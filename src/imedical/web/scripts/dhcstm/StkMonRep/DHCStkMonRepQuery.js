// /名称: 月报明细查询
// /描述: 月报明细查询
// /编写者：zhangdongmei
// /编写日期: 2012.11.23

	//勾选财务类组控件时,联动修改此全局变量
	var SCGTYPE = 'M';		//财务类组(物资类组M,财务类组O)

	var gUserId = session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gIncid="";
	//alert(gIngrRowid);
	var Url=DictUrl	+ 'stkmonaction.csp?';
	var today=new Date();
	var growid=""
	var activeTabtmp=""

	var PhaLoc = new Ext.ux.LocComboBox({
		id : 'PhaLoc',
		name : 'PhaLoc',
		fieldLabel : '科室',
		listWidth : 200,
		groupId:gGroupId,
		stkGrpId : 'StkGrpType'
	});

	var StYear=new Ext.form.TextField({
		fieldLabel:'月份',
		id:'StYear',
		name:'StYear',
		anchor:'90%',
		width:80,
		value:today.getFullYear()
	});
	var StMonth=new Ext.form.TextField({
		fieldLabel:'',
		id:'StMonth',
		name:'StMonth',
		anchor:'90%',
		width:80,
		value:((today.getMonth()-10)<=0?1:(today.getMonth()-10))
	});

	var EdYear=new Ext.form.TextField({
		fieldLabel:'',
		id:'EdYear',
		name:'EdYear',
		anchor:'90%',
		width:80,
		value:today.getFullYear()
	});

	var EdMonth=new Ext.form.TextField({
		fieldLabel:'',
		id:'EdMonth',
		name:'EdMonth',
		anchor:'90%',
		width:80,
		value:(today.getMonth()+1)
	});

	var FinancialFlag = new Ext.form.Checkbox({
		hideLabel : true,
		boxLabel : '财务类组',
		listeners : {
			check : function(checkbox, checked){
				SCGTYPE = checked ? 'O' : 'M';
				Ext.getCmp('IncStkCat').setValue('');
				Ext.getCmp('StkGrpType').setValue('');
				Ext.getCmp('StkGrpType').StkType = SCGTYPE;
				Ext.getCmp('StkGrpType').getStore().reload();
			}
		}
	})

	// 物资类组
	var StkGrpType=new Ext.ux.StkGrpComboBox({
		id : 'StkGrpType',
		width : 150,
		listWidth : 200,
		StkType : SCGTYPE,
		LocId:gLocId,
		UserId:gUserId,
		anchor:'90%',
		childCombo : 'IncStkCat',
		listeners : {
			select : function(){
				tabPanel.fireEvent('tabchange',tabPanel,tabPanel.getActiveTab());
			}
		}
	});

	var IncStkCat=new Ext.ux.ComboBox({
		id:'IncStkCat',
		width : 150,
		store:StkCatStore,
		displayField:'Description',
		valueField:'RowId',
		emptyText:'库存分类',
		params:{StkGrpId:'StkGrpType'}
	});

	var IncDesc=new Ext.form.TextField({
		id:'IncDesc',
		name:'IncDesc',
		emptyText:'物资名称',
		width:150,
		listeners:{
			'specialkey':function(field,e){
				if(e.getKey()==Ext.EventObject.ENTER){
					var stkgrp = Ext.getCmp("StkGrpType").getValue();
					GetPhaOrderWindow(field.getValue(), stkgrp, App_StkTypeCode, "", "N", "0", "",getDrugList);
				}
			}
		}
	});

	var Filter=new Ext.Toolbar.Button({
		id:'filter',
		text:'筛选',
		iconCls : 'page_find',
		anchor:'90%',
		handler:function(){
			tabPanel.fireEvent('tabchange',tabPanel,tabPanel.getActiveTab());
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
		Ext.getCmp("IncDesc").setValue(inciDesc);
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
		var selectRecord=MainGrid.getSelectionModel().getSelected();
		var startDate=selectRecord.get("frDate");
		var endDate=selectRecord.get("toDate");
		var incId=record.get("inci"),incDesc=record.get("incidesc");
		var DateFlag=1;  //按审核日期统计
		var QueryParams=Loc+","+startDate+","+endDate+","+incId+","+incDesc+","+DateFlag;
		var newUrl="http://"+host+""+commonPath+"/csp/dhcstm.ingdrecquery.csp?QueryParams={0}"
		/*
		alert(curUrl);
		alert(host);
		alert(window.location.pathname);
		alert(pos);  */
		return String.format('<a href='+newUrl+' target="_blank">{1}',QueryParams,value);
		//return String.format('<b><a href="http://extjs.com/forum/showthread.php?t={2}" target="_blank">{0}</a></b><a href="http://extjs.com/forum/forumdisplay.php?f={3}" target="_blank">{1} Forum</a>',
		//);

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
			header : '物资代码',
			dataIndex : 'inciCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '物资名称',
			dataIndex : 'inciDesc',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : '规格',
			dataIndex : 'spec',
			width : 80,
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
			summaryType : 'sum',
			width : 90,
			align : 'right',
			sortable : true
		}, {
			header : "本期结存金额",
			dataIndex : 'amt',
			summaryType : 'sum',
			width : 100,
			align : 'right',
			sortable : true
		},{
			header:'上期结存数量',
			dataIndex:'lastQty',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'上期结存金额',
			dataIndex:'lastAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'入库数量',
			dataIndex:'recQty',
			width:100,
			align:'right',
			sortable:'true'
		//	useRenderExport : false,
		//	renderer:renderRecQty
		},{
			header:'入库金额',
			dataIndex:'recAmt',
			summaryType : 'sum',
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
			summaryType : 'sum',
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
			summaryType : 'sum',
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
			summaryType : 'sum',
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
			summaryType : 'sum',
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
			summaryType : 'sum',
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
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'调价损益',
			dataIndex:'aspAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'赠品入库数量',
			dataIndex:'giftRecQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'赠品入库金额',
			dataIndex:'giftRecAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'赠品出库数量',
			dataIndex:'giftTrOutQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'赠品出库金额',
			dataIndex:'giftTrOutAmt',
			summaryType : 'sum',
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
			summaryType : 'sum',
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
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'退货损益(调价)',
			dataIndex:'retAspAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'转入损益(调价)',
			dataIndex:'trInAspAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},
		/*{
			header:'制剂入库数量',
			dataIndex:'mRecQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'制剂入库金额',
			dataIndex:'mRecAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},*/
		{
			header:'盘点调整数量',
			dataIndex:'stktkAdjQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'盘点调整金额',
			dataIndex:'stktkAdjAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},
		/*{
			header:'制剂消耗数量',
			dataIndex:'manuXQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'制剂消耗金额',
			dataIndex:'manuXAmt',
			summaryType : 'sum',
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
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},*/
		{
			header:'数量差异',
			dataIndex:'diffQty',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'金额差异',
			dataIndex:'diffAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		}]);

	function DiffQty(val,record){
		var diffqty=Number(record.lastQty)+Number(record.recQty)+Number(record.retQty)+Number(record.trOutQty)+Number(record.trInQty)+Number(record.adjQty)+Number(record.csmQty)+Number(record.disposeQty)+
		Number(record.giftRecQty)+Number(record.giftTrOutQty)+Number(record.chgRecQty)+Number(record.chgRetQty)+Number(record.mRecQty)+Number(record.stktkAdjQty)+Number(record.manuXQty)+Number(record.manuMQty)-Number(record.qty);
		return Math.round(diffqty*100)/100;
	}

	function DiffAmt(val,record){
		var diffamt=Number(record.lastAmt)+Number(record.recAmt)+Number(record.retAmt)+Number(record.trOutAmt)+Number(record.trInAmt)+Number(record.adjAmt)+Number(record.csmAmt)+Number(record.disposeAmt)+
		Number(record.giftRecAmt)+Number(record.giftTrOutAmt)+Number(record.chgRecAmt)+Number(record.chgRetAmt)+Number(record.mRecAmt)+Number(record.stktkAdjAmt)+Number(record.manuXAmt)+
		Number(record.manuMAmt)+Number(record.trInAspAmt)+Number(record.aspAmt)+Number(record.retAspAmt)-Number(record.amt);

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
		{name:'diffQty',convert:DiffQty},{name:'diffAmt',convert:DiffAmt}]
	});

	var DetailGrid = new Ext.ux.GridPanel({
		id:'DetailGrid',
		store: DetailStore,
		cm:DetailCm,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		autoScroll:true,
		trackMouseOver : true,
		loadMask:true,
		plugins : new Ext.grid.GridSummary(),
		view: new Ext.ux.grid.BufferView({
				// custom row height
				rowHeight: 25,
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

	var DetailStoreRp = new Ext.data.JsonStore({
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
		{name:'diffQty',convert:DiffQty},{name:'diffAmt',convert:DiffAmt}]
	});

	var DetailGridRp = new Ext.ux.GridPanel({
		id:'DetailGridRp',
		store: DetailStoreRp,
		cm:DetailCm,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		autoScroll:true,
		trackMouseOver : true,
		loadMask:true,
		plugins : new Ext.grid.GridSummary(),
		view: new Ext.ux.grid.BufferView({
			// custom row height
			rowHeight: 25,
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
		+Number(record.trfiqty)+Number(record.adjqty)+Number(record.conqty)-Number(record.qty)+Number(record.stkqty);
		return Math.round(diffqty*100)/100;
	}

	function DiffAmtLB(val,record){
		var diffamt=Number(record.lastamt)+Number(record.recamt)+Number(record.retamt)+Number(record.trfoamt)+Number(record.trfiamt)+Number(record.adjamt)+Number(record.conamt)+
		Number(record.aspamt)-Number(record.amt)+Number(record.stkamt);
		return Math.round(diffamt*100)/100;
	}

	function DiffAmtLbRp(val,record){
		var diffamt=Number(record.lastcoamt)+Number(record.reccoamt)+Number(record.retcoamt)+Number(record.trfocoamt)+Number(record.trficoamt)+Number(record.adjcoamt)+Number(record.concoamt)+
		Number(record.aspcoamt)-Number(record.coamt)+Number(record.stkcoamt);
		return Math.round(diffamt*100)/100;
	}

	//合并DetailGridLB中相同的物资信息
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
		root: 'rows',
		totalProperty : "results",
		fields: ['inci','incicode','incidesc', 'spec', 'manf','puomdesc','IBNO','qty','amt','coamt','lastqty','lastamt','lastcoamt','recqty','recamt','reccoamt',
		'retqty','retamt','retcoamt','trfoqty','trfoamt','trfocoamt','trfiqty','trfiamt','trficoamt','adjqty','adjamt','adjcoamt','conqty','conamt','concoamt',
		'aspamt', 'aspcoamt','stkqty','stkamt','stkcoamt',{name:'diffQty',convert:DiffQtyLB},{name:'diffAmt',convert:DiffAmtLB},{name:'diffAmtRp',convert:DiffAmtLbRp}]
	});
	var DetailGridLB = new Ext.ux.GridPanel({
		id:'DetailGridLB',
		store: DetailStoreLB,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		autoScroll:true,
		trackMouseOver : true,
		loadMask:true,
		plugins : new Ext.grid.GridSummary(),
		view: new Ext.ux.grid.BufferView({
			// custom row height
			rowHeight: 25,
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
			header : '物资代码',
			dataIndex : 'incicode',
			width : 80,
			align : 'left',
			sortable : true/*,
			renderer:cellMerge*/
		}, {
			header : '物资名称',
			dataIndex : 'incidesc',
			width : 100,
			align : 'left',
			sortable : true/*,
			renderer:cellMerge*/
		}, {
			header : '规格',
			dataIndex : 'spec',
			width : 80,
			align : 'left',
			sortable : true/*,
			renderer:cellMerge*/
		},{
			header : "单位",
			dataIndex : 'puomdesc',
			width : 80,
			align : 'left',
			sortable : true/*,
			renderer:cellMerge*/
		}, {
			header:'厂商',
			dataIndex : 'manf',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "批次",
			dataIndex : 'IBNO',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "本期结存数量",
			dataIndex : 'qty',
			summaryType : 'sum',
			width : 90,
			align : 'right',
			sortable : true
		}, {
			header : "本期结存金额",
			dataIndex : 'amt',
			summaryType : 'sum',
			width : 100,
			align : 'right',
			sortable : true
		},{
			header:'上期结存数量',
			dataIndex:'lastqty',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'上期结存金额',
			dataIndex:'lastamt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'入库数量',
			dataIndex:'recqty',
			width:100,
			align:'right',
			sortable:'true'
		//	useRenderExport : false,
		//	renderer:renderRecQty
		},{
			header:'入库金额',
			dataIndex:'recamt',
			summaryType : 'sum',
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
			summaryType : 'sum',
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
			summaryType : 'sum',
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
			summaryType : 'sum',
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
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'盘点调整数量',
			dataIndex:'stkqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'盘点调整金额',
			dataIndex:'stkamt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'报损数量',
			dataIndex:'conqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'报损金额',
			dataIndex:'conamt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'调价损益',
			dataIndex:'aspamt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'数量差异',
			dataIndex:'diffQty',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'金额差异',
			dataIndex:'diffAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		}])
	});

	var DetailStoreLBRp = new Ext.data.JsonStore({
		autoDestroy: true,
		url: Url+"actiontype=QueryDetailLB",
		root: 'rows',
		totalProperty : "results",
		fields: ['inci','incicode','incidesc', 'spec', 'manf','puomdesc','IBNO','qty','amt','coamt','lastqty','lastamt','lastcoamt','recqty','recamt','reccoamt',
		'retqty','retamt','retcoamt','trfoqty','trfoamt','trfocoamt','trfiqty','trfiamt','trficoamt','adjqty','adjamt','adjcoamt','conqty','conamt','concoamt',
		'aspamt', 'aspcoamt','stkqty','stkamt','stkcoamt',{name:'diffQty',convert:DiffQtyLB},{name:'diffAmt',convert:DiffAmtLB},{name:'diffAmtRp',convert:DiffAmtLbRp}]
	});

	var DetailGridLBRp = new Ext.ux.GridPanel({
		id:'DetailGridLBRp',
		store: DetailStoreLBRp,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		autoScroll:true,
		trackMouseOver : true,
		loadMask:true,
		plugins : new Ext.grid.GridSummary(),
		view: new Ext.ux.grid.BufferView({
			// custom row height
			rowHeight: 25,
			// render rows as they come into viewable area.
			scrollDelay: false,
			getRowClass:function(record,index,rowParams,store){
				var diffQty=record.get("diffQty");
				var diffAmtRp=record.get("diffAmtRp");
				if((diffQty!=0)||(diffAmtRp!=0)){
					return 'my_row_Yellow';
				}
			}
		}),
		cm:new Ext.grid.ColumnModel([new Ext.grid.RowNumberer({width:30}),  {
			header : '物资代码',
			dataIndex : 'incicode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '物资名称',
			dataIndex : 'incidesc',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : '规格',
			dataIndex : 'spec',
			width : 80,
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
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "本期结存数量",
			dataIndex : 'qty',
			summaryType : 'sum',
			width : 90,
			align : 'right',
			sortable : true
		}, {
			header : "本期结存金额",
			dataIndex : 'coamt',
			summaryType : 'sum',
			width : 100,
			align : 'right',
			sortable : true
		},{
			header:'上期结存数量',
			dataIndex:'lastqty',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'上期结存金额',
			dataIndex:'lastcoamt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'入库数量',
			dataIndex:'recqty',
			width:100,
			align:'right',
			sortable:'true'
		//	useRenderExport : false,
		//	renderer:renderRecQty
		},{
			header:'入库金额',
			dataIndex:'reccoamt',
			summaryType : 'sum',
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
			summaryType : 'sum',
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
			summaryType : 'sum',
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
			summaryType : 'sum',
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
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'盘点调整数量',
			dataIndex:'stkqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'盘点调整金额',
			dataIndex:'stkcoamt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'报损数量',
			dataIndex:'conqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'报损金额',
			dataIndex:'concoamt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'调价损益',
			dataIndex:'aspcoamt',
			summaryType : 'sum',
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
			'manuXAmt','manuMAmt','phoRetAspAmt','trfIAspAmt','InAmt','OutAmt'
		]
	});

	var DetailGridSCG = new Ext.ux.GridPanel({
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
			header : '退货调价损益',
			dataIndex : 'RetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '住院退药调价损益',
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
		}, {
			header : '制剂入库金额',
			dataIndex : 'mRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
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
			header : '门诊退药调价损益金额',
			dataIndex : 'phoRetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '转移入库调价损益金额',
			dataIndex : 'trfIAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '转入',
			dataIndex : 'InAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '转出',
			dataIndex : 'OutAmt',
			width : 100,
			align : 'right',
			sortable : true
		}])
	});

	var DetailGridSCGRp = new Ext.ux.GridPanel({
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
			header : '退货调价损益',
			dataIndex : 'RetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '住院退药调价损益',
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
		}, {
			header : '制剂入库金额',
			dataIndex : 'mRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
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
			header : '门诊退药调价损益金额',
			dataIndex : 'phoRetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '转移入库调价损益金额',
			dataIndex : 'trfIAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '转入',
			dataIndex : 'InAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '转出',
			dataIndex : 'OutAmt',
			width : 100,
			align : 'right',
			sortable : true
		}])
	});

	var MainStore=new Ext.data.JsonStore({
		auroDestroy:true,
		url:Url+"actiontype=Query",
		sotreId:'MainStore',
		root:'rows',
		totalProperty:'results',
		idProperty:'smRowid',
		fields:['smRowid','locDesc','mon','frDate','frTime','toDate','toTime',
				'StkMonNo','AcctVoucherCode','AcctVoucherDate','AcctVoucherStatus','PdfFile']
	});

	var MainSm = new Ext.grid.CheckboxSelectionModel({
		singleSelect : false,
		checkOnly : true
	});
	var MainGrid = new Ext.ux.GridPanel({
		id:'MainGrid',
		title:'月报',
		region:'west',
		width:220,
		store:MainStore,
		cm:new Ext.grid.ColumnModel([
		MainSm,
		{
			header:'Rowid',
			dataIndex:'smRowid',
			width:100,
			align:'left',
			hidden:true
		},{
			header:'科室',
			dataIndex:'locDesc',
			width:120,
			align:'left',
			sortable:true
		},{
			header:'月份',
			dataIndex:'mon',
			width:100,
			align:'left',
			sortable:true
		},{
			header:'月报起始日期',
			dataIndex:'frDate',
			width:100,
			align:'left',
			sortable:true,
			renderer:function(value,metaData,record,rowIndex,colIndex,store){
				var StDateTime=value+" "+record.get('frTime');
				return StDateTime;
			}
		},{
			header:'月报截止日期',
			dataIndex:'toDate',
			width:100,
			align:'left',
			sortable:true,
			renderer:function(value,metaData,record,rowIndex,colIndex,store){
				var EdDateTime=value+" "+record.get('toTime');
				return EdDateTime;
			}
		},{
			header:'月报号',
			dataIndex:'StkMonNo',
			width:140,
			align:'left',
			sortable:true
		},{
			header:'凭证号',
			dataIndex:'AcctVoucherCode',
			width:120,
			align:'left',
			sortable:true
		},{
			header:'凭证日期',
			dataIndex:'AcctVoucherDate',
			width:100,
			align:'left',
			sortable:true
		},{
			header:'凭证处理状态',
			dataIndex:'AcctVoucherStatus',
			width:80,
			align:'left',
			sortable:true
		},{
			header:'Pdf文件名称',
			dataIndex:'PdfFile',
			width:100,
			align:'left',
			sortable:true
		}]),
		sm: MainSm,
		autoScroll:true
	})

	MainGrid.addListener('rowclick',function(grid,rowindex,e){
		tabPanel.fireEvent('tabchange',tabPanel,tabPanel.getActiveTab());
	});

	 // 提交
	var Submit = new Ext.ux.Button({
				id : "Submit",
				text : '凭证数据提交',
				tooltip : '点击提交',
				iconCls : 'page_gear',
				handler : function() {
					var gridSelected =Ext.getCmp("MainGrid");
					var rows=MainGrid.getSelectionModel().getSelections() ;
					if(rows.length==0){
						Ext.Msg.show({title:'错误',msg:'请选择要提交的月报！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}else
					{
						var selectedRow = rows[0];
						var smRowid = selectedRow.get("smRowid");

						Ext.Ajax.request({
							url:DictUrl+'stkmonaction.csp?actiontype=Submit&smRowid='+smRowid+'&UserId='+gUserId,
							waitMsg:'更新中...',
							failure: function(result, request) {
								Msg.info("error", "请检查网络连接!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success", "提交成功!");
									Query();
								}else{
									if(jsonData.info==-1)
									{
										Msg.info('warning','当前状态不允许提交!');
									}
									else
									{
										Msg.info("error", "提交失败!");
									}
								}
							},
							scope: this
						});
					}
				}
			});
	// 取消提交
	var CancelSubmit = new Ext.ux.Button({
				id : "CancelSubmit",
				text : '取消提交',
				tooltip : '点击取消提交',
				iconCls : 'page_gear',
				handler : function() {
					var gridSelected =Ext.getCmp("MainGrid");
					var rows=MainGrid.getSelectionModel().getSelections() ;
					if(rows.length==0){
						Ext.Msg.show({title:'错误',msg:'请选择要取消提交的月报！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}else
					{
						var selectedRow = rows[0];
						var smRowid = selectedRow.get("smRowid");

						Ext.Ajax.request({
							url:DictUrl+'stkmonaction.csp?actiontype=CancelSubmit&smRowid='+smRowid+'&UserId='+gUserId,
							waitMsg:'更新中...',
							failure: function(result, request) {
								Msg.info("error", "请检查网络连接!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success", "取消成功!");
									Query();
								}else{
									if(jsonData.info==-1)
									{
										Msg.info('warning','当前状态不允许取消提交!');
									}
									else
									{
										Msg.info("error", "取消失败!");
									}
								}
							},
							scope: this
						});
					}
				}
			});
	var mainForm = new Ext.ux.FormPanel({
		title:'月报明细查询',
		tbar : [SearchBT,'-',printBT,'-',Submit,'-',CancelSubmit],
		region:'north',
		items:[{
			layout:'column',
			xtype: 'fieldset',
			title:'查询条件',
			style:'padding:0px 20px 0px 0px',
			defaults: {border:false},
			items:[{
				columnWidth: 0.3,
				xtype: 'fieldset',
				items: [PhaLoc]
			},{
				columnWidth: 0.5,
				xtype: 'compositefield',
				items : [
							{ xtype: 'displayfield', value: '月报范围：'},
							StYear,
							{ xtype: 'displayfield', value: '年'},
							StMonth,
							{ xtype: 'displayfield', value: '月   -----'},
							EdYear,
							{ xtype: 'displayfield', value: '年'},
							EdMonth,
							{xtype:'displayfield',value:'月'}
						]
			},{
				columnWidth: 0.2,
				xtype: 'fieldset',
				items: [FinancialFlag]
			}]
		}]
	});

	var DetailSCGRp = new Ext.Panel({
		html:'<iframe id="frameDetailSCGRp" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	});
	var DetailSCGSp = new Ext.Panel({
		html:'<iframe id="frameDetailSCGSp" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	});
	var InIsRpPanel=new Ext.Panel({
		html:'<iframe id="frameReport" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	});
	var InIsRpLocCatPanel = new Ext.Panel({
		html:'<iframe id="frameReportInIsRpLocCat" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	});
	var StkCatRp = new Ext.Panel({
		html:'<iframe id="frameStkCatRp" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	});
	var MulScgRp = new Ext.Panel({
		html:'<iframe id="frameMulScgRp" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	});
	var ImportVendorSum = new Ext.Panel({
		html:'<iframe id="frameImportVendorSum" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	});
	var tabPanel=new Ext.TabPanel({
		region:'center',
		activeTab:0,
		enableTabScroll : true,
		tbar:new Ext.Toolbar({items:[StkGrpType,IncStkCat,IncDesc,Filter,'<font color=blue>&nbsp;&nbsp仅对明细进行筛选</font>']}),
		items:[
		/* 该报表和"业报出库汇总(交叉报表)"内容有些重复
		{
			title:'月报转移汇总',
			id:'ReportDetailInIsRp',
			layout:'fit',
			items:[InIsRpPanel]
		},
		*/
		{
			title:'月报出库汇总(交叉报表)',
			id:'ReportInIsRpLocCatCross',
			layout:'fit',
			items:[InIsRpLocCatPanel]
		},{
			title:'月报入库汇总(供应商)',
			id:'ReportImportVendorSum',
			layout:'fit',
			items:[ImportVendorSum]
		},{
			title:'类组汇总(进价)',
			id:'ReportDetailSCGRp',
			layout:'fit',
			items:[DetailSCGRp]
//			items:[DetailGridSCGRp]
		},{
			title:'类组汇总(售价)',
			id:'ReportDetailSCG',
			layout:'fit',
			hidden : true,
			items:[DetailSCGSp]
//			items:[DetailGridSCG]
		},{
			title:'多级类组',
			id:'ReportMulSCG',
			layout:'fit',
			items:[MulScgRp]
		},{
			title:'库存分类汇总',
			id:'ReportStkCatRp',
			layout:'fit',
			items:[StkCatRp]
		},{
			title:'月报明细(售价)',
			id:'ReportDetailSp',
			layout:'fit',
			items:[DetailGrid]
		},{
			title:'月报明细(进价)',
			id:'ReportDetailRp',
			layout:'fit',
			items:[DetailGridRp]
		},{
			title:'月报明细批次(售价)',
			id:'ReportDetailLbSp',
			layout:'fit',
			items:[DetailGridLB]
		},{
			title:'月报明细批次(进价)',
			id:'ReportDetailLbRp',
			layout:'fit',
			items:[DetailGridLBRp]
		}]
	});

	tabPanel.addListener('tabchange',function(tabpanel,panel){
		var record=MainGrid.getSelectionModel().getSelected();
		
		var Sels = MainGrid.getSelectionModel().getSelections();
		if(Ext.isEmpty(Sels)){
			return;
		}
		var record = Sels[Sels.length - 1];		//取最后勾选的行
		var rowid = '';
		for(var i = 0, Len = Sels.length; i < Len; i++){
			var SMRowId = Sels[i].get('smRowid');
			if(rowid == ''){
				rowid = SMRowId;
			}else{
				rowid = rowid + '^' + SMRowId;
			}
		}
		growid=rowid;
			
			
			//其他变量按最后一行取值
			var LastSMRowId = record.get('smRowid');
			var StkMonth = record.get("mon");
			var stkgrpid=Ext.getCmp("StkGrpType").getValue();
			var stkcatid=Ext.getCmp("IncStkCat").getValue();
			var incdesc=Ext.getCmp("IncDesc").getValue();
			activeTabtmp=panel;
			var mainData=GetMainData(LastSMRowId);
			var mainArr=mainData.split("^");
			var LocId=mainArr[2];
			var month=mainArr[10];
			var LocDesc=mainArr[11];
			var fromdate=mainArr[12];
			var todate=mainArr[13];
			var createdate=mainArr[14];
			var createUser=mainArr[15];
			var fromTime=mainArr[16];
			var toTime=mainArr[17];
			var createTime=mainArr[18];
			var startDate=toDate(fromdate).format(ARG_DATEFORMAT);
			var endDate=toDate(todate).format(ARG_DATEFORMAT);
			if(panel.id=="ReportDetailSp"){
				var StrParam = SCGTYPE;
				DetailStore.removeAll();
				DetailStore.load({params:{Parref:LastSMRowId,StkGrpId:stkgrpid,StkCatId:stkcatid,IncDesc:incdesc,StrParam:StrParam}});
			}else if(panel.id=="ReportDetailRp"){
				var StrParam = SCGTYPE;
				DetailStoreRp.removeAll();
				DetailStoreRp.load({params:{Parref:LastSMRowId,StkGrpId:stkgrpid,StkCatId:stkcatid,IncDesc:incdesc,StrParam:StrParam}});
			}else if(panel.id=="ReportDetailLbRp"){
				var SourceOfFund = '';	//资金来源 暂时置空
				var StrParam = SourceOfFund + '^' + SCGTYPE;
				DetailStoreLBRp.removeAll();
				DetailStoreLBRp.load({params:{Parref:LastSMRowId,StkGrpId:stkgrpid,StkCatId:stkcatid,IncDesc:incdesc,StrParam:StrParam}});
			}else if(panel.id=="ReportDetailLbSp"){
				var SourceOfFund = '';	//资金来源 暂时置空
				var StrParam = SourceOfFund + '^' + SCGTYPE;
				DetailStoreLB.removeAll();
				DetailStoreLB.load({params:{Parref:rowid,StkGrpId:stkgrpid,StkCatId:stkcatid,IncDesc:incdesc,StrParam:StrParam}});
			}else if(panel.id=="ReportDetailSCGRp"){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCSTM_ReportDetailSCGRp_Common.raq'
					+"&growid="+growid+"&Type="+0;
				var reportFrame=document.getElementById("frameDetailSCGRp");
				reportFrame.src=p_URL;
			}else if(panel.id=="ReportDetailSCG"){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCSTM_ReportDetailSCGRp_Common.raq'
					+"&growid="+growid+"&Type="+1;
				var reportFrame=document.getElementById("frameDetailSCGSp");
				reportFrame.src=p_URL;
			}else if(panel.id=="ReportDetailInIsRp"){
				var OthersArr=[];
				OthersArr[0]=stkgrpid,
				OthersArr[23]=fromTime,OthersArr[24]=toTime;
				var Others=OthersArr.join("^");
				var TransferFlag=0;
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_ReportInIsStatRp.raq'
					+"&growid="+growid
					+"&StartDate="+startDate+"&EndDate="+endDate+"&LocId="+LocId+"&TransferFlag="+TransferFlag+"&Others="+Others
					+"&LocDesc="+LocDesc+"&fromdate="+fromdate+"&todate="+todate
					+"&HospDesc="+App_LogonHospDesc+"&createdate="+createdate+"&createUser="+createUser+"&fromTime="+fromTime+"&toTime="+toTime+"&createTime="+createTime;
				var reportFrame=document.getElementById("frameReport");
				reportFrame.src=p_URL;
			}else if(panel.id=="ReportStkCatRp"){
				//库存分类汇总
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_ReportStkCatRp.raq'
					+"&growid="+growid+"&Type="+0+"&ScgType="+SCGTYPE
					+"&LocDesc="+LocDesc+"&fromdate="+fromdate+"&todate="+todate+"&createdate="+createdate
					+"&createUser="+createUser+"&fromTime="+fromTime+"&toTime="+toTime+"&createTime="+createTime
					+"&HospDesc="+App_LogonHospDesc+"&StkGrpId="+stkgrpid;
				var reportFrame=document.getElementById("frameStkCatRp");
				reportFrame.src=p_URL;
			}else if(panel.id=="ReportInIsRpLocCatCross"){
				//科室库存分类交叉汇总(出库汇总)
				var StrParam = SCGTYPE;		//再加的参数,用^拼起来
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_ReportInIsRpLocCatCross.raq'
					+"&growid="+growid+"&StrParam="+StrParam;
				var reportFrame=document.getElementById("frameReportInIsRpLocCat");
				reportFrame.src=p_URL;
			}else if(panel.id == 'ReportMulSCG'){
				var Type = 0;	//进价
				var ParamStr =stkgrpid+"^"+stkcatid+"^"+incdesc+"^"+SCGTYPE+"^"+Type;
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_ReportMulScg.raq'
					+"&growid="+growid+"&ParamStr="+ParamStr;
				var reportFrame=document.getElementById("frameMulScgRp");
				reportFrame.src=p_URL;
			}else if(panel.id == 'ReportImportVendorSum'){
				var Type = 0;	//进价
				var ParamStr =stkgrpid+"^"+stkcatid+"^"+incdesc+"^"+SCGTYPE+"^"+Type;
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_ReportImportVendorSum.raq'
					+"&growid="+growid+"&ParamStr="+ParamStr;
				var reportFrame=document.getElementById("frameImportVendorSum");
				reportFrame.src=p_URL;
			}
	});

	Ext.onReady(function() {
		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		var myPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [mainForm,MainGrid,tabPanel]
		});
		Query();
	});
