CommFindFun = function() {
	if(repdr=="roo"){
		Ext.Msg.show({title:'����',msg:'�˽ڵ㲻�ܲ鿴����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	if(leaf)
	{
		Ext.Msg.show({title:'ע��',msg:'�˽ڵ㲻�ܲ鿴����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	//============================================================���ؼ�=============================================================


	var findCommTabProxy = new Ext.data.HttpProxy({url: deptLevelSetsUrl + '?action=listloc&searchvalue='});

	function formatDate(value){
		return value ? value.dateFormat('Y-m-d') : '';
	};
	
	var findCommTabDs = new Ext.data.Store({
		proxy: findCommTabProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, [
			'RowId',
			'itemCode',
			'itemName',
			'Phone',
			'Addr',
			'Remark',
			{name:'Start',type:'date',dateFormat:'Y-m-d'},
			{name:'End',type:'date',dateFormat:'Y-m-d'}
		]),
		remoteSort: true
	});



///////////////
/*	var hospProxy = new Ext.data.HttpProxy({url:deptLevelSetsUrl+'?action=listhosp'});

	var hospDs = new Ext.data.Store({
			proxy: hospProxy,
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['Name','Rowid'])	
	});


	var hospSelecter = new Ext.form.ComboBox({
		id: 'myHospSelecter',
		anchor: '90%',
		listWidth: 260,
		fieldLabel: '�������',
		store: hospDs,
		valueField: 'Rowid',
		displayField: 'Name',
		typeAhead: false,
		pageSize: 5,
		minChars: 1,
		triggerAction: 'all',
		emptyText: '��ѡ��...',
		selectOnFocus: true,
		forceSelection: true,
		readOnly: true
	});
	*/
////////////////////////////////
var itemTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','shortcut','remark','order','active'])
	});
	var hospSelecter = new Ext.form.ComboBox({
		id: 'itemType',
		fieldLabel: '�������',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: itemTypeDs,
		valueField: 'rowid',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ���������...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	
	itemTypeDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.datalevelsetsexe.csp?action=listitemtype&searchValue='+Ext.getCmp('itemType').getRawValue(),method:'POST'});
	});
/*
	itemType.on("select",function(cmb,rec,id ){
		//items.setRawValue("");
		//items.setValue("");
		itemsDs.proxy=new Ext.data.HttpProxy({url:'dhc.ca.datalevelsetsexe.csp?action=listloc&recname='+Ext.getCmp('items').getRawValue()+'&id='+itemType.getValue()+'&repdr='+repdr,method:'GET'});
		//itemsDs.proxy = new Ext.data.HttpProxy({url:'dhc.ca.datalevelsetsexe.csp?action=items&id='+cmb.getValue(),method:'GET'});
		itemsDs.load({params:{start:0, limit:cmb.pageSize}});
	});*/
	///////////////////////////////////////////
	var findCommTabCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
	 	{
    		header: '����',
			dataIndex: 'itemCode',
			width: 60,
			align: 'left',
			sortable: true
		},
		{
			header: "����",
			dataIndex: 'itemName',
			width: 200,
			align: 'left',
			sortable: true
		}/*,
		/*{
			header: "�绰",
			dataIndex: 'Phone',
			width: 150,
			align: 'left',
			sortable: true
		},
		{
			header: "λ��",
			dataIndex: 'Addr',
			width: 150,
			align: 'left',
			sortable: true
		},
		{
			header: "��ע",
			dataIndex: 'Remark',
			width: 200,
			align: 'left',
			sortable: true
		},
		{
			header: "��������",
			dataIndex: 'Start',
			width: 80,
			align: 'left',
			sortable: true,
			renderer: formatDate
		},
		{
			header: "ͣ������",
			dataIndex: 'End',
			width: 80,
			align: 'left',
			sortable: true,
			renderer: formatDate
		}*/
	]);



		var findCommTabPagingToolbar = new Ext.PagingToolbar({//��ҳ������
			pageSize: 10,
			store: findCommTabDs,
			displayInfo: true,
			displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
			emptyMsg: "û������",
			doLoad:function(C){
				var B={},
				A=this.paramNames;
				B[A.start]=C;
				B[A.limit]=this.pageSize;
				B['id']=hospSelecter.getValue();
				B['repdr']=repdr;
				if(this.fireEvent("beforechange",this,B)!==false){
					this.store.load({params:B});
				}
			}

		});


		//==========================================================���==========================================================
		var formPanel = new Ext.grid.GridPanel({
			store: findCommTabDs,
			cm: findCommTabCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			tbar:['��ѡ�����:',hospSelecter],
			bbar: findCommTabPagingToolbar
		});
		//============================================================����========================================================
		var window = new Ext.Window({
			title: 'δ��ӵ�����',
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
//findCommTabDs.load({params:{start:0, limit:findCommTabPagingToolbar.pageSize,id:1,repdr:repdr}});
			window.show();
			hospSelecter.on("select",function(cmb,rec,id ){
				findCommTabDs.load({params:{start:0, limit:findCommTabPagingToolbar.pageSize,id:cmb.getValue(),repdr:repdr}});
			});
		};