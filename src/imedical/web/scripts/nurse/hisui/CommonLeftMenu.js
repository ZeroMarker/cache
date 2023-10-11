/**
* @author songchunli
* HISUI �����߲˵������js
*/
var PageLogicObj={
	m_menuList:"", //���˵�json
    m_isShowPlayIcon:"", //�Ƿ���ʾ�����¼����
    m_selectedMenuID:"", //��ѡ���˵�id
    m_PatientListJson:"" //������Ϣjson
}
$(function(){
    // ��ʼ�����˵�
    InitLeftMenu();
    // ��ʼ�������б�(�����ʼ���Ҳ໼����Ϣ��)
    InitPatientList();
    InitEvent();
});
function InitEvent(){
    $(".prev").click(prev);
    $(".next").click(next);
    $(".dropDown").click(dropDown);
    $("#menuSearchBox").keydown(function(e){
		var key=websys_getKey(e);
		if (key==13){
			menuSearch();
            return false;
		}
	});
    $("#menuSearchBoxBtn").click(menuSearch);
}
$(window).load(function() {
	$("#loading").hide();
})
function InitLeftMenu(){
    var selMenuId="";
    $.cm({
		ClassName:"Nur.NIS.Service.Base.Menu",
		MethodName:"GetPatientLeftMenuList",
		groupId:session['LOGON.GROUPID']
	},function(menuList){
        PageLogicObj.m_menuList=menuList;
        var html=[];
        for (var i=0;i<menuList.length;i++){
            var checked=menuList[i].checked;
            if (checked) {
	            var name=menuList[i].attributes.Name;
	            if ((ServerObj.leftMenuCode!="")&&(ServerObj.leftMenuCode==name)) {
		            selMenuId=menuList[i].id;
		        }
                html.push('<li class="menuitem">');
                    html.push('<div id="'+menuList[i].id+'" class="menu-title">');
                    html.push('<span class="text">'+$g(menuList[i].text)+'</span>');
                if (menuList[i].text ==$g("����ƻ�")){
                    html.push('<label class="planicon" style="vertical-align:middle;"><img src="../images/uiimages/alert_red.png" title=$g("�г��ڵĻ���ƻ����뼰ʱ����") style="margin-left: 5px;margin-top:-2px;width:14px;height:14px;"></label>');
                }
                var children=menuList[i].children;
                if (children) {
                    html.push('<i class="icon u-arrow-down"></i>');
                    html.push('</div>');
                    html.push('<ul class="submenu">');
                    var firstId = ""
                    for (var j=0;j<children.length;j++){
                        if (children[j].checked){
	                        if (firstId == "")
	                        {
		                    	firstId = children[j].id
		                    }
                            html.push('<li id="'+children[j].id+'">'+$g(children[j].text)+'</li>');
                            var name=children[j].attributes.Name;
                            if ((ServerObj.leftMenuCode!="")&&(ServerObj.leftMenuCode==name)) {
					            selMenuId=children[j].id;
					        }
                        }
                    }
                    html.push('</ul>');
                    
                    // ��λͼ��ת��Ĭ�ϵ�һ������Ȩ�Ĳ˵� 2021.9.6
                    //if (!selMenuId) selMenuId=children[0].id;
                    if (!selMenuId){
	                	var tmpfirstId = children[0].id;
	                	if (firstId != ""){
		                	tmpfirstId = firstId
		                }
		                selMenuId = tmpfirstId
	                }
                }else{
                    html.push('</div>');
                }
                html.push('</li>');
                if (!selMenuId) selMenuId=menuList[i].id;
            }
        }
        $(".menuList").append(html.join(""));
        ChangePlayIconStatus();
        $(".menu-title").click(menuTitleClick);
        $(".submenu li").click(subMenuClick);
        if (selMenuId) {
	        $("#"+selMenuId).trigger("click");
	    }
    })
}
function InitPatIfoBar(EpisodeID){
	
	$.cm({
		ClassName:"Nur.NIS.Service.Base.Patient",
		MethodName:"GetPatient",
		EpisodeID:EpisodeID
	},function(PatInfo){
        $(".rightWrap .panel-header").empty();
		var sex=PatInfo.sex;
		if (sex ==$g("Ů")) {
			$(".rightWrap .panel-header").append('<img src="../images/uiimages/bed/fmaleAvatar.png" alt="" class="patSexIcon">');
		}else if(sex==$g("��")){
			$(".rightWrap .panel-header").append('<img src="../images/uiimages/bed/maleAvatar.png" alt="" class="patSexIcon">');
		}else{
			$(".rightWrap .panel-header").append('<img src="../images/uiimages/bed/unKnownAvatar.png" alt="" class="patSexIcon">');
		}
        $(".rightWrap .panel-header").append('<div class="patInfoBanner_patInfoText"></div>');
		var _$patInfo=$(".patInfoBanner_patInfoText");
        _$patInfo.append("<span class='patInfoBanner_patInfoText--otherInfo'>"+PatInfo.bedCode+"</span>");
		_$patInfo.append("<span class='patInfoBanner_sep'>/</span>");
		_$patInfo.append("<span class='patInfoBanner_patInfoText--otherInfo'>"+PatInfo.name+"</span>");
		_$patInfo.append("<span class='patInfoBanner_sep'>/</span>");
		_$patInfo.append("<span class='patInfoBanner_patInfoText--otherInfo'>"+PatInfo.age+"</span>");
		_$patInfo.append("<span class='patInfoBanner_sep'>/</span>");
		_$patInfo.append("<span class='patInfoBanner_patInfoText--otherInfo'>"+PatInfo.regNo+"</span>");
		_$patInfo.append("<span class='patInfoBanner_sep'>/</span>");
		_$patInfo.append("<span class='patInfoBanner_patInfoText--otherInfo'>"+PatInfo.admReason+"</span>");
		_$patInfo.append("<span class='patInfoBanner_sep'>/</span>");
		_$patInfo.append("<span class='patInfoBanner_patInfoText--otherInfo'>"+PatInfo.ctLocDesc+"</span>");
		_$patInfo.append("<span class='patInfoBanner_sep'>/</span>");
		_$patInfo.append("<span class='patInfoBanner_patInfoText--otherInfo'>"+PatInfo.wardDesc+"</span>");
		$.cm({
			ClassName:"Nur.NIS.Service.Base.Patient",
			MethodName:"GetChunkIcons",
			episodeIDString:EpisodeID
		},function(icons){
			icons=icons[0];
			_$patInfo.append("<span class='patInfoBanner_sep'>/</span>");
			var appendHtml="<span class='patInfoBanner_patInfoText--otherInfo'>"
			_$patInfo.append("<span class='patInfoBanner_patInfoText--otherInfo'>");
			for (var i=0;i<icons.length;i++){
				var src=icons[i].src;
				if (!src) continue;
				var title=icons[i].title;

				appendHtml+='<a href="#"><img src="../images/'+src+'" alt="'+title+'" title="'+title+'" class="patInfoBanner_patInfoIcon--icon"></a>';
			}
			appendHtml+="</span>";
			_$patInfo.append(appendHtml);
		})
	})
}
var patientListPage="";
// ���ػ�����Ϣ������
function setPatientBarInfo() {
	InitPatInfoBanner(ServerObj.EpisodeID);
	/*var html=$m({
		ClassName: "web.DHCDoc.OP.AjaxInterface",
		MethodName: "GetOPInfoBar",
		CONTEXT: "",
		EpisodeID: ServerObj.EpisodeID
	},false);
	if (html != "") {
		$(".patientbar").data("patinfo",html);
		if ("function"==typeof InitPatInfoHover) {InitPatInfoHover();}
		else{$(".PatInfoItem").html(reservedToHtml(html))}
		$(".PatInfoItem").find("img").eq(0).css("top",0);
	} else {
		$(".PatInfoItem").html("��ȡ������Ϣʧ�ܡ����顾������Ϣչʾ�����á�");
	}*/
}
function reservedToHtml(str) {
	var replacements = {
		"&lt;": "<",
		"&#60;": "<",
		"&gt;": ">",
		"&#62;": ">",
		"&quot;": "\"",
		"&#34;": "\"",
		"&apos;": "'",
		"&#39;": "'",
		"&amp;": "&",
		"&#38;": "&"
	};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g, function(v) {
		return replacements[v];
	});
}
function menuTitleClick(e){
    var id=e.currentTarget.id;
    if ($("#"+id).nextAll("ul").length){
        if (!$("#"+id).parent().hasClass("expand")){
            $("#"+id).parent().addClass("expand");
            $("#"+id +" .icon").removeClass("u-arrow-down").addClass("u-arrow-top");
        }else{
            $("#"+id).parent().removeClass("expand");
            $("#"+id +" .icon").removeClass("u-arrow-top").addClass("u-arrow-down");
        }
    }else{
        $("#"+id).parent().addClass("expand");
        $("#"+id).addClass("menu-title");
        getPageName(id);
    }
}
function getPageName(id){
    PageLogicObj.m_selectedMenuID=id;
    $.cm({
        ClassName:"Nur.NIS.Service.Base.Menu",
        MethodName:"GetValueExpressionByID",
        menuID:id
    },function(result){
        var link=result.link+"&EpisodeID="+ServerObj.EpisodeID;
        if ("undefined"!==typeof websys_getMWToken){
			link += "&MWToken="+websys_getMWToken()
		}
        $('.rightWrap iframe').attr('src',link);
    })
}
function subMenuClick(e){
	var id=e.currentTarget.id;
    if (!$("#"+id).parents("li").hasClass("expand")){
        $("#"+id).parents("li").addClass("expand");
        $("#"+id).parent().prev().children(".icon").removeClass("u-arrow-down").addClass("u-arrow-top");
    }
    $(".active").removeClass("active");
    var id=e.currentTarget.id;
    $("#"+id).addClass("active");
    getPageName(id);
}
function IsOutPlayDays(){
    var isShowPlayIcon=$.cm({
        ClassName:"Nur.NIS.Service.NursingPlan.QuestionRecord",
        MethodName:"IsOutPlayDays",
        episodeID:ServerObj.EpisodeID
    },false)
    return isShowPlayIcon;
}
// ��һ������
function prev(){
    var selPatIndex=$.hisui.indexOfArray(PageLogicObj.m_PatientListJson,"episodeID",ServerObj.EpisodeID);
    SetPatientInfo(selPatIndex-1);
    ChangePatInfoArrowStatus(selPatIndex-1);
    getPageName(PageLogicObj.m_selectedMenuID);
}
//��һ������
function next(){
    var selPatIndex=$.hisui.indexOfArray(PageLogicObj.m_PatientListJson,"episodeID",ServerObj.EpisodeID);
    SetPatientInfo(selPatIndex+1);
    ChangePatInfoArrowStatus(selPatIndex+1);
    getPageName(PageLogicObj.m_selectedMenuID);
}
// չʾ����������
function dropDown(){
    if($('.patientList').css('display') === 'none'){
        $(".menu-area").hide();
        $(".patientList").show();
    }else{
        $(".menu-area").show();
        $(".patientList").hide();
    }
}
//��ʼ�������б�
function InitPatientList(){
    $.cm({
        ClassName:"Nur.NIS.Service.Base.Ward",
        MethodName:"GetBeds", //GetWardPatients
        /*wardID:session['LOGON.WARDID'],
        adm:"", 
        groupSort:false,
        babyFlag:"",
        groupID:session['LOGON.GROUPID'],
        userID:session['LOGON.USERID']*/
        WardID:session['LOGON.WARDID'],
        locID:session['LOGON.CTLOCID'],
        groupID:session['LOGON.GROUPID'],
        userID:session['LOGON.USERID'],
        deliveryRoomFlag:ServerObj.deliveryRoomFlag
    },function(JsonData){
        var PatListArr=[];
        /*if (JsonData.length > 0) {
		  JsonData.forEach(function(item){
			  if (item.label == "��λ") {
				  item.children.forEach(function(patItem){
					  if ((patItem.children)&&(patItem.children.length > 0)){ //&&(PatListArr.isArray(patItem.children))
					  	  var copyArr = $.extend(true, [], patItem);
					  	  delete copyArr.children;
					  	  PatListArr.push(copyArr);
					  	  patItem.children.forEach(function(patItemchild){
						  	  PatListArr.push(patItemchild);
						  })
					  }else{
						  PatListArr.push(patItem);
					  }
				  })
			  }else{
				  item.children.forEach(function(child){
					  child.remark = item.label;
					  PatListArr.push(child);
				  })
			  }
		  })
        }*/
        if (JsonData.length > 0) {
	        JsonData.forEach(function(item){
		        if ((item.patient)&&(!$.isEmptyObject(item.patient))) PatListArr.push(item.patient);
		    })
	    }
        PageLogicObj.m_PatientListJson=PatListArr;
        var selPatIndex=$.hisui.indexOfArray(PageLogicObj.m_PatientListJson,"episodeID",ServerObj.EpisodeID);
        if (selPatIndex<0){
	        PatListArr.push($.cm({
		        ClassName:"Nur.NIS.Service.Base.PatientInfo",
		        MethodName:"GetPatientByItem", 
		        EpisodeID:ServerObj.EpisodeID,
		        area:"bedChart"
		    },false))
        }
	    var selPatIndex=$.hisui.indexOfArray(PageLogicObj.m_PatientListJson,"episodeID",ServerObj.EpisodeID);
	    ChangePatInfoArrowStatus(selPatIndex);
	    SetPatientInfo(selPatIndex);
        InitPatientListCombo();
    })
}
//�ı����Ͻǻ�����Ϣͼ����ʾ
function ChangePatInfoArrowStatus(selPatIndex){
    $(".prev,.next").css("visibility","visible");
    if (selPatIndex ==0) {
        $(".prev").css("visibility","hidden");
    }else if(selPatIndex ==(PageLogicObj.m_PatientListJson.length-1)){
        $(".next").css("visibility","hidden");
    }
}
//����ѡ�л��ߵ���Ϣ
function SetPatientInfo(selPatIndex){
    var selPatientInfo=PageLogicObj.m_PatientListJson[selPatIndex];
    var bedCode=selPatientInfo.bedCode;
    if (bedCode.indexOf($g("��"))<0) {
        bedCode=bedCode+$g("��");
    }
    var name=selPatientInfo.name;
    $("#patName").html(name);
    $("#patBed").html(bedCode);
    $(".patientInfo").css("background-color",selPatientInfo.careLevelColor?selPatientInfo.careLevelColor:"#999");
    $.extend(ServerObj,{EpisodeID:selPatientInfo.episodeID});
    //�޸Ŀ�ܾ���
    var frm = dhcsys_getmenuform();
	if ((frm)&&(frm.EpisodeID.value!=selPatientInfo.episodeID)) {
		frm.EpisodeID.value = selPatientInfo.episodeID;
		frm.PatientID.value = selPatientInfo.patientID;
		frm.canGiveBirth.value = selPatientInfo.sex === $g("Ů") &&
        selPatientInfo.ifNewBaby !== "Y"
          ? "1"
          : "0";
	}
    //InitPatIfoBar(ServerObj.EpisodeID);
    setPatientBarInfo();
    ChangePlayIconStatus();
    $(".patientList .active").removeClass("active");
    $("#episodeId_"+ServerObj.EpisodeID).addClass("active"); 
    var Url=window.location.href;
    var NewUrl=rewriteUrl(Url, {EpisodeID:selPatientInfo.episodeID});
    history.pushState("", "", NewUrl);
}
function InitPatientListCombo(){
    var html=[];
    for (var i=0;i<PageLogicObj.m_PatientListJson.length;i++){
	    if (PageLogicObj.m_PatientListJson[i].remark) continue;
        var episodeID=PageLogicObj.m_PatientListJson[i].episodeID;
        var name=PageLogicObj.m_PatientListJson[i].name;
        var bedCode=PageLogicObj.m_PatientListJson[i].bedCode;
        var medicareNo=PageLogicObj.m_PatientListJson[i].medicareNo;
        var liclass=(episodeID == ServerObj.EpisodeID)?"active":"";
        html.push('<li class="'+liclass+'" id="episodeId_'+episodeID+'">');
            html.push('<div class="name">');
                html.push('<p class="patientName">'+name+'</p>');
                html.push('<p class="patientId">'+medicareNo?medicareNo:""+'</p>');
            html.push('</div>');

            html.push('<div class="bedNo">');
                html.push('<p style="font-size:18px;font-weight:bolder;">'+bedCode+'</p>');
                html.push('<p>'+$g("��")+'</p>');
            html.push('</div>');
        html.push('</div>');
        html.push('</li>');
    }
    $(".patientList").append(html.join(""));
    $(".patientList li").click(function(e){
        var id=e.currentTarget.id;
        var selEpisodeID=id.split("_")[1];
        var selPatIndex=$.hisui.indexOfArray(PageLogicObj.m_PatientListJson,"episodeID",selEpisodeID);
        ChangePatInfoArrowStatus(selPatIndex);
        SetPatientInfo(selPatIndex);
        getPageName(PageLogicObj.m_selectedMenuID);
        $(".menu-area").show();
        $(".patientList").hide();
    });
}
//�˵�����
function menuSearch(){
    var keyword=$("#menuSearchBox").val();
    for (var i=0;i<PageLogicObj.m_menuList.length;i++){
        var id=PageLogicObj.m_menuList[i].id;
        var text=PageLogicObj.m_menuList[i].text
        var checked=PageLogicObj.m_menuList[i].checked;
        if (checked) {
            var children=PageLogicObj.m_menuList[i].children;
            if (children) {
                var findSubItem=0;
                for (var j=0;j<children.length;j++){
                    if (children[j].checked){
                        if (children[j].text.indexOf(keyword)>=0) {
                            findSubItem=1;
                            $("#"+children[j].id).show();
                        }else{
                            $("#"+children[j].id).hide();
                        }
                    }
                }
                if (keyword) {
                    if (findSubItem) {
                        $("#"+id).show().trigger("click");
                    }else{
                        $("#"+id).hide();
                    }
                }else{
                    $("#"+id).show();
                }
            }else{
                if (keyword) {
                    if (text.indexOf(keyword)>=0) {
                        $("#"+id).show();
                    }else{
                        $("#"+id).hide();
                    }
                }else{
                    $("#"+id).show();
                }
            }
        }
    }
}
function ChangePlayIconStatus(){
	PageLogicObj.m_isShowPlayIcon=IsOutPlayDays();
	if (PageLogicObj.m_isShowPlayIcon ==1){
        $(".planicon").show();
    }else{
        $(".planicon").hide();
    }
}
