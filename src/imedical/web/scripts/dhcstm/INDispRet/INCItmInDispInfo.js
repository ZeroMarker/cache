// /名称: 选物资及相应批次窗口
// /描述: 选物资及相应批次

/**
 Input:物资别名录入值
 StkGrpRowId：类组id
 StkGrpType：类组类型，G：物资
 Locdr:科室id
 NotUseFlag：不可用标志
 QtyFlag：是否包含0库存项目
 HospID：医院id
 ReqLoc:请求科室id(请求科室id为空时，请求科室库存显示为空)
 Fn：回调函数
 RetLoc: 退回单接收科室(即物资的原发放科室)
 */
InDispItmBat =function(Input, StkGrpRowId, StkGrpType, Locdr, NotUseFlag,QtyFlag, HospID,Fn, RetLoc) {

	var RetURL = 'dhcstm.indispretaction.csp';
	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	if(RetLoc==''){
		RetLoc = tkMakeServerCall("web.DHCSTM.Common.UtilCommon","GetLeadLoc",Locdr);
	}
	/*物资窗口------------------------------*/
	var PhaOrderUrl = 'dhcstm.drugutil.csp?actiontype=GetPhaOrderItemForDialog&Input='
			+ Input + '&StkGrpRowId=' + StkGrpRowId + '&StkGrpType='
			+ StkGrpType + '&Locdr=' + RetLoc + '&NotUseFlag=' + NotUseFlag
			+ '&QtyFlag=' + QtyFlag + '&HospID=' + HospID + '&start=' + 0
			+ '&limit=' + 15;

	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : PhaOrderUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["InciDr", "InciItem", "InciCode", "InciDesc", "Spec",
			"ManfName", "PuomDesc", "pRp", "pSp", "PuomQty", "BuomDesc", "bRp",
			"bSp", "BuomQty", "BillUomDesc", "BillSp", "BillRp", "BillUomQty",
			{name:'NotUseFlag',type: 'bool'}, "PuomDr",
			"PFac", "Manfdr", "MaxQty", "MinQty", "StockQty", "Remark", "Brand", "Model", "Abbrev"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "InciItem",
		fields : fields
	});
	// 数据集
	var PhaOrderStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader
	});
	
	var StatuTabPagingToolbar = new Ext.PagingToolbar({
		store : PhaOrderStore,
		pageSize : 15,
		displayInfo : true
	});

	var nm = new Ext.grid.RowNumberer();
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect:true,
				listeners:{
					'rowselect':function(selmod,rowindex,record){
						queryInDispItm();
					},
					'rowdeselect':function(sm,rowIndex,record){
						InDispItmStore.removeAll();
					}
				}
			});
	
	var ColumnNotUseFlag = new Ext.grid.CheckColumn({
   		header: '不可用',
   		dataIndex: 'NotUseFlag',
   		width: 45,
   		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	});
	var PhaOrderCm = new Ext.grid.ColumnModel([nm, sm, {
				header : "代码",
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '名称',
				dataIndex : 'InciDesc',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : "简称",
				dataIndex : 'Abbrev',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "品牌",
				dataIndex : '',
				width : 100,
				align : 'Brand',
				sortable : true
			}, {
				header : "型号",
				dataIndex : 'Model',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "规格",
				dataIndex : 'Spec',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "厂商",
				dataIndex : 'ManfName',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : '发放单位',
				dataIndex : 'PuomDesc',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : "售价(发放单位)",
				dataIndex : 'pSp',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "数量(发放单位)",
				dataIndex : 'PuomQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "基本单位",
				dataIndex : 'BuomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "售价(基本单位)",
				dataIndex : 'bSp',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "数量(基本单位)",
				dataIndex : 'BuomQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "计价单位",
				dataIndex : 'BillUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "售价(计价单位)",
				dataIndex : 'BillSp',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "数量(计价单位)",
				dataIndex : 'BillUomQty',
				width : 100,
				align : 'right',
				sortable : true
			}, ColumnNotUseFlag
	]);
	PhaOrderCm.defaultSortable = true;
	
	var PhaOrderGrid = new Ext.ux.GridPanel({
		id : 'PhaOrderGrid',
		cm : PhaOrderCm,
		store : PhaOrderStore,
		trackMouseOver : true,
		stripeRows : true,
		sm : sm,
		loadMask : true,
		bbar : StatuTabPagingToolbar,
		deferRowRender : false
	});

	PhaOrderStore.load({
		callback : function(r, options, success) {
			if (success == false) {
              Msg.info('warning','没有任何记录！');
			 	if(window){window.focus();}
			} else {
				PhaOrderGrid.getSelectionModel().selectFirstRow();// 选中第一行并获得焦点
				row = PhaOrderGrid.getView().getRow(0);
				if(row){
					var element = Ext.get(row);
					if (typeof(element) != "undefined" && element != null) {
						element.focus();
						PhaOrderGrid.getView().focusRow(0);
					}
				}
			}
		}
	});
		// 回车事件
	PhaOrderGrid.on('keydown', function(e) {
		if (e.getKey() == Ext.EventObject.ENTER) {
			InDispItmGrid.getSelectionModel().selectFirstRow();// 选中第一行并获得焦点
			row = InDispItmGrid.getView().getRow(0);
			if (row){
				var element = Ext.get(row);
				if (typeof(element) != "undefined" && element != null) {
					element.focus();
				}	
			}
		}
	});
	
	//科室库存项目的供应商发放记录
	var InDispItmStore = new Ext.data.Store({
		autoDestroy: true,
		url:RetURL	+ '?actiontype=selectBatch',
		reader: new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results" ,
			id:'indsi',
			fields:["inclb","inci","inciCode","inciDesc","spec",
				"dispQty","dsiRetQty","dispUom","dispUomDesc","dispDate",
				"batNo","expDate","opUser","indsi",{name:"mnf",mapping:'manf'},
				"rp","sp","dsrqNo"
			]
		})	
	});	
	
	var IngriToolBar = new Ext.PagingToolbar({
		store : InDispItmStore,
		pageSize : 15,
		displayInfo : true
	});

	var nm2 = new Ext.grid.RowNumberer();
	var sm2=new Ext.grid.CheckboxSelectionModel({
		checkOnly:true,
		listeners:{
			'rowselect':function(t,ind,rec)
			{
				var dispQty=Number(rec.get('dispQty'));
				var retQty=rec.get('retQty');
				if(retQty==undefined || retQty==""){
					rec.set('retQty',dispQty);
				}else{
					rec.set('retQty',Math.min(dispQty,Number(retQty)));
				}
			},
			'rowdeselect':function(t,ind,rec)
			{
				rec.set('retQty','');
			}
		}
	});	
	
	var InDsItmCm=new Ext.grid.ColumnModel([nm2, sm2,{
		header : "批号",
		dataIndex : 'batNo',
		width : 100,
		align : ''
	},{
		header : "效期",
		dataIndex : 'expDate',
		width : 100,
		align : ''
	},{
		header : "厂商",
		dataIndex : 'mnf',
		width : 100,
		align : ''
	},{
		header : "发放日期",
		dataIndex : 'dispDate',
		width : 100,
		align : ''
	},{
		header : "请领单号",
		dataIndex : 'dsrqNo',
		width : 140,
		align : 'left'
	},{
		header : "可退数量",
		dataIndex : 'dispQty',
		width : 100,
		align : 'right'
	},{
		header:'退回数',
		dataIndex:'retQty',
		id:'retQty',
		width:100,
		align:'right',
		editor:new Ext.form.NumberField({
			allowNegative:false
		})
	},{
		header : "已退占用",
		dataIndex : 'dsiRetQty',
		width : 60,
		align : 'right'
	},{
		header : "单位rowid",
		dataIndex : 'dispUom',
		width : 100,
		align : '',
		hidden : true
	},{
		header : "单位",
		dataIndex : 'dispUomDesc',
		width : 100,
		align : ''
	},{
		header:'进价',
		dataIndex:'rp',
		width:80,
		align:'right'
	},{
		header:'售价',
		dataIndex:'sp',
		width:80,
		align:'right'
	},{
		header:'发放人',
		dataIndex:'opUser',
		width : 60
	},{
		header : "发放明细rowid",
		dataIndex : 'indsi',
		width : 100,
		align : '',
		hidden : true
	},{
		header : "批次rowid",
		dataIndex : 'inclb',
		width : 100,
		align : '',
		hidden : true
	}]);
	
	var InDispItmGrid = new Ext.ux.EditorGridPanel({
		id : 'InDispItmGrid',
		title:'已发放批次信息',
		cm:InDsItmCm,
		clicksToEdit:true,
		store:InDispItmStore,
		trackMouseOver : true,
		stripeRows : true,
		sm : sm2, 
		loadMask : true,
		bbar : IngriToolBar	,
		deferRowRender : false
	});
	// 回车事件
	InDispItmGrid.on('keydown', function(e) {
		if (e.getKey() == Ext.EventObject.ENTER) {
			returnData();
		}
	});
	
	// 返回按钮
	var returnBT = new Ext.Toolbar.Button({
		text : '确定',
		tooltip : '确定退回明细',
		height:30,
		width:70,
		iconCls : 'page_goto',
		handler : function() {
			returnData();
		}
	});
	
	var sd = new Ext.ux.DateField({
		id:'StartDate',
		fieldLabel:"起始日期",
		listeners:{
			change:function(field,newValue,oldValue){
				queryInDispItm();
			},
			select:function(){
				this.fireEvent('change');
			}
		}
	})

	var ed = new Ext.ux.DateField({
		id:'EndDate',
		fieldLabel:"截止日期",
		value:new Date(),
		listeners:{
			change:function(field,newValue,oldValue){
				queryInDispItm();
			},
			select:function(){
				this.fireEvent('change');
			}
		}
	})
	
	setInitDate();
	
	/**
	 * 返回数据
	 */
	function returnData() {
		var selectRows = InDispItmGrid.getSelectionModel().getSelections();
		var MasterRecord = PhaOrderGrid.getSelectionModel().getSelections();
		if(MasterRecord==null){return;}
		if (selectRows.length == 0) {
			Msg.info("warning", "请选择一条批次信息！");
		}else {
			for(var i=0;i<selectRows.length;i++){
				Ext.applyIf(selectRows[i].data,MasterRecord[0].data);
			}
			Fn(selectRows);
			window.close();
		}
	}

	// 关闭按钮
	var closeBT = new Ext.Toolbar.Button({
		text : '关闭',
		tooltip : '点击关闭',
		height:30,
		width:70,
		iconCls : 'page_delete',
		handler : function() {
			window.close();
		}
	});	
	
	//检索供应商发放明细记录
	function queryInDispItm()
	{
		InDispItmStore.removeAll();
		var rec=PhaOrderGrid.getSelectionModel().getSelected();
		if(rec==null){
			Msg.info("warning","请选择物资品种!");
			return;
		}
		var inci=rec.get('InciDr');
		var sd =Ext.getCmp("StartDate").getValue();
		if(Ext.isEmpty(sd)){
			
			Msg.info("warning","日期不可为空！")
			}
		var sd=sd.format(ARG_DATEFORMAT);
		var ed=Ext.getCmp("EndDate").getValue();
		if(Ext.isEmpty(ed)){
			
			Msg.info("warning","日期不可为空！")
			}
		var ed=ed.format(ARG_DATEFORMAT);
//		var INDSLoc = tkMakeServerCall("web.DHCSTM.Common.UtilCommon","GetLeadLoc",Locdr);	//发放科室
		var strPar=RetLoc+"^"+session['LOGON.USERID']+"^"+inci+"^"+sd+"^"+ed+"^"+Locdr;
		var pageSize=IngriToolBar.pageSize;
		//alert(strPar);
		InDispItmStore.setBaseParam('strPar',strPar);
		InDispItmStore.load({params:{start:0,limit:pageSize}});
	}
	
	var window = new Ext.Window({
		title : '检索物资品种',
		width : gWinWidth,
		height : gWinHeight,
		layout : 'border',
		plain : true,
		tbar : [returnBT, '-', closeBT],
		modal : true,
		buttonAlign : 'center',
		autoScroll : true,
		items : [{
			region:'north',
			height:200,
			split:true,
			layout:'fit',
			items:PhaOrderGrid
		},{
			region:'center',
			layout:'fit',
			items:InDispItmGrid
		},{
			region:'south',
			layout:'column',
			frame : true,
			height:40,
			items:[{columnWidth:'.3',layout:'form',labelAlign:'right',items:sd},
				{columnWidth:'.3',layout:'form',labelAlign:'right',items:ed}]
		}]
	});

	window.show();
}

/* 设置缺省的起始日期和截止日期*/
function setInitDate()
{
  var days =180 ;
  var sd=new Date().add(Date.DAY,-days);
  var ed=new Date();
  Ext.getCmp('StartDate').setValue(sd);
  Ext.getCmp('EndDate').setValue(ed);
}