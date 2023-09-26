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

var isPhoto = new Ext.data.SimpleStore({
	fields:['key','Value'],
	data:[['Y','��'],['N','��']]
})

var photoField = new Ext.form.ComboBox({
	id: 'photoField',
	//fieldLabel: '�Ƿ�����',
	width:100,
	listWidth : 130,
	selectOnFocus: true,
	store: isPhoto,
	valueNotFoundText:'',
	displayField: 'Value',
	valueField: 'key',
	triggerAction: 'all',
	mode: 'local', //����ģʽ
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true
})
var isSpecial = new Ext.data.SimpleStore({
	fields:['key','Value'],
	data:[['Y','��'],['N','��']]
})

var specialField = new Ext.form.ComboBox({
	id: 'specialField',
	fieldLabel: '',
	width:100,
	listWidth : 130,
	selectOnFocus: true,
	store: isSpecial,
	valueNotFoundText:'',
	displayField: 'Value',
	valueField: 'key',
	triggerAction: 'all',
	mode: 'local', //����ģʽ
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true
})

var objectType = new Ext.data.SimpleStore({
	fields:['key','Value'],
	data:[['1','����'],['2','����']]
})

var objectTypeField = new Ext.form.ComboBox({
	id: 'objectTypeField',
	fieldLabel: '',
	width:100,
	listWidth : 130,
	selectOnFocus: true,
	store: objectType,
	valueNotFoundText:'',
	displayField: 'Value',
	valueField: 'key',
	triggerAction: 'all',
	mode: 'local', //����ģʽ
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true
})


var checklocType = new Ext.data.SimpleStore({
	fields:['key','Value'],
	data:[['1','��ѡ�����'],['2','���б����']]
})

var checklocTypeField = new Ext.form.ComboBox({
	id: 'checklocTypeField',
	fieldLabel: '',
	width:100,
	listWidth : 130,
	selectOnFocus: true,
	store: checklocType,
	valueNotFoundText:'',
	displayField: 'Value',
	valueField: 'key',
	triggerAction: 'all',
	mode: 'local', //����ģʽ
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true
})

var checkcolType = new Ext.data.SimpleStore({
	fields:['key','Value'],
	data:[['1','¼��'],['2','�ɼ�'],['3','����'],['4','Excel����']]
})

var checkcolTypeField = new Ext.form.ComboBox({
	id: 'checkcolTypeField',
	fieldLabel: '',
	width:100,
	listWidth : 130,
	selectOnFocus: true,
	store: checkcolType,
	valueNotFoundText:'',
	displayField: 'Value',
	valueField: 'key',
	triggerAction: 'all',
	mode: 'local', //����ģʽ
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true
})

var checkAccesType = new Ext.data.SimpleStore({
	fields:['key','Value'],
	data:[['1','ѡ��'],['2','�ı�']]
})

var checkAccesTypeField = new Ext.form.ComboBox({
	id: 'checkAccesTypeField',
	fieldLabel: '',
	width:100,
	listWidth : 130,
	selectOnFocus: true,
	store: checkAccesType,
	valueNotFoundText:'',
	displayField: 'Value',
	valueField: 'key',
	triggerAction: 'all',
	mode: 'local', //����ģʽ
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true
})

var IsdriectField = new Ext.form.Checkbox({
						fieldLabel : '�Ƿ�'
});


var compField = new Ext.form.ComboBox({
	id: 'compField',
	fieldLabel: '�Ƿ�',
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


var itemGrid = new dhc.herp.Grid({
        title: '����ά��',
        width: 400,
        //edit:true,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'dhc.qm.checkexe.csp',	  
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
		autoExpandColumn:'desc',
        fields: [{

			 id:'rowid',
		     header: 'ID',
		     //allowBlank: false,
		     hidden:true,
		     width:100,
		     editable:true,
		     dataIndex: 'rowid'
		}, {
		     id:'code',
		     header: '����',
		    // allowBlank: false,
		     width:80,
		     editable:true,
		     dataIndex: 'code',
			 type:'text'
		}, {
		     id:'name',
		     header: '����',
		     allowBlank: false,
		     width:150,
		     editable:true,
		     dataIndex: 'name'
		}, {
		     id:'loctype',
		     header: '�������',
		     allowBlank: false,
		     width:70,
		     editable:true,
		     dataIndex: 'loctype',
			 align:'center',
		     type:checklocTypeField
		}, {
		     id:'coltype',
		     header: '�ռ���ʽ',
		     allowBlank: false,
		     width:70,
		     editable:true,
		     dataIndex: 'coltype',
			 align:'center',
		     type:checkcolTypeField
		}, {
		     id:'assesstype',
		     header: '��������',
		     allowBlank: false,
		     width:70,
		     editable:true,
		     dataIndex: 'assesstype',
			 align:'center',
		     type:checkAccesTypeField
		}, {
		     id:'desc',
		     header: '����',
		     //allowBlank: false,
		     width:200,
		     editable:true,
		     dataIndex: 'desc'
		}, {
		     id:'active',
		     header: '�Ƿ���Ч',
		     allowBlank: false,
		     width:70,
		     editable:true,
			 align:'center',
		     dataIndex: 'active',
		     type:activeField
		}, {
		     id:'photo',
		     header: '�Ƿ�����',
		     allowBlank: false,
		     width:70,
		     editable:true,
		     dataIndex: 'photo',
			 align:'center',
		     type:photoField
		     
		}, {
		     id:'spcil',
		     header: '�����ʾ',
		     //allowBlank: false,
		     width:70,
		     editable:true,
		     dataIndex: 'spcil',
			 align:'center',
		     type:specialField
		}, {
		     id:'objecttype',
		     header: '����������',
		     allowBlank: false,
		     width:85,
		     editable:true,
		     dataIndex: 'objecttype',
			 align:'center',
		     type:objectTypeField
		     
		}, {
		     id:'comp',
		     header: '�Ƿ���뿼��',
		     allowBlank: false,
		     width:85,
		     editable:true,
		     dataIndex: 'comp',
			 align:'center',
		     type:compField
		     
		}]
});
	itemGrid.hiddenButton(2);
    itemGrid.hiddenButton(3);
    itemGrid.hiddenButton(4);
	
	
