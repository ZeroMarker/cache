using System;
using System.Web;
using System.IO;
using System.Web.SessionState;
using System.Web.Services;

namespace WebApp
{
    /// <summary>
    /// $codebehindclassname$ 的摘要说明
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class Example : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/html";

            string jSONString = string.Empty;
            try
            {

                if (HttpContext.Current.Request.Files.Count > 0)
                {
                    HttpPostedFile postedFile = HttpContext.Current.Request.Files[0];
                    string savePath;
                    savePath = context.Server.MapPath("UpLoad/");
                    savePath += Path.GetFileName(postedFile.FileName);

                    //检查是否在服务器上已经存在用户上传的同名文件
                    if (System.IO.File.Exists(savePath))
                    {
                        File.Delete(savePath);
                    }
                    postedFile.SaveAs(savePath);

                    jSONString = "{success:true,msg:'上传成功'}";

                    //jSONString = "{success:false,message:'上传失败,可能因为上传文件过大导致!'}";
                }
            }
            catch (Exception e)
            {
                jSONString = "{success:false,msg:'上传失败,失败代码为：" + e.Message + "'}";

            }//catch

            context.Response.Write(jSONString);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}
