// /����: ���ҹ�����ά��
// /����: ���ҹ�����ά��
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.23
Ext.onReady(function () {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gStrParam = '';
    var groupId = session['LOGON.GROUPID'];
    var gLocId = null;
    var gLocManId = null;

    // ��ѯ��ť
    var SearchBT = new Ext.Toolbar.Button({
        text: $g('��ѯ'),
        tooltip: $g('�����ѯ'),
        iconCls: 'page_find',
        width: 70,
        height: 30,
        handler: function () {
            Query();
        }
    });

    /**
     * ��ѯ����
     */
    function Query() {
        // ��ѡ����
        var Code = Ext.getCmp('LocCode').getValue();
        var Desc = Ext.getCmp('LocDesc').getValue();

        gStrParam = Code + '^' + Desc;
        var PageSize = LocPagingToolbar.pageSize;
        LocStore.load({ params: { start: 0, limit: PageSize, StrParam: gStrParam, GroupId: groupId } });
    }

    // ��հ�ť
    var RefreshBT = new Ext.Toolbar.Button({
        text: $g('���'),
        tooltip: $g('������'),
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
        gStrParam = '';
        gLocManId = '';
        gLocId = '';
        Ext.getCmp('LocCode').setValue('');
        Ext.getCmp('LocDesc').setValue('');
        LocGrid.store.removeAll();
        LocGrid.getView().refresh();
        Query();
        LocManGrpStore.load({ params: { LocId: '' } });
        QueryLocUserManGrp();
    }

    //�½�
    var AddBT = new Ext.Toolbar.Button({
        id: 'AddBT',
        text: $g('����'),
        tooltip: $g('������ӹ�����'),
        width: 70,
        height: 30,
        iconCls: 'page_add',
        handler: function () {
            if (gLocId == null || gLocId.length < 1) {
                Msg.info('warning', $g('����ѡ�����!'));
                return;
            }

            AddNewRow();
        }
    });

    function AddNewRow() {
        var record = Ext.data.Record.create([{ name: 'Rowid' }, { name: 'Code' }, { name: 'Desc' }]);
        var newRecord = new Ext.data.Record({
            Rowid: '',
            Code: '',
            Desc: ''
        });

        LocManGrpStore.add(newRecord);
        var lastRow = LocManGrpStore.getCount() - 1;
        LocManGrpGrid.startEditing(lastRow, 2);
    }
    // ���水ť
    var SaveBT = new Ext.Toolbar.Button({
        id: 'SaveBT',
        text: $g('����'),
        tooltip: $g('������������'),
        width: 70,
        height: 30,
        iconCls: 'page_save',
        handler: function () {
            // ������ҿ�������Ϣ
            save();
        }
    });
    function save() {
        if (gLocId == null || gLocId.length < 1) {
            Msg.info('warning', $g('���Ҳ���Ϊ��!'));
            return;
        }
        var ListDetail = '';
        var rowCount = LocManGrpGrid.getStore().getCount();
        for (var i = 0; i < rowCount; i++) {
            var rowData = LocManGrpStore.getAt(i);
            //���������ݷ����仯ʱִ����������
            if (rowData.data.newRecord || rowData.dirty) {
                var Rowid = rowData.get('Rowid');
                var Code = rowData.get('Code').trim();
                var Desc = rowData.get('Desc').trim();
                if (Code == '') {
                    Msg.info('warning', $g('��') + (i + 1) + $g('�д���Ϊ��!'));
                    return;
                }
                if (Desc == '') {
                    Msg.info('warning', $g('��') + (i + 1) + $g('������Ϊ��!'));
                    return;
                }
                if (Code != '' && Desc != '') {
                    var str = Rowid + '^' + Code + '^' + Desc;
                    if (ListDetail == '') {
                        ListDetail = str;
                    } else {
                        ListDetail = ListDetail + xRowDelim() + str;
                    }
                }
            }
        }
        if (ListDetail == '') {
            Msg.info('warning', $g('û���޸Ļ����������!'));
            return false;
        }
        var url = DictUrl + 'locmangrpaction.csp?actiontype=Save';
        var mask = ShowLoadMask(Ext.getBody(), $g('���������Ժ�...'));
        Ext.Ajax.request({
            url: url,
            params: { LocId: gLocId, Detail: ListDetail },
            method: 'POST',
            waitMsg: $g('������...'),
            success: function (result, request) {
                var jsonData = Ext.util.JSON.decode(result.responseText);
                mask.hide();
                if (jsonData.success == 'true') {
                    Msg.info('success', $g('����ɹ�!'));
                    // ˢ�½���
                    LocManGrpStore.load({ params: { LocId: gLocId } });
                } else {
                    var ret = jsonData.info;
                    if (ret == -5) {
                        Msg.info('warning', $g('�����ظ�!'));
                    } else if (ret == -6) {
                        Msg.info('warning', $g('�����ظ�!'));
                    } else if (ret == -1) {
                        Msg.info('error', $g('û����Ҫ���������!'));
                    } else {
                        Msg.info('error', $g('����ʧ�ܣ�'));
                    }
                    LocManGrpStore.load({ params: { LocId: gLocId } });
                }
            },
            scope: this
        });
    }

    var DeleteBT = new Ext.Toolbar.Button({
        id: 'DeleteBT',
        text: $g('ɾ��'),
        width: '70',
        height: '30',
        tooltip: $g('���ɾ��������'),
        iconCls: 'page_delete',
        handler: function () {
            Delete();
        }
    });

    function Delete() {
        var cell = LocManGrpGrid.getSelectionModel().getSelectedCell();
        if (cell == null) {
            Msg.info('warning', $g('��ѡ��Ҫɾ���ļ�¼��'));
            return;
        }
        var row = cell[0];
        var record = LocManGrpStore.getAt(row);
        var rowid = record.get('Rowid');
        if (rowid == null || rowid.length < 1) {
            LocManGrpStore.remove(record);
            LocManGrpGrid.getView().refresh();
            return;
        } else {
            Ext.MessageBox.show({
                title: $g('��ʾ'),
                msg: $g('�Ƿ�ȷ��ɾ���ù�������Ϣ'),
                buttons: Ext.MessageBox.YESNO,
                fn: showResult,
                icon: Ext.MessageBox.QUESTION
            });
        }

        function showResult(btn) {
            if (btn == 'yes') {
                var url = DictUrl + 'locmangrpaction.csp?actiontype=Delete';
                var mask = ShowLoadMask(Ext.getBody(), $g('���������Ժ�...'));
                Ext.Ajax.request({
                    url: url,
                    method: 'post',
                    waitMsg: $g('������...'),
                    params: { Rowid: rowid },
                    success: function (response, opts) {
                        var jsonData = Ext.util.JSON.decode(response.responseText);
                        mask.hide();
                        if (jsonData.success == 'true') {
                            Msg.info('success', $g('ɾ���ɹ�!'));
                            LocManGrpStore.load({ params: { LocId: gLocId } });
                            QueryLocUserManGrp();
                        } else {
                            Msg.info('error', $g('ɾ��ʧ��!'));
                        }
                    }
                });
            }
        }
    }
    //��������Դ
    var locUrl = DictUrl + 'locmangrpaction.csp?actiontype=QueryLoc';
    var LocGridProxy = new Ext.data.HttpProxy({ url: locUrl, method: 'POST' });
    var LocStore = new Ext.data.Store({
        proxy: LocGridProxy,
        reader: new Ext.data.JsonReader(
            {
                totalProperty: 'results',
                root: 'rows'
            },
            [{ name: 'Rowid' }, { name: 'Code' }, { name: 'Desc' }]
        ),
        remoteSort: true
    });

    //ģ��
    var LocGridCm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(),
        {
            header: $g('����'),
            dataIndex: 'Code',
            width: 200,
            align: 'left',
            sortable: true
        },
        {
            header: $g('����'),
            dataIndex: 'Desc',
            width: 200,
            align: 'left',
            sortable: true
        }
    ]);
    //��ʼ��Ĭ��������
    LocGridCm.defaultSortable = true;
    var LocPagingToolbar = new Ext.PagingToolbar({
        store: LocStore,
        pageSize: PageSize,
        displayInfo: true,
        displayMsg: $g('�� {0} ���� {1}�� ��һ�� {2} ��'),
        emptyMsg: $g('û�м�¼'),
        doLoad: function (C) {
            var B = {},
                A = this.getParams();
            B[A.start] = C;
            B[A.limit] = this.pageSize;
            B[A.sort] = 'Rowid';
            B[A.dir] = 'desc';
            B['StrParam'] = gStrParam;
            B['GroupId'] = groupId;
            if (this.fireEvent('beforechange', this, B) !== false) {
                this.store.load({ params: B });
            }
        }
    });

    var LocCode = new Ext.form.TextField({
        id: 'LocCode',
        name: 'LocCode',
        width: 100
    });

    var LocDesc = new Ext.form.TextField({
        id: 'LocDesc',
        name: 'LocDesc',
        width: 120
    });

    //���
    LocGrid = new Ext.grid.GridPanel({
        id: 'LocGrid',
        region: 'west',
        title: $g('���ҹ�����'),
        store: LocStore,
        cm: LocGridCm,
        trackMouseOver: true,
        width: 500,
        height: 300,
        stripeRows: true,
        sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
        loadMask: true,
        bbar: LocPagingToolbar,
        tbar: [$g('����'), LocCode, $g('����'), LocDesc, '-', SearchBT, '-', RefreshBT]
    });

    LocGrid.addListener('rowclick', function (grid, rowindex, e) {
        LocUserManGrpGridDs.removeAll(); //�����Ա���
        gLocManId = ''; //�������
        var selectRow = LocStore.getAt(rowindex);
        gLocId = selectRow.get('Rowid');
        LocManGrpStore.load({ params: { LocId: gLocId } });
        LocUserManGrpGridDs.load({params:{locGrpId:gLocManId}});
		LocUserManGrpGrid.store.removeAll();
    });

    var nm = new Ext.grid.RowNumberer();
    var LocManGrpCm = new Ext.grid.ColumnModel([
        nm,
        {
            header: 'Rowid',
            dataIndex: 'Rowid',
            width: 80,
            align: 'left',
            sortable: true,
            hidden: true
        },
        {
            header: $g('����'),
            dataIndex: 'Code',
            width: 80,
            align: 'left',
            sortable: true,
            hidden: false,
            editor: new Ext.form.TextField({
                allowBlank: false,
                listeners: {
                    specialkey: function (field, e) {
                        var keycode = e.getKey();
                        if (keycode == e.ENTER) {
                            var cell = LocManGrpGrid.getSelectionModel().getSelectedCell();
                            var row = cell[0];
                            LocManGrpGrid.startEditing(row, 3);
                        }
                    }
                }
            })
        },
        {
            header: $g('����'),
            dataIndex: 'Desc',
            width: 200,
            align: 'left',
            sortable: true,
            editor: new Ext.form.TextField({
                allowBlank: false,
                listeners: {
                    specialkey: function (field, e) {
                        var keycode = e.getKey();
                        if (keycode == e.ENTER) {
                            AddNewRow();
                        }
                    }
                }
            })
        }
    ]);
    LocManGrpCm.defaultSortable = true;

    // ����·��
    var DspPhaUrl = DictUrl + 'locmangrpaction.csp?actiontype=Query&start=&limit=';
    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
        url: DspPhaUrl,
        method: 'POST'
    });
    // ָ���в���
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results',
        id: 'Rowid',
        fields: ['Rowid', 'Code', 'Desc']
    });
    // ���ݼ�
    var LocManGrpStore = new Ext.data.Store({
        pruneModifiedRecords: true,
        proxy: proxy,
        reader: reader
    });
    var LocManGrpGrid = new Ext.grid.EditorGridPanel({
        id: 'LocManGrpGrid',
        region: 'center',
        title: $g('������'),
        id: 'LocManGrpGrid',
        cm: LocManGrpCm,
        store: LocManGrpStore,
        trackMouseOver: true,
        stripeRows: true,
        height: 300,
        sm: new Ext.grid.CellSelectionModel({}),
        clicksToEdit: 1,
        tbar: [AddBT, '-', SaveBT, '-', DeleteBT],
        loadMask: true
    });

    LocManGrpGrid.addListener('rowclick', function (grid, rowindex, e) {
        var selectRow = LocManGrpStore.getAt(rowindex);
        gLocManId = selectRow.get('Rowid');
        QueryLocUserManGrp();
    });

    //���ñ༭��
    var ActiveField = new Ext.grid.CheckColumn({
        header: $g('�Ƿ���Ч'),
        dataIndex: 'Active',
        width: 100,
        sortable: true,
        renderer: function (v, p, record) {
            p.css += ' x-grid3-check-col-td';
            return '<div class="x-grid3-check-col' + (v == 'Y' || v == true ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
        }
    });

    //����
    var AddLocUserManGrp = new Ext.Toolbar.Button({
        text: $g('����'),
        tooltip: $g('������������Ա'),
        iconCls: 'page_add',
        width: 70,
        height: 30,
        handler: function () {
            AddLocUserNewRow();
        }
    }); //������Ա

    var SaveLocUserManGrp = new Ext.Toolbar.Button({
        text: $g('����'),
        tooltip: $g('�����������Ա'),
        width: 70,
        height: 30,
        iconCls: 'page_save',
        handler: function () {
            SaveLocUserMan();
        }
    });
    //ɾ����Ա
    var DeleteLocUserBT = new Ext.Toolbar.Button({
        id: 'DeleteLocUserBT',
        text: $g('ɾ��'),
        width: '70',
        height: '30',
        tooltip: $g('���ɾ��'),
        iconCls: 'page_delete',
        handler: function () {
            deleteLocUserMan();
        }
    }); //��Ա����

    var UStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: 'dhcst.orgutil.csp?actiontype=StkLocUserCatGrp'
        }),
        reader: new Ext.data.JsonReader(
            {
                totalProperty: 'results',
                root: 'rows'
            },
            ['Description', 'RowId']
        )
    });

    var UCG = new Ext.form.ComboBox({
        fieldLabel: $g('����'),
        id: 'UCG',
        name: 'UCG',
        anchor: '90%',
        width: 120,
        store: UStore,
        valueField: 'RowId',
        displayField: 'Description',
        allowBlank: false,
        triggerAction: 'all',
        emptyText: $g('����...'),
        selectOnFocus: true,
        forceSelection: true,
        minChars: 1,
        pageSize: 10,
        listWidth: 250,
        valueNotFoundText: '',
        listeners: {
            specialKey: function (field, e) {
                if (e.getKey() == Ext.EventObject.ENTER) {
                    //addNewRow();
                }
            }
        }
    });

    UCG.on('beforequery', function (e) {
        UStore.removeAll();
        UStore.setBaseParam('name', Ext.getCmp('UCG').getRawValue());
        UStore.setBaseParam('locId', gLocId);
        var pageSize = Ext.getCmp('UCG').pageSize;
        UStore.load({ params: { start: 0, limit: pageSize } });
    });

    //��������Դ
    //����·��
    var gridUrl = DictUrl + 'locmangrpaction.csp?actiontype=QueryLocUserMan&start=0&limit=200';
    var LocUserManGrpGridProxy = new Ext.data.HttpProxy({ url: gridUrl, method: 'GET' });
    var LocUserManGrpGridDs = new Ext.data.Store({
        proxy: LocUserManGrpGridProxy,
        reader: new Ext.data.JsonReader(
            {
                root: 'rows'
            },
            [{ name: 'Rowid' }, { name: 'UserId' }, { name: 'Code' }, { name: 'Name' }, { name: 'Active' }]
        ),
        pruneModifiedRecords: true,
        remoteSort: false
    });

    //ģ��
    var LocUserManGrpGridCm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(),
        {
            header: 'Rowid',
            dataIndex: 'Rowid',
            width: 200,
            align: 'left',
            sortable: true,
            hidden: true
        },
        {
            header: $g('����'),
            dataIndex: 'Code',
            width: 200,
            align: 'left',
            sortable: true
        },
        {
            header: $g('����'),
            dataIndex: 'UserId',
            width: 200,
            align: 'left',
            sortable: true,
            renderer: Ext.util.Format.comboRenderer2(UCG, 'UserId', 'Name'),
            editor: new Ext.grid.GridEditor(UCG)
        },
        ActiveField
    ]);

    //��ʼ��Ĭ��������
    LocUserManGrpGridCm.defaultSortable = true;

    var LocUserManGrpGridPagingToolbar = new Ext.PagingToolbar({
        store: LocUserManGrpGridDs,
        pageSize: 30,
        displayInfo: true,
        displayMsg: $g('�� {0} ���� {1}�� ��һ�� {2} ��'),
        emptyMsg: $g('û�м�¼'),
        doLoad: function (C) {
            var B = {},
                A = this.getParams();
            B[A.start] = C;
            B[A.limit] = this.pageSize;
            B[A.sort] = 'Rowid';
            B[A.dir] = 'desc';
            B['locGrpId'] = LocGrpId;
            if (this.fireEvent('beforechange', this, B) !== false) {
                this.store.load({ params: B });
            }
        }
    });

    //���˷�����
    LocUserManGrpGrid = new Ext.grid.EditorGridPanel({
        store: LocUserManGrpGridDs,
        cm: LocUserManGrpGridCm,
        trackMouseOver: true,
        height: 370,
        plugins: [ActiveField],
        stripeRows: true,
        sm: new Ext.grid.CellSelectionModel({}),
        //sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
        loadMask: true,
        clicksToEdit: 2,
        tbar: [AddLocUserManGrp, '-', SaveLocUserManGrp, '-', DeleteLocUserBT],
        bbar: LocUserManGrpGridPagingToolbar
    });
    LocUserManGrpGrid.on('beforeedit', function (e) {
        if (e.field == 'UserId') {
            //addComboData(UCG.getStore(),e.record.get("UserId"),e.record.get("Name"));
        }
    });
	var HospPanel = InitHospCombo('PHA-IN-LocManGrp',function(combo, record, index){
		HospId = this.value; 
		UStore.removeAll();
		UStore.reload();
		clearData();
	});

    var LocUserManGroupPanel = new Ext.Panel({
        id: 'LocUserManGroupPanel',
        region: 'south',
        deferredRender: true,
        title: $g('��Աά��'),
        activeTab: 0,
        height: 300,
        layout: 'fit',
        split: true,
        collapsible: true,
        items: [LocUserManGrpGrid]
    });

    // 5.2.ҳ�沼��
    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: [HospPanel,LocGrid, LocManGrpGrid, LocUserManGroupPanel], // create instance immediately
        renderTo: 'mainPanel'
    });

    //-----------------------------Events----------------------//

    Query();

    //������
    function AddLocUserNewRow() {
        if (gLocId == null || gLocId.length < 1) {
            Msg.info('warning', $g('����ѡ�����!'));
            return;
        }

        if (gLocManId == null || gLocManId.length < 1) {
            Msg.info('warning', $g('����ѡ�������!'));
            return;
        }

        var record = Ext.data.Record.create([
            {
                name: 'Rowid',
                type: 'int'
            },
            {
                name: 'UserId',
                type: 'int'
            },
            {
                name: 'Code',
                type: 'string'
            },
            {
                name: 'Name',
                type: 'string'
            },
            {
                name: 'Active',
                type: 'string'
            }
        ]);

        var rec = new record({
            Rowid: '',
            UserId: '',
            Code: '',
            Name: '',
            Default: 'Y',
            Active: 'Y'
        });
        LocUserManGrpGridDs.add(rec);
        LocUserManGrpGrid.startEditing(LocUserManGrpGridDs.getCount() - 1, 3);
    }

    //������Ա������
    function SaveLocUserMan() {
        //��ȡ���е��¼�¼
        var mr = LocUserManGrpGridDs.getModifiedRecords();
        var data = '';
        var nameflag = '';
        for (var i = 0; i < mr.length; i++) {
            var RowId = mr[i].data['Rowid'];
            var userId = mr[i].data['UserId'];
            var active = mr[i].data['Active'];
            var name = mr[i].data['Name'];
            if (RowId != '') {
                var dataRow = RowId + '^' + userId + '^' + active + '^' + name;
                if (data == '') {
                    data = dataRow;
                    nameflag = nameflag + userId;
                } else {
                    data = data + xRowDelim() + dataRow;
                    nameflag = nameflag + userId;
                }
            } else {
                var dataRow = '^' + userId + '^' + active + '^' + name;
                if (data == '') {
                    data = dataRow;
                    nameflag = nameflag + userId;
                } else {
                    data = data + xRowDelim() + dataRow;
                    nameflag = nameflag + userId;
                }
            }
        }

        if (nameflag == '') {
            Msg.info('warning', $g('û����Ҫ���������!'));
            return false;
        }

        if (data != '') {
            Ext.Ajax.request({
                url: DictUrl + 'locmangrpaction.csp?actiontype=SaveLocUserMan',
                params: { Detail: data, locGrpId: gLocManId },
                failure: function (result, request) {
                    Msg.info('error', $g('������������!'));
                },
                success: function (result, request) {
                    data = '';
                    var jsonData = Ext.util.JSON.decode(result.responseText);
                    if (jsonData.success == 'true') {
                        Msg.info('success',$g( '����ɹ�!'));
                        QueryLocUserManGrp();
                    } else {
                        var info = jsonData.info;
                        var infoarr = info.split(',');
                        var infovalue = infoarr[0];
                        var infodesc = infoarr[1];
                        if (infovalue == -99) {
                            Msg.info('warning', $g('��Ա�����ظ�����!') + infodesc);
                        } else {
                            Msg.info('error', $g('����ʧ��') + infodesc);
                        }
                    }
                },
                scope: this
            });
        }
    }
    function deleteLocUserMan() {
        var cell = LocUserManGrpGrid.getSelectionModel().getSelectedCell();
        if (cell == null) {
            Msg.info('warning', $g('��ѡ������!'));
            return false;
        } else {
            var record = LocUserManGrpGrid.getStore().getAt(cell[0]);
            var RowId = record.get('Rowid');
            if (RowId != '') {
                Ext.MessageBox.confirm('��ʾ', $g('ȷ��Ҫɾ��ѡ������?'), function (btn) {
                    if (btn == 'yes') {
                        Ext.Ajax.request({
                            url: DictUrl + 'locmangrpaction.csp?actiontype=deleteUser',
                            waitMsg: $g('ɾ����...'),
                            params: { RowId: RowId },
                            failure: function (result, request) {
                                Msg.info('error', $g('������������!'));
                            },
                            success: function (result, request) {
                                var jsonData = Ext.util.JSON.decode(result.responseText);
                                if (jsonData.success == 'true') {
                                    Msg.info('success', $g('ɾ���ɹ�!'));
                                    QueryLocUserManGrp();
                                } else {
                                    Msg.info('error', $g('ɾ��ʧ��!'));
                                }
                            },
                            scope: this
                        });
                    }
                });
            } else {
                LocUserManGrpGridDs.remove(record);
                LocUserManGrpGrid.getView().refresh();
            }
        }
    }

    //ˢ�±��
    function QueryLocUserManGrp() {
        LocUserManGrpGridDs.removeAll();
        LocUserManGrpGridDs.load({ params: { locGrpId: gLocManId } });
    }
});
