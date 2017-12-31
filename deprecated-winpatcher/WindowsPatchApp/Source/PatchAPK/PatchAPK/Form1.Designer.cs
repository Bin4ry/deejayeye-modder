namespace PatchAPK
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.btnDecompile = new System.Windows.Forms.Button();
            this.txtOutput = new System.Windows.Forms.TextBox();
            this.clbPatch = new System.Windows.Forms.CheckedListBox();
            this.btnPatch = new System.Windows.Forms.Button();
            this.btnRecompile = new System.Windows.Forms.Button();
            this.cbDryRun = new System.Windows.Forms.CheckBox();
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.menuToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.settingsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.aboutToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.lblAPK = new System.Windows.Forms.Label();
            this.menuStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // btnDecompile
            // 
            this.btnDecompile.Location = new System.Drawing.Point(6, 207);
            this.btnDecompile.Margin = new System.Windows.Forms.Padding(2);
            this.btnDecompile.Name = "btnDecompile";
            this.btnDecompile.Size = new System.Drawing.Size(71, 21);
            this.btnDecompile.TabIndex = 2;
            this.btnDecompile.Text = "Decompile";
            this.btnDecompile.UseVisualStyleBackColor = true;
            this.btnDecompile.Click += new System.EventHandler(this.btnDecompile_Click);
            // 
            // txtOutput
            // 
            this.txtOutput.BackColor = System.Drawing.SystemColors.Control;
            this.txtOutput.ForeColor = System.Drawing.SystemColors.ControlText;
            this.txtOutput.Location = new System.Drawing.Point(276, 27);
            this.txtOutput.Margin = new System.Windows.Forms.Padding(2);
            this.txtOutput.Multiline = true;
            this.txtOutput.Name = "txtOutput";
            this.txtOutput.ReadOnly = true;
            this.txtOutput.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.txtOutput.Size = new System.Drawing.Size(468, 360);
            this.txtOutput.TabIndex = 3;
            // 
            // clbPatch
            // 
            this.clbPatch.CheckOnClick = true;
            this.clbPatch.FormattingEnabled = true;
            this.clbPatch.Location = new System.Drawing.Point(6, 27);
            this.clbPatch.Margin = new System.Windows.Forms.Padding(2);
            this.clbPatch.Name = "clbPatch";
            this.clbPatch.Size = new System.Drawing.Size(268, 169);
            this.clbPatch.TabIndex = 12;
            // 
            // btnPatch
            // 
            this.btnPatch.Location = new System.Drawing.Point(80, 207);
            this.btnPatch.Margin = new System.Windows.Forms.Padding(2);
            this.btnPatch.Name = "btnPatch";
            this.btnPatch.Size = new System.Drawing.Size(71, 21);
            this.btnPatch.TabIndex = 13;
            this.btnPatch.Text = "Patch";
            this.btnPatch.UseVisualStyleBackColor = true;
            this.btnPatch.Click += new System.EventHandler(this.btnPatch_Click);
            // 
            // btnRecompile
            // 
            this.btnRecompile.BackColor = System.Drawing.SystemColors.Control;
            this.btnRecompile.Font = new System.Drawing.Font("Microsoft Sans Serif", 7.875F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnRecompile.ForeColor = System.Drawing.SystemColors.ControlText;
            this.btnRecompile.Location = new System.Drawing.Point(6, 231);
            this.btnRecompile.Margin = new System.Windows.Forms.Padding(2);
            this.btnRecompile.Name = "btnRecompile";
            this.btnRecompile.Size = new System.Drawing.Size(145, 21);
            this.btnRecompile.TabIndex = 14;
            this.btnRecompile.Text = "Build and Sign";
            this.btnRecompile.UseVisualStyleBackColor = true;
            this.btnRecompile.Click += new System.EventHandler(this.btnRecompile_Click);
            // 
            // cbDryRun
            // 
            this.cbDryRun.AutoSize = true;
            this.cbDryRun.Location = new System.Drawing.Point(154, 211);
            this.cbDryRun.Margin = new System.Windows.Forms.Padding(2);
            this.cbDryRun.Name = "cbDryRun";
            this.cbDryRun.Size = new System.Drawing.Size(65, 17);
            this.cbDryRun.TabIndex = 15;
            this.cbDryRun.Text = "Dry Run";
            this.cbDryRun.UseVisualStyleBackColor = true;
            this.cbDryRun.CheckedChanged += new System.EventHandler(this.cbDryRun_CheckedChanged);
            // 
            // menuStrip1
            // 
            this.menuStrip1.ImageScalingSize = new System.Drawing.Size(32, 32);
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.menuToolStripMenuItem,
            this.aboutToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Padding = new System.Windows.Forms.Padding(3, 1, 0, 1);
            this.menuStrip1.Size = new System.Drawing.Size(749, 24);
            this.menuStrip1.TabIndex = 19;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // menuToolStripMenuItem
            // 
            this.menuToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.settingsToolStripMenuItem});
            this.menuToolStripMenuItem.Name = "menuToolStripMenuItem";
            this.menuToolStripMenuItem.Size = new System.Drawing.Size(37, 22);
            this.menuToolStripMenuItem.Text = "File";
            this.menuToolStripMenuItem.Click += new System.EventHandler(this.menuToolStripMenuItem_Click);
            // 
            // settingsToolStripMenuItem
            // 
            this.settingsToolStripMenuItem.Name = "settingsToolStripMenuItem";
            this.settingsToolStripMenuItem.Size = new System.Drawing.Size(152, 22);
            this.settingsToolStripMenuItem.Text = "Select APK";
            this.settingsToolStripMenuItem.Click += new System.EventHandler(this.settingsToolStripMenuItem_Click);
            // 
            // aboutToolStripMenuItem
            // 
            this.aboutToolStripMenuItem.Name = "aboutToolStripMenuItem";
            this.aboutToolStripMenuItem.Size = new System.Drawing.Size(52, 22);
            this.aboutToolStripMenuItem.Text = "About";
            this.aboutToolStripMenuItem.Click += new System.EventHandler(this.aboutToolStripMenuItem_Click);
            // 
            // lblAPK
            // 
            this.lblAPK.AutoSize = true;
            this.lblAPK.Location = new System.Drawing.Point(6, 371);
            this.lblAPK.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.lblAPK.Name = "lblAPK";
            this.lblAPK.Size = new System.Drawing.Size(35, 13);
            this.lblAPK.TabIndex = 20;
            this.lblAPK.Text = "label1";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(749, 391);
            this.Controls.Add(this.lblAPK);
            this.Controls.Add(this.cbDryRun);
            this.Controls.Add(this.btnRecompile);
            this.Controls.Add(this.btnPatch);
            this.Controls.Add(this.clbPatch);
            this.Controls.Add(this.txtOutput);
            this.Controls.Add(this.btnDecompile);
            this.Controls.Add(this.menuStrip1);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MainMenuStrip = this.menuStrip1;
            this.Margin = new System.Windows.Forms.Padding(2);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "Form1";
            this.Text = "WinAPK Patcher - DJayEyeBalls";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnDecompile;
        private System.Windows.Forms.TextBox txtOutput;
        private System.Windows.Forms.CheckedListBox clbPatch;
        private System.Windows.Forms.Button btnPatch;
        private System.Windows.Forms.Button btnRecompile;
        private System.Windows.Forms.CheckBox cbDryRun;
        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem menuToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem settingsToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem aboutToolStripMenuItem;
        private System.Windows.Forms.Label lblAPK;
    }
}

