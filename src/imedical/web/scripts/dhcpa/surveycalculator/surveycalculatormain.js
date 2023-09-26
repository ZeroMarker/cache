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
	fieldLabel:'考核周期',
	width:180,
	listWidth : 180,
	allowBlank: false,
	store: cycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择考核周期...',
	name: 'cycleField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','月'],['Q','季'],['H','半年'],['Y','年']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '期间类型',
	width:180,
	listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
	anchor: '90%',
	value:'', //默认值
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'选择期间类型...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

periodTypeField.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){
		data=[['1','01月'],['2','02月'],['3','03月'],['4','04月'],['5','05月'],['6','06月'],['7','07月'],['8','08月'],['9','09月'],['10','10月'],['11','11月'],['12','12月']];
	}
	if(cmb.getValue()=="Q"){
		data=[['1','01季度'],['2','02季度'],['3','03季度'],['4','04季度']];
	}
	if(cmb.getValue()=="H"){
		data=[['1','1~6上半年'],['2','7~12下半年']];
	}
	if(cmb.getValue()=="Y"){
		data=[['0','全年']];
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
	emptyText:'请选择...',
	mode: 'local', //本地模式
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
	fieldLabel: '当前方案',
	width:180,
	listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: schemDs,
	anchor: '90%',
	displayField:'shortcut',
	valueField: 'rowid',
	triggerAction: 'all',
	emptyText:'选择当前方案...',
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

var autohisoutmedvouchForm = new Ext.form.FormPanel({
		title:'★分数计算',
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
					{columnWidth:.2,xtype:'label',text: '☆ 问卷调查---分数计算 ☆'}
				]
			},{
			xtype: 'panel',
			layout:"column",
			hideLabel:true,
			height:50,
			isFormField:true,
			items:[
					{columnWidth:.07,xtype:'label',text: '年度:'},
					cycleField,
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.15,xtype:'label',text: '期间类型:'},
					periodTypeField,
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.1,xtype:'label',text: '期间:'},
					periodField,
					{columnWidth:.06,xtype:'displayfield'},
					{columnWidth:.15,xtype:'label',text:'考核方案:'},
					schem,
					{columnWidth:.06,xtype:'displayfield'},
					{columnWidth:.05,xtype:'button',text: '分数计算',name: 'bc',tooltip: '分数计算',handler:function(){kpical()},iconCls: 'remove'}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:50,
				isFormField:true,
				items:[
					{columnWidth:.40,xtype:'displayfield'},
					{columnWidth:.2,xtype:'label',text: '※ 友情提示： 请仔细选择各个参数 ※'}
				]
			}
		]
});

var cycleDr="";
var periodType="";
var period="";
var schemDr="";

//获取参数
getParams=function(){
	cycleDr=Ext.getCmp('cycleField').getValue();
	if(cycleDr==""){
		Ext.Msg.show({title:'注意',msg:'请选择年度!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
	periodType=Ext.getCmp('periodTypeField').getValue();
	if(periodType==""){
		Ext.Msg.show({title:'注意',msg:'请期间类型!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
	period=Ext.getCmp('periodField').getValue();
	if(period==""){
		Ext.Msg.show({title:'注意',msg:'请选择期间!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
	if(period<10){
		period="0"+""+period;
	}
	schemDr=Ext.getCmp('schem').getValue();
	if(schemDr==""){
		Ext.Msg.show({title:'注意',msg:'请选择!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
	
}
//指标计算方法
kpical = function(){
	getParams();
	//alert(period);
	Ext.Ajax.request({
		url: SurveyScoreTotalUrl+'?action=cal&period='+period+'&cycleDr='+cycleDr+'&periodType='+periodType+'&schemDr='+schemDr,
		waitMsg:'保存中...',
		failure: function(result, request){
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true'){
					if(jsonData.info=="UnCycle"){
						Ext.Msg.show({title:'提示',msg:'考核年度丢失!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						return false;
					}
					if(jsonData.info=="NoperiodType"){
						Ext.Msg.show({title:'提示',msg:'期间类型丢失!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						return false;
					}
					if(jsonData.info=="Noperiod"){
						Ext.Msg.show({title:'提示',msg:'考核期间丢失!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						return false;
					}
					if(jsonData.info=="NoSchemDr"){
						Ext.Msg.show({title:'提示',msg:'当前战略下无方案记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						return false;
					}
					else{
						Ext.Msg.show({title:'注意',msg:'计算成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					}
			}
			else{
						//提示用户检查返回的指标
						Ext.Msg.show({title:'提示',msg:'计算执行失败,请检查再计算!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					}
		},
		scope: this
	});
}




