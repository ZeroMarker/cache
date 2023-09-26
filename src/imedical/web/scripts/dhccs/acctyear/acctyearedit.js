editFun = function(dataStore,grid) {
	
	Ext.QuickTips.init();

	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var rowid = "";
	
	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		rowid = rowObj[0].get("rowid");
	}

	var compCodeField = new Ext.form.TextField({
		id:'compCodeField',
		fieldLabel: '单位编码',
		allowBlank: false,
		name:'compCode',
		anchor: '95%'
	});

	var copyCodeField = new Ext.form.TextField({
		id:'copyCodeField',
		fieldLabel: '账套编码',
		allowBlank: false,
		name:'copyCode',
		anchor: '95%'
	});
	
	var acctYearField = new Ext.form.TextField({
		id:'acctYearField',
		fieldLabel: '会计年度',
		allowBlank: false,
		name:'acctYear',
		anchor: '95%'
	});
	
	var beginDateField = new Ext.form.DateField({
		id:'beginDateField',
		fieldLabel: '开始日期',
		allowBlank: false,
		format: 'Y年m月d日',
		name:'beginDate',
		anchor: '95%'
	});
		
	var endDateField = new Ext.form.DateField({
		id:'endDateField',
		fieldLabel: '结束日期',
		allowBlank: false,
		format: 'Y年m月d日',
		name:'endDate',
		anchor: '95%'
	});

	var periodNumField = new Ext.form.TextField({
		id:'periodNumField',
		fieldLabel: '期间数目',
		allowBlank: false,
		name:'periodNum',
		anchor: '95%'
	});
	
	var accFlagField = new Ext.form.Checkbox({
		id:'accFlagField',
		fieldLabel: '账务结账',
		allowBlank: false,
		name:'accFlag',
		anchor: '95%'
	});
	
	var budgFlagField = new Ext.form.Checkbox({
		id:'budgFlagField',
		fieldLabel: '预算结账',
		allowBlank: false,
		name:'budgFlag',
		anchor: '95%'
	});
	
	var perfFlagField = new Ext.form.Checkbox({
		id:'perfFlagField',
		fieldLabel: '绩效结账',
		allowBlank: false,
		name:'perfFlag',
		anchor: '95%'
	});
		
	var costFlagField = new Ext.form.Checkbox({
		id:'costFlagField',
		fieldLabel: '成本结账',
		allowBlank: false,
		name:'costFlag',
		anchor: '95%'
	});

	var cashDateField = new Ext.form.DateField({
		id:'cashDateField',
		fieldLabel: '现金银行结账日期',
		allowBlank: true,
		format: 'Y年m月d日',
		name:'cashDate',
		anchor: '95%'
	});

	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 60,
		items: [
			compCodeField,
            copyCodeField,
            acctYearField,
            beginDateField,
            endDateField,
            periodNumField,
			accFlagField,
			budgFlagField,
			perfFlagField,
			costFlagField,
			cashDateField
		]
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			accFlagField.setValue((rowObj[0].data['accFlag'])=='1'?true:false);
			budgFlagField.setValue((rowObj[0].data['budgFlag'])=='1'?true:false);
			perfFlagField.setValue((rowObj[0].data['perfFlag'])=='1'?true:false);
			costFlagField.setValue((rowObj[0].data['costFlag'])=='Y'?true:false);
		});
    
	var window = new Ext.Window({
		title: '修改',
		width: 300,
		height:400,
		minWidth: 300,
		minHeight: 400,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '保存', 
			handler: function() {
				
				var	compCode = compCodeField.getValue();
				var	copyCode = copyCodeField.getValue();
				var	acctYear = acctYearField.getValue();
				var	beginDate = beginDateField.getValue().format('Y-m-d');
				var	endDate = endDateField.getValue().format('Y-m-d');
				var	periodNum = periodNumField.getValue();
				var	accFlag = (accFlagField.getValue()==true)?'1':'0';
				var	budgFlag = (budgFlagField.getValue()==true)?'1':'0';
				var	perfFlag = (perfFlagField.getValue()==true)?'1':'0';
				var	costFlag = (costFlagField.getValue()==true)?'Y':'N';
				var	cashDate = '';
				if(cashDateField.getValue()!= ""){
					cashDate = cashDateField.getValue().format('Y-m-d');
				}
				
				compCode = compCode.trim();
				copyCode = copyCode.trim();
				acctYear = acctYear.trim();
				periodNum =	periodNum.trim();
				accFlag = accFlag.trim();
				budgFlag = budgFlag.trim();
				perfFlag = perfFlag.trim();
				
				if (formPanel.form.isValid()) {
					Ext.Ajax.request({
						url: 'dhc.cs.baseexe.csp?action=editacctyear&rowid='+rowid+'&compCode='+compCode+'&copyCode='+copyCode+'&acctYear='+acctYear+'&beginDate='+beginDate+'&endDate='+endDate+'&periodNum='+periodNum+'&accFlag='+accFlag+'&budgFlag='+budgFlag+'&perfFlag='+perfFlag+'&costFlag='+costFlag+'&cashDate='+cashDate,
						waitMsg:'保存中...',
						failure: function(result, request) {
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								dataStore.load();
								window.close();
							}
							else
							{
								var message="SQLErr: "+jsonData.info;
								Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
					scope: this
					});
				}
				else{
						Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}             
				}
			},
			{
					text: '取消',
			handler: function(){window.close();}
		}]
	});
    window.show();
};