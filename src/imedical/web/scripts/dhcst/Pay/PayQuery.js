
// /����: ����Ƶ�
// /��д�ߣ�gwj
// /��д����: 2012.09.24

var payRowId="";
var URL="dhcst.payaction.csp"
var gGroupId=session['LOGON.GROUPID'];

// ������
var PhaLoc = new Ext.ux.LocComboBox({
	fieldLabel : '�ɹ�����',
	id : 'PhaLoc',
	name : 'PhaLoc',
	anchor:'90%',
	width : 120,
	emptyText : '�ɹ�����...',
	groupId:gGroupId
});

// ��¼����Ĭ��ֵ
//SetLogInDept(GetGroupDeptStore, "PhaLoc");

// ��������
var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : '��Ӧ��',
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	emptyText : '��Ӧ��...'
});
			
// ��ʼ����
var StartDate = new Ext.ux.DateField({
	fieldLabel : '��ʼ����',
	id : 'StartDate',
	name : 'StartDate',
	anchor : '90%',
	value : new Date().add(Date.DAY, - 30)
});
// ��ֹ����
var EndDate = new Ext.ux.DateField({
	fieldLabel : '��ֹ����',
	id : 'EndDate',
	name : 'EndDate',
	anchor : '90%',
	value : new Date()
});
	
// ��ѯ��ť
var SearchBT = new Ext.Toolbar.Button({
	text : '��ѯ',
	tooltip : '�����ѯ',
	width : 70,
	height : 30,
	iconCls : 'page_find',
	handler : function() {
		Query();
	}
});
/**
 * ��ѯ����
 */
function Query() {
	var phaLoc = Ext.getCmp("PhaLoc").getValue();
	if (phaLoc == null || phaLoc.length <= 0) {
		Msg.info("warning", "��ѡ��ɹ�����!");
		return;
	}
	var vendor = Ext.getCmp("Vendor").getValue();
	var startDate = Ext.getCmp("StartDate").getRawValue();
	var endDate = Ext.getCmp("EndDate").getRawValue();
	
	
	//var purno = Ext.getCmp("PurNo").getValue();
	
	
	var CmpFlag = "Y";
	//��ʼ����^��ֹ����^����id^��Ӧ��id
	var ListParam=startDate+'^'+endDate+'^'+phaLoc+'^'+vendor;
	var Page=GridPagingToolbar.pageSize;
	//MasterStore.load({params:{start:0, limit:Page,strParam:ListParam}});
	MasterStore.load();
		MasterStore.on('load',function(){
				if (MasterStore.getCount()>0){
		      MasterGrid.getSelectionModel().selectFirstRow();
		      MasterGrid.getView().focusRow(0);
	        }
				})
	
	//DetailGrid.store.removeAll();
	//DetailGrid.getView().refresh();
}

// ��հ�ť
var ClearBT = new Ext.Toolbar.Button({
	text : '����',
	tooltip : '�������',
	width : 70,
	height : 30,
	iconCls : 'page_clearscreen',
	handler : function() {
		clearData();
	}
});

/**
 * ��շ���
 */
function clearData() {
	Ext.getCmp("PhaLoc").setValue("");
	Ext.getCmp("Vendor").setValue("");
	
	MasterGrid.store.removeAll();
	MasterGrid.store.load({params:{start:0,limit:0}})
	MasterGrid.getView().refresh();
	
	DetailGrid.store.removeAll();
	DetailGrid.store.load({params:{start:0,limit:0}})
	DetailGrid.getView().refresh();
}

// �ɹ�ȷ�ϰ�ť
var Ack1BT = new Ext.Toolbar.Button({
	id : "Ack1BT",
	text : '�ɹ�ȷ��',
	tooltip : '���ȷ��',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
		SetAck1();
	}
});
// ���ȷ�ϰ�ť
var Ack2BT = new Ext.Toolbar.Button({
	id : "Ack2BT",
	text : '���ȷ��',
	tooltip : '���ȷ��',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
		SetAck2();
	}
});
/**
 * �ɹ�ȷ�ϸ��
 */
function SetAck1() {
	var rec=MasterGrid.getSelectionModel().getSelected();
	if (rec==undefined) {return;}
	var PayId=rec.get('RowId');
	if (PayId=='')  {return; }
	
	var url = URL	+ "?actiontype=SetAck1&PayId=" + PayId ;
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '������...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON
					.decode(result.responseText);
			if (jsonData.success == 'true') {
				// ȷ�ϵ���
				Msg.info("success", "ȷ�ϳɹ�!");
				Query();
			} else {
				var Ret=jsonData.info;
				if(Ret==-2){
					Msg.info("error", "�˸��δ���!");
				}else if(Ret==-3){
					Msg.info("error", "�˸���Ѿ�ȷ��!");
				}else if(Ret==-1){
					Msg.info("error", "δ�ҵ��˸��!");
				}else{
					Msg.info("error", "ȷ��ʧ��:");
				}
			}
		},
		scope : this
	});
}	

function ExecuteAck2(rowid,paymodeInfo)
{
	var url = URL+ "?actiontype=SetAck2&PayId=" + rowid +"&PayInfo=" + paymodeInfo;		
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '������...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				// ȷ�ϵ���
				Msg.info("success", "ȷ�ϳɹ�!");
				Query();
			} else {
				var Ret=jsonData.info;
				if(Ret==-2){
					Msg.info("error", "�˸��δ���!");
				}else if(Ret==-3){
					Msg.info("error", "�˸���Ѿ�ȷ��!");
				}else if(Ret==-1){
					Msg.info("error", "δ�ҵ��˸��!");
				}else{
					Msg.info("error", "ȷ��ʧ��:"+Ret);
				}
			}
		},
		scope : this
	});

}


/**
 * ���ȷ�ϸ��
 */
function SetAck2() {
	var rowData=MasterGrid.getSelectionModel().getSelected();	
	if (rowData==undefined) {return;}
	payRowId=rowData.get('RowId');
	if (payRowId=='')  {return; }
	
	var IfAlReadyAck=tkMakeServerCall("web.DHCST.DHCPayQuery","GetPayInfo",payRowId).split("^")[1];
	if(IfAlReadyAck=="Y"){
		Msg.info("error", "�˸������Ѿ�ȷ��!");
		return;
	}
	
	if (payRowId!=""){
		 
		var vendorName= rowData.get("vendorName");
		var payNo= rowData.get("payNo");
		var payAmt= rowData.get("payAmt");
		var PayNoinfo=payNo+"^"+vendorName+"^"+payAmt;
		SetInfo(PayNoinfo);   //ȷ�ϸ�����Ϣ
	}
}	

// ����·��
var MasterUrl = URL	+ '?actiontype=query';
// ͨ��AJAX��ʽ���ú�̨����
var proxy = new Ext.data.HttpProxy({
	url : MasterUrl,
	method : "POST"
});
// ָ���в���
var fields = [{name:"RowId",mapping:'pay'}, "PurNo", "payNo", "locDesc", "vendorName","payDate", "payTime","payUserName","payAmt",
{name:"ack1Flag",mapping:'ack1'}, "ack1UserName","ack1Date", {name:"ack2Flag",mapping:'ack2'}, "ack2UserName","ack2Date","PoisonFlag","payMode","checkNo","checkDate","checkAmt",{name:"completed",mapping:'payComp'}];
// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
var mReader = new Ext.data.JsonReader({
	root : 'rows',
	totalProperty : "results",
	id : "RowId",
	fields : fields
});
// ���ݼ�
var MasterStore = new Ext.data.Store({
	proxy : proxy,
	reader : mReader,
	remoteSort:true,
	listeners:{					
		'beforeload':function(store){
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			var vendor = Ext.getCmp("Vendor").getValue();
			var startDate = Ext.getCmp("StartDate").getRawValue();
			var endDate = Ext.getCmp("EndDate").getRawValue();
	
			var completed="Y"  ;   //��ɱ�־="Y"
			var ListParam=startDate+'^'+endDate+'^'+phaLoc+'^'+vendor+'^'+completed;
				var Page=GridPagingToolbar.pageSize;
				MasterStore.baseParams={start:0, limit:Page,strParam:ListParam};
				
			//MasterStore.load({params:{}})
		}
	}
});
var nm = new Ext.grid.RowNumberer();
var MasterCm = new Ext.grid.ColumnModel([nm, {
		header : "RowId",
		dataIndex : 'RowId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "�����",
		dataIndex : 'payNo',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : "�ɹ�����",
		dataIndex : 'locDesc',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : "��Ӧ��",
		dataIndex : 'vendorName',
		width : 190,
		align : 'center',
		sortable : true,
		align:'left'
	}, {
		header : "�Ƶ�����",
		dataIndex : 'payDate',
		width : 90,
		align : 'left',
		sortable : true
	}, {
		header : "�Ƶ�ʱ��",
		dataIndex : 'payTime',
		width : 90,
		align : 'left',
		sortable : true
	}, {
		header : "�Ƶ���",
		dataIndex : 'payUserName',
		width : 90,
		align : 'left',
		sortable : true
	}, {
		header : "������",
		dataIndex : 'payAmt',
		width : 90,
		sortable : true,
		align:'right'
	},{
		header : "��ɱ�־",
		dataIndex : 'completed',
		width : 50,
		align : 'center'
		//,
		//xtype:'booleancolumn',
		//falseText:'��',
		//trueText:'��'
	}, {
		header : "�Ƿ�ɹ�ȷ��",
		dataIndex : 'ack1Flag',
		width : 100,
		align : 'center',
		sortable : true					
	}, {
		header : "�ɹ�ȷ����",
		dataIndex : 'ack1UserName',
		width : 100,
		align : 'left',
		sortable : true
		
	}, {
		header : "�ɹ�ȷ������",
		dataIndex : 'ack1Date',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "�Ƿ���ȷ��",
		dataIndex : 'ack2Flag',
		width : 100,
		align : 'center',
		sortable : true
		
	}, {
		header : "���ȷ����",
		dataIndex : 'ack2UserName',
		width : 100,
		align : 'left',
		sortable : true
		
	}, {
		header : "���ȷ������",
		dataIndex : 'ack2Date',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "�����־",
		dataIndex : 'PoisonFlag',
		width : 100,
		align : 'left',
		sortable : true
		
	}, {
		header : "֧����ʽ",
		dataIndex : 'payMode',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "֧��Ʊ�ݺ�",
		dataIndex : 'checkNo',
		width : 100,
		align : 'left',
		sortable : true
		
	}, {
		header : "֧��Ʊ������",
		dataIndex : 'checkDate',
		width : 100,
		align : 'left',
		sortable : true
		
	}, {
		header : "֧��Ʊ�ݽ��",
		dataIndex : 'checkAmt',
		width : 100,
		align : 'left',
		sortable : true,
		align:'right'
	}
]);
	
MasterCm.defaultSortable = true;
var GridPagingToolbar = new Ext.PagingToolbar({
	store:MasterStore,
	pageSize:PageSize,
	displayInfo:true,
	displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
	emptyMsg:"û�м�¼"
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
	var PayId = MasterStore.getAt(rowIndex).get("RowId");
	//alert(PayId);
	DetailStore.setBaseParam('parref',PayId)
	DetailStore.load({params:{start:0,limit:GridDetailPagingToolbar.pageSize}});
});

// ת����ϸ
// ����·��
var DetailUrl =  URL
			+ '?actiontype=queryItem';;;
// ͨ��AJAX��ʽ���ú�̨����
var proxy = new Ext.data.HttpProxy({
	url : DetailUrl,
	method : "POST"
});
// ָ���в���
var fields = ["RowId", "pointer","TransType","INCI","inciCode","inciDesc", "spec", "manf", "qty",
		 "uomDesc", "rp", "sp","rpAmt","spAmt","OverFlag", "invNo", "invDate", "invAmt","batNo", "ExpDate"];
// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
var reader = new Ext.data.JsonReader({
	root : 'rows',
	totalProperty : "results",
	id : "RowId",
	fields : fields
});
// ���ݼ�
var DetailStore = new Ext.data.Store({
	proxy : proxy,
	reader : reader,
	remoteSort:true
});
var nm = new Ext.grid.RowNumberer();
var DetailCm = new Ext.grid.ColumnModel([nm, {
		header : "RowId",
		dataIndex : 'RowId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "����˻�Id",
		dataIndex : 'pointer',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "ҩƷId",
		dataIndex : 'INCI',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : 'ҩƷ����',
		dataIndex : 'inciCode',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : 'ҩƷ����',
		dataIndex : 'inciDesc',
		width : 180,
		align : 'left',
		sortable : true
	}, {
		header : "���",
		dataIndex : 'spec',
		width : 180,
		align : 'left',
		sortable : true
	}, {
		header : "����",
		dataIndex : 'manf',
		width : 150,
		align : 'left',
		sortable : true
	}, {
		header : "����",
		dataIndex : 'qty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "��λ",
		dataIndex : 'uomDesc',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : "����",
		dataIndex : 'rp',
		width : 60,
		align : 'right',
		
		sortable : true
	}, {
		header : "�ۼ�",
		dataIndex : 'sp',
		width : 60,
		align : 'right',
		
		sortable : true
	}, {
		header : "���۽��",
		dataIndex : 'rpAmt',
		width : 100,
		align : 'right',
		
		sortable : true
	}, {
		header : "�ۼ۽��",
		dataIndex : 'spAmt',
		width : 100,
		align : 'right',
		
		sortable : true
	}, {
		header : "�����־",
		dataIndex : 'OverFlag',
		width : 80,
		align : 'center',
		sortable : true
	}, {
		header : "��Ʊ��",
		dataIndex : 'invNo',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "��Ʊ����",
		dataIndex : 'invDate',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "��Ʊ���",
		dataIndex : 'invAmt',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "����",
		dataIndex : 'batNo',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : "Ч��",
		dataIndex : 'ExpDate',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "����",
		dataIndex : 'TransType',
		width : 100,
		align : 'left',
		sortable : true
	}]);
var GridDetailPagingToolbar = new Ext.PagingToolbar({
	store:DetailStore,
	pageSize:PageSize,
	displayInfo:true,
	displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
	emptyMsg:"û�м�¼"
});
var DetailGrid = new Ext.grid.GridPanel({
	title : '',
	height : 200,
	cm : DetailCm,
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
	tbar : [SearchBT, '-', ClearBT, '-', Ack1BT, '-', Ack2BT],
	items:[{
		xtype:'fieldset',
		title:'��ѯ����',
		layout:'column',
		style:DHCSTFormStyle.FrmPaddingV,
		items : [{ 				
				columnWidth: 0.25,
				layout:'form',
				items: [PhaLoc]			
			},{ 				
				columnWidth: 0.35,
				layout:'form',
				items: [Vendor]
			},{ 				
				columnWidth: 0.2,
				layout:'form',
				items: [StartDate]				
			},{ 				
				columnWidth: 0.2,
				layout:'form',
				items: [EndDate]
			}]	
	}]
	  // Specifies that the items will now be arranged in columns
});				
	
//===========ģ����ҳ��=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	// ҳ�沼��
	var mainPanel = new Ext.Viewport({
		layout : 'border',
		items : [            // create instance immediately
			{   
				title: '�������',		
				region: 'north',
				height: DHCSTFormStyle.FrmHeight(1), // give north and south regions a height
				layout: 'fit', // specify layout manager for items
				items:HisListTab
			}, {
				region: 'center',
				title: '���',			               
				layout: 'fit', // specify layout manager for items
				items: MasterGrid       
			   
			}, {
				region: 'south',
				split: true,
				height: 300,
				minSize: 200,
				maxSize: 350,
				collapsible: true,
				title: '�����ϸ',
				layout: 'fit', // specify layout manager for items
				items: DetailGrid       
			   
			}
		],
		renderTo : 'mainPanel'
	});
});
//===========ģ����ҳ��=============================================