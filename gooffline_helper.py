#!/usr/bin/python3
"""
Offline & partialOffline patch helper

https://github.com/Bin4ry/deejayeye-modder
DON'T BE A DICK PUBLIC LICENSE

ideas and issues to @lenisko
"""

import re
import os
import sys
import glob
import base64
import argparse
import binascii

# EDIT FROM HERE -- if needed

# patching will skip those strings if found in both full and partial patches
overall_whitelist = [
    'schemas.android.com',
    'localhost',
    '10.10.',
    '192.168.',
    '127.0.0.1'
]

# partial patch ignore list, if any of those strings is found in un-fogged string, fog is not touched
partial_whitelist = [
    '.here.com',
    'maps.google.com',
    'mapbox.com',
    'amap.com'
]

# match all strings starting with those variables as URLs
start_string_match = ('http', 'ftp')

# EDIT ENDS HERE


def show_message(message, error=False, end=False):
    print(message)
    if error:
        sys.exit(1)
    elif end:
        sys.exit(0)


class PatchHelper:
    def __init__(self, type_of_key, patch_type, mod_dir, yes):
        # Keys
        self.keys = {
            'key_414': ("I Love Android", 7),
            'key_415': ("Y9*PI8B#gD^6Yhd1", 8)
        }

        # Save init variables
        self.key = self.keys[type_of_key]
        self.patch_type = patch_type
        self.mod_dir = os.path.join(os.getcwd(), mod_dir)
        self.yes = yes

        # Fogged and un-fogged http://127.0.0.1 string
        self.localhost_fog = "MV49Ml1xdlVrHWdySW53VQ=="
        self.localhost_not_fog = "http://127.0.0.1"

        """
        Matching strings section eg:
            const-string v1, "MFkMNAIwLQ=="

        Returns:
            Group `name` => `v1`
            Group `fog` => `MFkMNAIwLQ==`
        """
        self.fog_match = re.compile('const-string\s(?P<name>\w+),\s\"(?P<fog>[\w+/=]+=)\"')

        """
        Matching strings section eg:
            const-string v0, "https://i.imgur.com/FCID59G.jpg"

        Returns:
            Group `name` => `v0`
            Group `url` => `https://i.imgur.com/FCID59G.jpg`
        """
        self.not_fog_match = re.compile('const-string\s(?P<name>\w+),\s\"(?P<url>.*)\"')

        """
        I'll implement this someday...
        Matching whole section eg:
            const-string v1, "MFkMNAIwLQ=="

            invoke-static {v1}, Lcom/dji/f/a/a/b;->a(Ljava/lang/String;)Ljava/lang/String;

            move-result-object v1

        Returns:
            Group `name` => `v1`
            Group `fog` => `MFkMNAIwLQ==`
        """
        self.full_fog_match = re.compile((
            'const-string\s(?P<name>\w+),\s\"(?P<fog>[\w+/=]+)\"(?:\n\s*)+invoke-static\s{\w+},'
            '\sLcom/dji/f/a/a/b;->a.+(?:\n\s*)+move-result-object.+'
        ))

    def pre_check(self):
        print('Offline & partialOffline patch helper\n')

        if not os.path.exists(self.mod_dir):
            show_message('Incorrect mod path', error=True)

        print('Working directory: {}'.format(self.mod_dir))
        print('Patch type: {}'.format(self.patch_type))
        print('Key to use: {}'.format(self.key[0]))
        print('Dry run: {}\n'.format('Yes' if not self.yes else 'No'))

        if not self.yes:
            show_message('Job didn\'t started. There\'s no --yes flag', end=True)

    def replace_content(self):
        print('Job started. This might take a while...\n')

        smali_iterator = self.iterate_dir(self.mod_dir)

        print('List of whitelisted matches:')
        for file_path in smali_iterator:
            self.replace_file_content(file_path)

        print('Done! :-)\n')
        print('Now run diff on orig/ and mod/ directories:')
        print('$ diff -Naru orig/ mod/ > {}.patch'.format(
            'goOfflinePartial' if self.patch_type == 'partial_patch' else 'goOffline')
        )

    @staticmethod
    def iterate_dir(dir_path):
        os.chdir(dir_path)
        for file_path in glob.iglob('**/*.smali', recursive=True):
            yield os.path.join(dir_path, file_path)

    def defog(self, s):
        # a bit~ modded version from work by nopcode, miek and bin4ry
        key, l = self.key
        s = base64.decodestring(s)
        decr = ''.join([chr(ord(c) ^ ord(key[i % l * 2])) for i, c in enumerate(s.decode('ascii'))])
        decr = decr.replace('\r', '').replace('\n', '').replace('"', '').replace('\\', '')
        return decr

    def content_whitelisted(self, defogged_content):
        if any([row in defogged_content for row in overall_whitelist]):
            print('- ' + defogged_content)
            return True

        if self.patch_type == 'partial_patch':
            if any([row in defogged_content for row in partial_whitelist]):
                print('- ' + defogged_content)
                return True
        
        return False

    def parse_matched(self, match_tuple, fog):
        variable_name, content = match_tuple
        return self.fog_check(variable_name, content) if fog else self.not_fog_check(variable_name, content)


    def fog_check(self, variable_name, content):
        try:
            defogged_content = self.defog(content.encode('ascii'))
            if defogged_content.startswith(start_string_match):
                if self.content_whitelisted(defogged_content):
                    return 'const-string {}, "{}"'.format(variable_name, content)
                return 'const-string {}, "{}"'.format(variable_name, self.localhost_fog)
            return 'const-string {}, "{}"'.format(variable_name, content)
        except (UnicodeDecodeError, binascii.Error):
            return 'const-string {}, "{}"'.format(variable_name, content)

    def not_fog_check(self, variable_name, content):
        if content.startswith(start_string_match):
            if self.content_whitelisted(content):
                return 'const-string {}, "{}"'.format(variable_name, content)
            return 'const-string {}, "{}"'.format(variable_name, self.localhost_not_fog)
        return 'const-string {}, "{}"'.format(variable_name, content)

    def replace_file_content(self, file_path):
        with open(file_path, 'r') as f:
            content = f.read()

        content = re.sub(self.fog_match, lambda m: self.parse_matched(m.groups(), fog=True), content)
        content = re.sub(self.not_fog_match, lambda m: self.parse_matched(m.groups(), fog=False), content)

        with open(file_path, 'w') as f:
            f.write(content)


if __name__ == "__main__":
    if not sys.version_info >= (3, 5):
        show_message('Please use at least Python 3.5 to run this script.', error=True)

    parser = argparse.ArgumentParser(description='Offline & partialOffline patch helper')
    parser.add_argument('path', help='mod directory location')
    parser.add_argument('-t', '--type', choices=['partial_patch', 'full_patch'], default='partial_patch',
                        help='type of work on mod directory')
    parser.add_argument('-k', '--key', choices=['key_414', 'key_415'], default='key_415', help='key to use')
    parser.add_argument('-y', '--yes', action='store_true',
                        help='write changes to all smali files under provided mod directory')
    args = parser.parse_args()

    work = PatchHelper(args.key, args.type, args.path, args.yes)
    work.pre_check()
    work.replace_content()
