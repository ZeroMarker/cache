// /����: ������ⵥ����
// /����: ������ⵥ����
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.27
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gInitId='';
var timer=null; ///����ȫ�ֱ�����ʱ��   ��ֹȫѡ��ʱ�� ִ�ж�β�ѯ������
	var reqidstr='';
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	//ȡ��ֵ�������
	var UseItmTrack="";
	if(gItmTrackParam.length<1){
		GetItmTrackParam();
		UseItmTrack=gItmTrackParam[0]=='Y'?true:false;
	}
	
	// ������
	var RequestPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '������',
				id : 'RequestPhaLoc',
				name : 'RequestPhaLoc',
				anchor : '90%',
				emptyText : '������...',
				listWidth : 250,
				defaultLoc:''
			});
		
	// ��������
	var SupplyPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '��������',
				id : 'SupplyPhaLoc',
				name : 'SupplyPhaLoc',
				anchor : '90%',
				emptyText : '��������...',
				listWidth : 250,
				groupId : session['LOGON.GROUPID'],
				childCombo : 'Vendor'
			});
			
	var VirtualFlag = new Ext.form.Checkbox({
			hideLabel:true,
			boxLabel : G_VIRTUAL_STORE,
			id : 'VirtualFlag',
			name : 'VirtualFlag',
			anchor : '90%',
			checked : false,
			listeners:{
				check:function(chk,bool){
					if(bool){
						var phaloc=Ext.getCmp("SupplyPhaLoc").getValue();
						var url="dhcstm.utilcommon.csp?actiontype=GetMainLoc&loc="+phaloc;
						var response=ExecuteDBSynAccess(url);
						var jsonData=Ext.util.JSON.decode(response);
						if(jsonData.success=='true'){
							var info=jsonData.info;
							var infoArr=info.split("^");
							var vituralLoc=infoArr[0],vituralLocDesc=infoArr[1];
							addComboData(Ext.getCmp("SupplyPhaLoc").getStore(),vituralLoc,vituralLocDesc);
							Ext.getCmp("SupplyPhaLoc").setValue(vituralLoc);
						}
					}else{
						SetLogInDept(Ext.getCmp("SupplyPhaLoc").getStore(), "SupplyPhaLoc");
					}
				}
			}
		});
			
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '��ʼ����',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				value : DefaultStDate()
			});
	// ��ֹ����
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '��ֹ����',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				value : DefaultEdDate()
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
	// ��������
	var Vendor = new Ext.ux.VendorComboBox({
			fieldLabel : '��Ӧ��',
			id : 'Vendor',
			name : 'Vendor',
			anchor : '90%',
			listWidth : 250,
			params : {LocId : 'SupplyPhaLoc'}
		});
		
	// ��ѯת�Ƶ���ť
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : '��ѯ',
				tooltip : '�����ѯ��ⵥ',
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
		Ext.getCmp("VirtualFlag").setValue(false);
		Ext.getCmp("RequestPhaLoc").setValue("");
		Ext.getCmp("SupplyPhaLoc").setDisabled(0);
		Ext.getCmp("Vendor").setValue("");
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 7));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("TransStatus").setValue(false);
		MasterGrid.store.removeAll();
		DetailGrid.getView().refresh();
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
					if(DetailGrid.activeEditor!=null){
						DetailGrid.activeEditor.completeEdit();
					}
					save();
				}
			});

	/**
	 * ����ת�Ƶ�
	 */
	function save() {
	var recarr=MasterGrid.getSelectionModel().getSelections();
		var count=recarr.length;
		var HVInIsTrfFlag = false;		//��ֵת�Ƶ���־,ȱʡfalse
		var selectRecords = MasterGrid.getSelectionModel().getSelections();
		if(selectRecords=="" || selectRecords=='undefined'){
			Msg.info("warning","û��ѡ�е���ⵥ!");
			return;
		}
		var record = selectRecords[0];
		var Status = record.get("Status");				
		if (Status =="��ת��") {
			Msg.info("warning", "����ⵥ�Ѿ����⣬�����ٳ���!");
			
			return;
		}			
		
		//��Ӧ����RowId^�������RowId^���ת������RowId^��������RowId^��ɱ�־^����״̬^�Ƶ���RowId^����RowId^�������^��ע
		var inItNo = '';
		var supplyPhaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
		var requestPhaLoc = Ext.getCmp("RequestPhaLoc").getValue();
		if(requestPhaLoc==null || requestPhaLoc.length<1){
			Msg.info("warning", "��ѡ���������!");
			return;
		}
		if(supplyPhaLoc==requestPhaLoc){
			Msg.info("warning", "������Ҳ��ܺ͹���������ͬ!");
			return;
		}
	var reqidstr=""
		for (i=0;i<count;i++)
		{
			var rec=recarr[i];
			var reqid=rec.get('IngrId');
			if (reqidstr=="")
			 {reqidstr=reqid}
			 else
			 {reqidstr=reqidstr+","+reqid}
				
		}
		var ingrid=record.get("IngrId");
		var reqid='';
		var operatetype = '';	
		var Complete='N';
		var Status=10;
		var StkGrpId =record.get("StkGrpId");	
		var StkType = App_StkTypeCode;					
		var remark = '';
		
		var MainInfo = supplyPhaLoc + "^" + requestPhaLoc + "^" + reqid + "^" + operatetype + "^"
				+ Complete + "^" + Status + "^" + userId + "^"+StkGrpId+"^"+StkType+"^"+remark+"^"+reqidstr;
		//��ϸid^����id^����^��λ^������ϸid^��ע
		var ListDetail="";
		var rowCount = DetailGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailStore.getAt(i);					
			var Initi = '';
			var Ingri = rowData.get("Ingri");
			var Inclb = rowData.get("Inclb");
			var Qty = rowData.get("TrQty");
			if(Qty==0){
				continue;
			}
			var UomId = rowData.get("TrUomId");
			var BUomId = rowData.get("BUomId");
			/*
			if(BUomId==UomId && (Qty!=0 && Qty%1!=0)){
				Msg.info("warning","ת�Ƶ�λ�ǻ�����λʱ���������������!");
				return;
			}
			*/
			var ReqItmId = '';
			var Remark ='';
			var HVFlag = rowData.get("HVFlag");
			var HVBarCode = rowData.get("HVBarCode");
			if(HVBarCode!=""){
				if(Qty!=0 && Qty!=1){
					Msg.info("warning","��ֵ��������ֻ��Ϊ1��0!");
					return;
				}else if(!CheckBarcode(HVBarCode)){
					return;
				}else{
					HVInIsTrfFlag = true;
				}
			}
			var str = Initi + "^" + Inclb + "^"	+ Qty + "^" + UomId + "^" + ReqItmId
					+ "^" + Remark + "^" + HVBarCode + "^^^" + Ingri;
			if(ListDetail==""){
				ListDetail=str;
			}
			else{
				ListDetail=ListDetail+xRowDelim()+str;
			}				
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
							if(HVInIsTrfFlag){
								window.location.href='dhcstm.dhcinistrfhv.csp?Rowid='+InitRowid+'&QueryFlag=1';
							}else{
								window.location.href='dhcstm.dhcinistrf.csp?Rowid='+InitRowid+'&QueryFlag=1';
							}
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

	/*
	 * ��������Ƿ����ת�Ƴ���
	 */
	function CheckBarcode(Barcode) {
		var url='dhcstm.itmtrackaction.csp?actiontype=GetItmByBarcode&Barcode='+Barcode;
		var itmResult=ExecuteDBSynAccess(url);
		var itmInfo=Ext.util.JSON.decode(itmResult);
		if(itmInfo.success == 'true'){
			var itmArr=itmInfo.info.split("^");
			var status=itmArr[0],type=itmArr[1],lastDetailAudit=itmArr[2],lastDetailOperNo=itmArr[3];
			var inclb=itmArr[4],inciDr=itmArr[5],inciCode=itmArr[6],inciDesc=itmArr[7],scgID=itmArr[8],scgDesc=itmArr[9];
			if(inclb==""){
				Msg.info("warning",Barcode+"û����Ӧ����¼,�����Ƶ�!");
				return false;
			}else if(lastDetailAudit!="Y"){
				Msg.info("warning",Barcode+"��δ��˵�"+lastDetailOperNo+",���ʵ!");
				return false;
			}else if(type=="T"){
				Msg.info("warning",Barcode+"�Ѿ�����,�����Ƶ�!");
				return false;
			}else if(status!="Enable"){
				Msg.info("warning",Barcode+"���ڲ�����״̬,�����Ƶ�!");
				return false;
			}
			
			var phaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
			var phaLocRQ = Ext.getCmp("RequestPhaLoc").getValue();
			var url = "dhcstm.drugutil.csp?actiontype=GetDrugBatInfo&IncId="+inciDr
				+"&ProLocId="+phaLoc+"&ReqLocId="+phaLocRQ+"&QtyFlag=1"+"&StkType="+App_StkTypeCode+"&Inclb="+inclb+"&start=0&limit=1";
			var LBResult=ExecuteDBSynAccess(url);
			var info=Ext.util.JSON.decode(LBResult);
			if(info.results=='0'){
				Msg.info("warning",Barcode+"û����Ӧ����¼,�����Ƶ�!");
				return false;
			}
			return true;
		}else{
			Msg.info("error",Barcode+"��δע��!");
			return false;
		}
	}
						
	/**
	 * ɾ��ѡ��������
	 */
	function deleteDetail() {
		// �ж�ת�Ƶ��Ƿ������
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "û��ѡ����!");
			return;
		}
		// ѡ����
		var row = cell[0];
		var record = DetailGrid.getStore().getAt(row);			
		DetailGrid.getStore().remove(record);
	
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
			
	CTUom.on('beforequery', function(e) {
				CTUom.store.removeAll();
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);
				var InciDr = record.get("IncId");
				var url = DictUrl
						+ 'drugutil.csp?actiontype=INCIUom&ItmRowid='
						+ InciDr;
				CTUomStore.proxy = new Ext.data.HttpProxy({
							url : url
						});
				CTUom.store.load();
			});

	/**
	 * ��λ�任�¼�
	 */
	CTUom.on('select', function(combo) {
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);
				
				var value = combo.getValue();        //Ŀǰѡ��ĵ�λid
				var BUom = record.get("BUomId");
				var ConFac = record.get("ConFacPur");   //��λ��С��λ��ת����ϵ					
				var TrUom = record.get("TrUomId");    //Ŀǰ��ʾ�ĳ��ⵥλ
				var Sp = record.get("Sp");
				var Rp = record.get("Rp");
				var InclbQty=record.get("StkQty");
				var DirtyQty=record.get("DirtyQty");
				var AvaQty=record.get("AvaQty");
				var TrQty=record.get("TrQty");
				if (value == null || value.length <= 0) {
					return;
				} else if (TrUom == value) {
					return;
				} else if (value==BUom) {     //��ѡ��ĵ�λΪ������λ��ԭ��ʾ�ĵ�λΪ��λ
					record.set("Sp", accDiv(Sp,ConFac));
					record.set("Rp", accDiv(Rp,ConFac));
					record.set("StkQty", accMul(InclbQty,ConFac));
					record.set("DirtyQty", accMul(DirtyQty,ConFac));
					record.set("AvaQty", accMul(AvaQty,ConFac));
					record.set("TrQty", accMul(TrQty,ConFac));
				} else{  //��ѡ��ĵ�λΪ��λ��ԭ���ǵ�λΪС��λ
					record.set("Sp", accMul(Sp,ConFac));
					record.set("Rp", accMul(Rp,ConFac));
					record.set("StkQty", accDiv(InclbQty,ConFac));
					record.set("DirtyQty", accDiv(DirtyQty,ConFac));
					record.set("AvaQty", accDiv(AvaQty,ConFac));
					record.set("TrQty", accDiv(TrQty,ConFac));
				}
				record.set("TrUomId", combo.getValue());
	});
	
	// ��ʾ��ⵥ����
	function Query() {
		var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
		if (supplyphaLoc =='' || supplyphaLoc.length <= 0) {
			Msg.info("warning", "��ѡ�񹩸�����!");
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
		var status = (Ext.getCmp("TransStatus").getValue()==true?1:0);
		var Vendor = Ext.getCmp("Vendor").getValue();
		
		var ListParam=startDate+'^'+endDate+'^^'+Vendor+'^'+supplyphaLoc+'^'+status+'^'+requestphaLoc;
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam("ParamStr",ListParam);
		
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		MasterStore.removeAll();
		MasterStore.load({
			params:{start:0, limit:Page},
			callback:function(r,options, success){
				if(success==false){
     				Msg.info("error", "��ѯ������鿴��־!");
     			}else{
     				if(r.length>=1){
     					MasterGrid.getSelectionModel().selectFirstRow();
						MasterGrid.getView().focusRow(0);
     				}
     			} 
			}		
		});
	}
	// ��ʾ��ⵥ��ϸ����
	function getDetail(Parref) {
		if (Parref == null || Parref=='') {
			return;
		}
		DetailStore.load({params:{start:0,limit:999,Parref:Parref}});
	}
	
	// ����·��
	var MasterUrl = DictUrl	+ 'dhcinistrfaction.csp?actiontype=QueryImport';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["IngrId", "IngrNo", "RecLoc", "ReqLoc", "Vendor","CreateUser", "CreateDate","Status","StkGrpId","StkGrpDesc"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "IngrId",
				fields : fields
			});
	// ���ݼ�
	var MasterStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
var	sm1=new Ext.grid.CheckboxSelectionModel({checkOnly:true})
	var MasterCm = new Ext.grid.ColumnModel([nm,sm1, {
				header : "RowId",
				dataIndex : 'IngrId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "��ⵥ��",
				dataIndex : 'IngrNo',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : "������",
				dataIndex : 'ReqLoc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'RecLoc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "�������",
				dataIndex : 'CreateDate',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : "��Ӧ��",
				dataIndex : 'Vendor',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "�����",
				dataIndex : 'CreateUser',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "ת��״̬",
				dataIndex : 'Status',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'StkGrpDesc',
				width : 80,
				align : 'right',
				sortable : true
			}]);
	MasterCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true
	});
	var MasterGrid = new Ext.ux.GridPanel({
 id:'MasterGrid',
				region: 'west',
				title: '��ⵥ',
				collapsible: true,
				split: true,
				width: 300,
				minSize: 175,
				maxSize: 400,
				cm : MasterCm,
				sm:sm1,
				store : MasterStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:[GridPagingToolbar]
			});
	// ��ӱ�񵥻����¼�
	MasterGrid.getSelectionModel().on('selectionchange', function(ssm){
	clearTimeout(timer)
	timer=change.defer(100,this,[ssm])
	});
	
	function change(ssm){
		var recarr=ssm.getSelections();
		var count=recarr.length;
		var reqidstr=""
		for (i=0;i<count;i++)
		{
			var rec=recarr[i];
			var reqid=rec.get('IngrId');
			if (reqidstr=="")
			 {reqidstr=reqid}
			 else
			 {reqidstr=reqidstr+","+reqid}
				//alert(reqidstr)
		}
		reqidstr=reqidstr
		DetailStore.removeAll();
		DetailStore.setBaseParam('req',reqidstr);
		//DetailStore.setBaseParam('refuseflag',0);
		DetailStore.load({params:{Parref:reqidstr}});
	
	}
	
	// ת����ϸ
	// ����·��
	var DetailUrl =DictUrl+
		'dhcinistrfaction.csp?actiontype=QueryImportDetail&Parref=&start=0&limit=999';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	
	// ָ���в���
	var fields = ["Ingri", "BatchNo", "TrUomId","TrUom","ExpDate", "Inclb", "TrQty", "IncId",
			 "IncCode", "IncDesc", "Manf","Rp","RpAmt", "Sp", "SpAmt", "BUomId",
			 "ConFacPur", "StkQty", "DirtyQty","AvaQty","BatExp","HVFlag","HVBarCode"
			];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "Ingri",
				fields : fields
			});
	// ���ݼ�
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
				header : "�����ϸid",
				dataIndex : 'Ingri',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "����RowId",
				dataIndex : 'IncId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '���ʴ���',
				dataIndex : 'IncCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '��������',
				dataIndex : 'IncDesc',
				width : 230,
				align : 'left',
				sortable : true
			}, {
				header : "����RowId",
				dataIndex : 'Inclb',
				width : 180,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "����~Ч��",
				dataIndex : 'BatExp',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "��ֵ��־",
				dataIndex : 'HVFlag',
				width : 80,
				align : 'center',
				sortable : true,
				hidden : true
			},{
				header : "��ֵ����",
				dataIndex : 'HVBarCode',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "���ο��",
				dataIndex : 'StkQty',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "ת������",
				dataIndex : 'TrQty',
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
								var cell = DetailGrid.getSelectionModel()
										.getSelectedCell();
								var record = DetailGrid.getStore()
										.getAt(cell[0]);
								var salePriceAMT = record
										.get("Sp")
										* qty;
								record.set("SpAmt",
										salePriceAMT);
								var AvaQty = record.get("AvaQty");
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
				dataIndex : 'TrUomId',
				width : 50,
				align : 'left',
				sortable : true,
				renderer : Ext.util.Format.comboRenderer2(CTUom,"TrUomId","TrUom"),
				editor : new Ext.grid.GridEditor(CTUom)
			}, {
				header : "����",
				dataIndex : 'Rp',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "�ۼ�",
				dataIndex : 'Sp',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "���۽��",
				dataIndex : 'RpAmt',
				width : 100,
				align : 'right',
				summaryType : 'sum',
				sortable : true
			}, {
				header : "�ۼ۽��",
				dataIndex : 'SpAmt',
				width : 100,
				align : 'right',
				summaryType : 'sum',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "ռ������",
				dataIndex : 'DirtyQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'AvaQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "ת����",
				dataIndex : 'ConFacPur',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "������λ",
				dataIndex : 'BUomId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}]);

	var DetailGrid = new Ext.ux.GridPanel({
				region : 'center',
				title : '��ⵥ��ϸ',
				id : 'DetailGrid',
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				sm : new Ext.grid.CellSelectionModel({}),
				clicksToEdit : 1,
				plugins : new Ext.grid.GridSummary()
			});

	DetailGrid.on('beforeedit',function(e){
		if(e.field=="TrQty" || e.field=="TrUomId"){
			var rowData=MasterGrid.getSelectionModel().getSelected();
			if(rowData!=null && rowData!=""){
				if(rowData.get('Status')=='��ת��'){
					e.cancel=true;	//��ת�Ƶĵ���,�����޸�ת������
				}
			}
			if(e.record.get('HVBarCode')!=""){
				e.cancel=true;
			}
		}
	});
			
	/***
	**����Ҽ��˵�
	**/		
	DetailGrid.addListener('rowcontextmenu', rightClickFn);//�Ҽ��˵�����ؼ����� 
	var rightClick = new Ext.menu.Menu({ 
		id:'rightClickCont', 
		items: [ 
			{ 
				id: 'mnuDelete', 
				handler: deleteDetail, 
				text: 'ɾ��' 
			}
		] 
	}); 
	
	//�Ҽ��˵�����ؼ����� 
	function rightClickFn(grid,rowindex,e){ 
		e.preventDefault();
		grid.getSelectionModel().select(rowindex,0);
		rightClick.showAt(e.getXY()); 
	}

	// �任����ɫ
	function changeBgColor(row, color) {
		DetailGrid.getView().getRow(row).style.backgroundColor = color;
	}

	var HisListTab = new Ext.ux.FormPanel({
		title:'���ת��-������ⵥ',
		labelWidth: 80,
		tbar : [SearchBT, '-',  ClearBT, '-', SaveBT],
		items : [{
			layout: 'column',    // Specifies that the items will now be arranged in columns
			xtype:'fieldset',
			title:'��ѯ����',
			style : 'padding:5px 0px 0px 5px',
			defaults: {width: 220, border:false},    // Default config options for child items
			items:[{
				columnWidth: 0.3,
				xtype: 'fieldset',
				items: [SupplyPhaLoc,Vendor]
			},{
				columnWidth: UseItmTrack?0.1:0.01,
				xtype: 'fieldset',
				items: UseItmTrack?[VirtualFlag]:[]
			},{
				columnWidth: 0.3,
				xtype: 'fieldset',
				items: [StartDate,EndDate]
			},{
				columnWidth: 0.3,
				xtype: 'fieldset',
				items: [RequestPhaLoc,TransStatus]
			}]
		}]
	});

	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [HisListTab, MasterGrid, DetailGrid],
				renderTo : 'mainPanel'
			});
})