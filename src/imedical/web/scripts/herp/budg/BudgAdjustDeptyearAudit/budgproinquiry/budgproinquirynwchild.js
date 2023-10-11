ChildFun = function(name)
{	
	//��Ŀ״̬
	var stateStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['0','�½�'],['1','ִ��'],['2','���'],['3','ȡ��']]
	});
	var stateStoreField = new Ext.form.ComboBox({
		id: 'stateStoreField',
		fieldLabel: '��Ŀ״̬',
		width:120,
		listWidth : 215,
		selectOnFocus: true,
		allowBlank: false,
		store: stateStore,
		anchor: '90%',
		// value:'key', //Ĭ��ֵ
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		// emptyText:'ѡ��ģ������...',
		mode: 'local', // ����ģʽ
		editable:false,
		pageSize: 10,
		minChars: 15,
		selectOnFocus:true,
		forceSelection:true
	});
	
	//��Ŀ���� 
	var propertyStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['1','һ������Ŀ'],['2','������Ŀ'],['3','������Ŀ']]
	});
	var propertyStoreField = new Ext.form.ComboBox({
		id: 'propertyStoreField',
		fieldLabel: '��Ŀ����',
		width:120,
		listWidth : 215,
		selectOnFocus: true,
		allowBlank: false,
		store: stateStore,
		anchor: '90%',
		// value:'key', //Ĭ��ֵ
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		// emptyText:'ѡ��ģ������...',
		mode: 'local', // ����ģʽ
		editable:false,
		pageSize: 10,
		minChars: 15,
		selectOnFocus:true,
		forceSelection:true
	});
		
	//���Ƿ�״̬ 
	var whetherStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['0','��'],['1','��']]
	});
	var whetherStoreField = new Ext.form.ComboBox({
		id: 'whetherStoreField',
		fieldLabel: '�Ƿ�',
		width:120,
		listWidth : 215,
		selectOnFocus: true,
		allowBlank: false,
		store: stateStore,
		anchor: '90%',
		// value:'key', //Ĭ��ֵ
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		// emptyText:'ѡ��ģ������...',
		mode: 'local', // ����ģʽ
		editable:false,
		pageSize: 10,
		minChars: 15,
		selectOnFocus:true,
		forceSelection:true
	});
	
	var childGrid = new dhc.herp.Grid({
	    title: '��Ŀ��ϸ��Ϣ�� ',
	    width: 400,
	    // edit:false, //�Ƿ�ɱ༭
	    // readerModel:'local',
	    region: 'center',
	   //atLoad : true, // �Ƿ��Զ�ˢ��
	    url: 'herp.budg.budgproinquirynwchildexe.csp',
		
		
	    fields: [
	    {
	        id:'rowid',
	        header: 'ID',
	        dataIndex: 'rowid',
	        hidden: true
	    },{
	        id:'year',
	        header: '�������',
	        dataIndex: 'year',
	        width:75,
	        update:true,
	        allowBlank: true,
			editable:false
	    },{ 
	        id:'compdr',
	        header: 'ҽԺ����',
	        dataIndex: 'compdr',
	        width:100,
	        allowBlank: true,
			editable:false,
			hidden: false
	    }, {
	        id:'projcode',
	        header: '��Ŀ����',
	        width:100,
			//tip:true,
			//allowBlank: false,
	        editable:false,
	        allowBlank: true,
	        dataIndex: 'projcode'
			
	    }, {
	        id:'projname',
	        header: '��Ŀ����',
	        width:250,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'projname'
	    }, {
	        id:'spell',
	        header: 'ƴ����',
	        width:100,
			//tip:true,
			allowBlank: true,
			editable:false,
	        dataIndex: 'spell'
	    },{
	        id:'goal',
	        header: '��ĿĿ��',
	        width:150,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'goal'
	    }, {
	        id:'dutydr',
	        header: '��Ŀ������(��)',
	        width:100,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'dutydr',
	        hidden: true
	    }, {
	        id:'ssname',
	        header: '��Ŀ������',
	        width:100,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'ssname'
	    }, {
	        id:'start',
	        header: '����ʱ��',
	        width:150,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'start'
	    }, {
	        id:'deptdr',
	        header: '���ο���(��)',
	        width:100,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'deptdr',
	        hidden: true
	    }, {
	        id:'deptname',
	        header: '���ο���',
	        width:200,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'deptname'
	    }, {
	        id:'plansdate',
	        header: '�ƻ���ʼʱ��',
	        width:150,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'plansdate'
	    }, {
	        id:'planedate',
	        header: '�ƻ�����ʱ��',
	        width:150,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'planedate'
	    }, {
	        id:'realsdate',
	        header: 'ʵ�ʿ�ʼʱ��',
	        width:150,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'realsdate'
	    }, {
	        id:'realedate',
	        header: 'ʵ�ʽ���ʱ��',
	        width:150,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'realedate'
	    }, {
	        id:'state',
	        header: '��Ŀ״̬',
	        width:100,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'state',
	        type:stateStoreField
	    }, {
	        id:'propertyid',
	        header: '��Ŀ����',
	        width:150,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'propertyid',
	        type:propertyStoreField
	    }, {
	        id:'iscontinue',
	        header: '�Ƿ���������Ŀ',
	        width:100,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'iscontinue',
	        type:whetherStoreField
	    }, {
	        id:'isgovbuy',
	        header: '�Ƿ������Բɹ�',
	        width:100,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'isgovbuy',
	        type:whetherStoreField
	    }, {
	        id:'fundgov',
	        header: '����֧�����',
	        width:120,
	        align:'right',
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'fundgov'
	    }, {
	        id:'fundown',
	        header: '�Գ��ʽ�',
	        width:120,
	        align:'right',
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'fundown'
	    }, {
	        id:'fundtotal',
	        header: '��Ŀ��Ԥ��',
	        width:120,
	        align:'right',
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'fundtotal'
	    },  {
	        id:'reqmoney',
	        header: '�����ʽ��ܶ�',
	        width:120,
	        align:'right',
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'reqmoney'
	    }, {
	        id:'actpaywait',
	        header: '��;������',
	        width:120,
	        align:'right',
			//tip:true,
			allowBlank: true,
			editable:false,
	        dataIndex: 'actpaywait'
	    },  {
	        id:'actpaymoney',
	        header: '��ִ��Ԥ��',
	        width:120,
	        align:'right',
			//tip:true,
			allowBlank: true,
			editable:false,
	        dataIndex: 'actpaymoney'
			
	    },{
	    	id:'alertpercent',
	        header: 'ִ��Ԥ���ٷֱ�',
	        width:100,
	        align:'right',
		    //tip:true,
		    allowBlank: true,
		    editable:false,
	        dataIndex: 'alertpercent'
	    },{
	    	id:'filedesc',
	        header: '����',
	        width:100,
		    //tip:true,
		    allowBlank: true,
		    editable:false,
	        dataIndex: 'filedesc'
	    }
		]

	});
	childGrid.load(({params:{start:0, limit:25,name:name}}));
	
	
	
	// ��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({
				text : '�ر�'
			});

	// ����ȡ����ť����Ӧ����
	cancelHandler = function() {
		window.close();
	}
	// ���ȡ����ť�ļ����¼�
	cancelButton.addListener('click', cancelHandler, false);
	// ��ʼ�����
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [childGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				plain : true,
				width : 1000,
				height : 500,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
	
	
	childGrid.btnAddHide();  //�������Ӱ�ť
	childGrid.btnSaveHide();  //���ر��水ť
	childGrid.btnResetHide();  //�������ð�ť
	childGrid.btnDeleteHide(); //����ɾ����ť
	childGrid.btnPrintHide();  //���ش�ӡ��ť
	

};