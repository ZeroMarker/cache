//===========================================================================================
// 作者：      yangyongtao
// 编写日期:   2020-03-10
// 描述:	   随访本时间轴JS
//===========================================================================================

var CstID = "";     	/// 会诊ID
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LgParam=LgUserID+"^"+LgLocID+"^"+LgGroupID+"^"+LgHospID

/// 页面初始化函数
function initPageDefault(){
	
	InitPatEpisodeID();       /// 初始化加载病人就诊ID
}
/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	
	CstID =getParam("CstID");            /// 会诊ID
	InitTimeAxis(CstID)
}


///  时间轴
function InitTimeAxis(CstID){

	runClassMethod("web.DHCMDTFolUpVis","JsMcTimeAxis",{"CstID":CstID,"LgParam":""},function(jsonString){
		
		if (jsonString != null){
			InsTimeAxis(jsonString);
		}
	},'json',false)
}

///  时间轴
function InsTimeAxis(itemArr){
	
	var htmlstr = "";
	var McType=""
	for (var i=0; i<itemArr.length; i++){
    
		htmlstr = htmlstr + '<li id="'+ itemArr[i].McID +'">';
		htmlstr = htmlstr + '	<div class="circle"></div>';
		
		
		if(itemArr[i].McType=="F"){
			McType=$g("第")+itemArr[i].FTimes+$g("随访")
		}else{
		 	McType=$g("专家意见")
	    }
    	if(itemArr[i].Type=="Log"){
			htmlstr = htmlstr + '<div class="txt">'+ itemArr[i].StatusDesc +'<span style="margin-left:10px;">'+itemArr[i].McUser +'</span><span style="margin-left:10px;">'+ itemArr[i].McDate +'</span><span style="margin-left:10px;">'+ itemArr[i].McTime +'</span></div>';
		}else{
			htmlstr = htmlstr + '<div class="txt">'+ McType +'<span style="margin-left:10px;">'+itemArr[i].McUser +'</span><span style="margin-left:10px;">'+ itemArr[i].McDate +'</span><span style="margin-left:10px;">'+ itemArr[i].McTime +'</span></div>';
        }
        
        var McContent = itemArr[i].McContent
        McContent = McContent.replace(/\n/g,"<br>");
		
		if(itemArr[i].Status=="20"){
			htmlstr = htmlstr + '	<div  class="content">'+ $g("病情摘要")+"："+itemArr[i].CstTrePro +'<br/>'+$g("会诊目的")+"："+itemArr[i].CstPurpose+'</div>';
			//htmlstr = htmlstr + '	<div  class="trepro">'+ "会诊目的："+itemArr[i].CstPurpose +'</div>';
		}else if(itemArr[i].Status=="40"){
			htmlstr = htmlstr + '	<div id="content" class="content">'+ itemArr[i].DisProcess +'</div>';
		}else if(itemArr[i].Status=="80"){
			htmlstr = htmlstr + '	<div id="content" class="content">'+ $g("会诊讨论")+":"+itemArr[i].DisProcess+"<br/>"+$g("会诊意见")+":"+itemArr[i].TreMeasures +'</div>';
		}else{
			htmlstr = htmlstr + '	<div id="content" class="content">'+ McContent +'</div>';
		}
		htmlstr = htmlstr + '</li>';
		
	}
	$(".timeaxis ul").html(htmlstr);
	$(".timeaxis ul li").addClass("li_active");	
	
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })