//张枕平   附件下载
//2015-05-02  
function BrowseFolder(name) {
	 
	 var fd = new ActiveXObject("MSComDlg.CommonDialog");
       fd.Filter = "所有类型(*)"; //過濾文件類型
       fd.filename=name
       fd.FilterIndex = 2;
       fd.MaxFileSize = 128;
       //fd.ShowOpen();//打开对话框
       fd.ShowSave();//保存对话框
       VerStrstr=fd.filename;//fd.filename路径
}
///JS生成bat文件   update by lzt 20150205
function Log(url){ 
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
	OpenWindow()
}
function OpenWindow() {
	 s=new  ActiveXObject("WScript.Shell"); 
	 //alert("执行")   
     s.Run("d:\cmd.bat",0,true);
    // alert(t["2"])
}

