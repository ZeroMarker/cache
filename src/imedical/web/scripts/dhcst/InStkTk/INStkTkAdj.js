// /����: �̵㵥����
// /����: �̵㵥����
// /��д�ߣ�zhangdongmei
// /��д����: 2012.09.12
Ext.onReady(function () {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gStrParams = '';
    var gRowid = '';
    Ext.Ajax.timeout = 900000;
    var gGroupId = session["LOGON.GROUPID"];
    var url = DictUrl + 'instktkaction.csp';
    var PhaLoc = new Ext.ux.LocComboBox({
        fieldLabel: '����',
        id: 'PhaLoc',
        name: 'PhaLoc',
        anchor: '90%',
        emptyText: '����...',
        groupId: gGroupId
    });

    // ��ʼ����
    var StartDate = new Ext.ux.DateField({
        fieldLabel: '��ʼ����',
        id: 'StartDate',
        name: 'StartDate',
        anchor: '90%',
        width: 80,
        value: new Date().add(Date.DAY, -30)
    });

    // ��������
    var EndDate = new Ext.ux.DateField({
        fieldLabel: '��������',
        id: 'EndDate',
        name: 'EndDate',
        anchor: '90%',
        width: 80,
        value: new Date()
    });

    // ��ѯ��ť
    var QueryBT = new Ext.Toolbar.Button({
        text: '��ѯ',
        tooltip: '�����ѯ',
        iconCls: 'page_find',
        width: 70,
        height: 30,
        handler: function () {
            Query();
        }
    });

    //��ѯ�̵㵥
    function Query() {

        var StartDate = Ext.getCmp("StartDate").getValue().format(App_StkDateFormat).toString();;
        var EndDate = Ext.getCmp("EndDate").getValue().format(App_StkDateFormat).toString();
        var PhaLoc = Ext.getCmp("PhaLoc").getValue();
        if (PhaLoc == "") {
            Msg.info("warning", "��ѡ���̵����!");
            return;
        }
        if (StartDate == "" || EndDate == "") {
            Msg.info("warning", "��ѡ��ʼ���ںͽ�ֹ����!");
            return;
        }
        var CompFlag = 'Y';
        var TkComplete = 'Y'; //ʵ����ɱ�־
        var AdjComplete = 'N'; //������ɱ�־
        var Page = GridPagingToolbar.pageSize;
        gStrParams = PhaLoc + '^' + StartDate + '^' + EndDate + '^' + CompFlag + '^' + TkComplete + '^' + AdjComplete;
        MasterInfoStore.load({
            params: {
                actiontype: 'Query',
                start: 0,
                limit: Page,
                sort: 'instNo',
                dir: 'asc',
                Params: gStrParams
            }
        });
    }

    // ��հ�ť
    var RefreshBT = new Ext.Toolbar.Button({
        text: '����',
        tooltip: '�������',
        iconCls: 'page_clearscreen',
        width: 70,
        height: 30,
        handler: function () {
            clearData();
        }
    });

    /**
     * ��շ���
     */
    function clearData() {

        gStrParams = '';
        var stDate = new Date().add(Date.DAY, -30);
        var edDate = new Date();
        Ext.getCmp("StartDate").setValue(stDate);
        Ext.getCmp("EndDate").setValue(edDate);

        MasterInfoStore.removeAll();
        MasterInfoStore.load({
            params: {
                start: 0,
                limit: 0
            }
        })
        MasterInfoGrid.getView().refresh();
        GridPagingToolbar.updateInfo();
        StatuTabPagingToolbar.updateInfo();
        gRowid = ""
        InstDetailStore.removeAll();
        InstDetailStore.load({
            params: {
                actiontype: 'QueryDetail',
                start: 0,
                limit: 0,
                Parref: 0
            }
        })
        InstDetailGrid.getView().refresh();


    }

    var CompleteBT = new Ext.Toolbar.Button({
        text: 'ȷ��',
        tooltip: '���ȷ�ϵ���',
        iconCls: 'page_gear',
        width: 70,
        height: 30,
        handler: function () {
            Complete();
        }
    });

    function Complete() {

        var selectRow = MasterInfoGrid.getSelectionModel().getSelected();
        if (selectRow == null || selectRow == "") {
            Msg.info("Warning", "��ѡ��Ҫ�������̵㵥!");
            return;
        }

        var inst = selectRow.get('inst');
        if (inst == null || inst == "") {
            Msg.info("Warning", "��ѡ��Ҫ�������̵㵥!");
            return;
        }
        var userId = session['LOGON.USERID'];
        var mask = ShowLoadMask(Ext.getBody(), "������...");
        Ext.Ajax.request({
            url: url,
            params: {
                actiontype: 'StkTkAdj',
                Inst: inst,
                UserId: userId
            },
            method: 'post',
            waitMsg: '������...',
            success: function (response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                if (jsonData.success == 'true') {
                    Msg.info("success", "�����ɹ�!");
                    Query();
                    InstDetailGrid.store.removeAll();
                    InstDetailGrid.store.load({
                        params: {
                            start: 0,
                            limit: 0
                        }
                    })
                    InstDetailGrid.getView().refresh();
                } else {
                    var ret = jsonData.info;
                    if (ret == -1) {
                        Msg.info("error", "���̵㵥������δ���!");
                    } else if (ret == -2) {
                        Msg.info("error", "���̵㵥ʵ������δ����!");
                    } else if (ret == -3) {
                        Msg.info("error", "���̵㵥�Ѿ�����!");
                    } else if (ret == -4) {
                        Msg.info("error", "���������ʧ��!");
                    } else if (ret == -6) {
                        Msg.info("error", "���������ϸʧ��!");
                    } else if (ret == -8) {
                        Msg.info("error", "�������ʧ��!");
                    } else {
                        ret = ret.replace('-8:-100^', '');
                        Ext.Msg.show({
                            title: '������ʾ',
                            msg: ret,
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.ERROR
                        });
                    }
                }

                mask.hide();
            }
        });
    }

    var SaveBT = new Ext.Toolbar.Button({
        text: '����',
        tooltip: '��������޸ĺ��ʵ������',
        iconCls: 'page_save',
        width: 70,
        height: 30,
        handler: function () {
            save();
        }
    });

    //����ʵ������
    function save() {
        if (InstDetailGrid.activeEditor != null) {
            InstDetailGrid.activeEditor.completeEdit();
        }
        var rowCount = InstDetailStore.getCount();
        var ListDetail = '';
        for (var i = 0; i < rowCount; i++) {
            var rowData = InstDetailStore.getAt(i);
            //�������޸Ĺ�������
            if (rowData.dirty || rowData.data.newRecord) {
                var desc = rowData.get('desc');
                var rowid = rowData.get('rowid');
                var inclb = rowData.get('inclb');
                var countQty = rowData.get('countQty');
                var freQty = rowData.get('freQty');
                var curqty = rowData.get('curqty');
                var afterqty = Number(countQty) - Number(freQty) + Number(curqty)
                if (afterqty < 0) {
                    changeBgColor(i, "yellow");
                    Msg.info("warning", desc + ",��" + i + "��" + "��������Ϊ����,���޸�ʵ����!");
                    return;
                }
                var Detail = rowid + '^' + inclb + '^' + countQty;
                if (ListDetail == '') {
                    ListDetail = Detail;
                } else {
                    ListDetail = ListDetail + xRowDelim() + Detail;
                }
            }
        }
        if (ListDetail == '') {
            Msg.info('Warning', 'û����Ҫ���������!');
            return;
        }
        var mask = ShowLoadMask(Ext.getBody(), "���������Ժ�...");
        Ext.Ajax.request({
            url: url,
            params: {
                actiontype: 'SaveAdjInput',
                Params: ListDetail
            },
            method: 'post',
            waitMsg: '������...',
            success: function (response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                mask.hide();
                if (jsonData.success == 'true') {
                    Msg.info('success', '����ɹ�!');
                    InstDetailStore.reload();
                } else {
                    var ret = jsonData.info;
                    if (ret == '-1') {
                        Msg.info('warning', 'û����Ҫ���������!');
                    } else if (ret == '-2') {
                        Msg.info('error', '����ʧ��!');
                    } else {
                        Msg.info('error', '�������ݱ���ʧ��:' + ret);
                    }
                }
            }
        });
    }

    // �任����ɫ
    function changeBgColor(row, color) {
        InstDetailGrid.getView().getRow(row).style.backgroundColor = color;
    }

    // ָ���в���
    var fields = ["inst", "instNo", "date", "time", "userName", "status", "locDesc", "comp", "stktkComp",
        "adjComp", "adj", "manFlag", "freezeUom", "includeNotUse", "onlyNotUse", "scgDesc", "scDesc", "frSb", "toSb"
    ];
    // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: "results",
        id: "inst",
        fields: fields
    });
    // ���ݼ�
    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
        url: url,
        method: "POST"
    });
    var MasterInfoStore = new Ext.data.Store({
        proxy: proxy,
        reader: reader
    });

    function renderManaFlag(value) {
        if (value == 'Y') {
            return '����ҩ';
        } else {
            return '�ǹ���ҩ'
        }
    }

    function renderYesNo(value) {
        if (value == 'Y') {
            return '��';
        } else {
            return '��'
        }
    }
    var nm = new Ext.grid.RowNumberer();
    var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
        header: "RowId",
        dataIndex: 'inst',
        width: 100,
        align: 'left',
        sortable: true,
        hidden: true,
        hideable: false
    }, {
        header: "�̵㵥��",
        dataIndex: 'instNo',
        width: 150,
        align: 'left',
        sortable: true
    }, {
        header: "�̵�����",
        dataIndex: 'date',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: '�̵�ʱ��',
        dataIndex: 'time',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: '�̵���',
        dataIndex: 'userName',
        width: 70,
        align: 'left',
        sortable: true
    }, {
        header: '����ҩ��־',
        dataIndex: 'manFlag',
        width: 80,
        align: 'left',
        renderer: renderManaFlag,
        sortable: true
    }, {
        header: "���̵�λ",
        dataIndex: 'freezeUom',
        width: 80,
        align: 'left',
        renderer: function (value) {
            if (value == 1) {
                return '��ⵥλ';
            } else {
                return '������λ';
            }
        },
        sortable: true
    }, {
        header: "����������",
        dataIndex: 'includeNotUse',
        width: 80,
        align: 'center',
        renderer: renderYesNo,
        sortable: true
    }, {
        header: "��������",
        dataIndex: 'onlyNotUse',
        renderer: renderYesNo,
        width: 60,
        align: 'center',
        sortable: true
    }, {
        header: "����",
        dataIndex: 'scgDesc',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: "������",
        dataIndex: 'scDesc',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: "��ʼ��λ",
        dataIndex: 'frSb',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: "��ֹ��λ",
        dataIndex: 'toSb',
        width: 100,
        align: 'left',
        sortable: true
    }]);
    MasterInfoCm.defaultSortable = true;
    var GridPagingToolbar = new Ext.PagingToolbar({
        store: MasterInfoStore,
        pageSize: PageSize,
        displayInfo: true,
        displayMsg: '��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
        emptyMsg: "No results to display",
        prevText: "��һҳ",
        nextText: "��һҳ",
        refreshText: "ˢ��",
        lastText: "���ҳ",
        firstText: "��һҳ",
        beforePageText: "��ǰҳ",
        afterPageText: "��{0}ҳ",
        emptyMsg: "û������"
        /*,
                            doLoad:function(C){
                                var B={},
                                A=this.getParams();
                                B[A.start]=C;
                                B[A.limit]=this.pageSize;
                                B[A.sort]='Rowid';
                                B[A.dir]='desc';
                                B['Params']=gStrParams;
                                B['actiontype']='Query';
                                if(this.fireEvent("beforechange",this,B)!==false){
                                    this.store.load({params:B});
                                }
                            }*/
    });
    var MasterInfoGrid = new Ext.grid.GridPanel({
        id: 'MasterInfoGrid',
        title: '�̵㵥',
        height: 170,
        cm: MasterInfoCm,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
        store: MasterInfoStore,
        trackMouseOver: true,
        stripeRows: true,
        loadMask: true,
        bbar: [GridPagingToolbar]
    });
    MasterInfoStore.on('load', function () {
        if (MasterInfoStore.getCount() > 0) {
            MasterInfoGrid.getSelectionModel().selectRow(0);
            MasterInfoGrid.getView().focusRow(0);
        } else {
            gRowid = ""
            InstDetailStore.removeAll();
            InstDetailStore.load({
                params: {
                    actiontype: 'QueryDetail',
                    start: 0,
                    limit: 0,
                    Parref: 0
                }
            })
            InstDetailGrid.getView().refresh();
        }
    });
    // ��ӱ�񵥻����¼�
    MasterInfoGrid.on('rowclick', QueryDetail);
    MasterInfoGrid.getSelectionModel().on('rowselect', QueryDetail);

    function QueryDetail(sm, rowIndex, r) {
        var selectRow = MasterInfoStore.getAt(rowIndex);
        gRowid = selectRow.get('inst');
        var size = StatuTabPagingToolbar.pageSize;
        var othersArr = [];
        othersArr[4] = (Ext.getCmp("adjFail").getValue() == true) ? 'Y' : 'N';
        othersArr[5] = (Ext.getCmp("avaLessAdj").getValue() == true) ? 'Y' : 'N';
        InstDetailStore.load({
            params: {
                actiontype: 'QueryDetail',
                start: 0,
                limit: size,
                sort: 'rowid',
                dir: 'ASC',
                Parref: gRowid,
                Params: othersArr.join("^")
            }
        });
    }
   function StatusColorRenderer(val,meta){
			if (val=="�ѵ���")
			meta.css='classCyan';
			return val
		
	}
    
    var nm = new Ext.grid.RowNumberer();
    var InstDetailGridCm = new Ext.grid.ColumnModel([nm, {
        header: "rowid",
        dataIndex: 'rowid',
        width: 80,
        align: 'left',
        sortable: true,
        hidden: true
    }, {
        header: "inclb",
        dataIndex: 'inclb',
        width: 80,
        align: 'left',
        sortable: true,
        hidden: true
    }, {
        header: '״̬',
        dataIndex: 'statusi',
        width: 60,
        align: 'left',
        sortable: true,
		renderer:StatusColorRenderer
    }, {
        header: '����',
        dataIndex: 'code',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: "����",
        dataIndex: 'desc',
        width: 200,
        align: 'left',
        sortable: true
    }, {
        header: "���",
        dataIndex: 'spec',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: '����',
        dataIndex: 'batchNo',
        width: 80,
        align: 'right',
        sortable: true
    }, {
        header: 'Ч��',
        dataIndex: 'expDate',
        width: 100,
        align: 'right',
        sortable: true
    }, {
        header: "��λ",
        dataIndex: 'uomDesc',
        width: 60,
        align: 'left',
        sortable: true
    }, {
        header: '��������',
        dataIndex: 'freQty',
        width: 80,
        align: 'right',
        sortable: true
    }, {
        header: '<font color=blue>ʵ������</font>',
        dataIndex: 'countQty',
        width: 80,
        align: 'right',
        sortable: true,
        editor: new Ext.form.NumberField({
            selectOnFocus: true,
            allowNegative: false,
            listeners: {
                'specialkey': function (field, e) {
                    var keyCode = e.getKey();
                    var col = GetColIndex(InstDetailGrid, 'countQty');
                    var cell = InstDetailGrid.getSelectionModel().getSelectedCell();
                    InstDetailGrid.stopEditing(cell[0], col);
                    var record = InstDetailGrid.getStore().getAt(cell[0]);
                    var rowCount = InstDetailGrid.getStore().getCount();
                    if (keyCode == Ext.EventObject.ENTER) {
                        var qty = field.getValue();
                        if (qty < 0) {
                            Msg.info('warning', 'ʵ����������С����!');
                            return;
                        }
                        var freQty = record.get("freQty")
                        record.set("variance", (Number(qty) - Number(freQty)));
                        var row = cell[0] + 1;
                        if (row < rowCount) {
                            var task = new Ext.util.DelayedTask(function () {
                                InstDetailGrid.startEditing(row, col);
                            })
                            task.delay(100);
                        }
                    }
                    if (keyCode == Ext.EventObject.UP) {
                        var row = cell[0] - 1;
                        if (row >= 0) {
                            InstDetailGrid.getSelectionModel().select(row, col);
                            InstDetailGrid.startEditing(row, col);
                        }
                    }
                    if (keyCode == Ext.EventObject.DOWN) {
                        var row = cell[0] + 1;
                        if (row < rowCount) {
                            InstDetailGrid.getSelectionModel().select(row, col);
                            InstDetailGrid.startEditing(row, col);
                        }
                    }
                }
            }
        })
    }, {
        header: '��������',
        dataIndex: 'variance',
        width: 80,
        align: 'right',
        sortable: true
    }, {
        header: '���ÿ��',
        dataIndex: 'avaqty',
        width: 100,
        align: 'right',
        sortable: true
    }, {
        header: '��ǰ���',
        dataIndex: 'curqty',
        width: 100,
        align: 'right',
        sortable: true
    }, {
        header: '������',
        dataIndex: 'afterqty',
        width: 100,
        align: 'right',
        sortable: true
    }, {
        header: "����",
        dataIndex: 'manf',
        width: 100,
        align: 'right',
        sortable: true
    },{
		header:'���̽��۽��',
		dataIndex:'freezeRpAmt',
		width:120,
		align:'right',
		sortable:true
	},{
		header:'ʵ�̽��۽��',
		dataIndex:'countRpAmt',
		width:120,
		align:'right',
		sortable:true
	},{
		header:'�����ۼ۽��',
		dataIndex:'freezeSpAmt',
		width:120,
		align:'right',
		sortable:true
	},{
		header:'ʵ���ۼ۽��',
		dataIndex:'countSpAmt',
		width:120,
		align:'right',
		sortable:true
	},{
		header:'���۲��',
		dataIndex:'varianceRpAmt',
		width:120,
		align:'right',
		sortable:true
	},{
		header:'�ۼ۲��',
		dataIndex:'varianceSpAmt',
		width:120,
		align:'right',
		sortable:true
	}]);
    InstDetailGridCm.defaultSortable = true;

    // ���ݼ�
    var InstDetailStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: url,
            method: "POST"
        }),
        reader: new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: "results",
            id: "instw",
            fields: ["rowid", "inclb", "inci", "code", "desc", "spec", "manf", "batchNo", "expDate",
                "freQty", "uom", "uomDesc", "countQty", "freDate", "freTime",
                "countDate", "countTime", "countPersonName", "variance", "curqty", "afterqty", "avaqty","statusi" 
            ,"freezeSpAmt","freezeRpAmt","countSpAmt","countRpAmt","varianceSpAmt","varianceRpAmt"]
        }),
        remoteSort: true,
        pruneModifiedRecords: true
    });

    var StatuTabPagingToolbar = new Ext.PagingToolbar({
        store: InstDetailStore,
        pageSize: PageSize,
        displayInfo: true,
        displayMsg: '��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
        prevText: "��һҳ",
        nextText: "��һҳ",
        refreshText: "ˢ��",
        lastText: "���ҳ",
        firstText: "��һҳ",
        beforePageText: "��ǰҳ",
        afterPageText: "��{0}ҳ",
        emptyMsg: "û������",
        doLoad: function (C) {
            var B = {},
                A = this.getParams();
            B[A.start] = C;
            B[A.limit] = this.pageSize;
            B[A.sort] = 'rowid';
            B[A.dir] = 'asc';
            B['Parref'] = gRowid;
            B['actiontype'] = 'QueryDetail';
            var othersArr = [];
            othersArr[4] = (Ext.getCmp("adjFail").getValue() == true) ? 'Y' : 'N';
            othersArr[5] = (Ext.getCmp("avaLessAdj").getValue() == true) ? 'Y' : 'N';
            B['Params'] = othersArr.join("^");
            if (this.fireEvent("beforechange", this, B) !== false) {
                this.store.load({
                    params: B
                });
            }
        }
    });

    StatuTabPagingToolbar.addListener('beforechange', function (toolbar, params) {
        if (InstDetailGrid.activeEditor != null) {
            InstDetailGrid.activeEditor.completeEdit();
        }
        var records = InstDetailStore.getModifiedRecords();
        if (records.length > 0) {
            Ext.Msg.show({
                title: '��ʾ',
                msg: '��ҳ���ݷ����ı䣬�Ƿ���Ҫ���棿',
                buttons: Ext.Msg.YESNOCANCEL,
                fn: function (btn, text, opt) {
                    if (btn == 'yes') {
                        //save();
                        toolbar.store.commitChanges();
                        changePagingToolBar(toolbar, params.start);
                    }
                    if (btn == 'no') {
                        toolbar.store.rejectChanges();
                        changePagingToolBar(toolbar, params.start);
                    }
                },
                animEl: 'elId',
                icon: Ext.MessageBox.QUESTION
            });
            return false;
        }
    });

    ///startRow:��ǰҳ�п�ʼ�е������м�¼�е�˳��
    function changePagingToolBar(toolbar, startRow) {
        if (toolbar.cursor > startRow) {
            if (toolbar.cursor - startRow == toolbar.pageSize) {
                toolbar.movePrevious();
            } else {
                toolbar.moveFirst();
            }
        }
        if (toolbar.cursor < startRow) {
            if (toolbar.cursor - startRow == -toolbar.pageSize) {
                toolbar.moveNext();
            } else {
                toolbar.moveLast();
            }
        }
    }

    var InstDetailGrid = new Ext.grid.EditorGridPanel({
        title: "�̵㵥��ϸ",
        id: 'InstDetailGrid',
        region: 'center',
        cm: InstDetailGridCm,
        store: InstDetailStore,
        trackMouseOver: true,
        stripeRows: true,
        //sm : new Ext.grid.RowSelectionModel(),
        sm: new Ext.grid.CellSelectionModel(), //liangjiaquan modify 2018-10-23��Ϊ��ģʽ
        loadMask: true,
        clicksToEdit: 1,
        bbar: [StatuTabPagingToolbar],
        tbar: ['       ', {
                xtype: 'checkbox',
                boxLabel: '��ϸδ����',
                id: 'adjFail',
                checked: false,
                width: '100px'
            },
            {
                xtype: 'checkbox',
                boxLabel: '��������С�ڵ�����',
                id: 'avaLessAdj',
                checked: false,
                width: '155px'
            }

        ],
        viewConfig: {
            getRowClass: function (record, rowIndex, rowParams, store) {
                var countQty = record.get("countQty");
                var freQty = record.get("freQty");
                var variance = Number(countQty) - Number(freQty)
                //var variance=record.get("variance");
                var code = record.get("code");
                var ststusi=record.get("ststusi");
                if (code == "�ϼ�") {
                    return;
                }
                if (Number(variance) < 0) return 'classSalmon';
                //if(ststusi!="") s
                if (Number(variance) > 0) return 'classAquamarine';
                
            }
        },
         listeners:{  
            'beforeedit':function(o ){  
	            var cellrow=o.row;
	            var rowData = InstDetailStore.getAt(cellrow);
                var statusi = rowData.get("statusi"); 
                if(statusi != "") 
                { 
                	Msg.info("warning", "�Ѿ������ļ�¼���������޸ģ�");
                    return false; 
                } 
                else  
                    return true;  
            }  
        }


    });
    /*
      InstDetailGrid.on('beforeedit', function(e) {
        if (e.field == "countQty") {
			e.cancel = true;
        }
	});
	*/
    

    var form = new Ext.form.FormPanel({
        labelAlign: 'right',
        labelWidth: 60,
        frame: true,
        autoHeight: true,
        title: '�̵����',
        tbar: [QueryBT, '-', RefreshBT, '-', SaveBT, '-', CompleteBT],
        items: [{
            xtype: 'fieldset',
            title: '��ѯ����',
            layout: 'column',
            defaults: {
                border: false
            },
            style: DHCSTFormStyle.FrmPaddingV,
            items: [{
                columnWidth: 0.25,
                xtype: 'fieldset',
                items: [PhaLoc]

            }, {
                columnWidth: 0.25,
                xtype: 'fieldset',
                items: [StartDate]

            }, {
                columnWidth: 0.25,
                xtype: 'fieldset',
                items: [EndDate]

            }]
        }]
    });

    // 5.2.ҳ�沼��
    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: [{
            region: 'north',
            split: false,
            height: DHCSTFormStyle.FrmHeight(1),
            layout: 'fit', // specify layout manager for items
            items: form

        }, {
            region: 'west',
            split: true,
            //collapsible: true, 
            width: document.body.clientWidth * 0.3,
            minSize: document.body.clientWidth * 0.1,
            maxSize: document.body.clientWidth * 0.9,
            layout: 'fit', // specify layout manager for items
            items: MasterInfoGrid

        }, {
            region: 'center',
            layout: 'fit',
            items: [InstDetailGrid]
        }],
        renderTo: 'mainPanel'
    });

    Query();
})