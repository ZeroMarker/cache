
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
		header: '����',
		dataIndex: 'code',
		width: 60,
		align: 'left',
		sortable: true
    },
	{
        header: '����',
        dataIndex: 'name',
        width: 200,
        align: 'left',
        sortable: true
    },
	{
        header: '�����־',
        dataIndex: 'flag',
        width: 100,
        align: 'left',
        sortable: true
    },
    {
        header: "��Ч",
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
				text: '����',
				id:'loctypeadd',
        		tooltip:'��������������',        
        		iconCls:'add',
				//disabled:true,
		        handler: function(){      
		        	addLocsFun(specialParamds, specialParamPanel ,specialParamPagingToolbar);        
		        }
			},'-',
			{
				text: '�޸�',
				tooltip:'�޸�����������',        
				iconCls:'add',
				handler: function(){            				
					editLocsFun(specialParamds, specialParamPanel, specialParamPagingToolbar);        
				}
			},'-',
			{
		        text:'ɾ��',
		        tooltip:'ɾ��ѡ��������������',
		        iconCls:'remove',
				disabled:true,
				id:'locdel',
		        handler: function(){            
	    				var selectedRow = specialParamPanel.getSelections();				
    					if (selectedRow.length < 1){
     						Ext.MessageBox.show({title: '��ʾ',msg: '��ѡ��һ�����ݣ�',buttons: Ext.MessageBox.OK,icon: Ext.MessageBox.INFO});
    						return false;
    					}  
						var tmpRowid=selectedRow[0].get("RowId");						
						Ext.MessageBox.confirm('��ʾ', 
							'ȷ��Ҫɾ��ѡ�е�����?', 
							function(btn) {
								if(btn == 'yes')
								{		
									var tmpRow = specialParamPanel.getSelections();
									var tmpSRowid=tmpRow[0].get("RowId");	
									Ext.Ajax.request({
										url:'dhc.ca.indistrulesexe.csp?action=delparam&id='+tmpRowid,
										waitMsg:'ɾ����...',
										failure: function(result, request) {
											Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
										},
										success: function(result, request) {
											var jsonData = Ext.util.JSON.decode( result.responseText );
											if (jsonData.success=='true') {		
												message='ɾ���ɹ�!';
												Ext.Msg.show({title:'ע��', msg:message, icon:Ext.MessageBox.INFO, buttons:Ext.Msg.OK});
												specialParamds.load({params:{start:0, limit:specialUnitLocPagingToolbar.pageSize,id:tmpSRowid}});
												//specialUnitDs.load({params:{start:0, limit:0}});
											}else{		
												Ext.Msg.show({
													title:'����',
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
						text: '������',
						tooltip: '�ؼ����������',
						menu: {items: [
							new Ext.menu.CheckItem({ text: '����', value: 'code', checked: false, group: 'filter',checkHandler: specialParamRulesonItemCheck }),
							new Ext.menu.CheckItem({ text: '�Ƿ���Ч', value: 'name', checked: true, group: 'filter', checkHandler: specialParamRulesonItemCheck })
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
	    ,emptyText:'����...' 
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
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������"		
	});

	
 
    var specialParamPanel = new Ext.grid.GridPanel({
        //title:'�������ݷ������',
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
		//�����������ݵ�Ԫ��ˢ���������ݵ�Ԫ��Ԫ
		var selectedRow = specialParamds.data.items[rowIndex];
		inFiltRulesId = selectedRow.data["rowid"];
		var distRulesFlag = selectedRow.data["flag"];
		if("�������"==distRulesFlag){
			inFiltfDeptsGrid.disable();
			specialUnitGrid.enable();
		}if("ָ������"==distRulesFlag){
			specialUnitGrid.disable();
			inFiltfDeptsGrid.enable();
		}
	
		specialUnitDs.load({params:{start:0, limit:specialUnitPagingToolbar.pageSize,parRef:inFiltRulesId}});
		inFiltfDeptsDs.load({params:{start:0, limit:inFiltfDeptsPagingToolbar.pageSize,parRef:inFiltRulesId}});
	});
specialParamds.load({params:{start:0, limit:specialParamPagingToolbar.pageSize}});
