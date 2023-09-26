// /名称: 出库汇总统计条件录入
// /描述: 出库汇总统计条件录入
// /编写者：zhangdongmei
// /编写日期: 2012.11.12

Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var IncRowid='';
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	
	/*
	var PhaLoc=new Ext.ux.LocComboBox({
		fieldLabel : '<font color=blue>科室</font>',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		emptyText : '科室...',
		groupId:gGroupId,
		stkGrpId : 'StkGrpType',
		childCombo : ['vendor','PhManufacturer']
	});
	*/
	
	var PhaLoc = new Ext.ux.form.LovCombo({
		id : 'PhaLoc',
		fieldLabel : '<font color=blue>出库科室</font>',
		listWidth : 400,
		anchor: '90%',
		separator:',',	//科室id用","连接
		store : GetGroupDeptStore,
		valueField : 'RowId',
		displayField : 'Description',
		triggerAction : 'all'
	});
	// 登录设置默认值
	SetLogInDept(PhaLoc.getStore(), "PhaLoc");
	
	var RecLoc = new Ext.ux.LocComboBox({
		fieldLabel : '<font color=blue>医嘱科室</font>',
		id : 'RecLoc',
		name : 'RecLoc',
		emptyText : '医嘱科室...',
		anchor : '90%',
		defaultLoc:''
	});

	var DateFrom = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>开始日期</font>',
		id : 'DateFrom',
		anchor : '90%',
		
		value : new Date()
	});
	
	var TimeFrom = new Ext.form.TextField({
		fieldLabel : '开始时间',
		id : 'TimeFrom',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'时间格式错误，正确格式hh:mm:ss'
	});
		
	var DateTo = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>截止日期</font>',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		
		value : new Date()
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
		data : [['0', '全部'], ['1', '转出转入台帐'], ['2', '医嘱台帐'], ['3', '全部(基于出库数据)']]
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
	Ext.getCmp("TransferFlag").setValue("3");

	/*
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
	*/
	
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

	// 确定按钮
	var OkBT = new Ext.Toolbar.Button({
				id : "OkBT",
				text : '统计',
				tooltip : '点击统计',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					//ShowReport();
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
					Ext.getCmp("DateFrom").setValue(new Date());
					Ext.getCmp("DateTo").setValue(new Date());
					Ext.getCmp("TransferFlag").setValue('3');
					Ext.getCmp("StkGrpType").getStore().load();
					FlagSum.setValue(true);
					document.getElementById("reportFrame").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
				}
			});
	
	// 单品汇总
	var FlagSum = new Ext.form.Radio({
				boxLabel : '单品汇总',
				id : 'FlagSum',
				inputValue : 'FlagSum',
				name : 'ReportType',
				checked : true
			});
	// 单品汇总(具体规格)
	var FlagSpecDescSum = new Ext.form.Radio({
				boxLabel : '单品汇总(具体规格)',
				id : 'FlagSpecDescSum',
				inputValue : 'FlagSpecDescSum',
				name : 'ReportType'
			});
	var FlagStkCatInci = new Ext.form.Radio({
				boxLabel : '库存分类单品汇总',
				id : 'FlagStkCatInci',
				inputValue : 'FlagStkCatInci',
				name : 'ReportType'
			});
	// 出库明细
	var FlagDetail = new Ext.form.Radio({
				boxLabel : '单品明细',
				id : 'FlagDetail',
				inputValue : 'FlagDetail',
				name : 'ReportType'
			});
	// 出库明细(台帐零差异)
	var FlagDetailZeroIntr = new Ext.form.Radio({
				boxLabel : '单品明细(零差异)',
				id : 'FlagDetailZeroIntr',
				inputValue : 'FlagDetailZeroIntr',
				name : 'ReportType'
			});
	var FlagDetailNotZeroIntr = new Ext.form.Radio({
				boxLabel : '单品明细(非零差异)',
				id : 'FlagDetailNotZeroIntr',
				inputValue : 'FlagDetailNotZeroIntr',
				name : 'ReportType'
			});
	// 库存分类
	var FlagType = new Ext.form.Radio({
				boxLabel : '库存分类汇总',
				id : 'FlagType',
				inputValue : 'FlagType',
				name : 'ReportType'
			});
			
		function ShowReport() {
			var RecLocId=Ext.getCmp("RecLoc").getValue();
			if(RecLocId == ''){
				Msg.info('warning', '请选择医嘱科室!');
				return false;
			}
			var StartDate=Ext.getCmp("DateFrom").getValue().format(ARG_DATEFORMAT).toString();
			var EndDate=Ext.getCmp("DateTo").getValue().format(ARG_DATEFORMAT).toString();
			var LocId=Ext.getCmp("PhaLoc").getValue();
			
			var FlagDetail=Ext.getCmp("FlagDetail").getValue();
			var FlagDetailZeroIntr=Ext.getCmp("FlagDetailZeroIntr").getValue();
			var FlagDetailNotZeroIntr=Ext.getCmp("FlagDetailNotZeroIntr").getValue();
			var FlagStkCatInci=Ext.getCmp("FlagStkCatInci").getValue();
			var FlagType=Ext.getCmp("FlagType").getValue();
			var FlagSum=Ext.getCmp("FlagSum").getValue();
			var FlagSpecDescSum=Ext.getCmp("FlagSpecDescSum").getValue();
			
			var GrpType=Ext.getCmp("StkGrpType").getValue();			//类组id
			var StkCatId=Ext.getCmp("DHCStkCatGroup").getValue();		//库存分类id
			var InciDesc=Ext.getCmp("InciDesc").getValue();				//库存项id
			if (InciDesc==null || InciDesc=="") {
				IncRowid = "";
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
			var TransferFlag=Ext.getCmp("TransferFlag").getValue();				//统计方式
			var hvFlag=Ext.getCmp("hvFlag").getValue()==true?'Y':'';
			var StartTime=Ext.getCmp("TimeFrom").getValue();
			var EndTime=Ext.getCmp("TimeTo").getValue();
			var TransRange='';
			
			var Others=GrpType+"^"+StkCatId+"^"+IncRowid+"^"+MarkType+"^"+ImpFlag+"^"+BatNo+"^"+PbFlag
			+"^"+PbLevel+"^"+""+"^"+""+"^"+""+"^"+ManfId+"^"+""+"^"+InsuType+"^"+""
			+"^"+VendorId+"^"+OperateType+"^"+MinSp+"^"+MaxSp+"^"+MinRp+"^"+MaxRp+"^"+RecLocId+"^"+hvFlag
			+"^"+StartTime+"^"+EndTime+"^"+TransRange;
			
			var reportframe=document.getElementById("reportFrame")
			var p_URL="";
			//取出查询条件
			var Conditions=""
			/*
			if(LocId!=""){
				Conditions="出库科室: "+Ext.getCmp("PhaLoc").getRawValue()
				}
			if(StartDate!=""){
				Conditions=Conditions+" 统计时间: "+StartDate+" "+StartTime
				}
		    if(EndDate!=""){
			    Conditions=Conditions+"~ "+EndDate+" "+EndTime
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
				Conditions=Conditions+" 物资名称: "+InciDesc
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
			if(hvFlag==1){
				Conditions=Conditions+" 高值: 是 "
				}
			*/
			//单品汇总
			if(FlagSum==true){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_TKPYStat_Sum.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
					'&Conditions='+Conditions;
			}
			//单品汇总(具体规格)
			else if(FlagSpecDescSum==true){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_TKPYStat_SpecDescSum.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
					'&Conditions='+Conditions;
			}
			//库存分类单品汇总
			else if(FlagStkCatInci==true){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_TKPYStat_StkCatInci.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
					'&Conditions='+Conditions;
			}
			//单品明细
			else if(FlagDetail==true){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_TKPYStat_InciDetail.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
					'&Conditions='+Conditions;
			}
			//单品明细(台帐零差异) 2018-05-23 安贞
			else if(FlagDetailZeroIntr==true){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_TKPYStat_InciDetail_ZeroIntr.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
					'&Conditions='+Conditions + '&IntrStatFlag=1';
			}
			//单品明细(台帐非零差异) 安贞
			else if(FlagDetailNotZeroIntr==true){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_TKPYStat_InciDetail_NotZeroIntr.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
					'&Conditions='+Conditions + '&IntrStatFlag=2';
			}
			//库存分类
			else if(FlagType==true){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_TKPYStat_StkCat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
					'&Conditions='+Conditions;
			}else {
				return false;
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
			tbar : [OkBT, "-", ClearBT],
			items : [{
				xtype : 'fieldset',
				title : '查询条件',
				items : [PhaLoc,RecLoc,DateFrom,TimeFrom,DateTo,TimeTo,TransferFlag,StkGrpType,DHCStkCatGroup,
					PhManufacturer,InciDesc,PHCDOfficialType,INFOMT,OperateOutType,Vendor,
					PublicBidding,INFOPBLevel,INFOImportFlag,
					{xtype:'compositefield',fieldLabel:'售价范围',items:[MinSp,{xtype:'displayfield',value:'-'},MaxSp]},
					{xtype:'compositefield',fieldLabel:'进价范围',items:[MinRp,{xtype:'displayfield',value:'-'},MaxRp]},
					{
						xtype:'checkbox',
						boxLabel : '高值标志',
						id : 'hvFlag',
						name : 'hvFlag',
						anchor : '90%',
						checked : false
					},{
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
				items : [FlagSum,FlagSpecDescSum,FlagStkCatInci,FlagDetail,FlagDetailZeroIntr,FlagDetailNotZeroIntr,FlagType]
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
						title:'出库&医嘱台帐统计',
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