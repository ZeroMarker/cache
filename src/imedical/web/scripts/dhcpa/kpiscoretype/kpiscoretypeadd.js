var addKpiScoreTypeFun = function(dataStore,grid,pagingTool) {
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
    var directField = new Ext.form.Radio({
		id: 'directField',
		name:'score',
		labelSeparator:'ֱ��'
	});
			
	var levelField = new Ext.form.Radio({
		id: 'levelField',
		name:'score',
		labelSeparator:'�ȼ�'
	});
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			kpicom,
            directField,
			levelField
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '��ӵȼ���',
    width: 400,
    height:300,
    minWidth: 400,
    minHeight: 300,
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
      		var KPIDr = kpicom.getValue();
      		var direct = (directField.getValue()==true)?'Y':'N'; 
			var level = (levelField.getValue()==true)?'Y':'N';
      		KPIDr = KPIDr.trim();
      		//direct = direct.trim();
			//level = level.trim();

      		if(KPIDr=="")
      		{
      			Ext.Msg.show({title:'����',msg:'ָ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
        	var data = KPIDr+'^'+direct+'^'+level;
			if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: KpiScoreTypeUrl+'?action=add&data='+data,
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
									//window.close();
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