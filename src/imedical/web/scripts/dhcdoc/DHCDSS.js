/*
Description:东华CDSS交互统一封装JS
Creator:WangQingyong
CreateDate:2021-12-15
已引用此JS界面:门诊诊疗、诊断录入、医嘱录入、信息总览、住院医嘱列表、过敏记录、住院诊疗(websys.menugroup.csp)
 */
var CDSSObj={
    //同步就诊信息给CDSS(切换病人时调用)
    SynAdm:function(EpisodeID){ 
        return this.Send('INITIALIZE_PATIENT_INFORMATION',{MethodName:"GetPatInfo",EpisodeID:EpisodeID});
    },
    //诊断阻断预警(保存诊断前调用,对不合规的诊断进行提示)
    CheckDiagnos:function(EpisodeID,DiagItemStr,CallBackFun){
	    return this.Send('CATCH_DIAG_WARNING',{MethodName:"GetDiagStrInfo", EpisodeID:EpisodeID,DiagItemStr:DiagItemStr},function(CDSSRet){
            try{
                if(!CDSSRet){
                    CallBackFun(true);
                    return;
                }
                var $WarningTip=$('<dl></dl>');
                $.each(CDSSRet.BlockWarn,function(){
                    $WarningTip.append('<dt>'+this.WarningSource+':</dt><dd style="margin-left:15px;">'+this.WarningTip+'</dd>');
                });
                if($WarningTip.children().length){
                    $.messager.alert('提示',$WarningTip.prop('outerHTML'),'warning');
                    CallBackFun(false);
                    return;
                }
                $WarningTip.empty();
                $.each(CDSSRet.PopWarn,function(){
                    $WarningTip.append('<dt>'+this.WarningSource+':</dt><dd style="margin-left:15px;">'+this.WarningTip+'</dd>');
                });
                if($WarningTip.children().length){
                    $.messager.confirm('提示',$WarningTip.prop('outerHTML'),CallBackFun);
                }else{
                    CallBackFun(true);
                }
            }catch(e){
                CallBackFun(true);
            }
        });
	},
    //同步诊断给CDSS(删除和保存诊断成功后调用)
    SynDiagnos:function(EpisodeID,DiagRowIdStr){
        return this.Send('SYNCHRONOUS_DIAGNOSTIC_INFORMATION',{MethodName:"GetDiagnosInfo", EpisodeID:EpisodeID,DiagRowIdStr:DiagRowIdStr});
    },
    //医嘱阻断预警(保存医嘱前调用,对不合规的医嘱进行提示)
    CheckOrder:function(EpisodeID,OrdItemStr,CallBackFun){
	    return this.Send('CATCH_ORDER_WARNING',{MethodName:"GetOrdItemStrInfo", EpisodeID:EpisodeID,OrdItemStr:OrdItemStr},function(CDSSRet){
            try{
                if(!CDSSRet){
                    CallBackFun(true);
                    return;
                }
                var $WarningTip=$('<dl></dl>');
                $.each(CDSSRet.BlockWarn,function(){
                    $WarningTip.append('<dt>'+this.WarningSource+':</dt><dd style="margin-left:15px;">'+this.WarningTip+'</dd>');
                });
                if($WarningTip.children().length){
                    $.messager.alert('提示',$WarningTip.prop('outerHTML'),'warning');
                    CallBackFun(false);
                    return;
                }
                $WarningTip.empty();
                $.each(CDSSRet.PopWarn,function(){
                    $WarningTip.append('<dt>'+this.WarningSource+':</dt><dd style="margin-left:15px;">'+this.WarningTip+'</dd>');
                });
                if($WarningTip.children().length){
                    $.messager.confirm('提示',$WarningTip.prop('outerHTML'),CallBackFun);
                }else{
                    CallBackFun(true);
                }
            }catch(e){
                CallBackFun(true);
            }
        });
	},
    //同步医嘱给CDSS(审核、作废、停止、撤销成功后调用)
    SynOrder:function(EpisodeID,OrdItemStr){
        return this.Send('SYNCHRONIZE_PATIENT_ORDERS',{MethodName:"GetOrderInfo", EpisodeID:EpisodeID,OrdItemStr:OrdItemStr});
    },
    //同步申请单医嘱给CDSS(发送申请时调用)
    SynReqOrder:function(EpisodeID,ReqIDStr,Type){
        return this.Send('SYNCHRONIZE_PATIENT_ORDERS',{MethodName:"GetReqOrdInfo", EpisodeID:EpisodeID,ReqIDStr:ReqIDStr,Type:Type});
    },
    //同步申请单医嘱给CDSS(申请单撤销单个医嘱时调用)
    SysReqItem:function(EpisodeID,ReqItmID,Type){
        return this.Send('SYNCHRONIZE_PATIENT_ORDERS',{MethodName:"GetReqItemInfo", EpisodeID:EpisodeID,ReqItmID:ReqItmID,Type:Type});
    },
    //同步过敏记录给CDSS(增加和删除过敏记录成功后调用)
    SynAllergy:function(EpisodeID){
        return this.Send('ALLERGY_INFORMATION',{MethodName:"GetAllergyInfo", EpisodeID:EpisodeID});
    },
    //回写CDSS推荐诊断至诊断录入表格(CopyDataForCDSS方法里调用)
    AddDiagToList:function(copyCDSSData){
        try{
            if(!copyCDSSData) return;
            if(typeof copyCDSSData=='string') copyCDSSData=JSON.parse(decodeURIComponent(copyCDSSData));
            $.each(copyCDSSData,function(){
                var ICDRowid=this.ICDCode?tkMakeServerCall("DHCDoc.Interface.Inside.CDSS",'GetICDRowidByCode',this.ICDCode):'';
                if(ICDRowid==""){
                    $.messager.alert('提示','HIS系统不存在此诊断:'+this.ICDCode);
                }else{
                    AddDiagItemtoList(ICDRowid,this.Note,this.CMFlag);
                }
            });
            this.RewriteUrl({copyCDSSData:""});
        }catch(e){
            debugger
        }
    },
    //回写CDSS推荐医嘱至医嘱录入表格(CopyDataForCDSS方法里调用)
    AddOrdToList:function(copyCDSSData){
        try{
            if(!copyCDSSData) return;
            if(typeof copyCDSSData=='string') copyCDSSData=JSON.parse(decodeURIComponent(copyCDSSData));
            var newCDSSSData=new Array();
            $.each(copyCDSSData,function(){
                var itemArr=this.split("!");
                var ARCIMCode=itemArr[0];	//CDSS传过来的是医嘱项代码,做一次转换
                var ARCIMRowid=ARCIMCode?tkMakeServerCall("DHCDoc.Interface.Inside.CDSS",'GetARCIMRowidByCode',ARCIMCode):"";
                if(ARCIMRowid==""){
                    $.messager.alert('提示','HIS系统不存在此医嘱项:'+ARCIMCode);
                }else{
                    itemArr[0]=ARCIMRowid;
                    var Params=itemArr[2].split('^');
                    var OrderPrior=Params[5].split(String.fromCharCode(1))[0];   //CDSS传过来只有医嘱类型描述 需要取ID
                    var OrderPriorRowid=OrderPrior=='长期医嘱'?GlobalObj.LongOrderPriorRowid:GlobalObj.ShortOrderPriorRowid;
                    Params[5]=OrderPrior+String.fromCharCode(1)+OrderPriorRowid;
                    itemArr[2]=Params.join('^');
                    newCDSSSData.push(itemArr.join("!"));
                }
            }); 
            if(newCDSSSData.length) AddCopyItemToList(newCDSSSData);
            this.RewriteUrl({copyCDSSData:""});
        }catch(e){
            debugger
        }
    },
    //获取后台json数据与发送给CDSS本对象公共方法
    Send:function(CDSSCode,MethodParamObj,CallBackFun){
        try{
            if(!websys_getMenuWin) return;
            var menuwin=websys_getMenuWin();
            if(menuwin.CopyDataToCDSS&&menuwin.DriverCDSS){
	            var DefaultMethObj={
	               	ClassName:"DHCDoc.Interface.Inside.CDSS",
	               	UserID:session['LOGON.USERID'],
	               	LogonLocID:session['LOGON.CTLOCID'],
	               	LogonHospID:session['LOGON.HOSPID']
	            };
                $.cm($.extend(DefaultMethObj,MethodParamObj),function(Data){
                    var CDSSRet=menuwin.CopyDataToCDSS(CDSSCode,Data);
                    if(CallBackFun) CallBackFun(CDSSRet);
                });
            }else{
                if(CallBackFun) CallBackFun();
            }
        }catch(e){
            debugger
            if(CallBackFun) CallBackFun();
        }
    },
    //重写url,清空url里copyCDSSData，防止右键重复刷新
    RewriteUrl:function(ParamObj){
        if (typeof(history.pushState) === 'function') {
            var NewUrl=rewriteUrl(window.location.href, ParamObj);
            history.pushState("", "", NewUrl);
        }
    }
};
//CDSS回写数据调用
function CopyDataForCDSS(type,JsonStr)
{
    try{
        if(typeof(switchTabByEMR)!='function') return;
        var tabId=null;
        $.each(['tabsReg','tabMenuFrame'],function(){
           if($('#'+this).size()){tabId=this; return false;}
        });
        if(!tabId) return;
        var tabName="";
        switch(type){
            case "DIAG":tabName="诊断录入";break;
            case 'ORDER':tabName="医嘱录入";break;
            case 'CMORDER':tabName=tabId=='tabsReg'?"中草药录入":"草药录入";break;
            default:break;
        }
        if(tabName){
            var tab=$('#'+tabId).tabs('getTab',tabName);
            var setTab=$('#'+tabId).tabs('getSelected');
            //有些项目没有配置局部刷新，会导致回写刷新；如果当前选中的页面是目标回写页面 直接调该页面的回写方法
            if(tab&&tab.children('iframe').size()&&(setTab.panel('options').id==tab.panel('options').id)){
                var CDSSObj=tab.children('iframe')[0].contentWindow['CDSSObj'];
                switch(type){
                    case "DIAG":CDSSObj.AddDiagToList(JsonStr);break;
                    case 'ORDER':CDSSObj.AddOrdToList(JsonStr);break;
                    case 'CMORDER':CDSSObj.AddOrdToList(JsonStr);break;
                    default:break;
                }
            }else{
                if(typeof JsonStr=='object') JsonStr=JSON.stringify(JsonStr);
                switchTabByEMR(tabName,{oneTimeValueExp:"copyCDSSData="+encodeURIComponent(JsonStr)});
            }
        }
        return;
    }catch(e){
        debugger
    }
}