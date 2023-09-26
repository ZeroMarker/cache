/// EH 2014-04-24
function InitializeForm() {
	var sdateField = {
		xtype: 'datefield',
		id: 'StDate',
		fieldLabel: '开始日期',
		format: 'Y-m-d',
		colspan: 1
	};
	var stimeField = {
		xtype: 'timefield',
		id: 'StartTime',
		width: 80,
		format: 'G:i',
		colspan: 2
	};
	var edateField = {
		xtype: 'datefield',
		id: 'EDate',
		fieldLabel: '结束日期',
		format: 'Y-m-d',
		colspan: 1
	};
	var etimeField = {
		xtype: 'timefield',
		id: 'EndTime',
		width: 80,
		format: 'G:i',
		colspan: 2
	};
	var intervalArea = {
		layout: 'table',
		layoutConfig: {
			columns: 2
		},
		items: [
			sdateField,
			stimeField,
			edateField,
			etimeField
		]
	};
	var wardLabel = {
		xtype: 'label',
		text: '病区',
		colspan: 1
	};
	var pharmacyLabel = {
		xtype: 'label',
		text: '药房',
		colspan: 1
	};
	var medicineLabel = {
		xtype: 'label',
		text: '药品',
		colspan: 1
	};
	var wardCombob = CreateComboBox('wardId', 'desc', 'rw', 165, 'web.DHCLCNUREXCUTE', 'GetWard', 'code');
	var pharmacyCombob = CreateComboBoxSimple('RecLocId', 'desc', 'rw', 165, classconfig, 'GetPharmacySimple', '');
	var medicineCombob = CreateComboBox('ArcimID', 'desc', 'rw', 165, classconfig, 'GetMedicine', 'code');
	Ext.applyIf(wardCombob, {
		colspan: 2
	});
	Ext.applyIf(pharmacyCombob, {
		colspan: 2
	});
	Ext.applyIf(medicineCombob, {
		colspan: 2
	});
	var locationArea = {
		layout: 'table',
		layoutConfig: {
			columns: 2
		},
		items: [
			wardLabel,
			wardCombob,
			pharmacyLabel,
			pharmacyCombob,
			medicineLabel,
			medicineCombob
		]
	};
	var parameterLabelStr = westconfig1;
	var parameterFieldStr = westconfig2;
	var defaultCheckedStr = westconfig3;
	var defaultHiddenStr = westconfig4;
	var parameterLabelArray = parameterLabelStr.split('^');
	var parameterFieldArray = parameterFieldStr.split('^');
	var defaultCheckedArray = defaultCheckedStr.split('^');
	var defaultHiddenArray = defaultHiddenStr.split('^');
	if (westconfig1 == '') {
		parameterLabelArray.length = 0;
	}
	var parameterItems = [];
	var colspanInd = 0;
	var colspanNum = 4;
	for (var i = 0; i < parameterLabelArray.length; i++) {
		var parameterLabel = {
			xtype: 'label',
			width: 50,
			text: parameterLabelArray[i],
			hidden : (defaultHiddenArray[i] == 'hidden') ? true : false
		};
		var parameterField = {
			xtype: 'checkbox',
			id: parameterFieldArray[i],
			width: 50,
			checked: (defaultCheckedArray[i] == 'checked') ? true : false,
			hidden : (defaultHiddenArray[i] == 'hidden') ? true : false
		};
		if (colspanNum > 0) {
			colspanInd++;
			(colspanInd > colspanNum) ? colspanInd = 1 : '';
			colspanInd++;
			(colspanInd > colspanNum) ? colspanInd = 1 : '';
		}
		parameterItems[parameterItems.length] = parameterLabel;
		parameterItems[parameterItems.length] = parameterField;
	}
	var searchButton = {
		xtype: 'button',
		id: 'btnSearch',
		text: '查询',
		handler: function(t, e) {
			Search_Click();	
		}
	};
	parameterItems[parameterItems.length] = searchButton;
	var parameterArea = {
		layout: 'table',
		layoutConfig: {
		},
		items: parameterItems
	};
	(colspanNum > 0) ? (parameterArea.layoutConfig.columns = colspanNum) : '';
	var searchFieldset = {
		xtype: 'fieldset',
		id: 'fsSearch',
		labelWidth: 55,
		collapsible: true,
		title: '查询条件',
		frame: false,
		bodyStyle: 'padding: 1px',
		items: [
			intervalArea,
			locationArea,
			parameterArea
		]
	};
	var patientTree = CreateTree('patientTree');
	var patientFieldset = {
		xtype: 'fieldset',
		title: '病人列表',
		id: 'fsPatient',
		containerScroll: true,
		collapsible: true,
		autoScroll: true,
		frame: true,
		items: [
			patientTree
		]
	};
	var anchorPanel = new Ext.FormPanel({
		id: 'leftPanel',
		region: 'west',
		width: 240,
		minWidth: 140,
		split: true,
		items: [
			searchFieldset,
			patientFieldset
		]
	});
	var westRegion = Ext.getCmp('leftPanel');
	InitializeRight();
	var centerRegion = Ext.getCmp('rightPanel');
	var viewPort = new Ext.Viewport({
		layout: 'border',
		id: 'viewPort',
		defaults: {
			border: true,
			frame: true,
			bodyBorder: true
		},
		items: [
			westRegion,
			centerRegion
		]
	});
}

function getDisposeStatColor() {
	var parameterLabelStr = errorconfig1;
	var parameterColorStr = errorconfig3;
	var parameterLabelArray = parameterLabelStr.split('^');
	var parameterColorArray = parameterColorStr.split('^');
	if (errorconfig1 == '') {
		parameterLabelArray.length = 0;
	}
	var str = '';
	for (var i = 0; i < parameterLabelArray.length; i++) {
		str += "<TD noWrap><label id='renderclortip" + i + "' style='BORDER-RIGHT: silver 1px solid; BORDER-TOP: silver 1px solid; BORDER-LEFT: silver 1px solid; WIDTH: 85px; BORDER-BOTTOM: silver 1px solid; HEIGHT: 20px; BACKGROUND-COLOR: " + parameterColorArray[i] + "; font-weight: bold'>" + parameterLabelArray[i] + "</label></TD>"
	}
	if (str != '') {
		str = "<table>" + "<tr>" + str + "</tr>" + " </table>";
	}
	return str;
}

function InitializeRight() {
	var panelTitle = CreateTitle('arrowPanel', '药品查询', 'button');
	var headerStr = northconfig1;
	var columnStr = northconfig2;
	var widthStr = northconfig3;
	var typeStr = northconfig4;
	var columnModel = CreateModel(headerStr, columnStr, widthStr, typeStr);
	var arrowPanel = CreateGrid(classconfig, 'GetFaYao', columnModel, 'arrowPanel', panelTitle, 300, 300, 20);
	var parameterFieldStr = errorconfig2;
	var parameterColorStr = errorconfig3;
	var parameterFieldArray = parameterFieldStr.split('^');
	var parameterColorArray = parameterColorStr.split('^');
	if (errorconfig2 == '') {
		parameterFieldArray.length = 0;
	}
	for (var i = 0; i < parameterFieldArray.length; i++) {
		arrowPanel.renderColor('errcode', parameterFieldArray[i], 'errcode1', parameterColorArray[i]);
	}
	var tbar = arrowPanel.getTopToolbar();
	var button = {
		xtype: 'button',
		text: '药品审核',
		id: 'btnArrowAudit',
		handler: function(t, e) {
			try {
				Click_Button(arrowPanel.id, this.id);
			} catch(e){
			}
		}
	};
	tbar.addItem(button);
	tbar.addItem('-');
	tbar.addItem({
		xtype: 'label',
		text: '双击单行以查询明细',
		style: 'color:purple; font-weight: bold;'
	});
	tbar.addItem('-');
	var disposecolor = getDisposeStatColor();
	if (disposecolor != '') {
		tbar.addItem({
			xtype: 'label',
			html: disposecolor
		});
	}
	tbar.doLayout();
	panelTitle = CreateTitle('dhcdspPanel', '明细查询', 'button');
	headerStr = southconfig1;
	columnStr = southconfig2;
	widthStr = southconfig3;
	typeStr = southconfig4;
	columnModel = CreateModel(headerStr, columnStr, widthStr, typeStr);
	var dhcdspPanel = CreateGrid(classconfig, 'GetFaYaoDet', columnModel, 'dhcdspPanel', panelTitle, 300, 300, 20);
	for (var i = 0; i < parameterFieldArray.length; i++) {
		dhcdspPanel.renderColor('errcode', parameterFieldArray[i], 'errcode1', parameterColorArray[i]);
	}
	tbar = dhcdspPanel.getTopToolbar();
	button = {
		xtype: 'button',
		text: '明细审核',
		id: 'btnDspensingAudit',
		handler: function() {
			try {
				Click_Button(dhcdspPanel.id, this.id);
			} catch(e){
			}
		}
	};
	tbar.addItem(button);
	tbar.addItem('-');
	var button2 = {
		xtype: 'button',
		text: '撤销审核',
		id: 'btnDspensingCancel',
		handler: function() {
			try {
				Click_Button(dhcdspPanel.id, this.id);
			} catch(e){
			}
		}
	};
	tbar.addItem(button2);
	//tbar.addItem('-'); // cilin
	var pogFlagLabel = {
		xtype: 'label',
		text: '打包标志'
		,hidden: true
	};
	var pogFlagField = {
		xtype: 'checkbox',
		id: 'pogFlag',
		checked: false
		,hidden: true
	};
	tbar.addItem(pogFlagLabel);
	tbar.addItem(pogFlagField);
	tbar.addItem('-');
	tbar.addItem({
		xtype: 'label',
		text: '点击"明细查询"回到顶部',
		style: 'color:purple; font-weight: bold;'
	});
	tbar.doLayout();
	Ext.applyIf(arrowPanel, {
		collapsible: true,
		region: 'center'
	});
	Ext.applyIf(dhcdspPanel, {
		collapsible: true,
		region: 'south'
	});
	var rightPanel = new Ext.Panel({
		id: 'rightPanel',
		width: 'auto',
		region: 'center',
		split: true,
		items: [
			arrowPanel,
			dhcdspPanel
		]	
	});
}

function InitializeValue() {
	var arrowTitle = document.getElementById('arrowPanelTitle');
	var dhcdspTitle = document.getElementById('dhcdspPanelTitle');
	arrowTitle.onclick = function() {
		try {
			Click_Button('arrowPanel', 'arrowPanelTitle');
		} catch(e){
		}		
	};
	dhcdspTitle.onclick = function() {
		try {
			Click_Button('dhcdspPanel', 'dhcdspPanelTitle');
		} catch(e){
		}		
	};
	var startDate = Ext.getCmp('StDate');
	var startTime = Ext.getCmp('StartTime');
	var endDate = Ext.getCmp('EDate');
	var endTime = Ext.getCmp('EndTime');
	var periodArray = periodconfig1.split('^');
	startDate.setValue(getToday(periodArray[0] || ''));
	startTime.setValue(getTime(periodArray[2] || ''));
	endDate.setValue(getToday(periodArray[1] || ''));
	endTime.setValue(getTime(periodArray[3] || ''));
	var wardLocInfo = tkMakeServerCall('web.DHCLCNUREXCUTE', 'GetUserWardId', session['LOGON.USERID'], session['LOGON.CTLOCID'], '');
	wardLocInfo = wardLocInfo.split('|');
	var wardInfo = wardLocInfo[0].split('^');
	if (wardInfo[1] == undefined) {
		Ext.Msg.show({
			title: '提示',
			msg: '无法获取病区信息, 请确认登录用户!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return;
	}
	var recloc = Ext.getCmp('RecLocId');
	recloc.on('select', function(combo, record, index) {
		Search_Click();
	});
	var ward = Ext.getCmp('wardId');
	ward.on('select', function(combo, record, index) {
		var patientTree = Ext.getCmp('patientTree');
		patientTree.root.reload();
	});
	var fsSearch = Ext.getCmp('fsSearch');
	var patientTree = Ext.getCmp('patientTree');
	var loader = patientTree.loader;
	loader.on('beforeload', function(loader, node, callback) { // EH 05-28
        var ward = Ext.getCmp('wardId');
        loader.baseParams.wardId = ward.getValue();
        loader.baseParams.adm = EpisodeID;
    }, this);
    loader.on('load', function(loader, node, response) { // EH 05-28
        var patientTree = Ext.getCmp('patientTree');
        patientTree.expandAll();
    }, this);
    ward.getStore().load({
		params: {
			start: 0,
			limit: 10,
			code: wardInfo[0]
		},
		callback: function() {
			ward.setValue(wardInfo[1]);
			patientTree.root.reload(); // EH 05-28
			patientTree.root.getUI().toggleCheck(false);
		}		
	});
	var patientTreeAutoHeight = function() {
		var viewPort = Ext.getCmp('viewPort');
		var fsSearch = Ext.getCmp('fsSearch');
		var patientTree = Ext.getCmp('patientTree');
		patientTree.setHeight(viewPort.getHeight() - fsSearch.getHeight() - 120);
	};
	fsSearch.on('collapse', function(animate) {
		patientTreeAutoHeight()
	}, this);
	fsSearch.on('expand', function(animate) {
		patientTreeAutoHeight()
	}, this);
	patientTree.on('click', function(node, e) {
		if((!arguments[1]) != true) {
			node.getUI().toggleCheck();
		}
		var childNodeArray = node.childNodes;
		if(childNodeArray.length == 0) {
			return;
		}
		for(var i = 0; i < childNodeArray.length; i++) {
			childNodeArray[i].getUI().toggleCheck(node.getUI().isChecked());
			arguments.callee(childNodeArray[i], false);
		}
	});
	patientTree.on('checkchange', function(node, checked) {
		var childNodeArray = node.childNodes;
		if (childNodeArray.length == 0) {
			return;
		}
		for (var i = 0; i < childNodeArray.length; i++) {
			childNodeArray[i].getUI().toggleCheck(node.getUI().isChecked());
			arguments.callee(childNodeArray[i], false);
		}
	});
	patientTree.on('dblclick', function(node, e) {
		node.getUI().toggleCheck(true);
		Search_Click();
	});
	patientTree.on('load', function(node) {
	});
	patientTree.setHeight(patientTreeAutoHeight());
	var arrowPanel = Ext.getCmp('arrowPanel');
	var dhcdspPanel = Ext.getCmp('dhcdspPanel');
	arrowPanel.on('rowdblclick', function(grid, row, e) {
		arrow_Row_Double_Click(grid, row, e);
	});
	var workSpaceAutoHeight = function(id, on, th) {
		var viewPort = Ext.getCmp('viewPort');
		var arrowPanel = Ext.getCmp('arrowPanel');
		var dhcdspPanel = Ext.getCmp('dhcdspPanel');
		if (on == 'collapse') {
			if (id == 'arrowPanel') {
				if (dhcdspPanel.collapsed == false) {
					dhcdspPanel.setHeight(viewPort.getHeight() - arrowPanel.getHeight() - 6);
				}
			} else if (id == 'dhcdspPanel') {
				if (arrowPanel.collapsed == false) {
					arrowPanel.setHeight(viewPort.getHeight() - dhcdspPanel.getHeight() - 6);
				}
			}
		} else if (on == 'expand') {
			if (id == 'arrowPanel') {
				if (dhcdspPanel.collapsed == false) {
					dhcdspPanel.setHeight(viewPort.getHeight() * .5 - 3);
					arrowPanel.setHeight(viewPort.getHeight() * .5 - 3);
				} else {
					arrowPanel.setHeight(viewPort.getHeight() - dhcdspPanel.getHeight() - 6);	
				}
			} else if (id == 'dhcdspPanel') {
				if (arrowPanel.collapsed == false) {
					arrowPanel.setHeight(viewPort.getHeight() * .5 - 3);
					dhcdspPanel.setHeight(viewPort.getHeight() * .5 - 3);
				} else {
					dhcdspPanel.setHeight(viewPort.getHeight() - arrowPanel.getHeight() - 6);	
				}
			}	
		}
	};
	var viewPort = Ext.getCmp('viewPort');
	var totalHeight = viewPort.getHeight();
	arrowPanel.on('collapse', function(animate) {
		workSpaceAutoHeight(arrowPanel.id, 'collapse', totalHeight);
	}, this);
	arrowPanel.on('expand', function(animate) {
		workSpaceAutoHeight(arrowPanel.id, 'expand', totalHeight);
	}, this);
	dhcdspPanel.on('collapse', function(animate) {
		workSpaceAutoHeight(dhcdspPanel.id, 'collapse', totalHeight);
	}, this);
	dhcdspPanel.on('expand', function(animate) {
		workSpaceAutoHeight(dhcdspPanel.id, 'expand', totalHeight);
	}, this);
	var leftPanel = Ext.getCmp('leftPanel');
	var rightPanel = Ext.getCmp('rightPanel');
	rightPanel.setWidth(viewPort.getWidth() - leftPanel.getWidth() - 5);
	arrowPanel.setWidth(rightPanel.getWidth() - 8);
	dhcdspPanel.setWidth(rightPanel.getWidth() - 8);
	Search_Click();
}

function Search_Click() {
	var panel = Ext.getCmp('arrowPanel');
	if (panel.loading == true) {
		return false;
	}
	var pats = Ext.getCmp('patientTree').getChecked('id')
	if(pats.length == 0) {
		pats = EpisodeID || '';
	} else {
		pats = pats.join('^');
	}
	var regNo = tkMakeServerCall('Nur.Utility', 'getPatRegs', pats);
	var userId = session['LOGON.USERID'];
	var locId = session['LOGON.CTLOCID'];
	var StDate = Ext.getCmp('StDate').getRawValue();
	var StartTime = Ext.getCmp('StartTime').getRawValue();
	var EDate = Ext.getCmp('EDate').getRawValue();
	var EndTime = Ext.getCmp('EndTime').getRawValue();
	var ArcimID = Ext.getCmp('ArcimID').getValue();
	var ArcimDesc = Ext.getCmp('ArcimID').getRawValue();
	var RecLocId = Ext.getCmp('RecLocId').getValue();
	var RecLoc = Ext.getCmp('RecLocId').getRawValue();
	var parameterFieldStr = westconfig2; 
	var parameterFieldArray = parameterFieldStr.split('^');
	if (westconfig2 == '') {
		parameterFieldArray.length = 0;
	}
	var theFlags = '';
	for (var i = 0; i < parameterFieldArray.length; i++) {
		theFlags += (i == 0) ? '' : '^';
		theFlags += parameterFieldArray[i] + '|' + ((Ext.getCmp(parameterFieldArray[i]).getValue() == true) ? 'on' : '');
	}
	ArcimID += (ArcimID == '') ? '' : ('|' + ArcimDesc);
	RecLocId += (RecLocId == '') ? '' : ('|' + RecLoc);
	var auditBatchId = '';
	var RollFl = '';
	var paramObj = {
		userId: userId,
		locId: locId,
		StDate: StDate,
		StartTime: StartTime,
		EDate: EDate,
		EndTime: EndTime,
		Arcim: ArcimID,
		RecLoc: RecLocId,
		theFlags: theFlags,
		auditBatchId: auditBatchId,
		RollFl: RollFl,
		regNo: regNo,
		start: 0,
		limit: panel.getBottomToolbar().pageSize
	}
	ReloadData(panel, paramObj);
	var dhcdspPanel = Ext.getCmp('dhcdspPanel');
	var nullData = {
		rows: [],
		results: 0
	}
	dhcdspPanel.store.loadData(nullData);
	dhcdspPanel.collapse();
	panel.expand();
	return true;
}

function arrow_Row_Double_Click(grid, row, e) {
	var panel = Ext.getCmp('dhcdspPanel');
	if (panel.loading == true) {
		return false;
	}
	var userId = parameterObject[grid.id].userId;
	var rowData = grid.store.getAt(row).data;
	var process = rowData['Process'];
	var recLocId = rowData['recLocId'];
	var ArRow = rowData['ArRow'];
	var paramObj = {
		userId: userId,
		process: process,
		recLocId: recLocId,
		ArRow: ArRow,
		start: 0,
		limit: panel.getBottomToolbar().pageSize
	};
	ReloadData(panel, paramObj);
	var pogFlag = Ext.getCmp('pogFlag');
	pogFlag.setValue(false);
	grid.collapse();
	panel.expand();
	return true;
}

function Select_Row(id, row) {
	var panel = Ext.getCmp(id);
	id = id + 'chb' + '_';
	var sci = document.getElementById(id + row);
	var num = panel.store.getCount();
	if (row == 'a') {
		for (var i = 0; i < num; i++) {
			var ssi = document.getElementById(id + i);
			ssi.checked = sci.checked;
		}
		return;
	} else {
		var saf = sci.checked;
		var sai = document.getElementById(id + 'a');
		for (var i = 0; i < num; i++) {
			var ssi = document.getElementById(id + i);
			if (i == row) {
				continue;
			}
			if (ssi.checked != sci.checked) {
				saf = false;
				break;
			}
		}
		sai.checked = saf;
	}
	try {
		SelectRowHandler(id, row);
	} catch(e) {
	}
	
}

function SelectRowHandler(id, row) {
}

function Click_Button(pid, bid) {
	if (bid == 'btnArrowAudit') {
		try {
			Arrow_Audit(pid, bid);
		} catch(e) {
		}
	} else if (bid == 'btnDspensingAudit') {
		try {
			Dspensing_Audit(pid, bid);
		} catch(e) {
		}
	} else if (bid == 'btnDspensingCancel') {
		try {
			Dspensing_Cancel(pid, bid);
		} catch(e) {
		}
	} else if (bid == 'arrowPanelTitle') {
		var src = event.srcElement;
		src.blur();
		var grid = Ext.getCmp(pid);
		var panel = Ext.getCmp('dhcdspPanel');
		grid.expand();
		panel.expand();
	} else if (bid == 'dhcdspPanelTitle') {
		var src = event.srcElement;
		src.blur();
		var grid = Ext.getCmp(pid);
		var panel = Ext.getCmp('arrowPanel');
		grid.collapse();
		panel.expand();
	}
}

function Arrow_Audit(pid, bid) {
}

function Dspensing_Audit(pid, bid) {
}

function Dspensing_Cancel(pid, bid) {
}

Ext.onReady(function() {
	InitializeForm();
	InitializeValue();
});