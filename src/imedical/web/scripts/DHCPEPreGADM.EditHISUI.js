//名称 DHCPEPreGADM.EditHISUI.js
//功能 团体预约hisui
//创建 
//创建人 yp
var TeamRowIndex="";
var BNewWin = function(){
    
    var UserID= session['LOGON.USERID'];
    var LocID= session['LOGON.CTLOCID'];
    $("#TeamGrid ").datagrid('clearSelections'); //取消分组选中状态

    setValueById("PGTRowId","")
    setValueById("PGTChildSub","")
    setValueById("TeamDesc","")
    
    setValueById("ParentTeam","")
    
    
    $("#UpperLimit,#LowerLimit").val("");
    $("#PreGRebate,#AddGRebate,#AddIRebate").numberbox("setValue","");  
    
    var VIPNV=tkMakeServerCall("web.DHCPE.HISUICommon","GetVIP",UserID,LocID);
    $('#VIPLevel').combobox('setValue',VIPNV);
    
    /*********************诊室重新加载*******************/
    $HUI.combobox("#RoomPlace",{
        onBeforeLoad:function(param){
            var VIP=$("#VIPLevel").combobox("getValue");
            param.VIPLevel = VIP;
            param.GIType = "G";
            param.LocID = session['LOGON.CTLOCID']
        }
    });
              
    $('#RoomPlace').combobox('reload'); 
    /*********************诊室重新加载*******************/

    /*********************诊室默认值*******************/
    var DefaultRoomPlace=tkMakeServerCall("web.DHCPE.CT.RoomManagerEx","GetDefaultRoomPlace",VIPNV,"G",LocID); 
    $('#RoomPlace').combobox('setValue',DefaultRoomPlace);
    /*********************诊室默认值*******************/
    
    
    $("#NewWin").show();
    
    $HUI.window("#NewWin",{
        title:"新建分组",
        collapsible:false,
        minimizable:false,
        maximizable:false,
        iconCls: "icon-w-edit",
        modal:true,
        width:920,
        height:680

    });
    
    $HUI.radio("#TeamSexN").setValue(true);
    $HUI.radio("#TeamMarriedN").setValue(true);
    //团体报告发送、个人报告领取在预约分组表没存数据，分组界面只是显示，所以不可编辑
    $("#TeamGReportSend").combobox('disable'); 
    $("#TeamIReportSend").combobox('disable');
    $("#TeamAddOrdItemLimit").checkbox("disable");

    var VIPLevelDesc=$("#VIPLevel").combobox('getText');
    if (VIPLevelDesc=="职业病"){
            $("#OMEType").combobox('enable');
            $("#HarmInfo").combotree('enable');
        }else{
            $("#OMEType").combobox('disable');
            $("#HarmInfo").combotree('disable');
                
        }

    var GADMID=getValueById("ID")
    $("#VIPLevel").combobox('enable')
    var ret=tkMakeServerCall("web.DHCPE.PreGADM","GetPreGADM",GADMID);
    
    setValueById("ParRef_Name",ret.split("^")[3])
    
    SetParRefData(ret)
    
    var ret=tkMakeServerCall("web.DHCPE.PreGTeam","DocListBroker","","",GADMID+"^^");
    
    //TeamClear();
    
}

var RapidNewWin = function(){
    
    var GStatus=tkMakeServerCall("web.DHCPE.PreGADM","GetStatus",GroupID);
    if (GStatus!="PREREG"){
        $("#RapidNew").linkbutton('disable');
        return false;
        }
    else{
        $("#RapidNew").linkbutton('enable');
    }

    $HUI.window("#RapidNewWin",{
        title:"快速分组",
        collapsible:false,
        minimizable:false,
        maximizable:false,
        modal:true,
        width:800,
        height:500
    });
    
    var GADMID=getValueById("ID")
    var ret=tkMakeServerCall("web.DHCPE.PreGADM","GetPreGADM",GADMID);
    SetRapidParRefData(ret)
}


function VIPLevelOnChange()
{
    var LocID=session['LOGON.CTLOCID'];

    var obj=document.getElementById("VIPLevel");
    if (obj){
        var VIPLevel=$("#VIPLevel").combobox('getValue');
        
        if (VIPLevel=="") return false;
        
        var VIPLevelDesc=$("#VIPLevel").combobox('getText');
        if (VIPLevelDesc=="职业病"){
            $("#OMEType").combobox('enable');
            $("#HarmInfo").combotree('enable');
            var TeamOMETypeObj = $HUI.combobox("#OMEType",{
                url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindOMEType&ResultSetType=array",
                valueField:'id',
                textField:'Desc',
                onBeforeLoad: function(param){
                    param.VIPLevel=$("#VIPLevel").combobox('getValue'); 
                }   
            });
    
            }else{
                $("#OMEType").combobox('disable');
                $("#HarmInfo").combotree('disable');
                $("#OMEType").combobox('setValue',"");
                $("#HarmInfo").combotree('setValue',"");
                
            }
        var PatType=tkMakeServerCall("web.DHCPE.VIPLevel","GetPatFeeType",VIPLevel,LocID)
        if (PatType!=""){
            var obj=document.getElementById("TeamPatFeeTypeName");
            if (obj) $('#TeamPatFeeTypeName').combobox('setValue',PatType);
        }
        var DefaultRoomPlace=tkMakeServerCall("web.DHCPE.RoomManagerEx","GetDefaultRoomPlace",VIPLevel,"G",LocID);
        var obj=document.getElementById("RoomPlace");
        if (obj) { $('#RoomPlace').combobox('setValue',DefaultRoomPlace);}
        $('#RoomPlace').combobox('reload');
        
        
    }
    
}
function TeamSetAddItem(value) {
    
    var Data=value.split("^");
    var iLLoop=0;   
    
    var iAddOrdItem=false;
    //  允许加项    PGADM_AddOrdItem    19
    obj=document.getElementById("TeamAddOrdItem");
    if (obj) {
        if ("Y"==Data[iLLoop]) {
            setValueById("TeamAddOrdItem",true)
            iAddOrdItem=true;
            
        }
        else { 
            setValueById("TeamAddOrdItem",false)
            iAddOrdItem=false;
        }
                
    }
    iLLoop=iLLoop+1;    
    
    var iAddOrdItemLimit=false;
    //  加项金额限制  PGADM_AddOrdItemLimit   20
    obj=document.getElementById("TeamAddOrdItemLimit");
    if (obj) { 
        if (iAddOrdItem) {
            obj.disabled=false;
            if ("Y"==Data[iLLoop]) {
                setValueById("TeamAddOrdItemLimit",true)
                iAddOrdItemLimit=true;
            }
            else {
                obj.checked=false;
                iAddOrdItemLimit=false;
            }
            
        }
        else {
            obj.disabled=true;
            
            obj.checked=false;
            iAddOrdItemLimit=false;
                            
        }
    }
    iLLoop=iLLoop+1;    
    
    //  允许加项金额  PGADM_AddOrdItemAmount  21
    obj=document.getElementById("TeamAddOrdItemAmount");
    if (obj) {
        if (iAddOrdItemLimit) {
            obj.disabled=false;
            setValueById("TeamAddOrdItemAmount",Data[iLLoop])
        }
        else{
            obj.disabled=true;
            
            obj.value="";
        }
        
    }
    iLLoop=iLLoop+1;    
    
    //  允许加药    PGADM_AddPhcItem    22
    var iAddPhcItem=false;
    obj=document.getElementById("TeamAddPhcItem");
    if (obj) {
        if ("Y"==Data[iLLoop]) {
            setValueById("TeamAddPhcItem",true)
            iAddPhcItem=true;
        }
        else {
            setValueById("TeamAddPhcItem",false)
            iAddPhcItem=false
        }

    }
    iLLoop=iLLoop+1;    
    
}

function SetRapidParRefData(value) {
    
    var obj;
    var fillData;
    var Data=value.split("^");
    var iLLoop=4;   
    fillData=Data[iLLoop];
    // PGADM_BookDateBegin  预约日期
    //setValueById("RapidBookDateBegin",fillData)
    $("#RapidBookDateBegin").datebox('setValue',fillData)
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    // PGADM_BookDateEnd
    //setValueById("RapidBookDateEnd",fillData)
    $("#RapidBookDateEnd").datebox('setValue',fillData)
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    // PGADM_BookTime   预约时间
    setValueById("RapidBookTime",fillData)
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    // PGADM_AuditUser_DR   预约接待人员
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    setValueById("RapidPEDeskClerkName",fillData)
    iLLoop=iLLoop+3;
    fillData=Data[iLLoop];
    var strLine=""
    strLine=strLine+fillData+"^"; 
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    strLine=strLine+fillData+"^"; 
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    strLine=strLine+fillData+"^"; 
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    strLine=strLine+fillData+"^"; 
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    strLine=strLine+fillData+"^"; 
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    strLine=strLine+fillData+"^"; 
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    
    TeamSetAddItem(strLine);
    
    // PGADM_GReportSend 团体报告发送
    setValueById("RapidGReportSend",fillData)
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];

    // PGADM_IReportSend 个人报告发送 
    setValueById("RapidIReportSend",fillData)
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];

    // PGADM_DisChargedMode 结算方式
    setValueById("RapidDisChargedMode",fillData)
    iLLoop=iLLoop+3;
    fillData=Data[iLLoop];
    
    //VIP
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    
    iLLoop=iLLoop+9;
    fillData=Data[iLLoop];

    //默认团体就诊类别
    
    setValueById("RapidPatFeeTypeName",fillData)
    
    
    return true;
    
    
    
}

function SetParRefData(value) {

    var obj;
    var fillData;
    var Data=value.split("^");
    var iLLoop=4;   
    fillData=Data[iLLoop];
    // PGADM_BookDateBegin  预约日期
    setValueById("TeamBookDateBegin",fillData)
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    // PGADM_BookDateEnd
    setValueById("TeamBookDateEnd",fillData)
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    // PGADM_BookTime   预约时间
    
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    setValueById("TeamPEDeskClerkNameID",fillData)
    // PGADM_AuditUser_DR   预约接待人员
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    //setValueById("TeamPEDeskClerkName",fillData)
    $("#TeamPEDeskClerkName").combogrid('grid').datagrid('reload',{'q':Data[iLLoop]});
    setValueById("TeamPEDeskClerkName",Data[iLLoop-1])

    iLLoop=iLLoop+3;
    fillData=Data[iLLoop];
    var strLine=""
    strLine=strLine+fillData+"^"; 
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    strLine=strLine+fillData+"^"; 
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    strLine=strLine+fillData+"^"; 
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    strLine=strLine+fillData+"^"; 
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    strLine=strLine+fillData+"^"; 
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    strLine=strLine+fillData+"^"; 
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    
    TeamSetAddItem(strLine);
    
    // PGADM_GReportSend 团体报告发送
    setValueById("TeamGReportSend",fillData)
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];

    // PGADM_IReportSend 个人报告发送 
    setValueById("TeamIReportSend",fillData)
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];

    // PGADM_DisChargedMode 结算方式
    setValueById("TeamDisChargedMode",fillData)
    iLLoop=iLLoop+3;
    fillData=Data[iLLoop];
    
    //VIP
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    
    iLLoop=iLLoop+9;
    fillData=Data[iLLoop];

    //默认团体就诊类别
    
    setValueById("TeamPatFeeTypeName",fillData)
    
    var VIPLevel="";
    //VIPLevel=getValueById("VIPLevel")
    VIPLevel=$("#VIPLevel").combobox("getValue");
    var LocID=session['LOGON.CTLOCID'];
    var DefaultRoomPlace=tkMakeServerCall("web.DHCPE.RoomManagerEx","GetDefaultRoomPlace",VIPLevel,"G",LocID);
    //setValueById("RoomPlace",DefaultRoomPlace)
    $("#RoomPlace").combobox("setValue",DefaultRoomPlace);
    return true;

}
function TeamAddOrdItem_click(value) {


    if (value) {
            $("#TeamAddOrdItemLimit").checkbox("enable");
            setValueById("TeamAddOrdItemLimit",true);
            $("#TeamAddOrdItemAmount").attr("disabled",false)
        
    }
    else{
        
            $("#TeamAddOrdItemLimit").checkbox("disable");
            setValueById("TeamAddOrdItemLimit",false)
        
            $("#TeamAddOrdItemAmount").attr("disabled",true);
            setValueById("TeamAddOrdItemAmount","")
            
    }

}
function TeamAddOrdItemLimit_click(value) {
    if (value) {
        $("#TeamAddOrdItemAmount").attr("disabled",false)
        
    }
    else{
        $("#TeamAddOrdItemAmount").attr("disabled",true);
        setValueById("TeamAddOrdItemAmount","") 
            
    }
    
}
function ReadCardClickHandlerG(){
    var SelValue=$HUI.combobox("#CardType").getValue();
    
    if (SelValue==""){return;}
    var myary=SelValue.split("^");
    var myCardTypeDR=myary[0];
    if (myCardTypeDR==""){return;}
    
    var myary=SelValue.split("^");
    var myEquipDR=myary[14];
    
    var rtn = DHCACC_GetAccInfoHISUI(myCardTypeDR, myEquipDR);
    
    
    
    var ReturnArr=rtn.split("^");
    
    if (ReturnArr[0]=="-200")
    {
         var cardvalue=rtn.split("^")[1];
         return false;
    }
    
    $('#PAPMINo').val(ReturnArr[5]);
    RegNoOnChange();
    $('#CardNo').val(ReturnArr[1]);
    
}
    
function ReadCardClickHandler(){
    var SelValue=$HUI.combobox("#PCardType").getValue();
    
    if (SelValue==""){return;}
    var myary=SelValue.split("^");
    var myCardTypeDR=myary[0];
    if (myCardTypeDR==""){return;}
    
    var myary=SelValue.split("^");
    var myEquipDR=myary[14];
    
    var rtn = DHCACC_GetAccInfoHISUI(myCardTypeDR, myEquipDR);
    
    
    
    var ReturnArr=rtn.split("^");
    
    if (ReturnArr[0]=="-200")
    {
         var cardvalue=rtn.split("^")[1];
         return false;
    }
    $('#RegNo').val(ReturnArr[5]);
    PRegNoOnChange();
    $('#PCardNo').val(ReturnArr[1]);
    
    
    
}
function DHCACC_GetAccInfoHISUI(CardTypeDR, EquipDR)
{
    
    //var myrtn =DHCACC_ReadMagCard(EquipDR);
    
    var myrtn =DHCACC_ReadMagCard(EquipDR,"R", "23");
    
    var rtn=0;
    var myLeftM=0;
    var myAccRowID="";
    var myPAPMI="";
    var myPAPMNo=""
    var myCardNo="";
    var myCheckNo="";
    var myGetCardTypeDR="";
    var mySCTTip="";
    var myary=myrtn.split("^");
    var encmeth="";
    if (myary[0]==0){
        rtn=myary[0];
        myCardNo=myary[1];
        myCheckNo=myary[2];
    
            var myExpStr=""+String.fromCharCode(2)+CardTypeDR;
            var myrtn=tkMakeServerCall("web.UDHCAccManageCLSIF","getaccinfofromcardno",myCardNo,myCheckNo, myExpStr);
            
            var myary=myrtn.split("^");
            if(myary[0]==0)
            {
            rtn=myary[0];
            
            var myAccRowID=myary[1];
            var myLeftM=myary[3];
            var myPAPMI=myary[7];
            var myPAPMNo=myary[8];
            var myAccType=myary[10];
            var myAccGrpLeftM=myary[17]
            if (myary.length>12){
                myGetCardTypeDR=myary[12];
            }
            if (myary.length>13){
                mySCTTip = myary[13];
            }
            }
        
    }else{
        rtn=myary[0];
        
    }
    return rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo+"^"+myAccType+"^"+myAccRowID+"^"+myGetCardTypeDR+"^"+mySCTTip+"^"+myAccGrpLeftM;
}

function SetButtonDisable()
{
    
    $("#AddOrdItemLimit").checkbox("disable");
    $("#AddOrdItemAmount").attr('disabled','disabled');
    
        
    
    

    
    var GStatus=tkMakeServerCall("web.DHCPE.PreGADM","GetStatus",GroupID);
    if (GStatus!="PREREG")
    {
        $("#RapidNew").linkbutton('disable');
    }
}


function BMoveTeam_Click()
{
    var SelectIds=""
    var selectrow = $("#TeamPersonGrid").datagrid("getChecked");//获取的是数组，多行数据
    
    for(var i=0;i<selectrow.length;i++){
        
        if (SelectIds==""){
                SelectIds=selectrow[i].PIADM_RowId;
            }else{
                SelectIds=SelectIds+"^"+selectrow[i].PIADM_RowId;
            } 
    }
    /*
    if(selectrow.length>=2){
        $.messager.alert("提示","只能选择一人转组","info");
        return false;
        }
    */
    if(SelectIds=="")
    { 
        $.messager.alert("提示","请选择待转组人员","info");
        return false;
    }
    var iRowId=SelectIds;


    //if (!confirm("是否确定转组")) return false;
    //$.messager.confirm("确认", "是否确定转组", function(r){if (!r) { return false; }});
    $.messager.confirm("确认", "是否确定转组？", function(r){
        if (r){
            
                var flag=tkMakeServerCall("web.DHCPE.CancelPE","CheckIAdmCanCancel",iRowId);
                if(flag=="1") {
                    $.messager.alert("提示","存在已执行或者已交费的项目,不能转组","info");
                    return false;
                }
    
                var iPGADM=getValueById("ID");
    
                var iGTeam=getValueById("PGTRowId");
                
                
                
                
                var lnk="dhcpemoveteam.hisui.csp?ParRef="+iPGADM+"&PIADMRowId="+iRowId+"&PGTeam="+iGTeam;
                websys_lu(lnk,false,'width=800,height=630,hisui=true,title=分组列表')
                
                
            }
    });
    
        
    
}

var init = function(){
    
    $("#IReportSend").combobox("setValue","IS"); //个人报告领取
    SetButtonDisable();
    LoadCard();
    
    if((OperType)&&(OperType=="T"))
    {$('#GroupTab').tabs('select',"团体分组");}
    
    var obj=document.getElementById('ReadCard');
    if (obj) obj.onclick=ReadCardClickHandlerG;
    var obj=document.getElementById('PReadCard');
    if (obj) obj.onclick=ReadCardClickHandler;
    
    $("#Update").css({"width":"110px"});
    $("#GroupTeam").css({"width":"110px"});
    $("#PreGImport").css({"width":"110px"});
    $("#BClear").css({"width":"110px"});
    
    
    
    $("#BRegister").css({"width":"110px"});
    $("#BNewIADM").css({"width":"130px"});
    $("#PNewItem").css({"width":"130px"});
    $("#BAddItem").css({"width":"130px"});
    $("#BCancelSelect").css({"width":"130px"});
    $("#BMoveTeam").css({"width":"120px"});
    $("#BCancelPE").css({"width":"120px"});
    $("#BFind").css({"width":"130px"});
    $("#BSelectPre").css({"width":"130px"});
    $("#PrintTeamSelf").css({"width":"130px"});
    $("#GroupTeam").css({"width":"130px"});
    $("#PreGImport").css({"width":"130px"});
    $("#ImportCheck").css({"width":"130px"});

    $("#GroupTeam").click(function(){
            
            $('#GroupTab').tabs('select',"团体分组");
            var ParRef=getValueById("ID");
            if ((ParRef!="")&&(ParRef!="0")){
                $("#BRegister,#BPrintPatItem,#TCancelPE,#BNew").linkbutton('enable');
                $("#BCancelPE,#BCancelSelect,#BSelectPre,#BFind,#BMoveTeam,#BAddItem,#PNewItem").linkbutton('enable');
                var GStatus=tkMakeServerCall("web.DHCPE.PreGADM","GetStatus",ParRef);
                if (GStatus!="PREREG"){
                    $("#RapidNew").linkbutton('disable');
                }else{
                    $("#RapidNew").linkbutton('enable');
                }
                
            }
        });


    $('#GroupTab').tabs({
    
        onSelect:function(title,index){
            if(title=="团体分组")
            {
                var ParRef=getValueById("ID");
                if ((ParRef!="")&&(ParRef!="0")){
                     $("#BRegister,#BPrintPatItem,#TCancelPE,#BNew").linkbutton('enable');
                    $("#BCancelPE,#BCancelSelect,#BSelectPre,#BFind,#BMoveTeam,#BAddItem,#PNewItem").linkbutton('enable');
                    var GStatus=tkMakeServerCall("web.DHCPE.PreGADM","GetStatus",ParRef);
                    if (GStatus!="PREREG"){
                        $("#RapidNew").linkbutton('disable');
                    }else{
                        $("#RapidNew").linkbutton('enable');
                    }
                
                }
                $("#TeamGrid").treegrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:getValueById("ID")});
    
                
            }
        }
    });
    
     
    
    //查询  <!--选取已预约人员窗口-->
    $("#PreBFind").click(function(){
            PreBFind_click();
        });
        
    //新增 <!--选取已预约人员窗口-->
    $("#PreBAdd").click(function(){
            PreBAdd_click();
        });
    // <!--选取已预约人员窗口-->
     $("#PreRegNo").keydown(function(e) {
            
            if(e.keyCode==13){
                PreBFind_click();
            }
            
        });



      //快速分组
      $HUI.radio("[name='TeamNum']",{
            onChecked:function(e,value){
               var checkedRadioObj = $("input[name='TeamNum']:checked");
                OneData=checkedRadioObj.val();
    
                if ((OneData=="Team_One")||(OneData=="Team_Two")||(OneData=="Team_Three")){
                    $("#AgeBoundary").attr('disabled',true);
                    $("#AgeBoundary").val("")
                }else{
                    $("#AgeBoundary").attr('disabled',false);
                    
                }
               
           }
        });



    $("#BPrintPatItem").click(function(){
            BPrintPatItem_click();
        });
        
    $("#PrintTeamPerson").click(function(){
            PrintTeamPerson_click("");
        }); 
    
    
    $("#ContinueRegNo").keydown(function(e) {
            
            if(e.keyCode==13){
                ConPrintTPerson_click();
            }
            
        });
       
    
    $("#ContinuePrintTeamPer").click(function(){
            ConPrintTPerson_click();
        });
            
    $("#PrintTeamSelf").click(function(){
            PrintTeamSelf_click();
        });     
        
        
    //保存
    $("#Update").click(function(){
            Update();
        });

     //清屏
    $("#BClear").click(function(){
            Clear_click();
        });



    //导入人员
    $("#PreGImport").click(function(){
            //ReadInfo();
            OpenImportWin();
        }); 
    
    $("#ImportCheck").click(function(){
            CheckInfo();
        }); 
    
    
    //新建分组
    $("#BNew").click(function(){
            BNewWin();
        });

    
    //复制分组
    $("#BCopyTeam").click(function(){
            BCopyTeam();
        });     
            

    //快速分组
    $("#RapidNew").click(function(){
            RapidNewWin();
        }); 
        
    
    //删除分组  
    $("#BDelete").click(function(){
            Delete_click();
        }); 

    //取消体检
    $("#TCancelPE").click(function(){
            TCancelPE();
        }); 
    
    //登记
    $("#BRegister").click(function(){
            BRegister();
        });     
    
        
    //公费加项（分组人员）
    $("#PNewItem").click(function(){
            PNewItem();
        }); 

    //自费加项（分组人员）
    $("#BAddItem").click(function(){
            BAddItem();
        });     
        
    //公费加项（分组）
    $("#BNewItem").click(function(){
            BNewItem();
        }); 
        
    //自费加项（分组）
    $("#BAddItems").click(function(){
            BAddItems();
        }); 
    
    
    //更新
    $("#TeamUpdate").click(function(){
            TeamUpdate();
        }); 
        
    //清屏
    $("#TeamClear").click(function(){
            TeamClear();
        });
    
    //存为预置      
    $("#SaveTemplate").click(function(){
            SaveTemplate();
        });
        
    
    //保存
    $("#RapidUpdate").click(function(){
            RapidUpdate();
        }); 

    
    //查询
    $("#BFind").click(function(){
            BFind_Click();
        });
    
    //转组
    $("#BMoveTeam").click(function(){
            BMoveTeam_Click();
        });


   //新建人员
    $("#BNewIADM").click(function(){
            BNewIADM();
        }); 

   //选取已预约人员
    $("#BSelectPre").click(function(){
            BSelectPre();
        }); 
    
    //撤销已预约人员
    $("#BCancelSelect").click(function(){
            BCancelSelect();
        });     
    
    //取消体检
    $("#BCancelPE").click(function(){
            BCancelPE();
        }); 
    
    $("#PAPMINo").change(function(){
            RegNoOnChange();
        });
        
    $("#PAPMINo").keydown(function(e) {
            
            if(e.keyCode==13){
                $("#PAPMINo").dispatchEvent(new Event('change', {}));
            }
            
        });
        
    $("#CardNo").change(function(){
            CardNoOnChange();
        });
        
    $("#CardNo").keydown(function(e) {
            
            if(e.keyCode==13){
                $("#CardNo").dispatchEvent(new Event('change', {}));
            }
            
        });    
        
    $("#RegNo").change(function(){
            PRegNoOnChange();
        });
        
    $("#RegNo").keydown(function(e) {
            
            if(e.keyCode==13){
                
                PRegNoOnChange();
            }
            
        });

    $("#PCardNo").change(function(){
            PCardNoOnChange();
        });
        
    $("#PCardNo").keydown(function(e) {
            
            if(e.keyCode==13){
                PCardNoOnChange();
            }
            
        });

    
    setValueById("ID",GroupID);
    setValueById("PGADM_RowId",GroupID)
    setValueById("DietFlag",DietFlag);
    setValueById("GiftFlag",GiftFlag);
    
    
    //接待人（分组）
    var TeamPEDeskClerkNameObj = $HUI.combogrid("#TeamPEDeskClerkName",{
        panelWidth:470,
        url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXTNew",
        mode:'remote',
        delay:200,
        pagination : true, 
        pageSize: 20,
        pageList : [20,50,100],
        idField:'DocDr',
        textField:'DocName',
        onBeforeLoad:function(param){
            param.Desc = param.q;
            param.Type="B";
            param.LocID=session['LOGON.CTLOCID'];
            param.hospId = session['LOGON.HOSPID'];

        },
        columns:[[

            {field:'DocDr',title:'ID',width:60},
            {field:'DocName',title:'姓名',width:200},
            {field:'Initials',title:'工号',width:140} 
                
        ]]
    });
    
    /*
    var VIPObj = $HUI.combobox("#VIPLevel",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
        valueField:'id',
        textField:'desc',
        onSelect:function(record){
            
            VIPLevelOnChange(record.id);
        }
    });
    
    var RapidVIPObj = $HUI.combobox("#RapidVIPLevel",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
        valueField:'id',
        textField:'desc',
        onSelect:function(record){
            
        }
    });
    
    */
    
    
   var ParentTeamObj = $HUI.combobox("#ParentTeam",{
        url:$URL+"?ClassName=web.DHCPE.PreGTeam&QueryName=SearchGTeam&ResultSetType=array",
        valueField:'PGT_RowId',
        textField:'PGT_Desc',
        onBeforeLoad:function(param){
            param.ParRef = getValueById("ID");
            param.QType = "A";
            param.TeamID=$("#PGTRowId").val();
            
        },
        onShowPanel : function(){
            $(this).combobox('reload');   
          
          }
    });
    
    //VIP等级
   var VIPObj = $HUI.combobox("#VIPLevel",{
        url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
        valueField:'id',
        textField:'desc',
        onSelect:function(record){
            
            VIPLevelOnChange(record.id);
        }
    });

    //VIP等级（快速分组）
    var RapidVIPObj = $HUI.combobox("#RapidVIPLevel",{
        url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
        valueField:'id',
        textField:'desc',
        onSelect:function(record){
            
            
        }
    });
    

    var UserID= session['LOGON.USERID'];
    var LocID= session['LOGON.CTLOCID'];

    var VIPNV=tkMakeServerCall("web.DHCPE.HISUICommon","GetVIP",UserID,LocID);
    
    $('#VIPLevel').combobox('setValue',VIPNV);
    $('#RapidVIPLevel').combobox('setValue',VIPNV);
    
    //诊室位置
    var RoomPlaceObj = $HUI.combobox("#RoomPlace",{
        url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindRoomPlace&ResultSetType=array",
        valueField:'id',
        textField:'desc',
        //mode:'remote',
        onBeforeLoad:function(param){
            var VIP=$("#VIPLevel").combobox("getValue");
            param.VIPLevel = VIP;
            param.GIType = "I";
            param.LocID = session['LOGON.CTLOCID']
        }
        })
        
    $('#RoomPlace').combobox('reload');


    var TempSetObj = $HUI.datagrid("#TempSet",{
        url:$URL,
        fit : true,
        border : false,
        striped : false, //设置为 true，则把行条纹化（即奇偶行使用不同背景色）
        fitColumns : false,
        autoRowHeight : false,
        rownumbers:true,
        pagination : true,  
        pageSize: 10,
        pageList : [10,20,30],
        queryParams:{
            ClassName:"web.DHCPE.PreGTeam",
            QueryName:"GetGTeamTempSet",
            VIP:"",
            ToGID:"",
            GBID:"",
            TemplateFlag:"1"
        },
        
        columns:[[
            {field:'TID',title:'操作',
            formatter:function(value,row,index){
					return "<span style='cursor:pointer;' class='icon-cancel'  onclick='DelGTeamTemp(\""+row.TID+"\")''>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                    return "<a href='#' onclick='DelGTeamTemp(\""+row.TID+"\")'>\
                    <img src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\
                    </a>";
            }},
            {field:'TAgeFrom',title:'年龄上限',width: 100},
            {field:'TAgeTo',title:'年龄下限',width: 100},
            {field:'TSex',hidden:true},
            {field:'THouse',hidden:true},
            {field:'TDesc',title:'分组名称',width: 350},
            {field:'TSexDesc',title:'性别',width: 100},
            {field:'THouseDesc',title:'婚姻',width: 100}
                    
        ]],
        onClickRow:function(rowIndex,rowData){
            
            setValueById("TeamDesc",rowData.TDesc)
            setValueById("UpperLimit",rowData.TAgeFrom)
            setValueById("LowerLimit",rowData.TAgeTo)
            SexDesc=rowData.TSexDesc
            if(SexDesc=="男"){
                $HUI.radio("#TeamSexM").setValue(true);
            }else if(SexDesc=="女"){
                $HUI.radio("#TeamSexF").setValue(true);
            }else{
                $HUI.radio("#TeamSexN").setValue(true);
            }
            MarryDesc=rowData.THouseDesc
            if(MarryDesc=="未婚"){
                $HUI.radio("#TeamMarriedUM").setValue(true);
            }else if(MarryDesc=="已婚"){
                $HUI.radio("#TeamMarriedM").setValue(true);
            }else{
                $HUI.radio("#TeamMarriedN").setValue(true);
            }
            
            
        },
            
    });
    var TeamPersonGridObj = $HUI.datagrid("#TeamPersonGrid",{
        url:$URL,
        fitColumns:true,
        fit:true,
        checkOnSelect:true,
        selectOnCheck:true,
        pagination:true,
        displayMsg:"",
        pageSize:20,
        queryParams:{
            ClassName:"web.DHCPE.PreIADM",
            QueryName:"SearchGTeamIADM",
            GTeam:"",
            RegNo:"",
            Name:"",
            DepartName:"",
            OperType:"",
            Status:""

        },
        onClickRow:function(rowIndex,rowData){
            
            //setValueById("PIADM_RowId",rowData.PIADM_RowId)
            //$("#PNewItem").linkbutton('enable');
            //$("#BAddItem").linkbutton('enable');
        },
        onCheck:function(rowIndex,rowData){
            
            setValueById("PIADM_RowId",rowData.PIADM_RowId);
            //$("#PNewItem").linkbutton('enable');
            //$("#BAddItem").linkbutton('enable'); 
    
        },
        onUncheck:function(rowIndex,rowData){
            setValueById("PIADM_RowId","");
            //$("#PNewItem").linkbutton('disable');
            //$("#BAddItem").linkbutton('disable');
            
        },
        
        columns:[[
            {field:'Sequence',title:'序号',checkbox:true},
            
            {field:'PIADM_PIBI_DR',title:'预约修改',align:'center',
            formatter:function(value,row,index){
	            	return "<span style='cursor:pointer;' class='icon-write-order'  onclick='GIAdmEdit(\""+row.PIADM_RowId+"^"+row.PIADM_PIBI_DR_RegNo+"^"+row.PIADM_PIBI_DR_Name+"^"+row.PIADM_PEDateBegin+"^"+row.PIADM_PETime+"\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                    
                    return "<a href='#' onclick='GIAdmEdit(\""+row.PIADM_RowId+"^"+row.PIADM_PIBI_DR_RegNo+"^"+row.PIADM_PIBI_DR_Name+"^"+row.PIADM_PEDateBegin+"^"+row.PIADM_PETime+"\")'>\
                    <img src='../scripts_lib/hisui-0.1.0/dist/css/icons/write_order.png' border=0/>\
                    </a>";
            }},
            
            {field:'PIADM_RowId',title:'项目明细',align:'center',
            formatter:function(value,row,index){
                    return "<span style='cursor:pointer;' class='icon-eye'  onclick='openIADMItemDetailWin(\""+row.PIADM_RowId+"^PERSON"+"\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                    
                    return "<a href='#' onclick='openIADMItemDetailWin(\""+row.PIADM_RowId+"^PERSON"+"\")'>\
                    <img src='../scripts_lib/hisui-0.1.0/dist/css/icons/eye.png' border=0/>\
                    </a>";
            }},
            {field:'BaseInfo',title:'基本信息',align:'center',
            formatter:function(value,row,index){
	            return "<span style='cursor:pointer;' class='icon-add-note'  onclick='BaseInfo("+index+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                return "<a href='#' onclick='BaseInfo(\""+index+"\")'>\
                    <img src='../scripts_lib/hisui-0.1.0/dist/css/icons/add_note.png' border=0/>\
                    </a>";
                    /*return "<a href='#' onclick='BaseInfo(\""+row.PIADM_PIBI_DR+"\")'>\
                    <img src='../scripts_lib/hisui-0.1.0/dist/css/icons/add_note.png' border=0/>\
                    </a>";
                    */
            }},
            {field:'PIADM_PGADM_DR',hidden:true},
            {field:'Amount',title:'金额'},
            {field:'PIADM_PIBI_DR_RegNo',title:'登记号'},
            {field:'PIADM_PIBI_DR_Name',title:'姓名'},
            {field:'PIADM_PGADM_DR',hidden:true},
            {field:'PIADM_PGADM_DR_Name',hidden:true},
            {field:'PIADM_PGTeam_DR',hidden:true},
            {field:'PIADM_PGTeam_DR_Name',hidden:true},
            {field:'PIADM_PEDateBegin',title:'体检日期'},
            {field:'PIADM_PEDateEnd',title:'截至日期'},
            {field:'PIADM_PETime',hidden:true},
            {field:'PIADM_PEDeskClerk_DR',hidden:true},
            {field:'PIADM_PEDeskClerk_DR_Name',title:'接待人'},
            {field:'PIADM_Status',hidden:true},
            {field:'PIADM_Status_Desc',title:'状态'},
            {field:'PIADM_AsCharged',hidden:true},
            {field:'PIADM_AccountAmount',hidden:true},
            {field:'PIADM_DiscountedAmount',hidden:true},
            {field:'PIADM_SaleAmount',hidden:true},
            {field:'PIADM_FactAmount',hidden:true},
            {field:'PIADM_AuditUser_DR',hidden:true},
            {field:'PIADM_AuditUser_DR_Name',hidden:true},
            {field:'PIADM_AuditDate',hidden:true},
            {field:'PIADM_UpdateUser_DR',hidden:true},
            {field:'PIADM_UpdateUser_DR_Name',hidden:true},
            {field:'PIADM_UpdateDate',hidden:true},
            {field:'PIADM_ChargedStatus',hidden:true},
            {field:'PIADM_ChargedStatus_Desc',hidden:true},
            {field:'PIADM_CheckedStatus',hidden:true},
            {field:'PIADM_CheckedStatus_Desc',hidden:true},
            {field:'PIADM_AddOrdItem',title:'公费加项'},
            {field:'PIADM_AddOrdItemLimit',hidden:true},
            {field:'PIADM_AddOrdItemAmount',hidden:true},
            {field:'PIADM_AddPhcItem',title:'加药'},
            {field:'PIADM_AddPhcItemLimit',hidden:true},
            {field:'PIADM_AddPhcItemAmount',hidden:true},
            {field:'PIADM_IReportSend',hidden:true},
            {field:'PIADM_IReportSend_Desc',hidden:true},
            {field:'PIADM_DisChargedMode',hidden:true},
            {field:'PIADM_DisChargedMode_Desc',title:'结算方式'},
            {field:'PIADM_VIP',hidden:true},
            {field:'PIADMRemark',hidden:true},
            {field:'TArriveDate',title:'到达时间'},
            {field:'TType',title:'职务'},
            {field:'TNewHPNo',title:'体检号'},
            {field:'PACCardDesc',title:'证件类型'},
            {field:'IDCard',title:'证件号'},
            {field:'TPosition',title:'部门',
            formatter:function(value,row,index){
                    return tkMakeServerCall("web.DHCPE.PreCommon","GetPosition","PreADM",row.PIADM_RowId);
            }},
            {field:'TRoomPlace',title:'诊室位置',
            formatter:function(value,row,index){
                    return tkMakeServerCall("web.DHCPE.PreCommon","GetRoomPlace","PreADM",row.PIADM_RowId);
            },styler: function(value,row,index){
                
                    return 'border-right:0;';
                }
            }
            
        ]]
        
    
        });
    
    var TeamGridObj = $HUI.treegrid("#TeamGrid",{
        url: $URL,
        fit: true,
        border: false,
        rownumbers: true,
        animate: true,
        singleSelect: true,
        idField: 'PGT_ChildSub',
        treeField: 'PGT_Desc',
        queryParams:{
            ClassName:"web.DHCPE.PreGTeam",
            QueryName:"SearchGTeam",
            ParRef:GroupID,
            page:1,
            rows:500
        },
        onClickRow:function(rowIndex,rowData){
            
            $("#TeamDetailDiv").layout("resize"); 
            TeamRowIndex=rowIndex;
            setValueById("PGTRowId",rowData.PGT_RowId)
            setValueById("PGTChildSub",rowData.PGT_ChildSub)
            $("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:rowData.PGT_RowId,RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
            $("#BCopyTeam").linkbutton('enable');
            $("#BDelete").linkbutton('enable'); 
            $("#BNewItem").linkbutton('enable');
            $("#BAddItems").linkbutton('enable');
        var flag=tkMakeServerCall("web.DHCPE.PreGADM","IsRegister",rowData.PGT_RowId);
        if(flag==0){
            $("#BRegister").linkbutton('disable');
        }else{
            $("#BRegister").linkbutton('enable');
        }
        
        },
        onLoadSuccess:function(){
            //$('#TeamGrid').datagrid('selectRow', TeamRowIndex);
             /*
               $('#TeamGrid').datagrid('selectRow', 0); //选中列表第一行
               ////加载分组对应得人员/////
               var SelRowData = $("#TeamGrid").treegrid("getSelected");
               setValueById("PGTRowId",SelRowData.PGT_RowId)
                setValueById("PGTChildSub",SelRowData.PGT_ChildSub)
                $("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:SelRowData.PGT_RowId,RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
                $("#BCopyTeam").linkbutton('enable');
                $("#BDelete").linkbutton('enable'); 
                $("#BNewItem").linkbutton('enable');
                var flag=tkMakeServerCall("web.DHCPE.PreGADM","IsRegister",SelRowData.PGT_RowId);
                if(flag==0){
                    $("#BRegister").linkbutton('disable');
                }else{
                    $("#BRegister").linkbutton('enable');
                }
              
              */

        },
        columns:[[
            {field:'GroupID',title:'团体ID',hidden:true},
            {field:'PGT_RowId',title:'分组ID',hidden:true},
            {field:'PGT_ChildSub',title:'操作',align:'center',
            formatter:function(value,row,index){
	            	return "<span style='cursor:pointer;' class='icon-write-order'  onclick='PreTeamEdit(\""+row.PGT_ChildSub+"\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                    return "<a href='#' onclick='PreTeamEdit(\""+row.PGT_ChildSub+"\")'>\
                    <img src='../scripts_lib/hisui-0.1.0/dist/css/icons/write_order.png' border=0/>\
                    </a>";
            }},
            {field:'PGT_ParRef_Name',title:'团体名称',hidden:true},
            {field:'PGT_Desc',title:'分组名称'},
            {field:'teamcheckitem',title:'项目明细',align:'center',
            formatter:function(value,row,index){
                    /*return "<a href='#' onclick='CheckTeamItem(\""+row.PGT_RowId+"\")'>\
                    <img src='../scripts_lib/hisui-0.1.0/dist/css/icons/eye.png' border=0/>\
                    </a>";*/
                    return "<span style='cursor:pointer;' class='icon-eye'  onclick='openIADMItemDetailWin(\""+row.PGT_RowId+"^TEAM"+"\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                    return "<a href='#' onclick='openIADMItemDetailWin(\""+row.PGT_RowId+"^TEAM"+"\")'>\
                    <img src='../scripts_lib/hisui-0.1.0/dist/css/icons/eye.png' border=0/>\
                    </a>";

            }},
            {field:'PGTSex',title:'Sex',hidden:true},
            {field:'PGT_Sex_Desc',title:'性别'},
            {field:'PGT_UpperLimit',title:'年龄上限'},
            {field:'PGT_LowerLimit',title:'年龄下限'},
            {field:'PGTMarried',title:'Married',hidden:true},
            {field:'PGT_Married_Desc',title:'婚姻'},
            {field:'PGTUpdateUserDR',title:'UserID',hidden:true},
            {field:'PGT_UpdateUser_DR_Name',title:'更新人',hidden:true},
            {field:'PGT_UpdateDate',title:'更新时间',hidden:true},
            {field:'PGT_AddOrdItem',title:'公费加项'},
            {field:'PGT_AddOrdItemLimit',title:'加项金额限制',hidden:true},
            {field:'PGT_AddOrdItemAmount',title:'加项金额',hidden:true},
            {field:'PGT_AddPhcItem',title:'允许加药'},
            {field:'PGT_AddPhcItemLimit',title:'开药金额限制',hidden:true},
            {field:'PGT_AddPhcItemAmount',title:'开药金额',hidden:true},
            {field:'PGTGReportSend',title:'GSend',hidden:true},
            {field:'PGT_GReportSend_Name',title:'团体报告发送',hidden:true},
            {field:'PGTIReportSend',title:'ISend',hidden:true},
            {field:'PGT_IReportSend_Name',title:'个人报告发送',hidden:true},
            {field:'PGTDisChargedMode',title:'Mode',hidden:true},
            {field:'PGT_DisChargedMode_Name',title:'结算方式'},
            {field:'PGT_BookDateBegin',title:'预约开始日期'},
            {field:'PGT_BookDateEnd',title:'预约截止日期'},
            {field:'PGT_BookTime',title:'预约时间',hidden:true},
            {field:'PGTPEDeskClerkDR',title:'PEDeskClerk',hidden:true},
            {field:'PGT_PEDeskClerk_DR_Name',title:'接待人',hidden:true},
            {field:'TTotalPerson',title:'人数'},
            {field:'THadChecked',title:'已检名单',align:'center',
            formatter:function(value,row,index){
	                return "<span style='cursor:pointer;' class='icon-paper'  onclick='HadCheckedList(\""+row.PGT_RowId+"\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                    return "<a href='#' onclick='HadCheckedList(\""+row.PGT_RowId+"\")'>\
                    <img src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png' border=0/>\
                    </a>";
            }},
            {field:'TNoCheckDetail',title:'未检名单',align:'center',
            formatter:function(value,row,index){
	            	return "<span style='cursor:pointer;' class='icon-paper'  onclick='NoCheckedList(\""+row.PGT_RowId+"\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                    return "<a href='#' onclick='NoCheckedList(\""+row.PGT_RowId+"\")'>\
                    <img src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png' border=0/>\
                    </a>";
            }},
            {field:'TCancelPEDetail',title:'取消体检名单',align:'center',
            formatter:function(value,row,index){
	            	return "<span style='cursor:pointer;' class='icon-paper'  onclick='CancelPEList(\""+row.PGT_RowId+"\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
                    return "<a href='#' onclick='CancelPEList(\""+row.PGT_RowId+"\")'>\
                    <img src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png' border=0/>\
                    </a>";
            }},

            {field:'TRoomPlace',title:'诊室位置',
            formatter:function(value,row,index){
                    return tkMakeServerCall("web.DHCPE.PreCommon","GetRoomPlace","PGTADM",row.PGT_RowId);
            }}
            
        ]]
        
    
        });
    
    //团体
    var GroupDescObj = $HUI.combogrid("#GroupDesc",{
        panelWidth:430,
        url:$URL+"?ClassName=web.DHCPE.PreGBaseInfo&QueryName=SearchGListByDesc",
        mode:'remote',
        delay:200,
        pagination : true, 
        pageSize: 20,
        pageList : [20,50,100],
        idField:'GBI_RowId',
        textField:'GBI_Desc',
        onBeforeLoad:function(param){
            param.GBIDesc = param.q;
            
        },
        onSelect:function(rowIndex, rowData){
            
            setValueById("GroupCode",rowData.GBI_Code)
            ID="^"+rowData.GBI_Code
            
            GroupDescSelect(ID)
             
            },
        columns:[[
            {field:'GBI_RowId',hidden:true},
            {field:'GBI_Code',title:'团体编码',width:150},
            {field:'GBI_Desc',title:'团体名称',width:250}
            
            
            
        ]]
    });

    //体检类别
    var PatFeeTypeNameObj = $HUI.combobox("#PatFeeTypeName",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatFeeTypeName&ResultSetType=array",
        valueField:'id',
        textField:'Desc'
    });
    
    //部门
    var DepartNameObj = $HUI.combobox("#DepartName",{
        url:$URL+"?ClassName=web.DHCPE.PreGTeam&QueryName=SearchGDepart&ResultSetType=array",
        valueField:'DepartName',
        textField:'DepartName',
        onBeforeLoad:function(param){
            param.GID=getValueById("ID");
            param.TeamID="";
            param.Type="PGADM";
            param.Depart=param.q;
        }
    });
    
    //姓名
    var PatNameObj = $HUI.combogrid("#PatName",{
        panelWidth:430,
        url:$URL+"?ClassName=web.DHCPE.PreIBaseInfo&QueryName=PreIBaseInfoList",
        mode:'remote',
        delay:200,
        pagination : true, 
        pageSize: 20,
        pageList : [20,50,100],
        idField:'编码',
        textField:'姓名',
        onBeforeLoad:function(param){
            param.Name = param.q;
        },
        onClickRow:function(rowIndex,rowData){

            setValueById("RegNo",rowData.登记号)
            setValueById("PIBI_RowId",rowData.编码)
            $("#BNewIADM").linkbutton('enable');
        
        },
        columns:[[
            {field:'编码',title:'编码',width:80},
            {field:'登记号',title:'登记号',width:140},
            {field:'姓名',title:'姓名',width:150}
            
            
            
        ]]
    });
    
    //体检类别（快速分组）
    var RapidPatFeeTypeNameObj = $HUI.combobox("#RapidPatFeeTypeName",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatFeeTypeName&ResultSetType=array",
        valueField:'id',
        textField:'Desc'
    });

    //检查种类（分组）
    var TeamOMETypeObj = $HUI.combobox("#OMEType",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindOMEType&ResultSetType=array",
        valueField:'id',
        textField:'Desc',
        onBeforeLoad: function(param){
            param.VIPLevel=$("#VIPLevel").combobox('getValue'); 
        }   
    });
    
    //危害因素（分组）
    var HarmInfoObj = $HUI.combotree("#HarmInfo",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&MethodName=GetHarmInfo&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
        checkbox:true,
        multiple:true,
        onlyLeafCheck:true
            
        });

   //体检类别（分组）
    var TeamPatFeeTypeNameObj = $HUI.combobox("#TeamPatFeeTypeName",{
        url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatFeeTypeName&ResultSetType=array",
        valueField:'id',
        textField:'Desc'
    });
    
   //业务员
    var SalesObj = $HUI.combogrid("#Sales",{
        panelWidth:400,
        url:$URL+"?ClassName=web.DHCPE.PreIADM&QueryName=UserListNew",
        mode:'remote',
        delay:200,
        pagination : true, 
        pageSize: 20,
        pageList : [20,50,100],
        idField:'HIDDEN',
        textField:'姓名',
        onBeforeLoad:function(param){
            param.Desc = param.q;
            param.Type="B";
            param.LocID=session['LOGON.CTLOCID'];
            param.hospId = session['LOGON.HOSPID'];

        },
        columns:[[
            {field:'HIDDEN',hidden:true},
            {field:'工号',title:'工号',width:100},
            {field:'姓名',title:'姓名',width:240}
            
            
            
        ]]
    });
    
    
    //接待人
    var PEDeskClerkNameObj = $HUI.combogrid("#PEDeskClerkName",{
        panelWidth:450,
        url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXTNew",
        mode:'remote',
        delay:200,
        pagination : true, 
        pageSize: 20,
        pageList : [20,50,100],
        idField:'DocDr',
        textField:'DocName',
        onBeforeLoad:function(param){
            param.Desc = param.q;
            param.Type="B";
            param.LocID=session['LOGON.CTLOCID'];
            param.hospId = session['LOGON.HOSPID'];

        },
        columns:[[

            {field:'DocDr',title:'ID',width:60},
            {field:'DocName',title:'姓名',width:200},
            {field:'Initials',title:'工号',width:140} 
            
            
            
        ]]
    });
    
    
    //团体合同
    var ContractObj = $HUI.combogrid("#Contract",{
        panelWidth:640,
        url:$URL+"?ClassName=web.DHCPE.Contract&QueryName=SerchContract",
        mode:'remote',
        delay:200,
        pagination : true, 
        pageSize: 20,
        pageList : [20,50,100],
        idField:'TID',
        textField:'TName',
        onBeforeLoad:function(param){
            param.Contract = param.q;
        },
        
        columns:[[
            {field:'TID',hidden:true},
            {field:'TNo',title:'合同编号',width:100},
            {field:'TName',title:'合同名称',width:100},
            {field:'TSignDate',title:'签订日期',width:100},
            {field:'TRemark',title:'备注',width:100},
            {field:'TCreateDate',title:'录入日期',width:100},
            {field:'TCreateUser',title:'录入人',width:100}
        ]]
    });
    
    
    var obj=document.getElementById('ID');
    if (obj && ""!=obj.value) {
            var ret=tkMakeServerCall("web.DHCPE.PreGADM","DocListBroker","","",obj.value+"^");
            
            SetPatient_Sel(ret);
        
    }
}

function CardNoOnChange()
{
    
    CardNoChangeAppHISUI("PAPMINo","CardNo","RegNoOnChange()","Clear_click()","0");
    
}
function CardNoChangeAppHISUI(RegNoElement,CardElement,AppFunction,AppFunctionClear,ClearFlag)
{
    
    var obj;
    var CardNo="",SelectCardTypeRowID="";
    obj=document.getElementById(CardElement);
    if (obj) CardNo=obj.value;
    if (CardNo=="") return;
    if (ClearFlag=="1") eval(AppFunctionClear);
    obj.value=CardNo;
    
    var SelValue=$HUI.combobox("#CardType").getValue();
    if (SelValue==""){return;}
    var myary=SelValue.split("^");
    var myCardTypeDR=myary[0];
    if (myCardTypeDR==""){return;}
    SelectCardTypeRowID=myCardTypeDR;
    
    CardNo=CardNo+"$"+SelectCardTypeRowID;
    
    RegNo=tkMakeServerCall("web.DHCPE.PreIBIUpdate","GetRelate",CardNo,"C");
    
    if (RegNo=="") {
        $.messager.alert("提示","未找到记录","info");
        return;
    }

    obj=document.getElementById(RegNoElement);
    if (obj)
    {
        obj.value=RegNo;
        eval(AppFunction);
    }
}

function LoadCard()
{
    var HospID=session['LOGON.HOSPID']
    $.m({
            ClassName:"web.UDHCOPOtherLB",
            MethodName:"ReadCardTypeDefineListBroker",
            JSFunName:"GetCardTypeToHUIJson",
            ListName:"",
            SessionStr:"^^^^"+HospID
        },function(val){
            
            var ComboJson=JSON.parse(val); 
            
            $HUI.combobox('#CardType',{
                data:ComboJson,
                valueField:'id',    
                textField:'text',
            onSelect:function(record){
                CardTypeKeydownHandlerG();
            }
        });
        CardTypeKeydownHandlerG();
        });
        
    $.m({
            ClassName:"web.UDHCOPOtherLB",
            MethodName:"ReadCardTypeDefineListBroker",
            JSFunName:"GetCardTypeToHUIJson",
            ListName:"",
            SessionStr:"^^^^"+HospID
        },function(val){
            
            var ComboJson=JSON.parse(val); 
            
            $HUI.combobox('#PCardType',{
                data:ComboJson,
                valueField:'id',    
                textField:'text',
            onSelect:function(record){
                CardTypeKeydownHandler();
            }
        });
        CardTypeKeydownHandler();
        }); 
        
    
}
function DisableBtn(id,disabled){
    if (disabled){
        $HUI.linkbutton("#"+id).disable();
    }else{
        $HUI.linkbutton("#"+id).enable();
    }
}
function GetCardEqRowIdA(){
    var CardEqRowId="";
    var CardTypeValue=$HUI.combobox("#PCardType").getValue();
    
    if (CardTypeValue!=""){
        var CardTypeArr=CardTypeValue.split("^")
        CardEqRowId=CardTypeArr[14];
    }
    return CardEqRowId;
}

function CardTypeKeydownHandler(){
    var SelValue=$HUI.combobox("#PCardType").getValue();
    
    if (SelValue==""){return;}
    var myary=SelValue.split("^");
    var myCardTypeDR=myary[0];
    if (myCardTypeDR==""){return;}
    
    if (myary[16]=="Handle"){;
        $("#PCardNo").attr("disabled",false);
        DisableBtn("PReadCard",true);
        $("#PCardNo").focus();
    }else{
        $("#PCardNo").attr("disabled",true);
        DisableBtn("PReadCard",false);
        $("#PReadCard").focus();
        
        m_CCMRowID=GetCardEqRowIdA();
        var myobj=document.getElementById("PCardNo");
        
        if (myobj){myobj.readOnly = false;} 
        var obj=document.getElementById("PReadCard");
        if (obj){
            obj.disabled = false;
            
        }
        DHCWeb_setfocus("PReadCard");
    }
}
function GetCardEqRowIdG(){
    var CardEqRowId="";
    var CardTypeValue=$HUI.combobox("#CardType").getValue();
    
    if (CardTypeValue!=""){
        var CardTypeArr=CardTypeValue.split("^")
        CardEqRowId=CardTypeArr[14];
    }
    return CardEqRowId;
}

function CardTypeKeydownHandlerG(){
    var SelValue=$HUI.combobox("#CardType").getValue();
    
    if (SelValue==""){return;}
    var myary=SelValue.split("^");
    var myCardTypeDR=myary[0];
    if (myCardTypeDR==""){return;}
    
    if (myary[16]=="Handle"){;
        $("#CardNo").attr("disabled",false);
        DisableBtn("ReadCard",true);
        $("#CardNo").focus();
    }else{
        $("#CardNo").attr("disabled",true);
        DisableBtn("ReadCard",false);
        $("#ReadCard").focus();
        
        m_CCMRowID=GetCardEqRowIdG();
        var myobj=document.getElementById("CardNo");
        
        if (myobj){myobj.readOnly = false;} 
        var obj=document.getElementById("ReadCard");
        if (obj){
            obj.disabled = false;
            
        }
        DHCWeb_setfocus("ReadCard");
    }
}

function PCardNoOnChange()
{
    
    PCardNoChangeAppHISUI("RegNo","PCardNo","PRegNoOnChange()","","");
    
}

function PCardNoChangeAppHISUI(RegNoElement,CardElement,AppFunction,AppFunctionClear,ClearFlag)
{
    var obj;
    var CardNo="",SelectCardTypeRowID="";
    obj=document.getElementById(CardElement);
    if (obj) CardNo=obj.value;
    if (CardNo=="") return;
    if (ClearFlag=="1") eval(AppFunctionClear);
    
    obj.value=CardNo;
    
    var SelValue=$HUI.combobox("#PCardType").getValue();
    if (SelValue==""){return;}
    var myary=SelValue.split("^");
    var myCardTypeDR=myary[0];
    if (myCardTypeDR==""){return;}
    SelectCardTypeRowID=myCardTypeDR;
    
    CardNo=CardNo+"$"+SelectCardTypeRowID;
    
    RegNo=tkMakeServerCall("web.DHCPE.PreIBIUpdate","GetRelate",CardNo,"C");
    
    if (RegNo=="") return;
    obj=document.getElementById(RegNoElement);
    if (obj)
    {
        obj.value=RegNo;
        eval(AppFunction);
    }
}

function PSetPatient_Sel(value) {

    var obj;
    var Data=value.split("^");
    var iLLoop=0;
    
    iRowId=Data[iLLoop];
    iLLoop=iLLoop+1;
    
    if ("0"==iRowId){
        //  PIBI_PAPMINo    登记号 1
        setValueById("PIBI_RowId","")
        setValueById("RegNo","")
        
        alert("无效登记号!");
        
        return false;
    };
    
    setValueById("PIBI_RowId",Data[0])
    setValueById("RegNo",Data[1])
    setValueById("PatName",Data[2])     
    setValueById("PCardNo",Data[32])    
    
    $("#BNewIADM").linkbutton('enable');
    
    
    
}

function FindPatDetailTeam(ID){
    var Instring=ID;
    
    var SelValue=$HUI.combobox("#PCardType").getValue();
    
    if (SelValue==""){return;}
    var myary=SelValue.split("^");
    var myCardTypeDR=myary[0];
    if (myCardTypeDR==""){return;}
    
    
    var flag=tkMakeServerCall("web.DHCPE.PreIBaseInfo","DocListBroker",'','',Instring+"$"+myCardTypeDR);
    PSetPatient_Sel(flag)

}

function PRegNoOnChange()
{
        var obj;
        var CTLocID=session['LOGON.CTLOCID'];
        var iRegNo=getValueById("RegNo");
        iRegNo = RegNoMask(iRegNo,CTLocID);
        
        
        var IBaseInfoID=tkMakeServerCall("web.DHCPE.PreIBaseInfo","GetIBaseInfoIDByADM",iRegNo);
        
        if (IBaseInfoID==""){
                setValueById("RegNo","")
                setValueById("PCardNo","")
                setValueById("PatName","")
                 $.messager.popover({msg: "无效客户信息", type: "info"});
                //alert("无效客户信息");
                return false;
        
        }
        iRegNo="^"+iRegNo+"^";
        
        FindPatDetailTeam(iRegNo);
    
    
}

function RegNoOnChange() {
    
        var CTLocID=session['LOGON.CTLOCID'];
        var iPAPMINo=getValueById("PAPMINo");
        if(iPAPMINo=="")
        {
            return false;
        }
        iPAPMINo = RegNoMask(iPAPMINo,CTLocID);
        
        setValueById("PAPMINo",iPAPMINo)
        
        var GCode=tkMakeServerCall("web.DHCPE.PreGBaseInfo","GetGCodeByADM",iPAPMINo);
        
        if (GCode=="") {
            $.messager.alert("提示", "该人员属于个人，请在个人预约界面操作！", "info")
            Clear_click();
        
            return false;
        }
        
        ID="^"+GCode;
        
        FindPatDetail(ID);  
        
}


function Delete_click() {
     
    var iRowId="";
    iRowId=getValueById("PGTRowId")
    var iParRef=getValueById("ID")
    if (iRowId=="") {
        $.messager.alert("提示","请先选择分组记录","info"); 
        return false;
    } 
    else{
        $.messager.confirm("确认", "是否确定删除该分组", function(r){
        if (r){
            
            var SubTeam=tkMakeServerCall("web.DHCPE.PreGTeam","GetSubTeamByID",iRowId);
            if(SubTeam)
            {
                $.messager.alert("提示","该分组有未删除的子分组记录,不能删除!","info"); 
                return false;
            
            }
        
            var flag=tkMakeServerCall("web.DHCPE.PreGTeam","Delete",'','',iRowId);
            
            if (flag=='0') {
                $("#PGTRowId").val("");
                $("#TeamGrid").treegrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:iParRef}); 
                $("#BCopyTeam").linkbutton('disable');
                $("#BDelete").linkbutton('disable');    
                $("#BNewItem").linkbutton('disable');
                $("#BAddItems").linkbutton('disable');
                }
            else{
                var Errs=flag.split("^");
                
                //删除团体组所属人员时发生错误
                if ("IADM Err"==Errs[0]) {
                    $.messager.alert("提示","人员登记记录删除错误："+Errs[1],"info"); 
                    
                }
                
                //删除团体组时发生错误
                if ("GTeam Err"==Errs[0]) {
                    $.messager.alert("提示","团体组记录删除错误："+Errs[1],"info"); 
                    
                }
                
                if ("2"==Errs[0]) {
                    $.messager.alert("提示","团体中已有人员","info"); 
                    
                }
                
                return false;
            }

        }
        });
    }
}

function GroupDescSelect(ID)
{
    
    FindPatDetailSelect(ID)
}
function FindPatDetailSelect(ID){

    var Instring=ID;

    var flag=tkMakeServerCall("web.DHCPE.PreGADM","DocListBroker","","",Instring);
    
    SetPatient_SelSelect(flag);
}
function FindPatDetail(ID){

    var Instring=ID;

    var flag=tkMakeServerCall("web.DHCPE.PreGADM","DocListBroker","","",Instring);
    
    SetPatient_Sel(flag);
}
function SetPatient_SelSelect(value) {
    

    var obj;
    var Data=value.split(";");
    var PAPMINo=$("#PAPMINo").val();
    var IsShowAlert=Data[2];
    
    if (("Y"==IsShowAlert)&&(PAPMINo=="")) {
        $.messager.confirm("确认", "此团体已有预约，是否再次预约？", function(data){ 
        if (data) {
        }
        else{
                Clear_click();
            
            }
        }
            
        );
    }
    //登记信息
    var PreGADMData=Data[1];
    if (""!=PreGADMData) { SetPreGADM(PreGADMData); }
    
    //团体信息
    var PreGBaseGnfoData=Data[0];
    
    if (""!=PreGBaseGnfoData) { SetPreGBaseInfoSelect(PreGBaseGnfoData) }

        
}


function SetPatient_Sel(value) {
    
    
    //Clear_click();

    var obj;
    var Data=value.split(";");
    
    var IsShowAlert=Data[2];
    
    if ("Y"==IsShowAlert) {
        
        
        
        $.messager.confirm("确认", "此团体已有预约，是否再次预约？", function(data){ 
        if (data) {
        }
        else{
                Clear_click();
            
            }
        }
            
        );
        
        
    }
    
    //登记信息
    var PreGADMData=Data[1];
    if ((""!=PreGADMData)&&(PreGADMData.split("^")[0]!=0)) { SetPreGADM(PreGADMData); }
    
    //团体信息
    var PreGBaseGnfoData=Data[0];
    
    if ((""!=PreGBaseGnfoData)&&(PreGBaseGnfoData.split("^")[0]!=0)) { SetPreGBaseInfo(PreGBaseGnfoData) }

        
}
//登记信息
function SetPreGADM(value) {
    var obj;
    var fillData;
    var Data=value.split("^");
    var iLLoop=0;   
    iRowId=Data[iLLoop];
    var CurDate="";
    var GReportSend="AC"; //团体报告发送  默认值"挂账可取"
    var IReportSend="IS"; //个人报告领取  默认值"自取"
    
    CurDate=tkMakeServerCall("web.DHCPE.PreGADM","GetDefaultDate");
    
    setValueById("BookDateBegin",CurDate)
    setValueById("BookDateEnd",CurDate)
    
    $("#GReportSend").combobox("setValue",GReportSend); //团体报告发送
    $("#IReportSend").combobox("setValue",IReportSend);  //个人报告领取
    
    
    //视同收费 PIADM_AsCharged
    
    if (Default)
    {
        if ((Default=="2")||(Default=="3")){setValueById("AsCharged",true)}
        else{
            setValueById("AsCharged",false)
            }
            
        
    }
        
    
    if ('0'==iRowId) { return true; }
    
    
    //团体ADM 0
    setValueById("PGADM_RowId",iRowId)

    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    // PGADM_PGBI_DR    预团体客户RowId 2
    setValueById("PGBI_RowId",fillData)

    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    // PGADM_BookDateBegin  预约日期 4
    setValueById("BookDateBegin",fillData)
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    
    // PGADM_BookDateEnd 29
    setValueById("BookDateEnd",fillData)
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    
    // PGADM_BookTime   预约时间 5
    setValueById("BookTime",fillData)
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    // PGADM_AuditUser_DR   预约接待人员 16
    //setValueById("PEDeskClerkName",fillData)
    $("#PEDeskClerkNameID").val(fillData)
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    $("#PEDeskClerkName").combogrid('setValue',fillData)
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    
    // PGADM_Status 状态 8
    setValueById("Status",fillData)
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
        
    // PGADM_AsCharged  视同收费 3
    
    
    if (fillData=="Y"){setValueById("AsCharged",true);
        }
    else{setValueById("AsCharged",false);
        }
    
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    
    var strLine=""
    strLine=strLine+fillData+"^"; 
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    strLine=strLine+fillData+"^"; 
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    strLine=strLine+fillData+"^"; 
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    strLine=strLine+fillData+"^"; 
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    strLine=strLine+fillData+"^"; 
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    strLine=strLine+fillData+"^"; 
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    
    SetAddItem(strLine);
    
    // PGADM_GReportSend 团体报告发送 26
    setValueById("GReportSend",fillData);
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];

    // PGADM_IReportSend 个人报告发送 27
    setValueById("IReportSend",fillData)
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];

    // PGADM_DisChargedMode 结算方式 28
    setValueById("DisChargedMode",fillData)
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    
    // PGADM_DelayDate
    setValueById("DelayDate",fillData)
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    
    // PGADM_Remark 备注 6
    setValueById("Remark",fillData)
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    
    setValueById("PAPMINo",fillData)
    iLLoop=iLLoop+3;
    fillData=Data[iLLoop];
    // PGADM_PEDeskClerk_DR 预约接待人员 15
    $("#Sales").combogrid('grid').datagrid('reload',{'q':Data[iLLoop+1]});
    setValueById("Sales",fillData)

    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];

    
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    // PGADM_AuditUser_DR   业务员 31
    setValueById("Type",fillData)
    
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    // PGADM_AuditUser_DR   业务员 32
    setValueById("GetReportDate",fillData)
    
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    // PGADM_AuditUser_DR   业务员 33
    setValueById("GetReportTime",fillData)
    
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    // PGADM_AuditUser_DR   业务员 33
    setValueById("PayType",fillData)
    
    
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    // PGADM_AuditUser_DR   业务员 33
    setValueById("Percent",fillData)
    
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    //  就诊类别 用于取计费价格
    setValueById("PatFeeTypeName",fillData)
    
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    //  合同ID
    setValueById("Contract",fillData)
    iLLoop=iLLoop+1;
    fillData=Data[iLLoop];
    //  合同名称
    return true;
        

}
function SetTeamAddItem(value) {
    var Data=value.split("^");
    var iLLoop=0;   

    if ("Y"==Data[iLLoop]) {
        setValueById("TeamAddOrdItem",true);    
    }
    else { 
    
        $("#TeamAddOrdItemLimit").checkbox("disable");
        $("#TeamAddOrdItemAmount").attr('disabled',true);
    }
    
    iLLoop=iLLoop+1;        
    if ("Y"==Data[iLLoop]) {
        setValueById("TeamAddOrdItemLimit",true);
        setValueById("TeamAddOrdItemAmount",Data[iLLoop+1])
        $("#TeamAddOrdItemAmount").attr('disabled',false);  
    }
    else { 
        setValueById("TeamAddOrdItemLimit",false);
        setValueById("TeamAddOrdItemAmount",Data[iLLoop+1])
        $("#TeamAddOrdItemAmount").attr('disabled',true);
        
    }
    
    iLLoop=iLLoop+1;    
    iLLoop=iLLoop+1;    
    //  允许加药    
    if ("Y"==Data[iLLoop]) {
        setValueById("TeamAddPhcItem",true);
    }
    
    
    iLLoop=iLLoop+1;    
    
    
}
function SetAddItem(value) {
    
    var Data=value.split("^");
    var iLLoop=0;   
    
    var iAddOrdItem=false;
    
    //  允许加项    PGADM_AddOrdItem    19
    obj=document.getElementById("AddOrdItem");
    if (obj) {
        if ("Y"==Data[iLLoop]) {
            setValueById("AddOrdItem",true)
            iAddOrdItem=true;
            
        }
        else { 
            setValueById("AddOrdItem",false)
            iAddOrdItem=false;
        }
                
    }
    iLLoop=iLLoop+1;    
    
    var iAddOrdItemLimit=false;
    //  加项金额限制  PGADM_AddOrdItemLimit   20
    obj=document.getElementById("AddOrdItemLimit");
    if (obj) { 
        if (iAddOrdItem) {
            obj.disabled=false;
            if ("Y"==Data[iLLoop]) {
                setValueById("AddOrdItemLimit",true)
                iAddOrdItemLimit=true;
            }
            else {
                obj.checked=false;
                iAddOrdItemLimit=false;
            }
            
        }
        else {
            obj.disabled=true;
            
            obj.checked=false;
            iAddOrdItemLimit=false;
                            
        }
    }
    iLLoop=iLLoop+1;    
    
    //  允许加项金额  PGADM_AddOrdItemAmount  21
    obj=document.getElementById("AddOrdItemAmount");
    if (obj) {
        if (iAddOrdItemLimit) {
            obj.disabled=false;
            setValueById("AddOrdItemAmount",Data[iLLoop])
        }
        else{
            obj.disabled=true;
            
            obj.value="";
        }
        
    }
    iLLoop=iLLoop+1;    
    
    //  允许加药    PGADM_AddPhcItem    22
    var iAddPhcItem=false;
    obj=document.getElementById("AddPhcItem");
    if (obj) {
        if ("Y"==Data[iLLoop]) {
            setValueById("AddPhcItem",true)
            iAddPhcItem=true;
        }
        else {
            setValueById("AddPhcItem",false)
            iAddPhcItem=false
        }

    }
    iLLoop=iLLoop+1;    
    
    
}

function SetPreGBaseInfoSelect(value) {

    var obj;
    
    var Data=value.split("^");
    var iLLoop=0;

    var iRowId=Data[iLLoop];    
    
    iLLoop=iLLoop+1;
    if ("0"==iRowId) {
    

        //单位编码  PGBI_Code   1
        
        setValueById("GroupCode",Data[iLLoop])
        iLLoop=iLLoop+1;
        //描    述    PGBI_Desc   2
        $("#GroupDesc").combogrid("setText",Data[iLLoop])
    
        return false;
    }

    
    setValueById("PGBI_RowId",iRowId)
    //单位编码  PGBI_Code   1
    setValueById("GroupCode",Data[iLLoop])

    iLLoop=iLLoop+1;
    //描    述    PGBI_Desc   2
    
    
    iLLoop=iLLoop+1;
    //地    址    PGBI_Address    3
    setValueById("Address",Data[iLLoop])

    iLLoop=iLLoop+1;
    //邮政编码  PGBI_Postalcode 4
    setValueById("Postalcode",Data[iLLoop])

    iLLoop=iLLoop+1;
    //联系人   PGBI_Linkman    5
    setValueById("Linkman",Data[iLLoop])
    

    iLLoop=iLLoop+1;
    //业务银行  PGBI_Bank   6
    setValueById("Bank",Data[iLLoop])
    

    iLLoop=iLLoop+1;
    //帐    号    PGBI_Account    7
    setValueById("Account",Data[iLLoop])
    
    iLLoop=iLLoop+1;
    //联系电话1 PGBI_Tel1   8
    setValueById("Tel1",Data[iLLoop])

    iLLoop=iLLoop+1;
    //联系电话2 PGBI_Tel2   9
    setValueById("Tel2",Data[iLLoop])

    iLLoop=iLLoop+1;
    //电子邮件  PGBI_Email  10
    setValueById("Email",Data[iLLoop])
    
    iLLoop=iLLoop+3;
    //电子邮件  PGBI_PAPMINo    10
    setValueById("PAPMINo",Data[iLLoop])
    iLLoop=iLLoop+2;
    //  CardNo  10
    setValueById("CardNo",Data[iLLoop])
    
    return true;
    
    
    
    
}

//团体信息
function SetPreGBaseInfo(value) {

    var obj;
    
    var Data=value.split("^");
    var iLLoop=0;

    var iRowId=Data[iLLoop];    
    
    iLLoop=iLLoop+1;
    if ("0"==iRowId) {
    

        //单位编码  PGBI_Code   1
        
        setValueById("GroupCode",Data[iLLoop])
        iLLoop=iLLoop+1;
        //描    述    PGBI_Desc   2
        $("#GroupDesc").combogrid("setText",Data[iLLoop])
    
        return false;
    }

        
    setValueById("PGBI_RowId",iRowId)
    //单位编码  PGBI_Code   1
    setValueById("GroupCode",Data[iLLoop])

    iLLoop=iLLoop+1;
    //描    述    PGBI_Desc   2
    //setValueById("GroupDesc",iRowId)
    //$("#GroupDesc").combogrid("setText",Data[iLLoop])
    $("#GroupDesc").combogrid('grid').datagrid('reload',{'q':Data[iLLoop]});
    setValueById("GroupDesc",iRowId)

    iLLoop=iLLoop+1;
    //地    址    PGBI_Address    3
    setValueById("Address",Data[iLLoop])

    iLLoop=iLLoop+1;
    //邮政编码  PGBI_Postalcode 4
    setValueById("Postalcode",Data[iLLoop])

    iLLoop=iLLoop+1;
    //联系人   PGBI_Linkman    5
    setValueById("Linkman",Data[iLLoop])
    

    iLLoop=iLLoop+1;
    //业务银行  PGBI_Bank   6
    setValueById("Bank",Data[iLLoop])
    

    iLLoop=iLLoop+1;
    //帐    号    PGBI_Account    7
    setValueById("Account",Data[iLLoop])
    
    iLLoop=iLLoop+1;
    //联系电话1 PGBI_Tel1   8
    setValueById("Tel1",Data[iLLoop])

    iLLoop=iLLoop+1;
    //联系电话2 PGBI_Tel2   9
    setValueById("Tel2",Data[iLLoop])

    iLLoop=iLLoop+1;
    //电子邮件  PGBI_Email  10
    setValueById("Email",Data[iLLoop])
    
    iLLoop=iLLoop+3;
    //电子邮件  PGBI_PAPMINo    10
    setValueById("PAPMINo",Data[iLLoop])
    iLLoop=iLLoop+2;
    //  CardNo  10
    setValueById("CardNo",Data[iLLoop])
    
    return true;
        
    
}

var OldPGBIID="";
function Update() {
    var iRowId="";
    var iPGBIDR="", iAsCharged="", iBookDateBegin="", iBookDateEnd="", iBookTime="", iRemark="", 
        iContractNo="", iStatus="",
        iAccountAmount="", iDiscountedAmount="", iFactAmount="",
        iAuditUserDR="", iAuditDate="", 
        iUpdateUserDR="", iUpdateDate="", 
        iPEDeskClerkDR="", iSaleAmount="",
        iChargedStatus="", iChargedStatusDesc="", 
        iCheckedStatus="", iCheckedStatusDesc="", 
        iAddOrdItem="", iAddOrdItemLimit="", iAddOrdItemAmount="", 
        iAddPhcItem="", iAddPhcItemLimit="", iAddPhcItemAmount="", 
        iGReportSend="", iGReportSendDesc="", 
        iIReportSend="", iIReportSendDesc="",
        iDisChargedMode="", iDisChargedModeDesc="",iDelayDate="",Sales="",
        Type="",GetReportDate="",GetReportTime="",PayType="",Percent=""
        DietFlag="1",GiftFlag="0",PatFeeType="",Contract="";
        var obj;
    
    // PGADM_RowId  团体ADM 1
    
    
    iRowId=getValueById("PGADM_RowId")
    if(iRowId=="0") {var iRowId="";}
    
    


    // PGADM_PGBI_DR    预团体客户RowId 2
    iPGBIDR=getValueById("PGBI_RowId")
    
    
    if (($("#GroupDesc").combogrid('getValue'))==($("#GroupDesc").combogrid('getText'))||(($("#GroupDesc").combogrid('getText')=="")))  {
        $.messager.alert("提示","团体名称选择不正确！","info");
        return false;
    }
    
    if((iRowId!="")&&(OldPGBIID!="")&&($("#GroupDesc").combogrid('getValue')!=OldPGBIID)){
    var ExsitFlag=tkMakeServerCall("web.DHCPE.PreGADM","IsExsitIADMByGroup",iRowId);
        if(ExsitFlag=="1"){
            $.messager.alert("提示","该团体已有人员，不能直接修改预约记录，请清屏后重新预约！","info");
            return false;
        
        }
    }



    // PGADM_BookDateBegin  预约日期 4
    iBookDateBegin=getValueById("BookDateBegin")
    

    // PGADM_BookDateEnd 29
    iBookDateEnd=getValueById("BookDateEnd")
    var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat");
     if (dtformat=="YMD"){
          var BeginYear=iBookDateBegin.split("-")[0];
          var EndYear=iBookDateEnd.split("-")[0];
      }
      if (dtformat=="DMY"){
         var BeginYear=iBookDateBegin.split("/")[2];
         var EndYear=iBookDateEnd.split("/")[2];
      }
      
    if(BeginYear<1840){
        $.messager.alert('提示','体检起始日期不能小于1840年!',"info"); 
        return false;
    }
    if(EndYear<1840){
        $.messager.alert('提示','截止日期不能小于1840年!',"info"); 
        return false;
    }
    // PGADM_BookTime   预约时间 5
    iBookTime=getValueById("BookTime")
    
    // PGADM_AuditUser_DR   预约接待人员 16
    iPEDeskClerkDR=$("#PEDeskClerkName").combogrid("getValue")
    if (($("#PEDeskClerkName").combogrid('getValue')==undefined)||($("#PEDeskClerkName").combogrid('getText')=="")){var iPEDeskClerkDR="";}
    /*if(iPEDeskClerkDR!="")
    {
    if (($("#PEDeskClerkName").combogrid('getValue'))==($("#PEDeskClerkName").combogrid('getText')))  {
        $.messager.alert("提示","接待人选择不正确！","info");
        return false;
    }
    }
    */
       var reg = /^[0-9]+.?[0-9]*$/;
    if((!(reg.test(iPEDeskClerkDR)))&&(iPEDeskClerkDR!="")){var iPEDeskClerkDR=$("#PEDeskClerkNameID").val();}

   
    // PGADM_Status 状态 8
    iStatus=getValueById("Status")
    
        
    // PGADM_AsCharged  视同收费 3
    iAsCharged=getValueById("AsCharged")
    if (iAsCharged) { iAsCharged="Y"; }
    else { iAsCharged="N"; }
    // PGADM_AddOrdItem 允许加项 20
    iAddOrdItem=getValueById("AddOrdItem")
    if (iAddOrdItem) { iAddOrdItem='Y'; }
    else { iAddOrdItem='N';}
    
    // PGADM_AddOrdItemLimit 加项金额限制 21
    iAddOrdItemLimit=getValueById("AddOrdItemLimit")
    if (iAddOrdItemLimit) { iAddOrdItemLimit='Y'; }
    else { iAddOrdItemLimit='N';}
    // PGADM_AddOrdItemAmount 允许加项金额 22
    iAddOrdItemAmount=getValueById("AddOrdItemAmount")
    
    
    if((iAddOrdItemLimit=="Y")&&(iAddOrdItemAmount=="")){
        $.messager.alert('提示','限制加项金额时，加项金额不允许为空！',"info");
          return false;
    }
    
    if((iAddOrdItemAmount!="")&&(iAddOrdItemAmount<=0)){
        $.messager.alert('提示','加项金额应大于0',"info");
          return false;
    }
    
    

     if(!IsFloat(iAddOrdItemAmount)){
          $.messager.alert('提示','允许加项金额格式不正确',"info");
          return false;
      }
    if((iAddOrdItemAmount!="")&&(iAddOrdItemAmount.indexOf(".")!="-1")&&(iAddOrdItemAmount.toString().split(".")[1].length>2))
        {
            $.messager.alert("提示","加项金额小数点后不能超过两位","info");
            return false;
        }

    // PGADM_AddPhcItem 允许加药 23
    iAddPhcItem=getValueById("AddPhcItem")
    if (iAddPhcItem) { iAddPhcItem='Y'; }
    else { iAddPhcItem='N';}
    // PGADM_AddPhcItemLimit 加药金额限制 24
    iAddPhcItemLimit=getValueById("AddPhcItemLimit")
    if (iAddPhcItemLimit) { iAddPhcItemLimit='Y'; }
    else { iAddPhcItemLimit='N';}
    //  PGADM_AddPhcItemAmount允许加药金额 25
    iAddPhcItemAmount=getValueById("AddPhcItemAmount")

    // PGADM_GReportSend 团体报告发送 26
    iGReportSend=getValueById("GReportSend")
    
    // PGADM_IReportSend 个人报告发送 27
    iIReportSend=getValueById("IReportSend")
    
    // PGADM_DisChargedMode 结算方式 28
    iDisChargedMode=getValueById("DisChargedMode")
    
    // PGADM_DelayDate
    iDelayDate=getValueById("DelayDate")
    if(iDelayDate!=""){
        var BookDateBeginLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",iBookDateBegin)
        var iDelayDateLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",iDelayDate)
        
        if(iDelayDateLogical<BookDateBeginLogical){
            $.messager.alert("提示","延期日期不能早于体检起始日期","info");
            return false;
        }
    }
    

    
    // PGADM_Remark 备注 29
    iRemark=getValueById("Remark")
    
    
    // PGADM_AuditUser_DR   业务员 30
    Sales=$("#Sales").combogrid("getValue")
    if (($("#Sales").combogrid('getValue')==undefined)||($("#Sales").combogrid('getText')=="")){var Sales="";}
    if(Sales!="")
    {
    if (($("#Sales").combogrid('getValue'))==($("#Sales").combogrid('getText')))  {
        $.messager.alert("提示","业务员选择不正确！","info");
        return false;
    }
    }
    
    // 类型   业务员 31
    Type=getValueById("Type")
    
    
    // 取报告日期    业务员 32
    GetReportDate=getValueById("GetReportDate")
    
    if(GetReportDate!=""){
        var BookDateBeginLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",iBookDateBegin)
        var GetReportDateLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",GetReportDate)
        
        if(GetReportDateLogical<=BookDateBeginLogical){
            $.messager.alert("提示","取报告日期应大于体检起始日期","info");
            return false;
        }
    }

    //iBookDateBegin=getValueById("BookDateBegin")
    
    // 取报告时间    业务员 33
    GetReportTime=getValueById("GetReportTime")
    
    // 付款类型 业务员 33
    PayType=getValueById("PayType")
    
    // 百分比  业务员 33
    Percent=getValueById("Percent")
    
    // 就餐标志 业务员 33
    var iDietFlag=getValueById("DietFlag")
    if (!iDietFlag) { DietFlag="0"; }   
    //赠品标志  业务员 33
    var iGiftFlag=getValueById("GiftFlag")
    if (iGiftFlag) { GiftFlag="1";}
    //就诊类型用于取价格
    PatFeeType=getValueById("PatFeeTypeName")
    
    //所属合同
    Contract=$("#Contract").combogrid("getValue")
    if (($("#Contract").combogrid('getValue')==undefined)||($("#Contract").combogrid('getText')=="")){var Contract="";}
    if(Contract!="")
    {
    if (($("#Contract").combogrid('getValue'))==($("#Contract").combogrid('getText')))  {
        $.messager.alert("提示","合同选择不正确！","info");
        return false;
    }
    }
    
    
    var Instring= trim(iRowId)                  // 1
                +"^"+trim(iPGBIDR)              // 2    PGADM_PGBI_DR   预团体客户
                +"^"+trim(iBookDateBegin)       // 3    PGADM_BookDateBegin 预约日期
                +"^"+trim(iBookDateEnd)         // 4    PGADM_BookDateEnd
                +"^"+trim(iBookTime)            // 5    PGADM_BookTime  预约时间
                +"^"+trim(iPEDeskClerkDR)       // 6    PGADM_PEDeskClerk_DR    预约接待人员
                +"^"+trim(iStatus)              // 7    PGADM_Status    状态
                +"^"+trim(iAsCharged)           // 8    PGADM_AsCharged 视同收费
                +"^"+trim(iAddOrdItem)          // 9    PGADM_AddOrdItem 允许加项
                +"^"+trim(iAddOrdItemLimit)     // 10   PGADM_AddOrdItemLimit 加项金额限制
                +"^"+trim(iAddOrdItemAmount)    // 11   PGADM_AddOrdItemAmount 允许加项金额
                +"^"+trim(iAddPhcItem)          // 12   PGADM_AddPhcItem 允许加药
                +"^"+trim(iAddPhcItemLimit)     // 13   PGADM_AddPhcItemLimit 加药金额限制
                +"^"+trim(iAddPhcItemAmount)    // 14   PGADM_AddPhcItemAmount允许加药金额
                +"^"+trim(iGReportSend)         // 15   PGADM_GReportSend 团体报告发送
                +"^"+trim(iIReportSend)         // 16   PGADM_IReportSend 个人报告发送
                +"^"+trim(iDisChargedMode)      // 17   PGADM_DisChargedMode 结算方式
                +"^"+trim(iDelayDate)           // 18   PGADM_DelayDate 延期日期
                +"^"+trim(iRemark)              // 19   PGADM_Remark    备注  
                +"^"+trim(Sales)
                +"^"+trim(Type)
                +"^"+trim(GetReportDate)
                +"^"+trim(GetReportTime)
                +"^"+trim(PayType)
                +"^"+trim(Percent)
                +"^"+trim(DietFlag)
                +"^"+trim(GiftFlag)
                +"^"+trim(PatFeeType)
                +"^"+trim(Contract)
                ;
    
   //alert(Instring)
    var flag=tkMakeServerCall("web.DHCPE.PreGADM","Save2","","",Instring);
    
    if (flag=="Err Date")
    {
        $.messager.alert("提示","结束日期不能早于开始日期","info");
        return false;
    }
    
    if (flag=="Err HomeDate")
    {
        $.messager.alert("提示","结束日期不能小于主场结束日期","info");
        return false;
    }
    if (flag=="Err GetReportDate")
    {
        $.messager.alert("提示","取报告日期不能小于今天","info");
        return false;
    }

 
    if (""==iRowId) { //插入操作 返回 RowId
        var Rets=flag.split("^");
        flag=Rets[0];
        // PGADM_RowId  团体ADM 1
        setValueById("PGADM_RowId",Rets[1])
        setValueById("ID",Rets[1])
        GroupID=Rets[1]
    }

    if ('0'==flag) {
        
        if (""==iRowId) { 
            $.messager.alert("提示","预约成功","success");
            OldPGBIID=trim(iPGBIDR);
        }
        else { 
            $.messager.alert("提示","更新成功","success");
            OldPGBIID=trim(iPGBIDR);
         }
    
        if (""==iRowId) { //刷新页面
            setValueById("PGADM_RowId",Rets[1])
            setValueById("ID",Rets[1])
            GroupID=Rets[1]
            var GStatus=tkMakeServerCall("web.DHCPE.PreGADM","GetStatus",GroupID);
            if (GStatus!="PREREG"){
                $("#RapidNew").linkbutton('disable');
                return false;
                }
            else{
                $("#RapidNew").linkbutton('enable');
            }

            return false;
        }

        return false;
    }
    else if ('Err 02'==flag) {
        $.messager.alert("提示","团体已登记","info");
        return false;       
    }
    else if ('Err 05'==flag) {
        $.messager.alert("提示","录已不是预登记状态,不能修改","info");
        return false;       
    }       
    else {
        $.messager.alert("提示","更新错误 错误号:"+flag,"info");
        return false;
    } 
    return true;
}

function trim(s) {
    if (""==s) { return ""; }
    var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
    return (m == null) ? "" : m[1];
}

function Clear_click()
{
    OldPGBIID="";
    $("#groupform").form("clear");
    var CurDate="";
    var GReportSend="AC"; //团体报告发送  默认值"挂账可取"
    var IReportSend="IS"; //个人报告领取  默认值"自取"
    CurDate=tkMakeServerCall("web.DHCPE.PreGADM","GetDefaultDate");
    
    setValueById("BookDateBegin",CurDate)
    setValueById("BookDateEnd",CurDate)
    
    $("#GReportSend").combobox("setValue",GReportSend); //团体报告发送
    $("#IReportSend").combobox("setValue",IReportSend);  //个人报告领取
    
    
    //视同收费 PIADM_AsCharged
    
    if (Default)
    {
        if ((Default=="2")||(Default=="3")){setValueById("AsCharged",true)}
        else{
            setValueById("AsCharged",false)
            }
            
        
    }
    LoadCard();
}

//  允许加项(PGADM_AddOrdItem)
function AddOrdItem_click(value) {
    if (value) {
        
            $("#AddOrdItemLimit").checkbox("enable");
            setValueById("AddOrdItemLimit",true);
            $("#AddOrdItemAmount").attr("disabled",false)
        
        
    }
    else{
        
            $("#AddOrdItemLimit").checkbox("disable");
            setValueById("AddOrdItemLimit",false)
        
            $("#AddOrdItemAmount").attr("disabled",true);
            setValueById("AddOrdItemAmount","")
            
    }

}
// PGADM_AddOrdItemLimit 加项金额限制 
function AddOrdItemLimit_click(value) {
    if (value) {
        $("#AddOrdItemAmount").attr("disabled",false)
    }
    else{
        $("#AddOrdItemAmount").attr("disabled",true);
        setValueById("AddOrdItemAmount","") 
            
    }
    
}

function trim(s) {
    if (""==s) { return ""; }
    var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
    return (m == null) ? "" : m[1];

}

//验证是否为浮点数
function IsFloat(Value) {
    
    var reg;
    
    if(""==trim(Value)) { 
        //容许为空
        return true; 
    }else { Value=Value.toString(); }
    
    reg=/^((-?|\+?)\d+)(\.\d+)?$/;
    if ("."==Value.charAt(0)) {
        Value="0"+Value;
    }
    
    var r=Value.match(reg);
    if (null==r) { return false; }
    else { return true; }
}

function TeamUpdate() {
    var obj,OneData="",DataStr="";
    var iParRef="",iRowId="",iChildSub,iDesc;
    
    //团体ADM PGT_ParRef
    OneData=getValueById("ID")
    
    if ((""==OneData)||("0"==OneData)) {
        $.messager.alert("提示","无效团体","info");
        return false; 
    }

    iParRef=OneData
    DataStr=OneData
    OneData=""
    
    //  PGT_RowId
    OneData=getValueById("PGTRowId")
    iRowId=OneData
    DataStr=DataStr+"^"+OneData
    OneData=""
    
    //  PGT_ChildSub
    OneData=getValueById("PGTChildSub")
    iChildSub=OneData
    DataStr=DataStr+"^"+OneData
    OneData=""

    //分组名称  PGT_Desc
    OneData=getValueById("TeamDesc") 
    if (""==OneData) {
        
    $.messager.alert("提示","分组名称不能为空","info"); 
        websys_setfocus("TeamDesc");
        return false;       
    }
    iDesc=OneData
    DataStr=DataStr+"^"+OneData
    OneData=""
    
    // PGT_BookDateBegin
    OneData=getValueById("TeamBookDateBegin") 
    DataStr=DataStr+"^"+OneData
    OneData=""

    // PGT_BookDateEnd
    OneData=getValueById("TeamBookDateEnd") 
    DataStr=DataStr+"^"+OneData
    OneData=""
    
    //预约时间 PGT_BookTime
    DataStr=DataStr+"^"+OneData
    OneData=""
    
    //预约接待员 PGT_PEDeskClerk_DR
    OneData=$("#TeamPEDeskClerkName").combogrid("getValue")
    if (($("#TeamPEDeskClerkName").combogrid('getValue')==undefined)||($("#TeamPEDeskClerkName").combogrid('getText')=="")){var OneData="";}
    var reg = /^[0-9]+.?[0-9]*$/;
    if((!(reg.test(OneData)))&&(OneData!="")){var OneData=$("#TeamPEDeskClerkNameID").val();}

    DataStr=DataStr+"^"+OneData
    OneData=""  
    
    // PGT_AddOrdItem 公费加项
    iAddOrdItem=getValueById("TeamAddOrdItem")
    if (iAddOrdItem) { OneData='Y'; }
    else { OneData='N';}
    
    
    DataStr=DataStr+"^"+OneData
    OneData=""
    
    // PGT_AddOrdItemLimit 加项金额限制
    iAddOrdItemLimit=getValueById("TeamAddOrdItemLimit")
    if (iAddOrdItemLimit) { OneData='Y'; }
    else { OneData='N';}
    DataStr=DataStr+"^"+OneData
    OneData=""
    
    // PGT_AddOrdItemAmount 公费加项金额
    OneData=getValueById("TeamAddOrdItemAmount") 
    if ((iAddOrdItemLimit)&&(OneData=="")){
        $.messager.alert('提示','限制加项金额时，加项金额不允许为空',"info");
         return false;  
    }

    if((OneData!="")&&(OneData<=0)){
        $.messager.alert('提示','加项金额应大于0',"info");
        return false;
    }

     if(!IsFloat(OneData)){
          $.messager.alert('提示','加项金额格式不正确',"info");
          return false;
      }
     if((OneData!="")&&(OneData.indexOf(".")!="-1")&&(OneData.toString().split(".")[1].length>2))
     {
         $.messager.alert("提示","加项金额小数点后不能超过两位","info");
         return false;
     }

    DataStr=DataStr+"^"+OneData
    OneData=""
    
    // PGT_AddPhcItem 允许加药
    iAddPhcItem=getValueById("TeamAddPhcItem")
    if (iAddPhcItem) { OneData='Y'; }
    else { OneData='N';}
    DataStr=DataStr+"^"+OneData
    OneData=""
    
    // PGT_AddPhcItemLimit 加药金额限制 
    OneData='N'
    DataStr=DataStr+"^"+OneData
    OneData=""
    
    //  PGT_AddPhcItemAmount允许加药金额
    DataStr=DataStr+"^"+OneData
    OneData=""
    
    //性别    PGT_Sex
    var checkedRadioObj = $("input[name='TeamSex']:checked");
    OneData=checkedRadioObj.val();
    DataStr=DataStr+"^"+OneData
    OneData=""
    
    //年龄上限  PGT_UpperLimit
    OneData=getValueById("UpperLimit")
    if (OneData!=""){
        if(+OneData<0){
          $.messager.alert("提示","年龄上限不能小于0","info"); 
            websys_setfocus("UpperLimit"); 
            return false;
      }

        if(!isInteger(OneData)) {
            $.messager.alert("提示","年龄上限格式非法","info"); 
            websys_setfocus("UpperLimit"); 
            return false;
    }
    }
    
    DataStr=DataStr+"^"+trim(OneData)
    OneData=""

    //年龄下限  PGT_LowerLimit
    OneData=getValueById("LowerLimit")
    if (OneData!=""){
        if(+OneData<0){
          $.messager.alert("提示","年龄下限不能小于0","info"); 
            websys_setfocus("UpperLimit"); 
            return false;
      }
        if(!isInteger(OneData)) {
            $.messager.alert("提示","年龄下限格式非法","info"); 
            websys_setfocus("LowerLimit"); 
            return false;
    }
    }

    var iUpperLimit=parseFloat($("#UpperLimit").val())
    var iLowerLimit=parseFloat($("#LowerLimit").val())
    if(iUpperLimit<iLowerLimit){
        $.messager.alert("提示","年龄下限不能大于上限","info");     
        return false;
    }

    DataStr=DataStr+"^"+trim(OneData)
    OneData=""

    //婚姻状况  PGT_Married
    
    var checkedRadioObj = $("input[name='TeamMarried']:checked");
    OneData=checkedRadioObj.val();
    
    DataStr=DataStr+"^"+OneData
    OneData=""
    
    //VIP等级
    OneData=$("#VIPLevel").combogrid("getValue")
    
    DataStr=DataStr+"^"+OneData
    OneData=""
     
    // 分组等级
     
    DataStr=DataStr+"^"+OneData
    OneData=""
    //就诊费用类别 用于计费价格
    OneData=$("#TeamPatFeeTypeName").combogrid("getValue")
   
    DataStr=DataStr+"^"+OneData
    //是否包含在团体
    OneData=""
    iNoIncludeGroup=getValueById("NoIncludeGroup")
    if (iNoIncludeGroup) { OneData=1; }
    else { OneData="";}
    
    DataStr=DataStr+"^"+OneData;
    //结算方式
    OneData=""
    OneData=$("#TeamDisChargedMode").combogrid("getValue")

    DataStr=DataStr+"^"+OneData;
    //危害因素
    OneData=""
    var OccuId=$("#HarmInfo").combotree("getValues")
    var OneData=OccuId.join(",");

    DataStr=DataStr+"^"+OneData;
    
    //检查种类
    OneData=""
    OneData=$("#OMEType").combobox("getValue")

    DataStr=DataStr+"^"+OneData;

   //检查位置
    OneData=""
    OneData=$("#RoomPlace").combogrid("getValue")

    DataStr=DataStr+"^"+OneData;
    
    
    
    
    
    //获取分组信息
    var PreGTeamDataStr=tkMakeServerCall("web.DHCPE.PreGTeam","DocListBroker","","",iRowId.split("||")[0]+"^^"+iRowId.split("||")[1]);
    var PreGTeamData=PreGTeamDataStr.split("^");
    var OldPreRebate=PreGTeamData[33];
    var OldAddGTRebate=PreGTeamData[34];
    var OldAddITRebate=PreGTeamData[35];
    


    //预约折扣率
    var OneData=getValueById("PreGRebate") 
    
    if(OneData!=""){
        if((OneData<=0)||(OneData>=100)){
            $.messager.alert("提示","预约折扣率应大于0小于100","info");
            return false;
        }else{
            if (IsFloat(OneData)){}
            else 
            {   
                $("#PreGRebate").focus();
                $.messager.alert("提示","预约折扣率不能为0","info");
                return false;
            }
        }
    
        var userId=session['LOGON.USERID'];
        var LocID=session['LOGON.CTLOCID'];
        var ReturnStr=tkMakeServerCall("web.DHCPE.CT.ChargeLimit","GetOPChargeLimitInfo",userId,LocID);
        var OPflagOne=ReturnStr.split("^");
        var DFLimit=OPflagOne[3];
       
        if (DFLimit==0){
            $.messager.alert("提示","没有打折权限","info");
             return;
            }
        if(+DFLimit>+OneData){
            $.messager.alert("提示","权限不足,您的折扣权限为:"+DFLimit+"%","info");
            return;
        }
    }   
    if ((OldPreRebate!="")&&(OldPreRebate!=undefined)&&(OneData!="")&&(OldPreRebate!=OneData)){
        $.messager.alert("提示","预约折扣率有变化，需要在费用界面修改审核记录的折扣率！","info");
        return;
        
    }

    DataStr=DataStr+"^"+OneData;
    
    //公加折扣率
    var OneData=getValueById("AddGRebate") 
    
    if(OneData!=""){
        if((OneData<=0)||(OneData>=100)){
            $.messager.alert("提示","公加折扣率应大于0小于100","info");
            return false;
        }else{
            if (IsFloat(OneData)){}
            else 
            {   
                $("#AddGRebate").focus();
                $.messager.alert("提示","公加折扣率不能为0","info");
                return false;
            }
        }
    
        var userId=session['LOGON.USERID'];
        var LocID=session['LOGON.CTLOCID'];
        var ReturnStr=tkMakeServerCall("web.DHCPE.CT.ChargeLimit","GetOPChargeLimitInfo",userId,LocID);
        var OPflagOne=ReturnStr.split("^");
        var DFLimit=OPflagOne[3];
        
        if (DFLimit==0){
            $.messager.alert("提示","没有打折权限","info");
            return;
            }
        if(+DFLimit>+OneData){
            $.messager.alert("提示","权限不足,您的折扣权限为:"+DFLimit+"%","info");
            return;
        }
    }   
    if ((OldAddGTRebate!="")&&(OldAddGTRebate!=undefined)&&(OneData!="")&&(OldAddGTRebate!=OneData)){
        $.messager.alert("提示","公加扣率有变化，需要在费用界面修改审核记录的折扣率！","info");
        return;
        
    }

    DataStr=DataStr+"^"+OneData;
    
    //自加折扣率
    var OneData=getValueById("AddIRebate") 
    
    if(OneData!=""){
        if((OneData<=0)||(OneData>=100)){
            $.messager.alert("提示","自加折扣率应大于0小于100","info");
            return false;
        }else{
            if (IsFloat(OneData)){}
            else 
            {   
                $("#AddIRebate").focus();
                $.messager.alert("提示","自加折扣率不能为0","info");
                return false;
            }
        }
    
        var userId=session['LOGON.USERID'];
        var LocID=session['LOGON.CTLOCID'];
        var ReturnStr=tkMakeServerCall("web.DHCPE.CT.ChargeLimit","GetOPChargeLimitInfo",userId,LocID);
        var OPflagOne=ReturnStr.split("^");
        var DFLimit=OPflagOne[3];

        if (DFLimit==0){
            $.messager.alert("提示","没有打折权限","info");
            return;
            }
        if(+DFLimit>+OneData){
            $.messager.alert("提示","权限不足,您的折扣权限为:"+DFLimit+"%","info");
            return;
        }   
    }
    if ((OldAddITRebate!="")&&(OldAddITRebate!=undefined)&&(OneData!="")&&(OldAddITRebate!=OneData)){
        $.messager.alert("提示","自加扣率有变化，需要在费用界面修改审核记录的折扣率！","info");
        return;
        
    }

    DataStr=DataStr+"^"+OneData;
    //alert(DataStr)
    
    //父层分组
    OneData=""
    OneData=$("#ParentTeam").combobox("getValue")
    
    DataStr=DataStr+"^"+OneData;
    
    
    
    //性别    PGT_Sex
    var checkedRadioObj = $("input[name='TeamSex']:checked");
    OneData=checkedRadioObj.val();
    
    if(iRowId!=""){
        var ret=tkMakeServerCall("web.DHCPE.PreGTeam","IsExistPersonInTeam",iRowId); 
        var OldSex=ret.split("^")[1];
        var flag=ret.split("^")[0];
        if(flag=="1"){
            if(((OneData=="M")&&(OldSex=="F"))||((OneData=="F")&&(OldSex=="M"))){
                $.messager.confirm("确认", "分组性别与分组人员性别不一致，是否继续更新？", function(data){  
                    if (data) {
                            SaveTeamInfo(DataStr,iParRef);  
    
                    }else{
                        return false;
                    }
                }); 
            
            }else{
                SaveTeamInfo(DataStr,iParRef);  
                }
        
        }else{
            SaveTeamInfo(DataStr,iParRef);      
        }
    }else{
        SaveTeamInfo(DataStr,iParRef);  
    }

}

//保存分组信息
function SaveTeamInfo(DataStr,ParRef)
{
    var flag=tkMakeServerCall("web.DHCPE.PreGTeam","Save2","","",DataStr);
    
    if (flag=="Err Date")
    {
        $.messager.alert("提示","结束日期小于开始日期","info");
        return false;
    }else if ('0'==flag) {
        $.messager.popover({msg: '更新成功！',type:'success',timeout: 1000});
        $('#NewWin').window('close');
        $("#TeamGrid").treegrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:ParRef}); 
        
    }else {
        $.messager.alert("提示","更新错误 错误号:"+flag);
        return false;
    }

    return true;
}

function TeamClear()
{
    
    $("#OMEType").combobox("setValue","")
    $("#NoIncludeGroup,#TeamAddOrdItem,#TeamAddPhcItem,#TeamAddOrdItemLimit").checkbox('setValue',false);
    $("#HarmInfo").combotree("setValue","")
    $("#TeamDesc,#UpperLimit,#LowerLimit,#TeamAddOrdItemLimit").val("");
    $("#TeamBookDateBegin").datebox('setValue',"");
    $("#TeamBookDateEnd").datebox('setValue',"");
    $HUI.radio("#TeamSexN").setValue(true);
    $HUI.radio("#TeamMarriedN").setValue(true);
    var GADMID=getValueById("ID")
    var ret=tkMakeServerCall("web.DHCPE.PreGADM","GetPreGADM",GADMID);
    SetParRefData(ret)
    
    var UserID= session['LOGON.USERID'];
    var LocID=session['LOGON.CTLOCID'];

    var VIPNV=tkMakeServerCall("web.DHCPE.HISUICommon","GetVIP",UserID,LocID);
    $('#VIPLevel').combobox('setValue',VIPNV);

   
    /*********************诊室重新加载*******************/
    $HUI.combobox("#RoomPlace",{
        onBeforeLoad:function(param){
            var VIP=$("#VIPLevel").combobox("getValue");
            param.VIPLevel = VIP;
            param.GIType = "G";
            param.LocID = session['LOGON.CTLOCID']
        }
    });
              
    $('#RoomPlace').combobox('reload'); 
    /*********************诊室重新加载*******************/

    /*********************诊室默认值*******************/
    var DefaultRoomPlace=tkMakeServerCall("web.DHCPE.CT.RoomManagerEx","GetDefaultRoomPlace",VIPNV,"G",LocID); 
    $('#RoomPlace').combobox('setValue',DefaultRoomPlace);
    /*********************诊室默认值*******************/

   /*
    var DefaultRoomPlace=tkMakeServerCall("web.DHCPE.RoomManagerEx","GetDefaultRoomPlace",VIPNV,"G");
    $('#RoomPlace').combobox('setValue',DefaultRoomPlace);
    $('#RoomPlace').combobox('reload');
 */

    $("#PreGRebate,#AddGRebate,#AddIRebate").numberbox("setValue","");

    
}

function SaveTemplate()
{
    var iPGBIDR=getValueById("PGBI_RowId")
    var iDesc=getValueById("TeamDesc");
    if (iDesc=="") {
        //$.messager.alert("提示","分组名称不能为空","info"); 
        //return false;
    }

    var iAgeDown=$("#LowerLimit").val();
    
    if(iAgeDown!="")
    { 
      if(+iAgeDown<0){
          $.messager.alert("提示","年龄下限不能小于0","info"); 
        websys_setfocus("LowerLimit"); 
        return false;
      }
      if(!(isInteger(iAgeDown))){
           $.messager.alert("提示","年龄下限格式非法","info"); 
        websys_setfocus("LowerLimit"); 
        return false;
      }
    }
    


    var iAgeUp=$("#UpperLimit").val();
    if(iAgeUp!="")
    { 
      if(+iAgeUp<0){
          $.messager.alert("提示","年龄上限不能小于0","info"); 
        websys_setfocus("UpperLimit"); 
        return false;
      }
      if(!(isInteger(iAgeUp))){
           $.messager.alert("提示","年龄上限格式非法","info"); 
        websys_setfocus("UpperLimit"); 
        return false;
      }
    }

    if(iAgeUp<iAgeDown){
        $.messager.alert("提示","年龄下限不能大于上限","info"); 
        return false;
    }
    
    if(iAgeDown!="")  var iAgeDown=tkMakeServerCall("web.DHCPE.Cashier","Round",iAgeDown,0,5)
    if(iAgeUp!="")  var iAgeUp=tkMakeServerCall("web.DHCPE.Cashier","Round",iAgeUp,0,5)
    
    //性别 
    var checkedRadioObj = $("input[name='TeamSex']:checked");
    var iSex=checkedRadioObj.val();
    
    //婚姻状况 
    var checkedRadioObj = $("input[name='TeamMarried']:checked");
    var iMarried=checkedRadioObj.val();
    
    var ret=1;
    var InStr=iDesc+'^'+iAgeUp+'^'+iAgeDown+'^'+iSex+'^'+iMarried;
    
    var ret=tkMakeServerCall("web.DHCPE.PreGTeam","GTeamTempSet",InStr,"","Set"); 
    if (ret==0){
        $.messager.alert("提示","保存成功","success"); 
        $("#TempSet").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"GetGTeamTempSet",VIP:"",ToGID:"",GBID:"",TemplateFlag:"1"}); 
            
    }
    else{
        $.messager.alert("提示","保存失败","error");
        }
//  $("#TempSet").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"GetGTeamTempSet",ToGID:"",TemplateFlag:"1"}); 
}


function RapidUpdate()
{
    var obj;
    var iDesc="",iSex="",iMarried="",iAge="",iAgeLow="",iAgeHigh="";
    var iTeamNum=0;
    
    var checkedRadioObj = $("input[name='TeamNum']:checked");
    OneData=checkedRadioObj.val();
    
    if(OneData==undefined){
        $.messager.alert("提示","请勾选分组","info");
        return false;   
    }
    var RapidEndDate=$("#RapidBookDateEnd").datebox('getValue');
    var RapidStartDate=$("#RapidBookDateBegin").datebox('getValue');
    var iRapidStartDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",RapidStartDate);
    var iRapidEndDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",RapidEndDate);
    
    if((iRapidStartDate!="")&&(iRapidEndDate!="")&&(iRapidEndDate<iRapidStartDate))
    {
        $.messager.alert("提示","结束日期小于开始日期","info"); 
        return false;
    }
    if (OneData=="Team_One"){
        iTeamNum=1;
        for (var i=0;i<iTeamNum;i++)
        {
            if(i==0)
            {
                iDesc="全体人员";
                iSex="N";
                iMarried="N";
                save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
                continue;
            }
        }       
    }
    
    if (OneData=="Team_Two"){
        iTeamNum=2;
        for (var i=0;i<iTeamNum;i++)
        {
            if(i==0)
            {
                iDesc="男";
                iSex="M";
                iMarried="N";
                save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
                continue;
            }
            else
            {
                iDesc="女";
                iSex="F";
                iMarried="N";
                save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
                continue;
            }
        }
    }
    
    if (OneData=="Team_Three"){
        
        
        iTeamNum=3;
        for (var i=0;i<iTeamNum;i++)
        {
            if(i==0)
            {
                iDesc="男";
                iSex="M";
                iMarried="N";
                save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
                continue; 
            }
            else if(i==1)
            {
                iDesc="女未婚";
                iSex="F";
                iMarried="UM";
                save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
                continue;
            }
            else 
            {
                iDesc="女已婚";
                iSex="F";
                iMarried="M";
                save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
                continue;
            }
        }
    }
    
    if (OneData=="Team_Four"){
        
        iTeamNum=4;
        obj=document.getElementById("AgeBoundary");
        if (obj&& obj.value){ iAge=obj.value;}
         if (iAge=="") {
                $.messager.alert("提示","年龄界限不能为空","info"); 
                return false;
                }
        if (!(isInteger(iAge))||(iAge<0)) {
                    $.messager.alert("提示","年龄格式非法","info"); 
                    return false;
                }   
         if (iAge>100) {
                    $.messager.alert("提示","年龄上限不能超过100","info"); 
                    return false;
                }
        for (var i=0;i<iTeamNum;i++)
        {
            if(i==0)
            {
                iDesc="男大于等于"+iAge+"岁";
                iSex="M";
                iMarried="N";
                iAgeLow=iAge
                iAgeHigh=100
                save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
                continue;
            }
            else if(i==1)
            {
                iDesc="男小于等于"+iAge+"岁";
                iSex="M";
                iMarried="N";
                iAgeLow=0
                iAgeHigh=iAge
                save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
                continue;
            }
            else if(i==2) 
            {
                iDesc="女大于等于"+iAge+"岁";
                iSex="F";
                iMarried="N";
                iAgeLow=iAge
                iAgeHigh=100
                
                save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
                continue;
            }
            else
            {
                iDesc="女小于等于"+iAge+"岁";
                iSex="F";
                iMarried="N";
                iAgeLow=0
                iAgeHigh=iAge
                
                save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
                continue;
            }
        }
    }
    
    if (OneData=="Team_Five"){
    
        iTeamNum=5;
        
        obj=document.getElementById("AgeBoundary");
        if (obj&& obj.value){ iAge=obj.value;}
        if (iAge=="") {
                $.messager.alert("提示","年龄界限不能为空","info"); 
                return false;
                }
        if (!(isInteger(iAge))||(iAge<0)) {
                    $.messager.alert("提示","年龄格式非法","info"); 
                    return false;
                }   
         if (iAge>100) {
                    $.messager.alert("提示","年龄上限不能超过100","info"); 
                    return false;
                }
        for (var i=0;i<iTeamNum;i++)
        {
            if(i==0)
            {
                iDesc="女未婚";
                iSex="F";
                iMarried="UM";
                iAgeLow=""
                iAgeHigh=""
                
                save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
                continue;
            }
            else if(i==1)
            {
                iDesc="男大于等于"+iAge+"岁";
                iSex="M";
                iMarried="N";
                iAgeLow=iAge
                iAgeHigh=100
                
                save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
                continue;
            }
            else if(i==2) 
            {
                iDesc="男小于等于"+iAge+"岁";
                iSex="M";
                iMarried="N";
                iAgeLow=0
                iAgeHigh=iAge
                
                save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
                continue;
            }
            else if(i==3)
            {
                iDesc="女已婚大于等于"+iAge+"岁";
                iSex="F";
                iMarried="M";
                iAgeLow=iAge
                iAgeHigh=100
                
                save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum)
                continue;
            }
            else
            {
                iDesc="女已婚小于等于"+iAge+"岁";
                iSex="F";
                iMarried="M";
                iAgeLow=0
                iAgeHigh=iAge
                
                save(iDesc,iSex,iMarried,iAgeLow,iAgeHigh,i,iTeamNum);
                continue;
            }
        }
    }
    
}

function save(Desc,Sex,Married,AgeLow,AgeHigh,Num,TeamNum){
    
    //alert(AgeLow,AgeHigh)
    
    var obj,OneData="",DataStr="";
    var iParRef="",iRowId="",iChildSub,iDesc;
    
    obj=document.getElementById("ID");
    if (obj) { OneData=obj.value; } 
    else {
         obj.value=Desc; 
         OneData=obj.value; }
       
    if((""==OneData)||("0"==OneData)){
      $.messager.alert("提示","无效团体","info");
        return false;
    }

    iParRef=OneData
    DataStr=OneData
    OneData=""
    var PreGInfoStr=tkMakeServerCall("web.DHCPE.PreGTeamNew","GetPreGInfo",iParRef);
    var PreGInfo=PreGInfoStr.split("^");
    //  PGT_RowId
    
    iRowId=OneData
    DataStr=DataStr+"^"+OneData
    OneData=""

    //  PGT_ChildSub
    
    iChildSub=OneData 
    DataStr=DataStr+"^"+OneData
    OneData=""

    //分组名称  PGT_Desc
    OneData=Desc
    iDesc=OneData
    DataStr=DataStr+"^"+OneData
    OneData=""
        
    // PGT_BookDateBegin
    OneData=getValueById("RapidBookDateBegin") 
    DataStr=DataStr+"^"+OneData
    OneData=""

    // PGT_BookDateEnd
    OneData=getValueById("RapidBookDateEnd") 
     
    DataStr=DataStr+"^"+OneData
    OneData=""
    
    //预约时间 PGT_BookTime
    OneData=getValueById("RapidBookTime")
    DataStr=DataStr+"^"+OneData
    OneData=""
    
    //预约接待员 PGT_PEDeskClerk_DR
     
    DataStr=DataStr+"^"+OneData
    OneData=""  
    
    // PGT_AddOrdItem 公费加项
    /*
    obj=document.getElementById("AddOrdItem");
    if (obj && obj.checked) { OneData='Y'; }
    else { OneData='N';}
    */
    OneData=PreGInfo[7];
    DataStr=DataStr+"^"+OneData
    OneData=""
    
    // PGT_AddOrdItemLimit 加项金额限制
    /*
    obj=document.getElementById("AddOrdItemLimit");
    if (obj && obj.checked) { OneData='Y'; }
    else { OneData='N';}
    */
    OneData=PreGInfo[8];
    DataStr=DataStr+"^"+OneData
    OneData=""
    
    // PGT_AddOrdItemAmount 公费加项金额
    /*
    obj=document.getElementById("AddOrdItemAmount");
    if (obj) { OneData=obj.value; }
    */
    OneData=PreGInfo[9];


    DataStr=DataStr+"^"+OneData
    OneData=""
    
    // PGT_AddPhcItem 允许加药
    /*
    obj=document.getElementById("AddPhcItem");
    if (obj && obj.checked) { OneData='Y'; }
    else { OneData='N';}
    */
    OneData=PreGInfo[10];
    DataStr=DataStr+"^"+OneData
    OneData=""
    
    // PGT_AddPhcItemLimit 加药金额限制
    /*
    obj=document.getElementById("AddPhcItemLimit");
    if (obj && obj.checked) { OneData='Y'; }
    else { OneData='N';}
    */
    OneData=PreGInfo[11];
    DataStr=DataStr+"^"+OneData
    OneData=""
    
    //  PGT_AddPhcItemAmount允许加药金额
    /*
    obj=document.getElementById("AddPhcItemAmount");
    if (obj) { OneData=obj.value; }
    */
    OneData=PreGInfo[12];
    DataStr=DataStr+"^"+OneData
    OneData=""
    
    //性别    PGT_Sex
    OneData=Sex
    DataStr=DataStr+"^"+OneData
    OneData=""
    
    //年龄上限  PGT_UpperLimit
    OneData=AgeHigh
    DataStr=DataStr+"^"+OneData
    OneData=""

    //年龄下限  PGT_LowerLimit
    OneData=AgeLow
    DataStr=DataStr+"^"+OneData
    OneData=""

    //婚姻状况  PGT_Married
    OneData=Married
    DataStr=DataStr+"^"+OneData
    OneData=""
    
    //VIP等级
    OneData=$("#RapidVIPLevel").combogrid("getValue") 
    DataStr=DataStr+"^"+OneData
    OneData=""
    
    obj=document.getElementById("TeamLevel");
    if (obj) { OneData=obj.value; } 
    DataStr=DataStr+"^"+OneData
    OneData=""
     
    //就诊费用类别 用于计费价格
    OneData=$("#RapidPatFeeTypeName").combogrid("getValue") 
    DataStr=DataStr+"^"+OneData
    OneData=""
    
    //是否包含在团体
    OneData=""
    obj=document.getElementById("RapidNoIncludeGroup");
    if (obj&&obj.checked) { OneData=1; } 
    DataStr=DataStr+"^"+OneData;

    //结算方式
    OneData=$("#RapidDisChargedMode").combogrid("getValue") 
    
    DataStr=DataStr+"^"+OneData;
    
    
    var flag=tkMakeServerCall("web.DHCPE.PreGTeamNew","Save2","","",DataStr);
    
    
    if (flag=="Err Date")
    {
        $.messager.alert("提示","结束日期小于开始日期","info"); 
        return false;
    }
    if ('0'==flag) {
        
        $('#RapidNewWin').window('close');
        $("#TeamGrid").treegrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:iParRef}); 
        
    }   
    else {
        
        $.messager.alert("提示","更新错误 错误号："+flag,"error"); 
        return false;
    }

    return true;

}   


//自费加项（分组）
function BAddItems()
{
    
    var iRowId=$("#PGTRowId").val();
    var PreOrAdd="ADD"
    var lnk="dhcpepreitemlist.main.hisui.csp"+"?AdmType=TEAM"
            +"&AdmId="+iRowId+"&PreOrAdd="+PreOrAdd
            ;
    $HUI.window("#ItemEditWin", {
        		title: "预约项目修改",
        		iconCls: "icon-w-edit",
        		collapsible: false,
       			 minimizable: false,
        		maximizable: false,
        		resizable: false,
        		closable: true,
        		modal: true,
        		width: 1430,
        		height: 760,
				onClose:function(){
	        		$('#TeamPersonGrid').datagrid('reload');   //关闭窗口刷新父页面	
        		},  
        		content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
    }); 
    return true; 
    /*  
    var wwidth=1450;
    var wheight=1450; 
    var xposition = (screen.width - wwidth) / 2;
    var yposition = (screen.height - wheight) / 2;
    var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes'
            +',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
            ;
    window.open(lnk,"_blank",nwin) 
    */
    //websys_lu(lnk,false,'iconCls=icon-w-edit,width=1430,height=750,hisui=true,title='+$g('预约项目修改'))  
    
}


function BAddItem()
{
    var PreOrAdd="ADD"  //是否公费加项
    var iRowId=getValueById("PIADM_RowId")
    var iRowId=GetSelectADM();
    if(iRowId=="")
    {
        $.messager.alert("提示", "请选择待加项的客户", "info");
        return;
        
    }
    
    var lnk="dhcpepreitemlist.main.hisui.csp"+"?AdmType=PERSON"
            +"&AdmId="+iRowId+"&PreOrAdd="+PreOrAdd
            ;
    /*
    var wwidth=1450;
    var wheight=1450; 
    var xposition=0;
    var yposition=0;

    var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes, '
            +'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
            ;
    window.open(lnk,"_blank",nwin)  
    */
    //websys_lu(lnk,false,'iconCls=icon-w-edit,width=1430,height=750,hisui=true,title='+$g('预约项目修改'))   
		$HUI.window("#ItemEditWin", {
        		title: "预约项目修改",
        		iconCls: "icon-w-edit",
        		collapsible: false,
       			 minimizable: false,
        		maximizable: false,
        		resizable: false,
        		closable: true,
        		modal: true,
        		width: 1430,
        		height: 760,
        		content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
    }); 
    return true;
    
    
}

function PNewItem()
{
    
    var PreOrAdd="PRE"  //是否公费加项
    var iRowId=getValueById("PIADM_RowId")
    var iRowId=GetSelectADM();
    if(iRowId=="")
    {
        $.messager.alert("提示", "请选择待加项的客户", "info");
        return;
        
    }
    var lnk="dhcpepreitemlist.main.hisui.csp"+"?AdmType=PERSON"
            +"&AdmId="+iRowId+"&PreOrAdd="+PreOrAdd
            ;
    /*
    var wwidth=1450;
    var wheight=1450; 
    var xposition=0;
    var yposition=0;

    var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes, '
            +'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
            ;
    window.open(lnk,"_blank",nwin)  
  */
   //websys_lu(lnk,false,'iconCls=icon-w-edit,width=1430,height=750,hisui=true,title='+$g('预约项目修改')) 
   	$HUI.window("#ItemEditWin", {
        		title: "预约项目修改",
        		iconCls: "icon-w-edit",
        		collapsible: false,
       			 minimizable: false,
        		maximizable: false,
        		resizable: false,
        		closable: true,
        		modal: true,
        		width: 1430,
        		height: 760,
        		content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
    }); 
    return true;
    
}

//撤销已预约人员
function BCancelSelect()
{
    
    var SelectIds=""
    var selectrow = $("#TeamPersonGrid").datagrid("getChecked");//获取的是数组，多行数据
    
    for(var i=0;i<selectrow.length;i++){
        
        if (SelectIds==""){
                SelectIds=selectrow[i].PIADM_RowId;
            }else{
                SelectIds=SelectIds+"^"+selectrow[i].PIADM_RowId;
            } 
    }
    if(selectrow.length>=2){
        $.messager.alert("提示","只能选择一人撤销","info");
        return false;
        }
    
    if(SelectIds=="")
    { 
        $.messager.alert("提示","请选择待撤销人员","info");
        return false;
    }
    
    
    $.messager.confirm("确认", "确定要撤销吗？", function(r){
        if (r){
             var PreIADMDR=SelectIds
   
            var ret=tkMakeServerCall("web.DHCPE.SelectPreInfo","Cancel",PreIADMDR);
            var Arr=ret.split("^");
            if (Arr[0]==0){
                $("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:getValueById("PGTRowId"),RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
                $("#TeamGrid").treegrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:getValueById("ID")});
                $.messager.alert("提示","撤销成功","success");
            }else{
                $.messager.alert("提示",Arr[1],"info");
            }
            
        }
    }); 
    
}   


function BNewItem()
{
    
    var iRowId=getValueById("PGTRowId")
    var PreOrAdd="PRE"
    var lnk="dhcpepreitemlist.main.hisui.csp"+"?AdmType=TEAM"
            +"&AdmId="+iRowId+"&PreOrAdd="+PreOrAdd
            ;
	$HUI.window("#ItemEditWin", {
        		title: "预约项目修改",
        		iconCls: "icon-w-edit",
        		collapsible: false,
       			 minimizable: false,
        		maximizable: false,
        		resizable: false,
        		closable: true,
        		modal: true,
        		width: 1430,
        		height: 760,
				onClose:function(){
	        		$('#TeamPersonGrid').datagrid('reload');   //关闭窗口刷新父页面	
        		},  
        		content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
    		}); 
    return true;      
    
   /*
    var wwidth=1450;
    var wheight=1450; 
    var xposition=0;
    var yposition=0;

    var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes'
            +',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
            ;
    window.open(lnk,"_blank",nwin)  
    */
  // websys_lu(lnk,false,'iconCls=icon-w-edit,width=1430,height=750,hisui=true,title='+$g('预约项目修改')) 
     
   
}

function PreTeamEdit(instring)
{
    
    $("#NewWin").show();
    
    $HUI.window("#NewWin",{
        title:"团体分组信息",
        collapsible:false,
        minimizable:false,
        maximizable:false,
        iconCls: "icon-w-edit",
        modal:true,
        width:920,
        height:810

    });
    
    

    
    $HUI.radio("#TeamSexN").setValue(true);
    $HUI.radio("#TeamMarriedN").setValue(true);
    
    $("#TeamGReportSend").combobox('disable');
    $("#TeamIReportSend").combobox('disable');

    

    var GADMID=getValueById("ID")
    
    var ret=tkMakeServerCall("web.DHCPE.PreGADM","GetPreGADM",GADMID);
    
    
    setValueById("ParRef_Name",ret.split("^")[3])
    
    SetParRefData(ret)
    var ret=tkMakeServerCall("web.DHCPE.PreGTeam","DocListBroker","","",GADMID+"^^"+instring);
    
    TSetPatient_Sel(ret)

     TempSetObj.load({ClassName:"web.DHCPE.PreGTeam",QueryName:"GetGTeamTempSet",VIP:"",ToGID:"",GBID:"",TemplateFlag:"1"});

    
}


function TSetPatient_Sel(value) {
    var obj;
    var Data=value.split("^");
    var iLLoop=0;
    iRowId=Data[iLLoop];
    if ("0"==iRowId){
        return false;
    }
    
    //团体ADM PGT_ParRef  1
    setValueById("",Data[iLLoop])
    
    iLLoop=iLLoop+1;
        
    //  PGT_RowId
    setValueById("",Data[iLLoop]) 

    var flag=tkMakeServerCall("web.DHCPE.PreGADM","IsExsitIADMByTeam",Data[iLLoop]);
    if(flag==1){$("#VIPLevel").combobox('disable');}
    else{$("#VIPLevel").combobox('enable');}

    iLLoop=iLLoop+1;
    //  PGT_ChildSub 3
    setValueById("",Data[iLLoop])
    iLLoop=iLLoop+1;
    
    //分组名称  PGT_Desc 4
    setValueById("TeamDesc",Data[iLLoop])
    iLLoop=iLLoop+1;
    
    //  PGT_BookDateBegin   21
    setValueById("TeamBookDateBegin",Data[iLLoop])
    iLLoop=iLLoop+1;
    
    //  PGT_BookDateEnd 22
    setValueById("TeamBookDateEnd",Data[iLLoop])
    iLLoop=iLLoop+1;
    
    //预约时间 PGT_BookTime 23
    
    iLLoop=iLLoop+1;
    
    // PGT_PEDeskClerk_DR 24
    //setValueById("TeamPEDeskClerkName",Data[iLLoop])
    $("#TeamPEDeskClerkName").combogrid('grid').datagrid('reload',{'q':Data[iLLoop+18]});
    setValueById("TeamPEDeskClerkName",Data[iLLoop])

    iLLoop=iLLoop+1;
    
    var strLine="";
    //  公费加项    PGT_AddOrdItem  12
    strLine=strLine+Data[iLLoop]+"^"; 
    iLLoop=iLLoop+1;    

    //  加项金额限制  PGT_AddOrdItemLimit 13
    strLine=strLine+Data[iLLoop]+"^"; 
    iLLoop=iLLoop+1;
    
    //  公费加项金额  PGT_AddOrdItemAmount    14
    strLine=strLine+Data[iLLoop]+"^"; 
    iLLoop=iLLoop+1;    
    
    //  允许加药    PGT_AddPhcItem  15
    strLine=strLine+Data[iLLoop]+"^"; 
    iLLoop=iLLoop+1;    
    
    //  加药金额限制  PGT_AddPhcItemLimit 16
    strLine=strLine+Data[iLLoop]+"^"; 
    iLLoop=iLLoop+1;

    //  允许加药金额  PGT_AddPhcItemAmount    17
    strLine=strLine+Data[iLLoop]+"^"; 
    iLLoop=iLLoop+1;
    SetTeamAddItem(strLine);
    
    //性别    PGT_Sex 5
    
    if(Data[iLLoop]=="M")
    {$HUI.radio("#TeamSexM").setValue(true);}
    else if(Data[iLLoop]=="F")
    {$HUI.radio("#TeamSexF").setValue(true);}
    else
    {$HUI.radio("#TeamSexN").setValue(true);}
    
    iLLoop=iLLoop+1;
    //年龄上限  PGT_UpperLimit 6
    setValueById("UpperLimit",Data[iLLoop])

    iLLoop=iLLoop+1;
    //年龄下限  PGT_LowerLimit 7
    setValueById("LowerLimit",Data[iLLoop])

    iLLoop=iLLoop+1;
    //婚姻状况  PGT_Married 8
    if(Data[iLLoop]=="M")
    {$HUI.radio("#TeamMarriedM").setValue(true);}
    else if(Data[iLLoop]=="UM")
    {$HUI.radio("#TeamMarriedUM").setValue(true);}
    else
    {$HUI.radio("#TeamMarriedN").setValue(true);}
   
    iLLoop=iLLoop+4;
    
    //团体名称  PGT_LowerLimit 7
    setValueById("ParRef_Name",Data[iLLoop])
    iLLoop=iLLoop+1;
    
    //  团体报告发送  PGT_GReportSend 18
    setValueById("TeamGReportSend",Data[iLLoop])
    iLLoop=iLLoop+1;    
    
    //  个人报告发送  PGT_IReportSend 19
    setValueById("TeamIReportSend",Data[iLLoop])
    iLLoop=iLLoop+1;    
    
    //  结算方式    PGT_DisChargedMode  20
    setValueById("TeamDisChargedMode",Data[iLLoop])
    iLLoop=iLLoop+1;    
    // PGT_PEDeskClerk_DR_Name 24.1
    
    iLLoop=iLLoop+1;
    
    setValueById("VIPLevel",Data[iLLoop])
    iLLoop=iLLoop+1;
    
    iLLoop=iLLoop+1;
    setValueById("TeamPatFeeTypeName",Data[iLLoop])

    iLLoop=iLLoop+1;
    var NoInclude=""
    NoInclude=Data[iLLoop];
    if (NoInclude=="1"){
        setValueById("NoIncludeGroup",Data[iLLoop])
    }
    
    
    var VIPLevelDesc=$("#VIPLevel").combobox('getText');
    
    if (VIPLevelDesc=="职业病"){
            $("#OMEType").combobox('enable');
            $("#HarmInfo").combotree('enable');
                var TeamOMETypeObj = $HUI.combobox("#OMEType",{
                url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindOMEType&ResultSetType=array",
                valueField:'id',
                textField:'Desc',
                onBeforeLoad: function(param){
                    param.VIPLevel=$("#VIPLevel").combobox('getValue'); 
                } 
            });
    

        }else{
                $("#OMEType").combobox('disable');
                $("#HarmInfo").combotree('disable');
                
        }
    iLLoop=iLLoop+1;
    //检查种类
    OMEType=Data[iLLoop];
    $("#OMEType").combobox("setValues",OMEType);
    
    iLLoop=iLLoop+1;
    var RoomPlace=""
    RoomPlace=Data[iLLoop];

    var RoomPlaceObj = $HUI.combobox("#RoomPlace",{
        url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindRoomPlace&ResultSetType=array",
        valueField:'id',
        textField:'desc',
        onBeforeLoad:function(param){
            var VIP=$("#VIPLevel").combobox("getValue");
            param.VIPLevel = VIP;
            param.GIType = "I";
            param.LocID = session['LOGON.CTLOCID']
        }
       })

     $("#RoomPlace").combobox("setValue",Data[iLLoop]);

    iLLoop=iLLoop+1;
    //危害因素
    var HarmInfo=Data[iLLoop].split(","); 
    $("#HarmInfo").combotree("setValues",HarmInfo);
    
    
    iLLoop=iLLoop+1;
    setValueById("PreGRebate",Data[iLLoop])
    iLLoop=iLLoop+1;
    setValueById("AddGRebate",Data[iLLoop])
    iLLoop=iLLoop+1;
    setValueById("AddIRebate",Data[iLLoop])
    
    iLLoop=iLLoop+1;
    //父层分组
    var ParentTeam=Data[iLLoop]; 
    
    $("#ParentTeam").combobox("setValue",ParentTeam);
    
}

//预约修改
function GIAdmEdit(instring)
{
    
    var rowid=instring.split("^")[0]
    var regno=instring.split("^")[1]
    var name=instring.split("^")[2]
    var pedate=instring.split("^")[3]
    var petime=instring.split("^")[4]
    
    
    //var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreIADM.GTEdit"+"&ID="+rowid+"&RegNo="+regno+"&Name="+name+"&PEDate="+pedate+"&PETime="+petime;
    //websys_lu(str,false,'width=700,height=495,hisui=true,title=预约信息修改')
    
     var lnk = "dhcpepreiadm.gtedit.hisui.csp?ID=" + rowid + "&RegNo="+regno+"&Name="+name+"&PEDate="+pedate+"&PETime="+petime;
   
    $HUI.window("#GIAdmEditWin",{
        title:"预约修改",
        iconCls: "icon-w-edit",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: true,
        closable: true,
        modal: true,
        width:528, 
        height:552,
        content:'<iframe src="'+PEURLAddToken(lnk)+'" width="100%" height="100%" frameborder="0"></iframe>'

    });
    
}

function BaseInfo(index)
{
    var rows = $('#TeamPersonGrid').datagrid("getRows");
    var PIADM=rows[index].PIADM_RowId;
    var PIBI=rows[index].PIADM_PIBI_DR;
    var GroupDR=rows[index].PIADM_PGADM_DR;
    var TeamDR=rows[index].PIADM_PGTeam_DR;
    //var lnk="dhcpepreibaseinfo.edit.hisui.csp?OperType=Q&ID="+PIBI+"&TeamID="+TeamDR;
	var lnk="dhcpepreibaseinfonew.edit.hisui.csp"+"?ID="+PIBI+"&OperType="+"M";
    websys_lu(lnk,false,'width=795,height=630,hisui=true,title='+$g("个人基本信息维护"))
}



function NoCheckedList(rowid)
{
    /*
    $HUI.window("#CheckedListWin",{
        title:"检查信息列表",
        collapsible:false,
        modal:true,
        width:1200, 
        height:600,
        content:'<iframe src="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEHadCheckedList&HadCheckType=N&GroupID='+rowid+'" width="100%" height="100%" frameborder="0"></iframe>'

    });
    */
    //var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEHadCheckedList&HadCheckType=N&GroupID="+rowid;
    
    //websys_lu(str,false,'width=1200,height=495,hisui=true,title=未检信息列表')
    var GroupID=rowid.split("||")[0];
    var lnk="dhcpehadcheckedlist.hisui.csp"+"?TeamID="+rowid+"&GroupID="+GroupID+"&HadCheckType=N";
     websys_lu(lnk,false,'width=1200,height=600,hisui=true,title='+$g('未检名单'))
}

function HadCheckedList(rowid)
{
    /*
    $HUI.window("#CheckedListWin",{
        title:"检查信息列表",
        collapsible:false,
        modal:true,
        width:1200, 
        height:600,
        content:'<iframe src="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEHadCheckedList&HadCheckType=Y&GroupID='+rowid+'" width="100%" height="100%" frameborder="0"></iframe>'

    });
    */
    //var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEHadCheckedList&HadCheckType=Y&GroupID="+rowid;
    
    //websys_lu(str,false,'width=1200,height=495,hisui=true,title=已检信息列表')
    var GroupID=rowid.split("||")[0];
    var lnk="dhcpehadcheckedlist.hisui.csp"+"?TeamID="+rowid+"&GroupID="+GroupID+"&HadCheckType=Y";
     websys_lu(lnk,false,'width=1200,height=600,hisui=true,title='+$g('已检名单'))
    
}
function CancelPEList(rowid)
{
    
    //var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEHadCheckedList&HadCheckType=C&GroupID="+rowid;
    //websys_lu(str,false,'width=1200,height=495,hisui=true,title=取消体检信息列表')
    var GroupID=rowid.split("||")[0];
    var lnk="dhcpehadcheckedlist.hisui.csp"+"?TeamID="+rowid+"&GroupID="+GroupID+"&HadCheckType=C";
     websys_lu(lnk,false,'width=1200,height=600,hisui=true,title='+$g('取消体检名单'))
    
}
function CheckTeamItem(rowid)
{
    /*
    $HUI.window("#ItemWin",{
        title:"项目信息列表",
        collapsible:false,
        modal:true,
        width:800, 
        height:600,
        content:'<iframe src="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.List&AdmType=TEAM&AdmId='+rowid+'" width="100%" height="100%" frameborder="0"></iframe>'

    });
    */
    var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.List&AdmType=TEAM&AdmId="+rowid;
    
    websys_lu(str,false,'width=690,height=495,hisui=true,title='+$g('项目信息列表'))
}

function CheckItem(rowid)
{
    /*
    $HUI.window("#ItemWin",{
        title:"项目信息列表",
        collapsible:false,
        modal:true,
        width:800, 
        height:600,
        content:'<iframe src="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.List&AdmType=PERSON&AdmId='+rowid+'" width="100%" height="100%" frameborder="0"></iframe>'

    });
    */
    var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.List&AdmType=PERSON&AdmId="+rowid;
    
    websys_lu(str,false,'width=690,height=495,hisui=true,title='+$g('项目信息列表'))
    
}

//项目明细弹窗
var openIADMItemDetailWin= function(value){
    //alert(value)
    var rowid=value.split("^")[0];
    var AdmType=value.split("^")[1];
  
    $("#IADMItemDetailWin").show();
    $HUI.window("#IADMItemDetailWin",{
        title:"项目明细",
        iconCls:'icon-w-list',
        minimizable:false,
        maximizable:false,
        collapsible:false,
        modal:true
    });
    
    var ItemDetailObj = $HUI.datagrid("#IADMItemDetailGrid",{
        url:$URL,
        fit : true,
        border : false,
        striped : false,
        fitColumns : false,
        autoRowHeight : false,
        rownumbers:true,
        pagination : true, 
        pageSize: 20,
        pageList : [20,100,200],
        queryParams:{
            ClassName:"web.DHCPE.Query.PreItemList",
            QueryName:"QueryPreItemList",
            AdmId:rowid,
            AdmType:AdmType
        },
        
        columns:[[
            {field:'ItemDesc',width:'120',title:'项目名称'},
            {field:'ItemSetDesc',width:'100',title:'套餐'},
            {field:'TAccountAmount',width:'100',title:'应收金额',align:'right'},
            {field:'TSpecName',width:'90',title:'样本'},
            {field:'TAddUser',width:'90',title:'操作员'},
            {field:'TPreOrAdd',width:'90',title:'项目类别'},
            {field:'TRecLocDesc',width:'100',title:'接收科室'}
            
        ]]              
        
        })

    
};

function BNewIADM()
{
    var iRowId="";

    var iPIBIDR="", iPGADMDR="", iPGTeamDR="", iPEDateBegin="", iPEDateEnd="", iPETime="", iPEDeskClerkDR="", 
        iStatus="", iAsCharged="", iAccountAmount="", iDiscountedAmount="", iSaleAmount="", 
        iFactAmount="", iAuditUserDR="", iAuditDate="", iUpdateUserDR="", iUpdateDate=""
        iChargedStatus="", iCheckedStatus="", iAddOrdItem="", iAddOrdItemLimit="", 
        iAddOrdItemAmount="", iAddPhcItem="", iAddPhcItemLimit="", iAddPhcItemAmount="", 
        iIReportSend="", iDisChargedMode=""
        ;
    var obj;

    
    iRowId="";

    var iRegNo=$("#RegNo").val();
    if(iRegNo==""){
        $.messager.alert("提示","无效客户信息",'info');
            return false;
    }

    
    //预登记个人基本信息号 PIADM_PIBI_DR 1
    iPIBIDR=getValueById("PIBI_RowId")
    
    
    //对应团体的ADM PIADM_PGADM_DR 2
    iPGADMDR=getValueById("ID")
    
    if (""==iPGADMDR) {
            //无效团体组
            $.messager.alert("提示","无效团体",'info');
            return false;
        }
    

    //对应组ADM PIADM_PGTeam_DR 3
    iPGTeamDR=getValueById("PGTRowId")
    
    if (""==iPGTeamDR) {
            //无效团体组
            $.messager.alert("提示","无效分组",'info');
            return false;
        } 
    
    
    var flag=tkMakeServerCall("web.DHCPE.PreIADM","InsertIADMInGTeam",iPIBIDR,iPGADMDR,iPGTeamDR);
    if (flag=="Err Audit")
    {
        //alert("计费纪录都已审核,请先取消审核纪录");
        $.messager.alert("提示","计费记录都已审核,请先取消审核记录",'info');
        return false;
    }
    
    if (""==iRowId) { 
        var Rets=flag.split("^");
        flag=Rets[0];
        
    }
    if ('0'==flag) {
        $("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:iPGTeamDR,RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
        
        window.parent.$("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:iPGTeamDR,RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
        
        $("#TeamGrid").treegrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:getValueById("ID")});

        window.parent.$("#TeamGrid").treegrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:getValueById("ID")});
         
    }
    else if ('Err 07'==flag) {
        $.messager.alert("提示","客户在团体或团体组中已存在!",'info');
        //alert("客户在团体或团体组中已存在!");
        return false;       
    }
    else if ('Err 09'==flag) {
        $.messager.alert("提示","增加团体组客户失败"+":"+Rets[1],'error');
        //alert("增加团体组客户失败"+":"+Rets[1]);
        return false;       
    }
    else {
        $.messager.alert("提示","更新错误 错误号:"+flag,'error');
        //alert("更新错误 错误号:"+flag);
        return false;
    }
    
    return true;
    
}


function BFind_Click()
{
    
    var iStatus=GetStatus();
    
    
    $("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:getValueById("PGTRowId"),RegNo:getValueById("RegNo"),Name:getValueById("PatName"),DepartName:getValueById("DepartName"),OperType:"",Status:iStatus}); 
        
    
    
}


function GetStatus()
{
    var obj;
    var iStatus="";

    // PREREG 预约
    obj=getValueById("PREREG");
    if (obj){ iStatus=iStatus+"^"+"PREREG"; }

    // REGISTERED 登记
    obj=getValueById("REGISTERED");
    if (obj){ iStatus=iStatus+"^"+"REGISTERED"; }
    
    // REGISTERED 到达
    obj=getValueById("ARRIVED");
    if (obj){ iStatus=iStatus+"^"+"ARRIVED"; }
    
    iStatus=iStatus+"^"
    return iStatus;
}

//复制分组
function BCopyTeam()
{
    var iRowId="";

    var obj=document.getElementById("PGTRowId");
    if (obj) { iRowId=obj.value; }
    if (""==iRowId) { return false;}
    
    var flag=tkMakeServerCall("web.DHCPE.PreGTeam","CopyTeamData",iRowId);
    
    if (flag=="Notice"){
        alert("已审核,加人加项需取消审核!");
        return false;
    }
    if (flag!="") {
        alert("保存出错!"+":"+flag);
        return false;
    }
    $("#TeamGrid").treegrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:getValueById("ID")}); 
    $("#PGTRowId").val("");
    $("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:$("#PGTRowId").val(),RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
    
}
function DelGTeamTemp(rowid)
{
    
    var ret=tkMakeServerCall("web.DHCPE.PreGTeam","GTeamTempSet","",rowid,"Del"); 
    if(ret==0)
    {
        $("#TempSet").datagrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"GetGTeamTempSet",VIP:"",ToGID:"",GBID:"",TemplateFlag:"1"}); 
    }       
}


function GetSelectADM()
{
    var PreADMs="",PIADM="";
    var selectrow = $("#TeamPersonGrid").datagrid("getChecked");//获取的是数组，多行数据
    
    for(var i=0;i<selectrow.length;i++){
        var PIADM=selectrow[i].PIADM_RowId;
        if ((PIADM=="")||(PIADM==" ")) continue;
        if (PreADMs==""){
                PreADMs=PIADM;
            }else{
                PreADMs=PreADMs+"^"+PIADM;
            }

    }
    return PreADMs
}


var DoType="";
function BRegister()
{
  
    DoType=2;
    register(0,0);  //register 传入已成功，已失败数据  wgy
    
    var PreTeamID=$("#PGTRowId").val();
    var PreGADMID=$("#ID").val();
    if(DoType==2){var GType="TeamRegister";}
    if(DoType==3){var GType="TeamArrived";}
    var CurUser=session['LOGON.USERID'];
    var Ret=tkMakeServerCall("web.DHCPE.GAdmRecordManager","Insert",PreGADMID,"P",GType,CurUser,PreTeamID); 
    
}

function TCancelPE()
{
    
    
    var iRowId=$("#PGTRowId").val();
    
    if (""==iRowId) {
         $.messager.alert("提示","请选择待取消体检的分组","info"); 
        return false;
    }
    
    $.messager.confirm("确认", "是否确定取消体检？", function(r){
    if (r){     
    
        var Ret=tkMakeServerCall("web.DHCPE.CancelPE","CancelPE",iRowId,"T","0");
    
        Ret=Ret.split("^")

        if (Ret[0]=="0") 
    
        {
            $.messager.alert("提示","完成取消体检！","info");
             
            $("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:$("#PGTRowId").val(),RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
           
            $("#TeamGrid").treegrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:getValueById("ID")}); 

         } 
     else
        {
            $.messager.alert("提示",Ret[1],"info");
        
            }
        }
    });
    
    
}



function BCancelPE()
{
    
    var SelectIds=""
    var selectrow = $("#TeamPersonGrid").datagrid("getChecked");//获取的是数组，多行数据
    for(var i=0;i<selectrow.length;i++){
        
        if (SelectIds==""){
                SelectIds=selectrow[i].PIADM_RowId;
            }else{
                SelectIds=SelectIds+"^"+selectrow[i].PIADM_RowId;
            } 
    }
    
    if(SelectIds=="")
    { 
        $.messager.alert("提示","请选择待取消体检的人员","info");
        return false;
    }

    
    $.messager.confirm("确认", "是否确定取消体检？", function(r){
        if (r){
            
            var CancelFlag=0;
    
    PreAdmIdStr=SelectIds.split("^")

    for(var i=0;i<PreAdmIdStr.length;i++){
        
        var PreAdmId=PreAdmIdStr[i];
        var Ret=tkMakeServerCall("web.DHCPE.CancelPE","CancelPE",PreAdmId,"I","0"); 
        Ret=Ret.split("^")
        
        if (Ret[1]!=="完成取消体检操作")
        { 
            CancelFlag=1; 
        }
        
    }
    

    if (CancelFlag=="0") 
    
     {
         
         $.messager.alert("提示","完成取消体检！","info");
         
         var gteam=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetGTeamByIADM",PreAdmId);
         
         $("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:gteam,RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
         
         $("#TeamGrid").treegrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:getValueById("ID")});
         
     
     } 
    else
     {
        $.messager.alert("提示",Ret[1],"info");
         var gteam=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetGTeamByIADM",PreAdmId);
         $("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:gteam,RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 

        
     }
        }
    });
    
    
}

var OKNumTotal=0,ErrNumTotal=0;
var LastTeamRowID="";
/**
 * [必须传入已成功、已失败记录数  因为setTimeout 任务队列执行时，全局函数被重新初始化了]
 * @param    {[type]}    hadOkNum  [description]
 * @param    {[type]}    hadErrNum [description]
 * modify by    wangguoying
 */
function register(hadOkNum,hadErrNum) {
    var OneNum = 3; //每次操作人数OneNum+1
    var obj = document.getElementById("PGTRowId");
    if (obj) {
        iRowId = obj.value;
        // if ((LastTeamRowID != "") && (LastTeamRowID != iRowId)) { var hadOkNum = 0,
        //         hadErrNum = 0; }
        // var LastTeamRowID = iRowId;
    }

    if ("" == iRowId) {
        alert("请选择分组!");
        return false;
    }
    $('#PELoading').css('display',"block"); 
    var ret = tkMakeServerCall("web.DHCPE.DHCPEIAdm", "UpdateTeamInfo", iRowId, DoType, OneNum);
    var Arr = ret.split("^")
    if(Arr[0] == "0" && Arr[1] == "0" && Arr[2] == "0"){  //SLQCODE=0  OKNum=0 ErrNum=0 表示已完成

        $('#PELoading').fadeOut('fast');
        $("#LoadMsg").html("处理中");
        var obj = document.getElementById("RegisterInfo");
        obj.innerText = "登记成功:" + hadOkNum + "人;错误:" + hadErrNum + "人";
        $("#TeamPersonGrid").datagrid('load', { ClassName: "web.DHCPE.PreIADM", QueryName: "SearchGTeamIADM", GTeam: iRowId, RegNo: "", Name: "", DepartName: "", OperType: "", Status: "" });
    }else{
        var Num = Arr[1]
        if(parseInt(Arr[2]) > 0){
            var OKNum = Arr[1];
            var ErrNum = Arr[2];
            hadOkNum = hadOkNum + (+OKNum);
            hadErrNum = hadErrNum + (+ErrNum);
            var obj = document.getElementById("RegisterInfo");
            $("#LoadMsg").html("登记成功:<font color='green'> " + hadOkNum + "</font>人;错误:<font color='red'> " + hadErrNum + "</font>人");
            $('#PELoading').fadeOut('fast');
            $("#LoadMsg").html("处理中");
            obj.innerText = "登记成功:" + hadOkNum + "人;错误:" + hadErrNum + "人";
            $("#TeamPersonGrid").datagrid('load', { ClassName: "web.DHCPE.PreIADM", QueryName: "SearchGTeamIADM", GTeam: iRowId, RegNo: "", Name: "", DepartName: "", OperType: "", Status: "" });
        }else  {  
            var OKNum = Arr[1];
            var ErrNum = Arr[2];
            hadOkNum = hadOkNum + (+OKNum);
            hadErrNum = hadErrNum + (+ErrNum);
            var obj = document.getElementById("RegisterInfo");
            $("#LoadMsg").html("登记成功:<font color='green'> " + hadOkNum + "</font>人;错误:<font color='red'> " + hadErrNum + "</font>人");
            setTimeout("register("+hadOkNum+","+hadErrNum+")", 500);

        }  
    }
    
    
    var GStatus = tkMakeServerCall("web.DHCPE.PreGADM", "GetStatus", GroupID);
    if (GStatus != "PREREG") {
        $("#RapidNew").linkbutton('disable');
        return false;
    } else {
        $("#RapidNew").linkbutton('enable');
    }
    

}

function BPrintPatItem_click()
{
    var Instring,PAADM
    var obj=document.getElementById("PGTRowId");
    if (obj) { var iRowId=obj.value; }
    if (""==iRowId) 
    {
        $.messager.alert("提示","请先选择分组","info");
        return false;
     }
     
   
    $.messager.confirm("提示", "只打印未打印过的?", function (r) {
    if (r) {
                    
                    
    var IDS=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetTeamIADM",iRowId,1)
    if (IDS=="")
    {
        $.messager.alert("提示","没有需要打印的数据","info");
        return
        
    }
    var idArr = IDS.split("^");
    $('#PELoading').css('display',"block"); 
    patItem_print(idArr,0,5);
                    
                    
                    
     } else {
    var IDS=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetTeamIADM",iRowId)
    if (IDS=="")
    {
        $.messager.alert("提示","没有需要打印的数据","info");
        return
        
    }
    var idArr = IDS.split("^");
    $('#PELoading').css('display',"block"); 
    patItem_print(idArr,0,5);
                    
                    
                    
                    
                    
    }
    });
      
     
     
    
    
}


/**
 * [分组打印导诊单]
 * @param    {[Array]}    idArr          [分组成员记录的PAADM数组]
 * @param    {[int]}      startIndex     [开始下标]
 * @param    {[int]}      copies         [每次打印记录数]
 * @Author   wangguoying
 * @DateTime 2020-09-22
 */
function patItem_print(idArr,startIndex,copies){
    var count = startIndex + copies;
    for (; startIndex < count; startIndex++) {
        if(startIndex == idArr.length) break;

        var PAADM=idArr[startIndex];
        var Instring=PAADM+"^1^PAADM";
        var value=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetPatOrdItemInfo",'','',Instring);
        PrintDJDByType(PAADM, "PAADM", "P", "");  // DHCPEPrintDJDCommon.js
        //PEPrintDJD("P",PAADM,"");//DHCPEPrintDJDCommon.js lodop打印导诊单
        //PrintA4(value,1,"N"); //DHCPEIAdmItemStatusAdms.PatItemPrint.js
        var PFlag=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","PatItemPrintFlag",PAADM);
    }

    if(startIndex == idArr.length){ //打印结束
        $("#LoadMsg").html("已打印:<font color='green'> " + startIndex  + "</font>/" + idArr.length );
        $('#PELoading').fadeOut('fast');
        $("#LoadMsg").html("处理中");
    }else{
        $("#LoadMsg").html("已打印:<font color='green'> " + startIndex  + "</font>/" + idArr.length );
        setTimeout(function(){patItem_print(idArr,startIndex,copies);});
    }

}
//续打凭条
function ConPrintTPerson_click()
{
    var obj,ConRegNo,iRegNo
    obj=document.getElementById("ContinueRegNo");
    if (obj) {
        ConRegNo=obj.value;
        if(ConRegNo==""){
            alert("请先输入续打体检号")
            return false;
        }
        var flag=tkMakeServerCall("web.DHCPE.PrintGroupPerson","IsHPNo",ConRegNo);
        if(flag=="1"){
            alert("输入的体检号不正确");
            return false;
        }

        //iRegNo=RegNoMask(ConRegNo);
        PrintTeamPerson_click(iRegNo);
        }
    else {alert("请输入续打体检号!")}
}

//按分组打印
function PrintTeamPerson_click(ConRegNo)
{
    try{
    
    var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
    var Templatefilepath=prnpath+'DHCPEPrintTeamPerson.xls';
    
    xlApp = new ActiveXObject("Excel.Application");  //固定
    xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
    xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称
    
    var myDate = new Date();
    myDate.getFullYear();
    
    var obj=document.getElementById("PGTRowId");
    if(obj)  {var PGADMID=obj.value;}   //team
    if ((""==PGADMID)){
        alert("未选择分组");
        return false;   }
    var Instring=PGADMID;
  
    
    var returnval=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetPreGPerson",Instring,"Y",ConRegNo);
    
    var str=returnval; 
    var temprow=str.split("^");
    if(temprow=="")
    {
        alert("该团体人员名单为空")
        return;
    } 
   
    
    for(i=0;i<=(temprow.length-1);i++)
    {  
        var row=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetInfoById",temprow[i]);
        
        var tempcol=row.split("^");
        var j=(i+1)%6;
        var Rows,Cols;
        if (j==1){
            Rows=0; 
            Cols=0; 
        }
        if (j==2){
            Rows=0;  
            Cols=7;             
        }
        if (j==3){
            Rows=12;  
            Cols=0;    
        }
        if (j==4){
            Rows=12; 
            Cols=7;         
        }
        if (j==5){
            Rows=24;  
            Cols=0;             
        }
        if (j==0){
            Rows=24;
            Cols=7;
        } 
       
        xlsheet.cells(Rows+2,Cols+2)=tempcol[2]; //姓名
        xlsheet.cells(Rows+2,Cols+4)=tempcol[3]; //性别
        xlsheet.cells(Rows+2,Cols+6)=tempcol[4]; //年龄
        //xlsheet.cells(Rows+3,Cols+3)=tempcol[13]; //电话
        xlsheet.cells(Rows+3,Cols+3)=tempcol[15]; //体检号
        xlsheet.cells(Rows+4,Cols+3)="*"+tempcol[1]+"*"; //编号或条码
        xlsheet.cells(Rows+6,Cols+3)=tempcol[9]; //单位名称
        xlsheet.cells(Rows+7,Cols+3)=tempcol[6]; //所属部门
        
        
        var HOSPID=session['LOGON.HOSPID'];
        var HospitalName=""
        var HospitalName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",HOSPID);
        if(HospitalName.indexOf("[")>0) var HospitalName=HospitalName.split("[")[0]
        xlsheet.cells(Rows+1,Cols+1)=(myDate.getFullYear())+"年"+HospitalName+"体检凭条";

        xlsheet.cells(Rows+2,Cols+1)="姓名:";
        xlsheet.cells(Rows+2,Cols+3)="性别:";
        xlsheet.cells(Rows+2,Cols+5)="年龄:";
        //xlsheet.cells(Rows+3,Cols+1)="联系电话:";
        xlsheet.cells(Rows+3,Cols+1)="体检号:";
        xlsheet.cells(Rows+4,Cols+1)="编号(或编码):";
        xlsheet.cells(Rows+6,Cols+1)="单位名称：";
        xlsheet.cells(Rows+7,Cols+1)="所属部门:";
        xlsheet.cells(Rows+8,Cols+1)="★注:抽血时间:上午8:00---9:30";
       if(session['LOGON.CTLOCID']=='572')
        {
            xlsheet.cells(Rows+9,Cols+1)="体检地址:";
            xlsheet.cells(Rows+10,Cols+1)="体检电话: ";    
            xlsheet.cells(Rows+8,Cols+1)="★注:登记时间:上午7:45---10:00";
        }
        else
        {
        if
            (tempcol[14]=="2"){
                xlsheet.cells(Rows+9,Cols+1)="体检地址:";
                xlsheet.cells(Rows+10,Cols+1)="体检电话: ";
            }else{
                xlsheet.cells(Rows+9,Cols+1)="体检地址:";
                xlsheet.cells(Rows+10,Cols+1)="体检电话:";
            }
        }
        if(j==0){
            xlsheet.printout;
            for(m=1;m<40;m++){
                for(n=1;n<20;n++){
                    xlsheet.cells(m,n)="";
                    }
                }
            }
    }
    
    if(j!=0){
     
    xlsheet.printout;
    }   
    xlBook.Close (savechanges=false);
    xlApp.Quit();
    xlApp=null;
    xlsheet=null;

    idTmr   =   window.setInterval("Cleanup();",1); 
    
}

catch(e)
    {
        alert(e+"^"+e.message);
    }
    
    
}

//团体打印单个人员体检凭条方法
function PrintTeamSelf_click()
{
    var iRowId=GetSelectADM();
    PrintGPerson_click(iRowId)
    
}

function PrintGPerson_click(iRowIDStr)
{
    
    try{
        
    var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
    var Templatefilepath=prnpath+'DHCPEPrintTeamPerson.xls';
    
    xlApp = new ActiveXObject("Excel.Application");  //固定
    xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
    xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称

    var myDate = new Date();
    myDate.getFullYear();
    
  
    var temprow=iRowIDStr.split("^");
    if(temprow=="")
    {
        alert("您没有选择任何一个人员!")
        return;
    } 
    
    
    for(i=0;i<=(temprow.length-1);i++)
    {  
        var row=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetInfoById",temprow[i]);
        //alert("row:"+row)
        var tempcol=row.split("^");
        var j=(i+1)%6;
        var Rows,Cols;
        if (j==1){
            Rows=0; 
            Cols=0; 
        }
        if (j==2){
            Rows=0;  
            Cols=7;             
        }
        if (j==3){
            Rows=12;  
            Cols=0;    
        }
        if (j==4){
            Rows=12; 
            Cols=7;         
        }
        if (j==5){
            Rows=24;  
            Cols=0;             
        }
        if (j==0){
            Rows=24;
            Cols=7;
        }
        xlsheet.cells(Rows+2,Cols+2)=tempcol[2]; //姓名
        xlsheet.cells(Rows+2,Cols+4)=tempcol[3]; //性别
        xlsheet.cells(Rows+2,Cols+6)=tempcol[4]; //年龄
        //xlsheet.cells(Rows+3,Cols+3)=tempcol[13]; //电话
        xlsheet.cells(Rows+3,Cols+3)=tempcol[15]; ///体检号
        xlsheet.cells(Rows+4,Cols+3)="*"+tempcol[1]+"*"; //编号或条码
        xlsheet.cells(Rows+6,Cols+3)=tempcol[9] //PIADMName; //单位名称
        xlsheet.cells(Rows+7,Cols+3)=tempcol[6]; //所属部门
        
            
        var HOSPID=session['LOGON.HOSPID'];
        var HospitalName=""
        var HospitalName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",HOSPID);
        if(HospitalName.indexOf("[")>0) var HospitalName=HospitalName.split("[")[0]
        xlsheet.cells(Rows+1,Cols+1)=(myDate.getFullYear())+"年"+HospitalName+"体检凭条";
       
        //xlsheet.cells(Rows+1,Cols+1)=(myDate.getFullYear())+"年北京协和医院体检中心体检凭条";
        xlsheet.cells(Rows+2,Cols+1)="姓名:";
        xlsheet.cells(Rows+2,Cols+3)="性别:";
        xlsheet.cells(Rows+2,Cols+5)="年龄:";
        xlsheet.cells(Rows+3,Cols+1)="体检号:";
        xlsheet.cells(Rows+4,Cols+1)="编号(或编码):";
        xlsheet.cells(Rows+6,Cols+1)="单位名称：";
        xlsheet.cells(Rows+7,Cols+1)="所属部门:";
        xlsheet.cells(Rows+8,Cols+1)="★注:抽血时间:上午8:00---9:30";
       if(session['LOGON.CTLOCID']=='572')
        {
            xlsheet.cells(Rows+9,Cols+1)="体检地址:";
            xlsheet.cells(Rows+10,Cols+1)="体检电话:";    
            
        }
        else
        {
        if
            (tempcol[14]=="2"){
                xlsheet.cells(Rows+9,Cols+1)="体检地址:";
                xlsheet.cells(Rows+10,Cols+1)="体检电话:";
            }else{
                xlsheet.cells(Rows+9,Cols+1)="体检地址:";
                xlsheet.cells(Rows+10,Cols+1)="体检电话:";
            }
        }
        if(j==0){
            
            xlsheet.printout;
            for(m=1;m<40;m++){
                for(n=1;n<20;n++){
                    xlsheet.cells(m,n)="";
                    }
                }
            }
    }

    if(j!=0){
     
    xlsheet.printout;
    }   
    xlBook.Close (savechanges=false);
    xlApp.Quit();
    xlApp=null;
    xlsheet=null;

    idTmr   =   window.setInterval("Cleanup();",1);     
}
catch(e)
    {
        alert(e+"^"+e.message);
    }   
}


function isInteger(num) {
      if (!isNaN(num) && num % 1 === 0) {
        return true;
      } else {
        return false;
      }
 
}
//验证是否为浮点数
function IsFloat(Value) {
    
    var reg;
    if(""==$.trim(Value)) { 
        return true; 
    }else { Value=Value.toString(); }
    //reg=/^((\d+\.\d*[1-9]\d*)|(\d*[1-9]\d*\.\d+)|(\d*[1-9]\d*))$/;
    reg=/^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/;
    
    //reg=/^((-?|\+?)\d+)(\.\d+)?$/;
    if ("."==Value.charAt(0)) {
        Value="0"+Value;
    }
    
    var r=Value.match(reg);
    if (null==r) { return false; }
    else { return true; }
    
}
/**
 * [打开团体导入界面]
 * @Author   wangguoying
 * @DateTime 2020-04-27
 */
function OpenImportWin() {
    var GID = "";
    var obj = document.getElementById("ID");
    if (obj) GID = obj.value;
    if (GID == "") {
        $.messager.alert("提示", "还没有预约团体!", "info")
        return false;
    }

    var ret = tkMakeServerCall("web.DHCPE.ImportGInfo", "GetTeamStatus", GID);
    if (ret == "") {
        $.messager.alert("提示", "还没有分组信息！", "info");
        return false;
    }


    var GDesc = $("#GroupDesc").combogrid("getText")
    var AllowCF = "0";
    iAllowCF = getValueById("AllowCF")
    if (iAllowCF) {
        AllowCF = 1;
    }

    var ImportOldFlag = "0";
    iImportOldFlag = getValueById("ImportOldFlag")
    if (iImportOldFlag) {
        ImportOldFlag = 1;
    }
    if (ImportOldFlag=="0"){
        $HUI.window("#ImportGWin", {
            title: "导入团体成员",
            iconCls: "icon-w-import",
            collapsible: false,
            minimizable: false,
            maximizable: false,
            resizable: true,
            closable: true,
            modal: true,
            width: 1200,
            height: 700,
            content: '<iframe src="dhcpe.importginfo.csp?GID=' + GID + '&GDesc=' + GDesc + '&AllowCF=' + AllowCF + '" width="100%" height="100%" frameborder="0"></iframe>'
        });
    }
    else
    {
        $HUI.window("#ImportGWin", {
            title: "导入以往团体成员",
            iconCls: "icon-w-import",
            collapsible: false,
            minimizable: false,
            maximizable: false,
            resizable: true,
            closable: true,
            modal: true,
            width: 1200,
            height: 700,
            content: '<iframe src="dhcpe.importoldginfo.csp?GID=' + GID + '&GDesc=' + GDesc + '&AllowCF=' + AllowCF + '" width="100%" height="100%" frameborder="0"></iframe>'
        });
    }
}


//查询
function PreBFind_click(){
    var CTLocID=session['LOGON.CTLOCID'];
    var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength",CTLocID);
    var iRegNo= $("#PreRegNo").val();
    if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
            iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo,CTLocID);
            $("#PreRegNo").val(iRegNo);
    }
    
    var Name=$("#PreName").val();
    var TeamID=$("#PGTRowId").val();

    var HospID=session['LOGON.HOSPID'];
    
    $("#SelectPreInfoGrid").datagrid('load',{
        ClassName:"web.DHCPE.SelectPreInfo",
        QueryName:"SearchPreIADM",
        RegNo:iRegNo,
        Name:Name,
        TeamID:TeamID,
        HospID:HospID
        });
    
}

//新增
function PreBAdd_click(){
    
    var selectrow = $("#SelectPreInfoGrid").datagrid("getChecked");//获取的是数组，多行数据
   
    if (selectrow.length=="0"){
        $.messager.alert("提示","请先选择待操作的数据","info"); 
        return false;
    }
    
    var PreIADM=selectrow[0].TPIADM
    var TeamID=$("#PGTRowId").val()
    if (TeamID==""){
        $.messager.alert("提示","请选择合并到的分组","info"); 
        return false;
    }
    var Status=selectrow[0].TStatus;
    if ((Status=="预约")||(Status=="取消体检")){
        $.messager.alert("提示","请选取登记、到达的人员","info"); 
        return false;
    }

    var RegNo=selectrow[0].TRegNo;
    
    var flag=tkMakeServerCall("web.DHCPE.SelectPreInfo","GetRegNoByTeamID",TeamID,RegNo);
    if(flag==1){
         $.messager.alert("提示","分组里已经存在该人员,不能重复添加","info");
         return false;
     }
    
    var ret=tkMakeServerCall("web.DHCPE.SelectPreInfo","InsertPreToTeam",TeamID,PreIADM);
    
    var Arr=ret.split("^");
    if (Arr[0]==0){
        $.messager.alert("提示","合并成功","success");
        PreBFind_click();   
    
        $("#TeamPersonGrid").datagrid('load',{ClassName:"web.DHCPE.PreIADM",QueryName:"SearchGTeamIADM",GTeam:TeamID,RegNo:"",Name:"",DepartName:"",OperType:"",Status:""}); 
        var GroupID=TeamID.split("||")[0];
        $("#TeamGrid").treegrid('load',{ClassName:"web.DHCPE.PreGTeam",QueryName:"SearchGTeam",ParRef:GroupID}); 

    }else{
         $.messager.alert("提示",Arr[1],"info");
    }
    
}


//选取已预约人员
function InitSelectPreInfoGrid(){
    
    var TeamID=$("#PGTRowId").val();
    var HospID=session['LOGON.HOSPID'];
    //alert(TeamID)
    $HUI.datagrid("#SelectPreInfoGrid",{
        url:$URL,
        fit : true,
        border : false,
        striped : false,
        fitColumns : false,
        autoRowHeight : false,
        rownumbers:true,
        pagination : true,   
        pageSize: 20,
        pageList : [20,100,200],
        queryParams:{
            ClassName:"web.DHCPE.SelectPreInfo",
            QueryName:"SearchPreIADM",
            TeamID:TeamID,
            HospID:HospID
        },
        
        columns:[[
            {field:'TPIADM',title:'PIADM',hidden: true},
            {field:'TRegNo',width:'100',title:'登记号'},
            {field:'TName',width:'90',title:'姓名'},
            {field:'TSex',width:'70',title:'性别'},
            {field:'TVIPLevel',width:'90',title:'VIP等级'},   
            {field:'TPreDate',width:'90',title:'预约日期'},
            {field:'TGroup',width:'130',title:'单位'},
            {field:'TAmount',width:'80',title:'应收金额',align:'right'},
            {field:'TStatus',width:'70',title:'状态'},
            {field:'TAge',width:'70',title:'年龄'},
            {field:'TIDCard',width:'190',title:'证件号'},
            {field:'TPACCardType',width:'90',title:'证件类型'}      
            
        ]]
        
        })

}

//选取已预约人员
function BSelectPre()
{

    var TeamID=$("#PGTRowId").val()
    if (TeamID==""){
        $.messager.alert("提示","请先选择分组","info"); 
        return false;
    }
    $("#PreRegNo,#PreName").val("");
    
  $("#SelectPreInfoWinNew").show();
  
   $HUI.window("#SelectPreInfoWinNew", {
        title: "合并到团体",
        iconCls: "icon-w-copy",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        modal: true,
        width: 1150,
        height: 600,
       
    });
 
    InitSelectPreInfoGrid();
}


$(init);
