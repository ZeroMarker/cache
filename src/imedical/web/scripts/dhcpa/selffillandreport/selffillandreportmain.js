var userId = session['LOGON.USERID'];
var projUrl='dhc.pa.selffillandreportexe.csp'   
var fm = Ext.form;
//---------------------------------------------------------------------------------
var dataStr="";
var data="";
var data1=[['01','01��'],['02','02��'],['03','03��'],['04','04��'],['05','05��'],['06','06��'],['07','07��'],['08','08��'],['09','09��'],
['10','10��'],['11','11��'],['12','12��']];
var data2=[['01','01����'],['02','02����'],['03','03����'],['04','04����']];
var data3=[['01','1~6�ϰ���'],['02','7~12�°���']];
var data4=[['0','00']];

//���
var yearField= new Ext.form.TextField({
                id:'yearField',
                value: "2015",//(new Date()).getFullYear(),
                width: 50,
                triggerAction: 'all',
                allowBlank: false,
                fieldLabel: '���',
				emptyText:'ѡ�������...',
                name: 'yearField',
                allowBlank: false ,
                regex:/^\d{4}$/,
                regexText:"ֻ�������������",
                editable:true                			
});

//�ڼ�����
var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','��'],['Q','��'],['H','����'],['Y','��']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '�ڼ�����',
	width:80,
	listWidth : 80,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
	anchor: '90%',
	value: 'M', 
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'ѡ���ڼ�����...',
	mode: 'local', //����ģʽ
	editable:false,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true,
	listeners:{"select":function(combo,record,index){ 
		DeptSchemDs.removeAll();   
        DeptSchemField.setValue('');
        DeptSchemDs.proxy = new Ext.data.HttpProxy({url:projUrl+'?action=listdeptschem&userId='+userId+'&frequency='+encodeURIComponent(Ext.getCmp('periodTypeField').getValue()),method:'POST'});
		DeptSchemDs.load({params:{start:0,limit:10}});
	}}   
});

periodTypeField.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){data=data1;}
	if(cmb.getValue()=="Q"){data=data2;}
	if(cmb.getValue()=="H"){data=data3;}
	if(cmb.getValue()=="Y"){data=data4;}
	periodStore.loadData(data);
	searchFun(cmb.getValue());
});

//�ڼ�
var periodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});
periodStore.loadData([['01','01��'],['02','02��'],['03','03��'],['04','04��'],['05','05��'],['06','06��'],['07','07��'],['08','08��'],['09','09��'],['10','10��'],['11','11��'],['12','12��']]);
var periodField = new Ext.form.ComboBox({
	id: 'periodField',
	fieldLabel: '',
	width:80,
	listWidth : 80,
	selectOnFocus: true,
	allowBlank: false,
	store: periodStore,
	anchor: '90%',
	value:'01', 
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'��ѡ��...',
	mode: 'local', //����ģʽ
	editable:false,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});


//�ڼ�����뷽����ѯ�Ķ�����������
function searchFun(periodType){
	periodField.setValue("");
	periodField.setRawValue("");
	
};

//ѡ���Բ�
var DeptSchemDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

DeptSchemDs.on('beforeload', function(ds, o){
	var periodType=periodTypeField.getValue();	
	var frequency = periodTypeField.getValue();
	ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.selffillandreportexe.csp?action=listdeptschem&userId='+userId+'&frequency='+frequency,method:'POST'})
	
});

var DeptSchemField = new Ext.form.ComboBox({
	id: 'DeptSchemField',
	fieldLabel:'ѡ���Բ�',
	width:200,
	listWidth : 200,
	allowBlank: false,
	store: DeptSchemDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ���Բ�...',
	name: 'DeptSchemField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

DeptSchemField.on('select', function(combo,record,index){ 	
        //alert("aa");	
		deptDs.removeAll();   
        deptField.setValue('');
        deptDs.proxy = new Ext.data.HttpProxy({url: projUrl+'?action=listdept&userId='+userId+'&DschemDr='+Ext.getCmp('DeptSchemField').getValue(),method:'POST'});
		deptDs.load({params:{start:0,limit:10}});	
	});
//Ȩ�޿���
var deptDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

deptDs.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url: projUrl+'?action=listdept&userId='+userId+'&DschemDr='+DeptSchemField.getValue(),method:'POST'});
	
});

var deptField = new Ext.form.ComboBox({
	id: 'deptField',
	fieldLabel:'Ȩ�޿���',
	width:200,
	listWidth : 200,
	allowBlank: false,
	store: deptDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ�����...',
	name: 'deptField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	listeners:{"select":function(combo,record,index){ 		
		search();	
			
	}}   
});

//��ѯ���
var autohisoutmedvouchForm = new Ext.form.FormPanel({
		//title:'�Բ��',
		region:'north',
		frame:true,
		labelWidth:100,
		height:90,
		items:[{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				isFormField:true,
				items:[{columnWidth:.9,xtype: 'displayfield',value: '<font size="5px"><center>�� �� �� ��</center></font>'}]
			},{
			xtype: 'panel',
			layout:"column",
			hideLabel:true,
			isFormField:true,
			labelWidth:100,
			items:[
					{xtype:'label',text: '���:',style:'margin:2px 5px 0px 10px;'},
					yearField,
					{xtype:'label',text: '�ڼ�����:',style:'margin:2px 5px 0px 5px;'},
					periodTypeField,
					{xtype:'label',text: '�ڼ�:',style:'margin:2px 5px 0px 5px;'},
					periodField,
					{xtype:'label',text: 'ѡ���Բ�:',style:'margin:2px 5px 0px 5px;'},
					DeptSchemField,
					{xtype:'label',text: 'Ȩ�޿���:',style:'margin:2px 5px 0px 5px;'},
					deptField,
					{xtype:'button',id:'sumBtn',text: '�ύ',style:'margin:2px 10px 0px 5px;',name: 'gb',tooltip: '�ύ',iconCls: 'remove', handler:function(){submitHandler()}},
					{xtype:'button',id:'uploadBtn',text: '�ϴ�',name: 'gb',tooltip: '�ϴ�',iconCls: 'remove', handler:function(){cancelsubmit()}}   
					
					
				]
			}
		]
});
var year ="";
var frequency ="";
var acuttypeitem ="";
var DschemDr ="";
var deptDr = "";

////=====================================�̶�ͷ=========================================//

var editStore={};
var columnArry=[];

var sm = new Ext.grid.CheckboxSelectionModel(); 
var editCm = new Ext.grid.ColumnModel({
	defaults: {
		sortable: true          
	},
	columns: columnArry
});
//===========================�༭���====================================
var editGrid = new Ext.grid.EditorGridPanel({
	store: editStore,
	cm: editCm,
	sm:sm,
	border:1,
	//frame: true,
	region:'center',
	autoScroll:true,
	clicksToEdit: 1
	
});

cancelsubmit = function(){
		
		var deptDr = deptField.getValue()
	//alert(deptDr);
	if (deptDr!=0){
			uploadMainFun(editGrid,'deptDr',deptDr);//�����ϴ�wenjian
			}
			else{
				Ext.Msg.show({title:'ע��',msg:'Ȩ�޿���Ϊ�ղ������ϴ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;	}
			
			
	
}

