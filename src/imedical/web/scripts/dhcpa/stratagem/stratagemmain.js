/**
  *name:tab of database
  *author:limingzhong
  *Date:2009-11-6
 */

function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

//========================================================================================

var value = "http: //www.baidu.com";

function DomUrl(){
	//alert("aaaaaaaaaaa");
	/*
	var row = grid.getSelectionModel().selectRow(startrow);//选中当前行
	var rownum = grid.getSelectionModel().getSelected();//获取当前行
	startrow ++;
	var strurl = "abc.jsp?id=" + rownum.get('id');//获取当前选中行的值，并组织链接字符串
	return "<a href='"+strurl+"'>"+value+"</a>";
	*/
	return "<a href=>"+value+"</a>";
} 
//========================================================================================
 
var unitDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

unitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:StratagemTabUrl+'?action=unit&str='+Ext.getCmp('unitField').getRawValue(),method:'POST'})
});

var unitField = new Ext.form.ComboBox({
	id: 'unitField',
	fieldLabel: '所属单位',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: unitDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择所属单位...',
	name: 'unitField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:StratagemTabUrl+'?action=cycle&searchValue='+Ext.getCmp('cycleField').getRawValue()+'&active=Y',method:'POST'})
});

var cycleField = new Ext.form.ComboBox({
	id: 'cycleField',
	fieldLabel: '考核周期',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: cycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择考核周期...',
	name: 'cycleField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var currStratagemStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data : [['Y','当前战略'],['N','非当前战略']]
});
var currStratagemField = new Ext.form.ComboBox({
	id: 'currStratagemField',
	fieldLabel: '当前战略',
	listWidth : 130,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: currStratagemStore,
	anchor: '90%',
	value:'Y', //默认值
	valueNotFoundText:'当前战略',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'选择标志...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

//配件数据源
var StratagemTabUrl = 'dhc.pa.stratagemexe.csp';
var StratagemTabProxy= new Ext.data.HttpProxy({url:StratagemTabUrl + '?action=list'});
var StratagemTabDs = new Ext.data.Store({
	proxy: StratagemTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'unitDr',
		'unitName',
		'cycleDr',
		'cycleName',
		'code',
		'name',
		'shortcut',
		'isVFlag',
		'state',
		'stateName',
		'monthDr',
		'monthName',
		'desc',
		'linkFile',
		'nurFlag',
		'medFlag',
		'postFlag',
		'currStratagem'
	]),
    // turn on remote sorting
    remoteSort: true
});

//设置默认排序字段和排序方向
StratagemTabDs.setDefaultSort('rowid', 'desc');

//数据库数据模型
var StratagemTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 /*{
    	header: '单位',
        dataIndex: 'unitName',
        width: 70,
        sortable: true
    },*/{
    	header: '年份',
        dataIndex: 'cycleName',
        width: 70,
        sortable: true
    },{
    	header: '代码',
        dataIndex: 'code',
        width: 70,
        sortable: true
    },{
        header: "名称",
        dataIndex: 'name',
        width: 80,
        align: 'left',
        sortable: true
    },{
        header:'当前战略',
		width:60,
		dataIndex:'currStratagem',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },{
        header:'虚拟标志',
		width:60,
		dataIndex:'isVFlag',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },{
        header: "科室绩效状态",
        dataIndex: 'stateName',
        width: 80,
        align: 'left',
        sortable: true
    },{
        header: "当前核算月",
        dataIndex: 'monthName',
        width: 80,
        align: 'left',
        sortable: true,
		editor:new Ext.form.ComboBox({
			id:'editcom',
			editable:false,
			valueField: 'key',
			displayField:'value',
			mode:'local',
			triggerAction:'all',
			store:new Ext.data.SimpleStore({
				fields:['key','value'],
				data:[['1','1月'],['2','2月'],['3','3月'],['4','4月'],['5','5月'],['6','6月'],['7','7月'],['8','8月'],['9','9月'],['10','10月'],['11','11月'],['12','12月']]
			}),
			listeners :{
				specialKey :function(field,e){
					if (e.getKey()==Ext.EventObject.ENTER){
						//获取该条记录所修改的字段值
						var monthDr = Ext.getCmp('editcom').getValue();
						//获取该条记录的rowid
						var rowObj=StratagemTab.getSelections();
						var len = rowObj.length;
						var rowid = rowObj[0].get("rowid");
						
						var unitdr=Ext.getCmp('unitField').getValue();
						var cycledr=Ext.getCmp('cycleField').getValue();
						var currstratagem=Ext.getCmp('currStratagemField').getValue();
						
						//判断该条战略是否已经被关闭
						var state = rowObj[0].get("state");
						if(state=="close"){
							Ext.Msg.show({title:'提示',msg:'该战略已经被关闭,不允许再被修改或刷新!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							StratagemTabDs.load({params:{start:0,limit:StratagemTabPagingToolbar.pageSize,unitdr:unitdr,cycledr:cycledr,currstratagem:currstratagem}});
							return false;						
						}else{
							Ext.Ajax.request({
								url:'dhc.pa.stratagemexe.csp?action=refresh&rowid='+rowid+'&monthDr='+monthDr,
								waitMsg:'刷新中...',
								failure: function(result, request){
									Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
								success: function(result, request){
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true'){
										Ext.Msg.show({title:'注意',msg:'刷新成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										StratagemTabDs.load({params:{start:0,limit:StratagemTabPagingToolbar.pageSize,unitdr:unitdr,cycledr:cycledr,currstratagem:currstratagem}});
									}else{
										Ext.Msg.show({title:'错误',msg:'刷新失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									}
								},
								scope: this
							});
						}
					}
				}
			}
		})
    }/*,{
        header:'护理状态标志',
		width:80,
		dataIndex:'nurFlag',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },{
        header:'医疗状态标志',
		width:80,
		dataIndex:'medFlag',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },{
        header:'岗位状态标志',
		width:80,
		dataIndex:'postFlag',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    }*/,{
        header: "目标概要",
        dataIndex: 'desc',
        width: 120,
        align: 'left',
        sortable: true
    }
/**
,{
        header: "说明文件",
        dataIndex: 'linkFile',
        width: 180,
        align: 'left',
        sortable: true,
		renderer : function(v, p, record){
			return '<font color=blue>文件说明</font>';
		}
    }

**/
]);

//初始化默认排序功能
StratagemTabCm.defaultSortable = true;

//查询按钮
var findButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'add',
	handler:function(){
		var unitdr=Ext.getCmp('unitField').getValue();
		var cycledr=Ext.getCmp('cycleField').getValue();
		var currstratagem=Ext.getCmp('currStratagemField').getValue();
		StratagemTabDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize,unitdr:unitdr,cycledr:cycledr,currstratagem:currstratagem}});
	}
});

//添加按钮
var addButton = new Ext.Toolbar.Button({
	text: '添加',
    tooltip:'添加',        
    iconCls:'add',
	handler:function(){
		
		var unitds = new Ext.data.Store({
			autoLoad:true,
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
		});

		unitds.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
				url:StratagemTabUrl+'?action=unit&str='+Ext.getCmp('uField').getRawValue(),method:'POST'})
		});

		var uField = new Ext.form.ComboBox({
			id: 'uField',
			fieldLabel: '所属单位',
			width:231,
			listWidth : 231,
			allowBlank: false,
			store: unitds,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			emptyText:'请选择所属单位...',
			name: 'uField',
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true,
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(uField.getValue()!=""){
							cField.focus();
						}else{
							Handler = function(){uField.focus();}
							Ext.Msg.show({title:'错误',msg:'单位不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});

		var cycleds = new Ext.data.Store({
			autoLoad:true,
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
		});

		cycleds.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
				url:StratagemTabUrl+'?action=cycle&searchValue='+Ext.getCmp('cField').getRawValue()+'&active=Y',method:'POST'})
		});

		var cField = new Ext.form.ComboBox({
			id: 'cField',
			fieldLabel: '考核周期',
			width:231,
			listWidth : 231,
			allowBlank: false,
			store: cycleds,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			emptyText:'请选择考核周期...',
			name: 'cField',
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true,
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(cField.getValue()!=""){
							codeField.focus();
						}else{
							Handler = function(){cField.focus();}
							Ext.Msg.show({title:'错误',msg:'考核周期不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		
		var codeField = new Ext.form.TextField({
			id:'codeField',
			fieldLabel: '目标代码',
			allowBlank: false,
			width:150,
			listWidth : 150,
			emptyText:'目标代码...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(codeField.getValue()!=""){
							nameField.focus();
						}else{
							Handler = function(){codeField.focus();}
							Ext.Msg.show({title:'错误',msg:'目标代码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
	
		var nameField = new Ext.form.TextField({
			id:'nameField',
			fieldLabel: '目标名称',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'目标名称...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(nameField.getValue()!=""){
							currStrField.focus();
						}else{
							Handler = function(){nameField.focus();}
							Ext.Msg.show({title:'错误',msg:'目标名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var currStrStore = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data : [['Y','当前战略'],['N','非当前战略']]
		});
		var currStrField = new Ext.form.ComboBox({
			id: 'currStrField',
			fieldLabel: '当前战略',
			listWidth : 231,
			selectOnFocus: true,
			allowBlank: false,
			store: currStrStore,
			anchor: '90%',
			value:'Y', //默认值
			valueNotFoundText:'当前战略',
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
						if(currStrField.getValue()!=""){
							stateField.focus();
						}else{
							Handler = function(){currStrField.focus();}
							Ext.Msg.show({title:'错误',msg:'当前战略不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var stateStore = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data : [['close','已关闭'],['new','新增'],['confirm','已下达']]
		});
		var stateField = new Ext.form.ComboBox({
			id: 'stateField',
			fieldLabel: '科室绩效标示',
			listWidth : 231,
			selectOnFocus: true,
			allowBlank: false,
			store: stateStore,
			anchor: '90%',
			value:'new', //默认值
			valueNotFoundText:'新增',
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
						if(stateField.getValue()!=""){
							monthField.focus();
						}else{
							Handler = function(){stateField.focus();}
							Ext.Msg.show({title:'错误',msg:'科室绩效标示不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var monthStore = new Ext.data.SimpleStore({
			fields:['key','keyValue'],
			data:[['1','1月'],['2','2月'],['3','3月'],['4','4月'],['5','5月'],['6','6月'],['7','7月'],['8','8月'],['9','9月'],['10','10月'],['11','11月'],['12','12月']]
		});
		var monthField = new Ext.form.ComboBox({
			id: 'monthField',
			fieldLabel: '当前核算月',
			listWidth : 231,
			selectOnFocus: true,
			allowBlank: false,
			store: monthStore,
			anchor: '90%',
			value:'1', //默认值
			valueNotFoundText:'1月',
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
						if(monthField.getValue()!=""){
							descField.focus();
						}else{
							Handler = function(){monthField.focus();}
							Ext.Msg.show({title:'错误',msg:'应用系统代码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var descField = new Ext.form.TextField({
			id:'descField',
			fieldLabel: '目标概要',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'目标概要...',
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
				//uField,
				cField,
				codeField,
				nameField,
				currStrField,
				stateField,
				monthField,
				descField
			]
		});
		
		//初始化添加按钮
		addButton = new Ext.Toolbar.Button({
			text:'添 加'
		});
		
		//定义添加按钮响应函数
		addHandler = function(){
			//var unitdr = Ext.getCmp('uField').getValue();
			var cycledr = Ext.getCmp('cField').getValue();
			var code = codeField.getValue();
			var name = nameField.getValue();
			var currStratagem = Ext.getCmp('currStrField').getValue();
			var state = Ext.getCmp('stateField').getValue();
			var monthDr = Ext.getCmp('monthField').getValue();
			var desc = descField.getValue();
			code = trim(code);
			name = trim(name);
			if(code==""){
				Ext.Msg.show({title:'错误',msg:'战略目标代码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(name==""){
				Ext.Msg.show({title:'错误',msg:'战略目标名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			
			Ext.Ajax.request({
				url: 'dhc.pa.stratagemexe.csp?action=add&code='+code+'&name='+name+'&unitdr=&cycledr='+cycledr+'&state='+state+'&desc='+desc+'&monthDr='+monthDr+'&currstratagem='+currStratagem,
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
						//var unitdr=Ext.getCmp('unitField').getValue();
						var cycledr=Ext.getCmp('cycleField').getValue();
						var currstratagem=Ext.getCmp('currStratagemField').getValue();
						StratagemTabDs.load({params:{start:0,limit:StratagemTabPagingToolbar.pageSize,cycledr:cycledr,currstratagem:currstratagem}});
					}else{
						if(jsonData.info=='RepCode'){
							Handler = function(){codeField.focus();}
							Ext.Msg.show({title:'错误',msg:'此战略目标代码已经存在!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
						if(jsonData.info=='RepName'){
							Handler = function(){nameField.focus();}
							Ext.Msg.show({title:'错误',msg:'此战略目标名称已经存在!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
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
			title: '添加战略目标记录',
			width: 400,
			height:330,
			minWidth: 400, 
			minHeight: 330,
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
    iconCls:'add',
	handler:function(){
		//定义并初始化行对象
		var rowObj=StratagemTab.getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
			var state = rowObj[0].get("state");
			if(state=="close"){
				Ext.Msg.show({title:'注意',msg:'该条数据已经被关闭,不允许再修改!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return false;
			}
			if(state=="confirm"){
				Ext.Msg.show({title:'注意',msg:'该战略已下达,不允许再编辑!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return false;
			}
		}
		var UnitDs = new Ext.data.Store({
			autoLoad:true,
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
		});

		UnitDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
				url:StratagemTabUrl+'?action=unit&str='+Ext.getCmp('Unit').getRawValue(),method:'POST'})
		});

		var Unit = new Ext.form.ComboBox({
			id:'Unit',
			fieldLabel:'所属单位',
			width:231,
			listWidth:231,
			allowBlank:false,
			store:UnitDs,
			valueField:'rowid',
			displayField:'name',
			triggerAction:'all',
			emptyText:'请选择所属单位...',
			name:'Unit',
			minChars:1,
			pageSize:10,
			selectOnFocus:true,
			forceSelection:'true',
			valueNotFoundText:rowObj[0].get("unitName"),
			editable:true,
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(Unit.getValue()!=""){
							Cycle.focus();
						}else{
							Handler = function(){Unit.focus();}
							Ext.Msg.show({title:'错误',msg:'单位不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});

		var CycleDs = new Ext.data.Store({
			autoLoad:true,
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
		});

		CycleDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
				url:StratagemTabUrl+'?action=cycle&searchValue='+Ext.getCmp('Cycle').getRawValue()+'&active=Y',method:'POST'})
		});

		var Cycle = new Ext.form.ComboBox({
			id: 'Cycle',
			fieldLabel: '考核周期',
			width:231,
			listWidth : 231,
			allowBlank: false,
			store: CycleDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			emptyText:'请选择考核周期...',
			name: 'Cycle',
			valueNotFoundText:rowObj[0].get("cycleName"),
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true,
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(Cycle.getValue()!=""){
							CodeField.focus();
						}else{
							Handler = function(){Cycle.focus();}
							Ext.Msg.show({title:'错误',msg:'考核周期不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		
		var CodeField = new Ext.form.TextField({
			id:'CodeField',
			fieldLabel: '目标代码',
			allowBlank: false,
			width:150,
			listWidth : 150,
			emptyText:'目标代码...',
			anchor: '90%',
			selectOnFocus:'true',
			name:'code',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(CodeField.getValue()!=""){
							NameField.focus();
						}else{
							Handler = function(){CodeField.focus();}
							Ext.Msg.show({title:'错误',msg:'目标代码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
	
		var NameField = new Ext.form.TextField({
			id:'NameField',
			fieldLabel: '目标名称',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'目标名称...',
			anchor: '90%',
			selectOnFocus:'true',
			name:'name',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(NameField.getValue()!=""){
							CurrField.focus();
						}else{
							Handler = function(){NameField.focus();}
							Ext.Msg.show({title:'错误',msg:'目标名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var CurrField = new Ext.form.Checkbox({
			id: 'CurrField',
			labelSeparator: '战略状态:',
			allowBlank: false,
			checked: (rowObj[0].data['currStratagem'])=='Y'?true:false,
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						isVFField.focus();
					}
				}
			}
		});
		
		var isVFField = new Ext.form.Checkbox({
			id: 'isVFField',
			labelSeparator: '虚拟标志:',
			allowBlank: false,
			checked: (rowObj[0].data['isVFlag'])=='Y'?true:false,
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						StateField.focus();
					}
				}
			}
		});
		
		var stateFlagStore = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data : [['close','已关闭'],['new','新增'],['confirm','已下达']]
		});
		var StateField = new Ext.form.ComboBox({
			id: 'StateField',
			fieldLabel: '科室绩效标示',
			listWidth : 231,
			selectOnFocus: true,
			allowBlank: false,
			store: stateFlagStore,
			anchor: '90%',
			//value:'new', //默认值
			valueNotFoundText:rowObj[0].get("stateName"),
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
						if(StateField.getValue()!=""){
							MonthField.focus();
						}else{
							Handler = function(){StateField.focus();}
							Ext.Msg.show({title:'错误',msg:'科室绩效标示不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var MonthStore = new Ext.data.SimpleStore({
			fields:['key','keyValue'],
			data:[['1','1月'],['2','2月'],['3','3月'],['4','4月'],['5','5月'],['6','6月'],['7','7月'],['8','8月'],['9','9月'],['10','10月'],['11','11月'],['12','12月']]
		});
		var MonthField = new Ext.form.ComboBox({
			id: 'MonthField',
			fieldLabel: '当前核算月',
			listWidth : 231,
			selectOnFocus: true,
			allowBlank: false,
			store: MonthStore,
			anchor: '90%',
			//value:'1', //默认值
			valueNotFoundText:rowObj[0].get("monthName"),
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
						if(MonthField.getValue()!=""){
							DescField.focus();
						}else{
							Handler = function(){MonthField.focus();}
							Ext.Msg.show({title:'错误',msg:'应用系统代码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var DescField = new Ext.form.TextField({
			id:'DescField',
			fieldLabel: '目标概要',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'目标概要...',
			anchor: '90%',
			selectOnFocus:'true',
			name:'desc',
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
				//Unit,
				Cycle,
				CodeField,
				NameField,
				CurrField,
				isVFField,
				StateField,
				MonthField,
				DescField
			]
		});
	
		//面板加载
		formPanel.on('afterlayout', function(panel, layout){
			this.getForm().loadRecord(rowObj[0]);
			//Unit.setValue(rowObj[0].get("unitDr"));
			Cycle.setValue(rowObj[0].get("cycleDr"));
			StateField.setValue(rowObj[0].get("state"));
			MonthField.setValue(rowObj[0].get("monthDr"));
		});
		
		//定义并初始化保存修改按钮
		var editButton = new Ext.Toolbar.Button({
			text:'保存修改'
		});
	
		//定义修改按钮响应函数
		editHandler = function(){
			//var unitdr = Ext.getCmp('Unit').getValue();
			var cycledr = Ext.getCmp('Cycle').getValue();
			var code = CodeField.getValue();
			var name = NameField.getValue();
			var currstratagem = (CurrField.getValue()==true)?'Y':'N';
			var isVFlag = (isVFField.getValue()==true)?'Y':'N';
			var state = Ext.getCmp('StateField').getValue();
			var monthDr = Ext.getCmp('MonthField').getValue();
			var desc = DescField.getValue();
			code = trim(code);
			name = trim(name);
			if(code==""){
				Ext.Msg.show({title:'错误',msg:'战略目标代码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(name==""){
				Ext.Msg.show({title:'错误',msg:'战略目标名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			Ext.Ajax.request({
				url: 'dhc.pa.stratagemexe.csp?action=edit&rowid='+rowid+'&code='+code+'&name='+name+'&unitdr=&cycledr='+cycledr+'&state='+state+'&desc='+desc+'&monthDr='+monthDr+'&currstratagem='+currstratagem+'&isVFlag='+isVFlag,
				waitMsg:'保存中...',
				failure: function(result, request){
					Handler = function(){codeField.focus();}
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						//var unitdr=Ext.getCmp('unitField').getValue();
						var cycledr=Ext.getCmp('cycleField').getValue();
						var currstratagem=Ext.getCmp('currStratagemField').getValue();
						StratagemTabDs.load({params:{start:0,limit:StratagemTabPagingToolbar.pageSize,cycledr:cycledr,currstratagem:currstratagem}});
						editwin.close();
					}else{
						if(jsonData.info=='RepCode'){
							Handler = function(){codeField.focus();}
							Ext.Msg.show({title:'错误',msg:'战略目标代码已经存在!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
						if(jsonData.info=='RepName'){
							Handler = function(){nameField.focus();}
							Ext.Msg.show({title:'错误',msg:'战略目标名称已经存在!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
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
			title: '修改战略目标记录',
			width: 400,
			height:330,
			minWidth: 400, 
			minHeight: 330,
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
/*
//删除按钮
var delStratagem = new Ext.Toolbar.Button({
	text: '删除战略',
    tooltip:'删除战略',        
    iconCls:'add',
	handler:function(){
		//定义并初始化行对象
		var rowObj=StratagemTab.getSelections();
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
				var unitdr=Ext.getCmp('unitField').getValue();
				var cycledr=Ext.getCmp('cycleField').getValue();
				Ext.Ajax.request({
					url:'dhc.pa.stratagemexe.csp?action=del&rowid='+rowid,
					waitMsg:'删除中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							StratagemTabDs.load({params:{start:0,limit:StratagemTabPagingToolbar.pageSize,unitdr:unitdr,cycledr:cycledr}});
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
		Ext.MessageBox.confirm('提示','确实要删除该条战略目标记录吗?',handler);
	}
});
*/
var importFile = new Ext.Toolbar.Button({
	text: '导入',
    tooltip:'导入',        
    iconCls:'add',
	handler:function(){
		//文件上传功能
		var excelUpload = new Ext.form.TextField({   
			id:'excelUpload', 
			name:'Excel',   
			anchor:'90%',   
			height:20,   
			inputType:'file',
			fieldLabel:'文件选择'
		});
		
		
		var form = new Ext.form.FormPanel({
			title:'Excel数据导入',
			labelWidth:80,
			bodyStyle:'padding:5 5 5 5',
			height:360,
			width:503,
			frame:true,
			fileUpload:true,
			items:excelUpload/*,
			buttons:[{text:'导入Excel数据',handler:handler}]*/
		})
		
		//定义并初始化取消修改按钮
		var button = new Ext.Toolbar.Button({
			text:'导入'
		});
	
		//定义取消修改按钮的响应函数
		handler = function(){
			alert("aaaaaaaaaaaa");
			var excelName = Ext.getCmp('excelUpload').getRawValue();//上传文件名称的路径
			if(excelName==""){
				Ext.Msg.show({title:'提示',msg:'请选择文件!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
				return false;
			}else{ 
				var array=new Array();
				array=excelName.split("\\");
				var fileName="";
										var i=0;
										for(i=0;i<array.length;i++){
											if(fileName==""){
												fileName=array[i];
											}else{
												fileName=fileName+"/"+array[i];
											}
										}
										var uploadUrl = "http://172.16.2.20:8080/dhcpaverify/uploadfile";
										var upUrl = uploadUrl+'?fileName='+encodeURI(encodeURI(fileName));
										
										form.getForm().submit({
											url:upUrl,
											method:'POST',
											waitMsg:'数据导入中, 请稍等...',
											success:function(form, action, o) {
												Ext.MessageBox.alert("提示信息","数据成功导入!");
												//Ext.MessageBox.alert("Information",action.result.mess);
											},
											failure:function(form, action) {
												Ext.MessageBox.alert("Error",action.result.mess);
											}
										}); 
										/*
										
										Ext.Ajax.request({
											url:upUrl,
											waitMsg:'保存中...',
											failure: function(result, request){
												Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
											},
											success: function(result, request){
												alert("aaaaaaaaaaaaaaaaa");
											},
											scope: this
										}); 
										*/
									}
		}
	
		//添加取消按钮的监听事件
		button.addListener('click',handler,false);
		
		var win = new Ext.Window({
			title: '修改战略目标记录',
			width: 400,
			height:310,
			minWidth: 400, 
			minHeight: 310,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: form,
			buttons: [button
			]
		});
	
		//窗口显示
		win.show();
	}
});


//初始化搜索字段
var StratagemSearchField ='name';

//搜索过滤器
var StratagemFilterItem = new Ext.Toolbar.MenuButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '代码',
			value: 'code',
			checked: false ,
			group: 'StratagemFilter',
			checkHandler: onStratagemItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '名称',
			value: 'name',
			checked: false,
			group: 'StratagemFilter',
			checkHandler: onStratagemItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '当前核算月',
			value: 'monthName',
			checked: false,
			group: 'StratagemFilter',
			checkHandler: onStratagemItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '科室绩效标示',
			value: 'stateName',
			checked: false,
			group: 'StratagemFilter',
			checkHandler: onStratagemItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '考核周期',
			value: 'cycleName',
			checked: false,
			group: 'StratagemFilter',
			checkHandler: onStratagemItemCheck 
		})
	]}
});

//定义搜索响应函数
function onStratagemItemCheck(item, checked){
	if(checked) {
		StratagemSearchField = item.value;
		StratagemFilterItem.setText(item.text + ':');
	}
};

//查找按钮
var StratagemSearchBox = new Ext.form.TwinTriggerField({
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
			var unitdr=Ext.getCmp('unitField').getValue();
			var cycledr=Ext.getCmp('cycleField').getValue();
			StratagemTabDs.proxy = new Ext.data.HttpProxy({url: StratagemTabUrl + '?action=list'+'&unitdr='+unitdr+'&cycledr='+cycledr+'&currstratagem='+Ext.getCmp('currStratagemField').getValue()});
			StratagemTabDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize,unitdr:unitdr,cycledr:cycledr}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
			var unitdr=Ext.getCmp('unitField').getValue();
			var cycledr=Ext.getCmp('cycleField').getValue();
			StratagemTabDs.proxy = new Ext.data.HttpProxy({
				url: StratagemTabUrl + '?action=list&searchField=' + StratagemSearchField + '&searchValue=' + this.getValue()+'&unitdr='+unitdr+'&cycledr='+cycledr+'&currstratagem='+Ext.getCmp('currStratagemField').getValue()});
	        	StratagemTabDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize,unitdr:unitdr,cycledr:cycledr}});
	    	}
	}
});

//分页工具栏
var StratagemTabPagingToolbar = new Ext.PagingToolbar({
    store: StratagemTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg: "没有记录",
	buttons: ['-',StratagemFilterItem,'-',StratagemSearchBox],
	doLoad:function(C){
		var B={},
		A=this.paramNames;
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['unitdr']=Ext.getCmp('unitField').getValue();
		B['cycledr']=Ext.getCmp('cycleField').getValue();
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//表格
var StratagemTab = new Ext.grid.EditorGridPanel({
	title: '战略目标维护',
	store: StratagemTabDs,
	cm: StratagemTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	//tbar:['单位:',unitField,'-','年份:',cycleField,'-','战略状态:',currStratagemField,'-',findButton,'-',addButton,'-',editButton,'-',importFile],
	tbar:['年份:',cycleField,'-','战略状态:',currStratagemField,'-',findButton,'-',addButton,'-',editButton],

	bbar:StratagemTabPagingToolbar
});

/*
StratagemTab.on('cellclick',function(grid,rowIndex,columnIndex,e){
	alert(columnIndex);
	if(columnIndex==9){
		accPeriodsEditor(grid);
	}else if(columnIndex==10){
		copyOtherMon(grid);
	}
	var uploadUrl = "http://172.16.2.20:8080/dhcpaverify/download";
	var fileName="mm.txt";
	var checkFileExist="Y";
	var is="N";
	var upUrl = uploadUrl+"?fileName="+encodeURI(encodeURI(fileName))+'&checkFileExist='+checkFileExist+'&is='+is;
    Ext.Ajax.request({
		url:upUrl,
		waitMsg:'保存中...',
		failure: function(result, request){
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if(jsonData.info=="success"){
				function handler(id){
					if(id=="yes"){
						is="Y";
						window.location.href = 'http://172.16.2.20:8080/dhcpaverify/download?fileName='+encodeURI(encodeURI(fileName))+'&checkFileExist='+checkFileExist+'&is='+is;  
					}else{
						return false;
					}
				}
				Ext.MessageBox.confirm('提示','确实要下载该文件吗?',handler);
			}else{
				Ext.Msg.show({title:'提示',msg:'文件不存在!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			} 
		},
		scope: this
	}); 
});
*/

