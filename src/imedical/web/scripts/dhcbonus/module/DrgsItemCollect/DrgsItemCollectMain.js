//数据采集按钮
var DataCollect = new Ext.Toolbar.Button({
      text : '数据采集',
	  tooltip : '数据采集',
	  iconCls : 'add',
      handler : function(){
	  alert("数据采集功能在这里添加！");
	  }
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


//查询按钮
var FindButton = new Ext.Toolbar.Button({
    text : '查询',
	tooltip : '查询',
	iconCls : 'find',
	handler : function(){
	     var data = YearMonth.getRawValue()+"^"+WorkItemFiled.getValue();
	     DeptWorkDs.load({
					params:{
							start : 0,
							limit : DeptWorkPagTba.pageSize,
							data:data
							}
					});
	}
});




//审核按钮
var CheckButton = new Ext.Toolbar.Button({
    text : '审核',
	tooltip : '审核',
	iconCls : 'add',
	handler : function(){
	  var data = "";
	  var rowObj=MainGrid.getSelections();
	  if ((YearMonth.getRawValue()=="")&&(rowObj.length<1))
	  {
	     alert("请选择要审核的数据.....");
	  }
	  else if((YearMonth.getRawValue()!="")&&(rowObj.length<1))
	  {
		   Ext.MessageBox.confirm("审核确认",'您将要审核'+YearMonth.getRawValue()+"的数据，是否确认审核?",function(btn){  
               if (btn == 'yes') { 
				 data ="A"+"||"+ session['LOGON.USERNAME']+'||'+YearMonth.getRawValue();
				 //alert(data);
				 request('check',data);
				 //重新刷新页面
		         FindButton.handler();
			} 		   
           });  
	  }
	  else
	  {
	    Ext.MessageBox.confirm("审核确认",'您将要审核已选的'+rowObj.length+"条数据，是否确认审核?",function(btn){  
		if (btn == 'yes') { 
	      for (var i=0;i<rowObj.length;i++)
		   {
		    //rowIdArry.push(rowObj[i].get("rowid"));
		    if(data!="")
		     data = data+'^'+ rowObj[i].get("rowid");
		    else
		     data=rowObj[i].get("rowid");
		  }
	      data = "B"+"||"+session['LOGON.USERNAME']+'||'+data
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
					}, ['rowid', 'YearMonth', 'DeptName', 'DrgsName','NumDiseases','CMI','CostFactor','CollectDate','State','CheckDate']),
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
			dataIndex : 'YearMonth',
			width : 120,
			sortable : true

		}, {
			header : '科室名称',
			dataIndex : 'DeptName',
			width : 120,
			sortable : true
		}, {
			header : 'Drgs名称',
			dataIndex : 'DrgsName',
			width : 120,
			//align:'right',
			sortable : true
		}, {
			header : '病种数量',
			dataIndex : 'NumDiseases',
			width : 100,
			align:'right',
			sortable : true
		}, {
			header : 'CMI值',
			dataIndex : 'CMI',
			width : 100,
			align:'right',
			sortable : true
		}, {
			header : '费用系数',
			dataIndex : 'CostFactor',
			width : 100,
			align:'right',
			sortable : true
		}, {
			header : '采集时间',
			dataIndex : 'CollectDate',
			width : 100,
			align:'right',
			sortable : true
		}, {
			header : '数据状态',
			dataIndex : 'State',
			width : 100,
			//align:'right',
			sortable : true
		}, {
			header : '审核时间',
			dataIndex : 'CheckDate',
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
			title : 'Drgs项目数据采集',
			store : DeptWorkDs,
			cm : DeptWorkCm,
			clicksToEdit : 1,
			trackMouseOver : true,
			stripeRows : true,
			sm: new Ext.grid.CheckboxSelectionModel({singleSelect:false}),
			tbar : ['所属年月:',YearMonth,'-','Drag名称:',WorkItemFiled,'-',FindButton,'-',DataCollect,'-',CheckButton],
			bbar:DeptWorkPagTba,
			loadMask : true
	
		}); 