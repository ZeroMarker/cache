function ExportMinke(){
	var obj = new Object();
	//�������Ŀ¼
	obj.CreatePathIE = function(Path){
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
	obj.CreatePath = function(Path)
	{
		//if (BrowserVer!="isIE11"){
		if (EnableLocalWeb==1) {  //��IE��������������м��
			var arryFolder = Path.split("\\");
			var strPath = arryFolder[0];
			var blnReturn = false;		
				
			var Str ="(function test(x){"+ '\n' 
		    Str +="var objFSO = new ActiveXObject('Scripting.FileSystemObject');"+ '\n'
			for(var i = 1; i < arryFolder.length; i ++)
			{
				if(arryFolder[i] == "") continue;
				strPath += "\\\\" + arryFolder[i];			
				Str +="		if(!objFSO.FolderExists('"+strPath+"')){"+ '\n'  
				Str +="			objFSO.CreateFolder('"+strPath+"');"+ '\n'  //Ϊ���ݹȸ��²㼶����������һ���ǡ�\\\\��,�����ź���Ҫ��ֵ����''����������ʹ��
				Str +="		}"+ '\n'				
			}
			Str += "return 1;}());";
			CmdShell.notReturn =0;   
			var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ����
			if (rtn.status=="200") {
				blnReturn = true;
			}else {
				blnReturn = false;
			}
			objFSO = null;
			return blnReturn;
		}else{
			obj.CreatePathIE(Path);
		}
	}	
	obj.WriteFileIE = function(FileName, Contents){
		var objFSO = new ActiveXObject("Scripting.FileSystemObject");
		var objTxt = objFSO.CreateTextFile(FileName);
		objTxt.WriteLine(Contents);
		objTxt.Close();
		objFSO = null;
	}
	obj.WriteFile = function(FileName, Contents)
	{
		//if (BrowserVer!="isIE11"){
		if (EnableLocalWeb==1) {  //��IE��������������м��
		//���з�\r\nӰ�쵼�����������������쳣:δ�������ַ��������������滻Ϊ\n
			var arryPath = FileName.split("\\");
			var FileName = arryPath[0];
			for(var i = 1; i < arryPath.length; i ++){
				if(arryPath[i] == "") continue;
				FileName += "\\\\" + arryPath[i];		
			}
	
			var reg = new RegExp("\r\n","g")
			
			
			
			var Contents=Contents.replace(reg,"\\n");
			var Str ="(function test(x){"
			Str += "var objFSO = new ActiveXObject('Scripting.FileSystemObject');"
			console.log(objFSO);
			//Str += "var objTxt = objFSO.CreateTextFile('"+FileName+"',true,false);" //�ǳ����׳������������ź���Ҫ��ֵ����''����������ʹ��
			Str += "var objTxt = objFSO.CreateTextFile('"+FileName+"');" //�ǳ����׳������������ź���Ҫ��ֵ����''����������ʹ��
			Str += "objTxt.WriteLine('"+Contents+"');"  //�����л��з������������ź���Ҫ��ֵ����''����������ʹ��
			Str += "objTxt.Close();"
			Str += "objFSO = null;"
	        Str += "return 1;}());";
			CmdShell.notReturn =0;  
			var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ���� 
			//var rtn = CurrentUserEvalJs(Str);
		}else{
			obj.WriteFileIE(FileName, Contents);
		}
	}
	
	obj.ExportMinkeData = function(ReportID, ExportPath,ReptList)
	{
		//var strTmp = $.Tool.RunServerMethod("DHCHAI.MK.ExportToMKSrv", "ExportReport", ReportID,ReptList);
		var strTmp = $m({
				ClassName:"DHCHAI.MK.ExportToMKSrv",
				MethodName:"ExportReport",
				aReport:ReportID,
				aReportIDList:ReptList
			},false)
		
		if (!strTmp) return false;   //ֻ����˺��ύ�ı����֧�ֵ���
		//var DEscdss=strTmp.split("^")[4];
		//alert(DEscdss);
		
		strTmp = ExtTool.ReplaceText(strTmp, String.fromCharCode(2), "\r\n");
		strTmp = ExtTool.ReplaceText(strTmp, "^", "\t");
		var arryFile = strTmp.split(String.fromCharCode(1));
		if(arryFile[0] == "FETAL") //���������޷���������
		{
			return false;
		}
		/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE�����
			obj.CreatePathIE(ExportPath);
		}else{
			obj.CreatePath(ExportPath);
		}*/
		obj.CreatePath(ExportPath);
		var strPath = ExportPath;
		
		//�ж������Ƿ�Ϊ�գ���Ϊ�յ��������򲻵���
		if(arryFile[0]!=""){
			
			/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE�����
				obj.WriteFileIE(strPath+ "\\���˻�����Ϣ.txt", arryFile[0]);
			}else{
				obj.WriteFile(strPath+ "\\���˻�����Ϣ.txt", arryFile[0]);
			}*/
			obj.WriteFile(strPath+ "\\���˻�����Ϣ.txt", arryFile[0]);
		}
		if(arryFile[1]!=""){
			/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE�����
				obj.WriteFileIE(strPath + "\\��������.txt", arryFile[1]);
			}else{
				obj.WriteFile(strPath + "\\��������.txt", arryFile[1]);
			}*/
			obj.WriteFile(strPath + "\\��������.txt", arryFile[1]);
		}
		if(arryFile[2]!=""){
			/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE�����
				obj.WriteFileIE(strPath + "\\�������.txt", arryFile[2]);
			}else{
				obj.WriteFile(strPath+ "\\�������.txt", arryFile[2]);
			}*/
			obj.WriteFile(strPath+ "\\�������.txt", arryFile[2]);
		}
		if(arryFile[3]!=""){
			/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE�����
				obj.WriteFileIE(strPath + "\\�׸�����.txt", arryFile[3]);
			}else{
				obj.WriteFile(strPath+ "\\�׸�����.txt", arryFile[3]);
			}*/
			obj.WriteFile(strPath+ "\\�׸�����.txt", arryFile[3]);
		}
		if(arryFile[4]!=""){
			/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE�����
				obj.WriteFileIE(strPath + "\\�ֺ��Բ���.txt", arryFile[4]);
			}else{
				obj.WriteFile(strPath+ "\\�ֺ��Բ���.txt", arryFile[4]);
			}*/
			obj.WriteFile(strPath+ "\\�ֺ��Բ���.txt", arryFile[4]);
		}
		if(arryFile[5]!=""){
			/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE�����
				obj.WriteFileIE(strPath + "\\��Ⱦ��λ��ϸ���.txt", arryFile[5]);
			}else{
				obj.WriteFile(strPath+ "\\��Ⱦ��λ��ϸ���.txt", arryFile[5]);
			}*/
			obj.WriteFile(strPath+ "\\��Ⱦ��λ��ϸ���.txt", arryFile[5]);
		}
		if(arryFile[6]!=""){
			/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE�����
				obj.WriteFileIE(strPath + "\\��Ⱦ��λ��ص��ֺ��Բ���.txt", arryFile[6]);
			}else{
				obj.WriteFile(strPath + "\\��Ⱦ��λ��ص��ֺ��Բ���.txt", arryFile[6]);
			}*/
			obj.WriteFile(strPath + "\\��Ⱦ��λ��ص��ֺ��Բ���.txt", arryFile[6]);
		}
		if(arryFile[7]!=""){
			/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE�����
				obj.WriteFileIE(strPath + "\\���걾��ϸ���.txt", arryFile[7]);
			}else{
				obj.WriteFile(strPath + "\\���걾��ϸ���.txt", arryFile[7]);
			}*/
			obj.WriteFile(strPath + "\\���걾��ϸ���.txt", arryFile[7]);
		}
		if(arryFile[8]!=""){
			/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE�����
				obj.WriteFileIE(strPath + "\\�걾�����Ĳ�ԭ����ϸ���.txt", arryFile[8]);
			}else{
				obj.WriteFile(strPath+ "\\�걾�����Ĳ�ԭ����ϸ���.txt", arryFile[8]);
			}*/
			obj.WriteFile(strPath+ "\\�걾�����Ĳ�ԭ����ϸ���.txt", arryFile[8]);
		}
		if(arryFile[9]!=""){
			/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE�����
				obj.WriteFileIE(strPath + "\\ҩ��������.txt", arryFile[9]);
			}else{
				obj.WriteFile(strPath + "\\ҩ��������.txt", arryFile[9]);
			}*/
			obj.WriteFile(strPath + "\\ҩ��������.txt", arryFile[9]);
		}
		if(arryFile[10]!=""){
			/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE�����
				obj.WriteFileIE(strPath + "\\����ҩ��ʹ�����.txt", arryFile[10]);
			}else{
				obj.WriteFile(strPath + "\\����ҩ��ʹ�����.txt", arryFile[10]);
			}*/	
			obj.WriteFile(strPath + "\\����ҩ��ʹ�����.txt", arryFile[10]);
		}
		return true;
	}
	
	obj.ExportICUMinkeData = function(ReportID,ExportPath,ReptList)
	{
		
		var IcuStr=''      
		//var IcuStr=Indate+"^"+Disdate+"^"+ICULocdesc+"^"+APACHEScore+"^"+AdmLocID
		//var strTmp = $.Tool.RunServerMethod("DHCHAI.MK.ExportToMKSrv", "ExportICUReport", ReportID,ReptList,IcuStr);
		
		
		var strTmp = $m({
				ClassName:"DHCHAI.MK.ExportToMKSrv",
				MethodName:"ExportICUReport",
				aReport:ReportID,
				aReportIDList:ReptList,
				IcuStr:IcuStr
			},false)
			
		if (!strTmp) return false;   //ֻ����˺��ύ�ı����֧�ֵ���
		
		strTmp = ExtTool.ReplaceText(strTmp, String.fromCharCode(2), "\r\n");
		strTmp = ExtTool.ReplaceText(strTmp, "^", "\t");
		var arryFile = strTmp.split(String.fromCharCode(1));
		if(arryFile[0] == "FETAL") //���������޷���������
		{
			return false;
		}
		//alert(ExportPath)
		obj.CreatePath(ExportPath);
		var strPath = ExportPath;
		//�ж������Ƿ�Ϊ�գ���Ϊ�յ��������򲻵���
		if(arryFile[0]!=""){
			obj.WriteFile(strPath + "\\���˻�����Ϣ.txt", arryFile[0]);
		}
		
		//alert(arryFile[1])
		if(arryFile[1]!=""){
			obj.WriteFile(strPath + "\\ICU���˻������.txt", arryFile[1]);
		}
		if(arryFile[2]!=""){
			obj.WriteFile(strPath + "\\��������.txt", arryFile[2]);
		}
		if(arryFile[3]!=""){
			obj.WriteFile(strPath + "\\���ľ���������.txt", arryFile[3]);
		}
		if(arryFile[4]!=""){
			obj.WriteFile(strPath + "\\������ʹ�����.txt", arryFile[4]);
		}
		if(arryFile[5]!=""){
			obj.WriteFile(strPath + "\\�����ʹ�����.txt", arryFile[5]);
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