var isActive = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['Y','��'],['N','��']]
});
var activeField = new Ext.form.ComboBox({
	id: 'activeField',
	fieldLabel: '�Ƿ���Ч',
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
	emptyText:'ѡ���ڼ�����...',
	mode: 'local', //����ģʽ
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true
});

var IsdriectField = new Ext.form.Checkbox({
						fieldLabel : '�Ƿ�'
});

var itemGrid = new dhc.herp.Grid({
        title: '����ά��',
        width: 400,
        edit:true,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'dhc.qm.patshowexe.csp',	  
		atLoad : true, // �Ƿ��Զ�ˢ��
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
		     header: '��ʾ����',
		     allowBlank: false,
		     width:100,
		     editable:true,
		     dataIndex: 'code'
		}, {
		     id:'name',
		     header: '��ʾ����',
		     allowBlank: false,
		     width:100,
		     editable:true,
		     dataIndex: 'name'
		}, {
		     id:'desc',
		     header: '����',
		     //allowBlank: false,
		     width:100,
		     editable:true,
		     dataIndex: 'desc'
		}, {
		     id:'active',
		     header: '�Ƿ���Ч',
		     //allowBlank: false,
		     width:100,
		     editable:true,
		     dataIndex: 'active',
		     type:activeField
		}]
});

    itemGrid.hiddenButton(3);
    itemGrid.hiddenButton(4);
