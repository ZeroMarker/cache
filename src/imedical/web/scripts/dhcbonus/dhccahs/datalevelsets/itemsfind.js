CommFindFun = function() {
	if(repdr=="roo"){
		Ext.Msg.show({title:'错误',msg:'此节点不能查看数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	if(leaf)
	{
		Ext.Msg.show({title:'注意',msg:'此节点不能查看数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	//============================================================面板控件=============================================================


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
		fieldLabel: '数据类别',
		store: hospDs,
		valueField: 'Rowid',
		displayField: 'Name',
		typeAhead: false,
		pageSize: 5,
		minChars: 1,
		triggerAction: 'all',
		emptyText: '请选择...',
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
		fieldLabel: '数据类别',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: itemTypeDs,
		valueField: 'rowid',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择数据类别...',
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
    		header: '代码',
			dataIndex: 'itemCode',
			width: 60,
			align: 'left',
			sortable: true
		},
		{
			header: "名称",
			dataIndex: 'itemName',
			width: 200,
			align: 'left',
			sortable: true
		}/*,
		/*{
			header: "电话",
			dataIndex: 'Phone',
			width: 150,
			align: 'left',
			sortable: true
		},
		{
			header: "位置",
			dataIndex: 'Addr',
			width: 150,
			align: 'left',
			sortable: true
		},
		{
			header: "备注",
			dataIndex: 'Remark',
			width: 200,
			align: 'left',
			sortable: true
		},
		{
			header: "启用日期",
			dataIndex: 'Start',
			width: 80,
			align: 'left',
			sortable: true,
			renderer: formatDate
		},
		{
			header: "停用日期",
			dataIndex: 'End',
			width: 80,
			align: 'left',
			sortable: true,
			renderer: formatDate
		}*/
	]);



		var findCommTabPagingToolbar = new Ext.PagingToolbar({//分页工具栏
			pageSize: 10,
			store: findCommTabDs,
			displayInfo: true,
			displayMsg: '当前显示{0} - {1}，共计{2}',
			emptyMsg: "没有数据",
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


		//==========================================================面板==========================================================
		var formPanel = new Ext.grid.GridPanel({
			store: findCommTabDs,
			cm: findCommTabCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			tbar:['请选择类别:',hospSelecter],
			bbar: findCommTabPagingToolbar
		});
		//============================================================窗口========================================================
		var window = new Ext.Window({
			title: '未添加的数据',
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
					text: '取消',
					handler: function(){window.close();}
				}]
			});
//findCommTabDs.load({params:{start:0, limit:findCommTabPagingToolbar.pageSize,id:1,repdr:repdr}});
			window.show();
			hospSelecter.on("select",function(cmb,rec,id ){
				findCommTabDs.load({params:{start:0, limit:findCommTabPagingToolbar.pageSize,id:cmb.getValue(),repdr:repdr}});
			});
		};