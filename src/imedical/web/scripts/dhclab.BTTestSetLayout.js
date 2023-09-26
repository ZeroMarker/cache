
//��ʾҽԺ
function ShowBTTestSetLayout() {
    $('#dgBTTestSetLayout').datagrid({	
    	url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCBTData",
			QueryName:"QryTestSetLayout",
			FunModul:"JSON"
		},		
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		pageList: [20, 50, 100, 200,500,1000,2000],
		sortName: 'Code',
		sortOrder: 'dasc',		
		striped:true,
		nowrap: false, 
		border: true,
		collapsible: true,
		singleSelect:true,
		selectOnCheck: false,
        checkOnSelect: false,
        remoteSort: false,
        onClickCell: onClickCell,
		fit:true, 
        columns: [[
          { field: 'RowID', title: 'RowID', width: 60, sortable: true, align: 'left',editor:'text' },
          { field: 'WorkGroupCode', title: '���������', width: 60, sortable: true, align: 'center' ,editor:'text'},
          { field: 'WorkGroupName', title: '����������', width: 120, sortable: true, align: 'left' ,editor:'text'},
          { field: 'TestSetCode', title: 'ҽ������', width: 60, sortable: true, align: 'center' ,editor:'text'},
          { field: 'TestSetName', title: 'ҽ������', width: 120, sortable: true, align: 'left' ,editor:'text'},
          { field: 'TestCode', title: '��Ŀ����', width: 60, sortable: true, align: 'center' ,editor:'text'},
          { field: 'TestName', title: '��Ŀ����', width: 120, sortable: true, align: 'left' ,editor:'text'},
          { field: 'WorkGroupMachineCode', title: '����С�����', width: 80, sortable: true, align: 'left' ,editor:'text'},
          { field: 'WorkGroupMachineName', title: '����С������', width: 120, sortable: true, align: 'left' ,editor:'text'},
          { field: 'HospCode', title: 'ҽԺ����', width: 120, sortable: true, align: 'center' ,editor:'text'},
          { field: 'HospName', title: 'ҽԺ����', width: 200, sortable: true, align: 'left' ,editor:'text'},
          { field: 'RetValue', title: '������Ϣ', width: 200, sortable: true, align: 'left' ,editor:'text'}
          
        ]]
    });
}; //ShowBTHospital 

//新增
function AddTestSetLayout() {
	$('#dgBTTestSetLayout').datagrid('appendRow',{
		RowID:'',
		Code: '',
		CName: '',
		Sequence: ''
	});
}

//����
function UpdTestSetLayout() {
    var RowID = "";
    var WorkGroupCode = "";
    var TestSetCode = "";
    var TestCode="";
    var HospCode="";
    var HospName="";   
    var WorkGroupMachineCode="";
    var rowsel = $('#dgBTTestSetLayout').datagrid("getSelected");
    var currow = $('#dgBTTestSetLayout').datagrid('getRowIndex', rowsel);
    
    t = $('#dgBTTestSetLayout');
	endEditing(t);

    if (rowsel) {
	    RowID=rowsel.RowID
	    WorkGroupCode=rowsel.WorkGroupCode
	    TestSetCode=rowsel.TestSetCode
	    TestCode=rowsel.TestCode
	    WorkGroupMachineCode=rowsel.WorkGroupMachineCode
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTTestSetLayout",RowID:RowID, WorkGroupCode:WorkGroupCode, TestSetCode:TestSetCode, TestCode:TestCode,WorkGroupMachineCode:WorkGroupMachineCode,HospCode:HospCode},
				function(rtn){
					if (rtn == 1) {
                        message="���³ɹ�"
					}else
					{
						message="����ʧ��" +rtn
					}
                   $('#dgBTTestSetLayout').datagrid('updateRow', {
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
function DelTestSetLayout() {
	var RowID = "";
	var CName = "";
	var rowsel = $('#dgBTTestSetLayout').datagrid("getSelected");
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"DelBTTestSetLayout",RowID:RowID},
				function(rtn){
					if (rtn == 1) {
                            $('#dgBTTestSetLayout').datagrid('reload');
                            $('#dgBTTestSetLayout').datagrid('clearSelections');
					}else
					{
						message="ɾ��ʧ��" +rtn
						$.messager.alert("��ʾ��Ϣ", message, "info");
					}
			});	
        }
    })
}
function ImportDataTestSetLayout() {
	var rows = $('#dgBTTestSetLayout').datagrid('getRows');
	var currow=0 //RowID, Code, CName, AbFlag, Sequence, TestCode
	for (var i = 0; i < rows.length; i++) {
		var RowID=rows[i].RowID
	    var WorkGroupCode=rows[i].WorkGroupCode
	    var TestSetCode=rows[i].TestSetCode
	    var TestCode=rows[i].TestCode
		var WorkGroupMachineCode=rows[i].WorkGroupMachineCode
		var HospCode=rows[i].HospCode
		
		$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTTestSetLayout",RowID:RowID, WorkGroupCode:WorkGroupCode, TestSetCode:TestSetCode, TestCode:TestCode,WorkGroupMachineCode:WorkGroupMachineCode,HospCode:HospCode},
		function(rtn){
			var message="";
			if (rtn == 1) {
				message="���³ɹ�"
			}else
			{
				message="����ʧ��" +rtn
			}
			currow++
			$('#dgBTTestSetLayout').datagrid('updateRow', {index: currow-1, row: {RetValue:message}});
		});	
	}
    //$('#dgBTTestSetLayout').datagrid('reload');
    //$('#dgBTTestSetLayout').datagrid('clearSelections');
	$.messager.alert("��ʾ��Ϣ", "���뱣�����,���鵼����Ϣ���!", "info");
}


function RefreshTestSetLayout(){
    $('#dgBTTestSetLayout').datagrid('reload');
    $('#dgBTTestSetLayout').datagrid('clearSelections');
}
//���뵼������
function ReadExcelTestSetLayout() {
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
	$('#dgBTTestSetLayout').datagrid("loadData",[]);
	
	xBooks.worksheets("����ҽ��").select(); 
	var xSheet = xBooks.ActiveSheet; 
	var rowcount=xSheet.UsedRange.Cells.Rows.Count ;  ///����  
	var colcount=xSheet.UsedRange.Cells.Columns.Count ;  ///����
	var sheetname=xSheet.name;  //��ȡsheet�ı����ĺ���
	var tTestSetCode="",tWorkGroupMachineCode=""
	for (var row=4;row<=rowcount;row++){
		var TestSetCode=xSheet.Cells(row,1).value;
		var TestSetName=xSheet.Cells(row,2).value;
		var WorkGroupMachineCode=xSheet.Cells(row,3).value;
		var WorkGroupMachineName=xSheet.Cells(row,4).value;
		var TestCode=xSheet.Cells(row,5).value;
		var TestName=xSheet.Cells(row,6).value;
		var HospCode=xSheet.Cells(row,12).value;
		var HospName=xSheet.Cells(row,13).value;
		if ((typeof(TestCode)=="undefined") && (typeof(WorkGroupMachineCode)=="undefined")){
			continue ;
		}
		
		var msginfo=""
		if (typeof(TestSetCode)=="undefined") TestSetCode=tTestSetCode
		tTestSetCode=TestSetCode
		if (typeof(WorkGroupMachineCode)=="undefined") WorkGroupMachineCode=tWorkGroupMachineCode
		tWorkGroupMachineCode=WorkGroupMachineCode
		
		$('#dgBTTestSetLayout').datagrid('appendRow',{
			RowID:'',
			TestSetCode:TestSetCode,
			TestSetName:TestSetName,
			TestCode:TestCode,
			TestName:TestName,
			WorkGroupMachineCode:WorkGroupMachineCode,
			WorkGroupMachineName:WorkGroupMachineName,
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
	alert("ҽ���ײ�������װ�سɹ���");
}

