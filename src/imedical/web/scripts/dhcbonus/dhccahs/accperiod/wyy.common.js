/*
 * Version 0.1 
 * Ext JS Library 2.1 
 * 2009.11.23 
 * wyy
 */
 

///////////////
//2009.11.24//
/////////////
var onePageSize = 25;


/*
///////////////
//2009.11.23//
/////////////
Ext.ux.wyySearchBox = Ext.extend(Ext.form.TwinTriggerField, {
			wyyDataStore : '',
			wyyURL : '',
			wyySearchField : '',
			pageSize : onePageSize,
			width : 180,
			trigger1Class : 'x-form-clear-trigger',
			trigger2Class : 'x-form-search-trigger',
			emptyText : '搜索...',
			listeners : {
				specialkey : {
					fn : function(field, e) {
						var key = e.getKey();
						if (e.ENTER === key) {
							this.onTrigger2Click();
						}
					}
				}
			},
			grid : this,
			onTrigger1Click : function() {
				if (this.getValue()) {
					this.setValue('');
					this.wyyDataStore.proxy = new Ext.data.HttpProxy({
								url : this.wyyURL
							});
					this.wyyDataStore.load({
								params : {
									start : 0,
									limit : this.pageSize
								}
							});
				}
			},
			onTrigger2Click : function() {
				if (this.getValue()) {
					this.wyyDataStore.proxy = new Ext.data.HttpProxy({
								url : this.wyyURL + '&searchField='
										+ this.wyySearchField + '&searchValue='
										+ this.getValue()
							});
					this.wyyDataStore.load({
								params : {
									start : 0,
									limit : this.pageSize
								}
							});
				}
			}
		});
*/


///////////////
//2009.11.24//
/////////////
Ext.ux.wyyPagingToolbar = Ext.extend(Ext.PagingToolbar, {//for bbar
			wyyDataStore : '',
			wyyFilterSearchBox : '',
			pageSize : onePageSize,
			displayInfo : true,
			displayMsg : '当前显示{0} - {1}，共计{2}',
			emptyMsg : "没有数据",
			initComponent : function() {
				this.store = this.wyyDataStore;
				this.buttons = this.wyyFilterSearchBox;
				Ext.ux.wyyPagingToolbar.superclass.initComponent.call(this);
			}
		});
		
		
///////////////
//2009.11.24//
/////////////
wyyRepErrFun = function(jsonDataInfo) {
	var message = "";
	message = "SQLErr: " + jsonDataInfo;
	if (jsonDataInfo == 'RepOrder')
		message = '输入的顺序已经存在!';
	if (jsonDataInfo == 'RepCode')
		message = '输入的代码已经存在!';
	if (jsonDataInfo == 'RepName')
		message = '输入的名称已经存在!';
	Ext.Msg.show({
				title : '错误',
				msg : message,
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.ERROR
			});
};


///////////////
//2009.11.24//
/////////////
wyyAddFun = function(wyyItemsArray, wyyWinTitle, wyyUrl, wyyDataStore) {
	
	var formPanelItems = new Array();   
	var formPanelItemsNum = 0;
	for(i=0;i<wyyItemsArray.length;i++){
		if(wyyItemsArray[i].ignoreAdd==true){
			//ignore
		}else{
			if(wyyItemsArray[i].xtype=='textfield'){
				formPanelItems[formPanelItemsNum] = new Ext.form.TextField({                         
		  	  fieldLabel: wyyItemsArray[i].labelName,                                      
		  	  allowBlank:  wyyItemsArray[i].allowBlank,                                      
		  	  emptyText:  wyyItemsArray[i].emptyText,                           
		  	  name:  wyyItemsArray[i].name,                                             
		  	  anchor: wyyItemsArray[i].anchor                                    
				}); 
				formPanelItemsNum++;    
			}else if(wyyItemsArray[i].xtype=='checkbox'){
				formPanelItems[formPanelItemsNum] = new Ext.form.Checkbox({                         
		  	  fieldLabel: wyyItemsArray[i].labelName,                                      
		  	  name:  wyyItemsArray[i].name
		  	 });     
		  	 formPanelItemsNum++;                   
			} 
				 ///////////////////////////
				//add others if necessary//
			 ///////////////////////////	
		}		                       
	}                                

	var formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				labelWidth : 40,
				items : formPanelItems
			});

	var window = new Ext.Window({
		title : wyyWinTitle,
		width : 400,
		height : 300,
		minWidth : 400,
		minHeight : 300,
		iconCls : 'add',
		layout : 'fit',
		plain : true,
		modal : true,
		bodyStyle : 'padding:5px;',
		buttonAlign : 'center',
		items : formPanel,
		buttons : [{
			text : '保存',
			handler : function() {
				
				var tmpUrlExt = '';
				
				for (i = 0; i < formPanelItemsNum; i++) {
					tmpUrlExt = tmpUrlExt + '&' + formPanelItems[i].name + '=' + formPanelItems[i].getValue().trim();
				}

				if (formPanel.form.isValid()) {
					Ext.Ajax.request({
								url : wyyUrl + tmpUrlExt,
								waitMsg : '保存中...',
								failure : function(result, request) {
									Ext.Msg.show({
												title : '错误',
												msg : '请检查网络连接!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
								},
								success : function(result, request) {
									var jsonData = Ext.util.JSON
											.decode(result.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
													title : '注意',
													msg : '添加成功!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO
												});
										wyyDataStore.load({
													params : {
														start : 0,
														limit : onePageSize
													}
												});
									} else {
										wyyRepErrFun(jsonData.info);
									}
								},
								scope : this
							});
				} else {
					Ext.Msg.show({
								title : '错误',
								msg : '请修正页面提示的错误后提交。',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				}
			}
		}, {
			text : '取消',
			handler : function() {
				window.close();
			}
		}]
	});

	window.show();
};


///////////////
//2009.11.24//
/////////////
Ext.ux.wyyAddBtn = Ext.extend(Ext.Toolbar.Button, {
			wyyItemsArray : '',
			wyyWinTitle : '',
			wyyUrl : '',
			wyyDataStore : '',
			text : '添加',
			iconCls : 'add',
			initComponent : function() {
				this.tooltip = this.wyyWinTitle;
				this.handler = function(b, e) {
					wyyAddFun(this.wyyItemsArray, this.wyyWinTitle, this.wyyUrl, this.wyyDataStore);
				};
				Ext.ux.wyyAddBtn.superclass.initComponent.call(this);
			}
		});
		
		
///////////////
//2009.11.26//
/////////////
wyyEditFun = function(wyyItemsArray,wyyWinTitle,wyyUrl,wyyDataStore,rowsSelected,pagingTool) {
	
	myRowid = rowsSelected[0].get('rowId'); 

	var formPanelItems = new Array();   
	
	for(i=0;i<wyyItemsArray.length;i++){
		if(wyyItemsArray[i].xtype=='textfield'){
			formPanelItems[i] = new Ext.form.TextField({          
	  	  fieldLabel: wyyItemsArray[i].labelName,                                      
	  	  allowBlank:  wyyItemsArray[i].allowBlank,                                      
	  	  emptyText:  wyyItemsArray[i].emptyText,                           
	  	  name:  wyyItemsArray[i].name,                                             
	  	  anchor: wyyItemsArray[i].anchor,
	  	  value: rowsSelected[0].get(wyyItemsArray[i].name)                                          
			});     
		}else if(wyyItemsArray[i].xtype=='checkbox'){
			formPanelItems[i] = new Ext.form.Checkbox({         
	  	  fieldLabel: wyyItemsArray[i].labelName,                                      
	  	  name:  wyyItemsArray[i].name,   
	  	  checked: (rowsSelected[0].get(wyyItemsArray[i].name))=='Y'?true:false    
	  	 });                    
		} 
		 ///////////////////////////
		//add others if necessary//
	 ///////////////////////////			                       
	}                                

  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 40,
    items: formPanelItems
	});

  var window = new Ext.Window({
  	title: wyyWinTitle,
    width: 400,
    height:300,
    minWidth: 400,
    minHeight: 300,
    iconCls : 'option',
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
    	text: '保存', 
      handler: function() {
      	
      	var tmpUrlExt = '';
				
				for (i = 0; i < formPanelItems.length; i++) {
					if(formPanelItems[i].getXType() == 'textfield'){
						tmpUrlExt = tmpUrlExt + '&' + formPanelItems[i].name + '=' + formPanelItems[i].getValue().trim();
					}else if(formPanelItems[i].getXType() == 'checkbox'){				
						tmpUrlExt = tmpUrlExt + '&' + formPanelItems[i].name + '=' + ((formPanelItems[i].getValue()==true)?'Y':'N');//() is nesessary
					}else{
						tmpUrlExt = tmpUrlExt + '&' + formPanelItems[i].name + '=' + formPanelItems[i].getValue();
					}
					
				}

        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: wyyUrl+tmpUrlExt+'&id='+myRowid,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									wyyDataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
									window.close();
								}
								else
								{
									wyyRepErrFun(jsonData.info);
								}
							},
					  	scope: this
						});
        	}
        	else{
						Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}             
	    	}
    	},
    	{
				text: '取消',
        handler: function(){
        	window.close();
        	}
      }]
    });
    window.show();

};


///////////////
//2009.11.26//
/////////////
Ext.ux.wyyEditBtn = Ext.extend(Ext.Toolbar.Button, {
	wyyItemsArray : '',
	wyyWinTitle : '',
	wyyUrl : '',
	wyyDataStore : '',
	////////////////////////////////////////////
	//GridPanel.on('click',function(e){   //
	//	editUnittypesButton.wyyGridPanel=this;//
	//});                                     //
	////////////////////////////////////////////
	wyyGridPanel : '',
	wyyPageingToolbar : '',
	text : '修改',
	iconCls : 'option',
	initComponent : function() {
		Ext.ux.wyyEditBtn.superclass.initComponent.call(this);
		this.tooltip = this.wyyWinTitle;
		this.handler = function(b, e) {
			var rs = ((this.wyyGridPanel == '')?'':this.wyyGridPanel.getSelections());
			if(rs == '')
			{
				Ext.Msg.show({title:'注意',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				wyyEditFun(this.wyyItemsArray, this.wyyWinTitle, this.wyyUrl, this.wyyDataStore, rs, this.wyyPageingToolbar);
			}
		};	
	}
});


///////////////
//2009.11.26//
/////////////
wyyDelFun = function(wyyUrl,dataStore,rowsSelected,pagingTool) {
	
	myRowid = rowsSelected[0].get('rowId'); 
	               
	Ext.MessageBox.confirm('提示', 
		'确定要删除选定的行?', 
		function(btn) {
			if(btn == 'yes'){	
				Ext.Ajax.request({
					url: wyyUrl+'&id='+myRowid,
					waitMsg:'删除中...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') { 
							dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
						}else {
							var message = "SQLErr: " + jsonData.info;
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
	  		}
		} 
	);	
};


///////////////
//2009.11.26//
/////////////
Ext.ux.wyyDelBtn = Ext.extend(Ext.Toolbar.Button, {
	wyyUrl : '',
	wyyDataStore : '',
	////////////////////////////////////////////
	//GridPanel.on('click',function(e){   //
	//	Ext.ux.editUnittypesButton.wyyGridPanel=this;//
	//});                                     //
	////////////////////////////////////////////
	wyyGridPanel : '',
	wyyPageingToolbar : '',
	text : '删除',
	iconCls : 'remove',
	disabled: true,
	initComponent : function() {
		Ext.ux.wyyDelBtn.superclass.initComponent.call(this);
		this.handler = function(b, e) {
			var rs = ((this.wyyGridPanel == '')?'':this.wyyGridPanel.getSelections());
			if(rs == '')                                  
			{
				Ext.Msg.show({title:'注意',msg:'请选择需要删除的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				wyyDelFun(this.wyyUrl, this.wyyDataStore, rs, this.wyyPageingToolbar);
			}
		};	
	}
});


///////////////
//2009.11.26//
/////////////
var getColumnModel = function(wyyItemsArray){
			var tmpCols = new Array();
			tmpCols[0] = new Ext.grid.RowNumberer();
			for(i=0;i<wyyItemsArray.length;i++){
				if(wyyItemsArray[i].xtype == 'textfield'){
					tmpCols[i+1] = {
							header : wyyItemsArray[i].labelName,
							dataIndex : wyyItemsArray[i].name,
							width : 150,
							align : 'left',
							sortable : true
						};    
				}else if(wyyItemsArray[i].xtype == 'checkbox'){
					tmpCols[i+1] = {                            
						header : wyyItemsArray[i].labelName,    
						dataIndex : wyyItemsArray[i].name,      
						width : 40,                              
						sortable : true,
						renderer : function(v, p, record) {
							p.css += ' x-grid3-check-col-td';
							return '<div class="x-grid3-check-col'
									+ (v == 'Y' ? '-on' : '') + ' x-grid3-cc-' + this.id
									+ '">&#160;</div>';
						}                         
					};
				}
				/////////
				//more//
				///////
			}
			return new Ext.grid.ColumnModel(tmpCols);
		};
		
		
///////////////
//2009.11.27//
/////////////		
var getDataStore = function(dataStoreUrl, itemsArray){
			var tmpArray = new Array();
			tmpArray[0] = 'rowId';
			for(i=0;i<itemsArray.length;i++){
				tmpArray[i+1] = itemsArray[i].name;
			}
			return new Ext.data.Store({
								 		proxy : new Ext.data.HttpProxy({
								 									url : dataStoreUrl + '?action=list'
								 								}),
										reader : new Ext.data.JsonReader(
																		{
																			root : 'rows',
																			totalProperty : 'results'
																		},
																		tmpArray
																),
										remoteSort : true,
										sortInfo : {field: tmpArray[0], direction: "DESC"}
									});
		};

/*
///////////////
//2009.11.30//
/////////////	
var getSearchBox = function(dataStore, dataStoreUrl, searchField) {
	return new Ext.form.TwinTriggerField({
				width : 180,
				trigger1Class : 'x-form-clear-trigger',
				trigger2Class : 'x-form-search-trigger',
				emptyText : '搜索...',
				listeners : {
					specialkey : {
						fn : function(field, e) {
							var key = e.getKey();
							if (e.ENTER === key) {
								this.onTrigger2Click();
							}
						}
					}
				},
				grid : this,
				onTrigger1Click : function() {
					if (this.getValue()) {
						this.setValue('');
						dataStore.proxy = new Ext.data.HttpProxy({
									url : dataStoreUrl + '?action=list'
								});
						dataStore.load({
									params : {
										start : 0,
										limit : onePageSize
									}
								});
					}
				},
				onTrigger2Click : function() {
					if (this.getValue()) {
						dataStore.proxy = new Ext.data.HttpProxy({
									url : dataStoreUrl + '?action=list'+ '&searchField='
											+ searchField + '&searchValue='
											+ this.getValue()
								});
						dataStore.load({
									params : {
										start : 0,
										limit : onePageSize
									}
								});
					}
				}
			});
};


var tmpSearchField = 'name';
var getFilterItem = function(itemsArray){			
			var tmpCheckItemsArray = new Array();
			for(i=0;i<itemsArray.length;i++){
				tmpCheckItemsArray[i] = new Ext.menu.CheckItem({
																			text : itemsArray[i].labelName,
																			value : itemsArray[i].name,
																			checked : itemsArray[i].initSearchField,
																			group : 'FilterItems',
																			checkHandler : function(item, checked){
																												if (checked) {
																													tmpSearchField = item.value;
																													tmpFilter.setText(item.text);
																												}
																											}
																		});
			}
			var tmpFilter =  new Ext.Toolbar.SplitButton({
									text : '过滤器',
									tooltip : '关键字类别',
									handler : function(b,e){
															b.showMenu();
														},
									menu : {
														items :tmpCheckItemsArray
													}
								});
				return [tmpSearchField,tmpFilter];
		};

var getFilterSearchBox = function(itemsArray,dataStore, dataStoreUrl){//return array
	var tmpFilterArray = getFilterItem(itemsArray);
	if(tmpFilterArray.length != 2){
		alert('程序出错');
		return;
	}
	var tmpSearchField = tmpFilterArray[0];
	var tmpFilter = tmpFilterArray[1];
	var tmpSearchBox = getSearchBox(dataStore, dataStoreUrl, tmpSearchField);
	tmpFilter.on('menuhide',function(b,m){
			tmpSearchField = getFilterItem(itemsArray)[0];
			tmpSearchBox = getSearchBox(dataStore, dataStoreUrl, tmpSearchField);
			return ['-',tmpFilter,tmpSearchBox];
		});
	return ['-',tmpFilter,tmpSearchBox];
};
*/


///////////////
//2009.11.30//
/////////////	
var getFilterSearchBox = function(itemsArray, dataStoreUrl, dataStore) {//return array
	var tmpSearchField = 'name';
	var tmpCheckItemsArray = new Array();
	for (i = 0; i < itemsArray.length; i++) {
		tmpCheckItemsArray[i] = new Ext.menu.CheckItem({
					text : itemsArray[i].labelName,
					value : itemsArray[i].name,
					checked : itemsArray[i].initSearchField,
					group : 'FilterItems',
					checkHandler : function(item, checked) {
						if (checked) {
							tmpSearchField = item.value;
							tmpFilter.setText(item.text);
						}
					}
				});
	}
	var tmpFilter = new Ext.Toolbar.SplitButton({
				text : '过滤器',
				tooltip : '关键字类别',
				handler : function(b, e) {
					b.showMenu();
				},
				menu : {
					items : tmpCheckItemsArray
				}
			});
	var tmpDefaultProxy = dataStore.proxy;
	var tmpSearchBox = new Ext.form.TwinTriggerField({
				width : 180,
				trigger1Class : 'x-form-clear-trigger',
				trigger2Class : 'x-form-search-trigger',
				emptyText : '搜索...',
				listeners : {
					specialkey : {
						fn : function(field, e) {
							var key = e.getKey();
							if (e.ENTER === key) {
								this.onTrigger2Click();
							}
						}
					}
				},
				grid : this,
				onTrigger1Click : function() {
					if (this.getValue()) {
						this.setValue('');
						dataStore.proxy = tmpDefaultProxy;
						dataStore.load({
									params : {
										start : 0,
										limit : onePageSize
									}
								});
					}
				},
				onTrigger2Click : function() {
					if (this.getValue()) {
						dataStore.proxy = new Ext.data.HttpProxy({
									url : dataStoreUrl + '?action=list'
											+ '&searchField=' + tmpSearchField
											+ '&searchValue=' + this.getValue()
								});
						dataStore.load({
									params : {
										start : 0,
										limit : onePageSize
									}
								});
					}
				}
			});
	return ['-', tmpFilter, tmpSearchBox];
};

