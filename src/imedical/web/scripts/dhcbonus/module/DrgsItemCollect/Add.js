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
	fieldLabel:'Drag����',
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
  
  
  
//���ݽӿ�������
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
	fieldLabel:'����ָ��',
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
            fieldLabel:"¼�����",
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
		title: '���',
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
				text: '����',
				handler: function() {
				        if(WorkItemFileds.getValue()=="")
						{
						Ext.Msg.show({title:'���棡', msg:'Drag���Ʋ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
				text: 'ȡ��',
				handler: function(){
				//alert(WorkItemFileds.fieldLabel);
				//Ext.getCmp('WorkItemFileds').destroy();//����destroy�Ϳ�����
				//Ext.getCmp('DeptFileds').destroy();//����destroy�Ϳ�����
				addWin.close();
				}
			}
		]
		
	});

	addWin.show();

};
