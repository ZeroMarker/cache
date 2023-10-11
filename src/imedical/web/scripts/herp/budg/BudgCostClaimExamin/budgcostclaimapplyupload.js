//创建图片浏览窗口(弹出)
payuploadFun = function CreatePicWin(rowid)
{
    //初始化取消按钮
    var delButton = new Ext.Toolbar.Button({
        text:'删除图片',
        handler:function()
        {
           
            var rowObj = PicGrid.getSelectionModel().getSelected(); 
            if(Ext.isEmpty(rowObj))
            {
	            Ext.Msg.show({title : 'error',msg : '请选择要删除的图片!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
            	return;
            }
            var rowid = rowObj.get('rowid');
            var code=rowObj.get('code');
            var picsrc = rowObj.get('picname');
       
             Ext.MessageBox.confirm('提示','确定要删除选定图片?',
                    function(btn) {
                        if(btn == 'yes'){
                            var mask = Ext.Msg.show({title : "图片处理",msg : "'数据正在处理中...",width : 300,wait : true,closable : true});
                            Ext.Ajax.request({
                                url:'herp.budg.costclaimapplyexe.csp?action=DeletePic&rowid='+rowid+'&picsrc='+picsrc,
                                waitMsg:'删除中...',
                                failure: function(result, request) {
                                     mask.hide();
                                    Msg.info("error", "请检查网络连接!");
                                },
                                success: function(result, request) {
                                    var jsonData = Ext.util.JSON.decode( result.responseText );
                                     mask.hide();
                                    
                                     PicStore.load({params:{rowid:rowid}})
                                    if (jsonData.success=='true') {
                                        Ext.Msg.show({
											title : '注意',
											msg : '操作成功!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO
										});
                                       
                                    }else{
	                                    var message = "错误";
										message = "SQLErr: " + jsonData.info+"删除失败";
										Ext.Msg.show({
											title : '错误',
											msg : message,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
                                    }
                                },
                                scope: this
                            });
                        }
                    }
                )
              
        }
    });
    var PicUrl = 'herp.budg.costclaimapplyexe.csp?action=GetPic&rowid='+rowid;
    // 通过AJAX方式调用后台数据
    var proxy = new Ext.data.HttpProxy({
                url : PicUrl,
                method : "POST"
            });
    // 指定列参数 code _"^"_name
    var fields = ["rowid", "code","name", "picname"];
    //alert(fields);
    // 支持分页显示的读取方式
    var reader = new Ext.data.JsonReader({
                root : 'rows',
                totalProperty : "results",
                fields : fields
            });
    // 数据集
    var PicStore = new Ext.data.Store({
                proxy : proxy,
                reader : reader
            });
	
    var sm = new Ext.grid.RowSelectionModel({singleSelect:true});
    var nm = new Ext.grid.RowNumberer();
    
    var PicCm = new Ext.grid.ColumnModel([nm,{
                header : "rowid",
                dataIndex : 'rowid',
                width : 80,
                align : 'left',
                hidden:true,
                sortable : true
            }, {
                header : "报销单号",
                dataIndex : 'code',
                width : 80,
                align : 'left',
                hidden:true,
                sortable : true
            },{
                header : '报销说明',
                dataIndex : 'name',
                width : 200,
                align : 'left',
                sortable : true
            }, {
                header : "图片名称",
                dataIndex : 'picname',
                width : 200,
                align : 'left',
                sortable : true
            }
])
 
    var PicGrid = new Ext.grid.GridPanel({
                cm : PicCm,
                store : PicStore,
                trackMouseOver : true,
                stripeRows : true,
                sm : sm, 
                tbar:[delButton],   
                loadMask : true
            });
     var panel = new Ext.Panel({
        title:'图片信息',
        region:'center',
        layout:'fit',
        items:[PicGrid]                                 
     });
    
    var reportPanel=new Ext.Panel({
        title:'附件图片显示',
        region:'east',
        width:'600',
        html:'<img id="frameReport" height="100%" width="100%" frameborder=0 src=""/>'
    }) 
    
    var picindow = new Ext.Window({
                title : '单据信息',
                width : 1000,
                height : 500,
                layout:'border',
                plain : true,
                modal : true,
                items:[panel,reportPanel]
            });
    
    picindow.show();
    PicStore.load({params:{rowid:rowid}})
    var reportFrame=document.getElementById("frameReport");
    reportFrame.src="../scripts/herp/budg/common/img/uploadblack.jpg";
    var src="http://192.168.0.114/myftp/BUDGUPLOAD/";    //图片路径
    PicGrid.on('rowclick',function(g,rowindex,e){
    	var rowdata=PicGrid.getStore().getAt(rowindex);
        var picsrc=rowdata.get('picname');
        reportFrame.src=src+picsrc;
        //alert(reportFrame.src);
    })
}
