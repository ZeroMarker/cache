/**
 * FileName: dhcbill.queuelist.js
 * Anchor: ShangXuehao
 * Date: 2021-08-18
 * Description: 叫号队列查询
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
	
	//业务类型
	var bizData = [{value: '', text: '全部'}];
	if (CV.QueueType == "IP") {
		bizData.push({value: 'IPReg', text: '住院登记'});
		bizData.push({value: 'IPDep', text: '住院押金'});
		bizData.push({value: 'IPPay', text: '住院收费'});
	}else {
		bizData.push({value: 'OPDep', text: '门诊预交金'});
		bizData.push({value: 'HDDep', text: '血透押金'});
		bizData.push({value: 'OPPay', text: '门诊收费'});
	}
	$HUI.combobox('#bizType', {
		panelHeight: 'auto',
		editable: false,
		valueField: 'value',
		textField: 'text',
		data: bizData
	});
	
	//叫号状态
	$("#calledStatus").keywords({
    	singleSelect: true,
    	labelCls: 'red',
    	items: [
        	{text: '未叫号', id: '0', selected: true},
        	{text: '已叫号', id: '1'},
        	{text: '已过号', id: '2'},
    	],
    	onClick: function(v) {
	    	var opt = {updateDate: '叫号时间', updateUser: '叫号人', calledClient: '叫号终端号'};
	    	if (v.id == 2) {
		    	$.each(Object.keys(opt), function(index, prop) {
					opt[prop] = opt[prop].replace(/叫号/g, '过号');
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
		columns: [[{title: '登记号', field: 'patNo', width: 120},
		           {title: '患者姓名', field: 'patName', width: 100},
				   {title: '队列号', field: 'queueNo', width: 100},
			       {title: '生成队列终端号', field: 'creatServer', width: 130},
				   {title: '生成队列时间', field: 'creatDate', width: 155,
				    formatter: function (value, row, index) {
						if (value) {
							return value + " " + row.creatTime;
						}
					}
				   },
				   {title: '生成队列人', field: 'creatUser', width: 120},
				   {title: '业务类型', field: 'bizType', width: 100},
				   {title: '叫号时间', field: 'updateDate', width: 155,
				   	formatter: function (value, row, index) {
						if (value) {
							return value + " " + row.updateTime;
						}
					}
				   },
				   {title: '叫号人', field: 'updateUser', width: 120},
				   {title: '叫号终端号', field: 'calledClient', width: 120},
				   {title: '叫号次数', field: 'calledNum', width: 100},
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