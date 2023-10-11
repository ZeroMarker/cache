
/*
 * FileName: dhcpe.ct.powersuperuser.js
 * Author: xy
 * Date: 2021-08-04
 * Description: 体检用户授权
 */
 
 var lastIndex = "";
var EditIndex = -1;

 $(function(){
		
	InitCombobox();
	
	InitPowerSuperUserGrid();
	
	//查询
     $('#BFind').click(function(){
    	BFind_click();
    });
    
    //新增
     $('#BAdd').click(function(){
    	BAdd_click();
    });
    
    //修改
     $('#BUpdate').click(function(){
    	BUpdate_click();
    });
    
    //保存
     $('#BSave').click(function(){
    	BSave_click();
    });
	    
})


//查询
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


//新增
function BAdd_click()
 {
	lastIndex = $('#PowerSuperUserGrid').datagrid('getRows').length - 1;
	$('#PowerSuperUserGrid').datagrid('selectRow', lastIndex);
	var selected = $('#PowerSuperUserGrid').datagrid('getSelected');
	
	if (selected) {
		if (selected.TPSUID == "") {
			$.messager.alert('提示', "不能同时添加多条!", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('提示', "一次只能修改一条记录", 'info');
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
 
 //修改
 function BUpdate_click()
 {
	var selected = $('#PowerSuperUserGrid').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('提示', "请选择待修改的记录", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#PowerSuperUserGrid').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('提示', "一次只能修改一条记录", 'info');
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

//保存
function BSave_click()
{
	$('#PowerSuperUserGrid').datagrid('acceptChanges');
	var selected = $('#PowerSuperUserGrid').datagrid('getSelected');
	if (selected) {
		// selected.TPSUID为undefined，说明是新建项目，调用保存接口
		if (selected.TPSUID == "") {
			if ((selected.TPSUUserName == "undefined") || (selected.TPSUGroupDesc == "undefined") ||(selected.TPSUPowerType=="undefined")||(selected.TPSUEffPower=="undefined")|| (selected.TPSUUserName == "") || (selected.TPSUGroupDesc== "")|| (selected.TPSUPowerType == "")||(selected.TPSUEffPower=="")) {
				$.messager.alert('提示', "数据为空,不允许添加", 'info');
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
					
					$.messager.alert('提示', '保存失败:'+ rtnArr[1], 'error');
					
				}else{
					
					$.messager.alert('提示', '保存成功', 'success');
					
				}
			
				
				LoadPowerSuperUserGrid();
			});
		} else {
			$('#PowerSuperUserGrid').datagrid('selectRow', EditIndex);
			var selected = $('#PowerSuperUserGrid').datagrid('getSelected');
			if ((selected.TPSUUserName == "undefined") || (selected.TPSUGroupDesc == "undefined") ||(selected.TPSUPowerType=="undefined")||(selected.TPSUEffPower=="undefined")|| (selected.TPSUUserName == "") || (selected.TPSUGroupDesc== "")|| (selected.TPSUPowerType == "")||(selected.TPSUEffPower=="")) {
				$.messager.alert('提示', "数据为空,不允许修改", 'info');
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
					$.messager.alert('提示', '修改失败:'+ rtnArr[1], 'error');
					
				}else{	
					$.messager.alert('提示', '修改成功', 'success');
					
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
			
	// 权限类型
	$HUI.combobox("#PowerType", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'S', text:'超级'},
			{id:'G', text:'科室组'},
			{id:'L', text:'科室'}
	
		]
	});
	
	
	 //用户
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
			{field:'DocName',title:'姓名',width:200},
			{field:'Initials',title:'工号',width:200}	
				
		]],
		onLoadSuccess:function(){
			//$("#UserName").combogrid('setValue',""); 
		}

		});	
		 
		
		
	//安全组
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
		
	//权限类型  下拉列表值
	var PowerTypeData = [{
			id: 'S',
			text: '超级'
		}, {
			id: 'G',
			text: '科室组'
		}, {
			id: 'L',
			text: '科室'
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
				title: '用户',
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
				title: '安全组',
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
				title:'权限类型',
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
				title: '是否有效授权',
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
				title: '更新日期'
			}, {
				field: 'TUpdateTime',
				width: '120',
				title: '更新时间'
			}, {
				field: 'TUpdateUserName',
				width: '120',
				title: '更新人'
			}
		]];
		
	// 初始化DataGrid
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


