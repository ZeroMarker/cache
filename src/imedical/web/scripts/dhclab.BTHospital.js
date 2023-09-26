
//��ʾҽԺ
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
          { field: 'Code', title: '����', width: 160, sortable: true, align: 'center' ,editor:'text'},
          { field: 'CName', title: '����', width: 380, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Sequence', title: '���', width: 80, sortable: true, align: 'left',editor:'text' },
        ]]
    });
}; //ShowBTHospital

//新增
function AddHosp() {
	$('#dgBTHospital').datagrid('appendRow',{
		RowID:'',
		Code: '',
		CName: '',
		Sequence: ''
	});
}

//����
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
        $.messager.alert("��ʾ��Ϣ", '���벻��Ϊ��!', "info");
        return;
    }
    if (CName == "") { 
        $.messager.alert("��ʾ��Ϣ", '���Ʋ���Ϊ��!', "info");
        return;
    }
    $.messager.confirm('��ʾ��Ϣ', 'ȷ��Ҫ����ѡ�����'+ Code + ":" + CName + '��', function (isClickedOk) {
        if (isClickedOk) {
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTHospital",RowID:RowID,Code:Code,CName:CName,Sequence:Sequence},
				function(rtn){
					if (rtn == 1) {
                            $('#dgBTHospital').datagrid('reload');
                            $('#dgBTHospital').datagrid('clearSelections');
					}else
					{
						message="����ʧ��" +rtn
						$.messager.alert("��ʾ��Ϣ", message, "info");
					}
			});	
        }
    })    
    
}

 //ɾ��
function DelHosp() {
	var RowID = "";
	var CName = "";
	var rowsel = $('#dgBTHospital').datagrid("getSelected");
	if (rowsel) {
	    RowID=rowsel.RowID
	    CName=rowsel.CName
	}

	if (RowID == "") { 
	    $.messager.alert("��ʾ��Ϣ", '��ѡ���¼���в���!', "info");
	    return;
	} 
    if (RowID == "1") { 
    	$.messager.alert("��ʾ��Ϣ", 'RowIDΪ��1��Ĭ��Ϊ��ҽԺ����!����ɾ����ֻ�ܸ��£�', "info");
        return;
    } 
    $.messager.confirm('��ʾ��Ϣ', 'ȷ��Ҫɾ��ѡ���RowID��'+RowID +":"+ CName + '��', function (isClickedOk) {
        if (isClickedOk) {
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"DelBTHospital",RowID:RowID},
				function(rtn){
					if (rtn == 1) {
                            $('#dgBTHospital').datagrid('reload');
                            $('#dgBTHospital').datagrid('clearSelections');
					}else
					{
						message="ɾ��ʧ��" +rtn
						$.messager.alert("��ʾ��Ϣ", message, "info");
					}
			});	
        }
    })
}



