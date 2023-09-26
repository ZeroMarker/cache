
    // create the Data Store
    var specialParamds = new Ext.data.Store({
    		id:'specialParamds',
        proxy: new Ext.data.HttpProxy({
            url: 'dhc.ca.indistrulesexe.csp?action=listrule'
        }),
        reader: new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: 'results'
        }, [
            'rowid',
          	'code',
            'name',
			'shortcut',
			'flag',
			'active'
        ]),

        
        remoteSort: true
    });
    //specialParamds.on('beforeload', function(){if (specialUnitLocPanel.getSelections().length>0) var parentselectedRow = specialUnitLocPanel.getSelections()[0].id;else {parentselectedRow='0||0';}specialParamds.baseParams = {parent:parentselectedRow};});



    var cm = new Ext.grid.ColumnModel([
	{
		header: '代码',
		dataIndex: 'code',
		width: 60,
		align: 'left',
		sortable: true
    },
	{
        header: '名称',
        dataIndex: 'name',
        width: 200,
        align: 'left',
        sortable: true
    },
	{
        header: '规则标志',
        dataIndex: 'flag',
        width: 100,
        align: 'left',
        sortable: true
    },
    {
        header: "有效",
        dataIndex: 'active',
        width: 60,
        sortable: true,
        renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    	}
    }

	]);


    // by default columns are sortable
    cm.defaultSortable = true;

    var menubar = [
    		{
				text: '增加',
				id:'loctypeadd',
        		tooltip:'增加收入分配规则',        
        		iconCls:'add',
				//disabled:true,
		        handler: function(){      
		        	addLocsFun(specialParamds, specialParamPanel ,specialParamPagingToolbar);        
		        }
			},'-',
			{
				text: '修改',
				tooltip:'修改收入分配规则',        
				iconCls:'add',
				handler: function(){            				
					editLocsFun(specialParamds, specialParamPanel, specialParamPagingToolbar);        
				}
			},'-',
			{
		        text:'删除',
		        tooltip:'删除选定的收入分配规则',
		        iconCls:'remove',
				disabled:true,
				id:'locdel',
		        handler: function(){            
	    				var selectedRow = specialParamPanel.getSelections();				
    					if (selectedRow.length < 1){
     						Ext.MessageBox.show({title: '提示',msg: '请选择一个数据！',buttons: Ext.MessageBox.OK,icon: Ext.MessageBox.INFO});
    						return false;
    					}  
						var tmpRowid=selectedRow[0].get("RowId");						
						Ext.MessageBox.confirm('提示', 
							'确定要删除选中的数据?', 
							function(btn) {
								if(btn == 'yes')
								{		
									var tmpRow = specialParamPanel.getSelections();
									var tmpSRowid=tmpRow[0].get("RowId");	
									Ext.Ajax.request({
										url:'dhc.ca.indistrulesexe.csp?action=delparam&id='+tmpRowid,
										waitMsg:'删除中...',
										failure: function(result, request) {
											Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
										},
										success: function(result, request) {
											var jsonData = Ext.util.JSON.decode( result.responseText );
											if (jsonData.success=='true') {		
												message='删除成功!';
												Ext.Msg.show({title:'注意', msg:message, icon:Ext.MessageBox.INFO, buttons:Ext.Msg.OK});
												specialParamds.load({params:{start:0, limit:specialUnitLocPagingToolbar.pageSize,id:tmpSRowid}});
												//specialUnitDs.load({params:{start:0, limit:0}});
											}else{		
												Ext.Msg.show({
													title:'错误',
													msg:jsonData.info,
													buttons: Ext.Msg.OK,
													icon:Ext.MessageBox.ERROR
												});
													
											}
										},
										scope: this
									});	
									
								}
							} 
						);
		        }
			}
		];



	specialParamRulessfieldname='name';
	specialParamRulesfilteritem = new Ext.Toolbar.MenuButton({
						text: '过滤器',
						tooltip: '关键字所属类别',
						menu: {items: [
							new Ext.menu.CheckItem({ text: '组名', value: 'code', checked: false, group: 'filter',checkHandler: specialParamRulesonItemCheck }),
							new Ext.menu.CheckItem({ text: '是否有效', value: 'name', checked: true, group: 'filter', checkHandler: specialParamRulesonItemCheck })
						]}
  });

    // Update search button text with selected item
	function specialParamRulesonItemCheck(item, checked)
	{
		if(checked) {
			specialParamRulessfieldname=item.value;
			specialParamRulesfilteritem.setText(item.text + ':');
		}
	}

////
	searchbox = new Ext.form.TwinTriggerField({
	    width: 120
	    , trigger1Class: 'x-form-clear-trigger'
	    , trigger2Class: 'x-form-search-trigger'
	    ,emptyText:'搜索...' 
	    ,listeners: {
	        specialkey: {fn:function(field, e) {
	            var key = e.getKey();
	            if(e.ENTER === key) {
	                this.onTrigger2Click();
	            }
	        }}
	    }
	    , grid: this
	    , onTrigger1Click: function() {
	        if(this.getValue()) {
	            this.setValue('');    
							specialParamds.proxy = new Ext.data.HttpProxy({
									url: '../scripts/ext2/tutorial/Right/specialParamRulesQuery.csp?action=list'
			        }),
	            specialParamds.load({params:{start:0, limit:specialParamPagingToolbar.pageSize}});
	        }
	    }
	    , onTrigger2Click: function() {
	        if(this.getValue()) {
							specialParamds.proxy = new Ext.data.HttpProxy({
									url: '../scripts/ext2/tutorial/Right/specialParamRulesQuery.csp?action=list&'+specialParamRulessfieldname+'='+this.getValue()
			        }),
	        		specialParamds.load({params:{start:0, limit:specialParamPagingToolbar.pageSize}});
	        }
	    }
	});       

    var specialParamPagingToolbar = new Ext.PagingToolbar({
		id: 'specialParamPagingToolbar',
		pageSize: 10,
		store: specialParamds,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据"		
	});

	
 
    var specialParamPanel = new Ext.grid.GridPanel({
        //title:'特殊数据分配参数',
        region:'center',
        split:true,
        //collapsible: true,
        containerScroll: true, 
        xtype: 'grid',
        store: specialParamds,
        cm: cm,
        trackMouseOver:true,
        stripeRows: true,
        sm: new Ext.grid.RowSelectionModel({singleSelect:false}),
        loadMask: true,
        viewConfig: {forceFit:true},
        //tbar: menubar,
		bbar: specialParamPagingToolbar
    });
	specialParamPanel.on('rowclick',function(grid,rowIndex,e){
		//单击特殊数据单元后刷新特殊数据单元单元
		var selectedRow = specialParamds.data.items[rowIndex];
		inFiltRulesId = selectedRow.data["rowid"];
		var distRulesFlag = selectedRow.data["flag"];
		if("科室类别"==distRulesFlag){
			inFiltfDeptsGrid.disable();
			specialUnitGrid.enable();
		}if("指定科室"==distRulesFlag){
			specialUnitGrid.disable();
			inFiltfDeptsGrid.enable();
		}
	
		specialUnitDs.load({params:{start:0, limit:specialUnitPagingToolbar.pageSize,parRef:inFiltRulesId}});
		inFiltfDeptsDs.load({params:{start:0, limit:inFiltfDeptsPagingToolbar.pageSize,parRef:inFiltRulesId}});
	});
specialParamds.load({params:{start:0, limit:specialParamPagingToolbar.pageSize}});
