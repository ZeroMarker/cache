/// dhclab.btdata.js

$.extend($.fn.datagrid.methods, {
	editCell: function(jq,param){
		return jq.each(function(){
			var opts = $(this).datagrid('options');
			var fields = $(this).datagrid('getColumnFields',true).concat($(this).datagrid('getColumnFields'));
			for(var i=0; i<fields.length; i++){
				var col = $(this).datagrid('getColumnOption', fields[i]);
				col.editor1 = col.editor;
				if (fields[i] != param.field){
					col.editor = null;
				}
			}
			$(this).datagrid('beginEdit', param.index);
			for(var i=0; i<fields.length; i++){
				var col = $(this).datagrid('getColumnOption', fields[i]);
				col.editor = col.editor1;
			}
		});
	}
});

var editIndex = undefined;
function endEditing(t){
	if (editIndex == undefined){return true}
	if (t.datagrid('validateRow', editIndex)){
		t.datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
function onClickCell(index, field){
	t = $(this);
	if (endEditing(t)){
		t.datagrid('selectRow', index)
				.datagrid('editCell', {index:index,field:field});
		editIndex = index;
	}
}
///页面加载
$(function() {
    pageInit();
});

function pageInit() {
	ShowBTHospital(); 	
	ShowBTDepartment();
	ShowBTWorkGroup();
	ShowBTWGMachine();
	ShowBTSpecimen();
	ShowBTContainer();
	ShowBTTestCode();
	ShowBTTestCodeRanges();
	ShowBTTestCodeComments();
	ShowBTTestSet();
	ShowBTTestSetLayout();
	ShowSYSUser();
	ShowBTTestSetSpecimen();
}   ///pageInit

//导入
function ImportData(){
    $("#file_upload").click()
}

//载入导入数据
function LoadImportData(a) {
    var filename = document.getElementById("file_upload").value;
	$('#filename').val(filename)
}



//导出
function ExcelExport(gridID)
{
	var tgrid=$("#"+gridID)

	try{
    	xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add();   ///默认三个sheet
	}catch(e){
		alert(e.message);
		return;
	}

	var rows = tgrid.datagrid('getRows');
	var cols = tgrid.datagrid('getColumnFields');
	if (rows.length==0) {return;}

	xlBook.worksheets(1).select(); 
	xlsheet = xlBook.ActiveSheet;
	xlsheet.name=gridID;
	
	var currow=1;   //默认每三行开始
	//标题
	for(var j = 0 ; j < cols.length ; j++){
	    xlsheet.cells(currow,j+1)=cols[j];  
    }

	//数据明细
	for (var i = 0; i < rows.length; i++) {
		currow++
		for(var j = 0 ; j < cols.length ; j++){
			fieldName = cols[j];
			value=rows[i][fieldName];
			if (typeof(value)=="undefined") {value=""}
			xlsheet.cells(currow,j+1)=value;  
	    }
    }
	
	xlApp.Visible=true;
	xlBook.Close(savechanges=true);
	//xlApp.Quit();
	CollectGarbage();
	xlApp=null;
	xlsheet=null;
	//xlApp.Save();
	//xlsheet.SaveAs(path);   //xlsheet.SaveAs(path);  
	//xlsheet.PrintPreview();

}
	

