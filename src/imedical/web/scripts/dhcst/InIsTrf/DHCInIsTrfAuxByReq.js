// /����: ����ת�������Ƶ�
// /����: ����ת�������Ƶ�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.24
var TransferPageSize=9999;
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var userName=session['LOGON.USERNAME'];
	var gInitId='';
	var reqid=''; ///����ȫ�ֱ����Ա������󵥺ŵ�ת�Ƶ�
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	Ext.Ajax.timeout = 900000;
       //ȡ��������
	if(gParam==null ||gParam.length<1){			
		GetParam();		
	}
	if(gParamCommon.length<1){
		GetParamCommon();  //��ʼ��������������
	}
	// ������
	var RequestPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '������',
				id : 'RequestPhaLoc',
				name : 'RequestPhaLoc',
				//anchor : '70%',				
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
				//anchor : '70%',
				emptyText : '��������...',
				listWidth : 250,
				groupId:session['LOGON.GROUPID']
			});
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '��ʼ����',
				id : 'StartDate',
				name : 'StartDate',
				width : 120,
				value : DefaultStDate()
			});
	// ��ֹ����
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '��ֹ����',
				id : 'EndDate',
				name : 'EndDate',
				width : 120,
				value : DefaultEdDate()
			});
	
	// ��������ת��
	var PartlyStatus = new Ext.form.Checkbox({
				//fieldLabel : '��������ת��',
				boxLabel:'��������ת��',
				hideLable:true,
				id : 'PartlyStatus',
				name : 'PartlyStatus',
				anchor : '90%',
				width : 120,
				checked : false,
				disabled : false
			});
			
var TransStatus = new Ext.form.Checkbox({
				boxLabel : '������ת��',
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

	// ������ť
	var ExportBT = new Ext.Toolbar.Button({
				id : "ExportBT",
				text : '���',
				tooltip : '�������',
				width : 70,
				height : 30,
				iconCls : 'page_excel',
				handler : function() {
					ExportAllToExcel(DetailGrid);
					//gridSaveAsExcel(DetailGrid);
				}
			});
	// ��ӡ��ť
	var PrintBT = new Ext.Toolbar.Button({
				id : "PrintBT",
				text : '��ӡ',
				tooltip : '�����ӡ',
				width : 70,
				height : 30,
				iconCls : 'page_print',
				handler : function() {
						PrintTransReq();
				}
			});	
	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
				id : "ClearBT",
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
		Ext.getCmp("RequestPhaLoc").setValue("");
		Ext.getCmp("SupplyPhaLoc").setDisabled(0);
		Ext.getCmp("StartDate").setValue(DefaultStDate());
		Ext.getCmp("EndDate").setValue(DefaultEdDate());
		MasterGrid.store.removeAll();
		MasterGrid.getView().refresh();
		DetailGrid.store.removeAll();
		DetailGrid.store.load({params:{start:0,limit:0,Parref:"0"}});
		DetailGrid.getView().refresh();
	}
	 // ȫѡ
	 var AllBT = new Ext.form.Checkbox({
					boxLabel : '����ȫѡ',
					id : 'AllBT',
					name : 'AllBT',
					anchor : '90%',
					width : 120,
					checked : false,
					handler : function() {
						AllBTSel();
					}
	 });
      function AllBTSel(){
	   var AllValue=Ext.getCmp("AllBT").getValue();
	   var rowCount = DetailGrid.getStore().getCount();
	   if (AllValue==true){
		    for (var i = 0; i < rowCount; i++) {
			  DetailStore.getAt(i).set("cancel",1);
			}  
		     }
	   if (AllValue==false){
		    for (var i = 0; i < rowCount; i++) {
			   DetailStore.getAt(i).set("cancel",0);
			}
		     }
	      }
	// ���水ť
	var SaveBT = new Ext.Toolbar.Button({
				id : "SaveBT",
				text : '����',
				tooltip : '�������',
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {
					Ext.getCmp("SaveBT").disable();
					setTimeout(ChangeSaveBtn,3000);//�����ִ��
					// ����ת�Ƶ�
					if(CheckDataBeforeSave()==true){
						saveOrder();
					}
				}
			});
	function ChangeSaveBtn()
	{
		Ext.getCmp("SaveBT").enable();
	}		
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
		
		// 1.�ж�ת��ҩƷ�Ƿ�Ϊ��
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
		// 3.�ж��ظ��������ο��ҩƷ
		for (var i = 0; i < rowCount - 1; i++) {
			for (var j = i + 1; j < rowCount; j++) {
				var item_i = DetailStore.getAt(i).get("inclb");;
				var item_j = DetailStore.getAt(j).get("inclb");;
				if (item_i != undefined && item_j != undefined
						&& item_i == item_j) {
					changeBgColor(i, "yellow");
					changeBgColor(j, "yellow");
					Msg.info("warning", "ҩƷ�����ظ�������������!");
					return false;
				}
			}
		}
		// 4.ҩƷ��Ϣ�������
		var rowCount = DetailGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailStore.getAt(i);
			var code = rowData.get("incicode");
			if (code == null || code.length == 0) {
				continue;
			}
			var item = rowData.get("incidr");
			if (item == undefined) {
				Msg.info("warning", "ҩƷ��Ϣ�������!");
				DetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}
			var qty = DetailStore.getAt(i).get("qty");
			if ((item != undefined) && (qty == null || qty < 0)) {
				Msg.info("warning", "ת����������С��0!");
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
		 // var cancelList=QueryListDetailID()
              //if (cancelList!=""&&gParam[9]=='Y'){			
                  // Msg.info("warning","�й�ѡ��������û������!");
			//return;
			//}
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
		      if (Qty>0){
				var str = Initi + "^" + Inclb + "^"	+ Qty + "^" + UomId + "^"
						+ ReqItmId + "^" + Remark;	
                         if (DetailStore.getAt(i).get("cancel")!=true){				
				if(ListDetail==""){
					ListDetail=str;
				}
				else{
					ListDetail=ListDetail+xRowDelim()+str;
				}
                         }
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
							window.location.href='dhcst.dhcinistrf.csp?Rowid='+InitRowid+'&QueryFlag=1';

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
		var startDate = Ext.getCmp("StartDate").getRawValue();
		var endDate = Ext.getCmp("EndDate").getRawValue();
		var PartlyStatus = (Ext.getCmp("PartlyStatus").getValue()==true?1:0);
		var TransStatus = (Ext.getCmp("TransStatus").getValue()==true?1:0);
		var ListParam=startDate+'^'+endDate+'^'+supplyphaLoc+'^'+requestphaLoc+'^'+PartlyStatus+'^'+TransStatus;
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
		var PartlyStatus = (Ext.getCmp("PartlyStatus").getValue()==true?1:0);
		var TransStatus = (Ext.getCmp("TransStatus").getValue()==true?1:0);
		var strParam=InitRowid+"^"+PartlyStatus+'^'+TransStatus
		DetailStore.setBaseParam("Params",strParam);
		DetailStore.load({params:{start:0,limit:StatuTabPagingToolbar.pageSize}});
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
				header : "��������",
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
			},{
				header : "������ID",
				dataIndex : 'toLoc',
				width : 120,
				align : 'left',
				sortable : true,
				hidden : true
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
		}else if(value=='1'){
			ReqType='����ҩƷ����';
		}else if(value=='2'){
			ReqType='�����鲹��';
		}else if(value=='3'){
			ReqType='����Һ����';
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
				bbar:[GridPagingToolbar],
				viewConfig:{getRowClass : function(record,rowIndex,rowParams,store){ 
						var transferStatus=record.get("transferStatus");
						switch(transferStatus){
							case "1":
								return 'classTransPart';
								break;
							case "2":
								return 'classSalmon';
								break;
						}
				}
				}
			});

	// ��ӱ�񵥻����¼�
	MasterGrid.on('rowclick', function(grid, rowIndex, e) {
		var ReqId = MasterStore.getAt(rowIndex).get("req"); 
		var ReqLocDesc=MasterStore.getAt(rowIndex).get("toLocDesc");
		var ReqLocId=MasterStore.getAt(rowIndex).get("toLoc");
		addComboData(RequestPhaLoc.getStore(),ReqLocId,ReqLocDesc);    //GetGroupDeptStore  ���storeδ���壬���»�ȡ yangsj2019-11-13
		Ext.getCmp("RequestPhaLoc").setValue(ReqLocId);
		var strParam=ReqId
		DetailStore.setBaseParam("Params",strParam);
		DetailStore.load({params:{start:0,limit:StatuTabPagingToolbar.pageSize,sort:'req',dir:'Desc'}});
	});
   MasterStore.on('load',function(){
		var rowData = MasterGrid.getSelectionModel().getSelected();
		if ((rowData==null)||(rowData==undefined))
		{
			DetailStore.setBaseParam("Params","");
			DetailStore.load({params:{start:0,limit:StatuTabPagingToolbar.pageSize,sort:'req',dir:'Desc'}});
		}
	})	
	// ת����ϸ
	// ����·��
	var DetailUrl =DictUrl+
		'dhcinistrfaction.csp?actiontype=QueryReqDetail&Parref=&start=0&limit=9999';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	//initi_inrqi_incidr_incicode_incidesc_inclb_batexp_manfName_inclbqty_qty_uomdr_uomdesc_sp_rqty_reqstkqty_stkbin_rp_spec_geneDesc_formDesc_spamt_buomdr_confac_dirtyqty_avaqty_transqty_rpamt_newsp
	// ָ���в���
	var fields = ["cancel","initi", "inrqi", "incidr","incicode","incidesc", "inclb", "batexp", "manfName",
			 "inclbqty","qty", "uomdr","uomdesc", "sp","rqty","reqstkqty","stkbin","rp","spec","geneDesc","formDesc","spamt","buomdr", "confac","dirtyqty","avaqty","transqty","rpamt","newsp","colorlevel","prostkqty" 
			  
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
	var DetailCm = new Ext.grid.ColumnModel([nm,{
		              header : "����",
		              width : 50,
		              sortable: false,             
		              dataIndex: 'cancel',//����Դ�е�״̬��             
		              renderer: function (v) {
		                       return '<input type="checkbox"'+(v=="1"?"checked":"")+'/>';  //����ֵ����checkbox�Ƿ�ѡ    
		                       },
		              listeners : {
			              'click':function(e,b,row){

				              if (DetailStore.getAt(row).get("cancel")==""||DetailStore.getAt(row).get("cancel")==0)
				               {DetailStore.getAt(row).set("cancel",1);}
				              else{DetailStore.getAt(row).set("cancel",0);} 
				               
				               
				               }
			              
			              },
			      hidden:(gParam[9]=='Y'?false:true)
			             
		                     
		        }, {
				header : "ת��ϸ��RowId",
				dataIndex : 'initi',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "����ϸ��RowId",
				dataIndex : 'inrqi',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "ҩƷRowId",
				dataIndex : 'incidr',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : 'ҩƷ����',
				dataIndex : 'incicode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : 'ҩƷ����',
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
				renderer:BiggerRender,
				editor : new Ext.ux.NumberField({
					selectOnFocus : true,
					formatType:'FmtSQ',
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
				header : "���������",
				dataIndex : 'prostkqty',
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
			}, {
				header : "����ͨ����",
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
			}, {
				header : "�ۼ۽��",
				dataIndex : 'spamt',
				width : 100,
				align : 'right',				
				sortable : true,
				renderer:FormatGridSpAmount
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
			}, {
				header : "colorlevel",
				dataIndex : 'colorlevel',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}]);
		var StatuTabPagingToolbar = new Ext.PagingToolbar({
					store : DetailStore,
					pageSize : TransferPageSize,
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

	var DetailGrid = new Ext.grid.EditorGridPanel({
				id : 'DetailGrid',
				region : 'center',
				title : '',
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				//sm :new Ext.grid.RowSelectionModel({singleSelect:true}),
				sm : new Ext.grid.CellSelectionModel({}),
				clicksToEdit : 1,
				bbar:[StatuTabPagingToolbar],
				viewConfig:{getRowClass : function(record,rowIndex,rowParams,store){ 
						var colorlevel=record.get("colorlevel");
						switch(colorlevel){
							/*case "0":
								return 'classSalmon';
								break;*/
							case "-1":
								return 'classTransPart';
								break;
						}
				}
				}
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
	function BiggerRender(val){
				return '<span style="font-size:13px;font-weight:bold">'+val+'</span>';

	}

	var HisListTab = new Ext.form.FormPanel({
		labelWidth: 60,	
		labelAlign : 'right',
		frame : true,
		autoHeight:true,
		tbar : [SearchBT, '-',  ClearBT, '-', SaveBT,'-',PrintBT,'-',ExportBT],
		items : [{
			layout: 'column',    // Specifies that the items will now be arranged in columns
			xtype:'fieldset',
			title:'��ѯ����',
			defaults: {border:false},    // Default config options for child items
			style:DHCSTFormStyle.FrmPaddingV,
			items:[{ 				
				columnWidth: 0.3,
	        	xtype: 'fieldset',
	        	items: [SupplyPhaLoc,RequestPhaLoc]				
			},{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',	        	
	        	items: [StartDate,EndDate]				
			},{ 				
				columnWidth: 0.1,
	        	xtype: 'fieldset',	
	        	labelWidth:10,        	
	        	items: [PartlyStatus,TransStatus]
	        }]
		}]
	});
	 function QueryListDetailID(){
	      //var sm=DetailGrid.getSelectionModel()
	      //var records=sm.getSelections()  //���ص���Ext.data.Record��������
	      //var count=records.length
	      var rowCount = DetailGrid.getStore().getCount();
	      var listdata=""
            for (var i=0;i<rowCount;i++) {
	         if (DetailStore.getAt(i).get("cancel")==true && listdata==""){
	              listdata=DetailStore.getAt(i).get("inrqi");
	         }
	         else if(DetailStore.getAt(i).get("cancel")==true && listdata!=""){
		       listdata=listdata+"^"+DetailStore.getAt(i).get("inrqi");
		      }
	       } 
		return  listdata;   
	   }
	   	 
		
	 
	 
	 //��������ѡ����� wyx 2014-06-23
	 function CancelDetailsAction(ListDetailID){
		    	// ����·��
	         var url =DictUrl+
		        'inrequestaction.csp?actiontype=CancelReqItm';
			var loadMask=ShowLoadMask(Ext.getBody(),"������...");
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{ListDetailID:ListDetailID},
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {				
								Msg.info("success", "���ϳɹ�!");
								// ���¼�������	
       						    MasterStore.reload();
       							DetailStore.reload();
       							DetailGrid.getView().refresh();
							} else {
								//var ret=jsonData.info;
									Msg.info("error", "����ʧ��!");
							}
						},
						scope : this
					});
			loadMask.hide();		
		}
	
	function CancelSelectAll(){
		var toggleselect=(Ext.getCmp("AllBT").getValue()==false) ? true : false;
		Ext.getCmp("AllBT").setValue(toggleselect);

	}
		function CancelDetails() {
         // �û��Ի���
                   Ext.Msg.show({
	                 title:'��������ѡ����',
	                 msg:'ȷ����������ѡ���',
	                 scope: this,
	                 buttons: Ext.Msg.OKCANCEL,
	                 icon:Ext.MessageBox.QUESTION,
                     fn: function(id){
	                     if (id=='ok'){
		                    var ListDetailID=QueryListDetailID();
		                    if (ListDetailID=="") {Msg.info("warning","û�й�ѡ������!");}
		                    if (ListDetailID!=""){
		                        CancelDetailsAction(ListDetailID); 
		                    }
		                 }
                        
	                     }

	                 });
		}	
		function DeleteDetail()
		{
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			if (cell == null) {
				Msg.info("warning", "û��ѡ����!");
				return;
			}
			var row = cell[0];
			var thisrowData = DetailStore.getAt(row);	
			DetailGrid.getStore().remove(thisrowData);
			DetailGrid.getView().refresh();
		}
		///������������޸����ι���,yunhaibao20151117
		function ChangeInclb() {
			var rowMainData=MasterGrid.getSelectionModel().getSelected();
			var ReqLocId=""
			if(rowMainData==null || rowMainData==""){
				Msg.info("warning","û��ѡ�������!");
				return;
			}else{
				ReqLocId=rowMainData.get('toLoc');
			}
			if (ReqLocId=="")
			{
				Msg.info("warning", "û��ѡ����!");
				return
			}
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			if (cell == null) {
				Msg.info("warning", "û��ѡ����!");
				return;
			}
			// ѡ����
			var row = cell[0];
			var record = DetailGrid.getStore().getAt(row);
			var Inclb = record.get("inclb");
			INCItmLcBtInfo(Inclb, "", ReqLocId, ReplaceInclb)
		}	
		function ReplaceInclb(modifyrecord)
		{
			if (modifyrecord == null || modifyrecord == "") {
				return;
			}
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			var selectRow = cell[0];
			var thisrowData = DetailStore.getAt(selectRow);	
			for(var i=0;i<modifyrecord.length;i++){
				if (i!=0){
					insertNewRow(selectRow)	
				}
				var inclb = modifyrecord[i].data["Inclb"]
				var inci=modifyrecord[i].data["IncRowId"]
				var incidesc=modifyrecord[i].data["IncDesc"]
				var incicode=modifyrecord[i].data["IncCode"]
				var expdate=modifyrecord[i].data["BatExp"]
				var inclbqty=modifyrecord[i].data["InclbQty"]
				var reqlocqty=modifyrecord[i].data["RequrstStockQty"]
				var prolocqty=modifyrecord[i].data["SupplyStockQty"]
				var dirtyqty=modifyrecord[i].data["DirtyQty"]
				var avaqty=modifyrecord[i].data["AvaQty"]
				var initqty=modifyrecord[i].data["InitQty"]
				var confac=modifyrecord[i].data["ConFac"]
				var buomdr=modifyrecord[i].data["BUomId"]
				var requomdr=thisrowData.get("uomdr")
				if (requomdr==buomdr){//����������������ⵥλ��,�������λΪ������λ����ת��
					avaqty=avaqty*confac
					reqlocqty=reqlocqty*confac
					prolocqty=prolocqty*confac
					dirtyqty=dirtyqty*confac
					inclbqty=inclbqty*confac					
				}
				DetailStore.getAt(selectRow).set("inci", inci);
				DetailStore.getAt(selectRow).set("inclb", inclb);
				DetailStore.getAt(selectRow).set("batexp", expdate);
				DetailStore.getAt(selectRow).set("inclbqty", inclbqty);
				DetailStore.getAt(selectRow).set("reqstkqty", reqlocqty);
				DetailStore.getAt(selectRow).set("proLocStkQty", prolocqty);
				DetailStore.getAt(selectRow).set("dirtyqty", dirtyqty);
				DetailStore.getAt(selectRow).set("avaqty", avaqty);
				DetailStore.getAt(selectRow).set("qty", initqty);
				//����ԭ������
				DetailStore.getAt(selectRow).set("cancel", thisrowData.get("cancel"));
				DetailStore.getAt(selectRow).set("initi", thisrowData.get("initi"));
				DetailStore.getAt(selectRow).set("inrqi", thisrowData.get("inrqi"));
				DetailStore.getAt(selectRow).set("incidr", thisrowData.get("incidr"));
				DetailStore.getAt(selectRow).set("incicode", thisrowData.get("incicode"));
				DetailStore.getAt(selectRow).set("incidesc", thisrowData.get("incidesc"));
				DetailStore.getAt(selectRow).set("manfName", thisrowData.get("manfName"));
				DetailStore.getAt(selectRow).set("uomdr", thisrowData.get("uomdr"));
				DetailStore.getAt(selectRow).set("uomdesc", thisrowData.get("uomdesc"));
				DetailStore.getAt(selectRow).set("sp", thisrowData.get("sp"));
				DetailStore.getAt(selectRow).set("rqty", thisrowData.get("rqty"));
				DetailStore.getAt(selectRow).set("stkbin", thisrowData.get("stkbin"));
				DetailStore.getAt(selectRow).set("rp", thisrowData.get("rp"));
				DetailStore.getAt(selectRow).set("spec", thisrowData.get("spec"));
				DetailStore.getAt(selectRow).set("geneDesc", thisrowData.get("geneDesc"));
				DetailStore.getAt(selectRow).set("formDesc", thisrowData.get("formDesc"));
				DetailStore.getAt(selectRow).set("buomdr", thisrowData.get("buomdr"));
				DetailStore.getAt(selectRow).set("confac", thisrowData.get("confac"));
				DetailStore.getAt(selectRow).set("newsp", thisrowData.get("newsp"));
			}	
			DetailGrid.getView().refresh();
		}
		//������,20150530,yunhaibao
		function insertNewRow(RowNum)
		{
			var record = Ext.data.Record.create([
			{
				name : 'cancel',
				type : 'string'
			}, {
				name : 'initi',
				type : 'string'
			}, {
				name : 'inrqi',
				type : 'string'
			}, {
				name : 'incidr',
				type : 'string'
			}, {
				name : 'incicode',
				type : 'string'
			}, {
				name : 'incidesc',
				type : 'string'
			}, {
				name : 'inclb',
				type : 'string'
			}, {
				name : 'batexp',
				type : 'string'
			}, {
				name : 'manfName',
				type : 'string'
			},{	
				name : 'inclbqty',
				type : 'int'
			}, {
				name : 'qty',
				type : 'int'
			}, {
				name : 'uomdr',
				type : 'int'
			}, {
				name : 'uomdesc',
				type : 'string'
			}, {
				name : 'sp',
				type : 'double'
			}, {
				name : 'rqty',
				type : 'double'
			}, {
				name : 'reqstkqty',
				type : 'double'
			}, {
				name : 'stkbin',
				type : 'double'
			}, {
				name : 'rp',
				type : 'double'
			},{
				name:'spec',
				type:'string'
			},
			{
				name:'geneDesc',
				type:'string'	
			},
			{
				name:'formDesc',
				type:'string'	
			},
			{
				name:'spamt',
				type:'double'	
			},
			{
				name:'buomdr',
				type:'string'	
			},
			{
				name:'confac',
				type:'string'	
			},
			{
				name:'dirtyqty',
				type:'double'	
			},
			{
				name:'avaqty',
				type:'double'	
			},
			{
				name:'transqty',
				type:'double'	
			},
			{
				name:'rpamt',
				type:'double'	
			},
			{
				name:'newsp',
				type:'double'	
			},
			{
				name:'proLocStkQty',
				type:'double'	
			}
		]);
	
		var NewRecord = new record({
			cancel:'',
			initi:'',
			inrqi:'',
			incidr:'',
			incicode:'',
			incidesc:'',
			inclb:'',
			batexp:'', 
			manfName:'',
			inclbqty:'',
			qty:'',
			uomdr:'',
			uomdesc:'',
			sp:'',
			rqty:'',
			reqstkqty:'',
			stkbin:'',
			rp:'',
			spec:'',
			geneDesc:'',
			formDesc:'',
			spamt:'',
			buomdr:'',
			confac:'',
			dirtyqty:'',
			avaqty:'',
			transqty:'',
			rpamt:'',
			newsp:'',
			proLocStkQty:'' 
		});
					
		DetailStore.insert(RowNum,NewRecord);
		}
		function InsertNewInclbData(Record,newqty)
		{		
			if (Record == null || Record == "") {
				return;
			}
			var rowMainData=MasterGrid.getSelectionModel().getSelected();
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			var selectRow = cell[0];
			var thisrowData = DetailStore.getAt(selectRow);	
			var ReqLocId=rowMainData.get('toLoc'); //��������
			var inci=Record.get("IncRowId");
			var inrqi=Record.get("inrqi");
			var inci=Record.get("IncRowId");
			var incidesc=Record.get("IncDesc");
			var incicode=Record.get("IncCode");
			var reqlocqty=Record.get("reqstkqty");
			var prolocqty=Record.get("proLocStkQty");
			var inclbstr=tkMakeServerCall("web.DHCST.DHCINIsTrfItm","UpdateNewInclbForReq",inrqi,newqty)  //����inclb��ȡ����������Ϣ
			if (inclbstr=="")
		    {
				return
		    }
			var inclbstrarr
			var inclblen
			inclbstrarr=inclbstr.split("!!")
			inclblen=inclbstrarr.length
			for (i=0;i<inclblen;i++ )
			{
				if (i!=0)
				{
					insertNewRow(selectRow)	
				}
				var inclbinfo=inclbstrarr[i]
				var inclbinfoarr=inclbinfo.split("^")
				var inclb=inclbinfoarr[0]
			    var inclbqty=inclbinfoarr[1]
				var initqty=inclbinfoarr[4]
				var dirtyqty=inclbinfoarr[2]
				var availqty=inclbinfoarr[3]
				var batexp=inclbinfoarr[5]
				DetailStore.getAt(selectRow).set("inci", inci);
				DetailStore.getAt(selectRow).set("inclb", inclb);
				DetailStore.getAt(selectRow).set("batexp", batexp);
				DetailStore.getAt(selectRow).set("inclbqty", inclbqty);
				DetailStore.getAt(selectRow).set("reqstkqty", reqlocqty);
				DetailStore.getAt(selectRow).set("proLocStkQty", prolocqty);
				DetailStore.getAt(selectRow).set("dirtyqty", dirtyqty);
				DetailStore.getAt(selectRow).set("avaqty", availqty);
				DetailStore.getAt(selectRow).set("qty", initqty);
				//����ԭ������
				DetailStore.getAt(selectRow).set("cancel", thisrowData.get("cancel"));
				DetailStore.getAt(selectRow).set("initi", thisrowData.get("initi"));
				DetailStore.getAt(selectRow).set("inrqi", thisrowData.get("inrqi"));
				DetailStore.getAt(selectRow).set("incidr", thisrowData.get("incidr"));
				DetailStore.getAt(selectRow).set("incicode", thisrowData.get("incicode"));
				DetailStore.getAt(selectRow).set("incidesc", thisrowData.get("incidesc"));
				DetailStore.getAt(selectRow).set("manfName", thisrowData.get("manfName"));
				DetailStore.getAt(selectRow).set("uomdr", thisrowData.get("uomdr"));
				DetailStore.getAt(selectRow).set("uomdesc", thisrowData.get("uomdesc"));
				DetailStore.getAt(selectRow).set("sp", thisrowData.get("sp"));
				DetailStore.getAt(selectRow).set("rqty", thisrowData.get("rqty"));
				DetailStore.getAt(selectRow).set("stkbin", thisrowData.get("stkbin"));
				DetailStore.getAt(selectRow).set("rp", thisrowData.get("rp"));
				DetailStore.getAt(selectRow).set("spec", thisrowData.get("spec"));
				DetailStore.getAt(selectRow).set("geneDesc", thisrowData.get("geneDesc"));
				DetailStore.getAt(selectRow).set("formDesc", thisrowData.get("formDesc"));
				DetailStore.getAt(selectRow).set("buomdr", thisrowData.get("buomdr"));
				DetailStore.getAt(selectRow).set("confac", thisrowData.get("confac"));
				DetailStore.getAt(selectRow).set("newsp", thisrowData.get("newsp"));
				DetailStore.getAt(selectRow).set("formDesc", thisrowData.get("formDesc"));
				DetailStore.getAt(selectRow).set("formDesc", thisrowData.get("formDesc"));

			}
			DetailGrid.getView().refresh();
		}
			/***
		**����Ҽ��˵�,wyx,2014-06-23***
		**/
		//�Ҽ��˵�����ؼ����� 
		function rightClickFn(grid,rowindex,e){
			e.preventDefault(); 
			rightClick.showAt(e.getXY()); //��ȡ����
           
		}
		DetailGrid.addListener('rowcontextmenu', rightClickFn);//�Ҽ��˵�����ؼ����� 
		var rightClick = new Ext.menu.Menu({ 
			id:'rightClickCont', 
			items: [ 
				{ 
					id: 'mncancelSelectAll', 
					handler: CancelSelectAll, 
					text: 'ȫѡ������',
					click:true
					 
				},{ 
					id: 'mncancelDetails', 
					handler: CancelDetails, 
					text: '��������',
					click:true,
					hidden:(gParam[9]=='Y'?false:true)
					 
				},{ 
					id: 'mnchangeInclb', 
					handler: ChangeInclb, 
					text: '�޸�����',
					click:true					 
				},{ 
					id: 'mndelete', 
					handler: DeleteDetail, 
					text: 'ɾ��',
					click:true					 
				}
				]
		})
	// ҳ�沼��
	var mainPanel = new Ext.Viewport({
				layout : 'border',
					items : [            // create instance immediately
		            {
		            	title:'���ת��-��������',
		                region: 'north',
		                height: DHCSTFormStyle.FrmHeight(2), // give north and south regions a height
		                layout: 'fit', // specify layout manager for items
		                items:HisListTab
		            }, {
		                region: 'west',
		                title: '����',
		                collapsible: true,
		                split: true,
		                width: 400, // give east and west regions a width
		                minSize: 175,
		                maxSize: 600,
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
	
	
	/*
	* @creator: Huxt 2019-12-27
	* @desc: xml���Excel��ӡ
	*/
	function PrintTransReq(){
		var prtData = GetPrintData();
		if (prtData == null) {
			return;
		}
		PRINTCOM.XML({
			printBy: 'lodop',
			XMLTemplate: 'PHAINStockTransReq',
			data: prtData,
			listBorder: {style:4, startX:1, endX:190},
			aptListFields: ["label14", "printUserName", "label16", "perintDate"],
			page: {rows:28, x:4, y:4, fontname:'����', fontbold:'false', fontsize:'12', format:'��{1}ҳ/��{2}ҳ'},
		});
	}
	
	/*
	* @desc: ��ȡ��ӡ���ݵ�json��ʽ
	*/
	function GetPrintData(){
		var nowdate = new Date();
		var pritntimenow = nowdate.getFullYear()+"-"+(nowdate.getMonth()+1)+"-"+nowdate.getDate()+" "+(nowdate.getHours())+":"+(nowdate.getMinutes())+":"+(nowdate.getSeconds());
		var rowCount = DetailStore.getCount();
		if (rowCount == 0) {
			Msg.info("warning", "û����ϸ����!");
			return null;
		}
		var gTotalNum = rowCount;
		
		//����Ϣ
		var rowMainData = MasterGrid.getSelectionModel().getSelected();
		if(rowMainData == null || rowMainData==""){
			Msg.info("warning", "û��ѡ�������!");
			return null;
		} else {
			var prolocdesc = rowMainData.get('frLocDesc');
			var reqlocdesc = rowMainData.get('toLocDesc');
			var reqno = rowMainData.get('reqNo');
		}
		var Para = {
			title: App_LogonHospDesc + prolocdesc + "���ŵ�",
			reqNo: reqno,
			reqlocdesc: reqlocdesc,
			printUserName: session['LOGON.USERNAME'],
			perintDate: pritntimenow
		}
		
		var sumspamt = 0;
		var List = [];
		for(var i=0; i<rowCount; i++){
			var rowData = DetailStore.getAt(i);
			var incidesc = rowData.get("incidesc"); //����
			var formDesc = rowData.get("formDesc"); //����
			var rqty = rowData.get("rqty"); //������
			var qty = rowData.get("qty"); //ʵ����
			var uomdesc = rowData.get("uomdesc"); //��λ
			var sp = rowData.get("sp");
			var spamt = rowData.get("spamt");
			var inclbqty = rowData.get("inclbqty");
			var diffflag = parseFloat(inclbqty)<parseFloat(rqty) ? "��" : "";
			List.push({
				num: i+1,
				incidesc: incidesc,
				formDesc: formDesc,
				rqty: rqty,
				qty: qty,
				uomdesc: uomdesc,
				sp: sp,
				spamt: spamt,
				diffflag: diffflag
			});
			sumspamt = sumspamt + parseFloat(spamt);
		}
		//�ϼ���
		List.push({num: "",incidesc: "�ϼ�",formDesc: "",rqty: "",qty: "",uomdesc: "",sp: "",spamt: sumspamt.toFixed(2),diffflag: ""});
		
		return {
			Para: Para,
			List: List
		}
	}
	
})

