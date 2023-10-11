var userdr = session['LOGON.USERID'];
var rawValue = "";

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
	url:'herp.srm.srmpatentapplyexe.csp'+'?action=GetDept&str='+encodeURIComponent(Ext.getCmp('DeptFields').getRawValue()),
	method:'POST'});
});

var DeptFields = new Ext.form.ComboBox({
	id: 'DeptFields',
	fieldLabel: '����',
	width:172,
	listWidth : 245,
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
					}, ['rowid', 'name'])
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
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '��ѡ������...',
			width : 120,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

/////////////////�μ���Ա///////////////////////////
var InventorssDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
});


InventorssDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmpatentapplyexe.csp?action=GetInventors&str='+encodeURIComponent(Ext.getCmp('Inventorsss').getRawValue()),
	method:'POST'});
});

var InventorsFields = new Ext.form.ComboBox({
	id: 'Inventorsss',
	fieldLabel: '��Ŀ�μ���Ա',
	width:172,
	listWidth : 245,
	allowBlank: true,
	store:InventorssDs,
	valueField: 'rowid',
	displayField: 'Name',
	triggerAction: 'all',
	emptyText:'��ѡ����Ŀ�μ���Ա...',
	name: 'Inventorsss',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//////////////////////������Դ//////////////////////////////////
var addSubSourceDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
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
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 225,
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
					}, ['rowid', 'name'])
		});
		
RelyUnitDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=RelyUnitList', 
                        method:'POST'
					});
		});

var RelyUnitCombo = new Ext.form.ComboBox({
			fieldLabel : '���е�λ',
			store : RelyUnitDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '��ѡ�����е�λ',
			width : 120,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
	

/////////////////////��ע//////////////////////////
var RemarkField = new Ext.form.TextField({
	id:'RemarkField',
    fieldLabel: '��ע',
	width:180,
	height: 110,
    allowBlank: false,
    emptyText:'��ע...',
    anchor: '95%'
	});

//////////////////�μ���Ա///////////////////////
var InventorsGrid = new Ext.grid.GridPanel({
		id:'InventorsGrid',
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
    height: 110
	//plugins:[rowEditing]
	//tbar:[{text:'���',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});

///////////////��Ӷ���μ���Ա��ť////////////////
var addInventors  = new Ext.Button({
		text: '���',
		handler: function(){
			var InventorId;
			var id = Ext.getCmp('Inventorsss').getValue();
			//alert(id);
			var InventorName = Ext.getCmp('Inventorsss').getRawValue();
			var total = InventorsGrid.getStore().getCount();
			if(total>0){	
				for(var i=0;i<total;i++){
					var erow = InventorsGrid.getStore().getAt(i).get('rowid');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'����',msg:'��ѡ����ͬһ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
							InventorId=id;
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
					InventorId=id;
				}	
			}
			var data = new Ext.data.Record({'rowid':InventorId,'Name':InventorName});
			InventorsGrid.stopEditing(); 
			InventorsGrid.getStore().insert(0,data);
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
		text:'ɾ��',
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
					   //InventorsTextArea,
					   //addInventors
					   RelyUnitCombo,
					   InventorsGrid,
					   InventorsFields,
					   addInventors,
					   delInventors
					  
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
						ProjectNumField,
						AppFundsField,
						StartDateFields,
						EndDateFields,
						ConDateFields,
						RemarkField
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
    height:400,
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
			var total = InventorsGrid.getStore().getCount();
			if(total>0){
				rawValue = InventorsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<total;i++){
				  var row = InventorsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  rawValue = rawValue+","+row;
				};
			}
			var Inventors = rawValue;
      	    var SubSource = addSubSourceCombo.getValue();
			var SubNo = ProjectNumField.getValue();
			var AppFunds = AppFundsField.getValue();
      		var StartDate = StartDateFields.getValue();
        	var EndDate = EndDateFields.getValue();
			var ConDate = ConDateFields.getValue();
			var RelyUnit = RelyUnitCombo.getValue();
			var SubUser = userdr;
			var Remark = RemarkField.getValue();
			
			ProjectsName = ProjectsName.trim();
      		DeptDr = DeptDr.trim();
			HeadDr = HeadDr.trim();
			
			Inventors = Inventors.trim();
      		SubSource = SubSource.trim();
      		SubNo = SubNo.trim();
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
			if(Inventors=="")
      		{
      			Ext.Msg.show({title:'����',msg:'ר���μ���ԱΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(SubSource=="")
      		{
      			Ext.Msg.show({title:'����',msg:'������ԴΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(SubNo=="")
      		{
      			Ext.Msg.show({title:'����',msg:'�������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
			if(ConDate=="")
      		{
      			Ext.Msg.show({title:'����',msg:'����ʱ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(RelyUnit=="")
      		{
      			Ext.Msg.show({title:'����',msg:'���е�λΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      	    if (addFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url: 'herp.srm.srmprojectsapplyexe.csp?action=add&ProjectsName='+encodeURIComponent(ProjectsName)+'&Inventors='+Inventors+'&HeadDr='+HeadDr+'&EndDate='+EndDate+'&SubSource='+SubSource+'&SubNo='+SubNo+'&AppFunds='+AppFunds+'&StartDate='+StartDate+'&SubUser='+SubUser+'&DeptDr='+DeptDr+'&ConDate='+ConDate+'&RelyUnit='+RelyUnit+'&Remark='+encodeURIComponent(Remark),
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								  itemGrid.load({params:{start:0, limit:25}});
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
						addwin.close();
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
