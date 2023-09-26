/**
  *name:tab of database
  *author:liuyang
  *Date:2011-1-10
 */
 function formatDate(value){
	//alert(value);
	return value?value.dateFormat('Y-m-d'):'';
};
var SchemePeriodTabUrl = '../csp/dhc.bonus.schemeperiodexe.csp';
function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

//配件数据源

var SchemePeriodTabProxy= new Ext.data.HttpProxy({url:SchemePeriodTabUrl + '?action=list'});
var SchemePeriodTabDs = new Ext.data.Store({
	proxy: SchemePeriodTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
	
		'rowid',
		'bonusYear',
		'bonusPeriod',
		'startDate',
		'endDate',
	
		'type',
		{name:'endDate',type:'date',dateFormat:'Y-m-d'},
		{name:'startDate',type:'date',dateFormat:'Y-m-d'}
	]),
    // turn on remote sorting
    remoteSort: true
});

//设置默认排序字段和排序方向
SchemePeriodTabDs.setDefaultSort('rowid', 'name');

//数据库数据模型
var SchemePeriodTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
    	header: '所属年度',
        dataIndex: 'bonusYear',
        width: 100,		  
        sortable: true
    },{
    	header: '所属期间',
        dataIndex: 'bonusPeriod',
        width: 100,
        sortable: true
    },{
    	header: '开始时间',
        dataIndex: 'startDate',
        width: 150,
		renderer:formatDate,
        sortable: true
    },{
    	header: '结束时间',
        dataIndex: 'endDate',
        width: 150,
		renderer:formatDate,
        sortable: true
    }
    
]);

//初始化默认排序功能
SchemePeriodTabCm.defaultSortable = true;


//初始化搜索字段
var SchemePeriodSearchField ='name';

//搜索过滤器
var SchemePeriodFilterItem = new Ext.Toolbar.MenuButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '所属年度',
			value: 'bonusYear',
			checked: false ,
			group: 'SchemePeriodFilter',
			checkHandler: onSchemePeriodItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '所属期间',
			value: 'bonusPeriod',
			checked: true,
			group: 'SchemePeriodFilter',
			checkHandler: onSchemePeriodItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '开始时间',
			value: 'startDate',
			checked: true,
			group: 'SchemePeriodFilter',
			
			checkHandler: onSchemePeriodItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '结束时间',
			value: 'endDate',
			checked: true,
			renderer:formatDate,
			group: 'SchemePeriodFilter',
			checkHandler: onSchemePeriodItemCheck 
		})
	]}
});

//定义搜索响应函数
function onSchemePeriodItemCheck (item, checked){
	if(checked) {
		SchemePeriodSearchField = item.value;
		SchemePeriodFilterItem.setText(item.text + ':');
	}
};

//查找按钮
var SchemePeriodSearchBox = new Ext.form.TwinTriggerField({
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
			SchemePeriodTabDs.proxy = new Ext.data.HttpProxy({url:  SchemePeriodTabUrl + '?action=list'});
			SchemePeriodTabDs.load({params:{start:0, limit:SchemePeriodTabPagingToolbar.pageSize}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
				SchemePeriodTabDs.proxy = new Ext.data.HttpProxy({
				url: SchemePeriodTabUrl + '?action=list&searchField=' + SchemePeriodSearchField + '&searchValue=' + this.getValue()});
	        	SchemePeriodTabDs.load({params:{start:0, limit:SchemePeriodTabPagingToolbar.pageSize}});
	    	}
	}
});



//添加按钮
var addButton = new Ext.Toolbar.Button({
	text: '添加',
    tooltip:'添加',        
    iconCls:'add',
	handler:function(){	
var data="";
var data1=[['01','01月'],['02','02月'],['03','03月'],['04','04月'],['05','05月'],['06','06月'],['07','07月'],['08','08月'],['09','09月'],['10','10月'],['11','11月'],['12','12月']];
var data2=[['01','01季度'],['02','02季度'],['03','03季度'],['04','04季度']];
var data3=[['01','1~6上半年'],['02','7~12下半年']];
var data4=[['00','00']];

		var yearField = new Ext.form.TextField({
			id:'yearField',
			fieldLabel: '所属年度',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(yearField.getValue()!=""){
							periodTypeField.focus();
						}else{
							Handler = function(){yearField.focus();}
							Ext.Msg.show({title:'错误',msg:'年度不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
	var periodTypeStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['M','月'],['Q','季'],['H','半年'],['Y','年']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '期间类型',
	width:180,
	//listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
	anchor: '90%',
	value:'', //默认值
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true,
		listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(periodTypeField.getValue()!=""){
							periodField.focus();
						}else{
							Handler = function(){periodTypeField.focus();}
							Ext.Msg.show({title:'错误',msg:'期间类型不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
});

periodTypeField.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){data=data1;}
	if(cmb.getValue()=="Q"){data=data2;}
	if(cmb.getValue()=="H"){data=data3;}
	if(cmb.getValue()=="Y"){data=data4;}
	periodStore.loadData(data);
	
});

periodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});

var periodField = new Ext.form.ComboBox({
	id: 'periodField',
	fieldLabel: '期间',
	width:180,
	//listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: periodStore,
	anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true,
	isteners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(periodField.getValue()!=""){
							startDate.focus();
						}else{
							Handler = function(){periodField.focus();}
							Ext.Msg.show({title:'错误',msg:'期间不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
});


var startDate = new Ext.form.DateField({
		id: 'startDate',
		fieldLabel: '开始时间',
		allowBlank: false,
		dateFormat: 'Y-m-d',
		emptyText:'',
		anchor: '90%',
			isteners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(startDate.getValue()!=""){
							endDate.focus();
						}else{
							Handler = function(){startDate.focus();}
							Ext.Msg.show({title:'错误',msg:'开始时间为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
});
var endDate = new Ext.form.DateField({
		id: 'endDate',
		fieldLabel: '结束时间',
		allowBlank: false,
		dateFormat: 'Y-m-d',
		emptyText:'',
		anchor: '90%',
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
				yearField,
				periodTypeField,
				periodField,
				startDate,
				endDate
			]
		});
		
		//初始化添加按钮
		addButton = new Ext.Toolbar.Button({
			text:'添 加'
		});
		
		//定义添加按钮响应函数
		addHandler = function(){
		
			var yeardr = yearField.getValue();
			var typedr = periodTypeField.getValue();
			var perioddr=periodField.getValue();
			var startdr1=startDate.getValue();
			var enddr1=endDate.getValue();
			
			if(startDate.getValue()!="")
			{
			 var startdr=startDate.getValue().format('Y-m-d');
			}
			if(endDate.getValue()!="")
			{
			 var enddr=endDate.getValue().format('Y-m-d');
			}
			yeardr = trim(yeardr);
			var temDate=""
			if(startDate>endDate){
				temDate=startDate;
				startDate=endDate;
				endDate=temDate;
			}
			//alert("yeardr"+yeardr+"typedr"+typedr+"perioddr"+perioddr+"startdr"+startdr+"enddr"+enddr);
			if(yeardr==""){
				Ext.Msg.show({title:'错误',msg:'年度为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(typedr==""){
				Ext.Msg.show({title:'错误',msg:'期间类型为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(perioddr==""){
				Ext.Msg.show({title:'错误',msg:'期间为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			
			if(startdr1==""){
				Ext.Msg.show({title:'错误',msg:'开始时间为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			
			if(enddr1==""){
				Ext.Msg.show({title:'错误',msg:'结束时间为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			
			if(enddr1<=startdr1){
				Ext.Msg.show({title:'错误',msg:'结束时间小于开始时间',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			
			
			Ext.Ajax.request({
				url: '../csp/dhc.bonus.schemeperiodexe.csp?action=add&yeardr='+yeardr+'&typedr='+typedr+'&perioddr='+perioddr+'&startdr='+startdr+'&enddr='+enddr,
				waitMsg:'保存中...',
				failure: function(result, request){
					Handler = function(){endDate.focus();}
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){endDate.focus();}
						Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
					
						SchemePeriodTabDs.load({params:{start:0, limit:SchemePeriodTabPagingToolbar.pageSize}});
						//addwin.close();
					}
					else
							{
								var message="添加年度期间已存在";
								
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
			height:300,
			minWidth: 400, 
			minHeight: 300,
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
		var rowObj=SchemePeriodTab.getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
var data="";
var data1=[['01','01月'],['02','02月'],['03','03月'],['04','04月'],['05','05月'],['06','06月'],['07','07月'],['08','08月'],['09','09月'],['10','10月'],['11','11月'],['12','12月']];
var data2=[['01','01季度'],['02','02季度'],['03','03季度'],['04','04季度']];
var data3=[['01','1~6上半年'],['02','7~12下半年']];
var data4=[['00','00']];


	var year1Field = new Ext.form.TextField({
			id:'year1Field',
			fieldLabel: '所属年度',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'所属年度...',
			valueNotFoundText:rowObj[0].get("bonusYear"),
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(year1Field.getValue()!=""){
							periodType1Field.focus();
						}else{
							Handler = function(){year1Field.focus();}
							Ext.Msg.show({title:'错误',msg:'年度不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
	
		var periodType1Store = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['M','月'],['Q','季'],['H','半年'],['Y','年']]
});
var periodType1Field = new Ext.form.ComboBox({
	id: 'periodType1Field',
	fieldLabel: '期间类型',
	width:180,
	//listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: periodType1Store,
	anchor: '90%',
	value:'', //默认值
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'',
	mode: 'local', //本地模式
	valueNotFoundText:rowObj[0].get("type"),
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true,
		listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(periodType1Field.getValue()!=""){
							period1Field.focus();
						}else{
							Handler = function(){periodType1Field.focus();}
							Ext.Msg.show({title:'错误',msg:'期间类型不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
});

periodType1Field.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){data=data1;}
	if(cmb.getValue()=="Q"){data=data2;}
	if(cmb.getValue()=="H"){data=data3;}
	if(cmb.getValue()=="Y"){data=data4;}
	period1Store.loadData(data);
	
});

period1Store = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});

var period1Field = new Ext.form.ComboBox({
	id: 'period1Field',
	fieldLabel: '期间',
	width:180,
	//listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: period1Store,
	anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueNotFoundText:rowObj[0].get("bonusPeriod"),
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'请选择期间...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true,
	isteners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(period1Field.getValue()!=""){
							start1Date.focus();
						}else{
							Handler = function(){period1Field.focus();}
							Ext.Msg.show({title:'错误',msg:'期间不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
});
	var start1Date = new Ext.form.DateField({
		id: 'start1Date',
		fieldLabel: '开始时间',
		allowBlank: false,
		dateFormat: 'Y-m-d',
		valueNotFoundText:rowObj[0].get("startDate"),
		emptyText:'选择开始时间...',
		anchor: '90%',
			isteners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(start1Date.getValue()!=""){
							end1Date.focus();
						}else{
							Handler = function(){start1Date.focus();}
							Ext.Msg.show({title:'错误',msg:'开始时间为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
});
var end1Date = new Ext.form.DateField({
		id: 'endDate',
		fieldLabel: '结束时间',
		allowBlank: false,
		valueNotFoundText:rowObj[0].get("endDate"),
		dateFormat: 'Y-m-d',
		emptyText:'选择结束时间...',
		anchor: '90%',
		listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
});
	
		
		//定义并初始化面板
		var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
				year1Field,
				periodType1Field,
				period1Field,
				start1Date,
				end1Date
			]
		});
	
		//面板加载
		formPanel.on('afterlayout', function(panel, layout){
			this.getForm().loadRecord(rowObj[0]);
			year1Field.setValue(rowObj[0].get("bonusYear"));
			periodType1Field.setValue(rowObj[0].get("type"));
			
			period1Field.setValue(rowObj[0].get("bonusPeriod"));	
			start1Date.setValue(rowObj[0].get("startDate"));	
			end1Date.setValue(rowObj[0].get("endDate"));		
			
		});
		
		//定义并初始化保存修改按钮
		var editButton = new Ext.Toolbar.Button({
			text:'保存修改'
		});
	
		//定义修改按钮响应函数
		editHandler = function(){
			
			var yeardr = year1Field.getValue();
			
			var typedr = periodType1Field.getValue();
			
			var perioddr=period1Field.getValue();
			var start=start1Date.getValue();
			var end=end1Date.getValue();
			
			if(start1Date.getValue()!="")
			{
			 var startdr=start1Date.getValue().format('Y-m-d');
			}
			if(end1Date.getValue()!="")
			{
			 var enddr=end1Date.getValue().format('Y-m-d');
			}
			yeardr = trim(yeardr);
			var temDate=""
			if(start1Date>end1Date){
				temDate=start1Date;
				start1Date=end1Date;
				end1Date=tem1Date;
			}
			//alert("yeardr"+yeardr+"typedr"+typedr+"perioddr"+perioddr+"startdr"+startdr+"enddr"+enddr);
			if(yeardr==""){
				Ext.Msg.show({title:'错误',msg:'年度为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(typedr==""){
				Ext.Msg.show({title:'错误',msg:'期间类型为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(perioddr==""){
				Ext.Msg.show({title:'错误',msg:'期间为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			
			if(start==""){
				Ext.Msg.show({title:'错误',msg:'开始时间为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			
			if(end==""){
				Ext.Msg.show({title:'错误',msg:'结束时间为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			
			if(end<=start){
				Ext.Msg.show({title:'错误',msg:'结束时间小于开始时间',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			Ext.Ajax.request({
				url: '../csp/dhc.bonus.schemeperiodexe.csp?action=edit&rowid='+rowid+'&yeardr='+yeardr+'&typedr='+typedr+'&perioddr='+perioddr+'&startdr='+startdr+'&enddr='+enddr,
				waitMsg:'保存中...',
				failure: function(result, request){
					Handler = function(){end1Date.focus();}
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						SchemePeriodTabDs.load({params:{start:0, limit:SchemePeriodTabPagingToolbar.pageSize}});
						editwin.close();						
					}
					else
						{
							var message="所选年度期间已存在";
						
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
		var rowObj=SchemePeriodTab.getSelections();
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
						url:'../csp/dhc.bonus.schemeperiodexe.csp?action=del&rowid='+rowid,
						waitMsg:'删除中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								SchemePeriodTabDs.load({params:{start:0, limit:SchemePeriodTabPagingToolbar.pageSize}});
								
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
var SchemePeriodTabPagingToolbar = new Ext.PagingToolbar({
    store: SchemePeriodTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg: "没有记录",
	buttons: ['-',SchemePeriodFilterItem,'-',SchemePeriodSearchBox]
	
	
});

//表格
var SchemePeriodTab = new Ext.grid.EditorGridPanel({
	title: '考核周期设置',
	store: SchemePeriodTabDs,
	cm: SchemePeriodTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:[addButton,'-',editButton,'-',delButton],
	bbar:SchemePeriodTabPagingToolbar
});
SchemePeriodTabDs.load({params:{start:0, limit:SchemePeriodTabPagingToolbar.pageSize}});
