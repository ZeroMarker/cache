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
			fieldLabel : '�û�',
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
        // title: 'ҵ��ϵͳģ��ά��',
        width: 400,
        //edit:false,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'herp.acct.sysbusimoduleexe.csp',	  
		//tbar:delButton,
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'code',
            header: '<div style="text-align:center">ģ�����</div>',
			allowBlank: false,
			width:200,
            dataIndex: 'code'
        },{
            id:'name',
            header: '<div style="text-align:center">ģ������</div>',
			allowBlank: false,
			width:200,
            dataIndex: 'name'
        },{
            id:'SysBusinessID',
            header: '<div style="text-align:center">ϵͳ����</div>',
			width:200,
            dataIndex: 'SysBusinessID',
            hidden: false,
            type:SysBusinessCombo
        }] 
});

    itemGrid.hiddenButton(3);
	itemGrid.hiddenButton(4);
