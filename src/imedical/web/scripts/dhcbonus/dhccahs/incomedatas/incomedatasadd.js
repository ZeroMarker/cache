var addFun = function(dataStore,grid,pagingTool) {
	//alert(userDr);
	if(monthDr==""){
		Ext.Msg.show({title:'����',msg:'��ѡ�������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	}
	
	var feeField = new Ext.form.NumberField({
		id: 'feeField',
		fieldLabel: '�շѽ��',
		//allowDecimals:false,
		allowBlank: false,
		value:0,
		anchor: '90%'
	});
	
	var costField = new Ext.form.NumberField({
		id: 'costField',
		fieldLabel: '�ɱ����',
		//allowDecimals:false,
		allowBlank: false,
		value:0,
		anchor: '90%'
	});
	
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '��ע',
		allowBlank: true,
		emptyText: '�������ݱ�ע...',
		anchor: '90%'
	});
	var itemTypeDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','order','code','name','shortcut','remark','active'])
	});

	itemTypeDs.on('beforeload',function(ds, o){
		ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.dataitemcorresexe.csp?action=listtype&searchField=shortcut&searchValue='+Ext.getCmp('itemTypes').getRawValue(), method:'GET'});
	});

	var itemTypes = new Ext.form.ComboBox({
		id:'itemTypes',
		fieldLabel:'��Ŀ���',
		store: itemTypeDs,
		valueField:'rowid',
		displayField:'shortcut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		anchor: '90%',
		listWidth:250,
		triggerAction:'all',
		emptyText:'ѡ�����������...',
		allowBlank: false,
		name:'itemTypes',
		selectOnFocus: true,
		forceSelection: true 
	});
	
	var itemsDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",                                                        
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','typeDr','typeName','typeShortCut','order','itemDr','itemCode','itemName','itemShortCut'])
	});

	itemsDs.on('beforeload',function(ds, o){           
		ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.vouchdatasexe.csp?action=items&searchField=itemShortCut&searchValue='+Ext.getCmp('items').getRawValue()+'&id='+itemTypes.getValue(), method:'GET'});
	});

	var items = new Ext.form.ComboBox({
		id:'items',
		fieldLabel:'����������Ŀ',
		store: itemsDs,
		valueField:'itemDr',
		displayField:'itemShortCut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		anchor: '90%',
		listWidth:250,
		triggerAction:'all',
		emptyText:'ѡ��������...',
		allowBlank: false,
		name:'items',
		selectOnFocus: true,
		forceSelection: true 
	});
	
	var unitTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	var unitType = new Ext.form.ComboBox({
		id: 'unitType',
		fieldLabel: '�������',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: unitTypeDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ�������...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	unitTypeDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=unitType&searchValue='+Ext.getCmp('unitType').getRawValue(),method:'POST'});
	});

	var unitsDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	var units = new Ext.form.ComboBox({
		id: 'units',
		fieldLabel: 'ҽԺ��Ԫ',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: unitsDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ��ҽԺ��Ԫ...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	unitsDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=units&searchValue='+Ext.getCmp('units').getRawValue()+'&id='+unitType.getValue(),method:'POST'});
	});
	
	var assLocDs = new Ext.data.Store({
		proxy: "",                                                            
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','address','remark','startTime','stop','unitDr','propertyDr','active'])
	});
	var assLoc = new Ext.form.ComboBox({
		id: 'assLoc',
		fieldLabel: '���㿪������',
		anchor: '90%',
		listWidth : 260,
		allowBlank: true,
		store: assLocDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ����㿪������...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	assLocDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.vouchdatasexe.csp?action=depts&searchField=shortcut&searchValue='+Ext.getCmp('assLoc').getRawValue()+'&unitsDr='+units.getValue(),method:'GET'});
	});
	//--------------------------------------------------------
	var unitFTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	var unitFType = new Ext.form.ComboBox({
		id: 'unitFType',
		fieldLabel: '�������',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: unitFTypeDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ�������...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	unitFTypeDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=unitType&searchValue='+Ext.getCmp('unitFType').getRawValue(),method:'POST'});
	});

	var unitsFDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	var unitsF = new Ext.form.ComboBox({
		id: 'unitsF',
		fieldLabel: 'ҽԺ��Ԫ',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: unitsFDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ��ҽԺ��Ԫ...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	unitsFDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=units&searchValue='+Ext.getCmp('unitsF').getRawValue()+'&id='+unitFType.getValue(),method:'POST'});
	});
	
	var assLocFDs = new Ext.data.Store({
		proxy: "",                                                            
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','address','remark','startTime','stop','unitDr','propertyDr','active'])
	});
	var assFLoc = new Ext.form.ComboBox({
		id: 'assFLoc',
		fieldLabel: '������ղ���',
		anchor: '90%',
		listWidth : 260,
		allowBlank: true,
		store: assLocFDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ�������ղ���...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	assLocFDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.vouchdatasexe.csp?action=depts&searchField=shortcut&searchValue='+Ext.getCmp('assFLoc').getRawValue()+'&unitsDr='+units.getValue(),method:'GET'});
	});
	//--------------------------------------------------------
	var unitTTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	var unitTType = new Ext.form.ComboBox({
		id: 'unitTType',
		fieldLabel: '�������',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: unitTTypeDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ�������...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	unitTTypeDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=unitType&searchValue='+Ext.getCmp('unitTType').getRawValue(),method:'POST'});
	});

	var unitsTDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	var unitsT = new Ext.form.ComboBox({
		id: 'unitsT',
		fieldLabel: 'ҽԺ��Ԫ',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: unitsTDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ��ҽԺ��Ԫ...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	unitsTDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=units&searchValue='+Ext.getCmp('unitsT').getRawValue()+'&id='+unitTType.getValue(),method:'POST'});
	});
	
	var assLocTDs = new Ext.data.Store({
		proxy: "",                                                            
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','address','remark','startTime','stop','unitDr','propertyDr','active'])
	});
	var assTLoc = new Ext.form.ComboBox({
		id: 'assTLoc',
		fieldLabel: '���㲡�˲���',
		anchor: '90%',
		listWidth : 260,
		allowBlank: true,
		store: assLocTDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ����㲡�˲���...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	assLocTDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.vouchdatasexe.csp?action=depts&searchField=shortcut&searchValue='+Ext.getCmp('assTLoc').getRawValue()+'&unitsDr='+unitsT.getValue(),method:'GET'});
	});
	//--------------------------------------------------------
	var formStore = new Ext.data.SimpleStore({//������Ͽ�����ʾ������Դ
		fields: ['type','rowid'],
		data : [['סԺ','I'],['����','O'],['���','H']]
	});
	var formComm = new Ext.form.ComboBox({
		id: 'formComm',
		fieldLabel: '��������',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: formStore,
		valueField: 'rowid',
		displayField: 'type',
		triggerAction: 'all',
		emptyText:'��������...',
		mode: 'local',
		name:'Flag',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	
	var inDate = new Ext.form.DateField({
		id: 'inDate',
		fieldLabel: '����ʱ��',
		allowBlank: true,
		dateFormat: 'Y-m-d',
		emptyText:'ѡ������ʱ��...',
		anchor: '90%'
	});
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 90,
		items: [
			inDate,
			formComm,
			unitType,
			units,
			assLoc,
			unitFType,
			unitsF,
			assFLoc,
			unitTType,
			unitsT,
			assTLoc,
			itemTypes,
			items,
			remarkField,
			feeField
			//costField
		]        
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '����������ݱ�',
    width: 400,
    height:500,
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
			var patType=formComm.getValue();
			var fDeptDr = assLoc.getValue();
			var tDeptDr = assFLoc.getValue();
			var patDeptDr = assTLoc.getValue();
      		var itemsDr = items.getValue();
      		var remark = remarkField.getValue();
			var fee=feeField.getValue();
			var cost=costField.getValue();
			var feeDate=""
			if (Ext.getCmp('inDate').getValue()!=""){
				feeDate=Ext.getCmp('inDate').getValue().format('Y-m-d');
			}
        	if (formPanel.form.isValid()) {
						//alert('action=add&deptDr='+deptDr+'&itemsDr='+itemsDr+'&remark='+remark+'&fee='+fee+'&cost='+cost+'&monthDr='+monthDr+'&userDr='+userDr);
						//return;
						Ext.Ajax.request({
							url: incomeDatasUrl+'?action=add&fDeptDr='+fDeptDr+'&patType='+patType+'&feeDate='+feeDate+'&tDeptDr='+tDeptDr+'&patDeptDr='+patDeptDr+'&itemsDr='+itemsDr+'&remark='+remark+'&fee='+fee+'&cost='+cost+'&monthDr='+monthDr+'&userDr='+userDr,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									incomeDatasDs.setDefaultSort('rowid', 'desc');
									dataStore.load({params:{start:0, limit:pagingTool.pageSize,monthDr:monthDr}});
									//window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyName') message='���������Ϊ��!';
									if(jsonData.info=='EmptyOrder') message='��������Ϊ��!';
									if(jsonData.info=='RepName') message='����������Ѿ�����!';
									if(jsonData.info=='RepOrder') message='���������Ѿ�����!';
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
		assLoc.setRawValue("");
		unitsDs.load({params:{start:0, limit:cmb.pageSize,id:cmb.getValue()}});
	});
	units.on("select",function(cmb,rec,id ){
		assLoc.setValue("");
		assLoc.setRawValue("");
		assLocDs.load({params:{start:0, limit:assLoc.pageSize,id:cmb.getValue()}});
	});
	itemTypes.on("select",function(cmb,rec,id ){
		items.setRawValue("");
		items.setValue("");
		itemsDs.load({params:{start:0, limit:cmb.pageSize,id:cmb.getValue()}});
	});
	
	unitFType.on("select",function(cmb,rec,id ){
		unitsF.setRawValue("");
		unitsF.setValue("");
		assFLoc.setValue("");
		assFLoc.setRawValue("");
		unitsFDs.load({params:{start:0, limit:cmb.pageSize,id:cmb.getValue()}});
	});
	unitsF.on("select",function(cmb,rec,id ){
		assFLoc.setValue("");
		assFLoc.setRawValue("");
		assLocFDs.load({params:{start:0, limit:assFLoc.pageSize,id:cmb.getValue()}});
	});
	
	unitTType.on("select",function(cmb,rec,id ){
		unitsT.setRawValue("");
		unitsT.setValue("");
		assTLoc.setValue("");
		assTLoc.setRawValue("");
		unitsTDs.load({params:{start:0, limit:cmb.pageSize,id:cmb.getValue()}});
	});
	unitsT.on("select",function(cmb,rec,id ){
		assTLoc.setValue("");
		assTLoc.setRawValue("");
		assLocTDs.load({params:{start:0, limit:assTLoc.pageSize,id:cmb.getValue()}});
	});

    window.show();
};