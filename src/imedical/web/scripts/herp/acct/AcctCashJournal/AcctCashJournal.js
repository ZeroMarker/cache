var userid = session['LOGON.USERID'];
var CheckInfo = "";
var AcctBookID = IsExistAcctBook();
var projUrl = "herp.acct.AcctCashJournalexe.csp";

var Income = "";
var ifIncome = function() {
    Ext.Ajax.request({
        url: 'herp.acct.AcctCashJournalexe.csp?action=IfIncome&AcctBookID=' + AcctBookID,
        method: 'POST',

        success: function(result, request) {
            var jsonData = Ext.util.JSON.decode(result.responseText);

            //alert(jsonData.success );
            if (jsonData.success == 'true') {

                Income = jsonData.info;

				//如果从凭证引入日记账  隐藏以下按钮
                if (Income == 1) {
                    itemGrid.btnAddHide();
                    itemGrid.btnSaveHide();
                    itemGrid.btnDeleteHide();
                    SubmitButton.hide();
                    CanSubmitButton.hide();
                    SaveSumButton.hide();
                } else {
                    VouchInButton.hide();
                }

            }
        }
    });

};
ifIncome();



var StartYearMonth = new Ext.form.DateField({
    id: 'StartYearMonth',
    name: 'StartYearMonth',
    fieldLabel: '会计期间',
    emptyMsg: "",
    value: new Date(),
    // format: 'Y-m-d',
    width: 120,
    allowBlank: false,
    editable: true
});

var EndYearMonth = new Ext.form.DateField({
    id: 'EndYearMonth',
    name: 'EndYearMonth',
    fieldLabel: '会计期间',
    emptyMsg: "",
    value: new Date(),
    // format: 'Y-m-d',
    width: 120,
    allowBlank: true,
    editable: true
});

//摘要
var SummaryLDS = new Ext.data.Store({
    autoLoad: true,
    proxy: "",
    reader: new Ext.data.JsonReader({
        totalProperty: 'results',
        root: 'rows'
    }, ['code', 'name'])
});
SummaryLDS.on('beforeload', function(ds, o) {
    ds.proxy = new Ext.data.HttpProxy({
        url: 'herp.acct.AcctCashJournalexe.csp?action=GetSummary&str=' + Ext.getCmp('SummaryL').getRawValue(),
        method: 'POST'
    });

});

var SummaryL = new Ext.form.ComboBox({
    id: 'SummaryL',
    store: SummaryLDS,
    valueField: 'name',
    displayField: 'name',
    width: 200,
    listWidth: 220,
    triggerAction: 'all',
    pageSize: 10,
    minChars: 1,
    selectOnFocus: true,
    mode: 'remote',
    editable: true,
    resizable: true
        //queryMode : 'local',


});


//会计科目
var AcctSubjDs = new Ext.data.Store({
    autoLoad: true,
    proxy: "",
    reader: new Ext.data.JsonReader({
        totalProperty: 'results',
        root: 'rows'
    }, ['subjId', 'subjCode', 'subjName', 'subjCodeName'])
});
AcctSubjDs.on('beforeload', function(ds, o) {
    ds.proxy = new Ext.data.HttpProxy({
        url: 'herp.acct.AcctCashJournalexe.csp?action=GetAcctSubj&str=' + Ext.getCmp('AcctSubj').getRawValue() + '&AcctBookID=' + AcctBookID,
        method: 'POST'
    });

});

var AcctSubj = new Ext.form.ComboBox({
    id: 'AcctSubj',
    fieldLabel: '会计科目',
    store: AcctSubjDs,
    valueField: 'subjCode',
    displayField: 'subjCodeName',
    width: 200,
    listWidth: 220,
    triggerAction: 'all',
    pageSize: 10,
    minChars: 1,
    selectOnFocus: true,
    editable: true,
    resizable: true,
    forceSelection: true
});


var JournalStateDS = new Ext.data.SimpleStore({
    fields: ['key', 'keyValue'],
    data: [
        ['0', '新增'],
        ['1', '提交'],
        ['', '全部']
    ]
});


var JournalState = new Ext.form.ComboBox({
    id: 'JournalState',
    fieldLabel: '数据状态',
    width: 120,
    listWidth: 100,
    store: JournalStateDS,
	//bodyStyle: 'padding: 0 5px;margin:5px',
    valueNotFoundText: '',
    displayField: 'keyValue',
    valueField: 'key',
    mode: 'local', // 本地模式
    triggerAction: 'all',
    emptyText: '全部',
    selectOnFocus: true,
    forceSelection: true,
    editable: true
        //allowBlank:true

});


//摘要
var Summary1DS = new Ext.data.Store({
    autoLoad: true,
    proxy: "",
    reader: new Ext.data.JsonReader({
        totalProperty: 'results',
        root: 'rows'
    }, ['code', 'name'])
});
Summary1DS.on('beforeload', function(ds, o) {
    ds.proxy = new Ext.data.HttpProxy({
        url: 'herp.acct.AcctCashJournalexe.csp?action=GetSummary&str=' + Ext.getCmp('Summary1').getRawValue(),
        method: 'POST'
    });

});

var Summary1 = new Ext.form.ComboBox({
    id: 'Summary1',
    store: Summary1DS,
    valueField: 'name',
    displayField: 'name',
    width: 200,
    listWidth: 220,
    triggerAction: 'all',
    pageSize: 10,
    minChars: 1,
    selectOnFocus: true,
    mode: 'remote',
    editable: true,
    resizable: true
        //queryMode : 'local',


});


var QueryButton = new Ext.Toolbar.Button({
    text: '查询',
    tooltip: '查询',
    iconCls: 'find',
    width: 60,
    handler: function() {
        find();
    }
});
//提交数据按钮
var SubmitButton = new Ext.Toolbar.Button({
    text: '提交',
    tooltip: '提交',
    iconCls: 'submit',
    handler: function() {
        submitData();
    }
});
//撤销提交
var CanSubmitButton = new Ext.Toolbar.Button({
    text: '撤销提交',
    tooltip: '撤销提交',
    iconCls: 'cancel',
    handler: function() {
        CanSubmit();
    }
});
//保存摘要
var SaveSumButton = new Ext.Toolbar.Button({
    text: '保存摘要',
    tooltip: '保存摘要',
    iconCls: 'save',
    handler: function() {
        SaveSum();
    }
});

var VouchInButton = new Ext.Toolbar.Button({
    text: '从凭证引入',
    tooltip: '从凭证引入',
    iconCls: 'leadinto ',
    width: 90,
    handler: function() {
        VouchIncome();
    }
});

//提交数据方法
var submitData = function() {

    var records = itemGrid.getSelectionModel().getSelections();
    var len = records.length;
    if (len < 1) {
        Ext.Msg.show({
            title: '提示',
            msg: '请选择要提交的数据! ',
            buttons: Ext.Msg.OK,
            icon: Ext.MessageBox.WARNING
        });
        return;
    }

    var ID = "";
    for (var i = 0; i < len; i++) {
        var rowid = records[i].get("rowid");
        var statue = records[i].get("JournalState");
        var Check = records[i].get("Check");
        if (rowid == "") {
            continue;
        }

        if (statue == "提交") {
            Ext.Msg.show({
                title: '提示',
                msg: '选择的数据中有已提交的数据! ',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.WARNING
            });
            return;

        }
        var Check1 = "未添加辅助核算";
        var Check2 = "辅助账与总账不相等";
        // alert(Check);
        if ((Check == '100')) {
            Ext.Msg.show({
                title: '提示',
                msg: '选择的数据中有"' + Check1 + '"的数据,不可提交! ',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.WARNING
            });
            return;

        }
        if ((Check == '110')) {
            Ext.Msg.show({
                title: '提示',
                msg: '选择的数据中有"' + Check2 + '"的数据,不可提交! ',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.WARNING
            });
            return;

        }


        if (ID == "") {
            ID = rowid;
        } else {
            ID = ID + "^" + rowid;
        }
    }
    //alert(ID);

    Ext.MessageBox.confirm('提示', '确定提交数据? ', function(btn) {
        if (btn == "yes") {
            Ext.Ajax.request({
                url: 'herp.acct.AcctCashJournalexe.csp?action=Sbumitdata&ID=' + ID,
                method: 'POST',
                failure: function(result, request) {
                    Ext.Msg.show({
                        title: '错误',
                        msg: '请检查网络连接!',
                        buttons: Ext.Msg.OK,
                        icon: Ext.MessageBox.ERROR
                    });
                },
                success: function(result, request) {
                    var jsonData = Ext.util.JSON.decode(result.responseText);

                    //alert(jsonData.success );
                    if (jsonData.success == 'true') {
                        Ext.Msg.show({
                            title: '提示',
                            msg: '数据已提交! ',
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.INFO
                        });

                        var Sumarryv = Summary1.getValue();
                        var StartDate = StartYearMonth.getValue();
                        var EndDate = EndYearMonth.getValue();
                        if (StartDate != "") {
                            var StartDateF = StartDate.format('Y-m-d');

                        } else {
                            var StartDateF = "";
                        }

                        if (EndDate != "") {
                            var EndDateF = EndDate.format('Y-m-d');

                        } else {
                            var EndDateF = "";
                        }

                        itemGrid.load({
                            params: {

                                sortField: '',
                                sortDir: '',
                                start: 0,
                                limit: 25,
                                SYearMonth: StartDateF,
                                EYearMonth: EndDateF,
                                Summary: Sumarryv,
                                AcctBookID: AcctBookID

                            }
                        });

                    } else if (jsonData.success == 'false') {
                        var result = jsonData.info;

                        Ext.Msg.show({
                            title: '提示',
                            msg: '提交失败! ',
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.INFO
                        });

                    }
                },
                scope: this
            });
        }
    });

};

var CanSubmit = function() {
        var records = itemGrid.getSelectionModel().getSelections();
        var len = records.length;
        if (len < 1) {
            Ext.Msg.show({
                title: '提示',
                msg: '请选择要撤销提交的数据! ',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.WARNING
            });
            return;
        }

        var ID = "";
        for (var i = 0; i < len; i++) {
            var rowid = records[i].get("rowid");
            var statue = records[i].get("JournalState");
            var Accounting = records[i].get("Accounting");
            // alert(Accounting);

            if (Accounting == "记账") {
                Ext.Msg.show({
                    title: '提示',
                    msg: '数据已记账,不可撤销! ',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.WARNING
                });
                return;

            }
            if (rowid == "") {
                continue;
            }
            // alert(statue);
            if (statue == '提交') {

                if (ID == "") {
                    ID = rowid;
                } else {
                    ID = ID + "^" + rowid;
                }

            }

            if (ID == "") {
                Ext.Msg.show({
                    title: '提示',
                    msg: '请选择已经提交的数据进行撤销! ',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.WARNING
                });
                return;

            }
        }
        //alert(ID);

        Ext.MessageBox.confirm('提示', '确定撤销提交数据? ', function(btn) {
            if (btn == "yes") {
                Ext.Ajax.request({
                    url: 'herp.acct.AcctCashJournalexe.csp?action=CanSubmit&ID=' + ID,
                    method: 'POST',
                    failure: function(result, request) {
                        Ext.Msg.show({
                            title: '错误',
                            msg: '请检查网络连接!',
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.ERROR
                        });
                    },
                    success: function(result, request) {
                        var jsonData = Ext.util.JSON.decode(result.responseText);

                        //alert(jsonData.success );
                        if (jsonData.success == 'true') {
                            Ext.Msg.show({
                                title: '提示',
                                msg: '撤销成功! ',
                                buttons: Ext.Msg.OK,
                                icon: Ext.MessageBox.INFO
                            });

                            var Sumarryv = Summary1.getValue();
                            var StartDate = StartYearMonth.getValue();
                            var EndDate = EndYearMonth.getValue();
                            if (StartDate != "") {
                                var StartDateF = StartDate.format('Y-m-d');

                            } else {
                                var StartDateF = "";
                            }

                            if (EndDate != "") {
                                var EndDateF = EndDate.format('Y-m-d');

                            } else {
                                var EndDateF = "";
                            }

                            itemGrid.load({
                                params: {

                                    sortField: '',
                                    sortDir: '',
                                    start: 0,
                                    limit: 25,
                                    SYearMonth: StartDateF,
                                    EYearMonth: EndDateF,
                                    Summary: Sumarryv,
                                    AcctBookID: AcctBookID

                                }
                            });

                        } else if (jsonData.success == 'false') {
                            var result = jsonData.info;

                            Ext.Msg.show({
                                title: '提示',
                                msg: '撤销失败! ',
                                buttons: Ext.Msg.OK,
                                icon: Ext.MessageBox.INFO
                            });

                        }
                    },
                    scope: this
                });
            }
        });

    }
    //保存摘要
var SaveSum = function() {
    var records = itemGrid.getSelectionModel().getSelections();
    var len = records.length;
    if (len < 1) {
        Ext.Msg.show({
            title: '提示',
            msg: '请选择要保存的数据! ',
            buttons: Ext.Msg.OK,
            icon: Ext.MessageBox.WARNING
        });
        return;
    }


    var summary = records[0].get("Summary");
    //alert(summary);

    Ext.MessageBox.confirm('提示', '确定保存摘要? ', function(btn) {
        if (btn == "yes") {
            Ext.Ajax.request({
                url: 'herp.acct.AcctCashJournalexe.csp?action=SaveSum&Summary=' + encodeURIComponent(summary),
                method: 'POST',
                failure: function(result, request) {
                    Ext.Msg.show({
                        title: '错误',
                        msg: '请检查网络连接!',
                        buttons: Ext.Msg.OK,
                        icon: Ext.MessageBox.ERROR
                    });
                },
                success: function(result, request) {
                    var jsonData = Ext.util.JSON.decode(result.responseText);

                    //alert(jsonData.success );
                    if (jsonData.success == 'true') {
                        Ext.Msg.show({
                            title: '提示',
                            msg: '保存成功! ',
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.INFO
                        });

                    } else if (jsonData.success == 'false') {
                        var result = jsonData.info;
                        if (result == "ReqCode") {
                            Ext.Msg.show({
                                title: '提示',
                                msg: '编码重复! ',
                                buttons: Ext.Msg.OK,
                                icon: Ext.MessageBox.INFO
                            });

                        } else {
                            Ext.Msg.show({
                                title: '提示',
                                msg: '保存失败! ',
                                buttons: Ext.Msg.OK,
                                icon: Ext.MessageBox.INFO
                            });
                        }


                    }
                },
                scope: this
            });
        }
    });
}

//查询方法
var find = function() {
    var State = JournalState.getValue();
    var Sumarryv = Summary1.getValue();
    var StartDate = StartYearMonth.getValue();
    var EndDate = EndYearMonth.getValue();
    if (StartDate != "") {
        var StartDateF = StartDate.format('Y-m-d');

    } else {
		Ext.Msg.show({
                                title: '提示',
                                msg: '开始日期不可为空! ',
                                buttons: Ext.Msg.OK,
                                icon: Ext.MessageBox.INFO
                            });
							
			return;
      //  var StartDateF = "";
		
    }

    if (EndDate != "") {
        var EndDateF = EndDate.format('Y-m-d');

    } else {
        var EndDateF = "";
    }

    itemGrid.load({
        params: {

            sortField: '',
            sortDir: '',
            start: 0,
            limit: 25,
            SYearMonth: StartDateF,
            EYearMonth: EndDateF,
            Summary: Sumarryv,
            JournalState: State,
            AcctBookID: AcctBookID

        }
    });

};
//从凭证引入
var VouchIncome = function() {

    var vStartDate = new Ext.form.DateField({
        id: 'vStartDate',
        name: 'vStartDate',
        fieldLabel: '凭证开始日期',
        // value: new Date(),
        // format: 'Y-m-d',
        width: 120,
        allowBlank: true,
        disabled: true
    });
    //取上次引入的结束日期，避免引入时漏掉部分凭证
    Ext.Ajax.request({
        url: projUrl + "?action=getvcStartDate&AcctBookID=" + AcctBookID ,
        method: 'GET',
        success: function(result, request) {
            var jsonData = Ext.util.JSON.decode(result.responseText);
            if (jsonData.success == 'true') {
                // alert(jsonData.info);
                vStartDate.setValue(jsonData.info);
            }
        }
    });

    var vEndDate = new Ext.form.DateField({
        id: 'vEndDate',
        name: 'vEndDate',
        fieldLabel: '凭证结束日期',
        value: new Date(),
        // format: 'Y-m-d',
        width: 120,
        allowBlank: false,
        editable: true
    });

    var dateModelRadio = new Ext.form.RadioGroup({
        fieldLabel: "日记账日期",
        width: 150,
        defaults: {
            style: "vertical-align:middle;" //margin-top:2px;line-height:20px;
        },
        items: [{
            name: 'dateModelRadio',
            boxLabel: "当前日期",
            inputValue: 1,
            checked: true
        }, {
            name: 'dateModelRadio',
            boxLabel: "凭证日期",
            inputValue: 2
        }]
    });

    var vInComePanel = new Ext.FormPanel({
        baseCls: 'x-plain',
        labelWidth: 90,
        labelAlign: 'right',
        // bodyStyle:"padding:10 20;",
        items: [vStartDate, vEndDate, dateModelRadio]
    });

    var win = new Ext.Window({
        title: "凭证引入条件",
        height: 240,
        width: 320,
        minHeight: 220,
        minWidth: 320,
        layout: 'fit',
        plain: true,
        modal: true, //窗口之外的区域不能操作
        buttonAlign: 'center',
        bodyStyle: 'padding:20 0 20 15;',
        items: vInComePanel,
        buttons: [{
            text: "开始引入",
            handler: function() {
                var StartDate = vStartDate.getRawValue();
                var EndDate = vEndDate.getRawValue();
                var dateModel = dateModelRadio.getValue().inputValue;
                // alert(StartDate+"^"+EndDate+"^"+dateModel);
				//判断所选日期范围内有没有符合的凭证
				Ext.Ajax.request({
					url:'herp.acct.AcctCashJournalexe.csp?action=IfExistCashVouch&AcctBookID=' + AcctBookID +
                                '&SYearMonth=' + StartDate + '&EYearMonth=' + EndDate,
					method:'GET',
					success:function(result,request){
						var jsonData=Ext.util.JSON.decode(result.responseText);
						// console.log(jsonData)
						// alert(jsonData.info+"*"+!jsonData.info)
						if(jsonData.info==0){
							Ext.Msg.show({
								title: '提示',
								msg: "所选日期范围内没有符合的凭证！ ",
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.INFO
							});
							// win.close();
							return;							
						}else{
							
							Ext.Msg.confirm("注意", "确定要将" + StartDate + "至" + EndDate + "的凭证引入到日记账吗？ ", callback)
							function callback(btnid) {
								if (btnid == 'yes') {
									Ext.Ajax.request({
										url: 'herp.acct.AcctCashJournalexe.csp?action=cashVouchIncome&AcctBookID=' + AcctBookID +
											'&SYearMonth=' + StartDate + '&EYearMonth=' + EndDate + '&dateModel=' + dateModel ,
										method: 'POST',
										failure: function(result, request) {
											Ext.Msg.show({
												title: '错误',
												msg: '请检查网络连接!',
												buttons: Ext.Msg.OK,
												icon: Ext.MessageBox.ERROR
											});
											return;
										},
										success: function(result, request) {
											var jsonData = Ext.util.JSON.decode(result.responseText);

											// console.log(jsonData.info);
											if (jsonData.success == 'true') {
												Ext.Msg.show({
													title: '提示',
													msg: '引入成功! ',
													buttons: Ext.Msg.OK,
													icon: Ext.MessageBox.INFO
												});
												win.close();
												return;

											} /* else {
												if (jsonData.info == 0) {
													var msgStr = "所选日期范围内没有符合的凭证！ ";
												}
												Ext.Msg.show({
													title: '提示',
													msg: msgStr,
													buttons: Ext.Msg.OK,
													icon: Ext.MessageBox.INFO
												});
												return;
											} */
										},
										failure: function(result, request) {
											Ext.Msg.show({
												title: '提示',
												msg: "网络错误！ ",
												buttons: Ext.Msg.OK,
												icon: Ext.MessageBox.INFO
											});
											return;
										}
									});

								}
							}
						}
					}
                

                });
            }
        }, {
            text: "取消",
            handler: function() {
                win.close();
            }
        }]


    });
    win.show();

};

//查询面板
var queryPanel = new Ext.FormPanel({
	title:'现金日记账维护',
    region: 'north',
    frame: true,
	iconCls : 'maintain',
    defaults: {
        bodyStyle: 'padding:5px'
    },
    height: 70,
    items: [{
        columnWidth: 1,
        xtype: 'panel',
        layout: "column",
        width: 1200,
        items: [
            {
                xtype: 'displayfield',
                value: '日期',
                style: 'padding: 0 5px;'
                //width: 40
            },
            StartYearMonth, {
                xtype: 'displayfield',
                value: '至',
               style: 'padding: 0 5px;'
                //width: 15
            },
            EndYearMonth, {
                xtype: 'displayfield',
                value: '',
                width: 40
            }, {
                xtype: 'displayfield',

                value: '摘要',
               style: 'padding: 0 5px;'
                //width: 40
            },
            Summary1, {
                xtype: 'displayfield',
                value: '',
                width: 40
            }, {
                xtype: 'displayfield',

                value: '数据状态',
               style: 'padding: 0 5PX;'
               // width: 60
            },
            JournalState, {
                xtype: 'displayfield',
                value: '',
                width: 40
            },
            QueryButton, {
                xtype: 'displayfield',
                value: '',
                width: 40
            },
            VouchInButton


        ]
    }]

});

var itemGrid = new dhc.herp.Grid({
	//title:'现金日记账查询列表',
    width: 400,
    region: 'center',
	//iconCls : 'list',
    url: 'herp.acct.AcctCashJournalexe.csp',
    tbar: [SubmitButton, CanSubmitButton, SaveSumButton],
	viewConfig : { //forceFit : true,   //控制页面全局比例，使页面每列按照对应的比例填充满面板
		//scrollOffset: 20,//表示表格右侧为滚动条预留的宽度
		/*根据条件改变要求行的背景色！
		需要在主页面新建一个css例如：
		<style type="text/css">
		.my_row_style table{ background:Yellow}
		</style>
		然后用下面的方法便可以实现了！
		 */
		getRowClass : function (record, rowIndex, rowParams, store) {
			//alert("record.data.Summary");
			if ((record.data.Summary == "今日合计")||(record.data.Summary == "上年结转")||(record.data.Summary == "昨日余额")||(record.data.Summary == "期初余额"))

				{
				return "my_row_style";
			}

		}
	},
    fields: [
        new Ext.grid.CheckboxSelectionModel({
            editable: false,
            singleSelect: true
        }), {
            id: 'rowid',
            header: '<div style="text-align:center">ID</div>',
            width: 100,
            editable: true,
            align: 'left',
            //allowBlank : false,  
            hidden: true,
            dataIndex: 'rowid'
        }, {
            id: 'BillDate',
            header: '<div style="text-align:center">日期</div>',
            width: 90,
            editable: true,
            align: 'center',
            allowBlank: false,
            type: "dateField",
            dateFormat: 'Y-m-d',
            dataIndex: 'BillDate'

        }, {
            id: 'Summary',
            header: '<div style="text-align:center">摘要</div>',
            width: 180,
            align: 'left',
            editable: true,
            allowBlank: true,
            type: SummaryL,
			dataIndex: 'Summary'
        }, {
            id: 'AcctSubjCode',
            header: '<div style="text-align:center">对方科目</div>',
            width: 220,
            align: 'left',
            editable: true,
            dataIndex: 'AcctSubjCode',
            allowBlank: false,
            type: AcctSubj

        }, {
            id: 'AmtDebit',
            header: '<div style="text-align:center">借方金额</div>',
            width: 120,
            align: 'right',
            editable: true,
            allowBlank: true,
            dataIndex: 'AmtDebit'
        }, {
            id: 'AmtCredit',
            header: '<div style="text-align:center">贷方金额</div>',
            width: 120,
            align: 'right',
            editable: true,
            allowBlank: true,
            dataIndex: 'AmtCredit'
        }, {
            id: 'EndSum',
            header: '<div style="text-align:center">余额</div>',
            width: 120,
            align: 'right',
            editable: false,
            allowBlank: true,
            dataIndex: 'EndSum'
        }, {
            id: 'Check',
            header: '<div style="text-align:center">辅助账</div>',
            width: 150,
            align: 'left',
            editable: false,
            allowBlank: true,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //alert(value);
                if (value == '0') {
                    return '<span ></span>'; //科目非辅助核算项
                } else if (value == '100') {
                    return '<span style="color:red;cursor:hand;TEXT-DECORATION:underline">未添加辅助核算项</span>';
                } else if (value == '110') {
                    return '<span style="color:red;cursor:hand;TEXT-DECORATION:underline">辅助账与总账不相等</span>';
                } else if (value == '111') {
                    return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">查看辅助账</span>';
                }

            },
            dataIndex: 'Check'
        }, {
            id: 'JournalState',
            header: '<div style="text-align:center">数据状态</div>',
            width: 80,
            align: 'center',
            editable: false,
            allowBlank: true,
            dataIndex: 'JournalState'
        }, {
            id: 'VouchNO',
            header: '<div style="text-align:center">凭证号</div>',
            width: 120,
            align: 'left',
            editable: false,
            allowBlank: true,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>';
            },
            dataIndex: 'VouchNO'
        }, {
            id: 'YearMonth',
            header: '<div style="text-align:center">会计期间</div>',
            width: 90,
            align: 'center',
            editable: false,
            allowBlank: true,
            dataIndex: 'YearMonth'
        }, {
            id: 'VouchState',
            header: '<div style="text-align:center">凭证状态</div>',
            width: 90,
            align: 'center',
            editable: false,
            allowBlank: true,
            dataIndex: 'VouchState'
        }, {
            id: 'Flag',
            header: '<div style="text-align:center">记账标志</div>',
            width: 80,
            align: 'center',
            editable: false,
            allowBlank: true,
            dataIndex: 'Accounting'
        }, {
            id: 'Poster',
            header: '<div style="text-align:center">制单人</div>',
            width: 100,
            align: 'center',
            editable: false,
            allowBlank: true,
            dataIndex: 'Poster'
        }, {
            id: 'Every',
            header: '<div style="text-align:center">附件数</div>',
            width: 80,
            align: 'left',
            editable: true,
            allowBlank: true,
            hidden: true,
            dataIndex: 'Every'
        }
    ]
});

itemGrid.btnResetHide();
itemGrid.btnPrintHide();


/* 	// 合计行设置背景色
	itemGrid.getStore().on('load', function (s, record) {
		var rowNo = 0
			s.each(function (r) {
				if (r.get("Summary") == "今日合计") {
					itemGrid.getView().getRow(rowNo).style.backgroundColor = '#FFFF00';
				}
				rowNo += 1;
			});

	}); */


itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
    var records = itemGrid.getSelectionModel().getSelections();
    //alert(itemGrid.getStore().indexOf(records[0]));

    if (columnIndex == '11') {

        var VouchNo = records[0].get("VouchNO");
        var VouchState = "11";
        //alert(VouchNo);
        if (VouchNo != "") {
            var myPanel = new Ext.Panel({
                layout: 'fit',
                html: '<iframe id="frameReport" style="margin-top:-3px;" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno=' + VouchNo + '&user=' + userid + '&acctstate=' + VouchState + '&bookID=' + AcctBookID + '&SearchFlag=' + '1' + '" /></iframe>'

            });
            var win = new Ext.Window({
                title: '凭证查看',
                width: 1090,
                height: 620,
                resizable: false,
                closable: true,
                draggable: true,
                resizable: false,
                layout: 'fit',
                modal: false,
                plain: true, // 表示为渲染window body的背景为透明的背景
                //bodyStyle : 'padding:5px;',
                items: [myPanel],
                buttonAlign: 'center',
                buttons: [{
                    text: '关闭',
                    type: 'button',
                    handler: function() {
                        win.close();
                    }
                }]
            });
            win.show();
        }
    }
	

    if (columnIndex == '9') {
        var SubjCodeName = records[0].get("AcctSubjCode");
        var SubjCode = SubjCodeName.split(" ")[0];
        var rowid = records[0].get("rowid");
        var staute = records[0].get("JournalState");
        var checktext = records[0].get("Check");
		//获取行号
		// var store = itemGrid.getStore();
        // var selectData = records[0];
        // var dataIndex = store.indexOf(selectData);
      //alert(dataIndex);
        Ext.Ajax.request({
            url: 'herp.acct.AcctCashJournalexe.csp?action=IsCheck&SubjCode=' + encodeURIComponent(SubjCode) + '&AcctBookID=' + AcctBookID,
            method: 'POST',
            success: function(result, request) {
                var jsonData = Ext.util.JSON.decode(result.responseText);

                if (jsonData.success == 'true') {
                    var result = jsonData.info;
                    if (result.split("*")[0] == 1) {
                        var SubjID = result.split("*")[1];
                        IsCheck(SubjID, SubjCode, rowid, staute, checktext);
                        // alert("批量录入辅助账");

                    }

                }
            }

        });

    }

    var summary = records[0].get("Summary");
    var rowid = records[0].get("rowid");
    var statue = records[0].get("JournalState");
    var summ = "上年结转";
    var summ1 = "昨日余额";
    var summ2 = "期初余额";
    var summ3 = "今日合计";
    if ((summary == summ) || (summary == summ1) || (summary == summ2) || (summary == summ3) || (statue == "提交")) {
        return false;
    } else {
        return true;
    }

});



//辅助账录入页面

var IsCheck = function(SubjID, SubjCode, CashJournalID, staute, checktext) {
    //alert(SubjID+" "+SubjCode);

    var rows;
    var CheckTypeDS = new Ext.data.Store({
        autoLoad: true,
        proxy: "",
        reader: new Ext.data.JsonReader({
            totalProperty: 'results',
            root: 'rows'
        }, ['typeID', 'typeName'])
    });

    CheckTypeDS.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({
            url: 'herp.acct.AcctCashJournalexe.csp' + '?action=CheckType&SubjID=' + SubjID + '&str=' + encodeURIComponent(Ext.getCmp('CheckType').getRawValue()),
            method: 'POST'
        });
    });

    var CheckType = new Ext.form.ComboBox({
        id: 'CheckType',
        fieldLabel: '辅助账类型',
        width: 200,
        listWidth: 200,
        allowBlank: false,
        store: CheckTypeDS,
        valueField: 'typeID',
        displayField: 'typeName',
        triggerAction: 'all',
        emptyText: '请选择...',
        name: 'CheckType',
        minChars: 1,
        pageSize: 10,
        selectOnFocus: true,
        forceSelection: true,
        editable: true,
        listeners: {
            select: function() {
                var currow = itemGridC.getSelectionModel().getSelections();
                rows = currow[0].data["rowid"];
                var CheckTypeID = CheckType.getValue();
                // alert(CheckTypeID);
                if (CheckTypeID != "") {
                    CheckItemDS.removeAll();

                    CheckItemDS.on('beforeload', function(ds, o) {
                        ds.proxy = new Ext.data.HttpProxy({
                            method: 'POST',
                            url: 'herp.acct.AcctCashJournalexe.csp?action=GetCheckItem&start=0&limit=25&str=' + encodeURIComponent(Ext.getCmp('CheckItem').getRawValue()) + '&AcctBookID=' + AcctBookID + '&CheckTypeID=' + CheckTypeID
                        })
                    });
                    CheckItemDS.load();
                }
            }
        }

    });

    var CheckItemDS = new Ext.data.Store({
        autoLoad: false,
        proxy: "",
        reader: new Ext.data.JsonReader({
            totalProperty: 'results',
            root: 'rows'
        }, ['ItemID', 'ItemName'])
    });


    var CheckItem = new Ext.form.ComboBox({
        id: 'CheckItem',
        fieldLabel: '辅助核算项',
        width: 200,
        listWidth: 200,
        queryModel: 'local',
        lazyRender: true, //选择时加载
        minChars: 1,
        pageSize: 10,
        store: CheckItemDS,
        displayField: 'ItemName',
        valueField: 'ItemID',
        name: 'CheckItem',
        triggerAction: 'all',
        selectOnFocus: true,
        forceSelection: true,
        editable: true,
        listeners: {
            focus: function() {
                var record = itemGridC.getSelectionModel().getSelections();
                var CheckTypeName = record[0].data["CheckName"];
                // alert(CheckTypeName);
                if (CheckTypeName == "") {

                    Ext.Msg.show({
                        title: '注意',
                        msg: '请先选择辅助核算项！ ',
                        icon: Ext.Msg.INFO,
                        buttons: Ext.Msg.OK
                    });
                    return;
                }
                //alert(rows+"&"+record[0].data["rowid"]);
                if (rows != record[0].data["rowid"]) {

                    CheckItemDS.removeAll();


                    CheckItemDS.on('beforeload', function(ds, o) {
                        ds.proxy = new Ext.data.HttpProxy({
                            method: 'GET',
                            url: 'herp.acct.AcctCashJournalexe.csp?action=GetCheckItem&start=0&limit=25&str=' + encodeURIComponent(Ext.getCmp('CheckItem').getRawValue()) + '&AcctBookID=' + AcctBookID + '&CheckTypeName=' + encodeURIComponent(CheckTypeName)
                        })

                    });

                    CheckItemDS.load();
                }
            }
        }


    });

    var batchButton = new Ext.Toolbar.Button({
        text: '批量添加',
        tooltip: '批量添加',
        iconCls: 'adds',
        handler: function() {
            batchAdd();
        }
    });


    var itemGridC = new dhc.herp.Gridp({
        // width: 550,
        // height:430,
        region: 'center',
        url: 'herp.acct.AcctCashJournalCheckexe.csp',
        atLoad: true,
        //forceFit:true,
        readerModel: 'remote',
        tbar: [batchButton],
        fields: [
            new Ext.grid.CheckboxSelectionModel({
                editable: false,
                singleSelect: true
            }), {
                id: 'rowid',
                header: '<div style="text-align:center">rowid</div>',
                width: 120,
                editable: false,
                align: 'left',
                hidden: true,
                dataIndex: 'rowid'
            }, {
                id: 'SubjName',
                header: '<div style="text-align:center">会计科目</div>',
                width: 120,
                editable: true,
                hidden: true,
                align: 'left',
                dataIndex: 'SubjName'
            }, {
                id: 'CheckName',
                header: '<div style="text-align:center">辅助账类型</div>',
                width: 120,
                align: 'left',
                dataIndex: 'CheckName',
                type: CheckType
            }, {
                id: 'ItemName',
                header: '<div style="text-align:center">辅助核算项</div>',
                width: 150,
                editable: true,
                align: 'left',
                dataIndex: 'ItemName',
                type: CheckItem
            }, {
                id: 'Amount',
                header: '<div style="text-align:center">金额</div>',
                width: 150,
                editable: true,
                align: 'right',
                dataIndex: 'Amount',
                renderer: function(v) {
                    if (v != "") {
                        return Ext.util.Format.number(v, "0,000.00");
                    } else {
                        return v;
                    }
                }
            }
        ]

    });

    itemGridC.load({
        params: {
            CashJournalID: CashJournalID,
            start: 0,
            limit: 25
        }
    });
	
    if (staute == '提交') {
        batchButton.hide();
        itemGridC.btnAddHide();
        itemGridC.btnSaveHide();
        itemGridC.btnDeleteHide();
    }
    itemGridC.btnResetHide();
    itemGridC.btnPrintHide();



    var CheckWin = new Ext.Window({
        title: '辅助账录入',
        id: 'CheckWin',
        width: 560,
        height: 500,
        minWidth: 500,
        minHeight: 400,
        buttonAlign: 'center',
        layout: 'fit',
        plain: true,
        modal: true,
        items: itemGridC,
        buttons: [{
            xtype: 'button',
            text: '完成',
            handler: function() {
                var State = JournalState.getValue();
                var Sumarryv = Summary1.getValue();
                var StartDate = StartYearMonth.getValue();
                var EndDate = EndYearMonth.getValue();
                if (StartDate != "") {
                    var StartDateF = StartDate.format('Y-m-d');

                } else {
                    var StartDateF = "";
                }

                if (EndDate != "") {
                    var EndDateF = EndDate.format('Y-m-d');

                } else {
                    var EndDateF = "";
                }

            //  alert(itemGrid.getBottomToolbar().cursor);
                // itemGrid.load({
                // params:{

                // sortField:'',
                // sortDir:'',
                // start : Ext.isEmpty(itemGrid.getBottomToolbar().cursor)? 0: itemGrid.getBottomToolbar().cursor,
                // limit : itemGrid.pageSize,
                // SYearMonth:StartDateF,
                // EYearMonth:EndDateF,
                // Summary:Sumarryv,
                // JournalState:State,
                // AcctBookID:AcctBookID

                // }
                // });
              
                CheckWin.close();
                
				//关闭出口后刷新	--add 关闭后不刷新，停在当前位置
                var tbarnum = itemGrid.getBottomToolbar();
                tbarnum.doLoad(tbarnum.cursor);
				//alert(Index);
				//控制滚动条向下滚动
		       //itemGrid.getView().scroller.dom.scrollTop=itemGrid.getView().scroller.dom.scrollTop+50;
			
            }

        }]
    });


    // alert(checktext);
    if (checktext == 111) {
        CheckWin.title = "辅助帐明细查看";
        CheckWin.buttons[0].text = "关闭";
    }

    CheckWin.show();
//批量添加辅助账的方法
    var batchAdd = function() {

        var queryButton = new Ext.Toolbar.Button({
            text: '查询',
            tooltip: '查询',
            iconCls: 'find',
            handler: function() {
                batchfind();
            }
        });

//辅助账类型下拉框
        var CheckTypebDS = new Ext.data.Store({
            autoLoad: true,
            proxy: "",
            reader: new Ext.data.JsonReader({
                totalProperty: 'results',
                root: 'rows'
            }, ['typeID', 'typeName'])
        });

        CheckTypebDS.on('beforeload', function(ds, o) {
            ds.proxy = new Ext.data.HttpProxy({
                url: 'herp.acct.AcctCashJournalexe.csp' + '?action=CheckType&SubjID=' + SubjID + '&str=' + encodeURIComponent(Ext.getCmp('CheckTypeb').getRawValue()),
                method: 'POST'
            });
        });

        var CheckTypeb = new Ext.form.ComboBox({
            id: 'CheckTypeb',
            fieldLabel: '辅助账类型',
            width: 200,
            listWidth: 225,
            allowBlank: false,
            store: CheckTypebDS,
            valueField: 'typeID',
            displayField: 'typeName',
            triggerAction: 'all',
            emptyText: '请选择...',
            name: 'CheckType',
            minChars: 1,
            pageSize: 10,
            selectOnFocus: true,
            forceSelection: true,
            editable: true
        });



        var itemGridb = new dhc.herp.Gridb({
            // width: 550,
            // height:430,
            region: 'center',
            url: 'herp.acct.AcctCashJournalCheckexe.csp',
            atLoad: true,
            //forceFit:true,
            readerModel: 'remote',
            tbar: ['-', "辅助账类型：", CheckTypeb, '-', queryButton],
            fields: [
                new Ext.grid.CheckboxSelectionModel({
                    editable: false,
                    singleSelect: true
                }), {
                    id: 'CheckTypeID',
                    header: '<div style="text-align:center">CheckTypeID</div>',
                    width: 120,
                    editable: false,
                    align: 'left',
                    hidden: true,
                    dataIndex: 'CheckTypeID'
                }, {
                    id: 'CheckItemID',
                    header: '<div style="text-align:center">CheckItemID</div>',
                    width: 120,
                    editable: false,
                    align: 'left',
                    hidden: true,
                    dataIndex: 'CheckItemID'
                }, {
                    id: 'CheckTypeName',
                    header: '<div style="text-align:center">辅助账类型</div>',
                    width: 120,
                    align: 'left',
                    dataIndex: 'CheckTypeName'
                }, {
                    id: 'CheckItemName',
                    header: '<div style="text-align:center">辅助核算项</div>',
                    width: 150,
                    editable: true,
                    align: 'left',
                    dataIndex: 'CheckItemName'
                }
            ]

        });
   itemGridb.load({
                params: {
                    start: 0,
                    limit: 25,
					SubjID:SubjID,
                    AcctBookID: AcctBookID

                }
            });
			
        var batchfind = function() {

            var CheckTypeID = CheckTypeb.getValue();
            itemGridb.load({
                params: {
                    start: 0,
                    limit: 25,
					SubjID:SubjID,
                    AcctCheckTypeID: CheckTypeID,
                    AcctBookID: AcctBookID

                }
            });

        };
		
        itemGridb.btnResetHide();
        itemGridb.btnPrintHide();
        itemGridb.btnAddHide();
        itemGridb.btnSaveHide();
        itemGridb.btnDeleteHide();

        var BatchkWin = new Ext.Window({
            title: '辅助账录入',
            id: 'BatchkWin',
            width: 500,
            height: 400,
            minWidth: 400,
            minHeight: 350,
            buttonAlign: 'center',
            layout: 'fit',
            plain: true,
            modal: true,
            items: itemGridb,
            buttons: [{
                xtype: 'button',
                text: '确认',
                handler: function() {
                    var record = itemGridb.getSelectionModel().getSelections();
                    var len = record.length;
					if(len==0){
						 Ext.Msg.show({
                                title: '提示',
                                msg: '请先选择要添加的数据!',
                                buttons: Ext.Msg.OK,
                                icon: Ext.MessageBox.INFO
                            });
						//BatchkWin.close();
						return;
					}
                    var CheckItemIDMain = "";
                    for (var i = 0; i < len; i++) {
                        var CheckTypeID = record[i].data["CheckTypeID"];
                        var CheckItemID = record[i].data["CheckItemID"];
                        if (CheckItemID != "") {

                            if (CheckItemIDMain == "") {

                                CheckItemIDMain = CheckItemID
                            } else {
                                CheckItemIDMain = CheckItemIDMain + "^" + CheckItemID
                            }
                        }


                    }
                    //alert(CheckItemIDMain);

                    Ext.Ajax.request({
                        url: 'herp.acct.AcctCashJournalCheckexe.csp?action=batchAdd&CheckTypeID=' + CheckTypeID + "&CheckItemIDMain=" + CheckItemIDMain + "&CashJournalID=" + CashJournalID + "&SubjCode=" + SubjCode,
                        method: 'POST',
                        failure: function(result, request) {
                            Ext.Msg.show({
                                title: '错误',
                                msg: '请检查网络连接!',
                                buttons: Ext.Msg.OK,
                                icon: Ext.MessageBox.ERROR
                            });
                        },
                        success: function(result, request) {
                            var jsonData = Ext.util.JSON.decode(result.responseText);

                            //alert(jsonData.success );
                            if (jsonData.success == 'true') {
                                Ext.Msg.show({
                                    title: '提示',
                                    msg: '添加成功! ',
                                    buttons: Ext.Msg.OK,
                                    icon: Ext.MessageBox.INFO
                                });
					 var tbarnum = itemGridb.getBottomToolbar();
                     tbarnum.doLoad(tbarnum.cursor);
                            } else {
                                Ext.Msg.show({
                                    title: '提示',
                                    msg: '添加失败! ',
                                    buttons: Ext.Msg.OK,
                                    icon: Ext.MessageBox.INFO
                                });
                            }
                        }
                    });

                    itemGridC.load({
                        params: {
                            CashJournalID: CashJournalID,
                            start: 0,
                            limit: 25
                        }
                    });


                }
            }, {
                xtype: 'button',
                text: '关闭',
                handler: function() {
                    BatchkWin.close();
                }
            }]

        });

        BatchkWin.show();

    };
};
//辅助账录入结束