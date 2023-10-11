///����: ����Ƶ���ѯ
///��д�ߣ�gwj
///��д����: 2012.09.24
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

    // ��ʼ����
    var StartDateF = new Ext.ux.DateField({
        fieldLabel: $g('��ʼ����'),
        id: 'StartDateF',
        name: 'StartDateF',
        anchor: '90%',
        width: 120,
        value: new Date().add(Date.DAY, -30)
    });

    // ��ֹ����
    var EndDateF = new Ext.ux.DateField({
        fieldLabel: $g('��ֹ����'),
        id: 'EndDateF',
        name: 'EndDateF',
        anchor: '90%',
        width: 120,
        value: new Date()
    });
    
    // ȫ��
	var PayAllF = new Ext.form.Radio({ 
		id:'PayAllF',
		name:'PayFlagF',
		boxLabel:$g('ȫ��')  
	});
	
	// �����
	var PayCompletedF = new Ext.form.Radio({ 
		id:'PayCompletedF',
		name:'PayFlagF',
		boxLabel:$g('�����'  )
	});
	
	// δ���
	var PayNoCompletedF = new Ext.form.Radio({ 
		id:'PayNoCompletedF',
		name:'PayFlagF',
		boxLabel:$g('δ���'),
		checked:true  
	});
	
    // ��ѯ��ť
    var SearchBTF = new Ext.Toolbar.Button({
        text: $g('��ѯ'),
        tooltip: $g('�����ѯ'),
        width: 70,
        height: 30,
        iconCls: 'page_find',
        handler: function() {
            Query();
        }
    });
    // ��հ�ť
    var ClearBTF = new Ext.Toolbar.Button({
        text:$g( '����'),
        tooltip: $g('�������'),
        width: 70,
        height: 30,
        iconCls: 'page_clearscreen',
        handler: function() {
            clearData();
        }
    });

    // ȷ����ť
    var selectBTF = new Ext.Toolbar.Button({
        text: $g('ѡȡ'),
        tooltip:$g( '���ѡȡ'),
        width: 70,
        height: 30,
        iconCls: 'page_goto',
        handler: function() {
            SelectPay();
        }
    });


    // ȡ����ť
    var CancelBTF = new Ext.Toolbar.Button({
        text: $g('�ر�'),
        tooltip: $g('����˳�������'),
        width: 70,
        height: 30,
        iconCls: 'page_close',
        handler: function() {
            cancelFind();
        }
    });


    // ��ѯ����
    function Query() {
	    var payLocRowId=Ext.getCmp("PhaLoc").getValue();
        if (payLocRowId == null || payLocRowId.length <= 0) {
	        Msg.info("warning", $g("��ѡ��ɹ�����!"))
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
     * ��շ���
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

    //ѡ����ǰ�ĸ��
    function SelectPay() {
		var rowRecord = MasterGridF.getSelectionModel().getSelected();
		if(rowRecord==undefined){
			PayId="";
			Msg.info("warning", $g("��ѡ�񸶿!"));
            return;
		}
		var PayId = rowRecord.data["pay"];
		payRowId=PayId;
		Fn(PayId);
		findWindow.close();
    }

    // ����·��
    var MasterUrlF = URL + '?actiontype=query';


    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
        url: MasterUrlF,
        method: "POST"
    });
    // ָ���в���

    var fields = ["pay", "PurNo", "payNo", "locDesc", "vendorName", "payDate", "payTime", "payUserName", "payAmt",
        { name: 'ack1Flag', mapping: 'ack1' }, "ack1UserName", "ack1Date", { name: 'ack2Flag', mapping: 'ack2' }, "ack2UserName", "ack2Date", "payMode", "checkNo", "checkDate", "checkAmt", { name: "completed", mapping: 'payComp' }, "PoisonFlag"
    ];
    // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: "results",
        id: "pay",
        fields: fields
    });

    // ���ݼ�
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
            header: $g("�����"),
            dataIndex: 'payNo',
            width: 120,
            align: 'left',
            sortable: true
        }, {
            header: $g("�ɹ�����"),
            dataIndex: 'locDesc',
            width: 120,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: $g("��Ӫ��ҵ"),
            dataIndex: 'vendorName',
            width: 230,
            align: 'left',
            sortable: true
        }, {
            header: $g("�Ƶ�����"),
            dataIndex: 'payDate',
            width: 90,
            align: 'center',
            sortable: true
        }, {
            header: $g("�Ƶ�ʱ��"),
            dataIndex: 'payTime',
            width: 90,
            align: 'center',
            sortable: true
        }, {
            header: $g("�Ƶ���"),
            dataIndex: 'payUserName',
            width: 90,
            align: 'left',
            sortable: true
        }, {
            header: $g("������"),
            dataIndex: 'payAmt',
            width: 90,
            align: 'right',
            sortable: true
        }, {
            header: $g("�Ƿ�ɹ�ȷ��"),
            dataIndex: 'ack1Flag',
            width: 100,
            align: 'center',
            sortable: true,
            renderer: function(v, p, record) {
                p.css += ' x-grid3-check-col-td';
                return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
            }
        }, {
            header: $g("�ɹ�ȷ����"),
            dataIndex: 'ack1UserName',
            width: 100,
            align: 'center',
            sortable: true

        }, {
            header: $g("�ɹ�ȷ������"),
            dataIndex: 'ack1Date',
            width: 100,
            align: 'center',
            sortable: true
        }, {
            header: $g("�Ƿ���ȷ��"),
            dataIndex: 'ack2Flag',
            width: 100,
            align: 'center',
            sortable: true,
            renderer: function(v, p, record) {
                p.css += ' x-grid3-check-col-td';
                return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
            }

        }, {
            header: $g("���ȷ����"),
            dataIndex: 'ack2UserName',
            width: 100,
            align: 'center',
            sortable: true
        }, {
            header: $g("���ȷ������"),
            dataIndex: 'ack2Date',
            width: 100,
            align: 'center',
            sortable: true
        }, {
            header: $g("�����־"),
            dataIndex: 'PoisonFlag',
            width: 100,
            align: 'center',
            sortable: true,
            renderer: function(v, p, record) {
                p.css += ' x-grid3-check-col-td';
                return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
            }
        }, {
            header: $g("֧����ʽ"),
            dataIndex: 'payMode',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: $g("֧��Ʊ�ݺ�"),
            dataIndex: 'checkNo',
            width: 100,
            align: 'left',
            sortable: true

        }, {
            header: $g("֧��Ʊ������"),
            dataIndex: 'checkDate',
            width: 100,
            align: 'center',
            sortable: true

        }, {
            header: $g("֧��Ʊ�ݽ��"),
            dataIndex: 'checkAmt',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: $g("��ɱ�־"),
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
        displayMsg: $g('��ʾ��{0}��{1}����¼��һ��{2}��'),
        emptyMsg: $g("û�м�¼")
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
    // ����·��
    var DetailUrlF = URL + '?actiontype=queryItem';

    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
        url: DetailUrlF,
        method: "POST"
    });
    // ָ���в���
    var fields = ["payi", "pointer", "TransType", "INCI", "inciCode", "inciDesc", "spec", "manf", "qty",
        "uomDesc", "rp", "sp", "rpAmt", "spAmt", "OverFlag", "invNo", "invDate", "invAmt", "batNo", "ExpDate"
    ];
    // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: "results",
        id: "payi",
        fields: fields
    });
    // ���ݼ�
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
        header: $g("����˻�Id"),
        dataIndex: 'pointer',
        width: 80,
        align: 'left',
        sortable: true,
        hidden: true
    }, {
        header: $g("ҩƷId"),
        dataIndex: 'INCI',
        width: 80,
        align: 'left',
        sortable: true,
        hidden: true
    }, {
        header: $g('ҩƷ����'),
        dataIndex: 'inciCode',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g('ҩƷ����'),
        dataIndex: 'inciDesc',
        width: 180,
        align: 'left',
        sortable: true
    }, {
        header: $g("���"),
        dataIndex: 'spec',
        width: 180,
        align: 'left',
        sortable: true
    }, {
        header: $g("������ҵ"),
        dataIndex: 'manf',
        width: 150,
        align: 'left',
        sortable: true
    }, {
        header: $g("����"),
        dataIndex: 'qty',
        width: 80,
        align: 'right',
        sortable: true
    }, {
        header: $g("��λ"),
        dataIndex: 'uomDesc',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g("����"),
        dataIndex: 'rp',
        width: 60,
        align: 'right',

        sortable: true
    }, {
        header: $g("�ۼ�"),
        dataIndex: 'sp',
        width: 60,
        align: 'right',

        sortable: true
    }, {
        header: $g("���۽��"),
        dataIndex: 'rpAmt',
        width: 100,
        align: 'right',

        sortable: true
    }, {
        header: $g("�ۼ۽��"),
        dataIndex: 'spAmt',
        width: 100,
        align: 'right',

        sortable: true
    }, {
        header: $g("�����־"),
        dataIndex: 'OverFlag',
        width: 80,
        align: 'center',
        sortable: true
    }, {
        header: $g("��Ʊ��"),
        dataIndex: 'invNo',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g("��Ʊ����"),
        dataIndex: 'invDate',
        width: 100,
        align: 'center',
        sortable: true
    }, {
        header: $g("��Ʊ���"),
        dataIndex: 'invAmt',
        width: 80,
        align: 'right',
        sortable: true
    }, {
        header: $g("����"),
        dataIndex: 'batNo',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g("Ч��"),
        dataIndex: 'ExpDate',
        width: 100,
        align: 'center',
        sortable: true
    }, {
        header: $g("����"),
        dataIndex: 'TransType',
        width: 100,
        align: 'center',
        sortable: true
    }]);


    var detailGridPagingToolbarF = new Ext.PagingToolbar({
        store: DetailStoreF,
        pageSize: PageSize,
        displayInfo: true,
        displayMsg: $g('��ʾ��{0}��{1}����¼��һ��{2}��'),
        emptyMsg: $g("û�м�¼")
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
			title:$g('��ѯ����'),
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
		title : $g('�����ѯ'),
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