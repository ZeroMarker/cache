editSurveyScoreFun = function(dataStore,grid,pagingTool) {
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;

	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		myRowid = rowObj[0].get("rowid");
	}

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
		fieldLabel:'打分科室',
		width:213,
		listWidth : 213,
		allowBlank:true,
		store:jxUnitDs,
		valueField:'jxUnitDr',
		displayField:'jxUnitShortCut',
		valueNotFoundText: rowObj[0].data['unitName'],
		//emptyText:'请选择打分科室...',
		triggerAction:'all',
		name: 'jxUnit',
		emptyText:'',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:'true'
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
		fieldLabel:'接受科室',
		width:213,
		listWidth : 213,
		allowBlank:true,
		store:acceptJXUnitDs,
		valueField:'jxUnitDr',
		displayField:'jxUnitShortCut',
		valueNotFoundText: rowObj[0].data['acceptUnitName'],
		//emptyText:'请选择接受科室...',
		triggerAction:'all',
		name: 'acceptJXUnit',
		emptyText:'',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
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
		fieldLabel: '用户',
		width:213,
		listWidth : 213,
        allowBlank: false,
		store: userDs,
		valueField: 'rowid',
		displayField: 'name',
		valueNotFoundText: rowObj[0].data['userName'],
		triggerAction: 'all',
		//emptyText:'请选择用户...',
		name: 'userField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true'
	});
	
	var periodTypeStore = new Ext.data.SimpleStore({
		fields: ['key','keyValue'],
		data:[['M','月'],['Q','季'],['H','半年'],['Y','年']]
	});
	var periodTypeField = new Ext.form.ComboBox({
		id: 'periodTypeField',
		fieldLabel: '期间类型',
		width:213,
		listWidth : 213,
		selectOnFocus: true,
		allowBlank: false,
		store: periodTypeStore,
		//anchor: '90%',
		value:'', //默认值
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		valueNotFoundText:rowObj[0].data['periodType'],
		triggerAction: 'all',
		//emptyText:'选择期间类型...',
		mode: 'local', //本地模式
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

    
	 var periodField = new Ext.form.TextField({
		id: 'periodField',
		name: 'period',
		fieldLabel:'期间',
		width:213
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
		fieldLabel: '当前方案',
		width:213,
		listWidth : 213,
		selectOnFocus: true,
		allowBlank: false,
		store: schemDs,
		//anchor: '90%',
		displayField:'shortCutFreQuency',
		valueField: 'rowid',
		triggerAction: 'all',
		valueNotFoundText:rowObj[0].data['schemName'],
		//emptyText:'选择当前方案...',
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
		fieldLabel:'KPI指标',
		width:213,
		listWidth : 213,
		allowBlank:true,
		store:kpicomDs,
		valueField:'kpiDr',
		displayField:'KPIName',
		triggerAction:'all',
		valueNotFoundText:rowObj[0].data['KPIName'],
		//emptyText:'',
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
	var typeStore = new Ext.data.SimpleStore({
		fields: ['key','keyValue'],
		data:[['P','个人'],['L','科室']]
	});
	var TypeField = new Ext.form.ComboBox({
		id: 'TypeField',
		fieldLabel: '科室类型',
		width:213,
		listWidth : 213,
		selectOnFocus: true,
		allowBlank: false,
		store: typeStore,
		//anchor: '90%',
		value:'', //默认值
		valueNotFoundText:rowObj[0].data['unitTypeName'],
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		//emptyText:'选择类型...',
		mode: 'local', //本地模式
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	var acceptTypeField = new Ext.form.ComboBox({
		id: 'acceptTypeField',
		fieldLabel: '接受类型',
		width:213,
		listWidth : 213,
		selectOnFocus: true,
		allowBlank: false,
		store: typeStore,
		//anchor: '90%',
		value:'', //默认值
		valueNotFoundText:rowObj[0].data['acceptUnitTypeName'],
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		//emptyText:'选择类型...',
		mode: 'local', //本地模式
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
    var directField = new Ext.form.TextField({
		id: 'directField',
		name: 'directScore',
		fieldLabel:'直接打分',
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
		fieldLabel:'级别',
		width:213,
		listWidth : 213,
		allowBlank:true,
		store:levelDs,
		valueField:'rowid',
		displayField:'name',
		valueNotFoundText:rowObj[0].data['scoreLevel'],
		emptyText:'请选择级别...',
		triggerAction:'all',
		name: 'levelField',
		emptyText:'',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:'true'
	});
	
	var tieOffField = new Ext.form.Checkbox({
		id: 'tieOffField',
		fieldLabel:'有效标志',
		disabled:false,
		allowBlank: false,
		checked: (rowObj[0].data['active']) == 'Y' ? true : false
        
	});



	var flagPanel = new Ext.Panel({
			layout: 'column',
			border: false,
			//labelWidth: 80,
			baseCls: 'x-plain',
			defaults: {
				border: false,
				layout: 'form',
				baseCls: 'x-plain',
				//labelSeparator: ':',
				columnWidth: .3
			},
			items: [
				
				{
					items: tieOffField
				}
			]
	});

	// create form panel
	var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			userField,
			periodTypeField,
			periodField,
			schemField,
			jxUnit,
			TypeField,
			acceptJXUnit,
			acceptTypeField,
			kpicom,
			directField,
			levelField,
            flagPanel
			
		]
	});

	formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			kpicom.setValue(rowObj[0].get("KpiDr"));
			userField.setValue(rowObj[0].get("userDr"));
			schemField.setValue(rowObj[0].get("schemDr"));
			jxUnit.setValue(rowObj[0].get("unitDr"));
			TypeField.setValue(rowObj[0].get("unitType"));
			acceptJXUnit.setValue(rowObj[0].get("acceptUnitDr"));
			acceptTypeField.setValue(rowObj[0].get("acceptUnitType"));
			levelField.setValue(rowObj[0].get("scoreLevelDr"));
		});
  
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '修改等级表',
    width: 380,
    height:420,
    minWidth: 380,
    minHeight: 420,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
    	text: '保存',
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
			var period = periodField.getValue();
			var periodType = periodTypeField.getValue();
      		var schemF = schemField.getValue();
			//var schem = "1||3";
			user = user.trim();
			unit = unit.trim();
		    type = type.trim();
			acceptUnit = acceptUnit.trim();
			acceptType = acceptType.trim();
			KPIDr = KPIDr.trim();
      		direct = direct.trim();
			levelF = levelF.trim();
			period = period.trim();
			periodType = periodType.trim();
            schemF = schemF.trim();
			var tieOff = (tieOffField.getValue()==true)?'Y':'N'; 
      		if(KPIDr=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'指标为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
        	var data = user+'^'+unit+'^'+type+'^'+acceptUnit+'^'+acceptType+'^'+KPIDr+'^'+levelF+'^'+direct+'^'+period+'^'+periodType+'^'+schemF+'^'+tieOff;
            //var data = code+'^'+name+'^'+py+'^'+sorce+'^'+tieOff;
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: SurveyScoreUrl+'?action=edit&data='+data+'&rowid='+myRowid,
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
									window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyRecData') message='输入的数据为空!';
									if(jsonData.info=='RepCode') message='输入的代码已经存在!';
									if(jsonData.info=='RepName') message='输入的名称已经存在!';
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