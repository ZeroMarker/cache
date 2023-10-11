var hospid = session['LOGON.HOSPID'];
var commonboxURL='herp.budg.budgcommoncomboxexe.csp';
var deptuserURL='herp.budg.budgdeptuserexe.csp';

////////////////人员姓名////////////////////
var unituserDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
unituserDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:commonboxURL+'?action=username&flag=1&str='+encodeURIComponent(Ext.getCmp('unituserField').getRawValue()),method:'POST'});
});
var unituserField = new Ext.form.ComboBox({
	id: 'unituserField',
	fieldLabel: '人员名称',
	width:200,
	listWidth :300,
	store: unituserDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择人员姓名...',
	name: 'unituserField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

////////////////查询人员姓名////////////////////
var userDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

userDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
	                     url:commonboxURL+'?action=username&flag=1&str='+encodeURIComponent(Ext.getCmp('userCombo').getRawValue()),method:'POST'});
					
		});

var userCombo = new Ext.form.ComboBox({
			id: 'userCombo',
			fieldLabel : '查询用户',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText:'请选择人员姓名...',
			width : 150,
			listWidth : 300,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
			selectOnFocus : true
		});

////////////////查询上级领导////////////////////		
var user2Ds = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

user2Ds.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
	                    url : commonboxURL+'?action=username&flag=1&str='+encodeURIComponent(Ext.getCmp('user2Combo').getRawValue()),method:'POST'});
					
		     });

var user2Combo = new Ext.form.ComboBox({
			id : 'user2Combo',
			fieldLabel : '查询上级领导',
			store : user2Ds,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText:'请选择上级领导...',
			width : 150,
			listWidth : 300,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
			selectOnFocus : true
		});

////////////////科室名称////////////////////
var unitdeptDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

unitdeptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:commonboxURL+'?action=dept&flag=1&str='+encodeURIComponent(Ext.getCmp('unitdeptField').getRawValue()),method:'POST'});
});

var unitdeptField = new Ext.form.ComboBox({
	id: 'unitdeptField',
	fieldLabel: '科室名称',
	width:200,
	listWidth : 300,
	allowBlank: false,
	store: unitdeptDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科室...',
	name: 'unitdeptField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

////////////////查询科室名称////////////////////
var unitdeptDs2 = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

unitdeptDs2.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:deptuserURL+'?action=caldept&str='+encodeURIComponent(Ext.getCmp('unitdept2Field').getRawValue()),method:'POST'});
});

var unitdept2Field = new Ext.form.ComboBox({
	id: 'unitdept2Field',
	fieldLabel: '查询科室',
	width:200,
	listWidth : 300,
	allowBlank: false,
	store: unitdeptDs2,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科室...',
	name: 'unitdept2Field',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
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
			value : '<center><p style="font-weight:bold;font-size:150%">组织关系维护</p></center>',
			columnWidth : 1,
			height : '35'
		}]
	},{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
					xtype : 'displayfield',
					value : '人员姓名:',
					columnWidth : .08
				}, userCombo,
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '科室名称:',
					columnWidth : .08
				},unitdept2Field,
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '上级姓名:',
					columnWidth : .08
				}, user2Combo,
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype:'button',
					text: '查询',
					handler:function(){
					
						var uname  = userCombo.getValue();
						var deptdr  = unitdept2Field.getValue();
						var mnguname  = user2Combo.getValue();

						itemGrid.load({params:{start:0, limit:25,uname:uname,deptdr:deptdr,mnguname:mnguname}});
						
					},
					iconCls: 'add'
				}]
	}]
});
		
var checkActive = new Ext.form.Checkbox({
						fieldLabel: '是否用于一般预算'								
					});
var checkActive2 = new Ext.form.Checkbox({
						fieldLabel: '是否用于项目预算'								
					});
var checkActive3 = new Ext.form.Checkbox({
						fieldLabel: '能否项目审核'								
					});

var addbudgButton = new Ext.Toolbar.Button({
	text: '批量添加',
	tooltip: '批量添加组织关系信息',
	iconCls: 'add',
	handler: function(){
		addfun(itemGrid);
	}
});

var itemGrid = new dhc.herp.Grid({
        width: 400,
         //edit:false,                   //是否可编辑
        //readerModel:'local',
        region: 'center',
        url: deptuserURL,
		//autoLoad:true,
		//tbar : [addbudgButton],
		xtype : 'grid',
		atLoad : true, // 是否自动刷新
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'CompName',
            header: '医疗单位',
            edit:false,
            allowBlank: true,
			width:170,
            dataIndex: 'CompName'
        },{
            id:'username',
            header: '人员姓名',
			allowBlank: false,
			width:170,
			edit:true,
            dataIndex: 'username',
            type:unituserField
        },{
            id:'deptname',
            header: '科室名称',
			allowBlank: false,
			width:170,
			//update:true,
            dataIndex: 'deptname',
            type:unitdeptField
        },{
            id:'mngname',
            header: '上级领导',
			calunit:true,
			//update:true,
			allowBlank: false,
			width:170,
            dataIndex: 'mngname',
			type:unituserField
        },{
            id:'IsBase',
            header: '是否用于一般预算',
			width:120,
            dataIndex: 'IsBase',
            type:checkActive,
            renderer : function(v, p, record){
        	//p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'|| v== true?'-on':'')+' x-grid3-cc-'+this.IsBase+'">&#160;</div>';
    		}
        },{
            id:'IsProj',
            header: '是否用于项目预算',
			width:120,
            dataIndex: 'IsProj',
            type:checkActive2,
            renderer : function(v, p, record){
        	//p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'|| v== true?'-on':'')+' x-grid3-cc-'+this.IsProj+'">&#160;</div>';
    		}
        },{
            id:'IsFinance',
            header: '能否项目审核',
			width:120,
            dataIndex: 'IsFinance',
            type:checkActive3,
            renderer : function(v, p, record){
        	//p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'|| v== true?'-on':'')+' x-grid3-cc-'+this.IsFinance+'">&#160;</div>';
    		}
        }]
    
    });

	itemGrid.btnResetHide();
	itemGrid.hiddenButton(4);
	itemGrid.addButton(addbudgButton);
    //itemGrid.load({params:{start:0, limit:1, userdr:userdr}});