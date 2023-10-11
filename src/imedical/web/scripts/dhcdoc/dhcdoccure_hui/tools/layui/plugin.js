var LAY_UTIL = {};
LAY_UTIL.lay_table = {};
/**
 * 表格默认配置
 * @type {{request: {limitName: string, pageName: string}, methods: string, page: boolean, limits: number[], height: number}}
 */
LAY_UTIL.tableDefaultSetting = {
    height: 450,
    page: true,
    methods:"post",
    limits:[10,20,50,100,200,300],
    request:{
        pageName: 'pageNum',
        limitName: 'pageSize'
    },
};
/**
 * 初始化一个表格
 * @param oldSet
 */
LAY_UTIL.loadTable = function(oldSet){
    var id = "table_"+new Date().getTime();
    //表格的jquery选择器表达式
    var $select = oldSet.$select;
    var $obj;
    if(($obj = $($select+"")).length === 0){
        return;
    }
    //拷贝表格默认配置
    var set = JSON.parse(JSON.stringify(LAY_UTIL.tableDefaultSetting));
    for(var k in oldSet){
        set[k] = oldSet[k];
    }
    //通过table的lay-filter属性绑定各种事件
    var layFilter = $obj.attr("lay-filter");

    var column = set.column;
    //获得表格查询参数的方法
    var getQueryParameter = set.getQueryParameter;
    //获取查询参数，如果是函数，调用函数
    var queryParameter = getQueryParameter;
    if($.isFunction(getQueryParameter)){
        queryParameter = getQueryParameter();
    }
    //查询按钮绑定事件
    var queryBtn = set.queryBtn;
    //return false不查询
    var beforeQuery = set.beforeQuery;
    set.id = id;
    var rowEvents = set.rowEvents;
    var toolbarEvents = set.toolbarEvents;

    set.elem=$select;
    set.cols=column;
    set.where = queryParameter;
    //选中行的背景色
    var selectColor = StringUtil.nvl(set.selectColor,"#dfd");
    //定义表格加载失败的回调事件
    set.error = function(data){
        //console.log(data);
        showRequestError(data,'',data);
    };
    var showTool = StringUtil.nvl(set.showTool,true);
    if(showTool){
        set.defaultToolbar=['filter', 'exports', 'print', {
            title: '提示'
            ,layEvent: 'LAYTABLE_TIPS'
            ,icon: 'layui-icon-tips'
        }];
    }
    layui.use('table', function(){
        layui.table.render(set);
        //绑定操作按钮事件
        if(layFilter != null && layFilter.length > 0){
            if(rowEvents !== undefined){
                //绑定行操作按钮事件
                layui.table.on('tool('+layFilter+')', function(obj){
                    //var data = obj.data;
                    for(var eventName in rowEvents){
                        var func = rowEvents[eventName];
                        if(obj.event === eventName && $.isFunction(func)){
                            func(obj.data);
                            break;
                        }
                    }
                });
            }
            if(toolbarEvents !== undefined){
                //绑定工具栏按钮事件
                layui.table.on('toolbar('+layFilter+')', function(obj){
                    //var data = obj.data;
                    //获取选中的数据
                    var checkStatus = layui.table.checkStatus(obj.config.id);
                    var data = checkStatus.data;
                    for(var eventName in toolbarEvents){
                        var func = toolbarEvents[eventName];
                        if(obj.event === eventName && $.isFunction(func)){
                            func(data,checkStatus.isAll);
                            break;
                        }
                    }
                });
            }
            layui.table.on('row('+layFilter+')', function(obj){
                $(".layui-table-body tr ").css("background","#FFFFFF");
                //修改选中的tr颜色
                $(obj.tr).css("background",selectColor);

            });
        }


    });
    //保存表格配置
    LAY_UTIL.lay_table[$select] = set;
    var $queryBtn ;
    if(queryBtn !== undefined && ($queryBtn = $(queryBtn+"")).length > 0){
        $queryBtn.bind('click',function(){
            var b = true;
            if($.isFunction(beforeQuery)){
                b = beforeQuery();
            }
            if(b !== false){
                LAY_UTIL.refreshTable($select);
            }
        });
    }

};
LAY_UTIL.loadStaticTable = function(set){
    var id = "table_"+new Date().getTime();
    //表格的jquery选择器表达式
    var $select = set.$select;
    var $obj = $($select);
    if($obj.length === 0){
        return;
    }
    var layFilter = $obj.attr("lay-filter");
    var rowEvents = set.rowEvents;
    set.id = id;
    set.elem = $select;
    set.cols=set.column;
    var showTool = StringUtil.nvl(set.showTool,true);
    if(showTool){
        set.defaultToolbar=['filter', 'exports', 'print', {
            title: '提示'
            ,layEvent: 'LAYTABLE_TIPS'
            ,icon: 'layui-icon-tips'
        }];
    }
    layui.use('table', function(){
        layui.table.render(set);
        if(layFilter != null && layFilter.length > 0){
            if(rowEvents !== undefined){
                layui.table.on('tool('+layFilter+')', function(obj){
                    //var data = obj.data;
                    for(var eventName in rowEvents){
                        var func = rowEvents[eventName];
                        if(obj.event === eventName && $.isFunction(func)){
                            func(obj.data);
                            break;
                        }
                    }
                });
            }
        }


    });

};
/**
 * 刷新表格
 * @param $select
 */
LAY_UTIL.refreshTable = function($select){
    var set = LAY_UTIL.lay_table[$select];
    if(set === undefined){
        return;
    }
    var getQueryParameter = set.getQueryParameter;
    var queryParameter = getQueryParameter;
    //获取查询参数
    if($.isFunction(getQueryParameter)){
        queryParameter = getQueryParameter();
    }
    var id =set.id;
    layui.table.reload(id,{
        url: set.url,
        request:{
            pageName: 'pageNum',
            limitName: 'pageSize'
        },
        where: queryParameter,
        page: {
            //返回第一页
            curr: 1
        }
    });
};
//启用layer弹出层
layui.use('layer');
LAY_UTIL.init = function(){
    if(layui.layer=== undefined){
        layui.use('layer');
    }
};
function findDreaIndex(w,id){
    try{
        if(w === undefined){
            w = window;
        }
        if(id === undefined){
            id = w.dreaFrame.id;
        }
        if(w.drea_index_flag !== undefined){

            return {w:w,id:id};
        }
        if(w === w.top){
            return null;
        }
        return findDreaIndex(w.parent,id);
    }catch (e) {
        return null;
    }
}
/**
 * 自定义弹出提示框
 * @param content   内容
 * @param title     标题
 * @param func      回调
 */
LAY_UTIL.alertMessage = function(content,title,func,height,width){
    var id = "id_"+new Date().getTime();
    //var a1 = {'info':'black','warn':'yellow','error':'red'};
    //var a2 = {'info':'提示','warn':'警告','error':'错误'};
    title = StringUtil.nvl(title,'提示');
    content = StringUtil.nvl(content,"");
    height = StringUtil.nvl(height,"180px");
    width = StringUtil.nvl(width,"360px");
    var contentTag = new Tag("div").attr('class','alert-title');
    contentTag.append(content);
    try{
        var w = findDreaIndex();
        if(w !== null && w.id !== undefined){
            w.w.switchTbar(w.id);
        }
    }catch (e) {
        //
    }
    setTimeout(function(){
        var index = layui.layer.open({
            //0（信息框，默认）1（页面层）2（iframe层）3（加载层）4（tips层）
            type: 1,
            id: id,
            //自定义皮肤
            skin:'alertUI-skin',
            title: "<div class='alert-content'>"+title+"</div>",
            area: [width, height],
            content: contentTag.toString(),
            btn: ['确定'],
            success: function(layero, index){

            },cancel:function(){
                if($.isFunction(func)){
                    func();
                }
            },btn1:function(){
                if($.isFunction(func)){
                    func();
                }
                layui.layer.close(index);
            }
        });
    },50);

};
/**
 * 弹出一个带表单的弹窗
 * @param set
 * @returns {s.index}
 */
LAY_UTIL.alertUI = function(set){
    if(set === undefined){
        set = {};
    }
    var id = set.id;
    if(StringUtil.isEmpty(id)){
        id = "id_"+new Date().getTime();
    }
    var title = StringUtil.nvl(set.title,'提示');
    var width = StringUtil.nvl(set.width,'360px');
    var height = StringUtil.nvl(set.height,'460px');
    var autoResetForm = StringUtil.nvl(set.autoResetForm,true);
    //支持传入一组数据
    var rowData = set.rowData;
    //上述数据data中的key与form表单中的dom元素id进行映射，实现打开弹窗自动填充，无特殊逻辑时可以使用
    var formIds = set.domMapping;
    //填充方式为val、html或者text
    var fillType = set.fillType;
    //弹窗前的执行
    var beforeAlert = set.beforeAlert;
    //弹窗目标
    var $select = set.$select;
    var target;
    if(typeof $select ==="string"){
        target = $($select)
    }else{
        target = $select;
    }

    if(StringUtil.isEmpty($select) || target.length === 0){
        return;
    }
    //按钮组的事件绑定
    var btns = set.btns;
    var btnArray = [];
    var callbackMap = {};
    var closeBtn = set.closeBtn;
    if(btns !== undefined){
        for(var i=0;i<btns.length;i++){
            var btnObj = btns[i];
            for(var n in btnObj){
                btnArray.push(n);
                callbackMap['btn'+(i+1)] = btnObj[n];
                break;
            }
        }
    }
    var fst = {
        type: 1,
        id: id,
        skin:'alertUI-skin',
        title: title === false ? false : "<div class='alert-content'>"+title+"</div>",
        area: [width, height],
        content: target
    };
    //添加取消按钮
    if(closeBtn !== false && closeBtn !== 0){
        btnArray.push("取消");
        callbackMap['btn'+(btnArray.length+1)] = function(index,o){
            layui.layer.close(index);
        };
    }
    if(closeBtn !== undefined){
        fst.closeBtn = closeBtn;
    }
    fst.btn = btnArray;
    for(var na in callbackMap){
        var func = callbackMap[na];
        if($.isFunction(func)){
            fst[na] = func;
        }

    }
    if($.isFunction(beforeAlert)){
        beforeAlert();
    }
    var form = target.find("form").eq(0);
    if(form != null && form.length > 0){
        form.children().find("[drea-verify]").removeClass("drea-verify-error").unbind("drea-verify-event");
        //重置form表单
        if(autoResetForm && !$.isFunction(beforeAlert)){
            form.reset_form();
        }
        if(formIds !== undefined && rowData !== undefined){
            for(var cn in formIds){
                var columnName = cn;
                var domId = formIds[cn];
                var obj = form.find("#"+domId).eq(0);
                if(fillType === 'text'){
                    obj.text(StringUtil.safeToString(rowData[columnName],''));
                }else if(fillType === 'html'){
                    obj.html(StringUtil.safeToString(rowData[columnName],''));
                }else{
                    obj.val(StringUtil.safeToString(rowData[columnName],''));
                }

            }
        }
    }
    layui.form.render();
    return layui.layer.open(fst);
};
/**
 * 弹出一个确认框
 * @param content   内容
 * @param title     标题
 * @param funOK     确定回调
 * @param funcNo    取消回调
 */
LAY_UTIL.confirmMessage = function(content,title,funOK,funcNo,height,width){
    var id = "id_"+new Date().getTime();
    title = StringUtil.nvl(title,'提示');
    content = StringUtil.nvl(content,"确定要执行此操作吗？");
    height = StringUtil.nvl(height,"160px");
    width = StringUtil.nvl(width,"300px");
    var contentTag = new Tag("div").attr('class','alert-title');
    contentTag.append(content);
    try{

        var w = findDreaIndex();
        if(w !== null && w.id !== undefined){
            w.w.switchTbar(w.id);
        }
    }catch (e) {
        //
    }
    setTimeout(function(){
        layui.layer.confirm(content, {
            id: id,
            skin:'alertUI-skin',
            title: "<div class='alert-content'>"+title+"</div>",
            area: [width, height],
            btn: ['确定', '取消'],
            btn1: function(index, layero){
                if($.isFunction(funOK)){
                    funOK();
                }
                layui.layer.close(index);
            },
            btn2: function(index, layero){
                if($.isFunction(funcNo)){
                    funcNo();
                }
            }
        });
    },50);

};
/**
 * 显示遮罩
 * @returns {*}
 */
LAY_UTIL.showMask2 = function(){

    return layui.layer.load({
        shade: [0.3, '#fff']
    });

};
LAY_UTIL.showMask = function(){

    return layui.layer.load(2,{
        shade: [0.5, '#fff']
    });

};
/**
 * 根据索引关闭layui的弹出层
 * @param index 索引
 */
LAY_UTIL.closeUI = function(index){
    layui.layer.close(index);
};
/**
 * 带遮罩的ajax请求
 * @param sett
 */
LAY_UTIL.blockAjax = function(sett){
    LAY_UTIL.init();
    if (sett) {
        var root = window.getRootPath();

        if(StringUtil.isEmpty(root)){
            root = "/";
        }
        var url = sett.url;
        if(url.indexOf("/") !== 0){
            url = "/" + url;
        }

        if(!StringUtil.startWidth(url,root)){

            url = root+url;
        }
        sett.url = url;
        if(sett.needSync===true){
            sett.async=false;
        }else{
            sett.async=true;
        }
        if(sett.error===undefined){
            sett.error = function(e){
                showRequestError(e,'',e);
            }
        }
        var index = LAY_UTIL.showMask();
        sett.complete = function () {
            //关闭遮罩
            LAY_UTIL.closeUI(index);
        };

        $.ajax(sett);

    }
};
function showRequestError(e,textStatus,request){
    var sessionstatus = request.getResponseHeader("sessionstatus");

    if (sessionstatus == "timeout") {
        // 这里怎么处理在你，这里跳转的登录页面
        /*alertMessage("会话超时，请重新登录！","提示",function(){
            window.top.location.href = request.getResponseHeader("redirectUrl");
        });*/
        window.showDreaTip("用户会话已失效！","warning");
        LAY_UTIL.confirmMessage("会话超时，点击<em>确定</em>重新登录，点击<em>取消</em>停留在本页面","提示",function(){
            window.top.location.href = request.getResponseHeader("redirectUrl");
        });
        return;
    }else if(sessionstatus == "no-permission"){

        window.showDreaTip("没有访问权限！","danger");
        return;
    }else if(sessionstatus == "system-reset"){

        window.showDreaTip("系统元数据维护中！","warning");
        return;
    }/*else if(sessionstatus == "password-outdate"){

        window.showDreaTip("您的密码已过期，请先修改！","warning");
        return;
    }*/
    if(e.readyState === 0){
        //alertMessage("连接失败！","错误");
        window.showDreaTip("连接失败！","danger");
    }else if(e.readyState !== 4){
        //alertMessage("请求失败！","错误");
        window.showDreaTip("请求失败！","danger");
    }else{
        if(e.status === 400){
            //alertMessage("请求不合法！","错误");
            window.showDreaTip("错误状态码：400","danger");
        }else if(e.status === 404){
            //alertMessage("请求的路径不存在！","错误");
            window.showDreaTip("错误状态码：404","danger");
        }else if(e.status === 500){
            //alertMessage("服务器发生错误！","错误");
            window.showDreaTip("错误状态码：500","danger");
        }else{
            //alertMessage("请求失败！","错误");
            window.showDreaTip("请求失败！","danger");
        }
    }
}
LAY_UTIL.onloadFunction = [];
LAY_UTIL.onload = function(func){
    LAY_UTIL.onloadFunction.push(func);
};
LAY_UTIL.refreshUI = function(){
    if(layui.form === undefined){
        layui.use('form', function(){
            var form = layui.form;
            form.render();
        });
    }else{
        layui.form.render();
    }

};
window.onload = function (){
    LAY_UTIL.refreshUI();
    for(var i=0;i<LAY_UTIL.onloadFunction.length;i++){
        var func = LAY_UTIL.onloadFunction[i];
        if($.isFunction(func)){
            func();
        }
    }
};
LAY_UTIL.loadTbar = function(set){
    if(set === undefined){
        set = {};
    }
    var $select = set.$select;
    var target;
    if(typeof $select === 'string' ){
        target = $($select);
    }else{
        target = $select;
    }
    if(target === undefined || target.length === 0){
        return;
    }
    var layFilter = $(target).attr("lay-filter");
    if(StringUtil.isEmpty(layFilter)){
        return;
    }
    var clickCallback = set.clickCallback;
    layui.use('element', function(){
        //Tab的切换功能，切换事件监听等，需要依赖element模块
        var $ = layui.jquery
            ,element = layui.element;

        if(StringUtil.isNotEmpty(clickCallback)){
            element.on('tab('+layFilter+')', function(elem){
                location.hash = layFilter+'='+ $(this).attr('lay-id');
                var index = elem.index;

                if(index < clickCallback.length && $.isFunction(clickCallback[index])){
                    var visible = $(elem.elem).children("div").eq(0).children().eq(index).is(":visible");
                    clickCallback[index](visible);
                }
            });
        }



    });
};
LAY_UTIL.loadCollapse = function (set) {
    if(set === undefined){
        set = {};
    }
    var $select = set.$select;
    var target;
    if(typeof $select === 'string' ){
        target = $($select);
    }else{
        target = $select;
    }
    if(target === undefined || target.length === 0){
        return;
    }
    var layFilter = $(target).attr("lay-filter");
    if(StringUtil.isEmpty(layFilter)){
        return;
    }
    layui.use('element', function(){
        var element = layui.element;

        //监听折叠
        element.on('collapse('+layFilter+')', function(data){
            //console.log('展开状态：'+ data.show);
        });
    });
};
LAY_UTIL.hoverTip = function(msg,$select){
    var target;
    if(typeof $select === 'string'){
        target = $($select);
    }else{
        target = $select;
    }
    var tip = "<p>"+msg+"</p>";
    $(target).mouseover(function(){
        var index = layui.layer.tips(tip, $(this),{tips: 1,time:0});
        $(this).mouseout(function(){
            LAY_UTIL.closeUI(index);
        });
    });
};
LAY_UTIL.loadSlider = function(set){
    var $select = set.$select;
    if($($select).length === 0){
        return;
    }
    set.elem = $select;
    layui.use('slider', function(){
        slider = layui.slider;
        slider.render(set);
    });
};
LAY_UTIL.loadColor = function(set){
    var $select = set.$select;
    if($($select).length === 0){
        return;
    }
    set.elem = $select;
    layui.use('colorpicker', function() {
        var colorpicker = layui.colorpicker;
        colorpicker.render(set);
    });
};
