var userdr = session['LOGON.USERID'];
var hospid = session['LOGON.HOSPID'];
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var deptUrl = 'herp.budg.budgdeptauditexe.csp';
//////////////////医疗单位
var AddCompDRDs = new Ext.data.Store({
						proxy : "",
						url : commonboxUrl+'?action=hospital&rowid='+hospid+'&start=0&limit=10&str=',
						//autoLoad : true,  
						fields: ['rowid','name'],
						reader : new Ext.data.JsonReader({
									totalProperty : "results",
									root : 'rows'
								}, ['rowid', 'name'])
					});

			AddCompDRDs.on('load', function() {

						var Num=AddCompDRDs.getCount();
    					if (Num!=0){
						var id=AddCompDRDs.getAt(0).get('rowid');
						AddCompDRCombo.setValue(id);  
    					} 
					});

			var AddCompDRCombo = new Ext.form.ComboBox({
						id : 'AddCompDRCombo',
						name : 'AddCompDRCombo',
						fieldLabel : '医疗单位',
						store : AddCompDRDs,
						displayField : 'name',
						valueField : 'rowid',
						//allowBlank: false,
						typeAhead : true,
						forceSelection : true,
						triggerAction : 'all',
						emptyText : '',
						width : 70,
						listWidth : 300,
						pageSize : 10,
						minChars : 1,
						anchor: '90%',
						selectOnFocus : true
					});			
// 用户///////////////////////////////////

var userDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

userDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : commonboxUrl+'?action=username&flag=1&str='+encodeURIComponent(Ext.getCmp('userCombo').getRawValue()),
						method : 'POST'
					});
		});

var userCombo = new Ext.form.ComboBox({
			id: 'userCombo',
			fieldLabel : '用户',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择...',
			width : 100,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

var userDs1 = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
userDs1.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : deptUrl+'?action=username&str='+encodeURIComponent(Ext.getCmp('userCombo1').getRawValue()),
						method : 'POST'
					});
		});
		
var userCombo1 = new Ext.form.ComboBox({
			id: 'userCombo1',
			fieldLabel : '人员名称',
			store : userDs1,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择...',
			width : 200,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .10,
			selectOnFocus : true
		});
		
// ////////////科室名称////////////////////////
var deptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

deptDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : commonboxUrl+'?action=dept&flag=1&str='+encodeURIComponent(Ext.getCmp('deptCombo').getRawValue()),
						method : 'POST'
					});
		});

var deptCombo = new Ext.form.ComboBox({
			id: 'deptCombo',
			fieldLabel : '科室',
			store : deptDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择...',
			width : 100,
			listWidth : 200,			
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

var deptDs1 = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

deptDs1.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : deptUrl+'?action=dept&str='+encodeURIComponent(Ext.getCmp('deptCombo1').getRawValue()),
						method : 'POST'
					});
		});

var deptCombo1 = new Ext.form.ComboBox({
			id: 'deptCombo1',
			fieldLabel : '科室名称',
			store : deptDs1,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择...',
			width : 200,
			listWidth : 200,			
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
		
var SafeGroupDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

SafeGroupDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : deptUrl+'?action=groupList&flag=2&str='+encodeURIComponent(Ext.getCmp('SafeGroupCombo').getRawValue()),
						method : 'POST'
					});
		});

var SafeGroupCombo = new Ext.form.ComboBox({
			id: 'SafeGroupCombo',
			fieldLabel : '安全组',
			store : SafeGroupDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择...',
			width : 200,
			listWidth : 200,			
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
		
/////////////////// 查询按钮 //////////////////
/****var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
	    var deptname  = deptCombo1.getValue();
	    var uname = userCombo1.getValue();
	    var groupname = SafeGroupCombo.getValue();
		itemGrid.load({params:{start:0,limit:25,deptname:deptname,uname:uname,groupname:groupname}});
		
	}
});****
****/

//批量添加
var batchButton = new Ext.Toolbar.Button({
	text: '批量添加',
	tooltip: '批量添加',
	iconCls: 'add',
	handler: function(){
		BatchAddfun(itemGrid);				
		}
});

//删除
var delButton = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'remove',
	handler: function(){
		var rowObj = itemGrid.getSelectionModel().getSelections();
		var len = rowObj.length;
		var tmpRowid = "";
		if(len < 1)
		{
			Ext.Msg.show({title:'注意',msg:'请选择删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}	
			var rowids=""
			for(var i = 0; i < len; i++){
				tmpRowid = rowObj[i].get("rowid");	
				if(rowids==""){
					rowids=tmpRowid;
					}
				else {
					rowids=rowids+"|"+tmpRowid
					}
				}
			
			Ext.MessageBox.confirm('提示','确定要删除选定的行?',function(btn){
			if(btn == 'yes'){
						Ext.each(rowObj, function(record) {
						if (Ext.isEmpty(record.get("rowid"))) {
									itemGrid.getStore().remove(record);
									return;
						}
							});  
						Ext.Ajax.request({
							url: deptUrl + '?action=del&rowid='+rowids,
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0,limit:25}});
								}else{
									Ext.Msg.show({title:'错误',msg:'错误',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});   	
				
					}
				} 
			)	
		}
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
			value : '<center><p style="font-weight:bold;font-size:150%">科室访问权限</p></center>',
			columnWidth : 1,
			height : '35'
		}]
	},{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
					xtype : 'displayfield',
					value : '科室名称:',
					columnWidth : .05
				}, deptCombo1,
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '人员名称:',
					columnWidth : .05
				},userCombo1,
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '安全组:',
					columnWidth : .04
				}, SafeGroupCombo,
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype:'button',
					text: '查询',
					iconCls: 'option',
					handler:function(){		
						var deptname  = deptCombo1.getValue();
	    				var uname = userCombo1.getValue();
	    				var groupname = SafeGroupCombo.getValue();
						itemGrid.load({params:{start:0,limit:25,deptname:deptname,uname:uname,groupname:groupname}});		
				    }
				  }
		       ]
	}]
});

var itemGrid = new dhc.herp.Grid({
	       
            width: 400,
            //edit:true,                   //是否可编辑
            //readerModel:'remote',
			region : 'center',
			url : deptUrl,		
			
			fields : [
			new Ext.grid.CheckboxSelectionModel({editable:false}),
					 {
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'CompName',
						header : '医疗单位',
						width : 300,
						//allowBlank:false,
						dataIndex : 'CompName',
						type:AddCompDRCombo,
						hidden : true

					},{
						id : 'dept',
						header : '科室',
						width : 300,
						allowBlank:false,
						dataIndex : 'dept',
						type:deptCombo

					}, {
						id : 'user',
						header : '用户',
						width : 300,						
						allowBlank : false,
						dataIndex : 'user',
						type:userCombo

					}],
					xtype : 'grid',
					atload:true,
					loadMask : true,
										
          tbar:[batchButton,delButton]
		});

    //itemGrid.btnAddHide();  //隐藏增加按钮
   	//itemGrid.btnSaveHide();  //隐藏保存按钮
    itemGrid.btnResetHide();  //隐藏重置按钮
    itemGrid.btnDeleteHide(); //隐藏删除按钮
    itemGrid.btnPrintHide();  //隐藏打印按钮

itemGrid.load({params:{start:0,limit:25}});


