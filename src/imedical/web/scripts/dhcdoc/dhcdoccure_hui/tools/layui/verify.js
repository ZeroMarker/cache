var VERY = {};
VERY.map={};
var defaultVerify = {
    //验证不为空
    'required':function(a){
        return StringUtil.isNotEmpty(a);
    },
    //验证整型
    'integer':function(a){
        return new RegExp("^\\d+$").test(a);
    },
    //验证整型，可为空
    'integer_empty':function(a){
        return !(defaultVerify['required'])(a) || (defaultVerify['integer'])(a);
    },
    'number':function(a){
        return new RegExp("^[-+]?\\d+([\\.]\\d+)?$").test(a);
    },
    'number_empty':function(a){
        return !(defaultVerify['required'])(a) || (defaultVerify['number'])(a);
    },
    'email':function(a){
        return new RegExp("^\\w+([-\\.]\\w+)*@\\w+([-\\.]\\w+)*\\.\\w+([-\\.]\\w+)*$").test(a);
    },
    'email_empty':function(a){
        return !(defaultVerify['required'])(a) || (defaultVerify['email'])(a);
    },
    'phone':function(a){
        return new RegExp("(^1[34578]\\d{9}$)|(^09\\d{8}$)").test(a);
    },
    'phone_empty':function(a){
        return !(defaultVerify['required'])(a) || (defaultVerify['phone'])(a);
    },
};
var exitErrorMode = function(){
    $(this).removeClass("drea-verify-error");
};
VERY.init = function(formId){
    $(formId).children().find("[drea-verify]").bind("blur",function(){
        var dm = VERY.verifyOne(formId,this);
        if(dm.status !== true){
            $(this).addClass("drea-verify-error");
        }
    }).bind("mousemove",function (e) {
        $(this).trigger("drea-verify-event",[e]);
    }).bind("mouseout",function (e) {
        $(formId+"_div").hide();
    }).bind("focus",function (e) {
        $(formId+"_div").hide();
    }).bind("input",function (e) {
        $(formId+"_div").hide();
    });
    var id = formId;
    if(StringUtil.startWidth(id,"#")){
        id = formId.substring(1);
    }
    $("body").append("<div class='drea-verify-error-div' id='"+id+"_div'></div>");
};

VERY.verify = function(formId){
    var $select = $(formId).children().find("[drea-verify]");
    var tips = [];
    var res = true;
    for(var i=0;i<$select.length;i++){
        var obj = $select[i];
        var dm = VERY.verifyOne(formId,obj);

        if(dm.status !== true){
            res = false;
            if(!ArrayUtil.contain(tips,dm.msg)){
                tips.push(dm.msg);
            }
        }
    }
    if(tips.length > 0){
        //window.showDreaTip(ArrayUtil.join(tips,"<br>"),"danger",4000);
    }
    return res;
    /*each(function(i,obj){

    });*/
};
VERY.verifyOne = function(formId,obj){
    var status = true;
    var verify = $(obj).attr('drea-verify');
    var tip = $(obj).attr('drea-tip');
    var value = $(obj).trim_val();
    if(StringUtil.isEmpty(verify)){
        verify = 'required';
    }

    var func ;
    var def = "";
    if($.isFunction(defaultVerify[verify])){
        func = defaultVerify[verify];
    }else {
        var vrs = VERY.map[formId];
        func = vrs[verify];
    }
    if($.isFunction(func)){
        try{
            status = func(value);
            if(status === false){
                def = StringUtil.nvl(tip,"输入不能为空！");
            }else if(status !== true){
                def = status;
            }
        }catch (e) {
            console.log(e);
        }
    }

    if(status !== true){
        //console.log(def);
        $(obj).addClass("drea-verify-error");


        //$(obj).focus();
        $(obj).bind("input",exitErrorMode);
        $(obj).bind("focus",exitErrorMode);
        $(obj).bind("drea-verify-event",function(e1,e){
            //$("#form_"+formId+"_div").show().css();
            var x = e.offsetX + $(obj).offset().left + 15;
            var y = e.offsetY + $(obj).offset().top - 20;
            //console.log(e.offsetX,e.offsetY,$(obj).offset().left,$(obj).offset().top,x,y);
            $(formId+"_div").text(def).css({left:x,top:y}).show();
        });

    }else{
        $(obj).unbind("drea-verify-event");
        $(formId+"_div").hide();
    }
    return {status:status,msg:def};
};
/**
 * 注册自定义验证方法
 */
VERY.addVerify = function(formId,vrs){
    if(VERY.map[formId] === undefined){
        VERY.map[formId] = {};
    }
    for(var key in vrs){
        VERY.map[formId][key]=vrs[key];
        $(formId).children().find("[drea-verify='"+key+"']").bind("blur",function(){
            var dm = VERY.verifyOne(formId,this);
            if(dm.status !== true){
                $(this).addClass("drea-verify-error");
            }
        });
    }

};
$(function(){

    $("form[drea-form]").each(function(){
        var id = $(this).attr('id');
        if(StringUtil.isNotEmpty(id)){
            VERY.init("#"+id);
        }
    })
});


