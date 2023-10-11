///////////////////////////////////////////////////

var tmpData="";

var itemGridUrl = '../csp/herp.srm.srmPartTimeInfoAuditexe.csp';

var usercode = session['LOGON.USERCODE'];





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
			'ResDesc',
			'CommitteeType'
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
		
		
		///��ְ����
var CommitteeTypeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'Name'])
		});
		
CommitteeTypeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : itemGridUrl+'?action=listCommitteeType&str='+encodeURIComponent(Ext.getCmp('CommitteeTypeCombo').getRawValue()), 
                        method:'POST'
					});
		});

var CommitteeTypeCombo = new Ext.form.ComboBox({
	id: 'CommitteeTypeCombo',
			fieldLabel : '����',
			store : CommitteeTypeDs,
			displayField : 'Name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
			//editable:true
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
			autoHeight : true,
			title : '����ְ�����Ϣ��ѯ',
			iconCls : 'search',
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
        // new Ext.grid.CheckboxSelectionModel({editable:false}),
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
    	     id:'Year',
    	     header: '���',
    	     allowBlank: false,
    	     width:60,
    	     editable:false,
    	     dataIndex: 'Year'
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
    	},{
			 id:'CommitteeType',
    	     header: '����',
    	     allowBlank: false,
    	     width:100,
    	     //editable:false,
    	     dataIndex: 'CommitteeType',
		    editor:CommitteeTypeCombo,
		    renderer : function(v, p, r){
							var index=CommitteeTypeDs.find('rowid',v);
							
							if (index!=-1)
							
							{
								return CommitteeTypeDs.getAt(index).data.Name;
							
								}
								return v
								//return r.get('Name');
					    }

		},{
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
						dataIndex:'ResDesc'

					},{
							id:'upload',
							header: '����',
							allowBlank: false,
							width:40,
							hidden:true,
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


var AuditButton = new Ext.Toolbar.Button({
	text: 'ͨ��',  
    iconCls: 'pencil',
    handler:function(){
	//���岢��ʼ���ж���
	var checker = session['LOGON.USERCODE'];
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//���岢��ʼ���ж��󳤶ȱ���
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	for(var j= 0; j< len; j++){
	    
	
	   if(rowObj[j].get("ResAudit")!='�ȴ�����')
	 {
		      Ext.Msg.show({title:'ע��',msg:'���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
	 }
	
	     if(rowObj[j].get("CommitteeType") == "")
	 {
		      Ext.Msg.show({title:'ע��',msg:'����д����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
	 }
	 //alert(rowObj[j].get("CommitteeType"));
	 //alert(CommitteeTypeCombo.getValue());
	 
	}
	function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    Ext.Ajax.request({
						url:'herp.srm.srmPartTimeInfoAuditexe.csp?action=audit&&rowid='+rowObj[i].get("rowid")+'&usercode='+usercode+'&CommitteeType='+CommitteeTypeCombo.getValue(),
						waitMsg:'�����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},   
						success: function(result, request){			
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'��˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGridDs.load({params:{start:0, limit:12,usercode:checker}});								
							}else{
							Ext.Msg.show({title:'����',msg:'���ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						    }
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ�����ѡ��¼��?��˺����޸�',handler);
    }
});

var NoAuditButton = new Ext.Toolbar.Button({
				text : '��ͨ��',
				iconCls: 'pencil',
				handler : function() {
					var rowObj=itemGrid.getSelectionModel().getSelections();
					var len = rowObj.length;
					if(len < 1){
						Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}
					for(var j= 0; j < len; j++){
						 if(rowObj[j].get("ResAudit")!='�ȴ�����')
	       {
		      Ext.Msg.show({title:'ע��',msg:'���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
	       }else
						{
							noauditfun();
						}
					}
					
					
			   }
});




var itemGrid = new Ext.grid.EditorGridPanel({
			title: '����ְ�����Ϣ��ѯ�б�',
			iconCls: 'list',
		    region: 'center',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'herp.srm.srmPartTimeInfoAuditexe.csp',
		    atLoad : true, // �Ƿ��Զ�ˢ��
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			//tbar:[addButton,'-',editButton,'-',delButton,'-',subButton],
			tbar:[AuditButton,'-',NoAuditButton],
			
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
	    	
								url : 'herp.srm.srmPartTimeInfoAuditexe.csp?action=list&User='+encodeURIComponent(uNameField.getValue())+ 
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


//uploadMainFun(itemGrid,'rowid','T001',17);
downloadMainFun(itemGrid,'rowid','T001',20);