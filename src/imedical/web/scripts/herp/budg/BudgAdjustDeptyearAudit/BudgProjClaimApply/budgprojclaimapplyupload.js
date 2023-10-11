//����ͼƬ�������(����)
projpayuploadFun = function CreatePicWin(rowid)
{
    //��ʼ��ȡ����ť
    var delButton = new Ext.Toolbar.Button({
        text:'ɾ��ͼƬ',
        handler:function()
        {
           
            var rowObj = PicGrid.getSelectionModel().getSelected(); 
            if(Ext.isEmpty(rowObj))
            {
            Ext.Msg.show({title : 'error',msg : '��ѡ��Ҫɾ����ͼƬ!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
            return;
            }
            var rowid = rowObj.get('rowid');
            var code=rowObj.get('code');
            var picsrc = rowObj.get('picsrc');
             Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ��ͼƬ?',
                    function(btn) {
                        if(btn == 'yes'){
                            var mask = Ext.Msg.show({title : "ͼƬ����",msg : "'�������ڴ�����...",width : 300,wait : true,closable : true});
                            Ext.Ajax.request({
                                url:'herp.budg.budgprojclaimapplydetailexe.csp?action=DeletePic&rowid='+rowid+'&picsrc='+picsrc,
                                waitMsg:'ɾ����...',
                                failure: function(result, request) {
                                     mask.hide();
                                    Msg.info("error", "������������!");
                                },
                                success: function(result, request) {
                                    var jsonData = Ext.util.JSON.decode( result.responseText );
                                     mask.hide();
                                    
                                     PicStore.load({params:{rowid:rowid}})
                                    if (jsonData.success=='true') {
                                        Ext.Msg.show({
											title : 'ע��',
											msg : '�����ɹ�!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO
										});
                                       
                                    }else{
	                                    var message = "����";
										message = "SQLErr: " + jsonData.info+"ɾ��ʧ��";
										Ext.Msg.show({
											title : '����',
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
    var PicUrl = 'herp.budg.budgprojclaimapplydetailexe.csp?action=GetPic&rowid='+rowid;
    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
                url : PicUrl,
                method : "POST"
            });
    // ָ���в��� code _"^"_name
    var fields = ["rowid", "code","name", "picsrc"];
    // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
    var reader = new Ext.data.JsonReader({
                root : 'rows',
                totalProperty : "results",
                id : "rowid",
                fields : fields
            });
    // ���ݼ�
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
                header : "���ݱ��",
                dataIndex : 'code',
                width : 80,
                align : 'left',
                hidden:true,
                sortable : true
            },{
                header : '��������',
                dataIndex : 'name',
                width : 200,
                align : 'left',
                sortable : true
            }, {
                header : "ͼƬ����",
                dataIndex : 'picsrc',
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
        title:'ͼƬ��Ϣ',
        region:'center',
        layout:'fit',
        items:[PicGrid]                                 
     });
    
    var reportPanel=new Ext.Panel({
        title:'����ͼƬ��ʾ',
        region:'east',
        width:'600',
        html:'<img id="frameReport" height="100%" width="100%" frameborder=0 src=""/>'
    }) 
    
    var picindow = new Ext.Window({
                title : '������Ϣ',
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
    reportFrame.src="../scripts/herp/budg/common/img/uploadblack.jpg"
    var  src="http://127.0.0.1/ftpdir/BUDGUPLOAD/"    //ͼƬ·��
    PicGrid.on('rowclick',function(g,rowindex,e){
    var rowdata=PicGrid.getStore().getAt(rowindex)
        var picsrc=rowdata.get('picsrc')
        reportFrame.src=src+picsrc
    })
}
