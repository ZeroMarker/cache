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
		fieldLabel:'绩效单元',
		width:150,
		listWidth : 150,
		allowBlank:true,
		store:jxUnitDs,
		valueField:'jxUnitDr',
		displayField:'jxUnitShortCut',
		triggerAction:'all',
		emptyText:'请选择绩效单元...',
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
						Ext.Msg.show({title:'错误',msg:'绩效单元不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	
	var PeriodField = new Ext.form.TextField({
		id:'PeriodField',
		fieldLabel: '考核期间',
		allowBlank: false,
		width:180,
		listWidth : 180,
		emptyText:'请填写考核期间...',
		anchor: '90%',
		selectOnFocus:'true',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(PeriodField.getValue()!=""){
						periodTypeField.focus();
					}else{
						Handler = function(){PeriodField.focus();}
						Ext.Msg.show({title:'错误',msg:'考核期间不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	
	var periodTypeStore = new Ext.data.SimpleStore({
		fields: ['key','keyValue'],
		data : [['M','M-月'],['Q','Q-季'],['H','H-半年'],['Y','Y-年']]
	});
	var periodTypeField = new Ext.form.ComboBox({
		id: 'periodTypeField',
		fieldLabel: '期间类型',
		width:275,
		listWidth : 275,
		selectOnFocus: true,
		allowBlank: false,
		store: periodTypeStore,
		anchor: '90%',
		value:'M', //默认值
		valueNotFoundText:'M-月',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'选择期间类型...',
		mode: 'local', //本地模式
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
						Ext.Msg.show({title:'错误',msg:'期间类型不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
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
		fieldLabel:'KPI 指标',
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
						Ext.Msg.show({title:'错误',msg:'KPI 指标不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	
	var actualValueField = new Ext.form.TextField({
		id:'actualValueField',
		fieldLabel: '实际值',
		allowBlank: false,
		width:180,
		listWidth : 180,
		emptyText:'请填写实际值...',
		anchor: '90%',
		selectOnFocus:'true',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(actualValueField.getValue()!=""){
						addButton.focus();
					}else{
						Handler = function(){actualValueField.focus();}
						Ext.Msg.show({title:'错误',msg:'实际值不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	var descField = new Ext.form.TextArea({
		id:'descField',
		fieldLabel: '描述',
		allowBlank: true,
		width:180,
		listWidth : 180,
		emptyText:'请填写描述...',
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
	
	//定义添加按钮
	var addButton = new Ext.Toolbar.Button({
		text:'添加'
	});
			
	//添加处理函数
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
			Ext.Msg.show({title:'提示',msg:'绩效单元为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		period = trim(period);
		if(period==""){
			Ext.Msg.show({title:'提示',msg:'考核期间为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		periodType = trim(periodType);
		if(periodType==""){
			Ext.Msg.show({title:'提示',msg:'期间类别为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		kpidr = trim(kpidr);
		if(kpidr==""){
			Ext.Msg.show({title:'提示',msg:'KPI指标为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		actualValue = trim(actualValue);
		if(actualValue==""){
			Ext.Msg.show({title:'提示',msg:'实际值为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		
		var data = jxunitdr+"^"+period+"^"+periodType+"^"+kpidr+"^"+actualValue+"^"+state+"^"+desc;
		
		Ext.Ajax.request({
			url:'dhc.pa.jxbasedataexe.csp?action=add&data='+data,
			waitMsg:'添加中..',
			failure: function(result, request){
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'提示',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					store.load({params:{start:0, limit:pagingToolbar.pageSize,period:periodValue,periodType:type,dir:'asc',sort:'childSub'}});
				}else{
					if(jsonData.info=='RepRecode'){
						Handler = function(){PeriodField.focus();}
						Ext.Msg.show({title:'提示',msg:'基本数据记录重复!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
					}
					if(jsonData.info=='dataEmpt'){
						Handler = function(){PeriodField.focus();}
						Ext.Msg.show({title:'错误',msg:'数据为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			},
			scope: this
		});
	}

	//添加按钮的响应事件
	addButton.addListener('click',addHandler,false);

	//定义取消按钮
	var cancelButton = new Ext.Toolbar.Button({
		text:'取消'
	});

	//取消处理函数
	var cancelHandler = function(){
		win.close();
	}

	//取消按钮的响应事件
	cancelButton.addListener('click',cancelHandler,false);

	var win = new Ext.Window({
		title: '添加基本数据记录',
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