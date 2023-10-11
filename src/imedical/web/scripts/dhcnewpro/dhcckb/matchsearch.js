/**
*	Author: 		Qunianpeng
*	Create: 		2019/05/15
*	Description:	药品信息导入及查询
*/

/// 页面初始化函数
function initPageDefault(){

	InitPatEpisodeID();		/// 初始化加载病人就诊ID
	InitButton();			/// 初始化按钮绑定事件
	//InitPatInfo();			/// 初始化患者信息
	InitDrugListGrid();		/// 初始化药品列表
	
}


/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	
	PatientID = getParam("PatientID");
	EpisodeID = getParam("EpisodeID");	
}

/// 初始化按钮绑定事件
function InitButton(){

	/// 计算
	//$('#calc').on("click",CalcClick); 

	/// 编码，商品名回车
	//$('#queryCode,#queryDesc').bind('keypress',InputPrese);
	$('#queryDesc').bind('keypress',InputPrese);
	
	

}

function InitDrugListGrid(){

	/// 
	var  columns=[[    
	       	{field:'num',title:'序号',width:80},    
	     /*    {field:'dicCode',title:'编码',width:140}, */
	        {field:'dicDesc',title:'通用名称(含剂型)',width:180},
	        {field:'generKey',title:'通用名',width:180},
	        /* {field:'proName',title:'商品名',width:200}, */
	        {field:'factory',title:'厂家',width:240},
	       {field:'matchFlag',title:'标注',width:120}
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
		//showHeader:false,
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
	    fit:true,	
	    checkbox:true,
	    onDblClickRow: function (rowIndex, rowData) {			
		
        },
	    onLoadSuccess: function (data) { //数据加载完毕事件
          
        }
	};	
	
	var uniturl = $URL+"?ClassName=web.DHCCKBMatchSearch&MethodName=QueryDrugList";
	new ListComponent('druglist', columns, uniturl, option).Init();
}


/// 查询
function Query(){

	
	var code = "" //$("#queryCode").val().trim();
	var desc = $("#queryDesc").val().trim();
	var params = code +"^"+ desc;

	$("#druglist").datagrid("load",{"params":params});

}


/// 代码，描述回车事件
function InputPrese(e){

	 if(e.keyCode == 13){
		Query();
	}
}

/// 导入数据
function UploadData(){
	    
	var efilepath = $("input[name=filepath]").val();
    
    if (efilepath.indexOf("fakepath") > 0) {
	    $.messager.alert("提示","请在IE下执行导入！","info"); 
	    return; 
	}
    if (efilepath.indexOf(".xls") <= 0) {  
    	$.messager.alert("提示","请选择excel表格文件！","info"); 
    	return; 
    }
    //var kbclassname = ""  // 类名
    var sheetcount = 1  	// 模板中表的个数
    var file = efilepath.split("\\");
    var filename = file[file.length - 1];
    if ((filename.indexOf(".xlsx")<0)&&(filename.indexOf(".xls")<0)) {
	    clearFiles ()
        $.messager.alert('提示', '文件选择的不正确！',"info");
        return;
    }

	try {
		var oXL = new ActiveXObject("Excel.application");
	    var oWB = oXL.Workbooks.open(efilepath);   	
	}catch (e) {
	    $.messager.alert("提示",'请在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!',"info");
	    return;
	}
    var errorRow = "";	//没有插入的行
    var errorMsg = "";	//错误信息
    
    oWB.worksheets(1).select();
    var oSheet = oWB.ActiveSheet;
    var rowcount = oXL.Worksheets(1).UsedRange.Cells.Rows.Count;
    var colcount = oXL.Worksheets(1).UsedRange.Cells.Columns.Count;   
   
    //$.messager.progress({title:'请稍后',msg:'数据正在匹配中.',text: '匹配中....'});   
   
    var errMsg="",dicFlag=0;
    pid=serverCall("web.DHCCKBMatchSearch","MatchDataPid");  
      
    for (var i = 1; i <= rowcount; i++) {
	    var tempStr = ""; //每行数据（第一列[next]第二列[next]...）
		var row=i;
		var seqNo="";
		for(var j = 1; j <=4; j++){
			seqNo=oSheet.Cells(i+1, i).value;		// 序号
			var cellValue = ""
        	if (typeof (oSheet.Cells(j, 1).value) == "undefined") {
           	 	cellValue = "";
       		}else {
            	cellValue = oSheet.Cells(i, j).value;
        	}  
        	
        	tempStr=(tempStr=="")?cellValue:tempStr+"[next]" + cellValue;
		}
        
		if(tempStr!=""){
			ret=serverCall("web.DHCCKBMatchSearch","MatchTmpData",{pid:pid,row:row,data:tempStr})
			
		}	
    }
    //$.messager.progress('close');	//数据导入完成关闭加载框
		
    if(errMsg!=""){
	    
	}else{
		MatchSearch(pid);  	
	}
	
    clearFiles();
    oWB.Close(savechanges = false);
    CollectGarbage();
    oXL.Quit();
    oXL = null;
    oSheet = null;	
}

function MatchSearch(pid){
	ret=serverCall("web.DHCCKBMatchSearch","MatchSearch",{pid:pid});
    if(ret>0){
	    $.messager.alert("提示","匹配完成！");
	}else{
		$.messager.alert("提示","匹配失败！");	
	}
	Query();
}


//清空文件上传的路径 
function clearFiles(){
     var file = $("#filepath");
      file.after(file.clone().val(""));      
      file.remove();   
	
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })