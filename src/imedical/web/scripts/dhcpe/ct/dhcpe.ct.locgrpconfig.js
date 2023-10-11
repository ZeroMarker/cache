
/*
 * FileName: dhcpe.ct.locgrpconfig.js
 * Author: xy
 * Date: 2021-08-02
 * Description: ���ҷ���ά��
 */
 
 var lastIndex = "";
var EditIndex = -1;

 $(function(){
		
	InitCombobox();
	
	InitLocGrpGrid();
	
	//��ѯ
     $('#BFind').click(function(){
    	BFind_click();
    });
    
    //����
     $('#BAdd').click(function(){
    	BAdd_click();
    });
    
    //�޸�
     $('#BUpdate').click(function(){
    	BUpdate_click();
    });
    
    //����
     $('#BSave').click(function(){
    	BSave_click();
    });
	 
	
})


//��ѯ
function BFind_click(){
	
	$("#LocGrpGrid").datagrid('load',{
			ClassName:"web.DHCPE.CT.LocGrpConfig",
			QueryName:"SearchLocGrp",
			LocID:$('#LocID').combogrid('getValue'), 
			LocGrpID:$('#LocGrpID').combogrid('getValue'), 
			HospID:$('#Hospital').combobox('getValue'),
			ActiveFlag:$('#Active').checkbox('getValue') ? "Y" : "N",
			
			
		});	
}
//����
function BAdd_click()
 {
	lastIndex = $('#LocGrpGrid').datagrid('getRows').length - 1;
	$('#LocGrpGrid').datagrid('selectRow', lastIndex);
	var selected = $('#LocGrpGrid').datagrid('getSelected');
	if (selected) {
		if (selected.TLGCRowid == "") {
			$.messager.alert('��ʾ', "����ͬʱ��Ӷ���!", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
		return;
	}
	$('#LocGrpGrid').datagrid('appendRow', {
		TLGCRowid: '',
		TLocRowid:'',
		TLocDesc: '',
		TLocDesc2:'',
		TLocCode:'',
		TLocGrpRowid:'',
		TLocGrpDesc: '',
		THopDesc:'',
		TActive: '',
		TUpdateDate:'',
		TUpdateTimeL:'',
		TUserName:''
			});
			
	lastIndex = $('#LocGrpGrid').datagrid('getRows').length - 1;
	$('#LocGrpGrid').datagrid('selectRow', lastIndex);
	$('#LocGrpGrid').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
 }
 
 //�޸�
 function BUpdate_click()
 {
	var selected = $('#LocGrpGrid').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('��ʾ', "��ѡ����޸ĵļ�¼", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#LocGrpGrid').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
			return;
		}
		$('#LocGrpGrid').datagrid('beginEdit', thisIndex);
		$('#LocGrpGrid').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
		var selected = $('#LocGrpGrid').datagrid('getSelected');

		var thisEd = $('#LocGrpGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TLocDesc'   // ����
			});
		$(thisEd.target).combobox('select', selected.TLocRowid);  
		 
		var thisEd = $('#LocGrpGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TLocGrpDesc'  //Ĭ�Ͽ���
			});
			  
		$(thisEd.target).combobox('select', selected.TLocGrpRowid);

		var thisEd = $('#LocGrpGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TLocDesc2'   // ���ұ���
			});	
	}
 }


//����
function BSave_click()
{
	$('#LocGrpGrid').datagrid('acceptChanges');
	var selected = $('#LocGrpGrid').datagrid('getSelected');
	if (selected) {
		
		if (selected.TLGCRowid == "") {
			if ((selected.TLocDesc == "undefined") || (selected.TLocGrpDesc == "undefined") ||(selected.TActive=="undefined")|| (selected.TLocDesc == "") || (selected.TLocGrpDesc == "")||(selected.TActive == "")) {
				$.messager.alert('��ʾ', "����Ϊ��,���������", 'info');
				LoadLocGrpGrid();
				return;
			}
			var LocDesc2=selected.TLocDesc2;
			if(LocDesc2==""){
				LocDesc2=tkMakeServerCall("web.DHCPE.CT.LocGrpConfig","GetLocDescByID",selected.TLocDesc)
			}

			$.m({
				ClassName: "web.DHCPE.CT.LocGrpConfig",
				MethodName: "InsertLocGrp",
				LocID: selected.TLocDesc,
				LocGrpID: selected.TLocGrpDesc,
				LocDesc2: LocDesc2,
				Active: selected.TActive,
				UserID:session['LOGON.USERID']
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){		
					$.messager.alert('��ʾ', '����ʧ��:'+ rtnArr[1], 'error');	
				}else{
					$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
				}
				LoadLocGrpGrid();
			});
		} else {
			$('#LocGrpGrid').datagrid('selectRow', EditIndex);
			var selected = $('#LocGrpGrid').datagrid('getSelected');
			if ((selected.TLocDesc == "undefined") || (selected.TLocGrpDesc == "undefined") ||(selected.TActive=="undefined")|| (selected.TLocDesc == "")||(selected.TLocGrpDesc == "")||(selected.TActive == "")) {
				$.messager.alert('��ʾ', "����Ϊ��,�������޸�", 'info');
				LoadLocGrpGrid();
				return;
			}

			var Active=selected.TActive;
			var LocDesc2=selected.TLocDesc2;
			if(LocDesc2==""){
				LocDesc2=tkMakeServerCall("web.DHCPE.CT.LocGrpConfig","GetLocDescByID",selected.TLocDesc);
			}

			$.m({
				ClassName: "web.DHCPE.CT.LocGrpConfig",
				MethodName: "UpdateLocGrp",
				LGCRowid: selected.TLGCRowid,
				LocID: selected.TLocDesc,
				LocGrpID: selected.TLocGrpDesc,
				LocDesc2: LocDesc2,
				Active: selected.TActive,
				UserID:session['LOGON.USERID']
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){
					$.messager.alert('��ʾ', '�޸�ʧ��:'+ rtnArr[1], 'error');
				}else{
					$.messager.popover({msg: '�޸ĳɹ���',type:'success',timeout: 1000});		
				}
			
				LoadLocGrpGrid();
			});
		}
	}
}

function LoadLocGrpGrid()
{
	$("#LocGrpGrid").datagrid('reload');
}

function InitCombobox()
{
	
	//ҽԺ
	$("#Hospital").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCPE.CT.DHCPEMappingLoc&QueryName=GetHospDataForCombo&ResultSetType=array',
		method: 'GET',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			$(this).combobox('select', session['LOGON.HOSPID']);
		},
		onChange: function(newValue, oldValue) {
		  LocObj.clear();
		  $('#LocID').combogrid('grid').datagrid('reload');	
		  LocGrpObj.clear();
		  $('#LocGrpID').combogrid('grid').datagrid('reload');
		  BFind_click();	
		  
		  
		}
	});
	
	
	//����
	var LocObj = $HUI.combogrid("#LocID",{
		panelWidth:280,
		url:$URL+"?ClassName=web.DHCPE.Public.SettingEdit&QueryName=Querytest",
		mode:'remote',
		delay:200,
		idField:'CTLOCID',
		textField:'Desc',
		onBeforeLoad:function(param){
			param.ctlocdesc = param.q;
			param.hospId = $("#Hospital").combobox('getValue');
			//param.hospId = session['LOGON.HOSPID'];
		},	
		columns:[[
			{field:'CTLOCID',hidden:true},
			{field:'CTLOCCODE',title:'���ұ���',width:100},
			{field:'Desc',title:'��������',width:200}
			]]
	});
	
	//������
	var LocGrpObj = $HUI.combogrid("#LocGrpID",{
		panelWidth:280,
		url:$URL+"?ClassName=web.DHCPE.Public.SettingEdit&QueryName=Querytest",
		mode:'remote',
		delay:200,
		idField:'CTLOCID',
		textField:'Desc',
		onBeforeLoad:function(param){
			param.ctlocdesc = param.q;
			param.hospId = $("#Hospital").combobox('getValue');
			//param.hospId = session['LOGON.HOSPID'];
			
		},
		columns:[[
			{field:'CTLOCID',hidden:true},
			{field:'CTLOCCODE',title:'���ұ���',width:100},
			{field:'Desc',title:'��������',width:200}		
		]]
	});
	
}

function InitLocGrpGrid()
{
	var LocGrpColumns = [[
			{
				field: 'TLGCRowid',
				title: 'TLGCRowid',
				hidden: true
			}, {
				field: 'TLocRowid',
				title: 'TLocRowid',  
				hidden: true
			},{
				field: 'TLocGrpRowid',
				title: 'TLocGrpRowid',
				hidden: true
			}, {
				field: 'TLocDesc',
				title: '��������',
				width: 200,
			    formatter:function(value,row){
                    return row.TLocDesc;
                },
				 editor:{
                    type:'combobox',
                    options:{
	                    required: true,
                        valueField:'CTLOCID',
                        textField:'Desc',
                        method:'get',
                        url:$URL+"?ClassName=web.DHCPE.Public.SettingEdit&QueryName=Querytest&ResultSetType=array",
                        onBeforeLoad:function(param){   
                            param.ctlocdesc = param.q;
			                param.hospId = session['LOGON.HOSPID'];   
                            
                           }
                        
                    }
                }
			}, {
				field: 'TLocDesc2',
				title: '���ұ���',
				width: '200',
				editor: {
					type: 'validatebox',
					required: true
				}
			}, {
				field: 'TLocGrpDesc',
				title: '������',
				width: 200,
			    formatter:function(value,row){
                    return row.TLocGrpDesc;
                },
				 editor:{
                    type:'combobox',
                    options:{
	                    required: true,
                        valueField:'CTLOCID',
                        textField:'Desc',
                        method:'get',
                        url:$URL+"?ClassName=web.DHCPE.Public.SettingEdit&QueryName=Querytest&ResultSetType=array",
                        onBeforeLoad:function(param){   
                            param.ctlocdesc = param.q;
			                param.hospId = session['LOGON.HOSPID'];   
                            
                           }
                        
                    }
                }
			},{
				field: 'TLocCode',
				width: '150',
				title: '���ұ���'
			},{
				field: 'THopDesc',
				width: '200',
				title: 'Ժ��'
			},{
				field: 'TActive',
				width: '80',
				title: '����',
				align:'center',
				editor: {
					type: 'checkbox',
					options: {
						on:'Y',
						off:'N'
					}
						
				}
			}, {
				field: 'TUpdateDate',
				width: '100',
				title: '��������'
			}, {
				field: 'TUpdateTime',
				width: '100',
				title: '����ʱ��'
			}, {
				field: 'TUserName',
				width: '80',
				title: '������'
			}
		]];
		
	// ��ʼ��DataGrid
	$('#LocGrpGrid').datagrid({
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		
		columns: LocGrpColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.LocGrpConfig",
			QueryName:"SearchLocGrp",
			LocID:$('#LocID').combobox('getValue'), 
			LocGrpID:$('#LocGrpID').combobox('getValue'), 
			HospID:$('#Hospital').combobox('getValue'),
			ActiveFlag:$('#Active').checkbox('getValue') ? "Y" : "N",

		},
		
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});
	
}


