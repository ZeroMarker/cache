// /����: ����ת�������Ƶ�
// /����: ����ת�������Ƶ�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.10.12
var timer=null; ///����ȫ�ֱ�����ʱ��   ��ֹȫѡ��ʱ�� ִ�ж�β�ѯ������
var SelReq=function(SupplyLocId,Fn,Fn1) {
	var userId = session['LOGON.USERID'];
	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var ReqHosp = new Ext.ux.ComboBox({
	fieldLabel : '�������Ժ��',
	id : 'ReqHosp',
	anchor : '90%',
	store : HospStore
});
	// ������
	var RequestPhaLocS = new Ext.ux.LocComboBox({
		fieldLabel : '������',
		id : 'RequestPhaLocS',
		name : 'RequestPhaLocS',
		emptyText:'������',
		anchor : '90%',
		defaultLoc:{}
	}); 
	
	// ��ʼ����
	var StartDateS = new Ext.ux.DateField({
				fieldLabel : '��ʼ����',
				id : 'StartDateS',
				name : 'StartDate',
				anchor : '90%',
				value : DefaultStDate()
			});
	// ��ֹ����
	var EndDateS = new Ext.ux.DateField({
				fieldLabel : '��ֹ����',
				id : 'EndDateS',
				name : 'EndDate',
				anchor : '90%',
				value : DefaultEdDate()
			});
	
	// ��������ת��
	var PartlyStatusS = new Ext.form.Checkbox({
				boxLabel : '��������ת��',
				hideLabel : true,
				id : 'PartlyStatusS',
				name : 'PartlyStatus',
				anchor : '90%',
				checked : false,
				disabled : false
			});
	
	// ��ʾ�����ת�Ƶ�������ϸ
	var ShowTransfered = new Ext.form.Checkbox({
				boxLabel : '��ʾת�����',
				hideLabel : true,
				id : 'ShowTransfered',
				name : 'ShowTransfered',
				anchor : '90%',
				checked : false,
				disabled : false
			});
	var includeDefLoc=new Ext.form.Checkbox({
			id: 'includeDefLoc',
			boxLabel : '����֧�����',
			hideLabel : true,
			allowBlank:true
	});
	var reqTypeGroup=new Ext.form.RadioGroup({
		id:'reqTypeGroup',
		columns: 1,
		anchor : '90%',
		fieldLabel:'��������',
		defaults : {height : 20},
		items:[
			{boxLabel: 'ȫ��', name: 'reqType', inputValue: 'OC'},
			{boxLabel: '��ʱ����', name: 'reqType', inputValue: 'O',checked:true},
			{boxLabel: '����ƻ�', name: 'reqType', inputValue: 'C'}
		 ]
	});
	var ifShowTrf=new Ext.form.Checkbox({
			id: 'ifShowTrf',
			boxLabel :'��ʾ�ѳ�����ϸ',
			checked : true,
			allowBlank:true
	});
	// ��������
		var inciDesc = new Ext.form.TextField({
			fieldLabel : '��������',
			id : 'inciDesc',
			name : 'inciDesc',
			anchor : '90%',
			width : 150,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						GetPhaOrderInfo(field.getValue(),"");
					}
				}
			}
		});

		/**
		 * �������ʴ��岢���ؽ��
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
			if (record == null || record == "") {
				return;
			}
			var InciDesc=record.get("InciDesc");
			Ext.getCmp("inciDesc").setValue(InciDesc);
		}
		
	// 3�رհ�ť
	var closeBTS = new Ext.Toolbar.Button({
				text : '�ر�',
				tooltip : '�رս���',
				iconCls : 'page_delete',
				width : 70,
				height : 30,
				handler : function() {
					findWin.close();
				}
			});
			
	// ��ѯ���󵥰�ť
	var SearchBTS = new Ext.Toolbar.Button({
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
    // �˻����밴ť
	var returnDataBT = new Ext.Toolbar.Button({
				text : '�˻�����',
				tooltip : '����˻�ת����Ϣ',
				iconCls : 'page_gear',
				height:30,
				width:70,
				handler : function() {
					returnDurgData();				
				}
			});	
	// �ܾ����밴ť
	var refDetailBT = new Ext.Toolbar.Button({
				text : '�ܾ�һ����ϸ',
				tooltip : '����ܾ�ת����Ϣ',
				iconCls : 'page_gear',
				height:30,
				width:70,
				handler : function() {
					refDetail();
				}
			});	
	/////�ܾ�������ϸ
	function refDetail(){		
		var selectRow=DetailGridS.getSelectionModel().getSelected();
		if (Ext.isEmpty(selectRow)){
			  Msg.info("warning", "��ѡ��Ҫ�ܾ�����ϸ��¼!");
			  return;
		}
		var reqi=selectRow.get("rowid");
		var mask=ShowLoadMask('findWin',"�����˻����뵥...");
		var url=DictUrl+"inrequestaction.csp?actiontype=refuse&reqi="+reqi;
		var responsetext=ExecuteDBSynAccess(url);
		var jsonData = Ext.util.JSON.decode(responsetext);
		mask.hide();
		if (jsonData.success == 'true') {
			// ˢ�½���
          Msg.info("success", "�ܾ����뵥��ϸ�ɹ�!");
			DetailStore.reload()

		} else {
			Msg.info("error", "�ܾ����뵥ʧ��!");
		
		}	
	 }
	// ��հ�ť
	var ClearBTS = new Ext.Toolbar.Button({
				id : "ClearBTSR",
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
		Ext.getCmp("RequestPhaLocS").setValue("");
		Ext.getCmp("inciDesc").setValue("");
		Ext.getCmp("StartDateS").setValue(DefaultStDate());
		Ext.getCmp("EndDateS").setValue(DefaultEdDate());
		Ext.getCmp("PartlyStatusS").setValue(false);
		Ext.getCmp("ShowTransfered").setValue(false);
		MasterGridS.store.removeAll();
		MasterGridS.getView().refresh();
		DetailGridS.store.removeAll();
		DetailGridS.getView().refresh();		
	}

	// ���水ť
	var SaveBTS = new Ext.ux.Button({
				id : "SaveBTS",
				text : '���ɳ��ⵥ',
				tooltip : '�ù��ܿ���ѡ��������һ�����ɳ��ⵥ',
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {

					// ����ת�Ƶ�
					if(CheckDataBeforeSave()==true){
						save();
					}
				}
			});

	
	/**
	 * ������ⵥǰ���ݼ��
	 */		
	function CheckDataBeforeSave() {
		if (SupplyLocId == null || SupplyLocId.length <= 0) {
			Msg.info("warning", "��رմ��ڣ�ѡ��Ӧ����!");
			return false;
		}
		return true;
	}
	
 /**
	 * �˻�����
	 */	
 function returnDurgData(){
		var InitRowid="";
		var supplyPhaLoc =SupplyLocId;
		var requestPhaLoc = Ext.getCmp("RequestPhaLocS").getValue();
		var selectRow=MasterGridS.getSelectionModel().getSelected();
		if(typeof(selectRow) == "undefined"){
			Msg.info("warning","û��Ҫ���������!");
			return;
		}
		var reqid=selectRow.get("req");
		if(reqid==null || reqid==""){
			Msg.info("warning","��ѡ��Ҫ���������!");
			return;
		}
		var mask=ShowLoadMask('findWin',"�����˻����뵥...");
		var url=DictUrl+"inrequestaction.csp?actiontype=CancelComp&req="+reqid+"&flag=T";
		var responsetext=ExecuteDBSynAccess(url);
		var jsonData = Ext.util.JSON.decode(responsetext);
		mask.hide();
		if (jsonData.success == 'true') {
			// ˢ�½���
			Msg.info("success", "�˻����뵥�ɹ�!");
			Query()
		} else {
			var Ret=jsonData.info;
			if(Ret==-11){
				Msg.info("error", "���������,�����˻�����!");
			}else if(Ret==-12){
				Msg.info("error", "���������,�����˻�����!");
			}else if(Ret==-13){
				Msg.info("error", "��Ӧ�������,�����˻�����!");
			}else if(Ret==-1){
				Msg.info("error", "�������Ѵ���,�����˻�����!");
			}else{
				Msg.info("error", "�˻����뵥ʧ��!"+Ret);
			}
		}
	 }
	/**
	 * ����ת�Ƶ�
	 */
	function save() {
		var recarr=MasterGridS.getSelectionModel().getSelections();
		var count=recarr.length;
		if(count==0){Msg.info("warning","��ѡ��Ҫ���������!");return};
		
		var reqidstr=""
		for (i=0;i<count;i++)
		{
			var rec=recarr[i];
			var reqid=rec.get('req');
			if (reqidstr=="")
			 {reqidstr=reqid}
			 else
			 {reqidstr=reqidstr+","+reqid}
				
		}
		//��Ӧ����RowId^�������RowId^�Ƶ���RowId
		var InitRowid="";
		var supplyPhaLoc =SupplyLocId;
		var requestPhaLoc = ""  ///Ext.getCmp("RequestPhaLocS").getValue();
		
		var issplit=IsSplit();
		var outType=OutType();
		
		var mask=ShowLoadMask(findWin.body, "�������ɳ��ⵥ...");
		var MainInfo = supplyPhaLoc + "^" + requestPhaLoc + "^" + userId +"^"+issplit+"^"+outType;
		if(UseItmTrack){
			var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=CreateTransferByReqStrHV&MainInfo=" + MainInfo+"&ReqIdStr="+reqidstr;
		}else{
			var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=CreateTransferByReqStr&MainInfo=" + MainInfo+"&ReqIdStr="+reqidstr;
		}
		var responsetext=ExecuteDBSynAccess(url);
		var jsonData = Ext.util.JSON.decode(responsetext);
		mask.hide();
		if (jsonData.success == 'true') {
			// ˢ�½���
			InitRowidStr = jsonData.info;
			//Msg.info("success", "���ɳ��ⵥ�ɹ�!");
			findWin.close();
			Fn1(InitRowidStr);
		} else {
			var ret=jsonData.info;
			if(ret==-99){
				Msg.info("error", "����ʧ��,�������ɳ��ⵥ!");
			}else if(ret==-2){
				Msg.info("error", "���ɳ��ⵥ��ʧ��!");
			}else if(ret==-1){
				Msg.info("error", "���ɳ��ⵥʧ��!");
			}else if(ret==-5){
				Msg.info("error", "���ɳ��ⵥ��ϸʧ��!");
			}else if(ret==-7){
				Msg.info("error", "û����Ҫת�Ƶ���ϸ���ݻ���ÿ�治��!");
			}else if(ret==-101){
				Msg.info("error", "�����쵥�Ѿ�ȡ�������!!");
			}else {
				Msg.info("error", "���ɳ��ⵥʧ�ܣ�"+ret);
			}
		}
	}
	
	//ѡȡ��ť
	var SelectBTS = new Ext.ux.Button({
		id : "SelectBTS",
		text : 'ѡȡ',
		tooltip : '�ù���ֻ��ѡ��һ������',
		width : 70,
		height : 30,
		iconCls : 'page_save',
		handler : function() {
			var selectRows = MasterGridS.getSelectionModel().getSelections();
			if (selectRows.length > 1) {
				Ext.MessageBox.show({
								title : '��ʾ',
								msg : '�ù���ֻ��ѡһ�������Ƿ��������?',
								buttons : Ext.MessageBox.YESNO,
								fn: function(b,t,o){
									if (b=='yes'){
										SelectReq();
									}
								},
								icon : Ext.MessageBox.QUESTION
							});
			}else{
				SelectReq();
			}
		}
	});	
	
	//ѡȡ����
	function SelectReq(){
		var selectRows = MasterGridS.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Msg.info("warning", "��ѡ��Ҫ���ص�ת�Ƶ���Ϣ��");
			return;
		}
		var Reqstore = DetailGridS.getStore();
		if(Reqstore.getCount()<0 ){
			Msg.info("warning", "ת�Ƶ���ϸΪ�գ�");
			return;
		}
		var req = selectRows[0].get("req");
		var reqNo = selectRows[0].get("reqNo");
		var toLoc = selectRows[0].get("toLoc");
		var toLocDesc = selectRows[0].get("toLocDesc");
		var frLoc = selectRows[0].get("frLoc");
		var frLocDesc = selectRows[0].get("frLocDesc");
		var comp = selectRows[0].get("comp");
		var userName = selectRows[0].get("userName");
		var status = selectRows[0].get("status");
		var transferStatus = selectRows[0].get("transferStatus");
		var Remarks = selectRows[0].get("Remarks");
		var HVFlag = selectRows[0].get("HVFlag");
		var reqscg = selectRows[0].get("reqscg");  
		var reqscgdesc = selectRows[0].get("reqscgdesc");
		var ExpressFlag=selectRows[0].get("ExpressFlag");
        var datastr=req+"^"+reqNo+"^"+toLoc+"^"+toLocDesc+"^"+frLoc+"^"+frLocDesc+"^"+comp+"^"+userName+"^"+status+"^"+transferStatus+"^"+Remarks+"^"+HVFlag+"^"+reqscg+"^"+reqscgdesc+"^"+ExpressFlag
		var requestPhaLoc = ""  
		var issplit=IsSplit();
		var outType=OutType();
        var Mainstr = SupplyLocId + "^" + requestPhaLoc + "^" + userId +"^"+issplit+"^"+outType;
        var strinfo=Mainstr+"^"+req
        if(datastr!=""){
    		Fn(datastr,strinfo)
        }else 
        	{
        	   Msg.info("warning", "��ѡ��Ҫ���ص�ת�Ƶ���Ϣ��");
        	}
		findWin.close();
	}

	// ��ʾ��������
	function Query() {
		var provlocAuditRequired=ProvLocAuditRequired();
		var issplit=IsSplit();
		var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();  //SupplyLocId;
		if (supplyphaLoc =='' || supplyphaLoc.length <= 0) {
			Msg.info("warning", "��ѡ��Ӧ����!");
			return;
		}
		var requestphaLoc = Ext.getCmp("RequestPhaLocS").getValue();
		var inciDesc = Ext.getCmp("inciDesc").getValue();
		var startDate = Ext.getCmp("StartDateS").getValue();
		var endDate = Ext.getCmp("EndDateS").getValue();
		if(startDate!=""){
			startDate = startDate.format(ARG_DATEFORMAT);
		}
		if(endDate!=""){
			endDate = endDate.format(ARG_DATEFORMAT);
		}
		var partlyStatus = (Ext.getCmp("PartlyStatusS").getValue()==true?1:0);
		var allStatus = (Ext.getCmp("ShowTransfered").getValue()==true?1:0);
		var reqType=Ext.getCmp("reqTypeGroup").getValue().getGroupValue();
		var HV = gHVInIsTrf? "Y" : UseItmTrack? "N" : "";
		var includeDefLoc=(Ext.getCmp('includeDefLoc').getValue()==true?1:0);  //�Ƿ����֧�����
		var ReqHosp=Ext.getCmp("ReqHosp").getValue();
		var ListParam=startDate+'^'+endDate+'^'+supplyphaLoc+'^'+requestphaLoc+'^'+partlyStatus
				+'^'+allStatus+"^"+provlocAuditRequired+'^'+reqType+'^'+issplit+'^'+inciDesc
				+'^'+HV+'^'+userId+"^"+includeDefLoc+"^"+ReqHosp;
		
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam('ParamStr',ListParam);
		MasterStore.removeAll();
		MasterStore.load({
			params:{start:0, limit:Page},
			callback : function(r,options, success){
					if(success==false){
						Msg.info("error", "��ѯ������鿴��־!");
					}else{
						if(r.length>0){
							MasterGridS.getSelectionModel().selectFirstRow();
							MasterGridS.getView().focusRow(0);
						}
					}
				}
		});
	
		DetailGridS.store.removeAll();
		DetailGridS.getView().refresh();
	}
	
	// ����·��
	var MasterUrl = DictUrl	+ 'dhcinistrfaction.csp?actiontype=QueryReq';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["req", "reqNo", "toLoc","toLocDesc","frLoc","frLocDesc", "date","time", "comp", 
	"userName","status","transferStatus","HVFlag","Remarks","reqscg","reqscgdesc","ExpressFlag"];
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
	var	sm1=new Ext.grid.CheckboxSelectionModel({
		singleSelect : gHVInIsTrf,	//2016-04-29 ��ֵ�Ƶ���ʱ����ѡ����(������,Ҫע��'ѡȡ'����ʱ�ĺ�̨����)
		checkOnly:true
	});
	var MasterCm = new Ext.grid.ColumnModel([nm,sm1,{
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
				header : "ת��״̬",
				dataIndex : 'transferStatus',
				width : 80,
				align : 'left',
				renderer: renderStatus,
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
				header : "����ʱ��",
				dataIndex : 'time',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : "����״̬",
				dataIndex : 'status',
				width : 120,
				align : 'left',
				renderer: renderReqType,
				sortable : true
			}, {
				header : "�Ƶ���",
				dataIndex : 'userName',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "��ֵ��־",
				dataIndex : 'HVFlag',
				width : 80,
				align : 'left'
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

	var MasterGridS = new Ext.ux.GridPanel({
		id:'MasterGridS',
		region: 'west',
		title: '����',
		collapsible: true,
		split: true,
		width: 230,
		margins: '0 5 0 0',
		layout: 'fit',
		cm : MasterCm,
		sm: sm1,
		store : MasterStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		bbar:GridPagingToolbar
	});

	// ��ӱ�񵥻����¼�
	MasterGridS.getSelectionModel().on('selectionchange', function(ssm){
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
			var reqid=rec.get('req');
			if (reqidstr=="")
			 {reqidstr=reqid}
			 else
			 {reqidstr=reqidstr+","+reqid}
				
		}
		DetailStore.removeAll();
		DetailStore.setBaseParam('req',reqidstr);
		DetailStore.setBaseParam('refuseflag',0);
		if(IsSplit()=="Y"){
			DetailStore.setBaseParam('handletype',0);
		}
		DetailStore.setBaseParam('canceled',"Y");
		var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();  //SupplyLocId;
		var includeDefLoc=(Ext.getCmp('includeDefLoc').getValue()==true?1:0);  //�Ƿ����֧�����
		var ListParam=supplyphaLoc+"^"+includeDefLoc+"^"+userId;
		DetailStore.setBaseParam('ListParam',ListParam);
		if(Ext.getCmp('ifShowTrf').getValue()){
			DetailStore.setBaseParam('TransferedFlag',1);
		}else{
			DetailStore.setBaseParam('TransferedFlag',0);
		}
		
		DetailStore.load({
			params:{start:0,limit:GridDetailPagingToolbar.pageSize},
			callback : function(r,options,success){
				if(!success){
					Msg.info('error', '��ѯ����!');
				}
			}
		});
	}
	// ������ϸ
	// ����·��
//	var DetailUrl =DictUrl+
//		'inrequestaction.csp?actiontype=queryDetail';
	var DetailUrl =DictUrl+'dhcinistrfaction.csp?actiontype=GetReqDetail';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	
	// ָ���в���
	var fields = ["rowid", "inci", "code","desc","qty", "uom", "uomDesc", "spec",
			 "manf", "sp", "spAmt","generic","drugForm", "remark","transQty","NotTransQty",
			 "stkQty","reqno","reqlocdesc","ProLocAllAvaQty","qtyApproved","remark","rp","reqPuomQty","rpAmt"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "rowid",
				fields : fields
			});
	// ���ݼ�
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm,{
				header : "������ϸRowId",
				dataIndex : 'rowid',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "����RowId",
				dataIndex : 'inci',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			},{
				header : '���󵥺�',
				dataIndex : 'reqno',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : '�������',
				dataIndex : 'reqlocdesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '���ʴ���',
				dataIndex : 'code',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '��������',
				dataIndex : 'desc',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "���",
				dataIndex : 'spec',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "��Ӧ�����",
				dataIndex : 'stkQty',
				width : 80,
				align : 'right',
				sortable : true				
			}, {
				header : "��Ӧ�����ÿ��",
				dataIndex : 'ProLocAllAvaQty',
				width : 80,
				align : 'right',
				sortable : true				
			}, {
				header : "��������",
				dataIndex : 'qty',
				width : 80,
				align : 'right',
				sortable : true				
			}, {
				header : "��Ӧ����׼����",
				dataIndex : 'qtyApproved',
				width : 80,
				align : 'right',
				sortable : true				
			}, {
				header : "��ת������",
				dataIndex : 'transQty',
				width : 80,
				align : 'right',
				sortable : true				
			}, {
				header : "δת������",
				dataIndex : 'NotTransQty',
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
				header : "�ۼ�",
				dataIndex : 'sp',
				width : 60,
				align : 'right',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'manf',
				width : 180,
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

	var DetailGridS = new Ext.ux.GridPanel({
				id : 'DetailGridS',
				region : 'center',
				title : '',
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:GridDetailPagingToolbar,
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
				viewConfig:{
					getRowClass : function(record,rowIndex,rowParams,store){ 
						var stkQty=parseFloat(record.get("stkQty"));
						var reqQty=parseFloat(record.get("qty"));
						var ProLocAllAvaQty=parseFloat(record.get("ProLocAllAvaQty"));
						var complete=(Ext.getCmp("ShowTransfered").getValue()==true?1:0);
						if(complete==0){
							if(ProLocAllAvaQty<=0){   //��������ܳ��� �ú�ɫ��ʾ
								return 'classRed';
							}
							if(ProLocAllAvaQty<reqQty){   //������ܳ��⵫���ǲ��ֳ��� �û�ɫ��ʾ��ʾ����
								return 'classYellow';
							}
							
						}
					}
				}
			});
			
		DetailGridS.on('render', function(grid) {    	
			var view = grid.getView();
			 DetailGridS.tip = new Ext.ToolTip({    
		        target: view.mainBody,    // The overall target element.    
		    
		        delegate: '.x-grid3-row', // Each grid row causes its own seperate show and hide.    
		    
		        trackMouse: true,         // Moving within the row should not hide the tip.    
		    
		        renderTo: document.body,  // Render immediately so that tip.body can be referenced prior to the first show.    
		    
		        listeners: {              // Change content dynamically depending on which element triggered the show.    
		    
		            beforeshow: function updateTipBody(tip) { 
		            	//alert("tip")
		                   var rowIndex = view.findRowIndex(tip.triggerElement);
		                   record=DetailGridS.getStore().getAt(rowIndex);
		 					var stkQty=parseFloat(record.get("stkQty"));
							var reqQty=parseFloat(record.get("qty"));
							var ProLocAllAvaQty=parseFloat(record.get("ProLocAllAvaQty"));
							var complete=(Ext.getCmp("ShowTransfered").getValue()==true?1:0);
							if(complete==0){
								if(ProLocAllAvaQty<=0){
									tip.body.dom.innerHTML = "���ÿ��Ϊ0�����ܳ���";
								}else if(ProLocAllAvaQty<reqQty){
								    tip.body.dom.innerHTML = "�����������ڹ�Ӧ���ҿ��ÿ�棬ֻ�ܲ��ֳ���";
								}else{
									tip.body.dom.innerHTML = "����������������ȫ����";
								}
							}
		            }    
		        }    
		    });    
			
		});
	
	
	var HisListTab = new Ext.ux.FormPanel({
		items:[{
			xtype:'fieldset',
			title:'��ѯ����',
			defaults: {border:false}, 
			style:"padding:5px 0px 0px 0px",
			layout: 'column',
			items : [{
				labelWidth:100,
				columnWidth: 0.3,
	        	xtype: 'fieldset',
	        	items: [ReqHosp,RequestPhaLocS,inciDesc]
			},{
				columnWidth: 0.3,
	        	xtype: 'fieldset',
	        	items: [StartDateS,EndDateS,ifShowTrf]
			},{
				columnWidth: 0.2,
	        	xtype: 'fieldset',
	        	items: [ShowTransfered,PartlyStatusS,includeDefLoc]
			},{
				columnWidth: 0.2,
	        	hideLables:true,
	        	items: [reqTypeGroup]
			}]
		}]
	});

	var findWin = new Ext.Window({
		title:'ѡȡ����',
		id:'findWin',
		width:gWinWidth,
		height:gWinHeight,
		plain:true,
		modal:true,
		layout : 'border',
		items : [HisListTab,MasterGridS,DetailGridS],
		tbar : [SearchBTS, '-',  ClearBTS,'-',((gHVInIsTrf)&&(InitParamObj.HVReqScanInit=="Y"))?"":SaveBTS, '-',((gHVInIsTrf)&&(InitParamObj.HVReqScanInit!="Y"))?"":SelectBTS,'-',returnDataBT,'-',refDetailBT, '-', closeBTS] //, '-', gHVInIsTrf?"":SelectBTS
		
	});
		
	//��ʾ����
	findWin.show();
	Query();		
}