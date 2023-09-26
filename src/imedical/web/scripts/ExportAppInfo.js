//ExportAppInfo.js
var SelectedRow = 0;

function BodyLoadHandler() {
	var obj=document.getElementById('Export');
	if (obj) obj.onclick=Export_Click;
	
	
	//var FileStr="郭荣勇,guorongyong,840730-11-15"+"\r\n"+"周莉,zhouli,1984-07-30,wwwww";
	//BuildSF(FileStr);
	//document.body.scroll="Yes"
	
}

function Export_Click()
{
	var TDeptCode,TDeptDesc,TDocCode,TDocDesc,TTimeRang,TAppAmount,TStartNum,TCTLocDR,TCTPcpDR,TTRRowId,TNum,SessDOW;
	var StrArr="";
	var objtbl=document.getElementById('tExportAppInfo');
	var rows=objtbl.rows.length;
	var obj=document.getElementById('GetNumble');
	if(obj)var enumv=obj.value; else enumv="";
		var rtn=cspRunServerMethod(enumv);
		if(rtn=="")return;
		    TNum=rtn;
	for(var i=0;i<TNum;i++)
	{
		/*TDeptCode=document.getElementById('TDeptCodez'+i).innerText;
		TDeptDesc=document.getElementById('TDeptDescz'+i).innerText;
		TDocCode=document.getElementById('TDocCodez'+i).innerText;
		TDocDesc=document.getElementById('TDocDescz'+i).innerText;
		TTimeRang=document.getElementById('TTimeRangz'+i).innerText;
		TAppAmount=document.getElementById('TAppAmountz'+i).innerText;
		TStartNum=document.getElementById('TStartNumz'+i).innerText;
		
		TCTLocDR=document.getElementById('TCTLocDRz'+i).value;
		TCTPcpDR=document.getElementById('TCTPcpDRz'+i).value;
		TTRRowId=document.getElementById('TTRRowIdz'+i).value;
		*/
		var obj=document.getElementById('GetValue');
		if(obj) enumv=obj.value; else enumv="";
		rtn=cspRunServerMethod(enumv,i);
		var Str=rtn.split('^');
		TDeptCode=Str[0];
		TDeptDesc=Str[1];
		TDocCode=Str[2];
		TDocDesc=Str[3];
		TTimeRang=Str[4];
		TAppAmount=Str[5];
		TStartNum=Str[6];
		SessDOW=Str[7];
		
		StrArr=StrArr+"\r\n"+TDeptCode+"^"+TDeptDesc+"^"+TDocCode+"^"+TDocDesc+"^"+SessDOW+"^"+TTimeRang+"^"+TAppAmount+"^"+TStartNum;
	}

	BuildSF(StrArr);
}

//写文件函数
function BuildSF(FileTxt)     //写文件
   {	  
	  var ReplyFile
	  var fs, f1
	  var itmString,CountString
	  var TempList
	  ReplyFile="D:\\ToAikang.txt"
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
	    alert(":读取文件并保存");
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
function Gfind_Click() {
var obj=document.getElementById('Syn');
var obj1=document.getElementById('Gfind');
var status=obj1.checked;
CleartAppoint();
obj1.checked=status;

if (status) {
	obj.value="1";//
}
else
{
	obj.value="0";
}
var obj2=document.getElementById('Tfind');
var status1=obj2.checked;
if ((status==false)&&(status1==false)) {
	obj.value="2";//
}
}


document.body.onload = BodyLoadHandler;