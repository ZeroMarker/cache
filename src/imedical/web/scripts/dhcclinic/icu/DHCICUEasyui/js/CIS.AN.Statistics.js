/**
 * 报表查询条件
 * @param {object} opts 选项
 */
function StatQueryView(opts){
    this.options=opts;
}

StatQueryView.prototype={

}

function StatQueryItem(opts){
    this.options=opts;
}

StatQueryItem.prototype={
    init:function(){
        var _this=this;
        this.queryItemDetails=[{
            code:_this.options.code,
            descripiton:_this.options.description,
            control:{
                type:"hisui-combobox",
                options:{
                    
                }
            }
        }];
    }
}