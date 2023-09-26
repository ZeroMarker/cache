// /名称: 入库汇总统计条件录入
// /描述:  入库汇总统计条件录入
// /编写者：zhangdongmei
// /编写日期: 2012.01.17
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	var inciDr=""
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
		StkType:sssStkGrpType,     //标识类组类型
		LocId:gLocId,
		UserId:gUserId,
		childCombo : 'DHCStkCatGroup'
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
			GetPhaOrderWindow(item, group,App_StkTypeCode, "", "N", "0", "",
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
		inciDr = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		Ext.getCmp("InciDesc").setValue(inciDesc);
	}
	
	var DHCStkCatGroup = new Ext.ux.form.LovCombo({
		fieldLabel : '库存分类',
		id : 'DHCStkCatGroup',
		listWidth : 200,
		anchor: '90%',
		separator:',',	//库存分类id用,连接
		store : StkCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{StkGrpId:'StkGrpType'},
		triggerAction : 'all'
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

	var INFOPBLevel = new Ext.ux.ComboBox({
		fieldLabel : '招标级别',
		id : 'INFOPBLevel',
		name : 'INFOPBLevel',
		store : INFOPBLevelStore,
		valueField : 'RowId',
		displayField : 'Description'
	});
    var TransferFlagStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['0', '入库退货'], ['1', '退货'], ['2', '入库']]
	});
	var RetFlag = new Ext.form.ComboBox({
		fieldLabel : '统计方式',
		id : 'RetFlag',
		name : 'RetFlag',
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
	Ext.getCmp("RetFlag").setValue("0");
		
	var SpFlag = new Ext.form.Checkbox({
		boxLabel : '批次售价不等于售价',
		hideLabel : true,
		id : 'SpFlag',
		name : 'SpFlag',
		anchor : '90%',
		checked : false
	});
	
	var MonFlag = new Ext.form.Checkbox({
		boxLabel : '月度汇总',
		hideLabel : true,
		id : 'MonFlag',
		name : 'MonFlag',
		anchor : '90%',
		checked : false,
		listeners: {
			'check': function (checked) {
				if (checked.checked) {
					Ext.getCmp("DateFrom").setValue(BeginLastMon());
					Ext.getCmp("DateTo").setValue(EndLastMon());
					Ext.getCmp("TimeFrom").setValue("");
					Ext.getCmp("TimeTo").setValue("");
					Ext.getCmp("RetFlag").setValue("0");
					Ext.getCmp("Vendor").setValue("");
					Ext.getCmp("SourceOfFund").setValue("");
					Ext.getCmp("PhManufacturer").setValue("");
					Ext.getCmp("InciDesc").setValue("");
					Ext.getCmp("PHCDOfficialType").setValue("");
					Ext.getCmp("INFOMT").setValue("");
					Ext.getCmp("OperateInType").setValue("");
					Ext.getCmp("INFOImportFlag").setValue("");
					Ext.getCmp("PublicBidding").setValue("");
					Ext.getCmp("INFOPBLevel").setValue("");
					Ext.getCmp("InvNo").setValue("");
					Ext.getCmp("MinSp").setValue("");
					Ext.getCmp("MaxSp").setValue("");
					Ext.getCmp("MinRp").setValue("");
					Ext.getCmp("MaxRp").setValue("");
					Ext.getCmp("SpFlag").setValue("false");
					Ext.getCmp("hvFlag").setValue("");
					Ext.getCmp("M_ChargeFlag").setValue("");
					Ext.getCmp("FindTypeFlag").setValue("All");
					Ext.getCmp("StkGrpType").setValue("");
					Ext.getCmp("DHCStkCatGroup").setValue("");
				}
			}
		}
				
	});
/*
取上月默认开始截至日期
*/
function BeginLastMon(){
	var today=new Date();
	var days=today.getDate()
	var lastmon=today.add(Date.MONTH,-1);
	var lastmon=lastmon.add(Date.DAY, 1-days);
	return lastmon;
}

function EndLastMon(){
	var today=new Date();
	var days=today.getDate()
	var lastmon=today.add(Date.DAY, -days);
	return lastmon;
}
	// 高值标志
	var hvFlag = new Ext.form.RadioGroup({
		id : 'hvFlag',
		hideLabel : true,
		items : [
			{boxLabel:'全部',name:'hv_Flag',id:'all',inputValue:'',checked:true},
			{boxLabel:'高值',name:'hv_Flag',id:'hv',inputValue:'Y'},
			{boxLabel:'非高值',name:'hv_Flag',id:'nhv',inputValue:'N'}
		]
	});
	// 收费标志
	var M_ChargeFlag = new Ext.form.RadioGroup({
		id : 'M_ChargeFlag',
		hideLabel : true,
		items : [
			{boxLabel:'全部',name:'M_ChargeFlag',id:'onlySurplus',inputValue:'',checked:true},
			{boxLabel:'收费',name:'M_ChargeFlag',id:'onlyLoss',inputValue:'Y'},
			{boxLabel:'不收费',name:'M_ChargeFlag',id:'onlyBalance',inputValue:'N'}
		]
	});		
	var FindTypeData=[['全部','All'],['赠送','G'],['调价换票','A']];
		var FindTypeStore = new Ext.data.SimpleStore({
			fields: ['typedesc', 'typeid'],
			data : FindTypeData
		});
	var FindTypeFlag = new Ext.form.ComboBox({
		store: FindTypeStore,
		displayField:'typedesc',
		mode: 'local', 
		anchor : '90%',
		emptyText:'',
		id:'FindTypeFlag',
		fieldLabel : '赠送或调价换票',
		triggerAction:'all',
		valueField : 'typeid'
	});
	Ext.getCmp("FindTypeFlag").setValue("All");		
	var usedFlag = new Ext.form.Checkbox({
		boxLabel : '已使用',
		id : 'usedFlag',
		name : 'usedFlag',
		anchor : '90%',
		checked : false,
		hidden:true
	});
	
	MarkTypeStore.load();
	var INFOMT = new Ext.ux.ComboBox({
		fieldLabel : '定价类型',
		id : 'INFOMT',
		name : 'INFOMT',
		store : MarkTypeStore,
		valueField : 'RowId',
		displayField : 'Description'
	});

	// 入库类型
	var OperateInType = new Ext.ux.ComboBox({
		fieldLabel : '入库类型',
		id : 'OperateInType',
		name : 'OperateInType',
		store : OperateInTypeStore,
		valueField : 'RowId',
		displayField : 'Description'
	});
	OperateInTypeStore.load();

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
	var InvNo = new Ext.form.TextField({
		fieldLabel : '发票号',
		id : 'InvNo',
		name : 'InvNo',
		anchor : '90%',
		valueNotFoundText : ''
	});

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
	
	var SourceOfFund = new Ext.ux.ComboBox({
		fieldLabel : '资金来源',
		id : 'SourceOfFund',
		name : 'SourceOfFund',
		anchor : '90%',
		store : SourceOfFundStore,
		valueField : 'RowId',
		filterName:'Desc',
		displayField : 'Description'
	});	
	//资金来源
	var FlagSourceOfFundStat = new Ext.form.Radio({
		boxLabel : '资金来源汇总',
		id : 'FlagSourceOfFundStat',
		name : 'ReportType',
		anchor : '80%',
		inputValue : 'FlagSourceOfFundStat'
	});
	// 入库单列表
	var FlagImportDetail = new Ext.form.Radio({
		boxLabel : '入库单明细列表',
		id : 'FlagImportDetail',
		name : 'ReportType',
		anchor : '90%',
		inputValue : 'FlagImportDetail',
		checked:'true'
	});
	// 入库单汇总列表
	var FlagImportGroupDetail = new Ext.form.Radio({
		boxLabel : '入库单汇总列表',
		id : 'FlagImportGroupDetail',
		name : 'ReportType',
		anchor : '90%',
		inputValue : 'FlagImportGroupDetail'
	});
	// 单品汇总
	var FlagItmStat = new Ext.form.Radio({
		boxLabel : '单品汇总',
		id : 'FlagItmStat',
		name : 'ReportType',
		anchor : '80%',
		inputValue : 'FlagItmStat'
	});
	// 单品汇总(按批次)
	var FlagItmBatStat = new Ext.form.Radio({
		boxLabel : '单品批次汇总',
		id : 'FlagItmBatStat',
		name : 'ReportType',
		anchor : '80%',
		inputValue : 'FlagItmBatStat'
	});
	// 供应商汇总
	var FlagVendorStat = new Ext.form.Radio({
		boxLabel : '供应商汇总',
		id : 'FlagVendorStat',
		name : 'ReportType',
		anchor : '80%',
		inputValue : 'FlagVendorStat'
	});
	// 供应商明细汇总
	var FlagVendorItmStat = new Ext.form.Radio({
		boxLabel : '供应商明细汇总',
		id : 'FlagVendorItmStat',
		name : 'ReportType',
		anchor : '80%',
		inputValue : 'FlagVendorItmStat'
	});	
	// 供应商库存分类交叉报表(进价)
	var FlagVendorStkcatCross = new Ext.form.Radio({
		boxLabel : '供应商/库存分类汇总(进价)',
		id : 'FlagVendorStkcatCross',
		name : 'ReportType',
		anchor : '100%',
		inputValue : 'FlagVendorStkcatCross'
	});
	// 供应商发票汇总(进价)
	var FlagVendorInvList = new Ext.form.Radio({
		boxLabel : '供应商发票汇总(进价)',
		id : 'FlagVendorInvList',
		name : 'ReportType',
		inputValue : 'FlagVendorInvList'
	});
	// 类组汇总
	var FlagStkGrpStat = new Ext.form.Radio({
		boxLabel : '类组汇总',
		id : 'FlagStkGrpStat',
		name : 'ReportType',
		anchor : '80%',
		inputValue : 'FlagStkGrpStat'
	});	
	// 库存分类汇总
	var FlagStockStat = new Ext.form.Radio({
		boxLabel : '库存分类汇总',
		id : 'FlagStockStat',
		name : 'ReportType',
		anchor : '80%',
		inputValue : 'FlagStockStat'
	});				
   // 入库单汇总
	var FlagRecItmSumStat = new Ext.form.Radio({
		boxLabel : '入库单汇总',
		id : 'FlagRecItmSumStat',
		name : 'ReportType',
		anchor : '80%',
		inputValue : 'FlagRecItmSumStat'
	});	
   // 单品汇总(进价)
	var FlagRpItmSumStat = new Ext.form.Radio({
		boxLabel : '单品汇总(进价)',
		id : 'FlagRpItmSumStat',
		name : 'ReportType',
		anchor : '80%',
		inputValue : 'FlagRpItmSumStat'
	});			
    // 供应商发票单据汇总
	var FlagVendor2InvList = new Ext.form.Radio({
		boxLabel : '供应商发票单据汇总',
		id : 'FlagVendor2InvList',
		name : 'ReportType',
		inputValue : 'FlagVendor2InvList'
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
			SetLogInDept(PhaLoc.getStore(),'PhaLoc');
			Ext.getCmp("DateFrom").setValue(DefaultStDate());
			Ext.getCmp("DateTo").setValue(DefaultEdDate());
			Ext.getCmp("StkGrpType").getStore().load();
			FlagImportDetail.setValue(true);
			document.getElementById("frameReport").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
		}
	});
	//打印按钮
	var PrintBT = new Ext.Toolbar.Button({
		text : '打印',
		tooltip : '点击打印',
		width : 70,
		height : 30,
		iconCls : 'page_print',
		handler : function() {
			Print();
		}
	});
	function Print(){
		var StartDate=Ext.getCmp("DateFrom").getValue().format(ARG_DATEFORMAT).toString();;
		var EndDate=Ext.getCmp("DateTo").getValue().format(ARG_DATEFORMAT).toString();;
		var LocId=Ext.getCmp("PhaLoc").getValue();
		var GrpType=Ext.getCmp("StkGrpType").getValue();			//类组id
		var StkCatId=Ext.getCmp("DHCStkCatGroup").getValue();		//库存分类id
		var InciDesc=Ext.getCmp("InciDesc").getValue();				//库存项id
		if (InciDesc==null || InciDesc=="") {
			inciDr = "";
		}
		var MarkType=Ext.getCmp("INFOMT").getValue();				//定价类型
		var ImpFlag=Ext.getCmp("INFOImportFlag").getValue();		//进口标志
		var BatNo='';											//生产批号
		var PbFlag=Ext.getCmp("PublicBidding").getValue();		//招标标志
		var PbLevel=Ext.getCmp("INFOPBLevel").getValue();			//招标级别
		var ManfId=Ext.getCmp("PhManufacturer").getValue();			//生产厂商id
		var InsuType=Ext.getCmp("PHCDOfficialType").getValue();		//医保类型
		var VendorId=Ext.getCmp("Vendor").getValue();				//供应商id
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
		var hvFlag = Ext.getCmp("hvFlag").getValue().getGroupValue();
		var charge = Ext.getCmp("M_ChargeFlag").getValue().getGroupValue();
		var TimeFrom=Ext.getCmp("TimeFrom").getValue();
		var TimeTo=Ext.getCmp("TimeTo").getValue();
		var RetFlag=Ext.getCmp("RetFlag").getValue();		  //统计方式
		
		var Others=GrpType+"^"+StkCatId+"^"+inciDr+"^"+MarkType+"^"+ImpFlag+"^"+BatNo+"^"+PbFlag
		+"^"+PbLevel+"^"+""+"^"+""+"^"+""+"^"+ManfId+"^"+""+"^"+InsuType+"^"+""
		+"^"+VendorId+"^"+OperateType+"^"+MinSp+"^"+MaxSp+"^"+MinRp+"^"+MaxRp+"^"+InvNo+"^"+SpFlag+"^"+hvFlag+"^"+TimeFrom+"^"+TimeTo+"^"+charge+"^"+sssStkGrpType+"^"+gUserId;
		//获取查询条件列表
		var Conditions=""
		if(LocId!=""){
			Conditions="库房: "+Ext.getCmp("PhaLoc").getRawValue()
		}
		if(Ext.getCmp("DateFrom").getValue()!=""){
			Conditions=Conditions+" 日期: "+StartDate+" "+TimeFrom
		}
		if(Ext.getCmp("DateTo").getValue()!=""){
			Conditions=Conditions+"~ "+EndDate+" "+TimeTo
		} 
		var HospDesc=App_LogonHospDesc;
		fileName="{DHCSTM_importvendorpage.raq(StartDate="+StartDate+";HospDesc="+HospDesc+";EndDate="+EndDate+";LocId="+LocId+";Others="+Others+";Conditions="+Conditions+";RetFlag="+RetFlag+")}";
		DHCCPM_RQDirectPrint(fileName);
	}
		
	// 确定按钮
	var OkBT = new Ext.Toolbar.Button({
		id : "OkBT",
		text : '统计',
		tooltip : '点击统计',
		width : 70,
		iconCls : 'page_find',
		height : 30,
		handler : function() {
			//ShowReport();
			var ReportType = Ext.getCmp("HisListTab").getForm().findField('ReportType').getGroupValue();
			var RadioObj = Ext.getCmp(ReportType);
			addtab(RadioObj);
		}
	});
	
	function ShowReport(){   
		var StartDate=Ext.getCmp("DateFrom").getValue();
		var EndDate=Ext.getCmp("DateTo").getValue();
		if(StartDate==""||EndDate==""){
			Msg.info("warning","开始日期或截止日期不能为空！");
			return;
		}
		var StartDate=Ext.getCmp("DateFrom").getValue().format(ARG_DATEFORMAT).toString();;
		var EndDate=Ext.getCmp("DateTo").getValue().format(ARG_DATEFORMAT).toString();;
		var LocId=Ext.getCmp("PhaLoc").getValue();
		var GrpType=Ext.getCmp("StkGrpType").getValue();			//类组id
		var StkCatId=Ext.getCmp("DHCStkCatGroup").getValue();		//库存分类id
		if(StkCatId!=""&StkCatId!=null){
			StkCatId=","+StkCatId+",";
		}
		var InciDesc=Ext.getCmp("InciDesc").getValue();				//库存项id
		if (InciDesc==null || InciDesc=="") {
			inciDr = "";
		}
		var MarkType=Ext.getCmp("INFOMT").getValue();				//定价类型
		var ImpFlag=Ext.getCmp("INFOImportFlag").getValue();		//进口标志
		var BatNo='';											//生产批号
		var PbFlag=Ext.getCmp("PublicBidding").getValue();		//招标标志
		var PbLevel=Ext.getCmp("INFOPBLevel").getValue();			//招标级别
		var ManfId=Ext.getCmp("PhManufacturer").getValue();			//生产厂商id
		var InsuType=Ext.getCmp("PHCDOfficialType").getValue();		//医保类型
		var VendorId=Ext.getCmp("Vendor").getValue();				//供应商id
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
		var FlagImportDetail=Ext.getCmp("FlagImportDetail").getValue();
		var FlagImportGroupDetail=Ext.getCmp("FlagImportGroupDetail").getValue();
		var FlagItmStat=Ext.getCmp("FlagItmStat").getValue();
		var FlagItmBatStat=Ext.getCmp("FlagItmBatStat").getValue();
		var FlagVendorStat=Ext.getCmp("FlagVendorStat").getValue();
		var FlagVendorItmStat=Ext.getCmp("FlagVendorItmStat").getValue(); //供应商明细汇总
		var FlagVendorStkcatCross=Ext.getCmp("FlagVendorStkcatCross").getValue();  //供应商库存分类交叉统计
		var FlagStkGrpStat=Ext.getCmp("FlagStkGrpStat").getValue();        //类组汇总
		var FlagStockStat=Ext.getCmp("FlagStockStat").getValue();       //库存分类汇总
		var FlagRecItmSumStat=Ext.getCmp("FlagRecItmSumStat").getValue();       //入库单汇总
		var FlagRpItmSumStat=Ext.getCmp("FlagRpItmSumStat").getValue();      //入库单(进价)汇总 
		var FlagSourceOfFundStat=Ext.getCmp("FlagSourceOfFundStat").getValue();      //资金来源汇总 
		var FlagVendorInvList=Ext.getCmp("FlagVendorInvList").getValue();			//供应商发票列表
		var FlagVendor2InvList=Ext.getCmp("FlagVendor2InvList").getValue();
		var hvFlag = Ext.getCmp("hvFlag").getValue().getGroupValue();
		var charge = Ext.getCmp("M_ChargeFlag").getValue().getGroupValue();
		var TimeFrom=Ext.getCmp("TimeFrom").getValue();
		var TimeTo=Ext.getCmp("TimeTo").getValue();
		var RetFlag=Ext.getCmp("RetFlag").getValue();		  //统计方式
		var SourceOfFund=Ext.getCmp("SourceOfFund").getValue();
		var FindTypeFlag=Ext.getCmp("FindTypeFlag").getValue();  //调价换票或者赠送
		
		var Others=GrpType+"^"+StkCatId+"^"+inciDr+"^"+MarkType+"^"+ImpFlag+"^"+BatNo+"^"+PbFlag
		+"^"+PbLevel+"^"+""+"^"+""+"^"+""+"^"+ManfId+"^"+""+"^"+InsuType+"^"+""
		+"^"+VendorId+"^"+OperateType+"^"+MinSp+"^"+MaxSp+"^"+MinRp+"^"+MaxRp+"^"+InvNo+"^"+SpFlag
		+"^"+hvFlag+"^"+TimeFrom+"^"+TimeTo+"^"+InciDesc+"^"+SourceOfFund+"^"+charge+"^"+sssStkGrpType+"^"+FindTypeFlag+"^"+gUserId;
		var reportFrame=document.getElementById("frameReport");
		var p_URL="";
		//获取查询条件列表
		var Conditions=""
		if(LocId!=""){
			Conditions="科室: "+Ext.getCmp("PhaLoc").getRawValue()
		}
		if(Ext.getCmp("DateFrom").getValue()!=""){
			var Sdate=Ext.getCmp("DateFrom").getValue().format(DateFormat).toString();
			Conditions=Conditions+" 统计时间: "+Sdate+" "+TimeFrom
		}
		if(Ext.getCmp("DateTo").getValue()!=""){
			var Tdate=Ext.getCmp("DateTo").getValue().format(DateFormat).toString();
			Conditions=Conditions+"~ "+Tdate+" "+TimeTo
		} 
		if(VendorId!=""){
			Conditions=Conditions+" 供应商: "+Ext.getCmp("Vendor").getRawValue()
		}	
		if(GrpType!=""){
			Conditions=Conditions+" 类组: "+Ext.getCmp("StkGrpType").getRawValue()
		}	
		if(StkCatId!=""){
			Conditions=Conditions+" 库存分类: "+Ext.getCmp("DHCStkCatGroup").getRawValue()
		}
		if(ManfId!=""){
			Conditions=Conditions+" 厂商: "+Ext.getCmp("PhManufacturer").getRawValue()
		}	
		if(InciDesc!=""){
			Conditions=Conditions+" 物资: "+InciDesc
		}
		if(InsuType!=""){
			Conditions=Conditions+" 医保类别: "+Ext.getCmp("PHCDOfficialType").getRawValue()
		}
		if(MarkType!=""){
			Conditions=Conditions+" 定价类型: "+Ext.getCmp("INFOMT").getRawValue()
		}
		if(OperateType!=""){
			Conditions=Conditions+" 入库类型: "+Ext.getCmp("OperateInType").getRawValue()
		}
		if(ImpFlag!=""){
			Conditions=Conditions+" 进口标志: "+Ext.getCmp("INFOImportFlag").getRawValue()
		} 
		if(PbFlag!=""){
			Conditions=Conditions+" 招标: "+Ext.getCmp("PublicBidding").getRawValue()
		}
		if(PbLevel!=""){
			Conditions=Conditions+" 招标级别: "+Ext.getCmp("INFOPBLevel").getRawValue()
		}
		if(InvNo!=""){
			Conditions=Conditions+" 发票号: "+InvNo
		}
		if(MinSp!=""||MaxSp!=""){
			Conditions=Conditions+" 售价范围: "+MinSp+" ~ "+MaxSp
		}
		if(MinRp!=""||MaxRp!=""){
			Conditions=Conditions+" 进价范围: "+MinRp+" ~ "+MaxRp
		}
		if(SpFlag==1){
			Conditions=Conditions+" 批次售价不等于售价: 是"
		}	
		if(hvFlag=="Y"){
			Conditions=Conditions+" 高值: 是"
		}else if(hvFlag=="N"){
			Conditions=Conditions+" 高值: 否"			
		}else if(hvFlag==""){
			Conditions=Conditions+" 高值: 全部"			
		}
		if(charge=="Y"){
			Conditions=Conditions+" 收费: 是"
		}else if(charge=="N"){
			Conditions=Conditions+" 收费: 否"			
		}else if(charge==""){
			Conditions=Conditions+" 收费: 全部"			
		}
		if(RetFlag!=""){
			Conditions=Conditions+" 统计方式: "+Ext.getCmp("RetFlag").getRawValue()
		}
		if(SourceOfFund!=""){
			Conditions=Conditions+" 资金来源: "+Ext.getCmp("SourceOfFund").getRawValue();
		}
	//获取查询条件列表
		//入库单列表
		if(FlagImportDetail==true){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importdetail.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		else if(FlagImportGroupDetail==true){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importgroupdetail.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		//单品汇总
		else if(FlagItmStat==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importitmstat.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		//单品汇总(按批次)
		else if(FlagItmBatStat==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importitmbatstat.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		//供应商汇总
		else if(FlagVendorStat==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importvendorstat.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		//供应商明细汇总
		else if(FlagVendorItmStat==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importvendoitmrstat.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		//供应商库存分类交叉报表(进价)
		else if(FlagVendorStkcatCross==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importvendorstkcatcross.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		//类组汇总
		else if(FlagStkGrpStat==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importstkgrpstat.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		//库存分类汇总
		else if(FlagStockStat==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importstockstat.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		//入库单汇总
		else if(FlagRecItmSumStat==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importrecitmsumstat.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		//单品汇总(进价)
		else if(FlagRpItmSumStat==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importrpitmsumstat.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		//资金来源汇总
		else if(FlagSourceOfFundStat==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_sourceoffundstat.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}	
		//供应商发票列表
		else if(FlagVendorInvList==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importVendorInvList.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		//供应商发票单据汇总
		else if(FlagVendor2InvList==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_VendorRecInvNoDetailStat.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		//入库单列表
		else{
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importdetail.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}		
		var ReportType = Ext.getCmp("HisListTab").getForm().findField('ReportType').getGroupValue();
			var reportFrame = document.getElementById("iframe_"+ReportType);
			reportFrame.src = p_URL;
	}
	var HisListTab = new Ext.form.FormPanel({
		id : 'HisListTab',
		labelWidth : 60,
		labelAlign : 'right',
		frame : true,
		autoScroll : true,
		bodyStyle : 'padding:5px;',
		tbar : [OkBT,'-',ClearBT,'-',MonFlag],
		items : [{
			xtype : 'fieldset',
			title : '查询条件',					
			items : [PhaLoc,DateFrom,TimeFrom,DateTo,TimeTo,RetFlag,Vendor,SourceOfFund,StkGrpType,DHCStkCatGroup,
				PhManufacturer,InciDesc,PHCDOfficialType,INFOMT,OperateInType,
				INFOImportFlag,PublicBidding,INFOPBLevel,InvNo,
				{xtype:'compositefield',fieldLabel:'售价范围',items:[MinSp,{xtype:'displayfield',value:'-'},MaxSp]},
				{xtype:'compositefield',fieldLabel:'进价范围',items:[MinRp,{xtype:'displayfield',value:'-'},MaxRp]},
				SpFlag,hvFlag,usedFlag,M_ChargeFlag,FindTypeFlag]
		}, {
			xtype : 'fieldset',
			title : '报表类型',
			items : [FlagImportDetail,FlagImportGroupDetail,FlagItmStat,FlagRpItmSumStat,FlagItmBatStat,FlagVendorStat,FlagVendorItmStat,FlagVendorStkcatCross,
				FlagVendorInvList,FlagVendor2InvList,FlagStkGrpStat,FlagStockStat,FlagRecItmSumStat,
				FlagSourceOfFundStat]
		}]
	});
   
	var addtab = function(cmpobj){
			var tabs=Ext.getCmp('main-tabs');
			var id=cmpobj.id;
			var title=cmpobj.boxLabel;
			var tabId = "tab_"+id;
			var iframeId = "iframe_"+id;
			var obj = Ext.getCmp(tabId);
			if (!obj){
				//判断tab是否已打开
				var obj=tabs.add({
					id:tabId,
					title:title,
					html:"<iframe id='"+iframeId+"' frameborder='0' scrolling='auto' height='100%' width='100%' src='../scripts/dhcstm/ExtUX/images/logon_bg.jpg'></iframe>",
					closable:true
				});
				obj.show();	//显示tab页
			}else{
				tabs.fireEvent('tabchange', tabs, obj);
			}
		}
		
		var tabs=new Ext.TabPanel({
			id:'main-tabs',
			activeTab:0,
			region:'center',
			enableTabScroll:true,
			resizeTabs: true,
			tabWidth:130,
			minTabWidth:120,
			resizeTabs:true,
			plugins: new Ext.ux.TabCloseMenu(), //右键关闭菜单
			items:[{
				title:'报表',	
					html:'<iframe id="reportFrame" height="100%" width="100%" scrolling="auto" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
				}],
			listeners : {
				tabchange : function(tabpanel, tab){
					var radioId = tab.id.split('_')[1];
					if(!Ext.isEmpty(radioId) && !Ext.isEmpty(radioId)){
						Ext.getCmp(radioId).setValue(true);
						ShowReport();
					}
				}
			}
		});
	
	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [{
			region:'west',
			title:"入库汇总",
			width:300,
			split:true,
			collapsible:true,
			minSize:250,
			maxSize:350,
			layout:'fit',
			items:HisListTab
		},{
			region:'center',
			layout:'fit',
			items:tabs
		}]
	});
});