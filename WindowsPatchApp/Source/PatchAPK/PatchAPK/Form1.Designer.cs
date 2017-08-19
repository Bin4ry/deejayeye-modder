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
            this.aPKVersionToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem2 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem3 = new System.Windows.Forms.ToolStripMenuItem();
            this.aboutToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.lblAPK = new System.Windows.Forms.Label();
            this.menuStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // btnDecompile
            // 
            this.btnDecompile.Location = new System.Drawing.Point(12, 399);
            this.btnDecompile.Name = "btnDecompile";
            this.btnDecompile.Size = new System.Drawing.Size(142, 40);
            this.btnDecompile.TabIndex = 2;
            this.btnDecompile.Text = "Decompile";
            this.btnDecompile.UseVisualStyleBackColor = true;
            this.btnDecompile.Click += new System.EventHandler(this.btnDecompile_Click);
            // 
            // txtOutput
            // 
            this.txtOutput.BackColor = System.Drawing.SystemColors.Control;
            this.txtOutput.ForeColor = System.Drawing.SystemColors.ControlText;
            this.txtOutput.Location = new System.Drawing.Point(551, 51);
            this.txtOutput.Multiline = true;
            this.txtOutput.Name = "txtOutput";
            this.txtOutput.ReadOnly = true;
            this.txtOutput.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.txtOutput.Size = new System.Drawing.Size(932, 689);
            this.txtOutput.TabIndex = 3;
            // 
            // clbPatch
            // 
            this.clbPatch.CheckOnClick = true;
            this.clbPatch.FormattingEnabled = true;
            this.clbPatch.Location = new System.Drawing.Point(12, 51);
            this.clbPatch.Name = "clbPatch";
            this.clbPatch.Size = new System.Drawing.Size(533, 342);
            this.clbPatch.TabIndex = 12;
            // 
            // btnPatch
            // 
            this.btnPatch.Location = new System.Drawing.Point(160, 399);
            this.btnPatch.Name = "btnPatch";
            this.btnPatch.Size = new System.Drawing.Size(142, 40);
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
            this.btnRecompile.Location = new System.Drawing.Point(12, 445);
            this.btnRecompile.Name = "btnRecompile";
            this.btnRecompile.Size = new System.Drawing.Size(290, 40);
            this.btnRecompile.TabIndex = 14;
            this.btnRecompile.Text = "Build and Sign";
            this.btnRecompile.UseVisualStyleBackColor = true;
            this.btnRecompile.Click += new System.EventHandler(this.btnRecompile_Click);
            // 
            // cbDryRun
            // 
            this.cbDryRun.AutoSize = true;
            this.cbDryRun.Location = new System.Drawing.Point(308, 406);
            this.cbDryRun.Name = "cbDryRun";
            this.cbDryRun.Size = new System.Drawing.Size(116, 29);
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
            this.menuStrip1.Size = new System.Drawing.Size(1498, 40);
            this.menuStrip1.TabIndex = 19;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // menuToolStripMenuItem
            // 
            this.menuToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.settingsToolStripMenuItem,
            this.aPKVersionToolStripMenuItem});
            this.menuToolStripMenuItem.Name = "menuToolStripMenuItem";
            this.menuToolStripMenuItem.Size = new System.Drawing.Size(64, 36);
            this.menuToolStripMenuItem.Text = "File";
            this.menuToolStripMenuItem.Click += new System.EventHandler(this.menuToolStripMenuItem_Click);
            // 
            // settingsToolStripMenuItem
            // 
            this.settingsToolStripMenuItem.Name = "settingsToolStripMenuItem";
            this.settingsToolStripMenuItem.Size = new System.Drawing.Size(269, 38);
            this.settingsToolStripMenuItem.Text = "Select APK";
            this.settingsToolStripMenuItem.Click += new System.EventHandler(this.settingsToolStripMenuItem_Click);
            // 
            // aPKVersionToolStripMenuItem
            // 
            this.aPKVersionToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripMenuItem2,
            this.toolStripMenuItem3});
            this.aPKVersionToolStripMenuItem.Name = "aPKVersionToolStripMenuItem";
            this.aPKVersionToolStripMenuItem.Size = new System.Drawing.Size(269, 38);
            this.aPKVersionToolStripMenuItem.Text = "APK Version";
            // 
            // toolStripMenuItem2
            // 
            this.toolStripMenuItem2.Checked = true;
            this.toolStripMenuItem2.CheckOnClick = true;
            this.toolStripMenuItem2.CheckState = System.Windows.Forms.CheckState.Checked;
            this.toolStripMenuItem2.ImageScaling = System.Windows.Forms.ToolStripItemImageScaling.None;
            this.toolStripMenuItem2.Name = "toolStripMenuItem2";
            this.toolStripMenuItem2.Size = new System.Drawing.Size(164, 38);
            this.toolStripMenuItem2.Text = "4.1.3";
            this.toolStripMenuItem2.TextImageRelation = System.Windows.Forms.TextImageRelation.TextBeforeImage;
            this.toolStripMenuItem2.Click += new System.EventHandler(this.toolStripMenuItem2_Click);
            // 
            // toolStripMenuItem3
            // 
            this.toolStripMenuItem3.CheckOnClick = true;
            this.toolStripMenuItem3.ImageScaling = System.Windows.Forms.ToolStripItemImageScaling.None;
            this.toolStripMenuItem3.Name = "toolStripMenuItem3";
            this.toolStripMenuItem3.Size = new System.Drawing.Size(164, 38);
            this.toolStripMenuItem3.Text = "4.1.4";
            this.toolStripMenuItem3.TextImageRelation = System.Windows.Forms.TextImageRelation.TextBeforeImage;
            this.toolStripMenuItem3.Click += new System.EventHandler(this.toolStripMenuItem3_Click);
            // 
            // aboutToolStripMenuItem
            // 
            this.aboutToolStripMenuItem.Name = "aboutToolStripMenuItem";
            this.aboutToolStripMenuItem.Size = new System.Drawing.Size(92, 36);
            this.aboutToolStripMenuItem.Text = "About";
            this.aboutToolStripMenuItem.Click += new System.EventHandler(this.aboutToolStripMenuItem_Click);
            // 
            // lblAPK
            // 
            this.lblAPK.AutoSize = true;
            this.lblAPK.Location = new System.Drawing.Point(12, 714);
            this.lblAPK.Name = "lblAPK";
            this.lblAPK.Size = new System.Drawing.Size(70, 25);
            this.lblAPK.TabIndex = 20;
            this.lblAPK.Text = "label1";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(12F, 25F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1498, 752);
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
        private System.Windows.Forms.ToolStripMenuItem aPKVersionToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem2;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem3;
        private System.Windows.Forms.ToolStripMenuItem aboutToolStripMenuItem;
        private System.Windows.Forms.Label lblAPK;
    }
}

