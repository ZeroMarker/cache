detailAddFun = function() {
	
	var rowObj = templateMain.getSelectionModel().getSelections();
	var minuteRate =rowObj[0].get("useMinuteRate");
    var riskRate=rowObj[0].get("workRiskRate");
	var difficultyRate=rowObj[0].get("techDifficultyRate");
	var costRate=rowObj[0].get("workCostRate");

	
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
	var subsItemNameSt = new Ext.data.Store({
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['BonusSubItemID','SubItemName'])
	});

subsItemNameSt.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'../csp/dhc.bonus.rvstemplateexe.csp?action=GetSubsItemName&start=0&limit=25'+encodeURIComponent(Ext.getCmp('subsItemNameCombo').getRawValue()),
		     method:'POST'
		});
});

var subsItemNameCombo = new Ext.form.ComboBox({
	id: 'subsItemNameCombo',
	name:'subsItemNameCombo',
	fieldLabel : 'RBRVS项目',
	width : 120,
	selectOnFocus : true,
	store : subsItemNameSt,
	anchor : '95%',			
	displayField : 'SubItemName',                                
	valueField : 'BonusSubItemID',
	triggerAction : 'all',
	emptyText : '',
	//mode : 'local', // 本地模式
	selectOnFocus : true,
	forceSelection : true,
	minChars: 1,
	pageSize: 25
});
	
	
    var useMinuteFieldStore = new Ext.data.SimpleStore({
            fields : ['key', 'keyValue'],
            data : [['5','0-20分钟'],['4','20-40分钟'],['3','40-60分钟'],['2','60-90分钟'],['1','90分钟以上']]
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
            data : [['6','极高'],['5','较高'],['4','一般'],['3','较低'],['2','极低'],['1','无']]
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
            data : [['6','高难'],['5','较难'],['4','一般'],['3','低难'],['2','较易'],['1','无']]
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
            data : [['6','最高'],['5','较高'],['4','一般'],['3','较低'],['2','最低'],['1','无']]
      });
    
      var workCostField = new Ext.form.ComboBox({
	       id : 'workCostField',
	       fieldLabel : '消耗值',
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
				anchor : '95%',
				regex:/^(-?\d+)(\.\d+)?$/
		});
		
		
	var execRateField = new Ext.form.TextField({
				id : 'execRateField',
				name : 'execRate',
				fieldLabel : '执行计提',
				allowBlank : false,
				emptyText : '',
				anchor : '95%',
				regex:/^(-?\d+)(\.\d+)?$/
		});
		
	//BSDIDField.setValue('');
	subsItemNameCombo.setValue('');
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
				 subsItemNameCombo,
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
		width : 360,
		height : 310,
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
					//getRawValue传递的是valueField的值，getValue传递的是displayField的值
					

					tmpData = tmpSelectedTemplate
							+ "^"
							+subsItemNameCombo.getValue()
							+"^"
							+ useMinuteField.getValue()
							+ "^"
							+ workRiskField.getValue()
							+ "^"
							+ techDifficultyField.getValue()
							+ "^"
							+ workCostField.getValue()
							+ "^"
							+ makeRateField.getValue()
							+ "^"
							+ execRateField.getValue()
							+"^"
							+minuteRate
							+"^"
							+riskRate
							+"^"
							+difficultyRate
							+"^"
							+costRate;
					
					//alert(tmpData)
		
					Ext.Ajax.request({
						url : DetailUrl + '?action=detailadd&data=' + tmpData,
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
									tmpmsg = 'RBRVS项目已经存在';
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