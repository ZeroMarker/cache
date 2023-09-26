var deptMeasDevFun = function(dataStore,grid,pagingTool,unitSelecter,dataItemSelecter) {
	var unitDr=unitSelecter.getValue();
	var dataItemDr=dataItemSelecter.getValue();
	
	if(unitDr==""){
		Ext.Msg.show({title:'注意',msg:'请选择单位后再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	
	if(dataItemDr==""){
		Ext.Msg.show({title:'注意',msg:'请选择数据类别后再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	
	var deptDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	
	var dept = new Ext.form.ComboBox({
		id: 'dept',
		fieldLabel: '部门',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: deptDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择部门...',
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
	    		header: '序号',
	        dataIndex: 'order',
	        width: 60,
	        align: 'left',
	        sortable: true
	    },
		 	{
	    		header: '代码',
	        dataIndex: 'code',
	        width: 60,
	        align: 'left',
	        sortable: true
	    },
	    {
	        header: "备注",
	        dataIndex: 'remark',
	        width: 200,
	        align: 'left',
	        sortable: true
	    },
	        {
	        header: "启用时间",
	        dataIndex: 'startTime',
	        width: 80,
	        align: 'left',
	        sortable: true,
	        renderer: formatDate
	    },
	    {
	        header: "停用时间",
	        dataIndex: 'stop',
	        width: 80,
	        align: 'left',
	        sortable: true,
	        renderer: formatDate
	    },
	    {
	        header: "有效",
	        dataIndex: 'active',
	        width: 50,
	        sortable: true,
	        renderer : function(v, p, record){
	        	p.css += ' x-grid3-check-col-td'; 
	        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	    	}
	    }
	]);

		var unitMeasDevPagingToolbar = new Ext.PagingToolbar({//分页工具栏
			pageSize: 25,
			store: unitMeasDevDs,
			displayInfo: true,
			displayMsg: '当前显示{0} - {1}，共计{2}',
			emptyMsg: "没有数据",
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
			title: '查看部门计量表计',
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
					text: '取消',
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