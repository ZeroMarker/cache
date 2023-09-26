var paramFun = function(dataStore,grid,pagingTool) {
	

	//------------------------------------------------------------------------------
	var feeField = new Ext.form.NumberField({
		id: 'feeField',
		fieldLabel: '金额',
		//allowDecimals:false,
		name:'fee',
		allowBlank: true,
		anchor: '90%'
	});
	
	var costField = new Ext.form.NumberField({
		id: 'costField',
		fieldLabel: '成本',
		//allowDecimals:false,
		name:'cost',
		allowBlank: true,
		anchor: '90%'
	});
	
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '备注',
		name:'remark',
		allowBlank: true,
		emptyText: '收入数据备注...',
		anchor: '90%'
	});
	var itemCodeField = new Ext.form.TextField({
		id: 'itemCodeField',
		fieldLabel: '项目代码',
		name:'itemCode',
		allowBlank: true,
		emptyText: '项目代码...',
		anchor: '90%'
	});
	var itemNameField = new Ext.form.TextField({
		id: 'itemNameField',
		fieldLabel: '项目名称',
		name:'itemName',
		allowBlank: true,
		emptyText: '收入项目名称...',
		anchor: '90%'
	});
	var fDeptCodeField = new Ext.form.TextField({
		id: 'fDeptCodeField',
		fieldLabel: '开单部门代码',
		name:'fDeptCode',
		allowBlank: true,
		emptyText: '开单部门代码...',
		anchor: '90%'
	});
	var fDeptNameField = new Ext.form.TextField({
		id: 'fDeptNameField',
		fieldLabel: '开单部门名称',
		name:'fDeptName',
		allowBlank: true,
		emptyText: '开单部门名称...',
		anchor: '90%'
	});
	var tDeptCodeField = new Ext.form.TextField({
		id: 'tDeptCodeField',
		fieldLabel: '接收部门代码',
		name:'tDeptCode',
		allowBlank: true,
		emptyText: '接收部门代码...',
		anchor: '90%'
	});
	var tDeptNameField = new Ext.form.TextField({
		id: 'tDeptNameField',
		fieldLabel: '接收部门名称',
		name:'tDeptName',
		allowBlank: true,
		emptyText: '接收部门名称...',
		anchor: '90%'
	});
	var patDeptCodeField = new Ext.form.TextField({
		id: 'pattDeptCodeField',
		fieldLabel: '病人部门代码',
		name:'patDeptCode',
		allowBlank: true,
		emptyText: '病人部门代码...',
		anchor: '90%'
	});
	var patDeptNameField = new Ext.form.TextField({
		id: 'patDeptNameField',
		fieldLabel: '病人部门名称',
		name:'patDeptName',
		allowBlank: true,
		emptyText: '病人部门名称...',
		anchor: '90%'
	});
	//------------------------------------------------------------------------------
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
		fieldLabel:'项目类别',
		store: itemTypeDs,
		valueField:'rowid',
		displayField:'shortcut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		anchor: '90%',
		listWidth:250,
		triggerAction:'all',
		emptyText:'选择数据项类别...',
		allowBlank: true,
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
		fieldLabel:'数据项(内)',
		store: itemsDs,
		valueField:'itemDr',
		displayField:'itemShortCut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		anchor: '90%',
		listWidth:250,
		triggerAction:'all',
		emptyText:'选择数据项(内)...',
		allowBlank: true,
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
		fieldLabel: '单元类别',
		anchor: '90%',
		listWidth : 260,
		allowBlank: true,
		store: unitTypeDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择单元类别...',
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
		fieldLabel: '单元',
		anchor: '90%',
		listWidth : 260,
		allowBlank: true,
		store: unitsDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择单元...',
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
		fieldLabel: '开单部门(内)',
		anchor: '90%',
		listWidth : 260,
		allowBlank: true,
		store: assLocDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择开单部门(内)...',
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
		fieldLabel: '单元类别',
		anchor: '90%',
		listWidth : 260,
		allowBlank: true,
		store: unitFTypeDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择单元类别...',
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
		fieldLabel: '单元',
		anchor: '90%',
		listWidth : 260,
		allowBlank: true,
		store: unitsFDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择单元...',
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
		fieldLabel: '接收部门(内)',
		anchor: '90%',
		listWidth : 260,
		allowBlank: true,
		store: assLocFDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择接收部门(内)...',
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
		fieldLabel: '单元类别',
		anchor: '90%',
		listWidth : 260,
		allowBlank: true,
		store: unitTTypeDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择单元类别...',
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
		fieldLabel: '单元',
		anchor: '90%',
		listWidth : 260,
		allowBlank: true,
		store: unitsTDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择单元...',
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
		fieldLabel: '病人部门(内)',
		anchor: '90%',
		listWidth : 260,
		allowBlank: true,
		store: assLocTDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择病人部门(内)...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	assLocTDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.vouchdatasexe.csp?action=depts&searchField=shortcut&searchValue='+Ext.getCmp('assTLoc').getRawValue()+'&unitsDr='+unitsT.getValue(),method:'GET'});
	});
	var inDate = new Ext.form.DateField({
		id: 'inDate',
		fieldLabel: '收入时间',
		allowBlank: true,
		dateFormat: 'Y-m-d',
		emptyText:'选择收入时间...',
		anchor: '90%'
	});
	//------------------------------------------------------------------------------
	var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 90,
    items: [
			inDate,
			itemCodeField,
			itemNameField,
			fDeptCodeField,
			fDeptNameField,
			tDeptCodeField,
			tDeptNameField,
			patDeptCodeField,
			patDeptNameField,
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
			items
		]        
	});
	


  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '综合搜索',
    width: 400,
    height:600,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
    	text: '查询', 
      handler: function() {
      	// check form value	
		
			itemCode=itemCodeField.getValue();
			itemName=itemNameField.getValue();
			fDeptCode=fDeptCodeField.getValue();
			fDeptName=fDeptNameField.getValue();
			tDeptCode=tDeptCodeField.getValue();
			tDeptName=tDeptNameField.getValue();
			patDeptCode=patDeptCodeField.getValue();
			patDeptName=patDeptNameField.getValue();
			
			itemCode=itemCode.trim();
			itemName=itemName.trim();
			fDeptCode=fDeptCode.trim();
			fDeptName=fDeptName.trim();
			tDeptCode=tDeptCode.trim();
			tDeptName=tDeptName.trim();
			patDeptCode=patDeptCode.trim();
			patDeptName=patDeptName.trim();
			
			feeDate=""
			if (Ext.getCmp('inDate').getValue()!=""){
				feeDate=Ext.getCmp('inDate').getValue().format('Y-m-d');
			}
			fDeptDr = assLoc.getValue();
			tDeptDr = assFLoc.getValue();
			patDeptDr = assTLoc.getValue();
      		itemsDr = items.getValue();
			
      		remark = remarkField.getValue();
			fee=feeField.getValue();
			cost=costField.getValue();
      		dataStore.load({params:{start:0, limit:pagingTool.pageSize,itemCode:itemCode,itemName:itemName,remark:remark,fee:fee,cost:cost,monthDr:monthDr,userDr:userDr,fDeptCode:fDeptCode,fDeptName:fDeptName,tDeptCode:tDeptCode,tDeptName:tDeptName,patDeptCode:patDeptCode,patDeptName:patDeptName,fDeptDr:fDeptDr,feeDate:feeDate,tDeptDr:tDeptDr,patDeptDr:patDeptDr,itemDr:itemsDr}});
    	}
		},
		{
			text: '取消',
			handler: function(){window.close();}
		}]
    });
    window.show();
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
};