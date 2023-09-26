var StratagemTabUrl = '../csp/dhc.bonus.calculateworkexe.csp';
//日期下拉框
 var YearMonth = new Ext.ux.MonthField({   
     id:'month',   
     fieldLabel: '月份',   
     allowBlank:false,   
     readOnly : true,   
     format:'Y-m',   
        listeners:{"blur":function(){   
        //alert(this.getValue()); 
  }}   
});   
	

//科室下拉框
var DeptDataStor  = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'DeptCode','DeptName'])
		});

DeptDataStor.on('beforeload',function(ds,o){
    ds.proxy = new Ext.data.HttpProxy({
    url:StratagemTabUrl + '?action=GetDept&str='+DeptFiled.getValue(),
	method : 'POST'
					})
});


var DeptFiled = new Ext.form.ComboBox({
    id:'DeptFiled',
	fieldLabel:'核算科室',
	width:80,
	listWidth:205,
	anchor : '100%',
	allowBlank:true,
	valueField:'rowid',
	displayField:'DeptName',
	store : DeptDataStor,
	triggerAction : 'all',
	name : 'DeptFiled',
	emptyText:"",
	minChars:1,
	pageSize:10,
	editable:true,
	selectOnFocus : false,
	forceSelection : 'true',
	editable : true
});

//工作项目下拉框
var WorkItemStor = new Ext.data.Store({
 autoLoad:true,
 proxy:"",
 reader:new Ext.data.JsonReader({
 totalProperty:'results',
 root:'rows'
 },['rowid','WorkItemCode','WorkItemName'])
});

WorkItemStor.on('beforeload',function(ds,o){
    ds.proxy = new Ext.data.HttpProxy({
    url:StratagemTabUrl + '?action=GetWorkItem',
	method : 'POST'
					})
});

var WorkItemFiled = new Ext.form.ComboBox({
    id:'WorkItemFiled',
	fieldLabel:'工作项目',
	width:80,
	listWidth:205,
	anchor : '100%',
	allowBlank:true,
	valueField:'rowid',
	displayField:'WorkItemName',
	store : WorkItemStor,
	triggerAction : 'all',
	name : 'WorkItemFiled',
	emptyText:"",
	minChars:1,
	pageSize:10,
	editable:true,
	selectOnFocus : false,
	forceSelection : 'true',
	editable : true
});

//数据接口下拉框
var DataInterfStor = new Ext.data.Store({
 autoLoad:true,
 proxy:"",
 reader:new Ext.data.JsonReader({
 totalProperty:'results',
 root:'rows'
 },['rowid','DataInter'])
});

DataInterfStor.on('beforeload',function(ds,o){
    ds.proxy = new Ext.data.HttpProxy({
    url:StratagemTabUrl + '?action=GetInterf',
	method : 'POST'
					})
});



var DataInterFiled = new Ext.form.ComboBox({
    id:'DataInterFiled',
	fieldLabel:'数据接口',
	width:103,
	listWidth:205,
    anchor : '100%',
	allowBlank:true,
	valueField:'rowid',
	displayField:'DataInter',
	store : DataInterfStor,
	triggerAction : 'all',
	name : 'DataInterFiled',
	emptyText:"",
	minChars:1,
	pageSize:10,
	editable:true,
	selectOnFocus : false,
	forceSelection : 'true',
	editable : true
});

//查询按钮
var FindButton = new Ext.Toolbar.Button({
    text : '查询',
	tooltip : '查询',
	iconCls : 'find',
	handler : function(){
	     var data = YearMonth.getRawValue()+"^"+DeptFiled.getValue()+"^"+WorkItemFiled.getValue();
	     //alert(data);
	     DeptWorkDs.load({
					params:{
							start : 0,
							limit : DeptWorkPagTba.pageSize,
							data:data
							}
					});
	}
});

//计算按钮
var CalculateButton = new Ext.Toolbar.Button({
    text : '计算',
	tooltip : '计算',
	iconCls : 'add',
	handler : function(){
	  if(YearMonth.getRawValue()=="")
	  {
	  	Ext.Msg.show({
						title : '提示',
						msg : '请选择所属年月！!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
		return;
	  }
	 else
	 {
	 	Ext.MessageBox.confirm("计算确认",'您将要计算'+YearMonth.getRawValue()+"的数据，是否确认计算?",function(btn){  
         if(btn=='yes')
		 {
		   var data =YearMonth.getRawValue()+"^"+DataInterFiled.getValue()+"^"+DeptFiled.getValue()+"^"+WorkItemFiled.getValue();
	       request('calculat',data);
		   //重新刷新页面
		   FindButton.handler();
		 }
	
	   });
	 }

	return;
	
	}
});


//此函数用于前后台交互
function request(actions,data){
Ext.Ajax.request({
		//url: StratagemTabUrl+'?action=check&data='+data,
		url: StratagemTabUrl+'?action='+actions+'&data='+data,
		waitMsg : '处理中...',
		failure : function(result, request) {
			Ext.Msg.show({
						title : '错误',
						msg : '请检查网络连接!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
				},
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
					flag = jsonData.info;
					Ext.Msg.show({
								    title : '注意',
									msg : '成功!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
											});
					} 
					else {
										Ext.Msg.show({
											title : '错误',
											msg : '错误',
										    buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
											});
					}
										
		},
	scope : this
  });
return;
}


//审核按钮
var CheckButton = new Ext.Toolbar.Button({
    text : '审核',
	tooltip : '审核',
	iconCls : 'add',
	handler : function(){
	  var data = "";
	  var rowObj=DeptWorkGrid.getSelections();
	  if ( YearMonth.getRawValue()=="")
	  {
	     alert("请选择要审核的数据.....");
	  }
	  else if(YearMonth.getRawValue()!="")
	  {
		   Ext.MessageBox.confirm("审核确认",'您将要审核'+YearMonth.getRawValue()+"的数据，是否确认审核?",function(btn){  
               if (btn == 'yes') { 
				 data = session['LOGON.USERNAME']+'||'+YearMonth.getRawValue();
				 //alert(data);
				 request('check',data);
				 //重新刷新页面
		         FindButton.handler();
			} 		   
           });  
	  }
	return;
	}
});



//科室工作量数据  dhc.bonus.targetCollect

var DeptWorkProxy = new Ext.data.HttpProxy({
			url : StratagemTabUrl + '?action=list'
		});
var DeptWorkDs = new Ext.data.Store({
			proxy : DeptWorkProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowid', 'YearMonths', 'Dept', 'ProjectClass',
							'WorkItem', 'Counts','Price','Amount', 'DataState', 'Checker',
							'CheckDate', 'CollectDate']),
			// turn on remote sorting
			remoteSort : true
		});                              
var DeptWorkCm = new Ext.grid.ColumnModel([new Ext.grid.CheckboxSelectionModel(), {
			header : 'RowID',
			dataIndex : 'rowid',
			width : 40,
			hidden:'true',
			sortable : true

		}, {
			header : '年月',
			dataIndex : 'YearMonths',
			width : 70,
			sortable : true

		}, {
			header : '所属科室',
			dataIndex : 'Dept',
			width : 100,
			sortable : true
		}, {
			header : '项目分类',
			dataIndex : 'ProjectClass',
			width : 100,
			sortable : true
		}, {
			header : '工作量项目',
			dataIndex : 'WorkItem',
			width : 80,
			sortable : true
		}, {
			header : '数量',
			dataIndex : 'Counts',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : '单价',
			dataIndex : 'Price',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : '金额',
			dataIndex : 'Amount',
			width : 90,
			align : 'right',
			sortable : true
		}, {
			header : '数据状态',
			dataIndex : 'DataState',
			width : 80,
			sortable : true
		}, {
			header : '审核人',
			dataIndex : 'Checker',
			width : 80,
			sortable : true
		}, {
			header : '审核时间',
			align : 'right',
			dataIndex : 'CheckDate',
			width : 80,
			sortable : true
		}, {
			header : '计算时间',
			align : 'right',
			dataIndex : 'CollectDate',
			width : 120,
			sortable : true
		}
		]);
		
var DeptWorkPagTba = new Ext.PagingToolbar({
			store : DeptWorkDs,
			pageSize : 25,
			displayInfo : true,
			displayMsg : '当前显示{0} - {1}，共计{2}',
			emptyMsg : "没有记录"
			// buttons: ['-',StratagemFilterItem,'-',StratagemSearchBox],
		});
	
// 表格
 var tbar1 = new Ext.Toolbar(['数据接口:', DataInterFiled,'-',CalculateButton,'-',CheckButton]); 

var DeptWorkGrid = new Ext.grid.EditorGridPanel({
			title : '科室工作量维护',
			store : DeptWorkDs,
			cm : DeptWorkCm,
			clicksToEdit : 1,
			trackMouseOver : true,
			stripeRows : true,
			sm: new Ext.grid.CheckboxSelectionModel({singleSelect:false}),
			tbar : ['所属年月:', YearMonth,'-','科室:',DeptFiled,'-','工作项目:',WorkItemFiled,'-',FindButton,'-',CalculateButton,'-',CheckButton],
			bbar:DeptWorkPagTba,
			loadMask : true
			/*,
			listeners : { 
            'render': function(){ 
            	tbar1.render(DeptWorkGrid.tbar); 
            } 
            
           } */
		}); 