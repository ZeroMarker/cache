using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;


namespace WebApp
{

    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // string datastr=FileToData(Server.MapPath("neteaselogo.gif"));

            //  DataToFile(datastr,Server.MapPath("logo.gif"));
            upfile();

        }
        public static string FileToData(string path)
        {
            if (File.Exists(path))
            {
                FileStream fs = new FileStream(path, FileMode.Open, FileAccess.Read);
                int fileLenght = Convert.ToInt32(fs.Length);
                byte[] bytes = new byte[fileLenght];
                BinaryReader br = new BinaryReader(fs);
                for (int i = 0; i <= fileLenght; i++)
                {
                    br.Read(bytes, 0, fileLenght);
                }
                string strdata = Convert.ToBase64String(bytes);
                fs.Close();
                br.Close();
                return strdata;
            }
            return null;
        }
        public void DataToFile(string strdata, string path)
        {
            FileStream fs = new FileStream(path, FileMode.Create, FileAccess.Write);
            BinaryWriter bw = new BinaryWriter(fs);
            bw.Write(Convert.FromBase64String(strdata));
            Response.OutputStream.Write(Convert.FromBase64String(strdata), 0, strdata.Length);
            bw.Close();
            fs.Close();
        }
        public void upfile()
        {
            System.IO.Stream iStream = null;

            // Buffer to read 10K bytes in chunk:
            byte[] buffer = new Byte[10240];

            // Length of the file:
            int length;

            // Total bytes to read:
            long dataToRead;

            // Identify the file to download including its path.
            string filepath = @"D:\实用工具\office2007pro.zip";

            // Identify the file name.
            string filename = System.IO.Path.GetFileName(filepath);

            try
            {
                // Open the file.
                iStream = new FileStream(filepath, System.IO.FileMode.Open,FileAccess.Read, FileShare.Read);
                Response.Clear();

                // Total bytes to read:
                dataToRead = iStream.Length;

                long p = 0;
                if (Request.Headers["Range"] != null)
                {
                    Response.StatusCode = 206;
                    p = long.Parse(Request.Headers["Range"].Replace("bytes=", "").Replace("-", ""));
                }
                if (p != 0)
                {
                    Response.AddHeader("Content-Range", "bytes " + p.ToString() + "-" + ((long)(dataToRead - 1)).ToString() + "/" + dataToRead.ToString());
                }
                Response.AddHeader("Content-Length", ((long)(dataToRead - p)).ToString());
                Response.ContentType = "application/octet-stream";
                Response.AddHeader("Content-Disposition", "attachment; filename=" + System.Web.HttpUtility.UrlEncode(Request.ContentEncoding.GetBytes(filename)));

                iStream.Position = p;
                dataToRead = dataToRead - p;
                // Read the bytes.
                while (dataToRead > 0)
                {
                    // Verify that the client is connected.
                    if (Response.IsClientConnected)
                    {
                        // Read the data in buffer.
                        length = iStream.Read(buffer, 0, 10240);

                        // Write the data to the current output stream.
                        Response.OutputStream.Write(buffer, 0, length);

                        // Flush the data to the HTML output.
                        Response.Flush();

                        buffer = new Byte[10240];
                        dataToRead = dataToRead - length;
                    }
                    else
                    {
                        //prevent infinite loop if user disconnects
                        dataToRead = -1;
                    }
                }
            }
            catch (Exception ex)
            {
                // Trap the error, if any.
                Response.Write("Error : " + ex.Message);
            }
            finally
            {
                if (iStream != null)
                {
                    //Close the file.
                    iStream.Close();
                }
                Response.End();
            }
        }
    }
}