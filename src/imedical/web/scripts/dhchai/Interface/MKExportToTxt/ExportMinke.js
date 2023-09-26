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
		var objFSO = new ActiveXObject("Scripting.FileSystemObject");
		var objTxt = objFSO.CreateTextFile(FileName);
		objTxt.WriteLine(Contents);
		objTxt.Close();
		objFSO = null;
	}
	
	obj.ExportMinkeData = function(ReportID, ExportPath,ReptList)
	{
		var strTmp = $.Tool.RunServerMethod("DHCHAI.MK.ExportToMKSrv", "ExportReport", ReportID,ReptList);
		if (!strTmp) return false;   //ֻ����˺��ύ�ı����֧�ֵ���
		
		strTmp = ExtTool.ReplaceText(strTmp, String.fromCharCode(2), "\r\n");
		strTmp = ExtTool.ReplaceText(strTmp, "^", "\t");
		var arryFile = strTmp.split(String.fromCharCode(1));
		if(arryFile[0] == "FETAL") //���������޷���������
		{
			return false;
		}
		
		obj.CreatePath(ExportPath);
		var strPath = ExportPath;
		//�ж������Ƿ�Ϊ�գ���Ϊ�յ��������򲻵���
		if(arryFile[0]!=""){
			obj.WriteFile(strPath + "\\���˻�����Ϣ.txt", arryFile[0]);
		}
		if(arryFile[1]!=""){
			obj.WriteFile(strPath + "\\��������.txt", arryFile[1]);
		}
		if(arryFile[2]!=""){
			obj.WriteFile(strPath + "\\�������.txt", arryFile[2]);
		}
		if(arryFile[3]!=""){
			obj.WriteFile(strPath + "\\�׸�����.txt", arryFile[3]);
		}
		if(arryFile[4]!=""){
			obj.WriteFile(strPath + "\\�ֺ��Բ���.txt", arryFile[4]);
		}
		if(arryFile[5]!=""){
			obj.WriteFile(strPath + "\\��Ⱦ��λ��ϸ���.txt", arryFile[5]);
		}
		if(arryFile[6]!=""){
			obj.WriteFile(strPath + "\\��Ⱦ��λ��ص��ֺ��Բ���.txt", arryFile[6]);
		}
		if(arryFile[7]!=""){
			obj.WriteFile(strPath + "\\���걾��ϸ���.txt", arryFile[7]);
		}
		if(arryFile[8]!=""){
			obj.WriteFile(strPath + "\\�걾�����Ĳ�ԭ����ϸ���.txt", arryFile[8]);
		}
		if(arryFile[9]!=""){
			obj.WriteFile(strPath + "\\ҩ��������.txt", arryFile[9]);
		}
		if(arryFile[10]!=""){
			obj.WriteFile(strPath + "\\����ҩ��ʹ�����.txt", arryFile[10]);
		}
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
					ExtTool.alert("��ʾ", "������ɣ������ļ���������", Ext.MessageBox.INFO);
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