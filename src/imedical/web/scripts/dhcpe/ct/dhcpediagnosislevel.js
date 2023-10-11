/*
 * FileName: dhcpediagnosislevel.js
 * Author: xy
 * Date: 2021-08-04
 * Description: ���鼶��ά��
 */
var lastIndex = "";
var EditIndex = -1;

var tableName = "DHC_PE_EDClass";

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
	
	
	//��ȡ���������б�
	GetLocComp(SessionStr);
	  
	//��ʼ��  ���鼶��Grid    
    InitDiagnosisLevelDataGrid();
    
    //���������б�change
	$("#LocList").combobox({
       onSelect:function(){
		InitDiagnosisLevelDataGrid();
		}
	});
	
	//��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
     });
        
     //����
	$("#BAdd").click(function() {	
		BAdd_click();		
        });
        
    //�޸�
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
     
     //ɾ��
	$("#BDelete").click(function() {	
		BDelete_click();		
        });
        
    //����
	$("#BClear").click(function() {	
		BClear_click();		
        });
        
      //����
     $('#BSave').click(function(){
    	BSave_click();
    });
	   
    //���ݹ�������
	$("#BRelateLoc").click(function() {	
		BRelateLoc_click();		
        });
        
     $('#NoActive').checkbox({
		onCheckChange:function(e,vaule){
			BFind_click();		
	    }			
    });   
        
 
})


//���ݹ�������
function BRelateLoc_click()
{
	var DateID=$("#ID").val()
	if (DateID==""){
		$.messager.alert("��ʾ","��ѡ����Ҫ��Ȩ�ļ�¼","info"); 
		return false;
	}
  
   var LocID=$("#LocList").combobox('getValue')
   //alert("LocID:"+LocID)
   OpenLocWin(tableName,DateID,SessionStr,LocID,InitDiagnosisLevelDataGrid)
   
}

//����
function BClear_click()
{	
	$("#Level,#Desc,#ID").val("");
	$("#NoActive").checkbox('setValue',true);
	LoadDiagnosisLevel();
}

//��ѯ
function BFind_click(){
	
	$("#DiagnosisLevelQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.CT.DiagnosisLevel",
			QueryName:"LevelAll",
			Code:$("#Level").val(),
			Desc:$("#Desc").val(),
			NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
			tableName:tableName, 
			LocID:$("#LocList").combobox('getValue')
			
		});	
}
//����
function BAdd_click()
 {
	lastIndex = $('#DiagnosisLevelQueryTab').datagrid('getRows').length - 1;
	$('#DiagnosisLevelQueryTab').datagrid('selectRow', lastIndex);
	var selected = $('#DiagnosisLevelQueryTab').datagrid('getSelected');
	if (selected) {
		if (selected.TRowID == "") {
			$.messager.alert('��ʾ', "����ͬʱ��Ӷ���!", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
		return;
	}
	$('#DiagnosisLevelQueryTab').datagrid('appendRow', {
		TRowID: '',
		TLevel: '',
		TDesc: '',
		TNoActive:'',
		TUpdateDate:'',
		TUpdateTime:'',
		TUserName:'',
		TEmpower:'',
		TEffPowerFlag:''
	});
	lastIndex = $('#DiagnosisLevelQueryTab').datagrid('getRows').length - 1;
	$('#DiagnosisLevelQueryTab').datagrid('selectRow', lastIndex);
	$('#DiagnosisLevelQueryTab').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
 }
 
 //�޸�
 function BUpdate_click()
 {
	var selected = $('#DiagnosisLevelQueryTab').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('��ʾ', "��ѡ����޸ĵļ�¼", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#DiagnosisLevelQueryTab').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
			return;
		}
		$('#DiagnosisLevelQueryTab').datagrid('beginEdit', thisIndex);
		$('#DiagnosisLevelQueryTab').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
	
		var selected = $('#DiagnosisLevelQueryTab').datagrid('getSelected');
		
		var thisEd = $('#DiagnosisLevelQueryTab').datagrid('getEditor', {
				index: EditIndex,
				field: 'TLevel'  
		});
			
		var thisEd = $('#DiagnosisLevelQueryTab').datagrid('getEditor', {
				index: EditIndex,
				field: 'TDesc'  
		});
		
		//if((selected.TEffPowerFlag!="Y")){
		//	var dd = $('#DiagnosisLevelQueryTab').datagrid('getEditor', { index: EditIndex, field: 'TEmpower' });		
		//	$(dd.target).checkbox("disable");  
	    //}else{
		    var dd = $('#DiagnosisLevelQueryTab').datagrid('getEditor', { index: EditIndex, field: 'TEmpower' });		
			$(dd.target).checkbox("enable"); 
	    //}
	}
 }

//����
function BSave_click()
{
	$('#DiagnosisLevelQueryTab').datagrid('acceptChanges');
	
	var selected = $('#DiagnosisLevelQueryTab').datagrid('getSelected');
	if(selected ==null){
		$.messager.alert('��ʾ', "��ѡ������������", 'info');
		return;
	}
	if (selected) {
		
		if (selected.TRowID == "") {
			if ((selected.TLevel == "undefined")||(selected.TDesc=="undefined")||(selected.TNoActive == "undefined")||(selected.TLevel == "")||(selected.TDesc=="")||(selected.TNoActive == "")) {
				$.messager.alert('��ʾ', "����Ϊ��,���������", 'info');
				LoadDiagnosisLevel()
				return;
			}
			$.m({
				ClassName: "web.DHCPE.CT.DiagnosisLevel",
				MethodName: "Insert",
				level:selected.TLevel,
				Desc:selected.TDesc,
				NoActive:selected.TNoActive,
				tableName:tableName,
				LocID:$("#LocList").combobox('getValue'),
				UserID:session['LOGON.USERID'],
				Empower:selected.TEmpower
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('��ʾ', rtnArr[1], 'error');
					
				}else{
					
					$.messager.alert('��ʾ', '����ɹ�', 'success');
					
				}
			
				
			LoadDiagnosisLevel()
			});
		} else {
			$('#DiagnosisLevelQueryTab').datagrid('selectRow', EditIndex);
			var selected = $('#DiagnosisLevelQueryTab').datagrid('getSelected');
            if(selected ==null){ return; }
			$.messager.confirm("ȷ��", "ȷ��Ҫ����������", function(r){
			if (r){
					
					if ((selected.TLevel == "undefined")||(selected.TDesc=="undefined")||(selected.TNoActive == "undefined")||(selected.TLevel == "")||(selected.TDesc=="")||(selected.TNoActive == "")) {
						$.messager.alert('��ʾ', "����Ϊ��,�������޸�", 'info');
						LoadDiagnosisLevel()
						return;
					}
					/*
					if ((selected.TNoActive=="Y")&&(selected.TEmpower=="Y")){
						$.messager.alert('��ʾ', "������Ȩ���ݲ�������", 'info');
						return;
					}*/
					$.m({
						ClassName: "web.DHCPE.CT.DiagnosisLevel",
						MethodName: "Update",
						rowid: selected.TRowID,
						level:selected.TLevel,
						Desc:selected.TDesc,
						NoActive:selected.TNoActive,
						UserID:session['LOGON.USERID'],
						tableName:tableName,
						LocID:$("#LocList").combobox('getValue'),
						Empower:selected.TEmpower	
				
					}, function (rtn) {
						var rtnArr=rtn.split("^");
						if(rtnArr[0]=="-1"){	
						$.messager.alert('��ʾ', rtnArr[1], 'error');
					
					}else{	
						$.messager.alert('��ʾ', '�޸ĳɹ�', 'success');
					
					}
			
					LoadDiagnosisLevel()
				});
			
			
				}
			});	
		
			
		}
	}
}



//ɾ��
function BDelete_click()
{
	var ID=$("#ID").val();
	if(ID==""){
			$.messager.alert("��ʾ","��ѡ���ɾ���ļ�¼","info");
			return false;
	}
	
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
				$.m({ ClassName:"web.DHCPE.DiagnosisLevel", MethodName:"Delete",InString:ID},function(ReturnValue){
				if (ReturnValue!="0") {
					if(ReturnValue.indexOf("^")>0){
						$.messager.alert("��ʾ",$g("ɾ��ʧ��:")+ReturnValue.split("^")[1],"error"); 
					} else{
						$.messager.alert("��ʾ","ɾ��ʧ��","error"); 
					}
 
				}else{
					$.messager.alert("��ʾ","ɾ���ɹ�","success");
					BClear_click();	
				}
				});
		}
	});
	
	
}


function LoadDiagnosisLevel()
{
	 $("#DiagnosisLevelQueryTab").datagrid('reload');
	 $("#BRelateLoc").linkbutton('disable');
}



function InitDiagnosisLevelDataGrid(){
	//alert($("#LocList").combobox('getValue')	
	
	var DiagnosisLevelColumns = [[
			{
				field:'TRowID',
				title:'TRowID',
				hidden:true
			},{
				field:'TLevel',
				width: '200',
			 	title:'����',
				sortable: true,
				resizable: true,
				editor: {
					type: 'validatebox',  
					options: {
						required: true
					}
				}
			 },{
				field:'TDesc',
				width: '200',
			 	title:'����',
				sortable: true,
				resizable: true,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			 },{
				field: 'TNoActive',
				width: '80',
				title: '����',
				align:'center',
				editor: {
					type: 'checkbox',
					options: {
						on:'Y',
						off:'N'
					}
						
				},
                formatter: function (value, rec, rowIndex) {
            		if(value=="Y"){
            			return '<input type="checkbox" checked="checked" disabled/>';
            		}else{
            			return '<input type="checkbox" value="" disabled/>';
            		}
            	}
			},{
				field: 'TEmpower',
				width: '80',
				title: '������Ȩ',
				align:'center',
				editor: {
					type: 'checkbox',
					options: {
						on:'Y',
						off:'N'
					}
						
				},
                formatter: function (value, rec, rowIndex) {
            		if(value=="Y"){
            			return '<input type="checkbox" checked="checked" disabled/>';
            		}else{
            			return '<input type="checkbox" value="" disabled/>';
            		}
            	}
			},{ field:'TEffPowerFlag',width:100,align:'center',title:'��ǰ������Ȩ',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
				}
			}, {
				field: 'TUpdateDate',
				width: '120',
				title: '��������'
			}, {
				field: 'TUpdateTime',
				width: '120',
				title: '����ʱ��'
			}, {
				field: 'TUserName',
				width: '120',
				title: '������'
			}
			
			
			
		]];
		
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];	

	// ��ʼ��DataGrid
	$('#DiagnosisLevelQueryTab').datagrid({
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,
		pageSize: 20,
		pageList : [20,100,200],  
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		columns: DiagnosisLevelColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.DiagnosisLevel",
			QueryName:"LevelAll",
			Code:$("#Level").val(),
			Desc:$("#Desc").val(),
			NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
			tableName:tableName, 
			LocID:locId
		},
		onSelect: function (rowIndex, rowData) {
			if(rowData){
				if((rowData.TEmpower=="Y")&&(rowData.TNoActive=="Y")){		
					$("#BRelateLoc").linkbutton('enable');
				}else{
					$("#BRelateLoc").linkbutton('disable');
				}
			    $("#ID").val(rowData.TRowID);
			}

		},
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});

		
}

