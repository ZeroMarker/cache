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

editFun = function(participantids) {
	//alert(ParticipantsIDs);
	
	
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
		rowid = rowObj[0].get("rowid"); 
		var bftype = rowObj[0].get("TypeID"); 
		var bfyear = rowObj[0].get("YearID"); 
		var bfname = rowObj[0].get("Name"); 
		var bfrewardtypeid = rowObj[0].get("RewardTypeID"); 
		var bfrewardnameid = rowObj[0].get("RewardNameID"); 
		var bfrewardlevelid = rowObj[0].get("RewardLevelID"); 
		var bfrewardunitid = rowObj[0].get("RewardUnitID"); 
		var bfrewarddate   = rowObj[0].get("RewardDate"); 
		var bfcompleteunitid = rowObj[0].get("CompleteUnitID"); 
		var bfprjdr = rowObj[0].get("PrjDR"); 
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
		           value:bftype,
		           selectOnFocus : true,
				   labelSeparator:'',
		           forceSelection : true
});		
/////////////////���///////////////////////
var eYearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


eYearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=yearList&str='+encodeURIComponent(Ext.getCmp('eYearField').getRawValue()),
	method:'POST'});
});

var eYearField = new Ext.form.ComboBox({
	id: 'eYearField',
	fieldLabel: '���',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:eYearDs,
	value:bfyear,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	// emptyText:'��ѡ�����...',
	name: 'eYearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	labelSeparator:'',
	editable:true
});
/* 
eYearField.on('select',function(combo, record, index){
		bfyear = combo.getValue();
	}); */
///////////////////////������//////////////////////////////
var eNameField = new Ext.form.TextArea({
	id:'eNameField',
	width:180,
	value:bfname,
	fieldLabel: '����Ŀ',
	allowBlank: false,
	labelSeparator:''
	// emptyText:'��Ŀ...'
	//anchor: '95%'
});

//////////////////////////������Ա��λ�Ρ��Ƿ�Ժ////////////////////////////////////////////////////////////////////////
//////////////////�μ���Ա///////////////////////
var eParticipantsDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


eParticipantsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=userList&str='+encodeURIComponent(Ext.getCmp('eParticipantsField').getRawValue()),
	method:'POST'});
});

var eParticipantsField = new Ext.form.ComboBox({
	id: 'eParticipantsField',
	fieldLabel: '��Ŀ�μ���Ա',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:eParticipantsDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	// emptyText:'��ѡ����Ŀ�μ���Ա...',
	name: 'eParticipantsField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	labelSeparator:'',
	forceSelection:'true',
	editable:true
});

///////////////////����λ��/////////////////////////////  
var AuthorRangeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '��һ'],['2', '�ڶ�'], ['3', '����'], ['4', '����'], ['5', '����'],['6', '����'],['7', '����'],['8', '�ڰ�']]
	});		
		
var AuthorRangeCombox = new Ext.form.ComboBox({
	                   id : 'AuthorRangeCombox',
		           fieldLabel : '������λ��',
	               width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : AuthorRangeDs,
		          // anchor : '95%',			
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
		           fieldLabel : '���������',
	               width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : IsTheHosDs,
		          // anchor : '95%',			
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
                                   AuthorRangeCombox.setValue('');
								   AuthorRangeCombox.disable();  //��Ϊ�ң����ɱ༭
                                   //AuthorRangeCombox.disabled=true;   //����Ϊ�ң����ɱ༭	
                                   }				
                                   else{
								   AuthorRangeCombox.enable();  	
								   }								   
			}
	}	
});	

var eParticipantsGrid = new Ext.grid.GridPanel({
		id:'eParticipantsGrid',
    	store: new Ext.data.Store({
        autoLoad:true,
		proxy: new Ext.data.HttpProxy({
		url:projUrl+'?action=GetParticipantsInfo&start='+0+'&limit='+25+'&IDs='+participantids,
		method:'POST'}),
	  reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','rangerowid','range','isthehosrowid','isthehos'])
    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 129,
            sortable: true
        },
        columns: [
            {id: 'rowid', header: '�μ���ԱID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '�μ���Ա����', dataIndex: 'name',align:'center',width: 100},
            {id: 'rangerowid', header: '����������ID', width: 129, sortable: true, dataIndex: 'rangerowid',hidden:true},
            {header: '������λ��', dataIndex: 'range',align:'center',width: 80},
            {id: 'isthehosrowid', header: '������гɹ�ʱ���ID', width: 129, sortable: true, dataIndex: 'isthehosrowid',hidden:true},
            {header: '���������', dataIndex: 'isthehos',align:'center',width: 110}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 290,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'���',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});

///////////////��Ӷ���μ���Ա��ť////////////////
var addParticipants  = new Ext.Button({
		text: '����',
		iconCls: 'edit_add',
		handler: function(){
			var ParticipantsId;
			var RangeId;
			var IsTheHosId;
			var id = Ext.getCmp('eParticipantsField').getValue();
			var rangeid = Ext.getCmp('AuthorRangeCombox').getValue();
			var isthehosid = Ext.getCmp('IsTheHosCombox').getValue();
			//alert(id);
			var ParticipantsName = Ext.getCmp('eParticipantsField').getRawValue();
			var AuthorRange = Ext.getCmp('AuthorRangeCombox').getRawValue();
			var IsTheHos = Ext.getCmp('IsTheHosCombox').getRawValue();
			var ptotal = eParticipantsGrid.getStore().getCount();
			if(ptotal>0){	
				for(var i=0;i<ptotal;i++){
					var erow = eParticipantsGrid.getStore().getAt(i).get('rowid');
					var tmprange = eParticipantsGrid.getStore().getAt(i).get('range');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'����',msg:'��ѡ����ͬһ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
//						   if(tmprange==AuthorRange)
//							{
//								Ext.Msg.show({title:'����',msg:'��ͬ�Ĳ�����Ա��ѡ������ͬ��λ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
//							  return;
//							}
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
							if((tmprange==AuthorRange)&&(tmprange!="")&&(AuthorRange!=""))
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
						Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵĲμ���Ա!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				}
			}else{
				if(id==""){
					Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵĲμ���Ա!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}if(isthehosid=="")
					{
					Ext.Msg.show({title:'����',msg:'��ѡ��������ʱ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
			var data = new Ext.data.Record({'rowid':ParticipantsId,'name':ParticipantsName,'rangerowid':RangeId,'isthehosrowid':IsTheHosId,'range':AuthorRange,'isthehos':IsTheHos});
			eParticipantsGrid.stopEditing(); 
			eParticipantsGrid.getStore().insert(ptotal,data);
			if(ptotal>0){
			   // prawValue=eParticipantsGrid.getStore().getAt(i).get('rowid');
				var authorid = eParticipantsGrid.getStore().getAt(0).get('rowid');
				var authorrangeid = eParticipantsGrid.getStore().getAt(0).get('rangerowid');
				var authoristhehosid = eParticipantsGrid.getStore().getAt(0).get('isthehosrowid');
				prawValue = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				for(var i=1;i<ptotal;i++){
				  //var prow = eParticipantsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  var authorid = eParticipantsGrid.getStore().getAt(i).get('rowid');
				  var authorrangeid = eParticipantsGrid.getStore().getAt(i).get('rangerowid');
				  var authoristhehosid = eParticipantsGrid.getStore().getAt(i).get('isthehosrowid');
				  var prow = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				  prawValue = prawValue+","+prow;
				}
			}
			//alert(rawValue);
			//alert(InventorId+"  "+InventorName);
		}
	});	
var delParticipants = new Ext.Button({
		text:'ɾ��',
		iconCls:'edit_remove',
		handler: function() {  
			var rows = eParticipantsGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				rRowid = eParticipantsGrid.getStore().indexOf(rows[0]); //����кţ�������rowid
				eParticipantsGrid.getStore().removeAt(rRowid);//�Ƴ���ѡ�е�һ��
			}

//			var ptotal = eParticipantsGrid.getStore().getCount();
//			//alert(total);
//			if(ptotal>0){
//				prawValue = eParticipantsGrid.getStore().getAt(0).get('rowid');
//				for(var i=1;i<ptotal;i++){
//				  var prow = eParticipantsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
//				  prawValue = prawValue+","+prow;
//				}
//			}
			
		}
	});
/////////////////��������////////////////////////////
var eReWardTypeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

eReWardTypeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=rewardTypeList',
						method : 'POST'
					});
		});

var eReWardTypeField = new Ext.form.ComboBox({
            id: 'eReWardTypeField',
			fieldLabel: '�����',
			store : eReWardTypeDs,
			value:bfrewardtypeid,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			// emptyText : '��ѡ��������...',
			name:'eReWardTypeField',
			width : 180,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			labelSeparator:'',
			selectOnFocus : true
		});

/////////////////�����////////////////////////////
var eReWardNameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

eReWardNameDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=rewardDictList',
						method : 'POST'
					});
		});

var eReWardNameField = new Ext.form.ComboBox({
            id: 'eReWardNameField',
			fieldLabel: '��������',
			store : eReWardNameDs,
			value:bfrewardnameid,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			// emptyText : '��ѡ�����...',
			name:'eReWardNameField',
			width : 180,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			labelSeparator:'',
			selectOnFocus : true
		});

//////////////////////����ȴ�//////////////////////////////////
var eRewardLevelDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', 'һ�Ƚ�'], ['2', '���Ƚ�'],['3', '���Ƚ�']]
		});
var eRewardLevelField = new Ext.form.ComboBox({
            id:'eRewardLevelField',
			fieldLabel : '����ȴ�',
			width : 180,
			listWidth : 180,
			selectOnFocus : true,
			allowBlank : false,
			store : eRewardLevelDs,
			value:bfrewardlevelid,
			//anchor : '95%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			// emptyText : '',
			name:'eRewardLevelField',
			mode : 'local', // ����ģʽ
			editable : true,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:'',
			forceSelection : true
		});
	
/////////////////��׼��λ///////////////////////
var eRewardUnitDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


eRewardUnitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetUint&str='+encodeURIComponent(Ext.getCmp('eRewardUnitField').getRawValue()),
	method:'POST'});
});

var eRewardUnitField = new Ext.form.ComboBox({
	id: 'eRewardUnitField',
	fieldLabel: '��׼��λ',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:eRewardUnitDs,
	value:bfrewardunitid,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	// emptyText:'��ѡ����׼��λ...',
	name: 'eRewardUnitField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	labelSeparator:'',
	editable:true
});

////////////////////////������///////////////////////
var eRewardDateField = new Ext.form.DateField({
			fieldLabel: '������',
			width:180,
			allowBlank:false,
			value:bfrewarddate,
			//format:'Y-m-d',
			//columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			labelSeparator:'',
			selectOnFocus:'true'
		});
		
//////////////////////��Ժ��λλ��//////////////////////////////////
var eCompleteUnitDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '��һ��ɵ�λ'], ['2', '�ڶ���ɵ�λ'],['3', '������ɵ�λ'],['4', '������ɵ�λ'],['5', '������ɵ�λ'],['6', '������ɵ�λ'],['7', '������ɵ�λ'],['8', '�ڰ���ɵ�λ']]
		});
var eCompleteUnitField = new Ext.form.ComboBox({
            id:'eCompleteUnitField',
			name:'eCompleteUnitField',
			fieldLabel : '��Ժ��λλ��',
			width : 180,
			listWidth : 180,
			selectOnFocus : true,
			allowBlank : false,
			store : eCompleteUnitDs,
			value:bfcompleteunitid,
			//anchor : '95%',
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
			labelSeparator:'',
			forceSelection : true
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
			value:bfprjdr,
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:'',
			forceSelection : true
	});
				
///Ժ�����п���
var eOutPrjNameField = new Ext.form.TextField({
	fieldLabel:'���гɹ����п��п���(Ժ��)',
	width : 180,
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
							columnWidth : .1
						}, */
					   eTypeCombox,
					   eYearField,                          
					   eNameField,
					   eParticipantsGrid,
					   eParticipantsField,
					   IsTheHosCombox,
					   AuthorRangeCombox,  
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
				}
				, {
					xtype: 'fieldset',
					autoHeight: true,
					items: [
						/* {
							xtype : 'displayfield',
							value : '',
							columnWidth : .1
						}, */
						eReWardTypeField,
						eReWardNameField,
						eRewardLevelField,
						eRewardUnitField,
						eRewardDateField,
						eCompleteUnitField,
						ePrjNameField
					]
				 }
				 ]
		}
	]		
  var editFormPanel = new Ext.form.FormPanel({
    labelWidth: 100,
	labelAlign:'right',
	frame: true,
    items: colItems 
	});
	
	editFormPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			eYearField.setRawValue(rowObj[0].get("Year"));
			eNameField.setRawValue(rowObj[0].get("Name"));			
			eReWardTypeField.setRawValue(rowObj[0].get("RewardTypeName"));
			eReWardNameField.setRawValue(rowObj[0].get("RewardName"));
			eRewardLevelField.setRawValue(rowObj[0].get("RewardLevel"));
			eRewardUnitField.setRawValue(rowObj[0].get("RewardUnit"));
			eRewardDateField.setRawValue(rowObj[0].get("RewardDate"));
			eCompleteUnitField.setRawValue(rowObj[0].get("CompleteUnit"));
			eTypeCombox.setRawValue(rowObj[0].get("Type"))
			//ParticipantsGrid.load();
			ePrjNameField.setRawValue(rowObj[0].get("PrjName"));
		});

 var eprawValue="";
  // define window and show it in desktop
  var editWindow = new Ext.Window({
  	title: '�޸Ŀ��гɹ�����',
	iconCls: 'pencil',
    width: 650,
    height:450,
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
      	// check form value
            var Year = eYearField.getValue();
            var Name = eNameField.getValue();
			var RewardType = eReWardTypeField.getValue();
			var eRewardName = eReWardNameField.getValue();
			var RewardLevel = eRewardLevelField.getValue();
			var RewardUnit = eRewardUnitField.getValue();
			var RewardDate = eRewardDateField.getRawValue();
			var CompleteUnit = eCompleteUnitField.getValue();
			//alert("Year:"+Year);
		    var ptotal = eParticipantsGrid.getStore().getCount();
		    
		    var prjdr = ePrjNameField.getValue(); ///libairu20160913������̨
		    
			if(ptotal>0){
				//prawValue = eParticipantsGrid.getStore().getAt(0).get('rowid');
				var authorid = eParticipantsGrid.getStore().getAt(0).get('rowid');
				var authorrangeid = eParticipantsGrid.getStore().getAt(0).get('rangerowid');
				var authoristhehosid = eParticipantsGrid.getStore().getAt(0).get('isthehosrowid');
				eprawValue = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				for(var i=1;i<ptotal;i++){
				  //var prow = eParticipantsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  var authorid = eParticipantsGrid.getStore().getAt(i).get('rowid');
				  var authorrangeid = eParticipantsGrid.getStore().getAt(i).get('rangerowid');
				  var authoristhehosid = eParticipantsGrid.getStore().getAt(i).get('isthehosrowid');
				  var prow = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				  eprawValue = eprawValue+","+prow;
				};
			}
			var Participants = eprawValue;
			var SubUser = userdr;
			
			var Type=eTypeCombox.getValue();
			
			// var year=rowObj[0].get("Year");
            // var name=rowObj[0].get("Name");
			// var participants=rowObj[0].get("Participants");
			// var rewardtype=rowObj[0].get("RewardTypeName");
			// var rewardname=rowObj[0].get("RewardName");
			// var rewardlevel=rowObj[0].get("RewardLevel");
			// var rewardunit=rowObj[0].get("RewardUnit");
			// var rewarddate=rowObj[0].get("RewardDate");
			// var completeunit=rowObj[0].get("CompleteUnit");
			// var subuser=rowObj[0].get("SubUser");
			
           if(eTypeCombox.getRawValue()=="")
     		{
     			Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
     			return;
     		};
           if(eYearField.getRawValue()=="")
     		{
     			Ext.Msg.show({title:'����',msg:'���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
     			return;
     		};
     		if(eNameField.getRawValue()=="")
     		{
     			Ext.Msg.show({title:'����',msg:'����ĿΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
     			return;
     		};
			if(Participants=="")
      		{
      			Ext.Msg.show({title:'����',msg:'������ԱΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
            if(eReWardTypeField.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'����',msg:'�����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(eReWardNameField.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'����',msg:'��������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(eRewardLevelField.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'����',msg:'����ȴ�Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(eRewardUnitField.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'����',msg:'��׼��λΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(eRewardDateField.getValue()=="")
      		{
      			Ext.Msg.show({title:'����',msg:'������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(eCompleteUnitField.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'����',msg:'��Ժ��λλ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			
            //if(year==Year){Year="";}
		    // if(name==Name){Name="";}
			// if(participants==Participants){Participants="";}
			// if(rewardtype==RewardType){RewardType="";}
			// if(rewardname==RewardName){RewardName="";}
			// if(rewardlevel==RewardLevel){RewardLevel="";}
		    // if(rewardunit==RewardUnit){RewardUnit="";}
			// if(rewarddate==RewardDate){RewardDate="";}
			// if(completeunit==CompleteUnit){CompleteUnit="";}
			// if(subuser==SubUser){SubUser="";}
		    
			// alert(Year+"^"+Name+"^"+Participants+"^"+RewardType+"^"+RewardName+"^"+RewardLevel+"^"+RewardUnit+"^"+RewardDate+"^"+CompleteUnit);
        	if (editFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url:  projUrl+'?action=edit&rowid='+rowid+'&Year='+encodeURIComponent(Year)+'&Name='+encodeURIComponent(Name)+'&Participants='+encodeURIComponent(Participants)+'&RewardType='+encodeURIComponent(RewardType)+'&RewardName='+encodeURIComponent(eRewardName)+'&RewardLevel='+encodeURIComponent(RewardLevel)+'&RewardUnit='+encodeURIComponent(RewardUnit)+'&RewardDate='+RewardDate+'&CompleteUnit='+encodeURIComponent(CompleteUnit)+'&SubUser='+SubUser+'&Type='+Type+'&PrjDr='+prjdr,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									var data="||||"+userdr+"|";
									itemGrid.load({params:{start:0, limit:25,data:data}});
									editWindow.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=="RepName") message='���гɹ������ظ�!';
									if(jsonData.info=='RepDate') message='�����ڲ��ܴ��ڵ�ǰ����!';
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
			text: '�ر�',
		iconCls: 'cancel',
        handler: function(){editWindow.close();}
      }]
    });
    editWindow.show();
};
