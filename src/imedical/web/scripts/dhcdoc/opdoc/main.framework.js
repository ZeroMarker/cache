$(function(){
    InitTreatStep();        //初始化配置诊疗步骤
    InitShortcutBar();      //初始化配置按钮
    InitEvent();
});
function InitEvent(){
}
function InitTreatStep()
{
    $('#menuStep').marystep({
        queryParams:{ClassName:'DHCDoc.OPDoc.Workflow',QueryName:'QueryTreatStep',LocID:session['LOGON.CTLOCID'],GroupID:session['LOGON.GROUPID'],UserID:session['LOGON.USERID']},
        onBeforeSelect:chartOnBlur,
        onSelect:function(opts,cfg){
            hrefRefresh($.extend({},opts),$.extend({},cfg));
        },
        onLoadSuccess:function(data){
            var frm = dhcsys_getmenuform();
            var adm=frm.EpisodeID.value;
            var papmi= frm.PatientID.value;
            var mradm=frm.mradm.value;
            if(adm){
                switchPatient(papmi,adm,mradm);
            }else{
                showPatListWin();
            }
        }
    });
}
function InitShortcutBar()
{
    $('#btnList').marybtnbar({
        showIcon:false,
        plain:false,
        direction:'y',
        btnCls:HISUIStyleCode=="lite"?'btn-bar-btn-lite':'btn-bar-btn',
        queryParams:{url:'opdoc.main.framework.csp'},
        onClick:function(jq,cfg){
            if(cfg.url){
                var width=$(document).width()*0.95;
                width=width<1300?1300:width;
                ShowHISUIWindow({
                    title:cfg.text,
                    src:replaceLinkParams(cfg.url),
                    iconCls:cfg.iconCls||'',
                    width:width,
                    height:$(document).height()*0.95,
                    isTopZindex:true
                });
            }
        },
        onBeforeLoad:function(param){
            param.EpisodeID=ServerObj.EpisodeID;
        }
    });
}
function refreshBar()
{
    return InitPatInfoBanner();
}
function chartOnBlur(){
    var tab=$('#tabMenuFrame').tabs('getSelected');
    if(tab){
        var chartOnBlur=tab.children('iframe')[0].contentWindow.chartOnBlur;
        if(chartOnBlur) return chartOnBlur();
    }
    return true;
}
function hrefRefresh(opts,cfg)
{
    $('#tabMenuFrame').showMask();
    tkMakeServerCall("web.DHCDocMainOrderInterface","ChartItemChange");     // 解锁病人
    for(var key in cfg){
        opts.url+=(opts.url.indexOf("?")>-1?"&":"?")+(key=='oneTimeValueExp'?cfg[key]:(key+"="+cfg[key]));
    }
    var src=replaceLinkParams(opts.url);
    if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
    if($('#tabMenuFrame').tabs('exists',opts.text)){
        $('#tabMenuFrame').tabs('select',opts.text);
        var tab=$('#tabMenuFrame').tabs('getTab',opts.text);
        var xhrRefresh=tab.children('iframe')[0].contentWindow.xhrRefresh;
        if(((opts.isRefresh=="1")||(opts.isRefresh=="true"))&&xhrRefresh){
            var urlParaObj = {papmi: ServerObj.PatientID, adm: ServerObj.EpisodeID, mradm: ServerObj.mradm};
            var urlPara=src.split("?")[1];
            if(urlPara){
                var urlParaArray=urlPara.split("&");
                for(var i=0;i<urlParaArray.length;i++){
                    var oneUrlPara=urlParaArray[i];
                    urlParaObj[oneUrlPara.split("=")[0]] = oneUrlPara.split("=")[1];
                }
            }
            xhrRefresh(urlParaObj);
        }else{
            tab.children('iframe').attr('src',src);
        }
    }else{
        $('#tabMenuFrame').tabs('add',{
            id:opts.id,
            title: opts.text,
            selected: true,
            content:"<iframe width='100%' height='100%' frameborder='0' scrolling='no' src='"+src+"'></iframe>"
        });
    }
    if (opts.id=="CompleteAdm"){
        ShowSecondeWin("onOpenDHCEMRbrowse");
    }
    $('#tabMenuFrame').hideMask();
}
function replaceLinkParams(lnk){
    var urlParaObj=urlToObj(lnk);
    if(!urlParaObj['EpisodeID']) urlParaObj['EpisodeID']=ServerObj.EpisodeID;
    if(!urlParaObj['PatientID']) urlParaObj['PatientID']=ServerObj.PatientID;
    if(!urlParaObj['mradm']) urlParaObj['mradm']=ServerObj.mradm;
    return rewriteUrl(lnk,urlParaObj); 
}
function switchPatient(patientId,episodeId,mradm)
{
    if(chartOnBlur()==false) return;
    setEprMenuForm(episodeId,patientId,mradm,"");
    refreshBar();
    if(typeof CDSSObj=='object') CDSSObj.SynAdm(episodeId);
    var PerStatus=tkMakeServerCall('web.DHCDocTransfer','GetQueStatusByAdm',episodeId);
    var StepIndex=0;
    if((PerStatus!='等候')&&(PerStatus!='报到')){
        var CurStepIndex=$('#menuStep').marystep('getCurStepIndex');
        if(CurStepIndex>-1) StepIndex=CurStepIndex;
    }else{
        if(ServerObj.NewDocGotoWhere){
            var DefIndex=$('#menuStep').marystep('getIndexByValue',ServerObj.NewDocGotoWhere);
            if(DefIndex>-1) StepIndex=DefIndex;
        }
    }
    var step=$('#menuStep').marystep('getStep',StepIndex);
    var opts=$('#menuStep').marystep('options');
    var beforeSelFun=opts.onBeforeSelect;
    opts.onBeforeSelect=function(){};
    if(step.text=='完成接诊'){
        $('#menuStep').marystep('selectLastStep');
    }else{
        $('#menuStep').marystep('selectStep',StepIndex);
    }
    opts.onBeforeSelect=beforeSelFun;
    var step=$('#menuStep').marystep('getCurStep');
    if(step.text!='门诊病历'){
        //仅当电子病历配置为局部刷新时，才执行局部刷新方法
        var BLindex=$('#menuStep').marystep('getIndexByValue',"WriteEMR");
        if (BLindex>=0){
            var BLopts=$('#menuStep').marystep('getStep',BLindex);
            if((BLopts.isRefresh=="1")||(BLopts.isRefresh=="true")){
                invokeChartFun('门诊病历','xhrRefresh',{papmi:patientId,adm:episodeId,mradm:mradm}); 
            }
        }
    }
    ShowSecondeWin("onSelectIPPatient");
}  
function setEprMenuForm(adm,papmi,mradm,canGiveBirth){
    var frm = dhcsys_getmenuform();
    var menuWin=websys_getMenuWin();
    if((frm) &&(frm.EpisodeID.value != adm)){
        if ((menuWin) &&(menuWin.MainClearEpisodeDetails)) menuWin.MainClearEpisodeDetails();
        frm.EpisodeID.value = adm;          //DHCDocMainView.EpisodeID;
        frm.PatientID.value = papmi;        //DHCDocMainView.PatientID;
        frm.mradm.value = mradm;                //DHCDocMainView.EpisodeID;
        if (frm.canGiveBirth) frm.canGiveBirth.value = canGiveBirth;
    }
    $.extend(ServerObj,{PatientID:papmi,EpisodeID:adm, mradm:mradm, RegNo:''});
}
function invokeChartFun(tabName,funName)
{
    var tab = $("#tabMenuFrame").tabs('getTab',tabName);
    if(tab&&tab.children('iframe').size()){ 
        var fun=tab.children('iframe')[0].contentWindow[funName];
        if(fun){
            var args=[],j=0;
            for (var i=2; i<invokeChartFun.arguments.length; i++) {
                args[j++]=invokeChartFun.arguments[i];
            }
            fun.apply(tab.children('iframe')[0],args);
        }else{
            console.log("未找到【"+tabName+"】页签的【"+funName+"】方法!");
        }
    }else{
        console.log("未找到【"+tabName+"】页签!");
    }
    return ;
}
function switchTabByEMR(tabName,cfg)
{
    var data=$('#menuStep').marystep('getData');
    for(var i=0;i<data.length;i++){
        if((data[i].id==tabName)||(data[i].text.toUpperCase()==tabName.toUpperCase())||($g(data[i].text)==$g(tabName))){
            $('#menuStep').marystep('selectStep',i,cfg);
            break;
        }
    }
}
function getConfigUrl(userId,groupId,ctlocId){
    return {title:"诊疗配置",url:"dhcdoc.custom.setting.csp",width:750,height:700,iconCls:'icon-w-setting'}; 
}
//业务代码
function PreCardBillClickHandle(){
    var groupDR = session['LOGON.GROUPID'];
    var locDR = session['LOGON.CTLOCID'];
    var hospDR = session['LOGON.HOSPID'];
    var expStr = groupDR + "^" + locDR + "^" + hospDR;
    $.m({
        ClassName:"web.udhcOPBillIF",
        MethodName:"GetCheckOutMode",
        expStr:expStr
    },function(mode){
        var PatDefCardInfo=$.cm({ 
            ClassName:"web.DHCOPAdmReg",
            MethodName:"GetValidAccMNoCardNo",
            PatientID:ServerObj.PatientID,
            dataType:"text"
        }, false);
        $("#CardBillCardTypeValue").val(PatDefCardInfo.split("^").slice(1,PatDefCardInfo.split("^").length).join("^")); 
        var CardNo = PatDefCardInfo.split("^")[0];
        if(mode == 1) {
            if (CardNo == "") {
                $.messager.alert("提示","该患者无对应卡信息,不能进行预扣费!");
                return false;
            }
            $.messager.confirm('提示', '是否确认扣费?', function(r){
                if (r){
                    var insType = "";
                    var oeoriIDStr = "";
                    var guser = session['LOGON.USERID'];
                    var rtn = checkOut(CardNo,ServerObj.PatientID,ServerObj.EpisodeID,insType,oeoriIDStr,guser,groupDR,locDR,hospDR,CardBillAfterReload);
                    //CardBillAfterReload();
                }
            });
            return;
            
        }else {
            var CardTypeValue = $("#CardBillCardTypeValue").val();
            var CardTypeRowId = (CardTypeValue != "") ? CardTypeValue.split("^")[0] : "";
            var url = "dhcbill.opbill.charge.main.csp?ReloadFlag=3&CardNo=" + CardNo + "&SelectAdmRowId=" + ServerObj.EpisodeID + "&SelectPatRowId=" + ServerObj.PatientID + "&CardTypeRowId=" + CardTypeRowId;
            websys_showModal({
                url: url,
                title: '预扣费',
                iconCls: 'icon-w-inv',
                width: '96%',
                height: '85%',
                isTopZindex:true,
                onClose: function() {
                    CardBillAfterReload();
                }
            });
        }       
    });
}
function CardBillAfterReload(){
    var CurStage=$('#menuStep').marystep('getCurStep');
    if ((CurStage)&&((CurStage.text.indexOf('医嘱录入')>-1)||(CurStage.text.indexOf('草药录入')>-1))){
        invokeChartFun(CurStage.text,'CardBillAfterReload');
    }else{
        refreshBar();
    }
}
function CancelRecAdmClickHandle(){
    $.m({
        ClassName:"web.SSUser",
        MethodName:"GetDefaultCareProvider",
        userID:session['LOGON.USERID']
    },function(DoctorId){
        $.m({
            ClassName:"web.DHCDocOutPatientList",
            MethodName:"CancelAdmiss",
            Adm:ServerObj.EpisodeID,
            DocDr:DoctorId
        },function(myrtn){
            if (myrtn!='0') {
                if (myrtn=="NoToday"){
                    $.messager.alert("提示",t['CancelAdmissFailure']+',只能取消当日就诊的接诊.');
                }else if (myrtn=="NoAdmiss") {
                    $.messager.alert("提示",t['CancelAdmissFailure']+',未接诊的就诊不能取消.');
                }else if (myrtn=="NoSelf") {
                    $.messager.alert("提示",t['CancelAdmissFailure']+',只能取消本人接诊的就诊记录.');
                }else if (myrtn=="NoInitData") {
                    $.messager.alert("提示",t['CancelAdmissFailure']+',未得到接诊状态改变记录.');
                }else if (myrtn=="InsertFail") {
                    $.messager.alert("提示",t['CancelAdmissFailure']+',队列表记录更新失败.');
                }else if (myrtn=="UpdateAdmDocFail") {
                    $.messager.alert("提示",t['CancelAdmissFailure']+',更新就诊科室与医生失败.');
                }else if (myrtn=="diagnos") {
                    $.messager.alert("提示","患者已经录入诊断或者存在有效的医嘱不可取消接诊!")
                }else if (myrtn=="AddMark") {
                    $.messager.alert("提示","加号患者不能取消接诊!")
                }else {
                    $.messager.alert("提示",t['CancelAdmissFailure']);
                }
                return false;
            }else{
                $.messager.alert("提示",t['CancelAdmissSeccess'],"info",function(){
                    LoadOutPatientDataGrid();
                    showPatListWin();
                });
            }
        });
    });
}
function TransAdmClickHandle(config){
}
function PrintAllAfterClick(){
    var index=$('#menuStep').marystep('getIndexByValue',"CompleteAdm");
    if (index >= 0) {
        $('#menuStep').marystep('selectStep',index);
    }
}
/// 展示第二副屏
function ShowSecondeWin(Flag){
	var MainSreenFlag=websys_getAppScreenIndex();
    if (MainSreenFlag==0){
	    var Obj={PatientID:ServerObj.PatientID,EpisodeID:ServerObj.EpisodeID,mradm:ServerObj.mradm};
	    if (Flag=="onOpenIPTab"){
		    //信息总览
		}
		if (Flag=="onSelectIPPatient"){
		    //患者信息
		}
		if (Flag=="onOpenDHCEMRbrowse"){
			var JsonStr=$.m({
				ClassName:"DHCDoc.Util.Base",
				MethodName:"GetMenuInfoByName",
				MenuCode:"DHC.Seconde.DHCEMRbrowse"		//使用最新统一维护的菜单
			},false)
			if (JsonStr=="{}") return false;
			var JsonObj=JSON.parse(JsonStr);
			$.extend(Obj,JsonObj);
		}
		websys_emit(Flag,Obj);
	}
}
