/**
  *name:tab of database
  *author:zhaoliguo
  *Date:2016-8-29
 */
 function formatDate(value){
	//alert(value);
	return value?value.dateFormat('Y-m-d'):'';
};
var InvoicingManagementTabUrl = '../csp/dhc.bonus.invoicingmanagementexe.csp';
function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

//配件数据源

var InvoicingManagementTabProxy= new Ext.data.HttpProxy({url:InvoicingManagementTabUrl + '?action=list'});
var InvoicingManagementTabDs = new Ext.data.Store({
	proxy: InvoicingManagementTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
	
		'rowid',
		'bonusYear',
		'bonusPeriod',
		'flag',
		'updateDate',
		'type',
		'flag1',
		{name:'updateDate',type:'date',dateFormat:'Y-m-d'},
	]),
    // turn on remote sorting
    remoteSort: true
});

//设置默认排序字段和排序方向
InvoicingManagementTabDs.setDefaultSort('rowid', 'name');

//数据库数据模型
var InvoicingManagementTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
    	header: '所属年度',
        dataIndex: 'bonusYear',
        width: 100,		  
        sortable: true
    },{
    	header: '所属月份',
        dataIndex: 'bonusPeriod',
        width: 100,
        sortable: true
    },{
    	header: '状态',
        dataIndex: 'flag',
        width: 150,
        sortable: true
    },{
    	header: '更新时间',
        dataIndex: 'updateDate',
        width: 150,
		renderer:formatDate,
        sortable: true
    }
    
]);

//初始化默认排序功能
InvoicingManagementTabCm.defaultSortable = true;


//初始化搜索字段
var InvoicingManagementSearchField ='name';

//搜索过滤器
var InvoicingManagementFilterItem = new Ext.Toolbar.MenuButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '所属年度',
			value: 'bonusYear',
			checked: false ,
			group: 'InvoicingManagementFilter',
			checkHandler: onInvoicingManagementItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '所属月份',
			value: 'bonusPeriod',
			checked: true,
			group: 'InvoicingManagementFilter',
			checkHandler: onInvoicingManagementItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '状态',
			value: 'flag',
			checked: true,
			group: 'InvoicingManagementFilter',
			
			checkHandler: onInvoicingManagementItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '更新时间',
			value: 'updateDate',
			checked: true,
			renderer:formatDate,
			group: 'InvoicingManagementFilter',
			checkHandler: onInvoicingManagementItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '状态(代码)',
			value: 'flag1',
			checked: true,
			
			group: 'InvoicingManagementFilter',
			checkHandler: onInvoicingManagementItemCheck 
		})
	]}
});

//定义搜索响应函数
function onInvoicingManagementItemCheck (item, checked){
	if(checked) {
		InvoicingManagementSearchField = item.value;
		InvoicingManagementFilterItem.setText(item.text + ':');
	}
};

//查找按钮
var InvoicingManagementSearchBox = new Ext.form.TwinTriggerField({
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
			InvoicingManagementTabDs.proxy = new Ext.data.HttpProxy({url:  InvoicingManagementTabUrl + '?action=list'});
			InvoicingManagementTabDs.load({params:{start:0, limit:InvoicingManagementTabPagingToolbar.pageSize}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
				InvoicingManagementTabDs.proxy = new Ext.data.HttpProxy({
				url: InvoicingManagementTabUrl + '?action=list&searchField=' + InvoicingManagementSearchField + '&searchValue=' + this.getValue()});
	        	InvoicingManagementTabDs.load({params:{start:0, limit:InvoicingManagementTabPagingToolbar.pageSize}});
	    	}
	}
});

//财务核算
var accountingButton = new Ext.Toolbar.Button({
	text: '奖金核算',
    tooltip:'奖金正在核算中',        
    iconCls:'remove',
	handler:function(){
		//定义并初始化行对象
		var rowObj=InvoicingManagementTab.getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要核算的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
		
		var flag = rowObj[0].get("flag1");
		if(flag!=0){
			Ext.Msg.show({title:'注意',msg:'不是“待核算”状态，不能进行核算!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		
		function handler(id){
			if(id=="yes"){
				
					Ext.Ajax.request({
						url:'../csp/dhc.bonus.invoicingmanagementexe.csp?action=accounting&rowid='+rowid,
						waitMsg:'核算中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'核算成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								InvoicingManagementTabDs.load({params:{start:0, limit:InvoicingManagementTabPagingToolbar.pageSize}});
								
							}else{
								Ext.Msg.show({title:'错误',msg:'核算失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要核算该条记录吗?',handler);
	}
});

//取消核算
var cancelaccountingButton = new Ext.Toolbar.Button({
	text: '取消核算',
    tooltip:'取消核算后，进行指标采集、录入等',        
    iconCls:'remove',
	handler:function(){
		//定义并初始化行对象
		var rowObj=InvoicingManagementTab.getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要取消核算的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
		
		var flag = rowObj[0].get("flag1");
		if(flag!=1){
			Ext.Msg.show({title:'注意',msg:'不是“核算”状态，不能取消核算!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		
		function handler(id){
			if(id=="yes"){
				
					Ext.Ajax.request({
						url:'../csp/dhc.bonus.invoicingmanagementexe.csp?action=cancelaccounting&rowid='+rowid,
						waitMsg:'取消核算中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'取消核算成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								InvoicingManagementTabDs.load({params:{start:0, limit:InvoicingManagementTabPagingToolbar.pageSize}});
								
							}else{
								Ext.Msg.show({title:'错误',msg:'取消核算失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要对该条记录取消核算吗?',handler);
	}
});

//财务结账
var invoicingButton = new Ext.Toolbar.Button({
	text: '奖金结账',
    tooltip:'结账后，奖金不能再核算',        
    iconCls:'remove',
	handler:function(){
		//定义并初始化行对象
		var rowObj=InvoicingManagementTab.getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要结账的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
		
		var flag = rowObj[0].get("flag1");
		if(flag!=1){
			Ext.Msg.show({title:'注意',msg:'不是“核算”状态，不能进行结账!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		
		function handler(id){
			if(id=="yes"){
				
					Ext.Ajax.request({
						url:'../csp/dhc.bonus.invoicingmanagementexe.csp?action=invoicing&rowid='+rowid,
						waitMsg:'结账中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'结账成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								InvoicingManagementTabDs.load({params:{start:0, limit:InvoicingManagementTabPagingToolbar.pageSize}});
								
							}else{
								Ext.Msg.show({title:'错误',msg:'结账失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要结账该条记录吗?',handler);
	}
});

//取消结账
var cancelinvoicingButton = new Ext.Toolbar.Button({
	text: '取消结账',
    tooltip:'取消结账',        
    iconCls:'remove',
	handler:function(){
		//定义并初始化行对象
		var rowObj=InvoicingManagementTab.getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要取消结账的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
		
		var flag = rowObj[0].get("flag1");
		if(flag!=2){
			Ext.Msg.show({title:'注意',msg:'数据未结账，不能取消结账!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		
		function handler(id){
			if(id=="yes"){
				
					Ext.Ajax.request({
						url:'../csp/dhc.bonus.invoicingmanagementexe.csp?action=cancelinvoicing&rowid='+rowid,
						waitMsg:'取消结账中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'取消结账成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								InvoicingManagementTabDs.load({params:{start:0, limit:InvoicingManagementTabPagingToolbar.pageSize}});
								
							}else{
								Ext.Msg.show({title:'错误',msg:'取消结账失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要对该条记录取消结账吗?',handler);
	}
});



//分页工具栏
var InvoicingManagementTabPagingToolbar = new Ext.PagingToolbar({
    store: InvoicingManagementTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg: "没有记录",
	buttons: ['-',InvoicingManagementFilterItem,'-',InvoicingManagementSearchBox]
	
	
});

//表格
var InvoicingManagementTab = new Ext.grid.EditorGridPanel({
	title: '财务结账设置',
	store: InvoicingManagementTabDs,
	cm: InvoicingManagementTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:[accountingButton,'-',cancelaccountingButton,'-',invoicingButton,'-',cancelinvoicingButton],
	bbar:InvoicingManagementTabPagingToolbar
});
InvoicingManagementTabDs.load({params:{start:0, limit:InvoicingManagementTabPagingToolbar.pageSize}});
