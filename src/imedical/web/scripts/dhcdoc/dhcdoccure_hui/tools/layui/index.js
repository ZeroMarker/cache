$(function(){
    $("#float-tool").on('click',function(){
        hideLeft();
    });
});
/**
 * 首页标识
 */
var drea_index_flag = "lang.zhou";

function hideLeft(){
    var o=$("#float-left");
    var o2=$("#right-body");
    if($(o).is(":visible")){
        o2.animate({left:0},100,function(){
            $(o).hide();
        });
        o.animate({width:0},100,function(){
            $(o).hide();
        });

    }else{
        o.animate({width:200},100,function(){
            $(o).show();
        });
        o2.animate({left:200},100,function(){
            $(o).show();
        });
        //o2.animate({left:80},140);

    }
    synTabScroll();
    /*var o=$("#iframeBox");
    var o2=$("#float-tool");
    if($(o).offset().left > 0){
        o.animate({width:$(window).width(),left:0},100);
    }else{
        o.animate({width:$(window).width()-80,left:80},100);

    }*/
}


var tbarBox=new Array();
var mx=0;
var my=0;
var defaultSetting = {
    title : '',
    url : '',
    canClose : true,
    ifHome : false,
    method : "POST",
    param : {},
};
window.getRootPath = function() {
    //获取当前网址，如： http://localhost:8088/test/test.jsp
    var curPath = window.document.location.href;
    //获取主机地址之后的目录，如： test/test.jsp
    var pathName = window.document.location.pathname;
    var pos = curPath.indexOf(pathName);
    //获取主机地址，如： http://localhost:8088
    var localhostPath = curPath.substring(0, pos);
    //获取带"/"的项目名，如：/test
    var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
    //return (localhostPath + projectName);//发布前用此
    return projectName;//发布前用此
};
function getTabLength(){
    var len = 0;
    for(var i=0;i<tbarBox.length;i++){
        var tab = tbarBox[i];
        var item = $("#tbarItem_" + tab.id);
        if(item.length > 0){
            len += item.width();
        }
    }
    return len;
}
function isTabOverFlow(){
    var nowLen = getTabLength();
    var max = $("#tbarBox").width();
    if(max < nowLen - 5){
        return true;
    }
    return false;
}
function synTabScroll(){
    setTimeout(function(){
        var nowLen = getTabLength();
        var max = $("#tbarBox").width();
        if(max < nowLen - 5){
            $("#scrollRightBtn").show();
            $("#scrollLeftBtn").show();
            $("#tbarBox").animate({
                scrollLeft: max - 60
            },100);
        }else{
            $("#scrollRightBtn").hide();
            $("#scrollLeftBtn").hide();
        }
    },80);
}
/*function addTbar(setting){

    setTimeout(function(){
        addTbarLater(setting);
    },200)
}*/
var addFlag = true;
function addTbar(setting){
    if(!addFlag){
        return;
    }
    addFlag = false;
    //防止暴力点击
    setTimeout(function(){
        addFlag = true;
    },800);
    var st = JSON.parse(JSON.stringify(defaultSetting));
    for(var k in setting){
        st[k] = setting[k];
    }
    if(StringUtil.isEmpty(st.url)){
        return;
    }
    if(tbarBox.length >= tabMaxnum){
        LAY_UTIL.alertMessage("打开的tab页超过最大上限"+tabMaxnum);
        return;
    }
    if($.isFunction(st.funcBefore)){
        st.funcBefore();
    }
    var id = 0;
    if(st.ifHome === undefined || !st.ifHome){
        id=makeId();
    }
    for(var i=0;i<tbarBox.length;i++){
        if(tbarBox[i].url==st.url){
            refreshTbar(tbarBox[i].id);
            return;
        }
    }
    var beforeClose = setting.beforeClose;
    if(st.param==null)st.param={};
    st.param['id']=id;
    var newTitle;
    if(st.clazz != undefined && st.clazz.length > 0){
        newTitle = "<i class='"+st.clazz+"' style='color:#aaa;line-height: 35px;font-size: 14px;margin-right:4px;'></i>" + st.title;
    }else{
        newTitle = st.title;
    }
    var html='<div class="tabr-item selected-tbar" id="tbarItem_'+id+'">'+
        '<div class="tbar-title" title="'+st.title+'" onclick="switchTbar('+id+')">'+newTitle+'</div>';
    html+='<div class="tbar-close"><a href="javascript:void(0)" onclick="closeTbar('+id+')">';
    if(st.canClose){
        html+="<i class='layui-icon layui-icon-close can-close'></i>";
    }else{
        html+='<i class="layui-icon layui-icon-password not-close" ></i>';
    }
    html+='</a></div></div>';
    tbarBox.push({id:id,url:st.url,param:st.param,locked:st.canClose?0:1,method:st.method,beforeClose:beforeClose});
    var obj=$(html);
    $("#tbarBox").append(obj);
    synTabScroll();
    addIframe(id,st.url,st.param,st.method);
    /*//双击table页全屏
    $(obj).on("dblclick",screen);*/
    switchTbar(id);
    $(obj).contextmenu({id:id},function(e){
        switchTbar(e.data.id);
        var tarObj = getTabrObjById(id);
        if(e.data.id == 0){
            $("#lockIt").hide();
            $("#closeNow").hide();
            $("#loveIt").hide();
        }else{
            $("#lockIt").show();
            $("#closeNow").show();
            $("#loveIt").show();
            if(tarObj != undefined){
                if(tarObj.locked ==0){
                    $("#contextmenu #lockIt").text("锁定");
                }else{
                    $("#contextmenu #lockIt").text("解锁");
                }
            }
        }

        mx=e.pageX;
        my=e.pageY;

        $("#contextmenu").css({
            top: my,
            left: mx
        }).show();
        /*$("#contextmenu #fullScreen").unbind("click");
        $("#contextmenu #fullScreen").click({id:id}, function(e) {
            screen(e.data.id);
        });*/
        $("#contextmenu #refresh").unbind("click");
        $("#contextmenu #refresh").click({id:id}, function(e) {
            refreshTbar(e.data.id);
        });
        $("#contextmenu #lockIt").unbind("click");
        $("#contextmenu #lockIt").click({id:id}, function(e) {
            lockedTabr(e.data.id);
        });
        $("#contextmenu #closeNow").unbind("click");
        $("#contextmenu #closeNow").click({id:id}, function(e) {
            closeTbar(e.data.id);
        });
        $("#contextmenu #closeOther").unbind("click");
        $("#contextmenu #closeOther").click({id:id}, function(e) {
            closeOtherTbar(e.data.id);
        });
        $("#contextmenu #closeAll").unbind("click");
        $("#contextmenu #closeAll").click({id:id}, function(e) {
            closeAllTbar();
        });
        $("#contextmenu #openInNewTab").unbind("click");
        $("#contextmenu #openInNewTab").click({id:id}, function(e) {
            openInNewTab(e.data.id);
        });
        return false;
    }).on("click", function() {
        $("#contextmenu").hide();
    });

}

function openInNewTab(id){
    for(var i=0;i<tbarBox.length;i++){
        var tab = tbarBox[i];
        if(tab.id===id ){
            var url = tab.url;
            var method = tab.method;
            var param = tab.param;
            if(!StringUtil.startWidth(url,"http")){
                if(!StringUtil.startWidth(url,"/")){
                    url = "/" + url;
                }
                var root = window.getRootPath();
                if(StringUtil.isEmpty(root)){
                    root = "/";
                }

                if(!StringUtil.startWidth(url,root)){
                    url = root+url;
                }
            }
            //closeTbar(id);
            //console.log(url);
            var form = $("<form></form>").attr("action", url).attr("method", method).attr("target","_blank");
            if(param!=null){
                for(var key in param){
                    //data+=key+"="+param[key]+"&";
                    var value=param[key];
                    if(typeof value =="object"){
                        value=JSON.stringify(value);
                    }
                    form.append($("<input/>").attr("type", "hidden").attr("name", key).attr("value", value));
                }
            }
            form.appendTo('body').submit().remove();
            return;
        }
    }
}
function lockedTabr(id){
    for(var i=1;i<tbarBox.length;i++){
        var tab = tbarBox[i];
        if(tab.id==id ){
            var o = $("#tbarItem_"+id+" .tbar-close i");
            if(tab.locked == 0){
                tab.locked =1;
                $(o).addClass("layui-icon-password");
                $(o).removeClass("layui-icon-close");
                $(o).addClass("not-close");
                $(o).removeClass("can-close");
            }else{
                tab.locked =0;
                $(o).removeClass("layui-icon-password");
                $(o).addClass("layui-icon-close");
                $(o).removeClass("not-close");
                $(o).addClass("can-close");
            }
            tbarBox.splice(i,1,tab);
            break;
        }
    }
}
function addIframe(id,url,param,method){
    if(!StringUtil.startWidth(url,"http:") && !StringUtil.startWidth(url,"https:")){
        if(url[0]!=='/'){
            url ="/" + url;
        }
        if(method === undefined){
            method = "POST";
        }
        //var data="?";
        if(url.indexOf("?") !== -1){
            var p = getUrlParam(url);
            for(var key in p){
                //data+=key+"="+param[key]+"&";
                var value=p[key];
                if(typeof value =="object"){
                    value=JSON.stringify(value);
                }
                param[key] = value;
            }
        }
        var root = window.getRootPath();

        if(StringUtil.isEmpty(root)){
            root = "/";
        }

        if(!StringUtil.startWidth(url,root)){
            url = root+url;
        }
    }
    var form = $("<form></form>").attr("action", url).attr("method", method).attr("target","iframe_"+id);
    if(param!=null){
        for(var key in param){
            //data+=key+"="+param[key]+"&";
            var value=param[key];
            if(typeof value =="object"){
                value=JSON.stringify(value);
            }
            form.append($("<input/>").attr("type", "hidden").attr("name", key).attr("value", value));
        }
    }
//        var end=data.charAt(data.length-1);
//        if(end=="&"|| end=="?"){
//            data=data.substring(0,data.length-1);
//        }
    $("#iframeBox").append('<iframe src="" id="iframe_'+id+'" name="iframe_'+id+
        '" style="width: 100%;height:100%;background: white" frameborder="0"></iframe>');
    form.appendTo('body').submit().remove();
}
/**
 * 切换到某一个tab
 * @param id
 */
function switchTbar(id){

    var s=false;
    for(var i=0;i<tbarBox.length;i++){
        if(tbarBox[i].id!=id){
            $("#tbarItem_"+tbarBox[i].id).removeClass("selected-tbar");
            hideIframe(tbarBox[i].id);
        }else{
            s=true;
        }
    }
    if(s){
        $("#tbarItem_"+id).addClass("selected-tbar");
        showIframe(id);
    }
}
/**
 * 生成id
 * @returns {number}
 */
function makeId(){
    return new Date().getTime();
}
function hideIframe(id){

    $("#iframe_"+id).attr("hidden","hidden");
}
function removeIframe(id){
    $("#iframe_"+id).remove();
}
function showIframe(id){
    $("#iframe_"+id).removeAttr("hidden");
}
/**
 *关闭某个tab
 * @param id
 * @param func：关闭前调用，返回true则不关闭
 */
function closeTbar(id,func){
    if($.isFunction(func)){
        var a=func();
        if(a)return;
    }
    for(var i=1;i<tbarBox.length;i++){
        var tab = tbarBox[i];
        if(tab.id==id && tab.locked == 0){
            var beforeClose =tab.beforeClose;
            if($.isFunction(beforeClose)){
                try{
                    beforeClose();
                }catch (e) {
                    console.error(e);
                }
            }
            $("#tbarItem_"+tab.id).remove();
            setTimeout(function(){
                if(isTabOverFlow()){
                    $("#scrollRightBtn").show();
                    $("#scrollLeftBtn").show();
                }else{
                    $("#scrollRightBtn").hide();
                    $("#scrollLeftBtn").hide();
                }
            },80);
            var s = $("#iframe_"+id).is(":visible");
            removeIframe(tab.id);
            tbarBox.splice(i,1);
            if(s){
                showOtherTbar();
            }
            break;
        }
    }

}
/**
 * 自动切换到上一个tab
 */
function showOtherTbar(){
    $(".tabr-item").removeClass("selected-tbar");
    $("#iframeBox").children('iframe').attr("hidden","hidden");
    showIframe(tbarBox[tbarBox.length-1].id);
    $("#tbarItem_"+tbarBox[tbarBox.length-1].id).addClass("selected-tbar");
}
function getTabrObjById(id){
    for(var i=1;i<tbarBox.length;i++){
        if(tbarBox[i].id==id){
            return tbarBox[i];
        }
    }
}
function refreshTbar(id){
    if($("#iframe_"+id).length>0){
        for(var i=0;i<tbarBox.length;i++){
            if(tbarBox[i].id==id){
                var url = tbarBox[i].url;
                var method = tbarBox[i].method;
                if(url[0] !=='/'){
                    url = '/' + url;
                }
                if(method === undefined){
                    method = "POST";
                }
                var form = $("<form></form>").attr("action", ctx + url).attr("method", method).attr("target","iframe_"+id);
                if(!isNull(tbarBox[i].param)){
                    for(var key in tbarBox[i].param){
                        var value=tbarBox[i].param[key];
                        if(typeof value =="object"){
                            value=JSON.stringify(value);
                        }
                        form.append($("<input/>").attr("type", "hidden").attr("name", key).attr("value", value));
                    }
                }
                form.appendTo('body').submit().remove();
                switchTbar(id);
                break;
            }
        }
    }

}
function closeNowTbar(beforeClose){
    if($.isFunction(beforeClose)){
        beforeClose();
    }
    var currId = undefined;
    var currIndex = undefined;
    for(var i=1;i<tbarBox.length;i++){
        var tab = tbarBox[i];
        if($("#tbarItem_"+tab.id).is(":visible")){
            currId = tab.id;
            currIndex = i;
            break;
        }
    }
    if(currId != undefined){
        $("#tbarItem_"+currId).remove();
        removeIframe(currId);
        tbarBox.splice(currIndex,1);
        showOtherTbar();
    }
}

/**
 * 关闭其它tab
 */
function closeOtherTbar(id){
    var toCloseId=new Array();
    for(var i=1;i<tbarBox.length;i++){
        var tab = tbarBox[i];
        if(tab.id!=id && tab.locked == 0){
            toCloseId.push(tbarBox[i].id);
        }
    }
    for(var i=0;i<toCloseId.length;i++){
        closeTbar(toCloseId[i]);
    }
}
/**
 * 关闭所有tab
 */
function closeAllTbar(){
    var toCloseId=new Array();
    for(var i=1;i<tbarBox.length;i++){
        toCloseId.push(tbarBox[i].id);
    }
    for(var i=0;i<toCloseId.length;i++){
        closeTbar(toCloseId[i]);
    }
}
//获取url中"?"符后的字符串
function getUrlParam(urlStr) {
    if (typeof urlStr == "undefined") {
        var url = decodeURI(location.search);
    } else {
        var url = "?" + urlStr.split("?")[1];
    }
    var theRequest = new Object();
    if (url.indexOf("?") != -1) {
        var str = url.substr(1);
        strs = str.split("&");
        for (var i = 0; i < strs.length; i++) {
            theRequest[strs[i].split("=")[0]] = decodeURI(strs[i].split("=")[1]);
        }
    }
    return theRequest;
}