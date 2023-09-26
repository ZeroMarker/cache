templateBatchAddFun = function(){
	
	var checkAdd=function(formPanel){
	var tmpWrongName=''
	for(i=0;i<formPanel.items.length;i++) {
		//alert(i);
		if(!formPanel.items.items[i].isValid()){
			if(tmpWrongName==''){
				tmpWrongName=formPanel.items.items[i].fieldLabel;
			}else{
				//tmpWrongName=tmpWrongName+','+formPanel.items.items[i].fieldLabel;
			}
		}
	}
	return tmpWrongName
}
//------------------------------------------------------------------------------------------------------
  

//--------------------------------------------------------------------------------------------------------	
	
	/*
	var BSDIDField = new Ext.form.TextField({
				id : 'BSDIDField',
				name : 'BonusSubItemID',
				fieldLabel : 'RBRVS项目',
				allowBlank : false,
				emptyText : '',
				anchor : '95%'
			});
		*/
	
	
var templateMainIDSt = new Ext.data.Store({
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','templateCode'])
	});

 templateMainIDSt.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'../csp/dhc.bonus.rvstemplateexe.csp?action=templateCode&start=0&limit=10'+encodeURIComponent(Ext.getCmp('templateMainIDCombo').getRawValue()),
		     method:'POST'
		});
});
/*
var templateMainIDCombo = new Ext.form.ComboBox({
	id: 'templateMainIDCombo',
	fieldLabel : '主模板编码',
	width : 120,
	selectOnFocus : true,
	store : templateMainIDSt,
	anchor : '95%',			
	displayField : 'templateCode',                                //下拉框显示的值，即在表中定义的字段
	valueField : 'rowid',
	triggerAction : 'all',
	emptyText : '',
	//mode : 'local', // 本地模式
	selectOnFocus : true,
	forceSelection : true
});
	

  var templateMainIDCombo = new Ext.form.MultiSelect({
	//renderTo: Ext.getBody(),
	id: 'templateMainIDCombo',
	fieldLabel : '主模板编码',
	width : 120,
	selectOnFocus : true,
	store : templateMainIDSt,
	anchor : '95%',			
	displayField : 'templateCode',                                //下拉框显示的值，即在表中定义的字段
	valueField : 'rowid',
	triggerAction : 'all',
	emptyText : '',
	//mode : 'local', // 本地模式
	selectOnFocus : true,
	forceSelection : true
});
*/
	
	
	
	
	
    var useMinuteFieldStore = new Ext.data.SimpleStore({
            fields : ['key', 'keyValue'],
            data : [['1','0-20分钟'],['2','20-40分钟'],['3','40-60分钟'],['4','60-90分钟'],['5','90分钟以上']]
      });
    
    var useMinuteField = new Ext.form.ComboBox({
	       id : 'useMinuteField',
	       fieldLabel : '用时值',
	       width : 130,
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
            data : [['1','极高'],['2','较高'],['3','一般'],['4','较低'],['5','极地'],['6','无']]
      });
    
      var workRiskField = new Ext.form.ComboBox({
	       id : 'workRiskField',
	       fieldLabel : '风险值',
	       width : 130,
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
            data : [['1','高难'],['2','较难'],['3','一般'],['4','低难'],['5','较易'],['6','无']]
      });
    
      var techDifficultyField = new Ext.form.ComboBox({
	       id : 'techDifficultyField',
	       fieldLabel : '难度值',
	       width : 130,
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
            data : [['1','最高'],['2','较高'],['3','一般'],['4','较低'],['5','最低'],['6','无']]
      });
    
      var workCostField = new Ext.form.ComboBox({
	       id : 'workCostField',
	       fieldLabel : '工作消耗值',
	       width : 120,
	       selectOnFocus : true,
	      //allowBlank : false,
	      store : workCostFieldStore,
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
      
      
	
	
	
	var makeRateField = new Ext.form.TextField({
				id : 'makeRateField',
				name : 'makeRate',
				fieldLabel : '开单计提',
				allowBlank : false,
				emptyText : '',
				anchor : '95%'
		});
		
		
	var execRateField = new Ext.form.TextField({
				id : 'execRateField',
				name : 'execRate',
				fieldLabel : '执行计提',
				allowBlank : false,
				emptyText : '',
				anchor : '95%'
		});
		
	//BSDIDField.setValue('');
	
	useMinuteField.setValue('');
	workRiskField.setValue('');
	techDifficultyField.setValue('');
	workCostField.setValue('');
	makeRateField.setValue('');
	execRateField.setValue('');
	
	var formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				labelWidth : 70,
				items : [
				 //BSDIDField,
				 
				 useMinuteField,
				 workRiskField,
				 techDifficultyField,
				 workCostField, 
				 makeRateField, 
				 execRateField
				 
				 
				]
			});
	
	
	var detailAddWin = new Ext.Window({
		title : '添加',
		width : 240,
		height : 265,
		layout : 'fit',
		plain : true,
		modal : true,
		bodyStyle : 'padding:5px;',
		buttonAlign : 'center',
		items : formPanel,
		buttons : [{
			text : '保存',
			handler : function() {
				if (formPanel.form.isValid()) {
					

					tmpData = 
							 "^dhc.bonus.subs.BonusSubItem.BonusSubItemID^"
							+ useMinuteField.getRawValue()
							+ "^"
							+ workRiskField.getRawValue()
							+ "^"
							+ techDifficultyField.getRawValue()
							+ "^"
							+ workCostField.getRawValue()
							+ "^"
							+ makeRateField.getValue()
							+ "^"
							+ execRateField.getValue();
				
					Ext.Ajax.request({
						url : DetailUrl + '?action=batchadd&data=' + tmpData,
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
							var jsonData = Ext.util.JSON.decode(result.responseText);
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

				} else {
					var tmpWrongName = checkAdd(formPanel);
					Ext.Msg.show({
								title : '错误',
								msg : tmpWrongName + '不能为空!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				}
			}
		}, {
			text : '取消',
			handler : function() {
			  detailAddWin.close();
			}
		}]

	});
	
		
	detailAddWin.show();	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
};