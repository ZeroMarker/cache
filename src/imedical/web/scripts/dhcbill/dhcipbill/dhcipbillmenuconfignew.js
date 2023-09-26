/**
*Name:		./dhcbill/dhcipbill/dhcipbillmenuconfignew.js
*Creator:	hujubin
*Date:		2015-05-24
*Desc:		住院收费菜单配置
*/
var SessionObj = {
	guser : session['LOGON.USERID'],
	group : session['LOGON.GROUPID'],
	ctLoc : session['LOGON.CTLOCID'],
	hospital : session['LOGON.HOSPID']
}
var QUERY_URL = {
	QUERY_GRID_URL : "./dhcbill.query.grid.easyui.csp",
	QUERY_COMBO_URL : "./dhcbill.query.combo.easyui.csp"
};
var editingId = undefined;
var movingId = undefined;

//程序入口
jQuery(function () {
	initPageMenu();
	initData();
	initGroupList();
	initEvent();
});

function initPageMenu() {
	jQuery("#rightkeygrid,#toolkeygrid").datagrid({
		idField : 'rowId',
		singleSelect : false,
		checkOnSelect: false,
		selectOnCheck: false,
		pagination : false,
		pageNumber : 0,
		pageSize : 1,
		pageList : [10,20,30,40,50],
		columns : [[
			{ field : 'JBMCode', title : '代码', width : 160, editor:'text' }, 
			{ field : 'JBMDesc',	title : '描述', width : 200, editor:'text'}, 
			{ field : 'JBMPage', title : 'Page', hidden:"true", width : 180 }, 
			{ field : 'JBMTarget', title : 'Target', hidden:"true",  width : 180 }, 
			{ field : 'JBMParrefDr', title : 'Parref', hidden:"true", width : 80 }, 
			{ field : 'JBMActiveFlag', title : '有效标志', width : 60,
				editor:{
					type:'combobox',
					options: {
						valueField: 'value',
						textField: 'text',
						data:[
							{text:'Y',value:'Y'},
							{text:'N',value:'N'}
						]
					}
				}
			}, 
			{ field : 'JBMNo', title : '排序', width : 130, editor:'text' },
			{ field : 'JBMNodeLevel', title : 'Level',hidden:"true",  width : 40 },
			{ field : 'rowId', title : 'ID', hidden:"true", width : 80 },
			{ field : 'Select', title : 'Select', width : 160, hidden:true, editor:'text' }
			
		]],
		onBeforeLoad: function(param) {
			//目的是为了防止loadData时，设置url加载两次
			if(param.ArgCnt == undefined) {
				return false;
			}
		},
		onLoadSuccess : function (data) {
			
			
		},
		onLoadError : function () {
			jQuery.messager.alert("失败", "载入远程数据失败.");
		},
		onSelect: function(rowIndex, rowData) {
			//alert("select" + rowIndex)
		},
		onClickRow: function(rowIndex) {
			//alert("click" +rowIndex)
		},
		onRowContextMenu: function(e, rowIndex, rowData) {
			e.preventDefault();
			e.stopPropagation();
			var idList = getSelected();
			var idArray = idList.split("^");
			if(jQuery.inArray(rowData.rowId, idArray) == "-1") {
				jQuery.messager.alert("授权", "请先将该菜单授权给安全组再进行调序.");
				return;
			}
			movingId = rowData.rowId;
			jQuery('#' + this.id).datagrid({
				rowStyler: function(index,row){
					if (rowIndex == index) {
						return 'color:red;';
					}
				}
			});

		},
		onDblClickRow: function(rowIndex, rowData) {
			if(editingId != undefined) {
				jQuery.messager.alert("编辑", "有正在编辑的行且未保存,请保存后再进行操作.");
				return false;
			}
			var rowId = rowData.rowId;
			editingId = rowId;
			jQuery('#' + this.id).datagrid('beginEdit', rowIndex);	
		}
	});
	

}

function initData() {
	var group = jQuery("#group").combobox("getValue");
	initMenuData("rightkeygrid", "IPBILLRighty", group);
	initMenuData("toolkeygrid", "IPBILLTool", group);	
}

function initGroupList() {
	jQuery("#group").combobox({
		panelHeight : 180,
		panelWidth : 140,
		height : 24,
		url : QUERY_URL.QUERY_COMBO_URL,
		valueField : 'rowid',
		textField : '安全组',
		onShowPanel : function () {},
		onBeforeLoad : function (param) {
			param.ClassName = "web.DHCIPBillPatTypeSet";
			param.QueryName = "FindSSGRP";
			param.Arg1 = "";
			param.ArgCnt = 1;
		},
		onLoadError : function () {
			jQuery.messager.alert("错误", "载入安全组列表失败.");
		},
		onLoadSuccess: function() {
		},
		onSelect : function (record) {
			refresh();
		}
	});
}

function initEvent() {
	jQuery("#authorize").on("click", authorize);
	jQuery("#refresh").on("click", refresh);
}

function addTool() {
	add("toolkeygrid", "IPBILLTool");
	disElement("cancelright");
}

function addRight() {
	add("rightkeygrid", "IPBILLRighty");
	disElement("canceltool");
}

function saveTool() {
	save("toolkeygrid");
	ableElement("cancelright", cancelRight);
}

function saveRight() {
	save("rightkeygrid");
	ableElement("canceltool", cancelTool);
}

function cancelTool() {
	cancel("toolkeygrid");
	ableElement("cancelright", cancelRight);
}

function cancelRight() {
	cancel("rightkeygrid");
	ableElement("canceltool", cancelTool);
}

function cancel() {
	
}

function upTool() {
	
}

function upRight() {
	
}

function downTool() {
	
}

function downRight() {
	
} 

function add(datagridId, code) {
	jQuery("#" + datagridId).datagrid('unselectAll');
	//判断是否有正在编辑的行
	if(editingId != undefined) {
		jQuery.messager.alert("编辑", "有正在编辑的行且未保存,请保存后再进行操作.");
		return false;
	}
	editingId = undefined;
	var parrefInfo = tkMakeServerCall("web.UDHCJFBILLMENU", "GetMenuInfo", "", code);
	//alert(parrefInfo)
	var parrefArr = parrefInfo.split("^");
	if(parrefArr[0] != 0) {
		jQuery.messager.alert("编辑", "添加失败.");
		return false;	
	}
	var parref = parrefArr[1];
	var page = parrefArr[4]
	var target = parrefArr[5];
	var level = 1 + parseInt(parrefArr[8]);
	//添加可编辑行
	jQuery('#' + datagridId).datagrid('appendRow',{
		rowId: "parref" + parref,
		JBMCode: '',
		JBMDesc: '',
		ID: '',
		JBMParrefDr:parref,
		JBMPage: page,
		JBMTarget: target,
		JBMActiveFlag: "Y",
		JBMNodeLevel: level
	});
	//var editIndex = jQuery('#' + datagridId).datagrid('getRows').length-1;
	editingId = "parref" + parref;
	var editIndex = jQuery('#' + datagridId).datagrid('getRowIndex', editingId);
	jQuery('#' + datagridId).datagrid('beginEdit', editIndex);
	
}

function save(datagridId) {
	if(editingId == undefined) {
		jQuery.messager.alert("保存", "没有正在编辑的行数据.");
		return;
	}
	//alert(editingId)
	if (editingId != undefined){
		//先后台保存 三个数据，code, desc, activeFlag
		jQuery("#" + datagridId).datagrid('unselectAll');
		jQuery("#" + datagridId).datagrid('selectRecord', editingId);
		var row = jQuery("#" + datagridId).datagrid('getSelected');
		var rowIndex = jQuery("#" + datagridId).datagrid('getRowIndex', row);
		//alert(rowIndex)
		//结束编辑后才能后台更新，因为只有结束编辑才能取到修改后的值
		jQuery("#" + datagridId).datagrid('endEdit', rowIndex);
		if(row) {
			var activeFlag = row.JBMActiveFlag;
			var desc = row.JBMDesc;
			var code = row.JBMCode;
			var parref = row.JBMParrefDr;
			var nodeLevel = row.JBMNodeLevel;
			var page = row.JBMPage;
			var target = row.JBMTarget;
			var rowId = editingId;
			var setno=row.JBMNo
			//alert(activeFlag +":"+desc +":"+code+":"+parref+":"+nodeLevel+":"+target+":"+rowId);
			if($.trim(code) == "" || $.trim(desc) == "") {
				jQuery.messager.alert("保存", "Code 或 Desc 不能为空");
				jQuery("#" + datagridId).datagrid('beginEdit', rowIndex);
				return;
			} 
			var val = rowId + "^" + code + "^" + desc + "^" + activeFlag + "^" + parref + "^" + nodeLevel + "^" + page + "^" + target+"^"+setno;
			var flag = "update";
			if(rowId.indexOf("parref") >= 0) {
				flag = "insert";
			}
			var rtn = tkMakeServerCall("web.UDHCJFBILLMENU", "UpdateMenu", val, flag);
			if(rtn == 0) {
				editingId = undefined;
				jQuery.messager.alert("保存", "保存成功.");
				refresh();
			}else {
				jQuery("#" + datagridId).datagrid('beginEdit', rowIndex);
				jQuery.messager.alert("保存", "保存失败，返回值：" + rtn);
				return;
			}
		}

	}
}

function cancel(datagridId) {
	if (editingId != undefined){
	
		var rowIndex = jQuery("#" + datagridId).datagrid('getRowIndex', editingId);
		jQuery("#" + datagridId).datagrid('cancelEdit', rowIndex);
		jQuery("#" + datagridId).datagrid('endEdit', rowIndex);
		if(editingId.indexOf("parref") >= 0) {
			jQuery("#" + datagridId).datagrid('deleteRow', rowIndex);
		}
		
		
	}
	editingId = undefined;
	jQuery("#" + datagridId).datagrid('unselectAll');
}

function up() {
	
}

function down() {
	
}

function authorize() {
	var group = jQuery("#group").combobox("getValue");
	if (group == "") {
		jQuery.messager.alert("授权", "请选择安全组.");
		return false;
	}
	var menuStr = getSelected();
	if (menuStr == "") {
		jQuery.messager.alert("授权", "未选择要授权的菜单.");
		return false;
	}
	var rtn = tkMakeServerCall("web.UDHCJFBILLMENU", "grant", group, menuStr);
	if (rtn == 0) {
		jQuery.messager.alert("授权", "安全组授权成功.");
	} else {
		jQuery.messager.alert("错误", rtn + "安全组授权失败.");
	}
}

function refresh() {
	jQuery("#rightkeygrid,#toolkeygrid").datagrid("clearSelections");
	initData();
	selectAuthRow();
}

function getAuthRow() {
	var group = jQuery("#group").combobox("getValue");
	var authList = tkMakeServerCall("web.UDHCJFBILLMENU", "GetAuthList", group);

	return authList;
}

function selectAuthRow() {
	var authList = getAuthRow();
	var authArr = authList.split("^");

	var rows = jQuery('#rightkeygrid').datagrid('getRows');
	jQuery.each(rows, function (index,val) {
		var rowId = val.rowId;
		if(jQuery.inArray(rowId, authArr) != "-1") {
			jQuery("#rightkeygrid").datagrid("selectRecord", rowId);	
		}
	});	
	var rows = jQuery('#toolkeygrid').datagrid('getRows');
	jQuery.each(rows, function (index,val) {
		var rowId = val.rowId;
		if(jQuery.inArray(rowId, authArr) != "-1") {
			jQuery("#toolkeygrid").datagrid("selectRecord", rowId);	
		}
	});	
}

function getSelected() {
	var idList = "";
	
	var rows = jQuery('#rightkeygrid').datagrid('getSelections');
	for(var i=0; i<rows.length; i++){
		var rowData = rows[i];
		var rowId = rowData['rowId'];
		if(idList == "") {
			idList = rowId;
		} else {
			idList = idList + "^" + rowId;
		}
	}
	var rows = jQuery('#toolkeygrid').datagrid('getSelections');
	for(var i=0; i<rows.length; i++){
		var rowData = rows[i];
		var rowId = rowData['rowId'];
		if(idList == "") {
			idList = rowId;
		} else {
			idList = idList + "^" + rowId;
		}
	}

	
	
	return idList;
}

function initMenuData(dagagridId, code, group) {
	var queryParams = new Object();
	var ClassName = "web.UDHCJFBILLMENU";
	var QueryName = "GetMenuList";
	queryParams.ClassName = ClassName;
	queryParams.QueryName = QueryName;
	queryParams.Arg1 = code
	queryParams.Arg2 = group
	queryParams.ArgCnt = 2;
	loadDataGridStore(dagagridId, queryParams);
}

function loadDataGridStore(dagagridId, queryParams){
	var jQueryGridObj = jQuery("#" + dagagridId);
	var opts = jQueryGridObj.datagrid("options");
	
	opts.url = QUERY_URL.QUERY_GRID_URL;
	jQueryGridObj.datagrid('load', queryParams);
}

//控制按钮灰亮 14.11.12
function disElement(argName) {
	var arg = jQuery("#" + argName);
	var tagName = arg[0].tagName.toLowerCase();
	if(tagName == "a") {
		arg.css({
			color: "#C0C0C0"
		});
		jQuery("#" + argName).off("click").on("click", function() {
			return false; 
		});
		jQuery("#" + argName).removeAttr("onclick");
		jQuery("#" + argName).attr("{readOnly: true}");
	} else if(tagName == "button") {
		jQuery("#" + argName).attr("{readOnly: true}");
	} else if(tagName == "input") {
		jQuery("#" + argName).attr("{readOnly: true}");
	} else if(tagName == "select") {
		jQuery("#" + argName).attr("{readOnly: true}");
	} else if(tagName == "") {
		
	} else {
		
	}
}

//控制按钮灰亮 14.11.12
function ableElement(argName, fun) {
	var arg = jQuery("#" + argName);
	var tagName = arg[0].tagName.toLowerCase();
	if(tagName == "a") {
		arg.css({
			color: ""
		});
		if(typeof fun == "function") {
			arg.off("click").on("click", fun);
		}

		jQuery("#" + argName).removeAttr("readOnly");
	} else if(tagName == "button") {
		jQuery("#" + argName).removeAttr("readOnly");
	} else if(tagName == "input") {
		jQuery("#" + argName).removeAttr("readOnly");
	} else if(tagName == "select") {
		jQuery("#" + argName).removeAttr("readOnly");
	} else if(tagName == "") {
		
	} else {
		
	}
}