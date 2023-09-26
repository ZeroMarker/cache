//添加，删除公用的组件

	//检查点combox
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
	//TODO:模糊查询未处理
	//console.log(Ext.getCmp('checkField').getRawValue());
	});
	
	var checkCom = new Ext.form.ComboBox({
		id: 'checkField',
		fieldLabel: '检查点',
		width:230,
		height:100,
		listWidth :230,
        allowBlank: false,
		store: checkDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择检查点...',
		name: 'checkField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true,
		resizable:true
	}); 
	
	
	var coefficientFiled =new Ext.form.Field({
		fieldLabel:"特殊值",
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
		fieldLabel:"特殊值：",
		id:"coefficient2",
		inputType:'text',
		
		width:100	
	});
	//特殊值公式下拉框
	//数据
	var comData = [
		['1','等于','='],['2','大于','>'],['3','小于','<'],
		['3','大于等于','>='],['4','小于等于','<='],['5','包含','like'],
		['6','区间','between']
	];
	//装备数据
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
		fieldLabel: '表达式',
		width:113,
		listWidth : 113,
        allowBlank: false,
		store: comStore,
		valueField: 'comCode',
		displayField: 'comDes',
		triggerAction: 'all',
		emptyText:'请选择检查点...',
		name: 'comField',
		minChars: 1,
		editable:true,
		resizable:true
	}); 
	//取消按钮
	var cancleBtn = new Ext.Button({
		text:'取消',
		//iconCls:'',
		handler:function(){
			addWin.close();
		}
	});

