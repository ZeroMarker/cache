function accessoryFun()
{
	var form = new Ext.form.FormPanel({
        baseCls: 'x-plain',
        labelWidth: 80,
        url:'upload.php',
        fileUpload:true,
        defaultType: 'textfield',

        items: [{
            xtype: 'textfield',
            fieldLabel: '文件名',
            name: 'userfile',
            inputType: 'file',
            allowBlank: false,
            blankText: 'File can\'t not empty.',
            anchor: '90%'  // anchor width by percentage
        }]
    });

    var win = new Ext.Window({
        title: '上传附件',
        width: 400,
        height:200,
        minWidth: 300,
        minHeight: 100,
        layout: 'fit',
        plain:true,
        bodyStyle:'padding:5px;',
        buttonAlign:'center',
        items: form,

        buttons: [{
            text: '上传',
            handler: function() {
                if(form.form.isValid()){
                    Ext.MessageBox.show({
                           title: '请稍等',
                           msg: '上传中...',
                           progressText: '',
                           width:300,
                           progress:true,
                           closable:false,
                           animEl: 'loding'
                       });
                    form.getForm().submit({    
                        success: function(form, action){
                           Ext.Msg.alert('Message from extjs.org.cn',action.result.msg);
                           win.hide();  
                        },    
                       failure: function(){    
                          Ext.Msg.alert('Error', 'File upload failure.');    
                       }
                    })               
                }
           }
        },{
            text: '取消上传',
            handler:function(){win.hide();}
        }]
    });
    win.show();

}
var accessoryButton = new Ext.Toolbar.Button({
	text: '附件',
    tooltip:'附件',        
    iconCls:'add',
	handler:function(){
	accessoryFun();
	}
	
});
