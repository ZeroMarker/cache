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

var isPhoto = new Ext.data.SimpleStore({
	fields:['key','Value'],
	data:[['Y','是'],['N','否']]
})

var photoField = new Ext.form.ComboBox({
	id: 'photoField',
	//fieldLabel: '是否拍照',
	width:100,
	listWidth : 130,
	selectOnFocus: true,
	store: isPhoto,
	valueNotFoundText:'',
	displayField: 'Value',
	valueField: 'key',
	triggerAction: 'all',
	mode: 'local', //本地模式
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true
})
var isSpecial = new Ext.data.SimpleStore({
	fields:['key','Value'],
	data:[['Y','是'],['N','否']]
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
	mode: 'local', //本地模式
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true
})

var objectType = new Ext.data.SimpleStore({
	fields:['key','Value'],
	data:[['1','科室'],['2','病人']]
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
	mode: 'local', //本地模式
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true
})


var checklocType = new Ext.data.SimpleStore({
	fields:['key','Value'],
	data:[['1','扣选择科室'],['2','扣列表科室']]
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
	mode: 'local', //本地模式
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true
})

var checkcolType = new Ext.data.SimpleStore({
	fields:['key','Value'],
	data:[['1','录入'],['2','采集'],['3','计算'],['4','Excel导入']]
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
	mode: 'local', //本地模式
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true
})

var checkAccesType = new Ext.data.SimpleStore({
	fields:['key','Value'],
	data:[['1','选项'],['2','文本']]
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
	mode: 'local', //本地模式
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true
})

var IsdriectField = new Ext.form.Checkbox({
						fieldLabel : '是否'
});


var compField = new Ext.form.ComboBox({
	id: 'compField',
	fieldLabel: '是否',
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


var itemGrid = new dhc.herp.Grid({
        title: '检查点维护',
        width: 400,
        //edit:true,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'dhc.qm.checkexe.csp',	  
		atLoad : true, // 是否自动刷新
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
		     header: '代码',
		    // allowBlank: false,
		     width:80,
		     editable:true,
		     dataIndex: 'code',
			 type:'text'
		}, {
		     id:'name',
		     header: '名称',
		     allowBlank: false,
		     width:150,
		     editable:true,
		     dataIndex: 'name'
		}, {
		     id:'loctype',
		     header: '检查类型',
		     allowBlank: false,
		     width:70,
		     editable:true,
		     dataIndex: 'loctype',
			 align:'center',
		     type:checklocTypeField
		}, {
		     id:'coltype',
		     header: '收集方式',
		     allowBlank: false,
		     width:70,
		     editable:true,
		     dataIndex: 'coltype',
			 align:'center',
		     type:checkcolTypeField
		}, {
		     id:'assesstype',
		     header: '考核类型',
		     allowBlank: false,
		     width:70,
		     editable:true,
		     dataIndex: 'assesstype',
			 align:'center',
		     type:checkAccesTypeField
		}, {
		     id:'desc',
		     header: '描述',
		     //allowBlank: false,
		     width:200,
		     editable:true,
		     dataIndex: 'desc'
		}, {
		     id:'active',
		     header: '是否有效',
		     allowBlank: false,
		     width:70,
		     editable:true,
			 align:'center',
		     dataIndex: 'active',
		     type:activeField
		}, {
		     id:'photo',
		     header: '是否拍照',
		     allowBlank: false,
		     width:70,
		     editable:true,
		     dataIndex: 'photo',
			 align:'center',
		     type:photoField
		     
		}, {
		     id:'spcil',
		     header: '特殊标示',
		     //allowBlank: false,
		     width:70,
		     editable:true,
		     dataIndex: 'spcil',
			 align:'center',
		     type:specialField
		}, {
		     id:'objecttype',
		     header: '检查对象类型',
		     allowBlank: false,
		     width:85,
		     editable:true,
		     dataIndex: 'objecttype',
			 align:'center',
		     type:objectTypeField
		     
		}, {
		     id:'comp',
		     header: '是否参与考核',
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
	
	
