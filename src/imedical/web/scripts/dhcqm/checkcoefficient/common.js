//��ӣ�ɾ�����õ����

	//����combox
	var checkDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},[
		'rowid','code','name'
		])
	});

	checkDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:CheckCoefficientTabUrl+'?action=listcheckname&str='+Ext.getCmp('checkField').getRawValue(),method:'POST'})
	//TODO:ģ����ѯδ����
	//console.log(Ext.getCmp('checkField').getRawValue());
	});
	
	var checkCom = new Ext.form.ComboBox({
		id: 'checkField',
		fieldLabel: '����',
		width:230,
		height:100,
		listWidth :230,
        allowBlank: false,
		store: checkDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'��ѡ�����...',
		name: 'checkField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true,
		resizable:true
	}); 
	
	
	var coefficientFiled =new Ext.form.Field({
		fieldLabel:"����ֵ",
		id:"coefficient",
		inputType:'text',
		width:100	
	});
	var betweenAnd = new Ext.form.DisplayField({			
			id:'and',
			style:'padding-top:3px;',
			value: '&nbsp;&nbsp;and&nbsp;&nbsp;'
				
		});
	var coefficientFiled2 =new Ext.form.Field({
		fieldLabel:"����ֵ��",
		id:"coefficient2",
		inputType:'text',
		
		width:100	
	});
	//����ֵ��ʽ������
	//����
	var comData = [
		['1','����','='],['2','����','>'],['3','С��','<'],
		['3','���ڵ���','>='],['4','С�ڵ���','<='],['5','����','like'],
		['6','����','between']
	];
	//װ������
	var comStore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(comData),
		reader: new Ext.data.ArrayReader({},[
			{name:'comID'},
			{name:'comDes'},
			{name:'comCode'}
		])	
	});
	var com = new Ext.form.ComboBox({
		id: 'comField',
		fieldLabel: '���ʽ',
		width:113,
		listWidth : 113,
        allowBlank: false,
		store: comStore,
		valueField: 'comCode',
		displayField: 'comDes',
		triggerAction: 'all',
		emptyText:'��ѡ�����...',
		name: 'comField',
		minChars: 1,
		editable:true,
		resizable:true
	}); 
	//ȡ����ť
	var cancleBtn = new Ext.Button({
		text:'ȡ��',
		//iconCls:'',
		handler:function(){
			addWin.close();
		}
	});

