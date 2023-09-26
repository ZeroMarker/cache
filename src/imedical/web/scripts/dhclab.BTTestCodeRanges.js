
//��ʾҽԺ
function ShowBTTestCodeRanges() {
    $('#dgBTTestCodeRanges').datagrid({	
    	url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCBTData",
			QueryName:"QryTestCodeRanges",
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
          { field: 'Code', title: '����', width: 60, sortable: true, align: 'center' ,editor:'text'},
          { field: 'CName', title: '����', width: 160, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Species', title: '�Ա�', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'AgeLow', title: '�����', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'AgeHigh', title: '�����', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'ValueLow', title: '��ֵ', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'ValueHigh', title: '��ֵ', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'PanicLow', title: 'Σ����ֵ', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'PanicHigh', title: 'Σ���{ֵ', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'OrderNo', title: '���', width: 60, sortable: true, align: 'left',editor:'text'},
          { field: 'HospCode', title: 'ҽԺ����', width: 100, sortable: true, align: 'center' ,editor:'text'},
          { field: 'HospName', title: 'ҽԺ����', width: 200, sortable: true, align: 'left' ,editor:'text'},
          { field: 'RetValue', title: '������Ϣ', width: 200, sortable: true, align: 'left' ,editor:'text'}
        ]]
    });
}; //ShowBTHospital 

//新增
function AddTestCodeRanges() {
	$('#dgBTTestCodeRanges').datagrid('appendRow',{
		RowID:'',
		Code: '',
		CName: '',
		Sequence: '',
		HospCode: '',
		HospName: ''	
	});
}

//����
function UpdTestCodeRanges() {
    var RowID = "";
    var CName = "";
    var Code = "";
    var Species="";
    var AgeLow="";
    var AgeHigh="";
    var ValueLow="";
    var ValueHigh="";
    var PanicLow="";
    var PanicHigh="";
    var OrderNo="";
    var HospCode="";
    var HospName="";    
        
    var rowsel = $('#dgBTTestCodeRanges').datagrid("getSelected");
    var currow = $('#dgBTTestCodeRanges').datagrid('getRowIndex', rowsel);
    
    t = $('#dgBTTestCodeRanges');
	endEditing(t);

    if (rowsel) {
	    RowID=rowsel.RowID
	    Code=rowsel.Code
	    CName=rowsel.CName
	    Species=rowsel.Species
	    AgeLow=rowsel.AgeLow
	    AgeHigh=rowsel.AgeHigh
	    ValueLow=rowsel.ValueLow
	    ValueHigh=rowsel.ValueHigh
	    PanicLow=rowsel.PanicLow
	    PanicHigh=rowsel.PanicHigh
	    OrderNo=rowsel.OrderNo
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTTestCodeRanges",RowID:RowID,Code:Code,Species:Species,AgeLow:AgeLow,AgeHigh:AgeHigh,ValueLow:ValueLow,ValueHigh:ValueHigh,PanicLow:PanicLow,PanicHigh:PanicHigh,OrderNo:OrderNo,HospCode:HospCode},
				function(rtn){
					if (rtn == 1) {
                        message="���³ɹ�"
					}else
					{
						message="����ʧ��" +rtn
					}
                   $('#dgBTTestCodeRanges').datagrid('updateRow', {
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
function DelTestCodeRanges() {
	var RowID = "";
	var CName = "";
	var rowsel = $('#dgBTTestCodeRanges').datagrid("getSelected");
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"DelBTTestCodeRanges",RowID:RowID},
				function(rtn){
					if (rtn == 1) {
                            $('#dgBTTestCodeRanges').datagrid('reload');
                            $('#dgBTTestCodeRanges').datagrid('clearSelections');
					}else
					{
						message="ɾ��ʧ��" +rtn
						$.messager.alert("��ʾ��Ϣ", message, "info");
					}
			});	
        }
    })
}
function ImportDataTestCodeRanges() {
	var rows = $('#dgBTTestCodeRanges').datagrid('getRows');
	var currow=0
	for (var i = 0; i < rows.length; i++) {
		var RowID=rows[i].RowID
	    var Code=rows[i].Code
	    var Species=rows[i].Species
	    var AgeLow=rows[i].AgeLow
	    var AgeHigh=rows[i].AgeHigh
	    var ValueLow=rows[i].ValueLow
	    var ValueHigh=rows[i].ValueHigh
	    var PanicLow=rows[i].PanicLow
	    var PanicHigh=rows[i].PanicHigh
	    var OrderNo=rows[i].OrderNo
		var HospCode=rows[i].HospCode
	    
		$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTTestCodeRanges",RowID:RowID,Code:Code,Species:Species,AgeLow:AgeLow,AgeHigh:AgeHigh,ValueLow:ValueLow,ValueHigh:ValueHigh,PanicLow:PanicLow,PanicHigh:PanicHigh,OrderNo:OrderNo,HospCode:HospCode},
		function(rtn){
			var message="";
			if (rtn == 1) {
				message="���³ɹ�"
			}else
			{
				message="����ʧ��" +rtn
			}
			currow++
			$('#dgBTTestCodeRanges').datagrid('updateRow', {index: currow-1, row: {RetValue:message}});
		});	
	}
    //$('#dgBTTestCodeRanges').datagrid('reload');
    //$('#dgBTTestCodeRanges').datagrid('clearSelections');
	$.messager.alert("��ʾ��Ϣ", "���뱣�����,���鵼����Ϣ���!", "info");
}


function RefreshTestCodeRanges(){
    $('#dgBTTestCodeRanges').datagrid('reload');
    $('#dgBTTestCodeRanges').datagrid('clearSelections');
}
//���뵼������
function ReadExcelTestCodeRanges() {
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
	$('#dgBTTestCodeRanges').datagrid("loadData",[]);
	
	xBooks.worksheets("������Ŀ").select(); 
	var xSheet = xBooks.ActiveSheet; 
	var rowcount=xSheet.UsedRange.Cells.Rows.Count ;  ///����  
	var colcount=xSheet.UsedRange.Cells.Columns.Count ;  ///����
	var sheetname=xSheet.name;  //��ȡsheet�ı����ĺ���
	
	var OrderNo=0,tCode=""
	for (var row=4;row<=rowcount;row++){
		var Code=xSheet.Cells(row,1).value;
		var CName=xSheet.Cells(row,2).value;
		
		var Species=xSheet.Cells(row,7).value;
		var AgeLow=xSheet.Cells(row,8).value;
		var AgeHigh=xSheet.Cells(row,9).value;
		
		var ValueLow=xSheet.Cells(row,10).value;
		var ValueHigh=xSheet.Cells(row,11).value;
		var PanicLow=xSheet.Cells(row,13).value;
		var PanicHigh=xSheet.Cells(row,14).value;
		var HospCode=xSheet.Cells(row,19).value;
		var HospName=xSheet.Cells(row,20).value;
		
		if ((typeof(ValueLow)=="undefined") && (typeof(ValueHigh)=="undefined")){
			continue ;
		}
		if (typeof(Code)=="undefined") {
			continue ;
		}
		
		var msginfo=""
		if (Code==tCode)
		{
			OrderNo=OrderNo+1
		}else
		{
			tCode=Code
			OrderNo=1
		}
		$('#dgBTTestCodeRanges').datagrid('appendRow',{
			RowID:'',
			Code: Code,
			CName: CName,
			Species:Species,
			AgeLow:AgeLow,
			AgeHigh:AgeHigh,
			ValueLow:ValueLow,
			ValueHigh:ValueHigh,
			PanicLow:PanicLow,
			PanicHigh:PanicHigh,
			OrderNo:OrderNo,
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
	alert("������Ŀ�ο���Χ����װ�سɹ���");
}

