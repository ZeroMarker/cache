function ExportMinke(){
	var obj = new Object();
	
	//创建存放目录
	obj.CreatePath = function(Path)
	{
		var objFSO = new ActiveXObject("Scripting.FileSystemObject");
		var arryFolder = Path.split("\\");
		var strPath = arryFolder[0];
		var blnReturn = false;
		try
		{
			for(var i = 1; i < arryFolder.length; i ++)
			{
				if(arryFolder[i] == "")
					continue;
				strPath += "\\" + arryFolder[i];
				if(!objFSO.FolderExists(strPath))
					objFSO.CreateFolder(strPath);
			}
			blnReturn = true;
		}catch(err)
		{
			blnReturn = false;
		}
		objFSO = null;
		return blnReturn;
	}	
	
	obj.WriteFile = function(FileName, Contents)
	{
		var objFSO = new ActiveXObject("Scripting.FileSystemObject");
		var objTxt = objFSO.CreateTextFile(FileName);
		objTxt.WriteLine(Contents);
		objTxt.Close();
		objFSO = null;
	}
	
	obj.ExportMinkeData = function(ReportID, ExportPath)
	{
		var strTmp = ExtTool.RunServerMethod("DHCMed.NINFService.Srv.ExportMinKeCss", "ExportReport", ReportID);
		strTmp = ExtTool.ReplaceText(strTmp, String.fromCharCode(2), "\r\n");
		strTmp = ExtTool.ReplaceText(strTmp, "^", "\t");
		var arryFile = strTmp.split(String.fromCharCode(1));
		if(arryFile[0] == "FETAL") //致命错误，无法导出数据
		{
			return false;
		}
		
		obj.CreatePath(ExportPath);
		var strPath = ExportPath;
		obj.WriteFile(strPath + "\\病人基本信息.txt", arryFile[0]);
		if (arryFile[1] != '') {
			obj.WriteFile(strPath + "\\基础疾病.txt", arryFile[1]);
		}
		if (arryFile[2] != '') {
			obj.WriteFile(strPath + "\\病原学检验.txt", arryFile[2]);
		}
		return true;
	}
	
	obj.LaunchMinkeInterface = function(Path)
	{
		var strInterfacePath = "C:\\Program Files\\minke\\医院感染监控管理系统\\yginterface.exe";
		var objFSO = new ActiveXObject("Scripting.FileSystemObject");
		if(objFSO.FileExists(strInterfacePath))
		{
			Ext.MessageBox.show({
				closable : false,
				modal : true,
				msg : '程序已启动民科接口程序，请在接口程序中进行完操作。当退出民科接口程序后，本窗口会自动关闭，并清理先前生成的文件。' +
					'患者的接口文件已存放在【<a href="file:///' + Path + '">' + Path + '</a>】文件夹下。',
				title : '提示'
			});
			var WshShell = new ActiveXObject("WScript.Shell");
			var oExec = WshShell.Exec(strInterfacePath +  " " + Path);					
			var handler = window.setInterval(
				function()
				{
					if(oExec.Status == 0)
						return;
					obj.ClearFiles(Path);
					Ext.MessageBox.hide();
					ExtTool.alert("提示", "操作完成，垃圾文件已清理！", Ext.MessageBox.INFO);
					window.clearInterval(handler);
				}
			, 1000);
		}else{
			ExtTool.alert("提示", "无法启动民科的接口程序，您需要手工将这些文件拷贝到相应的电脑中导入！", Ext.MessageBox.INFO);
			var WshShell = new ActiveXObject("WScript.Shell");
			var oExec = WshShell.Exec("explorer.exe " + Path);	
		}
	}
	
	obj.ClearFiles = function(Path)
	{
		var objFSO = new ActiveXObject("Scripting.FileSystemObject");
	   f = objFSO.GetFolder(Path);
	   fc = new Enumerator(f.SubFolders);
	   s = "";
	   for (;!fc.atEnd(); fc.moveNext())
	   {
			 var objFolder = fc.item();
			 objFSO.DeleteFolder(objFolder.Path);
	   }
		return true;
		
	}
	
	return obj;	
}