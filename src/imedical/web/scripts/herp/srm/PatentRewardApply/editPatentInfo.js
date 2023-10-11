// JavaScript Document
/////////////////////�޸Ĺ���/////////////////////
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

var rawValue = "";
editFun = function(inventorsids) {
	//alert(InventorsIDs);
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	//alert(rowObj[0].get("remark"));
	if(len < 1)
	{
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		var myRowid = rowObj[0].get("rowid"); 
	}

	///////////////////////ר������//////////////////////////////
var eNameField = new Ext.form.TextArea({
	id:'Name',
	width:180,
	fieldLabel: 'ר������',
	allowBlank: false,
	name:'Name',
	labelSeparator:''
	//emptyText:'ר������...'
	//anchor: '95%'
});

/////////////ר�����
var ePatentTypeDs  = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '����ר��'], ['2', 'ʵ������ר��'], ['3', '������ר��']]
		});
var ePatentTypeField  = new Ext.form.ComboBox({
			id:'PatentType',
			fieldLabel : 'ר�����',
			width : 180,
			listWidth : 180,
			selectOnFocus : true,
			allowBlank : false,
			store : ePatentTypeDs ,
			displayField : 'keyValue',
			valueField : 'key',
			//emptyText : '',
			name:'PatentType',		
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			mode : 'local', // ����ģʽ
			triggerAction : 'all',
			labelSeparator:''
		});

/////////////////����///////////////////////
var eDeptsDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


eDeptsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetDept&str='+encodeURIComponent(Ext.getCmp('DeptDr').getRawValue()),
	method:'POST'});
});

var eDeptFields = new Ext.form.ComboBox({
	id: 'DeptDr',
	fieldLabel: '����',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:eDeptsDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ�����...',
	name: 'DeptDr',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});
///////////////////////֤���///////////////////////////
var eCertificateNoField = new Ext.form.TextField({
	id:'CertificateNo',
	fieldLabel: '֤���',
	width:180,
	allowBlank: false,
	name:'CertificateNo',
	labelSeparator:''
	//emptyText:'֤���...'
	//anchor: '95%'
});
////////////////////////��Ȩ����///////////////////////
var eAnnDateFields = new Ext.form.DateField({
			fieldLabel: '��Ȩ��������',
			width:180,
			allowBlank:false,
			//format:'Y-m-d',
			name:'AnnDate',
			//columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true',
			labelSeparator:''
		});
		
/////////////////������λ///////////////////////
var eAnnUintDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


eAnnUintDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetUint&str='+encodeURIComponent(Ext.getCmp('AnnUnit').getRawValue()),
	method:'POST'});
});

var eAnnUintFields = new Ext.form.ComboBox({
	id: 'eAnnUintFields',
	fieldLabel: '������λ',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store: eAnnUintDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ�񹫲���λ...',
	name: 'eAnnUintFields',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});
	
//////////////////////���//////////////////////////////////
var eYearDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


eYearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetYear&str='+encodeURIComponent(Ext.getCmp('YearDr').getRawValue()),
	method:'POST'});
});

var eYearField = new Ext.form.ComboBox({
	id: 'YearDr',
	fieldLabel: '���',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:eYearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ�����...',
	name: 'YearDr',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});

/////////////////ר��Ȩ��///////////////////
var ePatenteesDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

ePatenteesDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetPatentee&str='+encodeURIComponent(Ext.getCmp('Patentee').getRawValue()),
	method:'POST'});
});

var ePatenteeFields = new Ext.form.ComboBox({
	id: 'Patentee',
	fieldLabel: 'ר��Ȩ��',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:ePatenteesDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ��ר��Ȩ��...',
	name: 'Patentee',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});
/////////////////////ר����//////////////////////////
var ePatentNumField = new Ext.form.TextField({
	id:'PatentNum',
    fieldLabel: 'ר����',
	width:180,
    allowBlank: false,
	name:'PatentNum',
	labelSeparator:''
    //emptyText:'ר����...'
    //anchor: '95%'
	});
/////////////////��������///////////////////////
var eAppDateFields = new Ext.form.DateField({
			fieldLabel: '��������',
			width:180,
			allowBlank:false,
			//format:'Y-m-d',
			//columnWidth : .12,
			name:'AppDate',
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true',
			labelSeparator:''
		});
		
		
//////////////////////////////ר��������ID��λ�Ρ��Ƿ�Ժ///////////////////////////////////
/////////////////ר��������///////////////////////////
var InventorssDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

InventorssDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetInventors&str='+encodeURIComponent(Ext.getCmp('Inventorsss').getRawValue()),
	method:'POST'});
});

var InventorsFields = new Ext.form.ComboBox({
	id: 'Inventorsss',
	fieldLabel: 'ר��������',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:InventorssDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ��ר��������...',
	name: 'Inventorsss',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});
///////////////////����λ��/////////////////////////////  
var InventorsRangeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '��һ'],['2', '�ڶ�'], ['3', '����'], ['4', '����'], ['5', '����'],['6', '����'],['7', '����'],['8', '�ڰ�']]
	});		
		
var InventorsRangeCombox = new Ext.form.ComboBox({
	                   id : 'InventorsRangeCombox',
		           fieldLabel : 'λ��',
	                   width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : InventorsRangeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
				   labelSeparator:''
						  });	
///////////////////�Ƿ�Ժ/////////////////////////////  
var IsTheHosDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '��'],['0', '��']]
	});		
		
var IsTheHosCombox = new Ext.form.ComboBox({
	                   id : 'IsTheHosCombox',
		           fieldLabel : '�Ƿ�Ժ',
	                   width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : IsTheHosDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : '����ר������ʱ�Ƿ�Ϊ��Ժ��Ա',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
				   labelSeparator:''
						  });	
					
//////////////////ר��������GridPanel///////////////////////
var InventorsGrid = new Ext.grid.GridPanel({
		id:'InventorsGrid',
    store: new Ext.data.Store({
    autoLoad:true,
		proxy: new Ext.data.HttpProxy({
		url:'herp.srm.srmpatentrewardapplyexe.csp'+'?action=GetInventorsInfo&start='+0+'&limit='+25+'&IDs='+inventorsids,
		method:'POST'}),
	  reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','rangerowid','range','isthehosrowid','isthehos'])
    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 129,
            sortable: true
        },
        columns: [
            {id: 'rowid', header: '������ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '����������', dataIndex: 'name',align:'center',width: 100},
            {id: 'rangerowid', header: 'λ��ID', width: 129, sortable: true, dataIndex: 'rangerowid',hidden:true},
            {header: 'λ��', dataIndex: 'range',align:'center',width: 80},
            {id: 'isthehosrowid', header: '�Ƿ�ԺID', width: 129, sortable: true, dataIndex: 'isthehosrowid',hidden:true},
            {header: '�Ƿ�Ժ', dataIndex: 'isthehos',align:'center',width: 80}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 285,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'���',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});

///////////////��Ӷ�������˰�ť////////////////
var addInventors  = new Ext.Button({
		text: '����',iconCls: 'edit_add',
		handler: function(){
			var InventorId;
			var RangeId;
			var IsTheHosId;
			var id = Ext.getCmp('Inventorsss').getValue();
			var rangeid = Ext.getCmp('InventorsRangeCombox').getValue();
			var isthehosid = Ext.getCmp('IsTheHosCombox').getValue();
			var InventorName = Ext.getCmp('Inventorsss').getRawValue();
			var InventorsRange = Ext.getCmp('InventorsRangeCombox').getRawValue();
			var IsTheHos = Ext.getCmp('IsTheHosCombox').getRawValue();
			//var firstauthor = FristAuthor.getValue();
			
			var total = InventorsGrid.getStore().getCount();
			if(total>0){	
				for(var i=0;i<total;i++){
					var erow = InventorsGrid.getStore().getAt(i).get('rowid');
					var tmprange = InventorsGrid.getStore().getAt(i).get('range');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'����',msg:'��ѡ����ͬһ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
							if(tmprange==InventorsRange)
							{
								Ext.Msg.show({title:'����',msg:'��ͬ�ķ�������ѡ������ͬ��λ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							else{
						    InventorId=id;
						    RangeId=rangeid;
						    IsTheHosId=isthehosid;
						  }
						}
					}else{
						Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵķ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				}
			}else{
				if(id==""){
					Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵķ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}else{
					InventorId=id;
					RangeId=rangeid;
					IsTheHosId=isthehosid;
				}	
			}
			var data = new Ext.data.Record({'rowid':InventorId,'name':InventorName,'rangerowid':RangeId,'range':InventorsRange,'isthehosrowid':IsTheHosId,'isthehos':IsTheHos});
			InventorsGrid.stopEditing(); 
			InventorsGrid.getStore().insert(total,data);
			if(total>0){
				rawValue = InventorsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<total;i++){
				  var row = InventorsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  rawValue = rawValue+","+row;
				}
			}
			//alert(rawValue);
			//alert(InventorId+"  "+InventorName);
		}
	});	
var delInventors = new Ext.Button({
		text:'ɾ��',iconCls: 'edit_remove',

		handler: function() {  
			var rows = InventorsGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				rRowid = InventorsGrid.getStore().indexOf(rows[0]); //����кţ�������rowid
				InventorsGrid.getStore().removeAt(rRowid);//�Ƴ���ѡ�е�һ��
			}

			var total = InventorsGrid.getStore().getCount();
			//alert(total);
			if(total>0){
				rawValue = InventorsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<total;i++){
				  var row = InventorsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  rawValue = rawValue+","+row;
				}
			}
			
		}
	});
/////////////////��Ժ��λλ��///////////////////////////
var CompleteUnitStore = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['1','��һ��ɵ�λ'],['2','�ڶ���ɵ�λ'],['3','������ɵ�λ'],['4','������ɵ�λ'],['5','������ɵ�λ'],['6','������ɵ�λ'],['7','������ɵ�λ'],['8','�ڰ���ɵ�λ']]
});

var CompleteUnitField = new Ext.form.ComboBox({
	id: 'CompleteUnitField',
	fieldLabel: '��Ժ��λλ��',
	width:180,
	//anchor: '95%',
	listWidth : 180,
	allowBlank: true,
	store:CompleteUnitStore,
	valueField: 'key',
	displayField: 'keyvalue',
	triggerAction: 'all',
	//emptyText:'��ѡ����Ժ��λλ��...',
	mode : 'local',
	name: 'CompleteUnitField',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	labelSeparator:''
});
///////////////////��Ʊ����/////////////////////////////  
var InvoiceCodeField = new Ext.form.NumberField({
				fieldLabel: '��Ʊ����',
				width:180,
				allowBlank : true, 
				disabled:false,
				//anchor: '95%',
				selectOnFocus:'true',
				editable:true,
				labelSeparator:''
});	
///////////////////��Ʊ����/////////////////////////////  
var InvoiceNoField = new Ext.form.NumberField({
				fieldLabel: '��Ʊ����',
				width:180,
				allowBlank : true, 
				disabled:false,
				//anchor: '95%',
				selectOnFocus:'true',
				editable:true,
				labelSeparator:''
});		
///////////////////���뱨��/////////////////////////////  
var PageChargeField = new Ext.form.NumberField({
				fieldLabel: '���뱨��',
				width:180,
				allowBlank : true, 
				disabled:false,
				//anchor: '95%',
				selectOnFocus:'true',
				editable:true,
				labelSeparator:''
});

////////////////////���ҵ�λ/////////////////////////////
var UnitMoneyStore = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['R','�����'],['D','��Ԫ'],['E','ŷԪ'],['P','Ӣ��']]
});

var UnitMoneyField = new Ext.form.ComboBox({
	id: 'UnitMoneyField',
	fieldLabel: '���ҵ�λ',
	width:180,
	//anchor: '95%',
	listWidth : 180,
	allowBlank: true,
	store:UnitMoneyStore,
	valueField: 'key',
	displayField: 'keyvalue',
	value:'R',
	triggerAction: 'all',
	//emptyText:'��ѡ����ҵ�λ...',
	mode : 'local',
	name: 'UnitMoneyField',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	labelSeparator:''
});

////��������
var ePrjNameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
			totalProperty : "results",
			root : 'rows'
		}, ['rowid', 'name'])
	});
				
ePrjNameDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
		url : 'herp.srm.monographrewardapplyexe.csp'+'?action=GetPrjName&str='+encodeURIComponent(Ext.getCmp('ePrjNameField').getRawValue()),
		method : 'POST'
			});
	});
var ePrjNameField = new Ext.form.ComboBox({
	        id:'ePrjNameField',
			fieldLabel : '������Ŀ',
			width : 180,
			listWidth : 260,
			selectOnFocus : true,
			allowBlank : false,
			store : ePrjNameDs,
			//anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			//emptyText : '',
			//mode : 'local', // ����ģʽ
			name:'ePrjNameField',
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			labelSeparator:''
	});
				
///Ժ�����п���
var eOutPrjNameField = new Ext.form.TextField({
	fieldLabel:'������Ŀ(Ժ��)',
	width : 180,
	allowBlank : true,
	selectOnFocus : true,
	labelSeparator:''
});

var colItems =	[
		{
			layout: 'column',
			border: false,
			defaults: {
				columnWidth: '.5',
				bodyStyle:'padding:5px 5px 0',
				border: false
			},            
			items: [
				{
					xtype: 'fieldset',
					//autoHeight: true,
					items: [
						{
							xtype : 'displayfield',
							value : '',
							columnWidth : .1
						},
					   eYearField,
					   ePatenteeFields,
					   eNameField,  
					   ePatentTypeField ,
					   //eDeptFields,
					   InventorsGrid,
					   InventorsFields,
					   InventorsRangeCombox,
					   IsTheHosCombox,
					   {
						columnWidth : 1,
						xtype : 'panel',
						layout : "column",
						items : [{
							xtype : 'displayfield',
							
							columnWidth : .05
							},addInventors,{
							xtype : 'displayfield',
							
							columnWidth : .07
							},delInventors]
						}
					   //eaddInventors,
					   //edelInventors					   
					]	 
				}, {
					xtype: 'fieldset',
					autoHeight: true,
					items: [
						{
							xtype : 'displayfield',
							value : '',
							columnWidth : .1
						},
						ePatentNumField,
						eAppDateFields,
						eCertificateNoField,
					  eAnnDateFields,
					  eAnnUintFields,
					  CompleteUnitField,
                      PageChargeField,
					  UnitMoneyField,
					  InvoiceCodeField,
					  InvoiceNoField,
					  ePrjNameField						  
					]
				 }]
		}
	]		
	// create form panel
  var editFormPanel = new Ext.form.FormPanel({
    labelWidth: 100,
	labelAlign:'right',
	  frame: true,
    items: colItems
	});
	
	editFormPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
	
			eNameField.setRawValue(rowObj[0].get("Name"));
			eYearField.setRawValue(rowObj[0].get("YearDr"));
			//eDeptFields.setRawValue(rowObj[0].get("DeptDr"));
			ePatentTypeField.setRawValue(rowObj[0].get("PatentTypeList"));   
			ePatenteeFields.setRawValue(rowObj[0].get("Patentee"));	
			ePatentNumField.setRawValue(rowObj[0].get("PatentNum"));	
			eCertificateNoField.setRawValue(rowObj[0].get("CertificateNo"));	
			eAppDateFields.setValue(rowObj[0].get("AppDate"));			
			eAnnDateFields.setValue(rowObj[0].get("AnnDate"));
			eAnnUintFields.setRawValue(rowObj[0].get("AnnUnitList"));
		  CompleteUnitField.setValue(rowObj[0].get("CompleteUnit"));
		  PageChargeField.setValue(rowObj[0].get("VCAmount"));
		  UnitMoneyField.setValue(rowObj[0].get("unitMoney"));
		  InvoiceCodeField.setValue(rowObj[0].get("InvoiceCode"));
		  InvoiceNoField.setValue(rowObj[0].get("InvoiceNo"));
		  ePrjNameField.setRawValue(rowObj[0].get("PrjName"));
			
		});

  // define window and show it in desktop
  var allauthorinfo="";
  var editWindow = new Ext.Window({
  	title: '�޸�ר������������Ϣ',
	iconCls: 'pencil',
    width: 640,
    height:560,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: editFormPanel,
    buttons: [{
    	text: '����', iconCls: 'save',
        handler: function() {
      		var Name = eNameField.getValue();
      		var YearDr = eYearField.getValue();
      		//var DeptDr = eDeptFields.getValue(); 	
      		var DeptDr="";	
      		var PatentType =ePatentTypeField.getValue();
      		var Patentee = ePatenteeFields.getValue();
      		var PatentNum = ePatentNumField.getValue();
      		var CertificateNo = eCertificateNoField.getValue();
      		var AppDate = eAppDateFields.getRawValue();
      		//AppDate = AppDate.format("Y-m-d");
      		
      		var AnnDate = eAnnDateFields.getRawValue();
      		//AnnDate = AnnDate.format("Y-m-d");
      		
      		var AnnUnit = eAnnUintFields.getValue();
      		var CompleteUnit = CompleteUnitField.getValue();
      		
      		var prjdr = ePrjNameField.getValue(); ///libairu20160913������̨
      
			    
			  var inventorscount = InventorsGrid.getStore().getCount();
			  if(inventorscount>0){
				var authorid = InventorsGrid.getStore().getAt(0).get('rowid');
				var authorrangeid = InventorsGrid.getStore().getAt(0).get('rangerowid');
				var authoristhehosid = InventorsGrid.getStore().getAt(0).get('isthehosrowid');
				allauthorinfo = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				for(var i=1;i<inventorscount;i++){
				  var authorid = InventorsGrid.getStore().getAt(i).get('rowid');
				  var authorrangeid = InventorsGrid.getStore().getAt(i).get('rangerowid');
				  var authoristhehosid = InventorsGrid.getStore().getAt(i).get('isthehosrowid');
				  var authorinfo = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				  allauthorinfo = allauthorinfo+","+authorinfo;
				   };
			   }   
			var Inventors = allauthorinfo;
			
			Name = Name.trim();
      //DeptDr =DeptDr.trim();
			YearDr =YearDr.trim();
			Patentee =Patentee.trim();
      CertificateNo = CertificateNo.trim();
			PatentNum = PatentNum.trim();
      		
	   var VCAmount=PageChargeField.getValue();
	   var unitMoney=UnitMoneyField.getValue();
	   var InvoiceCode=InvoiceCodeField.getValue();
	   var InvoiceNo=InvoiceNoField.getValue();
      		if(Name=="")
      		{
      			Ext.Msg.show({title:'����',msg:'ר������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(CertificateNo=="")
      		{
      			Ext.Msg.show({title:'����',msg:'֤���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			   if(PatentNum=="")
      		{
      			Ext.Msg.show({title:'����',msg:'ר����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};

		      var name = rowObj[0].get("Name");
      		var year = rowObj[0].get("YearDr");
      		var patent = rowObj[0].get("Patentee");
      		//var dept = rowObj[0].get("DeptDr");
      		var patenttype = rowObj[0].get("PatentTypeList");
      		var patentnum = rowObj[0].get("PatentNum");
      		var certificateno = rowObj[0].get("CertificateNo");
      		var appdate = rowObj[0].get("AppDate");
      		var anndate = rowObj[0].get("AnnDate");
      		var annunit = rowObj[0].get("AnnUnitList");
      		
      		var completeunit = rowObj[0].get("CompleteUnit");
      		var invent = rowObj[0].get("Inventors");
      		var vcamount = rowObj[0].get("VCAmount");
			var unitmoney = rowObj[0].get("unitMoney");
			var invoicecode = rowObj[0].get("InvoiceCode");
			var invoiceno= rowObj[0].get("InvoiceNo");
      		
      		//if(DeptDr==dept){DeptDr=""};
			    if(Inventors==invent){Inventors=""};
			    if(Name==name){Name=""};	
			    if(YearDr==year){YearDr=""};	
			    if(Patentee==patent){Patentee=""};	
			    if(PatentType==patenttype){PatentType=""};	
			    if(PatentNum==patentnum){PatentNum=""};	
			    if(CertificateNo==certificateno){CertificateNo=""};	
			    if(AppDate==appdate){AppDate=""};	
			    if(AnnDate==anndate){AnnDate=""};	
			    if(AnnUnit==annunit){AnnUnit=""};	
			    if(CompleteUnit==completeunit){CompleteUnit=""};	
				
				if(VCAmount==vcamount){VCAmount=""};
				if(unitMoney==unitmoney){unitMoney=""};	
				if(InvoiceCode==invoicecode){InvoiceCode=""};	
				if(InvoiceNo==invoiceno){InvoiceNo=""};	
        	if (editFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url:  projUrl+'?action=edit&rowid='+myRowid+'&Name='+encodeURIComponent(Name)+'&PatentType='+PatentType+'&DeptDr='+encodeURIComponent(DeptDr)+'&Inventors='+Inventors+'&CertificateNo='+CertificateNo+'&AnnDate='+AnnDate+'&YearDr='+YearDr+'&Patentee='+Patentee+'&PatentNum='+PatentNum+'&AppDate='+AppDate+'&AnnUnit='+AnnUnit+'&CompleteUnit='+CompleteUnit+'&VCAmount='+VCAmount+'&InvoiceCode='+InvoiceCode+'&InvoiceNo='+InvoiceNo+'&unitMoneys='+unitMoney+'&PrjDr='+prjdr,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	    if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:25}});
									editWindow.close();
								}
								else
								{
									var message = "";
									message = jsonData.info;
									if(jsonData.info=='RepTitle') message='�����ר�������Ѿ�����!';	
									if(jsonData.info=='RepPatentNum') message='�����ר�����Ѿ�����!';					
								  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	else{
						Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ���󱣴档',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}             
	    	}
    	},
    	{
			text: '�ر�',iconCls : 'cancel',
        handler: function(){editWindow.close();}
      }]
    });
    editWindow.show();
};
