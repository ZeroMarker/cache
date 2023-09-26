editFun = function(dataStore,grid) {
	
	Ext.QuickTips.init();

	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var rowid = "";
	
	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		rowid = rowObj[0].get("rowid");
	}

	//var acctYearDrField = new Ext.form.TextField({
	//	id:'acctYearDrField',
	//	fieldLabel: '������',
	//	name:'acctYearDr',
	//	allowBlank: true,
	//	anchor: '95%'
	//});

	var acctYearST = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'}, ['acctYear','rowid'])
	});
	
	acctYearST.on(
			'beforeload',
			function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listacctyear', method:'GET'});
			}
		);	
		
	var acctYearCB = new Ext.form.ComboBox({
			//id:'acctYearCB',
			store: acctYearST,
			valueField:'rowid',
			displayField:'acctYear',
			fieldLabel: '������',
			typeAhead:true,
			//pageSize:10,
			minChars:1,
			valueNotFoundText:rowObj[0].get("acctYearName"),
			width:150,
			listWidth:150,
			triggerAction:'all',
			emptyText:'ѡ�������...',
			allowBlank: true,
			name:'acctYearCB',
			selectOnFocus: true,
			//mode:'local',
			forceSelection: true
		});			
	
	//var acctSubjTypeDrField = new Ext.form.TextField({
	//	id:'acctSubjTypeDrField',
	//	fieldLabel: '��Ŀ���',
	//	name:'acctSubjTypeDr',
	//	allowBlank: true,
	//	anchor: '95%'
	//});
	
	var acctSubjTypeST = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'}, ['subjTypeName','rowid'])
	});
	
	acctSubjTypeST.on(
			'beforeload',
			function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listacctsubjtype', method:'GET'});
			}
		);	
		
	var acctSubjTypeCB = new Ext.form.ComboBox({
			//id:'acctSubjTypeCB',
			store: acctSubjTypeST,
			valueField:'rowid',
			displayField:'subjTypeName',
			fieldLabel: '��Ŀ���',
			typeAhead:true,
			//pageSize:10,
			minChars:1,
			valueNotFoundText:rowObj[0].get("acctSubjTypeName"),
			width:150,
			listWidth:150,
			triggerAction:'all',
			emptyText:'ѡ���Ŀ���...',
			allowBlank: true,
			name:'acctSubjTypeCB',
			selectOnFocus: true,
			//mode:'local',
			forceSelection: true
		});		

	var acctSubjCodeField = new Ext.form.TextField({
		id:'acctSubjCodeField',
		fieldLabel: '��Ŀ����',
		name:'acctSubjCode',
		allowBlank: false,
		anchor: '95%'
	});
	
	var aCCTSubjNameField = new Ext.form.TextField({
		id:'aCCTSubjNameField',
		fieldLabel: '��ƿ�Ŀ',
		name:'aCCTSubjName',
		allowBlank: false,
		anchor: '95%'
	});
		
	var aCCTSubjNameAllField = new Ext.form.TextField({
		id:'aCCTSubjNameAllField',
		fieldLabel: '��Ŀȫ��',
		name:'aCCTSubjNameAll',
		allowBlank: false,
		anchor: '95%'
	});
	
	//var superSubjField = new Ext.form.TextField({
	//	id:'superSubjField',
	//	fieldLabel: '�ϼ�����',
	//	name:'superSubj',
	//	allowBlank: true,
	//	anchor: '95%'
	//});
	
	var superSubjST = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'}, ['aCCTSubjName','rowid'])
	});
	
	superSubjST.on(
			'beforeload',
			function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listacctsubj', method:'GET'});
			}
		);	
		
	var superSubjCB = new Ext.form.ComboBox({
			//id:'superSubjCB',
			store: superSubjST,
			valueField:'rowid',
			displayField:'aCCTSubjName',
			fieldLabel: '�ϼ�����',
			typeAhead:true,
			//pageSize:10,
			minChars:1,
			valueNotFoundText:rowObj[0].get("superSubjName"),
			width:150,
			listWidth:150,
			triggerAction:'all',
			emptyText:'ѡ���ϼ�����...',
			allowBlank: true,
			name:'superSubjCB',
			selectOnFocus: true,
			//mode:'local',
			forceSelection: true
		});		
	
	var subjLevelField = new Ext.form.TextField({
		id:'subjLevelField',
		fieldLabel: '��Ŀ����',
		name:'subjLevel',
		allowBlank: false,
		anchor: '95%'
	});

	var isLastField = new Ext.form.Checkbox({
		id:'isLastField',
		fieldLabel: '�Ƿ�ĩ��',
		name:'isLast',
		allowBlank: false,
		anchor: '95%'
	});

	var directionField = new Ext.form.Checkbox({
		id:'directionField',
		fieldLabel: '����',
		name:'direction',
		allowBlank: false,
		anchor: '95%'
	});
	
	var isCashField = new Ext.form.Checkbox({
		id:'isCashField',
		fieldLabel: '�ֽ��־',
		name:'isCash',
		allowBlank: false,
		anchor: '95%'
	});
	
	var isNumField = new Ext.form.Checkbox({
		id:'isNumField',
		fieldLabel: '��������',
		name:'isNum',
		allowBlank: false,
		anchor: '95%'
	});
	
	var isFcField = new Ext.form.Checkbox({
		id:'isFcField',
		fieldLabel: '�������',
		name:'isFc',
		allowBlank: false,
		anchor: '95%'
	});
	
	var isCheckField = new Ext.form.Checkbox({
		id:'isCheckField',
		fieldLabel: '�����־',
		name:'isCheck',
		allowBlank: false,
		anchor: '95%'
	});	
	
	var checkType1Field = new Ext.form.TextField({
		id:'checkType1Field',
		fieldLabel: '����������1',
		name:'checkType1',
		allowBlank: true,
		anchor: '95%'
	});
	
	var checkType2Field = new Ext.form.TextField({
		id:'checkType2Field',
		fieldLabel: '����������2',
		name:'checkType2',
		allowBlank: true,
		anchor: '95%'
	});
	
	var checkType3Field = new Ext.form.TextField({
		id:'checkType3Field',
		fieldLabel: '����������3',
		name:'checkType3',
		allowBlank: true,
		anchor: '95%'
	});
	
	var checkType4Field = new Ext.form.TextField({
		id:'checkType4Field',
		fieldLabel: '����������4',
		name:'checkType4',
		allowBlank: true,
		anchor: '95%'
	});
	
	var checkType5Field = new Ext.form.TextField({
		id:'checkType5Field',
		fieldLabel: '����������5',
		name:'checkType5',
		allowBlank: true,
		anchor: '95%'
	});
	
	var checkType6Field = new Ext.form.TextField({
		id:'checkType6Field',
		fieldLabel: '����������6',
		name:'checkType6',
		allowBlank: true,
		anchor: '95%'
	});
	
	var checkType7Field = new Ext.form.TextField({
		id:'checkType7Field',
		fieldLabel: '����������7',
		name:'checkType7',
		allowBlank: true,
		anchor: '95%'
	});
	
	var checkType8Field = new Ext.form.TextField({
		id:'checkType8Field',
		fieldLabel: '����������8',
		name:'checkType8',
		allowBlank: true,
		anchor: '95%'
	});
	
	var defineField = new Ext.form.TextField({
		id:'defineField',
		fieldLabel: '�Զ�����',
		name:'define',
		allowBlank: true,
		anchor: '95%'
	});
	
	var spellField = new Ext.form.TextField({
		id:'spellField',
		fieldLabel: 'ƴ����',
		name:'spell',
		allowBlank: true,
		anchor: '95%'
	});
	
	var isStopField = new Ext.form.Checkbox({
		id:'isStopField',
		fieldLabel: 'ͣ��',
		name:'isStop',
		allowBlank: false,
		anchor: '95%'
	});
	
	var isCbcsField = new Ext.form.Checkbox({
		id:'isCbcsField',
		fieldLabel: '�ɱ����',
		name:'isCbcs',
		allowBlank: false,
		anchor: '95%'
	});	
	
	var isZeroField = new Ext.form.Checkbox({
		id:'isZeroField',
		fieldLabel: '�����',
		name:'isZero',
		allowBlank: false,
		anchor: '95%'
	});	
	
	var subjDefineField = new Ext.form.TextField({
		id:'subjDefineField',
		fieldLabel: '��Ŀ����',
		name:'subjDefine',
		allowBlank: false,
		anchor: '95%'
	});
	
	var isBudgeField = new Ext.form.TextField({
		id:'isBudgeField',
		fieldLabel: 'Ԥ�����',
		name:'isBudge',
		allowBlank: true,
		anchor: '95%'
	});
	
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		autoScroll:true,
		labelWidth: 75,
		items: [
            acctSubjCodeField,
			aCCTSubjNameField,
			aCCTSubjNameAllField,		
    		subjLevelField,
			subjDefineField,
    		//acctYearDrField,
			acctYearCB,
            //acctSubjTypeDrField,
			acctSubjTypeCB,
			//superSubjField,	
			superSubjCB,
            isLastField,
            directionField,
			isCashField,
			isNumField,
			isFcField,
    		isCheckField,
            checkType1Field,
            checkType2Field,
			checkType3Field,
			checkType4Field,
			checkType5Field,
			checkType6Field,
			checkType7Field,
			checkType8Field,
			defineField,
            spellField,
			isStopField,
			isCbcsField,
			isZeroField,
			isBudgeField
		]
	});

	formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			acctYearCB.setValue(rowObj[0].get("acctYearDr"));
			acctSubjTypeCB.setValue(rowObj[0].get("acctSubjTypeDr"));
			superSubjCB.setValue(rowObj[0].get("superSubj"));
			isLastField.setValue((rowObj[0].data['isLast'])=='1'?true:false);
			directionField.setValue((rowObj[0].data['direction'])=='1'?true:false);
			isCashField.setValue((rowObj[0].data['isCash'])=='1'?true:false);
			isNumField.setValue((rowObj[0].data['isNum'])=='1'?true:false);
			isFcField.setValue((rowObj[0].data['isFc'])=='1'?true:false);
			isCheckField.setValue((rowObj[0].data['isCheck'])=='1'?true:false);
			isStopField.setValue((rowObj[0].data['isStop'])=='1'?true:false);
			isCbcsField.setValue((rowObj[0].data['isCbcs'])=='1'?true:false);
			isZeroField.setValue((rowObj[0].data['isZero'])=='1'?true:false);
		});
    
	var window = new Ext.Window({
		title: '�޸�',
		width: 350,
		height:600,
		minWidth: 350,
		minHeight: 600,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '����', 
			handler: function() {
				
				//var acctYearDr     = acctYearDrField.getValue();
				//var acctSubjTypeDr = acctSubjTypeDrField.getValue();
				var acctSubjCode   = acctSubjCodeField.getValue();
				var aCCTSubjName   = aCCTSubjNameField.getValue();
				var aCCTSubjNameAll= aCCTSubjNameAllField.getValue();
				//var superSubj	   = superSubjField.getValue();		
				var subjLevel      = subjLevelField.getValue();
				var isLast         = (isLastField.getValue()==true)?'1':'0';
				var direction      = (directionField.getValue()==true)?'1':'0';
				var isCash         = (isCashField.getValue()==true)?'1':'0';
			    var isNum          = (isNumField.getValue()==true)?'1':'0';
			    var isFc           = (isFcField.getValue()==true)?'1':'0';
			    var isCheck        = (isCheckField.getValue()==true)?'1':'0';
			    var checkType1     = checkType1Field.getValue();
			    var checkType2     = checkType2Field.getValue();
			    var checkType3     = checkType3Field.getValue();
			    var checkType4     = checkType4Field.getValue();
			    var checkType5     = checkType5Field.getValue();
			    var checkType6     = checkType6Field.getValue();
			    var checkType7     = checkType7Field.getValue();
			    var checkType8     = checkType8Field.getValue();
			    var define         = defineField.getValue();
			    var spell          = spellField.getValue();
			    var isStop         = (isStopField.getValue()==true)?'1':'0';
			    var isCbcs         = (isCbcsField.getValue()==true)?'1':'0';
			    var isZero         = (isZeroField.getValue()==true)?'1':'0';
			    var subjDefine     = subjDefineField.getValue();
			    var isBudge        = isBudgeField.getValue();
				
				//acctYearDr      = acctYearDr.trim();     
				//acctSubjTypeDr  = acctSubjTypeDr.trim(); 
				acctSubjCode    = acctSubjCode.trim();   
				aCCTSubjName    = aCCTSubjName.trim();   
				aCCTSubjNameAll = aCCTSubjNameAll.trim();
				//superSubj	    = superSubj.trim();	   
				subjLevel       = subjLevel.trim();      
				checkType1      = checkType1.trim();     
				checkType2      = checkType2.trim();     
				checkType3      = checkType3.trim();     
				checkType4      = checkType4.trim();     
				checkType5      = checkType5.trim();     
				checkType6      = checkType6.trim();     
				checkType7      = checkType7.trim();     
				checkType8      = checkType8.trim();     
				define          = define.trim();         
				spell           = spell.trim();          
				subjDefine      = subjDefine.trim();     
				isBudge         = isBudge.trim();        
				
				if (formPanel.form.isValid()) {
					Ext.Ajax.request({
						url: 'dhc.cs.baseexe.csp?action=editacctsubj&rowid='+rowid+'&acctYearDr='+acctYearCB.getValue()+'&acctSubjTypeDr='+acctSubjTypeCB.getValue()+'&acctSubjCode='+acctSubjCode+'&aCCTSubjName='+aCCTSubjName+'&aCCTSubjNameAll='+aCCTSubjNameAll+'&superSubj='+superSubjCB.getValue()+'&subjLevel='+subjLevel+'&isLast='+isLast+'&direction='+direction+'&isCash='+isCash+'&isNum='+isNum+'&isFc='+isFc+'&isCheck='+isCheck+'&checkType1='+checkType1+'&checkType2='+checkType2+'&checkType3='+checkType3+'&checkType4='+checkType4+'&checkType5='+checkType5+'&checkType6='+checkType6+'&checkType7='+checkType7+'&checkType8='+checkType8+'&define='+define+'&spell='+spell+'&isStop='+isStop+'&isCbcs='+isCbcs+'&isZero='+isZero+'&subjDefine='+subjDefine+'&isBudge='+isBudge,
						waitMsg:'������...',
						failure: function(result, request) {
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								dataStore.load();
								window.close();
							}
							else
							{
								var message="SQLErr: "+jsonData.info;
								Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
					scope: this
					});
				}
				else{
						Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ�����ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}             
				}
			},
			{
					text: 'ȡ��',
			handler: function(){window.close();}
		}]
	});
    window.show();
};