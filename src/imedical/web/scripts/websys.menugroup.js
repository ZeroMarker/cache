// websys.menugroup.js

/**
*ie console=undefined 
*/
var Level = {
    DEBUG: 1,
    INFO: 2,
    WARN: 3,
    ERROR: 4
};
(function(){	
	if ("undefined" === typeof console){		
		var emptyFn = function(){}; 
		console = {
			log: emptyFn,
			debug: emptyFn,
			info: emptyFn,
			warn: emptyFn,
			error: emptyFn,
			assert: emptyFn,
			dir: emptyFn,
			dirxml: emptyFn,
			trace: emptyFn,
			group: emptyFn,
			groupCollapsed: emptyFn,
			time: emptyFn,
			timeEnd: emptyFn,
			profile: emptyFn,
			profileEnd: emptyFn,
			count: emptyFn,
			clear: emptyFn
		};
	}
    var Logger = function () {
        this.level = Level.ERROR; //Level.DEBUG;
    };
    Logger.prototype = {
        log: function (msg) {
            try { console.log(msg); } catch (ex) { }
        },
        debug: function (msg) {
            if (this.level <= Level.DEBUG) {
                this.log(msg);
				//console.trace();
            }
        },
        info: function (msg) {
            if (this.level <= Level.INFO) {
                this.log(msg);
            }
        },
        warn: function (msg) {
            if (this.level <= Level.WARN) {
                console.warn(msg);
				//console.trace();
            }
        },
        error: function (msg) {
            if (this.level <= Level.ERROR) {
                this.log(msg);
				console.trace();
            }
        }
    };
	logger = new Logger();
})();
logger.level=4;
function getConfigUrl(userId,groupId,ctlocId){
	return {title:"��������",url:"oeorder.oplistcustom.config.hui.csp",width:700,height:525};	

	//return {title:"��������",url:"oeorder.oplistcustom.config.csp",width:700,height:500};	
}
/**
* @param {iframe} win        iframe|window
* @param {String} funName    function name
*/
function getFrameFun(ifrm,funName){
	var fun = "";
	if ("function" === typeof ifrm[funName]){
		fun = ifrm[funName]; 
	}else if (ifrm.contentWindow && "function" === typeof ifrm.contentWindow[funName]){
		fun = ifrm.contentWindow[funName];
	}
	if(fun) {return fun;}
	return null;
}
/**
* @param {String} newTitle
* �޸ĵ�ǰtab��title
* 2018-3-13
*/
function setCurrentTitle(newTitle){
	var curTab = $('#tabsReg').tabs('getSelected');
	$("#tabsReg").tabs('updateOpt',{tab:curTab,options:{title:newTitle}});
	return ;
}
/**
*  @param {String} tabName �˵�Code.���˵�Code��
*  @param {Object} cfg     ���Ӳ���
*  �л�ҳǩ����,���û�д����
* parent.switchTabByEMR("dhc.side.oe.diagrecord") �л�������Ϊdhc.side.oe.oemanage��ҳǩ
* parent.switchTabByEMR("dhc.side.oe.diagrecord",{oneTimeValueExp:"ReportId=123456"}) �л�������Ϊdhc.side.oe.oemanage��ҳǩ
* parent.switchTabByEMR("CategoryID=30") �л������ʽΪCategoryID=30��ҳǩ , parent.switchTabByEMR("CategoryID=30&a=12") �л������ʽΪCategoryID=30��ҳǩ,
*/
function switchTabByEMR(tabName,cfg){
	switchTabByEMRAndOpt(tabName,undefined,cfg);
}
function switchTabByEMRAndOpt(tabName,tabOption,cfg){
	if ('string'==typeof tabName){
		if (tabName==""){alert("�봫��Ҫ�򿪵�ҳǩ��!");return ;}
		if (tabName.indexOf("=")>0){
			//CategoryID=30�鵽tabName
			var tnFindStr = tabName;
			$("#menuGroupReg ul.i-menugroup li a").each(function(){
				console.log($(this).data('icode')+" : "+$(this).data("valueexp"));
				if ($(this).data("valueexp").indexOf(tnFindStr)>-1){
					tabName = $(this).data('icode');
					return false;
				}
			})
		}
		if ($g) tabName = $g(tabName);
	}
	tabName = tabName.split(".").join("_");
	var tabsJObj = $("#tabsReg");
	if (!tabsJObj.tabs("exists",tabName)){
		var _opt_ = {};
		var _t_ = $("ul.i-menugroup li a[data-icode='"+tabName+"']");  // ѭ�����в�˵�---��������
		if (_t_.length==0){
			$("ul.i-menugroup li a").each(function(index,item){
				var menuItemHtml = $(this).html();
				var menuTitle = menuItemHtml.split("<span")[0];
				if ( $.trim(menuTitle)==tabName){
					_t_=$(this);
					return false;
				}
			});
		}
		if ("undefined" == typeof tabOption) {
			var li = _t_.parent();
			if(li.hasClass("disabled")){ return false; }
			$.extend(_opt_,{
				id:_t_.data("icode"), 
				title:_t_.data('text')+(_t_.data('count')>0?(" ("+_t_.data('count')+")"):""),
				closable:true,
				ilink:_t_.data("ilink"),
				isxhr:_t_.data("isxhr"),
				itarget:_t_.data('itarget'),
				valueExp:_t_.data('valueexp'),
				content:'<iframe id="i'+_t_.data("icode")+'" name="i'+_t_.data("icode")+'" src="about:blank" width="100%" min-height="500px" height="100%" frameborder="0"></iframe>'
			});
		}
		var tabOpt = tabOption||_opt_;
		$.extend(tabOpt,cfg)
		if ("undefined" != typeof tabOpt.id){
			// add�ᴥ��select�¼�---��ʵ��src��select�¼��ϼ���
			$("#tabsReg").tabs('add',tabOpt);
			// �޸�color
			if (_t_.data("class")!=""){
				var titleLi = $("#tabsReg .tabs-header .tabs-wrap>ul.tabs li.tabs-selected");
				titleLi.addClass(_t_.data("class"));
			}
		}else{
			alert("δ�ҵ���"+tabName+"��ҳǩ!");
		}
	}else{
		$.extend($('#tabsReg').tabs('getTab',tabName).panel("options"),  cfg) ;
		tabsJObj.tabs('select',tabName); 
	}
}
/**
* @param {String|Number} tabName  ҳǩ�ġ��˵����������򡾲˵�Code���� tabs��index
* @param {String} funName         JS��������
* @param {....}  �������ΪfunName�����
* ������һ�Ѵ򿪹���ҳǩ�����JS����
* parent.invokeChartFun("dhc.side.oe.oemanage","save","arg1","arg2")
*/
function invokeChartFun(tabName,funName){
	//alert("tabName"+tabName+",funName="+funName);
	var tab = $("#tabsReg").tabs('getTab',tabName);
	if (!tab) { console.log("δ�ҵ���"+tabName+"��ҳǩ!");return ;}
	var newTabframe = tab.find("iframe").get(0);
	if ( newTabframe ){
		var fun = "";
		if ("function" === typeof newTabframe[funName]){
			fun = newTabframe[funName]; 
		}else if (newTabframe.contentWindow && "function" === typeof newTabframe.contentWindow[funName]){
			fun = newTabframe.contentWindow[funName];
		}
		if(fun) {
			var args=[],j=0;
			for (var i=2; i<invokeChartFun.arguments.length; i++) {
				args[j++]=invokeChartFun.arguments[i];
			}
			fun.apply(newTabframe,args);
		}			
	}
	return ;
}
/**
* �л�����
* scripts/dhcdoc/InPatientist.inPat.js---
function doSwitch(PatientID,EpisodeID,mradm) {
	if(top.frames[0] && top.frames[0].switchPatient){
		top.frames[0].switchPatient(PatientID,EpisodeID,mradm);
		top.frames[0].hidePatListWin();
	}else{
		parent.parent.switchPatient(PatientID,EpisodeID,mradm);
		parent.parent.hidePatListWin();
	}
}
*/
function switchPatient(patientId,episodeId,mradm){
	var onSelectBak = $("#tabsReg").tabs("options").onSelect;
	$("#tabsReg").tabs("options").onSelect = function(){}

	$("#InpatListDiv").data("AutoOpen",0);
	for (var i=$("#tabsReg .tabs-header ul.tabs li").length-1; i>0+fixlen; i--){
		$("#tabsReg").tabs("close",i);
	}
	$("#tabsReg").tabs("options").onSelect = onSelectBak;
	setEprMenuForm(episodeId,patientId,mradm,"");
	hrefRefresh();
	refreshBar();
	g_reloadMenuAutoChart = true;
	reloadMenu();
}
/**
* ��render
*/
function viewportRenderer(){
	
}
/**
* @param {String|Number} code �����String��Ϊtitle��id�������Number����tabs��index
*/
function selectMenuStyle(code){
	$("ul.i-menugroup li").removeClass("active");
	if (typeof code == 'string'){
		$("ul.i-menugroup li a[data-icode='"+code+"']").parent().addClass("active");
	}else if(typeof code == 'number'){ // tab--index
		var tab = $("#tabsReg").tabs('getTab',code);  
		$("ul.i-menugroup li a[data-icode='"+tab.panel('options').id+"']").parent().addClass("active");
	}
}
/**
* @author wanghc
* @date 2012/5/18
* @param {String} str
* @return {HTMLString} html htmlƬ��
*/
function reservedToHtml(str){	
	var replacements = {"&lt;":"<", "&#60;":"<", "&gt;":">", "&#62;":">", "&quot;":"\"", "&#34;":"\"", "&apos;":"'",
	"&#39;":"'", "&amp;":"&", "&#38;":"&"};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g,function(v){
		return replacements[v];		
	});
}
var resetEprMenuForm = function(){
	setEprMenuForm("","","","");
}
var setEprMenuForm = function(adm,papmi,mradm,canGiveBirth){
	var frm = dhcsys_getmenuform();
	if((frm) &&(frm.EpisodeID.value != adm)){
		frm.EpisodeID.value = adm; 			//DHCDocMainView.EpisodeID;
		frm.PatientID.value = papmi; 		//DHCDocMainView.PatientID;
		frm.mradm.value = mradm; 				//DHCDocMainView.EpisodeID;
		if(frm.AnaesthesiaID) frm.AnaesthesiaID.value = "";
		if (frm.canGiveBirth) frm.canGiveBirth.value = canGiveBirth;
		if(frm.PPRowId) frm.PPRowId.value = "";
	}
}
/**
*
*/
var refreshBar = function (){
	var frm = dhcsys_getmenuform();
	if (frm) {
		var papmi = frm.PatientID.value;
		var adm = frm.EpisodeID.value;
		if (adm > 0 ){
			/*$.m({ClassName:"web.DHCDocMain",MethodName:"GetPatientBaseInfo",papmi:papmi,adm:adm},function(html){
				$(".patientInfo").html("");
				var patJson = $.parseJSON(html);
				patJson.baseIconProfile=reservedToHtml(patJson.baseIconProfile);
				$("#patientInfoTpl").tmpl(patJson).appendTo(".patientInfo");
			});*/
			$.m({ClassName:"web.DHCDoc.OP.AjaxInterface",MethodName:"GetOPInfoBar",CONTEXT:"",EpisodeID:adm},function(html){
				if (html!=""){
					$(".PatInfoItem").html(reservedToHtml(html));
					$(".PatInfoItem").find("img").eq(0).css("top",0);
				}else{
					$(".PatInfoItem").html("��ȡ������Ϣʧ�ܡ����顾������Ϣչʾ�����á�");
				}
			});
		}else{
			// δѡ�����Զ����������б�
			$("#InpatListDiv").data("AutoOpen",1);
			if(window.showPatListWin) showPatListWin();
		}
	}
};
/*�˵��仯ʱ,�޸�ҳǩ��ʽ*/
var refreshTabsTitleAndStyle = function(json){
	if (json){
		for (var i=0; i<json.length;i++){
			if (json[i].children){
				for (var j=0; j<json[i].children.length; j++){
					var item = json[i].children[j];
					var tab = $('#tabsReg').tabs("getTab",item.code);
					if (tab){
						var newTitle = item.text;
						if (item.count>0){ newTitle = item.text+"<span class=\"count\">("+item.count+")</span>";}
						//console.log(tab.panel("options").title+"?=="+newTitle);
						var ind = $("#tabsReg").tabs("getTabIndex",tab);
						var titleLi = $("#tabsReg .tabs-header .tabs-wrap>ul.tabs li").eq(ind);
						if (titleLi.find("span.tabs-title").html()!=newTitle) {
							//console.log(tab.panel("options").title+"-->"+newTitle);
							titleLi.find("span.tabs-title").html(newTitle)
						}
						//if (tab.panel("options").title!=newTitle){
							// ���ٴδ���iframes��src����
							//$('#tabsReg').tabs('update', {tab:tab, options: {title:newTitle}});
						//}
						if (titleLi.hasClass("tabs-selected")){
							titleLi.get(0).className="tabs-selected";
						}else{
							titleLi.get(0).className="";
						}
						if (item.className){
							titleLi.addClass(item.className);
						}
					}
				}
			}
		}
	}
}
//�л�����ʱ,�ػ��˵���ҳǩ
function reloadMenu(PatientId,EpisodeId,mradm){
	if (arguments.length==0){
		var frm = dhcsys_getmenuform();
		var PatientId = frm.PatientID.value;
		var EpisodeId = frm.EpisodeID.value;
		var mradm = frm.mradm.value;
	}
	$.m({ClassName:"websys.MenuGroup",MethodName:"Json",MenuGroup:MENUGROUPID,PatientID:PatientId,EpisodeID:EpisodeId,mradm:mradm},function(rtn){
		var json = $.parseJSON(rtn);
		//ȡ�÷���
		if ($g && trans){
			for(var i=0; i<json.length;i++){
				var item = json[i];
				if ("undefined"!=typeof item["children"] && item.children.length>0){ //Ҫ�����ÿ���ֶ���seq
					for (var j=0;j<item.children.length;j++){
						var item2 = item.children[j];
						if (item2.originText) trans[item2.originText]=item2.text;
						if("undefined"!=typeof item2["children"] && item2.children.length>0){
							for (var k=0;k<item2.children.length;k++){
								if (item2.children[k].originText) trans[item2.children[k].originText]=item2.children[k].text;
							}
						}
					}
				}
			}
		}
		// ����������˵�˳��
		for(var i=0; i<json.length;i++){
			var item = json[i];
			if ("undefined"!=typeof item["children"]){
				if (item.children.length>0 && item.children[0]["seq"]){ //Ҫ�����ÿ���ֶ���seq
					try{
						item.children.sort(function(a,b){
							// ��ֵ��ǰ��
							if (a.seq=="") return -1;
							if (b.seq=="") return 1;
							return (parseInt(a.seq)-parseInt(b.seq));
						});
					}catch(e){}
				}
			}
		}
		$(".menugroup-list").each(function(ind,itm){
			var mcode = $(this).data("code");
			for (var i =0;i<json.length;i++){
				if (json[i].code==mcode){ //��һ���˵��µĶ���json����html�ŵ�һ����
					$(this).html("");
					var html = $("#menuGroupLevel2Tpl").tmpl({menuscnd:json[i].children});
					html.appendTo($(this));	
					return ;
				}
			}

		});
		//$("#menuGroupReg").html("");
		//var html = $("#menuGroupTpl").tmpl({menus:json});
		//html.appendTo("#menuGroupReg");
		//$(".i-menugroup>.nav-header:first>li").addClass("active");
		refreshTabsTitleAndStyle(json);
		//��reloadmenu���Ե��dhc_emside_emr_cate21
		fixlen=0;   //cryze 2018-3-1�̶�ҳǩ����Ŀ�Ǹ�����ѭ������ģ��л�����Ҳ�����˷�������ʹfixlen����������������0  
		if (g_reloadMenuAutoChart){
			$("#menuGroupReg ul.i-menugroup li a").each(function(){
				/*if($(this).data("icode")=="dhc_emside_emr_cate21"){
					$(this).click();
					return false;
				}*/
				if ($(this).data("autoopen")==1){
					var icode = $(this).data('icode');
					var tab = $('#tabsReg').tabs("getTab",icode);
					if (tab){
						//�����ص�ʱ,�Ѿ��Ǵ�״̬�Ͳ��ٴ���Click,click�ᵼ�´���xhrRefresh
					}else {
						$(this).click(); //�Զ��򿪿��Թر�
					}
				}else if(FixedTabTitle.indexOf(","+$(this).data('text')+",")>-1) {
					var icode = $(this).data('icode');
					var tab = $('#tabsReg').tabs("getTab",icode);
					if (tab){
						//�л�����ʱ����xhrRefresh,�Ѿ��Ǵ�״̬�Ͳ��ٴ���Click,click�ᵼ�´���xhrRefresh
					}else {
						$(this).click();
					}
					fixlen++;
				}
			});
			g_reloadMenuAutoChart = false;
		}
	});
	return false;
}
var clickMenuHandler = function (){
	$("#menuGroupReg").on("click","ul.i-menugroup li a",function(e){
		var _t_ = $(this);
		var li = _t_.parent();
		if(li.hasClass("disabled")){ return false; }
		var code = _t_.data("icode");
		var target = _t_.data('itarget'); 	//TRAK_mainĬ������ҳǩ
		selectMenuStyle(code); 				//,iconCls:'icon-help'
		var tabOpt = {
			id:code, 
			title:_t_.data('text')+(_t_.data('count')>0?(" ("+_t_.data('count')+")"):""),
			closable:FixedTabTitle.indexOf(","+_t_.data('text')+",")>-1?false:true,
			ilink:_t_.data("ilink"),
			isxhr:_t_.data("isxhr"),
			itarget:_t_.data('itarget'),
			valueExp:_t_.data('valueexp'),
			content:'<iframe id="i'+code+'" name="i'+code+'" src="about:blank" width="100%" min-height="500px" height="100%" frameborder="0"></iframe>'
		};
		if (target=="TRAK_main"){ // ������¿�chart
			switchTabByEMRAndOpt(code,tabOpt);
			/*
			if (!$("#tabsReg").tabs("exists",code)){
				// add�ᴥ��select�¼�---��ʵ��src��select�¼��ϼ���
				$("#tabsReg").tabs('add',tabOpt);
				// �޸�color
				if (_t_.data("class")!=""){
					var titleLi = $("#tabsReg .tabs-header .tabs-wrap>ul.tabs li.tabs-selected");
					titleLi.addClass(_t_.data("class"));
				}
			}else{
				switchTabByEMR(code);
			}*/
		}else{
			// ָ��ĳһchart��
			var targetTab = $("#tabsReg").tabs("getTabByOpt",{"val":target,key:'itarget'})
			if (targetTab){
				if(tabOpt.isxhr){
					targetTab.panel("options").id=code;
					targetTab.panel("options").ilink=_t_.data("ilink");
					targetTab.panel("options").isxhr=_t_.data("isxhr");
					targetTab.panel("options").itarget=_t_.data('itarget');
					targetTab.panel("options").valueExp=_t_.data('valueexp');
					//targetTab.find('span.tabs-title').html(_t_.text());
					// easyui�Զ���update���������content,����ʵ�־ֲ�ˢ��
					$("#tabsReg").tabs('updateOpt',{tab:targetTab,options:{title:_t_.data('text')+(_t_.data('count')>0?(" ("+_t_.data('count')+")"):"")}});
					//�ֲ�ˢ��,url����
					var curIframe = targetTab.find("iframe").get(0);
					curIframe.id="i"+code;
					curIframe.name="i"+code;
				}else{
					$('#tabsReg').tabs('update',{tab:targetTab,options:tabOpt}); 
				}
				$("#tabsReg").tabs('select',$("#tabsReg").tabs('getTabIndex',targetTab));
				//switchTabByEMR(code);
			}else{
				// add�ᴥ��select�¼�---��ʵ��src��select�¼��ϼ���
				$("#tabsReg").tabs('add',tabOpt);
				// �޸�color
				if (_t_.data("class")!=""){
					var titleLi = $("#tabsReg .tabs-header .tabs-wrap>ul.tabs li.tabs-selected");
					titleLi.addClass(_t_.data("class"));
				}
			}
		}
	});
}
//����load��ǰҳ��,����������
var hrefRefresh = function (forceRefresh){
	// ��������
	tkMakeServerCall("web.DHCDocMainOrderInterface","ChartItemChange");
	var frm = dhcsys_getmenuform();
	if (frm) {
		var papmi = frm.PatientID.value; //DHCDocMainView.PatientID;
		var adm = frm.EpisodeID.value; //DHCDocMainView.EpisodeID;
		var mradm = frm.mradm.value; //DHCDocMainView.EpisodeID;
		var curTab = $('#tabsReg').tabs('getSelected');
		if(!curTab){ // 2019-06-25 �����������л������б�ʱ,��Ϣ��������հ�
			//Ĭ��ѡ�е�һ��ҳǩ
			curTab = $("#tabsReg").tabs("getTab",0);
			$("#tabsReg").tabs("select",0);
		}
		var ilink = curTab.panel("options").ilink;
		var isXhrRefresh = curTab.panel("options").isxhr;
		var valueExp = curTab.panel("options").valueExp||"";
		var oneTimeValueExp = curTab.panel("options").oneTimeValueExp||"";
		valueExp = valueExp+"&"+oneTimeValueExp;
		delete curTab.panel("options").oneTimeValueExp;
		
        var curIframe = curTab.find("iframe").get(0);
		if (curIframe){
			if (adm > 0){
				// isXhrRefresh=��,false����ȫ��ˢ��,���һ��ˢ��
				if ((curIframe.src=="about:blank")||!isXhrRefresh){
					var objParam = {PatientID: papmi, EpisodeID: adm, mradm: mradm, forceRefresh: (forceRefresh || false)};
					// �Ѳ˵��б��ʽת��json--->�ӵ�xhrRefresh�����
					var veArr = valueExp.split("&");
					for(var ve=0; ve<veArr.length; ve++){
						var veItem = veArr[ve].split("=");
						if (veItem[0]&&veItem.length>1) objParam[veItem[0]] = veItem[1];
					}
			 		curIframe.src = rewriteUrl(ilink,objParam);
				}else{
					if (curIframe && curIframe.contentWindow){
						if("function" === typeof curIframe.contentWindow.xhrRefresh ){
							var obj = {papmi: papmi, adm: adm, mradm: mradm, forceRefresh: (forceRefresh || false)};
							// �Ѳ˵��б��ʽת��json--->�ӵ�xhrRefresh�����
							var veArr = valueExp.split("&");
							for(var ve=0; ve<veArr.length; ve++){
								var veItem = veArr[ve].split("=");
								if (veItem[0]&&veItem.length>1) obj[veItem[0]] = veItem[1];
							}
							if (logger.level==Level.DEBUG) debugger;
							// ����panelҳ��iframe�е�xhrRefresh����
							curIframe.contentWindow.xhrRefresh(obj);				
						}
					}
				}
			}else{
				 curIframe.contentDocument.body.innerHTML=$g("��ѡ����")
			}
		}
	}
}
var g_reloadMenuAutoChart = false;  //ֻ�����л����˻��ʼ��ʱ�����Զ���ҳǩ
function soundOpenOrderEntry(){
	switchTabByEMR("dhc_side_oe_oerecord");
}
function soundOpenDiagnosEntry(){
	switchTabByEMR("dhc_side_oe_diagrecord");
}
function soundSelPatient(p1){
	alert("sound sel patient ()="+p1);
}
function soundOpenPatientList(){
	showPatListWin();
}
var init = function(){
	if (FixedTabTitle!="") FixedTabTitle=","+FixedTabTitle+","
	g_reloadMenuAutoChart = true;
	reloadMenu();
	refreshBar();
	clickMenuHandler();
	/*select tab*/
	$.extend($("#tabsReg").tabs("options"),{
		onSelect : function(title,index){ 
			//���н���ˢ�¶�����
			var selectMenu = $("ul.i-menugroup li.active a");
			//console.log("onSelect tab,�˵�title = "+selectMenu.text()+",tab title = "+title);
			//if(selectMenu.text()!=title){  //�����ǰ��ѡ�еĲ˵��Ͳ�����ѡ��
				selectMenuStyle(index);
				hrefRefresh(true);  //ֻҪ�����ǿ��ˢ��
			//}	
		},
		onBeforeClose : function(title,index){
			var target = this;
			var tab = $(target).tabs("getTab",title);	
			var iframe = tab.find("iframe").get(0);
			if ( iframe ){
				var onBeforeCloseTab = getFrameFun(iframe,"onBeforeCloseTab");
				if(onBeforeCloseTab) {
					//�������false,���л�Chart
					if (!onBeforeCloseTab()){return false;};	
			    }			
			}
			return true;			
		},
		onBeforeSelect : function(title,newWhich){
			var oldTab = $(this).tabs("getSelected");
			if (oldTab==null) return ; //��chart��x		
			var oldIframe = oldTab.find("iframe").get(0);	
			if ( oldIframe ){
				var chartOnBlur = getFrameFun(oldIframe,"chartOnBlur");
				if(chartOnBlur) {
					//�������false,���л�Chart
					var blurRtn = true;
					try{chartOnBlur();}catch(e){alert("�뿪��ǰҳ�ж�ʱ����"+e.message);}
					if (!blurRtn){return false;};	
			    }			
			}	
			//------------------	
			var newTab = $(this).tabs("getTab",newWhich.attr("id"));
			if (newTab==null) return ; //ͬһtarget�ڼ���			
			var newTabframe = newTab.find("iframe").get(0);	
			if ( newTabframe ){
				var chartOnFocus = getFrameFun(newTabframe,"chartOnFocus");
				if (chartOnFocus) {
					var frm = dhcsys_getmenuform();
					var papmi="",adm="",mradm="";
					if (frm) {
						papmi = frm.PatientID.value;
						adm = frm.EpisodeID.value; 
						mradm = frm.mradm.value; 
					}
				    chartOnFocus({papmi: papmi, adm: adm, mradm: mradm});	
				}			
			}
		}	
	});
	
	/*�����˵�*/
	$(".i-west-acc").on("mouseenter","li.i-dropdown-submenu",function(){
		var t = $(this);  
		t.addClass('open');
		var off = $(this).offset(); 
		$(this).find(".dropdown-menu").offset({
			top:off.top,left:$(this).width()-35
		});
		if(!!window.ActiveXObject || "ActiveXObject" in window){   
			if (t.find("iframe").length>0){}else{
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
	}).on("mouseleave","li.i-dropdown-submenu",function(){
		var t = $(this);
		t.removeClass('open');
		return false;
	});
	hrefRefresh(true);
	// 2017-20-28
	/*$("#menuGroupReg").panel("options").onResize=function(){
		$("#menuGroupReg .i-menugroup").width($(this).width()-20);
	};*/
	// 2017-20-28
	//$("#menuGroupReg").css("position","fixed");
	
	/*switch patient*/
	/*$('.selectpat>select').on("change",function(r){
		var _t_ = $(this);
		var idInfo = _t_.val();
		var arr = idInfo.split("^");
		switchPatient(arr[0],arr[1],arr[2]);
	});*/
	/*
	$("#tabsReg .tabs-header").on("contextmenu","ul.tabs li",function(e){
		e.preventDefault();
		return false;
	});
	//.off("mousedown")
	//�Ҽ��˵�
	$("#tabsReg .tabs-header").on("mousedown","ul.tabs li",function(e){
		if(e.which==3){
			$("#tabscm").menu({onClick:function(item){
			}}).menu("show",{left:200,top:100});
		}
	});*/
	
}
var fixlen=0;   ///�����̶�ҳǩ��,ƥ��request��FixedTabTitle ���ҳǩ��Ŀ
$.parser.onComplete = function(context){
	// ��һ��contextΪundefined,��Ϊ������.
	if (!!context) return ;
	$(".window-mask.alldom").hide(); //.fadeOut("fast");
	init();
}
