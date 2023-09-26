addFun = function(store,pagingToolbar){
	var KPIDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['KPIDr','shortCut'])
	});

	KPIDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:KPIProTabUrl+'?action=kpi&str='+Ext.getCmp('KPI').getRawValue()+'&userCode='+userCode,method:'POST'})
	});

	var KPI = new Ext.form.ComboBox({
		id:'KPI',
		fieldLabel:'ָ��',
		width:213,
		listWidth : 213,
		allowBlank:true,
		store:KPIDs,
		valueField:'KPIDr',
		displayField:'shortCut',
		emptyText:'��ѡ��ָ��...',
		triggerAction:'all',
		name: 'KPI',
		emptyText:'',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(KPI.getValue()!=""){
						userField.focus();
					}else{
						Handler = function(){KPI.focus();}
						Ext.Msg.show({title:'����',msg:'ָ�겻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	
	
	formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth:70,
		items: [
			KPI
		]
	});
	
	//������Ӱ�ť
	var addButton = new Ext.Toolbar.Button({
		text:'���'
	});
			
	//��Ӵ�����
	var addHandler = function(){
		var kpidr = Ext.getCmp('KPI').getValue();
		if(kpidr==""){
			Ext.Msg.show({title:'��ʾ',msg:'ָ��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		var data = kpidr;
		
		Ext.Ajax.request({
			url:KPIProTabUrl+'?action=add&data='+data,
			waitMsg:'�����..',
			failure: function(result, request){
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'��ʾ',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					store.load({params:{start:0, limit:pagingToolbar.pageSize,kpidr:kpidr,dir:'asc',sort:'rowid'}});
				}else{
					if(jsonData.info=='RepRecode'){
						Handler = function(){KPI.focus();}
						Ext.Msg.show({title:'��ʾ',msg:'�Ѵ��и�ָ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
					}
					if(jsonData.info=='dataEmpt'){
						Handler = function(){KPI.focus();}
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
		title: '���ƽ��ֵָ�����',
		width: 350,
		height:200,
		minWidth: 350,
		minHeight: 200,
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