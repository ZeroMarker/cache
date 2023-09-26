
//��ʾҽԺ
function ShowBTTestSet() {
    $('#dgBTTestSet').datagrid({	
    	url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCBTData",
			QueryName:"QryTestSet",
			FunModul:"JSON"
		},		
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		pageList: [20, 50, 100, 200,500,1000,2000],
		sortName: 'Sequence',
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
          { field: 'RowID', title: 'RowID', width: 50, sortable: true, align: 'left',editor:'text' },
          { field: 'Code', title: '����', width: 60, sortable: true, align: 'center' ,editor:'text'},
          { field: 'CName', title: '����', width: 200, sortable: true, align: 'left' ,editor:'text'},
          { field: 'WorkGroupMachineCode', title: '����С�����', width: 80, sortable: true, align: 'left' ,editor:'text'},
          { field: 'WorkGroupMachineName', title: '����С������', width: 120, sortable: true, align: 'left' ,editor:'text'},
          { field: 'SpecimenCode', title: '�걾����', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'SpecimenName', title: '�걾����', width: 100, sortable: true, align: 'left' ,editor:'text'},
          { field: 'ContainerCode', title: '��������', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'ContainerName', title: '��������', width: 100, sortable: true, align: 'left' ,editor:'text'},
          { field: 'HISCode', title: '�ⲿHIS����', width: 80, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Sequence', title: '���', width: 50	, sortable: true, align: 'left',editor:'text'},
          { field: 'HospCode', title: 'ҽԺ����', width: 100, sortable: true, align: 'center' ,editor:'text'},
          { field: 'HospName', title: 'ҽԺ����', width: 200, sortable: true, align: 'left' ,editor:'text'},
          { field: 'RetValue', title: '������Ϣ', width: 120, sortable: true, align: 'left' ,editor:'text'}
        ]]
    });
}; //ShowBTHospital

//新增
function AddTestSet() {
	$('#dgBTTestSet').datagrid('appendRow',{
		RowID:'',
		Code: '',
		CName: '',
		Sequence: '',
		HospCode: '',
		HospName: ''
	});
}

//����
function UpdTestSet() {
    var RowID = "";
    var CName = "";
    var Code = "";
    var WorkGroupMachineCode="";
    var SpecimenCode="";
    var ContainerCode="";
    var HISCode="";
    var Sequence="";
    var HospCode="";
    var HospName="";  
    
    var rowsel = $('#dgBTTestSet').datagrid("getSelected");
    var currow = $('#dgBTTestSet').datagrid('getRowIndex', rowsel);
    
    t = $('#dgBTTestSet');
	endEditing(t);

    if (rowsel) {
	    RowID=rowsel.RowID
	    CName=rowsel.CName
	    Code=rowsel.Code
	    WorkGroupMachineCode=rowsel.WorkGroupMachineCode
	    SpecimenCode=rowsel.SpecimenCode
	    ContainerCode=rowsel.ContainerCode
	    HISCode=rowsel.HISCode
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTTestSet",RowID:RowID,Code:Code,CName:CName,WorkGroupMachineCode:WorkGroupMachineCode,SpecimenCode:SpecimenCode,ContainerCode:ContainerCode,HISCode:HISCode,Sequence:Sequence,HospCode:HospCode},
				function(rtn){
					if (rtn == 1) {
                        message="���³ɹ�"
					}else
					{
						message="����ʧ��" +rtn
					}
                   $('#dgBTTestSet').datagrid('updateRow', {
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
function DelTestSet() {
	var RowID = "";
	var CName = "";
	var rowsel = $('#dgBTTestSet').datagrid("getSelected");
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"DelBTTestSet",RowID:RowID},
				function(rtn){
					if (rtn == 1) {
                            $('#dgBTTestSet').datagrid('reload');
                            $('#dgBTTestSet').datagrid('clearSelections');
					}else
					{
						message="ɾ��ʧ��" +rtn
						$.messager.alert("��ʾ��Ϣ", message, "info");
					}
			});	
        }
    })
}
function ImportDataTestSet() {
	var rows = $('#dgBTTestSet').datagrid('getRows');
	var currow=0
	for (var i = 0; i < rows.length; i++) {
		var RowID=rows[i].RowID
	    var CName=rows[i].CName
	    var Code=rows[i].Code
	    var WorkGroupMachineCode=rows[i].WorkGroupMachineCode
	    var SpecimenCode=rows[i].SpecimenCode
	    var ContainerCode=rows[i].ContainerCode
	    var HISCode=rows[i].HISCode
	    var Sequence=rows[i].Sequence
		var HospCode=rows[i].HospCode
			    
		$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTTestSet",RowID:RowID,Code:Code,CName:CName,WorkGroupMachineCode:WorkGroupMachineCode,SpecimenCode:SpecimenCode,ContainerCode:ContainerCode,HISCode:HISCode,Sequence:Sequence,HospCode:HospCode},
		function(rtn){
			var message="";
			if (rtn == 1) {
				message="���³ɹ�"
			}else
			{
				message="����ʧ��" +rtn
			}
			currow++
			$('#dgBTTestSet').datagrid('updateRow', {index: currow-1, row: {RetValue:message}});
		});	
	}
    //$('#dgBTTestSet').datagrid('reload');
    //$('#dgBTTestSet').datagrid('clearSelections');
	$.messager.alert("��ʾ��Ϣ", "���뱣�����,���鵼����Ϣ���!", "info");
}


function RefreshTestSet(){
    $('#dgBTTestSet').datagrid('reload');
    $('#dgBTTestSet').datagrid('clearSelections');
}
//���뵼������
function ReadExcelTestSet() {
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
	$('#dgBTTestSet').datagrid("loadData",[]);
	
	xBooks.worksheets("����ҽ��").select(); 
	var xSheet = xBooks.ActiveSheet; 
	var rowcount=xSheet.UsedRange.Cells.Rows.Count ;  ///����  
	var colcount=xSheet.UsedRange.Cells.Columns.Count ;  ///����
	var sheetname=xSheet.name;  //��ȡsheet�ı����ĺ���
	var currow=0;
	for (var row=4;row<=rowcount;row++){
		var Code=xSheet.Cells(row,1).value;
		var CName=xSheet.Cells(row,2).value;
		var WorkGroupMachineCode=xSheet.Cells(row,3).value;
		var WorkGroupMachineName=xSheet.Cells(row,4).value;
		var SpecimenCode=xSheet.Cells(row,7).value;
		var SpecimenName=xSheet.Cells(row,8).value;
		var ContainerCode=xSheet.Cells(row,9).value;
		var ContainerName=xSheet.Cells(row,10).value;
		var HISCode=xSheet.Cells(row,11).value;
		var HospCode=xSheet.Cells(row,12).value;
		var HospName=xSheet.Cells(row,13).value;
	
		if (typeof(Code)=="undefined") continue 
		if (typeof(CName)=="undefined") continue 
		currow++
		$('#dgBTTestSet').datagrid('appendRow',{
			RowID:'',
			Code: Code,
			CName: CName,
			WorkGroupMachineCode:WorkGroupMachineCode,
			WorkGroupMachineName:WorkGroupMachineName,
			SpecimenCode:SpecimenCode,
			SpecimenName:SpecimenName,
			ContainerCode:ContainerCode,
			ContainerName:ContainerName,
			HospCode:HospCode,
			HospName:HospName,
			Sequence: currow,
			RetValue:""
		});		
	}
	xBooks.Close (savechanges=false);
	xApp.Quit(); 
	xApp=null;
	xSheet=null;
	xBooks=null;
	alert("����ҽ������װ�سɹ���");
}

