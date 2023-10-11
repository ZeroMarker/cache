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
 return {title:"��������",url:"dhcdoc.custom.setting.csp",width:750,height:700,iconCls:'icon-w-setting'};

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
/**
*  @param {String} tabName    �˵�Code �� CategoryID=Ŀ¼id
*                             �磺dhc_side_oe_diagrecord��dhc.side.oe.diagrecord��CategoryID=30
*  @param {Object} tabOption  ���ڵ�һ�δ�ҳǩʱ
*  	   tabOption=undefinedʱ���Ӳ�˵���ȡ{id:x, title:x,closable:true,ilink:x,isxhr:x,itarget:x,valueExp:x,content:x}
*      id����,titleΪҳǩ����,ilinkΪ����·��websys.csp?a=a&CategoryID=5&TMENU=57391&TPAGID=9696319
*      isxhrΪboolean�࣬false��true,false��ʾȫ��ˢ�£�true�ֲ�ˢ�� 
*      itargetΪEMR��    ����ͳһ��EMR����ʾ��ͬһҳǩ��
*      valueExpΪ���ʽ����&CategoryID=5
*      contentΪ'<iframe id="i"+code name="i"+code src="about:blank" width="100%" min-height="500px" height="100%" frameborder="0"></iframe>'
*  @param {Object} cfg        ����ҳǩ����  {oneTimeValueExp:"ReportId=123456"}
*/
function switchTabByEMRAndOpt(tabName,tabOption,cfg){
	var _t_ = null; /*��˵�jq����*/
	var mcode = "",mtitle="",mtarget="TRAK_main";
	if ('string'==typeof tabName){
		if (tabName==""){alert("�봫��Ҫ�򿪵�ҳǩ��!");return ;}
		$("#menuGroupReg ul.i-menugroup li a").each(function(){
			var menuItemHtml = $(this).html();
			var menuTitle = menuItemHtml.split("<span")[0];
			if ($(this).data("icode")==tabName){ //code
				_t_=$(this);				
			}else if ($(this).data("valueexp").indexOf(tabName)>-1){ //CategoryID=30�鵽tabName
				_t_=$(this);				
			}else if ( $.trim(menuTitle)==tabName){   //title�鵽tabName
				_t_=$(this);
			}
			if (_t_){
				return false;
			}
		})
		if ($g) tabName = $g(tabName);
	}
	if (!_t_) {alert($g("δ�ҵ���")+tabName+$g("��ҳǩ!")); return };
	mcode = _t_.data('icode');
	mtitle = _t_.data('text');
	mtarget = _t_.data('itarget');
	tabName = mcode.split(".").join("_");
	var tabsJObj = $("#tabsReg");
	var li = _t_.parent();
	if(li.hasClass("disabled")){ return false; }
	var _opt_ = {};
	$.extend(_opt_,{
		id: mcode, 
		title:mtitle+(_t_.data('count')>0?(" ("+_t_.data('count')+")"):""),
		closable:FixedTabTitle.indexOf(","+mtitle+",")>-1?false:true,
		ilink:_t_.data("ilink"),
		isxhr:_t_.data("isxhr"),
		itarget:mtarget,
		valueExp:_t_.data('valueexp'),
		content:'<iframe id="i'+_t_.data("icode")+'" name="i'+_t_.data("icode")+'" src="about:blank" width="100%" min-height="500px" height="100%" frameborder="0"></iframe>'
	});
	if (typeof tabOption === "object") $.extend(_opt_,tabOption);
	if (typeof cfg === "object") $.extend(_opt_,cfg);
	/*�������ĸ�ҳ��*/
	var targetTab = tabsJObj.tabs("getTabByOpt",{"val":mcode,key:'id'});
	if (mtarget != "TRAK_main" && (!targetTab || targetTab.length==0)) targetTab = tabsJObj.tabs("getTabByOpt",{"val":mtarget,key:'itarget'});
	if (!targetTab){  //�¼�ҳǩ
		// add�ᴥ��select�¼�---��ʵ��src��select�¼��ϼ���
		tabsJObj.tabs('add',_opt_);
		// �޸�color
		if (_t_.data("class")!=""){
			var titleLi = $("#tabsReg .tabs-header .tabs-wrap>ul.tabs li.tabs-selected");
			titleLi.addClass(_t_.data("class"));
		}
	}else{
		if (mtarget=="TRAK_main"){
			$.extend(targetTab.panel("options"),cfg) ;
		}else{
			// ָ��ĳһҳǩ��,��EMR��
			if(_opt_.isxhr){
				delete _opt_.content;
				$.extend(targetTab.panel("options"),_opt_) ;
				
				//targetTab.find('span.tabs-title').html(_t_.text());
				// easyui�Զ���update���������content,����ʵ�־ֲ�ˢ��
				$("#tabsReg").tabs('updateOpt',{tab:targetTab,options:_opt_}); //{title:_opt_.title}});
				//�ֲ�ˢ��,url����
				var curIframe = targetTab.find("iframe").get(0);
				curIframe.id="i"+mcode;
				curIframe.name="i"+mcode;
			}else{
				tabsJObj.tabs('update',{tab:targetTab,options:_opt_}); 
			}
		}
		tabsJObj.tabs('select',tabsJObj.tabs('getTabIndex',targetTab)); 
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
	if (!tab) { console.log("δ�ҵ���"+tabName+"��ҳǩ!");return -1;}
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
		}else{
			return -3;
		}			
	}else{
		return -2;
	}
	return 0;
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
function switchPatient(patientId,episodeId,mradm,canGiveBirth,options){
	var cfg = {patientId:patientId,episodeId:episodeId,mradm:mradm,canGiveBirth:canGiveBirth,options:options};
	var frm = dhcsys_getmenuform(); //menuWin.document.forms['fEPRMENU'];
	var DoingSthDesc = frm.DoingSth.value;
	if (DoingSthDesc!=""){
		if ('function'==typeof websys_getMenuWin().doingSthConfirm){
			websys_getMenuWin().doingSthConfirm(switchPatientGoto,cfg,'����','����');
		}else{
			$.messager.alert("��ʾ",DoingSthDesc);
		}
		return ;
	}
	switchPatientGoto(cfg);
}
// 1 ���۲�����ʾ�½����л�
// 0��� ��ˮ���˲���ʾ
function handlerToolsByAdm(EpisodeId){
	$m({ClassName:"web.DHCEMInterfaceCom",MethodName:"PatientVisitStatus",EpisodeID:EpisodeId},function(vs){
		if(vs=="O" || vs=="E"){
			EPRCATE85.toEprMenu(); // ��ˮ���˻ص���˵�
			$("#menuGroupReg").find('.panel-tool a.icon-w-switch,.panel-tool a.icon-w-add').hide();
		}else{
			$("#menuGroupReg").find('.panel-tool a.icon-w-switch,.panel-tool a.icon-w-add').show();
		}
	});
}
function switchPatientGoto(cfg){
	var onSelectBak = $("#tabsReg").tabs("options").onSelect;
	$("#tabsReg").tabs("options").onSelect = function(){}
	// 9.0ǰ�Ĳ�����Ϣ�������ڰ�AutoOpen���ó�0
	if(typeof InitPatInfoBanner!='function') $("#InpatListDiv").data("AutoOpen",0);
	for (var i=$("#tabsReg .tabs-header ul.tabs li").length-1; i>0+fixlen; i--){
		$("#tabsReg").tabs("close",i);
	}
	$("#tabsReg").tabs("options").onSelect = onSelectBak;
	setEprMenuForm(cfg.episodeId,cfg.patientId,cfg.mradm,cfg.canGiveBirth,cfg.options);
	hrefRefresh();
	refreshBar();
	if (typeof CDSSObj == 'object') CDSSObj.SynAdm(cfg.episodeId);
	if ("function" == typeof SwitchPatientTriggerAllCDSS) SwitchPatientTriggerAllCDSS("ZY_"+cfg.episodeId);
	g_reloadMenuAutoChart = true;
	reloadMenu();
	if (websys_emit){
		try{
			websys_emit("onSelectIPPatient",{PatientID:cfg.patientId,EpisodeID:cfg.episodeId,mradm:cfg.mradm});
		}catch(e){}
	}
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
	var mycode = "";
	if (typeof code == 'string'){
		mycode = code;
	}else if(typeof code == 'number'){ // tab--index
		var tab = $("#tabsReg").tabs('getTab',code);  
		mycode = tab.panel('options').id;
	}
	if (mycode!="") $("ul.i-menugroup li a[data-icode='"+mycode+"']").parent().addClass("active");
}
/**
* @author wanghc
* @date 2012/5/18
* @param {String} str
* @return {HTMLString} html htmlƬ��
*/
function reservedToHtml(str){
	if ('string'!==typeof str) return str;	
	var replacements = {"&lt;":"<", "&#60;":"<", "&gt;":">", "&#62;":">", "&quot;":"\"", "&#34;":"\"", "&apos;":"'",
	"&#39;":"'", "&amp;":"&", "&#38;":"&"};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g,function(v){
		return replacements[v];		
	});
}
var resetEprMenuForm = function(){
	setEprMenuForm("","","","");
}
var setEprMenuForm = function(adm,papmi,mradm,canGiveBirth,options){
		//episodeId,patientId,mradm,"",AnaesthesiaID
	var menuWin = websys_getMenuWin();  // ���ͷ�˵�Window����
	if (menuWin){		
		var frm = dhcsys_getmenuform(); //menuWin.document.forms['fEPRMENU'];
		if((frm) &&(frm.EpisodeID.value != adm)){
			if (menuWin.MainClearEpisodeDetails) menuWin.MainClearEpisodeDetails();  //���ͷ�˵������в��������Ϣ
			frm.EpisodeID.value = adm; 			//DHCDocMainView.EpisodeID;
			frm.PatientID.value = papmi; 		//DHCDocMainView.PatientID;
			frm.mradm.value = mradm; 				//DHCDocMainView.EpisodeID;
			if("undefined"!==typeof canGiveBirth && frm.canGiveBirth) frm.canGiveBirth.value = canGiveBirth;
			if ("object"===typeof options){
				for (var p in options ){
					if (frm[p]) frm[p].value = options[p];
				}
			}else if ("string"===typeof options){
				frm.AnaesthesiaID.value = options;
			}
		}
	}
}
function SynAdmInfoToCDSS(EpisodeID)
{
	if(!websys_getMenuWin) return;
	var menuwin=websys_getMenuWin();
	if(menuwin.CopyDataToCDSS && menuwin.DriverCDSS){
		$.cm({
			ClassName:"DHCDoc.Interface.Inside.CDSS",
			MethodName:"GetPatInfo",
			EpisodeID:EpisodeID,
		},function(PatInfo){
			var CDSSRet=menuwin.CopyDataToCDSS("INITIALIZE_PATIENT_INFORMATION",PatInfo);
		});
	}
}
/**
*
*/
var refreshBar = function (){
	if(typeof InitPatInfoBanner=='function'){
		return InitPatInfoBanner();
	}else{  // ����9.0��ǰ������Ŀ
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
						$(".patientbar").data("patinfo",html);
						if ("function"==typeof InitPatInfoHover) {InitPatInfoHover();}
						else{$(".PatInfoItem").html(reservedToHtml(html))}
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
			//SynAdmInfoToCDSS(adm);
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

/**
* �л�����ʱ,�ػ��˵���ҳǩ
* @param {Object||String} PatientId ����id,��{reloadCurrentMenu:true,instance:instanceid}
* @param {String} EpisodeId
* @param {String} mradm
* ��������/��ӡ/ǩ����,���ô˷���ˢ�����ʵ��
* ˢ���ַ��ٲ˵�/��ˢ�²���Ŀ¼
*/
function reloadMenu(PatientId,EpisodeId,mradm){
	if ("object" == typeof PatientId){
		// 2021-08-13 ����Ŀ¼ˢ��
		var reloadCurrentMenu = PatientId.reloadCurrentMenu||false;
		var instance = PatientId.instance||"";
		if (reloadCurrentMenu && EPRCATE85.isEprCategory()){
			recordListRefresh(instance);
			return ;
		}
	}
	var frm = dhcsys_getmenuform();
	var papmi = frm.PatientID.value;
	var adm = frm.EpisodeID.value;
	var mr = frm.mradm.value;
	if (arguments.length==0 || "undefined"===typeof EpisodeId){
		PatientId = papmi;
		EpisodeId = adm;
		mradm = mr;
	}
	handlerToolsByAdm(EpisodeId);
	$.m({ClassName:"websys.MenuGroup",MethodName:"Json",MenuGroup:MENUGROUPID,PatientID:PatientId,EpisodeID:EpisodeId,mradm:mradm},function(rtn){
		EPRCATE85.toEprMenu();
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
					if (json[i].children.length==0){
						json[i].children.push({blankOpt: "",code: "nullmenu",img: "../images/uiimages/updatediag.png",isXhrRefresh: true,link: "",originText:"��",seq: "",target: "TRAK_main",text: "��"})
					}
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
						setTimeout((function(t){return function(){$(t).click();}})(this),500);
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
		if (_t_.data('ilink')==''){return false;}
		if (_t_.data('ilink')=='#'){return false;}
		var code = _t_.data("icode");
		var target = _t_.data('itarget'); 	//TRAK_mainĬ������ҳǩ
		selectMenuStyle(code); 				//,iconCls:'icon-help'
		switchTabByEMRAndOpt(code);
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
					if ("function"==typeof websys_writeMWToken) ilink = websys_writeMWToken(ilink);
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
function soundClosePatientList(){
	hidePatListWin();
}
function closeDoListModel() {
	websys_showModal("hide");
	websys_showModal("close");	
}
function clearRAM(frmId,frm) {
	try{
		var frame = null ;
		if (frm){
			frame = frm;
		}else{
			frame = document.getElementById(frmId);
		}
		if (frame.contentWindow.onbeforeunload){
			var oldOnbeforeunload = frame.contentWindow.onbeforeunload;
			var rtn = frame.contentWindow.onbeforeunload.call(window);
			if (rtn){
				var sure = window.confirm(rtn);
				if (!sure){
					frame.contentWindow.onbeforeunload = oldOnbeforeunload;
					return false;
				}
			}
			frame.contentWindow.onbeforeunload = null;
		}
		frame.src = 'about:blank';
		frame.contentWindow.document.write('');//���frame������
		frame.contentWindow.document.clear();
		frame.contentWindow.close(); //����frame�ڴ�й©
		if (navigator.userAgent.indexOf('MSIE') >= 0) {
			if (CollectGarbage) {
				CollectGarbage(); //IE ���� �ͷ��ڴ�
				//ɾ��ԭ�б��
				frame.parentElement.removeChild(frame);
				//���frameset���
				/*var _frame = document.createElement('frame');
				_frame.src = '';
				_frame.name = 'content';
				_frame.id = 'ifr_content';
				tags.appendChild(_frame);*/
			}
		}
		return true;
	}catch(ex){return true;}
}
var EPRCATE85 = {};
EPRCATE85.isEprCategory =function(){
	var showEPRInstance = $("#menuGroupReg").data("showEPRInstance");
	if (showEPRInstance==1) return true;
	return false;
}
//ת�ɲ�˵���ʽ
EPRCATE85.toEprMenu = function (){
	var eprPanel = $(".menugroup-list").eq(0);
	//eprPanel.html("").height("auto");
	eprPanel.panel('options').height = "auto";
	eprPanel.panel('resize');
	$("#menuGroupReg").css("overflow", "auto").data("showEPRInstance", 0);
	$("#menuGroupReg").children(".panel").eq(1).css("display","block");
	$("#menuGroupReg").children(".panel").eq(2).css("display","block");
}
// ת�ɲ���Ŀ¼��ʽ
EPRCATE85.toEprCategory = function (){
	var eprPanel = $(".menugroup-list").eq(0);
	var ofs  = eprPanel.parent().offset();
	$('<div id="eprCategoryContainer"></div>').appendTo(eprPanel);
	$("#menuGroupReg").css("overflow","hidden").data("showEPRInstance",1);
	//eprPanel.height(document.body.clientHeight - ofs.top);
	eprPanel.panel('options').height = document.body.clientHeight - ofs.top; //�����ק�����ߺ���panel�߶���������
	eprPanel.panel('resize');
	eprPanel.children(".i-menugroup").css("display","none"); //���ز�����Ŀ¼
	$("#menuGroupReg").children(".panel").eq(1).css("display","none");
	$("#menuGroupReg").children(".panel").eq(2).css("display","none");
}
function switchToolHandler(){
	var frm = dhcsys_getmenuform();
	var papmi="",adm="",mradm="";
	if (frm) {
		papmi = frm.PatientID.value;
		adm = frm.EpisodeID.value; 
		mradm = frm.mradm.value; 
	}
	if (adm>0){}else{return ;}
	if (EPRCATE85.isEprCategory()){
		reloadMenu(papmi,adm,mradm);
	}else{
		EPRCATE85.toEprCategory();
		// ��ʾ����Ŀ¼
		$.ajax({
			url:"emr.ip.navigation.record.csp?EpisodeID="+adm+"&PatientID="+papmi,
			type:"get",
			success:function(res){
				$("#eprCategoryContainer").html($(res));
			}
		});
	}
}
function addToolHandler(){
	var frm = dhcsys_getmenuform();
	var papmi="",adm="",mradm="";
	if (frm) {
		papmi = frm.PatientID.value;
		adm = frm.EpisodeID.value; 
		mradm = frm.mradm.value;
		var myAdmCategoryIds = [];
		var eprPanel = $(".menugroup-list").eq(0);
		eprPanel.find("ul.i-menugroup>li>a").each(function(){
			var ve = $(this).data("valueexp");
			if (ve.indexOf("CategoryID")>-1){
				var myid = "";
				var stInd = ve.indexOf("CategoryID=")+11;
				var endInd = ve.indexOf("&",stInd);
				if (endInd==-1) {myid = ve.slice(stInd);}
				else {myid = ve.slice(stInd,endInd);}
				myAdmCategoryIds.push(myid);
			}
		});
		websys_showModal({
			title:"ģ��ѡ��",isTopZindex:true,
			url:"emr.ip.navigation.list.template.csp?CategoryIDs="+myAdmCategoryIds.join(",")+"&EpisodeID="+adm+"&PatientID="+papmi
		});
	}
}
websys_on("onHomePageClick",function(opt){
	$.messager.alert("�û�:"+opt.usercode,opt.msg);
});
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
			    //return clearRAM("",iframe);		
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
					try{blurRtn = chartOnBlur();}catch(e){alert("�뿪��ǰҳ�ж�ʱ����"+e.message);}
					if (!blurRtn){return false;};	
			    }
			}
			var frm = dhcsys_getmenuform();
			var papmi="",adm="",mradm="";
			if (frm) {
				papmi = frm.PatientID.value;
				adm = frm.EpisodeID.value;
				mradm = frm.mradm.value;
			}
			if (window.websys_emit){
				var newTabId=title.attr("id");
				if (newTabId.indexOf("dhc_side_emr_cate")>-1){
					websys_emit("onOpenIPTab",{PatientID:papmi,EpisodeID:adm,mradm:mradm});
				}else if (newTabId.indexOf("dhc_side_oe_diagrecord")>-1){
					var obj={
						"PatientListPanel":"emr.browse.episodelist.csp",
						"PatientListPage":"emr.browse.patientlist.csp",
						"SwitchSysPat":"N",
						"LayoutType":2,
						"TMENU":54653,
						"TPAGID":4730731,
						"ChartBookID":70,
						PatientID:papmi,EpisodeID:adm,mradm:mradm
					}
					//websys_emit("onOpenDHCEMRbrowse",obj);
				}else{
					if (websys_getTop().resetSecondScreen) websys_getTop().resetSecondScreen({
						type:"clickwebsysmenu",
						targetName:"main",
						code:newTabId,
						originName:"websys.menugroup"
					})
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
		var off = t.offset();
		var mytop = off.top;
		if (off.top>500){ // ������ʾ
			mytop = off.top-$(this).find(".dropdown-menu").height()+22			
		}
		var myleft = t.find('a b.i-dropdown-arrow')[0].offsetLeft+10;
		$(this).find(".dropdown-menu").offset({top:mytop,left:myleft});
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
	if ($(".patientbar").length>0&&("function"==typeof InitPatInfoHover)) $(".patientbar").closest('.panel-body').panel('options').onResize=InitPatInfoHover;
}
 /*�رղ���ҳ*/
function closeEPRChart(){
	var tabsJObj = $("#tabsReg");
	var targetTab = tabsJObj.tabs("getTabByOpt",{"val":'EMR',key:'itarget'});
	tabsJObj.tabs('close',tabsJObj.tabs('getTabIndex',targetTab));
}
function closeCurrentChart(){
	var tabsJObj = $("#tabsReg");
	var targetTab = tabsJObj.tabs("getSelected");;
	tabsJObj.tabs('close',tabsJObj.tabs('getTabIndex',targetTab));
}
/*NEW VERSIONѭ����������cdss���л����˷���*/
function SwitchPatientTriggerAllCDSS(visitId){
	var menuWin = websys_getMenuWin();
	var CDSSConfig = menuWin.getWebsysCDSSConfig();
	for (var c=0;c<CDSSConfig.length;c++){
		if(menuWin.getWebsysCDSS(CDSSConfig[c].type)){
			menuWin.SwitchPatientFunArray[CDSSConfig[c].type](visitId);
		}
	}
}
function CopyDataForCDSS(type,JsonStr){
	if (typeof JsonStr=="object") JsonStr=JSON.stringify(JsonStr);
	JsonStr = encodeURIComponent(JsonStr);
	switch(type){
		case 'ORDER':
			switchTabByEMR("dhc_side_oe_oerecord",{oneTimeValueExp:"copyCDSSData="+JsonStr});
			break;
		case "DIAG":
			switchTabByEMR("dhc_side_oe_diagrecord",{oneTimeValueExp:"copyCDSSData="+JsonStr});
			break;
	}
	return ;
}
var fixlen=0;   ///�����̶�ҳǩ��,ƥ��request��FixedTabTitle ���ҳǩ��Ŀ
$.parser.onComplete = function(context){
	// ��һ��contextΪundefined,��Ϊ������.
	if (!!context) return ;
	$(".window-mask.alldom").hide(); //.fadeOut("fast");
	init();
}