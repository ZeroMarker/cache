/**
 * FileName: dhcbill.ipbill.patbatch.audit.js
 * Author: luochaoyue
 * Date: 2022-12-12
 * Description: 住院批量审核
 */
 
$(function () {
	initQueryMenu();
	initPatList();
});

function initQueryMenu() {
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadPatList();
		}
	});
	
	//身份证号回车查询事件
	$("#IDNo").keydown(function (e) {
		IDNoKeydown(e);
	});
	
	$HUI.combobox("#auditStatus", {
		panelHeight: 'auto',
		editable: false,
		data: [{value: 'N', text: $g('未审核'), selected: true},
			   {value: 'Y', text: $g('已审核')}
			],
		valueField: 'value',
		textField: 'text'
	});
}

function initPatList() {
	var toolbar = [{
			text: '审核',
			iconCls: 'icon-stamp',
			handler: function () {
				auditClick();
			}
		}, {
			text: '撤销审核',
			iconCls: 'icon-stamp-cancel',
			handler: function () {
				cancelClick();
			}
		}];
	GV.PatList = $HUI.datagrid("#patList", {
		fit: true,
		border: false,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		toolbar: toolbar,
		idField: 'Id',
		className: 'BILL.IP.BL.BatchReg',
		queryName: 'QryRefePatList',
		frozenColumns: [[ {field: 'ck', checkbox: true},
						  {title: '患者姓名', field: 'PatName', width: 100},
						  {title: '性别', field: 'PatSex', width: 60},
						  {title: '年龄', field: 'PatAge', width: 60},
						  {title: '身份证号', field: 'PatID', width: 160}
			]],
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["PatName", "PatSex", "PatAge", "PatID", "CreatDate", "AuditDate", "UpdtUser", "UpdtDate", "UpdtTime"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["Id", "IsRegisted"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "CreatTime") {
					cm[i].formatter = function (value, row, index) {
						return row.CreatDate + " " + value;
					}
				}
				if (cm[i].field == "AuditTime") {
					cm[i].formatter = function (value, row, index) {
						return row.AuditDate + " " + value;
					}
				}
				if ($.inArray(cm[i].field, ["Address", "PatContactHistory"]) != -1) {
					cm[i].showTip = true;
				}
				if (cm[i].field == "IsAudited") {
					cm[i].formatter = function (value, row, index) {
						var color = (value == "Y") ? "#21ba45" : "#f16e57";
						return "<font color=\"" + color + "\">" + ((value == "Y") ? $g("是") : $g("否")) + "</font>";
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "Address") {
						cm[i].width = 200;
					}
					if (cm[i].field == "PatContactHistory") {
						cm[i].width = 150;
					}
					if ($.inArray(cm[i].field, ["CreatTime", "AuditTime"]) != -1) {
						cm[i].width = 160;
					}
				}
			}
		}
	});
}

function loadPatList() {
	var queryParams = {
		ClassName: "BILL.IP.BL.BatchReg",
		QueryName: "QryRefePatList",
		IDNo: getValueById("IDNo"),
		isAudited: getValueById("auditStatus"),
		isRegisted: "",
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}
	loadDataGridStore("patList", queryParams);
}

function IDNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		loadPatList();
	}
}

/**
* 审核
*/
function auditClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			refeIdAry = GV.PatList.getChecked().filter(function(row) {
				if (row.IsAudited == "Y") {
					return false;
				}
				if (row.IsRegisted == "Y") {
					return false;
				}
				return (row.Id > 0);
			}).map(function(row) {
				return row.Id;
			});
			if (refeIdAry.length == 0) {
				$.messager.popover({msg: "请选择待审核记录", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "确认审核？", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _audit = function() {
		return new Promise(function (resolve, reject) {
			$.m({
		    	ClassName: "BILL.IP.BL.BatchReg",
		    	MethodName: "Audit",
		    	refeIdAry: refeIdAry,
		    	userId: PUBLIC_CONSTANT.SESSION.USERID
		    }, function(rtn) {
			    var myAry = rtn.split("^");
			    if (myAry[0] == 0) {
				    $.messager.popover({msg: "审核成功", type: "success"});
		            return resolve();
		        }
		        $.messager.popover({msg: "审核失败：" + (myAry[1] || myAry[0]), type: "error"});
		      	reject();
			});
		});
	};
	
	var _success = function() {
		GV.PatList.reload();
	};
	
	var $this = $(event.target);
	if ($this.prop("disabled")) {
		return;
	}
	$this.prop("disabled", true);
	
	var refeIdAry = [];
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_audit)
		.then(function() {
			_success();
			$this.prop("disabled", false);
		}, function() {
			$this.prop("disabled", false);
		});
}

/**
* 撤销审核
*/
function cancelClick() {	
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			refeIdAry = GV.PatList.getChecked().filter(function(row) {
				if (row.IsAudited != "Y") {
					return false;
				}
				if (row.IsRegisted == "Y") {
					return false;
				}
				return (row.Id > 0);
			}).map(function(row) {
				return row.Id;
			});
			if (refeIdAry.length == 0) {
				$.messager.popover({msg: "请选择待撤销审核记录", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "确认撤销审核？", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _cancel = function() {
		return new Promise(function (resolve, reject) {
			$.m({
		    	ClassName: "BILL.IP.BL.BatchReg",
		    	MethodName: "CancelAudit",
		    	refeIdAry: refeIdAry,
		    	userId: PUBLIC_CONSTANT.SESSION.USERID
		    }, function(rtn) {
			    var myAry = rtn.split("^");
			    if (myAry[0] == 0) {
				    $.messager.popover({msg: "撤销审核成功", type: "success"});
		            return resolve();
		        }
		        $.messager.popover({msg: "撤销审核失败：" + (myAry[1] || myAry[0]), type: "error"});
		      	reject();
			});
		});
	};
	
	var _success = function() {
		GV.PatList.reload();
	};
	
	var $this = $(event.target);
	if ($this.prop("disabled")) {
		return;
	}
	$this.prop("disabled", true);
	
	var refeIdAry = [];
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_cancel)
		.then(function() {
			_success();
			$this.prop("disabled", false);
		}, function() {
			$this.prop("disabled", false);
		});
}