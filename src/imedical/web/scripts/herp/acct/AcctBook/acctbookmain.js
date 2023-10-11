var acctbookcspurl = "../csp/herp.acct.acctbookexe.csp";

var addButton = new Ext.Button({
		text: "增加",
		iconCls: "add",
		handler: function () {
			itemGrid.add();
		}
	});

//月份补0
function month_0(month) {
	var newmonth="";
	if (month < 10){
		newmonth = '0' + month;
	}else{
		newmonth = month.toString();
	}
	return newmonth;
}
var saveButton = new Ext.Button({
		text: "保存",
		iconCls: 'save',
		handler: function () {
			var rowObj = itemGrid.getSelectionModel().getSelections();
			// console.log(itemGrid.store.getModifiedRecords())
			/* Ext.each(rowObj, function (r) {
				for(var i=0;i<this.fields.length;i++){
					var index = itemGrid.getColumnModel().getColumnId(i + 1);
					var tmobj = itemGrid.getColumnModel().getColumnById(index);
					if (tmobj.allowBlank == false) {
						var rowtitle = tmobj.header;
						//title 中加了css样式，截取名称
						var arr = rowtitle.split(">", 2);
						rowtitle = arr[1].split("<", 1);
						if (!r.data[index]) {
						alert(r.data[index].toString());
							alert("come in");
							Ext.Msg.show({
								title: '错误',
								msg: "[" + rowtitle + "]列为必填项，不能为空！ ",
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR
							});
							// return;
							break;
						}
					}
				}
			}); */
			var rowid = parseInt(rowObj[0].get("rowid"), 10); //账套id
			var cthospitalid = rowObj[0].get("CTHospitalName");
			// 不编辑单位名称时，取到的cthospitalid为显示值，根据显示值找id
			var hospitalpos = CompNameDs.find('name', cthospitalid)
			if (hospitalpos > -1) {
				cthospitalid = CompNameDs.getAt(hospitalpos).data.rowid
			}
			var bookcode = rowObj[0].get("bookCode");
			var bookname = encodeURIComponent(rowObj[0].get("bookName"));
			if (!bookcode || !bookname) {
				Ext.Msg.show({
					title: '错误',
					msg: '账套编码或名称不可为空！',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});
				return;
			}
			var cocode = rowObj[0].get("coCode");
			if (cocode == "") {
				Ext.Msg.show({
					title: '错误',
					msg: '体系代码不能为空！ ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});
				return;
			}
			var startyear = rowObj[0].get("startYear"); //开始当前年度
			if (startyear == "") {
				Ext.Msg.show({
					title: '错误',
					msg: '会计开始年度不可为空！ ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});
				return;
			}

			var startmonth = parseInt(rowObj[0].get("startMonth"), 10); //开始当前月份
			var curyear = parseInt(rowObj[0].get("curYear"), 10); //会计当前年度
			var curmonth = parseInt(rowObj[0].get("curMonth"), 10); // 会计当前月份
			var endday = parseInt(rowObj[0].get("endDay"), 10);
			if (!endday) {
				Ext.Msg.show({
					title: '错误',
					msg: '结账日填写不正确！ ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});
				return;
			}

			// 月份小于10，前面补0；为了比较开始年月与当前年月
			// alert(startmonth)
			var startMonth = month_0(startmonth),
			curMonth = month_0(curmonth);
			// console.log(startyear + startMonth + "^" + curyear + curMonth)
			// 最初对于结账日的录入限制： 根据当前会计开始月份,最多取到当前月最后一天(包括闰年的判断)
			if (startmonth < 1 || startmonth > 12) {
				Ext.Msg.show({
					title: '错误',
					msg: '开始月份填写不正确！ ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});
				rowObj[0].set("startMonth", "");
				return;
			} else if (curmonth < 1 || curmonth > 12) {
				Ext.Msg.show({
					title: '错误',
					msg: '当前月份填写不正确！ ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});
				rowObj[0].set("curMonth", "");
				return;
			} else if (startyear + startMonth > curyear + curMonth) {
				Ext.Msg.show({
					title: '错误',
					msg: '开始年月不能大于当前年月！ ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});
				rowObj[0].set("startYear", "");
				rowObj[0].set("startMonth", "");
				return;
			} else if (curmonth == 2) {
				// new Date(string date).format('L')的值直接判断闰年，返回1，为闰年
				// if ((curyear % 400 == 0) || ((curyear % 4 == 0) && (curyear % 100 != 0))) {
				if (new Date(curyear + "/" + curmonth + "/01").format('L')) {
					if (endday > 29) {
						Ext.Msg.show({
							title: '注意',
							msg: curyear + '年是闰年，当前月为' + curmonth + '月份，请输入小于等于29的日期！ ',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.INFO
						});
						rowObj[0].set("endDay", ""); //	防止重新保存时成功
						return;
					}

				} else {
					if (endday > 28) {
						Ext.Msg.show({
							title: '注意',
							msg: curyear + '年是平年，当前月为' + curmonth + '月份，请输入小于等于28的日期！ ',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.INFO
						});
						rowObj[0].set("endDay", "");
						return;
					}
				}
			} else if (curmonth == 4 || curmonth == 6 || curmonth == 9 || curmonth == 11) {
				if (endday > 30) {
					Ext.Msg.show({
						title: '注意',
						msg: '当前月为' + curmonth + '月份，请输入小于等于30的日期！ ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO
					});
					rowObj[0].set("endDay", "");
					return;
				}
			} else {
				if (endday > 31) {
					Ext.Msg.show({
						title: '注意',
						msg: '当前月为' + curmonth + '月份，请输入小于等于31的日期！ ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO
					});
					rowObj[0].set("endDay", "");
					return;
				}
			}
			// 判断调添加或是更新方法
			var methodType = "add",
			returnmsg = "添加成功！ ";
			var data = '&CTHospitalID=' + cthospitalid + '&bookCode=' + bookcode + '&bookName=' + bookname +
				'&coCode=' + cocode + '&startYear=' + startyear + '&startMonth=' + startmonth + 
				'&curYear=' + curyear + '&curMonth=' + curmonth +'&endDay=' + endday
				// console.log(data)
				if (rowid) {
					methodType = "edit";
					returnmsg = "保存成功！ ";
					data = '&rowid=' + rowid + data;
				}
				var saveurl = acctbookcspurl + "?action=" + methodType + data;

			var f = {
				url: saveurl,
				method: 'POST',
				waitMsg: '保存中...',
				failure: function (result, request) {
					Ext.Msg.show({
						title: '错误',
						msg: '请检查网络连接!',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.ERROR
					});
				},
				success: function (result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Ext.Msg.show({
							title: '注意',
							msg: returnmsg,
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.INFO
						});
						// 刷新后停留到当前页
						var tbarnum = itemGrid.getBottomToolbar();
						tbarnum.doLoad(tbarnum.cursor);

					} else {
						var message = "";
						if (jsonData.info == 'RepCode')
							message = '输入的编码已经存在! ';
						if (jsonData.info == 'RepName')
							message = '输入的名称已经存在! ';
						if (jsonData.info == 'BookUpdateErr')
							message = '会计账套表更新出错! ';
						if (jsonData.info == 'YearPeriodUpdateErr')
							message = '会计期间表更新出错! ';

						Ext.Msg.show({
							title: '错误',
							msg: message,
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.ERROR
						});
					}
				}
			}

			// 判断结账日是否为当前月最后一天,并给url赋值
			var lastcurmonthdays = new Date(curyear + "/" + curmonth + "/01").format('t');
			if (endday == lastcurmonthdays) {
				Ext.Msg.show({
					title: "提示",
					msg: "结账日是会计当前月份的最后一天，是否将此月后的 <br/>每个月的最后一天设为结账日？ ",
					buttons: Ext.Msg.YESNOCANCEL,
					icon: Ext.Msg.INFO,
					fn: callback
				});
				function callback(id) {
					if (id == 'yes') {
						// alert("y");
						f.url += '&ifEndDday=Y';
						Ext.Ajax.request(f);
					} else if (id == "no") {
						// alert("n")
						// 结账日是31日时，只能以每月最后一天作为结账日
						if (endday == '31') {
							f.url += '&ifEndDday=Y';
						} else {
							f.url += '&ifEndDday=N';
						}
						Ext.Ajax.request(f);
					} else
						return;
				}
			} else {
				Ext.Ajax.request(f);
			}

		}
	})

	var CompNameDs = new Ext.data.Store({
		//autoLoad:true,
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		},
			['rowid', 'name'])
	});

CompNameDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: 'herp.acct.acctbookexe.csp' + '?action=calCompany', //&query='+encodeURIComponent(Ext.getCmp('unitField').getRawValue()),
			method: 'POST'
		});
});

CompNameDs.load({
	params: {
		start: 0,
		limit: 25
	}
});

var CompNameID = new Ext.form.ComboBox({
		id: 'CompNameID',
		fieldLabel: '单位名称',
		store: CompNameDs,
		displayField: 'name',
		valueField: 'rowid',
		// typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: '请选择单位名称...',
		width: 200,
		pageSize: 10,
		minChars: 1,
		listWidth: 250,
		columnWidth: .1,
		selectOnFocus: true
		//editable:true
	});

var endDateField = new Ext.form.DateField({
		format: 'Y-m-d',
		emptyText: '结束时间...',
		renderer: function (v, p, r, i) {
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {
				return v;
			}
		},
		columnWidth: 1
	});
var driectStore = new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [['0', '否'], ['1', '是']]
	});
var driectField = new Ext.form.ComboBox({
		id: 'driectField',
		fieldLabel: '是否当前帐套',
		width: 100,
		listWidth: 130,
		selectOnFocus: true,
		allowBlank: true,
		store: driectStore,
		//anchor: '90%',
		valueNotFoundText: '',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText: '选择期间类型...',
		mode: 'local', //本地模式
		editable: false,
		disabled: true,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
var driectStoreCoCode = new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [['01', '医疗会计'],
			['02', '事业会计']]
	});
var driectFieldCoCode = new Ext.form.ComboBox({
		id: 'driectFieldCoCode',
		fieldLabel: '数据项目',
		width: 100,
		listWidth: 200,
		selectOnFocus: true,
		allowBlank: false,
		store: driectStoreCoCode,
		//anchor: '90%',
		valueNotFoundText: '',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText: '选择期间类型...',
		mode: 'local', //本地模式
		editable: false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

var itemGrid = new dhc.herp.Grid({
		title: '单位账套维护',
		iconCls: 'maintain',
		width: 400,
		//edit:false,                   //是否可编辑
		readerModel: 'remote',
		region: 'center',
		url: 'herp.acct.acctbookexe.csp',
		tbar: [addButton, "-", saveButton],
		atLoad: true, // 是否自动刷新
		loadmask: true,
		fields: [{
				id: 'rowid',
				header: 'ID',
				dataIndex: 'rowid', //AcctBookID
				edit: false,
				hidden: true
			}, {
				id: 'CTHospitalName',
				header: '<div style="text-align:center">单位名称</div>',
				//calunit:true,
				allowBlank: false,
				width: 150,
				dataIndex: 'CTHospitalName',
				hidden: false,
				type: CompNameID
			}, {
				id: 'bookCode',
				header: '<div style="text-align:center">账套编码</div>',
				allowBlank: false,
				width: 80,
				dataIndex: 'bookCode'
			}, {
				id: 'bookName',
				header: '<div style="text-align:center">账套名称</div>',
				allowBlank: false,
				width: 150,
				dataIndex: 'bookName'
			}, {
				id: 'coCode',
				header: '<div style="text-align:center">体系代码</div>',
				allowBlank: false,
				width: 90,
				dataIndex: 'coCode',
				type: driectFieldCoCode
			}, {
				id: 'startYear',
				header: '<div style="text-align:center">会计开始年度</div>',
				allowBlank: false,
				align: 'center',
				width: 95,
				dataIndex: 'startYear'
			}, {
				id: 'startMonth',
				header: '<div style="text-align:center">会计开始月份</div>',
				allowBlank: false,
				align: 'center',
				width: 90,
				dataIndex: 'startMonth'
			}, {
				id: 'curYear',
				header: '<div style="text-align:center">会计当前年度</div>',
				allowBlank: false,
				// editable: false,
				align: 'center',
				width: 95,
				dataIndex: 'curYear'
			}, {
				id: 'curMonth',
				header: '<div style="text-align:center">会计当前月份</div>',
				allowBlank: false,
				// editable: false,
				align: 'center',
				width: 95,
				dataIndex: 'curMonth'
			}, {
				id: 'endDay',
				header: '<div style="text-align:center">结帐日</div>',
				allowBlank: false,
				align: 'center',
				width: 50,
				xtype: 'numbercolumn',
				format: '',
				dataIndex: 'endDay'
			}, {
				id: 'InitLedgerFlag',
				header: '<div style="text-align:center">启用账套</div>',
				allowBlank: true, //会否可以为空
				align: 'center', //是否居中
				width: 70,
				dataIndex: 'InitLedgerFlag',
				//type:driectField,
				editable: false
				//disabled:true     //为true是使按钮失效
				//hidden: true      //是否隐藏，true是隐藏
			}, {
				id: 'InitBankFlag',
				header: '<div style="text-align:center">银行对账单据初始化</div>',
				allowBlank: true,
				align: 'center',
				width: 135,
				dataIndex: 'InitBankFlag',
				editable: false
				//hidden: true
				//type: "dateField"
			}, {
				id: 'InitCashFlowFlag',
				header: '<div style="text-align:center">资金流量初始化</div>',
				allowBlank: true,
				align: 'center',
				width: 110,
				dataIndex: 'InitCashFlowFlag',
				editable: false
				//hidden: true
			}
		]
	});

//更新前先判断账套有没有启用，已启用的账套不能修改启用年月
itemGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {
	var selRow = itemGrid.getSelectionModel().getSelections();
	var row = selRow[0].get("InitLedgerFlag");
	if (row == "是") {
		if (columnIndex == 10) {
			return true;
		} else {
			return false;
		}
	}
});

// 编辑后数据验证
// saveButton.on('click', afterEdit);
/* function afterEdit() {
	// edit 20170418 yanglf
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var startyear = parseInt(rowObj[0].get("startYear"), 10); //开始当前年度
	var startmonth = parseInt(rowObj[0].get("startMonth"), 10); //开始当前月份
	var curyear = parseInt(rowObj[0].get("curYear"), 10); //会计当前年度
	var curmonth = parseInt(rowObj[0].get("curMonth"), 10); // 会计当前月份
	var endday = parseInt(rowObj[0].get("endDay"), 10);
	if (!Ext.isNumber(endday)) {
		Ext.Msg.show({
			title: '错误',
			msg: '结账日填写不正确！ ',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.ERROR
		});
		return;
	}
	// 如果当前年月存在，则取当前年月，否则取开始年月
	var year = curyear ? curyear : startyear,
	month = curmonth ? curmonth : startmonth;

	// 月份小于10，前面补0；为了比较开始年月与当前年月
	var startMonth = month_0(startmonth),
	curMonth = month_0(curmonth);
	// 最初对于结账日的录入限制： 根据当前会计开始月份,最多取到当前月最后一天(包括闰年的判断)
	if (startmonth < 1 || startmonth > 12) {
		Ext.Msg.show({
			title: '错误',
			msg: '开始月份填写不正确！ ',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.ERROR
		});
		rowObj[0].set("startMonth", "");
		return;
	} else if (curmonth < 1 || curmonth > 12) {
		Ext.Msg.show({
			title: '错误',
			msg: '当前月份填写不正确！ ',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.ERROR
		});
		rowObj[0].set("curMonth", "");
		return;
	} else if (startyear + startMonth > curyear + curMonth) {
		Ext.Msg.show({
			title: '错误',
			msg: '开始年月不能大于当前年月！ ',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.ERROR
		});
		rowObj[0].set("startYear", "");
		rowObj[0].set("startMonth", "");
		return;
	} else if (curmonth == 2) {
		// new Date(string date).format('L')的值直接判断闰年，返回1，为闰年
		// if ((curyear % 400 == 0) || ((curyear % 4 == 0) && (curyear % 100 != 0))) {
		if (new Date(curyear + "/" + curmonth + "/01").format('L')) {
			if (endday > 29) {
				Ext.Msg.show({
					title: '注意',
					msg: curyear + '年是闰年，当前月为' + curmonth + '月份，请输入小于等于29的日期！ ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.INFO
				});
				rowObj[0].set("endDay", ""); //	防止重新保存时成功
			}

		} else {
			if (endday > 28) {
				Ext.Msg.show({
					title: '注意',
					msg: curyear + '年是平年，当前月为' + curmonth + '月份，请输入小于等于28的日期！ ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.INFO
				});
				rowObj[0].set("endDay", "");
			}
		}
	} else if (curmonth == 4 || curmonth == 6 || curmonth == 9 || curmonth == 11) {
		if (endday > 30) {
			Ext.Msg.show({
				title: '注意',
				msg: '当前月为' + curmonth + '月份，请输入小于等于30的日期！ ',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.INFO
			});
			rowObj[0].set("endDay", "");
		}
	} else {
		if (endday > 31) {
			Ext.Msg.show({
				title: '注意',
				msg: '当前月为' + curmonth + '月份，请输入小于等于31的日期！ ',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.INFO
			});
			rowObj[0].set("endDay", "");
		}
	}
} */

itemGrid.btnAddHide();
itemGrid.btnSaveHide();
itemGrid.btnDeleteHide(); //隐藏删除按钮
itemGrid.btnResetHide(); //隐藏重置按钮
itemGrid.btnPrintHide(); //隐藏打印按钮
