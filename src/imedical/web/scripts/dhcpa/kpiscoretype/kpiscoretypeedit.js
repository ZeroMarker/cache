editKpiScoreTypeFun = function(dataStore,grid,pagingTool) {
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;

	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		myRowid = rowObj[0].get("rowid");
	}

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
		width:250,
		listWidth : 250,
		allowBlank:true,
		store:kpicomDs,
		valueField:'KPIDr',
		displayField:'shortCut',
		valueNotFoundText:rowObj[0].get('KPIName'),
		triggerAction:'all',
		emptyText:'',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:false,
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
		labelSeparator:'ֱ��',
		checked: (rowObj[0].data['directScore']) == 'Y' ? true : false
	});
			
	var levelField = new Ext.form.Radio({
		id: 'levelField',
		name:'score',
		labelSeparator:'�ȼ�',
		checked: (rowObj[0].data['levelScore']) == 'Y' ? true : false
	});	
	var tieOffField = new Ext.form.Checkbox({
		id: 'tieOffField',
		fieldLabel:'��Ч��־',
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
			kpicom,
            directField,
			levelField,
            flagPanel
			
		]
	});

	formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			kpicom.setValue(rowObj[0].get("KpiDr"));
		});
  
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '�޸ĵȼ���',
    width: 380,
    height:220,
    minWidth: 380,
    minHeight: 220,
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
      		
			var tieOff = (tieOffField.getValue()==true)?'Y':'N'; 
		    var direct = (directField.getValue()==true)?'Y':'N'; 
			var level = (levelField.getValue()==true)?'Y':'N';
			
      		KPIDr = KPIDr.trim();
      		if(KPIDr=="")
      		{
      			Ext.Msg.show({title:'����',msg:'ָ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
        	var data = KPIDr+'^'+direct+'^'+level+'^'+tieOff;
            //var data = code+'^'+name+'^'+py+'^'+sorce+'^'+tieOff;
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: KpiScoreTypeUrl+'?action=edit&data='+data+'&rowid='+myRowid,
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
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