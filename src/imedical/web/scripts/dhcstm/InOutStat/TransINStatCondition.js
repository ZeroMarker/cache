// /名称: 出库汇总统计条件录入
// /描述: 出库汇总统计条件录入
// /编写者：zhangdongmei
// /编写日期: 2012.11.12

var InRequestParamObj = GetAppPropValue('DHCSTINREQM');
//科室类型全局变量
var LOCTYPE = '';
if(InRequestParamObj && InRequestParamObj.ReqLocUseLinkLoc){
	//请求时使用"关联科室"的,转移入库查询也一样
	LOCTYPE = InRequestParamObj.ReqLocUseLinkLoc == 'Y'? 'L' : '';
}

Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var IncRowid='';
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	
    // 请求部门
	var RecLoc= new Ext.ux.LocComboBox({
		fieldLabel : '接收部门',
		id : 'RecLoc',
		name : 'RecLoc',
		anchor:'90%',
		emptyText : '接收部门...',
		groupId:gGroupId,
		protype : LOCTYPE,
		linkloc:gLocId,
		listeners:
		{
			'select':function(cb)
			{
				var requestLoc=cb.getValue();
				var defprovLocs=tkMakeServerCall("web.DHCSTM.DHCTransferLocConf","GetDefLoc",requestLoc,gGroupId)
				var mainArr=defprovLocs.split("^");
		                var defprovLoc=mainArr[0];
		                var defprovLocdesc=mainArr[1];
				addComboData(Ext.getCmp('PhaLoc').getStore(),defprovLoc,defprovLocdesc);
				Ext.getCmp("PhaLoc").setValue(defprovLoc);
				var provLoc=Ext.getCmp('PhaLoc').getValue();
				var provLoc=Ext.getCmp('PhaLoc').getValue();
				Ext.getCmp("StkGrpType").setFilterByLoc(requestLoc,provLoc);			
			}
		}
	});
	var PhaLoc = new Ext.ux.ComboBox({
		id:'PhaLoc',
		fieldLabel:'供给部门',
		anchor:'90%',
		store:frLocListStore,
		displayField:'Description',
		valueField:'RowId',
		listWidth:210,
		emptyText:'供给部门...',
		params:{LocId:'RecLoc'},
		filterName : 'FilterDesc',
		listeners:{
			'select':function(cb)
			{
				var provLoc=cb.getValue();
				var requestLoc=Ext.getCmp('RecLoc').getValue();
				Ext.getCmp("StkGrpType").setFilterByLoc(requestLoc,provLoc);			
			}
		}
	});

	PhaLoc.on("select",function(cmb,rec,id ){
	});
	var DateFrom = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>开始日期</font>',
		id : 'DateFrom',
		name : 'DateFrom',
		anchor : '90%',
		
		value :DefaultStDate()
	});
	
	var TimeFrom = new Ext.form.TextField({
		fieldLabel : '开始时间',
		id : 'TimeFrom',
		name : 'TimeFrom',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'时间格式错误，正确格式hh:mm:ss'
	});
		
	var DateTo = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>截止日期</font>',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		
		value : DefaultEdDate()
	});
	
	var TimeTo = new Ext.form.TextField({
		fieldLabel : '截止时间',
		id : 'TimeTo',
		name : 'TimeTo',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'时间格式错误，正确格式hh:mm:ss'
	});
	
	// 物资类组
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		anchor : '90%',
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
	
	var InciDesc = new Ext.form.TextField({
		fieldLabel : '物资名称',
		id : 'InciDesc',
		name : 'InciDesc',
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
			GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",
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
		IncRowid = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		Ext.getCmp("InciDr").setValue(InciDr);
		Ext.getCmp("InciCode").setValue(inciCode);
		Ext.getCmp("InciDesc").setValue(inciDesc);
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
		params : {LocId : 'PhaLoc',ScgId : 'StkGrpType'}
	});

	var PhManufacturer = new Ext.ux.ComboBox({
		fieldLabel : '厂商',
		id : 'PhManufacturer',
		name : 'PhManufacturer',
		store : PhManufacturerStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PHMNFName',
		params : {LocId : 'PhaLoc',ScgId : 'StkGrpType'}
	});

	var PHCDOfficialType = new Ext.ux.ComboBox({
		fieldLabel : '医保类别',
		id : 'PHCDOfficialType',
		name : 'PHCDOfficialType',
		anchor : '90%',
		store : OfficeCodeStore,
		valueField : 'RowId',
		displayField : 'Description'
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

	var TransferFlagStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['0', '转出转入'], ['1', '转出'], ['2', '转入']]
	});
	var TransferFlag = new Ext.form.ComboBox({
		fieldLabel : '统计方式',
		id : 'TransferFlag',
		name : 'TransferFlag',
		anchor : '90%',
		store : TransferFlagStore,
		valueField : 'RowId',
		displayField : 'Description',
		mode : 'local',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		listWidth : 150,
		forceSelection : true
	});
	Ext.getCmp("TransferFlag").setValue("2");

	var INFOPBLevel = new Ext.ux.ComboBox({
		fieldLabel : '招标级别',
		id : 'INFOPBLevel',
		name : 'INFOPBLevel',
		anchor : '90%',
		store : INFOPBLevelStore,
		valueField : 'RowId',
		displayField : 'Description'
	});

	var SpFlag = new Ext.form.Checkbox({
		boxLabel : '批次售价不等于售价',
		id : 'SpFlag',
		name : 'SpFlag',
		anchor : '90%',
		checked : false
	});
	MarkTypeStore.load();
	var INFOMT = new Ext.ux.ComboBox({
		fieldLabel : '定价类型',
		id : 'INFOMT',
		name : 'INFOMT',
		anchor : '90%',
		store : MarkTypeStore,
		valueField : 'RowId',
		displayField : 'Description'
	});

	// 入库类型
	var OperateOutType = new Ext.ux.ComboBox({
		fieldLabel : '出库类型',
		id : 'OperateOutType',
		name : 'OperateOutType',
		anchor : '90%',
		store : OperateOutTypeStore,
		valueField : 'RowId',
		displayField : 'Description'
	});
	OperateInTypeStore.load();

	var MinSp = new Ext.ux.NumberField({
		id : 'MinSp',
		formatType : 'FmtSP',
		width : '70',
		valueNotFoundText : ''
	});
			
	var MaxSp = new Ext.ux.NumberField({
		id : 'MaxSp',
		formatType : 'FmtSP',
		width : '70',
		valueNotFoundText : ''
	});
	var MaxRp = new Ext.ux.NumberField({
		id : 'MaxRp',
		formatType : 'FmtRP',
		width : '70',
		valueNotFoundText : ''
	});
	var MinRp = new Ext.ux.NumberField({
		id : 'MinRp',
		formatType : 'FmtRP',
		width : '70',
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
		mode : 'local',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		listWidth : 150,
		forceSelection : true
	});
    //高值标志
    var hvFlag = new Ext.form.RadioGroup({
	    id : 'hvFlag',
	    items : [
		    {boxLabel:'全部',name:'hv_Flag',id:'all',inputValue:'',checked:true},
		    {boxLabel:'高值',name:'hv_Flag',id:'hv',inputValue:'Y'},
		    {boxLabel:'非高值',name:'hv_Flag',id:'nhv',inputValue:'N'}
		]
	});

	// 确定按钮
	var OkBT = new Ext.Toolbar.Button({
		id : "OkBT",
		text : '统计',
		tooltip : '点击统计',
		width : 70,
		height : 30,
		iconCls : 'page_find',
		handler : function() {
			ShowReport();
		}
	});
	
	var ClearBT = new Ext.Toolbar.Button({
		id : "ClearBT",
		text : '清空',
		tooltip : '点击清空',
		width : 70,
		height : 30,
		iconCls : 'page_clearscreen',
		handler : function() {
			Ext.getCmp('HisListTab').getForm().items.each(function(f){ 
				f.setValue("");
			});
			Ext.getCmp("MinSp").setValue("");
			Ext.getCmp("MaxSp").setValue("");
			Ext.getCmp("MinRp").setValue("");
			Ext.getCmp("MaxRp").setValue("");
			SetLogInDept(RecLoc.getStore(),'RecLoc');
			Ext.getCmp("DateFrom").setValue(DefaultStDate());
			Ext.getCmp("DateTo").setValue(DefaultEdDate());
			Ext.getCmp("StkGrpType").getStore().load();
			document.getElementById("reportFrame").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
		}
	});
	
	function ShowReport() {
		var StartDate=Ext.getCmp("DateFrom").getValue();
		var EndDate=Ext.getCmp("DateTo").getValue();
		if(StartDate==""||EndDate==""){
			   Msg.info("warning","开始日期或截止日期不能为空！");
			   return;			    
		}
		var StartDate=Ext.getCmp("DateFrom").getValue().format(ARG_DATEFORMAT).toString();;
		var EndDate=Ext.getCmp("DateTo").getValue().format(ARG_DATEFORMAT).toString();;
		var LocId=Ext.getCmp("PhaLoc").getValue();
		if(LocId==""){
			//Msg.info("warning","供给部门不能为空！");
			//return;
		}	
		var GrpType=Ext.getCmp("StkGrpType").getValue();			//类组id
		var StkCatId=Ext.getCmp("DHCStkCatGroup").getValue();		//库存分类id
		var InciDesc=Ext.getCmp("InciDesc").getValue();				//库存项id
		if (InciDesc==null || InciDesc=="") {
			IncRowid = "";
		}
		if(IncRowid!=""&IncRowid!=null){
			InciDesc="";
		}
		var MarkType=Ext.getCmp("INFOMT").getValue();				//定价类型
		var ImpFlag=Ext.getCmp("INFOImportFlag").getValue();		//进口标志
		var BatNo='';											//生产批号
		var PbFlag=Ext.getCmp("PublicBidding").getValue();		//招标标志
		var PbLevel=Ext.getCmp("INFOPBLevel").getValue();			//招标级别
		var ManfId=Ext.getCmp("PhManufacturer").getValue();			//生产厂商id
		var InsuType=Ext.getCmp("PHCDOfficialType").getValue();		//医保类型
		var VendorId=Ext.getCmp("Vendor").getValue();				//供应商id
		var OperateType=Ext.getCmp("OperateOutType").getValue();		//出库类型
		var MinSp=Ext.getCmp("MinSp").getValue();				//最低售价
		var MaxSp=Ext.getCmp("MaxSp").getValue();				//最高售价
		var MinRp=Ext.getCmp("MinRp").getValue();				//最低进价
		var MaxRp=Ext.getCmp("MaxRp").getValue();				//最高进价
		var RecLocId=Ext.getCmp("RecLoc").getValue();			//接收科室
		if(RecLocId==""){
			Msg.info("warning","接收部门不能为空！");
			return;
		}
		var RecLocDesc=Ext.getCmp("RecLoc").getRawValue();			//接收科室
		var PhaLocDesc=Ext.getCmp("PhaLoc").getRawValue()
		var TransferFlag=Ext.getCmp("TransferFlag").getValue();				//统计方式
		var hvFlag=Ext.getCmp("hvFlag").getValue().getGroupValue();
		var StartTime=Ext.getCmp("TimeFrom").getValue();
		var EndTime=Ext.getCmp("TimeTo").getValue();
		
		var Others=GrpType+"^"+StkCatId+"^"+IncRowid+"^"+MarkType+"^"+ImpFlag+"^"+BatNo+"^"+PbFlag+"^"+PbLevel+"^"+""+"^"+""
			+"^"+""+"^"+ManfId+"^"+""+"^"+InsuType+"^"+""+"^"+VendorId+"^"+OperateType+"^"+MinSp+"^"+MaxSp+"^"+MinRp
			+"^"+MaxRp+"^"+LocId+"^"+hvFlag+"^"+StartTime+"^"+EndTime+"^"+InciDesc;
		var reportframe=document.getElementById("reportFrame")
		var p_URL="";
		//取出查询条件
		var Conditions="";
		if(LocId!=""){
			Conditions="出库科室: "+Ext.getCmp("PhaLoc").getRawValue()
		}
		if(StartDate!=""){
			var Sdate=Ext.getCmp("DateFrom").getValue().format(DateFormat).toString();
			Conditions=Conditions+" 统计时间: "+Sdate+" "+StartTime
		}
		if(EndDate!=""){
			var Tdate=Ext.getCmp("DateTo").getValue().format(DateFormat).toString();
			Conditions=Conditions+"~ "+Tdate+" "+EndTime
		}
		if(TransferFlag!=""){
			Conditions=Conditions+" 统计方式: "+Ext.getCmp("TransferFlag").getRawValue()
		}
		if(GrpType!=""){
			Conditions=Conditions+" 类组: "+Ext.getCmp("StkGrpType").getRawValue()
		}
		if(hvFlag=="Y"){
			Conditions=Conditions+" 高值: 是"
		}else if(hvFlag=="N"){
			Conditions=Conditions+" 高值: 否"			
		}else if(hvFlag==""){
			Conditions=Conditions+" 高值: 全部"			
		}
		if(StkCatId!=""){
			Conditions=Conditions+" 库存分类: "+Ext.getCmp("DHCStkCatGroup").getRawValue()
		}
		//取出查询条件
		p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferINStat-LocStkcat.raq&StartDate='+
			StartDate +'&EndDate=' +EndDate +'&LocId='+ RecLocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
			'&Conditions='+Conditions+'&RecLocDesc='+RecLocDesc;
		reportframe.src=p_URL;
	}

	var HisListTab = new Ext.form.FormPanel({
		id : 'HisListTab',
		labelWidth : 60,
		labelAlign : 'right',
		frame : true,
		autoScroll : true,
		bodyStyle : 'padding:5px;',
		tbar : [OkBT, "-", ClearBT],
		items : [{
			xtype : 'fieldset',
			title : '查询条件',
			items : [RecLoc,PhaLoc,DateFrom,TimeFrom,DateTo,TimeTo,TransferFlag,StkGrpType,DHCStkCatGroup,
				PhManufacturer,InciDesc,PHCDOfficialType,INFOMT,OperateOutType,Vendor,
				PublicBidding,INFOPBLevel,INFOImportFlag,
				{xtype:'compositefield',fieldLabel:'售价范围',items:[MinSp,{xtype:'displayfield',value:'-'},MaxSp]},
				{xtype:'compositefield',fieldLabel:'进价范围',items:[MinRp,{xtype:'displayfield',value:'-'},MaxRp]},
				hvFlag,
				{
					xtype:'checkbox',
					boxLabel : '已使用',
					id : 'usedFlag',
					name : 'usedFlag',
					anchor : '90%',
					checked : false,
					hidden:true
				}
			]
		}]
	});

	var reportPanel=new Ext.Panel({
		frame:true,
		html:'<iframe id="reportFrame" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	})
	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [{
			region:'west',
			title:'转移入库汇总',
			width:300,
			minSize:250,
			maxSize:350,
			split:true,
			collapsible:true,
			layout:'fit',
			items:HisListTab
		},{
			region:'center',
			layout:'fit',
			items:reportPanel
		}]
	});
});