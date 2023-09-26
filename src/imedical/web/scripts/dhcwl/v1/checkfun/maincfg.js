/// Creator   : wk
/// CreatDate : 2018-09-29
/// Desc      : 考核方案维护
var COMBOBOX_DATA_LOAD = 0;
var STAND_COMBOX_LOAD = 0;
var EXCEPT_COMBO_LOAD = 0;
var dimProObj = "";

var kpiBodyHeight = getViewportOffset().y;
kpiBodyHeight = kpiBodyHeight > 500 ? 500 : kpiBodyHeight;
$HUI.datagrid("#checkFunGrid",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.CheckFun.CheckFunCfg',
		QueryName:'GetProGram'
	},
	fitColumns:true,
	pagination:true,
	pageList:[15,20,50,100],
	pageSize:15,
	toolbar:"#checkFunToobar"
})

/*--方案新增--*/
$("#addButton").click(function(e){
	/*if (!COMBOBOX_DATA_LOAD){
		comboboxLoad();
	}else{
		comboboxDataLoad();
	}*/
	comboboxLoad();
	$("#checkFunAddInforForm").form('reset');    //内容重置
	$("#checkFunAddDialog").show();
	$HUI.dialog("#checkFunAddDialog",{
		iconCls:'icon-w-add',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#checkFunAddInforForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var code,desc,section,dim,dimPro;   //获取表单数据
				code = $("#checkFunCode").val();
				desc = $("#checkFunDesc").val();
				section = $("#checkFunSection").combobox("getText");
				var dimGrid = $('#checkFunDim').combogrid('grid');	
				var dimRow = dimGrid.datagrid('getSelected');
				dim = dimRow.ID;
				var dimProGrid = $('#checkFunDimPro').combogrid('grid');
				var dimProRow = dimProGrid.datagrid('getSelected');
				dimPro = dimProRow.ID;
				//alert(code+"^"+desc+"^"+section+"^"+dim+"^"+dimPro);
				$m({
					ClassName:'web.DHCWL.V1.CheckFun.CheckFunCfg',
					MethodName:'AddCheckFunSet',
					code:code,
					desc:desc,
					section:section,
					dim:dim,
					dimPro:dimPro
				},function(e){
					myMsg(e);
					$HUI.dialog("#checkFunAddDialog").close();
					$("#checkFunGrid").datagrid("reload");
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#checkFunAddDialog").close();
			}
		}]
	})
})


/*--方案修改--*/
$("#modifyButton").click(function(e){
	var row = $("#checkFunGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择一条修改方案");
		return;
	}
	var checkFunID = row.ID;
	$("#checkFunModInforForm").form('reset');    //内容重置
	$("#checkFunModCode").val(row.code);
	$("#checkFunModDesc").val(row.desc);
	$("#checkFunModInforForm").form('validate');
	$("#checkFunModDialog").show();
	$HUI.dialog("#checkFunModDialog",{
		resizable:true,
		modal:true,
		iconCls:'icon-w-edit',
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#checkFunModInforForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var desc = $("#checkFunModDesc").val();
				$m({
					ClassName:'web.DHCWL.V1.CheckFun.CheckFunCfg',
					MethodName:'UpdateCheckFunSet',
					ID:checkFunID,
					desc:desc
				},function(e){
					myMsg(e);
					$HUI.dialog("#checkFunModDialog").close();
					$("#checkFunGrid").datagrid("reload");
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#checkFunModDialog").close();
			}
		}]
	});
})

/*--方案删除--*/
$("#deleteButton").click(function(e){
	var row = $("#checkFunGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择一条方案");
		return;
	}
	var checkFunID = row.ID;
	$.messager.confirm("提示", "删除后将不能恢复,确认删除么?", function (r) {
		if (r) {
			$m({
				ClassName:'web.DHCWL.V1.CheckFun.CheckFunCfg',
				MethodName:'DeleteCheckFunSet',
				ID:checkFunID
			},function(e){
				myMsg(e);
				$("#checkFunGrid").datagrid('reload');
			})
		}
	});
})

/*--方案检索--*/
$('#searchText').searchbox({
	searcher:function(value,name){
		$("#checkFunGrid").datagrid("load",{ClassName:'web.DHCWL.V1.CheckFun.CheckFunCfg',QueryName:'GetProGram',filterValue:value});
	}
})

/*--方案指标维护--*/
$("#kpiCfgButton").click(function(e){
	var row = $("#checkFunGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择一条方案");
		return;
	}
	var checkFunID = row.ID;
	$HUI.datagrid("#kpiSelectDetailGrid",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.CheckFun.CheckFunCfg',
			QueryName:'GetSelectKPI',
			checkFunID:checkFunID
		},
		fitColumns:true,
		toolbar:'#kpiSelectDetailToobar',
		pagination:true,
		pageList:[15,20,50],
		pageSize:15
	});
	$HUI.datagrid("#kpiAllDetailGrid",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.CheckFun.CheckFunCfg',
			QueryName:'GetAllKPI',
			checkFunID:checkFunID
		},
		fitColumns:true,
		pagination:true,
		toolbar:'#kpiDetailToobar',
		pageList:[15,20,50],
		pageSize:15
	})
	$("#searchKPI").searchbox("setValue","");
	$("#grpDetailDialog").show();
	$HUI.dialog("#grpDetailDialog",{
		height:kpiBodyHeight-20,
		iconCls:'icon-w-config',
		resizable:true,
		modal:true
	})
})

/*--指标查询--*/
$('#searchKPI').searchbox({
	searcher:function(value,name){
		var row = $("#checkFunGrid").datagrid("getSelected");
		if (!row){
			myMsg("请先选择一条方案");
			return;
		}
		var checkFunID = row.ID;
		$("#kpiAllDetailGrid").datagrid("load",{ClassName:'web.DHCWL.V1.CheckFun.CheckFunCfg',QueryName:'GetAllKPI',checkFunID:checkFunID,filterValue:value});
	}
})

/*--方案指标新增--*/
$("#kpiAddButton").click(function(e){
	var kpiRow = $("#kpiAllDetailGrid").datagrid("getSelected");
	if (!kpiRow){
		myMsg("请先选择一条指标");
		return;
	}
	var ID = kpiRow.ID;
	var checkFunRow = $("#checkFunGrid").datagrid("getSelected");
	if (!checkFunRow){
		myMsg("获取方案失败");
		return;
	}
	var checkFunID = checkFunRow.ID;
	$m({
		ClassName:'web.DHCWL.V1.CheckFun.CheckFunCfg',
		MethodName:'AddCheckFunRel',
		kpiID:ID,
		checkFunID:checkFunID
	},function(e){
		myMsg(e);
		$("#kpiSelectDetailGrid").datagrid("reload");
		$("#kpiAllDetailGrid").datagrid("reload");
	})
})
/*--方案指标删除--*/
$("#kpiDeleteButton").click(function(e){
	var kpiRow = $("#kpiSelectDetailGrid").datagrid("getSelected");
	if (!kpiRow){
		myMsg("请先选择需要删除的指标");
		return;
	}
	var ID = kpiRow.ID;
	
	$.messager.confirm("提示", "删除后将不能恢复,确认要删除么？", function (r) {
		if (r) {
			$m({
				ClassName:'web.DHCWL.V1.CheckFun.CheckFunCfg',
				MethodName:'DeleteCheckFunRel',
				ID:ID
			},function(e){
				if(e == "ok"){
					myMsg("删除成功");
				}else{
					myMsg("删除失败");
				}
				$("#kpiSelectDetailGrid").datagrid("reload");
				$("#kpiAllDetailGrid").datagrid("reload");
				
			})
		}
	});
})

/*--标准值维护--*/
$("#standardValueButton").click(function(e){
	var row = $("#checkFunGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择一条方案");
		return;
	}
	var ID = row.ID;
	$("#standardValueGrid").datagrid({
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.CheckFun.CheckFunCfg',
			QueryName:'GetEValue',
			checkFunID:ID
		},
		fitColumns:true,
		pagination:true,
		toolbar:'#standToobar',
		pageList:[15,20,50],
		pageSize:15,
		onClickRow:function(rowIndex, rowData){
			$('#searchExcept').searchbox('clear');
			var standID = rowData.ID;
			$("#exceptionValueGrid").datagrid("load",{ClassName:'web.DHCWL.V1.CheckFun.CheckFunCfg',QueryName:'GetExceptValue',checkfunID:ID,standID:standID})
		},
		onLoadSuccess:function(data){
			$('#exceptionValueGrid').datagrid('loadData',{total:0,rows:[]});
		}
	})
	
	$("#exceptionValueGrid").datagrid({
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.CheckFun.CheckFunCfg",
			QueryName:'GetExceptValue'
		},
		fitColumns:true,
		pagination:true,
		toolbar:'#exceptToobar',
		pageList:[15,20,50],
		pageSize:15
	})
	
	$("#searchStand").searchbox("setValue","");
	$("#searchExcept").searchbox("setValue","");
	
	$("#standardValueDialog").show();
	$HUI.dialog("#standardValueDialog",{
		height:kpiBodyHeight-40,
		iconCls:'icon-w-config',
		fitColumns:true,
		modal:true
	})
})

/*--标准值新增--*/
$("#standAddButton").click(function(e){
	var row = $("#checkFunGrid").datagrid("getSelected");
	if (!row){
		myMsg("方案获取失败");
		return;
	}
	var checkfunID = row.ID;
	/*if(!STAND_COMBOX_LOAD){
		standComboboxLoad(checkfunID);
	}else{
		standComboboxDataLoad();
	}*/
	standComboboxLoad(checkfunID);
	$("#standAddInforForm").form('reset');    //内容重置
	$("#standAddDialog").show();
	$HUI.dialog("#standAddDialog",{
		iconCls:'icon-w-add',
		fitColumns:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#standAddInforForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var kpiGrid,kpiRow,kpiID;
				kpiGrid = $('#kpiCombo').combogrid('grid');	   //获取下拉指标ID
				kpiRow = kpiGrid.datagrid('getSelected');
				kpiID = kpiRow.kpiID;
				var activeDate = $('#activeDate').combogrid('getText');   //获取生效日期显示值
				var value = $("#standValue").val();
				
				$m({    ///访问后台数据保存
					ClassName:'web.DHCWL.V1.CheckFun.CheckFunCfg',
					MethodName:'AddStandardValue',
					checkfunID:checkfunID,
					kpiID:kpiID,
					value:value,
					activeDate:activeDate
				},function(e){
					myMsg(e);
					$("#standardValueGrid").datagrid("reload");
					$HUI.dialog("#standAddDialog").close();
				})
				
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#standAddDialog").close();
			}
		}]
	})
})

/*--标准值修改--*/
$("#standModButton").click(function(e){
	var row = $("#checkFunGrid").datagrid("getSelected");
	if (!row){
		myMsg("方案获取失败");
		return;
	}
	var checkfunID = row.ID;
	
	var standRow = $("#standardValueGrid").datagrid("getSelected");
	if (!standRow){
		myMsg("请先选择需要修改的标准记录");
		return;
	}
	var standID,standDesc,standValue;
	standID = standRow.ID;
	standDesc = standRow.desc;
	standValue = standRow.value;
	$("#kpiModCombo").val(standDesc);
	$("#standModValue").val(standValue);
	$("#standModInforForm").form('validate');
	$("#standModDialog").show();
	$HUI.dialog("#standModDialog",{
		iconCls:'icon-w-edit',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#standModInforForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var value = $("#standModValue").val();
				$m({
					ClassName:'web.DHCWL.V1.CheckFun.CheckFunCfg',
					MethodName:'UpdateStandardValue',
					id:standID,
					value:value
				},function(e){
					myMsg(e);
					$("#standardValueGrid").datagrid("reload");
					$HUI.dialog("#standModDialog").close();
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#standModDialog").close();
			}
		}]
	});
})

/*--标准值删除--*/
$("#standRemoveButton").click(function(e){
	var standRow = $("#standardValueGrid").datagrid("getSelected");
	if (!standRow){
		myMsg("请先选择需要删除的标准记录");
		return;
	}
	var standID = standRow.ID;
	$.messager.confirm("提示", "删除后将不能恢复,确认删除么?", function (r) {
		if (r) {
			$m({
				ClassName:'web.DHCWL.V1.CheckFun.CheckFunCfg',
				MethodName:'DeleteStandardValue',
				id:standID
			},function(e){
				myMsg(e);
				$("#standardValueGrid").datagrid("reload");
			})
		}
	});
})

/*--标准值修改--*/
$('#searchStand').searchbox({
	searcher:function(value,name){
		var row = $("#checkFunGrid").datagrid("getSelected");
		if (!row){
			myMsg("方案获取失败");
			return;
		}
		var checkfunID = row.ID;
		$("#standardValueGrid").datagrid("load",{ClassName:'web.DHCWL.V1.CheckFun.CheckFunCfg',QueryName:'GetEValue',checkFunID:checkfunID,filterValue:value});
	}
})

/*--例外值新增--*/
$("#exceptAddButton").click(function(e){
	var row = $("#checkFunGrid").datagrid("getSelected");
	if (!row){
		myMsg("方案获取失败");
		return;
	}
	var checkfunID = row.ID;
	
	var standRow = $("#standardValueGrid").datagrid("getSelected");
	if (!standRow){
		myMsg("请先选择一条标准记录");
		return;
	}
	var standID = standRow.ID;
	/*if (!EXCEPT_COMBO_LOAD){
		exceptComboboxLoad(checkfunID);
	}else{
		exceptComboboxDataLoad();
	}*/
	exceptComboboxLoad(checkfunID);
	$("#exceptAddInforForm").form('reset');    //内容重置
	$("#exceptAddDialog").show();
	$HUI.dialog("#exceptAddDialog",{
		iconCls:'icon-w-add',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#exceptAddInforForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var assessGrid,assessRow,assessID;
				assessGrid = $('#assessObj').combogrid('grid');	
				assessRow = assessGrid.datagrid('getSelected');
				assessID = assessRow.ID;
				var value = $("#exceptValue").val();
				//alert(assessID+"^"+desc+"^"+value+"^"+standID);
				$m({
					ClassName:'web.DHCWL.V1.CheckFun.CheckFunCfg',
					MethodName:'AddexceptValue',
					standID:standID,
					objID:assessID,
					value:value
				},function(e){
					myMsg(e);
					$("#exceptionValueGrid").datagrid("reload");
					$HUI.dialog("#exceptAddDialog").close();
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#exceptAddDialog").close();
			}
		}]
	})
})

/*--例外值修改--*/
$("#exceptModButton").click(function(e){
	var exceptRow = $("#exceptionValueGrid").datagrid("getSelected");
	if (!exceptRow){
		myMsg("请先选择需要修改的记录");
		return;
	}
	var objDesc = exceptRow.obj;
	var objValue = exceptRow.excepValue;
	var exceptID = exceptRow.ID;
	$("#assessDesc").val(objDesc);
	$("#exceptModValue").val(objValue);
	$("#exceptModInforForm").form('validate');
	$("#exceptModDialog").show();
	$HUI.dialog("#exceptModDialog",{
		iconCls:'icon-w-edit',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#exceptModInforForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var value = $("#exceptModValue").val();
				$m({
					ClassName:'web.DHCWL.V1.CheckFun.CheckFunCfg',
					MethodName:'UpdateExceptValue',
					value:value,
					exceptID:exceptID
				},function(e){
					myMsg(e);
					$HUI.dialog("#exceptModDialog").close();
					$("#exceptionValueGrid").datagrid("reload");
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#exceptModDialog").close();
			}
		}]
	})
})

/*--例外值删除--*/
$("#exceptRemoveButton").click(function(e){
	var exceptRow = $("#exceptionValueGrid").datagrid("getSelected");
	if (!exceptRow){
		myMsg("请先选择需要删除的记录");
		return;
	}
	var exceptID = exceptRow.ID;
	$.messager.confirm("提示", "删除后将不能恢复,确认删除么？", function (r) {
		if (r) {
			$m({
				ClassName:'web.DHCWL.V1.CheckFun.CheckFunCfg',
				MethodName:'DeleteexceptValue',
				exceptID:exceptID
			},function(e){
				myMsg(e);
				$("#exceptionValueGrid").datagrid("reload");
			})
		}
	});
})
/*--例外值检索--*/
$('#searchExcept').searchbox({
	searcher:function(value,name){
		var row = $("#checkFunGrid").datagrid("getSelected");
		if (!row){
			myMsg("请先选择一条方案");
			return;
		}
		var ID = row.ID;
		
		var standRow = $("#standardValueGrid").datagrid("getSelected");
		if (!standRow){
			myMsg("请选选择一条标准记录");
			return;
		}
		var standID = standRow.ID;
		$("#exceptionValueGrid").datagrid("load",{ClassName:'web.DHCWL.V1.CheckFun.CheckFunCfg',QueryName:'GetExceptValue',checkfunID:ID,standID:standID,filterValue:value})
	}
})

/*--方案新增时,维度、维度属性加载--*/
function comboboxLoad(){
	COMBOBOX_DATA_LOAD = 1;
	/*--维度下拉框数据获取--*/
	var dimObj = $HUI.combogrid("#checkFunDim",{
		panelWidth:420,
		url:$URL+"?ClassName=web.DHCWL.V1.Util.Util" + "&QueryName=GetDim",
		mode:'remote',
		delay:200,
		idField:'ID',
		textField:'dimName',
		onBeforeLoad:function(param){
			param.filterValue = param.q;
		},
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'dimCode',title:'编码',width:100},
			{field:'dimName',title:'名称',width:100}
		]],
		fitColumns:true,
		pagination:true,
		pageSize:15,
		pageList:[10,15,20,50,100],
		onSelect:function(record){
			var dimGrid = $('#checkFunDim').combogrid('grid');	
			var dimRow = dimGrid.datagrid('getSelected');	
			//alert(dimRow.dimName);
			var dimID = dimRow.ID;
			var dimProGrid = $('#checkFunDimPro').combogrid('grid');
			dimProGrid.datagrid('load',{ClassName:'web.DHCWL.V1.Util.Util',QueryName:'GetDimPro',dimCode:dimID})
			$('#checkFunDimPro').combogrid('clear');
		}
	});
	/*--维度属性下拉框数据获取--*/
	dimProObj = $HUI.combogrid("#checkFunDimPro",{
		panelWidth:420,
		url:$URL+"?ClassName=web.DHCWL.V1.Util.Util" + "&QueryName=GetDimPro",
		mode:'remote',
		delay:200,
		idField:'ID',
		textField:'name',
		onBeforeLoad:function(param){
			param.filterValue = param.q;
			var dimGrid = $('#checkFunDim').combogrid('grid');	
			var dimRow = dimGrid.datagrid('getSelected');
			if (dimRow){
				var dimID = dimRow.ID;
				param.dimCode = dimID;
			}
		},
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'code',title:'编码',width:100},
			{field:'name',title:'名称',width:100}
		]],
		fitColumns:true,
		pagination:true,
		pageSize:15,
		pageList:[10,15,20,50,100]
	});
}

/*--方案新增时,维度、维度属性数据加载--*/
function comboboxDataLoad(){
	var dimGrid = $('#checkFunDim').combogrid('grid');	
	dimGrid.datagrid('load');
	var dimProGrid = $('#checkFunDimPro').combogrid('grid');
	dimProGrid.datagrid('load',{ClassName:'web.DHCWL.V1.Util.Util',QueryName:'GetDimPro'});
}

/*--标准值新增时,方案指标、生效日期下拉框加载--*/
function standComboboxLoad(checkfunID){
	//STAND_COMBOX_LOAD = 1;
	/*--方案指标下拉框数据获取--*/
	var dateObj = $HUI.combogrid("#activeDate",{
		panelWidth:450,
		url:$URL+"?ClassName=web.DHCWL.V1.CheckFun.CheckFunCfg&QueryName=EffectDate&checkfunID=" + checkfunID,
		mode:'remote',
		delay:200,
		idField:'monID',
		textField:'monDesc',
		onBeforeLoad:function(param){
			param.filterValue = param.q;
		},
		columns:[[
			{field:'monID',title:'日期ID',width:100},
			{field:'monDesc',title:'日期描述',width:100}
		]],
		fitColumns:true,
		pagination:true,
		pageSize:15,
		pageList:[10,15,20,50,100]
	});
	
	/*--方案指标下拉框数据获取--*/
	var kpiComboObj = $HUI.combogrid("#kpiCombo",{
		panelWidth:420,
		url:$URL+"?ClassName=web.DHCWL.V1.CheckFun.CheckFunCfg&QueryName=GetSelectKPI&checkFunID=" + checkfunID,
		mode:'remote',
		delay:200,
		idField:'ID',
		textField:'desc',
		onBeforeLoad:function(param){
			param.filterValue = param.q;
		},
		columns:[[
			{field:'kpiID',title:'ID',width:100},
			{field:'desc',title:'指标名称',width:100}
		]],
		fitColumns:true,
		pagination:true,
		pageSize:15,
		pageList:[10,15,20,50,100]
	});
}
/*--标准值新增时,方案指标、生效日期下拉框数据加载--*/
function standComboboxDataLoad(){
	var dateGrid = $('#activeDate').combogrid('grid');	
	dateGrid.datagrid('load');
	var kpiGrid = $('#kpiCombo').combogrid('grid');	
	kpiGrid.datagrid('load');
}
/*--例外值新增时,考核对象下拉框加载--*/
function exceptComboboxLoad(checkfunID){
	//EXCEPT_COMBO_LOAD = 1;
	/*--考核对象下拉框数据获取--*/
	var assessObj = $HUI.combogrid("#assessObj",{
		panelWidth:420,
		url:$URL+"?ClassName=web.DHCWL.V1.CheckFun.CheckFunCfg&QueryName=GetAssessObj&checkfunID=" + checkfunID,
		mode:'remote',
		delay:200,
		idField:'ID',
		textField:'objDesc',
		onBeforeLoad:function(param){
			param.filterValue = param.q;
		},
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'objDesc',title:'名称',width:100}
		]],
		fitColumns:true,
		pagination:true,
		pageSize:15,
		pageList:[10,15,20,50,100]
	});
}
/*--例外值新增时,考核对象下拉框数据加载--*/
function exceptComboboxDataLoad(){
	var assesGrid = $('#assessObj').combogrid('grid');	
	assesGrid.datagrid('load');
}