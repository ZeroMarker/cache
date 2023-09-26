
//��ʾҽԺ
function ShowBTWorkGroup() {
    $('#dgBTWorkGroup').datagrid({	
    	url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCBTData",
			QueryName:"QryWorkGroup",
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
          { field: 'DepartmentDR', title: 'DepartmentDR', width: 80, sortable: true, align: 'center',editor:'text'},
          { field: 'DepartmentCode', title: '������Ҵ���', width: 100, sortable: true, align: 'left',editor:'text'},
          { field: 'DepartmentName', title: '�����������', width: 200, sortable: true, align: 'left',editor:'text'},
          { field: 'Sequence', title: '���', width: 60, sortable: true, align: 'left',editor:'text'},
          { field: 'RetValue', title: '������Ϣ', width: 200, sortable: true, align: 'left' }
        ]]
    });
}; //ShowBTHospital

//新增
function AddWorkGroup() {
	$('#dgBTWorkGroup').datagrid('appendRow',{
		RowID:'',
		Code: '',
		CName: '',
		Sequence: ''
	});
}

//����
function UpdWorkGroup() {
    var RowID = "";
    var CName = "";
    var Code = "";
    var DepartmentDR=""
    var rowsel = $('#dgBTWorkGroup').datagrid("getSelected");
    var currow = $('#dgBTWorkGroup').datagrid('getRowIndex', rowsel);
   
    t = $('#dgBTWorkGroup');
	endEditing(t);
	
    if (rowsel) {
	    RowID=rowsel.RowID
	    CName=rowsel.CName
	    Code=rowsel.Code
	    Sequence=rowsel.Sequence
	    DepartmentDR=rowsel.DepartmentDR
	}
    if (Code == "") { 
        $.messager.alert("��ʾ��Ϣ", '���벻��Ϊ��!', "info");
        return;
    }
    if (CName == "") { 
        $.messager.alert("��ʾ��Ϣ", '���Ʋ���Ϊ��!', "info");
        return;
    }
    if (DepartmentDR == "") { 
        $.messager.alert("��ʾ��Ϣ", '�������RowID��DepartmentDR������Ϊ��!', "info");
        return;
    }    

    $.messager.confirm('��ʾ��Ϣ', 'ȷ��Ҫ����ѡ�����'+ Code + ":" + CName + '��', function (isClickedOk) {
        if (isClickedOk) {
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTWorkGroup",RowID:RowID,Code:Code,CName:CName,DepartmentDR:DepartmentDR,Sequence:Sequence},
				function(rtn){
					if (rtn == 1) {
                        message="���³ɹ�"
					}else
					{
						message="����ʧ��" +rtn
					}
					
                   $('#dgBTWorkGroup').datagrid('updateRow', {
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
function DelWorkGroup() {
	var RowID = "";
	var CName = "";
	var rowsel = $('#dgBTWorkGroup').datagrid("getSelected");
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"DelBTWorkGroup",RowID:RowID},
				function(rtn){
					if (rtn == 1) {
                            $('#dgBTWorkGroup').datagrid('reload');
                            $('#dgBTWorkGroup').datagrid('clearSelections');
					}else
					{
						message="ɾ��ʧ��" +rtn
						$.messager.alert("��ʾ��Ϣ", message, "info");
					}
			});	
        }
    })
}

function ImportDataWorkGroup() {
	var rows = $('#dgBTWorkGroup').datagrid('getRows');
	var currow=0
	for (var i = 0; i < rows.length; i++) {
		var RowID=rows[i].RowID
	    var CName=rows[i].CName
	    var Code=rows[i].Code
	    var Sequence=rows[i].Sequence
	    var DepartmentDR=rows[i].DepartmentDR
	    var DepartmentCode=rows[i].DepartmentCode

	    $.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTWorkGroup",RowID:RowID,Code:Code,CName:CName,DepartmentDR:DepartmentDR,Sequence:Sequence,DepartmentCode:DepartmentCode},
		function(rtn){
			var message="";
			if (rtn == 1) {
				message="���³ɹ�"
			}else
			{
				message="����ʧ��" +rtn
			}
			
			currow++
            $('#dgBTWorkGroup').datagrid('updateRow', {
                index: currow-1,
                row: {
                    RetValue: message
                }
            });			
			
		});	
	}
    //$('#dgBTWorkGroup').datagrid('reload');
    //$('#dgBTWorkGroup').datagrid('clearSelections');
	$.messager.alert("��ʾ��Ϣ", "���뱣�����,���鵼����Ϣ���!", "info");
}

function RefreshWorkGroup(){
    $('#dgBTWorkGroup').datagrid('reload');
    $('#dgBTWorkGroup').datagrid('clearSelections');
}
//���뵼������
function ReadExcelWorkGroup() {
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
	$('#dgBTWorkGroup').datagrid("loadData",[]);
	
	xBooks.worksheets("������").select(); 
	var xSheet = xBooks.ActiveSheet; 
	var rowcount=xSheet.UsedRange.Cells.Rows.Count ;  ///����  
	var colcount=xSheet.UsedRange.Cells.Columns.Count ;  ///����
	var sheetname=xSheet.name;  //��ȡsheet�ı����ĺ���
	
	for (var row=4;row<=rowcount;row++){
		var Code=xSheet.Cells(row,1).value;
		var CName=xSheet.Cells(row,2).value;
		var DepartmentCode=xSheet.Cells(row,3).value;
		var DepartmentName=xSheet.Cells(row,4).value;
		var msginfo=""
		if (Code=="undefined") msginfo="���벻��Ϊ�գ�"
		if (CName=="undefined") msginfo="���Ʋ���Ϊ�գ�"
		if (typeof(DepartmentCode)=="undefined") msginfo="������Ҵ��벻��Ϊ�գ�"
		$('#dgBTWorkGroup').datagrid('appendRow',{
			RowID:'',
			Code: Code,
			CName: CName,
			DepartmentCode:DepartmentCode,
			DepartmentName:DepartmentName,
			Sequence: row-3,
			RetValue:msginfo
		});		
	}
	xBooks.Close (savechanges=false);
	xApp.Quit(); 
	xApp=null;
	xSheet=null;
	xBooks=null;
	alert("����������װ�سɹ���");
}

