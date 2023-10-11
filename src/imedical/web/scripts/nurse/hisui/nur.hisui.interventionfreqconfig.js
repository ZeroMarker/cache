/**
 * Tab����Ƶ������
 * nur.hisui.interventionfreqconfig.js
 * 
*/
//2758853������ƻ����á�ҵ���������
var PageLogicObj={
	iframeflag:'1',	
	
}
$(function () {
	InitHospList();
	var valbox = $HUI.panel("#InterventionItemsettingPanel", {		
		maximizable: true,
		onMaximize: function () {
			//alert("���������!");
			$('#CenterDivChild').css("display", "none");
			var innerHeight = window.innerHeight;
			var innerWidth= window.innerWidth;
			$('#WestDivChild').css({
				height:innerHeight,
	        	width: innerWidth-20
	    	});
	    	$('#WestDivChild').panel('resize', {
		        height: '100%',
		        width: '100%'
		    });
			toopTip(".panel-tool-max","left","��ԭ"); //���/��ԭ��ʾ			
		},
		onRestore:function(){
			var innerHeight = window.innerHeight;
			//alert("��������С��!");
			$('#WestDivChild').css({
				height:innerHeight,
	        	width: 680
	    	});
	    	$('#WestDivChild').panel('resize', {
		        height: '100%',
		        width: '100%'
		    });
			$('#CenterDivChild').css("display", "block");
			toopTip(".panel-tool-max","bottom","���"); //���/��ԭ��ʾ		
		},
	});
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
//��ʼ��ҽԺ�б�
function InitHospList() {
	try {
		// ��Ժ��
		var sessionInfo = session["LOGON.USERID"] + '^' + session["LOGON.GROUPID"] + '^' + session["LOGON.CTLOCID"] + '^' + session["LOGON.HOSPID"];
		var hospComp = GenHospComp("Nur_IP_Question", sessionInfo);
		hospComp.jdata.options.onSelect = function (e, t) {
			if (t) {
				//ѡ��ҽԺˢ�½���
				//���������ý���
				iframeInterventionItemsetting.window.ReloadInterventionItemList();
				//����Ƶ������
				iframeInterventionFreq.window.ReloadInterventionFreqList();

			}
		}
		hospComp.jdata.options.onLoadSuccess = function (data) {
			if (data) {
				 if(navigator.userAgent.indexOf('Trident') > -1){//IE 11
					setTimeout(function(){
						iframeInterventionItemsetting.window.Init();
						iframeInterventionFreq.window.Init();

					},200);
				 }else{ //��IE 11
				 	try{
						iframeInterventionItemsetting.window.onload = function(){
						    iframeInterventionItemsetting.window.Init();
						}

						iframeInterventionFreq.window.onload = function(){
							iframeInterventionFreq.window.Init();
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
					iframeInterventionFreq.window.onload = function(){
						iframeInterventionItemsetting.window.Init();
						iframeInterventionFreq.window.Init();
					}				
				}
			}
		});
	}
}
function addiFrametoEditWindow(url,name,Width,Height){
	if(url){
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
		$("#InterventionItemsettingPanel").parent().css({
				height:layoutHeight-northHeight-10,	
	    });		
    },50);
}
function setIframeSrc() {
 	var s_iframeInterventionItemsetting =getIframeUrl("nur.hisui.interventionitemsetting.csp");
    var s_iframeInterventionFreq =getIframeUrl("nur.hisui.interventionfreqsetting.csp");
       
    var iframeInterventionItemsetting = document.getElementById('iframeInterventionItemsetting');
    var iframeInterventionFreq = document.getElementById('iframeInterventionFreq');
    if (-1 == navigator.userAgent.indexOf("MSIE")) {
	    iframeInterventionItemsetting.src = s_iframeInterventionItemsetting;
	    iframeInterventionFreq.src = s_iframeInterventionFreq;
    } else {
	    iframeInterventionItemsetting.location = s_iframeInterventionItemsetting;
	    iframeInterventionFreq.location = s_iframeInterventionFreq;
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