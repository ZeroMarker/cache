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

var projUrl='herp.srm.srmpatentrewardapplyexe.csp';

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
/////////////////��Ȩ����///////////////////////
var StartDateField = new Ext.form.DateField({
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


/////////////////ר����///////////////////
var PatentNumber = new Ext.form.TextField({
                width: 120,
                allowBlank: true,
                name: 'PatentNumber',
                fieldLabel: 'ר����',
                blankText: 'ר����'
            });
/////////////////ר������///////////////////
var PatentName = new Ext.form.TextField({
                width: 120,
                allowBlank: true,
                name: 'PatentName',
                fieldLabel: 'ר������',
                blankText: 'ר������'
            });


/////////////////ר��������///////////////////////////
var InventorsDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


InventorsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetInventors&str='+encodeURIComponent(Ext.getCmp('Inventorss').getRawValue()),
	method:'POST'});
});

var InventorsField = new Ext.form.ComboBox({
	id: 'Inventorss',
	fieldLabel: 'ר��������',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:InventorsDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ��ר��������...',
	name: 'Inventorss',
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
    var PatentNum = PatentNumber.getValue();
    var Name = PatentName.getValue();
    var Inventors = InventorsField.getValue();
    var PatentType = ufPatentTypeField.getValue();
    if ((groupdesc=="���й���ϵͳ(��Ϣ�޸�)")||(groupdesc=="���й���ϵͳ(��Ϣ��ѯ)"))
	{ 
		userdr="";
	}
	itemGrid.load({params:{start:0,limit:25,startdate:startdate,enddate:enddate,DeptDr:DeptDr,Patentee:Patentee,PatentNum:PatentNum,Name:Name,Inventors:Inventors,userdr:userdr,PatentType:PatentType}});
	
}

//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel({
	autoHeight : true,
	region : 'north',
	frame : true,
	title : 'ר������������Ϣ��ѯ',
	iconCls : 'search',
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
				DeptField,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
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
					value : '<p style="text-align:right;">��Ȩ����</p>',
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
					width : 70			
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
					value : '<p style="text-align:right;">ר����</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},	
				PatentNumber,
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
				ufPatentTypeField,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">ר��������</p>',
					width : 70			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				InventorsField
				]
	}]
	
});

var itemGrid = new dhc.herp.Grid({
			region : 'center',
			title: 'ר�����������Ϣ��ѯ�б�',
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
						id:'YearDr',
						header:'��� ',
						width:60,
						editable:false,
						allowBlank:false,
						align:'left',
						dataIndex:'YearDr'

					}, {
						id:'CertificateNo',
						header:'֤���',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'CertificateNo'

					},{
						id:'PatentType',
						header:'ר�����',
						width:100,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'PatentType'
					},{
						id:'PatentTypeList',
						header:'ר�����',
						width:120,
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

					}, {
							id:'upload',
							header: '����',
							allowBlank: false,
							width:40,
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
						id:'Inventors',
						header:'������IDs',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'Inventors'
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
						id:'PatentNum',
						header:'ר����',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'PatentNum'

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
						id:'AnnDate',
						header:'��Ȩ��������',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'AnnDate'

					},{
						id:'AnnUnit',
						header:'������λ',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'AnnUnit'

					},{
						id:'AnnUnitList',
						header:'������λ',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'AnnUnitList'

					},{
						id:'CompleteUnit',
						header:'��Ժ��λλ��',
						//xtype:'numbercolumn',
						width : 120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'CompleteUnit'

					},{
						id:'VCAmount',
						header:'���뱨��(Ԫ)',
						editable:false,
						width:100,
						align:'right',
						dataIndex:'VCAmount',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
					},{
						id:'unitMoney',
						header:'���ҵ�λ',
						editable:false,
						width:60,
						align:'left',
						dataIndex:'unitMoney'
					},{
						id:'REAmount',
						header:'ʵ�ʱ���(Ԫ)',
						editable:false,
						width:100,
						align:'right',
						dataIndex:'REAmount',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
					},{
						id:'InvoiceCode',
						header:'��������',
						editable:false,
						width:120,
						align:'left',
						hidden:true,
						dataIndex:'InvoiceCode'
					},{
						id:'InvoiceNo',
						header:'������',
						editable:false,
						width:120,
						align:'left',
						hidden:true,
						dataIndex:'InvoiceNo'
					},{
						id : 'RewardAmount',
						header : '����(Ԫ)',
						width : 80,
						editable:false,
						allowblank:false,
						align:'right',
						renderer : function(val,cellmeta, record,rowIndex, columnIndex, store) { 
						
						val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
			 
						var sf = record.data['RewardAmount']
						if (sf !== "") {
							return '<span style="color:red;cursor:hand;">'+val+'</span>';
						}},
						dataIndex : 'RewardAmount'
					},{
						id:'SubUser',
						header:'������',
						editable:false,
						width:60,
						align:'left',
						dataIndex:'SubUser'
					},{
						id:'DeptDr',
						header:'�����˿���',
						editable:false,
						width:120,
						align:'left',
						dataIndex:'DeptDr',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					},{
						id:'SubDate',
						header:'����ʱ��',
						editable:false,
						width:80,
						align:'left',
						dataIndex:'SubDate'
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
				var inventorsids = rowObj[0].get("Inventors");		
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
    if (columnIndex == 7) {
		PatentDetail(itemGrid);
	}
	//��������
	if (columnIndex == 15) {
		var records = itemGrid.getSelectionModel().getSelections();
		var authorinfo = records[0].get("Inventors");
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
uploadMainFun(itemGrid,'rowid','P005',9);
downloadMainFun(itemGrid,'rowid','P005',10);
