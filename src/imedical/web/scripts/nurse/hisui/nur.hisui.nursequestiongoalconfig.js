/**
 * Tab ����Ŀ���ʩ
 * nur.hisui.nursequestiongoalconfig.js
 * 
*/
//2758853������ƻ����á�ҵ���������
var PageLogicObj={
	iframeflag:'1',	
	iframeQuestiononMax:'0',  //����iframe �Ƿ������״̬
	Reloadiframe:{
		iframeQlRelate:0,
		iframeInterventions:0,
		iframeQuestionGoal:0,
	}
}
$(function () {
	//toopTip("#BSearch","��ѯ");
	InitHospList();	
	//var layoutHeight = $("#quelayout").height();    	//Tab ҳǩ���������� �߶� 
	var Height = $("#tabs",window.parent.document).height();	    
	var tabsheaderHeight = $("#tabs",window.parent.document).children(".tabs-header").height();
	var layoutHeight = Height-tabsheaderHeight; 	
    var northHeight = $("#NorthDivParent").height();	//Tab ҳǩ�¡�����ҽԺ��Div �߶� 
    $(".hisui-layout").layout("resize").layout('panel', 'center').panel('resize', {
        height: layoutHeight-northHeight,
        width: '100%'
    });													//Tab ҳǩ������Div �߶� 
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
			//alert("���������!");			
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
		    toopTip(".panel-tool-max","left","��ԭ"); //���/��ԭ��ʾ
						
		},
		onRestore:function(){
			//alert("�����˻�ԭ!");	
			var innerHeight = window.innerHeight;						
			var layoutHeight = $("#quelayout").height();    	//Tab ҳǩ���������� �߶� 
		    var northHeight = $("#NorthDivParent").height();	//Tab ҳǩ�¡�����ҽԺ��Div �߶�
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
			toopTip(".panel-tool-max","bottom","���"); //���/��ԭ��ʾ			
		},
	});
	if('undefined'!=typeof cefbound) ReloadiframeonSelect(); //ҽΪ�����
	toopTip(".panel-tool-max","bottom","���");
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
			if(title=="�����������������"){
				if (PageLogicObj.Reloadiframe.iframeQlRelate=='0'){
					$("#iframeQlRelate")[0].contentWindow.location.reload(false);
					PageLogicObj.Reloadiframe.iframeQlRelate=1;
				}
				//iframeQlRelate.window.ReloadQLRelateFactorListDataGrid();
			}else if(title=="�����ʩ����"){
				if (PageLogicObj.Reloadiframe.iframeInterventions=='0') {
					$("#iframeInterventions")[0].contentWindow.location.reload(false);
					PageLogicObj.Reloadiframe.iframeInterventions=1;
				}
				//iframeInterventions.window.ReloadQLInterventionListDataGrid();
			}else if(title=="����Ŀ������"){
				if (PageLogicObj.Reloadiframe.iframeQuestionGoal=='0') {
					$("#iframeQuestionGoal")[0].contentWindow.location.reload(false);
					PageLogicObj.Reloadiframe.iframeQuestionGoal=1;
				}
				//iframeQuestionGoal.window.ReloadQuestionGoalListDataGrid();
			}
		}
	});		
}

//��ʼ��ҽԺ�б�
function InitHospList() {
	try {
		// ��Ժ��
		var sessionInfo = session["LOGON.USERID"] + '^' + session["LOGON.GROUPID"] + '^' + session["LOGON.CTLOCID"] + '^' + session["LOGON.HOSPID"];
		var hospComp = GenHospComp("Nur_IP_Question", sessionInfo);
		hospComp.jdata.options.onSelect = function (e, t) {
			if (t) {				
				//�������	
				iframeQuestion.window.ReloadQuestionListDataGrid();			
				//������������ؽ���
				iframeQlRelate.window.ReloadQLRelateFactorListDataGrid();
				//����Ŀ�����ý���
				iframeQuestionGoal.window.ReloadQuestionGoalListDataGrid();
				//�����ʩ���ý���
				iframeInterventions.window.ReloadQLInterventionListDataGrid();
				//����������ý���
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
				 }else{ //��IE 11
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
		// ��������Ŀ���Ƕ�Ժ���ĳ���
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
				//�������	
				iframeQuestion.window.ReloadQuestionListDataGrid();			
				//������������ؽ���
				iframeQlRelate.window.ReloadQLRelateFactorListDataGrid();
				//����Ŀ�����ý���
				iframeQuestionGoal.window.ReloadQuestionGoalListDataGrid();
				//�����ʩ���ý���
				iframeInterventions.window.ReloadQLInterventionListDataGrid();
				//����������ý���
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
	        title:'�ֶ��������',
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
 * ����ȫ��
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
 * �˳�ȫ��
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
		//var layoutHeight = $("#quelayout").height();    	//Tab ҳǩ���������� �߶� 
	    var Height = $("#tabs",window.parent.document).height();	    
		var tabsheaderHeight = $("#tabs",window.parent.document).children(".tabs-header").height();
		var layoutHeight = Height-tabsheaderHeight; 	
	    var northHeight = $("#NorthDivParent").height();	//Tab ҳǩ�¡�����ҽԺ��Div �߶� 
	    $(".hisui-layout").layout("resize").layout('panel', 'center').panel('resize', {
	        height: layoutHeight-northHeight,
	        width: '100%'
	    });													//Tab ҳǩ������Div �߶� 
	    $('#WestDivChild').css({
				height:layoutHeight-northHeight-10,
	    });
	    //var WestDivChildWidth=$('#WestDivChild').width();													//Tab ҳǩ������Div�����Div�߶�
		$("#NurseQuestionPanel").parent().css({
				height:layoutHeight-northHeight-10,	
	    });													//Tab ҳǩ������Div�����Div��Panel�߶�	    
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