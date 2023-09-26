
//��ʾҽԺ
function ShowBTSpecimen() {
    $('#dgBTSpecimen').datagrid({	
    	url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCBTData",
			QueryName:"QrySpecimen",
			FunModul:"JSON"
		},		
		rownumbers: true,
		pagination: true,
		pageSize: 100,
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
          { field: 'Code', title: '����', width: 120, sortable: true, align: 'center' ,editor:'text'},
          { field: 'IName', title: '����', width: 200, sortable: true, align: 'left' ,editor:'text'},
          { field: 'WCode', title: 'Whonet��', width: 100, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Sequence', title: '���', width: 80, sortable: true, align: 'left',editor:'text'},
          { field: 'HospCode', title: 'ҽԺ����', width: 120, sortable: true, align: 'center' ,editor:'text'},
          { field: 'HospName', title: 'ҽԺ����', width: 200, sortable: true, align: 'left' ,editor:'text'},
          { field: 'RetValue', title: '������Ϣ', width: 200, sortable: true, align: 'left' ,editor:'text'}
        ]]
    });
}; //ShowBTHospital

//新增
function AddSpecimen() {
	$('#dgBTSpecimen').datagrid('appendRow',{
		RowID:'',
		Code: '',
		IName: '',
		Sequence: '',
		HospCode: '',
		HospName: ''	
	});
}

//����
function UpdSpecimen() {
    var RowID = "";
    var IName = "";
    var Code = "";
    var WCode="";
    var HospCode="";
    var HospName="";    
    var rowsel = $('#dgBTSpecimen').datagrid("getSelected");
    var currow = $('#dgBTSpecimen').datagrid('getRowIndex', rowsel);
    
    t = $('#dgBTSpecimen');
	endEditing(t);
	
    if (rowsel) {
	    RowID=rowsel.RowID
	    IName=rowsel.IName
	    Code=rowsel.Code
	    WCode=rowsel.WCode
	    Sequence=rowsel.Sequence
	    HospName=rowsel.HospName
	    HospCode=rowsel.HospCode	    
	}
    if (Code == "") { 
        $.messager.alert("��ʾ��Ϣ", '���벻��Ϊ��!', "info");
        return;
    }
    if (IName == "") { 
        $.messager.alert("��ʾ��Ϣ", '���Ʋ���Ϊ��!', "info");
        return;
    }
    $.messager.confirm('��ʾ��Ϣ', 'ȷ��Ҫ����ѡ�����'+ Code + ":" + IName + '��', function (isClickedOk) {
        if (isClickedOk) {
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTSpecimen",RowID:RowID,Code:Code,IName:IName,Sequence:Sequence,WCode:WCode,HospCode:HospCode},
				function(rtn){
					if (rtn == 1) {
                        message="���³ɹ�"
					}else
					{
						message="����ʧ��" +rtn
					}
                   $('#dgBTSpecimen').datagrid('updateRow', {
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
function DelSpecimen() {
	var RowID = "";
	var IName = "";
	var rowsel = $('#dgBTSpecimen').datagrid("getSelected");
	if (rowsel) {
	    RowID=rowsel.RowID
	    IName=rowsel.IName
	}
	if (RowID == "") { 
	    $.messager.alert("��ʾ��Ϣ", '��ѡ���¼���в���!', "info");
	    return;
	} 
    $.messager.confirm('��ʾ��Ϣ', 'ȷ��Ҫɾ��ѡ���RowID��'+RowID +":"+ IName + '��', function (isClickedOk) {
        if (isClickedOk) {
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"DelBTSpecimen",RowID:RowID},
				function(rtn){
					if (rtn == 1) {
                            $('#dgBTSpecimen').datagrid('reload');
                            $('#dgBTSpecimen').datagrid('clearSelections');
					}else
					{
						message="ɾ��ʧ��" +rtn
						$.messager.alert("��ʾ��Ϣ", message, "info");
					}
			});	
        }
    })
}
function ImportDataSpecimen() {
	var rows = $('#dgBTSpecimen').datagrid('getRows');
	var currow=0
	for (var i = 0; i < rows.length; i++) {
		var RowID=rows[i].RowID
	    var IName=rows[i].IName
	    var Code=rows[i].Code
	    var WCode=rows[i].WCode
	    var Sequence=rows[i].Sequence
		var HospCode=rows[i].HospCode

		$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTSpecimen",RowID:RowID,Code:Code,IName:IName,Sequence:Sequence,WCode:WCode,HospCode:HospCode},
		function(rtn){
			var message="";
			if (rtn == 1) {
				message="���³ɹ�"
			}else
			{
				message="����ʧ��" +rtn
			}
			currow++
			$('#dgBTSpecimen').datagrid('updateRow', {index: currow-1, row: {RetValue:message}});
		});	
	}
    //$('#dgBTSpecimen').datagrid('reload');
    //$('#dgBTSpecimen').datagrid('clearSelections');
	$.messager.alert("��ʾ��Ϣ", "���뱣�����,���鵼����Ϣ���!", "info");
}


function RefreshSpecimen(){
    $('#dgBTSpecimen').datagrid('reload');
    $('#dgBTSpecimen').datagrid('clearSelections');
}
//���뵼������
function ReadExcelSpecimen() {
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
	$('#dgBTSpecimen').datagrid("loadData",[]);
	
	xBooks.worksheets("�걾����").select(); 
	var xSheet = xBooks.ActiveSheet; 
	var rowcount=xSheet.UsedRange.Cells.Rows.Count ;  ///����  
	var colcount=xSheet.UsedRange.Cells.Columns.Count ;  ///����
	var sheetname=xSheet.name;  //��ȡsheet�ı����ĺ���
	
	for (var row=4;row<=rowcount;row++){
		var Code=xSheet.Cells(row,1).value;
		var IName=xSheet.Cells(row,2).value;
		var WCode=xSheet.Cells(row,3).value;
		var HospCode=xSheet.Cells(row,4).value;
		var HospName=xSheet.Cells(row,5).value;
				
		var msginfo=""
		if (typeof(Code)=="undefined") msginfo="���벻��Ϊ�գ�"
		if (typeof(IName)=="undefined") msginfo="���Ʋ���Ϊ�գ�"
		$('#dgBTSpecimen').datagrid('appendRow',{
			RowID:'',
			Code: Code,
			IName: IName,
			WCode:WCode,
			Sequence: row-3,
			HospCode:HospCode,
			HospName:HospName,			
			RetValue:msginfo
		});		
	}
	xBooks.Close (savechanges=false);
	xApp.Quit(); 
	xApp=null;
	xSheet=null;
	xBooks=null;
	alert("�걾��������װ�سɹ���");
}

