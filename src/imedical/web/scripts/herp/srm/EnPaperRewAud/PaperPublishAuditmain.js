var projUrl='herp.srm.SRMEnPaperRewAudexe.csp';
var userdr = session['LOGON.USERCODE'];
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
/**
Ext.Ajax.request({
						url:projUrl+'?action=GetUserID&userdr='+userdr,
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success=='NoOne!'){
								Ext.Msg.show({title:'����',msg:'��û��Ȩ����ˣ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
**/
///////////////////��/////////////////////////////  
var YearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


YearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetYear&str='+encodeURIComponent(Ext.getCmp('YearField').getRawValue()),method:'POST'});
});

var YearField = new Ext.form.ComboBox({
	id: 'YearField',
	fieldLabel: '��',
	width:120,
	listWidth : 260,
	allowBlank : true, 
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	anchor: '95%',
	////emptyText:'��ѡ��ʼʱ��...',
	name: 'YearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

/////////////////��ʼʱ��///////////////////////
var StartDateField = new Ext.form.DateField({
			fieldLabel: '��ʼʱ��',
			width:120,
			allowBlank:false,
			//format:'Y-m-d',
			//columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});

/////////////////����ʱ��///////////////////////		
var EndDateField = new Ext.form.DateField({
			fieldLabel: '����ʱ��',
			width:120,
			allowBlank:false,
			//format:'Y-m-d',
			//columnWidth : .12,	
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});

/////////////////����//////////////////

var DeptDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


DeptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetDept&str='+encodeURIComponent(Ext.getCmp('DeptField').getRawValue()),
	method:'POST'});
});

var DeptField = new Ext.form.ComboBox({
	id: 'DeptField',
	fieldLabel: '����',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:DeptDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ�����...',
	name: 'DeptField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

/////////////////������Ŀ///////////////////
var PaperName = new Ext.form.TextField({
                width: 120,
                allowBlank: true,
                name: 'PaperName',
                fieldLabel: '������Ŀ',
                blankText: '������������Ŀ'
            });

/////////////////�ڿ�����///////////////////

var JournalNameDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


JournalNameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetJournalDict&str='+encodeURIComponent(Ext.getCmp('JournalName').getRawValue()),method:'POST'});
});

var JournalName = new Ext.form.ComboBox({
	id: 'JournalName',
	fieldLabel: '�ڿ�����',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:JournalNameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ���ڿ�����...',
	name: 'JournalName',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});




/////////////////����///////////////////
var FisAuthorDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


FisAuthorDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetAuthor&str='+encodeURIComponent(Ext.getCmp('FisAuthor').getRawValue()),
	method:'POST'});
});

var FisAuthorField = new Ext.form.ComboBox({
	id: 'FisAuthor',
	fieldLabel: '����',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:FisAuthorDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ������...',
	name: 'FisAuthor',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

/////////////////��һͨѶ����///////////////////////////
var ComAuthorDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


ComAuthorDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetAuthor&str='+encodeURIComponent(Ext.getCmp('ComAuthor').getRawValue()),
	method:'POST'});
});

var ComAuthorField = new Ext.form.ComboBox({
	id: 'ComAuthor',
	fieldLabel: '��һͨѶ����',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:ComAuthorDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ���һͨѶ����...',
	name: 'ComAuthor',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

/////////////////��˽��///////////////////////////
var AuditStateStore = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['1','�ȴ�����'],['2','��ͨ��'],['3','δͨ��']]
});

var AuditStateField = new Ext.form.ComboBox({
	id: 'AuditState',
	fieldLabel: '��˽��',
	width:120,
	listWidth : 120,
	allowBlank: true,
	store:AuditStateStore,
	valueField: 'key',
	displayField: 'keyvalue',
	triggerAction: 'all',
	//emptyText:'��ѡ����˽��...',
	mode : 'local',
	name: 'AuditState',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});
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
		           anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true
						  });	
/////////////////��ѯ��ť��Ӧ����//////////////
function SearchFun()
{
	var StartDate= StartDateField.getRawValue();
	var EndDate  = EndDateField.getRawValue();
    var Dept      = DeptField.getValue();
    var PaperNames= PaperName.getValue();
    var JournalNames= JournalName.getRawValue();
    var FisAuthor = FisAuthorField.getValue();
    var ComAuthor = ComAuthorField.getValue();
	var AuditState = AuditStateField.getValue();
	var type = TypeCombox.getValue();
    JournalNames=JournalNames.trim();
    var Year = YearField.getValue();
    itemGrid.load({params:{start:0,limit:25,sortField:'',sortDir:'',
	StartDate:StartDate,EndDate:EndDate,Dept:Dept,PaperNames:PaperNames,
	JournalNames:JournalNames,FisAuthor:FisAuthor,ComAuthor:ComAuthor,
	AuditState:AuditState,userdr:userdr,Type:type,Year:Year}});
	
}

//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel({
	autoHeight : true,
	title : '���ı����뽱�������Ϣ��ѯ',
	iconCls : 'search',	
	region : 'north',
	frame : true,

	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">����</p>',
					width : 60			
				},	
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				TypeCombox,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">���</p>',
					width : 30			
				},	
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				YearField,
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">������Ŀ</p>',
					width : 80			
				},	
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				PaperName,
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">�ڿ�����</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				JournalName,
				{
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
				}
				
				]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">����</p>',
					width : 60			
				},	
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				DeptField,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">����</p>',
					width : 30			
				},	
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				FisAuthorField,
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">��һͨѶ����</p>',
					width : 80			
				},	
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				ComAuthorField,
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">��˽��</p>',
					width : 60			
				},	
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				AuditStateField
	
				]
	},{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
		
		
		
		
		
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">��������</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				StartDateField,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:center;">��</p>',
					width : 30			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				EndDateField,
				{
					xtype : 'displayfield',
					value : '',
					width : 30
				}]
	}]
	
});

/////////////////����ʱ��///////////////////////
var RewardDateField = new Ext.form.DateField({
	        id: 'RewardDateField',
			fieldLabel: '����ʱ��',
			width:120,
			allowBlank:false,
			//format:'Y-m-d',
			//columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});


////////////////////��������/////////////////////////////

var RatioStore = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['0','0'],['0.3','30%'],['0.7','70%'],['1','100%']]
});

var RatioField = new Ext.form.ComboBox({
	id: 'RatioField',
	fieldLabel: '��������',
	width:120,
	//anchor: '95%',
	listWidth : 120,
	allowBlank: true,
	store:RatioStore,
	valueField: 'key',
	displayField: 'keyvalue',
	value:'R',
	triggerAction: 'all',
	//emptyText:'��ѡ��������...',
	mode : 'local',
	name: 'RatioField',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});


//////////////////////////////////////////////

var itemGrid = new dhc.herp.Grid({
			region : 'center',
			title: '���ı����뽱�������Ϣ�б�',
			iconCls: 'list',
			url : projUrl,
			sortInfo: {
             field: 'Title',
             direction: "ASC"
            },
            remoteSort: true, //������������		
			/* listeners:{
	        'cellclick' : function(grid, rowIndex, columnIndex, e) {
	               var record = grid.getStore().getAt(rowIndex);
	               //if (((record.get('CheckState') != '�ȴ�����') &&(columnIndex == 30))||((record.get('IsReward') != 'δ����') &&(columnIndex == 32))||((record.get('IsReward') != 'δ����') &&(columnIndex == 33))) {  
	                if ((record.get('CheckState') != '�ȴ�����') &&(columnIndex == 30)) {      
	                      Ext.Msg.show({title:'ע��',msg:'�����,�����޸�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	                      return false;
	               }else{
	                      return true;
	               }
	        }},    */   
	        		
			fields : [
			 new Ext.grid.CheckboxSelectionModel({editable:false}),
			{
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'Type',
						header : '����',
						width : 40,
						editable:false,
						//hidden:true,
						dataIndex : 'Type'
					},{
						id : 'RecordType',
						header : '����¼���ݿ�',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'RecordType'
					},{
						id : 'JourLevel',
						header : '�ڿ�����',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'JourLevel'
					},{
						id : 'JName',
						header : ' �ڿ�����',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'JName'
					},{
						id : 'PaperType',
						header : '������� ',
						width : 120,
						editable:false,
						hidden:true,
						allowBlank : false,                
						dataIndex : 'PaperType'
					},{
						id : 'Title',
						header : '������Ŀ',
						width : 180,
						editable:false,
						sortable:true,
						allowBlank : false, 
						/*						
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						},
						*/
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+data+'</span>';;
						},						
						dataIndex : 'Title'
					},{
						id : 'CompleteUnit',
						header : '��Ժ��λλ��',
						width : 80,
						editable:false,
						allowBlank : false,
						dataIndex : 'CompleteUnit'
					},{
						id : 'RegInfo',
						header : ' �����ҳ',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'RegInfo'
					},{
						id : 'PubYear',
						header : '��',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'right',
						hidden:true,
						dataIndex : 'PubYear'
					},{
						id : 'Roll',
						header : '��',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'right',
						hidden:true,
						dataIndex : 'Roll'
					},{
						id : 'Period',
						header : '��',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'right',
						hidden:true,
						dataIndex : 'Period'
					},{
						id : 'StartPage',
						header : '��ʼҳ',
						//xtype:'numbercolumn',
						hidden:true,
						width : 120,
						editable : false,
						align:'right',
						dataIndex : 'StartPage'
					},{
						id : 'EndPage',
						header : '����ҳ',
						//xtype:'numbercolumn',
						hidden:true,
						width : 120,
						editable : false,
						align:'right',
						dataIndex : 'EndPage'
					},{
						id : 'FristAuthor',
						header : ' ��һ����',
						//xtype:'numbercolumn',
						width : 80,
						editable : false,
						sortable:true,
						align:'left',
						dataIndex : 'FristAuthor'
					}, {
						id : 'FristAuthorRange',
						header : '��һ��������',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'right',
						hidden:true,
						dataIndex : 'FristAuthorRange'
					},{
						id : 'FristAuthorDept',
						header : ' ��һ���߿���',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'right',
						hidden:true,
						dataIndex : 'FristAuthorDept'
					}, {
						id : 'FristAuthorComp',
						header : '��һ���ߵ�λ',
						width : 120,
						align:'right',
						editable:false,
						hidden:true,
						dataIndex : 'FristAuthorComp'
					},{
						id : 'CorrAuthor',
						header : '��һͨѶ����',
						editable:false,
						width : 80,
						dataIndex : 'CorrAuthor'
					},{
						id : 'CorrAuthorRange',
						header : 'ͨѶ��������',
						editable:false,
						width : 120,
						align:'right',
						hidden:true,
						dataIndex : 'CorrAuthorRange'
					},{
						id : 'CorrAuthorDept',
						header : '��һͨѶ������',
						editable:false,
						width : 120,
						align:'right',
						hidden:true,
						dataIndex : 'CorrAuthorDept'
					},{
						id : 'CorrAuthorComp',
						header : 'ͨѶ���ߵ�λ',
						editable:false,
						width : 120,
						hidden:true,
						align:'right',
						dataIndex : 'CorrAuthorComp'
					},{
						id : 'AllAuthorInfo',
						header : '��������',
						editable:false,
						width : 60,
						hidden:false,
						
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						},
						
						
						dataIndex : 'AllAuthorInfo'
					},{
						id : 'AllCorrAuthorInfo',
						header : '����ͨѶ����',
						editable:false,
						width : 80,
						hidden:false,
						
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						},
						
						
						dataIndex : 'AllCorrAuthorInfo'
					},{
						id : 'IF',
						header : 'Ӱ������',
						hidden:false,
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'IF'
					},{
						id : 'InvoiceCode',
						header : '��Ʊ���� ',
						width : 120,
						editable:false,
						hidden:true,
						allowBlank : false,                
						dataIndex : 'InvoiceCode'
					},{
						id : 'InvoiceNo',
						header : '��Ʊ���� ',
						width : 120,
						editable:false,
						hidden:true,
						allowBlank : false,                
						dataIndex : 'InvoiceNo'
					},{
						id : 'PageCharge',
						header : '�����(Ԫ)',
						editable:false,
						width : 100,
						align:'right',
						sortable:true,	
						dataIndex : 'PageCharge',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
					},{
						id : 'UnitMoney',
						header : '���ҵ�λ',
						editable:false,
						width : 60,
						dataIndex : 'UnitMoney'
					},{
						id : 'Ratio',
						header : '��������',
						editable:true,
						//hidden:true,
						width : 80,
						align:'right',
						dataIndex : 'Ratio',
						type:RatioField
					},{
						id : 'REAmount',
						header : '���������(Ԫ)',
						editable:false,
						width : 100,
						align:'right',
						dataIndex : 'REAmount',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
					},{
						id : 'RewardAmount',
						header : '�������(Ԫ)',
						editable:true,
						width : 100,
						align:'right',
						dataIndex : 'RewardAmount',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
					},{
						id : 'RewardDate',
						header : '����ʱ��',
						editable:true,
						width : 80,
						dataIndex : 'RewardDate',
						type:RewardDateField,
						renderer : function(v, p, r, i) {			
						if (v instanceof Date) {
							return new Date(v).format("Y-m-d");
						} else {return v;}
			          }
			         },{
						id : 'IsReward',
						header : '�Ƿ���',
						editable:false,
						hidden:true,
						//format:'Y-m-d',
						width : 60,
						dataIndex : 'IsReward'
					},{
						id : 'SubUser',
						header : '������',
						editable:false,
						width : 60,
						dataIndex : 'SubUser'
					},{
						id : 'DeptName',
						header : '�����˿���',
						editable:false,
						width : 120,
						dataIndex : 'DeptName',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					},{
						id : 'SubDate',
						header : '����ʱ��',
						hidden:false,
						editable:false,
						width : 80,
						dataIndex : 'SubDate'
					},{
						id : 'DataStatus',
						header : '�ύ״̬',
						editable:false,
						hidden:true,
						width : 120,
						dataIndex : 'DataStatus'
					},{
						id : 'Chercker',
						header : '������',
						editable:false,
						width : 60,
						dataIndex : 'Chercker'
					},{
						id : 'CheckDept',
						header : '�����˿���',
						editable:false,
						hidden:true,
						width : 120,
						dataIndex : 'CheckDept'
					},{
						id : 'CheckDate',
						header : '����ʱ��',
						editable:false,
						width : 80,
						dataIndex : 'CheckDate'
					},{
						id : 'CheckState',
						header : '����״̬',
						editable:false,
						hidden:true,
						width : 120,
						dataIndex : 'CheckState'  
					},{
						id : 'CheckProcDesc',
						header : '�������',
						editable:false,
						width : 100,
						dataIndex : 'CheckProcDesc'  
					},{
						id : 'Desc',
						header : '�������',
						editable:false,
						width : 100,
						dataIndex : 'Desc'
					},{
						id : 'AuthorsInfo',
						header : '��������',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'AuthorsInfo'
					},{
						id : 'CorrAuthorsInfo',
						header : 'ͨѶ��������',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'CorrAuthorsInfo'
					},{
							id:'download',
							header: 'ԭ��',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>����</u></span>';
					    } 
					},{
							id:'download1',
							header: '��¼֤��',
							allowBlank: false,
							width:60,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>����</u></span>';
					    } 
					},{
							id:'ESICited',
							header: '�Ƿ�ESI�߱���',
							allowBlank: false,
							width:40,
							editable:false,
							hidden:true,
							dataIndex: 'ESICited'
					},{
							id:'IsLastStep',
							header: '�Ƿ������������',
							allowBlank: false,
							width:40,
							editable:false,
							hidden:true,
							dataIndex: 'IsLastStep'
					}]
		});

var AuditButton  = new Ext.Toolbar.Button({
		text: '�������ͨ��',  
        id:'auditButton', 
        iconCls: 'pencil',
        handler:function(){
			
		//���岢��ʼ���ж���
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		var checker = session['LOGON.USERCODE'];
		var CheckDesc= rowObj[0].get("CheckDesc")
		
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		for(var j= 0; j < len; j++){
		 if(rowObj[j].get("CheckState")!="�ȴ�����")
		 {
			      Ext.Msg.show({title:'ע��',msg:'���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					
					
					  var Ratio=rowObj[i].get("Ratio");
					  var tmpIsLastStep=rowObj[i].get("IsLastStep");
					   
					  //if((Ratio=="")&&(rowObj[i].get("CheckProcDesc").indexOf("���д�����")>-1))   ���д��������ʱȷ����������
					  if((Ratio=="")&&(tmpIsLastStep=="Y"))
					  {
						Ext.Msg.show({title:'ע��',msg:'��ѡ��������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					  }
							
					    Ext.Ajax.request({
						url:projUrl+'?action=audit&rowid='+rowObj[i].get("rowid")+'&checker='+checker+'&Ratio='+Ratio,
						waitMsg:'�����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'��˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0,limit:12,userdr:userdr}});
								
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
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ��˸�����¼��?',handler);
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
							 if(rowObj[j].get("CheckState")!="�ȴ�����")
							 {
								      Ext.Msg.show({title:'ע��',msg:'���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
								       return;
							 }
						}
						noauditfun();
				   }
  });
  
  var RewardAuditButton  = new Ext.Toolbar.Button({
		text: '�������',  
        id:'RewardAuditButton', 
        iconCls: 'pencil',
        handler:function(){
			
		//���岢��ʼ���ж���
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		var checker = session['LOGON.USERCODE'];

		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		
		
     for(var j= 0; j < len; j++){
	     
	      var RewardState= rowObj[j].get("IsReward")
		   if(rowObj[j].get("IsReward")=="�ѽ���")
		   { 
			      Ext.Msg.show({title:'ע��',msg:'�����ѽ�����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		    }
		    
		    var RewardAmount = rowObj[j].get("RewardAmount")   
		 	  if(rowObj[j].get("RewardAmount")==""){
			     Ext.Msg.show({title:'ע��',msg:'����д�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			     return;
		    }
		    
		   var aaa=rowObj[j].get("CheckProcDesc");
		  
		    if((aaa.indexOf("�ȴ�����")>0)||(aaa.indexOf("��ͨ��")>0))
		  {
			     Ext.Msg.show({title:'ע��',msg:'����δ��˲��ܷ��Ž���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			     return;
		    }
		    
		      var RewardDate=rowObj[j].get("RewardDate");
				 if(RewardDate=="")
				 {
								     Ext.Msg.show({title:'ע��',msg:'��ѡ����ʱ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
								     return;
				 }
					 
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					  var RewardAmount = rowObj[i].get("RewardAmount")   
					     var RewardDate=rowObj[i].get("RewardDate");
					
					      if(rowObj[i].isModified("RewardDate")){
						 
						  var RewardDate=RewardDate.format('Y-m-d');
						  
						  } 
					  Ext.Ajax.request({
						url:projUrl+'?action=rewardaudit&&rowid='+rowObj[i].get("rowid")+'&RewardAmount='+RewardAmount+'&checker='+checker+'&RewardDate='+RewardDate,
						waitMsg:'�����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'��˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0,limit:12,userdr:userdr}});
								
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
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ��˸�����¼��?',handler);
    }
});

  itemGrid.addButton('-');
  itemGrid.addButton(AuditButton);
  itemGrid.addButton('-');
  itemGrid.addButton(NoAuditButton);  
  itemGrid.addButton('-');
  itemGrid.addButton(RewardAuditButton);
  
  itemGrid.btnResetHide(); 	//�������ð�ť
  itemGrid.btnDeleteHide(); //����ɾ����ť
  itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
  itemGrid.btnAddHide(); 	//������Ӱ�ť
  itemGrid.btnSaveHide(); 	//���ر��水ť
 
  itemGrid.load({params:{start:0, limit:25, userdr:userdr}});
  
  
  // ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	
	//  ������Ŀ
	if (columnIndex == 8) {
		PaperDetail(itemGrid);
	}
	//��������
	if (columnIndex == 24) {
		var records = itemGrid.getSelectionModel().getSelections();
		var authorinfo = records[0].get("AuthorsInfo");
		var corrauthorinfo = records[0].get("CorrAuthorsInfo");
		var title = records[0].get("Title");
		//alert(authorinfo);
		AuthorInfoList(title,authorinfo);
	}
	//ͨѶ��������
	if (columnIndex == 25) {
		var records = itemGrid.getSelectionModel().getSelections();
		var corrauthorinfo = records[0].get("CorrAuthorsInfo");
		var title = records[0].get("Title");
		//alert(authorinfo);
		CorrAuthorInfoList(title,corrauthorinfo);
	}
	
	
	
	var records = itemGrid.getSelectionModel().getSelections();
	var state = records[0].get("CheckState");
	
	if(state!="ͨ��")
	{
	  RewardAuditButton.disable();//����Ϊ������
	  return;
	}else{
	   RewardAuditButton.enable();//����Ϊ����
	  return;
	}
	
});

//uploadMainFun(itemGrid,'rowid','P001',22);
//downloadMainFun(itemGrid,'rowid','P002',46);
downloadMainFun(itemGrid,'rowid','P00201',48);
downloadMainFun(itemGrid,'rowid','P00202',49);