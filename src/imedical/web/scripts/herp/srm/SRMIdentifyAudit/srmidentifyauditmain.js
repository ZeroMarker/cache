var usercode = session['LOGON.USERCODE'];
var projUrl = 'herp.srm.srmidentifyauditexe.csp';

var SearchUrl = 'herp.srm.srmidentifyapplyexe.csp';

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
	url:SearchUrl+'?action=GetUser&str='+encodeURIComponent(Ext.getCmp('ParticipantField').getRawValue()),
	method:'POST'});
});

var ParticipantField = new Ext.form.ComboBox({
	id: 'ParticipantField',
	fieldLabel: '������Ա',
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
                fieldLabel: '��Ŀ����',
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
	url:SearchUrl+'?action=GetUint&str='+encodeURIComponent(Ext.getCmp('IdentifyUnitField').getRawValue()),
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
			// emptytext : '',
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
	  var startdate= StartDateField.getValue();
	  var enddate= EndDateField.getValue()
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
    var  Type = TypeCombox.getValue();
	
	itemGrid.load({params:{start:0,limit:25,startdate:startdate,enddate:enddate,Title:Title,Participant:Participant,IdentifyLevel:IdentifyLevel,IdentifyUnit:IdentifyUnit,usercode:usercode,Type:Type}});
	
}

//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel({
	region : 'north',
	frame : true,
	autoHeight : true,
	iconCls : 'search',	
	title : '���м�����˲�ѯ',
	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [ {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">����</p>',
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
					xtype : 'displayfield',
					value : '',
					width : 30
				},		
				{
					xtype : 'button',
					text : '��ѯ',
					handler : function(b){SearchFun();},
					iconCls : 'search',
					width : 30
				}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">������</p>',
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
			title: '���м�����˲�ѯ�б�',
			iconCls: 'list',
			url : projUrl,			
			fields : [
			 new Ext.grid.CheckboxSelectionModel({editable:false}),
			{
						header:'ID',
						dataIndex:'rowid',
						align:'center',
						hidden:true
					},{
						id:'Type',
						header:'���� ',
						width:40,
						editable:false,
						allowBlank:false,
						align:'left',
						dataIndex:'Type'
					}, {
						id:'YearName',
						header:'��� ',
						width:60,
						editable:false,
						allowBlank:false,
						align:'left',
						dataIndex:'YearName'
					}, {
						id:'Name',
						header:'��Ŀ����',
						width:180,
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
						header:'������Աλ����Ϣ',
						width:100,
						editable:false,
						align:'left',
						hidden:false,
						dataIndex:'ParticipantInfo',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
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
						id:'DataStatus',
						header:'�ύ״̬',
						//xtype:'numbercolumn',
						width : 80,
						editable:false,
						hidden:'true',
						align:'center',
						dataIndex:'DataStatus'

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
						id:'ResAudit',
						header:'���״̬',
						width:80,
						editable:false,
						align:'left',
						dataIndex:'ResAudit'

					},{
						id:'ResDesc',
						header:'���˵��',
						width:120,
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
						id:'Remark',
						header:'��ע',
						width:100,
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

					}]
		});


var AuditButton = new Ext.Toolbar.Button({
	text: 'ͨ��',  
	iconCls: 'pencil',
    handler:function(){
	//���岢��ʼ���ж���
	var checker = session['LOGON.USERCODE'];
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//���岢��ʼ���ж��󳤶ȱ���
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	for(var j= 0; j< len; j++){
	     //alert(rowObj[j].get("RewardAmount"))
	   if(rowObj[j].get("ResAudit")!='�ȴ�����')
	 {
		      Ext.Msg.show({title:'ע��',msg:'���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
	 }
	}
	function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    Ext.Ajax.request({
						url:projUrl+'?action=audit&&rowid='+rowObj[i].get("rowid")+'&usercode='+checker,
						waitMsg:'�����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},   
						success: function(result, request){			
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'��˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:12,usercode:checker}});								
							}else{
							Ext.Msg.show({title:'����',msg:'���ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						    }
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ�����ѡ��¼��?��˺����޸�',handler);
    }
});


var NoAuditButton = new Ext.Toolbar.Button({
				text : '��ͨ��',
				iconCls: 'pencil',
				handler : function() {
					var rowObj=itemGrid.getSelectionModel().getSelections();
					var len = rowObj.length;
					if(len < 1){
						Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}
					for(var j= 0; j < len; j++){
						if(rowObj[j].get("ResAudit")!='�ȴ�����')
	       {
		      Ext.Msg.show({title:'ע��',msg:'���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
	       }else
						{noauditfun();}
					}
					
					
			   }
});

	itemGrid.addButton('-');
	itemGrid.addButton(AuditButton);
	itemGrid.addButton('-');
	itemGrid.addButton(NoAuditButton);

  itemGrid.btnResetHide(); 	//�������ð�ť
  itemGrid.btnDeleteHide(); //����ɾ����ť
  itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
  itemGrid.btnAddHide(); 	//������Ӱ�ť
  itemGrid.btnSaveHide(); 	//���ر��水ť
  itemGrid.load({params:{start:0, limit:12, usercode:usercode}});
 
 // ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//��������
	if (columnIndex ==6) {
		var records = itemGrid.getSelectionModel().getSelections();
		var authorinfo = records[0].get("ParticipantDRs");
		var title = records[0].get("Name");
		AuthorInfoList(title,authorinfo);
	}
}); 

//uploadMainFun(itemGrid,'rowid','P005',24);
downloadMainFun(itemGrid,'rowid','P008',7);