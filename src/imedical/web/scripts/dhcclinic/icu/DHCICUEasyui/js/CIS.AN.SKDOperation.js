function SKDOperation(opts){
    this.options=$.extend({
        width:600,
        height:400
    },opts);
    this.init();
}

SKDOperation.prototype={
    init:function(){
        this.dom=$("<div style='padding:10px 10px 0 10px;'></div>").appendTo("body");
        this.initDialog();
    },

    initDialog:function(){
        var _this=this;
        var href="dhc.bdp.sds.structoperation.csp?ADMNo="+_this.options.EpisodeID+"&PMINo="+_this.options.RegNo+"&AnaestOperationId=";
        _this.dom.dialog({
            title:"选择手术",
            width:this.options.width,
            height:this.options.height,
            closed:true,
            modal:true,
            iconCls:"icon-edit",
            content:"<iframe scrolling='yes' frameborder='0' src='" + href + "' style='width:100%;height:100%'></iframe>"
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