
/*
 * FileName: dhcpe.ct.powersuperuser.js
 * Author: xy
 * Date: 2021-08-04
 * Description: ����û���Ȩ
 */
 
 var lastIndex = "";
var EditIndex = -1;

 $(function(){
		
	InitCombobox();
	
	InitPowerSuperUserGrid();
	
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
	
	$("#PowerSuperUserGrid").datagrid('load',{
			ClassName:"web.DHCPE.CT.PowerSuperUser",
			QueryName:"SearchPowerSuperUser",
			UserID:$("#UserID").combobox('getValue'), 
			GroupID:$("#GroupID").combobox('getValue'), 
			PowerType:$("#PowerType").combobox('getValue'),
			EffPower:$("#EffPower").checkbox('getValue') ? "Y" : "N"
			
		});	
}


//����
function BAdd_click()
 {
	lastIndex = $('#PowerSuperUserGrid').datagrid('getRows').length - 1;
	$('#PowerSuperUserGrid').datagrid('selectRow', lastIndex);
	var selected = $('#PowerSuperUserGrid').datagrid('getSelected');
	
	if (selected) {
		if (selected.TPSUID == "") {
			$.messager.alert('��ʾ', "����ͬʱ��Ӷ���!", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
		return;
	}
	$('#PowerSuperUserGrid').datagrid('appendRow', {
		TPSUID: '',
		TPSUUserDR:'',
		TPSUUserName:'',
		TPSUGroupDR:'',
		TPSUGroupDesc: '',
		TPSUPowerTypeID:'',
		TPSUPowerType:'',
		TPSUEffPower:'',
		TUpdateDate:'',
		TUpdateTime:'',
		TUpdateUserName:''
			});
	lastIndex = $('#PowerSuperUserGrid').datagrid('getRows').length - 1;
	$('#PowerSuperUserGrid').datagrid('selectRow', lastIndex);
	$('#PowerSuperUserGrid').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
	
 }
 
 //�޸�
 function BUpdate_click()
 {
	var selected = $('#PowerSuperUserGrid').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('��ʾ', "��ѡ����޸ĵļ�¼", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#PowerSuperUserGrid').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
			return;
		}
		$('#PowerSuperUserGrid').datagrid('beginEdit', thisIndex);
		$('#PowerSuperUserGrid').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
		var selected = $('#PowerSuperUserGrid').datagrid('getSelected');

		var thisEd = $('#PowerSuperUserGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TPSUUserName'   
			});
		$(thisEd.target).combobox('select', selected.TPSUUserDR);  
		 
		var thisEd = $('#PowerSuperUserGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TPSUGroupDesc'  
			});
			  
		$(thisEd.target).combobox('select', selected.TPSUGroupDR);
		
		var thisEd = $('#PowerSuperUserGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TPSUPowerType'  
			});
			  
		$(thisEd.target).combobox('select', selected.TPSUPowerTypeID);
	}
 }

//����
function BSave_click()
{
	$('#PowerSuperUserGrid').datagrid('acceptChanges');
	var selected = $('#PowerSuperUserGrid').datagrid('getSelected');
	if (selected) {
		// selected.TPSUIDΪundefined��˵�����½���Ŀ�����ñ���ӿ�
		if (selected.TPSUID == "") {
			if ((selected.TPSUUserName == "undefined") || (selected.TPSUGroupDesc == "undefined") ||(selected.TPSUPowerType=="undefined")||(selected.TPSUEffPower=="undefined")|| (selected.TPSUUserName == "") || (selected.TPSUGroupDesc== "")|| (selected.TPSUPowerType == "")||(selected.TPSUEffPower=="")) {
				$.messager.alert('��ʾ', "����Ϊ��,���������", 'info');
				LoadPowerSuperUserGrid();
				return;
			}
			$.m({
				ClassName: "web.DHCPE.CT.PowerSuperUser",
				MethodName: "InsertPowerSuperUser",
				UserID: selected.TPSUUserName,
				GroupID: selected.TPSUGroupDesc,
				PowerType: selected.TPSUPowerType,
				EffPower: selected.TPSUEffPower,
				CurUserID:session['LOGON.USERID']  
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){
					
					$.messager.alert('��ʾ', '����ʧ��:'+ rtnArr[1], 'error');
					
				}else{
					
					$.messager.alert('��ʾ', '����ɹ�', 'success');
					
				}
			
				
				LoadPowerSuperUserGrid();
			});
		} else {
			$('#PowerSuperUserGrid').datagrid('selectRow', EditIndex);
			var selected = $('#PowerSuperUserGrid').datagrid('getSelected');
			if ((selected.TPSUUserName == "undefined") || (selected.TPSUGroupDesc == "undefined") ||(selected.TPSUPowerType=="undefined")||(selected.TPSUEffPower=="undefined")|| (selected.TPSUUserName == "") || (selected.TPSUGroupDesc== "")|| (selected.TPSUPowerType == "")||(selected.TPSUEffPower=="")) {
				$.messager.alert('��ʾ', "����Ϊ��,�������޸�", 'info');
				LoadPowerSuperUserGrid();
				return;
			}
			var Active=selected.TActive
			$.m({
				ClassName: "web.DHCPE.CT.PowerSuperUser",
				MethodName: "UpdatePowerSuperUser",
				PSURowid: selected.TPSUID,
				UserID: selected.TPSUUserName,
				GroupID: selected.TPSUGroupDesc,
				PowerType: selected.TPSUPowerType,
				EffPower: selected.TPSUEffPower,
				CurUserID:session['LOGON.USERID']  
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('��ʾ', '�޸�ʧ��:'+ rtnArr[1], 'error');
					
				}else{	
					$.messager.alert('��ʾ', '�޸ĳɹ�', 'success');
					
				}
			
				LoadPowerSuperUserGrid();
			});
		}
	}
}

function LoadPowerSuperUserGrid()
{
	$("#PowerSuperUserGrid").datagrid('reload');
}

function InitCombobox()
{
			
	// Ȩ������
	$HUI.combobox("#PowerType", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'S', text:'����'},
			{id:'G', text:'������'},
			{id:'L', text:'����'}
	
		]
	});
	
	
	 //�û�
	   varUserObj = $HUI.combogrid("#UserID",{
		panelWidth:470,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXT",
		mode:'remote',
		delay:200,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
		idField:'DocDr',
		textField:'DocName',
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.Type="B";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];

		},
		columns:[[
		    {field:'DocDr',title:'ID',width:40},
			{field:'DocName',title:'����',width:200},
			{field:'Initials',title:'����',width:200}	
				
		]],
		onLoadSuccess:function(){
			//$("#UserName").combogrid('setValue',""); 
		}

		});	
		 
		
		
	//��ȫ��
	var GroupObj = $HUI.combobox("#GroupID",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindFeeTypeSuperGroup&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		onBeforeLoad:function(param){
			param.GroupDesc = param.q;
			param.hospId = session['LOGON.HOSPID']; 
		}

	});	
	
	    
	
}

function InitPowerSuperUserGrid()
{
		
	//Ȩ������  �����б�ֵ
	var PowerTypeData = [{
			id: 'S',
			text: '����'
		}, {
			id: 'G',
			text: '������'
		}, {
			id: 'L',
			text: '����'
		}];
	
	var PowerSuperUserColumns = [[
			{
				field: 'TPSUID',
				title: 'TPSUID',
				hidden: true
			}, {
				field: 'TPSUUserDR',
				title: 'TPSUUserDR',  
				hidden: true
			},{
				field: 'TPSUGroupDR',
				title: 'TPSUGroupDR',
				hidden: true
			}, {
				field: 'TPSUUserName',
				title: '�û�',
				width: 230,
			    formatter:function(value,row){
                    return row.TPSUUserName;
                },
				 editor:{
                    type:'combobox',
                    options:{
	                    required: true,
                        valueField:'DocDr',
                        textField:'DocName',
                        method:'get',
                        url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXT&ResultSetType=array",
                        onBeforeLoad:function(param){   
			                param.Desc = param.q;
							param.Type="B";
							param.LocID=session['LOGON.CTLOCID'];
							param.hospId = session['LOGON.HOSPID'];
                            
                           }
                        
                    }
                }
			},  {
				field: 'TPSUGroupDesc',
				title: '��ȫ��',
				width: 230,
			    formatter:function(value,row){
                    return row.TPSUGroupDesc;
                },
				 editor:{
                    type:'combobox',
                    options:{
	                    required: true,
                        valueField:'id',
                        textField:'desc',
                        method:'get',
                        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindFeeTypeSuperGroup&ResultSetType=array",
                        onBeforeLoad:function(param){ 
                           param.GroupDesc = param.q; 
                           param.hospId = session['LOGON.HOSPID'];  
                            
                           }
                        
                    }
                }
			},{
				field: 'TPSUPowerType',
				title:'Ȩ������',
				width:200,
				sortable:true,
				resizable:true,
				editor: {
					type:'combobox',
					options: {
						valueField: 'id',
						textField: 'text',
						data: PowerTypeData,
						required: true
					}
				}
				
				
			},{
				field: 'TPSUEffPower',
				width: '100',
				title: '�Ƿ���Ч��Ȩ',
				align:'center',
				editor: {
					type: 'checkbox',
					options: {
						on:'Y',
						off:'N',
						required: true
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
				field: 'TUpdateUserName',
				width: '120',
				title: '������'
			}
		]];
		
	// ��ʼ��DataGrid
	$('#PowerSuperUserGrid').datagrid({
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
		
		columns: PowerSuperUserColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.PowerSuperUser",
			QueryName:"SearchPowerSuperUser",

		},
		
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});
	
}


