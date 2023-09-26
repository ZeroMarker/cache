
$(function(){ 
	document.onkeydown = function(e){ 
    var ev = document.all ? window.event : e;
    	if(ev.keyCode==13) {
			commonQuery({'datagrid':'#datagrid','formid':'#toolbar'})
     	}
	}
	
	$(":radio").click(function(){
   		commonQuery({'datagrid':'#datagrid','formid':'#toolbar'})
  	});
});
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'style':'input'}})
}

function save(){
	saveByDataGrid("web.DHCADVFormName","save","#datagrid",function(data){
		//修改
		if(data==0){
			$.messager.alert('提示','保存成功');
			$("#datagrid").datagrid('reload'); 
		}else{
		 	if((data=11)||(data=12)){
				$.messager.alert('提示','保存失败:表单代码已存在!')
			}else{
				$.messager.alert('提示','保存失败:'+data)
			}
		}
		
	});	
}

function formItm(){
	window.location.href="dhcadv.formdic.csp"	
}
function edit(){
	var rowsData = $("#datagrid").datagrid('getSelected')
	if (rowsData == null) {
		$.messager.alert("提示","请选择表单!");
		return;	
	}
	window.open("dhcadv.layout.csp?id="+rowsData.ID)
	//window.location.href="layout.csp?id="+rowsData.ID	
}

function remove(){
	var rowsData = $("#datagrid").datagrid('getSelected')
	if (rowsData == null) {
		$.messager.alert("提示","请选择表单!");
		return;	
	}
	
	$.messager.confirm("操作提示", "确认要删除表单吗？", function (data) {  
            if (data) {  
                runClassMethod(
					"web.DHCADVFormName",
				    "remove",
					{
		 				'id':rowsData.ID
		 			},
		 			function(data){
			 			$("#datagrid").datagrid('reload'); 
					},"text");
            } 
    }); 
}
function formCat(){
	window.location.href="dhcadv.formcat.csp"
}

//复制表单
function formCopy(){
	var rowsData = $("#datagrid").datagrid('getSelected')
	if (rowsData == null) {
		$.messager.alert("提示","请选择表单!");
		return;	
	}
	$("#copyCode").val("");
	$("#copyName").val("");
	$('#copy').dialog("open");

}

function saveFormCopy(){
	if($("#copyForm").form('validate')){
		var rowsData = $("#datagrid").datagrid('getSelected')
		runClassMethod(
		"web.DHCADVFormCopy",
		"copyForm",
		{
		 'id':rowsData.ID,
		 'code':$("#copyCode").val(),
		 'name':$("#copyName").val()},
		 function(data){
			 if(data==1){
				$.messager.alert("提示","代码重复")
			 	return;
			 }
			 if(data==2){
				$.messager.alert("提示","保存失败")
			 	return;
			 }
			 $.messager.alert("提示","保存成功")
			 $('#copy').dialog("close");
			 $("#datagrid").datagrid('reload'); 
		},"text");
	}
	
}


function formExp()
{

  	var rowsData = $("#datagrid").datagrid('getSelected')
	if (rowsData == null) {
		$.messager.alert("提示","请选择表单!");
		return;	
	}

	try
	{
		var xlApp=new ActiveXObject("Excel.Application");
	}
	catch (e)
	{
        $.messager.alert('提示','请在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!');
        return;
	}
	$.messager.progress({   //数据导入提示
		title:'请稍后', 
		msg:'数据正在导出中...' 
	}); 
	xlApp.Visible=false;
	xlApp.DisplayAlerts = false;
	var xlBook=xlApp.Workbooks.Add();
	var xlSheet=xlBook.Worksheets(1);	
	    

	ret=serverCall("web.DHCADVFormExport","exportFormName",{id:rowsData.ID})

	retArr=ret.split(",");
	if(retArr[1]>0){
		pid=retArr[0];
		xlSheet.Cells(1,1).Value=retArr[3];
		for (k=1;k<=retArr[1];k++)
		{
			xlSheet.Cells(k+1,1).Value=serverCall("web.DHCADVFormExport","exportForm",{pid:pid,count:k});
		
		}
		xlSheet.Cells(parseInt(retArr[1])+2,1).Value="dicstart";
		for (k=1;k<=retArr[2];k++)
		{
			xlSheet.Cells(parseInt(k)+parseInt(retArr[1])+2,1).Value=serverCall("web.DHCADVFormExport","exportFormDic",{pid:pid,count:k});
		}
	}
 	
 	 $.messager.progress('close')//数据导入完成关闭加载框
 	
 	  
	try
	{
		var fileName = xlApp.Application.GetSaveAsFilename("*.xls", "Excel Spreadsheets (*.xls), *.xls");
		if(fileName){
			 var ss = xlBook.SaveAs(fileName);  
		 	if (ss==false)
			{
				 $.messager.alert('提示','导出失败！') ;
			}else{
				 $.messager.alert('提示','导出成功！') ;
			}
		}else{
			$.messager.alert('提示','导出取消！') ;
		}
		
	}
	catch(e){
		  $.messager.alert('提示','导出失败！') ;
	}


	xlSheet=null;
    xlBook.Close (savechanges=false);
    xlBook=null;
    xlApp.Quit();
    xlApp=null;
 	   
}


//清空文件上传的路径 
function clearFiles (){
     var file = $("#filepath");
      file.after(file.clone().val(""));      
      file.remove();   
	
}
function formImp(){
	
	var efilepath = $("input[name=filepath]").val();
    //alert(efilepath)
    if (efilepath.indexOf("fakepath") > 0) {alert("请在IE下执行导入！"); return; }
    if (efilepath.indexOf(".xls") <= 0) { alert("请选择excel表格文件！"); return; }
    //var kbclassname = ""  //类名
    var sheetcount = 1  //模板中表的个数
    var file = efilepath.split("\\");
    var filename = file[file.length - 1];
    if ((filename.indexOf(".xlsx")<0)&&(filename.indexOf(".xls")<0)) {
	    clearFiles ()
        $.messager.alert('提示', '文件选择的不正确！');
        return;
    }

	try {
	        var oXL = new ActiveXObject("Excel.application");
	        var oWB = oXL.Workbooks.open(efilepath);   	
	}catch (e) {
	        $.messager.alert('请在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!');
	        return;
	}
    var errorRow = "";//没有插入的行
    var errorMsg = "";//错误信息
    oWB.worksheets(1).select();
    var oSheet = oWB.ActiveSheet;
    var rowcount = oXL.Worksheets(1).UsedRange.Cells.Rows.Count;
    var colcount = oXL.Worksheets(1).UsedRange.Cells.Columns.Count;
    
    $.messager.progress({title:'请稍后',msg:'数据正在导入中...'}); 
    
    var errMsg="",dicFlag=0;
    pid=serverCall("web.DHCADVFormExport","importPid")
    for (var j = 1; j <= rowcount; j++) {
        var cellValue = ""
        if (typeof (oSheet.Cells(j, 1).value) == "undefined") {
            cellValue = ""
        } else {
            cellValue = oSheet.Cells(j, 1).value
        }
		if(cellValue!=""){
			if(cellValue=="dicstart"){
				dicFlag=1
			}
			ret=serverCall("web.DHCADVFormExport","importData",{pid:pid,row:j,data:cellValue,dicFlag:dicFlag})
			if(ret==1){
				errMsg=errMsg+j+"行,";
			}	
		}	
    }
    $.messager.progress('close')//数据导入完成关闭加载框

    if(errMsg!=""){
	     $.messager.confirm("操作提示", "第"+errMsg+"行字典代码和系统重复,将会覆盖系统字典,确认继续吗？", function (data) {  
            if (data) {  
               saveData(pid);  
            } 
        }); 
	}else{
		saveData(pid);  	
	}
	
    clearFiles ()
    oWB.Close(savechanges = false);
    CollectGarbage();
    oXL.Quit();
    oXL = null;
    oSheet = null;	
}

function saveData(pid){
	ret=serverCall("web.DHCADVFormExport","import",{pid:pid}) 
    if(ret==0){
	    $.messager.alert("提示","导入成功");
	}else if(ret==1){
	    $.messager.alert("提示","表单代码以存在,请修改表单代码再导入!");
	}else{
		$.messager.alert("提示","导入失败");
	}
}
