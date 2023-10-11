editFun = function() {
	
	var userid = session['LOGON.USERID'];
	
	var rowObj=itemMain.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	//判断是否选择了要修改的数据
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
		}
	else{
		var rowid = rowObj[0].get("rowid");
	    var tmppafundrestype =rowObj[0].get("pafundrestype");
	    var tmpparowid =rowObj[0].get("parowid");
	    var tmppadesc =rowObj[0].get("padesc");
	    var tmppabudgvaluebegin =rowObj[0].get("pabudgvaluebegin");
	    }
	
//////////////////// 项目名称 //////////////////////
	var projectname2Ds  = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});

	projectname2Ds.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		
			url:BudgProAdditionalUrl+'?action=projectnamelist&userid='+userid,method:'POST'});
			});

	var projectname2Field  = new Ext.form.ComboBox({
		id: 'projectname2Field',
		fieldLabel: '项目名称',
		width:150,
		listWidth : 250,
		store: projectname2Ds,
		anchor: '90%',
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择项目...',
		name: 'projectname2Field',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true,
		valueNotFoundText:rowObj[0].get("projectcode")
	});
	
	projectname2Field.on('select',function(combo, record, index){
		rowid= combo.getValue();
	});
	
////////////////// 调整序号   //////////////////////////////	
	var parowid2Field = new Ext.form.NumberField({
		id: 'parowid2Field',
		fieldLabel: '调整序号',
		allowBlank:true,
		disabled:true,
		anchor: '90%',
		valueNotFoundText:rowObj[0].get("parowid")
	});
	
////////////////// 预算调整说明   //////////////////////////////
	
	var padesc2Field = new Ext.form.TextField({
		id: 'padesc2Field',
		fieldLabel: '预算调整说明',
		allowBlank: false,
		emptyText: '预算调整说明...',
		anchor: '90%',
		valueNotFoundText:rowObj[0].get("padesc")
	});

	
////////////////// 资金来源类型   //////////////////////////////
	var fundrestype2Store = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['1','财政资金'],['2','预算外资金'],['3','其他资金']]
	});
	var fundrestype2StoreField = new Ext.form.ComboBox({
		id: 'fundrestype2StoreField',
		fieldLabel: '资金来源类型',
		width:150,
		listWidth : 250,
		selectOnFocus: true,
		allowBlank: false,
		store:fundrestype2Store,
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
		forceSelection:true,
		valueNotFoundText:rowObj[0].get("pafundrestype")
	});  
	
	fundrestype2StoreField.on('select',function(combo, record, index){
		tmppafundrestype = combo.getValue();
	});
	
////////////////// 期初预算   //////////////////////////////
	var pabudgvaluebegin2Field = new Ext.form.NumberField({
		id: 'pabudgvaluebegin2Field',
		fieldLabel: '期初预算',
		allowBlank: true,
		disabled:true,
		anchor: '90%',
		valueNotFoundText:rowObj[0].get("pabudgvaluebegin")
	});
	

	
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			projectname2Field,
			parowid2Field,
			padesc2Field,
			fundrestype2StoreField,
			pabudgvaluebegin2Field
		]
	});

//面板加载
  formPanel.on('afterlayout', function(panel, layout) {                                                                                           //
	this.getForm().loadRecord(rowObj[0]); 
	    
	projectname2Field.setValue(rowObj[0].get("projname"));
	parowid2Field.setValue(rowObj[0].get("parowid"));	
	padesc2Field.setValue(rowObj[0].get("padesc"));
	fundrestype2StoreField.setValue(rowObj[0].get("pafundrestype"));	
	pabudgvaluebegin2Field.setValue(rowObj[0].get("pabudgvaluebegin1"));                                                                                              //
                                                                                                                    //
  });   
  
  var window = new Ext.Window({
  	title: '预算追加修改',
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
    	text: '修改',
		handler: function() {
    		var projdr = rowid; // 项目ID
    		var parowid = parowid2Field.getValue(); // 调整序号 项目预算主表ID
      		var adjdesc = padesc2Field.getValue(); //预算调整说明
      		var fundtype = tmppafundrestype;  // 资金来源类型
      		
      		
      		//alert(projdr+","+parowid+","+adjdesc+","+fundtype)
      		
      		if(projdr=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'项目名称不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		
      		var data='&projdr='+projdr+'&parowid='+parowid+'&adjdesc='+encodeURIComponent(adjdesc)+"&fundtype="+fundtype;
			
			Ext.Ajax.request({
					url: BudgProAdditionalUrl+'?action=edit'+data,
					failure: function(result, request) {
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						  		itemMain.load({params:{start:0, limit:25,userid:userid}});
									window.close();
								}
					},
					 scope: this
						});
	    	}
    	},
    	{
				text: '取消',
        handler: function(){window.close();}
      }]
    });

    window.show();
};