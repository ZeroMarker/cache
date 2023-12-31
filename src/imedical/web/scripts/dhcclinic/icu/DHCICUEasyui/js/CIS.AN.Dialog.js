function ANDialog(opts){
    this.options=$.extend(opts,{});
    this.init();
}

ANDialog.prototype={
    /**
     * 签名面板初始化
     */
    init:function(){ 
        this.dom=$("<div></div>").appendTo("body");
        this.initDialog();
    },

    /**
     * 初始化签名对话框
     */
    initDialog:function(){
        var _this=this;
        var selectedData=_this.options.appData;
        var csp=_this.options.csp;
        var queryString=_this.options.queryString;
        if(!queryString) queryString="";
        if(!selectedData){
            selectedData={
                OPSID:"",
                EpisodeID:"",
                PatientID:"",
                MRAdmID:"",
                OPAID:""
            };
        }
        var url=csp;
        if(!_this.options.queryParams){
            url=csp+"?opsId="+selectedData.OPSID+"&EpisodeID="+selectedData.EpisodeID+"&PatientID="+selectedData.PatientID+"&MRAdmID="+selectedData.MRAdmID+"&OPAID="+selectedData.OPAID+queryString;
        }
        var href="<iframe scrolling='yes' frameborder='0' src='" + url + "' style='width:100%;height:100%'></iframe>";
        this.dom.dialog({
            title:_this.options.title,
            width:_this.options.width,
            height:_this.options.height,
            content:href,
            closed:true,
            modal:true,
            iconCls:_this.options.iconCls,
            onOpen:function(){
                if(_this.options.openCallBack)
                    _this.options.openCallBack();
            },
            onClose:function(){
                if(_this.options.closeCallBack)
                    _this.options.closeCallBack();
                if(_this.dom){
                    _this.dom.remove();
                }
            }
        });

    },

    open:function(){
        this.dom.dialog("open");
    },

    close:function(){
        this.dom.dialog("close");
    }
}
