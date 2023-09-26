CommFindFun = function() {
	
	if(repdr == "roo")
	{
		Ext.Msg.show({title:'ע��',msg:'�˽ڵ㲻������ʵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	//============================================================���ؼ�=============================================================


	var findCommTabProxy = new Ext.data.HttpProxy({url: deptLevelSetsUrl + '?action=listloc'});

	function formatDate(value){
		return value ? value.dateFormat('Y-m-d') : '';
	};
	
	var findCommTabDs = new Ext.data.Store({
		proxy: findCommTabProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, [
			'rowId',
			'code',
			'name',
			'shortcut',
			'address',
			'remark',
			{name:'startTime',type:'date',dateFormat:'Y-m-d'},
			{name:'stop',type:'date',dateFormat:'Y-m-d'}
		]),
		remoteSort: true
	});

	//--------------------------------
	var unitTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	var unitType = new Ext.form.ComboBox({
		id: 'unitType',
		fieldLabel: '��Ԫ���',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: unitTypeDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ��Ԫ���...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	unitTypeDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=unitType&searchValue='+Ext.getCmp('unitType').getRawValue(),method:'GET'});
	});

	var unitsDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	var units = new Ext.form.ComboBox({
		id: 'units',
		fieldLabel: '��Ԫ',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: unitsDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ��Ԫ...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	unitType.on("select",function(cmb,rec,id ){
		units.setRawValue("");
		units.setValue("");
		unitsDs.load({params:{start:0, limit:cmb.pageSize,id:cmb.getValue()}});
		
	});
	unitsDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=units&searchValue='+Ext.getCmp('units').getRawValue()+'&id='+unitType.getValue(),method:'GET'});
	});
	//--------------------------------
	
	var findCommTabCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
	 	{
    		header: '����',
			dataIndex: 'code',
			width: 60,
			align: 'left',
			sortable: true
		},
		{
			header: "����",
			dataIndex: 'name',
			width: 200,
			align: 'left',
			sortable: true
		},
		{
			header: "λ��",
			dataIndex: 'address',
			width: 150,
			align: 'left',
			sortable: true
		},
		{
			header: "��ע",
			dataIndex: 'remark',
			width: 200,
			align: 'left',
			sortable: true
		},
		{
			header: "��������",
			dataIndex: 'startTime',
			width: 80,
			align: 'left',
			sortable: true,
			renderer: formatDate
		},
		{
			header: "ͣ������",
			dataIndex: 'stop',
			width: 80,
			align: 'left',
			sortable: true,
			renderer: formatDate
		}
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
				B['id']=units.getValue();
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
			tbar:['��ѡ��λ���:',unitType,'��ѡ��λ:',units],
			bbar: findCommTabPagingToolbar
		});
		//============================================================����========================================================
		var window = new Ext.Window({
			title: 'δ��ӵĲ���',
			width: 1100,
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
			units.on("select",function(cmb,rec,id ){
				findCommTabDs.load({params:{start:0, limit:findCommTabPagingToolbar.pageSize,id:cmb.getValue(),repdr:repdr}});
			});
		};