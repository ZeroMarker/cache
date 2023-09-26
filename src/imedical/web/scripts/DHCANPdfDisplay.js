
 //document.write("<object id='DownloadPdf' classid='clsid:C54DEA4A-1203-43AA-9D92-C84AC9358E54' codebase='../service/DHCClinic/App/AN/DHCANActiveX.cab' >")
 document.write("<object id='DownloadPdf' classid='../service/DHCClinic/App/AN/DownloadFtpFiles.dll#DownloadFtpFiles.ManageFtp' VIEWASTEXT/>")
 document.write("</object>");
function BodyLoadHandler()
{  
  var opStartDate=document.getElementById('opStartDate').value;
  var dtArr=opStartDate.split("/");
  
  var year0=parseInt(dtArr[2],10)
  var month0=parseInt(dtArr[1],10)
  var day0=parseInt(dtArr[0],10)
  //alert(year0+"/"+month0+"/"+day0)
  var datetime=new Date(year0,month0-1,day0);
 
  var year=datetime.getFullYear();
  var month=datetime.getMonth()+1;
  //alert(month)
  var day=datetime.getDate(); 
  //alert(day)
  var remoteDir=year+"-"+month+"-"+day;
   //alert(remoteDir)
  var opaId=document.getElementById('opaId').value;
    DownloadPdf.UserName="DHCANOP";
    DownloadPdf.Password="CMUDHCANOP";
    DownloadPdf.FtpUrl="ftp://172.26.201.1:23";
    DownloadPdf.RemoteDirectory=remoteDir;
    DownloadPdf.LocalPath="C:\\Download";
    DownloadPdf.FileName=opaId;
    var ret=""
    ret=DownloadPdf.GetFtpFiles();
    if(ret!="1") 
   {
    //if(ret=="0") alert(t['alert:noPdf'])
    //else alert(ret);
   }
  var pdfObjStr=PdfText("C:\\Download\\"+opaId+".pdf");
  document.write(pdfObjStr)
}
function PdfText(pdfname)
        {
            var txt="<object   classid='clsid:CA8A9780-280D-11CF-A24D-444553540000' scrolling='auto' width='100%' height='100%'>"  //width='1024' height='768' border='2'          
                      +"<param   name='SRC' value='"
                      +pdfname 
                      +"'>"     
                    +"<\/object>";
            return txt;
        }
document.body.onload = BodyLoadHandler;