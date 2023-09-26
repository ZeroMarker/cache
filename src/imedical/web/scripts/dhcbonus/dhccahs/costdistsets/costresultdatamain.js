
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
		Ext.Msg.show({title:'ע��',msg:'��ѡ��ɱ���̯��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
		Ext.Msg.show({title:'ע��',msg:'����Ϊ��Ч������ӷ�̯����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	Ext.tree.TreeLoader.override({ requestData : function(node, callback){ if(this.fireEvent("beforeload", this, node, callback) !== false){ this.transId = Ext.Ajax.request({ method:this.requestMethod, url: this.dataUrl||this.url, success: this.handleResponse, failure: this.handleFailure, timeout: this.timeout || 30000, scope: this, argument: {callback: callback, node: node}, params: this.getParams(node) }); }else{if(typeof callback == "function"){ callback(); } } }});
	//���νṹ������
	var locTreeLoader = new Ext.tree.TreeLoader({
		dataUrl:'dhc.ca.costdistsetsexe.csp',
		timeout:1200000,
		uiProviders:{
			'col': Ext.tree.ColumnNodeUI
		}
	});
	//����ǰ�¼�
	locTreeLoader.on('beforeload', function(locTreeLoader,node){
		if(monthDr=="") return;
		var url="dhc.ca.costdistsetsexe.csp?action=listResult";
		locTreeLoader.dataUrl=url+"&nodeDr="+node.id+"&monthDr="+monthDr+'&costSetsDr='+rowid+'&layerDr='+layer;
	});
	//���νṹ�ĸ�
	var locTreeRoot = new Ext.tree.AsyncTreeNode({
		id:"roo",
		text:repname,
		value:'0',
		expanded:true
	});

	var findUndistButton  = new Ext.Toolbar.Button({
		text: 'δ��̯����',
		tooltip: '�鿴δ��̯����',
		iconCls: 'add',
		handler: function(){costUndistFun(rowid,monthDr,repdr,nodeName);}
	});

	var findLocButton  = new Ext.Toolbar.Button({
		text: '��̯��ϸ',
		tooltip: '�鿴��̯��ϸ',
		iconCls: 'add',
		handler: function(){	
			if(leaf){
				new CostResultFun(rowid,monthDr,repdr,"disted");
			}else{
				Ext.Msg.show({title:'����',msg:'��ѡ����鿴��ʵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
			}
		}
	});
	
	var delLocButton  = new Ext.Toolbar.Button({
		text:'ɾ����̯���',
		tooltip:'ɾ����̯���',
		iconCls:'remove',
		//disabled:'true',
		handler: function(){	
			if(monthDr=="")
      		{
      			Ext.Msg.show({title:'����',msg:'��ѡ�����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
				Ext.MessageBox.confirm('��ʾ', 
				'ȷ��Ҫɾ��\"'+months.getRawValue()+'\"��̯���?', 
				function(btn) {
					if(btn == 'yes')
					{	
						Ext.Ajax.request({
						url:'dhc.ca.costdistsetsexe.csp?action=delResult&costSetsDr='+rowid+'&monthDr='+monthDr,
						waitMsg:'ɾ����...',
						failure: function(result, request) {
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								locTreeRoot.reload();
							}
							else
								{
									var message="";
									Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});   	
					}
				})
		}
	});
	
	var importVButton  = new Ext.Toolbar.Button({
		text:'������������֧������ҳ��',
		tooltip:'���������ƾ֤����',
		iconCls:'remove',
		//disabled:'true',
		handler: function(){	
			if(monthDr=="")
      		{
      			Ext.Msg.show({title:'����',msg:'��ѡ�����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
				Ext.MessageBox.confirm('��ʾ', 
				'ȷ��Ҫ��\"'+months.getRawValue()+'\"��̯������뵽����֧������?', 
				function(btn) {
					if(btn == 'yes')
					{	
						Ext.Ajax.request({
						url:'dhc.ca.costdistsetsexe.csp?action=improtVouch&costSetsDr='+rowid+'&monthDr='+monthDr+'&user='+session['LOGON.USERID'],
						waitMsg:'ɾ����...',
						failure: function(result, request) {
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'ע��',msg:'����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								locTreeRoot.reload();
							}
							else
								{
									var message=jsonData.info;
									Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});   	
					}
				})
		}
	});
	if(distFlag!="���")importVButton.enable();
	else importVButton.disable();
	
	
	var monthsDs = new Ext.data.Store({
		proxy: "",                                                           
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','desc','start','end','dataFinish'])
	});
	var months = new Ext.form.ComboBox({
		id: 'months',
		fieldLabel: '��������',
		width: 100,
		listWidth : 260,
		allowBlank: false,
		store: monthsDs,
		//readOnly:true,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'ѡ���������...',
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
		//title: '���ŷֲ�',
		tbar: ["��������:",'-',months,'-',delLocButton,'-',findUndistButton,'-',findLocButton,'-',importVButton],
		columns:[{
			header:'����',
			width:200,
			dataIndex:'name'
		},{
			header:'ֱ�ӳɱ�',
			width:150,
			align: 'right',
			renderer: formatNum,
			dataIndex:'self'
		},{
			header:'��̯�ɱ�',
			width:150,
			align: 'right',
			renderer: formatNum,
			dataIndex:'dist'
		},{
			header:'�ܼ�',
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
	
	detailReport.on('dblclick',function(e){//˫�������ִ��
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
  	title: '�ɱ���̯���',
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
			text: 'ȡ��',
			handler: function(){window.close();}
      }]
    });

    window.show();
	months.on("select",function(cmb,rec,id ){
		monthDr=cmb.getValue();
		locTreeRoot.reload();
	});
};