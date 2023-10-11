/*
Description:����CDSS����ͳһ��װJS
Creator:WangQingyong
CreateDate:2021-12-15
�����ô�JS����:�������ơ����¼�롢ҽ��¼�롢��Ϣ������סԺҽ���б�������¼��סԺ����(websys.menugroup.csp)
 */
var CDSSObj={
    //ͬ��������Ϣ��CDSS(�л�����ʱ����)
    SynAdm:function(EpisodeID){ 
        return this.Send('INITIALIZE_PATIENT_INFORMATION',{MethodName:"GetPatInfo",EpisodeID:EpisodeID});
    },
    //������Ԥ��(�������ǰ����,�Բ��Ϲ����Ͻ�����ʾ)
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
                    $.messager.alert('��ʾ',$WarningTip.prop('outerHTML'),'warning');
                    CallBackFun(false);
                    return;
                }
                $WarningTip.empty();
                $.each(CDSSRet.PopWarn,function(){
                    $WarningTip.append('<dt>'+this.WarningSource+':</dt><dd style="margin-left:15px;">'+this.WarningTip+'</dd>');
                });
                if($WarningTip.children().length){
                    $.messager.confirm('��ʾ',$WarningTip.prop('outerHTML'),CallBackFun);
                }else{
                    CallBackFun(true);
                }
            }catch(e){
                CallBackFun(true);
            }
        });
	},
    //ͬ����ϸ�CDSS(ɾ���ͱ�����ϳɹ������)
    SynDiagnos:function(EpisodeID,DiagRowIdStr){
        return this.Send('SYNCHRONOUS_DIAGNOSTIC_INFORMATION',{MethodName:"GetDiagnosInfo", EpisodeID:EpisodeID,DiagRowIdStr:DiagRowIdStr});
    },
    //ҽ�����Ԥ��(����ҽ��ǰ����,�Բ��Ϲ��ҽ��������ʾ)
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
                    $.messager.alert('��ʾ',$WarningTip.prop('outerHTML'),'warning');
                    CallBackFun(false);
                    return;
                }
                $WarningTip.empty();
                $.each(CDSSRet.PopWarn,function(){
                    $WarningTip.append('<dt>'+this.WarningSource+':</dt><dd style="margin-left:15px;">'+this.WarningTip+'</dd>');
                });
                if($WarningTip.children().length){
                    $.messager.confirm('��ʾ',$WarningTip.prop('outerHTML'),CallBackFun);
                }else{
                    CallBackFun(true);
                }
            }catch(e){
                CallBackFun(true);
            }
        });
	},
    //ͬ��ҽ����CDSS(��ˡ����ϡ�ֹͣ�������ɹ������)
    SynOrder:function(EpisodeID,OrdItemStr){
        return this.Send('SYNCHRONIZE_PATIENT_ORDERS',{MethodName:"GetOrderInfo", EpisodeID:EpisodeID,OrdItemStr:OrdItemStr});
    },
    //ͬ�����뵥ҽ����CDSS(��������ʱ����)
    SynReqOrder:function(EpisodeID,ReqIDStr,Type){
        return this.Send('SYNCHRONIZE_PATIENT_ORDERS',{MethodName:"GetReqOrdInfo", EpisodeID:EpisodeID,ReqIDStr:ReqIDStr,Type:Type});
    },
    //ͬ�����뵥ҽ����CDSS(���뵥��������ҽ��ʱ����)
    SysReqItem:function(EpisodeID,ReqItmID,Type){
        return this.Send('SYNCHRONIZE_PATIENT_ORDERS',{MethodName:"GetReqItemInfo", EpisodeID:EpisodeID,ReqItmID:ReqItmID,Type:Type});
    },
    //ͬ��������¼��CDSS(���Ӻ�ɾ��������¼�ɹ������)
    SynAllergy:function(EpisodeID){
        return this.Send('ALLERGY_INFORMATION',{MethodName:"GetAllergyInfo", EpisodeID:EpisodeID});
    },
    //��дCDSS�Ƽ���������¼����(CopyDataForCDSS���������)
    AddDiagToList:function(copyCDSSData){
        try{
            if(!copyCDSSData) return;
            if(typeof copyCDSSData=='string') copyCDSSData=JSON.parse(decodeURIComponent(copyCDSSData));
            $.each(copyCDSSData,function(){
                var ICDRowid=this.ICDCode?tkMakeServerCall("DHCDoc.Interface.Inside.CDSS",'GetICDRowidByCode',this.ICDCode):'';
                if(ICDRowid==""){
                    $.messager.alert('��ʾ','HISϵͳ�����ڴ����:'+this.ICDCode);
                }else{
                    AddDiagItemtoList(ICDRowid,this.Note,this.CMFlag);
                }
            });
            this.RewriteUrl({copyCDSSData:""});
        }catch(e){
            debugger
        }
    },
    //��дCDSS�Ƽ�ҽ����ҽ��¼����(CopyDataForCDSS���������)
    AddOrdToList:function(copyCDSSData){
        try{
            if(!copyCDSSData) return;
            if(typeof copyCDSSData=='string') copyCDSSData=JSON.parse(decodeURIComponent(copyCDSSData));
            var newCDSSSData=new Array();
            $.each(copyCDSSData,function(){
                var itemArr=this.split("!");
                var ARCIMCode=itemArr[0];	//CDSS����������ҽ�������,��һ��ת��
                var ARCIMRowid=ARCIMCode?tkMakeServerCall("DHCDoc.Interface.Inside.CDSS",'GetARCIMRowidByCode',ARCIMCode):"";
                if(ARCIMRowid==""){
                    $.messager.alert('��ʾ','HISϵͳ�����ڴ�ҽ����:'+ARCIMCode);
                }else{
                    itemArr[0]=ARCIMRowid;
                    var Params=itemArr[2].split('^');
                    var OrderPrior=Params[5].split(String.fromCharCode(1))[0];   //CDSS������ֻ��ҽ���������� ��ҪȡID
                    var OrderPriorRowid=OrderPrior=='����ҽ��'?GlobalObj.LongOrderPriorRowid:GlobalObj.ShortOrderPriorRowid;
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
    //��ȡ��̨json�����뷢�͸�CDSS�����󹫹�����
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
    //��дurl,���url��copyCDSSData����ֹ�Ҽ��ظ�ˢ��
    RewriteUrl:function(ParamObj){
        if (typeof(history.pushState) === 'function') {
            var NewUrl=rewriteUrl(window.location.href, ParamObj);
            history.pushState("", "", NewUrl);
        }
    }
};
//CDSS��д���ݵ���
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
            case "DIAG":tabName="���¼��";break;
            case 'ORDER':tabName="ҽ��¼��";break;
            case 'CMORDER':tabName=tabId=='tabsReg'?"�в�ҩ¼��":"��ҩ¼��";break;
            default:break;
        }
        if(tabName){
            var tab=$('#'+tabId).tabs('getTab',tabName);
            var setTab=$('#'+tabId).tabs('getSelected');
            //��Щ��Ŀû�����þֲ�ˢ�£��ᵼ�»�дˢ�£������ǰѡ�е�ҳ����Ŀ���дҳ�� ֱ�ӵ���ҳ��Ļ�д����
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