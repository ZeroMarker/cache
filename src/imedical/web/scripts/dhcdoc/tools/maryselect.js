(function($){
    $.fn.maryselect = function(options){
        if(typeof options == 'string'){
            var method = $.fn.maryselect.methods[options];
            if (method){
                arguments[0]=this;
                return method.apply(this,arguments);
            }
        }else{
            options = options || {};
            options=$.extend({}, $.fn.maryselect.defaults,options);
            return this.each(function(){
                $.data(this, 'maryselect',{options:options});
                $(this).maryselect('init');
            });
        }
        return this;
    }
    $.fn.maryselect.methods={
        options: function(jq){
            return $.data(jq[0],'maryselect').options;
        },
        init:function(jq){
            return jq.each(function(){
                var opts=$(this).maryselect('options');
                $(this).addClass('maryselect-f').maryselect('initEvent').maryselect('loadData',opts.data).maryselect('load');
            });
        },
        initEvent:function(jq){
            var opts=jq.maryselect('options');
            jq.change(function(e){
                var val=$(this).val();
                var row=jq.find("option[value='"+val+"']").data('row');
                var index=jq.find("option[value='"+val+"']").index();
                opts.onSelect.call(this,index,row);
            });
            return jq;
        },
        load:function(jq,param){
            param=param||{};
            return jq.each(function(){
                var target=this;
                var opts=$(target).maryselect('options');
                if(!opts.url) return true;
                var newParam={ ClassName:opts.ClassName,QueryName:opts.QueryName};
                if(opts.queryParams) newParam=$.extend({},opts.queryParams);
                $.extend(newParam,param);
                if(opts.onBeforeLoad.call(this,newParam)==false) return true;
                $.extend(newParam,param);
                if(!newParam.ClassName) return true;
                if(typeof websys_writeMWToken=='function') opts.url=websys_writeMWToken(opts.url);
                $.post(opts.url, newParam,function(data){
                    $(target).maryselect('loadData',data);
                }, "json");
            });
        },
        loadData:function(jq,data){
            return jq.each(function(){
                var target=this;
                var opts=$(target).maryselect('options');
                var newData=opts.loadFilter.call(target,data);
                if(typeof(newData)!='undefined') data=newData;
                var oldValue=$(target).val();
                $(target).empty();
                $.each(data,function(){
                    $(target).maryselect('appendRow',this);
                });
                opts.onLoadSuccess.call(target,data);
                if(oldValue!=undefined){
                    $(target).val(oldValue);
                    var row=$(target).find("option[value='"+oldValue+"']").data('row');
                    var index=$(target).find("option[value='"+oldValue+"']").index();
                    opts.onSelect.call(target,index,row);
                }
            });
        },
        appendRow:function(jq,row){
            row=row||{};
            return jq.each(function(){
                var oldValue=$(this).val();
                // if($(this).find("option[value='"+oldValue+"']").index()>-1){
                //     return true;
                // }
                var opts=$(this).maryselect('options');
                var value=row[opts.valueField],text=row[opts.textField];
                var $option=$('<option value="'+value+'">'+text+'</option>');
                if(value==oldValue){
                    $(this).find("option[value='"+value+"']").remove();
                    $option.attr('selected',true);
                }
                $.data($option[0],'row',row);
                $option.appendTo($(this));
            });
        },
        setValue:function(jq,val,text){
            if(typeof text=='undefined') text=val;
            return jq.each(function(){
                if(!$(this).find("option[value='"+val+"']").size()){
                    $('<option value="'+val+'">'+text+'</option>').prependTo($(this));
                }
                $(this).val(val);
            });
        },
        getValue:function(jq){
            return jq.val();
        },
        getText:function(jq){
            return jq.find('option[value="'+jq.val()+'"]').text();
        },
        disable:function(jq){
            return jq.attr("disabled","disabled");
        },
        enable:function(jq){
            return jq.removeAttr("disabled");
        },
        getData:function(jq){
            var rows=new Array();
            var opts=jq.maryselect('options');
            jq.find('option').each(function(){
                var row={};
                row[opts.valueField]=$(this).val();
                row[opts.textField]=$(this).text();
                rows.push(row);
            });
            return rows;
        }
    };
    $.fn.maryselect.defaults = {
        url:'DHCDoc.Util.QueryToJSON.cls?JSONTYPE=Combo',
        valueField:'id',
        textField:'text',
        queryParams:{},
        data:[],
        loadFilter:function(data){},
        onSelect:function(index,row){},
        onBeforeLoad:function(param){},
        onLoadSuccess:function(data){}
    };
    $.parser.plugins.push("maryselect");
})(jQuery);
