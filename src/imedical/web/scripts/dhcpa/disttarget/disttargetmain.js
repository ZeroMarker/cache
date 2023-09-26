function format(value){
	//alert(value);
	re=/(\d{1,3})(?=(\d{3})+(?:$|\D))/g;
	value=value.replace(re,"$1,")
	return value?value:'';
};

var cycleIdCookieNameOfDT="cycleDr";
var schemIdCookieNameOfDT="schemDr";
var deptIdCookieNameOfDT="deptDr";
var kpiIdCookieNameOfDT="kpiDr";
var nameStr=cycleIdCookieNameOfDT+"^"+schemIdCookieNameOfDT+"^"+deptIdCookieNameOfDT+"^"+kpiIdCookieNameOfDT;
var dataStr="";
var count1=0;
var count2=0;
var count3=0;
var count4=0;



var userCode = session['LOGON.USERCODE'];


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
	listWidth : 200,
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

/* cycleDs.on('load', function(ds, o){
	cycleField.setValue(getCookie(cycleIdCookieNameOfDT));
	count1=1;
}); */

var schemDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','parRef','code','name','shortcut','appSysDr','frequency','KPIDr','KPIName','desc','level','appSys','quency','shortCutFreQuency'])
});

schemDs.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.disttargetexe.csp?action=schem&searchField=name&searchValue='+encodeURIComponent(Ext.getCmp('schemField').getRawValue())+'&active=Y',method:'POST'})
	
});
var schemField = new Ext.form.ComboBox({
	id: 'schemField',
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

/* schemDs.on('load', function(ds, o){
	schemField.setValue(getCookie(schemIdCookieNameOfDT));
	count2=1;
}); */

var deptDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['jxUnitDr','jxUnitName','shortCut'])
});

deptDs.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.disttargetexe.csp?action=dept&schemDr='+Ext.getCmp('schemField').getValue(),method:'POST'})
	
});

var deptField = new Ext.form.ComboBox({
	id: 'deptField',
	fieldLabel: '科室',
	width:180,
	listWidth : 200,
	selectOnFocus: false,
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
	forceSelection: true
});

/* deptDs.on('load', function(ds, o){
	deptField.setValue(getCookie(deptIdCookieNameOfDT));
	count3=1;
});
 */
var KPIDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


KPIDs.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.disttargetexe.csp?action=kpi&schemDr='+Ext.getCmp('schemField').getValue()+'&userCode='+userCode,method:'POST'})
	
});
var KPIField = new Ext.form.ComboBox({
	id: 'KPIField',
	fieldLabel: '',
	width:180,
	listWidth : 200,
	selectOnFocus: false,
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
	forceSelection: true
});

/* KPIDs.on('load', function(ds, o){
	KPIField.setValue(getCookie(kpiIdCookieNameOfDT));
	count4=1;
});
 */
schemField.on("select",function(cmb,rec,id ){
    searchFun(cmb.getValue());
});

function searchFun(schemDr){
	deptField.setValue("");
	deptField.setRawValue("");
	//绩效单位
    deptDs.load({params:{start:0, limit:deptField.pageSize}});
	KPIField.setValue("");
	KPIField.setRawValue("");
	//KPI指标
	KPIDs.load({params:{start:0, limit:KPIField.pageSize}});
	
	/* if(getCookie(schemIdCookieNameOfDT)==schemDr){
		setComboValueFromServer(deptField,deptIdCookieNameOfDT);
		setComboValueFromServer(KPIField,kpiIdCookieNameOfDT);
	}else{
		deptDs.on('load', function(ds, o){
			deptField.setValue("");
		});
		KPIDs.on('load', function(ds, o){
			KPIField.setValue("");
		});
	} */
};

var sm = new Ext.grid.CheckboxSelectionModel();

var vouchDetailST = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'../csp/dhc.pa.basedataviewexe.csp'}),
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
		}),
	remoteSort: true
});

var autoHisOutMedCm = new Ext.grid.ColumnModel([]);

var autohisoutmedvouchForm = new Ext.form.FormPanel({
	title:'目标分解设置',
	region:'north',
	frame:true,
	height:90,
	items:[{
		xtype: 'panel',
		layout:"column",
		hideLabel:true,
		isFormField:true,
		items:[
			{columnWidth:.07,xtype:'label',text: '年度:'},
			cycleField,
			{columnWidth:.02,xtype:'displayfield'},
			{columnWidth:.1,xtype:'label',text: '当前方案:'},
			schemField,
			{columnWidth:.02,xtype:'displayfield'},
			{columnWidth:.1,xtype:'label',text: 'KPI 指标:'},
			KPIField,
			{columnWidth:.50,xtype:'displayfield'},
			{columnWidth:.05,xtype:'button',text: '查询',name: 'bc',tooltip: '查询',handler:function(){find()},iconCls: 'add'}
			]
		},{
			xtype: 'panel',
			layout:"column",
			hideLabel:true,
			isFormField:true,
			items:[
				{columnWidth:.25,xtype:'displayfield'},
				{columnWidth:.057,xtype:'label',text: '科     室:'},
				deptField,
				{columnWidth:.01,xtype:'displayfield'},
				{columnWidth:.065,xtype:'label',text: '批量设置:'},
				{columnWidth:.08,xtype:'button',text: '比例系数设置',name: 'gb',tooltip: '比例系数设置',handler:function(){setRate()}},
				{columnWidth:.2,xtype:'displayfield'},
				{columnWidth:.08,xtype:'button',text: '数据初始化',name: 'gb',tooltip: '数据初始化',handler:function(){init()},iconCls: 'remove'},
				{columnWidth:.135,xtype:'displayfield'},
				{columnWidth:.05,xtype:'button',text: '保存',name: 'bc',tooltip: '保存',handler:function(){update()},iconCls: 'remove'}
			]
		}
	]
});

init2=function(){
	Ext.Ajax.request({
		url:'../csp/dhc.pa.disttargetexe.csp?action=init&cycleDr='+Ext.getCmp('cycleField').getValue()+'&schemDr='+Ext.getCmp('schemField').getValue(),
		waitMsg:'...',
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success=='true'){
				Ext.Msg.show({title:'提示',msg:'数据初始化完成!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
			}else{
				if(jsonData.info=='Copyed'){
					Ext.Msg.show({title:'提示',msg:'当前战略已经初始化!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='NoCurrRecord'){
					Ext.Msg.show({title:'提示',msg:'没有当前战略!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='RepCurrRecord'){
					Ext.Msg.show({title:'提示',msg:'多个当前战略!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='false1'){
					Ext.Msg.show({title:'提示',msg:'当前战略方案初始化失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='false2'){
					Ext.Msg.show({title:'提示',msg:'当前战略方案明细初始化失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='false3'){
					Ext.Msg.show({title:'提示',msg:'当前战略加扣分法初始化失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='false4'){
					Ext.Msg.show({title:'提示',msg:'当前战略区间法初始化失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='nullUnit'){
					Ext.Msg.show({title:'提示',msg:'该方案下没有科室',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
			
			}
		},
		scope: this
	});
}

init = function(){
	Ext.MessageBox.confirm('提示','确实要初始化数据吗?',
		function(btn) {
			if(btn == 'yes'){
				Ext.Ajax.request({
					url:'../csp/dhc.pa.disttargetexe.csp?action=judgeinit&schemDr='+Ext.getCmp('schemField').getValue(),
					waitMsg:'...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if(jsonData.info=='Copyed'){
							Ext.MessageBox.confirm('提示','当前战略已经初始化,要重新初始化吗?',
								function(btn) {
									if(btn == 'yes'){
										init2();
									}	
								}
							)
						}else if(jsonData.info=='NoCurrRecord'){
							Ext.Msg.show({title:'提示',msg:'没有当前战略,程序终止!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}else if(jsonData.info=='RepCurrRecord'){
							Ext.Msg.show({title:'提示',msg:'多个当前战略,程序终止!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}else{
							Ext.MessageBox.confirm('提示','确实要初始化吗?',
								function(btn) {
									if(btn == 'yes'){
										init2();
									}	
								}
							)
						}
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

//查询按钮处理函数
find = function(){
	var cycleDr=Ext.getCmp('cycleField').getValue();
	if((cycleDr=="")||(cycleDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
		return false;
	}
	var schemDr=Ext.getCmp('schemField').getValue();
	if((schemDr=="")||(schemDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
		return false;
	}
	var kpiDr=Ext.getCmp('KPIField').getValue();
	var deptDr=Ext.getCmp('deptField').getValue();
	dataStr=cycleIdCookieNameOfDT+"^"+cycleDr+"!"+schemIdCookieNameOfDT+"^"+schemDr+"!"+deptIdCookieNameOfDT+"^"+deptDr+"!"+kpiIdCookieNameOfDT+"^"+kpiDr;
	setBathCookieValue(dataStr);
	Ext.Ajax.request({
		url:'../csp/dhc.pa.disttargetexe.csp?action=getTitleInfo&cycleDr='+cycleDr+'&schemDr='+schemDr,
		waitMsg:'...',
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
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
				if((jsonHeadList[i].name=="jxUnitDr")||(jsonHeadList[i].name=="KPIDr")||(jsonHeadList[i].name=="DistDr")){
					cmConfig = {header:jsonHeadList[i].title,dataIndex:jsonHeadList[i].name,width:75,sortable:true,align:'left',hidden:true};
				}
				else if((jsonHeadList[i].name=="jxUnitName")||(jsonHeadList[i].name=="KPIName")){
					cmConfig = {header:jsonHeadList[i].title,dataIndex:jsonHeadList[i].name,width:75,sortable:true,align:'left'};
				}
				else if(jsonHeadList[i].name=="DistName"){
					cmConfig = {
						header:jsonHeadList[i].title,
						dataIndex:jsonHeadList[i].name,
						width:100,
						sortable:true,
						align:'left',
						editor:new Ext.form.ComboBox({
							editable:false,
							valueField: 'value',
							displayField:'value',
							mode:'local',
							triggerAction:'all',
							store:new Ext.data.SimpleStore({
								fields:['value'],
								data:[['1-全面贯彻'],['2-比例贯彻'],['3-比例系数'],['4-不分解']]
							})
						})
					};
				}else{
					var align="left";
					if(i>5){
						align="right";
					}
					cmConfig = {
						header:jsonHeadList[i].title,
						dataIndex:jsonHeadList[i].name, 
						width:75,
						sortable:true,
						renderer:format,
						align:align,
						editor:new Ext.form.TextField({
							allowBlank:true
						})
					};
				}
				cmItems.push(cmConfig); 
				tmpDataMapping.push(jsonHeadList[i].name);
			}
			var tmpColumnModel = new Ext.grid.ColumnModel(cmItems);
			
			tmpStore = new Ext.data.Store({
				proxy:new Ext.data.HttpProxy({url:'../csp/dhc.pa.disttargetexe.csp?action=getData&cycleDr='+cycleDr+'&schemDr='+schemDr+'&kpiDr='+kpiDr+'&deptDr='+deptDr, method:'GET'}),
				reader:new Ext.data.JsonReader({
					totalProperty:"results",
					root:'rows'
				},tmpDataMapping),
				remoteSort:true
			});
			autohisoutmedvouchMain.reconfigure(tmpStore,tmpColumnModel);
			
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

distMethod = function(){
	//如果方案的周期是月、季度、半年则不让其设置分配方法
	var schemDr=Ext.getCmp('schemField').getValue();
	if((schemDr=="")||(schemDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
		return false;
	}
	
	var schemShortCutF=Ext.getCmp('schemField').getRawValue();
	var rowObj = autohisoutmedvouchMain.getSelectionModel().getSelections();
	var length=rowObj.length;
	
	if(length<1){
		Ext.Msg.show({title:'提示',msg:'请选择数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
		return false;
	}else{
		//定义绩效单元ID字符串
		var jxUnitDrStr="";
		//定义分解方法ID字符串
		var methodDrStr="";
		
		var infoStr="";
		
		for(var i=0;i<length;i++){
			//定义临时绩效单元Dr变量
			var tmpJXUnitDr=rowObj[i].get('jxUnitDr');
			//定义临时分配方法Dr变量
			var tmpDistDr=rowObj[i].get('DistName').split("-")[0];
			//定义临时指标Dr变量
			var tmpKpiDr=rowObj[i].get('KPIDr');
			var info=tmpJXUnitDr+"^"+tmpDistDr+"^"+tmpKpiDr+"^"+schemDr;
			
			if(infoStr==""){
				infoStr=info;
			}else{
				infoStr=infoStr+"!"+info;
			}
		}
		Ext.MessageBox.confirm('提示','确实要设置该方法吗?',
			function(btn) {
				if(btn == 'yes'){
					Ext.Ajax.request({
						url:'../csp/dhc.pa.disttargetexe.csp?action=setmethod&infoStr='+infoStr,
						waitMsg:'...',
						failure: function(result, request) {
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:200});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'提示',msg:'分配方法设置完成!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,width:250});
								find();
							}else{
								if(jsonData.info=='1'){
									Ext.Msg.show({title:'提示',msg:'分配方法设置失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
								}
								if(jsonData.info=='NoYear'){
									Ext.Msg.show({title:'提示',msg:'没有该年的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
								}
								if(jsonData.info=='NoKPIDr'){
									Ext.Msg.show({title:'提示',msg:'没有该指标的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
								}
								if(jsonData.info=='ErrCycle'){
									Ext.Msg.show({title:'提示',msg:'当前战略错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
								}
								if(jsonData.info=='NoMethod'){
									Ext.Msg.show({title:'提示',msg:'分配方法不存在或者丢失!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:300});
								}
								if(jsonData.info=='NoDatas'){
									Ext.Msg.show({title:'提示',msg:'没有数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:150});
								}
								if(jsonData.info=='NoSchem'){
									Ext.Msg.show({title:'提示',msg:'没有方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:150});
								}
							}
						},
						scope: this
					});
				}	
			}
		)
	}
}

setRate = function(){
	var cycleDr=Ext.getCmp('cycleField').getValue();
	if((cycleDr=="")||(cycleDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:150});
		return false;
	}
	var schemDr=Ext.getCmp('schemField').getValue();	
	if((schemDr=="")||(schemDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:150});
		return false;
	}
	var rowObj = autohisoutmedvouchMain.getSelectionModel().getSelections();
	var length=rowObj.length;
	if(length<1){
		Ext.Msg.show({title:'提示',msg:'请选择要设置系数的单元!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:300});
		return false;
	}else{
		//定义临时指标Dr变量
		var kpiDr=rowObj[0].get('KPIDr');
		
		
		var numField=new Ext.form.NumberField({
			id:'numField',
			fieldLabel:'比例系数',
			width:200,
			allowBlank:true,
			blankText:'请填写比例数值',
			msTarget:'qtip'
		})
		
		var form = new Ext.form.FormPanel({
			height:100,
			width:300,
			frame:true,
			labelSeparator:':',
			labelWidth:60,
			labelAlign:'right',
			items:[
				numField
			]
		});
		
		//初始化设置按钮
		setButton = new Ext.Toolbar.Button({
			text:'确定'
		});
		
		//定义设置按钮响应函数
		setHandler = function(){
			var num = numField.getValue();
			//定义绩效单元ID字符串
			var unitDrStr="";
			for(var i=0;i<length;i++){
				//定义临时绩效单元Dr变量
				var tmpJXUnitDr=rowObj[i].get('jxUnitDr');
				if(unitDrStr==""){
					unitDrStr=tmpJXUnitDr;
				}else{
					unitDrStr=unitDrStr+"!"+tmpJXUnitDr;
				}
			}
			if(num!=""){
				Ext.Ajax.request({
					url: '../csp/dhc.pa.disttargetexe.csp?action=setrate&schemDr='+schemDr+'&kpiDr='+kpiDr+'&num='+num+'&jxUnitDrStr='+unitDrStr,
					waitMsg:'保存中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:200});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							win.close();
							Ext.Msg.show({title:'注意',msg:'设置成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,width:200});
							start=pagingToolbar.cursor;
							find();
						}else{
							if(jsonData.info=='1'){
								Ext.Msg.show({title:'提示',msg:'比例系数设置失败,数据已回滚!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:300});
							}
							if(jsonData.info=='NoYear'){
								Ext.Msg.show({title:'提示',msg:'没有该年的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
							}
							if(jsonData.info=='NoKPIDr'){
								Ext.Msg.show({title:'提示',msg:'没有该指标的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
							}
							if(jsonData.info=='ErrCycle'){
								Ext.Msg.show({title:'提示',msg:'当前战略错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
							}
							if(jsonData.info=='ErrMonth'){
								Ext.Msg.show({title:'提示',msg:'当前战略的当前月份不存在!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:300});
							}
							if(jsonData.info=='NoData'){
								Ext.Msg.show({title:'提示',msg:'没有数据更新!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
							}
							if(jsonData.info=='NoNum'){
								Ext.Msg.show({title:'提示',msg:'系数已经丢失!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
							}
						}
					},
					scope: this
				});
			}else{
				Ext.Msg.show({title:'提示',msg:'请填写比例系数值!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
				return false;
			}
		}
	
		//添加设置按钮的监听事件
		setButton.addListener('click',setHandler,false);
	
		//初始化取消按钮
		cancelButton = new Ext.Toolbar.Button({
			text:'取消'
		});
	
		//定义取消按钮的响应函数
		cancelHandler = function(){
			win.close();
		}
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//初始化窗口
		win = new Ext.Window({
			title: '设置比例系数窗口',
			width: 350,
			height:150,
			minWidth: 350, 
			minHeight: 150,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyBorder:false, 
			buttonAlign:'center',
			border:false, 
			items:form,
			buttons: [
				setButton,
				cancelButton
			]
		});
	
		//窗口显示
		win.show();
	}
}
var point="";
update = function(){
	var schemName=Ext.getCmp('schemField').getRawValue();
	if((schemName=="")||(schemName=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:200});
		return false;
	}
	var schemDr=Ext.getCmp('schemField').getValue();
	var frequery=schemName.split("!")[schemName.split("!").length-1];
	
	var obj = autohisoutmedvouchMain.getSelectionModel().getSelections();
	var length=obj.length;
	if(length<1){
		Ext.Msg.show({title:'提示',msg:'请选择要设置系数的单元!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
		return false;
	}else{
		var dataInfo="";
		for(var i=0;i<length;i++){
			if(frequery=="M"){
				var DistDr="";
				var data="";
				var jxUnitDr=obj[i].get('jxUnitDr');
				var KPIDr=obj[i].get('KPIDr');
				var DistName=obj[i].get('DistName');
				var arr=DistName.split("-");
				if(arr.length==1){
					if(DistName=="全面贯彻"){DistDr=1;}
					if(DistName=="比例贯彻"){DistDr=2;}
					if(DistName=="比例系数"){DistDr=3;}
					if(DistName=="不分解"){DistDr=4;}
				}else{
					DistDr=arr[0];
				}
				var month1=obj[i].get('month1');
				var month2=obj[i].get('month2');
				var month3=obj[i].get('month3');
				var month4=obj[i].get('month4');
				var month5=obj[i].get('month5');
				var month6=obj[i].get('month6');
				var month7=obj[i].get('month7');
				var month8=obj[i].get('month8');
				var month9=obj[i].get('month9');
				var month10=obj[i].get('month10');
				var month11=obj[i].get('month11');
				var month12=obj[i].get('month12');
				
				data=jxUnitDr+"^"+schemDr+"^"+KPIDr+"^"+month1+"^"+month2+"^"+month3+"^"+month4+"^"+month5+"^"+month6+"^"+month7+"^"+month8+"^"+month9+"^"+month10+"^"+month11+"^"+month12+"^"+DistDr;
				//alert("DistDr="+DistDr);
				if(dataInfo==""){
					dataInfo=data;
				}else{
					dataInfo=dataInfo+"!"+data;
				}
			}
			if(frequery=="Q"){
				var DistDr="";
				var data="";
				var jxUnitDr=obj[i].get('jxUnitDr');
				var KPIDr=obj[i].get('KPIDr');
				var DistName=obj[i].get('DistName');
				var arr=DistName.split("-");
				if(arr.length==1){
					if(DistName=="全面贯彻"){DistDr=1;}
					if(DistName=="比例贯彻"){DistDr=2;}
					if(DistName=="比例系数"){DistDr=3;}
					if(DistName=="不分解"){DistDr=4;}
				}else{
					DistDr=arr[0];
				}
				var Quarter1=obj[i].get('Quarter1');
				var Quarter2=obj[i].get('Quarter2');
				var Quarter3=obj[i].get('Quarter3');
				var Quarter4=obj[i].get('Quarter4');
				data=jxUnitDr+"^"+schemDr+"^"+KPIDr+"^"+Quarter1+"^"+Quarter2+"^"+Quarter3+"^"+Quarter4+"^"+DistDr;
				if(dataInfo==""){
					dataInfo=data;
				}else{
					dataInfo=dataInfo+"!"+data;
				}
			}
			if(frequery=="H"){
				var DistDr="";
				var data="";
				var jxUnitDr=obj[i].get('jxUnitDr');
				var KPIDr=obj[i].get('KPIDr');
				var DistName=obj[i].get('DistName');
				var arr=DistName.split("-");
				if(arr.length==1){
					if(DistName=="全面贯彻"){DistDr=1;}
					if(DistName=="比例贯彻"){DistDr=2;}
					if(DistName=="比例系数"){DistDr=3;}
					if(DistName=="不分解"){DistDr=4;}
				}else{
					DistDr=arr[0];
				}
				var HYear1=obj[i].get('HYear1');
				var HYear2=obj[i].get('HYear2');
				data=jxUnitDr+"^"+schemDr+"^"+KPIDr+"^"+HYear1+"^"+HYear2+"^"+DistDr;
				if(dataInfo==""){
					dataInfo=data;
				}else{
					dataInfo=dataInfo+"!"+data;
				}
			}
			if(frequery=="Y"){
				var DistDr="";
				var data="";
				var jxUnitDr=obj[i].get('jxUnitDr');
				var KPIDr=obj[i].get('KPIDr');
				var DistName=obj[i].get('DistName');
				var arr=DistName.split("-");
				if(arr.length==1){
					if(DistName=="全面贯彻"){DistDr=1;}
					if(DistName=="比例贯彻"){DistDr=2;}
					if(DistName=="比例系数"){DistDr=3;}
					if(DistName=="不分解"){DistDr=4;}
				}else{
					DistDr=arr[0];
				}
				var Year=obj[i].get('Year');
				data=jxUnitDr+"^"+schemDr+"^"+KPIDr+"^"+Year+"^"+DistDr;
				if(dataInfo==""){
					dataInfo=data;
				}else{
					dataInfo=dataInfo+"!"+data;
				}
			}
		}
		dataInfo=dataInfo+"%"+frequery;
		
		Ext.Ajax.request({
			url:'../csp/dhc.pa.disttargetexe.csp?action=update&dataInfo='+dataInfo,
			waitMsg:'刷新中...',
			failure: function(result, request){
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:200});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'保存成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
					start=pagingToolbar.cursor;
					find();
				}else{
					if(jsonData.info=='1'){
						Ext.Msg.show({title:'提示',msg:'数据设置失败,数据已回滚!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
					}
					if(jsonData.info=='NoUpdate'){
						Ext.Msg.show({title:'提示',msg:'没有保存数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
					}
					if(jsonData.info=='ErrCycle'){
						Ext.Msg.show({title:'提示',msg:'当前战略错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
					}
					if(jsonData.info=='NoData'){
						Ext.Msg.show({title:'提示',msg:'没有数据更新!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
					}
				}
			},
			scope: this
		});
	}
}

pagingToolbar=new Ext.PagingToolbar({
	store:tmpStore,
	pageSize:30,
	displayInfo:true,
	displayMsg: '第 {0} 条到 {1} 条,一共 {2} 条',
	emptyMsg:"没有记录"
})

var autohisoutmedvouchMain = new Ext.grid.EditorGridPanel({
	store:vouchDetailST,
	cm:autoHisOutMedCm,
	region:'center',
	clicksToEdit:1,
	trackMouseOver:true,
	sm:sm,
	stripeRows:true,
	loadMask:true,
	bbar:pagingToolbar
});

vouchDetailST.load();

//获取被点击的cell列id
autohisoutmedvouchMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
	point=columnIndex;
})
