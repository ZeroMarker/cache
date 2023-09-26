var isActive = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['Y','是'],['N','否']]
});
var activeField = new Ext.form.ComboBox({
	id: 'activeField',
	fieldLabel: '是否有效',
	width:100,
	listWidth : 130,
	selectOnFocus: true,
	//allowBlank: false,
	store: isActive,
	//anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'选择期间类型...',
	mode: 'local', //本地模式
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true
});

var IsdriectField = new Ext.form.Checkbox({
						fieldLabel : '是否'
});

var itemGrid = new dhc.herp.Grid({
        title: '检查点维护',
        width: 400,
        edit:true,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'dhc.qm.patshowexe.csp',	  
		atLoad : true, // 是否自动刷新
		loadmask:true,
        fields: [{

			 id:'rowid',
		     header: 'ID',
		     //allowBlank: false,
		     width:100,
		     editable:true,
		     hidden:true,
		     dataIndex: 'rowid'
		}, {
		     id:'code',
		     header: '显示代码',
		     allowBlank: false,
		     width:100,
		     editable:true,
		     dataIndex: 'code'
		}, {
		     id:'name',
		     header: '显示名称',
		     allowBlank: false,
		     width:100,
		     editable:true,
		     dataIndex: 'name'
		}, {
		     id:'desc',
		     header: '描述',
		     //allowBlank: false,
		     width:100,
		     editable:true,
		     dataIndex: 'desc'
		}, {
		     id:'active',
		     header: '是否有效',
		     //allowBlank: false,
		     width:100,
		     editable:true,
		     dataIndex: 'active',
		     type:activeField
		}]
});

    itemGrid.hiddenButton(3);
    itemGrid.hiddenButton(4);
