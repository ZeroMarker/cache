
var delButton = new Ext.Toolbar.Button({
	text: '删除',
    tooltip:'删除',        
    iconCls:'remove',
    handler:function() {
    // get the selected items
    //定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
		if (Ext.isEmpty(rowid)) {
			itemGrid.store.remove(rowObj);
			return;
		}
		function handler(id){
			if(id=="yes"){
				Ext.Ajax.request({
					url:'../csp/herp.acct.acctcurexe.csp?action=del&rowid='+rowid,
					waitMsg:'审核中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGrid.load();
						}else{
							Ext.Msg.show({title:'错误',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			
			}
		}
		Ext.MessageBox.confirm('提示','确实要删除目标记录吗?',handler);
	}
	});


//是否本位币

var monthField = new Ext.form.ComboBox({
	id: 'monthField',
	fieldLabel: '会计期间',
	width:200,
	listWidth : 60,
	allowBlank: false,
	store: [['0', '否'], ['1', '是']],
	triggerAction: 'all',
	emptyText:'请选择会计期间..',
	name: 'monthField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


 var itemGrid = new dhc.herp.Grid({
        title: '货币维护',
        width: 400,
		iconCls:'maintain',
        //edit:false,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'herp.acct.acctcurexe.csp',	  
		atLoad : true, // 是否自动刷新
		loadmask:true,
 fields: [
       {
            id:'acctCurID',
            header: '<div style="text-align:center">币种ID</div>',
            editable:true,
	    	allowBlank: true,
	    	width:130,
            dataIndex: 'rowid',
			align:'center',
            hidden: true,
            print:false
        },{
            id:'currCode',
            header: '<div style="text-align:center">币种编码</div>',
	  		calunit:true,
			//align:'center',
	  		allowBlank: false,
			width:100,
            dataIndex: 'currCode'	  
        },{
            id:'currName',
            header: '<div style="text-align:center">币种名称</div>',
			editable:true,
			allowBlank: false,
			width:150,
            //align:'center',
            dataIndex: 'currName'
       
        },{
            id:'isSelf',
            header: '<div style="text-align:center">是否本位币</div>',
			editable:true,
			allowBlank: true,
			width:90,
            dataIndex: 'isSelf',
            align:'center',
            type:monthField
        }]
     
});
                                                                                                                              
	itemGrid.addButton(delButton);
	itemGrid.hiddenButton(2);
	itemGrid.hiddenButton(3);
	itemGrid.hiddenButton(4);





