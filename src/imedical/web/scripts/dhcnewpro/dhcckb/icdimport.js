///****************************************
//*	Author: 		Sunhuiyong
//*	Create: 		2020/01/09
//*	Description:	ICD诊断对照导入导入
///****************************************
/// 页面初始化函数
function initPageDefault(){
	InitLinkList();
}
/// 初始化关联表
function InitLinkList(){
	// s title="num^itmCode^itmProName^itmGeneName^itmIngre^itmExcipient^itmForm^itmLibary^errMsg"

	var  columns=[[    
	       	{field:'AllNum',title:'文件错误行数',width:140},    
	     	{field:'msg',title:'错误信息',width:200}
	        
	    ]]
	
	///  定义datagrid
	var option = {		
		toolbar:'#toolbar',
		border:false,
	    rownumbers:true,
	    fitColumns:true,
	    singleSelect:true,
	    pagination:true,
	    pageSize:20,
	    pageList:[20,40,100],
	    fit:true,	
	    //checkbox:true,
	    onDblClickRow: function (rowIndex, rowData) {			
		
        },
	    onLoadSuccess: function (data) { //数据加载完毕事件
     
        }
	};	
	
	var uniturl = $URL+"?ClassName=web.DHCCKBIcdImport&MethodName=GetErrList";
	new ListComponent('linklist', columns, uniturl, option).Init();
}

/// 导入数据
function formImp(){
	var efilepath = $("input[name=filepath]").val();
    if (efilepath.indexOf("fakepath") > 0) {$.messager.alert('提示',"请在IE下执行导入！"); return; }
    if (efilepath.indexOf(".xls") <= 0) { $.messager.alert('提示',"请选择excel表格文件！"); return; }
    var sheetcount = 1  //模板中表的个数
    var file = efilepath.split("\\");
    var filename = file[file.length - 1]; //限制选中上传文件的格式仅限两种格式的excl文件
    if ((filename.indexOf(".xlsx")<0)&&(filename.indexOf(".xls")<0)) {
	    clearFiles ()
        $.messager.alert('提示', '文件选择的不正确！');
        return;
    }
	try {
	        var oXL = new ActiveXObject("Excel.application"); //通过ActiveX方式读取excl文件
	        var oWB = oXL.Workbooks.open(efilepath);   	
	}catch (e) {
	        $.messager.alert('请在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!');
	        return;
	}
    var errorRow = "";//没有插入的行
    var errorMsg = "";//错误信息
    oWB.worksheets(1).select();//默认选中的表格：sheet1
    var oSheet = oWB.ActiveSheet;
    var rowcount = oXL.Worksheets(1).UsedRange.Cells.Rows.Count;
    var colcount = oXL.Worksheets(1).UsedRange.Cells.Columns.Count;
	var ProgressText='';
	$('#pro').progressbar({
		text:"正在处理中，请稍后...",
	    value: 0
	});
	alert("开始处理！!");
	var impAllData="";
    for (var j = 2; j <= rowcount; j++) {
        var rowData="";
        var row = j;
		for(k =1;k<=colcount;k++){
			var cellValue = "";
			if (typeof (oSheet.Cells(j, k).value) == "undefined") {
				cellValue = ""
			}else{
				cellValue = oSheet.Cells(j, k).value
			}
			rowData==""?rowData=cellValue:rowData=rowData+"^"+cellValue;
			
		}
		
		Flag=SaveRowData(rowData,row,rowcount)
		console.log(Flag);
		//impAllData==""?impAllData=rowData:impAllData=impAllData+"@@"+rowData;
		if (Flag=="0"){
				errorRow=errorRow	
			}else{
				if(errorRow!=""){
					errorRow=errorRow+","+(row-1)
				}else{
					errorRow=(row-1)
				}
			}
			rowData=""
			progressText = "正在导入"+oSheet.name+"表的第"+(row-1)+"条记录,总共"+(rowcount-1)+"条记录!";  

			//$('#pro').attr('text', progressText);

		    //$('#pro').attr('text', progressText);
		    if(errorRow!="")  //碰到第一条错误信息 退出并存入TMPERR 加载出错误信息
		    {
			    
				  runClassMethod("web.DHCCKBIcdImport","SaveErr",{"errorRow":(row-1)},function(val){
				  })
			} 
			if(row==rowcount) //当到达最后一行退出
			{
				if(errorRow!=""){
					errorMsg=oSheet.name+"表导入完成，第"+errorRow+"行插入失败!" ;
					$("#linklist").datagrid('reload'); 			
				}else{
					errorMsg=oSheet.name+"表导入完成!"
				}
				$('#pro').progressbar('setValue', 100); 
				debugger;
				progressText = "正在导入"+oSheet.name+"表的记录,总共"+rowcount+"条记录!";  
				$('#pro').attr('text', progressText); 
				alert(errorMsg)
				oWB.Close(savechanges=false);
				CollectGarbage();
				oXL.Quit(); 
				oXL=null;
				oSheet=null;
    }
   
	//name,10;name2,20...
	//Save(impAllData,rowcount)
   // $.messager.progress('close')//数据导入完成关闭加载框
 
}
 	clearFiles();
}
	
 //清空文件上传的路径 
function clearFiles(){
      $('#filepath').filebox('clear');
     
} 

//优化行导入
function SaveRowData(rowData,row,rowcount){
	var value = $('#pro').progressbar('getValue');
			if (value < 100){
	   		 	value = ((row-1)/(rowcount-1))*100;
	   		 	value =parseInt(value)
	   		 	$('#pro').progressbar('setValue', value);
			}
	var ErrFlag = "";

	runClassMethod("web.DHCCKBIcdImport","SaveIcdRowData",{"rowData":rowData,"hospID":LgHospID},function(val){
		var retObj=val
		if (retObj.code == "success"){
			ErrFlag=0
		}
		else{
			ErrFlag=1
		}
		//$("#linklist").datagrid("reload");
	},"json",false)
	
	return ErrFlag;}

/// 存储数据
function Save(impAllData,rowcount){
   
	var ErrFlag = 0;

	runClassMethod("web.DHCCKBIcdImport","SaveIcd",{"impAllData":impAllData,"rowcount":rowcount},function(val){
		//var retObj = JSON.parse(val);
		//$.messager.progress('close');
		
		var retObj=val
		if (retObj.code =="success"){
			$.messager.progress('close')//数据导入完成关闭加载框
			$.messager.alert("提示:","导入成功."+"共【"+retObj.total+"条】,  成功【"+retObj.successNum+"】条.  "+"失败【"+retObj.errNum+"】条","info");
		}
		else{
			$.messager.progress('close')//数据导入完成关闭加载框
			$.messager.alert("提示:","导入失败."+"失败原因："+retObj.msg,"info");
			ErrFlag=1
		}
		$("#linklist").datagrid("reload");
	},"json")
	
	return ErrFlag;
}


function JsonToArr(obj,spec){

	// 根据typeof判断对象也不太准确
	/*
	表达式	                      返回值
	typeof undefined	       'undefined'
	typeof null	               'object'
	typeof true	               'boolean'
	typeof 123	               'number'
	typeof "abc"	           'string'
	typeof function() {}	   'function'
	typeof {}	               'object'
	typeof []	               'object'
	*/
	
	var val=(Object.prototype.toString.call(obj) === '[Object Object]')?0:1;
	val=(JSON.stringify(obj) == "{}")?1:0;
	
	if (val){
		return "";
	}
	var strArr = [];
	for (k in obj){
		var tmpStr = k + spec + obj[k];		// {"test":"1"}-> test$c(1)1
		strArr.push(tmpStr);
	}
	
	return strArr;
	
}




/// JQuery 初始化页面
$(function(){ initPageDefault(); })
