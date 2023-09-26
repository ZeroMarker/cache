//ExportAppInfo.js
var SelectedRow = 0;

function BodyLoadHandler() {
	var obj=document.getElementById('Inport');
	if (obj) obj.onclick=Inport_Click;
	
	
	//var FileStr="郭荣勇,guorongyong,840730-11-15"+"\r\n"+"周莉,zhouli,1984-07-30,wwwww";
	//BuildSF(FileStr);
	//document.body.scroll="Yes"
	
}

function Inport_Click()
{
	//先K掉GLOBLA
	var objKTMP=document.getElementById('KTMP');
	 if(objKTMP)var enumv=objKTMP.value; else enumv="";
	 cspRunServerMethod(enumv);
	
	var fs, f1,Str; 
	    var Temptxt
	    var TempArr
	    //alert(":读取文件并保存");
	    ReplyFile="D:\\ToFuchan.txt"
	    ReplyFile1="D:\\Error.txt"
        fs = new ActiveXObject("Scripting.FileSystemObject");
        if (fs.FileExists(ReplyFile)){
	        f1=fs.OpenTextFile(ReplyFile,"1");
	        do {       
               Str = f1.ReadLine();
               //alert(Str);
               if(Str=="")continue;
              var obj=document.getElementById('GetInExport');
	          if(obj)var enumv=obj.value; else enumv="";
		      var rtn=cspRunServerMethod(enumv,Str);
		      if(rtn!=0)
		      {
			      if(rtn=="-201")rtn="预约失败!";
			      alert("导入错误"+rtn);
			      if (!fs.FileExists(ReplyFile1))fs.CreateTextFile(ReplyFile1, true);
			      f2=fs.OpenTextFile(ReplyFile1,"8");
			      f2.WriteLine(Str+"!!!"+rtn);
			      f2.Close();
		      }
               
            } while  ((!f1.AtEndOfStream)||(Str=="end"))
            alert('导入完成!');
            f1.Close();
	    }
 // window.reload;
}

//写文件函数
function BuildSF(FileTxt)     //写文件
   {	  
	  var ReplyFile
	  var fs, f1
	  var itmString,CountString
	  var TempList
	  ReplyFile="D:\\test.txt"
      fs = new ActiveXObject("Scripting.FileSystemObject");
	  if (fs.FileExists(ReplyFile)){
		    fs.DeleteFile(ReplyFile,false);
		    }
	  f1=fs.CreateTextFile(ReplyFile, true); 
	  f1.WriteLine(FileTxt);                             //FileTxt是要写的外部串入的串
	  f1.Close();
	  alert("生成导出文件成功!"); 	  
	  return true;
   }
 //读文件函数
function ReadSF()
   {	   
	    var fs, f1,s; 
	    var Temptxt
	    var TempArr
	    //alert(":读取文件并保存");
	    ReplyFile="d:\\test.txt"
        fs = new ActiveXObject("Scripting.FileSystemObject");
        if (fs.FileExists(ReplyFile)){
	        f1=fs.OpenTextFile(ReplyFile,"1");
	        do {       
               s = f1.ReadLine();
               alert(s); 
               
            } while  (! f1.AtEndOfStream)
            
            f1.Close();
	    }
   }

function ShowTotal()
{
	var objtbl=document.getElementById('tDHCOPDro');
	var rows=objtbl.rows.length;
	if (rows>1) {
		var TobjTotal=document.getElementById("TTotalz"+1);
    	//alert(TobjTotal.innerText)
		
		var objTotal=document.getElementById('Total');
    	if (objTotal) objTotal.value=TobjTotal.value;
	}
}

function CleartAppoint()
{
	var obj=document.getElementById('Gfind');
	if (obj) obj.checked=false 
	var obj=document.getElementById('Tfind');
	if (obj) obj.checked=false
}
function Quit_click()
{
  window.close();
}
function DocumentUnloadHandler(e){
	 
	
}


document.body.onload = BodyLoadHandler;
document.body.onunload = DocumentUnloadHandler;
