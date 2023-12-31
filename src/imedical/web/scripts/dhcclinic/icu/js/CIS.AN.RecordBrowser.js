function RecordBrowser(opts){
    this.options=$.extend({
        width:1280,
        height:800
    },opts);
    this.init();
}

RecordBrowser.prototype={
    /**
     * 编辑器初始化
     */
    init:function(){
        
        this.dom=$("<div style='padding:10px 10px 0 10px;'></div>").appendTo("body");
        this.initDialog();
    },

    /**
     * 初始化对话框
     */
    initDialog:function(){
        var _this=this;
        this.dom.dialog({
            title:"病历浏览-"+_this.options.title,
            width:this.options.width,
            height:this.options.height,
            closed:true,
            modal:true,
            iconCls:"icon-edit",
            content:"<iframe scrolling='yes' frameborder='0' src='" + this.options.href + "' style='width:100%;height:100%'></iframe>",
            buttons:[{
                text:"退出",
                iconCls:"icon-w-cancel",
                handler:function(){
                    _this.exit();
                }
            }],
            onOpen:function(){
                
            },
            onClose:function(){
                
            }
        });
    },

    /**
     * 退出
     */
    exit:function(){
        this.close();
    },

    /**
     * 打开对话框
     */
    open:function(){
        this.dom.dialog("open");
    },

    /**
     * 关闭对话框
     */
    close:function(){
        this.dom.dialog("close");
    }
}