Ext.onReady(function() {
    
    Ext.QuickTips.init();
    var HiddenFlag = false
    if (EpisodeID != "")
        HiddenFlag = true

    var sm = new Ext.grid.CheckboxSelectionModel({
                handleMouseDown : Ext.emptyFn
            });
    var mrbasecm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), sm, {
                header : "类型",
                dataIndex : 'mtype'
            }, {
                header : "住院号",
                dataIndex : 'mrmrid'
            }, {
                header : "登记号",
                dataIndex : 'mRegno',
                sortable : true
            }, {
                header : "姓名",
                dataIndex : 'mrname'
            }, {
                header : "性别",
                dataIndex : 'mrgender',
                sortable : true
            }, {
                header : "年龄",
                dataIndex : 'mrage',
                sortable : true
            }, {
                header : "身份证号",
                dataIndex : 'mrcardid',
                width : 150
            }, {
                header : "入院日期",
                dataIndex : 'mradmdate',
                sortable : true
            }, {
                header : "出院日期",
                dataIndex : 'mrdisdate',
                sortable : true
            }, {
                header : "出院科室",
                dataIndex : 'LocDesc',
                width : 100,
                sortable : true
            }, {
                header : "出院病房",
                dataIndex : 'mrdisroom',
                width : 200,
                sortable : true
            }, {
                header : "出院诊断",
                dataIndex : 'mrdisdiagname',
                width : 300,
                sortable : true
            }, {
                header : "联系电话",
                dataIndex : 'mrtel',
                width : 200
            }, {
                header : "联系地址",
                dataIndex : 'mraddress'
            }, {
                header : "主治医师",
                dataIndex : 'docname'
            }, {
                header : "PAADM",
                dataIndex : 'mradm'
            }]);

    var fupcm = new Ext.grid.ColumnModel([

    {
                header : "登记号",
                dataIndex : 'PAPMINO'
            }, {
                header : "姓名",
                dataIndex : 'PAPMIName'
            }, {
                header : "PAADM",
                dataIndex : 'FUPPAADM',
                hidden : true
            }, {
                header : "调查主题",
                dataIndex : 'FUPSubject',
                width : 200
            }, {
                header : "开始日期",
                dataIndex : 'FUPFUDate',
                width : 150
            }, {
                header : "结束日期",
                dataIndex : 'EndDate',
                width : 150
            }, {
                header : "调查人",
                dataIndex : 'FUPFUUser'
            }]);

    var mrbasestore = new Ext.data.Store({
                url : 'dhccrmsetplan1.csp?action=mrbaselist&PAADM=' + EpisodeID,
                reader : new Ext.data.JsonReader({
                            totalProperty : "results",
                            root : "rows"
                        }, ['mrmrid', 'mRegno', 'mrname', 'mrgender', 'mrage',
                                'mrcardid', 'mradmdate', 'mrdisdate',
                                'mrdisroom', 'mrdisdiagname', 'mradm', 'mtype',
                                'mrtel', 'mraddress', 'docname', 'LocDesc'])
            });

    var fupstore = new Ext.data.Store({
                url : 'dhccrmsetplan1.csp?action=fuplist',
                reader : new Ext.data.JsonReader({
                            totalProperty : "results",
                            root : "rows"
                        }, ['PAPMINO', 'PAPMIName', 'FUPPAADM', 'FUPSubject',
                                'FUPFUDate', 'FUPFUUser', 'EndDate'])
            });

    // 主题
    var fusbstore = new Ext.data.Store({
                url : 'dhccrmfurecord1.csp?action=fusblist',
                reader : new Ext.data.JsonReader({
                            totalProperty : "results",
                            root : "rows"
                        }, ['FUSRowId', 'FUSCode', 'FUSDesc', 'FUPSRowId'])
            });
    // 随访人
    var fuPersonstore = new Ext.data.Store({
                url : 'dhccrmsetplan1.csp?action=fupersonlist',
                reader : new Ext.data.JsonReader({
                            totalProperty : "results",
                            root : "rows"
                        }, ['RowID', 'Name'])
            })

    fuPersonstore.on('beforeload', function() {
        var UserDesc = Ext.getCmp('fupersoncombo').getRawValue();
        if (UserDesc == "")
            return;
        fuPersonstore.proxy.conn.url = 'dhccrmsetplan1.csp?action=fupersonlist&UserDesc='
                + UserDesc;

    });

    var fuICDstore = new Ext.data.Store({
                url : 'dhccrmsetplan1.csp?action=fuqtICDlist',
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

    var sexstore = new Ext.data.Store({
                url : 'dhccrmsetplan1.csp?action=loclist',
                reader : new Ext.data.JsonReader({
                            totalProperty : 'results',
                            root : 'rows'
                        }, ['RowID', 'Name'])
            })

    var subjectrecord = Ext.data.Record.create([{
                name : 'FUSRowId'
            }, {
                name : 'FUSDesc'
            }]);

    var subjectcm = new Ext.grid.ColumnModel([{
                header : "主题ID",
                dataIndex : 'FUSRowId'
            }, {
                header : "主题名称",
                dataIndex : 'FUSDesc'
            }]);

    var subjectstore = new Ext.data.Store({
                proxy : new Ext.data.MemoryProxy(),
                reader : new Ext.data.ArrayReader({}, subjectrecord)
            });
    var ColumnNum = new Ext.form.NumberField({
                fieldLabel : '显示行数',
                width : 40,
                id : 'ColumnNum',
                value:25
            })

    var bbar = new Ext.PagingToolbar({
                pageSize : Ext.getCmp('ColumnNum').getValue(),
                store : mrbasestore,
                displayInfo : true,
                displayMsg : '显示第 {0}条到 {1}条记录，一共 {2}条',
                emptyMsg : "没有记录"
            });

    var fupbbar = new Ext.PagingToolbar({
                pageSize : 25,
                store : fupstore
            });

    mrbasestore.load({
                params : {
                    start : 0,
                    limit : Ext.getCmp('ColumnNum').getValue()
                }
            });

    mrbasestore.on('load', function() {

                Ext.getCmp('mzinfo').setText('当前数据量'
                        + mrbasestore.getTotalCount() + '行')

            });
    mrbasestore.on('beforeload', function() {

                var BDate = BeginDate.getValue();
                var EDate = EndDate.getValue();
                if (BDate != '') {
                    BDate = BDate.format('Y-m-d').toString();
                }
                if (EDate != '') {
                    EDate = EDate.format('Y-m-d').toString();
                }

                var LocID = Loc.getValue();
                var ICD = Ext.getCmp('mrdisdiagname').getValue();

                var RegNo = Ext.getCmp('RegNo').getValue();
                var PatName = Ext.getCmp('PatName').getValue();

                var PatSexID = Ext.getCmp('PatSex').getValue();
                var PatAgeFrom = Ext.getCmp('PatAge').getValue();
                var PatAgeTo = Ext.getCmp('PatAge1').getValue();

                var PatientType = spradio.getValue().getRawValue();
                var FindCheck = Ext.getCmp('FindCheck').getValue();

                var YuanQuID = Ext.getCmp('YuanQu').getValue();
                var PatInDate = Ext.getCmp('PatInDate').getValue();
                var PatInDate1 = Ext.getCmp('PatInDate1').getValue();
                var PatLocNum = Ext.getCmp('PatLocNum').getValue();
                
                
                
                
                mrbasestore.proxy.conn.url = 'dhccrmsetplan1.csp?action=mrbaselist'
                        + "&BeginDate="
                        + BDate
                        + "&EndDate="
                        + EDate
                        + "&LocID="
                        + LocID
                        + "&ICD="
                        + encodeURIComponent(ICD)
                        + "&RegNo="
                        + RegNo
                        + "&PatName="
                        + encodeURIComponent(PatName)
                        + "&PatSexID="
                        + PatSexID
                        + "&PatAgeFrom="
                        + PatAgeFrom
                        + "&PatAgeTo="
                        + PatAgeTo
                        + "&PAADM="
                        + EpisodeID
                        + "&PatientType="
                        + PatientType
                        + "&FindCheck="
                        + FindCheck
                        + "&YuanQuID="
                        + YuanQuID
                        + "&PatInDate="
                        + PatInDate
                        + "^"
                        + PatInDate1
                        + "&PatLocNum=" + PatLocNum;

            });

    fupstore.load({
                params : {
                    start : 0,
                    limit : fupbbar.pageSize
                }
            });
    var RegNo = new Ext.form.TextField({
                fieldLabel : '登记/住院号',
                width : 150,
                allowBlank : true,
                id : 'RegNo'
            })
    var RegNoPanel = new Ext.Panel({
                layout : 'form',
                columnWidth : 1 / 4,
                items : RegNo,
                id : 'RegNoPanel',
                labelAlign : "right"

            })

    var PatName = new Ext.form.TextField({
                fieldLabel : '姓名',
                width : 150,
                id : 'PatName'
            })
    var PatNamePanel = new Ext.Panel({
                layout : 'form',
                columnWidth : 1 / 4,
                items : PatName,
                id : 'PatNamePanel',
                labelAlign : "right"
            })

    var PatSex = new Ext.form.ComboBox({
        enableKeyEvents : true,
        fieldLabel : '性别',
        width : 150,
        store : sexstore,
        valueField : 'RowID',
        displayField : 'Name',
        triggerAction : 'all',
        allowBlank : true,
        id : 'PatSex',
        mode : 'local',
        PageSize : 20,
        listeners : {
            focus : function() {
                SexDesc = Ext.getCmp('PatSex').getRawValue();
                this.store.on('beforeload', function() {
                    this.proxy.conn.url = 'dhccrmsetplan1.csp?action=Sexlist&SexDesc='
                            + SexDesc
                });
                this.store.reload();
            }
        }

    })

    var PatSexPanel = new Ext.Panel({
                layout : 'form',
                columnWidth : 1 / 4,
                id : 'PatSexPanel',
                items : PatSex,
                labelAlign : "right"
            })
    var yuanqustore = new Ext.data.Store({
                url : 'dhccrmsetplan1.csp?action=yuanqulist',
                reader : new Ext.data.JsonReader({
                            totalProperty : 'results',
                            root : 'rows'
                        }, ['RowID', 'Name'])
            })
    var YuanQu = new Ext.form.ComboBox({
                fieldLabel : '院区',
                width : 150,
                store : yuanqustore,
                valueField : 'RowID',
                displayField : 'Name',
                triggerAction : 'all',
                allowBlank : true,
                id : 'YuanQu',
                triggerAction : 'all'

            })

    var YuanQuPanel = new Ext.Panel({
                layout : 'form',
                columnWidth : 1 / 4,
                id : 'YuanQuPanel',
                items : YuanQu,
                labelAlign : "right"
            })

    var BeginDate = new Ext.form.DateField({
                fieldLabel : '开始日期',
                width : 150,
                id : 'BeginDate'
            })
    var BeginDatePanel = new Ext.Panel({
                layout : 'form',
                columnWidth : 1 / 4,
                items : BeginDate,
                id : 'BeginDatePanel',
                // width:120,
                labelAlign : "right"
            })
    var EndDate = new Ext.form.DateField({
                fieldLabel : '结束日期',
                width : 150,
                id : 'EndDate'
            })
    var EndDatePanel = new Ext.Panel({
                layout : 'form',
                columnWidth : 1 / 4,
                id : 'EndDatePanel',
                items : EndDate,
                // width:120,
                labelAlign : "right"
            })
    var PatAge = new Ext.form.NumberField({
                fieldLabel : '年龄',
                width : 40,
                id : 'PatAge'
            })
    var PatAge1 = new Ext.form.NumberField({
                fieldLabel : '-',
                width : 40,
                id : 'PatAge1'
            })
    var PatInDate = new Ext.form.NumberField({
                fieldLabel : '住院天数',
                width : 40,
                id : 'PatInDate'
            })
    var PatInDate1 = new Ext.form.NumberField({
                fieldLabel : '-',
                width : 40,
                id : 'PatInDate1'
            })
    var PatInDatePanel = new Ext.Panel({
                layout : 'form',
                columnWidth : 1 / 8,
                items : PatInDate,
                id : 'PatInDatePanel',
                labelAlign : "right"
            })
    var PatInDatePanel1 = new Ext.Panel({
                layout : 'form',
                columnWidth : 1 / 8,
                items : PatInDate1,
                id : 'PatInDatePanel1',
                labelAlign : "left",
                labelWidth : 20
            })
    var PatLocNum = new Ext.form.NumberField({
                fieldLabel : '每病房人数<=',
                width : 40,
                id : 'PatLocNum'
            })
    var PatLocNumPanel = new Ext.Panel({
                layout : 'form',
                columnWidth : 1 / 8,
                items : PatLocNum,
                id : 'PatLocNumPanel',
                labelAlign : "right"
            })

    var ColumnNumPanel = new Ext.Panel({
                layout : 'form',
                columnWidth : 1 / 8,
                items : ColumnNum,
                id : 'ColumnNumPanel',
                labelAlign : "right"
            })
    var PatAgePanel = new Ext.Panel({
                layout : 'form',
                columnWidth : 1 / 8,
                items : PatAge,
                id : 'PatAgePanel',
                labelAlign : "right"
            })

    var PatAgePanel1 = new Ext.Panel({
                layout : 'form',
                columnWidth : 1 / 8,
                items : PatAge1,
                id : 'PatAgePanel1',
                labelAlign : "left",
                labelWidth : 20
            })

    var Loc = new Ext.form.ComboBox({
        enableKeyEvents : true,
        fieldLabel : '科室',
        width : 150,
        store : locstore,
        valueField : 'RowID',
        displayField : 'Name',
        triggerAction : 'all',
        id : 'Loc',
        mode : 'local',
        PageSize : 20,
        minListWidth : 220,
        selectOnFocus : true,
        //forceSelection : true,
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

    var LocPanel = new Ext.Panel({
                layout : 'form',
                columnWidth : 1 / 4,
                id : 'LocPanel',
                // PageSize : 20,
                items : Loc,
                labelAlign : "right"
            })
    
            
    var mrdisdiagname = new Ext.form.ComboBox({
        enableKeyEvents : true,
        fieldLabel : '出院诊断',
        width : 150,
        store : fuICDstore,
        valueField : 'RowID',
        displayField : 'Name',
        triggerAction : 'all',
        id : 'mrdisdiagname',
        mode : 'local',
        PageSize : 20,
        minListWidth : 220,
        selectOnFocus : true,
        listeners : {
            'specialkey' : function(obj, e) {
                if (e.getKey() == e.ENTER) {
                    var ICDDesc = obj.getRawValue();
                    
                    obj.store.proxy.conn.url = 'dhccrmsetplan1.csp?action=fuICDlist&ICDDesc='
                            + ICDDesc;
                    obj.store.load({});
                }

            }
        }
    })
    
    var mrdisdiagnamebak = new Ext.form.ComboBox({
                enableKeyEvents : true,
                fieldLabel : '躯体疾病',
                width : 150,
                store : fuICDstore,
                valueField : 'RowID',
                displayField : 'Name',
                triggerAction : 'all',
                id : 'mrdisdiagnamebak',
                mode : 'mode',
                PageSize : 20,
                minListWidth : 220,
                selectOnFocus : true
            })

    var mrdisdiagPanel = new Ext.Panel({
                layout : 'form',
                columnWidth : 1 / 4,
                id : 'mrdisdiagPanel',
                items : mrdisdiagname,
                labelAlign : "right"
            })

    var FindButton = new Ext.Button({
                text : '查询',
                iconCls : 'find',
                handler : Find_click
            })

    var FindCheck = new Ext.form.Checkbox({
        boxLabel : '已定计划',
        id : 'FindCheck'
            // width : 100

        })
    function Find_click() {
        
        mrbasestore.load({
                    params : {
                        start : 0,
                        limit : Ext.getCmp('ColumnNum').getValue()
                    }
                })
        bbar.pageSize=Ext.getCmp('ColumnNum').getValue()
        
    }
    var FindButtonPanel = new Ext.Panel({
                layout : 'form',
                width : 100,
                id : 'FindButtonPanel',
                items : FindButton
            })
    var FindCheckPanel = new Ext.Panel({
                layout : 'form',
                columnWidth : 1 / 4,
                id : 'FindCheckPanel',
                items : FindCheck
            })
    var DatePanel = new Ext.Panel({
                layout : 'column',
                defaults : {
                    anchor : '90%'
                },
                height : 90,
                items : [RegNoPanel, PatNamePanel, PatSexPanel, YuanQuPanel,
                        BeginDatePanel, EndDatePanel, LocPanel, mrdisdiagPanel,
                        PatAgePanel, PatAgePanel1, PatInDatePanel,
                        PatInDatePanel1, ColumnNumPanel, PatLocNumPanel,
                        FindCheckPanel]
            })
    var queryinfo = new Ext.form.FormPanel({
                region : 'north',
                frame : true,
                height : 220,
                layout : 'form',
                autoHeight : true,
                hidden : HiddenFlag,
                items : [DatePanel]

            });

    var grid = new Ext.grid.GridPanel({
                region : 'center',
                collapsible : true,
                viewConfig : {
                    forceFit : true
                },
                store : mrbasestore,
                cm : mrbasecm,
                sm : sm,
                stripeRows : true,
                bbar : bbar
            });
    grid.on('rowclick', function(grid, rowIndex, event) {

                var selectedRow = mrbasestore.getAt(rowIndex);
                adm = selectedRow.get('mradm');

                var frm = parent.parent.parent.document.forms['fEPRMENU'];
                var frmEpisodeID = frm.EpisodeID;
                frmEpisodeID.value = adm;

            })
    var fupgrid = new Ext.grid.GridPanel({
                store : fupstore,
                frame : true,
                height : 155,
                cm : fupcm,
                // autoHeight : true,
                viewConfig : {
                    forceFit : true
                },
                bbar : fupbbar
            });
    var planbutton = new Ext.Button({
                text : '导出此时间段计划',
                hidden:true,
                handler : Export_click
            })
    var planbuttonI = new Ext.Button({
                text : '导入调查结果',
                hidden:true,
                handler : Import_click
            })
    var planform = new Ext.form.FormPanel({
        region : 'center',
        title : '生成计划',
        labelAlign : 'right',
        items : [{
            xtype : 'panel',
            layout : 'column',
            items : [{
                        xtype : 'panel',
                        layout : 'form',
                        columnWidth : 1 / 4,
                        items : [{
                                    xtype : 'combo',
                                    fieldLabel : 'his调查人',
                                    // allowBlank : false,
                                    id : 'fupersoncombo',
                                    name : 'fupersoncombo',
                                    store : fuPersonstore,
                                    valueField : 'RowID',
                                    displayField : 'Name',
                                    triggerAction : 'all',
                                    emptyText : '点击选择',
                                    width : 120
                                }]

                    }, {
                        xtype : 'panel',
                        layout : 'form',
                        columnWidth : 1 / 4,
                        items : [{

                                    xtype : 'textfield',
                                    fieldLabel : '调查人',
                                    id : 'fuperson',
                                    name : 'fuperson',
                                    emptyText : '调查人'
                                }]

                    }, {
                        xtype : 'panel',
                        layout : 'form',
                        columnWidth : 1 / 4,
                        items : [{

                                    xtype : 'datefield',
                                    allowBlank : false,
                                    fieldLabel : '调查日期',
                                    id : 'fusbDate',
                                    name : 'fusbDate',
                                    emptyText : '调查日期'
                                }]

                    }, {
                        xtype : 'panel',
                        layout : 'form',
                        columnWidth : 1 / 4,
                        items : [{

                                    xtype : 'datefield',
                                    // allowBlank : false,
                                    fieldLabel : '结束日期',
                                    id : 'fusbEndDate',
                                    name : 'fusbEndDate',
                                    emptyText : '结束日期'
                                }]

                    }, {
                        xtype : 'panel',
                        layout : 'form',
                        columnWidth : 3 / 10,
                        items : [{
                                    xtype : 'combo',
                                    fieldLabel : '调查主题',
                                    id : 'fusbcombo',
                                    name : 'fusbcombo',
                                    store : fusbstore,
                                    valueField : 'FUSRowId',
                                    displayField : 'FUSDesc',
                                    triggerAction : 'all',
                                    emptyText : '点击选择主题',
                                    width : 180

                                }]

                    }, {
                        xtype : 'panel',
                        layout : 'form',
                        columnWidth : 1 / 5,
                        items : [{

                                    xtype : 'numberfield',
                                    fieldLabel : '随访周期',
                                    id : 'fudays',
                                    name : 'fudays',
                                    emptyText : '天数',
                                    width : 40
                                }]

                    }, {
                        xtype : 'panel',
                        layout : 'form',
                        columnWidth : 1 / 5,
                        items : [{

                                    xtype : 'numberfield',
                                    fieldLabel : '随访次数',
                                    id : 'funums',
                                    name : 'funums',
                                    emptyText : '次数',
                                    width : 40
                                }]

                    } ,{
                        xtype : 'panel',
                        layout : 'form',
                        columnWidth : 1 / 10,
                        items : [{
                            xtype : 'button',
                            text : '生成计划',
                            iconCls : 'update',
                            id : 'CreatePlanButton',
                            name : 'CreatePlanButton',
                            handler : function() {
                                var selectedRows = grid.getSelectionModel()
                                        .getSelections();
                                if (selectedRows.length == 0) {
                                    Ext.Msg.alert("提示", "请选择病人记录!");
                                    return;
                                }
                                var PAADMStr = "";
                                for (i = 0; i < selectedRows.length; i++) {

                                    var PAADMRowID = selectedRows[i].data.mradm
                                    var admstr = tkMakeServerCall(
                                        'web.DHCCRM.SetPlan', "IsRepeatByADM",
                                        PAADMRowID)
                                    
                                    var setstr=1;
                                    if (admstr == 1) {
                                    
                                    if(!confirm(selectedRows[i].data.mrname+'一年内已有随访计划,是否继续?'))
                                        setstr = tkMakeServerCall('web.DHCCRM.SetPlan', "SetRepeatByADM",PAADMRowID)
                                        
                                    }
                                    if(setstr==0) continue;
                                    if (PAADMStr == "")
                                        PAADMStr = PAADMRowID
                                    else {
                                        PAADMStr = PAADMStr + "^" + PAADMRowID
                                    }

                                }

                                var WardStr = "";
                                for (i = 0; i < selectedRows.length; i++) {

                                    var ward = selectedRows[i].data.mrdisroom

                                    if (WardStr == "")
                                        WardStr = ward
                                    else {
                                        WardStr = WardStr + "^" + ward
                                    }

                                }

                                var str = tkMakeServerCall(
                                        'web.DHCCRM.SetPlan', "IsRepeat",
                                        WardStr)
                                if (str == 1) {
                                    Ext.Msg.confirm('系统提示', '完成一次病房循环,是否继续?',
                                            function(btn) {
                                                if (btn == 'yes') {

                                                    var count = subjectstore
                                                            .getCount();

                                                    var FUSRowIdStr = ""
                                                    for (var j = 0; j < count; j++) {
                                                        var record = subjectstore
                                                                .getAt(j);
                                                        var FUSRowId = record.data.FUSRowId;
                                                        if (FUSRowIdStr == "")
                                                            FUSRowIdStr = FUSRowId
                                                        else {
                                                            FUSRowIdStr = FUSRowIdStr
                                                                    + "^"
                                                                    + FUSRowId
                                                        }
                                                    }

                                                    if (FUSRowIdStr == "") {
                                                        Ext.Msg.alert("提示",
                                                                "请选择调查主题!");
                                                        return;
                                                    }
                                                    var Date = Ext
                                                            .getCmp('fusbDate')
                                                            .getValue()
                                                    var EndDate = Ext
                                                            .getCmp('fusbEndDate')
                                                            .getValue()
                                                    var User = Ext
                                                            .getCmp('fupersoncombo')
                                                            .getValue()
                                                    var PTUser = Ext
                                                            .getCmp('fuperson')
                                                            .getValue()
                                                    if (Date == "") {
                                                        Ext.Msg.alert("提示",
                                                                "日期必填!");
                                                        return;
                                                    }
                                                    Date = Date.format('Y-m-d')
                                                            .toString();
                                                    EndDate = Date; // EndDate.format('Y-m-d').toString();
                                                    var PatientType = spradio
                                                            .getValue()
                                                            .getRawValue();
                                                    var Seturl = 'dhccrmsetplan1.csp?action=AddPlan'
                                                            + '&PAADMStr='
                                                            + PAADMStr
                                                            + '&FUSRowIdStr='
                                                            + FUSRowIdStr
                                                            + '&FUSUser='
                                                            + User
                                                            + '&FUSDate='
                                                            + Date
                                                            + '&PatientType='
                                                            + PatientType
                                                            + '&FUSEndDate='
                                                            + EndDate
                                                            + '&PTUser='
                                                            + PTUser;

                                                    if (planform.getForm()
                                                            .isValid()) {
                                                        Ext.Ajax.request({
                                                            url : Seturl,
                                                            waitMsg : '保存中...',
                                                            failure : function(
                                                                    result,
                                                                    request) {
                                                                Ext.Msg.show({
                                                                    title : '错误',
                                                                    msg : '请检查网络连接!',
                                                                    buttons : Ext.Msg.OK,
                                                                    icon : Ext.MessageBox.ERROR
                                                                });
                                                            },
                                                            success : function(
                                                                    result,
                                                                    request) {
                                                                var jsonData = Ext.util.JSON
                                                                        .decode(result.responseText);
                                                                if (jsonData.success == 'true') {
                                                                    Ext.Msg
                                                                            .show(
                                                                                    {
                                                                                        title : '提示',
                                                                                        msg : '数据保存成功!',
                                                                                        buttons : Ext.Msg.OK,
                                                                                        icon : Ext.MessageBox.INFO
                                                                                    });

                                                                    fupstore
                                                                            .load(
                                                                                    {
                                                                                        params : {
                                                                                            start : 0,
                                                                                            limit : fupbbar.pageSize
                                                                                        }
                                                                                    });
                                                                    mrbasestore
                                                                            .load(
                                                                                    {
                                                                                        params : {
                                                                                            start : 0,
                                                                                            limit : Ext
                                                                                                    .getCmp('ColumnNum')
                                                                                                    .getValue()
                                                                                        }
                                                                                    });
                                                                } else {
                                                                    Ext.MessageBox
                                                                            .show(
                                                                                    {
                                                                                        title : '错误',
                                                                                        msg : jsonData.info,
                                                                                        buttons : Ext.MessageBox.OK,
                                                                                        icon : Ext.MessageBox.ERROR
                                                                                    });
                                                                }
                                                            }
                                                        });
                                                    } else {
                                                        Ext.Msg.show({
                                                            title : '错误',
                                                            msg : '请修正页面提示的错误后提交',
                                                            buttons : Ext.Msg.OK,
                                                            icon : Ext.MessageBox.ERROR
                                                        });

                                                    }

                                                } else {
                                                    return;
                                                }
                                            }

                                    );

                                } else {
                                    var count = subjectstore.getCount();

                                    var FUSRowIdStr = ""
                                    for (var j = 0; j < count; j++) {
                                        var record = subjectstore.getAt(j);
                                        var FUSRowId = record.data.FUSRowId;
                                        if (FUSRowIdStr == "")
                                            FUSRowIdStr = FUSRowId
                                        else {
                                            FUSRowIdStr = FUSRowIdStr + "^"
                                                    + FUSRowId
                                        }
                                    }

                                    if (FUSRowIdStr == "") {
                                        Ext.Msg.alert("提示", "请选择调查主题!");
                                        return;
                                    }
                                    var Date = Ext.getCmp('fusbDate')
                                            .getValue()
                                    var EndDate = Ext.getCmp('fusbEndDate')
                                            .getValue()
                                    var User = Ext.getCmp('fupersoncombo')
                                            .getValue()
                                    var PTUser = Ext.getCmp('fuperson')
                                            .getValue()
                                    var fudays = Ext.getCmp('fudays')
                                            .getValue()
                                    var funums = Ext.getCmp('funums')
                                            .getValue()
                                    if (Date == "") {
                                        Ext.Msg.alert("提示", "日期必填!");
                                        return;
                                    }
                                    
                                    if(EndDate=="") EndDate=Date;
                                    
                                    var oDate1 = Date.format('Y-m-d').toString();
                                    
                                    var oDate2 = EndDate.format('Y-m-d').toString();
                                    var d1=oDate1.replace(/\-/gi,"/");
                                    var d2=oDate2.replace(/\-/gi,"/");
                                    if(d1 > d2){
                                            alert("开始日期不能晚于结束日期");
                                            return
                                    }
                                    
                                    Date = Date.format('Y-m-d').toString();
                                    EndDate = Date; // EndDate.format('Y-m-d').toString();
                                    var PatientType = spradio.getValue()
                                            .getRawValue();
                                    var Seturl = 'dhccrmsetplan1.csp?action=AddPlan'
                                            + '&PAADMStr='
                                            + PAADMStr
                                            + '&FUSRowIdStr='
                                            + FUSRowIdStr
                                            + '&FUSUser='
                                            + User
                                            + '&FUSDate='
                                            + Date
                                            + '&PatientType='
                                            + PatientType
                                            + '&FUSEndDate='
                                            + EndDate + '&PTUser=' + PTUser+ '&fudays=' + fudays+ '&funums=' + funums;
                                    
                                    if (planform.getForm().isValid()) {
                                        Ext.Ajax.request({
                                            url : Seturl,
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

                                                    fupstore.load({
                                                        params : {
                                                            start : 0,
                                                            limit : fupbbar.pageSize
                                                        }
                                                    });
                                                    mrbasestore.load({
                                                        params : {
                                                            start : 0,
                                                            limit : Ext
                                                                    .getCmp('ColumnNum')
                                                                    .getValue()
                                                        }
                                                    });
                                                } else {
                                                    Ext.MessageBox.show({
                                                        title : '错误',
                                                        msg : jsonData.info,
                                                        buttons : Ext.MessageBox.OK,
                                                        icon : Ext.MessageBox.ERROR
                                                    });
                                                }
                                            }
                                        });
                                    } else {
                                        Ext.Msg.show({
                                                    title : '错误',
                                                    msg : '请修正页面提示的错误后提交',
                                                    buttons : Ext.Msg.OK,
                                                    icon : Ext.MessageBox.ERROR
                                                });

                                    }
                                }

                            }
                        }]

                    }, {
                        xtype : 'panel',
                        layout : 'form',
                        columnWidth : 1 / 10,
                        items : planbutton

                    }, {
                        xtype : 'panel',
                        layout : 'form',
                        columnWidth : 1 / 10,
                        items : planbuttonI

                    }]

        }, new Ext.grid.GridPanel({
                    id : 'subjectgrid',
                    store : subjectstore,
                    cm : subjectcm,
                    frame : true,
                    collapsible : true,
                    viewConfig : {
                        forceFit : true
                    },
                    autoHeight : true,
                    autoScroll : true
                })]
    });

    Ext.getCmp('subjectgrid').on('rowdblclick', function(g, row, e) {
                subjectstore.remove(subjectstore.getAt(row));
            });

    Ext.getCmp('fusbcombo').on('select', function() {
                var fusrowid = this.getValue();
                var fusdesc = this.getRawValue();
                subjectstore.add(new subjectrecord({
                            FUSRowId : fusrowid,
                            FUSDesc : fusdesc
                        }));
            });

    subjectstore.load({
                add : true
            });
    function Export_click() {

        //alert(1)
        var Date = Ext.getCmp('fusbDate').getValue()
        //alert(Date)
        var EndDate = Ext.getCmp('fusbEndDate').getValue()
        //alert(EndDate)
        
        if (Date == '') {
            alert('请先选择日期!');
            return

        }
        Date = Date.format('Y-m-d').toString();
        
        EndDate = EndDate.format('Y-m-d').toString();
        
        if (EndDate == "")
        {
            EndDate = Date;
        }
        
        
        var ret = tkMakeServerCall("web.DHCCRM.SetPlan", "ExportPlan", Date,
                EndDate);
        var obj;
        var prnpath = tkMakeServerCall("web.DHCPE.Report.MonthStatistic",
                "getpath")

        var Templatefilepath = prnpath + 'DHCCRMExportCommon.xlsx';

        var ExportName = "DHCCRMPlan"

        var ret = tkMakeServerCall("web.DHCCRM.SetPlan", "GetUserName");

        var UserStr = ret.split("^")
        if (UserStr == '') {
            alert('无数据!');
            return

        }
        for (var m = 0; m < UserStr.length; m++) {
            var UserName = UserStr[m]
            xlApp = new ActiveXObject("Excel.Application"); // 固定
            xlBook = xlApp.Workbooks.Add(Templatefilepath); // 固定
            xlsheet = xlBook.WorkSheets("Sheet1"); // Excel下标的名称
            var Info = tkMakeServerCall("web.DHCCRM.SetPlan",
                    "GetOneExportInfo", "", ExportName, UserName);

            var Row = 2;

            while (Info != "") {
                var DataArr = Info.split("^");
                var DataLength = DataArr.length;
                for (i = 1; i < DataLength; i++) {
                    xlsheet.cells(Row, i).value = DataArr[i];
                    if ((i == 2) && (Row != 2))
                        xlsheet.cells(Row, i).value = Row - 2;
                }
                var Sort = DataArr[0];
                if (Sort == "")
                    break;
                Row = Row + 1;
                Info = tkMakeServerCall("web.DHCCRM.SetPlan",
                        "GetOneExportInfo", Sort, ExportName, UserName);
            }

            var Detail = tkMakeServerCall("web.DHCCRM.SetPlan",
                    "GetOneExportInfo", "", "DHCCRMDetail", UserName);
            var DataArr = Detail.split("^");
            var DataLength = DataArr.length;
            for (i = 1; i < DataLength; i++) {
                xlsheet.cells(1, i).value = DataArr[i];
            }

            xlsheet.SaveAs("d:\\" + UserName + '(' + Date + '-' + EndDate + ')'
                    + ".xlsx");

            xlApp.Quit();
            xlApp = null;

        }

        alert("导出完成!")
    }
    function StringIsNull(String) {
        if (String == null)
            return ""
        return String
    }

    function Import_click() {
        var kill = tkMakeServerCall("web.DHCCRM.SetPlan", "KillDataGlobal");
        try {
            var Template = "";
            var obj = document.getElementById("File")
            if (obj) {
                obj.click();
                Template = obj.value;
                obj.outerHTML = obj.outerHTML; // 清空选择文件名称
            }
            if (Template == "")
                return false;
            var extend = Template.substring(Template.lastIndexOf(".") + 1);
            if (!(extend == "xls" || extend == "xlsx")) {
                alert("请选择xls文件")
                return false;
            }

            xlApp = new ActiveXObject("Excel.Application"); // 固定
            xlBook = xlApp.Workbooks.Add(Template); // 固定
            xlsheet = xlBook.WorkSheets("Sheet1"); // Excel下标的名称

            i = 1

            while (Flag = 1) {
                IInString = ""

                for (j = 1; j <= 31; j++) {
                    StrValue = StringIsNull(xlsheet.cells(i, j).Value);
                    if (IInString == "")
                        IInString = StrValue;
                    else
                        IInString = IInString + "^" + StrValue;
                }

                StrValue = StringIsNull(xlsheet.cells(i, 2).Value);
                if (StrValue == "")
                    break;

                var ReturnValue = tkMakeServerCall("web.DHCCRM.SetPlan",
                        "CreateDataGol", IInString, i);
                i = i + 1
            }

            xlApp.Quit();
            xlApp = null;
            xlsheet = null;

            var Return = tkMakeServerCall("web.DHCCRM.SetPlan",
                    "ImportDataByGol")
            if (Return == 0) {
                alert("导入成功!")
            }
            else {
            alert("导入失败"+"请检查导入文件")
            
            
            }
        } catch (e) {
            alert("导入失败，请检查导入文件");
            return;
            alert(e + "^" + e.message);
        }

    }

    var plangrid = new Ext.Panel({
                region : 'east',
                width : 400,
                frame : true,
                collapsible : true,
                collapsed : true,
                title : '计划列表',
                items : fupgrid
            });
    var planpanel = new Ext.Panel({
                region : 'south',

                layout : 'border',
                height : 180,
                items : [planform, plangrid]

            })

    var spradio = new Ext.form.RadioGroup({
                hideLabel : true,
                width : 600,
                height : 30,
                items : [{
                            boxLabel : '门诊',
                            inputValue : 'OPatient',
                            name : 'PatientType'
                        }, {
                            boxLabel : '在院',
                            inputValue : 'IPatient',
                            name : 'PatientType'
                        }, {
                            boxLabel : '出院',
                            inputValue : 'CPatient',
                            name : 'PatientType',
                            checked : true
                        }, {
                            boxLabel : '急诊留观',
                            inputValue : 'EIPatient',
                            name : 'PatientType'
                        }, {
                            boxLabel : '急诊非留观',
                            inputValue : 'EOPatient',
                            name : 'PatientType'
                        },{
                            boxLabel : '体检',
                            inputValue : 'HPatient',
                            hidden : true,
                            name : 'PatientType'
                        }
                        , {
                            boxLabel : '职工',
                            inputValue : 'BYUser',
                            hidden : true,
                            name : 'PatientType'
                        }

                ]
            });

    spradio.on('change', function(radiogroup, radio) {

                if (radio.getRawValue() == 'CPatient') {

                    mrbasecm.setConfig([new Ext.grid.RowNumberer(), sm, {
                                header : "类型",
                                dataIndex : 'mtype'
                            }, {
                                header : "住院号",
                                dataIndex : 'mrmrid'
                            }, {
                                header : "登记号",
                                dataIndex : 'mRegno'
                            }, {
                                header : "姓名",
                                dataIndex : 'mrname'
                            }, {
                                header : "性别",
                                dataIndex : 'mrgender'
                            }, {
                                header : "年龄",
                                dataIndex : 'mrage'
                            }, {
                                header : "身份证号",
                                dataIndex : 'mrcardid',
                                width : 150
                            }, {
                                header : "入院日期",
                                dataIndex : 'mradmdate'
                            }, {
                                header : "出院日期",
                                dataIndex : 'mrdisdate',
                                sortable : true
                            }, {
                                header : "出院科室",
                                dataIndex : 'LocDesc',
                                width : 100,
                                sortable : true
                            }, {
                                header : "出院病房",
                                dataIndex : 'mrdisroom',
                                width : 200,
                                sortable : true
                            }, {
                                header : "出院情况",
                                dataIndex : 'mrdisdiagname',
                                width : 300
                            }, {
                                header : "联系电话",
                                dataIndex : 'mrtel',
                                width : 100
                            }, {
                                header : "联系地址",
                                dataIndex : 'mraddress'
                            }, {
                                header : "主治医师",
                                dataIndex : 'docname'
                            }, {
                                header : "PAADM",
                                dataIndex : 'mradm'
                            }]

                    )

                }
                if (radio.getRawValue() == 'EIPatient') {

                    mrbasecm.setConfig([new Ext.grid.RowNumberer(), sm, {
                                header : "类型",
                                dataIndex : 'mtype'
                            }, {
                                header : "住院号",
                                dataIndex : 'mrmrid'
                            }, {
                                header : "登记号",
                                dataIndex : 'mRegno'
                            }, {
                                header : "姓名",
                                dataIndex : 'mrname'
                            }, {
                                header : "性别",
                                dataIndex : 'mrgender'
                            }, {
                                header : "年龄",
                                dataIndex : 'mrage'
                            }, {
                                header : "身份证号",
                                dataIndex : 'mrcardid',
                                width : 150
                            }, {
                                header : "入院日期",
                                dataIndex : 'mradmdate'
                            }, {
                                header : "入院科室",
                                dataIndex : 'mrdisdate',
                                sortable : true
                            }, {
                                header : "出院科室",
                                dataIndex : 'mrdisroom',
                                width : 200,
                                sortable : true
                            }, {
                                header : "床位",
                                dataIndex : 'mrdisdiagname',
                                width : 300
                            }, {
                                header : "联系电话",
                                dataIndex : 'mrtel'
                            }, {
                                header : "联系地址",
                                dataIndex : 'mraddress'
                            }, {
                                header : "主治医师",
                                dataIndex : 'docname'
                            }, {
                                header : "PAADM",
                                dataIndex : 'mradm'
                            }]

                    )

                }
                if (radio.getRawValue() == 'IPatient') {
                    mrbasecm.setConfig([new Ext.grid.RowNumberer(), sm, {
                                        header : "类型",
                                        dataIndex : 'mtype'
                                    }, {
                                        header : "住院号",
                                        dataIndex : 'mrmrid'
                                    }, {
                                        header : "登记号",
                                        dataIndex : 'mRegno'
                                    }, {
                                        header : "姓名",
                                        dataIndex : 'mrname'
                                    }, {
                                        header : "性别",
                                        dataIndex : 'mrgender'
                                    }, {
                                        header : "年龄",
                                        dataIndex : 'mrage'
                                    }, {
                                        header : "身份证号",
                                        dataIndex : 'mrcardid',
                                        width : 150
                                    }, {
                                        header : "入院日期",
                                        dataIndex : 'mradmdate',
                                        sortable : true
                                    }, {
                                        header : "病区",
                                        dataIndex : 'mrdisdate',
                                        width : 200,
                                        sortable : true
                                    }, {
                                        header : "科别",
                                        dataIndex : 'mrdisroom',
                                        width : 200,
                                        sortable : true
                                    }, {
                                        header : "床位",
                                        dataIndex : 'mrdisdiagname'
                                    }, {
                                        header : "联系电话",
                                        dataIndex : 'mrtel'
                                    }, {
                                        header : "联系地址",
                                        dataIndex : 'mraddress'
                                    }, {
                                        header : "主治医师",
                                        dataIndex : 'docname'
                                    }, {
                                        header : "PAADM",
                                        dataIndex : 'mradm'
                                    }], false)
                }

                if (radio.getRawValue() == 'OPatient') {
                    mrbasecm.setConfig([new Ext.grid.RowNumberer(), sm, {
                                        header : "类型",
                                        dataIndex : 'mtype'
                                    }, {
                                        header : "就诊类型",
                                        dataIndex : 'mrmrid'
                                    }, {
                                        header : "登记号",
                                        dataIndex : 'mRegno'
                                    }, {
                                        header : "姓名",
                                        dataIndex : 'mrname'
                                    }, {
                                        header : "性别",
                                        dataIndex : 'mrgender'
                                    }, {
                                        header : "年龄",
                                        dataIndex : 'mrage'
                                    }, {
                                        header : "身份证号",
                                        dataIndex : 'mrcardid',
                                        width : 150
                                    }, {
                                        header : "就诊日期",
                                        dataIndex : 'mradmdate',
                                        sortable : true
                                    }, {
                                        header : "医生",
                                        dataIndex : 'mrdisdate',
                                        width : 200
                                    }, {
                                        header : "科室",
                                        dataIndex : 'mrdisroom',
                                        sortable : true
                                    }, {
                                        header : "初步诊断",
                                        dataIndex : 'mrdisdiagname',
                                        sortable : true
                                    }, {
                                        header : "电话",
                                        dataIndex : 'mrtel',
                                        sortable : true
                                    }, {
                                        header : "PAADM",
                                        dataIndex : 'mradm'
                                    }], false)
                }
                if (radio.getRawValue() == 'EOPatient') {
                    mrbasecm.setConfig([new Ext.grid.RowNumberer(), sm, {
                                        header : "类型",
                                        dataIndex : 'mtype'
                                    }, {
                                        header : "就诊类型",
                                        dataIndex : 'mrmrid'
                                    }, {
                                        header : "登记号",
                                        dataIndex : 'mRegno'
                                    }, {
                                        header : "姓名",
                                        dataIndex : 'mrname'
                                    }, {
                                        header : "性别",
                                        dataIndex : 'mrgender'
                                    }, {
                                        header : "年龄",
                                        dataIndex : 'mrage'
                                    }, {
                                        header : "身份证号",
                                        dataIndex : 'mrcardid',
                                        width : 150
                                    }, {
                                        header : "就诊日期",
                                        dataIndex : 'mradmdate',
                                        sortable : true
                                    }, {
                                        header : "医生",
                                        dataIndex : 'mrdisdate',
                                        width : 200
                                    }, {
                                        header : "科室",
                                        dataIndex : 'mrdisroom',
                                        sortable : true
                                    }, {
                                        header : "初步诊断",
                                        dataIndex : 'mrdisdiagname',
                                        sortable : true
                                    }, {
                                        header : "PAADM",
                                        dataIndex : 'mradm'
                                    }], false)
                }
                if (radio.getRawValue() == 'BYUser') {
                    mrbasecm.setConfig([new Ext.grid.RowNumberer(), sm, {
                                        header : "类型",
                                        dataIndex : 'mtype'
                                    }, {
                                        header : "住院号",
                                        dataIndex : 'mrmrid'
                                    }, {
                                        header : "登记号",
                                        dataIndex : 'mRegno'
                                    }, {
                                        header : "姓名",
                                        dataIndex : 'mrname'
                                    }, {
                                        header : "性别",
                                        dataIndex : 'mrgender'
                                    }, {
                                        header : "年龄",
                                        dataIndex : 'mrage'
                                    }, {
                                        header : "身份证号",
                                        dataIndex : 'mrcardid',
                                        width : 150
                                    }, {
                                        header : "入院日期",
                                        dataIndex : 'mradmdate',
                                        sortable : true
                                    }, {
                                        header : "病区",
                                        dataIndex : 'mrdisdate',
                                        width : 200,
                                        sortable : true
                                    }, {
                                        header : "科别",
                                        dataIndex : 'mrdisroom',
                                        width : 200,
                                        sortable : true
                                    }, {
                                        header : "床位",
                                        dataIndex : 'mrdisdiagname'
                                    }, {
                                        header : "PAADM",
                                        dataIndex : 'mradm'
                                    }], false)
                }
                if (radio.getRawValue() == 'HPatient') {
                    mrbasecm.setConfig([new Ext.grid.RowNumberer(), sm, {
                                        header : "类型",
                                        dataIndex : 'mtype'
                                    }, {
                                        header : "就诊类型",
                                        dataIndex : 'mrmrid'
                                    }, {
                                        header : "登记号",
                                        dataIndex : 'mRegno'
                                    }, {
                                        header : "姓名",
                                        dataIndex : 'mrname'
                                    }, {
                                        header : "性别",
                                        dataIndex : 'mrgender'
                                    }, {
                                        header : "年龄",
                                        dataIndex : 'mrage'
                                    }, {
                                        header : "身份证号",
                                        dataIndex : 'mrcardid',
                                        width : 150
                                    }, {
                                        header : "就诊日期",
                                        dataIndex : 'mradmdate',
                                        sortable : true
                                    }, {
                                        header : "医生",
                                        hidden : true,
                                        dataIndex : 'mrdisdate',
                                        width : 200
                                    }, {
                                        header : "科室",
                                        dataIndex : 'mrdisroom',
                                        sortable : true
                                    }, {
                                        header : "初步诊断",
                                        hidden : true,
                                        dataIndex : 'mrdisdiagname',
                                        sortable : true
                                    }, {
                                        header : "电话",
                                        dataIndex : 'mrtel',
                                        sortable : true
                                    },{
                                        header : "PAADM",
                                        hidden : true,
                                        dataIndex : 'mradm'
                                    }], false)
                }
     
                mrbasestore.load({
                            
                            params : {
                                
                                start : 0,
                                limit : Ext.getCmp('ColumnNum').getValue()
                            }
                        });

            })
    fupstore.on('beforeload', function() {
                var Date = Ext.getCmp('fusbDate').getValue()
                var EndDate = Ext.getCmp('fusbEndDate').getValue()

                if (Date != '')
                    Date = Date.format('Y-m-d').toString();
                if (EndDate != '')
                    EndDate = EndDate.format('Y-m-d').toString();

                fupstore.proxy.conn.url = 'dhccrmsetplan1.csp?action=fuplist'
                        + "&BeginDate=" + Date + "&EndDate=" + EndDate;
            })
    var mzinfo = new Ext.form.Label({
                id : 'mzinfo',
                text : '门诊只显示1天数据'

            })
    var mrbasetbar = new Ext.Toolbar({

                items : [spradio, FindButtonPanel, mzinfo]

            });

    var mrbasepanel = new Ext.Panel({
                region : 'center',
                title : '患者列表',
                layout : 'border',
                width : 800,
                frame : true,
                tbar : mrbasetbar,
                items : [queryinfo, grid, planpanel]
            });

    var mainPanel = new Ext.Viewport({
                layout : 'border',
                collapsible : true,
                items : [mrbasepanel]

            });
})