/**
  *name:tab of database
  *author:liuyang
  *Date:2011-1-5
 */
 
var TargetMappingTabUrl = '../csp/dhc.bonus.targetmappingexe.csp';
function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

//配件数据源

var TargetMappingTabProxy= new Ext.data.HttpProxy({url:TargetMappingTabUrl + '?action=list'});
var TargetMappingTabDs = new Ext.data.Store({
	proxy: TargetMappingTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'schemID',
		'schemName',
		'targetId',
		'targetName',
		'mappingTargetId',
		'mappingTargetName',
		'valid',
		'comeFlag',
		'comeFlagName'
	]),
    // turn on remote sorting
    remoteSort: true
});

//设置默认排序字段和排序方向
TargetMappingTabDs.setDefaultSort('rowid', 'name');

//数据库数据模型
var TargetMappingTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
    	header: '核算方案',
        dataIndex: 'schemName',
        width: 200,		  
        sortable: true
    },{
    	header: '方案涉及指标',
        dataIndex: 'targetName',
        width: 200,
        sortable: true
    },{
    	header: '映射指标或项目',
        dataIndex: 'mappingTargetName',
        width: 200,
        sortable: true
    },{
    	header: '数据来源',
        dataIndex: 'comeFlagName',
        width: 200,
        sortable: true
    },{
		header: "有效标志",
		dataIndex: 'valid',
		width: 90,
		sortable: true,
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v==1?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	}
]);

//初始化默认排序功能
TargetMappingTabCm.defaultSortable = true;


//初始化搜索字段
var TargetMappingSearchField ='schemName';

//搜索过滤器
var TargetMappingFilterItem = new Ext.Toolbar.MenuButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '方案名称',
			value: 'schemName',
			checked: false ,
			group: 'TargetMappingFilter',
			checkHandler: onTargetMappingItemCheck 
		})
	]}
});

//定义搜索响应函数
function onTargetMappingItemCheck (item, checked){
	if(checked) {
		TargetMappingSearchField = item.value;
		TargetMappingFilterItem.setText(item.text + ':');
	}
};

//查找按钮
var TargetMappingSearchBox = new Ext.form.TwinTriggerField({
	width: 180,
	trigger1Class: 'x-form-clear-trigger',
	trigger2Class: 'x-form-search-trigger',
	emptyText:'搜索...',
	listeners: {
		specialkey: {
			fn:function(field, e) {
				var key = e.getKey();
	      	  		if(e.ENTER === key) {
					this.onTrigger2Click();
				}
			}
		}
	},
	grid: this,
	onTrigger1Click: function() {
		if(this.getValue()) {
			this.setValue('');    
			TargetMappingTabDs.proxy = new Ext.data.HttpProxy({url:  TargetMappingTabUrl + '?action=list'});
			TargetMappingTabDs.load({params:{start:0, limit:TargetMappingTabPagingToolbar.pageSize}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
				TargetMappingTabDs.proxy = new Ext.data.HttpProxy({
				url: TargetMappingTabUrl + '?action=list&searchField=' + TargetMappingSearchField + '&searchValue=' + this.getValue()});
	        	TargetMappingTabDs.load({params:{start:0, limit:TargetMappingTabPagingToolbar.pageSize}});
	    	}
	}
});


//添加按钮
var addButton = new Ext.Toolbar.Button({
	text: '添加',
    tooltip:'添加',        
    iconCls:'add',
	handler:function(){

		var schemDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['schemID', 'schemName'])
				});

		schemDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.bonus.targetmappingexe.csp?action=getSchem&str='
								+ Ext.getCmp('schemField').getRawValue(),
						method : 'POST'
					})
		});

		var schemField = new Ext.form.ComboBox({
					id : 'schemField',
					fieldLabel : '核算方案',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : schemDs,
					valueField : 'schemID',
					displayField : 'schemName',
					triggerAction : 'all',
					emptyText : '',
					name : 'schemField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
				});
		
		var targetDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['targetID', 'targetName'])
				});

		targetDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.bonus.targetmappingexe.csp?action=getTarget&str='
								+ Ext.getCmp('targetField').getRawValue(),
						method : 'POST'
					})
		});

		var targetField = new Ext.form.ComboBox({
					id : 'targetField',
					fieldLabel : '方案指标',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : targetDs,
					valueField : 'targetID',
					displayField : 'targetName',
					triggerAction : 'all',
					emptyText : '',
					name : 'targetField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
				});
				
		var comeFlagStore = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data : [[1,'奖金指标'],[2,'奖金项目']]
		});
		var comeFlagField = new Ext.form.ComboBox({
			id: 'comeFlagField',
			fieldLabel: '数据来源',
			width : 230,
			listWidth : 230,
			selectOnFocus: true,
			allowBlank: true,
			store: comeFlagStore,
			value:1, //默认值
			valueNotFoundText:'奖金指标',
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			emptyText:'选择数据级别...',
			mode: 'local', //本地模式
			editable:false,
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: true
		});

		
		var mappedTargetDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['mappedTargetID', 'mappedTargetName'])
				});

		mappedTargetDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.bonus.targetmappingexe.csp?action=getMappedTarget&str='
								+ Ext.getCmp('mappedTargetField').getRawValue()+'&comeId='+comeFlagField.getValue(),
						method : 'POST'
					})
		});

		var mappedTargetField = new Ext.form.ComboBox({
					id : 'mappedTargetField',
					fieldLabel : '映射指标',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : mappedTargetDs,
					valueField : 'mappedTargetID',
					displayField : 'mappedTargetName',
					triggerAction : 'all',
					emptyText : '',
					name : 'mappedTargetField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
				});

				
	
comeFlagField.on("select",function(cmb,rec,id ){
    searchFun(cmb.getValue());
});

function searchFun(comeFlagId){
	mappedTargetField.setValue("");
	mappedTargetField.setRawValue("");
	mappedTargetDs.load({params:{start:0,limit:mappedTargetField.pageSize,comeId:comeFlagId,str:Ext.getCmp('mappedTargetField').getRawValue()}});
};				
				
				
		//初始化面板
		formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
				schemField,
				targetField,
				comeFlagField,
				mappedTargetField
			]
		});
		
		//初始化添加按钮
		addButton = new Ext.Toolbar.Button({
			text:'添 加'
		});
		
		//定义添加按钮响应函数
		addHandler = function(){

			var schemId = schemField.getValue();
			var targetId = targetField.getValue();
			var comeId = comeFlagField.getValue();
			var mappedTargetId = mappedTargetField.getValue();

			if(schemId==""){
				Ext.Msg.show({title:'错误',msg:'方案为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(targetId==""){
				Ext.Msg.show({title:'错误',msg:'方案指标为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(comeId==""){
				Ext.Msg.show({title:'错误',msg:'数据来源为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(mappedTargetId==""){
				Ext.Msg.show({title:'错误',msg:'映射指标为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			//encodeURI
			//alert(schemId+'&targetId='+targetId+'&mappedTargetId='+mappedTargetId+'&comeId='+comeId);
			Ext.Ajax.request({
				url: encodeURI('../csp/dhc.bonus.targetmappingexe.csp?action=add&schemId='+schemId+'&targetId='+targetId+'&mappedTargetId='+mappedTargetId+'&comeId='+comeId),
				waitMsg:'保存中...',
				failure: function(result, request){
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						TargetMappingTabDs.load({params:{start:0, limit:TargetMappingTabPagingToolbar.pageSize}});
					}else{
						var message="";
						if(jsonData.info=='RepRecord') message='该记录已经存在!';
						Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
				scope: this
			});
		}
	
		//添加保存按钮的监听事件
		addButton.addListener('click',addHandler,false);
	
		//初始化取消按钮
		cancelButton = new Ext.Toolbar.Button({
			text:'取消'
		});
	
		//定义取消按钮的响应函数
		cancelHandler = function(){
			addwin.close();
		}
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//初始化窗口
		addwin = new Ext.Window({
			title: '添加记录',
			width: 400,
			height:200,
			minWidth: 400, 
			minHeight: 200,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				addButton,
				cancelButton
			]
		});
	
		//窗口显示
		addwin.show();
	}
});



//修改按钮
var editButton = new Ext.Toolbar.Button({
	text: '修改',
    tooltip:'修改',        
    iconCls: 'option',
	handler:function(){
		//定义并初始化行对象
		var rowObj=TargetMappingTab.getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
	
	
	var sDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['schemID', 'schemName'])
				});

		sDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.bonus.targetmappingexe.csp?action=getSchem&str='
								+ Ext.getCmp('sField').getRawValue(),
						method : 'POST'
					})
		});

		var sField = new Ext.form.ComboBox({
					id : 'sField',
					fieldLabel : '核算方案',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : sDs,
					valueField : 'schemID',
					displayField : 'schemName',
					valueNotFoundText:rowObj[0].get("schemName"),
					triggerAction : 'all',
					emptyText : '',
					name : 'sField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
				});
		
		var tDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['targetID', 'targetName'])
				});

		tDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.bonus.targetmappingexe.csp?action=getTarget&str='
								+ Ext.getCmp('tField').getRawValue(),
						method : 'POST'
					})
		});

		var tField = new Ext.form.ComboBox({
					id : 'tField',
					fieldLabel : '方案指标',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : tDs,
					valueField : 'targetID',
					valueNotFoundText:rowObj[0].get("targetName"),
					displayField : 'targetName',
					triggerAction : 'all',
					emptyText : '',
					name : 'tField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
				});
				
		var comeStore = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data : [[1,'奖金指标'],[2,'奖金项目']]
		});
		var comeField = new Ext.form.ComboBox({
			id: 'comeField',
			fieldLabel: '数据来源',
			width : 230,
			listWidth : 230,
			selectOnFocus: true,
			allowBlank: true,
			store: comeStore,
			valueNotFoundText:rowObj[0].get("comeFlagName"),
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			emptyText:'选择数据来源...',
			mode: 'local', //本地模式
			editable:false,
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: true
		});
				
		var mTDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['mappedTargetID', 'mappedTargetName'])
				});

		mTDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.bonus.targetmappingexe.csp?action=getMappedTarget&str='
								+ Ext.getCmp('mTField').getRawValue()+'&comeId='+comeField.getValue(),
						method : 'POST'
					})
		});

		var mTField = new Ext.form.ComboBox({
					id : 'mTField',
					fieldLabel : '映射指标',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store:mTDs,
					valueField : 'mappedTargetID',
					displayField : 'mappedTargetName',
					valueNotFoundText:rowObj[0].get("mappingTargetName"),
					triggerAction : 'all',
					emptyText : '',
					name : 'mTField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
				});

comeField.on("select",function(cmb,rec,id ){
    mTField.setValue("");
	mTField.setRawValue("");
	mTDs.load({params:{start:0,limit:mTField.pageSize,comeId:comeField.getValue(),str:Ext.getCmp('mTField').getRawValue()}});
});
		
				
		var activeField = new Ext.form.Checkbox({
			id: 'activeField',
			fieldLabel:'有效标志',
			disabled:false,
			allowBlank: false,
			checked: (rowObj[0].data['valid']) == 1 ? true : false
		});
		
		//定义并初始化面板
		var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
				sField,
				tField,
				comeField,
				mTField,
				activeField
			]
		});
	
		//面板加载
		formPanel.on('afterlayout', function(panel, layout){
			this.getForm().loadRecord(rowObj[0]);
			sField.setValue(rowObj[0].get("schemID"));
			tField.setValue(rowObj[0].get("targetId"));	
			comeField.setValue(rowObj[0].get("comeFlag")); 
			mTField.setValue(rowObj[0].get("mappingTargetId"));	
		});
		
		//定义并初始化保存修改按钮
		var editButton = new Ext.Toolbar.Button({
			text:'保存修改'
		});
	
		//定义修改按钮响应函数
		editHandler = function(){

			var sId = sField.getValue();
			var tId = tField.getValue();
			var cId = comeField.getValue();
			var mtId = mTField.getValue();
			var active = (activeField.getValue()==true)?1:0;
				
			if(sId==""){
				Ext.Msg.show({title:'错误',msg:'方案为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(tId==""){
				Ext.Msg.show({title:'错误',msg:'方案指标为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(mtId==""){
				Ext.Msg.show({title:'错误',msg:'映射指标为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
		
			Ext.Ajax.request({
				url: '../csp/dhc.bonus.targetmappingexe.csp?action=edit&rowid='+rowid+'&schemId='+sId+'&targetId='+tId+'&mappedTargetId='+mtId+'&active='+active+'&comeId='+cId,
				waitMsg:'保存中...',
				failure: function(result, request){
					Handler = function(){activeFlag.focus();}
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						TargetMappingTabDs.load({params:{start:0, limit:TargetMappingTabPagingToolbar.pageSize}});
						editwin.close();						
					}
					else
						{
							var message="";
							if(jsonData.info=='RepRecord') message='该记录已经存在!';
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
				},
				scope: this
			});
		}
	
		//添加保存修改按钮的监听事件
		editButton.addListener('click',editHandler,false);
	
		//定义并初始化取消修改按钮
		var cancelButton = new Ext.Toolbar.Button({
			text:'取消修改'
		});
	
		//定义取消修改按钮的响应函数
		cancelHandler = function(){
			editwin.close();
		}
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//定义并初始化窗口
		var editwin = new Ext.Window({
			title: '修改记录',
			width: 400,
			height:250,
			minWidth: 400, 
			minHeight: 250,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				editButton,
				cancelButton
			]
		});
	
		//窗口显示
		editwin.show();
	}
});


//删除按钮
var delButton = new Ext.Toolbar.Button({
	text: '删除',
    tooltip:'删除',        
    iconCls:'remove',
	handler:function(){
		//定义并初始化行对象
		var rowObj=TargetMappingTab.getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
			var active=rowObj[0].get("valid");
			if(active==1){
				Ext.Msg.show({title:'注意',msg:'有效数据部允许删除!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
		}
		function handler(id){
			if(id=="yes"){
					Ext.Ajax.request({
						url:'../csp/dhc.bonus.targetmappingexe.csp?action=del&rowid='+rowid,
						waitMsg:'删除中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								TargetMappingTabDs.load({params:{start:0, limit:TargetMappingTabPagingToolbar.pageSize}});
							}else{
								Ext.Msg.show({title:'错误',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要删除该条记录吗?',handler);
	}
});



//分页工具栏
var TargetMappingTabPagingToolbar = new Ext.PagingToolbar({
    store: TargetMappingTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg: "没有记录",
	buttons: ['-',TargetMappingFilterItem,'-',TargetMappingSearchBox]
	
	
});


//表格
var TargetMappingTab = new Ext.grid.EditorGridPanel({
	title: '奖金指标映射',
	store: TargetMappingTabDs,
	cm: TargetMappingTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:[addButton,'-',editButton,'-',delButton],
	bbar:TargetMappingTabPagingToolbar
});
TargetMappingTabDs.load({params:{start:0, limit:TargetMappingTabPagingToolbar.pageSize}});
