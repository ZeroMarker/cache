var dw=$(window).width()-166,dh=$(window).height()-80;
var PageObj={
    EMRRowId:"EMR",
	EMRConfigs:"",
	m_admProBardJson:"",
	m_RightBtnJson:"",
	m_CONTEXT:"",
	m_refreshTimeout:120000
}
if (websys_isIE==true) {
	 var script = document.createElement('script');
	 script.type = 'text/javaScript';
	 script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird �ļ���ַ
	 document.getElementsByTagName('head')[0].appendChild(script);
}
function Init(){
	var frm = dhcsys_getmenuform();
	if((frm) &&(ServerObj.EpisodeID=="")){
		$.extend(ServerObj, { EpisodeID:frm.EpisodeID.value,PatientID:frm.PatientID.value,mradm:frm.mradm.value});
	}
	if (ServerObj.EpisodeID!=""){
		onClosePatListWin();
		opdoc.patinfobar.view.InitPatInfo(ServerObj.EpisodeID);
		setTimeout(function(){
			InitAdmProcedureBar();
			InitRightBtnFun();
			InitEvent();
		})
		
	}else{
		$("#InPatListBtn").click(showPatListWin);
		$("#InpatListDiv").data("AutoOpen",1);
		//$(".northpat-div").hide();
		showPatListWin();
	}
}
window.onload = function () {
	setInterval(window.frames['patlistframe'].LoadOutPatientDataGrid(),PageObj.m_refreshTimeout);
}
function InitEvent(){
	$('#tabsReg').tabs('hideHeader');
	$.extend($("#tabsReg").tabs("options"),{
		onSelect:function(title,index){ 
			hrefRefresh(true);
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
			var oldTabTile=oldTab.panel("options").title;	
			var oldIframe = oldTab.find("iframe").get(0);	
			if ( oldIframe ){
				var chartOnBlur = getFrameFun(oldIframe,"chartOnBlur");
				if(chartOnBlur) {
					//�������false,���л�Chart
					var blurRtn = true;
					try{blurRtn=chartOnBlur();}catch(e){dhcsys_alert("�뿪��ǰҳ�ж�ʱ����"+e.message);}
					if (!blurRtn){
						refreshProBarStatus(oldTabTile);
						return false;
					};	
			    }			
			}	
		}	
	});
	// ����click�ظ���ΰ�
	$("#InPatListBtn").unbind("click");
	$("#InPatListBtn").click(showPatListWin);
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
function InitAdmProcedureBar(){
	$(".events ul li:not(#li-tmp)").remove();
	$(".right-line").remove();
	var WinwonWidth=$(window).width();
	var AdmProBarWidth=800;
	$.m({
		ClassName:"DHCDoc.OPDoc.AjaxInterface",
		MethodName:"GetOPDocProBarJsonData",
		EpisodeID:ServerObj.EpisodeID
	},function(jsonData){
		var panel=$(".events ul")
		var templ=$("#li-tmp");
		var json=$.parseJSON(jsonData);
		PageObj.m_admProBardJson=json;
		var len=json.length;
		var left=0;
		for (var i=0;i<len;i++){
			var config=json[i];
			if ((config["preLineClass"]!="")&&(i>=1)) {
				var _$panelli=$("li",panel);
				$("div",_$panelli[_$panelli.length-1]).addClass(config["preLineClass"]);
			}
			var tool=templ.clone();
			tool.removeAttr("style");
		    tool.removeAttr("id");
			var a=$("a",tool).attr("id",config["id"]);
			$("a",tool).text(config["Name"]);
			panel.append(tool);
			if (i!=(len-1)){
				panel.append('<li><div class="line"></div></li>');
			}
			if (config["link"]){
				$("a",tool).attr("data-ilink", config["link"])
						   .attr("data-isxhr", config["isRefresh"]) 
						   .attr("data-itarget", "TRAK_main")
						   .attr("data-id", config["id"]);
			}
			if(config["click"]){
			   var fun=config["click"];
			   if($.type(fun) === "string"){
				    a.click(eval(fun));
			   }else{
				    a.click(fun);
			   }
			   if(ServerObj.NewDocGotoWhere!=""){
				   $('#'+ServerObj.NewDocGotoWhere).trigger("click");
			   }else{
			   		if (i==0) $('#'+config["id"]).trigger("click");
			   }
		   }
		}
		var str = '<iframe frameborder="0" tabindex="-1" src="javascript:false;" style="display:block;position:absolute;z-index:-1;filter:Alpha(Opacity=0);opacity:0;';
		str += 'top:0px;left:0px;width:530px;height:500px;"/>';
		panel.append();
	});
}
var LoadPopover=(function(){
	///��ֹ��γ�ʼ������
	var AlreadLoadObj={};	//��ʼ��Ԫ��
	var AlreadShowObj={};	//��ʼ����ʾ����
	return function(Type,ID){
		if (Type=="Load"){
			if (typeof AlreadLoadObj[ID] =="undefined"){
				AlreadLoadObj[ID] ="1";
				return true;
			}else{
				return false;
			}
		}else if (Type=="Show"){
			if (typeof AlreadShowObj[ID] =="undefined"){
				AlreadShowObj[ID] ="1";
				return true;
			}else{
				return false;
			}
		}
	}
})();
function GetPannelHTML(){
	var innerHTML="";
	var CallFunction={};
	var Title="";
	    innerHTML+='<table id="HisAdmGrid" title="" style="border:1px solid #ccc;"></table>';
		innerHTML+= '<iframe frameborder="0" tabindex="-1" src="javascript:false;" style="display:block;position:absolute;z-index:-1;filter:Alpha(Opacity=0);opacity:0;';
		innerHTML+= 'top:0px;left:0px;width:530px;height:500px;"/>';
	CallFunction=LoadEMRGrid;
	return {
		"innerHTML":innerHTML,
		"CallFunction":CallFunction,
		"Title":Title
	}
}
function LoadEMRGrid(){
	var Columns=[[    
			{field:'AdmRowId', hidden:true},
			{title:'��������',field:'AdmDate',width:90},
			{title:'����',field:'AdmLoc',width:90},
			{title:'ҽ��',field:'AdmDoc',width:90},
			{title:'�����',field:'MainDiagnos',width:200}
	    ]];
		$.m({
		    ClassName:"DHCDoc.OPDoc.AjaxInterface",
		    QueryName:"GetPatAdmList",
		    EpisodeID:ServerObj.EpisodeID
		},function(GridData){
			var GridData=eval('(' + GridData + ')'); 
			$('#HisAdmGrid').datagrid({
			    data:GridData,
			    headerCls:'panel-header-gray',
			    idField:'AdmRowId',
			    fit : false,
			    rownumbers:true,
			    width:500,
			    height:250,
			    border: false,
			    columns:Columns,
			    onDblClickRow:function(index, row){
				    EMRClickHandle(PageObj.EMRConfigs,row["AdmRowId"]);
				}
			});
		});
}
function WhiteEMROnClick(){
	ChangeTabs($(this));	
	refreshProBarStatus($(this).text());
}
function InsertDiagOnClick(){
	ChangeTabs($(this));
	refreshProBarStatus($(this).text());
}
function InsertOrderOnClick(){
	ChangeTabs($(this));
	refreshProBarStatus($(this).text());
}
function InsertCMOrderOnClick(){
	ChangeTabs($(this));
	refreshProBarStatus($(this).text());
}
function CompleteRecAdm(){
	refreshProBarStatus("��ɽ���"); //$(this).text()
	$.ajax("opdoc.outpatcompleteadm.csp", {
		"type" : "GET",
		"dataType" : "html",
		"success" : function(data, textStatus) {
			var $code = $(data);
			createModalDialog("CompletAdm","��ɾ���", 600, 355,"icon-w-edit","",$code,"");
			LoadModalMainContent();
			//�¼�����
			InitBtnClick();
		},
		"error" : function(XMLHttpRequest, textStatus, errorThrown) {
			console.log(textStatus);
		}
	});
}
function PrintAllOnClick(){
	ChangeTabs($(this));
	refreshProBarStatus($(this).text());
}
function ChangeTabs(that){
	var curTab = $('#tabsReg').tabs('getSelected');
	var curIframe = curTab.find("iframe").get(0);
	var curNewIframe=window.frames[curIframe.name];
	if (curNewIframe){
		if ((curIframe.src!="about:blank")&&("function" === typeof curNewIframe.DocumentUnloadHandler)){
			curNewIframe.DocumentUnloadHandler();
		}
	}
	var iid=that.data("id");
	var ilink=that.data("ilink");
	var isxhr=that.data("isxhr");
	var code=ilink.split("?")[0];
	var text=that.text();
	if ($('#tabsReg').tabs("exists",text)){
		$('#tabsReg').tabs("select",text);
	}else{
		var tabOpt = {
			id:ilink.split("?")[0], 
			title:text,
			closable:true,
			ilink:ilink,
			isxhr:isxhr,
			itarget:that.data('itarget'),
			content:'<iframe id="i'+code+'" name="i'+code+"_"+iid+'" src="about:blank" width="100%" min-height="500px" height="100%" frameborder="0"></iframe>'
		};
		$("#tabsReg").tabs('add',tabOpt);
	}
}
function hrefRefresh(forceRefresh){
	// ��������
	tkMakeServerCall("web.DHCDocMainOrderInterface","ChartItemChange");
	var curTab = $('#tabsReg').tabs('getSelected');
	var ilink = curTab.panel("options").ilink;
	if (ilink=="") return;
	var isXhrRefresh = curTab.panel("options").isxhr;
	if (isXhrRefresh=="false") isXhrRefresh=false;
	if (isXhrRefresh=="true") isXhrRefresh=true;
	var valueExp = curTab.panel("options").valueExp||"";
	var oneTimeValueExp = curTab.panel("options").oneTimeValueExp||"";
	valueExp = valueExp+"&"+oneTimeValueExp;
	delete curTab.panel("options").oneTimeValueExp;
	var curIframe = curTab.find("iframe").get(0);
	var curNewIframe=window.frames[curIframe.name];
	if (curNewIframe){
		// isXhrRefresh=��,false����ȫ��ˢ��,���һ��ˢ��
		if ((curIframe.src=="about:blank")||!isXhrRefresh){
			// �Ѳ˵��б��ʽת��json--->�ӵ�xhrRefresh�����
			var objParam={PatientID: ServerObj.PatientID, EpisodeID: ServerObj.EpisodeID, mradm: ServerObj.mradm, forceRefresh: (forceRefresh || false)}
			if (PageObj.m_CONTEXT!="") {
				$.extend(objParam, { CONTEXT: PageObj.m_CONTEXT});
		    }
			var veArr = valueExp.split("&");
			for(var ve=0; ve<veArr.length; ve++){
				var veItem = veArr[ve].split("=");
				if (veItem[0]&&veItem.length>1) objParam[veItem[0]] = veItem[1];
			}
			var lnk=rewriteUrl(ilink,objParam);
	 		curIframe.src = lnk;
		}else{
			var obj = {papmi: ServerObj.PatientID, adm: ServerObj.EpisodeID, mradm: ServerObj.mradm};
			if (PageObj.m_CONTEXT!="") {
				$.extend(obj, { CONTEXT: PageObj.m_CONTEXT});
		    }
			// �Ѳ˵��б��ʽת��json--->�ӵ�xhrRefresh�����
			var veArr = valueExp.split("&");
			for(var ve=0; ve<veArr.length; ve++){
				var veItem = veArr[ve].split("=");
				if (veItem[0]&&veItem.length>1) obj[veItem[0]] = veItem[1];
			}
			if ("function" === typeof curNewIframe.xhrRefresh){
				curNewIframe.xhrRefresh(obj);
			}else if (curNewIframe.contentWindow && "function" === typeof curNewIframe.contentWindow.xhrRefresh){
				curNewIframe.contentWindow.xhrRefresh(obj);	
			}
		}
	}
}
function refreshProBarStatus(selTabText){
	var curTab = $('#tabsReg').tabs('getSelected');
	var curTabTile=curTab.panel("options").title;
	if (selTabText !=curTabTile) return;
	$(".sel-line").removeClass("sel-line");
	$(".sel-li-a").removeClass("sel-li-a");
	$(".oldsel-li-a").removeClass("oldsel-li-a");
	var $li=$(".events li");
	for (var i=1;i<$li.length;i++){
		var $ch_a=$($li[i]).children('a');
		var $ch_l=$($li[i]).children('.line');
		if ($ch_a.length>0){
			var text=$ch_a[0].text;
			if (text==selTabText){
				$ch_a.addClass("sel-li-a");
				break;
			}else{
				$ch_a.addClass("oldsel-li-a");
			}
		}else{
			$ch_l.addClass("sel-line");
		}
	}
}
function InitRightBtnFun(){
	var defBtnCount=$.m({
		 ClassName:"web.DHCDocConfig",
		 MethodName:"GetConfigNode",
		 Node:"RecAdmDefShwoBtnCount",
		 HospId:session['LOGON.HOSPID']
	},false);
	if (defBtnCount==0) defBtnCount=6;
	$.q({
		ClassName:"DHCDoc.OPDoc.TreatStatusConfigQuery",
		QueryName:"TreatStatusConfig",
		CSPMain:"opdoc.outpatrecadm.csp",
		ActiveOrNo:"1",
		HospId:session['LOGON.HOSPID'],
		page:1,  
		rows:200
   },function(Data){
	    PageObj.m_RightBtnJson=Data.rows;
		toolbarConfigRender(Data.rows,defBtnCount);
		//InitEMRPopover();
   });
}
function InitEMRPopover(){
	$("#"+PageObj.EMRRowId).mouseover(function(e){
		if (LoadPopover("Load","EMR"+"_"+ServerObj.EpisodeID)){
			var HTML=GetPannelHTML("EMR");
			if (HTML.innerHTML==""){return;}
			$("#EMR").webuiPopover({
				width:530,
				height:300,
				title:"�����б�",
				content:HTML.innerHTML, //HTML.innerHTML
				trigger:'hover',
				placement:'bottom-left',
				onShow:function(){
					if (LoadPopover("Show","EMR"+"_"+ServerObj.EpisodeID)){
						if (typeof HTML.CallFunction == "function"){
							HTML.CallFunction.call();
						}
					}
				}
			});
			$("#EMR").webuiPopover('show');
		}
	});
}
function toolbarConfigRender(configs,defBtnCount){
	var panel=$(".i-btn-right");
	var temp=$("#btn-right-temp");
	var MenuBtn=$(".i-btn-right .hisui-menubutton");
	var dropDownMenu=$("#moreRightBtn");
	for(var i=0,len=configs.length;i<len;++i){
		(function(i){
		    var config=configs[i];
			var fun=config["clickHandler"];
			if (i<defBtnCount){
				var tool=temp.clone();
					tool.removeAttr("style");
					tool.attr('id',config["toolId"]);
					//tool.attr('data-options',"iconCls:'"+config["iconStyle"]+"'")
					tool.text(config["name"]);
					panel.append(tool);
					if(fun){
					    if($.type(fun) === "string"){
						    //tool.click(eval(fun));
						    tool.click((function(){
							    return function(){
								    eval("("+fun+")")(config)
								};
							})(fun,config));
					    }else{
						    //tool.click(fun);
						    tool.click(fun(config));
					    }
				    }
			}else{
				MenuBtn.removeAttr("style");
				// ׷��һ�������˵�
				dropDownMenu.menu('appendItem', {
					id:config["toolId"],
					text: config["name"],
					//iconCls:config["iconStyle"],
					onclick: (function(){
							    return function(){
								    eval("("+fun+")")(config)
								};
							})(fun,config) //eval(fun)
				});

			}
			if (config["toolId"]==PageObj.EMRRowId){PageObj.EMRConfigs=config;}
		 })(i)
	}
	$HUI.linkbutton(".hisui-linkbutton",{});
	renderRightBtnStatus();
}
function renderRightBtnStatus(){
	//������������ξ�����ť���Ϸ���ʾ��ɫ��
	$("#EMR,#PAAllergy").removeClass('tabItem');
	$(".tabItem_badge").remove();
	$.cm({
		ClassName:"DHCDoc.OPDoc.AjaxInterface",
		MethodName:"GetOPInfoJosn",
		EpisodeID:ServerObj.EpisodeID,
		LogLocID:session['LOGON.CTLOCID']
	 },function(Data){
	    var LocAdmHistoryCount=Data[0]['LocAdmHistoryCount'];
	    if (LocAdmHistoryCount>0){
		    $("#EMRBrowsing").addClass('tabItem').append('<sup class="tabItem_badge">'+LocAdmHistoryCount+'</sup>');
		}
	    var AllergyCount=Data[0]['AllergyCount'];
	    if (+AllergyCount>0){
		    $("#PAAllergy").addClass('tabItem').append('<sup class="tabItem_badge">'+AllergyCount+'</sup>');
		}
    });
}
function EMRClickHandle(config,AdmRowId){
	var objParam={PatientID: ServerObj.PatientID, EpisodeID: ServerObj.EpisodeID, mradm: ServerObj.mradm};
	if ((AdmRowId!="")&&(AdmRowId!=undefined)){
	    $.extend(objParam, { EpisodeID: AdmRowId});
	}
	var src=rewriteUrl(config["URLconfig"],objParam);
	src=src+"&OpenWinName=OPDocRecAdm";
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("DocApp",config["name"], dw+40, dh,config["iconStyle"],"",$code,"");
}
function PAAllergyClickHandle(config){
	var objParam={PatientID: ServerObj.PatientID, EpisodeID: ServerObj.EpisodeID, mradm: ServerObj.mradm};
	var src=rewriteUrl(config["URLconfig"],objParam);
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("DocApp",config["name"], dw, dh,config["iconStyle"],"",$code,"");
}
function TransAdmClickHandle(config){
	alert("ת��");
}
function DoctorAppointClickHandle(config){
	var objParam={PatientID: ServerObj.PatientID, EpisodeID: ServerObj.EpisodeID, mradm: ServerObj.mradm};
	var src=rewriteUrl(config["URLconfig"],objParam);
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("DocApp",config["name"], dw, dh,config["iconStyle"],"",$code,"");
}
function CreateInpatCertifyClickHandle(config){
	var objParam={PatientID: ServerObj.PatientID, EpisodeID: ServerObj.EpisodeID, mradm: ServerObj.mradm};
	var src=rewriteUrl(config["URLconfig"],objParam);
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("CreatNewBook",config["name"], dw, dh+60,config["iconStyle"],"",$code,"");
}
//�Ҳఴť��������¼�
function BtnComClickHandle(config){
	var objParam={PatientID: ServerObj.PatientID, EpisodeID: ServerObj.EpisodeID, mradm: ServerObj.mradm};
	var src=rewriteUrl(config["URLconfig"],objParam);
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("CreatNewBook",config["name"], dw, dh,config["iconStyle"],"",$code,"");
}
function PreCardBillClickHandle(){
	var groupDR = session['LOGON.GROUPID'];
    var locDR = session['LOGON.CTLOCID'];
    var hospDR = session['LOGON.HOSPID'];
    var expStr = groupDR + "^" + locDR + "^" + hospDR;
	$.m({
		ClassName:"web.udhcOPBillIF",
		MethodName:"GetCheckOutMode",
		expStr:expStr
	},function(mode){
		var PatDefCardInfo=$.cm({ 
			ClassName:"web.DHCOPAdmReg",
			MethodName:"GetValidAccMNoCardNo",
			PatientID:ServerObj.PatientID,
			dataType:"text"
		}, false);
		$("#CardBillCardTypeValue").val(PatDefCardInfo.split("^").slice(1,PatDefCardInfo.split("^").length).join("^")); 
       	var CardNo = PatDefCardInfo.split("^")[0];
		if(mode == 1) {
			if (CardNo == "") {
		       	$.messager.alert("��ʾ","�û����޶�Ӧ����Ϣ,���ܽ���Ԥ�۷�!");
		       	return false;
		    }
		    $.messager.confirm('��ʾ', '�Ƿ�ȷ�Ͽ۷�?', function(r){
			    if (r){
			    	var insType = "";
					var oeoriIDStr = "";
					var guser = session['LOGON.USERID'];
					var rtn = checkOut(CardNo,ServerObj.PatientID,ServerObj.EpisodeID,insType,oeoriIDStr,guser,groupDR,locDR,hospDR,CardBillAfterReload);
					//CardBillAfterReload();
				}
			});
        	return;
			
		}else {
		 	var CardTypeValue = $("#CardBillCardTypeValue").val();
		 	var CardTypeRowId = (CardTypeValue != "") ? CardTypeValue.split("^")[0] : "";
 			var url = "dhcbill.opbill.charge.main.csp?ReloadFlag=3&CardNo=" + CardNo + "&SelectAdmRowId=" + ServerObj.EpisodeID + "&SelectPatRowId=" + ServerObj.PatientID + "&CardTypeRowId=" + CardTypeRowId;
			websys_showModal({
				url: url,
				title: 'Ԥ�۷�',
				iconCls: 'icon-w-inv',
				width: '97%',
				height: '85%',
				isTopZindex:true,
				onClose: function() {
					CardBillAfterReload();
				}
			});
		}	 	
	});
}

function CardBillAfterReload(){
	opdoc.patinfobar.view.InitPatInfo(ServerObj.EpisodeID);
 	//����ǰѡ��ҳ����ҽ��¼�룬��ˢ�±������
 	var curTab = $('#tabsReg').tabs('getSelected');
	var curIframe = curTab.find("iframe").get(0);
	var curNewIframe=window.frames[curIframe.name];
	if (curNewIframe){
		if ("function" === typeof curNewIframe.CardBillAfterReload){
			curNewIframe.CardBillAfterReload();
		}
	}
}
function StopOrderClickHandle(){
	alert("ͣҽ��")
}
function CancelRecAdmClickHandle(){
	$.m({
		ClassName:"web.SSUser",
		MethodName:"GetDefaultCareProvider",
		userID:session['LOGON.USERID']
	},function(DoctorId){
		$.m({
			ClassName:"web.DHCDocOutPatientList",
			MethodName:"CancelAdmiss",
			Adm:ServerObj.EpisodeID,
			DocDr:DoctorId
		},function(myrtn){
			if (myrtn!='0')	{
				if (myrtn=="NoToday"){
					$.messager.alert("��ʾ",t['CancelAdmissFailure']+',ֻ��ȡ�����վ���Ľ���.');
				}else if (myrtn=="NoAdmiss") {
					$.messager.alert("��ʾ",t['CancelAdmissFailure']+',δ����ľ��ﲻ��ȡ��.');
				}else if (myrtn=="NoSelf") {
					$.messager.alert("��ʾ",t['CancelAdmissFailure']+',ֻ��ȡ�����˽���ľ����¼.');
				}else if (myrtn=="NoInitData") {
					$.messager.alert("��ʾ",t['CancelAdmissFailure']+',δ�õ�����״̬�ı��¼.');
				}else if (myrtn=="InsertFail") {
					$.messager.alert("��ʾ",t['CancelAdmissFailure']+',���б��¼����ʧ��.');
				}else if (myrtn=="UpdateAdmDocFail") {
					$.messager.alert("��ʾ",t['CancelAdmissFailure']+',���¾��������ҽ��ʧ��.');
				}else if (myrtn=="diagnos") {
					$.messager.alert("��ʾ","�����Ѿ�¼����ϻ��ߴ�����Ч��ҽ������ȡ������!")
				}else if (myrtn=="AddMark") {
					$.messager.alert("��ʾ","�ӺŻ��߲���ȡ������!")
				}else {
					$.messager.alert("��ʾ",t['CancelAdmissFailure']);
				}
				return false;
			}else{
				$.messager.alert("��ʾ",t['CancelAdmissSeccess'],"info",function(){
					window.frames['patlistframe'].LoadOutPatientDataGrid();
					showPatListWin();
				});
			}
		});
	});
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
	if($("#modalIframe").length<1){
		$('body').append('<iframe id="modalIframe" style=\"position: absolute; z-index: 1999; width: 100%; height: 100%; top: 0;left:0;scrolling:no;\" frameborder=\"0\"></iframe>');
	}else{
		$("#modalIframe").css("display","block")		
	}
	$("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;

    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        border:'thick',
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        isTopZindex:true,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        isTopZindex:true,
        onClose:function(){
	        destroyDialog(id);
	        $("#modalIframe").hide();
	    }
       // buttons:buttons
    });
    //$("#"+id).parent().append('<iframe style=\"position: absolute; z-index: -1; width: 100%; height: 100%; top: 0;left:0;scrolling:no;\" frameborder=\"0\"></iframe>');
}
function destroyDialog(id){
	$("body").remove("#"+id); //�Ƴ����ڵ�Dialog
	$("#"+id).dialog('destroy');
}
function InitBtnClick(){
	$("#btn-Comfirm").click(BComfirmclickhandler);
	$("#btn-ConfirmEmr").click(BConfirmEmrclickhandler);
	$("#btn-Cancel").click(function(){$("#CompletAdm").dialog("close");});
	$("#callPatient").click(callPatientHandler);
	$("#reCallPatient").click(reCallPatientHandler);
	$("#skipAndCallPatient").click(skipCallPatientHandler);
	$("#ReceiveNextPat").click(ReceiveNextPat);
}
//��ɾ��ﲢ�������ﲡ��
function BConfirmEmrclickhandler(){
	tkMakeServerCall("web.DHCDocMainOrderInterface","ChartItemChange");
	var rtn=ComplateAdm();
	$("#CompletAdm").dialog("close");
	var curTab = $('#tabsReg').tabs('getSelected');
	var title=curTab.panel("options").title;
	if (title!="���ﲡ��"){
		$('#tabsReg').tabs('select',"���ﲡ��");
	}
	findPatientTree();
}
//��ɾ��ﲢ���ز����б����
function BComfirmclickhandler(){
	var rtn=ComplateAdm();
	if (rtn!="0"){
		$.messager.alert("��ʾ",rtn.split("^")[1]);
		return false;
	}else{
		tkMakeServerCall("web.DHCDocMainOrderInterface","ChartItemChange");
		$("#CompletAdm").dialog("close");
		findPatientTree();
		showPatListWin();
	}
}
function ComplateAdm(){
	var rtn=$.cm({
		ClassName:"web.DHCDocOutPatientList",
		MethodName:"SetComplate",
		Adm:ServerObj.EpisodeID,
		LocId:session['LOGON.CTLOCID'],
		UserId:session['LOGON.USERID'],
		dataType:"text"
	},false);
	return rtn;
}
//����
function callPatientHandler(){
	var rtn=ComplateAdm();
	if (rtn!="0"){
		$.messager.alert("��ʾ",rtn.split("^")[1]);
		return false;
	}else{
		var IPAddress = GetComputerIp();
		if (!IPAddress) {
			IPAddress = "";
		} 
		if((IPAddress!="Exception")&&(IPAddress!="")){
			var ret=tkMakeServerCall("web.DHCVISQueueManage","RunNextButton","","",IPAddress);
		}else{
		    var ret=tkMakeServerCall("web.DHCVISQueueManage","RunNextButton");
		}
		CalledAfter(ret);
	}
}
function findPatientTree(){
	window.frames['patlistframe'].LoadOutPatientDataGrid();
}
//�ظ�����
function reCallPatientHandler(){
	var IPAddress = GetComputerIp();
	if (!IPAddress) {
		IPAddress = "";
	} 
	if((IPAddress!="Exception")&&(IPAddress!="")){
		var ret=tkMakeServerCall("web.DHCVISQueueManage","RecallButton","","",IPAddress);
	}else{
	    var ret=tkMakeServerCall("web.DHCVISQueueManage","RecallButton");
	}
	CalledAfter(ret);
}
//���Ų�������һλ
function skipCallPatientHandler(){
	$.cm({
		ClassName:"web.SSUser",
		MethodName:"GetDefaultCareProvider",
		userID:session['LOGON.USERID'],
		dataType:"text"
	},function(DoctorId){
		$.cm({ 
			ClassName:"web.DHCDocOutPatientList",
			MethodName:"SetSkipStatus",
			Adm:ServerObj.EpisodeID,
			DocDr:DoctorId
		},function(stat){
			if (stat!='1'){
				$.messager.alert("��ʾ",t['StatusFailure']);
				return false;
			}
			var IPAddress = GetComputerIp();
			if (!IPAddress) {
				IPAddress = "";
			} 
			if((IPAddress!="Exception")&&(IPAddress!="")){
				var ret=tkMakeServerCall("web.DHCVISQueueManage","RunNextButton","","",IPAddress);
			}else{
			    var ret=tkMakeServerCall("web.DHCVISQueueManage","RunNextButton");
			}
			CalledAfter(ret);
			showPatListWin();
			return true;
		});
	});
	
}
function GetComputerIp(){
	return ClientIPAddress;
   /*var ipAddr="";
   var locator = new ActiveXObject ("WbemScripting.SWbemLocator");
   //���ӱ���������
   var service = locator.ConnectServer(".");
   //��ѯʹ��SQL��׼ 
   var properties = service.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration");
   var e = new Enumerator (properties);
   var p = e.item ();
   for (;!e.atEnd();e.moveNext ())  {
		var p = e.item ();
		//IP��ַΪ��������,�������뼰Ĭ��������ͬ
		ipAddr=p.IPAddress(0);
		if(ipAddr) break;
	}
	return ipAddr;*/
}
//����
function ReceiveNextPat(){
	var rtn=ComplateAdm();
	if (rtn!="0"){
		$.messager.alert("��ʾ",rtn.split("^")[1]);
		return false;
	}else{
		//ˢ�»����б�
		window.frames['patlistframe'].LoadOutPatientDataGrid();
		//���ں��л���IDΪ��,��ȡ�����б��һ���Ⱥ���
		$.cm({
			ClassName:"web.DHCDocOutPatientList",
			MethodName:"GetNextPatMethod",
			LocId:session['LOGON.CTLOCID'],
			UserId:session['LOGON.USERID'],
			dataType:"text"
		},function(NextCallPat){
			if (NextCallPat==""){
				$.messager.confirm('ȷ�϶Ի���',"û�����ڵȴ�����Ļ���,�Ƿ񷵻����ﻼ���б�?",function(r){
					if (r){
						$("#CompletAdm").dialog("close");
						showPatListWin();
					}else{
						$("#CompletAdm").dialog("close");
					}
					return false;
				})
			}else{
				var NextCallPatArr=NextCallPat.split("^");
				switchPatient(NextCallPatArr[1],NextCallPatArr[0],NextCallPatArr[2],"�Ⱥ�");
				$("#CompletAdm").dialog("close");
			}
		});
	}
}
//��һλ���ﻼ����Ϣ
//�Ѿ�������
//δ��������
/*
"ClassName":"DHCDoc.OPDoc.PatientList","MethodName":"OutPatientList",
		"LocID":session['LOGON.CTLOCID'],"UserID":session['LOGON.USERID'],
		"IPAddress":"","AllPatient":"","PatientNo":"","SurName":"",
		"StartDate":"","EndDate":"","ArrivedQue":"","RegQue":"",
		"Consultation":"","MarkID":"","CheckName":""
*/
function LoadModalMainContent(){
	$.m({
	    ClassName : "DHCDoc.OPDoc.PatientList",
	    MethodName : "OutPatientListCatCount",
	    LocID: session['LOGON.CTLOCID'],
	    UserID: session['LOGON.USERID'],
	    IPAddress: "",
	    AllPatient: "",
	    PatientNo: "",
	    SurName: "",
	    StartDate: "",
	    EndDate: "",
	    ArrivedQue: "",
	    RegQue: "",
	    Consultation: "",
	    MarkID:"",
	    CheckName:""
	},function(data){
		var data=eval("("+data+")");  //"{"RegQue":4,"Complete":0,"Report":0}"
		for(var pro in data){
			$("#"+pro).text(data[pro]);
		}
	}); 
}
/**
*  @param {String} tabName �˵�Code.���˵�Code��
*  @param {Object} cfg     ���Ӳ���
*  �л�ҳǩ����,���û�д����
* parent.switchTabByEMR("dhc.side.oe.diagrecord") �л�������Ϊdhc.side.oe.oemanage��ҳǩ
* parent.switchTabByEMR("dhc.side.oe.diagrecord",{oneTimeValueExp:"ReportId=123456"}) �л�������Ϊdhc.side.oe.oemanage��ҳǩ
*/
function switchTabByEMR(tabName,cfg){
	switchTabByEMRAndOpt(tabName,undefined,cfg);
}
function switchTabByEMRAndOpt(tabName,tabOption,cfg){
	if (tabName==""){
		$.messager.alert("��ʾ","�봫��Ҫ�򿪵�ҳǩ��!");
		return false;
	}
	var oldtabName=tabName;
	if (tabName=="�в�ҩ¼��"){
		tabName="��ҩ¼��";
		PageObj.m_CONTEXT="W50007";
	}
	var FindTab=0;
	for (var i=0;i<PageObj.m_admProBardJson.length;i++){
		var iid=PageObj.m_admProBardJson[i]['id'];
		var ilink=PageObj.m_admProBardJson[i]['link'];
		var isxhr=PageObj.m_admProBardJson[i]["isRefresh"];
		var code=ilink.split("?")[0];
		var text=PageObj.m_admProBardJson[i]['Name'];
		if (tabName==text) {
			if ($('#tabsReg').tabs("exists",text)){
				$.extend($('#tabsReg').tabs('getTab',text).panel("options"),  cfg) ;
				var curTab = $('#tabsReg').tabs('getSelected');
				if (curTab.panel("options").title==tabName) {
					hrefRefresh(true);
				}else{
					$('#tabsReg').tabs("select",text);
				}
			}else{
				var tabOpt = {
					id:ilink.split("?")[0], 
					title:text,
					closable:true,
					ilink:ilink,
					isxhr:isxhr,
					itarget:"TRAK_main",
					content:'<iframe id="i'+code+'" name="i'+code+"_"+iid+'" src="about:blank" width="100%" min-height="500px" height="100%" frameborder="0"></iframe>'
				};
				$.extend(tabOpt,cfg)
				$("#tabsReg").tabs('add',tabOpt);
			}
			refreshProBarStatus(text);
			FindTab=1;
			PageObj.m_CONTEXT="";
			break;
		}
	}
	if (FindTab==0){
		$.messager.alert("��ʾ",tabName+" �˵�������,�����ڡ�������ʾ��Ϣ���á�->��������Ϣչʾ������ά��!");
		return false;
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
	var tab = $("#tabsReg").tabs('getTab',tabName);
	if (!tab) { 
		console.log("δ�ҵ���"+tabName+"��ҳǩ!");
		return ;
	}
	var Tabframe = tab.find("iframe").get(0);
	var newTabframe=window.frames[Tabframe.name];
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
//�����б�
function showPatListWin(){
	//if ($("#InpatListDiv .panel").css('display')!=="none") return ;
	if ($("#InpatListDiv").data("AutoOpen")==1){
		//$("#patlist").panel({closable:false});
		$("#patlist").window({closable:false,maximizable:false});
	}else{
		//$("#patlist").panel({closable:true});
		$("#patlist").window({closable:true,maximizable:true});
	}
	//$("#patlist").panel("open");
	$("#patlist").window("open");
}
function hidePatListWin(){
	if ($("#InpatListDiv").data("AutoOpen")==1){
		// δѡ����ʱ,���������ز����б�
	}else{
		//$("#patlist").panel("close");
		$("#patlist").window("close");
	}
}
function onOpenPatListWin(){
	if ($("#patlist").find("iframe").get(0).src=="about:blank") {
		$("#patlist").find("iframe").get(0).src="opdoc.outpatientlist.csp"; //?openWinName=recAdm
	}
	//var opt = {'z-index':9085,'position':'fixed'};
	//var panelJObj = $("#InpatListDiv .panel");
	var patListJObj = $("#patlist");
	if ($("#InpatListDiv").data("AutoOpen")==1){
		// δѡ�в���ʱ,ȫ����ʾ�����б�
		//panelJObj.css($.extend({},opt,{right:'4px',top:'4px'}));
		//patListJObj.panel('resize', { width:$(window).width()-8, height:$(window).height()-8 } );
		patListJObj.window('resize', {left:0,top:0, width:$(document.body).width(), height:$(document.body).height() } );
	}else{
		//panelJObj.css($.extend({},opt,{right:'10px',top:'38px'}));
		//patListJObj.panel('resize', { width:1300, height:$(window).height()-45 });
		patListJObj.window('resize', {left:$(document.body).width()-1090-10,top:38, width:1090, height:$(document.body).height()-45 });
	}
	//$(".window-mask.alldom").show();
	if (window.frames['patlistframe'].ResizePatListWindow) {
		window.frames['patlistframe'].ResizePatListWindow();
	}
}
function onClosePatListWin(){
	$(".window-mask.alldom").hide();
}
/*
 �л�����
*/
function switchPatient(patientId,episodeId,mradm,WalkStatus){
	$("#InpatListDiv").data("AutoOpen",0);
	setEprMenuForm(episodeId,patientId,mradm,"");
	$.extend(ServerObj, { EpisodeID:episodeId,PatientID:patientId,mradm:mradm});
	refreshBar();
	if (PageObj.m_admProBardJson!=""){
		if (WalkStatus=="�Ⱥ�"){
			//�Ⱥ���ֱ�Ӱ�ҳǩ��λ�����ﲡ�����棬����Ҫ�ٵ���ˢ�����ﲡ��
			var ItemId=PageObj.m_admProBardJson[0]['id'];
			var name=PageObj.m_admProBardJson[0]['Name'];
			var curTab = $('#tabsReg').tabs('getSelected');
			var title=curTab.panel("options").title;
			if (title==name){
				hrefRefresh();
			}else{
				if (!$('#tabsReg').tabs('exists',name)) {
					$('#'+ItemId).trigger("click");
				}else{
					$('#tabsReg').tabs('select',name);
				}
			}
			refreshProBarStatus(name);
		}else{
			var tmp = {
			    papmi : patientId,
			    adm : episodeId,
			    mradm : mradm
			};
			invokeChartFun('���ﲡ��','xhrRefresh',tmp); 
			hrefRefresh();
		}
	}
}
var setEprMenuForm = function(adm,papmi,mradm,canGiveBirth){
	var frm = dhcsys_getmenuform();
	if (frm){
		frm.EpisodeID.value = adm; 		
		frm.PatientID.value = papmi; 		
		frm.mradm.value = mradm; 	
		if(frm.AnaesthesiaID) frm.AnaesthesiaID.value = "";
		if (frm.canGiveBirth) frm.canGiveBirth.value = canGiveBirth;
		if(frm.PPRowId) frm.PPRowId.value = "";
	}
}
function refreshBar(){
	$(".northpat-div").show();
	opdoc.patinfobar.view.InitPatInfo(ServerObj.EpisodeID);
	setTimeout(function(){
		if (PageObj.m_RightBtnJson==""){
			InitRightBtnFun();
		}else{
			renderRightBtnStatus();
		}
		if (PageObj.m_admProBardJson==""){
			InitAdmProcedureBar();
		}
		InitEvent();
	})
}
/*function getConfigUrl(userId,groupId,ctlocId){
	return {title:"��������",url:"oeorder.oplistcustom.config.hui.csp",width:700,height:525};	
}*/
function CalledAfter(ret){
	if (ret!=""){
		var alertCode=ret.split("^")[0];
		var alertMsg=ret.split("^")[1];
		if (alertCode==0){
			$.messager.popover({msg: alertMsg,type:'success',timeout: 3000});
			findPatientTree();
			return true;
		}else{
			$.messager.alert("��ʾ", alertMsg);
		}
	}
}
/**
* @param {String} url ����·�� ��: https://127.0.0.1/dthealth/web/csp/test.csp?EpisodeId=1&UserId=1
* @param {Object} obj ֱ�Ӷ��� ��: {"EpisodeId":2,OrderId:"2||1"}
* @return {String} ��Ϻ��url�� ��:https://127.0.0.1/dthealth/web/csp/test.csp?EpisodeId=2&UserId=1&OrderId=2||1
*/
function rewriteUrl(url, obj){
	var reg,flag, indexFlag = false;
	var indexFlag = (url.indexOf("?")==-1);
	if (indexFlag){
		url += "?";	
	}
	var objCount=0
	for (var i in obj){	
		if(obj.hasOwnProperty(i)){
			flag = false; 	
			if(!indexFlag){
				reg =  new RegExp(i+"=(.*?)(?=$|&)","g");
				url = url.replace(reg, function(m1){
					flag = true;
					return i+"="+obj[i];
				});
			}
			if(!flag){
				if ((indexFlag)&&(objCount==0)){
					url  +=   i + "=" + obj[i];
				}else{
					url  +=   "&" + i + "=" + obj[i];
				}
				objCount++;
			}
		}
	}
	return encodeURI(url);	
}
function getConfigUrl(userId,groupId,ctlocId){
	return {title:"��������",url:"oeorder.oplistcustom.config.hui.csp",width:710,height:600};	
}
function ReshOrder(){
	var text=$g("ҽ��¼��")
	if ($(".sel-li-a").text()==text){
		hrefRefresh("")
	}
}
function GetCurframeObj(){
	var curTab = $('#tabsReg').tabs('getSelected');
	var curTabOpts=curTab.panel('options');
	var ilink = curTab.panel("options").ilink;
	var valueExp = curTab.panel("options").valueExp||"";
	var oneTimeValueExp = curTab.panel("options").oneTimeValueExp||"";
	var curIframe = curTab.find("iframe").get(0);
	var curNewIframe=window.frames[curIframe.name];
	var CurframeObj={
		frameName:curIframe.name,
		frameId:curIframe.id,
		frameDesc:curTabOpts.title
	};
	return CurframeObj;
}