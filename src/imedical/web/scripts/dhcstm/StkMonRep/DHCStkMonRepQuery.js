// /����: �±���ϸ��ѯ
// /����: �±���ϸ��ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.11.23

	//��ѡ��������ؼ�ʱ,�����޸Ĵ�ȫ�ֱ���
	var SCGTYPE = 'M';		//��������(��������M,��������O)

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
		fieldLabel : '����',
		listWidth : 200,
		groupId:gGroupId,
		stkGrpId : 'StkGrpType'
	});

	var StYear=new Ext.form.TextField({
		fieldLabel:'�·�',
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
		boxLabel : '��������',
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

	// ��������
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
		emptyText:'������',
		params:{StkGrpId:'StkGrpType'}
	});

	var IncDesc=new Ext.form.TextField({
		id:'IncDesc',
		name:'IncDesc',
		emptyText:'��������',
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
		text:'ɸѡ',
		iconCls : 'page_find',
		anchor:'90%',
		handler:function(){
			tabPanel.fireEvent('tabchange',tabPanel,tabPanel.getActiveTab());
		}
	});

	/**
	 * ���ط���
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
	// ��ѯ��ť
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : '��ѯ',
				tooltip : '�����ѯ',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					Query();
				}
			});
	// ��ӡ�±���ϸ
	var printBT = new Ext.Toolbar.Button({
		id : "printBT",
		text : '��ӡ',
		tooltip : '��ӡ�±���ϸ',
		width : 70,
		height : 30,
		iconCls : 'page_print',
		handler : function() {
			PrintStkMon(growid,activeTabtmp);
		}
	});

	//��ѯ�±�
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
		var DateFlag=1;  //���������ͳ��
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
			header : '���ʴ���',
			dataIndex : 'inciCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '��������',
			dataIndex : 'inciDesc',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : '���',
			dataIndex : 'spec',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "��λ",
			dataIndex : 'uomDesc',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "���ڽ������",
			dataIndex : 'qty',
			summaryType : 'sum',
			width : 90,
			align : 'right',
			sortable : true
		}, {
			header : "���ڽ����",
			dataIndex : 'amt',
			summaryType : 'sum',
			width : 100,
			align : 'right',
			sortable : true
		},{
			header:'���ڽ������',
			dataIndex:'lastQty',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'���ڽ����',
			dataIndex:'lastAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�������',
			dataIndex:'recQty',
			width:100,
			align:'right',
			sortable:'true'
		//	useRenderExport : false,
		//	renderer:renderRecQty
		},{
			header:'�����',
			dataIndex:'recAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�˻�����',
			dataIndex:'retQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�˻����',
			dataIndex:'retAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת������',
			dataIndex:'trOutQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת�����',
			dataIndex:'trOutAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת������',
			dataIndex:'trInQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת����',
			dataIndex:'trInAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��������',
			dataIndex:'adjQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�������',
			dataIndex:'adjAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��������',
			dataIndex:'csmQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'���Ľ��',
			dataIndex:'csmAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��������',
			dataIndex:'disposeQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'������',
			dataIndex:'disposeAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��������',
			dataIndex:'aspAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��Ʒ�������',
			dataIndex:'giftRecQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��Ʒ�����',
			dataIndex:'giftRecAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��Ʒ��������',
			dataIndex:'giftTrOutQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��Ʒ������',
			dataIndex:'giftTrOutAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'���ۻ�Ʊ�������',
			dataIndex:'chgRecQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'���ۻ�Ʊ�����',
			dataIndex:'chgRecAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'���ۻ�Ʊ�˻�����',
			dataIndex:'chgRetQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'���ۻ�Ʊ�˻����',
			dataIndex:'chgRetAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�˻�����(����)',
			dataIndex:'retAspAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת������(����)',
			dataIndex:'trInAspAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},
		/*{
			header:'�Ƽ��������',
			dataIndex:'mRecQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�Ƽ������',
			dataIndex:'mRecAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},*/
		{
			header:'�̵��������',
			dataIndex:'stktkAdjQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�̵�������',
			dataIndex:'stktkAdjAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},
		/*{
			header:'�Ƽ���������',
			dataIndex:'manuXQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�Ƽ����Ľ��',
			dataIndex:'manuXAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�Ƽ���������',
			dataIndex:'manuMQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�Ƽ����ɽ��',
			dataIndex:'manuMAmt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},*/
		{
			header:'��������',
			dataIndex:'diffQty',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'������',
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

	//�ϲ�DetailGridLB����ͬ��������Ϣ
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
			header : '���ʴ���',
			dataIndex : 'incicode',
			width : 80,
			align : 'left',
			sortable : true/*,
			renderer:cellMerge*/
		}, {
			header : '��������',
			dataIndex : 'incidesc',
			width : 100,
			align : 'left',
			sortable : true/*,
			renderer:cellMerge*/
		}, {
			header : '���',
			dataIndex : 'spec',
			width : 80,
			align : 'left',
			sortable : true/*,
			renderer:cellMerge*/
		},{
			header : "��λ",
			dataIndex : 'puomdesc',
			width : 80,
			align : 'left',
			sortable : true/*,
			renderer:cellMerge*/
		}, {
			header:'����',
			dataIndex : 'manf',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "����",
			dataIndex : 'IBNO',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "���ڽ������",
			dataIndex : 'qty',
			summaryType : 'sum',
			width : 90,
			align : 'right',
			sortable : true
		}, {
			header : "���ڽ����",
			dataIndex : 'amt',
			summaryType : 'sum',
			width : 100,
			align : 'right',
			sortable : true
		},{
			header:'���ڽ������',
			dataIndex:'lastqty',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'���ڽ����',
			dataIndex:'lastamt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�������',
			dataIndex:'recqty',
			width:100,
			align:'right',
			sortable:'true'
		//	useRenderExport : false,
		//	renderer:renderRecQty
		},{
			header:'�����',
			dataIndex:'recamt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�˻�����',
			dataIndex:'retqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�˻����',
			dataIndex:'retamt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת������',
			dataIndex:'trfoqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת�����',
			dataIndex:'trfoamt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת������',
			dataIndex:'trfiqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת����',
			dataIndex:'trfiamt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��������',
			dataIndex:'adjqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�������',
			dataIndex:'adjamt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�̵��������',
			dataIndex:'stkqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�̵�������',
			dataIndex:'stkamt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��������',
			dataIndex:'conqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'������',
			dataIndex:'conamt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��������',
			dataIndex:'aspamt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��������',
			dataIndex:'diffQty',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'������',
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
			header : '���ʴ���',
			dataIndex : 'incicode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '��������',
			dataIndex : 'incidesc',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : '���',
			dataIndex : 'spec',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header:'����',
			dataIndex : 'manf',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "��λ",
			dataIndex : 'puomdesc',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "����",
			dataIndex : 'IBNO',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "���ڽ������",
			dataIndex : 'qty',
			summaryType : 'sum',
			width : 90,
			align : 'right',
			sortable : true
		}, {
			header : "���ڽ����",
			dataIndex : 'coamt',
			summaryType : 'sum',
			width : 100,
			align : 'right',
			sortable : true
		},{
			header:'���ڽ������',
			dataIndex:'lastqty',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'���ڽ����',
			dataIndex:'lastcoamt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�������',
			dataIndex:'recqty',
			width:100,
			align:'right',
			sortable:'true'
		//	useRenderExport : false,
		//	renderer:renderRecQty
		},{
			header:'�����',
			dataIndex:'reccoamt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�˻�����',
			dataIndex:'retqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�˻����',
			dataIndex:'retcoamt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת������',
			dataIndex:'trfoqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת�����',
			dataIndex:'trfocoamt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת������',
			dataIndex:'trfiqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת����',
			dataIndex:'trficoamt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��������',
			dataIndex:'adjqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�������',
			dataIndex:'adjcoamt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�̵��������',
			dataIndex:'stkqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�̵�������',
			dataIndex:'stkcoamt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��������',
			dataIndex:'conqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'������',
			dataIndex:'concoamt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��������',
			dataIndex:'aspcoamt',
			summaryType : 'sum',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��������',
			dataIndex:'diffQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'������',
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
			header : '����',
			dataIndex : 'grpDesc',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '���ڽ����',
			dataIndex : 'LastAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���ڽ����',
			dataIndex : 'Amt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�����',
			dataIndex : 'RecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�˻����',
			dataIndex : 'RetAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'ת�����',
			dataIndex : 'TroAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'ת����',
			dataIndex : 'TriAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�������',
			dataIndex : 'AdjAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���Ľ��',
			dataIndex : 'ConAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '������',
			dataIndex : 'DisAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '��ҩ���',
			dataIndex : 'DspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '����������',
			dataIndex : 'AspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '������ҩ���',
			dataIndex : 'PhaRetAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�˻���������',
			dataIndex : 'RetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'סԺ��ҩ��������',
			dataIndex : 'PhaRetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '��Ʒ�����',
			dataIndex : 'GiftRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '��Ʒ������',
			dataIndex : 'giftTrfAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���ۻ�Ʊ�����',
			dataIndex : 'chgRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���ۻ�Ʊ�˻����',
			dataIndex : 'chgRetAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�Ƽ������',
			dataIndex : 'mRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�̵�������',
			dataIndex : 'stktkAdjAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�Ƽ����Ľ��',
			dataIndex : 'manuXAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�Ƽ����ɽ��',
			dataIndex : 'manuMAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '������ҩ����������',
			dataIndex : 'phoRetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'ת��������������',
			dataIndex : 'trfIAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'ת��',
			dataIndex : 'InAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'ת��',
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
			header : '����',
			dataIndex : 'grpDesc',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '���ڽ����',
			dataIndex : 'LastAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���ڽ����',
			dataIndex : 'Amt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�����',
			dataIndex : 'RecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�˻����',
			dataIndex : 'RetAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'ת�����',
			dataIndex : 'TroAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'ת����',
			dataIndex : 'TriAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�������',
			dataIndex : 'AdjAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���Ľ��',
			dataIndex : 'ConAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '������',
			dataIndex : 'DisAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '��ҩ���',
			dataIndex : 'DspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '����������',
			dataIndex : 'AspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '������ҩ���',
			dataIndex : 'PhaRetAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�˻���������',
			dataIndex : 'RetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'סԺ��ҩ��������',
			dataIndex : 'PhaRetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '��Ʒ�����',
			dataIndex : 'GiftRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '��Ʒ������',
			dataIndex : 'giftTrfAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���ۻ�Ʊ�����',
			dataIndex : 'chgRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���ۻ�Ʊ�˻����',
			dataIndex : 'chgRetAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�Ƽ������',
			dataIndex : 'mRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�̵�������',
			dataIndex : 'stktkAdjAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�Ƽ����Ľ��',
			dataIndex : 'manuXAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�Ƽ����ɽ��',
			dataIndex : 'manuMAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '������ҩ����������',
			dataIndex : 'phoRetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'ת��������������',
			dataIndex : 'trfIAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'ת��',
			dataIndex : 'InAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'ת��',
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
		title:'�±�',
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
			header:'����',
			dataIndex:'locDesc',
			width:120,
			align:'left',
			sortable:true
		},{
			header:'�·�',
			dataIndex:'mon',
			width:100,
			align:'left',
			sortable:true
		},{
			header:'�±���ʼ����',
			dataIndex:'frDate',
			width:100,
			align:'left',
			sortable:true,
			renderer:function(value,metaData,record,rowIndex,colIndex,store){
				var StDateTime=value+" "+record.get('frTime');
				return StDateTime;
			}
		},{
			header:'�±���ֹ����',
			dataIndex:'toDate',
			width:100,
			align:'left',
			sortable:true,
			renderer:function(value,metaData,record,rowIndex,colIndex,store){
				var EdDateTime=value+" "+record.get('toTime');
				return EdDateTime;
			}
		},{
			header:'�±���',
			dataIndex:'StkMonNo',
			width:140,
			align:'left',
			sortable:true
		},{
			header:'ƾ֤��',
			dataIndex:'AcctVoucherCode',
			width:120,
			align:'left',
			sortable:true
		},{
			header:'ƾ֤����',
			dataIndex:'AcctVoucherDate',
			width:100,
			align:'left',
			sortable:true
		},{
			header:'ƾ֤����״̬',
			dataIndex:'AcctVoucherStatus',
			width:80,
			align:'left',
			sortable:true
		},{
			header:'Pdf�ļ�����',
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

	 // �ύ
	var Submit = new Ext.ux.Button({
				id : "Submit",
				text : 'ƾ֤�����ύ',
				tooltip : '����ύ',
				iconCls : 'page_gear',
				handler : function() {
					var gridSelected =Ext.getCmp("MainGrid");
					var rows=MainGrid.getSelectionModel().getSelections() ;
					if(rows.length==0){
						Ext.Msg.show({title:'����',msg:'��ѡ��Ҫ�ύ���±���',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}else
					{
						var selectedRow = rows[0];
						var smRowid = selectedRow.get("smRowid");

						Ext.Ajax.request({
							url:DictUrl+'stkmonaction.csp?actiontype=Submit&smRowid='+smRowid+'&UserId='+gUserId,
							waitMsg:'������...',
							failure: function(result, request) {
								Msg.info("error", "������������!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success", "�ύ�ɹ�!");
									Query();
								}else{
									if(jsonData.info==-1)
									{
										Msg.info('warning','��ǰ״̬�������ύ!');
									}
									else
									{
										Msg.info("error", "�ύʧ��!");
									}
								}
							},
							scope: this
						});
					}
				}
			});
	// ȡ���ύ
	var CancelSubmit = new Ext.ux.Button({
				id : "CancelSubmit",
				text : 'ȡ���ύ',
				tooltip : '���ȡ���ύ',
				iconCls : 'page_gear',
				handler : function() {
					var gridSelected =Ext.getCmp("MainGrid");
					var rows=MainGrid.getSelectionModel().getSelections() ;
					if(rows.length==0){
						Ext.Msg.show({title:'����',msg:'��ѡ��Ҫȡ���ύ���±���',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}else
					{
						var selectedRow = rows[0];
						var smRowid = selectedRow.get("smRowid");

						Ext.Ajax.request({
							url:DictUrl+'stkmonaction.csp?actiontype=CancelSubmit&smRowid='+smRowid+'&UserId='+gUserId,
							waitMsg:'������...',
							failure: function(result, request) {
								Msg.info("error", "������������!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success", "ȡ���ɹ�!");
									Query();
								}else{
									if(jsonData.info==-1)
									{
										Msg.info('warning','��ǰ״̬������ȡ���ύ!');
									}
									else
									{
										Msg.info("error", "ȡ��ʧ��!");
									}
								}
							},
							scope: this
						});
					}
				}
			});
	var mainForm = new Ext.ux.FormPanel({
		title:'�±���ϸ��ѯ',
		tbar : [SearchBT,'-',printBT,'-',Submit,'-',CancelSubmit],
		region:'north',
		items:[{
			layout:'column',
			xtype: 'fieldset',
			title:'��ѯ����',
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
							{ xtype: 'displayfield', value: '�±���Χ��'},
							StYear,
							{ xtype: 'displayfield', value: '��'},
							StMonth,
							{ xtype: 'displayfield', value: '��   -----'},
							EdYear,
							{ xtype: 'displayfield', value: '��'},
							EdMonth,
							{xtype:'displayfield',value:'��'}
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
		tbar:new Ext.Toolbar({items:[StkGrpType,IncStkCat,IncDesc,Filter,'<font color=blue>&nbsp;&nbsp������ϸ����ɸѡ</font>']}),
		items:[
		/* �ñ����"ҵ���������(���汨��)"������Щ�ظ�
		{
			title:'�±�ת�ƻ���',
			id:'ReportDetailInIsRp',
			layout:'fit',
			items:[InIsRpPanel]
		},
		*/
		{
			title:'�±��������(���汨��)',
			id:'ReportInIsRpLocCatCross',
			layout:'fit',
			items:[InIsRpLocCatPanel]
		},{
			title:'�±�������(��Ӧ��)',
			id:'ReportImportVendorSum',
			layout:'fit',
			items:[ImportVendorSum]
		},{
			title:'�������(����)',
			id:'ReportDetailSCGRp',
			layout:'fit',
			items:[DetailSCGRp]
//			items:[DetailGridSCGRp]
		},{
			title:'�������(�ۼ�)',
			id:'ReportDetailSCG',
			layout:'fit',
			hidden : true,
			items:[DetailSCGSp]
//			items:[DetailGridSCG]
		},{
			title:'�༶����',
			id:'ReportMulSCG',
			layout:'fit',
			items:[MulScgRp]
		},{
			title:'���������',
			id:'ReportStkCatRp',
			layout:'fit',
			items:[StkCatRp]
		},{
			title:'�±���ϸ(�ۼ�)',
			id:'ReportDetailSp',
			layout:'fit',
			items:[DetailGrid]
		},{
			title:'�±���ϸ(����)',
			id:'ReportDetailRp',
			layout:'fit',
			items:[DetailGridRp]
		},{
			title:'�±���ϸ����(�ۼ�)',
			id:'ReportDetailLbSp',
			layout:'fit',
			items:[DetailGridLB]
		},{
			title:'�±���ϸ����(����)',
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
		var record = Sels[Sels.length - 1];		//ȡ���ѡ����
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
			
			
			//�������������һ��ȡֵ
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
				var SourceOfFund = '';	//�ʽ���Դ ��ʱ�ÿ�
				var StrParam = SourceOfFund + '^' + SCGTYPE;
				DetailStoreLBRp.removeAll();
				DetailStoreLBRp.load({params:{Parref:LastSMRowId,StkGrpId:stkgrpid,StkCatId:stkcatid,IncDesc:incdesc,StrParam:StrParam}});
			}else if(panel.id=="ReportDetailLbSp"){
				var SourceOfFund = '';	//�ʽ���Դ ��ʱ�ÿ�
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
				//���������
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_ReportStkCatRp.raq'
					+"&growid="+growid+"&Type="+0+"&ScgType="+SCGTYPE
					+"&LocDesc="+LocDesc+"&fromdate="+fromdate+"&todate="+todate+"&createdate="+createdate
					+"&createUser="+createUser+"&fromTime="+fromTime+"&toTime="+toTime+"&createTime="+createTime
					+"&HospDesc="+App_LogonHospDesc+"&StkGrpId="+stkgrpid;
				var reportFrame=document.getElementById("frameStkCatRp");
				reportFrame.src=p_URL;
			}else if(panel.id=="ReportInIsRpLocCatCross"){
				//���ҿ����ཻ�����(�������)
				var StrParam = SCGTYPE;		//�ټӵĲ���,��^ƴ����
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_ReportInIsRpLocCatCross.raq'
					+"&growid="+growid+"&StrParam="+StrParam;
				var reportFrame=document.getElementById("frameReportInIsRpLocCat");
				reportFrame.src=p_URL;
			}else if(panel.id == 'ReportMulSCG'){
				var Type = 0;	//����
				var ParamStr =stkgrpid+"^"+stkcatid+"^"+incdesc+"^"+SCGTYPE+"^"+Type;
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_ReportMulScg.raq'
					+"&growid="+growid+"&ParamStr="+ParamStr;
				var reportFrame=document.getElementById("frameMulScgRp");
				reportFrame.src=p_URL;
			}else if(panel.id == 'ReportImportVendorSum'){
				var Type = 0;	//����
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
