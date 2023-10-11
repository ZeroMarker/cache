// /名称: 入库汇总统计条件录入
// /描述:  入库汇总统计条件录入
// /编写者：zhangdongmei
// /编写日期: 2012.01.17
var gNewCatId="";
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	var UserName=session['LOGON.USERNAME'];
	var PhaLoc=new Ext.ux.LocComboBox({
		fieldLabel : '<font color=blue>'+$g('科室')+'</font>',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		emptyText : $g('科室...'),
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
	
	var DateFrom = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>'+$g('开始日期')+'</font>',
		id : 'DateFrom',
		name : 'DateFrom',
		anchor : '90%',
		value :DefaultStDate()
	});
	/*
	var StartTime=new Ext.form.TextField({
		fieldLabel : '<font color=blue>开始时间</font>',
		id : 'StartTime',
		name : 'StartTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'时间格式错误，正确格式hh:mm:ss',
		width : 120
	});
	*/
	var StartTime=new Ext.form.TextField({
		fieldLabel : $g('开始时间'),
		id : 'StartTime',
		name : 'StartTime',
		anchor : '90%',
		//value :DefaultEdTime(),
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:$g('时间格式错误，正确格式hh:mm:ss'),
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
	 	alert($g("请输入时间！"))
	 	return  ;
	 	}
		if (Hdate>24)
		{
			alert($g("输入的小时格式错误，应在0~24之间..."))
			return ;
			}
		if (Hdate.length<2){
		  var Hdate="0"+Hdate
		}
		
		if (Mdate>60)
		{
			alert($g("输入的分钟格式错误，应在0~60之间..."))
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
			alert($g("输入的秒格式错误，应在0~60之间..."))
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
	var DateTo = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>'+$g('截止日期')+'</font>',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		value : DefaultEdDate()
	});
	/*
	var EndTime=new Ext.form.TextField({
		fieldLabel : '<font color=blue>截止时间</font>',
		id : 'EndTime',
		name : 'EndTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'时间格式错误，正确格式hh:mm:ss',
		width : 120
	});
	*/
	var EndTime=new Ext.form.TextField({
		fieldLabel : $g('截止时间'),
		id : 'EndTime',
		name : 'EndTime',
		anchor : '90%',
		//value :DefaultEdTime(),
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:$g('时间格式错误，正确格式hh:mm:ss'),
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
				fieldLabel : $g('药品RowId'),
				id : 'InciDr',
				name : 'InciDr',
				valueNotFoundText : ''
			});

	var InciCode = new Ext.form.TextField({
				fieldLabel : $g('药品编码'),
				id : 'InciCode',
				name : 'InciCode',
				anchor : '90%',
				valueNotFoundText : ''
			});
	var InciDesc = new Ext.form.TextField({
				fieldLabel : $g('药品名称'),
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
		fieldLabel : $g('药学子类'),
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
		fieldLabel :$g( '药学小类'),
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
	text :$g( '药学分类维护'),
	handler : function() {	
       PhcCatNewSelect(gNewCatId,GetAllCatNew)

    }
});
	var PHCDFPhcDoDR = new Ext.ux.ComboBox({
		fieldLabel : $g('管制分类'),
		id : 'PHCDFPhcDoDR',
		name : 'PHCDFPhcDoDR',
		store : PhcPoisonStore,
		valueField : 'Description',
		displayField : 'Description'
	});

	var PhManufacturer = new Ext.ux.ComboBox({
		fieldLabel : $g('生产企业'),
		id : 'PhManufacturer',
		name : 'PhManufacturer',
		store : PhManufacturerStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PHMNFName'
	});

	var PHCDOfficialType = new Ext.ux.ComboBox({
		fieldLabel :$g( '医保类别'),
		id : 'PHCDOfficialType',
		name : 'PHCDOfficialType',
		store : OfficeCodeStore,
		valueField : 'Description',
		displayField : 'Description'
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

		var INFOPBLevel = new Ext.ux.ComboBox({
					fieldLabel : $g('招标级别'),
					id : 'INFOPBLevel',
					name : 'INFOPBLevel',
					store : INFOPBLevelStore,
					valueField : 'RowId',
					displayField : 'Description'
				});

		var RetFlag = new Ext.form.Checkbox({
					boxLabel : $g('是否包含退货'),
					id : 'RetFlag',
					name : 'RetFlag',
					anchor : '90%',
					checked : true
				});
		var SpFlag = new Ext.form.Checkbox({
					boxLabel : $g('批次售价不等于售价'),
					id : 'SpFlag',
					name : 'SpFlag',
					anchor : '90%',
					checked : false
				});
              var INFOBasicDrug = new Ext.form.Checkbox({
			           boxLabel : $g('基本药物标志'),
		                  id : 'INFOBasicDrug',
		                  name : 'INFOBasicDrug',
		                  anchor : '90%',
			           checked : false
		                });
		MarkTypeStore.load();
		var INFOMT = new Ext.ux.ComboBox({
					fieldLabel : $g('定价类型'),
					id : 'INFOMT',
					name : 'INFOMT',
					store : MarkTypeStore,
					valueField : 'RowId',
					displayField : 'Description'
		});
		
				// 入库类型
		var OperateInType = new Ext.ux.ComboBox({
					fieldLabel : $g('入库类型'),
					id : 'OperateInType',
					name : 'OperateInType',
					store : OperateInTypeStore,
					valueField : 'RowId',
					displayField : 'Description'
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
			mode : 'local',
			allowBlank : true,
			triggerAction : 'all',
			selectOnFocus : true,
			listWidth : 150,
			forceSelection : true
		});
	var InvNo = new Ext.form.TextField({
				fieldLabel : $g('发票号'),
				id : 'InvNo',
				name : 'InvNo',
				anchor : '90%',
				valueNotFoundText : ''
		});
				
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
	
		// 入库单列表
		var FlagImportDetail = new Ext.form.Radio({
					boxLabel : $g('入库单列表'),
					id : 'FlagImportDetail',
					name : 'ReportType',
					anchor : '80%',
					checked : true
				});
		// 单品汇总
		var FlagItmStat = new Ext.form.Radio({
					boxLabel : $g('单品汇总'),
					id : 'FlagItmStat',
					name : 'ReportType',
					anchor : '80%'
				});
		// 经营企业汇总
		var FlagVendorStat = new Ext.form.Radio({
					boxLabel : $g('经营企业汇总'),
					id : 'FlagVendorStat',
					name : 'ReportType',
					anchor : '80%'
				});
		// 经营企业明细汇总
		var FlagVendorItmStat = new Ext.form.Radio({
					boxLabel : $g('经营企业明细汇总'),
					id : 'FlagVendorItmStat',
					name : 'ReportType',
					anchor : '80%'
				});	
		// 经营企业类组汇总
		var FlagVendorStkGrpStat = new Ext.form.Radio({
					boxLabel : $g('经营企业类组汇总'),
					id : 'FlagVendorStkGrpStat',
					name : 'ReportType',
					anchor : '80%'
				});
		// 类组汇总
		var FlagStkGrpStat = new Ext.form.Radio({
					boxLabel : $g('类组汇总'),
					id : 'FlagStkGrpStat',
					name : 'ReportType',
					anchor : '80%'
				});	
		// 库存分类汇总
		var FlagStockStat = new Ext.form.Radio({
					boxLabel : $g('库存分类汇总'),
					id : 'FlagStockStat',
					name : 'ReportType',
					anchor : '80%'
				});				
	   // 入库单汇总
		var FlagRecItmSumStat = new Ext.form.Radio({
					boxLabel : $g('入库单汇总'),
					id : 'FlagRecItmSumStat',
					name : 'ReportType',
					anchor : '80%'
				});	
	   // 入库单(进价)汇总
		var FlagRpItmSumStat = new Ext.form.Radio({
					boxLabel : $g('入库单(进价)汇总'),
					id : 'FlagRpItmSumStat',
					name : 'ReportType',
					anchor : '80%'
				});	
	var ClearBT = new Ext.Toolbar.Button({
				id : "ClearBT",
				text : $g('清屏'),
				tooltip : $g('点击清屏'),
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
					FlagImportDetail.setValue(true);
					RetFlag.setValue(true);
					document.getElementById("frameReport").src=BlankBackGroundImg;
					gNewCatId=""
					Ext.getCmp("PHCCATALL").setValue("");
				}
			});
		// 统计按钮
		var OkBT = new Ext.Toolbar.Button({
					id : "OkBT",
					text : $g('统计'),
					tooltip : $g('点击统计'),
					width : 70,
					iconCls : 'page_find',
					height : 30,
					handler : function() {
						
						ShowReport();
					}
				}); 

		function ShowReport()
		{
			var StartDate=Ext.getCmp("DateFrom").getValue()
			var EndDate=Ext.getCmp("DateTo").getValue()
			if(StartDate==""||EndDate=="")
			{
				Msg.info("warning",$g( "开始日期和截止日期不能空！"));
				return;
			}
			var StartDate=Ext.getCmp("DateFrom").getValue().format(App_StkDateFormat).toString();;
			var EndDate=Ext.getCmp("DateTo").getValue().format(App_StkDateFormat).toString();;
		    var startTime=Ext.getCmp("StartTime").getRawValue();
			var endTime=Ext.getCmp("EndTime").getRawValue();
			if(StartDate==EndDate && startTime>endTime){
				Msg.info("warning", $g("开始时间大于截止时间！"));
				return;
			}
			var LocId=Ext.getCmp("PhaLoc").getValue();
			var RetFlag=Ext.getCmp("RetFlag").getValue();
			if(RetFlag==true){
				RetFlag=1;
			}
			else{
				RetFlag=0;
			}
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
			var ManfId=Ext.getCmp("PhManufacturer").getValue();			//生产企业id
			var Form=Ext.getCmp("PHCForm").getValue();					//剂型
			var InsuType=Ext.getCmp("PHCDOfficialType").getValue();		//医保类型
			var PosionCat=Ext.getCmp("PHCDFPhcDoDR").getValue();		//管制分类
			var VendorId=Ext.getCmp("Vendor").getValue();				//经营企业id
			var OperateType=Ext.getCmp("OperateInType").getValue();		//入库类型
			var MinSp=Ext.getCmp("MinSp").getValue();				//最低售价
			var MaxSp=Ext.getCmp("MaxSp").getValue();				//最高售价
			var MinRp=Ext.getCmp("MinRp").getValue();				//最低进价
			var MaxRp=Ext.getCmp("MaxRp").getValue();				//最高进价
			var InvNo=Ext.getCmp("InvNo").getValue();				//发票号
			
			var SpFlag=0 //Ext.getCmp("SpFlag").getValue();				//批次售价不等于售价标志
			/*if(SpFlag==true){
				SpFlag=1;
			}
			else{
				SpFlag=0;
			}*/
			var INFOBasicDrug=Ext.getCmp("INFOBasicDrug").getValue();				//批次售价不等于售价标志
			if(INFOBasicDrug==true){
				INFOBasicDrug=1;
			}
			else{
				INFOBasicDrug=0;
			}
			
			var FlagImportDetail=Ext.getCmp("FlagImportDetail").getValue();
			var FlagItmStat=Ext.getCmp("FlagItmStat").getValue();
			var FlagVendorStat=Ext.getCmp("FlagVendorStat").getValue();
			var FlagVendorItmStat=Ext.getCmp("FlagVendorItmStat").getValue(); //经营企业明细汇总
			var FlagStkGrpStat=Ext.getCmp("FlagStkGrpStat").getValue();        //类组汇总
			var FlagStockStat=Ext.getCmp("FlagStockStat").getValue();       //库存分类汇总
			var FlagRecItmSumStat=Ext.getCmp("FlagRecItmSumStat").getValue();       //入库单汇总
			var FlagRpItmSumStat=Ext.getCmp("FlagRpItmSumStat").getValue();      //入库单(进价)汇总 
			var FlagVendorStkGrpStat=Ext.getCmp("FlagVendorStkGrpStat").getValue(); //经营企业类组 
			var RQDTFormat=App_StkRQDateFormat+" "+App_StkRQTimeFormat;
			var Others=GrpType+"^"+StkCatId+"^"+IncRowid+"^"+MarkType+"^"+ImpFlag+"^"+BatNo+"^"+PbFlag
			+"^"+PbLevel+"^"+PhcCatId+"^"+PhcSubCatId+"^"+PhcMinCatId+"^"+ManfId+"^"+Form+"^"+InsuType+"^"+PosionCat
			+"^"+VendorId+"^"+OperateType+"^"+MinSp+"^"+MaxSp+"^"+MinRp+"^"+MaxRp+"^"+InvNo+"^"+SpFlag+"^"+INFOBasicDrug+"^"+gNewCatId;
			var reportFrame=document.getElementById("frameReport");
			var p_URL="";
			//入库单列表
			if(FlagImportDetail==true){
				
				p_URL = 'dhccpmrunqianreport.csp?reportName=importdetail.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&RetFlag='+RetFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;

				//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.INVDetail&sUser="+sUser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
				//websys_createWindow(p_URL,1,"width=330,height=160,top=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
				//var NewWin=open(p_URL,"入库单列表","top=20,left=20,width=930,height=660,scrollbars=1");
			} 
			//单品汇总
			else if(FlagItmStat==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=importitmstat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&RetFlag='+RetFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
			//经营企业汇总
			else if(FlagVendorStat==true){
				
				p_URL = 'dhccpmrunqianreport.csp?reportName=importvendorstat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&RetFlag='+RetFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
			//经营企业明细汇总
			else if(FlagVendorItmStat==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=importvendoitmrstat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&RetFlag='+RetFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
			//类组汇总
			else if(FlagStkGrpStat==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=importstkgrpstat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&RetFlag='+RetFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
			//库存分类汇总
			else if(FlagStockStat==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=importstockstat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&RetFlag='+RetFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
			//入库单汇总
			else if(FlagRecItmSumStat==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=importrecitmsumstat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&RetFlag='+RetFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
			//入库单品(进价)汇总
			else if(FlagRpItmSumStat==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=importrpitmsumstat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&RetFlag='+RetFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
			//经营企业类组汇总
			else if(FlagVendorStkGrpStat==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=importvendorstkgrpstat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&RetFlag='+RetFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
			reportFrame.src=p_URL;
			
			//window.open (p_URL, 'newwindow', 'height=100, width=400, top=0, left=0, toolbar=no, menubar=no, scrollbars=no,resizable=no,location=no, status=no'); 
		}
		var HisListTab = new Ext.form.FormPanel({
			id : 'HisListTab',
			labelWidth : 60,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:5px;',
			tbar : [OkBT,'-',ClearBT],
			items : [{
						xtype : 'fieldset',
						title : $g('查询条件'),					
						items : [PhaLoc,DateFrom,StartTime,DateTo,EndTime,Vendor,StkGrpType,DHCStkCatGroup,{xtype:'compositefield',items:[PHCCATALL,PHCCATALLButton]},
							PhManufacturer,PHCForm,PHCDFPhcDoDR,InciDesc,INFOMT,OperateInType,
							INFOImportFlag,PublicBidding,INFOPBLevel,InvNo,
							{xtype:'compositefield',fieldLabel:$g('售价范围'),items:[MinSp,{xtype:'displayfield',value:'-'},MaxSp]},
							{xtype:'compositefield',fieldLabel:$g('进价范围'),items:[MinRp,{xtype:'displayfield',value:'-'},MaxRp]},
							RetFlag,INFOBasicDrug]  //,SpFlag
					}, {
						xtype : 'fieldset',
						title : $g('报表类型'),
						items : [FlagImportDetail,FlagItmStat,FlagVendorStat,FlagVendorItmStat,FlagVendorStkGrpStat,FlagStkGrpStat,FlagStockStat,FlagRecItmSumStat,FlagRpItmSumStat]
					}]
		});

	var reportPanel=new Ext.Panel({
		//autoScroll:true,
		layout:'fit',
		html:'<iframe id="frameReport" height="100%" width="100%" style="border:none" src='+DHCSTBlankBackGround+'>'
	})
	// 页面布局
	var mainPanel = new Ext.Viewport({
				layout : 'border',
				items : [{
					region:'west',
					title:$g("入库汇总"),
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
					items:reportPanel
				}]
	});
				
});