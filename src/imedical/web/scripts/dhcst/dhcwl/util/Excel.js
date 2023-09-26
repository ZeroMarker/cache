(function(){
	Ext.ns("dhcwl.mkpi.util");
})();
dhcwl.mkpi.util.Excel=function(){
	var excelAX=null;
	var title='导出文件';
	var head=[];
	var content=null;
	var serverUrl=null;
	var outThis=this;
	this.setTitle=function(parTitle){
		title=parTitle;
	}
	this.setHead=function(parHead){
		head=parHead;
	}
	this.setServerUrl=function(parUrl){
		serverUrl=parUrl;
	}
	this.exportExcel=function(){
		getContentFromUrl();
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
			dhcwl.mkpi.Util.ajaxExc(serverUrl,null,
				function(responseText){
					if(responseText){
						content=responseText;
						writeToExcel();
					}else{
						Ext.Msg.show({title : '错误',msg : "相应失败！\n" +responseText,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
					}
				}
				,outThis,false,null);
		}
	}
	function writeToExcel(){
		if(!excelAX){
			if(!createExcelAX()) return;
		}
		var dir = dhcwl.mkpi.Util.browseFolder();
		//alert(dir);
		//return;
		//getContentFromUrl();
		var oWB = excelAX.Workbooks.Add(); 
     	var oSheet = oWB.ActiveSheet;
     	var rows=1,contLen=content.length,rowLen=0;
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
     	oSheet.SaveAs(dir+title+dhcwl.mkpi.Util.nowDateTime());
 		oSheet = null;
 		oWB = null;
 		excelAX = null;
	}
}
