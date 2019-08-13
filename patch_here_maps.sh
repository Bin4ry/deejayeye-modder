if [ $(uname) = "Linux" ]
then
    SYSTEMTYPE=LINUX
    SED_CMD=sed
else
    SYSTEMTYPE=OSX
    OLD_LC_CTYPE=$LC_CTYPE
    # fix because OSX "tr" does not work on arbitrary chars without that environment variable set
    export LC_CTYPE=C
    SED_CMD=gsed
fi

license_key="ksGaXJocG/BTWhzEABabe5sDvrY1eyYWXtdr8E6LVOTj6Qv7LzloLC87OnG0j20NRhWjVtwDkBBkh0rwVI80ae04WU8vy+OwUjlXydS1JfJec/2pbjSc7FyuVw4NABiJ0NJZqqo30NZAHwsHo3df6TeQlMYiqBxC0SmJnMWiuelPB7NGWfd4mf3zF/vVsFy+DL0lEpvwuYO0QwTRYZ4mBwp1/ypwU5wC/U8X6KO0WW28B7oO1FMW/7RpAZ7gJGPbLZX9dq0MhMvqlgUvTyh+XBdyDDvBuEQ0m2bO2WmS0eeXnSm7LwP28XpBKo3NClLQPrkSMGkONdDiYfRlWcnIHbCXtBHISCePhUnk7zIKi4hRh0TMnGJf6M713L25as2O4ERZ1xcM3vucK1tURcnVZNv2gHkhGxKAK1sCjnF0Aeb2wtu56JJ2IIrLOc89la9yA7QfNO30znnzajkeUnGyJ36sBH7sMe+BbPA3oxNE2jXU6ZKqsJrcUDK7oKK445hhQJzJC15gb6ezWqUgWBFhj+Z4u77naCP9AAiOw7AY3QmBHEbia22KMfXutqMUxDKORDuAxJI2SeCp0P+qamiK0aY1MlJZKVK/87oeSNkOYTGs6tnuOoZJ0MbhYgAlzrw1thkexTLSPWrxGF6mqUW/X9gMwM7Fzt2FSM+j/nzoG6A="
echo "Patching HERE Maps with provided variables..."
$SED_CMD -i "s/TU3wfM3272o2BkJrcO2c/$1/g" AndroidManifest.xml
$SED_CMD -i "s/VCUv-uumVMheXJAMr7I-rA/$2/g" AndroidManifest.xml
$SED_CMD -i -e "s@$license_key@$3@g" AndroidManifest.xml
