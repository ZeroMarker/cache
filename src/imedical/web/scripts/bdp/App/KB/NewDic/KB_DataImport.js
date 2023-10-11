/// 名称: 知识库模板数据导入导出
/// 编写者: 基础数据平台组-丁亚男
/// 编写日期: 2018-8-21
var init = function(){
	$('#myWinpro').window('close'); 
 /**************************模板下载部分开始***********************************************************************************************/
	//药品知识库模板下载按钮
	$("#LoadDrugPath").click(function (e) {
			LoadKBData("LoadDrugPath");
	 })  
	 //检验知识库模板下载按钮
	$("#LoadLabPath").click(function (e) {
			LoadKBData("LoadLabPath");
	 })  
	 //检查知识库模板下载按钮
	$("#LoadCheckPath").click(function (e) {
			LoadKBData("LoadCheckPath");
	 })  
	 //心电知识库模板下载按钮
	$("#LoadElectPath").click(function (e) {
			LoadKBData("LoadElectPath");
	 }) 
	 //手术知识库模板下载按钮
	$("#LoadOperationPath").click(function (e) {
			LoadKBData("LoadOperationPath");
	 }) 
    //治疗知识库模板下载按钮
	$("#LoadTreatPath").click(function (e) {
			LoadKBData("LoadTreatPath");
	 }) 
	 
	///判断浏览器是否是IE
    function isIE()
	{
		if((!!window.ActiveXObject)||(navigator.userAgent.indexOf('Trident')>-1&&navigator.userAgent.indexOf("rv:11.0")>-1))
		{	
			return true;
		}
		else
		{  
			return false;
		}
	}
	 //下载知识库模板
	function LoadKBData(id){
		if (!isIE())
		{
			$.messager.alert('错误提示','请在IE下执行！',"error");
			return;
		}
		
		var filepath=""
		if (id=="LoadDrugPath"){
			  filepath = "../scripts/bdp/APPHelp/Doc/DRUGData.xls";
		}else if (id=="LoadLabPath"){
			  filepath = "../scripts/bdp/APPHelp/Doc/LABData.xls";
		}else if (id=="LoadCheckPath"){
			  filepath = "../scripts/bdp/APPHelp/Doc/CheckData.xls";
		}else if (id=="LoadElectPath"){
			  filepath = "../scripts/bdp/APPHelp/Doc/ELECTData.xls";
		}else if (id=="LoadOperationPath"){
			  filepath = "../scripts/bdp/APPHelp/Doc/OPERATIONData.xls";
		}else if (id=="LoadTreatPath"){
			  filepath = "../scripts/bdp/APPHelp/Doc/TREATData.xls";
		}
		
		var isExists=IsExistsFile(filepath)
		if(isExists){
			location.href=filepath;
		}else{
			$.messager.alert('提示','该文件不存在!',"error");
		}
	}
	function IsExistsFile(filepath)
    {
        var xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
        xmlhttp.open("GET",filepath,false);
        xmlhttp.send();
        if(xmlhttp.readyState==4){   
            if(xmlhttp.status==200) return true; //url存在   
            else if(xmlhttp.status==404) return false; //url不存在   
            else return false;//其他状态   
        } 
    }
/**************************模板下载部分结束***********************************************************************************************/
	
/**************************数据导入部分开始***********************************************************************************************/
	//点选择按钮时候获取路径
	doChange=function (file){
	    var upload_file = $.trim($("#fileParth").val());    //获取上传文件
	    $('#ExcelImportPath').val(upload_file);     //赋值给自定义input框
	}
     //导入按钮
	$("#ImportData").click(function (e) {
			ImportKBData();
	 }) 
	function ImportKBData(){
		var efilepath=$('#ExcelImportPath').val();  //要导入的模板
		//console.log(efilepath)
		var sheetid=$.trim($("#sheetid").val());  //要导入第几个表
		var sheet_id=parseInt(sheetid);
		if( efilepath.indexOf("fakepath")>0 ) {alert ("请在IE下执行导入！"); return;}
		if( efilepath.indexOf(".xls")<=0 ) {alert ("请选择excel表格文件！"); return;}
		if(sheet_id=="") {alert ("请填写要导入模板里的第几个sheet！"); return;}

		var kbclassname=""  //类名
		var sheetcount=2  //模板中表的个数 
		var file=efilepath.split("\\");
		var filename=file[file.length-1];
		if(filename.indexOf("DRUGData")>=0){
		    kbclassname="web.DHCBL.BDP.ImportKBData"
		    sheetcount=44
		 }
		 if(filename.indexOf("LABData")>=0){
		    kbclassname="web.DHCBL.BDP.ImportLABData"
		    sheetcount=16
		 }
		 if(filename.indexOf("CheckData")>=0){
		     kbclassname="web.DHCBL.BDP.ImportCheckData"
		     sheetcount=15
		 }
		 if(filename.indexOf("ELECTData")>=0){
		      kbclassname="web.DHCBL.BDP.ImportELECTData"
		      sheetcount=16
		 }
		 if(filename.indexOf("OPERATIONData")>=0){
		      kbclassname="web.DHCBL.BDP.ImportOPERATIONData"
		      sheetcount=18
		 }
		 if(filename.indexOf("TREATData")>=0){
		      kbclassname="web.DHCBL.BDP.ImportTREATData"
		      sheetcount=13
		 }
		 if ((sheet_id<2)||(sheet_id>sheetcount))
		 {
		 	alert ("模板里没有该sheet！"); return;
		 }
		try{ 
			var oXL = new ActiveXObject("Excel.application"); 
			var oWB = oXL.Workbooks.open(efilepath);   //xlBook = xlApp.Workbooks.add(ImportFile);		
		}		
		catch(e){
			var emsg="请在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!"
			$.messager.alert('提示',emsg,"error"); 
			return;
		}
		
	 	if (kbclassname!="")
	 	{	 	  
		  
			var errorRow="";//没有插入的行
			var errorMsg="";//错误信息
			oWB.worksheets(sheet_id).select(); 
			var oSheet = oWB.ActiveSheet; 
			var rowcount=oXL.Worksheets(sheet_id).UsedRange.Cells.Rows.Count ;
			var colcount=oXL.Worksheets(sheet_id).UsedRange.Cells.Columns.Count ;
			
			$('#myWinpro').window('open');
			$('#pro').progressbar({
				text:"正在导入中，请稍候...",
			    value: 0
			});
			
			//谷雪萍 2020-05-09 进度条
			var row=1
			//var interval = setInterval(function(){
			var loopFlag=setTimeout(startCount,100);  //setTimeout是超时调用，使用递归模拟间歇调用
			function startCount(){
				row++;
			//for (row>1;row<=rowcount;row++){
				if(row>rowcount) //当到达最后一行退出
			  	{
			  		clearTimeout(loopFlag);
			  		//clearInterval(interval);
			  		$('#myWinpro').window('close'); 
			  		if(errorRow!=""){
						errorMsg=oSheet.name+"表导入完成，第"+errorRow+"行插入失败!" ;			
					}else{
						errorMsg=oSheet.name+"表导入完成!"
					}
					alert(errorMsg)

					oWB.Close(savechanges=false);
					CollectGarbage();
					
					oXL.Quit(); 
					oXL=null;
					oSheet=null;	
					idTmr = window.setInterval("Cleanup();",1);
					$('#myWinpro').window('close'); 
					return
			  	}
			  	else
			  	{
					var tempStr = ""; //每行数据（第一列[next]第二列[next]...）
					var i=row
					for (var j=1;j<=colcount;j++){
						var cellValue=""
						if(typeof(oSheet.Cells(i,j).value)=="undefined"){
							cellValue=""
						}else{
							cellValue=oSheet.Cells(i,j).value
						}
						tempStr+=(cellValue+"[next]")
					}
					var Flag =tkMakeServerCall(kbclassname,"SaveData",tempStr,sheet_id,row);
					
					//alert(kbclassname+"^"+tempStr+"^"+Flag);
					if (Flag=="true"){
						errorRow=errorRow
						
					}else{
						if(errorRow!=""){
							errorRow=errorRow+","+i
						}else{
							errorRow=i
						}
					}
					tempStr=""
				    //progressText = "正在导入"+oSheet.name+"表的第"+row+"条记录,总共"+rowcount+"条记录!";  
		            $('#pro').progressbar('setValue', row/rowcount*100); 
			  	}
    			//$('#pro').attr('text', progressText);		    
			  	loopFlag=setTimeout(startCount,100);  //setTimeout是超时调用，使用递归模拟间歇调用
			}
			
			  	//}, 100);
			//}
			
			
	  	}
	  	else
	  	{
		   //提示信息
	  		var emsg="该知识库模板名不能识别！<br>知识库模板名要包含：DRUGData、LABData、CheckData、ELECTData、OPERATIONData或TREATData！<br>注意：请勿随意修改模板！否则会影响数据导入！"
			$.messager.alert('提示',emsg,"error"); 
	  	}

  }
	function Cleanup(){   
	 	window.clearInterval(idTmr);   
	 	CollectGarbage();
	}
	
	
/**************************数据导入部分结束***********************************************************************************************/


/**************************数据导出部分开始***********************************************************************************************/
	///导出数据
	var DataName = $HUI.combobox("#exportsheetnameF",{
		valueField:'id',
		textField:'text',
		data:[
			{id:'DRUGData',text:'药品知识库模板',"selected":true},
			{id:'LABData',text:'检验知识库模板'},
			{id:'CheckData',text:'检查知识库模板'},
			{id:'ELECTData',text:'心电知识库模板'}	,
			{id:'OPERATIONData',text:'手术知识库模板'}	,
			{id:'TREATData',text:'治疗知识库模板'}	
		]
	});
	
	//导出按钮
	$("#ExportData").click(function (e) {
			ExportKBData();
	 }) 
	 
	function ExportKBData() {
		
			$.messager.confirm("导出", "确定要导出数据吗?", function (r) {
				if (r) {
					var ekbclassname="";
					var tablename=$("#exportsheetnameF").combobox('getValue');  //要导出哪个知识库
					var table=$("#exsheetid").val();  //要导出第几个表
					if (table=="")
					{
					 	alert ("请填写要导出模板里的第几个sheet！"); return;
					}
					
					try{
				    	xlApp = new ActiveXObject("Excel.Application");
						xlBook = xlApp.Workbooks.Add();///默认三个sheet
					}catch(e){
						var emsg="请在IE下操作，并在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!"
						$.messager.alert('提示',emsg,"error"); 
					     return;
					}
					
				  if(tablename.indexOf("LABData")>=0)
					 {
						    ekbclassname="web.DHCBL.BDP.ExportLABData"
						   if ((table<2)||(table>16))
						 	{
							 	alert ("目前只能导出检验知识库模板中第2个到第16个sheet的数据！"); return;
							}
					 }
					else if(tablename.indexOf("CheckData")>=0)
					{
						     ekbclassname="web.DHCBL.BDP.ExportCheckData"
						    if ((table<2)||(table>15))
							{
							 	alert ("目前只能导出放射、超声、内镜知识库模板中第2个到第15个sheet的数据！"); return;
							}
					 }
					 else if(tablename.indexOf("ELECTData")>=0)
					 {
					      ekbclassname="web.DHCBL.BDP.ExportELECTData"
					      if ((table<2)||(table>16))
						  {
						 	alert ("目前只能导出心电知识库模板中第2个到第16个sheet的数据！"); return;
						  }
					 }
					 else if(tablename.indexOf("TREATData")>=0)
					 {
					      ekbclassname="web.DHCBL.BDP.ExportTREATData"
					      if ((table<2)||(table>13))
						  {
						 	alert ("目前只能导出治疗知识库模板中第2个到第13个sheet的数据！"); return;
						  }
					 }
					 else if(tablename.indexOf("OPERATIONData")>=0)
					 {
					      ekbclassname="web.DHCBL.BDP.ExportOPERATIONData"
					      if ((table<2)||(table>18))
						  {
						 	alert ("目前只能导出手术知识库模板中第2个到第18个sheet的数据！"); return;
						  }
					 }
					 else
					 {
						 ekbclassname="web.DHCBL.BDP.ExportKBData"
						    if ((table<2)||(table>44))
							{
							 	alert ("目前只能导出药品知识库模板中第2个到第44个sheet的数据！"); return;
							}
					 }
					 

					///菜单
					var sheetname=tkMakeServerCall(ekbclassname,"GetName",table);
					$('#myWinpro').window('open');
					$('#pro').progressbar({
						text:"正在导出中，请稍候...",
					    value: 0
					});
					xlBook.worksheets(1).select(); 
					var xlsheet = xlBook.ActiveSheet; 
					xlsheet.name = sheetname;
					var rowcount=tkMakeServerCall(ekbclassname,"GetCount",table);
					var titleStr=tkMakeServerCall(ekbclassname,"GetTitle",table);
					//alert(titleStr+"^"+count)
					var title=titleStr.split("&%");
					for (var i = 0; i < title.length; i++) {    				
						//1b	
			    		xlsheet.cells(1,i+1)=title[i];
	
					}

					//谷雪萍 2020-05-09 进度条 计时器
					var row = 0;
					var loopFlag=setTimeout(startCount,100);  //setTimeout是超时调用，使用递归模拟间歇调用
					function startCount(){
					//var interval = setInterval(function(){
						row++;
						if(row>rowcount){
							//clearInterval(interval);
							clearTimeout(loopFlag);
							idTmr = window.setInterval("Cleanup();",1);
							$('#myWinpro').window('close');
							//$.messager.progress("close")
							xlApp.Visible=true;	
							xlBook.Close(savechanges=true);
							//xlApp.Quit();
							CollectGarbage();
							xlApp=null;
							xlsheet=null;
							return
							 
						}
						else{
							var DataDetailStr2=tkMakeServerCall(ekbclassname,"GetInfo",table,row);
							var Detail2=DataDetailStr2.split("&%");	
							for (var j=1;j<=title.length;j++){
								xlsheet.Cells(1+row,j).NumberFormatLocal = "@";//设置导出为文本
								xlsheet.cells(1+row,j)=Detail2[j-1];
								xlsheet.cells(1+row,j)=Detail2[j-1];
							}	 
				            $('#pro').progressbar('setValue', row/rowcount*100); 
						}
					//}, 100);
						loopFlag=setTimeout(startCount,100);  //setTimeout是超时调用，使用递归模拟间歇调用
					}			
			
				} else {
					
				}
			});
	}
		
  
  
  
/**************************数据导出部分结束***********************************************************************************************/
	
		
	
};
$(init);

