/**
 * FileName: dhcbill.queuelist.js
 * Anchor: ShangXuehao
 * Date: 2021-08-18
 * Description: �кŶ��в�ѯ
 */

$(function () {
	initQueryMenu();
	initQueueList();
});

function initQueryMenu() {
	$(".datebox-f").datebox("setValue",CV.DefDate);
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadCallList();
		}
	});
	
	//ҵ������
	var bizData = [{value: '', text: 'ȫ��'}];
	if (CV.QueueType == "IP") {
		bizData.push({value: 'IPReg', text: 'סԺ�Ǽ�'});
		bizData.push({value: 'IPDep', text: 'סԺѺ��'});
		bizData.push({value: 'IPPay', text: 'סԺ�շ�'});
	}else {
		bizData.push({value: 'OPDep', text: '����Ԥ����'});
		bizData.push({value: 'HDDep', text: 'Ѫ͸Ѻ��'});
		bizData.push({value: 'OPPay', text: '�����շ�'});
	}
	$HUI.combobox('#bizType', {
		panelHeight: 'auto',
		editable: false,
		valueField: 'value',
		textField: 'text',
		data: bizData
	});
	
	//�к�״̬
	$("#calledStatus").keywords({
    	singleSelect: true,
    	labelCls: 'red',
    	items: [
        	{text: 'δ�к�', id: '0', selected: true},
        	{text: '�ѽк�', id: '1'},
        	{text: '�ѹ���', id: '2'},
    	],
    	onClick: function(v) {
	    	var opt = {updateDate: '�к�ʱ��', updateUser: '�к���', calledClient: '�к��ն˺�'};
	    	if (v.id == 2) {
		    	$.each(Object.keys(opt), function(index, prop) {
					opt[prop] = opt[prop].replace(/�к�/g, '����');
				});
		    }
		    GV.QueueList.setColumnTitle(opt);
	    	loadCallList();
	    }
	});
}

function initQueueList() {
	GV.QueueList = $HUI.datagrid("#queueList", {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		columns: [[{title: '�ǼǺ�', field: 'patNo', width: 120},
		           {title: '��������', field: 'patName', width: 100},
				   {title: '���к�', field: 'queueNo', width: 100},
			       {title: '���ɶ����ն˺�', field: 'creatServer', width: 130},
				   {title: '���ɶ���ʱ��', field: 'creatDate', width: 155,
				    formatter: function (value, row, index) {
						if (value) {
							return value + " " + row.creatTime;
						}
					}
				   },
				   {title: '���ɶ�����', field: 'creatUser', width: 120},
				   {title: 'ҵ������', field: 'bizType', width: 100},
				   {title: '�к�ʱ��', field: 'updateDate', width: 155,
				   	formatter: function (value, row, index) {
						if (value) {
							return value + " " + row.updateTime;
						}
					}
				   },
				   {title: '�к���', field: 'updateUser', width: 120},
				   {title: '�к��ն˺�', field: 'calledClient', width: 120},
				   {title: '�кŴ���', field: 'calledNum', width: 100},
				   {title: 'queueId', field: 'queueId', hidden: true}
			]],
		url: $URL,
		queryParams: {
			ClassName: "BILL.AUX.BL.CallQueue",
			QueryName: "QryQueueList",
			stDate: getValueById("stDate"),
			endDate: getValueById("endDate"),
			queueType: CV.QueueType,
			bizType: getValueById("bizType"),
			calledStatus: (($("#calledStatus").keywords("getSelected").length > 0) ? $("#calledStatus").keywords("getSelected")[0].id : ""),
			sessionStr: getSessionStr()
		}
	});
}

function loadCallList() {
	var queryParams = {
		ClassName: "BILL.AUX.BL.CallQueue",
		QueryName: "QryQueueList",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		queueType: CV.QueueType,
		bizType: getValueById("bizType"),
		calledStatus: (($("#calledStatus").keywords("getSelected").length > 0) ? $("#calledStatus").keywords("getSelected")[0].id : ""),
		sessionStr: getSessionStr()
	}
	loadDataGridStore("queueList", queryParams);
}