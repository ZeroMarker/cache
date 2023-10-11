/// 名称: 医护人员-医院关联
/// 编写者: 基础数据平台组-高姗姗
/// 编写日期: 2015-1-27
//document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"></script>');
	 
	var Query_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCareProvHospitals&pClassQuery=GetList";
  	var Save_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTCareProvHospitals&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTCareProvHospitals";
  	var Delete_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCareProvHospitals&pClassMethod=DeleteData";
	var Open_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCareProvHospitals&pClassMethod=OpenData";
  	var Hosp_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHospital&pClassQuery=GetDataForCmb1";
    
 	var pagesize_pop =  Ext.BDP.FunLib.PageSize.Pop;
 	var pagesize_combo=  Ext.BDP.FunLib.PageSize.Combo;

  /******************************添加关联的医院***********************************************/
	var Add=function(){
		var tempCode = Ext.getCmp("txtHospital").getValue();
		if (tempCode=="") {
			Ext.Msg.show({ title : '提示', msg : '医院不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
  			return;
		}
		WinFormHosp.form.submit({
			clientValidation : true, // 进行客户端验证
			waitMsg : '正在提交数据请稍后...',
			waitTitle : '提示',
			url : Save_ACTION_URL,
			method : 'POST',
			success : function(form, action) {
				if (action.result.success == 'true') {
					var myrowid = action.result.id;																							
					Ext.Msg.show({
								title : '提示',
								msg : '添加成功!',
								icon : Ext.Msg.INFO,
								buttons : Ext.Msg.OK,
								fn : function(btn) {
									var totalnum=gridCTCareProvHosp.getStore().getTotalCount();
									HospStore.baseParams={ParRef:Ext.getCmp("HOSPParRef").getValue()};
									HospStore.load({
									    params:{start : 0, limit : pagesize_pop}
									});	 
									Ext.getCmp('txtHospital').reset();
								}
						});
					
				} else {
					var errorMsg = '';
					if (action.result.errorinfo) {
						errorMsg = '<br/>错误信息:' + action.result.errorinfo
					}
					Ext.Msg.show({
									title : '提示',
									msg : '添加失败!' + errorMsg,
									minWidth : 200,
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK
								});
						}			
			},
			failure : function(form, action) {
				Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
			}
		})
	};
	/********************************修改医院关联****************************************************/
	var Update=function(){
		if (gridCTCareProvHosp.selModel.hasSelection()) {
			var tempCode = Ext.getCmp("txtHospital").getValue();
			if (tempCode=="") {
				Ext.Msg.show({ title : '提示', msg : '医院不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
	  			return;
			}
			Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
				if (btn == 'yes') {
					var HOSPRowId = gridCTCareProvHosp.getSelectionModel().getSelections()[0].get('HOSPRowId');
					WinFormHosp.form.submit({
						clientValidation : true, // 进行客户端验证
						waitMsg : '正在提交数据请稍后...',
						waitTitle : '提示',
						url : Save_ACTION_URL,
						params:{'HOSPRowId':HOSPRowId },
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								Ext.Msg.show({
									title : '提示',
									msg : '修改成功!',
									icon : Ext.Msg.INFO,
									buttons : Ext.Msg.OK,
									fn : function(btn) {
										 var totalnum=gridCTCareProvHosp.getStore().getTotalCount();
										 HospStore.baseParams={ParRef:Ext.getCmp("HOSPParRef").getValue()};
										 HospStore.load({
										    params:{start : 0, limit : pagesize_pop}
										 });	 
										 Ext.getCmp('txtHospital').reset();
									}
								});
							} else {
								var errorMsg = '';
								if (action.result.errorinfo) {
									errorMsg = '<br/>错误信息:' + action.result.errorinfo
								}
								Ext.Msg.show({
									title : '提示',
									msg : '修改失败!' + errorMsg,
									minWidth : 200,
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK
								});
								}			
						},
						failure : function(form, action) {
							Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
						}
					})
				}
			}, this);
		}else{
			Ext.Msg.show({
				title : '提示',
				msg : '请选择需要修改的行!',
				icon : Ext.Msg.WARNING,
				buttons : Ext.Msg.OK
			});
		}
	};
	/***********************************删除关联的医院***********************************************/
	var Delete=function(){
		if (gridCTCareProvHosp.selModel.hasSelection()) {
		 	Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						var records =  gridCTCareProvHosp.getSelectionModel().getSelections();
						Ext.Ajax.request({
										url:Delete_ACTION_URL,
										method:'POST',
										params:{
											'id':records[0].get('HOSPRowId')   //删除医嘱项过敏源关联
									},
							callback:function(options, success, response){
								if(success){
									var jsonData = Ext.util.JSON.decode(response.responseText);
									Ext.getCmp('txtHospital').reset();
									if (jsonData.success == 'true')
									{  		
										//var myrowid = action.result.id;                
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												HospStore.baseParams={ParRef:Ext.getCmp("HOSPParRef").getValue()};
												HospStore.load({ 
												    params:{start : 0, limit : pagesize_pop}
												});	 
										       	
											}
										});
									}
									else {
											var errorMsg = '';
											if (jsonData.info) {
												errorMsg = '<br/>错误信息:'+ jsonData.info
											}
											Ext.Msg.show({
														title : '提示',
														msg : '数据删除失败！' + errorMsg,
														minWidth : 200,
														icon : Ext.Msg.ERROR,
														buttons : Ext.Msg.OK,
														fn : function(btn){
															HospStore.baseParams={ParRef:Ext.getCmp("HOSPParRef").getValue()};
															HospStore.load({ 
															    params:{start : 0, limit : pagesize_pop}
															});	 
													       	
														}
													});
										}
											
						 	 	  }else{
										Ext.Msg.show({
											title : '提示',
											msg : '异步通讯失败,请检查网络连接！',
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
								}
							 }
						})
					}
			},this);
		}else{
			Ext.Msg.show({
				title : '提示',
				msg : '请选择需要删除的行!',
				icon : Ext.Msg.WARNING,
				buttons : Ext.Msg.OK
			});
		} 
	};
	/****************************************维护面板*******************************************/
	var WinFormHosp = new Ext.form.FormPanel({
		    xtype:'form',
		    region:'south',
		    //title:'医院关联维护',
	        collapsible: false,
	      	id: 'formHosp',
	        labelAlign : 'right',
	        height: 100,
	        split: true,
	        frame: true,
	        labelWidth:80,
	        reader: new Ext.data.JsonReader({root:'data'},
                        [{name: 'HOSPRowId',mapping:'HOSPRowId',type:'string'},
                         {name: 'HOSPParRef',mapping:'HOSPParRef',type:'string'},
                         {name: 'HOSPHospitalDR',mapping:'HOSPHospitalDR',type:'string'}
                   ]),
	        xtype:'fieldset',
	        items:[{
	        border:false,
	       	items:[{ 
        	layout : "column",  
        	items : [{
          				 fieldLabel: 'HOSPRowId',
					     hideLabel:'True',
					     hidden : true,
					     name: 'HOSPRowId'
          			},{
						 id : 'HOSPParRef',
						 xtype : 'textfield',
						 fieldLabel : 'HOSPParRef',
						 name : 'HOSPParRef',
						 hideLabel : 'True',
						 hidden : true
					},{
	      				 columnWidth : .45, // 该列有整行中所占百分比
	      				 layout : "form", // 从上往下的布局
	      				 items : [{
								xtype:'bdpcombo',
								loadByIdParam : 'rowid',
								fieldLabel : '医院',
								name : 'HOSPHospitalDR',
								id:'txtHospital',
								style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('txtHospital')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('txtHospital'),
								store : new Ext.data.Store({
									autoLoad: true,
									proxy : new Ext.data.HttpProxy({ url : Hosp_ACTION_URL }),
									reader : new Ext.data.JsonReader({
												totalProperty : 'total',
												root : 'data',
												successProperty : 'success'
											}, [ 'HOSPRowId', 'HOSPDesc' ])
								}),
								queryParam : 'desc',
								//triggerAction : 'all',
								forceSelection : true,
								selectOnFocus : false,
								listWidth : 250,
								valueField : 'HOSPRowId',
								displayField : 'HOSPDesc',
								hiddenName : 'HOSPHospitalDR',
								pageSize : Ext.BDP.FunLib.PageSize.Combo
							  }]
					       }]
	       				}]
	        }],
	        buttonAlign:'center', 
	        buttons:[{  
	        		id:'btn_Add',
	        		disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_Add'),
	                text:'添加',
	                iconCls : 'icon-add',
	                width: 60,
	                handler: function (){
						Add()
					}
	            },
	            {  
	            	id:'btn_Update',
	            	disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_Update'),
	                text:'修改',
	                iconCls : 'icon-update',
	                width: 60,
	                handler: function (){ 
	                	Update();
	                }  
	            }, {  
	            	id:'btn_del',
	            	disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_del'),
	                text:'删除',
	                iconCls : 'icon-delete',
	                width: 60,
	                handler: function (){ 
	                  Delete();
	               }  
	            },{				
	            	id:'btn_Refresh',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_Refresh'),
					text:'重置',
					iconCls : 'icon-refresh',
					handler:function(){
						HospStore.baseParams={ParRef:Ext.getCmp("HOSPParRef").getValue()};
						HospStore.load({ 
						    params:{start : 0, limit : pagesize_pop}
						});	 
 				    	Ext.getCmp('txtHospital').setValue("");																
						var linenum=gridCTCareProvHosp.getSelectionModel().lastActive;  //取消选择行
						gridCTCareProvHosp.getSelectionModel().deselectRow(linenum)
					}
				}]
    	});
    /********************************医院关联的存储store********************************************************/
	var HospStore = new Ext.data.Store({
	    proxy: new Ext.data.HttpProxy({url:Query_ACTION_URL}), 
	    reader: new Ext.data.JsonReader({
	        	totalProperty: 'total',
	        	root: 'data',
	        	successProperty :'success'
	    	},[	{name: 'HOSPRowId', mapping:'HOSPRowId',type: 'string'},
	       		{name: 'HOSPHospitalDR', mapping:'HOSPHospitalDR',type: 'string'},
	       		{name: 'HOSPDesc', mapping:'HOSPDesc',type: 'string'}      
			]),
		    remoteSort: true
	 });
	HospStore.load({
    	params:{start : 0, limit : pagesize_pop, ParRef:Ext.getCmp("HOSPParRef").getValue()},
    	callback: function(records, options, success){
	   }
	}); //加载数据
	/** 加载前设置参数 */
	HospStore.on('beforeload',function() {
					var gsm = gridCTCareProvHosp.getSelectionModel();// 获取选择列
					var rows = gsm.getSelections();// 根据选择列获取到所有的行
					Ext.apply(HospStore.lastOptions.params, {
				    	ParRef:Ext.getCmp("HOSPParRef").getValue()
				    });
			},this);
	var paging= new Ext.PagingToolbar({
            pageSize: pagesize_pop,
            store: HospStore,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录 一共 {2} 条',
            emptyMsg: "没有记录",
			plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
			listeners : {
				"change":function (t,p) {
					pagesize_pop=this.pageSize;
				}
			}
        });		
    var sm = new Ext.grid.CheckboxSelectionModel({singleSelect: true, checkOnly: false, width: 20});
  	var gridCTCareProvHosp = new Ext.grid.GridPanel({
		id:'gridCTCareProvHosp',
		region: 'center',
		width:700,
		height:800,
		closable:true,
	    store: HospStore,
	    trackMouseOver: true,
	    columns: [
	            sm,
	            { header: 'HOSPRowId', width: 80, sortable: true, dataIndex: 'HOSPRowId', hidden:true},
	            { header: '医院DR', width: 80, sortable: true, dataIndex: 'HOSPHospitalDR',hidden:true },
	            { header: '医院', width: 160, sortable: true, dataIndex: 'HOSPDesc' }
	         ],
	    stripeRows: true,
	    columnLines : true, //在列分隔处显示分隔符
	    stateful: true,
	    viewConfig: { forceFit: true },
		bbar:paging ,
		stateId: 'gridCTCareProvHosp'
	});
	
	Ext.BDP.FunLib.ShowUserHabit(gridCTCareProvHosp,"User.CTCareProvHosp");
	
	gridCTCareProvHosp.on("rowclick",function(grid,rowIndex,e){
		var record = gridCTCareProvHosp.getSelectionModel().getSelections();
	   	Ext.getCmp("formHosp").getForm().reset();
        Ext.getCmp("formHosp").getForm().load({
            url : Open_ACTION_URL + '&id=' + record[0].get('HOSPRowId'),
            success : function(form,action) {
            },
            failure : function(form,action) {
            	Ext.Msg.alert('编辑', '载入失败');
            }
        });
   });  
   var hospPanel=new Ext.Panel({
		layout:'border',
		frame:true,
		items:[gridCTCareProvHosp,WinFormHosp]
	});
/*var hospPanel=new Ext.Panel({
	items:[gridCTCareProvHosp,
				{
	                region: 'south',
	                title:'医院关联维护',
	                collapsible: true,
	                split: true,
	                height:110,
	                layout: 'fit', // specify layout manager for items
	                items: WinFormHosp
	             }]
});*/
function getCTCareProvHospPanel(){
	var winCTCareProvHosp = new Ext.Window({
			title:'',
			width:700,
            height:450,
			layout:'fit',
			plain:true,//true则主体背景透明
			modal:true,
			frame:true,
			//autoScroll: true,
			collapsible:true,
			hideCollapseTool:true,
			titleCollapse: true,
			bodyStyle:'padding:3px',
			buttonAlign:'center',
			closeAction:'hide',
            labelWidth:55,
			items: hospPanel,
			listeners:{
				"show":function(){
				},
				"hide":function(){
				},
				"close":function(){
				}
			}
		});
  	return winCTCareProvHosp;
  	
}
