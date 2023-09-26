(function(){
	Ext.ns("dhcwl.RptMgmt.util.Excel");
})();

	//如果要查看更详细的信息，请在excel中打开帮助，搜索“Visual Basic”，关于“开发人员参考”部分
	//需要加异常处理
dhcwl.RptMgmt.util.Excel=function(){
	var excelAX=null;
	var title='导出文件';
	var head=[];
	var content=null;
	var serverUrl=null;
	var outThis=this;
	//var serverCode="";
	var fieldNames=[];
	//var serverParam=new Object();
	this.setTitle=function(parTitle){
		title=parTitle;
	}
	this.setHead=function(parHead){
		head=parHead;
	}
	this.setCode=function(parCode){
		serverCode=parCode
	}
	this.setServerUrl=function(parUrl){
		serverUrl=parUrl;
	}
	this.setfieldNames=function(parfName){
		fieldNames=parfName;
	}

	this.exportExcel=function(exportCallback,scope){
		getContentFromUrl(exportCallback,scope);
	}
	function createExcelAX(){
		try {
	 		excelAX = new ActiveXObject('Excel.Application');
	 	}catch (e) {
	 		alert("无法启动Excel!\n\n如果您确信您的电脑中已经安装了Excel，"+"那么请调整IE的安全级别。\n\n具体操作：\n\n"+"工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用");
	 		return false;
	 	}
	 	return true;
	}
	function getContentFromUrl(exportCallback,scope){
		if(serverUrl){
			dhcwl.mkpi.Util.ajaxExc(serverUrl,{fieldNames:fieldNames.join()},
				function(responseText){
					if(responseText){
						content=responseText;
						writeToExcel(exportCallback,scope);
					}else{
						Ext.Msg.show({title : '错误',msg : "相应失败！\n" +responseText,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
					}
				}
				,outThis,false,null);
		}
	}
	function writeToExcel(exportCallback,scope){
		if(!excelAX){
			if(!createExcelAX()) return;
		}
		var dir = dhcwl.mkpi.Util.browseFolder();
		if (!dir) return; 
		var oWB = excelAX.Workbooks.Add(); 
     	var oSheet = oWB.ActiveSheet;
     	var rows=1,contLen=content.length,rowLen=0;
		//合并标题区域
		oSheet.Range(oSheet.Cells(rows, 1), oSheet.Cells(rows, fieldNames.length)).Merge();
		//oSheet.Range(oSheet.Cells(rows, 1), oSheet.Cells(rows, fieldNames.length)).Font.Bold = true;
		
		oSheet.Cells(rows,1).Font.Bold = true;

     	oSheet.Cells(rows,1).value=title;
		oSheet.Cells(rows,1).Font.Size=oSheet.Cells(rows,1).Font.Size+2;
		oSheet.Cells(rows,1).VerticalAlignment = 2;	//居中排列
		oSheet.Cells(rows,1).HorizontalAlignment=3; //居中排列

		


     	//rows++;
     	//oSheet.Cells(rows,1).value='DHCWL_MKPI.DHCWLMKPI';
     	
		/*
     	if(serverCode!=""){
     		if(serverCode.length>0){
     			for(var j=0;j<serverCode.length;j++){
     				oSheet.Cells(rows, j + 1).value =serverCode[j];
     			}
     			rows++;
     		}
     	}
		*/
		rows++;
     	if(fieldNames!=""){
     		if(fieldNames.length>0){
     			for(var j=0;j<fieldNames.length;j++){
     				oSheet.Cells(rows, j + 1).value =fieldNames[j];
     			}
				oSheet.Rows(rows).Hidden = true ;	//隐藏字段名称
				oSheet.Rows(rows).ColumnWidth =20;
     			rows++;
     		}
     	}		
		
		//oSheet.Range(myExcelCell, myExcelCell2).Merge();
		
		
     	if(head.length>0){
     		for(var j=0;j<head.length;j++){
     			oSheet.Cells(rows, j + 1).value =head[j];
     		}
			oSheet.Range(oSheet.Cells(rows,1),oSheet.Cells(rows,head.length)).Font.Bold = true;
     		rows++;
     	}
		
		
		
     	for(var i=0;i<contLen;i++,rows++){
     		if(!content[i])continue;
     		rowLen=content[i].length;
     		for(var j=0;j<rowLen;j++){
     			oSheet.Cells(rows, j + 1).value =content[i][j];
     		}
     	}
     	excelAX.Visible = true;
     	if(dir.charAt(dir.length-1)!="\\") dir+="\\";
     	oSheet.SaveAs(dir+title+dhcwl.mkpi.Util.nowDateTime());
 		oSheet = null;
 		//oWB = null;
		oWB.Close();  
 		//excelAX = null;
		excelAX.Quit();  
		exportCallback.call(scope, "导出完成");
	}
}
