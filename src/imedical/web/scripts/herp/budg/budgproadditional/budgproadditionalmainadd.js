addFun = function() {
	
	var userid = session['LOGON.USERID'];
	
///////////////////项目名称///////////////////////
	var projectname1Ds  = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});

	projectname1Ds.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		
			url:BudgProAdditionalUrl+'?action=projectnamelist&userid='+userid,method:'POST'});
			});

	var projectname1Field  = new Ext.form.ComboBox({
		id: 'projectname1Field',
		fieldLabel: '项目名称',
		width:150,
		listWidth : 250,
		store: projectname1Ds,
		anchor: '90%',
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择项目...',
		name: 'projectname1Field',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});

////////////////////资金来源类型  ///////////////////////// 
	var fundrestype1Store = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['1','财政资金'],['2','预算外资金'],['3','其他资金']]
	});
	var fundrestype1StoreField = new Ext.form.ComboBox({
		id: 'fundrestype1StoreField',
		fieldLabel: '资金来源类型',
		width:150,
		listWidth : 250,
		selectOnFocus: true,
		allowBlank: false,
		store:fundrestype1Store,
		anchor: '90%',
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		mode: 'local', // 本地模式
		editable:false,
		pageSize: 10,
		minChars: 15,
		selectOnFocus:true,
		forceSelection:true
	});  
	
	var parowid1Field = new Ext.form.NumberField({
		id: 'parowid1Field',
		fieldLabel: '调整序号',
		allowBlank:true,
		disabled:true,
		anchor: '90%'
	});
	
	var padesc1Field = new Ext.form.TextField({
		id: 'padesc1Field',
		fieldLabel: '预算调整说明',
		allowBlank: false,
		emptyText: '预算调整说明...',
		anchor: '90%'
	});
	
	var pabudgvaluebegin1Field = new Ext.form.NumberField({
		id: 'pabudgvaluebegin1Field',
		fieldLabel: '期初预算',
		allowBlank: true,
		disabled:true,
		anchor: '90%'
	});
	
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			projectname1Field,
			parowid1Field,
			padesc1Field,
			fundrestype1StoreField,
			pabudgvaluebegin1Field
		]
	});

  var window = new Ext.Window({
  	title: '预算追加添加',
    width: 400,
    height:300,
    minWidth: 400,
    minHeight: 300,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
    	text: '保存',
		handler: function() {
      		var projdr = projectname1Field.getValue();  // 项目ID
      		var adjdesc = encodeURIComponent(padesc1Field.getValue()); // 预算调整说明
      		var fundtype = fundrestype1StoreField.getValue(); // 资金来源类型
      		      					
      		adjdesc = adjdesc.trim();

      		if(projdr=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'项目名称不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		
      		var data='&projdr='+projdr+'&adjdesc='+adjdesc+'&fundtype='+fundtype;
      		
			Ext.Ajax.request({
					url: BudgProAdditionalUrl+'?action=add'+data+'&userid='+userid,
					failure: function(result, request) {
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		var apllycode = jsonData.info;
						  		Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						  		itemMain.load(({params:{start:0, limit:25, userid:userid}}));
									window.close();
								}
					},
					scope: this
						});
			window.close();
      		
	    	}
    	},
    	{
		text: '取消',
        handler: function(){window.close();}
      }]
    });

    window.show();
};