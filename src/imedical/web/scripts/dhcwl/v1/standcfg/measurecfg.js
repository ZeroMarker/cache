/**
 * Creator   : wk
 * CreatDate : 2018-10-17
 * Desc      : 度量管理界面
 **/
 var COMBOBOX_LOAD_FLAG = 0;
 
/*--度量管理界面--*/ 
$HUI.propertygrid("#measureGrid",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.StandCfg.MeasureCfg',
		QueryName:"GetMeasure"
	},
	toolbar:"#meaToobar",
	columns:[[
		{field:'ID',title:'ID',width:100,align:'left',hidden:true},
		{field:'name',title:'编码',width:100,align:'left'},
		{field:'value',title:'描述',width:100,align:'left'},
		{field:'statDate',title:'口径',width:150,align:'left'},
		{field:'statItem',title:'统计项',width:150,align:'left'}
		
	]],
	showGroup:true,
	fitColumns:true,
	pagination:true, //允许用户通过翻页导航数据
	pageSize:10,  //设置首次界面展示时每页加载条数
	pageList:[10,15,20,50,100] //设置分页可选展示条数
})

/*--度量新增--*/
$("#meaAddButton").click(function(e){
	$("#measureAddForm").form('reset');    //内容重置
	if (!COMBOBOX_LOAD_FLAG){
		comboboxLoad();
	}
	$("#measureAddDialog").show();
	$HUI.dialog("#measureAddDialog",{
		iconCls:'icon-w-add',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#measureAddForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var code,desc;
				code = $("#code").val();
				desc = $("#desc").val();
				var dsGrid,dsRow,dsID;                  // 获取下拉数据源数据
				dsGrid = $('#ds').combogrid('grid');	// get datagrid object
				dsRow = dsGrid.datagrid('getSelected');	// get the selected row
				dsID = dsRow.ID;
				var itemGrid,itemRow,itemCode,itemDesc,itemInfor;   // 获取下拉统计项数据
				itemGrid = $('#statItem').combogrid('grid');
				itemRow = itemGrid.datagrid('getSelected');
				itemCode = itemRow.code;
				itemDesc = itemRow.desc;
				itemInfor = itemCode + ":" +itemDesc;
				var dateGrid,dateRow,dateCode,dateDesc,dateInfor;   // 获取下拉统计口径数据
				dateGrid = $('#statDate').combogrid('grid');
				dateRow = dateGrid.datagrid('getSelected');
				dateCode = dateRow.code;
				dateDesc = dateRow.desc;
				dateInfor = dateCode + ":" + dateDesc;
				//alert(code+"^"+desc+"^"+dsID+"^"+itemInfor+"^"+dateInfor);
				$m({
					ClassName:'web.DHCWL.V1.StandCfg.MeasureCfg',
					MethodName:'AddMeasure',
					code:code,
					desc:desc,
					ds:dsID,
					item:itemInfor,
					date:dateInfor
				},function(text){
					myMsg(text);
					$HUI.dialog("#measureAddDialog").close();
					$("#measureGrid").propertygrid("reload");
				})
				
				//$HUI.dialog("#measureAddDialog").close();
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#measureAddDialog").close();
			}
		}]
	})
})

/*--度量修改--*/
$("#meaModifyButton").click(function(e){
	var row = $("#measureGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择需要修改的对象");
		return;
	}
	var ID = row.ID;
	var code = row.name;
	var desc = row.value;
	$("#modCode").val(code);
	$("#modDesc").val(desc);
	$("#measureModForm").form('validate');
	$("#measureModDialog").show();
	$HUI.dialog("#measureModDialog",{
		iconCls:'icon-w-edit',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#measureModForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var desc = $("#modDesc").val();
				//alert(ID + "^" + desc);
				$m({
					ClassName:'web.DHCWL.V1.StandCfg.MeasureCfg',
					MethodName:'ModifyMeasure',
					ID:ID,
					desc:desc
				},function(text){
					myMsg(text);
					$HUI.dialog("#measureModDialog").close();
					$("#measureGrid").propertygrid("reload");
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#measureModDialog").close();
			}
		}]
	})
})

/*--度量删除--*/
$("#meaDeleteButton").click(function(e){
	var row = $("#measureGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择需要删除的对象");
		return;
	}
	var ID = row.ID;
	$.messager.confirm("提示", "删除后将不能恢复,慎重!!!,确认删除么?", function (r) {
		if (r) {
			$m({
				ClassName:'web.DHCWL.V1.StandCfg.MeasureCfg',
				MethodName:'DeleteMeasure',
				meaID:ID
			},function(text){
				myMsg(text);
				$("#measureGrid").propertygrid("reload");
			})
		}
	});
})

/*--度量新增时数据源、口径、统计项下拉框加载--*/
function comboboxLoad(){
	var dsObj = $HUI.combogrid("#ds",{          /// 数据源下拉框加载
		panelWidth:420,
		url:$URL+"?ClassName=web.DHCWL.V1.StandCfg.MeasureCfg&QueryName=GetDS",
		mode:'remote',
		delay:200,
		idField:'dsCode',
		textField:'dsDesc',
		onBeforeLoad:function(param){
			param.kpiCode = param.q;
		},
		columns:[[
			{field:'ID',title:'ID',width:100,hidden:true},
			{field:'dsCode',title:'数据源编码',width:100},
			{field:'dsDesc',title:'数据源名称',width:100}
		]],
		fitColumns:true,
		pagination:true,
		pageSize:15,
		pageList:[10,15,20,50,100]
	});
	var statItemObj = $HUI.combogrid("#statItem",{        /// 统计项下拉框加载
		panelWidth:420,
		url:$URL+"?ClassName=web.DHCWL.V1.StandCfg.MeasureCfg&QueryName=GetStatItem",
		mode:'remote',
		delay:200,
		idField:'code',
		textField:'desc',
		onBeforeLoad:function(param){
			param.kpiCode = param.q;
		},
		columns:[[
			{field:'code',title:'统计项编码',width:100},
			{field:'desc',title:'统计项名称',width:100}
		]],
		fitColumns:true,
		pagination:true,
		pageSize:15,
		pageList:[10,15,20,50,100]
	}); 
	
	var statDateObj = $HUI.combogrid("#statDate",{    // 统计口径下拉框加载
		panelWidth:420,
		url:$URL+"?ClassName=web.DHCWL.V1.StandCfg.MeasureCfg&QueryName=GetStatDate",
		mode:'remote',
		delay:200,
		idField:'code',
		textField:'desc',
		onBeforeLoad:function(param){
			param.kpiCode = param.q;
		},
		columns:[[
			{field:'code',title:'统计项编码',width:100},
			{field:'desc',title:'统计项名称',width:100}
		]],
		fitColumns:true,
		pagination:true,
		pageSize:15,
		pageList:[10,15,20,50,100]
	}); 
	COMBOBOX_LOAD_FLAG = 1;
}

/*--度量检索--*/
$('#searchText').searchbox({
	searcher:function(value,name){
		$("#measureGrid").propertygrid("load",{ClassName:'web.DHCWL.V1.StandCfg.MeasureCfg',QueryName:'GetMeasure',filterValue:value});
	}
})