function Reason(opts){
    this.options=$.extend(opts,{width:240,height:260});
    this.init();
}

Reason.prototype={
    init:function(){
        this.dom=$("<div></div>").appendTo("body");
        var formArr=[
            "<form id='reasonForm'>",
                "<div>",
                    "<div class='form-row'>",
                        "<div class='form-title-normal'>选择</div>",
                        "<div class='form-item-normal'>",
                            "<select id='reasonOptions' class='hisui-combobox'></select>",
                        "</div>",
                    "</div>",
                "</div>",
                "<div>",
                    "<div class='form-row'>",
                        "<div class='form-title-normal'>原因</div>",
                        "<div class='form-item-normal'>",
                            "<textarea id='reason' class='textbox' style='width:173px;height:120px'></textarea>",
                        "</div>",
                    "</div>",
                "</div>",
            "</form>"
        ];

        $(formArr.join("")).appendTo(this.dom);

        this.initDialog();
        this.initForm();
    },

    initDialog:function(){
        var _this=this;
        this.dom.dialog({
            title:this.options.title,
            iconCls:"icon-paper",
            width:this.options.width,
            height:this.options.height,
            modal:true,
            buttons:[{
                iconCls:"icon-w-ok",
                text:"确定",
                handler:function(){
                    _this.options.reasonHandle($("#reason").val());
                    _this.close();
                }
            },{
                iconCls:"icon-w-cancel",
                text:"取消",
                handler:function(){
                    $("#reasonForm").form("clear");
                    _this.close();
                }
            }],
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

    initForm:function(){
        $("#reasonOptions").combobox({
            valueField:"RowId",
            textField:"Description",
            url:ANCSP.DataQuery,
            onBeforeLoad:function(param){
                param.ClassName=ANCLS.BLL.CodeQueries;
                param.QueryName="FindReason",
                param.Arg1="C";
                param.ArgCnt=1;
            },
            editable:false,
            onSelect:function(record){
                var curReason=$("#reason").val();
                if(record && record.Description){
                    if(curReason) curReason+="；";
                    $("#reason").val(curReason+record.Description);
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