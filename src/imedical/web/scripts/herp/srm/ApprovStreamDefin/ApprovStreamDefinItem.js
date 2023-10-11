var usernameDr = session['LOGON.USERID'];


//��Ӱ�ť
var AddButton = new Ext.Toolbar.Button({
	text: '����',
    //tooltip:'����',        
    iconCls: 'edit_add',
	handler:function(){
	
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	if (selectedRow.length < 1) {
		Ext.Msg.show({
					title : 'ע��',
					msg : '�뵥��ѡ���Ӧ��������!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return;
	}
	else
	{
	  var mainrowid=selectedRow[0].get("rowid");	
	}
        
		/////////////////////��������////////////////////////////
var aunitDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

aunitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.approvstreamdefindetailexe.csp'+'?action=caldept&usernameDr='+usernameDr+'&str='+encodeURIComponent(Ext.getCmp('aunitField').getRawValue()),method:'POST'});
});

var aunitField = new Ext.form.ComboBox({
	id: 'aunitField',
	fieldLabel: '�����˿���',
	width:200,
	listWidth : 260,
	allowBlank: true,
	store: aunitDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ��������...',
	name: 'aunitField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//////////////////////������//////////////////////
var aunituserDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

aunituserDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.approvstreamdefindetailexe.csp'+'?action=caluser&str='+encodeURIComponent(Ext.getCmp('aunituserField').getRawValue()),method:'POST'});
});
//aunituserDs.load();

var aunituserField = new Ext.form.ComboBox({
	id: 'aunituserField',
	fieldLabel: '������',
	width:200,
	listWidth : 260,
	allowBlank: true,
	store: aunituserDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ�������������...',
	name: 'aunituserField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});  


/* var aunituserField = new Ext.form.MultiSelect({
    id:'aunituserField',
	fieldLabel: '������',
    width:200,
	listWidth : 260,
	allowBlank : false, 
	store: aunituserDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'ѡ��...',
	name:'aunituserField',
	mode:'romote',
	minChars: 1,
	pageSize: 100,
	anchor: '95%',
	selectOnFocus:true,
	//forceSelection:'true',
	editable:true
}); */

var aChkUserGrid = new Ext.grid.GridPanel({
		id:'aChkUserGrid',
    store: new Ext.data.Store({
    //autoLoad:true,
		proxy: new Ext.data.MemoryProxy(),
		reader: new Ext.data.ArrayReader({}, [  
			 {name: 'rowid'},  
			 {name: 'name'}
         ])  
    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 129,
            sortable: true
        },
        columns: [
            {id: 'rowid', header: '������ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '�������б�', dataIndex: 'name',align:'center',width: 300}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 300,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'���',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});

///////////////��Ӷ�������˰�ť////////////////
var addParticipants  = new Ext.Button({
		text: '����',
		iconCls: 'edit_add',
		handler: function(){
			var ChkUserId;
			var id = Ext.getCmp('aunituserField').getValue();
			var ChkName = Ext.getCmp('aunituserField').getRawValue();

			var ptotal = aChkUserGrid.getStore().getCount();
			if(ptotal>0){	
				for(var i=0;i<ptotal;i++){
					var erow = aChkUserGrid.getStore().getAt(i).get('rowid');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'����',msg:'��ѡ����ͬһ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}
						else{
						    ChkUserId=id;
						}
					}else{
						Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵ�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				}
			}else{
				if(id==""){
					Ext.Msg.show({title:'��ʾ',msg:'��ѡ��Ҫ��ӵ�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				else{		
						ChkUserId=id;	
				}	
			}
			var data = new Ext.data.Record({'rowid':ChkUserId,'name':ChkName});
			aChkUserGrid.stopEditing(); 
			aChkUserGrid.getStore().insert(ptotal,data);
		}
	});	
var delParticipants = new Ext.Button({
		text:'ɾ��',
		iconCls: 'edit_remove',
		handler: function() {  
			var rows = aChkUserGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				var rRowid = aChkUserGrid.getStore().indexOf(rows[0]); //����кţ�������rowid
				aChkUserGrid.getStore().removeAt(rRowid);//�Ƴ���ѡ�е�һ��
			}		
		}
	});

/////////////////////�Ƿ������/////////////////////////////
var aIsdriectField = new Ext.form.Checkbox({
                        id:'aIsdriectField',
						name:'aIsdriectField',
						fieldLabel : '�Ƿ������'
					});
/////////////////////�Ƿ�����/////////////////////////////					
var aIsSecretaryField = new Ext.form.Checkbox({
    id:'aIsSecretaryField',
	name:'aIsSecretaryField',
	fieldLabel : '�Ƿ������'
});
//////////////////////������������//////////////////////
var aDescField = new Ext.form.TextField({
    id:'aDescField',
	name:'aDescField',
	fieldLabel:'������������',
	width : 200,
	allowBlank : false,
	selectOnFocus : true,
	labelSeparator:''
});
     	
	var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '1',
							bodyStyle:'padding:5px 5px 0',
							border: false
						},            
						items: [
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
							 aDescField,
							 aChkUserGrid,
							  
					         aunituserField,
					        
					        {
						         columnWidth : 1,
						         xtype : 'panel',
						         layout : "column",
						         items : [{
							       xtype : 'displayfield',
							       columnWidth : .05
							    },addParticipants,
							    {
							       xtype : 'displayfield',
							       columnWidth : .07
							    },delParticipants]
						      }
							  /* , 
							  //aunitField,
							 {
						         columnWidth : 1,
						         xtype : 'panel',
						         layout : "column",
						         items : [{
							       xtype : 'displayfield',
								   value:'�Ƿ������',
							       columnWidth : .25
							    },aIsdriectField,
							    {
							       xtype : 'displayfield',
							       columnWidth : .07
							    },{
							       xtype : 'displayfield',
								   value:'�Ƿ������',
							       columnWidth : .25
							    },aIsSecretaryField]
						      } */
								]
							 }]
					}
				]	

var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 90,
				labelAlign: 'right',
				//layout: 'form',
				frame: true,
				items: colItems
			});
			
		//��ʼ����Ӱ�ť
		add1Button = new Ext.Toolbar.Button({
			text:'����',
			iconCls: 'save'
		});
		
		var auser="";
		//������Ӱ�ť��Ӧ����
		add1Handler = function(){
            //alert("wwww")
			var adesc = aDescField.getValue();
			//var auint = aunitField.getValue();
            var auint="";
			var chknamecount = aChkUserGrid.getStore().getCount();
			  if(chknamecount>0){
				var id = aChkUserGrid.getStore().getAt(0).get('rowid');
				auser = id;
				for(var i=1;i<chknamecount;i++){
				  var tmpid = aChkUserGrid.getStore().getAt(i).get('rowid');
				  auser = auser+","+tmpid;
				   };
			   }

            var aisdirect = "";
			if (Ext.getCmp('aIsdriectField').checked) {aisdirect="Y";}
			else { aisdirect="N";}
			var aissecretary = "";
			if (Ext.getCmp('aIsSecretaryField').checked) {aissecretary="Y";}
			else{aissecretary="N";}
	        //alert(adesc+"^"+auint+"^"+auser+"^"+aisdirect+"^"+aissecretary);
			//encodeURI
			Ext.Ajax.request({
				url: encodeURI('../csp/herp.srm.approvstreamdefindetailexe.csp?action=add&checkmainid='+mainrowid+'&procdesc='+adesc+'&chkname='+auser+'&deptname='+auint+'&isdirect='+aisdirect+'&IsSecretary='+aissecretary),
				waitMsg:'������...',
				failure: function(result, request){
					Handler = function(){aField.focus();};
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'ע��',msg:'���ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						detailGrid.load({params:{start:0, limit:20,checkmainid:mainrowid}});
						//addwin.close();
					}
					else
							{
								var message="";
                                message=jsonData.info
								Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
				},
				scope: this
			});
			addwin.close();
		};
	
		//��ӱ��水ť�ļ����¼�
		add1Button.addListener('click',add1Handler,false);
	
		//��ʼ��ȡ����ť
		cancelButton = new Ext.Toolbar.Button({
		text:'�ر�',
			iconCls : 'cancel'
		});
	
		//����ȡ����ť����Ӧ����
		cancelHandler = function(){
			addwin.close();
		};
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//��ʼ������
		addwin = new Ext.Window({
			title: '������������ϸ��Ϣ',
			iconCls: 'edit_add',
			width: 380,
			height:320,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				add1Button,
				cancelButton
			]
		});
	
		//������ʾ
		addwin.show();
	}	
});



//�޸İ�ť
var EditButton = new Ext.Toolbar.Button({
	text: '�޸�',
    //tooltip:'�޸�',        
    iconCls: 'pencil',
	handler:function(){
		//���岢��ʼ���ж���
		var rowObj=detailGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
			var bfchknamedr = rowObj[0].get("chknamedr");
			var bfdeptnamedr = rowObj[0].get("deptnamedr");
		}
	
	
/////////////////////��������////////////////////////////
var eunitDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

eunitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.approvstreamdefindetailexe.csp'+'?action=caldept&usernameDr='+usernameDr+'&str='+encodeURIComponent(Ext.getCmp('eunitField').getRawValue()),method:'POST'});
});

var eunitField = new Ext.form.ComboBox({
	id: 'eunitField',
	fieldLabel: '�����˿���',
	width:200,
	listWidth : 260,
	allowBlank: true,
	store: eunitDs,
	value:bfdeptnamedr,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ��������...',
	name: 'eunitField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//////////////////////������//////////////////////
var eunituserDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

eunituserDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.approvstreamdefindetailexe.csp'+'?action=caluser&str='+encodeURIComponent(Ext.getCmp('eunituserField').getRawValue()),method:'POST'});
});

var eunituserField = new Ext.form.ComboBox({
	id: 'eunituserField',
	fieldLabel: '������',
	width:200,
	listWidth : 260,
	allowBlank: true,
	store: eunituserDs,
	//value:bfchknamedr,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ�������������...',
	name: 'eunituserField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});

/**
var eunituserField = new Ext.form.MultiSelect({
    id :'eunituserField',
	fieldLabel: '������',
    width:200,
	listWidth : 260,
	allowBlank : false, 
	store: eunituserDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	////emptyText:'ѡ��...',
	name: 'eunituserField',
	mode:'romote',
	//minChars: 1,
	pageSize: 100,
	anchor: '95%',
	//selectOnFocus:true,
	//forceSelection:'true',
	//editable:true
});
**/


var eChkUserGrid = new Ext.grid.GridPanel({
		id:'eChkUserGrid',
     store: new Ext.data.Store({
        autoLoad:true,
		proxy: new Ext.data.HttpProxy({
		url:'herp.srm.approvstreamdefindetailexe.csp'+'?action=GetChkUserInfo&start='+0+'&limit='+25+'&IDs='+bfchknamedr,
		method:'POST'}),
	  reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])

    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 129,
            sortable: true
        },
        columns: [
            {id: 'rowid', header: '������ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '����������', dataIndex: 'name',align:'center',width: 300}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 300,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'���',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});

///////////////��Ӷ�������˰�ť////////////////
var addeParticipants  = new Ext.Button({
		text: '����',
		iconCls: 'edit_add',
		handler: function(){
			var ChkUserId;
			var id = Ext.getCmp('eunituserField').getValue();
			var ChkName = Ext.getCmp('eunituserField').getRawValue();

			var ptotal = eChkUserGrid.getStore().getCount();
			if(ptotal>0){	
				for(var i=0;i<ptotal;i++){
					var erow = eChkUserGrid.getStore().getAt(i).get('rowid');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'����',msg:'��ѡ����ͬһ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}
						else{
						    ChkUserId=id;
						}
					}else{
						Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵ�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				}
			}else{
				if(id==""){
					Ext.Msg.show({title:'��ʾ',msg:'��ѡ��Ҫ��ӵ�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				else{		
						ChkUserId=id;	
				}	
			}
			var data = new Ext.data.Record({'rowid':ChkUserId,'name':ChkName});
			eChkUserGrid.stopEditing(); 
			eChkUserGrid.getStore().insert(ptotal,data);
		}
	});	
var deleParticipants = new Ext.Button({
		text:'ɾ��',
		iconCls: 'edit_remove',
		handler: function() {  
			var rows = eChkUserGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				var rRowid = eChkUserGrid.getStore().indexOf(rows[0]); //����кţ�������rowid
				eChkUserGrid.getStore().removeAt(rRowid);//�Ƴ���ѡ�е�һ��
			}		
		}
	});

/////////////////////�Ƿ������/////////////////////////////
var eIsdriectField = new Ext.form.Checkbox({
                        id:'eIsdriectField',
						name:'eIsdriectField',
						fieldLabel : '�Ƿ������',
						renderer : function(v, p, record){
        	               p.css += ' x-grid3-check-col-td'; 
        	               return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
					});
/////////////////////�Ƿ�����/////////////////////////////					
var eIsSecretaryField = new Ext.form.Checkbox({
    id:'eIsSecretaryField',
	name:'eIsSecretaryField',
	fieldLabel : '�Ƿ������',
	renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
});
//////////////////////������������//////////////////////
var eDescField = new Ext.form.TextField({
    id:'eDescField',
	name:'eDescField',
	fieldLabel:'������������',
	width : 200,
	allowBlank : false,
	selectOnFocus : true,
	labelSeparator:''
});
		var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '1',
							bodyStyle:'padding:5px 5px 0',
							border: false
						},            
						items: [
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
								   
							 eDescField,
							 eChkUserGrid,
					         eunituserField,
					        {
						         columnWidth : 1,
						         xtype : 'panel',
						         layout : "column",
						         items : [{
							       xtype : 'displayfield',
							       columnWidth : .05
							    },addeParticipants,
							    {
							       xtype : 'displayfield',
							       columnWidth : .07
							    },deleParticipants]
						      }
							 /*  , 
							  //eunitField,
							 {
						         columnWidth : 1,
						         xtype : 'panel',
						         layout : "column",
						         items : [{
							       xtype : 'displayfield',
								   value:'�Ƿ������',
							       columnWidth : .25
							    },eIsdriectField,
							    {
							       xtype : 'displayfield',
							       columnWidth : .07
							    },{
							       xtype : 'displayfield',
								   value:'�Ƿ������',
							       columnWidth : .25
							    },eIsSecretaryField]
						      } */
								]
							 }]
					}
				]	

var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 90,
				labelAlign: 'right',
				//layout: 'form',
				frame: true,
				items: colItems
			});
		//���岢��ʼ�����
		/* var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
				eDescField,
				eChkUserGrid,
				eunituserField,
				{
				 columnWidth : 1,
				 xtype : 'panel',
				 layout : "column",
				 items : [{
				 xtype : 'displayfield',
				 columnWidth : .05
				 },addeParticipants,
				{
				xtype : 'displayfield',
				columnWidth : .07
				},deleParticipants]
			    },
				eunitField,
				eIsdriectField,
				eIsSecretaryField
			]
		}); */
	
		//������
		formPanel.on('afterlayout', function(panel, layout){
			this.getForm().loadRecord(rowObj[0]);
			eDescField.setValue(rowObj[0].get("procdesc"));
			//eunitField.setRawValue(rowObj[0].get("deptname"));
			//eunituserField.setRawValue(rowObj[0].get("chkname"));

            if(rowObj[0].get("isdirect")=="Y"){eIsdriectField.setValue(true);}		
			if(rowObj[0].get("IsSecretary")=="Y"){eIsSecretaryField.setValue(true);}	

			
		});

var euser="";
//���岢��ʼ�������޸İ�ť
   var editButton = new Ext.Toolbar.Button({
			text:'����',
			iconCls : 'save'

		});
	
		//�����޸İ�ť��Ӧ����
		editHandler = function(){

            var rowObj=itemGrid.getSelectionModel().getSelections();
            var mainrowid = rowObj[0].get("rowid");    
			
			var edesc = eDescField.getValue();
			//var euint = eunitField.getValue();	
			var euint="";
			var chknamecount = eChkUserGrid.getStore().getCount();
			  if(chknamecount>0){
				var id = eChkUserGrid.getStore().getAt(0).get('rowid');
				euser = id;
				for(var i=1;i<chknamecount;i++){
				  var tmpid = eChkUserGrid.getStore().getAt(i).get('rowid');
				  euser = euser+","+tmpid;
				   };
			   }
			
            var eisdirect = "";
			if (Ext.getCmp('eIsdriectField').checked) {eisdirect="Y";}
			else { eisdirect="N";}
			var eissecretary = "";
			if (Ext.getCmp('eIsSecretaryField').checked) {eissecretary="Y";}
			else { eissecretary="N";}
			
			Ext.Ajax.request({
				url: encodeURI('../csp/herp.srm.approvstreamdefindetailexe.csp?action=edit&rowid='+rowid+'&checkmainid='+mainrowid+'&procdesc='+edesc+'&chkname='+euser+'&deptname='+euint+'&isdirect='+eisdirect+'&IsSecretary='+eissecretary),
				waitMsg:'������...',
				failure: function(result, request){
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});			
				},
				
				success: function(result, request){
				   	var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						detailGrid.load({params:{start:0, limit:20,checkmainid:mainrowid}});	
					}
					else
						{
							var message="";
                            message=jsonData.info
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
				},
				scope: this
			});
			editwin.close();
		};
	
		//��ӱ����޸İ�ť�ļ����¼�
		editButton.addListener('click',editHandler,false);
	
		//���岢��ʼ��ȡ���޸İ�ť
		var cancelButton = new Ext.Toolbar.Button({
			text:'�ر�',
			iconCls : 'cancel'
		});
	
		//����ȡ���޸İ�ť����Ӧ����
		cancelHandler = function(){
			editwin.close();
		};
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//���岢��ʼ������
		var editwin = new Ext.Window({
			title: '�޸���������ϸ��Ϣ',
			iconCls: 'pencil',
			width:380,
			height:320,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				editButton,
				cancelButton
			]
		});
	
		//������ʾ
		editwin.show();
	}
});


///ɾ����ť
var DelButton = new Ext.Toolbar.Button({
	text: 'ɾ��',
   // tooltip:'ɾ��',       
    id:'delButton', 
    iconCls:'edit_remove',
	handler:function(){
		//���岢��ʼ���ж���
		var rowObj=detailGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
		function handler(id){
			if(id=="yes"){
			       var mainrowObj=itemGrid.getSelectionModel().getSelections();
                   var mainrowid = mainrowObj[0].get("rowid");   
			
				  Ext.each(rowObj, function(record) {
				  if (Ext.isEmpty(record.get("rowid"))) {
				  detailGrid.getStore().remove(record);
				  return;}
					Ext.Ajax.request({
						url:'herp.srm.approvstreamdefindetailexe.csp?action=del&rowid='+rowid+'&checkmainid='+mainrowid,
						waitMsg:'ɾ����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								detailGrid.load({params:{start:0, limit:20,checkmainid:mainrowid}});
							}else{
							    var message=jsonData.info;
							    if(jsonData.info=='HaveDate') message='��ϸ������Ϣ������ֱ��ɾ�����ڵ�!';
								Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				});
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪɾ��������¼��?',handler);
	}
});

var detailGrid = new dhc.herp.Gridhm({
        title:'��������ϸ',
        iconCls: 'popup_list',
        region: 'east',
        //layout:'fit',
        width:700,
		tbar:[AddButton,EditButton,DelButton],
        url: 'herp.srm.approvstreamdefindetailexe.csp',
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			editable:false,
            hidden: true
        },{
            id:'checkmainid',
            header: '����������ID',
			editable:false,
			hidden:true,
            dataIndex: 'checkmainid'
        },{
            id:'stepno',
            header: '����˳���',
			//allowBlank: false,
			editable:false,
			width:80,
            dataIndex: 'stepno'
        },{
           id:'procdesc',
            header: '������������',
			allowBlank: false,
			width:150,
			editable:false,
            dataIndex: 'procdesc'
        },{
            id:'chkname',
            header: '������',
			editable:false,
			//allowBlank: false,
			width:280,
            dataIndex: 'chkname'
            //type: unituserField
        },{
            id:'deptname',
            header: '�����˿���',
			hidden:true,
			//allowBlank: false,
			width:100,
            dataIndex: 'deptname'
            //type:unitField
        },{
            id:'isdirect',
            header: '�Ƿ��ǿ�����',
			width:80,
            dataIndex: 'isdirect',
			hidden:true,
            //sortable: true,          
            //type : IsdriectField
            renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
        },{
            id:'IsSecretary',
            header: '�Ƿ��ǿ�����',
			//allowBlank: false,
			width:80,
            dataIndex: 'IsSecretary',
			hidden:true,
            //type:driectField,
            //type : IsSecretaryField,
            renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
        },{
            id:'chknamedr',
            header: '������dr',
			//allowBlank: false,
			width:100,
            dataIndex: 'chknamedr',
            hidden:true
        },{
            id:'deptnamedr',
            header: '�����˿���dr',
			//allowBlank: false,
			width:100,
            dataIndex: 'deptnamedr',
            hidden:true
        }]
   });
	
	// detailGrid.hiddenButton(0);  
	// detailGrid.hiddenButton(1);
	// detailGrid.hiddenButton(2); 
	

    /* detailGrid.btnDeleteHide(); //����ɾ����ť
    detailGrid.btnAddHide(); 	//�������ð�ť
    detailGrid.btnSaveHide(); 	//�������ð�ť */


