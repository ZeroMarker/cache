AddFun = function(){


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
    url:StratagemTabUrl + '?action=GetWorkItem',
	method : 'POST'
					})
});
var WorkItemFileds = new Ext.form.ComboBox({
    id:'WorkItemFileds',
	fieldLabel:'Drag名称',
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
	editable : true
});
  
  
  
//数据接口下拉框
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
  
  
  var Proportion  = new Ext.form.TextField({
            fieldLabel:"录入比例",
			columnWidth : .1,
			width : 70,
			columnWidth : .12,
			anchor : '100%',
			selectOnFocus : true

		});
  //for (var i in window.document)
  //document.writeln(i);
 
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 60,
		items: [
			WorkItemFileds,
			DataInterFileds,
			Proportion
		]
	});

var addWin = new Ext.Window({
		title: '添加',
		width: 250,
		height: 180,
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
				        if(WorkItemFileds.getValue()=="")
						{
						Ext.Msg.show({title:'警告！', msg:'Drag名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
						}
						var data=WorkItemFileds.getValue()+"^"+DataInterFileds.getValue()+"^"+Proportion.getValue();	
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
				//alert(WorkItemFileds.fieldLabel);
				//Ext.getCmp('WorkItemFileds').destroy();//把它destroy就可以了
				//Ext.getCmp('DeptFileds').destroy();//把它destroy就可以了
				addWin.close();
				}
			}
		]
		
	});

	addWin.show();

};
