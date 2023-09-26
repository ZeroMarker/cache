Ext.onReady(function() {
	Ext.QuickTips.init();

	var sm = new Ext.grid.CheckboxSelectionModel({
				handleMouseDown : Ext.emptyFn
			});

   function CreatDetailGrid(){}

	//主题
	var fusbstore = new Ext.data.Store({
				url : 'dhccrmfurecord1.csp?action=fusblist',
				reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : "rows"
						}, ['FUSRowId', 'FUSCode', 'FUSDesc', 'FUPSRowId'])
			});
			//随访人Strore
	var fuPersonstore=new Ext.data.Store({
		url : 'dhccrmsetplan1.csp?action=fupersonlist',
				reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : "rows"
						}, ['RowID',  'Name'])
	})
	
	fuPersonstore.on('beforeload', function() {
		var UserDesc=Ext.getCmp('fupersoncombo').getRawValue();
		if (UserDesc=="") return;
		fuPersonstore.proxy.conn.url = 'dhccrmsetplan1.csp?action=fupersonlist&UserDesc='+UserDesc;

	});

      

	var subjectrecord = Ext.data.Record.create([{
				name : 'FUSRowId'
			}, {
				name : 'FUSDesc'
			},
			{
				name : 'FUSDetail'
			}]);

	var subjectcm = new Ext.grid.ColumnModel([{
				header : "主题ID",
				dataIndex : 'FUSRowId'
			}, {
				header : "主题名称",
				dataIndex : 'FUSDesc'
			}
			, {
				header : "主题明细",
				dataIndex : 'FUSDetail'
			}]);

	var subjectstore = new Ext.data.Store({
				proxy : new Ext.data.MemoryProxy(),
				reader : new Ext.data.ArrayReader({}, subjectrecord)
			});

									




	var planform = new Ext.form.FormPanel({
		items : [{
			xtype : 'panel',
			layout : 'column',
			items : [{
				xtype : 'panel',
				layout : 'form',
				columnWidth : 1 / 2,
				items : [{
					xtype : 'combo',
					fieldLabel : '随访人',
					allowBlank : false,
					id : 'fupersoncombo',
					name : 'fupersoncombo',
					store : fuPersonstore,
					valueField : 'RowID',
					displayField : 'Name',
					triggerAction : 'all',
					emptyText : '点击选择随访人',
					width : 180,
					//pageSize:10,
					//minListWidth:60,
					
					listeners : {'specialkey':function(obj,e){
						if (e.getKey()==e.ENTER){
						//var UserDesc=obj.getRawValue();
						//obj.store.proxy.conn.url = 'dhccrmsetplan1.csp?action=fupersonlist&UserDesc='+UserDesc;
						//alert(this.store.proxy.conn.url)
						obj.store.load();
						
						}
						}}
					
					
			
				}]

			}, {
				xtype : 'panel',
				layout : 'form',
				columnWidth : 1 / 2,
				items : [{

							xtype : 'datefield',
							allowBlank : false,
							format : 'Y-m-d',
							fieldLabel : '随访日期',
							id : 'fusbDate',
							name : 'fusbDate',
							emptyText : '点击选择随访日期',
							width : 180
						}]

			}, {
				xtype : 'panel',
				layout : 'form',
				columnWidth : 1 / 2,
				items : [{
					xtype : 'combo',
					fieldLabel : '随访主题',
					id : 'fusbcombo',
					name : 'fusbcombo',
					store : fusbstore,
					valueField : 'FUSRowId',
					displayField : 'FUSDesc',
					triggerAction : 'all',
					emptyText : '点击选择主题',
					width : 180,
					//listWidth:250,
					mode : 'local',
                                        
					listeners : {
						focus : function() { 
							this.store.on('beforeload', function() {
								this.proxy.conn.url = 'dhccrmfurecord1.csp?action=fusblist'
							});
							this.store.reload();
						}
					}
				}]

			}, {
				xtype : 'panel',
				layout : 'form',
				columnWidth : 1 / 2,
				items : [{
							xtype : 'button',
							text : '生成计划',
							id : 'CreatePlanButton',
							name : 'CreatePlanButton',
							 handler : function() {
						
						var PAADMStr= "";
						for (i = 0; i < selectedRows.length; i++) 
						{
										
								       						
																				
						}
										
 						var count = subjectstore.getCount();
									
						var FUSRowIdStr=""
						for (var j = 0; j < count; j++) 
						{	var record = subjectstore.getAt(j);
							var FUSRowId= record.data.FUSRowId;
							if (FUSRowIdStr=="")  FUSRowIdStr=FUSRowId
							else {FUSRowIdStr=FUSRowIdStr+"^"+FUSRowId}
						}
 										
						if(FUSRowIdStr=="")
						{
							Ext.Msg.alert("提示", "请选择随访主题!");
							return;
						}
							var Date= Ext.getCmp('fusbDate').getValue()
							var User=Ext.getCmp('fupersoncombo').getValue()
							
							if((Date=="")||(User==""))
						{
							Ext.Msg.alert("提示", "随访人和随访时间必填!");
							return;
						}
 							Date = Date.format('Y-m-d').toString();
							var Seturl = 'dhccrmsetplan1.csp?action=AddPlan'
							+ '&PAADMStr=' + PAADMStr + '&FUSRowIdStr=' + FUSRowIdStr+ '&FUSUser=' + User+ '&FUSDate=' + Date;  
	   
            if (planform.getForm().isValid()) {
                Ext.Ajax.request({
                    url: Seturl,
                    waitMsg: '保存中...',
                    failure: function(result, request){
                        Ext.Msg.show({
                            title: '错误',
                            msg: '请检查网络连接!',
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.ERROR
                        });
                    },
                    success: function(result, request){  
                        var jsonData = Ext.util.JSON.decode(result.responseText);
                        if (jsonData.success == 'true') {
                            Ext.Msg.show({
                                title: '提示',
                                msg: '数据保存成功!',
                                buttons: Ext.Msg.OK,
                                icon: Ext.MessageBox.INFO
                            });
                            
	
			fupstore.proxy.conn.url ='dhccrmsetplan1.csp?action=fuplist'
			fupstore.load({
				params : {
				start : 0,
				limit : 20
						}
				});
                        }
                        else {
                            Ext.MessageBox.show({
                                title: '错误',
                                msg: jsonData.info,
                                buttons: Ext.MessageBox.OK,
                                icon: Ext.MessageBox.ERROR
                            });
                        }
                    },
                    scope: this
                });
            }
		else { 
                Ext.Msg.show({
                    title: '错误',
                    msg: '请修正页面提示的错误后提交',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });

            }	
					

	}		
					
				}]

					
                }]

		}, new Ext.grid.GridPanel({
					id : 'subjectgrid',
					store : subjectstore,
					cm : subjectcm,
					frame : true,
					collapsible : true,
					viewConfig : {
						forceFit : true
					},
					autoHeight : true,
					autoScroll : true
				})]
	});
	




	Ext.getCmp('subjectgrid').on('rowdblclick', function(g, row, e) {
				subjectstore.remove(subjectstore.getAt(row));
			});
	var selectedRows = subjectstore.getSelectionModel().getSelections();
	var FUSRowId = selectedRows[i].data.FUSRowId
	if (FUSRowId!=""){
	}
	CreatDetailGrid();
					
	Ext.getCmp('fusbcombo').on('select', function() {
				var fusrowid = this.getValue();
				var fusdesc = this.getRawValue();
				subjectstore.add(new subjectrecord({
							FUSRowId : fusrowid,
							FUSDesc : fusdesc
						}));
			});

	subjectstore.load({
				add : true
			});

          
	var planpanel = new Ext.Panel({
				region : 'center',
				title : '生成计划',
				height : 280,
				frame : true,
				items : planform

			})
	var mainPanel = new Ext.Viewport({
		layout : 'border',
		items : planpanel
			
		});
	

})

