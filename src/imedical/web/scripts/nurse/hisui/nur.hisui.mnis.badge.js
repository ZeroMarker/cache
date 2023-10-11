/// Creator:      EH
/// CreatDate:    2022-03-17
/// Description:  工号牌打印 8.5

var PRIVILEGE, LOADING;

/// 初始化
var init = function() {
	PRIVILEGE = (GetSessionProperty('LOGON.GROUPDESC').indexOf('Demo Group') > -1);
	///
	$('#locCombo').combobox({
		url: '',
	    valueField: 'locID',
		textField: 'locDesc',
	    defaultFilter: 4,
	    disabled: !PRIVILEGE,
	    panelHeight: 'auto',
	    panelMaxHeight: '400px',
		onShowPanel: function() {
			var panel = $(this).combobox('panel');
			panel.css('display', 'inline-block');
			var maxHeight = parseInt($(this).combobox('options').panelMaxHeight);
			if (panel.height() > maxHeight) panel.height(maxHeight);
		},
		onLoadSuccess: function(data) {
			var locID = PRIVILEGE ? $('#locCombo').combo('getValue') : GetSessionProperty('LOGON.CTLOCID');
			var findValue = data.find(function(currentValue, index, arr) {
				if (currentValue.locID == locID) return true;
			}, this);
			setTimeout(function() {
				$('#locCombo').combo('setValue', findValue ? findValue.locID : '');
				$('#locCombo').combo('setText', findValue ? findValue.locDesc : '');
			}, 20);
		},
		onChange: function(value, oldValue) {
			setTimeout(badgeGridFindClick, 20);
		}
	});
	///
	var showPrintLog = $('#printLogCheck').checkbox('getValue');
	var columns = [
		{ field: 'check', checkbox: true },
		{ field: 'userCode', title: text003, width: 150 },
		{ field: 'userName', title: text004, width: 150 },
		{ field: 'printLog', title: text005, width: 300
			, hidden: !showPrintLog
			, formatter: function(value, row, index) {
				if (!value.length) return '';
				var json = JSON.parse(value);
				if (!json.length) return '';
				if (!window.collapsePrintLog) {
					window.collapsePrintLog = function(ar) {
						var tb = $(ar).parent().parent().parent().parent();
						if (!tb.length) return;
						tb.toggleClass('collapse');
					};
				}
				var tb = '<table class="printLog collapse">';
				for (var i = 0; i < json.length; i++) {
					var tt = '<table class=\'printLog tip\'><tr><td>' + text006 + '</td><td>' + (json[i].clientIP || '') + '</td></tr>'
						+ '<tr><td>' + text007 + '</td><td>' + (json[i].computerName || '') + '</td></td></table>';
					var ar = i == 0 && json.length > 1 ? '<a href="javascript:void(0)" onclick=collapsePrintLog(this)></a>' : '';
					var tr = '<tr title="' + tt + '" class="hisui-tooltip" data-options="position:\'right\'">'
						+ '<td>' + (json[i].printTime || '') + '</td><td>' + (json[i].printUser || '') + '</td>'
						+ '<td>' + ar + '</td></tr>';
					tb += tr;
				}
				tb += '</table>';
				return tb;
			}	
		},
	    { field: 'userID', title: 'ID', width: 100, hidden: true }
	];
	if (PRIVILEGE) {
		columns.splice(1, 0
			, { field: 'locDesc', title: text002, width: 250 }
		);
	}
	$HUI.datagrid('#badgeGrid', {
		url: '',
		columns: [
			columns
		],
		fitColumns: false,
		idField: 'userCode',
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 50,
		pageList: [50, 200, 500],
		remoteSort: true,
		onBeforeLoad: function(param) {
			LOADING = true;
		},
		onLoadSuccess: function(data) {
			LOADING = false;
			var showPrintLog = $('#printLogCheck').checkbox('getValue');
			if (showPrintLog) {
				var tb = $('#badgeGrid').prev().find('.datagrid-body');
				var rows = data.rows || data;
				rows.forEach(function(row, i) {
					var td = tb.find('tr[datagrid-row-index=' + i + ']').find('td[field=printLog]').find('.datagrid-cell');
					if (!td.length || !td.html()) return;
					$.parser.parse(td);
				});
			}
		},
		onLoadError: function() {
			LOADING = false;
		}
	});
	///
	$('#badgeGridFindBtn').bind('click', function() {
		if (!LOADING) badgeGridFindClick();
	});
	$('#badgeGridPrintBtn').bind('click', badgeGridPrintClick);
	$('#userCodeText').bind('keypress', function(event) {
		if (event.keyCode == '13' && !LOADING) setTimeout(badgeGridFindClick, 20);
	});
	var onHospComboSelect = function() {
		$('#locCombo').combobox('options').url = $URL + '?ClassName=Nur.HISUI.MNIS.Badge&QueryName=FindLoc&ResultSetType=array'
			+ '&hospID=' + GetHospComboValue() + '&userType=NURSE';
		$('#locCombo').combobox('reload');
	};
	if (PRIVILEGE) {
		BeforeHospCombo('locCombo', onHospComboSelect, text001);
		setTimeout(badgeGridFindClick, 80);
	} else onHospComboSelect();
};
$(init);

function badgeGridFindClick() {
	var locID = $('#locCombo').combobox('getValue');
	if ((!PRIVILEGE && !locID) || !$('#locCombo').combobox('options').url) return;
	var showPrintLog = $('#printLogCheck').checkbox('getValue');
	if (showPrintLog) $('#badgeGrid').datagrid('showColumn', 'printLog');
	else $('#badgeGrid').datagrid('hideColumn', 'printLog');
	var printFlag = showPrintLog ? 'Badge' : '';
	var options = $('#badgeGrid').datagrid('options');
	options.url = $URL + '?ClassName=Nur.HISUI.MNIS.Badge&QueryName=FindUser'
		+ '&hospID=' + GetHospComboValue() + '&userType=NURSE'
		+ '&locID=' + locID + '&filterText=' + $('#userCodeText').val()
		+ '&printFlag=' + printFlag;
	$('#badgeGrid').datagrid('reload');
}

function badgeGridPrintClick() {
	var idArray = [], dataArray = [];
	var selections = $('#badgeGrid').datagrid('getSelections');
	selections.forEach(function(row) {
		var id = row['userID'];
		if (idArray.indexOf(id) > -1) return;
		idArray.push(id);
		var data = '';
		for (var name in row) {
			if (name == 'userID') continue;
			data += (data != '') ? '^' : '';
			data += name + '|' + row[name];
		}
		dataArray.push(data);
	});
	if (dataArray.length == 0) {
		$.messager.popover({ msg: text008, type: 'alert', timeout: 5000 });
		return;
	}
	var orderIDStr = idArray.join('^'), printData = dataArray.join('#');
	NewPrintXmlMode(orderIDStr, printData, 'Badge', 'DHCNUR_Badge');
}
