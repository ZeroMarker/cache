//ExportAppInfo.js
var SelectedRow = 0;

function BodyLoadHandler() {
	var obj=document.getElementById('Inport');
	if (obj) obj.onclick=Inport_Click;
	
	
	//var FileStr="������,guorongyong,840730-11-15"+"\r\n"+"����,zhouli,1984-07-30,wwwww";
	//BuildSF(FileStr);
	//document.body.scroll="Yes"
	
}

function Inport_Click()
{
	//��K��GLOBLA
	var objKTMP=document.getElementById('KTMP');
	 if(objKTMP)var enumv=objKTMP.value; else enumv="";
	 cspRunServerMethod(enumv);
	
	var fs, f1,Str; 
	    var Temptxt
	    var TempArr
	    //alert(":��ȡ�ļ�������");
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
			      if(rtn=="-201")rtn="ԤԼʧ��!";
			      alert("�������"+rtn);
			      if (!fs.FileExists(ReplyFile1))fs.CreateTextFile(ReplyFile1, true);
			      f2=fs.OpenTextFile(ReplyFile1,"8");
			      f2.WriteLine(Str+"!!!"+rtn);
			      f2.Close();
		      }
               
            } while  ((!f1.AtEndOfStream)||(Str=="end"))
            alert('�������!');
            f1.Close();
	    }
 // window.reload;
}

//д�ļ�����
function BuildSF(FileTxt)     //д�ļ�
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
	  f1.WriteLine(FileTxt);                             //FileTxt��Ҫд���ⲿ����Ĵ�
	  f1.Close();
	  alert("���ɵ����ļ��ɹ�!"); 	  
	  return true;
   }
 //���ļ�����
function ReadSF()
   {	   
	    var fs, f1,s; 
	    var Temptxt
	    var TempArr
	    //alert(":��ȡ�ļ�������");
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
