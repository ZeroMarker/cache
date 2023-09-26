
//��ʾҽԺ
function ShowBTTestSetSpecimen() {
    $('#dgBTTestSetSpecimen').datagrid({	
    	url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCBTData",
			QueryName:"QryTestSetSpecimen",
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
          { field: 'SpecimenCode', title: '�걾����', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'SpecimenName', title: '�걾����', width: 100, sortable: true, align: 'left' ,editor:'text'},
          { field: 'ContainerCode', title: '��������', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'ContainerName', title: '��������', width: 100, sortable: true, align: 'left' ,editor:'text'},
          { field: 'MergeType', title: '��������', width: 80, sortable: true, align: 'left' ,editor:'text'},
          { field: 'IsDefault', title: 'Ĭ��', width: 50, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Sequence', title: '���', width: 50	, sortable: true, align: 'left',editor:'text'},
          { field: 'HospCode', title: 'ҽԺ����', width: 100, sortable: true, align: 'center' ,editor:'text'},
          { field: 'HospName', title: 'ҽԺ����', width: 200, sortable: true, align: 'left' ,editor:'text'},
          { field: 'RetValue', title: '������Ϣ', width: 120, sortable: true, align: 'left' ,editor:'text'}
        ]]
    });
}; //ShowBTHospital

//新增
function AddTestSetSpecimen() {
	$('#dgBTTestSetSpecimen').datagrid('appendRow',{
		RowID:'',
		Code: '',
		CName: '',
		Sequence: ''
	});
}

//����
function UpdTestSetSpecimen() {
    var RowID = "";
    var CName = "";
    var Code = "";
    var MergeType="";
    var SpecimenCode="";
    var ContainerCode="";
    var IsDefault="";
    var Sequence="";
    var HospCode="";
    var HospName="";  

    var rowsel = $('#dgBTTestSetSpecimen').datagrid("getSelected");
    var currow = $('#dgBTTestSetSpecimen').datagrid('getRowIndex', rowsel);
    
    t = $('#dgBTTestSetSpecimen');
	endEditing(t);

    if (rowsel) {
	    CName=rowsel.CName;
	    Code=rowsel.Code;
	    SpecimenCode=rowsel.SpecimenCode;
	    ContainerCode=rowsel.ContainerCode;
	    MergeType=rowsel.MergeType;
	    IsDefault=rowsel.IsDefault;
	    Sequence=rowsel.Sequence;
	    RowID=rowsel.RowID;
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTTestSetSpecimen",Code:Code,SpecimenCode:SpecimenCode,ContainerCode:ContainerCode,MergeType:MergeType,IsDefault:IsDefault,Sequence:Sequence,RowID:RowID,HospCode:HospCode},
				function(rtn){
					if (rtn == 1) {
                        message="���³ɹ�"
					}else
					{
						message="����ʧ��" +rtn
					}
                   $('#dgBTTestSetSpecimen').datagrid('updateRow', {
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
function DelTestSetSpecimen() {
	var RowID = "";
	var CName = "";
	var SpecimenName="";
	var rowsel = $('#dgBTTestSetSpecimen').datagrid("getSelected");
	if (rowsel) {
	    RowID=rowsel.RowID
	    CName=rowsel.CName
	    SpecimenName=rowsel.SpecimenName
	}
	if (RowID == "") { 
	    $.messager.alert("��ʾ��Ϣ", '��ѡ���¼���в���!', "info");
	    return;
	} 
    $.messager.confirm('��ʾ��Ϣ', 'ȷ��Ҫɾ��ѡ���RowID��'+RowID +":"+ CName + ":" +SpecimenName + '��', function (isClickedOk) {
        if (isClickedOk) {
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"DelBTTestSetSpecimen",RowID:RowID},
				function(rtn){
					if (rtn == 1) {
                            $('#dgBTTestSetSpecimen').datagrid('reload');
                            $('#dgBTTestSetSpecimen').datagrid('clearSelections');
					}else
					{
						message="ɾ��ʧ��" +rtn
						$.messager.alert("��ʾ��Ϣ", message, "info");
					}
			});	
        }
    })
}
function ImportDataTestSetSpecimen() {
	var rows = $('#dgBTTestSetSpecimen').datagrid('getRows');
	var currow=0
	for (var i = 0; i < rows.length; i++) {
	    var Code=rows[i].Code;
	    var SpecimenCode=rows[i].SpecimenCode;
	    var ContainerCode=rows[i].ContainerCode;
	    var MergeType=rows[i].MergeType;
	    var IsDefault=rows[i].IsDefault;
	    var Sequence=rows[i].Sequence;
	    var RowID="";
		var HospCode=rows[i].HospCode
    
		$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTTestSetSpecimen",Code:Code,SpecimenCode:SpecimenCode,ContainerCode:ContainerCode,MergeType:MergeType,IsDefault:IsDefault,Sequence:Sequence,RowID:RowID,HospCode:HospCode},
		function(rtn){
			var message="";
			if (rtn == 1) {
				message="���³ɹ�"
			}else
			{
				message="����ʧ��" +rtn
			}
			currow++
			$('#dgBTTestSetSpecimen').datagrid('updateRow', {index: currow-1, row: {RetValue:message}});
		});	
	}
    //$('#dgBTTestSetSpecimen').datagrid('reload');
    //$('#dgBTTestSetSpecimen').datagrid('clearSelections');
	$.messager.alert("��ʾ��Ϣ", "���뱣�����,���鵼����Ϣ���!", "info");
}


function RefreshTestSetSpecimen(){
    $('#dgBTTestSetSpecimen').datagrid('reload');
    $('#dgBTTestSetSpecimen').datagrid('clearSelections');
}
//���뵼������
function ReadExcelTestSetSpecimen() {
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
	$('#dgBTTestSetSpecimen').datagrid("loadData",[]);
	
	xBooks.worksheets("ҽ����걾").select(); 
	var xSheet = xBooks.ActiveSheet; 
	var rowcount=xSheet.UsedRange.Cells.Rows.Count ;  ///����  
	var colcount=xSheet.UsedRange.Cells.Columns.Count ;  ///����
	var sheetname=xSheet.name;  //��ȡsheet�ı����ĺ���
	var currow=0;
	for (var row=4;row<=rowcount;row++){
		var Code=xSheet.Cells(row,1).value;
		var CName=xSheet.Cells(row,2).value;
		var SpecimenCode=xSheet.Cells(row,3).value;
		var SpecimenName=xSheet.Cells(row,4).value;
		var ContainerCode=xSheet.Cells(row,5).value;
		var ContainerName=xSheet.Cells(row,6).value;
		var MergeType=xSheet.Cells(row,7).value;
		var IsDefault=xSheet.Cells(row,8).value;
		var Sequence=xSheet.Cells(row,9).value;
		var HospCode=xSheet.Cells(row,10).value;
		var HospName=xSheet.Cells(row,11).value;
		
		var msginfo=""
		
		if (typeof(Code)=="undefined") continue 
		if (typeof(SpecimenCode)=="undefined") msginfo="�걾���벻��Ϊ�գ�"
		if (typeof(Sequence)=="undefined") Sequence=1 

		currow++
		$('#dgBTTestSetSpecimen').datagrid('appendRow',{
			RowID:'',
			Code: Code,
			CName: CName,
			SpecimenCode:SpecimenCode,
			SpecimenName:SpecimenName,
			ContainerCode:ContainerCode,
			ContainerName:ContainerName,
			MergeType:MergeType,
			IsDefault:IsDefault,
			Sequence: Sequence,
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
	alert("����ҽ������װ�سɹ���");
}

