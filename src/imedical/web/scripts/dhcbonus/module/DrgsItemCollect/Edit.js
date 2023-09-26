function EditFun(rowObj){

var RowId = rowObj[0].get("rowid");
var BonsTargetId = "";
var DragId = "";

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
	listeners: {	//监听事件
		select:function(){
		DragId = WorkItemFileds.getValue();
		}
	 },
	editable : true
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
	listeners: {	//监听事件
		select:function(){
		BonsTargetId = DataInterFileds.getValue();
		}
	 },
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
 WorkItemFileds.setValue(rowObj[0].get("DragName"));
 DataInterFileds.setValue(rowObj[0].get("BonusTarget"));
 Proportion.setValue(rowObj[0].get("InputProport"));
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
		title: '修改',
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
						var data=DragId+"^"+BonsTargetId+"^"+Proportion.getValue()+"^"+RowId;	
						request("edit",data);
						 DeptWorkDs.load({
					     params:{
							start : 0,
							limit : DeptWorkPagTba.pageSize
							}
					});
					addWin.close();
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

}