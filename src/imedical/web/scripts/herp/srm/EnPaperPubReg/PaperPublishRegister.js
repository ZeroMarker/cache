
var userdr = session['LOGON.USERCODE'];

var groupdesc = session['LOGON.GROUPDESC'];
if (groupdesc=="���й���ϵͳ(��Ϣ�޸�)")
{  userdr=""
	}
if (groupdesc=="���й���ϵͳ(��Ϣ��ѯ)")
{  userdr=""
	}

var projUrl = 'herp.srm.SRMEnPaperPubRegexe.csp';

// ������ʼʱ��ؼ�
	var startDate = new Ext.form.DateField({
		  id:'startDate',
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
	var endDate = new Ext.form.DateField({
		  id:'endDate',
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
/////////////////��ʼʱ��////////////////////////////
var StartdDateField = new Ext.form.DateField({
		id : 'StartdDateField',
		//format : 'Y-m-d',
		fieldLabel:'��ʼ����',
		width : 120,
		editable:true
		//emptyText : '��ѡ��ʼ����...'
	});

/////////////////����ʱ��////////////////////////////
var EnddDateField = new Ext.form.DateField({
		id : 'EnddDateField',
		//format : 'Y-m-d',
		fieldLabel:'��������',
		width : 120,
		editable:true
		//emptyText : '��ѡ���������...'
	});
//md.formatDate(searchContractDate.getValue())


/////////////////����////////////////////////
var DeptDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


DeptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetDept&str='+encodeURIComponent(Ext.getCmp('DeptField').getRawValue()),method:'POST'});
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
	forceSelection:true,
	editable:true
});


/////////////////������Ŀ
var PaperName = new Ext.form.TextField({
                width: 120,
                allowBlank: true,
                name: 'PaperName',
                fieldLabel: '������Ŀ',
                blankText: '������������Ŀ'
            });


/////////////////�ڿ�����
var PeriodiNamDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

PeriodiNamDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetJournalDict&str='+encodeURIComponent(Ext.getCmp('PeriodiNam').getRawValue()),method:'POST'});
});

var PeriodiNam = new Ext.form.ComboBox({
	id: 'PeriodiNam',
	fieldLabel: '�ڿ�����',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:PeriodiNamDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ���ڿ�����...',
	name: 'PeriodiNam',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});

/////////////////��һ����
var FisAuthorDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

FisAuthorDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetAuthor&str='+encodeURIComponent(Ext.getCmp('FisAuthor').getRawValue()),method:'POST'});
});

var FisAuthorField = new Ext.form.ComboBox({
	id: 'FisAuthor',
	fieldLabel: '��һ����',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:FisAuthorDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ���һ����...',
	name: 'FisAuthor',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});

/////////////////ͨѶ����
var ComAuthorDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


ComAuthorDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetAuthor&str='+encodeURIComponent(Ext.getCmp('ComAuthor').getRawValue()),method:'POST'});
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

	var startTime= startDate.getRawValue();
	if (startTime!=="")
    {
       //startTime=startTime.format ('Y-m-d');
    }
	var endTime  = endDate.getRawValue();
	if (endTime!=="")
    {
       //endTime=endTime.format ('Y-m-d');
    }
        var Dept      = DeptField.getValue();
        var PaperNames= PaperName.getValue();
        var PeriodiNams= PeriodiNam.getRawValue();  
        var FisAuthor = FisAuthorField.getValue();
        var ComAuthor = ComAuthorField.getValue();
		    var type = TypeCombox.getValue();
		     

		    if ((groupdesc=="���й���ϵͳ(��Ϣ�޸�)")||(groupdesc=="���й���ϵͳ(��Ϣ��ѯ)"))
      {  userdr=""
	    }
	

        var data = startTime+"|"+endTime+"|"+Dept+"|"+PaperNames+"|"+PeriodiNams+"|"+FisAuthor+"|"+ComAuthor+"|"+userdr+"|"+type;

        itemGrid.load({params:{data:data,sortField:'',sortDir:'',start:0,limit:25}});      
}

//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel({
	title: '���ı����뽱��������Ϣ��ѯ',iconCls: 'search',
	autoHeight : true,
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
					width : 30			
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
					value : '<p style="text-align:right;">������Ŀ</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				PaperName,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
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
				startDate,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:center;">��</p>',
					width : 90			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				endDate,
				{
					xtype : 'displayfield',
					value : '',
					width : 30
				},
				{
					width : 30,
					xtype:'button',
					text: '��ѯ',
					handler:function(b){SearchFun();},
					iconCls : 'search'
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
					width : 30			
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
					value : '<p style="text-align:right;">�ڿ�����</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				PeriodiNam,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">��һ����</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				FisAuthorField,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">��һͨѶ����</p>',
					width : 90			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				ComAuthorField
			
				]
	}]
	
});

var itemGrid = new dhc.herp.Grid({
	title: '���ı����뽱��������Ϣ�б�',iconCls: 'list',
			region : 'center',
			url : projUrl,	
			//atLoad:true,        
			 sortInfo: {
             field: 'Title',
             direction: "ASC"
             },
            remoteSort: true, //������������
			fields : [
			new Ext.grid.CheckboxSelectionModel(
			{    hidden : true,
				editable:false
				
				}
			
			),
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
						header : '�ڿ�����',
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
						header : '������Ŀ ',
						sortable:true,
						width : 180,
						editable:false,
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
							return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+data+'</span>';
						},
						dataIndex : 'Title'
					},{
						id : 'CompleteUnit',
						header : '�ڼ���ɵ�λ ',
						width : 100,
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
						width : 60,
						editable : false,
						align:'left',
						dataIndex : 'FristAuthor'
					}, {
							id:'upload',
							header: 'ԭ��',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>�ϴ�</u></span>';
							}
					}, {
							id:'upload1',
							header: '��¼֤��',
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
								//alert(itemGrid1);
							return '<span style="color:blue"><u>����</u></span>';
							//return '<span style="color:gray;cursor:hand">���</span>';
					    } 
					},{
						id : 'DataStatus',
						header : '�ύ״̬',
						editable:false,
						hidden:false,
						width : 60,
						dataIndex : 'DataStatus'
					},{
						id : 'CheckState',
						header : '����״̬',
						editable:false,
						width : 100,
						dataIndex : 'CheckState'
					},{
						id : 'Desc',
						header : '�������',
						editable:false,
						width : 100,
						dataIndex : 'Desc'
					},{
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
						editable:false,
						//hidden:true,
						width : 80,
						align:'right',
						dataIndex : 'Ratio'
					},{
						id : 'REAmount',
						header : 'ʵ�������(Ԫ)',
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
						editable:false,
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
						id : 'SubUser',
						header : '������',
						editable:false,
						width : 60,
						dataIndex : 'SubUser',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
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
					}, {
							id:'ESICited',
							header: '�Ƿ�ESI�߱���',
							allowBlank: false,
							width:40,
							editable:false,
							hidden:true,
							dataIndex: 'ESICited'
					},{
						id : 'AllAudit',
						header : '�Ƿ�ȫ������ͨ��',
						width : 120,
						editable: false,
						hidden : true,
						dataIndex : 'AllAudit'
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
					},{
						header : '����ID',
						dataIndex : 'TypeID',
						hidden : true
					},{
						header : '��ID',
						dataIndex : 'YearID',
						hidden : true
					},{
						header : '��¼���ID',
						dataIndex : 'RecordTypeID',
						hidden : true
					},{
						header : '�ڿ�ID',
						dataIndex : 'JournalDR',
						hidden : true
					},{
						header : '�ڿ�����ID',
						dataIndex : 'JourLevelID',
						hidden : true
					},{
						header : '�������ID',
						dataIndex : 'PaperTypeID',
						hidden : true
					},{
						header : '��Ժ��λλ��ID',
						dataIndex : 'CompleteUnitID',
						hidden : true
					},{
						header : '���ҵ�λID',
						dataIndex : 'UnitMoneyID',
						hidden : true
					},{
						header : '���е�λID',
						dataIndex : 'PrjDR',
						hidden : true
					}] 

		});
		
/////////////////��Ӱ�ť////////////////////////////
var addButton = new Ext.Toolbar.Button({
	text: '����',
        //tooltip:'���',        
        iconCls: 'edit_add',
	handler:function(){
	AddFun();			
	}
	
});

/////////////////�޸İ�ť//////////////////
var editButton = new Ext.Toolbar.Button({
	text: '�޸�',
        //tooltip:'�޸�',        
        iconCls: 'pencil',
	handler:function(){
		var rowObj = itemGrid.getSelectionModel().getSelections();
		if(rowObj.length<1){
		 Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		 return;
		}
		var state = rowObj[0].get("DataStatus");
		var AuthorInfoID = rowObj[0].get("AuthorsInfo");
		var CorrAuthorInfoID = rowObj[0].get("CorrAuthorsInfo");
		
		
		
		if((state == "δ�ύ")||(groupdesc=="���й���ϵͳ(��Ϣ�޸�)" )){EditFun(AuthorInfoID,CorrAuthorInfoID);}
		else {Ext.Msg.show({title:'����',msg:'�������ύ���������޸ģ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}	
			
	}
	
});

////////////////ɾ����ť/////////////////////
var delButton = new Ext.Toolbar.Button({
	text:'ɾ��',
	//tooltip:'ɾ��',
	iconCls: 'edit_remove',
	handler:function(){
		var rowObj = itemGrid.getSelectionModel().getSelections();
		var state = rowObj[0].get("DataStatus");
		if(state == "δ�ύ" ){delFun();}
		else {Ext.Msg.show({title:'����',msg:'�������ύ��������ɾ����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}	
	}	
});

/////////////////�ύ��ť/////////////////////
var submitButton = new Ext.Toolbar.Button({
		text: '�ύ',
        //tooltip:'�ύ',        
        iconCls: 'pencil',
		handler:function(){
		var rowObj = itemGrid.getSelectionModel().getSelections();
		
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�ύ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			
			//////////////////////////�ж��Ƿ��и����ϴ���¼///////////////////////////
				Ext.Ajax.request({
					url:'herp.srm.uploadexe.csp?action=GetUpLoadInfo&RecDr='+rowObj[0].get("rowid")+'&SysNo='+'P00201',
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'ע��',msg:'���ϴ�ԭ�ĸ���!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
						
							return;
						}
						
					},
					scope: this			
				  });
		///////////////////////////////////////
		
			var state = rowObj[0].get("DataStatus");
		if(state == "δ�ύ"){submitFun();}
		else {Ext.Msg.show({title:'����',msg:'�������ύ���������ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}				
		}
	
});
  itemGrid.addButton('-');
  itemGrid.addButton(addButton);
  itemGrid.addButton('-');
  itemGrid.addButton(editButton);
  itemGrid.addButton('-');
  itemGrid.addButton(delButton);
  itemGrid.addButton('-');
  itemGrid.addButton(submitButton);
  //itemGrid.addButton('-');
  //itemGrid.addButton(upLaodButton);

  
    itemGrid.btnAddHide();     //�������Ӱ�ť
    itemGrid.btnSaveHide();    //���ر��水ť
    itemGrid.btnResetHide();   //�������ð�ť
    itemGrid.btnDeleteHide();  //����ɾ����ť
    itemGrid.btnPrintHide();   //���ش�ӡ��ť

/**
var data1 = "|||||||"+userdr+"|";

itemGrid.load({params:{data:data1,sortField:'',sortDir:'',start:0,limit:25}});     
**/
	var data = "|||||||"+userdr+"|";
if ((groupdesc=="���й���ϵͳ(��Ϣ�޸�)")||(groupdesc=="���й���ϵͳ(��Ϣ��ѯ)"))
{ 
  userdr="";
  data="";
  //itemGrid.load({params:{data:data,sortField:'', sortDir:'',start:0,limit:25}});      
}
else{
  itemGrid.load({params:{data:data,sortField:'', sortDir:'',start:0,limit:25}});      
}

// ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//  ������Ŀ
	if (columnIndex == 8) {
		PaperDetail(itemGrid);
	}
	//��������
	if (columnIndex == 30) {
		var records = itemGrid.getSelectionModel().getSelections();
		var authorinfo = records[0].get("AuthorsInfo");
//		var corrauthorinfo = records[0].get("CorrAuthorsInfo");
//		authorinfo=authorinfo+','+corrauthorinfo;
    var title = records[0].get("Title");
		AuthorInfoList(title,authorinfo);
	}
	if (columnIndex == 31) {
		var records = itemGrid.getSelectionModel().getSelections();
		var corrauthorinfo = records[0].get("CorrAuthorsInfo");
		//alert(authorinfo);
		var title = records[0].get("Title");
		CorrAuthorInfoList(title,corrauthorinfo);
	}
	
		
	
});

if (groupdesc=="���й���ϵͳ(��Ϣ�޸�)")
{
	 addButton.disable();//����Ϊ������
	  delButton.disable();//����Ϊ������
	  submitButton.disable();//����Ϊ������
	  
	
	}
if (groupdesc=="���й���ϵͳ(��Ϣ��ѯ)")
{
	 addButton.disable();//����Ϊ������
	 editButton.disable();
	 delButton.disable();//����Ϊ������
	 submitButton.disable();//����Ϊ������
	  
	
}
uploadMainFun(itemGrid,'rowid','P00201',17);//ԭ���ϴ�
uploadMainFun(itemGrid,'rowid','P00202',18);//��¼֤���ϴ�
downloadMainFun(itemGrid,'rowid','P00201,P00202',19);//����ԭ�ĺ���¼֤��
