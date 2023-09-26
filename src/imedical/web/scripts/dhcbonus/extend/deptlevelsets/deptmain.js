locLastFun = function(dataStore,grid,pagingTool) {
	if(repdr=="roo"){
		Ext.Msg.show({title:'����',msg:'�˽ڵ㲻�����ʵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	}
	if(leaf)
	{
		Ext.Msg.show({title:'ע��',msg:'�˽ڵ㲻�����ʵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	var tmpUId="";
	var deptLevelSetsLastTabProxy = new Ext.data.HttpProxy({url:'dhc.bonus.deptlevelsetsexe.csp?action=listlast&id='+repdr});
	var tmpMonth="";

	var deptLevelSetsLastTabDs = new Ext.data.Store({
		proxy: deptLevelSetsLastTabProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, [
			'rowid',
			'unitTypeDr',
			'unitTypeName',
			'unitDr',
			'deptCode',
			'unitName',
			'deptDr',
			'deptName',
			'recCost',
			'distCost',
			'order'
		]),
		remoteSort: true
	});

	deptLevelSetsLastTabDs.setDefaultSort('rowid', 'Desc');



	var deptLevelSetsLastTabCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: "˳��",
			dataIndex: 'order',
			width: 50,
			sortable: true
		},
		{
			header: '���Ҵ���',
			dataIndex: 'deptCode',
			width: 100,
			sortable: true
		},
		{
			header: '��������',
			dataIndex: 'deptName',
			width: 200,
			sortable: true
		}
		/*,
		{
			header: "���ܳɱ�",
			dataIndex: 'recCost',
			width: 80,
			sortable: true,
			renderer : function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		},
		{
			header: "��̯�ɱ�",
			dataIndex: 'distCost',
			width: 80,
			sortable: true,
			renderer : function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		}*/
	]);


		
	var deptLevelSetsLastTabPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 15,
		store: deptLevelSetsLastTabDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		doLoad:function(C){
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['id']=repdr;
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}

	});
	var addLocButton  = new Ext.Toolbar.Button({
		text: '���ӵ�Ԫ',
		tooltip: '���ӵ�Ԫ',
		iconCls: 'add',
		handler: function(){AddLocFun(deptLevelSetsLastTabDs,formPanel,deptLevelSetsLastTabPagingToolbar);}
	});

	var editLocButton  = new Ext.Toolbar.Button({
		text: '�޸ĵ�Ԫ',
		tooltip: '�޸ĵ�Ԫ',
		iconCls: 'add',
		handler: function(){editLocFun(deptLevelSetsLastTabDs,formPanel,deptLevelSetsLastTabPagingToolbar);}
	});
	var delLocButton  = new Ext.Toolbar.Button({
		text:'ɾ����Ԫ',
		tooltip:'ɾ��ѡ���ĵ�Ԫ',
		iconCls:'remove',
		//disabled:'true',
		handler: function(){
			var rowObj = formPanel.getSelections();
			var len = rowObj.length;
			var myId = "";
			if(len < 1)
			{
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{	
				Ext.MessageBox.confirm('��ʾ', 
				'ȷ��Ҫɾ��ѡ������?', 
				function(btn) {
					if(btn == 'yes')
					{	
					myId = rowObj[0].get("rowid");
						Ext.Ajax.request({
						url:'dhc.bonus.deptlevelsetsexe.csp?action=delloc&id='+myId,
						waitMsg:'ɾ����...',
						failure: function(result, request) {
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								Ext.getCmp('detailReport').getNodeById(repdr).reload();
								deptLevelSetsLastTabDs.load({params:{start:0, limit:deptLevelSetsPagingToolbar.pageSize}});
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
		}
	});
		
	var formPanel = new Ext.grid.GridPanel({
		//title: 'ͨ������',
		store: deptLevelSetsLastTabDs,
		cm: deptLevelSetsLastTabCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar:[addLocButton,'-',editLocButton,'-',delLocButton],
		bbar: deptLevelSetsLastTabPagingToolbar
	});

	
	var window = new Ext.Window({
		title: '��Ԫ',
		width: 600,
		height:400,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [
			{
				text: 'ȡ��',
				handler: function(){window.close();}
			}]
		});

	window.show();
	deptLevelSetsLastTabDs.load({params:{start:0, limit:deptLevelSetsLastTabPagingToolbar.pageSize}});
};