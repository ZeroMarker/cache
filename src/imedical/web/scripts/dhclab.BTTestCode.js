
//��ʾҽԺ
function ShowBTTestCode() {
    $('#dgBTTestCode').datagrid({	
    	url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCBTData",
			QueryName:"QryTestCode",
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
          { field: 'RowID', title: 'RowID', width: 60, sortable: true, align: 'left',editor:'text' },
          { field: 'Code', title: '����', width: 100, sortable: true, align: 'center' ,editor:'text'},
          { field: 'CName', title: '����', width: 200, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Synonym', title: '��д', width: 100, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Units', title: '��λ', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Precision', title: '��ȷ��', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'ResultFormat', title: '���ݸ�ʽ', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'RefRanges', title: '������ʾ�ο���Χ', width: 100, sortable: true, align: 'left' ,editor:'text'},
          { field: 'SCode', title: '��׼��', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Sequence', title: '���', width: 60, sortable: true, align: 'left',editor:'text'},
          { field: 'HospCode', title: 'ҽԺ����', width: 100, sortable: true, align: 'center' ,editor:'text'},
          { field: 'HospName', title: 'ҽԺ����', width: 200, sortable: true, align: 'left' ,editor:'text'},
          { field: 'RetValue', title: '������Ϣ', width: 120, sortable: true, align: 'left' ,editor:'text'}
        ]]
    });
}; //ShowBTHospital

//新增
function AddTestCode() {
	$('#dgBTTestCode').datagrid('appendRow',{
		RowID:'',
		Code: '',
		CName: '',
		Sequence: '',
		HospCode: '',
		HospName: ''
	});
}

//����
function UpdTestCode() {
    var RowID = "";
    var CName = "";
    var Code = "";
    var Synonym="";
    var Units="";
    var Precision="";
    var ResultFormat="";
    var RefRanges="";
    var SCode="";
    var Sequence="";
    var HospCode="";
    var HospName="";    
       
    var rowsel = $('#dgBTTestCode').datagrid("getSelected");
    var currow = $('#dgBTTestCode').datagrid('getRowIndex', rowsel);
    
    t = $('#dgBTTestCode');
	endEditing(t);

    if (rowsel) {
	    RowID=rowsel.RowID
	    CName=rowsel.CName
	    Code=rowsel.Code
	    Synonym=rowsel.Synonym
	    Units=rowsel.Units
	    Precision=rowsel.Precision
	    ResultFormat=rowsel.ResultFormat
	    RefRanges=rowsel.RefRanges
	    SCode=rowsel.SCode
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTTestCode",RowID:RowID,Code:Code,CName:CName,Synonym:Synonym,Units:Units,Precision:Precision,ResultFormat:ResultFormat,RefRanges:RefRanges,SCode:SCode,Sequence:Sequence,HospCode:HospCode},
				function(rtn){
					if (rtn == 1) {
                        message="���³ɹ�"
					}else
					{
						message="����ʧ��" +rtn
					}
                   $('#dgBTTestCode').datagrid('updateRow', {
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
function DelTestCode() {
	var RowID = "";
	var CName = "";
	var rowsel = $('#dgBTTestCode').datagrid("getSelected");
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"DelBTTestCode",RowID:RowID},
				function(rtn){
					if (rtn == 1) {
                            $('#dgBTTestCode').datagrid('reload');
                            $('#dgBTTestCode').datagrid('clearSelections');
					}else
					{
						message="ɾ��ʧ��" +rtn
						$.messager.alert("��ʾ��Ϣ", message, "info");
					}
			});	
        }
    })
}
function ImportDataTestCode() {
	var rows = $('#dgBTTestCode').datagrid('getRows');
	var currow=0
	for (var i = 0; i < rows.length; i++) {
		var RowID=rows[i].RowID
	    var CName=rows[i].CName
	    var Code=rows[i].Code
	    var Synonym=rows[i].Synonym
	    var Units=rows[i].Units
	    var Precision=rows[i].Precision
	    var ResultFormat=rows[i].ResultFormat
	    var RefRanges=rows[i].RefRanges
	    var SCode=rows[i].SCode
	    var Sequence=rows[i].Sequence
		var HospCode=rows[i].HospCode
			    
		$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTTestCode",RowID:RowID,Code:Code,CName:CName,Synonym:Synonym,Units:Units,Precision:Precision,ResultFormat:ResultFormat,RefRanges:RefRanges,SCode:SCode,Sequence:Sequence,HospCode:HospCode},
		function(rtn){
			var message="";
			if (rtn == 1) {
				message="���³ɹ�"
			}else
			{
				message="����ʧ��" +rtn
			}
			currow++
			$('#dgBTTestCode').datagrid('updateRow', {index: currow-1, row: {RetValue:message}});
		});	
	}
    //$('#dgBTTestCode').datagrid('reload');
    //$('#dgBTTestCode').datagrid('clearSelections');
	$.messager.alert("��ʾ��Ϣ", "���뱣�����,���鵼����Ϣ���!", "info");
}


function RefreshTestCode(){
    $('#dgBTTestCode').datagrid('reload');
    $('#dgBTTestCode').datagrid('clearSelections');
}
//���뵼������
function ReadExcelTestCode() {
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
	$('#dgBTTestCode').datagrid("loadData",[]);
	
	xBooks.worksheets("������Ŀ").select(); 
	var xSheet = xBooks.ActiveSheet; 
	var rowcount=xSheet.UsedRange.Cells.Rows.Count ;  ///����  
	var colcount=xSheet.UsedRange.Cells.Columns.Count ;  ///����
	var sheetname=xSheet.name;  //��ȡsheet�ı����ĺ���
	
	for (var row=4;row<=rowcount;row++){
		var Code=xSheet.Cells(row,1).value;
		var CName=xSheet.Cells(row,2).value;
		var Synonym=xSheet.Cells(row,3).value;
		var Units=xSheet.Cells(row,4).value;
		var Precision=xSheet.Cells(row,5).value;
		var ResultFormat=xSheet.Cells(row,6).value;
		var RefRanges=xSheet.Cells(row,12).value;
		var SCode=xSheet.Cells(row,18).value;
		var HospCode=xSheet.Cells(row,19).value;
		var HospName=xSheet.Cells(row,20).value;
				
		var msginfo=""
		if (typeof(Code)=="undefined") msginfo="���벻��Ϊ�գ�"
		if (typeof(CName)=="undefined") msginfo="���Ʋ���Ϊ�գ�"
		if (msginfo==""){
			$('#dgBTTestCode').datagrid('appendRow',{
				RowID:'',
				Code: Code,
				CName: CName,
				Synonym:Synonym,
				Units:Units,
				Precision:Precision,
				ResultFormat:ResultFormat,
				RefRanges:RefRanges,
				SCode:SCode,
				Sequence: row-3,
				HospCode:HospCode,
				HospName:HospName,					
				RetValue:msginfo
			});		
		};
	}
	xBooks.Close (savechanges=false);
	xApp.Quit(); 
	xApp=null;
	xSheet=null;
	xBooks=null;
	alert("������Ŀ����װ�سɹ���");
}

