CopyFun = function(itemGrid,deptname) 
{	
	var mainUrl = 'herp.srm.srmitemdictexe.csp';
	
	//年度
	var Year1Ds = new Ext.data.Store
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

	Year1Ds.on
	(
		'beforeload', function(ds, o)
		{
			ds.proxy=new Ext.data.HttpProxy
			(
				{
					url: mainUrl+'?action=yearList&str=',
					method: 'POST'
				}
			);
		}
	);

	var uCopyYear1Combo = new Ext.form.ComboBox
	(
		{
			id: 'uCopyYear1Combo',
			fieldLabel: '被复制年度',
			width: 200,
			listWidth: 250,
			allowBlank: true,
			store: Year1Ds,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			//emptyText: '请选择被复制年度...',
			name: 'uCopyYear1Combo',
			minChars: 1,
			pageSize: 10,
			selectOnFocus: true,
			forceSelection: 'true',
			editable: true,
			labelSeparator:''	 
		}
	);
	
	//年度
	var Year2Ds = new Ext.data.Store
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

	Year2Ds.on
	(
		'beforeload', function(ds, o)
		{
			ds.proxy=new Ext.data.HttpProxy
			(
				{
					url: mainUrl+'?action=yearList&str=',
					method: 'POST'
				}
			);
		}
	);

	var uCopyYear2Combo = new Ext.form.ComboBox
	(
		{
			id: 'uCopyYear2Combo',
			fieldLabel: '复制年度',
			width: 200,
			listWidth: 250,
			allowBlank: true,
			store: Year2Ds,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			//emptyText: '复制年度大于往年年度...',
			name: 'uCopyYear2Combo',
			minChars: 1,
			pageSize: 10,
			selectOnFocus: true,
			forceSelection: 'true',
			editable: true,
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
			  	bodyStyle:'padding:5px 5px 0',
			  	border: false
		  	},
		  	items: 
		  	[		  
			  	{				  	
				 	xtype: 'fieldset',
				  	autoHeight: true,
				  	items: 
				  	[				  		
					  	uCopyYear1Combo,
					  	uCopyYear2Combo
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
			layout: 'form',
			frame: true,
			items: colItems
		}
	);
	
  	// define window and show it in desktop
 	var window = new Ext.Window
 	(
 		{
  			title: '复制某年科目信息到新的一年',
			iconCls: 'copy',
    		width: 380,
    		height: 200,
    		layout: 'fit',
    		plain: true,
    		modal: true,
    		bodyStyle: 'padding:5px;',
    		buttonAlign: 'center',
    		// atLoad: true, // 是否自动刷新
    		items: formPanel,
    		buttons:
    		[
    			{
    				text: '保存',
    				iconCls: 'save',
					handler: function() 
					{
      					var year = uCopyYear1Combo.getValue();
      					var year2 = uCopyYear2Combo.getValue();
      					if(year=="")
      					{
      						Ext.Msg.show({title:'错误',msg:'被复制年度不能为空！',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
      						return;
      					}
      					if(year2=="")
      					{
      						Ext.Msg.show({title:'错误',msg:'要复制到年度不能为空！',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
      						return;
      					}
      					
      					Ext.Ajax.request
      					(
      						{
								url: mainUrl+'?action=copy&year='+year+'&toyear='+year2,
								failure: function(result, request)
								{
									Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
								},
								success: function(result, request)
								{
									var jsonData = Ext.util.JSON.decode(result.responseText);
									if (jsonData.success=='true')
									{
										Ext.Msg.show({title:'提示',msg:'处理成功!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                                    	mainGrid.root.reload();
										window.close();
									}
									else
									{
										var tmpMsg = jsonData.info+"处理失败!";
										Ext.Msg.show({title:'错误',msg:tmpMsg,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									}
								},
			  					scope: this
							}
						);
					}
				},
				{
					text: '关闭',
					iconCls : 'cancel',
					handler: function()
					{
						window.close();
					}
				}
			]
		}
	);
	window.show();
};