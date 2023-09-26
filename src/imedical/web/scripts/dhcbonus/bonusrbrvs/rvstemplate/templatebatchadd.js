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
				fieldLabel : 'RBRVS��Ŀ',
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
	fieldLabel : '��ģ�����',
	width : 120,
	selectOnFocus : true,
	store : templateMainIDSt,
	anchor : '95%',			
	displayField : 'templateCode',                                //��������ʾ��ֵ�����ڱ��ж�����ֶ�
	valueField : 'rowid',
	triggerAction : 'all',
	emptyText : '',
	//mode : 'local', // ����ģʽ
	selectOnFocus : true,
	forceSelection : true
});
	

  var templateMainIDCombo = new Ext.form.MultiSelect({
	//renderTo: Ext.getBody(),
	id: 'templateMainIDCombo',
	fieldLabel : '��ģ�����',
	width : 120,
	selectOnFocus : true,
	store : templateMainIDSt,
	anchor : '95%',			
	displayField : 'templateCode',                                //��������ʾ��ֵ�����ڱ��ж�����ֶ�
	valueField : 'rowid',
	triggerAction : 'all',
	emptyText : '',
	//mode : 'local', // ����ģʽ
	selectOnFocus : true,
	forceSelection : true
});
*/
	
	
	
	
	
    var useMinuteFieldStore = new Ext.data.SimpleStore({
            fields : ['key', 'keyValue'],
            data : [['1','0-20����'],['2','20-40����'],['3','40-60����'],['4','60-90����'],['5','90��������']]
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
            data : [['1','����'],['2','�ϸ�'],['3','һ��'],['4','�ϵ�'],['5','����'],['6','��']]
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
            data : [['1','����'],['2','����'],['3','һ��'],['4','����'],['5','����'],['6','��']]
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
            data : [['1','���'],['2','�ϸ�'],['3','һ��'],['4','�ϵ�'],['5','���'],['6','��']]
      });
    
      var workCostField = new Ext.form.ComboBox({
	       id : 'workCostField',
	       fieldLabel : '��������ֵ',
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
				anchor : '95%'
		});
		
		
	var execRateField = new Ext.form.TextField({
				id : 'execRateField',
				name : 'execRate',
				fieldLabel : 'ִ�м���',
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
		title : '���',
		width : 240,
		height : 265,
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
									tmpmsg = '�����ظ�!';
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