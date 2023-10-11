/**
 * @Author      yaojining
 * @DateTime    2020-03-09
 * @description ����ʱ������
 */
$(function() { 
	var GLOBAL = {
		HospEnvironment: true,
		HospitalID: session['LOGON.HOSPID']
	};
	/**
	 * @description ��ʼ������
	 */
	function initUI() {
		initCondition();
		getInOutConfig();
		getRecordConfig();
		listenEvents();
	}
	/**
	 * @description ��ʼ��ҽԺ
	 */
	function initHosp(){
		if (typeof GenHospComp == "undefined") {
			GLOBAL.HospEnvironment = false;
		}
		if(GLOBAL.HospEnvironment){
			var hospComp = GenHospComp('Nur_IP_DHCNurEmrConfig', session['LOGON.USERID'] + '^' + session['LOGON.GROUPID'] + '^' + session['LOGON.CTLOCID'] + '^' + GLOBAL.HospitalID);  
			hospComp.options().onSelect = function(q, row){
				GLOBAL.HospitalID = row.HOSPRowId;
				getInOutConfig();
				getRecordConfig();
			}
		}else{
			$m({
				ClassName: 'NurMp.Common.Base.Hosp', 
				MethodName: 'hospitalName', 
				HospitalID: GLOBAL.HospitalID
			},function(hospDesc){
				$HUI.combobox("#_HospList", {
					width:350,
					valueField: 'HOSPRowId',
					textField: 'HOSPDesc',
					data: [{
						HOSPRowId: GLOBAL.HospitalID,
						HOSPDesc: hospDesc
					}],
					value: GLOBAL.HospitalID,
					disabled: true
				});
			});
		}
	}
	/**
	 * @description ��ʼ������
	 */
	function initCondition() {
		initHosp();
		$HUI.combobox('#comboRecordDate', {
			valueField: 'id',
			textField: 'text',
			value: 4,
			data:[
				{id:1, text:"��������д����֮���¼"},
				{id:2, text:"��������д����֮���¼"},
				{id:3, text:"��������дһ��֮���¼"},
				{id:4, text:"��������д��ǰ�졢���졢����ļ�¼"},
				{id:5, text:"��������"}
			],
			onChange: function(newval, oldval) {
				if ((newval != 1) && (newval != '��������д����֮���¼')){
					$('#comboRecordTime').combobox('setValue','');
					$('#comboRecordTime').combobox('disable');
				}else{
					$('#comboRecordTime').combobox('enable');
				}
			} 
		});
		$HUI.combobox('#comboRecordTime', {
			valueField: 'id',
			textField: 'text',
			value: 8,
			data:[
				{id:1, text:"0"},
				{id:2, text:"0.5"},
				{id:3, text:"1"},
				{id:4, text:"1.5"},
				{id:5, text:"2"},
				{id:6, text:"2.5"},
				{id:7, text:"3"},
				{id:8, text:"����ʱ��"}
			], 
		});
		$HUI.combobox('#comboOneTimeRecords', {
			valueField: 'id',
			textField: 'text',
			value: 1,
			data:[
				{id:1, text:"����"},
				{id:2, text:"������"}
			], 
		});
	}
	/**
	 * @description ��ѯ����Һ����Ϣ
	 */
	function getInOutConfig() {
		$m({
			ClassName:"NurMp.DHCNurEmrConfig",
			MethodName:"GetId",
			type: 'TJ',
			HospitalID: GLOBAL.HospitalID 
		},function(anaesID){
			if (!!anaesID) {
				$m({
					ClassName:"NurMp.DHCNurEmrConfig",
					MethodName:"getBindInfo",
					rowid: anaesID
				},function(ret){
					var configArr = ret.split("^");
					$('#dayStartTime').timespinner('setValue', configArr[0]);
					$('#dayEndTime').timespinner('setValue', configArr[1]);
					$('#partStartTime').timespinner('setValue', configArr[2]);
					$('#partEndTime').timespinner('setValue', configArr[3]);
					$('#DisplayTitle24').val(configArr[4]);
					$('#DisplayTitleDay').val(configArr[5]);
				});
			}else{
				$('#dayStartTime').timespinner('setValue', "");
				$('#dayEndTime').timespinner('setValue', "");
				$('#partStartTime').timespinner('setValue', "");
				$('#partEndTime').timespinner('setValue', "");
				$('#DisplayTitle24').val("");
				$('#DisplayTitleDay').val("");
			}
		});
	}
	/**
	 * @description ��ѯ��¼��Ϣ
	 */
	function getRecordConfig() {
		$m({
			ClassName:"NurMp.DHCNurEmrConfig",
			MethodName:"GetId",
			type: 'Limit',
			HospitalID: GLOBAL.HospitalID
		},function(anaesID){
			if (!!anaesID) {
				$m({
					ClassName:"NurMp.DHCNurEmrConfig",
					MethodName:"getLimitBindInfo",
					rowid: anaesID
				},function(ret){
					var configArr = ret.split("^");
					$('#comboRecordDate').combobox('select', configArr[0]);
					$('#comboRecordTime').combobox('select', configArr[1]);
					$('#comboOneTimeRecords').combobox('select', configArr[2]);
				});
			}else{
				$('#comboRecordDate').combobox('select', '��������');
				$('#comboRecordTime').combobox('select', '����ʱ��');
				$('#comboOneTimeRecords').combobox('select', "����");
			}
		});
	}
	/**
	 * @description �¼�����
	 */
	function listenEvents() {
		$('#btnSaveInOut').click(function(e) {
			var dayStartTime=$('#dayStartTime').timespinner('getValue');
			var dayEndTime=$('#dayEndTime').timespinner('getValue');
			var partStartTime=$('#partStartTime').timespinner('getValue');
			var partEndTime=$('#partEndTime').timespinner('getValue');
			if (((dayStartTime!='')&&(dayEndTime==''))||((dayStartTime=='')&&(dayEndTime!=''))) {
				$.messager.popover({
					msg: '��ʼ�����ʱ�䲻��Ϊ��!',
					type: 'error'
				});
				return;
			}
			if (((partStartTime!='')&&(partEndTime==''))||((partStartTime=='')&&(partEndTime!=''))) {
				$.messager.popover({
					msg: '��ʼ�����ʱ�䲻��Ϊ��!',
					type: 'error'
				});
				return;
			}
			$m({
				ClassName: "NurMp.DHCNurEmrConfig",
				MethodName: "GetId",
				type: "TJ",
				HospitalID: GLOBAL.HospitalID 
			},function(anaesID){
				anaesID = !!anaesID ? anaesID : '';
				var parr = "TJ^" + dayStartTime + "^" + dayEndTime + "^";
				parr += partStartTime + "^" + partEndTime + "^";
				parr += $('#DisplayTitle24').val() + "^" + $('#DisplayTitleDay').val(); 
				$m({
					ClassName: "NurMp.DHCNurEmrConfig",
					MethodName: "save",
					parr: parr,
					user: session['LOGON.USERCODE'],
					id: anaesID,
					HospitalID: GLOBAL.HospitalID
				},function(ret){
					if (ret == '0') {
						$.messager.popover({
	    					msg: '����ɹ�!',
	    					type: 'success'
	    				});
					}else {
						$.messager.popover({
	    					msg: ret,
	    					type: 'error'
	    				});
					}
				});
			});
		});
		$('#btnSaveRec').click(function(e) {
			$m({
				ClassName: "NurMp.DHCNurEmrConfig",
				MethodName: "GetId",
				type: "Limit",
				HospitalID: GLOBAL.HospitalID
			},function(anaesID){
				anaesID = !!anaesID ? anaesID : '';
				var parr = "Limit^" + $('#comboRecordDate').combobox('getText') + "^" + $('#comboRecordTime').combobox('getText') + "^" + $('#comboOneTimeRecords').combobox('getText');
				$m({
					ClassName: "NurMp.DHCNurEmrConfig",
					MethodName: "RecLimitsave",
					parr: parr,
					user: session['LOGON.USERCODE'],
					id: anaesID,
					HospitalID: GLOBAL.HospitalID
				},function(ret){
					if (ret == '0') {
						$.messager.popover({
	    					msg: '����ɹ�!',
	    					type: 'success'
	    				});
					}else {
						$.messager.popover({
	    					msg: ret,
	    					type: 'error'
	    				});
					}
				});
			});
		})
	}
	initUI();
});