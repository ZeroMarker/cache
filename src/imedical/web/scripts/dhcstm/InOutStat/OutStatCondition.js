// /名称: 出库汇总统计条件录入
// /描述: 出库汇总统计条件录入
// /编写者：zhangdongmei
// /编写日期: 2012.11.12
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var IncRowid='';
	var Inclb='';
	var obj='';
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	
	var PhaLoc = new Ext.ux.form.LovCombo({
		id : 'PhaLoc',
		fieldLabel : '<font color=blue>出库科室</font>',
		listWidth : 400,
		anchor: '90%',
		separator:',',	//科室id用","连接
		store : GetGroupDeptStore,
		filterName : 'locDesc',
		valueField : 'RowId',
		displayField : 'Description',
		triggerAction : 'all'
	});
	// 登录设置默认值
	SetLogInDept(PhaLoc.getStore(), "PhaLoc");
	
	/*
	var RecLoc = new Ext.ux.LocComboBox({
		fieldLabel : '接收科室',
		id : 'RecLoc',
		name : 'RecLoc',
		emptyText : '接收科室...',
		anchor : '90%',
		defaultLoc:''
	});
	*/
	
	var RecLoc = new Ext.ux.form.LovCombo({
		fieldLabel : '接收科室',
		id : 'RecLoc',
		emptyText : '接收科室...',
		separator : ',',	//科室id用","连接
		store : DeptLocStore,
		filterName : 'locDesc',
		valueField : 'RowId',
		displayField : 'Description',
		pageSize : 9999,
		anchor : '90%'
	});

	var SlgG = new Ext.ux.ComboBox({
		id:'SlgG',
		fieldLabel:'科室组',
		anchor:'90%',
		listWidth:220,
		allowBlank:true,
		store:StkLocGrpStore,
		valueField:'RowId',
		displayField:'Description',
		emptyText:'科室组...',
		filterName:'str'
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
	
	var SCGSet = new Ext.form.ComboBox({
		id:'SCGSet',
		fieldLabel : '类组集合',
		anchor : '90%',
		store: SCGSetStore,
		mode : 'local',
		valueField : 'RowId',
		displayField : 'Description',
		valueNotFoundText : ''
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
	
	var InclbFlag = new Ext.form.Checkbox({
		fieldLabel : '按批次查',
		id : 'InclbFlag',
		name : 'InclbFlag',
		anchor : '90%',
		width : 120,
		checked : false,
		listeners:{
			'check':function(){
				Ext.getCmp("InciDesc").setValue("");
			}
		}
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
		var LocId=Ext.getCmp("PhaLoc").getValue();
		var InclbFlag = (Ext.getCmp("InclbFlag").getValue()==true?'Y':'N');
		if (item != null && item.length > 0) {
			if(InclbFlag=="Y"){
				GetPhaOrderWindowInclb(item, group, App_StkTypeCode, LocId, "N", "0", "",
					getDrugListInclb);
			}else{
				GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",
					getDrugList);
			}
		}
	}
	
	/**
	 * 返回方法
	*/
	function getDrugListInclb(record,record1) {
		if (record == null || record == "") {
			return;
		}
		Inclb = record1.get("Inclb");
		IncRowid = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		Ext.getCmp("InciCode").setValue(inciCode);
		Ext.getCmp("InciDesc").setValue(inciDesc);
	}
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
var INFOPbCarrier = new Ext.ux.ComboBox({
		fieldLabel: '配送商',
		id: 'INFOPbCarrier',
		name: 'INFOPbCarrier',
		store: CarrierStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'CADesc'
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

	var SourceOfFund = new Ext.ux.ComboBox({
		fieldLabel : '资金来源',
		id : 'SourceOfFund',
		anchor : '90%',
		store : SourceOfFundStore
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
		data : [['0', '转出转入'], ['1', '转出'], ['2', '转入'], ['3', '高值转入补录']]
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
	Ext.getCmp("TransferFlag").setValue("0");

	var TransRangeStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['0', '全部科室'], ['1', '科室组内部'], ['2', '科室组外部']]
	});
	var TransRange = new Ext.form.ComboBox({
		fieldLabel : '科室范围',
		id : 'TransRange',
		anchor : '90%',
		store : TransRangeStore,
		valueField : 'RowId',
		displayField : 'Description',
		mode : 'local',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		listWidth : 150,
		forceSelection : true
	});
	Ext.getCmp("TransRange").setValue("0");
	
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
					Ext.getCmp("TransferFlag").setValue("0");
					Ext.getCmp("TransRange").setValue("0");
					Ext.getCmp("RecLoc").setValue("");
					Ext.getCmp("SlgG").setValue("");
					Ext.getCmp("PhManufacturer").setValue("");
					Ext.getCmp("InclbFlag").setValue("false");
					Ext.getCmp("SourceOfFund").setValue("");
					Ext.getCmp("InciDesc").setValue("");
					Ext.getCmp("PHCDOfficialType").setValue("");
					Ext.getCmp("INFOMT").setValue("");
					Ext.getCmp("OperateOutType").setValue("");
					Ext.getCmp("Vendor").setValue("");
					Ext.getCmp("INFOImportFlag").setValue("");
					Ext.getCmp("PublicBidding").setValue("");
					Ext.getCmp("INFOPBLevel").setValue("");
					Ext.getCmp("MinSp").setValue("");
					Ext.getCmp("MaxSp").setValue("");
					Ext.getCmp("MinRp").setValue("");
					Ext.getCmp("MaxRp").setValue("");
					Ext.getCmp("SpFlag").setValue("false");
					Ext.getCmp("hvFlag").setValue("");
					Ext.getCmp("M_ChargeFlag").setValue("");
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
		//anchor : '90%',
		items : [
			{boxLabel:'全部',name:'hv_Flag',id:'all',inputValue:'',checked:true},
			{boxLabel:'高值',name:'hv_Flag',id:'hv',inputValue:'Y'},
			{boxLabel:'非高值',name:'hv_Flag',id:'nhv',inputValue:'N'}
		]
	});
	// 收费标志
	var M_ChargeFlag = new Ext.form.RadioGroup({
		id : 'M_ChargeFlag',
		//anchor : '90%',
		items : [
			{boxLabel:'全部',name:'M_ChargeFlag',id:'onlySurplus',inputValue:'',checked:true},
			{boxLabel:'收费',name:'M_ChargeFlag',id:'onlyLoss',inputValue:'Y'},
			{boxLabel:'不收费',name:'M_ChargeFlag',id:'onlyBalance',inputValue:'N'}
		]
	});
	var ManageFlag = new Ext.form.RadioGroup({
		id : 'ManageFlag',
		items : [
			{boxLabel:'全部',name:'ManageFlag',id:'ManageFlag_All',inputValue:'',checked:true},
			{boxLabel:'重点关注',name:'ManageFlag',id:'ManageFlag_Yes',inputValue:'Y'},
			{boxLabel:'非重点',name:'ManageFlag',id:'ManageFlag_No',inputValue:'N'}
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
				var ReportType = Ext.getCmp("HisListTab").getForm().findField('ReportType').getGroupValue();
					var RadioObj = Ext.getCmp(ReportType);
					addtab(RadioObj);
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
					
					SetLogInDept(PhaLoc.getStore(),'PhaLoc');
					Ext.getCmp("DateFrom").setValue(DefaultStDate());
					Ext.getCmp("DateTo").setValue(DefaultEdDate());
					Ext.getCmp("StkGrpType").getStore().load();
					FlagLocStkcat.setValue(true);
					document.getElementById("reportFrame").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
				}
			});
	// 科室库存分类
	var FlagLocStkcat = new Ext.form.Radio({
				boxLabel : '科室/库存分类',
				id : 'FlagLocStkcat',
				name : 'ReportType',
				inputValue : 'FlagLocStkcat',
				checked:'true'
			});
	// 科室库存分类交叉报表(进价)
	var FlagLocStkcatCross = new Ext.form.Radio({
				boxLabel : '科室/库存分类交叉报表(进价)',
				id : 'FlagLocStkcatCross',
				name : 'ReportType',
				inputValue : 'FlagLocStkcatCross'
			});
	var FlagLocScgCross = new Ext.form.Radio({
				boxLabel : '科室/类组交叉报表(进价)',
				id : 'FlagLocScgCross',
				name : 'ReportType',
				inputValue : 'FlagLocScgCross'
			});
	// 科室金额
	var FlagLoc = new Ext.form.Radio({
				boxLabel : '科室金额',
				id : 'FlagLoc',
				name : 'ReportType',
				inputValue : 'FlagLoc'
			});
	// 科室金额/科室组
	var FlagLocGrp = new Ext.form.Radio({
				boxLabel : '科室金额/科室组',
				id : 'FlagLocGrp',
				name : 'ReportType',
				inputValue : 'FlagLocGrp'
			});
	// 单品汇总
	var FlagSum = new Ext.form.Radio({
				boxLabel : '单品汇总',
				id : 'FlagSum',
				name : 'ReportType',
				inputValue : 'FlagSum'
			});
	// 科室单品汇总
	var FlagLocSum = new Ext.form.Radio({
				boxLabel : '科室单品汇总',
				id : 'FlagLocSum',
				name : 'ReportType',
				inputValue : 'FlagLocSum'
			});
	// 出库明细
	var FlagDetail = new Ext.form.Radio({
				boxLabel : '出库明细',
				id : 'FlagDetail',
				name : 'ReportType',
				inputValue : 'FlagDetail'
			});
	// 出库单汇总
	var FlagTrf = new Ext.form.Radio({
				boxLabel : '出库单汇总',
				id : 'FlagTrf',
				name : 'ReportType',
				inputValue : 'FlagTrf'
			});
	// 库存分类
	var FlagType = new Ext.form.Radio({
				boxLabel : '库存分类',
				id : 'FlagType',
				name : 'ReportType',
			inputValue : 'FlagType'
			});
	// 类组汇总
	var FlagScg = new Ext.form.Radio({
				boxLabel : '类组汇总',
				id : 'FlagScg',
				name : 'ReportType',
				inputValue : 'FlagScg'
			});
	// 供应商汇总交叉报表
	var FlagVendor = new Ext.form.Radio({
				boxLabel : '供应商库存分类',
				id : 'FlagVendor',
				name : 'ReportType',
				inputValue : 'FlagVendor'
			});
	// 供应商明细汇总报表
	var FlagVendorItm = new Ext.form.Radio({
				boxLabel : '供应商明细汇总',
				id : 'FlagVendorItm',
				name : 'ReportType',
				inputValue : 'FlagVendorItm'
			});
	// 配送商明细汇总报表
	var FlagCarridItm = new Ext.form.Radio({
				boxLabel : '配送商明细汇总',
				id : 'FlagCarridItm',
				name : 'ReportType',
				inputValue : 'FlagCarridItm'
			});
	// 收费/不收费汇总
	var FlagChargeSum = new Ext.form.Radio({
				boxLabel : '收费/不收费汇总',
				id : 'FlagChargeSum',
				name : 'ReportType',
				inputValue : 'FlagChargeSum'
			});
	// 账簿分类汇总
	var FlagBookCatSum = new Ext.form.Radio({
				boxLabel : '账簿分类汇总',
				id : 'FlagBookCatSum',
				name : 'ReportType',
				inputValue : 'FlagBookCatSum'
			});
	// 单品金额前十
	var FlagDetailTop = new Ext.form.Radio({
				boxLabel : '单品金额前十',
				id : 'FlagDetailTop',
				name : 'ReportType',
				inputValue : 'FlagDetailTop'
			});

	function ShowReport() {
		var StartDate=Ext.getCmp("DateFrom").getValue();
		var EndDate=Ext.getCmp("DateTo").getValue();
		if(StartDate==""||EndDate==""){
			Msg.info("warning","开始日期或截止日期不能为空！");
			return;
		}
		var StartDate=Ext.getCmp("DateFrom").getValue().format(ARG_DATEFORMAT).toString();
		var EndDate=Ext.getCmp("DateTo").getValue().format(ARG_DATEFORMAT).toString();
		var LocId=Ext.getCmp("PhaLoc").getValue();
		
		var FlagLocStkcat=Ext.getCmp("FlagLocStkcat").getValue();
		var FlagLocStkcatCross=Ext.getCmp("FlagLocStkcatCross").getValue();
		var FlagLocScgCross=Ext.getCmp("FlagLocScgCross").getValue();
		var FlagLoc=Ext.getCmp("FlagLoc").getValue();
		var FlagDetail=Ext.getCmp("FlagDetail").getValue();
		var FlagLocGrp=Ext.getCmp("FlagLocGrp").getValue();
		var FlagTrf=Ext.getCmp("FlagTrf").getValue();
		var FlagType=Ext.getCmp("FlagType").getValue();
		var FlagScg=Ext.getCmp("FlagScg").getValue();
		var FlagLocSum=Ext.getCmp("FlagLocSum").getValue();
		var FlagSum=Ext.getCmp("FlagSum").getValue();
		var FlagVendor=Ext.getCmp("FlagVendor").getValue();
		var FlagVendorItm=Ext.getCmp("FlagVendorItm").getValue();
		var FlagChargeSum = Ext.getCmp("FlagChargeSum").getValue();
		var FlagBookCatSum = Ext.getCmp("FlagBookCatSum").getValue();
		var FlagDetailTop = Ext.getCmp("FlagDetailTop").getValue();
		var FlagCarridItm= Ext.getCmp("FlagCarridItm").getValue();
		var SCGSet=Ext.getCmp('SCGSet').getRawValue();
		var GrpType=Ext.getCmp("StkGrpType").getValue();			//类组id
		var StkCatId=Ext.getCmp("DHCStkCatGroup").getValue();		//库存分类id
		if(StkCatId!=""&StkCatId!=null){
			StkCatId=","+StkCatId+",";
		}
		var InciDesc=Ext.getCmp("InciDesc").getValue();				//库存项id
		if (InciDesc==null || InciDesc=="") {
			IncRowid = "";
			Inclb="";
		}
		if(IncRowid!="" & IncRowid!=null){
			InciDesc=""
		}
		var MarkType=Ext.getCmp("INFOMT").getValue();				//定价类型
		var ImpFlag=Ext.getCmp("INFOImportFlag").getValue();		//进口标志
		var BatNo='';											//生产批号
		var PbFlag=Ext.getCmp("PublicBidding").getValue();		//招标标志
		var PbLevel=Ext.getCmp("INFOPBLevel").getValue();			//招标级别
		var ManageFlag=Ext.getCmp("ManageFlag").getValue().getGroupValue();		//重点关注标记
		var ManfId=Ext.getCmp("PhManufacturer").getValue();			//生产厂商id
		var InsuType=Ext.getCmp("PHCDOfficialType").getValue();		//医保类型
		var VendorId=Ext.getCmp("Vendor").getValue();				//供应商id
		var OperateType=Ext.getCmp("OperateOutType").getValue();		//出库类型
		var MinSp=Ext.getCmp("MinSp").getValue();				//最低售价
		var MaxSp=Ext.getCmp("MaxSp").getValue();				//最高售价
		var MinRp=Ext.getCmp("MinRp").getValue();				//最低进价
		var MaxRp=Ext.getCmp("MaxRp").getValue();				//最高进价
		var RecLocId=Ext.getCmp("RecLoc").getValue();			//接收科室
		var TransferFlag=Ext.getCmp("TransferFlag").getValue();				//统计方式
		var hvFlag = Ext.getCmp("hvFlag").getValue().getGroupValue();
		var charge = Ext.getCmp("M_ChargeFlag").getValue().getGroupValue();
		var StartTime=Ext.getCmp("TimeFrom").getValue();
		var EndTime=Ext.getCmp("TimeTo").getValue();
		var SourceOfFund=Ext.getCmp("SourceOfFund").getValue();
		var TransRange=Ext.getCmp("TransRange").getValue();		//科室范围
		var SlgG = Ext.getCmp('SlgG').getRawValue();				//科室组
		var Carrid=Ext.getCmp('INFOPbCarrier').getValue(); //配送商
		var Others=GrpType+"^"+StkCatId+"^"+IncRowid+"^"+MarkType+"^"+ImpFlag+"^"+BatNo+"^"+PbFlag+"^"+PbLevel+"^"+ManageFlag+"^"+""
			+"^"+""+"^"+ManfId+"^"+""+"^"+InsuType+"^"+""+"^"+VendorId+"^"+OperateType+"^"+MinSp+"^"+MaxSp+"^"+MinRp
			+"^"+MaxRp+"^"+RecLocId+"^"+hvFlag+"^"+StartTime+"^"+EndTime+"^"+InciDesc+"^"+SourceOfFund+"^"+charge+"^"+sssStkGrpType+"^"+Inclb
			+"^"+TransRange+"^"+SlgG+"^"+gUserId+"^"+SCGSet+"^"+Carrid;
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
		if(TransRange!=""){
			Conditions=Conditions+" 科室范围: "+Ext.getCmp("TransRange").getRawValue()
		}
		if(RecLocId!=""){
			Conditions=Conditions+" 接收科室: "+Ext.getCmp("RecLoc").getRawValue()
		}
		if(SlgG!=""){
			Conditions=Conditions+" 科室组: "+SlgG
		}
		if(SCGSet!=""){
			Conditions=Conditions+" 类组集合: "+Ext.getCmp("SCGSet").getRawValue()
		}
		if(GrpType!=""){
			Conditions=Conditions+" 类组: "+Ext.getCmp("StkGrpType").getRawValue()
		}
		if(StkCatId!=""){
			Conditions=Conditions+" 库存分类: "+Ext.getCmp("DHCStkCatGroup").getRawValue()
		}
		if(ManfId!=""){
			Conditions=Conditions+" 厂商: "+Ext.getCmp("PhManufacturer").getRawValue()
		}if(Carrid!=""){
			Conditions=Conditions+" 配送商: "+Ext.getCmp("INFOPbCarrier").getRawValue()
			}
		if(InciDesc!=""){
			Conditions=Conditions+" 物资名称: "+InciDesc
		}
		if(SourceOfFund!=""){
			Conditions=Conditions+" 资金来源: "+Ext.getCmp("SourceOfFund").getRawValue()
		}
		if(InsuType!=""){
			Conditions=Conditions+" 医保类别: "+Ext.getCmp("PHCDOfficialType").getRawValue()
		}
		if(MarkType!=""){
			Conditions=Conditions+" 定价类型: "+Ext.getCmp("INFOMT").getRawValue()
		}
		if(OperateType!=""){
			Conditions=Conditions+" 出库类型: "+Ext.getCmp("OperateOutType").getRawValue()
		}
		if(VendorId!=""){
			Conditions=Conditions+" 供应商: "+Ext.getCmp("Vendor").getRawValue()
		}
		if(PbFlag!=""){
			Conditions=Conditions+" 招标: "+Ext.getCmp("PublicBidding").getRawValue()
		}
		if(PbLevel!=""){
			Conditions=Conditions+" 招标级别: "+Ext.getCmp("INFOPBLevel").getRawValue()
		}
		if(ImpFlag!=""){
			Conditions=Conditions+" 进口标志: "+Ext.getCmp("INFOImportFlag").getRawValue()
		}
		if(MinSp!=""||MaxSp!=""){
			Conditions=Conditions+" 售价范围: "+MinSp+" ~ "+MaxSp
		}
		if(MinRp!=""||MaxRp!=""){
			Conditions=Conditions+" 进价范围: "+MinRp+" ~ "+MaxRp
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
		if(ManageFlag == 'Y'){
			Conditions = Conditions+" 重点关注: 是"
		}else if(ManageFlag == 'N'){
			Conditions = Conditions+" 重点关注: 否"
		}
		//取出查询条件
		//科室库存分类
	
		if(FlagLocStkcat==true){
		
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-LocStkcat.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//科室库存分类交叉报表(进价)
		else if(FlagLocStkcatCross==true){
		
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-LocStkcatCross.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//科室类组交叉报表(进价)
		else if(FlagLocScgCross==true){
		
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-LocScgCross.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//科室金额
		else if(FlagLoc==true){
		
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-Loc.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//科室组
		else if(FlagLocGrp==true){
		
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-LocGrp.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//单品汇总
		else if(FlagSum==true){
		
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-Sum.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//科室单品汇总
		else if(FlagLocSum==true){
		
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-LocSum.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//出库明细
		else if(FlagDetail==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-Detail.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//出库单汇总
		else if(FlagTrf==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-Trf.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//库存分类
		else if(FlagType==true){
		
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-Type.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//供应商库存分类
		else if(FlagVendor==true){

			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-Vendor.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//供应商明细汇总
		else if(FlagVendorItm==true){
		
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-VendorItm.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//类组汇总
		else if(FlagScg==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-Scg.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		else if(FlagChargeSum==true){
			//收费汇总
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat_ChargeSum.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		else if(FlagBookCatSum==true){
			//账簿分类汇总
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat_BookCatSum.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		else if(FlagDetailTop==true){
			//单品金额前十
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat_DetailTop.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}else if(FlagCarridItm==true){
			//配送商
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferCarii_Detail.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//科室库存分类
		else{
		
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-LocStkcat.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		
			//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.INVDetail&sUser="+sUser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
			//websys_createWindow(p_URL,1,"width=330,height=160,top=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
			//var NewWin=open(p_URL,"出库汇总-科室/库存分类","top=20,left=20,width=930,height=660,scrollbars=1");
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
		tbar : [OkBT, "-", ClearBT,'-',MonFlag],
		items : [{
			xtype : 'fieldset',
			title : '查询条件',
			items : [PhaLoc,DateFrom,TimeFrom,DateTo,TimeTo,TransferFlag,TransRange,RecLoc,SlgG,SCGSet,StkGrpType,DHCStkCatGroup,
				PhManufacturer,InclbFlag,InciDesc,SourceOfFund,PHCDOfficialType,INFOMT,OperateOutType,Vendor,INFOPbCarrier,
				PublicBidding,INFOPBLevel,INFOImportFlag,
				{xtype:'compositefield',fieldLabel:'售价范围',items:[MinSp,{xtype:'displayfield',value:'-'},MaxSp]},
				{xtype:'compositefield',fieldLabel:'进价范围',items:[MinRp,{xtype:'displayfield',value:'-'},MaxRp]},
				hvFlag,M_ChargeFlag,ManageFlag,
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
		}, {
			xtype : 'fieldset',
			title : '报表类型',
			labelWidth : 40,
			items : [FlagLocStkcat,FlagLocStkcatCross,FlagLocScgCross,FlagLoc,FlagLocGrp,FlagSum,
					FlagLocSum,FlagDetail,FlagTrf,FlagType,FlagScg,
					FlagVendor,FlagVendorItm,FlagChargeSum,FlagBookCatSum,FlagDetailTop,FlagCarridItm]
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
					title:'出库汇总',
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
					items:tabs
				}]
			});
});