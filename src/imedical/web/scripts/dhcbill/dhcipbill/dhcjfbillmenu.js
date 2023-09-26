//dhcjfbillmenu.js
//add hujunbin 14.6.18
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
var MenuObj = {
	rowId : "",
	code : "",
	parentId : "",
	nodeLevel : "",
	initMenuVal : function(rowData) {
		this.code = rowData.JBMCode;
		this.rowId = rowData.JBMDesc;
		this.parentId = rowData.JBMParrefDr;
		this.nodeLevel = rowData.JBMNodeLevel;
	},
	clearMenuVal : function() {
		this.code = "";
		this.rowId = "";
		this.parentId = "";
		this.nodeLevel = "";
	}
}
var editingId;
jQuery(function () {
	initPageMenu();
	initGroupList();
	initEvent();
});
function log(obj) {
	//console.log(obj);
}
function initPageMenu() {
	jQuery("#accordion").accordion({
		onSelect: function(title, index) {
			var titleArr = title.split(":");
			var desc = titleArr[0];
			var code = titleArr[1];
			initChild(code);
			initTreeGrid(code);
		},
		onUnselect: function(title, index) {
			showAllPage();
		}
	});
	initSelectAccordion();
}

function initSelectAccordion() {
	getChecked()
	var p = $('#accordion').accordion('getSelected');
	if (p){
		var index = $('#accordion').accordion('getPanelIndex', p);
		//log(p[0].id)
		var code = p[0].id;
		initChild(code);
		initTreeGrid(code);
	}
}

function initChild(code) {
	var innerHtml = "";
	var menuJson = tkMakeServerCall("web.UDHCJFBILLMENU", "GetTargetsByPage", code, 2);
	menuJson = $.parseJSON(menuJson);
	for(var o in menuJson) {
		var menu = menuJson[o];
		var menuCode = menu.JBMCode;
		var menuDesc = menu.JBMDesc;
		var html = '<li id="' + menuCode +'" style="cursor:pointer;font-size:14px;padding:4px;" onclick="initTreeGrid(\'' + menuCode + '\')">' + menuDesc + ":" + menuCode + '</li>'	
		if(innerHtml == "") {
			innerHtml = html;
		} else {
			innerHtml = innerHtml + html	
		}
	}
	jQuery("#" + code).html(innerHtml);
}
function initTreeGrid(code) {
	//获取授权选择的安全组
	var group = jQuery("#group").combobox("getValue");
	var rtnJson = tkMakeServerCall("web.UDHCJFBILLMENU", "GetMenus", code, group);
	var menuJson = $.parseJSON(rtnJson);
	createTreeGrid(menuJson);
	getChecked();
}
function initTreeGridByGrp(code, grp) {
	var rtnJson = tkMakeServerCall("web.UDHCJFBILLMENU", "GetMenus", code, grp);
	var menuJson = $.parseJSON(rtnJson);
	createTreeGrid(menuJson);
}
function showAllPage() {
	var rtnJson = tkMakeServerCall("web.UDHCJFBILLMENU", "GetPageMenus", 1);
	var menuJson = $.parseJSON(rtnJson);
	createTreeGrid(menuJson);
}
function createTreeGrid(menuJson) {
	editingId = undefined;
	jQuery("#menuConfig").treegrid({
		data:menuJson,
		method : 'get',
		idField : 'rowId',
		treeField : 'JBMDesc',
		singleSelect : false,
		checkOnSelect: true,
		selectOnCheck: true,
		//pagination : true,
		pageNumber : 0,
		pageSize : 1,
		pageList : [10,20,30,40,50],
		columns : [[
			{ field : 'JBMDesc',	title : 'Desc', width : 280, editor:'text'}, 
			{ field : 'ck', title : 'ck', checkbox : true, width : 40 ,
				formatter: function (value, row, index) {
					if(value == "true" || value == "checked") {
						jQuery("#menuConfig").treegrid("cascadeCheck",{
							id:row.rowId, //节点ID  
							deepCascade:false //深度级联false 
						});
						return true;	
					} else {
						return false;
					}
				}
			}, 
			{ field : 'JBMCode', title : 'Code', width : 180, editor:'text' }, 
			{ field : 'JBMPage', title : 'Page', width : 180 }, 
			{ field : 'JBMTarget', title : 'Target', width : 180 }, 
			{ field : 'JBMParrefDr', title : 'Parref', width : 80 }, 
			{ field : 'JBMActiveFlag', title : 'ActiveFlag', width : 40,
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
			{ field : 'JBMNodeLevel', title : 'Level', width : 40 },
			{ field : 'rowId', title : 'ID', width : 80 } 
		]],
		onLoadSuccess : function (row, data) {
			//如果是checked的，让其处于选中状态的，
			log(data)
		},
		onLoadError : function () {
			jQuery.messager.alert("失败", "载入远程数据失败.");
		},
		onClickRow: function(rowData) {
			//jQuery.cachedScript('../scripts/dhcipbill/dhcipbillcharge/jquery.easyui.treegrid.extend.js').done(function(){ 
				jQuery("#menuConfig").treegrid('cascadeCheck',{  
					id:rowData.rowId, //节点ID  
					deepCascade:true //深度级联  
				}); 
			//});
		},
		onContextMenu: function(e, rowData) {
			jQuery("#menuConfig").treegrid("checkOnlySelf",rowData.rowId);
			createRightyKey(e,rowData); //14.9.1
		}
	});
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
		onSelect : function (record) {}
	});
}

function initEvent() {
	jQuery("#authorize").on("click", authorizeClick);
	jQuery("#refresh").on("click", initSelectAccordion);
	jQuery("#group").combobox({
		onSelect: function(record) {
			var grp = record.rowid;
			var p = $('#accordion').accordion('getSelected');
			if (p){
				var index = $('#accordion').accordion('getPanelIndex', p);
				var code = p[0].id;
				initTreeGridByGrp(code, grp);
			}
		}
	});
}
function authorizeClick() {
	var group = jQuery("#group").combobox("getValue");
	if (group == "") {
		jQuery.messager.alert("授权", "请选择安全组.");
		return;
	}
	var p = $('#accordion').accordion('getSelected');
	//如果左侧没有选择，说明右侧显示的是界面,如果是界面不能授权
	if(!p) {
		jQuery.messager.alert("授权", "界面按钮不能授权.");
		return;
	}
	var menuStr = "";
	var menuStr = getChecked();
	/*
	var menuSel = jQuery('#menuConfig').treegrid("getChecked");
	log(menuSel)
	jQuery.each(menuSel, function (index, value) {
		var menuObj = menuSel[index];
		if (menuStr == "") {
			menuStr = menuObj.rowId;
		} else {
			menuStr = menuStr + "^" + menuObj.rowId;
		}
	});
	*/
	if (menuStr == "") {
		jQuery.messager.alert("授权", "未选择要授权的菜单.");
		return;
	}
	var rtn = tkMakeServerCall("web.UDHCJFBILLMENU", "grant", group, menuStr);
	if (rtn == 0) {
		jQuery.messager.alert("授权", "安全组授权成功.");
	} else {
		jQuery.messager.alert("错误", rtn + "安全组授权失败.");
	}
}

function addMenu() {
	//判断是否有正在编辑的行
	if(editingId != undefined) {
		jQuery.messager.alert("编辑", "有正在编辑的行且未保存,请保存后再进行操作.");
		return;
	}
	//如果左侧没有选择，说明要添加的是页面
	//如果左侧选择了，则必须在右侧选择一个父Id进行增加
	var p = $('#accordion').accordion('getSelected');
	var parref = "", page = "", target = "", level = 1;
	if(p) {
		if(!selectOnlyOne()) {
			jQuery.messager.alert("编辑", "请只选择一个父ID进行添加.");
			return;
		}
		
		var row = $('#menuConfig').treegrid('getSelected');
		if(row) {
			var index = $('#menuConfig').treegrid('getRowIndex', row);
			var addIndex = index + 1;
			parref = row.rowId;
			page = row.JBMPage;
			target = row.JBMTarget;
			level = row.JBMNodeLevel;
			level = parseInt(level) + 1;
		}
	}
	//添加可编辑行
	$('#menuConfig').treegrid('append',{
		parent: parref,
		data: [
			{
				rowId: "parref" + parref,
				JBMCode: '',
				JBMDesc: '',
				ID: '',
				JBMParrefDr:parref,
				JBMPage: page,
				JBMTarget: target,
				JBMActiveFlag: "Y",
				JBMNodeLevel: level
			}
		]
	});
	$('#menuConfig').treegrid('beginEdit', "parref" + parref);
	editingId = "parref" + parref;
}

function saveMenu() {
	if(editingId == undefined) {
		jQuery.messager.alert("保存", "没有正在编辑的行数据.");
		return;
	}
	if (editingId != undefined){
		//先后台保存 三个数据，code, desc, activeFlag
		$('#menuConfig').treegrid('unselectAll');
		$('#menuConfig').treegrid('select', editingId);
		var row = $('#menuConfig').treegrid('getSelected');
		//结束编辑后才能后台更新，因为只有结束编辑才能取到修改后的值
		$('#menuConfig').treegrid('endEdit', editingId);
		if(row) {
			var activeFlag = row.JBMActiveFlag;
			var desc = row.JBMDesc;
			var code = row.JBMCode;
			var parref = row.JBMParrefDr;
			var nodeLevel = row.JBMNodeLevel;
			var page = row.JBMPage;
			var target = row.JBMTarget;
			var rowId = editingId;
			if($.trim(code) == "" || $.trim(desc) == "") {
				jQuery.messager.alert("保存", "Code 或 Desc 不能为空");
				$('#menuConfig').treegrid('beginEdit', editingId);
				return;
			} 
			var val = rowId + "^" + code + "^" + desc + "^" + activeFlag + "^" + parref + "^" + nodeLevel + "^" + page + "^" + target;
			var flag = "update";
			if(rowId.indexOf("parref") >= 0) {
				flag = "insert";
			}
			var rtn = tkMakeServerCall("web.UDHCJFBILLMENU", "UpdateMenu", val, flag);
			if(rtn == 0) {
				editingId = undefined;
				jQuery.messager.alert("保存", "保存成功.");
				var p = $('#accordion').accordion('getSelected');
				if(flag == "insert" && p) {
					//重新加载列表，更新新插入的ID,rowId
					initSelectAccordion();
				} else if(flag == "insert" && !p) {
					showAllPage();
				}
			}else {
				$('#menuConfig').treegrid('beginEdit', editingId);
				jQuery.messager.alert("保存", "保存失败，返回值：" + rtn);
				return;
			}
		}

	}
}

function editMenu() {
	//判断编辑只能编辑一行
	if(!selectOnlyOne()) {
		jQuery.messager.alert("编辑", "请选择一行进行编辑.");
		return;
	}
	var thisEditId;
	var thisRow = $('#menuConfig').treegrid('getSelected');
	if(thisRow) {
		thisEditId = thisRow.rowId;
	}
	if (editingId != undefined && thisEditId != editingId){
		jQuery.messager.alert("编辑", "有正在编辑的行且未保存,请保存后操作其他行.");
		$('#menuConfig').treegrid('unselectAll');
		$('#menuConfig').treegrid('select', editingId);
		return;
	}
	
	var row = $('#menuConfig').treegrid('getSelected');
	if (row){
		editingId = row.rowId;
		$('#menuConfig').treegrid('beginEdit', editingId);
	}
}

function cancelEdit() {
	if (editingId != undefined){
		$('#menuConfig').treegrid('cancelEdit', editingId);
		editingId = undefined;
	}
}

function deleteMenu() {
	if(!selectOnlyOne()) {
		jQuery.messager.alert("编辑", "请选择一行进行删除.");
		return;
	}
	
	var thisRow = $('#menuConfig').treegrid('getSelected');
	if(thisRow) {
		delMenu(thisRow.rowId);
	}else {
		jQuery.messager.alert("编辑", "不存在要删除的行数据.");
	}
}

function delMenu(rowId) {
	//获取父节点,刷新用
	var rtn = tkMakeServerCall("web.UDHCJFBILLMENU", "hasChild", rowId); //后台判断
	if(rtn == "Y") {
		jQuery.messager.confirm("确认", "此菜单存在子菜单是否确认全部删除", function(r) {
			if(r) {
				var delRtn = tkMakeServerCall("web.UDHCJFBILLMENU", "DelMenu", rowId);
				if(delRtn == 0) {
					jQuery.messager.alert("删除", "删除成功.");
					jQuery("#menuConfig").treegrid("remove", rowId);
					return;
				}
			}else {
				return;
			}
		});
	}else {
		jQuery.messager.confirm("确认", "确认要删除该菜单", function(r) {
			if(r) {
				var delRtn = tkMakeServerCall("web.UDHCJFBILLMENU", "DelMenu", rowId);
				if(delRtn == 0) {
					jQuery.messager.alert("删除", "删除成功.");
					jQuery("#menuConfig").treegrid("remove", rowId);
					return;
				}else {
					jQuery.messager.alert("删除", "删除失败,返回值：" + rtn);
				}
			}else {
				return;
			}
		});
	}
}

function selectOnlyOne() {
	var selectedRow = jQuery("#menuConfig").treegrid("getSelections");
	var selectNum = 0;
	jQuery.each(selectedRow, function(index, value) {
		selectNum = selectNum + 1;
	});
	if(selectNum == 1) {
		return true;
	} else {
		return false;
	}
}

function createRightyKey(event,rowData) {
	var opts = jQuery("#menuConfig").treegrid("options");
	var idField = opts.idField;
	var rowId = rowData[idField];
	var menuBtnArr = [
		{id: "1", code: "addRighty", desc: "添加", iconCls: 'icon-add'},
		{id: "3", code: "saveRighty", desc: "保存", iconCls: 'icon-save'},
		{id: "2", code: "deleteRighty", desc: "删除", iconCls: 'icon-cancel'},
		{id: "3", code: "editRighty", desc: "编辑", iconCls: 'icon-edit'},
		{id: "3", code: "cancelEditRighty", desc: "取消编辑"}
	];
	event.preventDefault();
	event.stopPropagation();
	var target = "rightyKey";
	var $target = jQuery('#' + target);
	if (!$target.length) {
		$target = jQuery('<div id=\"' + target + '\"></div>').appendTo(document.body);
	}else {
		$target.empty(); //防止事件的循环
	}
	$target.menu();
	jQuery.each(menuBtnArr, function (index, value) {
		var menu = menuBtnArr[index];
		$target.menu('appendItem', {
			id : menu.code,
			text : menu.desc,
			iconCls: menu.iconCls
		});
	});

	$target.menu('show', {
		left : event.pageX,
		top : event.pageY
	});
	jQuery("#addRighty").off().on("click", function() {
		addMenu();
	});
	jQuery("#saveRighty").off().on("click", function() {
		saveMenu();
	});
	jQuery("#deleteRighty").off().on("click", function() {
		deleteMenu();
	});
	jQuery("#editRighty").off().on("click", function() {
		editMenu();
	});
	jQuery("#cancelEditRighty").off().on("click", function() {
		cancelEdit();
	});
}

function getChecked() {
	var idList = "";  
	jQuery("[name='ck']").each(function(i,val){
		var thisCheck = jQuery("[name='ck']").get(i);
		if(thisCheck.checked) {
			var thisRowId = jQuery("[field='rowId'] .datagrid-cell").get(i+1).innerText;
			//console.log(thisRowId);
			//var id = thisCol.attr("rowId");
			if(idList == "") {
				idList = thisRowId;
			} else {
				idList = idList + "^" + thisRowId;
			}
		}
	});
	
	return idList;
}



















