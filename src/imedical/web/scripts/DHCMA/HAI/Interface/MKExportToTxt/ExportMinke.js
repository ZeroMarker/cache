function ExportMinke(){
	var obj = new Object();
	//创建存放目录
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
		if (EnableLocalWeb==1) {  //非IE浏览器，且启用中间件
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
				Str +="			objFSO.CreateFolder('"+strPath+"');"+ '\n'  //为兼容谷歌下层级正常导出，一定是“\\\\”,标点符号很重要，值都是''引起来才能使用
				Str +="		}"+ '\n'				
			}
			Str += "return 1;}());";
			CmdShell.notReturn =0;   
			var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序
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
		if (EnableLocalWeb==1) {  //非IE浏览器，且启用中间件
		//换行符\r\n影响导出，报错“处理请求异常:未结束的字符串常量”，需替换为\n
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
			//Str += "var objTxt = objFSO.CreateTextFile('"+FileName+"',true,false);" //非常容易出错！！！标点符号很重要，值都是''引起来才能使用
			Str += "var objTxt = objFSO.CreateTextFile('"+FileName+"');" //非常容易出错！！！标点符号很重要，值都是''引起来才能使用
			Str += "objTxt.WriteLine('"+Contents+"');"  //不能有换行符！！！标点符号很重要，值都是''引起来才能使用
			Str += "objTxt.Close();"
			Str += "objFSO = null;"
	        Str += "return 1;}());";
			CmdShell.notReturn =0;  
			var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
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
		
		if (!strTmp) return false;   //只有审核和提交的报告才支持导出
		//var DEscdss=strTmp.split("^")[4];
		//alert(DEscdss);
		
		strTmp = ExtTool.ReplaceText(strTmp, String.fromCharCode(2), "\r\n");
		strTmp = ExtTool.ReplaceText(strTmp, "^", "\t");
		var arryFile = strTmp.split(String.fromCharCode(1));
		if(arryFile[0] == "FETAL") //致命错误，无法导出数据
		{
			return false;
		}
		/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE浏览器
			obj.CreatePathIE(ExportPath);
		}else{
			obj.CreatePath(ExportPath);
		}*/
		obj.CreatePath(ExportPath);
		var strPath = ExportPath;
		
		//判断内容是否为空，不为空导出，否则不导出
		if(arryFile[0]!=""){
			
			/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE浏览器
				obj.WriteFileIE(strPath+ "\\病人基本信息.txt", arryFile[0]);
			}else{
				obj.WriteFile(strPath+ "\\病人基本信息.txt", arryFile[0]);
			}*/
			obj.WriteFile(strPath+ "\\病人基本信息.txt", arryFile[0]);
		}
		if(arryFile[1]!=""){
			/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE浏览器
				obj.WriteFileIE(strPath + "\\基础疾病.txt", arryFile[1]);
			}else{
				obj.WriteFile(strPath + "\\基础疾病.txt", arryFile[1]);
			}*/
			obj.WriteFile(strPath + "\\基础疾病.txt", arryFile[1]);
		}
		if(arryFile[2]!=""){
			/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE浏览器
				obj.WriteFileIE(strPath + "\\手术情况.txt", arryFile[2]);
			}else{
				obj.WriteFile(strPath+ "\\手术情况.txt", arryFile[2]);
			}*/
			obj.WriteFile(strPath+ "\\手术情况.txt", arryFile[2]);
		}
		if(arryFile[3]!=""){
			/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE浏览器
				obj.WriteFileIE(strPath + "\\易感因素.txt", arryFile[3]);
			}else{
				obj.WriteFile(strPath+ "\\易感因素.txt", arryFile[3]);
			}*/
			obj.WriteFile(strPath+ "\\易感因素.txt", arryFile[3]);
		}
		if(arryFile[4]!=""){
			/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE浏览器
				obj.WriteFileIE(strPath + "\\侵害性操作.txt", arryFile[4]);
			}else{
				obj.WriteFile(strPath+ "\\侵害性操作.txt", arryFile[4]);
			}*/
			obj.WriteFile(strPath+ "\\侵害性操作.txt", arryFile[4]);
		}
		if(arryFile[5]!=""){
			/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE浏览器
				obj.WriteFileIE(strPath + "\\感染部位详细情况.txt", arryFile[5]);
			}else{
				obj.WriteFile(strPath+ "\\感染部位详细情况.txt", arryFile[5]);
			}*/
			obj.WriteFile(strPath+ "\\感染部位详细情况.txt", arryFile[5]);
		}
		if(arryFile[6]!=""){
			/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE浏览器
				obj.WriteFileIE(strPath + "\\感染部位相关的侵害性操作.txt", arryFile[6]);
			}else{
				obj.WriteFile(strPath + "\\感染部位相关的侵害性操作.txt", arryFile[6]);
			}*/
			obj.WriteFile(strPath + "\\感染部位相关的侵害性操作.txt", arryFile[6]);
		}
		if(arryFile[7]!=""){
			/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE浏览器
				obj.WriteFileIE(strPath + "\\检测标本详细情况.txt", arryFile[7]);
			}else{
				obj.WriteFile(strPath + "\\检测标本详细情况.txt", arryFile[7]);
			}*/
			obj.WriteFile(strPath + "\\检测标本详细情况.txt", arryFile[7]);
		}
		if(arryFile[8]!=""){
			/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE浏览器
				obj.WriteFileIE(strPath + "\\标本检测出的病原体详细情况.txt", arryFile[8]);
			}else{
				obj.WriteFile(strPath+ "\\标本检测出的病原体详细情况.txt", arryFile[8]);
			}*/
			obj.WriteFile(strPath+ "\\标本检测出的病原体详细情况.txt", arryFile[8]);
		}
		if(arryFile[9]!=""){
			/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE浏览器
				obj.WriteFileIE(strPath + "\\药敏试验结果.txt", arryFile[9]);
			}else{
				obj.WriteFile(strPath + "\\药敏试验结果.txt", arryFile[9]);
			}*/
			obj.WriteFile(strPath + "\\药敏试验结果.txt", arryFile[9]);
		}
		if(arryFile[10]!=""){
			/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE浏览器
				obj.WriteFileIE(strPath + "\\抗菌药物使用情况.txt", arryFile[10]);
			}else{
				obj.WriteFile(strPath + "\\抗菌药物使用情况.txt", arryFile[10]);
			}*/	
			obj.WriteFile(strPath + "\\抗菌药物使用情况.txt", arryFile[10]);
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
			
		if (!strTmp) return false;   //只有审核和提交的报告才支持导出
		
		strTmp = ExtTool.ReplaceText(strTmp, String.fromCharCode(2), "\r\n");
		strTmp = ExtTool.ReplaceText(strTmp, "^", "\t");
		var arryFile = strTmp.split(String.fromCharCode(1));
		if(arryFile[0] == "FETAL") //致命错误，无法导出数据
		{
			return false;
		}
		//alert(ExportPath)
		obj.CreatePath(ExportPath);
		var strPath = ExportPath;
		//判断内容是否为空，不为空导出，否则不导出
		if(arryFile[0]!=""){
			obj.WriteFile(strPath + "\\病人基本信息.txt", arryFile[0]);
		}
		
		//alert(arryFile[1])
		if(arryFile[1]!=""){
			obj.WriteFile(strPath + "\\ICU病人基本情况.txt", arryFile[1]);
		}
		if(arryFile[2]!=""){
			obj.WriteFile(strPath + "\\基础疾病.txt", arryFile[2]);
		}
		if(arryFile[3]!=""){
			obj.WriteFile(strPath + "\\中心静脉插管情况.txt", arryFile[3]);
		}
		if(arryFile[4]!=""){
			obj.WriteFile(strPath + "\\呼吸机使用情况.txt", arryFile[4]);
		}
		if(arryFile[5]!=""){
			obj.WriteFile(strPath + "\\导尿管使用情况.txt", arryFile[5]);
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