/**
 * Tab 问题目标措施
 * nur.hisui.nursequestiongoalconfig.js
 * 
*/
//2758853【护理计划配置】业务界面整合
var PageLogicObj={
	iframeflag:'1',	
	iframeQuestiononMax:'0',  //问题iframe 是否在最大化状态
	Reloadiframe:{
		iframeQlRelate:0,
		iframeInterventions:0,
		iframeQuestionGoal:0,
	}
}
$(function () {
	//toopTip("#BSearch","查询");
	InitHospList();	
	//var layoutHeight = $("#quelayout").height();    	//Tab 页签下整个界面 高度 
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
	$("#NurseQuestionPanel").parent().css({
		height:layoutHeight-northHeight-10,
		width: '100%'				
    });	
	var valbox = $HUI.panel("#NurseQuestionPanel", {
		maximizable: true,
		onMaximize: function () {
			//var iframe = document.getElementById("NurseQuestionPanel");
			//requestFullScreen(iframe);
			//alert("你点击了最大化!");			
			$('#CenterDivChild').css("display", "none");
			var innerHeight = window.innerHeight;
			var innerWidth= window.innerWidth;
			$('#WestDivChild').css({
				height:innerHeight,
	        	width: innerWidth-15
	    	});
	    	$('#WestDivChild').panel('resize', {
		        height: '100%',
		        width: '100%'
		    });
		    toopTip(".panel-tool-max","left","还原"); //最大化/还原提示
						
		},
		onRestore:function(){
			//alert("你点击了还原!");	
			var innerHeight = window.innerHeight;						
			var layoutHeight = $("#quelayout").height();    	//Tab 页签下整个界面 高度 
		    var northHeight = $("#NorthDivParent").height();	//Tab 页签下【所属医院】Div 高度
		    var innerWidth = window.innerWidth; 
		    var CenterDivChildWidth = $('#CenterDivChild').width();
		    var CenterDivChildHeight = $('#CenterDivChild').height();
		    $('#CenterDivChild').css("display", "block");
		    $('#WestDivChild').parent().css({
				height:CenterDivChildHeight+10,
				width: innerWidth-CenterDivChildWidth-30,
				
		    });
		    $('#WestDivChild').css({
				height:CenterDivChildHeight+10,
				width: innerWidth-CenterDivChildWidth-30,
				padding:'0 10px 10px 10px'
		    });
	    	$('#WestDivChild').panel('resize', {
		        //height: CenterDivChildHeight,
		        height:'100%',
		        width: '100%',
		    });
		    
		    var NurseQuestionPanelHeight = $('#NurseQuestionPanel').parents().height()-$('#NurseQuestionPanel').parents().children()[0].clientHeight;
		    $('#NurseQuestionPanel').css({
			    //height:NurseQuestionPanelHeight-31,
				height:631,				
		    });
	   		iframeQuestion.window.$(".hisui-layout").layout("resize").layout('panel', 'center').panel('resize', {
		        height:507,		        
		    });
		    /*
		    $("#tabQuestionList").datagrid("resize",{		        
		    	height:'98%',
		        width: '98%',
		    });			
		    */
			toopTip(".panel-tool-max","bottom","最大化"); //最大化/还原提示			
		},
	});
	if('undefined'!=typeof cefbound) ReloadiframeonSelect(); //医为浏览器
	toopTip(".panel-tool-max","bottom","最大化");
	ResetDomSize();	
	setTimeout(setIframeSrc, 10);
});

window.addEventListener("resize", ResetDomSize);
function toopTip(idOrClass,position,showText){
    $(idOrClass).tooltip({
        position: position,
        content: '<span style="color:#6A6A6A">' + showText + '</span>',
        onShow: function(){
            $(this).tooltip('tip').css({
                backgroundColor: '#ffffff',
                borderColor: '#ff8c40'
            });
        }
    });
}
function ReloadiframeonSelect(){
	$('#config-accordion').accordion({
		onSelect: function (title) {
			if(title=="非评估相关因素配置"){
				if (PageLogicObj.Reloadiframe.iframeQlRelate=='0'){
					$("#iframeQlRelate")[0].contentWindow.location.reload(false);
					PageLogicObj.Reloadiframe.iframeQlRelate=1;
				}
				//iframeQlRelate.window.ReloadQLRelateFactorListDataGrid();
			}else if(title=="护理措施配置"){
				if (PageLogicObj.Reloadiframe.iframeInterventions=='0') {
					$("#iframeInterventions")[0].contentWindow.location.reload(false);
					PageLogicObj.Reloadiframe.iframeInterventions=1;
				}
				//iframeInterventions.window.ReloadQLInterventionListDataGrid();
			}else if(title=="护理目标配置"){
				if (PageLogicObj.Reloadiframe.iframeQuestionGoal=='0') {
					$("#iframeQuestionGoal")[0].contentWindow.location.reload(false);
					PageLogicObj.Reloadiframe.iframeQuestionGoal=1;
				}
				//iframeQuestionGoal.window.ReloadQuestionGoalListDataGrid();
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
				//问题界面	
				iframeQuestion.window.ReloadQuestionListDataGrid();			
				//非评估相关因素界面
				iframeQlRelate.window.ReloadQLRelateFactorListDataGrid();
				//护理目标配置界面
				iframeQuestionGoal.window.ReloadQuestionGoalListDataGrid();
				//护理措施配置界面
				iframeInterventions.window.ReloadQLInterventionListDataGrid();
				//相关因素配置界面
				iframeQlassess.window.ReloadQLAssessListDataGrid();
			}
		}
		hospComp.jdata.options.onLoadSuccess = function (data) {
			if (data) {
				 if(navigator.userAgent.indexOf('Trident') > -1){//IE 11
					setTimeout(function(){
						iframeQuestion.window.Init();
						iframeQlRelate.window.Init();
						iframeQuestionGoal.window.Init();
						iframeInterventions.window.Init();
						iframeQlassess.window.Init();
					},5);
				 }else{ //非IE 11
					iframeQuestion.window.onload = function(){
					    iframeQuestion.window.Init();					    
					}
					iframeQlRelate.window.onload = function(){
						iframeQlRelate.window.Init();						
					}
					iframeQuestionGoal.window.onload = function(){
						iframeQuestionGoal.window.Init();						
					}
					iframeInterventions.window.onload = function(){
						iframeInterventions.window.Init();						
					}
					iframeQlassess.window.onload = function(){
						iframeQlassess.window.Init();						
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
				//问题界面	
				iframeQuestion.window.ReloadQuestionListDataGrid();			
				//非评估相关因素界面
				iframeQlRelate.window.ReloadQLRelateFactorListDataGrid();
				//护理目标配置界面
				iframeQuestionGoal.window.ReloadQuestionGoalListDataGrid();
				//护理措施配置界面
				iframeInterventions.window.ReloadQLInterventionListDataGrid();
				//相关因素配置界面
				iframeQlassess.window.ReloadQLAssessListDataGrid();
				}
			},
			onLoadSuccess: function (data) {
				if (data) {
					iframeQuestion.window.onload = function(){
						iframeQuestion.window.Init();
						iframeQlRelate.window.Init();
						iframeQuestionGoal.window.Init();
						iframeInterventions.window.Init();
						iframeQlassess.window.Init();
					}				
				}
			}
		});
	}
}
function addiFrametoEditWindow(url){
	if(url=="nur.hisui.nursequestionType.csp"){
		var Height = window.innerHeight*0.618+30;
		var Width= window.innerWidth*0.618+30;
		$('#EditWindow').css({visibility:'visible'})
		$('#EditWindow').dialog({
			modal:true,
			content:addiFramecontent(url),
	        width:Width,
	        height:Height,
	        maximizable:false,
	        closable:true,
	        href:'',
	        title:'手动问题分类',
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

/**
 * 进入全屏
 * @param element
 */
 function requestFullScreen(element) {
	 var requestMethod = element.requestFullScreen || element.webkitRequestFullScreen || element.mozRequestFullScreen || element.msRequestFullScreen;
     if (requestMethod) {
	     requestMethod.call(element);
     } else if (typeof window.ActiveXObject !== "undefined") {
         var wscript = new ActiveXObject("WScript.Shell");
     	 if (wscript !== null) {
	     	 wscript.SendKeys("{F11}");
         }
     }
}
/**
 * 退出全屏
 */
function exitFullscreen() {
	if (document.exitFullscreen) {
		document.exitFullscreen();		
    } else if (document.msExitFullscreen) {
        document.msExitFullscreen();
    } else if (document.mozCancelFullScreen) {
        document.mozCancelFullScreen();
    } else if (document.webkitExitFullscreen) {
        document.webkitExitFullscreen();
    }
}
function ResetDomSize() {
	setTimeout(function () {
		//var layoutHeight = $("#quelayout").height();    	//Tab 页签下整个界面 高度 
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
		$("#NurseQuestionPanel").parent().css({
				height:layoutHeight-northHeight-10,	
	    });													//Tab 页签下中心Div下左侧Div的Panel高度	    
	    //$("#tabQuestionList").datagrid("load");
    },15);
}
function setIframeSrc() {
	/*
	var s_iframeQuestion ="nur.hisui.nursequestionsetting.csp";
    var s_iframeQlassess ="nur.hisui.qlassess.csp";
    var s_iframeQuestionGoal ="nur.hisui.nursequestiongoalsetting.csp";
    var s_iframeInterventions ="nur.hisui.qlintervention.csp";
    var s_iframeQlRelate ="nur.hisui.qlrelatefactor.csp";
    */
 	var s_iframeQuestion =getIframeUrl("nur.hisui.nursequestionsetting.csp");
 	if (ServerObj.TransPatStatusFlag=="1"){
    	var s_iframeQlassess =getIframeUrl("nur.hisui.qlassess.csp");
 	}else {
	 	var s_iframeQlassess =getIframeUrl("nur.hisui.qlassessOld.csp");
	}
    var s_iframeQuestionGoal =getIframeUrl("nur.hisui.nursequestiongoalsetting.csp");
    var s_iframeInterventions =getIframeUrl("nur.hisui.qlintervention.csp");
    var s_iframeQlRelate =getIframeUrl("nur.hisui.qlrelatefactor.csp");
       
    var iframeQuestion = document.getElementById('iframeQuestion');
    var iframeQlassess = document.getElementById('iframeQlassess');
    var iframeQuestionGoal = document.getElementById('iframeQuestionGoal');
    var iframeInterventions = document.getElementById('iframeInterventions');
    var iframeQlRelate = document.getElementById('iframeQlRelate');
    if (-1 == navigator.userAgent.indexOf("MSIE")) {
	    iframeQuestion.src = s_iframeQuestion;
	    iframeQlassess.src = s_iframeQlassess;
	    iframeQuestionGoal.src = s_iframeQuestionGoal;
	    iframeInterventions.src = s_iframeInterventions;
	    iframeQlRelate.src = s_iframeQlRelate;

    } else {
	   	iframeQuestion.location = s_iframeQuestion;
	    iframeQlassess.location = s_iframeQlassess;
	    iframeQuestionGoal.location = s_iframeQuestionGoal;
	    iframeInterventions.location = s_iframeInterventions;
	    iframeQlRelate.location = s_iframeQlRelate;
    }
}
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