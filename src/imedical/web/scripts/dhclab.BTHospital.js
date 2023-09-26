
//显示医院
function ShowBTHospital() {
    $('#dgBTHospital').datagrid({	
    	url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCBTData",
			QueryName:"QryHospital",
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
          { field: 'RowID', title: 'RowID', width: 80, sortable: true, align: 'left',editor:'text' },
          { field: 'Code', title: '代码', width: 160, sortable: true, align: 'center' ,editor:'text'},
          { field: 'CName', title: '名称', width: 380, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Sequence', title: '序号', width: 80, sortable: true, align: 'left',editor:'text' },
        ]]
    });
}; //ShowBTHospital

//鏂板
function AddHosp() {
	$('#dgBTHospital').datagrid('appendRow',{
		RowID:'',
		Code: '',
		CName: '',
		Sequence: ''
	});
}

//更新
function UpdHosp() {
    var RowID = "";
    var CName = "";
    var Code = "";
    var rowsel = $('#dgBTHospital').datagrid("getSelected");
    
    t = $('#dgBTHospital');
	endEditing(t);
	
    if (rowsel) {
	    RowID=rowsel.RowID
	    CName=rowsel.CName
	    Code=rowsel.Code
	    Sequence=rowsel.Sequence
	}
    if (Code == "") { 
        $.messager.alert("提示信息", '代码不能为空!', "info");
        return;
    }
    if (CName == "") { 
        $.messager.alert("提示信息", '名称不能为空!', "info");
        return;
    }
    $.messager.confirm('提示信息', '确认要更新选择项？【'+ Code + ":" + CName + '】', function (isClickedOk) {
        if (isClickedOk) {
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTHospital",RowID:RowID,Code:Code,CName:CName,Sequence:Sequence},
				function(rtn){
					if (rtn == 1) {
                            $('#dgBTHospital').datagrid('reload');
                            $('#dgBTHospital').datagrid('clearSelections');
					}else
					{
						message="更新失败" +rtn
						$.messager.alert("提示信息", message, "info");
					}
			});	
        }
    })    
    
}

 //删除
function DelHosp() {
	var RowID = "";
	var CName = "";
	var rowsel = $('#dgBTHospital').datagrid("getSelected");
	if (rowsel) {
	    RowID=rowsel.RowID
	    CName=rowsel.CName
	}

	if (RowID == "") { 
	    $.messager.alert("提示信息", '请选择记录进行操作!', "info");
	    return;
	} 
    if (RowID == "1") { 
    	$.messager.alert("提示信息", 'RowID为【1】默认为主医院代码!不能删除，只能更新！', "info");
        return;
    } 
    $.messager.confirm('提示信息', '确认要删除选择项？RowID【'+RowID +":"+ CName + '】', function (isClickedOk) {
        if (isClickedOk) {
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"DelBTHospital",RowID:RowID},
				function(rtn){
					if (rtn == 1) {
                            $('#dgBTHospital').datagrid('reload');
                            $('#dgBTHospital').datagrid('clearSelections');
					}else
					{
						message="删除失败" +rtn
						$.messager.alert("提示信息", message, "info");
					}
			});	
        }
    })
}



