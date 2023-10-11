var userdr = session['LOGON.USERID'];

var projUrl = 'herp.budg.budgprojauditexe.csp';
var commonboxURL='herp.budg.budgcommoncomboxexe.csp';
//////////////////////// 用户///////////////////////////////////
var userDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

userDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : commonboxURL+'?action=username&flag=1&str='+encodeURIComponent(Ext.getCmp('userCombo').getRawValue()),
						method : 'POST'
					});
		});

var userCombo = new Ext.form.ComboBox({
			id :'userCombo',
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
		
////////////////////////权限人///////////////////////////////////		
var user2Ds = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

user2Ds.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=userList&str='+encodeURIComponent(Ext.getCmp('user2Combo').getRawValue()),
						method : 'POST'
					});
		});

var user2Combo = new Ext.form.ComboBox({
			id :'user2Combo',
			fieldLabel : '权限人',
			store : user2Ds,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
		
// ////////////项目////////////////////////
var projDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

projDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=projList&flag=1&str'+encodeURIComponent(Ext.getCmp('projCombo').getRawValue()),
						method : 'POST'
					});
		});

var projCombo = new Ext.form.ComboBox({
			id :'projCombo',
			fieldLabel : '项目',
			store : projDs,
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
// ////////////项目名称////////////////////////
var proj2Ds = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

proj2Ds.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=projList&flag=2&str'+encodeURIComponent(Ext.getCmp('proj2Combo').getRawValue()),
						method : 'POST'
					});
		});

var proj2Combo = new Ext.form.ComboBox({
			id :'proj2Combo',
			fieldLabel : '项目名称',
			store : proj2Ds,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '名称或者编码……',
			width : 200,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

var queryPanel = new Ext.FormPanel({
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
			value : '<center><p style="font-weight:bold;font-size:150%">项目访问权限</p></center>',
			columnWidth : 1,
			height : '35'
		}]
	},{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
					xtype : 'displayfield',
					value : '项目名称:',
					columnWidth : .05
				}, proj2Combo,
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '权限人:',
					columnWidth : .05
				}, user2Combo,
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype:'button',
					text: '查询',
					handler:function(){
					
						var prjname  = proj2Combo.getValue();
						var auditer  = user2Combo.getValue();

						itemGrid.load({params:{start:0, limit:25,prjname:prjname,auditer:auditer}});
						
					},
					iconCls: 'add'
				}]
	}]
});
var checkActive = new Ext.form.Checkbox({
						fieldLabel: '能否提交'								
					})
var checkActive2 = new Ext.form.Checkbox({
						fieldLabel: '能否审核'								
					})
					
var itemGrid = new dhc.herp.Grid({
			region : 'center',
			url : projUrl,		
			
			fields : [{
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'CompName',
						header : '医疗单位',
						width : 150,
						dataIndex : 'CompName',
						hidden : true
					},{
						id : 'proj',
						header : '项目',
						width : 300,
						allowBlank:false,
						dataIndex : 'proj',
						type:projCombo

					}, {
						id : 'user',
						header : '用户',
						width : 300,						
						allowBlank : false,
						dataIndex : 'user',
						type:userCombo

					},{
            			id:'IsSubmit',
            			header: '能否提交',
						width:120,
            			dataIndex: 'IsSubmit',
            			type:checkActive,
            			renderer : function(v, p, record){
        				//p.css += ' x-grid3-check-col-td'; 
        				return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    					}
        			},{
            			id:'IsAudit',
            			header: '能否审核',
						width:120,
            			dataIndex: 'IsAudit',
            			
            			type:checkActive2,
            			renderer : function(v, p, record){
        				//p.css += ' x-grid3-check-col-td'; 
        				return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    					}
        			}],
					xtype : 'grid',
					atload:true,
					loadMask : true
					//viewConfig : {forceFit : true}					

		});

    //itemGrid.btnAddHide();  //隐藏增加按钮
   	//itemGrid.btnSaveHide();  //隐藏保存按钮
    itemGrid.btnResetHide();  //隐藏重置按钮
    //itemGrid.btnDeleteHide(); //隐藏删除按钮
    itemGrid.btnPrintHide();  //隐藏打印按钮


itemGrid.load({params:{start:0, limit:25}});


