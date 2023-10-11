var userdr = session['LOGON.USERCODE'];

var groupdesc = session['LOGON.GROUPDESC'];
if (groupdesc=="���й���ϵͳ(��Ϣ�޸�)")
{ var userdr=""
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
			format:'Y-m-d',
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
			format:'Y-m-d',
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
	listWidth : 250,
	allowBlank: true,
	store:DeptDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ�����...',
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
	listWidth : 250,
	allowBlank: true,
	store:PatenteeDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ��ר��Ȩ��...',
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
	listWidth : 250,
	allowBlank: true,
	store:InventorsDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ��ר��������...',
	name: 'Inventorss',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

/////////////////��ѯ��ť��Ӧ����//////////////
function SearchFun()
{			
	  var startdate= StartDateField.getValue()
		if(startdate!=""){
			startdate.format("Y-m-d");
		};
	  var enddate= EndDateField.getValue()
		if(enddate!=""){
			enddate.format("Y-m-d");
		};
	  var DeptDr  = DeptField.getValue();
    var Patentee = PatenteeField.getValue();
    var PatentNum = PatentNumber.getValue();
    var Inventors = InventorsField.getValue();
		
	itemGrid.load({params:{start:0,limit:25,startdate:startdate,enddate:enddate,DeptDr:DeptDr,Patentee:Patentee,PatentNum:PatentNum,Inventors:Inventors,userdr:userdr}});
	
}

//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel({
	height : 130,
	region : 'north',
	frame : true,

	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<center><p style="font-weight:bold;font-size:100%">ר����������</p></center>',
			columnWidth : 1,
			height : '32'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '��Ȩ����:',
				columnWidth : .08
				},StartDateField,{
				xtype:'displayfield',
				value:'��',
				columnWidth:.03
				},EndDateField,{
				xtype:'displayfield',
				value:'',
				columnWidth:.05
				},{
				xtype : 'displayfield',
				value : '����:',
				columnWidth : .05
				},DeptField,{
				xtype:'displayfield',
				value:'',
				columnWidth:.05
				},{
				xtype : 'displayfield',
				value : 'ר��Ȩ��:',
				columnWidth : .08
				},PatenteeField]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : 'ר����:',
				columnWidth : .06
				},PatentNumber,
				{
				xtype:'displayfield',
				value:'',
				columnWidth:.05
				},{
				xtype : 'displayfield',
				value : 'ר��������:',
				columnWidth : .09
				},InventorsField,{
				xtype:'displayfield',
				value:'',
				columnWidth:.13
				},{
				columnWidth:0.06,
				xtype:'button',
				text: '��ѯ',
				handler:function(b){SearchFun();},
				iconCls: 'find'
				}]
	}]
	
});

var itemGrid = new dhc.herp.Grid({
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
						width:120,
						editable:false,
						allowBlank:false,
						align:'center',
						dataIndex:'YearDr'

					}, {
						id:'CertificateNo',
						header:'֤���',
						width:120,
						editable:false,
						align:'center',
						hidden:true,
						dataIndex:'CertificateNo'

					},{
						id:'PatentType',
						header:'ר�����',
						width:120,
						editable:false,
						align:'center',
						hidden:true,
						dataIndex:'PatentType'
					},{
						id:'PatentTypeList',
						header:'ר�����',
						width:120,
						editable:false,
						align:'center',
						dataIndex:'PatentTypeList'
					},{
						id:'Name',
						header:'ר������',
						width:180,
						editable:false,
						align:'center',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						},
						dataIndex:'Name'
					}, {
						id:'Patentee',
						header:'ר��Ȩ��',
						width:120,
						editable:false,
						align:'center',
						dataIndex:'Patentee'

					}, {
						id:'Inventors',
						header:'������IDs',
						width:120,
						editable:false,
						align:'center',
						hidden:true,
						dataIndex:'Inventors'
					},{
						id:'InventorInfos',
						header:'������',
						width:120,
						editable:false,
						align:'center',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						},
						dataIndex:'InventorInfos'
					},{
						id:'PatentNum',
						header:'ר����',
						width:120,
						editable:false,
						align:'center',
						hidden:true,
						dataIndex:'PatentNum'

					},{
						id:'AppDate',
						header:'ר����������',
						//xtype:'numbercolumn',
						width : 120,
						editable:false,
						align:'center',
						hidden:true,
						dataIndex:'AppDate'

					},{
						id:'AnnDate',
						header:'��Ȩ��������',
						width:120,
						editable:false,
						align:'center',
						hidden:true,
						dataIndex:'AnnDate'

					},{
						id:'AnnUnit',
						header:'������λ',
						width:120,
						editable:false,
						align:'center',
						hidden:true,
						dataIndex:'AnnUnit'

					},{
						id:'AnnUnitList',
						header:'������λ',
						width:120,
						editable:false,
						align:'center',
						hidden:true,
						dataIndex:'AnnUnitList'

					},{
						id:'CompleteUnit',
						header:'��Ժ��λλ��',
						//xtype:'numbercolumn',
						width : 120,
						editable:false,
						align:'center',
						hidden:true,
						dataIndex:'CompleteUnit'

					},{
						id:'VCAmount',
						header:'���뱨��',
						editable:false,
						width:120,
						align:'center',
						dataIndex:'VCAmount'
					},{
						id:'unitMoney',
						header:'���ҵ�λ',
						editable:false,
						width:120,
						align:'center',
						dataIndex:'unitMoney'
					},{
						id:'REAmount',
						header:'ʵ�ʱ���',
						editable:false,
						width:120,
						align:'center',
						dataIndex:'REAmount'
					},{
						id:'InvoiceCode',
						header:'��������',
						editable:false,
						width:120,
						align:'center',
						hidden:true,
						dataIndex:'InvoiceCode'
					},{
						id:'InvoiceNo',
						header:'������',
						editable:false,
						width:120,
						align:'center',
						hidden:true,
						dataIndex:'InvoiceNo'
					},{
						id : 'RewardAmount',
						header : '����(Ԫ)',
						width : 120,
						editable:false,
						allowblank:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['RewardAmount']
						if (sf !== "") {
							return '<span style="color:red;cursor:hand;">'+value+'</span>';
						}},
						dataIndex : 'RewardAmount'
					},{
						id:'SubUser',
						header:'������',
						editable:false,
						width:120,
						align:'center',
						dataIndex:'SubUser'
					},{
						id:'DeptDr',
						header:'�����˿���',
						editable:false,
						width:120,
						align:'center',
						dataIndex:'DeptDr'
					},{
						id:'SubDate',
						header:'����ʱ��',
						editable:false,
						width:120,
						align:'center',
						dataIndex:'SubDate'
					},{
						id:'DataStatus',
						header:'����״̬',
						editable:false,
						width:120,
						align:'center',
						dataIndex:'DataStatus'
					},{
						id:'ChkResult',
						header:'���״̬',
						width:120,
						editable:false,
						align:'center',
						dataIndex:'ChkResult'
					},{
						id:'Desc',
						header:'������',
						width:180,
						editable:false,
						align:'center',
						dataIndex:'Desc'
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
					}]
		});


///////////////////��Ӱ�ť///////////////////////
var addPatentInfoButton = new Ext.Toolbar.Button({
		text: '���',    
    	iconCls: 'add',
		handler: function(){addFun();}
});

/////////////////�޸İ�ť/////////////////////////
var editPatentInfoButton  = new Ext.Toolbar.Button({
		text: '�޸�',        
		iconCls: 'option',
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
		iconCls: 'remove',
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
		iconCls:'option',
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
	if (columnIndex == 10) {
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

uploadMainFun(itemGrid,'rowid','P005',29);
downloadMainFun(itemGrid,'rowid','P005',30);
