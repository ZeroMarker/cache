// /����: ��;������Ϣ��ѯ
// /����: ��;������Ϣ��ѯ
// /��д�ߣ�yunhaibao
// /��д����: 2012.08.17

/**
 * @StrParams:ͳһ�۴����ҿ����ID,���μ۴�����ID
 * @IncInfo:
 * @fn
 */
function ReserveQtyQuery(Incil, Inclb, IncInfo, Fn) {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    // ��ѯ��ť
    var ClrResBT = new Ext.Toolbar.Button({
        text: $g('�����;��'),
        tooltip: $g('������ѡ�е���;'),
        iconCls: 'page_clearscreen',
        width: 70,
        height: 30,
        handler: function () {
            ClearResQty();
        }
    });
    var nm = new Ext.grid.RowNumberer();
    var newSM = new Ext.grid.CheckboxSelectionModel({
        singleSelect: false
    });
    var Cm = new Ext.grid.ColumnModel([nm, newSM,
        {
            header: $g("���ҿ����ID"),
            dataIndex: 'incilRowId',
            width: 80,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: $g("ָ��"),
            dataIndex: 'pointer',
            width: 80,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: $g('�ǼǺ�'),
            dataIndex: 'patNo',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: $g('����'),
            dataIndex: 'patName',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: $g('ҽ������'),
            dataIndex: 'orderDept',
            width: 200,
            align: 'left',
            sortable: true
        }, {
            header: $g('������'),
            dataIndex: 'prescNo',
            width: 125,
            align: 'left',
            sortable: true
        }, {
            header: $g("ʣ����;��"),
            dataIndex: 'resQty',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: $g("��λ"),
            dataIndex: 'uomDesc',
            width: 90,
            align: 'left',
            sortable: true
        }, {
            header: $g('����'),
            dataIndex: 'oeDspDate',
            width: 100,
            align: 'right',
            sortable: true
        }, {
            header: $g("ʱ��"),
            dataIndex: 'oeDspTime',
            width: 100,
            align: 'left',
            sortable: true
        }
    ]);
    Cm.defaultSortable = false;

    // ����·��
    var DspPhaUrl = DictUrl +
        'locitmstkaction.csp?actiontype=GetReserveQtyInfo';

    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
        url: DspPhaUrl,
        method: "POST"
    });

    // ָ���в���
    var fields = ['incilRowId', 'pointer', 'patNo', 'patName', 'orderDept', 'prescNo', 'resQty', 'uomDesc', 'oeDspDate', 'oeDspTime'];

    // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: "results",
        id: "pointer",
        fields: fields
    });

    // ���ݼ�
    var ReserveQtyStore = new Ext.data.Store({
        proxy: proxy,
        reader: reader
    });

    var ReserveQtyPagingToolbar = new Ext.PagingToolbar({
        store: ReserveQtyStore,
        pageSize: 50,
        id: 'ReserveQtyPagingToolbar',
        displayInfo: true,
        displayMsg: $g('�� {0} ���� {1}�� ��һ�� {2} ��'),
        emptyMsg: $g("û�м�¼")
    });

    var ReserveQtyGrid = new Ext.grid.GridPanel({
        cm: Cm,
        store: ReserveQtyStore,
        trackMouseOver: true,
        stripeRows: true,
        sm: newSM,
        loadMask: true,
        tbar: [ClrResBT],
        bbar: ReserveQtyPagingToolbar
    });

    var window = new Ext.Window({
        title: $g('��;����ѯ'),
        width: document.body.clientWidth * 0.75,
        height: document.body.clientHeight * 0.9,
        layout: 'fit',
        items: [ReserveQtyGrid]
    });

    window.on('close', function (panel) {
        //Fn()
    });

    window.show();
    var strParams = (Incil != "") ? Incil : Inclb;
    ReserveQtyStore.setBaseParam("strParams", strParams);
    ReserveQtyStore.load({
        params: {
            start: 0,
            limit: 50
        }
    });


    function ClearResQty() {
        var selectlist = ReserveQtyGrid.getSelectionModel().getSelections();
        if (selectlist == "") {
            Msg.info("warning", $g("��ѡ������!"));
            return false;
        } else {
            Ext.MessageBox.confirm($g('��ʾ'), $g('ȷ��Ҫɾ����¼?'),
                function (btn) {
                    if (btn == 'yes') {
                        var pointeArr = []
                        var selectlength = selectlist.length;
                        for (var selecti = 0; selecti < selectlength; selecti++) {
                            var selectrecord = selectlist[selecti];
                            var pointer = selectrecord.data['pointer'];
                            if (pointeArr.indexOf(pointer) < 0) {
                                pointeArr.push(pointer);
                            }
                        }
                        var pointerStr = pointeArr.join("^");
                        if (pointerStr == "") {
                            Msg.info("warning", $g("û�п��������"));
                            return;
                        }
                        var ret = tkMakeServerCall("PHA.COM.Reserve", "ClrReserveByPointerMulti", pointerStr);
                        ReserveQtyStore.reload();
                    }
                }
            )
        }
    }
}