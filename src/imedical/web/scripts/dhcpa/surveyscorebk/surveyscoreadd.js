var addSurveyScoreFun = function(dataStore,grid,pagingTool) {
	
	var jxUnitDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['jxUnitDr','jxUnitShortCut'])
	});

	jxUnitDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:'dhc.pa.jxunitauditexe.csp?action=jxunit&str='+Ext.getCmp('jxUnit').getRawValue(),method:'POST'})
	});

	var jxUnit = new Ext.form.ComboBox({
		id:'jxUnit',
		fieldLabel:'��ֿ���',
		width:213,
		listWidth : 213,
		allowBlank:true,
		store:jxUnitDs,
		valueField:'jxUnitDr',
		displayField:'jxUnitShortCut',
		emptyText:'��ѡ���ֿ���...',
		triggerAction:'all',
		name: 'jxUnit',
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
						userField.focus();
					}else{
						Handler = function(){jxUnit.focus();}
						Ext.Msg.show({title:'����',msg:'��Ч��Ԫ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	
	var acceptJXUnitDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['jxUnitDr','jxUnitShortCut'])
	});

	acceptJXUnitDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:'dhc.pa.jxunitauditexe.csp?action=jxunit&str='+Ext.getCmp('acceptJXUnit').getRawValue(),method:'POST'})
	});

	var acceptJXUnit = new Ext.form.ComboBox({
		id:'acceptJXUnit',
		fieldLabel:'���ܿ���',
		width:213,
		listWidth : 213,
		allowBlank:true,
		store:acceptJXUnitDs,
		valueField:'jxUnitDr',
		displayField:'jxUnitShortCut',
		emptyText:'��ѡ����ܿ���...',
		triggerAction:'all',
		name: 'acceptJXUnit',
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
						userField.focus();
					}else{
						Handler = function(){jxUnit.focus();}
						Ext.Msg.show({title:'����',msg:'��Ч��Ԫ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	var userDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});

	userDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:'dhc.pa.jxunitauditexe.csp?action=user&str='+Ext.getCmp('userField').getRawValue(),method:'POST'})
	});

	var userField = new Ext.form.ComboBox({
		id: 'userField',
		fieldLabel: '�û�',
		width:213,
		listWidth : 213,
        allowBlank: false,
		store: userDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'��ѡ���û�...',
		name: 'userField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(userField.getValue()!=""){
						isReadField.focus();
					}else{
						Handler = function(){userField.focus();}
						Ext.Msg.show({title:'����',msg:'Ȩ���û�����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	
	var data="";
	var monthStore="";

	var cycleDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
	});

	cycleDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:'../csp/dhc.pa.stratagemexe.csp?action=cycle&searchValue='+Ext.getCmp('cycleField').getRawValue()+'&active=Y',method:'POST'})
	});

	var cycleField = new Ext.form.ComboBox({
		id: 'cycleField',
		fieldLabel:'��������',
		width:213,
		listWidth : 213,
		allowBlank: false,
		store: cycleDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'��ѡ�񿼺�����...',
		name: 'cycleField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});

	var periodTypeStore = new Ext.data.SimpleStore({
		fields: ['key','keyValue'],
		data:[['M','��'],['Q','��'],['H','����'],['Y','��']]
	});
	var periodTypeField = new Ext.form.ComboBox({
		id: 'periodTypeField',
		fieldLabel: '�ڼ�����',
		width:213,
		listWidth : 213,
		selectOnFocus: true,
		allowBlank: false,
		store: periodTypeStore,
		//anchor: '90%',
		value:'', //Ĭ��ֵ
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'ѡ���ڼ�����...',
		mode: 'local', //����ģʽ
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	periodTypeField.on("select",function(cmb,rec,id){
		if(cmb.getValue()=="M"){
			data=[['1','01��'],['2','02��'],['3','03��'],['4','04��'],['5','05��'],['6','06��'],['7','07��'],['8','08��'],['9','09��'],['10','10��'],['11','11��'],['12','12��']];
		}
		if(cmb.getValue()=="Q"){
			data=[['1','01����'],['2','02����'],['3','03����'],['4','04����']];
		}
		if(cmb.getValue()=="H"){
			data=[['1','1~6�ϰ���'],['2','7~12�°���']];
		}
		if(cmb.getValue()=="Y"){
			data=[['0','00']];
		}
		periodStore.loadData(data);
	});
	periodStore = new Ext.data.SimpleStore({
		fields:['key','keyValue']
	});

	var periodField = new Ext.form.ComboBox({
		id: 'periodField',
		fieldLabel: '�ڼ�',
		width:213,
		listWidth : 213,
		selectOnFocus: true,
		allowBlank: false,
		store: periodStore,
		//anchor: '90%',
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'��ѡ��...',
		mode: 'local', //����ģʽ
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});


	var schemDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','parRef','code','name','shortcut','appSysDr','frequency','KPIDr','KPIName','desc','level','appSys','quency','shortCutFreQuency'])
	});

	schemDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:'../csp/dhc.pa.disttargetexe.csp?action=schem&searchValue='+Ext.getCmp('schem').getRawValue()+'&active=Y',method:'POST'})
	});
	var schemField = new Ext.form.ComboBox({
		id: 'schem',
		fieldLabel: '��ǰ����',
		width:213,
		listWidth : 213,
		selectOnFocus: true,
		allowBlank: false,
		store: schemDs,
		//anchor: '90%',
		displayField:'shortCutFreQuency',
		valueField: 'rowid',
		triggerAction: 'all',
		emptyText:'ѡ��ǰ����...',
		editable:true,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	var kpicomDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['kpiDr','KPIName'])
	});

	kpicomDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:SurveyScoreUrl+'?action=getkpiscore&str='+Ext.getCmp('kpicom').getRawValue()+'&userCode='+userCode,method:'POST'})
	});

	var kpicom = new Ext.form.ComboBox({
		id:'kpicom',
		fieldLabel:'KPI ָ��',
		width:213,
		listWidth : 213,
		allowBlank:true,
		store:kpicomDs,
		valueField:'kpiDr',
		displayField:'KPIName',
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
	var typeStore = new Ext.data.SimpleStore({
		fields: ['key','keyValue'],
		data:[['P','����'],['L','����']]
	});
	var TypeField = new Ext.form.ComboBox({
		id: 'TypeField',
		fieldLabel: '��������',
		width:213,
		listWidth : 213,
		selectOnFocus: true,
		allowBlank: false,
		store: typeStore,
		//anchor: '90%',
		value:'', //Ĭ��ֵ
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'ѡ������...',
		mode: 'local', //����ģʽ
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	var acceptTypeField = new Ext.form.ComboBox({
		id: 'acceptTypeField',
		fieldLabel: '��������',
		width:213,
		listWidth : 213,
		selectOnFocus: true,
		allowBlank: false,
		store: typeStore,
		//anchor: '90%',
		value:'', //Ĭ��ֵ
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'ѡ������...',
		mode: 'local', //����ģʽ
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
    var directField = new Ext.form.TextField({
		id: 'directField',
		fieldLabel:'ֱ�Ӵ��',
		width:213
	});
			
	var levelDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','sorce','code','name','shortcut','py','active'])
	});

	levelDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:'dhc.pa.sorcelevelexe.csp?action=list&active=Y',method:'POST'})
	});
	var levelField = new Ext.form.ComboBox({
		fieldLabel:'����',
		width:213,
		listWidth : 213,
		allowBlank:true,
		store:levelDs,
		valueField:'rowid',
		displayField:'name',
		emptyText:'��ѡ�񼶱�...',
		triggerAction:'all',
		name: 'levelField',
		emptyText:'',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:'true'
	});
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			userField,
			cycleField,
			periodTypeField,
			periodField,
			schemField,
			jxUnit,
			TypeField,
			acceptJXUnit,
			acceptTypeField,
			kpicom,
			directField,
			levelField
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '��ӵȼ���',
    width: 400,
    height:400,
    minWidth: 400,
    minHeight: 400,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
    	text: '����',
		handler: function() {
      		// check form value
      		var user = userField.getValue();
			var unit = jxUnit.getValue();
			var type = TypeField.getValue();
			var acceptUnit = acceptJXUnit.getValue();
			var acceptType = acceptTypeField.getValue();
			var KPIDr = kpicom.getValue();
      		var direct = directField.getValue(); 
			var levelF = levelField.getValue();
			//levelField = 2;
			var cycle = cycleField.getValue();
			var period = periodField.getValue();
			var periodType = periodTypeField.getValue();
      		var schemF = schemField.getValue();
			var schem = "1||3";
			user = user.trim();
			unit = unit.trim();
		    type = type.trim();
			acceptUnit = acceptUnit.trim();
			acceptType = acceptType.trim();
			KPIDr = KPIDr.trim();
      		direct = direct.trim();
			levelF = levelF.trim();
			cycle = cycle.trim();
			period = period.trim();
			periodType = periodType.trim();
            schemF = schemF.trim();
      		
			if(KPIDr=="")
      		{
      			Ext.Msg.show({title:'����',msg:'ָ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
        	var data = user+'^'+unit+'^'+type+'^'+acceptUnit+'^'+acceptType+'^'+KPIDr+'^'+levelF+'^'+direct+'^'+cycle+'^'+period+'^'+periodType+'^'+schemF;
			if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: SurveyScoreUrl+'?action=add&data='+data,
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
									window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyRecData') message='���������Ϊ��!';
									if(jsonData.info=='RepCode') message='����Ĵ����Ѿ�����!';
									if(jsonData.info=='RepName') message='����������Ѿ�����!';
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