//添加按钮
var AddButton = new Ext.Toolbar.Button({
      text : '添加',
	  tooltip : '添加',
	  iconCls : 'add',
      handler : function(){AddFun();}
});

//修改按钮
var EditButton = new Ext.Toolbar.Button({
      text : '修改',
	  tooltip : '修改',
	  iconCls : 'add',
      handler : function(){
	  var rowObj=MainGrid.getSelections();
	  if ( rowObj.length<1)
	  {
	  	Ext.Msg.show({
						title : '提示',
						msg : '请选择要修改的数据！!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
		return;
	  }
	  else if (rowObj.length>1)
	  {
	  	Ext.Msg.show({
						title : '提示',
						msg : '每次只能修改一条数据，请您重新选择！!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
		return;
	  }
	  else
	  {EditFun(rowObj);}
	}
});

//删除按钮
var DelButton = new Ext.Toolbar.Button({
      text : '删除',
	  tooltip : '删除',
	  iconCls : 'remove',
	  handler : function(){
	 function handler1(id){ 	
	  if(id=="yes"){
	   var rowObj=MainGrid.getSelections();
	  if ( rowObj.length>0)
	  {
	    var rowIdArry = [];
		var data = "";
	    for (var i=0;i<rowObj.length;i++)
		 {
		  //rowIdArry.push(rowObj[i].get("rowid"));
		  if(data!="")
		   data = data+'^'+ rowObj[i].get("rowid");
		  else
		   data=rowObj[i].get("rowid");
		 }
	     //alert(data);
		 request('del',data);
		 //重新刷新页面
		 FindButton.handler();
	  }
	}else{
					return;
				}
		}		
	Ext.MessageBox.confirm('提示','确实要删除吗?',handler1);			
	  //------
	  }
	  

	

			
			
});

//查询按钮
var FindButton = new Ext.Toolbar.Button({
    text : '查询',
	tooltip : '查询',
	iconCls : 'find',
	handler : function(){
	     var data = DeptFiled.getValue()+"^"+WorkItemFiled.getValue();
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
					
					Ext.Msg.show({
								    title : '注意',
									msg : '成功!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
											});
					} 
					else {
					        flag = jsonData.info;
							if (flag=="RepCode")
							{
							Ext.Msg.show({
											title : '错误',
											msg : '数据有重复！',
										    buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
											});
							}
							else
							{
							Ext.Msg.show({
											title : '错误',
											msg : '错误！',
										    buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
											});
							}
										
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
	  var rowObj=MainGrid.getSelections();
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
					}, ['rowid', 'BonusTarget', 'DragName', 'InputProport','UpdateDate']),
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
			header : '奖金指标',
			dataIndex : 'BonusTarget',
			width : 150,
			sortable : true

		}, {
			header : 'Drag名称',
			dataIndex : 'DragName',
			width : 150,
			sortable : true
		}, {
			header : '录入比例',
			dataIndex : 'InputProport',
			width : 80,
			align:'right',
			sortable : true
		}, {
			header : '修改时间',
			dataIndex : 'UpdateDate',
			width : 100,
			align:'right',
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
DeptWorkDs.load({params:{start:0,limit:DeptWorkPagTba.pageSize}});	
var MainGrid = new Ext.grid.EditorGridPanel({
			title : 'Drgs指标映射',
			store : DeptWorkDs,
			cm : DeptWorkCm,
			clicksToEdit : 1,
			trackMouseOver : true,
			stripeRows : true,
			sm: new Ext.grid.CheckboxSelectionModel({singleSelect:false}),
			tbar : ['奖金指标:',DeptFiled,'-','Drag名称:',WorkItemFiled,'-',FindButton,'-',AddButton,'-',EditButton ,'-',DelButton],
			bbar:DeptWorkPagTba,
			loadMask : true
	
		}); 