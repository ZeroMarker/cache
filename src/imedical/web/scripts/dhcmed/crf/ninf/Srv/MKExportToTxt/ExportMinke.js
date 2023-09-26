function ExportMinke(){
	var obj = new Object();
	
	//�������Ŀ¼
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
		//Modified By LiYang 2014-07-04 FixBug��1714 ҽԺ��Ⱦ����-ȫԺ�ۺ��Լ��-��Ⱦ�����ѯ-�����ӿ�ʱ,�ļ�·�������̷������ڣ�һֱ��ʾ"���ڴ���..."
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
		if(arryFile[0] == "FETAL") //���������޷���������
		{
			return false;
		}
		
		obj.CreatePath(ExportPath);
		var strPath = ExportPath;
		obj.WriteFile(strPath + "\\���˻�����Ϣ.txt", arryFile[0]);
		obj.WriteFile(strPath + "\\��������.txt", arryFile[1]);
		obj.WriteFile(strPath + "\\�������.txt", arryFile[2]);
		obj.WriteFile(strPath + "\\�׸�����.txt", arryFile[3]);
		obj.WriteFile(strPath + "\\�ֺ��Բ���.txt", arryFile[4]);
		obj.WriteFile(strPath + "\\��Ⱦ��λ��ϸ���.txt", arryFile[5]);
		obj.WriteFile(strPath + "\\��Ⱦ��λ��ص��ֺ��Բ���.txt", arryFile[6]);
		obj.WriteFile(strPath + "\\���걾��ϸ���.txt", arryFile[7]);
		obj.WriteFile(strPath + "\\�걾�����Ĳ�ԭ����ϸ���.txt", arryFile[8]);
		obj.WriteFile(strPath + "\\ҩ��������.txt", arryFile[9]);
		obj.WriteFile(strPath + "\\����ҩ��ʹ�����.txt", arryFile[10]);
		return true;
	}
	
	//Add By LiYang 2014-04-28 ���ӵ���ICU��ⱨ��Ĺ���
	obj.ExportMinkeDataICU = function(ReportID, ExportPath)
	{
	debugger;
		var strTmp = ExtTool.RunServerMethod("DHCMed.NINFService.Srv.ExportMinkeICUSrv", "ExportReport", ReportID);
		strTmp = ExtTool.ReplaceText(strTmp, String.fromCharCode(2), "\r\n");
		strTmp = ExtTool.ReplaceText(strTmp, "^", "\t");
		var arryFile = strTmp.split(String.fromCharCode(1));
		if(arryFile[0] == "FETAL") //���������޷���������
		{
			return false;
		}
		
		obj.CreatePath(ExportPath);
		var strPath = ExportPath;
		obj.WriteFile(strPath + "\\���˻�����Ϣ.txt", arryFile[0]);
		obj.WriteFile(strPath + "\\ICU����Ĳ��˻������.txt", arryFile[1]);
		obj.WriteFile(strPath + "\\ICU�������.txt", arryFile[2]);
		obj.WriteFile(strPath + "\\���ľ���������.txt", arryFile[3]);
		
		obj.WriteFile(strPath + "\\��������.txt", arryFile[4]);
		obj.WriteFile(strPath + "\\�������.txt", arryFile[5]);
		obj.WriteFile(strPath + "\\�׸�����.txt", arryFile[6]);
		obj.WriteFile(strPath + "\\�ֺ��Բ���.txt", arryFile[7]);
		obj.WriteFile(strPath + "\\��Ⱦ��λ��ϸ���.txt", arryFile[8]);
		obj.WriteFile(strPath + "\\��Ⱦ��λ��ص��ֺ��Բ���.txt", arryFile[9]);
		obj.WriteFile(strPath + "\\���걾��ϸ���.txt", arryFile[10]);
		obj.WriteFile(strPath + "\\�걾�����Ĳ�ԭ����ϸ���.txt", arryFile[11]);
		obj.WriteFile(strPath + "\\ҩ��������.txt", arryFile[12]);
		obj.WriteFile(strPath + "\\����ҩ��ʹ�����.txt", arryFile[13]);		
		
		return true;
	}	
	
	
	
	obj.LaunchMinkeInterface = function(Path)
	{
		var strInterfacePath = "C:\\Program Files\\minke\\ҽԺ��Ⱦ��ع���ϵͳ\\yginterface.exe";
		var objFSO = new ActiveXObject("Scripting.FileSystemObject");
		if(objFSO.FileExists(strInterfacePath))
		{
			Ext.MessageBox.show({
				closable : false,
				modal : true,
				msg : '������������ƽӿڳ������ڽӿڳ����н�������������˳���ƽӿڳ���󣬱����ڻ��Զ��رգ���������ǰ���ɵ��ļ���' +
					'���ߵĽӿ��ļ��Ѵ���ڡ�<a href="file:///' + Path + '">' + Path + '</a>���ļ����¡�',
				title : '��ʾ'
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
					ExtTool.alert("��ʾ", "������ɣ������ļ�������", Ext.MessageBox.INFO);
					window.clearInterval(handler);
				}
			, 1000);
			
		}
		else
		{
			ExtTool.alert("��ʾ", "�޷�������ƵĽӿڳ�������Ҫ�ֹ�����Щ�ļ���������Ӧ�ĵ����е��룡", Ext.MessageBox.INFO);
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