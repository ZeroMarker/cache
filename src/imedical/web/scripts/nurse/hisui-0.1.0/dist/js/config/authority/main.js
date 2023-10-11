/*
 * @Descripttion: 护理病历书写权限配置
 * @Author: yaojining
 * @Date: 2021-10-14 09:21:10
 */

var GLOBAL = {
	HospEnvironment: true,
	HospitalID: session['LOGON.HOSPID'],
	ClassName: "NurMp.Service.Template.Authority",
	ConfigTableName: "Nur_IP_AuthControl"
};
var init = function () {
	initHosp(function(){
		initRoleGrid();
		initAuthority();
	});
	initCondition();
	listenEvents();
}
$(init);

/**
* @description: 条件
*/ 
function initCondition() {
	$HUI.combogrid("#RoleDirect", {
		url: $URL,
		queryParams:{
			ClassName: "NurMp.Service.Patient.List",
			QueryName: "FindUserGroup",
			rows: 1000,
			HospitalID: GLOBAL.HospitalID, 
			TableName: "Nur_IP_AuthControl"
		},
		columns: [[
			{field:'Checkbox',title:'sel',checkbox:true},
			{field:'GroupDesc',title:'名称',width:250},
			{field:'Id',title:'ID',width:100},
		]],
		mode:'remote',
		idField: 'Id',
		textField: 'GroupDesc',
		multiple:true,
		singleSelect:false,
		fitColumns: true,
		panelWidth: 500,
		panelHeight: 420,
		delay:500,
		//pagination : true,
		enterNullValueClear:true,
		//editable:false,
		onBeforeLoad:function(param){
			var desc = "";
			if (param['q']) {
				desc=param['q'];
			}
			param = $.extend(param,{SearchDesc: desc});
			return true;
		},
	});	
}
/**
* @description: 角色
*/ 
function initRoleGrid() {
	$HUI.datagrid('#roleGrid',{
		url: $URL,
		queryParams: {
			ClassName: GLOBAL.ClassName,
			QueryName: "FindRole",
			HospitalID: GLOBAL.HospitalID,
			ConfigTableName: GLOBAL.ConfigTableName
		},
		columns: [[
			{field:'RoleName',title:'名称',width:150},
			{field:'RoleDirect',title:'指向角色',width:230},
			{field:'LimitLoc',title:'指向科室',width:80, align:'center',formatter: function(value, row, index){
				if (row.LocIds){
					return "<a style='display:block;width:65px;height:30px;' title='已限制科室，点击可查看详细' onclick='limitLoc(" + index + ")' class='icon-accept' href='#'></a>";
				} else {
					return "<a style='display:block;width:65px;height:30px;' title='未限制科室，点击可进行维护' onclick='limitLoc(" + index + ")' class='icon-forbid' href='#'></a>";
				}
			}},
			{field:'LimitModel',title:'指向模板',width:80, align:'center',formatter: function(value,row,index){
				if (row.ModelIds){
					return "<a style='display:block;width:65px;height:30px;' title='已限制模板，点击可查看详细' onclick='limitModel(" + index + ")' class='icon-accept' href='#'>&nbsp;&nbsp;&nbsp;&nbsp;</a>";
				} else {
					return "<a style='display:block;width:65px;height:30px;' title='未限制模板，点击可进行维护' onclick='limitModel(" + index + ")' class='icon-forbid' href='#'></a>";
				}
			}}
		]],
		nowrap:false,
		singleSelect: true,
		pagination: true,
		pageSize: 15,
		pageList: [15, 30, 50],
		onClickRow: function(rowIndex, rowData){
			$("#RoleName").val(rowData.RoleName);
			if (!!rowData.Custom) {
				$("#IsCustom").radio("check");
				$("#RoleCustom").val(rowData.Custom);
			} else {
				$("#IsCustom").radio("uncheck");
				$('#RoleDirect').combogrid('clear');
				initCondition();
				$("#RoleDirect").combogrid('setValues', rowData.DirectId.split("^"));
			}
			setAuthValues(rowData.Id);
   		},
	});
}
/**
 * @description: 限制科室
 * @param {String} index
 */
function limitLoc(index) {
	$("#roleGrid").datagrid("selectRow", index);
	var roleRows = $("#roleGrid").datagrid("getSelections");
	if (roleRows.length == 0) {
		return;
	}
	var locIds = roleRows[0].LocIds;
	var url = 'nur.emr.config.authority.loc.csp?HospitalID=' + GLOBAL.HospitalID + '&ConfigTableName=' + GLOBAL.ConfigTableName + '&Loc=' + locIds;
    $('#dialog-loc').dialog({  
        title: '指向科室',
        buttons:[{
			text:'保存',
			handler:function(){
				var arrNewLoc = $("#iframeAuthLoc")[0].contentWindow.GLOBAL.ArrSelLoc;
				var param = {RowID: roleRows[0].Id, ACLoc: arrNewLoc.join("^")};
				$m({
					ClassName: GLOBAL.ClassName,
					MethodName: 'save',
					Param: JSON.stringify(param)
				},function(result){
					if(result == '0'){
						$.messager.popover({msg: "保存成功！", type: "success"});
						$("#roleGrid").datagrid("reload");
						$("#dialog-loc").dialog("close");	
					}else{
						$.messager.popover({msg: result, type: "error"});		
					}
				});
			}
		},{
			text:'关闭',
			handler:function(){
				$("#dialog-loc").dialog("close");
			}
		}],
        width: 600,  
        height: 568,  
        content: "<iframe id='iframeAuthLoc' scrolling='auto' frameborder='0' src='" + buildMWTokenUrl(url) + "' style='width:100%; height:100%; display:block;'></iframe>",
    });
    $("#dialog-loc").dialog("open");
}
/**
 * @description: 限制模板
 * @param {String} index
 */
function limitModel(index) {
	$("#roleGrid").datagrid("selectRow", index);
	var roleRows = $("#roleGrid").datagrid("getSelections");
	if (roleRows.length == 0) {
		return;
	}
	var modelIds = roleRows[0].ModelIds;
	var locIds = roleRows[0].LocIds;
	var url = 'nur.emr.config.authority.model.csp?HospitalID=' + GLOBAL.HospitalID + '&ConfigTableName=' + GLOBAL.ConfigTableName + '&Model=' + modelIds + '&Loc=' + locIds;
    $('#dialog-model').dialog({  
        title: '指向模板',
        buttons:[{
			text:'保存',
			handler:function(){
				var arrNewModel = $("#iframeAuthModel")[0].contentWindow.GLOBAL.ArrSelModel;
				var param = {RowID: roleRows[0].Id, ACTemplate: arrNewModel.join("^")};
				$m({
					ClassName: GLOBAL.ClassName,
					MethodName: 'save',
					Param: JSON.stringify(param)
				},function(result){
					if(result == '0'){
						$.messager.popover({msg: "保存成功！", type: "success"});
						$("#roleGrid").datagrid("reload");
						$("#dialog-model").dialog("close");	
					}else{
						$.messager.popover({msg: result, type: "error"});		
					}
				});
			}
		},{
			text:'关闭',
			handler:function(){
				$("#dialog-model").dialog("close");
			}
		}],
        width: 600,  
        height: 568,  
        content: "<iframe id='iframeAuthModel' scrolling='auto' frameborder='0' src='" + buildMWTokenUrl(url) + "' style='width:100%; height:100%; display:block;'></iframe>",
    });
    $("#dialog-model").dialog("open");
}
/**
* @description: 权限
*/ 
function initAuthority() {
	$("#kwAuth").keywords({
		labelCls: 'blue',
		items:[
		// {
		//     text:'查看',type:"section",items:[
		//         {text:'查看病历',id:"ACView"}
		//     ]
		// },
		{
		    text:"编辑",type:'section',items:[
		        {text:'新建',id:"ACNew"},
		        {text:'修改',id:"ACModify"},
		        {text:'作废',id:'ACCancel'},
		        // {text:'撤销作废',id:'ACUnCancel'}
		    ]
		},
		// {
		//     text:"统计",type:'section',items:[
		//         {text:'24小时统计',id:"ACStat24"},
		//         {text:'日间小结',id:"ACStatDay"},
		//         {text:'按时间段统计',id:'ACStatTime'},
		//         {text:'最大值最小值统计',id:'ACStatLimit'}
		//     ]
		// },
		{
		    text:"打印",type:'section',items:[
		        // {text:'全部打印',id:"ACPrintAll"},
		        {text:'打印',id:"ACPrint"},
		        // {text:'生成图片',id:"ACPicture"}
		    ]
		}
		]
    });
}
/**
* @description: 清屏
*/ 
function clear() {
	$("#RoleName").val("");
	$HUI.radio("#IsCustom").setValue(false);
	$HUI.combogrid("#RoleDirect").setValues([]);
}
/**
* @description: 增加
*/ 
function add() {
	saveRole("");
}
/**
* @description: 保存角色
*/ 
function saveRole(id) {
	var roleName = $("#RoleName").val();
	if (!roleName) {
		$.messager.alert("简单提示", "请定义角色名称！", "info");
		return;
	}
	var isCustom = $("#IsCustom").radio("getValue");
	if (isCustom) {
		var roleCustom = $('#RoleCustom').val();
		if (!roleCustom) {
			$.messager.alert("提示", "请填写角色自定义指向的类方法！", "info");
			return;
		}
	} else {
		var roleDirect = $("#RoleDirect").combobox("getValues");
		if (roleDirect.length < 1) {
			$.messager.alert("提示", "请选择角色指向！", "info");
			return;
		}
	}
	var param = {RowID: id, ACHospDr: GLOBAL.HospitalID, ACRoleName: $("#RoleName").val(), ACGroup: $("#RoleDirect").combobox("getValues").join("^"), ACCustomRole: ""};
	if (isCustom) {
		param = {RowID: id, ACHospDr: GLOBAL.HospitalID, ACRoleName: $("#RoleName").val(), ACGroup: "", ACCustomRole: $("#RoleCustom").val()};
	}
	$m({
		ClassName: GLOBAL.ClassName,
		MethodName: 'save',
		Param: JSON.stringify(param)
	},function(result){
		if(result == '0'){
			$.messager.popover({msg: "保存成功！", type: "success"});
			$("#btnClear").click();
			$("#roleGrid").datagrid("reload");			
		}else{
			$.messager.popover({msg: result, type: "error"});		
		}
	});
}
/**
* @description: 修改
*/ 
function modify() {
	var roleRows = $("#roleGrid").datagrid("getSelections");
	if (roleRows.length == 0) {
		$.messager.alert("简单提示", "请选择一个角色！", "info");
		return;
	}
	var id = roleRows[0].Id;
	saveRole(id);
}
/**
* @description: 删除
*/ 
function remove() {
	var roleRows = $("#roleGrid").datagrid("getSelections");
	if (roleRows.length == 0) {
		$.messager.alert("简单提示", "请选择一个角色！", "info");
		return;
	}
	$.messager.confirm("警告", "确定要删除吗？", function (r) {
		if (r) {
			$m({
				ClassName: GLOBAL.ClassName,
				MethodName: 'delete',
				Id:  roleRows[0].Id
			},function(result){
				if(result == '0'){
					$.messager.popover({msg: "删除成功！", type: "success"});
					$("#btnClear").click();
					$("#roleGrid").datagrid("reload");
					setAuthValues("");		
				}else{
					$.messager.popover({msg: result, type: "error"});		
				}
			});
		} else {
			return;
		}
	});
}
/**
* @description: 保存权限
*/ 
function saveAuth() {
	var roleRows = $("#roleGrid").datagrid("getSelections");
	if (roleRows.length == 0) {
		$.messager.alert("简单提示", "请选择一个角色！", "info");
		return;
	}
	var param = {
		RowID: roleRows[0].Id,
		ACView: "N",
		ACNew: "N",
		ACModify: "N",
		ACCancel: "N",
		ACUnCancel: "N",
		ACStat24: "N",
		ACStatDay: "N",
		ACStatTime: "N",
		ACStatLimit: "N",
		ACPrintAll: "N",
		ACPrint: "N",
		ACPicture: "N"
	};
	var kwAuths = $("#kwAuth").keywords('getSelected');
	$.each(kwAuths, function(index, kwAuth) {
		param[kwAuth.id] = "Y";
	});
	$m({
		ClassName: GLOBAL.ClassName,
		MethodName: 'save',
		Param: JSON.stringify(param)
	},function(result){
		if(result == '0'){
			$.messager.popover({msg: "保存成功！", type: "success"});
			// $("#roleGrid").datagrid("reload");			
		}else{
			$.messager.popover({msg: result, type: "error"});		
		}
	});
}
/**
 * @description: 默认权限配置
 * @param {String} roleId
 */
function setAuthValues(roleId) {
	$("#kwAuth").keywords("clearAllSelected");
	$cm({
		ClassName: GLOBAL.ClassName,
		MethodName: "getAuth",
		RoleId: roleId
	}, function(words) {
		$.each(words, function(index, word) {
			if (word.value == "Y") {
				$("#kwAuth").keywords("select", word.id);
			}
		});
	});
	
}
/**
* @description: 监听事件
*/ 
function listenEvents() {
	$HUI.radio("[name='IsCustom']",{
        onCheckChange:function(e,value){
        	if (value) {
				$("#LabelDirect").hide();
				$("#divRoleDirect").hide();
	        	$("#LabelCustom").show();
				$("#RoleCustom").show();
        	}else{
				$("#LabelCustom").hide();
				$("#RoleCustom").hide();
	        	$("#LabelDirect").show();
				$("#divRoleDirect").show();
				$("#RoleCustom").val("");
        	}
        }
    });
    $("#btnClear").bind("click", clear);
    $("#btnAdd").bind("click", add);
    $("#btnModify").bind("click", modify);
    $("#btnDelete").bind("click", remove);
    $("#btnSave").bind("click", saveAuth);	    
}