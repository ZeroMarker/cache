/// EH 2014-05-04

function isAuditChecked(pid) {
	var theFlags = parameterObject[pid].theFlags || '';
	var theFlagsArray = theFlags.split('^');
	if (theFlags == '') {
		theFlagsArray.length = 0;
	}
	for (var i = 0; i < theFlagsArray.length; i++) {
		var theFlagsSubArray = theFlagsArray[i].split('|');
		if ((theFlagsSubArray[0] == 'typ') || (theFlagsSubArray[0] == 'Audittyp')) { // 已发 / 已审
			if (theFlagsSubArray[1] == 'on') {
				return true;
			}
		}
	}
	return false;
}
function Cancel_Audit(pid, bid) {

	var panel = Ext.getCmp(pid);
	if (panel.loading == true) {
		return false;
	}
	if (parameterObject[pid] == undefined) {
		return false;
	}

	if (isAuditChecked(pid) == false) {
		return false;
	}

	var id = pid + 'chb' + '_';
	var num = panel.store.getCount();
	var process = '';
	var ArRowStr = '';
	var recloc = '';
	var arcqty = '';
	var count = 0;
	var stockflag = true;
	for (var i = 0; i < num; i++) {
		var ssi = document.getElementById(id + i);
		if (ssi.checked == false) {
			continue;
		}
		var rowData = panel.store.getAt(i).data;
		var ArRow = rowData['ArRow'];
		var locid = rowData['recLocId'];
		var qty = rowData['Qty'];
		if ((!locid) || (!qty)) {
			stockflag = false;
		}
		(process == '') ? (process = rowData['Process']) : '';
		if (count > 0) {
			ArRowStr += '^';
			recloc += '^';
			arcqty += '^';
		}
		ArRowStr += ArRow;
		recloc += locid;
		arcqty += qty;
		count++;
	}
	if (ArRowStr == '') {
		return false;
	}

	if (searchward != thisward) {
		Ext.Msg.show({
			title: '提示',
			msg: '不能审核非本病区!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return false;
	}
	if (thispatregno != '') {
		if (thispatregno == searchpatregno) {
			if (thispatward != thisward) {
				Ext.Msg.show({
					title: '提示',
					msg: '不能审核非本病区!',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return false;
			}
		}
	}
	var userId = parameterObject[pid].userId;
	var params = {
		className: classconfig,
		methodName: 'CancelAuditMed',
		userId: userId,
		process: process,
		ArRowStr: ArRowStr,
		RecLocStr:recloc
	};
	var button = Ext.getCmp(bid);
	button.Ajax.request(params, function() {
		Search_Click();
	});
	return true;
}
function Arrow_Audit(pid, bid) {

	if (isAuditChecked(pid) == true) {
		alert("已审核药品不能再次审核!")
		return false;
	}
	var panel = Ext.getCmp(pid);
	if (panel.loading == true) {
		return false;
	}
	if (parameterObject[pid] == undefined) {
		return false;
	}
	if (parameterObject[pid].Audittyp == 'on') {
		return false;
	}
	var id = pid + 'chb' + '_';
	var num = panel.store.getCount();
	var process = '';
	var ArRowStr = '';
	var recloc = '';
	var arcqty = '';
	var count = 0;
	var stockflag = true;
	for (var i = 0; i < num; i++) {
		var ssi = document.getElementById(id + i);
		if (ssi.checked == false) {
			continue;
		}
		var rowData = panel.store.getAt(i).data;
		var ArRow = rowData['ArRow'];
		var locid = rowData['recLocId'];
		var qty = rowData['Qty'];
		if ((!locid) || (!qty)) {
			stockflag = false;
		}
		(process == '') ? (process = rowData['Process']) : '';
		if (count > 0) {
			ArRowStr += '^';
			recloc += '^';
			arcqty += '^';
		}
		ArRowStr += ArRow;
		recloc += locid;
		arcqty += qty;
		count++;
	}
	if (ArRowStr == '') {
		return false;
	}
	var ward = Ext.getCmp('wardId');
	if (ward.getValue() != session['LOGON.WARDID']) {
		Ext.Msg.show({
			title: '提示',
			msg: '不能审核非本病区!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return false;
	}

	var pogFlagall = Ext.getCmp('pogFlagall').getValue();
	var userId = parameterObject[pid].userId;
	var params = {
		className: classconfig,
		methodName: 'AuditMed',
		userId: userId,
		process: process,
		ArRowStr: ArRowStr,
		recLocIdStr:recloc,
		pogFlagall: (pogFlagall == true) ? 'on' : ''
	};
	var button = Ext.getCmp(bid);
	button.Ajax.request(params, function() {
		Search_Click();
	});
	return true;
}



function GetSelceteddsp(pid, typ) {
	var panel = Ext.getCmp(pid);
	var id = pid + 'chb' + '_';
	var num = panel.store.getCount();
	var dhcDspIdStr = '';
	selectqty = 0;
	for (var i = 0; i < num; i++) {
		var ssi = document.getElementById(id + i);
		if (ssi.checked == false) {
			continue;
		}
		var rowData = panel.store.getAt(i).data;
		var Audit = rowData['Audit'];
		var dhcDspId = rowData['dhcDspId'];
		var qty = rowData['Qty'] || '0';
		if (((typ == 'Y') && (Audit == '')) || ((typ == 'N') && (Audit != ''))) {
			dhcDspIdStr += (dhcDspIdStr == '') ? dhcDspId : '^' + dhcDspId;
			if ((typ == 'Y') && (qty)) {
				selectqty += parseInt(qty);
			}
		}
	}
	return dhcDspIdStr;
}

function Dspensing_Audit(pid, bid) {
	var panel = Ext.getCmp(pid);
	if (panel.loading == true) {
		return false;
	}
	if (parameterObject[pid] == undefined) {
		return false;
	}
	var dhcDspIdStr = GetSelceteddsp(pid, 'Y');
	if (dhcDspIdStr == '') {
		return false;
	}
	var ward = Ext.getCmp('wardId');
	if (ward.getValue() != session['LOGON.WARDID']) {
		Ext.Msg.show({
			title: '提示',
			msg: '不能审核非本病区!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return false;
	}
	var userId = parameterObject[pid].userId;
	var process = parameterObject[pid].process;
	var recLocId = parameterObject[pid].recLocId;
	var ArcRow = parameterObject[pid].ArRow;
	var pogFlag = Ext.getCmp('pogFlag').getValue();
	var auditBatchId = '';

	var params = {
		className: classconfig,
		methodName: 'PhAudit',
		dhcDspIdStr: dhcDspIdStr,
		userId: userId,
		ArcRow: ArcRow,
		locId: recLocId,
		auditBatchId: auditBatchId,
		pogFlag: (pogFlag == true) ? 'on' : '',
		process: process
	};
	var button = Ext.getCmp(bid);
	button.Ajax.request(params, function() {
		panel.store.reload();
	});
	return true;
}

function Dspensing_Cancel(pid, bid) {
	var panel = Ext.getCmp(pid);
	if (panel.loading == true) {
		return false;
	}
	if (parameterObject[pid] == undefined) {
		return false;
	}
	var dhcDspIdStr = GetSelceteddsp(pid, 'N');
	if (dhcDspIdStr == '') {
		return false;
	}
	var ward = Ext.getCmp('wardId');
	if (ward.getValue() != session['LOGON.WARDID']) {
		Ext.Msg.show({
			title: '提示',
			msg: '不能审核非本病区!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return false;
	}
	var userId = parameterObject[pid].userId;
	var process = parameterObject[pid].process;
	var params = {
		className: classconfig,
		methodName: 'UnAudit',
		dhcDspIdStr: dhcDspIdStr,
		userId: userId,
		process: process
	};
	var button = Ext.getCmp(bid);
	button.Ajax.request(params, function() {
		panel.store.reload();
	});
	return true;
}
function btnStoppog_click(pid, bid) {
	var panel = Ext.getCmp(pid);
	if (panel.loading == true) {
		return false;
	}
	if (parameterObject[pid] == undefined) {
		return false;
	}
	if (isAuditChecked(pid) == false) {
		alert("请查询已审药品!")
		return false;
	}
	var id = pid + 'chb' + '_';
	var num = panel.store.getCount();
	var process = '';
	var ArRowStr = '';
	var recloc = '';
	var arcqty = '';
	var count = 0;
	var stockflag = true;
	for (var i = 0; i < num; i++) {
		var ssi = document.getElementById(id + i);
		if (ssi.checked == false) {
			continue;
		}
		var rowData = panel.store.getAt(i).data;
		var ArRow = rowData['ArRow'];
		var locid = rowData['recLocId'];
		var qty = rowData['Qty'];
		if ((!locid) || (!qty)) {
			stockflag = false;
		}
		(process == '') ? (process = rowData['Process']) : '';
		if (count > 0) {
			ArRowStr += '^';
			recloc += '^';
			arcqty += '^';
		}
		ArRowStr += ArRow;
		recloc += locid;
		arcqty += qty;
		count++;
	}
	if (ArRowStr == '') {
		return false;
	}
	if (searchward != thisward) {
		Ext.Msg.show({
			title: '提示',
			msg: '不能审核非本病区!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return false;
	}
	if (thispatregno != '') {
		if (thispatregno == searchpatregno) {
			if (thispatward != thisward) {
				Ext.Msg.show({
					title: '提示',
					msg: '不能审核非本病区!',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return false;
			}
		}
	}
	var pogFlagall = Ext.getCmp('pogFlagall').getValue();

	//	var userId = parameterObject[pid].userId;
	//	var msg=tkMakeServerCall("web.DrugAuditNew","SendMeg",ArRowStr,userId,process);
	var userId = parameterObject[pid].userId;
	var params = {
		className: classconfig,
		methodName: 'SendMeg',
		ArRowStr: ArRowStr,
		userId: userId,
		process: process
	};

	var button = Ext.getCmp(bid);
	button.Ajax.request(params, function() {
		Search_Click();
	});
	return true;
}
function GetSelceteddspnew(pid, typ) {
	var panel = Ext.getCmp(pid);
 
	var id = pid + 'chb' + '_';
	var num = panel.store.getCount();
	var dhcDspIdStr = '';
	selectqty = 0;
	for (var i = 0; i < num; i++) {
		var ssi = document.getElementById(id + i);
		if (ssi.checked == false) {
			continue;
		}
		var rowData = panel.store.getAt(i).data;
		var Audit = rowData['Audit'];
		var dhcDspId = rowData['dhcDspId'];
		var qty = rowData['Qty'] || '0';
 
		if ((typ == 'Y') && (Audit != '| ')) {
			dhcDspIdStr += (dhcDspIdStr == '') ? dhcDspId : '^' + dhcDspId;
			if ((typ == 'Y') && (qty)) {
				selectqty += parseInt(qty);
			}
		}
	}
	return dhcDspIdStr;
}
function btnbtnStoppogMX_click(pid, bid) {

	if (isAuditChecked(arrowPanel.id) == false) {
		alert("请查询已审药品!");
		return;
	}

	var panel = Ext.getCmp(pid);
	if (panel.loading == true) {
		return false;
	}
	if (parameterObject[pid] == undefined) {
		return false;
	}

	var dhcDspIdStr = GetSelceteddspnew(pid, 'Y');

	if (dhcDspIdStr == '') {
		return false;
	}

	if (searchward != thisward) {
		Ext.Msg.show({
			title: '提示',
			msg: '不能审核非本病区!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return false;
	}

	if (thispatregno != '') {
		if (thispatregno == searchpatregno) {
			if (thispatward != thisward) {
				Ext.Msg.show({
					title: '提示',
					msg: '不能审核非本病区!',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return false;
			}
		}
	}
	var userId = parameterObject[pid].userId;
	var process = parameterObject[pid].process;
	var recLocId = parameterObject[pid].recLocId;
	var ArcRow = parameterObject[pid].ArRow;
	var pogFlag = Ext.getCmp('pogFlag').getValue();


	var params = {
		className: classconfig,
		methodName: 'SetpogflagDetail',
		dhcDspIdStr: dhcDspIdStr,
		userId: userId,
		process: process
	};
	var button = Ext.getCmp(bid);
	button.Ajax.request(params, function() {
		panel.store.reload();
	});
	return true;
}

