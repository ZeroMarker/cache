var userdr = session['LOGON.USERCODE'];

var groupdesc = session['LOGON.GROUPDESC'];
if (groupdesc=="���й���ϵͳ(��Ϣ�޸�)")
{ 
	userdr="";
}
if (groupdesc=="���й���ϵͳ(��Ϣ��ѯ)")
{ 
	userdr="";
}

var projUrl='herp.srm.srmpatentcertificateapplyexe.csp';

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

/////////////////ר��Ժ��֤����������///////////////////////
var StartDateField = new Ext.form.DateField({
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
var EndDateField = new Ext.form.DateField({
			fieldLabel: '��Ȩ����',
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
/////////////////����///////////////////////
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
/////////////////ר������///////////////////
var PatentName = new Ext.form.TextField({
                width: 120,
                allowBlank: true,
                name: 'PatentName',
                fieldLabel: 'ר������',
                blankText: 'ר������'
            });	
/////////////////ר��Ȩ��///////////////////
var PatenteeDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


PatenteeDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetPatentee&str='+encodeURIComponent(Ext.getCmp('Patentees').getRawValue()),
	method:'POST'});
});

var PatenteeField = new Ext.form.ComboBox({
	id: 'Patentees',
	fieldLabel: 'ר��Ȩ��',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:PatenteeDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ��ר��Ȩ��...',
	name: 'Patentees',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


/////////////////////ר�����/////////////////////////////					
var ufPatentTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '����ר��'], ['2', 'ʵ������ר��'], ['3', '������ר��']]
	});
	var ufPatentTypeField = new Ext.form.ComboBox({
	    id : 'ufPatentTypeField',
		fieldLabel : 'ר�����',
		width : 120,
		listWidth : 120,
		store : ufPatentTypeDs,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // ����ģʽ
		triggerAction: 'all',
		//emptyText:'��ѡ��...',
		selectOnFocus:true,
		forceSelection : true
	});	
	
/////////////////��ѯ��ť��Ӧ����//////////////
function SearchFun()
{			
	  var startdate= StartDateField.getRawValue()
		if(startdate!=""){
			//startdate.format("Y-m-d");
		};
	  var enddate= EndDateField.getRawValue()
		if(enddate!=""){
			//enddate.format("Y-m-d");
		};
	var DeptDr  = DeptField.getValue(); 
    var Patentee = PatenteeField.getValue();
    var Name = PatentName.getValue();
    var PatentType = ufPatentTypeField.getValue();
    if ((groupdesc=="���й���ϵͳ(��Ϣ�޸�)")||(groupdesc=="���й���ϵͳ(��Ϣ��ѯ)"))
	{ 
		userdr="";
	}
	
	itemGrid.load({params:{start:0,limit:25,startdate:startdate,enddate:enddate,DeptDr:DeptDr,Patentee:Patentee,Name:Name,PatentType:PatentType,userdr:userdr}});
	
}

//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel({
	autoHeight : true,
	title : 'ר��Ժ��֤��������Ϣ��ѯ',
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
				/* {
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
				}, */
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">ר��Ȩ��</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				PatenteeField,
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
				StartDateField,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:center;">��</p>',
					width : 20			
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
					value : '<p style="text-align:right;">ר������</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},	
				PatentName,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">ר������</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				ufPatentTypeField
				]
	}]
	
});

var itemGrid = new dhc.herp.Grid({
	title: 'ר��Ժ��֤��������Ϣ��ѯ�б�',
			iconCls: 'list',
			region : 'center',
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
						id:'YearDr',
						header:'��� ',
						width:60,
						editable:false,
						allowBlank:false,
						align:'left',
						dataIndex:'YearDr'

					},{
						id:'DeptDr',
						header:'��������',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'DeptDr'
					},{
						id:'PatentTypeList',
						header:'ר�����',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'PatentTypeList'
					},{
						id:'Name',
						header:'ר������',
						width:180,
						editable:false,
						align:'left',
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
						dataIndex:'Name'
					}, {
						id:'Patentee',
						header:'ר��Ȩ��',
						width:120,
						editable:false,
						align:'left',
						dataIndex:'Patentee',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
						id:'InventorsID',
						header:'������IDs',
						width:100,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'InventorsID'
					},{
						id:'InventorInfos',
						header:'������',
						width:80,
						editable:false,
						align:'left',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						},
						dataIndex:'InventorInfos'
					},{
							id:'upload',
							header: 'ר��������',
							allowBlank: false,
							width:80,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>�ϴ�</u></span>';
							}
					},{
							id:'upload2',
							header: 'Ȩ��Ҫ����',
							allowBlank: false,
							width:80,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>�ϴ�</u></span>';
							}
					}
					,{
							id:'upload3',
							header: '˵����',
							allowBlank: false,
							width:60,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>�ϴ�</u></span>';
							}
					},{
							id:'upload4',
							header: '˵���鸽ͼ',
							allowBlank: false,
							width:80,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>�ϴ�</u></span>';
							}
					},{
							id:'upload5',
							header: '˵����ժҪ',
							allowBlank: false,
							width:80,
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
					    } 
					},{
							id:'IsApproved',
							header: '�Ƿ����',
							allowBlank: false,
							width:60,
							editable:false,
							dataIndex: 'IsApproved'
					},{
							id:'ApprovedDate',
							header: '��������',
							allowBlank: false,
							width:80,
							editable:false,
							dataIndex: 'ApprovedDate'
					},{
						id:'DataStatus',
						header:'����״̬',
						editable:false,
						width:60,
						align:'left',
						dataIndex:'DataStatus'
					},{
						id:'ChkResult',
						header:'���״̬',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'ChkResult'
					},{
						id:'Desc',
						header:'������',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'Desc'
					},{
						id:'AppDate',
						header:'ר����������',
						//xtype:'numbercolumn',
						width : 120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'AppDate'

					},{
						id:'SubUser',
						header:'������',
						editable:false,
						width:60,
						align:'left',
						dataIndex:'SubUser'
					},{
						id:'SubDept',
						header:'�����˿���',
						editable:false,
						width:120,
						align:'left',
						dataIndex:'SubDept',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					},{
						id:'SubDate',
						header:'ר���Ǽ�����',
						editable:false,
						width:80,
						align:'left',
						dataIndex:'SubDate'
					},{
						id:'Phone',
						header:'�ֻ�',
						editable:false,
						width:120,
						align:'left',
						hidden:true,
						dataIndex:'Phone'
					},{
						id:'Email',
						header:'����',
						editable:false,
						width:120,
						hidden:true,
						align:'left',
						dataIndex:'Email'
					},{
						id:'PatenteeDR',
						header:'ר��Ȩ��ID',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'PatenteeDR'

					},{
						id:'PatentType',
						header:'ר�����ID',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'PatentType'
					},{
						id:'Year',
						header:'���ID',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'Year'
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
					}]
		});


///////////////////��Ӱ�ť///////////////////////
var addPatentInfoButton = new Ext.Toolbar.Button({
		text: '����',    
    	iconCls: 'edit_add',
		handler: function(){addFun();}
});

/////////////////�޸İ�ť/////////////////////////
var editPatentInfoButton  = new Ext.Toolbar.Button({
		text: '�޸�',        
		iconCls: 'pencil',
		handler: function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length; 
			if(len < 1)
			{
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				var state = rowObj[0].get("DataStatus");	
				var inventorsids = rowObj[0].get("InventorsID");		
				if((state == "δ�ύ")||(groupdesc=="���й���ϵͳ(��Ϣ�޸�)" ) ){editFun(inventorsids);}				
				else {Ext.Msg.show({title:'����',msg:'�������ύ���������޸ģ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}
			}
});

////////////////ɾ����ť//////////////////////////
var delPatentInfoButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		iconCls: 'edit_remove',
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
		iconCls: 'pencil',
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
  itemGrid.load({params:{start:0, limit:12, userdr:userdr}});
  
 // ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
    if (columnIndex ==6) {
		PatentDetail(itemGrid);
	}
	if (columnIndex == 9) {
		var records = itemGrid.getSelectionModel().getSelections();
		var authorinfo = records[0].get("InventorsID");
		var title = records[0].get("Name");
		AuthorInfoList(title,authorinfo);
	}
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
	 editPatentInfoButton.disable();
	  delPatentInfoButton.disable();//����Ϊ������
	  subPatentInfoButton.disable();//����Ϊ������
	  
	
	}
uploadMainFun(itemGrid,'rowid','SRMpatentapply001',10);
uploadMainFun(itemGrid,'rowid','SRMpatentapply002',11);
uploadMainFun(itemGrid,'rowid','SRMpatentapply003',12);
uploadMainFun(itemGrid,'rowid','SRMpatentapply004',13);
uploadMainFun(itemGrid,'rowid','SRMpatentapply005',14);
downloadMainFun(itemGrid,'rowid','SRMpatentapply001,SRMpatentapply002,SRMpatentapply003,SRMpatentapply004,SRMpatentapply005',15);
