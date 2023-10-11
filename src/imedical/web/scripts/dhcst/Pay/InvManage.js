// /����: ��Ʊ����
// /��д�ߣ�gwj
// /��д����: 2012.09.18
var invURL="dhcst.invmanageaction.csp"
var gIncId="";
var bfparref=""
var gGroupId=session['LOGON.GROUPID'];
//var deptId = 0;
//var arr = window.status.split(":");
//var length = arr.length;

// �ɹ�����
var locField = new Ext.ux.LocComboBox({
	id:'locField',
	name:'locField',
	fieldLabel:$g('�ɹ�����'),
	//width:210,
	listWidth:210,
	groupId:gGroupId,
	anchor:'90%'

});

var INVNo = new Ext.form.TextField({
	fieldLabel : $g('��Ʊ��'),
	id : 'INVNo',
	name : 'INVNo',
	anchor : '90%'
	//,
	//width : 120
});

var SXNo = new Ext.form.TextField({
	fieldLabel : $g('���е���'),
	id : 'SXNo',
	name : 'SXNo',
	anchor : '90%'
	//,
	//width : 120
});

var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : $g('��Ӧ��'),
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	emptyText : $g('��Ӧ��...')
});
	
// ��ʼ����
var StartDate = new Ext.ux.DateField({
	fieldLabel : $g('��ʼ����'),
	id : 'StartDate',
	name : 'StartDate',
	anchor : '90%',
	width : 120,
	value : new Date().add(Date.DAY, - 30)
});

// ��ֹ����
var EndDate = new Ext.ux.DateField({
	fieldLabel : $g('��ֹ����'),
	id : 'EndDate',
	name : 'EndDate',
	anchor : '90%',
	//width : 120,
	value : new Date()
});

var InciDesc = new Ext.form.TextField({
	fieldLabel : $g('ҩƷ����'),
	id : 'InciDesc',
	name : 'InciDesc',
	anchor : '90%',
	//width : 140,
	listeners : {
		specialkey : function(field, e) {
			var keyCode=e.getKey();
			if ( keyCode== Ext.EventObject.ENTER) {
				GetPhaOrderInfo(field.getValue(),'');
			}
		}
	}
});
		/**
 * ����ҩƷ���岢���ؽ��
 */
function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",getDrugList);
	}
}

/**
 * ���ط���
 */
function getDrugList(record) {
	
	gIncId=""	;
	if (record == null || record == "") {
		gIncId="";	
		return;
	}
	gIncId = record.get("InciDr");
	var inciCode=record.get("InciCode");
	var inciDesc=record.get("InciDesc");
	Ext.getCmp("InciDesc").setValue(inciDesc);
}

// ��ѯ��ť
var SearchBT = new Ext.Toolbar.Button({
	text : $g('��ѯ'),
	tooltip : $g('�����ѯ'),
	width : 70,
	height : 30,
	iconCls : 'page_find',
	handler : function() {
		Query();
	}
});

// ��հ�ť
var ClearBT = new Ext.Toolbar.Button({
	text : $g('����'),
	tooltip : $g('�������'),
	width : 70,
	height : 30,
	iconCls : 'page_clearscreen',
	handler : function() {
		clearData();
	}
});
// ���水ť
var SaveBT = new Ext.Toolbar.Button({
	id : "SaveBT",
	text : $g('����'),
	tooltip : $g('�������'),
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		Save();
	}
});

/**
 * ��ѯ����
 */
function Query() {
	var phaLoc = Ext.getCmp("locField").getValue();
	if (phaLoc == null || phaLoc.length <= 0) {
		Msg.info("warning", $g("��ѡ��ɹ�����!"));
		return;
	}
	MasterStore.load();
	MasterStore.on('load',function(){
				if (MasterStore.getCount()>0){
		      MasterGrid.getSelectionModel().selectFirstRow();
		      MasterGrid.getView().focusRow(0);
	        }
				})
		
	
	DetailGrid.store.removeAll();
	DetailGrid.getView().refresh();
}



/**
 * ��շ���
 */
function clearData() {
	//Ext.getCmp("locField").setValue("");
	SetLogInDept(PhaDeptStore, "locField");
	Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 30));
    Ext.getCmp("EndDate").setValue(new Date());
	Ext.getCmp("Vendor").setValue("");
	Ext.getCmp("INVNo").setValue("");
	Ext.getCmp("SXNo").setValue("");
	Ext.getCmp("InciDesc").setValue("");
	MasterGrid.store.removeAll();
	MasterGrid.store.load({params:{start:0,limit:0}})
	MasterGrid.getView().refresh();
	DetailGrid.store.removeAll();
	DetailStore.setBaseParam('parref','')
	DetailGrid.store.load({params:{start:0,limit:0}})
	DetailGrid.getView().refresh();
	gIncId="";
    bfparref=""
	GridPagingToolbar.updateInfo();
	GridDetailPagingToolbar.updateInfo();
	
}


/**
 * ���淢Ʊ��Ϣ
 */
function Save() {
	var k=0
	var rowCount = DetailGrid.getStore().getCount();
	if(rowCount==0){Msg.info("warning",$g("�޿��ñ�������!"));return;}
	for (var i = 0; i < rowCount; i++) {
		//alert(12)
		var rowData = DetailStore.getAt(i);	
		//���������ݷ����仯ʱִ����������
         
		if(rowData.data.newRecord || rowData.dirty){
			//alert('save')
			var ingri=rowData.get("Ingri");
			var invNo = rowData.get("InvNo");
			var invAmt = rowData.get("InvAmt");
			var invDate = Ext.util.Format.date(rowData.get("InvDate"),App_StkDateFormat);
			var sxNo=rowData.get("SxNo");
			//alert(invURL+'?actiontype=updInv&InGrId='+ingri+'&invNo='+invNo+'&invAmt='+invAmt+'&invDate='+invDate+"&sxNo="+sxNo);
			Ext.Ajax.request({
				url: invURL+'?actiontype=updInv&InGrId='+ingri+'&invNo='+invNo+'&invAmt='+invAmt+'&invDate='+invDate+"&sxNo="+sxNo,
				method : 'POST',
				waitMsg : $g('������...'),
				failure: function(result,request) {
					Msg.info("error",$g("������������!"));
				},
				success: function(result,request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						//Msg.info("success","����ɹ�!");
						k=k+1
					}
					//======
					if(k==1)
					{Msg.info("success",$g("����ɹ�!"));}
					//========
				},
				scope: this
				
			});
		}
	}
	DetailStore.load({params:{start:0,limit:GridPagingToolbar.pageSize,parref:bfparref}});
}
		
function rendorPoFlag(value){
    return value=='Y'? $g('��'): $g('��');
}
function rendorCmpFlag(value){
    return value=='Y'? $g('���'): $g('δ���');
}


// ����·��
var MasterUrl = invURL	+ '?actiontype=query';
// ͨ��AJAX��ʽ���ú�̨����
var mProxy = new Ext.data.HttpProxy({
	url : MasterUrl,
	method : "POST"
});
		
// ָ���в���
var mFields = [{name:"RowId",mapping:'ingr'}, {name:"vendorName",mapping:'vendorName'},  
	{name:"phaLoc",mapping:'locDesc'}, {name:"IngrNo",mapping:'ingrNo'}, 
		{name:"CreateDate",mapping:'ingrDate'},{name:"CreateUser",mapping:'ingrUserName'}, 
			{name:"AuditDate",mapping:'auditDate'},{name:"AuditUser",mapping:'auditUserName'},{name:"rpAmt",mapping:'rpAmt'},
				{name:"payedAmt",mapping:'payedAmt'}, {name:"PayedFlag",mapping:'payOverFlag'}];

//var mFields =["ingr","vendorName","ingrNo","ingrDate","ingrUserName","auditDate","auditUserName","rpAmt","spAmt","payedAmt","payOverFlag"]

// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
var mReader = new Ext.data.JsonReader({
	root : 'rows',
	totalProperty : "results",
	id : "RowId",
	fields : mFields
});
// ���ݼ�
var MasterStore = new Ext.data.Store({
	proxy : mProxy,
	reader : mReader,
	remoteSort:true,
	listeners:
	{
		'beforeload':function(ds){
			var vendor = Ext.getCmp("Vendor").getValue();
			var startDate = Ext.getCmp("StartDate").getRawValue();
			var endDate = Ext.getCmp("EndDate").getRawValue();
			var invno = Ext.getCmp("INVNo").getValue();
			var sxno = Ext.getCmp("SXNo").getValue();
			
			if (Ext.getCmp('InciDesc').getValue()=='')
			{gIncId=''}
			else
			{}
			var inciid = gIncId  ;  //Ext.getCmp("InciDesc").getValue();
			
			var phaLoc=Ext.getCmp("locField").getValue();
			
			//����id^��ʼ����^��ֹ����^��Ӧ��id^��Ʊ��^���е���^ҩƷid
			var ListParam=phaLoc+'^'+startDate+'^'+endDate+'^'+vendor+'^'+invno+'^'+sxno+'^'+inciid;
			var Page=GridPagingToolbar.pageSize;
			//alert(ListParam);
			ds.baseParams={start:0, limit:Page,strParam:ListParam};
			
			
		
		}
	}
});



		
var MasterCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
	{
		header : "RowId",
		dataIndex : 'RowId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	},{
		header : $g("��Ӧ��"),
		dataIndex : 'vendorName',
		width : 240,
		align : 'left',
		sortable : true
	}, {
		header : $g("�ɹ�����"),
		dataIndex : 'phaLoc',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : $g("��ⵥ��"),
		dataIndex : 'IngrNo',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : $g("�Ƶ�����"),
		dataIndex : 'CreateDate',
		width : 90,
		align : 'center',
		sortable : true
	}, {
		header : $g("�Ƶ���"),
		dataIndex : 'CreateUser',
		width : 50,
		align : 'left',
		sortable : true
	}, {
		header : $g("�������"),
		dataIndex : 'AuditDate',
		width : 100,
		align : 'left',
		sortable : true
		//,
		//renderer:rendorPoFlag
	}, {
		header : $g("�����"),
		dataIndex : 'AuditUser',
		width : 100,
		align : 'left',
		sortable : true
		//,
		//renderer:rendorCmpFlag
	}, {
		header : $g("���۽��"),
		dataIndex : 'rpAmt',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : $g("�Ѹ����"),
		dataIndex : 'payedAmt',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : $g("�����־"),
		dataIndex : 'PayedFlag',
		width : 100,
		align : 'left',
		sortable : true
	}]);
	
MasterCm.defaultSortable = true;
var GridPagingToolbar = new Ext.PagingToolbar({
	store:MasterStore,
	pageSize:PageSize,
	displayInfo:true,
	displayMsg:$g('�� {0} ���� {1}�� ��һ�� {2} ��'),
	emptyMsg:$g("û�м�¼")
});

var MasterGrid = new Ext.grid.GridPanel({
	title : '',
	height : 170,
	cm : MasterCm,
	sm : new Ext.grid.RowSelectionModel({
				singleSelect : true
			}),
	store : MasterStore,
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	bbar:GridPagingToolbar
});

// ��ӱ�񵥻����¼�
MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
	var parref = MasterStore.getAt(rowIndex).get("RowId");
	bfparref=parref
	DetailStore.setBaseParam('parref',parref)
	DetailStore.load({params:{start:0,limit:GridPagingToolbar.pageSize}});
	
});

// ת����ϸ
// ����·��
var DetailUrl =  invURL	+ '?actiontype=queryItem';;;
// ͨ��AJAX��ʽ���ú�̨����
var dProxy = new Ext.data.HttpProxy({
	url : DetailUrl,
	method : "POST"
});
// ָ���в���
var dFields = ["Ingri", "IncId","IncCode","IncDesc", "Spec", "Manf", "BatchNo","ExpDate",{name:"Qty",mapping:'RecQty'},{name:"UomId",mapping:'IngrUomId'},
{name:"Uom",mapping:'IngrUom'}, "Rp", "Sp","RpAmt","SpAmt","InvNo", {name:'InvDate',type:'date',dateFormat:App_StkDateFormat}, {name:"InvAmt",mapping:'InvMoney'}, "SxNo"];
// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
var dReader = new Ext.data.JsonReader({
	root : 'rows',
	totalProperty : "results",
	id : "RowId",
	fields : dFields
});
// ���ݼ�
var DetailStore = new Ext.data.Store({
	proxy : dProxy,
	reader : dReader,
	remoteSort:true
});

var DetailCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
	{
		header : "Ingri",
		dataIndex : 'Ingri',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : $g("ҩƷId"),
		dataIndex : 'IncId',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : $g('ҩƷ����'),
		dataIndex : 'IncCode',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : $g('ҩƷ����'),
		dataIndex : 'IncDesc',
		width : 180,
		align : 'left',
		sortable : true
	}, {
		header : $g("���"),
		dataIndex : 'Spec',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : $g("����"),
		dataIndex : 'Manf',
		width : 150,
		align : 'left',
		sortable : true
	}, {
		header : $g("����"),
		dataIndex : 'BatchNo',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : $g("Ч��"),
		dataIndex : 'ExpDate',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : $g("�������"),
		dataIndex : 'Qty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : $g("��λ"),
		dataIndex : 'Uom',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : $g("����"),
		dataIndex : 'Rp',
		width : 60,
		align : 'right',
		
		sortable : true
	}, {
		header : $g("�ۼ�"),
		dataIndex : 'Sp',
		width : 60,
		align : 'right',
		
		sortable : true
	}, {
		header : $g("���۽��"),
		dataIndex : 'RpAmt',
		width : 100,
		align : 'right',
		
		sortable : true
	}, {
		header : $g("�ۼ۽��"),
		dataIndex : 'SpAmt',
		width : 100,
		align : 'right',
		
		sortable : true
	}, {
		header : $g("��Ʊ��"),
		dataIndex : 'InvNo',
		width : 80,
		align : 'center',
		sortable : true,
		editable:true,
		editor:new Ext.form.TextField({
			listeners:{
				'blur':function(field){
					var invNo=field.getValue();
					var IngrRecord=MasterGrid.getSelectionModel().getSelected();
					var Ingr=IngrRecord.get('RowId');
					var flag=InvNoValidator(invNo,Ingr);
					if(flag==false){
						Msg.info("warning",$g("��Ʊ��")+invNo+$g("������������ⵥ��!"));
						field.setValue("");
					}
				}
				
			}
		})
	}, {
		header : $g("��Ʊ����"),
		dataIndex : 'InvDate',
		width : 100,
		align : 'center',
		sortable : true,
		editable:true,
		renderer : Ext.util.Format.dateRenderer(App_StkDateFormat),
		editor:new Ext.ux.DateField({
		})
		
	}, {
		header : $g("��Ʊ���"),
		dataIndex : 'InvAmt',
		width : 100,
		align : 'right',
		sortable : true,
		editable:true,
		editor:new Ext.form.NumberField({
		})
	}, {
		header : $g("���е���"),
		dataIndex : 'SxNo',
		width : 80,
		align : 'center',
		sortable : true,
		editable:true,
		editor:new Ext.form.TextField({
		})
	}]);
var GridDetailPagingToolbar = new Ext.PagingToolbar({
	store:DetailStore,
	pageSize:PageSize,
	displayInfo:true,
	displayMsg:$g('�� {0} ���� {1}�� ��һ�� {2} ��'),
	emptyMsg:$g("û�м�¼")
});

var DetailGrid = new Ext.grid.EditorGridPanel({
	title : $g('��ⵥ��ϸ'),
	height : 200,
	cm : DetailCm,
	clicksToEdit:1,
	store : DetailStore,
	trackMouseOver : true,
	stripeRows : true,
	bbar:GridDetailPagingToolbar,
	loadMask : true
});

var HisListTab = new Ext.form.FormPanel({
	labelWidth : 60,
	labelAlign : 'right',
	frame : true,
	autoScroll : true,
	autoHeight: true,
	//bodyStyle : 'padding:5px;',
	tbar : [SearchBT, '-', ClearBT, '-', SaveBT],
	items:[{
		xtype:'fieldset',
		title:$g('��ѯ����'),
		layout:'column',
		autoHeight:true,
		style:DHCSTFormStyle.FrmPaddingV,
		items : [{ 		
			columnWidth: 0.34,
	    	xtype: 'fieldset',
	    	border: false,
	    	items: [locField,Vendor]
		
		},{ 				
			columnWidth: 0.22,
	    	xtype: 'fieldset',
	    	border: false,
	    	items: [StartDate,EndDate]
		
		},{ 				
			columnWidth: 0.22,
	    	xtype: 'fieldset',
	    	border: false,
	    	items: [INVNo,SXNo]
		
		},
		{ 				
			columnWidth: 0.22,
	    	xtype: 'fieldset',
	    	border: false,
	    	items: [InciDesc]
		
		}]
	}]
	
});
			
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var CtLocId = session['LOGON.CTLOCID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	GetGroupDeptStore.load();
	// ҳ�沼��
	var mainPanel = new Ext.Viewport({
		layout : 'border',
		items : [            // create instance immediately
            {
                title:$g('��Ʊ����'),
                region: 'north',
                height: DHCSTFormStyle.FrmHeight(2), // give north and south regions a height
                layout: 'fit', // specify layout manager for items
                items:HisListTab
            }, {
                region: 'center',
                title: $g('��ⵥ'),			               
                layout: 'fit', // specify layout manager for items
                items: MasterGrid       
               
            }, {
                region: 'south',
                split: true,
    			height: 300,
    			minSize: 200,
    			maxSize: 350,
    			//collapsible: true,
                //title: '��ⵥ��ϸ',
                layout: 'fit', // specify layout manager for items
                items: DetailGrid                     
            }
		],
		renderTo : 'mainPanel'
	});	
})