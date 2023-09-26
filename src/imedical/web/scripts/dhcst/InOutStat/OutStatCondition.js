// /名称: 出库汇总统计条件录入
// /描述: 出库汇总统计条件录入
// /编写者：zhangdongmei
// /编写日期: 2012.11.12
var gNewCatId="";
Ext.onReady(function() {
	// function loadForm1(){

	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	var UserName=session['LOGON.USERNAME'];
	var PhaLoc=new Ext.ux.LocComboBox({
		fieldLabel : '<font color=blue>出库科室</font>',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		emptyText : '科室...',
		groupId:gGroupId,
		listeners : {
			'select' : function(e) {
                          var SelLocId=Ext.getCmp('PhaLoc').getValue();//add wyx 根据选择的科室动态加载类组
                          StkGrpType.getStore().removeAll();
                          StkGrpType.getStore().setBaseParam("locId",SelLocId)
                          StkGrpType.getStore().setBaseParam("userId",UserId)
                          StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
                          StkGrpType.getStore().load();
			}
	}
	});

	var RecLoc = new Ext.ux.LocComboBox({
		fieldLabel : '接收科室',
		id : 'RecLoc',
		name : 'RecLoc',
		emptyText : '接收科室...',
		anchor : '90%',
		defaultLoc:''
	});

	var DateFrom = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>开始日期</font>',
		id : 'DateFrom',
		name : 'DateFrom',
		anchor : '90%',
		value :DefaultStDate()
	});

	var StartTime=new Ext.form.TextField({
		fieldLabel : '开始时间',
		id : 'StartTime',
		name : 'StartTime',
		anchor : '90%',
		//value :DefaultEdTime(),
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'时间格式错误，正确格式hh:mm:ss',
		width : 120,
		//value :DefaultEdTime(),
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var item=field.getValue();
					if (item != null && item.length > 0) {
						var eTime=SetCorrectTimetype(item);
						Ext.getCmp("StartTime").setValue(eTime);
					}
				}
			}
		}
	});
	//--------------------add by myq 20140414 北京同仁亦庄




 //-----------------给时间设定正确的格式 add by myq 20140420 
	function SetCorrectTimetype(item) {
	 //如果录入的信息内含有“：”则 不处理
	 if (item.indexOf(":") > 0)
	 {
	 return item ;
	 }
	 	
	 var datelength=item.length
	 var Hdate=item.substring(0,2) ;
	 var Mdate=item.substring(2,4) ;
	 var Sdate=item.substring(4,6) ;
	 
	 if (datelength<1)
	 {
	 	alert("请输入时间！")
	 	return  ;
	 	}
		if (Hdate>24)
		{
			alert("输入的小时格式错误，应在0~24之间...")
			return ;
			}
		if (Hdate.length<2){
		  var Hdate="0"+Hdate
		}
		
		if (Mdate>60)
		{
			alert("输入的分钟格式错误，应在0~60之间...")
			return ;
			}
		if (Mdate.length<1){
		  var Mdate="00"
		}
		if ((Mdate.length<2)&&(Mdate.length>0)){
		  var Mdate=Mdate+"0"
		}
		
			if (Sdate>60)
		{
			alert("输入的秒格式错误，应在0~60之间...")
			return ;
			}
		if (Sdate.length<1){
		  var Sdate="00"
		}
		if ((Sdate.length<2)&&(Sdate.length>0)) {
			var Sdate=Sdate+"0"
			}
		
		var result= Hdate+":"+Mdate+":"+Sdate
		
		 return result ;
		
	}
	//-----------------给时间设定正确的格式 add by myq 20140420 	
	var EndTime=new Ext.form.TextField({
		fieldLabel : '截止时间',
		id : 'EndTime',
		name : 'EndTime',
		anchor : '90%',
		//value :DefaultEdTime(),
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'时间格式错误，正确格式hh:mm:ss',
		width : 120,
		//value :DefaultEdTime(),
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var item=field.getValue();
					if (item != null && item.length > 0) {
						var eTime=SetCorrectTimetype(item);
						Ext.getCmp("EndTime").setValue(eTime);
					}
				}
			}
		}
	});
	//--------------------add by myq 20140414 北京同仁亦庄
	var DateTo = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>截止日期</font>',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		value : DefaultEdDate()
	});
	
	// 药品类组
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		anchor : '90%',
		StkType:App_StkTypeCode,     //标识类组类型
		LocId:gLocId,
		UserId:gUserId
	}); 

	var InciDr = new Ext.form.TextField({
		fieldLabel : '药品RowId',
		id : 'InciDr',
		name : 'InciDr',
		anchor : '90%',
		valueNotFoundText : ''
	});

	var InciCode = new Ext.form.TextField({
		fieldLabel : '药品编码',
		id : 'InciCode',
		name : 'InciCode',
		anchor : '90%',
		valueNotFoundText : ''
	});
	var InciDesc = new Ext.form.TextField({
		fieldLabel : '药品名称',
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
	 * 调用药品窗体并返回结果
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
		var inciDr = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		Ext.getCmp("InciDr").setValue(inciDr);
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
		anchor : '90%'
	});
				
	// 药学大类
	var PhcCat = new Ext.ux.ComboBox({
		fieldLabel : '药学大类',
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
		fieldLabel : '药学子类',
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
		fieldLabel : '药学小类',
		id : 'PhcMinCat',
		name : 'PhcMinCat',
		store : PhcMinCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{PhcSubCatId:'PhcSubCat'}
	});
	var PHCCATALL = new Ext.form.TextField({
	fieldLabel : '药学分类',
	id : 'PHCCATALL',
	name : 'PHCCATALL',
	width: 70,
	anchor : '90%',
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
	text : '药学分类维护',
	handler : function() {	
       PhcCatNewSelect(gNewCatId,GetAllCatNew)

    }
});

	var PHCDFPhcDoDR = new Ext.ux.ComboBox({
		fieldLabel : '管制分类',
		id : 'PHCDFPhcDoDR',
		name : 'PHCDFPhcDoDR',
		store : PhcPoisonStore,
		valueField : 'Description',
		displayField : 'Description'
	});

	var PhManufacturer = new Ext.ux.ComboBox({
		fieldLabel : '生产厂商',
		id : 'PhManufacturer',
		name : 'PhManufacturer',
		store : PhManufacturerStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PHMNFName'
	});

	/*var PHCDOfficialType = new Ext.ux.ComboBox({
		fieldLabel : '医保类别',
		id : 'PHCDOfficialType',
		name : 'PHCDOfficialType',
		anchor : '90%',
		store : OfficeCodeStore,
		valueField : 'RowId',
		displayField : 'Description'
	});*/

	var PHCForm = new Ext.ux.ComboBox({
		fieldLabel : '剂型',
		id : 'PHCForm',
		name : 'PHCForm',
		store : PhcFormStore,
		valueField : 'Description',
		displayField : 'Description',
		filterName:'PHCFDesc'
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
	Ext.getCmp("TransferFlag").setValue("0");

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

	var MinSp = new Ext.form.NumberField({
		id : 'MinSp',
		name : 'MinSp',
		width : '70',
		valueNotFoundText : ''
	});
			
	var MaxSp = new Ext.form.NumberField({
		id : 'MaxSp',
		name : 'MaxSp',
		width : '70',
		valueNotFoundText : ''
	});
	var MaxRp = new Ext.form.NumberField({
		id : 'MaxRp',
		name : 'MaxRp',
		width : '70',
		valueNotFoundText : ''
	});
	var MinRp = new Ext.form.NumberField({
		id : 'MinRp',
		name : 'MinRp',
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

					ShowReport();
				}
			});
	
	var ClearBT = new Ext.Toolbar.Button({
				id : "ClearBT",
				text : '清屏',
				tooltip : '点击清屏',
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
					Ext.getCmp("PHCCATALL").setValue("");
					SetLogInDept(PhaLoc.getStore(),'PhaLoc');
					Ext.getCmp("DateFrom").setValue(DefaultStDate());
					Ext.getCmp("DateTo").setValue(DefaultEdDate());
					Ext.getCmp("StkGrpType").getStore().load();
					FlagLocStkcat.setValue(true);
					document.getElementById("reportFrame").src=BlankBackGroundImg;
					gNewCatId=""
					Ext.getCmp("PHCCATALL").setValue("");
				}
			});
	// 科室库存分类
	var FlagLocStkcat = new Ext.form.Radio({
				boxLabel : '科室/库存分类',
				id : 'FlagLocStkcat',
				name : 'ReportType',
				anchor : '70%',
				checked : true
			});
	// 科室金额
	var FlagLoc = new Ext.form.Radio({
				boxLabel : '科室金额',
				id : 'FlagLoc',
				name : 'ReportType',
				anchor : '70%'
			});
	// 科室金额/分组统计
	var FlagLocGrp = new Ext.form.Radio({
				boxLabel : '科室金额/科室组',
				id : 'FlagLocGrp',
				name : 'ReportType',
				anchor : '70%'
			});
	// 单品汇总
	var FlagSum = new Ext.form.Radio({
				boxLabel : '单品汇总',
				id : 'FlagSum',
				name : 'ReportType',
				anchor : '70%'
			});
	// 科室单品汇总
	var FlagLocSum = new Ext.form.Radio({
				boxLabel : '科室单品汇总',
				id : 'FlagLocSum',
				name : 'ReportType',
				anchor : '70%'
			});
	// 出库明细
	var FlagDetail = new Ext.form.Radio({
				boxLabel : '出库明细',
				id : 'FlagDetail',
				name : 'ReportType',
				anchor : '70%'
			});
  // 出库单汇总
	var FlagTrf = new Ext.form.Radio({
				boxLabel : '出库单汇总',
				id : 'FlagTrf',
				name : 'ReportType',
				anchor : '70%'
			});
	// 库存分类
	var FlagType = new Ext.form.Radio({
				boxLabel : '库存分类',
				id : 'FlagType',
				name : 'ReportType',
				anchor : '70%'
			});		

		function ShowReport() {
			var StartDate=Ext.getCmp("DateFrom").getValue()
			var EndDate=Ext.getCmp("DateTo").getValue()
			if(StartDate==""||EndDate=="")
			{
				Msg.info("warning", "开始日期和截止日期不能空！");
				return;
			}
			var StartDate=Ext.getCmp("DateFrom").getValue().format(App_StkDateFormat).toString();;
			var EndDate=Ext.getCmp("DateTo").getValue().format(App_StkDateFormat).toString();;
		    var startTime=Ext.getCmp("StartTime").getRawValue();
			var endTime=Ext.getCmp("EndTime").getRawValue();
			if(StartDate==EndDate && startTime>endTime){
				Msg.info("warning", "开始时间大于截止时间！");
				return;
			}
			var LocId=Ext.getCmp("PhaLoc").getValue();
			
			var FlagLocStkcat=Ext.getCmp("FlagLocStkcat").getValue();
			var FlagLoc=Ext.getCmp("FlagLoc").getValue();
			var FlagLocGrp=Ext.getCmp("FlagLocGrp").getValue();
			var FlagDetail=Ext.getCmp("FlagDetail").getValue();
			var FlagTrf=Ext.getCmp("FlagTrf").getValue();
			var FlagType=Ext.getCmp("FlagType").getValue();
			var FlagLocSum=Ext.getCmp("FlagLocSum").getValue();
			var FlagSum=Ext.getCmp("FlagSum").getValue();
			
			var GrpType=Ext.getCmp("StkGrpType").getValue();			//类组id
			var StkCatId=Ext.getCmp("DHCStkCatGroup").getValue();		//库存分类id
			var IncRowid=Ext.getCmp("InciDr").getValue();				//库存项id
			if (IncRowid == undefined) {
				IncRowid = "";
			}
			var InciDesc=Ext.getCmp("InciDesc").getValue();
			if(InciDesc==null || InciDesc==""){
				IncRowid="";
			}
			var MarkType=Ext.getCmp("INFOMT").getValue();				//定价类型
			var ImpFlag=Ext.getCmp("INFOImportFlag").getValue();		//进口标志
			var BatNo='';											//生产批号
			var PbFlag=Ext.getCmp("PublicBidding").getValue();		//招标标志
			var PbLevel=Ext.getCmp("INFOPBLevel").getValue();			//招标级别
			var PhcCatId=Ext.getCmp("PhcCat").getValue();				//药学大类id
			var PhcSubCatId=Ext.getCmp("PhcSubCat").getValue();			//药学子类id
			var PhcMinCatId=Ext.getCmp("PhcMinCat").getValue();			//药学小类id
			var ManfId=Ext.getCmp("PhManufacturer").getValue();			//生产厂商id
			var Form=Ext.getCmp("PHCForm").getValue();					//剂型
			var InsuType="" //Ext.getCmp("PHCDOfficialType").getValue();		//医保类型
			var PosionCat=Ext.getCmp("PHCDFPhcDoDR").getValue();		//管制分类
			var VendorId=Ext.getCmp("Vendor").getValue();				//供应商id
			var OperateType=Ext.getCmp("OperateOutType").getValue();		//出库类型
			var MinSp=Ext.getCmp("MinSp").getValue();				//最低售价
			var MaxSp=Ext.getCmp("MaxSp").getValue();				//最高售价
			var MinRp=Ext.getCmp("MinRp").getValue();				//最低进价
			var MaxRp=Ext.getCmp("MaxRp").getValue();				//最高进价
			var RecLocId=Ext.getCmp("RecLoc").getValue();			//接收科室
			var TransferFlag=Ext.getCmp("TransferFlag").getValue();				//统计方式
			
			var Others=GrpType+"^"+StkCatId+"^"+IncRowid+"^"+MarkType+"^"+ImpFlag+"^"+BatNo+"^"+PbFlag
			+"^"+PbLevel+"^"+PhcCatId+"^"+PhcSubCatId+"^"+PhcMinCatId+"^"+ManfId+"^"+Form+"^"+InsuType+"^"+PosionCat
			+"^"+VendorId+"^"+OperateType+"^"+MinSp+"^"+MaxSp+"^"+MinRp+"^"+MaxRp+"^"+RecLocId+"^"+gNewCatId;
			var RQDTFormat=App_StkRQDateFormat+" "+App_StkRQTimeFormat;
			var reportframe=document.getElementById("reportFrame")
			var p_URL="";
			
			//科室库存分类
			if(FlagLocStkcat==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_TransferOutStat-LocStkcat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			
				//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.INVDetail&sUser="+sUser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
				//websys_createWindow(p_URL,1,"width=330,height=160,top=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
				//var NewWin=open(p_URL,"出库汇总-科室/库存分类","top=20,left=20,width=930,height=660,scrollbars=1");
			} 
			//科室金额
			else if(FlagLoc==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_TransferOutStat-Loc.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
						}
			//科室组
			else if(FlagLocGrp==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_TransferOutStat-LocGrp.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
			//单品汇总
			else if(FlagSum==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_TransferOutStat-Sum.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
			//科室单品汇总
			else if(FlagLocSum==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_TransferOutStat-LocSum.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
			//出库明细
			else if(FlagDetail==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_TransferOutStat-Detail.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
			//出库单汇总
			else if(FlagTrf==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_TransferOutStat-Trf.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
			//库存分类
			else if(FlagType==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_TransferOutStat-Type.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
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
				items : [PhaLoc,DateFrom,StartTime,DateTo,EndTime,TransferFlag,RecLoc,StkGrpType,DHCStkCatGroup,{xtype:'compositefield',items:[PHCCATALL,PHCCATALLButton]},
				PhManufacturer,PHCForm,PHCDFPhcDoDR,InciDesc,INFOMT,OperateOutType,Vendor,
				PublicBidding,INFOPBLevel,INFOImportFlag,
				{xtype:'compositefield',fieldLabel:'售价范围',items:[MinSp,{xtype:'displayfield',value:'-'},MaxSp]},
				{xtype:'compositefield',fieldLabel:'进价范围',items:[MinRp,{xtype:'displayfield',value:'-'},MaxRp]}]
											
			}, {
				xtype : 'fieldset',
				title : '报表类型',
				labelWidth : 40,
				items : [FlagLocStkcat,FlagLoc,FlagLocGrp,FlagSum,FlagLocSum,FlagDetail,FlagTrf,FlagType]
			}]
		});

		var reportPanel=new Ext.Panel({
			//autoScroll:true,
			//frame:true,
			html:'<iframe id="reportFrame" height="100%" width="100%" style="border:none" src='+DHCSTBlankBackGround+'>'

		})
		// 页面布局
		var mainPanel = new Ext.Viewport({
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
						items:reportPanel
					}]
				});

	
});