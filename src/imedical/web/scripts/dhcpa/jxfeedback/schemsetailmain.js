/**
  *name:schemsetailmain
  *author:wang ying
  *Date:2010-9-21
 */
//================去掉字符串空格==============================
var jxfeedbackURL ='dhc.pa.jxfeedbackexe.csp';
var UserCode = session['LOGON.USERCODE'];
var userID = session['LOGON.USERID'];
function trim(str){
	var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}
function format(value){
	//alert(value);
	re=/(\d{1,3})(?=(\d{3})+(?:$|\D))/g;
	value=value.replace(re,"$1,")
	return value?value:'';
};
//============================================================

//================定义部分全局变量============================
//添加或者修改标志
var type="";
//表达式(控件)
var expreField="";
//表达式描述(控件)
var expreDescField="";
//表达式描述(变量)
var expreDesc="";
//用于表达式的存储
var globalStr3="";
//用于表达式的显示
var globalStr="";
//用于表达式的退格处理
var globalStr2="";
//============================================================

//================定义获取要操作节点的函数====================
//获取要操作的节点
var getNode = function(){
	return detailsetReport.getSelectionModel().getSelectedNode(); 
};
//============================================================

//================定义工具栏以及添加、修改、删除按钮==========
//添加按钮
var adddetailButton=new Ext.Toolbar.Button({
	text:'添加',
	tooltip:'添加',
	iconCls: 'add',
	handler:function(){
		addFun(getNode());
	}
});
//修改按钮
var updatedetailButton=new Ext.Toolbar.Button({
	text:'编写反馈信息',
	tooltip:'提交编写反馈信息',
	iconCls: 'add',
	handler:function(){
		updateSetDetailFun(detailsetReport.getSelectionModel().getSelectedNode());
	}
});
//删除按钮
var deldetailButton=new Ext.Toolbar.Button({
	text:'取消提交',
	tooltip:'取消提交',
	iconCls: 'remove',
	handler:function(){
		delFun(detailsetReport.getSelectionModel().getSelectedNode());
	}
});
//计算按钮
var calculatorButton=new Ext.Toolbar.Button({
	text:'计算',
	tooltip:'计算',
	iconCls: 'add',
	handler:function(){
		alert(MVEL.eval("1+2*3*(5+6)"));
	}
});

var StratagemTabUrl = '../csp/dhc.pa.stratagemexe.csp';
var userCode = session['LOGON.USERCODE'];
var data="";
var monthStore="";
function formatDate(value){
	return value?value.dateFormat('Y-m-d'):'';
};

//考核周期comboBox
var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:StratagemTabUrl+'?action=cycle&searchValue='+Ext.getCmp('cycleField').getRawValue()+'&active=Y',method:'POST'})
});

var cycleField = new Ext.form.ComboBox({
	id: 'cycleField',
	fieldLabel: '考核周期',
	width:100,
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

//期间类型comboBox
var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','月'],['Q','季'],['H','半年'],['Y','年']]
});

var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '期间类型',
	width:90,
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

//与考核类型对应的考核期间comboBox
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
		data=[['0','00']];
	}
	periodStore.loadData(data);
	schemeDs.proxy=new Ext.data.HttpProxy({url:'dhc.pa.schemlistexe.csp?action=list&cycle='+Ext.getCmp('cycleField').getValue()});
	schemeDs.load({params:{start:0, limit:schemeField.pageSize}});
});
periodStore = new Ext.data.SimpleStore({
     fields:['key','keyValue']
});

var periodField = new Ext.form.ComboBox({
	id: 'periodField',
	fieldLabel: '',
	width:90,
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

var schemeDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

schemeDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.schemlistexe.csp?action=list&start=0&limit=25&cycle='+Ext.getCmp('cycleField').getValue()+'&period='+encodeURIComponent(schemeField.getValue())});
});

var schemeField = new Ext.form.ComboBox({
	id: 'schemeField',
	fieldLabel: '绩效方案',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: schemeDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择绩效方案...',
	name: 'schemeField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
var deptDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','jxUnitDr','jxUnitName','shortCut'])
});

deptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:jxfeedbackURL+'?action=unit&schem='+Ext.getCmp('schemeField').getValue()+"&userID="+userID,method:'POST'})
});

var deptField = new Ext.form.ComboBox({
	id: 'deptField',
	fieldLabel: '科室',
	width:100,
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
schemeField.on("select",function(cmb,rec,id ){
    searchFun(cmb.getValue());
});

function searchFun(schemDr,userID){
	//绩效单位
    deptDs.load({params:{start:0, limit:deptField.pageSize}});
	//KPI指标
	//KPIDs.load({params:{start:0, limit:KPIField.pageSize}});
};
var method = new Ext.form.ComboBox({
			id:'method',
			fieldLabel: '考核频率',
			editable:false,
			valueField: 'rowid',
			displayField:'name',
			mode:'local',
			triggerAction:'all',
			store:new Ext.data.SimpleStore({
				fields:['rowid','name'],
				data:[["I",'区间法'],["C",'比较法'],["D",'扣分法'],["A",'加分法'],["M",'目标参照法']]
			})			
		});
//工具栏
var textfile = [
	{
	xtype:'label',
	text:'',
	align:'right',
	width:265
	},{
	xtype:'label',
	text:'分数总计',
	align:'right'
	},{
	xtype:'label',
	text:'',
	align:'right',
	width:265
	},
	new Ext.form.TextField({id:'total',width:70,disabled:true}),
	{
	xtype:'label',
	text:'',
	align:'right',
	width:210
	}];
var detailsetmenubar = ['年度:',cycleField,'-','考核期间：',periodTypeField,periodField,'-','绩效方案:',schemeField,'-','科室',deptField,'-',updatedetailButton,'-',deldetailButton];
//============================================================

//================定义ColumnTree的相关信息====================
//树形结构导入器
var detailsetTreeLoader = new Ext.tree.TreeLoader({
	dataUrl:'../scripts/ext2/cost/report/test11.csp',
	clearOnLoad:true,
    uiProviders:{
    	'col': Ext.tree.ColumnNodeUI
    }
});
//加载前事件
detailsetTreeLoader.on('beforeload', function(detailsetTreeLoader,node){
	if(detailsetTreeRoot.value!="undefined"){
	  var url=jxfeedbackURL+'?action=list&schem='+schemeField.getValue()+'&cycle='+Ext.getCmp('cycleField').getValue()+'&period='+periodField.getValue()+'&jxUnitDr='+deptField.getValue();
		detailsetTreeLoader.dataUrl=url+'&parent='+node.id;
	}
});
//树形结构的根
var detailsetTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
    text:'方案明细',
	value:'',
	expanded:false
});

//树型结构定义
var detailsetReport = new Ext.tree.ColumnTree({
	id:'detailsetReport',
	height:590,
    rootVisible:true,
    autoScroll:true,
    //title: '权重设置',
	columns:[{
    	header:'指标名称',
    	align: 'right',
    	width:160,
    	dataIndex:'name'
	},{
    	header:'指标代码',
    	width:90,
    	dataIndex:'code'
	},{
    	header:'计量单位',
    	align: 'right',
    	width:80,
    	dataIndex:'calUnitName'
	},{
    	header:'目标值',
    	align: 'right',
		renderer:format,
    	width:70,
    	dataIndex:'tValue'
	},{
    	header:'指标值',
    	align: 'right',
		renderer:format,
    	width:70,
    	dataIndex:'actValue'
	},{
    	header:'分数',
    	align: 'right',
		renderer:format,
    	width:70,
    	dataIndex:'score'
	},{
    	header:'考核方法',
    	align: 'right',
    	width:80,
    	dataIndex:'method'
	},{
    	header:'关注度',
    	align: 'right',
    	width:80,
    	dataIndex:'attentionName'
	},{
    	header:'反馈信息',
    	align: 'right',
    	width:150,
    	dataIndex:'fbdesc'
	},{
    	header:'反馈人',
    	align: 'right',
    	width:80,
    	dataIndex:'userName'
	},{
    	header:'考核点评',
    	align: 'right',
    	width:150,
    	dataIndex:'estdesc'
	},{
    	header:'点评时间',
    	align: 'right',
    	width:80,
    	dataIndex:'estDateName'
	},{
    	header:'是否提交',
    	align: 'right',
    	width:80,
    	dataIndex:'submit'
	}],
    loader:detailsetTreeLoader,
    root:detailsetTreeRoot
});
//submit
deptField.on("select",function(cmb,rec,id ){

    var url=jxfeedbackURL+'?action=list&schem='+schemeField.getValue()+'&cycle='+Ext.getCmp('cycleField').getValue()+'&period='+periodField.getValue()+'&jxUnitDr='+deptField.getValue();
	detailsetTreeLoader.dataUrl=url+"&parent=0";	
	Ext.getCmp('detailsetReport').getNodeById("roo").reload();  
    
	var url=jxfeedbackURL+'?action=gettotal'
	 detailsetTreeLoader.dataUrl=url;
	 
	 Ext.Ajax.request({
       url: jxfeedbackURL+'?action=gettotal&schem='+schemeField.getValue()+'&cycle='+Ext.getCmp('cycleField').getValue()+'&period='+periodField.getValue()+'&jxUnitDr='+deptField.getValue(),
       success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			var data =jsonData.rows;
            Ext.getCmp('total').setValue(data[0].total);

			if (jsonData.success=='true') {
				Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				this.store.commitChanges(); //还原数据修改提示
				}
				else{
					if(jsonData.info=='EmptyRecData') message='输入的数据为空!';
					if(jsonData.info=='RepCode') message='输入的代码已经存在!';
					if(jsonData.info=='RepName') message='输入的名称已经存在!';				
			    }
	    }
	});
});
//============================================================