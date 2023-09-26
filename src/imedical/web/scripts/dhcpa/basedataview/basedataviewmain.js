function format(value){
	//alert(value);
	re=/(\d{1,3})(?=(\d{3})+(?:$|\D))/g;
	value=value.replace(re,"$1,")
	return value?value:'';
};
var cycleIdCookieName="bdvCycleDr";
var periodTypeNameCookieName="bdvPeriodTypeName";
var periodTypeCookieName="bdvPeriodType";
var periodCookieName="bdvPeriod";
var groupIdCookieName="bdvGroupDr";
var nameStr=cycleIdCookieName+"^"+periodTypeNameCookieName+"^"+periodTypeCookieName+"^"+periodCookieName+"^"+groupIdCookieName;
var dataStr="";

var data="";
var data1=[['1','01月'],['2','02月'],['3','03月'],['4','04月'],['5','05月'],['6','06月'],['7','07月'],['8','08月'],['9','09月'],['10','10月'],['11','11月'],['12','12月']];
var data2=[['1','01季度'],['2','02季度'],['3','03季度'],['4','04季度']];
var data3=[['1','1~6上半年'],['2','7~12下半年']];
var data4=[['0','00']];
var count1=0;
var count2=0;

var monthStore="";

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

cycleDs.on('load', function(ds, o){
	//cycleField.setValue(getCookie(cycleIdCookieName));
	//count1=1;
});

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
setComboValueFromClientOfNotChange(periodTypeField,periodTypeNameCookieName,periodTypeCookieName);

if(getCookie(periodTypeCookieName)=="M"){data=data1;}
if(getCookie(periodTypeCookieName)=="Q"){data=data2;}
if(getCookie(periodTypeCookieName)=="H"){data=data3;}
if(getCookie(periodTypeCookieName)=="Y"){data=data4;}
//加载页面时渲染控件
setComboValueFromClientOfChange(periodStore,data,periodField,periodCookieName);

//期间类别与方案查询的二级联动控制
function searchFun(periodType){
	periodField.setValue("");
	periodField.setRawValue("");
	/* if(getCookie(periodTypeCookieName)==periodType){
		setComboActValueFromClientOfChange(periodField,periodCookieName);
	} */
};

var groupDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name'])
});

groupDs.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.basedataviewexe.csp?action=group&str='+encodeURIComponent(Ext.getCmp('groupField').getRawValue()),method:'POST'})
	
});

var groupField = new Ext.form.ComboBox({
	id: 'groupField',
	fieldLabel:'分组',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: groupDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择分组...',
	name: 'groupField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

groupDs.on('load', function(ds, o){
	//groupField.setValue(getCookie(groupIdCookieName));
	//count2=1;
});

//==============================================================================================================================

var vouchDetailST = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({url:'../csp/dhc.pa.basedataviewexe.csp'}),
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
			}),
		remoteSort: true
	});

var autoHisOutMedCm = new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer()
]);

var autohisoutmedvouchForm = new Ext.form.FormPanel({
		title:'基础数据查询',
		region:'north',
		frame:true,
		height:140,
		items:[{
			xtype: 'panel',
			layout:"column",
			hideLabel:true,
			isFormField:true,
			items:[
					{columnWidth:.07,xtype:'label',text: '年度:'},
					cycleField,
					{columnWidth:.01,xtype:'displayfield'},
					{columnWidth:.14,xtype:'label',text: '期间类型:'},
					periodTypeField,
					{columnWidth:.01,xtype:'displayfield'},
					{columnWidth:.07,xtype:'label',text: '期间:'},
					periodField,
					{columnWidth:.01,xtype:'displayfield'},
					{columnWidth:.14,xtype:'label',text: '显示分组:'},
					groupField
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				isFormField:true,
				items:[{columnWidth:.9,xtype: 'displayfield',value: '<font size="5px"><center>基 础 数 据 查 询</center></font>'}]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				isFormField:true,
				items:[
					{columnWidth:.41,xtype:'displayfield'},
					{columnWidth:.4,xtype:'displayfield',value:''},
					{columnWidth:.05,xtype:'button',text: '查询',name: 'bc',tooltip: '查询',handler:function(){find()},iconCls: 'add'},
					{columnWidth:.05,xtype:'button',text: '审核',name: 'gb',tooltip: '审核',handler:function(){audit()},iconCls: 'remove'}
				]
			}
		]
});

find = function(){
	var cycleDr=Ext.getCmp('cycleField').getValue();
	if((cycleDr=="")||(cycleDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var periodType=Ext.getCmp('periodTypeField').getValue();
	var periodTypeName=Ext.getCmp('periodTypeField').getRawValue();
	if((periodType=="")||(periodType=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择期间类型!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var period=Ext.getCmp('periodField').getValue();
	if((period=="")||(period=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择考核期间!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var groupDr=Ext.getCmp('groupField').getValue();
	if((groupDr=="")||(groupDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择指标分组!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}

	dataStr=cycleIdCookieName+"^"+cycleDr+"!"+groupIdCookieName+"^"+groupDr+"!"+periodCookieName+"^"+period+"!"+periodTypeCookieName+"^"+periodType+"!"+periodTypeNameCookieName+"^"+periodTypeName;
	setBathCookieValue(dataStr);
	
	Ext.Ajax.request({
		url:'../csp/dhc.pa.basedataviewexe.csp?action=getTitleInfo&groupDr='+groupDr,
		waitMsg:'...',
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			var cmItems = []; 
			var cmConfig = {}; 
			cmItems.push(new Ext.grid.RowNumberer()); 
			var jsonHeadNum = jsonData.results; 
			var jsonHeadList = jsonData.rows; 
			var tmpDataMapping = [];
			for(var i=0;i<jsonHeadList.length;i++){
				if(jsonHeadList[i].title=="绩效单元ID"){
					cmConfig = {header:jsonHeadList[i].title,dataIndex:jsonHeadList[i].name,width:75,sortable:true,align:'left',hidden:true};
				}else{
					if((jsonHeadList[i].title=="绩效单元代码")||(jsonHeadList[i].title=="绩效单元名称")){
						cmConfig = {header:jsonHeadList[i].title,dataIndex:jsonHeadList[i].name,width:75,sortable:true,align:'left'};
					}else{
						cmConfig = {header:jsonHeadList[i].title,dataIndex:jsonHeadList[i].name,width:80,renderer:format,sortable:true,align:'right'};
					}
				}
				cmItems.push(cmConfig); 
				tmpDataMapping.push(jsonHeadList[i].name);
			}
			var tmpColumnModel = new Ext.grid.ColumnModel(cmItems);
			
			var length=jsonHeadList[2].name.split("-").length;
			var publicName=jsonHeadList[2].name.split("-")[0];
						
			var tmpStore = new Ext.data.Store({
				proxy:new Ext.data.HttpProxy({
					url:'../csp/dhc.pa.basedataviewexe.csp?action=getData&groupDr='+groupDr+'&publicName='+publicName+'&cycleDr='+cycleDr+'&periodType='+periodType+'&period='+period, method:'GET'
				}),
				reader:new Ext.data.JsonReader({
					totalProperty:"results",
					root:'rows'
				},tmpDataMapping),
				remoteSort:true
			});
			autohisoutmedvouchMain.reconfigure(tmpStore,tmpColumnModel);
			tmpStore.load();
		},
		scope: this
	});
}

audit = function(){
	var userCode = session['LOGON.USERCODE'];
	var cycleDr=Ext.getCmp('cycleField').getValue();
	if((cycleDr=="")||(cycleDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var periodType=Ext.getCmp('periodTypeField').getValue();
	if((periodType=="")||(periodType=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择期间类型!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var period=Ext.getCmp('periodField').getValue();
	if((period=="")||(period=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择考核期间!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var groupDr=Ext.getCmp('groupField').getValue();
	if((groupDr=="")||(groupDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择指标分组!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var str=Ext.getCmp('cycleField').getRawValue()+Ext.getCmp('periodField').getRawValue()+Ext.getCmp('groupField').getRawValue();
	Ext.MessageBox.confirm('提示','确实要审核'+str+'的数据吗?',
		function(btn) {
			if(btn == 'yes'){
				Ext.Ajax.request({
					url:'../csp/dhc.pa.basedataviewexe.csp?action=audit&groupDr='+groupDr+'&cycleDr='+cycleDr+'&periodType='+periodType+'&period='+period+'&userCode='+userCode,
					waitMsg:'...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'提示',msg:'审核成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,width:250});
						}else{
							if(jsonData.info=='1'){
								Ext.Msg.show({title:'提示',msg:'审核失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler,width:250});
							}
						}
					},
					scope: this
				});
			}
		}
	)
}


var autohisoutmedvouchMain = new Ext.grid.EditorGridPanel({
	store:vouchDetailST,
	cm:autoHisOutMedCm,
	region:'center',
	clicksToEdit:1,
	trackMouseOver:true,
	stripeRows:true,
	loadMask:true
});

vouchDetailST.load();
