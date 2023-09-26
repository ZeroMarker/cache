addFun = function(type,periodValue,store,pagingToolbar){
	var userCode = session['LOGON.USERCODE'];
	var jxUnitDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['jxUnitDr','jxUnitShortCut'])
	});

	jxUnitDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:'dhc.pa.jxbasedataexe.csp?action=jxunit&str='+Ext.getCmp('jxUnit').getRawValue()+'&userCode='+userCode,method:'POST'})
	});

	var jxUnit = new Ext.form.ComboBox({
		id:'jxUnit',
		fieldLabel:'��Ч��Ԫ',
		width:150,
		listWidth : 150,
		allowBlank:true,
		store:jxUnitDs,
		valueField:'jxUnitDr',
		displayField:'jxUnitShortCut',
		triggerAction:'all',
		emptyText:'��ѡ��Ч��Ԫ...',
		emptyText:'',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(jxUnit.getValue()!=""){
						PeriodField.focus();
					}else{
						Handler = function(){jxUnit.focus();}
						Ext.Msg.show({title:'����',msg:'��Ч��Ԫ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	
	var PeriodField = new Ext.form.TextField({
		id:'PeriodField',
		fieldLabel: '�����ڼ�',
		allowBlank: false,
		width:180,
		listWidth : 180,
		emptyText:'����д�����ڼ�...',
		anchor: '90%',
		selectOnFocus:'true',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(PeriodField.getValue()!=""){
						periodTypeField.focus();
					}else{
						Handler = function(){PeriodField.focus();}
						Ext.Msg.show({title:'����',msg:'�����ڼ䲻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	
	var periodTypeStore = new Ext.data.SimpleStore({
		fields: ['key','keyValue'],
		data : [['M','M-��'],['Q','Q-��'],['H','H-����'],['Y','Y-��']]
	});
	var periodTypeField = new Ext.form.ComboBox({
		id: 'periodTypeField',
		fieldLabel: '�ڼ�����',
		width:275,
		listWidth : 275,
		selectOnFocus: true,
		allowBlank: false,
		store: periodTypeStore,
		anchor: '90%',
		value:'M', //Ĭ��ֵ
		valueNotFoundText:'M-��',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'ѡ���ڼ�����...',
		mode: 'local', //����ģʽ
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(periodTypeField.getValue()!=""){
						kpicom.focus();
					}else{
						Handler = function(){periodTypeField.focus();}
						Ext.Msg.show({title:'����',msg:'�ڼ����Ͳ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	
	var kpicomDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['KPIDr','shortCut'])
	});

	kpicomDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:'dhc.pa.jxbasedataexe.csp?action=kpi&str='+Ext.getCmp('kpicom').getRawValue()+'&userCode='+userCode,method:'POST'})
	});

	var kpicom = new Ext.form.ComboBox({
		id:'kpicom',
		fieldLabel:'KPI ָ��',
		width:285,
		listWidth : 285,
		allowBlank:true,
		store:kpicomDs,
		valueField:'KPIDr',
		displayField:'shortCut',
		triggerAction:'all',
		emptyText:'',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(kpicom.getValue()!=""){
						actualValueField.focus();
					}else{
						Handler = function(){kpicom.focus();}
						Ext.Msg.show({title:'����',msg:'KPI ָ�겻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	
	var actualValueField = new Ext.form.TextField({
		id:'actualValueField',
		fieldLabel: 'ʵ��ֵ',
		allowBlank: false,
		width:180,
		listWidth : 180,
		emptyText:'����дʵ��ֵ...',
		anchor: '90%',
		selectOnFocus:'true',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(actualValueField.getValue()!=""){
						addButton.focus();
					}else{
						Handler = function(){actualValueField.focus();}
						Ext.Msg.show({title:'����',msg:'ʵ��ֵ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	var descField = new Ext.form.TextArea({
		id:'descField',
		fieldLabel: '����',
		allowBlank: true,
		width:180,
		listWidth : 180,
		emptyText:'����д����...',
		anchor: '90%',
		selectOnFocus:'true'
	});
	formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth:60,
		items: [
			jxUnit,
			PeriodField,
			periodTypeField,
			kpicom,
			actualValueField,
			descField
		]
	});
	
	//������Ӱ�ť
	var addButton = new Ext.Toolbar.Button({
		text:'���'
	});
			
	//��Ӵ�����
	var addHandler = function(){
		var jxunitdr = Ext.getCmp('jxUnit').getValue();
		var period = PeriodField.getValue();
		var periodType = Ext.getCmp('periodTypeField').getValue();
		var kpidr = Ext.getCmp('kpicom').getValue();
		var actualValue = actualValueField.getValue();
		var desc = descField.getValue();
		var state = -1;
		jxunitdr = trim(jxunitdr);
		if(jxunitdr==""){
			Ext.Msg.show({title:'��ʾ',msg:'��Ч��ԪΪ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		period = trim(period);
		if(period==""){
			Ext.Msg.show({title:'��ʾ',msg:'�����ڼ�Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		periodType = trim(periodType);
		if(periodType==""){
			Ext.Msg.show({title:'��ʾ',msg:'�ڼ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		kpidr = trim(kpidr);
		if(kpidr==""){
			Ext.Msg.show({title:'��ʾ',msg:'KPIָ��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		actualValue = trim(actualValue);
		if(actualValue==""){
			Ext.Msg.show({title:'��ʾ',msg:'ʵ��ֵΪ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		
		var data = jxunitdr+"^"+period+"^"+periodType+"^"+kpidr+"^"+actualValue+"^"+state+"^"+desc;
		
		Ext.Ajax.request({
			url:'dhc.pa.jxbasedataexe.csp?action=add&data='+data,
			waitMsg:'�����..',
			failure: function(result, request){
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'��ʾ',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					store.load({params:{start:0, limit:pagingToolbar.pageSize,period:periodValue,periodType:type,dir:'asc',sort:'childSub'}});
				}else{
					if(jsonData.info=='RepRecode'){
						Handler = function(){PeriodField.focus();}
						Ext.Msg.show({title:'��ʾ',msg:'�������ݼ�¼�ظ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
					}
					if(jsonData.info=='dataEmpt'){
						Handler = function(){PeriodField.focus();}
						Ext.Msg.show({title:'����',msg:'����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			},
			scope: this
		});
	}

	//��Ӱ�ť����Ӧ�¼�
	addButton.addListener('click',addHandler,false);

	//����ȡ����ť
	var cancelButton = new Ext.Toolbar.Button({
		text:'ȡ��'
	});

	//ȡ��������
	var cancelHandler = function(){
		win.close();
	}

	//ȡ����ť����Ӧ�¼�
	cancelButton.addListener('click',cancelHandler,false);

	var win = new Ext.Window({
		title: '��ӻ������ݼ�¼',
		width: 415,
		height:340,
		minWidth: 415,
		minHeight: 340,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [
			addButton,
			cancelButton
		]
	});
	win.show();
}