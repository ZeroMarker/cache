/*
* 工作量主模板
* 2016-05-05 guojing
*/



function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}

var DetailUrl = '../csp/dhc.bonus.rvstemplateexe.csp';
//var DetailProxy = new Ext.data.HttpProxy({url:DetailUrl + '?action=detaillist&start=0&limit=10'});
var DetailProxy = '';

var DetailDs = new Ext.data.Store({
	proxy: DetailProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
       // 'rvsTemplateDetailID',
        'rowid',
		'rvsTemplateMainID',
		'BonusSubItemID',
		'useMinuteValue',
		'workRiskValue',
		'techDifficultyValue',
		'workCostValue',
		'makeRate',
		'execRate',
		'makeItemScore',
		'execItemScore'
	]),
    // turn on remote sorting
    //remoteSort: true     //排序
    pruneModifiedRecords:true
});


var useMinuteFieldStore = new Ext.data.SimpleStore({
            fields : ['key', 'keyValue'],
            data :[['5','0-20分钟'],['4','20-40分钟'],['3','40-60分钟'],['2','60-90分钟'],['1','90分钟以上']]
      });
var useMinuteField = new Ext.form.ComboBox({
	       id : 'useMinuteField',
	       //name:'useMinuteField',
	       fieldLabel : '用时值',
	       width : 120,
	       selectOnFocus : true,
	      //allowBlank : false,
	      store : useMinuteFieldStore,
    	  anchor : '95%',			
	      displayField : 'keyValue',  //下拉框显示的值
	      valueField : 'key',
	      triggerAction : 'all',
	      emptyText : '',
	      mode : 'local', // 本地模式
	      //editable : false,
	      selectOnFocus : true,
	      forceSelection : true
      });  
      
      var workRiskFieldStore = new Ext.data.SimpleStore({
            fields : ['key', 'keyValue'],
            data : [['6','极高'],['5','较高'],['4','一般'],['3','较低'],['2','极低'],['1','无']]
      });
    
      var workRiskField = new Ext.form.ComboBox({
	       id : 'workRiskField',
	       fieldLabel : '风险值',
	       width : 120,
	       selectOnFocus : true,
	      //allowBlank : false,
	      store : workRiskFieldStore,
    	  anchor : '95%',			
	      displayField : 'keyValue',  //下拉框显示的值
	      valueField : 'key',
	      triggerAction : 'all',
	      emptyText : '',
	      mode : 'local', // 本地模式
	      //editable : false,
	      selectOnFocus : true,
	      forceSelection : true
      });  
      
      
       var techDifficultyFieldStore = new Ext.data.SimpleStore({
            fields : ['key', 'keyValue'],
            data : [['6','高难'],['5','较难'],['4','一般'],['3','低难'],['2','较易'],['1','无']]
      });
    
      var techDifficultyField = new Ext.form.ComboBox({
	       id : 'techDifficultyField',
	       fieldLabel : '难度值',
	       width : 120,
	       selectOnFocus : true,
	      //allowBlank : false,
	      store : techDifficultyFieldStore,
    	  anchor : '95%',			
	      displayField : 'keyValue',  //下拉框显示的值
	      valueField : 'key',
	      triggerAction : 'all',
	      emptyText : '',
	      mode : 'local', // 本地模式
	      //editable : false,
	      selectOnFocus : true,
	      forceSelection : true
      });  
      
       var workCostFieldStore = new Ext.data.SimpleStore({
            fields : ['key', 'keyValue'],
            data : [['6','最高'],['5','较高'],['4','一般'],['3','较低'],['2','最低'],['1','无']]
      });
    
      var workCostField = new Ext.form.ComboBox({
	       id : 'workCostField',
	       fieldLabel : '工作消耗值',
	       width : 120,
	       selectOnFocus : true,
	      //allowBlank : false,
	      store : workCostFieldStore,
    	  anchor : '95%',			
	      displayField : 'keyValue',  
	      valueField : 'key',
	      triggerAction : 'all',
	      emptyText : '',
	      mode : 'local', // 本地模式
	      selectOnFocus : true,
	      forceSelection : true
	      
      });  
 
 var makeRateField = new Ext.form.TextField({
	                    id:'makeRateField',
						allowBlank:false,
						name : 'makeRate',
				        fieldLabel : '开单计提',
				        emptyText : '',
				        anchor : '95%'		    
					});
 
 var execRateField = new Ext.form.TextField({
	                    id:'execRateField',
						name : 'execRate',
				       fieldLabel : '执行计提',
				       allowBlank : false,
				       emptyText : '',
				       anchor : '95%'		    
					});
 
 var DetailCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
    	header: '模板ID',
        dataIndex: 'rvsTemplateMainID',
        width: 100,		  
        sortable: true,
        hidden:true
    },{
    	header: 'RBRVS项目',
        dataIndex: 'BonusSubItemID',
        width:80,
        sortable: true
    },{
	    header: '用时值',
        dataIndex: 'useMinuteValue',
        width: 60,
        sortable: true,
        editor:useMinuteField
        //renderer:Ext.util.Format.comboRenderer(useMinuteField)
        
	},{
    	header: '风险值',
        dataIndex: 'workRiskValue',
        width: 60,		  
        sortable: true,
        editor:workRiskField
    },{
    	header: '难度值',
        dataIndex: 'techDifficultyValue',
        width: 60,
        sortable: true,
        editor:techDifficultyField
    },{
	    header: '工作消耗值',
        dataIndex: 'workCostValue',
        width: 60,
        sortable: true,
        editor:workCostField
	},{
    	header: '开单计提',
        dataIndex: 'makeRate',
        width: 60,		  
        sortable: true,
        editor:makeRateField,
        regex:/^(-?\d+)(\.\d+)?$/,
        align : 'right'

    },{
    	header: '执行计提',
        dataIndex: 'execRate',
        width: 60,
        sortable: true,
        editor:execRateField,
        regex:/^(-?\d+)(\.\d+)?$/,
        align : 'right'

    },{
    	header: '开单分值',
        dataIndex: 'makeItemScore',
        width: 90,		  
        sortable: true,
        align : 'right'
    },{
    	header: '执行分值',
        dataIndex: 'execItemScore',
        width: 90,
        sortable: true,
        align : 'right'
    }
    
]);


//分页工具栏
var DetailPagingToolbar = new Ext.PagingToolbar({
    store: DetailDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg: "没有记录"
	
});

var addButton = new Ext.Toolbar.Button({
	text: '添加',
	tooltip: '添加',
	iconCls: 'add',
	handler: function(){
		var rowObj = templateMain.getSelectionModel().getSelections();
				/*
				if (rowObj.length == 0) {
					new Ext.grid.RowSelectionModel({singleSelect:true}).selectFirstRow();
					rowObj = templateMain.getSelectionModel().getSelections();
					
				}*/
	        if (rowObj.length == 0) {
		    Ext.MessageBox.alert('提示', '您没有选择柱模板，请选择柱模板');
		    return false;
	        }
				
		detailAddFun();
		
	}
});

var editButton = new Ext.Toolbar.Button({
	text: '修改',
	tooltip: '修改',
	iconCls: 'option',
	handler: function(){
		/*
		var rowObj = detailMain.getSelectionModel().getSelections();
		var len = rowObj.length;
		var tmpRowid = "";
		*/	
		var rowObj = templateMain.getSelectionModel().getSelections();
		if (rowObj.length == 0) {
		    Ext.MessageBox.alert('提示', '您没有选择柱模板，请选择柱模板');
		    return false;
	        }
		
		 var minuteRate =rowObj[0].get("useMinuteRate");
		 var riskRate=rowObj[0].get("workRiskRate");
		 var difficultyRate=rowObj[0].get("techDifficultyRate");
		 var costRate=rowObj[0].get("workCostRate");

		
		//detailEditFun();
	
		var mr=DetailDs.getModifiedRecords();
		if (mr=="") {
		    Ext.MessageBox.alert('提示', '修改记录为空');
		    return false;
	        }

		var data = ""
		//var rowDelim=xRowDelim();
		
		for(i=0;i<mr.length;i++){
			var rvsTemplateMainID = mr[i].data["rvsTemplateMainID"];
			var BonusSubItemID = mr[i].data["BonusSubItemID"];
			var useMinuteValue = mr[i].data["useMinuteValue"];
			var workRiskValue = mr[i].data["workRiskValue"];
			var techDifficultyValue = mr[i].data["techDifficultyValue"];
			var workCostValue = mr[i].data["workCostValue"];
			var makeRate = mr[i].data["makeRate"];
			var execRate = mr[i].data["execRate"];
			
			if((useMinuteValue!="")&&(workRiskValue!="")&&(techDifficultyValue!="")&&(workCostValue!="")&&(makeRate!="")&&(execRate!=""))
			{
				var tmpData = mr[i].data["rowid"]+"^"+rvsTemplateMainID+"^"+BonusSubItemID+"^"+useMinuteValue+"^"+workRiskValue+"^"+techDifficultyValue+"^"+workCostValue+"^"+makeRate+"^"+execRate+"^"+minuteRate+"^"+riskRate+"^"+difficultyRate+"^"+costRate;
				if(data==""){
					data = tmpData;
				}else{
					data = data + tmpData;
					
				}
			}
		}
		//alert(tmpData)
		if(useMinuteValue==""){
			Msg.info("error", "用时值不能为空!");
			return false;}
		if(workRiskValue==""){
			Msg.info("error", "风险值不能为空!");
			return false;}
		if(techDifficultyValue==""){
			Msg.info("error", "难度值不能为空!");
			return false;}
		
		if(workCostValue==""){
			Msg.info("error", "消耗值不能为空!");
			return false;}
		if(makeRate==""){
			Msg.info("error", "开单计提不能为空!");
			return false;}
		if(execRate==""){
			Msg.info("error", "执行计提不能为空!");
			return false;}else{		
		       Ext.Ajax.request({
			    
						url : DetailUrl + '?action=detailedit&data=' + tmpData,
								
						waitMsg : '保存中...',
						
						failure : function(result, request) {
							Ext.Msg.show({
										title : '错误',
										msg : '请检查网络连接!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						},						
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
											title : '注意',
											msg : '操作成功!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO
										});
								DetailDs.load({
											params : {
												start : 0,
												limit : DetailPagingToolbar.pageSize
											}
										});
								
							} else {
								var tmpmsg = '';
								if (jsonData.info == '1') {
									tmpmsg = '编码重复!';
								}
								Ext.Msg.show({
											title : '错误',
											msg : tmpmsg,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							}
						},
						scope : this
					});
	
			}
			
		
	}
});


//批量增加
var batchAddButton = new Ext.Toolbar.Button({
	text: '批量添加',
	tooltip: '批量添加',
	iconCls: 'add',
	handler: function(){
		templateBatchAddFun();
		
	}
});

var detailDelButton = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'remove',
	handler: function(){
		var rowObj = detailMain.getSelectionModel().getSelections();
		var len = rowObj.length;
		var tmpRowid = "";
		
		if(len < 1)
		{
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			tmpRowid = rowObj[0].get("rowid");
			
			Ext.MessageBox.confirm(
				'提示', 
				'确定要删除选定的行?', 
				function(btn){
					if(btn == 'yes'){
						Ext.Ajax.request({
							url: DetailUrl + '?action=detaildel&rowid='+tmpRowid,
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									DetailDs.load({params:{start:0, limit:DetailPagingToolbar.pageSize}});
								}else{
									Ext.Msg.show({title:'错误',msg:'错误',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});   	
					}
				} 
			)	
		}
	}
});


//可编辑的面板要用EditorGridPanel，不能用GridPanel
var detailMain = new Ext.grid.EditorGridPanel
({
	title:'工作模板明细',
	//region:'north',
	region:'center',
	//height:250,
	store: DetailDs,
	cm: DetailCm,
	trackMouseOver: true,
	stripeRows: true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
	//sm:sm,
	loadMask: true,
	clicksToEdit : 1,
	viewConfig: {forceFit:true},
	tbar:[addButton,'-',editButton,'-',detailDelButton,'-',batchAddButton],
	bbar:DetailPagingToolbar
	
});


	