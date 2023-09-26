// /名称: 月报明细查询
// /描述: 月报明细查询
// /编写者：zhangdongmei
// /编写日期: 2012.11.23
Ext.grid.RowNumberer.prototype.width = 100;
Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];	
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gIncid="";
	//alert(gIngrRowid);
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var Url=DictUrl	+ 'stkmonaction.csp?';
	var today=new Date();
	var growid=""
	var activeTabtmp=""
	//GetGroupDeptStore.load();

	var PhaLoc = new Ext.ux.LocComboBox({
		id : 'PhaLoc',
		name : 'PhaLoc',
		fieldLabel : '科室',
		listWidth : 'auto',
		groupId:gGroupId,
		listeners : {
			'select' : function(e) {
                  var SelLocId=Ext.getCmp('PhaLoc').getValue();//add wyx 根据选择的科室动态加载类组
                  StkGrpType.getStore().removeAll();
                  StkGrpType.getStore().setBaseParam("locId",SelLocId)
                  StkGrpType.getStore().setBaseParam("userId",gUserId)
                  StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
                  StkGrpType.getStore().load();
			}
	}
	});


	var StYear=new Ext.form.TextField({
		fieldLabel:'月份',
		id:'StYear',
		name:'StYear',
		//anchor:'90%',
		width:70,
		value:today.getFullYear()
	});
	var StMonth=new Ext.form.TextField({
		fieldLabel:'',
		id:'StMonth',
		name:'StMonth',
		//anchor:'90%',
		width:50,
		value:((today.getMonth()-10)<=0?1:(today.getMonth()-10))
	});
	
	var EdYear=new Ext.form.TextField({
		fieldLabel:'',
		id:'EdYear',
		name:'EdYear',
		//anchor:'90%',
		width:70,
		value:today.getFullYear()
	});
	
	var EdMonth=new Ext.form.TextField({
		fieldLabel:'',
		id:'EdMonth',
		name:'EdMonth',
		//anchor:'90%',
		width:50,
		value:(today.getMonth()+1)
	});
	
	// 药品类组
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,     //标识类组类型
		LocId:gLocId,
		UserId:gUserId,
		anchor:'90%',
		width : 200
	});
	StkGrpType.on('change',function(){
		Ext.getCmp("IncStkCat").setValue("");
	});
	
	var IncStkCat=new Ext.ux.ComboBox({
		id:'IncStkCat',
		name:'IncStkCat',
		store:StkCatStore,
		displayField:'Description',
		valueField:'RowId',
		emptyText:'库存分类',
		params:{StkGrpId:'StkGrpType'}
	});
	
	var IncDesc=new Ext.form.TextField({
		id:'IncDesc',
		name:'IncDesc',
		emptyText:'药品名称',
		width:220,
		listeners:{
			'specialkey':function(field,e){
				if(e.getKey()==Ext.EventObject.ENTER){
					var stkgrp = Ext.getCmp("StkGrpType").getValue();
					GetPhaOrderWindow(field.getValue(), stkgrp, App_StkTypeCode, "", "N", "0", "",getDrugList);
				}
			}
		}
	});
	var HelpBT = new Ext.Button({
	　　　　id:'HelpBtn',
			text : '帮助',
			width : 70,
			height : 30,
			renderTo: Ext.get("tipdiv"),
			iconCls : 'page_help'
			
		});
		// 另存按钮
	var SaveAsBT = new Ext.Toolbar.Button({
				text : '另存',
				tooltip : '另存为Excel',
				iconCls : 'page_export',
				width : 70,
				height : 30,
				handler : function() {
					var activeTab=tabPanel.getActiveTab();

					if(activeTab.id=="ReportDetailSp"){
						ExportAllToExcel(DetailGrid);
					}else if(activeTab.id=="ReportDetailRp"){
						ExportAllToExcel(DetailGridRp);
					}else if(activeTab.id=="ReportDetailLbSp"){
						ExportAllToExcel(DetailGridLB);
					}else if (activeTab.id=="ReportDetailLbRp"){
						ExportAllToExcel(DetailGridLBRp);
					}else if(activeTab.id=="ReportDetailSCGRp"){
						ExportAllToExcel(DetailGridSCGRp);
					}else if(activeTab.id=="ReportDetailSCG"){
						ExportAllToExcel(DetailGridSCG);
					}else if(activeTab.id=="ReportDetailCat"){
						ExportAllToExcel(DetailGridCat);
					}else if(activeTab.id=="ReportDetailCatRp"){
						ExportAllToExcel(DetailGridCatRp);
					}else{
						return;
					}					
				}
			});
	var Filter=new Ext.Toolbar.Button({
		id:'filter',
		text:'筛选',
		iconCls : 'page_find',
		anchor:'90%',
		handler:function(){
				MonRepFilter();
			}
	});
	
	/**
	 * 返回方法
	 */
	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		gIncId = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		;
		Ext.getCmp("IncDesc").setValue(inciDesc);
		//Ext.getCmp('InciDr').setValue(inciDr);			
	}
	
	//根据类组,库存分类,药品名称的变化,  过滤月报明细
	function MonRepFilter(){
		var record=MainGrid.getSelectionModel().getSelected();
		if(record){
			var rowid=record.get("smRowid");
			var stkgrpid=Ext.getCmp("StkGrpType").getValue();
			var stkcatid=Ext.getCmp("IncStkCat").getValue();
			var incdesc=Ext.getCmp("IncDesc").getValue();
			
			var activeTab=tabPanel.getActiveTab();
			growid=rowid
			activeTabtmp=activeTab ;
			if(activeTab.id=="ReportDetailSp"){
				DetailStore.load({params:{Parref:rowid,StkGrpId:stkgrpid,StkCatId:stkcatid,IncDesc:incdesc}});
			}else if(activeTab.id=="ReportDetailRp"){
				DetailStoreRp.load({params:{Parref:rowid,StkGrpId:stkgrpid,StkCatId:stkcatid,IncDesc:incdesc}});
			}else if(activeTab.id=="ReportDetailLbSp" || activeTab.id=="ReportDetailLbRp"){
				DetailStoreLB.load({params:{Parref:rowid,StkGrpId:stkgrpid,StkCatId:stkcatid,IncDesc:incdesc}});
			}else if(activeTab.id=="ReportDetailSCGRp"){
				DetailStoreSCG.load({params:{Parref:rowid,Type:0}});
			}else if(activeTab.id=="ReportDetailSCG"){
				DetailStoreSCG.load({params:{Parref:rowid,Type:1}});
			}else if(activeTab.id=="ReportDetailCat"){
				DetailStoreCat.load({params:{Parref:rowid,Type:1}});
			}else if(activeTab.id=="ReportDetailCatRp"){
				DetailStoreCat.load({params:{Parref:rowid,Type:0}});
			}else{
				DetailStore.load({params:{Parref:rowid,StkGrpId:stkgrpid,StkCatId:stkcatid,IncDesc:incdesc}});
			}
		}
	}
		// 查询按钮
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : '查询',
				tooltip : '点击查询',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {  
					Query();
				}
			});
		// 打印月报明细
var printBT = new Ext.Toolbar.Button({
	id : "printBT",
	text : '打印',
	tooltip : '打印月报明细',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		PrintStkMon(growid,activeTabtmp);
	}
});			
			
	
//查询月报
function Query(){
	var stYear=Ext.getCmp('StYear').getValue();
	var stMonth=Ext.getCmp('StMonth').getValue();
	var stDate=stYear+'-'+stMonth+'-'+'01';
	var edYear=Ext.getCmp('EdYear').getValue();
	var edMonth=Ext.getCmp('EdMonth').getValue();
	var edDate=edYear+'-'+edMonth+'-'+'01';
	var Loc=Ext.getCmp('PhaLoc').getValue();
	if(Loc==""){
		Msg.info("warning","请选择需要查询月报的科室!");
		return;
	}
	DetailGrid.store.removeAll();
	DetailGridRp.store.removeAll();
	DetailGridLB.store.removeAll();
	DetailGridLBRp.store.removeAll();
	DetailStoreSCG.removeAll();
	MainStore.removeAll();
	MainStore.load({params:{LocId:Loc,StartDate:stDate,EndDate:edDate}});
}

function renderRecQty(value, metaData, record, rowIndex, colIndex, store){
	var curUrl=window.location.href;
	var host=window.location.host;
	var pathName=window.location.pathname;
	var pos=pathName.indexOf("/csp");
	var commonPath=pathName.substring(0,pos);
	var Loc=Ext.getCmp('PhaLoc').getValue();
	var LocDesc=Ext.getCmp('PhaLoc').getRawValue();
	var selectRecord=MainGrid.getSelectionModel().getSelected();
	var startDate=selectRecord.get("frDate");
	var endDate=selectRecord.get("toDate");
	var incId=record.get("inci"),incDesc=record.get("inciDesc");
	var DateFlag=1;  //按审核日期统计
	var QueryParams=Loc+","+startDate+","+endDate+","+incId+","+incDesc+","+DateFlag+","+LocDesc;
	var newUrl="http://"+host+commonPath+"/csp/dhcst.ingdrecquery.csp?QueryParams={0}"
	//return String.format('<a href='+newUrl+' target="_blank">{1}',QueryParams,value);	
	
	var retINfo="<a onclick='websys_createWindow("+"\"dhcst.ingdrecquery.csp?QueryParams="+QueryParams+"\""+")'>"+"<font color='blue'>"+value+"</font>"+"</a>"
	return retINfo;

	
}
var nm = new Ext.grid.RowNumberer({width:30});
var DetailCm = new Ext.grid.ColumnModel([nm, {
			header : "rowid",
			dataIndex : 'Rowid',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '药品代码',
			dataIndex : 'inciCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '药品名称',
			dataIndex : 'inciDesc',
			width : 220,
			align : 'left',
			sortable : true
		}, {
			header : '规格',
			dataIndex : 'spec',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "单位",
			dataIndex : 'uomDesc',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "本期结存数量",
			dataIndex : 'qty',
			width : 90,
			align : 'right',
			sortable : true
		}, {
			header : "本期结存金额",
			dataIndex : 'amt',
			width : 100,
			align : 'right',
			sortable : true
		},{
			header:'上期结存数量',
			dataIndex:'lastQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'上期结存金额',
			dataIndex:'lastAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'入库数量',
			dataIndex:'recQty',
			width:100,
			align:'right',
			sortable:'true',
			renderer:renderRecQty
		},{
			header:'入库金额',
			dataIndex:'recAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'退货数量',
			dataIndex:'retQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'退货金额',
			dataIndex:'retAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'转出数量',
			dataIndex:'trOutQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'转出金额',
			dataIndex:'trOutAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'转入数量',
			dataIndex:'trInQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'转入金额',
			dataIndex:'trInAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'调整数量',
			dataIndex:'adjQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'调整金额',
			dataIndex:'adjAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'消耗数量',
			dataIndex:'csmQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'消耗金额',
			dataIndex:'csmAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'报损数量',
			dataIndex:'disposeQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'报损金额',
			dataIndex:'disposeAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'调价损益',
			dataIndex:'aspAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'赠药入库数量',
			dataIndex:'giftRecQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'赠药入库金额',
			dataIndex:'giftRecAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'赠药出库数量',
			dataIndex:'giftTrOutQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'赠药出库金额',
			dataIndex:'giftTrOutAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'调价换票入库数量',
			dataIndex:'chgRecQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'调价换票入库金额',
			dataIndex:'chgRecAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'调价换票退货数量',
			dataIndex:'chgRetQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'调价换票退货金额',
			dataIndex:'chgRetAmt',
			width:100,
			align:'right',
			sortable:'true'
		},/*{   //项目特殊定制，暂无用，先屏蔽  yangsj 2020-01-13
			header:'制剂入库数量',
			dataIndex:'mRecQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'制剂入库金额',
			dataIndex:'mRecAmt',
			width:100,
			align:'right',
			sortable:'true'
		},*/{
			header:'盘点调整数量',
			dataIndex:'stktkAdjQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'盘点调整金额',
			dataIndex:'stktkAdjAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'制剂消耗数量',
			dataIndex:'manuXQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'制剂消耗金额',
			dataIndex:'manuXAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'制剂生成数量',
			dataIndex:'manuMQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'制剂生成金额',
			dataIndex:'manuMAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'住院发药数量',
			dataIndex:'phaInDspQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'住院发药金额',
			dataIndex:'phaInDspAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'住院退药数量',
			dataIndex:'phaInRetQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'住院退药金额',
			dataIndex:'phaInRetAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'门诊发药数量',
			dataIndex:'phaOutDspQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'门诊发药金额',
			dataIndex:'phaOutDspAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'门诊退药数量',
			dataIndex:'phaOutRetQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'门诊退药金额',
			dataIndex:'phaOutRetAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'入库损益(调价)',
			dataIndex:'recAspAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'退货损益(调价)',
			dataIndex:'retAspAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'转入损益(调价)',
			dataIndex:'trInAspAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'门诊退药损益(调价)',
			dataIndex:'phaOutRetAspAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'住院退药损益(调价)',
			dataIndex:'phaRetAspAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'门诊发药损益(调价)',
			dataIndex:'phaOutDispAspAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'住院发药损益(调价)',
			dataIndex:'phaDispAspAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'数量差异',
			dataIndex:'diffQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'金额差异',
			dataIndex:'diffAmt',
			width:100,
			align:'right',
			sortable:'true'
		}]);
function DiffQty(val,record){
	var diffqty=Number(record.lastQty)+Number(record.recQty)+Number(record.retQty)+Number(record.trOutQty)+Number(record.trInQty)+Number(record.adjQty)+Number(record.csmQty)+Number(record.disposeQty)+
	Number(record.giftRecQty)+Number(record.giftTrOutQty)+Number(record.chgRecQty)+Number(record.chgRetQty)+Number(record.mRecQty)+Number(record.stktkAdjQty)+Number(record.manuXQty)+Number(record.manuMQty)+
	Number(record.phaInDspQty)+Number(record.phaInRetQty)+Number(record.phaOutDspQty)+Number(record.phaOutRetQty)-Number(record.qty);
	return Math.round(diffqty*100)/100;
}

function DiffAmt(val,record){
	var diffamt=Number(record.lastAmt)+Number(record.recAmt)+Number(record.retAmt)+Number(record.trOutAmt)+Number(record.trInAmt)+Number(record.adjAmt)+Number(record.csmAmt)+Number(record.disposeAmt)+
	Number(record.giftRecAmt)+Number(record.giftTrOutAmt)+Number(record.chgRecAmt)+Number(record.chgRetAmt)+Number(record.mRecAmt)+Number(record.stktkAdjAmt)+Number(record.manuXAmt)+
	Number(record.manuMAmt)+Number(record.trInAspAmt)+Number(record.aspAmt)+Number(record.retAspAmt)+Number(record.phaInDspAmt)+Number(record.phaInRetAmt)+Number(record.phaOutDspAmt)+Number(record.phaOutRetAmt)+
	Number(record.recAspAmt)+Number(record.phaOutRetAspAmt)+Number(record.phaRetAspAmt)+Number(record.phaOutDispAspAmt)+Number(record.phaDispAspAmt)-
    Number(record.amt);
	
	return Math.round(diffamt*100)/100;
}

var DetailStore = new Ext.data.JsonStore({
	autoDestroy: true,
    url: Url+"actiontype=QueryDetail",
    storeId: 'DetailStore',
    root: 'rows',
    totalProperty : "results",
    idProperty: 'Rowid',  
    fields: ['Rowid','inci','inciCode','inciDesc', 'spec', 'uomDesc','qty','amt','lastQty','lastAmt','recQty','recAmt','retQty',
    'retAmt','trOutQty','trOutAmt','trInQty','trInAmt','adjQty','adjAmt','csmQty','csmAmt','disposeQty','disposeAmt',
    'aspAmt','giftRecQty','giftRecAmt','giftTrOutQty','giftTrOutAmt','chgRecQty','chgRecAmt','chgRetQty','chgRetAmt',
    'retAspAmt','mRecQty','mRecAmt','stktkAdjQty','stktkAdjAmt','manuXQty','manuXAmt','manuMQty','manuMAmt','trInAspAmt',
	'phaInDspAmt','phaInDspQty','phaInRetQty','phaInRetAmt','phaOutDspQty','phaOutDspAmt','phaOutRetQty','phaOutRetAmt',
	'recAspAmt','phaOutRetAspAmt','phaRetAspAmt',,'phaOutDispAspAmt','phaDispAspAmt',
    {name:'diffQty',convert:DiffQty},{name:'diffAmt',convert:DiffAmt}]
});

var DetailGrid = new Ext.grid.GridPanel({
	id:'DetailGrid',
    store: DetailStore,
    cm:DetailCm,
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    autoScroll:true,
    trackMouseOver : true,
    loadMask:true,
    view: new Ext.ux.grid.BufferView({
		    // custom row height
		    rowHeight: 35,
		    borderHeight:1,
		    // render rows as they come into viewable area.
		    scrollDelay: false,
		    getRowClass:function(record,index,rowParams,store){
				var diffQty=record.get("diffQty");
				var diffAmt=record.get("diffAmt");
				if((diffQty!=0)||(diffAmt!=0)){
					return 'my_row_Yellow';
				}
			}
	    })
});

var DetailStoreRp=new Ext.data.JsonStore({
	autoDestroy: true,
    url: Url+"actiontype=QueryDetailRp",
    storeId: 'DetailStoreRp',
    root: 'rows',
    totalProperty : "results",
    idProperty: 'Rowid',  
    fields: ['Rowid','inci','inciCode','inciDesc', 'spec', 'uomDesc','qty','amt','lastQty','lastAmt','recQty','recAmt','retQty',
    'retAmt','trOutQty','trOutAmt','trInQty','trInAmt','adjQty','adjAmt','csmQty','csmAmt','disposeQty','disposeAmt',
    'aspAmt','giftRecQty','giftRecAmt','giftTrOutQty','giftTrOutAmt','chgRecQty','chgRecAmt','chgRetQty','chgRetAmt',
    'retAspAmt','mRecQty','mRecAmt','stktkAdjQty','stktkAdjAmt','manuXQty','manuXAmt','manuMQty','manuMAmt','trInAspAmt',
	'phaInDspAmt','phaInDspQty','phaInRetQty','phaInRetAmt','phaOutDspQty','phaOutDspAmt','phaOutRetQty','phaOutRetAmt',
	'recAspAmt','phaOutRetAspAmt','phaRetAspAmt',,'phaOutDispAspAmt','phaDispAspAmt',
    {name:'diffQty',convert:DiffQty},{name:'diffAmt',convert:DiffAmt}]
});

var DetailGridRp = new Ext.grid.GridPanel({
	id:'DetailGridRp',
    store: DetailStoreRp,
    cm:DetailCm,
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    autoScroll:true,
    trackMouseOver : true,
    loadMask:true,
    view: new Ext.ux.grid.BufferView({
		    // custom row height
		    rowHeight: 35,
		    borderHeight:1,
		    // render rows as they come into viewable area.
		    scrollDelay: false,
		    getRowClass:function(record,index,rowParams,store){
				var diffQty=record.get("diffQty");
				var diffAmt=record.get("diffAmt");
				if((diffQty!=0)||(diffAmt!=0)){
					return 'my_row_Yellow';
				}
			}
	    })
});

function DiffQtyLB(val,record){
	var diffqty=Number(record.lastqty)+Number(record.recqty)+Number(record.retqty)+Number(record.trfoqty)
	+Number(record.trfiqty)+Number(record.adjqty)+Number(record.conqty)+Number(record.dispqty)+Number(record.dspretqty)
	+Number(record.phaoutdispqty)+Number(record.phaoutretqty)+Number(record.stktkqty)+Number(record.dspqty)
	-Number(record.qty);
	return Math.round(diffqty*100)/100;
}

function DiffAmtLB(val,record){
	var diffamt=Number(record.lastamt)+Number(record.recamt)+Number(record.retamt)+Number(record.trfoamt)
	+Number(record.trfiamt)+Number(record.adjamt)+Number(record.conamt)+Number(record.dispamt)+Number(record.dspamt)
	+Number(record.aspamt)+Number(record.phaoutdispamt)+Number(record.phaoutretamt)+Number(record.dspretamt)
	+Number(record.recaspamt)+Number(record.retaspamt)+Number(record.phaoutretaspamt)+Number(record.pharetaspamt)+
	+Number(record.trfinaspamt)+Number(record.phaoutdispaspamt)+Number(record.phadispaspamt)
	-Number(record.amt);	
	return Math.round(diffamt*100)/100;
}

function DiffAmtLbRp(val,record){
	var diffamt=Number(record.lastcoamt)+Number(record.reccoamt)+Number(record.retcoamt)+Number(record.trfocoamt)
	+Number(record.trficoamt)+Number(record.adjcoamt)+Number(record.concoamt)+Number(record.dispcoamt)+Number(record.dspcoamt)
	+Number(record.aspcoamt)+Number(record.phaoutdispcoamt)+Number(record.phaoutretcoamt)+Number(record.dspretcoamt)
	+Number(record.recaspcoamt)+Number(record.retaspcoamt)+Number(record.phaoutretaspcoamt)+Number(record.pharetaspcoamt)+
	+Number(record.trfinaspcoamt)
	-Number(record.coamt);	
	return Math.round(diffamt*100)/100;
}
//合并DetailGridLB中相同的药品信息
function cellMerge(value, meta, record, rowIndex, colIndex, store) {
	var lastRowCode="",lastRowDesc="",lastRowSpec="",lastRowUom="";
	if(rowIndex>0){
		lastRowCode=store.getAt(rowIndex - 1).get("incicode"),lastRowDesc=store.getAt(rowIndex - 1).get("incidesc"),
		lastRowSpec=store.getAt(rowIndex - 1).get("spec"),lastRowUom=store.getAt(rowIndex - 1).get("puomdesc");
	}
	var thisRowCode=store.getAt(rowIndex).get("incicode"),thisRowDesc=store.getAt(rowIndex).get("incidesc"),
	thisRowSpec=store.getAt(rowIndex).get("spec"),thisRowUom=store.getAt(rowIndex).get("puomdesc");
	var nextRowCode="",nextRowDesc="",nextRowSpec="",nextRowUom="";
	if(rowIndex<store.getCount()-1){
		nextRowCode=store.getAt(rowIndex+1).get("incicode"),nextRowDesc=store.getAt(rowIndex+1).get("incidesc"),
		nextRowSpec=store.getAt(rowIndex+1).get("spec"),nextRowUom=store.getAt(rowIndex+1).get("puomdesc");
	}
	
    var first = !rowIndex || (thisRowCode !==lastRowCode)||(thisRowDesc!==lastRowDesc)||(thisRowSpec!==lastRowSpec)||(thisRowUom!==lastRowUom),
    last = rowIndex >= store.getCount() - 1 || (thisRowCode !==nextRowCode)||(thisRowDesc!==nextRowDesc)||(thisRowSpec!==nextRowSpec)||(thisRowUom!==nextRowUom);
    meta.css += 'row-span' + (first ? ' row-span-first' : '') +  (last ? ' row-span-last' : '');
    if (first) {
        var i = rowIndex + 1;
        while (i < store.getCount() && thisRowCode == store.getAt(i).get("incicode")
        &&thisRowDesc==store.getAt(i).get("incidesc")&&thisRowSpec==store.getAt(i).get("spec")&&thisRowUom==store.getAt(i).get("puomdesc")) {
            i++;
        }
        var rowHeight = 25, padding = 6,
            height = (rowHeight * (i - rowIndex) - padding) + 'px';
        meta.attr = 'style="height:' + height + ';line-height:' + height + ';"';
    }
    return first ? value : '';
}

var DetailStoreLB = new Ext.data.JsonStore({
	autoDestroy: true,
    url: Url+"actiontype=QueryDetailLB",
    storeId: 'DetailStoreLB',
    root: 'rows',
    totalProperty : "results",
    fields: ['incicode','incidesc', 'spec', 'manf','puomdesc','IBNO','qty','amt','coamt','lastqty','lastamt','lastcoamt','recqty','recamt','reccoamt',
    'retqty','retamt','retcoamt','trfoqty','trfoamt','trfocoamt','trfiqty','trfiamt','trficoamt','adjqty','adjamt','adjcoamt','dispqty','dispamt','dispcoamt',
    'aspamt', 'aspcoamt','dspamt','dspqty','dspcoamt','dspretqty','dspretamt','dspretcoamt','phaoutdispqty','phaoutdispamt','phaoutdispcoamt','phaoutretqty','phaoutretamt','phaoutretcoamt','retaspamt',
    'retaspcoamt','recaspamt','recaspcoamt','pharetaspamt','pharetaspcoamt','trfinaspamt','trfinaspcoamt','phaoutretaspamt','phaoutretaspcoamt','stktkqty','stktkamt','stktkcoamt','phaoutdispaspamt','phadispaspamt',
    {name:'diffQty',convert:DiffQtyLB},{name:'diffAmt',convert:DiffAmtLB},{name:'diffAmtRp',convert:DiffAmtLbRp}]
});
var DetailGridLB = new Ext.grid.GridPanel({
	id:'DetailGridLB',
    store: DetailStoreLB,
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    autoScroll:true,
    trackMouseOver : true,
    loadMask:true,
    view: new Ext.ux.grid.BufferView({
		    // custom row height
		    rowHeight: 25,
		    borderHeight:1,
		    // render rows as they come into viewable area.
		    scrollDelay: false,
		    getRowClass:function(record,index,rowParams,store){
				var diffQty=record.get("diffQty");
				var diffAmt=record.get("diffAmt");
				if((diffQty!=0)||(diffAmt!=0)){
					return 'my_row_Yellow';
				}
			}
	    }),
	    //cls: 'grid-row-span',
	cm:new Ext.grid.ColumnModel([new Ext.grid.RowNumberer({width:30}),  {
			header : '药品代码',
			dataIndex : 'incicode',
			width : 80,
			align : 'left',
			sortable : true
			//renderer:cellMerge  //yunhaibao,20151207注释,不如不合并效果好
		}, {
			header : '药品名称',
			dataIndex : 'incidesc',
			width : 220,
			align : 'left',
			sortable : true
			//renderer:cellMerge
		}, {
			header : '规格',
			dataIndex : 'spec',
			width : 100,
			align : 'left',
			sortable : true
			//renderer:cellMerge
		},{
			header : "单位",
			dataIndex : 'puomdesc',
			width : 80,
			align : 'left',
			sortable : true
			//renderer:cellMerge
		}, {
			header:'厂商',
			dataIndex : 'manf',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "批次",
			dataIndex : 'IBNO',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "本期结存数量",
			dataIndex : 'qty',
			width : 90,
			align : 'right',
			sortable : true
		}, {
			header : "本期结存金额",
			dataIndex : 'amt',
			width : 100,
			align : 'right',
			sortable : true
		},{
			header:'上期结存数量',
			dataIndex:'lastqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'上期结存金额',
			dataIndex:'lastamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'入库数量',
			dataIndex:'recqty',
			width:100,
			align:'right',
			sortable:'true',
			renderer:renderRecQty
		},{
			header:'入库金额',
			dataIndex:'recamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'退货数量',
			dataIndex:'retqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'退货金额',
			dataIndex:'retamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'转出数量',
			dataIndex:'trfoqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'转出金额',
			dataIndex:'trfoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'转入数量',
			dataIndex:'trfiqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'转入金额',
			dataIndex:'trfiamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'调整数量',
			dataIndex:'adjqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'调整金额',
			dataIndex:'adjamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'报损数量',
			dataIndex:'dispqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'报损金额',
			dataIndex:'dispamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'调价损益',
			dataIndex:'aspamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'住院发药数量',
			dataIndex:'dspqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'住院发药金额',
			dataIndex:'dspamt',
			width:100,
			align:'right',
			sortable:'true'
		} ,{
			header:'住院退药数量',
			dataIndex:'dspretqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'住院退药金额',
			dataIndex:'dspretamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'门诊发药数量',
			dataIndex:'phaoutdispqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'门诊发药金额',
			dataIndex:'phaoutdispamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'门诊退药数量',
			dataIndex:'phaoutretqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'门诊退药金额',
			dataIndex:'phaoutretamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'盘点调整数量',
			dataIndex:'stktkqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'盘点调整金额',
			dataIndex:'stktkamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'入库损益',
			dataIndex:'recaspamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'退货损益',
			dataIndex:'retaspamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'转移入库损益',
			dataIndex:'trfinaspamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'住院退药损益',
			dataIndex:'pharetaspamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'门诊退药损益',
			dataIndex:'phaoutretaspamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'门诊发药损益',
			dataIndex:'phaoutdispaspamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'住院发药损益',
			dataIndex:'phadispaspamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'数量差异',
			dataIndex:'diffQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'金额差异',
			dataIndex:'diffAmt',
			width:100,
			align:'right',
			sortable:'true'
		}])
});

var DetailGridLBRp = new Ext.grid.GridPanel({
	id:'DetailGridLBRp',
    store: DetailStoreLB,
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    autoScroll:true,
    trackMouseOver : true,
    loadMask:true,
    view: new Ext.ux.grid.BufferView({
		    // custom row height
		    rowHeight: 25,
		    borderHeight:1,
		    // render rows as they come into viewable area.
		    scrollDelay: false,
		    getRowClass:function(record,index,rowParams,store){
				var diffQty=record.get("diffQty");
				var diffAmt=record.get("diffAmt");
				if((diffQty!=0)||(diffAmt!=0)){
					return 'my_row_Yellow';
				}
			}
	    }),
	cm:new Ext.grid.ColumnModel([new Ext.grid.RowNumberer({width:30}),  {
			header : '药品代码',
			dataIndex : 'incicode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '药品名称',
			dataIndex : 'incidesc',
			width : 220,
			align : 'left',
			sortable : true
		}, {
			header : '规格',
			dataIndex : 'spec',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header:'厂商',
			dataIndex : 'manf',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "单位",
			dataIndex : 'puomdesc',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "批次",
			dataIndex : 'IBNO',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "本期结存数量",
			dataIndex : 'qty',
			width : 90,
			align : 'right',
			sortable : true
		}, {
			header : "本期结存金额",
			dataIndex : 'coamt',
			width : 100,
			align : 'right',
			sortable : true
		},{
			header:'上期结存数量',
			dataIndex:'lastqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'上期结存金额',
			dataIndex:'lastcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'入库数量',
			dataIndex:'recqty',
			width:100,
			align:'right',
			sortable:'true',
			renderer:renderRecQty
		},{
			header:'入库金额',
			dataIndex:'reccoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'退货数量',
			dataIndex:'retqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'退货金额',
			dataIndex:'retcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'转出数量',
			dataIndex:'trfoqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'转出金额',
			dataIndex:'trfocoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'转入数量',
			dataIndex:'trfiqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'转入金额',
			dataIndex:'trficoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'调整数量',
			dataIndex:'adjqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'调整金额',
			dataIndex:'adjcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'报损数量',
			dataIndex:'dispqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'报损金额',
			dataIndex:'dispcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'调价损益',
			dataIndex:'aspcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'住院发药数量',
			dataIndex:'dspqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'住院发药金额',
			dataIndex:'dspcoamt',
			width:100,
			align:'right',
			sortable:'true'
		} ,{
			header:'住院退药数量',
			dataIndex:'dspretqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'住院退药金额',
			dataIndex:'dspretcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'门诊发药数量',
			dataIndex:'phaoutdispqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'门诊发药金额',
			dataIndex:'phaoutdispcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'门诊退药数量',
			dataIndex:'phaoutretqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'门诊退药金额',
			dataIndex:'phaoutretcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'盘点调整数量',
			dataIndex:'stktkqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'盘点调整金额',
			dataIndex:'stktkcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'入库损益',
			dataIndex:'recaspcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'退货损益',
			dataIndex:'retaspcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'转移入库损益',
			dataIndex:'trfinaspcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'住院退药损益损益',
			dataIndex:'pharetaspcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'门诊退药损益',
			dataIndex:'phaoutretaspcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'数量差异',
			dataIndex:'diffQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'金额差异',
			dataIndex:'diffAmtRp',
			width:100,
			align:'right',
			sortable:'true'
		}])
});

var DetailStoreSCG = new Ext.data.JsonStore({
	autoDestroy:true,
	url:Url+"actiontype=QuerySumBySCG",
	totalProperty:'results',
	root:'rows',
	fields:['grpDesc','LastAmt','Amt','RecAmt','RetAmt','TroAmt',
		'TriAmt','AdjAmt','ConAmt','DisAmt','DspAmt',
		'AspAmt','PhaRetAmt','RetAspAmt','PhaRetAspAmt','GiftRecAmt',
		'giftTrfAmt','chgRecAmt','chgRetAmt','mRecAmt','stktkAdjAmt',
		'manuXAmt','manuMAmt','phoRetAspAmt','trfIAspAmt','recAspAmt',
		,'phaOutDispAspAmt','phaDispAspAmt','In','Out'
	]
});

var DetailGridSCG = new Ext.grid.GridPanel({
	id:'DetailGridSCG',
	store:DetailStoreSCG,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	autoScroll:true,
	trackMouseOver : true,
	loadMask:true,
	cm:new Ext.grid.ColumnModel([new Ext.grid.RowNumberer({width:30}), {
			header : '类组',
			dataIndex : 'grpDesc',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '上期结存金额',
			dataIndex : 'LastAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '本期结存金额',
			dataIndex : 'Amt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '入库金额',
			dataIndex : 'RecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '退货金额',
			dataIndex : 'RetAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '转出金额',
			dataIndex : 'TroAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '转入金额',
			dataIndex : 'TriAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '调整金额',
			dataIndex : 'AdjAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '消耗金额',
			dataIndex : 'ConAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '报损金额',
			dataIndex : 'DisAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '发药金额',
			dataIndex : 'DspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '调价损益金额',
			dataIndex : 'AspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '患者退药金额',
			dataIndex : 'PhaRetAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '赠品入库金额',
			dataIndex : 'GiftRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '赠品出库金额',
			dataIndex : 'giftTrfAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '调价换票入库金额',
			dataIndex : 'chgRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '调价换票退货金额',
			dataIndex : 'chgRetAmt',
			width : 100,
			align : 'right',
			sortable : true
		},/* { 
			header : '制剂入库金额',
			dataIndex : 'mRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, */{
			header : '盘点调整金额',
			dataIndex : 'stktkAdjAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '制剂消耗金额',
			dataIndex : 'manuXAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '制剂生成金额',
			dataIndex : 'manuMAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '退货损益',
			dataIndex : 'RetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '住院退药损益',
			dataIndex : 'PhaRetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '门诊退药损益',
			dataIndex : 'phoRetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '转移入库损益',
			dataIndex : 'trfIAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '入库损益',
			dataIndex : 'recAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '门诊发药损益',
			dataIndex : 'phaOutDispAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '住院发药损益',
			dataIndex : 'phaDispAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '增加',
			dataIndex : 'In',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '减少',
			dataIndex : 'Out',
			width : 100,
			align : 'right',
			sortable : true
		}
	])
});

var DetailGridSCGRp = new Ext.grid.GridPanel({
	id:'DetailGridSCGRp',
	store:DetailStoreSCG,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	autoScroll:true,
	trackMouseOver : true,
	loadMask:true,
	cm:new Ext.grid.ColumnModel([new Ext.grid.RowNumberer({width:30}), {
			header : '类组',
			dataIndex : 'grpDesc',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '上期结存金额',
			dataIndex : 'LastAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '本期结存金额',
			dataIndex : 'Amt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '入库金额',
			dataIndex : 'RecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '退货金额',
			dataIndex : 'RetAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '转出金额',
			dataIndex : 'TroAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '转入金额',
			dataIndex : 'TriAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '调整金额',
			dataIndex : 'AdjAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '消耗金额',
			dataIndex : 'ConAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '报损金额',
			dataIndex : 'DisAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '发药金额',
			dataIndex : 'DspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '调价损益金额',
			dataIndex : 'AspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '患者退药金额',
			dataIndex : 'PhaRetAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '退货损益',
			dataIndex : 'RetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '住院退药损益',
			dataIndex : 'PhaRetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '赠品入库金额',
			dataIndex : 'GiftRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '赠品出库金额',
			dataIndex : 'giftTrfAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '调价换票入库金额',
			dataIndex : 'chgRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '调价换票退货金额',
			dataIndex : 'chgRetAmt',
			width : 100,
			align : 'right',
			sortable : true
		},/* {
			header : '制剂入库金额',
			dataIndex : 'mRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, */{
			header : '盘点调整金额',
			dataIndex : 'stktkAdjAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '制剂消耗金额',
			dataIndex : 'manuXAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '制剂生成金额',
			dataIndex : 'manuMAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '门诊退药损益',
			dataIndex : 'phoRetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '转移入库损益',
			dataIndex : 'trfIAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '入库损益',
			dataIndex : 'recAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '增加',
			dataIndex : 'In',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '减少',
			dataIndex : 'Out',
			width : 100,
			align : 'right',
			sortable : true
		}
	])
});
var DetailStoreCat = new Ext.data.JsonStore({
	autoDestroy:true,
	url:Url+"actiontype=QuerySumByCat",
	totalProperty:'results',
	root:'rows',
	fields:['grpDesc','catdesc','LastAmt','Amt','RecAmt','RetAmt','TroAmt',
		'TriAmt','AdjAmt','ConAmt','DisAmt','DspAmt',
		'AspAmt','PhaRetAmt','RetAspAmt','PhaRetAspAmt','GiftRecAmt',
		'giftTrfAmt','chgRecAmt','chgRetAmt','mRecAmt','stktkAdjAmt',
		'manuXAmt','manuMAmt','phoRetAspAmt','trfIAspAmt','recAspAmt',
		'phaOutDispAspAmt','phaDispAspAmt','In','Out'
	]
});
var DetailGridCat = new Ext.grid.GridPanel({
	id:'DetailGridCat',
	store:DetailStoreCat,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	autoScroll:true,
	trackMouseOver : true,
	loadMask:true,
	cm:new Ext.grid.ColumnModel([new Ext.grid.RowNumberer({width:30}), {
			header : '类组',
			dataIndex : 'grpDesc',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '分类',
			dataIndex : 'catdesc',
			width : 125,
			align : 'left',
			sortable : true
		}, {
			header : '上期结存金额',
			dataIndex : 'LastAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '本期结存金额',
			dataIndex : 'Amt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '入库金额',
			dataIndex : 'RecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '退货金额',
			dataIndex : 'RetAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '转出金额',
			dataIndex : 'TroAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '转入金额',
			dataIndex : 'TriAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '调整金额',
			dataIndex : 'AdjAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '消耗金额',
			dataIndex : 'ConAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '报损金额',
			dataIndex : 'DisAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '发药金额',
			dataIndex : 'DspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '调价损益金额',
			dataIndex : 'AspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '患者退药金额',
			dataIndex : 'PhaRetAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '退货损益',
			dataIndex : 'RetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '住院退药损益',
			dataIndex : 'PhaRetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '赠品入库金额',
			dataIndex : 'GiftRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '赠品出库金额',
			dataIndex : 'giftTrfAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '调价换票入库金额',
			dataIndex : 'chgRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '调价换票退货金额',
			dataIndex : 'chgRetAmt',
			width : 100,
			align : 'right',
			sortable : true
		},/* {
			header : '制剂入库金额',
			dataIndex : 'mRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, */{
			header : '盘点调整金额',
			dataIndex : 'stktkAdjAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '制剂消耗金额',
			dataIndex : 'manuXAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '制剂生成金额',
			dataIndex : 'manuMAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '门诊退药损益',
			dataIndex : 'phoRetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '转移入库损益',
			dataIndex : 'trfIAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '入库损益',
			dataIndex : 'recAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '门诊发药损益',
			dataIndex : 'phaOutDispAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '住院发药损益',
			dataIndex : 'phaDispAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '增加',
			dataIndex : 'In',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '减少',
			dataIndex : 'Out',
			width : 100,
			align : 'right',
			sortable : true
		}
	])
});
var DetailGridCatRp = new Ext.grid.GridPanel({
	id:'DetailGridCatRp',
	store:DetailStoreCat,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	autoScroll:true,
	trackMouseOver : true,
	loadMask:true,
	cm:new Ext.grid.ColumnModel([new Ext.grid.RowNumberer({width:30}), {
			header : '类组',
			dataIndex : 'grpDesc',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '分类',
			dataIndex : 'catdesc',
			width : 125,
			align : 'left',
			sortable : true
		}, {
			header : '上期结存金额',
			dataIndex : 'LastAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '本期结存金额',
			dataIndex : 'Amt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '入库金额',
			dataIndex : 'RecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '退货金额',
			dataIndex : 'RetAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '转出金额',
			dataIndex : 'TroAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '转入金额',
			dataIndex : 'TriAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '调整金额',
			dataIndex : 'AdjAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '消耗金额',
			dataIndex : 'ConAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '报损金额',
			dataIndex : 'DisAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '发药金额',
			dataIndex : 'DspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '调价损益金额',
			dataIndex : 'AspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '患者退药金额',
			dataIndex : 'PhaRetAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '退货损益',
			dataIndex : 'RetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '住院退药损益',
			dataIndex : 'PhaRetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '赠品入库金额',
			dataIndex : 'GiftRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '赠品出库金额',
			dataIndex : 'giftTrfAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '调价换票入库金额',
			dataIndex : 'chgRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '调价换票退货金额',
			dataIndex : 'chgRetAmt',
			width : 100,
			align : 'right',
			sortable : true
		},/* {
			header : '制剂入库金额',
			dataIndex : 'mRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		},*/ {
			header : '盘点调整金额',
			dataIndex : 'stktkAdjAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '制剂消耗金额',
			dataIndex : 'manuXAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '制剂生成金额',
			dataIndex : 'manuMAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '门诊退药损益',
			dataIndex : 'phoRetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '转移入库损益',
			dataIndex : 'trfIAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '入库损益',
			dataIndex : 'recAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '增加',
			dataIndex : 'In',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '减少',
			dataIndex : 'Out',
			width : 100,
			align : 'right',
			sortable : true
		}
	])
});

var MainStore=new Ext.data.JsonStore({
	auroDestroy:true,
	url:Url+"actiontype=Query",
	sotreId:'MainStore',
	root:'rows',
	totalProperty:'results',
	idProperty:'smRowid',
	fields:['smRowid','locDesc','mon','frDate','frTime','toDate','toTime']
});

var MainGrid=new Ext.grid.GridPanel({
	id:'MainGrid',
	store:MainStore,
	cm:new Ext.grid.ColumnModel([{
		header:'Rowid',
		dataIndex:'smRowid',
		width:100,
		align:'left',
		hidden:true
	},{
		header:'科室',
		dataIndex:'locDesc',
		width:200,
		align:'left',
		sortable:true
	},{
		header:'月份',
		dataIndex:'mon',
		width:75,
		align:'center',
		sortable:true
	},{
		header:'月报起始日期',
		dataIndex:'frDate',
		width:150,
		align:'center',
		sortable:true,
		renderer:function(value,metaData,record,rowIndex,colIndex,store){
			var StDateTime=value+" "+record.get('frTime');
			return StDateTime;
		}
	},{
		header:'月报截止日期',
		dataIndex:'toDate',
		width:150,
		align:'center',
		sortable:true,
		renderer:function(value,metaData,record,rowIndex,colIndex,store){
			var EdDateTime=value+" "+record.get('toTime');
			return EdDateTime;
		}
	}]),
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	autoScroll:true
})

MainGrid.addListener('rowclick',function(grid,rowindex,e){
	MonRepFilter();
});
	var mainForm = new Ext.form.FormPanel({
        autoHeight:true,
		labelWidth : 60,
		tbar : [SearchBT,'-',printBT,'-',SaveAsBT,'-',HelpBT],
		labelAlign : 'right',
		frame : true,
		items:[{
			layout:'column',
			xtype: 'fieldset',
			title:'查询条件',
			style:DHCSTFormStyle.FrmPaddingV,
			items:[{
				columnWidth: 1,
		    	xtype: 'fieldset',
		    	defaults: {width: 450, border:false},    // Default config options for child items
		    	defaultType: 'textfield',
		    	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
		    	border: false,
		    	items: [
		    		PhaLoc,
		    		{
						xtype: 'fieldset',
						style:'margin-top:6px;padding-left:0px;padding-bottom:0px;',
						items:[{
							xtype: 'compositefield',						
							items : [
								StYear,
								{ xtype: 'displayfield', value: '年'},
								StMonth,
								{ xtype: 'displayfield', value: ' －至－'},
								EdYear,
								{ xtype: 'displayfield', value: '年'},
								EdMonth,
								{xtype:'displayfield',value:'月'}
							 ]
						}]
					}
				]
			}]

		}]						
	});

	//Ext.getCmp('PhaLoc').select(gLocId);
	//SetStkMonStDate();
   var tabPanel=new Ext.TabPanel({
   		activeTab:0,
   		tbar:new Ext.Toolbar({items:[StkGrpType,IncStkCat,IncDesc,Filter,'<font color=blue>&nbsp;&nbsp仅对明细进行筛选</font>']}),
   		items:[{
   			title:'月报明细(售价)',
   			id:'ReportDetailSp',
   			layout:'fit',
   			items:[DetailGrid]
   		},{
   			title:'月报明细(进价)',
   			id:'ReportDetailRp',
   			layout:'fit',
   			items:[DetailGridRp]
   		}/*,{
   			title:'月报明细批次（售价）',
   			id:'ReportDetailLbSp',
   			layout:'fit',
   			items:[DetailGridLB]
   		},{
   			title:'月报明细批次(进价)',
   			id:'ReportDetailLbRp',
   			layout:'fit',
   			items:[DetailGridLBRp]
   		}*/,{
   			title:'类组汇总(进价)',
   			id:'ReportDetailSCGRp',
   			layout:'fit',
   			items:[DetailGridSCGRp]
   		},{
   			title:'类组汇总(售价)',
   			id:'ReportDetailSCG',
   			layout:'fit',
   			items:[DetailGridSCG]
   		},{
   			title:'分类汇总(售价)',
   			id:'ReportDetailCat',
   			layout:'fit',
   			items:[DetailGridCat]
   		},{
   			title:'分类汇总(进价)',
   			id:'ReportDetailCatRp',
   			layout:'fit',
   			items:[DetailGridCatRp]
   		}]
   })
   
   tabPanel.addListener('tabchange',function(tabpanel,panel){
   		var record=MainGrid.getSelectionModel().getSelected();
		
		if(record){
			var rowid=record.get("smRowid");
			var stkgrpid=Ext.getCmp("StkGrpType").getValue();
			var stkcatid=Ext.getCmp("IncStkCat").getValue();
			var incdesc=Ext.getCmp("IncDesc").getValue();
			growid=rowid
			activeTabtmp=panel
	   		if((panel.id=="ReportDetailSp")&(DetailStore.getCount()==0)){
				DetailStore.load({params:{Parref:rowid,StkGrpId:stkgrpid,StkCatId:stkcatid,IncDesc:incdesc}});
			}else if((panel.id=="ReportDetailRp")&(DetailStoreRp.getCount()==0)){
				DetailStoreRp.load({params:{Parref:rowid,StkGrpId:stkgrpid,StkCatId:stkcatid,IncDesc:incdesc}});
			}else if(panel.id=="ReportDetailLbSp" || panel.id=="ReportDetailLbRp"){
				if(DetailStoreLB.getCount()==0){
					DetailStoreLB.load({params:{Parref:rowid,StkGrpId:stkgrpid,StkCatId:stkcatid,IncDesc:incdesc}});
				}
			}else if(panel.id=="ReportDetailSCGRp"){
				DetailStoreSCG.load({params:{Parref:rowid,Type:0}});
			}else if(panel.id=="ReportDetailSCG"){
				DetailStoreSCG.load({params:{Parref:rowid,Type:1}});
			}
			else if(panel.id=="ReportDetailCat"){
				DetailStoreCat.load({params:{Parref:rowid,Type:1}});
			}
			else if(panel.id=="ReportDetailCatRp"){
				DetailStoreCat.load({params:{Parref:rowid,Type:0}});
			}
		}
	});
	
	var myPanel = new Ext.Viewport({
		renderTo:'mainPanel',
		layout : 'border',
		items : [ 
		{
			region:'north',
			height:DHCSTFormStyle.FrmHeight(2)+28,
			layout:'fit',
			title:'月报明细查询',
			layout: 'border', // specify layout manager for items
			items: [{
				region: 'west',
				split: false,
				width: document.body.clientWidth*0.4,                			
				layout: 'fit', // specify layout manager for items
				items: mainForm 				               
			},{
				region:'center',
				layout:'fit',
				items:MainGrid 
			}]
		},{ 
			region:'center',
			layout:'fit',
			items:tabPanel 
		}]
	});
  //Query();   
   new Ext.ToolTip({
        target: 'HelpBtn',
        anchor: 'buttom',
        width: 250,
        anchorOffset: 50,
		hideDelay : 90000,
        html: "<font size=2 color=#15428b ><p><b>增加:</b>各种业务数据金额为正的合计</p><p><b>减少:</b>各种业务数据金额为负的合计</p><p><b>差异:</b>上期结余+增加+减少-本期结余</p></font>"
   });
    Ext.getCmp('HelpBtn').focus('',100); //初始化页面给某个元素设置焦点	  
}) 