
//显示医院
function ShowBTWGMachine() {
    $('#dgBTWGMachine').datagrid({	
    	url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCBTData",
			QueryName:"QryWGMachine",
			FunModul:"JSON"
		},		
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		pageList: [20, 50, 100, 200],
		sortName: 'Sequence',
		sortOrder: 'dasc',		
		striped:true,
		nowrap: false, 
		border: true,
		collapsible: true,
		singleSelect:true,
		selectOnCheck: false,
        checkOnSelect: false,
        onClickCell: onClickCell,
		fit:true, 
        columns: [[
          { field: 'RowID', title: 'RowID', width: 60, sortable: true, align: 'left',editor:'text' },
          { field: 'Code', title: '代码', width: 80, sortable: true, align: 'center' ,editor:'text'},
          { field: 'CName', title: '名称', width: 200, sortable: true, align: 'left' ,editor:'text'},
          { field: 'WorkGroupDR', title: 'WorkGroupDR', width: 80, sortable: true, align: 'center',editor:'text'},
          { field: 'WorkGroupCode', title: '工作组代码', width: 100, sortable: true, align: 'left',editor:'text'},
          { field: 'WorkGroupName', title: '工作组名称', width: 200, sortable: true, align: 'left',editor:'text'},
          { field: 'Sequence', title: '序号', width: 60, sortable: true, align: 'left',editor:'text'},
          { field: 'RetValue', title: '导入信息', width: 200, sortable: true, align: 'left' }
        ]]
    });
}; //ShowBTHospital

//鏂板
function AddWGMachine() {
	$('#dgBTWGMachine').datagrid('appendRow',{
		RowID:'',
		Code: '',
		CName: '',
		Sequence: ''
	});
}

//更新
function UpdWGMachine() {
    var RowID = "";
    var CName = "";
    var Code = "";
    var WorkGroupDR=""
    var rowsel = $('#dgBTWGMachine').datagrid("getSelected");
    var currow = $('#dgBTWGMachine').datagrid('getRowIndex', rowsel);
    
    t = $('#dgBTWGMachine');
	endEditing(t);
	
    if (rowsel) {
	    RowID=rowsel.RowID
	    CName=rowsel.CName
	    Code=rowsel.Code
	    Sequence=rowsel.Sequence
	    WorkGroupDR=rowsel.WorkGroupDR
	}
    if (Code == "") { 
        $.messager.alert("提示信息", '代码不能为空!', "info");
        return;
    }
    if (CName == "") { 
        $.messager.alert("提示信息", '名称不能为空!', "info");
        return;
    }
    if (WorkGroupDR == "") { 
        $.messager.alert("提示信息", '检验科室RowID【WorkGroupDR】不能为空!', "info");
        return;
    }    

    $.messager.confirm('提示信息', '确认要更新选择项？【'+ Code + ":" + CName + '】', function (isClickedOk) {
        if (isClickedOk) {
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTWGMachine",RowID:RowID,Code:Code,CName:CName,WorkGroupDR:WorkGroupDR,Sequence:Sequence},
				function(rtn){
					if (rtn == 1) {
		     			message="更新成功"
					}else
					{
						message="更新失败" +rtn
					}

                   $('#dgBTWGMachine').datagrid('updateRow', {
		                index: currow,
		                row: {
		                    RetValue: message
		                }
		            });	
			});	
        }
    })    
    
}

 //删除
function DelWGMachine() {
	var RowID = "";
	var CName = "";
	var rowsel = $('#dgBTWGMachine').datagrid("getSelected");
	if (rowsel) {
	    RowID=rowsel.RowID
	    CName=rowsel.CName
	}
	if (RowID == "") { 
	    $.messager.alert("提示信息", '请选择记录进行操作!', "info");
	    return;
	} 
    $.messager.confirm('提示信息', '确认要删除选择项？RowID【'+RowID +":"+ CName + '】', function (isClickedOk) {
        if (isClickedOk) {
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"DelBTWGMachine",RowID:RowID},
				function(rtn){
					if (rtn == 1) {
                            $('#dgBTWGMachine').datagrid('reload');
                            $('#dgBTWGMachine').datagrid('clearSelections');
					}else
					{
						message="删除失败" +rtn
						$.messager.alert("提示信息", message, "info");
					}
			});	
        }
    })
}

function ImportDataWGMachine() {
	var rows = $('#dgBTWGMachine').datagrid('getRows');
	var currow=0
	for (var i = 0; i < rows.length; i++) {
		var RowID=rows[i].RowID
	    var CName=rows[i].CName
	    var Code=rows[i].Code
	    var Sequence=rows[i].Sequence
	    var WorkGroupDR=rows[i].WorkGroupDR
	    var WorkGroupCode=rows[i].WorkGroupCode

	    $.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTWGMachine",RowID:RowID,Code:Code,CName:CName,WorkGroupDR:WorkGroupDR,Sequence:Sequence,WorkGroupCode:WorkGroupCode},
		function(rtn){
			var message="";
			if (rtn == 1) {
				message="更新成功"
			}else
			{
				message="更新失败" +rtn
			}
			
			currow++
            $('#dgBTWGMachine').datagrid('updateRow', {
                index: currow-1,
                row: {
                    RetValue: message
                }
            });			
			
		});	
	}
    //$('#dgBTWGMachine').datagrid('reload');
    //$('#dgBTWGMachine').datagrid('clearSelections');
	$.messager.alert("提示信息", "导入保存完成,请检查导入信息情况!", "info");
}

function RefreshWGMachine(){
    $('#dgBTWGMachine').datagrid('reload');
    $('#dgBTWGMachine').datagrid('clearSelections');
}
//载入导入数据
function ReadExcelWGMachine() {
	var filename=$('#filename').val()
	if (filename=='')
	{
		alert("请选择导入文件！");
		return;
	}   	
   	//var filename="D:\\iMedicalLIS标准模板.xls"
	try{ 
		var xApp = new ActiveXObject("Excel.application"); 
		var xBooks = xApp.Workbooks.open(filename);   
	}		
	catch(e){
		var emsg="请在IE下导入，并在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!"
		alert(e.message);
		return;
	}
	$('#dgBTWGMachine').datagrid("loadData",[]);
	
	xBooks.worksheets("工作小组").select(); 
	var xSheet = xBooks.ActiveSheet; 
	var rowcount=xSheet.UsedRange.Cells.Rows.Count ;  ///行数  
	var colcount=xSheet.UsedRange.Cells.Columns.Count ;  ///列数
	var sheetname=xSheet.name;  //获取sheet的表中文含义
	
	for (var row=4;row<=rowcount;row++){
		var Code=xSheet.Cells(row,1).value;
		var CName=xSheet.Cells(row,2).value;
		var WorkGroupCode=xSheet.Cells(row,3).value;
		var WorkGroupName=xSheet.Cells(row,4).value;
		var msginfo=""
		if (Code=="undefined") msginfo="代码不能为空！"
		if (CName=="undefined") msginfo="名称不能为空！"
		if (typeof(WorkGroupCode)=="undefined") msginfo="工作组代码不能为空！"
		$('#dgBTWGMachine').datagrid('appendRow',{
			RowID:'',
			Code: Code,
			CName: CName,
			WorkGroupCode:WorkGroupCode,
			WorkGroupName:WorkGroupName,
			Sequence: row-3,
			RetValue:msginfo
		});		
	}
	xBooks.Close (savechanges=false);
	xApp.Quit(); 
	xApp=null;
	xSheet=null;
	xBooks=null;
	alert("工作小组数据装载成功！");
}

