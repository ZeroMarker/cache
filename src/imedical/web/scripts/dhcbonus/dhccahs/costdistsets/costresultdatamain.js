
costResultDataMain = function(dataStore,grid,pagingTool) {
	
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	var repdr="";
	var layer="";
	var rowid="";
	var repname="";
	var nodeName="";
	var monthDr="";
	var distFlag="";
	var active="";
	
	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择成本分摊套!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		active=rowObj[0].get("active"); 
		rowid = rowObj[0].get("rowid"); 
		layer = rowObj[0].get("deptSetDr"); 
		repname = rowObj[0].get("deptSetName"); 
		distFlag = rowObj[0].get("distFlag"); 
	}
	if(active !="Y")
	{
		Ext.Msg.show({title:'注意',msg:'不能为无效数据添加分摊方法!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	Ext.tree.TreeLoader.override({ requestData : function(node, callback){ if(this.fireEvent("beforeload", this, node, callback) !== false){ this.transId = Ext.Ajax.request({ method:this.requestMethod, url: this.dataUrl||this.url, success: this.handleResponse, failure: this.handleFailure, timeout: this.timeout || 30000, scope: this, argument: {callback: callback, node: node}, params: this.getParams(node) }); }else{if(typeof callback == "function"){ callback(); } } }});
	//树形结构导入器
	var locTreeLoader = new Ext.tree.TreeLoader({
		dataUrl:'dhc.ca.costdistsetsexe.csp',
		timeout:1200000,
		uiProviders:{
			'col': Ext.tree.ColumnNodeUI
		}
	});
	//加载前事件
	locTreeLoader.on('beforeload', function(locTreeLoader,node){
		if(monthDr=="") return;
		var url="dhc.ca.costdistsetsexe.csp?action=listResult";
		locTreeLoader.dataUrl=url+"&nodeDr="+node.id+"&monthDr="+monthDr+'&costSetsDr='+rowid+'&layerDr='+layer;
	});
	//树形结构的根
	var locTreeRoot = new Ext.tree.AsyncTreeNode({
		id:"roo",
		text:repname,
		value:'0',
		expanded:true
	});

	var findUndistButton  = new Ext.Toolbar.Button({
		text: '未分摊数据',
		tooltip: '查看未分摊数据',
		iconCls: 'add',
		handler: function(){costUndistFun(rowid,monthDr,repdr,nodeName);}
	});

	var findLocButton  = new Ext.Toolbar.Button({
		text: '分摊明细',
		tooltip: '查看分摊明细',
		iconCls: 'add',
		handler: function(){	
			if(leaf){
				new CostResultFun(rowid,monthDr,repdr,"disted");
			}else{
				Ext.Msg.show({title:'错误',msg:'请选择待查看的实体科室!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
			}
		}
	});
	
	var delLocButton  = new Ext.Toolbar.Button({
		text:'删除分摊结果',
		tooltip:'删除分摊结果',
		iconCls:'remove',
		//disabled:'true',
		handler: function(){	
			if(monthDr=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'请选择区间后再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
				Ext.MessageBox.confirm('提示', 
				'确定要删除\"'+months.getRawValue()+'\"分摊结果?', 
				function(btn) {
					if(btn == 'yes')
					{	
						Ext.Ajax.request({
						url:'dhc.ca.costdistsetsexe.csp?action=delResult&costSetsDr='+rowid+'&monthDr='+monthDr,
						waitMsg:'删除中...',
						failure: function(result, request) {
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								locTreeRoot.reload();
							}
							else
								{
									var message="";
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});   	
					}
				})
		}
	});
	
	var importVButton  = new Ext.Toolbar.Button({
		text:'将结果导入财务支出数据页面',
		tooltip:'将结果导入凭证数据',
		iconCls:'remove',
		//disabled:'true',
		handler: function(){	
			if(monthDr=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'请选择区间后再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
				Ext.MessageBox.confirm('提示', 
				'确定要将\"'+months.getRawValue()+'\"分摊结果导入到财务支出数据?', 
				function(btn) {
					if(btn == 'yes')
					{	
						Ext.Ajax.request({
						url:'dhc.ca.costdistsetsexe.csp?action=improtVouch&costSetsDr='+rowid+'&monthDr='+monthDr+'&user='+session['LOGON.USERID'],
						waitMsg:'删除中...',
						failure: function(result, request) {
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'注意',msg:'导入成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								locTreeRoot.reload();
							}
							else
								{
									var message=jsonData.info;
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});   	
					}
				})
		}
	});
	if(distFlag!="逐层")importVButton.enable();
	else importVButton.disable();
	
	
	var monthsDs = new Ext.data.Store({
		proxy: "",                                                           
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','desc','start','end','dataFinish'])
	});
	var months = new Ext.form.ComboBox({
		id: 'months',
		fieldLabel: '核算区间',
		width: 100,
		listWidth : 260,
		allowBlank: false,
		store: monthsDs,
		//readOnly:true,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'选择核算区间...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	monthsDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.vouchdatasexe.csp?action=months&searchValue='+Ext.getCmp('months').getRawValue(),method:'GET'});
	});	
	var detailReport = new Ext.tree.ColumnTree({
		id:'detailReport',
		//width:450,
		region: 'west',
		//split: true,
		autoScroll:true,
		//collapsible: true,
		//containerScroll: true,
		rootVisible: true,
		//title: '部门分层',
		tbar: ["核算区间:",'-',months,'-',delLocButton,'-',findUndistButton,'-',findLocButton,'-',importVButton],
		columns:[{
			header:'名称',
			width:200,
			dataIndex:'name'
		},{
			header:'直接成本',
			width:150,
			align: 'right',
			renderer: formatNum,
			dataIndex:'self'
		},{
			header:'分摊成本',
			width:150,
			align: 'right',
			renderer: formatNum,
			dataIndex:'dist'
		},{
			header:'总计',
			width:150,
			align: 'right',
			renderer: formatNum,
			dataIndex:'total'
		}],
		loader:locTreeLoader,
		root:locTreeRoot,
		rootVisible: false,
		listeners:{
			beforeexpandnode:{fn:alt},
			click:{fn:nodeClicked}
		}
	});
	
	detailReport.on('dblclick',function(e){//双击表格行执行
			if(e.leaf) new CostResultFun(rowid,monthDr,e.id);
		});
	function nodeClicked(node)
	{
		nodeName=node.attributes.name;
		repdr=node.id;	
		leaf=node.leaf;
		//deptLevelSetsDs.load({params:{start:0, limit:deptLevelSetsPagingToolbar.pageSize,id:repdr}});		
	}
	function alt(node)
	{
		nodeName=node.attributes.name;
		repdr=node.id;	
		leaf=node.leaf;
		//deptLevelSetsDs.load({params:{start:deptLevelSetsPagingToolbar.cursor, limit:deptLevelSetsPagingToolbar.pageSize,id:node.id}});	
	}
	
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '成本分摊结果',
    width: 800,
    height:500,
    minWidth: 400,
    minHeight: 300,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: detailReport,
    buttons: [
    	{
			text: '取消',
			handler: function(){window.close();}
      }]
    });

    window.show();
	months.on("select",function(cmb,rec,id ){
		monthDr=cmb.getValue();
		locTreeRoot.reload();
	});
};