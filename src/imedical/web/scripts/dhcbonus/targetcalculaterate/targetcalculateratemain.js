/**
  *name:tab of database
  *author:why
  *Date:2011-01-14
 */

function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

//========================================================================================

var value = "http: //www.baidu.com";

function DomUrl(){
	//alert("aaaaaaaaaaa");
	
	return "<a href=>"+value+"</a>";
} 
//========================================================================================


//奖金方案
var SchemeDs = new Ext.data.Store({
	     autoLoad:true,
	     proxy:"",
	     reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

    SchemeDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:StratagemTabUrl+'?action=schemelist&str='+Ext.getCmp('SchemeField').getRawValue(),method:'POST'})
});

var SchemeField = new Ext.form.ComboBox({
	id: 'SchemeField',
	fieldLabel: '奖金方案',
	width:150,
	listWidth : 200,
	allowBlank: false,
	store: SchemeDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'',
	name: 'SchemeField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:false,
	forceSelection:'true',
	editable:true
	});
	
//方案和核算单元联动
SchemeField.on("select",function(cmb,rec,id ){
		searchFun(cmb.getValue());
		//tmpStr=cmb.getValue();
		UnitField.setValue("");
		UnitField.setRawValue("");
		UnitDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
		//unitdeptDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
	});

function searchFun(SetCfgDr){
		UnitDs.proxy = new Ext.data.HttpProxy({
		url:'../csp/targetcalculaterateexe.csp?action=suunit&str='+Ext.getCmp('UnitField').getRawValue()+'&SchemeID='+Ext.getCmp('SchemeField').getValue(),method:'POST'});
		UnitDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
	};
//核算单元
var UnitDs = new Ext.data.Store({
	     autoLoad:true,
	     proxy:"",
	     reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

    UnitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:StratagemTabUrl+'?action=suunit&str='+Ext.getCmp('UnitField').getRawValue()+'&SchemeID='+Ext.getCmp('SchemeField').getValue(),method:'POST'})
});

var UnitField = new Ext.form.ComboBox({
	id: 'UnitField',
	fieldLabel: '核算单元',
	width:100,
	listWidth : 200,
	allowBlank: false,
	store: UnitDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'',
	name: 'UnitField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:false,
	forceSelection:'true',
	editable:true
	});
//奖金指标
var TargetDs = new Ext.data.Store({
	     autoLoad:true,
	     proxy:"",
	     reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

    TargetDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:StratagemTabUrl+'?action=stunit&str='+Ext.getCmp('TargetField').getRawValue()+'&SchemeID='+Ext.getCmp('SchemeField').getValue(),method:'POST'})
});

var TargetField = new Ext.form.ComboBox({
	id: 'TargetField',
	fieldLabel: '核算指标',
	width:150,
	listWidth : 200,
	allowBlank: false,
	store: TargetDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'',
	name: 'TargetField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:false,
	forceSelection:'true',
	editable:true
	});
//方案和指标联动
SchemeField.on("select",function(cmb,rec,id ){
		searchFun(cmb.getValue());
		//tmpStr=cmb.getValue();
		TargetField.setValue("");
		TargetField.setRawValue("");
		TargetDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
		//unitdeptDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
	});

function searchFun(SetCfgDr){
		TargetDs.proxy = new Ext.data.HttpProxy({
		url:'../csp/targetcalculaterateexe.csp?action=stunit&str='+Ext.getCmp('TargetField').getRawValue()+'&SchemeID='+Ext.getCmp('SchemeField').getValue(),method:'POST'});
		TargetDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
	};

//审核状态
var StateDs = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['0','未审核'],['1','审核']]
});

    
var StateField = new Ext.form.ComboBox({
	id: 'StateField',
	fieldLabel: '审核状态',
	width:80,
	listWidth : 80,
	selectOnFocus: true,
	allowBlank: false,
	store: StateDs,
	//anchor: '90%',
	value:'', //默认值
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

//配件数据源
var StratagemTabUrl = '../csp/dhc.bonus.targetcalculaterateexe.csp';
var StratagemTabProxy= new Ext.data.HttpProxy({url:StratagemTabUrl + '?action=list'});
var StratagemTabDs = new Ext.data.Store({
	proxy: StratagemTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'BonusSchemeID',
		'BonusSchemeName',
		'UnitID',
		'UnitName',
		'TargetID',
		'TargetName',
		'TargetUnit',
		'TargetUnitName',
		'ParameterTarget',
		'ParameterTargetName',
		'AccountBase',
		'StepSize',
		'TargetDirection',
		'StartLimit',
		'EndLimit',
		'TargetRate',
		'SchemeState',
		'IsValid'
		
	]),
    // turn on remote sorting
    remoteSort: true
});

//设置默认排序字段和排序方向
StratagemTabDs.setDefaultSort('rowid', 'desc');

//数据库数据模型
var StratagemTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.CheckboxSelectionModel(),
	{
	   header:'奖金方案',
	   dataIndex:'BonusSchemeName',
	   width:100,
	   sortable:true
	   
	 }, {
	   header:'方案状态',
	   dataIndex:'SchemeState',
	   width:100,
	   sortable:true
	   
	 },{
	   header:'奖金核算单元',
	   dataIndex:'UnitName',
	   width:100,
	   sortable:true
	   
	 },{
        header:'奖金指标名称',
		width:150,
		dataIndex:'TargetName',
		sortable:true

    },{
        header: "核算项单位",
        dataIndex: 'TargetUnitName',
        width: 80,
        align: 'left',
        sortable: true
		
    },{
        header: "目标值",
        dataIndex: 'AccountBase',
        width: 80,
        align: 'right',
        sortable: true
		
    },{
        header: "步长",
        dataIndex: 'StepSize',
        width: 80,
        align: 'right',
        sortable: true
		
    },{
        header: "核算方向",
        dataIndex: 'TargetDirection',
        width: 80,
        align: 'left',
        hidden: true,
        sortable: true
		
    },{
        header: "起始边界",
        dataIndex: 'StartLimit',
        width: 80,
        align: 'right',
        sortable: true
    },{
        header: "结束边界",
        dataIndex: 'EndLimit',
        width: 80,
        align: 'right',
        sortable: true
    },{
        header: "计提系数",
        dataIndex: 'TargetRate',
        width: 80,
        align: 'right',
        sortable: true
    },{
        header: "参数指标",
        dataIndex: 'ParameterTargetName',
        width: 150,
        align: 'left',
        sortable: true
    }
    
]);

//初始化默认排序功能
StratagemTabCm.defaultSortable = true;

//查询按钮
var findButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'add',
	handler:function(){
	    var BonusSchemeID=Ext.getCmp('SchemeField').getValue();
		//alert(BonusSchemeID);
		var UnitID=Ext.getCmp('UnitField').getValue();
		var TargetID=Ext.getCmp('TargetField').getValue();
		if(BonusSchemeID==""){
				Ext.Msg.show({title:'错误',msg:'奖金方案为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
		StratagemTabDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize,TargetID:TargetID,UnitID:UnitID,BonusSchemeID:BonusSchemeID}});
	}
});

//添加按钮
var addButton = new Ext.Toolbar.Button({
	text: '添加',
    tooltip:'添加',        
    iconCls:'add',
	handler:function(){
	

//奖金方案
var SchemeDs = new Ext.data.Store({
	     autoLoad:true,
	     proxy:"",
	     reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

    SchemeDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:StratagemTabUrl+'?action=schemelist1&str='+Ext.getCmp('SchField').getRawValue(),method:'POST'})
});

 var SchField = new Ext.form.ComboBox({
	id: 'SchField',
	fieldLabel: '奖金方案',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: SchemeDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'',
	name: 'SchField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:false,
	forceSelection:'true',
	editable:true,
	listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(SchField.getValue()!=""){
							UnField.focus();
						}else{
							Handler = function(){UnField.focus();}
							Ext.Msg.show({title:'错误',msg:'奖金方案不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
});
SchField.on("select",function(cmb,rec,id ){
		searchFun(cmb.getValue());
		//tmpStr=cmb.getValue();
		UnField.setValue("");
		UnField.setRawValue("");
		UnitDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
		//unitdeptDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
	});

function searchFun(BonusSchemeID){
		UnitDs.proxy = new Ext.data.HttpProxy({
		url:'../csp/targetcalculaterateexe.csp?action=suunit&str='+Ext.getCmp('UnField').getRawValue()+'&SchemeID='+Ext.getCmp('SchField').getValue(),method:'POST'});
		UnitDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
	};
//核算单元
var UnitDs = new Ext.data.Store({
	     autoLoad:true,
	     proxy:"",
	     reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

    UnitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:StratagemTabUrl+'?action=suunit&str='+Ext.getCmp('UnField').getRawValue()+'&SchemeID='+Ext.getCmp('SchField').getValue(),method:'POST'})
});

var UnField = new Ext.form.ComboBox({
	id: 'UnField',
	fieldLabel: '核算单元',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: UnitDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'',
	name: 'UnField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:false,
	forceSelection:'true',
	editable:true,
	listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(UnField.getValue()!=""){
							TarField.focus();
						}else{
							Handler = function(){TarField.focus();}
							Ext.Msg.show({title:'错误',msg:'核算单元不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
});
//奖金指标
var TargetDs = new Ext.data.Store({
	     autoLoad:true,
	     proxy:"",
	     reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

    TargetDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:StratagemTabUrl+'?action=stunit&str='+Ext.getCmp('TarField').getRawValue()+'&SchemeID='+Ext.getCmp('SchField').getValue(),method:'POST'})
});

var TarField = new Ext.form.ComboBox({
	id: 'TarField',
	fieldLabel: '核算指标',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: TargetDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'',
	name: 'TarField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:false,
	forceSelection:'true',
	editable:true,
	listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(TarField.getValue()!=""){
							TargetUnitField.focus();
						}else{
							Handler = function(){TargetUnitField.focus();}
							Ext.Msg.show({title:'错误',msg:'核算指标不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
});
//方案和指标联动
SchField.on("select",function(cmb,rec,id ){
		searchFun(cmb.getValue());
		//tmpStr=cmb.getValue();
		TarField.setValue("");
		TarField.setRawValue("");
		TargetDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
		//unitdeptDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
	});

function searchFun(BonusSchemeID){
		TargetDs.proxy = new Ext.data.HttpProxy({
		url:'../csp/targetcalculaterateexe.csp?action=stunit&str='+Ext.getCmp('TarField').getRawValue()+'&SchemeID='+Ext.getCmp('SchField').getValue(),method:'POST'});
		TargetDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
	};
/----------------------------------------------------------------------------------------------/

//计量单位
var CalDs = new Ext.data.Store({
	     autoLoad:true,
	     proxy:"",
	     reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

    CalDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:StratagemTabUrl+'?action=calunit&str='+Ext.getCmp('TargetUnitField').getRawValue(),method:'POST'})
});

var TargetUnitField = new Ext.form.ComboBox({
	id: 'TargetUnitField',
	fieldLabel: '计量单位',
	width:180,
	listWidth : 180,
	allowBlank: false,
	store: CalDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'',
	name: 'TargetUnitField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:false,
	forceSelection:'true',
	editable:true,
    listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(TargetUnitField.getValue()!=""){
							AccountBaseField.focus();
						}else{
							Handler = function(){AccountBaseField.focus();}
							Ext.Msg.show({title:'错误',msg:'计量单位不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
});	
//目标值	
var AccountBaseField = new Ext.form.TextField({
			id:'AccountBaseField',
			fieldLabel: '目标值',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'',
			//anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
		});
//步长
	var StepSizeField = new Ext.form.TextField({
			id:'StepSizeField',
			fieldLabel: '步长',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'',
			//anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
		});	
//核算方向
var DirectDs = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['1','正向'],['-1','负向']]
});
var TargetDirectionField = new Ext.form.ComboBox({
	id: 'TargetDirectionField',
	fieldLabel: '核算方向',
	width:180,
	listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: DirectDs,
	//anchor: '90%',
	value:'', //默认值
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	hidden: true,
	forceSelection: true,
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
		});	
//起始边界
var StartLimitField = new Ext.form.TextField({
			id:'StartLimitField',
			fieldLabel: '起始边界',
			allowBlank: true,
			width:180,
			listWidth : 180,
			emptyText:'',
			//anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
		});
//结束边界
var EndLimitField = new Ext.form.TextField({
			id:'EndLimitField',
			fieldLabel: '结束边界',
			allowBlank: true,
			width:180,
			listWidth : 180,
			emptyText:'',
			//anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
		});
//计提系数
var TargetRateField = new Ext.form.TextField({
			id:'TargetRateField',
			fieldLabel: '计提系数',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'',
			//anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
		});	
//参数指标
var ParameterDs = new Ext.data.Store({
	     autoLoad:true,
	     proxy:"",
	     reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

    ParameterDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:StratagemTabUrl+'?action=targetlist&str='+Ext.getCmp('ParameterField').getRawValue()+'&TargetID='+Ext.getCmp('TarField').getValue(),method:'POST'});
});

var ParameterField = new Ext.form.ComboBox({
	id: 'ParameterField',
	fieldLabel: '参数指标',
	width:180,
	listWidth : 180,
	allowBlank: false,
	store: ParameterDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'',
	name: 'ParameterField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:false,
	forceSelection:'true',
	editable:true
	});
//指标和参数指标联动
TarField.on("select",function(cmb,rec,id ){
		searchFun(cmb.getValue());
		//tmpStr=cmb.getValue();
		ParameterField.setValue("");
		ParameterField.setRawValue("");
		ParameterDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
		//unitdeptDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
	});

function searchFun(TargetID){
		ParameterDs.proxy = new Ext.data.HttpProxy({
		url:'../csp/targetcalculaterateexe.csp?action=targetlist&str='+Ext.getCmp('ParameterField').getRawValue()+'&TargetID='+Ext.getCmp('TarField').getValue(),method:'POST'});
		ParameterDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
	};	
		
		//初始化面板
		formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
				SchField,
			    UnField,
				TarField,
				TargetUnitField,
				AccountBaseField,
				StepSizeField,
				//TargetDirectionField,
				StartLimitField,
				EndLimitField,
				TargetRateField,
				ParameterField
			]
		});
		
		//初始化添加按钮
		addButton = new Ext.Toolbar.Button({
			text:'添 加'
		});
		
		//定义添加按钮响应函数
		addHandler = function(){
		    var BonusSchemeID = Ext.getCmp('SchField').getValue();
			//alert(BonusSchemeID);
			var UnitID = Ext.getCmp('UnField').getValue();
			var TargetID=Ext.getCmp('TarField').getValue();
			var TargetUnit = Ext.getCmp('TargetUnitField').getValue();
			var AccountBase=Ext.getCmp('AccountBaseField').getValue();
			var StepSize=Ext.getCmp('StepSizeField').getValue();
			
			//var TargetDirection = Ext.getCmp('TargetDirectionField').getValue();
			var TargetDirection ='1'
			
			var StartLimit = Ext.getCmp('StartLimitField').getValue();
			var EndLimit = Ext.getCmp('EndLimitField').getValue();
			var TargetRate = Ext.getCmp('TargetRateField').getValue();
			var ParameterTarget = Ext.getCmp('ParameterField').getValue();
			if(BonusSchemeID==""){
				Ext.Msg.show({title:'错误',msg:'奖金方案为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(UnitID==""){
				Ext.Msg.show({title:'错误',msg:'核算单元为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
	        if(TargetID==""){
				Ext.Msg.show({title:'错误',msg:'核算指标为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(TargetUnit==""){
				Ext.Msg.show({title:'错误',msg:'计量单位为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(AccountBase==""){
				Ext.Msg.show({title:'错误',msg:'目标值为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(StepSize==""){
				Ext.Msg.show({title:'错误',msg:'步长为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(ParameterTarget==""){
				Ext.Msg.show({title:'错误',msg:'参数指标为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			var data=UnitID.trim()+"^"+TargetID.trim()+"^"+TargetUnit.trim()+"^"+AccountBase.trim()+"^"+StepSize.trim()+"^"+TargetDirection.trim()+"^"+StartLimit.trim()+"^"+EndLimit.trim()+"^"+TargetRate.trim()+"^"+ParameterTarget.trim()+"^"+BonusSchemeID.trim();
			//alert(data);
	
			
			Ext.Ajax.request({
				url: '../csp/dhc.bonus.targetcalculaterateexe.csp?action=add&data='+data,
				waitMsg:'保存中...',
				failure: function(result, request){
					//Handler = function(){codeField.focus();}
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						//Handler = function(){codeField.focus();}
						Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						var BonusSchemeID=Ext.getCmp('SchemeField').getValue();
		                var UnitID=Ext.getCmp('UnitField').getValue();
		                var TargetID=Ext.getCmp('TargetField').getValue();
						StratagemTabDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize,TargetID:TargetID,UnitID:UnitID,BonusSchemeID:BonusSchemeID}});
					}else{
						if(jsonData.info=='RepCode'){
							//Handler = function(){codeField.focus();}
							Ext.Msg.show({title:'错误',msg:'此战略目标代码已经存在!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
						if(jsonData.info=='RepName'){
							//Handler = function(){nameField.focus();}
							Ext.Msg.show({title:'错误',msg:'此战略目标名称已经存在!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					}
				},
				scope: this
			});
		}
	
		//添加保存按钮的监听事件
		addButton.addListener('click',addHandler,false);
	
		//初始化取消按钮
		cancelButton = new Ext.Toolbar.Button({
			text:'取消'
		});
	
		//定义取消按钮的响应函数
		cancelHandler = function(){
			addwin.close();
		}
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//初始化窗口
		addwin = new Ext.Window({
			title: '添加计提系数',
			width: 400,
			height:400,
			minWidth: 400, 
			minHeight: 400,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				addButton,
				cancelButton
			]
		});
	
		//窗口显示
		addwin.show();
	}
});


//修改按钮
var editButton = new Ext.Toolbar.Button({
	text: '修改',
    tooltip:'修改',        
    iconCls:'add',
	handler:function(){
		//定义并初始化行对象
		var rowObj=StratagemTab.getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
			var state = rowObj[0].get("SchemeState");
			//alert(state);
			if(state=="审核完成"){
				Ext.Msg.show({title:'注意',msg:'该条数据方案已经被审核,不允许再修改!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return false;
			}
			if(state=="confirm"){
				Ext.Msg.show({title:'注意',msg:'该战略已下达,不允许再编辑!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return false;
			}
		}
 var SchemeDs = new Ext.data.Store({
	     autoLoad:true,
	     proxy:"",
	     reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

    SchemeDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:StratagemTabUrl+'?action=schemelist1&str='+Ext.getCmp('SchmeField').getRawValue(),method:'POST'})
});

 var SchmeField = new Ext.form.ComboBox({
	id: 'SchmeField',
	fieldLabel: '奖金方案',
	width:180,
	listWidth : 180,
	allowBlank: false,
	store: SchemeDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'',
    valueNotFoundText:rowObj[0].get("BonusSchemeName"),
	name: 'SchmeField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:false,
	forceSelection:'true',
	//readOnly:false,
	disabled:true,
	editable:true,
	listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(SchmeField.getValue()!=""){
							SchField.focus();
						}else{
							Handler = function(){workField.focus();}
							Ext.Msg.show({title:'错误',msg:'目标代码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
});
SchmeField.on("select",function(cmb,rec,id ){
		searchFun(cmb.getValue());
		//tmpStr=cmb.getValue();
		UField.setValue("");
		UField.setRawValue("");
		UnitDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
		//unitdeptDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
	});

function searchFun(BonusSchemeID){
		UnitDs.proxy = new Ext.data.HttpProxy({
		url:'../csp/targetcalculaterateexe.csp?action=suunit&str='+Ext.getCmp('UField').getRawValue()+'&SchemeID='+Ext.getCmp('SchmeField').getValue(),method:'POST'});
		UnitDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
	};
//核算单元
var UnitDs = new Ext.data.Store({
	     autoLoad:true,
	     proxy:"",
	     reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

    UnitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:StratagemTabUrl+'?action=suunit&str='+Ext.getCmp('UField').getRawValue()+'&SchemeID='+Ext.getCmp('SchmeField').getValue(),method:'POST'})
});

var UField = new Ext.form.ComboBox({
	id: 'UField',
	fieldLabel: '核算单元',
	width:180,
	listWidth : 180,
	allowBlank: false,
	store: UnitDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'',
	valueNotFoundText:rowObj[0].get("UnitName"),
	name: 'UField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:false,
	forceSelection:'true',
	editable:true
	});
//奖金指标
var TargetDs = new Ext.data.Store({
	     autoLoad:true,
	     proxy:"",
	     reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

    TargetDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:StratagemTabUrl+'?action=stunit&str='+Ext.getCmp('TargField').getRawValue()+'&SchemeID='+Ext.getCmp('SchmeField').getValue(),method:'POST'})
});

var TargField = new Ext.form.ComboBox({
	id: 'TargField',
	fieldLabel: '核算指标',
	width:180,
	listWidth : 180,
	allowBlank: false,
	store: TargetDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'',
	valueNotFoundText:rowObj[0].get("TargetName"),
	name: 'TargField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:false,
	forceSelection:'true',
	editable:true
	});
//方案和指标联动
SchmeField.on("select",function(cmb,rec,id ){
		searchFun(cmb.getValue());
		//tmpStr=cmb.getValue();
		TargField.setValue("");
		TargField.setRawValue("");
		TargetDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
		//unitdeptDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
	});

function searchFun(BonusSchemeID){
		TargetDs.proxy = new Ext.data.HttpProxy({
		url:'../csp/targetcalculaterateexe.csp?action=stunit&str='+Ext.getCmp('TargField').getRawValue()+'&SchemeID='+Ext.getCmp('SchmeField').getValue(),method:'POST'});
		TargetDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
	};
/-----------------------------------------------/	
	
//计量单位
var CalDs = new Ext.data.Store({
	     autoLoad:true,
	     proxy:"",
	     reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

    CalDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:StratagemTabUrl+'?action=calunit&str='+Ext.getCmp('TargetUField').getRawValue(),method:'POST'})
});

var TargetUField = new Ext.form.ComboBox({
	id: 'TargetUField',
	fieldLabel: '计量单位',
	width:180,
	listWidth : 180,
	allowBlank: false,
	store: CalDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'',
	valueNotFoundText:rowObj[0].get("TargetUnitName"),
	name: 'TargetUField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:false,
	forceSelection:'true',
	editable:true
	});
	
//目标值	
var AccountField = new Ext.form.TextField({
			id:'AccountField',
			fieldLabel: '目标值',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'',
			//anchor: '90%',
			selectOnFocus:'true',
			name:'AccountBase',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
		});
//步长
	var StepField = new Ext.form.TextField({
			id:'StepField',
			fieldLabel: '步长',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'',
			//anchor: '90%',
			selectOnFocus:'true',
			name:'StepSize',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
		});	
//核算方向
var DirectDs = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['1','正向'],['-1','负向']]
});
var DirectionField = new Ext.form.ComboBox({
	        id: 'DirectionField',
			fieldLabel: '核算方向',
			listWidth : 180,
			selectOnFocus: true,
			allowBlank: false,
			store: DirectDs,
			value:'1', //默认值
			valueNotFoundText:'正向',
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			emptyText:'',
			name:'TargetDirection',
			mode: 'local', //本地模式
			editable:false,
			pageSize: 10,
			minChars: 1,
			hidden:true,
			selectOnFocus: true,
			forceSelection: true,
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
		});	
//起始边界
var StartField = new Ext.form.TextField({
			id:'StartField',
			fieldLabel: '起始边界',
			allowBlank: true,
			width:180,
			listWidth : 180,
			emptyText:'',
			//anchor: '90%',
			selectOnFocus:'true',
			name:'StartLimit',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
		});
//结束边界
var EndField = new Ext.form.TextField({
			id:'EndField',
			fieldLabel: '结束边界',
			allowBlank: true,
			width:180,
			listWidth : 180,
			emptyText:'',
			//anchor: '90%',
			selectOnFocus:'true',
			name:'EndLimit',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
		});
//计提系数
var RateField = new Ext.form.TextField({
			id:'RateField',
			fieldLabel: '计提系数',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'',
			//anchor: '90%',
			selectOnFocus:'true',
			name:'TargetRate',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
		});	
//参数指标
var ParameterDs = new Ext.data.Store({
	     autoLoad:true,
	     proxy:"",
	     reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

    ParameterDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:StratagemTabUrl+'?action=targetlist&str='+Ext.getCmp('ParaField').getRawValue()+'&TargetID='+Ext.getCmp('TargField').getValue(),method:'POST'});
});

var ParaField = new Ext.form.ComboBox({
	id: 'ParaField',
	fieldLabel: '参数指标',
	width:180,
	listWidth : 180,
	allowBlank: false,
	store: ParameterDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'',
	valueNotFoundText:rowObj[0].get("ParameterTargetName"),
	name: 'ParaField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:false,
	forceSelection:'true',
	editable:true
	});
//指标和参数指标联动
TargField.on("select",function(cmb,rec,id ){
		searchFun(cmb.getValue());
		//tmpStr=cmb.getValue();
		ParaField.setValue("");
		ParaField.setRawValue("");
		ParameterDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
		//unitdeptDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
	});

function searchFun(TargetID){
		ParameterDs.proxy = new Ext.data.HttpProxy({
		url:'../csp/targetcalculaterateexe.csp?action=targetlist&str='+Ext.getCmp('ParaField').getRawValue()+'&TargetID='+Ext.getCmp('TargField').getValue(),method:'POST'});
		ParameterDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
	};	
		
		
		//定义并初始化面板
		var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
				SchmeField,
				UField,
				TargField,
				TargetUField,
				AccountField,
				StepField,
				//DirectionField,
				StartField,
				EndField,
				RateField,
				ParaField
			]
		});
	
		//面板加载
		formPanel.on('afterlayout', function(panel, layout){
		
		   var sTargetDirection = rowObj[0].get("TargetDirection")
			this.getForm().loadRecord(rowObj[0]);
			SchmeField.setValue(rowObj[0].get("BonusSchemeID"));
			UField.setValue(rowObj[0].get("UnitID"));
			TargField.setValue(rowObj[0].get("TargetID"));
			TargetUField.setValue(rowObj[0].get("TargetUnit"));
			ParaField.setValue(rowObj[0].get("ParameterTarget"));
			var a = rowObj[0].get("ParameterTarget");
		    //alert(a);
			DirectionField.setValue( "1")
			
/*			if (sTargetDirection=="正向") {
				DirectionField.setValue("1");
			}else {
				DirectionField.setValue("-1");
			}*/
			
			
		});
		
		//定义并初始化保存修改按钮
		var editButton = new Ext.Toolbar.Button({
			text:'保存修改'
		});
	
		//定义修改按钮响应函数
		editHandler = function(){
		    var BonusSchemeID = Ext.getCmp('SchmeField').getValue();
			//alert(BonusSchemeID);
			var UnitID = Ext.getCmp('UField').getValue();
			var TargetID=Ext.getCmp('TargField').getValue();
			var TargetUnit = Ext.getCmp('TargetUField').getValue();
			var AccountBase=Ext.getCmp('AccountField').getValue();
			var StepSize=Ext.getCmp('StepField').getValue();
			
			//var TargetDirection = Ext.getCmp('DirectionField').getValue();
			
			var TargetDirection = '1'
			
			var StartLimit = Ext.getCmp('StartField').getValue();
			var EndLimit = Ext.getCmp('EndField').getValue();
			var TargetRate = Ext.getCmp('RateField').getValue();
			var ParameterTarget = Ext.getCmp('ParaField').getValue();
			if(BonusSchemeID==""){
				Ext.Msg.show({title:'错误',msg:'奖金方案为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(UnitID==""){
				Ext.Msg.show({title:'错误',msg:'核算单元为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
	        if(TargetID==""){
				Ext.Msg.show({title:'错误',msg:'核算指标为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(TargetUnit==""){
				Ext.Msg.show({title:'错误',msg:'计量单位为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(AccountBase==""){
				Ext.Msg.show({title:'错误',msg:'目标值为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(ParameterTarget==""){
				Ext.Msg.show({title:'错误',msg:'参数指标为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			var data=UnitID.trim()+"^"+TargetID.trim()+"^"+TargetUnit.trim()+"^"+AccountBase.trim()+"^"+StepSize.trim()+"^"+TargetDirection.trim()+"^"+StartLimit.trim()+"^"+EndLimit.trim()+"^"+TargetRate.trim()+"^"+ParameterTarget.trim()+"^"+BonusSchemeID.trim();
			//alert(data);
			Ext.Ajax.request({
				url: '../csp/dhc.bonus.targetcalculaterateexe.csp?action=edit&rowid='+rowid+'&data='+data,
				waitMsg:'保存中...',
				failure: function(result, request){
					//Handler = function(){codeField.focus();}
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					    var BonusSchemeID=Ext.getCmp('SchemeField').getValue();
		                var UnitID=Ext.getCmp('UnitField').getValue();
		                var TargetID=Ext.getCmp('TargetField').getValue();
						StratagemTabDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize,TargetID:TargetID,UnitID:UnitID,BonusSchemeID:BonusSchemeID}});
						editwin.close();
					}
				},
				scope: this
			});
		}
	
		//添加保存修改按钮的监听事件
		editButton.addListener('click',editHandler,false);
	
		//定义并初始化取消修改按钮
		var cancelButton = new Ext.Toolbar.Button({
			text:'取消修改'
		});
	
		//定义取消修改按钮的响应函数
		cancelHandler = function(){
			editwin.close();
		}
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//定义并初始化窗口
		var editwin = new Ext.Window({
			title: '修改计提系数设定',
			width: 400,
			height:400,
			minWidth: 400, 
			minHeight: 400,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				editButton,
				cancelButton
			]
		});
	
		//窗口显示
		editwin.show();
	}
});

//审核按钮
/**
var AuButton = new Ext.Toolbar.Button({
	text: '审核',
    tooltip:'审核',        
    iconCls:'add',
	handler:function(){
		//定义并初始化行对象
		var rowObj=StratagemTab.getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
			var state = rowObj[0].get("AuditingState")
		    var userCode = session['LOGON.USERCODE'];
			//alert(state);
		}
		function handler(id){
			if(id=="yes"){
			for(var i = 0; i < len; i++){
				Ext.Ajax.request({
					url:'../csp/dhc.bonus.targetcalculaterateexe.csp?action=audit&rowid='+rowObj[i].get("rowid")+'&userCode='+userCode,
					waitMsg:'审核中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							StratagemTabDs.load({params:{start:0,limit:StratagemTabPagingToolbar.pageSize}});
						}else{
							Ext.Msg.show({title:'错误',msg:'数据已审核!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
			}
		}
		Ext.MessageBox.confirm('提示','确实要审核目标记录吗?',handler);
	}
});
**/
//删除按钮
var DelButton = new Ext.Toolbar.Button({
	text: '删除',
    tooltip:'删除',        
    iconCls:'add',
	handler:function(){
		//定义并初始化行对象
		var rowObj=StratagemTab.getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		//alert(len);
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
			var state = rowObj[0].get("SchemeState");
			//alert(state);
			if(state=="审核完成"){
				Ext.Msg.show({title:'注意',msg:'该条数据方案已经被审核,不允许删除!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return false;
			}
		}
		function handler(id){
			if(id=="yes"){
			for(var i = 0; i < len; i++){
				Ext.Ajax.request({
					url:'../csp/dhc.bonus.targetcalculaterateexe.csp?action=del&rowid='+rowObj[i].get("rowid"),
					waitMsg:'删除中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							var BonusSchemeID=Ext.getCmp('SchemeField').getValue();
		                var UnitID=Ext.getCmp('UnitField').getValue();
		                var TargetID=Ext.getCmp('TargetField').getValue();
						StratagemTabDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize,TargetID:TargetID,UnitID:UnitID,BonusSchemeID:BonusSchemeID}});
						}else{
							Ext.Msg.show({title:'错误',msg:'数据已审核,删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
			}
		}
		Ext.MessageBox.confirm('提示','确实要删除目标记录吗?',handler);
	}
});

//分页工具栏
var StratagemTabPagingToolbar = new Ext.PagingToolbar({
    store: StratagemTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg: "没有记录",
	//buttons: ['-',StratagemFilterItem,'-',StratagemSearchBox],
	doLoad:function(C){
		var B={},
		A=this.paramNames;
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['BonusSchemeID']=Ext.getCmp('SchemeField').getValue();
		B['UnitID']=Ext.getCmp('UnitField').getValue();
		B['TargetID']=Ext.getCmp('TargetField').getValue();

		//B['unitdr']=Ext.getCmp('unitField').getValue();
		//B['cycledr']=Ext.getCmp('cycleField').getValue();
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//表格
var StratagemTab = new Ext.grid.EditorGridPanel({
	title: '参数指标系数设置',
	store: StratagemTabDs,
	cm: StratagemTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.CheckboxSelectionModel({singleSelect:false}),
	loadMask: true,
	tbar:['奖金方案:',SchemeField,'-','核算单元:',UnitField,'-','核算指标:',TargetField,'-',findButton,'-',addButton,'-',editButton,'-',DelButton],
	bbar:StratagemTabPagingToolbar
});


