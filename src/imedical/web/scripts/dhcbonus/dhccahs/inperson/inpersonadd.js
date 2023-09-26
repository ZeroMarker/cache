addInDeptsFun = function(dataStore,grid,pagingTool) {
	if(inDeptSetsId=="")
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ��ӿں�����Ա�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return;
	}
	var orderField = new Ext.form.NumberField({
		id: 'orderField',
		fieldLabel: '���',
		allowDecimals:false,
		allowBlank: false,
		emptyText: '���...',
		anchor: '90%'
	});
	
	var unitTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	var unitType = new Ext.form.ComboBox({
		id: 'unitType',
		fieldLabel: '��Ԫ���',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: unitTypeDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ��Ԫ���...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	unitTypeDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=unitType&searchValue='+Ext.getCmp('unitType').getRawValue(),method:'GET'});
	});

	var unitsDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	var units = new Ext.form.ComboBox({
		id: 'units',
		fieldLabel: '��Ԫ',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: unitsDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ��Ԫ...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	unitsDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=units&searchField=shortcut&searchValue='+Ext.getCmp('units').getRawValue()+'&id='+unitType.getValue(),method:'GET'});
	});
	
	var assLocDs = new Ext.data.Store({
		proxy: "",                                                            
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','shortcut','address','remark','startTime','stop','unitDr','propertyDr','active'])
	});
	var assLoc = new Ext.form.ComboBox({
		id: 'assLoc',
		fieldLabel: '��Ա',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: assLocDs,
		valueField: 'rowid',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ����Ա...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	assLocDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.inpersonexe.csp?action=unitperson&searchField=shortcut&searchValue='+Ext.getCmp('assLoc').getRawValue()+'&unitDr='+units.getValue()+'&inDeptSetsId='+inDeptSetsId,method:'GET'});
	});
	
	// create form panel
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 70,
		items: [
			orderField,
			unitType,
			units,
			assLoc
		]
	});

	// define window and show it in desktop
	var window = new Ext.Window({
		title: '��ӽӿں�����Ա',
		width: 350,
		height: 300,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			id:'saveButton',
			text: '����',
			handler: function() {
				if (formPanel.form.isValid()) {
					Ext.Ajax.request({
						url: outDeptsUrl+'?action=add&order='+orderField.getValue()+'&inDeptId='+assLoc.getValue()+'&inDeptSetsId='+inDeptSetsId,
						waitMsg:'������...',
						failure: function(result, request) {
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								assLoc.setValue("");
								assLoc.setRawValue("");
								assLocDs.load({params:{start:0, limit:assLoc.pageSize}});
								dataStore.load({params:{start:0, limit:inDeptsPagingToolbar.pageSize,inDeptSetsId:inDeptSetsId}});
							}
							else
							{
								var message = "";
								if(jsonData.info == 'RepOrder')
								{
									message = '���������Ѿ�����!';
								}
								else if(jsonData.info == 'RepDept')
								{
									message = '����Ŀ����Ѿ�����!';
								}
								else
								{	
									message = jsonData.info;
								}
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
				unitType.on("select",function(cmb,rec,id ){
					units.setRawValue("");
					units.setValue("");
					assLoc.setValue("");
					unitsDs.load({params:{start:0, limit:cmb.pageSize,id:cmb.getValue()}});
					//UnitPersonsDs.load({params:{start:0, limit:0,id:cmb.getValue(),searchValue:"",type:type}});
				});
				units.on("select",function(cmb,rec,id ){
						type="";
						assLocDs.load({params:{start:0, limit:assLoc.pageSize,id:cmb.getValue()}});
				});
				window.show();
			};
			