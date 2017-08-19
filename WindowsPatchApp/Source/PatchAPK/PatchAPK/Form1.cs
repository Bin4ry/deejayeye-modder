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
                proc.StartInfo.Arguments = @"-jar " + toolsdir + "\\apktool.jar b -o " + decompiledir + "\\dist\\mod.apk " + decompiledir; 
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

                Thread thread2 = new Thread(apkSign);
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

        public void apkSign()
        {
            try
            {
                Process proc = new Process();
                proc.StartInfo.FileName = "java";
                proc.StartInfo.Arguments = @"-jar " + toolsdir + "\\sign.jar b " + decompiledir + "\\dist\\mod.apk --override";
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
                SetTextBoxText("\r\n<-------------- Sign APK Complete ----------->\r\n");
                
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
                proc.StartInfo.FileName = toolsdir + "\\bspatch";
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

        public void patch()
        {
            
            for (int i = 0; i < clbPatch.Items.Count; i++) 
            {
                 string itm = clbPatch.Items[i].ToString();
                 if(clbPatch.GetItemChecked(i) && itm != "removeOnlinefunction")
                 {
                     try
                     {
                         string preArg = "";
                         Process proc = new Process();
                         proc.StartInfo.FileName = toolsdir + "\\patch.exe";
                         proc.StartInfo.WorkingDirectory = decompiledir;
                         string f = patchdir + "\\" + clbPatch.Items[i].ToString() + ".patch";
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
                         SetTextBoxText("Applying Patch: " + clbPatch.Items[i].ToString() + "\r\n");
                         //MessageBox.Show(f);
                         proc.Start();
                         proc.WaitForExit();
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
                     catch (Exception ex)
                     {
                         MessageBox.Show(ex.ToString());
                     }
                 }
                 else if (clbPatch.GetItemChecked(i) && itm == "removeOnlinefunction")
                 {
                     Thread thread3 = new Thread(bsPatch);
                     thread3.Start();
                 }

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
            System.IO.Directory.CreateDirectory(Application.StartupPath + "\\decompile");
            apk = Application.StartupPath + "\\SELECT APK";
            lblAPK.Text = "";
            toolsdir = Application.StartupPath + "\\tools";
            patchdir = Application.StartupPath + "\\patches\\" + getAPKVersion();
            decompiledir = Application.StartupPath + "\\decompile";

        }      
  
        private string getAPKVersion()
        {
            string version = "";
            if (toolStripMenuItem3.Checked)
            {
                version = "4.1.4";
            }
            else
            {
                version = "4.1.3";
            }
            return version;
        }

       

        private void loadPatches()
        {
            clbPatch.Items.Clear();
            DirectoryInfo d = new DirectoryInfo(Application.StartupPath + "\\patches\\" + getAPKVersion());
            FileInfo[] Files = d.GetFiles("*.patch");
            foreach (FileInfo file in Files)
            {
                clbPatch.Items.Add(file.Name.Replace(".patch", ""));
            }          
            
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            SetVars();           
            loadPatches();
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

        private void toolStripMenuItem2_Click(object sender, EventArgs e)
        {
            if (toolStripMenuItem3.Checked)
            {
                toolStripMenuItem3.Checked = false;
            }
            else
            {
                toolStripMenuItem2.Checked = true;
            }
            loadPatches();
        }

        private void toolStripMenuItem3_Click(object sender, EventArgs e)
        {
            if (toolStripMenuItem2.Checked)
            {
                toolStripMenuItem2.Checked = false;
            }
            else
            {
                toolStripMenuItem3.Checked = true;
            }
            loadPatches();
        }
    }
}
