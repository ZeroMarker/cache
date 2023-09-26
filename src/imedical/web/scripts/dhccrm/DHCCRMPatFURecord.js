Ext.onReady(function() {
    // 气泡提示

    Ext.QuickTips.init();
    var qrrowid = '';
    // 病人信息
    var store = new Ext.data.Store({
        url : 'dhccrmfurecord1.csp?action=list',
        reader : new Ext.data.JsonReader({
                    totalProperty : "results",
                    root : "rows"
                }, ['PAPMINo', 'MRNAME', 'MRGENDER', 'MRBIRTHDAY', 'MRADMDATE',
                        'MRADMDIAG', 'MRMRID', 'MRDISMAINDIAGNAME',
                        'MRDISDATE', 'MRADMROOM', 'MRDISROOM', 'MRORGTEL',
                        'MRORGADDRESS', 'Subjects', 'PAADM', 'FollowUp',
                        'DeadCondition', 'papmiid', 'mrcardid',
                        'LinkCondition', 'DocName', 'DocIf', 'DocResult'])

            // 登记号 姓名 性别 出生日期 入院日期 入院诊断 病案号 出院诊断 出院日期 入院病室 出院病室 联系电话 联系地址 主题 计划
            // ADM号 随访记录 死亡情况
        });
    // 主题
    var fusbstore = new Ext.data.Store({
                url : 'dhccrmfurecord1.csp?action=fusblist',
                reader : new Ext.data.JsonReader({
                            totalProperty : "results",
                            root : "rows"
                        }, ['FUSRowId', 'FUSCode', 'FUSDesc', 'FUPSRowId'])
            });
    // 主题内容
    var fusdstore = new Ext.data.Store({
                url : 'dhccrmfurecord1.csp?action=fusdlist',
                reader : new Ext.data.JsonReader({
                            totalProperty : "results",
                            root : "rows"
                        },
                        ['SDRowId', 'SDCode', 'SDDesc', 'SDType', 'SDActive'])
            });
    // 选择默认
    var furstore = new Ext.data.Store({
                url : 'dhccrmfurecord1.csp?action=furlist',
                reader : new Ext.data.JsonReader({
                            totalProperty : "results",
                            root : "rows"
                        }, ['SDRowId', 'SDSTextVal'])
            });
    fusbstore.load();
    /*
     * fusbstore.on('beforeload', function() { var subjects =
     * Ext.getCmp('Subjects').getValue();
     * 
     * if (subjects == "") return;
     * 
     * fusbstore.proxy.conn.url =
     * 'dhccrmfurecord1.csp?action=fusblist&Subjects=' + subjects;
     * 
     * });
     */
    store.on('beforeload', function() {
                var patname = Ext.getCmp('patname').getValue();
                var papmino = Ext.getCmp('papmino').getValue();
                // var patdisdiag = Ext.getCmp('patdisdiag').getValue();
                var Condition = Ext.getCmp('Condition').getValue();
                var ZSCondition = Ext.getCmp('ZSCondition').getValue();
                var FollowFlag = Ext.getCmp('FollowFlag').getValue();
                var Loc = Ext.getCmp('Loc').getValue();
                var patstartdate = '';
                if (Ext.getCmp('patstartdate').getValue() != '') {
                    patstartdate = Ext.getCmp('patstartdate').getValue()
                            .format('Y-m-d').toString();
                }
                var patenddate = '';
                if (Ext.getCmp('patenddate').getValue() != '') {
                    patenddate = Ext.getCmp('patenddate').getValue()
                            .format('Y-m-d').toString();
                }
                var telno = Ext.getCmp('telno').getValue();
                store.proxy.conn.url = 'dhccrmfurecord1.csp?action=list'
                        + '&PatName=' + encodeURIComponent(patname)
                        + '&PAPMINo=' + papmino + '&DisDiag=' + ""
                        + '&StartDate=' + patstartdate + '&EndDate='
                        + patenddate + '&FollowFlag=' + FollowFlag + '&Loc='
                        + Loc + '&Condition=' + Condition + '&TelNo=' + telno
                        + '&ZSCondition=' + ZSCondition;

            });

    Ext.grid.CheckColumn = function(config) {
        Ext.apply(this, config);
        if (!this.id) {
            this.id = Ext.id();
        }
        this.renderer = this.renderer.createDelegate(this);
    };

    Ext.grid.CheckColumn.prototype = {
        init : function(grid) {
            this.grid = grid;
            this.grid.on('render', function() {
                        var view = this.grid.getView();
                        view.mainBody.on('mousedown', this.onMouseDown, this);
                    }, this);
        },
        onMouseDown : function(e, t) {
            if (t.className
                    && t.className.indexOf('x-grid3-cc-' + this.id) != -1) {
                e.stopEvent();
                var index = this.grid.getView().findRowIndex(t);
                var cindex = this.grid.getView().findCellIndex(t);
                var record = this.grid.store.getAt(index);
                var field = this.grid.colModel.getDataIndex(cindex);
                var e = {
                    grid : this.grid,
                    record : record,
                    field : field,
                    originalValue : record.data[this.dataIndex],
                    value : !record.data[this.dataIndex],
                    row : index,
                    column : cindex,
                    cancel : false
                };
                if (this.grid.fireEvent("validateedit", e) !== false
                        && !e.cancel) {
                    delete e.cancel;
                    record.set(this.dataIndex, !record.data[this.dataIndex]);
                    this.grid.fireEvent("afteredit", e);
                }
            }
        },
        renderer : function(v, p, record) {
            p.css += ' x-grid3-check-col-td';
            return '<div class="x-grid3-check-col' + (v ? '-on' : '')
                    + ' x-grid3-cc-' + this.id + '"> </div>';
        }
    };

    var checkColumn1 = new Ext.grid.CheckColumn({
                header : "死亡情况",
                dataIndex : 'DeadCondition'
            });
    var checkColumn2 = new Ext.grid.CheckColumn({
                header : "随访情况",
                dataIndex : 'FollowUp'
            });
    var cm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
                header : "登记号",
                dataIndex : 'PAPMINo',
                sortable : true
            }, {
                header : "姓名",
                dataIndex : 'MRNAME',
                sortable : true

            }, {
                header : "性别",
                dataIndex : 'MRGENDER',
                sortable : true
            }, {
                header : "年龄",
                dataIndex : 'MRBIRTHDAY',
                sortable : true
            }, {
                header : "身份证号",
                dataIndex : 'mrcardid',
                width : 150,
                sortable : true
            }, {
                header : "入院日期",
                dataIndex : 'MRADMDATE',
                sortable : true
            }, {
                header : "入院诊断",
                dataIndex : 'MRADMDIAG',
                hidden : true
            }, {
                header : "病案号",
                dataIndex : 'MRMRID'
            }, {
                header : "出院诊断",
                dataIndex : 'MRDISMAINDIAGNAME',
                width : 200
            }, {
                header : "出院日期",
                dataIndex : 'MRDISDATE'
            }, {
                header : "入院病室",
                dataIndex : 'MRADMROOM',
                hidden : true
            }, {
                header : "出院病室",
                dataIndex : 'MRDISROOM',
                sortable : true
            }, {
                header : "联系电话",
                dataIndex : 'MRORGTEL'
            }, {
                header : "联系地址",
                dataIndex : 'MRORGADDRESS'
            }, checkColumn2, checkColumn1, {
                header : "PAPMI",
                dataIndex : 'papmiid',
                hidden : true
            }, {
                header : "联系不上原因",
                dataIndex : 'LinkCondition'
            }, {
                header : "主治医师",
                dataIndex : 'DocName'
            }, {
                header : "医生随访",
                dataIndex : 'DocIf',
                hidden : true

            }, {
                header : "医生结果",
                dataIndex : 'DocResult',
                hidden : true
            }, {
                header : "Subjects",
                dataIndex : 'Subjects',
                hidden : true
            }]);

    var bbar = new Ext.PagingToolbar({
                pageSize : 10,
                store : store
            });
    var sm = new Ext.grid.CheckboxSelectionModel();
    var grid = new Ext.grid.EditorGridPanel({
                region : 'center',
                // collapsible: true,
                plugins : [checkColumn1, checkColumn2],
                sortable : true,
                viewConfig : {
                    forceFit : true
                },
                store : store,
                cm : cm,
                sm : sm,
                stripeRows : true,
                bbar : bbar
            });
    var nolinkstore = new Ext.data.SimpleStore({
                fields : ['linkid', 'linkname'],
                data : [['空号', '空号'], ['关机', '关机'], ['无人接听', '无人接听'],
                        ['拒接', '拒接'], ['号码错误', '号码错误'], ['拒绝交流沟通', '拒绝交流沟通'],
                        ['家属不了解情况', '家属不了解情况']]
            });
    var linkform = new Ext.form.FormPanel({

                frame : true,
                autoHeight : true,
                items : [{
                            layout : 'column',
                            items : [{
                                        columnWidth : 1,
                                        layout : 'form',
                                        items : [{
                                                    xtype : 'label',
                                                    text : '',
                                                    id : 'linknum',
                                                    name : 'linknum'
                                                }]
                                    }]
                        }, {
                            layout : 'column',
                            items : [{
                                        columnWidth : 1,
                                        layout : 'form',
                                        items : [{
                                                    xtype : 'combo',
                                                    fieldLabel : '联系不上原因',
                                                    store : nolinkstore,
                                                    id : 'linkreason',
                                                    name : 'linkreason',
                                                    mode : 'local',
                                                    displayField : 'linkname',
                                                    triggerAction : 'all',
                                                    valueField : 'linkid'
                                                }]
                                    }]
                        }, {
                            layout : 'column',
                            items : [{
                                        columnWidth : 1,
                                        layout : 'form',
                                        items : [{
                                                    xtype : 'label',
                                                    text : '',
                                                    id : 'linknum1',
                                                    name : 'linknum1'
                                                }]
                                    }]
                        }, {
                            layout : 'column',
                            items : [{
                                        columnWidth : 1,
                                        layout : 'form',
                                        items : [{
                                                    xtype : 'label',
                                                    text : '',
                                                    id : 'linknum2',
                                                    name : 'linknum2'
                                                }]
                                    }]
                        }, {
                            layout : 'column',
                            items : [{
                                        columnWidth : 1,
                                        layout : 'form',
                                        items : [{
                                                    xtype : 'label',
                                                    text : '',
                                                    id : 'linknum3',
                                                    name : 'linknum3'
                                                }]
                                    }]
                        }]
            })

    linkform.on('afterlayout', function(form, layout) {
                Ext.getCmp('linknum1').setText("");
                Ext.getCmp('linknum2').setText("");
                Ext.getCmp('linknum3').setText("");
                var fupid = Ext.getCmp('Subjects').getValue()
                fupid = fupid.split("^")[1]
                var str = tkMakeServerCall('web.DHCCRM.FUSubject',
                        "GetLinkNum", fupid)
                var num = str.split("^")[0]
                num = parseInt(num) + 1
                Ext.getCmp('linknum').setText(Ext.getCmp('MRNAME').getValue()
                        + '当前第' + num + '次联系不上')

                var reason = str.split("^")[1].split(";")

                Ext.getCmp('linknum1').setText('第1次联系不上原因:' + reason[0])
                if (reason[1])
                    Ext.getCmp('linknum2').setText('第2次联系不上原因:' + reason[1])
                if (reason[2])
                    Ext.getCmp('linknum3').setText('第3次联系不上原因:' + reason[2])

            })
    var linksave = function() {
        var fupid = Ext.getCmp('Subjects').getValue()
        fupid = fupid.split("^")[1]
        var reason = Ext.getCmp('linkreason').getValue()

        var str = tkMakeServerCall('web.DHCCRM.FUSubject', "GetLinkNum", fupid)
        var num = str.split("^")[0]
        var oldreason = str.split("^")[1]
        num = parseInt(num) + 1
        if (num == 4) {
            alert('超过3次联系不上!');
            return
        }
        if (oldreason != "")
            reason = oldreason + ";" + reason;

        var ret = tkMakeServerCall('web.DHCCRM.FUSubject', "SetLinkFlag",
                fupid, num, reason)

        if (ret == 0)
            linkwindow.hide();
        findPatList();
        tkMakeServerCall('web.DHCCRM.FUSubject', "SetLinkInfo", fupid, "Z")
        if ((reason.indexOf("空号") >= 0) || (reason.indexOf("号码错误") >= 0)
                || (reason.indexOf("拒绝交流沟通") >= 0)
                || (reason.indexOf("家属不了解情况") >= 0))
            tkMakeServerCall('web.DHCCRM.FUSubject', "SetLinkInfo", fupid, "L")
        if (num == 3)
            tkMakeServerCall('web.DHCCRM.FUSubject', "SetLinkInfo", fupid, "L")
    }
    var linkwindow = new Ext.Window({

                title : '<b>联系信息',
                width : 500,
                height : 400,
                layout : 'fit',
                plain : true,
                closeAction : 'hide',
                bodyStyle : 'padding:10px;',
                buttonAlign : 'center',
                items : linkform,
                buttons : [{
                            xtype : 'tbbutton',
                            text : '保存',
                            handler : linksave
                        }]
            });
    grid.on('cellclick', function(grid, rowIndex, columnIndex, e) {

                var record = grid.getStore().getAt(rowIndex);
                var fieldName = grid.getColumnModel().getDataIndex(columnIndex);
                if (fieldName == 'LinkCondition') {

                    linkwindow.show();

                }

            })
    grid.on('afteredit', function(e) {

                var patno = e.record.get("PAPMINo");
                var fupid = e.record.get("Subjects").split("^")[1];
                if (e.field == 'DeadCondition') {
                    var deadflag = cspRunServerMethod(setdeadflag, e.value,
                            fupid);
                    if (deadflag == 0)
                        alert("更新成功!")
                }

            });
    findPatList = function() {

        store.load({
                    params : {
                        start : 0,
                        limit : bbar.pageSize
                    }
                });
        if (dynamicpanel.getComponent('panel') != null) {
            dynamicpanel.remove(dynamicpanel.getComponent('panel'));
        };
    };

    var fuICDstore = new Ext.data.Store({
                url : 'dhccrmsetplan1.csp?action=fuICDlist',
                reader : new Ext.data.JsonReader({
                            totalProperty : "results",
                            root : "rows"
                        }, ['RowID', 'Name'])
            })

    var locstore = new Ext.data.Store({
                url : 'dhccrmsetplan1.csp?action=loclist',
                reader : new Ext.data.JsonReader({
                            totalProperty : 'results',
                            root : 'rows'
                        }, ['RowID', 'Name'])
            })

    var Loc = new Ext.form.ComboBox({
        enableKeyEvents : true,
        fieldLabel : '科室',
        width : 125,
        store : locstore,
        valueField : 'RowID',
        displayField : 'Name',
        triggerAction : 'all',
        id : 'Loc',
        mode : 'local',
        PageSize : 20,
        minListWidth : 220,
        selectOnFocus : true,
        listeners : {
            'specialkey' : function(obj, e) {
                if (e.getKey() == e.ENTER) {
                var locDesc = obj.getRawValue();
                locDesc=encodeURI(encodeURI(locDesc))
                obj.store.proxy.conn.url = 'dhccrmsetplan1.csp?action=loclist&locDesc='
                        + locDesc;
                obj.store.load({});
                }
            }
        }
    })

    var mrdisdiagname = new Ext.form.ComboBox({
        enableKeyEvents : true,
        fieldLabel : '出院诊断',
        width : 150,
        store : fuICDstore,
        valueField : 'RowID',
        displayField : 'Name',
        triggerAction : 'all',
        id : 'patdisdiag',
        mode : 'local',
        PageSize : 20,
        minListWidth : 220,
        selectOnFocus : true,
        listeners : {
            'specialkey' : function(obj, e) {
                if (e.getKey() == e.ENTER) {
                    var ICDDesc = obj.getRawValue();
                    if (ICDDesc == "")
                        return;
                    obj.store.proxy.conn.url = 'dhccrmsetplan1.csp?action=fuICDlist&ICDDesc='
                            + ICDDesc;
                    obj.store.load({});
                }

            }
        }
    })
    function DeletePatList() {
        var fupid = Ext.getCmp('Subjects').getValue()
        fupid = fupid.split("^")[1]
        var ret = tkMakeServerCall("web.DHCCRM.FUSubject", "DeleteFupById",
                fupid)
        if (ret == 0) {
            findPatList()
        }
        if (ret == 1) {
            alert("已随访不允许!")
        }
    }
    var queryinfo = new Ext.form.FormPanel({
        region : 'north',
        height : 90,
        frame : true,
        labelWidth : 100,
        layout : 'column',
        items : [{
                    columnWidth : 1 / 4,
                    layout : 'form',
                    items : [{
                                fieldLabel : '登记/住院号',
                                id : 'papmino',
                                xtype : 'textfield',
                                listeners : {
                                    specialkey : function(field, e) {
                                        if (e.getKey() == Ext.EventObject.ENTER) {
                                            findPatList();
                                        }
                                    }
                                }
                            }]
                }, {
                    columnWidth : 1 / 4,
                    layout : 'form',
                    items : [{
                                fieldLabel : '姓名',
                                id : 'patname',
                                xtype : 'textfield',
                                listeners : {
                                    specialkey : function(field, e) {
                                        if (e.getKey() == Ext.EventObject.ENTER) {
                                            findPatList();
                                        }
                                    }
                                }
                            }]
                }, {
                    columnWidth : 1 / 8,
                    layout : 'form',
                    xtype : 'checkbox',
                    boxLabel : '联系不上',
                    id : 'Condition',
                    name : 'Condition'

                }, {
                    columnWidth : 1 / 8,
                    layout : 'form',
                    xtype : 'checkbox',
                    boxLabel : '暂时联系不上',
                    id : 'ZSCondition',
                    name : 'ZSCondition'

                }, {
                    columnWidth : 1 / 4,
                    layout : 'form',
                    items : [{
                                fieldLabel : '联系电话',
                                id : 'telno',
                                xtype : 'textfield'
                            }]
                }, {
                    columnWidth : 1 / 4,
                    layout : 'form',
                    items : [{
                                fieldLabel : '开始日期',
                                width : 125,
                                id : 'patstartdate',
                                xtype : 'datefield'
                            }]
                }, {
                    columnWidth : 1 / 4,
                    layout : 'form',
                    items : [{
                                fieldLabel : '结束日期',
                                width : 125,
                                id : 'patenddate',
                                xtype : 'datefield'
                            }]
                }, {

                    columnWidth : 1 / 4,
                    layout : 'form',
                    xtype : 'checkbox',
                    boxLabel : '已随访',
                    id : 'FollowFlag',
                    name : 'FollowFlag'
                }, {
                    columnWidth : 1 / 4,
                    layout : 'form',
                    items : Loc
                }]

    });
    function SaveTel(personid, newtel) {
        var ret = tkMakeServerCall("web.DHCCRM.PatInfo", "UpdateTel", personid,
                newtel);
        if (ret == 0)
            alert("更新成功")
    }
    var cxbutton = new Ext.Button({
                text : '查询',
                handler : findPatList,
                pressed : true
            })
    var scbutton = new Ext.Button({
                text : '删除当前未随访记录',
                handler : DeletePatList,
                pressed : true

            })
    var cxbuttonPanel = new Ext.Panel({
                width : 100,
                items : cxbutton
            })
    var patbar = new Ext.Toolbar({

                items : [cxbuttonPanel, scbutton]

            });
    var patpanel = new Ext.Panel({
                region : 'north',
                title : '患者列表',
                layout : 'border',
                autoScroll : true,
                collapsible : true,
                frame : true,
                height : 250,
                tbar : patbar,
                items : [queryinfo, grid]
            });

    var RTimeLabel = new Ext.form.Label({
                html : '<p><h1><br><FONT SIZE =3 color=red>已录音时间0秒</FONT></h1></p>'
            });

    var RTime = 0;
    var task = {
        run : function() {
            RTime = RTime + 1;
            RTimeLabel.destroy();
            RTimeLabel = new Ext.form.Label({
                        html : '<p><h1><br><FONT SIZE =3 color=red>已录音时间'
                                + RTime + '秒</FONT></h1></p>'
                    });
            form.add(RTimeLabel);
            form.doLayout(true);
        },
        interval : 1000
        // 1 second
    }

    form = new Ext.form.FormPanel({
        region : 'west',
        title : '详细信息',
        frame : true,
        id : 'form',
        width : 300,
        autoScroll : true,
        collapsible : true,
        items : [new Ext.Toolbar({
            items : [{
                xtype : 'tbbutton',
                hidden : true,
                pressed : true,
                text : '登录呼叫中心',
                handler : function() {
                    var loginform = new Ext.form.FormPanel({
                        frame : true,
                        labelWidth : 80,
                        autoHeight : true,
                        items : [{
                                    layout : 'column',
                                    items : [{
                                                columnWidth : 1,
                                                layout : 'form',
                                                items : [{
                                                            xtype : 'textfield',
                                                            fieldLabel : '分机号',
                                                            id : 'ExtNumber',
                                                            name : 'ExtNumber',
                                                            auchor : '90%',
                                                            allowBlank : false
                                                        }]
                                            }]
                                }, {
                                    layout : 'column',
                                    items : [{
                                                columnWidth : 1,
                                                layout : 'form',
                                                items : [{
                                                            xtype : 'textfield',
                                                            fieldLabel : '组号',
                                                            id : 'GroupID',
                                                            name : 'GroupID',
                                                            auchor : '90%',
                                                            allowBlank : false
                                                        }]
                                            }]
                                }, {
                                    layout : 'column',
                                    items : [{
                                                columnWidth : 1,
                                                layout : 'form',
                                                items : [{
                                                            xtype : 'textfield',
                                                            fieldLabel : '工号',
                                                            id : 'AgentID',
                                                            name : 'AgentID',
                                                            auchor : '90%',
                                                            allowBlank : false
                                                        }]
                                            }]
                                }]
                    });

                    var window = new Ext.Window({

                                title : '登录',
                                width : 300,
                                height : 200,
                                layout : 'fit',
                                plain : true,
                                modal : true,
                                buttonAlign : 'center',
                                items : loginform,
                                buttons : [{
                                    xtype : 'tbbutton',
                                    text : '确定',
                                    handler : function() {
                                        var extnumber = Ext.getCmp('ExtNumber')
                                                .getValue();
                                        var groupid = Ext.getCmp('GroupID')
                                                .getValue();
                                        var agentid = Ext.getCmp('AgentID')
                                                .getValue();

                                        InitSoftPhone(extnumber, groupid,
                                                agentid);
                                        var ret = tkMakeServerCall(
                                                "web.DHCCRM.PatInfo",
                                                "SaveLogin", extnumber,
                                                groupid, agentid);
                                        window.close();
                                    }
                                }]
                            });

                    window.show();
                }

            }, {

                xtype : 'tbbutton',
                pressed : true,
                hidden : true,
                text : '开始录音',
                handler : function() {
                    var telnumber = Ext.getCmp('MRORGTEL').getValue();
                    if (this.text == "开始录音") {
                        StartRecord(telnumber);
                        this.setText("结束录音");
                    } else {
                        EndRecord();
                        this.setText("开始录音");
                    }
                }

            }, {

                xtype : 'tbbutton',
                pressed : true,
                hidden : true,
                text : '结束录音',
                handler : function() {
                    EndRecord();
                }

            }, {

                xtype : 'tbbutton',
                pressed : true,
                text : '拨号录音',
                handler : function() {
                    RTime = 0;

                    var telnumber = Ext.getCmp('MRORGTEL').getValue();
                    var telfup = Ext.getCmp('Subjects').getValue().split("^")[1];

                    if (telfup) {
                    } else {
                        alert('请先选择一条记录!');
                        return
                    }
                    DoMakeCall(telnumber, telfup);
                    // var ret = tkMakeServerCall("web.DHCCRM.PatInfo",
                    // "GetLogin");
                    // MakeCall(ret,telnumber)
                    Ext.TaskMgr.start(task);
                }

            }, {

                xtype : 'tbbutton',
                pressed : true,
                text : '挂断结束',
                handler : function() {
                    var telfup = Ext.getCmp('Subjects').getValue().split("^")[1];
                    DoHangupCall(telfup);
                    Ext.TaskMgr.stopAll();
                    // RTimeLabel.destroy();
                    // form.doLayout(true);
                }
            }, {

                xtype : 'tbbutton',
                pressed : true,
                text : '播放录音',
                handler : function() {
                    var telfup = Ext.getCmp('Subjects').getValue().split("^")[1];
                    var LuYinWJ = GetLuYinFile(telfup);
                    if (LuYinWJ == "") {
                        Ext.Msg.show({
                                    title : '提示',
                                    msg : '未找到录音文件!',
                                    buttons : Ext.Msg.OK,
                                    icon : Ext.MessageBox.INFO
                                });
                        return;
                    }
                    var luyinPlayer = new Ext.Window({
                        layout : 'fit',
                        frame : true,
                        width : 310,
                        modal : true,
                        autoHeight : true,
                        items : [new Ext.Panel({
                                    html : '<embed width="420" height="360" src='
                                            + LuYinWJ + '></embed>'

                                })]
                    });
                    luyinPlayer.show();

                    luyinPlayer.doLayout();

                }
            }]
        }), {
            layout : 'column',
            labelWidth : 80,
            items : [{
                        columnWidth : 1,
                        layout : 'form',
                        items : [{
                                    xtype : 'hidden',
                                    name : 'Subjects',
                                    id : 'Subjects',
                                    width : 160,
                                    disabled : true
                                }]
                    }]
        }, {
            layout : 'column',
            labelWidth : 80,
            items : [{
                        columnWidth : 1,
                        layout : 'form',
                        items : [{
                                    xtype : 'hidden',
                                    name : 'PAADM',
                                    id : 'PAADM',
                                    width : 160,
                                    disabled : true
                                }]
                    }]
        }, {
            layout : 'column',
            labelWidth : 80,
            items : [{
                        columnWidth : 1,
                        layout : 'form',
                        items : [{
                                    xtype : 'hidden',
                                    name : 'papmiid',
                                    id : 'papmiid',
                                    width : 160,
                                    disabled : true
                                }]
                    }]
        }, {
            labelWidth : 80,
            columnWidth : 1,
            layout : 'form',
            items : [{
                        xtype : 'combo',
                        fieldLabel : '随访主题',
                        id : 'fusbcombo',
                        name : 'fusbcombo',
                        store : fusbstore,
                        mode : 'local',
                        valueField : 'FUPSRowId',
                        displayField : 'FUSDesc',
                        triggerAction : 'all',
                        emptyText : '点击选择主题',
                        disabled : true,
                        listeners : {
                            focus : function() {

                                fusbstore.reload();
                            }
                        }
                    }]
        }, {
            labelWidth : 80,
            columnWidth : 1,
            layout : 'form',
            items : [{
                        xtype : 'textfield',
                        fieldLabel : '联系电话',
                        id : 'MRORGTEL',
                        width : 160,
                        name : 'MRORGTEL',
                        listeners : {
                            specialkey : function(field, e) {
                                if (e.getKey() == Ext.EventObject.ENTER) {
                                    PAPMIID = Ext.getCmp('papmiid').getValue();
                                    if(this.getValue()=='') 
                                    {
                                        alert("联系电话不能为空");
                                        return;
                                    }
                                    SaveTel(PAPMIID, this.getValue());
                                }
                            }
                        }
                    }]
        }, {
            layout : 'column',
            labelWidth : 80,
            items : [{
                        columnWidth : 1,
                        layout : 'form',
                        items : [{
                                    xtype : 'textfield',
                                    fieldLabel : '登记号',
                                    id : 'patno',
                                    name : 'PAPMINo',
                                    width : 160,
                                    disabled : true
                                }]
                    }, {
                        columnWidth : 1,
                        layout : 'form',
                        items : [{
                                    xtype : 'textfield',
                                    fieldLabel : '姓名',
                                    id : 'MRNAME',
                                    name : 'MRNAME',
                                    width : 160,
                                    disabled : true
                                }]
                    }, {
                        columnWidth : 1,
                        layout : 'form',
                        items : [{
                                    xtype : 'textfield',
                                    fieldLabel : '性别',
                                    name : 'MRGENDER',
                                    width : 160,
                                    disabled : true
                                }]
                    }, {
                        columnWidth : 1,
                        layout : 'form',
                        items : [{
                                    xtype : 'textfield',
                                    fieldLabel : '年龄',
                                    name : 'MRBIRTHDAY',
                                    width : 160,
                                    disabled : true
                                }]
                    }, {
                        columnWidth : 1,
                        layout : 'form',
                        items : [{
                                    xtype : 'textfield',
                                    fieldLabel : '入院日期',
                                    name : 'MRADMDATE',
                                    width : 160,
                                    disabled : true

                                }]
                    }, {
                        columnWidth : 1,
                        layout : 'form',
                        items : [{
                                    xtype : 'hidden',
                                    fieldLabel : '入院诊断',
                                    name : 'MRADMDIAG',
                                    width : 160,
                                    disabled : true
                                }]
                    }, {
                        columnWidth : 1,
                        layout : 'form',
                        items : [{
                                    xtype : 'hidden',
                                    fieldLabel : '病案号',
                                    name : 'MRMRID',
                                    width : 160,
                                    disabled : true
                                }]
                    }, {
                        columnWidth : 1,
                        layout : 'form',
                        items : [{
                                    xtype : 'textfield',
                                    fieldLabel : '出院诊断',
                                    name : 'MRDISMAINDIAGNAME',
                                    width : 160,
                                    disabled : true
                                }]
                    }, {
                        columnWidth : 1,
                        layout : 'form',
                        items : [{
                                    xtype : 'textfield',
                                    fieldLabel : '出院日期',
                                    name : 'MRDISDATE',
                                    width : 160,
                                    disabled : true
                                }]
                    }, {
                        columnWidth : 1,
                        layout : 'form',
                        items : [{
                                    xtype : 'hidden',
                                    fieldLabel : '入院病室',
                                    name : 'MRADMROOM',
                                    width : 160,
                                    disabled : true
                                }]
                    }, {
                        columnWidth : 1,
                        layout : 'form',
                        items : [{
                                    xtype : 'textfield',
                                    fieldLabel : '出院病室',
                                    name : 'MRDISROOM',
                                    width : 160,
                                    disabled : true
                                }]
                    }, {
                        columnWidth : 1,
                        layout : 'form',
                        items : [{
                                    xtype : 'hidden',
                                    fieldLabel : '联系地址',
                                    name : 'MRORGADDRESS',
                                    hidden : true,
                                    disabled : true
                                }]
                    }]
        }]
    });

    Ext.getCmp('fusbcombo').on('select', function() {
        if (Ext.getCmp('PAADM').getValue() == '') {
            Ext.Msg.show({
                        title : '错误',
                        msg : '请先选择一个患者!',
                        buttons : Ext.Msg.OK,
                        icon : Ext.MessageBox.ERROR
                    });
            return;
        }
        var fusrowid = this.getValue().split("^")[1];
        PlanID = fusrowid;
        FUPRowId = this.getValue().split("^")[0];
        adm = Ext.getCmp('PAADM').getValue();
        PAPMIID = Ext.getCmp('papmiid').getValue();
        RecordID = cspRunServerMethod(getRecordID, FUPRowId);
        CreateMainPanel();

        if (dynamicpanel.getComponent('panel') != null) {
            dynamicpanel.remove(dynamicpanel.getComponent('panel'));
        };
        dynamicpanel.add(panel);
        dynamicpanel.doLayout();
            /*
             * //加载默认信息 furstore.proxy.conn.url =
             * 'dhccrmfurecord1.csp?action=furlist&FUSRowId=' + fusrowid;
             * furstore.load(); //加载主题内容 fusdstore.proxy.conn.url =
             * 'dhccrmfurecord1.csp?action=fusdlist&FUSRowId=' + fusrowid;
             * fusdstore.load();
             */
        });

    dynamicpanel = new Ext.Panel({
                region : 'center',
                id : 'dynamicpanel',
                autoScroll : true,
                // collapsible: true,
                layout : 'fit'
            });

    var fuspanel = new Ext.Panel({
                region : 'center',
                layout : 'border',
                autoScroll : true,
                // collapsible: true,
                frame : true,
                items : [form, dynamicpanel]
            });

    var mainPanel = new Ext.Viewport({
                layout : 'border',
                // collapsible: true,
                items : [patpanel, fuspanel]

            });

    fusdstore.on('load', function() {

        var fursave = function() {

            var furresult = '';
            for (var i = 0; i < fusdstore.getCount(); i++) {
                var fusdrecord = fusdstore.getAt(i);
                var furvalue = fusdrecord.get('SDRowId');
                if ((furform.getForm().findField(furvalue) != null)) {
                    if (furresult == '') {
                        furresult = furvalue
                                + '^'
                                + furform.getForm().findField(furvalue)
                                        .getValue();
                    } else {
                        furresult = furresult
                                + '$'
                                + furvalue
                                + '^'
                                + furform.getForm().findField(furvalue)
                                        .getValue();
                    }

                }
            };
            // var subjects = Ext.getCmp('Subjects').getValue();
            var furUrl = 'dhccrmfurecord1.csp?action=fursave&PAADM='
                    + Ext.getCmp('PAADM').getValue() + '&FUPRowId='
                    + Ext.getCmp('Subjects').getValue().split("^")[1]
                    + '&QRRowId=' + qrrowid + '&FURResult=' + furresult;

            if (furform.getForm().isValid()) {
                Ext.Ajax.request({
                            url : furUrl,
                            waitMsg : '保存中...',
                            failure : function(result, request) {
                                Ext.Msg.show({
                                            title : '错误',
                                            msg : '请检查网络连接!',
                                            buttons : Ext.Msg.OK,
                                            icon : Ext.MessageBox.ERROR
                                        });
                            },
                            success : function(result, request) {
                                var jsonData = Ext.util.JSON
                                        .decode(result.responseText);
                                if (jsonData.success == 'true') {
                                    Ext.Msg.show({
                                                title : '提示',
                                                msg : '数据保存成功!',
                                                buttons : Ext.Msg.OK,
                                                icon : Ext.MessageBox.INFO
                                            });
                                    qrrowid = jsonData.info;
                                } else {
                                    Ext.MessageBox.show({
                                                title : '错误',
                                                msg : jsonData.info,
                                                buttons : Ext.MessageBox.OK,
                                                icon : Ext.MessageBox.ERROR
                                            });
                                }
                            },
                            scope : this
                        });
            } else {
                Ext.Msg.show({
                            title : '错误',
                            msg : '请修正页面提示的错误后提交',
                            buttons : Ext.Msg.OK,
                            icon : Ext.MessageBox.ERROR
                        });
            }

        };
        var furform = new Ext.form.FormPanel({
                    id : 'furform',
                    frame : true,
                    labelWidth : 350,
                    autoHeight : true,
                    layout : 'column',
                    buttons : [{
                                xtype : 'button',
                                text : '保存',
                                handler : fursave
                            }]
                });

        var sdsstore = new Ext.data.Store({

                    url : 'dhccrmfurecord1.csp?action=sdslist',

                    reader : new Ext.data.JsonReader({
                                totalProperty : 'results',
                                root : 'rows'
                            }, ['SDSRowId', 'SDSTextVal'])
                });

        for (var i = 0; i < fusdstore.getCount(); i++) {
            // alert("333")
            var fusdrecord = fusdstore.getAt(i);
            if (fusdrecord.get('SDActive') == 'false')
                continue;

            if (fusdrecord.get('SDType') == 'S') {

                furform.add(new Ext.Panel({
                    layout : 'form',
                    columnWidth : 1,
                    items : [{
                        xtype : 'multicombo',
                        fieldLabel : fusdrecord.get('SDDesc'),
                        id : fusdrecord.get('SDRowId'),
                        name : fusdrecord.get('SDCode'),
                        store : sdsstore,
                        mode : 'local',
                        hiddenName : 'test',
                        displayField : 'SDSTextVal',
                        triggerAction : 'all',
                        emptyText : '请点击选择',
                        listeners : {
                            focus : function() {
                                var sdrowid = this.id;
                                sdsstore.on('beforeload', function() {
                                    sdsstore.proxy.conn.url = 'dhccrmfurecord1.csp?action=sdslist&SDRowId='
                                            + sdrowid;
                                });
                                sdsstore.reload();
                            }
                        }
                    }]
                }));
            };
            if (fusdrecord.get('SDType') == 'T') {
                furform.add(new Ext.Panel({
                            layout : 'form',
                            columnWidth : 1,
                            items : [{
                                        xtype : 'textfield',
                                        fieldLabel : fusdrecord.get('SDDesc'),
                                        id : fusdrecord.get('SDRowId'),
                                        name : fusdrecord.get('SDRowId'),
                                        emptyText : '请填写内容',
                                        width : 160
                                    }]
                        }))
            };
            if (fusdrecord.get('SDType') == 'N') {
                furform.add(new Ext.Panel({
                            layout : 'form',
                            columnWidth : 1,
                            items : [{
                                        xtype : 'numberfield',
                                        fieldLabel : fusdrecord.get('SDDesc'),
                                        id : fusdrecord.get('SDRowId'),
                                        name : fusdrecord.get('SDRowId'),
                                        emptyText : '请填写数字',
                                        width : 160
                                    }]
                        }))
            };

        };

        furform.doLayout();
        furform.on('afterlayout', function(furform, layout) {

                    for (i = 0; i < furstore.getCount(); i++) {
                        var furrecord = furstore.getAt(i);
                        var fusdid = furrecord.get('SDRowId');
                        var fusdval = furrecord.get('SDSTextVal');
                        if (furform.getForm().findField(fusdid) != null)
                            furform.getForm().findField(fusdid)
                                    .setValue(fusdval);
                    }

                });
        if (dynamicpanel.getComponent('furform') != null) {
            dynamicpanel.remove(dynamicpanel.getComponent('furform'));
        };
        dynamicpanel.add(Ext.getCmp('furform'));
        dynamicpanel.doLayout();
    });

    grid.on('rowclick', function(grid, rowIndex, event) {
        var tmpplan = Ext.getCmp('Subjects').getValue().split("^")[1];

        var record = grid.getStore().getAt(rowIndex);
        form.getForm().loadRecord(record);

        qrrowid = '';
        var fusrowid = Ext.getCmp('Subjects').getValue().split("^")[0];
        PlanID = fusrowid;
        FUPRowId = Ext.getCmp('Subjects').getValue().split("^")[1];

        if (tmpplan == FUPRowId) {
            // alert('同一条计划，请稍等刷新');
            return
        }
        Ext.getCmp('fusbcombo').setValue(fusrowid);

        adm = Ext.getCmp('PAADM').getValue();
        var frm = parent.parent.parent.document.forms['fEPRMENU'];
        var frmEpisodeID = frm.EpisodeID;
        frmEpisodeID.value = adm;
        var frmPatientID = frm.PatientID;
        frmPatientID.value = "";
        PAPMIID = Ext.getCmp('papmiid').getValue();
        RecordID = cspRunServerMethod(getRecordID, FUPRowId);;
        CreateMainPanel();
        if (dynamicpanel.getComponent('panel') != null) {
            dynamicpanel.remove(dynamicpanel.getComponent('panel'));
        };

        dynamicpanel.add(panel);
        dynamicpanel.doLayout();

            /*
             * var record = grid.getStore().getAt(rowIndex);
             * form.getForm().loadRecord(record); qrrowid = '';
             * Ext.getCmp('deadflag').setValue(false);
             * Ext.getCmp("fusbcombo").clearValue(); dynamicpanel.removeAll();
             */
            // fusbstore.removeAll();
            /*
             * fusbstore.reload(); //var fusrowid =
             * Ext.getCmp("fusbcombo").getValue().split("^")[1]; PlanID =
             * fusrowid; FUPRowId = Ext.getCmp('PAADM').getValue();
             * 
             * adm = Ext.getCmp('PAADM').getValue(); RecordID = '';
             * CreateMainPanel(); if (dynamicpanel.getComponent('panel') !=
             * null) { dynamicpanel.remove(dynamicpanel.getComponent('panel')); };
             * 
             * dynamicpanel.add(panel); dynamicpanel.doLayout();
             */
        });
    /*
     * grid.on('rowdblclick', function(grid, rowIndex, event){
     * 
     * var record = grid.getStore().getAt(rowIndex);
     * Ext.MessageBox.alert("出院小结"); });
     */

    store.load({
                params : {
                    start : 0,
                    limit : bbar.pageSize
                }
            });
})
