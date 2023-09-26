$.extend($.fn.datagrid.methods, {    
    gotoPage:function(jq,pgn)
    {
        return jq.each(function(){
            var _this=this;
            var page,cb;
            if(typeof pgn=="object"){
                page=pgn.page;
                cb=pgn.callback;
            }else{
                page=pgn;
            }
            $(_this).datagrid("options").pageNumber=page;
            $(_this).datagrid("getPager").pagination("refresh",{pageNumber:page});
            _bf(_this,null,function(){
                if(cb){
                    cb.call(_this,page);
                }
            });
        });
    },
    editCell: function(jq,param){
				return jq.each(function(){
					var opts = $(this).datagrid('options');
					var fields = $(this).datagrid('getColumnFields',true).concat($(this).datagrid('getColumnFields'));
					for(var i=0; i<fields.length; i++){
						var col = $(this).datagrid('getColumnOption', fields[i]);
						col.editor1 = col.editor;
						if (fields[i] != param.field){
							col.editor = null;
						}
					}
					$(this).datagrid('beginEdit', param.index);
					for(var i=0; i<fields.length; i++){
						var col = $(this).datagrid('getColumnOption', fields[i]);
						col.editor = col.editor1;
					}
				});
		}
});
function _bf(selector,params,cb){
    var opts=$.data(selector,"datagrid").options;
    if(params){
        opts.queryParams=params;
    }
    var _queryParams=$.extend({},opts.queryParams);
    if(opts.pagination){
        $.extend(_queryParams,{page:opts.pageNumber||1,rows:opts.pageSize});
    }
    if(opts.sortName){
        $.extend(_queryParams,{sort:opts.sortName,order:opts.sortOrder});
    }
    if(opts.onBeforeLoad.call(selector,_queryParams)==false){
        return;
    }
    $(selector).datagrid("loading");
    var _ret=opts.loader.call(selector,_queryParams,function(data){
        $(selector).datagrid("loaded");
        $(selector).datagrid("loadData",data);
        if(cb){
            cb();
        }
    },function(){
        $(selector).datagrid("loaded");
        opts.onLoadError.apply(selector,arguments);
    });
    if(_ret==false){
        $(selector).datagrid("loaded");
    }
};
