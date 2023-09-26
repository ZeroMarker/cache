
 
//名称    DHCPENewDiagnosisHISUI.js
//功能    
//创建日期  
//创建人  yp

var UserId=session['LOGON.USERID'];
var CloseODSDivFlag="1";
var CurID="";
var EDWin;
var ResultWin;
var ReportWin;

$("#EpisodeID").val(EpisodeID);
$("#MainDoctor").val(MainDoctor);
$("#OnlyRead").val(OnlyRead);
$("#SSID").val(SSID);

/**
 * 重设Body的宽度
 * @param    {[int]}    flag [0 展开  1 折叠]
 * @Author   wangguoying
 * @DateTime 2019-09-04
 */
function setLayoutSize(flag){
    var dWidth=$(window).width();
    var parentLeft=$("#PersonPanel",window.parent.document);
    if(parentLeft.css("display")=="none") flag=1;   //防止父界面左侧折叠时，刷新iframe导致右侧空白
    var leftWidth=0;
    if(flag==1){
        leftWidth=15;
    }else{
        leftWidth=parentLeft.width()-5;
    }
    $("#BodyContent").width(dWidth-leftWidth);
    $("#BodyContent").layout("resize");
}


document.body.onload = BodyLoadHandler;

function BodyLoadHandler()
{
    setLayoutSize(0);
    var obj=document.getElementById("EpisodeID");
    if (obj) var EpisodeID=obj.value;
    
    var AuditInfo=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","GetAuditInfo",EpisodeID,SSID)
    
    //$("#AuditUser").combobox("setValue",AuditInfo.split("^")[0]);
    $("#AuditUser").val(AuditInfo.split("^")[0]);
    if($("#AuditUser").val()!=""){$("#AuditUser").attr('disabled',true);}
    $("#AuditDate").datebox("setValue",AuditInfo.split("^")[1]);
    if($("#AuditDate").datebox('getValue')!=""){$("#AuditDate").datebox("disable");}
    //$("#MainUser").combobox("setValue",AuditInfo.split("^")[2]);
    $("#MainUser").val(AuditInfo.split("^")[2]);
    if($("#MainUser").val()!=""){$("#MainUser").attr('disabled',true);}
    $("#MainDate").datebox("setValue",AuditInfo.split("^")[3]);
    if($("#MainDate").datebox('getValue')!=""){$("#MainDate").datebox("disable");}
    
    if(AuditInfo.split("^")[0]!="")
    {
        $('#Save').linkbutton('disable');
        $('#Auto').linkbutton('disable');
        $('#Cancel').linkbutton('enable');
    }
    else
    {
        $('#Cancel').linkbutton('disable');
        $('#Save').linkbutton('enable');
        $('#MainCancel').linkbutton('disable');
    }
    
    if(AuditInfo.split("^")[2]!="")
    {
        $('#MainSave').linkbutton('disable');
        $('#MainCancel').linkbutton('enable');
    }
    else
    {
        $('#MainCancel').linkbutton('disable');
        $('#MainSave').linkbutton('enable');
    }
    
    
    if((AuditInfo=="^^^")||(AuditInfo==""))
    {
        $('#MainSave').linkbutton('disable');
        $('#MainCancel').linkbutton('disable');
        
    }
    
    $("#Save").click(function() {
            
            Audit_click();  
            
        });
    $("#MainSave").click(function() {
            
            Audit_click();  
            
        });   
    $("#Auto").click(function() {
            
            SumResult_click();  
            
        });    
    $("#Report").click(function() {
            
            PreviewAllReport(); 
            
        });
        
    $("#Cancel").click(function() {
            
            StationSCancelSub();    
            
       });  
    $("#MainCancel").click(function() {
            
            StationSCancelSub();    
            
       });    
        
    SetAreaTextHeight();
    
    
   //初检提交
    var obj=document.getElementById(EpisodeID+"^Save");
    if (obj) obj.onclick=Audit_click;
    //重新总检
    var obj=document.getElementById(EpisodeID+"^Auto");
    if (obj) obj.onclick=SumResult_click;
    //取消体检
     var obj=document.getElementById(EpisodeID+"^Cancel");
    if (obj) obj.onclick=StationSCancelSub;
     var obj=document.getElementById(EpisodeID+"^Look");
    if (obj) obj.onclick=ShowResultLook_click;
    //历次结果
    var obj=document.getElementById(EpisodeID+"^History");
    if (obj) obj.onclick=GetContrastWithLast;
    //报告预览
    var obj=document.getElementById(EpisodeID+"^Report");
    if (obj) obj.onclick=PreviewReport;
    //建议保存
    var obj=document.getElementById(EpisodeID+"^SaveD");
    if (obj) obj.onclick=Save_click;
    //建议合并
    var obj=document.getElementById(EpisodeID+"^ShowUnite");
    if (obj) obj.onclick=ShowUnite_click;
    //高危
    var obj=document.getElementById(EpisodeID+"^HighRisk");
    if (obj) obj.onclick=HighRiskReport;
    //检查报告
    var obj=document.getElementById(EpisodeID+"^CheckResult");
    if (obj) obj.onclick=ShowCheckResult;
    //病理报告
    var obj=document.getElementById(EpisodeID+"^CheckPISResult");
    if (obj) obj.onclick=ShowCheckPISResult;
    //检查结论
    var obj=document.getElementById(EpisodeID+"^Conc");
    if (obj) obj.onclick=Conclusion;
    //质量上报
    var obj=document.getElementById(EpisodeID+"^QM");
    if (obj) obj.onclick=QMManager;
    //指引单预览
    var obj=document.getElementById(EpisodeID+"^PreviewDirect");
    if (obj) obj.onclick=PreviewDirect;
    //黏贴
    var obj=document.getElementById(EpisodeID+"^SendAudit");
    if (obj) obj.onclick=SendAudit;
    //全选建议
    var obj=document.getElementById(EpisodeID+"^Select");
    if (obj) obj.onclick=SelectAdvice;
    //复检提交
    var obj=document.getElementById(EpisodeID+"^SaveF");
    if (obj) obj.onclick=Audit_click;
    //取消复检
    var obj=document.getElementById(EpisodeID+"^CancelF");
    if (obj) obj.onclick=StationSCancelSub;
    //取消初检
    var obj=document.getElementById(EpisodeID+"^CancelC");
    if (obj) obj.onclick=StationSCancelSub;
    //保存建议
    var obj=document.getElementById(EpisodeID+"^SaveAP");
    if (obj) obj.onclick=SaveAdviceApp;
    
    var obj=document.getElementById("OnlyRead");
    if (obj) OnlyRead=obj.value;
    var ReloadFlag="N"
    var obj=document.getElementById("ReloadFlag");
    if (obj) ReloadFlag=obj.value;
    var MainDoctor="",AuditUser="";
    var obj=document.getElementById("MainDoctor");
    if (obj) MainDoctor=obj.value;
    var obj=document.getElementById("AuditUser");
    if (obj) AuditUser=obj.value;
    
    if ((OnlyRead!="Y")&&(ReloadFlag!="Y")&&(MainDoctor!="Y")&&(AuditUser=="")){
        //SumResult_click();
    }
    var obj=document.getElementById("SSID");
    if (obj) GSID=obj.value;
    var ObjArr=document.getElementsByName("DeleteButton");
    var ArrLength=ObjArr.length;    
    for (var i=0;i<ArrLength;i++)
    {
        var ID=ObjArr[i].id;
        var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetSSDiagnosisAdvice",ID);
        var arr=ret.split("^");
        
        var obj=document.getElementById(ID+"^JY");
        if (obj) obj.value=arr[0];
        var obj=document.getElementById(ID+"^JL");
        if (obj) obj.value=arr[1];
    
    }
    
    try{
        //alert(parent.frames("baseinfo"))
        if (parent.frames("baseinfo"))
        {
            setTimeout("SetParentFocues()",200)
        }
    }
    catch(e){
        //alert("catch")
    }
    //FormatAreaHeight();
}
function SetParentFocues()
{
    parent.frames["baseinfo"].websys_setfocus("RegNo");
}
//保存建议
   
function SaveAdviceApp(CloseFlag)
{
    var ObjArr=document.getElementsByName("DeleteButton");
    var ArrLength=ObjArr.length; 
    var Strings="",Remark="",OEItemId="",EDCRowId="";
    for (var i=0;i<ArrLength;i++)
    {
        var tr=ObjArr[i].parentNode.parentNode;
        var Sort=tr.rowIndex+1;
        var ID=ObjArr[i].id;
        var Advice="";
        var obj=document.getElementById(ID+"^JY");
        if (obj) Advice=obj.value;
        obj=document.getElementById('TReCheckz'+i);
        var ReCheck="N";
        var obj=document.getElementById(ID+"^MD");
        if(obj){
            if (obj.checked){ReCheck="Y" }
            else{
                /*
                if ((MainAuditFlag=="1")&&(confirm("第"+(i+1)+"行确实要删除吗")))
                {
                    ReCheck="N";
                }else{
                    ReCheck="Y";
                }
                */
            }
        }
        var DisplayDesc="";
        var obj=document.getElementById(ID+"^JL");
        if (obj) DisplayDesc=obj.value;
        //alert(Sort+"^"+DisplayDesc)
        if (Strings=="")
        {
            Strings=ID+"&&"+Remark+"&&"+Advice+"&&"+Sort+"&&"+EDCRowId+"&&"+OEItemId+"&&"+DisplayDesc+"&&"+ReCheck;
        }
        else
        {
            Strings=Strings+"^"+ID+"&&"+Remark+"&&"+Advice+"&&"+Sort+"&&"+EDCRowId+"&&"+OEItemId+"&&"+DisplayDesc+"&&"+ReCheck;
        }
    
    }
    //alert("Strings:"+Strings)
    if (Strings=="") {
        $.messager.alert("提示", "建议和结论为空!", "info");
        return false;
    }
    
    var MainDoctor="";
    var obj=document.getElementById("MainDoctor");
    if (obj) MainDoctor=obj.value;
    var flag=tkMakeServerCall("web.DHCPE.ResultDiagnosis","UpdateStationDRemark",Strings,MainDoctor)
    //alert("flag:"+flag)
    
    //var flag=cspRunServerMethod(encmeth,Strings,MainDoctor);
    var SaveSortInfo=""
    if (SaveSortInfo!=""){
        var GSID="";
        var obj=document.getElementById("GSID");
        if (obj) GSID=obj.value;
        var ret= tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","SaveSortInfo",GSID,SaveSortInfo);
    } 
    if (CloseFlag==0) return false;
      window.location.reload();
    if (opener){
        opener.location.reload();
    }
    window.returnValue=1;
    window.close();
}


//高危
function HighRiskReport()
{
    var iEpisodeID="";
    obj=document.getElementById("EpisodeID");
    if (obj) { iEpisodeID=obj.value; }
    
    var url="dhcpesendmessagenew.maindoctor.hisui.csp?PAADM="+iEpisodeID+"&OrderItemID=";
    websys_lu(url,false,'width=900,height=600,hisui=true,title=高危信息')
    
    
}

function PreviewAllReport()
{
    var iReportName="",iEpisodeID="";
    obj=document.getElementById("ReportNameBox");
    if (obj) { iReportName=obj.value; }
    obj=document.getElementById("EpisodeID");
    if (obj) { iEpisodeID=obj.value; }
    
    
    var NewVerReportFlag = tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",session['LOGON.CTLOCID'],"NewVerReport");
    //alert(NewVerReportFlag)
    //if (NewVerReportFlag == "Y") {
    
    if(NewVerReportFlag == "Word") {
        calPEReportProtocol("BPrintView",iEpisodeID);
    } else if (NewVerReportFlag == "Lodop") {
        PEPrintReport("V",iEpisodeID,"");
    } else {
        PEPrintReport("V",iEpisodeID,"");
    }
    /*
    var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no'
        +',left=0'
        +',top=0'
        +',width='+window.screen.availWidth
        +',height='+(window.screen.availHeight-40)
        ;
    var NewVerReportFlag=tkMakeServerCall("web.DHCPE.DHCPECommon","GetNewVerReport",session['LOGON.CTLOCID']);
    if(NewVerReportFlag=="Y"){
    /*---新版C/S体检报告--- 如使用标准功能，请将此段内代码注释* /  
            //calPEReportProtocol("BPrintView",iEpisodeID);
        PEPrintReport("V",iEpisodeID,""); //lodop+csp预览体检报告
        
        return false;
    }else{ 
        var lnk="dhcpeireport.normal.csp"+"?PatientID="+iEpisodeID;
        if (ReportWin) ReportWin.close();
        ReportWin=window.open(lnk,"ReportWin",nwin)
    }
    */
}
//外部协议打开体检报告程序 
function calPEReportProtocol(sourceID,jarPAADM){
    var opType=(sourceID=="BPrint"||sourceID=="NoCoverPrint")?"2":(sourceID=="BPrintView"?"5":"1");
    if(opType=="2"){
        jarPAADM=jarPAADM+"@"+session['LOGON.USERID'];
    }
    var saveType=sourceID=="BExportPDF"?"pdf":(sourceID=="BExportHtml"?"html":"word"); 
    var printType=sourceID=="NoCoverPrint"?"2":"1";
    location.href="PEReport://"+jarPAADM+":"+opType+":"+saveType+":"+printType
}

function ShowLocResult(e)
{
    
    
    var OEORDItemID=e.id;
    
    var url="dhcpenewoneresult.hisui.csp?OEORDItemID="+OEORDItemID;
    websys_lu(url,false,'width=700,height=400,hisui=true,title=结果明细')
    /*
    var content = '<iframe scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';

    $HUI.window("#LocResultWin",{
        title:"结果明细",
        collapsible:false,
        modal:true,
        width:600,
        height:400,
        content:content
    });
    */


    /*
    var OEORDItemID=e.id;
    var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENewOneResult&StationID=a&OEORDItemID="+OEORDItemID;
    
    var wwidth=550;
    var wheight=600; 
    var xposition = ((screen.width - wwidth) / 2)-20;
    var yposition = ((screen.height - wheight) / 2)-100;
    var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes'
            +',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
            ;
    if (ResultWin) ResultWin.close();
    ResultWin=window.open(url,"ResultWin",nwin)
    */
    //window.open(url,"_blank",nwin)
}
function SetAreaTextHeight()
{
    var objArr=document.getElementsByTagName("textarea");
    var objLength=objArr.length;
    for (var i=0;i<objLength;i++)
    {
        setTareaAutoHeight(objArr[i]);
    }
}
function FormatAreaHeight()
{
    var ObjArr=document.getElementsByName("DeleteButton");
    var ArrLength=ObjArr.length;
    for (var i=0;i<ArrLength;i++)
    {
        var ID=ObjArr[i].id;
        var JYObj=document.getElementById(ID+"^JY");
        var JLObj=document.getElementById(ID+"^JL");
        if (JYObj&&JLObj){
            if (JLObj.scrollHeight>JYObj.scrollHeight){
                JYObj.style.height=100+" px";
                //alert("a"+JYObj.style.height+"^"+JLObj.style.height)
            }else{
                JLObj.style.height=100+" px"
                //alert("b"+JYObj.style.height+"^"+JLObj.style.height)
            }
        }
    }
}
function Save_click()
{
    SaveNew_click(1)
}
function SaveNew_click(SaveFlag)
{
    
    var ObjArr=document.getElementsByName("DeleteButton");
    var ArrLength=ObjArr.length;    
    var Strings="",Remark="",OEItemId="",EDCRowId="";
    for (var i=0;i<ArrLength;i++)
    {
        var ID=ObjArr[i].id;
        var obj=document.getElementById(ID+"^Sort");
        var Sort=obj.innerText;
        var Advice="";
        var obj=document.getElementById(ID+"^JY");
        if (obj) Advice=obj.value;
        obj=document.getElementById('TReCheckz'+i);
        var ReCheck="N";
        var DisplayDesc="";
        var obj=document.getElementById(ID+"^JL");
        if (obj) DisplayDesc=obj.value;
        if (Strings=="")
        {
            Strings=ID+"&&"+Remark+"&&"+Advice+"&&"+Sort+"&&"+EDCRowId+"&&"+OEItemId+"&&"+DisplayDesc+"&&"+ReCheck;
        }
        else
        {
            Strings=Strings+"^"+ID+"&&"+Remark+"&&"+Advice+"&&"+Sort+"&&"+EDCRowId+"&&"+OEItemId+"&&"+DisplayDesc+"&&"+ReCheck;
        }
    
    }
    if (Strings=="") return false;
    
    var obj=document.getElementById("UpdateClass");
    if (obj) var encmeth=obj.value;
    var MainDoctor="";
    var obj=document.getElementById("MainDoctor");
    if (obj) MainDoctor=obj.value;
    //var flag=cspRunServerMethod(encmeth,Strings,MainDoctor)
    var flag=tkMakeServerCall("web.DHCPE.ResultDiagnosis","UpdateStationDRemark",Strings,MainDoctor)
    
    if (flag!=0){
        $.messager.alert("提示", flag, "info");
    }else{
        
        if(SaveFlag=="1") {
            $.messager.alert("提示", "保存成功！", "info");
            }
    }

return false;   
}
function DeleteAdvice(e,ConfirmFlag)
{
    if(ConfirmFlag==1){
        
        $.messager.confirm("提示", "确实要删除诊断意见吗?", function (r) {
                if (r) {
                    var ID=e.id;
                    var obj=document.getElementById("AddEDClass");
                    if (obj) var encmeth=obj.value;
                    if (ID=="") return false;
                    var SSID=ID.split("||")[0];
                    var MainDoctor="";
                    var obj=document.getElementById("MainDoctor");
                    if (obj) MainDoctor=obj.value;
                    var flag=tkMakeServerCall("web.DHCPE.ResultDiagnosis","UpdateSSDiagnosis",SSID,ID,"2",MainDoctor)
                    DeleteTableRow(e);
                    //window.location.reload();
                } else {
                    return false;
                }
            });
        
        
        
    }
    else
    {
        var ID=e.id;
        var obj=document.getElementById("AddEDClass");
        if (obj) var encmeth=obj.value;
        if (ID=="") return false;
        var SSID=ID.split("||")[0];
        var MainDoctor="";
        var obj=document.getElementById("MainDoctor");
        if (obj) MainDoctor=obj.value;
        var flag=tkMakeServerCall("web.DHCPE.ResultDiagnosis","UpdateSSDiagnosis",SSID,ID,"2",MainDoctor)
        DeleteTableRow(e);
        //window.location.reload();
    }
}
function DeleteTableRow(e)
{
    var Rows=e.parentNode.parentNode.rowIndex;
    //var TableObj=document.getElementById("EditAdvice");
    var TableObj=e.parentNode.parentNode.parentNode;
    TableObj.deleteRow(Rows);

}
function PreviewReport()
{
    var obj;
    var iReportName="",iEpisodeID="";
    obj=document.getElementById("ReportNameBox");
    if (obj) { iReportName=obj.value; }
    obj=document.getElementById("EpisodeID");
    if (obj) { iEpisodeID=obj.value; }
    
    var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no'
        +',left=0'
        +',top=0'
        +',width='+window.screen.availWidth
        +',height='+window.screen.availHeight
        ;
    var lnk=iReportName+"?PatientID="+iEpisodeID; //+"&OnlyAdvice=Y";
    open(lnk,"_blank",nwin);
    return false;
}
function GetContrastWithLast()
{
    var obj;
    var iEpisodeID="";
    obj=document.getElementById("EpisodeID");
    if (obj) { iEpisodeID=obj.value; }
    //alert(iEpisodeID)
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEContrastWithLast"
            +"&PAADM="+iEpisodeID
    
        var wwidth=1000;
    var wheight=600; 
    var xposition = (screen.width - wwidth) / 2;
    var yposition = (screen.height - wheight) / 2;
    var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes'
            +',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
            ;
    window.open(lnk,"_blank",nwin)  
    //return true;
    return false;
}
function SumResult_click()
{
    
    var Type=0
    obj=document.getElementById("SSID");
    if (obj) var SSID=obj.value;
    if (SSID!="")
    {
        
        
        
        $.messager.confirm("提示", "已经有审核纪录,更新原来的吗?", function (r) {
            if (r) {
                var Type=1;
                
                obj=document.getElementById("EpisodeID");
                if (obj) var PAADM=obj.value;
                if (PAADM=="") return false;
                obj=document.getElementById("IsCanSumResult");
                if (obj) var encmeth=obj.value;
                var flag=tkMakeServerCall("web.DHCPE.ResultDiagnosis","IsCanSumResult",PAADM)
                var values=flag.split("^");
                flag=values[0];
                if (flag!=0)
                {
                    
                    if(flag=="HadNoApp") { flag="有未检查项目" ;} 
                    if(flag=="NoItem"){ flag="没有要总检的项目" ;} 
                    if(flag=="NoSub"){flag="未提交";}
                    
                    $.messager.confirm("提示", values[1]+flag+",是否继续总检?", function (r) {
                            if (r) {
                                obj=document.getElementById("SumResultBox");
                                if (obj) var encmeth=obj.value;
                                var Remark=""
                                var flag=tkMakeServerCall("web.DHCPE.ResultDiagnosis","UpdateStationS",PAADM,Type,Remark)
                                
                                var values=flag.split("^");
                                
                                flag=values[0];
                                if (flag==0)
                                {
                                    window.location.reload();
                                    return false;
                                }
                                $.messager.alert("提示", values[1]+flag, "info");
                                return false;
                            } else {
                                return false;
                            }
                    });
        
        
        
                }
                else
                {
                                obj=document.getElementById("SumResultBox");
                                if (obj) var encmeth=obj.value;
                                var Remark=""
                                var flag=tkMakeServerCall("web.DHCPE.ResultDiagnosis","UpdateStationS",PAADM,Type,Remark)
                                
                                var values=flag.split("^");
                                
                                flag=values[0];
                                if (flag==0)
                                {
                                    window.location.reload();
                                    return false;
                                }
                                $.messager.alert("提示", values[1]+flag, "info");
                                return false;
                    
                }
                
            } else {
                return false;
            }
        });
        
        
    }
    else
    {
                obj=document.getElementById("EpisodeID");
                if (obj) var PAADM=obj.value;
                
                if (PAADM=="") return false;
                obj=document.getElementById("IsCanSumResult");
                if (obj) var encmeth=obj.value;
                var flag=tkMakeServerCall("web.DHCPE.ResultDiagnosis","IsCanSumResult",PAADM)
                var values=flag.split("^");
                flag=values[0];
                
                if (flag!=0)
                {
                    
                    if(flag=="HadNoApp") { flag="有未检查项目" ;} 
                    if(flag=="NoItem"){ flag="没有要总检的项目" ;} 
                    if(flag=="NoSub"){flag="未提交";}
                    
                    $.messager.confirm("提示", values[1]+flag+",是否继续总检?", function (r) {
                            if (r) {
                                obj=document.getElementById("SumResultBox");
                                if (obj) var encmeth=obj.value;
                                var Remark=""
                                var flag=tkMakeServerCall("web.DHCPE.ResultDiagnosis","UpdateStationS",PAADM,Type,Remark)
                                
                                var values=flag.split("^");
                                
                                flag=values[0];
                                if (flag==0)
                                {
                                    window.location.reload();
                                    return false;
                                }
                                $.messager.alert("提示", values[1]+flag, "info");
                                return false;
                            } else {
                                return false;
                            }
                    });
        
        
        
                }
                else
                {
                    
                                obj=document.getElementById("SumResultBox");
                                if (obj) var encmeth=obj.value;
                                var Remark=""
                                var flag=tkMakeServerCall("web.DHCPE.ResultDiagnosis","UpdateStationS",PAADM,Type,Remark)
                                
                                var values=flag.split("^");
                                
                                flag=values[0];
                                if (flag==0)
                                {
                                    window.location.reload();
                                    return false;
                                }
                                $.messager.alert("提示", values[1]+flag, "info");
                                return false;
                    
                    
                }
        
    }
    
    
}
function SelectAdvice()
{
    var objArr=document.getElementsByName("MainFlag");
    for (var i=0;i<objArr.length;i++)
    {
        objArr[i].checked=true;
    }
    return false;
}
function SaveAdvice(AlertFlag)
{
    //Save_click();
    SaveNew_click(0)
    var SaveInfo="";
    var NoUseInfo=""
    var objArr=document.getElementsByName("MainFlag");
    var ArrLength=objArr.length;
    for (var i=0;i<objArr.length;i++)
    {
        if (objArr[i].checked){
            if (SaveInfo==""){
                SaveInfo=objArr[i].id;
            }else{
                SaveInfo=SaveInfo+"^"+objArr[i].id;
            }
        }else{
            if (NoUseInfo==""){
                NoUseInfo=objArr[i].id;
            }else{
                NoUseInfo=NoUseInfo+"^"+objArr[i].id;
            }
        }
    }
    /*
    if (SaveInfo==""){
            if (AlertFlag=="1") alert("没有选择建议,不能保存.");
            return false;
    }*/
    if ((SaveInfo=="")&&(ArrLength=="0")){
        if (!confirm("没有建议,是否继续提交?")) return false;
        
    }
    
    if ((SaveInfo=="")&&(ArrLength!="0")){
            if (AlertFlag=="1") 
            {
                $.messager.alert("提示", "没有选择建议,不能保存!", "info");
                return false;
            }
    }
    if (AlertFlag=="1"){
        if (NoUseInfo!=""){
            if (!confirm("有没选中的建议,是否继续?")) return false;
        }
    }

    
    var encmeth="";
    var obj=document.getElementById("SaveMainCheckClass");
    if (obj) encmeth=obj.value;
    
    //var ret=cspRunServerMethod(encmeth,SaveInfo,NoUseInfo,UserId);
    var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","SaveMainCheck",SaveInfo,NoUseInfo,UserId)
    
    return ret;
}
function ShowResult_click(SaveFlag)
{
    var obj,GSID="",MainDoctor="";
    var UserID=session['LOGON.USERID'];
    var GSID=tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetSSId",EpisodeID)
    
    var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","CreateGSIDetail",GSID,UserID)
    obj=document.getElementById("MainDoctor");
    if (obj) MainDoctor=obj.value;
    
    var url="dhcpenewgssdetail.hisui.csp?GSID="+GSID+"&ButtonFlag="+SaveFlag+"&MainDoctor="+MainDoctor;
    var content = '<iframe id="gssdetailframe" scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:99%;"></iframe>';

    
    
    $HUI.window("#GSSDetailWin",{
        title:"建议明细",
        collapsible:false,
        minimizable:false,
        iconCls:"icon-write-order",
        modal:true,
        content:content,
        onClose:function(){
            
            var ret=$('#gssdetailframe').contents().find('#CloseFlag').val();
            if(ret>0)
            {
            
                var flag=tkMakeServerCall("web.DHCPE.ResultDiagnosis","AuditStationS",EpisodeID,"Submit","0",MainDoctor);
                
                if (flag=="0")
                {
                    window.location.reload();
                    return false;
                }
                if(flag=="NoAudit"){alert("初审未提交")}
                //alert(flag);
            }
            else
            {
             return false;  
                
            }
            
            }
    });
    
    
    
    return ret;
    
    /*
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENewGSSDetail&GSID="+GSID+"&ButtonFlag="+SaveFlag;
    var  iWidth=1000; //模态窗口宽度
    var  iHeight=700;//模态窗口高度
    var  iTop=(window.screen.height-iHeight)/2;
    var  iLeft=(window.screen.width-iWidth)/2;
    var ret=window.showModalDialog(lnk, "", "dialogwidth:1000px;dialogheight:600px;center:1"); 
    //var ret=window.open(lnk, "", "");
    if(!ret){
               ret=window.returnValue;
            }
    
    
    return ret;
    */
    
}
function ShowResultLook_click()
{
    var obj,GSID="",MainDoctor="";
    obj=document.getElementById("SSID");
    if (obj) GSID=obj.value;
    //alert(GSID)
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENewGSSDetail&GSID="+GSID+"&ButtonFlag="+0;
    var  iWidth=1000; //模态窗口宽度
    var  iHeight=700;//模态窗口高度
    var  iTop=(window.screen.height-iHeight)/2;
    var  iLeft=(window.screen.width-iWidth)/2;
    var ret=window.showModalDialog(lnk, "", "dialogwidth:1000px;dialogheight:600px;center:1"); 
    //var ret=window.open(lnk, "", "");
    if(!ret){
               ret=window.returnValue;
            }
    
    return false;
}

function ShowUnite_click()
{    
    var MainDoctor="";
    var obj=document.getElementById("MainDoctor");
    if (obj) MainDoctor=obj.value;
    
    if (MainDoctor=="Y"){
        //复检保存建议
        var ret=SaveAdvice("0");
        //if (!ret) return false;
    }else{
        //保存建议
        SaveNew_click(0)
        //Save_click();
    }
    
    //Save_click();
    ModifyAdviceApp("");
    return false;
}
function ModifyAdvice(e)
{
    var ret=ModifyAdviceApp(e.id)
}

function AllSelectAdvice()
{
    var objArr=document.getElementsByName("SelectAdvice");
    var objLength=objArr.length;
    
    var SaveInfo="",NoUseInfo=""
    for (var i=0;i<objArr.length;i++)
    {
    
    
        if (objArr[i].checked){
            if (SaveInfo==""){
                SaveInfo=objArr[i].id.split("^")[0];
            }else{
                SaveInfo=SaveInfo+"^"+objArr[i].id.split("^")[0];
            }
        }else{
            if (NoUseInfo==""){
                NoUseInfo=objArr[i].id.split("^")[0];
            }else{
                NoUseInfo=NoUseInfo+"^"+objArr[i].id.split("^")[0];
            }
        }
    }
    
    var UserID=session['LOGON.USERID'];
    var flag=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","SaveMainCheck",SaveInfo,NoUseInfo,UserID);
    
    return false;
}


function ModifyAdviceApp(StationID)
{
    var obj,GSID="",MainDoctor="";
    obj=document.getElementById("SSID");
    if (obj) GSID=obj.value;
    var GSID=tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetSSId",EpisodeID)
    obj=document.getElementById("MainDoctor");
    if (obj) MainDoctor=obj.value;
    
    
    var url="dhcpeneweditadvice.hisui.csp?GSID="+GSID+"&StationID="+StationID+"&MainDoctor="+MainDoctor+"&StationID="+StationID;
    
    var content = '<iframe scrolling="auto" frameborder="0" src="'+url+'" style="width:100%;height:100%;"></iframe>';

    
    
    $HUI.window("#EditAdviceWin",{
        title:"合并建议",
        collapsible:false,
        minimizable:false,
        modal:true,
        width:800,
        height:600,
        content:content
    });
    /*
    var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENewEditAdvice&GSID="+GSID+"&StationID="+StationID+"&MainDoctor="+MainDoctor;
    var  iWidth=800; //模态窗口宽度
    var  iHeight=600;//模态窗口高度
    var  iTop=(window.screen.height-iHeight)/2;
    var  iLeft=(window.screen.width-iWidth)/2;
    
    var wwidth=800;
    var wheight=600;
    var xposition = (screen.width - wwidth) / 2;
    var yposition = (screen.height - wheight) / 2;
    var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
            +'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
            ;
    //var ret=window.showModalDialog(url, "", "dialogwidth:800px;dialogheight:600px;center:1"); 
    
    var cwin=window.open(url,"_blank",nwin) 
    
    return false;
    
    if (StationID!=""){
        var obj=document.getElementById("GetAdviceByStation");
        if (obj) encmeth=obj.value;
        //GSID,CurStation,MainDoctorFlag
        var ret=cspRunServerMethod(encmeth,GSID,StationID,MainDoctor,"Y");
        var Arr=ret.split("^");
        var ID=Arr[0];
        var Info=Arr[1];
        var obj=document.getElementById(ID);
        if (obj) obj.innerHTML=Info;
    }else{
        //var objArr=document.getElementsByName("StationAdvice");
        window.location.reload();
    }
    if(ret!=1){
        return false;
    }
    //if (StationID!="") window.location.reload();
    
    return true;
    */
}
function Audit_click()
{
    
    var MainDoctor="";
    var obj=document.getElementById("MainDoctor");
    if (obj) MainDoctor=obj.value;
    if (MainDoctor=="Y"){
        //复检保存建议
        
        
        //Save_click();
        SaveNew_click(0)
        var SaveInfo="";
        var NoUseInfo=""
        var objArr=document.getElementsByName("MainFlag");
        var ArrLength=objArr.length;
        for (var i=0;i<objArr.length;i++)
        {
            if (objArr[i].checked){
                if (SaveInfo==""){
                    SaveInfo=objArr[i].id;
                }else{
                    SaveInfo=SaveInfo+"^"+objArr[i].id;
                }
            }else{
                if (NoUseInfo==""){
                    NoUseInfo=objArr[i].id;
                }else{
                    NoUseInfo=NoUseInfo+"^"+objArr[i].id;
                }
            }
        }
        /*
        if (SaveInfo==""){
                if (AlertFlag=="1") alert("没有选择建议,不能保存.");
                return false;
        }*/
        if ((SaveInfo=="")&&(ArrLength=="0")){
            
            $.messager.confirm("提示", "没有建议,是否继续提交?", function (r) {
                if (r) {
                    
        
                        var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","SaveMainCheck",SaveInfo,NoUseInfo,UserId)
                        

                        if (!ret) return false;
                        
                        obj=document.getElementById("EpisodeID");
                        if (obj) var PAADM=obj.value;
                        
                        //判断是否存在与性别不一致的关键字
                        var SelectMark=""
                        var SelectMark=tkMakeServerCall("web.DHCPE.ReportGetInfor","SelectMarkDesc",PAADM);
                        if(SelectMark!=""){
                            if (!confirm("存在与性别不一致关键字: "+SelectMark+" ,是否继续?")) return false;
                            
                            }

                        //判断是否有没有结果的项目
                        obj=document.getElementById("NoResultItemClass");
                        if (obj) var encmeth=obj.value;
                        //var ret=cspRunServerMethod(encmeth,PAADM);
                        var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","GetNoResultItem",PAADM);
                        if (ret!=""){
                            var Char_1=String.fromCharCode(1);
                            var NoResultArr=ret.split(Char_1);
                            var NoResultDesc=NoResultArr[1];
                            
                            
                            $.messager.confirm("提示", "存在未完成的项目'"+NoResultDesc+"'是否把该项目放弃？", function (r) {
                                if (r) {
                                    //处理是否放弃
                                    var NoResultIDs=NoResultArr[0];
                                    obj=document.getElementById("RefuseItems");
                                    if (obj) var encmeth=obj.value;
                                    //var ret=cspRunServerMethod(encmeth,NoResultIDs);
                                    var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","RefuseItems",NoResultIDs);
                                    
                                    
                                    // 自动插入会诊费
                        
                                    if (MainDoctor=="N"){
                                        var CurLocID=session['LOGON.CTLOCID'];
                                        var ConRet=tkMakeServerCall("web.DHCPE.OtherPatientToHP","InsertConOrder",PAADM,"",UserId,UserId,CurLocID)
                                        var ConArr=ConRet.split("^");
                                        if (ConArr[0]=="-1"){
                                            alert(ConArr[1]);
                                            return false;
                                        }else if (ConArr[0]=="-2"){
                                            if (!confirm(ConArr[1]+",是否继续?")) return false;
                                        }
                                    }
                                    //if (!ModifyAdviceApp("")) return false;
                                    /* 生成总的建议提到审核之前  wgy*/
                                    var obj=document.getElementById("CreateGSSDetail");
                                    if (obj) var encmeth=obj.value;
                                    //obj=document.getElementById("SSID");
                                    //if (obj) GSID=obj.value;
                                     var GSID=tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetSSId",PAADM)
                                     if(GSID==""){
                                        return false;
                                        }

                                    //var ret=cspRunServerMethod(encmeth,GSID,MainDoctor);
                                    var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","CreateGSSDetail",GSID,MainDoctor);
                                    var ret=ShowResult_click(1);
                                    
                                    /*end*/
                                    
                                    
                                    return false;
                                    
                                    
                                    
                                    
                                } else {
                                    // 自动插入会诊费
                        
                                    if (MainDoctor=="N"){
                                        var CurLocID=session['LOGON.CTLOCID'];
                                        var ConRet=tkMakeServerCall("web.DHCPE.OtherPatientToHP","InsertConOrder",PAADM,"",UserId,UserId,CurLocID)
                                        var ConArr=ConRet.split("^");
                                        if (ConArr[0]=="-1"){
                                            alert(ConArr[1]);
                                            return false;
                                        }else if (ConArr[0]=="-2"){
                                            if (!confirm(ConArr[1]+",是否继续?")) return false;
                                        }
                                    }
                                    //if (!ModifyAdviceApp("")) return false;
                                    /* 生成总的建议提到审核之前  wgy*/
                                    var obj=document.getElementById("CreateGSSDetail");
                                    if (obj) var encmeth=obj.value;
                                    //obj=document.getElementById("SSID");
                                    //if (obj) GSID=obj.value;
                                     var GSID=tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetSSId",PAADM)
                                     if(GSID==""){
                                        return false;
                                        }

                                    //var ret=cspRunServerMethod(encmeth,GSID,MainDoctor);
                                    var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","CreateGSSDetail",GSID,MainDoctor);
                                    var ret=ShowResult_click(1);
                                    
                                    /*end*/
                                    return false;
                                }
                            });
                            
                            
                            
                            
                            
                        }
                        
                        else
                        {
                                    // 自动插入会诊费
                        
                                    if (MainDoctor=="N"){
                                        var CurLocID=session['LOGON.CTLOCID'];
                                        var ConRet=tkMakeServerCall("web.DHCPE.OtherPatientToHP","InsertConOrder",PAADM,"",UserId,UserId,CurLocID)
                                        var ConArr=ConRet.split("^");
                                        if (ConArr[0]=="-1"){
                                            alert(ConArr[1]);
                                            return false;
                                        }else if (ConArr[0]=="-2"){
                                            if (!confirm(ConArr[1]+",是否继续?")) return false;
                                        }
                                    }
                                    //if (!ModifyAdviceApp("")) return false;
                                    /* 生成总的建议提到审核之前  wgy*/
                                    var obj=document.getElementById("CreateGSSDetail");
                                    if (obj) var encmeth=obj.value;
                                    //obj=document.getElementById("SSID");
                                    //if (obj) GSID=obj.value;
                                     var GSID=tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetSSId",PAADM)
                                     if(GSID==""){
                                        return false;
                                        }

                                    //var ret=cspRunServerMethod(encmeth,GSID,MainDoctor);
                                    var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","CreateGSSDetail",GSID,MainDoctor);
                                    var ret=ShowResult_click(1);
                                    
                                    /*end*/
                                    
                                    
                                    return false;
                            
                            
                            
                        }
                        
                        
                        
                        
                } else {
                        return false;
                }
            });
            
            
            
            
        }
        
        else if ((SaveInfo=="")&&(ArrLength!="0")){
            $.messager.alert("提示", "没有选择建议,不能保存!", "info");
            return false;
        }
        
        else
        {
            var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","SaveMainCheck",SaveInfo,NoUseInfo,UserId)
                        
            if (!ret) return false;
            if (NoUseInfo!=""){
                $.messager.confirm("提示", "有没选中的建议,是否继续?", function (r) {
                    if (r) {
                        var obj=document.getElementById("EpisodeID");
                        if (obj) var PAADM=obj.value;
                        
                        //判断是否存在与性别不一致的关键字
                        var SelectMark=""
                        var SelectMark=tkMakeServerCall("web.DHCPE.ReportGetInfor","SelectMarkDesc",PAADM);
                        if(SelectMark!=""){
                            if (!confirm("存在与性别不一致关键字: "+SelectMark+" ,是否继续?")) return false;
                            
                            }

                        //判断是否有没有结果的项目
                        obj=document.getElementById("NoResultItemClass");
                        if (obj) var encmeth=obj.value;
                        //var ret=cspRunServerMethod(encmeth,PAADM);
                        var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","GetNoResultItem",PAADM);
                        if (ret!=""){
                            var Char_1=String.fromCharCode(1);
                            var NoResultArr=ret.split(Char_1);
                            var NoResultDesc=NoResultArr[1];
                            
                            
                            $.messager.confirm("提示", "存在未完成的项目'"+NoResultDesc+"'是否把该项目放弃?", function (r) {
                                if (r) {
                                    //处理是否放弃
                                    var NoResultIDs=NoResultArr[0];
                                    obj=document.getElementById("RefuseItems");
                                    if (obj) var encmeth=obj.value;
                                    //var ret=cspRunServerMethod(encmeth,NoResultIDs);
                                    var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","RefuseItems",NoResultIDs);
                                    
                                    
                                    // 自动插入会诊费
                        
                                    if (MainDoctor=="N"){
                                        var CurLocID=session['LOGON.CTLOCID'];
                                        var ConRet=tkMakeServerCall("web.DHCPE.OtherPatientToHP","InsertConOrder",PAADM,"",UserId,UserId,CurLocID)
                                        var ConArr=ConRet.split("^");
                                        if (ConArr[0]=="-1"){
                                            alert(ConArr[1]);
                                            return false;
                                        }else if (ConArr[0]=="-2"){
                                            if (!confirm(ConArr[1]+",是否继续?")) return false;
                                        }
                                    }
                                    //if (!ModifyAdviceApp("")) return false;
                                    /* 生成总的建议提到审核之前  wgy*/
                                    var obj=document.getElementById("CreateGSSDetail");
                                    if (obj) var encmeth=obj.value;
                                    //obj=document.getElementById("SSID");
                                    //if (obj) GSID=obj.value;
                                     var GSID=tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetSSId",PAADM)
                                     if(GSID==""){
                                        return false;
                                        }

                                    //var ret=cspRunServerMethod(encmeth,GSID,MainDoctor);
                                    var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","CreateGSSDetail",GSID,MainDoctor);
                                    var ret=ShowResult_click(1);
                                    
                                    /*end*/
                                    
                                    
                                    return false;
                                    
                                    
                                    
                                    
                                } else {
                                    // 自动插入会诊费
                
                                    if (MainDoctor=="N"){
                                        var CurLocID=session['LOGON.CTLOCID'];
                                        var ConRet=tkMakeServerCall("web.DHCPE.OtherPatientToHP","InsertConOrder",PAADM,"",UserId,UserId,CurLocID)
                                        var ConArr=ConRet.split("^");
                                        if (ConArr[0]=="-1"){
                                            alert(ConArr[1]);
                                            return false;
                                        }else if (ConArr[0]=="-2"){
                                            if (!confirm(ConArr[1]+",是否继续?")) return false;
                                        }
                                    }
                                    //if (!ModifyAdviceApp("")) return false;
                                    /* 生成总的建议提到审核之前  wgy*/
                                    var obj=document.getElementById("CreateGSSDetail");
                                    if (obj) var encmeth=obj.value;
                                    //obj=document.getElementById("SSID");
                                    //if (obj) GSID=obj.value;
                                     var GSID=tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetSSId",PAADM)
                                     if(GSID==""){
                                        return false;
                                        }

                                    //var ret=cspRunServerMethod(encmeth,GSID,MainDoctor);
                                    var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","CreateGSSDetail",GSID,MainDoctor);
                                    var ret=ShowResult_click(1);
                                    
                                    /*end*/
                                    
                                    
                                    return false;
                                }
                            });
                            
                            
                        }
                        else
                        {
                            // 自动插入会诊费
                        
                            if (MainDoctor=="N"){
                                var CurLocID=session['LOGON.CTLOCID'];
                                var ConRet=tkMakeServerCall("web.DHCPE.OtherPatientToHP","InsertConOrder",PAADM,"",UserId,UserId,CurLocID)
                                var ConArr=ConRet.split("^");
                                if (ConArr[0]=="-1"){
                                    alert(ConArr[1]);
                                    return false;
                                }else if (ConArr[0]=="-2"){
                                    if (!confirm(ConArr[1]+",是否继续?")) return false;
                                }
                            }
                            //if (!ModifyAdviceApp("")) return false;
                            /* 生成总的建议提到审核之前  wgy*/
                            var obj=document.getElementById("CreateGSSDetail");
                            if (obj) var encmeth=obj.value;
                            //obj=document.getElementById("SSID");
                            //if (obj) GSID=obj.value;
                             var GSID=tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetSSId",PAADM)
                             if(GSID==""){
                                return false;
                                }

                            //var ret=cspRunServerMethod(encmeth,GSID,MainDoctor);
                            var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","CreateGSSDetail",GSID,MainDoctor);
                            var ret=ShowResult_click(1);
                            
                            /*end*/
                            
                            
                            return false;
                            
                            
                        }
                        
                    } else {
                        return false;
                    }
                });
                
            }
            else
            {
            
            
                var obj=document.getElementById("EpisodeID");
                if (obj) var PAADM=obj.value;
                
                //判断是否存在与性别不一致的关键字
                var SelectMark=""
                var SelectMark=tkMakeServerCall("web.DHCPE.ReportGetInfor","SelectMarkDesc",PAADM);
                if(SelectMark!=""){
                    if (!confirm("存在与性别不一致关键字: "+SelectMark+" ,是否继续?")) return false;
                    
                    }

                //判断是否有没有结果的项目
                obj=document.getElementById("NoResultItemClass");
                if (obj) var encmeth=obj.value;
                //var ret=cspRunServerMethod(encmeth,PAADM);
                var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","GetNoResultItem",PAADM);
                if (ret!=""){
                    var Char_1=String.fromCharCode(1);
                    var NoResultArr=ret.split(Char_1);
                    var NoResultDesc=NoResultArr[1];
                    
                    
                    $.messager.confirm("提示", "存在未完成的项目'"+NoResultDesc+"'是否把该项目放弃?", function (r) {
                        if (r) {
                            //处理是否放弃
                            var NoResultIDs=NoResultArr[0];
                            obj=document.getElementById("RefuseItems");
                            if (obj) var encmeth=obj.value;
                            //var ret=cspRunServerMethod(encmeth,NoResultIDs);
                            var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","RefuseItems",NoResultIDs);
                            
                            
                            // 自动插入会诊费
                
                            if (MainDoctor=="N"){
                                var CurLocID=session['LOGON.CTLOCID'];
                                var ConRet=tkMakeServerCall("web.DHCPE.OtherPatientToHP","InsertConOrder",PAADM,"",UserId,UserId,CurLocID)
                                var ConArr=ConRet.split("^");
                                if (ConArr[0]=="-1"){
                                    alert(ConArr[1]);
                                    return false;
                                }else if (ConArr[0]=="-2"){
                                    if (!confirm(ConArr[1]+",是否继续?")) return false;
                                }
                            }
                            //if (!ModifyAdviceApp("")) return false;
                            /* 生成总的建议提到审核之前  wgy*/
                            var obj=document.getElementById("CreateGSSDetail");
                            if (obj) var encmeth=obj.value;
                            //obj=document.getElementById("SSID");
                            //if (obj) GSID=obj.value;
                             var GSID=tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetSSId",PAADM)
                             if(GSID==""){
                                return false;
                                }

                            //var ret=cspRunServerMethod(encmeth,GSID,MainDoctor);
                            var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","CreateGSSDetail",GSID,MainDoctor);
                            var ret=ShowResult_click(1);
                            
                            /*end*/
                            
                            
                            return false;
                            
                            
                            
                            
                        } else {
                            // 自动插入会诊费
                
                            if (MainDoctor=="N"){
                                var CurLocID=session['LOGON.CTLOCID'];
                                var ConRet=tkMakeServerCall("web.DHCPE.OtherPatientToHP","InsertConOrder",PAADM,"",UserId,UserId,CurLocID)
                                var ConArr=ConRet.split("^");
                                if (ConArr[0]=="-1"){
                                    alert(ConArr[1]);
                                    return false;
                                }else if (ConArr[0]=="-2"){
                                    if (!confirm(ConArr[1]+",是否继续?")) return false;
                                }
                            }
                            //if (!ModifyAdviceApp("")) return false;
                            /* 生成总的建议提到审核之前  wgy*/
                            var obj=document.getElementById("CreateGSSDetail");
                            if (obj) var encmeth=obj.value;
                            //obj=document.getElementById("SSID");
                            //if (obj) GSID=obj.value;
                             var GSID=tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetSSId",PAADM)
                             if(GSID==""){
                                return false;
                                }

                            //var ret=cspRunServerMethod(encmeth,GSID,MainDoctor);
                            var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","CreateGSSDetail",GSID,MainDoctor);
                            var ret=ShowResult_click(1);
                            
                            /*end*/
                            
                            
                            return false;
                        }
                    });
                    
                    
                }
                else
                {
                    // 自动插入会诊费
                
                    if (MainDoctor=="N"){
                        var CurLocID=session['LOGON.CTLOCID'];
                        var ConRet=tkMakeServerCall("web.DHCPE.OtherPatientToHP","InsertConOrder",PAADM,"",UserId,UserId,CurLocID)
                        var ConArr=ConRet.split("^");
                        if (ConArr[0]=="-1"){
                            alert(ConArr[1]);
                            return false;
                        }else if (ConArr[0]=="-2"){
                            if (!confirm(ConArr[1]+",是否继续?")) return false;
                        }
                    }
                    //if (!ModifyAdviceApp("")) return false;
                    /* 生成总的建议提到审核之前  wgy*/
                    var obj=document.getElementById("CreateGSSDetail");
                    if (obj) var encmeth=obj.value;
                    //obj=document.getElementById("SSID");
                    //if (obj) GSID=obj.value;
                     var GSID=tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetSSId",PAADM)
                     if(GSID==""){
                        return false;
                        }

                    //var ret=cspRunServerMethod(encmeth,GSID,MainDoctor);
                    var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","CreateGSSDetail",GSID,MainDoctor);
                    var ret=ShowResult_click(1);
                    
                    /*end*/
                    
                    
                    return false;
                    
                    
                }
            }
        }
        
        
        
        
    }else{
        //保存建议
        //Save_click();
        SaveNew_click(0)
        
        obj=document.getElementById("EpisodeID");
        if (obj) var PAADM=obj.value;
        
        //判断是否存在与性别不一致的关键字
        var SelectMark=""
        var SelectMark=tkMakeServerCall("web.DHCPE.ReportGetInfor","SelectMarkDesc",PAADM);
        if(SelectMark!=""){
            
            
            $.messager.confirm("提示","存在与性别不一致关键字: "+SelectMark+" ,是否继续?", function (r) {
                if (r) {
                    //判断是否有没有结果的项目
                    obj=document.getElementById("NoResultItemClass");
                    if (obj) var encmeth=obj.value;
                    //var ret=cspRunServerMethod(encmeth,PAADM);
                    var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","GetNoResultItem",PAADM);
                    if (ret!=""){
                        var Char_1=String.fromCharCode(1);
                        var NoResultArr=ret.split(Char_1);
                        var NoResultDesc=NoResultArr[1];
                        
                        
                        $.messager.confirm("提示", "存在未完成的项目'"+NoResultDesc+"'是否把该项目放弃?", function (r) {
                            if (r) {
                                //处理是否放弃
                                var NoResultIDs=NoResultArr[0];
                                obj=document.getElementById("RefuseItems");
                                if (obj) var encmeth=obj.value;
                                //var ret=cspRunServerMethod(encmeth,NoResultIDs);
                                var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","RefuseItems",NoResultIDs);
                                
                                
                                // 自动插入会诊费
                    
                                if (MainDoctor=="N"){
                                    var CurLocID=session['LOGON.CTLOCID'];
                                    var ConRet=tkMakeServerCall("web.DHCPE.OtherPatientToHP","InsertConOrder",PAADM,"",UserId,UserId,CurLocID)
                                    var ConArr=ConRet.split("^");
                                    if (ConArr[0]=="-1"){
                                        alert(ConArr[1]);
                                        return false;
                                    }else if (ConArr[0]=="-2"){
                                        if (!confirm(ConArr[1]+",是否继续?")) return false;
                                    }
                                }
                                //if (!ModifyAdviceApp("")) return false;
                                /* 生成总的建议提到审核之前  wgy*/
                                var obj=document.getElementById("CreateGSSDetail");
                                if (obj) var encmeth=obj.value;
                                //obj=document.getElementById("SSID");
                                //if (obj) GSID=obj.value;
                                 var GSID=tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetSSId",PAADM)
                                 if(GSID==""){
                                    return false;
                                    }

                                //var ret=cspRunServerMethod(encmeth,GSID,MainDoctor);
                                var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","CreateGSSDetail",GSID,MainDoctor);
                                var ret=ShowResult_click(1);
                                
                                /*end*/
                                
                                
                                return false;
                                
                                
                                
                                
                            } else {
                                
                                // 自动插入会诊费
                    
                                if (MainDoctor=="N"){
                                    var CurLocID=session['LOGON.CTLOCID'];
                                    var ConRet=tkMakeServerCall("web.DHCPE.OtherPatientToHP","InsertConOrder",PAADM,"",UserId,UserId,CurLocID)
                                    var ConArr=ConRet.split("^");
                                    if (ConArr[0]=="-1"){
                                        alert(ConArr[1]);
                                        return false;
                                    }else if (ConArr[0]=="-2"){
                                        if (!confirm(ConArr[1]+",是否继续?")) return false;
                                    }
                                }
                                //if (!ModifyAdviceApp("")) return false;
                                /* 生成总的建议提到审核之前  wgy*/
                                var obj=document.getElementById("CreateGSSDetail");
                                if (obj) var encmeth=obj.value;
                                //obj=document.getElementById("SSID");
                                //if (obj) GSID=obj.value;
                                 var GSID=tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetSSId",PAADM)
                                 if(GSID==""){
                                    return false;
                                    }

                                //var ret=cspRunServerMethod(encmeth,GSID,MainDoctor);
                                var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","CreateGSSDetail",GSID,MainDoctor);
                                var ret=ShowResult_click(1);
                                
                                /*end*/
                                
                                
                                return false;
                            }
                        });
                        
                        
                    }
                    else
                    {
                        // 自动插入会诊费
                    
                        if (MainDoctor=="N"){
                            var CurLocID=session['LOGON.CTLOCID'];
                            var ConRet=tkMakeServerCall("web.DHCPE.OtherPatientToHP","InsertConOrder",PAADM,"",UserId,UserId,CurLocID)
                            var ConArr=ConRet.split("^");
                            if (ConArr[0]=="-1"){
                                alert(ConArr[1]);
                                return false;
                            }else if (ConArr[0]=="-2"){
                                if (!confirm(ConArr[1]+",是否继续?")) return false;
                            }
                        }
                        //if (!ModifyAdviceApp("")) return false;
                        /* 生成总的建议提到审核之前  wgy*/
                        var obj=document.getElementById("CreateGSSDetail");
                        if (obj) var encmeth=obj.value;
                        //obj=document.getElementById("SSID");
                        //if (obj) GSID=obj.value;
                         var GSID=tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetSSId",PAADM)
                         if(GSID==""){
                            return false;
                            }

                        //var ret=cspRunServerMethod(encmeth,GSID,MainDoctor);
                        var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","CreateGSSDetail",GSID,MainDoctor);
                        var ret=ShowResult_click(1);
                        
                        /*end*/
                        
                        
                        return false;
                        
                        
                    }
                } else {
                    return false;
                }
            });
            
        }
        else
        {
            //判断是否有没有结果的项目
            obj=document.getElementById("NoResultItemClass");
            if (obj) var encmeth=obj.value;
            //var ret=cspRunServerMethod(encmeth,PAADM);
            var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","GetNoResultItem",PAADM);
            if (ret!=""){
                var Char_1=String.fromCharCode(1);
                var NoResultArr=ret.split(Char_1);
                var NoResultDesc=NoResultArr[1];
                
                
                $.messager.confirm("提示", "存在未完成的项目'"+NoResultDesc+"'是否把该项目放弃?", function (r) {
                    if (r) {
                        //处理是否放弃
                        var NoResultIDs=NoResultArr[0];
                        obj=document.getElementById("RefuseItems");
                        if (obj) var encmeth=obj.value;
                        //var ret=cspRunServerMethod(encmeth,NoResultIDs);
                        var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","RefuseItems",NoResultIDs);
                        
                        
                        // 自动插入会诊费
            
                        if (MainDoctor=="N"){
                            var CurLocID=session['LOGON.CTLOCID'];
                            var ConRet=tkMakeServerCall("web.DHCPE.OtherPatientToHP","InsertConOrder",PAADM,"",UserId,UserId,CurLocID)
                            var ConArr=ConRet.split("^");
                            if (ConArr[0]=="-1"){
                                alert(ConArr[1]);
                                return false;
                            }else if (ConArr[0]=="-2"){
                                if (!confirm(ConArr[1]+",是否继续?")) return false;
                            }
                        }
                        //if (!ModifyAdviceApp("")) return false;
                        /* 生成总的建议提到审核之前  wgy*/
                        var obj=document.getElementById("CreateGSSDetail");
                        if (obj) var encmeth=obj.value;
                        //obj=document.getElementById("SSID");
                        //if (obj) GSID=obj.value;
                         var GSID=tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetSSId",PAADM)
                         if(GSID==""){
                            return false;
                            }

                        //var ret=cspRunServerMethod(encmeth,GSID,MainDoctor);
                        var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","CreateGSSDetail",GSID,MainDoctor);
                        var ret=ShowResult_click(1);
                        
                        /*end*/
                        
                        
                        return false;
                        
                        
                        
                        
                    } else {
                        
                        // 自动插入会诊费
            
                        if (MainDoctor=="N"){
                            var CurLocID=session['LOGON.CTLOCID'];
                            var ConRet=tkMakeServerCall("web.DHCPE.OtherPatientToHP","InsertConOrder",PAADM,"",UserId,UserId,CurLocID)
                            var ConArr=ConRet.split("^");
                            if (ConArr[0]=="-1"){
                                alert(ConArr[1]);
                                return false;
                            }else if (ConArr[0]=="-2"){
                                if (!confirm(ConArr[1]+",是否继续?")) return false;
                            }
                        }
                        //if (!ModifyAdviceApp("")) return false;
                        /* 生成总的建议提到审核之前  wgy*/
                        var obj=document.getElementById("CreateGSSDetail");
                        if (obj) var encmeth=obj.value;
                        //obj=document.getElementById("SSID");
                        //if (obj) GSID=obj.value;
                         var GSID=tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetSSId",PAADM)
                         if(GSID==""){
                            return false;
                            }

                        //var ret=cspRunServerMethod(encmeth,GSID,MainDoctor);
                        var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","CreateGSSDetail",GSID,MainDoctor);
                        var ret=ShowResult_click(1);
                        
                        /*end*/
                        
                        
                        return false;
                    }
                });
                
                
            }
            else
            {
                // 自动插入会诊费
            
                if (MainDoctor=="N"){
                    var CurLocID=session['LOGON.CTLOCID'];
                    var ConRet=tkMakeServerCall("web.DHCPE.OtherPatientToHP","InsertConOrder",PAADM,"",UserId,UserId,CurLocID)
                    var ConArr=ConRet.split("^");
                    if (ConArr[0]=="-1"){
                        alert(ConArr[1]);
                        return false;
                    }else if (ConArr[0]=="-2"){
                        if (!confirm(ConArr[1]+",是否继续?")) return false;
                    }
                }
                //if (!ModifyAdviceApp("")) return false;
                /* 生成总的建议提到审核之前  wgy*/
                var obj=document.getElementById("CreateGSSDetail");
                if (obj) var encmeth=obj.value;
                //obj=document.getElementById("SSID");
                //if (obj) GSID=obj.value;
                 var GSID=tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetSSId",PAADM)
                 if(GSID==""){
                    $.messager.alert("提示", "还未生成总检信息，请点击获取结果!", "info");
                    return false;
                    }

                //var ret=cspRunServerMethod(encmeth,GSID,MainDoctor);
                var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","CreateGSSDetail",GSID,MainDoctor);
                var ret=ShowResult_click(1);
                
                /*end*/
                
                
                return false;
                
                
            }
            
            
            
            
            
            
        }
    }
    
}
function StationSCancelSub()
{
    StatusChange("Cancel","0");
}
function StatusChange(Type,QXType)
{
    obj=document.getElementById("EpisodeID");
    if (obj) var PAADM=obj.value;
    var MainDoctor="";
    var obj=document.getElementById("MainDoctor");
    if (obj) MainDoctor=obj.value;
    
    if(Type=="Cancel")
    {
        var AuditUser=tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetAuditUserId",PAADM,MainDoctor);
        if (AuditUser==""){
            $.messager.alert("提示", "小结还未提交!", "info");
            return false;
        }
        if(AuditUser!=UserId){
            
            $.messager.alert("提示", "非本人提交不能放弃提交!", "info");
            return; 
        }
            
    }
    
    //电子签名
    try{
        var SignType="2";
        if (MainDoctor=="Y") SignType=3;
        if (!PESaveCASign(SignType,PAADM,"")) return false;
    }catch(e){}
    //
    obj=document.getElementById("AuditBox");
    if (obj) var encmeth=obj.value;
    //var flag=cspRunServerMethod(encmeth,PAADM,Type,QXType,MainDoctor);
    var flag=tkMakeServerCall("web.DHCPE.ResultDiagnosis","AuditStationS",PAADM,Type,QXType,MainDoctor);
    if (flag=="0")
    {
        window.location.reload();
        return false;
    }
    else{
        if(flag=="ReMainHadAudit"){flag="总检复审已提交";}
        if(flag=="ReMainNoAudit"){flag="总检复审未提交";}
        if(flag=="HadAudit"){flag="总检初审已提交";}
        if(flag=="NoAudit"){flag="总检初审未提交";}
        if(flag=="ReportStatusErr"){flag="报告不是审核或者打印状态，不能取消";}
        $.messager.alert("提示", flag, "info");
        
        return false;
    }
}
function ShowEDInfo(e)
{
    
    var OnlyRead="N";
    var obj=document.getElementById("OnlyRead");
    if (obj) OnlyRead=obj.value;
    if (OnlyRead=="Y") return false;
    
    var Status="";
    var obj=document.getElementById("Status");
    if (obj) Status=obj.value;
    Status=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","GetStatus",EpisodeID);
    if ((Status==2)||(Status=="")) return false;  //已复检
    var MainDoctor="";
    var obj=document.getElementById("MainDoctor");
    if (obj) MainDoctor=obj.value;
    if ((Status==1)&&(MainDoctor=="N")) return false; //初检界面已初检
    if ((Status==0)&&(MainDoctor=="Y")) return false; //复检界面未初检
        
    
    var OEORDItemID=e.id;
    CurID=OEORDItemID;
    
    
    var innerText=tkMakeServerCall("web.DHCPE.DHCPEExpertDiagnosis","OutEDInfoHISUI","",OEORDItemID);
    
    
    $HUI.window("#DiagnosisEDDiv",{
        title:"科室建议",
        minimizable:false,
        iconCls:'icon-w-list',
        maximizable:false,
        collapsible:false,
        modal:true,
        width:300,
        height:600,
        content:innerText
    });
    
    /*
    var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEShowEDInfo&OEORDItemID="+OEORDItemID;
    var wwidth=300;
    var wheight=600; 
    var xposition = screen.width-wwidth-30;
    var yposition = ((screen.height - wheight) / 2)-100;
    var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes'
            +',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
            ;
    if (EDWin) EDWin.close();
    EDWin=window.open(url,"EDWin",nwin);
    */
    
}

function EDClick()
{
    var eSrc=window.event.srcElement;
    var eSrcID=eSrc.id;
    var InfoArr=eSrcID.split("^");
    var StationID=InfoArr[0];
    var Desc=InfoArr[1];
    var LocID=InfoArr[2];
    var obj=document.getElementById("GetEDInfoByDesc");
    if (obj) encmeth=obj.value;
    
    //var Info=cspRunServerMethod(encmeth,StationID,Desc,OEORDItemID);
    if(LocID==undefined){var LocID="";}
    var Info=tkMakeServerCall("web.DHCPE.DHCPEExpertDiagnosis","GetEDInfoByDesc",StationID,Desc,EpisodeID,LocID);
    if (Info=="") return false;
    CreateDiv(eSrc,Info)
    
}
function CreateDiv(obj,Info){  
    var div=document.getElementById("editBehaviorDiv");  
    if(div!=null)  
        $("#editBehaviorDiv").remove();  
    div = document.createElement("div");   
    div.id="editBehaviorDiv";  
    div.style.position='absolute';  
    div.style.overflow='auto';
    var op=getoffset(obj);  
    div.style.top=op[0]+20;  
    div.style.left=op[1]+30;  
    div.style.zIndex =100;  
    
    var DivTop=150;
    var Divleft=560; 
    div.style.height='300px';
    div.style.backgroundColor='white';  
    div.style.border="1px solid #666";  
      
    var innerText="<TABLE border=1 width=200><TR align='right' bgcolor=''><TD colspan=2><a herf='#' onclick='RemoveAllDiv(0)'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>关闭</a></TD></TR>"
    var Char_2=String.fromCharCode(2);
    var Char_1=String.fromCharCode(1);
    var EDArr=Info.split(Char_2);
    var EDArrLength=EDArr.length
    for (var i=0;i<EDArrLength;i++)
    {
        var OneEDArr=EDArr[i];
        
        var OneArr=OneEDArr.split(Char_1);
        innerText=innerText+"<TR><TD style='cursor:hand' value='"+OneArr[0]+"'"+" id='EDID^"+OneArr[0]+"' ondblclick=EDDblClick(this)>"+OneArr[1]+"</TD></TR>"
    }
    innerText=innerText+"</TABLE>"
    
    //document.body.appendChild(div); 
    $("#DiagnosisEDDiv").append(div);
    $("#editBehaviorDiv").html(innerText);
    
    
    newPos=new Object();
    newPos.left=Divleft;
    newPos.top=DivTop;
    $("#editBehaviorDiv").offset(newPos);
    $("#editBehaviorDiv").show();
     
}

function QueryED_KeyDown(e,stid,adm)
{
    var Key=websys_getKey(e); 
    if ((13==Key)) 
    {
        
        var ret=tkMakeServerCall("web.DHCPE.DocPatientFind","OutEDInfobyPrefix",stid,"",adm,"0",e.value);
        
        $("#edprefix").remove();
        $("#DiagnosisEDDiv").append(ret);
    }

    
}
function ShowOneResult(e)
{
    obj=document.getElementById("MainDoctor");
    if (obj) MainDoctor=obj.value;
    var OEORDItemID=e.id;
    var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENewOneResult&OEORDItemID="+OEORDItemID;
    var wwidth=550;
    var wheight=600; 
    var xposition = ((screen.width - wwidth) / 2)-20;
    var yposition = ((screen.height - wheight) / 2)-100;
    var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes'
            +',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
            ;
    if (ResultWin) ResultWin.close();
    ResultWin=window.open(url,"ResultWin",nwin)
}
function RemoveAllDiv(Type)
{
    if (CloseODSDivFlag=="1"){
        var div=document.getElementById("ODSDiv");  
        if (div!=null) document.body.removeChild(div);
    }else{
        CloseODSDivFlag="1";
    }
    var div=document.getElementById("EDDetail");  
    if (div!=null) document.body.removeChild(div);
    var div=document.getElementById("ALLEDDesc");  
    if (div!=null) document.body.removeChild(div);
    var div=document.getElementById("editBehaviorDiv");
    if (div!=null) $("#editBehaviorDiv").remove();
    
    if (Type=="1")
    {
        var div=document.getElementById("EDDiv");  
        if (div!=null) document.body.removeChild(div);
        var div=document.getElementById("DiagnosisEDDiv");  
        if (div!=null) document.body.removeChild(div);
    }
}
function getoffset(elem)   
{
    if ( !elem ) return {left:0, top:0};

    var top = 0, left = 0;

    if ( "getBoundingClientRect" in document.documentElement ){

        //jquery方法

        var box = elem.getBoundingClientRect(), 

        doc = elem.ownerDocument, 

        body = doc.body, 

        docElem = doc.documentElement,

        clientTop = docElem.clientTop || body.clientTop || 0, 

        clientLeft = docElem.clientLeft || body.clientLeft || 0,

        top  = box.top  + (self.pageYOffset || docElem && docElem.scrollTop  || body.scrollTop ) - clientTop,

        left = box.left + (self.pageXOffset || docElem && docElem.scrollLeft || body.scrollLeft) - clientLeft;

    }else{

        do{

            top += elem.offsetTop || 0;

            left += elem.offsetLeft || 0;

            elem = elem.offsetParent;

        } while (elem);

    }
    var rec = new Array(1);   
    rec[0] = top;   
    rec[1] = left;   
    return rec 
}

function detailClick(e)
{
    var OnlyRead="N";
    var obj=document.getElementById("OnlyRead");
    if (obj) OnlyRead=obj.value;
    if (OnlyRead=="Y") return false;
    var Status="";
    var obj=document.getElementById("Status");
    if (obj) Status=obj.value;
    //if ((Status==2)||(Status=="")) return false;  //已复检
    
    var MainDoctor="";
    var obj=document.getElementById("MainDoctor");
    if (obj) MainDoctor=obj.value;
    if ((Status==1)&&(MainDoctor=="N")) return false; //初检界面已初检
    if ((Status==0)&&(MainDoctor=="Y")) return false; //复检界面未初检
    var Info=e.id;
    var InfoArr=Info.split("^");
    var OEORIRowId=InfoArr[0];
    CurID=OEORIRowId;
    var ODRowid=InfoArr[1];
    var ChartID=InfoArr[2];
    var otherDesc="";
    var EpisodeID=""
    var obj=document.getElementById("EpisodeID");
        if (obj){
        EpisodeID=obj.value
    }
    //if (EpisodeID=="4034840") alert(InfoArr)
    var temIns=document.getElementById("GetEDInfo");
    if(temIns){
            temIns=temIns.value;
    }
    //alert(OEORIRowId+"^"+EpisodeID+"^"+ODRowid+"^"+ChartID)
    var Info=cspRunServerMethod(temIns,OEORIRowId,EpisodeID,ODRowid,ChartID,otherDesc);
    CreateEDDIv(e,Info,ChartID);
}
function CreateEDDIv(Parentobj,Info,ChartID){
    var OnlyRead="N";
    var obj=document.getElementById("OnlyRead");
    if (obj) OnlyRead=obj.value;
    if (OnlyRead=="Y") return false;

    RemoveAllDiv(1);  
    if (Info=="") return false;
    div = document.createElement("div");   
    div.id="EDDiv";  
    div.style.position='absolute';  
    var op=getoffset(Parentobj);
    //alert(op)
    //div.style.top=op[0]+20; 
    div.style.top=30; 
    //div.style.height=500
    div.style.width=240
    //div.style.left=op[1]+20; 
    div.style.left=500; 
    div.style.zIndex =100;  
    div.style.backgroundColor='white';  
    div.style.border="1px solid #666";
    div.style.overflow="auto"  
    //div.className="td1";  
    var OneHeight=20;
    var TableHeight=0;
    
    var innerText="<TABLE border=0.5 width=220><TR height=20 align='right' bgcolor='lightblue'><TD colspan=2><button onclick='RemoveAllDiv(1)'>关闭</button></TD></TR>"
    var Char_1=String.fromCharCode(1);
    var EDArr=Info.split(Char_1);
    var EDArrLength=EDArr.length;
    for (var i=0;i<EDArrLength;i++)
    {
        var OneED=EDArr[i];
        TableHeight=TableHeight+OneHeight;
        innerText=innerText+"<TR height=20 bgcolor='lightblue'><TD width=20>"+(i+1)+"</TD><TD style='cursor:hand' width=200 value='"+OneED+"^"+ChartID+"^"+Parentobj.id+"'   id='"+OneED+"^"+ChartID+"^"+Parentobj.id+"' onclick=EDDescClick(this,1)>"+OneED+"</TD>"
        /*
        i=i+1;
        if (i<EDArrLength)
        {
            var OneED=EDArr[i];
            innerText=innerText+"<TD style='cursor:hand' width=110 value='"+OneED+"^"+ChartID+"' onclick=EDDescClick(this,1)>"+OneED+"</TD>"
        }
        */
        innerText=innerText+"</TR>"
    }
    
    if (TableHeight>500)
    {
        div.style.height=500;
    }
    //innerText=TableInfo+innerText;

    innerText=innerText+"</TABLE>"
    div.innerHTML=innerText;
    document.body.appendChild(div); 
    //rDrag.init(div);
}
////拖动DIV
var rDrag = {
 
 o:null,
 
 init:function(o){
  o.onmousedown = this.start;
 },
 start:function(e){
  var o;
  e = rDrag.fixEvent(e);
               e.preventDefault && e.preventDefault();
               rDrag.o = o = this;
  o.x = e.clientX - rDrag.o.offsetLeft;
                o.y = e.clientY - rDrag.o.offsetTop;
  document.onmousemove = rDrag.move;
  document.onmouseup = rDrag.end;
 },
 move:function(e){
  e = rDrag.fixEvent(e);
  var oLeft,oTop;
  oLeft = e.clientX - rDrag.o.x;
  oTop = e.clientY - rDrag.o.y;
  rDrag.o.style.left = oLeft + 'px';
  rDrag.o.style.top = oTop + 'px';
 },
 end:function(e){
  e = rDrag.fixEvent(e);
  if (rDrag.o.id=="RoomRecord")
  {
    UpdateDivPosition();
  }
  rDrag.o = document.onmousemove = document.onmouseup = null;
 },
    fixEvent: function(e){
        if (!e) {
            e = window.event;
            e.target = e.srcElement;
            e.layerX = e.offsetX;
            e.layerY = e.offsetY;
            
        }
        return e;
    }
}
function EDDescClick(e,CloseODSFlag,ChartID)
{
    CloseODSDivFlag=CloseODSFlag;
    //var Desc=e.value;
    var Desc=e.id;
    var ChartID=Desc.split("^")[1];
    var OEOrdID=Desc.split("^")[2];
    var Desc=Desc.split("^")[0];
    var encmeth="";
    var obj=document.getElementById("GetEDInfoByDesc");
    if (obj) encmeth=obj.value;
    var Info=cspRunServerMethod(encmeth,ChartID,Desc,OEOrdID);
    CreateEDDetailDiv(e,Info)
}
function PreviewDirect()
{
    var viewmark=2;
    var EpisodeID=""
    var obj=document.getElementById("EpisodeID");
        if (obj){
        EpisodeID=obj.value
    }
    if (""==EpisodeID) { 
        alert("您没有选择客户,或者没有登记")
        return false;    
    }
    var flag= tkMakeServerCall("web.DHCPE.OtherPatientToHP","IsOtherPatientToHP",EpisodeID);
    if(flag=="1"){
        alert("住院病人无需预览导诊单");
        return false;
        }

    var PrintFlag=1;
    var PrintView=1;
    var Instring=EpisodeID+"^"+PrintFlag+"^PAADM"+"Y";  
    var Ins=document.getElementById('GetOEOrdItemBox'); 
    if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
    var value=cspRunServerMethod(encmeth,'','',Instring);
    Print(value,PrintFlag,viewmark);    //DHCPEIAdmItemStatusAdms.PatItemPrint
    
    return false;
}
function SendAudit()
{
    
    
    var UserID=session['LOGON.USERID'];
    var EpisodeID=""
    var obj=document.getElementById("EpisodeID");
    if (obj){
        EpisodeID=obj.value
    }
    if (""==EpisodeID) { 
        $.messager.alert("提示","您没有选择客户,或者没有登记!","info");
        return false;    
    }
    
    
    //判断是否有没有结果的项目
    obj=document.getElementById("NoResultItemClass");
    if (obj) var encmeth=obj.value;
    //var ret=cspRunServerMethod(encmeth,EpisodeID);
    var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","GetNoResultItem",EpisodeID);
    if (ret!=""){
        var Char_1=String.fromCharCode(1);
        var NoResultArr=ret.split(Char_1);
        var NoResultDesc=NoResultArr[1];
        
    }
    
    var obj=document.getElementById("SendAuditClass");
    if (obj) encmeth=obj.value;
    
    var ret=tkMakeServerCall("web.DHCPE.FetchReport","SendAudit","",UserID,"0",EpisodeID);
    
    var Arr=ret.split("^");
    if (Arr[0]=="-1"){
        try
        {   $.messager.alert("提示",Arr[1],"info");
            
            $("#RegNo",parent.document).focus();
            
        }catch(e){}
        return false;
    }
    if (Arr[0]=="0"){
        try
        {       $.messager.alert("提示","粘贴核对完成!","info");
                window.location.reload();

            $("#RegNo",parent.document).focus();
            
        }catch(e){}
        return false;
    }
    if (Arr[0]=="-2")
    {
        var EnterKey=String.fromCharCode(13);
        var AlertInfo="此人已经收表"+EnterKey;
        if (Arr[1]!=""){
            AlertInfo=AlertInfo+"未完成项目:"+Arr[1]+EnterKey+"是否继续操作";
        }else{
            AlertInfo=AlertInfo+"是否继续操作";
        }
        $.messager.confirm("操作提示",AlertInfo, function (data) {
                    if (data) {
                        
    //var ret=cspRunServerMethod(encmeth,"",UserID,"1",EpisodeID);
    var ret=tkMakeServerCall("web.DHCPE.FetchReport","SendAudit","",UserID,"1",EpisodeID);
    var Arr=ret.split("^");
    
    if (Arr[0]!="0"){
        $.messager.alert("提示",Arr[1],"info");
        return false;
    }
    try
    {
        
        $.messager.alert("提示","粘贴核对完成!","info");
        window.location.reload();
        $("#RegNo",parent.document).focus();
        

    }catch(e){};
                        
                        
                    }
                    
                     else {
                    return false;
                }
                    })
        //if (!confirm(AlertInfo)) return false;
    }
    
    if (Arr[0]=="-3")
    {
        var EnterKey=String.fromCharCode(13);
        var AlertInfo="未完成项目:"+Arr[1]+EnterKey+"是否继续操作";
        $.messager.confirm("操作提示",AlertInfo, function (data) {
                    if (data) {
                        
    //var ret=cspRunServerMethod(encmeth,"",UserID,"1",EpisodeID);
    var ret=tkMakeServerCall("web.DHCPE.FetchReport","SendAudit","",UserID,"1",EpisodeID);
    var Arr=ret.split("^");
    if (Arr[0]!="0"){
        $.messager.alert("提示",Arr[1],"info");
        return false;
    }
    try
    {
        
        $.messager.alert("提示","粘贴核对完成!","info");
        window.location.reload();
        $("#RegNo",parent.document).focus();
        

    }catch(e){};
                        
                        
                    }
                     else {
                    return false;
                }
                    })
        //if (!confirm(AlertInfo)) return false;
    }
    
    return false;
}
function CreateEDDetailDiv(obj,Info){  
    RemoveAllDiv(0);  
    div = document.createElement("div");   
    div.id="EDDetail";  
    div.style.position='absolute';  
    var op=getoffset(obj);  
    //div.style.top=op[0]+20; 
    div.style.top=30;
    //div.style.left=op[1];  
    div.style.left=520+220;  
    div.style.zIndex =100;  
    div.style.backgroundColor='white';  
    div.style.border="1px solid #666";  
    //div.className="td1";  
    var innerText="<TABLE border=0.5 width=300><TR align='right' bgcolor='lightblue'><TD colspan=2><button onclick='RemoveAllDiv(0)'>关闭</button></TD></TR>"
    var Char_2=String.fromCharCode(2);
    var Char_1=String.fromCharCode(1);
    var EDArr=Info.split(Char_2);
    var EDArrLength=EDArr.length
    for (var i=0;i<EDArrLength;i++)
    {
        var OneEDArr=EDArr[i];
        var OneArr=OneEDArr.split(Char_1);
        innerText=innerText+"<TR bgcolor='lightblue'><TD style='cursor:hand' value='"+OneArr[0]+"' id='EDID^"+OneArr[0]+"'  ondblclick=EDDblClick(this)>"+OneArr[1]+"</TD></TR>"
    }
    innerText=innerText+"</TABLE>"
    div.innerHTML=innerText;
    document.body.appendChild(div);  
}
function EDDblClick(e)
{
    
    //var EDID=e.value;
    var EDID=e.id;
    
    var EDID=EDID.split("^")[1];

    AddDiagnosis(EDID); 
}
function AddDiagnosis(EDID)
{
    var ID=EDID.split("^")[0];
    var SSIDObj=document.getElementById("SSID");
    if (SSIDObj) var SSID=SSIDObj.value;
    var obj=document.getElementById("AddEDClass");
    if (obj) var encmeth=obj.value;
    if (SSID=="") {alert("还没有小结");return false;}
    var MainDoctor="";
    var obj=document.getElementById("MainDoctor");
    if (obj) MainDoctor=obj.value;
    //var flag=cspRunServerMethod(encmeth,SSID,ID,"0",MainDoctor);
    var flag=tkMakeServerCall("web.DHCPE.ResultDiagnosis","UpdateSSDiagnosis",SSID,ID,"0",MainDoctor);
    var Arr=flag.split("^");
    if (Arr[0]==0){
        var MainDoctor="";
        var obj=document.getElementById("MainDoctor");
        if (obj) MainDoctor=obj.value;
        if (MainDoctor=="Y"){
            //复检保存建议
            var ret=SaveAdvice("0");
            //if (!ret) return false;
        }else{
            //保存建议
            SaveNew_click(0)
            //Save_click();
        }
        var obj=document.getElementById("GetAdviceByStation");
        if (obj) encmeth=obj.value;
        
        //var ret=cspRunServerMethod(encmeth,SSID,CurID,MainDoctor);
        var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","GetAdviceInfoByStation",SSID,CurID,MainDoctor);
        
        var Char_1=String.fromCharCode(1);
        var Arr=ret.split(Char_1);
        var ID=Arr[0];
        var Info=Arr[1];
        var obj=document.getElementById(ID);
        if (obj) obj.innerHTML=Info;
        SetAreaTextHeight();
        $.parser.parse($("#addiagnosisdiv").parent());
        return false;
    }
    if(flag=="HadDiagnosis"){$.messager.alert("提示","已经有相同的诊断","info");}
    if(flag=="HadAudit"){$.messager.alert("提示","总检已经审核","info");}
    if(flag=="NoAudit"){$.messager.alert("提示","小结还未提交","info");}
    if(flag=="ReMainHadAudit"){$.messager.alert("提示","复检已提交","info");}

    //alert(flag);
    return false;
}
function setTareaAutoHeight(e) {
    //e.style.height = e.scrollHeight + "px";
    if (e.scrollHeight<32){
        e.style.height=32+"px";
    }else{
        e.style.height = e.scrollHeight + "px";
    }
}
function GSSDetail()
{
    var SSID="";
    var SSIDObj=document.getElementById("SSID");
    if (SSIDObj) var SSID=SSIDObj.value;
    if (SSID=="") return false
    var UserID=session['LOGON.USERID'];
    var url="dhcpemodifyrecord.hisui.csp?SourceType="+"GSSDetail"+"&SourceID="+SSID;
    websys_lu(url,false,'width=1150,height=660,hisui=true,title=总检日志')
    
    return false;
}
function Conclusion()
{
    var SSID="";
    var SSIDObj=document.getElementById("SSID");
    if (SSIDObj) var SSID=SSIDObj.value;
    if (SSID=="") return false
    var UserID=session['LOGON.USERID'];
    var url="dhcpenewdiagnosis.conclusion.hisui.csp?GSID="+SSID+"&UserID="+UserID;
    websys_lu(url,false,'width=670,height=428,hisui=true,title=检查结论')
    
    return false;
}
function ConclusionOld()
{
    var SSID="";
    var SSIDObj=document.getElementById("SSID");
    if (SSIDObj) var SSID=SSIDObj.value;
    if (SSID=="") return false
    var UserID=session['LOGON.USERID'];
    var url="dhcpeconclusion.csp?GSID="+SSID+"&UserID="+UserID;
    websys_lu(url,false,'width=670,height=505,hisui=true,title=检查结论')
    
    /*
    var content = '<iframe scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';
    
    $HUI.window("#ConclusionWin",{
        title:"检查结论",
        collapsible:false,
        modal:true,
        width:600,
        height:500,
        content:content
    });             
    */
    return false;
}
function QMManager()
{
    var iEpisodeID="",obj;
    obj=document.getElementById("EpisodeID");
    if (obj) { iEpisodeID=obj.value; }
    var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEQualityManager"+"&PAADM="+iEpisodeID;
    websys_lu(url,false,'width=670,height=600,hisui=true,title=质量上报')
    /*
    var content = '<iframe scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';
    
    $HUI.window("#QMManagerWin",{
        title:"质量上报",
        collapsible:false,
        modal:true,
        width:700,
        height:600,
        content:content
    }); 
    */
   
    return false;
}
/*
function ShowCheckResult()
{
    var iEpisodeID="",obj;
    obj=document.getElementById("EpisodeID");
    if (obj) { iEpisodeID=obj.value; }
    lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisclinicQueryOEItem"
    +"&EpisodeID="+iEpisodeID;
    var wwidth=600;
    var wheight=400;
    var xposition = (screen.width - wwidth) / 2;
    var yposition = (screen.height - wheight) / 2;
    var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
    +'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
    ;
    var cwin=window.open(lnk,"_blank",nwin)
    return false;
}
function ShowCheckPISResult()
{
    var iEpisodeID="",obj;
    obj=document.getElementById("EpisodeID");
    if (obj) { iEpisodeID=obj.value; }
    lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPisclinicQueryOEItem"
    +"&EpisodeID="+iEpisodeID;
    var wwidth=600;
    var wheight=400;
    var xposition = (screen.width - wwidth) / 2;
    var yposition = (screen.height - wheight) / 2;
    var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
    +'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
    ;
    var cwin=window.open(lnk,"_blank",nwin)
    return false;
}
*/
function ShowCheckResult()
{
    var iEpisodeID="",obj;
    obj=document.getElementById("EpisodeID");
    if (obj) { iEpisodeID=obj.value; }
    var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSendPisInterface");
    if(flag=="1"){
        //新产品组方法
         //lnk=tkMakeServerCall("web.DHCEMInterface","GetRepLinkUrl",iEpisodeID,"","E");
         lnk=tkMakeServerCall("web.DHCAPPInterface","GetRepLinkUrl",iEpisodeID,"","E");
        }else{
        //pacs组件
        lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisclinicQueryOEItem"
        +"&EpisodeID="+iEpisodeID;
        }
    
    var wwidth=1400;
    var wheight=1200;
    var xposition = (screen.width - wwidth) / 2;
    var yposition = (screen.height - wheight) / 2;
    var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
    +'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
    ;
    var cwin=window.open(lnk,"_blank",nwin)
    return false;
}
function ShowCheckPISResult()
{
    var iEpisodeID="",obj;
    obj=document.getElementById("EpisodeID");
    if (obj) { iEpisodeID=obj.value; }
    var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSendPisInterface");
    if(flag=="1"){
        //新产品组方法
         //lnk=tkMakeServerCall("web.DHCEMInterface","GetRepLinkUrl",iEpisodeID,"","P");
         lnk=tkMakeServerCall("web.DHCAPPInterface","GetRepLinkUrl",iEpisodeID,"","P");
        }else{
        //病理组件
        lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPisclinicQueryOEItem"
        +"&EpisodeID="+iEpisodeID;
        }
    var wwidth=1400;
    var wheight=1200;
    var xposition = (screen.width - wwidth) / 2;
    var yposition = (screen.height - wheight) / 2;
    var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
    +'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
    ;
    var cwin=window.open(lnk,"_blank",nwin)
    return false;
}

function SetYGFlag(e,ConfirmFlag) {
    var IDStr = e.id;
    if (IDStr == "") return false;
    var Flag = IDStr.split("^")[0];
    if (Flag == "YGFlag") {
        var info = "乙肝建议";
        var info1 = "正常建议";
    } else {
        var info = "正常建议";
        var info1 = "乙肝建议";
    }
    if (ConfirmFlag == 1) {
        $.messager.confirm("提示", "确实将" + info + "转变成" + info1 + "？",
            function (r) {
                if (r) {
                    var ID = IDStr.split("^")[1];
                    if (ID=="") return false;
                    // alert(ID + ",," + e.id);
                    var obj = document.getElementById(e.id);
                    if (obj) {
                        var imgurl = tkMakeServerCall("web.DHCPE.ResultDiagnosis","UpdateYGDiagnosisFlag",ID,Flag);
                        if (imgurl != "") {
                            $(e).tooltip("update",info1);
                            if (Flag == "YGFlag") { e.id = "ZCFlag^" + ID;}
                            else { e.id = "YGFlag^" + ID;}
                            obj.innerHTML = "<img src='" + imgurl + "' border='0'>";
                            //window.location.reload();
                        }
                    } else {
                        
                    }
                } else {
                    return false;
                }
            });
    } else {
        var ID = IDStr.split("^")[1];
        if (ID=="") return false;
        // alert(ID + ",," + e.id);
        var obj = document.getElementById(e.id);
        if (obj) {
            var imgurl = tkMakeServerCall("web.DHCPE.ResultDiagnosis","UpdateYGDiagnosisFlag",ID,Flag);
            if (imgurl != "") {
                $(e).tooltip("update",info1);
                if (Flag == "YGFlag") { e.id = "ZCFlag^" + ID;}
                else { e.id = "YGFlag^" + ID;}
                obj.innerHTML = "<img src='" + imgurl + "' border='0'>";
                //window.location.reload();
            } else {
                        
            }
        }
    }
}
