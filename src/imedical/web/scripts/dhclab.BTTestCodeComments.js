
//��ʾҽԺ
function ShowBTTestCodeComments() {
    $('#dgBTTestCodeComments').datagrid({	
    	url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCBTData",
			QueryName:"QryTestCodeComments",
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
          { field: 'TestCode', title: '��Ŀ����', width: 60, sortable: true, align: 'center' ,editor:'text'},
          { field: 'TestName', title: '��Ŀ����', width: 160, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Code', title: '��ע����', width: 60, sortable: true, align: 'center' ,editor:'text'},
          { field: 'CName', title: '��ע����', width: 160, sortable: true, align: 'left' ,editor:'text'},
          { field: 'AbFlag', title: '�쳣���', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Sequence', title: '���', width: 60, sortable: true, align: 'left',editor:'text'},
          { field: 'HospCode', title: 'ҽԺ����', width: 100, sortable: true, align: 'center' ,editor:'text'},
          { field: 'HospName', title: 'ҽԺ����', width: 200, sortable: true, align: 'left' ,editor:'text'},
          { field: 'RetValue', title: '������Ϣ', width: 200, sortable: true, align: 'left' ,editor:'text'}
          
        ]]
    });
}; //ShowBTHospital 

//新增
function AddTestCodeComments() {
	$('#dgBTTestCodeComments').datagrid('appendRow',{
		RowID:'',
		Code: '',
		CName: '',
		Sequence: '',
		HospCode: '',
		HospName: ''	
	});
}

//����
function UpdTestCodeComments() {
    var RowID = "";
    var CName = "";
    var Code = "";
    var TestCode="";
    var AbFlag="";
    var Sequence="";
    var HospCode="";
    var HospName="";    
        
    var rowsel = $('#dgBTTestCodeComments').datagrid("getSelected");
    var currow = $('#dgBTTestCodeComments').datagrid('getRowIndex', rowsel);
    
    t = $('#dgBTTestCodeComments');
	endEditing(t);

    if (rowsel) {
	    RowID=rowsel.RowID
	    Code=rowsel.Code
	    CName=rowsel.CName
	    AbFlag=rowsel.AbFlag
	    Sequence=rowsel.Sequence
	    TestCode=rowsel.TestCode
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTTestCodeComments",RowID:RowID, Code:Code, CName:CName, AbFlag:AbFlag, Sequence:Sequence, TestCode:TestCode,HospCode:HospCode},
				function(rtn){
					if (rtn == 1) {
                        message="���³ɹ�"
					}else
					{
						message="����ʧ��" +rtn
					}
                   $('#dgBTTestCodeComments').datagrid('updateRow', {
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
function DelTestCodeComments() {
	var RowID = "";
	var CName = "";
	var rowsel = $('#dgBTTestCodeComments').datagrid("getSelected");
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"DelBTTestCodeComments",RowID:RowID},
				function(rtn){
					if (rtn == 1) {
                            $('#dgBTTestCodeComments').datagrid('reload');
                            $('#dgBTTestCodeComments').datagrid('clearSelections');
					}else
					{
						message="ɾ��ʧ��" +rtn
						$.messager.alert("��ʾ��Ϣ", message, "info");
					}
			});	
        }
    })
}
function ImportDataTestCodeComments() {
	var rows = $('#dgBTTestCodeComments').datagrid('getRows');
	var currow=0 //RowID, Code, CName, AbFlag, Sequence, TestCode
	for (var i = 0; i < rows.length; i++) {
		var RowID=rows[i].RowID
	    var Code=rows[i].Code
	    var CName=rows[i].CName
	    var AbFlag=rows[i].AbFlag
	    var Sequence=rows[i].Sequence
	    var TestCode=rows[i].TestCode
		var HospCode=rows[i].HospCode
	    
		$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTTestCodeComments",RowID:RowID, Code:Code, CName:CName, AbFlag:AbFlag, Sequence:Sequence, TestCode:TestCode,HospCode:HospCode},
		function(rtn){
			var message="";
			if (rtn == 1) {
				message="���³ɹ�"
			}else
			{
				message="����ʧ��" +rtn
			}
			currow++
			$('#dgBTTestCodeComments').datagrid('updateRow', {index: currow-1, row: {RetValue:message}});
		});	
	}
    //$('#dgBTTestCodeComments').datagrid('reload');
    //$('#dgBTTestCodeComments').datagrid('clearSelections');
	$.messager.alert("��ʾ��Ϣ", "���뱣�����,���鵼����Ϣ���!", "info");
}


function RefreshTestCodeComments(){
    $('#dgBTTestCodeComments').datagrid('reload');
    $('#dgBTTestCodeComments').datagrid('clearSelections');
}
//���뵼������
function ReadExcelTestCodeComments() {
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
	$('#dgBTTestCodeComments').datagrid("loadData",[]);
	
	xBooks.worksheets("������Ŀ").select(); 
	var xSheet = xBooks.ActiveSheet; 
	var rowcount=xSheet.UsedRange.Cells.Rows.Count ;  ///����  
	var colcount=xSheet.UsedRange.Cells.Columns.Count ;  ///����
	var sheetname=xSheet.name;  //��ȡsheet�ı����ĺ���
	
	var Sequence=0,tTestCode=""
	for (var row=4;row<=rowcount;row++){
		var TestCode=xSheet.Cells(row,1).value;
		var TestName=xSheet.Cells(row,2).value;
		var Code=xSheet.Cells(row,15).value;
		var CName=xSheet.Cells(row,16).value;
		var AbFlag=xSheet.Cells(row,17).value;
		var HospCode=xSheet.Cells(row,19).value;
		var HospName=xSheet.Cells(row,20).value;
		
		if ((typeof(Code)=="undefined") && (typeof(CName)=="undefined")){
			continue ;
		}
		
		var msginfo=""
		if (typeof(TestCode)=="undefined")
		{
			TestCode=tTestCode
			Sequence=Sequence+1
		}else
		{
			Sequence=1
		}
		tTestCode=TestCode
		$('#dgBTTestCodeComments').datagrid('appendRow',{
			RowID:'',
			TestCode:TestCode,
			TestName:TestName,
			Code: Code,
			CName: CName,
			AbFlag:AbFlag,
			Sequence:Sequence,
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
	alert("������Ŀ��׼����װ�سɹ���");
}

