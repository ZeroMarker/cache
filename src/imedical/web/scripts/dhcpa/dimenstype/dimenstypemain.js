/**
  *name:tab of database
  *author:limingzhong
  *Date:2010-09-6
 */

function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

//配件数据源
var DimensTypeTabUrl = '../csp/dhc.pa.dimenstypeexe.csp';
var DimensTypeTabProxy= new Ext.data.HttpProxy({url:DimensTypeTabUrl + '?action=list'});
var DimensTypeTabDs = new Ext.data.Store({
	proxy: DimensTypeTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'code',
		'name',
		'shortcut',
		'order',
		'appSysDr',
		'appSysName',
		'desc',
		'isInner',
		'active'
	]),
    // turn on remote sorting
    remoteSort: true
});

//设置默认排序字段和排序方向
DimensTypeTabDs.setDefaultSort('rowid', 'desc');

//数据库数据模型
var DimensTypeTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
    	header: '代码',
        dataIndex: 'code',
        width: 100,
        sortable: true
    },{
        header: "名称",
        dataIndex: 'name',
        width: 120,
        align: 'left',
        sortable: true
    },{
        header: "顺序",
        dataIndex: 'order',
        width: 150,
        align: 'left',
        sortable: true
    }/*,{
        header: "应用系统类别",
        dataIndex: 'appSysName',
        width: 150,
        align: 'left',
        sortable: true/*,
		editor:new Ext.form.ComboBox({
			editable:false,
			valueField: 'key',
			displayField:'value',
			mode:'local',
			triggerAction:'all',
			store:new Ext.data.SimpleStore({
				fields:['key','value'],
				data:[['1','1-全院'],['2','2-科室'],['3','3-护理'],['4','4-医疗'],['5','5-个人']]
			})
		})
		
    }*/,{
        header: "描述",
        dataIndex: 'desc',
        width: 150,
        align: 'left',
        sortable: true
    },{
        header:'内置标志',
		width:100,
		dataIndex:'isInner',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },{
        header:'有效标志',
		width:100,
		dataIndex:'active',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    }
]);

//初始化默认排序功能
DimensTypeTabCm.defaultSortable = true;

//添加按钮
var addDimensType = new Ext.Toolbar.Button({
	text: '添加维度类别',
    tooltip:'添加维度类别',        
    iconCls:'add',
	handler:function(){
		var codeField = new Ext.form.TextField({
			id:'codeField',
			fieldLabel: '维度分类代码',
			allowBlank: false,
			width:150,
			listWidth : 150,
			emptyText:'维度分类代码...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(codeField.getValue()!=""){
							nameField.focus();
						}else{
							Handler = function(){codeField.focus();}
							Ext.Msg.show({title:'错误',msg:'维度分类代码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
	
		var nameField = new Ext.form.TextField({
			id:'nameField',
			fieldLabel: '维度分类名称',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'维度分类名称...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(nameField.getValue()!=""){
							orderField.focus();
						}else{
							Handler = function(){nameField.focus();}
							Ext.Msg.show({title:'错误',msg:'维度分类名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var orderField = new Ext.form.NumberField({
			id:'orderField',
			fieldLabel:'维度分类顺序',
			allowBlank:false,
			emptyText:'维度分类顺序...',
			anchor:'90%',
			width:220,
			listWidth:220,
			selectOnFocus:true,
			allowNegative:false,
			allowDecimals:false,
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(orderField.getValue()!=""){
							appSysField.focus();
						}else{
							Handler = function(){orderField.focus();}
							Ext.Msg.show({title:'错误',msg:'维度分类顺序不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var appSysStore = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data : [['1','1-全院'],['2','2-科室'],['3','3-护理'],['4','4-医疗'],['5','5-个人']]
		});
		var appSysField = new Ext.form.ComboBox({
			id: 'appSysField',
			fieldLabel: '应用系统类别',
			listWidth : 230,
			selectOnFocus: true,
			allowBlank: false,
			store: appSysStore,
			anchor: '90%',
			value:'1', //默认值
			valueNotFoundText:'1-全院',
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			emptyText:'选择标志...',
			mode: 'local', //本地模式
			editable:false,
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: true,
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(appSysField.getValue()!=""){
							descField.focus();
						}else{
							Handler = function(){appSysField.focus();}
							Ext.Msg.show({title:'错误',msg:'应用系统代码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var descField = new Ext.form.TextField({
			id:'descField',
			fieldLabel: '维度分类描述',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'维度分类描述...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
		});
		
		//初始化面板
		formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
				codeField,
				nameField,
				orderField,
				//appSysField,
				descField
			]
		});
		
		//初始化添加按钮
		addButton = new Ext.Toolbar.Button({
			text:'添 加'
		});
		
		//定义添加按钮响应函数
		addHandler = function(){
			var code = codeField.getValue();
			var name = nameField.getValue();
			var order = orderField.getValue();
			//var appSysDr = Ext.getCmp('appSysField').getValue();
			var desc = descField.getValue();
			code = trim(code);
			name = trim(name);
			if(code==""){
				Ext.Msg.show({title:'错误',msg:'维度分类代码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(name==""){
				Ext.Msg.show({title:'错误',msg:'维度分类名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			//alert('code='+code+'&name='+name+'&order='+order+'&appSysDr='+appSysDr+'&desc='+desc);
			Ext.Ajax.request({
				url: '../csp/dhc.pa.dimenstypeexe.csp?action=add&code='+code+'&name='+name+'&order='+order+'&appSysDr='+2+'&desc='+desc,
				waitMsg:'保存中...',
				failure: function(result, request){
					Handler = function(){codeField.focus();}
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){codeField.focus();}
						Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
						DimensTypeTabDs.load({params:{start:0,limit:DimensTypeTabPagingToolbar.pageSize}});
					}else{
						if(jsonData.info=='RepCode'){
							Handler = function(){codeField.focus();}
							Ext.Msg.show({title:'错误',msg:'此维度分类代码已经存在!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
						if(jsonData.info=='RepName'){
							Handler = function(){nameField.focus();}
							Ext.Msg.show({title:'错误',msg:'此维度分类名称已经存在!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
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
			title: '添加维度分类记录',
			width: 380,
			height:250,
			minWidth: 380, 
			minHeight: 250,
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

edit=function(){

		//定义并初始化行对象
		var rowObj=DimensTypeTab.getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
		var codeField = new Ext.form.TextField({
			id:'codeField',
			fieldLabel: '维度分类代码',
			allowBlank: false,
			width:150,
			listWidth : 150,
			emptyText:'维度分类代码...',
			anchor: '90%',
			selectOnFocus:'true',
			name:'code',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(codeField.getValue()!=""){
							nameField.focus();
						}else{
							Handler = function(){codeField.focus();}
							Ext.Msg.show({title:'错误',msg:'维度分类代码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
	
		var nameField = new Ext.form.TextField({
			id:'nameField',
			fieldLabel: '维度分类名称',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'维度分类名称...',
			anchor: '90%',
			selectOnFocus:'true',
			name:'name',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(nameField.getValue()!=""){
							orderField.focus();
						}else{
							Handler = function(){nameField.focus();}
							Ext.Msg.show({title:'错误',msg:'维度分类名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var orderField = new Ext.form.NumberField({
			id:'orderField',
			fieldLabel:'维度分类顺序',
			allowBlank:false,
			emptyText:'维度分类顺序...',
			anchor:'90%',
			width:220,
			listWidth:220,
			selectOnFocus:true,
			allowNegative:false,
			allowDecimals:false,
			name:'order',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(orderField.getValue()!=""){
							appSysField.focus();
						}else{
							Handler = function(){orderField.focus();}
							Ext.Msg.show({title:'错误',msg:'维度分类顺序不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var appStore = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data : [['1','1-全院'],['2','2-科室'],['3','3-护理'],['4','4-医疗'],['5','5-个人']]
		});
		var appField = new Ext.form.ComboBox({
			id: 'appField',
			fieldLabel: '应用系统类别',
			listWidth : 230,
			selectOnFocus: true,
			allowBlank: false,
			store: appStore,
			anchor: '90%',
			value:'1', //默认值
			valueNotFoundText:rowObj[0].get("appSysName"),
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			emptyText:'选择标志...',
			mode: 'local', //本地模式
			editable:false,
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: true,
			name:'order',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(appField.getValue()!=""){
							descField.focus();
						}else{
							Handler = function(){appField.focus();}
							Ext.Msg.show({title:'错误',msg:'应用系统代码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var descField = new Ext.form.TextField({
			id:'descField',
			fieldLabel: '维度分类描述',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'维度分类描述...',
			anchor: '90%',
			selectOnFocus:'true',
			name:'desc',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						isInnerField.focus();
					}
				}
			}
		});
		
		var isInnerField = new Ext.form.Checkbox({
			id: 'isInnerField',
			labelSeparator: '内置标志:',
			allowBlank: false,
			checked: (rowObj[0].data['isInner'])=='Y'?true:false,
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						activeField.focus();
					}
				}
			}
		});
		
		var activeField = new Ext.form.Checkbox({
			id: 'activeField',
			labelSeparator: '有效标志:',
			allowBlank: false,
			checked: (rowObj[0].data['active'])=='Y'?true:false,
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						editButton.focus();
					}
				}
			}
		});
		
		//定义并初始化面板
		var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
				codeField,
				nameField,
				orderField,
				//appField,
				descField,
				isInnerField,
				activeField
			]
		});
	
		//面板加载
		formPanel.on('afterlayout', function(panel, layout){
			this.getForm().loadRecord(rowObj[0]);
			appField.setValue(rowObj[0].get("appSysDr"));
		});
		
		//定义并初始化保存修改按钮
		var editButton = new Ext.Toolbar.Button({
			text:'保存修改'
		});
	
		//定义修改按钮响应函数
		editHandler = function(){
			var code = codeField.getValue();
			var name = nameField.getValue();
			var order = orderField.getValue();
			//var appSysDr = Ext.getCmp('appField').getValue();
			var desc = descField.getValue();
			var isInner = (isInnerField.getValue()==true)?'Y':'N';
			var active = (activeField.getValue()==true)?'Y':'N';
			code = trim(code);
			name = trim(name);
			if(code==""){
				Ext.Msg.show({title:'错误',msg:'维度分类代码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(name==""){
				Ext.Msg.show({title:'错误',msg:'维度分类名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			Ext.Ajax.request({
				url: '../csp/dhc.pa.dimenstypeexe.csp?action=edit&rowid='+rowid+'&code='+code+'&name='+name+'&order='+order+'&appSysDr='+2+'&desc='+desc+'&isInner='+isInner+'&active='+active,
				waitMsg:'保存中...',
				failure: function(result, request){
					Handler = function(){codeField.focus();}
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						DimensTypeTabDs.load({params:{start:0,limit:DimensTypeTabPagingToolbar.pageSize}});
						editwin.close();
					}else{
						if(jsonData.info=='RepCode'){
							Handler = function(){codeField.focus();}
							Ext.Msg.show({title:'错误',msg:'维度分类代码已经存在!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
						if(jsonData.info=='RepName'){
							Handler = function(){nameField.focus();}
							Ext.Msg.show({title:'错误',msg:'维度分类名称已经存在!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
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
			title: '修改维度分类记录',
			width: 380,
			height:260,
			minWidth: 380, 
			minHeight: 260,
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

//修改按钮
var editDimensType = new Ext.Toolbar.Button({
	text: '修改维度类别',
    tooltip:'修改维度类别',        
    iconCls:'add',
	handler:function(){
		edit();
	}
});

//删除按钮
var delDimensType = new Ext.Toolbar.Button({
	text: '删除维度类别',
    tooltip:'删除维度类别',        
    iconCls:'add',
	handler:function(){
		//定义并初始化行对象
		var rowObj=DimensTypeTab.getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
		function handler(id){
			if(id=="yes"){
				var isInner = rowObj[0].get("isInner");
				//判断是否是内置数据,如果是则不允许删除,否则可以被删除
				if(isInner=="Y"||isInner=="Yes"||isInner=="y"||isInner=="yes"){
					Ext.Msg.show({title:'注意',msg:'内置数据,不允许被删除!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}else{
					Ext.Ajax.request({
						url:'../csp/dhc.pa.dimenstypeexe.csp?action=del&rowid='+rowid,
						waitMsg:'删除中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								DimensTypeTabDs.load({params:{start:0,limit:DimensTypeTabPagingToolbar.pageSize}});
							}else{
								Ext.Msg.show({title:'错误',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要删除该条记录吗?',handler);
	}
});

//初始化搜索字段
var DimensTypeSearchField ='name';

//搜索过滤器
var DimensTypeFilterItem = new Ext.Toolbar.MenuButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '代码',
			value: 'code',
			checked: false ,
			group: 'DimensTypeFilter',
			checkHandler: onDimensTypeItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '名称',
			value: 'name',
			checked: false,
			group: 'DimensTypeFilter',
			checkHandler: onDimensTypeItemCheck 
		})/*,
		new Ext.menu.CheckItem({ 
			text: '应用系统类别',
			value: 'appSysName',
			checked: false,
			group: 'DimensTypeFilter',
			checkHandler: onDimensTypeItemCheck 
		})*/
	]}
});

//定义搜索响应函数
function onDimensTypeItemCheck(item, checked){
	if(checked) {
		DimensTypeSearchField = item.value;
		DimensTypeFilterItem.setText(item.text + ':');
	}
};

//查找按钮
var DimensTypeSearchBox = new Ext.form.TwinTriggerField({
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
			DimensTypeTabDs.proxy = new Ext.data.HttpProxy({url: DimensTypeTabUrl + '?action=list'});
			DimensTypeTabDs.load({params:{start:0, limit:DimensTypeTabPagingToolbar.pageSize}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
			DimensTypeTabDs.proxy = new Ext.data.HttpProxy({
				url: DimensTypeTabUrl + '?action=list&searchField=' + DimensTypeSearchField + '&searchValue=' + this.getValue()});
	        	DimensTypeTabDs.load({params:{start:0, limit:DimensTypeTabPagingToolbar.pageSize}});
	    	}
	}
});

//分页工具栏
var DimensTypeTabPagingToolbar = new Ext.PagingToolbar({
    store: DimensTypeTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg: "没有记录",
	buttons: ['-',DimensTypeFilterItem,'-',DimensTypeSearchBox]
});

//表格
var DimensTypeTab = new Ext.grid.EditorGridPanel({
	title: '维度分类维护窗口',
	store: DimensTypeTabDs,
	cm: DimensTypeTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:[addDimensType,'-',editDimensType,'-',delDimensType],
	bbar:DimensTypeTabPagingToolbar
});

//加载
DimensTypeTabDs.load({params:{start:0, limit:DimensTypeTabPagingToolbar.pageSize}});

/*
DimensTypeTab.on('contextmenu',function(e){
    if(!this.menu){
		this.menu = new Ext.menu.Menu({
			items:[
				{
					text: 'Add Product',
					handler: addProduct
				},{
					text: 'Edit Product(s)'
					//handler: editProduct
				},{
					text: 'Delete Product(s)'
					//handler: deleteProduct
				}
			]
		});
    }
	e.preventDefault(); 
    this.menu.showAt(e.getXY());
});
	
addProduct=function(){
	alert("你是天才!");
	edit();
}

*/
