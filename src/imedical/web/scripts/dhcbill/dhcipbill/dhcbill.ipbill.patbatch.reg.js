/**
 * FileName: dhcbill.ipbill.patbatch.reg.js
 * Author: luochaoyue
 * Date: 2022-12-12
 * Description: 批量住院登记
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
	
	$HUI.combobox("#regStatus", {
		panelHeight: 'auto',
		editable: false,
		data: [{value: 'N', text: $g('未入院登记'), selected: true},
			   {value: 'Y', text: $g('已入院登记')}
			],
		valueField: 'value',
		textField: 'text'
	});
}

function IDNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		loadPatList();
	}
};

function loadPatList() {
	var queryParams = {
		ClassName: "BILL.IP.BL.BatchReg",
		QueryName: "QryRefePatList",
		IDNo: getValueById("IDNo"),
		isAudited: "",
		isRegisted: getValueById("regStatus"),
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}
	loadDataGridStore("patList", queryParams);
};

function initPatList() {
	var toolbar = [{
			text: '入院登记',
			iconCls: 'icon-check-reg',
			handler: function () {
				regClick();
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
				if ($.inArray(cm[i].field, ["PatName", "PatSex", "PatAge", "PatID", "CreatDate", "AuditDate", "UpdtDate"]) != -1) {
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
				if (cm[i].field == "IsRegisted") {
					cm[i].formatter = function (value, row, index) {
						var color = (value == "Y") ? "#21ba45" : "#f16e57";
						return "<font color=\"" + color + "\">" + ((value == "Y") ? $g("是") : $g("否")) + "</font>";
					}
				}
				if (cm[i].field == "UpdtUser") {
					cm[i].title = "入院办理人";
					cm[i].formatter = function (value, row, index) {
						return (row.IsRegisted == "Y") ? value : "";
					}
				}
				if (cm[i].field == "UpdtTime") {
					cm[i].title = "入院办理时间";
					cm[i].formatter = function (value, row, index) {
						return (row.IsRegisted == "Y") ? (row.UpdtDate + " " + value) : "";
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
					if ($.inArray(cm[i].field, ["CreatTime", "AuditTime", "UpdtTime"]) != -1) {
						cm[i].width = 160;
					}
				}
			}
		}
	});
}

/**
* 批量入院登记
*/
function regClick() {
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
				$.messager.popover({msg: "请选择待办理入院登记的记录", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "确认办理入院登记？", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	//选择就诊信息
	var _showRegDlg = function() {
	    return new Promise(function (resolve, reject) {
	        $("#registDlg").form("clear").show();
	        var dlgObj = $HUI.dialog("#registDlg", {
	            title: $g('就诊信息'),
	            iconCls: 'icon-w-edit',
	            draggable: false,
	            resizable: false,
	            cache: false,
	            modal: true,
	            closable: false,
	            onBeforeOpen: function () {
	                //就诊费别
	                $HUI.combobox("#admReason", {
	                    panelHeight: 150,
						method: 'GET',
						url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryGrpAdmReason&ResultSetType=array',
						valueField: 'id',
						textField: 'text',
						blurValidValue: true,
						defaultFilter: 5,
						onBeforeLoad: function (param) {
							param.groupId = PUBLIC_CONSTANT.SESSION.GROUPID;
							param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
						}
	                });

	                //科室
	                $HUI.combobox("#dept", {
						panelHeight: 150,
						method: 'GET',
						url: $URL + '?ClassName=web.DHCIPBillReg&QueryName=FindIPDept&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
						valueField: 'id',
						textField: 'text',
						selectOnNavigation: false,
						blurValidValue: true,
						defaultFilter: 5,
						filter: function(q, row) {
							var opts = $(this).combobox("options");
							var mCode = false;
							if (row.contactName) {
								mCode = row.contactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
							}
							var mValue = row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
							return mCode || mValue;
						},
						onSelect: function (rec) {
							$("#ward").combobox("clear").combobox("reload");
						},
						onChange: function (newValue, oldValue) {
							if (!newValue) {
								$("#ward").combobox("clear").combobox("loadData", []);
							}
						}
					});
	                
	                //病区
					$HUI.combobox("#ward", {
						panelHeight: 150,
						method: 'GET',
						url: $URL + '?ClassName=web.DHCIPBillReg&QueryName=FindWard&ResultSetType=array',
						valueField: 'id',
						textField: 'text',
						blurValidValue: true,
						defaultFilter: 5,
						onBeforeLoad: function(param) {
							param.deptId = getValueById("dept");
						},
						onLoadSuccess: function(data) {
							if (data.length == 1) {
								$(this).combobox("select", data[0].id);
							}
						}
					});
	            },
	            buttons: [{
	                    text: $g('确认'),
	                    handler: function () {
	                        var bool = true;
	                        var id = "";
	                        $("#registDlg label.clsRequired").each(function (index, item) {
	                            id = $($(this).parent().next().find("input"))[0].id;
	                            if (!id) {
	                                return true;
	                            }
	                            if (!getValueById(id)) {
	                                bool = false;
	                                focusById(id);
	                                $.messager.popover({msg: ($g("请输入") + "<font color=\"red\">" + $(this).text() + "</font>"), type: "info"});
	                                return false;
	                            }
	                        });
	                        if (!bool) {
	                            return;
	                        }
	                        dlgObj.close();
	                        resolve();
	                    }
	                }, {
	                    text: $g('关闭'),
	                    handler: function () {
	                        dlgObj.close();
	                        return reject();
	                    }
	                }
	            ]
	        });
	    });
	};
	
	var _setRegJsonAry = function() {
		return new Promise(function (resolve, reject) {
			var insTypeId = getValueById("admReason");
			var deptId = getValueById("dept");
			var wardId = getValueById("ward");
			regJsonAry = refeIdAry.map(function(id) {
				return {refeId: id, insTypeId: insTypeId, deptId: deptId, wardId: wardId};
			});
			resolve();
		});
	};
	
	var _reg = function() {
		return new Promise(function (resolve, reject) {
			$.m({
		    	ClassName: "BILL.IP.BL.BatchReg",
		    	MethodName: "RegBatch",
		    	regList: JSON.stringify(regJsonAry),
		    	sessionStr: getSessionStr()
		    }, function(rtn) {
			    var myAry = rtn.split("^");
			     $.messager.alert("提示", (myAry[1] || myAry[0]), "info", function() {
				    resolve();
				});
			    return;
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
	var regJsonAry = [];
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_showRegDlg)
		.then(_setRegJsonAry)
		.then(_reg)
		.then(function() {
			_success();
			$this.prop("disabled", false);
		}, function() {
			$this.prop("disabled", false);
		});
}