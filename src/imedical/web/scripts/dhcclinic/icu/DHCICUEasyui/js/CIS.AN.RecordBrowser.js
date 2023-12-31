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
        
        this.dom=$("<div></div>").appendTo("body");
        this.initDialog();
    },

    /**
     * 初始化对话框
     */
    initDialog:function(){
        var _this=this;
		var url = "../service/dhcanop/lib/pdfjs/web/viewer.html?file=" + encodeURIComponent(this.options.href);
        var content = '<iframe src=" '+ url +' " style="width:100%; height:100%;" frameborder="0"></iframe> ';
		if(!!window.ActiveXObject || "ActiveXObject" in window){//IE浏览器
			content = "<iframe scrolling='yes' frameborder='0' src='" + this.options.href + "' style='width:100%;height:100%'></iframe>";
		}
        this.dom.dialog({
            title:"病历浏览-"+_this.options.title,
            width:this.options.width,
            height:this.options.height,
            closed:true,
            modal:true,
            iconCls:"icon-edit",
            content: content,
            // buttons:[{
            //     text:"退出",
            //     iconCls:"icon-w-cancel",
            //     handler:function(){
            //         _this.exit();
            //     }
            // }],
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