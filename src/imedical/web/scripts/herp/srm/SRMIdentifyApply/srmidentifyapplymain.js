var usercode = session['LOGON.USERCODE'];


var groupdesc = session['LOGON.GROUPDESC'];
if (groupdesc=="���й���ϵͳ(��Ϣ�޸�)")
{ var usercode=""
	}
if (groupdesc=="���й���ϵͳ(��Ϣ��ѯ)")
{ var usercode=""
	}
	
var projUrl='herp.srm.srmidentifyapplyexe.csp';

Date.dayNames = ["��", "һ", "��", "��", "��", "��", "��"];  
    Date.monthNames=["1��","2��","3��","4��","5��","6��","7��","8��","9��","10��","11��","12��"];  
    if (Ext.DatePicker) {  
        Ext.apply(Ext.DatePicker.prototype, {  
            todayText: "����",  
            minText: "��������С����֮ǰ",  
            maxText: "�������������֮��",  
            disabledDaysText: "",  
            disabledDatesText: "",  
            monthNames: Date.monthNames,  
            dayNames: Date.dayNames,  
            nextText: '���� (Control+Right)',  
            prevText: '���� (Control+Left)',  
            monthYearText: 'ѡ��һ���� (Control+Up/Down ���ı���)',  
            todayTip: "{0} (Spacebar)",  
            okText: "ȷ��",  
            cancelText: "ȡ��" 
        });  
 }  
 ///////////////////����/////////////////////////////  
var TypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '����'],['2', '��ѧ']]
	});		
		
var TypeCombox = new Ext.form.ComboBox({
	                   id : 'TypeCombox',
		           fieldLabel : '����',
	                   width : 120,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : TypeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true
});		
/////////////////������ʼ����///////////////////////
var StartDateField = new Ext.form.DateField({
			fieldLabel: '��ʼ����',
			width:120,
			//format:'Y-m-d',
			//columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});
/////////////////������������///////////////////////
var EndDateField = new Ext.form.DateField({
			fieldLabel: '��������',
			width:120,
			//format:'Y-m-d',
			//columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});

/////////////////������///////////////////
var ParticipantDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


ParticipantDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetUser&str='+encodeURIComponent(Ext.getCmp('ParticipantField').getRawValue()),
	method:'POST'});
});

var ParticipantField = new Ext.form.ComboBox({
	id: 'ParticipantField',
	fieldLabel: '������',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:ParticipantDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	// emptyText:'��ѡ�������...',
	name: 'Patentees',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


/////////////////����///////////////////
var NameField = new Ext.form.TextField({
                width: 120,
                allowBlank: true,
                name: 'NameField',
                fieldLabel: '����',
                blankText: '����������.....'
            });


/////////////////������λ///////////////////////////
var IdentifyUnitDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


IdentifyUnitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetUint&str='+encodeURIComponent(Ext.getCmp('IdentifyUnitField').getRawValue()),
	method:'POST'});
});

var IdentifyUnitField = new Ext.form.ComboBox({
	id: 'IdentifyUnitField',
	fieldLabel: '������λ',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:IdentifyUnitDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	// emptyText:'��ѡ�������λ...',
	name: 'Inventorss',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
///////////////////��������
var IdentifyLevelStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '�����Ƚ�'], ['2', '��������'], ['3', '�����Ƚ�'], ['4', '��������']]
		});
var IdentifyLevelField = new Ext.form.ComboBox({
			fieldLabel : '��������',
			width : 120,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : true,
			store : IdentifyLevelStore,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			// emptyText : '',
			mode : 'local', // ����ģʽ
			editable : true,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
/////////////////��ѯ��ť��Ӧ����//////////////
function SearchFun()
{			
	  var startdate= StartDateField.getRawValue();
	  var enddate= EndDateField.getRawValue()
	  if(startdate!=""){
			//startdate.format("Y-m-d");
		};
	  if(enddate!=""){
			//enddate.format("Y-m-d");
		};
	var Title  = NameField.getValue();
    var Participant = ParticipantField.getValue();
    var IdentifyLevel = IdentifyLevelField.getValue();
    var IdentifyUnit = IdentifyUnitField.getValue();
    var Type = TypeCombox.getValue();
	
	itemGrid.load({params:{start:0,limit:25,startdate:startdate,enddate:enddate,Title:Title,Participant:Participant,IdentifyLevel:IdentifyLevel,IdentifyUnit:IdentifyUnit,usercode:usercode,Type:Type}});
	
}

//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel({
	autoHeight : true,
	region : 'north',
	frame : true,
	iconCls : 'search',	
	title : '���м��������ѯ',
	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">����</p>',
				//columnWidth : .08
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},TypeCombox,{
				xtype:'displayfield',
				value:'',
				width:10
				},{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">��Ŀ����</p>',
				//columnWidth : .08
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},NameField,{
				xtype:'displayfield',
				value:'',
				width:10
				},{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">��������</p>',
				//columnWidth : .08
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},StartDateField,{
				xtype:'displayfield',
				value:'',
				width:10
				},{
				xtype:'displayfield',
				value:'<p style="text-align:center;">��</p>',
				width:20
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},EndDateField,{
				xtype:'displayfield',
				value:'',
				width:30
				},{
				//columnWidth:0.06,
				width:30,
				xtype:'button',
				text: '��ѯ',
				handler:function(b){SearchFun();},
				iconCls: 'search'
				}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">������</p>',
				//columnWidth : .08
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},ParticipantField,{
				xtype:'displayfield',
				value:'',
				width:10
				},{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">������λ</p>',
				//columnWidth : .08
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},IdentifyUnitField,
				{
				xtype:'displayfield',
				value:'',
				width:10
				},{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">��������</p>',
				//columnWidth : .08
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},IdentifyLevelField]
	}]
	
});

////"rowid^YearName^Name^ParticipantInfo^IdentifyLevel^IdentifyUnit^IdentifyDate^CompleteUnit^SubUser^SubDate^DataStatus^ResAudit^Auditor^AuditDate^Remark^YearDR^ParticipantDRs^IdentifyUnitDR^SubUserDR^AuditorDR"
var itemGrid = new dhc.herp.Grid({
			region : 'center',
			title: '���м��������ѯ�б�',
			iconCls: 'list',
			url : projUrl,					
			fields : [
			 new Ext.grid.CheckboxSelectionModel({
				 hidden:true,
				 editable:false
				 
				 }),
			{
						header:'ID',
						dataIndex:'rowid',
						align:'center',
						hidden:true
					},{
						id:'Type',
						header:'����',
						width:40,
						editable:false,
						allowBlank:false,
						align:'left',
						dataIndex:'Type'
					},{
						id:'YearName',
						header:'��� ',
						width:60,
						editable:false,
						allowBlank:false,
						align:'left',
						dataIndex:'YearName'
					},{
						id:'Name',
						header:'��Ŀ����',
						width:150,
						editable:false,
						align:'left',
						dataIndex:'Name',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
						id:'ParticipantInfo',
						header:'������λ����Ϣ',
						width:100,
						editable:false,
						align:'left',
						hidden:false,
						dataIndex:'ParticipantInfo',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						}
					},{
							id:'upload',
							header: '����֤��',
							allowBlank: false,
							width:60,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>�ϴ�</u></span>';
							}
					},{
							id:'download',
							header: '����',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>����</u></span>';
					    } },{
						id:'DataStatus',
						header:'�ύ״̬',
						//xtype:'numbercolumn',
						width : 60,
						editable:false,
						align:'left',
						dataIndex:'DataStatus'

					},{
						id:'ResAudit',
						header:'���״̬',
						width:80,
						editable:false,
						align:'left',
						dataIndex:'ResAudit'

					},{
						id:'ResDesc',
						header:'���˵��',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'ResDesc',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
						id:'IdentifyLevel',
						header:'��������',
						width:60,
						editable:false,
						align:'left',
						dataIndex:'IdentifyLevel'
					},{
						id:'IdentifyUnit',
						header:'������λ',
						width:180,
						editable:false,
						align:'left',
						dataIndex:'IdentifyUnit',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					}, {
						id:'IdentifyDate',
						header:'��������',
						width:80,
						editable:false,
						align:'left',
						dataIndex:'IdentifyDate'
					}, {
						id:'CompleteUnit',
						header:'��Ժ��λλ��',
						width:100,
						editable:false,
						align:'center',
						hidden:true,
						dataIndex:'CompleteUnit'
					},{
						id:'SubUser',
						header:'������',
						width:60,
						editable:false,
						align:'left',
						dataIndex:'SubUser'
					},{
						id:'SubDate',
						header:'����ʱ��',
						width:80,
						editable:false,
						align:'left',
						dataIndex:'SubDate'

					},{
						id:'Auditor',
						header:'�����',
						width:60,
						editable:false,
						align:'left',
						dataIndex:'Auditor'

					},{
						id:'AuditDate',
						header:'���ʱ��',
						width:80,
						editable:false,
						align:'left',
						hidden:false,
						dataIndex:'AuditDate'

					},{
						id:'Remark',
						header:'��ע',
						width:120,
						editable:false,
						align:'left',
						dataIndex:'Remark',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
						id:'ParticipantDRs',
						header:'������IDs',
						width:120,
						editable:false,
						align:'center',
						hidden:'true',
						dataIndex:'ParticipantDRs'

					},{
						id : 'PrjName',
						header : '���л�������',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'PrjName'
					},{
						header : '�������п��п���(Ժ��)',
						dataIndex : 'OutPrjName',
						hidden : true
					}
				]
		});


///////////////////��Ӱ�ť///////////////////////
var addPatentInfoButton = new Ext.Toolbar.Button({
		text: '����',    
    	iconCls:'edit_add',
		handler: function(){addFun();}
});

/////////////////�޸İ�ť/////////////////////////
var editPatentInfoButton  = new Ext.Toolbar.Button({
		text: '�޸�',        
		iconCls:'pencil',
		handler: function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length; 
			if(len < 1)
			{
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				var state = rowObj[0].get("DataStatus");	
				var participantids = rowObj[0].get("ParticipantDRs");		
				if((state == "δ�ύ")||(groupdesc=="���й���ϵͳ(��Ϣ�޸�)" ) ){editFun(participantids);}				
				else {Ext.Msg.show({title:'����',msg:'�������ύ���������޸ģ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}
			}
});

////////////////ɾ����ť//////////////////////////
var delPatentInfoButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		iconCls:'edit_remove',
		handler: function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if(len<1){
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫɾ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				for(var i = 0; i < len; i++){
				var state = rowObj[i].get("DataStatus");			
				if(state == "δ�ύ" ){delFun();}
				else {Ext.Msg.show({title:'����',msg:'�������ύ������ɾ����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}
});

///////////////�ύ��ť//////////////////////////
var subPatentInfoButton = new Ext.Toolbar.Button({
		text:'�ύ',
		iconCls:'pencil',
		handler:function(){subFun();}	
});


  itemGrid.addButton('-');
  itemGrid.addButton(addPatentInfoButton);
  itemGrid.addButton('-');
  itemGrid.addButton(editPatentInfoButton);
  itemGrid.addButton('-');
  itemGrid.addButton(delPatentInfoButton);
  itemGrid.addButton('-');
  itemGrid.addButton(subPatentInfoButton);



  itemGrid.btnResetHide(); 	//�������ð�ť
  itemGrid.btnDeleteHide(); //����ɾ����ť
  itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
  itemGrid.btnAddHide(); 	//������Ӱ�ť
  itemGrid.btnSaveHide(); 	//���ر��水ť
  itemGrid.load({params:{start:0, limit:12, usercode:usercode}});
  
 // ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//��������
	if (columnIndex == 6) {
		var records = itemGrid.getSelectionModel().getSelections();
		var authorinfo = records[0].get("ParticipantDRs");
		var title = records[0].get("Name");
		AuthorInfoList(title,authorinfo);
	}
	/**
	if (columnIndex == 19) {
		var records = itemGrid.getSelectionModel().getSelections();
		var state = records[0].get("DataStatus");
		//alert(state);
		if (state=="���ύ"){Ext.Msg.show({title:'����',msg:'�������ύ���������ϴ�������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}
		else{uploadMainFun(itemGrid,'rowid','P008',19);}
	}**/
}); 

if (groupdesc=="���й���ϵͳ(��Ϣ�޸�)")
{
	 addPatentInfoButton.disable();//����Ϊ������
	  delPatentInfoButton.disable();//����Ϊ������
	  subPatentInfoButton.disable();//����Ϊ������
}
if (groupdesc=="���й���ϵͳ(��Ϣ��ѯ)")
{
	 addPatentInfoButton.disable();//����Ϊ������
	 editPatentInfoButton.disable();//����Ϊ������
	  delPatentInfoButton.disable();//����Ϊ������
	  subPatentInfoButton.disable();//����Ϊ������
}

uploadMainFun(itemGrid,'rowid','P008',7);
downloadMainFun(itemGrid,'rowid','P008',8);
