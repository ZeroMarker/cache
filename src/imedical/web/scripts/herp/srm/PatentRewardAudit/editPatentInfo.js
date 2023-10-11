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
editFun = function(InventorsIDs) {
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
		myRowid = rowObj[0].get("rowid"); 
	}

	///////////////////////ר������//////////////////////////////
var eNameField = new Ext.form.TextField({
	id:'Name',
	width:180,
	fieldLabel: 'ר������',
	allowBlank: false,
	name:'Name',
	emptyText:'ר������...',
	anchor: '95%'
});

	

/////////////////����///////////////////////
var eDeptsDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
});


eDeptsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmpatentrewardauditexe.csp'+'?action=GetDept&str='+encodeURIComponent(Ext.getCmp('DeptDr').getRawValue()),
	method:'POST'});
});

var eDeptFields = new Ext.form.ComboBox({
	id: 'DeptDr',
	fieldLabel: '����',
	width:172,
	listWidth : 220,
	allowBlank: true,
	store:eDeptsDs,
	valueField: 'rowid',
	displayField: 'Name',
	triggerAction: 'all',
	emptyText:'��ѡ�����...',
	name: 'DeptDr',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});



/////////////////ר��������///////////////////////////
var eInventorssDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
});


eInventorssDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmpatentrewardauditexe.csp?action=GetInventors&str='+encodeURIComponent(Ext.getCmp('Inventors').getRawValue()),
	method:'POST'});
});

var eInventorsFields = new Ext.form.ComboBox({
	id: 'eInventors',
	fieldLabel: 'ר��������',
	width:172,
	listWidth : 220,
	allowBlank: true,
	store:eInventorssDs,
	valueField: 'rowid',
	displayField: 'Name',
	triggerAction: 'all',
	emptyText:'������ѡ��ר��������...',
	name: 'eInventors',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


///////////////////////֤���///////////////////////////
var eCertificateNoField = new Ext.form.TextField({
	id:'CertificateNo',
	fieldLabel: '֤���',
	width:180,
	allowBlank: false,
	name:'CertificateNo',
	emptyText:'֤���...',
	anchor: '95%'
});



////////////////////////��Ȩ����///////////////////////
var eAnnDateFields = new Ext.form.DateField({
			fieldLabel: '��Ȩ��������',
			width:172,
			allowBlank:false,
			//format:'Y-m-d',
			name:'AnnDate',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});
		
		

//////////////////////���//////////////////////////////////
var eYearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
});


eYearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmpatentrewardauditexe.csp'+'?action=GetYear&str='+encodeURIComponent(Ext.getCmp('YearDr').getRawValue()),
	method:'POST'});
});

var eYearField = new Ext.form.ComboBox({
	id: 'YearDr',
	fieldLabel: '���',
	width:172,
	listWidth : 220,
	allowBlank: true,
	store:eYearDs,
	valueField: 'rowid',
	displayField: 'Name',
	triggerAction: 'all',
	emptyText:'��ѡ�����...',
	name: 'YearDr',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});



/////////////////ר��Ȩ��///////////////////
var ePatenteesDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
});


ePatenteesDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmpatentrewardauditexe.csp'+'?action=GetPatentee&str='+encodeURIComponent(Ext.getCmp('Patentee').getRawValue()),
	method:'POST'});
});

var ePatenteeFields = new Ext.form.ComboBox({
	id: 'Patentee',
	fieldLabel: 'ר��Ȩ��',
	width:172,
	listWidth : 220,
	allowBlank: true,
	store:ePatenteesDs,
	valueField: 'rowid',
	displayField: 'Name',
	triggerAction: 'all',
	emptyText:'��ѡ��ר��Ȩ��...',
	name: 'Patentee',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});





/////////////////////ר����//////////////////////////
var ePatentNumField = new Ext.form.TextField({
	id:'PatentNum',
    fieldLabel: 'ר����',
	width:180,
    allowBlank: false,
	name:'PatentNum',
    emptyText:'ר����...',
    anchor: '95%'
	});
	


/////////////////��������///////////////////////
var eAppDateFields = new Ext.form.DateField({
			fieldLabel: '��������',
			width:172,
			allowBlank:false,
			//format:'Y-m-d',
			columnWidth : .12,
			name:'AppDate',
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});


/*
///////////////ר�������˶�ѡ��//////////////////
var eInventorsTextArea = new Ext.form.TextArea({
		id: 'eInventorsTextArea',
		name: 'eInventorsTextArea',
		autoScroll: true
	});
//////////////ר�������˵�id//////////////////
var InventorsIDs = new Ext.form.TextField({
		id: 'InventorsIDs',
		name: 'InventorsIDs',
		width: 180,
		anchor: '95%'
	});
*/
//////////////////ר��������///////////////////////
var InventorsGrid = new Ext.grid.GridPanel({
		id:'InventorsGrid',
    	store: new Ext.data.Store({
        autoLoad:true,
		proxy: new Ext.data.HttpProxy({
		url:'herp.srm.srmpatentrewardauditexe.csp'+'?action=InventorID&start='+0+'&limit='+25+'&InventorsIDs='+InventorsIDs,
		method:'POST'}),
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 129,
            sortable: true
        },
        columns: [
            {id: 'rowid', header: '������ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '����������', dataIndex: 'Name',align:'center',width: 258}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 260,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'���',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});

///////////////��Ӷ�������˰�ť////////////////
var eaddInventors  = new Ext.Button({
		text: '���',
		handler: function(){
			var InventorId;
			var id = Ext.getCmp('eInventors').getValue();
			var InventorName = Ext.getCmp('eInventors').getRawValue();
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
		}
	});	
var edelInventors = new Ext.Button({
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
				/*
					grid.getSelectionModel().getSelected();//��ȡѡ�еĵ�һ����¼,����record����
					grid.getSelectionModel().getSelections();//��ȡѡ�е�ȫ����¼,����һ������,����ȫ��record����
					
					grid.store.remove(record);//������record���͵�,�Ƴ�������
					grid.store.removeAt(rowIndex);//����������,�Ƴ�����
					grid.store.removeAll();//�Ƴ�ȫ������
					
					����������Щ,ɾ���ͼ���
					ɾ��ѡ�еĵ�һ����¼
					grid.store.remove(grid.getSelectionModel().getSelected());
					ɾ��ѡ�е�ȫ����¼
					var records = grid.getSelectionModel().getSelections();
					for(var i = 0,len = records.length;i<len;i++ ){
							grid.store.remove(records[i]);
					}
				*/
				 //InventorsGrid.getView().refresh();
				 //InventorsGrid.load({params:{start:0,limit:25,InventorsIDs:InventorsIDs}});
				 //alert(myRowid);	 
			}
			//alert(InventorsGrid.getColumnModel( ).getDataIndex(0).length);
			var total = InventorsGrid.getStore().getCount();
			if(total>0){
				rawValue = InventorsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<total;i++){
				  var row = InventorsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  rawValue = rawValue+","+row;
				}
			}
		}
	});
	
	// create form panel
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
			
					  /* eNameField,  
					  eDeptFields,
					   eInventorsFields,
					   eCertificateNoField,
					   eAnnDateFields*/
					   
					   eNameField,  
					   eDeptFields,
					   InventorsGrid,
					   //eInventorsTextArea,
					   eInventorsFields,
					   {
						columnWidth : 1,
						xtype : 'panel',
						layout : "column",
						items : [{
							xtype : 'displayfield',
							
							columnWidth : .05
							},eaddInventors,{
							xtype : 'displayfield',
							
							columnWidth : .07
							},edelInventors]
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
						/*eYearField,
						ePatenteeFields,
						ePatentNumField,
						eAppDateFields	*/	
						eYearField,
						ePatenteeFields,
						ePatentNumField,
						eAppDateFields,
						eCertificateNoField,
					    eAnnDateFields											
					]
				 }]
		}
	]		
	// create form panel
  var editFormPanel = new Ext.form.FormPanel({
    labelWidth: 80,
	frame: true,
    items: colItems
	});
	
	editFormPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			//InventorsGrid.load();
		});

  // define window and show it in desktop
  var editWindow = new Ext.Window({
  	title: '�޸�ר���ɹ�������Ϣ',
    width: 600,
    height:355,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: editFormPanel,
    buttons: [{
    	text: '����', 
      handler: function() {
      	// check form value
      		var Name = eNameField.getValue();
			var dept = rowObj[0].get("DeptDr");
      		var DeptDr = eDeptFields.getValue();
			var invent = rowObj[0].get("Inventors");
			var total = InventorsGrid.getStore().getCount();
			if(total>0){
				rawValue = InventorsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<total;i++){
				  var row = InventorsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  rawValue = rawValue+","+row;
				};
			}
			var Inventors = rawValue;
			//alert(Inventors+"   "+invent+"   "+rawValue);
      		var CertificateNo = eCertificateNoField.getValue();
			//var AnnDate = eAnnDateFields.getValue().format("Y-m-d");
			var year = rowObj[0].get("YearDr");
      		var YearDr = eYearField.getValue();
			var patent = rowObj[0].get("Patentee");
			var Patentee = ePatenteeFields.getValue();
			var PatentNum = ePatentNumField.getValue();
      		//var AppDate = eAppDateFields.getValue().format("Y-m-d");
        	
			Name = Name.trim();
      		DeptDr =DeptDr.trim();
			YearDr =YearDr.trim();
			Patentee =Patentee.trim();
      		CertificateNo = CertificateNo.trim();
      		
			PatentNum = PatentNum.trim();
      		
      		
      		if(Name=="")
      		{
      			Ext.Msg.show({title:'����',msg:'ר������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(DeptDr=="")
      		{
      			Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(Inventors=="")
      		{
      			Ext.Msg.show({title:'����',msg:'ר��������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(CertificateNo=="")
      		{
      			Ext.Msg.show({title:'����',msg:'֤���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(AnnDate=="")
      		{
      			Ext.Msg.show({title:'����',msg:'��Ȩ��������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(YearDr=="")
      		{
      			Ext.Msg.show({title:'����',msg:'���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(Patentee=="")
      		{
      			Ext.Msg.show({title:'����',msg:'ר��Ȩ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(PatentNum=="")
      		{
      			Ext.Msg.show({title:'����',msg:'ר����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(AppDate=="")
      		{
      			Ext.Msg.show({title:'����',msg:'��������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		 if(DeptDr==dept){DeptDr=""};
			 if(Inventors==invent){Inventors=""};
			 if(YearDr==year){YearDr=""};	
			 if(Patentee==patent){Patentee=""};	
        	if (editFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url:  'herp.srm.srmpatentrewardauditexe.csp?action=edit&rowid='+myRowid+'&Name='+encodeURIComponent(Name)+'&DeptDr='+encodeURIComponent(DeptDr)+'&Inventors='+Inventors+'&CertificateNo='+CertificateNo+'&AnnDate='+AnnDate+'&YearDr='+YearDr+'&Patentee='+Patentee+'&PatentNum='+PatentNum+'&AppDate='+AppDate,
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
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info!=0) message='��Ϣ�޸�����!';
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
			text: 'ȡ��',
        handler: function(){editWindow.close();}
      }]
    });
    editWindow.show();
};
