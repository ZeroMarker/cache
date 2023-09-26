/**
  *name:tab of database
  *author:liuyang
  *Date:2011-1-5
 */
 
var TargetTypeTabUrl = '../csp/dhc.bonus.targettypeexe.csp';
function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

//配件数据源

var TargetTypeTabProxy= new Ext.data.HttpProxy({url:TargetTypeTabUrl + '?action=list'});
var TargetTypeTabDs = new Ext.data.Store({
	proxy: TargetTypeTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'code',
		'name',
		'valid'
	]),
    // turn on remote sorting
    remoteSort: true
});

//设置默认排序字段和排序方向
TargetTypeTabDs.setDefaultSort('rowid', 'name');

//数据库数据模型
var TargetTypeTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
    	header: '编码',
        dataIndex: 'code',
        width: 100,		  
        sortable: true
    },{
    	header: '名称',
        dataIndex: 'name',
        width: 200,
        sortable: true
    }
    
]);

//初始化默认排序功能
TargetTypeTabCm.defaultSortable = true;


//初始化搜索字段
var TargetTypeSearchField ='name';

//搜索过滤器
var TargetTypeFilterItem = new Ext.Toolbar.MenuButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '编码',
			value: 'code',
			checked: false ,
			group: 'TargetTypeFilter',
			checkHandler: onTargetTypeItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '名称',
			value: 'name',
			checked: true,
			group: 'TargetTypeFilter',
			checkHandler: onTargetTypeItemCheck 
		})
	]}
});

//定义搜索响应函数
function onTargetTypeItemCheck (item, checked){
	if(checked) {
		TargetTypeSearchField = item.value;
		TargetTypeFilterItem.setText(item.text + ':');
	}
};

//查找按钮
var TargetTypeSearchBox = new Ext.form.TwinTriggerField({
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
			TargetTypeTabDs.proxy = new Ext.data.HttpProxy({url:  TargetTypeTabUrl + '?action=list'});
			TargetTypeTabDs.load({params:{start:0, limit:TargetTypeTabPagingToolbar.pageSize}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
				TargetTypeTabDs.proxy = new Ext.data.HttpProxy({
				url: TargetTypeTabUrl + '?action=list&searchField=' + TargetTypeSearchField + '&searchValue=' + encodeURIComponent(this.getValue())});
	        	TargetTypeTabDs.load({params:{start:0, limit:TargetTypeTabPagingToolbar.pageSize}});
	    	}
	}
});


//添加按钮
var addButton = new Ext.Toolbar.Button({
	text: '添加',
    tooltip:'添加',        
    iconCls:'add',
	handler:function(){

		var cField = new Ext.form.TextField({
			id:'cField',
			fieldLabel: '编码',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'编码...',
			anchor: '90%',
			selectOnFocus:'true',
			
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(cField.getValue()!=""){
							nField.focus();
						}else{
							Handler = function(){cField.focus();}
							Ext.Msg.show({title:'错误',msg:'编码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var nField = new Ext.form.TextField({
			id:'nField',
			fieldLabel: '名称',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'名称...',
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
				cField,
				nField
			]
		});
		
		//初始化添加按钮
		addButton = new Ext.Toolbar.Button({
			text:'添 加'
		});
		
		//定义添加按钮响应函数
		addHandler = function(){

			var code = cField.getValue();
			var name = nField.getValue();
			code = trim(code);
			name = trim(name);

			if(code==""){
				Ext.Msg.show({title:'错误',msg:'编码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(name==""){
				Ext.Msg.show({title:'错误',msg:'名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			//encodeURI
			Ext.Ajax.request({
				url: encodeURI('../csp/dhc.bonus.targettypeexe.csp?action=add&code='+code+'&name='+name),
				waitMsg:'保存中...',
				failure: function(result, request){
					Handler = function(){nField.focus();}
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){nField.focus();}
						Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
					
						TargetTypeTabDs.load({params:{start:0, limit:TargetTypeTabPagingToolbar.pageSize}});
						//addwin.close();
					}
					else
							{
								var message="";
								if(jsonData.info=='RepCode') message='输入的编码已经存在!';
								if(jsonData.info=='RepName') message='输入的名称已经存在!';
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
		var rowObj=TargetTypeTab.getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
	
	
		var c1Field = new Ext.form.TextField({
			id:'c1Field',
			fieldLabel: '编码',
			allowBlank: false,
			width:180,
			listWidth : 180,
			valueNotFoundText:rowObj[0].get("code"),
			emptyText:'编码...',
			anchor: '90%',
			selectOnFocus:'true',
			
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(c1Field.getValue()!=""){
							n1Field.focus();
						}else{
							Handler = function(){c1Field.focus();}
							Ext.Msg.show({title:'错误',msg:'编码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var n1Field = new Ext.form.TextField({
			id:'n1Field',
			fieldLabel: '名称',
			allowBlank: false,
			width:180,
			listWidth : 180,
			valueNotFoundText:rowObj[0].get("name"),
			emptyText:'名称...',
			anchor: '90%',
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
				c1Field,
				n1Field
			]
		});
	
		//面板加载
		formPanel.on('afterlayout', function(panel, layout){
			this.getForm().loadRecord(rowObj[0]);
			c1Field.setValue(rowObj[0].get("code"));
			n1Field.setValue(rowObj[0].get("name"));	
		});
		
		//定义并初始化保存修改按钮
		var editButton = new Ext.Toolbar.Button({
			text:'保存修改'
		});
	
		//定义修改按钮响应函数
		editHandler = function(){

			var code = c1Field.getValue();
			var name = n1Field.getValue();
			code = trim(code);
			name = encodeURIComponent(name);
				
			if(code==""){
				Ext.Msg.show({title:'错误',msg:'编码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(name==""){
				Ext.Msg.show({title:'错误',msg:'名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
		
			Ext.Ajax.request({
				url: '../csp/dhc.bonus.targettypeexe.csp?action=edit&rowid='+rowid+'&code='+encodeURIComponent(code)+'&name='+name,
				waitMsg:'保存中...',
				failure: function(result, request){
					Handler = function(){activeFlag.focus();}
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						TargetTypeTabDs.load({params:{start:0, limit:TargetTypeTabPagingToolbar.pageSize}});
						editwin.close();						
					}
					else
						{
							var message="";
							if(jsonData.info=='RepCode') message='输入的代码已经存在!';
							if(jsonData.info=='RepName') message='输入的名称已经存在!';
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
		var rowObj=TargetTypeTab.getSelections();
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
				
					Ext.Ajax.request({
						url:'../csp/dhc.bonus.targettypeexe.csp?action=del&rowid='+rowid,
						waitMsg:'删除中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								TargetTypeTabDs.load({params:{start:0, limit:TargetTypeTabPagingToolbar.pageSize}});
								
							}else if(jsonData.info=='RepItemType'){
								Ext.Msg.show({title:'错误',msg:'所选中的指标类别已被指标引用!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
var TargetTypeTabPagingToolbar = new Ext.PagingToolbar({
    store: TargetTypeTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg: "没有记录",
	buttons: ['-',TargetTypeFilterItem,'-',TargetTypeSearchBox]
	
	
});


//表格
var TargetTypeTab = new Ext.grid.EditorGridPanel({
	title: '奖金指标类别',
	store: TargetTypeTabDs,
	cm: TargetTypeTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:[addButton,'-',editButton,'-',delButton],
	bbar:TargetTypeTabPagingToolbar
});
TargetTypeTabDs.load({params:{start:0, limit:TargetTypeTabPagingToolbar.pageSize}});
