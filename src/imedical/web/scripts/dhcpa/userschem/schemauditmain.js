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
			//var rowid = rowObj[0].get("rowid");
		}
		function handler(id){
			if(id=="yes"){
			for(var i = 0; i < len; i++){
			rowid = rowObj[i].get("rowid");
				Ext.Ajax.request({
					url: '../csp/dhc.pa.userschemauditexe.csp?action=del&rowid='+rowid,
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
		}
		Ext.MessageBox.confirm('提示','确实要删除目标记录吗?',handler);
	}
	})

var addButton = new Ext.Toolbar.Button({
	text: '增加',
    tooltip:'增加',        
    iconCls:'add',
	handler:function(){
			
			addFun();
	}
});	

	
var valid=new Ext.form.Checkbox({
			fieldLabel:'是否有效',
			//editable:false,
			width:30
			});			
			
		
var itemGrid = new Dhc.ca.Grid({
        title: '方案权限设置',
        width: 400,
        //edit:false,                   //是否可编辑
        //readerModel:'local',
        region: 'center',
        url: 'dhc.pa.userschemauditexe.csp',
		tbar:[addButton,'-',delButton],
		//atLoad:false,
        fields: [
		new Ext.grid.CheckboxSelectionModel({editable:false}),
		{
            header: 'ID',
            dataIndex: 'rowid',
			editable:false,
            hidden: true
        }, {
            header: '用户名称',
			calunit:true,
			allowBlank: false,
			editable:false,
			width:200,
            dataIndex: 'user'
        }, {
            header: '方案名称',
			calunit:true,
			allowBlank: false,
			editable:false,
			width:200,
            dataIndex: 'schem'
        }]
    
    });
	


	