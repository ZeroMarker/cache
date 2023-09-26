function format(value){
	//alert(value);
	re=/(\d{1,3})(?=(\d{3})+(?:$|\D))/g;
	value=value.replace(re,"$1,")
	return value?value:'';
};

var userCode = session['LOGON.USERCODE'];



var cycleIdCookieName="cycleDr";
var periodTypeNameCookieName="periodTypeName";
var periodTypeCookieName="periodType";
var periodCookieName="period";
var schemIdCookieName="schemDr";
var nameStr=cycleIdCookieName+"^"+periodTypeNameCookieName+"^"+periodTypeCookieName+"^"+periodCookieName+"^"+schemIdCookieName;
var dataStr="";

var data1=[['1','01��'],['2','02��'],['3','03��'],['4','04��'],['5','05��'],['6','06��'],['7','07��'],['8','08��'],['9','09��'],['10','10��'],['11','11��'],['12','12��']];
var data2=[['1','01����'],['2','02����'],['3','03����'],['4','04����']];
var data3=[['1','1~6�ϰ���'],['2','7~12�°���']];
var data4=[['0','00']];

var count1=0;
var count2=0;

var data="";
var monthStore="";

var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.paauditexe.csp?action=cycle&str='+encodeURIComponent(Ext.getCmp('cycleField').getRawValue())+'&active=Y',method:'POST'})
	
});

var cycleField = new Ext.form.ComboBox({
	id: 'cycleField',
	fieldLabel:'��������',
	width:180,
	listWidth : 200,
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

/* cycleDs.on('load', function(ds, o){
	cycleField.setValue(getCookie(cycleIdCookieName));
	count1=1;
}); */

var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','��'],['Q','��'],['H','����'],['Y','��']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '�ڼ�����',
	width:180,
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
	if(cmb.getValue()=="M"){data=data1;}
	if(cmb.getValue()=="Q"){data=data2;}
	if(cmb.getValue()=="H"){data=data3;}
	if(cmb.getValue()=="Y"){data=data4;}
	periodStore.loadData(data);
	searchFun(cmb.getValue());
});

periodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});

var periodField = new Ext.form.ComboBox({
	id: 'periodField',
	fieldLabel: '',
	width:180,
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

//����ҳ��ʱ��Ⱦ�ؼ�
//setComboValueFromClientOfNotChange(periodTypeField,periodTypeNameCookieName,periodTypeCookieName);

if(getCookie(periodTypeCookieName)=="M"){data=data1;}
if(getCookie(periodTypeCookieName)=="Q"){data=data2;}
if(getCookie(periodTypeCookieName)=="H"){data=data3;}
if(getCookie(periodTypeCookieName)=="Y"){data=data4;}
//����ҳ��ʱ��Ⱦ�ؼ�
setComboValueFromClientOfChange(periodStore,data,periodField,periodCookieName);

var schemDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','shortCutFreQuency'])
});

schemDs.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.paauditexe.csp?action=schem2&str='+encodeURIComponent(Ext.getCmp('schem').getRawValue())+'&active=Y'+'&periodType='+Ext.getCmp('periodTypeField').getValue()+'&userCode='+userCode,method:'POST'})
	
});
var schem = new Ext.form.ComboBox({
	id: 'schem',
	fieldLabel: '��ǰ����',
	width:180,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: schemDs,
	anchor: '90%',
	displayField:'shortCutFreQuency',
	valueField: 'rowid',
	triggerAction: 'all',
	emptyText:'ѡ��ǰ����...',
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});
	
//�ڼ�����뷽����ѯ�Ķ�����������
function searchFun(periodType){
	schem.setRawValue("");
	periodField.setRawValue("");
	schemDs.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.paauditexe.csp?action=schem2&active=Y'+'&periodType='+Ext.getCmp('periodTypeField').getValue()+'&str='+encodeURIComponent(Ext.getCmp('schem').getRawValue()),method:'POST'});
	schemDs.load({params:{start:0, limit:schem.pageSize}});
	/* if(getCookie(periodTypeCookieName)==periodType){
		count2=3;
		setComboValueFromServer(schem,schemIdCookieName);
		setComboActValueFromClientOfChange(periodField,periodCookieName);
	}else{
		schemDs.on('load', function(ds, o){
			schem.setValue("");
			count2=2;
		});
	} */
};

//setAndLoadComboValueFromServer(schemDs,schem,schemIdCookieName);

var getParam=function(){
	var dataStr="";
	var schemDr=Ext.getCmp('schem').getValue();
	if((schemDr=="")||(schemDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�񷽰�!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
		return false;
	}
	schemName=Ext.getCmp('schem').getRawValue();
	if((schemName=="")||(schemName=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����ȷ�ķ���!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
		return false;
	}
	cycleDr=Ext.getCmp('cycleField').getValue();
	if((cycleDr=="")||(cycleDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�����!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
		return false;
	}
	cycleName=Ext.getCmp('cycleField').getRawValue();
	if((cycleName=="")||(cycleName=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����ȷ�����!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
		return false;
	}
	period=Ext.getCmp('periodField').getValue();
	if((period=="")||(period=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ���ڼ�!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
		return false;
	}
	periodName=Ext.getCmp('periodField').getRawValue();
	if((periodName=="")||(periodName=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����ȷ���ڼ�!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
		return false;
	}
	periodType=Ext.getCmp('periodTypeField').getValue();
	if((periodType=="")||(periodType=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ���ڼ�����!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
		return false;
	}
	periodTypeName=Ext.getCmp('periodTypeField').getRawValue();
	if((periodTypeName=="")||(periodTypeName=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����ȷ���ڼ�����!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
		return false;
	}
	
	if((schemDr!="")&&(cycleDr!="")&&(period!="")&&(periodType!="")&&(schemName!="")&&(cycleName!="")&&(periodName!="")&&(periodTypeName!="")){
		dataStr=cycleName+"^"+cycleDr+"^"+periodName+"^"+period+"^"+schemName+"^"+schemDr+"^"+periodTypeName+"^"+periodType;
	}
	
	return dataStr;
}
//==========================================================================
query = function(){
	var dataStr = getParam();
	var newDataStr="";
	if(dataStr!=""){
		//�û��Ѿ�ѡ�����
		var array=dataStr.split("^");
		cycleDr=array[1];
		period=array[3];
		var schemDr=array[5];
		var periodType=array[7];
		//��ѯ
		queryData(cycleDr,period,schemDr);
		
		var periodTypeName=array[6];
		newDataStr=cycleIdCookieName+"^"+cycleDr+"!"+schemIdCookieName+"^"+schemDr+"!"+periodCookieName+"^"+period+"!"+periodTypeCookieName+"^"+periodType+"!"+periodTypeNameCookieName+"^"+periodTypeName;
	}
	//��������cookie
	//setBathCookieValue(newDataStr);
	//����ɾ��cookie
	//delBathCookieValue(nameStr);
}

queryData = function(cycleDr,period,schemDr){
	count=2;
	url2=deptSetUrl+'?action=treeroolist&schemDr='+schemDr+'&cycleDr='+cycleDr+'&period='+period;
	
	deptTreeLoader.load(deptTreeRoot,function(){
		deptTreeRoot.expand();
	});
	
	type=1;
	deptDr="";
	SchemId="";
	cycleDr="";
	period="";
	titleName="ָ����ϸ��ѯ�����";
	kpiTreeLoader.load(kpiTreeRoot,function(){
		kpiTreeRoot.expand();
		kpiTree.setTitle(titleName);
	});
}
//==========================================================================


var autohisoutmedvouchForm = new Ext.form.FormPanel({
	title:'���������ѯ',
	region:'north',
	frame:true,
	height:90,
	items:[
		{
			xtype: 'panel',
			layout:"column",
			hideLabel:true,
			height:25,
			isFormField:true,
			items:[
				{columnWidth:.07,xtype:'label',text: '���:'},
				cycleField,
				{columnWidth:.02,xtype:'displayfield'},
				{columnWidth:.1,xtype:'label',text: '�ڼ�����:'},
				periodTypeField,
				{columnWidth:.02,xtype:'displayfield'},
				{columnWidth:.05,xtype:'label',text: '�ڼ�:'},
				periodField
			]
		},{
			xtype: 'panel',
			layout:"column",
			hideLabel:true,
			height:25,
			isFormField:true,
			items:[
				{columnWidth:.468,xtype:'displayfield'},
				{columnWidth:.07,xtype:'label',text:'���˷���:'},
				schem,
				{columnWidth:.3,xtype:'displayfield'},
				{columnWidth:.05,xtype:'button',text: '��ѯ',name: 'bc',tooltip: '��ѯ',handler:function(){query()},iconCls: 'add'}
			]
		}
	]
});

var deptColObj=[
	{	
		header:'����',
		align: 'right',
		width:250,
		dataIndex:'name'
	}
];

var deptSetUrl = 'dhc.pa.findresultexe.csp';
var count=1;
var url2="";

//���νṹ������
var deptTreeLoader = new Ext.tree.TreeLoader({
	dataUrl:'../scripts/ext2/cost/report/test1.csp',
	uiProviders:{'col': Ext.tree.ColumnNodeUI}
});

//����ǰ�¼�
deptTreeLoader.on('beforeload', function(deptTreeLoader,node){
	
		var url=deptSetUrl+'?action=depttreelist&parent='+node.id+'&schemDr='+Ext.getCmp('schem').getValue();
		deptTreeLoader.dataUrl=url;
	
	/* if(count==2){
		deptTreeLoader.dataUrl=url2;
		count=3;
	} */
});
//���νṹ�ĸ�
var deptTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'deptRoo',
	text:"����ѡ��",
	expanded:true
});

var deptTree = new Ext.tree.ColumnTree({
	id:'deptTree',
	width:250,
	region:'west',
	split:true,
	autoScroll:true,
	collapsible: true,
	containerScroll: true,
	rootVisible: true,
    title:"���ҽṹѡ��",
	columns:deptColObj,
    loader:deptTreeLoader,
	onlyLeafCheckable:true,
    root:deptTreeRoot,
	listeners:{click:{fn:nodeClicked}}
});

//==================================================
var kpiSetUrl = 'dhc.pa.findresultexe.csp';

var detailColObj=[
	{	
		header:'ָ������',
		align: 'right',
		width:250,
		dataIndex:'KPIName'
	},{
		header:'ָ�����',
		width:125,
		dataIndex:'KPICode'
	},{
		header:'������λ',
		align:'right',
		width:70,
		dataIndex:'calUnitName'
	},{
		header:'Ŀ��ֵ',
		align: 'right',
		width:70,
		renderer:format,
		dataIndex:'targetValue'
	},{
		header:'ָ��ֵ',
		align: 'right',
		width:70,
		renderer:format,
		dataIndex:'actValue'
	},{
		header:'����',
		align: 'right',
		width:70,
		renderer:format,
		dataIndex:'score'
	},{
		header:'���˷���',
		align: 'right',
		width:70,
		dataIndex:'methodName'
	},{
		header:'����Ŀ��',
		align: 'right',
		width:70,
		dataIndex:'target'
	},{
		header:'Ȩ��',
		align: 'right',
		width:70,
		renderer:format,
		dataIndex:'rate'
	}
];

//���νṹ������
var kpiTreeLoader = new Ext.tree.TreeLoader({
	dataUrl:'../scripts/ext2/cost/report/test1.csp',
	uiProviders:{'col': Ext.tree.ColumnNodeUI}
});

var type1="";
var type="";
var deptDr="";
var SchemId="";
var cycleDr="";
var period="";
//����ǰ�¼�
kpiTreeLoader.on('beforeload', function(kpiTreeLoader,node){
	if(type!=""){
		var url3=kpiSetUrl+'?action=kpitreelist&parent='+node.id+'&schemDr='+SchemId+'&deptDr='+deptDr+'&cycleDr='+cycleDr+'&period='+period;
		kpiTreeLoader.dataUrl=url3;
	}
});

//�ֿ�ִ��
/*
kpiTreeLoader.on('load', function(kpiTreeLoader,node){
	if(type1==1){
		//total();
		//alert(total());
	}
});
*/

//���ܺ���
/*
total=function(){
	var totalScore=0;
	var score=0;
	
	//��ȡ��
	var rootNode=Ext.getCmp('kpiTree').getRootNode();
	var array=new Array();
	array=findChildNode(rootNode);
	for(var k=0;k<array.length;k++){
		var newNode=array[k];
		if(newNode.attributes.id){
			score=newNode.attributes.score*newNode.attributes.rate;
			totalScore=add(totalScore,score);
		}
	}
	Ext.getCmp('score').setValue(totalScore);
		
	//alert(totalScore);
}
*/


//�ӷ�����
add = function(a,b){
	return a-(-b);
}

/*
//��ȡ���������ӽڵ�
findAllNode=function(node,newArr){
	var arr=new Array();
	if(node.hasChildNodes()){
		arr=findNode(node);
		for(var i=0;i<arr.length;i++){
			newArr.push(arr[i]);
			if(arr[i].hasChildNodes()){
				newArr = findAllNode(arr[i],newArr);
			}
		}
	}
	return newArr;
};
*/

//��ȡ�����ڵ���ӽڵ�
findChildNode=function(node){
	return node.childNodes;
}

//���νṹ�ĸ�
var kpiTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
	text:"ָ����ϸ",
	expanded:true
});

var titleName="ָ����ϸ��ѯ�����";
var kpiTree = new Ext.tree.ColumnTree({
	id:'kpiTree',
	width:300,
	region:'center',
	split:true,
	autoScroll:true,
	collapsible: true,
	containerScroll: true,
	rootVisible: true,
    title:titleName,
	columns:detailColObj,
    loader:kpiTreeLoader,
    root:kpiTreeRoot,
	bbar:[
		{
			xtype:'label',
			text:'',
			align:'right',
			width:265
		},{
			xtype:'label',
			text:'�����ܼ�:',
			align:'right'
		},{
			xtype:'label',
			text:'',
			align:'right',
			width:265
		},
		new Ext.form.TextField({id:'score',width:70,disabled:true}),
		{
			xtype:'label',
			text:'',
			align:'right',
			width:210
		}
	]
});

//��ѯ��ť
/*
query = function(){
	var schemDr=Ext.getCmp('schem').getValue();
	if(schemDr==""){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�񷽰�!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
	count=2;
	url2=deptSetUrl+'?action=treeroolist&schemDr='+schemDr;
	deptTreeLoader.load(deptTreeRoot,function(){
		deptTreeRoot.expand();
	});
	
	type=1;
	deptDr="";
	SchemId="";
	cycleDr="";
	period="";
	titleName="ָ����ϸ��ѯ�����";
	kpiTreeLoader.load(kpiTreeRoot,function(){
		kpiTreeRoot.expand();
		kpiTree.setTitle(titleName);
	});
}
*/
//����ڵ��¼�
function nodeClicked(node){
	if(node.attributes.isEnd=="Y"){
		var schemName=Ext.getCmp('schem').getRawValue();
		var deptName=node.attributes.name;
		var cycleName=Ext.getCmp('cycleField').getRawValue();
		var periodName=Ext.getCmp('periodField').getRawValue();
		if(periodName=="00"){periodName="";}
		titleName=schemName+"-"+deptName+"-"+cycleName+periodName+"���˷�";
		kpiTree.setTitle(titleName);
		type=1;
		//׼������
		deptDr=node.attributes.id;
		if(deptDr==""){
			Ext.Msg.show({title:'ע��',msg:'��Ч��ԪΪ��!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
			return false;
		}
		SchemId=Ext.getCmp('schem').getValue();
		if((SchemId=="")||(SchemId=="null")){
			Ext.Msg.show({title:'ע��',msg:'��ѡ�񷽰�!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
			return false;
		}
		cycleDr=Ext.getCmp('cycleField').getValue();
		if((cycleDr=="")||(cycleDr=="null")){
			Ext.Msg.show({title:'ע��',msg:'��ѡ�񿼺����!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
			return false;
		}
		period=Ext.getCmp('periodField').getValue();
		if((period=="")||(period=="null")){
			Ext.Msg.show({title:'ע��',msg:'��ѡ�񿼺��ڼ�!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
			return false;
		}
		
		kpiTreeLoader.load(kpiTreeRoot,function(){
			kpiTreeRoot.expand();
		});
		
		type1=1;
		
		Ext.Ajax.request({
			url:deptSetUrl+'?action=total&deptDr='+deptDr+'&cycleDr='+cycleDr+'&period='+period+'&schemDr='+SchemId,
			waitMsg:'ɾ����...',
			failure: function(result, request){
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.getCmp('score').setValue(jsonData.info);
				}
			},
			scope: this
		});
	}else{
		Ext.Msg.show({title:'ע��',msg:'��Ҷ�ӽڵ�,���ܲ鿴!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
		return false;
	}
}