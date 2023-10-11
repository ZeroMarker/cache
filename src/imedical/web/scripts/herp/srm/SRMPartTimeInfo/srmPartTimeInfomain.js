///////////////////////////////////////////////////

var tmpData="";

var itemGridUrl = '../csp/herp.srm.srmPartTimeInfoexe.csp';

var usercode = session['LOGON.USERCODE'];





var groupdesc = session['LOGON.GROUPDESC'];
if (groupdesc=="���й���ϵͳ(��Ϣ�޸�)")
{ var usercode=""
	}


//�������Դ
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list&usercode='+usercode});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'rowid',
			'Type',
			'UserName',
			'DeptName',
			'CommitteeName',
			'PositionName',
			'Year',
			'StartDate',
			'EndDate',
			'SubUserName',
			'SubDate',
			'DataStatus',
			'Branch',
			'Auditor',
			'AuditDate',
			'ResAudit',
			'ResDesc'
		]),
	    remoteSort: true
});


var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 15,
		store: itemGridDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������"//,

});
//����Ĭ�������ֶκ�������
itemGridDs.setDefaultSort('rowid', 'name');

//��ѯ��������
var uCodeField = new Ext.form.TextField({
	id: 'uCodeField',
	fieldLabel: '�û�����',
	width:100,
	listWidth : 220,
	triggerAction: 'all',
	emptyText:'',
	name: 'uCodeField',
	minChars: 1,
	pageSize: 10,
	editable:true
});
var uNameField = new Ext.form.TextField({
	id: 'uNameField',
	fieldLabel: '�û�����',
	width:120,
	listWidth : 220,
	triggerAction: 'all',
	emptyText:'',
	name: 'uNameField',
	minChars: 1,
	pageSize: 10,
	editable:true
});

///��֯����
var CommitteeInfoDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
CommitteeInfoDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : itemGridUrl+'?action=CalCommitteeInfo', 
                        method:'POST'
					});
		});

var CommitteeInfoCombo = new Ext.form.ComboBox({
	id: 'CommitteeInfoCombo',
			fieldLabel : '��֯����',
			store : CommitteeInfoDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
		
///ְ������
var PartTimeJobsDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
PartTimeJobsDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : itemGridUrl+'?action=CalPartTimeJobs', 
                        method:'POST'
					});
		});

var PartTimeJobsCombo = new Ext.form.ComboBox({
	id: 'PartTimeJobsCombo',
			fieldLabel : 'ְλ����',
			store : PartTimeJobsDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
///////////////////����/////////////////////////////  
var TypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '����'],['2', '��ѧ']]
	});		
		
var TypeCombox = new Ext.form.ComboBox({
	                   id : 'TypeCombox',
		           fieldLabel : '����',
	                   width : 120,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : TypeDs,
		           anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true
						  });	
var tmpTitle='ѧ���ְ������Ϣ';	
var combos = new Ext.FormPanel({
			title : '����ְ������Ϣ��ѯ',
			iconCls : 'search',
			autoHeight : true,
			region:'north',
			frame:true,
			defaults: {bodyStyle:'padding:5px'},
				items:[{
			    columnWidth:1,
			    xtype: 'panel',
				layout:"column",
				items: [
				   	{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">����</p>',
						width : 60			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					TypeCombox,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},					
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">��֯��Ϣ</p>',
						width : 60			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					CommitteeInfoCombo,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">����</p>',
						width : 40			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					uNameField,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">ְ������</p>',
						width : 60			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					PartTimeJobsCombo,
					{
						xtype : 'displayfield',
						value : '',
						width : 30
					},
					{
						xtype : 'button',
						text : '��ѯ',
						handler : function(b){srmdeptuserDs();},
						iconCls : 'search',
						width : 30
					}	
		     	]
			}]
});	
//���ݿ�����ģ��
var itemGridCm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), 
        {

            id:'rowid',
            header: 'ID',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            dataIndex: 'rowid'
       }, {
            id:'Type',
            header: '����',
            allowBlank: false,
            width:40,
            editable:false,
            dataIndex: 'Type'
       }, {
            id:'UserName',
            header: '��ְ��Ա����',
            allowBlank: false,
            width:80,
            editable:false,
            dataIndex: 'UserName'
       }, {
            id:'DeptName',
            header: '��������',
            allowBlank: false,
            width:180,
            editable:false,
            dataIndex: 'DeptName',
			renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
       }, {
            id:'CommitteeName',
            header: 'ѧ������',
            allowBlank: false,
            width:180,
            editable:false,
            dataIndex: 'CommitteeName',
			renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
       }, {
            id:'Branch',
            header: '�ֻ��ѧ������',
            allowBlank: false,
            width:180,
            editable:false,
            dataIndex: 'Branch',
			renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
       }, {
    	     id:'PositionName',
    	     header: 'ְλ����',
    	     allowBlank: false,
    	     width:100,
    	     editable:false,
    	     dataIndex: 'PositionName'
    	}, {
    	     id:'Year',
    	     header: '���',
    	     allowBlank: false,
    	     width:60,
    	     editable:false,
    	     dataIndex: 'Year'
    	}, {
    	     id:'StartDate',
    	     header: '��ְ��ʼʱ��',
    	     allowBlank: false,
    	     width:80,
    	     editable:false,
    	     dataIndex: 'StartDate'
    	}, {
    	     id:'EndDate',
    	     header: '��ְ��ֹʱ��',
    	     allowBlank: false,
    	     width:80,
    	     editable:false,
    	     dataIndex: 'EndDate'
    	}, {
    	     id:'SubUserName',
    	     header: '������ ',
    	     allowBlank: false,
    	     width:60,
    	     editable:false,
    	     dataIndex: 'SubUserName'
    	}, {
    	     id:'SubDate',
    	     header: '����ʱ��',
    	     allowBlank: false,
    	     width:80,
    	     editable:false,
    	     dataIndex: 'SubDate'
    	}, {
    	     id:'DataStatus',
    	     header: '����״̬',
    	     allowBlank: false,
    	     width:60,
    	     editable:false,
    	     dataIndex: 'DataStatus'
    	},{
						id:'Auditor',
						header:'�����',
						width:60,
						editable:false,
						align:'left',
						dataIndex:'Auditor'

					},{
						id:'AuditDate',
						header:'���ʱ��',
						width:80,
						editable:false,
						align:'left',
						hidden:false,
						dataIndex:'AuditDate'

					},{
						id:'ResAudit',
						header:'���״̬',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'ResAudit'

					},{
						id:'ResDesc',
						header:'���˵��',
						width:180,
						editable:false,
						align:'left',
						dataIndex:'ResDesc',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
							id:'upload',
							header: '����',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>�ϴ�</u></span>';
							}
					},{
							id:'download',
							header: '����',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>����</u></span>';
					    } }
			    
]);

var addButton = new Ext.Toolbar.Button({
					text : '����',
					//tooltip : '���',
					iconCls: 'edit_add',
					handler : function() {
						srmPartTimeInfoAddFun();
					}
				});

var editButton = new Ext.Toolbar.Button({
					text : '�޸�',
					//tooltip : '�޸�',
					iconCls: 'pencil',
					handler : function() {
						var rowObj = itemGrid.getSelectionModel().getSelections();
						var len = rowObj.length; 
						if(len < 1)
						{
							Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}else{
							var state = rowObj[0].get("DataStatus");	
							if((state == "δ�ύ")||(groupdesc=="���й���ϵͳ(��Ϣ�޸�)" )  ){srmPartTimeInfoEditFun();}
							else {Ext.Msg.show({title:'����',msg:'�������ύ���������޸ģ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}
						}
						
					}
				});

var subButton = new Ext.Toolbar.Button({
			text : '�ύ',
			//tooltip : '�ύ',
			iconCls: 'pencil',
			handler : function(){
 var rowObj = itemGrid.getSelectionModel().getSelections();     // get the selected items
    var len = rowObj.length;
    if(len > 0)
    {
	    
	    //////////////////////////�ж��Ƿ��и����ϴ���¼///////////////////////////
				Ext.Ajax.request({
					url:'herp.srm.uploadexe.csp?action=GetUpLoadInfo&RecDr='+rowObj[0].get("rowid")+'&SysNo='+'T001',
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'ע��',msg:'���ϴ�����!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
						
							return;
						}
						
					},
					scope: this			
				  });
		///////////////////////////////////////
	    
    	Ext.MessageBox.confirm('��ʾ', 
    	    'ȷ��Ҫ�ύѡ������?�ύ�󲻿��޸ġ�����ɾ����', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {	
				 	if(rowObj[0].get("DataStatus")!="���ύ"){
				        for(var i = 0; i < len; i++){     		
					          Ext.Ajax.request({
					              url: itemGridUrl+'?action=sub&rowid='+rowObj[i].get("rowid")+'&userid='+session['LOGON.USERCODE'],
												waitMsg:'�ύ��...',
						            failure: function(result, request) {
						            		Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
												success: function(result, request) {
														var jsonData = Ext.util.JSON.decode( result.responseText );
						                if (jsonData.success=='true') { 
						                			 	Ext.MessageBox.alert('��ʾ', '�ύ���');
														
											    		itemGridDs.load({params : {start :0,limit : itemGridPagingToolbar.pageSize,usercode:usercode}});
									    			}
									    			else {
									    					var message = "�ύʧ��";
									    					Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									    			}
												},
					               scope: this
					          });
			        	}
					 }else{
						 Ext.Msg.show({title:'����',msg:'��ѡ��������ύ���������ύ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						 //return;
					 }
			    }
		    } 
		);	
    }
    else
    {
    	Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�ύ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
    }       
	
}
});
var delButton = new Ext.Toolbar.Button({
			text : 'ɾ��',
			//tooltip : 'ɾ��',
			iconCls: 'edit_remove',
			handler : function() {
    var rowObj = itemGrid.getSelectionModel().getSelections();     // get the selected items
    var len = rowObj.length;
    if(len > 0)
    {
		for(var i = 0; i < len; i++){
			var state = rowObj[i].get("DataStatus");			
			if(state == "δ�ύ" ){
			Ext.MessageBox.confirm('��ʾ', 
    	    'ȷ��Ҫɾ��ѡ������?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {	
				        for(var i = 0; i < len; i++){     		
					          Ext.Ajax.request({
					              url: itemGridUrl+'?action=del&rowid='+rowObj[i].get("rowid"),
												waitMsg:'ɾ����...',
						            failure: function(result, request) {
						            		Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
												success: function(result, request) {
														var jsonData = Ext.util.JSON.decode( result.responseText );
						                if (jsonData.success=='true') { 
						                		if (i==len-1)Ext.MessageBox.alert('��ʾ', 'ɾ�����');
											    			itemGridDs.load({params : {start :0,limit : itemGridPagingToolbar.pageSize,usercode:usercode}});
									    			}
									    			else {
									    					var message = "SQLErr: " + jsonData.info;
									    					Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									    			}
												},
					               scope: this
					          });
			        }	
			    }
		    } 
		);	
		}else {Ext.Msg.show({title:'����',msg:'�������ύ������ɾ����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}
    	
    }
    else
    {
    	Ext.Msg.show({title:'����',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
    }       

}
});

var itemGrid = new Ext.grid.GridPanel({
			title: '����ְ������Ϣ��ѯ�б�',
			iconCls: 'list',	
		    region: 'center',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'herp.srm.srmuserexe.csp',
		    atLoad : true, // �Ƿ��Զ�ˢ��
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			tbar:[addButton,'-',editButton,'-',delButton,'-',subButton],
			bbar:itemGridPagingToolbar
});


  itemGridDs.load({	
			params:{start:0, limit:itemGridPagingToolbar.pageSize},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
});
  var srmdeptuserDs=function(){	
		
	    itemGridDs.proxy = new Ext.data.HttpProxy({
	    	
								url : 'herp.srm.srmPartTimeInfoexe.csp?action=list&User='+encodeURIComponent(uNameField.getValue())+ 
								'&CommitteeDr='+CommitteeInfoCombo.getValue()+
								'&PositionDr='+ PartTimeJobsCombo.getValue()+'&usercode='+usercode+'&Type='+TypeCombox.getValue(),
								
								method : 'GET'
							});
					itemGridDs.load({
								params : {
									start : 0,
									limit : itemGridPagingToolbar.pageSize
								}
							});
	};
	
	if (groupdesc=="���й���ϵͳ(��Ϣ�޸�)")
{
	 addButton.disable();//����Ϊ������
	  delButton.disable();//����Ϊ������
	  subButton.disable();//����Ϊ������
	  
	
	}

uploadMainFun(itemGrid,'rowid','T001',18);
downloadMainFun(itemGrid,'rowid','T001',19);