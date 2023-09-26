/// EH 2014-05-04
function Arrow_Audit(pid, bid) {
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
	if (stockflag == true) {
		try {
			var isSE = tkMakeServerCall(classconfig, 'isStockEnough', ArRowStr, recloc, arcqty);
			var arr1= isSE.split('^');
			if ((arr1[2] == 'N') || (arr1[3] == 'N')) {
				Ext.Msg.show({
				title: '提示',
				msg: arr1[4],
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.WARNING
				});
				if (((arr1[0] == 'Y') && ((arr1[2] == 'N'))) || ((arr1[1] == 'Y') && ((arr1[3] == 'N')))) {
					return false;
				}
			}
		} catch(e1) {
		}
	}
	var userId = parameterObject[pid].userId;
	var params = {
		className: classconfig,
		methodName: 'AuditMed',
		userId: userId,
		process: process,
		ArRowStr: ArRowStr
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
		if (((typ == 'Y') && (Audit == '| ')) || ((typ == 'N') && (Audit != '| '))) {
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
	if (selectqty > 0) {
		try {
			var isSE = tkMakeServerCall(classconfig, 'isStockEnough', ArcRow, recLocId, selectqty);
			var arr1= isSE.split('^');
			if ((arr1[2] == 'N') || (arr1[3] == 'N')) {
				Ext.Msg.show({
				title: '提示',
				msg: arr1[4],
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.WARNING
				});
				if (((arr1[0] == 'Y') && ((arr1[2] == 'N'))) || ((arr1[1] == 'Y') && ((arr1[3] == 'N')))) {
					return false;
				}
			}
		} catch(e1) {
		}
	}
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