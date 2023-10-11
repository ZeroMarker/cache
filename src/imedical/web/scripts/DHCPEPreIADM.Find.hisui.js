
//����    DHCPEPreIADM.Find.hisui.js
//����    ����ԤԼ��ѯ
//����    2020.11.06
//������  xy

$(function(){
            
    InitCombobox();
    
    //��ʼ������ԤԼ��ѯ����
    InitPreIADMFindGrid();  
    
    //��ʼ����Ŀ��ϸ����
    InitOrderItemListGrid();  
   
    SetDefault();
    
    //Ĭ�ϱ���Լ��
    DefaultReportDate()
    
    //��ѯ
    $("#BFind").click(function() {  
        BFind_click();      
        });

      //����
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

      
   //ȡ�����
   $("#CancelPE").click(function() {    
        CancelPE();     
        });

    //����ȡ�����
     $("#UnCancelPE").click(function() {    
        UnCancelPE();       
        });
    
    //����/ȡ������
     $("#BUnArrived").click(function() {    
        IAdmAlterStatus();      
        });
    
    //ȡ��/��ͬ�շ�
    $("#BAsCharged").click(function() { 
        UpdateAsCharged();      
        });

    //����
    $("#UpdatePreAudit").click(function() { 
        UpdatePreAudit();       
        });
        
    //�޸���Ŀ
    $("#BModifyTest").click(function() {
            BModifyTest_click();            
        });
     
    //��ӡ
    $("#BPrint").click(function() {
            BPrint_click();         
        });
     
    //����
    $("#PrintAagin").click(function() {
            PrintAagin_click();         
        });    
          
    //ָ������ӡԤ��
    $("#BPrintView").click(function() {
            PatItemPrintXH();           
        });
    
    //�����շ�����
    $("#PrintPayAagin").click(function() {
            PrintPayAagin_Click();          
        });
     
     //����Ԥ��
     $("#BPreviewReport").click(function() {
            PreviewAllReport();         
        });

    //�޸�VIP
     $("#BUpdateVIPLevel").click(function() {
            BUpdateVIPLevel_click();            
        });
    
    //�޸Ĳ���
    $("#BUpdateDepart").click(function() {
            BUpdateDepart_click();          
        });
    
     //����
      $("#BReadCard").click(function() {
            ReadCardClickHandler();         
        });
    
      $("#CardNo").keydown(function(e) {
            
            if(e.keyCode==13){
                CardNoKeydownHandler();
            }
            
        }); 

    
    //�����֤
     $("#ReadRegInfo").click(function() {
            ReadRegInfo_OnClick();          
        });
      
      
     //�ձ�
    $("#BRecpaper").click(function() {  
        BRecpaper_click();      
        });
        
    //����
    $("#BDelayed").click(function() {   
        BExtension_click("0"); 
    }); 
    
    //��������
    $("#BCancelDelayed").click(function() { 
        BExtension_click("1"); 
    }); 
    
    //�������
    $("#BRefuseCheck").click(function() {   
        BRefuseCheck_click();       
    }); 
    
     //�����������
    $("#UnBRefuseCheck").click(function() { 
        UnBRefuseCheck_click();     
        }); 
     
    //�ֶ����Ѽ�״̬
    $("#BChecked").click(function() {   
        BChecked_click("0");        1
        });  
    
    //�����Ѽ�״̬
    $("#BCancelChecked").click(function() { 
        BChecked_click("1");        
        });     
    
   
    //ȫѡδ��
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
    
    //ȡ��/��ͬ�շ�
    if(OPflagOne[1]=="Y"){
        $("#BAsCharged").linkbutton('enable');
    }else{
        $("#BAsCharged").linkbutton('disable');
    }
    
    //����
    if(OPflagOne[0]=="N"){
        $("#UpdatePreAudit").linkbutton('disable');
    } else{
        $("#UpdatePreAudit").linkbutton('enable');
    }   

}

//���汸ע 
function BSaveRemark_Click(){
    
    $('#PreIADMFindGrid').datagrid('endEdit', editIndex); //���һ�н����б༭   

    $.messager.confirm('ȷ��', 'ȷ��Ҫ����������', function(t) {
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
//ָ������ӡԤ��
function PatItemPrintXH()
{

    var viewmark=2;
    var NoPrintAmount="N";
    var NoPrintAmount=$("#NoPrintAmount").checkbox('getValue');
    if(NoPrintAmount){ var NoPrintAmount="Y";}
    else{var NoPrintAmount="N";}
    
    var AdmIdStr=GetSelectIADM();
    if(AdmIdStr==""){
            $.messager.alert("��ʾ","��û��ѡ��ͻ�","info");
            return false;
        }
    if(AdmIdStr.split(";").length>1){
        
        $.messager.alert("��ʾ","ֻ�ܲ���һ��","info");
        return false;
    } 
    
    var AdmId=AdmIdStr.split("^")[0];
    if (AdmId=="") { 
        $.messager.alert("��ʾ","��û��ѡ��ͻ�,����û�еǼ�","info");
        return false;    
    }
        
    var PrintFlag=1;
    var PrintView=1;
    var Instring=AdmId+"^"+PrintFlag+"^PAADM^"+NoPrintAmount+"Y";
    var value=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetPatOrdItemInfo",'','',Instring);
    if (value=="NoPayed"){
        $.messager.alert("��ʾ","����δ������Ŀ������Ԥ��","info");
        return false;
    }
    //alert(value)
    
    PrintDJDByType(AdmId, "PAADM", "V", "");  // DHCPEPrintDJDCommon.js
    
    //PEPrintDJD("V",AdmId+"^"+NoPrintAmount,"");//DHCPEPrintDJDCommon.js  lodop��ӡ  �������ƴ���Ƿ��ӡ���ı��  Y �򲻴�ӡ��N ��ӡ
    //Print(value,PrintFlag,viewmark);  //DHCPEIAdmItemStatusAdms.PatItemPrint
    
}

 ///����Ԥ��
function PreviewAllReport()
{
    var iReportName=""; 
    var NewVerReportFlag=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",session['LOGON.CTLOCID'],"NewVerReport");
    var iReportName=tkMakeServerCall("web.DHCPE.ReportOutToWeb","GetReportPageName");
    var AdmIdStr=GetSelectIADM();
    if(AdmIdStr==""){
            $.messager.alert("��ʾ","��û��ѡ��ͻ�","info");
            return false;
        }
    if(AdmIdStr.split(";").length>1){
        
        $.messager.alert("��ʾ","ֻ�ܲ���һ��","info");
        return false;
    } 
    
    var PAADM=AdmIdStr.split("^")[0];
    
    if (PAADM=="") { 
        $.messager.alert("��ʾ","��û��ѡ��ͻ�,����û�еǼ�","info");
        $("#RegNo").focus()
        return false; 
    }
    if(NewVerReportFlag=="Lodop"){
        var Flag=tkMakeServerCall("web.DHCPE.PreIADM","IsHaveResultByPAADM",PAADM);
        if(Flag=="0"){
            $.messager.alert("��ʾ","û�������������Ԥ��","info");
             return false; 
        }

        //calPEReportProtocol("BPrintView",PAADM);
        PEPrintReport("V",PAADM,""); //lodop+cspԤ����챨��
        return false;
    }else if(NewVerReportFlag=="Word"){ 
            var Flag=tkMakeServerCall("web.DHCPE.PreIADM","IsHaveResultByPAADM",PAADM);
            if(Flag=="0"){
                $.messager.alert("��ʾ","û�������������Ԥ��","info");
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
 * [websocket �ͻ���ͨ��]
 * @param    {[Date]}    date [����]
 * @return   {[String]}         [��ʽ��������]
 * @Author   wangguoying
 * @DateTime 2021-01-28
 */
function websocoket_report(sourceID, jarPAADM) {    
    var opType = (sourceID == "BPrint" || sourceID == "NoCoverPrint") ? "2" : (sourceID == "BPrintView" ? "5" : (sourceID == "BUploadReport" ? "4" : "1"));
    var fileType = (sourceID == "BExportPDF") || (sourceID == "BUploadReport") ? "pdf" : (sourceID == "BExportHtml" ? "html" : "word");
    var execParam = {
        business: "REPORT", //����̶�ΪREPORT
        admId: jarPAADM,
        opType: opType,
        fileType: fileType,
        printType: "1" //1Ϊ���˱���
    };
    
    //��ӡԤ����������ˮӡ
    if(execParam.opType == "2") execParam.extStr="HS10322,"+session["LOGON.USERID"];
    if(execParam.opType == "5") execParam.extStr="WaterMark:PreView";
    
    var json = JSON.stringify(execParam);
    $PESocket.sendMsg(json, null);
}

//�޸Ĳ���
function BUpdateDepart_click()
{
    var IDs=GetSelectId();
    if (IDs=="") {
        $.messager.alert("��ʾ","��ѡ����Ա","info");
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
    
    $.messager.alert("��ʾ","�޸����","success");
    BFind_click();
}
//�޸�VIP
function BUpdateVIPLevel_click()
{
    var iTAdmId="",iVIP="";
    
    var iVIP=$("#VIPLevel").combobox('getValue');
    
    if(iVIP==""){
         $.messager.alert("��ʾ","��ѡ��VIP�ȼ����ٸ���","info");
        return false;
        }
        
    var IDs=GetSelectId();
    if (IDs=="") {
        $.messager.alert("��ʾ","��ѡ����Ա","info");
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
        $.messager.alert("��ʾ","������Ա�������޸�VIP�ȼ�","info");
        return false;
    }
    
    for(i=0;i<PIAdmIdStr.length;i++)
    { 
        
        var PIAdmId=PIAdmIdStr[i].split(";")[0]
        var flag=tkMakeServerCall("web.DHCPE.PreItemListEx","ChangeVipLevel",PIAdmId,iVIP);
        
    }
    
    if(i==PIAdmIdStr.length){
        
        $.messager.alert("��ʾ","�޸����","success");
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
            $.messager.alert("��ʾ","��û��ѡ��ͻ�,����û�еǼ�","info");
            websys_setfocus("RegNo");
            return false;    
        }
        
        PrintAllApp(iTAdmId,"PAADM","","Y");    //DHCPEPrintCommon.js  
    }
    $("#RegNo").focus();
    
}

//��ӡ
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
            $.messager.alert("��ʾ","��û��ѡ��ͻ�,����û�еǼ�","info");
            websys_setfocus("RegNo");
            return false;    
        }
        
        PrintAllApp(iTAdmId,"PAADM","N","",""); //DHCPEPrintCommon.js   
    }
    $("#RegNo").focus();
    
}

///�����շ�����
function PrintPayAagin_Click()
{
    
    var selectrow = $("#PreIADMFindGrid").datagrid("getChecked");//��ȡ�������飬��������
    if(selectrow.length=="0"){
            $.messager.alert("��ʾ","��û��ѡ��ͻ�,����û�еǼ�","info");
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
        //var Age=selectrow[i].TAge+' ������';
        var Age=selectrow[i].TAge;
            
        var Amount=tkMakeServerCall("web.DHCPE.HandlerPreOrds","IGetAmount4Person",PIAdmId); 
        //var Amount=tkMakeServerCall("web.DHCPE.PrintNewDirect","GetPayedAmt",PIAdmId); 
        //var FactAmount=Amount.split('^')[1]+'Ԫ';
        var FactAmount=Amount.split('^')[1]+'Ԫ'+'    ������';
        //var Info=RegNo+"^"+Name+"  "+FactAmount+"^"+"^"+"^"+"^"+Sex+String.fromCharCode(1)+"^"+Age+"^"+RegNo+"^"+NewHPNo;
        //alert(Info)
        //PrintBarRis(Info);    
        var Info=RegNo+"^"+Name+"^"+Sex+"^"+Age+"^"+FactAmount+"^"+RegNo;
        PrintBaseBar(Info);
    }
    
}

/// ��ĿԤԼҳ��
function BModifyTest_click() {
    
     var IDs="",GFlag=0,IFlag=0;
    var selectrow = $("#PreIADMFindGrid").datagrid("getChecked");//��ȡ�������飬��������
     
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
        $.messager.alert("��ʾ","�޸�ԤԼ��Ŀ,ֻ��ѡ��һ��","info");
        return false;
    }
    


    if (VIPLevel=="ְҵ��"){
        var VipFlag="dhcpeoccupationaldiseaseinfo.csp"
    }else {
        var VipFlag=""
    }
    
    if (iRowId=="") {
        $.messager.alert("��ʾ","���ȹ�ѡһ����Ա","info");
        return false;
    }
    var ret=tkMakeServerCall("web.DHCPE.PreIADM","GetPreFlag",IDs,IFlag,GFlag);
    var Str=ret.split("^");
    var flag=Str[0];
    if (flag=="1"){
            $.messager.alert("��ʾ","���˺����岻��ͬʱ����","info");
            return false;
    }else if (flag=="2"){
            $.messager.alert("��ʾ","����ͬһ��������Ա����ͬʱ����","info");
            return false;
    }else if (flag=="3"){
            $.messager.alert("��ʾ","����ͬһ��״̬����ͬʱ����","info");
            return false;
    }else if (flag=="4"){
            $.messager.alert("��ʾ","����ͬһ��VIP�ȼ��Ĳ���ͬʱ����","info");
            return false;
    }else if (flag=="5"){
            $.messager.alert("��ʾ",Str[1]+$g("���ձ��������"),"info");
            return false;
    }else if (flag=="6"){
            $.messager.alert("��ʾ","���ǵǼǻ��ߵ���״̬������ͬʱ����","info");
            return false;
    }
    
    
    var PreOrAdd="PRE";
    
    if (GFlag=="1"){
        var AddType=$("#AddType").checkbox('getValue');
        if(AddType){PreOrAdd="PRE";}
        else{PreOrAdd="ADD";}
        
        var AddType="�Է�";
        if (PreOrAdd=="PRE") AddType="����"
    
    $.messager.confirm("ȷ��", $g("ȷʵҪ��ѡ�е���Ա")+AddType+$g("������?"), function(r){
        if (r){
			 var lnk="dhcpepreitemlist.main.new.hisui.csp"+"?AdmType=PERSON"
            +"&AdmId="+IDs+"&PreOrAdd="+PreOrAdd+"&VIPLevel="+VIPLevel
            ;
		
         //websys_lu(lnk,false,'iconCls=icon-w-edit,width=1400,height=740,hisui=true,title='+$g('ԤԼ��Ŀ�޸�')) 
		 $HUI.window("#ItemEditWin", {
        		title: "ԤԼ��Ŀ�޸�",
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
       
         //websys_lu(lnk,false,'iconCls=icon-w-edit,width=1400,height=740,hisui=true,title='+$g('ԤԼ��Ŀ�޸�')) 
		 $HUI.window("#ItemEditWin", {
        		title: "ԤԼ��Ŀ�޸�",
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


//ȡ��/��ͬ�շ�
function UpdateAsCharged()
{
    var Type="I";
    var AsType="",AsRemark="",ID="";
    
    var ID=GetSelectId();
    
    if (ID=="") {
        $.messager.alert("��ʾ","����ѡ�����������Ա!","info");
        return false;
    }
    if(ID.split("^").length>1){
        $.messager.alert("��ʾ","ֻ�ܲ���һ��!","info");
        return false;
        }

    var  Group=ID.split(";")[1];
    if ((Group!="")&&(Group!=" "))
    {
        $.messager.alert("��ʾ","�����еĿͻ�,���������в���!","info");
        return;
    }
    
    
    var  AsType=$("#AsType").combobox('getValue')
    var  AsRemark=$("#AsRemark").val();
    var AsCharged=ID.split(";")[4];
    ID=ID.split(";")[0];
    ID=ID+"^"+AsType+"^"+AsRemark;
   
   var UserID=session['LOGON.USERID'];
  
    if((AsCharged==$g("��"))){ 
        $.messager.confirm("ȷ��", "ȷ��Ҫȡ����ͬ�շ���", function (r) {
            if (r) {
                var Return=tkMakeServerCall("web.DHCPE.PreGADM","UpdateAsCharged",ID,Type,UserID);
                if (Return=="StatusErr"){
                    $.messager.alert("��ʾ","״̬����!","error");
                }else if (Return=="SQLErr"){
                    $.messager.alert("��ʾ","���´���!","error");
                }else if (Return=="ExcuteErr"){
                    $.messager.alert("��ʾ","��ͬ�շѵ�ҽ��������ִ�еģ�����ȡ����ͬ�շ�!","info");
                }else if (Return=="MedErr"){
                    $.messager.alert("��ʾ","���ڷ�ҩƷ��ҽ��,����ȡ����ͬ�շ�!","info"); 
                }else{
                    $.messager.alert("��ʾ","���³ɹ�!","success");
                    $("#AsRemark").val(""); 
                    $("#AsType").combobox('setValue',"");
                    BFind_click();
        
                }
            }else{
                return false;
           }
    })
   }
   if((AsCharged==$g("��"))){
        $.messager.confirm("ȷ��", "ȷ��Ҫ��ͬ�շ���", function (r) {
            if (r) {
                var Return=tkMakeServerCall("web.DHCPE.PreGADM","UpdateAsCharged",ID,Type,UserID);
                if (Return=="StatusErr"){
                    $.messager.alert("��ʾ","״̬����!","error");
                }else if (Return=="SQLErr"){
                    $.messager.alert("��ʾ","���´���!","error");
                }else if (Return=="ExcuteErr"){
                    $.messager.alert("��ʾ","��ͬ�շѵ�ҽ��������ִ�еģ�����ȡ����ͬ�շ�!","info");
                }else if (Return=="MedErr"){
                    $.messager.alert("��ʾ","���ڷ�ҩƷ��ҽ��,����ȡ����ͬ�շ�!","info"); 
                }else{
                    $.messager.alert("��ʾ","���³ɹ�!","success");
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


//����
function UpdatePreAudit()
{
    var Type="I";
    var ID=GetSelectId();
    
    if (ID=="") {
        $.messager.alert("��ʾ","��ѡ�����������Ա","info");
        return false;
        }
        
    if(ID.split("^").length>1){
        $.messager.alert("��ʾ","ֻ�ܲ���һ��","info");
        return false;
        }
    ID=ID.split(";")[0];
    
    var lnk="dhcpepreauditlist.hiui.csp?CRMADM="+ID+"&ADMType="+Type+"&GIADM="+"&RowID=";
    
	//websys_lu(lnk,false,'iconCls=icon-w-edit,width=1400,height=750,hisui=true,title=����') //�޷��������������������ʾ��������
    
   $HUI.window("#SplitWin", {
        title: "����",
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

///����/ȡ��ȡ��
function IAdmAlterStatus(){ 
    var Data=GetSelectIADM();
    if (""==Data) { 
        $.messager.alert("��ʾ","����ѡ�����������Ա��","info");
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
                    $.messager.alert("��ʾ","�ܼ�������ύ������ȡ�����","info");
                    return false;
                 }
            }

            if (IAdmStatus=="REGISTERED") {
                newStatus="ARRIVED";
            }

            //if (IAdmStatus=="CANCELARRIVED") {newStatus="ARRIVED"}
            if (newStatus==""){
                $.messager.alert("��ʾ","ѡ����˵�״̬Ӧ�ǵ����Ǽǣ�","info");
                return false;
            }
            var flag=tkMakeServerCall("web.DHCPE.DHCPEIAdm","ArrivedUpdate",iIAdmId,newStatus);
            if (flag!='0') {
                $.messager.alert("��ʾ","����ʧ��:"+flag,"info");
                return false;
            }
        }
    }
    
    $.messager.alert("��ʾ","������ɣ�","info");
    BFind_click();
    
}

function GetSelectIADM() 
{ 
    var vals="",IADM="",Status="";
    var selectrow = $("#PreIADMFindGrid").datagrid("getChecked");//��ȡ�������飬��������
  
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
    var selectrow = $("#PreIADMFindGrid").datagrid("getChecked");//��ȡ�������飬��������
     
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
            $.messager.alert("��ʾ","δѡ����Ա","info");
            return false;
        }
    if(Id.split("^").length>1){
        
        $.messager.alert("��ʾ","ֻ�ܲ���һ��","info");
        return false;
    } 
    $.messager.confirm("ȷ��", "ȷ��Ҫȡ�������", function(r){
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
            $.messager.alert("��ʾ","δѡ����Ա","info");
            return false;
        }
    if(Id.split("^").length>1){
        
        $.messager.alert("��ʾ","ֻ�ܲ���һ��","info");
        return false;
    } 
        
    var Status="";
    var Status=Id.split(";")[3];
    if(Status!=$g("ȡ�����")){
        $.messager.alert("��ʾ","����ȡ�����״̬,���ܳ���ȡ�����","info");
        return false;
    }
    var PGADM=Id.split(";")[1];
    var PIBI=Id.split(";")[2];
    var ExistFlag=tkMakeServerCall("web.DHCPE.PreIADM","GroupIsExistIADM",PIBI,PGADM)
    if (ExistFlag=="1") {
        $.messager.alert("��ʾ","�ͻ����������Ѵ���,���ܳ���ȡ�����","info");
        return false;
    }

    $.messager.confirm("ȷ��", "ȷ��Ҫ����ȡ�������", function(r){
        if (r){
                CancelPECommon("I",1,Id.split(";")[0]);
                BFind_click();
            
        }
    }); 
    
    
}

function CancelPECommon(Type,DoType,Id){
    
    var Ret=tkMakeServerCall("web.DHCPE.CancelPE","CancelPE",Id,Type,DoType)
    Ret=Ret.split("^");
    $.messager.alert("��ʾ",Ret[1],'success');
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

    // PREREG ԤԼ
    var PREREG=$("#Status_PREREG").checkbox('getValue');
    if(PREREG){iStatus=iStatus+"^"+"PREREG";}      
    
    // REGISTERED �Ǽ�
    var REGISTERED=$("#Status_REGISTERED").checkbox('getValue');
    if(REGISTERED){iStatus=iStatus+"^"+"REGISTERED";}  
    
    
    // REGISTERED ����
    var ARRIVED=$("#Status_ARRIVED").checkbox('getValue');
    if(ARRIVED){iStatus=iStatus+"^"+"ARRIVED";}  
    

    //CANCELPE  ȡ�����
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


//�鿴ԤԼ��Ŀ
function BItemList(IADM)
{
    var lnk="dhcpeitemdetail.hisui.csp"+"?AdmId="+IADM;
    //websys_lu(lnk,false,'width=1350,height=750,hisui=true,title=ԤԼ��Ŀ')
	$HUI.window("#ItemListWin", {
        title: "ԤԼ��Ŀ",
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
//��ӡ����
function BPrintBarCode(PIADM)
{
    var lnk="dhcpeprintiadminfo.hisui.csp"+"?IAdmId="+PIADM;
   // websys_lu(lnk,false,'width=870,height=600,hisui=true,title=��ӡ����')
   $HUI.window("#PrintBarCodeWin", {
        title: "��ӡ����",
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

//�����滻
function BModifyName(PIADM)
{
    var lnk="dhcpepreiadmreplace.hisui.csp"+"?PreIADM="+PIADM;
    //websys_lu(lnk,false,'width=870,height=700,hisui=true,title=�����滻')
	$HUI.window("#ModifyNameWin", {
        title: "�����滻",
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

//���˲�����־
function BAdmRecordList(IADM){
    var lnk="dhcpeadmrecordlist.hisui.csp"+"?AdmId="+IADM;
    //websys_lu(lnk,false,'width=950,height=700,hisui=true,title=������־������¼')
	 $HUI.window("#RecordListWin", {
        title: "������־������¼",
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

//�շ�״̬
function BPreAuditList(PIADM){
  
$("#PreAuditListWin").show();
    
    $HUI.window("#PreAuditListWin",{
        title:"�շ�״̬�б�",
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
            {field:'TRebate',width:'100',title:'�ۿ���'},
            {field:'TAccountAmount',width:'100',title:'Ӧ�ս��',align:'right'},
            {field:'TDiscountedAmount',width:'100',title:'���۽��',align:'right'},
            {field:'TFactAmount',width:'100',title:'���ս��',align:'right'},
            {field:'TAuditedStatus',width:'80',title:'���״̬'},
            {field:'TChargedStatus',width:'80',title:'�շ�״̬'},
            {field:'TPrivilegeMode',width:'80',title:'�Ż���ʽ'},
            {field:'TType',width:'50',title:'����'},
            {field:'TItemDetail',width:'70',title:'��Ŀ��ϸ',align:'center',
                formatter:function(value,rowData,rowIndex){
                    if(rowData.TRowId!=""){
                        return "<span style='cursor:pointer;padding:0 10px 0px 0px' class='icon-paper' title='��Ŀ��ϸ' onclick='ItemDetail_click("+rowData.TRowId+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                    }
                }},
            {field:'TTeamName',width:'90',title:'��������'},
            {field:'TRemark',width:'60',title:'��ע'},
            
            
        ]]              
        
        })
}

//��Ŀ��ϸ����
function ItemDetail_click(AuditID)
{

$("#ItemDetailWin").show();
    
    $HUI.window("#ItemDetailWin",{
        title:"��Ŀ��ϸ",
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
            {field:'ItemName',width:'180',title:'��Ŀ����'},
            {field:'FactAmount',width:'90',title:'���ս��',align:'right'},
            {field:'FeeTypeDesc',width:'50',title:'���'},
            {field:'OrdStatusDesc',width:'60',title:'״̬'},
            {field:'PatName',width:'100',title:'����'}
            
        ]]              
        
        })  
}

//����λ��
function BChangeRoomPlace(PIADM){
    
     var lnk="dhcpechangeroomplace.hisui.csp"+"?PreIADM="+PIADM;
    // websys_lu(lnk,false,'width=1270,height=730,hisui=true,title=����λ��')
	 $HUI.window("#RoomPlaceWin", {
        title: "����λ��",
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

//�����ʾ�
function BHMS(PIADM){
    var lnk="dhchm.questiondetailset.csp"+"?PreIADM="+PIADM;
     //websys_lu(lnk,false,'width=1100,height=600,hisui=true,title=�����ʾ�')
 $HUI.window("#QuestionWin", {
        title: "�����ʾ�",
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

//ԤԼ�����޸�
function UpdatePreDate(PIADM)
{ 
    var lnk = "dhcpe.predate.select.csp?PIADM=" + PIADM + "&CBFunc=UpdatePreDateCallback&WinId=SelectDateWin";
    $HUI.window("#SelectDateWin", {
        title: "��Դ��",
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
        title:'ԤԼ�����޸�',
        modal:true,
        buttonAlign : 'center',
        buttons:[
                
            {
                iconCls:'icon-w-update',
                text:'����',
                id:'save_btn',
                handler:function(){
                    SaveForm(PIADM)
                }
            },{
                iconCls:'icon-w-close',
                text:'�ر�',
                handler:function(){
                    UpdatePreDateWin.close();
                }
                
            }]
        });
        
        
    
}

///����
function UpdatePreDateCallback(piadm,date,time,detailId)
{
    var ret=tkMakeServerCall("web.DHCPE.TransAdmInfo","UpdateAdmDate",piadm,date+"^"+time,detailId);
    if(ret=="0"){
        $.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
        $('#PreIADMFindGrid').datagrid('reload');   
    }else{
        $.messager.alert("��ʾ",ret,"error");
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
        $.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
        $('#UpdatePreDateWin').dialog('close');     
        
    }
}
function InitPreIADMFindGrid(){
    $HUI.datagrid("#PreIADMFindGrid",{
        url:$URL,
        fit : true,
        border : false,
        striped : false, //����Ϊ true����������ƻ�������ż��ʹ�ò�ͬ����ɫ��
        fitColumns : false,
        autoRowHeight : false,
        rownumbers:true,
        pagination : true,  
        rownumbers : true,  
        pageSize: 50,
        pageList : [50,100,150],
        singleSelect: false,
        checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
        selectOnCheck: true,
        
        queryParams:{
            ClassName:"web.DHCPE.PreIADM",
            QueryName:"SearchPreIADM",
            RegNo:$("#RegNo").val(),
            Name:$("#Name").val(),
            PEStDate:$("#PEStDate").datebox('getValue')
        

        },
        frozenColumns:[[
            {title: 'ѡ��',field: 'Select',width: 60,checkbox:true},
            {field:'PrintBarCode',width:80,title:'��ӡ����',
            formatter:function(value,rowData,rowIndex){ 
                    
                if((rowData.TAdmIdPIDM!="")&&(rowData.PIADM_Status_Desc!=$g("ȡ�����"))){
                    return "<span style='cursor:pointer;padding:0 10px 0px 30px' class='icon-print' title='��ӡ����' onclick='BPrintBarCode("+rowData.TAdmIdPIDM+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                   
                }
            }},
            {field:'TItemListNew',width:100,title:'�鿴ԤԼ��Ŀ',
                formatter:function(value,rowData,rowIndex){ 
                    
                if((rowData.TAdmIdPIDM!="")&&(rowData.PIADM_Status_Desc!=$g("ȡ�����"))){
                    return "<span style='cursor:pointer;padding:0 10px 0px 30px' class='icon-paper' title='��Ŀ��ϸ' onclick='BItemList("+rowData.TAdmIdPIDM+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                   
                }
            }},
    
            {field:'PIADM_PIBI_DR_RegNo',width:110,title:'�ǼǺ�',sortable:true},
            {field:'PIADM_PIBI_DR_Name',width:110,title:'����',
            formatter:function(value,rowData,rowIndex){ 
                    if(rowData.PIADM_RowId!=""){
                        return "<a href='#'  class='grid-td-text' onclick=BModifyName("+rowData.PIADM_RowId+"\)>"+value+"</a>";
            
                    }else{return value}
                    
                    
    
            }},
            {field:'TNewHPNo',width:110,title:'����',sortable:true}
            
        ]],
        columns:[[
        
        
            {field:'TAdmIdPIDM',title:'TAdmIdPIDM',hidden: true},
            {field:'PIADM_PGADM_DR',title:'PIADM_PGADM_DR',hidden: true},
            {field:'PIADM_PIBI_DR',title:'PIADM_PIBI_DR',hidden: true},
            {field:'PIADM_RowId',title:'PIADM_RowId',hidden: true},
            {field:'PIADM_PGADM_DR_Name',width:130,title:'��������'},
            {field:'PIADM_PGTeam_DR_Name',width:100,title:'����'},
            {field:'TAdmDate',width:100,title:'��������',
            formatter:function(value,rowData,rowIndex){ 
                    if(rowData.TAdmIdPIDM!=""){
                        return "<a href='#'  class='grid-td-text' onclick=BAdmRecordList("+rowData.TAdmIdPIDM+"\)>"+value+"</a>";
            
                    }else{return value}
                    
                    
    
            }},
            {field:'PIADM_PEDateBegin',width:100,title:'��ʼ����',sortable:true,
            formatter:function(value,rowData,rowIndex){ 
                    if(rowData.PIADM_RowId!=""){
                        return "<a href='#'  class='grid-td-text' onclick=UpdatePreDate("+rowData.PIADM_RowId+"\)>"+value+"</a>";
            
                    }else{return value}
                    
                    
    
            }},
            {field:'PIADM_VIP',width:80,title:'VIP�ȼ�'},
            {field:'PIADM_AsCharged',width:80,title:'��ͬ�շ�'},
            {field:'TPatItemPrtFlag',width:90,title:'���ﵥ��ӡ',align:'center',
            formatter:function(value,rowData,rowIndex){
                    var rvalue="",checked="";
                    if(value!=""){
                        if (value=="Y") {checked="checked=checked"}
                        else{checked=""}
                        var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"    
                        return rvalue;
                    }
                
                }},
            {field:'PIADM_ChargedStatus_Desc',width:80,title:'�շ�״̬',
            formatter:function(value,rowData,rowIndex){ 
                    if((rowData.PIADM_RowId!="")&&(value!=$g("û����Ŀ(δ�Ǽ�)"))){
                        var flag = tkMakeServerCall("web.DHCPE.PreAudit","IsExsistIItem",rowData.PIADM_RowId)
                        if(flag =="1"){
                            return "<a href='#' class='grid-td-text' onclick=BPreAuditList("+rowData.PIADM_RowId+"\)>"+value+"</a>";
                        }else{
                            return value;
                        }

            
                    }else{return value}
                    
                    
    
            }},
            {field:'PIADM_Status_Desc',width:80,title:'ԤԼ״̬'},
            {field:'TReportStatus',width:80,title:'����״̬'},
            {field:'TOrdEnt',width:120,title:'�ײ�'},
            {field:'PIADM_PEDateEnd',width:100,title:'��������'},
            {field:'PIADMRemark',width:100,title:'��ͬ�շѱ�ע'},
            {field:'TAsType',width:100,title:'��ͬ�շ�����'},
            {field:'TRoomPlace',width:120,title:'����λ��',
            formatter:function(value,rowData,rowIndex){ 
                    if(rowData.PIADM_RowId!=""){
                        return "<a href='#'  class='grid-td-text' onclick=BChangeRoomPlace("+rowData.PIADM_RowId+"\)>"+value+"</a>";
            
                    }else{return value}
                    
                    
    
            }},
            {field:'TGetCheckDate',width:100,title:'�������'},
            {field:'TAccountAmount',width:80,title:'Ӧ�ս��',align:'right'},
            {field:'TFactAmount',width:80,title:'�Żݽ��',align:'right'},
            {field:'TCheckNum',width:80,title:'�Ѽ����'},
            {field:'TDiet',width:60,title:'�Ͳ�',align:'center',
            formatter:function(value,rowData,rowIndex){
                    var rvalue="",checked="";
                    if(value!=""){
                        if (value=="1") {checked="checked=checked"}
                        else{checked=""}
                        var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"    
                        return rvalue;
                    }
                
            }},
            {field:'PIBI_IDCard',width:150,title:'֤����'},
            {field:'TPACCardType',width:100,title:'֤������'},
            {field:'TAge',width:60,title:'����'},
            {field:'TType',width:60,title:'ְλ'},
            {field:'TPosition',width:60,title:'����'},
            {field:'PIADMPIBI_DR_SEX',width:60,title:'�Ա�'},
            {field:'TMarryDesc',width:60,title:'����'},
            {field:'PIADM_PEDeskClerk_DR_Name',width:60,title:'�Ӵ���'},
            {field:'TGetReportDate',width:100,title:'ȡ��������'},
            {field:'PGBI_Tel1',width:100,title:'��ϵ�绰'},
            {field:'THMS',width:80,title:'�����ʾ�',
                formatter:function(value,rowData,rowIndex){ 
                    
                if(rowData.PIADM_RowId!=""){
                    return '<a><img style="padding:0 10px 0px 20px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png"  title="�����ʾ�" border="0" onclick="BHMS('+rowData.PIADM_RowId+')"></a>';
                    
                }
            }},
            
    {field:'TMark',width:120,title:'��ע',editor:{type:'textarea',options:{height:'30px'}}}
                    
        
            
        ]],
        onClickRow: onClickRow,
        onAfterEdit: function(index, rowdata, changes) {
            if(rowdata.PIADM_RowId==""){
                    //$.messager.alert("��ʾ","�ϼ��в���Ҫ���汸ע",'info');
                    return false;
            }else{
                var ret = tkMakeServerCall("web.DHCPE.PreIADM","UpDateMark",rowdata.PIADM_RowId,rowdata.TMark);
                if(ret=="0"){ $.messager.alert("��ʾ","����ɹ�",'success');}
            }
            

        },
        onSelect: function (rowIndex, rowData) {
        

        // ���֮ǰ�����Ѿ�������ȡ��ʽ�ͱ�ע����ʾ���ұ� ���������Ĭ�� start
        var ItemStr=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetSendReportCode",rowData.PIADM_RowId)
        setValueById("PatInfoArr","&nbsp;&nbsp;"+$g("������")+rowData.PIADM_PIBI_DR_Name+"&nbsp;&nbsp;&nbsp;&nbsp;"+$g("���ţ�")+rowData.TNewHPNo);
        setValueById("Remark",ItemStr.split("^")[0]);
        $("#ReportDate").datebox('setValue',ItemStr.split("^")[1]);   
        $("#SendMethod").combobox('setValue',ItemStr.split("^")[2]);
        // ���֮ǰ�����Ѿ�������ȡ��ʽ�ͱ�ע����ʾ���ұ� ���������Ĭ�� end
        
        iniForm();

        var Status=rowData.PIADM_Status_Desc;
        if((Status==$g("ȡ�����"))||(Status=="")){
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
        
        

        //����
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

//�б�༭
var editIndex = undefined;
var modifyBeforeRow = "";
var modifyAfterRow = "";

//�����б༭
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

//���ĳ�н��б༭
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
    

    //VIP�ȼ� 
    var VIPObj = $HUI.combobox("#VIPLevel",{
        url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
        valueField:'id',
        textField:'desc',
        });
        
        
        //����
    var ReCheckObj = $HUI.combobox("#ReCheck",{
        valueField:'id',
        textField:'text',
        panelHeight:'70',
        data:[
           {id:'0',text:$g('�Ǹ���')},
           {id:'1',text:$g('����')},
        ]

    });
    
    
    //�Ա�
    var SexObj = $HUI.combobox("#Sex",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindSex&ResultSetType=array",
        valueField:'id',
        textField:'sex',
        panelHeight:'130',
    });
    
    
    //��ͬ�շ�����
    var AsTypeObj = $HUI.combobox("#AsType",{
        valueField:'id',
        textField:'text',
        panelHeight:'130',
        data:[
           {id:'1',text:$g('��������')},
            {id:'2',text:$g('�쵼����')},
            {id:'3',text:$g('����')},
            {id:'4',text:$g('ת��')}

        ]

    });
    
    //�շ�״̬
    var ChargeStatusObj = $HUI.combobox("#ChargeStatus",{
        valueField:'id',
        textField:'text',
        panelHeight:'130',
        data:[
             {id:'0',text:$g('δ����')},
            {id:'1',text:$g('�����շ�')},
            {id:'2',text:$g('ȫ���շ�')},
            {id:'3',text:$g('û����Ŀ')},
            {id:'4',text:$g('���')},
            {id:'5',text:$g('����')}
        ]

    });
    
    //����
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
            {field:'Name',title:'����',width:150},
            {field:'Code',title:'����',width:100},
            {field:'Begin',title:'ԤԼ��ʼ����',width:100},
            {field:'End',title:'ԤԼ��������',width:100},
            {field:'DelayDate',title:'״̬',width:60},
                    
        ]]
        });
        
        
        //����
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
            {field:'PGT_ParRef_Name',title:'��������',width:240},
            {field:'PGT_Desc',title:'��������',width:150}
        ]]
        });
        
        //����
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
            {field:'DepartName',title:'����',width:100}
        ]]
        });




    //�ʹ﷽ʽ
    var SendMethodObj = $HUI.combobox("#SendMethod",{
        valueField:'id',
        textField:'text',
        panelHeight:'140',
        data:[
            {id:'ZQ',text:$g('��ȡ')},
            {id:'TQ',text:$g('ͳȡ')},
            {id:'KD',text:$g('���')},
            {id:'DY',text:$g('����')},
            {id:'DZB',text:$g('���Ӱ�')},
           
        ]

      });
    
    // �Ƿ�������ܼ�
    var IfComplateAll = $HUI.combobox("#IfComplateAll",{
        valueField:'id',
        textField:'text',
        panelHeight:'140',
        data:[
            {id:'Y',text:$g('��')},
            {id:'N',text:$g('��')}   
           
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


//����
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
         $.messager.alert("��ʾ","����Ч","info",function(){$("#CardNo").focus();});
        
        
        return false;
    }
}

//�����֤
function ReadRegInfo_OnClick()
{
  
    var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
    var rtn=tkMakeServerCall("DHCDoc.Interface.Inside.Service","GetIECreat")
    var myHCTypeDR=rtn.split("^")[0];
    var myInfo=DHCWCOM_PersonInfoRead(myHCTypeDR);
    var myary=myInfo.split("^");
    if(myary=="0")
    {
        $.messager.alert("��ʾ","����ʧ�ܻ���û�ж�������","info");
        return false;
    }
    if (myary[0]=="-1"){
        $.messager.alert("��ʾ",myary[1],"info");
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
        $.messager.alert("��ʾ",xmlDoc.parseError.reason,"info");
        return; 
    }
    */
    var nodes = xmlDoc.documentElement.childNodes;
    if (nodes.length<=0){return;}
    for (var i = 0; i < nodes.length; i++) {
        
        var myItemName = getNodeName(nodes,i);
        
        var myItemValue = getNodeValue(nodes,i);
        
        //����
        if(myItemName=="Name") $("#Name").val(myItemValue);
        
       //���֤��
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
        displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������"
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
            {title: 'ѡ��',field: 'Select',width: 60,checkbox:true},
            {field:'Ord_ItemID',title:'ID',hidden: true},
            {field:'Ord_ItemDesc',width:120,title:'��Ŀ����'},
            {field:'Ord_ItemStatus',width:55,title:'״̬',sortable:true},
            {field:'Bill_Status',width:100,title:'�շ�״̬'},
            {field:'Ord_Doctor',width:80,title:'ҽ��',},
            {field:'Ord_Date',width:120,title:'�������',}
            
        ]],
        
    
    })
}


//Ĭ�ϱ���Լ��
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


//�ձ����
function BRecpaper_click()
{   
    
    var PAADM=$("#PAADM").val();
    if(PAADM==""){
           $.messager.alert("��ʾ","��ѡ����ձ�ľ����¼��","info");
           return false;
        }
  
        
    var RecpaperFlag=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetRecpaperFlag",PAADM);
    if(RecpaperFlag=="1"){
        $.messager.alert("��ʾ","���ǵ���״̬�������ձ�","info");
        return false;
    }else if(RecpaperFlag=="2"){
        $.messager.alert("��ʾ","���ձ������ظ��ձ�","info");
        return false;
    }else if(RecpaperFlag=="3"){
        $.messager.confirm("ɾ��", "��δִ�е���Ŀ��ȷ��Ҫ�ձ���?", function (r) {
        if (r) {
            var PayFlag=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetOEItemNoPay",PAADM);
            if(PayFlag=="0"){
                $.messager.confirm('ȷ��', '����δ������Ŀ���Ƿ�����ձ�', function(t) {
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

//�ձ�
function RecpaperCommon(PAADM)
{
    var iReportDate=$("#ReportDate").datebox('getValue');
    if(iReportDate==""){
        $.messager.alert("��ʾ","��ѡ�񱨸�Լ�ڣ�","info");
        return false;
    }
    
    var iSendMethod=$("#SendMethod").combobox("getValue"); 
    if (($("#SendMethod").combobox("getValue")==undefined)||($("#SendMethod").combobox("getValue")=="")){var iSendMethod="";}
    if(iSendMethod==""){
        $.messager.alert("��ʾ","��ѡ���ʹ﷽ʽ��","info");
         return false;
    }
        
    var iRemark=$("#Remark").val(); 
    var Return=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetRecPaperNew",PAADM,iReportDate,iSendMethod,iRemark);
    var ret=Return.split("#");
    if (ret[0]!=0)
    { 
        $.messager.alert("��ʾ",ret[0],"info");
    }else{
        $.messager.alert("��ʾ","�ձ�ɹ���","success");
        var flag=tkMakeServerCall("web.DHCPE.TransResult","TransMain",PAADM);
        if(ret[1]=="Y"){
            var value=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetBaseInfo",PAADM,iReportDate);
            if(value!=""){
                PrintGetReportPT(value); 
              }//��ӡȡ����ƾ��
        }
            
   }
            
}
///ȡ���ձ�
function CancelPaper(PIADM)
{
    
    if (PIADM=="")  {
        $.messager.alert("��ʾ","��ѡ���ȡ���ձ�Ŀͻ���","info");
        return false
    } 
    else{ 
        $.messager.confirm("ȷ��", "ȷ��Ҫȡ����", function(r){
        if (r){
            
            $.m({ ClassName:"web.DHCPE.DHCPEIAdm", MethodName:"CancelRecPaper",PIADM:PIADM},function(ReturnValue){
                //alert(ReturnValue)
                if (ReturnValue!='0') {
                    $.messager.alert("��ʾ","ȡ���ձ�ʧ��"+flag,"error");  
                }else{
                    $.messager.popover({msg: 'ȡ���ձ�ɹ���',type:'success',timeout: 1000});
                    BFind_click();
     
                }
            }); 
        }
    });
    }       

}

//�������
function BRefuseCheck_click()
{
    var UserID=session['LOGON.USERID'];
    var OrdIDS=GetSelectItemId();
    
    if(OrdIDS==""){
            $.messager.alert("��ʾ","��û��ѡ�����������Ŀ��","info");
            return false;
        }
        
    var OrdStr=OrdIDS.split("^");
    
    for(i=0;i<OrdStr.length;i++)
    { 
        var OEID=OrdStr[i].split(";")[0]
        var Status=OrdStr[i].split(";")[1]
        if(!((Status=="δ��")||(Status=="����"))){
           $.messager.alert("��ʾ","ֻ�ܲ���δ�졢����ҽ����","info");
            return false;
        }else{
            
        }
    }
    
    //$("#SelectA").checkbox('setValue',false);
    $.messager.confirm('ȷ��', 'ȷ��Ҫ���������', function(t) {
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

// �����������
function UnBRefuseCheck_click()
{
    var UserID=session['LOGON.USERID'];
    var OrdIDS=GetSelectItemId();
    
    if(OrdIDS==""){
            $.messager.alert("��ʾ","��û��ѡ��������������Ŀ��","info");
            return false;
        }
        
    var OrdStr=OrdIDS.split("^");
    
    for(i=0;i<OrdStr.length;i++)
    { 
        var OEID=OrdStr[i].split(";")[0]
        var Status=OrdStr[i].split(";")[1]
        if(Status!="����"){
           $.messager.alert("��ʾ","ֻ�ܲ����ѷ�������ҽ����","info");
            return false;
        }else{
           
        }
    }
    
        
    $.messager.confirm('ȷ��', 'ȷ��Ҫ����������', function(t) {
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


//���ڼ��  DoType :0  ���ڣ�1����������
function BExtension_click(DoType)
{
    var UserID=session['LOGON.USERID'];
    var OrdIDNewS="";
    var PAADM=$("#PAADM").val();
    if(PAADM==""){
           $.messager.alert("��ʾ","��ѡ������ڵľ����¼��","info");
           return false;
        }
    var OrdIDS=GetSelectItemId();
    if(OrdIDS==""){
            $.messager.alert("��ʾ","��û��ѡ����Ŀ��","info");
            return false;
        }

    var OrdStr=OrdIDS.split("^");
    for(i=0;i<OrdStr.length;i++)
    { 
        var OEID=OrdStr[i].split(";")[0];
        var Status=OrdStr[i].split(";")[1];
        if((Status!=$g("δ��"))&&(DoType=="0"))  continue;
        if((Status!=$g("����"))&&(DoType=="1"))  continue;
        if(OrdIDNewS==""){ var OrdIDNewS=OEID;}
        else{var OrdIDNewS=OrdIDNewS+","+OEID;}
       
    }
    if(OrdIDNewS==""){
        $.messager.alert("��ʾ","û�з�����������Ŀ��","info");
        return false;
    }
    
    

    if(DoType=="0"){

        var iDelayDate=$("#DelayDate").datebox('getValue')
        if(iDelayDate==""){
            $.messager.alert("��ʾ","ûѡ���������ڣ�","info");
            return false;
        }

        var today = getDefStDate(0);
        var todayLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",today);
        var YQDateLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",iDelayDate);
        if(YQDateLogical<=todayLogical){
            $.messager.alert("��ʾ","��������Ӧ���ڽ���","info");  
            return false;
        }

        var iIfComplateAll=$("#IfComplateAll").combobox("getValue");
        if (($("#IfComplateAll").combobox("getValue")==undefined)||($("#IfComplateAll").combobox("getValue")=="")){var iIfComplateAll="";}
        if(iIfComplateAll==""){
            $.messager.alert("��ʾ","ûѡ��ȫ���������ܼ죡","info");
            return false;
        }

        var Return=tkMakeServerCall("web.DHCPE.OrderPostPoned","DelayRecord",PAADM,iDelayDate,iIfComplateAll,OrdIDNewS,UserID);
        var ret=Return.split("#");
        if((ret>0)||(ret==0)){
            $.messager.alert("��ʾ","���ڳɹ���","success");   
        }else{
            $.messager.alert("��ʾ","����ʧ�ܣ�","error"); 
            return false;
        }
    }
    if(DoType=="1"){
        var OrdIDNewS=OrdIDNewS.replace(/,/g,"^");
        //alert(OrdIDNewS)
        var Return=tkMakeServerCall("web.DHCPE.OrderPostPoned","CancelDelay",OrdIDNewS,UserID);
        if((Return>0)||(Return==0)){
            $.messager.alert("��ʾ","�������ڳɹ���","success"); 
        }else{
            $.messager.alert("��ʾ","��������ʧ�ܣ�","error");   
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


///�ֶ����Ѽ�
function BChecked_click(DoType)
{
    var UserID=session['LOGON.USERID'];
    var OrdIDNewS="";
    if(DoType=="0"){var MessageInfo=$g("�Ѽ���³ɹ���");}
    if(DoType=="1"){var MessageInfo=$g("�����Ѽ���³ɹ���");}
    
    var PAADM=$("#PAADM").val();
    if(PAADM==""){
           $.messager.alert("��ʾ","��ѡ�����״̬�ļ�¼��","info");
           return false;
        }
    var OrdIDS=GetSelectItemId();
    if(OrdIDS==""){
            $.messager.alert("��ʾ","��û��ѡ����Ŀ��","info");
            return false;
        }
    
    var OrdStr=OrdIDS.split("^");
    for(i=0;i<OrdStr.length;i++)
    { 
        var OEID=OrdStr[i].split(";")[0];
        var Status=OrdStr[i].split(";")[1];
        if((Status!=$g("δ��"))&&(DoType=="0"))  continue;
        if((Status!=$g("�Ѽ�"))&&(DoType=="1"))  continue;
        if(OrdIDNewS==""){ var OrdIDNewS=OEID;}
        else{var OrdIDNewS=OrdIDNewS+"^"+OEID;}
       
    }
    if(OrdIDNewS==""){
        $.messager.alert("��ʾ","û�з�����������Ŀ��","info");
        return false;
    }
    var Return=tkMakeServerCall("web.DHCPE.DHCPEIAdm","SetSubStatus",PAADM,OrdIDNewS,DoType,UserID);
    var ret=Return.split("#");
    if (ret[0]!=0)
    { 
        $.messager.alert("��ʾ",ret[0],"info");
    }else{
            $.messager.alert("��ʾ",MessageInfo,"success");   
            
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
    var selectrow = $("#OrderItemListGrid").datagrid("getChecked");//��ȡ�������飬��������
     
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








