$(function(){
    /* 常量以及全局变量定义 */
    var selectToothRepresent = {};//当前选中的牙位标识法
    // 牙位图片常量
    var DTOTAL = 5,
    D_PATH="deciduous",
    PTOTAL = 8,
    P_PATH="permanent";
    var toothSurRTUPRight = "BDOMPRT"; //定义上排右牙面顺序
    var toothSurRTLOWRight = "LDOMBTR"; //定义下排右牙面顺序
    var toothSurRTUPLeft = "BMODPRT"; //定义上排左牙面顺序
    var toothSurRTLOWLeft = "LMODBTR"; //定义下排左牙面顺序
    var selectColor = "#ffb300";
    //牙位编码方式:后台取值
    var toothIdent = {};
    //点击用的公共值：前端点击赋值
    var selectTooth = {};
    //打开牙位图界面时默认点亮的牙面
    var lightInitFace = [];
    //加载标志，乳牙恒牙是否已经初始化
    var PermanentFlag=0,DeciduousFlag=0;
    /* 方法定义 */
    //获取牙位表示法
    function getToothRepresentation(){
        var data = {
            action: "GET_TOOTHPOSITION",
            product: product
        };
        ajaxPOSTCommon(data, function(strJson){
            if ("-1" != strJson){
                $("#toothMethod").combobox({
                    data:strJson.ident,
                    valueField:"Code",
                    textField:"Desc",
                    onSelect:function(record){
                      setToothRepresentation(record);
                    },
                    onLoadSuccess:function(){
                        if(modalDialogArgs){
                            if(modalDialogArgs.toothMethod){
                                $("#toothMethod").combobox("select",modalDialogArgs.toothMethod);
                            }else{
                                $("#toothMethod").combobox("select",strJson.select);
                            }
                        }else{
                            $("#toothMethod").combobox("select",strJson.select);
                        }
                    }
                });
            }else{
                $.messager.alert("提示","获取初始化牙位编码系统信息失败!","info");
            }
        }, function (error) {
            $.messager.alert("发生错误", "获取初始化牙位编码系统信息失败!", "error");
        }, true);
    }
    function setToothRepresentation(record){
        selectToothRepresent = record;
        //设置界面显示编号：更新界面
        updateToothPage();
    }
    //根据标识法显示相应的牙位编号
    function updateToothPage(){
        $(".box").each(function(){
            var id = $(this).prop("id");
            var num = selectToothRepresent.ToothIdent[id].ToothPDes;
            $(this).find(".box-num-label span.toothImg").text(num);
        });
    }
    //获取牙位对应的编码信息
    function initIdentData(){
        var data = {
            action: "GET_TOOTHSURFACE",
            product: product
        };
        ajaxPOSTCommon(data, function(ret){
            if (ret){
                toothIdent = ret;
            }
        }, function (error) {
            $.messager.alert("发生错误", "获取基础数据失败!", "error");
        }, false);
    }
    //设置图片信息
    function initToothImg(ShowModeCode){
        //获取当前选中的radio值
        if(ShowModeCode==="ToothDeciduous"){
            //生成乳牙
            if(DeciduousFlag===0){
                DeciduousFlag=1;
                addTypeTooth("deciduous",DTOTAL,D_PATH);
            }
        }else if(ShowModeCode==="ToothPermanent"){
            //生成恒牙
            if(PermanentFlag===0){
                PermanentFlag=1;
                addTypeTooth("permanent",PTOTAL,P_PATH);
            }
        }else if(ShowModeCode==="ToothAll"){
            if(DeciduousFlag===0){
                DeciduousFlag=1;
                addTypeTooth("deciduous",DTOTAL,D_PATH);
            }
            if(PermanentFlag===0){
                PermanentFlag=1;
                addTypeTooth("permanent",PTOTAL,P_PATH);
            }
        }
    }
    //按照类型批量添加牙位
    function addTypeTooth(selector,total,path){
        var divUpL_TR = document.createElement("div");
        $(divUpL_TR).prop("class","divLeft-tr");
        var divUpR_TL = document.createElement("div");
        $(divUpR_TL).prop("class","divRight-tl");
        var divLowL_TR = document.createElement("div");
        $(divLowL_TR).prop("class","divLeft-tr");
        var divLowR_TL = document.createElement("div");
        $(divLowR_TL).prop("class","divRight-tl");
        //定义4个象限的前缀恒牙：AA AB AC AD; 乳牙：CA CB CC CD
        var prefix = "";
        if(selector==="deciduous"){
            //乳牙
            prefix="C";
        }else{
            prefix="A";
        }
        for(var i=1;i<=total;i++){
            $(divUpL_TR).append(addTooth({direction:"Up",quadrant:prefix+"A",codeI:i,path:path}));
            $(divUpR_TL).append(addTooth({direction:"Up",quadrant:prefix+"B",codeI:i,path:path}));
            $(divLowL_TR).append(addTooth({direction:"Low",quadrant:prefix+"C",codeI:i,path:path}));
            $(divLowR_TL).append(addTooth({direction:"Low",quadrant:prefix+"D",codeI:i,path:path}));
        }
        $("."+selector+".top").append(divUpL_TR,divUpR_TL);
        $("."+selector+".bottom").append(divLowL_TR,divLowR_TL);
    }
    //添加一个box，即为一个牙位包含编号，牙根牙冠，牙面
    function addTooth(paramObj){
        var direction = paramObj.direction;
        var quadrant = paramObj.quadrant;
        var codeI = paramObj.codeI;
        var path = paramObj.path;
        /*--获取参数结束--*/
        var defaultColor = "";
        var toothPosition = quadrant+"."+codeI;
        selectTooth[toothPosition]!==undefined?defaultColor=selectColor:defaultColor="";
        var numDiv = "<div class=\"box-num-label\">\<span class=\"toothImg\" title=\""+toothIdent[toothPosition].Define+"\" style=\"background-color:"+defaultColor+";\">"+toothIdent[toothPosition].Desc+"</span></div>"
        var box = document.createElement("div");
        $(box).prop("class","box");
        $(box).prop("id",toothPosition);
        //牙面的外层盒子
        var box_surface_main = document.createElement("div");
        $(box_surface_main).prop("class","box-surface");
        var box_surfaceContent = box_surface_main;
        //牙根牙冠的外层盒子
        var box_rt_main = document.createElement("div");
        $(box_rt_main).prop("class","box-rt");
        var box_rtContent = box_rt_main;
        // 添加牙面box-surface和牙根牙冠
        var sort = "";
        if(direction==="Up"){
            sort = quadrant.indexOf("B")!==-1?toothSurRTUPLeft:toothSurRTUPRight;
            //牙根
            $(box_rt_main).css("position","relative");
            $(box_rt_main).append("<div class='upRTOuter'></div>");
            box_rtContent = $(box_rt_main).children("div.upRTOuter");
            //牙面
            $(box_surface_main).css("position","relative");
            $(box_surface_main).append("<div class='upSurOuter'></div>");
            box_surfaceContent = $(box_surface_main).children("div.upSurOuter");
        }else if(direction==="Low"){
            sort = quadrant.indexOf("D")!==-1?toothSurRTLOWLeft:toothSurRTLOWRight;
        }

        var surLen = sort.length;
        var boxDom = "";
        for(var j=0;j<surLen;j++){
            if(sort[j]==="R"||sort[j]==="T"){
                boxDom = box_rtContent;
            }else{
                boxDom = box_surfaceContent;
            }
            var surfaceItemObj = toothIdent[toothPosition].SurfaceObj[sort[j]];
            if(surfaceItemObj){
                createImgDom(boxDom,surfaceItemObj,path,direction);
            }
        }
        if(direction==="Up"){
            $(box).append(box_surface_main,box_rt_main,numDiv);
        }else{
            $(box).append(numDiv,box_rt_main,box_surface_main);
        }
        return box;
    }
    //添加图片到对应的盒子中
    function createImgDom(dom,surfaceItemObj,path){
        var ToothSICode = surfaceItemObj.ToothSICode;
        var defaultColor = "",letter = surfaceItemObj.ToothSIDes;
        if($.inArray(ToothSICode,lightInitFace)!==-1){
            defaultColor = selectColor;
        }
        //创建Image对象
        var imgName = ToothSICode.replace(".","_").replace(".","_");
        var imgclass = imgName + " toothImg rts_"+letter;
        if((letter==="R"||letter==="T")){
            var ImgObj = document.createElement("div");
            //设置不允许点击的颜色
            if (isClickRT===false){
                imgclass = imgclass + " RTImgDisable";
                ImgObj.style["background-color"] = "#CDCDB4";
            }else{
                ImgObj.style["background-color"] = defaultColor;
            }
        }else{
            var ImgObj = new Image();
            ImgObj.src = "";
            ImgObj.alt = "";
            ImgObj.style["background-color"] = defaultColor;
        }
        ImgObj.className = imgclass;
        ImgObj.title = surfaceItemObj.ToothSIDefine;
        $(dom).append(ImgObj);
    }
    /* 添加点击事件 单选按钮的点击*/
    //点击保存事件
    $("#addToRecord").click(function(){
        returnValue = getToothData();
        closeWindow();
    });
    $("#resetTooth").click(function(){
        $.messager.confirm("提示","是否清空当前选择的全部牙位信息？",function(r){
            if(r){
                $.each(selectTooth,function(key,value){
                    var selector = key.replace(".","\\.");
                    unCheckBox($("#"+selector))
                    //清空当前选择的所有牙位
                });
                selectTooth = {};
            }
        });
    });
    function getToothData(){
        var showModeCode = $('input:radio[name="toothRadio"]:checked').val();
        var toothData = {
            toothType: showModeCode.replace("Tooth",""),
            toothMethod: selectToothRepresent.Code,
            showType: selectToothRepresent.Code!="FDI"?"image":"text",
            toothCodeSystem: selectToothRepresent.toothCodeSystem,
            toothCodeSystemName: selectToothRepresent.toothCodeSystemName,
            toothSurfaceCodeSystem: selectToothRepresent.toothSurfaceCodeSystem,
            toothSurfaceCodeSystemName: selectToothRepresent.toothSurfaceCodeSystemName
        };
        $.each(selectTooth,function(key,value){
            if (value!==undefined){
                var teethObj = {
                    code : key,
                    name: toothIdent[key].Define,
                    desc: selectToothRepresent.ToothIdent[key].ToothPDes,
                    surface: getToothSurface(key,value)
                };
                var quadrant = toothIdent[key].Quadrant;
                if ("undefined" != typeof toothData[quadrant]){
                    toothData[quadrant].push(teethObj);
                }else{
                    toothData[quadrant] = [teethObj];
                }
            }
        });
        return toothData;
    }
    function getToothSurface(key,surValue){
        var toothSurface = [],surCode = "";
        var len = surValue.length;
        for(var i=0;i<len;i++){
            surCode = surValue[i];
            if(isClickRT===false&&(surCode==="R"||surCode==="T")){
                continue;
            }
            toothSurface.push({
                code: toothIdent[key].SurfaceObj[surCode].ToothSICode,
                desc: toothIdent[key].SurfaceObj[surCode].ToothSIDes,
                name: toothIdent[key].SurfaceObj[surCode].ToothSIDefine
            });
        }
        return toothSurface;
    }
    //关闭窗口
    function closeWindow() {
        if(parent && parent.closeDialog && dialogID){
            parent.closeDialog(dialogID);
        }
    }
    $HUI.radio("[name='toothRadio']",{
        onChecked:function(e,value){
            var value = $(e.target).attr("value");
            if (value === "ToothDeciduous"){
                $(".deciduous").css("display","");
                $(".permanent").css("display","none");
                $("#line").attr("class","cross-line-deciduous");
                $("#FlagRight").css("left","170px");
                $("#FlagLeft").css("right","170px");
                $(".flag-rl-middle").css("margin","175px auto");
                //竖线
                $(".tooth-main").css("height","372px");
                initToothImg(value);
            }else if (value === "ToothAll"){
                $(".deciduous").css("display","");
                $(".permanent").css("display","");
                $("#line").attr("class","cross-line");
                $("#FlagRight").css("left","0px");
                $("#FlagLeft").css("right","0px");
                $(".flag-rl-middle").css("margin","390px auto");
                //竖线
                $(".tooth-main").css("height","814px");
                initToothImg(value);
            }else{
                $(".deciduous").css("display","none");
                $(".permanent").css("display","");
                $("#line").attr("class","cross-line");
                $("#FlagRight").css("left","0px");
                $("#FlagLeft").css("right","0px");
                $(".flag-rl-middle").css("margin","212px auto");
                //竖线
                $(".tooth-main").css("height","442px");
                initToothImg(value);
            }
        }
    });
    //点击牙位 background-color:#ffb300
    $(".tooth-layout").on("click",".toothImg",function(){ 
        var clickType = $(this).prop("tagName").toUpperCase();
        //当前点击的是图片
        if(clickType === "SPAN"){
            clickNumber(this);
        }else{
            clickImg(this);
        }
    });
    function clickImg(_this){
        if(isClickRT===false){
            if(/rts_(R|T)/.test($(_this).attr("class"))){
                return;
            }
        }
        var $box = $(_this).parents("div.box");
        var $numSpan = $box.children("div.box-num-label").children("span");
        var boxID = $box.prop("id");
        var surCode = $(_this).prop("class").split(" ")[2].split("_")[1];
        if(!selectTooth[boxID]||selectTooth[boxID].indexOf(surCode)===-1){
            $(_this).css("background-color",selectColor);
            //点亮编号
            $numSpan.css("background-color",selectColor);
            selectTooth[boxID]?selectTooth[boxID] += surCode:selectTooth[boxID]=surCode;
            offReverseTooth(boxID);
        }else{
            var reg = new RegExp(surCode,"g");
            selectTooth[boxID] = selectTooth[boxID].replace(reg,"");
            $(_this).css("background-color","");
            // if(selectTooth[boxID]===""){
            //   $numSpan.css("background-color","");
            //   selectTooth[boxID] = undefined;
            // }
        }
    }
    function clickNumber(_this){
        var $box = $(_this).parents("div.box");
        var boxID = $box.prop("id");
        if(selectTooth[boxID]===undefined){
            $(_this).css("background-color",selectColor);
            selectTooth[boxID] = "";
            offReverseTooth(boxID);
        }else{
            unCheckBox($box);
        }
    }
    //取消恒牙乳牙对应牙齿的选择
    function offReverseTooth(boxID){
        if(boxID.indexOf("8")===-1){
            //取消对应位置的点亮
            if(boxID.charAt(0)==="A"){
                ReverseBoxID = "C"+boxID.slice(1);
            }else{
                ReverseBoxID = "A"+boxID.slice(1);
            }
            var $reverseBox=$(document.getElementById(ReverseBoxID));
            unCheckBox($reverseBox);
        }
    }
    function checkBox($box){
        var boxID = $box.prop("id");
        $box.prop("name","checked");
        $box.find(".box-num-label .toothImg").css("background-color",selectColor);
        selectTooth[boxID] = "";
    }
    function unCheckBox($box){
        var boxID = $box.prop("id");
        $box.prop("name","unchecked");
        $box.find(".toothImg").css("background-color","");
        $box.find(".RTImgDisable").css("background-color","#CDCDB4");
        selectTooth[boxID] = undefined;
    }
    function initToothData(){
        if (modalDialogArgs){
            InitOperedTooth();
            $HUI.radio("#Tooth"+modalDialogArgs.toothType).setValue(true);
        }else{
            //根据配置默认勾选恒牙乳牙混合牙
            setDefaultRadio();
        }
        function InitOperedTooth(){
            modalDialogArgs.A?areaSingleTooth(modalDialogArgs.A):1==1;
            modalDialogArgs.B?areaSingleTooth(modalDialogArgs.B):1==1;
            modalDialogArgs.C?areaSingleTooth(modalDialogArgs.C):1==1;
            modalDialogArgs.D?areaSingleTooth(modalDialogArgs.D):1==1;
        }
        function areaSingleTooth(Arry){
            var leng = Arry.length;
            for(var i=0;i<leng;i++){
                var boxID = Arry[i].code;
                selectTooth[boxID] = "";
                var surfaceArry =  Arry[i].surface;
                var str = "";
                for(var j=0;j<surfaceArry.length;j++){
                    str += surfaceArry[j].desc;
                    lightInitFace.push(surfaceArry[j].code);
                }
                selectTooth[boxID] = str;
            }
        }
    }

    //根据科室配置选中对应的radio
    function setDefaultRadio(){ 
        try {
            var reg = new RegExp("\\b"+userLocID+"\\b","g");
            if(defaultRadio.ToothPermanent && defaultRadio.ToothPermanent.search(reg)!==-1){
                //选中恒牙
                $HUI.radio("#ToothPermanent").setValue(true);
            }else if(defaultRadio.ToothDeciduous && defaultRadio.ToothDeciduous.search(reg)!==-1){
                //选中乳牙
                $HUI.radio("#ToothDeciduous").setValue(true);
            }else if(defaultRadio.ToothAll && defaultRadio.ToothAll.search(reg)!==-1){
                //选中混合牙
                $HUI.radio("#ToothAll").setValue(true);
            }else{
                //选中恒牙
                $HUI.radio("#ToothPermanent").setValue(true);
            }
        } catch (error) {
            //选中恒牙
            $HUI.radio("#ToothPermanent").setValue(true);
        }
    }
    //初始化ident数据
    initIdentData();
    //初始化选中的牙位
    initToothData();
    getToothRepresentation();
});

function ajaxPOSTCommon(data, onSuccess, onError, isAsync) {
    isAsync = isAsync || false;
    if ("undefined" != typeof data.params){
        data.params.langID = langID;
    }else{
        data.params = {
            langID: langID
        };
    }
    $.ajax({
        type: "POST",
        dataType: "json",
        url: "../EMR.DOC.SRV.RequestCommon.cls?MWToken="+getMWToken(),
        async: isAsync,
        cache: false,
        contentType: "text/plain",
        processData: false,
        data: JSON.stringify(data),
        success: function (ret) {
            if("true" === ret.success){
                if (!onSuccess) {}
                else {
                    if (ret.errorCode){
                        $.messager.alert("数据请求失败提示", ret.errorMessage, "info");
                        onSuccess("");
                    }else{
                        onSuccess(ret.data);
                    }
                }
            }else{
                $.messager.alert("失败", "ajaxPOSTCommon:请求失败", "error");
            }
        },
        error: function (ret) {
            if (!onError) {
                $.messager.alert("发生请求错误", "ajaxPOSTCommon error:"+JSON.stringify(ret), "error");
            }else {
                onError(ret);
            }
        }
    });
}

//国际化改造获取翻译
function emrTrans(value)
{
    if (typeof $g == "function") 
    {
        value = $g(value)
    }
    return value;
}

//封装基础平台websys_getMWToken()方法
function getMWToken()
{
    try{
        if (typeof(websys_getMWToken) != "undefined")
            return websys_getMWToken();
        return "";
    }catch(e) {
        return "";
    }
}