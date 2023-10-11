var userdr = session['LOGON.USERCODE'];

var projUrl='herp.srm.srmprojectsapplyexe.csp';

var prawValue = "";
var urawValue = "";
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
	
	
///////////////////////��������//////////////////////////////
var ProjectsNameFields = new Ext.form.TextField({
	id:'ProjectsNameFields',
	width:180,
	fieldLabel: '��������',
	allowBlank: false,
	emptyText:'��������...',
	anchor: '95%'
});
	

/////////////////����///////////////////////
var DeptsDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
});


DeptsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetDept&str='+encodeURIComponent(Ext.getCmp('DeptFields').getRawValue()),
	method:'POST'});
});

var DeptFields = new Ext.form.ComboBox({
	id: 'DeptFields',
	fieldLabel: '����',
	width:172,
	listWidth : 220,
	allowBlank: true,
	store:DeptsDs,
	valueField: 'rowid',
	displayField: 'Name',
	triggerAction: 'all',
	emptyText:'��ѡ�����...',
	name: 'DeptFields',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


/////////////////������////////////////////////////
var HeadDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'Name'])
		});

HeadDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=applyerList',
						method : 'POST'
					});
		});

var HeadCombo = new Ext.form.ComboBox({
            id: 'HeadCombo',
			fieldLabel: '������',
			store : HeadDs,
			displayField : 'Name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '��ѡ������...',
			width : 172,
			listWidth : 220,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});


//////////////////////������Դ//////////////////////////////////
var addSubSourceDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'Name'])
		});
		
addSubSourceDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=sourceList', 
                        method:'POST'
					});
		});

var addSubSourceCombo = new Ext.form.ComboBox({
			fieldLabel : '������Դ',
			store : addSubSourceDs,
			displayField : 'Name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 172,
			listWidth : 220,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
		
/////////////////////������//////////////////////////
var ProjectNumField = new Ext.form.TextField({
	id:'PatentNumField',
    fieldLabel: '������',
	width:180,
    allowBlank: false,
    emptyText:'������...',
    anchor: '95%'
	});

///////////////////////���뾭��///////////////////////////
var AppFundsField = new Ext.form.TextField({
	id:'AppFundsField',
	fieldLabel: '���뾭��',
	width:180,
	allowBlank: false,
	emptyText:'���뾭��...',
	anchor: '95%'
});

/////////////////������ʼʱ��///////////////////////
var StartDateFields = new Ext.form.DateField({
			fieldLabel: '���⿪ʼ����',
			width:172,
			allowBlank:false,
			//format:'Y-m-d',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});



////////////////////////�����ֹ����///////////////////////
var EndDateFields = new Ext.form.DateField({
			fieldLabel: '�����ֹ����',
			width:172,
			allowBlank:false,
			//format:'Y-m-d',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});
		
		
/////////////////����ʱ��///////////////////////
var ConDateFields = new Ext.form.DateField({
			fieldLabel: '��������',
			width:172,
			allowBlank:false,
			//format:'Y-m-d',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});


		
//////////////////////���е�λ//////////////////////////////////
var RelyUnitDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'Name'])
		});
		
RelyUnitDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url :projUrl+'?action=GetRelyUnit', 
                        method:'POST'
					});
		});

var RelyUnitCombo = new Ext.form.ComboBox({
			id:'RelyUnitCombo',
			fieldLabel : '���е�λ',
			store : RelyUnitDs,
			displayField : 'Name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '��ѡ�����е�λ',
			width : 172,
			listWidth : 220,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});


var RelyUnitsGrid = new Ext.grid.GridPanel({
		id:'RelyUnitsGrid',
    	store: new Ext.data.Store({
        autoLoad:true,
		proxy: new Ext.data.MemoryProxy(),
		reader: new Ext.data.ArrayReader({}, [  
			 {name: 'rowid'},  
			 {name: 'Name'}
         ])  
    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 129,
            sortable: true
        },
        columns: [
            {id: 'rowid', header: '���е�λID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '���е�λ����', dataIndex: 'Name',align:'center',width: 258}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 260,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'���',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});

///////////////��Ӷ�����е�λ��ť////////////////
var addRelyUnits  = new Ext.Button({
		text: '���',
		handler: function(){
			var RelyUnitId;
			var id = Ext.getCmp('RelyUnitCombo').getValue();
			//alert(id);
			var RelyUnitName = Ext.getCmp('RelyUnitCombo').getRawValue();
			var utotal = RelyUnitsGrid.getStore().getCount();
			if(utotal>0){	
				for(var i=0;i<utotal;i++){
					var erow = RelyUnitsGrid.getStore().getAt(i).get('rowid');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'����',msg:'��ѡ����ͬһ�����е�λ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
							RelyUnitId=id;
						}
					}else{
						Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵ����е�λ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				}
			}else{
				if(id==""){
					Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵ����е�λ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}else{
					RelyUnitId=id;
				}	
			}
			var data = new Ext.data.Record({'rowid':RelyUnitId,'Name':RelyUnitName});
			RelyUnitsGrid.stopEditing(); 
			RelyUnitsGrid.getStore().insert(0,data);
			if(utotal>0){
				urawValue = RelyUnitsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<utotal;i++){
				  var urow = RelyUnitsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  urawValue = urawValue+","+urow;
				}
			}
			//alert(rawValue);
			//alert(InventorId+"  "+InventorName);
		}
	});	
var delRelyUnits= new Ext.Button({
		text:'ɾ��',
		handler: function() {  
			var rows = RelyUnitsGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				rRowid = RelyUnitsGrid.getStore().indexOf(rows[0]); //����кţ�������rowid
				RelyUnitsGrid.getStore().removeAt(rRowid);//�Ƴ���ѡ�е�һ��
			}

			var utotal = RelyUnitsGrid.getStore().getCount();
			//alert(total);
			if(utotal>0){
				urawValue = RelyUnitsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<utotal;i++){
				  var urow = RelyUnitsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  urawValue = urawValue+","+urow;
				}
			}
			
		}
	});


/////////////////////��ע//////////////////////////
var RemarkField = new Ext.form.TextField({
	id:'RemarkField',
    fieldLabel: '��ע',
	width:180,
    allowBlank: false,
    emptyText:'��ע...',
    anchor: '95%'
	});

//////////////////�μ���Ա///////////////////////
var ParticipantssDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
});


ParticipantssDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmprojectsapplyexe.csp?action=GetParticipants&str='+encodeURIComponent(Ext.getCmp('Participantsss').getRawValue()),
	method:'POST'});
});

var ParticipantsFields = new Ext.form.ComboBox({
	id: 'Participantsss',
	fieldLabel: '��Ŀ�μ���Ա',
	width:172,
	listWidth : 220,
	allowBlank: true,
	store:ParticipantssDs,
	valueField: 'rowid',
	displayField: 'Name',
	triggerAction: 'all',
	emptyText:'��ѡ����Ŀ�μ���Ա...',
	name: 'Participantsss',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


var ParticipantsGrid = new Ext.grid.GridPanel({
		id:'ParticipantsGrid',
    	store: new Ext.data.Store({
        autoLoad:true,
		proxy: new Ext.data.MemoryProxy(),
		reader: new Ext.data.ArrayReader({}, [  
			 {name: 'rowid'},  
			 {name: 'Name'}
         ])  
    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 129,
            sortable: true
        },
        columns: [
            {id: 'rowid', header: '�μ���ԱID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '�μ���Ա����', dataIndex: 'Name',align:'center',width: 258}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 260,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'���',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});

///////////////��Ӷ���μ���Ա��ť////////////////
var addParticipants  = new Ext.Button({
		text: '���',
		handler: function(){
			var ParticipantsId;
			var id = Ext.getCmp('Participantsss').getValue();
			//alert(id);
			var ParticipantsName = Ext.getCmp('Participantsss').getRawValue();
			var ptotal = ParticipantsGrid.getStore().getCount();
			if(ptotal>0){	
				for(var i=0;i<ptotal;i++){
					var erow = ParticipantsGrid.getStore().getAt(i).get('rowid');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'����',msg:'��ѡ����ͬһ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
							ParticipantsId=id;
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
				}else{
					ParticipantsId=id;
				}	
			}
			var data = new Ext.data.Record({'rowid':ParticipantsId,'Name':ParticipantsName});
			ParticipantsGrid.stopEditing(); 
			ParticipantsGrid.getStore().insert(0,data);
			if(ptotal>0){
				prawValue = ParticipantsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<ptotal;i++){
				  var prow = ParticipantsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  prawValue = prawValue+","+prow;
				}
			}
			//alert(rawValue);
			//alert(InventorId+"  "+InventorName);
		}
	});	
var delParticipants = new Ext.Button({
		text:'ɾ��',
		handler: function() {  
			var rows = ParticipantsGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				rRowid = ParticipantsGrid.getStore().indexOf(rows[0]); //����кţ�������rowid
				ParticipantsGrid.getStore().removeAt(rRowid);//�Ƴ���ѡ�е�һ��
			}

			var ptotal = ParticipantsGrid.getStore().getCount();
			//alert(total);
			if(ptotal>0){
				prawValue = ParticipantsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<ptotal;i++){
				  var prow = ParticipantsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  prawValue = prawValue+","+prow;
				}
			}
			
		}
	});
 //FundGov, FundOwn, FundMatched, IsGovBuy, AlertPercent,PrjCN, PrjDestination, PrjRescContent, PrjCheck
 // ////////////�ϼ�����////////
var FundGovField = new Ext.form.TextField({
	id:'FundGovField',
    fieldLabel: '�ϼ�����',
	width:180,
    allowBlank: false,
    emptyText:'�ϼ�����...',
    anchor: '95%',
	selectOnFocus : true
});
////////////////////ҽԺ�Գ�//////////////////////
var FundOwnField = new Ext.form.TextField({
	id:'FundOwnField',
    fieldLabel: 'ҽԺ�Գ�',
	width:180,
    allowBlank: false,
    emptyText:'ҽԺ�Գ�...',
    anchor: '95%',
	selectOnFocus : true
});
///////////////////���´�//////////////////////
var FundMatchedField = new Ext.form.TextField({
	id:'FundMatchedField',
    fieldLabel: '��ƥ��',
	width:180,
    allowBlank: false,
    emptyText:'��ƥ��...',
    anchor: '95%',
	selectOnFocus : true
});
//////////////////////�Ƿ������ɹ�/////////////////////
var IsGovBuyStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '��'], ['1', '��']]
		});
var IsGovBuyField = new Ext.form.ComboBox({
			fieldLabel : '�Ƿ������ɹ�',
			width : 120,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : false,
			store : IsGovBuyStore,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
//////////////////////������/////////////////////////
var AlertPercentField = new Ext.form.TextField({
	id:'AlertPercentField',
    fieldLabel: '������',
	width:180,
    allowBlank: false,
    emptyText:'90...',
    anchor: '95%',
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
						{
							xtype : 'displayfield',
							value : '',
							columnWidth : .1
						},
					   ProjectsNameFields,                          
					   DeptFields,
					   HeadCombo,
					   //ParticipantsTextArea,
					   //addParticipants,
					   RelyUnitsGrid,
					   RelyUnitCombo,
					    {
						columnWidth : 1,
						xtype : 'panel',
						layout : "column",
						items : [{
							xtype : 'displayfield',
							
							columnWidth : .05
							},addRelyUnits,{
							xtype : 'displayfield',
							
							columnWidth : .07
							},delRelyUnits]
						},
					   ParticipantsGrid,
					   ParticipantsFields,
					    {
						columnWidth : 1,
						xtype : 'panel',
						layout : "column",
						items : [{
							xtype : 'displayfield',
							
							columnWidth : .05
							},addParticipants,{
							xtype : 'displayfield',
							
							columnWidth : .07
							},delParticipants]
						}
					   //addParticipants,
					   //delParticipants
					  
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
						addSubSourceCombo,
						//PatenteeFields,
						//ProjectNumField,
						AppFundsField,
						StartDateFields,
						EndDateFields,
						//ConDateFields,
						RemarkField,
						IsGovBuyField,
						FundGovField,
						FundOwnField,
						FundMatchedField,
						AlertPercentField
					]
				 }]
		}
	]		
	// create form panel
  var addFormPanel = new Ext.form.FormPanel({
    labelWidth: 80,
	frame: true,
    items: colItems
	});
    
  // define window and show it in desktop
  var addWindow = new Ext.Window({
  	title: '�����Ŀ��������',
    width: 600,
    height:510,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: addFormPanel,
    buttons: [{
    	text: '����', 
      handler: function() {
      		// check form value
      		var ProjectsName = ProjectsNameFields.getValue();
      		var DeptDr = DeptFields.getValue();
			var HeadDr = HeadCombo.getValue();
			var ptotal = ParticipantsGrid.getStore().getCount();
			if(ptotal>0){
				prawValue = ParticipantsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<ptotal;i++){
				  var prow = ParticipantsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  prawValue = prawValue+","+prow;
				};
			}
			var Participants = prawValue;
			//alert(Participants);
      	    var SubSource = addSubSourceCombo.getValue();
			var SubNo = ProjectNumField.getValue();
			var AppFunds = AppFundsField.getValue();
      		var StartDate = StartDateFields.getValue();
        	var EndDate = EndDateFields.getValue();
			var ConDate = ConDateFields.getValue();
			var utotal = RelyUnitsGrid.getStore().getCount();
			if(utotal>0){
				urawValue = RelyUnitsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<utotal;i++){
				  var urow = RelyUnitsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  urawValue = urawValue+","+urow;
				};
			}
			var RelyUnit = urawValue;
			var SubUser = userdr;
			var Remark = RemarkField.getValue();
			
			var FundGov = FundGovField.getValue();
			var FundOwn = FundOwnField.getValue();
			var FundMatched = FundMatchedField.getValue();
			var IsGovBuy = IsGovBuyField.getValue();
			var AlertPercent = AlertPercentField.getValue();
			
			ProjectsName = ProjectsName.trim();
      		DeptDr = DeptDr.trim();
			HeadDr = HeadDr.trim();
			
			Participants = Participants.trim();////ȥ�����ҵĿո�
      		SubSource = SubSource.trim();
      		//SubNo = SubNo.trim();
			AppFunds = AppFunds.trim();
			RelyUnit = RelyUnit.trim();
      		Remark = Remark.trim();
      		
      		if(ProjectsName=="")
      		{
      			Ext.Msg.show({title:'����',msg:'��Ŀ����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(DeptDr=="")
      		{
      			Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(HeadDr=="")
      		{
      			Ext.Msg.show({title:'����',msg:'������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(Participants=="")
      		{
      			Ext.Msg.show({title:'����',msg:'���������ԱΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(SubSource=="")
      		{
      			Ext.Msg.show({title:'����',msg:'������ԴΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(StartDate=="")
      		{
      			Ext.Msg.show({title:'����',msg:'��Ŀ��ʼʱ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(EndDate=="")
      		{
      			Ext.Msg.show({title:'����',msg:'��Ŀ����ʱ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		
			   if(RelyUnit=="")
      		{
      			Ext.Msg.show({title:'����',msg:'���е�λΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      	    if (addFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url: 'herp.srm.srmprojectsapplyexe.csp?action=add&ProjectsName='+encodeURIComponent(ProjectsName)+'&Participants='+Participants+'&HeadDr='+HeadDr+'&EndDate='+EndDate+'&SubSource='+SubSource+'&SubNo='+''+'&AppFunds='+AppFunds+'&StartDate='+StartDate+'&SubUser='+SubUser+'&DeptDr='+DeptDr+'&ConDate='+ConDate+'&RelyUnit='+RelyUnit+'&Remark='+encodeURIComponent(Remark)+'&FundGov='+FundGov+'&FundOwn='+FundOwn+'&FundMatched='+FundMatched+'&IsGovBuy='+encodeURIComponent(IsGovBuy)+'&AlertPercent='+AlertPercent,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								  itemGrid.load({params:{start:0, limit:25,userdr:userdr}});
									//window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='RepProjects') message='�������Ŀ�Ѿ�����!';	
									//if(jsonData.info=='RepName') message='�����ר�������Ѿ�����!';							
								  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
						addWindow.close();
        	}
        	else{
						Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ�����ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}             
	    	}
    	},
		
    	{
				text: 'ȡ��',
        handler: function(){addWindow.close();}
      }]
    });

    addWindow.show();
};
