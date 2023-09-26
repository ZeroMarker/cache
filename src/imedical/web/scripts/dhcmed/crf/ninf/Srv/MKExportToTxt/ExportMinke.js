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
		//Modified By LiYang 2014-07-04 FixBug：1714 医院感染管理-全院综合性监测-感染报告查询-导出接口时,文件路径名的盘符不存在，一直显示"正在处理..."
		try
		{
		var objFSO = new ActiveXObject("Scripting.FileSystemObject");
		var objTxt = objFSO.CreateTextFile(FileName);
		objTxt.WriteLine(Contents);
		objTxt.Close();
		objFSO = null;
		}catch(err)
		{
			window.alert(err.messaage);
		}
	}
	
	obj.ExportMinkeData = function(ReportID, ExportPath)
	{
		var strTmp = ExtTool.RunServerMethod("DHCMed.NINFService.Srv.ExportMinkeSrv", "ExportReport", ReportID);
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
		obj.WriteFile(strPath + "\\基础疾病.txt", arryFile[1]);
		obj.WriteFile(strPath + "\\手术情况.txt", arryFile[2]);
		obj.WriteFile(strPath + "\\易感因素.txt", arryFile[3]);
		obj.WriteFile(strPath + "\\侵害性操作.txt", arryFile[4]);
		obj.WriteFile(strPath + "\\感染部位详细情况.txt", arryFile[5]);
		obj.WriteFile(strPath + "\\感染部位相关的侵害性操作.txt", arryFile[6]);
		obj.WriteFile(strPath + "\\检测标本详细情况.txt", arryFile[7]);
		obj.WriteFile(strPath + "\\标本检测出的病原体详细情况.txt", arryFile[8]);
		obj.WriteFile(strPath + "\\药敏试验结果.txt", arryFile[9]);
		obj.WriteFile(strPath + "\\抗菌药物使用情况.txt", arryFile[10]);
		return true;
	}
	
	//Add By LiYang 2014-04-28 增加导出ICU检测报告的功能
	obj.ExportMinkeDataICU = function(ReportID, ExportPath)
	{
	debugger;
		var strTmp = ExtTool.RunServerMethod("DHCMed.NINFService.Srv.ExportMinkeICUSrv", "ExportReport", ReportID);
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
		obj.WriteFile(strPath + "\\ICU调查的病人基本情况.txt", arryFile[1]);
		obj.WriteFile(strPath + "\\ICU疾病诊断.txt", arryFile[2]);
		obj.WriteFile(strPath + "\\中心静脉插管情况.txt", arryFile[3]);
		
		obj.WriteFile(strPath + "\\基础疾病.txt", arryFile[4]);
		obj.WriteFile(strPath + "\\手术情况.txt", arryFile[5]);
		obj.WriteFile(strPath + "\\易感因素.txt", arryFile[6]);
		obj.WriteFile(strPath + "\\侵害性操作.txt", arryFile[7]);
		obj.WriteFile(strPath + "\\感染部位详细情况.txt", arryFile[8]);
		obj.WriteFile(strPath + "\\感染部位相关的侵害性操作.txt", arryFile[9]);
		obj.WriteFile(strPath + "\\检测标本详细情况.txt", arryFile[10]);
		obj.WriteFile(strPath + "\\标本检测出的病原体详细情况.txt", arryFile[11]);
		obj.WriteFile(strPath + "\\药敏试验结果.txt", arryFile[12]);
		obj.WriteFile(strPath + "\\抗菌药物使用情况.txt", arryFile[13]);		
		
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
			
		}
		else
		{
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