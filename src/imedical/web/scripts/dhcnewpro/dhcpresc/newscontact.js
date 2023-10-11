var lgHospID=session['LOGON.HOSPID'];
var lgCtLocID=session['LOGON.CTLOCID'];
var lgGroupID=session['LOGON.GROUPID'];
var lgUserID=session['LOGON.USERID'];
var lgUserCode=session['LOGON.USERCODE'];
var lgParams=lgHospID+"^"+lgCtLocID+"^"+lgGroupID+"^"+lgUserID;
var ws="",WEBSOCKET=true;
var allPrescObject={};  ///��ǰ����б�����
var mesObject={};
$(function(){
	
	initParams();
	
	openPolling();
	//initWs();
	
	initPage();
	
	initPageData();
	
	initMethod();	
})

function initParams(){
	USERTYPE = getParam("userType");   /// �û�����
	AUDITROWID = getParam("auditId");  /// ����ID 
}

function initPage(){
	if(AUDITROWID){
		$("#mainLayout").layout("hidden","west");	
	}
	if(USERTYPE=="Audit"){
		$("#replyArea").hide();
	}
	
	$("#content").focus();	
}

function initWs(){
	return;
	if(WEBSOCKET){
		//ʹ��websoketͨѶ
		var wsUrl = ((window.location.protocol == 'https:')?'wss:':'ws:')+'//'+window.location.host+
						'/imedical/web/web.DHCPRESCMessageWebSocketServer.cls'; //UnRead�Ǳ�ʶδ�����ֵ�ws
		ws = new WebSocket(wsUrl);
		
		ws.onopen  = function(event) {
			console.log('���ӳɹ�����!', event);
		};
		
		ws.onmessage = function(event) {
			var data = event.data;
			editMesListNumber(data);
		};
		
		ws.onerror = function(event) {
			console.log('WebSocket error received:', event);
		};
		
		ws.onclose = function(event) {
			console.log('�����Ѿ��ر�!', event);
			$.messager.confirm("����", "�����ѶϿ����Ƿ���������?", function (r) {
				if (r) {
					initWs();
				} 
			});
		};
		
	}
}

function editMesListNumber(data){
	
	if(isJSON(data)){
		var itmHtml=thisHtml(JSON.parse(data));
		$("#msgContent").append(itmHtml);
		scrollBottom();
	}else{
		var dataArray=data.split("^");
		var userType=dataArray[0];
		var auditId=dataArray[1];
		var number=parseInt(dataArray[2]);
		if(userType!=USERTYPE) return;
		var $mesItm = $('div[data-auditid="'+auditId+'"]');
		if($mesItm.length){
			number=number?number:'';
			$mesItm.find('#listUnreadNumber').html(number);
		}
	}
}

function isJSON(str) {
    if (typeof str == 'string') {
        try {
            var obj=JSON.parse(str);
            if(typeof obj == 'object' && obj ){
                return true;
            }else{
                return false;
            }

        } catch(e) {
            //console.log('error��'+str+'!!!'+e);
            return false;
        }
    }
    console.log('It is not a string!')
}

function scrollBottom(){
	$("#msgContent").parent().scrollTop(10000);	
}

function initPageData(){
	if(AUDITROWID){
		loadMessageText();
	}else{
		loadListText();
	}
	
	//loadMessageText();
}


function initMethod(){
	
	$('#content').on('keypress', function(e){  
		e=e||event;	// �����س�����   
		if(e.keyCode=="13"){
			stopDefault(e);
			sure();
		}
	});	
	
}

function reply(){
	/*if(!$(".checked").length){
		$.messager.alert("��ʾ","��ѡ��һ����¼!");
		return;	
	}*/
	var auditId=$(".checked").length?$(".checked").attr("data-auditid"):AUDITROWID;
	
	var url = 'dhcpresc.reviewreply.csp?auditId='+auditId;
	websys_showModal({
		url: url,
		iconCls:"icon-w-paper",
		title: '�󷽴���',
		closed: true,
		modal:true,
		width:900,
		height:750,
		onClose:function(){
			//_this._showSureAuditPop();	
		}
	});
}

function sure(){
	var auditId=$(".checked").length?$(".checked").attr("data-auditid"):AUDITROWID;
	var content=$("#content").val();
	$("#content").val("");
	
	if(content==""){
		$.messager.alert("��ʾ","��Ϣ���ݲ���Ϊ��!");
		return;	
	}
	var params=auditId+"^"+content+"^"+USERTYPE;
	
	$cm({
		ClassName:"web.DHCPRESCNewsContact",
		MethodName:"InsertMessage",
		"Params":params,
		"LgParams":lgParams,
		"dataType":"text"
	},function(ret){
		if(isJSON(ret)){
			/*
			var itmHtml=thisHtml(JSON.parse(ret));
		
			if(mesObject[auditId]){
				mesObject[auditId].MsgData.push(JSON.parse(ret));
			}
			
			$("#msgContent").append(itmHtml);
			*/
			loadMessageText("flush");
			//scrollBottom();
		}else{
			$.messager.alert("��ʾ","��Ϣ����ʧ��!��Ϣ:"+ret);	
		}
		
	});
}

function loadListText(){
	var params=USERTYPE;
	$cm({
		ClassName:"web.DHCPRESCAuditPopup",
		MethodName:"JsonListUnreadMessageNew",
		"Params":params,
		"LgParams":lgParams
	},function(jsonRet){
		if($(".listItm").length){
			if(jsonRet.length){
				///�³��ֵ�dom�������
				var firstAuditId = $(".listItm").eq(0).attr("data-auditid");
				var addOrUpdate="add",preAddHtml="";
				for(index in jsonRet){
					var itmData=jsonRet[index];
					var itmDataAuditId=itmData.AuditID;
					if(addOrUpdate==="add"){
						if(itmDataAuditId!=firstAuditId){
							var itmHtml = getItmHtml(itmData);
							preAddHtml = preAddHtml+itmHtml;
						}else{
							preAddHtml?$("#list").before(preAddHtml):"";
							addOrUpdate="update";
						}
					}
					if(addOrUpdate==="update"){
						var msgNum=(USERTYPE=="Audit"?itmData.DoctorCount:itmData.AuditCount);
						msgNum=="0"?msgNum="":"";
						$(".listItm[data-auditid='"+itmDataAuditId+"']").find("#listUnreadNumber").html(msgNum);
						$(".listItm[data-auditid='"+itmDataAuditId+"']").find("#listPatStatus").html(itmData.Status);
					}
				}
				
				///��ʧ��dom����ɾ��
				var lastDataAuditID=jsonRet[jsonRet.length-1].AuditID;
				$(".listItm[data-auditid='"+lastDataAuditID+"']").nextAll().remove();
				
			}
		}else{
			$("#list").html("");
			if(jsonRet.length){
				for(index in jsonRet){
					var itmData=jsonRet[index];
					addListItm(itmData,"");
				}
				$("#list").find(".listItm").eq(0).click();
			}
		}
		return;
		if(jsonRet.length){
			for(index in jsonRet){
				var itmData=jsonRet[index];
				//allPrescObject[itmData.AuditID]=itmData;
				addListItm(itmData,"");
			}
			$("#list").find(".listItm").eq(0).click();
		}
	
		return;
	});
}

function addListItm(itmData,position){
	var itmHtml = getItmHtml(itmData);
	if(position=="before"){
		$("#list").before(itmHtml);
	}else{
		$("#list").append(itmHtml);
	}
	return;
}

function getItmHtml(itmData){
	if(AUDITROWID) return;
	
	var sexImgName=(itmData.PatSex=="��"?"bz3.png":"bz2.png");
	var msgNum=(USERTYPE=="Audit"?itmData.DoctorCount:itmData.AuditCount);
	if(msgNum=="0") msgNum="";
	
	var itmHtml=""+
	"<div class='listItm' data-parid='"+itmData.PARRowID+"' data-auditId='"+itmData.AuditID+"' onclick='checkListItm(this)'>"+
		"<img id='listImg' src='../scripts/dhcnewpro/dhcpresc/images/"+sexImgName+"'/>"+
		"<span id='listPatName'>"+itmData.PatName+"</span>"+
		"<span id='listPatStatus' style='position: absolute;left: 95px;font-weight: 500;'>"+itmData.Status+"</span>"+
		"<span id='listPrescNo'>["+itmData.PrescNo+"]</span>"+
		//"<span id='listAuditTime'>"+itmData.Date+" "+itmData.Time+"</span>"+
		"<span id='listAuditTime'>"+itmData.Time+"</span>"+
		"<span id='listUnreadNumber'>"+msgNum+"</span>"+
	"</div>"+
	"<div style='height:15px'></div>"
	return itmHtml;	
}

function checkListItm(_this){
	if(!$(_this).hasClass("checked")){
		$(".checked").length?$(".checked").removeClass("checked"):"";
		$(_this).addClass("checked");
		$(_this).find("#listUnreadNumber").html("");
	}
	loadMessageText();
}


function loadMessageText(type){
	var auditId=$(".checked").length?$(".checked").attr("data-auditid"):AUDITROWID;
	if(!auditId) return;
	type=="flush"?"":$("#msgContent").html("");
	var params=auditId;
	$cm({
		ClassName:"web.DHCPRESCNewsContact",
		MethodName:"JsonListMsgData",
		"Params":params
	},function(retData){
		var setReadAllId="";
		var auditData=retData.AuditData;
		type=="flush"?updProcessData(auditData):setProcessData(auditData);
		
		var listData=retData.MsgData;
		var isEdit=false;
		for(i in listData){
			if((listData[i].Type!=USERTYPE)&&(listData[i].ReadFlag!="Y")){
				setReadAllId=(setReadAllId==""?listData[i].PAMRowID:setReadAllId+","+listData[i].PAMRowID);
			}
			
			if(!$(".msg-itm[data-id='"+listData[i].PAMRowID+"']").length){
				addMsgItm(listData[i]);	
				isEdit = true;	
			}
		}
		if((retData.AuditData.Status=="˫ǩͨ��")){
			$("#reply").show();
		}else{
			$("#reply").hide();
		}
		
		if(isEdit){
			mesObject[auditId] = retData;
			///���������·�
			scrollBottom();
		}
		///�����Ѷ�
		if(setReadAllId!=""){
			setMsgReadStatus(setReadAllId);	
		}
	});	
}


function addMsgItm(listItmData){
	var itmHtml=thisHtml(listItmData);
	var itmMsgRowId=listItmData.PAMRowID;
	$("#msgContent").append(itmHtml);
}

function updProcessData(thisData){
	if($(".lim_dot_hstatus").length){
		$(".lim_dot_hstatus").html(thisData.Status);
		$(".lim_dot_hdate").html(thisData.Date+" "+thisData.Time);
		$(".lim_dot_oreason").html(thisData.Reason);
		$(".lim_dot_oremark").html(thisData.Remark);
	}
	return;
}

function setProcessData(thisData){
	USERTYPE=="Audit"?userType="visitor":userType="operator";
	var imgName="ystx.png";
	var retHtml=""+
	"<div id='' class='role-"+userType+" lim_"+userType+" lim_head lim_clearfloat'>"+
		"<div class='head'>"+
			"<img src='../scripts/dhcnewpro/dhcpresc/images/"+imgName+"' width='40' height='40'>"+
		"</div>"+
		"<div class='chater_info clear'>"+
			"<span class='lim_name'>"+thisData.User+"</span>"+
			"<span class='lim_time'>"+" "+thisData.Date+" "+thisData.Time+"</span>"+
		"</div>"+
		"<div class='lim_bubble' style='width: 100%;'>"+
			"<div class='lim_content' name='text'>"+
				"<div class='lim_dot'>"+
					"<div class='lim_dot_head'>"+
						"<span class='lim_dot_hstatus'>"+thisData.Status+"</span>"+
						"<span class='lim_dot_hpresc'>"+thisData.PrescNo+"</span>"+
						"<span class='lim_dot_hdate'>"+thisData.Date+" "+thisData.Time+"</span>"+
					"</div>"+
					"<div class='lim_dot_pat'>"+
						"<div class='lim_dot_pinfo'>"+
							"<img src='../scripts/dhcnewpro/dhcpresc/images/hztx.png' width='40' height='40'>"+
							"<span class='lim_dot_pname'>"+thisData.PatName+"</span>"+
							"<span class='lim_dot_psex'>"+thisData.PatSex+"</span>"+
							"<span class='lim_dot_page'>"+thisData.PatAge+"</span>"+
							"<span class='lim_dot_pno'>"+"�ǼǺ�"+" "+thisData.PatNo+"</span>"+
							"<span class='lim_dot_ploc'>"+"�������"+" "+thisData.PatLoc+"</span>"+
							"<span class='lim_dot_pdoc'>"+"����ҽʦ"+" "+thisData.QueDoc+"</span>"+
						"</div>"+
						"<div class='lim_dot_diag'>"+
							"<span class='lim_dot_dtitle'>�����</span>"+
							"<span class='lim_dot_dtext'>"+thisData.Diag+"</span>"+
						"</div>"+
					"</div>"+
					"<div style='height:5px;'></div>"+
					"<div>"+
						"<span class='lim_dot_oreasont'>ԭ��</span>"+
						"<span class='lim_dot_oreason'>"+" "+thisData.Reason+"</span>"+
					"</div>"+
					"<div>"+
						"<span class='lim_dot_oremarkt'>��ע</span>"+
						"<span class='lim_dot_oremark'>"+" "+thisData.Remark+"</span>"+
					"</div>"+
				"</div>"+
			"</div>"+
		"</div>"+
	"</div>"
	$("#msgContent").append(retHtml);
	return;
}

function thisHtml(itmData){
	var userType="",imgName="";
	if(itmData.Type==USERTYPE){
		userType="visitor";
	}else{
		userType="operator"
	}
	itmData.Type=="Audit"?imgName="ystx.png":imgName="ystx2.png";
	
	var retHtml=""+
	"<div id='' class='msg-itm role-"+userType+" lim_"+userType+" lim_head lim_clearfloat' data-id='"+itmData.PAMRowID+"'>"+
		"<div class='head'>"+
			"<img src='../scripts/dhcnewpro/dhcpresc/images/"+imgName+"' width='40' height='40'>"+
		"</div>"+
		"<div class='chater_info clear'>"+
			"<span class='lim_name'>"+itmData.SendUser+"</span>"+
			"<span class='lim_time'>"+" "+itmData.Date+" "+itmData.Time+"</span>"+
		"</div>"+
		"<div class='lim_bubble'>"+
			"<div class='lim_content' name='text'>"+
				"<div class='lim_dot'>"+itmData.Content+"</div>"+
			"</div>"+
		"</div>"+
	"</div>"
	return retHtml;
}

function setMsgReadStatus(ids){
	$cm({
		ClassName:"web.DHCPRESCNewsContact",
		MethodName:"SetMsgReadStatus",
		"UserType":USERTYPE,
		"IdStr":ids,
		"LgParams":lgParams,
		"dataType":"text"
	},function(retData){
		if(retData!=0){
			$.messager.alert("��ʾ",retData);
			return;
		}
	});	
	return;
}

function cancel(){
	
	///ֹͣ��ѯ
	if(intervalData){
		clearInterval(intervalData);	
	}
	window.parent.$("#newsWin").window("close");
	return;
	//websys_showModal("close");	
	close();
} 

function close(){
	///�ر�server socket
	$cm({ClassName:"web.DHCPRESCMessageWebSocketServer",MethodName:"ClsoeWsServerByUser",UserId:lgUserID,"dataType":"text"},function(retData){});	
	window.parent.$("#newsWin").window("close");
	ws.close(); ///�ر�websocket
}

function openPolling(){
	
		intervalData=setInterval(function(){
			loadListText(); //����б�
			loadMessageText("flush");
		},1000*2);	
}


//��ֹ�����Ĭ����Ϊ������ͨ�÷��� 
function stopDefault(e){ 
    //��ֹ�����Ĭ����Ϊ(W3C) 
    if(e && e.preventDefault){ 
        e.preventDefault(); 
    } 
    //IE����֯�������Ϊ 
    else{ 
        window.event.returnValue=fale;
        return false;
    } 
} 