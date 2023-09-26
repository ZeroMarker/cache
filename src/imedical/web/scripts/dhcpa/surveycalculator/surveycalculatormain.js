var SurveyScoreTotalUrl = 'dhc.pa.surveyscoreexe.csp';
var data="";
var monthStore="";

var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'dhc.pa.stratagemexe.csp?action=cycle&searchValue='+Ext.getCmp('cycleField').getRawValue()+'&active=Y',method:'POST'})
});

var cycleField = new Ext.form.ComboBox({
	id: 'cycleField',
	fieldLabel:'��������',
	width:180,
	listWidth : 180,
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
	width:180,
	listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
	anchor: '90%',
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
		data=[['0','ȫ��']];
	}
	periodStore.loadData(data);
});
periodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});

var periodField = new Ext.form.ComboBox({
	id: 'periodField',
	fieldLabel: '',
	width:180,
	listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: periodStore,
	anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'��ѡ��...',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 12,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});


var schemDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','parRef','code','name','shortcut'])
});

schemDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'dhc.pa.surveyscoreexe.csp?action=getSchem&searchValue='+Ext.getCmp('schem').getRawValue()+'&active=Y',method:'POST'})
});
var schem = new Ext.form.ComboBox({
	id: 'schem',
	fieldLabel: '��ǰ����',
	width:180,
	listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: schemDs,
	anchor: '90%',
	displayField:'shortcut',
	valueField: 'rowid',
	triggerAction: 'all',
	emptyText:'ѡ��ǰ����...',
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

var autohisoutmedvouchForm = new Ext.form.FormPanel({
		title:'���������',
		region:'north',
		frame:true,
		height:90,
		items:[{
			xtype: 'panel',
			layout:"column",
			height:25,
			hideLabel:true,
			isFormField:true,
			items:[
					{columnWidth:.0,xtype:'displayfield'},
					{columnWidth:.2,xtype:'label',text: '�� �ʾ����---�������� ��'}
				]
			},{
			xtype: 'panel',
			layout:"column",
			hideLabel:true,
			height:50,
			isFormField:true,
			items:[
					{columnWidth:.07,xtype:'label',text: '���:'},
					cycleField,
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.15,xtype:'label',text: '�ڼ�����:'},
					periodTypeField,
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.1,xtype:'label',text: '�ڼ�:'},
					periodField,
					{columnWidth:.06,xtype:'displayfield'},
					{columnWidth:.15,xtype:'label',text:'���˷���:'},
					schem,
					{columnWidth:.06,xtype:'displayfield'},
					{columnWidth:.05,xtype:'button',text: '��������',name: 'bc',tooltip: '��������',handler:function(){kpical()},iconCls: 'remove'}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:50,
				isFormField:true,
				items:[
					{columnWidth:.40,xtype:'displayfield'},
					{columnWidth:.2,xtype:'label',text: '�� ������ʾ�� ����ϸѡ��������� ��'}
				]
			}
		]
});

var cycleDr="";
var periodType="";
var period="";
var schemDr="";

//��ȡ����
getParams=function(){
	cycleDr=Ext.getCmp('cycleField').getValue();
	if(cycleDr==""){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�����!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
	periodType=Ext.getCmp('periodTypeField').getValue();
	if(periodType==""){
		Ext.Msg.show({title:'ע��',msg:'���ڼ�����!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
	period=Ext.getCmp('periodField').getValue();
	if(period==""){
		Ext.Msg.show({title:'ע��',msg:'��ѡ���ڼ�!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
	if(period<10){
		period="0"+""+period;
	}
	schemDr=Ext.getCmp('schem').getValue();
	if(schemDr==""){
		Ext.Msg.show({title:'ע��',msg:'��ѡ��!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
	
}
//ָ����㷽��
kpical = function(){
	getParams();
	//alert(period);
	Ext.Ajax.request({
		url: SurveyScoreTotalUrl+'?action=cal&period='+period+'&cycleDr='+cycleDr+'&periodType='+periodType+'&schemDr='+schemDr,
		waitMsg:'������...',
		failure: function(result, request){
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true'){
					if(jsonData.info=="UnCycle"){
						Ext.Msg.show({title:'��ʾ',msg:'������ȶ�ʧ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						return false;
					}
					if(jsonData.info=="NoperiodType"){
						Ext.Msg.show({title:'��ʾ',msg:'�ڼ����Ͷ�ʧ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						return false;
					}
					if(jsonData.info=="Noperiod"){
						Ext.Msg.show({title:'��ʾ',msg:'�����ڼ䶪ʧ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						return false;
					}
					if(jsonData.info=="NoSchemDr"){
						Ext.Msg.show({title:'��ʾ',msg:'��ǰս�����޷�����¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						return false;
					}
					else{
						Ext.Msg.show({title:'ע��',msg:'����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					}
			}
			else{
						//��ʾ�û���鷵�ص�ָ��
						Ext.Msg.show({title:'��ʾ',msg:'����ִ��ʧ��,�����ټ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					}
		},
		scope: this
	});
}




