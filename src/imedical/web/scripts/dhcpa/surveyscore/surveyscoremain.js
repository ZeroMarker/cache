var surveyScoreUrl = 'dhc.pa.surveyscoreexe.csp';
var scoreUnitDr=session['LOGON.CTLOCID'];
var scoreUserDr=session['LOGON.USERID'];
function format(value){
	//alert(value);
	re=/(\d{1,3})(?=(\d{3})+(?:$|\D))/g;
	value=value.replace(re,"$1,")
	return value?value:'';
};

var data="";
var monthStore="";

var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.paauditexe.csp?action=cycle&str='+Ext.getCmp('cycleField').getRawValue()+'&active=Y',method:'POST'})
});

var cycleField = new Ext.form.ComboBox({
	id: 'cycleField',
	fieldLabel:'���',
	width:100,
	listWidth : 200,
	allowBlank: false,
	store: cycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ�����...',
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
	width:100,
	listWidth : 200,
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
	width:100,
	listWidth : 200,
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
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','parRef','code','name','shortcut','appSysDr','frequency','KPIDr','KPIName','desc','level','appSys','quency','shortcut'])
});

schemDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:surveyScoreUrl+'?action=getSchem',method:'POST'})
});
var schemField = new Ext.form.ComboBox({
	id: 'schemField',
	fieldLabel: '��ǰ����',
	width:180,
	listWidth : 200,
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

var deptDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['jxUnitDr','jxUnitName','shortCut'])
});

deptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.disttargetexe.csp?action=dept&schemDr='+Ext.getCmp('schemField').getValue(),method:'POST'})
});

var deptField = new Ext.form.ComboBox({
	id: 'deptField',
	fieldLabel: '����',
	width:180,
	listWidth : 200,
	selectOnFocus: false,
	allowBlank: false,
	store: deptDs,
	anchor: '90%',
	displayField: 'shortCut',
	valueField: 'jxUnitDr',
	triggerAction: 'all',
	emptyText:'ѡ�����...',
	editable:false,
	pageSize: 10,
	minChars: 1,
	forceSelection: true
});

schemField.on("select",function(cmb,rec,id ){
    searchFun(cmb.getValue());
});

function searchFun(schemDr){
	deptField.setValue("");
	deptField.setRawValue("");
	//��Ч��λ
    deptDs.load({params:{start:0, limit:deptField.pageSize}});
};

var sm = new Ext.grid.CheckboxSelectionModel();

var vouchDetailST = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'dhc.pa.basedataviewexe.csp'}),
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
		}),
	remoteSort: true
});

var autoHisOutMedCm = new Ext.grid.ColumnModel([]);

var autohisoutmedvouchForm = new Ext.form.FormPanel({
	title:'�����ʾ���ϸ',
	region:'north',
	frame:true,
	height:90,
	items:[{
		xtype: 'panel',
		layout:"column",
		hideLabel:true,
		isFormField:true,
		items:[
			{columnWidth:.05,xtype:'label',text: '���:'},
			cycleField,
			{columnWidth:.02,xtype:'displayfield'},
			{columnWidth:.08,xtype:'label',text: '�ڼ����:'},
			periodTypeField,
			{columnWidth:.02,xtype:'displayfield'},
			{columnWidth:.05,xtype:'label',text: '�ڼ�:'},
			periodField,
			{columnWidth:.02,xtype:'displayfield'},
			{columnWidth:.05,xtype:'label',text: '����:'},
			schemField
			]
		},{
			xtype: 'panel',
			layout:"column",
			hideLabel:true,
			isFormField:true,
			items:[
				{columnWidth:.455,xtype:'displayfield'},
				{columnWidth:.0355,xtype:'label',text: '����:'},
				deptField,
				/*
				{columnWidth:.1,xtype:'displayfield'},
				{columnWidth:.06,xtype:'button',text: '��ʼ��',name: 'gb',tooltip: '��ʼ��',handler:function(){init()},iconCls: 'remove'},
				
				{columnWidth:.01,xtype:'displayfield'},
				{columnWidth:.05,xtype:'button',text: '����',name: 'bc',tooltip: '����',handler:function(){save()},iconCls: 'remove'},*/
				{columnWidth:.01,xtype:'displayfield'},
				{columnWidth:.05,xtype:'button',text: '��ѯ',name: 'bc',tooltip: '��ѯ',handler:function(){find()},iconCls: 'remove'},
				/*
				{columnWidth:.01,xtype:'displayfield'},
				{columnWidth:.05,xtype:'button',text: '�޸�',name: 'bc',tooltip: '�޸�',handler:function(){alert("�޸�");},iconCls: 'remove'},
				
				{columnWidth:.01,xtype:'displayfield'},
				{columnWidth:.05,xtype:'button',text: '�ύ',name: 'bc',tooltip: '�ύ',handler:function(){alert("�ύ");},iconCls: 'remove'},*/
				{columnWidth:.01,xtype:'displayfield'},
				{columnWidth:.08,xtype:'button',text: '�����ܷ�',name: 'bc',tooltip: '�����ܷ�',handler:function(){total();},iconCls: 'remove'}
			]
		}
	]
});
find = function(){
    var schemDr=Ext.getCmp('schemField').getValue();
				if((schemDr=="")||(schemDr=="null")){
					Ext.Msg.show({title:'ע��',msg:'��ѡ�񷽰�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
					return false;
				}
				var acceptUnitDr=Ext.getCmp('deptField').getValue();
				if((acceptUnitDr=="")||(acceptUnitDr=="null")){
					Ext.Msg.show({title:'ע��',msg:'��ѡ��������ֿ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
					return false;
				}
				var acceptUnitType="L"; //���ܴ�ֵ�Ԫ���
	var period=Ext.getCmp('periodField').getValue();
	if((period=="")||(period=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ���ڼ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
		return false;
	}
	if(period<10){
		period="0"+""+period;
	}
	var periodType=Ext.getCmp('periodTypeField').getValue();
	if((periodType=="")||(periodType=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ���ڼ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
		return false;
	}
	var schemDr=Ext.getCmp('schemField').getValue();
	if((schemDr=="")||(schemDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�񷽰�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
		return false;
	}
	var cycleDr=Ext.getCmp('cycleField').getValue();
	if((cycleDr=="")||(cycleDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
		return false;
	}
				Ext.Ajax.request({
					url:surveyScoreUrl+'?action=getTitleInfo',
					waitMsg:'...',
					failure: function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						var cmItems = []; 
						var cmConfig = {}; 
						cmItems.push(sm); 
						cmItems.push(new Ext.grid.RowNumberer()); 
						var jsonHeadNum = jsonData.results; 
						var jsonHeadList = jsonData.rows; 
						var tmpDataMapping = [];
						for(var i=0;i<jsonHeadList.length;i++){
							if(jsonHeadList[i].name=="kpiDr"){
								cmConfig = {header:jsonHeadList[i].title,dataIndex:jsonHeadList[i].name,width:75,sortable:true,align:'left',hidden:true};
							}
							else if(jsonHeadList[i].name=="kpiName"){
								cmConfig = {header:jsonHeadList[i].title,dataIndex:jsonHeadList[i].name,width:240,sortable:true,align:'left'};
							}
							else if(jsonHeadList[i].name=="desc"){
								cmConfig = {
									header:jsonHeadList[i].title,
									dataIndex:jsonHeadList[i].name,
									width:300,
									sortable:true,
									align:'center'/*,
									editor:new Ext.form.TextField({
									allowBlank:true
									})*/
									};

							}
							else if(jsonHeadList[i].name=="level"){
								cmConfig = {header:jsonHeadList[i].title,dataIndex:jsonHeadList[i].name,width:100,sortable:true,align:'left',hidden:true};
							}
							else if(jsonHeadList[i].name=="patDr"){
								cmConfig = {header:jsonHeadList[i].title,dataIndex:jsonHeadList[i].name,width:100,sortable:true,align:'left',hidden:true};
							}
							else if(jsonHeadList[i].name=="score"){
								cmConfig = {
									header:jsonHeadList[i].title,
									dataIndex:jsonHeadList[i].name,
									width:100,
									sortable:true,
									align:'right'/*,
									editor:new Ext.form.TextField({
										allowBlank:true
									})*/
								};
							}else{
								cmConfig = {header:jsonHeadList[i].title,dataIndex:jsonHeadList[i].name,width:100,sortable:true,align:'right'};
							}
							cmItems.push(cmConfig); 
							tmpDataMapping.push(jsonHeadList[i].name);
						}
						var tmpColumnModel = new Ext.grid.ColumnModel(cmItems);
						
						tmpStore = new Ext.data.Store({
							proxy:new Ext.data.HttpProxy({url:surveyScoreUrl+'?action=getDataList&schemDr='+schemDr+'&acceptUnitDr='+acceptUnitDr+'&cycleDr='+cycleDr+'&periodType='+periodType+'&period='+period+'&scoreUserDr='+scoreUserDr, method:'GET'}),
							reader:new Ext.data.JsonReader({
								totalProperty:"results",
								root:'rows'
							},tmpDataMapping),
							remoteSort:true
						});
						autohisoutmedvouchMain.reconfigure(tmpStore,tmpColumnModel);
						tStore=tmpStore;
						var ptb = autohisoutmedvouchMain.getTopToolbar();
						if (!ptb || !ptb.bind) {
							ptb = autohisoutmedvouchMain.getBottomToolbar();
						}
						if (ptb && ptb.bind) {
							ptb.unbind(tmpStore);
							if (tmpStore.proxy) {
								ptb.bind(tmpStore);
								ptb.show();
							} else {
								ptb.hide();
							}
							autohisoutmedvouchMain.doLayout();
						}
						tmpStore.load({params:{start:pagingToolbar.cursor, limit:pagingToolbar.pageSize}});
					},
					scope: this
				});
}
var tStore="";
init = function(){
    //alert("hhhh");
	Ext.MessageBox.confirm('��ʾ','ȷʵҪ��ʼ��������?',
		function(btn) {
			if(btn == 'yes'){
				var schemDr=Ext.getCmp('schemField').getValue();
				if((schemDr=="")||(schemDr=="null")){
					Ext.Msg.show({title:'ע��',msg:'��ѡ�񷽰�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
					return false;
				}
				var acceptUnitDr=Ext.getCmp('deptField').getValue();
				if((acceptUnitDr=="")||(acceptUnitDr=="null")){
					Ext.Msg.show({title:'ע��',msg:'��ѡ��������ֿ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
					return false;
				}
				var cycleDr=Ext.getCmp('cycleField').getValue();
				if((cycleDr=="")||(cycleDr=="null")){
					Ext.Msg.show({title:'ע��',msg:'��ѡ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
					return false;
				}
				Ext.Ajax.request({
					url:surveyScoreUrl+'?action=getTitleInfo',
					waitMsg:'...',
					failure: function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						var cmItems = []; 
						var cmConfig = {}; 
						cmItems.push(sm); 
						cmItems.push(new Ext.grid.RowNumberer()); 
						var jsonHeadNum = jsonData.results; 
						var jsonHeadList = jsonData.rows; 
						var tmpDataMapping = [];
						for(var i=0;i<jsonHeadList.length;i++){
							if(jsonHeadList[i].name=="kpiDr"){
								cmConfig = {header:jsonHeadList[i].title,dataIndex:jsonHeadList[i].name,width:75,sortable:true,align:'left',hidden:true};
							}
							else if(jsonHeadList[i].name=="kpiName"){
								cmConfig = {header:jsonHeadList[i].title,dataIndex:jsonHeadList[i].name,width:240,sortable:true,align:'left'};
							}
							else if(jsonHeadList[i].name=="desc"){
								cmConfig = {
									header:jsonHeadList[i].title,
									dataIndex:jsonHeadList[i].name,
									width:600,
									sortable:true,
									align:'center'/*,
									editor:new Ext.form.TextField({
									allowBlank:true
									})*/
									};

							}
							else if(jsonHeadList[i].name=="level"){
								cmConfig = {header:jsonHeadList[i].title,dataIndex:jsonHeadList[i].name,width:100,sortable:true,align:'left',hidden:true};
							}
							else if(jsonHeadList[i].name=="score"){
								cmConfig = {
									header:jsonHeadList[i].title,
									dataIndex:jsonHeadList[i].name,
									width:100,
									sortable:true,
									align:'right'/*,
									editor:new Ext.form.TextField({
										allowBlank:true
									})*/
								};
							}else{
								cmConfig = {header:jsonHeadList[i].title,dataIndex:jsonHeadList[i].name,width:100,sortable:true,align:'right'};
							}
							cmItems.push(cmConfig); 
							tmpDataMapping.push(jsonHeadList[i].name);
						}
						var tmpColumnModel = new Ext.grid.ColumnModel(cmItems);
						
						tmpStore = new Ext.data.Store({
							proxy:new Ext.data.HttpProxy({url:surveyScoreUrl+'?action=getData&schemDr='+schemDr+'&cycleDr='+cycleDr, method:'GET'}),
							reader:new Ext.data.JsonReader({
								totalProperty:"results",
								root:'rows'
							},tmpDataMapping),
							remoteSort:true
						});
						autohisoutmedvouchMain.reconfigure(tmpStore,tmpColumnModel);
						tStore=tmpStore;
						var ptb = autohisoutmedvouchMain.getTopToolbar();
						if (!ptb || !ptb.bind) {
							ptb = autohisoutmedvouchMain.getBottomToolbar();
						}
						if (ptb && ptb.bind) {
							ptb.unbind(tmpStore);
							if (tmpStore.proxy) {
								ptb.bind(tmpStore);
								ptb.show();
							} else {
								ptb.hide();
							}
							autohisoutmedvouchMain.doLayout();
						}
						tmpStore.load({params:{start:pagingToolbar.cursor, limit:pagingToolbar.pageSize}});
					},
					scope: this
				});
			}
		}
	)
}

//======================================================
var tmpStore="";
var pagingToolbar="";
var start=0;
var autohisoutmedvouchMain="";

//���水ť������
save = function(){
	var unitType="L"; //��ֵ�Ԫ���
	var acceptUnitDr=Ext.getCmp('deptField').getValue();
	if((acceptUnitDr=="")||(acceptUnitDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
		return false;
	}
	var acceptUnitType="L"; //���ܴ�ֵ�Ԫ���
	var period=Ext.getCmp('periodField').getValue();
	if((period=="")||(period=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ���ڼ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
		return false;
	}
	if(period<10){
		period="0"+""+period;
	}
	var periodType=Ext.getCmp('periodTypeField').getValue();
	if((periodType=="")||(periodType=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ���ڼ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
		return false;
	}
	var schemDr=Ext.getCmp('schemField').getValue();
	if((schemDr=="")||(schemDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�񷽰�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
		tStore.load();
		return false;
	}
	var cycleDr=Ext.getCmp('cycleField').getValue();
	if((cycleDr=="")||(cycleDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
		return false;
	}
	
	var data="";
	var level=0;
	var score=0;
	var rowObj = autohisoutmedvouchMain.getSelectionModel().getSelections();
	var len = rowObj.length;

	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		for(var i=0;i<len;i++){
			level=rowObj[i].get("level");
			//alert("hh"+level);
			if((level==3)||(level==2)){
				kpiDr=rowObj[i].get("kpiDr");
				desc=rowObj[i].get("desc");
				score=rowObj[i].get("score");
				if(data==""){
					data=kpiDr+"^"+desc+"^"+score;
					//alert("data1="+data);
				}else{
					data=data+"||"+kpiDr+"^"+desc+"^"+score;
				}
			}
		}
	}
	//alert("data="+data);
	Ext.Ajax.request({
		url:surveyScoreUrl+'?action=save&data='+data+'&cycleDr='+cycleDr+'&schemDr='+schemDr+'&periodType='+periodType+'&period='+period+'&acceptUnitDr='+acceptUnitDr+'&scoreUnitDr='+scoreUnitDr+'&scoreUserDr='+scoreUserDr+'&unitType='+unitType+'&acceptUnitType='+acceptUnitType+'&patDr='+scoreUserDr,
		waitMsg:'...',
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success=='true') {
				Ext.Msg.show({title:'ע��',msg:'����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				tStore.load();
			}else{
				Ext.Msg.show({title:'����',msg:'����ʧ�ܣ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}
		},
		scope: this
	});
}
//�����ְܷ�ť
total = function(){
	var unitType="L"; //��ֵ�Ԫ���
	var acceptUnitDr=Ext.getCmp('deptField').getValue();
	var acceptUnitType="L"; //���ܴ�ֵ�Ԫ���
	var period=Ext.getCmp('periodField').getValue();
	if((period=="")||(period=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ���ڼ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
		return false;
	}
	if(period<10){
		period="0"+""+period;
	}
	var periodType=Ext.getCmp('periodTypeField').getValue();
	if((periodType=="")||(periodType=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ���ڼ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
		return false;
	}
	var schemDr=Ext.getCmp('schemField').getValue();
	if((schemDr=="")||(schemDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�񷽰�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
		tStore.load();
		return false;
	}
	var cycleDr=Ext.getCmp('cycleField').getValue();
	if((cycleDr=="")||(cycleDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
		return false;
	}
	
	//alert("data="+data);
	Ext.Ajax.request({
		url:surveyScoreUrl+'?action=total&schemDr='+schemDr+'&periodType='+periodType+'&period='+period+'&acceptUnitDr='+acceptUnitDr+'&scoreUnitDr='+scoreUnitDr+'&scoreUserDr='+scoreUserDr+'&unitType='+unitType+'&acceptUnitType='+acceptUnitType+'&cycleDr='+cycleDr,
		waitMsg:'...',
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success=='true') {
				Ext.Msg.show({title:'ע��',msg:'����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				tStore.load();
			}else{
				Ext.Msg.show({title:'����',msg:'����ʧ�ܣ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}
		},
		scope: this
	});
}
	
autohisoutmedvouchMain = new Ext.grid.EditorGridPanel({
	store:vouchDetailST,
	cm:autoHisOutMedCm,
	region:'center',
	clicksToEdit:1,
	trackMouseOver:true,
	sm:sm,
	stripeRows:true,
	loadMask:true,
	bbar:[
		{
			xtype:'label',
			text:'',
			align:'right',
			width:265
		},{
			xtype:'label',
			text:'',
			align:'right',
			width:265
		}/*,{
			xtype:'label',
			text:'�ʾ��ܷ�:',
			align:'right'
		},
		new Ext.form.TextField({id:'score',width:70,disabled:true}),
		{
			xtype:'label',
			text:'',
			align:'right',
			width:210
		}*/
	]
});

vouchDetailST.load();
