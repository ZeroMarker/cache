Ext.MessageBox.buttonText.yes = 'ȷ��'; 
Ext.MessageBox.buttonText.no = 'ȡ��'; 
Ext.MessageBox.buttonText.ok = 'ȷ��'; 


//������� schemeType
//combo
var schemeTypeValue = new Array(
	'',								//0
	'���Һ��㷽��',					//1
	'��Ա���㷽��'					//2
);

var schemeTypeSt = new Ext.data.ArrayStore({
	fields: ['rowid', 'name'],                
	data: 	[                                 
				['1',schemeTypeValue[1]],            
				['2',schemeTypeValue[2]]	
			]                                 
});                                           

var schemeStateValue = new Array(
	'����',							//0
	'������',						//1
	'��������'						//2
);

var schemeStateSt = new Ext.data.ArrayStore({
	fields: ['rowid', 'name'],                
	data: 	[                                 
				['0',schemeStateValue[0]],            
				['1',schemeStateValue[1]],            
				['2',schemeStateValue[2]]	
			]                                 
});                                           

var schemeDs = new Ext.data.Store({
	proxy: "",
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name','schemeState'])
});

var bonusTypeValue = new Array(
	'',								//0
	'ʵ��������',					//1
	'���㽱����'					//2
);

var bonusTypeSt = new Ext.data.ArrayStore({
	fields: ['rowid', 'name'],                
	data: 	[                                 
				['1',bonusTypeValue[1]],            
				['2',bonusTypeValue[2]]	
			]                                 
});                                           

//������Դ DataSource
//combo
var dataSourceValue = new Array(
	'',								//0
	'¼��',					//1
	'��ʽ'					//2
);

var dataSourceSt = new Ext.data.ArrayStore({
	fields: ['rowid', 'name'],                
	data: 	[                                 
				['1',dataSourceValue[1]],            
				['2',dataSourceValue[2]]	
			]                                 
});                                           



//����ָ����� TargetType
//combo
//rowid^TargetTypeCode^TargetTypeName^IsValid
var targetTypeComboDs = new Ext.data.Store({
	proxy: "",
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','TargetTypeCode','TargetTypeName'])
});
targetTypeComboDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.base10exe.csp?action=targetTypeList',method:'GET'});
});

//������λ CalUnit
//combo
//rowid^CalUnitCode^CalUnitName^IsValid
var calUnitDs = new Ext.data.Store({
	proxy: "",
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','CalUnitCode','CalUnitName'])
});
calUnitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.base10exe.csp?action=calUnitList',method:'GET'});
});

//����ָ�� BonusTarget
//combo
//rowid^BonusTargetCode^BonusTargetName
var bonusTargetDs = new Ext.data.Store({
	proxy: "",
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','BonusTargetCode','BonusTargetName'])
});
bonusTargetDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.base10exe.csp?action=base10list',method:'GET'});
});

//BonusUnitType
//combo
//rowid^name
var bonusUnitTypeDs = new Ext.data.Store({
	proxy: "",
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
});
bonusUnitTypeDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.scheme02exe.csp?action=bonusunittypelist',method:'GET'});
});

var bonusUnitDs = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'dhc.bonus.scheme02exe.csp?action=bonusunitlist&type=0',method:'GET'}),
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
});
//date
var dt = new Date();
dt=dt.format('Y-m-d');

///////////////
var checkAdd=function(formPanel){
	var tmpWrongName=''
	for(i=0;i<formPanel.items.length;i++) {
		//alert(i);
		if(!formPanel.items.items[i].isValid()){
			if(tmpWrongName==''){
				tmpWrongName=formPanel.items.items[i].fieldLabel;
			}else{
				//tmpWrongName=tmpWrongName+','+formPanel.items.items[i].fieldLabel;
			}
		}
	}
	return tmpWrongName
}

var userCode = session['LOGON.USERCODE'];