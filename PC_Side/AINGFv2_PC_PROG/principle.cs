using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using System.Windows.Forms;


namespace AINGFv2_PC_PROG
{
    class principle
    {
        

        public int max_history_count = 20;

        public void set_max_history(int val)
        {
            max_history_count = val;
        }

        public int get_max_history()
        {
            return max_history_count;
        }
        public Image create_Cbitmap(int w, int h, int clr)
        {
            Bitmap bmp = new Bitmap(w, h);
            int size = get_image_array_count(bmp), lw = get_line_width(bmp);
            byte[] dst = new byte[size];
            int t;
            for (int ww = 0; ww < w; ww++)
            {
                for (int hh = 0; hh < h; hh++)
                {
                    t = hh * lw + ww * 3;
                    dst[t] = (byte)clr;
                }
            }
            return write_image(bmp, dst);
        }

        public Image create_bitmap(Image img, int w,int h, int backcolor)
        {
            Bitmap bmp = new Bitmap(img.Width,img.Height,System.Drawing.Imaging.PixelFormat.Format24bppRgb);

            int size = get_image_array_count(img), lw = get_line_width(bmp);
            byte[] dst = new byte[size];

            for (int i = 0; i < size; i++)
                dst[i] = (byte)backcolor;
            return write_image(img, dst);
        }
        //============================
        public void copy_array(byte[] dest, byte[] src)
        {
            int last = src.Length;
            for (int i = 0; i < last; i++)
            {
                dest[i] = src[i];
            }
        }
        //============================
        public bool cmp_array(byte[] src1, byte[] src2)
        {
            int last = src1.Length;
            bool rslt = true;
            for (int i = 0; i < last; i++)
            {
                if (src1[i] != src2[i])
                { 
                    rslt = false; 
                    break; 
                }
            }
            return rslt;
        }
        //-----------------------
        public void init_image(Image img)
        {
            if (img != null)
            {
                img.Dispose();
            }
        }
        //=============================--------------- Read_Image ----------------------=======================================
        public void read_image(Image img, byte[] array)
        {
            Bitmap bmp = new Bitmap(img);
            Rectangle rect = new Rectangle(0, 0, bmp.Width, bmp.Height);
            System.Drawing.Imaging.BitmapData bmpData =
            bmp.LockBits(rect, System.Drawing.Imaging.ImageLockMode.ReadWrite,
            img.PixelFormat);
            
            IntPtr ptr = bmpData.Scan0;
            int bytes = bmpData.Stride * bmpData.Height;
            System.Runtime.InteropServices.Marshal.Copy(ptr, array, 0, bytes);
            bmp.UnlockBits(bmpData);
            bmp.Dispose();
        }
        //=============================--------------- Write_Image ----------------------=======================================
        public Image write_image(Image img, byte[] array)
        {
            Bitmap bmp = new Bitmap(img.Width,img.Height,System.Drawing.Imaging.PixelFormat.Format24bppRgb);
            Rectangle rect = new Rectangle(0, 0, bmp.Width, bmp.Height);
            System.Drawing.Imaging.BitmapData bmpData =
            bmp.LockBits(rect, System.Drawing.Imaging.ImageLockMode.ReadWrite,
            img.PixelFormat);
            IntPtr ptr = bmpData.Scan0;
            int bytes = bmpData.Stride * bmpData.Height;
            System.Runtime.InteropServices.Marshal.Copy(array, 0, ptr, bytes);
            bmp.UnlockBits(bmpData);
            return bmp;

        }
        //=============================--------------- Get_line_Width ----------------------=======================================
        public int get_line_width(Image img)
        {
            Bitmap bmp = new Bitmap(img);
            Rectangle rect = new Rectangle(0, 0, bmp.Width, bmp.Height);
            System.Drawing.Imaging.BitmapData bmpData =
            bmp.LockBits(rect, System.Drawing.Imaging.ImageLockMode.ReadWrite,
            System.Drawing.Imaging.PixelFormat.Format24bppRgb);
            IntPtr ptr = bmpData.Scan0;
            int bytes = bmpData.Stride * bmpData.Height;
            int lw = bmpData.Stride;
            bmp.UnlockBits(bmpData);
            bmp.Dispose();
            return lw;
        }
        //=============================--------------- get_image_array_count ----------------------=======================================
        public int get_image_array_count(Image img)
        {
            Bitmap bmp = new Bitmap(img);
            Rectangle rect = new Rectangle(0, 0, bmp.Width, bmp.Height);
            System.Drawing.Imaging.BitmapData bmpData =
            bmp.LockBits(rect, System.Drawing.Imaging.ImageLockMode.ReadWrite,
            System.Drawing.Imaging.PixelFormat.Format24bppRgb);
            IntPtr ptr = bmpData.Scan0;
            int bytes = bmpData.Stride * bmpData.Height;
            bmp.UnlockBits(bmpData);
            bmp.Dispose();
            return bytes;
        }
        //=============================--------------- get_image ----------------------=======================================
        public Image get_image(string adr)
        {
            try
            {
                Image img = Image.FromFile(adr);
                Bitmap bmp1 =(Bitmap) img;
                Bitmap bmp2;
                bmp2 = bmp1.Clone(new Rectangle(0, 0, img.Width, img.Height), System.Drawing.Imaging.PixelFormat.Format24bppRgb);
                img.Dispose();
                bmp1.Dispose();
                return (bmp2);
                
            }
            catch
            {
                return null;
            }
        }



        //===========
        public Image resize_img(Image src, int dest_w, int dest_h) //memory eater!
        {
            Bitmap dstt = new Bitmap(src,dest_w, dest_h);
            Bitmap dst = dstt.Clone(new Rectangle(0, 0, dstt.Width, dstt.Height), System.Drawing.Imaging.PixelFormat.Format24bppRgb);
            Graphics grp = Graphics.FromImage(dst);
            grp.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.None;
            grp.DrawImage(src, new Rectangle(0, 0, dest_w, dest_h));

            grp.Dispose();
            dstt.Dispose();
            return dst;
        }
        //===========
        public void resize_imgEX(out Image dest, Image src, int dest_w, int dest_h) //fixed memory eating bug!
        {
            Bitmap dstt = new Bitmap(src, dest_w, dest_h);
            dest = dstt.Clone(new Rectangle(0, 0, dstt.Width, dstt.Height), System.Drawing.Imaging.PixelFormat.Format24bppRgb);
            Graphics grp = Graphics.FromImage(dest);
            grp.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.None;
            grp.DrawImage(src, new Rectangle(0, 0, dest_w, dest_h));

            grp.Dispose();
            dstt.Dispose();
            
        }
        //===========
        public Bitmap rotateImage(Bitmap b, float angle)
        {
            //create a new empty bitmap to hold rotated image
            Bitmap returnBitmap = new Bitmap(b.Width, b.Height);
            returnBitmap.SetResolution(b.HorizontalResolution, b.VerticalResolution);
            //make a graphics object from the empty bitmap
            Graphics g = Graphics.FromImage(returnBitmap);
            //move rotation point to center of image
            g.TranslateTransform((float)b.Width / 2, (float)b.Height / 2);
            g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBilinear;
            //rotate
            g.RotateTransform(angle);
            g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBilinear;
            g.TranslateTransform(-(float)b.Width / 2, -(float)b.Height / 2);
            g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBilinear;
            //draw passed in image onto graphics object
            g.DrawImage(b, new Point(0, 0));
            g.Dispose();
            return returnBitmap;
        }
        //===========
        public Bitmap rotateImage_ex(Bitmap bmp, float angle, Color bkColor)
        {
            angle = angle % 360;
            if (angle > 180)
                angle -= 360;

            System.Drawing.Imaging.PixelFormat pf = default(System.Drawing.Imaging.PixelFormat);
            if (bkColor == Color.Transparent)
            {
                pf = System.Drawing.Imaging.PixelFormat.Format32bppArgb;
            }
            else
            {
                pf = bmp.PixelFormat;
            }

            float sin = (float)Math.Abs(Math.Sin(angle * Math.PI / 180.0)); // this function takes radians
            float cos = (float)Math.Abs(Math.Cos(angle * Math.PI / 180.0)); // this one too
            float newImgWidth = sin * bmp.Height + cos * bmp.Width;
            float newImgHeight = sin * bmp.Width + cos * bmp.Height;
            float originX = 0f;
            float originY = 0f;

            if (angle > 0)
            {
                if (angle <= 90)
                    originX = sin * bmp.Height;
                else
                {
                    originX = newImgWidth;
                    originY = newImgHeight - sin * bmp.Width;
                }
            }
            else
            {
                if (angle >= -90)
                    originY = sin * bmp.Width;
                else
                {
                    originX = newImgWidth - sin * bmp.Height;
                    originY = newImgHeight;
                }
            }

            Bitmap newImg = new Bitmap((int)newImgWidth, (int)newImgHeight, pf);
            Graphics g = Graphics.FromImage(newImg);
            g.Clear(bkColor);
            g.TranslateTransform(originX, originY); // offset the origin to our calculated values
            g.RotateTransform(angle); // set up rotate
            g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBilinear;
            g.DrawImageUnscaled(bmp, 0, 0); // draw the image at 0, 0
            g.Dispose();

            return newImg;
        }
    }
}
