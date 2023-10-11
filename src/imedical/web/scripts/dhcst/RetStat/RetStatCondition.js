// /名称: 退货汇总统计条件录入
// /描述:  退货汇总统计条件录入
// /编写者：wyx
// /编写日期: 2013.12.12
Ext.onReady(function() {
	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	var gUserName=session['LOGON.USERNAME'];
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
	
	var StartTime=new Ext.form.TextField({
		fieldLabel : '<font color=blue>'+$g('开始时间')+'</font>',
		id : 'StartTime',
		name : 'StartTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:$g('时间格式错误，正确格式hh:mm:ss'),
		width : 120
	});	
	var DateTo = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>'+$g('截止日期')+'</font>',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		value : DefaultEdDate()
	});
	var EndTime=new Ext.form.TextField({
		fieldLabel : '<font color=blue>'+$g('截止时间')+'</font>',
		id : 'EndTime',
		name : 'EndTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:$g('时间格式错误，正确格式hh:mm:ss'),
		width : 120
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
		fieldLabel :$g( '库存分类'),
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
		fieldLabel : $g('药学小类'),
		id : 'PhcMinCat',
		name : 'PhcMinCat',
		store : PhcMinCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{PhcSubCatId:'PhcSubCat'}
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
	var RetReason = new Ext.ux.ComboBox({
		fieldLabel : $g('退货原因'),
		id : 'RetReason',
		name : 'RetReason',
		store : ReasonForReturnStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'ReasonDesc'
	});

	var PHCDOfficialType = new Ext.ux.ComboBox({
		fieldLabel : $g('医保类别'),
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


		MarkTypeStore.load();
		var INFOMT = new Ext.ux.ComboBox({
					fieldLabel : $g('定价类型'),
					id : 'INFOMT',
					name : 'INFOMT',
					store : MarkTypeStore,
					valueField : 'RowId',
					displayField : 'Description'
		});

		// 退货单明细列表
		var FlagRetStatDetail = new Ext.form.Radio({
					boxLabel : $g('退货单明细'),
					id : 'FlagRetStatDetail',
					name : 'ReportType',
					anchor : '80%',
					checked : true
				});
		// 退货单汇总
		var FlagRetStat = new Ext.form.Radio({
					boxLabel : $g('退货单汇总'),
					id : 'FlagRetStat',
					name : 'ReportType',
					anchor : '80%'
				});
		// 退货单品汇总
		var FlagRetStatInci = new Ext.form.Radio({
					boxLabel : $g('退货单品汇总'),
					id : 'FlagRetStatInci',
					name : 'ReportType',
					anchor : '80%'
				});
		// 经营企业汇总
		var FlagRetStatVendor = new Ext.form.Radio({
					boxLabel : $g('经营企业汇总'),
					id : 'FlagRetStatVendor',
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
					SetLogInDept(PhaLoc.getStore(),'PhaLoc');
					Ext.getCmp("DateFrom").setValue(DefaultStDate());
					Ext.getCmp("DateTo").setValue(DefaultEdDate());
					Ext.getCmp("StkGrpType").getStore().load();
					//FlagImportDetail.setValue(true);
					document.getElementById("frameReport").src=BlankBackGroundImg;
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
			var StartDate=Ext.getCmp("DateFrom").getValue().format(App_StkDateFormat).toString();;
			var EndDate=Ext.getCmp("DateTo").getValue().format(App_StkDateFormat).toString();;
		    var startTime=Ext.getCmp("StartTime").getRawValue();
			var endTime=Ext.getCmp("EndTime").getRawValue();
			var LocId=Ext.getCmp("PhaLoc").getValue();
			var GrpType=Ext.getCmp("StkGrpType").getValue();			//类组id
			var StkCatId=Ext.getCmp("DHCStkCatGroup").getValue();		//库存分类id
			var IncRowid=Ext.getCmp("InciDr").getValue();				//库存项id
			var IncDesc=Ext.getCmp("InciDesc").getValue();
			if ((IncRowid == undefined)||(IncDesc=="")) {
				IncRowid = "";
			}
			var MarkType=Ext.getCmp("INFOMT").getValue();				//定价类型
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
			var FlagRetStatDetail=Ext.getCmp("FlagRetStatDetail").getValue();
			var FlagRetStat=Ext.getCmp("FlagRetStat").getValue();
			var FlagRetStatInci=Ext.getCmp("FlagRetStatInci").getValue();
			var FlagRetStatVendor=Ext.getCmp("FlagRetStatVendor").getValue(); //经营企业明细汇总
			var FlagRetReason=Ext.getCmp("RetReason").getValue();
			var FlagType=""
			if (FlagRetStatDetail==true) {FlagType="1"}
			if (FlagRetStat==true) {FlagType="2"}
			if (FlagRetStatInci==true) {FlagType="3"}
			if (FlagRetStatVendor==true) {FlagType="4"}
			var Others=GrpType+"^"+IncRowid+"^"+VendorId+"^"+FlagRetReason+"^"+FlagType;
			var LocDesc=Ext.getCmp("PhaLoc").getRawValue();
			var RQDTFormat=App_StkRQDateFormat+" "+App_StkRQTimeFormat;
			var reportFrame=document.getElementById("frameReport");
			var p_URL="";
			//退货单明细列表
			if(FlagRetStatDetail==true){				
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_RetStat_Detail_Common.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+"&UserName="+gUserName+"&HospDesc="+App_LogonHospDesc+"&LocDesc="+LocDesc+'&RQDTFormat='+RQDTFormat;
			} 
			//退货单汇总
			else if(FlagRetStat==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_RetStat_All_Common.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+"&UserName="+gUserName+"&HospDesc="+App_LogonHospDesc+"&LocDesc="+LocDesc+'&RQDTFormat='+RQDTFormat;
			}
			//退货单品汇总
			else if(FlagRetStatInci==true){
				
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_RetStat_Inci_Common.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+"&UserName="+gUserName+"&HospDesc="+App_LogonHospDesc+"&LocDesc="+LocDesc+'&RQDTFormat='+RQDTFormat;
			}
			//经营企业汇总
			else if(FlagRetStatVendor==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_RetStat_Vendor_Common.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+"&UserName="+gUserName+"&HospDesc="+App_LogonHospDesc+"&LocDesc="+LocDesc+'&RQDTFormat='+RQDTFormat;
			}
			reportFrame.src=p_URL;
	       
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
						items : [PhaLoc,DateFrom,StartTime,DateTo,EndTime,Vendor,StkGrpType,RetReason,InciDesc]
					}, {
						xtype : 'fieldset',
						title : $g('报表类型'),
						items : [FlagRetStatDetail,FlagRetStat,FlagRetStatInci,FlagRetStatVendor]
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
						title:$g("退货汇总"),
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