/**
 * FileName: dhcbill.pkg.dailyhand.js
 * Anchor: ZhYW
 * Date: 2019-01-04
 * Description: �ײ��շ��ս�
 */

var PUBLIC_CONSTANT = {
	SESSION: {
		GUSER_ROWID: session['LOGON.USERID'],
		GROUP_ROWID: session['LOGON.GROUPID'],
		HOSP_ROWID: session['LOGON.HOSPID']
	},
	METHOD: {
		CLS: 'DHCBILL.Package.BusinessLogic.DHCPkgDailyHandin',
		HANDIN: 'Handin'
	}
};

var m_WinObj;

$(function () {
	initSearchPanel();
});

function initSearchPanel() {
	var options = {
		onClick: function () {
			find_Click();
		}
	};
	var btnFindObj = $HUI.linkbutton('#btnFind', options);

	var options = {
		onClick: function () {
			handin_Click(this.id);
		}
	};
	var btnHandinObj = $HUI.linkbutton('#btnHandin', options);

	setDateTime(false);

	var options = {
		onCheckChange: function (e, value) {
			setDateTime(value);
		}
	};
	var checkHandObj = $HUI.checkbox('#checkHand', options);
}

function setDateTime(checked) {
	if (!checked) {
		$.m({
			ClassName: PUBLIC_CONSTANT.METHOD.CLS,
			MethodName: "GetStDate",
			guser: PUBLIC_CONSTANT.SESSION.GUSER_ROWID,
			hospDR: PUBLIC_CONSTANT.SESSION.HOSP_ROWID,
		}, function (txtData) {
			var myAry = txtData.split('^');
			var stDate = myAry[0];
			var stTime = myAry[1];
			var endDate = myAry[2];
			var endTime = myAry[3];
			var stDateTime = stDate + " " + stTime;
			var endDateTime = endDate + " " + endTime;
			ableDateTimeBox(true);
			$('#footId').val(""); //ȡ����ѡʱ��������Id����
			$('#stDateTime').datetimebox('setValue', stDateTime);
			$('#endDateTime').datetimebox('setValue', endDateTime);
		});
		$('#btnHandin').linkbutton('enable'); //���㰴ť��Ϊenable
	} else {
		$.m({
			ClassName: "web.UDHCJFBaseCommon",
			MethodName: "FormDateTime",
			Date: "",
			Time: ""
		}, function (txtData) {
			ableDateTimeBox(false);
			var curDateTime = txtData;
			$('#stDateTime').datetimebox('setValue', curDateTime);
			$('#endDateTime').datetimebox('setValue', curDateTime);
		});
		$('#btnHandin').linkbutton('disable'); //���㰴ť��Ϊdisable
	}
}

function ableDateTimeBox(disabled) {
	$('#stDateTime').datetimebox({
		disabled: disabled
	});
	$('#endDateTime').datetimebox({
		disabled: disabled
	});
}

function find_Click() {
	var stDateTime = $('#stDateTime').datetimebox('getValue');
	var endDateTime = $('#endDateTime').datetimebox('getValue');
	var stDateTimeAry = stDateTime.split(" ");
	var stDate = stDateTimeAry[0];
	var endDateTimeAry = endDateTime.split(" ");
	var endDate = endDateTimeAry[0];
	guser = PUBLIC_CONSTANT.SESSION.GUSER_ROWID;
	var handinFlag = $('#checkHand').checkbox('getValue');
	if (handinFlag) {
		var url = 'dhcbill.pkg.dailyreports.csp?&stDate=' + stDate + '&endDate=' + endDate + '&guser=' + guser;
		var content = '<iframe src="' + url + '" width="100%" height="100%" frameborder="0"></iframe>';
		m_WinObj = $HUI.window('#winDailyReports', {
				width: 750,
				height: 500,
				title: '�ײ��ս���ʷ',
				collapsible: false,
				minimizable: false,
				maximizable: false,
				isZindexTop: true, //ǿ���ö�
				border: false,
				closed: true,
				content: content
			});
		m_WinObj.open();
	} else {
		loadSelDetails();
	}
}

/**
 * Creator: ZhYW
 * CreatDate: 2018-03-05
 * Description: ����
 */
function handin_Click(btnId) {
	setDateTime(false); //����ʱ������Ϊ��ǰʱ��
	$.messager.confirm('ȷ��', '�Ƿ����?', function (r) {
		if (r) {
			var stDateTime = $('#stDateTime').datetimebox('getValue');
			var endDateTime = $('#endDateTime').datetimebox('getValue');
			stDateTime = stDateTime.replace(" ", "^");
			endDateTime = endDateTime.replace(" ", "^");
			var footInfo = stDateTime + "^" + endDateTime + "^" + "N" + "^" + "N";
			$.m({
				ClassName: PUBLIC_CONSTANT.METHOD.CLS,
				MethodName: PUBLIC_CONSTANT.METHOD.HANDIN,
				guser: PUBLIC_CONSTANT.SESSION.GUSER_ROWID,
				hospDR: PUBLIC_CONSTANT.SESSION.HOSP_ROWID,
				footInfo: footInfo
			}, function (txtData) {
				var myAry = txtData.split('^');
				var success = myAry[0];
				if (success == 0) {
					$.messager.alert('��Ϣ', '����ɹ�.', 'info');
					$('#footId').val(error); //����RowId
					$('#btnHandin').linkbutton('disable');
					loadSelDetails(); //ˢ�µ�ǰѡ�е�tab
				} else {
					$.messager.alert('��Ϣ', '����ʧ��, �������: ' + success, 'error');
				}
			});
		}
	});
}

/**
 * Creator: ZhYW
 * CreatDate: 2018-03-15
 * Description: ����iframeҳǩ��ϸ����
 */
function loadSelDetails() {
	var iframe = $('#tabMain')[0].contentWindow;
	if (iframe) {
		iframe.loadSelTabsContent();
	}
}
