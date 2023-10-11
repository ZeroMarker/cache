/**
 * ����:	 ҩ��ҩ��-ҩѧ��ҳ-��Ƭά��
 * ��д��:	 Huxt
 * ��д����: 2020-04-13
 * csp:  	 pha.sys.v1.card.csp
 * js:		 pha/sys/v1/card.js
 */
PHA_COM.App.Csp = "pha.sys.v1.card.csp"
PHA_COM.App.CspDesc = "��Ƭά��"
PHA_COM.App.ProDesc = "����ҵ��"
PHA_COM.Temp = {}
PHA_COM.Temp.SelectedIndex = null;
PHA_COM.Temp.PICI = '';
PHA_COM.Temp.PageSize = 100;

$(function() {
	// ���ñ���
	var t1 = $g('�������');
	var cardItmPanel = $("#panel-cardItm").panel('options');
	var cardItmTitle = cardItmPanel.title;
	$("#panel-cardItm").panel('setTitle', cardItmTitle + ' - ' + t1);
	
	// ��ʼ��
	InitFormData();
	InitGridCard();
	ShowCardContentGrids();

	// �¼�
	$("#btnAdd").on('click', Add);
	$("#btnEdit").on('click', Add);
	$("#btnDel").on('click', Delete);
	$('#btnExport').on('click', ExportTxt);
	$('#btnImport').on('click', ImportTxt);
	
	// �ı�˳��
	$(document).keydown(function(e){
		if(event.keyCode == 38){
			RowUpAndDown(true);
		}
		if(event.keyCode == 40){
			RowUpAndDown(false);
		}
	});
});

// ��Ԫ��
function InitFormData() {
}

// ��Ƭ�б�
function InitGridCard() {
	var columns = [[
    	{ field: "pic", title: 'pic', width: 80, hidden:true},
		{ field: "picCode", title: '��Ƭ����', width: 100},
		{ field: 'picDesc', title: '��Ƭ����', width: 130},
		{ field: 'picActiveFlag', title: '�Ƿ����', width: 70, align: 'center', formatter: PHA.CheckBoxFormatter}
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

// ��ʼ����Ƭ���ݱ��
function ShowCardContentGrids() {
	if ($("#cardContentGrids").length > 0) {
		$("#cardContentGrids").show();
		var $CHL = $("#cardContentGrids").children().eq(0);
		if ($CHL.length > 0) {
			$("#cardContentGrids").children().eq(1).css('top', $CHL[0].offsetHeight - 1);
		}
		return;
	}
	
	// ��̬����HTML
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
	gridCardItmBar += '<a class="hisui-linkbutton" plain=\'true\' iconCls="icon-add" id="btnAddItm">' + $g('����') + '</a>';
	gridCardItmBar += '<a class="hisui-linkbutton" plain=\'true\' iconCls="icon-write-order" id="btnEditItm">' + $g('�޸�') + '</a>';
	gridCardItmBar += '<a class="hisui-linkbutton" plain=\'true\' iconCls="icon-cancel" id="btnDelItm">' + $g('ɾ��') + '</a>';
	gridCardItmBar += '</div>';
	$(gridCardItmBar).appendTo('body');
	$.parser.parse($("#gridCardItmBar"));
	
	var gridCardItmBarSet = '<div id="gridCardItmSetBar" style="border-top:0px solid #d1d6da">' + '</div>';
	$(gridCardItmBarSet).appendTo('body');
	$.parser.parse($("#gridCardItmBarSet"));
	
	// ��ʼ��
	InitGridCardItm();
	InitGridCardItmSet();
	
	// �߿�
	$("#gridCardItmBar").parent().parent().parent().css('border-bottom', '1px solid #d1d6da');
	$("#gridCardItmSetBar").parent().parent().parent().css('border-top', '1px solid #d1d6da');
	
	// ���¼�
	$("#btnAddItm").on('click', AddItm);
	$("#btnEditItm").on('click', EditItm);
	$("#btnDelItm").on('click', DeleteItm);
}
function HideCardContentGrids(){
	if ($("#cardContentGrids").length > 0) {
		$("#cardContentGrids").hide();
	}
}

// ���ݱ��
function InitGridCardItm() {
	var columns = [[
    	{ field: "pic", title: 'pic', width: 80, hidden:true},
    	{ field: "pici", title: 'pici', width: 80, hidden:true},
    	{ field: "picc", title: 'picc', width: 80, hidden:true},
		{ field: "piccCode", title: '�������ʹ���', width: 80, hidden:true},
		{ field: 'piccDesc', title: '��������', width: 110},
		{ field: "piciCode", title: '���ݴ���', width: 100},
		{ field: 'piciDesc', title: '��������', width: 120},
		{ field: 'piciRowIndex', title: '�к�', width: 80, align: 'center'},
		{ field: 'piciColIndex', title: '�к�', width: 80, align: 'center'},
		{ field: 'piciSortNum', title: '�������', width: 80, align: 'center'},
		{ field: 'piccFormFlag', title: '��', width: 35, align: 'center', formatter: PHA.CheckBoxFormatter},
		{ field: 'piciActiveFlag', title: '����', width: 35, align: 'center', formatter: PHA.CheckBoxFormatter}
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
		        QueryItmSet(); // ������
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
// �������Ա��
function InitGridCardItmSet() {
	var columns = [[
    	{ field: "pici", title: 'pici', width: 80, hidden:true},
    	{ field: "picis", title: 'picis', width: 80, hidden:true},
		{ field: "picci", title: 'picci', width: 80, hidden:true},
		{ field: "picciCode", title: '���Դ���', width: 100},
		{ field: "picciDesc", title: '��������', width: 100},
		{ field: 'picisValue', title: '����ֵ', width: 100,
			formatter: function(value, rowData, rowIndex) {
				if (rowData.picciCode == 'columns') {
					if (value == "") {
						return "<a style='border:0px;cursor:pointer' onclick='ColumnsSet();'>���ά��</a>"
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

// Ԥ������
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

// �÷�����csp�а�
function Transfer(){
	var cardItmPanel = $("#panel-cardItm").panel('options');
	var title = cardItmPanel.title;
	var titleArr = title.split(' - ');
	var t1 = $g('�������');
	var t2 = $g('ͼ��Ԥ��');
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
* @description: ��Ƭ������ɾ�Ĳ�ѯ
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
	var title = "�޸Ŀ�Ƭ";
	var iconCls = "icon-w-edit";
	var selectedRow = $("#gridCard").datagrid('getSelected');
	var pic = selectedRow == null ? "" : (selectedRow.pic || "");
	if (pic == "" && opt.isAdd == false) {
		PHA.Popover({
			msg: "��ѡ����Ҫ�޸ĵĿ�Ƭ!",
			type: "alert"
		});
		return;
	}
	if (opt.isAdd == true) {
		title = "������Ƭ";
		iconCls = "icon-w-add";
		pic = "";
	}
	
	PHA_COM.ComAttr.Win({
		forceReload: true, // ÿ�����¼���
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
				title: $g('��Ƭ��������'),
				ClassName: 'PHA.SYS.Card.FormHtml',
				MethodName: 'GetCardBaseForm'
			}, {
				id: 'cardAttr',
				title: $g('��Ƭ��������'),
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
			msg: "��ѡ����Ҫ�޸ĵĿ�Ƭ!",
			type: "alert"
		});
		return;
	}
	if (opt.isAdd == true) {
		pic = "";
	}
	
	// ע: ʹ��$.cm({})�����ؼ���:function/object/link�޷�������̨
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
			msg: "��ѡ����Ҫɾ��������!",
			type: "alert"
		});
		return;
	}
	var pic = selectedRow.pic || "";
	PHA.Confirm("��ܰ��ʾ", "�Ƿ�ȷ��ɾ����", function () {
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
* @description: ��Ƭ��/�����ɾ�Ĳ�ѯ
*/
// ��ѯ
function QueryItm(){
	var selectedRow = $("#gridCard").datagrid('getSelected');
	var pic = selectedRow == null ? "" : (selectedRow.pic || "");
	$("#gridCardItm").datagrid('query',{
		inputStr: pic
	});
}
// �޸�
function EditItm(){
	var selectedRow = $("#gridCardItm").datagrid('getSelected');
	var picc = selectedRow == null ? "" : (selectedRow.picc || "");
	OpenCardContentWin({
		picc: picc,
		isAdd: false
	});
}
// ���� - ����һ������
function AddItm(){
	var selectedRow = $('#gridCard').datagrid('getSelected');
	var pic = selectedRow == null ? "" : (selectedRow.pic || "");
	if (pic == "") {
		PHA.Popover({
			msg: "����ѡ��Ƭ!",
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
	    	title: $g('ѡ��Ƭ��������'),
	    	closable: true,
	    	content: contentHtml,
	    	buttons : [{
				text: 'ȷ��',
				handler: function(){
					OnSureSelectContent(_winId);
				}
			}, {
				text: 'ȡ��',
				handler: function(){
					$('#' + _winId).dialog('close');
				}
			}]
		});
		
		PHA.ComboBox("comb-CardContent", {
			url: $URL + "?ResultSetType=array&ClassName=PHA.SYS.CardContent.Query&QueryName=PICCComboBox&pic="+pic,
			width: 200,
			mode: 'remote',
			placeholder: $g('��ѡ��Ƭ��������') + '...',
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
// ���� - ѡ������ʱ����
function OnSureSelectContent(winId){
	var picc = $("#comb-CardContent").combobox('getValue') || "";
	if (picc == "") {
		PHA.Popover({
			msg: "��ѡ��Ƭ��������!",
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
// ����/�޸� - �򿪴���
function OpenCardContentWin(opt) {
	var selectedRow = $('#gridCard').datagrid('getSelected');
	var pic = selectedRow == null ? "" : (selectedRow.pic || ""); // ǰ���Ѿ���֤��
	var picc = opt.picc || "";
	var title = "�޸Ŀ�Ƭ����";
	var iconCls = "icon-w-edit";
	var selectedRow = $("#gridCardItm").datagrid('getSelected');
	var pici = selectedRow == null ? "" : (selectedRow.pici || "");
	if (pici == "" && opt.isAdd == false) {
		PHA.Popover({
			msg: "��ѡ��һ�Ƭ���ݽ����޸�!",
			type: "alert"
		});
		return;
	}
	if (opt.isAdd == true) {
		title = "������Ƭ����";
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
				title: $g('��Ƭ���ݻ�������'),
				ClassName: 'PHA.SYS.Card.FormHtml',
				MethodName: 'GetCardContentBaseForm',
				picc: picc
			}, {
				id: 'picc' + '-' + 'add' + picc,
				title: $g('��Ƭ���ݸ�������'),
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
	
	// ���⴦���Ԫ��
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
// ��������
function SaveItm(opt) {
	var saveData = opt.saveData || [];
	if (saveData.length == 0) {
		return;
	}
	var selectedRow = $('#gridCard').datagrid('getSelected');
	var pic = selectedRow == null ? "" : (selectedRow.pic || "");
	if (pic == "") {
		PHA.Popover({
			msg: "����ѡ��Ƭ!",
			type: "alert"
		});
		return;
	}
	saveData[0].pic = pic;
	delete saveData[0].link; // todo...
	saveData[0].hospID = 0; // session['LOGON.HOSPID']; // ά����Ƭʱ������Ժ��
	var jsonDataStr = JSON.stringify(saveData[0]);
	
	var selectedRow = $("#gridCardItm").datagrid('getSelected');
	var pici = selectedRow == null ? "" : (selectedRow.pici || "");
	if (pici == "" && opt.isAdd == false) {
		PHA.Popover({
			msg: "��ѡ����Ҫ�޸ĵĿ�Ƭ����!",
			type: "alert"
		});
		return;
	}
	if (opt.isAdd == true) {
		pici = "";
	}
	
	// ע: ʹ��$.cm({})�����ؼ���:function/object/link�޷�������̨
	var retStr = tkMakeServerCall('PHA.SYS.Card.Save', 'SaveCardItm', pici, jsonDataStr);
	PHA.AfterRunServer(retStr, function() {
		var retArr = retStr.split('^');
		var newPici = retArr[0];
		PHA_COM.Temp.PICI = newPici;
		$('#dialogCardContentItm').dialog('close');
		QueryItm();
	});
}
// ɾ������
function DeleteItm() {
	var selectedRow = $("#gridCardItm").datagrid("getSelected");
	if (selectedRow == null) {
		PHA.Popover({
			msg: "��ѡ����Ҫɾ��������!",
			type: "alert"
		});
		return;
	}
	var pici = selectedRow.pici || "";
	PHA.Confirm("��ܰ��ʾ", "�Ƿ�ȷ��ɾ����", function () {
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
* @description: ��̨���ɵĴ�����ͳһ������
* @others: 		�ú�������Ϊ�ں�̨�̶�д����, ��Ҫ��triggerbox��չ��name������չ
*/
function TriggerboxHandler(value, name) {
	if (name == 'columns') {
		OpenColumnsSetWin(value);
	} else {
		alert('����js����:TriggerboxHandler()��ά����Ӧ�Ĵ���!!!');
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

// ����Ϣ���õ���
function OpenColumnsSetWin(picis) {
	var picis = picis || "";
	if (picis == '') {
		PHA.Popover({
			msg: "�뱣�����������ά������Ϣ!",
			type: "alert"
		});
		return;
	}
	// ��ȡQuery��Ϣ
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
	
	// ����Ϣά���� - ����
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
					PHA.Alert("��ʾ", retArr[1], retArr[0]);
					return;
				}
				PHA.Popover({
					msg: "����ɹ�!",
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
					PHA.Alert("��ʾ", retArr[1], retArr[0]);
					return;
				}
				PHA.Popover({
					msg: "ɾ���ɹ�!",
					type: "success"
				});
				COLSET_WIN.Query();
				QueryItmSet();
			});
		}
	});
}

// �����ƶ���
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
					msg: "��Ԫ����Ǳ�Ԫ���޷�����˳��",
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

// ��Ƭ����
function ExportTxt(){
	var selectedRow = $("#gridCard").datagrid("getSelected");
	if (selectedRow == null) {
		$.messager.popover({
			timeout: 1000,
			msg: "��ѡ����Ҫ�����Ŀ�Ƭ!",
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

// ��Ƭ����
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
			PHA.Alert('��ܰ��ʾ', 'txt�ļ������ݸ�ʽ�������ݸ�ʽֻ��Ϊjson��', 'error');
			return;
		}
		var importRet = tkMakeServerCall("PHA.SYS.Card.Save", "ImportCard", jsonTxt);
		var importRetArr = importRet.split('^');
		if (importRetArr[0] < 0) {
			PHA.Alert('��ܰ��ʾ', importRetArr[1], 'error');
			return;
		}
		$.messager.popover({
			timeout: 1000,
			msg: "�ɹ�!",
			type: "success"
		});
		Query();
	});	
}