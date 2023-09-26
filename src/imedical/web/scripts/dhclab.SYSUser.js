
//��ʾҽԺ
function ShowSYSUser() {
    $('#dgSYSUser').datagrid({	
    	url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCBTData",
			QueryName:"QrySYSUser",
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
          { field: 'Code', title: '����', width: 60, sortable: true, align: 'center' ,editor:'text'},
          { field: 'CName', title: '����', width: 80, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Password', title: '����', width: 260, sortable: true, align: 'left' ,editor:'text'},
          { field: 'GroupCode', title: '��ȫ��', width: 160, sortable: true, align: 'left' ,editor:'text'},
          { field: 'WorkGroupCode', title: '��¼������', width: 100, sortable: true, align: 'left' ,editor:'text'},
          { field: 'WorkGroupName', title: '��¼����������', width: 180, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Sequence', title: '���', width: 80, sortable: true, align: 'left',editor:'text'},
          { field: 'HospCode', title: 'ҽԺ����', width: 120, sortable: true, align: 'center' ,editor:'text'},
          { field: 'HospName', title: 'ҽԺ����', width: 200, sortable: true, align: 'left' ,editor:'text'},
          { field: 'RetValue', title: '������Ϣ', width: 100, sortable: true, align: 'left' ,editor:'text'}
        ]]
    });
}; //ShowBTHospital

//新增
function AddSYSUser() {
	$('#dgSYSUser').datagrid('appendRow',{
		RowID:'',
		Code: '',
		CName: '',
		Sequence: ''
	});
}

//����
function UpdSYSUser() {
    var RowID = "";
    var CName = "";
    var Code = "";
    var Password=""
    var GroupCode="";
    var WorkGroupCode="";
    var HospCode="";
    var HospName="";     
    var rowsel = $('#dgSYSUser').datagrid("getSelected");
    var currow = $('#dgSYSUser').datagrid('getRowIndex', rowsel);
    
    t = $('#dgSYSUser');
	endEditing(t);
	
    if (rowsel) {
	    RowID=rowsel.RowID
	    CName=rowsel.CName
	    Code=rowsel.Code
	    Password=rowsel.Password
	    GroupCode=rowsel.GroupCode
	    WorkGroupCode=rowsel.WorkGroupCode
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdSYSUser",RowID:RowID,Code:Code,CName:CName,Password:Password,Sequence:Sequence,GroupCode:GroupCode,WorkGroupCode:WorkGroupCode,HospCode:HospCode},
				function(rtn){
					if (rtn == 1) {
                        message="���³ɹ�"
					}else
					{
						message="����ʧ��" +rtn
					}
                   $('#dgSYSUser').datagrid('updateRow', {
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
function DelSYSUser() {
	var RowID = "";
	var CName = "";
	var rowsel = $('#dgSYSUser').datagrid("getSelected");
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"DelSYSUser",RowID:RowID},
				function(rtn){
					if (rtn == 1) {
                            $('#dgSYSUser').datagrid('reload');
                            $('#dgSYSUser').datagrid('clearSelections');
					}else
					{
						message="ɾ��ʧ��" +rtn
						$.messager.alert("��ʾ��Ϣ", message, "info");
					}
			});	
        }
    })
}
function ImportDataSYSUser() {
	var rows = $('#dgSYSUser').datagrid('getRows');
	var currow=0
	for (var i = 0; i < rows.length; i++) {
		var RowID=rows[i].RowID
	    var CName=rows[i].CName
	    var Code=rows[i].Code
	    var Password=rows[i].Password
		var GroupCode=rows[i].GroupCode
	    var WorkGroupCode=rows[i].WorkGroupCode
	    var Sequence=rows[i].Sequence
		var HospCode=rows[i].HospCode
			    
		$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdSYSUser",RowID:RowID,Code:Code,CName:CName,Password:Password,Sequence:Sequence,GroupCode:GroupCode,WorkGroupCode:WorkGroupCode,HospCode:HospCode},
		function(rtn){
			var message="";
			if (rtn == 1) {
				message="���³ɹ�"
			}else
			{
				message="����ʧ��" +rtn
			}
			currow++
			$('#dgSYSUser').datagrid('updateRow', {index: currow-1, row: {RetValue:message}});
		});	
	}
    //$('#dgSYSUser').datagrid('reload');
    //$('#dgSYSUser').datagrid('clearSelections');
	$.messager.alert("��ʾ��Ϣ", "���뱣�����,���鵼����Ϣ���!", "info");
}


function RefreshSYSUser(){
    $('#dgSYSUser').datagrid('reload');
    $('#dgSYSUser').datagrid('clearSelections');
}
//���뵼������
function ReadExcelSYSUser() {
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
	$('#dgSYSUser').datagrid("loadData",[]);
	
	xBooks.worksheets("�û�").select(); 
	var xSheet = xBooks.ActiveSheet; 
	var rowcount=xSheet.UsedRange.Cells.Rows.Count ;  ///����  
	var colcount=xSheet.UsedRange.Cells.Columns.Count ;  ///����
	var sheetname=xSheet.name;  //��ȡsheet�ı����ĺ���
	
	for (var row=4;row<=rowcount;row++){
		var Code=xSheet.Cells(row,1).value;
		var CName=xSheet.Cells(row,2).value;
		var Password=xSheet.Cells(row,3).value;
		var GroupCode=xSheet.Cells(row,4).value;
		var WorkGroupCode=xSheet.Cells(row,5).value;
		var HospCode=xSheet.Cells(row,6).value;
		var HospName=xSheet.Cells(row,7).value;
		
		var msginfo=""
		if (typeof(Code)=="undefined") msginfo="���벻��Ϊ�գ�"
		if (typeof(CName)=="undefined") msginfo="���Ʋ���Ϊ�գ�"
		$('#dgSYSUser').datagrid('appendRow',{
			RowID:'',
			Code: Code,
			CName: CName,
			Password:Password,
			GroupCode:GroupCode,
			WorkGroupCode:WorkGroupCode,
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
	alert("�û�����װ�سɹ���");
}

