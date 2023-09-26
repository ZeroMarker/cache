var deptMeasDevFun = function(dataStore,grid,pagingTool,unitSelecter,dataItemSelecter) {
	var unitDr=unitSelecter.getValue();
	var dataItemDr=dataItemSelecter.getValue();
	
	if(unitDr==""){
		Ext.Msg.show({title:'ע��',msg:'��ѡ��λ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	
	if(dataItemDr==""){
		Ext.Msg.show({title:'ע��',msg:'��ѡ��������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	
	var deptDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	
	var dept = new Ext.form.ComboBox({
		id: 'dept',
		fieldLabel: '����',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: deptDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ����...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	deptDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=dept&searchField=shortcut&searchValue='+Ext.getCmp('dept').getRawValue()+'&unitDr='+unitDr,method:'GET'});
	});
	
	var unitMeasDevDs = new Ext.data.Store({
    proxy: new Ext.data.HttpProxy({url: unitMeasDevUrl + '?action=list&unitDr='+unitDr+'&dataItemDr='+dataItemDr}),
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'rowId',
            'order',
						'code',
						'remark',
						{name:'startTime',type:'date',dateFormat:'Y-m-d'},
						{name:'stop',type:'date',dateFormat:'Y-m-d'},
						'unitDr',
						'active'
		]),
    // turn on remote sorting
    remoteSort: true
	});

	unitMeasDevDs.setDefaultSort('rowId', 'Desc');
	
	function formatDate(value){
	    return value ? value.dateFormat('Y-m-d') : '';
	};
	
	var unitMeasDevCm = new Ext.grid.ColumnModel([
		 	new Ext.grid.RowNumberer(),
		 	{
	    		header: '���',
	        dataIndex: 'order',
	        width: 60,
	        align: 'left',
	        sortable: true
	    },
		 	{
	    		header: '����',
	        dataIndex: 'code',
	        width: 60,
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
	        header: "����ʱ��",
	        dataIndex: 'startTime',
	        width: 80,
	        align: 'left',
	        sortable: true,
	        renderer: formatDate
	    },
	    {
	        header: "ͣ��ʱ��",
	        dataIndex: 'stop',
	        width: 80,
	        align: 'left',
	        sortable: true,
	        renderer: formatDate
	    },
	    {
	        header: "��Ч",
	        dataIndex: 'active',
	        width: 50,
	        sortable: true,
	        renderer : function(v, p, record){
	        	p.css += ' x-grid3-check-col-td'; 
	        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	    	}
	    }
	]);

		var unitMeasDevPagingToolbar = new Ext.PagingToolbar({//��ҳ������
			pageSize: 25,
			store: unitMeasDevDs,
			displayInfo: true,
			displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
			emptyMsg: "û������",
			doLoad:function(C){
				var B={},
				A=this.paramNames;
				B[A.start]=C;
				B[A.limit]=this.pageSize;
				B['id']=unitDr;
				B['type']=dept.getValue();
				if(this.fireEvent("beforechange",this,B)!==false){
					this.store.load({params:B});
				}
			}

		});
	
	var formPanel = new Ext.grid.GridPanel({
			store: unitMeasDevDs,
			cm: unitMeasDevCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			tbar:[dept],
			bbar: unitMeasDevPagingToolbar
		});
		
		var window = new Ext.Window({
			title: '�鿴���ż������',
			width: 900,
			height:500,
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
			
			///////////////////////////////////////////////////////////////////////////////////////temp
			//unitMeasDevDs.load({params:{start:0, limit:unitMeasDevPagingToolbar.pageSize}});
			dept.on("select",function(cmb,rec,id ){
					unitMeasDevDs.load({params:{start:0, limit:unitMeasDevPagingToolbar.pageSize,id:unitDr,type:cmb.getValue()}});
			});
			
};