///描述: 付款单制单查询
///编写者：gwj
///编写日期: 2012.09.24
function PaySearch(Fn) {
	PayId="";
	var URL = "dhcst.payaction.csp"
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    Ext.Ajax.timeout = 900000;
    var VendorF = new Ext.ux.VendorComboBox({
        id: 'VendorF',
        name: 'VendorF',
        anchor: '90%'
    });

    // 起始日期
    var StartDateF = new Ext.ux.DateField({
        fieldLabel: $g('起始日期'),
        id: 'StartDateF',
        name: 'StartDateF',
        anchor: '90%',
        width: 120,
        value: new Date().add(Date.DAY, -30)
    });

    // 截止日期
    var EndDateF = new Ext.ux.DateField({
        fieldLabel: $g('截止日期'),
        id: 'EndDateF',
        name: 'EndDateF',
        anchor: '90%',
        width: 120,
        value: new Date()
    });
    
    // 全部
	var PayAllF = new Ext.form.Radio({ 
		id:'PayAllF',
		name:'PayFlagF',
		boxLabel:$g('全部')  
	});
	
	// 已完成
	var PayCompletedF = new Ext.form.Radio({ 
		id:'PayCompletedF',
		name:'PayFlagF',
		boxLabel:$g('已完成'  )
	});
	
	// 未完成
	var PayNoCompletedF = new Ext.form.Radio({ 
		id:'PayNoCompletedF',
		name:'PayFlagF',
		boxLabel:$g('未完成'),
		checked:true  
	});
	
    // 查询按钮
    var SearchBTF = new Ext.Toolbar.Button({
        text: $g('查询'),
        tooltip: $g('点击查询'),
        width: 70,
        height: 30,
        iconCls: 'page_find',
        handler: function() {
            Query();
        }
    });
    // 清空按钮
    var ClearBTF = new Ext.Toolbar.Button({
        text:$g( '清屏'),
        tooltip: $g('点击清屏'),
        width: 70,
        height: 30,
        iconCls: 'page_clearscreen',
        handler: function() {
            clearData();
        }
    });

    // 确定按钮
    var selectBTF = new Ext.Toolbar.Button({
        text: $g('选取'),
        tooltip:$g( '点击选取'),
        width: 70,
        height: 30,
        iconCls: 'page_goto',
        handler: function() {
            SelectPay();
        }
    });


    // 取消按钮
    var CancelBTF = new Ext.Toolbar.Button({
        text: $g('关闭'),
        tooltip: $g('点击退出本窗口'),
        width: 70,
        height: 30,
        iconCls: 'page_close',
        handler: function() {
            cancelFind();
        }
    });


    // 查询方法
    function Query() {
	    var payLocRowId=Ext.getCmp("PhaLoc").getValue();
        if (payLocRowId == null || payLocRowId.length <= 0) {
	        Msg.info("warning", $g("请选择采购科室!"))
            return;
        }
        MasterStoreF.removeAll();
        DetailStoreF.removeAll();
        MasterStoreF.load();
        MasterStoreF.on('load', function() {
            if (MasterStoreF.getCount() > 0) {
                MasterGridF.getSelectionModel().selectFirstRow();
                MasterGridF.focus();
                MasterGridF.getView().focusRow(0);
            }
        })
    }


    /**
     * 清空方法
     */
    function clearData() {
        Ext.getCmp("VendorF").setValue("");
        MasterGridF.store.removeAll();
        MasterGridF.getView().refresh();
        DetailGridF.store.removeAll();
        DetailGridF.getView().refresh();
    }
    
    function cancelFind() {
        findWindow.close();
    }

    //选定当前的付款单
    function SelectPay() {
		var rowRecord = MasterGridF.getSelectionModel().getSelected();
		if(rowRecord==undefined){
			PayId="";
			Msg.info("warning", $g("请选择付款单!"));
            return;
		}
		var PayId = rowRecord.data["pay"];
		payRowId=PayId;
		Fn(PayId);
		findWindow.close();
    }

    // 访问路径
    var MasterUrlF = URL + '?actiontype=query';


    // 通过AJAX方式调用后台数据
    var proxy = new Ext.data.HttpProxy({
        url: MasterUrlF,
        method: "POST"
    });
    // 指定列参数

    var fields = ["pay", "PurNo", "payNo", "locDesc", "vendorName", "payDate", "payTime", "payUserName", "payAmt",
        { name: 'ack1Flag', mapping: 'ack1' }, "ack1UserName", "ack1Date", { name: 'ack2Flag', mapping: 'ack2' }, "ack2UserName", "ack2Date", "payMode", "checkNo", "checkDate", "checkAmt", { name: "completed", mapping: 'payComp' }, "PoisonFlag"
    ];
    // 支持分页显示的读取方式
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: "results",
        id: "pay",
        fields: fields
    });

    // 数据集
    var MasterStoreF = new Ext.data.Store({
        proxy: proxy,
        reader: reader,
        remoteSort:true,
        listeners: {
            'beforeload': function(store) {
                var sd = Ext.getCmp('StartDateF').getRawValue();
                var ed = Ext.getCmp('EndDateF').getRawValue();
                var vendor = Ext.getCmp('VendorF').getValue();
                var completed;
                if (Ext.getCmp("PayAllF").getValue() == true) { completed = ''; }
                if (Ext.getCmp("PayCompletedF").getValue() == true) { completed = 'Y'; }
                if (Ext.getCmp("PayNoCompletedF").getValue() == true) { completed = 'N'; }
				var payLocRowId=Ext.getCmp("PhaLoc").getValue();
                var StrParam = sd + "^" + ed + "^" + payLocRowId + "^" + vendor + "^" + completed;
                var page = GridPagingToolbarF.pageSize;
                store.baseParams = { start: 0, limit: page, strParam: StrParam }
            }
        }
    });


    var nm = new Ext.grid.RowNumberer();
    var MasterCmF = new Ext.grid.ColumnModel([nm, {
            header: "RowId",
            dataIndex: 'pay',
            width: 100,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: $g("付款单号"),
            dataIndex: 'payNo',
            width: 120,
            align: 'left',
            sortable: true
        }, {
            header: $g("采购部门"),
            dataIndex: 'locDesc',
            width: 120,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: $g("经营企业"),
            dataIndex: 'vendorName',
            width: 230,
            align: 'left',
            sortable: true
        }, {
            header: $g("制单日期"),
            dataIndex: 'payDate',
            width: 90,
            align: 'center',
            sortable: true
        }, {
            header: $g("制单时间"),
            dataIndex: 'payTime',
            width: 90,
            align: 'center',
            sortable: true
        }, {
            header: $g("制单人"),
            dataIndex: 'payUserName',
            width: 90,
            align: 'left',
            sortable: true
        }, {
            header: $g("付款金额"),
            dataIndex: 'payAmt',
            width: 90,
            align: 'right',
            sortable: true
        }, {
            header: $g("是否采购确认"),
            dataIndex: 'ack1Flag',
            width: 100,
            align: 'center',
            sortable: true,
            renderer: function(v, p, record) {
                p.css += ' x-grid3-check-col-td';
                return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
            }
        }, {
            header: $g("采购确认人"),
            dataIndex: 'ack1UserName',
            width: 100,
            align: 'center',
            sortable: true

        }, {
            header: $g("采购确认日期"),
            dataIndex: 'ack1Date',
            width: 100,
            align: 'center',
            sortable: true
        }, {
            header: $g("是否会计确认"),
            dataIndex: 'ack2Flag',
            width: 100,
            align: 'center',
            sortable: true,
            renderer: function(v, p, record) {
                p.css += ' x-grid3-check-col-td';
                return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
            }

        }, {
            header: $g("会计确认人"),
            dataIndex: 'ack2UserName',
            width: 100,
            align: 'center',
            sortable: true
        }, {
            header: $g("会计确认日期"),
            dataIndex: 'ack2Date',
            width: 100,
            align: 'center',
            sortable: true
        }, {
            header: $g("毒麻标志"),
            dataIndex: 'PoisonFlag',
            width: 100,
            align: 'center',
            sortable: true,
            renderer: function(v, p, record) {
                p.css += ' x-grid3-check-col-td';
                return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
            }
        }, {
            header: $g("支付方式"),
            dataIndex: 'payMode',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: $g("支付票据号"),
            dataIndex: 'checkNo',
            width: 100,
            align: 'left',
            sortable: true

        }, {
            header: $g("支付票据日期"),
            dataIndex: 'checkDate',
            width: 100,
            align: 'center',
            sortable: true

        }, {
            header: $g("支付票据金额"),
            dataIndex: 'checkAmt',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: $g("完成标志"),
            dataIndex: 'completed',
            width: 60,
            align: 'center',
            renderer: function(v, p, record) {
                p.css += ' x-grid3-check-col-td';
                return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
            }
        }

    ]);

    MasterCmF.defaultSortable = true;
    var GridPagingToolbarF = new Ext.PagingToolbar({
        id: 'mGridPageingTBF',
        store: MasterStoreF,
        pageSize: PageSize,
        displayInfo: true,
        displayMsg: $g('显示第{0}到{1}条记录，一共{2}条'),
        emptyMsg: $g("没有记录")
    });

    var MasterGridF = new Ext.grid.GridPanel({
        cm: MasterCmF,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
        store: MasterStoreF,
        trackMouseOver: true,
        stripeRows: true,
        loadMask: true,
        bbar: [GridPagingToolbarF]
    });
    MasterGridF.on('rowdblclick', function(grid,rowIndex,e) {
	    SelectPay();
    })


    MasterGridF.getSelectionModel().on('rowselect', function(sm, rowIndex, rec) {
        DetailStoreF.removeAll();
        var PayId = MasterStoreF.getAt(rowIndex).get("pay");
        var psize = detailGridPagingToolbarF.pageSize;
        DetailStoreF.baseParams = { start: 0, limit: psize, parref: PayId }
        DetailStoreF.load();
    });
    // 访问路径
    var DetailUrlF = URL + '?actiontype=queryItem';

    // 通过AJAX方式调用后台数据
    var proxy = new Ext.data.HttpProxy({
        url: DetailUrlF,
        method: "POST"
    });
    // 指定列参数
    var fields = ["payi", "pointer", "TransType", "INCI", "inciCode", "inciDesc", "spec", "manf", "qty",
        "uomDesc", "rp", "sp", "rpAmt", "spAmt", "OverFlag", "invNo", "invDate", "invAmt", "batNo", "ExpDate"
    ];
    // 支持分页显示的读取方式
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: "results",
        id: "payi",
        fields: fields
    });
    // 数据集
    var DetailStoreF = new Ext.data.Store({
        proxy: proxy,
        reader: reader,
        remoteSort:true
    });
    var nm = new Ext.grid.RowNumberer();

    var DetailCmF = new Ext.grid.ColumnModel([nm, {
        header: "RowId",
        dataIndex: 'payi',
        width: 100,
        align: 'left',
        sortable: true,
        hidden: true
    }, {
        header: $g("入库退货Id"),
        dataIndex: 'pointer',
        width: 80,
        align: 'left',
        sortable: true,
        hidden: true
    }, {
        header: $g("药品Id"),
        dataIndex: 'INCI',
        width: 80,
        align: 'left',
        sortable: true,
        hidden: true
    }, {
        header: $g('药品代码'),
        dataIndex: 'inciCode',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g('药品名称'),
        dataIndex: 'inciDesc',
        width: 180,
        align: 'left',
        sortable: true
    }, {
        header: $g("规格"),
        dataIndex: 'spec',
        width: 180,
        align: 'left',
        sortable: true
    }, {
        header: $g("生产企业"),
        dataIndex: 'manf',
        width: 150,
        align: 'left',
        sortable: true
    }, {
        header: $g("数量"),
        dataIndex: 'qty',
        width: 80,
        align: 'right',
        sortable: true
    }, {
        header: $g("单位"),
        dataIndex: 'uomDesc',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g("进价"),
        dataIndex: 'rp',
        width: 60,
        align: 'right',

        sortable: true
    }, {
        header: $g("售价"),
        dataIndex: 'sp',
        width: 60,
        align: 'right',

        sortable: true
    }, {
        header: $g("进价金额"),
        dataIndex: 'rpAmt',
        width: 100,
        align: 'right',

        sortable: true
    }, {
        header: $g("售价金额"),
        dataIndex: 'spAmt',
        width: 100,
        align: 'right',

        sortable: true
    }, {
        header: $g("结清标志"),
        dataIndex: 'OverFlag',
        width: 80,
        align: 'center',
        sortable: true
    }, {
        header: $g("发票号"),
        dataIndex: 'invNo',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g("发票日期"),
        dataIndex: 'invDate',
        width: 100,
        align: 'center',
        sortable: true
    }, {
        header: $g("发票金额"),
        dataIndex: 'invAmt',
        width: 80,
        align: 'right',
        sortable: true
    }, {
        header: $g("批号"),
        dataIndex: 'batNo',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g("效期"),
        dataIndex: 'ExpDate',
        width: 100,
        align: 'center',
        sortable: true
    }, {
        header: $g("类型"),
        dataIndex: 'TransType',
        width: 100,
        align: 'center',
        sortable: true
    }]);


    var detailGridPagingToolbarF = new Ext.PagingToolbar({
        store: DetailStoreF,
        pageSize: PageSize,
        displayInfo: true,
        displayMsg: $g('显示第{0}到{1}条记录，一共{2}条'),
        emptyMsg: $g("没有记录")
    });

    var DetailGridF = new Ext.grid.GridPanel({
	    region:'south',
        cm: DetailCmF,
        store: DetailStoreF,
        trackMouseOver: true,
        stripeRows: true,
        loadMask: true,
        bbar: [detailGridPagingToolbarF]
    });

    var findListTab = new Ext.form.FormPanel({
        labelWidth: 60,
        labelAlign: 'right',
		region:"north",
        frame: true,
        //bodyStyle: 'padding:5px;',
        layout:'fit',
        tbar: [SearchBTF, '-', ClearBTF, '-', selectBTF, '-', CancelBTF],
        items : [{
			layout: 'column',    // Specifies that the items will now be arranged in columns
			xtype:'fieldset',
			title:$g('查询条件'),
			style:DHCSTFormStyle.FrmPaddingV,
			defaults: {border:false},    // Default config options for child items
			items:[{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',		            	
	        	defaultType: 'textfield',
	        	items: [StartDateF]
			},{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',		            	
	        	defaultType: 'textfield',
	        	items: [EndDateF]
			},{ 				
				columnWidth: 0.25,
	        	xtype: 'fieldset',		            	
	        	defaultType: 'textfield',
	        	items: [VendorF]
			},{ 				
				columnWidth: 0.1,
	        	xtype: 'fieldset',		            	
	        	defaultType: 'textfield',
	        	labelWidth: 10,
	        	items: [PayAllF]
			},{ 				
				columnWidth: 0.1,
	        	xtype: 'fieldset',		            	
	        	defaultType: 'textfield',
	        	labelWidth: 10,
	        	items: [PayCompletedF]
			},{ 				
				columnWidth: 0.1,
	        	xtype: 'fieldset',		            	
	        	defaultType: 'textfield',
	        	labelWidth: 10,
	        	items: [PayNoCompletedF]
			}]
		}]

    });
	
	var findWindow = new Ext.Window({
		title : $g('付款单查询'),
		width : document.body.clientWidth*0.9,
		height : document.body.clientHeight*0.99,
		layout : 'border',
		plain:true,
		modal:true,
		items:[
			{
	            region: 'north',
	            height: DHCSTFormStyle.FrmHeight(1)-28, // give north and south regions a height
	            layout: 'fit', // specify layout manager for items
	            items:findListTab
	        }, {
	            region: 'center',			               
	            layout: 'fit', // specify layout manager for items
	            items: MasterGridF       
	        }, {
	            region: 'south',		
	            height: document.body.clientHeight*0.99*0.4,	               
	            layout: 'fit', // specify layout manager for items
	            items: DetailGridF       
           
	        }
        ] 
	});
	findWindow.show();

}