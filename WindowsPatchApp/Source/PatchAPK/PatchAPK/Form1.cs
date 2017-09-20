using System;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Linq;

namespace PatchAPK
{
    public partial class Form1 : Form
    {

        public Form1()
        {
            InitializeComponent();
        }

        public string apk = "";
        public string toolsdir = "";
        public string patchdir = "";
        public string decompiledir = "";
        public string apkversion = "";
        public string outdir = "";
        public string modver = "";

        private bool IsValidPath(string path)
        {
            Regex driveCheck = new Regex(@"^[a-zA-Z]:\\$");
            if (!driveCheck.IsMatch(path.Substring(0, 3)))
            {
                return false;
            }

            string strTheseAreInvalidFileNameChars = new string(Path.GetInvalidPathChars());
            strTheseAreInvalidFileNameChars += @":/?*" + "\"";
            Regex containsABadCharacter = new Regex("[" + Regex.Escape(strTheseAreInvalidFileNameChars) + "]");
            
            if (containsABadCharacter.IsMatch(path.Substring(3, path.Length - 3)))
            {
                return false;
            }
            
            return true;
        }        

        private string getFileSize(String type, long val)
        {
            long b = val;
            float kb = b / 1024;
            float mb = kb / 1024;
            float gb = mb / 1024;

            switch (type)
            {
                case "kb":
                    return kb.ToString("n2") + " kB";
                case "mb":
                    return mb.ToString("n2") + " MB";
                case "gb":
                    return gb.ToString("n2") + " GB";
                default:
                    return b.ToString() + " Bytes";
            }
        }

        private void btnDecompile_Click(object sender, EventArgs e)
        {
            if (apk.Contains(".apk"))
            {
                Thread thread1 = new Thread(apktoolDecompile);
                thread1.Start();
            }
            else
            {
                MessageBox.Show("No apk file selected to decompile!");
            }

        }

        public void apktoolDecompile()
        {
            try
            {                
                Process proc = new Process();
                proc.StartInfo.FileName = "java";
                proc.StartInfo.Arguments = @"-jar " + toolsdir + "\\apktool.jar d -f -o " + decompiledir + " " + apk;
                proc.StartInfo.CreateNoWindow = true;
                proc.StartInfo.RedirectStandardOutput = true;
                proc.StartInfo.RedirectStandardError = true;
                proc.StartInfo.UseShellExecute = false;
                proc.OutputDataReceived += new DataReceivedEventHandler(OutputHandler);
                SetTextBoxText("<-------------- Begin Decompile to " + decompiledir + " -------------->\r\n");
                proc.Start();
                proc.BeginOutputReadLine();
                //proc.BeginErrorReadLine();
                proc.WaitForExit();
                proc.Close();
                SetTextBoxText("\r\n<-------------- Decompile Complete ----------->\r\n");               
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
        }

        public void apktoolRecompile()
        {
            try
            {                
                Process proc = new Process();
                proc.StartInfo.FileName = "java";
                proc.StartInfo.Arguments = @"-jar " + toolsdir + "\\apktool.jar b -o " + outdir + "\\mod.apk " + decompiledir; 
                proc.StartInfo.CreateNoWindow = true;
                proc.StartInfo.RedirectStandardOutput = true;
                proc.StartInfo.RedirectStandardError = true;
                proc.StartInfo.UseShellExecute = false;
                proc.OutputDataReceived += new DataReceivedEventHandler(OutputHandler);
                SetTextBoxText("<-------------- Begin Recompile -------------->\r\n");
                proc.Start();
                proc.BeginOutputReadLine();
                //proc.BeginErrorReadLine();
                proc.WaitForExit();
                proc.Close();
                SetTextBoxText("\r\n<-------------- Recompile Complete ----------->\r\n");

                Thread thread2 = new Thread(apkSignAndCleanup);
                thread2.Start();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
        }

        const int MAX_PATH = 255;

        [DllImport("kernel32.dll", CharSet = CharSet.Auto)]
        public static extern int GetShortPathName(
            [MarshalAs(UnmanagedType.LPTStr)]
         string path,
            [MarshalAs(UnmanagedType.LPTStr)]
         StringBuilder shortPath,
            int shortPathLength
            );

        private static string GetShortPath(string path)
        {
            var shortPath = new StringBuilder(MAX_PATH);
            GetShortPathName(path, shortPath, MAX_PATH);
            return shortPath.ToString();
        }

        public void apkSignAndCleanup()
        {
            try
            {
                Process proc = new Process();
                proc.StartInfo.FileName = "java";
                proc.StartInfo.Arguments = @"-jar " + toolsdir + "\\sign.jar b " + outdir + "\\mod.apk --override";
                proc.StartInfo.CreateNoWindow = true;
                proc.StartInfo.RedirectStandardOutput = true;
                proc.StartInfo.RedirectStandardError = true;
                proc.StartInfo.UseShellExecute = false;
                proc.OutputDataReceived += new DataReceivedEventHandler(OutputHandler);
                SetTextBoxText("<-------------- Begin Sign APK -------------->\r\n");
                proc.Start();
                proc.BeginOutputReadLine();
                //proc.BeginErrorReadLine();
                proc.WaitForExit();
                proc.Close();
                System.IO.File.Move(outdir+"\\mod.apk", outdir + "\\mod-" + modver + ".apk");
                SetTextBoxText("\r\n<-------------- Sign APK Complete ----------->\r\n");
                SetTextBoxText("<-------------- Begin Cleanup -------------->\r\n");
                Directory.Delete(decompiledir, true);
                SetTextBoxText("\r\n<-------------- Cleanup Complete ----------->\r\n");
                SetTextBoxText("You can find the apk here: " + outdir + "\\mod-" + modver + ".apk");
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
        }

        public void bsPatch()
        {
            try
            {                
                Process proc = new Process();
                proc.StartInfo.FileName = toolsdir + "\\bspatch.exe";
                proc.StartInfo.Arguments = decompiledir + "\\lib\\armeabi-v7a\\libSDKRelativeJNI.so " + decompiledir + "\\lib\\armeabi-v7a\\libSDKRelativeJNI.so " + patchdir + "\\so.bspatch";
                proc.StartInfo.CreateNoWindow = true;
                proc.StartInfo.RedirectStandardOutput = true;
                proc.StartInfo.RedirectStandardError = true;
                proc.StartInfo.UseShellExecute = false;
                proc.OutputDataReceived += new DataReceivedEventHandler(OutputHandler);
                SetTextBoxText("<-------------- Applying BSPATCH -------------->\r\n");
                proc.Start();
                proc.BeginOutputReadLine();
                //proc.BeginErrorReadLine();
                proc.WaitForExit();
                proc.Close();
                SetTextBoxText("\r\n<-------------- BSPATCH Complete ----------->\r\n");                
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
        }

        public void bsPatch2()
        {
            try
            {
                Process proc = new Process();
                proc.StartInfo.FileName = toolsdir + "\\bspatch.exe";
                proc.StartInfo.Arguments = decompiledir + "\\lib\\armeabi-v7a\\libFREncrypt.so " + decompiledir + "\\lib\\armeabi-v7a\\libFREncrypt.so " + patchdir + "\\so2.bspatch";
                proc.StartInfo.CreateNoWindow = true;
                proc.StartInfo.RedirectStandardOutput = true;
                proc.StartInfo.RedirectStandardError = true;
                proc.StartInfo.UseShellExecute = false;
                proc.OutputDataReceived += new DataReceivedEventHandler(OutputHandler);
                SetTextBoxText("<-------------- Applying BSPATCH -------------->\r\n");
                proc.Start();
                proc.BeginOutputReadLine();
                //proc.BeginErrorReadLine();
                proc.WaitForExit();
                proc.Close();
                SetTextBoxText("\r\n<-------------- BSPATCH Complete ----------->\r\n");
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
        }

        public void patch()
        {
            
            for (int i = 0; i < clbPatch.Items.Count; i++) 
            {
                 string itm = clbPatch.Items[i].ToString();
                 if(clbPatch.GetItemChecked(i))
                 {
                     try
                     {
                        if (itm == "removeOnlinefunction")
                        {
                            Thread thread3 = new Thread(bsPatch);
                            thread3.Start();
                        }
                        doPatch(itm);
                    }
                     catch (Exception ex)
                     {
                         MessageBox.Show(ex.ToString());
                     }
                 }

            }
            doPatch("origin");
            if (File.Exists(patchdir + "\\" + "so2.bspatch"))
            {
                bsPatch2();
            }
        }

        private void doPatch(string patchname)
        {
            string preArg = "";
            Process proc = new Process();
            proc.StartInfo.FileName = toolsdir + "\\patch.exe";
            proc.StartInfo.WorkingDirectory = decompiledir;
            string f = "";
            if (patchname == "origin")
            {
                f = patchdir + "\\" + patchname;
            } else
            {
                f = patchdir + "\\" + patchname + ".patch";
            }
            Unix2Dos(f);
            if (cbDryRun.Checked)
            {
                preArg = "--dry-run ";
            }
            proc.StartInfo.Arguments = preArg + "-l -p1 -N -i " + f;
            proc.StartInfo.CreateNoWindow = true;
            proc.StartInfo.RedirectStandardOutput = true;
            proc.StartInfo.RedirectStandardError = true;
            proc.StartInfo.UseShellExecute = false;
            proc.StartInfo.Verb = "runas";
            proc.OutputDataReceived += new DataReceivedEventHandler(OutputHandler);
            SetTextBoxText("<-------------- Begin Patch -------------->\r\n");
            SetTextBoxText("Applying Patch: " + patchname + "\r\n");
            //MessageBox.Show(f);
            proc.Start();
            proc.WaitForExit(30000);
            string result = proc.StandardOutput.ReadToEnd();
            string error = proc.StandardError.ReadToEnd();
            SetTextBoxText("\r\nResult: " + result);
            if (error != "" && error != null)
            {
                SetTextBoxText("\r\nError: " + error);
            }
            proc.Close();
            SetTextBoxText("\r\n<-------------- Patch Complete ----------->\r\n");
        }
        private void Unix2Dos(string fileName)
        {
            const byte CR = 0x0D;
            const byte LF = 0x0A;
            byte[] DOS_LINE_ENDING = new byte[] { CR, LF };
            byte[] data = File.ReadAllBytes(fileName);
            using (FileStream fileStream = File.OpenWrite(fileName))
            {
                BinaryWriter bw = new BinaryWriter(fileStream);
                int position = 0;
                int index = 0;
                do
                {
                    index = Array.IndexOf<byte>(data, LF, position);
                    if (index >= 0)
                    {
                        if ((index > 0) && (data[index - 1] == CR))
                        {
                            // already dos ending
                            bw.Write(data, position, index - position + 1);
                        }
                        else
                        {
                            bw.Write(data, position, index - position);
                            bw.Write(DOS_LINE_ENDING);
                        }
                        position = index + 1;
                    }
                }
                while (index > 0);
                bw.Write(data, position, data.Length - position);
                fileStream.SetLength(fileStream.Position);
            }
        }

        private void OutputHandler(object sendingProcess, DataReceivedEventArgs outLine)
        {
            if (outLine.Data != null)
            {
                SetTextBoxText(outLine.Data.ToString());
            }
            
        }

        private delegate void SetTextBoxTextInvoker(string text);
        private void SetTextBoxText(string text)
        {

            if (this.txtOutput.InvokeRequired)
            {
                this.txtOutput.Invoke(new SetTextBoxTextInvoker(SetTextBoxText), text);
            }
            else
            {
                this.txtOutput.AppendText(text + "\r\n");
            }
        }             

        private void SetVars()
        {            
            apk = Application.StartupPath + "\\PutApkHere";
            lblAPK.Text = "";
            toolsdir = Application.StartupPath + "\\tools";
            //patchdir = Application.StartupPath + "\\patches\\" + getAPKVersion();
            decompiledir = Application.StartupPath + "\\decompile_out";
            outdir = Application.StartupPath + "\\__MODDED_APK_OUT__";
            modver = getModVersion();
            System.IO.Directory.CreateDirectory(decompiledir);
            System.IO.Directory.CreateDirectory(outdir);
            SetTextBoxText("Patch version: " + modver);
        }      
  
        private void loadPatches()
        {
            clbPatch.Items.Clear();
            DirectoryInfo d = new DirectoryInfo(Application.StartupPath + "\\patches\\" + apkversion);
            FileInfo[] Files = d.GetFiles("*.patch");
            foreach (FileInfo file in Files)
            {
                clbPatch.Items.Add(file.Name.Replace(".patch", ""));
            }          
            
        }

        private string checkSupportedVersion(string apksize)
        {
            string result = "";
            var lines = File.ReadAllLines(Application.StartupPath + "\\patches\\versions.txt");
            foreach (var line in lines)
            {
                if (line.Contains(apksize))  {
                    string[] parts = line.Split(':');
                    result = parts[0];
                }
            }
            return result;
        }

        private string getModVersion()
        {
            string ver = "";
            ver = File.ReadLines(Application.StartupPath + "\\version.txt").First();
  
            return ver;
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            SetVars();           
        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            System.Windows.Forms.Application.Exit();
        }

        private void btnPatch_Click(object sender, EventArgs e)
        {
            if (clbPatch.SelectedItems.Count > 0)
            {
                patch();
            }
            else
            {
                MessageBox.Show("No patches selected!");
            }
        }

        private void btnRecompile_Click(object sender, EventArgs e)
        {
            if (apk.Contains(".apk"))
            {
                Thread thread1 = new Thread(apktoolRecompile);
                thread1.Start();
            }
            else
            {
                MessageBox.Show("No apk file selected to recompile!");
            }
            
        }

        private void cbDryRun_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void menuToolStripMenuItem_Click(object sender, EventArgs e)
        {

        }

        private void settingsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            FileDialog fd = new OpenFileDialog();
            fd.RestoreDirectory = true;
            DialogResult result = fd.ShowDialog(); // Show the dialog.
            if (result == DialogResult.OK) // Test result.
            {
                string file = fd.FileName;
                try
                {
                    apk = file;
                    lblAPK.Text = file;
                    var size = new FileInfo(file).Length;
                    string supportedVersion = checkSupportedVersion(size.ToString());
                    if (supportedVersion.Equals(""))
                    {
                        MessageBox.Show("APK Version not supported, please use an supported version, check the patches folder to see which versions are supported!");
                        apk = "";
                        lblAPK.Text = "";
                    } else
                    {
                        apkversion = supportedVersion;
                        patchdir = Application.StartupPath + "\\patches\\" + apkversion;
                        loadPatches();
                    }
                }
                catch (IOException ex)
                {
                    MessageBox.Show(ex.Message);
                }
            }
        }

        private void aboutToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Form frmA = new AboutBox1();
            frmA.ShowDialog();
        }
    }
}
