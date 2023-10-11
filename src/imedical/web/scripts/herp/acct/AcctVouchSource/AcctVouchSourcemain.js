
var delButton = new Ext.Toolbar.Button({
	text: '删除',
    tooltip:'删除',        
    //iconCls:'remove',
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
		function handler(id){
			if(id=="yes"){
				Ext.Ajax.request({
					url:'../csp/herp.acct.vouchsourceexe.csp?action=del&rowid='+rowid,
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
							Ext.Msg.show({title:'错误',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			
			}
		}
		Ext.MessageBox.confirm('提示','确实要删除目标记录吗?',handler);
	}
	});
		
var itemGrid = new dhc.herp.Grid({
        title: '凭证来源',
        width: 400,
		iconCls:'find',
        edit:false,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'herp.acct.vouchsourceexe.csp',	  
		//tbar:delButton,
		    atLoad : true, // 是否自动刷新
		    loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			editable:false,
            hidden: true,
            print:false
        },{
        	  id:'code',
              header: '凭证来源编码',
			  allowBlank: false,
			  width:150,
              dataIndex: 'code'
        },{
            id:'name',
            header: '凭证来源名称',
			      allowBlank: false,
			      width:200,
            dataIndex: 'name'
        }]
});
	itemGrid.hiddenButton(0);
	itemGrid.hiddenButton(1);
	itemGrid.hiddenButton(2);	
	itemGrid.hiddenButton(3);
	itemGrid.hiddenButton(4);