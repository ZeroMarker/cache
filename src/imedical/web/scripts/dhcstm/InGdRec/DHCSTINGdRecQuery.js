//Description:入库综合查询
//Creator:zhangdongmei
//CreatDate:2012-11-30

Ext.onReady(function(){

	var gUserId = session['LOGON.USERID'];	
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	
	if(gParam.length<1){
		GetParam();  //初始化公共参数
	}
	
	var PhaLoc=new Ext.ux.LocComboBox({
		fieldLabel : '<font color=blue>科室</font>',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		emptyText : '科室...',
		groupId:gGroupId,
		stkGrpId : 'StkGrpType',
		childCombo : ['Vendor','PhManufacturer']
	});
	
	var DateFrom = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>开始日期</font>',
		id : 'DateFrom',
		name : 'DateFrom',
		anchor : '90%',
		
		value :DefaultStDate()
	});
		
	var DateTo = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>截止日期</font>',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		
		value : DefaultEdDate()
	});
	
	// 物资类组
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		anchor:'90%',
		StkType:App_StkTypeCode,     //标识类组类型
		LocId:gLocId,
		UserId:gUserId,
		childCombo : 'DHCStkCatGroup'
	}); 
			
	var InciDr = new Ext.form.TextField({
		fieldLabel : '物资RowId',
		id : 'InciDr',
		name : 'InciDr',
		anchor : '90%',
		valueNotFoundText : ''
	});

	var InciCode = new Ext.form.TextField({
		fieldLabel : '物资编码',
		id : 'InciCode',
		name : 'InciCode',
		anchor : '90%',
		valueNotFoundText : ''
	});
	var IncDesc = new Ext.form.TextField({
		fieldLabel : '物资名称',
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
	 * 调用物资窗体并返回结果
	 */
	function GetPhaOrderInfo(item, group) {
					
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "", "",
					getDrugList);
		}
	}
		
	/**
	 * 返回方法
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
		fieldLabel : '库存分类',
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
		fieldLabel : '厂商',
		id : 'PhManufacturer',
		name : 'PhManufacturer',
		store : PhManufacturerStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PHMNFName',
		params : {LocId : 'PhaLoc', ScgId : 'StkGrpType'}
	});

	var PHCDOfficialType = new Ext.form.ComboBox({
		fieldLabel : '医保类别',
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
		data : [['1', '招标'], ['0', '非招标']]
	});
	var PublicBidding = new Ext.form.ComboBox({
		fieldLabel : '招标',
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
		fieldLabel : '招标级别',
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
		boxLabel : '批次售价不等于售价',
		id : 'SpFlag',
		anchor : '90%',
		checked : false
	});
	
	var INFOMT = new Ext.form.ComboBox({
		fieldLabel : '定价类型',
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
		
	// 入库类型
	var OperateInType = new Ext.form.ComboBox({
		fieldLabel : '入库类型',
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
		data : [['国产', '国产'], ['进口', '进口'], ['合资', '合资']]
	});
	var INFOImportFlag = new Ext.form.ComboBox({
		fieldLabel : '进口标志',
		id : 'INFOImportFlag',
		name : 'INFOImportFlag',
		anchor : '90%',
		store : ImportStore,
		valueField : 'RowId',
		displayField : 'Description',
		mode : 'local'
	});
	var InvNo = new Ext.form.TextField({
		fieldLabel : '发票号',
		id : 'InvNo',
		name : 'InvNo',
		anchor : '90%',
		valueNotFoundText : ''
	});
			
	var MinSp = new Ext.form.TextField({
		fieldLabel : '最低售价',
		id : 'MinSp',
		name : 'MinSp',
		anchor : '90%',
		valueNotFoundText : ''
	});
			
	var MaxSp = new Ext.form.TextField({
		fieldLabel : '最高售价',
		id : 'MaxSp',
		name : 'MaxSp',
		anchor : '90%',
		valueNotFoundText : ''
	});
	var MaxRp = new Ext.form.TextField({
		fieldLabel : '最高进价',
		id : 'MaxRp',
		name : 'MaxRp',
		anchor : '90%',
		valueNotFoundText : ''
	});
	var MinRp = new Ext.form.TextField({
		fieldLabel : '最低进价',
		id : 'MinRp',
		name : 'MinRp',
		anchor : '90%',
		valueNotFoundText : ''
	});
	
	var DateFlag=new Ext.form.Checkbox({
//		hideLabel : true,
		boxLabel:'按审核日期统计',
		id:'DateFlag',
		anchor:'90%'
	});
	
	var AuditFlag = new Ext.form.RadioGroup({
		id:'AuditFlag',
		columns:3,
		itemCls: 'x-check-group-alt',
		anchor : '90%',
		items:[
			{boxLabel:'全部',name:'AuditFlag',id:'AuditFlag_All',inputValue:'',checked:true},
			{boxLabel:'已审核',name:'AuditFlag',id:'AuditFlag_Yes',inputValue:'Y'},
			{boxLabel:'未审核',name:'AuditFlag',id:'AuditFlag_No',inputValue:'N'}
		]
	});
	
	var CreateUser = new Ext.ux.ComboBox({
		id : 'CreateUser',
		fieldLabel : '制单人',
		store : UStore,
		params : {locId : 'PhaLoc'},
		filterName : 'name'
	});
	
	var searchBT=new Ext.Toolbar.Button({
		id:'searchBT',
		text:'查询',
		tooltip : '点击查询入库明细',
		height:30,
		width:70,
		iconCls : 'page_find',
		handler : function() {
			Query();
		}
	});
	
	var clearBT=new Ext.Toolbar.Button({
		id:'clearBT',
		text:'清空',
		tooltip : '点击清空',
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
	
	//查询入库明细
	function Query(){
		
		var StartDate=Ext.getCmp("DateFrom").getValue().format(ARG_DATEFORMAT).toString();;
		var EndDate=Ext.getCmp("DateTo").getValue().format(ARG_DATEFORMAT).toString();;
		var LocId=Ext.getCmp("PhaLoc").getValue();		
		var RetFlag=0;
		if(LocId==null || LocId==""){
			Msg.info("warning","科室不能为空!");
			return;
		}
		if(StartDate==null || StartDate==""){
			Msg.info("warning","开始日期不能为空!");
			return;
		}
		if(EndDate==null || EndDate==""){
			Msg.info("warning","截止日期不能为空!");
			return;
		}
		var GrpType=Ext.getCmp("StkGrpType").getValue();			//类组id
		var StkCatId=Ext.getCmp("DHCStkCatGroup").getValue();		//库存分类id
		var StkCatDesc=Ext.getCmp("DHCStkCatGroup").getRawValue();
		var IncDesc=Ext.getCmp("IncDesc").getValue();
		var IncRowid="";
		if(IncDesc!=null&IncDesc!=""){
			IncRowid=Ext.getCmp("InciDr").getValue();				//库存项id
			if (IncRowid == undefined) {
				IncRowid = "";
			}
		}else{
			Ext.getCmp("InciDr").setValue(""); 
		}
		if(IncRowid!=""&IncRowid!=null){
			IncDesc="";
		}
		var MarkType=Ext.getCmp("INFOMT").getValue();				//定价类型
		var ImpFlag=Ext.getCmp("INFOImportFlag").getValue();		//进口标志
		var BatNo='';											//生产批号
		var PbFlag=Ext.getCmp("PublicBidding").getValue();		//招标标志
		var ManfId=Ext.getCmp("PhManufacturer").getValue();			//生产厂商id
		var InsuType=Ext.getCmp("PHCDOfficialType").getValue();		//医保类型
		var VendorId=Ext.getCmp("Vendor").getValue();				//供应商id
		var OperateType=Ext.getCmp("OperateInType").getValue();		//入库类型
		var PbLevel=Ext.getCmp("INFOPBLevel").getValue();
		var MinSp=Ext.getCmp("MinSp").getValue();				//最低售价
		var MaxSp=Ext.getCmp("MaxSp").getValue();				//最高售价
		var MinRp=Ext.getCmp("MinRp").getValue();				//最低进价
		var MaxRp=Ext.getCmp("MaxRp").getValue();				//最高进价
		var InvNo=Ext.getCmp("InvNo").getValue();				//发票号
		var SpFlag=Ext.getCmp("SpFlag").getValue();				//批次售价不等于售价标志
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
			header:'入库单号',
			dataIndex:'IngrNo',
			width:100,
			sortable:true
		},{
			header:'制单日期',
			dataIndex:'IngrCreateDate',
			width:80,
			sortable:true
		},{
			header:'物资代码',
			dataIndex:'InciCode',
			width:100,
			sortable:false
		},{
			header:'物资名称',
			dataIndex:'InciDesc',
			width:100,
			sortable:true
		},{
			header : '规格',
			dataIndex : 'Spec',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header:'单位',
			dataIndex:'PurUom',
			width:100,
			sortable:false
		},{
			header:'数量',
			dataIndex:'Qty',
			width:100,
			align:'right',
			summaryType:'sum',
			sortable:false
		},{
			header:'进价',
			dataIndex:'Rp',
			width:100,
			align:'right',
			sortable:false
		},{
			header:'进价金额',
			dataIndex:'RpAmt',
			width:100,
			align:'right',
			summaryType:'sum',
			sortable:false
		},{
			header:'售价',
			dataIndex:'Sp',
			width:100,
			align:'right',
			sortable:false
		},{
			header:'售价金额',
			dataIndex:'SpAmt',
			width:100,
			align:'right',
			summaryType:'sum',
			sortable:false
		},{
			header:'供应商',
			dataIndex:'Vendor',
			width:100,
			sortable:true
		},{
			header:'批号',
			dataIndex:'BatNo',
			width:100,
			sortable:false
		},{
			header:'效期',
			dataIndex:'ExpDate',
			width:100,
			sortable:false
		},{
			header:'厂商',
			dataIndex:'Manf',
			width:100,
			sortable:false
		},{
			header:'货位',
			dataIndex:'StkBin',
			width:100,
			sortable:false
		},{
			header:'发票号',
			dataIndex:'InvNo',
			width:100,
			sortable:false
		},{
			header:'发票日期',
			dataIndex:'InvDate',
			width:100,
			sortable:false
		},{
			header:'定价类型',
			dataIndex:'SpType',
			width:100,
			sortable:false
		},{
			header:'招标标志',
			dataIndex:'PbFlag',
			width:100,
			sortable:false
		},{
			header:'招标级别',
			dataIndex:'PbLevel',
			width:100,
			sortable:false
		},{
			header:'医保类别',
			dataIndex:'InsuType',
			width:100,
			sortable:false
		},{
			header:'单据状态',
			dataIndex:'Status',
			width:100,
			sortable:false
		},{
			header:'审核日期',
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
		title:'入库明细',
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
		title:'入库明细查询---<font color=blue>蓝色表示必选条件</font>',
		tbar:[searchBT,'-',clearBT],
		items:[{
			xtype:'fieldset',
			title:'查询条件',
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
	
	//获取url参数
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
