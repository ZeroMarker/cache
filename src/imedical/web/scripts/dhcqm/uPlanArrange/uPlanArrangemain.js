var itemGridUrl = '../csp/dhc.qm.uPlanArrangeexe.csp';
//配件数据源
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var subStop=20;  //显示截取字符串的长度
var itemGridDs = new Ext.data.Store({
	proxy: itemGridProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'Rowid',
		'Title',
		'qmschemDr',
		'qmschemName',
		'deptGroupDr',
		'deptGroupName',
		'CheckStartDate',
		'CheckEndDate',
		'taskStart',
		'taskEndData',
		'checkUser',
		'checkUserName',
		'Status',
		'statusName'
		
	]),
	remoteSort: true
});
var QMSchemField="";
var nameField="";
//添加复选框
var sm = new Ext.grid.CheckboxSelectionModel();
var itemGridPagingToolbar = new Ext.PagingToolbar({
	pageSize: 15,
	store: itemGridDs,
	atLoad : true,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据"//,

});
//设置默认排序字段和排序方向
itemGridDs.setDefaultSort('Rowid', 'Title');

var CheckStartDate = new Ext.form.DateField({
	id:'CheckStartDate',
	//format:'Y-m-d',
	fieldLabel:'起始时间',
	//width:180,
	anchor: '90%',
	disabled:false,
	emptyText: '请选择起始时间...',
	listeners :{
		specialKey :function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER){
				if(startDate.getValue()!=""){
					endDate.focus();
				}else{
					Handler = function(){startDate.focus();}
					Ext.Msg.show({title:'提示',msg:'起始时间不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
				}
			}
		}
	}
});
		
		//定义结束时间控件
var CheckEndDate = new Ext.form.DateField({
	id:'CheckEndDate',
	//format:'Y-m-d',
	fieldLabel:'结束时间',
	//width:180,
	anchor: '90%',
	disabled:false,
	emptyText: '请选择结束时间...',
	listeners :{
		specialKey :function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER){
				if(endDate.getValue()!=""){
					
				}else{
					Handler = function(){endDate.focus();}
					Ext.Msg.show({title:'提示',msg:'结束时间不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
				}
			}
		}
	}
});
		
		
var userdDs = new Ext.data.Store({   //解析数据源   
	proxy: "",
	reader: new Ext.data.JsonReader({
		totalProperty: 'results',
		root: 'rows'	
	},['grupRowid','grupName'])	
});

userdDs.on('beforeload',function(ds,o){  //数据源监听函数调用后台类方法查询数据
	ds.proxy = new Ext.data.HttpProxy({
		url:'dhc.qm.uPlanArrangeexe.csp'+'?action=userList&str='+encodeURIComponent(Ext.getCmp('userdField').getRawValue()),method:'POST'
	});	
});

var userdField= new Ext.form.ComboBox({   //定义单位组合控件
	id: 'userdField',
	fieldLabel: '检查人',
	store: userdDs,
	anchor: '90%',
	valueNotFoundText:'',
	displayField: 'grupName',
	valueField: 'grupRowid',
	triggerAction: 'all',
	emptyText: '请选择...',
	pageSize: 10,
	minChars: 1,
	
	forceSelection: false	
});
/*var uTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['0', '未完成'], ['1', '完成']]
	});
	var StatusField = new Ext.form.ComboBox({
	    id : 'StatusField',
		fieldLabel : '检查状态',
		width : 100,
		listWidth : 200,
		store : uTypeDs,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // 本地模式
		triggerAction: 'all',
		emptyText:'请选择...',
		selectOnFocus:true,
		forceSelection : true
	});	*/
var tmpTitle='计划安排设置';

//数据库数据模型
var itemGridCm = new Ext.grid.ColumnModel([
	{

		id:'Rowid',
		header: 'ID',
		allowBlank: false,
		width:100,
		editable:false,
		dataIndex: 'Rowid',
		hidden:'true'
	   
   }, {
		id:'Title',
		header: '检查标题',
		allowBlank: false,
		width:80,
	   editable:false,
		dataIndex: 'Title'
		
   }, {
		id:'qmschemName',
		header: '检查内容',
		allowBlank: false,
		width:100,
		editable:false,
		dataIndex: 'qmschemName',
		renderer:function(value,meta,record){
			var dot="";
			 if(value.length>subStop){
					  meta.attr = 'ext:qtitle  ext:qtip="'+value+'"';
					  dot="...";
				  }else{
					
				  }
				return value.substring(0,subStop)+dot; 
			
		}
   },{
		id:'checkUserName',
		header: '检查人员',
		allowBlank: false,
		width:40,
		editable:false,
		dataIndex: 'checkUserName'
            
   }, {
		id:'checkUser',
		header: '检查人员ID',
		allowBlank: false,
		width:40,
		editable:false,
		dataIndex: 'checkUser',
		hidden:true
            
   },{
		id:'CheckStartDate',
		header: '开始日期',
		allowBlank: false,
		width:35,
		editable:false,
		dataIndex: 'CheckStartDate'
            
   }, {
		id:'CheckEndDate',
		header: '结束日期',
		allowBlank: false,
		width:35,
		editable:false,
		dataIndex: 'CheckEndDate'
            
   },{
		id:'taskStart',
		header: '任务开始日期',
		allowBlank: false,
		width:35,
		editable:false,
		dataIndex: 'taskStart'
		
   },{
		id:'taskEndData',
		header: '任务结束日期',
		allowBlank: false,
		width:35,
		editable:false,
		dataIndex: 'taskEndData'
		
   }, {
		id:'statusName',
		header: '检查状态',
		allowBlank: false,
		width:25,
		editable:false,
		dataIndex: 'statusName'
		
   }, {
		id:'deptGroupName',
		header: '检查科室',
		allowBlank: false,
		//width:100,
		editable:false,
		dataIndex: 'deptGroupName',
		renderer:function(value,meta,record){
			/*if(value!=""){
			 return '<div class="x-grid3-cell-inner x-grid3-col-linker" unselectable="on" ext:qtitle ext:qtip="'+value+'">'+value+'</div>'
			}*/
			var dot="";
			 if(value.length>subStop){
					  meta.attr = 'ext:qtitle  ext:qtip="'+value+'"';
					  dot="...";
				  }else{
					
				  }
				return value.substring(0,subStop)+dot; 
		}
          
    }
			    
]);
//查询功能
var SearchButton = new Ext.Toolbar.Button({
    text: '查询', 
    tooltip:'查询',        
    iconCls:'search',
	handler:function(){	
	//alert(userdField.getValue());
	var user=userdField.getRawValue();
	//alert(user);
	if(user!=""){
		var userDr= userdField.getValue();
	}else{
	    var userDr="";
	}
	var CheckStartDate = Ext.getCmp('CheckStartDate').getValue();
    var CheckEndDate = Ext.getCmp('CheckEndDate').getValue();
    if(CheckStartDate!=""){
		CheckStartDate = CheckStartDate.format('Y-m-d');
	}
	if(CheckEndDate!=""){
		CheckEndDate = CheckEndDate.format('Y-m-d');
	}  
	itemGridDs.load(({params:{start:0,limit:itemGridPagingToolbar.pageSize,CheckStartDate:CheckStartDate,CheckEndDate:CheckEndDate,userDr:userDr}}));}
});
var addButton = new Ext.Toolbar.Button({
	text : '新建',
	tooltip : '新建',
	iconCls : 'add',
	handler : function() {
		sysorgaffiaddFun(itemGridDs,itemGridPagingToolbar);
	}
});
//2016-6-30 cyl add  修改按钮			
var xiuButton = new Ext.Toolbar.Button({
	text : '修改',
	tooltip : '修改',
	iconCls : 'edit',
	handler : function() {
		editFun(itemGrid);
	}
});
var editButton = new Ext.Toolbar.Button({
	text : '作废',
	tooltip : '作废',
	iconCls : 'stop',
	handler : function() {
		var rowObj=itemGrid.getSelectionModel().getSelections();
	    var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要作废的记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{	
			var rowId = rowObj[0].get("Rowid");
		}
		function handler(id){          
			if(id=="yes"){
                Ext.Ajax.request({
					url:'dhc.qm.uPlanArrangeexe.csp?action=edit&rowId='+rowId,
				
					waitMsg:'保存中...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
				
					success: function(result, request){
			   		var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'作废成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});		
					}
					else
					{
						var message="已存在相同记录";
						Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					};
			      },
				scope: this
			   });
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要作废该条记录吗?',handler);
	}

});
				


var itemGrid = new Ext.grid.GridPanel({
	        
	//title: '绩效单位记录',
	region: 'center',
	layout:'fit',
	width: 400,
	readerModel:'local',
	url: 'dhc.qm.uPlanArrange.csp',
	split: true,
	collapsible: true,
	containerScroll: true,
	store: itemGridDs,
	cm: itemGridCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	viewConfig: {forceFit:true},
	tbar: ['开始期间:','-',CheckStartDate,'结束期间 :','-',CheckEndDate,'检查人 :','-',userdField,'-',SearchButton,'-',addButton,'-',xiuButton,'-',editButton],
	bbar:itemGridPagingToolbar
});
itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});




