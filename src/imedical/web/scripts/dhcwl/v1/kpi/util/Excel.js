var Excel=function(){
	var excelAX=null;
	var title='导出文件';
	var table="DHCWL_MKPI.DHCWLMKPI";
	var head=[];
	var content=null;
	var serverUrl=null;
	var outThis=this;
	var serverCode="";
	this.setTitle=function(parTitle){
		title=parTitle;
	}
	this.setTable=function(parTable){
		table=parTable;
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
	this.exportExcel=function(){
		getContentFromUrl();
	}
	this.exportExcelAll=function(className,methodName,selectID){
		getContentFromUrlAll(className,methodName,selectID);
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
	function getContentFromUrl(){
		if(serverUrl){
			$.m({
				ClassName:"web.DHCWL.V1.KPI.KPIFunction",
				MethodName:"GetKPInforExcel",
				kpiIDs:serverUrl,	
			},function(responseText){
				if (responseText){
					responseText=eval('(' + responseText + ')');
					content=responseText;
					writeToExcel();
				}
			});
		}
	}
	function getContentFromUrlAll(className,methodName,selectID){
		$.m({
			ClassName:className,
			MethodName:methodName,
			selectID:selectID			
		},function(responseText){
			if (responseText){
				responseText=eval('(' + responseText + ')');
				content=responseText;
				writeToExcel();
			}
		});
	}
	function writeToExcel(){
		if(!excelAX){
			if(!createExcelAX()) return;
		}
		var dir = browseFolderUtil();
		if (!dir) return; 
		//alert(dir);
		//return;
		//getContentFromUrl();
		var oWB = excelAX.Workbooks.Add(); 
     	var oSheet = oWB.ActiveSheet;
     	var rows=1,contLen=content.length,rowLen=0;
     	oSheet.Cells(rows,1).value='导出文件';
     	rows++;
     	oSheet.Cells(rows,1).value=table;
     	rows++;
     	if(serverCode!=""){
     		if(serverCode.length>0){
     			for(var j=0;j<serverCode.length;j++){
     				oSheet.Cells(rows, j + 1).value =serverCode[j];
     			}
     			rows++;
     		}
     	}
     	if(head.length>0){
     		for(var j=0;j<head.length;j++){
     			oSheet.Cells(rows, j + 1).value =head[j];
     		}
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
     	oSheet.SaveAs(dir+title+nowDateTimeUtil());
 		oSheet = null;
 		oWB = null;
 		excelAX = null;
	}
}
