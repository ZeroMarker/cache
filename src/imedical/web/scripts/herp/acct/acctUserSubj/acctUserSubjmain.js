//�������ID
var acctbookID=	IsExistAcctBook();

var userdr = session['LOGON.USERID'];
// ����û�����///////////////////////////////////
var projUrl = 'herp.acct.acctusersubjexe.csp';
var userDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

userDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=userList',
						method : 'POST'
					});
		});

var UserCombo = new Ext.form.ComboBox({
			fieldLabel : '�û�',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});



// ��ƿ�ĿID///////////////////////////////////
var subjDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

subjDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=subjList',
						method : 'POST'
					});
		});
		
var SubjCombo = new Ext.form.ComboBox({
		fieldLabel : '��Ŀ',
			 store : subjDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
///   ��ƿ�Ŀ��ѯ   ////////
		
var acctSubjDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({
		totalProperty:'results',root:'rows'},['rowid','name'])
});

acctSubjDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=subjList&str='+encodeURIComponent(Ext.getCmp('AcctSubjCombo').getRawValue()),method:'POST'});
});

		
var AcctSubjCombo = new Ext.form.ComboBox({
			
	id: 'AcctSubjCombo',
	fieldLabel : '��ƿ�Ŀ',
	store: acctSubjDs,
	width:145,
	listWidth : 245,
	valueField: 'name',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'ģ����ѯ...',
	name: 'AcctSubjCombo',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
		});

///  ����û���ѯ  ///////
var acctUserDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({
		totalProperty:'results',root:'rows'},['rowid','name'])
});

acctUserDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=userList&str='+encodeURIComponent(Ext.getCmp('AcctUserCombo').getRawValue()),method:'POST'});
});

		
var AcctUserCombo = new Ext.form.ComboBox({
			
	id: 'AcctUserCombo',
	fieldLabel : '����û�',
	store: acctUserDs,
	width:145,
	listWidth : 245,
	valueField: 'name',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'ģ����ѯ...',
	name: 'AcctUserCombo',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
		
	
///  ��ѯ��ť   ///////
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
    tooltip:'��ѯ',        
    iconCls:'find',
	handler:function(){

		var Subj=AcctSubjCombo.getValue();
		var User=AcctUserCombo.getValue();
		
		itemGrid.load(({
			params:{
				start:0,
				limit:25,
				acctbookID:acctbookID,
				Subj:Subj,
				User:User}}));
	}
});	

	
/* var queryPanel = new Ext.FormPanel({
	height : 90,
	region : 'north',
	frame : true,

	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<center><p style="font-weight:bold;font-size:200%">��ĿȨ��ά��</p></center>',
			columnWidth : 1,
			height : '40'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
					xtype : 'displayfield',
					value : '��ƿ�Ŀ:',
					columnWidth : .08
				},AcctSubj, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '����û�:',
					columnWidth : .08
				},AcctUser, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}]
	}]
	
}); */


var itemGrid = new dhc.herp.Grid({
        region: 'center',
        url:'herp.acct.acctusersubjexe.csp',
        title:"��ĿȨ��ά��",
        //headerAsText:false,	
        //xtype : 'grid',
		readerModel:'remote',
		tbar:['����û�:',AcctUserCombo,'-','��ƿ�Ŀ:',AcctSubjCombo,'-',findButton],
		atload:true,
		loadMask : true,
        fields: [{
	        id:'rowid',
            header: '��ĿȨ��',
            width:150,
            edit:false,
           	hidden:true,
            print:false,
            dataIndex:'rowid'
        },{	
       		id:'acctbookID',
        	header: '����ID',
        	hidden: true,
        	print:false,
			align: 'center',
        	dataIndex: 'bookid'        
    	},{
            id:'acctUserID',
            header: '����û�����',
            type:UserCombo,
			allowBlank: false,
			width:200,
			print:true,
            dataIndex: 'acctUserID'
        },{								
            id:'AcctSubjID',
            header: '��ƿ�Ŀ����',
            type:SubjCombo,
            allowBlank: false,
			width:200,
			print:true,
            dataIndex: 'AcctSubjID'
        },{
            id:'createDate',
            header: '����ʱ��',
            allowBlank: true,
            edit:false,
			width:200,
			print:true,
            dataIndex: 'createDate'
        }]
		//tbar:[findButton]
});

itemGrid.load({
	    params:{
		    start:0,
		    limit:25,
		    acctbookID:acctbookID
		    }
		});	

//itemGrid.btnAddHide();  //�������Ӱ�ť
itemGrid.btnResetHide();  //�������ð�ť
//itemGrid.btnDeleteHide(); //����ɾ����ť
itemGrid.btnPrintHide();  //���ش�ӡ��ť
