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
editFun = function(participantids) {
	//alert(participantids);
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
	
	
///////////////////����/////////////////////////////  
var eTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '����'],['2', '��ѧ']]
	});		
		
var eTypeCombox = new Ext.form.ComboBox({
	                   id : 'eTypeCombox',
		           fieldLabel : '����',
	                   width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : eTypeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
				   labelSeparator:'',
		           forceSelection : true
						  });	
///////////////////////��������//////////////////////////////
var NameField = new Ext.form.TextArea({
	id:'NameField',
	width:180,
	fieldLabel: '��Ŀ����',
	allowBlank: false,
	labelSeparator:''
	// emptyText:'��Ŀ����...'
	//anchor: '95%'
});
////////////////////////��������//////////////////////////
var IdentifyLevelStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '�����Ƚ�'], ['2', '��������'], ['3', '�����Ƚ�'], ['4', '��������']]
		});
var IdentifyLevelField = new Ext.form.ComboBox({
            id: 'IdentifyLevelField',
			fieldLabel : '��������',
			width : 180,
			listWidth : 180,
			allowBlank : true,
			store : IdentifyLevelStore,
			valueField : 'key',
			displayField : 'keyValue',
			// emptyText : '��ѡ�����',
			//pageSize : 10,
			minChars : 1,
			name:'IdentifyLevelField',
			selectOnFocus : true,
			forceSelection : true,
			labelSeparator:'',
			mode : 'local', // ����ģʽ
			triggerAction : 'all'
		});
/////////////////������λ///////////////////////////
var addIdentifyUnitDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


addIdentifyUnitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetUint&str='+encodeURIComponent(Ext.getCmp('addIdentifyUnitField').getRawValue()),
	method:'POST'});
});

var addIdentifyUnitField = new Ext.form.ComboBox({
	id: 'addIdentifyUnitField',
	fieldLabel: '������λ',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:addIdentifyUnitDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	// emptyText:'��ѡ�������λ...',
	name: 'addIdentifyUnitField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	labelSeparator:'',
	forceSelection:'true',
	editable:true
});
////////////////////////��������///////////////////////
var IdentifyDateFields = new Ext.form.DateField({
            id:'IdentifyDateFields',
			fieldLabel: '��������',
			width:180,
			allowBlank:false,
			//format:'Y-m-d',
			columnWidth : .12,
			labelSeparator:'',
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
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
	allowBlank: true,
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	// emptyText:'��ѡ�����...',
	name: 'YearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	labelSeparator:'',
	editable:true
});

/////////////////////��ע//////////////////////////
var RemarkField = new Ext.form.TextField({
	id:'RemarkField',
    fieldLabel: '��ע',
	width:180,
	labelSeparator:'',
    allowBlank: true
    // emptyText:'��ע...'
    //anchor: '95%'
	});

//////////////////////////////������ID��λ�Ρ��Ƿ�Ժ///////////////////////////////////
/////////////////������///////////////////////////
var ParticipantStore = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

ParticipantStore.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetUser&str='+encodeURIComponent(Ext.getCmp('ParticipantsFields').getRawValue()),
	method:'POST'});
});

var ParticipantsFields = new Ext.form.ComboBox({
	id: 'ParticipantsFields',
	fieldLabel: '������Ա',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:ParticipantStore,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	// emptyText:'��ѡ�������...',
	name: 'ParticipantsFields',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	labelSeparator:'',
	forceSelection:'true',
	editable:true
});
///////////////////������λ��/////////////////////////////  
var ParticipantsRangeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '��һ'],['2', '�ڶ�'], ['3', '����'], ['4', '����'], ['5', '����'],['6', '����'],['7', '����'],['8', '�ڰ�']]
	});		
		
var ParticipantsRangeCombox = new Ext.form.ComboBox({
	                   id : 'ParticipantsRangeCombox',
		           fieldLabel : '��Աλ��',
	                   width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : ParticipantsRangeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
				   labelSeparator:'',
		           forceSelection : true
						  });	
///////////////////�Ƿ�Ժ/////////////////////////////  
var IsTheHosDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '��Ժְ��'],['0', '��Ժ��Ա'],['2','��ʿ�о���'],['3','˶ʿ�о���']]
	});		
		
var IsTheHosCombox = new Ext.form.ComboBox({
	                   id : 'IsTheHosCombox',
		           fieldLabel : '�������ʱ���',
	                   width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : IsTheHosDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
				   labelSeparator:'',
		           forceSelection : true,
				    listeners:{
                           "select":function(combo,record,index){
						           if((combo.value=='2')||(combo.value=='3'))
								   {
                                   ParticipantsRangeCombox.setValue('');
								   ParticipantsRangeCombox.disable();  //��Ϊ�ң����ɱ༭
                                   //ParticipantsRangeCombox.disabled=true;   //����Ϊ�ң����ɱ༭	
                                   }				
                                   else{
								   ParticipantsRangeCombox.enable();  	
								   }								   
			}
	}	
});	
					
//////////////////ר��������GridPanel///////////////////////
var ParticipantsGrid = new Ext.grid.GridPanel({
		id:'ParticipantsGrid',
        store: new Ext.data.Store({
        autoLoad:true,
		proxy: new Ext.data.HttpProxy({
		url:projUrl+'?action=GetparticipantsInfo&start='+0+'&limit='+25+'&IDs='+participantids,
		method:'POST'}),
		reader: new Ext.data.JsonReader({totalProperty:'results',root:'rows'}, [  
			'rowid','name','rangerowid','range','isthehosrowid','isthehos'
         ])  
    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 129,
            sortable: true
        },
        columns: [
            {id: 'rowid', header: '������ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '����������', dataIndex: 'name',align:'center',width: 80},
            {id: 'rangerowid', header: 'λ��ID', width: 129, sortable: true, dataIndex: 'rangerowid',hidden:true},
            {header: 'λ��', dataIndex: 'range',align:'center',width: 80},
            {id: 'isthehosrowid', header: '�������ʱ���ID', width: 129, sortable: true, dataIndex: 'isthehosrowid',hidden:true},
            {header: '�������ʱ���', dataIndex: 'isthehos',align:'center',width: 110}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 272,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'���',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});

///////////////��Ӷ�������˰�ť////////////////
var addParticipants = new Ext.Button({
		text: '����',
		iconCls: 'edit_add',
		handler: function(){
			var ParticipantsId;
			var RangeId;
			var IsTheHosId;
			var id = Ext.getCmp('ParticipantsFields').getValue();
			var rangeid = Ext.getCmp('ParticipantsRangeCombox').getValue();
			var isthehosid = Ext.getCmp('IsTheHosCombox').getValue();
			var Name = Ext.getCmp('ParticipantsFields').getRawValue();
			var ParticipantsRange = Ext.getCmp('ParticipantsRangeCombox').getRawValue();
			var IsTheHos = Ext.getCmp('IsTheHosCombox').getRawValue();
			//var firstauthor = FristAuthor.getValue();
			
			var total = ParticipantsGrid.getStore().getCount();
			if(total>0){	
				for(var i=0;i<total;i++){
					var erow = ParticipantsGrid.getStore().getAt(i).get('rowid');
					var tmprange = ParticipantsGrid.getStore().getAt(i).get('range');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'����',msg:'��ѡ����ͬһ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
						    if(isthehosid=="")
						   {
						   Ext.Msg.show({title:'����',msg:'��ѡ��������ʱ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				    return;
						   }
						   else{
						  if((rangeid=="")&&((isthehosid=='0')||(isthehosid=='1')))
							{
							  Ext.Msg.show({title:'����',msg:'��ѡ�������Աλ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							else{
							if((tmprange==ParticipantsRange)&&(tmprange!="")&&(ParticipantsRange!=""))
							{
								Ext.Msg.show({title:'����',msg:'��ͬ�Ĳ�������ѡ������ͬ��λ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							else{
						    ParticipantsId=id;
						    RangeId=rangeid;
						    IsTheHosId=isthehosid;
						  }
						}
					}
				}
			}else{
						Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵĲ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
			}
			}
			}else{
				if(id==""){
					Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵĲ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				if(isthehosid=="")
					{
					Ext.Msg.show({title:'����',msg:'��ѡ�������Ŀʱ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				    return;
					}
				if((rangeid=="")&&((isthehosid=='0')||(isthehosid=='1')))
					{
					Ext.Msg.show({title:'����',msg:'��ѡ�������Աλ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
					}
				else{
					ParticipantsId=id;
					RangeId=rangeid;
					IsTheHosId=isthehosid;
				}	
			}
			var data = new Ext.data.Record({'rowid':ParticipantsId,'name':Name,'rangerowid':RangeId,'range':ParticipantsRange,'isthehosrowid':IsTheHosId,'isthehos':IsTheHos});
			ParticipantsGrid.stopEditing(); 
			ParticipantsGrid.getStore().insert(total,data);
			if(total>0){
				rawValue = ParticipantsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<total;i++){
				  var row = ParticipantsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  rawValue = rawValue+","+row;
				}
			}
			//alert(rawValue);
			//alert(InventorId+"  "+InventorName);
		}
	});	
var delParticipants = new Ext.Button({
		text:'ɾ��',
		iconCls: 'cancel',
		handler: function() {  
			var rows = ParticipantsGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				rRowid = ParticipantsGrid.getStore().indexOf(rows[0]); //����кţ�������rowid
				ParticipantsGrid.getStore().removeAt(rRowid);//�Ƴ���ѡ�е�һ��
			}

			var total = ParticipantsGrid.getStore().getCount();
			//alert(total);
			if(total>0){
				rawValue = ParticipantsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<total;i++){
				  var row = ParticipantsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
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
	allowBlank: true,
	store:CompleteUnitStore,
	valueField: 'key',
	displayField: 'keyvalue',
	triggerAction: 'all',
	// emptyText:'��ѡ����Ժ��λλ��...',
	mode : 'local',
	name: 'CompleteUnitField',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	labelSeparator:'',
	forceSelection:true,
	editable:true
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
		url : projUrl+'?action=GetPrjName&str='+encodeURIComponent(Ext.getCmp('ePrjNameField').getRawValue()),
		method : 'POST'
			});
	});
var ePrjNameField = new Ext.form.ComboBox({
	        id:'ePrjNameField',
			fieldLabel : '������Ŀ',
			width : 180,
			listWidth : 260,
			selectOnFocus : true,
			allowBlank : true,
			store : ePrjNameDs,
			//anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			// emptyText : '',
			//mode : 'local', // ����ģʽ
			name:'ePrjNameField',
			editable : true,
			pageSize : 10,
			minChars : 1,
			labelSeparator:'',
			selectOnFocus : true,
			forceSelection : true
	});
				
///Ժ�����п���
var eOutPrjNameField = new Ext.form.TextField({
	fieldLabel:'���п��п���(Ժ��)',
	width : 150,
	allowBlank : true,
	labelSeparator:'',
	selectOnFocus : true
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
						/* {
							xtype : 'displayfield',
							value : '',
							columnWidth : .05
						}, */
						eTypeCombox,
			           YearField,
					   NameField,  
					   IdentifyLevelField,
					   addIdentifyUnitField,
					   IdentifyDateFields,
					   CompleteUnitField,
					   RemarkField,
					   ePrjNameField
					]	 
				}, {
					xtype: 'fieldset',
					autoHeight: true,
					items: [
						/* {
							xtype : 'displayfield',
							value : '',
							columnWidth : .1
						}, */
                       ParticipantsGrid,
					   ParticipantsFields,
					   IsTheHosCombox,
					   ParticipantsRangeCombox,
					   {
						columnWidth : 1,
						xtype : 'panel',
						layout : "column",
						items : [{
							xtype : 'displayfield',
							
							columnWidth : .05
							},addParticipants,{
							xtype : 'displayfield',
							
							columnWidth : .1
							},delParticipants]
						}  						
					]
				 }]
		}
	]	

	// create form panel
  var editFormPanel = new Ext.form.FormPanel({
    labelWidth: 90,
	labelAlign:'right',
	  frame: true,
    items: colItems
	});
	
	editFormPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
	
			NameField.setRawValue(rowObj[0].get("Name"));
			YearField.setRawValue(rowObj[0].get("YearName"));
			IdentifyLevelField.setRawValue(rowObj[0].get("IdentifyLevel"));   
			addIdentifyUnitField.setRawValue(rowObj[0].get("IdentifyUnit"));   
			IdentifyDateFields.setRawValue(rowObj[0].get("IdentifyDate"));   
			CompleteUnitField.setRawValue(rowObj[0].get("CompleteUnit"));	
			RemarkField.setRawValue(rowObj[0].get("Remark"));	
			eTypeCombox.setRawValue(rowObj[0].get("Type"));
			ePrjNameField.setRawValue(rowObj[0].get("PrjName"));
		});

  // define window and show it in desktop
  var allauthorinfo="";
  var editWindow = new Ext.Window({
  	title: '�޸Ŀ��м�������',
	iconCls: 'pencil',
    width: 650,
    height:400,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: editFormPanel,
    buttons: [{
    	text: '����',
		iconCls: 'save',
        handler: function() {
      		var Year = YearField.getValue();
      var Name = NameField.getValue();
	  
	  var inventorscount = ParticipantsGrid.getStore().getCount();
	    if(inventorscount>0){
			var authorid = ParticipantsGrid.getStore().getAt(0).get('rowid');
			var authorrangeid = ParticipantsGrid.getStore().getAt(0).get('rangerowid');
			var authoristhehosid = ParticipantsGrid.getStore().getAt(0).get('isthehosrowid');
			allauthorinfo = authorid+"-"+authorrangeid+"-"+authoristhehosid;
			for(var i=1;i<inventorscount;i++){
				var authorid = ParticipantsGrid.getStore().getAt(i).get('rowid');
				var authorrangeid = ParticipantsGrid.getStore().getAt(i).get('rangerowid');
				var authoristhehosid = ParticipantsGrid.getStore().getAt(i).get('isthehosrowid');
				var authorinfo = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				allauthorinfo = allauthorinfo+","+authorinfo;
				};
		}
			   
	  var Participants = allauthorinfo;
      var IdentifyLevel = IdentifyLevelField.getValue();
	  var IdentifyUnit = addIdentifyUnitField.getValue();
      var IdentifyDate = IdentifyDateFields.getRawValue();
	  var CompleteUnit = CompleteUnitField.getValue();
	  var Remark = RemarkField.getValue();
      var Type = eTypeCombox.getValue();
      
      var prjdr = ePrjNameField.getValue(); ///libairu20160913������̨

      
	  
	  
      		if(eTypeCombox.getRawValue()=="")
      {
      	Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      	return;
      };
      		if(Name=="")
      {
      	Ext.Msg.show({title:'����',msg:'��������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      	return;
      };
	  
             
		    var name = rowObj[0].get("Name");
      		var year = rowObj[0].get("YearName");
      		var identifylevel = rowObj[0].get("IdentifyLevel");
      		var identifyunit = rowObj[0].get("IdentifyUnit");
      		var identifydate = rowObj[0].get("IdentifyDate");
      		var completeunit = rowObj[0].get("CompleteUnit");
      		var remark = rowObj[0].get("Remark");
      		var type = rowObj[0].get("Type");
      		var prjname = rowObj[0].get("PrjName");
			
			    if(Name==name){Name=""};	
			    if(Year==year){Year=""};	
			    if(IdentifyLevel==identifylevel){IdentifyLevel=""};	
			    if(IdentifyUnit==identifyunit){IdentifyUnit=""};	
			    if(IdentifyDate==identifydate){IdentifyDate=""};	
			    if(CompleteUnit==completeunit){CompleteUnit=""};	
			    if(Remark==remark){Remark=""};	
			    if(Participants==participantids){Participants=""};
			    if(Type==type){Type=""};
			    if(prjdr==prjname){prjdr=""};
				
        	if (editFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url:  projUrl+'?action=edit&rowid='+myRowid+'&Year='+encodeURIComponent(Year)+'&Name='+encodeURIComponent(Name)+'&Participants='+encodeURIComponent(Participants)+'&IdentifyLevel='+encodeURIComponent(IdentifyLevel)+'&IdentifyUnit='+encodeURIComponent(IdentifyUnit)+'&IdentifyDate='+IdentifyDate+'&CompleteUnit='+encodeURIComponent(CompleteUnit)+'&Remark='+encodeURIComponent(Remark)+'&usercode='+usercode+'&Type='+Type+'&PrjDr='+prjdr,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:25,usercode:usercode}});
									editWindow.close();
								}
								else
								{
									var message = "";
									message = jsonData.info;
									if(jsonData.info=='RepName') message='����������Ѿ�����!';	
									if(jsonData.info=='RepDate') message='�������ڲ��ܴ��ڵ�ǰ����!';				
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
		text: '�ر�',
		iconCls: 'cancel',
        handler: function(){editWindow.close();}
      }]
    });
    editWindow.show();
};
