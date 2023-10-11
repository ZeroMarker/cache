var userdr = session['LOGON.USERCODE'];
var rawValue = "";
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
/////////////////��ӹ���/////////////////
addFun = function() {
///////////////////////ר������//////////////////////////////
var NameField = new Ext.form.TextArea({
	id:'NameField',
	width:180,
	fieldLabel: 'ר������',
	allowBlank: false,
	labelSeparator:''
	//emptyText:'ר������...'
	//anchor: '95%'
});
var PatentTypeDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '����ר��'], ['2', 'ʵ������ר��'], ['3', '������ר��']]
		});
var PatentTypeField = new Ext.form.ComboBox({
            id: 'PatentType',
			fieldLabel : 'ר�����',
			width : 180,
			listWidth : 180,
			allowBlank: false,
			store : PatentTypeDs,
			valueField : 'key',
			displayField : 'keyValue',
			//emptyText : '��ѡ�����',
			//pageSize : 10,
			minChars : 1,
			name:'PatentType',
			selectOnFocus : true,
			forceSelection : true,
			mode : 'local', // ����ģʽ
			triggerAction : 'all',
			labelSeparator:''
		});
/////////////////����///////////////////////
var DeptsDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


DeptsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetDept&str='+encodeURIComponent(Ext.getCmp('DeptFields').getRawValue()),
	method:'POST'});
});

var DeptFields = new Ext.form.ComboBox({
	id: 'DeptFields',
	fieldLabel: '����',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:DeptsDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ�����...',
	name: 'DeptFields',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});

///////////////////////֤���///////////////////////////
var CertificateNoField = new Ext.form.TextField({
	id:'CertificateNoField',
	fieldLabel: '֤���',
	width:180,
	allowBlank: false,
	labelSeparator:''
	//emptyText:'֤���...'
	//anchor: '95%'
});



////////////////////////��Ȩ����///////////////////////
var AnnDateFields = new Ext.form.DateField({
			fieldLabel: '��Ȩ��������',
			width:180,
			allowBlank:false,
			//format:'Y-m-d',
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
var AnnUintDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


AnnUintDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetUint&str='+encodeURIComponent(Ext.getCmp('AnnUintFields').getRawValue()),
	method:'POST'});
});

var AnnUintFields = new Ext.form.ComboBox({
	id: 'AnnUintFields',
	fieldLabel: '������λ',
	width:180,
	listWidth : 260,
	allowBlank: false,
	store: AnnUintDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ�񹫲���λ...',
	name: 'AnnUintFields',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});

//////////////////////���//////////////////////////////////
var YearDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


YearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetYear&str='+encodeURIComponent(Ext.getCmp('YearField').getRawValue()),
	method:'POST'});
});

var YearField = new Ext.form.ComboBox({
	id: 'YearField',
	fieldLabel: '���',
	width:180,
	listWidth : 260,
	allowBlank: false,
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ�����...',
	name: 'YearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});



/////////////////ר��Ȩ��///////////////////
var PatenteesDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


PatenteesDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetPatentee&str='+encodeURIComponent(Ext.getCmp('Patenteess').getRawValue()),
	method:'POST'});
});

var PatenteeFields = new Ext.form.ComboBox({
	id: 'Patenteess',
	fieldLabel: 'ר��Ȩ��',
	width:180,
	listWidth : 260,
	allowBlank: false,
	store:PatenteesDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ��ר��Ȩ��...',
	name: 'Patenteess',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});

/////////////////////ר����//////////////////////////
var PatentNumField = new Ext.form.TextField({
	id:'PatentNumField',
    fieldLabel: 'ר����',
	width:180,
    allowBlank: false,
	labelSeparator:''
    //emptyText:'ר����...'
    //anchor: '95%'
	});
	
/////////////////��������///////////////////////
var AppDateFields = new Ext.form.DateField({
			fieldLabel: '��������',
			width:180,
			allowBlank:false,
			//format:'Y-m-d',
			columnWidth : .12,
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
    //autoLoad:true,
		proxy: new Ext.data.MemoryProxy(),
		/*proxy: new Ext.data.HttpProxy({
		url:'herp.srm.srmpatentrewardapplyexe.csp'+'?action=InventorID&start='+0+'&limit='+25+'&InventorsIDs='+InventorsIDs,
		method:'POST'}),*/
		reader: new Ext.data.ArrayReader({}, [  
			 {name: 'rowid'},  
			 {name: 'name'},
			 {name: 'rangerowid'},  
			 {name: 'range'},
			 {name: 'isthehosrowid'},  
			 {name: 'isthehos'}
         ])  
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
				}
				
					if(InventorsRange=="")
							{
								Ext.Msg.show({title:'����',msg:'��ѡ������λ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							
							if(IsTheHos=="")
							{
								Ext.Msg.show({title:'����',msg:'��ѡ���Ƿ�Ϊ��Ժ��Ա!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
				
				
				else{
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
/////////////////�ڼ���ɵ�λ///////////////////////////
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
	allowBlank:false,
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
				allowBlank: true,
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
var PrjNameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
PrjNameDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=GetPrjName&str='+encodeURIComponent(Ext.getCmp('PrjNameField').getRawValue()),
						method : 'POST'
					});
		});
var PrjNameField = new Ext.form.ComboBox({
	        id:'PrjNameField',
			fieldLabel : '������Ŀ',
			width : 180,
			listWidth : 260,
			selectOnFocus : true,
			//allowBlank : false,
			store : PrjNameDs,
			//anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			//emptyText : '',
			//mode : 'local', // ����ģʽ
			name:'PrjNameField',
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			labelSeparator:''
		});

///Ժ�����п���
var OutPrjNameField = new Ext.form.TextField({
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
					autoHeight: true,
					items: [
						{
							xtype : 'displayfield',
							value : '',
							columnWidth : .05
						},
			           YearField,
					   PatenteeFields,
					   NameField,  
					   PatentTypeField,
					   //DeptFields,
					   InventorsGrid,
					   InventorsFields,
					   InventorsRangeCombox,
					   IsTheHosCombox,
					   {
						columnWidth : 1,
						xtype : 'panel',
						layout : "column",
						items : [
							{
							xtype : 'displayfield',
							
							columnWidth : .05
							},addInventors,{
							xtype : 'displayfield',
							
							columnWidth : .1
							},delInventors,
							{
							    xtype : 'displayfield',
							    columnWidth : .07
							}]
						},
						{
							columnWidth : 1,
						    xtype : 'panel',
						    layout : "column",
						    items : [
							{
							xtype : 'displayfield',
							value : ' *�����ȫ�������ˣ���Ժ��Ա������ӣ�',
							columnWidth : 1,
							style:'color:red;'
							}
							]
						}
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
						PatentNumField,
						AppDateFields,
						CertificateNoField,
					    AnnDateFields,
					    AnnUintFields,
					    CompleteUnitField,
                        PageChargeField,
						UnitMoneyField,
						InvoiceCodeField,
						InvoiceNoField,
						PrjNameField							
					]
				 }]
		}
	]		
	// create form panel
  var addFormPanel = new Ext.form.FormPanel({
    labelWidth: 100,
	labelAlign:'right',
	frame: true,
    items: colItems
	});
    
  // define window and show it in desktop
  var allauthorinfo="";
  var addWindow = new Ext.Window({
  	title: '����ר������������Ϣ',
	iconCls: 'edit_add',
    width: 640,
    height:560,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: addFormPanel,
    buttons: [{
    	text: '����',iconCls: 'save', 
      handler: function() {
      		// check form value
      var Name = NameField.getValue();
      var PatentType = PatentTypeField.getValue();
      //var DeptDr = DeptFields.getValue();
			var DeptDr="";
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
      var CertificateNo = CertificateNoField.getValue();
			var AnnDate = AnnDateFields.getRawValue();
      var YearDr = YearField.getValue();
			var Patentee = PatenteeFields.getValue();
			var PatentNum = PatentNumField.getValue();
      var AppDate = AppDateFields.getRawValue();
      var AnnUnit = AnnUintFields.getValue();
      var CompleteUnit = CompleteUnitField.getValue();	
	   var VCAmount=PageChargeField.getValue();
	   var unitMoney=UnitMoneyField.getValue();
	   var InvoiceCode=InvoiceCodeField.getValue();
	   var InvoiceNo=InvoiceNoField.getValue();
	   
	   var prjdr = PrjNameField.getValue(); ///libairu20160913������̨
	   
			Name = Name.trim();
      DeptDr = DeptDr.trim();
			Inventors = Inventors.trim();
      CertificateNo = CertificateNo.trim();
      YearDr = YearDr.trim();
			Patentee = Patentee.trim();
			PatentNum = PatentNum.trim();
      		
      		
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
      
      		if(InventorsGrid.getStore().getCount()<1)
      {
      	Ext.Msg.show({title:'����',msg:'��ѡ��ר��������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      	return;
      };
      
	  
	  
        	if (addFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url: projUrl+'?action=add&Name='+encodeURIComponent(Name)+'&Inventors='+Inventors+'&CertificateNo='+CertificateNo+'&AnnDate='+AnnDate+'&YearDr='+YearDr+'&Patentee='+Patentee+'&PatentNum='+PatentNum+'&AppDate='+AppDate+'&userdr='+userdr+'&DeptDr='+DeptDr+'&PatentType='+PatentType+'&AnnUnit='+AnnUnit+'&CompleteUnit='+CompleteUnit+'&VCAmount='+VCAmount+'&InvoiceCode='+InvoiceCode+'&InvoiceNo='+InvoiceNo+'&unitMoneys='+unitMoney+'&PrjDr='+prjdr,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								  itemGrid.load({params:{start:0, limit:25}});
									addWindow.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='RepNum') message='�����ר�����Ѿ�����!';	
									if(jsonData.info=='RepName') message='�����ר�������Ѿ�����!';	
									if(jsonData.info=='RepInvoice') message='����ı������Ѿ�����!';	
								  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	else{
						Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ�����ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}             
	    	}
    	},
    	{
				text: '�ر�',iconCls : 'cancel',
        handler: function(){addWindow.close();}
      }]
    });

    addWindow.show();
};
