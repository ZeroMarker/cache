//Description:入库综合查询
//Creator:zhangdongmei
//CreatDate:2012-11-30
var gNewCatId="";
Ext.onReady(function(){

	var gUserId = session['LOGON.USERID'];	
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	
	if(gParam.length<1){
		GetParam();  //初始化公共参数
	}
	var PhaLoc=new Ext.ux.LocComboBox({
		fieldLabel : '<font color=blue>'+$g('科室')+'</font>',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		emptyText : '科室...',
		groupId:gGroupId,
		listeners : {'select' : function(e) {SetDefaultSCG();}}
	});
	
	function SetDefaultSCG()
	{
		 var SelLocId=Ext.getCmp('PhaLoc').getValue();//add wyx 根据选择的科室动态加载类组
         StkGrpType.getStore().removeAll();
         StkGrpType.getStore().setBaseParam("locId",SelLocId)
         StkGrpType.getStore().setBaseParam("userId",UserId)
         StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
         StkGrpType.getStore().load();
	}
	
	var DateFrom = new Ext.ux.EditDate({
		fieldLabel : '<font color=blue>'+$g('开始日期')+'</font>',
		id : 'DateFrom',
		name : 'DateFrom',
		anchor : '90%',
		value :DefaultStDate()
	});
		
	var DateTo = new Ext.ux.EditDate({
		fieldLabel : '<font color=blue>'+$g('截止日期')+'</font>',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		value : DefaultEdDate()
	});
	
	// 药品类组
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		anchor:'90%',
		StkType:App_StkTypeCode,     //标识类组类型
		LocId:gLocId,
		UserId:gUserId
	}); 
	StkGrpType.on('select',function(){
		Ext.getCmp("DHCStkCatGroup").setValue("");
	});
	
	var InciDr = new Ext.form.TextField({
		fieldLabel : $g('药品RowId'),
		id : 'InciDr',
		name : 'InciDr',
		anchor : '90%',
		valueNotFoundText : ''
	});

	var InciCode = new Ext.form.TextField({
		fieldLabel : $g('药品编码'),
		id : 'InciCode',
		name : 'InciCode',
		anchor : '90%',
		valueNotFoundText : ''
	});
	var IncDesc = new Ext.form.TextField({
		fieldLabel : $g('药品名称'),
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
	 * 调用药品窗体并返回结果
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
	var ImpNO = new Ext.form.TextField({
		fieldLabel : $g('入库单号'),
		id : 'ImpNO',
		name : 'ImpNO',
		anchor : '90%',
		valueNotFoundText : ''
	});	
	var DHCStkCatGroup = new Ext.ux.ComboBox({
		fieldLabel : $g('库存分类'),
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
		anchor : '90%'
	});
				
	// 药学大类
	var PhcCat = new Ext.ux.ComboBox({
		fieldLabel : $g('药学大类'),
		id : 'PhcCat',
		name : 'PhcCat',
		store : PhcCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PhccDesc'
	});

	PhcCat.on('change', function(e) {
		Ext.getCmp('PhcSubCat').setValue("");
		Ext.getCmp('PhcMinCat').setValue("");
	});

	// 药学子类
	var PhcSubCat = new Ext.ux.ComboBox({
		fieldLabel :$g( '药学子类'),
		id : 'PhcSubCat',
		name : 'PhcSubCat',
		store : PhcSubCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{PhcCatId:'PhcCat'}
	});

	PhcSubCat.on('change', function(e) {
		Ext.getCmp('PhcMinCat').setValue("");
	});

	// 药学小类
	var PhcMinCat = new Ext.ux.ComboBox({
		fieldLabel : $g('药学小类'),
		id : 'PhcMinCat',
		name : 'PhcMinCat',
		store : PhcMinCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{PhcSubCatId:'PhcSubCat'}
	});
	var PHCCATALL = new Ext.form.TextField({
		fieldLabel : $g('药学分类'),
		id : 'PHCCATALL',
		name : 'PHCCATALL',
		anchor : '100%',
		readOnly : true,
		valueNotFoundText : ''
	});
//GetAllCatNew("kkk");
function GetAllCatNew(catdescstr,newcatid){
	//if ((catdescstr=="")&&(newcatid=="")) {return;}
	Ext.getCmp("PHCCATALL").setValue(catdescstr);
	gNewCatId=newcatid;
	
	
}

var PHCCATALLButton = new Ext.Button({
	id:'PHCCATALLButton',
	text : $g('药学分类'),
	handler : function() {	
       //var lnk="dhcst.phccatall.csp?gNewCatId="+gNewCatId;
       //window.open(lnk,"_target","height=600,width=800,menubar=no,status=yes,toolbar=no,resizable=yes") ;
    /*
     var retstr=showModalDialog('dhcst.phccatall.csp?gNewCatId='+gNewCatId,'','dialogHeight:600px;dialogWidth:1000px;center:yes;help:no;resizable:no;status:no;scroll:no;menubar=no;toolbar=no;location=no')
       if (!(retstr)){
          return;
        }
        
        if (retstr==""){
          return;
        }
     
	var phacstr=retstr.split("^")
	GetAllCatNew(phacstr[0],phacstr[1])
	*/
	PhcCatNewSelect(gNewCatId,GetAllCatNew)
    }
});
	var PHCDFPhcDoDR = new Ext.ux.ComboBox({
		fieldLabel : $g('管制分类'),
		id : 'PHCDFPhcDoDR',
		name : 'PHCDFPhcDoDR',
		anchor : '90%',
		store : PhcPoisonStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		forceSelection : true,
		minChars : 1,
		valueNotFoundText : ''
	});

	var PhManufacturer = new Ext.ux.ComboBox({
		fieldLabel :$g( '生产企业'),
		id : 'PhManufacturer',
		name : 'PhManufacturer',
		store : PhManufacturerStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PHMNFName'
	});

	var PHCDOfficialType = new Ext.form.ComboBox({
		fieldLabel : $g('医保类别'),
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

	var PHCForm = new Ext.ux.ComboBox({
		fieldLabel : $g('剂型'),
		id : 'PHCForm',
		name : 'PHCForm',
		store : PhcFormStore,
		valueField : 'Description',
		displayField : 'Description',
		filterName:'PHCFDesc'
	});

	var PublicBiddingStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['1', $g('招标')], ['0', $g('非招标')]]
	});
	var PublicBidding = new Ext.form.ComboBox({
		fieldLabel : $g('招标'),
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
		fieldLabel : $g('招标级别'),
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
		//fieldLabel : '批次售价不等于售价',
		id : 'SpFlag',
		name : 'SpFlag',
		anchor : '90%',
		checked : false,
		boxLabel:$g('批次售价不等于售价')
	});
	
	MarkTypeStore.load();
	var INFOMT = new Ext.form.ComboBox({
		fieldLabel : $g('定价类型'),
		id : 'INFOMT',
		name : 'INFOMT',
		anchor : '90%',
		store : MarkTypeStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		forceSelection : true
	});
		
	// 入库类型
	var OperateInType = new Ext.form.ComboBox({
		fieldLabel :$g( '入库类型'),
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
	OperateInTypeStore.load();
		
	var ImportStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [[$g('国产'), $g('国产')], [$g('进口'), $g('进口')], [$g('合资'), $g('合资')]]
	});
	var INFOImportFlag = new Ext.form.ComboBox({
		fieldLabel : $g('进口标志'),
		id : 'INFOImportFlag',
		name : 'INFOImportFlag',
		anchor : '90%',
		store : ImportStore,
		valueField : 'RowId',
		displayField : 'Description',
		mode : 'local'
	});
	var InvNo = new Ext.form.TextField({
		fieldLabel : $g('发票号'),
		id : 'InvNo',
		name : 'InvNo',
		anchor : '90%',
		valueNotFoundText : ''
	});
			
	var MinSp = new Ext.form.TextField({
		fieldLabel : $g('最低售价'),
		id : 'MinSp',
		name : 'MinSp',
		anchor : '90%',
		valueNotFoundText : ''
	});
			
	var MaxSp = new Ext.form.TextField({
		fieldLabel : $g('最高售价'),
		id : 'MaxSp',
		name : 'MaxSp',
		anchor : '90%',
		valueNotFoundText : ''
	});
	var MaxRp = new Ext.form.TextField({
		fieldLabel : $g('最高进价'),
		id : 'MaxRp',
		name : 'MaxRp',
		anchor : '90%',
		valueNotFoundText : ''
	});
	var MinRp = new Ext.form.TextField({
		fieldLabel : $g('最低进价'),
		id : 'MinRp',
		name : 'MinRp',
		anchor : '90%',
		valueNotFoundText : ''
	});
	
	var DateFlag=new Ext.form.Checkbox({
		//fieldLabel:'按审核日期统计',
		id:'DateFlag',
		anchor:'90%',
		boxLabel:$g('按审核日期统计')
	});
	var searchBT=new Ext.Toolbar.Button({
		id:'searchBT',
		text:$g('查询'),
		tooltip : $g('点击查询入库明细'),
		height:30,
		width:70,
		iconCls : 'page_find',
		handler : function() {
			Query();
		}
	});
	
	var clearBT=new Ext.Toolbar.Button({
		id:'clearBT',
		text:$g('清屏'),
		tooltip : $g('点击清屏'),
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
		SetDefaultSCG();
		Ext.getCmp("DateFrom").setValue(DefaultStDate());
		Ext.getCmp("DateTo").setValue(DefaultEdDate());
		Ext.getCmp("StkGrpType").getStore().load();
		DetailGrid.store.removeAll();
		Ext.getCmp("PHCCATALL").setValue("");
		gNewCatId=""
	}
	
	//查询入库明细
	function Query(){
		
		
		var StartDate = Ext.getCmp("DateFrom").getValue();
			if(StartDate!=""){
				StartDate=StartDate.format(App_StkDateFormat);
			}else{
				Msg.info("warning",$g("请选择开始日期!"));
				return;
			}
			
			var EndDate = Ext.getCmp("DateTo").getValue()
			if(EndDate!=""){
				EndDate=EndDate.format(App_StkDateFormat);
			}else{
				Msg.info("warning",$g("请选择截止日期!"));
				return;
			}
		
		//var StartDate=Ext.getCmp("DateFrom").getValue().format(App_StkDateFormat).toString();;
		//var EndDate=Ext.getCmp("DateTo").getValue().format(App_StkDateFormat).toString();;
		var LocId=Ext.getCmp("PhaLoc").getValue();		
		var RetFlag=0;
		if(LocId==null || LocId==""){
			Msg.info("warning",$g("科室不能为空!"));
			return;
		}
		if(StartDate==null || StartDate==""){
			Msg.info("warning",$g("开始日期不能为空!"));
			return;
		}
		if(EndDate==null || EndDate==""){
			Msg.info("warning",$g("截止日期不能为空!"));
			return;
		}
		var GrpType=Ext.getCmp("StkGrpType").getValue();			//类组id
		var StkCatId=Ext.getCmp("DHCStkCatGroup").getValue();		//库存分类id
		var StkCatDesc=Ext.getCmp("DHCStkCatGroup").getRawValue();
		var IncDesc=Ext.getCmp("IncDesc").getValue();
		var ImpNO=Ext.getCmp("ImpNO").getValue();
		var IncRowid="";
		if(IncDesc!=null&IncDesc!=""){
			IncRowid=Ext.getCmp("InciDr").getValue();				//库存项id
			if (IncRowid == undefined) {
				IncRowid = "";
			}
		}
		var MarkType=Ext.getCmp("INFOMT").getValue();				//定价类型
		var ImpFlag=Ext.getCmp("INFOImportFlag").getValue();		//进口标志
		var BatNo='';											//生产批号
		var PbFlag=Ext.getCmp("PublicBidding").getValue();		//招标标志
		if (PbFlag=="招标") {PbFlag=1}
		else if (PbFlag=="非招标") {PbFlag=0}
		var PbLevel=Ext.getCmp("INFOPBLevel").getValue();			//招标级别
		var PhcCatId=(Ext.getCmp("PhcCat").getRawValue()==""?"":Ext.getCmp("PhcCat").getValue());				//药学大类id
		var PhcSubCatId=Ext.getCmp("PhcSubCat").getValue();			//药学子类id
		var PhcMinCatId=Ext.getCmp("PhcMinCat").getValue();			//药学小类id
		var ManfId=Ext.getCmp("PhManufacturer").getValue();			//生产企业id
		var Form=Ext.getCmp("PHCForm").getValue();					//剂型
		var InsuType=Ext.getCmp("PHCDOfficialType").getRawValue();		//医保类型
		var PosionCat=Ext.getCmp("PHCDFPhcDoDR").getValue();		//管制分类
		var VendorId=Ext.getCmp("Vendor").getValue();				//经营企业id
		var OperateType=Ext.getCmp("OperateInType").getValue();		//入库类型
		
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
		var Others=GrpType+"^"+StkCatId+"^"+IncRowid+"^"+MarkType+"^"+ImpFlag+"^"+BatNo+"^"+PbFlag
		+"^"+PbLevel+"^"+PhcCatId+"^"+PhcSubCatId+"^"+PhcMinCatId+"^"+ManfId+"^"+Form+"^"+InsuType+"^"+PosionCat
		+"^"+VendorId+"^"+OperateType+"^"+MinSp+"^"+MaxSp+"^"+MinRp+"^"+MaxRp+"^"+InvNo+"^"+SpFlag+"^"+StatFlag+"^"+ImpNO+"^"+gNewCatId;
		
		var pageSize=PagingToolBar.pageSize;
		DetailStore.setBaseParam("LocId",LocId);
		DetailStore.setBaseParam("StartDate",StartDate);
		DetailStore.setBaseParam("EndDate",EndDate);
		DetailStore.setBaseParam("Others",Others);
		DetailStore.load({params:{start:0,limit:pageSize}});
		
			
	}
	var DetailStore=new Ext.data.JsonStore({
		autoDestroy:true,
		url:DictUrl+"ingdrecaction.csp?actiontype=jsQueryRecDetail",
		storeId:'DetailStore',
		remoteSort:true,
		idProperty:'',
		root:'rows',
		totalProperty:'results',
		fields:['IngrNo','InvNo','IngrCreateDate','InciCode','InciDesc','PurUom','Qty',
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
			header:$g('入库单号'),
			dataIndex:'IngrNo',
			width:100,
			sortable:true
		},{
			header:$g('制单日期'),
			dataIndex:'IngrCreateDate',
			width:80,
			sortable:true
		},{
			header:$g('药品代码'),
			dataIndex:'InciCode',
			width:100,
			sortable:false
		},{
			header:$g('药品名称'),
			dataIndex:'InciDesc',
			width:100,
			sortable:true
		},{
			header:$g('单位'),
			dataIndex:'PurUom',
			width:100,
			sortable:false
		},{
			header:$g('数量'),
			dataIndex:'Qty',
			width:100,
			align:'right',
			sortable:false
		},{
			header:$g('进价'),
			dataIndex:'Rp',
			width:100,
			align:'right',
			sortable:false
		},{
			header:$g('进价金额'),
			dataIndex:'RpAmt',
			width:100,
			align:'right',
			sortable:false
		},{
			header:$g('售价'),
			dataIndex:'Sp',
			width:100,
			align:'right',
			sortable:false
		},{
			header:$g('售价金额'),
			dataIndex:'SpAmt',
			width:100,
			align:'right',
			sortable:false
		},{
			header:$g('经营企业'),
			dataIndex:'Vendor',
			width:100,
			sortable:true
		},{
			header:$g('批号'),
			dataIndex:'BatNo',
			width:100,
			sortable:false
		},{
			header:$g('效期'),
			dataIndex:'ExpDate',
			width:100,
			sortable:false
		},{
			header:$g('生产企业'),
			dataIndex:'Manf',
			width:100,
			sortable:false
		},{
			header:$g('货位'),
			dataIndex:'StkBin',
			width:100,
			sortable:false
		},{
			header:$g('发票号'),
			dataIndex:'InvNo',
			width:100,
			sortable:false
		},{
			header:$g('发票日期'),
			dataIndex:'InvDate',
			width:100,
			sortable:false
		},{
			header:$g('定价类型'),
			dataIndex:'SpType',
			width:100,
			sortable:false
		},{
			header:$g('招标标志'),
			dataIndex:'PbFlag',
			width:100,
			sortable:false
		},{
			header:$g('招标级别'),
			dataIndex:'PbLevel',
			width:100,
			sortable:false
		},{
			header:$g('医保类别'),
			dataIndex:'InsuType',
			width:100,
			sortable:false
		},{
			header:$g('单据状态'),
			dataIndex:'Status',
			width:100,
			sortable:false
		},{
			header:$g('审核日期'),
			dataIndex:'IngrDate',
			width:100,
			sortable:true
		},{
			header:$g('规格'),
			dataIndex:'Spec',
			width:100,
			sortable:true
		}	
	]);
	
	var PagingToolBar=new Ext.PagingToolbar({
		id:'PagingToolBar',
		store:DetailStore,
		displayInfo:true,
		pageSize:PageSize,
		displayMsg:$g("当前记录{0}---{1}条  共{2}条记录"),
		emptyMsg:$g("没有数据"),
		firstText:$g('第一页'),
		lastText:$g('最后一页'),
		prevText:$g('上一页'),
		refreshText:$g('刷新'),
		nextText:$g('下一页')		
	});
	var DetailGrid=new Ext.grid.GridPanel({
		title:'入库明细',
		id:'DetailGrid',
		height : 180,
		store:DetailStore,
		loadMask:true,
		cm:DetailCm,
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		bbar:PagingToolBar
	});
	
	var myForm=new Ext.form.FormPanel({
		id:'mainForm',
		title:$g('入库明细查询---<font color=blue>蓝色表示必选条件</font>'),
		autoHeight:true,
		frame:true,
		labelAlign:'right',
		tbar:[searchBT,'-',clearBT],
		items:[{
			xtype:'fieldset',
			title:$g('查询条件'),
			layout:'column',
			style:DHCSTFormStyle.FrmPaddingV,
			defaults:{border:false},
			items:[{
				columnWidth:0.25,
				xtype:'fieldset',
				defaults:{width:200},
				labelWidth:60,
				items:[PhaLoc,DateFrom,DateTo,StkGrpType,DHCStkCatGroup,IncDesc]
			},{
				columnWidth:0.25,
				xtype:'fieldset',
				defaults:{width:120},
				labelWidth:60,
				items:[OperateInType,INFOImportFlag,PublicBidding,INFOPBLevel,MaxSp,InvNo]
			},{
				columnWidth:0.25,
				xtype:'fieldset',
				defaults:{width:180},
				labelWidth:60,
				items:[Vendor,PhManufacturer,PHCForm,INFOMT,MinSp,SpFlag]
			},{
				columnWidth:0.25,
				xtype:'fieldset',
				defaults:{width:180},
				labelWidth:60,
				items:[PHCDFPhcDoDR,ImpNO,MinRp,MaxRp,{xtype:'compositefield',width:240,items:[PHCCATALL,PHCCATALLButton]},DateFlag]
			}]
		}]
		
	});

	var view=new Ext.Viewport({
		layout:'border',
		items:[{
			region:'north',
			height:DHCSTFormStyle.FrmHeight(6),
			layout:'fit',
			items:myForm		
		},{
			region:'center',
			layout:'fit',
			items:DetailGrid
		}]
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
  	var params=QueryParamsStr ; // getparastr("QueryParams");
  	if(params==null||(!params)){
  		return;
  	}
  	var arrparams=params.split(",");
  	if(arrparams[0]==null||arrparams[1]==null||arrparams[2]==null){
  		return;
  	}
  	
  	Ext.getCmp("PhaLoc").setValue(arrparams[0]);
  	//Ext.getCmp("PhaLoc").setRawValue(arrparams[6]);
  	Ext.getCmp("DateFrom").setValue(arrparams[1]);
  	Ext.getCmp("DateTo").setValue(arrparams[2]);
  	Ext.getCmp("InciDr").setValue(arrparams[3]);
  	var RetStr=tkMakeServerCall("web.DHCST.DHCINGdRecItm","GetDescByLocAndInci",arrparams[0]+"^"+arrparams[3])
  	var RetStrArr=RetStr.split("^")
  	Ext.getCmp("PhaLoc").setRawValue(RetStrArr[0]);
  	Ext.getCmp("IncDesc").setValue(RetStrArr[1]);
  	if(arrparams[5]==1){
  		Ext.getCmp("DateFlag").setValue(true);
  	}
  	Query();
  }
  
  ExecQuery();
});
