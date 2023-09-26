// /名称: 在途数量信息查询
// /描述: 在途数量信息查询
// /编写者：yunhaibao
// /编写日期: 2012.08.17

/**
 * @StrParams:统一价传科室库存项ID,批次价传批次ID
 * @IncInfo:
 * @fn
 */
function ReserveQtyQuery(Incil, Inclb, IncInfo, Fn) {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    // 查询按钮
    var ClrResBT = new Ext.Toolbar.Button({
        text: '清除在途数',
        tooltip: '点击清除选中的在途',
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
            header: "科室库存项ID",
            dataIndex: 'incilRowId',
            width: 80,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: "指针",
            dataIndex: 'pointer',
            width: 80,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: '登记号',
            dataIndex: 'patNo',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: '姓名',
            dataIndex: 'patName',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: '医嘱科室',
            dataIndex: 'orderDept',
            width: 200,
            align: 'left',
            sortable: true
        }, {
            header: '处方号',
            dataIndex: 'prescNo',
            width: 125,
            align: 'left',
            sortable: true
        }, {
            header: "剩余在途数",
            dataIndex: 'resQty',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: "单位",
            dataIndex: 'uomDesc',
            width: 90,
            align: 'left',
            sortable: true
        }, {
            header: '日期',
            dataIndex: 'oeDspDate',
            width: 100,
            align: 'right',
            sortable: true
        }, {
            header: "时间",
            dataIndex: 'oeDspTime',
            width: 100,
            align: 'left',
            sortable: true
        }
    ]);
    Cm.defaultSortable = false;

    // 访问路径
    var DspPhaUrl = DictUrl +
        'locitmstkaction.csp?actiontype=GetReserveQtyInfo';

    // 通过AJAX方式调用后台数据
    var proxy = new Ext.data.HttpProxy({
        url: DspPhaUrl,
        method: "POST"
    });

    // 指定列参数
    var fields = ['incilRowId', 'pointer', 'patNo', 'patName', 'orderDept', 'prescNo', 'resQty', 'uomDesc', 'oeDspDate', 'oeDspTime'];

    // 支持分页显示的读取方式
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: "results",
        id: "pointer",
        fields: fields
    });

    // 数据集
    var ReserveQtyStore = new Ext.data.Store({
        proxy: proxy,
        reader: reader
    });

    var ReserveQtyPagingToolbar = new Ext.PagingToolbar({
        store: ReserveQtyStore,
        pageSize: 50,
        id: 'ReserveQtyPagingToolbar',
        displayInfo: true,
        displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
        emptyMsg: "没有记录"
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
        title: '在途数查询',
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
            Msg.info("warning", "请选择数据!");
            return false;
        } else {
            Ext.MessageBox.confirm('提示', '确定要删除记录?',
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
                            Msg.info("warning", "没有可清除数据");
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