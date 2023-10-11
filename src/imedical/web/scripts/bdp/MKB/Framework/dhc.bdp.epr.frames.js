///顶部左边菜单数据解析
var leftMenuTpl = '{{each(i,r1) records}}'
+'<li class="dhc-menuie8" {{if !r1.childrent}} class="dhc-menu" {{/if}} >'
    +'<a data-itarget="${r1.target}" data-ilink="${r1.link}" data-iblankOpt="${r1.blankOpt}" href="#"'
        +'{{if !r1.childrent}} class="dhc-submenu1" {{/if}}'  /* dhc-submenu改成dhc-submenu1，否则点击头菜单，会出现空白页 */
        +'>${r1.text}'
        +'{{if r1.children }}<b class="caret"></b>{{/if}}'
    +'</a>'     //<!--第一层//-->
    +'{{if r1.children}}'
        +'<ul class="dropdown-menu">'
            +'{{each(j,r2) r1.children}}'
            +'<li'+'{{if r2.children }} class="dropdown-submenu dhc-menu" {{/if}}'+'>'
                +'<a data-ilink="${r2.link}" data-itarget="${r2.target}" data-iblankOpt="${r2.blankOpt}" href="#" data-target="#"'
                +' class="dropdown-toggle {{if !r2.childrent}} dhc-submenu {{/if}}"'
                +'>${r2.text}'
                +'</a>'     //<!--第二层//-->
                +'{{if r2.children }}'
                    +'<ul class="dropdown-menu">'
                        +'{{each(k,r3) r2.children}}'
                            //<!--第三层-->
                            +'<li><a class="dhc-submenu" href="#" data-ilink="${r3.link}" data-itarget="${r3.target}" data-iblankOpt="${r3.blankOpt}">${r3.text}</a></li>'
                        +'{{/each}}'
                    +'</ul>'
                +'{{/if}}'
            +'</li>'
            +'{{/each}}'
        +'</ul>'
    +'{{/if}}'
+'<li>'
+'{{/each}}'
var otherMenuTpl = '<li class="dhc-menu dhc-menuie8" ><a href="#">更多<b class="caret"></b></a>'
                        +'<ul class="dropdown-menu">'
                        +'{{each(i,r1) records}}'
                            +'<li' + '{{if r1.children }} class="dropdown-submenu dhc-menu" {{/if}}' +'> '
                                +'<a href="#" data-ilink="${r1.link}" data-itarget="${r1.target}" data-iblankOpt="${r1.blankOpt}" '
                                +' {{if !r1.children }} class="dhc-submenu1" {{/if}} '
                                +'>${r1.text}'
                                    //+'{{if r1.children}}<b class="caret-in"></b>{{/if}}'  //这一个没什么用吧
                                +'</a>' //一层
                                +'{{if r1.children}}'
                                    +'<ul class="dropdown-menu">'
                                    +'{{each(j,r2) r1.children}}'
                                        +'<li' + '{{if r2.children }} class="dropdown-submenu dhc-menu" {{/if}}' +'>'
                                            +'<a href="#" data-ilink="${r2.link}" data-itarget="${r2.target}" data-iblankOpt="${r2.blankOpt}"'
                                            +' {{if !r2.children }} class="dhc-submenu" {{/if}} >${r2.text}'
                                            +'</a>' //二层
                                            +'{{if r2.children}}'
                                                +'<ul class="dropdown-menu" > '
                                                    +'{{each(k,r3) r2.children}}'
                                                        //三层
                                                    +'<li><a class="dhc-submenu" href="#" data-ilink="${r3.link}" data-itarget="${r3.target}" data-iblankOpt="${r3.blankOpt}">${r3.text}</a></li>'
                                                    +'{{/each}}'
                                                +'</ul>'
                                            +'{{/if}}'
                                            
                                        +'</li>' 
                                        
                                    +'{{/each}}'
                                    +'</ul>'
                                +'{{/if}}'
                            +'</li>'
                        +'{{/each}}'
                        +'</ul>'
                    +'</li>'
//子菜单中子菜单的三角图案是通过after实现的，低版本IE不行，所以在低版本在<a>标签后加上<b class="caret-in"></b>                   
/* chenying  2018-06-04 头菜单 ie8下样式有问题 增加class="dhc-menuie8"*/
var leftMenuTpl2 = '{{each(i,r1) records}}'
+'<li class="dhc-menuie8" {{if r1.children }} class="dhc-menu" {{/if}}>'
    +'<a data-itarget="${r1.target}" data-ilink="${r1.link}" data-iblankOpt="${r1.blankOpt}" href="#"'
        +'{{if !r1.childrent}} class="dhc-submenu1" {{/if}}'
        +'>${r1.text}'
        +'{{if r1.children }}<b class="caret"></b>{{/if}}'
    +'</a>'     //<!--第一层//-->
    +'{{if r1.children}}'
        +'<ul class="dropdown-menu">'
            +'{{each(j,r2) r1.children}}'
            +'<li'+'{{if r2.children }} class="dropdown-submenu dhc-menu" {{/if}}'+'>'
                +'<a data-ilink="${r2.link}" data-itarget="${r2.target}" data-iblankOpt="${r2.blankOpt}" href="#" data-target="#"'
                +' class="dropdown-toggle {{if !r2.childrent}} dhc-submenu {{/if}}"'
                +'>${r2.text}'
                +'</a>'     //<!--第二层//-->
                +'{{if r2.children }}'
                    +'<b class="caret-in"></b>'    //子菜单三角
                    +'<ul class="dropdown-menu">'
                        +'{{each(k,r3) r2.children}}'
                            //<!--第三层-->
                            +'<li><a class="dhc-submenu" href="#" data-ilink="${r3.link}" data-itarget="${r3.target}" data-iblankOpt="${r3.blankOpt}">${r3.text}</a></li>'
                        +'{{/each}}'
                    +'</ul>'
                +'{{/if}}'
            +'</li>'
            +'{{/each}}'
        +'</ul>'
    +'{{/if}}'
+'</li>'
+'{{/each}}'
var otherMenuTpl2 = '<li class="dhc-menu dhc-menuie8"><a href="#">更多<b class="caret"></b></a>'
                        +'<ul class="dropdown-menu">'
                        +'{{each(i,r1) records}}'
                            +'<li' + '{{if r1.children }} class="dropdown-submenu dhc-menu" {{/if}}' +'> '
                                +'<a href="#" data-ilink="${r1.link}" data-itarget="${r1.target}" data-iblankOpt="${r1.blankOpt}" '
                                +' {{if !r1.children }} class="dhc-submenu" {{/if}} '
                                +'>${r1.text}'
                                    //+'{{if r1.children}}<b class="caret-in"></b>{{/if}}'  //这一个没什么用吧
                                +'</a>' //一层
                                +'{{if r1.children}}'
                                    +'<b class="caret-in"></b>'    //子菜单三角
                                    +'<ul class="dropdown-menu">'
                                    +'{{each(j,r2) r1.children}}'
                                        +'<li' + '{{if r2.children }} class="dropdown-submenu dhc-menu" {{/if}}' +'>'
                                            +'<a href="#" data-ilink="${r2.link}" data-itarget="${r2.target}" data-iblankOpt="${r2.blankOpt}"'
                                            +' {{if !r2.children }} class="dhc-submenu" {{/if}} >${r2.text}'
                                            +'</a>' //二层
                                            +'{{if r2.children}}'
                                                +'<b class="caret-in"></b>'    //子菜单三角
                                                +'<ul class="dropdown-menu" > '
                                                    +'{{each(k,r3) r2.children}}'
                                                        //三层
                                                    +'<li><a class="dhc-submenu" href="#" data-ilink="${r3.link}" data-itarget="${r3.target}" data-iblankOpt="${r3.blankOpt}">${r3.text}</a></li>'
                                                    +'{{/each}}'
                                                +'</ul>'
                                            +'{{/if}}'
                                            
                                        +'</li>' 
                                        
                                    +'{{/each}}'
                                    +'</ul>'
                                +'{{/if}}'
                            +'</li>'
                        +'{{/each}}'
                        +'</ul>'
                    +'</li>'                    
var preSelectedMenu;
function clearSelected(t){
    var tmp;
    if(t){
        tmp = t.parent();
        tmp.removeClass("clickactive");
        tmp = tmp.parent().parent();
        while(tmp.is("li")){
            if (tmp.is("div")) break;
            tmp.removeClass("clickactive");
            tmp = tmp.parent().parent();
        }               
    }
}
function addSelected(t){
    var tmp ;
    if(t){
        tmp = t.parent();       //li
        tmp.addClass("clickactive");
        tmp = tmp.parent().parent();
        while(tmp.is('li')){
            if (tmp.is("div")) break;
            tmp.addClass("clickactive");
            tmp = tmp.parent().parent();
        }               
    }
}
function modifySelectedStyle(t){
    if(preSelectedMenu){                
        clearSelected(preSelectedMenu);                 
    }
    preSelectedMenu = t;
    if(t){
        addSelected(t);
    }
}
/*
var msgJObj = "", findDHCMessageBtnCount = 10;  //信息按钮jquery对象
var msgTimeoutQhanlder = "";
var newMsgAudioObj = document.getElementById("newMsgAudio");
//显示消息数量
var ShowDHCMessageCount = function(){
    if (findDHCMessageBtnCount<0) return ;
    clearTimeout(msgTimeoutQhanlder);
    msgJObj = $("#DHCMessageBtn");
    var WinModalSel = msgJObj.attr("data-itarget");
    var WinModalJObj = $(WinModalSel);
    if (msgJObj.length>0) {
        $.ajaxRunServerMethod({ 
            ClassName:"websys.DHCMessageDetailsMgr",MethodName:"GetNotReadMsgCount",UserId:session['LOGON.USERID']
        },function(rtn){
            if ("string" == typeof rtn ){ rtn = $.parseJSON(rtn);}
            if (rtn && rtn.Count>0){
                msgJObj.removeClass("nullMessage").addClass("hasMessage");
                $("#DHCMessageBtn .messagecount").html(rtn.Count);
                if (rtn.DCount>0){
                    if( !WinModalJObj.is(":visible")) {
                        eval("var opt = {"+msgJObj.attr("data-iblankOpt")+"}");
                        showModal(WinModalSel,msgJObj.attr("data-ilink"),opt);
                    }
                }
                if (newMsgAudioObj) {newMsgAudioObj.play();}
            }else if(rtn && rtn.Count==0){
                $("#DHCMessageBtn .messagecount").html(rtn.Count);
                msgJObj.removeClass("hasMessage").addClass("nullMessage");
            }
            msgTimeoutQhanlder = setTimeout(ShowDHCMessageCount,5*60*1000); ///五分钟查询一次信息数量
        })
    }else{
        //没有找到元素,可能是ext没有render完成,所以得去再去查询,考虑可能是easyui的头菜单
        msgTimeoutQhanlder = setTimeout(ShowDHCMessageCount,1000);
        findDHCMessageBtnCount--;
    }
}
*/
///点击消息按钮,显示消息内容
/*
var msgBtnClickHandler = function(){
    
    if( $('#MessageWin').is(":visible")) return false;
    ShowDHCMessageCount();
    var xy = $("#DHCMessageBtn").offset();
    var width = 900;
    var height = 500;
    var left = xy.left-width+100;
    if (left<0) left = 0; 
    $("#MessageWin").window("move",{left:left,top:xy.top+20}).window("open");
    return false;
}*/
/*center.modal*/
var showConfig = function(){
    var content = "没有配置信息",dw=300,dh=300, title="设置",url="";
    var m = frames["TRAK_main"];
    if (m && m.getConfigUrl){
        var cfg = m.getConfigUrl.call(this,session["LOGON.USERID"],session["LOGON.GROUPID"],session["LOGON.CTLOCID"]);
        if (cfg) {
            title = cfg.title || title;
            dw = cfg.width || dw;
            dh = cfg.height || dh;
            url = cfg.url;
        }
    }
    showModal("#WinModal",url,{title:title,content:content,width:dw,height:dh});
}
var showHelp = function(){
    var m = frames["TRAK_main"], dw=700, dh=500;
    var groupId= session['LOGON.GROUPID'];
    var groupDesc = session['LOGON.GROUPDESC']
    var url = "../html/help/CH/G"+groupId+".html"
    $.ajax({
        url:url,
        success:function(rtn){
            showModal("#WinModal",url,{title:'帮助文档',width:dw,height:dh});
        },
        error:function(data,textStatus){
            if (data.status==404){
                //url = "websys.help.csp?helpCode=G"+groupId
                //showModal("#WinModal",url,{title:'帮助文档',width:dw,height:dh});
                showModal("#WinModal","",{title:'帮助文档',content:"没有找到"+session['LOGON.GROUPDESC']+"相关的帮助文件!<br>请联系管理员!",width:dw,height:dh});
            }
        }
    })
    return false;
    
    showModal("#WinModal",url,{title:'帮助文档',width:dw,height:dh});
    return false; 
    
    if (m && m.location.pathname){
        if (m.location.search){
            //alert(m.location.pathname+m.location.search);
        }
    }else{
        
    }
}
//关于
var aboutDiv = "<div style='width:430px;height:200px;border-bottom:1px solid #CCCCCD;'>"
    +"<div style='float:left;width:150px;height:200px;padding:50px 30px 30px 30px;'>"
        +"<img src='../skin/default/images/websys/aboutlogo.png'/>"
    +"</div>"
    +"<div style='float:left;width:270px;height:200px;' class='aboutbody'>"
        +"<img src='../skin/default/images/websys/logo.png'/ style='margin:10px 0px 10px 0px;'>"
        +"<ul style='font-size:13px;'>"
            +"<li>产品名称："+LicPrj+" Total HIS</li>"
            +"<li>产品版本："+LicVer+"</li>"
            +"<li>软件许可授权类型："+LicVerSummary+"</li>"
            +"<li>软件许可授权截止日期："+LicExpDate+"</li>"
            +"<li>软件许可授权使用单位："+LicUserName+"</li>"
        +"</ul>"
    +"</div></div>"
    +"<div class='aboutfooter'>"
        +"<span style='font-size:10px;' class='glyphicon glyphicon-copyright-mark'></span>"
        +"2016-2017 东华软件股份公司版权所有"
    +"</div>"
var showAbout = function(){ 
    showModal("#WinModal","",{title:'关于iMedical',content:aboutDiv,width:460,height:250});
    return false; 
}
/**
* 使页面中所有.modal元素在窗口可视范围之内居中
**/
function centerModals(){
  $('.modal').each(function(i){
    var $clone = $(this).clone().css('display', 'block').appendTo('body');
    var top = Math.round(($clone.height() - $clone.find('.modal-content').height()) / 2);
    var left = Math.round(($clone.width() - $clone.find('.modal-content').width()) / 2);
    top = top > 50 ? top : 0;
    $clone.remove();
    $(this).find('.modal-content').css("margin-top", top-50)
    $(this).find('.modal-dialog').css("margin-left",left);
  });
}
var showModal = function(target, url, opt){
    if (target && target=="#WinModalEasyUI"){
        showModalEasyUI(url,opt);
        return false;
    }
    var width = 400, height=400 , top=200 ,left=300, title = "对话框!" ,showbefore = null,showafter=null,content="无内容";
    var posWidth = screen.availWidth;
    var posHeight = screen.availHeight;
    if (arguments.length>2){
        if (opt.width){ width = parseInt(opt.width); }
        if (opt.height){ height = parseInt(opt.height);}
        if (opt.title){title = opt.title;}
        if (opt.showbefore){
            showbefore = opt.showbefore;
            if(showbefore) showbefore.call(this);
        }
        if (opt.showafter){
            showafter = opt.showafter;
        }
        if(opt.content) content = opt.content;
    }
    
    var urlHtml = "";
    if(url){
        if ('undefined'!==typeof websys_getMWToken){
            if (url.indexOf("?")>-1)
            {
                url += "&MWToken="+websys_getMWToken()
            }
            else
            {
                url += "?MWToken="+websys_getMWToken()
            }
            
        }
        urlHtml = '<iframe src="'+url+'" width="100%" height="100%" scrolling="auto" marginwidth=0 marginheight=0 frameborder="no" framespacing=0></iframe>';
    }else{
        urlHtml = content;
    }
    var modalJObj = $(target);
    //modalJObj.find(".modal-footer").hide();
    modalJObj.find(".modal-title").html(title);
    modalJObj.find(".modal-content").css({width:width});        
    modalJObj.find(".modal-body").css({width:width,height:height}).html(urlHtml); //
    modalJObj.modal('show');
    if(showafter) showafter.call(this);
}
var toggleMsgAudio =function(){
    var t = $("#toggleMsgAudioA");
    var iconI = t.find("i");
    //t.find("i").toggleClass("icon-volume-up").toggleClass("icon-volume-off");
    if (iconI.hasClass("icon-volume-up")){
        $.ajaxRunServerMethod({ClassName:"websys.DHCMessageConfig",MethodName:"DisableMsgAudio",UserId:session["LOGON.USERID"]},function(){
            iconI.addClass("icon-volume-off").removeClass("icon-volume-up");
            t.find("span").html("开启消息提示音");
            EnableMsgAudio = false;
        });
    }else{
        $.ajaxRunServerMethod({ClassName:"websys.DHCMessageConfig",MethodName:"EnableMsgAudio",UserId:session["LOGON.USERID"]},function(){
            iconI.addClass("icon-volume-up").removeClass("icon-volume-off");
            t.find("span").html("关闭消息提示音");
            EnableMsgAudio = true;
        });
    }
}
/*隐藏模态框*/
var hidenModalEasyUI = function(){
    $("#WinModalEasyUI").window('close');
    $("#WinModal").modal('hide');
}
var showModalEasyUI = function(url, opt){
    var width = 400, height=400 , title = "对话框!" ,showbefore = null,showafter=null,content="无内容";
    if (arguments.length>1){
        if (opt.width){ width = parseInt(opt.width); }
        if (opt.height){ height = parseInt(opt.height);}
        if (opt.title){title = opt.title;}
        if (opt.showbefore){
            showbefore = opt.showbefore;
            if(showbefore) showbefore.call(this);
        }
        if (opt.showafter){
            showafter = opt.showafter;
        }
        if(opt.content) content = opt.content;
    }
    var urlHtml = "";
    if(url){
        if ('undefined'!==typeof websys_getMWToken){
            if (url.indexOf("?")>-1)
            {
                url += "&MWToken="+websys_getMWToken()
            }
            else
            {
                url += "?MWToken="+websys_getMWToken()
            }
            
        }
        urlHtml = '<iframe src="'+url+'" width="100%" height="100%" scrolling="auto" marginwidth=0 marginheight=0 frameborder="no" framespacing=0></iframe>';
    }else{
        urlHtml = content;
    }
    if (!$.browser){
        $.browser = {} ;
        $.browser.mozilla = /firefox/.test(navigator.userAgent.toLowerCase());  
        $.browser.webkit = /webkit/.test(navigator.userAgent.toLowerCase());  
        $.browser.opera = /opera/.test(navigator.userAgent.toLowerCase());  
        $.browser.msie = /msie/.test(navigator.userAgent.toLowerCase());
    }
    $("#WinModalEasyUI").window({
        modal:true,
        closed:true,
        collapsible:false,
        closable:true,
        width:width,
        height:height,
        content:urlHtml,
        title:title
    }).window("open");
    var docWidth = $(document).width();
    $("#WinModalEasyUI").window("move",{top:100,left:(docWidth-width)/2}); //.window("setTitle",title);
}
var renderingMenuFlag = false;  //是否正在render menu
var renderMenu = function(posWidth){
    if (renderingMenuFlag) return false;
    renderingMenuFlag = true;
    var leftPullWidth = $(".navbar-container .pull-left").width();   // imedical logo
    var rightPullWidth = $(".navbar-container .pull-right").width(); // sys menu
    
    //menu max width
    var HEADERMENUWIDTH = posWidth - rightPullWidth - leftPullWidth ; //posWidth * 0.75;
    //menu china word length;
    var WORDPX = 17           // 一个汉字的宽 wordpx(px)
    var menuItemPaddingPX = 4/5
    var menuHeaderNum = menuItemPaddingPX;  // menu padding 是汉字的2/3*wordpx(px)
    var leftMenuJson = {left:{records:[]},other:{records:[]}};
    var tmpItm = null; 
    for (var i=0 ; i< menuJson.records.length; i++){
        tmpItm = menuJson.records[i];
        menuHeaderNum = menuHeaderNum+(menuItemPaddingPX*2); //menu paading   
        if (tmpItm.children) {menuHeaderNum++} // caret-in
        menuHeaderNum = menuHeaderNum+tmpItm.text.length
        if ((menuHeaderNum*WORDPX)>HEADERMENUWIDTH){
            leftMenuJson.other.records.push(tmpItm);
        }else{
            leftMenuJson.left.records.push(tmpItm);
        }
    }
    //console.log("render menu"+new Date());
    var headerMenuHtml = $.tmpl("leftMenuTpl",leftMenuJson.left);
    $("#left-menu").html("").prepend(headerMenuHtml);  //头部菜单
    if (leftMenuJson.other.records && leftMenuJson.other.records.length>0){
        var otherMenuHtml = $.tmpl("otherMenuTpl",leftMenuJson.other);
        $("#left-menu").append(otherMenuHtml);
    }
    // resize事件,防止频繁渲染头菜单
    //setTimeout(function(){renderingMenuFlag = false;},100);  //chenghegui注释  引发放大缩小窗口,菜单不显示bug
}
var isLowIE=function(){     //低版本IE判断 哪个版本算低再说 暂时认为这些都低
    if(navigator.userAgent.indexOf("MSIE")>0){   
      if(navigator.userAgent.indexOf("MSIE 6.0")>0){   
        //alert("ie6");
        return true;    
      }   
      if(navigator.userAgent.indexOf("MSIE 7.0")>0){  
        //alert("ie7");  
        return true;   
      }   
      if(navigator.userAgent.indexOf("MSIE 9.0")>0 && !window.innerWidth){//这里是重点
        //alert("ie8");  
        return true;  
      }   
      if(navigator.userAgent.indexOf("MSIE 9.0")>0){  
        //alert("ie9");  
        return true;  
      }   
    } 
}
var timeoutLoadOrderHandlerId;
var gCacheData = {}; //缓存数据
var loadOrderEntry = function(){
    if(window.frames["TRAK_main"] && window.frames["TRAK_main"].document && window.frames["TRAK_main"].document.readyState == 'complete'){
        clearTimeout(timeoutLoadOrderHandlerId);
        if (window.gCacheDetails) {
            for(var p in gCacheDetails){
                $.ajax({
                    url:  gCacheDetails[p], //"http://"+CfgWebIP+"/dthealth/web/temp/cachejson/"+CacheOrderName+".G"+session['LOGON.GROUPID']+".json", //"websys.QueryBroker.cls", //"../scripts/cachejson/tmp.json", //"../scripts/cachejson/arr.json"
                    dataType:"text",
                    data:{ r:new Date().getTime()},
                    success:function(data){
                        eval("var rtn="+data);
                        gCacheData[p] = rtn;
                    },
                    error:function(data,textStatus){
                    }
                }); 
            }
        }
    }else{
        timeoutLoadOrderHandlerId = setTimeout(loadOrderEntry,500);
    }
}
function websysChangeMenu(url,newwin){
    IsSideMenu=true;
    if (IEVersion=="IE8"){
        SetKeepOpen(url,newwin);
    }else{
        $("#left-menu").html("");
        websys_createWindow("epr.default.csp?IsSideMenu=true","TRAK_main","");
    }
}
/**
* 头菜单事件
*/
var addHeadMenuListeners = function(){
        /*
    var $menuLi = $(".navbar-nav>li");
    $menuLi.mouseover(function(){ 
            var t = $(this); if (t.find("ul.dropdown-menu")){ t.addClass('open'); }else{ t.addClass('active');}
        }).mouseout(function(){
            var t = $(this); if (t.find("ul.dropdown-menu")){ t.removeClass('open'); }else{ t.removeClass('active');}
        });
        */
    // toggleClass-->addClass  ie下 鼠标先在非头菜单位置长按左键不释放->拖动鼠标到有二级菜单的头菜单位置->释放鼠标左键，此时二级菜单展开。菜单不hide
    ///头菜单右侧，鼠标移上移除触发
    $(".navbar-container").on("mouseover",".navbar-nav>li.dhc-menu",function(){
	    var t = $(this);
        if (t.find("ul.dropdown-menu")){  
            t.addClass('open');  
        }else{  
            t.addClass('active');
        }
        //if(!!window.ActiveXObject || "ActiveXObject" in window){     chenying 2019-02-13 判断是否是IE
        if((!!window.ActiveXObject)||(navigator.userAgent.indexOf('Trident')>-1&&navigator.userAgent.indexOf("rv:11.0")>-1))
        {
            if (t.find("iframe").length>0){}else{ // ie下电子病历zindex
                var prop = function (n){return n&&n.constructor==Number?n+'px':n;}
                t.find("ul").each(function(){
                    var t1 = $(this);
                    var str = '<iframe frameborder="0" tabindex="-1" src="javascript:false;" style="display:block;position:absolute;z-index:-1;filter:Alpha(Opacity=0);opacity:0;';
                    str += 'top:0px;left:0px;width:'+prop(t1.css("width"))+';height:'+prop(t1.css("height"))+';"/>';
                    t1.append(str);
                });
            }
        }
        return false;
    }).on("mouseout",".navbar-nav>li.dhc-menu",function(){
	   var t = $(this);
        if (t.find("ul.dropdown-menu")){  
            t.removeClass('open');  
        }else{  
            t.removeClass('active');
        }
        return false;
    });
    $("#menuPanel").delegate('.dhc-submenu',"click",function(event){
        var DoingSthDesc = $("#DoingSth").val();
        if ((DoingSthDesc!="")&&(DoingSthDesc!=undefined)){ //gss 20210608
            $.messager.alert("提示",DoingSthDesc);
            event.preventDefault();
            event.stopPropagation();
            return ;
        }
        var isModifyStyle = true;  
        var t = $(this);
        var href = t.attr("data-ilink");
        var target = t.attr("data-itarget");
        var blankOpt=t.attr("data-iblankOpt");
        var imodal = t.attr("data-imodal");
        if (href=="#") {
            event.preventDefault();
            event.stopPropagation(); 
            return false;
        }
        if (target=="_blank"){
            isModifyStyle = false
        }
        if (href=="javascript:void(0);") {
            event.preventDefault();
            event.stopPropagation(); 
            return false;
        }
        // 增加选中样式
        var p = t;
        while(p){
            if (p.hasClass("navbar-container")){break;}
            if (p.hasClass("pull-right")) { isModifyStyle = false; break;}
            p = p.parent();
        }
        
        if(isModifyStyle){
            modifySelectedStyle(t);
        }
        if (href && href.indexOf("javascript:")>-1){
            window.eval(href);
        }else if(imodal=="true"){
            eval("var blankOptObj ={"+blankOpt+"}");
            showModal(target,href,blankOptObj);
        }else{
            websys_createWindow(href,target,blankOpt);
        }   
        return true;
    });
}
var initHeadMenu = function(){
	if(isLowIE()){
		
        $.template('leftMenuTpl',leftMenuTpl2);
        $.template('otherMenuTpl',otherMenuTpl2);       
    }else{
        $.template('leftMenuTpl',leftMenuTpl);
        $.template('otherMenuTpl',otherMenuTpl);
    }
    resizeCenter();
    renderMenu(screen.availWidth);
    $(window).resize(function(){
        if (!IsSideMenu) renderMenu($(document).width());
    });
    //缓存医嘱项信息
    //setTimeout(loadOrderEntry,3000);
}
var initSideMenu=function(){
    websys_createWindow("websys.frames.csp","TRAK_main","");
}
var resizeCenter = function (){
    /* 2018-08-30 chenying IE下左侧头部菜单 生成的元素里有 <LI></LI>空元素，导致菜单显示往下，空间不对*/
	var listli = $("#left-menu").find("li");
    for(var i=0,j=listli.length;i<j;i++){
        if($("#left-menu li").eq(i).html()=="")
        {
	        $("#left-menu li").eq(i).remove();
        }
    }
    
    /* chenying 20180418 修改下面菜单top值 */
    var menuHeight = $("#menuPanel").height();
    var docHeight = $(window).outerHeight();//$(document).height(); 20181126  浏览器窗口变化时 界面高度随着变化。 chenying
    $("#centerPanel").height(docHeight-menuHeight).css("top",menuHeight)
}
/************chenghegui 悬浮显示菜单****************/
var CreateSecondAndTridMenu = function(){
    var MenuHtml=$.m({ClassName:"web.DHCBL.BDP.BDPMenuDefine",MethodName:"CreateSecondAndTridMenu"},false);
    $("#navbox").html(MenuHtml);  
}
/**********************chenghegui 判断浏览器及版本*************************/
//获取浏览器
	getBrowserAndVersion=function(){
        var Sys = {};
        var ua = navigator.userAgent.toLowerCase();
        var s;
        (s = ua.match(/msie ([\d.]+)/)) ? Sys.ie = s[1] :
        (s = ua.match(/firefox\/([\d.]+)/)) ? Sys.firefox = s[1] :
        (s = ua.match(/chrome\/([\d.]+)/)) ? Sys.chrome = s[1] :
        (s = ua.match(/opera.([\d.]+)/)) ? Sys.opera = s[1] :
        (s = ua.match(/version\/([\d.]+).*safari/)) ? Sys.safari = s[1] : 0;
 
        //获取浏览器版本   
        var browerInfo="" 
        if(Sys.ie) browerInfo='IE:'+Sys.ie;   //非IE11
        else if(Sys.firefox) browerInfo='Firefox:'+Sys.firefox;
        else if(Sys.chrome) browerInfo='Chrome:'+Sys.chrome;
        else if(Sys.opera) browerInfo='Opera:'+Sys.opera;
        else if(Sys.safari) browerInfo='Safari:'+Sys.safari;
        else if((ua.indexOf('trident')>-1)&&(ua.indexOf("rv:11.0")>-1))  //("ActiveXObject" in window)
        {
            browerInfo="IE:11"
        }
        else
        {
            browerInfo=""
        }
		return browerInfo;
	}
var Initbox =function()
{
    //$(".now").parent().addClass("opennow");
    var time = null;
    var list = $("#left-menu");
    var box = $("#navbox");
    var lista =list.find("a");
   
    var browerInfo=getBrowserAndVersion();
    var box_show = function(hei){
        box.stop().animate({
            height:hei,
            opacity:1
        },400);
		if((browerInfo.indexOf("IE")!=-1)&&(browerInfo!="IE:11")){
			box.show();
		}
    }
    
    var box_hide = function(){
        box.stop().animate({
            height:0,
            opacity:0
        },400);
		if((browerInfo.indexOf("IE")!=-1)&&(browerInfo!="IE:11")){
			box.hide();
		}
    }
   
    //头菜单上的知识库菜单hover事件
    lista.hover(function(){
     	
	    $(this).parent().addClass("opennow");
        //lista.parent().removeClass("opennow");
        //lista.removeClass("now");
        $(this).addClass("now");
        clearTimeout(time);
        var index = list.find("a").index($(this));
        box.find(".cont").hide().eq(index).show();
        var _height = box.find(".cont").eq(index).height()+54;
        box_show(_height)
    },function(){
    	time = setTimeout(function(){   
            box.find(".cont").hide();
            box_hide();
        },50);
        for(var i=0,j=lista.length;i<j;i++){
	        lista.eq(i).parent().removeClass("opennow");
	        lista.eq(i).removeClass("now");
	        
	    }
	       
    });
    
    ///头菜单上的知识库菜单的第二级第三级菜单
    ///不能加在cont上是因为鼠标放到滚动条上面板会消失  chenying2019-08-01
    box.hover(function(){
	    clearTimeout(time);
        $(this).show();
        var _height = $(this).height()+54;
        box_show(_height);
    },function(){
	    time = setTimeout(function(){       
            $(this).hide();
            box_hide();
        },50);
        
    });
    
    box.find(".cont").hover(function(){
	    for(var i=0,j=lista.length;i<j;i++){
	        lista.eq(i).parent().removeClass("opennow");
	        lista.eq(i).removeClass("now");
	    }
        var _index = box.find(".cont").index($(this));
        lista.eq(_index).parent().addClass("opennow");
        lista.eq(_index).addClass("now"); 
    },function(){
        for(var i=0,j=lista.length;i<j;i++){
	        lista.eq(i).parent().removeClass("opennow");
	        lista.eq(i).removeClass("now");     
	    }
    });
    
    
    $(".mcate-item-bd").find("a").click(function(e){   //点击后隐藏显示的box
            $("#navbox").stop().animate({
            height:0,
            opacity:0
        },100)
		if((browerInfo.indexOf("IE")!=-1)&&(browerInfo!="IE:11")){
			$("#navbox").hide();
		}
      }
    );
}
    
var init = function (){
    if (IsSideMenu){
        initSideMenu();

    }else{
        initHeadMenu();
    }
    //chenghegui 悬浮显示菜单
   	//CreateSecondAndTridMenu();
    Initbox();
    // 头菜单事件
    addHeadMenuListeners();
    if(isLowIE()){
        $(".dropdown-menu .divider").addClass("divider-ie");
    }
    // 显示消息数量
    //ShowDHCMessageCount();    
    // 让.modal居中
    $('.modal').on('show.bs.modal', centerModals);
    
    $(window).resize(function(){
        resizeCenter();
    });
    resizeCenter();
    var iconOutHeight = $(".pull-right li.dhc-menu a.rightMainMenu").outerHeight();
	if (iconOutHeight>50){ //IE11兼容模式下高度算法不对,
		// 标准width是=padding+a的高度 
		// ie a.width=50px 后, a的实际高度为 50+paddingTop+paddingBottom
		$(".pull-right li.dhc-menu a.rightMainMenu").height(100-iconOutHeight);
	}
	
	
}
$(init);
