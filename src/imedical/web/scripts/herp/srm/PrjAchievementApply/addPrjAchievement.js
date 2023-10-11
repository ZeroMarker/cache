var userdr = session['LOGON.USERCODE'];

var projUrl='herp.srm.prjachievementapplyexe.csp';

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

///////////////////����/////////////////////////////  
var aTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '����'],['2', '��ѧ']]
	});		
		
var aTypeCombox = new Ext.form.ComboBox({
	                   id : 'aTypeCombox',
		           fieldLabel : '����',
	                   width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : aTypeDs,
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
/////////////////���///////////////////////
var aYearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


aYearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=yearList&str='+encodeURIComponent(Ext.getCmp('aYearField').getRawValue()),
	method:'POST'});
});

var aYearField = new Ext.form.ComboBox({
	id: 'aYearField',
	fieldLabel: '���',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:aYearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ�����...',
	name: 'aYearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	labelSeparator:'',
	forceSelection:'true',
	editable:true
});

///////////////////////������//////////////////////////////
var aNameField = new Ext.form.TextArea({
	id:'aNameField',
	width:180,
	fieldLabel: '����Ŀ',
	//allowBlank: false,
	labelSeparator:''
	// emptyText:'��Ŀ...'
	//anchor: '95%'
});

//////////////////////////������Ա��λ�Ρ��Ƿ�Ժ////////////////////////////////////////////////////////////////////////
//////////////////�μ���Ա///////////////////////
var aParticipantsDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


aParticipantsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=userList&str='+encodeURIComponent(Ext.getCmp('aParticipantsField').getRawValue()),
	method:'POST'});
});

var aParticipantsField = new Ext.form.ComboBox({
	id: 'aParticipantsField',
	fieldLabel: '��Ŀ�μ���Ա',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:aParticipantsDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	// emptyText:'��ѡ����Ŀ�μ���Ա...',
	name: 'aParticipantsField',
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
				   labelSeparator:'',
		           // value:1,
		           selectOnFocus : true,
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
				   labelSeparator:'',
		           //emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
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

var aParticipantsGrid = new Ext.grid.GridPanel({
		id:'aParticipantsGrid',
    	store: new Ext.data.Store({
        autoLoad:true,
		proxy: new Ext.data.MemoryProxy(),
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
			var id = Ext.getCmp('aParticipantsField').getValue();
			var rangeid = Ext.getCmp('AuthorRangeCombox').getValue();
			var isthehosid = Ext.getCmp('IsTheHosCombox').getValue();
			//alert(id);
			var ParticipantsName = Ext.getCmp('aParticipantsField').getRawValue();
			var AuthorRange = Ext.getCmp('AuthorRangeCombox').getRawValue();
			var IsTheHos = Ext.getCmp('IsTheHosCombox').getRawValue();
			var ptotal = aParticipantsGrid.getStore().getCount();
			if(ptotal>0){	
				for(var i=0;i<ptotal;i++){
					var erow = aParticipantsGrid.getStore().getAt(i).get('rowid');
					var tmprange = aParticipantsGrid.getStore().getAt(i).get('range');
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
				}
				if(isthehosid=="")
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
			aParticipantsGrid.stopEditing(); 
			aParticipantsGrid.getStore().insert(ptotal,data);
			// if(ptotal>0){
			   //prawValue=aParticipantsGrid.getStore().getAt(i).get('rowid');
				// var authorid = aParticipantsGrid.getStore().getAt(0).get('rowid');
				// var authorrangeid = aParticipantsGrid.getStore().getAt(0).get('rangerowid');
				// var authoristhehosid = aParticipantsGrid.getStore().getAt(0).get('isthehosrowid');
				// prawValue = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				// for(var i=1;i<ptotal;i++){
				  //var prow = aParticipantsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  // var authorid = aParticipantsGrid.getStore().getAt(i).get('rowid');
				  // var authorrangeid = aParticipantsGrid.getStore().getAt(i).get('rangerowid');
				  // var authoristhehosid = aParticipantsGrid.getStore().getAt(i).get('isthehosrowid');
				  // var prow = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				  // prawValue = prawValue+","+prow;
				// }
			// }
			//alert(rawValue);
			//alert(InventorId+"  "+InventorName);
		}
	});	
var delParticipants = new Ext.Button({
		text:'ɾ��',
		iconCls:'edit_remove',
		handler: function() {  
			var rows = aParticipantsGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				rRowid = aParticipantsGrid.getStore().indexOf(rows[0]); //����кţ�������rowid
				aParticipantsGrid.getStore().removeAt(rRowid);//�Ƴ���ѡ�е�һ��
			}

//			var ptotal = aParticipantsGrid.getStore().getCount();
//			//alert(total);
//			if(ptotal>0){
//				prawValue = aParticipantsGrid.getStore().getAt(0).get('rowid');
//				for(var i=1;i<ptotal;i++){
//				  var prow = aParticipantsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
//				  prawValue = prawValue+","+prow;
//				}
//			}
			
		}
	});
/////////////////��������////////////////////////////
var aReWardTypeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

aReWardTypeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=rewardTypeList',
						method : 'POST'
					});
		});

var aReWardTypeField = new Ext.form.ComboBox({
            id: 'aReWardTypeField',
			fieldLabel: '�����',
			store : aReWardTypeDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			// emptyText : '��ѡ��������...',
			name:'aReWardTypeField',
			width : 180,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			labelSeparator:'',
			selectOnFocus : true
		});

/////////////////�����////////////////////////////
var aReWardNameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

aReWardNameDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=rewardDictList',
						method : 'POST'
					});
		});

var aReWardNameField = new Ext.form.ComboBox({
            id: 'aReWardNameField',
			fieldLabel: '��������',
			store : aReWardNameDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			// emptyText : '��ѡ�����...',
			name:'aReWardNameField',
			width : 180,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			labelSeparator:'',
			selectOnFocus : true
		});

//////////////////////����ȴ�//////////////////////////////////
var aRewardLevelDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', 'һ�Ƚ�'], ['2', '���Ƚ�'],['3', '���Ƚ�']]
		});
var aRewardLevelField = new Ext.form.ComboBox({
            id:'aRewardLevelField',
			fieldLabel : '����ȴ�',
			width : 180,
			listWidth : 180,
			selectOnFocus : true,
			//allowBlank : false,
			store : aRewardLevelDs,
			//anchor : '95%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			name:'aRewardLevelField',
			mode : 'local', // ����ģʽ
			editable : false,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:'',
			forceSelection : true
		});
	
/////////////////��׼��λ///////////////////////
var aRewardUnitDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


aRewardUnitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetUint&str='+encodeURIComponent(Ext.getCmp('aRewardUnitField').getRawValue()),
	method:'POST'});
});

var aRewardUnitField = new Ext.form.ComboBox({
	id: 'aRewardUnitField',
	fieldLabel: '��׼��λ',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:aRewardUnitDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	// emptyText:'��ѡ����׼��λ...',
	name: 'aRewardUnitField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	labelSeparator:'',
	editable:true
});

////////////////////////������///////////////////////
var aRewardDateField = new Ext.form.DateField({
			fieldLabel: '������',
			width:180,
			//allowBlank:false,
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
var aCompleteUnitDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '��һ��ɵ�λ'], ['2', '�ڶ���ɵ�λ'],['3', '������ɵ�λ'],['4', '������ɵ�λ'],['5', '������ɵ�λ'],['6', '������ɵ�λ'],['7', '������ɵ�λ'],['8', '�ڰ���ɵ�λ']]
		});
var aCompleteUnitField = new Ext.form.ComboBox({
            id:'aCompleteUnitField',
			name:'aCompleteUnitField',
			fieldLabel : '��Ժ��λλ��',
			width : 180,
			listWidth : 180,
			selectOnFocus : true,
			//allowBlank : false,
			store : aCompleteUnitDs,
			//anchor : '95%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			// emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			//pageSize : 10,
			minChars : 1,
			labelSeparator:'',
			selectOnFocus : true,
			forceSelection : true
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
			// emptyText : '',
			//mode : 'local', // ����ģʽ
			name:'PrjNameField',
			editable : true,
			pageSize : 10,
			minChars : 1,
			labelSeparator:'',
			selectOnFocus : true,
			forceSelection : true
		});

///Ժ�����п���
var OutPrjNameField = new Ext.form.TextField({
	fieldLabel:'������Ŀ(Ժ��)',
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
					   aTypeCombox,
					   aYearField,                          
					   aNameField,
					   aParticipantsGrid,
					   aParticipantsField,
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
							},delParticipants,
							    {
							       xtype : 'displayfield',
							       columnWidth : .07
							    }
							    /*,
							    {
							       xtype : 'displayfield',
							       value : ' *�����ȫ����Ŀ��Ա��',
							       columnWidth : .7,
							       style:'color:red;'
							    }
							    */
							
							]
						},{
							columnWidth : 1,
						    xtype : 'panel',
						    layout : "column",
						    items : [
							{
							xtype : 'displayfield',
							value : ' *�����ȫ����Ŀ������Ա����Ժ��Ա������ӣ�',
							columnWidth : 1,
							style:'color:red;'
							}
							]
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
						aReWardTypeField,
						aReWardNameField,
						aRewardLevelField,
						aRewardUnitField,
						aRewardDateField,
						aCompleteUnitField,
						PrjNameField
					]
				 }
				 ]
		}
	]		
	// create form panel
  var addFormPanel = new Ext.form.FormPanel({
    //baseCls : 'x-plain',  Panel����ɫ��ɫ
    labelWidth: 100,
	labelAlign:'right',
	//labelAlign:'right',
	frame: true,
    items: colItems
	});
    
  var prawValue="";
  
  var addWindow = new Ext.Window({
  	title: '�������гɹ�����',
	iconCls: 'edit_add',
    width: 650,
    height:450,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: addFormPanel,
    buttons: [{
    	text: '����', 
		iconCls: 'save', 
      handler: function() {
      
            var Year = aYearField.getValue();
            var Name = aNameField.getValue();
			var RewardType = aReWardTypeField.getValue();
			var RewardName = aReWardNameField.getValue();
			var RewardLevel = aRewardLevelField.getValue();
			var RewardUnit = aRewardUnitField.getValue();
			var RewardDate = aRewardDateField.getRawValue();
			var CompleteUnit = aCompleteUnitField.getValue();
			
		    var ptotal = aParticipantsGrid.getStore().getCount();
		    
		    var prjdr = PrjNameField.getValue(); ///libairu20160913������̨
			if(ptotal>0){
				//prawValue = aParticipantsGrid.getStore().getAt(0).get('rowid');
				var authorid = aParticipantsGrid.getStore().getAt(0).get('rowid');
				var authorrangeid = aParticipantsGrid.getStore().getAt(0).get('rangerowid');
				var authoristhehosid = aParticipantsGrid.getStore().getAt(0).get('isthehosrowid');
				prawValue = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				for(var i=1;i<ptotal;i++){
				  //var prow = aParticipantsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  var authorid = aParticipantsGrid.getStore().getAt(i).get('rowid');
				  var authorrangeid = aParticipantsGrid.getStore().getAt(i).get('rangerowid');
				  var authoristhehosid = aParticipantsGrid.getStore().getAt(i).get('isthehosrowid');
				  var prow = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				  prawValue = prawValue+","+prow;
				};
			}
			//alert("prawValue:"+prawValue);
			var Participants = prawValue;
			var SubUser = userdr;
			
			var Type = aTypeCombox.getValue();
      		
			if (Type=="")
			{
      			Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if (Year=="")
			{
      			Ext.Msg.show({title:'����',msg:'���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(Name=="")
      		{
      			Ext.Msg.show({title:'����',msg:'����ĿΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(Participants=="")
      		{
      			Ext.Msg.show({title:'����',msg:'������ԱΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
            if(RewardType=="")
      		{
      			Ext.Msg.show({title:'����',msg:'�����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(RewardName=="")
      		{
      			Ext.Msg.show({title:'����',msg:'��������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(RewardLevel=="")
      		{
      			Ext.Msg.show({title:'����',msg:'����ȴ�Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(RewardUnit=="")
      		{
      			Ext.Msg.show({title:'����',msg:'��׼��λΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(RewardDate=="")
      		{
      			Ext.Msg.show({title:'����',msg:'������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(CompleteUnit=="")
      		{
      			Ext.Msg.show({title:'����',msg:'��Ժ��λλ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			
			
			//alert(Type);
      	    if (addFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url: projUrl+'?action=add&Year='+encodeURIComponent(Year)+'&Name='+encodeURIComponent(Name)+'&Participants='+encodeURIComponent(Participants)+'&RewardType='+encodeURIComponent(RewardType)+'&RewardName='+encodeURIComponent(RewardName)+'&RewardLevel='+encodeURIComponent(RewardLevel)+'&RewardUnit='+encodeURIComponent(RewardUnit)+'&RewardDate='+RewardDate+'&CompleteUnit='+encodeURIComponent(CompleteUnit)+'&SubUser='+userdr+'&Type='+Type+'&PrjDr='+prjdr,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								  var data="||||"+userdr+"|";
								  itemGrid.load({params:{start:0, limit:25,data:data}});
									//window.close();
								  addWindow.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='RepName') message='���гɹ������ظ�!';	
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
        handler: function(){addWindow.close();}
      }]
    });

    addWindow.show();
};
