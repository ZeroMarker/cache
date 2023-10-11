// /名称: 物流项物价信息维护
// /描述: 物流项物价信息维护
// /编写者：基础数据平台-陈莹
// /编写日期: 2015-07-22
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
Ext.onReady(function() {
	
	
		Ext.QuickTips.init();
		Ext.form.Field.prototype.msgTarget = 'qtip';
		var pagesize=10;  
		
		
		//收费类型  User.DHCItmAddionInfo-->User.DHCItmChargeType
		 var DHCItmChargeType_QUERY_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.INCItmNew&pClassQuery=GetDataForChgType";
		//// 账单组查询数据
 		var BillGroup_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCBillGrp&pClassQuery=GetDataForCmb1";
		/// 账单子组查询数据
		var BillSubGroup_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCBillSub&pClassQuery=GetDataForCmb1";
	 	//医嘱子类ARCIM_ItemCat_DR
		var ItemCat_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemCat&pClassQuery=GetDataForCmb1";
	 	///药物查找ARCIM_PHCDF_DR
		//var GetDrugList_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.INCItmNew&pClassQuery=GetDrugList";
		///服务资源组查询数据ARCIM_ServiceGroup_DR
		var resourcegroup_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.RBCServiceGroup&pClassQuery=GetDataForCmb1";

		var DrugInfoStoreUrl = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.INCItmNew&pClassQuery=GetARCIMList";
		//单位TARIUOM
		var TARI_UOM_QUERY_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTUOM&pClassQuery=GetDataForCmb1";
		
		
		
		//收费项目子类TARISubCate
	    var SubCate_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.QueryForARCItmMast&pClassQuery=chargesubcat";
		//收费会计子类TARIAcctCate
		var AcctCate_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.QueryForARCItmMast&pClassQuery=acctsubcat";
	    //// 住院费用子类TARIInpatCate
 		var InpatCate_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.QueryForARCItmMast&pClassQuery=inpatsubcat";
		/// 门诊费用子类查询数据TARIOutpatCate
		var OutpatCate_ACTION_URL =  "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.QueryForARCItmMast&pClassQuery=outpatsubcat";
		/// 经济核算子类TARIEMCCate
		var EMCCate_ACTION_URL ="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.QueryForARCItmMast&pClassQuery=emcsubcat";
		/// 旧病案首页子类查询数据TARIMRCate
		var MRCate_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.QueryForARCItmMast&pClassQuery=mrsubcat";
		/// 新病案首页子类查询数据TARIMCNew
		var MCNew_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.QueryForARCItmMast&pClassQuery=GetMCNew";
		
		/*
		// 收费项目子类TARISubCate
	    var SubCate_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarSubCate&pClassQuery=GetDataForCmb1";
		// 收费会计子类TARIAcctCate
		var AcctCate_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarAcctCate&pClassQuery=GetDataForCmb1";
	    // 住院费用子类TARIInpatCate
		var InpatCate_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarInpatCate&pClassQuery=GetDataForCmb1";
		// 门诊费用子类查询数据TARIOutpatCate
		var OutpatCate_ACTION_URL =  "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarOutpatCate&pClassQuery=GetDataForCmb1";
		// 经济核算子类TARIEMCCate
		var EMCCate_ACTION_URL ="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarEMCCate&pClassQuery=GetDataForCmb1";
		// 旧病案首页子类查询数据TARIMRCate
		var MRCate_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarMRCate&pClassQuery=GetDataForCmb1";
		// 新病案首页子类查询数据TARIMCNew
		var MCNew_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCNewTarMRCate&pClassQuery=GetDataForCmb1";
		
		 */
		
		
		
		//优先级OLTPriorityDR
	  	var OLTPriorityDR_QUERY_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.OECPriority&pClassQuery=GetDataForCmb1";
		//用法OLTInstDR
	    var OLTInstDR_QUERY_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PHCInstruc&pClassQuery=GetDataForCmb1";
		var AliasStoreUrl = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.INCItmNew&pClassQuery=GetAlias";
		var Alias_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.INCItmNew&pClassMethod=SaveTaritemAliasEntity&pEntityName=web.Entity.CT.DHCTarItemAlias";
		var ALIAS_DELETE_ACTION_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.INCItmNew&pClassMethod=DeleteTarAlias";
		var PriceStoreUrl = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.INCItmNew&pClassQuery=FindTarPrice";
	 	var Price_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.INCItmNew&pClassMethod=SaveTarItemPriceEntity&pEntityName=web.Entity.CT.DHCTarItemPrice";
		//患者费别TPPatInsType
		var PACAdmReason_QUERY_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACAdmReason&pClassQuery=GetDataForCmb1";
		var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.INCItmNew&pClassMethod=OpenData";
    	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.INCItmNew&pClassMethod=SaveTariEntity&pEntityName=web.Entity.CT.DHCTarItem1";
	
//============================查询条件=========================================================================	
	
		
		Ext.apply(Ext.form.VTypes, {										   
		cKDate:function(val, field){
			var v1 = Ext.getCmp("TARIStartDate").getValue();
    		var v2 = Ext.getCmp("TARIEndDate").getValue();
    		if(v1=="" || v2=="") return true;
    		return v2 > v1;
		},
		cKDateText:'结束日期应该大于开始日期'
	});
	
	Ext.apply(Ext.form.VTypes, {										   
		cKDate1:function(val, field){
			var v1 = Ext.getCmp("OLTStartDate").getValue();
    		var v2 = Ext.getCmp("OLTEndDate").getValue();
    		if(v1=="" || v2=="") return true;
    		return v2 > v1;
		},
		cKDate1Text:'结束日期应该大于开始日期'
	});
	
	Ext.apply(Ext.form.VTypes, {										   
		cKDate2:function(val, field){
			var v1 = Ext.getCmp("TPStartDate").getValue();
    		var v2 = Ext.getCmp("TPEndDate").getValue();
    		if(v1=="" || v2=="") return true;
    		return v2 > v1;
		},
		cKDate2Text:'结束日期应该大于开始日期'
	});
		// 医嘱代码
		var ARCIM_Code = new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '医嘱代码',
			id : 'ARCIM_Code',
			name : 'ARCIM_Code'
		});

		// 医嘱名称
		var ARCIM_Desc = new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '医嘱名称',
			id : 'ARCIM_Desc',
			name : 'ARCIM_Desc'
		});
	
		// 医嘱别名
		var ALIAS_Text = new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '医嘱别名',
			id : 'ALIAS_Text',
			name : 'ALIAS_Text'
		});
		
		 
	     //收费类型  User.DHCItmAddionInfo-->User.DHCItmChargeType
		 var INFO_ChargeType = new Ext.BDP.Component.form.ComboBox({
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			emptyText:'',
			fieldLabel : '收费类型',
			id:'INFO_ChargeType',
			listWidth : 250,
			//hiddenName : 'INFO_ChargeType',
			store : new Ext.data.Store({
						autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : DHCItmChargeType_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'ICTDesc',mapping:'ICTDesc'},
						{name:'ICTRowId',mapping:'ICTRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'ICTDesc',
			valueField : 'ICTRowId'
	   });
	   var rowid =tkMakeServerCall("web.DHCBL.CT.INCItmNew","GetChgTypeID","加成收费");
	   Ext.getCmp('INFO_ChargeType').setValue(rowid);//默认为加成收费
	    
	    
	    
		// 收费标志
		var ARCIM_ChargeLinkFlag = new Ext.BDP.FunLib.Component.Checkbox({
			fieldLabel : '关联收费项目',
			id : 'ARCIM_ChargeLinkFlag',
			name : 'ARCIM_ChargeLinkFlag',
			//inputValue:'Y',
			checked : false,  ///默认查询未关联收费项的医嘱项目
			listeners:{
			'check':function(e){
				//alert(Number(Ext.getCmp('ARCIM_ChargeLinkFlag').getValue())+"check");
				if (Number(Ext.getCmp('ARCIM_ChargeLinkFlag').getValue()))
				{
					Ext.getCmp('TARIDesc1').enable();
				}
				else
				{
					Ext.getCmp('TARIDesc1').reset();
					Ext.getCmp('TARIDesc1').disable();
				}
       	 		
			}
			
			
		}
		});
		// 可用医嘱
		var ARCIM_EnableFlag = new Ext.BDP.FunLib.Component.Checkbox({
			fieldLabel : '可用医嘱',
			id : 'ARCIM_EnableFlag',
			name : 'ARCIM_EnableFlag',
			//inputValue:'Y',
			checked : true  ///默认查询可用医嘱项目  （医嘱项开始日期早于等于今天，结束日期为空或者晚于等于今天）
		});
		// 收费项名称
		var TARIDesc1 = new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '收费项名称',
			id : 'TARIDesc1',
			name : 'TARIDesc1'
		});
		
		var UpdateDate = new Ext.BDP.FunLib.Component.ComboBox({
							fieldLabel : '修改时间',
							id : 'UpdateDate',
							mode : 'local',
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							listWidth : 100,
							valueField : 'value',
							displayField : 'name',
							store : new Ext.data.JsonStore({
										fields : ['name', 'value'],
										data : [{
													name : '全部',
													value : 'A'
												}, {
													name : '今天',
													value : 'T'
												}, {
													name : '昨天',
													value : 'Y'
												}, {
													name : '一周内',
													value : 'W'
												}, {
													name : '一月内',
													value : 'M'
												
												}]
									})
						});
		Ext.getCmp("UpdateDate").setValue("A")
		//账单组
		var billGrp = new Ext.BDP.Component.form.ComboBox({
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			emptyText:'',
			fieldLabel : '账单组',
			id:'billGrp',
			listWidth : 250,
			//hiddenName : 'INFO_ChargeType',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : BillGroup_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'ARCBGDesc',mapping:'ARCBGDesc'},
						{name:'ARCBGRowId',mapping:'ARCBGRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'ARCBGDesc',
			valueField : 'ARCBGRowId',
			listeners:{
			'select':function(combo,record,index){
				Ext.getCmp('ARCIM_BillSub_DR').reset();
       	 		
			}
			
			
			
		}
		 
	   });
	 
		// 账单子组 
		var ARCIM_BillSub_DR = new Ext.BDP.Component.form.ComboBox({
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			emptyText:'',
			fieldLabel : '账单子组',
			id:'ARCIM_BillSub_DR',
			listWidth : 250,
			//hiddenName : 'INFO_ChargeType',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : BillSubGroup_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'ARCSGDesc',mapping:'ARCSGDesc'},
						{name:'ARCSGRowId',mapping:'ARCSGRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'ARCSGDesc',
			valueField : 'ARCSGRowId',
			 listeners:{
		         	'beforequery':function(obj){
		         		obj.combo.store.baseParams = {
		          				desc:obj.combo.getRawValue(),
		     	  				ParRef:Ext.getCmp("billGrp").getValue()
						};
         				obj.combo.store.load();
         		  		return false;         		
              		}
			 }
	   });
	 
		// 医嘱子类
		var ARCIM_ItemCat_DR = new Ext.BDP.Component.form.ComboBox({
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			emptyText:'',
			fieldLabel : '医嘱子类',
			id:'ARCIM_ItemCat_DR',
			listWidth : 250,
			//hiddenName : 'INFO_ChargeType',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : ItemCat_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'ARCICDesc',mapping:'ARCICDesc'},
						{name:'ARCICRowId',mapping:'ARCICRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'ARCICDesc',
			valueField : 'ARCICRowId'
	   });
	   
	  
	   
		/*// 药物查找
		var ARCIM_PHCDF_DR = new Ext.BDP.Component.form.ComboBox({
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			emptyText:'',
			fieldLabel : '药物查找',   
			id:'ARCIM_PHCDF_DR',
			listWidth : 250,
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : GetDrugList_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'PHCDCodePHCDName',mapping:'PHCDCodePHCDName'},
						{name:'PHCDRowId',mapping:'PHCDRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'PHCDCodePHCDName',  ///PHCDCodePHCDName=PHCDCode_"-"_PHCDName
			valueField : 'PHCDRowId'
	   });
	   */
	   
	  
		// 服务资源组
		var ARCIM_ServiceGroup_DR = new Ext.BDP.Component.form.ComboBox({
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			emptyText:'',
			fieldLabel : '服务资源组',
			id:'ARCIM_ServiceGroup_DR',
			listWidth : 250,
			//hiddenName : 'INFO_ChargeType',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : resourcegroup_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'SGDesc',mapping:'SGDesc'},
						{name:'SGRowId',mapping:'SGRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'SGDesc',
			valueField : 'SGRowId'
	   });
		
	 
	 
	  		
	var DrugInfoStore = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : DrugInfoStoreUrl}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},[{
								name : 'ARCIMRowId',
								mapping : 'ARCIMRowId',
								type : 'string'   //医嘱项rowid  858||1
							}, {
								name : 'ARCIMCode',
								mapping : 'ARCIMCode',
								type : 'string'
							}, {
								name : 'ARCIMDesc',
								mapping : 'ARCIMDesc',
								type : 'string'
							}, {
								name : 'INCIRowId',
								mapping : 'INCIRowId',
								type : 'string'
							}, {
								name : 'TARIRowId',
								mapping : 'TARIRowId',
								type : 'string'
							}, {
								name : 'OLTRowId',
								mapping : 'OLTRowId',
								type : 'string'
							}, {
								name : 'INCIDesc',
								mapping : 'INCIDesc',
								type : 'string'
							}, {
								name : 'INCICode',
								mapping : 'INCICode',
								type : 'string'
							}, {
								name : 'INCICTUOMDR',
								mapping : 'INCICTUOMDR',
								type : 'string'
							}, {
								name : 'INCICTUOMPurchDR',
								mapping : 'INCICTUOMPurchDR',
								type : 'string'
							}, {
								name : 'ResultRPFactor',
								mapping : 'ResultRPFactor',
								type : 'string'
							}, {
								name : 'INFOPbRp',
								mapping : 'INFOPbRp',
								type : 'string'
							}, {
								name : 'INFOPbVendorDR',
								mapping : 'INFOPbVendorDR',
								type : 'string'
							}, {
								name : 'INFOPbVendorDRID',
								mapping : 'INFOPbVendorDRID',
								type : 'string'
							}, {
								name : 'INFOPbManfDR',
								mapping : 'INFOPbManfDR',
								type : 'string'
							}, {
								name : 'INFOPbManfDRID',
								mapping : 'INFOPbManfDRID',
								type : 'string'
							}, {
								name : 'INFORowId',
								mapping : 'INFORowId',
								type : 'string'
							}, {
								name : 'TARIActiveFlag',
								mapping : 'TARIActiveFlag',
								type : 'string'
								
							}, {
								name : 'TARISpecialFlag',
								mapping : 'TARISpecialFlag',
								type : 'string'
							}, {
								name : 'INCICTUOMDRID',
								mapping : 'INCICTUOMDRID',
								type : 'string'
								
							
							}
						])
				
	});
			

	
	// 分页工具条
	var DrugInfoToolbar = new Ext.PagingToolbar({
				pageSize : pagesize,
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
         		 "change":function (t,p)
         		{ 
             		pagesize=this.pageSize;
         		}
          		},
				store : DrugInfoStore,
				displayInfo : false,
				//displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
				emptyMsg : "没有记录"
	});
		
		// 搜索按钮
		var SearchBT = new Ext.Toolbar.Button({
			text : '搜索',
			tooltip : '点击搜索',
			iconCls : 'icon-search',
			width : 60,
			height : 15,
			handler : function() {
				search();
			}
		});

		function search(){
			//DrugInfoGrid.getStore().removeAll();
			//DrugInfoGrid.getView().refresh();
			//clearData();
			var arcimDesc = Ext.getCmp("ARCIM_Desc").getValue();
			var arcimCode = Ext.getCmp("ARCIM_Code").getValue();
			var aliastext = Ext.getCmp("ALIAS_Text").getValue();
			var infochargetype = Ext.getCmp("INFO_ChargeType").getValue();
			var chargelinkflag = (Ext.getCmp("ARCIM_ChargeLinkFlag").getValue()==true?'Y':'N');
			var billgrp = Ext.getCmp("billGrp").getValue();
			var billsub = Ext.getCmp("ARCIM_BillSub_DR").getValue();
			var itemcat = Ext.getCmp("ARCIM_ItemCat_DR").getValue();
			//var phcdmast = Ext.getCmp("ARCIM_PHCDF_DR").getValue();
			var taridesc1 = Ext.getCmp("TARIDesc1").getValue();
			
			var  update = Ext.getCmp("UpdateDate").getValue();
			
			var servicegroup = Ext.getCmp("ARCIM_ServiceGroup_DR").getValue();
			// 分页加载数据
			DrugInfoStore.setBaseParam('ID',"");
			DrugInfoStore.setBaseParam('arcimcode',arcimCode);
			DrugInfoStore.setBaseParam('arcimdesc',arcimDesc);
			if (chargelinkflag=="Y")  ///关联了收费项后，可以根据收费项名称查找医嘱项
			{
				DrugInfoStore.setBaseParam('taridesc1',taridesc1);
			}
			else
			{
				DrugInfoStore.setBaseParam('taridesc1',"");
			}
			DrugInfoStore.setBaseParam('arcimalias',aliastext);
			DrugInfoStore.setBaseParam('arcimbillgrp',billgrp);
			DrugInfoStore.setBaseParam('arcimbillsub',billsub);
			DrugInfoStore.setBaseParam('arcimitemcat',itemcat);
			DrugInfoStore.setBaseParam('arcimservicegroup',servicegroup);
			DrugInfoStore.setBaseParam('chargelinkflag',chargelinkflag);
			DrugInfoStore.setBaseParam('chargetype',infochargetype);
			DrugInfoStore.setBaseParam('update',update);
			var enableflag=(Ext.getCmp("ARCIM_EnableFlag").getValue()==true?'Y':'N')
			DrugInfoStore.setBaseParam('enableflag',enableflag);
			DrugInfoStore.load({params:{start:0, limit:pagesize}});
			
		}
		
		// 清空按钮
		var ClearBT = new Ext.Toolbar.Button({
			text : '重置',
			tooltip : '点击重置',
			width : 60,
			height : 15,
			iconCls : 'icon-refresh',
			handler : function() {
				
				//clearData();
				Ext.getCmp("ARCIM_Desc").setValue("");
				Ext.getCmp("ARCIM_Code").setValue("");
				Ext.getCmp("ALIAS_Text").setValue("");
				var rowid =tkMakeServerCall("web.DHCBL.CT.INCItmNew","GetChgTypeID","加成收费");
	   			Ext.getCmp('INFO_ChargeType').setValue(rowid);//默认为加成收费
				Ext.getCmp("ARCIM_ChargeLinkFlag").setValue(false);
				Ext.getCmp("ARCIM_EnableFlag").setValue(true);
				Ext.getCmp("TARIDesc1").setValue("");
				Ext.getCmp('TARIDesc1').disable();
				Ext.getCmp("billGrp").setValue("");
				Ext.getCmp("UpdateDate").setValue("A")
				Ext.getCmp("ARCIM_BillSub_DR").setValue("");
				Ext.getCmp("ARCIM_ItemCat_DR").setValue("");
				Ext.getCmp("ARCIM_ServiceGroup_DR").setValue("");
				Ext.getCmp("TARIPanel").getForm().reset();
				DrugInfoGrid.getStore().removeAll();
				DrugInfoGrid.getView().refresh();
				PriceGrid.getStore().removeAll();
				PriceGrid.getView().refresh();
				AliasGrid.getStore().removeAll();
				AliasGrid.getView().refresh();
				Ext.getCmp('AliasGrid').disable();
				
				
			}
		});
		
		
	
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
	});
		var DrugInfoGrid = new Ext.grid.GridPanel({
			id:'DrugInfoGrid',
			region:'center',
			title:'医嘱项',
			//height:420,
			//width : 495,
			autoScroll:true,
			store:DrugInfoStore,
			columnLines : true, //在列分隔处显示分隔符
			trackMouseOver : true,  //True表示为鼠标移动时高亮显示（默认为true)
			stripeRows : true,  //True表示为显示行的分隔符（默认为true）。
			//loadMask : true, 
			bbar:DrugInfoToolbar,
			columns :[sm, {
							header : '医嘱项ID',
							width : 70,
							hidden : true,
							sortable : true,
							dataIndex : 'ARCIMRowId'
						}, {
							header : '库存项ID',
							width : 70,
							hidden : true,
							sortable : true,
							dataIndex : 'INCIRowId'
						}, {
							header : '收费项ID',
							width : 70,
							hidden : true,
							sortable : true,
							dataIndex : 'TARIRowId'
						}, {
							header : '医嘱项与收费项关联表ID',
							width : 70,
							hidden : true,
							sortable : true,
							dataIndex : 'OLTRowId'
						}, {
							header : '库存项附加表ID',
							width : 70,
							hidden : true,
							sortable : true,
							dataIndex : 'INFORowId'
						}, {
							header : '代码',
							width : 80,
							sortable : true,
							dataIndex : 'ARCIMCode'
						}, {
							header : '描述',
							width : 100,
							sortable : true,
							dataIndex : 'ARCIMDesc'
						}, {
							header : '库存项代码',
							width : 80,
							sortable : true,
							dataIndex : 'INCICode'
						}, {
							header : '库存项描述',
							width : 100,
							sortable : true,
							dataIndex : 'INCIDesc'
						}, {
							header : '基本单位',
							width : 70,
							sortable : true,
							dataIndex : 'INCICTUOMDR'
						}, {
							header : '入库单位',
							width : 70,
							sortable : true,
							dataIndex : 'INCICTUOMPurchDR'
						}, {
							header : '进货价',
							width : 70,
							hidden : true,
							sortable : true,
							dataIndex : 'ResultRPFactor'
						}, {
							header : '招标进价',
							width : 70,
							sortable : true,
							dataIndex : 'INFOPbRp'
						}, {
							header : '招标供应商',
							width : 100,
							sortable : true,
							dataIndex : 'INFOPbVendorDR'
						}, {
							header : '供应商ID',
							width : 70,
							hidden : true,
							sortable : true,
							dataIndex : 'INFOPbVendorDRID'
						}, {
							header : '招标生产厂商',
							width : 100,
							sortable : true,
							dataIndex : 'INFOPbManfDR'
						}, {
							header : '厂商ID',
							width : 70,
							hidden : true,
							sortable : true,
							dataIndex : 'INFOPbManfDRID'
						}, {
							header : '是否有效',
							width : 70,
							hidden : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							sortable : true,
							dataIndex : 'TARIActiveFlag'
						}, {
							header : '特殊标志',
							width : 70,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							hidden : true,
							sortable : true,
							dataIndex : 'TARISpecialFlag'
						}, {
							header : '基本单位ID',
							width : 70,
							hidden : true,
							sortable : true,
							dataIndex : 'INCICTUOMDRID'
							
						}],
				loadMask : {
					//msg : '数据加载中,请稍候...'
				},
				// config options for stateful behavior
				stateful : true,
				viewConfig : {
					//forceFit : true  ///注释后按照width显示宽度
				},
				stateId : 'DrugInfoGrid'
		});
		
	
		var TARIRowId = new Ext.BDP.FunLib.Component.TextField({
			//fieldLabel : '收费项rowid',
			id : 'TARIRowId',
			hideLabel : 'True',
			hidden : true,
			name : 'TARIRowId'
		});
		var ARCIMRowId = new Ext.BDP.FunLib.Component.TextField({
			//fieldLabel : '医嘱项rowid',
			id : 'ARCIMRowId',
			hideLabel : 'True',
			hidden : true,
			name : 'ARCIMRowId'
		});
		var OLTRowId = new Ext.BDP.FunLib.Component.TextField({
			//fieldLabel : '医嘱项与收费项关联表rowid',
			id : 'OLTRowId',
			hideLabel : 'True',
			hidden : true,
			name : 'OLTRowId'
		});
		var OLTARCIMDR = new Ext.BDP.FunLib.Component.TextField({
			id : 'OLTARCIMDR',
			hideLabel : 'True',
			hidden : true,
			name : 'OLTARCIMDR'
		});
		var OLTTariffDR = new Ext.BDP.FunLib.Component.TextField({
			id : 'OLTTariffDR',
			hideLabel : 'True',
			hidden : true,
			name : 'OLTTariffDR'
		});

		
		// 收费项代码
		var TARICode = new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '<font color=red>*</font>收费项代码',
			id : 'TARICode',
			allowBlank:false,
			readOnly : true,
			style:Ext.BDP.FunLib.ReadonlyStyle(true),
			 
			name : 'TARICode'
		});

		// 收费项名称
		var TARIDesc = new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '<font color=red>*</font>收费项名称',
			id : 'TARIDesc',
			allowBlank:false,
			 
			name : 'TARIDesc'
		});
	
		// 医保名称
		var TARIInsuName = new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '医保名称',
			id : 'TARIInsuName',
			 
			name : 'TARIInsuName',
			listeners : {
				'blur' : function(){
					Ext.getCmp("TariExpPrintName").setValue(Ext.getCmp("TARIInsuName").getValue());	
			}
		}	
		});
		
		// 打印名称
		var TariExpPrintName = new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '打印名称', ///同步取医保名称数据
			id : 'TariExpPrintName',
			 
			name : 'TariExpPrintName'
		});
		// 外部编码
		var TARIExternalCode = new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '外部编码',
			id : 'TARIExternalCode',
			 
			name : 'TARIExternalCode'
		});
		//单位
		 var TARIUOM = new Ext.BDP.Component.form.ComboBox({
		 	loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			emptyText:'',
			allowBlank:false,
			fieldLabel : '<font color=red>*</font>单位',
			id:'TARIUOM1',
			 
			readOnly : true,  ///不可修改  取库存项基本单位
			style:Ext.BDP.FunLib.ReadonlyStyle(true), ///不可修改
			listWidth : 250,
			hiddenName : 'TARIUOM',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : TARI_UOM_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'CTUOMDesc',mapping:'CTUOMDesc'},
						{name:'CTUOMRowId',mapping:'CTUOMRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'CTUOMDesc',
			valueField : 'CTUOMRowId'
	   });
	    // 有效标志
		var TARIActiveFlag = new Ext.BDP.FunLib.Component.Checkbox({
			fieldLabel : '有效标志',
			id : 'TARIActiveFlag',
			inputValue : 'Y', //不加会返回"on"
			name : 'TARIActiveFlag'
		});
		 //收费项目子类
		 var TARISubCate = new Ext.BDP.Component.form.ComboBox({
		 	loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			emptyText:'',
			allowBlank:false,
			 
			fieldLabel : '<font color=red>*</font>收费项目子类',
			id:'TARISubCate1',
			listWidth : 250,
			hiddenName : 'TARISubCate',  ///不加hiddenname传入后台的就是描述而不是id
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : SubCate_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'TARSCDesc',mapping:'TARSCDesc'},
						{name:'TARSCRowId',mapping:'TARSCRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'TARSCDesc',
			valueField : 'TARSCRowId'
	   });
	    
	 	//收费会计子类
		var TARIAcctCate = new Ext.BDP.Component.form.ComboBox({
			loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			allowBlank:false,
			emptyText:'',
			fieldLabel : '<font color=red>*</font>收费会计子类',
			id:'TARIAcctCate1',
			 
			listWidth : 250,
			hiddenName : 'TARIAcctCate',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : AcctCate_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'TARACDesc',mapping:'TARACDesc'},
						{name:'TARACRowId',mapping:'TARACRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'TARACDesc',
			valueField : 'TARACRowId'
	   });
	   
	
	   
	    
		var TARIInpatCate= new Ext.BDP.Component.form.ComboBox({
			loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			allowBlank:false,
			emptyText:'',
			fieldLabel : '<font color=red>*</font>住院费用子类',
			id:'TARIInpatCate1',
			 
			listWidth : 250,
			hiddenName : 'TARIInpatCate',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : InpatCate_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'TARICDesc',mapping:'TARICDesc'},
						{name:'TARICRowId',mapping:'TARICRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'TARICDesc',
			valueField : 'TARICRowId'
	   });
		
		
		
		
		
	 
		// 门诊费用子类
		var TARIOutpatCate = new Ext.BDP.Component.form.ComboBox({
			loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			allowBlank:false,
			emptyText:'',
			 
			fieldLabel : '<font color=red>*</font>门诊费用子类',
			id:'TARIOutpatCate1',
			listWidth : 250,
			hiddenName : 'TARIOutpatCate',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : OutpatCate_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'TAROCDesc',mapping:'TAROCDesc'},
						{name:'TAROCRowId',mapping:'TAROCRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'TAROCDesc',
			valueField : 'TAROCRowId'
	   });
	 
	   
	   
	   
	   
	   
	   	
	  
		// 经济核算子类
		var TARIEMCCate = new Ext.BDP.Component.form.ComboBox({
			loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			allowBlank:false,
			emptyText:'',
			fieldLabel : '<font color=red>*</font>经济核算子类',
			 
			id:'TARIEMCCate1',
			listWidth : 250,
			hiddenName : 'TARIEMCCate',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : EMCCate_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'TARECDesc',mapping:'TARECDesc'},
						{name:'TARECRowId',mapping:'TARECRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'TARECDesc',
			valueField : 'TARECRowId'
	   });
	   

	   	
	 
		// 旧病案首页子类
		var TARIMRCate = new Ext.BDP.Component.form.ComboBox({
			loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			allowBlank:false,
			emptyText:'',
			fieldLabel : '<font color=red>*</font>旧病案首页子类',
			 
			id:'TARIMRCate1',
			listWidth : 250,
			hiddenName : 'TARIMRCate',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : MRCate_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'TARMCDesc',mapping:'TARMCDesc'},
						{name:'TARMCRowId',mapping:'TARMCRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'TARMCDesc',
			valueField : 'TARMCRowId'
	   });
	   
	   
	   
	   	
	  
		// 新病案首页子类
		var TARIMCNew = new Ext.BDP.Component.form.ComboBox({
			loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			allowBlank:false,
			emptyText:'',
			fieldLabel : '<font color=red>*</font>新病案首页子类',
			 
			id:'TARIMCNew1',
			listWidth : 250,
			hiddenName : 'TARIMCNew',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : MCNew_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'NTARMCDesc',mapping:'NTARMCDesc'},
						{name:'NTARMCRowId',mapping:'NTARMCRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'NTARMCDesc',
			valueField : 'NTARMCRowId'
	   });
	   
	   
	     // 特殊项目标识
		var TARISpecialFlag = new Ext.BDP.FunLib.Component.Checkbox({
			fieldLabel : '特殊项目标识',
			id : 'TARISpecialFlag',
			inputValue : 'Y',
			name : 'TARISpecialFlag',
			checked : false 
		});
	   // 收费依据
		var TARIChargeBasis = new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '收费依据',
			id : 'TARIChargeBasis',
			 
			name : 'TARIChargeBasis'
		});
		
		// 收费说明
		var TARIEngName = new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '收费说明',
			id : 'TARIEngName',
			 
			name : 'TARIEngName'
		});

		
		
		var TARIStartDate=new Ext.BDP.FunLib.Component.DateField({
							fieldLabel : '开始日期',
							name : 'TARIStartDate',
							format : 'Y/m/d',
							id:'TARIStartDate',
							 
							vtype:'cKDate',
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('date2'),
							
						})
						
		
		var TARIEndDate=new Ext.BDP.FunLib.Component.DateField({
							fieldLabel : '结束日期',
							name : 'TARIEndDate',
							format : 'Y/m/d',
							id:'TARIEndDate',
							width:220,
							vtype:'cKDate',
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('date2'),
							
						})
		
						
		///关联收费项表
		// 数量
		var OLTQty = new Ext.BDP.FunLib.Component.NumberField({
			fieldLabel : '<font color=red>*</font>数量',
			id : 'OLTQty',
			minValue : 0,
			allowNegative : false,//不允许输入负数
			allowDecimals : false,//不允许输入小数
			allowBlank:false,
			name : 'OLTQty'
		});
		var OLTStartDate=new Ext.BDP.FunLib.Component.DateField({
							fieldLabel : '<font color=red>*</font>开始日期',
							name : 'OLTStartDate',
							format : 'Y/m/d',
							allowBlank:false,
							id:'OLTStartDate',
							//vtype:'cKDate1',
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
							
						});
						
		var OLTEndDate=new Ext.BDP.FunLib.Component.DateField({
							fieldLabel : '结束日期',
							name : 'OLTEndDate',
							format : 'Y/m/d',
							hideLabel : 'True',
							hidden : true,
							id:'OLTEndDate',
							//vtype:'cKDate1',
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
							
							
						});
		//优先级
		 var OLTPriorityDR = new Ext.BDP.Component.form.ComboBox({
		 	loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			emptyText:'',
			fieldLabel : '优先级',
			id:'OLTPriorityDR1',
			listWidth : 250,
			hiddenName : 'OLTPriorityDR',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : OLTPriorityDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'OECPRDesc',mapping:'OECPRDesc'},
						{name:'OECPRRowId',mapping:'OECPRRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'OECPRDesc',
			valueField : 'OECPRRowId'
	   });
	  
	var OLTInstDR = new Ext.BDP.Component.form.ComboBox({
		 	loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			emptyText:'',
			fieldLabel : '用法',
			id:'OLTInstDR1',
			listWidth : 250,
			hiddenName : 'OLTInstDR',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : OLTInstDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'PHCINDesc1',mapping:'PHCINDesc1'},
						{name:'PHCINRowId',mapping:'PHCINRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'PHCINDesc1',
			valueField : 'PHCINRowId'
	   });
	   
	 
		var TPRowId = new Ext.BDP.FunLib.Component.TextField({
			//fieldLabel : '收费项价格rowid',
			id : 'TPRowId',
			hideLabel : 'True',
			hidden : true,
			name : 'TPRowId'
		});	
		
		
		var INFOPbRp = new Ext.BDP.FunLib.Component.NumberField({
			fieldLabel : '进价',
			readOnly:true, ///只读
			style:Ext.BDP.FunLib.ReadonlyStyle(true),
			id : 'INFOPbRp',
			name : 'INFOPbRp'
		});	
		var MRMargin = new Ext.BDP.FunLib.Component.NumberField({
			fieldLabel : '加成率',
			readOnly:true,  //只读
			style:Ext.BDP.FunLib.ReadonlyStyle(true),
			id : 'MRMargin',
			name : 'MRMargin'
		});	
		var TPPatInsType = new Ext.BDP.Component.form.ComboBox({
							fieldLabel : '<font color=red>*</font>患者费别',  //患者费别
		 					pageSize : Ext.BDP.FunLib.PageSize.Combo,
							emptyText:'',
							id:'TPPatInsType1',
							listWidth : 250,
							allowBlank:false,
							hiddenName : 'TPPatInsType',
							store : new Ext.data.Store({
										proxy : new Ext.data.HttpProxy({ url : PACAdmReason_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'READesc',mapping:'READesc'},
										{name:'REARowId',mapping:'REARowId'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'READesc',
							valueField : 'REARowId'
	   					});				
		var TPPrice = new Ext.BDP.FunLib.Component.NumberField({
			fieldLabel : '<font color=red>*</font>标准价格',
			id : 'TPPrice',
			minValue : 0,
			allowNegative : false,//不允许输入负数
			allowBlank:false,
			name : 'TPPrice'
		});				
	   	var TPStartDate=new Ext.BDP.FunLib.Component.DateField({
							fieldLabel : '<font color=red>*</font>开始日期',
							name : 'TPStartDate',
							format : 'Y/m/d',
							allowBlank:false,
							id:'TPStartDate',
							//vtype:'cKDate2',
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
							
						});
			var TPEndDate=new Ext.BDP.FunLib.Component.DateField({
							fieldLabel : '结束日期',
							name : 'TPEndDate',
							format : 'Y/m/d',
							hideLabel : 'True',
							hidden : true,
							id:'TPEndDate',
							//vtype:'cKDate2',
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
							
						});
		var TPAlterPrice1 = new Ext.BDP.FunLib.Component.NumberField({
			fieldLabel : '辅助价格1',
			id : 'TPAlterPrice1',
			minValue : 0,
			allowNegative : false,//不允许输入负数
			name : 'TPAlterPrice1'
		});	
		var TPAlterPrice2 = new Ext.BDP.FunLib.Component.NumberField({
			fieldLabel : '辅助价格2',
			id : 'TPAlterPrice2',
			minValue : 0,
			allowNegative : false,//不允许输入负数
			name : 'TPAlterPrice2'
		});	
	 
	   
	var AliasStore = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : AliasStoreUrl}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},[{
								name : 'TIARowId',
								mapping : 'TIARowId',
								type : 'string'
							}, {
								name : 'TIATARIDR',
								mapping : 'TIATARIDR',
								type : 'string'
							}, {
								name : 'TIAAlias',
								mapping : 'TIAAlias',
								type : 'string'
							}, {
								name : 'TIADesc',
								mapping : 'TIADesc',
								type : 'string'
							
							
							}
						])
				
	});	
	// 增加修改的Form
	var AliasWinForm = new Ext.FormPanel({
				id : 'alias-form-save',
				URL : Alias_SAVE_ACTION_URL,
				baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth : 75,
				split : true,
				frame : true,	
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'TIARowId',mapping:'TIARowId'},
                                         {name: 'TIADesc',mapping:'TIADesc'},
                                         {name: 'TIAAlias',mapping:'TIAAlias'}
                                        ]),
				defaults : {
					anchor : '85%',
					bosrder : false
				},
				//defaultType : 'textfield',
				items : [{
							id:'TIARowId',
							xtype:'textfield',
							fieldLabel : 'TIARowId',
							name : 'TIARowId',
							hideLabel : 'True',
							hidden : true
	   					}, {
							xtype : 'textfield',
							fieldLabel : '<font color=red>*</font>别名',
							id : 'TIAAlias',
							allowBlank:false,
							name : 'TIAAlias'
						}, {
							xtype : 'textfield',
							fieldLabel : '描述',
							name : 'TIADesc',
							id:'TIADesc'
						}]	
	});
		
	// 增加修改时弹出窗口
	var Aliaswin = new Ext.Window({
		title : '',
		width : 260,
		height: 160,
		layout : 'fit',
		closeAction : 'hide',
		plain : true, 
		modal : true,
		frame : true,
		autoScroll : true,
		//collapsible : true,
		hideCollapseTool : true,
		//titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		items : AliasWinForm, 
		buttons : [{
			text : '保存别名',
			iconCls : 'icon-save',
			id:'aliassave_btn',
			handler : function() { 
				if(AliasWinForm.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;
				}
				//-------添加----------
				if (Aliaswin.title == "新增收费项别名") {
					
					AliasWinForm.form.submit({
						url : Alias_SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST',
						params : {
								'TIATARIDR' : DrugInfoGrid.getSelectionModel().getSelected().get('TARIRowId')
							},
						success : function(form, action) {
							if (action.result.success == 'true') {
								Aliaswin.hide();
								 //var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												AliasGrid.getStore().baseParams={
													TARIRowId :  DrugInfoGrid.getSelectionModel().getSelected().get('TARIRowId')
												};
												AliasGrid.getStore().load();
												
												
											}
										});
								
								
							} else {
								var errorMsg = '';
								if (action.result.errorinfo) {
									errorMsg = '<br/>错误信息:'+ action.result.errorinfo
								}
								Ext.Msg.show({
											title : '提示',
											msg : '添加失败！' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
							}
						},
						failure : function(form, action) {
							Ext.Msg.alert('提示', '添加失败！');
						}
					})	
				} 
				else 
				{
					
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							AliasWinForm.form.submit({
							clientValidation : true, // 进行客户端验证
							waitMsg : '正在提交数据请稍后',
							waitTitle : '提示',
							url : Alias_SAVE_ACTION_URL,
							params : {
								'TIATARIDR' : DrugInfoGrid.getSelectionModel().getSelected().get('TARIRowId')
							},
							method : 'POST',
							success : function(form, action) {
								
								if (action.result.success == 'true') {
									Aliaswin.hide();
									
									Ext.Msg.show({
										title : '提示',
										msg : '修改成功!',
										icon : Ext.Msg.INFO,
										buttons : Ext.Msg.OK,
										fn : function(btn) {
											AliasGrid.getStore().baseParams={
													TARIRowId :  DrugInfoGrid.getSelectionModel().getSelected().get('TARIRowId')
												};
											AliasGrid.getStore().load();
										}
									});
								} 
								else {
									var errorMsg = '';
									if (action.result.errorinfo) {
										errorMsg = '<br/>错误信息:'+ action.result.errorinfo						
									}
									Ext.Msg.show({
										title : '提示',
										msg : '修改失败!' + errorMsg,
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
								}
							},
							failure : function(form, action) {
								Ext.Msg.alert('提示', '修改失败');
							}
						})
						}
					}, this);				
				}
				
				
			}
		}, {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				Aliaswin.hide();
			}
		}],
		listeners : {
			"show" : function() {
			},
			"hide" : function() {
				AliasWinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});
	var addTarItemAlias = new Ext.Button({
		id:'addTarItemAlias',
		text : '新增收费项别名',
		height:15,
		iconCls : 'icon-add',
		handler : function() {
			Aliaswin.setTitle('新增收费项别名');
			Aliaswin.setIconClass('icon-add');
			Aliaswin.show();
			AliasWinForm.getForm().reset();

		}
	});

	
	var delTarItemAlias = new Ext.Button({
		id:'delTarItemAlias',
		text : '删除收费项别名',
		height:15,
		iconCls : 'icon-delete',
		handler : function() {
			if (AliasGrid.selModel.hasSelection()) {
			Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
				if(btn=='yes'){
				
				var gsm = AliasGrid.getSelectionModel();//获取选择列
                var rows = gsm.getSelections();//根据选择列获取到所有的行
                
				Ext.Ajax.request({
					url:ALIAS_DELETE_ACTION_URL,
					method:'POST',
					params:{
					        'id':rows[0].get('TIARowId')
					},
					callback:function(options, success, response){
						Ext.MessageBox.hide();
						if(success){
							var jsonData = Ext.util.JSON.decode(response.responseText);
							if(jsonData.success == 'true'){
								Ext.Msg.show({
									title:'提示',
									msg:'数据删除成功!',
									icon:Ext.Msg.INFO,
									buttons:Ext.Msg.OK,
									fn:function(btn){
												AliasGrid.getStore().load();
									}
								});
							}
							else{
								var errorMsg ='';
								if(jsonData.info){
									errorMsg='<br />错误信息:'+jsonData.info
								}
								Ext.Msg.show({
									title:'提示',
									msg:'数据删除失败!'+errorMsg,
									minWidth:200,
									icon:Ext.Msg.ERROR,
									buttons:Ext.Msg.OK
								});
							}
						}
						else{
							Ext.Msg.show({
								title:'提示',
								msg:'异步通讯失败,请检查网络连接!',
								icon:Ext.Msg.ERROR,
								buttons:Ext.Msg.OK
							});
						}
						}
					},this);
				}
			},this);
				} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择要删除的别名！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
		
		}
	});
var AliasGrid = new Ext.grid.GridPanel({
			id:'AliasGrid',
			region:'center',
			height:160,
			tbar:[addTarItemAlias,delTarItemAlias],
			width : 650,
			autoScroll:true,
			store:AliasStore,
			trackMouseOver : true,  //True表示为鼠标移动时高亮显示（默认为true)
			stripeRows : true,  //True表示为显示行的分隔符（默认为true）。
			//loadMask : true, 
			columns :[sm, {
							header : 'TIARowId',
							width : 70,
							sortable : true,
							dataIndex : 'TIARowId',
							hidden : true
						}, {
							header : 'TIATARIDR',
							width : 70,
							sortable : true,
							dataIndex : 'TIATARIDR',
							hidden : true
						}, {
							header : '别名',
							width : 70,
							sortable : true,
							dataIndex : 'TIAAlias'
						}, {
							header : '描述',
							width : 70,
							sortable : true,
							dataIndex : 'TIADesc'
						
						}],
				loadMask : {
					//msg : '数据加载中,请稍候...'
				},
				// config options for stateful behavior
				stateful : true,
				viewConfig : {
					forceFit : true  ///注释后按照width显示宽度
				},
				stateId : 'AliasGrid'
		});
	AliasGrid.on("rowdblclick",function(grid,rowIndex,e){  
        if (AliasGrid.selModel.hasSelection()) {
					Aliaswin.setTitle('修改收费项别名');
					Aliaswin.setIconClass('icon-update');
					Aliaswin.show();
					var _arecord = AliasGrid.getSelectionModel().getSelected();
					Ext.getCmp("alias-form-save").getForm().loadRecord(_arecord);
				} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择需要修改的别名！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
    });  	
	var PriceStore = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : PriceStoreUrl}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},[{
								name : 'TPRowId',
								mapping : 'TPRowId',
								type : 'string'   
						}, {
								name : 'TPPatInsType',
								mapping : 'TPPatInsType',
								type : 'string'
							}, {
								name : 'TPPrice',
								mapping : 'TPPrice',
								type : 'string'
							}, {
								name : 'TPStartDate',
								mapping : 'TPStartDate',
								type : 'string'
							}, {
								name : 'TPEndDate',
								mapping : 'TPEndDate',
								type : 'string'
							
							}, {
								name : 'TPAlterPrice1',
								mapping : 'TPAlterPrice1',
								type : 'string'
							}, {
								name : 'TPAlterPrice2',
								mapping : 'TPAlterPrice2',
								type : 'string'
							}, {
								name : 'TPUpdateUser',
								mapping : 'TPUpdateUser',
								type : 'string'
							}, {
								name : 'TPUpdateDate',
								mapping : 'TPUpdateDate',
								type : 'string'
							}, {
								name : 'TPUpdateTime',
								mapping : 'TPUpdateTime',
								type : 'string'
							}, {
								name : 'TPHospitalDR',
								mapping : 'TPHospitalDR',
								type : 'string'
							
							}
						])
				
	});		
	
	/*
	 * 
	// 增加修改的Form
	var PriceWinForm = new Ext.FormPanel({
				id : 'price-form-save',
				URL : Price_SAVE_ACTION_URL,
				baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth : 75,
				split : true,
				frame : true,	
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'TPRowId',mapping:'TPRowId'},
                                         {name: 'TPPatInsType',mapping:'TPPatInsType'},
                                         {name: 'TPPrice',mapping:'TPPrice'},
                                         {name: 'TPStartDate',mapping:'TPStartDate'},
                                         {name: 'TPAlterPrice1',mapping:'TPAlterPrice1'},
                                         {name: 'TPAlterPrice2',mapping:'TPAlterPrice2'}
                                        ]),
				defaults : {
					anchor : '85%',
					bosrder : false
				},
				//defaultType : 'textfield',
				items : [{
							id:'TPRowId2',
							xtype:'textfield',
							fieldLabel : 'TPRowId',
							name : 'TPRowId',
							hideLabel : 'True',
							hidden : true
						
						}, {
							fieldLabel : '<font color=red>*</font>患者费别',  //患者费别
							xtype : 'bdpcombo',
		 					pageSize : Ext.BDP.FunLib.PageSize.Combo,
							emptyText:'',
							id:'TPPatInsType12',
							listWidth : 250,
							hiddenName : 'TPPatInsType12',
							store : new Ext.data.Store({
										proxy : new Ext.data.HttpProxy({ url : PACAdmReason_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'READesc',mapping:'READesc'},
										{name:'REARowId',mapping:'REARowId'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'READesc',
							valueField : 'REARowId'
	   					}, {
							xtype : 'numberfield',
							fieldLabel : '<font color=red>*</font>标准价格',
							id : 'TPPrice2',
							minValue : 0,
							allowNegative : false,//不允许输入负数
							allowBlank:false,
							name : 'TPPrice'
						}, {
							xtype : 'datefield',
							fieldLabel : '<font color=red>*</font>开始日期',
							name : 'TPStartDate',
							format : 'Y/m/d',
							id:'TPStartDate2',
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }},
							allowBlank:false
						}, {
							xtype : 'numberfield',
							fieldLabel : '辅助价格1',
							id : 'TPAlterPrice12',
							minValue : 0,
							allowNegative : false,//不允许输入负数
							name : 'TPAlterPrice1'
						}, {
							xtype : 'numberfield',
							fieldLabel : '辅助价格2',
							id : 'TPAlterPrice22',
							minValue : 0,
							allowNegative : false,//不允许输入负数
							//allowDecimals : false,//不允许输入小数
							name : 'TPAlterPrice2'
						}]	
	});
		
	// 增加修改时弹出窗口
	var Pricewin = new Ext.Window({
		title : '',
		width : 280,
		height: 280,
		layout : 'fit',
		closeAction : 'hide',
		plain : true, 
		modal : true,
		frame : true,
		autoScroll : true,
		//collapsible : true,
		hideCollapseTool : true,
		//titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		items : PriceWinForm, 
		buttons : [{
			text : '保存价格',
			iconCls : 'icon-save',
			id:'pricesave_btn',
			handler : function() { 
				if(PriceWinForm.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;
				}
				var TPStartDate=Ext.getCmp("TPStartDate").getValue(); //价格生效日期
				
				if((TPStartDate!="")&&(TPStartDate!=null)){
					if(TPStartDate<new Date().format('Y-m-d')){
						Msg.info("warning","价格生效日期不能早于当天!");
						return;
					}
				}	
				//-------添加----------
				if (Pricewin.title == "新增收费项价格") {
					//WinForm.form.isValid()
					PriceWinForm.form.submit({
						url : Price_SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST',
						params : {
								'TPTARIParRef' : DrugInfoGrid.getSelectionModel().getSelected().get('TARIRowId')
							},
						success : function(form, action) {
							if (action.result.success == 'true') {
								Pricewin.hide();
								var myrowid = action.result.id;
								 //var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												//PriceStore.setBaseParam('TARIRowId',TARIRowId);
												PriceStore.load();
											}
										});
								
								
							} else {
								var errorMsg = '';
								if (action.result.errorinfo) {
									errorMsg = '<br/>错误信息:'+ action.result.errorinfo
								}
								Ext.Msg.show({
											title : '提示',
											msg : '添加失败！' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
							}
						},
						failure : function(form, action) {
							Ext.Msg.alert('提示', '添加失败！');
						}
					})	
				} 
				
			}
		}, {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				Pricewin.hide();
			}
		}],
		listeners : {
			"show" : function() {
			},
			"hide" : function() {
				PriceWinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});
	
	
	
	var addTarItemPrice = new Ext.Button({
		id:'addTarItemPrice',
		text : '新增收费项价格',
		height:15,
		iconCls : 'icon-add',
		handler : function() {
		
					Pricewin.setTitle('新增收费项价格');
					Pricewin.setIconClass('icon-add');
					Pricewin.show();
					PriceWinForm.getForm().reset();
		}
	});
	*/
	var PriceGrid = new Ext.grid.GridPanel({
			id:'PriceGrid',
			region:'center',
			height:150,
			//tbar:[addTarItemPrice],
			width : 650,
			autoScroll:true,
			store:PriceStore,
			trackMouseOver : true,  //True表示为鼠标移动时高亮显示（默认为true)
			stripeRows : true,  //True表示为显示行的分隔符（默认为true）。
			//loadMask : true, 
			columns :[sm, {
							header : '收费项价格ID',
							width : 30,
							sortable : true,
							dataIndex : 'TPRowId',
							hidden : true
						}, {
							header : '收费类型',
							width : 80,
							sortable : true,
							dataIndex : 'TPPatInsType'
						}, {
							header : '标准价格',
							width : 80,
							sortable : true,
							dataIndex : 'TPPrice'
						}, {
							header : '开始日期',
							width : 90,
							//renderer : Ext.util.Format.dateRenderer('Y/m/d'),
							sortable : true,
							dataIndex : 'TPStartDate'
							
						}, {
							header : '结束日期',
							width : 90,
							//renderer : Ext.util.Format.dateRenderer('Y/m/d'),
							sortable : true,
							dataIndex : 'TPEndDate'
						}, {
							header : '辅助价格1',
							width : 80,
							sortable : true,
							dataIndex : 'TPAlterPrice1'
						}, {
							header : '辅助价格2',
							width : 80,
							sortable : true,
							dataIndex : 'TPAlterPrice2'
						}, {
							header : '更新人',
							width : 100,
							sortable : true,
							dataIndex : 'TPUpdateUser'
						}, {
							header : '更新日期',
							width : 90,
							sortable : true,
							//renderer : Ext.util.Format.dateRenderer('Y/m/d'),
							dataIndex : 'TPUpdateDate'
						}, {
							header : '更新时间',
							width : 90,
							sortable : true,
							dataIndex : 'TPUpdateTime'
						}, {
							header : '医院',
							width : 90,
							sortable : true,
							dataIndex : 'TPHospitalDR'
						
						}],
				loadMask : {
					//msg : '数据加载中,请稍候...'
				},
				// config options for stateful behavior
				stateful : true,
				viewConfig : {
					//forceFit : true  ///注释后按照width显示宽度
				},
				stateId : 'PriceGrid'
		});

		
	
    
    ////配置新增收费项时费用子类默认值
    //收费项目子类
	var DVTARISubCate = new Ext.BDP.Component.form.ComboBox({
		 	loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			emptyText:'',
			//allowBlank:false,
			width:220,
			fieldLabel : '收费项目子类',
			id:'DVTARISubCate1',
			listWidth : 250,
			hiddenName : 'DVTARISubCate',  ///不加hiddenname传入后台的就是描述而不是id
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : SubCate_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'TARSCDesc',mapping:'TARSCDesc'},
						{name:'TARSCRowId',mapping:'TARSCRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'TARSCDesc',
			valueField : 'TARSCRowId'
	   });
	    
	 	//收费会计子类
		var DVTARIAcctCate = new Ext.BDP.Component.form.ComboBox({
			loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			//allowBlank:false,
			emptyText:'',
			fieldLabel : '收费会计子类',
			id:'DVTARIAcctCate1',
			width:220,
			listWidth : 250,
			hiddenName : 'DVTARIAcctCate',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : AcctCate_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'TARACDesc',mapping:'TARACDesc'},
						{name:'TARACRowId',mapping:'TARACRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'TARACDesc',
			valueField : 'TARACRowId'
	   });
	   
	
	   
	    ///住院费用子类
		var DVTARIInpatCate= new Ext.BDP.Component.form.ComboBox({
			loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			//allowBlank:false,
			emptyText:'',
			fieldLabel : '住院费用子类',
			id:'DVTARIInpatCate1',
			width:220,
			listWidth : 250,
			hiddenName : 'DVTARIInpatCate',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : InpatCate_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'TARICDesc',mapping:'TARICDesc'},
						{name:'TARICRowId',mapping:'TARICRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'TARICDesc',
			valueField : 'TARICRowId'
	   });
		
		
		
		
		
	 
		// 门诊费用子类
		var DVTARIOutpatCate = new Ext.BDP.Component.form.ComboBox({
			loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			//allowBlank:false,
			emptyText:'',
			width:220,
			fieldLabel : '门诊费用子类',
			id:'DVTARIOutpatCate1',
			listWidth : 250,
			hiddenName : 'DVTARIOutpatCate',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : OutpatCate_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'TAROCDesc',mapping:'TAROCDesc'},
						{name:'TAROCRowId',mapping:'TAROCRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'TAROCDesc',
			valueField : 'TAROCRowId'
	   });
	 
	   
	   
	   
	   
	   
	   	
	  
		// 经济核算子类
		var DVTARIEMCCate = new Ext.BDP.Component.form.ComboBox({
			loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			//allowBlank:false,
			emptyText:'',
			fieldLabel : '经济核算子类',
			width:220,
			id:'DVTARIEMCCate1',
			listWidth : 250,
			hiddenName : 'DVTARIEMCCate',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : EMCCate_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'TARECDesc',mapping:'TARECDesc'},
						{name:'TARECRowId',mapping:'TARECRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'TARECDesc',
			valueField : 'TARECRowId'
	   });
	   

	   	
	 
		/*// 旧病案首页子类
		var DVTARIMRCate = new Ext.BDP.Component.form.ComboBox({
			loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			//allowBlank:false,
			emptyText:'',
			fieldLabel : '旧病案首页子类',
			width:220,
			id:'DVTARIMRCate1',
			listWidth : 250,
			hiddenName : 'DVTARIMRCate',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : MRCate_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'TARMCDesc',mapping:'TARMCDesc'},
						{name:'TARMCRowId',mapping:'TARMCRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'TARMCDesc',
			valueField : 'TARMCRowId'
	   });
	   */
	   
	   
	   	
	  
		// 新病案首页子类
		var DVTARIMCNew = new Ext.BDP.Component.form.ComboBox({
			loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			//allowBlank:false,
			emptyText:'',
			fieldLabel : '新病案首页子类',
			width:220,
			id:'DVTARIMCNew1',
			listWidth : 250,
			hiddenName : 'DVTARIMCNew',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : MCNew_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'NTARMCDesc',mapping:'NTARMCDesc'},
						{name:'NTARMCRowId',mapping:'NTARMCRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'NTARMCDesc',
			valueField : 'NTARMCRowId'
	   });
	   
	   
	   
	var DV_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.INCItmNew&pClassMethod=GetDefaultCate";
   	var DV_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.INCItmNew&pClassMethod=SaveDefaultCate";
       
	var DVWinForm = new Ext.FormPanel({
				id : 'dv-form-save',
				URL : DV_SAVE_ACTION_URL,
				//baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth : 110,
				split : true,
				frame : true,	
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'DVTARISubCate',mapping:'DVTARISubCate'},
                                         {name: 'DVTARIAcctCate',mapping:'DVTARIAcctCate'},
                                         {name: 'DVTARIInpatCate',mapping:'DVTARIInpatCate'},
                                         {name: 'DVTARIOutpatCate',mapping:'DVTARIOutpatCate'},
                                         {name: 'DVTARIEMCCate',mapping:'DVTARIEMCCate'},
                                         //{name: 'DVTARIMRCate',mapping:'DVTARIMRCate'},
                                         {name: 'DVTARIMCNew',mapping:'DVTARIMCNew'}
                                        ]),
				defaults : {
					anchor : '85%',
					bosrder : false
				},
				//defaultType : 'textfield',
				items : [DVTARISubCate, DVTARIAcctCate,DVTARIInpatCate,DVTARIOutpatCate,DVTARIEMCCate,DVTARIMCNew]	  //DVTARIMRCate,
	});
		
	// 增加修改时弹出窗口
	var DVwin = new Ext.Window({
		title : '',
		width : 400,
		height: 320,
		layout : 'fit',
		closeAction : 'hide',
		plain : true, 
		modal : true,
		frame : true,
		autoScroll : true,
		//collapsible : true,
		hideCollapseTool : true,
		//titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		items : DVWinForm, 
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'dvsave_btn',
			handler : function() { 
				
				
				//-------保存----------
				
					DVWinForm.form.submit({
						url : DV_SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								DVwin.hide();
								
								Ext.Msg.show({
											title : '提示',
											msg : '保存成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK
										});
								
								
							} else {
								var errorMsg = '';
								
								Ext.Msg.show({
											title : '提示',
											msg : '保存失败！' ,
											minWidth : 200,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
							}
						},
						failure : function(form, action) {
							Ext.Msg.alert('提示', '保存失败！');
						}
					})	
	
			}
		}, {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				DVwin.hide();
			}
		}],
		listeners : {
			"show" : function() {
			},
			"hide" : function() {
				//DVWinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});
	
 var configDefaultvalue = new Ext.Button({
	text : '配置',
	id:'configDefaultvalue',
	tooltip : '配置新增收费项时费用子类的默认值',
	height:15,
	iconCls : 'icon-config',
	handler : function() {
		
		///存在临时Global ^BDPLOGISTICS("CONFIG")里
		//DVWinForm.getForm().reset();
		Ext.getCmp("dv-form-save").getForm().load( {
                	url : DV_OPEN_ACTION_URL,
                	//waitMsg : '正在载入数据...',
               	 success : function(form,action) {
                	//Ext.Msg.alert('编辑','载入成功！');
                	},
                	failure : function(form,action) {
                		Ext.Msg.alert('编辑','载入失败！');
               	 }
           	 	});
           	 	
		DVwin.setTitle('配置新增收费项时费用子类的默认值');
		DVwin.setIconClass('icon-config');
		DVwin.show();
		
	}
});



var saveButton = new Ext.Button({
	text : '保存',
	iconCls : 'icon-save',
	id:'save-btn',
	tooltip : '医嘱项有关联收费项时为修改关联的收费项，无关联收费项时为新增收费项并关联',
	height:15,
	handler : function() {
		/*alert(document.body.clientWidth) //获取页面总宽度
alert("sw"+talPanel.x)
alert("sh"+HisListTab.getWidth())

return;*/
		///判断 ID
		// 保存收费项信息
		if (DrugInfoGrid.selModel.hasSelection()) {
			var _record = DrugInfoGrid.getSelectionModel().getSelected();
			
			var ARCIMRowId=_record.get('ARCIMRowId');
        	var TARIRowId=_record.get('TARIRowId');
        	
			if(DHCTarItemPanel.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br/>请检查您的数据格式是否有误！');
					 return;
			}
			//-------添加---------
			if (TARIRowId== "") {
				Ext.MessageBox.confirm('提示', '确定要新增并与医嘱项关联该收费项吗?', function(btn) {
				if (btn == 'yes') {
					Ext.getCmp("ARCIMRowId").setValue(ARCIMRowId);
					Ext.getCmp("OLTARCIMDR").setValue(ARCIMRowId);
					//Ext.getCmp("OLTRowId").setValue("");
					DHCTarItemPanel.form.submit({
						url : SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												Ext.getCmp("TARIRowId").setValue(action.result.TARIRowId);
												Ext.getCmp("OLTTariffDR").setValue(action.result.TARIRowId);
												Ext.getCmp("OLTRowId").setValue(action.result.OLTRowId);
												var myrowid = "ID="+ARCIMRowId;
												Ext.BDP.FunLib.ReturnDataForUpdate("DrugInfoGrid",DrugInfoStoreUrl,myrowid);
												Ext.getCmp('AliasGrid').enable();
												Ext.getCmp('PriceGrid').enable();
												
												AliasGrid.getStore().baseParams={
													TARIRowId :  action.result.TARIRowId
												};
												AliasGrid.getStore().load();
												
												PriceGrid.getStore().baseParams={
													TARIRowId :  action.result.TARIRowId
												};
												PriceGrid.getStore().load();
												
											}
										});
								
								
							} else {
								var errorMsg = '';
								if (action.result.errorinfo) {
									errorMsg = '<br/>错误信息:'+ action.result.errorinfo
								}
								Ext.Msg.show({
											title : '提示',
											msg : '添加失败！' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
							}
						},
						failure : function(form, action) {
							Ext.Msg.alert('提示', '添加失败！');
						}
					})	
					
					}
					}, this);
					
				} 
				//---------修改-------
				else {
					Ext.MessageBox.confirm('提示', '确定要修改该条收费项吗?', function(btn) {
						if (btn == 'yes') {
							DHCTarItemPanel.form.submit({
								url : SAVE_ACTION_URL,
								clientValidation : true,
								waitMsg : '正在提交数据请稍候...',
								waitTitle : '提示',
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {		
										var myrowid = action.result.id;
										
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												
												var myrowid = "ID="+ARCIMRowId;
												Ext.BDP.FunLib.ReturnDataForUpdate("DrugInfoGrid",DrugInfoStoreUrl,myrowid);
												
												//收费项描述修改后 自动保存别名，并加载 2016-8-9chenying
												AliasGrid.getStore().baseParams={
													TARIRowId : action.result.TARIRowId
												};
												AliasGrid.getStore().load();
												
												PriceGrid.getStore().baseParams={
													TARIRowId : action.result.TARIRowId
												};
												PriceGrid.getStore().load();
											}
										});
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:'+ action.result.errorinfo
										}
										Ext.Msg.show({
													title : '提示',
													msg : '修改失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								},
								failure : function(form, action) {
									Ext.Msg.alert('提示', '修改失败！');
								}
							})
							
							
						}
					}, this);
					
					
					
				}	
	
		} else {
			Ext.Msg.show({
					title : '提示',
					msg : '请先选中一条医嘱项！',
					icon : Ext.Msg.WARNING,
					buttons : Ext.Msg.OK
			});
		}
		
	}
	});

	
		// 收费项目Panel
var DHCTarItemPanel = new Ext.form.FormPanel({
	title:'收费项目',
	id:'TARIPanel',
	labelWidth : 110,
	labelAlign : 'right',
	autoScroll:true,
	frame : true,
	reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'TARIRowId',mapping:'TARIRowId'},
                                         {name: 'TARICode',mapping:'TARICode'},
                                         {name: 'TARIDesc',mapping:'TARIDesc'},
                                         {name: 'TARIInsuName',mapping:'TARIInsuName'},
                                         {name: 'TariExpPrintName',mapping:'TariExpPrintName'},
                                         {name: 'TARIExternalCode',mapping:'TARIExternalCode'},
                                        
                                         {name: 'TARIUOM',mapping:'TARIUOM'},
                                         {name: 'TARISubCate',mapping:'TARISubCate'},
                                         {name: 'TARIInpatCate',mapping:'TARIInpatCate'},
                                         {name: 'TARIEMCCate',mapping:'TARIEMCCate'},
                                         {name: 'TARIMCNew',mapping:'TARIMCNew'},
                                         {name: 'TARIChargeBasis',mapping:'TARIChargeBasis'},
                                         {name: 'TARIStartDate',mapping:'TARIStartDate'},
                                         {name: 'TARIActiveFlag',mapping:'TARIActiveFlag'},
                                         {name: 'TARIAcctCate',mapping:'TARIAcctCate'},
                                         {name: 'TARIOutpatCate',mapping:'TARIOutpatCate'},
                                         {name: 'TARIMRCate',mapping:'TARIMRCate'},
                                         {name: 'TARISpecialFlag',mapping:'TARISpecialFlag'},
                                         {name: 'TARIEngName',mapping:'TARIEngName'},
                                         {name: 'ARCIMRowId',mapping:'ARCIMRowId'},
                                         {name: 'OLTQty',mapping:'OLTQty'},
                                         {name: 'OLTStartDate',mapping:'OLTStartDate'},
                                         {name: 'OLTEndDate',mapping:'OLTEndDate'},
                                         {name: 'OLTARCIMDR',mapping:'OLTARCIMDR'},
                                         {name: 'OLTInstDR',mapping:'OLTInstDR'},
                                         {name: 'OLTPriorityDR',mapping:'OLTPriorityDR'},
                                         {name: 'OLTRowId',mapping:'OLTRowId'},
                                         {name: 'OLTTariffDR',mapping:'OLTTariffDR'},
                                         {name: 'TARIEndDate',mapping:'TARIEndDate'},
                                         {name: 'TPRowId',mapping:'TPRowId'},
                                         {name: 'TPPatInsType',mapping:'TPPatInsType'},
                                         {name: 'TPPrice',mapping:'TPPrice'},
                                         {name: 'MRMargin',mapping:'MRMargin'}, //价格加成率  1.1  1.05
                                         {name: 'INFOPbRp',mapping:'INFOPbRp'},//进价
                                         {name: 'TPStartDate',mapping:'TPStartDate'},
                                         {name: 'TPAlterPrice1',mapping:'TPAlterPrice1'},
                                         {name: 'TPAlterPrice2',mapping:'TPAlterPrice2'}
                                        ]),
				
	
	items : [{
			layout : 'column',
			xtype:'fieldset',
			anchor : '96%',
			style:'padding:5px 0px 0px 0px',
			defaults:{border:false},
			items : [{
						columnWidth : 0.5,
						xtype:'fieldset',
						defaults: {width:155},
						items : [TARIRowId,OLTRowId,TARICode,TARIInsuName,TARIUOM,TARISubCate,TARIInpatCate,TARIEMCCate,TARIChargeBasis,TARIStartDate,TARIEndDate]  //,TARIPrice,TARIAlterPrice2]
					},{
						columnWidth : 0.5,
						xtype:'fieldset',
						defaults: {width:155},
						items : [ARCIMRowId,OLTARCIMDR,TARIDesc,TARIExternalCode,TARIActiveFlag,TARIAcctCate,TARIOutpatCate,TARIMCNew,TARISpecialFlag,TARIEngName,TariExpPrintName] //,TARIAlterPrice1,TARIMRCate
					}]

		},{
			xtype : 'fieldset',
			title : '关联收费项',
			layout : 'column',
			style:'padding:5px 0px 0px 0px',
			anchor : '96%',
			defaults:{border:false},
			items : [
			{
					columnWidth : .5,
					xtype:'fieldset',
					//style:'margin-left:-20px',
					defaults: {width:155},
					items : [OLTQty,OLTStartDate,OLTEndDate]
				}, {
					columnWidth : .5,
					xtype:'fieldset',
					defaults: {width:155},
					items : [OLTInstDR,OLTPriorityDR,OLTTariffDR]
				}]
		},{
			xtype : 'fieldset',
			title : '收费项价格(当医嘱项和收费项已经关联时，不保存此处数据)',
			id:'tariprice',
			layout : 'column',
			style:'padding:5px 0px 0px 0px',
			anchor : '96%',
			defaults:{border:false},
			items : [
			{
					columnWidth : .5,
					xtype:'fieldset',
					defaults: {width:155},
					items : [TPPatInsType,TPStartDate,TPAlterPrice1,INFOPbRp,TPEndDate]
				}, {
					
					columnWidth : .5,
					xtype:'fieldset',		
					defaults: {width:155},
					items : [TPPrice,MRMargin,TPAlterPrice2,TPRowId]
				
				}]
		},{
			xtype : 'fieldset',
			title : '收费项价格',
			layout : 'column',
			anchor : '96%',
			style:'padding:5px 0px 0px 0px',
			defaults:{border:false},
			items : [PriceGrid]
		},{
			xtype : 'fieldset',
			title : '收费项别名',
			layout : 'column',
			anchor : '96%',
			style:'padding:5px 0px 0px 0px',
			defaults:{border:false},
			items : [AliasGrid]
		}
		]/*,
	listeners:{
		activate:function(){
		//Ext.getCmp('BillNotActive').fireEvent('check',Ext.getCmp('BillNotActive'),Ext.getCmp('BillNotActive').getValue());
		}
	}*/
});

	///点击grid某一单元格时
     DrugInfoGrid.on("cellclick", function(grid, rowIndex, columnIndex,  e ) {
     	  var _record1 = grid.getSelectionModel().getSelected();
        if (!_record1) {
            
        } else {
			//alert(rowIndex) 行 =第N行-1
			///alert(columnIndex) // 隐藏的行也算在columnIndex内
        	var record = grid.getStore().getAt(rowIndex); 
    		var fieldName = grid.getColumnModel().getDataIndex(columnIndex);  //列名  dataIndex
    		var ID = record.get(fieldName);   //单击的单元格的值
			//Ext.getCmp('grid').getSelectionModel().selection.record.set(列名,'修改后的值'); 
			if ((fieldName=='INFOPbVendorDRID')||(fieldName=='INFOPbVendorDR')) ///供应商
			{
				var INFOPbVendorDRID = _record1.get("INFOPbVendorDRID");
			}
			else if ((fieldName=='INFOPbManfDRID')||(fieldName=='INFOPbManfDR'))  ///生产厂商
			{
				var INFOPbManfDRID = _record1.get("INFOPbManfDRID");
			}
			else if ((fieldName=='INCICode')||(fieldName=='INCIDesc'))  ///生产厂商
			{
				var INCIRowId = _record1.get("INCIRowId");
			}
       	 }
     	
     })
     
      
     var ADD_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.INCItmNew&pClassMethod=AddOpenData";
   	
     DrugInfoGrid.on("rowclick", function(grid, rowIndex, e) {
        var _record = grid.getSelectionModel().getSelected();
       /// alert((_record.get('TARIActiveFlag')))
        if (!_record) {
        	
            return;
        } else {
        	var TARIRowId=_record.get('TARIRowId');
        	var ARCIMRowId=_record.get('ARCIMRowId');
        	
        	if (TARIRowId!="")  //获取已有关联的收费项
        	{
        		//Ext.getCmp("TARIPanel").getForm().reset();
            	Ext.getCmp("TARIPanel").getForm().load( {
                	url : OPEN_ACTION_URL + '&ARCIMRowId='+ _record.get('ARCIMRowId'),
                	//waitMsg : '正在载入数据...',
               	 success : function(form,action) {
                	//Ext.Msg.alert('编辑','载入成功！');
                	},
                	failure : function(form,action) {
                		Ext.Msg.alert('编辑','载入失败！');
               	 }
           	 	});
           		Ext.getCmp("TARIActiveFlag").setValue((_record.get('TARIActiveFlag'))=='Y'?true:false);
        		Ext.getCmp("TARISpecialFlag").setValue((_record.get('TARISpecialFlag'))=='Y'?true:false);
        		
         		
        	/*
				AliasStore.setBaseParam('TARIRowId',TARIRowId);
				AliasStore.load();
				PriceStore.setBaseParam('TARIRowId',TARIRowId);
				PriceStore.load();*/
				
				AliasGrid.getStore().baseParams={
						TARIRowId :  TARIRowId
				};
				AliasGrid.getStore().load();
				PriceGrid.getStore().baseParams={
						TARIRowId :  TARIRowId
				};
				PriceGrid.getStore().load();
												
				Ext.getCmp('AliasGrid').enable();
				Ext.getCmp('PriceGrid').enable();
				
				
        	}
        	else   ///清空所有数据 并获取添加时默认值
        	{
        		
        		//Ext.getCmp("TARIPanel").getForm().reset();
            	Ext.getCmp("TARIPanel").getForm().load( {
                	url : ADD_OPEN_ACTION_URL + '&ARCIMRowId='+ _record.get('ARCIMRowId')+ '&INCICTUOMDRID='+ _record.get('INCICTUOMDRID'),
                	//waitMsg : '正在载入数据...',
               	 	success : function(form,action) {
               	 		Ext.getCmp('TARICode').setValue(_record.get('ARCIMCode'));
                		Ext.getCmp('TARIDesc').setValue("【"+_record.get('ARCIMDesc')+"】");
                		Ext.getCmp("TARIActiveFlag").setValue(true);//默认有效2015-7-29
                	},
                	failure : function(form,action) {
                		Ext.Msg.alert('编辑','载入失败！');
               	 }
           	 	});
        		
        		//Ext.getCmp("TARIUOM1").setValue(_record.get('INCICTUOMDRID')); ///收费项单位取库存项基本单位(库存项基本单位不能为空)
        		//Ext.getCmp("TARIUOM1").setRawValue(_record.get('INCICTUOMDR')); ///收费项单位取库存项基本单位(库存项基本单位不能为空)
        		
        		PriceGrid.getStore().removeAll();
				PriceGrid.getView().refresh();
				AliasGrid.getStore().removeAll();
				AliasGrid.getView().refresh();
				Ext.getCmp('AliasGrid').disable();
        	}
			
           
        }
				        
    });	
    

// 页签
var talPanel = new Ext.TabPanel({
	activeTab : 0,
	deferredRender : true,
	region : 'east',
	width: 600, 
	minSize:600,
    maxSize: 900,
	tbar : [saveButton,'-','->',configDefaultvalue],
	items : [DHCTarItemPanel]
});		


	
//————————————————————————————————————————————————查询条件————————————————————————————————————————		
		var HisListTab = new Ext.form.FormPanel({
			width:423,
			height:250,
			labelWidth: 90,	
			title:'物流项物价信息维护',
			labelAlign : 'right',
			frame : true,
			region : 'north',	
			bodyStyle:'padding:5px',
			tbar : [SearchBT, '-', ClearBT],
			items:[{
				xtype:'fieldset',
				//title:'查询条件--<font color=red>默认查询未关联收费项目且是加成收费的医嘱项目</font>',
				layout: 'column',    // Specifies that the items will now be arranged in columns
				style:'padding:0px 0px 0px 5px',
				border:false, //去掉fieldset的边框 
				defaults: {border:false},
				items : [{ 				
					columnWidth: 0.45,
	            	xtype: 'fieldset',
	            	defaults: {anchor : '85%'},
	            	items: [ARCIM_Code,ARCIM_Desc,ALIAS_Text,INFO_ChargeType,ARCIM_ChargeLinkFlag,UpdateDate]
				}, {
					columnWidth: 0.45,
	            	xtype: 'fieldset',
	            	defaults: {anchor : '85%'},
					items : [billGrp,ARCIM_BillSub_DR,ARCIM_ItemCat_DR,ARCIM_ServiceGroup_DR,TARIDesc1,ARCIM_EnableFlag]  //,ARCIM_PHCDF_DR
				}]					
			}]			
		});
	
		var viewport = new Ext.Viewport({
            layout: 'border',
            defaults:{split:true},
            items: [
			 {
			 	id:'searchgrid',
                region: 'center',
                //title: '物流项物价信息维护',
                collapsible: false,
                width: 423, // give east and west regions a width
                minSize: 350,
                maxSize: 500,
                margins: '0 0 0 0',
                layout: 'border', 
                defaults:{split:true},
                items : [HisListTab,DrugInfoGrid]          // this TabPanel is wrapped by another Panel so the title will be applied
           	/*	listeners:{
					'resize':function(e){
						///alert("resize")
       	 				var twidth=parseInt(document.body.clientWidth)-423;
       	 				talPanel.setWidth(twidth)
       	 				
       	 				
					}
				}*/
            },
          
       		talPanel]
	
        });
        Ext.getCmp('AliasGrid').disable();
        Ext.getCmp('TARIDesc1').disable();
});

