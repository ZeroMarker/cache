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

var data1=[['1','01月'],['2','02月'],['3','03月'],['4','04月'],['5','05月'],['6','06月'],['7','07月'],['8','08月'],['9','09月'],['10','10月'],['11','11月'],['12','12月']];
var data2=[['1','01季度'],['2','02季度'],['3','03季度'],['4','04季度']];
var data3=[['1','1~6上半年'],['2','7~12下半年']];
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
	fieldLabel:'考核周期',
	width:180,
	listWidth : 200,
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

/* cycleDs.on('load', function(ds, o){
	cycleField.setValue(getCookie(cycleIdCookieName));
	count1=1;
}); */

var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','月'],['Q','季'],['H','半年'],['Y','年']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '期间类型',
	width:180,
	listWidth : 200,
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
	emptyText:'请选择...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 12,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

//加载页面时渲染控件
//setComboValueFromClientOfNotChange(periodTypeField,periodTypeNameCookieName,periodTypeCookieName);

if(getCookie(periodTypeCookieName)=="M"){data=data1;}
if(getCookie(periodTypeCookieName)=="Q"){data=data2;}
if(getCookie(periodTypeCookieName)=="H"){data=data3;}
if(getCookie(periodTypeCookieName)=="Y"){data=data4;}
//加载页面时渲染控件
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
	
//期间类别与方案查询的二级联动控制
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
		Ext.Msg.show({title:'注意',msg:'请选择方案!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
		return false;
	}
	schemName=Ext.getCmp('schem').getRawValue();
	if((schemName=="")||(schemName=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择正确的方案!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
		return false;
	}
	cycleDr=Ext.getCmp('cycleField').getValue();
	if((cycleDr=="")||(cycleDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择年度!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
		return false;
	}
	cycleName=Ext.getCmp('cycleField').getRawValue();
	if((cycleName=="")||(cycleName=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择正确的年度!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
		return false;
	}
	period=Ext.getCmp('periodField').getValue();
	if((period=="")||(period=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择期间!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
		return false;
	}
	periodName=Ext.getCmp('periodField').getRawValue();
	if((periodName=="")||(periodName=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择正确的期间!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
		return false;
	}
	periodType=Ext.getCmp('periodTypeField').getValue();
	if((periodType=="")||(periodType=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择期间类型!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
		return false;
	}
	periodTypeName=Ext.getCmp('periodTypeField').getRawValue();
	if((periodTypeName=="")||(periodTypeName=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择正确的期间类型!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
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
		//用户已经选择参数
		var array=dataStr.split("^");
		cycleDr=array[1];
		period=array[3];
		var schemDr=array[5];
		var periodType=array[7];
		//查询
		queryData(cycleDr,period,schemDr);
		
		var periodTypeName=array[6];
		newDataStr=cycleIdCookieName+"^"+cycleDr+"!"+schemIdCookieName+"^"+schemDr+"!"+periodCookieName+"^"+period+"!"+periodTypeCookieName+"^"+periodType+"!"+periodTypeNameCookieName+"^"+periodTypeName;
	}
	//批量设置cookie
	//setBathCookieValue(newDataStr);
	//批量删除cookie
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
	titleName="指标明细查询与管理";
	kpiTreeLoader.load(kpiTreeRoot,function(){
		kpiTreeRoot.expand();
		kpiTree.setTitle(titleName);
	});
}
//==========================================================================


var autohisoutmedvouchForm = new Ext.form.FormPanel({
	title:'★计算结果查询',
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
				{columnWidth:.07,xtype:'label',text: '年度:'},
				cycleField,
				{columnWidth:.02,xtype:'displayfield'},
				{columnWidth:.1,xtype:'label',text: '期间类型:'},
				periodTypeField,
				{columnWidth:.02,xtype:'displayfield'},
				{columnWidth:.05,xtype:'label',text: '期间:'},
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
				{columnWidth:.07,xtype:'label',text:'考核方案:'},
				schem,
				{columnWidth:.3,xtype:'displayfield'},
				{columnWidth:.05,xtype:'button',text: '查询',name: 'bc',tooltip: '查询',handler:function(){query()},iconCls: 'add'}
			]
		}
	]
});

var deptColObj=[
	{	
		header:'科室',
		align: 'right',
		width:250,
		dataIndex:'name'
	}
];

var deptSetUrl = 'dhc.pa.findresultexe.csp';
var count=1;
var url2="";

//树形结构导入器
var deptTreeLoader = new Ext.tree.TreeLoader({
	dataUrl:'../scripts/ext2/cost/report/test1.csp',
	uiProviders:{'col': Ext.tree.ColumnNodeUI}
});

//加载前事件
deptTreeLoader.on('beforeload', function(deptTreeLoader,node){
	
		var url=deptSetUrl+'?action=depttreelist&parent='+node.id+'&schemDr='+Ext.getCmp('schem').getValue();
		deptTreeLoader.dataUrl=url;
	
	/* if(count==2){
		deptTreeLoader.dataUrl=url2;
		count=3;
	} */
});
//树形结构的根
var deptTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'deptRoo',
	text:"科室选择",
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
    title:"科室结构选择",
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
		header:'指标名称',
		align: 'right',
		width:250,
		dataIndex:'KPIName'
	},{
		header:'指标代码',
		width:125,
		dataIndex:'KPICode'
	},{
		header:'计量单位',
		align:'right',
		width:70,
		dataIndex:'calUnitName'
	},{
		header:'目标值',
		align: 'right',
		width:70,
		renderer:format,
		dataIndex:'targetValue'
	},{
		header:'指标值',
		align: 'right',
		width:70,
		renderer:format,
		dataIndex:'actValue'
	},{
		header:'分数',
		align: 'right',
		width:70,
		renderer:format,
		dataIndex:'score'
	},{
		header:'考核方法',
		align: 'right',
		width:70,
		dataIndex:'methodName'
	},{
		header:'评测目的',
		align: 'right',
		width:70,
		dataIndex:'target'
	},{
		header:'权重',
		align: 'right',
		width:70,
		renderer:format,
		dataIndex:'rate'
	}
];

//树形结构导入器
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
//加载前事件
kpiTreeLoader.on('beforeload', function(kpiTreeLoader,node){
	if(type!=""){
		var url3=kpiSetUrl+'?action=kpitreelist&parent='+node.id+'&schemDr='+SchemId+'&deptDr='+deptDr+'&cycleDr='+cycleDr+'&period='+period;
		kpiTreeLoader.dataUrl=url3;
	}
});

//分开执行
/*
kpiTreeLoader.on('load', function(kpiTreeLoader,node){
	if(type1==1){
		//total();
		//alert(total());
	}
});
*/

//汇总函数
/*
total=function(){
	var totalScore=0;
	var score=0;
	
	//获取树
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


//加法函数
add = function(a,b){
	return a-(-b);
}

/*
//获取根下所有子节点
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

//获取单个节点的子节点
findChildNode=function(node){
	return node.childNodes;
}

//树形结构的根
var kpiTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
	text:"指标明细",
	expanded:true
});

var titleName="指标明细查询与管理";
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
			text:'分数总计:',
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

//查询按钮
/*
query = function(){
	var schemDr=Ext.getCmp('schem').getValue();
	if(schemDr==""){
		Ext.Msg.show({title:'注意',msg:'请选择方案!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
	titleName="指标明细查询与管理";
	kpiTreeLoader.load(kpiTreeRoot,function(){
		kpiTreeRoot.expand();
		kpiTree.setTitle(titleName);
	});
}
*/
//点击节点事件
function nodeClicked(node){
	if(node.attributes.isEnd=="Y"){
		var schemName=Ext.getCmp('schem').getRawValue();
		var deptName=node.attributes.name;
		var cycleName=Ext.getCmp('cycleField').getRawValue();
		var periodName=Ext.getCmp('periodField').getRawValue();
		if(periodName=="00"){periodName="";}
		titleName=schemName+"-"+deptName+"-"+cycleName+periodName+"考核分";
		kpiTree.setTitle(titleName);
		type=1;
		//准备参数
		deptDr=node.attributes.id;
		if(deptDr==""){
			Ext.Msg.show({title:'注意',msg:'绩效单元为空!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
			return false;
		}
		SchemId=Ext.getCmp('schem').getValue();
		if((SchemId=="")||(SchemId=="null")){
			Ext.Msg.show({title:'注意',msg:'请选择方案!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
			return false;
		}
		cycleDr=Ext.getCmp('cycleField').getValue();
		if((cycleDr=="")||(cycleDr=="null")){
			Ext.Msg.show({title:'注意',msg:'请选择考核年度!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
			return false;
		}
		period=Ext.getCmp('periodField').getValue();
		if((period=="")||(period=="null")){
			Ext.Msg.show({title:'注意',msg:'请选择考核期间!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
			return false;
		}
		
		kpiTreeLoader.load(kpiTreeRoot,function(){
			kpiTreeRoot.expand();
		});
		
		type1=1;
		
		Ext.Ajax.request({
			url:deptSetUrl+'?action=total&deptDr='+deptDr+'&cycleDr='+cycleDr+'&period='+period+'&schemDr='+SchemId,
			waitMsg:'删除中...',
			failure: function(result, request){
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
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
		Ext.Msg.show({title:'注意',msg:'非叶子节点,不能查看!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
		return false;
	}
}