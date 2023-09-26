//定义控件的全局变量
var cycleIdCookieName="ThCycleDr";
var periodTypeNameCookieName="ThPeriodTypeName";
var periodTypeCookieName="ThPeriodType";
var periodCookieName="ThPeriod";
var schemIdCookieName="ThSchemDr";
var kpiIdCookieName="ThKpiDr";
var nameStr=cycleIdCookieName+"^"+periodTypeNameCookieName+"^"+periodTypeCookieName+"^"+periodCookieName+"^"+schemIdCookieName+"^"+kpiIdCookieName;
var dataStr="";
var data="";
var data1=[['1','01月'],['2','02月'],['3','03月'],['4','04月'],['5','05月'],['6','06月'],['7','07月'],['8','08月'],['9','09月'],['10','10月'],['11','11月'],['12','12月']];
var data2=[['1','01季度'],['2','02季度'],['3','03季度'],['4','04季度']];
var data3=[['1','1~6上半年'],['2','7~12下半年']];
var data4=[['0','00']];
var count1=0;
var count2=0;
var count3=0;

var userCode = session['LOGON.USERCODE'];


//==========================================================
function formatDate(value){
	return value?value.dateFormat('Y-m-d'):'';
};

function format(value){
	//alert(value);
	re=/(\d{1,3})(?=(\d{3})+(?:$|\D))/g;
	value=value.replace(re,"$1,")
	return value?value:'';
};

var userCode= session['LOGON.USERCODE'];

var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.paauditexe.csp?action=cycle&str='+Ext.getCmp('cycleField').getRawValue()+'&active=Y',method:'POST'})
	
});

var cycleField = new Ext.form.ComboBox({
	id: 'cycleField',
	fieldLabel:'年度',
	width:180,
	listWidth : 180,
	allowBlank: false,
	store: cycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择年度...',
	name: 'cycleField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

cycleDs.on('load', function(ds, o){
	cycleField.setValue(getCookie(cycleIdCookieName));
	count1=1;
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

var periodStore = new Ext.data.SimpleStore({
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

/*
//加载页面时渲染控件
setComboValueFromClientOfNotChange(periodTypeField,periodTypeNameCookieName,periodTypeCookieName);

if(getCookie(periodTypeCookieName)=="M"){data=data1;}
if(getCookie(periodTypeCookieName)=="Q"){data=data2;}
if(getCookie(periodTypeCookieName)=="H"){data=data3;}
if(getCookie(periodTypeCookieName)=="Y"){data=data4;}
//加载页面时渲染控件
setComboValueFromClientOfChange(periodStore,data,periodField,periodCookieName);
*/
var schemDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','shortCutFreQuency'])
});

schemDs.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.paauditexe.csp?action=schem&searchValue='+Ext.getCmp('schem').getRawValue()+'&active=Y'+'&periodType='+Ext.getCmp('periodTypeField').getValue()+'&userCode='+userCode,method:'POST'})
	
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
	schemDs.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.paauditexe.csp?action=schem3&active=Y'+'&periodType='+getCookie(periodTypeCookieName),method:'POST'});
	schemDs.load({params:{start:0, limit:schem.pageSize}});
	/*
	if(getCookie(periodTypeCookieName)==periodType){
		count2=3;
		setComboValueFromServer(schem,schemIdCookieName);
		setComboActValueFromClientOfChange(periodField,periodCookieName);
	}else{
		schemDs.on('load', function(ds, o){
			schem.setValue("");
			count2=2;
		});
	}
	*/
};
setAndLoadComboValueFromServer(schemDs,schem,schemIdCookieName);

var KPIDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

KPIDs.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.disttargetexe.csp?action=kpi&schemDr='+Ext.getCmp('schem').getValue()+'&userCode='+userCode,method:'POST'})
	
	
});

var KPIField = new Ext.form.ComboBox({
	id: 'KPIField',
	fieldLabel: '',
	width:180,
	listWidth : 180,
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

/*
KPIDs.on('load', function(ds, o){
	KPIField.setValue(getCookie(kpiIdCookieName));
	count3=1;
});
*/

schem.on("select",function(cmb,rec,id){
	search(cmb.getValue());
});
function search(schemDr){
	KPIField.setValue("");
	KPIField.setRawValue("");
	//KPI指标
	KPIDs.load({params:{start:0, limit:KPIField.pageSize}});
	/*
	if(getCookie(schemIdCookieName)==schemDr){
		setComboValueFromServer(KPIField,kpiIdCookieName);
	}else{
		KPIDs.on('load', function(ds, o){
			KPIField.setValue("");
		});
	}
	*/
};
//==============================================================================================================================

var sm = new Ext.grid.CheckboxSelectionModel();

var vouchDetailST = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'../csp/dhc.pa.unitkpireportexe.csp?action=list'}),
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
		}, [
          'rowid',
		  'KPIDr',
		  'KPIName',
		  'flag',
		  'flagName',
		  'estDesc',
		  'estUserDr',
		  'estUserName',
		  'score',
		  {name:'estDate',type:'date',dateFormat:'Y-m-d'},
		  'estAUserDr',
		  'estAUserName',
		  {name:'estADate',type:'date',dateFormat:'Y-m-d'},
		  'unitDr',
		  'unitName',
		  'tValue',
		  'actValue'
		]),
	remoteSort: true
});

var autoHisOutMedCm = new Ext.grid.ColumnModel([]);

var autohisoutmedvouchForm = new Ext.form.FormPanel({
	title:'绩效结果评价',
	region:'north',
	frame:true,
	height:90,
	items:[{
		xtype: 'panel',
		layout:"column",
		hideLabel:true,
		isFormField:true,
		items:[
				{columnWidth:.09,xtype:'label',text: '考核年度:'},
				cycleField,
				{columnWidth:.02,xtype:'displayfield'},
				{columnWidth:.1,xtype:'label',text: '期间类型:'},
				periodTypeField,
				{columnWidth:.02,xtype:'displayfield'},
				{columnWidth:.09,xtype:'label',text: '考核期间:'},
				periodField
			]
	
		},{
			xtype: 'panel',
			layout:"column",
			hideLabel:true,
			isFormField:true,
			items:[
		
			{columnWidth:.07,xtype:'label',text: '当前方案:'},
			schem,
			{columnWidth:.02,xtype:'displayfield'},
			{columnWidth:.072,xtype:'label',text: 'KPI 指标:'},
			KPIField,
			{columnWidth:.53,xtype:'displayfield'},
			{columnWidth:.05,xtype:'button',text: '查询',name: 'bc',tooltip: '查询',handler:function(){find()},iconCls: 'add'},
			{columnWidth:.01,xtype:'displayfield'},
			{columnWidth:.05,xtype:'button',text: '点评',name: 'bc',tooltip: '点评',handler:function(){think()},iconCls: 'add'}
			]
		}
	]
});

//查询按钮处理函数
find = function(){
	
	var cycleDr=Ext.getCmp('cycleField').getValue();
	if((cycleDr=="")||(cycleDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var periodId=Ext.getCmp('periodField').getValue();
	if((periodId=="")||(periodId=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择期间!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var schemDr=Ext.getCmp('schem').getValue();
	if((schemDr=="")||(schemDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var kpiDr=Ext.getCmp('KPIField').getValue();
	if((kpiDr=="")||(kpiDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择指标!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	
	var periodType=Ext.getCmp('periodTypeField').getValue();
	var periodTypeName=Ext.getCmp('periodTypeField').getRawValue();
	
	
	vouchDetailST.load({params:{start:0, limit:pagingToolbar.pageSize,cycleDr:cycleDr,schemDr:schemDr,kpiDr:kpiDr,periodId:periodId}});
	
	dataStr=cycleIdCookieName+"^"+cycleDr+"!"+schemIdCookieName+"^"+schemDr+"!"+periodCookieName+"^"+periodId+"!"+kpiIdCookieName+"^"+kpiDr+"!"+periodTypeNameCookieName+"^"+periodTypeName+"!"+periodTypeCookieName+"^"+periodType;
	setBathCookieValue(dataStr);
}

var pagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: vouchDetailST,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		doLoad:function(C){
			var B={},
			A=this.getParams();
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['cycleDr']=Ext.getCmp('cycleField').getValue();
			B['schemDr']=Ext.getCmp('schem').getValue();
			B['kpiDr']=Ext.getCmp('KPIField').getValue();
			B['periodId']=Ext.getCmp('periodField').getValue();
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B})
			}
		}
});

var AllDataItemsCm = new Ext.grid.ColumnModel([
	sm,
	new Ext.grid.RowNumberer(),
	{
		header: '单位',
		dataIndex: 'unitName',
		width: 100,
		align: 'left',
		sortable: true
    },{
		header: '积分',
		dataIndex: 'score',
		width: 70,
		align: 'right',
		renderer:format,
		sortable: true
    },{
		header: '目标值',
		dataIndex: 'tValue',
		width: 70,
		align: 'right',
		renderer:format,
		sortable: true
    },{
		header: '实际值',
		dataIndex: 'actValue',
		width: 70,
		align: 'right',
		renderer:format,
		sortable: true
    },{
        header: '关注度',
        dataIndex: 'flagName',
        width: 70,
        align: 'left',
        sortable: true,
		editor:new Ext.form.ComboBox({
			editable:false,
			valueField: 'value',
			displayField:'value',
			mode:'local',
			triggerAction:'all',
			store:new Ext.data.SimpleStore({
				fields:['value'],
				data:[['1-重点'],['0-一般']]
				})
			})
    },{
        header: '点评',
        dataIndex: 'estDesc',
        width: 400,
        align: 'left',
        sortable: true,
		editor:new Ext.form.TextField({
			allowBlank:true
		})
    },{
        header: '点评人',
        dataIndex: 'estUserName',
        width: 100,
        align: 'center',
        sortable: true
    },{
		header: "点评时间",
		dataIndex: 'estDate',
		width: 120,
		renderer:formatDate,
		align: 'center',
		sortable: true
	}
/**
,{
        header: '审核人',
        dataIndex: 'estAUserName',
        width: 70,
        align: 'center',
        sortable: true
    },{
		header: "审核时间",
		dataIndex: 'estADate',
		width: 70,
		renderer:formatDate,
		align: 'center',
		sortable: true
	}

**/
]);
var autohisoutmedvouchMain = new Ext.grid.EditorGridPanel({
	store:vouchDetailST,
	cm:AllDataItemsCm,
	region:'center',
	clicksToEdit:1,
	trackMouseOver:true,
	sm:sm,
	stripeRows:true,
	loadMask:true,
	bbar: pagingToolbar
});

vouchDetailST.load();
/*
//获取被点击的cell列id
autohisoutmedvouchMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
	point=columnIndex;
})
*/

//点评按钮处理函数
think = function(){
	var cycleDr=Ext.getCmp('cycleField').getValue();
	if((cycleDr=="")||(cycleDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var periodId=Ext.getCmp('periodField').getValue();
	if((periodId=="")||(periodId=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择期间!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var schemDr=Ext.getCmp('schem').getValue();
	if((schemDr=="")||(schemDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	
	var schemName=Ext.getCmp('schem').getRawValue();
	var frequery=schemName.split("!")[schemName.split("!").length-1];
	
	var kpiDr=Ext.getCmp('KPIField').getValue();
	if((kpiDr=="")||(kpiDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择指标!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	
	var obj = autohisoutmedvouchMain.getSelectionModel().getSelections();
	var length=obj.length;
	if(length<1){
		Ext.Msg.show({title:'提示',msg:'请选择要设置系数的单元!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:300});
		return false;
	}else{
		var dataInfo="";
		for(var i=0;i<length;i++){
			var data="";
			var flagDr="";
			var flagName=obj[i].get('flagName');
			var arr=flagName.split("-");
			if(arr.length==1){
				if(flagName=="重点"){flagDr=1;}
				if(flagName=="一般"){flagDr=0;}
			}else{
				flagDr=arr[0];
			}
		
			var jxUnitDr=obj[i].get('unitDr');
			var estDesc=obj[i].get('estDesc');
			data=jxUnitDr+"^"+schemDr+"^"+kpiDr+"^"+cycleDr+"^"+periodId+"^"+estDesc+"^"+userCode+"^"+flagDr;
				
			if(dataInfo==""){
				dataInfo=data;
			}else{
				dataInfo=dataInfo+"!"+data;
			}
		}
		Ext.Ajax.request({
			url:'../csp/dhc.pa.unitkpireportexe.csp?action=think&dataInfo='+dataInfo,
			waitMsg:'刷新中...',
			failure: function(result, request){
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'点评成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
					vouchDetailST.load({params:{start:0, limit:pagingToolbar.pageSize,cycleDr:cycleDr,schemDr:schemDr,kpiDr:kpiDr,periodId:periodId}});
				}else{
					if(jsonData.info=='1'){
						Ext.Msg.show({title:'提示',msg:'点评失败,数据回滚!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
					}
					if(jsonData.info=='NoData'){
						Ext.Msg.show({title:'提示',msg:'没有数据更新!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
					}
				}
			},
			scope: this
		});
	}
}
