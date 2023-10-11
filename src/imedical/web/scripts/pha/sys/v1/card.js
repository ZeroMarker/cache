/**
 * 名称:	 药房药库-药学首页-卡片维护
 * 编写人:	 Huxt
 * 编写日期: 2020-04-13
 * csp:  	 pha.sys.v1.card.csp
 * js:		 pha/sys/v1/card.js
 */
PHA_COM.App.Csp = "pha.sys.v1.card.csp"
PHA_COM.App.CspDesc = "卡片维护"
PHA_COM.App.ProDesc = "公共业务"
PHA_COM.Temp = {}
PHA_COM.Temp.SelectedIndex = null;
PHA_COM.Temp.PICI = '';
PHA_COM.Temp.PageSize = 100;

$(function() {
	// 重置标题
	var t1 = $g('数据浏览');
	var cardItmPanel = $("#panel-cardItm").panel('options');
	var cardItmTitle = cardItmPanel.title;
	$("#panel-cardItm").panel('setTitle', cardItmTitle + ' - ' + t1);
	
	// 初始化
	InitFormData();
	InitGridCard();
	ShowCardContentGrids();

	// 事件
	$("#btnAdd").on('click', Add);
	$("#btnEdit").on('click', Add);
	$("#btnDel").on('click', Delete);
	$('#btnExport').on('click', ExportTxt);
	$('#btnImport').on('click', ImportTxt);
	
	// 改变顺序
	$(document).keydown(function(e){
		if(event.keyCode == 38){
			RowUpAndDown(true);
		}
		if(event.keyCode == 40){
			RowUpAndDown(false);
		}
	});
});

// 表单元素
function InitFormData() {
}

// 卡片列表
function InitGridCard() {
	var columns = [[
    	{ field: "pic", title: 'pic', width: 80, hidden:true},
		{ field: "picCode", title: '卡片代码', width: 100},
		{ field: 'picDesc', title: '卡片名称', width: 130},
		{ field: 'picActiveFlag', title: '是否可用', width: 70, align: 'center', formatter: PHA.CheckBoxFormatter}
    ]];
    var dataGridOption = {
        url: $URL,
		queryParams: {
			ClassName: 'PHA.SYS.Card.Query',
			QueryName: 'PHAINCard'
		},
        fitColumns: true,
        border: false,
        rownumbers: true,
        columns: columns,
        pagination: true,
        pageSize: PHA_COM.Temp.PageSize,
        singleSelect: true,
        toolbar: '#gridCardBar',
        onLoadSuccess: function(data) {
	        if (PHA_COM.Temp.SelectedIndex == null && data.total > 0) {
		        $('#gridCard').datagrid('selectRow', 0);
		        PHA_COM.Temp.SelectedIndex = 0;
		    } else {
			    if(PHA_COM.Temp.SelectedIndex && PHA_COM.Temp.SelectedIndex >= 0) {
				    $('#gridCard').datagrid('selectRow', PHA_COM.Temp.SelectedIndex);
				}
			}
	    },
        onSelect: function(rowIndex, rowData) {
	        PHA_COM.Temp.SelectedIndex = rowIndex;
	        PHA_COM.Temp.PICI = '';
	        QueryItm();
	        if (CardPreview('cardContentPreview', 'isHide') == false) {
		        ShowCardPreview();
		    }
	    },
        onDblClickRow: function(rowIndex, rowData){
	        PHA_COM.Temp.SelectedIndex = rowIndex;
	        PHA_COM.Temp.PICI = '';
	        Add({currentTarget:{id:'btnEdit'}});
		}
    };
    PHA.Grid("gridCard", dataGridOption);
}

// 初始化卡片内容表格
function ShowCardContentGrids() {
	if ($("#cardContentGrids").length > 0) {
		$("#cardContentGrids").show();
		var $CHL = $("#cardContentGrids").children().eq(0);
		if ($CHL.length > 0) {
			$("#cardContentGrids").children().eq(1).css('top', $CHL[0].offsetHeight - 1);
		}
		return;
	}
	
	// 动态生成HTML
	var panelCardItmHeight = $("#panel-cardItm").css('height');
	var northHeight = parseInt(parseInt(panelCardItmHeight) * 0.55);
	var htmlStr = '';
	htmlStr += '<div id="cardContentGrids" class="hisui-layout" fit="true">';
	htmlStr += '<div data-options="region:\'north\',border:false,split:true,height:' + northHeight + '">';
	htmlStr += '<div id="gridCardItm">';
	htmlStr += '</div>';
	htmlStr += '</div>';
	htmlStr += '<div data-options="region:\'center\',border:false,split:true">';
	htmlStr += '<div id="gridCardItmSet">';
	htmlStr += '</div>';
	htmlStr += '</div>';
	htmlStr += '</div>';
	$("#panel-cardItm").append(htmlStr);
	$.parser.parse($("#panel-cardItm"));
	
	var gridCardItmBar = '';
	gridCardItmBar += '<div id="gridCardItmBar">';
	gridCardItmBar += '<a class="hisui-linkbutton" plain=\'true\' iconCls="icon-add" id="btnAddItm">' + $g('新增') + '</a>';
	gridCardItmBar += '<a class="hisui-linkbutton" plain=\'true\' iconCls="icon-write-order" id="btnEditItm">' + $g('修改') + '</a>';
	gridCardItmBar += '<a class="hisui-linkbutton" plain=\'true\' iconCls="icon-cancel" id="btnDelItm">' + $g('删除') + '</a>';
	gridCardItmBar += '</div>';
	$(gridCardItmBar).appendTo('body');
	$.parser.parse($("#gridCardItmBar"));
	
	var gridCardItmBarSet = '<div id="gridCardItmSetBar" style="border-top:0px solid #d1d6da">' + '</div>';
	$(gridCardItmBarSet).appendTo('body');
	$.parser.parse($("#gridCardItmBarSet"));
	
	// 初始化
	InitGridCardItm();
	InitGridCardItmSet();
	
	// 边框
	$("#gridCardItmBar").parent().parent().parent().css('border-bottom', '1px solid #d1d6da');
	$("#gridCardItmSetBar").parent().parent().parent().css('border-top', '1px solid #d1d6da');
	
	// 绑定事件
	$("#btnAddItm").on('click', AddItm);
	$("#btnEditItm").on('click', EditItm);
	$("#btnDelItm").on('click', DeleteItm);
}
function HideCardContentGrids(){
	if ($("#cardContentGrids").length > 0) {
		$("#cardContentGrids").hide();
	}
}

// 内容表格
function InitGridCardItm() {
	var columns = [[
    	{ field: "pic", title: 'pic', width: 80, hidden:true},
    	{ field: "pici", title: 'pici', width: 80, hidden:true},
    	{ field: "picc", title: 'picc', width: 80, hidden:true},
		{ field: "piccCode", title: '内容类型代码', width: 80, hidden:true},
		{ field: 'piccDesc', title: '内容类型', width: 110},
		{ field: "piciCode", title: '内容代码', width: 100},
		{ field: 'piciDesc', title: '内容名称', width: 120},
		{ field: 'piciRowIndex', title: '行号', width: 80, align: 'center'},
		{ field: 'piciColIndex', title: '列号', width: 80, align: 'center'},
		{ field: 'piciSortNum', title: '内容序号', width: 80, align: 'center'},
		{ field: 'piccFormFlag', title: '表单', width: 35, align: 'center', formatter: PHA.CheckBoxFormatter},
		{ field: 'piciActiveFlag', title: '可用', width: 35, align: 'center', formatter: PHA.CheckBoxFormatter}
    ]];
    var dataGridOption = {
        url: $URL,
		queryParams: {
			ClassName: 'PHA.SYS.Card.Query',
			QueryName: 'PHAINCardItm'
		},
        fitColumns: true,
        border: false,
        rownumbers: true,
        columns: columns,
        pagination: true,
        pageSize: PHA_COM.Temp.PageSize,
        singleSelect: true,
        toolbar: '#gridCardItmBar',
        onLoadSuccess: function(data) {
	        if (data.total > 0) {
		        if (PHA_COM.Temp.PICI != "") {
			        var rowsData = $('#gridCardItm').datagrid('getRows');
			        var rowsLen = rowsData.length;
			        for (var i = rowsLen - 1; i >= 0; i--) {
				        if (rowsData[i].pici == PHA_COM.Temp.PICI) {
					        $('#gridCardItm').datagrid('selectRow', i);
					        break;
					    }
				    }
			    } else {
				    $('#gridCardItm').datagrid('selectRow', 0);
				}
	        } else {
		        QueryItmSet(); // 清空孙表
		    }
	    },
	    onSelect: function(rowIndex, rowData) {
		    PHA_COM.Temp.PICI = rowData.pici;
	        QueryItmSet();
	    },
        onDblClickRow: function(rowIndex, rowData){
	        PHA_COM.Temp.PICI = rowData.pici;
			var picc = rowData.picc || "";
			if (picc == "") {
				return;
			}
			OpenCardContentWin({
				picc: picc,
				isAdd: false
			});
		},
		onBeforeLoad: function (param) {
			var firstLoad = $(this).attr("firstLoad");
			if (firstLoad == "false" || typeof (firstLoad) == "undefined") {
			$(this).attr("firstLoad", "true");
				return false;
			}
			return true;
		}
    };
    PHA.Grid("gridCardItm", dataGridOption);
}
// 内容属性表格
function InitGridCardItmSet() {
	var columns = [[
    	{ field: "pici", title: 'pici', width: 80, hidden:true},
    	{ field: "picis", title: 'picis', width: 80, hidden:true},
		{ field: "picci", title: 'picci', width: 80, hidden:true},
		{ field: "picciCode", title: '属性代码', width: 100},
		{ field: "picciDesc", title: '属性名称', width: 100},
		{ field: 'picisValue', title: '属性值', width: 100,
			formatter: function(value, rowData, rowIndex) {
				if (rowData.picciCode == 'columns') {
					if (value == "") {
						return "<a style='border:0px;cursor:pointer' onclick='ColumnsSet();'>点击维护</a>"
					}
					return "<a style='border:0px;cursor:pointer' onclick='ColumnsSet();'>" + value + "</a>"
				} else {
					return value;
				}
			}
		}
    ]];
    var dataGridOption = {
        url: $URL,
		queryParams: {
			ClassName: 'PHA.SYS.Card.Query',
			QueryName: 'PHAINCardItmSet'
		},
        fitColumns: true,
        border: false,
        rownumbers: true,
        columns: columns,
        pagination: true,
        pageSize: PHA_COM.Temp.PageSize,
        singleSelect: true,
        toolbar: '#gridCardItmSetBar',
        onSelect: function(rowIndex, rowData) {},
        onLoadSuccess: function(data) {},
        onClickCell: function(rowIndex, field, value){
	        return;
	        if (field == 'picisValue') {
		        var rowsData = $("#gridCardItmSet").datagrid("getRows");
				var rowData = rowsData[rowIndex];
				if (rowData.picciCode == "columns") {
					alert(rowData.picciCode);
				}
			}
	    }
    };
    PHA.Grid("gridCardItmSet", dataGridOption);
}

// 预览界面
function ShowCardPreview() {
	var renderToId = "panel-cardItm";
	var _options = {}
	_options.renderToId = renderToId;
	_options.authStr = PHA_HOMEPAGE.AuthStr;
	_options.picCode = ($('#gridCard').datagrid('getSelected') || {}).picCode || "";
	CardPreview('cardContentPreview', _options);
}

function HideCardPreview(){
	CardPreview('cardContentPreview', 'hide');
}

// 该方法在csp中绑定
function Transfer(){
	var cardItmPanel = $("#panel-cardItm").panel('options');
	var title = cardItmPanel.title;
	var titleArr = title.split(' - ');
	var t1 = $g('数据浏览');
	var t2 = $g('图形预览');
	if (title.indexOf(t1) >= 0) {
		var authStrDesc = tkMakeServerCall('PHA.SYS.Card.Query', 'GetAuthStrDesc', PHA_COM.Session.ALL);
		$("#panel-cardItm").panel('setTitle', titleArr[0] + ' - ' + t2 + ' [ <label style="color:gray;">' + authStrDesc + '</label> ]');
		HideCardContentGrids();
		ShowCardPreview();
	} else {
		$("#panel-cardItm").panel('setTitle', titleArr[0] + ' - ' + t1);
		HideCardPreview();
		ShowCardContentGrids();
		QueryItm();
	}
}

/*
* @description: 卡片主表增删改查询
*/
function Query() {
	$('#gridCard').datagrid('reload');
}
function Add(btnOpt) {
	var inputStr = "";
	var isAdd = (btnOpt.currentTarget.id).indexOf("Add") >= 0 ? true : false;
	OpenCardWin({
		isAdd: isAdd
	});
}
function OpenCardWin(opt){
	var authDataStr = 0 + "^" + "A" + "^" + 0;
	var title = "修改卡片";
	var iconCls = "icon-w-edit";
	var selectedRow = $("#gridCard").datagrid('getSelected');
	var pic = selectedRow == null ? "" : (selectedRow.pic || "");
	if (pic == "" && opt.isAdd == false) {
		PHA.Popover({
			msg: "请选择需要修改的卡片!",
			type: "alert"
		});
		return;
	}
	if (opt.isAdd == true) {
		title = "新增卡片";
		iconCls = "icon-w-add";
		pic = "";
	}
	
	PHA_COM.ComAttr.Win({
		forceReload: true, // 每次重新加载
		winOptions: {
			id: 'dialogCardMaintain',
			width: 420,
	    	height: 480,
	    	modal: true,
	    	title: $g(title),
	    	iconCls: iconCls,
	    	closable: true,
	    	onClickSave: function(formData){
		    	Save({
			    	saveData: formData,
			    	isAdd: opt.isAdd
			    });
		    }
		},
		cards: [
			{
				id: 'cardBaseAttr',
				title: $g('卡片基本属性'),
				ClassName: 'PHA.SYS.Card.FormHtml',
				MethodName: 'GetCardBaseForm'
			}, {
				id: 'cardAttr',
				title: $g('卡片附加属性'),
				ClassName: 'PHA.SYS.Card.FormHtml',
				MethodName: 'GetCardOptForm',
				picaParCode: 'cardAttr'
			}
		],
		dataOptions: {
			ClassName: 'PHA.SYS.Card.Query',
			MethodName: 'GetCardFormData',
			pic: pic,
			authDataStr: authDataStr
		}
	});
}
function Save(opt) {
	var saveData = opt.saveData || [];
	if (saveData.length == 0) {
		return;
	}
	var jsonDataStr = JSON.stringify(saveData[0]);
	
	var authDataStr = 0 + "^" + "A" + "^" + 0;
	var selectedRow = $("#gridCard").datagrid('getSelected');
	var pic = selectedRow == null ? "" : (selectedRow.pic || "");
	if (pic == "" && opt.isAdd == false) {
		PHA.Popover({
			msg: "请选择需要修改的卡片!",
			type: "alert"
		});
		return;
	}
	if (opt.isAdd == true) {
		pic = "";
	}
	
	// 注: 使用$.cm({})方法关键字:function/object/link无法传到后台
	var retStr = tkMakeServerCall('PHA.SYS.Card.Save', 'SaveCard', pic, jsonDataStr, authDataStr);
	PHA.AfterRunServer(retStr, function(){
		Query();
		$('#dialogCardMaintain').dialog('close');
	});
}
function Delete(){
	var selectedRow = $('#gridCard').datagrid('getSelected');
	if (selectedRow == null) {
		PHA.Popover({
			msg: "请选择需要删除的数据!",
			type: "alert"
		});
		return;
	}
	var pic = selectedRow.pic || "";
	PHA.Confirm("温馨提示", "是否确认删除？", function () {
		if (pic == "") {
			var rowIndex = $("#gridCard").datagrid('getRowIndex', selectedRow);
			$("#gridCard").datagrid('deleteRow', rowIndex);
			return;
		}
		var retStr = $.cm({
			ClassName: 'PHA.SYS.Card.Save',
			MethodName: 'DeleteCard',
			ID: pic,
			dataType: 'text'
		}, false);
		PHA.AfterRunServer(retStr, Query);
	});
}


/*
* @description: 卡片子/孙表增删改查询
*/
// 查询
function QueryItm(){
	var selectedRow = $("#gridCard").datagrid('getSelected');
	var pic = selectedRow == null ? "" : (selectedRow.pic || "");
	$("#gridCardItm").datagrid('query',{
		inputStr: pic
	});
}
// 修改
function EditItm(){
	var selectedRow = $("#gridCardItm").datagrid('getSelected');
	var picc = selectedRow == null ? "" : (selectedRow.picc || "");
	OpenCardContentWin({
		picc: picc,
		isAdd: false
	});
}
// 新增 - 创建一个弹窗
function AddItm(){
	var selectedRow = $('#gridCard').datagrid('getSelected');
	var pic = selectedRow == null ? "" : (selectedRow.pic || "");
	if (pic == "") {
		PHA.Popover({
			msg: "请先选择卡片!",
			type: "alert"
		});
		return;
	}
	
	var _winId = "dialogSelectContent";
	if ($("#" + _winId).length == 0) {
		var contentHtml = '';
		contentHtml += '<div class="pha-container" style="padding-left: 20px; padding-top: 20px;">';
        contentHtml += '<div class="pha-row">';
        contentHtml += '<div class="pha-col">';
        contentHtml += '<input id="comb-CardContent" class=\'hisui-combobox\' data-pha="class:\'hisui-combobox\',requied:true">';
        contentHtml += '</div>';
        contentHtml += '</div>';
        contentHtml += '</div>';
        
		$('<div id="' + _winId + '"><div>').appendTo('body');
		$('#' + _winId).dialog({
			width: 260,
	    	height: 180,
	    	modal: true,
	    	iconCls: 'icon-w-edit',
	    	title: $g('选择卡片内容类型'),
	    	closable: true,
	    	content: contentHtml,
	    	buttons : [{
				text: '确认',
				handler: function(){
					OnSureSelectContent(_winId);
				}
			}, {
				text: '取消',
				handler: function(){
					$('#' + _winId).dialog('close');
				}
			}]
		});
		
		PHA.ComboBox("comb-CardContent", {
			url: $URL + "?ResultSetType=array&ClassName=PHA.SYS.CardContent.Query&QueryName=PICCComboBox&pic="+pic,
			width: 200,
			mode: 'remote',
			placeholder: $g('请选择卡片内容类型') + '...',
			onLoadSuccess: function(data){
				if (data.length == 1) {
					$("#comb-CardContent").combobox('setValue', data[0].RowId);
				}
			}
		});
	} else {
		$("#comb-CardContent").combobox('options').url = $URL + "?ResultSetType=array&ClassName=PHA.SYS.CardContent.Query&QueryName=PICCComboBox&pic="+pic;
		$("#comb-CardContent").combobox('clear');
		$("#comb-CardContent").combobox('reload');
	}
	$('#' + _winId).dialog('open');
}
// 新增 - 选择类型时调用
function OnSureSelectContent(winId){
	var picc = $("#comb-CardContent").combobox('getValue') || "";
	if (picc == "") {
		PHA.Popover({
			msg: "请选择卡片内容类型!",
			type: "alert"
		});
		return;
	}
	$('#' + winId).dialog('close');
	OpenCardContentWin({
		picc: picc,
		isAdd: true
	});
}
// 新增/修改 - 打开窗口
function OpenCardContentWin(opt) {
	var selectedRow = $('#gridCard').datagrid('getSelected');
	var pic = selectedRow == null ? "" : (selectedRow.pic || ""); // 前面已经验证过
	var picc = opt.picc || "";
	var title = "修改卡片内容";
	var iconCls = "icon-w-edit";
	var selectedRow = $("#gridCardItm").datagrid('getSelected');
	var pici = selectedRow == null ? "" : (selectedRow.pici || "");
	if (pici == "" && opt.isAdd == false) {
		PHA.Popover({
			msg: "请选择一项卡片内容进行修改!",
			type: "alert"
		});
		return;
	}
	if (opt.isAdd == true) {
		title = "新增卡片内容";
		iconCls = "icon-w-add";
		pici = "";
	}
	
	PHA_COM.ComAttr.Win({
		forceReload: true,
		winOptions: {
			id: 'dialogCardContentItm',
			width: 420,
	    	height: 480,
	    	modal: true,
	    	title: $g(title),
	    	iconCls: iconCls,
	    	closable: true,
	    	onClickSave: function(formData){
		    	SaveItm({
			    	saveData: formData,
			    	isAdd: opt.isAdd
			    });
		    }
		},
		cards: [
			{
				id: 'picc' + '-' + 'base' + picc,
				title: $g('卡片内容基本属性'),
				ClassName: 'PHA.SYS.Card.FormHtml',
				MethodName: 'GetCardContentBaseForm',
				picc: picc
			}, {
				id: 'picc' + '-' + 'add' + picc,
				title: $g('卡片内容附加属性'),
				ClassName: 'PHA.SYS.Card.FormHtml',
				MethodName: 'GetCardContentAddForm',
				picc: picc
			}
		],
		dataOptions: {
			ClassName: 'PHA.SYS.Card.Query',
			MethodName: 'GetCardContentFormData',
			pic: pic,
			pici: pici,
			picc: picc
		}
	});
	
	// 特殊处理表单元素
	if ($("#columns").length > 0) {
		$("#columns").next().eq(0).children().eq(0).attr('readonly', 'readonly');
	}
	if ($("#backgroundColor").length > 0) {
		$("#backgroundColor").combobox('options').formatter = function(rowData) {
			return '<label style="background-color:' + rowData.RowId + '">' + rowData.Description + '</label>';
		}
	}
	if ($("#icon").length > 0) {
		$("#icon").attr('readonly', 'readonly');
		$("#icon").parent().next().children().eq(0).on('click', function(){
			var selectedIcon = $("#icon").val() || '';
			PHA_HOMEPAGE.OpenIconWin({
				selectedIcon: selectedIcon
			});
		});
	}
}
// 保存内容
function SaveItm(opt) {
	var saveData = opt.saveData || [];
	if (saveData.length == 0) {
		return;
	}
	var selectedRow = $('#gridCard').datagrid('getSelected');
	var pic = selectedRow == null ? "" : (selectedRow.pic || "");
	if (pic == "") {
		PHA.Popover({
			msg: "请先选择卡片!",
			type: "alert"
		});
		return;
	}
	saveData[0].pic = pic;
	delete saveData[0].link; // todo...
	saveData[0].hospID = 0; // session['LOGON.HOSPID']; // 维护卡片时不区分院区
	var jsonDataStr = JSON.stringify(saveData[0]);
	
	var selectedRow = $("#gridCardItm").datagrid('getSelected');
	var pici = selectedRow == null ? "" : (selectedRow.pici || "");
	if (pici == "" && opt.isAdd == false) {
		PHA.Popover({
			msg: "请选择需要修改的卡片内容!",
			type: "alert"
		});
		return;
	}
	if (opt.isAdd == true) {
		pici = "";
	}
	
	// 注: 使用$.cm({})方法关键字:function/object/link无法传到后台
	var retStr = tkMakeServerCall('PHA.SYS.Card.Save', 'SaveCardItm', pici, jsonDataStr);
	PHA.AfterRunServer(retStr, function() {
		var retArr = retStr.split('^');
		var newPici = retArr[0];
		PHA_COM.Temp.PICI = newPici;
		$('#dialogCardContentItm').dialog('close');
		QueryItm();
	});
}
// 删除内容
function DeleteItm() {
	var selectedRow = $("#gridCardItm").datagrid("getSelected");
	if (selectedRow == null) {
		PHA.Popover({
			msg: "请选择需要删除的数据!",
			type: "alert"
		});
		return;
	}
	var pici = selectedRow.pici || "";
	PHA.Confirm("温馨提示", "是否确认删除？", function () {
		if (pici == "") {
			var rowIndex = $("#gridCardItm").datagrid('getRowIndex', selectedRow);
			$("#gridCardItm").datagrid('deleteRow', rowIndex);
			return;
		}
		var retStr = $.cm({
			ClassName: 'PHA.SYS.Card.Save',
			MethodName: 'DeleteCardItm',
			ID: pici,
			dataType: 'text'
		}, false);
		PHA.AfterRunServer(retStr, function(){
			PHA_COM.Temp.PICI = '';
			QueryItm();	
		});
	});
}

function QueryItmSet(){
	var selectedRow = $("#gridCardItm").datagrid('getSelected');
	var pici = selectedRow == null ? "" : (selectedRow.pici || "");
	$("#gridCardItmSet").datagrid('query', {
		inputStr: pici
	});
}

/*
* @description: 后台生成的触发框统一处理函数
* @others: 		该函数的名为在后台固定写死的, 需要对triggerbox扩展则按name进行扩展
*/
function TriggerboxHandler(value, name) {
	if (name == 'columns') {
		OpenColumnsSetWin(value);
	} else {
		alert('请在js函数:TriggerboxHandler()中维护对应的代码!!!');
	}
}

function ColumnsSet() {
	var picis = "";
	var otherTd = $(event.target).parent().parent().siblings();
	for (var i = 0; i < otherTd.length; i++) {
		if ($(otherTd[i]).attr('field') == 'picis') {
			picis = $(otherTd[i]).children().eq(0).text();
			break;
		}
	}
	OpenColumnsSetWin(picis);
}

// 列信息设置弹窗
function OpenColumnsSetWin(picis) {
	var picis = picis || "";
	if (picis == '') {
		PHA.Popover({
			msg: "请保存后在主界面维护列信息!",
			type: "alert"
		});
		return;
	}
	// 获取Query信息
	var clsName = '';
	var quyName = '';
	var findCnt = 0;
	var rowsData = $('#gridCardItmSet').datagrid('getRows');
	for (var i = 0; i < rowsData.length; i++) {
		var picciCode = rowsData[i].picciCode || "";
		var picisValue = rowsData[i].picisValue || "";
		if (findCnt == 2) {
			break;
		}
		if (picciCode == "ClassName") {
			clsName = picisValue;
			findCnt = findCnt + 1;
		}
		if (picciCode == "QueryName") {
			quyName = picisValue;
			findCnt = findCnt + 1;
		}
	}
	
	// 列信息维窗口 - 公共
	var inputStr = 'CF_PHA_IN.CardItmSet' + "^" + picis + "^" + clsName + "^" + quyName;
	COLSET_WIN.Open({
		queryParams: {
			ClassName: 'PHA.SYS.Col.Query',
			QueryName: 'PHAINCol',
			inputStr: inputStr
		},
		onClickSave: function(initOpts, gridColsData, gridOptsData, saveType) {
			var jsonColStr = JSON.stringify(gridColsData);
			$.m({
				ClassName: "PHA.SYS.Col.Save",
				MethodName: "SaveForPICIS",
				jsonColStr: jsonColStr,
				dataType: 'text'
			}, function(retText) {
				var retArr = retText.split('^');
				if (retArr[0] < 0) {
					PHA.Alert("提示", retArr[1], retArr[0]);
					return;
				}
				PHA.Popover({
					msg: "保存成功!",
					type: "success"
				});
				COLSET_WIN.Query();
				QueryItmSet();
			});
		},
		onClickDelete: function(initOpts, selectedRow, colId){
			$.m({
				ClassName: "PHA.SYS.Col.Save",
				MethodName: "Delete",
				Id: colId
			}, function(retText) {
				var retArr = retText.split('^');
				if (retArr[0] < 0) {
					PHA.Alert("提示", retArr[1], retArr[0]);
					return;
				}
				PHA.Popover({
					msg: "删除成功!",
					type: "success"
				});
				COLSET_WIN.Query();
				QueryItmSet();
			});
		}
	});
}

// 上下移动行
function RowUpAndDown(ifUp){
	PHA.UpDownCol({
		gridID: 'gridCardItm',
		ifUp: ifUp,
		onEnd: function(rowIndex, newRowIndex){
			var rowsData = $("#gridCardItm").datagrid('getRows');
			var rowData = rowsData[rowIndex];
			var newRowData = rowsData[newRowIndex];
			var rowIdx = rowData.piciRowIndex;
			var colIdx = rowData.piciColIndex;
			var sortNum = rowData.piciSortNum;
			var formFlag = rowData.piccFormFlag;
			var newRowIdx = newRowData.piciRowIndex;
			var newColIdx = newRowData.piciColIndex;
			var newSortNum = newRowData.piciSortNum;
			var newFormFlag = newRowData.piccFormFlag;
			if (formFlag != newFormFlag) {
				PHA.Popover({
					msg: "表单元素与非表单元素无法交换顺序！",
					type: "alert"
				});
				QueryItm();
				return;
			}
			rowData.piciRowIndex = newRowIdx;
			rowData.piciColIndex = newColIdx;
			rowData.piciSortNum = newSortNum;
			newRowData.piciRowIndex = rowIdx;
			newRowData.piciColIndex = colIdx;
			newRowData.piciSortNum = sortNum;
			
			var jsonArr = [rowData, newRowData];
			var jsonDataStr = JSON.stringify(jsonArr);
			
			var retStr = tkMakeServerCall("PHA.SYS.Card.Save", "UpdatePostion", jsonDataStr);
			PHA.AfterRunServer(retStr, function(){
				QueryItm();
			});
		}
	});
}

// 卡片导出
function ExportTxt(){
	var selectedRow = $("#gridCard").datagrid("getSelected");
	if (selectedRow == null) {
		$.messager.popover({
			timeout: 1000,
			msg: "请选择需要导出的卡片!",
			type: "alert"
		});
		return;
	}
	var pic = selectedRow.pic;
	var picCode = selectedRow.picCode;
	var picDesc = selectedRow.picDesc;
	
	var txtStr = $.m({
		ClassName: "PHA.SYS.Card.Save",
		MethodName: "ExportCard",
		pic: pic
	}, false);
	var blob = new Blob([txtStr], {type: "text/plain;charset=utf-8"});
	saveAs(blob, picCode + "-" + picDesc  + ".txt");
}

// 卡片导入
function ImportTxt(){
	PHA_COM.ImportFile({
		suffixReg: /^(.txt)$/,
		charset: 'utf-8'
	}, function(txt){
		var jsonTxt = txt;
		try {
			var jsonObj = eval('(' + txt + ')');
			jsonTxt = JSON.stringify(jsonObj);
		} catch(e) {
			PHA.Alert('温馨提示', 'txt文件中数据格式错误，数据格式只能为json！', 'error');
			return;
		}
		var importRet = tkMakeServerCall("PHA.SYS.Card.Save", "ImportCard", jsonTxt);
		var importRetArr = importRet.split('^');
		if (importRetArr[0] < 0) {
			PHA.Alert('温馨提示', importRetArr[1], 'error');
			return;
		}
		$.messager.popover({
			timeout: 1000,
			msg: "成功!",
			type: "success"
		});
		Query();
	});	
}