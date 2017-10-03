namespace AINGFv2_PC_PROG
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
            this.components = new System.ComponentModel.Container();
            this.button2 = new System.Windows.Forms.Button();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.button3 = new System.Windows.Forms.Button();
            this.tt = new System.Windows.Forms.TextBox();
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.button4 = new System.Windows.Forms.Button();
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.restartToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.reconnectToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.saveToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.runTimedAquiringToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.iNCToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.dECFRMRATEToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.enableToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.instructionsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.aquireAndSendAFrameToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.sCCBToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSeparator2 = new System.Windows.Forms.ToolStripSeparator();
            this.resetsemiToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.resetdeepToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.vendorRequestsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.vR3LEDToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.vRFLUSHToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.i3CToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.groupresetcontrolToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.semiToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.deepToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.groupaquireToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.aquireAndSendToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.sCCBCommitToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.groupsccbmonoToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.groupsccbburstToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.groupsccbburstRToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.editSCCBBuffToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.checkBox1 = new System.Windows.Forms.CheckBox();
            this.button5 = new System.Windows.Forms.Button();
            this.textBox_w = new System.Windows.Forms.TextBox();
            this.textBox_h = new System.Windows.Forms.TextBox();
            this.timer2 = new System.Windows.Forms.Timer(this.components);
            this.saveFileDialog1 = new System.Windows.Forms.SaveFileDialog();
            this.log = new System.Windows.Forms.ListBox();
            this.statusStrip1 = new System.Windows.Forms.StatusStrip();
            this.toolStripStatusLabel1 = new System.Windows.Forms.ToolStripStatusLabel();
            this.toolStripStatusLabel2 = new System.Windows.Forms.ToolStripStatusLabel();
            this.toolStripStatusLabel_FPS = new System.Windows.Forms.ToolStripStatusLabel();
            this.timer3 = new System.Windows.Forms.Timer(this.components);
            this.timer_fps_real = new System.Windows.Forms.Timer(this.components);
            this.button6 = new System.Windows.Forms.Button();
            this.button7 = new System.Windows.Forms.Button();
            this.button8 = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.menuStrip1.SuspendLayout();
            this.statusStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // button2
            // 
            this.button2.Location = new System.Drawing.Point(12, 27);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(75, 23);
            this.button2.TabIndex = 0;
            this.button2.Text = "Aquire Data";
            this.button2.UseVisualStyleBackColor = true;
            this.button2.Click += new System.EventHandler(this.button2_Click);
            // 
            // pictureBox1
            // 
            this.pictureBox1.Location = new System.Drawing.Point(93, 27);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(100, 50);
            this.pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.AutoSize;
            this.pictureBox1.TabIndex = 1;
            this.pictureBox1.TabStop = false;
            // 
            // button3
            // 
            this.button3.Location = new System.Drawing.Point(12, 57);
            this.button3.Name = "button3";
            this.button3.Size = new System.Drawing.Size(75, 23);
            this.button3.TabIndex = 2;
            this.button3.Text = "View Frame";
            this.button3.UseVisualStyleBackColor = true;
            this.button3.Click += new System.EventHandler(this.button3_Click);
            // 
            // tt
            // 
            this.tt.Location = new System.Drawing.Point(12, 86);
            this.tt.Name = "tt";
            this.tt.Size = new System.Drawing.Size(29, 20);
            this.tt.TabIndex = 3;
            this.tt.Text = "0";
            // 
            // timer1
            // 
            this.timer1.Tick += new System.EventHandler(this.timer1_Tick);
            // 
            // button4
            // 
            this.button4.Location = new System.Drawing.Point(13, 113);
            this.button4.Name = "button4";
            this.button4.Size = new System.Drawing.Size(75, 39);
            this.button4.TabIndex = 4;
            this.button4.Text = "Prepare Again";
            this.button4.UseVisualStyleBackColor = true;
            this.button4.Visible = false;
            this.button4.Click += new System.EventHandler(this.button4_Click);
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.restartToolStripMenuItem,
            this.reconnectToolStripMenuItem,
            this.saveToolStripMenuItem,
            this.runTimedAquiringToolStripMenuItem,
            this.instructionsToolStripMenuItem,
            this.vendorRequestsToolStripMenuItem,
            this.i3CToolStripMenuItem,
            this.editSCCBBuffToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(958, 24);
            this.menuStrip1.TabIndex = 5;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // restartToolStripMenuItem
            // 
            this.restartToolStripMenuItem.BackColor = System.Drawing.Color.Red;
            this.restartToolStripMenuItem.Name = "restartToolStripMenuItem";
            this.restartToolStripMenuItem.Size = new System.Drawing.Size(55, 20);
            this.restartToolStripMenuItem.Text = "Restart";
            this.restartToolStripMenuItem.Click += new System.EventHandler(this.restartToolStripMenuItem_Click);
            // 
            // reconnectToolStripMenuItem
            // 
            this.reconnectToolStripMenuItem.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(128)))), ((int)(((byte)(128)))));
            this.reconnectToolStripMenuItem.Name = "reconnectToolStripMenuItem";
            this.reconnectToolStripMenuItem.Size = new System.Drawing.Size(75, 20);
            this.reconnectToolStripMenuItem.Text = "Reconnect";
            this.reconnectToolStripMenuItem.Click += new System.EventHandler(this.reconnectToolStripMenuItem_Click);
            // 
            // saveToolStripMenuItem
            // 
            this.saveToolStripMenuItem.Name = "saveToolStripMenuItem";
            this.saveToolStripMenuItem.Size = new System.Drawing.Size(42, 20);
            this.saveToolStripMenuItem.Text = "save";
            this.saveToolStripMenuItem.Click += new System.EventHandler(this.saveToolStripMenuItem_Click);
            // 
            // runTimedAquiringToolStripMenuItem
            // 
            this.runTimedAquiringToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.iNCToolStripMenuItem,
            this.dECFRMRATEToolStripMenuItem,
            this.enableToolStripMenuItem});
            this.runTimedAquiringToolStripMenuItem.Name = "runTimedAquiringToolStripMenuItem";
            this.runTimedAquiringToolStripMenuItem.Size = new System.Drawing.Size(118, 20);
            this.runTimedAquiringToolStripMenuItem.Text = "run timed aquiring";
            this.runTimedAquiringToolStripMenuItem.Click += new System.EventHandler(this.runTimedAquiringToolStripMenuItem_Click);
            // 
            // iNCToolStripMenuItem
            // 
            this.iNCToolStripMenuItem.Name = "iNCToolStripMenuItem";
            this.iNCToolStripMenuItem.ShortcutKeys = System.Windows.Forms.Keys.F11;
            this.iNCToolStripMenuItem.Size = new System.Drawing.Size(179, 22);
            this.iNCToolStripMenuItem.Text = "INC";
            this.iNCToolStripMenuItem.Click += new System.EventHandler(this.iNCToolStripMenuItem_Click);
            // 
            // dECFRMRATEToolStripMenuItem
            // 
            this.dECFRMRATEToolStripMenuItem.Name = "dECFRMRATEToolStripMenuItem";
            this.dECFRMRATEToolStripMenuItem.ShortcutKeys = System.Windows.Forms.Keys.F12;
            this.dECFRMRATEToolStripMenuItem.Size = new System.Drawing.Size(179, 22);
            this.dECFRMRATEToolStripMenuItem.Text = "DEC FRM RATE";
            this.dECFRMRATEToolStripMenuItem.Click += new System.EventHandler(this.dECFRMRATEToolStripMenuItem_Click);
            // 
            // enableToolStripMenuItem
            // 
            this.enableToolStripMenuItem.Name = "enableToolStripMenuItem";
            this.enableToolStripMenuItem.ShortcutKeys = System.Windows.Forms.Keys.F5;
            this.enableToolStripMenuItem.Size = new System.Drawing.Size(179, 22);
            this.enableToolStripMenuItem.Text = "Enable";
            this.enableToolStripMenuItem.Click += new System.EventHandler(this.enableToolStripMenuItem_Click);
            // 
            // instructionsToolStripMenuItem
            // 
            this.instructionsToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.aquireAndSendAFrameToolStripMenuItem,
            this.toolStripSeparator1,
            this.sCCBToolStripMenuItem,
            this.toolStripSeparator2,
            this.resetsemiToolStripMenuItem,
            this.resetdeepToolStripMenuItem});
            this.instructionsToolStripMenuItem.Name = "instructionsToolStripMenuItem";
            this.instructionsToolStripMenuItem.Size = new System.Drawing.Size(81, 20);
            this.instructionsToolStripMenuItem.Text = "Instructions";
            this.instructionsToolStripMenuItem.Visible = false;
            // 
            // aquireAndSendAFrameToolStripMenuItem
            // 
            this.aquireAndSendAFrameToolStripMenuItem.Name = "aquireAndSendAFrameToolStripMenuItem";
            this.aquireAndSendAFrameToolStripMenuItem.ShortcutKeys = System.Windows.Forms.Keys.F5;
            this.aquireAndSendAFrameToolStripMenuItem.Size = new System.Drawing.Size(223, 22);
            this.aquireAndSendAFrameToolStripMenuItem.Text = "Aquire and Send a frame";
            this.aquireAndSendAFrameToolStripMenuItem.Click += new System.EventHandler(this.aquireAndSendAFrameToolStripMenuItem_Click);
            // 
            // toolStripSeparator1
            // 
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new System.Drawing.Size(220, 6);
            // 
            // sCCBToolStripMenuItem
            // 
            this.sCCBToolStripMenuItem.Name = "sCCBToolStripMenuItem";
            this.sCCBToolStripMenuItem.ShortcutKeys = System.Windows.Forms.Keys.F1;
            this.sCCBToolStripMenuItem.Size = new System.Drawing.Size(223, 22);
            this.sCCBToolStripMenuItem.Text = "SCCB";
            // 
            // toolStripSeparator2
            // 
            this.toolStripSeparator2.Name = "toolStripSeparator2";
            this.toolStripSeparator2.Size = new System.Drawing.Size(220, 6);
            // 
            // resetsemiToolStripMenuItem
            // 
            this.resetsemiToolStripMenuItem.Name = "resetsemiToolStripMenuItem";
            this.resetsemiToolStripMenuItem.ShortcutKeys = System.Windows.Forms.Keys.F2;
            this.resetsemiToolStripMenuItem.Size = new System.Drawing.Size(223, 22);
            this.resetsemiToolStripMenuItem.Text = "Reset-semi";
            this.resetsemiToolStripMenuItem.Click += new System.EventHandler(this.resetsemiToolStripMenuItem_Click);
            // 
            // resetdeepToolStripMenuItem
            // 
            this.resetdeepToolStripMenuItem.Name = "resetdeepToolStripMenuItem";
            this.resetdeepToolStripMenuItem.ShortcutKeys = System.Windows.Forms.Keys.F3;
            this.resetdeepToolStripMenuItem.Size = new System.Drawing.Size(223, 22);
            this.resetdeepToolStripMenuItem.Text = "Reset-deep";
            this.resetdeepToolStripMenuItem.Click += new System.EventHandler(this.resetdeepToolStripMenuItem_Click);
            // 
            // vendorRequestsToolStripMenuItem
            // 
            this.vendorRequestsToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.vR3LEDToolStripMenuItem,
            this.vRFLUSHToolStripMenuItem});
            this.vendorRequestsToolStripMenuItem.Name = "vendorRequestsToolStripMenuItem";
            this.vendorRequestsToolStripMenuItem.Size = new System.Drawing.Size(107, 20);
            this.vendorRequestsToolStripMenuItem.Text = "Vendor Requests";
            // 
            // vR3LEDToolStripMenuItem
            // 
            this.vR3LEDToolStripMenuItem.Name = "vR3LEDToolStripMenuItem";
            this.vR3LEDToolStripMenuItem.Size = new System.Drawing.Size(128, 22);
            this.vR3LEDToolStripMenuItem.Text = "VR_3LED";
            this.vR3LEDToolStripMenuItem.Click += new System.EventHandler(this.vR3LEDToolStripMenuItem_Click);
            // 
            // vRFLUSHToolStripMenuItem
            // 
            this.vRFLUSHToolStripMenuItem.Name = "vRFLUSHToolStripMenuItem";
            this.vRFLUSHToolStripMenuItem.Size = new System.Drawing.Size(128, 22);
            this.vRFLUSHToolStripMenuItem.Text = "VR_FLUSH";
            this.vRFLUSHToolStripMenuItem.Click += new System.EventHandler(this.vRFLUSHToolStripMenuItem_Click);
            // 
            // i3CToolStripMenuItem
            // 
            this.i3CToolStripMenuItem.BackColor = System.Drawing.Color.Yellow;
            this.i3CToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.groupresetcontrolToolStripMenuItem,
            this.groupaquireToolStripMenuItem,
            this.groupsccbmonoToolStripMenuItem,
            this.groupsccbburstToolStripMenuItem,
            this.groupsccbburstRToolStripMenuItem});
            this.i3CToolStripMenuItem.Name = "i3CToolStripMenuItem";
            this.i3CToolStripMenuItem.Size = new System.Drawing.Size(36, 20);
            this.i3CToolStripMenuItem.Text = "I3C";
            // 
            // groupresetcontrolToolStripMenuItem
            // 
            this.groupresetcontrolToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.semiToolStripMenuItem,
            this.deepToolStripMenuItem});
            this.groupresetcontrolToolStripMenuItem.Name = "groupresetcontrolToolStripMenuItem";
            this.groupresetcontrolToolStripMenuItem.Size = new System.Drawing.Size(233, 22);
            this.groupresetcontrolToolStripMenuItem.Text = "group_reset_control";
            // 
            // semiToolStripMenuItem
            // 
            this.semiToolStripMenuItem.Name = "semiToolStripMenuItem";
            this.semiToolStripMenuItem.Size = new System.Drawing.Size(101, 22);
            this.semiToolStripMenuItem.Text = "Semi";
            this.semiToolStripMenuItem.Click += new System.EventHandler(this.semiToolStripMenuItem_Click);
            // 
            // deepToolStripMenuItem
            // 
            this.deepToolStripMenuItem.Name = "deepToolStripMenuItem";
            this.deepToolStripMenuItem.Size = new System.Drawing.Size(101, 22);
            this.deepToolStripMenuItem.Text = "Deep";
            this.deepToolStripMenuItem.Click += new System.EventHandler(this.deepToolStripMenuItem_Click);
            // 
            // groupaquireToolStripMenuItem
            // 
            this.groupaquireToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.aquireAndSendToolStripMenuItem,
            this.sCCBCommitToolStripMenuItem});
            this.groupaquireToolStripMenuItem.Name = "groupaquireToolStripMenuItem";
            this.groupaquireToolStripMenuItem.Size = new System.Drawing.Size(233, 22);
            this.groupaquireToolStripMenuItem.Text = "group_aquire";
            // 
            // aquireAndSendToolStripMenuItem
            // 
            this.aquireAndSendToolStripMenuItem.Name = "aquireAndSendToolStripMenuItem";
            this.aquireAndSendToolStripMenuItem.Size = new System.Drawing.Size(161, 22);
            this.aquireAndSendToolStripMenuItem.Text = "Aquire and Send";
            this.aquireAndSendToolStripMenuItem.Click += new System.EventHandler(this.aquireAndSendToolStripMenuItem_Click);
            // 
            // sCCBCommitToolStripMenuItem
            // 
            this.sCCBCommitToolStripMenuItem.Name = "sCCBCommitToolStripMenuItem";
            this.sCCBCommitToolStripMenuItem.Size = new System.Drawing.Size(161, 22);
            this.sCCBCommitToolStripMenuItem.Text = "SCCB_Commit";
            this.sCCBCommitToolStripMenuItem.Click += new System.EventHandler(this.sCCBCommitToolStripMenuItem_Click);
            // 
            // groupsccbmonoToolStripMenuItem
            // 
            this.groupsccbmonoToolStripMenuItem.Name = "groupsccbmonoToolStripMenuItem";
            this.groupsccbmonoToolStripMenuItem.Size = new System.Drawing.Size(233, 22);
            this.groupsccbmonoToolStripMenuItem.Text = "group_sccb_mono";
            // 
            // groupsccbburstToolStripMenuItem
            // 
            this.groupsccbburstToolStripMenuItem.Name = "groupsccbburstToolStripMenuItem";
            this.groupsccbburstToolStripMenuItem.Size = new System.Drawing.Size(233, 22);
            this.groupsccbburstToolStripMenuItem.Text = "group_sccb_burst_W & Commit";
            this.groupsccbburstToolStripMenuItem.Click += new System.EventHandler(this.groupsccbburstToolStripMenuItem_Click);
            // 
            // groupsccbburstRToolStripMenuItem
            // 
            this.groupsccbburstRToolStripMenuItem.Name = "groupsccbburstRToolStripMenuItem";
            this.groupsccbburstRToolStripMenuItem.Size = new System.Drawing.Size(233, 22);
            this.groupsccbburstRToolStripMenuItem.Text = "group_sccb_burst_R";
            this.groupsccbburstRToolStripMenuItem.Click += new System.EventHandler(this.groupsccbburstRToolStripMenuItem_Click);
            // 
            // editSCCBBuffToolStripMenuItem
            // 
            this.editSCCBBuffToolStripMenuItem.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(128)))), ((int)(((byte)(255)))));
            this.editSCCBBuffToolStripMenuItem.Name = "editSCCBBuffToolStripMenuItem";
            this.editSCCBBuffToolStripMenuItem.Size = new System.Drawing.Size(96, 20);
            this.editSCCBBuffToolStripMenuItem.Text = "Edit SCCB buff";
            this.editSCCBBuffToolStripMenuItem.Click += new System.EventHandler(this.editSCCBBuffToolStripMenuItem_Click);
            // 
            // checkBox1
            // 
            this.checkBox1.AutoSize = true;
            this.checkBox1.Checked = true;
            this.checkBox1.CheckState = System.Windows.Forms.CheckState.Checked;
            this.checkBox1.Enabled = false;
            this.checkBox1.Location = new System.Drawing.Point(47, 89);
            this.checkBox1.Name = "checkBox1";
            this.checkBox1.Size = new System.Drawing.Size(41, 17);
            this.checkBox1.TabIndex = 6;
            this.checkBox1.Text = "rev";
            this.checkBox1.UseVisualStyleBackColor = true;
            // 
            // button5
            // 
            this.button5.Location = new System.Drawing.Point(13, 158);
            this.button5.Name = "button5";
            this.button5.Size = new System.Drawing.Size(75, 23);
            this.button5.TabIndex = 7;
            this.button5.Text = "process";
            this.button5.UseVisualStyleBackColor = true;
            this.button5.Visible = false;
            this.button5.Click += new System.EventHandler(this.button5_Click);
            // 
            // textBox_w
            // 
            this.textBox_w.Location = new System.Drawing.Point(14, 187);
            this.textBox_w.Name = "textBox_w";
            this.textBox_w.Size = new System.Drawing.Size(74, 20);
            this.textBox_w.TabIndex = 8;
            this.textBox_w.Text = "640";
            // 
            // textBox_h
            // 
            this.textBox_h.Location = new System.Drawing.Point(14, 213);
            this.textBox_h.Name = "textBox_h";
            this.textBox_h.Size = new System.Drawing.Size(74, 20);
            this.textBox_h.TabIndex = 8;
            this.textBox_h.Text = "480";
            // 
            // timer2
            // 
            this.timer2.Tick += new System.EventHandler(this.timer2_Tick);
            // 
            // log
            // 
            this.log.BackColor = System.Drawing.Color.Black;
            this.log.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.log.Dock = System.Windows.Forms.DockStyle.Right;
            this.log.ForeColor = System.Drawing.Color.Lime;
            this.log.FormattingEnabled = true;
            this.log.Location = new System.Drawing.Point(730, 24);
            this.log.Name = "log";
            this.log.Size = new System.Drawing.Size(228, 524);
            this.log.TabIndex = 9;
            this.log.MouseDoubleClick += new System.Windows.Forms.MouseEventHandler(this.log_MouseDoubleClick);
            // 
            // statusStrip1
            // 
            this.statusStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripStatusLabel1,
            this.toolStripStatusLabel2,
            this.toolStripStatusLabel_FPS});
            this.statusStrip1.Location = new System.Drawing.Point(0, 548);
            this.statusStrip1.Name = "statusStrip1";
            this.statusStrip1.Size = new System.Drawing.Size(958, 22);
            this.statusStrip1.TabIndex = 10;
            this.statusStrip1.Text = "statusStrip1";
            // 
            // toolStripStatusLabel1
            // 
            this.toolStripStatusLabel1.Name = "toolStripStatusLabel1";
            this.toolStripStatusLabel1.Size = new System.Drawing.Size(22, 17);
            this.toolStripStatusLabel1.Text = "---";
            // 
            // toolStripStatusLabel2
            // 
            this.toolStripStatusLabel2.Name = "toolStripStatusLabel2";
            this.toolStripStatusLabel2.Size = new System.Drawing.Size(59, 17);
            this.toolStripStatusLabel2.Text = "FPS(real) :";
            // 
            // toolStripStatusLabel_FPS
            // 
            this.toolStripStatusLabel_FPS.Name = "toolStripStatusLabel_FPS";
            this.toolStripStatusLabel_FPS.Size = new System.Drawing.Size(16, 17);
            this.toolStripStatusLabel_FPS.Text = "...";
            // 
            // timer3
            // 
            this.timer3.Enabled = true;
            this.timer3.Interval = 500;
            this.timer3.Tick += new System.EventHandler(this.timer3_Tick);
            // 
            // timer_fps_real
            // 
            this.timer_fps_real.Enabled = true;
            this.timer_fps_real.Tick += new System.EventHandler(this.timer_fps_real_Tick);
            // 
            // button6
            // 
            this.button6.Location = new System.Drawing.Point(12, 240);
            this.button6.Name = "button6";
            this.button6.Size = new System.Drawing.Size(75, 34);
            this.button6.TabIndex = 11;
            this.button6.Text = "aquire mthd2";
            this.button6.UseVisualStyleBackColor = true;
            this.button6.Click += new System.EventHandler(this.button6_Click);
            // 
            // button7
            // 
            this.button7.Location = new System.Drawing.Point(13, 280);
            this.button7.Name = "button7";
            this.button7.Size = new System.Drawing.Size(75, 34);
            this.button7.TabIndex = 11;
            this.button7.Text = "view frame mthd2";
            this.button7.UseVisualStyleBackColor = true;
            this.button7.Click += new System.EventHandler(this.button7_Click);
            // 
            // button8
            // 
            this.button8.Location = new System.Drawing.Point(12, 320);
            this.button8.Name = "button8";
            this.button8.Size = new System.Drawing.Size(75, 39);
            this.button8.TabIndex = 12;
            this.button8.Text = "aq. && view mthd2";
            this.button8.UseVisualStyleBackColor = true;
            this.button8.Click += new System.EventHandler(this.button8_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(958, 570);
            this.Controls.Add(this.button8);
            this.Controls.Add(this.button7);
            this.Controls.Add(this.button6);
            this.Controls.Add(this.log);
            this.Controls.Add(this.statusStrip1);
            this.Controls.Add(this.textBox_h);
            this.Controls.Add(this.textBox_w);
            this.Controls.Add(this.button5);
            this.Controls.Add(this.checkBox1);
            this.Controls.Add(this.button4);
            this.Controls.Add(this.tt);
            this.Controls.Add(this.button3);
            this.Controls.Add(this.pictureBox1);
            this.Controls.Add(this.button2);
            this.Controls.Add(this.menuStrip1);
            this.MainMenuStrip = this.menuStrip1;
            this.Name = "Form1";
            this.Text = "AINGF_V2 Control Center";
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.statusStrip1.ResumeLayout(false);
            this.statusStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.PictureBox pictureBox1;
        private System.Windows.Forms.Button button3;
        private System.Windows.Forms.TextBox tt;
        private System.Windows.Forms.Timer timer1;
        private System.Windows.Forms.Button button4;
        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem restartToolStripMenuItem;
        private System.Windows.Forms.CheckBox checkBox1;
        private System.Windows.Forms.Button button5;
        private System.Windows.Forms.TextBox textBox_w;
        private System.Windows.Forms.TextBox textBox_h;
        private System.Windows.Forms.Timer timer2;
        private System.Windows.Forms.ToolStripMenuItem runTimedAquiringToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem saveToolStripMenuItem;
        private System.Windows.Forms.SaveFileDialog saveFileDialog1;
        private System.Windows.Forms.ToolStripMenuItem iNCToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem dECFRMRATEToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem instructionsToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem sCCBToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem aquireAndSendAFrameToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem resetdeepToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem enableToolStripMenuItem;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator2;
        private System.Windows.Forms.ToolStripMenuItem resetsemiToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem vendorRequestsToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem vR3LEDToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem i3CToolStripMenuItem;
        private System.Windows.Forms.ListBox log;
        private System.Windows.Forms.ToolStripMenuItem groupresetcontrolToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem semiToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem deepToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem groupaquireToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem aquireAndSendToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem groupsccbmonoToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem groupsccbburstToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem groupsccbburstRToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem editSCCBBuffToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem sCCBCommitToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem reconnectToolStripMenuItem;
        private System.Windows.Forms.StatusStrip statusStrip1;
        private System.Windows.Forms.ToolStripStatusLabel toolStripStatusLabel1;
        private System.Windows.Forms.ToolStripMenuItem vRFLUSHToolStripMenuItem;
        private System.Windows.Forms.Timer timer3;
        private System.Windows.Forms.ToolStripStatusLabel toolStripStatusLabel2;
        private System.Windows.Forms.ToolStripStatusLabel toolStripStatusLabel_FPS;
        private System.Windows.Forms.Timer timer_fps_real;
        private System.Windows.Forms.Button button6;
        private System.Windows.Forms.Button button7;
        private System.Windows.Forms.Button button8;
    }
}

