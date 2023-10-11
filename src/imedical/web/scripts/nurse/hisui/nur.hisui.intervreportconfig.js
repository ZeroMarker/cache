/**
 * Tab��ʩ��������
 * nur.hisui.intervreportconfig.js
 * 
*/
//2758853������ƻ����á�ҵ���������
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
			if(title=="��������"){
				if (PageLogicObj.iframeInterventionextreport=='0'){
					$("#iframeInterventionextreport")[0].contentWindow.location.reload(false);
					PageLogicObj.iframeInterventionextreport=1;
				}
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
				//ѡ��ҽԺˢ�½���
				//�����ʩ���ý���
				iframeInterventions.window.ReloadInterventionsList();
				//�������ý���
				iframeInterventionlinktasksetting.window.ReloadInterventionLinkTaskList();
				//�������ý���
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
				 }else{ //��IE 11
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
		// MWToken ����
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
	    var northHeight = $("#NorthDivParent").height();	//Tab ҳǩ�¡�����ҽԺ��Div �߶� 
	    $(".hisui-layout").layout("resize").layout('panel', 'center').panel('resize', {
	        height: layoutHeight-northHeight,
	        width: '100%'
	    });													//Tab ҳǩ������Div �߶� 
	    $('#WestDivChild').css({
				height:layoutHeight-northHeight-10,
	    });
	    //var WestDivChildWidth=$('#WestDivChild').width();													//Tab ҳǩ������Div�����Div�߶�
		$("#NurseInterventionsPanel").parent().css({
				height:layoutHeight-northHeight-10,	
	    });													//Tab ҳǩ������Div�����Div��Panel�߶�	    

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
// MWToken ����
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