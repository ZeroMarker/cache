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
	var iconCls = 'icon-w-setting';
	if (m && m.getConfigUrl){
		var cfg = m.getConfigUrl.call(this,session["LOGON.USERID"],session["LOGON.GROUPID"],session["LOGON.CTLOCID"]);
		if (cfg) {
			title = cfg.title || title;
			dw = cfg.width || dw;
			dh = cfg.height || dh;
			url = cfg.url;
			iconCls = cfg.iconCls||iconCls;
		}
	}
	showModal("#WinModalEasyUI",url,{title:title,content:content,width:dw,height:dh,iconCls:iconCls});
}
var dtsBtnClickHandler = function(){
	var lnk = "http://49.7.113.114:8010/flow/flowBos/index";
	//lnk = "http://49.7.113.114:8010/flow/flowBos/hisIndex";
	var param = [];
	// PostDictCode
	var postCode = session['LOGON.ACCPOSTCODE']||"dts2023.0446-ITH0302-20-00002";
	param.push("windowId=a64fe0e827414105b514e47ee22706c3");
	param.push("assemblyType=link");
	param.push("showTitle=true");
	param.push("userCode="+session['LOGON.USERCODE']);
	param.push("postDictCode="+PostDictCode);
	param.push("postCode="+postCode);
	param.push("buCode="+LocCode);
	param.push("orgCode=001-00020066");
	param.push("assemblyCode=DTS_FLOW");
	param.push("freeLoginType=ZHIANTECHNFC");
	param.push("freeToken=UORQENFUOAJNEONJGOQONGQ");
	lnk +="?"+param.join("&");
	if ('undefined'!=typeof cefbound){
		exec('"%LOCALAPPDATA%\\Google\\Chrome\\Application\\chrome.exe" '+lnk.replace(/&/g,'^&'));
	}else{
		//&orgCode=001-00020066&assemblyCode=DTS_FLOW&freeLoginType=ZHIANTECHNFC&freeToken=UORQENFUOAJNEONJGOQONGQ
		websys_createWindow(lnk,"top=100");
		//showModalEasyUI(lnk,{targetName:'top'});
	}
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
					$.ajax({
						url:"../html/help/CH/G"+groupId+".pdf",
						success:function(rtn){
							window.open("../html/help/CH/G"+groupId+".pdf");
						},
						error:function(data,textStatus){
							if (data.status==404){
								//url = "websys.help.csp?helpCode=G"+groupId
								showModal("#WinModalEasyUI","",{title:'�����ĵ�',content:"û���ҵ�"+session['LOGON.GROUPDESC']+"��صİ����ļ�!<br>����ϵ����Ա!",width:dw,height:dh});
							}
						}
					})
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
var aboutDiv = "<div class='aboutMiddle'>"
	+"<div class='aboutMiddle-left-top'>"
	+"</div>"
	+"<div class='aboutMiddle-left-mid'>"
	+"</div>"
	+"<div class='aboutbody'>"		
		+"<ul class='aboutul'>"
			+"<li>��Ʒ���ƣ�"+LicPrj+"</li>"
			+"<li>��Ʒ�汾��"+LicVer+"</li>"
			+"<li>��������Ȩ���ͣ�"+LicVerSummary+"</li>"
			+"<li>��������Ȩ��ֹ���ڣ�"+LicExpDate+"</li>"
			+"<li>��������Ȩʹ�õ�λ��"+LicUserName+"</li>"
			+"<li>��������Ȩ��;��"+LicUseType+"</li>"
			+"<li>���ģ�������Ȩ��"+ModelLicType+"</li>"
			+"<li><a title=\"������ƻ�����\" href=\"#\" onclick=\"copyFn('EncCmpCodeSpan');\">������</a>��<span style=\"font-size:10px;\" id=\"EncCmpCodeSpan\">"+EncryptCmpCode+"</span></li>"
		+"</ul>"
		+"<div class='aboutMiddle-bottom'>"
		+"<div class='aboutfooter'>"
		+CurYear+" ����ҽΪ�Ƽ����޹�˾��Ȩ����"
		+"</div></div>"
		+"</div>"		
	+"<div class='abouBottom'>"
	+"</div>";
var showAbout = function(){
	var w = 493,h = 443,iconCls="icon-w-paper"; 
	if ("undefined"!=typeof HISUIStyleCode && window.HISUIStyleCode=="lite"){
		w = 917,h = 635;
		iconCls="";
	}		
	showModal("#WinModalEasyUI","",{targetName:"top",title:'����',content:aboutDiv,width:w,height:h,iconCls:iconCls});
	return false; 
}
/**
* cfg :{
	onclick: funstr,
	id:id,
	icon:icon	
  }
*/
function renderRightIconMenu(cfg){
	var t = $("#"+cfg.id);
	if (t.length>0){
		return t;
	}else{
		var h = '<li class="dhc-menu"><a id="'+cfg.id+'" href="#" data-ilink="javascript:'+cfg.onclick+'();" class="rightMainMenu dhc-submenu">'
		+'<span class="dhc-fa-icon-large " style="font-size:23px;background-image:url('+cfg.icon+')" aria-hidden="true"></span></a></li>'
		$(".pull-right .navbar-nav").prepend(h);
		return $("#"+cfg.id);
	}
	//t = $("#toggleAllowSecondScreenA");
}
var showCAAbout = function(){
	var caStr = dhcsys_getContainerNameAndPin();
	var arr = caStr.split("^");
	obj = {IsSucc:false,ContainerName:"",IsCA:true,CALogonType:"",CAUserCertCode:"",CACertNo:"",CAToken:"",UserID:"",UserName:""};
	if (arr[0]!==""){
		obj.IsSucc=true, obj.ContainerName=arr[0]||"";
		obj.CALogonType=arr[2]||"", obj.CAUserCertCode=arr[3]||"";
		obj.CACertNo=arr[4]||"",obj.CAToken=arr[5]||"", obj.UserID = arr[6]||"";
		obj.UserName=arr[7]||"",obj.IsCAReLogon=true;
		obj.Imagebase64=arr[8]||"" //w ##class(CA.BICAService).GetImageByCert(UserCertCode,CertNo)
	}	
	//����
	var caAboutDiv = "<div style='width:530px;height:290px;border-bottom:1px solid #CCCCCD;'>"
	+"<div style='float:left;width:200px;height:290px;padding:20px 30px 30px 30px;'>"
		+"<img src='../skin/default/images/websys/calogo.png'/>"
	+"</div>"
	+"<div style='float:left;width:270px;height:290px;' class='ca-aboutbody'>"
		//+"<img src='../skin/default/images/websys/logo.png'/ style='margin:10px 0px 10px 0px;'>"
		+"<div style='margin:0px 0px 0px 0px;'>&nbsp;</div>"
		+"<ul style='font-size:13px;'>"
			+"<li>֤�����������"+obj['UserName']+"</li>"
			+"<li>��ǰǩ��ͼƬ��<img style='width:80px;' src='data:image/png;base64,"+obj['Imagebase64']+"'/></li>"
			+"<li>��ǰ֤�����ͣ�"+obj['CALogonType']+"</li>"
			//+"<li>��������"+obj['ContainerName']+"</li>"
			+"<li>֤��Ψһ��ʶ��"+obj['CACertNo']+"</li>"
			+"<li>�û�Ψһ��ʶ��"+obj['CAUserCertCode']+"</li>"
			+"<li>�Ƿ���TOKEN��"+(obj['CAToken']!=""?"��":"��")+"</li>"
		+"</ul>"
	+"</div></div>";
	showModal("#WinModalEasyUI","",{title:'֤����Ϣ',content:caAboutDiv,width:530,height:340});
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
	var posWidth = (window.innerWidth||screen.availWidth) - eastPanelWidth;  // 20230116 ����Ӧ�÷���, ������������ 
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
		arr.push('<a data-icode="'+r1.code+'" data-ilink="'+r1.link+'" data-itarget="'+r1.target+'"  data-iblankOpt="'+r1.blankOpt+'" href="javascript:void(0)" data-target="#" ');
		arr.push(' class="');
		if (isSubMenu===1) arr.push(' dropdown-toggle')
		if (!r1.children) arr.push(' dhc-submenu');
		arr.push('">'+r1.text);
		if (r1.children && isSubMenu===0) arr.push('<b class="caret"></b>');
		if (r1.count&&r1.count>0) arr.push('<span class="dhc-menucount">'+r1.count+"</span>");
		if (r1.star) arr.push('<span class="dhc-menustar"></span>');
		
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
/*ͨ���Ӳ˵���Ϣ����,���㸸�˵���Ϣ����*/
var recalcParentMenuCount = function(marr){
	/*ÿ�����˵���ȡ����һ���Ӳ˵�������*/
	var myChildCountTotal = 0;
	for(var j=0;j<marr.length ;j++){
		var item = marr[j];
		if (item.children) {
			item.count = recalcParentMenuCount(item.children)||0; 
		}
		myChildCountTotal += parseInt(item.count||0);
	}
	return myChildCountTotal;
}
/*ͨ���Ӳ˵���,���㸸�˵���*/
var recalcParentMenuStar = function(marr){
	var star = false;
	for(var j=0;j<marr.length ;j++){
		var item = marr[j];
		if (item.children){
			item.star = recalcParentMenuStar(item.children);
			if (item.star) star = true;
		}else{
			if (item.star) star = true; // ��ʾ�Ӳ˵�������
		}
	}
	return star;
}
/*������Star*/
var handerMenuParentStar = function(hasStar,t){
	$(t).parents('li').children('a').each(function(){
		if(hasStar){
			if ($(this).find(".dhc-menustar").length==0) $(this).append('<span class="dhc-menustar"></span>');
		}else{
			$(this).find('.dhc-menustar').remove();
		}
	});
}
/*��������˵�Star*/
var handlerHelpMenuStar = function(hasStar,t){
	if (hasStar){
		$("#SystemHeaderMenuHelp .dhc-menustar").each(function(index,item){
			var myli = $(item).closest('li'); //�ų�����
			handerMenuParentStar(true,myli);  //����������Star
		});
	}else{
		// �������������Star
		handerMenuParentStar(false,t)
	}	
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
 	/*ͨ���ֱ��ʰѲ˵���ֵ�[����]�˵���*/
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
	/*�ϲ�����*/
	recalcParentMenuCount(leftMenuJson.left.records);
	recalcParentMenuCount(leftMenuJson.other.records);
	recalcParentMenuStar(leftMenuJson.left.records)
	recalcParentMenuStar(leftMenuJson.other.records);
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
			var itemSelector = "ul"; 
			if (t.find("ul>div.headerpanelmenu").length>0){itemSelector = "ul>div.headerpanelmenu";	}
			t.find(itemSelector).each(function(){
				var t1 = $(this);
				var str = '<iframe frameborder="0" tabindex="-1" src="javascript:false;" style="display:block;position:absolute;z-index:-1;filter:Alpha(Opacity=0);opacity:0;';
				str += 'top:0px;left:0px;width:'+prop(t1.css("width"))+';height:'+prop(t1.css("height"))+';"/>';
				t1.append(str);
			});
		}
	}
}
function checkEditorFrame(t){
	if (!!window.ActiveXObject || "ActiveXObject" in window) return ;
	if ('undefined'!=typeof MenuHoverHiddenEPREditorNum && t && t.length>0 && t.find("ul.dropdown-menu li").length<MenuHoverHiddenEPREditorNum) return ; //a.dhc-submenu
	handerEditorFrame($(".navbar-nav>li.dhc-menu.hover").length>0,t);
}
/// flag = trueʱΪ���ز���
function handerEditorFrame(flag,target){
	windowNPAPITotal=200;
	if (flag){
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
                var frm = tmpObjList[j], changeId=frm.id; //tmpWin.frameElement;
                if (frm) {
                    if (null == frm.getAttribute('data-hideTimes')) frm.setAttribute('data-hideTimes',0);
                    if (0>frm.getAttribute('data-hideTimes')) frm.setAttribute('data-hideTimes',0);
                    if(toHide){
                        frm.setAttribute('data-hideTimes',parseInt(frm.getAttribute('data-hideTimes'))+1);
                        //console.log("panel open => "+frm.getAttribute('data-hideTimes'));
                        frm.style.width = "0px";
                        frm.style.height = "0px";
                    }else{
                        frm.setAttribute('data-hideTimes',parseInt(frm.getAttribute('data-hideTimes'))-1);
                        //console.log(" panel close => "+frm.getAttribute('data-hideTimes'));
                        if (frm.getAttribute('data-hideTimes')==0){
                            frm.style.width = "100%";
                            frm.style.height = "100%";
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
		+'<a class="dhc-submenu" data-icode="'+arr.code+'" data-ilink="'+arr.link+'" data-itarget="'+arr.target+'" data-iblankOpt="'+arr.blankOpt+'" href="javascript:void(0)" data-target="#">'
		+arr.text
		+(arr.count&&arr.count>0?'<span class="dhc-menucount">'+arr.count+"</span>":"")
		+(arr.star?'<span class="dhc-menustar"></span>':'')
		+'</a></li>'
	}
	var html=[];
	var list = arr.children;
	for(var k=0;k<list.length;k++){
		var item = list[k];
		html.push('<li class="dhc-menu')
		if (item.children) html.push(' dropdown-submenu');
		html.push('">');
		html.push('<a data-icode="'+item.code+'" data-ilink="'+item.link+'" data-itarget="'+item.target+'" data-iblankOpt="'+item.blankOpt+'" href="javascript:void(0)" data-target="#" ')
		if (!item.children) html.push(' class="dhc-submenu" ')
		//if (item.text.length>9) html.push(' style="font-size:11px;"')
		html.push('>');
		if (isLowIE() && item.children) html.push('<b class="pm-caret-in"></b>')
		if (item.count&&item.count>0) html.push('<span class="dhc-menucount">'+html.count+"</span>");
		if (item.star) html.push('<span class="dhc-menustar"></span>')

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
@param {Function} cb �ص�����
@param {Object} param �����ص������Ĳ���
@param {string} okBtnTip
@param {String} noBtnTip
*/
function doingSthConfirm(cb,param,okBtnTip,noBtnTip){
	var DoingSthDesc = $("#DoingSth").val();
	if (DoingSthDesc!="") {
		if ((typeof window.DoingSthSureCallback == "function")||(typeof window.DoingSthCancelCallback == "function")){
			var oldOk = $.messager.defaults.ok;
			var oldNo = $.messager.defaults.no;
			$.messager.defaults.ok = okBtnTip;
			$.messager.defaults.no = noBtnTip;
			$.messager.confirm3("��ʾ",DoingSthDesc,function(r){
				if(r===true){
					if ("function"==typeof DoingSthSureCallback) {
						var cbRtn = DoingSthSureCallback();
						if (false===cbRtn) return false;
					}
				}else if(r===false){
					if ("function"==typeof DoingSthCancelCallback) {
						var cbRtn = DoingSthCancelCallback();
						if (false===cbRtn) return false;
					}
				}else{
					return false;
				}
				/*Ҫд�ڻص�������,�����ھɰ��¿��ܲ��ܻص�����*/
				$.messager.defaults.ok = oldOk;
				$.messager.defaults.no = oldNo;
				cb.call(this,param);
			}).children("div.messager-button").children("a:eq(2)").focus();;
			return ;
		}else{
			$.messager.alert("��ʾ",DoingSthDesc);
			event.preventDefault();
			event.stopPropagation();
			return ;
		}
	}else{
		cb.call(this,param);
	}
};
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
		checkEditorFrame(t);
		if (t.find("a.rightMainMenu").length==0){
			if (t.find("ul.dropdown-menu")){  
				t.addClass('open');
			}else{  
				t.addClass('active');
			}
			var dorpbox = t.find('.box');
			if (dorpbox.length>0){
				var boxWidth = 800;
				// 20230116 ����Ӧ�÷���, ������������ - eastPanelWidth;
				// 20230215 ���ǵ���������С��,��������ұ߲���ʾ, ��screen.availWidth�޸ĳ�ȡbody.clientWidth
				var screenWidth = window.document.body.clientWidth - eastPanelWidth;  //screen.availWidth - eastPanelWidth;
				var maxLeft = screenWidth-800;
				var xy = dorpbox.offset();
				if (xy.left > maxLeft) dorpbox.offset({ left: maxLeft });
				// ����box���в˵���,�Ҳ˵����������Ӳ˵�,��ʾ�߶ȳ���box�ĸ߶�ʱ,�Ӳ˵��鿴��ȫ���� [3270581] [3160922]
				dorpbox.on('mouseenter.boxsubdhcmenu', 'li.dhc-menu', function () {
					if (dorpbox.eq(0)[0].scrollHeight>(dorpbox.eq(0).innerHeight()+10)) dorpbox.css({height:dorpbox.eq(0)[0].scrollHeight+10});
				})
				/*var heightMenuItemNum = 60;
				var heightMenuItemMaxNum = heightMenuItemNum;
				t.find("ul.sublist>li").each(function (mind, mitem) { // 20220106 [2391511] �����˵�Ŀ¼
					$(mitem).find('ul>li.dhc-menu').each(function (rowInd,rowItem) { // �ұ��в˵�
						heightMenuItemNum = $(rowItem).offset().top;
						if ($(rowItem).find('ul>li.dropdown-submenu').length>0) heightMenuItemNum = parseInt(heightMenuItemNum) + (30 * $(rowItem).find('ul>li.dropdown-submenu').length);
					});
					//�����˵���ʾ�����߶�+���˵�top
				});
				if (heightMenuItemMaxNum>500) heightMenuItemMaxNum = 500;
				if (heightMenuItemMaxNum>heightMenuItemNum) t.find('.box').css({height:heightMenuItemMaxNum});
				*/
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
		t.find('.box').off('mouseenter.boxsubdhcmenu');
	}).on("mouseleave",".navbar-nav>li.dhc-menu",function(){
		var t = $(this);
		t.removeClass('hover');
		if (t.find("ul.dropdown-menu")){
			t.removeClass('open');   
		}else{  
			t.removeClass('active')
		}
		checkEditorFrame(t)
		t.find('.box').off('mouseenter.boxsubdhcmenu');
		return false;
	});

	$("#menuPanel").delegate('.dhc-submenu',"click",function(event){
		var t = $(this);
		var DoingSthDesc = $("#DoingSth").val();
		var blankOpt=t.attr("data-iblankOpt")||"";
		var href = t.attr("data-ilink")||"";
		var imodal = t.attr("data-imodal")||"";
		if (DoingSthDesc!="" && (blankOpt=="" || imodal=="true")) {
			doingSthConfirm(gotoMenuHref,t,'����','����');
			return;
		} 
		/*
		ͷ�˵�����������������˵�����Ϊ����λ�ÿ���Ļ���ϣ���ʱ�����˵������أ��������༭������״̬��
		�ڵ����ġ������������������������������˵������أ�����û�д���mouseleave,�������༭������ʾ��
		�޸İ취����˵���trigger-mouserleave�¼�
		
		20220624 imodalʱ�����ұ߲˵��������ڣ�������mouseleave (div-modal�ѵ���,Ȼ�󴥷���mouselevae,���²�����ǰ��)
		20220808 ����hisui����ʱ������mouseleave
		20220829 ����˳��, ��confrim3����ʱ������mouseleave
		*/
		if (imodal!="true" && blankOpt.indexOf("hisui=true")==-1 && href.indexOf("javascript:")==-1) t.closest("li.dhc-menu").trigger("mouseleave");
		gotoMenuHref(t);
		return true;
	});
}
function gotoMenuHref(t){
	var isModifyStyle = true;
	var href = t.attr("data-ilink");
	var target = t.attr("data-itarget");
	var blankOpt=t.attr("data-iblankOpt");
	var imodal = t.attr("data-imodal");
	var icode = t.attr("data-icode");
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
	
	if (t.find('.dhc-menustar').length>0){ //���ǺŲ˵�����
		//var menuId = href.split("TMENU=")[1].split('&')[0];
		$m({ClassName:"BSP.SYS.BL.MenuUserLog",MethodName:"ClickedCode",MenuCode:icode,UserId:session['LOGON.USERID']},function(txt){
			if (txt==1){
				t.find('.dhc-menustar').remove();
				var starCount = t.closest('ul.dropdown-menu').parent().find('.dhc-menustar').length;
				if (starCount==1){  // ֻ��һ����ʾ�ڸ��˵���,˵����ȫû��
					//t.closest('ul.dropdown-menu').parent().find('.dhc-menustar').remove();
					handlerHelpMenuStar(false,t);
				}
			}
		});
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
		window.resetSecondScreen({
			type:"clickwebsysmenu",
			targetName:"main",
			code:icode,
			originName:"epr.frames"
		})
		// 2021-06-06 ֻ��TRAK_main�д�ʱ����
		if (href.indexOf("?")==-1) href+="?";
		if (blankOpt=="") href += "&TMENUOPENFRM=main";
		websys_createWindow(href,target,blankOpt);
	}
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
	var headMenuWidth = (window.innerWidth||screen.availWidth)- eastPanelWidth; // 20230116 ����Ӧ�÷���, ������������
	/*�����layout������˵��ܿ��ʹ��Center��*/
	var hasCenterLayout = $(document.body).layout('panel',"center").length>0;
	if(hasCenterLayout){
		headMenuWidth = $(document.body).layout('panel',"center").panel('options').width;
	}
	// window.innerWidth��������������,screen.availwidth���������ؿ�=1024��1280��1366����¼��ͷ�˵���ʾ�����˵�����
	//console.log(" initHeadMenu "+headMenuWidth)
	renderMenu(Math.floor(headMenuWidth));
	if (hasCenterLayout){
		$(document.body).layout('panel',"center").panel("options").onResize = function(w,h){
			eastPanelWidth = (window.innerWidth||screen.availWidth) - w;  // �϶��ָ���ʱ�޸�ȫ�ֱ����Ŀ��
			renderMenu(w);
			
		};
	}else{
		$(window).resize(function(){
			if (!IsSideMenu) renderMenu($(document).width());
		});
	}
	//����ҽ������Ϣ
	setTimeout(loadOrderEntry,3000);
	if (window.HomePageUrl==""){
		$("#menuPanel a.dhc-submenu").eq(0).trigger('click');
	}
}
var initSideMenu=function(){
	websys_createWindow("websys.frames.csp","TRAK_main","");
}
var initHelpMenu = function(){
	var rows = HeaderMenuHelpJson.records;
	if (rows.length>0){
		var html = genHeaderMenuHtml(rows,1);
		$("#SystemHeaderMenuHelp").addClass('dropdown-submenu').addClass('dhc-menu').append('<ul class="dropdown-menu">'+html+'</ul>');
		
		if (html.indexOf('dhc-menustar')>-1){
			handlerHelpMenuStar(true,null);
		}
	}
}
var initCAInfoMenu = function(){
	if ("undefined"!=typeof LastCALogonType && LastCALogonType!=""){
		 renderRightIconMenu({id:"caInfoMenuA",onclick:"showCAAbout",icon:"../skin/default/images/ca_icon_white.png"});
	}else{
		try{
			Object.defineProperty(window,'LastCALogonType',{enumerable:true,configrable:true,	
				get:function(){ return window._LastCALogonType||"";},
				set:function(v){
					window._LastCALogonType=v;
					if("string" === typeof v && v!=""){
						renderRightIconMenu({id:"caInfoMenuA",onclick:"showCAAbout",icon:"../skin/default/images/ca_icon_white.png"});
					}
				}
			});
		}catch(exxx){}
	}
}
var eastPanelWidth = 0;
var resizeCenter = function (){	
	//var menuHeight = 36; //$("#menuPanel").height();
	var docHeight = $(window).outerHeight();//$(document).height(); 20180910
	var docWidth = $(window).outerWidth();//$(document).height(); 20180910
	// ���������,����Ӧ�÷���
	var epanel = $(document.body).layout('panel',"east");
	if (eastPanelWidth>0){
		if (epanel.length>0){
		}else{
			$(document.body).layout('add',{
				region:'east',
				title:'',
				width:eastPanelWidth,
				split:true,
				content:''
			});
			/*�ֶ���,һ��������ҽΪ�������,�����panel������iframeֻ�а�����*/
			var con = $(document.body).layout("panel",'east').panel("body");
			con.css('overflow','hidden');/* �ᵼ�³��ֹ�����*/
			con.html('<iframe name="TRAK_east" src="about:blank" width="100%" height="100%" scrolling="auto" marginwidth=0 marginheight=0 frameborder="no" framespacing=0></iframe>');
			websys_emit("onHISLogonSuccess",{usercode:session["LOGON.USERNAME"],viewCode:ViewCode,showHosTitle:showHosTitle});
		}
	}else{
		if (epanel.length>0) $(document.body).layout('remove',"east");
		if (showHosTitle=="false"){
			$(".pull-right .nav").find('.min-max-buttons').remove();
			$(".pull-right .nav").append('<li class="dhc-menu min-max-buttons"><a href="#" class="rightMainMenu" style="width:140px">&nbsp;</a></li>');
		}
	}
	/**/
	//$("#eastPanel").width(eastPanelWidth);
	//$("#centerPanel").width(docWidth-eastPanelWidth-6);
	//$("#menuPanel").width(docWidth-eastPanelWidth-6);
	$("#centerPanel").height(docHeight-menuHeight).css("top",menuHeight);
}
function soundOpenHeaderMenu(json){
	var text = json.command["origin_action"];
	if (text.indexOf("��")>-1){ text = text.replace('��','');}
	$("#menuPanel .dhc-submenu").each(function(ind,item){
		var mtext = $(this).html() ;
		mtext = mtext.replace(/[()\/-]/ig,"");
		if (mtext==text){
			$(this).click();
			return ;
		}
	});
}
function soundOpenMsgWindow(){
	$("#MessageWin").window("open");
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
function soundExitHisSystem(){
	try{
		window.opener = null;
		window.open("","_self");
		window.close();
	}catch(e){}
}
function sysSoundBtnClickHandler(){
	if (!window.SysSoundInstc){
		if ('function'==typeof initSoundWebSocket) {
			initSoundWebSocket();
		}else{
			$.messager.alert("��ʾ","δ����������������");
		}
	}
	if(window.SysSoundInstc){
		var $sysSound = $("#sysSountBtn");
		if ($sysSound.hasClass('record-open')){
			window.SysSoundInstc.stopRecording();
			$sysSound.removeClass('record-open')
		}else{
			window.SysSoundInstc.startRecording();
			$sysSound.addClass('record-open')
		}
	}
}
var MWScreens = {};
var MWSecondScreenWin = null;
var init = function (){
	/*if (IsSideMenu){
		initSideMenu();
	}else{
		initHeadMenu();
	}*/
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
	if (iconOutHeight>menuHeight){ //IE11����ģʽ�¸߶��㷨����,
		// ��׼width��=padding+a�ĸ߶� 
		// ie a.width=50px ��, a��ʵ�ʸ߶�Ϊ 50+paddingTop+paddingBottom
		$(".pull-right li.dhc-menu a.rightMainMenu").height(100-iconOutHeight);
	}
	initHelpMenu();
	initShortKey();
	initCAInfoMenu();
	if(CMgr.getScreens && !ReqDisabledMutilScreen){ /*��Ƕ�������ʾ����,������ʱΪ1*/
		CMgr.notReturn=1;
		CMgr.getScreens(function(obj){
			if ("object"==typeof obj){
				if (obj.rtn!=""){
					var myobj = JSON.parse(obj.rtn);
					var PrimaryScreenInfo = null;
					for(var s=0;s<myobj.screens.length;s++){
						if (myobj.screens[s].PrimaryScreen && s!=0){  //��0λ����������Ϣ
							PrimaryScreenInfo = myobj.screens.splice(s,1); 
						}
					}
					if (PrimaryScreenInfo) myobj.screens.splice(0,0,PrimaryScreenInfo[0]); //������������ʼλ��
					MWScreens = myobj;
					SetDisableSecondScreenByCfg(EnableMultiScreenDisplay);
					resizeCenter();
					initHeadMenu();
					websys_emit("onHISLogonSuccess",{usercode:session["LOGON.USERNAME"],viewCode:ViewCode,showHosTitle:showHosTitle});
					websys_emit("onHISLogonSuccess3",{usercode:session["LOGON.USERNAME"]});
				}
			}
		});
	}else{
		if (IsSideMenu){
			initSideMenu();
		}else{
			initHeadMenu();
		}
	}
	// ����Ƕ�뵽HOS������ʱ������ 20230301
	if ('undefined'!=typeof CreateChatForMultiDevice && CreateChatForMultiDevice==1){
		if (HosAssemblyType!="embedded") websys_CreateChatClient();	//��������
	}
	if (!window.SysSoundInstc){
		if ('function'!==typeof initSoundWebSocket) {
			$('#sysSountBtn').closest('li').hide(); //δ��������ʱ
		}
	}
	//if ($("#sysSountBtn").hasClass('record-open')){
	/*ͷ�˵�����ʱ���Զ���������  20230116 ��ʱע�� ���ռ������*/  
	// if(ViewCode=="") setTimeout(function(){sysSoundBtnClickHandler()},1000);
	//}
}
/// �Ƿ����ø�����Ϣ����ӭ
function resetSecondScreen(data){
	if (data.type=="clickwebsysmenu"){
		if (data.targetName=="main"){
			if ("undefined"!=typeof OpenEventJson && "undefined"==typeof OpenEventJsonMenus){
				 OpenEventJsonMenus = [];
				 for (var o in OpenEventJson){
					 if (OpenEventJson[o].OEMenuCode.length>0 && OpenEventJsonMenus.indexOf(OpenEventJson[o].OEMenuCode.join(''))==-1){
						 OpenEventJsonMenus = OpenEventJsonMenus.concat(OpenEventJson[o].OEMenuCode)
					 }
				 }
			}
			if ("undefined"!=typeof OpenEventJsonMenus && window.websys_emit){
				if (OpenEventJsonMenus.indexOf(data.code.replace(/_/g,"."))==-1){ // ���ø�������ӭ�����
					websys_emit("onHISLogonSuccess",{usercode:session["LOGON.USERNAME"],viewCode:ViewCode,showHosTitle:showHosTitle});
				}
			}
		}
	}
}
// ͨ���û��������� �� �ͻ��˻���������������
function SetDisableSecondScreenByCfg(val){
	eastPanelWidth = 0; /*�����ó�0*/
	
	var defaultExScreenWidth = (7*(window.innerWidth||screen.availWidth))/22;
	var isMutiScreens = false, isWildScreen=false,disabless = true;
	if (MWScreens.screens && MWScreens.screens.length>1) {
		isMutiScreens = true;
	}
	if (screen.availWidth/screen.availHeight>2.33){
		isWildScreen = true;
	}
	if(isMutiScreens){  // ����
		if (parseInt(val)>0){ //1,2,3
			disabless = false;
		}
	}else if(isWildScreen){  // ����
		if (parseInt(val)>=2){ //2,3
			disabless = false;
			eastPanelWidth = defaultExScreenWidth;
		}
	}else{
		if (parseInt(val)==3){ // ���ǿ���
			disabless = false;
			eastPanelWidth = defaultExScreenWidth;
		}
	}
	window.DisableSecondScreen = disabless;
}
Object.defineProperty(window,'DisableSecondScreen',{enumerable:true,configrable:true,
	get:function(){ return window._DisableSecondScreen;},
	set:function(v){
		if (v ==window._DisableSecondScreen) return ; 
		_DisableSecondScreen = v;
		resizeCenter();
	}
});
function initShortKey(myInArr){
	var myArr = myInArr || menuJson.records;
	for(var i=0; i<myArr.length; i++){
		var item = myArr[i];
		if (item.children){
			initShortKey(item.children);
		}else if(item.shortKey){
			websys_sckeys[item.shortKey]=(function(t){ return function(){clickHeaderMenu(t);} })(item.text);
			
		}
	}
}
/*
���ͷ�˵�����
clickHeaderMenu({code:"dhctt_mainview"});
*/
function clickHeaderMenu(menuDesc){
	if ('object'==typeof menuDesc){
		var o = $('#menuPanel a.dhc-submenu[data-icode="'+menuDesc.code+'"]');
		if(o.length==1){
			o.trigger('click');
			return false;
		}
	}
	$("#menuPanel a.dhc-submenu").each(function(){
		var text = $(this).text();
		if (text.indexOf(menuDesc)>-1){
			$(this).trigger('click');
			return ;
		}
	});
}
/// ����TRAK_Main����з���
/// menuWin.invokeMainFun("invokeChartFun","dhc.side.oe.oemanage","save","arg1","arg2")
/// �磺����סԺ���ƽ����ҽ��¼�������getTransData����ʾ��
/// menuWin.invokeMainFun("invokeChartFun","dhc_side_oe_oerecord","getTransData");
function invokeMainFun(funName){
	var ifrm =frames['TRAK_main'];
	var fun = "";
	if ("function" === typeof ifrm[funName]){
		fun = ifrm[funName]; 
	}else if (ifrm.contentWindow && "function" === typeof ifrm.contentWindow[funName]){
		fun = ifrm.contentWindow[funName];
	}
	if(fun) {
		var args=[],j=0;
		for (var i=1; i<invokeMainFun.arguments.length; i++) {
			args[j++]=invokeMainFun.arguments[i];
		}
		fun.apply(ifrm,args);
	}
}
/***
���ݴ�cdss������Ʒ����
*/
function CopyDataForCDSS(type,JsonStr){
	var mainfrm = frames['TRAK_main'];
	if (mainfrm.CopyDataForCDSS) mainfrm.CopyDataForCDSS(type,JsonStr);
}
/**
���ݷ���cdss
*/
function CopyDataToCDSS(type,JsonStr){
	// INItalize_PATIENT_INFORMATTON
	// SYNCHRONOUS_DIAGNOSTIC_INFORMATTON
	// SYNCCHRONIZE_PATIENT_ORDERS
	//return TriggerDHCDSS(type,JsonStr);
	if (typeof TriggerDHCDSS ==='function'){
		return TriggerDHCDSS(type,JsonStr);
    }
  	return null;
}
function sysMenuFindHandler(){
	var find = function(){
		var cont = $(".sysMenuFindTxt").closest('li');
		var arr = [];
		var q = $(".sysMenuFindTxt").val().toLocaleUpperCase();
		$('.navbarhead a[data-ilink!=""].dhc-submenu').each(function(index,item){
			if (arr.length>10) return ;
			var txt = $(this).text().trim();
			var py = $.hisui.getChineseSpellArray(txt).join(',');
			if (py.indexOf(q)>-1 || txt.indexOf(q)>-1){
				arr.push("<li><a href='javascript:void(0)'>"+txt+"</a></li>");
			}
		});
		cont.find(".sysMenuFindCont").remove();
		if (arr.length>0){
			var mylist = $('<ul class="sysMenuFindCont dropdown-menu">'+arr.join('')+'</ul>').appendTo(cont);
			mylist.find('li').eq(0).addClass('selected');
		}
	}
	$(".sysMenuFindTxt").toggle('slow',function(evt){
		$(".sysMenuFindTxt").val('');
		var _t = $(this);
		var cont = _t.closest('li');
		cont.find(".sysMenuFindCont").remove();
		_t.off('keydown').on('keydown',function(evt1){			
			var myselectObj = $('.sysMenuFindCont').find('li.selected');
			if (evt1.keyCode==37||evt1.keyCode==39 ){ // left right
				return 
			}else if (evt1.keyCode==40){ // down
				if(myselectObj.length>0) {
					myselectObj.removeClass('selected').next().addClass('selected');
				}else{
					$('.sysMenuFindCont').find('li').eq(0).addClass('selected');;
				}
				evt1.preventDefault();
				evt1.stopPropagation();
			}else if (evt1.keyCode==38){ // up
				if(myselectObj.length>0) {
					myselectObj.removeClass('selected').prev().addClass('selected');
				}else{
					$('.sysMenuFindCont').find('li').eq(0).addClass('selected');;
				}
				evt1.preventDefault();
				evt1.stopPropagation();
			}else if (evt1.keyCode==13){ // enter
				if(myselectObj.length>0){
					clickHeaderMenu(myselectObj.text());
					cont.find(".sysMenuFindCont").remove();
				}else{
					setTimeout(find,1);
				}
				evt1.preventDefault();
				evt1.stopPropagation();
				return ;
			}else{
				setTimeout(find,1);
			}
		});
		cont.on('click','li',function(evt2){
			cont.find('li').removeClass('selected');
			$(evt2.target).addClass('selected');
			if(evt2) {
				clickHeaderMenu($(evt2.target).text());
				cont.find(".sysMenuFindCont").remove();
			}
		});
	});
}
$(init);
