var SysBusiness = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

SysBusiness.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.sysbusimoduleexe.csp?action=SysBusinessList',
						method : 'POST'
					});
		});

var SysBusinessCombo = new Ext.form.ComboBox({
			fieldLabel : '用户',
			store : SysBusiness,
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
var itemGrid = new dhc.herp.Grid({
        // title: '业务系统模块维护',
        width: 400,
        //edit:false,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'herp.acct.sysbusimoduleexe.csp',	  
		//tbar:delButton,
		atLoad : true, // 是否自动刷新
		loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'code',
            header: '<div style="text-align:center">模块编码</div>',
			allowBlank: false,
			width:200,
            dataIndex: 'code'
        },{
            id:'name',
            header: '<div style="text-align:center">模块名称</div>',
			allowBlank: false,
			width:200,
            dataIndex: 'name'
        },{
            id:'SysBusinessID',
            header: '<div style="text-align:center">系统名称</div>',
			width:200,
            dataIndex: 'SysBusinessID',
            hidden: false,
            type:SysBusinessCombo
        }] 
});

    itemGrid.hiddenButton(3);
	itemGrid.hiddenButton(4);
