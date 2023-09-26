

//add by dongzt
//PMPCommon.js
//处理项目管理系统的公共JS

//add by dongzt 处理路径由于带有空格，导致上传失败的问题
function handleSpace(VerStrName)
{
	 //alert(VerStrName);
	 var dirc;
	 try {
			  var verLength=VerStrName.length-1;
			  
			 for(var jk=0;jk<verLength;jk++)
			  {
				  //alert(VerStrName[jk]);
				  //alert(VerStrName[jk].indexOf(" ")==-1);
				  if (VerStrName[jk].indexOf(" ")==-1)
				  {
					  
				  }
				  else
				  {
					  VerStrName[jk]="\""+VerStrName[jk]+"\"";
				  }
				  if (dirc)
				  {
					  dirc=dirc+"\\"+VerStrName[jk];
				  }
				  else
				  {
					  dirc=VerStrName[jk];
				  }
				  
				  //subst w: "C:\Documents and Settings\hopeshared"
			  }
		
			  return dirc;
			  
	 }
	 catch (e) {
 		alert(e.name + ": " + e.message);
	}
}




///JS生成bat文件
function CreatBat(url){ 
	//var url=url.replace(/(^\s*)|(\s*$)/g, "");
    var listret=tkMakeServerCall("web.PMP.Common","AdjunctIP");
	var user=listret.split("#")[2];
	var IP=listret.split("#")[0];
	var PassWord=listret.split("#")[1];
	var ipurl=listret.split("#")[3];
	var fso=new	ActiveXObject("Scripting.FileSystemObject");
	var LogFolder="D:";
	if(!fso.FolderExists(LogFolder)){
		fso.CreateFolder(LogFolder);     	
	}
    ts=fso.OpenTextFile(LogFolder+"\\"+"cmd.bat",8,true);
	ts.WriteLine("@echo off");
	//ts.WriteLine("net use \\\\127.0.0.1\\ipc$ "+'"'+"zhangkui"+'"'+" /user:"+'"'+"administrator"+'"');
	ts.WriteLine("net use \\\\"+IP+"\\ipc$ "+'"'+PassWord+'"'+" /user:"+'"'+user+'"');
    ts.WriteLine(url);
    ts.WriteLine("net use \\\\"+IP+"\\ipc$ /delete");
    //ts.WriteLine("net use \\\\127.0.0.1\\ipc$ /delete");
    ts.WriteLine("del d:\\cmd.bat");
	ts.Close();
	OpenWindow2()
}
function OpenWindow2() {
	 s=new  ActiveXObject("WScript.Shell"); 
	 //alert("执行")   
     s.Run("d:\cmd.bat",0,true);
    // alert(t["2"])
}