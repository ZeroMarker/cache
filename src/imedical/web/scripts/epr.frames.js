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
		tmp = t.parent();		//li
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
/*center.modal*/
var showConfig = function(){
	var content = "û��������Ϣ",dw=300,dh=300, title="����",url="";
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
	showModal("#WinModalEasyUI",url,{title:title,content:content,width:dw,height:dh});
}
var showHelp = function(){
	var fdom = $("#WinModal").find("iframe").get(0);
	if(fdom && fdom.src && fdom.src.indexOf("/html/help/")>-1){
		$("#WinModal").modal("show");
	}else{
		var m = frames["TRAK_main"], dw=700, dh=500;
		var groupId= session['LOGON.GROUPID'];
		var groupDesc = session['LOGON.GROUPDESC']
		var url = "../html/help/CH/G"+groupId+".html"
		$.ajax({
			url:url,
			success:function(rtn){
				showModal("#WinModalEasyUI",url,{title:'�����ĵ�',width:dw,height:dh,minimizable:true,maximizable:true});
			},
			error:function(data,textStatus){
				if (data.status==404){
					//url = "websys.help.csp?helpCode=G"+groupId
					showModal("#WinModalEasyUI","",{title:'�����ĵ�',content:"û���ҵ�"+session['LOGON.GROUPDESC']+"��صİ����ļ�!<br>����ϵ����Ա!",width:dw,height:dh});
				}
			}
		})
	}
	return false;
}
function copyFn(id){
	var val = document.getElementById(id);
	window.getSelection().selectAllChildren(val);
	document.execCommand("Copy");
	$.messager.popover({msg:"���ƻ�����ɹ�",type:"success"});
	window.getSelection().removeAllRanges();
}
//����
var aboutDiv = "<div style='width:430px;height:290px;border-bottom:1px solid #CCCCCD;'>"
	+"<div style='float:left;width:150px;height:290px;padding:50px 30px 30px 30px;'>"
		+"<img src='../skin/default/images/websys/aboutlogo.png'/>"
	+"</div>"
	+"<div style='float:left;width:270px;height:290px;' class='aboutbody'>"
		+"<img src='../skin/default/images/websys/logo.png'/ style='margin:10px 0px 10px 0px;'>"
		+"<ul style='font-size:13px;'>"
			+"<li>��Ʒ���ƣ�"+LicPrj+"</li>"
			+"<li>��Ʒ�汾��"+LicVer+"</li>"
			+"<li>��������Ȩ���ͣ�"+LicVerSummary+"</li>"
			+"<li>��������Ȩ��ֹ���ڣ�"+LicExpDate+"</li>"
			+"<li>��������Ȩʹ�õ�λ��"+LicUserName+"</li>"
			+"<li>��������Ȩ��;��"+LicUseType+"</li>"
			+"<li>���ģ�������Ȩ��"+ModelLicType+"</li>"
			+"<li><a title=\"������ƻ�����\" href=\"#\" onclick=\"copyFn('EncCmpCodeSpan');\">������</a>��<span style=\"font-size:10px;\" id=\"EncCmpCodeSpan\">"+EncryptCmpCode+"</span></li>"
		+"</ul>"
	+"</div></div>"
	+"<div class='aboutfooter'>"
		+"<span style='font-size:10px;' class='glyphicon glyphicon-copyright-mark'></span>"
		+CurYear+" ����ҽΪ�Ƽ����޹�˾��Ȩ����"
	+"</div>";
var showAbout = function(){	
	showModal("#WinModalEasyUI","",{title:'����iMedical',content:aboutDiv,width:460,height:362});
	return false; 
}
/**
* ʹҳ��������.modalԪ���ڴ��ڿ��ӷ�Χ֮�ھ���
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
	var width = 400, height=400 , top=200 ,left=300, title = "�Ի���!" ,showbefore = null,showafter=null,content="������";
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
	var urlFlag=false;
	if(url){
		urlHtml = '<iframe src="" width="100%" height="100%" scrolling="auto" marginwidth=0 marginheight=0 frameborder="no" framespacing=0></iframe>';
		urlFlag=true;
	}else{
		urlHtml = content;
	}
	var modalJObj = $(target);
	//modalJObj.find(".modal-footer").hide();
	modalJObj.find(".modal-title").html(title);
	modalJObj.find(".modal-content").css({width:width});		
	modalJObj.find(".modal-body").css({width:width,height:height}).html(urlHtml); //
	
	modalJObj.off('shown.bs.modal').on('shown.bs.modal', function () {
	  //console.log(new Date());
	  if (urlFlag) modalJObj.find('.modal-body>iframe').attr('src',url);
	})
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
			t.find("span").html(iconVolumeOnText);
			EnableMsgAudio = false;
		});
	}else{
		$.ajaxRunServerMethod({ClassName:"websys.DHCMessageConfig",MethodName:"EnableMsgAudio",UserId:session["LOGON.USERID"]},function(){
			iconI.addClass("icon-volume-up").removeClass("icon-volume-off");
			t.find("span").html(iconVolumeOffText);
			EnableMsgAudio = true;
		});
	}
}
/*����ģ̬��*/
var hidenModalEasyUI = function(){
	$("#WinModalEasyUI").window('close');
}
var showModalEasyUI = function(url, opt){
	opt = $.extend({url:url,isTopZindex:true},opt);
	websys_showModal(opt); //����ʵ������websys.js,top�ϴ򿪴���
	return ;
}
var renderingMenuFlag = false;  //�Ƿ�����render menu
var genHeaderMenuHtml = function(menuJson,isSubMenu){
	var arr = [];
	var rs = menuJson.records || menuJson;
	for (var i=0;i<rs.length;i++){
		var r1 = rs[i];
		arr.push('<li class="');
		if (r1.children) {
			arr.push(' dhc-menu');
			if (isSubMenu===1) arr.push(' dropdown-submenu');
		}
		arr.push('">');
		arr.push('<a data-ilink="'+r1.link+'" data-itarget="'+r1.target+'"  data-iblankOpt="'+r1.blankOpt+'" href="javascript:void(0)" data-target="#" ');
		arr.push(' class="');
		if (isSubMenu===1) arr.push(' dropdown-toggle')
		if (!r1.children) arr.push(' dhc-submenu');
		arr.push('">'+r1.text);
		if (r1.children && isSubMenu===0) arr.push('<b class="caret"></b>');
		arr.push('</a>');
		if (r1.children) {
			if (isLowIE()) arr.push('<b class="caret-in"></b>');    //����ͼ����ͨ��afterʵ�ֵ�,IE8�����Ǽ�ͷ��ʾ����,��ʾ����b
			arr.push('<ul class="dropdown-menu">');
			if (typeof GroupShowPanelMenu!="undefined" && GroupShowPanelMenu==1 && 1<getMenuDeepLevel(r1.children)){
				arr.push(genPanelMenuHtml(r1.children)); //2Ϊ���˵�mouse����ʱ�������˵�
			}else{
				arr.push(genHeaderMenuHtml(r1.children,1)); 
			}
			arr.push('</ul>');
		}
		arr.push("</li>");
	}	
	return arr.join("");
}
var genOtherMenuHtml = function(menuJson,isSubMenu){
	var arr = [];
	arr.push('<li class="dhc-menu" ><a href="javascript:void(0)">'+OtherMenuTan+'<b class="caret"></b></a><ul class="dropdown-menu">');
	if (typeof GroupShowPanelMenu!="undefined" && GroupShowPanelMenu==1 && 1<getMenuDeepLevel(menuJson.records)) {
		arr.push(genPanelMenuHtml(menuJson.records)); //2Ϊ���˵�mouse����ʱ�������˵�
	}else{
		arr.push(genHeaderMenuHtml(menuJson,1));
	}
	arr.push('</ul></li>');
	return arr.join("");
}
var renderMenu = function(posWidth){
	if (renderingMenuFlag) return false;
	renderingMenuFlag = true;
	var leftPullWidth = $(".navbar-container .pull-left").width();   // imedical logo
	var rightPullWidth = $(".navbar-container .pull-right").width(); // sys menu
	//menu max width
 	var HEADERMENUWIDTH = posWidth - rightPullWidth - leftPullWidth ; //posWidth * 0.75;
 	//menu china word length;
 	var WORDPX = 17			  // һ�����ֵĿ� wordpx(px)
 	var menuItemPaddingPX = 4/5
 	var menuHeaderNum = menuItemPaddingPX;  // menu padding �Ǻ��ֵ�2/3*wordpx(px)
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
	var headerMenuHtml =  genHeaderMenuHtml(leftMenuJson.left,0);// $.tmpl("leftMenuTpl",leftMenuJson.left);//
	$("#left-menu").html("").prepend(headerMenuHtml);
	if (leftMenuJson.other.records && leftMenuJson.other.records.length>0){
		var otherMenuHtml = genOtherMenuHtml(leftMenuJson.other,0); //$.tmpl("otherMenuTpl",leftMenuJson.other);
		$("#left-menu").append(otherMenuHtml);
	}
	// resize�¼�,��ֹƵ����Ⱦͷ�˵�
	setTimeout(function(){renderingMenuFlag = false;},100);
}
var isLowIE=function(){     //�Ͱ汾IE�ж� �ĸ��汾�����˵ ��ʱ��Ϊ��Щ����
	if(navigator.userAgent.indexOf("MSIE")>0){   
      if(navigator.userAgent.indexOf("MSIE 6.0")>0){   
        //alert("ie6");
        return true;    
      }   
      if(navigator.userAgent.indexOf("MSIE 7.0")>0){  
        //alert("ie7");  
        return true;   
      }   
      if(navigator.userAgent.indexOf("MSIE 9.0")>0 && !window.innerWidth){//�������ص�
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
var gCacheData = {}; //��������
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
		timeoutLoadOrderHandlerId =	setTimeout(loadOrderEntry,500);
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
function insertFrame(t){
	if(!!window.ActiveXObject || "ActiveXObject" in window){   
		if (t.find("iframe").length>0){}else{ // ie�µ��Ӳ���zindex
			var prop = function (n){return n&&n.constructor==Number?n+'px':n;}
			t.find("ul").each(function(){
				var t1 = $(this);
				var str = '<iframe frameborder="0" tabindex="-1" src="javascript:false;" style="display:block;position:absolute;z-index:-1;filter:Alpha(Opacity=0);opacity:0;';
				str += 'top:0px;left:0px;width:'+prop(t1.css("width"))+';height:'+prop(t1.css("height"))+';"/>';
				t1.append(str);
			});
		}
	}
}
function checkEditorFrame(){
	if (!!window.ActiveXObject || "ActiveXObject" in window) return ;
	windowNPAPITotal=200;
	if ($(".navbar-nav>li.dhc-menu.hover").length>0){
		findEditorFrame(window,true);
	}else{
		findEditorFrame(window,false);
	}
}
/*function findEditorFrame(win,toHide){
    if (!!window.ActiveXObject || "ActiveXObject" in window) return ;
    if (windowNPAPITotal<0) return ;
    windowNPAPITotal--;
    try{win.document;}catch(e){ return ;}
    var frm = win.document.getElementById("editorFrame");
    if (frm){
	    if (null == frm.getAttribute('data-hideTimes')) frm.setAttribute('data-hideTimes',0);
	    if(toHide){
		    frm.setAttribute('data-hideTimes',parseInt(frm.getAttribute('data-hideTimes'))+1);
		    //console.log("hover=> "+parseInt(frm.getAttribute('data-hideTimes')));
	    	if (frm.style.display!='none') {frm.style.display = "none";}
	    }else{
		    frm.setAttribute('data-hideTimes',parseInt(frm.getAttribute('data-hideTimes'))-1);
		    //console.log("leave=> "+parseInt(frm.getAttribute('data-hideTimes')));
	    	if (frm.getAttribute('data-hideTimes')==0){frm.style.display = 'block';}
	    }
    }else{
        var count = win.frames.length;
        for (var i=0; i<count; i++){
            var tmpWin = win.frames[i].window;
            findEditorFrame(tmpWin,toHide);
        }
    }
}*/
function findEditorFrame(win,toHide){
    if (!!window.ActiveXObject || "ActiveXObject" in window) return ;
    if (windowNPAPITotal<0) return ;
    windowNPAPITotal--;
    var count = win.frames.length;
    for (var i=0; i<count; i++){
		if(!win.frames[i]) continue; //�п���undefined
        var tmpWin = win.frames[i].window;
        try{tmpWin.document;/*runqian corss*/}catch(e){ return ;}
        var tmpObjList = tmpWin.document.querySelectorAll('OBJECT');
        if (tmpObjList.length>0){
            for(var j=0;j<tmpObjList.length; j++){
                if ("undefined"==typeof tmpObjList[j].attributes['type']) continue;
                if ("application/x-iemrplugin"!=tmpObjList[j].attributes['type'].value.toLowerCase()) continue; //tmpObjList[j].type
                var frm = tmpWin.frameElement; changeId=frm.id;
                if (frm) {
                    if (null == frm.getAttribute('data-hideTimes')) frm.setAttribute('data-hideTimes',0);
                    if (0>frm.getAttribute('data-hideTimes')) frm.setAttribute('data-hideTimes',0);
                    if(toHide){
                        frm.setAttribute('data-hideTimes',parseInt(frm.getAttribute('data-hideTimes'))+1);
                        //console.log(options.changeIdStr+"panel open => "+frm.getAttribute('data-hideTimes'));
                        if (frm.style.display!='none'){
                            frm.style.display = "none";
                        }
                    }else{
                        frm.setAttribute('data-hideTimes',parseInt(frm.getAttribute('data-hideTimes'))-1);
                        //console.log(options.changeIdStr+" panel close => "+frm.getAttribute('data-hideTimes'));
                        if (frm.getAttribute('data-hideTimes')==0){
                            frm.style.display = 'block';
                        }
                    }
                }
            }
        }
        findEditorFrame(tmpWin,toHide);
    }
}
/**
	��������˵����
*/
function getMenuDeepLevel(myArr,deepLevel){
	if (deepLevel>99) return deepLevel;
	deepLevel = deepLevel||1;
	for (var j=0; j<myArr.length; j++){
		var ch1 = myArr[j];
		if (ch1.children && ch1.children.length>0){
			deepLevel = 1+getMenuDeepLevel(ch1.children,deepLevel);
		}
	}	
	return deepLevel;
}
// ֻ��������ʽ�˵�
function genDropDownSubMenu(arr,verticalNo){
	if (!arr.children){
		return '<li class="dhc-menu">'
		+'<a class="dhc-submenu" data-ilink="'+arr.link+'" data-itarget="'+arr.target+'" data-iblankOpt="'+arr.blankOpt+'" href="javascript:void(0)" data-target="#">'
		+arr.text+'</a></li>'
	}
	var html=[];
	var list = arr.children;
	for(var k=0;k<list.length;k++){
		var item = list[k];
		html.push('<li class="dhc-menu')
		if (item.children) html.push(' dropdown-submenu');
		html.push('">');
		html.push('<a data-ilink="'+item.link+'" data-itarget="'+item.target+'" data-iblankOpt="'+item.blankOpt+'" href="javascript:void(0)" data-target="#" ')
		if (!item.children) html.push(' class="dhc-submenu" ')
		//if (item.text.length>9) html.push(' style="font-size:11px;"')
		html.push('>');
		if (isLowIE() && item.children) html.push('<b class="pm-caret-in"></b>')
		html.push(item.text+'</a>');
		if (item.children) {
			html.push('<ul class="dropdown-menu" style="');

			
			if (verticalNo>6){
				html.push('bottom: 0;top: auto;'); /*more bottom sub menu */
			}
			if (k%4==3){
				html.push('left: auto;right:100%;'); /*more right sub menu */
			}
			html.push('">');
			html.push(genDropDownSubMenu(item,verticalNo));
			html.push('</ul>');
		}
		html.push("</li>");
	}
	return html.join('');
}
/**�����˵�*/
function genPanelMenuHtml(ch){
	var html = '<div class="box headerpanelmenu"><div class="cont"><ul class="sublist">';
	for (var j=0; j<ch.length; j++){
		html += "<li>"
		+'<div class="ltitlebox">'
		+'<h3 class="ltitle">'+ch[j].text+'</h3>'
		+'</div>'
		+'<div class="lbody"><ul>'
		html+=genDropDownSubMenu(ch[j],j);
		html+='</ul></div>'
		html+="</li>"
	}
	html += '</ul></div></div>';
	return html;
}
/**
* ͷ�˵��¼�
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
	// toggleClass-->addClass  ie�� ������ڷ�ͷ�˵�λ�ó���������ͷ�->�϶���굽�ж����˵���ͷ�˵�λ��->�ͷ�����������ʱ�����˵�չ�����˵���hide
	$(".navbar-container").on("mouseenter",".navbar-nav>li.dhc-menu",function(){
		var t = $(this);
		t.addClass('hover');
		checkEditorFrame();
		if (t.find("a.rightMainMenu").length==0){
			if (t.find("ul.dropdown-menu")){  
				t.addClass('open');
			}else{  
				t.addClass('active');
			}
			if (t.find('.box').length>0){
				var boxWidth = 800;
				var screenWidth = screen.availWidth;
				var maxLeft = screenWidth-800;
				var xy = t.find('.box').offset();
				if (xy.left>maxLeft) t.find('.box').offset({left:maxLeft});
			}
			insertFrame(t);
			return false;
		}
	}).on('click',".navbar-nav>li.dhc-menu",function(){
		var t = $(this);
		if (t.find("a.rightMainMenu").length>0){
			if (t.find("ul.dropdown-menu")){  
				t.addClass('open');  
			}else{  
				t.addClass('active');
			}
			insertFrame(t);
		}
	}).on("mouseleave",".navbar-nav>li.dhc-menu",function(){
		var t = $(this);
		t.removeClass('hover');
		if (t.find("ul.dropdown-menu")){
			t.removeClass('open');   
		}else{  
			t.removeClass('active')
		}
		checkEditorFrame()
		return false;
	});

	$("#menuPanel").delegate('.dhc-submenu',"click",function(event){
		var DoingSthDesc = $("#DoingSth").val();
		if (DoingSthDesc!=""){
			$.messager.alert("��ʾ",DoingSthDesc);
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
		groupMutilTabMenu = groupMutilTabMenu||0;
		if (imodal!="true" && groupMutilTabMenu==1){
			blankOpt += ",addTab=1" ;
			blankOpt += ",title="+$.trim(t.text());
			blankOpt += ",closable=true";
			blankOpt += ",code="+$.trim(t.text());
		}
		if (href=="#") {
			event.preventDefault();
			event.stopPropagation(); 
			return false;
		}
		if (target=="_blank"){
			isModifyStyle = false
		}
		if (href=="javascript:void(0)") {
			event.preventDefault();
			event.stopPropagation(); 
			return false;
		}
		// ����ѡ����ʽ
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
	/*if(isLowIE()){
		$.template('leftMenuTpl',leftMenuTpl2);
		$.template('otherMenuTpl',otherMenuTpl2);		
	}else{
		$.template('leftMenuTpl',leftMenuTpl);
		$.template('otherMenuTpl',otherMenuTpl);
	}*/
	resizeCenter();
	renderMenu(screen.availWidth);
	$(window).resize(function(){
		if (!IsSideMenu) renderMenu($(document).width());
	});
	//����ҽ������Ϣ
	setTimeout(loadOrderEntry,3000);
}
var initSideMenu=function(){
	websys_createWindow("websys.frames.csp","TRAK_main","");
}
var resizeCenter = function (){
	var menuHeight = 50; //$("#menuPanel").height();
	var docHeight = $(window).outerHeight();//$(document).height(); 20180910
	$("#centerPanel").height(docHeight-menuHeight).css("top",menuHeight)
}
function soundCloseMsgWindow(){
	$("#MessageWin").window("close");
}
function soundOpenOrderDoc(){
	$("#menuPanel .dhc-submenu").each(function(ind,item){
		if ($(this).html()=="ҽ����"){
			$(this).click();
			return ;
		}
	});
}
function soundOpenEMR(){
	$("#menuPanel .dhc-submenu").each(function(ind,item){
		if ($(this).html()=="�������"){
			$(this).click();
			return ;
		}
	});
}
var init = function (){
	if (IsSideMenu){
		initSideMenu();
	}else{
		initHeadMenu();
	}
	// ͷ�˵��¼�
	addHeadMenuListeners();
	if(isLowIE()){
		$(".dropdown-menu .divider").addClass("divider-ie");
	}
	// ��ʾ��Ϣ����
	ShowDHCMessageCount();	
	// ��.modal����
	$('.modal').on('show.bs.modal', centerModals);
	
	$(window).resize(function(){
		resizeCenter();
	});
	resizeCenter();
	//�ӽ���href="#"���� �˵���������  �������������¼�,��������
	$('#centerPanel').scroll(function(){	
		if ($('#centerPanel').scrollTop()>0 ) $('#centerPanel').scrollTop(0);
	})

	var iconOutHeight = $(".pull-right li.dhc-menu a.rightMainMenu").outerHeight();
	if (iconOutHeight>50){ //IE11����ģʽ�¸߶��㷨����,
		// ��׼width��=padding+a�ĸ߶� 
		// ie a.width=50px ��, a��ʵ�ʸ߶�Ϊ 50+paddingTop+paddingBottom
		$(".pull-right li.dhc-menu a.rightMainMenu").height(100-iconOutHeight);
	}
}
$(init);