// /����: ��λ��ά��
// /����: ��λ��ά��
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.20
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gStrParam = '';
    var gGroupId = session['LOGON.GROUPID'];
	var HOSP_SELECT_TIMES=0;
    ChartInfoAddFun();

    function ChartInfoAddFun() {
        var PhaLoc = new Ext.ux.LocComboBox({
            fieldLabel: $g('����'),
            id: 'PhaLoc',
            name: 'PhaLoc',
            width: 250,
            groupId: gGroupId,
            listeners: {
                select: function(field, e) {
                    searchData();
                }
            }
        });
        var StkBin = new Ext.form.TextField({
            fieldLabel: $g('��λ��'),
            id: 'StkBin',
            name: 'StkBin',
            width: 150,
            disabled: false,
            listeners: {
                specialkey: function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        searchData();
                    }
                }
            }
        });
        // ��ѯ��ť
        var SearchBT = new Ext.Toolbar.Button({
            text: $g('��ѯ'),
            tooltip: $g('�����ѯ'),
            iconCls: 'page_find',
            width: 70,
            height: 30,
            handler: function() {
                searchData();
            }
        });

        /**
         * ��ѯ����
         */
        function searchData() {
            // ��ѡ����
            var phaLoc = Ext.getCmp("PhaLoc").getValue();
            if (phaLoc == null || phaLoc.length <= 0) {
                Msg.info("warning", $g("���Ҳ���Ϊ�գ�"));
                Ext.getCmp("PhaLoc").focus();
                return;
            }
            var stkBinDesc = Ext.getCmp("StkBin").getValue();
            gStrParam = phaLoc;
            var pagesize = GridPagingToolbar.pageSize;
            StkBinStore.removeAll();
            StkBinStore.setBaseParam('LocId', gStrParam);
            StkBinStore.setBaseParam('sbDesc', stkBinDesc);
            StkBinStore.load({ params: { start: 0, limit: 50 } });
        }

        // ɾ����ť
        var DeleteBT = new Ext.Toolbar.Button({
            id: "DeleteBT",
            text: $g('ɾ��'),
            tooltip: $g('���ɾ��'),
            width: 70,
            height: 30,
            iconCls: 'page_delete',
            handler: function() {
                deleteData();
            }
        });

        function deleteData() {
	        
	        var rows = StkBinGrid.getSelectionModel().getSelections();
	        var sbIdArr = [];
			for(var i=0;i<rows.length;i++){
				var sbId = rows[i].get("sb");
				if(!sbId) StkBinGrid.getStore().remove(rows[i]);
				else sbIdArr.push(rows[i].get("sb")) 
			}
			if(sbIdArr.length == 0) return;
	
			var sbIdStr = sbIdArr.join(",");
			Ext.MessageBox.show({
                title: $g('��ʾ'),
                msg: $g('�Ƿ�ȷ��ɾ����ѡ�Ļ�λ��Ϣ'),
                buttons: Ext.MessageBox.YESNO,
                parm: sbIdStr,
                fn: showResult,
                icon: Ext.MessageBox.QUESTION
            });
			
			return;
	        
	        /*
            var cell = StkBinGrid.getSelectionModel().getSelectedCell();
            if (cell == null) {
                Msg.info("warning", $g("û��ѡ����!"));
                return;
            }
            // ѡ����
            var row = cell[0];
            var record = StkBinGrid.getStore().getAt(row);
            var Rowid = record.get("sb");
            
            if (Rowid == null || Rowid.length <= 0) {
                StkBinGrid.getStore().remove(record);
            } else {
                Ext.MessageBox.show({
                    title: $g('��ʾ'),
                    msg: $g('�Ƿ�ȷ��ɾ��ѡ�л�λ��Ϣ'),
                    buttons: Ext.MessageBox.YESNO,
                    parm: Rowid,
                    fn: showResult,
                    icon: Ext.MessageBox.QUESTION
                });
            }
            */
        }

        /**
         * ɾ����λ��ʾ
         */
        function showResult(btn, text, opt) {
            if (btn == "yes") {
                var url = DictUrl +
                    "incstkbinaction.csp?actiontype=DeleteItms&sbIdStr=" +
                    opt.parm;
                var mask = ShowLoadMask(Ext.getBody(), $g("���������Ժ�..."));
                Ext.Ajax.request({
                    url: url,
                    method: 'POST',
                    waitMsg: $g('��ѯ��...'),
                    success: function(result, request) {
                        var jsonData = Ext.util.JSON
                            .decode(result.responseText);
                        mask.hide();
                        if (jsonData.success == 'true') {
                            Msg.info("success", $g("ɾ���ɹ�!"));
                            searchData();
                        } else {
                            var ret = jsonData.info;
                            if (ret == -2) {
                                Msg.info("error", $g("�û�λ�Ѿ����ã�����ɾ����"));
                            } else {
                                Msg.info("error", $g("ɾ��ʧ��:") + jsonData.info);
                            }
                        }
                    },
                    scope: this
                });
            }
        }

        // ��հ�ť
        var RefreshBT = new Ext.Toolbar.Button({
            text: $g('���'),
            tooltip: $g('������'),
            iconCls: 'page_refresh',
            width: 70,
            height: 30,
            handler: function() {
                clearData();
            }
        });

        /**
         * ��շ���
         */
        function clearData() {
            gStrParam = '';
            Ext.getCmp("PhaLoc").setValue("");
            StkBinGrid.store.removeAll();
            StkBinGrid.getView().refresh();
        }
        // �½���ť
        var AddBT = new Ext.Toolbar.Button({
            id: "AddBT",
            text: $g('�½�'),
            tooltip: $g('����½�'),
            width: 70,
            height: 30,
            iconCls: 'page_add',
            handler: function() {
	            addNewRow();
	            return;
                // �ж��Ƿ��Ѿ��������
                var rowCount = StkBinGrid.getStore().getCount();
                if (rowCount > 0) {
                    var rowData = StkBinStore.data.items[rowCount - 1];
                    var data = rowData.get("desc");
                    if (data == null || data.length <= 0) {
                        Msg.info("warning", $g("�Ѵ����½���!"));
                        return;
                    }
                }
                addNewRow();
            }
        });
        /**
         * ����һ��
         */
        function addNewRow() {
            var record = Ext.data.Record.create([{
                name: 'sb',
                type: 'string'
            }, {
                name: 'code',
                type: 'string'
            }, {
                name: 'desc',
                type: 'string'
            }]);
            var NewRecord = new record({
                sb: '',
                code: '',
                desc: ''
            });
            StkBinGrid.getStore().add(NewRecord);
            var s = StkBinGrid.getStore().getCount();
            //StkBinGrid.getSelectionModel().select(StkBinGrid.getStore().getCount() - 1, 3);
            //StkBinGrid.startEditing(StkBinStore.getCount() - 1, 3);
            StkBinGrid.getSelectionModel().selectRow(StkBinGrid.getStore().getCount() - 1, 4);
            StkBinGrid.startEditing(StkBinGrid.getStore().getCount() - 1, 4);
        };

        // ���水ť
        var SaveBT = new Ext.Toolbar.Button({
            id: "SaveBT",
            text: $g('����'),
            tooltip: $g('�������'),
            width: 70,
            height: 30,
            iconCls: 'page_save',
            handler: function() {
                save();
            }
        });

        function save() {
            PhaLocId = Ext.getCmp('PhaLoc').getValue();
            if (PhaLocId == null || PhaLocId.length < 1) {
                Msg.info("warning", $g("���Ҳ���Ϊ��!"));
                return;
            }
            var ListDetail = "";
            var rowCount = StkBinGrid.getStore().getCount();
            for (var i = 0; i < rowCount; i++) {
                var rowData = StkBinStore.getAt(i);
                //���������ݷ����仯ʱִ����������
                if (rowData.data.newRecord || rowData.dirty) {
                    var Rowid = rowData.get("sb");
                    var Desc = rowData.get("desc");

                    var str = Rowid + "^" + Desc;
                    if (ListDetail == "") {
                        ListDetail = str;
                    } else {
                        ListDetail = ListDetail + xRowDelim() + str;
                    }
                }
            }
            var url = DictUrl +
                "incstkbinaction.csp?actiontype=Save";
            var mask = ShowLoadMask(Ext.getBody(), $g("���������Ժ�..."));
            Ext.Ajax.request({
                url: url,
                method: 'POST',
                params: { LocId: PhaLocId, Detail: ListDetail },
                waitMsg: $g('������...'),
                success: function(result, request) {
                    var jsonData = Ext.util.JSON
                        .decode(result.responseText);
                    mask.hide();
                    if (jsonData.success == 'true') {

                        Msg.info("success", $g("����ɹ�!"));
                        // ˢ�½���
                        searchData();

                    } else {
                        var ret = jsonData.info;
                        if (ret == -1) {
                            Msg.info("error", $g("����Ϊ��,���ܱ���!"));
                        } else if (ret == -2) {
                            Msg.info("error", $g("û����Ҫ���������!"));
                        } else if (ret == -4) {
                            Msg.info("error", $g("��λ�����ظ�!"));
                        } else {
                            Msg.info("error", $g("������ϸ���治�ɹ���") + ret);
                        }
                    }
                },
                scope: this
            });
        }

        var nm = new Ext.grid.RowNumberer();
        var chkSm = new Ext.grid.CheckboxSelectionModel();
        var StkBinCm = new Ext.grid.ColumnModel([nm, chkSm, {
            header: "rowid",
            dataIndex: 'sb',
            width: 80,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: $g('����'),
            dataIndex: 'code',
            width: 80,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: $g("��λ��"),
            dataIndex: 'desc',
            width: 400,
            align: 'left',
            sortable: true,
            editor: new Ext.form.TextField({
                allowBlank: false,
                listeners: {
                    specialkey: function(field, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                           setTimeout(function(){addNewRow()},0)
                        }
                    }
                }
            })
        }]);
        StkBinCm.defaultSortable = true;

        // ����·��
        var DspPhaUrl = DictUrl +
            'incstkbinaction.csp?actiontype=Query&start=&limit=';
        // ͨ��AJAX��ʽ���ú�̨����
        var proxy = new Ext.data.HttpProxy({
            url: DspPhaUrl,
            method: "POST"
        });
        // ָ���в���
        var fields = ["sb", "code", "desc"];
        // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
        var reader = new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: "results",
            id: "sb",
            fields: fields
        });
        // ���ݼ�
        var StkBinStore = new Ext.data.Store({
            proxy: proxy,
            reader: reader
        });

        var GridPagingToolbar = new Ext.PagingToolbar({
            store: StkBinStore,
            pageSize: 50,
            displayInfo: true,
            displayMsg: $g('�� {0} ���� {1}�� ��һ�� {2} ��'),
            emptyMsg: $g("û�м�¼")
        });

        var StkBinGrid = new Ext.grid.EditorGridPanel({
            id: 'StkBinGrid',
            region: 'center',
            cm: StkBinCm,
            store: StkBinStore,
            trackMouseOver: true,
            stripeRows: true,
            sm: chkSm, //new Ext.grid.CellSelectionModel({}),
            clicksToEdit: 1,
            loadMask: true,
            bbar: GridPagingToolbar
        });
		var HospPanel = InitHospCombo('PHA-IN-StkBin',function(combo, record, index){
			HOSP_SELECT_TIMES++;
			if (HOSP_SELECT_TIMES>1){
				Ext.getCmp("PhaLoc").setValue("");
				HospId = this.value; 
				StkBinGrid.store.removeAll();
				StkBinGrid.getView().refresh();
				StkBinStore.setBaseParam('LocId', '');
			}
		});
        var HisListTab = new Ext.form.FormPanel({
	        id:"HisListTab",
            labelWidth: 60,
            height: DHCSTFormStyle.FrmHeight(1),
            labelAlign: 'right',
            title: $g('��λ��ά��'),
            region: 'north',
            frame: true,
            tbar: [SearchBT, '-', AddBT, '-', SaveBT, '-', DeleteBT],
            items: [{
                xtype: 'fieldset',
                title: $g('��ѯ����'),
                layout: 'column',
                style: DHCSTFormStyle.FrmPaddingV,
                layout: 'column',
                items: [{
                    columnWidth: .3,
                    xtype: 'fieldset',
                    border: false,
                    items: [PhaLoc]
                }, {
                    columnWidth: .5,
                    xtype: 'fieldset',
                    border: false,
                    items: [StkBin]
                }]
            }]
        });

        // 5.2.ҳ�沼��
        var mainPanel = new Ext.Viewport({
            layout: 'border',
			items:[
				{
					region:'north',
					height:'500px',
					items:[HospPanel,HisListTab]
				},StkBinGrid
			],
            renderTo: 'mainPanel'
        });

        // ��¼����Ĭ��ֵ
        SetLogInDept(PhaLoc.getStore(), "PhaLoc");
        searchData();
    }
})