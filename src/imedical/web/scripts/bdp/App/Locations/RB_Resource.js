 
Ext.onReady(function() {
    Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	var ACTION_URL = "../csp/ext.websys.querydatatrans.csp?pClassName=web.DHCBL.CT.RBResource&pClassQuery=GetList";
	var SELECT_ACTION_URL = "../csp/ext.websys.datatrans.csp?pClassName=web.DHCBL.CT.RBResource&pClassMethod=SelectSingle";
	var UPDATA_ACTION_URL = "../csp/ext.websys.datatrans.csp?pClassName=web.DHCBL.CT.RBResource&pClassMethod=Updata";
	var SAVE_ACTION_URL = "../csp/ext.websys.datatrans.csp?pClassName=web.DHCBL.CT.RBResource&pClassMethod=SaveEntity";
	var DELETE_ACTION_URL = "../csp/ext.websys.datatrans.csp?pClassName=web.DHCBL.CT.RBResource&pClassMethod=DeleteData";

    //Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	
	

    var btnDel = new Ext.Toolbar.Button({
        text: '删除',
        tooltip: '删除',
        iconCls: 'icon-delete',
        id:'del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
        handler: function() {
			if(grid.selModel.hasSelection()){
			Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
				if(btn=='yes'){
					Ext.MessageBox.wait('数据删除中,请稍候...','提示');
					Ext.Ajax.request({
						url:DELETE_ACTION_URL,
						method:'POST',
						params:{
							'id':Ext.getCmp("form-spec").getForm().getValues().RowId
						},
						callback:function(options, success, response){
							Ext.MessageBox.hide();
							if(success){
								var jsonData = Ext.util.JSON.decode(response.responseText);
								if(jsonData.success == 'true'){
									Ext.Msg.show({
										title:'提示',
										msg:'数据删除成功!',
										icon:Ext.Msg.INFO,
										buttons:Ext.Msg.OK,
										fn:function(btn){
											arcimForm.getForm().reset();
											var startIndex = grid.getBottomToolbar().cursor;
											grid.getStore().load({params:{start:startIndex, limit:20}});
										}
									});
								}
								else{
									var errorMsg ='';
									if(jsonData.info){
										errorMsg='<br />错误信息:'+jsonData.info
									}
									Ext.Msg.show({
										title:'提示',
										msg:'数据删除失败!'+errorMsg,
										minWidth:200,
										icon:Ext.Msg.ERROR,
										buttons:Ext.Msg.OK
									});
								}
							}
							else{
								Ext.Msg.show({
									title:'提示',
									msg:'异步通讯失败,请检查网络连接!',
									icon:Ext.Msg.ERROR,
									buttons:Ext.Msg.OK
								});
							}
						}
					},this);
				}
			},this);
		}
		else{
			Ext.Msg.show({
				title:'提示',
				msg:'请选择需要删除的行!',
				icon:Ext.Msg.WARNING,
				buttons:Ext.Msg.OK
			});
		}
        }
    });
    var arcimForm1 = new Ext.form.FormPanel({
	    id: 'form-spec-save',
        title: '数据信息',
        // region: 'west',
        labelAlign: 'left',
        width: 200,
        split: true,
        frame: true,
		
        defaults: { width: 140, bosrder: false },
        defaultType: 'textfield',
        items: [
            {
                fieldLabel: 'RES_RowId1',
                hideLabel:'True',
                hidden : true,
                name: 'RES_RowId1'
            },{
                fieldLabel: '代码',
                name: 'Code',
                id:'CodeF',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('CodeF')
                
            }, {
                fieldLabel: '名称',
                name: 'DescTest',
                id:'DescTestF',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('DescTestF')
            }, {
                xtype: 'datefield',
                fieldLabel: '开始日期',
                name: 'DateFrom',
                 id:'DateFromF',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('DateFromF'),
				format: 'm/d/Y' 
            }, {
                xtype:'datefield',
                fieldLabel: '结束日期',
                name: 'DateTo',
				format: 'm/d/Y' ,
				id:'DateToF',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('DateToF')
            }
        ]        
    });
	var tabs = new Ext.TabPanel({
			id:'tabDetail',
			region: 'center',
            //margins:'3 3 3 0',
			activeTab: 0,
			resizeTabs:true, // turn on tab resizing
			minTabWidth: 80,
			tabWidth:120,
			animScroll:true,
			enableTabScroll:true,
			border:false,
			frame:true,
			defaults:{autoScroll:true},	
			items:[arcimForm1]
		});
	var win = new Ext.Window({
			title:'',
			width:350,
            height:350,
			layout:'fit',
			plain:true,//true则主体背景透明
			modal:true,
			frame:true,
			autoScroll: true,
			collapsible:true,
			hideCollapseTool:true,
			titleCollapse: true,
			bodyStyle:'padding:3px',
			buttonAlign:'center',
			closeAction:'hide',
            labelWidth:55,   
			items: tabs,
			buttons:[{
				text:'保存',
				id:'save_btn',
  				disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
				handler: function() {
				    if(win.title=="添加")
					{
			 		Ext.MessageBox.wait('数据增加中,请稍候...','提示');
					Ext.Ajax.request({
						url:SAVE_ACTION_URL,
						method:'POST',
						params:{
							'Code':Ext.getCmp("form-spec-save").getForm().getValues().Code,
							'DescTest':Ext.getCmp("form-spec-save").getForm().getValues().DescTest,
							'DateFrom':Ext.getCmp("form-spec-save").getForm().getValues().DateFrom,
							'DateTo':Ext.getCmp("form-spec-save").getForm().getValues().DateTo
						},
						callback:function(options, success, response){
						//	Ext.MessageBox.hide();
							if(success){
								var jsonData = Ext.util.JSON.decode(response.responseText);
								if(jsonData.success == 'true'){
								    win.hide();
									Ext.Msg.show({
										title:'提示',
										msg:'增加成功!',
										icon:Ext.Msg.INFO,
										buttons:Ext.Msg.OK,
										fn:function(btn){										
											var startIndex = grid.getBottomToolbar().cursor;
											grid.getStore().load({params:{start:startIndex, limit:20}});
										}
									});
								}
								else{
									var errorMsg ='';
									if(jsonData.info){
										errorMsg='<br />错误信息:'+jsonData.info
									}
									Ext.Msg.show({
										title:'提示',
										msg:'数据增加失败!'+errorMsg,
										minWidth:200,
										icon:Ext.Msg.ERROR,
										buttons:Ext.Msg.OK
									});
								}
						    }
						 }
					},this)
					}
					else
					{
						Ext.MessageBox.confirm('提示','确定要修改该条数据吗?',function(btn){
							if(btn=='yes'){
								Ext.MessageBox.wait('数据修改中,请稍候...','提示');
								Ext.Ajax.request({
									url:UPDATA_ACTION_URL,
									method:'POST',
									params:{
										//'EditId':grid.selModel.getSelected().json[0],
										'rowid':Ext.getCmp("form-spec-save").getForm().getValues().RowId,
										'Code':Ext.getCmp("form-spec-save").getForm().getValues().Code,
										'DescTest':Ext.getCmp("form-spec-save").getForm().getValues().DescTest,
										'DateFrom':Ext.getCmp("form-spec-save").getForm().getValues().DateFrom,
										'DateTo':Ext.getCmp("form-spec-save").getForm().getValues().DateTo
									},
									callback:function(options, success, response){
										Ext.MessageBox.hide();
										if(success){
											var jsonData = Ext.util.JSON.decode(response.responseText);
											if(jsonData.success == 'true'){
											    win.hide();
												Ext.Msg.show({
													title:'提示',
													msg:'数据修改成功!',
													icon:Ext.Msg.INFO,
													buttons:Ext.Msg.OK,
													fn:function(btn){										
														var startIndex = grid.getBottomToolbar().cursor;
														grid.getStore().load({params:{start:startIndex, limit:20}});
													}
												});
											}
											else{
												var errorMsg ='';
												if(jsonData.info){
													errorMsg='<br />错误信息:'+jsonData.info
												}
												Ext.Msg.show({
													title:'提示',
													msg:'数据修改失败!'+errorMsg,
													minWidth:200,
													icon:Ext.Msg.ERROR,
													buttons:Ext.Msg.OK
												});
											}
										}
										else{
											Ext.Msg.show({
												title:'提示',
												msg:'异步通讯失败,请检查网络连接!',
												icon:Ext.Msg.ERROR,
												buttons:Ext.Msg.OK
											});
										}
									}
								},this);
							}
						},this);
	
                    }
					
			}
			},{
				text:'取消',
				handler:function(){
					win.hide();
				}
			}],
			listeners:{
				"show":function(){
				},
				"hide":function(){
				},
				"close":function(){
				}
			}
		});
    var btnAddwin = new Ext.Toolbar.Button({
        text: '添加',
        tooltip: '添加',
        iconCls: 'icon-add',
        id:'add_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
        handler: function() {
			win.setTitle('添加');
			win.setIconClass('icon-add');
			win.show('new1');
        },
        scope: this
    });
    var btnEditwin = new Ext.Toolbar.Button({
        text: '修改',
        tooltip: '修改',
        iconCls: 'icon-plugin',
        id:'update_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
        handler: function() {
        if(grid.selModel.hasSelection()){
				var record = grid.getSelectionModel().getSelected();//records[0]
				Ext.getCmp("form-spec-save").getForm().loadRecord(record);
				win.setTitle('修改');
			    win.setIconClass('icon-plugin');
			    win.show('');
		}
        else
		{
		Ext.Msg.show({
					title:'提示',
					msg:'请选择需要修改的行!',
					icon:Ext.Msg.WARNING,
					buttons:Ext.Msg.OK
				});
		}		
			
        }
    });
	var arcimForm = new Ext.form.FormPanel({
	    id: 'form-spec',
        title: '数据信息',
        // region: 'west',
        labelAlign: 'left',
        width: 200,
        split: true,
        frame: true,
        defaults: { width: 140, bosrder: false },
        defaultType: 'textfield',

        items: [
            {
                fieldLabel: 'RES_RowId1',
                hideLabel:'True',
                hidden : true,
                name: 'RES_RowId1'
            },{
                fieldLabel: '代码',
                name: 'Code'
            }, {
                fieldLabel: '名称',
                name: 'DescTest'
            }, {
                xtype: 'datefield',
                fieldLabel: '开始日期',
                name: 'DateFrom',
				format: 'm/d/Y' 
            }, {
                xtype:'datefield',
                fieldLabel: '结束日期',
                name: 'DateTo',
				format: 'm/d/Y' 
            }
        ] , buttonAlign:'center',//按钮对其方式  
        buttons:[  
            {  
                text:'查询',
                handler: function (){  }               
            },  
            {  
                text:'重置',
                handler: function (){ arcimForm.getForm().reset(); } 
            
                }]           
		// }
                    
    });
    var ds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_URL}),//调用的动作
        reader: new Ext.data.JsonReader({
            	totalProperty: 'total',
            	root: 'record',
            	successProperty :'success'
        	},
	  [{ name: 'RES_RowId1', mapping:'RES_RowId1',type: 'string'},
           { name: 'CTLOC_Desc', mapping:'CTLOC_Desc',type: 'string'},
	   { name: 'CTPCP_Desc', mapping:'CTPCP_Desc',type: 'string'},
           { name: 'RES_Code',mapping:'RES_Code', type: 'string' },         
           { name: 'RES_Desc', mapping:'RES_Desc',type: 'date', dateFormat: 'm/d/Y' },
           { name: 'RES_ScheduleRequired',mapping:'RES_ScheduleRequired', type: 'date', dateFormat: 'm/d/Y' },
	   { name: 'RES_DateTo', mapping:'RES_DateTo',type: 'string'},
           { name: 'RES_AdmittingRights',mapping:'RES_AdmittingRights', type: 'string' },  
	   { name: 'RES_DateActiveFrom', mapping:'RES_DateActiveFrom',type: 'string'}//列的映射
			]),
		remoteSort: true
    });	
	ds.load({
    	params:{start:0, limit:20},
    	callback: function(records, options, success){
		}
	}); //加载数据
	var paging= new Ext.PagingToolbar({
            pageSize: 20,
            store: ds,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录"
        })		
    var sm = new Ext.grid.CheckboxSelectionModel({singleSelect: true, checkOnly: false, width: 20});
// create the Grid
    var grid = new Ext.grid.GridPanel({
	id:'grid',
	region: 'center',
	width:900,
	height:500,
	closable:true,
    store: ds,
    trackMouseOver: true,
    tools:Ext.BDP.FunLib.Component.HelpMsg,
    columns: [
            sm,
            { header: 'RES_RowId1', width: 160, sortable: true, dataIndex: 'RES_RowId1'},
            { header: '科室', width: 160, sortable: true, dataIndex: 'CTLOC_Desc' },
	        { header: '医护人员', width: 160, sortable: true, dataIndex: 'CTPCP_Desc' },   
            { header: '代码', width: 85, sortable: true, dataIndex: 'RES_Code' },
	        { header: '描述', width: 160, sortable: true, dataIndex: 'RES_Desc' },
            { header: '需要排班', width: 85, sortable: true, dataIndex: 'RES_ScheduleRequired' },
	        { header: '资源截止日期', width: 160, sortable: true, renderer: Ext.util.Format.dateRenderer('m/d/Y'), dataIndex: 'RES_DateTo' },
            { header: '管理权', width: 85, sortable: true, dataIndex: 'RES_AdmittingRights' },
            { header: '激活开始日期', width: 85, sortable: true, renderer: Ext.util.Format.dateRenderer('m/d/Y'), dataIndex: 'RES_DateActiveFrom' }
        ],
    stripeRows: true,
    loadMask: { msg: '数据加载中,请稍候...' },
    sm: new Ext.grid.RowSelectionModel({
                    singleSelect: true,
                    listeners: {
                        rowselect: function(sm, row, rec) {
                            Ext.getCmp("form-spec").getForm().loadRecord(rec);
                        }
                    }
                }),
    
    title: '医生专长',
    // config options for stateful behavior
    stateful: true,
    viewConfig: {
			forceFit: true
		},
		bbar:paging ,
		tbar: {
			enableOverflow: true,
			
			items:[btnAddwin, '-', btnEditwin, '-', btnDel]//,'->',{text:'刷新',iconCls:'icon-arrowrefresh'}
		},
		
    stateId: 'grid'
    
});
	grid.on("rowdblclick",function(grid,rowIndex,e){  
                    var row=grid.getStore().getAt(rowIndex).data;  
                var record = grid.getSelectionModel().getSelected();//records[0]
				Ext.getCmp("form-spec-save").getForm().loadRecord(record);
				//win.show();
				win.setTitle('修改');
			    win.setIconClass('icon-plugin');
			    win.show(''); 
                      
                });  
	
	//var gridname=Ext.getCmp(Request);
    var viewport = new Ext.Viewport({
        layout: 'border',
        items: [grid         
          ]
    });
	
	

});
