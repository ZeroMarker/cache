var mainUrl = '../csp/herp.srm.srmitemdictexe.csp?action=list';
var projUrl = 'herp.srm.srmitemdictexe.csp';
var tmpNode = "";

var addButton = new Ext.Toolbar.Button
(
	{
		text: '新增',
    	//tooltip:'添加',        
    	iconCls: 'edit_add',
		handler:function()
		{	
			var tmpRowid = "";
			var tmpLeaf = "";
			var tmpCode = "";
			var tmpLevel = 0;
			var tmpYear = "";
			var tmpYearID = "";

			if (tmpNode!="") 
			{
				tmpRowid = tmpNode.attributes["Rowid"];
				tmpYearID = tmpNode.attributes["YearID"];
				tmpYear = tmpNode.attributes["Year"];
				tmpLeaf =  tmpNode.attributes["leaf"];
				tmpHavLeaf =  tmpNode.attributes["HavLeaf"];
				tmpCode = tmpNode.attributes["Code"];
				tmpLevel = parseInt(tmpNode.attributes["Level"])+1;
			}
			if(tmpLeaf)
			{
				Ext.Msg.show({title:'错误',msg:'末级不能添加子节点!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
			else
			{
				//年度
				var YearDs = new Ext.data.Store
				(
					{
						autoLoad: true,
						proxy: "",
						reader: new Ext.data.JsonReader
						(
							{	
								totalProperty: 'results',
								root: 'rows'
							},
							['rowid','name']
						)
					}
				); 

				YearDs.on
				(
					'beforeload', function(ds, o)
					{
						ds.proxy=new Ext.data.HttpProxy
						(
							{
								url: projUrl+'?action=yearList&str='+encodeURIComponent(Ext.getCmp('uAddYearCombo').getRawValue()),
								method: 'POST'
							}
						);
					}
				);

				var uAddYearCombo = new Ext.form.ComboBox
				(
					{
						id: 'uAddYearCombo',
						fieldLabel: '年度',
						width: 200,
						listWidth: 250,
						allowBlank: true,
						store: YearDs,
						valueField: 'rowid',
						displayField: 'name',
						triggerAction: 'all',
						////emptyText: '请选择年度...',
						name: 'uAddYearCombo',
						minChars: 1,
						pageSize: 10,
						selectOnFocus: true,
						forceSelection: 'true',
						editable: true,
						value: tmpYear,
						labelSeparator:''	 
					}
				);
				
				var uAddIsLastField = new Ext.form.Checkbox
				(
					{												
						fieldLabel: '末级',
						labelSeparator:''
					}
				);
			
				var uAddCodeField = new Ext.form.TextField
				(
					{
						id: 'uAddCodeField',
						fieldLabel: '科目编码',
						width: 200,
						allowBlank: false,
						name: 'uAddCodeField',
						selectOnFocus: 'true',
						labelSeparator:''
					}
				);
				
				var uAddNameField = new Ext.form.TextField
				(
					{
						id: 'uAddNameField',
						fieldLabel: '科目名称',
						width: 200,
						allowBlank: false,
						name: 'uAddNameField',
						selectOnFocus: 'true',
						labelSeparator:''
					}
				);
				
				var uAddBottomLineField = new Ext.form.NumberField
				(
					{
						id: 'uAddBottomLineField',
						fieldLabel: '最低占比(%)',
						width: 200,
						allowBlank: true,
						name: 'uAddBottomLineField',
						selectOnFocus: 'true',
						//xtype: 'numberfield',
						regex: /^\d+(\.\d{1,2})?$/,
						//regex: /(^[1-9]?\d$)|(^100$)/,
						regexText: "请输入有效数字",
						maxValue:100,
						minValue:0,
						labelSeparator:''
					}
				);
				
				var uAddTopPercentField = new Ext.form.NumberField
				(
					{
						id: 'uAddTopPercentField',
						fieldLabel: '最高占比(%)',
						width: 200,
						allowBlank: true,
						name: 'uAddTopPercentField',
						selectOnFocus: 'true',
						//xtype: 'numberfield',
						regex: /^\d+(\.\d{1,2})?$/,
						regexText: "请输入有效数字",
						maxValue:100,
						minValue:0,
						labelSeparator:''
					}
				);
				
				var uAddDescField = new Ext.form.TextField
				(
					{
						id: 'uAddDescField',
						fieldLabel: '说明',
						width: 200,
						allowBlank: true,
						name: 'uAddDescField',
						selectOnFocus: 'true',
						labelSeparator:''
					}
				);
			
				var colItems =	
				[
					{
						layout: 'column',
						border: false,
						defaults: 
						{
							columnWidth: '.9',
							bodyStyle: 'padding:5px 5px 0',
							border: false
						},            
						items: 
						[
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: 
								[
									uAddYearCombo,				
									uAddCodeField,				
									uAddNameField,													
									uAddBottomLineField,	
									uAddTopPercentField,				
									uAddDescField,
									uAddIsLastField					
								]
							} 
						]
					}
				]			
			
				var formPanel = new Ext.form.FormPanel
				(
					{
						//baseCls: 'x-plain',
						labelWidth: 80,
						//layout: 'form',
						frame: true,
						items: colItems
					}
				);
	
				addButton = new Ext.Toolbar.Button
				(
					{
						text:'保存',
						iconCls: 'save'
					}
				);
				
				formPanel.on
				(
					'afterlayout', function(panel, layout)
					{			
						if(tmpNode!="")
						{
							if(tmpYear=="")
							{
								Year=uAddYearCombo.getValue();
							}
							else
							{
								uAddYearCombo.setValue(tmpYearID);
								uAddYearCombo.setRawValue(tmpYear);
							}	
							uAddCodeField.setValue(tmpCode);
						}	
					}
				);
				
				
				addHandler = function()
				{							
					var Year = uAddYearCombo.getValue();
					var Code = uAddCodeField.getValue();	
					var Name = uAddNameField.getValue();
					var IsLast = uAddIsLastField.getValue();
					var data1 = Year+"*"+Code+"*"+Name+"*"+IsLast

					if(IsLast)
					{
						IsLast = 1
					}
					else
					{
						IsLast = 0
					}
					
					var BottomLine = uAddBottomLineField.getValue();
					var TopPercent = uAddTopPercentField.getValue();
					var Desc = uAddDescField.getValue();
					
					if (Year=="")
					{
						{Ext.Msg.show({title:'错误',msg:'年度不能为空!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
					}
					if (Code=="")
					{
						{Ext.Msg.show({title:'错误',msg:'科目编码不能为空!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
					}
					if (Name=="")
					{
						{Ext.Msg.show({title:'错误',msg:'科目名称不能为空!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
					}
					if ((TopPercent*1) < (BottomLine*1))
					{
						{Ext.Msg.show({title:'错误',msg:'最高占比不能小于最低占比!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
					}
				
					var data = Year+"|"+Code+"|"+Name+"|"+tmpCode+"|"+tmpLevel+"|"+IsLast+"|"+BottomLine+"|"+TopPercent+"|"+Desc
					//alert("jici");
					if(formPanel.form.isValid())
					{
						Ext.Ajax.request
						(
							{
								url: projUrl+'?action=add&data='+encodeURIComponent(data),
								waitMsg:'保存中...',
								failure: function(result, request)
								{
									Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
								success: function(result, request)
								{
									var jsonData = Ext.util.JSON.decode(result.responseText);
									if (jsonData.success=='true')
									{
										Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
										/* if(tmpNode=="")
										{
											mainGrid.root.reload();
										}
										else
										{
											mainGrid.loader.load(tmpNode);
											tmpNode.expand(true);
										} */	
										if (mainGrid.getSelectionModel().getSelectedNode() == null || mainGrid.getSelectionModel().getSelectedNode().id == null) {
											mainGrid.root.reload();
										} else {
												mainGrid.getNodeById(mainGrid.getSelectionModel().getSelectedNode().id).reload();
										}
										tmpNode = "";										
										addwin.close();
										//mainGrid.root.reload();
										//mainGrid.tmpNode.reload();
										
									}
									else
									{
										var tmpMsg = jsonData.info;
										Ext.Msg.show({title:'错误',msg:tmpMsg,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									}
								},
								scope: this
							}
						);
					}
					else
					{
						Ext.Msg.show({title:'错误',msg:'请修正页面上的错误!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				}
			
				addButton.addListener('click',addHandler,false);
	
				cancelButton = new Ext.Toolbar.Button
				(
					{
						text:'关闭',
						iconCls : 'cancel'
					}
				);
			
				cancelHandler = function()
				{
					addwin.close();
				}
			
				cancelButton.addListener('click',cancelHandler,false);
	
				addwin = new Ext.Window
				(
					{
						title: '新增科研项目科目信息',
						iconCls: 'edit_add',
						width: 380,						
						height: 300,
						atLoad: true,
						layout: 'fit',
						plain: true,
						modal: true,
						bodyStyle: 'padding:5px;',
						buttonAlign: 'center',
						items: formPanel,
						buttons: [addButton,cancelButton]
					}
				);		
				addwin.show();			
			}	
		}
	}
);

var editButton = new Ext.Toolbar.Button
(
	{
		text: '修改',
    	//tooltip: '修改',        
    	iconCls: 'pencil',
		handler: function()
		{
			if(tmpNode=="")
			{
				Ext.Msg.show({title:'错误',msg:'没有选择节点!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}
			else
			{
				var tmprowid = tmpNode.attributes["rowid"];
				var tmpYear = tmpNode.attributes["Year"];
				var tmpYearID = tmpNode.attributes["YearID"];
				var tmpLeaf = tmpNode.attributes["leaf"];
				var tmpCode = tmpNode.attributes["Code"];
				var tmpName = tmpNode.attributes["Name"];
				var tmpBottomLine = tmpNode.attributes["BottomLine"];
				var tmpTopPercent = tmpNode.attributes["TopPercent"];
				var tmpDesc = tmpNode.attributes["Desc"];
				var tmpIsLast = tmpNode.attributes["IsLast"];
							
				if(tmpIsLast=="是")
				{
					tmpIsLast = true
				}
				else
				{
					tmpIsLast = false
				}
				
				//年度
				var YearDs = new Ext.data.Store
				(
					{
						autoLoad: true,
						proxy: "",
						reader: new Ext.data.JsonReader
						(
							{	
								totalProperty: 'results',
								root: 'rows'
							},
							['rowid','name']
						)
					}
				); 

				YearDs.on
				(
					'beforeload', function(ds, o)
					{
						ds.proxy=new Ext.data.HttpProxy
						(
							{
								url: projUrl+'?action=yearList&str='+encodeURIComponent(Ext.getCmp('uEditYearCombo').getRawValue()),
								method: 'POST'
							}
						);
					}
				);

				var uEditYearCombo = new Ext.form.ComboBox
				(
					{
						id: 'uEditYearCombo',
						fieldLabel: '年度',
						width: 200,
						listWidth: 250,
						allowBlank: true,
						store: YearDs,
						valueField: 'rowid',
						displayField: 'name',
						triggerAction: 'all',
						//emptyText: '请选择年度...',
						name: 'uEditYearCombo',
						minChars: 1,
						pageSize: 10,
						selectOnFocus: true,
						forceSelection: 'true',
						editable: true,
						value: tmpYear,
						labelSeparator:''	 
					}
				);
				
				var uEditIsLastField = new Ext.form.Checkbox
				(
					{												
						fieldLabel: '末级',
						labelSeparator:''
					}
				);
			
				var uEditCodeField = new Ext.form.TextField
				(
					{
						id: 'uEditCodeField',
						fieldLabel: '科目编码',
						width: 200,
						allowBlank: false,
						name: 'uEditCodeField',
						selectOnFocus: 'true',
						labelSeparator:''
					}
				);
				
				var uEditNameField = new Ext.form.TextField
				(
					{
						id: 'uEditNameField',
						fieldLabel: '科目名称',
						width: 200,
						allowBlank: false,
						name: 'uEditNameField',
						selectOnFocus: 'true',
						labelSeparator:''
					}
				);
				
				var uEditBottomLineField = new Ext.form.NumberField
				(
					{
						id: 'uEditBottomLineField',
						fieldLabel: '最低占比(%)',
						width: 200,
						allowBlank: true,
						name: 'uEditBottomLineField',
						selectOnFocus: 'true',
						regex: /^\d+(\.\d{1,2})?$/,
						regexText: "请输入有效数字",
						maxValue:100,
						minValue:0,
						labelSeparator:''
					}
				);
				
				var uEditTopPercentField = new Ext.form.NumberField
				(
					{
						id: 'uEditTopPercentField',
						fieldLabel: '最高占比(%)',
						width: 200,
						allowBlank: true,
						name: 'uEditTopPercentField',
						selectOnFocus: 'true',
						regex: /^\d+(\.\d{1,2})?$/,
						regexText: "请输入有效数字",
						maxValue:100,
						minValue:0,
						labelSeparator:''
					}
				);
				
				var uEditDescField = new Ext.form.TextField
				(
					{
						id: 'uEditDescField',
						fieldLabel: '说明',
						width: 200,
						allowBlank: true,
						name: 'uEditDescField',
						selectOnFocus: 'true',
						labelSeparator:''
					}
				);	
													
				var colItems =	
				[
					{
						layout: 'column',
						border: false,
						defaults: 
						{
							columnWidth: '.9',
							bodyStyle: 'padding:5px 5px 0',
							border: false
						},            
						items: 
						[
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: 
								[
									uEditYearCombo,				
									uEditCodeField,				
									uEditNameField,				
									uEditBottomLineField,	
									uEditTopPercentField,				
									uEditDescField,
									uEditIsLastField
								]
							}
						]
					}
				]			
			
				var formPanel = new Ext.form.FormPanel
				(
					{
						//baseCls: 'x-plain',
						labelWidth: 80,
						//layout: 'form',
						frame: true,
						items: colItems
					}
				);
			
				formPanel.on
				(
					'afterlayout', function(panel,layout)
					{
						this.getForm().loadRecord(tmpNode);
						uEditYearCombo.setValue(tmpYearID);
						uEditYearCombo.setRawValue(tmpYear);
			
						uEditCodeField.setValue(tmpCode);
						uEditNameField.setValue(tmpName);
						uEditBottomLineField.setValue(tmpBottomLine);
						uEditTopPercentField.setValue(tmpTopPercent);
						uEditDescField.setValue(tmpDesc);
						uEditIsLastField.setValue(tmpIsLast);							
					}
				);	
	
				editButton = new Ext.Toolbar.Button
				(
					{
						text:'保存',
						iconCls: 'save'
					}
				);

				addHandler = function()
				{
					var Year = uEditYearCombo.getValue();
					var Code = uEditCodeField.getValue();	
					var Name = uEditNameField.getValue();
					var IsLast = uEditIsLastField.getValue();
					if(IsLast)
					{
						IsLast = 1
					}
					else
					{
						IsLast = 0
					}
					var BottomLine = uEditBottomLineField.getValue();
					var TopPercent = uEditTopPercentField.getValue();
					var Desc = uEditDescField.getValue();
					
					if ((TopPercent*1) < (BottomLine*1))
					{
						{Ext.Msg.show({title:'错误',msg:'最高占比不能小于最低占比!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
					}
					if (Year=="")
					{
						{Ext.Msg.show({title:'错误',msg:'年度不能为空!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
					}
					if (Code=="")
					{
						{Ext.Msg.show({title:'错误',msg:'科目编码不能为空!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
					}
					if (Name=="")
					{
						{Ext.Msg.show({title:'错误',msg:'科目名称不能为空!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
					}
					
					var data = Year+"|"+Code+"|"+Name+"|||"+IsLast+"|"+BottomLine+"|"+TopPercent+"|"+Desc
				
					if(formPanel.form.isValid())
					{
						Ext.Ajax.request
						(
							{
								url: projUrl+'?action=edit&rowid='+tmprowid+'&data='+encodeURIComponent(data),
								waitMsg: '保存中...',
								failure: function(result, request)
								{
									Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
								success: function(result, request)
								{
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true')
									{
										Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
										if(IsLast==1)
										{
											/* var tmpPar=tmpNode.parentNode;
											mainGrid.loader.load(tmpPar);
											tmpPar.expand(false); */
											mainGrid.getNodeById(mainGrid.getSelectionModel().getSelectedNode().parentNode.id).reload();
										}
										else
										{	
											//mainGrid.root.reload();
											mainGrid.getNodeById(mainGrid.getSelectionModel().getSelectedNode().parentNode.id).reload();
										} 
										//var tmpPar=tmpNode.parentNode;
										//mainGrid.getNodeById(mainGrid.getSelectionModel().getSelectedNode().parentNode.id).reload();
										tmpNode = "";
										editwin.close();
									}
									else
									{
										var tmpMsg = jsonData.info;
										if(tmpMsg=="HaveSub")
										{
											Ext.Msg.show({title:'错误',msg:'含有子项不能修改为"末级"!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
										}
										else
										{
											Ext.Msg.show({title:'错误',msg:tmpMsg,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
										}
									}
								},
								scope: this
							}
						);
					}
					else
					{
						Ext.Msg.show({title:'错误',msg:'请修正页面上的错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				}
			
				editButton.addListener('click',addHandler,false);
	
				cancelButton = new Ext.Toolbar.Button
				(
					{
						text:'关闭',
						iconCls : 'cancel'
					}
				);
			
				cancelHandler = function()
				{
					editwin.close();
				}
			
				cancelButton.addListener('click',cancelHandler,false);
	
				editwin = new Ext.Window
				(
					{
						title: '修改科研项目科目信息',
						iconCls: 'pencil',
						width: 380,
						height: 300,
						//autoHeight: true,
						layout: 'fit',
						plain: true,
						modal: true,
						bodyStyle: 'padding:5px;',
						buttonAlign: 'center',
						items: formPanel,
						buttons: [editButton,cancelButton]
					}
				);		
				editwin.show();
			}
		}
	}
);

var delButton = new Ext.Toolbar.Button
(
	{
		text: '删除',
    	//tooltip: '删除',        
    	iconCls: 'edit_remove',
		handler: function(id)
		{
			var tmpRowid = "";
			var tmpLeaf = "";
			if(tmpNode!="") 
			{
				tmpRowid = tmpNode.attributes["rowid"];
				tmpYear = tmpNode.attributes["YearID"];
				tmpLeaf = tmpNode.attributes["leaf"];
				tmpHavLeaf = tmpNode.attributes["HavLeaf"];
				tmpCode = tmpNode.attributes["Code"];		
				//alert(tmpLeaf);
				function handler(id)
				{
					if(id=="yes")
					{
						Ext.Ajax.request
						(
							{
								url: projUrl+'?action=del&rowid='+tmpRowid+'&year='+tmpYear+'&code='+tmpCode,
								waitMsg: '删除中...',
								failure: function(result, request)
								{
									Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
								success: function(result, request)
								{
									var jsonData = Ext.util.JSON.decode(result.responseText);
									if (jsonData.success=='true')
									{
										Ext.Msg.show({title:'注意',msg:'删除成功!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										tmpNode.remove();
										tmpNode.expand(false);
									}
									else
									{
										Ext.Msg.show({title:'错误',msg:'删除失败!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									}
								},
								scope: this							
							}
						);
					}
					else
					{
						return;
					}
				}
				if((tmpLeaf)||(tmpHavLeaf=="false"))
				{
					Ext.MessageBox.confirm('提示','确实要删除吗?',handler);
				}
				else
				{	
					if(tmpHavLeaf=="true")
					Ext.MessageBox.confirm('提示','含有子节点,确实要删除吗?',handler);
				}					
			
			}	
			else
			{
				Ext.Msg.show({title:'错误',msg:'请选择数据!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}
		}
	}
);

var expandAllButton = new Ext.Toolbar.Button
(
	{
		text: '全部展开',
    	//tooltip: '全部展开',        
    	iconCls: 'expand',
		handler: function()
		{
			mainGrid.getRootNode().expand(true);
		}
	}
);

//批量复制
var CopyButton = new Ext.Toolbar.Button
(
	{
		text: '复制',
		//tooltip: '复制一年数据到另一年',
		iconCls: 'copy',
		handler: function()
		{
			CopyFun();
		}
	}
);

var mainGrid = new Ext.ux.tree.TreeGrid
(
	{
    	title: '科研项目科目信息维护',
    	iconCls: 'list',
		region: 'center',
    	enabled: true,
		//autoScroll: true,
    	columns:
    	[
    		{
        		header: '科目名称',
        		dataIndex: 'Name',
        		width: 180
    		},
    		{
        		header: '科目编码',
        		dataIndex: 'Code',
        		width: 100
    		},
    		{
        		header: '年度',
        		dataIndex: 'Year',
        		width: 80
    		},
    		{
        		header: '上级科目',
        		dataIndex: 'SuperCode',
        		width: 180
    		},
    		{
        		header: '级次',
        		dataIndex: 'Level',
        		width: 80
    		},
    		{
        		header: '是否末级',
        		dataIndex: 'IsLast',
        		width: 80
    		},
    		{
        		header: '最低占比(%)',
        		dataIndex: 'BottomLine',
        		align: 'right',
        		width: 100,
        		renderer: function(val)
         		{
	         		val=val.replace(/(^\s*)|(\s*$)/g, "");
	         		val=Ext.util.Format.number(val,'0.00');
	         		val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         		return val?val:'';
		 		}
    		},
    		{
        		header: '最高占比(%)',
        		dataIndex: 'TopPercent',
        		align: 'right',
        		width: 100,
        		renderer: function(val)
         		{
	         		val=val.replace(/(^\s*)|(\s*$)/g, "");
	         		val=Ext.util.Format.number(val,'0.00');
	         		val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         		return val?val:'';
		 		}
		 	},
    		{
        		header: '说明',
        		dataIndex: 'Desc',
        		width: 180
    		}   		
    	],

    	requestUrl: mainUrl,
	
		listeners: 
		{
        	'beforeload': function(node)
        	{
            	if (node.isRoot) 
            	{
                	this.loader.dataUrl = this.requestUrl + "&rnode=";
            	}
            	else
            	{ 
                	var nodeText = node.attributes["Code"];
                	var Year = node.attributes["YearID"];
                	var rqtUrl = this.requestUrl + "&year=" + Year + "&rnode=" + encodeURIComponent(nodeText);
                	if (node.attributes.loader.dataUrl) 
                	{
                    	this.loader.dataUrl = rqtUrl
                	}
            	}
            	this.root.attributes.loader = null;
        	},	
			'reload': function(node)
        	{
            	if (node.isRoot) 
            	{
                	this.loader.dataUrl = this.requestUrl + "&rnode=";
            	}
            	else
            	{ 
                	var nodeText = node.attributes["Code"];
                	var Year = node.attributes["YearID"];
                	var rqtUrl = this.requestUrl + "&year=" + Year + "&rnode=" + encodeURIComponent(nodeText);
                	if (node.attributes.loader.dataUrl) 
                	{
                    	this.loader.dataUrl = rqtUrl
                	}
            	}
            	this.root.attributes.loader = null;
        	},			
			'click': function(node, e) 
			{
				tmpNode = node;
			}
    	},
    		
		tbar:[addButton,'-',editButton,'-',delButton,'-',expandAllButton,'-',CopyButton]
		
	}
);