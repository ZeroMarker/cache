//PMPJobLogChild.js
var userId=session['LOGON.USERID'];
var FileOpenObj = document.getElementById("cOpenFile");
FileOpenObj.innerHTML="<input type='file' id='FileOpen' style='width:300px'/> " 
function BodyLoadHandler(){
	var obj=document.getElementById("NewAdd");
	if (obj){obj.onclick=add_Click;	
	var obj=document.getElementById("Upload");
	if (obj){obj.onclick=Upload_Click;
	}
}
///添加按钮
function add_Click()
{
     
    var Desc = document.getElementById("Desc").value;
    //var User = document.getElementById("User").value;
    var Content = document.getElementById("Content").value;
    var Solution = document.getElementById("Solution").value;
    if(Solution==""){
	    alert("记录内容不能为空！");
	    return;
	    }
	 var fujian=document.getElementById("FileOpen").value;
	 var encmeth = document.getElementById("SaveParaEncrypt").value;
	 alert(encmeth)
	if (encmeth!=""){
		var aa=cspRunServerMethod(encmeth,Desc,userId,Content,Solution,fujian)
		if(aa){
			var VerStrsinn=tkMakeServerCall("web.PMP.PMPImprovementList","EscapingChangechang",fujian);
	        VerStr=VerStrsinn.split("||");
	       if(VerStr!=""){	
	            //alert(VerStr);
		        for(i=0;i<=VerStr.length-1;i++){  
			       VerStrName=VerStr[i].split("\\");
			       name=VerStrName[VerStrName.length-1];
			       vers="D:\\dthealth\\app\\dthis\\fujian\\"
			       var VerStrsinn=tkMakeServerCall("web.PMP.PMPImprovementList","EscapingChange",vers);
			       //added by dongzt ----------------去除路径空格-----------
			  dirc=handleSpace(VerStrName);
			  alert(dirc);
			  LocalDirc=dirc+"\\"+name;
			  aa="copy "+LocalDirc+" "+vers+name;
			//added by dongzt --------------------------------------
			       //aa="copy "+VerStr[i]+" "+VerStrsinn+name;
			       //alert("444")
			       Log(aa)
			       }
			       }
			}else{
				alert("添加失败！");
				return;
				}
				
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=PMPJobLogging";
    window.location.href=lnk;
	}
}
}
///上传附件
function Upload_Click()
{
	alert("12345")
	var FileOpenObj = document.getElementById("OpenFile");
	alert(FileOpenObj.value)
	BrowseFolder();
	
	var VerStrsinn=tkMakeServerCall("web.PMP.PMPImprovementList","EscapingChangechang",VerStrstr);
	  VerStr=VerStrsinn.split("||");
	  if(VerStr!="")
	  {	
	  //alert(VerStr);
		for(i=0;i<=VerStr.length-1;i++)
		{  
			  VerStrName=VerStr[i].split("\\");
			  name=VerStrName[VerStrName.length-1];
			  vers="D:\\dthealth\\app\\dthis\\fujian\\"
			  var VerStrsinn=tkMakeServerCall("web.PMP.PMPImprovementList","EscapingChange",vers);
			  aa="copy "+VerStr[i]+" "+VerStrsinn+name;
			  //alert("444")
			  Log(aa)
		}
}
}
function BrowseFolder() 
{
	   var fd = new ActiveXObject("MSComDlg.CommonDialog");
       fd.Filter = "所有类型(*)"; //過濾文件類型
       fd.filename=""
       fd.FilterIndex = 2;
       fd.MaxFileSize = 128;
       //fd.ShowOpen();//打开对话框
       fd.ShowSave();//保存对话框
       VerStrstr=fd.filename;//fd.filename路径
}
///JS生成bat文件
function Log(url){ 
	var fso=new	ActiveXObject("Scripting.FileSystemObject");
	var LogFolder="D:";
	if(!fso.FolderExists(LogFolder)){
		fso.CreateFolder(LogFolder);     	
	}
    ts=fso.OpenTextFile(LogFolder+"\\"+"cmd.bat",8,true);
	ts.WriteLine("@echo off");
    ts.WriteLine(url);
    ts.WriteLine("del d:\\cmd.bat");
	ts.Close();
	OpenWindow2()
}
function Log1(url){ 
	var fso=new	ActiveXObject("Scripting.FileSystemObject");
	var LogFolder="D:";
	if(!fso.FolderExists(LogFolder)){
		fso.CreateFolder(LogFolder);     	
	}
    ts=fso.OpenTextFile(LogFolder+"\\"+"cmd.bat",8,true);
	ts.WriteLine("@echo off");
    ts.WriteLine(url);
    ts.WriteLine("del d:\\cmd.bat");
	ts.Close();
	OpenWindow3()
}
function OpenWindow2() {
	 s=new  ActiveXObject("WScript.Shell");
	 alert("zhang");    
     s.Run("d:\cmd.bat",0,true);
     alert(t["2"])
}
function OpenWindow3() {
	 s=new  ActiveXObject("WScript.Shell");    
     s.Run("d:\cmd.bat",0,true);
     //alert(t["2"])
}
document.body.onload=BodyLoadHandler;