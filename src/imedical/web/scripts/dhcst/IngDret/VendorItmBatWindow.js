// /����: ѡҩƷ����Ӧ���δ���
// /����: ѡҩƷ����Ӧ����
// /��д�ߣ�zhangdongmei
// /��д����: 2013.01.22

/**
 Input:ҩƷ����¼��ֵ
 StkGrpRowId������id
 StkGrpType���������ͣ�G��ҩƷ
 Locdr:����id
 NotUseFlag�������ñ�־
 QtyFlag���Ƿ����0�����Ŀ
 HospID��ҽԺid
 ReqLoc:�������id(�������idΪ��ʱ��������ҿ����ʾΪ��)
 Fn���ص�����
 */
var RetVendorRowId='';
var RetURL = 'dhcst.ingdretaction.csp';

VendorItmBatWindow =function(Input, StkGrpRowId, StkGrpType, Locdr, Vendor,VendorName,NotUseFlag,
		QtyFlag, HospID, ReqLoc,Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var flg = false;

	// �滻�����ַ�
	while (Input.indexOf("*") >= 0) {
		Input = Input.substring(0,Input.indexOf("*"));
	}
	
	/*ҩƷ����------------------------------*/
	var PhaOrderUrl = 'dhcst.drugutil.csp?actiontype=GetPhaOrderItemForDialog&Input='
			+ encodeURI(Input) + '&StkGrpRowId=' + StkGrpRowId + '&StkGrpType='
			+ StkGrpType + '&Locdr=' + Locdr + '&NotUseFlag=' + NotUseFlag
			+ '&QtyFlag=' + QtyFlag + '&HospID=' + HospID + '&start=' + 0
			+ '&limit=' + 15;

	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : PhaOrderUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["InciDr", "InciItem", "InciCode", "InciDesc", "Spec",
			"ManfName", "PuomDesc", "pRp", "pSp", "PuomQty", "BuomDesc", "bRp",
			"bSp", "BuomQty", "BillUomDesc", "BillSp", "BillRp", "BillUomQty",
			"PhcFormDesc", "GoodName", "GeneName", {name:'NotUseFlag',type: 'bool'}, "PuomDr",
			"PFac", "Manfdr", "MaxQty", "MinQty", "StockQty", "Remark"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "InciItem",
		fields : fields
	});
	// ���ݼ�
	var PhaOrderStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader
	});
	
	var StatuTabPagingToolbar = new Ext.PagingToolbar({
		store : PhaOrderStore,
		pageSize : 15,
		displayInfo : true,
		displayMsg : '��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
		prevText : "��һҳ",
		nextText : "��һҳ",
		refreshText : "ˢ��",
		lastText : "���ҳ",
		firstText : "��һҳ",
		beforePageText : "��ǰҳ",
		afterPageText : "��{0}ҳ",
		emptyMsg : "û������"
	});

	var nm = new Ext.grid.RowNumberer();
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect:true,
				listeners:{
					'rowselect':function(selmod,rowindex,record){
							queryIngri();
							
							var inci=record.get("InciDr");
							var loc=Locdr;
							var zeroFlag='0';
							var strPar=inci+"^"+loc+"^"+zeroFlag;
							VendorForIncItmStore.setBaseParam('strPar',strPar);
							VendorForIncItmStore.load();
							//var record=PhaOrderGrid.getStore().getAt(rowindex);
							//var incid=record.get("InciDr");
							//var pagesize=StatuTabPagingToolbar.pageSize;
							//var strParm='';
							//VendorRecItmStore.setBaseParam('strParm',strParm)
							//VendorRecItmStore.load({params:{start:0,limit:pagesize}});
					}
				}
			});
	// the check column is created using a custom plugin
	var ColumnNotUseFlag = new Ext.grid.CheckColumn({
   		header: '������',
   		dataIndex: 'NotUseFlag',
   		width: 45,
   		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	});
	var PhaOrderCm = new Ext.grid.ColumnModel([nm, sm, {
				header : "����",
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '����',
				dataIndex : 'InciDesc',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : "���",
				dataIndex : 'Spec',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "������ҵ",
				dataIndex : 'ManfName',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : '��ⵥλ',
				dataIndex : 'PuomDesc',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : "�ۼ�(��ⵥλ)",
				dataIndex : 'pSp',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "����(��ⵥλ)",
				dataIndex : 'PuomQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "������λ",
				dataIndex : 'BuomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "�ۼ�(������λ)",
				dataIndex : 'bSp',
				width : 100,
				align : 'right',
			
				sortable : true
			}, {
				header : "����(������λ)",
				dataIndex : 'BuomQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "�Ƽ۵�λ",
				dataIndex : 'BillUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "�ۼ�(�Ƽ۵�λ)",
				dataIndex : 'BillSp',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "����(�Ƽ۵�λ)",
				dataIndex : 'BillUomQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'PhcFormDesc',
				width : 60,
				align : 'left',
				sortable : true
			}, {
				header : "��Ʒ��",
				dataIndex : 'GoodName',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "����ͨ����",
				dataIndex : 'GeneName',
				width : 80,
				align : 'left',
				sortable : true
			}, ColumnNotUseFlag]);
	PhaOrderCm.defaultSortable = true;
	
	var PhaOrderGrid = new Ext.grid.GridPanel({
		cm : PhaOrderCm,
		store : PhaOrderStore,
		trackMouseOver : true,
		stripeRows : true,
		sm : sm,			
		loadMask : true,
		bbar : StatuTabPagingToolbar,
		deferRowRender : false
	});

	PhaOrderStore.load({
		callback : function(r, options, success) {
			if (success == false) {
                Msg.info('warning','û���κμ�¼��');
			 	if(window){window.focus();}
			} else {
				PhaOrderGrid.getSelectionModel().selectFirstRow();// ѡ�е�һ�в���ý���
				row = PhaOrderGrid.getView().getRow(0);
				if(row){
				var element = Ext.get(row);
				if (typeof(element) != "undefined" && element != null) {
					element.focus();
					PhaOrderGrid.getView().focusRow(0);
					}
				}
			}
		}
	});
	
	// �س��¼�
	PhaOrderGrid.on('keydown', function(e) {
		if (e.getKey() == Ext.EventObject.ENTER) {
			VendorRecItmGrid.getSelectionModel().selectFirstRow();// ѡ�е�һ�в���ý���
			row = VendorRecItmGrid.getView().getRow(0);
			if (row){
				var element = Ext.get(row);
				if (typeof(element) != "undefined" && element != null) {
					element.focus();
					VendorRecItmGrid.getView().focusRow(0);
				}	
			}
		}
	}); 
	
	//�����Ŀ�ľ�Ӫ��ҵ�б� Store
	var VendorForIncItmStore = new Ext.data.JsonStore({
		autoDestroy: true,
		url:RetURL	+ '?actiontype=selectVendor',
		root : 'rows',
		totalProperty : "results",	
		fields :  [{name:"RowId",mapping:'vendor'},{name:"Description",mapping:'vendorName'}],
		baseParams:{
			strPar:''
		}
	});	
	
	
	//���ҿ����Ŀ�ľ�Ӫ��ҵ����¼
	var VendorRecItmStore = new Ext.data.Store({
		autoDestroy: true,
		url:RetURL	+ '?actiontype=selectBatch',
		reader: new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results" ,
			id:'INGRI',
			fields:["code","desc","mnf","batch","expdate","recqty","uom","uomDesc","stkqty","INGRI","pp","sven","idate","rp","sp","INCLB","iniflag","Drugform","invNo","invDate","invAmt","venid","buom","confac","CurRp","CurSp","InsuCode","InsuDesc"]
		})	
	});	
	
	var IngriToolBar = new Ext.PagingToolbar({
		store : VendorRecItmStore,
		pageSize : 15,
		displayInfo : true,
		displayMsg : '��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
		prevText : "��һҳ",
		nextText : "��һҳ",
		refreshText : "ˢ��",
		lastText : "���ҳ",
		firstText : "��һҳ",
		beforePageText : "��ǰҳ",
		afterPageText : "��{0}ҳ",
		emptyMsg : "û������"
	});

	var nm2 = new Ext.grid.RowNumberer();
	var sm2 = new Ext.grid.CheckboxSelectionModel({singleSelect:true});

	var VendorRecItmCm=new Ext.grid.ColumnModel([nm2, sm2,{
		header : "�������",
		dataIndex : 'idate',
		width : 100,
		align : ''
	},{
		header : "����",
		dataIndex : 'code',
		width : 100,
		align : '',
		hidden:true
	},{	
		header : "����",
		dataIndex : 'desc',
		width : 100,
		align : '',
		hidden:true
	},{
		header : "������ҵ",
		dataIndex : 'mnf',
		width : 100,
		align : ''
	},{
		header : "����",
		dataIndex : 'batch',
		width : 100,
		align : ''
	},{
		header : "Ч��",
		dataIndex : 'expdate',
		width : 100,
		align : ''
	},{
		header : "�����",
		dataIndex : 'recqty',
		width : 100,
		align : 'right'
	},{
		header : "��λrowid",
		dataIndex : 'uom',
		width : 100,
		align : '',
		hidden : true
	},{
		header : "��λ",
		dataIndex : 'uomDesc',
		width : 100,
		align : ''
	},{
		header : "�����",
		dataIndex : 'stkqty',
		width : 100,
		align : 'right'
	},{
		header : "�����ϸrowid",
		dataIndex : 'INGRI',
		width : 100,
		align : 'right',
		hidden : true
	},{
		header : "����",
		dataIndex : 'pp',
		width : 100,
		align : 'right',
		hidden: true
	},{
		header : "��Ӫ��ҵ����",
		dataIndex : 'sven',
		width : 100,
		align : '',
		hidden:true
	},{
		header : "������",
		dataIndex : 'rp',
		width : 100,
		align : 'right'
	},{
		header : "��ǰ����",
		dataIndex : 'CurRp',
		width : 100,
		align : 'right',
		renderer:RpRenderer
	},{
		header : "����ۼ�",
		dataIndex : 'sp',
		width : 100,
		align : 'right'
	},{
		header : "��ǰ�ۼ�",
		dataIndex : 'CurSp',
		width : 100,
		align : 'right',
		renderer:SpRenderer
	},{
		header : "����rowid",
		dataIndex : 'INCLB',
		width : 100,
		align : '',
		hidden : true
	},{
		header : "��ʼ����־",
		dataIndex : 'iniflag',
		width : 100,
		align : '',
		hidden : true
	},{
		header : "����",
		dataIndex : 'Drugform',
		width : 100,
		align : '',
		hidden : false
	},{
		header : "��Ʊ��",
		dataIndex : 'invNo',
		width : 100,
		align : '',
		hidden : false
	},
	{
		header : "��Ʊ����",
		dataIndex : 'invDate',
		width : 100,
		align : '',
		hidden : false
	},{
		header : "��Ʊ���",
		dataIndex : 'invAmt',
		width : 100,
		align : '',
		hidden : false
	},{
		header : "��Ӫ��ҵrowid",
		dataIndex : 'venid',
		width : 100,
		align : '',
		hidden : true
	},{
		header : "������λ",
		dataIndex : 'buom',
		width : 100,
		align : '',
		hidden : true
	},{
		header : "��λת��ϵ��",
		dataIndex : 'confac',
		width : 100,
		align : '',
		hidden : true
	},{
		header : "����ҽ������",
		dataIndex : 'InsuCode',
		width : 100,
		align : '',
		hidden : true
	},{
		header : "����ҽ������",
		dataIndex : 'InsuDesc',
		width : 100,
		align : '',
		hidden : true
	}
	]);
	
	
	function RpRenderer(val,meta,record){
		var rp = record.data.rp
		if(val != rp){
			monthcolor = 'classYellow';
			meta.css   = monthcolor;
		}
		return val; 
	}
	
	function SpRenderer(val,meta,record){
		var sp = record.data.sp
		if(val != sp){
			monthcolor = 'classYellow';
			meta.css   = monthcolor;
		}
		return val; 
	}
	
	
	var VendorRecItmGrid = new Ext.grid.GridPanel({
		//cm : ItmLcBtCm,
		cm:VendorRecItmCm,
		//store : ItmLcBtStore,
		store:VendorRecItmStore,
		trackMouseOver : true,
		stripeRows : true,
		sm : sm2, //new Ext.grid.CheckboxSelectionModel({singleSelect:true}),
		loadMask : true,
		bbar : IngriToolBar	,
		deferRowRender : false
	});

	// �س��¼�
	VendorRecItmGrid.on('keydown', function(e) {
		if (e.getKey() == Ext.EventObject.ENTER) {
			returnData();
		}
	});
	// ˫���¼�
	VendorRecItmGrid.on('rowdblclick', function() {
				returnData();
	});		
	// ���ذ�ť
	var returnBT = new Ext.Toolbar.Button({
		text : '����',
		tooltip : '�������',
		iconCls : 'page_goto',
		handler : function() {
			returnData();
		}
	});

	var RetVendor=new Ext.form.ComboBox({
		fieldLabel : '�˻���Ӫ��ҵ',
		id : 'RetVendor',
		anchor : '90%',
		width : 210,
		//store : APCVendorStore,
		store:VendorForIncItmStore,
		valueField : 'RowId',
		displayField : 'Description',		
		editable:false,
		allowBlank : true,
		triggerAction : 'all',
		emptyText : 'ѡ��Ӫ��ҵ',
		selectOnFocus : true,
		forceSelection : true,
		minChars : 1,
		//pageSize : 999,
		listWidth : 300,
		valueNotFoundText : '',
		listeners:{/*
			'select':function(cb,rec,index){
				if (index>-1)
				{
					queryIngri()
				}
				
			}*/
		}
	});
	
	RetVendor.on('select',function(combo,record,index){
		queryIngri();
	});
	
	/**
	 * ��������
	 */
	function returnData() {
		var selectRows = VendorRecItmGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Msg.info("warning", "��ѡ��һ��������Ϣ��");
		}else if(selectRows.length>1){
			Msg.info("warning", "ֻ��ѡ��һ��������Ϣ��");
		} else {
			flg = true;
			window.close();
		}
	}


	// �رհ�ť
	var closeBT = new Ext.Toolbar.Button({
		text : '�ر�',
		tooltip : '����ر�',
		iconCls : 'page_delete',
		handler : function() {
			flg = false;
			window.close();
		}
	});

	//���þ�Ӫ��ҵ
	function setVendor(Vendor,VendorName)
	{
		if ((Vendor!='')&&(VendorName!=''))
		{
			Ext.getCmp("RetVendor").clearValue();
			
			//����record
			var rec=new Ext.data.Record({'RowId':Vendor,"Description":VendorName});
			
			//����record
			Ext.getCmp("RetVendor").getStore().add(rec);	
			Ext.getCmp("RetVendor").setValue(Vendor);
			Ext.getCmp("RetVendor").disabled=true;
		}
	}
	
	//������Ӫ��ҵ�����ϸ��¼
	function queryIngri()
	{
		var loc='';
		var vendor='';
		var inci='';
		
		var rec=PhaOrderGrid.getSelectionModel().getSelected();
		var inci=rec.get('InciDr');
		var vendor=Ext.getCmp('RetVendor').getValue();
		var loc=Locdr;
		var zeroFlag='0';	
		var strPar=loc+"^"+inci+"^"+vendor+"^"+zeroFlag;
		var pageSize=IngriToolBar.pageSize;
		VendorRecItmStore.setBaseParam('strPar',strPar);
		VendorRecItmStore.load({params:{start:0,limit:pageSize,sort:'idate',dir:'DESC'}});
	}
	
	
	if (Vendor!='')	{setVendor(Vendor,VendorName);}  //�趨��Ӫ��ҵ
	
	var window = new Ext.Window({
		title : '���ҿ����������Ϣ',
		width : document.body.clientWidth*0.7,
		height : document.body.clientHeight*0.9,
		layout : 'border',
		plain : true,
		tbar : [returnBT, '-', closeBT],
		modal : true,
		buttonAlign : 'center',
		autoScroll : true,
		items : [{
			region:'north',
			height:document.body.clientHeight*0.9*0.4,
			split:true,
			layout:'fit',
			items:PhaOrderGrid
		},{
			region:'center',
			layout:'fit',
			height:250,
			items:VendorRecItmGrid
		},
		{
			region:'south',
			layout:'form',
			frame:true,
			height:40,
			items:RetVendor
		}]
	});

	window.show();

	window.on('close', function(panel) {
		var selectRows = VendorRecItmGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Fn("");
		}  else {
			if (flg) {
				var batRecord=selectRows[0];
				var itmRecord=PhaOrderGrid.getSelectionModel().getSelected();
				Ext.applyIf(batRecord.data,itmRecord.data);
				Fn(batRecord);
			} else {
				Fn("");
			}
		}
	});
}