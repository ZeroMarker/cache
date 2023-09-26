// 添加函数
function AddFun() {

//绩效方案
var WorkItemStors = new Ext.data.Store({
 autoLoad:true,
 proxy:"",
 reader:new Ext.data.JsonReader({
 totalProperty:'results',
 root:'rows'
 },['rowid','Code','Name'])
});

WorkItemStors.on('beforeload',function(ds,o){
    ds.proxy = new Ext.data.HttpProxy({
    url:StratagemTabUrl + '?action=GetPaScheme'+WorkItemFileds.getValue(),
	method : 'POST'
					})
});
var WorkItemFileds = new Ext.form.ComboBox({
    id:'WorkItemFileds',
	fieldLabel:'绩效方案',
	width:125,
	listWidth:205,
	anchor : '100%',
	allowBlank:true,
	valueField:'rowid',
	displayField:'Name',
	store : WorkItemStors,
	triggerAction : 'all',
	name : 'WorkItemFiled',
	emptyText:"",
	minChars:1,
	pageSize:10,
	editable:true,
	selectOnFocus : false,
	forceSelection : 'true',
	listeners:{        
    select : function(combo, record, index){      
    KpiTargetDS.proxy = new Ext.data.HttpProxy({
    url:StratagemTabUrl + '?action=GetKpiTarget&SchemID='+WorkItemFileds.getValue()+'&str='+KpiTargetFileds.getValue()+'&Targetype='+TargetTypeField.getValue(),
	method : 'POST'
					}) 
       KpiTargetDS.load({
					     params:{
							start : 0,
							limit : 10
							}
					});      
    }      
} ,
	editable : true
});
  
 //指标类别 
  	var TargetType = new Ext.data.SimpleStore({
	fields:['rowid','Name'],
	data:[[1,'方案总分'],[2,'方案维度'],[3,'方案指标']]
});
var TargetTypeField = new Ext.form.ComboBox({
	id: 'TargetTypeField',
	fieldLabel: '指标类别',
	width:168,
	listWidth : 205,
	selectOnFocus: true,
	//allowBlank: false,
	store: TargetType,
	anchor: '100%',
	value:'', //默认值
	valueNotFoundText:'',
	displayField: 'Name',
	valueField: 'rowid',
	triggerAction: 'all',
	emptyText:'',
	mode: 'local', //本地模式
	editable:false,
	//pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	listeners: {	//监听事件
	  select:function(){
	     if(TargetTypeField.getValue()==1)
		  {
		  KpiTargetFileds.setValue(-1);
		  KpiTargetFileds.setDisabled(true);
		  }
		  else
		  {
		  WorkItemFileds.setValue("");
		  KpiTargetFileds.setValue("");
		  KpiTargetFileds.setDisabled(false);
		  }
	  }
	 },
	forceSelection:true
});
//奖金指标
var DataInterfStors = new Ext.data.Store({
 autoLoad:true,
 proxy:"",
 reader:new Ext.data.JsonReader({
 totalProperty:'results',
 root:'rows'
 },['rowid', 'Code','Name'])
});

DataInterfStors.on('beforeload',function(ds,o){
    ds.proxy = new Ext.data.HttpProxy({
    url:StratagemTabUrl + '?action=GetDept&str='+DeptFiled.getValue(),
	method : 'POST'
					})
});



var DataInterFileds = new Ext.form.ComboBox({
    id:'DataInterFileds',
	fieldLabel:'奖金指标',
	width:103,
	listWidth:205,
    anchor : '100%',
	allowBlank:true,
	valueField:'rowid',
	displayField:'Name',
	store : DataInterfStors,
	triggerAction : 'all',
	name : 'DataInterFileds',
	emptyText:"",
	minChars:1,
	pageSize:10,
	editable:true,
	selectOnFocus : false,
	forceSelection : 'true',
	editable : true
});
  
 //绩效指标

var KpiTargetDS = new Ext.data.Store({
 //autoLoad:true,
 proxy:"",
 reader:new Ext.data.JsonReader({
 totalProperty:'results',
 root:'rows'
 },['rowid', 'Code','Name'])
});
  

  
 
var KpiTargetFileds = new Ext.form.ComboBox({
    id:'KpiTargetFileds',
	fieldLabel:'绩效指标',
	width:103,
	listWidth:205,
    anchor : '100%',
	allowBlank:true,
	valueField:'rowid',
	displayField:'Name',
	store : KpiTargetDS,
	triggerAction : 'all',
	name : 'KpiTargetFileds',
	emptyText:"",
	minChars:1,
	pageSize:10,
	editable:true,
	selectOnFocus : false,
	forceSelection : 'true',
	editable : true
}); 
  
  var Proportion  = new Ext.form.TextField({
            fieldLabel:"计提比例",
			columnWidth : .1,
			width : 70,
			columnWidth : .12,
			anchor : '100%',
			selectOnFocus : true

		});

/*   	var isTarget = new Ext.form.Checkbox({
						id : 'isTarget',
						labelSeparator : '是否指标:',
						allowBlank : false,
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									addButton.focus();
								}
							}
						}
					});
  */
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 60,
		items: [
		    TargetTypeField,
			DataInterFileds,
			WorkItemFileds,
			KpiTargetFileds,
			Proportion
		]
	});

var addWin = new Ext.Window({
		title: '添加',
		width: 260,
		height: 230,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons:[
			{
				text: '保存',
				handler: function() {
				       	if(TargetTypeField.getValue()==""||TargetTypeField.getValue()==0)
						{
						Ext.Msg.show({title:'警告！', msg:'指标类别不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
						} 
						if(DataInterFileds.getValue()=="")
						{
						Ext.Msg.show({title:'警告！', msg:'奖金指标不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
						} 
						if(WorkItemFileds.getValue()=="")
						{
						Ext.Msg.show({title:'警告！', msg:'绩效方案不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
						}
						if(KpiTargetFileds.getValue()=="")
						{
						Ext.Msg.show({title:'警告！', msg:'绩效指标不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
						}
						if(Proportion.getValue()=="")
						{
						Ext.Msg.show({title:'警告！', msg:'计提比例不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
						}
						//var istarg = (isTarget.getValue()==true)?1:0;
						var data=DataInterFileds.getValue()+"^"+WorkItemFileds.getValue()+"^"+KpiTargetFileds.getValue()+"^"+Proportion.getValue()+"^"+TargetTypeField.getValue();	
						//alert(data);
						request("add",data);
						 DeptWorkDs.load({
					     params:{
							start : 0,
							limit : DeptWorkPagTba.pageSize
							}
					});
				}
			},
			{
				text: '取消',
				handler: function(){
				addWin.close();
				}
			}
		]
		
	});

	addWin.show();
};