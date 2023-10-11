
//名称    DHCPEPreIADM.Find.hisui.js
//功能    个人预约查询
//创建    2020.11.06
//创建人  xy

$(function(){
            
    InitCombobox();
    
    //初始化个人预约查询界面
    InitPreIADMFindGrid();  
    
    //初始化项目明细界面
    InitOrderItemListGrid();  
   
    SetDefault();
    
    //默认报告约期
    DefaultReportDate()
    
    //查询
    $("#BFind").click(function() {  
        BFind_click();      
        });

      //清屏
     $("#BClear").click(function() {    
        BClear_click();     
        });
      
     $("#RegNo").keydown(function(e) {
            if(e.keyCode==13){
                BFind_click();
            }
            
        });

   $("#Name").keydown(function(e) { 
            if(e.keyCode==13){
                BFind_click();
            }
            
        });

      
   //取消体检
   $("#CancelPE").click(function() {    
        CancelPE();     
        });

    //撤销取消体检
     $("#UnCancelPE").click(function() {    
        UnCancelPE();       
        });
    
    //到达/取消到达
     $("#BUnArrived").click(function() {    
        IAdmAlterStatus();      
        });
    
    //取消/视同收费
    $("#BAsCharged").click(function() { 
        UpdateAsCharged();      
        });

    //费用
    $("#UpdatePreAudit").click(function() { 
        UpdatePreAudit();       
        });
        
    //修改项目
    $("#BModifyTest").click(function() {
            BModifyTest_click();            
        });
     
    //打印
    $("#BPrint").click(function() {
            BPrint_click();         
        });
     
    //补打
    $("#PrintAagin").click(function() {
            PrintAagin_click();         
        });    
          
    //指引单打印预览
    $("#BPrintView").click(function() {
            PatItemPrintXH();           
        });
    
    //补打收费条码
    $("#PrintPayAagin").click(function() {
            PrintPayAagin_Click();          
        });
     
     //报告预览
     $("#BPreviewReport").click(function() {
            PreviewAllReport();         
        });

    //修改VIP
     $("#BUpdateVIPLevel").click(function() {
            BUpdateVIPLevel_click();            
        });
    
    //修改部门
    $("#BUpdateDepart").click(function() {
            BUpdateDepart_click();          
        });
    
     //读卡
      $("#BReadCard").click(function() {
            ReadCardClickHandler();         
        });
    
      $("#CardNo").keydown(function(e) {
            
            if(e.keyCode==13){
                CardNoKeydownHandler();
            }
            
        }); 

    
    //读身份证
     $("#ReadRegInfo").click(function() {
            ReadRegInfo_OnClick();          
        });
      
      
     //收表
    $("#BRecpaper").click(function() {  
        BRecpaper_click();      
        });
        
    //延期
    $("#BDelayed").click(function() {   
        BExtension_click("0"); 
    }); 
    
    //撤销延期
    $("#BCancelDelayed").click(function() { 
        BExtension_click("1"); 
    }); 
    
    //放弃检查
    $("#BRefuseCheck").click(function() {   
        BRefuseCheck_click();       
    }); 
    
     //撤销放弃检查
    $("#UnBRefuseCheck").click(function() { 
        UnBRefuseCheck_click();     
        }); 
     
    //手动置已检状态
    $("#BChecked").click(function() {   
        BChecked_click("0");        1
        });  
    
    //撤销已检状态
    $("#BCancelChecked").click(function() { 
        BChecked_click("1");        
        });     
    
   
    //全选未检
    $('#SelectA').checkbox({
        onCheckChange:function(e,vaule){
            SelectA_clicked(vaule);
            
            }
            
    }); 

      iniForm();
})


/*
function iniForm(){

    var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSendPisFBWay");
    if(flag!="B"){
        $("#PrintPisRequest").checkbox("disable");
    }

    var UserDR=session['LOGON.USERID'];
    var LocID=session['LOGON.CTLOCID'];

    
    var OPflag=tkMakeServerCall("web.DHCPE.ChargeLimit","GetOPChargeLimitInfo",UserDR); 
    var OPflagOne=OPflag.split("^");
    if(OPflagOne[1]=="0"){
        $("#BAsCharged").linkbutton('disable');
        }
    if(OPflagOne[0]=="0"){
        $("#UpdatePreAudit").linkbutton('disable');
        }
        
    
}
*/

function iniForm(){

    var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSendPisFBWay");
    if(flag!="B"){
        $("#PrintPisRequest").checkbox("disable");
    }

    var UserDR=session['LOGON.USERID'];
    var LocID=session['LOGON.CTLOCID'];
   
    var OPflag=tkMakeServerCall("web.DHCPE.CT.ChargeLimit","GetOPChargeLimitInfo",UserDR,LocID);
    var OPflagOne=OPflag.split("^");
    
    //取消/视同收费
    if(OPflagOne[1]=="Y"){
        $("#BAsCharged").linkbutton('enable');
    }else{
        $("#BAsCharged").linkbutton('disable');
    }
    
    //费用
    if(OPflagOne[0]=="N"){
        $("#UpdatePreAudit").linkbutton('disable');
    } else{
        $("#UpdatePreAudit").linkbutton('enable');
    }   

}

//保存备注 
function BSaveRemark_Click(){
    
    $('#PreIADMFindGrid').datagrid('endEdit', editIndex); //最后一行结束行编辑   

    $.messager.confirm('确定', '确定要保存数据吗？', function(t) {
        if (t) {
            var rows = $('#PreIADMFindGrid').datagrid("getChanges");
            //alert(rows.length)
            if (rows.length > 0) {
                for (var i = 0; i < rows.length; i++) {
                    
                    if(rows[i].PIADM_RowId=="") break;
                    
                    var ret = tkMakeServerCall("web.DHCPE.PreIADM","UpDateMark",rows[i].PIADM_RowId,rows[i].TMark);
                
                    
                }
            }

        }
    });
    //BFind_click();    

}
//指引单打印预览
function PatItemPrintXH()
{

    var viewmark=2;
    var NoPrintAmount="N";
    var NoPrintAmount=$("#NoPrintAmount").checkbox('getValue');
    if(NoPrintAmount){ var NoPrintAmount="Y";}
    else{var NoPrintAmount="N";}
    
    var AdmIdStr=GetSelectIADM();
    if(AdmIdStr==""){
            $.messager.alert("提示","您没有选择客户","info");
            return false;
        }
    if(AdmIdStr.split(";").length>1){
        
        $.messager.alert("提示","只能操作一人","info");
        return false;
    } 
    
    var AdmId=AdmIdStr.split("^")[0];
    if (AdmId=="") { 
        $.messager.alert("提示","您没有选择客户,或者没有登记","info");
        return false;    
    }
        
    var PrintFlag=1;
    var PrintView=1;
    var Instring=AdmId+"^"+PrintFlag+"^PAADM^"+NoPrintAmount+"Y";
    var value=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetPatOrdItemInfo",'','',Instring);
    if (value=="NoPayed"){
        $.messager.alert("提示","存在未付费项目，不能预览","info");
        return false;
    }
    //alert(value)
    
    PrintDJDByType(AdmId, "PAADM", "V", "");  // DHCPEPrintDJDCommon.js
    
    //PEPrintDJD("V",AdmId+"^"+NoPrintAmount,"");//DHCPEPrintDJDCommon.js  lodop打印  增加入参拼串是否打印金额的标记  Y 打不打印，N 打印
    //Print(value,PrintFlag,viewmark);  //DHCPEIAdmItemStatusAdms.PatItemPrint
    
}

 ///报告预览
function PreviewAllReport()
{
    var iReportName=""; 
    var NewVerReportFlag=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",session['LOGON.CTLOCID'],"NewVerReport");
    var iReportName=tkMakeServerCall("web.DHCPE.ReportOutToWeb","GetReportPageName");
    var AdmIdStr=GetSelectIADM();
    if(AdmIdStr==""){
            $.messager.alert("提示","您没有选择客户","info");
            return false;
        }
    if(AdmIdStr.split(";").length>1){
        
        $.messager.alert("提示","只能操作一人","info");
        return false;
    } 
    
    var PAADM=AdmIdStr.split("^")[0];
    
    if (PAADM=="") { 
        $.messager.alert("提示","您没有选择客户,或者没有登记","info");
        $("#RegNo").focus()
        return false; 
    }
    if(NewVerReportFlag=="Lodop"){
        var Flag=tkMakeServerCall("web.DHCPE.PreIADM","IsHaveResultByPAADM",PAADM);
        if(Flag=="0"){
            $.messager.alert("提示","没有体检结果，不能预览","info");
             return false; 
        }

        //calPEReportProtocol("BPrintView",PAADM);
        PEPrintReport("V",PAADM,""); //lodop+csp预览体检报告
        return false;
    }else if(NewVerReportFlag=="Word"){ 
            var Flag=tkMakeServerCall("web.DHCPE.PreIADM","IsHaveResultByPAADM",PAADM);
            if(Flag=="0"){
                $.messager.alert("提示","没有体检结果，不能预览","info");
                 return false; 
            }
            //calPEReportProtocol("BPrintView",PAADM);
             websocoket_report("BPrintView",PAADM);
            return false;
        }else{
            var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no'
            +',left=0'
            +',top=0'
            +',width='+window.screen.availWidth
            +',height='+(window.screen.availHeight-40)
            ;
        var lnk=iReportName+"?PatientID="+PAADM;
        if (ReportWin) ReportWin.close();
        ReportWin=window.open(lnk,"ReportWin",nwin)
    }
    
}

function calPEReportProtocol(sourceID,jarPAADM){
    var opType=(sourceID=="BPrint"||sourceID=="NoCoverPrint")?"2":(sourceID=="BPrintView"?"5":"1");
    if(opType=="2"){
        jarPAADM=jarPAADM+"@"+session['LOGON.USERID'];
    }
    var saveType=sourceID=="BExportPDF"?"pdf":(sourceID=="BExportHtml"?"html":"word"); 
    var printType=sourceID=="NoCoverPrint"?"2":"1";
    location.href="PEReport://"+jarPAADM+":"+opType+":"+saveType+":"+printType
}

 
/*
 * [websocket 客户端通信]
 * @param    {[Date]}    date [日期]
 * @return   {[String]}         [格式化的日期]
 * @Author   wangguoying
 * @DateTime 2021-01-28
 */
function websocoket_report(sourceID, jarPAADM) {    
    var opType = (sourceID == "BPrint" || sourceID == "NoCoverPrint") ? "2" : (sourceID == "BPrintView" ? "5" : (sourceID == "BUploadReport" ? "4" : "1"));
    var fileType = (sourceID == "BExportPDF") || (sourceID == "BUploadReport") ? "pdf" : (sourceID == "BExportHtml" ? "html" : "word");
    var execParam = {
        business: "REPORT", //报告固定为REPORT
        admId: jarPAADM,
        opType: opType,
        fileType: fileType,
        printType: "1" //1为个人报告
    };
    
    //打印预览——增加水印
    if(execParam.opType == "2") execParam.extStr="HS10322,"+session["LOGON.USERID"];
    if(execParam.opType == "5") execParam.extStr="WaterMark:PreView";
    
    var json = JSON.stringify(execParam);
    $PESocket.sendMsg(json, null);
}

//修改部门
function BUpdateDepart_click()
{
    var IDs=GetSelectId();
    if (IDs=="") {
        $.messager.alert("提示","请选择人员","info");
        return;
        } 
    var DepartName=$("#DepartName").combogrid('getValue');
    if (($("#DepartName").combogrid('getValue')==undefined)||($("#DepartName").combogrid('getText')=="")){var DepartName="";}
    
    var AdmIdStr=IDs.split("^");
    
    for(i=0;i<AdmIdStr.length;i++)
    { 
        var AdmId=AdmIdStr[i].split(";")[0]
        
        var Info=tkMakeServerCall("web.DHCPE.PreIADMEx","UpdateDepartName",AdmId,DepartName);
    }
    
    $.messager.alert("提示","修改完成","success");
    BFind_click();
}
//修改VIP
function BUpdateVIPLevel_click()
{
    var iTAdmId="",iVIP="";
    
    var iVIP=$("#VIPLevel").combobox('getValue');
    
    if(iVIP==""){
         $.messager.alert("提示","请选择VIP等级后再更新","info");
        return false;
        }
        
    var IDs=GetSelectId();
    if (IDs=="") {
        $.messager.alert("提示","请选择人员","info");
        return;
        } 
        
    var PIAdmIdStr=IDs.split("^");
    var Flag=0
    for(i=0;i<PIAdmIdStr.length;i++)
    { 
        var PGAdmId=PIAdmIdStr[i].split(";")[1]
        if(PGAdmId!=="") var Flag=1
                
        
    }
    if(Flag==1){
        $.messager.alert("提示","团体人员不允许修改VIP等级","info");
        return false;
    }
    
    for(i=0;i<PIAdmIdStr.length;i++)
    { 
        
        var PIAdmId=PIAdmIdStr[i].split(";")[0]
        var flag=tkMakeServerCall("web.DHCPE.PreItemListEx","ChangeVipLevel",PIAdmId,iVIP);
        
    }
    
    if(i==PIAdmIdStr.length){
        
        $.messager.alert("提示","修改完成","success");
        BFind_click();
    }
    

    

}

function PrintAagin_click()
{
    var iTAdmId="";
    var iOEOriId="";
    var PrintFlag=1;
    var TAdmIdStr=GetSelectIADM() ;
    
    var TAdmIds=TAdmIdStr.split(";")
    for(var PSort=0;PSort<TAdmIds.length;PSort++)
    {
        var iTAdmIdS=TAdmIds[PSort];
        var iTAdmId=iTAdmIdS.split("^")[0];
        if (iTAdmId=="") { 
            $.messager.alert("提示","您没有选择客户,或者没有登记","info");
            websys_setfocus("RegNo");
            return false;    
        }
        
        PrintAllApp(iTAdmId,"PAADM","","Y");    //DHCPEPrintCommon.js  
    }
    $("#RegNo").focus();
    
}

//打印
function BPrint_click()
{
    
    var iTAdmId="";
    var iOEOriId="";
    var PrintFlag=1;
    var TAdmIdStr=GetSelectIADM() ;
    
    var TAdmIds=TAdmIdStr.split(";")
    for(var PSort=0;PSort<TAdmIds.length;PSort++)
    {
        var iTAdmIdS=TAdmIds[PSort];
        var iTAdmId=iTAdmIdS.split("^")[0];
        if (iTAdmId=="") { 
            $.messager.alert("提示","您没有选择客户,或者没有登记","info");
            websys_setfocus("RegNo");
            return false;    
        }
        
        PrintAllApp(iTAdmId,"PAADM","N","",""); //DHCPEPrintCommon.js   
    }
    $("#RegNo").focus();
    
}

///补打收费条码
function PrintPayAagin_Click()
{
    
    var selectrow = $("#PreIADMFindGrid").datagrid("getChecked");//获取的是数组，多行数据
    if(selectrow.length=="0"){
            $.messager.alert("提示","您没有选择客户,或者没有登记","info");
            return false;
        
        }
    for(var i=0;i<selectrow.length;i++){
        var IADM=selectrow[i].TAdmIdPIDM;
        if(IADM=="") continue;
        var PIAdmId=selectrow[i].PIADM_RowId;
        if(PIAdmId=="") continue;
        var RegNo=selectrow[i].PIADM_PIBI_DR_RegNo;
        var NewHPNo=selectrow[i].TNewHPNo;
        var Name=selectrow[i].PIADM_PIBI_DR_Name; 
        var Sex=selectrow[i].PIADMPIBI_DR_SEX;
        //var Age=selectrow[i].TAge+' 【补】';
        var Age=selectrow[i].TAge;
            
        var Amount=tkMakeServerCall("web.DHCPE.HandlerPreOrds","IGetAmount4Person",PIAdmId); 
        //var Amount=tkMakeServerCall("web.DHCPE.PrintNewDirect","GetPayedAmt",PIAdmId); 
        //var FactAmount=Amount.split('^')[1]+'元';
        var FactAmount=Amount.split('^')[1]+'元'+'    【补】';
        //var Info=RegNo+"^"+Name+"  "+FactAmount+"^"+"^"+"^"+"^"+Sex+String.fromCharCode(1)+"^"+Age+"^"+RegNo+"^"+NewHPNo;
        //alert(Info)
        //PrintBarRis(Info);    
        var Info=RegNo+"^"+Name+"^"+Sex+"^"+Age+"^"+FactAmount+"^"+RegNo;
        PrintBaseBar(Info);
    }
    
}

/// 项目预约页面
function BModifyTest_click() {
    
     var IDs="",GFlag=0,IFlag=0;
    var selectrow = $("#PreIADMFindGrid").datagrid("getChecked");//获取的是数组，多行数据
     
    for(var i=0;i<selectrow.length;i++){
        var PIADM=selectrow[i].PIADM_RowId;
         if(PIADM==""){
            break;
        }
        if (IDs==""){
                IDs=PIADM;
            }else{
                IDs=IDs+"^"+PIADM;
            }
        var PGADM=selectrow[i].PIADM_PGADM_DR;
        if (PGADM!=""){
                var GFlag=1;
            }else{
                var IFlag=1;
            }
    
        var VIPLevel=selectrow[i].TVIPLevel;
        
    }
    
    
    var Arr=IDs.split("^");
    var iRowId=Arr[0];

    
    if(IDs.split("^").length>1){
        $.messager.alert("提示","修改预约项目,只能选中一人","info");
        return false;
    }
    


    if (VIPLevel=="职业病"){
        var VipFlag="dhcpeoccupationaldiseaseinfo.csp"
    }else {
        var VipFlag=""
    }
    
    if (iRowId=="") {
        $.messager.alert("提示","请先勾选一个人员","info");
        return false;
    }
    var ret=tkMakeServerCall("web.DHCPE.PreIADM","GetPreFlag",IDs,IFlag,GFlag);
    var Str=ret.split("^");
    var flag=Str[0];
    if (flag=="1"){
            $.messager.alert("提示","个人和团体不能同时加项","info");
            return false;
    }else if (flag=="2"){
            $.messager.alert("提示","不是同一个团体人员不能同时加项","info");
            return false;
    }else if (flag=="3"){
            $.messager.alert("提示","不是同一个状态不能同时加项","info");
            return false;
    }else if (flag=="4"){
            $.messager.alert("提示","不是同一个VIP等级的不能同时加项","info");
            return false;
    }else if (flag=="5"){
            $.messager.alert("提示",Str[1]+$g("已收表不允许加项"),"info");
            return false;
    }else if (flag=="6"){
            $.messager.alert("提示","不是登记或者到达状态，不能同时加项","info");
            return false;
    }
    
    
    var PreOrAdd="PRE";
    
    if (GFlag=="1"){
        var AddType=$("#AddType").checkbox('getValue');
        if(AddType){PreOrAdd="PRE";}
        else{PreOrAdd="ADD";}
        
        var AddType="自费";
        if (PreOrAdd=="PRE") AddType="公费"
    
    $.messager.confirm("确认", $g("确实要给选中的人员")+AddType+$g("加项吗?"), function(r){
        if (r){
			 var lnk="dhcpepreitemlist.main.new.hisui.csp"+"?AdmType=PERSON"
            +"&AdmId="+IDs+"&PreOrAdd="+PreOrAdd+"&VIPLevel="+VIPLevel
            ;
		
         //websys_lu(lnk,false,'iconCls=icon-w-edit,width=1400,height=740,hisui=true,title='+$g('预约项目修改')) 
		 $HUI.window("#ItemEditWin", {
        		title: "预约项目修改",
        		iconCls: "icon-w-edit",
        		collapsible: false,
       			 minimizable: false,
        		maximizable: false,
        		resizable: false,
        		closable: true,
        		modal: true,
        		width: 1400,
        		height: 740,
        		content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
    		}); 
        }
    });
    }else{
		 var lnk="dhcpepreitemlist.main.new.hisui.csp"+"?AdmType=PERSON"
            +"&AdmId="+IDs+"&PreOrAdd="+PreOrAdd+"&VIPLevel="+VIPLevel
            ;
       
         //websys_lu(lnk,false,'iconCls=icon-w-edit,width=1400,height=740,hisui=true,title='+$g('预约项目修改')) 
		 $HUI.window("#ItemEditWin", {
        		title: "预约项目修改",
        		iconCls: "icon-w-edit",
        		collapsible: false,
       			 minimizable: false,
        		maximizable: false,
        		resizable: false,
        		closable: true,
        		modal: true,
        		width: 1400,
        		height: 740,
        		content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
    		}); 
    }
     
    return true;
}


//取消/视同收费
function UpdateAsCharged()
{
    var Type="I";
    var AsType="",AsRemark="",ID="";
    
    var ID=GetSelectId();
    
    if (ID=="") {
        $.messager.alert("提示","请先选择待操作的人员!","info");
        return false;
    }
    if(ID.split("^").length>1){
        $.messager.alert("提示","只能操作一人!","info");
        return false;
        }

    var  Group=ID.split(";")[1];
    if ((Group!="")&&(Group!=" "))
    {
        $.messager.alert("提示","团体中的客户,请在团体中操作!","info");
        return;
    }
    
    
    var  AsType=$("#AsType").combobox('getValue')
    var  AsRemark=$("#AsRemark").val();
    var AsCharged=ID.split(";")[4];
    ID=ID.split(";")[0];
    ID=ID+"^"+AsType+"^"+AsRemark;
   
   var UserID=session['LOGON.USERID'];
  
    if((AsCharged==$g("是"))){ 
        $.messager.confirm("确认", "确定要取消视同收费吗？", function (r) {
            if (r) {
                var Return=tkMakeServerCall("web.DHCPE.PreGADM","UpdateAsCharged",ID,Type,UserID);
                if (Return=="StatusErr"){
                    $.messager.alert("提示","状态错误!","error");
                }else if (Return=="SQLErr"){
                    $.messager.alert("提示","更新错误!","error");
                }else if (Return=="ExcuteErr"){
                    $.messager.alert("提示","视同收费的医嘱存在已执行的，不能取消视同收费!","info");
                }else if (Return=="MedErr"){
                    $.messager.alert("提示","存在发药品的医嘱,不能取消视同收费!","info"); 
                }else{
                    $.messager.alert("提示","更新成功!","success");
                    $("#AsRemark").val(""); 
                    $("#AsType").combobox('setValue',"");
                    BFind_click();
        
                }
            }else{
                return false;
           }
    })
   }
   if((AsCharged==$g("否"))){
        $.messager.confirm("确认", "确定要视同收费吗？", function (r) {
            if (r) {
                var Return=tkMakeServerCall("web.DHCPE.PreGADM","UpdateAsCharged",ID,Type,UserID);
                if (Return=="StatusErr"){
                    $.messager.alert("提示","状态错误!","error");
                }else if (Return=="SQLErr"){
                    $.messager.alert("提示","更新错误!","error");
                }else if (Return=="ExcuteErr"){
                    $.messager.alert("提示","视同收费的医嘱存在已执行的，不能取消视同收费!","info");
                }else if (Return=="MedErr"){
                    $.messager.alert("提示","存在发药品的医嘱,不能取消视同收费!","info"); 
                }else{
                    $.messager.alert("提示","更新成功!","success");
                    $("#AsRemark").val(""); 
                    $("#AsType").combobox('setValue',"");
                    BFind_click();
        
                }
            }else{
                return false;
           }
    })
   }
        


}


//费用
function UpdatePreAudit()
{
    var Type="I";
    var ID=GetSelectId();
    
    if (ID=="") {
        $.messager.alert("提示","请选择待操作的人员","info");
        return false;
        }
        
    if(ID.split("^").length>1){
        $.messager.alert("提示","只能操作一人","info");
        return false;
        }
    ID=ID.split(";")[0];
    
    var lnk="dhcpepreauditlist.hiui.csp?CRMADM="+ID+"&ADMType="+Type+"&GIADM="+"&RowID=";
    
	//websys_lu(lnk,false,'iconCls=icon-w-edit,width=1400,height=750,hisui=true,title=费用') //无法兼容所有浏览器居中显示，舍弃掉
    
   $HUI.window("#SplitWin", {
        title: "费用",
        iconCls: "icon-w-edit",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        closable: true,
        modal: true,
        width: 1400,
        height: 750,
        content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
    });

    return true;
}

///到达/取消取达
function IAdmAlterStatus(){ 
    var Data=GetSelectIADM();
    if (""==Data) { 
        $.messager.alert("提示","请先选择待操作的人员！","info");
        return ; 
    }
    var Datas=Data.split(";");
    for (var iLLoop=0;iLLoop<=Datas.length-1;iLLoop++){
        FData=Datas[iLLoop].split("^");
        if (""!=FData) {
            var paadm=FData[0];
            var iIAdmId=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetIAdmIdByPaadm",paadm);
            //var IAdmStatus=FData[1];
			var retstr = tkMakeServerCall("web.DHCPE.PreIADM", "GetStatusByPAADM", paadm);
           	var IAdmStatus = retstr.split("^")[0];
            var newStatus=""

            if (IAdmStatus=="ARRIVED") {
                newStatus="CANCELARRIVED";
                var GAAuditedFlag=tkMakeServerCall("web.DHCPE.ResultEdit","GeneralAdviceAudited",paadm,"PAADM");
                 if(GAAuditedFlag=="1") {
                    $.messager.alert("提示","总检初审已提交，不能取消到达！","info");
                    return false;
                 }
            }

            if (IAdmStatus=="REGISTERED") {
                newStatus="ARRIVED";
            }

            //if (IAdmStatus=="CANCELARRIVED") {newStatus="ARRIVED"}
            if (newStatus==""){
                $.messager.alert("提示","选择客人的状态应是到达或登记！","info");
                return false;
            }
            var flag=tkMakeServerCall("web.DHCPE.DHCPEIAdm","ArrivedUpdate",iIAdmId,newStatus);
            if (flag!='0') {
                $.messager.alert("提示","操作失败:"+flag,"info");
                return false;
            }
        }
    }
    
    $.messager.alert("提示","操作完成！","info");
    BFind_click();
    
}

function GetSelectIADM() 
{ 
    var vals="",IADM="",Status="";
    var selectrow = $("#PreIADMFindGrid").datagrid("getChecked");//获取的是数组，多行数据
  
    for(var i=0;i<selectrow.length;i++){
        var PIADM=selectrow[i].PIADM_RowId;
         if(PIADM==""){
            break;
        }
        var IADM=selectrow[i].TAdmIdPIDM;
        
        var Status=selectrow[i].PIADM_Status;
        if (IADM==" ") continue;
        if (vals=="") {vals=IADM+"^"+Status;}
        else {vals=vals+";"+IADM+"^"+Status;}
    }
    return vals;
    
}

function GetSelectId() 
{   

    var IDs="";
    var selectrow = $("#PreIADMFindGrid").datagrid("getChecked");//获取的是数组，多行数据
     
    for(var i=0;i<selectrow.length;i++){
        var PIADM=selectrow[i].PIADM_RowId;
        var PGADM=selectrow[i].PIADM_PGADM_DR;
        var Status=selectrow[i].PIADM_Status_Desc;
        var PIBIDR=selectrow[i].PIADM_PIBI_DR;
        var AsCharged=selectrow[i].PIADM_AsCharged;
          
         if(PIADM==""){
            break;
        }
            if (IDs==""){
                IDs=PIADM+";"+PGADM+";"+PIBIDR+";"+Status+";"+AsCharged;
            }else{
                IDs=IDs+"^"+PIADM+";"+PGADM+";"+PIBIDR+";"+Status+";"+AsCharged;
            }
    }
    
    return IDs;
}

function CancelPE()
{

    var Id="";
    var Id=GetSelectId();
    if(Id==""){
            $.messager.alert("提示","未选择人员","info");
            return false;
        }
    if(Id.split("^").length>1){
        
        $.messager.alert("提示","只能操作一人","info");
        return false;
    } 
    $.messager.confirm("确认", "确定要取消体检吗？", function(r){
        if (r){
            CancelPECommon("I",0,Id.split(";")[0]);
            BFind_click();
            
        }
    }); 
    
}

function UnCancelPE()
{
    var Id="";
    var Id=GetSelectId();
    if(Id==""){
            $.messager.alert("提示","未选择人员","info");
            return false;
        }
    if(Id.split("^").length>1){
        
        $.messager.alert("提示","只能操作一人","info");
        return false;
    } 
        
    var Status="";
    var Status=Id.split(";")[3];
    if(Status!=$g("取消体检")){
        $.messager.alert("提示","不是取消体检状态,不能撤销取消体检","info");
        return false;
    }
    var PGADM=Id.split(";")[1];
    var PIBI=Id.split(";")[2];
    var ExistFlag=tkMakeServerCall("web.DHCPE.PreIADM","GroupIsExistIADM",PIBI,PGADM)
    if (ExistFlag=="1") {
        $.messager.alert("提示","客户在团体中已存在,不能撤销取消体检","info");
        return false;
    }

    $.messager.confirm("确认", "确定要撤销取消体检吗？", function(r){
        if (r){
                CancelPECommon("I",1,Id.split(";")[0]);
                BFind_click();
            
        }
    }); 
    
    
}

function CancelPECommon(Type,DoType,Id){
    
    var Ret=tkMakeServerCall("web.DHCPE.CancelPE","CancelPE",Id,Type,DoType)
    Ret=Ret.split("^");
    $.messager.alert("提示",Ret[1],'success');
}



function SetDefault(){
    
    $("#ReCheck").combobox('setValue','0');
    $("#AsType").combobox('setValue','3');
    $("#PrintBarCode").checkbox('setValue',true);
    $("#PrintItem").checkbox('setValue',true);
    $("#PrintSpecItem").checkbox('setValue',true);

}

function GetStatus() {
    var iStatus="";

    // PREREG 预约
    var PREREG=$("#Status_PREREG").checkbox('getValue');
    if(PREREG){iStatus=iStatus+"^"+"PREREG";}      
    
    // REGISTERED 登记
    var REGISTERED=$("#Status_REGISTERED").checkbox('getValue');
    if(REGISTERED){iStatus=iStatus+"^"+"REGISTERED";}  
    
    
    // REGISTERED 到达
    var ARRIVED=$("#Status_ARRIVED").checkbox('getValue');
    if(ARRIVED){iStatus=iStatus+"^"+"ARRIVED";}  
    

    //CANCELPE  取消体检
    var CANCELPE=$("#Status_CANCELPE").checkbox('getValue');
    if(CANCELPE){iStatus=iStatus+"^"+"CANCELPE";}  
    
    iStatus=iStatus+"^"
    return iStatus;
}

function BFind_click() {
    
    //$("#BModifyTest,#BPrint,#BPrintView,#PrintPayAagin,#BPreviewReport,#BUpdateVIPLevel,#BUpdateDepart").linkbutton("enable");
    var CTLocID=session['LOGON.CTLOCID'];
    var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength",CTLocID);
    var iRegNo= $("#RegNo").val();
    if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
            iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo,CTLocID);
            $("#RegNo").val(iRegNo);
    }
    
    var iCardTypeNew=$("#CardTypeNew").val();
    
    var iCardNo=$("#CardNo").val();
    
    var iName=$("#Name").val();
    
    var iPEDate=$("#PEStDate").datebox('getValue');
    
    var iPETime="";
    
    var iVIP=$("#VIPLevel").combobox('getValue');
   
    iStatus=GetStatus();
    
    iChargedStatus=$("#ChargeStatus").combobox('getValue');
    
    iCheckedStatus="";
    
    
    var iPEEndDate=$("#EndDate").datebox('getValue');

    var iGroupID=$("#GroupDesc").combogrid('getValue');
    if (($("#GroupDesc").combogrid('getValue')==undefined)||($("#GroupDesc").combogrid('getValue')=="")){var iGroupID="";} 
    
    var iTeamID=$("#TeamDesc").combogrid('getValue');
    if (($("#TeamDesc").combogrid('getValue')==undefined)||($("#TeamDesc").combogrid('getValue')=="")){var iTeamID="";} 
    
    var iDepartName=$("#DepartName").combogrid('getValue');
    if (($("#DepartName").combogrid('getValue')==undefined)||($("#DepartName").combogrid('getValue')=="")){var iDepartName="";} 
    
   
    var iReCheck=$("#ReCheck").combobox('getValue');
    
    var iSex=$("#Sex").combobox('getValue');
   
    var iRoomPlace="";
    
    var HospID=session['LOGON.HOSPID'];
    
//debugger;
  $("#PreIADMFindGrid").datagrid('load',{
            ClassName:"web.DHCPE.PreIADM",
            QueryName:"SearchPreIADM",
            RegNo:iRegNo,
            Name:iName,
            PEStDate:iPEDate,
            Status:iStatus,
            ChargedStatus:iChargedStatus,
            CheckedStatus:iCheckedStatus,
            EndDate:iPEEndDate,
            GroupID:iGroupID,
            TeamID:iTeamID,
            DepartName:iDepartName,
            VIPLevel:iVIP,
            RoomPlace:iRoomPlace,
            ReCheck:iReCheck,
            SexDR:iSex,
            CardTypeNew:iCardTypeNew,
            HospID:HospID
        })
        
    
  InitOrderItemListGrid();
    
    
    
}


//查看预约项目
function BItemList(IADM)
{
    var lnk="dhcpeitemdetail.hisui.csp"+"?AdmId="+IADM;
    //websys_lu(lnk,false,'width=1350,height=750,hisui=true,title=预约项目')
	$HUI.window("#ItemListWin", {
        title: "预约项目",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        closable: true,
        modal: true,
        width: 1350,
        height: 750,
        content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
    });
    
}
//打印条码
function BPrintBarCode(PIADM)
{
    var lnk="dhcpeprintiadminfo.hisui.csp"+"?IAdmId="+PIADM;
   // websys_lu(lnk,false,'width=870,height=600,hisui=true,title=打印条码')
   $HUI.window("#PrintBarCodeWin", {
        title: "打印条码",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        closable: true,
        modal: true,
        width: 870,
        height: 600,
        content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
    });
}

//姓名替换
function BModifyName(PIADM)
{
    var lnk="dhcpepreiadmreplace.hisui.csp"+"?PreIADM="+PIADM;
    //websys_lu(lnk,false,'width=870,height=700,hisui=true,title=姓名替换')
	$HUI.window("#ModifyNameWin", {
        title: "姓名替换",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        closable: true,
        modal: true,
        width: 870,
        height: 700,
        content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
    });

}

//个人操作日志
function BAdmRecordList(IADM){
    var lnk="dhcpeadmrecordlist.hisui.csp"+"?AdmId="+IADM;
    //websys_lu(lnk,false,'width=950,height=700,hisui=true,title=个人日志操作记录')
	 $HUI.window("#RecordListWin", {
        title: "个人日志操作记录",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        closable: true,
        modal: true,
        width: 950,
        height: 700,
        content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
    });
}

//收费状态
function BPreAuditList(PIADM){
  
$("#PreAuditListWin").show();
    
    $HUI.window("#PreAuditListWin",{
        title:"收费状态列表",
        iconCls:'icon-w-list',
        minimizable:false,
        maximizable:false,
        collapsible:false,
        modal:true,
        width:980,
        height:390
    });
    
    var ConfirmObj = $HUI.datagrid("#PreAuditListGrid",{
        url:$URL,
        fit : true,
        border : true,
        striped : false,
        fitColumns : false,
        autoRowHeight : false,
        rownumbers:true,
        pagination : true, 
        pageSize: 20,
        pageList : [20,100,200],
        queryParams:{
            ClassName:"web.DHCPE.PreAudit",
            QueryName:"SerchPreAudit",
            ADMType:"I",
            CRMADM:PIADM
            
        },
        
        columns:[[
            {field:'TRowId',title:'PreAudit',hidden:true},
            {field:'TRebate',width:'100',title:'折扣率'},
            {field:'TAccountAmount',width:'100',title:'应收金额',align:'right'},
            {field:'TDiscountedAmount',width:'100',title:'打折金额',align:'right'},
            {field:'TFactAmount',width:'100',title:'最终金额',align:'right'},
            {field:'TAuditedStatus',width:'80',title:'审核状态'},
            {field:'TChargedStatus',width:'80',title:'收费状态'},
            {field:'TPrivilegeMode',width:'80',title:'优惠形式'},
            {field:'TType',width:'50',title:'类型'},
            {field:'TItemDetail',width:'70',title:'项目明细',align:'center',
                formatter:function(value,rowData,rowIndex){
                    if(rowData.TRowId!=""){
                        return "<span style='cursor:pointer;padding:0 10px 0px 0px' class='icon-paper' title='项目明细' onclick='ItemDetail_click("+rowData.TRowId+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                    }
                }},
            {field:'TTeamName',width:'90',title:'分组名称'},
            {field:'TRemark',width:'60',title:'备注'},
            
            
        ]]              
        
        })
}

//项目明细弹窗
function ItemDetail_click(AuditID)
{

$("#ItemDetailWin").show();
    
    $HUI.window("#ItemDetailWin",{
        title:"项目明细",
        iconCls:'icon-w-list',
        minimizable:false,
        maximizable:false,
        collapsible:false,
        modal:true,
        width:550,
        height:370
    });
    
    var ConfirmObj = $HUI.datagrid("#ItemDetailGrid",{
        url:$URL,
        fit : true,
        border : true,
        striped : false,
        fitColumns : false,
        autoRowHeight : false,
        rownumbers:true,
        pagination : true, 
        pageSize: 20,
        pageList : [20,100,200],
        queryParams:{
            ClassName:"web.DHCPE.ItemFeeList",
            QueryName:"FindItemFeeList",
            PreAudits:AuditID,
			CSPName:"dhcpepreiadmfind.hisui.csp"
        },
        
        columns:[[
            {field:'ItemName',width:'180',title:'项目名称'},
            {field:'FactAmount',width:'90',title:'最终金额',align:'right'},
            {field:'FeeTypeDesc',width:'50',title:'类别'},
            {field:'OrdStatusDesc',width:'60',title:'状态'},
            {field:'PatName',width:'100',title:'姓名'}
            
        ]]              
        
        })  
}

//诊室位置
function BChangeRoomPlace(PIADM){
    
     var lnk="dhcpechangeroomplace.hisui.csp"+"?PreIADM="+PIADM;
    // websys_lu(lnk,false,'width=1270,height=730,hisui=true,title=诊室位置')
	 $HUI.window("#RoomPlaceWin", {
        title: "诊室位置",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        closable: true,
        modal: true,
        width: 1270,
        height: 730,
        content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
    });
}

//调查问卷
function BHMS(PIADM){
    var lnk="dhchm.questiondetailset.csp"+"?PreIADM="+PIADM;
     //websys_lu(lnk,false,'width=1100,height=600,hisui=true,title=调查问卷')
 $HUI.window("#QuestionWin", {
        title: "调查问卷",
        iconCls: "icon-book",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        closable: true,
        modal: true,
        width: 1100,
        height: 700,
        content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="99%" frameborder="0"></iframe>'
    });
    return false;
}

//预约日期修改
function UpdatePreDate(PIADM)
{ 
    var lnk = "dhcpe.predate.select.csp?PIADM=" + PIADM + "&CBFunc=UpdatePreDateCallback&WinId=SelectDateWin";
    $HUI.window("#SelectDateWin", {
        title: "号源池",
        iconCls: "icon-book",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        closable: true,
        modal: true,
        width: 1300,
        height: 720,
        content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="99%" frameborder="0"></iframe>'
    });
    return false;
    
    
    
    
    $("#UpdatePreDateWin").show();
    $('#form-save').form("clear");
    var ret=tkMakeServerCall("web.DHCPE.PreIADM","GetPreIADM",PIADM);
    var retone=ret.split("^");
    var OldTime=retone[9];
    var OldDate=retone[7];
    $("#OldDate").datebox('setValue',OldDate);
    setValueById("OldTime",OldTime);
    
    var UpdatePreDateWin = $HUI.dialog("#UpdatePreDateWin",{
        iconCls:'icon-w-update',
        resizable:true,
        title:'预约日期修改',
        modal:true,
        buttonAlign : 'center',
        buttons:[
                
            {
                iconCls:'icon-w-update',
                text:'更新',
                id:'save_btn',
                handler:function(){
                    SaveForm(PIADM)
                }
            },{
                iconCls:'icon-w-close',
                text:'关闭',
                handler:function(){
                    UpdatePreDateWin.close();
                }
                
            }]
        });
        
        
    
}

///改期
function UpdatePreDateCallback(piadm,date,time,detailId)
{
    var ret=tkMakeServerCall("web.DHCPE.TransAdmInfo","UpdateAdmDate",piadm,date+"^"+time,detailId);
    if(ret=="0"){
        $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
        $('#PreIADMFindGrid').datagrid('reload');   
    }else{
        $.messager.alert("提示",ret,"error");
    }
    return 0;
}


SaveForm=function(PreIADM)
{
    var NewDate=$("#NewDate").datebox('getValue');
    var NewTime=getValueById("NewTime");
    var Date=NewDate+"^"+NewTime;
    var ret=tkMakeServerCall("web.DHCPE.TransAdmInfo","UpdateAdmDate",PreIADM,Date);
    if(ret=="0"){
        $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
        $('#UpdatePreDateWin').dialog('close');     
        
    }
}
function InitPreIADMFindGrid(){
    $HUI.datagrid("#PreIADMFindGrid",{
        url:$URL,
        fit : true,
        border : false,
        striped : false, //设置为 true，则把行条纹化（即奇偶行使用不同背景色）
        fitColumns : false,
        autoRowHeight : false,
        rownumbers:true,
        pagination : true,  
        rownumbers : true,  
        pageSize: 50,
        pageList : [50,100,150],
        singleSelect: false,
        checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
        selectOnCheck: true,
        
        queryParams:{
            ClassName:"web.DHCPE.PreIADM",
            QueryName:"SearchPreIADM",
            RegNo:$("#RegNo").val(),
            Name:$("#Name").val(),
            PEStDate:$("#PEStDate").datebox('getValue')
        

        },
        frozenColumns:[[
            {title: '选择',field: 'Select',width: 60,checkbox:true},
            {field:'PrintBarCode',width:80,title:'打印条码',
            formatter:function(value,rowData,rowIndex){ 
                    
                if((rowData.TAdmIdPIDM!="")&&(rowData.PIADM_Status_Desc!=$g("取消体检"))){
                    return "<span style='cursor:pointer;padding:0 10px 0px 30px' class='icon-print' title='打印条码' onclick='BPrintBarCode("+rowData.TAdmIdPIDM+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                   
                }
            }},
            {field:'TItemListNew',width:100,title:'查看预约项目',
                formatter:function(value,rowData,rowIndex){ 
                    
                if((rowData.TAdmIdPIDM!="")&&(rowData.PIADM_Status_Desc!=$g("取消体检"))){
                    return "<span style='cursor:pointer;padding:0 10px 0px 30px' class='icon-paper' title='项目明细' onclick='BItemList("+rowData.TAdmIdPIDM+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                   
                }
            }},
    
            {field:'PIADM_PIBI_DR_RegNo',width:110,title:'登记号',sortable:true},
            {field:'PIADM_PIBI_DR_Name',width:110,title:'姓名',
            formatter:function(value,rowData,rowIndex){ 
                    if(rowData.PIADM_RowId!=""){
                        return "<a href='#'  class='grid-td-text' onclick=BModifyName("+rowData.PIADM_RowId+"\)>"+value+"</a>";
            
                    }else{return value}
                    
                    
    
            }},
            {field:'TNewHPNo',width:110,title:'体检号',sortable:true}
            
        ]],
        columns:[[
        
        
            {field:'TAdmIdPIDM',title:'TAdmIdPIDM',hidden: true},
            {field:'PIADM_PGADM_DR',title:'PIADM_PGADM_DR',hidden: true},
            {field:'PIADM_PIBI_DR',title:'PIADM_PIBI_DR',hidden: true},
            {field:'PIADM_RowId',title:'PIADM_RowId',hidden: true},
            {field:'PIADM_PGADM_DR_Name',width:130,title:'团体名称'},
            {field:'PIADM_PGTeam_DR_Name',width:100,title:'分组'},
            {field:'TAdmDate',width:100,title:'操作日期',
            formatter:function(value,rowData,rowIndex){ 
                    if(rowData.TAdmIdPIDM!=""){
                        return "<a href='#'  class='grid-td-text' onclick=BAdmRecordList("+rowData.TAdmIdPIDM+"\)>"+value+"</a>";
            
                    }else{return value}
                    
                    
    
            }},
            {field:'PIADM_PEDateBegin',width:100,title:'开始日期',sortable:true,
            formatter:function(value,rowData,rowIndex){ 
                    if(rowData.PIADM_RowId!=""){
                        return "<a href='#'  class='grid-td-text' onclick=UpdatePreDate("+rowData.PIADM_RowId+"\)>"+value+"</a>";
            
                    }else{return value}
                    
                    
    
            }},
            {field:'PIADM_VIP',width:80,title:'VIP等级'},
            {field:'PIADM_AsCharged',width:80,title:'视同收费'},
            {field:'TPatItemPrtFlag',width:90,title:'导诊单打印',align:'center',
            formatter:function(value,rowData,rowIndex){
                    var rvalue="",checked="";
                    if(value!=""){
                        if (value=="Y") {checked="checked=checked"}
                        else{checked=""}
                        var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"    
                        return rvalue;
                    }
                
                }},
            {field:'PIADM_ChargedStatus_Desc',width:80,title:'收费状态',
            formatter:function(value,rowData,rowIndex){ 
                    if((rowData.PIADM_RowId!="")&&(value!=$g("没有项目(未登记)"))){
                        var flag = tkMakeServerCall("web.DHCPE.PreAudit","IsExsistIItem",rowData.PIADM_RowId)
                        if(flag =="1"){
                            return "<a href='#' class='grid-td-text' onclick=BPreAuditList("+rowData.PIADM_RowId+"\)>"+value+"</a>";
                        }else{
                            return value;
                        }

            
                    }else{return value}
                    
                    
    
            }},
            {field:'PIADM_Status_Desc',width:80,title:'预约状态'},
            {field:'TReportStatus',width:80,title:'报告状态'},
            {field:'TOrdEnt',width:120,title:'套餐'},
            {field:'PIADM_PEDateEnd',width:100,title:'结束日期'},
            {field:'PIADMRemark',width:100,title:'视同收费备注'},
            {field:'TAsType',width:100,title:'视同收费类型'},
            {field:'TRoomPlace',width:120,title:'诊室位置',
            formatter:function(value,rowData,rowIndex){ 
                    if(rowData.PIADM_RowId!=""){
                        return "<a href='#'  class='grid-td-text' onclick=BChangeRoomPlace("+rowData.PIADM_RowId+"\)>"+value+"</a>";
            
                    }else{return value}
                    
                    
    
            }},
            {field:'TGetCheckDate',width:100,title:'检查日期'},
            {field:'TAccountAmount',width:80,title:'应收金额',align:'right'},
            {field:'TFactAmount',width:80,title:'优惠金额',align:'right'},
            {field:'TCheckNum',width:80,title:'已检次数'},
            {field:'TDiet',width:60,title:'就餐',align:'center',
            formatter:function(value,rowData,rowIndex){
                    var rvalue="",checked="";
                    if(value!=""){
                        if (value=="1") {checked="checked=checked"}
                        else{checked=""}
                        var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"    
                        return rvalue;
                    }
                
            }},
            {field:'PIBI_IDCard',width:150,title:'证件号'},
            {field:'TPACCardType',width:100,title:'证件类型'},
            {field:'TAge',width:60,title:'年龄'},
            {field:'TType',width:60,title:'职位'},
            {field:'TPosition',width:60,title:'部门'},
            {field:'PIADMPIBI_DR_SEX',width:60,title:'性别'},
            {field:'TMarryDesc',width:60,title:'婚姻'},
            {field:'PIADM_PEDeskClerk_DR_Name',width:60,title:'接待人'},
            {field:'TGetReportDate',width:100,title:'取报告日期'},
            {field:'PGBI_Tel1',width:100,title:'联系电话'},
            {field:'THMS',width:80,title:'调查问卷',
                formatter:function(value,rowData,rowIndex){ 
                    
                if(rowData.PIADM_RowId!=""){
                    return '<a><img style="padding:0 10px 0px 20px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png"  title="调查问卷" border="0" onclick="BHMS('+rowData.PIADM_RowId+')"></a>';
                    
                }
            }},
            
    {field:'TMark',width:120,title:'备注',editor:{type:'textarea',options:{height:'30px'}}}
                    
        
            
        ]],
        onClickRow: onClickRow,
        onAfterEdit: function(index, rowdata, changes) {
            if(rowdata.PIADM_RowId==""){
                    //$.messager.alert("提示","合计行不需要保存备注",'info');
                    return false;
            }else{
                var ret = tkMakeServerCall("web.DHCPE.PreIADM","UpDateMark",rowdata.PIADM_RowId,rowdata.TMark);
                if(ret=="0"){ $.messager.alert("提示","保存成功",'success');}
            }
            

        },
        onSelect: function (rowIndex, rowData) {
        

        // 如果之前存在已经存在领取方式和备注，显示在右边 如果不存在默认 start
        var ItemStr=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetSendReportCode",rowData.PIADM_RowId)
        setValueById("PatInfoArr","&nbsp;&nbsp;"+$g("姓名：")+rowData.PIADM_PIBI_DR_Name+"&nbsp;&nbsp;&nbsp;&nbsp;"+$g("体检号：")+rowData.TNewHPNo);
        setValueById("Remark",ItemStr.split("^")[0]);
        $("#ReportDate").datebox('setValue',ItemStr.split("^")[1]);   
        $("#SendMethod").combobox('setValue',ItemStr.split("^")[2]);
        // 如果之前存在已经存在领取方式和备注，显示在右边 如果不存在默认 end
        
        iniForm();

        var Status=rowData.PIADM_Status_Desc;
        if((Status==$g("取消体检"))||(Status=="")){
            $("#BModifyTest,#BPrint,#BPrintView,#PrintPayAagin,#BPreviewReport,#BUpdateVIPLevel,#BUpdateDepart,#BAsCharged,#BUnArrived,#UpdatePreAudit,#CancelPE,#PrintAagin").linkbutton('disable');
            if(Status==""){$("#UnCancelPE").linkbutton('disable') }
            else{$("#UnCancelPE").linkbutton('enable') }

        }else{
            $("#BModifyTest,#BPrint,#BPrintView,#PrintPayAagin,#BPreviewReport,#BUpdateVIPLevel,#BUpdateDepart,#BAsCharged,#BUnArrived,#UpdatePreAudit,#CancelPE,#PrintAagin").linkbutton("enable");
                         
        }
        
        $("#PAADM").val(rowData.TAdmIdPIDM);
        $('#OrderItemListGrid').datagrid('loadData', {
                total: 0,
                rows: []
            });
        LoadOrderItemListGrid(rowData);
        
        

        //公费
        var GName=rowData.PIADM_PGADM_DR_Name;
        if(GName==""){
            $("#AddType").checkbox("disable");
            $("#AddType").checkbox('setValue',false);
        }else{
            $("#AddType").checkbox("enable");
        }
        
                    
                    
        },
         onLoadSuccess: function(data) {
            editIndex = undefined;
        },
            
    })
}

//列表编辑
var editIndex = undefined;
var modifyBeforeRow = "";
var modifyAfterRow = "";

//结束行编辑
function endEditing() {

    if (editIndex == undefined) {
        return true
    }
    if ($('#PreIADMFindGrid').datagrid('validateRow', editIndex)) {

        $('#PreIADMFindGrid').datagrid('endEdit', editIndex);



        editIndex = undefined;
        return true;
    } else {
        return false;
    }

}

//点击某行进行编辑
function onClickRow(index, value) {
    if (editIndex != index) {
        if (endEditing()) {
            $('#PreIADMFindGrid').datagrid('selectRow', index)
                .datagrid('beginEdit', index);
            editIndex = index;
            modifyBeforeRow = $('#PreIADMFindGrid').datagrid('getRows')[index]['TMark']

        } else {
            $('#PreIADMFindGrid').datagrid('selectRow', editIndex);
        }


    }

}




function InitCombobox(){
    

    //VIP等级 
    var VIPObj = $HUI.combobox("#VIPLevel",{
        url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
        valueField:'id',
        textField:'desc',
        });
        
        
        //复查
    var ReCheckObj = $HUI.combobox("#ReCheck",{
        valueField:'id',
        textField:'text',
        panelHeight:'70',
        data:[
           {id:'0',text:$g('非复查')},
           {id:'1',text:$g('复查')},
        ]

    });
    
    
    //性别
    var SexObj = $HUI.combobox("#Sex",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindSex&ResultSetType=array",
        valueField:'id',
        textField:'sex',
        panelHeight:'130',
    });
    
    
    //视同收费类型
    var AsTypeObj = $HUI.combobox("#AsType",{
        valueField:'id',
        textField:'text',
        panelHeight:'130',
        data:[
           {id:'1',text:$g('遗留数据')},
            {id:'2',text:$g('领导特批')},
            {id:'3',text:$g('其他')},
            {id:'4',text:$g('转账')}

        ]

    });
    
    //收费状态
    var ChargeStatusObj = $HUI.combobox("#ChargeStatus",{
        valueField:'id',
        textField:'text',
        panelHeight:'130',
        data:[
             {id:'0',text:$g('未付费')},
            {id:'1',text:$g('部分收费')},
            {id:'2',text:$g('全部收费')},
            {id:'3',text:$g('没有项目')},
            {id:'4',text:$g('定额卡')},
            {id:'5',text:$g('挂账')}
        ]

    });
    
    //团体
    var GroupDescObj = $HUI.combogrid("#GroupDesc",{
        panelWidth:540,
        url:$URL+"?ClassName=web.DHCPE.PreGADM&QueryName=SearchPreGADMShort",
        mode:'remote',
        delay:200,
        pagination : true, 
        pageSize: 20,
        pageList : [20,50,100],
        idField:'Hidden',
        textField:'Name',
        onBeforeLoad:function(param){
            param.Code = param.q;
            param.ShowPersonGroup="1";
			param.CSPName="dhcpepreiadmfind.hisui.csp"
        },
        onChange:function()
        {
            TeamDescObj.clear();
        },
        onShowPanel:function()
        {
            $('#GroupDesc').combogrid('grid').datagrid('reload');
        },
        columns:[[
            {field:'Hidden',title:'ID',hidden: true},
            {field:'Name',title:'名称',width:150},
            {field:'Code',title:'编码',width:100},
            {field:'Begin',title:'预约开始日期',width:100},
            {field:'End',title:'预约结束日期',width:100},
            {field:'DelayDate',title:'状态',width:60},
                    
        ]]
        });
        
        
        //分组
        var TeamDescObj = $HUI.combogrid("#TeamDesc",{
        panelWidth:400,
        url:$URL+"?ClassName=web.DHCPE.PreGTeam&QueryName=SearchGTeam",
        mode:'remote',
        delay:200,
        pagination : true, 
        pageSize: 20,
        pageList : [20,50,100],
        idField:'PGT_RowId',
        textField:'PGT_Desc',
        onBeforeLoad:function(param){
            
            var PreGId=$("#GroupDesc").combogrid("getValue");
            param.ParRef = PreGId;
            param.GTeam= param.q;
        },
       
        onShowPanel:function()
        {
            $('#TeamDesc').combogrid('grid').datagrid('reload');
        },
        columns:[[
            {field:'PGT_RowId',hidden:true},
            {field:'PGT_ParRef_Name',title:'团体名称',width:240},
            {field:'PGT_Desc',title:'分组名称',width:150}
        ]]
        });
        
        //部门
        var DepartNameObj = $HUI.combogrid("#DepartName",{
        panelWidth:110,
        url:$URL+"?ClassName=web.DHCPE.PreGTeam&QueryName=SearchGDepart",
        mode:'remote',
        delay:200,
        idField:'DepartName',
        textField:'DepartName',
        onBeforeLoad:function(param){
            
            var PreGId=$("#GroupDesc").combogrid("getValue");
            var PreTId=$("#TeamDesc").combogrid("getValue");
             
            param.GID = PreGId;
            param.TeamID = PreTId;
            param.Type = "PGADM";
            param.Depart= param.q;
        },
       
        onShowPanel:function()
        {
            $('#DepartName').combogrid('grid').datagrid('reload');
        },
        columns:[[
            {field:'DepartName',title:'部门',width:100}
        ]]
        });




    //送达方式
    var SendMethodObj = $HUI.combobox("#SendMethod",{
        valueField:'id',
        textField:'text',
        panelHeight:'140',
        data:[
            {id:'ZQ',text:$g('自取')},
            {id:'TQ',text:$g('统取')},
            {id:'KD',text:$g('快递')},
            {id:'DY',text:$g('电邮')},
            {id:'DZB',text:$g('电子版')},
           
        ]

      });
    
    // 是否做完出总检
    var IfComplateAll = $HUI.combobox("#IfComplateAll",{
        valueField:'id',
        textField:'text',
        panelHeight:'140',
        data:[
            {id:'Y',text:$g('是')},
            {id:'N',text:$g('否')}   
           
        ]

    });
}


function CardNoKeydownHandler(){
        var CardNo=$("#CardNo").val();
        if (CardNo=="") return;
        CheckCardNo();
        return false;
    
}
function CheckCardNo(){
    var CardNo=$("#CardNo").val();
    if (CardNo=="") return false;
    var myrtn=DHCACC_GetAccInfo("",CardNo,"","",CardNoKeyDownCallBack);
}


//读卡
function ReadCardClickHandler()
{
    var myrtn=DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
    
}

function CardNoKeyDownCallBack(myrtn){
    //alert(myrtn)
    var CardNo=$("#CardNo").val();
    var CardTypeNew=$("#CardTypeNew").val();
    $(".textbox").val('');
    $("#CardTypeNew").val(CardTypeNew);
   var myary=myrtn.split("^");
   var rtn=myary[0];
   if ((rtn=="0")||(rtn=="-201")){
         var PatientID=myary[4];
            var PatientNo=myary[5];
            var CardNo=myary[1]
             $("#CardTypeNewID").val(myary[8]);
            $("#CardNo").focus().val(CardNo);
            $("#RegNo").val(PatientNo);
            BFind_click();
    }else if(rtn=="-200"){
         $.messager.alert("提示","卡无效","info",function(){$("#CardNo").focus();});
        
        
        return false;
    }
}

//读身份证
function ReadRegInfo_OnClick()
{
  
    var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
    var rtn=tkMakeServerCall("DHCDoc.Interface.Inside.Service","GetIECreat")
    var myHCTypeDR=rtn.split("^")[0];
    var myInfo=DHCWCOM_PersonInfoRead(myHCTypeDR);
    var myary=myInfo.split("^");
    if(myary=="0")
    {
        $.messager.alert("提示","读卡失败或者没有读卡器！","info");
        return false;
    }
    if (myary[0]=="-1"){
        $.messager.alert("提示",myary[1],"info");
        return false;
    }
     if (myary[0]=="0")
     { 
     
         SetPatInfoByXML(myary[1]); 
        var IDCard=$("#IDCard").val();
     }
   
     
     var RegNo=tkMakeServerCall("web.DHCPE.PreIBaseInfo","GetRegNoByIDCard",IDCard);
     if (RegNo==""){
        return false;
    }
    $("#RegNo").val(RegNo)
    BFind_click();
     
   }

var myCombAry=new Array(); 
function SetPatInfoByXML(XMLStr)
{
    XMLStr = "<?xml version='1.0' encoding='gb2312'?>" + XMLStr
    var xmlDoc=DHCDOM_CreateXMLDOMNew(XMLStr);
    if (!xmlDoc) return;
    
    //var xmlDoc=DHCDOM_CreateXMLDOM();
    //xmlDoc.async = false;
    //xmlDoc.loadXML(XMLStr);
    /*
    if(xmlDoc.parseError.errorCode != 0) 
    {    
        $.messager.alert("提示",xmlDoc.parseError.reason,"info");
        return; 
    }
    */
    var nodes = xmlDoc.documentElement.childNodes;
    if (nodes.length<=0){return;}
    for (var i = 0; i < nodes.length; i++) {
        
        var myItemName = getNodeName(nodes,i);
        
        var myItemValue = getNodeValue(nodes,i);
        
        //姓名
        if(myItemName=="Name") $("#Name").val(myItemValue);
        
       //身份证号
       if(myItemName=="CredNo") {$("#IDCard").val(myItemValue);}
        
       if (myCombAry[myItemName]){
            myCombAry[myItemName].setComboValue(myItemValue);

        }else{
            DHCWebD_SetObjValueXMLTrans(myItemName, myItemValue);
        }
    }
    delete(xmlDoc);
}


function BClear_click()
{
    $("#RegNo,#CardTypeNew,#CardNo,#Name,#AsRemark,#Remark,#PAADM").val("");
    $("#PEStDate").datebox('setValue',"");
    $("#EndDate").datebox('setValue',"");
    $("#DelayDate").datebox('setValue',"");
    setValueById("PatInfoArr","");
    $(".hisui-combobox").combobox('select','');
    
    $("#GroupDesc").combogrid('setValue',"");
    $("#TeamDesc").combogrid('setValue',"");
    $("#DepartName").combogrid('setValue',"");
    $(".hisui-checkbox").checkbox('setValue',false);
    $("#BModifyTest,#BPrint,#BPrintView,#PrintPayAagin,#BPreviewReport,#BUpdateVIPLevel,#BUpdateDepart,#BAsCharged,#BUnArrived,#UpdatePreAudit,#CancelPE").linkbutton("enable");
    
     iniForm(); 

    SetDefault();

    DefaultReportDate();

    InitPreIADMFindGrid();

    InitOrderItemListGrid();

}

function LoadOrderItemListGrid(rowData)
{
     $("#PAADM").val();
     $('#OrderItemListGrid').datagrid('load', {
            ClassName:"web.DHCPE.PreIADM",
            QueryName:"OrdItemStatus",
            EpisodeID:rowData.TAdmIdPIDM,
			CSPName:"dhcpepreiadmfind.hisui.csp"
        
        });
    
    
    
}


function InitOrderItemListGrid()
{
    
        $HUI.datagrid("#OrderItemListGrid",{
        url:$URL,
        fit : true,
        border : false,
        striped : true,
        fitColumns : false,
        autoRowHeight : false,
        rownumbers:true,
        pagination : true,  
        rownumbers : true,  
        pageSize: 100,
        pageList : [100,200],
        displayMsg:"",//隐藏分页下面的文字"显示几页到几页,共多少条数据"
        singleSelect: false,
        selectOnCheck: true,
        //sortName:"Ord_ItemStatus",
        //sortOrder:"desc",
        queryParams:{
            ClassName:"web.DHCPE.PreIADM",
            QueryName:"OrdItemStatus",
			CSPName:"dhcpepreiadmfind.hisui.csp"
        },
        
        columns:[[
            {title: '选择',field: 'Select',width: 60,checkbox:true},
            {field:'Ord_ItemID',title:'ID',hidden: true},
            {field:'Ord_ItemDesc',width:120,title:'项目名称'},
            {field:'Ord_ItemStatus',width:55,title:'状态',sortable:true},
            {field:'Bill_Status',width:100,title:'收费状态'},
            {field:'Ord_Doctor',width:80,title:'医生',},
            {field:'Ord_Date',width:120,title:'检查日期',}
            
        ]],
        
    
    })
}


//默认报告约期
function DefaultReportDate()
{
    var mydate = new Date();
    var CurMonth=mydate.getMonth()+1;
    if((CurMonth<=9)&&(CurMonth>=0)){var CurMonth="0"+CurMonth;}
    var CurDate=mydate.getFullYear()+"-"+CurMonth+"-"+ mydate.getDate(); 
    var CurDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",CurDate);
    var CurDate=tkMakeServerCall("websys.Conversions","DateLogicalToHtml",parseInt(CurDate)+7);
    $("#ReportDate").datebox('setValue',CurDate) 
    $("#SendMethod").combobox('setValue',"DZB");
    $("#IfComplateAll").combobox('setValue',"Y");
}


//收表操作
function BRecpaper_click()
{   
    
    var PAADM=$("#PAADM").val();
    if(PAADM==""){
           $.messager.alert("提示","请选择待收表的就诊记录！","info");
           return false;
        }
  
        
    var RecpaperFlag=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetRecpaperFlag",PAADM);
    if(RecpaperFlag=="1"){
        $.messager.alert("提示","不是到达状态，不能收表！","info");
        return false;
    }else if(RecpaperFlag=="2"){
        $.messager.alert("提示","已收表，不能重复收表！","info");
        return false;
    }else if(RecpaperFlag=="3"){
        $.messager.confirm("删除", "有未执行的项目，确定要收表吗?", function (r) {
        if (r) {
            var PayFlag=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetOEItemNoPay",PAADM);
            if(PayFlag=="0"){
                $.messager.confirm('确定', '存在未付费项目，是否继续收表？', function(t) {
                    if(t){ 
                        RecpaperCommon(PAADM); 
                    }
                    else{
                        return; 
                    }
                });
            }else{
                RecpaperCommon(PAADM);
            }
                
        } else {
                return;
            }
        }); 
   } else{
        RecpaperCommon(PAADM);
   }    
      
}

//收表
function RecpaperCommon(PAADM)
{
    var iReportDate=$("#ReportDate").datebox('getValue');
    if(iReportDate==""){
        $.messager.alert("提示","请选择报告约期！","info");
        return false;
    }
    
    var iSendMethod=$("#SendMethod").combobox("getValue"); 
    if (($("#SendMethod").combobox("getValue")==undefined)||($("#SendMethod").combobox("getValue")=="")){var iSendMethod="";}
    if(iSendMethod==""){
        $.messager.alert("提示","请选择送达方式！","info");
         return false;
    }
        
    var iRemark=$("#Remark").val(); 
    var Return=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetRecPaperNew",PAADM,iReportDate,iSendMethod,iRemark);
    var ret=Return.split("#");
    if (ret[0]!=0)
    { 
        $.messager.alert("提示",ret[0],"info");
    }else{
        $.messager.alert("提示","收表成功！","success");
        var flag=tkMakeServerCall("web.DHCPE.TransResult","TransMain",PAADM);
        if(ret[1]=="Y"){
            var value=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetBaseInfo",PAADM,iReportDate);
            if(value!=""){
                PrintGetReportPT(value); 
              }//打印取报告凭条
        }
            
   }
            
}
///取消收表
function CancelPaper(PIADM)
{
    
    if (PIADM=="")  {
        $.messager.alert("提示","请选择待取消收表的客户！","info");
        return false
    } 
    else{ 
        $.messager.confirm("确认", "确定要取消吗？", function(r){
        if (r){
            
            $.m({ ClassName:"web.DHCPE.DHCPEIAdm", MethodName:"CancelRecPaper",PIADM:PIADM},function(ReturnValue){
                //alert(ReturnValue)
                if (ReturnValue!='0') {
                    $.messager.alert("提示","取消收表失败"+flag,"error");  
                }else{
                    $.messager.popover({msg: '取消收表成功！',type:'success',timeout: 1000});
                    BFind_click();
     
                }
            }); 
        }
    });
    }       

}

//放弃检查
function BRefuseCheck_click()
{
    var UserID=session['LOGON.USERID'];
    var OrdIDS=GetSelectItemId();
    
    if(OrdIDS==""){
            $.messager.alert("提示","您没有选择放弃检查的项目！","info");
            return false;
        }
        
    var OrdStr=OrdIDS.split("^");
    
    for(i=0;i<OrdStr.length;i++)
    { 
        var OEID=OrdStr[i].split(";")[0]
        var Status=OrdStr[i].split(";")[1]
        if(!((Status=="未检")||(Status=="延期"))){
           $.messager.alert("提示","只能操作未检、延期医嘱！","info");
            return false;
        }else{
            
        }
    }
    
    //$("#SelectA").checkbox('setValue',false);
    $.messager.confirm('确定', '确定要放弃检查吗？', function(t) {
        if (t) {
            var ret=tkMakeServerCall("web.DHCPE.ResultEdit","BatchRefuseCheck",OrdIDS,UserID);
            $('#OrderItemListGrid').datagrid('load', {
                ClassName:"web.DHCPE.PreIADM",
                QueryName:"OrdItemStatus",
                EpisodeID:$("#PAADM").val(),
				CSPName:"dhcpepreiadmfind.hisui.csp"
                
            })

        }
    });
        
}

// 撤销放弃检查
function UnBRefuseCheck_click()
{
    var UserID=session['LOGON.USERID'];
    var OrdIDS=GetSelectItemId();
    
    if(OrdIDS==""){
            $.messager.alert("提示","您没有选择撤销放弃检查的项目！","info");
            return false;
        }
        
    var OrdStr=OrdIDS.split("^");
    
    for(i=0;i<OrdStr.length;i++)
    { 
        var OEID=OrdStr[i].split(";")[0]
        var Status=OrdStr[i].split(";")[1]
        if(Status!="弃检"){
           $.messager.alert("提示","只能操作已放弃检查的医嘱！","info");
            return false;
        }else{
           
        }
    }
    
        
    $.messager.confirm('确定', '确定要撤销弃检吗？', function(t) {
        if (t) {
            var ret=tkMakeServerCall("web.DHCPE.ResultEdit","BatchRefuseCheck",OrdIDS,UserID);
    
            $('#OrderItemListGrid').datagrid('load', {
                ClassName:"web.DHCPE.PreIADM",
                QueryName:"OrdItemStatus",
                EpisodeID:$("#PAADM").val(),
				CSPName:"dhcpepreiadmfind.hisui.csp"
        
            })  
        }
    })
}


//延期检查  DoType :0  延期，1：撤销延期
function BExtension_click(DoType)
{
    var UserID=session['LOGON.USERID'];
    var OrdIDNewS="";
    var PAADM=$("#PAADM").val();
    if(PAADM==""){
           $.messager.alert("提示","请选择待延期的就诊记录！","info");
           return false;
        }
    var OrdIDS=GetSelectItemId();
    if(OrdIDS==""){
            $.messager.alert("提示","您没有选择项目！","info");
            return false;
        }

    var OrdStr=OrdIDS.split("^");
    for(i=0;i<OrdStr.length;i++)
    { 
        var OEID=OrdStr[i].split(";")[0];
        var Status=OrdStr[i].split(";")[1];
        if((Status!=$g("未检"))&&(DoType=="0"))  continue;
        if((Status!=$g("延期"))&&(DoType=="1"))  continue;
        if(OrdIDNewS==""){ var OrdIDNewS=OEID;}
        else{var OrdIDNewS=OrdIDNewS+","+OEID;}
       
    }
    if(OrdIDNewS==""){
        $.messager.alert("提示","没有符合条件的项目！","info");
        return false;
    }
    
    

    if(DoType=="0"){

        var iDelayDate=$("#DelayDate").datebox('getValue')
        if(iDelayDate==""){
            $.messager.alert("提示","没选择延期日期！","info");
            return false;
        }

        var today = getDefStDate(0);
        var todayLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",today);
        var YQDateLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",iDelayDate);
        if(YQDateLogical<=todayLogical){
            $.messager.alert("提示","延期日期应大于今天","info");  
            return false;
        }

        var iIfComplateAll=$("#IfComplateAll").combobox("getValue");
        if (($("#IfComplateAll").combobox("getValue")==undefined)||($("#IfComplateAll").combobox("getValue")=="")){var iIfComplateAll="";}
        if(iIfComplateAll==""){
            $.messager.alert("提示","没选择全部做完再总检！","info");
            return false;
        }

        var Return=tkMakeServerCall("web.DHCPE.OrderPostPoned","DelayRecord",PAADM,iDelayDate,iIfComplateAll,OrdIDNewS,UserID);
        var ret=Return.split("#");
        if((ret>0)||(ret==0)){
            $.messager.alert("提示","延期成功！","success");   
        }else{
            $.messager.alert("提示","延期失败！","error"); 
            return false;
        }
    }
    if(DoType=="1"){
        var OrdIDNewS=OrdIDNewS.replace(/,/g,"^");
        //alert(OrdIDNewS)
        var Return=tkMakeServerCall("web.DHCPE.OrderPostPoned","CancelDelay",OrdIDNewS,UserID);
        if((Return>0)||(Return==0)){
            $.messager.alert("提示","撤销延期成功！","success"); 
        }else{
            $.messager.alert("提示","撤销延期失败！","error");   
            return false;
        }
    }
    $('#OrderItemListGrid').datagrid('load', {
                      ClassName:"web.DHCPE.PreIADM",
                      QueryName:"OrdItemStatus",
                      EpisodeID:$("#PAADM").val(),
					  CSPName:"dhcpepreiadmfind.hisui.csp"
        
                    });
    //$("#SelectA").checkbox('setValue',false);         
    
}


///手动置已检
function BChecked_click(DoType)
{
    var UserID=session['LOGON.USERID'];
    var OrdIDNewS="";
    if(DoType=="0"){var MessageInfo=$g("已检更新成功！");}
    if(DoType=="1"){var MessageInfo=$g("撤销已检更新成功！");}
    
    var PAADM=$("#PAADM").val();
    if(PAADM==""){
           $.messager.alert("提示","请选择待置状态的记录！","info");
           return false;
        }
    var OrdIDS=GetSelectItemId();
    if(OrdIDS==""){
            $.messager.alert("提示","您没有选择项目！","info");
            return false;
        }
    
    var OrdStr=OrdIDS.split("^");
    for(i=0;i<OrdStr.length;i++)
    { 
        var OEID=OrdStr[i].split(";")[0];
        var Status=OrdStr[i].split(";")[1];
        if((Status!=$g("未检"))&&(DoType=="0"))  continue;
        if((Status!=$g("已检"))&&(DoType=="1"))  continue;
        if(OrdIDNewS==""){ var OrdIDNewS=OEID;}
        else{var OrdIDNewS=OrdIDNewS+"^"+OEID;}
       
    }
    if(OrdIDNewS==""){
        $.messager.alert("提示","没有符合条件的项目！","info");
        return false;
    }
    var Return=tkMakeServerCall("web.DHCPE.DHCPEIAdm","SetSubStatus",PAADM,OrdIDNewS,DoType,UserID);
    var ret=Return.split("#");
    if (ret[0]!=0)
    { 
        $.messager.alert("提示",ret[0],"info");
    }else{
            $.messager.alert("提示",MessageInfo,"success");   
            
        }
    $('#OrderItemListGrid').datagrid('load', {
                      ClassName:"web.DHCPE.PreIADM",
                      QueryName:"OrdItemStatus",
                      EpisodeID:$("#PAADM").val(),
					 CSPName:"dhcpepreiadmfind.hisui.csp"
        
                    });
    //$("#SelectA").checkbox('setValue',false);             
    
}



function GetSelectItemId() 
{   
 
    var IDs="";
    var selectrow = $("#OrderItemListGrid").datagrid("getChecked");//获取的是数组，多行数据
     
    for(var i=0;i<selectrow.length;i++){
        
        var ItemID=selectrow[i].Ord_ItemID;
        var Status=selectrow[i].Ord_ItemStatus;
        
         if(ItemID==""){
            break;
         }
            if (IDs==""){
                IDs=ItemID+";"+Status;
            }else{
                IDs=IDs+"^"+ItemID+";"+Status;
            }
    }
    
    return IDs;
}








