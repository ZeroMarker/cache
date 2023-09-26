function EditFun(rowObj){

var RowId = rowObj[0].get("rowid");
var BonsTargetId= rowObj[0].get("BonusTargetID");
var PaSchemID = rowObj[0].get("PaSchemID");
var PiTargetID= rowObj[0].get("PiTargetID");
//var IsTarget  = (rowObj[0].get("IsTarget")=="��")?1:0;

//��Ч����
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
    url:StratagemTabUrl + '?action=GetPaScheme&str='+WorkItemFileds.getValue(),
	method : 'POST'
					})
});
var WorkItemFileds = new Ext.form.ComboBox({
    id:'WorkItemFileds',
	fieldLabel:'��Ч����',
	width:125,
	listWidth:205,
	anchor : '100%',
	allowBlank:true,
	valueField:'rowid',
	displayField:'Name',
	store : WorkItemStors,
	triggerAction : 'all',
	name : 'WorkItemFileds',
	emptyText:"",
	minChars:1,
	pageSize:10,
	editable:true,
	selectOnFocus : false,
	forceSelection : 'true',
	listeners: {	//�����¼�
		select:function(){
		PaSchemID = WorkItemFileds.getValue();
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
	 },
	editable : true
});
  
  //ָ����� 
 var TargetType = new Ext.data.SimpleStore({
	fields:['rowid','Name'],
	data:[[1,'�����ܷ�'],[2,'����ά��'],[3,'����ָ��']]
});
var TargetTypeField = new Ext.form.ComboBox({
	id: 'TargetTypeField',
	fieldLabel: 'ָ�����',
	width:168,
	listWidth : 205,
	selectOnFocus: true,
	//allowBlank: false,
	store: TargetType,
	anchor: '100%',
	value:'', //Ĭ��ֵ
	valueNotFoundText:'',
	displayField: 'Name',
	valueField: 'rowid',
	triggerAction: 'all',
	emptyText:'',
	mode: 'local', //����ģʽ
	editable:true,
	//pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	listeners: {	//�����¼�
	  select:function(){
	     if(TargetTypeField.getValue()==1)
		  {
		  PiTargetID = -1;
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
  
//����ָ��
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
	listeners: {	//�����¼�
		select:function(){
		BonsTargetId = DataInterFileds.getValue();
		}
	 },
	editable : true
});
  
 //��Чָ��

var KpiTargetDS = new Ext.data.Store({
 autoLoad:true,
 proxy:"",
 reader:new Ext.data.JsonReader({
 totalProperty:'results',
 root:'rows'
 },['rowid', 'Code','Name'])
});
  
var KpiTargetFileds = new Ext.form.ComboBox({
    id:'KpiTargetFileds',
	fieldLabel:'��Чָ��',
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
	listeners: {	//�����¼�
		select:function(){
		PiTargetID = KpiTargetFileds.getValue();
		}
	 },
	editable : true
}); 
  
  var Proportion  = new Ext.form.TextField({
            fieldLabel:"�������",
			columnWidth : .1,
			width : 70,
			columnWidth : .12,
			anchor : '100%',
			selectOnFocus : true

		});
  
/*   
  	var isTarget = new Ext.form.Checkbox({
						id : 'isTarget',
						labelSeparator : '�Ƿ�ָ��:',
						allowBlank : false,
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									addButton.focus();
								}
							}
						}
					}); */

 DataInterFileds.setValue(rowObj[0].get("BonusTarget"));
 WorkItemFileds.setValue(rowObj[0].get("PaSchem"));
 KpiTargetFileds.setValue(rowObj[0].get("PiTarget"));
 Proportion.setValue(rowObj[0].get("Proportion"));
 TargetTypeField.setValue(rowObj[0].get("TargetTypeID"));
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
		title: '�޸�',
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
				text: '����',
				handler: function() {
				    
				       if(TargetTypeField.getValue()==""||TargetTypeField.getValue()==0)
						{
					
						Ext.Msg.show({title:'���棡', msg:'ָ�������Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
						} 
						if(DataInterFileds.getValue()=="")
						{
						Ext.Msg.show({title:'���棡', msg:'����ָ�겻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
						} 
						if(WorkItemFileds.getValue()=="")
						{
						Ext.Msg.show({title:'���棡', msg:'��Ч��������Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
						}
						if(KpiTargetFileds.getValue()=="")
						{
						Ext.Msg.show({title:'���棡', msg:'��Чָ�겻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
						}
						if(Proportion.getValue()=="")
						{
						Ext.Msg.show({title:'���棡', msg:'�����������Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
						}
						//var istarg = (isTarget.getValue()==true)?1:0;
						var data=BonsTargetId+"^"+PaSchemID+"^"+PiTargetID+"^"+Proportion.getValue()+"^"+TargetTypeField.getValue()+"^"+RowId;	
						//alert(data);
						request("edit",data);
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
				addWin.close();
				}
			}
		]
		
	});

	addWin.show();

}