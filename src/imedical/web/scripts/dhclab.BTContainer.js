
//��ʾҽԺ
function ShowBTContainer() {
    $('#dgBTContainer').datagrid({	
    	url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCBTData",
			QueryName:"QryContainer",
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
          { field: 'RowID', title: 'RowID', width: 60, sortable: true, align: 'left',editor:'text' },
          { field: 'Code', title: '����', width: 100, sortable: true, align: 'center' ,editor:'text'},
          { field: 'CName', title: '����', width: 200, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Volumn', title: '�ɼ�����', width: 100, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Color', title: '��ñ��ɫ', width: 100, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Remark', title: '˵��', width: 100, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Sequence', title: '���', width: 80, sortable: true, align: 'left',editor:'text'},
          { field: 'HospCode', title: 'ҽԺ����', width: 100, sortable: true, align: 'center' ,editor:'text'},
          { field: 'HospName', title: 'ҽԺ����', width: 200, sortable: true, align: 'left' ,editor:'text'},
          { field: 'RetValue', title: '������Ϣ', width: 200, sortable: true, align: 'left' ,editor:'text'}
        ]]
    });
}; //ShowBTHospital

//新增
function AddContainer() {
	$('#dgBTContainer').datagrid('appendRow',{
		RowID:'',
		Code: '',
		CName: '',
		Sequence: '',
		HospCode: '',
		HospName: ''
	});
}

//����
function UpdContainer() {
    var RowID = "";
    var CName = "";
    var Code = "";
    var Volumn="";
    var Color="";
    var Remark="";
    var HospCode="";
    var HospName="";    
    var rowsel = $('#dgBTContainer').datagrid("getSelected");
    var currow = $('#dgBTContainer').datagrid('getRowIndex', rowsel);
    
    t = $('#dgBTContainer');
	endEditing(t);
	
    if (rowsel) {
	    RowID=rowsel.RowID
	    CName=rowsel.CName
	    Code=rowsel.Code
	    Volumn=rowsel.Volumn
	    Color=rowsel.Color
	    Remark=rowsel.Remark
	    Sequence=rowsel.Sequence
	    HospName=rowsel.HospName
	    HospCode=rowsel.HospCode		    
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTContainer",RowID:RowID,Code:Code,CName:CName,Sequence:Sequence,Volumn:Volumn,Color:Color,Remark:Remark,HospCode:HospCode},
				function(rtn){
					if (rtn == 1) {
                        message="���³ɹ�"
					}else
					{
						message="����ʧ��" +rtn
					}
                   $('#dgBTContainer').datagrid('updateRow', {
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
function DelContainer() {
	var RowID = "";
	var CName = "";
	var rowsel = $('#dgBTContainer').datagrid("getSelected");
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"DelBTContainer",RowID:RowID},
				function(rtn){
					if (rtn == 1) {
                            $('#dgBTContainer').datagrid('reload');
                            $('#dgBTContainer').datagrid('clearSelections');
					}else
					{
						message="ɾ��ʧ��" +rtn
						$.messager.alert("��ʾ��Ϣ", message, "info");
					}
			});	
        }
    })
}
function ImportDataContainer() {
	var rows = $('#dgBTContainer').datagrid('getRows');
	var currow=0
	for (var i = 0; i < rows.length; i++) {
		var RowID=rows[i].RowID
	    var CName=rows[i].CName
	    var Code=rows[i].Code
	    var Volumn=rows[i].Volumn
	    var Color=rows[i].Color
	    var Remark=rows[i].Remark
	    var Sequence=rows[i].Sequence
	    var HospCode=rows[i].HospCode
	    	    
		$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTContainer",RowID:RowID,Code:Code,CName:CName,Sequence:Sequence,Volumn:Volumn,Color:Color,Remark:Remark,HospCode:HospCode},
		function(rtn){
			var message="";
			if (rtn == 1) {
				message="���³ɹ�"
			}else
			{
				message="����ʧ��" +rtn
			}
			currow++
			$('#dgBTContainer').datagrid('updateRow', {index: currow-1, row: {RetValue:message}});
		});	
	}
    //$('#dgBTContainer').datagrid('reload');
    //$('#dgBTContainer').datagrid('clearSelections');
	$.messager.alert("��ʾ��Ϣ", "���뱣�����,���鵼����Ϣ���!", "info");
}


function RefreshContainer(){
    $('#dgBTContainer').datagrid('reload');
    $('#dgBTContainer').datagrid('clearSelections');
}
//���뵼������
function ReadExcelContainer() {
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
	$('#dgBTContainer').datagrid("loadData",[]);
	
	xBooks.worksheets("�ɼ�����").select(); 
	var xSheet = xBooks.ActiveSheet; 
	var rowcount=xSheet.UsedRange.Cells.Rows.Count ;  ///����  
	var colcount=xSheet.UsedRange.Cells.Columns.Count ;  ///����
	var sheetname=xSheet.name;  //��ȡsheet�ı����ĺ���
	
	for (var row=4;row<=rowcount;row++){
		var Code=xSheet.Cells(row,1).value;
		var CName=xSheet.Cells(row,2).value;
		var Volumn=xSheet.Cells(row,3).value;
		var Color=xSheet.Cells(row,4).value;
		var Remark=xSheet.Cells(row,5).value;
		var HospCode=xSheet.Cells(row,6).value;
		var HospName=xSheet.Cells(row,7).value;		
		var msginfo=""
		if (typeof(Code)=="undefined") msginfo="���벻��Ϊ�գ�"
		if (typeof(CName)=="undefined") msginfo="���Ʋ���Ϊ�գ�"
		$('#dgBTContainer').datagrid('appendRow',{
			RowID:'',
			Code: Code,
			CName: CName,
			Volumn:Volumn,
			Color:Color,
			Remark:Remark,
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
	alert("�ɼ���������װ�سɹ���");
}

