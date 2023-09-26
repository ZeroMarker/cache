
//��ʾҽԺ
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
          { field: 'Code', title: '����', width: 80, sortable: true, align: 'center' ,editor:'text'},
          { field: 'CName', title: '����', width: 200, sortable: true, align: 'left' ,editor:'text'},
          { field: 'WorkGroupDR', title: 'WorkGroupDR', width: 80, sortable: true, align: 'center',editor:'text'},
          { field: 'WorkGroupCode', title: '���������', width: 100, sortable: true, align: 'left',editor:'text'},
          { field: 'WorkGroupName', title: '����������', width: 200, sortable: true, align: 'left',editor:'text'},
          { field: 'Sequence', title: '���', width: 60, sortable: true, align: 'left',editor:'text'},
          { field: 'RetValue', title: '������Ϣ', width: 200, sortable: true, align: 'left' }
        ]]
    });
}; //ShowBTHospital

//新增
function AddWGMachine() {
	$('#dgBTWGMachine').datagrid('appendRow',{
		RowID:'',
		Code: '',
		CName: '',
		Sequence: ''
	});
}

//����
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
        $.messager.alert("��ʾ��Ϣ", '���벻��Ϊ��!', "info");
        return;
    }
    if (CName == "") { 
        $.messager.alert("��ʾ��Ϣ", '���Ʋ���Ϊ��!', "info");
        return;
    }
    if (WorkGroupDR == "") { 
        $.messager.alert("��ʾ��Ϣ", '�������RowID��WorkGroupDR������Ϊ��!', "info");
        return;
    }    

    $.messager.confirm('��ʾ��Ϣ', 'ȷ��Ҫ����ѡ�����'+ Code + ":" + CName + '��', function (isClickedOk) {
        if (isClickedOk) {
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTWGMachine",RowID:RowID,Code:Code,CName:CName,WorkGroupDR:WorkGroupDR,Sequence:Sequence},
				function(rtn){
					if (rtn == 1) {
		     			message="���³ɹ�"
					}else
					{
						message="����ʧ��" +rtn
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

 //ɾ��
function DelWGMachine() {
	var RowID = "";
	var CName = "";
	var rowsel = $('#dgBTWGMachine').datagrid("getSelected");
	if (rowsel) {
	    RowID=rowsel.RowID
	    CName=rowsel.CName
	}
	if (RowID == "") { 
	    $.messager.alert("��ʾ��Ϣ", '��ѡ���¼���в���!', "info");
	    return;
	} 
    $.messager.confirm('��ʾ��Ϣ', 'ȷ��Ҫɾ��ѡ���RowID��'+RowID +":"+ CName + '��', function (isClickedOk) {
        if (isClickedOk) {
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"DelBTWGMachine",RowID:RowID},
				function(rtn){
					if (rtn == 1) {
                            $('#dgBTWGMachine').datagrid('reload');
                            $('#dgBTWGMachine').datagrid('clearSelections');
					}else
					{
						message="ɾ��ʧ��" +rtn
						$.messager.alert("��ʾ��Ϣ", message, "info");
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
				message="���³ɹ�"
			}else
			{
				message="����ʧ��" +rtn
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
	$.messager.alert("��ʾ��Ϣ", "���뱣�����,���鵼����Ϣ���!", "info");
}

function RefreshWGMachine(){
    $('#dgBTWGMachine').datagrid('reload');
    $('#dgBTWGMachine').datagrid('clearSelections');
}
//���뵼������
function ReadExcelWGMachine() {
	var filename=$('#filename').val()
	if (filename=='')
	{
		alert("��ѡ�����ļ���");
		return;
	}   	
   	//var filename="D:\\iMedicalLIS��׼ģ��.xls"
	try{ 
		var xApp = new ActiveXObject("Excel.application"); 
		var xBooks = xApp.Workbooks.open(filename);   
	}		
	catch(e){
		var emsg="����IE�µ��룬����[internetѡ��]-[��ȫ]-[�����ε�վ��]-[վ��]����ӿ�ʼ���浽�����ε�վ�㣬Ȼ����[�Զ��弶��]�ж�[û�б��Ϊ��ȫ��ActiveX�ؼ����г�ʼ���ͽű�����]��һ������Ϊ����!"
		alert(e.message);
		return;
	}
	$('#dgBTWGMachine').datagrid("loadData",[]);
	
	xBooks.worksheets("����С��").select(); 
	var xSheet = xBooks.ActiveSheet; 
	var rowcount=xSheet.UsedRange.Cells.Rows.Count ;  ///����  
	var colcount=xSheet.UsedRange.Cells.Columns.Count ;  ///����
	var sheetname=xSheet.name;  //��ȡsheet�ı����ĺ���
	
	for (var row=4;row<=rowcount;row++){
		var Code=xSheet.Cells(row,1).value;
		var CName=xSheet.Cells(row,2).value;
		var WorkGroupCode=xSheet.Cells(row,3).value;
		var WorkGroupName=xSheet.Cells(row,4).value;
		var msginfo=""
		if (Code=="undefined") msginfo="���벻��Ϊ�գ�"
		if (CName=="undefined") msginfo="���Ʋ���Ϊ�գ�"
		if (typeof(WorkGroupCode)=="undefined") msginfo="��������벻��Ϊ�գ�"
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
	alert("����С������װ�سɹ���");
}

