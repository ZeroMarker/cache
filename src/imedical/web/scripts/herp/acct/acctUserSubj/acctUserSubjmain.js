//添加账套ID
var acctbookID=	IsExistAcctBook();

var userdr = session['LOGON.USERID'];
// 会计用户名称///////////////////////////////////
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
			fieldLabel : '用户',
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



// 会计科目ID///////////////////////////////////
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
		fieldLabel : '科目',
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
///   会计科目查询   ////////
		
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
	fieldLabel : '会计科目',
	store: acctSubjDs,
	width:145,
	listWidth : 245,
	valueField: 'name',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'模糊查询...',
	name: 'AcctSubjCombo',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
		});

///  会计用户查询  ///////
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
	fieldLabel : '会计用户',
	store: acctUserDs,
	width:145,
	listWidth : 245,
	valueField: 'name',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'模糊查询...',
	name: 'AcctUserCombo',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
		
	
///  查询按钮   ///////
var findButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
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
			value : '<center><p style="font-weight:bold;font-size:200%">科目权限维护</p></center>',
			columnWidth : 1,
			height : '40'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
					xtype : 'displayfield',
					value : '会计科目:',
					columnWidth : .08
				},AcctSubj, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '会计用户:',
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
        title:"科目权限维护",
        //headerAsText:false,	
        //xtype : 'grid',
		readerModel:'remote',
		tbar:['会计用户:',AcctUserCombo,'-','会计科目:',AcctSubjCombo,'-',findButton],
		atload:true,
		loadMask : true,
        fields: [{
	        id:'rowid',
            header: '科目权限',
            width:150,
            edit:false,
           	hidden:true,
            print:false,
            dataIndex:'rowid'
        },{	
       		id:'acctbookID',
        	header: '账套ID',
        	hidden: true,
        	print:false,
			align: 'center',
        	dataIndex: 'bookid'        
    	},{
            id:'acctUserID',
            header: '会计用户名称',
            type:UserCombo,
			allowBlank: false,
			width:200,
			print:true,
            dataIndex: 'acctUserID'
        },{								
            id:'AcctSubjID',
            header: '会计科目名称',
            type:SubjCombo,
            allowBlank: false,
			width:200,
			print:true,
            dataIndex: 'AcctSubjID'
        },{
            id:'createDate',
            header: '创建时间',
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

//itemGrid.btnAddHide();  //隐藏增加按钮
itemGrid.btnResetHide();  //隐藏重置按钮
//itemGrid.btnDeleteHide(); //隐藏删除按钮
itemGrid.btnPrintHide();  //隐藏打印按钮
