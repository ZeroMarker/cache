var userCode = session['LOGON.USERCODE'];
var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'dhc.pa.stratagemexe.csp?action=cycle&searchValue='+Ext.getCmp('cycle').getRawValue()+'&active=Y',method:'POST'})
});

var cycle = new Ext.form.ComboBox({
	id: 'cycle',
	fieldLabel:'年度',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: cycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择年度...',
	name: 'cycle',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var schemDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','parRef','code','name','shortcut','appSysDr','frequency','KPIDr','KPIName','desc','level','appSys','quency','shortCutFreQuency'])
});

schemDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'dhc.pa.disttargetexe.csp?action=schem&searchValue='+Ext.getCmp('schem').getRawValue()+'&active=Y',method:'POST'})
});
var schem = new Ext.form.ComboBox({
	id: 'schem',
	fieldLabel: '当前方案',
	width:180,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: schemDs,
	anchor: '90%',
	displayField:'shortCutFreQuency',
	valueField: 'rowid',
	triggerAction: 'all',
	emptyText:'选择当前方案...',
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

var deptDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['jxUnitDr','jxUnitName','shortCut'])
});

deptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'dhc.pa.disttargetexe.csp?action=dept&schemDr='+Ext.getCmp('schem').getValue(),method:'POST'})
});

var dept = new Ext.form.ComboBox({
	id: 'dept',
	fieldLabel: '科室',
	width:180,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: deptDs,
	anchor: '90%',
	displayField: 'shortCut',
	valueField: 'jxUnitDr',
	triggerAction: 'all',
	emptyText:'选择科室...',
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

var KPIDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

KPIDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'dhc.pa.disttargetexe.csp?action=kpi&schemDr='+Ext.getCmp('schem').getValue()+'&userCode='+userCode,method:'POST'})
});
var KPIField = new Ext.form.ComboBox({
	id: 'KPIField',
	fieldLabel: '',
	width:200,
	listWidth : 400,
	selectOnFocus: true,
	allowBlank: false,
	store: KPIDs,
	anchor: '90%',
	displayField: 'name',
	valueField: 'rowid',
	triggerAction: 'all',
	emptyText:'请选择KPI...',
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

schem.on("select",function(cmb,rec,id ){
    searchFun(cmb.getValue());
});

function searchFun(schemDr){
	//绩效单位
    deptDs.load({params:{start:0, limit:dept.pageSize}});
	//KPI指标
	KPIDs.load({params:{start:0, limit:KPIField.pageSize}});
};

var autohisoutmedvouchForm = new Ext.form.FormPanel({
		title:'★目标分解执行',
		region:'north',
		frame:true,
		height:90,
		items:[{
			xtype: 'panel',
			layout:"column",
			height:50,
			hideLabel:true,
			isFormField:true,
			items:[
					{columnWidth:.45,xtype:'displayfield'},
					{columnWidth:.2,xtype:'label',text: '☆ 目标分解执行 ☆'}
				]
			},{
			xtype: 'panel',
			layout:"column",
			hideLabel:true,
			height:40,
			isFormField:true,
			items:[
					{columnWidth:.07,xtype:'label',text: '年度:'},
					cycle,
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.1,xtype:'label',text: '当前方案:'},
					schem,
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.1,xtype:'label',text: 'KPI 指标:'},
					KPIField
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:50,
				isFormField:true,
				items:[
					{columnWidth:.25,xtype:'displayfield'},
					{columnWidth:.057,xtype:'label',text: '科     室:'},
					dept
					
				]
			},{
			xtype: 'panel',
			layout:"column",
			hideLabel:true,
			height:50,
			isFormField:true,
			items:[
					{columnWidth:.85,xtype:'displayfield'},
					{columnWidth:.05,xtype:'button',text: '指标分解',name: 'bc',tooltip: '指标分解',handler:function(){batchDist();},iconCls: 'remove'}
				]
			},{
			xtype: 'panel',
			layout:"column",
			hideLabel:true,
			height:50,
			isFormField:true,
			items:[
					{columnWidth:.43,xtype:'displayfield'},
					{columnWidth:.2,xtype:'label',text: '※ 请仔细选择各个参数 ※'}
				]
			}
		]
});

batchDist = function(){
	var cycleDr=Ext.getCmp('cycle').getValue();
	if(cycleDr==""){
		Ext.Msg.show({title:'注意',msg:'请选择年度!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
	var schemDr=Ext.getCmp('schem').getValue();
	if(schemDr==""){
		Ext.Msg.show({title:'注意',msg:'请选择方案!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
	var deptDr=Ext.getCmp('dept').getValue();
	var kpiDr=Ext.getCmp('KPIField').getValue();
	
	Ext.Ajax.request({
		url: 'dhc.pa.kpitargetsetexe.csp?action=batchdist&schemDr='+schemDr+'&kpiDr='+kpiDr+'&deptDr='+deptDr+'&cycleDr='+cycleDr,
		waitMsg:'保存中...',
		failure: function(result, request){
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true'){
				Ext.Msg.show({title:'注意',msg:'批量指标分解成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
			}else{
				if(jsonData.info=='false'){
					Ext.Msg.show({title:'提示',msg:'批量指标分解失败,数据被回滚!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='NoCycleDr'){
					Ext.Msg.show({title:'提示',msg:'考核年份丢失!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='NoSchemDr'){
					Ext.Msg.show({title:'提示',msg:'考核方案丢失!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='NoKPIDr'){
					Ext.Msg.show({title:'提示',msg:'考核指标丢失!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='NoDeptDr'){
					Ext.Msg.show({title:'提示',msg:'考核部门丢失!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='NoYearData'){
					Ext.Msg.show({title:'提示',msg:'该指标没有缺少年度目标值!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='UnDistMethodDr'){
					Ext.Msg.show({title:'提示',msg:'该指标缺少指标分解方法!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='NoDatas'){
					Ext.Msg.show({title:'提示',msg:'没有你选择的组合条件的指标被分解!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
			}
		},
		scope: this
	});
}
