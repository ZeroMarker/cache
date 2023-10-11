/**
 * Tab措施任务文书
 * nur.hisui.intervreportconfig.js
 * 
*/
//2758853【护理计划配置】业务界面整合
var PageLogicObj={
	iframeflag:'1',
	iframeInterventionextreport:'0'	
	
}
$(function () {
	InitHospList();
	ReloadiframeonSelect();
	ResetDomSize();
	setTimeout(setIframeSrc, 10);
});
window.addEventListener("resize", ResetDomSize);
function ReloadiframeonSelect(){
	$('#config-accordion').accordion({
		onSelect: function (title) {
			if(title=="文书配置"){
				if (PageLogicObj.iframeInterventionextreport=='0'){
					$("#iframeInterventionextreport")[0].contentWindow.location.reload(false);
					PageLogicObj.iframeInterventionextreport=1;
				}
			}
		}
	});		
}
//初始化医院列表
function InitHospList() {
	try {
		// 多院区
		var sessionInfo = session["LOGON.USERID"] + '^' + session["LOGON.GROUPID"] + '^' + session["LOGON.CTLOCID"] + '^' + session["LOGON.HOSPID"];
		var hospComp = GenHospComp("Nur_IP_Question", sessionInfo);
		hospComp.jdata.options.onSelect = function (e, t) {
			if (t) {
				//选择医院刷新界面
				//护理措施配置界面
				iframeInterventions.window.ReloadInterventionsList();
				//任务配置界面
				iframeInterventionlinktasksetting.window.ReloadInterventionLinkTaskList();
				//文书配置界面
				iframeInterventionextreport.window.ReloadInterventionExtReportList();

			}
		}
		hospComp.jdata.options.onLoadSuccess = function (data) {
			if (data) {
				 if(navigator.userAgent.indexOf('Trident') > -1){//IE 11
					setTimeout(function(){
						iframeInterventions.window.Init();
						iframeInterventionlinktasksetting.window.Init();
						iframeInterventionextreport.window.Init();

					},200);
				 }else{ //非IE 11
				 	try{
						iframeInterventions.window.onload = function(){
						    iframeInterventions.window.Init();
						}

						iframeInterventionlinktasksetting.window.onload = function(){
							iframeInterventionlinktasksetting.window.Init();
						}
						iframeInterventionextreport.window.onload = function(){
							iframeInterventionextreport.window.Init();
						}
					}
				 	catch(err){
					 	
					}

				 }				
			}
		}
	} catch (ex) {
		// 兼容老项目，非多院区的场景
		$("#_HospList").combobox({
			url:
				$URL +
				"?1=1&ClassName=Nur.NIS.Service.ReportV2.LocUtils" +
				"&QueryName=GetHospitalList&ResultSetType=array",
			valueField: "HospitalId",
			textField: "HospitalDesc",
			defaultFilter: 4,
			width: 250,
			value: session['LOGON.HOSPID'],
			onSelect: function (e, t) {
				if (t) {
				}
			},
			onLoadSuccess: function (data) {
				if (data) {
					iframeInterventions.window.onload = function(){
						iframeInterventions.window.Init();
						iframeInterventionlinktasksetting.window.Init();
						iframeInterventionextreport.window.Init();
					}				
				}
			}
		});
	}
}
function addiFrametoEditWindow(url,name,Width,Height){
	if(url){
		// MWToken 改造
		url = getIframeUrl(url);
		if ((Width=="")||(Height=="")){
			var Height = window.innerHeight*0.618+30;
			var Width= window.innerWidth*0.618+30;
		}
		$('#EditWindow').css({visibility:'visible'})
		$('#EditWindow').dialog({
			modal:true,
			content:addiFramecontent(url),
	        width:Width,
	        height:Height,
	        maximizable:false,
	        closable:true,
	        href:'',
	        title:name,
	        onOpen:function(){              
	        },
	        onClose:function(){
		        InitHospList()
		    }
		});
	}
	
}
function addiFramecontent(url){	 
	 return '<iframe id="TempIFrame" name="TempIFrame"  scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';	
}

function ResetDomSize() {
	setTimeout(function () {
		var Height = $("#tabs",window.parent.document).height();	    
		var tabsheaderHeight = $("#tabs",window.parent.document).children(".tabs-header").height();
		var layoutHeight = Height-tabsheaderHeight; 	
	    var northHeight = $("#NorthDivParent").height();	//Tab 页签下【所属医院】Div 高度 
	    $(".hisui-layout").layout("resize").layout('panel', 'center').panel('resize', {
	        height: layoutHeight-northHeight,
	        width: '100%'
	    });													//Tab 页签下中心Div 高度 
	    $('#WestDivChild').css({
				height:layoutHeight-northHeight-10,
	    });
	    //var WestDivChildWidth=$('#WestDivChild').width();													//Tab 页签下中心Div下左侧Div高度
		$("#NurseInterventionsPanel").parent().css({
				height:layoutHeight-northHeight-10,	
	    });													//Tab 页签下中心Div下左侧Div的Panel高度	    

    },50);
}

function setIframeSrc() {
 	var s_iframeInterventions =getIframeUrl("nur.hisui.interventionssetting.csp");
    var s_iframeInterventionlinktasksetting =getIframeUrl("nur.hisui.interventionlinktasksettingV2.csp");
    var s_iframeInterventionextreport =getIframeUrl("nur.hisui.interventionextreportsettingV2.csp");
       
    var iframeInterventions = document.getElementById('iframeInterventions');
    var iframeInterventionlinktasksetting = document.getElementById('iframeInterventionlinktasksetting');
    var iframeInterventionextreport = document.getElementById('iframeInterventionextreport');
    if (-1 == navigator.userAgent.indexOf("MSIE")) {
	    iframeInterventions.src = s_iframeInterventions;
	    iframeInterventionlinktasksetting.src = s_iframeInterventionlinktasksetting;
	    iframeInterventionextreport.src = s_iframeInterventionextreport;
    } else {
	    iframeInterventions.location = s_iframeInterventions;
	    iframeInterventionlinktasksetting.location = s_iframeInterventionlinktasksetting;
	    iframeInterventionextreport.location = s_iframeInterventionextreport;	    
    }
}
// MWToken 改造
function getIframeUrl(url){
	if ('undefined'!==typeof websys_getMWToken){
		if(url.indexOf("?")==-1){
			url = url+"?MWToken="+websys_getMWToken()
		}else{
			url = url+"&MWToken="+websys_getMWToken()
		}
	}
	return url
}