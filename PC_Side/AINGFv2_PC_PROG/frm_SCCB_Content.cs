using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;
namespace AINGFv2_PC_PROG
{
    public partial class frm_SCCB_Content : Form
    {
        public frm_SCCB_Content()
        {
            InitializeComponent();
        }

        private void init_datagrid()
        {
            string[] str = File.ReadAllLines(".\\Data.dat");
            dataGridView1.Rows.Clear();

            dataGridView1.Rows.Add(str.Length);


            for (int i = 0; i < 56; i++)
            {
                string[] cells = str[i].Split(','); // addr(hex), value(hex), desc.
                
                dataGridView1.Rows[i].Cells[0].Value = cells[0];
                dataGridView1.Rows[i].Cells[1].Value = cells[1];
                dataGridView1.Rows[i].Cells[2].Value = cells[2];
                if (cells.Length > 3) dataGridView1.Rows[i].Cells[3].Value = cells[3];
                if (cells.Length > 3) dataGridView1.Rows[i].Cells[4].Value = cells[4];
            }
            dataGridView1.Refresh();

        }

        private void frm_SCCB_Content_Load(object sender, EventArgs e)
        {
            dataGridView1.Rows.Clear();
            dataGridView1.Columns.Clear();




            dataGridView1.Columns.Add("ADDR(HEX)", "ADDR(HEX)");
            dataGridView1.Columns.Add("Value(HEX)", "Value(HEX)");
            dataGridView1.Columns.Add("DESC.", "DESC.");
            dataGridView1.Columns.Add("NOTE.1", "NOTE.1");
            dataGridView1.Columns.Add("NOTE.2", "NOTE.2");

            init_datagrid();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            init_datagrid();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            string[] payload = new string[56];

            for (int i = 0; i < 56; i++)
            {
                int b = dataGridView1.Rows[i].Cells.Count;
                payload[i] =  dataGridView1.Rows[i].Cells[0].Value != null ? dataGridView1.Rows[i].Cells[0].Value.ToString() + "," : ",";
                payload[i] +=  dataGridView1.Rows[i].Cells[1].Value != null ? dataGridView1.Rows[i].Cells[1].Value.ToString() + "," : ",";
                payload[i] += dataGridView1.Rows[i].Cells[2].Value != null ? dataGridView1.Rows[i].Cells[2].Value.ToString() + "," : ",";
                payload[i] += dataGridView1.Rows[i].Cells[3].Value != null ? dataGridView1.Rows[i].Cells[3].Value.ToString() + "," : ",";
                payload[i] += dataGridView1.Rows[i].Cells[4].Value != null ? dataGridView1.Rows[i].Cells[4].Value.ToString(): "";
            }

            File.WriteAllLines(".\\Data.dat",payload);
        }

        /*
        string[] payload = new string[24];

        for (int i = 0; i < 24; i++)
        {
            payload[i] = dataGridView1.Rows[i].Cells[1].Value != null ? dataGridView1.Rows[i].Cells[1].Value.ToString() : "";
        }
         */
    }
}
