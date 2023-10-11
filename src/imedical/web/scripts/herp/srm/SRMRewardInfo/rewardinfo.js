//var userdr = session['LOGON.USERID'];    
//var userCode = session['LOGON.USERCODE'];
var UserCode = session['LOGON.USERCODE'];
var projUrl = 'herp.srm.rewardinfoexe.csp';
//-------------------------------------------------------
//��ѯ��������������
var deptDs = new Ext.data.Store({
	      autoLoad:true,
	      proxy : "",
	      reader : new Ext.data.JsonReader({
	                 totalProperty : 'results',
	                 root : 'rows'
	              }, ['rowid','name'])
     });

deptDs.on('beforeload', function(ds, o){
	     ds.proxy=new Ext.data.HttpProxy({
	               url: 'herp.srm.srmdeptuserexe.csp'
	                     +'?action=caldept&str='
	                     +encodeURIComponent(Ext.getCmp('deptField').getRawValue()),
	                     method:'POST'
		   		});
     });

var deptField = new Ext.form.ComboBox({
			id: 'deptField',
			fieldLabel: '��������',
			width:160,
			listWidth : 260,
			allowBlank: true,
			store: deptDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			emptyText : '��ѡ���������...',
			name: 'deptField',
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
	    	editable:true
});
//---------------------------------------------

var ThesisTitleField = new Ext.form.TextField({
			columnWidth : .1,
			width : 100,
			//columnWidth : .12,
			allowBlank: true,
			selectOnFocus : true

		});
var JournalNameField = new Ext.form.TextField({
			columnWidth : .1,
			width : 100,
			//columnWidth : .12,
			allowBlank: true,
			selectOnFocus : true

		});
//----------------------------------------------------------
//��ѯ����:��һ����
var userDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
			           totalProperty:'results',
			           root:'rows'
			       },['rowid','name'])
	     });
     
 userDs.on('beforeload', function(ds, o){
		   ds.proxy = new Ext.data.HttpProxy({
		   url: 'herp.srm.srmdeptuserexe.csp'
		         +'?action=caluser&str='
		         +encodeURIComponent(Ext.getCmp('deptField').getRawValue()),
		         method:'POST'
		   });
		         //+ Ext.getCmp('userField').getRawValue(),method:'GET'});
     });

var userField = new Ext.form.ComboBox({
			id: 'FristAuthor',
			fieldLabel: '��Ա����',
			width:100,
			listWidth :260,
			allowBlank: true,
			store: userDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			emptyText:'��ѡ������...',
			name: 'FristAuthor',
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true
});


///////////////// ��ѯ��ť 
function rewardinfoDs(){
	   
	    var RPDeptDr = deptField.getValue();
	    var RPTitle = ThesisTitleField.getValue(); 
	   // alert(RPTitle);
	    var RPJournalName = JournalNameField.getValue();
	   // alert(RPJournalName);
	    var RPFristAuthor = userField.getValue();
		itemGrid.load({
		    params:{
		    start:0,
		    limit:15,
		    RPDeptDr:RPDeptDr,
		    RPTitle:RPTitle,
		    RPJournalName:RPJournalName,
		    RPFristAuthor:RPFristAuthor
	  }
  })
}
 
var queryPanel = new Ext.FormPanel({
			height:150,
			region:'north',
			frame:true,
			defaults: {bodyStyle:'padding:5px'},
				items:[{
				xtype: 'panel',
				layout:"column",
				items: [
					{   
						xtype:'displayfield',
						value:'<center><p style="font-weight:bold;font-size:150%">���Ľ���</p></center>',
						columnWidth:1,
						height:'50'
					}]
			    },{
			    columnWidth:1,
			    xtype: 'panel',
				layout:"column",
				items: [
					{
						xtype:'displayfield',
						value:'����:',
						columnWidth:.04
					},
					deptField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.02
					},{
						xtype:'displayfield',
						value:'������Ŀ:',
						columnWidth:.06
					},
					ThesisTitleField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.02
					},{
						xtype:'displayfield',
						value:'�ڿ�����:',
						columnWidth:.06
					},
					JournalNameField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.02
					},{
						xtype:'displayfield',
						value:'��һ����:',
						columnWidth:.06
					},
					userField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.02
					},{
						columnWidth:.1,
						xtype:'button',
						text: '��ѯ',
						handler:function(b){
							rewardinfoDs();
						},
						iconCls: 'add'
					}	
		     	]
			    
			}]
});	

var itemGrid = new dhc.herp.Grid({
		    //title: '������������',
		    region : 'center',
		     
		    url: projUrl,
		    atLoad : true, // �Ƿ��Զ�ˢ��
			fields : [ 
			//new Ext.grid.RowNumberer(),
			new Ext.grid.CheckboxSelectionModel({editable:false}),
			      
			      {
					    id:'ID',
				    	//header: 'ID',
				        dataIndex: 'ID',
				        align: 'center',
				        width: 30,
				        editable:false,		  
				        hidden: true,
				        sortable: true
				    },{
					    id:'RPID',
				    	header: 'ID',
				        dataIndex: 'RPID',
				        align: 'center',
				        width: 30,
				        editable:false,		  
				        hidden: true,
				        sortable: true
				    },{
					    id:'RPRecordType',
				    	header: '��������',
				        dataIndex: 'RPRecordType',
				        align: 'center',
				        width: 100,	
				        editable:false,
				        sortable: true
				    },{
					    id:'RPDept',
				    	header: '����',
				        dataIndex: 'RPDept',
				        align: 'center',
				        width: 100,	
				        editable:false,
				        sortable: true
				    },{
					    id:'RPTitle',
				    	header: '������Ŀ',
				        dataIndex: 'RPTitle',
				        align: 'center',
				        width: 100,	
				        editable:false,	
				        sortable: true
				    },{
					    id:'RPJournalName',
				    	header: '�ڿ�����',
				        dataIndex: 'RPJournalName',
				        align: 'center',
				        editable:false,
				        width: 100,		  
				        sortable: true
				    },{ 
				        id:'RPCountryType',
				    	header: '�ڿ�����',
				        dataIndex: 'RPCountryType',
				        width: 80,
				        editable:false,  
				        sortable: true
				    },{ 
				        id:'RPFristAuthor',
				    	header: '��һ����',
				        dataIndex: 'RPFristAuthor',
				        align: 'center',
				        width: 90,	
				        editable:false,	  
				        sortable: true
				    },{ 
				        id:'RPCorrAuthor',
				    	header: 'ͨѶ����',
				        dataIndex: 'RPCorrAuthor',
				        align: 'center',
				        editable:false,
				        width: 90,
				        //hidden:true,		  
				        sortable: true
				    },{ 
				        id:'RPPubYear',
				    	header: '��',
				        dataIndex: 'RPPubYear',
				        align: 'center',
				        width: 50,
				        editable:false,		  
				        sortable: true
				    },{ 
				        id:'RPRoll',
				    	header: '��',
				        dataIndex: 'RPRoll',
				        align: 'center',
				        width: 50	,  
				        hidden:true,
				        editable:false,
				        sortable: true
				    },{ 
				        id:'RPPeriod',
				    	header: '��',
				        dataIndex: 'RPPeriod',
				        align: 'center',
				        width: 50,	
				        editable:false,	  
				        sortable: true
				    },{           
				         id:'RPStartPage',
				         header: '��ʼҳ',
				         width:50,
				         dataIndex: 'RPStartPage',	
				         editable:false,		  
				         sortable: true
				    },{           
				         id:'RPEndPage',
				         header: '��ֹҳ',
				         width:50,
				         dataIndex: 'RPEndPage',
				        align: 'center',	
				        editable:false,		  
				         sortable: true
				    },{           
				         id:'RPSN',
				         header: 'SN',
				         width:80,
				         dataIndex: 'RPSN',
				        align: 'center',
				        editable:false,			  
				        sortable: true
				    },{           
				         id:'RPWOS',
				         header:'��غ�',
				         width:80,
				         dataIndex: 'RPWOS',
				        align: 'center',
				        editable:false,			  
				        sortable: true
				    },{           
				         id:'RPIF',
				         header:'IF',
				         width:50,
				         dataIndex: 'RPIF',	
				        align: 'center',
				        editable:false,		  
				        sortable: true
				    },{           
				         id:'RPDocuType',
				         header:'��������',
				         width:80,
				         dataIndex: 'RPDocuType',
				          editable:false,		  
				        sortable: true
				    },{
					    id:'rowid',
				    	header: 'id',
				        dataIndex: 'rowid',
				        align: 'center',
				        width: 30,
				         editable:false,		  
				        hidden: true,
				        sortable: true
				    },{
					    id:'RegPaperDr',
				    	header: '���ĵǼǱ�Dr',
				        dataIndex: 'RegPaperDr',
				        align: 'center',
				        editable:false,
				         hidden: true,
				        width: 50,	
				        sortable: true
				    },{           
				         id:'RewardAmount',
				         header:'�������',
				         width:80,
				         dataIndex: 'RewardAmount',	
				         align: 'center',
				         allowblank:true,
				         editable:true,	
				         renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['AuditStatus']
						if (sf == "�����") {
							return '<span style="color:red;cursor:hand;">'+value+'</span>';
						} else {
							return '<span style="color:black;cursor:hand">'+value+'</span>';
						}},	 
				         sortable: true
				         
				    },{           
				         id:'AuditStatus',
				         header:'����״̬',
				         width:60,
				         dataIndex: 'AuditStatus',
				         renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['AuditStatus']
						if (sf == "�����") {
							return '<span style="color:red;cursor:hand;">'+value+'</span>';
						} else {
							return '<span style="color:black;cursor:hand">'+value+'</span>';
						}},

				        align: 'center',
				        editable:false,		  
				        sortable: true
				    },{           
				         id:'Auditor',
				         header:'�����',
				         width:80,
				         dataIndex: 'Auditor',	
				        align: 'center',
				        allowblank:true,
				        editable:false,	  
				        sortable: true
				    },{           
				         id:'AuditDate',
				         header:'���ʱ��',
				         width:120,
				         dataIndex: 'AuditDate',	
				        align: 'center',
				        allowblank:true,
				        editable:false,	  
				        sortable: true
				    }]		
		});
//alert(RewardAmount);
var AuditButton  = new Ext.Toolbar.Button({
		text: '���',  
        id:'auditButton', 
        iconCls:'option',
        handler:function(){
		//���岢��ʼ���ж���
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		
		//var checker = session['LOGON.USERID'];
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		/*
        for(var j= 0; j < len; j++){
		 if(rowObj[j].get("AuditStatus")=="�����")
		 {
			      Ext.Msg.show({title:'ע��',msg:'���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }else if(rowObj[j].get("RewardAmount")==""){
			       Ext.Msg.show({title:'ע��',msg:'���Ϊ��,�������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
			 
			 }
		} */
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    Ext.Ajax.request({
						url:'herp.srm.rewardinfoexe.csp?action=edit&&RPID='+rowObj[i].get("RPID")+'&RewardAmount='+rowObj[i].get("RewardAmount")+'&UserCode='+UserCode+'&ID='+rowObj[i].get("ID"),
						waitMsg:'�����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'��˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:15}});
								
							}else{
								Ext.Msg.show({title:'��ʾ',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ��˸�����¼��?',handler);
    }
});

  itemGrid.addButton('-');
  itemGrid.addButton(AuditButton);
  //itemGrid.addButton('-');
  //itemGrid.addButton(NoAuditButton);
  itemGrid.btnResetHide(); 	//�������ð�ť
  itemGrid.btnDeleteHide(); //����ɾ����ť
  itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
  itemGrid.btnAddHide(); 	//�������ð�ť
  itemGrid.btnSaveHide(); 	//�������ð�ť
  itemGrid.addListener("beforeedit" ,function(cell){
	                var _record=cell.record;
					var sf=_record.get("AuditStatus");			
					if (sf=="�����"){return false;}
					else {return true;}  
  });
 
  //itemGrid.load({params:{start:0, limit:12, userdr:userdr}});
  //itemGrid.load({params:{start:0, limit:15}});

