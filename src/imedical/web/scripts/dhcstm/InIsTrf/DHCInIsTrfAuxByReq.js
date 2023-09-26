// /����: ����ת�������Ƶ�
// /����: ����ת�������Ƶ�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.24
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gInitId='';
	var reqid=''; ///����ȫ�ֱ����Ա������󵥺ŵ�ת�Ƶ�
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;


	// ������
	var RequestPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '������',
				id : 'RequestPhaLoc',
				name : 'RequestPhaLoc',
				anchor : '70%',				
				emptyText : '������...',				
				listWidth : 250,
				//groupId:session['LOGON.GROUPID'],
				defaultLoc:""
			});
	
	// ��������
	var SupplyPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '��������',
				id : 'SupplyPhaLoc',
				name : 'SupplyPhaLoc',
				anchor : '70%',
				emptyText : '��������...',
				listWidth : 250,
				groupId:session['LOGON.GROUPID']
			});
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '��ʼ����',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '70%',
				
				width : 120,
				value : new Date().add(Date.DAY, - 7)
			});
	// ��ֹ����
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '��ֹ����',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '70%',
				
				width : 120,
				value : new Date()
			});
	
	// ��������ת��
	var PartlyStatus = new Ext.form.Checkbox({
				//fieldLabel : '��������ת��',
				fieldLabel:'��������ת��',
				hideLable:true,
				id : 'PartlyStatus',
				name : 'PartlyStatus',
				anchor : '90%',
				width : 120,
				checked : false,
				disabled : false
			});
			
var TransStatus = new Ext.form.Checkbox({
				fieldLabel : '������ת��',
				id : 'TransStatus',
				name : 'TransStatus',
				anchor : '90%',
				width : 120,
				checked : false,
				disabled : false
			});
			
	// ��ѯת�Ƶ���ť
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : '��ѯ',
				tooltip : '�����ѯ����',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					Query();
				}
			});


	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
				id : "ClearBT",
				text : '���',
				tooltip : '������',
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
		Ext.getCmp("RequestPhaLoc").setValue("");
		Ext.getCmp("SupplyPhaLoc").setDisabled(0);
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY,-7));
		Ext.getCmp("EndDate").setValue(new Date());
		MasterGrid.store.removeAll();
		MasterGrid.getView().refresh();
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}

	// ���水ť
	var SaveBT = new Ext.ux.Button({
				id : "SaveBT",
				text : '����',
				tooltip : '�������',
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {

					// ����ת�Ƶ�
					if(CheckDataBeforeSave()==true){
						saveOrder();
					}
				}
			});
			
	/**
	 * ������ⵥǰ���ݼ��
	 */		
	function CheckDataBeforeSave() {
				
		var requestphaLoc = Ext.getCmp("RequestPhaLoc")
				.getValue();
		if (requestphaLoc == null || requestphaLoc.length <= 0) {
			Msg.info("warning", "��ѡ��������!");
			return false;
		}
		var supplyphaLoc = Ext.getCmp("SupplyPhaLoc")
				.getValue();
		if (supplyphaLoc == null || supplyphaLoc.length <= 0) {
			Msg.info("warning", "��ѡ��Ӧ����!");
			return false;
		}
		if (requestphaLoc == supplyphaLoc) {
			Msg.info("warning", "�����ź͹�Ӧ���Ų�����ͬ!");
			return false;
		}
		
		// 1.�ж�ת�������Ƿ�Ϊ��
		var rowCount = DetailGrid.getStore().getCount();
		// ��Ч����
		var count = 0;
		for (var i = 0; i < rowCount; i++) {
			var item = DetailStore.getAt(i).get("incidr");
			if (item != undefined) {
				count++;
			}
		}
		if(rowCount<=0){
			Msg.info("warning", "û����Ҫ���������!");
			return false;
		}
		if (count <= 0) {
			Msg.info("warning", "��Ҫ�����������Ч!");
			return false;
		}
		// 2.������䱳��
		for (var i = 0; i < rowCount; i++) {
			changeBgColor(i, "white");
		}
		// 3.�ж��ظ��������ο������
		for (var i = 0; i < rowCount - 1; i++) {
			for (var j = i + 1; j < rowCount; j++) {
				var item_i = DetailStore.getAt(i).get("inclb");;
				var item_j = DetailStore.getAt(j).get("inclb");;
				if (item_i != undefined && item_j != undefined
						&& item_i == item_j) {
					changeBgColor(i, "yellow");
					changeBgColor(j, "yellow");
					Msg.info("warning", "���������ظ�������������!");
					return false;
				}
			}
		}
		// 4.������Ϣ�������
		var rowCount = DetailGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailStore.getAt(i);
			var code = rowData.get("incicode");
			if (code == null || code.length == 0) {
				continue;
			}
			var item = rowData.get("incidr");
			if (item == undefined) {
				Msg.info("warning", "������Ϣ�������!");
				DetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}
			var qty = DetailStore.getAt(i).get("qty");
			if ((item != undefined) && (qty == null || qty <= 0)) {
				Msg.info("warning", "ת����������С�ڻ����0!");
				DetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}

			var avaQty = DetailStore.getAt(i).get("avaqty");
			if ((item != undefined) && ((qty - avaQty) > 0)) {
				Msg.info("warning", "ת���������ܴ��ڿ��ÿ������!");
				DetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}
		}
		
		return true;
	}
	

	/**
	 * ����ת�Ƶ�
	 */
	function saveOrder() {
		//��Ӧ����RowId^�������RowId^���ת������RowId^��������RowId^��ɱ�־^����״̬^�Ƶ���RowId^����RowId^�������^��ע
		var supplyPhaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
		var requestPhaLoc = Ext.getCmp("RequestPhaLoc").getValue();
		var rowData=MasterGrid.getSelectionModel().getSelected();
		if(rowData==null || rowData==""){
			Msg.info("warning","û��ѡ�������!");
			return;
		}else{
			reqid=rowData.get('req');
		}
		var operatetype = "";	
		var Complete='N';
		var Status=10;
		var StkGrpId = "";
		var StkType = App_StkTypeCode;					
		var remark = "";
		
		var MainInfo = supplyPhaLoc + "^" + requestPhaLoc + "^" + reqid + "^" + operatetype + "^"
				+ Complete + "^" + Status + "^" + userId + "^"+StkGrpId+"^"+StkType+"^"+remark;
		//��ϸid^����id^����^��λ^������ϸid^��ע
		var ListDetail="";
		var rowCount = DetailGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
				var rowData = DetailStore.getAt(i);	
				var Initi = rowData.get("initi");
				var Inclb = rowData.get("inclb");
				var Qty = rowData.get("qty");
				var UomId = rowData.get("uomdr");
				var ReqItmId =rowData.get("inrqi");
				var Remark ="";
				
				var str = Initi + "^" + Inclb + "^"	+ Qty + "^" + UomId + "^"
						+ ReqItmId + "^" + Remark;	
				if(ListDetail==""){
					ListDetail=str;
				}
				else{
					ListDetail=ListDetail+xRowDelim()+str;
				}
			
		}
		if(ListDetail==""){
			Msg.info("warning","û����Ҫ���������!");
			return;
		}
		var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=Save";
		Ext.Ajax.request({
					url : url,
					params:{Rowid:'',MainInfo:MainInfo,ListDetail:ListDetail},
					method : 'POST',
					waitMsg : '������...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// ˢ�½���
							var InitRowid = jsonData.info;
							Msg.info("success", "����ɹ�!");
									
							// ��ת�������Ƶ�����
							window.location.href='dhcstm.dhcinistrf.csp?Rowid='+InitRowid+'&QueryFlag=1';

						} else {
							var ret=jsonData.info;
							if(ret==-99){
								Msg.info("error", "����ʧ��,���ܱ���!");
							}else if(ret==-2){
								Msg.info("error", "���ɳ��ⵥ��ʧ��,���ܱ���!");
							}else if(ret==-1){
								Msg.info("error", "������ⵥʧ��!");
							}else if(ret==-5){
								Msg.info("error", "������ⵥ��ϸʧ��!");
							}else {
								Msg.info("error", "������ϸ���治�ɹ���"+ret);
							}
							
						}
					},
					scope : this
				});
		
	}

	// ��λ
	var CTUom = new Ext.form.ComboBox({
				fieldLabel : '��λ',
				id : 'CTUom',
				name : 'CTUom',
				anchor : '90%',
				width : 120,
				store : CTUomStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : false,
				triggerAction : 'all',
				emptyText : '��λ...',
				selectOnFocus : true,
				forceSelection : true,
				minChars : 1,
				pageSize : 10,
				listWidth : 250,
				valueNotFoundText : ''
			});

	// ��ʾ���ⵥ����
	function Query() {
		var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
		if (supplyphaLoc =='' || supplyphaLoc.length <= 0) {
			Msg.info("warning", "��ѡ��Ӧ����!");
			return;
		}
		var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();
		var startDate = Ext.getCmp("StartDate").getValue();
		var endDate = Ext.getCmp("EndDate").getValue();
		if(startDate!=""){
			startDate = startDate.format(ARG_DATEFORMAT);
		}
		if(endDate!=""){
			endDate = endDate.format(ARG_DATEFORMAT);
		}
		var PartlyStatus = (Ext.getCmp("PartlyStatus").getRawValue()==true?1:0);
		var TransStatus = (Ext.getCmp("TransStatus").getValue()==true?1:0);
		var ListParam=startDate+'^'+endDate+'^'+supplyphaLoc+'^'+requestphaLoc+'^'+PartlyStatus+'^'+TransStatus+'^'+"Y";
		var Page=GridPagingToolbar.pageSize;
	
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		MasterStore.removeAll();
		
		MasterStore.setBaseParam('ParamStr',ListParam);
		MasterStore.load({params:{start:0, limit:Page}});
	}
	// ��ʾ��ⵥ��ϸ����
	function getDetail(InitRowid) {
		if (InitRowid == null || InitRowid=='') {
			return;
		}
		DetailStore.load({params:{start:0,limit:999,Parref:InitRowid}});
	}
	
	// ����·��
	var MasterUrl = DictUrl	+ 'dhcinistrfaction.csp?actiontype=QueryReq';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["req", "reqNo", "toLoc","toLocDesc", "frLocDesc", "date","time", "comp", 
	"userName","status","transferStatus"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "req",
				fields : fields
			});
	// ���ݼ�
	var MasterStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var MasterCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'req',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "���󵥺�",
				dataIndex : 'reqNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "������",
				dataIndex : 'toLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'frLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'date',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : "����״̬",
				dataIndex : 'status',
				width : 120,
				align : 'left',
				renderer : renderReqType,
				sortable : true
			}, {
				header : "�Ƶ���",
				dataIndex : 'userName',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "ת��״̬",
				dataIndex : 'transferStatus',
				width : 80,
				align : 'left',
				renderer : renderStatus,
				sortable : true
			}]);
	MasterCm.defaultSortable = true;
	
	function renderStatus(value){
		var InstrfStatus='';
		if(value==0){
			InstrfStatus='δת��';			
		}else if(value==1){
			InstrfStatus='����ת��';
		}else if(value==2){
			InstrfStatus='ȫ��ת��';
		}
		return InstrfStatus;
	}
	function renderReqType(value){
		var ReqType='';
		if(value=='O'){
			ReqType='���쵥';
		}else if(value=='C'){
			ReqType='����ƻ�';
		}
		return ReqType;
	}
	
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
				bbar:[GridPagingToolbar]
			});

	// ��ӱ�񵥻����¼�
	MasterGrid.on('rowclick', function(grid, rowIndex, e) {
		var ReqId = MasterStore.getAt(rowIndex).get("req"); 
		var ReqLocDesc=MasterStore.getAt(rowIndex).get("toLocDesc");
		var ReqLocId=MasterStore.getAt(rowIndex).get("toLoc");
		addComboData(GetGroupDeptStore,ReqLocId,ReqLocDesc);
		Ext.getCmp("RequestPhaLoc").setValue(ReqLocId);
		DetailStore.load({params:{start:0,limit:999,sort:'req',dir:'Desc',Parref:ReqId}});
	});
	
	// ת����ϸ
	// ����·��
	var DetailUrl =DictUrl+
		'dhcinistrfaction.csp?actiontype=QueryReqDetail&Parref=&start=0&limit=999';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	
	// ָ���в���
	var fields = ["initi", "inrqi", "incidr","incicode","incidesc", "inclb", "batexp", "manfName",
			 "qty", "uomdr", "sp","uomdesc","rqty", "inclbqty", "reqstkqty", "stkbin",
			 "spec", "geneDesc", "formDesc","newsp","spamt", "rp","rpamt", "confac", "buomdr", 
			 "dirtyqty", "avaqty","transqty"
			];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "initi",
				fields : fields
			});
	// ���ݼ�
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
				header : "ת��ϸ��RowId",
				dataIndex : 'initi',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "����RowId",
				dataIndex : 'incidr',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '���ʴ���',
				dataIndex : 'incicode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '��������',
				dataIndex : 'incidesc',
				width : 230,
				align : 'left',
				sortable : true
			}, {
				header : "����RowId",
				dataIndex : 'inclb',
				width : 180,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "ת������",
				dataIndex : 'qty',
				width : 80,
				align : 'right',
				sortable : true,
				editor : new Ext.form.NumberField({
					selectOnFocus : true,
					allowBlank : false,
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								
								var qty = field.getValue();
								if (qty == null || qty.length <= 0) {
									Msg.info("warning", "ת����������Ϊ��!");
									return;
								}
								if (qty <= 0) {
									Msg.info("warning", "ת����������С�ڻ����0!");
									return;
								}
								var cell = DetailGrid.getSelectionModel().getSelectedCell();
								var record = DetailGrid.getStore().getAt(cell[0]);
								var salePriceAMT = record.get("sp")* qty;
								record.set("spamt",	salePriceAMT);
								var AvaQty = record.get("avaqty");
								if (qty > AvaQty) {
									Msg.info("warning", "ת���������ܴ��ڿ��ÿ������!");
									return;
								}
							}
						}
					}
				})
			}, {
				header : "ת�Ƶ�λ",
				dataIndex : 'uomdesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "����/Ч��",
				dataIndex : 'batexp',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'avaqty',
				width : 80,
				align : 'right',
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
				header : "��������",
				dataIndex : 'rqty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'manfName',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "��λ��",
				dataIndex : 'stkbin',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "���󷽿��",
				dataIndex : 'reqstkqty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "���ο��",
				dataIndex : 'inclbqty',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "ռ������",
				dataIndex : 'dirtyqty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "�����ۼ�",
				dataIndex : 'newsp',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "���",
				dataIndex : 'spec',
				width : 100,
				align : 'left',
				sortable : true
			}, /*{
				header : "ͨ����",
				dataIndex : 'geneDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'formDesc',
				width : 100,
				align : 'left',
				sortable : true
			},*/ {
				header : "�ۼ۽��",
				dataIndex : 'spamt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "ת����",
				dataIndex : 'confac',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "������λ",
				dataIndex : 'buomdr',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "ת�������ӱ�RowId",
				dataIndex : 'inrqi',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}]);

	var DetailGrid = new Ext.grid.EditorGridPanel({
				id : 'DetailGrid',
				region : 'center',
				title : '',
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				sm : new Ext.grid.CellSelectionModel({}),
				clicksToEdit : 1
			});

	/**
	 * ��λչ���¼�
	 */
	CTUom.on('expand', function(combo) {
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);
				var InciDr = record.get("inci");
				var url = DictUrl
						+ 'drugutil.csp?actiontype=INCIUom&ItmRowid='
						+ InciDr;
				CTUomStore.proxy = new Ext.data.HttpProxy({
							url : url
						});
				CTUom.store.load();
			});

	
	// �任����ɫ
	function changeBgColor(row, color) {
		DetailGrid.getView().getRow(row).style.backgroundColor = color;
	}

	

	var HisListTab = new Ext.form.FormPanel({
		//labelWidth: 60,	
		labelAlign : 'right',
		frame : true,
		height : 160,
		tbar : [SearchBT, '-',  ClearBT, '-', SaveBT],
		items : [{
			layout: 'column',    // Specifies that the items will now be arranged in columns
			xtype:'fieldset',
			title:'��ѯ����',
			defaults: {border:false},    // Default config options for child items
			style : 'padding:5px 0px 0px 5px;',
			items:[{ 				
				columnWidth: 0.34,
	        	xtype: 'fieldset',
	        	items: [SupplyPhaLoc,RequestPhaLoc]				
			},{ 				
				columnWidth: 0.3,
	        	xtype: 'fieldset',	        	
	        	items: [StartDate,EndDate]				
			},{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',	        	
	        	items: [PartlyStatus,TransStatus]
				
			}]
		}]
	});

	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
					items : [            // create instance immediately
		            {
		            	title:'���ת��-��������',
		                region: 'north',
		                height: 180, // give north and south regions a height
		                layout: 'fit', // specify layout manager for items
		                items:HisListTab
		            }, {
		                region: 'west',
		                title: '����',
		                collapsible: true,
		                split: true,
		                width: 225, // give east and west regions a width
		                minSize: 175,
		                maxSize: 400,
		                margins: '0 5 0 0',
		                layout: 'fit', // specify layout manager for items
		                items: MasterGrid       
		               
		            }, {
		                region: 'center',
		                title: '������ϸ',
		                layout: 'fit', // specify layout manager for items
		                items: DetailGrid       
		               
		            }
       			],
				renderTo : 'mainPanel'
			});
			
	
	Query();
	
	
	
})