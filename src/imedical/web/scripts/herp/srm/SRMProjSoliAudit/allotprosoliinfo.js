//����רҵ����� ���������--xm ����һԺ����20170606��ֻ��Ҫ����ר������ˣ��������������칫�����
allotFun = function()
{	
var selectedRow = itemGrid.getSelectionModel().getSelections();
	if (selectedRow.length < 1) {
		Ext.Msg.show({
					title : 'ע��',
					msg : '�뵥��ѡ�����Ŀ��������!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return;
	}
	else
	{
	  var mainrowid=selectedRow[0].get("rowid");	
	  var isethic=selectedRow[0].get("IsEthic");	
	}
        
//////////////////////רҵ������//////////////////////
var expertuserDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

expertuserDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=expertList&str='+encodeURIComponent(Ext.getCmp('expertuserField').getRawValue()),method:'POST'});
});
//aunituserDs.load();

var expertuserField = new Ext.form.ComboBox({
	id: 'expertuserField',
	fieldLabel: 'רҵ������',
	width:200,
	listWidth : 260,
	allowBlank: true,
	store: expertuserDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ��רҵ����������...',
	name: 'expertuserField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});  

var ExpertGrid = new Ext.grid.GridPanel({
		id:'ExpertGrid',
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
            {id: 'rowid', header: 'רҵ������ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: 'רҵ�������б�', dataIndex: 'name',align:'center',width: 300}
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
			var id = Ext.getCmp('expertuserField').getValue();
			var ChkName = Ext.getCmp('expertuserField').getRawValue();

			var ptotal = ExpertGrid.getStore().getCount();
			if(ptotal>0){	
				for(var i=0;i<ptotal;i++){
					var erow = ExpertGrid.getStore().getAt(i).get('rowid');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'����',msg:'��ѡ����ͬһ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}
						else{
						    ChkUserId=id;
						}
					}else{
						Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵ�רҵ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				}
			}else{
				if(id==""){
					Ext.Msg.show({title:'��ʾ',msg:'��ѡ��Ҫ��ӵ�רҵ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				else{		
						ChkUserId=id;	
				}	
			}
			var data = new Ext.data.Record({'rowid':ChkUserId,'name':ChkName});
			ExpertGrid.stopEditing(); 
			ExpertGrid.getStore().insert(ptotal,data);
		}
	});	
var delParticipants = new Ext.Button({
		text:'ɾ��',
		iconCls: 'edit_remove',
		handler: function() {  
			var rows = ExpertGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				var rRowid = ExpertGrid.getStore().indexOf(rows[0]); //����кţ�������rowid
				ExpertGrid.getStore().removeAt(rRowid);//�Ƴ���ѡ�е�һ��
			}		
		}
	});

/*
//////////////////////����������//////////////////////
var ethicuserDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

ethicuserDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=ethicList&str='+encodeURIComponent(Ext.getCmp('ethicuserField').getRawValue()),method:'POST'});
});
//aunituserDs.load();

var ethicuserField = new Ext.form.ComboBox({
	id: 'ethicuserField',
	fieldLabel: '����������',
	width:200,
	listWidth : 260,
	allowBlank: true,
	store: ethicuserDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ����������������...',
	name: 'ethicuserField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});  

var EthicGrid = new Ext.grid.GridPanel({
		id:'EthicGrid',
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
            {id: 'rowid', header: '����������ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '�����������б�', dataIndex: 'name',align:'center',width: 300}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 300,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'���',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});

///////////////��Ӷ�����������˰�ť////////////////
var addethicParticipants  = new Ext.Button({
		id:'addethicParticipants',
		text: '���',
		
		handler: function(){
			var EthicChkUserId;
			var ethicid = Ext.getCmp('ethicuserField').getValue();
			var EthicChkName = Ext.getCmp('ethicuserField').getRawValue();

			var ethicptotal = EthicGrid.getStore().getCount();
			if(ethicptotal>0){	
				for(var i=0;i<ethicptotal;i++){
					var ethicerow = EthicGrid.getStore().getAt(i).get('rowid');
					if(ethicid!=""){
						if(ethicid==ethicerow){
							Ext.Msg.show({title:'����',msg:'��ѡ����ͬһ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}
						else{
						    EthicChkUserId=ethicid;
						}
					}else{
						Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵ�����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				}
			}else{
				if(ethicid==""){
					Ext.Msg.show({title:'��ʾ',msg:'��ѡ��Ҫ��ӵ�����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				else{		
						EthicChkUserId=ethicid;	
				}	
			}
			var data = new Ext.data.Record({'rowid':EthicChkUserId,'name':EthicChkName});
			EthicGrid.stopEditing(); 
			EthicGrid.getStore().insert(ethicptotal,data);
		}
	});	
var delethicParticipants = new Ext.Button({
		id:'delethicParticipants',
		text:'ɾ��',
		handler: function() {  
			var rows = EthicGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				var rRowid = EthicGrid.getStore().indexOf(rows[0]); //����кţ�������rowid
				EthicGrid.getStore().removeAt(rRowid);//�Ƴ���ѡ�е�һ��
			}		
		}
	});

*/	
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
					items: 
					[
						ExpertGrid,
						{
							xtype : 'displayfield',
							value : '',
							width : 10
						},
						expertuserField,
						
					    {
							columnWidth : 1,
						    xtype : 'panel',
						    layout : "column",
						    items : 
						    [
						    	{
									xtype : 'displayfield',
									value : '',
									width : 5
								},
							    addParticipants,
							    {
									xtype : 'displayfield',
									value : '',
									width : 20
								},
							    delParticipants
							]
						}
					]
				}
								]
							 }]
					

var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 95,
				//layout: 'form',
				frame: true,
				items: colItems
			});
/*
if ((isethic=="��")||(isethic==""))
{
	addethicParticipants.disable();
	delethicParticipants.disable();
	ethicuserField.disable();
}			
*/
		//��ʼ����Ӱ�ť
		add1Button = new Ext.Toolbar.Button({
			text:'����',
			iconCls: 'save'
		});
		
		var auser="";
		var ethicuser="";
		//������Ӱ�ť��Ӧ����
		add1Handler = function(){
			var chknamecount = ExpertGrid.getStore().getCount();
			  if(chknamecount>0){
				var id = ExpertGrid.getStore().getAt(0).get('rowid');
				auser = id;
				for(var i=1;i<chknamecount;i++){
				  var tmpid = ExpertGrid.getStore().getAt(i).get('rowid');
				  auser = auser+","+tmpid;
				   };
			   }
			  /* var ethicchknamecount = EthicGrid.getStore().getCount();
			  if(ethicchknamecount>0){
				var ethicid = EthicGrid.getStore().getAt(0).get('rowid');
				ethicuser = ethicid;
				for(var i=1;i<ethicchknamecount;i++){
				  var tmpethicid = EthicGrid.getStore().getAt(i).get('rowid');
				  ethicuser = ethicuser+","+tmpethicid;
				   };
			   } */
			   
			   var allotRowid = selectedRow[0].get("rowid");
		       var allotisethic = selectedRow[0].get("IsEthic");
		       var allotexpert = selectedRow[0].get("Expert");
		       var allotethicexpert = selectedRow[0].get("EthicExpert");
		       
			   //addethicParticipants.disable();
			   //if((chknamecount==0)&&(auser == ""))
				if(auser == "")
				{
					Ext.Msg.show({title:'��ʾ',msg:'�����רҵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;		
				}
			Ext.Ajax.request({
				url: projUrl+'?action=allot&rowid='+allotRowid+'&Expert='+encodeURIComponent(auser),
				waitMsg:'������...',
				failure: function(result, request){
					Handler = function(){aField.focus();};
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'ע��',msg:'�������!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						//addwin.close();
						itemGrid.load({params:{start:0,limit:25}});
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
			title: '����רҵ������',
			iconCls:'updateinfo',
			width: 400,
			height:300,
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
		/* 
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1)
	{
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		var allotRowid = rowObj[0].get("rowid");
		var allotisethic = rowObj[0].get("IsEthic");
		var allotexpert = rowObj[0].get("Expert");
		var allotethicexpert = rowObj[0].get("EthicExpert");
		if(allotisethic == "��")
		{
			if(allotexpert == "")
			{
				Ext.Msg.show({title:'��ʾ',msg:'����дרҵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;		
			}
		}
		else if(allotisethic == "��")
		{
			if((allotexpert == "") || (allotethicexpert == ""))
			{
				Ext.Msg.show({title:'��ʾ',msg:'����дרҵ����˺����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}		
		}
		
		Ext.Ajax.request
		({
			url:  projUrl+'?action=allot&rowid='+allotRowid+'&Expert='+encodeURIComponent(allotexpert)+'&EthicExpert='+encodeURIComponent(allotethicexpert),
			waitMsg:'������...',
			failure: function(result, request)
			{			
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request)
			{				
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true')
				{								
					Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					itemGrid.load({params:{start:0,limit:25}});
				}
				else
				{
					var message = "";
					message = jsonData.info;
					Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			},
			scope: this
		});	
	}	 */
};