//Description:����ۺϲ�ѯ
//Creator:zhangdongmei
//CreatDate:2012-11-30

Ext.onReady(function(){

	var gUserId = session['LOGON.USERID'];	
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	
	if(gParam.length<1){
		GetParam();  //��ʼ����������
	}
	
	var PhaLoc=new Ext.ux.LocComboBox({
		fieldLabel : '<font color=blue>����</font>',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		emptyText : '����...',
		groupId:gGroupId,
		stkGrpId : 'StkGrpType',
		childCombo : ['Vendor','PhManufacturer']
	});
	
	var DateFrom = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>��ʼ����</font>',
		id : 'DateFrom',
		name : 'DateFrom',
		anchor : '90%',
		
		value :DefaultStDate()
	});
		
	var DateTo = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>��ֹ����</font>',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		
		value : DefaultEdDate()
	});
	
	// ��������
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		anchor:'90%',
		StkType:App_StkTypeCode,     //��ʶ��������
		LocId:gLocId,
		UserId:gUserId,
		childCombo : 'DHCStkCatGroup'
	}); 
			
	var InciDr = new Ext.form.TextField({
		fieldLabel : '����RowId',
		id : 'InciDr',
		name : 'InciDr',
		anchor : '90%',
		valueNotFoundText : ''
	});

	var InciCode = new Ext.form.TextField({
		fieldLabel : '���ʱ���',
		id : 'InciCode',
		name : 'InciCode',
		anchor : '90%',
		valueNotFoundText : ''
	});
	var IncDesc = new Ext.form.TextField({
		fieldLabel : '��������',
		id : 'IncDesc',
		name : 'IncDesc',
		anchor : '90%',
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var stkGrp=Ext.getCmp("StkGrpType").getValue();
					var inputText=field.getValue();
					GetPhaOrderInfo(inputText,stkGrp);
				}
			}
		}
	});
    /**
	 * �������ʴ��岢���ؽ��
	 */
	function GetPhaOrderInfo(item, group) {
					
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "", "",
					getDrugList);
		}
	}
		
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
		
		Ext.getCmp("InciDr").setValue(inciDr);
		Ext.getCmp("InciCode").setValue(inciCode);
		Ext.getCmp("IncDesc").setValue(inciDesc);
	}
		
	var DHCStkCatGroup = new Ext.ux.ComboBox({
		fieldLabel : '������',
		id : 'DHCStkCatGroup',
		name : 'DHCStkCatGroup',
		store : StkCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{StkGrpId:'StkGrpType'}
	});
	
	var Vendor=new Ext.ux.VendorComboBox({
		id : 'Vendor',
		name : 'Vendor',
		anchor : '90%',
		params : {LocId : 'PhaLoc', ScgId : 'StkGrpType'}
	});

	var PhManufacturer = new Ext.ux.ComboBox({
		fieldLabel : '����',
		id : 'PhManufacturer',
		name : 'PhManufacturer',
		store : PhManufacturerStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PHMNFName',
		params : {LocId : 'PhaLoc', ScgId : 'StkGrpType'}
	});

	var PHCDOfficialType = new Ext.form.ComboBox({
		fieldLabel : 'ҽ�����',
		id : 'PHCDOfficialType',
		name : 'PHCDOfficialType',
		anchor : '90%',
		store : OfficeCodeStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		forceSelection : true,
		minChars : 1,
		valueNotFoundText : ''
	});
	var PublicBiddingStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['1', '�б�'], ['0', '���б�']]
	});
	var PublicBidding = new Ext.form.ComboBox({
		fieldLabel : '�б�',
		id : 'PublicBidding',
		name : 'PublicBidding',
		anchor : '90%',
		store : PublicBiddingStore,
		valueField : 'RowId',
		displayField : 'Description',
		mode : 'local',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		listWidth : 150,
		forceSelection : true
	});

	var INFOPBLevel = new Ext.form.ComboBox({
		fieldLabel : '�б꼶��',
		id : 'INFOPBLevel',
		name : 'INFOPBLevel',
		anchor : '90%',
		store : INFOPBLevelStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		listWidth : 150,
		forceSelection : true
	});

	var SpFlag = new Ext.form.Checkbox({
//		hideLabel : true,
		boxLabel : '�����ۼ۲������ۼ�',
		id : 'SpFlag',
		anchor : '90%',
		checked : false
	});
	
	var INFOMT = new Ext.form.ComboBox({
		fieldLabel : '��������',
		id : 'INFOMT',
		name : 'INFOMT',
		anchor : '90%',
		store : MarkTypeStore,
		valueField : 'Description',
		displayField : 'Description',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		forceSelection : true
	});
		
	// �������
	var OperateInType = new Ext.form.ComboBox({
		fieldLabel : '�������',
		id : 'OperateInType',
		name : 'OperateInType',
		anchor : '90%',
		store : OperateInTypeStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		forceSelection : true,
		minChars : 1,
		valueNotFoundText : ''
	});
		
	var ImportStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['����', '����'], ['����', '����'], ['����', '����']]
	});
	var INFOImportFlag = new Ext.form.ComboBox({
		fieldLabel : '���ڱ�־',
		id : 'INFOImportFlag',
		name : 'INFOImportFlag',
		anchor : '90%',
		store : ImportStore,
		valueField : 'RowId',
		displayField : 'Description',
		mode : 'local'
	});
	var InvNo = new Ext.form.TextField({
		fieldLabel : '��Ʊ��',
		id : 'InvNo',
		name : 'InvNo',
		anchor : '90%',
		valueNotFoundText : ''
	});
			
	var MinSp = new Ext.form.TextField({
		fieldLabel : '����ۼ�',
		id : 'MinSp',
		name : 'MinSp',
		anchor : '90%',
		valueNotFoundText : ''
	});
			
	var MaxSp = new Ext.form.TextField({
		fieldLabel : '����ۼ�',
		id : 'MaxSp',
		name : 'MaxSp',
		anchor : '90%',
		valueNotFoundText : ''
	});
	var MaxRp = new Ext.form.TextField({
		fieldLabel : '��߽���',
		id : 'MaxRp',
		name : 'MaxRp',
		anchor : '90%',
		valueNotFoundText : ''
	});
	var MinRp = new Ext.form.TextField({
		fieldLabel : '��ͽ���',
		id : 'MinRp',
		name : 'MinRp',
		anchor : '90%',
		valueNotFoundText : ''
	});
	
	var DateFlag=new Ext.form.Checkbox({
//		hideLabel : true,
		boxLabel:'���������ͳ��',
		id:'DateFlag',
		anchor:'90%'
	});
	
	var AuditFlag = new Ext.form.RadioGroup({
		id:'AuditFlag',
		columns:3,
		itemCls: 'x-check-group-alt',
		anchor : '90%',
		items:[
			{boxLabel:'ȫ��',name:'AuditFlag',id:'AuditFlag_All',inputValue:'',checked:true},
			{boxLabel:'�����',name:'AuditFlag',id:'AuditFlag_Yes',inputValue:'Y'},
			{boxLabel:'δ���',name:'AuditFlag',id:'AuditFlag_No',inputValue:'N'}
		]
	});
	
	var CreateUser = new Ext.ux.ComboBox({
		id : 'CreateUser',
		fieldLabel : '�Ƶ���',
		store : UStore,
		params : {locId : 'PhaLoc'},
		filterName : 'name'
	});
	
	var searchBT=new Ext.Toolbar.Button({
		id:'searchBT',
		text:'��ѯ',
		tooltip : '�����ѯ�����ϸ',
		height:30,
		width:70,
		iconCls : 'page_find',
		handler : function() {
			Query();
		}
	});
	
	var clearBT=new Ext.Toolbar.Button({
		id:'clearBT',
		text:'���',
		tooltip : '������',
		height:30,
		width:70,
		iconCls : 'page_clearscreen',
		handler : function() {
			ClearData();
		}
	});
	
	function ClearData(){
		Ext.getCmp('mainForm').getForm().items.each(function(f){ 
			f.setValue("");
		});
		SetLogInDept(PhaLoc.getStore(),"PhaLoc")
		Ext.getCmp("DateFrom").setValue(DefaultStDate());
		Ext.getCmp("DateTo").setValue(DefaultEdDate());
		Ext.getCmp("StkGrpType").getStore().setBaseParam("locId",gLocId);
		Ext.getCmp("StkGrpType").getStore().load();
		DetailGrid.store.removeAll();
	}
	
	//��ѯ�����ϸ
	function Query(){
		
		var StartDate=Ext.getCmp("DateFrom").getValue().format(ARG_DATEFORMAT).toString();;
		var EndDate=Ext.getCmp("DateTo").getValue().format(ARG_DATEFORMAT).toString();;
		var LocId=Ext.getCmp("PhaLoc").getValue();		
		var RetFlag=0;
		if(LocId==null || LocId==""){
			Msg.info("warning","���Ҳ���Ϊ��!");
			return;
		}
		if(StartDate==null || StartDate==""){
			Msg.info("warning","��ʼ���ڲ���Ϊ��!");
			return;
		}
		if(EndDate==null || EndDate==""){
			Msg.info("warning","��ֹ���ڲ���Ϊ��!");
			return;
		}
		var GrpType=Ext.getCmp("StkGrpType").getValue();			//����id
		var StkCatId=Ext.getCmp("DHCStkCatGroup").getValue();		//������id
		var StkCatDesc=Ext.getCmp("DHCStkCatGroup").getRawValue();
		var IncDesc=Ext.getCmp("IncDesc").getValue();
		var IncRowid="";
		if(IncDesc!=null&IncDesc!=""){
			IncRowid=Ext.getCmp("InciDr").getValue();				//�����id
			if (IncRowid == undefined) {
				IncRowid = "";
			}
		}else{
			Ext.getCmp("InciDr").setValue(""); 
		}
		if(IncRowid!=""&IncRowid!=null){
			IncDesc="";
		}
		var MarkType=Ext.getCmp("INFOMT").getValue();				//��������
		var ImpFlag=Ext.getCmp("INFOImportFlag").getValue();		//���ڱ�־
		var BatNo='';											//��������
		var PbFlag=Ext.getCmp("PublicBidding").getValue();		//�б��־
		var ManfId=Ext.getCmp("PhManufacturer").getValue();			//��������id
		var InsuType=Ext.getCmp("PHCDOfficialType").getValue();		//ҽ������
		var VendorId=Ext.getCmp("Vendor").getValue();				//��Ӧ��id
		var OperateType=Ext.getCmp("OperateInType").getValue();		//�������
		var PbLevel=Ext.getCmp("INFOPBLevel").getValue();
		var MinSp=Ext.getCmp("MinSp").getValue();				//����ۼ�
		var MaxSp=Ext.getCmp("MaxSp").getValue();				//����ۼ�
		var MinRp=Ext.getCmp("MinRp").getValue();				//��ͽ���
		var MaxRp=Ext.getCmp("MaxRp").getValue();				//��߽���
		var InvNo=Ext.getCmp("InvNo").getValue();				//��Ʊ��
		var SpFlag=Ext.getCmp("SpFlag").getValue();				//�����ۼ۲������ۼ۱�־
		if(SpFlag==true){
			SpFlag=1;
		}
		else{
			SpFlag=0;
		}
		var StatFlag=(Ext.getCmp("DateFlag").getValue()==true?'Y':'N');
		var AuditFlag=Ext.getCmp('AuditFlag').getValue().getGroupValue();
		var CreateUser = Ext.getCmp('CreateUser').getValue();
		var Others=GrpType+"^"+StkCatId+"^"+IncRowid+"^"+MarkType+"^"+ImpFlag+"^"+BatNo+"^"+PbFlag+"^"+PbLevel+"^"+CreateUser+"^"+""
			+"^"+""+"^"+ManfId+"^"+""+"^"+InsuType+"^"+""+"^"+VendorId+"^"+OperateType+"^"+MinSp+"^"+MaxSp+"^"+MinRp
			+"^"+MaxRp+"^"+InvNo+"^"+SpFlag+"^"+StatFlag+"^"+IncDesc+"^"+AuditFlag;
		var pageSize=PagingToolBar.pageSize;
		DetailStore.setBaseParam("LocId",LocId);
		DetailStore.setBaseParam("StartDate",StartDate);
		DetailStore.setBaseParam("EndDate",EndDate);
		DetailStore.setBaseParam("Others",Others);
		DetailStore.load({params:{start:0,limit:pageSize}});
	}
	
	var DetailStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:DictUrl+"ingdrecaction.csp?actiontype=jsQueryRecDetail",
		storeId:'DetailStore',
		remoteSort:true,
		idProperty:'',
		root:'rows',
		id:'Ingri',
		totalProperty:'results',
		fields:['Ingri','IngrNo','InvNo','IngrCreateDate','InciCode','InciDesc','PurUom','Qty',
		'Rp','RpAmt','Sp','SpAmt','Vendor','BatNo','ExpDate','Manf','StkBin','InvDate','SpType',
		'PbFlag','PbLevel','InsuType','Status','IngrDate','Spec'],
		baseParams:{
			LocId:'',
			StartDate:'',
			EndDate:'',
			Others:''
		}
	});
	var nm=new Ext.grid.RowNumberer();
	var DetailCm=new Ext.grid.ColumnModel([nm,
		{
			header:'��ⵥ��',
			dataIndex:'IngrNo',
			width:100,
			sortable:true
		},{
			header:'�Ƶ�����',
			dataIndex:'IngrCreateDate',
			width:80,
			sortable:true
		},{
			header:'���ʴ���',
			dataIndex:'InciCode',
			width:100,
			sortable:false
		},{
			header:'��������',
			dataIndex:'InciDesc',
			width:100,
			sortable:true
		},{
			header : '���',
			dataIndex : 'Spec',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header:'��λ',
			dataIndex:'PurUom',
			width:100,
			sortable:false
		},{
			header:'����',
			dataIndex:'Qty',
			width:100,
			align:'right',
			summaryType:'sum',
			sortable:false
		},{
			header:'����',
			dataIndex:'Rp',
			width:100,
			align:'right',
			sortable:false
		},{
			header:'���۽��',
			dataIndex:'RpAmt',
			width:100,
			align:'right',
			summaryType:'sum',
			sortable:false
		},{
			header:'�ۼ�',
			dataIndex:'Sp',
			width:100,
			align:'right',
			sortable:false
		},{
			header:'�ۼ۽��',
			dataIndex:'SpAmt',
			width:100,
			align:'right',
			summaryType:'sum',
			sortable:false
		},{
			header:'��Ӧ��',
			dataIndex:'Vendor',
			width:100,
			sortable:true
		},{
			header:'����',
			dataIndex:'BatNo',
			width:100,
			sortable:false
		},{
			header:'Ч��',
			dataIndex:'ExpDate',
			width:100,
			sortable:false
		},{
			header:'����',
			dataIndex:'Manf',
			width:100,
			sortable:false
		},{
			header:'��λ',
			dataIndex:'StkBin',
			width:100,
			sortable:false
		},{
			header:'��Ʊ��',
			dataIndex:'InvNo',
			width:100,
			sortable:false
		},{
			header:'��Ʊ����',
			dataIndex:'InvDate',
			width:100,
			sortable:false
		},{
			header:'��������',
			dataIndex:'SpType',
			width:100,
			sortable:false
		},{
			header:'�б��־',
			dataIndex:'PbFlag',
			width:100,
			sortable:false
		},{
			header:'�б꼶��',
			dataIndex:'PbLevel',
			width:100,
			sortable:false
		},{
			header:'ҽ�����',
			dataIndex:'InsuType',
			width:100,
			sortable:false
		},{
			header:'����״̬',
			dataIndex:'Status',
			width:100,
			sortable:false
		},{
			header:'�������',
			dataIndex:'IngrDate',
			width:100,
			sortable:true
		}	
	]);
	
	var PagingToolBar=new Ext.PagingToolbar({
		id:'PagingToolBar',
		store:DetailStore,
		displayInfo:true,
		pageSize:PageSize
	});
	var DetailGrid=new Ext.ux.GridPanel({
		region:'center',
		title:'�����ϸ',
		id:'DetailGrid',
		store:DetailStore,
		loadMask:true,
		cm:DetailCm,
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		bbar:PagingToolBar,
		plugins: new Ext.grid.GridSummary()
	});
	
	var myForm=new Ext.ux.FormPanel({
		id:'mainForm',
		title:'�����ϸ��ѯ---<font color=blue>��ɫ��ʾ��ѡ����</font>',
		tbar:[searchBT,'-',clearBT],
		items:[{
			xtype:'fieldset',
			title:'��ѯ����',
			layout:'column',
			style:'padding:5px 0px 0px 5px',
			defaults:{border:false},
			items:[{
				columnWidth:0.3,
				xtype:'fieldset',
				items:[PhaLoc,DateFrom,DateTo,StkGrpType,DHCStkCatGroup,IncDesc]
			},{
				columnWidth:0.2,
				xtype:'fieldset',
				items:[OperateInType,INFOImportFlag,PublicBidding,INFOPBLevel,InvNo,CreateUser]
			},{
				columnWidth:0.25,
				xtype:'fieldset',
				items:[Vendor,PhManufacturer,INFOMT,MinSp,MaxSp,DateFlag]
			},{
				columnWidth:0.25,
				xtype:'fieldset',
				items:[PHCDOfficialType,MinRp,MaxRp,AuditFlag,SpFlag]
			}]
		}]
	});

	var view=new Ext.ux.Viewport({
		layout:'border',
		items:[myForm, DetailGrid]
	});
	
	//��ȡurl����
	function getparastr(strname)
  {
   var hrefstr,pos,parastr,para,tempstr;
   hrefstr = window.location.href;
   pos = hrefstr.indexOf("?")
   parastr = hrefstr.substring(pos+1);
   para = parastr.split("&");
   tempstr="";
   for(i=0;i<para.length;i++)
   {
    tempstr = para[i];
    pos = tempstr.indexOf("=");
    if(tempstr.substring(0,pos) == strname)
    {
     return tempstr.substring(pos+1);
     }
   }
   return null;
  }

  function ExecQuery(){
  	var params=getparastr("QueryParams");
  	if(params==null){
  		return;
  	}
  	var arrparams=params.split(",");
  	if(arrparams[0]==null||arrparams[1]==null||arrparams[2]==null){
  		return;
  	}
  	
  	Ext.getCmp("PhaLoc").setValue(arrparams[0]);
  	Ext.getCmp("DateFrom").setValue(arrparams[1]);
  	Ext.getCmp("DateTo").setValue(arrparams[2]);
  	Ext.getCmp("InciDr").setValue(arrparams[3]);
  	Ext.getCmp("IncDesc").setValue(arrparams[4]);
  	if(arrparams[5]==1){
  		Ext.getCmp("DateFlag").setValue(true);
  	}
  	Query();
  }
  
  ExecQuery();
});
