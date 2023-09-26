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


//���𷽰�
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
	fieldLabel: '���𷽰�',
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
	
//�����ͺ��㵥Ԫ����
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
//���㵥Ԫ
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
	fieldLabel: '���㵥Ԫ',
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
//����ָ��
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
	fieldLabel: '����ָ��',
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
//������ָ������
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

//���״̬
var StateDs = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['0','δ���'],['1','���']]
});

    
var StateField = new Ext.form.ComboBox({
	id: 'StateField',
	fieldLabel: '���״̬',
	width:80,
	listWidth : 80,
	selectOnFocus: true,
	allowBlank: false,
	store: StateDs,
	//anchor: '90%',
	value:'', //Ĭ��ֵ
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

//�������Դ
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

//����Ĭ�������ֶκ�������
StratagemTabDs.setDefaultSort('rowid', 'desc');

//���ݿ�����ģ��
var StratagemTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.CheckboxSelectionModel(),
	{
	   header:'���𷽰�',
	   dataIndex:'BonusSchemeName',
	   width:100,
	   sortable:true
	   
	 }, {
	   header:'����״̬',
	   dataIndex:'SchemeState',
	   width:100,
	   sortable:true
	   
	 },{
	   header:'������㵥Ԫ',
	   dataIndex:'UnitName',
	   width:100,
	   sortable:true
	   
	 },{
        header:'����ָ������',
		width:150,
		dataIndex:'TargetName',
		sortable:true

    },{
        header: "�����λ",
        dataIndex: 'TargetUnitName',
        width: 80,
        align: 'left',
        sortable: true
		
    },{
        header: "Ŀ��ֵ",
        dataIndex: 'AccountBase',
        width: 80,
        align: 'right',
        sortable: true
		
    },{
        header: "����",
        dataIndex: 'StepSize',
        width: 80,
        align: 'right',
        sortable: true
		
    },{
        header: "���㷽��",
        dataIndex: 'TargetDirection',
        width: 80,
        align: 'left',
        hidden: true,
        sortable: true
		
    },{
        header: "��ʼ�߽�",
        dataIndex: 'StartLimit',
        width: 80,
        align: 'right',
        sortable: true
    },{
        header: "�����߽�",
        dataIndex: 'EndLimit',
        width: 80,
        align: 'right',
        sortable: true
    },{
        header: "����ϵ��",
        dataIndex: 'TargetRate',
        width: 80,
        align: 'right',
        sortable: true
    },{
        header: "����ָ��",
        dataIndex: 'ParameterTargetName',
        width: 150,
        align: 'left',
        sortable: true
    }
    
]);

//��ʼ��Ĭ��������
StratagemTabCm.defaultSortable = true;

//��ѯ��ť
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
    tooltip:'��ѯ',        
    iconCls:'add',
	handler:function(){
	    var BonusSchemeID=Ext.getCmp('SchemeField').getValue();
		//alert(BonusSchemeID);
		var UnitID=Ext.getCmp('UnitField').getValue();
		var TargetID=Ext.getCmp('TargetField').getValue();
		if(BonusSchemeID==""){
				Ext.Msg.show({title:'����',msg:'���𷽰�Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
		StratagemTabDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize,TargetID:TargetID,UnitID:UnitID,BonusSchemeID:BonusSchemeID}});
	}
});

//��Ӱ�ť
var addButton = new Ext.Toolbar.Button({
	text: '���',
    tooltip:'���',        
    iconCls:'add',
	handler:function(){
	

//���𷽰�
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
	fieldLabel: '���𷽰�',
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
							Ext.Msg.show({title:'����',msg:'���𷽰�����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
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
//���㵥Ԫ
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
	fieldLabel: '���㵥Ԫ',
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
							Ext.Msg.show({title:'����',msg:'���㵥Ԫ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
});
//����ָ��
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
	fieldLabel: '����ָ��',
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
							Ext.Msg.show({title:'����',msg:'����ָ�겻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
});
//������ָ������
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

//������λ
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
	fieldLabel: '������λ',
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
							Ext.Msg.show({title:'����',msg:'������λ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
});	
//Ŀ��ֵ	
var AccountBaseField = new Ext.form.TextField({
			id:'AccountBaseField',
			fieldLabel: 'Ŀ��ֵ',
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
//����
	var StepSizeField = new Ext.form.TextField({
			id:'StepSizeField',
			fieldLabel: '����',
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
//���㷽��
var DirectDs = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['1','����'],['-1','����']]
});
var TargetDirectionField = new Ext.form.ComboBox({
	id: 'TargetDirectionField',
	fieldLabel: '���㷽��',
	width:180,
	listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: DirectDs,
	//anchor: '90%',
	value:'', //Ĭ��ֵ
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'',
	mode: 'local', //����ģʽ
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
//��ʼ�߽�
var StartLimitField = new Ext.form.TextField({
			id:'StartLimitField',
			fieldLabel: '��ʼ�߽�',
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
//�����߽�
var EndLimitField = new Ext.form.TextField({
			id:'EndLimitField',
			fieldLabel: '�����߽�',
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
//����ϵ��
var TargetRateField = new Ext.form.TextField({
			id:'TargetRateField',
			fieldLabel: '����ϵ��',
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
//����ָ��
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
	fieldLabel: '����ָ��',
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
//ָ��Ͳ���ָ������
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
		
		//��ʼ�����
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
		
		//��ʼ����Ӱ�ť
		addButton = new Ext.Toolbar.Button({
			text:'�� ��'
		});
		
		//������Ӱ�ť��Ӧ����
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
				Ext.Msg.show({title:'����',msg:'���𷽰�Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(UnitID==""){
				Ext.Msg.show({title:'����',msg:'���㵥ԪΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
	        if(TargetID==""){
				Ext.Msg.show({title:'����',msg:'����ָ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(TargetUnit==""){
				Ext.Msg.show({title:'����',msg:'������λΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(AccountBase==""){
				Ext.Msg.show({title:'����',msg:'Ŀ��ֵΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(StepSize==""){
				Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(ParameterTarget==""){
				Ext.Msg.show({title:'����',msg:'����ָ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			var data=UnitID.trim()+"^"+TargetID.trim()+"^"+TargetUnit.trim()+"^"+AccountBase.trim()+"^"+StepSize.trim()+"^"+TargetDirection.trim()+"^"+StartLimit.trim()+"^"+EndLimit.trim()+"^"+TargetRate.trim()+"^"+ParameterTarget.trim()+"^"+BonusSchemeID.trim();
			//alert(data);
	
			
			Ext.Ajax.request({
				url: '../csp/dhc.bonus.targetcalculaterateexe.csp?action=add&data='+data,
				waitMsg:'������...',
				failure: function(result, request){
					//Handler = function(){codeField.focus();}
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						//Handler = function(){codeField.focus();}
						Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						var BonusSchemeID=Ext.getCmp('SchemeField').getValue();
		                var UnitID=Ext.getCmp('UnitField').getValue();
		                var TargetID=Ext.getCmp('TargetField').getValue();
						StratagemTabDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize,TargetID:TargetID,UnitID:UnitID,BonusSchemeID:BonusSchemeID}});
					}else{
						if(jsonData.info=='RepCode'){
							//Handler = function(){codeField.focus();}
							Ext.Msg.show({title:'����',msg:'��ս��Ŀ������Ѿ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
						if(jsonData.info=='RepName'){
							//Handler = function(){nameField.focus();}
							Ext.Msg.show({title:'����',msg:'��ս��Ŀ�������Ѿ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					}
				},
				scope: this
			});
		}
	
		//��ӱ��水ť�ļ����¼�
		addButton.addListener('click',addHandler,false);
	
		//��ʼ��ȡ����ť
		cancelButton = new Ext.Toolbar.Button({
			text:'ȡ��'
		});
	
		//����ȡ����ť����Ӧ����
		cancelHandler = function(){
			addwin.close();
		}
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//��ʼ������
		addwin = new Ext.Window({
			title: '��Ӽ���ϵ��',
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
	
		//������ʾ
		addwin.show();
	}
});


//�޸İ�ť
var editButton = new Ext.Toolbar.Button({
	text: '�޸�',
    tooltip:'�޸�',        
    iconCls:'add',
	handler:function(){
		//���岢��ʼ���ж���
		var rowObj=StratagemTab.getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
			var state = rowObj[0].get("SchemeState");
			//alert(state);
			if(state=="������"){
				Ext.Msg.show({title:'ע��',msg:'�������ݷ����Ѿ������,���������޸�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return false;
			}
			if(state=="confirm"){
				Ext.Msg.show({title:'ע��',msg:'��ս�����´�,�������ٱ༭!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
	fieldLabel: '���𷽰�',
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
							Ext.Msg.show({title:'����',msg:'Ŀ����벻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
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
//���㵥Ԫ
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
	fieldLabel: '���㵥Ԫ',
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
//����ָ��
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
	fieldLabel: '����ָ��',
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
//������ָ������
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
	
//������λ
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
	fieldLabel: '������λ',
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
	
//Ŀ��ֵ	
var AccountField = new Ext.form.TextField({
			id:'AccountField',
			fieldLabel: 'Ŀ��ֵ',
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
//����
	var StepField = new Ext.form.TextField({
			id:'StepField',
			fieldLabel: '����',
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
//���㷽��
var DirectDs = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['1','����'],['-1','����']]
});
var DirectionField = new Ext.form.ComboBox({
	        id: 'DirectionField',
			fieldLabel: '���㷽��',
			listWidth : 180,
			selectOnFocus: true,
			allowBlank: false,
			store: DirectDs,
			value:'1', //Ĭ��ֵ
			valueNotFoundText:'����',
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			emptyText:'',
			name:'TargetDirection',
			mode: 'local', //����ģʽ
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
//��ʼ�߽�
var StartField = new Ext.form.TextField({
			id:'StartField',
			fieldLabel: '��ʼ�߽�',
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
//�����߽�
var EndField = new Ext.form.TextField({
			id:'EndField',
			fieldLabel: '�����߽�',
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
//����ϵ��
var RateField = new Ext.form.TextField({
			id:'RateField',
			fieldLabel: '����ϵ��',
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
//����ָ��
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
	fieldLabel: '����ָ��',
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
//ָ��Ͳ���ָ������
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
		
		
		//���岢��ʼ�����
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
	
		//������
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
			
/*			if (sTargetDirection=="����") {
				DirectionField.setValue("1");
			}else {
				DirectionField.setValue("-1");
			}*/
			
			
		});
		
		//���岢��ʼ�������޸İ�ť
		var editButton = new Ext.Toolbar.Button({
			text:'�����޸�'
		});
	
		//�����޸İ�ť��Ӧ����
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
				Ext.Msg.show({title:'����',msg:'���𷽰�Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(UnitID==""){
				Ext.Msg.show({title:'����',msg:'���㵥ԪΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
	        if(TargetID==""){
				Ext.Msg.show({title:'����',msg:'����ָ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(TargetUnit==""){
				Ext.Msg.show({title:'����',msg:'������λΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(AccountBase==""){
				Ext.Msg.show({title:'����',msg:'Ŀ��ֵΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(ParameterTarget==""){
				Ext.Msg.show({title:'����',msg:'����ָ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			var data=UnitID.trim()+"^"+TargetID.trim()+"^"+TargetUnit.trim()+"^"+AccountBase.trim()+"^"+StepSize.trim()+"^"+TargetDirection.trim()+"^"+StartLimit.trim()+"^"+EndLimit.trim()+"^"+TargetRate.trim()+"^"+ParameterTarget.trim()+"^"+BonusSchemeID.trim();
			//alert(data);
			Ext.Ajax.request({
				url: '../csp/dhc.bonus.targetcalculaterateexe.csp?action=edit&rowid='+rowid+'&data='+data,
				waitMsg:'������...',
				failure: function(result, request){
					//Handler = function(){codeField.focus();}
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
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
	
		//��ӱ����޸İ�ť�ļ����¼�
		editButton.addListener('click',editHandler,false);
	
		//���岢��ʼ��ȡ���޸İ�ť
		var cancelButton = new Ext.Toolbar.Button({
			text:'ȡ���޸�'
		});
	
		//����ȡ���޸İ�ť����Ӧ����
		cancelHandler = function(){
			editwin.close();
		}
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//���岢��ʼ������
		var editwin = new Ext.Window({
			title: '�޸ļ���ϵ���趨',
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
	
		//������ʾ
		editwin.show();
	}
});

//��˰�ť
/**
var AuButton = new Ext.Toolbar.Button({
	text: '���',
    tooltip:'���',        
    iconCls:'add',
	handler:function(){
		//���岢��ʼ���ж���
		var rowObj=StratagemTab.getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
					waitMsg:'�����...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'ע��',msg:'��˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							StratagemTabDs.load({params:{start:0,limit:StratagemTabPagingToolbar.pageSize}});
						}else{
							Ext.Msg.show({title:'����',msg:'���������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ���Ŀ���¼��?',handler);
	}
});
**/
//ɾ����ť
var DelButton = new Ext.Toolbar.Button({
	text: 'ɾ��',
    tooltip:'ɾ��',        
    iconCls:'add',
	handler:function(){
		//���岢��ʼ���ж���
		var rowObj=StratagemTab.getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		//alert(len);
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
			var state = rowObj[0].get("SchemeState");
			//alert(state);
			if(state=="������"){
				Ext.Msg.show({title:'ע��',msg:'�������ݷ����Ѿ������,������ɾ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return false;
			}
		}
		function handler(id){
			if(id=="yes"){
			for(var i = 0; i < len; i++){
				Ext.Ajax.request({
					url:'../csp/dhc.bonus.targetcalculaterateexe.csp?action=del&rowid='+rowObj[i].get("rowid"),
					waitMsg:'ɾ����...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							var BonusSchemeID=Ext.getCmp('SchemeField').getValue();
		                var UnitID=Ext.getCmp('UnitField').getValue();
		                var TargetID=Ext.getCmp('TargetField').getValue();
						StratagemTabDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize,TargetID:TargetID,UnitID:UnitID,BonusSchemeID:BonusSchemeID}});
						}else{
							Ext.Msg.show({title:'����',msg:'���������,ɾ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪɾ��Ŀ���¼��?',handler);
	}
});

//��ҳ������
var StratagemTabPagingToolbar = new Ext.PagingToolbar({
    store: StratagemTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg: "û�м�¼",
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

//���
var StratagemTab = new Ext.grid.EditorGridPanel({
	title: '����ָ��ϵ������',
	store: StratagemTabDs,
	cm: StratagemTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.CheckboxSelectionModel({singleSelect:false}),
	loadMask: true,
	tbar:['���𷽰�:',SchemeField,'-','���㵥Ԫ:',UnitField,'-','����ָ��:',TargetField,'-',findButton,'-',addButton,'-',editButton,'-',DelButton],
	bbar:StratagemTabPagingToolbar
});


