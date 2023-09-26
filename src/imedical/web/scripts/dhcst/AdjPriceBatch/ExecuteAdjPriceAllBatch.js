// /����: ���۵���Ч���޸�(��������)
// /����: ���۵���Ч���޸�(��������)
// /��д�ߣ�liangjiaquan
// /��д����: 2018.11.15
Ext.onReady(function(){
	var gUserId = session['LOGON.USERID'];
	var gHospId=session['LOGON.HOSPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gInciRowId="";
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var ItmDesc = new Ext.form.TextField({
		fieldLabel : 'ҩƷ����',
		id : 'ItmDesc',
		name : 'ItmDesc',
		anchor:'90%',
		width : 140,
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == 13) {
					//alert(App_StkTypeCode)
					var item=field.getValue();
					if (item != null && item.length > 0) {
						GetPhaOrderWindow(item, "", App_StkTypeCode, "", "N", "0", "",getDrugList);
					}
				}
			}
		}
	});
	
	// ���۵���
	var AdjSpNo = new Ext.form.TextField({
		fieldLabel : '���۵���',
		id : 'AdjSpNo',
		name : 'AdjSpNo',
		anchor:'90%',
		width : 100
	});
	
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
		fieldLabel : '��ʼ����',
		id : 'StartDate',
		name : 'StartDate',
		anchor:'90%',
		width : 120,
		value : new Date().add(Date.DAY,-1)
	});

	// ��������
	var EndDate= new Ext.ux.DateField({
		fieldLabel : '��������',
		id : 'EndDate',
		name : 'EndDate',
		anchor:'90%',
		width : 120,
		value : new Date()
	});
	
	var TypeStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['Audit', '�����δ��Ч'],['Yes', '����Ч']]
	});
	var Type = new Ext.form.ComboBox({
		fieldLabel : '���۵�״̬',
		id : 'Type',
		name : 'Type',
		width : 120,
		anchor:'90%',
		store : TypeStore,
		triggerAction : 'all',
		mode : 'local',
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : true,
		selectOnFocus : true,
		forceSelection : true,
		minChars : 1,
		editable : false,
		valueNotFoundText : ''
	});
	Ext.getCmp("Type").setValue("Audit");
	
	// ��ѯ
	var SearchBT = new Ext.Toolbar.Button({
		id : "SearchBT",
		text : '��ѯ',
		tooltip : '�����ѯ',
		width : 70,
		height : 30,
		iconCls : 'page_find',
		handler : function() {
			getAspDetail();
		}
	});

	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
		id : "ClearBT",
		text : '����',
		tooltip : '�������',
		width : 70,
		height : 30,
		iconCls : 'page_refresh',
		handler : function() {
			clearData();
		}
	});
	
	/**
	 * ��շ���
	 */
	function clearData() {
		gInciRowId="";
		Ext.getCmp("AdjSpNo").setValue("");
		Ext.getCmp("ItmDesc").setValue("");
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY,-1).format(App_StkDateFormat));
		Ext.getCmp("EndDate").setValue(new Date().format(App_StkDateFormat));
		Ext.getCmp("Type").setValue("Audit");
		//Ext.getCmp("SupplyPhaLoc").setDisabled(0);

		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		// �����ť�Ƿ����
		//changeButtonEnable("1^1^1^1^1^0^0^0");
	}
	
	// ������Ч��ť
	var ExecuteBT = new Ext.Toolbar.Button({
		id : "ExecuteBT",
		text : '������Ч',
		tooltip : '���������Ч',
		width : 70,
		height : 30,
		iconCls : 'page_gear',
		handler : function() {					
			// ������Ч���۵�
			//ExecuteAsp();
			CheckIfHavenAdjDay();
		}
	});
		// ��Ч֮ǰ�жϽ����Ƿ����Ѿ��ĵ��ۼ�¼  2020-01013 yangsj
	function CheckIfHavenAdjDay()
	{
		var sm = DetailGrid.getSelectionModel();
		var store = DetailGrid.getStore();
		var rowCount = DetailGrid.getStore().getCount();
		var StrAspId="";
		var sureExeflag=""
		for (var i = 0; i < rowCount; i++) {				
			//ѭ��ÿ��ѡ�������
			if(sm.isSelected(i)){
					var record = store.getAt(i);
					var status=record.get("Status");
					if(status=="����Ч"){
						Msg.info("warning","�Ѿ���Ч�ļ�¼�����ظ���Ч!");
						return;
					}
					if(record.dirty){
						Msg.info("warning","�����޸Ĺ��ļ�¼�����ȱ���!");
						return;
					}
					var detailId = record.get('AspId');	
					var incidesc=record.get('InciDesc');	
					var ret=tkMakeServerCall("web.DHCST.INAdjPriceAllBatch","CheckIfHavenAdjDay",detailId)
					if  (ret=="Y") 
					{
						Msg.info("warning",incidesc+" ҩƷ���մ����Ѿ���Ч�ļ�¼����ȷ���Ƿ������Ч!");
						record.set("Status","����������Ч����");
						sureExeflag=1;
						record.dirty = false;  
						//DetailGrid.getView().getRow(i).style.backgroundColor = "red";
					}
				
				}
			}
		if(sureExeflag==1) 
		{
			    Ext.Msg.confirm('��ʾ','��ҩƷ���ڽ�������Ч�ĵ������Σ��Ƿ�������ۣ�',
							      function(btn){
								if(btn=='yes'){
								  ExecuteAsp();					
								}else{
								  return;
								}
							 },this);
		}
		else ExecuteAsp();		
	}		

	/**
	 * ������Ч���۵�
	 */
	function ExecuteAsp() {
		
		//���ѡ����
		var sm = DetailGrid.getSelectionModel();
		var store = DetailGrid.getStore();
		var rowCount = DetailGrid.getStore().getCount();
		var StrAspId="";
		for (var i = 0; i < rowCount; i++) {				
			//ѭ��ÿ��ѡ�������
			if(sm.isSelected(i)){
				var record = store.getAt(i);
				var status=record.get("Status");
				if(status=="����Ч"){
					Msg.info("warning","�Ѿ���Ч�ļ�¼�����ظ���Ч!");
					return;
				}
				if(record.dirty){
					Msg.info("warning","�����޸Ĺ��ļ�¼�����ȱ���!");
					return;
				}
				var detailId = record.get('AspId');	
				if(StrAspId==""){
					StrAspId=detailId;
				}
				else{
					StrAspId=StrAspId+"^"+detailId;
				}
			}
		}
		if(StrAspId==""){
			Msg.info("warning","û����Ҫ������Ч������!");
			return;
		}		
		var mask=ShowLoadMask(Ext.getBody(),"������...");
		//�ύ���ݿ�ִ������
		Ext.Ajax.request({
			url : DictUrl+'inadjpriceactionallbatch.csp?actiontype=Execute',
			method : 'POST',
			params:{StrAspId:StrAspId},
			success : function(response) {
				var jsonData = Ext.util.JSON.decode(response.responseText);
				mask.hide();
				if(jsonData.info==0){
					Msg.info("success", "�ɹ���");
				}else if(jsonData.info==-3){
					Msg.info("warning", "���󣺴�������Ч�ĵ��۵�,�����ظ���Ч!");
					return;
				}else{
					Msg.info("error", "����:"+jsonData.info);
					return;
				}
				getAspDetail();
			},
			failure : function(response){
				Msg.info("error", "��������"+response.responseText);					
				return;
			}
		});		
	}
	
	// �ύ�޸�
	var UpdateBT = new Ext.Toolbar.Button({
		id : "UpdateBT",
		text : '����',
		tooltip : '�������',
		width : 70,
		height : 30,
		iconCls : 'page_save',
		handler : function() {					
			// �޸ĵ����ۼ�
			UpdateAsp();
		}
	});
	
	// �޸ĵ����ۼ�
	function UpdateAsp(){
		var count=DetailGrid.getStore().getCount();
		var strdata=null;
		for(var i=0;i<count;i++){
			var record=DetailGrid.getStore().getAt(i);
			//���ݷ����仯ʱִ����������
			if(record.dirty){
				var aspId=record.get("AspId");
				var resultSp=record.get("ResultSpUom");
				var resultRp=record.get("ResultRpUom");
				var status=record.get("Status");
				var exedate=record.get("ExecuteDate");
				if (resultSp<resultRp) {
					Msg.info("warning", "��"+(i+1)+"�е����ۼ�С�ڵ������!");
					return false;
					break;
				}
				var today=new Date().format(App_StkDateFormat);
				if((status=="����Ч")&&(exedate!=today)){
					continue;     //��������Ч��¼��ֻ����õ�����Ч�ĵ���۸�
				}
				if(strdata==null){
					strdata=aspId+"^"+resultSp+"^"+resultRp;
				}else{
					strdata=strdata+xRowDelim()+aspId+"^"+resultSp+"^"+resultRp;
				}
			}
		}
		if(strdata==null){
			Msg.info("warning","û����Ҫ���������!");
			return;
		}
		var mask=ShowLoadMask(Ext.getBody(),"������...");
		Ext.Ajax.request({
			url:DictUrl+ 'inadjpriceactionallbatch.csp?actiontype=UpdatePrice',
			method:'POST',
			params:{ListData:strdata},
			success:function(response){
				var jsonData = Ext.util.JSON.decode(response.responseText);
				mask.hide();
				if(jsonData.info==0){
					Msg.info("success", "���³ɹ���");
				}else{
					Msg.info("error", "����:"+jsonData.info);
					return;
				}
				getAspDetail();
			}
		});
	}
	
	function StatusColorRenderer(val,meta){
			if (val=="����������Ч����")
			meta.css='classRed';
			return val
		
		}
		
	// ������ϸ
	// ����·��
	var DetailUrl =DictUrl+ 'inadjpriceactionallbatch.csp?actiontype=QueryAspInfo';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
					
	// ָ���в���
	var fields = ["AspId", "AspNo","StkCatDesc", "InciId", "InciCode","InciDesc", 
			"AspUomDesc","PriorSpUom", "ResultSpUom", "DiffSpUom",
			"PriorRpUom", "ResultRpUom", "DiffRpUom", "AdjDate","Status","ExecuteDate",
			"PreExecuteDate", "AdjReason","Remark",  "AdjUserName","MarkType", "PriceFileNo", "MaxSp"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "AspId",
		fields : fields
	});
	// ���ݼ�
	var DetailStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader,
		baseParams:{
			StartDate:'',
			EndDate:'',
			Others:''
		}
	});
	
	//¼�������ۺ��ۼۺ����¼�����
	DetailStore.on("update",function(store,record,opt){
		var priorsp=record.get("PriorSpUom");
		var resultsp=record.get("ResultSpUom");
		var priorrp=record.get("PriorRpUom");
		var resultrp=record.get("ResultRpUom");
		record.set("DiffSpUom",Math.round((resultsp-priorsp)*10000)/10000);
		record.set("DiffRpUom",Math.round((resultrp-priorrp)*10000)/10000);
	});
	var detailSM = new Ext.grid.CheckboxSelectionModel();
	
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, detailSM,{
		header : "AdjSpRowId",
		dataIndex : 'AspId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "���۵���",
		dataIndex : 'AspNo',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : "״̬",
		dataIndex : 'Status',
		width : 130,
		align : 'center',
		sortable : true,
		renderer:StatusColorRenderer
	},{
		header : "������",
		dataIndex : 'StkCatDesc',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : 'ҩƷ����',
		dataIndex : 'InciCode',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : 'ҩƷ����',
		dataIndex : 'InciDesc',
		width : 230,
		align : 'left',
		sortable : true
	}, {
		header : "���۵�λ",
		dataIndex : 'AspUomDesc',
		width : 60,
		align : 'left',
		sortable : true
	}, {
		header : "��ǰ����",
		dataIndex : 'PriorRpUom',
		width : 90,
		align : 'right',
		sortable : true
	}, {
		header : "��ǰ�ۼ�",
		dataIndex : 'PriorSpUom',
		width : 90,
		align : 'right',
		sortable : true
	}, {
		header : "�������",
		dataIndex : 'ResultRpUom',
		width : 90,
		align : 'right',
		sortable : true,
		editor:new Ext.form.NumberField({
			allowBlank:false
		})
	}, {
		header : "�����ۼ�",
		dataIndex : 'ResultSpUom',
		width : 80,
		align : 'right',
		sortable : true,
		editor:new Ext.form.NumberField({
			allowBlank:false
		})
	}, {
		header : "���(�ۼ�)",
		dataIndex : 'DiffSpUom',
		width : 90,
		align : 'right',
		sortable : true
	}, {
		header : "���(����)",
		dataIndex : 'DiffRpUom',
		width : 90,
		align : 'right',
		sortable : true
	}, {
		header : "�Ƶ�����",
		dataIndex : 'AdjDate',
		width : 80,
		align : 'left',
		sortable : true				
	}, {
		header : "�ƻ���Ч����",
		dataIndex : 'PreExecuteDate',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : "ʵ����Ч����",
		dataIndex : 'ExecuteDate',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : "����ԭ��",
		dataIndex : 'AdjReason',
		width : 100,
		align : 'left',					
		sortable : true
	}, {
		header : "������",
		dataIndex : 'AdjUserName',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : "��������",
		dataIndex : 'MarkType',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "����ļ���",
		dataIndex : 'PriceFileNo',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "����ۼ�",
		dataIndex : 'MaxSp',
		width : 90,
		align : 'right',
		sortable : true
	}]);
	
	var DetailPageToolBar=new Ext.PagingToolbar({
		store:DetailStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:'û�м�¼',
		firstText:'��һҳ',
		lastText:'���һҳ',
		nextText:'��һҳ',
		prevText:'��һҳ'		
	});
	DetailPageToolBar.addListener('beforechange',function(ptbar,params){
		var selrows=DetailGrid.getSelectionModel().getCount();
		if(selrows>0){
			Msg.info("warning","��ǰҳ��¼�����˱仯�����ȴ�����ٷ�ҳ��");
			return false;
		}
	})
	
	var DetailGrid = new Ext.grid.EditorGridPanel({
		id : 'DetailGrid',
		region : 'center',
		title : '���۵���ϸ(��������)',
		cm : DetailCm,
		store : DetailStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		sm :detailSM,
		//clicksToEdit : 1,
		bbar:DetailPageToolBar
	});
	
	DetailGrid.addListener('beforeedit',function(e){
	   var status=e.record.get("Status");
	   var exedate=e.record.get("ExecuteDate");
	   var today=new Date().format(App_StkDateFormat);
		//if((status=="����Ч")&(exedate!=today)){
		if((status=="����Ч")){
	   		//Msg.info("warning","�˼�¼���ǽ�����Ч�������޸ļ۸�");
	   		e.cancel=true;
	   }
	   return;
	});
	
	/**
	 * ���ط���
	*/
	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		var inciDr = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		;
		Ext.getCmp("ItmDesc").setValue(inciDesc);
		gInciRowId=inciDr;		
	}
	
	// ��ʾ���۵�����
	function getAspDetail() {
		DetailStore.removeAll();
		var InciDesc=Ext.getCmp("ItmDesc").getValue();
		var InciRowid="";
		if(InciDesc!=null & InciDesc!="" & InciDesc.length >0){
			InciRowid=gInciRowId;
		}else{
			gInciRowId="";
		}
		var AspNo=Ext.getCmp("AdjSpNo").getValue();
		var StartDate=Ext.getCmp("StartDate").getValue();
		var EndDate=Ext.getCmp("EndDate").getValue();
		var Status=Ext.getCmp("Type").getValue();
		var Others=AspNo+"^"+Status+"^"+InciRowid+"^"+"^"+gHospId;
		if (StartDate == null || StartDate.length <= 0 ) {
			Msg.info("warning", "��ʼ���ڲ���Ϊ�գ�");
			Ext.getCmp("StartDate").focus();
			return;
		}
		else{
			StartDate=StartDate.format(App_StkDateFormat);
		}
		if (EndDate == null || EndDate.length <= 0 ) {
			Msg.info("warning", "��ֹ���ڲ���Ϊ�գ�");
			Ext.getCmp("EndDate").focus();
			return;
		}
		else{
			EndDate=EndDate.format(App_StkDateFormat);
		}
		DetailStore.setBaseParam("StartDate",StartDate);
		DetailStore.setBaseParam("EndDate",EndDate);
		DetailStore.setBaseParam("Others",Others);
		var pagesize=DetailPageToolBar.pageSize;
		DetailStore.load({
			params:{start:0,limit:pagesize},
			callback : function(r,options,success) {
				if(success==false){
		 			Msg.info("error", "��ѯ������鿴��־!");
		 		}         				
			}
		});
	}
	
	var MainForm = new Ext.form.FormPanel({
		labelWidth : 90,
		labelAlign : 'right',
		frame : true,
		autoHeight:true,
		title:'���۵���Ч(��������)',
		tbar : [SearchBT, '-', ClearBT, '-', UpdateBT , '-',ExecuteBT],
		items : [{					
			xtype : 'fieldset',
			title : '��ѯ����',
			style: DHCSTFormStyle.FrmPaddingV,
			defaults:{border:false},
			layout : 'column',									
			items : [{
				columnWidth : .18,
				xtype : 'fieldset',
				items : [StartDate]
			},{
				columnWidth : .18,
				xtype : 'fieldset',
				items : [EndDate]
			},{
				columnWidth : .2,
				xtype : 'fieldset',
				items : [Type]
			},{
				columnWidth : .2,
				xtype : 'fieldset',
				items : [AdjSpNo]
			},{
				columnWidth : .2,
				xtype : 'fieldset',
				items : [ItmDesc]
			}]								
		}]
	});
	
	// ҳǩ
	var panel = new Ext.Panel({
		activeTab : 0,
		height : DHCSTFormStyle.FrmHeight(1),
		region : 'north',
		layout:'fit',
		items : [MainForm]
	});

	// ҳ�沼��
	var mainPanel = new Ext.Viewport({
		layout : 'border',
		items : [panel, DetailGrid]
	});		
	
	var RpRule=tkMakeServerCall("web.DHCSTCOMMPARA","GetRpRule",gHospId)
	if(RpRule!=3){
		Msg.info("warning","�����μ�ģʽ����ͳһ�۵��۲˵�!!!");
		SearchBT.setDisabled(true);
		ClearBT.setDisabled(true);
		UpdateBT.setDisabled(true);
		ExecuteBT.setDisabled(true);
		return;
	}
		
	getAspDetail();    //ҳ����غ���ʾ����˵���
})