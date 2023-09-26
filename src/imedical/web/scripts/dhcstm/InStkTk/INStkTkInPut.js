// /名称: 实盘：录入方式三（根据帐盘数据按品种填充实盘数）
// /描述: 实盘：录入方式三（根据帐盘数据按品种填充实盘数）
// /编写者：zhangdongmei
// /编写日期: 2012.09.07
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gUserId=session['LOGON.USERID'];
	var gStrDetailParams='';
	var url=DictUrl+'instktkaction.csp';
	var LocManaGrp = new Ext.form.ComboBox({
		fieldLabel : '管理组',
		id : 'LocManaGrp',
		name : 'LocManaGrp',
		anchor : '90%',
		store : LocManGrpStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : true,
		triggerAction : 'all',
		emptyText : '管理组...',
		selectOnFocus : true,
		forceSelection : true,
		minChars : 1,
		pageSize : 20,
		listWidth : 250,
		valueNotFoundText : '',
		listeners:{
			'beforequery':function(combox){
				this.store.removeAll();
				LocManGrpStore.setBaseParam('locId',gLocId)
				LocManGrpStore.load({params:{start:0,limit:20}});	
			}
		}
	});
	
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,     //标识类组类型
		UserId:gUserId,
		LocId:gLocId,
		anchor:'90%',
		childCombo : ['DHCStkCatGroup']
	});

	var DHCStkCatGroup = new Ext.ux.ComboBox({
		fieldLabel : '库存分类',
		id : 'DHCStkCatGroup',
		name : 'DHCStkCatGroup',
		store : StkCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{StkGrpId:'StkGrpType'}
	});

	var StkBin = new Ext.ux.ComboBox({
		fieldLabel : '货位',
		id : 'StkBin',
		name : 'StkBin',
		anchor : '90%',
		width : 140,
		store : LocStkBinStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		forceSelection : true,
		minChars : 1,
		pageSize : 20,
		listWidth : 250,
		valueNotFoundText : '',
		enableKeyEvents : true,
		listeners : {
			'beforequery' : function(e) {
				this.store.removeAll();
				LocStkBinStore.setBaseParam('LocId',gLocId);
				LocStkBinStore.setBaseParam('Desc',Ext.getCmp('StkBin').getRawValue());
				LocStkBinStore.load({params:{start:0,limit:20}});
			}
		}
	});
	
	var InstNo=new Ext.form.TextField({
		id : 'InstNo',
		name : 'InstNo',
		fieldLabel:'盘点单号',
		width:140,
		anchor:'90%',
		disabled:true
	});
	
	var InputWin = new Ext.form.ComboBox({
		fieldLabel : '实盘窗口',
		id : 'InputWin',
		name : 'InputWin',
		anchor : '90%',
		store : INStkTkWindowStore,
		valueField : 'RowId',
		displayField : 'Description',
		disabled:true,
		allowBlank : true,
		triggerAction : 'all',
		emptyText : '实盘窗口...',
		listeners:{
			'beforequery':function(e){
				this.store.removeAll();
				this.store.setBaseParam('LocId',gLocId);
				this.store.load({params:{start:0,limit:99}});
			}
		}
	});
	
	INStkTkWindowStore.load({
		params:{start:0,limit:99,'LocId':gLocId},
		callback:function(){
			Ext.getCmp("InputWin").setValue(gInputWin);
		}
	});
	
	var InciCode = {
		id : 'InciCode',
		xtype : 'textfield',
		fieldLabel : '物资代码',
		anchor : '90%',
		listeners : {
			specialkey : function(field, e){
				if(e.getKey() == Ext.EventObject.ENTER){
					QueryDetail();
				}
			}
		}
	};
	
	//设置未填数等于帐盘数
	var SetDefaultBT2 = new Ext.Toolbar.Button({
		text : '设置未填数等于帐盘数',
		tooltip : '点击设置未填数等于帐盘数',
		iconCls : 'page_save',
		width : 70,
		height : 30,
		handler : function() {
			var ss=Ext.Msg.show({
			   title:'提示',
			   msg: '设置未填实盘数等于帐盘数将修改此盘点单所有未录入的记录，是否继续？',
			   buttons: Ext.Msg.YESNO,
			   fn: function(b,t,o){
				   if (b=='yes'){
					   SetDefaultQty(2);
				   }
			   },
			   icon: Ext.MessageBox.QUESTION
			});
		}
	});

	//设置未填数等于0
	var SetDefaultBT = new Ext.Toolbar.Button({
		text : '设置未填数等于0',
		tooltip : '点击设置未填数等于0',
		iconCls : 'page_save',
		width : 70,
		height : 30,
		handler : function() {
			var ss=Ext.Msg.show({
			   title:'提示',
			   msg: '设置未填实盘数等于0将修改此盘点单所有未录入的记录，是否继续？',
			   buttons: Ext.Msg.YESNO,
			   fn: function(b,t,o){
				   if (b=='yes'){
					   SetDefaultQty(1);
				   }
			   },
			   icon: Ext.MessageBox.QUESTION
			});
		}
	});
	
	//设置未填实盘数
	function SetDefaultQty(flag){
		if(gRowid==''){
			Msg.info('Warning','没有选中的盘点单！');
			return;
		}
		var InstwWin=Ext.getCmp("InputWin").getValue();
		var UserId=session['LOGON.USERID'];
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url:url,
			params:{actiontype:'InputSetDefaultQty',Inst:gRowid,UserId:UserId,Flag:flag,InstwWin:InstwWin},
			method:'post',
			waitMsg:'处理中...',
			success:function(response,opt){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				 mask.hide();
				if(jsonData.success=='true'){
					Msg.info('success','成功!');
					create(gRowid);
				}else{
					var ret=jsonData.info;					
					Msg.info('error','设置未填记录实盘数失败:'+ret);
				}
			}		
		});
	}
	// 查询按钮
	var SearchBT = new Ext.Toolbar.Button({
		text : '查询',
		tooltip : '点击查询',
		iconCls : 'page_find',
		width : 70,
		height : 30,
		handler : function() {
			QueryDetail();
		}
	});
	
	// 清空按钮
	var RefreshBT = new Ext.Toolbar.Button({
		text : '清空',
		tooltip : '点击清空',
		iconCls : 'page_clearscreen',
		width : 70,
		height : 30,
		handler : function() {
			clearData();
		}
	});

	/**
	 * 清空方法
	 */
	function clearData() {
		Ext.getCmp("DHCStkCatGroup").setValue('');
		Ext.getCmp("StkBin").setValue('');
		Ext.getCmp("StkGrpType").setValue('');
		Ext.getCmp("LocManaGrp").setValue('');
		Select();
		InstDetailGrid.store.removeAll();
		InstDetailGrid.getView().refresh();
	}

	var SaveBT=new Ext.Toolbar.Button({
		text:'保存',
		tooltip:'点击保存',
		iconCls:'page_save',
		width:70,
		height:30,
		handler:function(){
			save();
		}
	});
	
	/*
	// 完成按钮	//2013-09-29 wangjiabin: 此按钮再修改了实盘窗口后不再使用, 暂不删除, 修改需谨慎
	var CompleteBT = new Ext.Toolbar.Button({
				text : '完成',
				tooltip : '点击完成',
				iconCls : 'page_gear',
				width : 70,
				height : 30,
				handler : function() {
					Complete();
				}
			});
	function Complete(){
		var UserId=session['LOGON.USERID'];
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url:url,
			params:{actiontype:'CompleteInput',Inst:gRowid,User:UserId},
			method:'post',
			waitMsg:'处理中...',
			success:function(response,opt){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				 mask.hide();
				if(jsonData.success=='true'){
					Msg.info('success','操作成功!');
					QueryDetail();
				}else{
					var ret=jsonData.info;					
					Msg.info('error','操作失败:'+ret);
					
				}
			}		
		});
	
	}
	*/
	
	//保存实盘数据
	function save(){
		if(InstDetailGrid.activeEditor != null){
			InstDetailGrid.activeEditor.completeEdit();
		}
		var rowCount=InstDetailStore.getCount();
		var ListDetail='';
		var InputWin=Ext.getCmp("InputWin").getValue();
		for(var i=0;i<rowCount;i++){
			var rowData=InstDetailStore.getAt(i);
			//新增或修改过的数据
			if(rowData.dirty || rowData.data.newRecord){
				var Parref=rowData.get('parref');
				var Rowid=rowData.get('rowid');
				var UserId=session['LOGON.USERID'];
				var CountQty=rowData.get('countQty');
				if(CountQty==""){
					CountQty=0;
				}
				var CountUomId=rowData.get('uom');
				var IncId=rowData.get('inci');
				var Detail=Rowid+'^'+Parref+'^'+IncId+'^'+CountUomId+'^'+CountQty+'^'+UserId+'^'+InputWin;
				if(ListDetail==''){
					ListDetail=Detail;
				}else{
					ListDetail=ListDetail+xRowDelim()+Detail;
				}
			}
		}
		if(ListDetail==''){
			Msg.info('Warning','没有需要保存的数据!');
			return;
		}
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url:url,
			params:{actiontype:'SaveInput',Params:ListDetail},
			method:'post',
			waitMsg:'处理中...',
			success:function(response,opt){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				 mask.hide();
				if(jsonData.success=='true'){
					Msg.info('success','保存成功!');
					InstDetailStore.reload();
				}else{
					var ret=jsonData.info;
					if(ret=='-1'){
						Msg.info('warning','没有需要保存的数据!');
					}else if(ret=='-2'){
						Msg.info('error','保存失败!');
					}else{
						Msg.info('error','部分数据保存失败:'+ret);
					}
				}
			}		
		});
	}

	//根据帐盘数据插入实盘列表
	function create(inst){
		if(inst==null || inst==''){
			Msg.info('warning','请选择盘点单');
			return;
		}
		var UserId=session['LOGON.USERID'];
	    var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url:url,
			params:{actiontype:'CreateStkTkInput',Inst:inst,UserId:UserId,InputWin:gInputWin},
			waitMsg:'处理中...',
			success:function(response,opt){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				 mask.hide();
				if(jsonData.success=='true'){
					QueryDetail();    //查找实盘列表
				}else{
					var ret=jsonData.info;					
					Msg.info("error","提取实盘列表失败："+ret);					
				}
			}			
		});
	}
		
	//查找盘点单明细信息
	function QueryDetail(){
		//查询盘点单明细
		var StkGrpId=Ext.getCmp('StkGrpType').getValue();
		var StkCatId=Ext.getCmp('DHCStkCatGroup').getValue();
		var StkBinId=Ext.getCmp('StkBin').getValue();
		var ManaGrpId=Ext.getCmp('LocManaGrp').getValue();
		var InputWin=Ext.getCmp('InputWin').getValue();
		var InciCode=Ext.getCmp('InciCode').getValue();
		var size=StatuTabPagingToolbar.pageSize;
		gStrDetailParams=gRowid+'^'+ManaGrpId+'^'+StkGrpId+'^'+StkCatId+'^'+StkBinId
			+'^'+InputWin+'^'+InciCode;
		InstDetailStore.setBaseParam('sort','code');
		InstDetailStore.setBaseParam('dir','ASC');
		InstDetailStore.setBaseParam('Params',gStrDetailParams)
		InstDetailStore.load({
			params:{start:0,limit:size},
			callback:function(r,options,success){
				if(success==false){
					Msg.info("error","查询有误,请查看日志!");
				}
			}
		});
	}
	//查询盘点单主表信息
	function Select(){
		if(gRowid==null || gRowid==""){
			return;
		}
		Ext.Ajax.request({
			url:url,
			params:{actiontype:'Select',Rowid:gRowid},
			method:'post',
			success:function(response,opt){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				if(jsonData.success=='true'){
					var info=jsonData.info;
					if(info!=""){
						var detail=info.split("^");
						var InstNo=detail[0];
						var StkGrpId=detail[17];
						var StkCatId=detail[18];
						var StkCatDesc=detail[19];
						var StkGrpDesc=detail[28];
						Ext.getCmp("InstNo").setValue(InstNo);
						addComboData(null,StkGrpId,StkGrpDesc,StkGrpType);
						Ext.getCmp("StkGrpType").setValue(StkGrpId);
						addComboData(StkCatStore,StkCatId,StkCatDesc);
						Ext.getCmp("DHCStkCatGroup").setValue(StkCatId);
					}
				}
			}
		});
	}
	
	var nm = new Ext.grid.RowNumberer();
	var InstDetailGridCm = new Ext.grid.ColumnModel([nm, {
				header : "rowid",
				dataIndex : 'rowid',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "parref",
				dataIndex : 'parref',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			},{
				header:"inci",
				dataIndex:'inci',
				width:80,
				align:'left',
				sortable:true,
				hidden:true				
			},{
				header : '代码',
				dataIndex : 'code',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "名称",
				dataIndex : 'desc',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : "规格",
				dataIndex : 'spec',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "单位",
				dataIndex : 'uomDesc',
				width : 60,
				align : 'left',
				sortable : true
			}, {
				header : "冻结数量",
				dataIndex : 'freQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header:'实盘数量',
				dataIndex:'countQty',
				width:80,
				align:'right',
				sortable:true,
				editor:new Ext.form.NumberField({
					selectOnFocus : true,
					allowNegative : false
				})
			},{
				header : "数量差",
				dataIndex : 'diffQty',
				width : 80,
				align : 'right',
				sortable : true
			},{
				header:'货位',
				dataIndex:'IncsbDesc',
				width:100,
				align:'left',
				sortable:true
			},{
				header:'实盘日期',
				dataIndex:'countDate',
				width:80,
				align:'left',
				sortable:true
			},{
				header : "实盘时间",
				dataIndex : 'countTime',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header:'实盘人',
				dataIndex:'userName',
				width:80,
				align:'left',
				sortable:true
			}]);
	InstDetailGridCm.defaultSortable = true;

	// 数据集
	var InstDetailStore = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			url : url+"?actiontype=QueryInput",
			method : "POST"
		}),
		reader :  new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			id : "rowid",
			fields : ["rowid","parref", "inci", "code", "desc","spec", 
				"uom", "uomDesc", "freQty", "countQty","countDate",
				"countTime","userName","IncsbDesc","diffQty"]
		}),
		pruneModifiedRecords: true
	});

	var StatuTabPagingToolbar = new Ext.PagingToolbar({
		store : InstDetailStore,
		pageSize : PageSize,
		displayInfo : true,
		displayMsg : '当前记录 {0} -- {1} 条 共 {2} 条记录',
		emptyMsg : "No results to display",
		prevText : "上一页",
		nextText : "下一页",
		refreshText : "刷新",
		lastText : "最后页",
		firstText : "第一页",
		beforePageText : "当前页",
		afterPageText : "共{0}页",
		emptyMsg : "没有数据"
	});
		
	StatuTabPagingToolbar.addListener('beforechange',function(toolbar,params){
		if(InstDetailGrid.activeEditor != null){
			InstDetailGrid.activeEditor.completeEdit();
		}
		var records=InstDetailStore.getModifiedRecords();
		if(records.length>0){
			Ext.Msg.show({
				title:'提示',
				msg: '本页数据发生改变，是否需要保存？',
				buttons: Ext.Msg.YESNOCANCEL,
				fn: function(btn,text,opt){
					if(btn=='yes'){
						save();
						toolbar.store.commitChanges();
						changePagingToolBar(toolbar,params.start);
					}
					if(btn=='no'){
						toolbar.store.rejectChanges();
						changePagingToolBar(toolbar,params.start);
					}
				},
				animEl: 'elId',
				icon: Ext.MessageBox.QUESTION
			});
			return false;
		}
	});

	//startRow:当前页中开始行的在所有记录中的顺序
	function changePagingToolBar(toolbar,startRow){
		if(toolbar.cursor > startRow){
			if(toolbar.cursor - startRow == toolbar.pageSize){
				toolbar.movePrevious();
			}else{
				toolbar.moveFirst();
			}
		}
		if(toolbar.cursor < startRow){
			if(toolbar.cursor - startRow == -toolbar.pageSize){
				toolbar.moveNext();
			}else{
				toolbar.moveLast();
			}
		}
	}
	var InstDetailGrid = new Ext.grid.EditorGridPanel({
		id:'InstDetailGrid',
		region : 'center',
		cm : InstDetailGridCm,
		store : InstDetailStore,
		trackMouseOver : true,
		stripeRows : true,
		sm : new Ext.ux.CellSelectionModel(),
		loadMask : true,
		bbar : StatuTabPagingToolbar,
		clicksToEdit:1,
		listeners:{
			'afteredit' : function(e){
				if(e.field=='countQty'){
					var FreQty=e.record.get("freQty");
					var countQty=e.record.get("countQty");
					var diffQty=countQty-FreQty;
					e.record.set("diffQty",diffQty);
				}
			}
		}
	});
	
	var form = new Ext.form.FormPanel({
		region : 'north',
		autoHeight : true,
		labelAlign : 'right',
		title : '实盘:录入方式三(按品种录入)',
		frame : true,
		tbar:[SearchBT,'-',SaveBT,'-',RefreshBT,'-',SetDefaultBT,'-',SetDefaultBT2],
		items:[{
			xtype:'fieldset',
			title:'查询条件',
			layout: 'column',
			defaults: {layout:'form'},
			items : [{
				columnWidth: 0.34,
				items: [LocManaGrp,StkBin,InciCode]
			},{
				columnWidth: 0.33,
				items: [StkGrpType,InstNo]
			},{
				columnWidth: 0.33,
				items: [DHCStkCatGroup,InputWin]
			}]
		}]
	});
	
	// 5.2.页面布局
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [form,
				{
					region:'center',
					layout:'fit',
					items:[InstDetailGrid]
				}],
		renderTo : 'mainPanel'
	});
	Select();
	//自动加载盘点单
	create(gRowid);
})