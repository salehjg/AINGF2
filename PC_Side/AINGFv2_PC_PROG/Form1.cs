using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Threading;
using CyUSB;
using System.Runtime.InteropServices;
using System.IO;

namespace AINGFv2_PC_PROG
{
       
    public partial class Form1 : Form
    {
        /*
        const int CMD_MODIFY_SCCB_DATA = 1;
        const int CMD_MODIFY_SCCB_ADDR = 2;
        const int CMD_SCCB_COMMIT = 3;
        const int CMD_AQUIRE_SEND = 8;
        const int CMD_RESET_SEMI = 11;
        const int CMD_RESET_DEEP = 10;

        
        const byte opcode_modify_sccb_buffer_address 	 = 0x01; // 8'b000_00001 ;
        const byte opcode_modify_sccb_buffer_data		 = 0x02; //8'b000_00010 ;
        const byte opcode_modify_sccb_commit			 = 0x03; //8'b000_00011 ;
        const byte opcode_aquire_single_frame_and_send   = 0x08; //8'b000_01000 ;
        const byte opcode_reset_entire					 = 0x0A; //8'b000_01010 ;
        const byte opcode_reset_semi					 = 0x0B; //8'b000_01011 ;
        */
  

        const byte  	group_reset_control			= 1;
        			const byte	subcode_reset_semi	= 1;
        			const byte	subcode_reset_deep	= 2;

        const byte 	group_aquire_control			= 2;
                    const byte subcode_aquire_send  = 1;
                    const byte subcode_sccb_commit  = 2;
        			
        			
        const byte 	group_sccb_mono					= 3;
        
        
        const byte 	group_sccb_burst_w				= 4;
                    const byte subcode_burst_w_start = 1;
                    const byte subcode_burst_w_loop0 = 2;
                    const byte subcode_burst_w_loop1 = 3;
                    const byte subcode_burst_w_stop  = 4;         
        
        const byte 	group_sccb_burst_r				= 5;
			        const byte	subcode_burst_r_start = 1;
			        const byte	subcode_burst_r_loop0 = 2;
			        const byte	subcode_burst_r_loop1 = 3;
			        const byte	subcode_burst_r_stop  = 4;        
        






        principle pc = new principle();
        int fname = 0;
        int ww;
        int hh ;
        byte[] data;
        bool bVista;
        private System.Diagnostics.PerformanceCounter CpuCounter;
        bool ready=false;
        USBDeviceList usbDevices;
        CyUSBDevice MyDevice;
        CyUSBEndPoint EndPoint;

        DateTime t1, t2;
        TimeSpan elapsed;
        double XferBytes;
        long xferRate;
        static byte DefaultBufInitValue = 0xA5;

        int BufSz;
        int QueueSz;
        int PPX;
        int IsoPktBlockSize;
        int Successes;
        int Failures;

        Thread tListen;
        static bool bRunning;

        // These are  needed for Thread to update the UI
        delegate void UpdateUICallback();
        UpdateUICallback updateUI;
        private Label label6;
        private ComboBox DevicesComboBox;
        private Button button1;

        // These are needed to close the app from the Thread exception(exception handling)
        delegate void ExceptionCallback();
        ExceptionCallback handleException;




        int frame_rate = 1;
        int frame_rate_delay_ms = 1000;
        bool auto_aquire_stop = false;
        bool auto_aquire_started = false;
        Image Last_Frame,New_Frame;
        bool new_frame_locked = false;



        #region Basic Frame Counter
        private int internal_fps;
        private int fps_real
        {
            get
            {
                return internal_fps;
            }
            set
            {
                internal_fps = value;
            }
        }
        private static int lastTick;
        private static int lastFrameRate;
        private static int frameRate;

        public static int CalculateFrameRate()
        {
            if (System.Environment.TickCount - lastTick >= 1000)
            {
                lastFrameRate = frameRate;
                frameRate = 0;
                lastTick = System.Environment.TickCount;
            }
            frameRate++;
            return lastFrameRate;
        }
        #endregion


        public void I3C_Transact(byte[] buff2send, byte len, ref byte[] result, bool thread_safe)
        {


            if (MyDevice != null)
            {
                if (MyDevice.ControlEndPt != null)
                {
                    {
                        CyControlEndPoint cept = MyDevice.ControlEndPt;
                        cept.Direction = CyConst.DIR_TO_DEVICE;
                        cept.ReqType = CyConst.REQ_VENDOR;
                        cept.Target = CyConst.TGT_DEVICE;
                        cept.ReqCode = 0xA6;
                        cept.Value = 0x00;//dummy--not used yet! 
                        cept.Index = (byte)(len/2);

                        //------------------------------------------------------
                        int lenn = len;
                        byte[] buff = new byte[len];
                        for (int j = 0; j < len; j++)
                        {
                            buff[j] = buff2send[j];
                        }

                        if (false == cept.XferData(ref buff, ref lenn)) { MessageBox.Show("Error#  "); }
                    }


                    {
                        CyControlEndPoint cept = MyDevice.ControlEndPt;
                        cept.Direction = CyConst.DIR_FROM_DEVICE;
                        cept.ReqType = CyConst.REQ_VENDOR;
                        cept.Target = CyConst.TGT_DEVICE;
                        cept.ReqCode = 0xA2;
                        cept.Value = 0x00; //dummy--not used yet! 
                        cept.Index = (byte)(len / 2); 

                        //------------------------------------------------------
                        int lenn = len;
                        byte[] buff = new byte[len];

                        if (false == cept.XferData(ref buff, ref lenn)) { MessageBox.Show("Error#  "); }
                        else
                        {
                            if (!thread_safe)
                            {
                                log.Items.Add("=========================");
                                for (int j = 0; j < len; j++)
                                {
                                    log.Items.Add("I3C-Recieved Byte #" + j.ToString("D2") + "  =  0x" + (buff[j]).ToString("X2"));
                                    log.SelectedIndex = log.Items.Count - 1;
                                }
                            }
                            result = buff;
                        }
                    }
                }
            }
        }

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            string tmp_folder = "C:\\tmp\\AINGF_V2\\";
            try
            {

                if (!Directory.Exists(tmp_folder)) Directory.CreateDirectory(tmp_folder);
                string[] filePaths = Directory.GetFiles(tmp_folder);
                foreach (string filePath in filePaths)
                    File.Delete(filePath);
            }
            catch
            {
                MessageBox.Show("Temp Folder flush error.");
            }

            //Thread th1 = new Thread(new ThreadStart(prepareEX));
            //th1.Start();
            usbDevices = new USBDeviceList(CyConst.DEVICES_CYUSB);
            MyDevice = usbDevices[0x04B4, 0x1003] as CyUSBDevice;
        }


        public void prepareEX()
        {
            USBDeviceList usbDevices = new USBDeviceList(CyConst.DEVICES_CYUSB);
            CyUSBDevice MyDevice = usbDevices[0x04B4, 0x1003] as CyUSBDevice;
            if (MyDevice != null)
            {
                MyDevice.Reset();
                Thread.Sleep(1000);
                MyDevice.ReConnect();
                Thread.Sleep(1000);
                if (MyDevice.BulkInEndPt != null) { MyDevice.BulkInEndPt.Reset(); }
                if (MyDevice.BulkOutEndPt != null)
                {
                    MyDevice.BulkInEndPt.TimeOut = 500;
                    
                    for (int i = 0; i < 640 * 480 * 2 / 512; i++)
                    {
                        int len = 512;
                        byte[] buf = new byte[len];

                        if (false == MyDevice.BulkInEndPt.XferData(ref buf, ref len, true)) { ready  = true; break; }
                    }
                }
            }
            return;
        }



        private Image convert_yuv422_rgb888(byte[] rawStreamingFrame,int offset_w,int offset_h)
        {
            Image result;
            int height = 480;
            int width = 640;

            // Create a QByteArray to store the RGB Data
            int[] redContainer = new int[height * width];
            int[] greenContainer = new int[height * width];
            int[] blueContainer = new int[height * width];


            int cnt = -1;

            for (int i = 0; i <= rawStreamingFrame.Length - 4; i += 4)
            {

                // Extract yuv components

                int u = (int)rawStreamingFrame[i];

                int y1 = (int)rawStreamingFrame[i + 1];

                int v = (int)rawStreamingFrame[i + 2];

                int y2 = (int)rawStreamingFrame[i + 3];

                // Define the RGB

                int r1 = 0, g1 = 0, b1 = 0;

                int r2 = 0, g2 = 0, b2 = 0;

                // u and v are +-0.5

                u -= 128;

                v -= 128;

                // Conversion

                r1 = (int)(y1 + 1.403 * v);

                g1 = (int)(y1 - 0.344 * u - 0.714 * v);

                b1 = (int)(y1 + 1.770 * u);

                r2 = (int)(y2 + 1.403 * v);

                g2 = (int)(y2 - 0.344 * u - 0.714 * v);

                b2 = (int)(y2 + 1.770 * u);

                // Increment by one so we can insert

                cnt += 1;

                // Append to the array holding our RGB Values

                redContainer[cnt] = check_val(r1);

                greenContainer[cnt] = check_val(g1);

                blueContainer[cnt] = check_val(b1);

                // Increment again since we have 2 pixels per uv value

                cnt += 1;

                // Store the second pixel

                redContainer[cnt] = check_val(r2);

                greenContainer[cnt] = check_val(g2);

                blueContainer[cnt] = check_val(b2);

            }

            {
                int pixelCounter = -1 + offset_w + offset_h * ww;
                Bitmap bmp = new Bitmap(ww, hh, System.Drawing.Imaging.PixelFormat.Format24bppRgb);
                int bitcount = pc.get_image_array_count(bmp);
                byte[] bit_rgb = new byte[bitcount];
                int indx;
                int lw = pc.get_line_width(bmp);

                for (int j = 0; j < hh; j++)
                {
                    for (int i = 0; i < ww; i++)
                    {

                        indx = j * lw + i * 3;
                        pixelCounter++;
                        if (pixelCounter < redContainer.Length)
                        {
                            //bmp.SetPixel(i, j, Color.FromArgb(redContainer[pixelCounter], greenContainer[pixelCounter], blueContainer[pixelCounter]));
                            bit_rgb[indx + 2] = Convert.ToByte(redContainer[pixelCounter]);
                            bit_rgb[indx + 1] = Convert.ToByte(greenContainer[pixelCounter]);
                            bit_rgb[indx] = Convert.ToByte(blueContainer[pixelCounter]);
                        }
                    }
                }
                result = pc.write_image(bmp, bit_rgb);//(Bitmap)bmp.Clone();
            }
            return result;
        }


        private Image convert_rgb565_rgb888(byte[] rawStreamingFrame, int offset_w, int offset_h)
        {
            Image result;
            int height = 480;
            int width = 640;

            // Create a QByteArray to store the RGB Data
            int[] redContainer = new int[height * width];
            int[] greenContainer = new int[height * width];
            int[] blueContainer = new int[height * width];


            int cnt = -1;

            for (int i = 0; i <= rawStreamingFrame.Length - 2; i += 2)
            {
                // Increment by one so we can insert

                cnt += 1;

                // Append to the array holding our RGB Values
                //rawStreamingFrame[i] = 0xff;
                redContainer[cnt] = check_val((int)(256.0d*((rawStreamingFrame[i] & 0xF8)>>3)  /32.0d));

                greenContainer[cnt] = 
                    check_val
                    (
                        (int)(
                                256.0d * 
                                (
                                    (double)(
                                        ( (rawStreamingFrame[i] & 0x07)    << 3  ) |
                                        ( (rawStreamingFrame[i +1] & 0xE0) >> 5  )
                                    )
                                ) / 64.0d
                            )
                    );

                blueContainer[cnt] = check_val((int)(256.0d * ((rawStreamingFrame[i+1] & 0x1F)) / 32.0d)); ;

            }

            {
                int pixelCounter = -1 + offset_w + offset_h * ww;
                Bitmap bmp = new Bitmap(ww, hh, System.Drawing.Imaging.PixelFormat.Format24bppRgb);
                int bitcount = pc.get_image_array_count(bmp);
                byte[] bit_rgb = new byte[bitcount];
                int indx;
                int lw = pc.get_line_width(bmp);

                for (int j = 0; j < hh; j++)
                {
                    for (int i = 0; i < ww; i++)
                    {

                        indx = j * lw + i * 3;
                        pixelCounter++;
                        if (pixelCounter < redContainer.Length)
                        {
                            //bmp.SetPixel(i, j, Color.FromArgb(redContainer[pixelCounter], greenContainer[pixelCounter], blueContainer[pixelCounter]));
                            bit_rgb[indx + 2] = Convert.ToByte(redContainer[pixelCounter]);
                            bit_rgb[indx + 1] = Convert.ToByte(greenContainer[pixelCounter]);
                            bit_rgb[indx] = Convert.ToByte(blueContainer[pixelCounter]);
                        }
                    }
                }
                result = pc.write_image(bmp, bit_rgb);//(Bitmap)bmp.Clone();
            }
            return result;
        }

        /*Summary
           This method is used to do the initialization for detecting the CPU load
        */
        private void InitializePeformanceMonitor()
        {
            // This isn't allowed in Vista.
            if (bVista) return;

            CpuCounter = new System.Diagnostics.PerformanceCounter();
            ((System.ComponentModel.ISupportInitialize)(CpuCounter)).BeginInit();

            CpuCounter.CategoryName = "Processor";
            CpuCounter.CounterName = "% Processor Time";
            CpuCounter.InstanceName = "_Total";

            ((System.ComponentModel.ISupportInitialize)(CpuCounter)).EndInit();

        }

        private int check_val(int val)
        {
            if (val < 0) return 0;
            if (val > 255) return 255;
            if (val >= 0 && val <= 255) return val;

            return -1;
        }
        ////////////////////////////////////////////////////////////////////////////////////////////////////////
        private void button2_Click(object sender, EventArgs e)
        {
            process_method01(0,false,true);
        }

        void process_method01(int phase,bool thread_safe,bool messagebox)
        {
            if (phase == 0)
            {
                data = new byte[(640 * 480 * 2)];
                byte[] data_rev = new byte[640 * 480 * 2];
                int cnt = 0;

                //USBDeviceList usbDevices = new USBDeviceList(CyConst.DEVICES_CYUSB);
                //CyUSBDevice MyDevice = usbDevices[0x04B4, 0x1003] as CyUSBDevice;
                if (MyDevice != null)
                {
                    if (MyDevice.BulkInEndPt != null)
                    {
                        {
                            // MyDevice.Reset();
                            // MyDevice.ReConnect();
                                                            // MyDevice.BulkInEndPt.Reset();   was enabled
                            
                           // MyDevice.BulkOutEndPt.TimeOut = 1000;

                            MyDevice.BulkInEndPt.TimeOut =20;

                            //int len = 0;
                            //byte[] buf = new byte[len];
                            //  MyDevice.BulkInEndPt.XferData(ref buf, ref len);
                        }
                        for (int i = 0; i < 640 * 480 * 2 / 512 ; i++)
                        {
                            int len = 512;
                            byte[] buf = new byte[len];

                            if (false == MyDevice.BulkInEndPt.XferData(ref buf, ref len, false)) {if(messagebox) MessageBox.Show("Error#  " + i.ToString()); break; }


                            for (int j = 0; j < 512; j++)
                            {
                                data[cnt++] = buf[j];
                            }
                            
                        }
                        fps_real = CalculateFrameRate();
                    }
                }
            }

            if (phase == 1)
            {
                ww = Convert.ToInt32(textBox_w.Text);
                hh = Convert.ToInt32(textBox_h.Text);
                /*
                byte[] data_rev = new byte[640 * 480 * 2];
                {
                    int l = data.Length;
                    int offset = Convert.ToInt32(tt.Text);
                    for (int i = 0; i < l; i += 2)
                    {
                        if (offset + i + 1 < l)
                        {
                            if (!checkBox1.Checked)
                            {
                                data_rev[offset + i] = data[i + 1];
                                data_rev[offset + i + 1] = data[i];
                            }
                            else
                            {
                                data_rev[offset + i] = data[i];
                                data_rev[offset + i + 1] = data[i + 1];
                            }
                        }
                    }
                }*/

                if (data.Length != 640 * 480 * 2) MessageBox.Show("Data lengh mismatch!");
                if (!thread_safe)
                {
                    if (pictureBox1.Image != null) pictureBox1.Image.Dispose();
                    pictureBox1.Image = convert_rgb565_rgb888(data, 0, 0);
                }
                else
                {
                    new_frame_locked = true;
                    New_Frame = convert_rgb565_rgb888(data, 0, 0);
                    new_frame_locked = false;
                }

                
            }
        }
        ////////////////////////////////////////////////////////////////////////////////////////////////////////
        void process_method02(int phase, bool thread_safe, bool messagebox)
        {
            if (phase == 0)
            {
                data = new byte[(640 * 480 * 2)*2+64*2]; // 2 frames , 1 frame = {pattern + 640*480 pixel data(2bytes per pixel)}.
                byte[] data_rev = new byte[640 * 480 * 2];
                int cnt = 0;

                //USBDeviceList usbDevices = new USBDeviceList(CyConst.DEVICES_CYUSB);
                //CyUSBDevice MyDevice = usbDevices[0x04B4, 0x1003] as CyUSBDevice;
                if (MyDevice != null)
                {
                    if (MyDevice.BulkInEndPt != null)
                    {
                        {
                            // MyDevice.Reset();
                            // MyDevice.ReConnect();
                            // MyDevice.BulkInEndPt.Reset();   was enabled

                            // MyDevice.BulkOutEndPt.TimeOut = 1000;

                            MyDevice.BulkInEndPt.TimeOut = 1000;

                            //int len = 0;
                            //byte[] buf = new byte[len];
                            //  MyDevice.BulkInEndPt.XferData(ref buf, ref len);
                        }
                        for (int i = 0; i < 640 * 480 * 2 / 512 + /*for 2 patterns (128 bytes)*/1; i++)
                        {
                            int len = 512;
                            byte[] buf = new byte[len];

                            if (false == MyDevice.BulkInEndPt.XferData(ref buf, ref len, false)) { if (messagebox) MessageBox.Show("Error#  " + i.ToString()); break; }


                            for (int j = 0; j < 512; j++)
                            {
                                data[cnt++] = buf[j];
                            }

                        }
                        fps_real = CalculateFrameRate();
                    }
                }
            }

            if (phase == 1)
            {
                ww = Convert.ToInt32(textBox_w.Text);
                hh = Convert.ToInt32(textBox_h.Text);

                int frame1_start = -1;
                int frame1_stop = -1;
                int frame2_start = -1;
                int frame2_stop = -1;
                int len = data.Length;

                for (int i = 0; i < len; i++)
                {
                    if (data[i] == 0xCD)
                    {
                        if(data[i+1] == 0xAB)
                        {
                            if (data[i + 2] == 0x89)
                            {
                                if (data[i + 3] == 0xEF)
                                {
                                    if (frame1_start == -1) frame1_start = i + 64*2;
                                    if (frame2_start == -1) frame2_start = i + 64*2;
                                }
                            }
                        }
                    }
                }

                byte[] frame1 = new byte[640 * 480 * 2];
                for (int i = 0; i < 614400; i++)
                {
                    frame1[i] = data[i + frame1_start];
                }


                if (!thread_safe)
                {
                    if (pictureBox1.Image != null) pictureBox1.Image.Dispose();
                    pictureBox1.Image = convert_rgb565_rgb888(frame1, 0, 0);
                }
                else
                {
                    new_frame_locked = true;
                    New_Frame = convert_rgb565_rgb888(frame1, 0, 0);
                    new_frame_locked = false;
                }


            }
        }
        ////////////////////////////////////////////////////////////////////////////////////////////////////////
        private void button3_Click(object sender, EventArgs e)
        {
            process_method01(1,false,true);
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            if (ready) this.Text = "Ready to get frame!";
            else this.Text = "getting ready to aquire frame...";
        }

        private void button4_Click(object sender, EventArgs e)
        {
            ready = false;
            Thread th1 = new Thread(new ThreadStart(prepareEX));
            th1.Start();
        }

        private void restartToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Application.Restart();
        }

        private void button5_Click(object sender, EventArgs e)
        {
            int offset_max_pixels = 640;
            int tmp, offset_w, offset_h;
            //------------------------------------          
            for (int ii = 1; ii < offset_max_pixels; ii++)
            {
                //------------------------------------
                {
                    tmp = ii - 1;
                    offset_h = (int)(tmp / 640.0d);
                    offset_w = tmp - offset_h * 640;
                }
                //------------------------------------
                {
                    byte[] data_rev = new byte[640 * 480 * 2];
                    {
                        int l = data.Length;
                        int offset = Convert.ToInt32(tt.Text);
                        for (int i = 0; i < l; i += 2)
                        {
                            if (offset + i + 1 < l)
                            {
                                if (!checkBox1.Checked)
                                {
                                    data_rev[offset + i] = data[i + 1];
                                    data_rev[offset + i + 1] = data[i];
                                }
                                else
                                {
                                    data_rev[offset + i] = data[i];
                                    data_rev[offset + i + 1] = data[i + 1];
                                }
                            }
                        }
                    }
                    convert_yuv422_rgb888(data_rev, offset_w, offset_h).Save("C:\\tmp\\AINGF_V2\\offset_x" + offset_w + "__y" + offset_h + ".png");
                }
                //------------------------------------
            }
        }

        private void runTimedAquiringToolStripMenuItem_Click(object sender, EventArgs e)
        {
            
        }

        private void timer2_Tick(object sender, EventArgs e)
        {
            if (new_frame_locked ==false)
            {
                if (Last_Frame != New_Frame)
                {
                    if(pictureBox1.Image != null)pictureBox1.Image.Dispose();
                    pictureBox1.Image = (Image)New_Frame.Clone();
                    Last_Frame = (Image)New_Frame.Clone();
                }
            }
        }

        private void saveToolStripMenuItem_Click(object sender, EventArgs e)
        {
            saveFileDialog1.Filter = "PNG FORMAT|*.PNG";
            if (saveFileDialog1.ShowDialog() != System.Windows.Forms.DialogResult.Cancel)
            {
                pictureBox1.Image.Save(saveFileDialog1.FileName);
            }
        }

        private void iNCToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (frame_rate <25)
            {
               // if (frame_rate_delay_ms <= 400) frame_rate_delay_ms -= 50;
               // if (frame_rate_delay_ms > 400) frame_rate_delay_ms -= 200;
                frame_rate++;
                frame_rate_delay_ms =(int) (1000.0f / frame_rate);
                toolStripStatusLabel1.Text = (frame_rate).ToString();
            }
        }

        private void dECFRMRATEToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (frame_rate >1)
            {
               // if (frame_rate_delay_ms <= 400) frame_rate_delay_ms += 50;
               // if (frame_rate_delay_ms > 400) frame_rate_delay_ms += 200;
                frame_rate--;
                frame_rate_delay_ms = (int)(1000.0f / frame_rate);
                toolStripStatusLabel1.Text = (frame_rate).ToString();
            }
        }

        private void enableToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (auto_aquire_started == false)
            {
                timer2.Enabled = true;
                auto_aquire_started = true;
                auto_aquire_stop = false;
                enableToolStripMenuItem.Checked = true;
                Thread t1 = new Thread(new ThreadStart(thread_method_v1));
                t1.Start();
            }
            else
            {
                timer2.Enabled = false;
                auto_aquire_started = false;
                auto_aquire_stop = true;
                enableToolStripMenuItem.Checked = false;
            }
        }

        private void thread_method_v1()
        {
            //toolStripStatusLabel1.Text = (1000.0f / (float)timer2.Interval).ToString("F3");
            while (auto_aquire_stop == false)
            {
                Thread.Sleep(frame_rate_delay_ms);
               // MessageBox.Show("DD");
                //I3C_Send_CMD(group_reset_control, subcode_reset_semi, 0x00,true);
                Thread.Sleep(75);
                process_method01(0,true,false);
               // process_method01(1,true,false);

            }
        }

        public UInt16[] I3C_Send_CMD(byte group,byte subcode,byte data_packet,bool thread_safe)
        { //BYTE[0]: LS-BYTE    BYTE[1]: MS-BYTE
            {
                if (subcode == subcode_reset_semi) Custom_REQ_FLUSH_FIFO(); // Flush all fifo s by custom req -- only firmware operations on usbfx2, non i3c operations
            }

            int cnt_indx = 0;
            int i3c_payload_count = 1; //maximum is 32
            byte[] buff = new byte[i3c_payload_count * 2];
            byte[] buff_r = new byte[i3c_payload_count * 2];
            UInt16[] buff_r_word = new UInt16[i3c_payload_count];
            //------------------------------
            for (int j = 0; j < i3c_payload_count * 2; j += 2)
            {
                buff[j + 0] = (byte)(((0x0F & group) << 4) | (0x0F & subcode)); //LSB
                buff[j + 1] = (byte)(data_packet);//MSB
            }
            I3C_Transact(buff, (byte)(i3c_payload_count * 2), ref buff_r, thread_safe);
            for (int j = 0; j < i3c_payload_count * 2; j += 2)
            {
                buff_r_word[cnt_indx++] = (UInt16)(buff_r[j] | (buff_r[j + 1] << 8));
            }
            return buff_r_word;
        }

        public void Custom_REQ_FLUSH_FIFO()
        {
            //USBDeviceList usbDevices = new USBDeviceList(CyConst.DEVICES_CYUSB);
           // CyUSBDevice MyDevice = usbDevices[0x04B4, 0x1003] as CyUSBDevice;
            if (MyDevice != null)
            {
                if (MyDevice.ControlEndPt != null)
                {
                    CyControlEndPoint cept = MyDevice.ControlEndPt;
                    cept.Direction = CyConst.DIR_TO_DEVICE;
                    cept.ReqType = CyConst.REQ_VENDOR;
                    cept.Target = CyConst.TGT_DEVICE;
                    cept.ReqCode = 0xA7; //VR_FLUSH  CUSTOM REQ---FLUSHES ALL FIFOS!
                    cept.Value = 0x01;
                    cept.Index = 0;



                    cept.Value = 0x08;
                    int lenn = 0;
                    byte[] buff = new byte[1];
                    buff[0] = (byte)(0x01 & 0xff);
                    if (false == cept.XferData(ref buff, ref lenn)) { MessageBox.Show("Error#  "); }


                }
            }
        }


        

        private void resetsemiToolStripMenuItem_Click(object sender, EventArgs e)
        {
            
        }

        private void resetdeepToolStripMenuItem_Click(object sender, EventArgs e)
        {
            
        }

        private void aquireAndSendAFrameToolStripMenuItem_Click(object sender, EventArgs e)
        {
            
        }

        private void vR3LEDToolStripMenuItem_Click(object sender, EventArgs e)
        {
            USBDeviceList usbDevices = new USBDeviceList(CyConst.DEVICES_CYUSB);
            CyUSBDevice MyDevice = usbDevices[0x04B4, 0x1003] as CyUSBDevice;
            if (MyDevice != null)
            {
                if (MyDevice.ControlEndPt != null)
                {
                    CyControlEndPoint cept = MyDevice.ControlEndPt;
                    cept.Direction = CyConst.DIR_TO_DEVICE;
                    cept.ReqType = CyConst.REQ_VENDOR;
                    cept.Target = CyConst.TGT_DEVICE;
                    cept.ReqCode = 0xA5;
                    cept.Value = 0x01;
                    cept.Index = 0;

                    //------------------------------------------------------
                    for (int i = 0; i < 10; i++)
                    {
                        Thread.Sleep(70);
                        {
                            cept.Value = 0x08;
                            int lenn = 0;
                            byte[] buff = new byte[1];
                            buff[0] = (byte)(0x01 & 0xff);
                            if (false == cept.XferData(ref buff, ref lenn)) { MessageBox.Show("Error#  "); }
                        }
                        Thread.Sleep(70);
                        {
                            cept.Value = 0x02;
                            int lenn = 0;
                            byte[] buff = new byte[1];
                            buff[0] = (byte)(0x01 & 0xff);
                            if (false == cept.XferData(ref buff, ref lenn)) { MessageBox.Show("Error#  "); }
                        }
                        Thread.Sleep(70);
                        {
                            cept.Value = 0x01;
                            int lenn = 0;
                            byte[] buff = new byte[1];
                            buff[0] = (byte)(0x01 & 0xff);
                            if (false == cept.XferData(ref buff, ref lenn)) { MessageBox.Show("Error#  "); }
                        }
                        Thread.Sleep(70);
                        {
                            cept.Value = 0x02;
                            int lenn = 0;
                            byte[] buff = new byte[1];
                            buff[0] = (byte)(0x01 & 0xff);
                            if (false == cept.XferData(ref buff, ref lenn)) { MessageBox.Show("Error#  "); }
                        }
                        Thread.Sleep(70);
                        {
                            cept.Value = 0x08;
                            int lenn = 0;
                            byte[] buff = new byte[1];
                            buff[0] = (byte)(0x01 & 0xff);
                            if (false == cept.XferData(ref buff, ref lenn)) { MessageBox.Show("Error#  "); }
                        }
                    }
                }
            }
        }

        private void semiResetToolStripMenuItem_Click(object sender, EventArgs e)
        {
            
        }

        private void deepResetToolStripMenuItem_Click(object sender, EventArgs e)
        {
            
        }

        private void aquireSendToolStripMenuItem_Click(object sender, EventArgs e)
        {
            
        }

        private void log_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            log.Items.Clear();
        }

        private void semiToolStripMenuItem_Click(object sender, EventArgs e)
        {
            I3C_Send_CMD(group_reset_control, subcode_reset_semi, 0x00,false);
        }

        private void deepToolStripMenuItem_Click(object sender, EventArgs e)
        {
            I3C_Send_CMD(group_reset_control, subcode_reset_deep, 0x00, false);
        }

        private void aquireAndSendToolStripMenuItem_Click(object sender, EventArgs e)
        {
            I3C_Send_CMD(group_aquire_control, subcode_aquire_send, 0x00, false);
        }

        private void groupsccbburstRToolStripMenuItem_Click(object sender, EventArgs e)
        {
            UInt16[] sccb_data = new UInt16[56];

            I3C_Send_CMD(group_sccb_burst_r, subcode_burst_r_start, 0x00, false);
            I3C_Send_CMD(group_sccb_burst_r, subcode_burst_r_loop0, 0x00, false); // returned data is dummy!
            for (int i = 0; i < 56; i++)
            {
                sccb_data[i] = I3C_Send_CMD(group_sccb_burst_r, subcode_burst_r_loop1, 0x00, false)[0];
            }
            I3C_Send_CMD(group_sccb_burst_r, subcode_burst_r_stop, 0x00, false);

            string[] last_saved = File.ReadAllLines(".\\Data.dat");




            
                
            string[] payload = new string[56];

            for (int i = 0; i < 56; i++)
            {
                string[] cells = last_saved[i].Split(','); // addr(hex), value(hex), desc.
                string str = sccb_data[i].ToString("X4");
                payload[i] = str.Substring(0, 2) + ",";
                payload[i] += str.Substring(2,2) + ",";
                payload[i] += cells[2] +  ","; //desc
                payload[i] += cells[3] + ",";  //note1
                payload[i] += cells[4] + ",";  //note2
            }

            File.WriteAllLines(".\\Data.dat", payload);

        }

        private void editSCCBBuffToolStripMenuItem_Click(object sender, EventArgs e)
        {
            frm_SCCB_Content f = new frm_SCCB_Content();
            f.ShowDialog();
        }

        private void groupsccbburstToolStripMenuItem_Click(object sender, EventArgs e)
        {
            string[] str = File.ReadAllLines(".\\Data.dat");

            I3C_Send_CMD(group_sccb_burst_w, subcode_burst_w_start, 0x00, false);
            for (int i = 0; i < 56; i++)
            {
                string[] cells = str[i].Split(','); // addr(hex), value(hex), desc.
                byte adr, val;
                adr = Convert.ToByte( cells[0], 16 ); //addr  hex
                val = Convert.ToByte( cells[1], 16 ); //value hex




                I3C_Send_CMD(group_sccb_burst_w, subcode_burst_w_loop0, val, false);
                I3C_Send_CMD(group_sccb_burst_w, subcode_burst_w_loop1, adr, false);
                
                
            }
            I3C_Send_CMD(group_sccb_burst_w, subcode_burst_w_stop, 0x00, false);
            I3C_Send_CMD(group_aquire_control, subcode_sccb_commit, 0x00, false);
        }

        private void sCCBCommitToolStripMenuItem_Click(object sender, EventArgs e)
        {
            I3C_Send_CMD(group_aquire_control, subcode_sccb_commit, 0x00, false);
        }

        private void reconnectToolStripMenuItem_Click(object sender, EventArgs e)
        {
            usbDevices = new USBDeviceList(CyConst.DEVICES_CYUSB);
            MyDevice = usbDevices[0x04B4, 0x1003] as CyUSBDevice;
        }

        private void vRFLUSHToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Custom_REQ_FLUSH_FIFO();
        }

        private void timer3_Tick(object sender, EventArgs e)
        {
            fname++;
            if(pictureBox1.Image!=null)pictureBox1.Image.Save("c:\\tmp\\" + fname.ToString() + ".bmp");
        }

        private void timer_fps_real_Tick(object sender, EventArgs e)
        {
            toolStripStatusLabel_FPS.Text = fps_real.ToString();
        }

        private void button6_Click(object sender, EventArgs e)
        {
            process_method02(0, false, true);
        }

        private void button7_Click(object sender, EventArgs e)
        {
            process_method02(1, false, true);
        }

        private void button8_Click(object sender, EventArgs e)
        {
            try
            {
                process_method02(0, false, true);
                process_method02(1, false, true);
            }
            catch
            {

            }
        }

       
    }
}
