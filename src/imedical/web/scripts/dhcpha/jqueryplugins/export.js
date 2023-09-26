/*
 *creator:yunhaibao
 *createdate:2016-05-20
 *description:easyui datagrid导出
 */
 //exportway为空:按行写数据,为1按单元格写数据
function ExportAllToExcel(exportGrid){
	if (exportGrid==""){
		return;
	}
	if ($('#'+exportGrid).datagrid("getRows").length<=0){
		$.messager.alert('提示',"没有数据!","info");
		return;
	}
	var exportway=""
	var exportwaydiv="<div><form>"+
					 "<p><span><input style='vertical-align:middle' type='checkbox' class='ui-checkbox' id='chkFast' onclick='ChangeExportWay(1)' checked='true'></input></span><span style='vertical-align:middle'><font color='#0e2d5f'><b>快速导出</b></font>＜导出按行写入数据,速度较快,但无法补数字前的零＞</span></p>"+
					 "<p><span><input style='vertical-align:middle' type='checkbox' class='ui-checkbox' id='chkNormal' onclick='ChangeExportWay(2)'></input></span><span style='vertical-align:middle'><font color='#0e2d5f'><b>正常导出</b></font>＜导出按单元格写入数据,导出大量数据较慢＞</span></p>"+
					 "</form></div>";
	$dialog = $(exportwaydiv).dialog({     
		title: '导出方式',     
		width: 375,     
		height: 165,     
		iconCls : '',    
		closed: true,     
		cache: false,         
		modal: true,               
		buttons : [ 
			{    
				text : '确定',    
				iconCls : 'icon-ok',    
				handler : function() { 
					var exportway="";
					if ($("input[id=chkFast]").prop("checked")){
						exportway=1;
					}
					if ($("input[id=chkNormal]").prop("checked")){
						exportway=2;
					}
					if (exportway==""){
						$.messager.alert("提示","请先选择导出方式","info");
						return;
					}
					ExportAllToExcelHandler(exportGrid,exportway);
					$dialog.dialog('close');                                               
				}    
			},{    
				text : '取消',    
				iconCls : 'icon-cancel',    
				handler : function() {    
					$dialog.dialog('close');    
				}    
			} 
		]  
	});  
	$("input[id=chkNormal]").prop("checked", false);  
	$("input[id=chkFast]").prop("checked", true);     
	$dialog.dialog('open'); 
}
//exportway=1:按行导出,exportway=2:按单元格导出
function ExportAllToExcelHandler(exportGrid,exportway){
	if (exportway=="1"){
		try{
			var mscd = new ActiveXObject("MSComDlg.CommonDialog");
			mscd.Filter = "Microsoft Office Excel(*.xls)|*.xls";
			mscd.FilterIndex = 1;
			// 必须设置MaxFileSize. 否则出错
			mscd.MaxFileSize = 32767;
			// 显示对话框
			mscd.ShowSave();
			var fileName=mscd.FileName;
			mscd=null;
		}
		catch(e)
		{
				if (confirm("当前系统不支持创建路径,是否载入文件配置?\n载入成功后,重启浏览器生效!"))
				{
					var fso = new ActiveXObject("Scripting.FileSystemObject");
					var sTextfile = fso.CreateTextFile("C:\\MSCommonDialog.reg",true)
					sTextfile.WriteLine("Windows Registry Editor Version 5.00")
					sTextfile.WriteLine("[HKEY_CLASSES_ROOT\\Licenses\\4D553650-6ABE-11cf-8ADB-00AA00C00905]")
					sTextfile.WriteLine("@=\"gfjmrfkfifkmkfffrlmmgmhmnlulkmfmqkqj\"")
					sTextfile.Close();
					sTextfile=null;
					fso=null;
					var shell = new ActiveXObject("WScript.Shell"); 
					shell.Run("C:\\MSCommonDialog.reg");
					return;
					
				}
				else{
					return;					
				}
		}
	}
	if ((exportway=="1")&&(fileName=='')){return;}
	var exportGridOption=$('#'+exportGrid).datagrid("options")
	var exportGridparams=exportGridOption.queryParams.params;
	var exportGridUrl=exportGridOption.url;
	var exportGridColumn="" //列好办
	/*$.messager.show({
		title:"提示",
		msg:"正在处理，请稍后...'",
		timeout:3000,
		showType:'slide'
	});*/
	$.messager.progress({ 
	    title: '请等待', 
	    msg: '处理数据中...', 
	    text: '加载中.......' 
	});
	$.ajax({
		type: "GET",
		url: exportGridUrl+"&page=1&rows=9999&params="+exportGridparams,
		async:false,
		dataType: "json",
		success: function(exportdata){
			if (exportway=="1"){
				ExportToExcelFromJsonData(exportdata,fileName,exportGrid); 
			}else{
				ExportToExcelFromJsonDataCell(exportdata,exportGrid);
			}
			$.messager.progress('close');
		}
	});
}
function ExportToExcelFromJsonData(exportdata,fileName,exportGrid){
	//获取对应grid非隐藏列
	var exportGridColumns = $('#'+exportGrid).datagrid("options").columns;
	var exportGridColumnsStr=$('#'+exportGrid).datagrid('getColumnFields',false);
	var exportGridTitleLength=exportGridColumnsStr.length;
	var exportGridTitle="",exportGridField="";
	for (var exporti=0;exporti<exportGridTitleLength;exporti++){
		var exportGridFieldi=exportGridColumnsStr[exporti]
	    var exportGridColumnOption = $('#'+exportGrid).datagrid("getColumnOption",exportGridFieldi)
		var titleDesc=exportGridColumnOption.title;
		if (exportGridColumnOption.hidden==true){
			continue;
		}
		if (exportGridTitle==""){
			exportGridTitle=titleDesc;
			exportGridField=exportGridFieldi;
		}else{
			exportGridTitle=exportGridTitle+String.fromCharCode(9)+titleDesc;
			exportGridField=exportGridField+String.fromCharCode(9)+exportGridFieldi;
		}
	}
	var FSO=new ActiveXObject("Scripting.FileSystemObject");
	var fs = FSO.CreateTextFile(fileName,true);
	//写标题
	fs.write(exportGridTitle + '\r\n');
	var tmpjsonObject = JSON.stringify(exportdata.rows);
    var colarray = typeof tmpjsonObject != 'object' ? JSON.parse(tmpjsonObject) : tmpjsonObject;
    var str = '';
    var exportGridFieldArr=exportGridField.split(String.fromCharCode(9))
    var exportGridFieldLen=exportGridFieldArr.length;
    for (var i = 0; i < colarray.length; i++) {
        var line = "";
        for (var j = 0; j < exportGridFieldLen; j++) {
	        var index=exportGridFieldArr[j];		    
	        var exportGridColumnOption = $('#'+exportGrid).datagrid("getColumnOption",index);
			if (line != '') line +=String.fromCharCode(9);	//to xls
			var colvalue=colarray[i][index];
			//var regExpPattern=/^(-?\d*)(.?\d*)$/; 
			//if(colvalue!="" && regExpPattern.test(colvalue)){
			//	colvalue="/"+colvalue
			//}
            line +=colvalue;
        }
        fs.write(line + '\r\n');
    }
	fs.close();
}

function ExportToExcelFromJsonDataCell(exportdata,exportGrid){
	//获取对应grid非隐藏列
	var oXL = new ActiveXObject("Excel.application");  
    var oWB = oXL.Workbooks.Add(); 
    var oSheet = oWB.ActiveSheet; 
    //oSheet.Cells(2,2).NumberFormatLocal = "@" 
	var exportGridColumns = $('#'+exportGrid).datagrid("options").columns;
	var exportGridColumnsStr=$('#'+exportGrid).datagrid('getColumnFields',false);
	var exportGridTitleLength=exportGridColumnsStr.length;
	var exportGridTitle="",exportGridField="",exportcol=0;
	for (var exporti=0;exporti<exportGridTitleLength;exporti++){
		var exportGridFieldi=exportGridColumnsStr[exporti]
	    var exportGridColumnOption = $('#'+exportGrid).datagrid("getColumnOption",exportGridFieldi)
		var titleDesc=exportGridColumnOption.title;
		if (exportGridColumnOption.hidden==true){
			continue;
		}
		exportcol=exportcol+1;
		oSheet.Cells(1,exportcol).value=titleDesc; //写标题
		if (exportGridField==""){
			exportGridField=exportGridFieldi;
		}else{
			exportGridField=exportGridField+String.fromCharCode(9)+exportGridFieldi;
		}
	}
	var tmpjsonObject = JSON.stringify(exportdata.rows);
    var colarray = typeof tmpjsonObject != 'object' ? JSON.parse(tmpjsonObject) : tmpjsonObject;
    var str = '';
    var exportGridFieldArr=exportGridField.split(String.fromCharCode(9))
    var exportGridFieldLen=exportGridFieldArr.length;
    for (var i = 0; i < colarray.length; i++) {
        for (var j = 0; j < exportGridFieldLen; j++) {
	        var index=exportGridFieldArr[j];		    
	        var exportGridColumnOption = $('#'+exportGrid).datagrid("getColumnOption",index);
			var colvalue=colarray[i][index];
			var regExpPattern=/^(-?\d*)(.?\d*)$/; 
			if(colvalue!="" && regExpPattern.test(colvalue)){
				oSheet.Cells(i+2,j+1).NumberFormatLocal = "@" 
			}
            oSheet.Cells(i+2,j+1).value=colvalue; //写标题
        }
    }
	oXL.Visible = true; 
	oXL.UserControl = true; 
    //手动调用垃圾收集器  
    //CollectGarbage(); 
}
function ChangeExportWay(exportway){
	if (exportway=="1"){
		$("input[id=chkNormal]").prop("checked", false);  
		$("input[id=chkFast]").prop("checked", true);  
	}else if (exportway=="2"){
		$("input[id=chkNormal]").prop("checked", true);  
		$("input[id=chkFast]").prop("checked", false); 
	}
}