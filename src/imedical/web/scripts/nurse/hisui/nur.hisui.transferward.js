var ifHasNeedCareOrder="",ifClickTrans=true;
var isTransNeedCareFlag="",isTransOrderFlag="";
var ifHasTransOrd="";
var lastTransOrigWardId="";
var curWardID="",curLocID="",curWardLinkLocID="";
var curWardLocID="";
var babyIfCanOper=0,babyIfOtherCanOper=0,babyAlertMsgArr=[];
$(window).load(function() {
	$("#Loading").hide();
})
$(function(){
	$("#username").val(session['LOGON.USERCODE']);
	$("#bedNo").combobox({"disabled":true});
	$("#transfer-btn").hide();
	getLastTransOrigWard();
	getTransWardOrdInfo();
	getAbnormalOrder();
	getWardList();
	//getNeedCareOrder();
})
function getAbnormalOrder(){
	/*runClassMethod("Nur.NIS.Service.Base.Transfer","getAbnormalOrder",{"episodeID":episodeID,"abnormalType":"TransWard"},function(data){
		ifHasNeedCareOrder=data;
	},'json',false)	*/
	$.cm({
		ClassName:"Nur.NIS.Service.Base.Transfer",
		MethodName:"getAbnormalOrder",
		episodeID:episodeID,
		abnormalType:"TransWard"
	},function(data){
		ifHasNeedCareOrder=data;
	})
}
function getLastTransOrigWard(){
	$.cm({
		ClassName:"Nur.NIS.Service.Base.Transfer",
		MethodName:"getLastTransOrigLocWard",
		episodId:episodeID
	},function(data){
		lastTransOrigWardId = data.OrigWardID;
    	curWardID = data.curWardID;
    	curLocID = data.curLocID;
    	curWardLinkLocID = data.curWardLinkLocID;
	})
}
function getWardList(){
	$HUI.combobox("#ward",{
		url:$URL+"?ClassName=Nur.NIS.Service.Base.Loc&QueryName=GetTransLocLinkWardsByAdmQuery&keyWord=",
		mode:'local',
		selectOnNavigation:true,
		valueField:'wardID',
		textField:'desc',	
		onBeforeLoad:function(param){   
			var desc=""
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{keyWord:desc,Adm:episodeID,currWardID:session['LOGON.WARDID'],exceptFlag:"Y"});
		},
		loadFilter:function(data){			
			return data.rows;
		},
		onLoadSuccess:function(data){	
			if (data.length === 0) {
              	$.messager.popover({msg:"无关联病区！",type: 'info'});
              	$(this).combobox('disable');
            }
		},
		onChange:function(record){
			var bedNoDisabled=transWardBedControl==1?true:false;
			var data=$(this).combobox("getData");
			data.forEach(function(item,index){
            	if (item.wardID == record) {
              		var limitFlag = item.ageSexLimitFlag;
              		if (limitFlag == "Y") {
	              		$.messager.popover({msg:"所选择的病区有性别/年龄限制！",type: 'alert'});
        				$("#transfer-btn").hide();
              		}else{
	              		//$("#transfer-btn").show();
	              		getNeedCareOrder(item.wardID,item.locID,item.ifMaternalBabyWard);
	              	}
	              	/*if (item.ifMaternalBabyWard=="true"){
		              	bedNoDisabled=true;
		            }*/
            	}
          	});
          	var data=$.cm({
				ClassName:"Nur.NIS.Service.Base.Patient",
				MethodName:"getBabyTransWardBedFlag",
				EpisodeID:episodeID,
				transInWardId:record
			},false)
			if (data.bedNoDisabled=="false") bedNoDisabled=true;
			if (data.transWardBedControl===0) {
				$("label[for=bedNo]").addClass("clsRequired");
			}else{
				if (transWardBedControl===0){
					$("label[for=bedNo]").addClass("clsRequired");
				}else{
					$("label[for=bedNo]").removeClass("clsRequired");
				}
			}
			$("#bedNo").combobox({
				url:$URL+"?ClassName=Nur.NIS.Service.Base.Ward&QueryName=GetEmptyBeds&rows=99999&wardID=&EpisodeID="+episodeID,
				mode:'local',
				selectOnNavigation:true,
				disabled:bedNoDisabled,
				valueField:'ID',
				textField:'code',
				onBeforeLoad:function(param){   
					param = $.extend(param,{
						wardID:record,
						onlyShowBabyBed:data.showBabyBedFlag=="true"?"Y":"N"
					});
				},
				loadFilter:function(data){			
					return data.rows;
				},
				onSelect:function(rec){
					if (rec){
						if (rec.ifRoomSexRestrict==1){
							$.messager.popover({msg:"房间只允许住同性别病人！",type: 'error'});
        					$("#bedNo").combobox("setValue","");
        					return false;
						}
						if (rec.ifRoomSexRestrict==2){
							$.messager.popover({msg:"性别与床位要求不符！",type: 'error'});
        					$("#bedNo").combobox("setValue","");
        					return false;
						}
						if(rec.bedDateTo!=""){
		              		$.messager.confirm('确认对话框', rec.code+'床将在'+rec.bedDateTo+"停止使用，是否继续?", function(r){
								if (!r){
								   $("#bedNo").combobox("setValue","");
								}
							});
	              		}
					}
				}
			});
		},
		filter: function(q, row){
			return (row["desc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["searchCode"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		}
	})
}

function getNeedCareOrder(wardID,locID,ifMaternalBabyWard){
	var data=$.cm({
		ClassName:"Nur.NIS.Service.Base.Transfer",
		MethodName:"IfHasNotControlLoc",
		locID:locID,
		transFromlocID:curLocID,
		transFromWardID:curWardID
	},false)
	isTransNeedCareFlag = data.isTransNeedCareFlag;
    isTransOrderFlag = data.isTransOrderFlag;
    //回转不控制需关注
    if ((lastTransOrigWardId!="")&&(lastTransOrigWardId==wardID)){
	    var data=$.cm({
			ClassName:"Nur.NIS.Service.Base.Transfer",
			MethodName:"IfHasNotControlLoc",
			locID:curWardLocID,
			transFromlocID:curLocID,
			transFromWardID:curWardID
		},false)
	    var transBackNeedCareFlag=data.transBackNeedCareFlag;
	    if (transBackNeedCareFlag=="Y") isTransNeedCareFlag="Y"
	}
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
				MsgArr.push("患者存在"+alertMsg + " " +otherAlertMsg+"不能转病区,请先处理!");
			}
		}else if(otherAlertMsg!=""){
			if(ifOtherCanOper=="0"){
				MsgArr.push("患者存在"+otherAlertMsg);
			}else{
				MsgArr.push("患者存在"+otherAlertMsg+"不能转病区,请先处理!");
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
			AbnormalType:"W"
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
			if ((babyIfCanOper==1)||(babyIfOtherCanOper==1)) babyAlertMsgArr.push("不能转病区,请点击婴儿名称处理!");
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
	
	/*$("#nowtrans-btn,#nowdeal-btn,#close-btn").hide();
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
        if(ifHasTransOrd!="0"){
	    	infos+='<p style="margin-bottom:10px;" class="controlMsg">'+ifHasTransOrd+'</p>';   
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
			infos+='需处理后才能进行转病区操作！</p>'  
		}
		if(ifHasNeedCareOrder.length > 0 && String(ifHasNeedCareOrder[0].ifCanOper) === '0'){
			infos+='<p style="margin-bottom:10px;"><span>'+ifHasNeedCareOrder[0].prefixMsg+'</span>';
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
					var className=item.ifCanOper == 1 ? 'controlMsg' : 'alertMsg';
					var linkUrl=item.linkUrl;
					if (linkUrl!=""){
						infos+='<a style="margin-right:5px;text-decoration:underline;" class="'+className+'" href="#" onclick=openOtherAbnormalMsgLink("'+linkUrl+'","'+item.abnormalMsg+'")>'+item.abnormalMsg+'</a>';
					}else{
						infos+='<span style="padding-right:5px;" class="'+className+'">'+item.abnormalMsg+'</span>';
					}
				})	
			}
			if(ifHasNeedCareOrder[0].ifOtherCanOper == '1'){
				infos+='<span>需处理后才能进行转病区操作！</span>'	
			}else{
				infos+='<span>需处理！</span>'
			}
			infos+='</p>'    	
		}
		$("#transfer-info .contents").html(infos);
        $("#transfer-info").dialog("open");
      }*/
}

// 立即处理
function openNeedCare(){
	var winWidth = Math.floor(window.screen.availWidth * 0.96);
	var winHeight = Math.floor(window.screen.availHeight * 0.96);
	var winTop = (window.screen.availHeight - winHeight) / 2;
	var winLeft = (window.screen.availWidth - winWidth) / 2;     
	window.open(getIframeUrl("nur.hisui.orderNeedCare.csp?EpisodeID="+episodeID+"&TypeCode=W"),"转病区需关注医嘱","top="+winTop+",left="+winLeft+",width="+winWidth+",height="+winHeight+"")
	$("#transfer-info").dialog("close");
	$("#nowtrans-btn,#nowdeal-btn,#close-btn").hide();
	closeTransferWard();	
}

// 关闭转科提示弹窗
function closeTransferInfo(){
	//babyIfCanOper=0,babyIfOtherCanOper=0,babyAlertMsgArr=[];
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

// 关闭转病区弹窗
function closeTransferWard(){
	if (websys_showModal('options').CallBackFunc) {
		websys_showModal('options').CallBackFunc();
	}else{
		window.close();
	}
}

// 转病区
function submitTransferWardForm() {
	var wardID=getValueById("ward"); //$("#ward").combobox("getValue");
	var bedID=getValueById("bedNo"); //$("#bedNo").combobox("getValue");
	var usercode=$.trim($("#username").val());
	var password=$.trim($("#password").val());
	if (wardID=="") {
		return $.messager.popover({msg:"请选择病区！",type: 'error'});
	}
	if (!$("#bedNo").combobox("options").disabled){
		if ($("#bedNo").combobox("getData").length==0) {
			return $.messager.popover({msg:"所选择的转入病区无床位!",type: 'error'});
		}else{
			if ((parseInt(transWardBedControl)==0)&&(!bedID)){
				return $.messager.popover({msg:"请选择转入床位！",type: 'error'});
			}
		}
	}
	if (ifClickTrans) {
		ifClickTrans = false;
		runClassMethod("Nur.NIS.Service.Base.User","SignPasswordConfirm",{"userCode":usercode,"passWord":password},function(data){
			if (String(data.result) === "0") {
              var userID = String(data.userID);
              transferWardApply(wardID,bedID,userID);
            } else {
              ifClickTrans = true;
              $.messager.popover({msg:data.result,type: 'error'});
              $("#password").focus();
            }
		},'json',false)	
        
    }
}

function transferWardApply(wardID,bedID,userID){
	runClassMethod("Nur.NIS.Service.Base.Transfer","TransWard",{"episodeID":episodeID,"wardID":wardID,"bedID":bedID,"tempLoc":"","userID":userID},function(data){
		if (String(data.status) === "0") {
			ifClickTrans = true;
        	closeTransferWard();
        }else{
	        ifClickTrans = true;
	    	$.messager.popover({msg:data.status,type: 'error'});    
	    }
	},'json',false)	
}
function getTransWardOrdInfo(){
	/*runClassMethod("Nur.NIS.Service.Base.Patient","IfHasTransWardOrd",{"episodeID":episodeID,"locID":"","wardID":""},function(data){
		ifHasTransOrd=data.abnormalMsg;
	},'json',false)*/
	$.cm({
		ClassName:"Nur.NIS.Service.Base.Patient",
		MethodName:"IfHasTransWardOrd",
		episodeID:episodeID,
		locID:"",
		wardID:""
	},function(data){
		ifHasTransOrd=data.abnormalMsg;
	})
}
function openOtherAbnormalMsgLink(linkUrl,title){
	var winWidth = Math.floor(window.screen.availWidth * 0.96);
	var winHeight = Math.floor(window.screen.availHeight * 0.96);
	var winTop = (window.screen.availHeight - winHeight) / 2;
	var winLeft = (window.screen.availWidth - winWidth) / 2;     
	window.open(getIframeUrl(linkUrl+"?EpisodeID="+episodeID),title,"top="+winTop+",left="+winLeft+",width="+winWidth+",height="+winHeight+"")
}
/// 立即转病区
function nowTransfer(){
	$("#transfer-info").dialog("close");
	$("#nowtrans-btn,#nowdeal-btn,#close-btn").hide();
	$("#transfer-btn").show();
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