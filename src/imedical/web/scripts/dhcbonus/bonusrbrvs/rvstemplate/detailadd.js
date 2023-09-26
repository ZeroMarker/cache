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
				fieldLabel : 'RBRVS��Ŀ',
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
	fieldLabel : 'RBRVS��Ŀ',
	width : 120,
	selectOnFocus : true,
	store : subsItemNameSt,
	anchor : '95%',			
	displayField : 'SubItemName',                                
	valueField : 'BonusSubItemID',
	triggerAction : 'all',
	emptyText : '',
	//mode : 'local', // ����ģʽ
	selectOnFocus : true,
	forceSelection : true,
	minChars: 1,
	pageSize: 25
});
	
	
    var useMinuteFieldStore = new Ext.data.SimpleStore({
            fields : ['key', 'keyValue'],
            data : [['5','0-20����'],['4','20-40����'],['3','40-60����'],['2','60-90����'],['1','90��������']]
      });
    
    var useMinuteField = new Ext.form.ComboBox({
	       id : 'useMinuteField',
	       fieldLabel : '��ʱֵ',
	       width : 130,
	       selectOnFocus : true,
	      //allowBlank : false,
	      store : useMinuteFieldStore,
    	  anchor : '95%',			
	      displayField : 'keyValue',  //��������ʾ��ֵ
	      valueField : 'key',
	      triggerAction : 'all',
	      emptyText : '',
	      mode : 'local', // ����ģʽ
	      //editable : false,
	      selectOnFocus : true,
	      forceSelection : true
      });  
      
      
       var workRiskFieldStore = new Ext.data.SimpleStore({
            fields : ['key', 'keyValue'],
            data : [['6','����'],['5','�ϸ�'],['4','һ��'],['3','�ϵ�'],['2','����'],['1','��']]
      });
    
      var workRiskField = new Ext.form.ComboBox({
	       id : 'workRiskField',
	       fieldLabel : '����ֵ',
	       width : 130,
	       selectOnFocus : true,
	      //allowBlank : false,
	      store : workRiskFieldStore,
    	  anchor : '95%',			
	      displayField : 'keyValue',  //��������ʾ��ֵ
	      valueField : 'key',
	      triggerAction : 'all',
	      emptyText : '',
	      mode : 'local', // ����ģʽ
	      //editable : false,
	      selectOnFocus : true,
	      forceSelection : true
      });  
      
      
       var techDifficultyFieldStore = new Ext.data.SimpleStore({
            fields : ['key', 'keyValue'],
            data : [['6','����'],['5','����'],['4','һ��'],['3','����'],['2','����'],['1','��']]
      });
    
      var techDifficultyField = new Ext.form.ComboBox({
	       id : 'techDifficultyField',
	       fieldLabel : '�Ѷ�ֵ',
	       width : 130,
	       selectOnFocus : true,
	      //allowBlank : false,
	      store : techDifficultyFieldStore,
    	  anchor : '95%',			
	      displayField : 'keyValue',  //��������ʾ��ֵ
	      valueField : 'key',
	      triggerAction : 'all',
	      emptyText : '',
	      mode : 'local', // ����ģʽ
	      //editable : false,
	      selectOnFocus : true,
	      forceSelection : true
      });  
      
       var workCostFieldStore = new Ext.data.SimpleStore({
            fields : ['key', 'keyValue'],
            data : [['6','���'],['5','�ϸ�'],['4','һ��'],['3','�ϵ�'],['2','���'],['1','��']]
      });
    
      var workCostField = new Ext.form.ComboBox({
	       id : 'workCostField',
	       fieldLabel : '����ֵ',
	       width : 120,
	       selectOnFocus : true,
	      //allowBlank : false,
	      store : workCostFieldStore,
    	  anchor : '95%',			
	      displayField : 'keyValue',  //��������ʾ��ֵ
	      valueField : 'key',
	      triggerAction : 'all',
	      emptyText : '',
	      mode : 'local', // ����ģʽ
	      //editable : false,
	      selectOnFocus : true,
	      forceSelection : true
      });  
      
      
	
	
	
	var makeRateField = new Ext.form.TextField({
				id : 'makeRateField',
				name : 'makeRate',
				fieldLabel : '��������',
				allowBlank : false,
				emptyText : '',
				anchor : '95%',
				regex:/^(-?\d+)(\.\d+)?$/
		});
		
		
	var execRateField = new Ext.form.TextField({
				id : 'execRateField',
				name : 'execRate',
				fieldLabel : 'ִ�м���',
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
		title : '���',
		width : 360,
		height : 310,
		layout : 'fit',
		plain : true,
		modal : true,
		bodyStyle : 'padding:5px;',
		buttonAlign : 'center',
		items : formPanel,
		buttons : [{
			text : '����',
			handler : function() {
				if (formPanel.form.isValid()) {
					//getRawValue���ݵ���valueField��ֵ��getValue���ݵ���displayField��ֵ
					

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
						waitMsg : '������...',
						failure : function(result, request) {
							Ext.Msg.show({
										title : '����',
										msg : '������������!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						},
						success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
											title : 'ע��',
											msg : '�����ɹ�!',
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
									tmpmsg = 'RBRVS��Ŀ�Ѿ�����';
								}
								Ext.Msg.show({
											title : '����',
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
								title : '����',
								msg : tmpWrongName + '����Ϊ��!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				}
			}
		}, {
			text : 'ȡ��',
			handler : function() {
			  detailAddWin.close();
			}
		}]

	});
	
		
	detailAddWin.show();	
		
	
};