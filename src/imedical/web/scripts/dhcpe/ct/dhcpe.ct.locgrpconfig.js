
/*
 * FileName: dhcpe.ct.locgrpconfig.js
 * Author: xy
 * Date: 2021-08-02
 * Description: 科室分组维护
 */
 
 var lastIndex = "";
var EditIndex = -1;

 $(function(){
		
	InitCombobox();
	
	InitLocGrpGrid();
	
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
	
	$("#LocGrpGrid").datagrid('load',{
			ClassName:"web.DHCPE.CT.LocGrpConfig",
			QueryName:"SearchLocGrp",
			LocID:$('#LocID').combogrid('getValue'), 
			LocGrpID:$('#LocGrpID').combogrid('getValue'), 
			HospID:$('#Hospital').combobox('getValue'),
			ActiveFlag:$('#Active').checkbox('getValue') ? "Y" : "N",
			
			
		});	
}
//新增
function BAdd_click()
 {
	lastIndex = $('#LocGrpGrid').datagrid('getRows').length - 1;
	$('#LocGrpGrid').datagrid('selectRow', lastIndex);
	var selected = $('#LocGrpGrid').datagrid('getSelected');
	if (selected) {
		if (selected.TLGCRowid == "") {
			$.messager.alert('提示', "不能同时添加多条!", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('提示', "一次只能修改一条记录", 'info');
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
 
 //修改
 function BUpdate_click()
 {
	var selected = $('#LocGrpGrid').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('提示', "请选择待修改的记录", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#LocGrpGrid').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('提示', "一次只能修改一条记录", 'info');
			return;
		}
		$('#LocGrpGrid').datagrid('beginEdit', thisIndex);
		$('#LocGrpGrid').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
		var selected = $('#LocGrpGrid').datagrid('getSelected');

		var thisEd = $('#LocGrpGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TLocDesc'   // 科室
			});
		$(thisEd.target).combobox('select', selected.TLocRowid);  
		 
		var thisEd = $('#LocGrpGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TLocGrpDesc'  //默认科室
			});
			  
		$(thisEd.target).combobox('select', selected.TLocGrpRowid);

		var thisEd = $('#LocGrpGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TLocDesc2'   // 科室别名
			});	
	}
 }


//保存
function BSave_click()
{
	$('#LocGrpGrid').datagrid('acceptChanges');
	var selected = $('#LocGrpGrid').datagrid('getSelected');
	if (selected) {
		
		if (selected.TLGCRowid == "") {
			if ((selected.TLocDesc == "undefined") || (selected.TLocGrpDesc == "undefined") ||(selected.TActive=="undefined")|| (selected.TLocDesc == "") || (selected.TLocGrpDesc == "")||(selected.TActive == "")) {
				$.messager.alert('提示', "数据为空,不允许添加", 'info');
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
					$.messager.alert('提示', '保存失败:'+ rtnArr[1], 'error');	
				}else{
					$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
				}
				LoadLocGrpGrid();
			});
		} else {
			$('#LocGrpGrid').datagrid('selectRow', EditIndex);
			var selected = $('#LocGrpGrid').datagrid('getSelected');
			if ((selected.TLocDesc == "undefined") || (selected.TLocGrpDesc == "undefined") ||(selected.TActive=="undefined")|| (selected.TLocDesc == "")||(selected.TLocGrpDesc == "")||(selected.TActive == "")) {
				$.messager.alert('提示', "数据为空,不允许修改", 'info');
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
					$.messager.alert('提示', '修改失败:'+ rtnArr[1], 'error');
				}else{
					$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});		
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
	
	//医院
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
	
	
	//科室
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
			{field:'CTLOCCODE',title:'科室编码',width:100},
			{field:'Desc',title:'科室名称',width:200}
			]]
	});
	
	//科室组
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
			{field:'CTLOCCODE',title:'科室编码',width:100},
			{field:'Desc',title:'科室名称',width:200}		
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
				title: '科室名称',
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
				title: '科室别名',
				width: '200',
				editor: {
					type: 'validatebox',
					required: true
				}
			}, {
				field: 'TLocGrpDesc',
				title: '科室组',
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
				title: '科室编码'
			},{
				field: 'THopDesc',
				width: '200',
				title: '院区'
			},{
				field: 'TActive',
				width: '80',
				title: '激活',
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
				title: '更新日期'
			}, {
				field: 'TUpdateTime',
				width: '100',
				title: '更新时间'
			}, {
				field: 'TUserName',
				width: '80',
				title: '更新人'
			}
		]];
		
	// 初始化DataGrid
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


