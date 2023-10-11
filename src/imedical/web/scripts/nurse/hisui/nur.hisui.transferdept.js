var ifHasTransOrd="",transOrdRecLocRowId="",ifHasNeedCareOrder="",isTransNeedCareFlag="",isTransOrderFlag="",ifClickTrans=true;
var lastTransOrigLocId="",lastTransOrigWardId="";
var curWardID="",curLocID="";
var babyIfCanOper=0,babyIfOtherCanOper=0,babyAlertMsgArr=[];
$(function(){
	$("#username").val(session['LOGON.USERCODE']);
	$("#ward").combobox({"disabled":true});
	$("#transfer-btn").hide();
	getLastTransOrigLocWard();
	getTransOrdInfo();
	getDeptList();
})
function getLastTransOrigLocWard(){
	var data=$.cm({
		ClassName:"Nur.NIS.Service.Base.Transfer",
		MethodName:"getLastTransOrigLocWard",
		episodId:episodeID
	},false)
	lastTransOrigLocId = data.origLocId;
    lastTransOrigWardId = data.origWardId;
    curWardID = data.curWardID;
    curLocID = data.curLocID;
}
function getDeptList(){
	$HUI.combobox("#dept",{
		url:$URL+"?ClassName=Nur.NIS.Service.Base.Loc&QueryName=GetLocsExceptAdmLoc&locDesc=",
		mode:'remote',
		selectOnNavigation:true,
		valueField:'ID',
		textField:'desc',	
		onBeforeLoad:function(param){   
			var desc=""
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{locDesc:desc,locType:"E",episodeID:episodeID});
		},
		loadFilter:function(data){			
			return data.rows;
		},
		onLoadSuccess:function(data){ 
			if (data.length === 0) {
              	//$.messager.popover({msg:"无关联科室！",type: 'info'});
            } else if (transOrdRecLocRowId != "") {
              	data.forEach(function(item,index){
                	if (item.ID == transOrdRecLocRowId) {      
                  		var limitFlag = item.ageSexLimitFlag;
                  		if (limitFlag == "N") {
                    		$("#dept").combobox("setValue",item.ID);                    		
                  		}
                	}
              	});
            }
		},
		onChange:function(record){
			
		},
		onHidePanel:function(){
			var locId=$(this).combobox("getValue");
			var selLocID="";
			var data=$(this).combobox("getData");
			data.forEach(function(item,index){
            	if (item.ID == locId) {
              		var limitFlag = item.ageSexLimitFlag;
              		if (limitFlag == "Y") {
	              		$.messager.popover({msg:"所选择的科室有性别/年龄限制！",type: 'alert'});
        				$("#transfer-btn").hide();
              		}/*else{
	              		getNeedCareOrder(item.ID);
	              	}*/
	              	selLocID=item.ID;
            	}
          	});
			runClassMethod("Nur.NIS.Service.Base.Loc","GetTransLocLinkWards",{"locID":selLocID},function(data){
				$("#ward").combobox({
					disabled:false,
					valueField:'wardID',
					textField:'wardDesc',
					data:data,
					onSelect: function (rec) {
						if ((rec)&&(rec.wardID)){
							getNeedCareOrder(rec.ifMaternalBabyWard);
						}
					},
					filter: function(q, row){
						return (row["wardDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["searchCode"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
					}
				});
				if(data.length==1) $("#ward").combobox("select",data[0].wardID);
			},'json',false)
		}
	})
}

function getTransOrdInfo(){
	runClassMethod("Nur.NIS.Service.Base.Patient","IfHasTransOrd",{"episodeID":episodeID,"locID":"","wardID":""},function(data){
		ifHasTransOrd=data.abnormalMsg;
		transOrdRecLocRowId=data.transOrdRecLocRowId;
	},'json',false)	
}

function getNeedCareOrder(ifMaternalBabyWard){
	var locID=$("#dept").combobox("getValue");
	var wardID=$("#ward").combobox("getValue");	
	var data=$.cm({
		ClassName:"Nur.NIS.Service.Base.Transfer",
		MethodName:"IfHasNotControlLoc",
		locID:locID,
		wardID:wardID,
		transFromlocID:curLocID,
		transFromWardID:curWardID
	},false)
	isTransNeedCareFlag = data.isTransNeedCareFlag;
    isTransOrderFlag = data.isTransOrderFlag;
    //回转不控制需关注
    if ((locID==lastTransOrigLocId)&&(wardID==lastTransOrigWardId)){
	    var data=$.cm({
			ClassName:"Nur.NIS.Service.Base.Transfer",
			MethodName:"IfHasNotControlLoc",
			locID:curLocID,
			wardID:curWardID,
			transFromlocID:curLocID,
			transFromWardID:curWardID
		},false)
	    var transBackNeedCareFlag=data.transBackNeedCareFlag;
	    if (transBackNeedCareFlag=="Y") isTransNeedCareFlag="Y"
	}
	runClassMethod("Nur.NIS.Service.Base.Transfer","getAbnormalOrder",{"episodeID":episodeID,"abnormalType":"Trans"},function(data){
		ifHasNeedCareOrder=data;
	},'json',false)
	var warningColor=HISUIStyleCode=="lite"?"color:#339eff;":"color:#40A2DE;";
	var ifCanOper=0,ifOtherCanOper=0,MsgArr=[];
	if (ifHasTransOrd!=0 && ifHasTransOrd!=""){
		var style=isTransOrderFlag !="Y"?"color:red;":warningColor;
		MsgArr.push("<span style='"+style+"'>"+ifHasTransOrd+"</span>");
	}
	var retArr=ifHasNeedCareOrder;
	if (retArr.length>0){
		var ifCanOper=retArr[0].ifCanOper;
	    var ifOtherCanOper=retArr[0].ifOtherCanOper;
	    var abnormalMsgArr=retArr[0].abnormalMsgs;
	    var otherAbnormalMsgs=retArr[0].otherAbnormalMsgs;
		var alertMsgArr=[];		
		for (var i=0;i<abnormalMsgArr.length;i++){
			var style=abnormalMsgArr[i].ifCanOper ==1?"color:red;":warningColor;
			alertMsgArr.push("<span style='"+style+"'>"+abnormalMsgArr[i].abnormalMsg+"</span>");
		}
		var otherAlertMsgArr=[];
		for (var i=0;i<otherAbnormalMsgs.length;i++){
			var linkUrl=otherAbnormalMsgs[i].linkUrl;
			var style=otherAbnormalMsgs[i].ifCanOper ==1?"color:red;":warningColor;
			if (linkUrl){
				style+="text-decoration:underline;";
				otherAlertMsgArr.push("<a href='#' style='"+style+"' onclick=openOtherAbnormalMsgLink('"+EpisodeID+"','"+linkUrl+"','"+otherAbnormalMsgs[i].abnormalMsg+"')>"+otherAbnormalMsgs[i].abnormalMsg+"</a>");
			}else{
				otherAlertMsgArr.push("<span style='"+style+"'>"+otherAbnormalMsgs[i].abnormalMsg+"</span>");
			}
		}
		var otherAlertMsg=otherAlertMsgArr.join(" ");
		var alertMsg=alertMsgArr.join(" ");
		if (alertMsg!=""){
			if(ifCanOper=="0"){
				MsgArr.push("患者存在"+alertMsg + " " +otherAlertMsg+"是否立即处理?");
			}else{
				MsgArr.push("患者存在"+alertMsg + " " +otherAlertMsg+"不能转科,请先处理!");
			}
		}else if(otherAlertMsg!=""){
			if(ifOtherCanOper=="0"){
				MsgArr.push("患者存在"+otherAlertMsg);
			}else{
				MsgArr.push("患者存在"+otherAlertMsg+"不能转科,请先处理!");
			}
		}
	}
	babyIfCanOper=0,babyIfOtherCanOper=0,babyAlertMsgArr=[];
	if (ifMaternalBabyWard=="true"){
		var retArr=$.cm({
			ClassName:"Nur.NIS.Service.Base.Transfer",
			MethodName:"getBabyAbnormalOrderByMother",
			motherEpisodeID:episodeID,
			CtcpType:"NURSE",
			AbnormalType:"T"
		},false)
		if (retArr.length>0){
			babyAlertMsgArr.push("患者婴儿");
			for (var babyIndex=0;babyIndex<retArr.length;babyIndex++){
				var oneBabyIfCanOper=retArr[babyIndex].ifCanOper;
			    var oneBabyIfOtherCanOper=retArr[babyIndex].ifOtherCanOper;
			    var oneBabyAbnormalMsgArr=retArr[babyIndex].abnormalMsgs;
			    var oneBabyOtherAbnormalMsgs=retArr[babyIndex].otherAbnormalMsgs;
			    var babyName=retArr[babyIndex].babyName;
			    var babyAdmId=retArr[babyIndex].babyAdmId;
			    if (oneBabyIfCanOper==1) babyIfCanOper=oneBabyIfCanOper;
			    if (oneBabyIfOtherCanOper==1) babyIfOtherCanOper=oneBabyIfOtherCanOper;
				var oneBabyAlertMsgArr=[];
				for (var i=0;i<oneBabyAbnormalMsgArr.length;i++){
					var style=oneBabyAbnormalMsgArr[i].ifCanOper ==1?"color:red;":warningColor;
					oneBabyAlertMsgArr.push("<span style='"+style+"'>"+oneBabyAbnormalMsgArr[i].abnormalMsg+"</span>");
				}
				var oneBabyOtherAlertMsgArr=[];
				for (var i=0;i<oneBabyOtherAbnormalMsgs.length;i++){
					var style=oneBabyOtherAbnormalMsgs[i].ifCanOper ==1?"color:red;":warningColor;
					if (linkUrl){
						style+="text-decoration:underline;";
						oneBabyOtherAlertMsgArr.push("<a href='#' style='"+style+"' onclick=openOtherAbnormalMsgLink('"+babyAdmId+"','"+linkUrl+"','"+oneBabyOtherAbnormalMsgs[i].abnormalMsg+"')>"+oneBabyOtherAbnormalMsgs[i].abnormalMsg+"</a>");
					}else{
						oneBabyOtherAlertMsgArr.push("<span style='"+style+"'>"+oneBabyOtherAbnormalMsgs[i].abnormalMsg+"</span>");
					}
				}
				var oneBabyOtherAlertMsg=oneBabyOtherAlertMsgArr.join(" ");
				var oneBabyAlertMsg=oneBabyAlertMsgArr.join(" ");
				if (oneBabyAlertMsg!=""){
					babyAlertMsgArr.push("<a href='#' class='babyNameLink' onclick='openBabyOrderNeedCare("+babyAdmId+")'>"+babyName+"</a>"+" 存在 "+oneBabyAlertMsg + " " +oneBabyOtherAlertMsg+";");
				}else{
					babyAlertMsgArr.push(+babyName+" 存在 "+oneBabyAlertMsg + " " +oneBabyOtherAlertMsg+";");
				}
			}
			if ((babyIfCanOper==1)||(babyIfOtherCanOper==1)) babyAlertMsgArr.push("不能转科,请点击婴儿名称处理!");
			if (babyIfCanOper==1) ifCanOper=1;
			if (babyIfOtherCanOper==1) ifOtherCanOper=1;
		}
	}
	if (babyAlertMsgArr.length) MsgArr.push(babyAlertMsgArr.join("<br/>"));
	$("#nowtrans-btn,#nowdeal-btn,#close-btn").hide();
	if (ifHasTransOrd == "0" && MsgArr.length == 0) {
		$("#transfer-btn").show();
	}else{
		if (isTransOrderFlag != "Y" && ifHasTransOrd != "0") {
			$("#transfer-btn").hide();
          	$("#nowtrans-btn").hide();
		}
		if (isTransNeedCareFlag==="Y" && MsgArr.length>0 && (ifCanOper==1 || ifOtherCanOper==1) && (isTransOrderFlag === "Y" || ifHasTransOrd==0)){
			//存在有必须处理的需关注且转科不需控制需关注或必须开立转科医嘱且转科控制不需转科医嘱,显示立即处理按钮
			$("#nowtrans-btn").show();
		}else if(ifHasTransOrd != 0 || (MsgArr.length>0 && ifCanOper==0)){
			$("#close-btn").show(); 
		}
		//母亲存在需关注则显示"立即处理"按钮
		if(ifHasNeedCareOrder.length > 0 && ifHasNeedCareOrder[0].abnormalMsgs.length > 0){
	    	$("#nowdeal-btn").show();    
	    }
	}
	if (MsgArr.length) {
		$("#transfer-info .contents").html(MsgArr.join("<br/>"));
        $("#transfer-info").dialog("open");
	}
	/*$("#nowtrans-btn,#nowdeal-btn,#close-btn,#transfer-btn").hide();
	if (ifHasTransOrd == "0" && ifHasNeedCareOrder.length == 0) {
        $("#transfer-btn").show();
    } else {
        if (isTransOrderFlag != "Y" && ifHasTransOrd != "0") {
          	$("#transfer-btn").hide();
          	$("#nowtrans-btn").hide();
        }
        if (isTransNeedCareFlag === "Y" && ifHasNeedCareOrder.length > 0 &&
          (String(ifHasNeedCareOrder[0].ifCanOper) === "1" ||
            String(ifHasNeedCareOrder[0].ifOtherCanOper) === "1") &&
          (isTransOrderFlag === "Y" || String(ifHasTransOrd) === "0")
        ) {
          	$("#nowtrans-btn").show();
        }else if(ifHasTransOrd != '0' || (ifHasNeedCareOrder.length > 0 && String(ifHasNeedCareOrder[0].ifCanOper) === '0')){
	    	$("#close-btn").show();    
	    }
        if(ifHasNeedCareOrder.length > 0 && ifHasNeedCareOrder[0].abnormalMsgs.length > 0){
	    	$("#nowdeal-btn").show();    
	    }
        
        var infos="";
        if(ifHasTransOrd!="")
        {
	        var className=isTransOrderFlag!="Y" ? 'controlMsg' : 'alertMsg'
	    	infos+='<p style="margin-bottom:10px;" class="'+className+'">'+ifHasTransOrd+'</p>';   
	    }
	    if(ifHasNeedCareOrder.length > 0 && String(ifHasNeedCareOrder[0].ifCanOper) === '1'){
			infos+='<p style="margin-bottom:10px;"><span>'+ifHasNeedCareOrder[0].prefixMsg+'</span>'  
			var msgs=ifHasNeedCareOrder[0].abnormalMsgs;
			if(msgs.length>0){
				msgs.forEach(function(item,index){
					var className=item.ifCanOper == 1 ? 'controlMsg' : 'alertMsg';
					infos+='<span style="padding-right:5px;" class="'+className+'">'+item.abnormalMsg+'</span>';
				})	
			}
			infos+='<span>'+ifHasNeedCareOrder[0].suffixMsg+'</span>'
			if(isTransNeedCareFlag === 'Y'){
				infos+='<span>是否现在进行处理？</span>'	
			}else{
				infos+='<span>需处理后才能进行转科操作！</span>'
			}
			infos+='</p>'  
		}
		if(ifHasNeedCareOrder.length > 0 && ifHasNeedCareOrder[0].abnormalMsgs.length > 0 && String(ifHasNeedCareOrder[0].ifCanOper) === '0'){
			infos+='<p style="margin-bottom:10px;">'+ifHasNeedCareOrder[0].prefixMsg;
			var msgs=ifHasNeedCareOrder[0].abnormalMsgs;
			if(msgs.length>0){
				msgs.forEach(function(item,index){
					var className=item.ifCanOper == 1 ? 'controlMsg' : 'alertMsg';
					infos+='<span style="padding-right:5px;" class="'+className+'">'+item.abnormalMsg+'</span>';
				})	
			}
			infos+='<span>'+ifHasNeedCareOrder[0].suffixMsg+'</span>'	
			infos+='是否现在进行处理？</p>'  
		}
		if(ifHasNeedCareOrder.length > 0 && ifHasNeedCareOrder[0].otherAbnormalMsgs.length > 0){
			infos+='<p style="margin-bottom:10px;">'+ifHasNeedCareOrder[0].prefixMsg
			var msgs=ifHasNeedCareOrder[0].otherAbnormalMsgs;
			if(msgs.length>0){
				msgs.forEach(function(item,index){
					var className=item.ifCanOper == 1 ? 'controlMsg' : 'alertMsg'
					var linkUrl=item.linkUrl;
					if (linkUrl!=""){
						infos+='<a style="margin-right:5px;text-decoration:underline;" class="'+className+'" href="#" onclick=openOtherAbnormalMsgLink("'+linkUrl+'","'+item.abnormalMsg+'")>'+item.abnormalMsg+'</a>';
					}else{
						infos+='<span style="padding-right:5px;" class="'+className+'">'+item.abnormalMsg+'</span>';
					}
				})	
			}
			if(ifHasNeedCareOrder[0].ifOtherCanOper == '1' && isTransNeedCareFlag != 'Y'){
				infos+='<span>需处理后才能进行转科操作！</span>'	
			}else{
				infos+='<span>需处理！</span>'
			}
			infos+='</p>'    	
		}
		$("#transfer-info .contents").html(infos);
        $("#transfer-info").dialog("open");
      }*/
}

/// 立即转科
function nowTransfer(){
	$("#transfer-info").dialog("close");
	$("#nowtrans-btn,#nowdeal-btn,#close-btn").hide();
	$("#transfer-btn").show();
}

// 立即处理
function openNeedCare(){
	var winWidth = Math.floor(window.screen.availWidth * 0.96);
	var winHeight = Math.floor(window.screen.availHeight * 0.96);
	var winTop = (window.screen.availHeight - winHeight) / 2;
	var winLeft = (window.screen.availWidth - winWidth) / 2;    
	window.open(getIframeUrl("nur.hisui.orderNeedCare.csp?EpisodeID="+episodeID+"&TypeCode=T"),"转科需关注医嘱","top="+winTop+",left="+winLeft+",width="+winWidth+",height="+winHeight+"")
	$("#transfer-info").dialog("close");
	$("#nowtrans-btn,#nowdeal-btn,#close-btn").hide();
	closeTransferDept();	
}

// 关闭转科提示弹窗
function closeTransferInfo(){
	$("#transfer-info").dialog("close");
	$("#nowtrans-btn,#nowdeal-btn,#close-btn").hide();
    if (ifHasNeedCareOrder.length > 0 || babyAlertMsgArr.length > 0) {
        if (ifHasTransOrd != "0") {
            if (((ifHasNeedCareOrder.length > 0 && String(ifHasNeedCareOrder[0].ifCanOper) === "0" && String(ifHasNeedCareOrder[0].ifOtherCanOper) === "0")||(ifHasNeedCareOrder.length == 0)) && (((babyAlertMsgArr.length > 0 && String(babyIfCanOper) ==="0" && String(babyIfOtherCanOper)==="0"))||(babyAlertMsgArr==0))) {
	            if (isTransOrderFlag === "Y") {
	              	$("#transfer-btn").show();
	            }
          	} else {
            	if (isTransOrderFlag === "Y" && isTransNeedCareFlag === "Y") {
              		$("#transfer-btn").show();
            	}
          	}
       	} else {
	        if (((ifHasNeedCareOrder.length > 0 && String(ifHasNeedCareOrder[0].ifCanOper) === "0" && String(ifHasNeedCareOrder[0].ifOtherCanOper) === "0")||(ifHasNeedCareOrder.length == 0)) && (((babyAlertMsgArr.length > 0 && String(babyIfCanOper) ==="0" && String(babyIfOtherCanOper)==="0"))||(babyAlertMsgArr==0))) {
	            $("#transfer-btn").show();
	        }
        }
    } else {
        if (ifHasTransOrd != "0" && isTransOrderFlag === "Y") {
          	$("#transfer-btn").show();
        }
    }	
}

// 关闭转科弹窗
function closeTransferDept(){
	if (websys_showModal('options').CallBackFunc) {
		websys_showModal('options').CallBackFunc();
	}else{
		window.close();
	}
}

// 转科
function submitTransferDeptForm() {
	var locID=$("#dept").combobox("getValue");
	var wardID=$("#ward").combobox("getValue");	
	var usercode=$.trim($("#username").val());
	var password=$.trim($("#password").val());
	if (locID=="") {
		return $.messager.popover({msg:"请选择科室！",type: 'error'});
	}
	if (wardID="") {
		return $.messager.popover({msg:"请选择病区！",type: 'error'});
	}
	if (ifClickTrans) {
		ifClickTrans = false;
		runClassMethod("Nur.NIS.Service.Base.User","SignPasswordConfirm",{"userCode":usercode,"passWord":password},function(data){
			if (String(data.result) === "0") {
              var userID = String(data.userID);
              transferDeptApply(userID);
            } else {
              ifClickTrans = true;
              $.messager.popover({msg:data.result,type: 'error'});
            }
		},'json',false)	
        
    }
}

function transferDeptApply(userID){
	var locID=$("#dept").combobox("getValue");
	var wardID=$("#ward").combobox("getValue");	
	runClassMethod("Nur.NIS.Service.Base.Transfer","TransLocApply",{"EpisodeID":episodeID,"TransLoc":locID,"WardID":wardID,"UserID":userID},function(data){
		if (String(data.status) === "0") {
			ifClickTrans = true;
        	closeTransferDept();
        }else{
	        $.messager.popover({msg:"申请转科失败！"+data.status,type: 'error'});
	        ifClickTrans = true;
	    }
	},'json',false)	
}
function openOtherAbnormalMsgLink(linkUrl,title){
	var winWidth = Math.floor(window.screen.availWidth * 0.96);
	var winHeight = Math.floor(window.screen.availHeight * 0.96);
	var winTop = (window.screen.availHeight - winHeight) / 2;
	var winLeft = (window.screen.availWidth - winWidth) / 2;     
	window.open(getIframeUrl(linkUrl+"?EpisodeID="+episodeID),title,"top="+winTop+",left="+winLeft+",width="+winWidth+",height="+winHeight+"")
}
var openBabyOrderNeedCare=function(babyAdmId) {
	var obj=getWidthHeightObj();
	var abnormWin2=websys_createWindow(getIframeUrl("../csp/nur.hisui.orderNeedCare.csp?EpisodeID="+babyAdmId+"&defaultTypeCode=D"),"","top="+obj.iTop+",left="+obj.iLeft+",width="+obj.iWidth+",height="+obj.iHeight+"")
}
var openOtherAbnormalMsgLink=function(episodeID,linkUrl,title){
	var obj=getWidthHeightObj();
	var abnormWin2=websys_createWindow(getIframeUrl(linkUrl+"?EpisodeID="+episodeID),title,"top="+obj.iTop+",left="+obj.iLeft+",width="+obj.iWidth+",height="+obj.iHeight+"")
}
function getWidthHeightObj(){
	var iHeight=window.screen.height-150;
	var iWidth=window.screen.width-50;
	var iTop=(window.screen.height-30-iHeight)/2;
	var iLeft=(window.screen.width-30-iWidth)/2;
	return {
		iHeight:iHeight,
		iWidth:iWidth,
		iTop:iTop,
		iLeft:iLeft
	};
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