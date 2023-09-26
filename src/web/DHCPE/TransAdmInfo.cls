/// Description: 将CRM中相关的体检登记信息传入His系统中，包括客户基本信息、体检登记信息和
/// 体检项目
/// Test: d ##class(web.DHCPE.TransAdmInfo).test()
/// ----------------------
/// modified 2006/5/31
/// description: add bloodType, Profession etc in function TranPatInfo
/// 
Class web.DHCPE.TransAdmInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

Property crmRegId As %String(TRUNCATE = 1);

Property patCardId As %String(TRUNCATE = 1);

Property patId As %String(TRUNCATE = 1);

Property hisUserId As %String(TRUNCATE = 1);

/// 体检中心
Property hisLocId As %String(TRUNCATE = 1);

Property LABDB As %String(TRUNCATE = 1);

Property MEDDATA As %String(TRUNCATE = 1);

Property hisAdmId As %String(TRUNCATE = 1);

Property PEPATTYPE As %String(TRUNCATE = 1) [ InitialExpression = "公费" ];

Property PEREGDocId As %String(TRUNCATE = 1);

Property CRMGateway As web.DHCPE.CRM.IGateway;

Property STATUSVerifiedd As %String(TRUNCATE = 1) [ InitialExpression = "1" ];

Property STATUSStoped As %String(TRUNCATE = 1) [ InitialExpression = "4" ];

Property STATUSExecuted As %String(TRUNCATE = 1) [ InitialExpression = "6" ];

Property objHisIAdm As User.DHCPEIADM;

Method %OnNew(newName As %String) As %Status
{
    s ..MEDDATA=^DHCPESetting("NAMESPACE","MEDDATA")
    s ..LABDB=^DHCPESetting("NAMESPACE","LABDATA")
    s ..hisLocId=%session.Get("LOGON.CTLOCID")
    //^DHCPESetting("DHCPE","PhyExamLocId")
    s ..PEREGDocId=^DHCPESetting("DHCPE","PhyExamDrId",..hisLocId)
    s ..PEPATTYPE=^DHCPESetting("DHCPE","PEPatType")
    s ..CRMGateway=##class(web.DHCPE.CRM.Factory).GetGateway()
    q $$$OK
}

/*
/// crmRegIdNew--DHC_PE_PreIAdm的RowId  //MLH Modified by 2006-07-20
ClassMethod main(crmRegIdNew As %String, hisUserId As %String = "") As %String
{
    s ^lisatest("0724temp")=crmRegIdNew_"  "_hisUserId
    s myObj=##Class(TransAdmInfo).%New()
    s retStr= myObj.mainEntrance(crmRegIdNew, hisUserId)    
    q retStr
}
*/
/// ------进行体检项目删除---------（只对已经登记过的记录有效）
Method stopOldItems() [ Private ]
{
    s retStr=""
    s ret=""
    s crmExamItems=..CRMGateway.GetExamItemsByRegId(..crmRegId)
    /// return: ***$C(1)ItemID^DepID^Quantity^crmOItemID$C(1)...

    s docName=$p(^CTPCP(..PEREGDocId,1),"^",2)
    s ordStopInfo=..hisUserId_"^"_..PEREGDocId_"^"_docName
    //..ordStopSepc="userid^careprovider^careProviderName"
    s ordId=$o(^OEORD(0,"Adm",..hisAdmId,""))
    if (ordId'=""){
        s ordIChd=$o(^OEORD(ordId,"I","0"))
        while(ordIChd'=""){
            s hisOEItemDr=ordId_"||"_ordIChd
            s objOEItemMatch=##class(HandlerIAdm).GetItemMatch(hisOEItemDr,"HIS")
            s ordIStatus=$p(^OEORD(ordId,"I",ordIChd,1),"^",13)
            i ((objOEItemMatch.%Id()'="")&(ordIStatus'=..STATUSStoped)){
                s strCrmOEIID="^"_objOEItemMatch.CRMOCRMORI_$C(1)
                if ((crmExamItems_$C(1))'[strCrmOEIID){     //如果有hisOEOrdItem表中存在但在CRM传过来的串中不存在，才需要停
                    i (ordIStatus=..STATUSExecuted){
                        s retStr="ERROR: there are some OEITM have been executied! OEORDItemDr="_hisOEItemDr
                        goto errHandler
                    }
                    
                    s CurrentNS=$ZNSPACE
                    ZN ..MEDDATA        
                    s ret=$$StopOrdItem^DHCOrdItem(hisOEItemDr,ordStopInfo)
                    zn CurrentNS
                }
            }
            s ordIChd=$o(^OEORD(ordId,"I",ordIChd))
        }
    }
    q ""
errHandler
    q retStr
}

/// test: w ##class(web.DHCPE.TransAdmInfo).GetReceiveLoc(4468,"4838||1","152")
/// [Previously private]
ClassMethod GetReceiveLoc(paadmId, arcItemId, defLocId As %String = "") As %String
{
    /*
    s recLocId=""
    Set rset = ##class(%ResultSet).%New()
    Set rset.ClassName = "web.DHCOPItemMast"
    Set rset.QueryName = "AIMRecLoc"
    
    //Do rset.Execute(paadmId, arcItemId,1)
    Do rset.Execute(paadmId, arcItemId,$p($g(^PAADM(paadmId)),"^",4))
    While (rset.Next()) 
     {
         ;b ;11
         i recLocId=""  s recLocId=rset.Data("RecLocRID")
         s isDef=(rset.Data("DefRecFlag"))
         i isDef="Y" {
            s recLocId=rset.Data("RecLocRID")
            quit
         }
     }
     i recLocId=""  s recLocId=defLocId
     quit recLocId
     */
     
     
 q:paadmId="" defLocId  
 s AdmLoc=$P($g(^PAADM(paadmId)),"^",4)
 s RecLocStr=""
 i $g(^DHCPESetting("DHCPE","RecLocHospital",AdmLoc))=1  //可以跨院
 {
    s RecLocStr=##class(web.DHCDocOrderCommon).GetLocRecLoc(AdmLoc,arcItemId,1)

 }

 else
 {
    s RecLocStr=##class(web.DHCDocOrderCommon).GetLocRecLoc(AdmLoc,arcItemId)
     
 }

 q:RecLocStr="" defLocId

 s recLocId=""

 s FristLoc=""

 s RecLocLength=$L(RecLocStr,"^")

 f RecLoci=1:1:RecLocLength

 {

  s OneRecLoc=$P(RecLocStr,"^",RecLoci)

  if RecLoci=1 s FristLoc=$P(OneRecLoc,$C(1),1)

  s isDef=$P(OneRecLoc,$C(1),3)

  if (isDef="Y"){

   s recLocId=$P(OneRecLoc,$C(1),1)

  }

  q:recLocId'=""

 }

 i recLocId="" s recLocId=FristLoc

 q recLocId
}

/// debug： d ##class(%ResultSet).RunQuery("web.DHCPE.TransAdmInfo","QueryReceiveLoc","14","5244||1")
Query QueryReceiveLoc(paadmId, arcItemId) As websys.Query(ROWSPEC = "RecLocRID,RecLocDesc")
{
}

ClassMethod QueryReceiveLocExecute(ByRef qHandle As %Binary, paadmId, arcItemId) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1  
    s AdmLoc=$P(^PAADM(paadmId),"^",4)
    s RecLocStr=""
    
    i $g(^DHCPESetting("DHCPE","RecLocHospital",AdmLoc))=1  //可以跨院
    {
        s RecLocStr=##class(web.DHCDocOrderCommon).GetLocRecLoc(AdmLoc,arcItemId,1)

    }

    else
    {
        s RecLocStr=##class(web.DHCDocOrderCommon).GetLocRecLoc(AdmLoc,arcItemId)
     
    }
 
    if RecLocStr="" 
    {
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
     
     
    }

 
    //多个接收科室之间使用$C(1,2)分割，不再用^分割
    //s RecLocLength=$L(RecLocStr,"^")
    s RecLocLength=$L(RecLocStr,$C(1,2))
    f RecLoci=1:1:RecLocLength d
    .;s OneRecLoc=$P(RecLocStr,"^",RecLoci)
    .s OneRecLoc=$P(RecLocStr,$C(1,2),RecLoci)
    .s RecLocRID=$P(OneRecLoc,$C(1),1)
    .s RecLocDesc=$P(OneRecLoc,$C(1),2)
    .s ^CacheTemp(repid,ind)=$lb(RecLocRID,RecLocDesc)
    .s ind=ind+1
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// test: w ##class(web.DHCPE.TransAdmInfo).patNo2Id("00130000")
/// 由登记号得到RowId
ClassMethod patNo2Id(patNO)
{
    s patId=$o(^PAPERi("PAPMI_PatNo",patNO,""))
    q patId
}

ClassMethod test()
{
    //crmRegIdNew As %String, hisUserId As %String = ""
    w !, ##Class(web.DHCPE.TransAdmInfo).main(6, 3566)
    //loc:577   doc1112    seqno3examfee4  regfee:5   user:10125
}

/// ******************************************************************
/// Created by jdl
/// 判断个人所在的团体客户是否已经登记，如果未登记，则自动对该团体进行登记
/// d ##class(web.DHCPE.TransAdmInfo).CheckGAdmCreated(102)
ClassMethod CheckGAdmCreated(PIAdmId As %String)
{
    k IAdmID,PGAdmID,GAdmID,PGTeamID,GTeamID,childsub,result,err
    s GAdmID=""
    s err=0
    s PGAdmID=$p($g(^DHCPEPreIADM(PIAdmId)),"^",2)
    i PGAdmID="" q err    //个人不需要处理
    s GAdmID=$o(^DHCPEGADM(0,"CRMGADM",PGAdmID,""))
    if GAdmID=""
    {
        //生成组ADM
        s:($d(%session)) userid=%session.Get("LOGON.USERID")
        s:('$d(%session)) userid=5918
        s:($d(%session)) locid=%session.Get("LOGON.CTLOCID")
        s:('$d(%session)) locid=572
        //s userid=3566
        //s locid=330
        ///参数 grpIdNew?也是DHC_PE_PreGADM, grpRegIdNew指向DHC_PE_PreGADM
        //q "PGAdmID:"_PGAdmID_" userid:"_userid_" locid"_locid
        s err= ##class(web.DHCPE.TransGrpInfo).mainNew(PGAdmID,PGAdmID,userid,locid)
        if (err'="") q err
        s err=0
        s GAdmID=$o(^DHCPEGADM(0,"CRMGADM",PGAdmID,""))
        if (GAdmID="") 
        {   s err="生成团体ADM失败!"
        q err       }
    }
    s PGTeamID=$p($g(^DHCPEPreIADM(PIAdmId)),"^",3)
    if PGTeamID="" 
    {   s err="未找到预约分组记录!"
        q err       }
    s childsub=""
    s GTeamID=""
    f  s childsub=$o(^DHCPEGADM(GAdmID,"Team",childsub)) q:(childsub="")||(GTeamID'="")  d
    .i PGTeamID=$p($g(^DHCPEGADM(GAdmID,"Team",childsub)),"^",2) d
    ..s GTeamID=GAdmID_"||"_childsub
    if GTeamID="" 
    {   s err="未找到登记分组记录!"
        q err       }
    s IAdmID= $o(^DHCPEIADM(0,"CRMADM",PIAdmId,""))
    //更新个人IADM的GADMDR
    &SQL(Update SQLUser.DHC_PE_IADM set IADM_GADM_DR=:GAdmID,IADM_GTeam_DR=:GTeamID
        Where IADM_RowId=:IAdmID)
    
    if SQLCODE
    {   s err="更新个人ADM的团体信息失败!  SQLCODE="_SQLCODE               
        q err}
        
    &SQL(Update SQLUser.DHC_PE_PreAudit set PA_GIAdm=:GAdmID
        Where PA_AdmType='G' and PA_CrmAdm=:PGAdmID)    
    if SQLCODE<0
    {   s err="更新团体费用信息失败!  SQLCODE="_SQLCODE               
        q err}
    
    q err
}

/// -------插入体检项目------------
/// [Previously private]
ClassMethod InsertItems1219bak(crmRegId, admId, iAdmId, userId, locId, MEDDATA)
{
    s crmExamItems=##class(web.DHCPE.CRM.Gateway).GetExamItemsByRegId(crmRegId)
    /// return: ***$C(1)ItemID^DepID^Quantity^crmOItemID$C(1)...
    s i=1  //, hisItemsStr=""
    s retStr=""
    Set HosCode=$g(^DHCPESetting("DHCPE","HospitalCode"))
    while(i<=$l(crmExamItems,$C(1))){
        s crmItem=$p(crmExamItems,$C(1),i)
            i (crmItem'=""){
                //hisItemSpec="ordItemID^qty^loc^price^Speciment^AdmReason"
                s crmOItemId=$p(crmItem,"^",4)          
                s objOItemMatch=##class(HandlerIAdm).GetItemMatch(crmOItemId,"CRM")
                if (objOItemMatch.%Id()=""){
                    s arcItemId=$p(crmItem,"^",1)
                    s crmitemid=$p(crmItem,"^",4)
                    s crmordent=$p($g(^DHCPEPreIADM($p(crmitemid,"||",1),"ORDITEM",$p(crmitemid,"||",2))),"^",2)
                    s arcos1=""
                    if crmordent'=""  d
                    .//0926 renzwang   取标本名称错误
                    .s arcos1=##class(web.DHCPE.PEApp).GetArcSets(crmordent,arcItemId)
                    .//s arcos1=$p($g(^DHCPEPreIADM($p(crmordent,"||",1),"ORDENT",$p(crmordent,"||",2))),"^",1)
                    .s ^DHCTemp("jdl","InsertOrdItem")="crmordent:"_crmordent_"  arcos:"_arcos1
                    //s arcos=$p($g(^DHCPEPreIADM($p(crmitemid,"||",1),"ORDITEM",$p(crmitemid,"||",2))),"^",3)
                    s locId=$g(locId)    //Add by MLH20070512
                
                    //070816 renzwang
                    //s locId=..GetReceiveLoc(admId,arcItemId,locId)
                    s ldefLocId=$G(^DHCPESetting("DHCPE","PhyExamLocId"))
                    s locId=##class(web.DHCPE.PreItemList).GetRecLoc(3,crmitemid)
                    i locId="" s locId=..GetReceiveLoc(admId,arcItemId,ldefLocId)
                    i ""=$G(^DHCPESetting("DHCPE","DefaultPAADM")) s ^DHCPESetting("DHCPE","DefaultPAADM")=admId
                
                    if locId="" s locId=$p(crmItem,"^",2)
                    s hisItem=arcItemId_"^1^"_locId_"^"_$p(crmItem,"^",2)_"^^^"_arcos1
                    s ret=0
                    if arcos1'="" s ^DHCTemp("jdl","InsertOrdItem","12")="##class(web.DHCPE.PEApp).InsertOrdItem("_admId_","_hisItem_","_userId_","_locId_","_userId_")"
                    s ret=##class(web.DHCPE.PEApp).InsertOrdItem(admId, hisItem, userId,locId, userId)          
                    s hisOItemId=$p(ret,"^",2)
                    //b "before updateItemMatch"
                    s gatewayCRM=##class(web.DHCPE.CRM.Factory).GetGateway()
                    d gatewayCRM.updateItemMatch(crmOItemId,hisOItemId,iAdmId)              
                }
            }
            //Modified by MLH 20070608
            //s TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
            //i TrakVerison="MedTrak" d
            s CurrentNS=$ZNSPACE
            //友谊的，安贞的非TLA医嘱
            ZN MEDDATA
            Do presno^aOET1(admId)  //Modified by MLH 20071218
            ZN CurrentNS
        s i=i+1
}
    q retStr
}

ClassMethod GetSttDate(PAADM)
{
    s SttDate=+$H
    s OldSttDate=""
    s OEORDID=$O(^OEORD(0,"Adm",PAADM,0))
    q:OEORDID="" SttDate
    s HadColFlag=0
    s OrderSub=0
    f  s OrderSub=$O(^OEORD(OEORDID,"I",OrderSub)) q:(OrderSub="")||(HadColFlag=1)  d
    .s Stat=$P($G(^OEORD(OEORDID,"I",OrderSub,1)),"^",13)
    .q:Stat'="1"
    .s SpecNo=$p($G(^OEORD(OEORDID,"I",OrderSub,3)),"^",20)
    .q:SpecNo=""
    .s:$D(^DHCPETempLabEpisodeScan(SpecNo)) HadColFlag=1
    .q:HadColFlag=1
    .s OldSttDate=$P(^OEORD(OEORDID,"I",OrderSub,1),"^",9)
    q:HadColFlag="1" SttDate
    s:OldSttDate'="" SttDate=OldSttDate
    q SttDate
}

/// -------插入体检项目------------
/// [Previously private]
/// Debug: d ##class(web.DHCPE.TransAdmInfo).InsertItems(1132,707,674,1021,263,"DHC-DATA",1)
ClassMethod InsertItems(crmRegId, admId, iAdmId, userId, locId, MEDDATA, FeeFlag As %String = 1)
{
    s ^tempdhcpe("InsertItems")=$lb(crmRegId, admId, iAdmId, userId, locId, MEDDATA, FeeFlag)
    s retStr=""
    //Set HosCode=$g(^DHCPESetting("DHCPE","HospitalCode")) 
    Set HosCode=$g(^DHCPESetting("DHCPE","HospitalCode",locId)) 
    
    k ^DHCPETMPSendPACSApplay("SendPACSApplay",$J)
    s mListData=admId_"^"_userId_"^"_locId 
    s ListDataStr="" 

    s SttDate=..GetSttDate(admId)
    s CurDate=+$H
    s CurTime=$P($H,",",2)
    s SQLCODE=0
    s ordid=$o(^OEORD(0,"Adm",admId,""))
    i ordid="" d
    .&SQL(Insert Into SQLUser.OE_Order (OEORD_Adm_DR,OEORD_Date,OEORD_Time) values(:admId,:CurDate,:CurTime))
    .q:SQLCODE'=0
    .s ordid=%ROWID
    q:SQLCODE'=0 "插入OE_Order错误"_SQLCODE
    
    s PreGInfo=""
    s PreGInfo=$P(^DHCPEPreIADM(crmRegId),"^",2)
    i PreGInfo'="" d
    .s PreGInfo=$P(^DHCPEPreGADM(PreGInfo),"^",1)
    .s PreGInfo=$P(^DHCPEPreGBI(PreGInfo),"^",2)
    
    /////////////////////8.0.2版本发送pacs申请///////////////// 
    //added by xy 20170323 start
    s mdataFlag=0
    s myChildId="0"
    f  s myChildId=$o(^DHCPEPreIADM(crmRegId,"ORDITEM",myChildId)) q:(myChildId="")||(SQLCODE'=0)  d
    .q:$p($g(^DHCPEPreIADM(crmRegId,"ORDITEM",myChildId)),"^",16)'=1 //判断是否有效
    .s PreItemID=crmRegId_"||"_myChildId
    .s OEID=""
    .s CRMOrderID=$O(^DHCPECRMO(0,"CRMORI",PreItemID,0))
    .i CRMOrderID'="" d
    ..s OEID=$P(^DHCPECRMO(CRMOrderID),"^",1)
    .q:OEID'=""
    .s arcItemId=$p($g(^DHCPEPreIADM(crmRegId,"ORDITEM",myChildId)),"^",1) 
    .S ARCItemCat=$P($G(^ARCIM(+arcItemId,1,1)),"^",10) //医嘱子分类
    .S ARCICOrdType=$P($G(^ARC("IC",ARCItemCat)),"^",7) 
    .s Service=$P(^ARCIM(+arcItemId,1,7),"^",6)
    .q:(Service'="S")&&(ARCICOrdType'="L") //检验(医嘱子分类L,医生界面显示的时间轴上需要显示申请时间和医生)、检验查都需要插入申请单表
    .s STRowId=$o(^DHCPEST(0,"STORD_ARCIM",arcItemId,0))
    .s STDesc=""
    .i STRowId'="" s STDesc=$p($g(^DHCPEST(STRowId)),"^",2)
    .q:STDesc["病理"
    .s locId=##class(web.DHCPE.PreItemList).GetRecLoc(3,PreItemID)
    .s ldefLocId=$p($g(^DHCPEPreIADM(crmRegId)),"^",26)
    .i locId="" s locId=..GetReceiveLoc(admId,arcItemId,ldefLocId)
    .i ""=$G(^DHCPESetting("DHCPE","DefaultPAADM",ldefLocId)) s ^DHCPESetting("DHCPE","DefaultPAADM",ldefLocId)=admId
    .if locId="" s locId=ldefLocId
    .S ListData=""_"^"_locId_"^"_SttDate_"^"_arcItemId_"^"_""
    .;I ListDataStr="" S ListDataStr=ListData
    .;e  s ListDataStr=ListDataStr_"@"_ListData
    .s mListDataStr=""
    .s mListDataStr=mListData_"!"_ListData 
    .s mdata=""
    .s mdata=##Class(web.DHCAPPInterface).InsExaReqNo(mListDataStr)
    .i +mdata<0 s mdataFlag=1
    .s ArcimRegID=$P(mdata,"^",1)
    .s ArcimID=$P(mdata,"^",2)
    .s flag=$P(mdata,"^",3)
    .;s ^DHCPETMPSendPACSApplay("SendPACSApplay",$J,ArcimID)=ArcimRegID_"^"_ flag
    .s SendPACSApplayi=$I(^DHCPETMPSendPACSApplay("SendPACSApplay",$J,ArcimID))
    .s ^DHCPETMPSendPACSApplay("SendPACSApplay",$J,ArcimID,SendPACSApplayi)=ArcimRegID_"^"_ flag
     q:mdataFlag=1 "插入申请单失败"
    /*
    s mListData=mListData_"!"_ListDataStr
    b ;mListData
    s mdata=""
    i ListDataStr'="" d
    .//w ##Class(web.DHCEMInterface).InsExaReqNo("")
    .;s mdata=##Class(web.DHCEMInterface).InsExaReqNo(mListData)
    .s mdata=##Class(web.DHCAPPInterface).InsExaReqNo(mListData)
    .b ;mdata
    i mdata'="" d
    .For i=1:1:$L(mdata,"@") d
    ..Set ArcimArry=$P(mdata,"@",i)
    ..Set ArcimRegID=$P(ArcimArry,"^",1)
    ..Set ArcimID=$P(ArcimArry,"^",2)
    ..Set flag=$P(ArcimArry,"^",3)
    ..;s ^DHCPETMPSendPACSApplay("SendPACSApplay",$J,ArcimID)=ArcimRegID_"^"_ flag
    ..s SendPACSApplayi=$I(^DHCPETMPSendPACSApplay("SendPACSApplay",$J,ArcimID))
    ..s ^DHCPETMPSendPACSApplay("SendPACSApplay",$J,ArcimID,SendPACSApplayi)=ArcimRegID_"^"_ flag

     */
    
    //added by xy 20170323 end
  	S PEItemInfos=""
  	k ^TempDHCPEInsertItems($J,crmRegId)
    s myChildId="0"
    f  s myChildId=$o(^DHCPEPreIADM(crmRegId,"ORDITEM",myChildId))  q:(myChildId="")||(SQLCODE'=0)  d
    .q:$p($g(^DHCPEPreIADM(crmRegId,"ORDITEM",myChildId)),"^",16)'=1    //判断是否有效
    .s PreItemID=crmRegId_"||"_myChildId
    .s OEID=""
    .s CRMOrderID=$O(^DHCPECRMO(0,"CRMORI",PreItemID,0))
    .i CRMOrderID'="" d
    ..s OEID=$P(^DHCPECRMO(CRMOrderID),"^",1)
    .q:OEID'=""
    .//插入医嘱套
    .s arcItemId=$p($g(^DHCPEPreIADM(crmRegId,"ORDITEM",myChildId)),"^",1)
    .s arRegArcID=""
    .;i $d(^DHCPETMPSendPACSApplay("SendPACSApplay",$J,arcItemId)) s arRegArcID=$P(^DHCPETMPSendPACSApplay("SendPACSApplay",$J,arcItemId),"^",1)
    .s SendPACSApplayi=$O(^DHCPETMPSendPACSApplay("SendPACSApplay",$J,arcItemId,""),-1)
    .i SendPACSApplayi'="" d
    ..s arRegArcID=$P(^DHCPETMPSendPACSApplay("SendPACSApplay",$J,arcItemId,SendPACSApplayi),"^",1)
    ..k ^DHCPETMPSendPACSApplay("SendPACSApplay",$J,arcItemId,SendPACSApplayi)

    .s crmordent=$p($g(^DHCPEPreIADM(crmRegId,"ORDITEM",myChildId)),"^",2)
    .s arcos1=""
    .if crmordent'=""  d
    ..//0926 renzwang   取标本名称错误
    ..s arcos1=##class(web.DHCPE.PEApp).GetArcSets(crmordent,arcItemId)
    .s OrdEntID="" 
    .i crmordent'="" d
    ..s OrdEntID=$G(^DHCPEDataEx("DHCPEPreIADM","OrdEnt",crmordent))
    ..q:OrdEntID'=""
    ..s ARCOS=$p($g(^DHCPEPreIADM(crmRegId,"ORDENT",$P(crmordent,"||",2))),"^",1)
    ..&SQL(Insert into SQLUser.OE_OrdEnt (OEORN_OEORD_ParRef,OEORN_OrdSets_DR) values (:ordid,:ARCOS))
    ..q:SQLCODE'=0
    ..s OrdEntID=%ROWID
    ..s ^DHCPEDataEx("DHCPEPreIADM","OrdEnt",crmordent)=OrdEntID
    .s:SQLCODE'=0 retStr="插入OE_OrdEnt错误"_SQLCODE
    .q:SQLCODE'=0
    .s AsCharged=$P(^DHCPEPreIADM(crmRegId,"ORDITEM",myChildId),"^",9)
    .s AddOrdItem=$P(^DHCPEPreIADM(crmRegId,"ORDITEM",myChildId),"^",5)
    .s FactAmount=$P(^DHCPEPreIADM(crmRegId,"ORDITEM",myChildId),"^",6)
    .s BillStatus="NP"
    .i AsCharged="Y"  d
    ..s BillStatus="OC"
    .s result= ##class(web.DHCPE.Cashier).CheckPayedCRMOrder(PreItemID)
    .i ((result="PP")||(result="P")) s BillStatus=result
    .s PayedFlag="TB"
    .i ((BillStatus="OC")||(BillStatus="P")||(BillStatus="PP")) s PayedFlag="P"
    .s InserItemUserID=$p($g(^DHCPEPreIADM(crmRegId,"ORDITEM",myChildId)),"^",11)
    .i InserItemUserID'="" d
    ..s DocUserID=InserItemUserID
    .e  d
    ..s DocUserID=userId
    .s Qty=$G(^DHCPEDataEx("DHCPEPreIOrdItem","Qty",PreItemID))
    .i +Qty=0 s Qty=1   
    .s locId=##class(web.DHCPE.PreItemList).GetRecLoc(3,PreItemID)
    .s ldefLocId=$p($g(^DHCPEPreIADM(crmRegId)),"^",26)
    .i locId="" s locId=..GetReceiveLoc(admId,arcItemId,ldefLocId)
    .i ""=$G(^DHCPESetting("DHCPE","DefaultPAADM",ldefLocId)) s ^DHCPESetting("DHCPE","DefaultPAADM",ldefLocId)=admId
    .if locId="" s locId=ldefLocId
    .s CurPrice=..GetCurItemPrice(PreItemID)
    .s CurPrice=CurPrice/Qty
    .s Spec=$G(^DHCPEDataEx("DHCPEPreIOrdItem","PERSON",PreItemID))
    .s Spec=$P(Spec,"^",1) 
    .S ARCItemCat=$P($G(^ARCIM(+arcItemId,1,1)),"^",10) //医嘱子分类
    .S ARCICOrdType=$P($G(^ARC("IC",ARCItemCat)),"^",7) 
    .s:(ARCICOrdType="L") hisItem=arcItemId_"^"_Qty_"^"_locId_"^"_CurPrice_"^"_Spec_"^^"_arcos1_"^"_SttDate_"^"_PayedFlag_"^"_OrdEntID_"^"_PreGInfo_"^"_arRegArcID_"^"_PreItemID
	.s:(ARCICOrdType'="L") hisItem=arcItemId_"^"_Qty_"^"_locId_"^"_CurPrice_"^"_Spec_"^^"_arcos1_"^"_+$H_"^"_PayedFlag_"^"_OrdEntID_"^"_PreGInfo_"^"_arRegArcID_"^"_PreItemID
	.//s hisItem=arcItemId_"^"_Qty_"^"_locId_"^"_CurPrice_"^"_Spec_"^^"_arcos1_"^"_SttDate_"^"_PayedFlag_"^"_OrdEntID_"^"_PreGInfo_"^"_arRegArcID_"^"_PreItemID
	.i PEItemInfos="" d
	..s PEItemInfos=hisItem
	.e  d
	..s PEItemInfos=PEItemInfos_$C(1)_hisItem
	.s ^TempDHCPEInsertItems($J,crmRegId,arcItemId,PreItemID)=arRegArcID_"^"_PayedFlag_"^"_CRMOrderID_"^"_BillStatus
	
	i PEItemInfos="" q ""
	b ;PEItemInfos
	s return=##class(web.DHCPE.PEApp).InsertOrdItem(admId, PEItemInfos, userId,locId, DocUserID)
	b ;return
	q:return'["^" "插入OE_OrdItem错误"_return
	s BillOEStr=""
	s OEOrdItems=$P(return,$c(1),2)
	s OEOrdItemLength=$L(OEOrdItems,"^")-1
	f OEOrdItemI=1:1:OEOrdItemLength{
		s OneOEOrdItem=$P(OEOrdItems,"^",OEOrdItemI)
		s hisOItemId=$P(OneOEOrdItem,"*",2)
		s ARCIMID=$P(OneOEOrdItem,"*",1)
		s PreItemID=$O(^TempDHCPEInsertItems($J,crmRegId,ARCIMID,""))
		i PreItemID'=""{
			s RelateInfo=$G(^TempDHCPEInsertItems($J,crmRegId,ARCIMID,PreItemID))
			k ^TempDHCPEInsertItems($J,crmRegId,ARCIMID,PreItemID)
			s arRegArcID=$P(RelateInfo,"^",1)
			i arRegArcID'=""{
				s ^DHCPEDataEx("DHCPESendPACSApplay","OEORDID",hisOItemId)=arRegArcID
				//登记时发送检查、检验申请(检查申请表dhc_appreparc)
				s ret=##Class(web.DHCAPPInterface).UpdAppRepItm(arRegArcID_"^^"_hisOItemId_"||1")
			}
			s PayedFlag=$P(RelateInfo,"^",2)
			Set:PayedFlag'="" $p(^OEORD(+hisOItemId,"I",$p(hisOItemId,"||",2),3),"^",5)=PayedFlag
			
			i (PayedFlag="P")&(BillOEStr'="") s BillOEStr=BillOEStr_$C(1)_hisOItemId  
			i (PayedFlag="P")&(BillOEStr="") s BillOEStr=hisOItemId
			
			s CRMOrderID=$P(RelateInfo,"^",3)
			s BillStatus=$P(RelateInfo,"^",4)
			i CRMOrderID'=""{
				&sql(UPDATE sqluser.dhc_pe_crmorder set crmo_oeori_dr=:hisOItemId,CRMO_BillStatus=:BillStatus
		 where crmo_rowid=:CRMOrderID)
			}else{
				&sql(insert into sqluser.dhc_pe_crmorder(crmo_crmori,crmo_oeori_dr,crmo_IADM_dr,CRMO_BillStatus)
		 values(:PreItemID, :hisOItemId, :iAdmId,:BillStatus))
			}
			s:SQLCODE'=0 retStr="操作DHC_PE_CrmOrder错误"_SQLCODE
			
		}
		q:SQLCODE'=0
	}
	
	k ^TempDHCPEInsertItems($J)

    q:SQLCODE'=0 retStr
    k ^DHCPETMPSendPACSApplay("SendPACSApplay",$J)
    s OEORDID=$O(^OEORD(0,"Adm",admId,0))
    q:OEORDID="" retStr
    s MaxSub=$O(^OEORD(OEORDID,"I",""),-1)
    
    


    /*
    //If (HosCode'="FX"){
        s CurrentNS=$ZNSPACE
        ZN MEDDATA
        Set AutoPresc=$$getconfignode^DHCDocConfig("PrescByAuto")
        if AutoPresc="1" Do presno3^aOET1(admId,userId,locId)
        e  d presno1^aOET1(admId,userId,locId)
        
        ZN CurrentNS
    //}
    */
     //s ADMLocID=$P($G(^PAADM(admId)),"^",4)
     //d ##class(DHCDoc.Interface.Inside.Service).GenPresno(admId,userId,ADMLocID_"^")
    ; ..InsertOtherItem(OEORDID,MaxSub,userId)
    ;d ..InsertOtherItem(OEORDID,MaxSub,userId,FeeFlag)
    d ..InsertOtherItemNew(OEORDID,userId,FeeFlag)
    s ADMLocID=$P($G(^PAADM(admId)),"^",4)
    //登记时发送病理申请(病理申请表DHC_AppPisMaster)
    //i ($g(^DHCPESetting("DHCPE","SendPisInterface"))="Y")&&($g(^DHCPESetting("DHCPE","SendPisFBWay"))="B")
    i ($g(^DHCPESetting("DHCPE","SendPisInterface",ADMLocID))="Y")&&($g(^DHCPESetting("DHCPE","SendPisFBWay",ADMLocID))="B")
    { 
        D ##class(web.DHCPE.CRM.RisGateway).GetPISPAADM(admId)
    }


    k ^DHCPEDataEx("DHCPEPreIOrdItem","InsertOtherFee",crmRegId,"N")
    
    //d ##class(web.DHCPE.ItemDetailRecord).InsertByAdm(admId,userId,MaxSub)
    
    q retStr
}

ClassMethod InsertOtherItemNew(OrderID, UserID, FeeFlag As %String = 1)
{
    //w ##class(web.DHCPE.TransAdmInfo).InsertOtherItemORDToCRM("32668","2","1")
    s Job=$J
    k ^TempDHCPEInsertOtherItem(Job)
    s PAADM=$P($G(^OEORD(OrderID)),"^",1)
    s CurLoc=$P($G(^PAADM(PAADM)),"^",4)
    s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
    s PIADM=$P($G(^DHCPEIADM(IADM)),"^",4)
    s VIPDesc=##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",PIADM)
    ;q:VIPDesc[("公务员") ""
    s BillStatus="NP"
    s AsCharged=$P($G(^DHCPEPreIADM(PIADM)),"^",9)
    s:AsCharged="Y" BillStatus="OC"
    s OrdSetFlag=0
    s ret=""
    s PreType="PRE"
    s sub=0

    f  s sub=$O(^OEORD(OrderID,"I",sub)) q:(sub="")  d
    .s OrderItemID=OrderID_"||"_sub
    .q:'$D(^OEORD(OrderID,"I",sub,1))
    .s Stat=$P($G(^OEORD(OrderID,"I",sub,1)),"^",13)
    .q:Stat="4"
    .s ArcItemID=$P($G(^OEORD(OrderID,"I",sub,1)),"^",2)
    .//q:ArcItemID=$G(^DHCPESetting("DHCPE","Group'sOEArcItemId"))
    .q:ArcItemID=$G(^DHCPESetting("DHCPE","Group'sOEArcItemId",CurLoc))
    .s ArcDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ArcItemID,CurLoc)
    .s SpecNo=$p($G(^OEORD(OrderID,"I",sub,3)),"^",20)
    .//判断下体检医嘱表是不是存在这条医嘱,存在退出
    .q:$D(^DHCPECRMO(0,"OEORI",OrderItemID))
    .;w !,OrderItemID
    .;根据标本号判断自费、公费
    .s LnkSpec=$P($G(^OEORD(OrderID,"I",sub,"DHC")),"^",22)
    .s:LnkSpec="" LnkSpec=$G(^OEORD(OrderID,"I",sub,"DEP",1))
    .s RisRelateItemID=$P($G(^OEORD(OrderID,"I",sub,11)),"^",39)
    .q:LnkSpec=""&&(RisRelateItemID="")
    .s OrderSub=""
    .s:LnkSpec'="" OrderSub=$O(^OEORD(0,"EpisNo",LnkSpec,OrderID,0))
    .s:RisRelateItemID'="" OrderSub=$p(RisRelateItemID,"||",2)
    .s OEOrdQty=$P($g(^OEORD(OrderID,"I",sub,1)),"^",12) //医嘱数量
    .i OrderSub'="" d  ;^OEORD(0,"EpisNo",18031402503,32668,3)
    ..s OldOrderID=OrderID_"||"_OrderSub
    ..s OldCrmOrderID=$O(^DHCPECRMO(0,"OEORI",OldOrderID,0))
    ..i OldCrmOrderID'="" d
    ...s OldCrmID=$P($G(^DHCPECRMO(OldCrmOrderID)),"^",2)
    ...s PreType=$P($G(^DHCPEPreIADM(+OldCrmID,"ORDITEM",$P(OldCrmID,"||",2))),"^",15)
    .;s ret=##class(web.DHCPE.PreItemList).IInsertItem(PIADM,"PERSON",PreType,ArcItemID,"",UserID,FeeFlag)
    .s ret=##class(web.DHCPE.PreItemList).IInsertItem(PIADM,"PERSON",PreType,ArcItemID,"",UserID,FeeFlag,"",OEOrdQty)
    .q:ret'=""
    .s PreSub=$O(^DHCPEPreIADM(PIADM,"ORDITEM",""),-1)
    .s PreItemID=PIADM_"||"_PreSub
    .&sql(insert into Sqluser.DHC_PE_CrmOrder (CRMO_OEORI_DR,CRMO_CRMORI,CRMO_IADM_DR,CRMO_BillStatus) values (:OrderItemID,:PreItemID,:IADM,:BillStatus))
    .i "0"=SQLCODE d
    ..s OEORDID=$p($g(^DHCPECRMO(%ROWID)),"^",1)
    ..i BillStatus="OC" d
    ...//附加医嘱考虑医嘱的状态
	...&SQL(update sqluser.OE_OrdItem set OEORI_Billed="P" where OEORI_RowID=:OEORDID)
    k ^TempDHCPEInsertOtherItem(Job,"Set")
    q ""
}

/// -------插入体检项目------------
/// [Previously private]
ClassMethod InsertItemsAZ(crmRegId, admId, iAdmId, userId, locId, MEDDATA)
{
    s crmExamItems=##class(web.DHCPE.CRM.Gateway).GetExamItemsByRegId(crmRegId)
    /// return: ***$C(1)ItemID^DepID^Quantity^crmOItemID$C(1)...
    s i=1  //, hisItemsStr=""
    s retStr=""
    //Set HosCode=$g(^DHCPESetting("DHCPE","HospitalCode"))
    Set HosCode=$g(^DHCPESetting("DHCPE","HospitalCode",locId))

    Set TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
    while(i<=$l(crmExamItems,$C(2))){
        s TLAItem=$p(crmExamItems,$C(2),i)
        s ^lisatest("1219","TLAItem",i)=TLAItem
        s m=1
        while(m<=$l(TLAItem,$C(1))){
            s crmItem=$p(TLAItem,$C(1),m)
            i (crmItem'=""){
                //hisItemSpec="ordItemID^qty^loc^price^Speciment^AdmReason"
                s crmOItemId=$p(crmItem,"^",4)          
                s objOItemMatch=##class(HandlerIAdm).GetItemMatch(crmOItemId,"CRM")
                if (objOItemMatch.%Id()=""){
                    s arcItemId=$p(crmItem,"^",1)
                    s crmitemid=$p(crmItem,"^",4)
                    s crmordent=$p($g(^DHCPEPreIADM($p(crmitemid,"||",1),"ORDITEM",$p(crmitemid,"||",2))),"^",2)
                    s arcos1=""
                    if crmordent'=""  d
                    .//0926 renzwang   取标本名称错误
                    .s arcos1=##class(web.DHCPE.PEApp).GetArcSets(crmordent,arcItemId)
                    .//s arcos1=$p($g(^DHCPEPreIADM($p(crmordent,"||",1),"ORDENT",$p(crmordent,"||",2))),"^",1)
                    .s ^DHCTemp("jdl","InsertOrdItem")="crmordent:"_crmordent_"  arcos:"_arcos1
                    //s arcos=$p($g(^DHCPEPreIADM($p(crmitemid,"||",1),"ORDITEM",$p(crmitemid,"||",2))),"^",3)
                    s locId=$g(locId)    //Add by MLH20070512
                
                    //070816 renzwang
                    //s locId=..GetReceiveLoc(admId,arcItemId,locId)
                    s ldefLocId=%session.Get("LOGON.CTLOCID")
                    s locId=##class(web.DHCPE.PreItemList).GetRecLoc(3,crmitemid)
                    i locId="" s locId=..GetReceiveLoc(admId,arcItemId,ldefLocId)
                    i ""=$G(^DHCPESetting("DHCPE","DefaultPAADM",ldefLocId)) s ^DHCPESetting("DHCPE","DefaultPAADM",ldefLocId)=admId
                
                    if locId="" s locId=$p(crmItem,"^",2)
                    s hisItem=arcItemId_"^1^"_locId_"^"_$p(crmItem,"^",2)_"^^^"_arcos1
                    s ret=0
                    if arcos1'="" s ^DHCTemp("jdl","InsertOrdItem","12")="##class(web.DHCPE.PEApp).InsertOrdItem("_admId_","_hisItem_","_userId_","_locId_","_userId_")"
                    s SPEC=""
                    i $G(crmOItemId)'="" d
                    .s SPEC=$G(^DHCPEDataEx("DHCPEPreIOrdItem","PERSON",crmOItemId))
                    .s SPEC=$p(SPEC,"^",1)
                    i hisItem'="" s hisItem=hisItem_"^"_SPEC
                    s ret=##class(web.DHCPE.PEApp).InsertOrdItem(admId, hisItem, userId,locId, userId)          
                    s hisOItemId=$p(ret,"^",2)
                    //b "before updateItemMatch"
                    s gatewayCRM=##class(web.DHCPE.CRM.Factory).GetGateway()
                    d gatewayCRM.updateItemMatch(crmOItemId,hisOItemId,iAdmId)              
                }
            }
            //Modified by MLH 20070608
            //s TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
            //i TrakVerison="MedTrak" d
            s CurrentNS=$ZNSPACE
            //友谊的，安贞的非TLA医嘱
            If ((HosCode="YY")||((HosCode="AZ")&(i=1))){
                ZN MEDDATA
                Do presno^aOET1(admId)  //Modified by MLH 20071218
                ZN CurrentNS
            }
            //////////////////////////
            s m=m+1
        }
        //非友谊的，安贞的TLA医嘱
        If ((HosCode'="YY")||(HosCode="AZ")&(i=2)){
            If (TrakVerison="MedTrak") {
             ZN MEDDATA 
             Do presno^aOET1(admId)  //Modified by MLH 20071218
             ZN CurrentNS   
            }
            If (TrakVerison="TrakCare"){
             s ^lisatest("20080220","presno1^aOET1")=admId_"^"_userId_"^"_locId
             ZN MEDDATA 
             Do presno1^aOET1(admId,userId,locId)  //Modified by MLH 20080220
             ZN CurrentNS   

            }
        }
        s i=i+1
    }
    q retStr
}

/// 保存挂号时间等基本信息
/// 插入DHC_PE_IADM表
/// [Previously private]
ClassMethod transBaseInfo(crmRegId, patNo, patId, iAdmId)
{
    s strErr=""     
    s regInfoCurrent=##class(web.DHCPE.CRM.Gateway).GetRegListByPatInf("REGID",crmRegId) //crmRegId--DHC_PE_PreIAdm的RowId  //MLH Modified by 2006-07-20
    // return: ***$C(1)preIAdmId_"^"_preIBId_"^"_PNo_"^"_PName_"^"_PSex_5"^"_PDOB_"^"_PGADMDR_"^"_PGTeamDR_"^"_BookDateBegin_"^"_BookDateEnd_10"^"_BookTime_"^"_PEDeskClerkDR_"^"_Status_"^"_AsCharged_"^"_AddOrdItem_15"^"_AddOrdItemLimit_"^"_AddOrdItemAmount_"^"_AddPhcItem_"^"_AddPhcItemLimit_"^"_AddPhcItemAmount_20"^"_IReportSend_"^"_DisChargedMode_"^"_Vip_"^"_DelayDate_"^"_Remark_25"^"_UpdateUserDR_"^"_UpdateDate$C(1)...
    
    //-----从CRM中找到需要的挂号信息------
    q:(regInfoCurrent="") "Error: 从CRM中根据Regid不能取到正确的挂号记录 in transBaseInfo"
    s iAdmId=$o(^DHCPEIADM(0,"CRMADM",crmRegId,""))
    s patNo=$P(regInfoCurrent,"^",3)  ///patCardId--PAPMINo //MLH Modified by 2006-07-20
    s patId=..patNo2Id(patNo)
    s iAdmDate=+$h
    s iAdmAsCharged="N"
    
    s CRMADM=$P(regInfoCurrent,"^",1)
    s AdmDate=+$h
    s AdmTime=$p($h,",",2)
    s AsCharged=$P(regInfoCurrent,"^",14)
    //s Status="ARRIVED"  Modified by MLH 20080418
    s Status="REGISTERED"
    s AddOrdItem=$P(regInfoCurrent,"^",15)
    s AddOrdItemLimit=$P(regInfoCurrent,"^",16)
    s AddOrdItemAmount=$P(regInfoCurrent,"^",17)
    s AddPhcItem=$P(regInfoCurrent,"^",18)
    s AddPhcItemLimit=$P(regInfoCurrent,"^",19)
    s AddPhcItemAmount=$P(regInfoCurrent,"^",20)
    s DisChargedMode=$P(regInfoCurrent,"^",22)
    s Remark=$P(regInfoCurrent,"^",25)
    
    i (+$P(regInfoCurrent,"^",14)=1) s iAdmAsCharged="Y"
    i iAdmId=""
    {
        &SQL(Insert Into sqluser.DHC_PE_IADM 
            (IADM_CRMADM,IADM_AdmDate,IADM_AdmTime,IADM_AsCharged,IADM_Status,IADM_AddOrdItem,IADM_AddOrdItemLimit,IADM_AddOrdItemAmount,IADM_AddPhcItem,IADM_AddPhcItemLimit,IADM_AddPhcItemAmount,IADM_DisChargedMode,IADM_Remark)
            Values (:CRMADM,:AdmDate,:AdmTime,:AsCharged,:Status,:AddOrdItem,:AddOrdItemLimit,:AddOrdItemAmount,:AddPhcItem,:AddPhcItemLimit,:AddPhcItemAmount,:DisChargedMode,:Remark)
            )
        if SQLCODE q "生成体检登记记录失败!       err:SQLCODE:"_SQLCODE
        s iAdmId=%ROWID
    }
    else
    {
        &SQL(update sqluser.DHC_PE_IADM set
            IADM_AdmDate=:AdmDate,IADM_AdmTime=:AdmTime,IADM_AsCharged=:AsCharged,
            IADM_Status=:Status,IADM_AddOrdItem=:AddOrdItem,IADM_AddOrdItemLimit=:AddOrdItemLimit,
            IADM_AddOrdItemAmount=:AddOrdItemAmount,IADM_AddPhcItem=:AddPhcItem,
            IADM_AddPhcItemLimit=:AddPhcItemLimit,IADM_AddPhcItemAmount=:AddPhcItemAmount,
            IADM_DisChargedMode=:DisChargedMode,IADM_Remark=:Remark Where IADM_RowId=:iAdmId)                       
        if SQLCODE q "生成体检登记记录失败!       err:SQLCODE:"_SQLCODE
    }
    q ""
}

/// ------插一条报告状态记录-----------
ClassMethod InsertReport(iAdmId)
{
    s reportId=$o(^DHCPERPT(0,"IADM",iAdmId,""))
    i reportId=""
    {
        &SQL(Insert into sqluser.dhc_pe_report
            (RPT_IADM_DR,RPT_Status)
            Values (:iAdmId,'NA'))
        if SQLCODE q SQLCODE
    }   
    q ""
}

/// 保存客人基本信息
/// 更新PA_Patmas表
/// [Previously private]
ClassMethod TranPatInfoNew(patNo, PEPATTYPE)
{
    //------从CRM中找到需要的客户信息--------
    s objPat=##class(web.DHCPE.CRM.Gateway).GetPatientInfoByNo(patNo)
    q:objPat="" "Error: 从CRM中不能取到正确的客户信息"
    
    s dob=objPat.DOB
    i dob'=""  s dob=$zd(dob,3)
    s patInfo=objPat.PatientNo_"^"_objPat.PatientName_"^"_objPat.Sex_"^"_
    dob_"^"_objPat.MobilePhone_"^^^"_objPat.PatientType_"^"_objPat.IDNo_"^^"_objPat.Corporator_"^"_objPat.Address
    
    s ret=##class(web.DHCPE.PEApp).CommitPatDetail("","",patInfo)   //Update表PA_PatMas和PA_Person
    q:(ret'="1") "ERROR:保存客人基本信息时出错 in TranPatInfo"
    
    s hisPatId=objPat.PatientId
    s hisMarital=objPat.Marital
    s hisEmail=objPat.Email
    s hisZip=objPat.Zip
    s hisBloodtype=objPat.BloodType
    s hisZipDr=""
    i $g(hisZip)'="" s hisZipDr=$o(^CT("ZIP",0,"Code",hisZip,""))
    
    &sql(update sqluser.pa_patmas set papmi_email=:hisEmail where papmi_rowId=:hisPatId)
    q:SQLCODE "Error:更新体检人基本信息失败!"
    &sql(update sqluser.pa_person set PAPER_Marital_DR=:hisMarital
            , PAPER_Zip_DR=:hisZipDr, PAPER_BloodType_DR=:hisBloodtype
         where paper_rowid=:hisPatId)
    q:SQLCODE "Error:更新体检人基本信息失败!"
    
    q ""
}

/// ------进行挂号------------（只对新登记有用，更新时不调用此程序）　
/// [Previously private]
ClassMethod Register(iAdmId, patId, locId, docId, userId, admId)
{
    s retStr=""
    i iAdmId="" q "没有传入体检登记号"
    s PIADM=$p($g(^DHCPEIADM(iAdmId)),"^",4)
    s ADMFeeType=""
    i PIADM'=""  s ADMFeeType=$G(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",PIADM))
    s admId=$p($g(^DHCPEIADM(iAdmId)),"^",1)
    if admId=""
    {
        s admId=##Class(web.DHCPE.PEApp).PEPAADMBroker(, , patId, locId, docId, "", userId,ADMFeeType)
        q:((admId="")||(admId=0)) "ERROR:An error occurs when registe！"
    }
    &SQL(Update sqluser.DHC_PE_IAdm set IADM_PAADM_DR=:admId 
        Where IADM_RowId=:iAdmId)
    if SQLCODE q "更新体检登记记录的PAAdmDR失败"
    q ""
}

/// crmRegIdNew--DHC_PE_PreIAdm的RowId  
/// w ##class(web.DHCPE.TransAdmInfo).main(99,3566)
ClassMethod main(crmRegIdNew As %String, hisUserId As %String = "", TransFlag As %String = 1, FeeFlag As %String = 1) As %String
{
    
    ;s retStr= ..mainEntrance(crmRegIdNew, hisUserId,TransFlag)
    s retStr= ..mainEntrance(crmRegIdNew, hisUserId,TransFlag,FeeFlag)
    d:retStr="" ##class(web.DHCPE.AdmRecordManager).Insert(crmRegIdNew,"P","Register",hisUserId,"") 
    d:retStr="" ##class(web.DHCPE.TransAdmInfo).UpdateAdmDate(crmRegIdNew,"")
    q retStr
}

/// Description: 主程序
/// Return: 正常："", 错误：错误信息，　
/// crmRegIdNew--DHC_PE_PreIAdm的RowId
ClassMethod mainEntrance(crmRegIdNew As %String, hisUserId As %String = "", TransFlag2 As %String = 1, FeeFlag As %String = 1) As %String
{
    s $ZT="myError"
    s strErr=""
    ;s ^wrzTransAdmInfo($H,1)=""
    s (patNo,patId,iAdmId,admId)=""
    s TransFlag=0
    s locId=$p($g(^DHCPEPreIADM(crmRegIdNew)),"^",26)
    s docId=$G(^DHCPESetting("DHCPE","PhyExamDrId",locId))
    s PEPATTYPE=$G(^DHCPESetting("DHCPE","PEPatType"))
    s MEDDATA=$G(^DHCPESetting("NAMESPACE","MEDDATA"))
    s HosCode=$g(^DHCPESetting("NAMESPACE","HospitalCode"))
    ///根据预约人员寻找对应的医护人员
    s InserItemUserID=$p($g(^DHCPEPreIADM(crmRegIdNew)),"^",21)
    i InserItemUserID'="" d
    .s IDOCID=$p($G(^SSU("SSUSR",InserItemUserID)),"^",14)
    .i IDOCID'="" d
    ..s CarPrvTpDR=$p($g(^CTPCP(IDOCID,1)),"^",4)
    ..s CTCPTType=""
    ..i CarPrvTpDR'="" s CTCPTType=$p($g(^CT("CPT",CarPrvTpDR)),"^",4)
    ..i CTCPTType="DOCTOR" S docId=IDOCID
    .//i IDOCID'="" d
    ..//s docId=IDOCID
    s iAdmId=$O(^DHCPEIADM(0,"CRMADM",crmRegIdNew,0))
    q:iAdmId'="" "Error:已经登记过!"
    s Status=$p($g(^DHCPEPreIADM(crmRegIdNew)),"^",8)
    q:Status'="PREREGED" "Error:还未完成预约"
    s PIBIID=$p($g(^DHCPEPreIADM(crmRegIdNew)),"^",1)
    s patNo=$p($g(^DHCPEPreIBI(PIBIID)),"^",1)
    s patId=..patNo2Id(patNo)
    s:TransFlag2=1 TransFlag=1
    TStart:TransFlag2=1
    s ADMFeeType=""
    s ADMFeeType=$G(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",crmRegIdNew))
    ;s ^wrzTransAdmInfo($H,2)=""
    //插入PAADM
    s admId=##Class(web.DHCPE.PEApp).PEPAADMBroker("","", patId, locId, docId, "", hisUserId,ADMFeeType)
    ;s ^wrzTransAdmInfo($H,3)=""
    s:((admId="")||(admId=0)) strErr="ERROR:An error occurs when registe！"
    if strErr'=""  goto myError
    //插入DHC_PE_IADM
    s PreGADM=$p($g(^DHCPEPreIADM(crmRegIdNew)),"^",2)
    s PreGTeamID=$p($g(^DHCPEPreIADM(crmRegIdNew)),"^",3)
    s GADM=""
    s GTeamID=""
    //是否有团体信息
    i PreGADM'="" d
    .s GADM=$O(^DHCPEGADM(0,"CRMGADM",PreGADM,""))
    .i GADM=""  d
    ..s strErr=##class(web.DHCPE.TransGrpInfo).mainNew(PreGADM,PreGADM,hisUserId,locId,"0")
    ..q:strErr'=""
    ..s GADM=$O(^DHCPEGADM(0,"CRMGADM",PreGADM,""))
    .q:GADM=""
    .s childsub=""
    .f  s childsub=$o(^DHCPEGADM(GADM,"Team",childsub)) q:(childsub="")||(GTeamID'="")  d
    ..i PreGTeamID=$p($g(^DHCPEGADM(GADM,"Team",childsub)),"^",2) d
    ...s GTeamID=GADM_"||"_childsub
    .s:GTeamID="" strErr="没有找到团体登记后的分组信息"
    if strErr'=""  goto myError
    ;s ^wrzTransAdmInfo($H,4)=""
    s regInfoCurrent=##class(web.DHCPE.CRM.Gateway).GetRegListByPatInf("REGID",crmRegIdNew)
    ;s ^wrzTransAdmInfo($H,5)=""
    s AdmDate=+$h
    s AdmTime=$p($h,",",2)
    s AsCharged=$P(regInfoCurrent,"^",14)
    //s Status="ARRIVED"  Modified by MLH 20080418
    s Status="REGISTERED"
    s AddOrdItem=$P(regInfoCurrent,"^",15)
    s AddOrdItemLimit=$P(regInfoCurrent,"^",16)
    s AddOrdItemAmount=$P(regInfoCurrent,"^",17)
    s AddPhcItem=$P(regInfoCurrent,"^",18)
    s AddPhcItemLimit=$P(regInfoCurrent,"^",19)
    s AddPhcItemAmount=$P(regInfoCurrent,"^",20)
    s DisChargedMode=$P(regInfoCurrent,"^",22)
    s Remark=$P(regInfoCurrent,"^",25)
    &SQL(Insert Into sqluser.DHC_PE_IADM 
            (IADM_CRMADM,IADM_PAADM_DR,IADM_GADM_DR,IADM_GTeam_DR,IADM_AdmDate,IADM_AdmTime,IADM_AsCharged,IADM_Status,IADM_AddOrdItem,IADM_AddOrdItemLimit,IADM_AddOrdItemAmount,IADM_AddPhcItem,IADM_AddPhcItemLimit,IADM_AddPhcItemAmount,IADM_DisChargedMode,IADM_Remark)
            Values (:crmRegIdNew,:admId,:GADM,:GTeamID,:AdmDate,:AdmTime,:AsCharged,:Status,:AddOrdItem,:AddOrdItemLimit,:AddOrdItemAmount,:AddPhcItem,:AddPhcItemLimit,:AddPhcItemAmount,:DisChargedMode,:Remark)
            )
    if SQLCODE s strErr="生成体检登记记录失败!err:SQLCODE:"_SQLCODE
    if strErr'=""  goto myError
    s iAdmId=%ROWID
    ;s ^wrzTransAdmInfo($H,6)=""
    //插入报告信息
    s strErr= ..InsertReport(iAdmId)  /////插入DHC_PE_Report表
    if strErr'=""  goto myError
    ;s ^wrzTransAdmInfo($H,7)=""
    //更新PreAudit
    
    ;&SQL(Update sqluser.DHC_PE_PreAudit set PA_GIADM=:iAdmId Where PA_ADMType='I' and PA_CRMADM=:crmRegIdNew)
    s PreAuditID=0
    f  s PreAuditID=$O(^DHCPEPreA(0,"CRMADM","I",crmRegIdNew,PreAuditID)) q:(PreAuditID="")||(SQLCODE'=0)  d
    .&SQL(Update sqluser.DHC_PE_PreAudit set PA_GIADM=:iAdmId Where PA_RowId=:PreAuditID)
    
    
    
    if SQLCODE<0 s strErr="更新预约审核记录失败"_SQLCODE
    if strErr'=""  goto myError
    //更新PreIADM表的状态
    &sql(update SQLUSER.DHC_PE_PreIADM set PIADM_Status='REGISTERED' where PIADM_RowId=:crmRegIdNew) 
    if SQLCODE<0 s strErr="更新预约记录失败"_SQLCODE
    if strErr'=""  goto myError
    ;s ^wrzTransAdmInfo($H,8)=""
    //插入医嘱信息
    If HosCode'="AZ" Do
    .;s strErr=..InsertItems(crmRegIdNew,admId,iAdmId,hisUserId,locId,MEDDATA)   /////插入医嘱表
    .s strErr=..InsertItems(crmRegIdNew,admId,iAdmId,hisUserId,locId,MEDDATA,FeeFlag)
    Else  Do
    .s strErr=..InsertItemsAZ(crmRegIdNew,admId,iAdmId,hisUserId,locId,MEDDATA)  /////插入医嘱表
    if strErr'=""  goto myError
    TCommit:TransFlag2=1
    q strErr
    
    
myError
    i TransFlag=1 TRollback
    q strErr_$ZERROR
}

/// Description: 主程序
/// Return: 正常："", 错误：错误信息，　
/// crmRegIdNew--DHC_PE_PreIAdm的RowId  //MLH Modified by 2006-07-20
ClassMethod mainEntranceNew(crmRegIdNew As %String, hisUserId As %String = "") As %String
{
    s strErr=""
    s (patNo,patId,iAdmId,admId)=""
    s:$d(%session) locId=%session.Get("LOGON.CTLOCID")
    s:'$d(%session) locId=572
    s docId=$G(^DHCPESetting("DHCPE","PhyExamDrId",locId))
    
    s PEPATTYPE=^DHCPESetting("DHCPE","PEPatType")
    s MEDDATA=^DHCPESetting("NAMESPACE","MEDDATA")
    Set HosCode=$g(^DHCPESetting("NAMESPACE","HospitalCode"))
    
    ///根据预约人员寻找对应的医护人员
    s InserItemUserID=$p($g(^DHCPEPreIADM(crmRegIdNew)),"^",21)
    i InserItemUserID'="" d
    .s IDOCID=$p($G(^SSU("SSUSR",InserItemUserID)),"^",14)
    .i IDOCID'="" d
    ..s docId=IDOCID
    
    
    s TransFlag=0
    s objIAdm=##class(HandlerIAdm).GetAdmByCrmAdm(crmRegIdNew) //用DHC_PE_PreIAdm的RowId得到DHC_PE_IADM表 //MLH Modified by 2006-07-20
    q:((objIAdm.%Id()'="")&&(objIAdm.IADMStatus'="PREREGED")) "Error:已经到达或尚未完成预约，操作失败!"
    s TransFlag=1
    TStart
    s $ZT="myError"
    s strErr=..transBaseInfo(crmRegIdNew,.patNo,.patId,.iAdmId)  //插入DHC_PE_IADM表
    if strErr'=""  goto myError
    q:iAdmId="" "Error:没有返回体检登记记录"
    s strErr= ..InsertReport(iAdmId)  /////插入DHC_PE_Report表
    if strErr'=""  goto myError
    &SQL(Update sqluser.DHC_PE_PreAudit set PA_GIADM=:iAdmId Where PA_ADMType='I' and PA_CRMADM=:crmRegIdNew)
    if SQLCODE<0 s strErr="更新预约审核记录失败"
    if strErr'=""  goto myError
    //TCommit
    
    //s TransFlag=0
    //b "before TranPatInfo"
    //s strErr=..TranPatInfo(patNo,PEPATTYPE) ////更新PA_PatMas和PA_Person表    
    //s strErr=..TranPatInfoNew(patNo,PEPATTYPE) ////更新PA_PatMas和PA_Person表 
    //if strErr'=""  goto myError
    //b "before Register"
    s strErr= ..Register(iAdmId,patId,locId,docId,hisUserId,.admId)   /////插入PA_ADM表
    if strErr'=""  goto myError
    //s ^DHCTemp("jdltest")="##class(web.DHCPE.TransAdmInfo).InsertItems("_crmRegIdNew_","_admId_","_iAdmId_","_hisUserId_","_locId_","_MEDDATA_")"
    
    If HosCode'="AZ" Do
    .s strErr=..InsertItems(crmRegIdNew,admId,iAdmId,hisUserId,locId,MEDDATA)    /////插入医嘱表
    Else  Do
    .s strErr=..InsertItemsAZ(crmRegIdNew,admId,iAdmId,hisUserId,locId,MEDDATA)  /////插入医嘱表
    //b ;InsertItems strErr
    //s rtn=##class(web.DHCPE.PEApp).CreatePrescNo(admId)
    if strErr'=""  goto myError
    
    s strErr=##class(web.DHCPE.CRM.GatewayDHC).InsertOEEnt(iAdmId)
    if strErr'=""  goto myError
    //Modified by MLH 20080418
    //s strErr=##class(web.DHCPE.CRM.Gateway).ExamStatusNotify("PERSON",crmRegIdNew, "ARRIVED","") 
    s strErr=##class(web.DHCPE.CRM.Gateway).ExamStatusNotify("PERSON",crmRegIdNew, "REGISTERED","") 
    i strErr="0" s strErr=""
    if strErr'=""  goto myError
    s strErr=##class(web.DHCPE.TransAdmInfo).CheckGAdmCreated(crmRegIdNew)
    i strErr="0" s strErr=""
    if strErr'=""  goto myError
    //d ##class(web.DHCPE.CRM.RisGateway).SendInfo("R","ADM",admId)  //add 20100307
    TCommit
    //b ;9
    q strErr
    
    
myError
    i TransFlag=1 TRollback
    q strErr_$ZERROR
}

/// 确认加项医嘱 Create by MLH 20080422
ClassMethod ConfirmAddOrdItem(PIADMRowID As %String, UserID As %String = "", FeeFlag As %String = 1) As %String
{
    Set $ZT="ConfirmErr"
    s TransFlag=0
    Set strErr=""
    Set (patNo,patId,iAdmId,admId)=""
    Set LocID=%session.Get("LOGON.CTLOCID")
    Set PEPATTYPE=$G(^DHCPESetting("DHCPE","PEPatType"))
    Set MEDDATA=$G(^DHCPESetting("NAMESPACE","MEDDATA"))
    Set HosCode=$g(^DHCPESetting("NAMESPACE","HospitalCode"))
    Set IAdmRowID=$o(^DHCPEIADM(0,"CRMADM",PIADMRowID,0))
    Quit:$g(IAdmRowID)="" ""
    Set ADMRowID=$p($g(^DHCPEIADM(IAdmRowID)),"^",1)
    Quit:$g(ADMRowID)="" ""
    ////20090417 Add by wrz
    
    s OEORDID=$O(^OEORD(0,"Adm",ADMRowID,0))
    s OldSub=0
    s:OEORDID'="" OldSub=$O(^OEORD(OEORDID,"I",""),-1)
    q:$g(OEORDID)="" ""
    s TransFlag=1
    TSTART
    If HosCode'="AZ" Do
    .;Set strErr=..InsertItems(PIADMRowID,ADMRowID,IAdmRowID,UserID,LocID,MEDDATA)
    .Set strErr=..InsertItems(PIADMRowID,ADMRowID,IAdmRowID,UserID,LocID,MEDDATA,FeeFlag)
    Else  Do
    .Set strErr=..InsertItemsAZ(PIADMRowID,ADMRowID,IAdmRowID,UserID,LocID,MEDDATA)
    ////End
    TROLLBACK:strErr'=""
    Quit:strErr'="" strErr
    /*
    Set strErr= ##class(web.DHCPE.OEOrdItem).TransOrder(IAdmRowID,"ARRIVED")
    TROLLBACK:strErr'=""
    Quit:strErr'="" strErr
    */
    TCOMMIT
    i ADMRowID'=""  d
    .d ##class(web.DHCPE.CRM.RisGateway).GetPAADM(ADMRowID,"ARRIVED") 
    .d ##class(web.DHCPE.ItemDetailRecord).InsertByAdm(ADMRowID,UserID,OldSub)
    Quit strErr
ConfirmErr
    TROLLBACK:TransFlag=1
    Quit "确认加项异常"_$ZERROR
}

/// 确认分组加项医嘱 Create by MLH 20080523
ClassMethod ConfirmAddOrdItemGT(PGTeamDR As %String, UserID As %String = "") As %String
{
    Set PIADMRowID=0
    For  Set PIADMRowID=$o(^DHCPEPreIADM(0,"PGTeam",PGTeamDR,PIADMRowID)) Quit:PIADMRowID=""  Do
    .;Do ..ConfirmAddOrdItem(PIADMRowID,UserID)
    .Do ..ConfirmAddOrdItem(PIADMRowID,UserID,0)
    d ##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(+PGTeamDR)
    Quit 0
}

/// 得到这个人所在的团体第一个人登记的时候是否视同收费
/// 看是否提示未视同收费   0  不提示  1  提示
ClassMethod GetGroupAsCharged(IADM)
{
    s Flag=0
    s GroupID=$P($G(^DHCPEPreIADM(IADM)),"^",2)
    q:GroupID="" Flag
    s Status=$p($G(^DHCPEPreGADM(GroupID)),"^",6)
    q:(Status="ARRIVED")||(Status="REGISTERED") Flag
    s AsCharged=$p($G(^DHCPEPreGADM(GroupID)),"^",7)
    q:AsCharged="Y" Flag
    q 1
}

/// -------检验条码打印自动到达，到达产生标本号------------
/// [Previously private]
/// d ##class(web.DHCPE.TransAdmInfo).IsArrivedInsertItems(3911)
ClassMethod IsArrivedInsertItems(admId, userId, locId)
{
 
    s IADM=$O(^DHCPEIADM(0,"PAADM",admId,0))
    q:IADM="" ""
    s Status=$p(^DHCPEIADM(IADM),"^",8)
    Q:Status'="ARRIVED" "" 
    //s MEDDATA=^DHCPESetting("NAMESPACE","MEDDATA") 
    //Set HosCode=$g(^DHCPESetting("DHCPE","HospitalCode"))
    s MEDDATA=^DHCPESetting("NAMESPACE","MEDDATA",locId) 
    Set HosCode=$g(^DHCPESetting("DHCPE","HospitalCode",locId))

    If (HosCode'="FX"){
        s CurrentNS=$ZNSPACE
        ZN MEDDATA  
        i (HosCode="SYYD")
        {
            Do presno1^aOET1(admId,userId,locId)    //Modified  By WRZ 2008-11-14
        }
        elseif(HosCode="AZ")||(HosCode="NB")||(HosCode="SHHS")
        {
            Do presno1^aOET1(admId)         
        }
        elseif(HosCode="ZSSY")
        {
            Do presno3^aOET1(admId,userId,locId)            
        }
        else
        {
            Do presno3^aOET1(admId,userId,locId)    //Modified  By WRZ 2008-11-14 
        } 
        ZN CurrentNS
    } 
    q
}

ClassMethod InsertOtherItem(OrderID, MaxSub, UserID, FeeFlag As %String = 1)
{
    //w ##class(web.DHCPE.TransAdmInfo).InsertOtherItem(3982360,2,1)
    s Job=$J
    k ^TempDHCPEInsertOtherItem(Job)
    s PAADM=$P(^OEORD(OrderID),"^",1)
    s CurLoc=$P($G(^PAADM(PAADM)),"^",4)
    s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
    s PIADM=$P(^DHCPEIADM(IADM),"^",4)
    s VIPDesc=##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",PIADM)
    ;q:VIPDesc[("公务员") ""
    s BillStatus="NP"
    s AsCharged=$P(^DHCPEPreIADM(PIADM),"^",9)
    s:AsCharged="Y" BillStatus="OC"
    s OrdSetFlag=0
    /*
    s sub=0
    f  s sub=$O(^DHCPEPreIADM(PIADM,"ORDENT",sub)) q:sub=""  d
    .s Stat=$P($G(^DHCPEPreIADM(PIADM,"ORDENT",sub)),"^",9)
    .q:Stat'="1"
    .s OrdSetFlag=1
    */
    
    ;q:(OrdSetFlag="1")&&(VIPDesc["VIP") ""
    ;b ;OrdSetFlag
    s ret=""
    s PreType="PRE"
    s sub=0
    ;f  s sub=$O(^OEORD(OrderID,"I",sub)) q:(sub="")||((OrdSetFlag=1)&&(VIPDesc["VIP"))  d
    f  s sub=$O(^OEORD(OrderID,"I",sub)) q:(sub="")  d
    .s OrderItemID=OrderID_"||"_sub
    .q:'$D(^OEORD(OrderID,"I",sub,1))
    .s Stat=$P(^OEORD(OrderID,"I",sub,1),"^",13)
    .q:Stat="4"
    .s ArcItemID=$P(^OEORD(OrderID,"I",sub,1),"^",2)
    .;q:ArcItemID=$G(^DHCPESetting("DHCPE","Group'sOEArcItemId"))
    .q:ArcItemID=$G(^DHCPESetting("DHCPE","Group'sOEArcItemId",CurLoc))
    .s ArcDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ArcItemID,CurLoc)
    .s SpecNo=$p($G(^OEORD(OrderID,"I",sub,3)),"^",20)
    .s CrmOrderID=$O(^DHCPECRMO(0,"OEORI",OrderItemID,0))
    .i CrmOrderID'="" d
    ..s CrmID=$P(^DHCPECRMO(CrmOrderID),"^",2)
    ..q:'$D(^DHCPEPreIADM(+CrmID,"ORDITEM",$P(CrmID,"||",2)))
    ..s CrmSetID=$P($G(^DHCPEPreIADM(+CrmID,"ORDITEM",$P(CrmID,"||",2))),"^",2)
    ..i CrmSetID'="" d
    ...s:SpecNo'="" ^TempDHCPEInsertOtherItem(Job,"Set",SpecNo)=""
    .i sub<(MaxSub+1) d  ;已经有采血费的不再插入标记,并看最后项目是公费还是自费
    ..s:((ArcDesc[("静脉抽血"))||(ArcDesc[("静脉采血"))) OrdSetFlag=1
    ..s OldOrderID=OrderID_"||"_sub
    ..s OldCrmOrderID=$O(^DHCPECRMO(0,"OEORI",OldOrderID,0))
    ..i OldCrmOrderID'="" d
    ...s OldCrmID=$P(^DHCPECRMO(OldCrmOrderID),"^",2)
    ...s PreType=$P(^DHCPEPreIADM(+OldCrmID,"ORDITEM",$P(OldCrmID,"||",2)),"^",15)
    .i sub>MaxSub d
    ..q:$D(^DHCPECRMO(0,"OEORI",OrderItemID))
    ..q:(((ArcDesc[("静脉抽血"))||(ArcDesc[("静脉采血")))&&(OrdSetFlag="1"))
    ..
    ..;根据标本号判断自费、公费
    ..s LnkSpec=$P($G(^OEORD(OrderID,"I",sub,"DHC")),"^",22)
    ..s:LnkSpec="" LnkSpec=$G(^OEORD(OrderID,"I",sub,"DEP",1))
    ..;q:LnkSpec=""
    ..b ;LnkSpec  ^TempDHCPEInsertOtherItem(Job,"Set",LnkSpec)
    ..;q:$D(^TempDHCPEInsertOtherItem(Job,"Set",LnkSpec))
    ..s OrderSub=""
    ..s:LnkSpec'="" OrderSub=$O(^OEORD(0,"EpisNo",LnkSpec,OrderID,0))
    ..i OrderSub'="" d
    ...s OldOrderID=OrderID_"||"_OrderSub
    ...s OldCrmOrderID=$O(^DHCPECRMO(0,"OEORI",OldOrderID,0))
    ...i OldCrmOrderID'="" d
    ....s OldCrmID=$P(^DHCPECRMO(OldCrmOrderID),"^",2)
    ....s PreType=$P(^DHCPEPreIADM(+OldCrmID,"ORDITEM",$P(OldCrmID,"||",2)),"^",15)
    ..;q:(VIPDesc[("公务员"))&&(PreType="PRE")
    ..;End 判断自费、公费
    ..;s ret=##class(web.DHCPE.PreItemList).IInsertItem(PIADM,"PERSON",PreType,ArcItemID,"",UserID)
    ..s ret=##class(web.DHCPE.PreItemList).IInsertItem(PIADM,"PERSON",PreType,ArcItemID,"",UserID,FeeFlag)
    ..q:ret'=""
    ..s PreSub=$O(^DHCPEPreIADM(PIADM,"ORDITEM",""),-1)
    ..s PreItemID=PIADM_"||"_PreSub
    ..&sql(insert into Sqluser.DHC_PE_CrmOrder (CRMO_OEORI_DR,CRMO_CRMORI,CRMO_IADM_DR,CRMO_BillStatus) values (:OrderItemID,:PreItemID,:IADM,:BillStatus))
    ..;s:((ArcDesc[("静脉抽血"))||(ArcDesc[("静脉采血"))) OrdSetFlag="1"
    .;e  d
    .;.s:((ArcDesc[("静脉抽血"))||(ArcDesc[("静脉采血"))) OrdSetFlag="1"
    k ^TempDHCPEInsertOtherItem(Job,"Set")
    q
}

ClassMethod GetCurItemPrice(crmitemid, CurSetAmount As %Float = 0)
{
    //w ##class(web.DHCPE.TransAdmInfo).GetCurItemPrice("752||1")
    //n (crmitemid,CurSetAmount)
    s Price=0
    q:crmitemid="" Price
    s Sub=$P(crmitemid,"||",2)
    s SetID=$P(^DHCPEPreIADM(+crmitemid,"ORDITEM",Sub),"^",2)
    s CurAmount=$P(^DHCPEPreIADM(+crmitemid,"ORDITEM",Sub),"^",14)
    i SetID="" d
    .s Price=##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(crmitemid,"","")
    .s Price=$j(Price,3,2)
    e  d
    .s SetAmount=$P(^DHCPEPreIADM(+crmitemid,"ORDENT",$P(SetID,"||",2)),"^",7)
    .s:CurSetAmount=0 CurSetAmount=..GetOrdSetsAmount(SetID)
    .
    .s SetFactAmount=##class(web.DHCPE.HandlerPreOrds).GetFactAmountByOrd(SetID,"","")
    .i CurSetAmount'=0 s Price=(CurAmount/CurSetAmount)*SetFactAmount
    s Price=$j(Price,3,2)
    q Price
}

ClassMethod GetOrdSetsAmount(SetID)
{
    //n (SetID)
    s Amount2=0
    s ItemSub=0
    f  s ItemSub=$O(^DHCPEPreIADM(0,"OrdEnt",SetID,+SetID,ItemSub)) q:ItemSub=""  d
    .s Stat=$P(^DHCPEPreIADM(+SetID,"ORDITEM",ItemSub),"^",16)
    .q:Stat'="1"
    .s CurAmount2=$P(^DHCPEPreIADM(+SetID,"ORDITEM",ItemSub),"^",14)
    .s Amount2=Amount2+CurAmount2
    q Amount2
}

// Type OrdSets,OrdItem

ClassMethod UpdateOrdItemPrice(PreItemID, Type)
{
    s $ZT="UpdatePriceErr"
    i Type="OrdItem" d
    .s SetAmount=0
    .d UpdateOEPrice(PreItemID,SetAmount)
    e  d
    .s SetAmount=..GetOrdSetsAmount(PreItemID)
    .s ItemSub=0
    .f  s ItemSub=$O(^DHCPEPreIADM(0,"OrdEnt",PreItemID,+PreItemID,ItemSub)) q:ItemSub=""  d
    ..s Stat=$P(^DHCPEPreIADM(+PreItemID,"ORDITEM",ItemSub),"^",16)
    ..q:Stat'="1"
    ..s CrmID=+PreItemID_"||"_ItemSub
    ..d UpdateOEPrice(CrmID,SetAmount)
    q 
UpdateOEPrice(ItemID,SetAmount)
    s CrmOrderID=$O(^DHCPECRMO(0,"CRMORI",ItemID,0))
    q:CrmOrderID=""
    s OEID=$P(^DHCPECRMO(CrmOrderID),"^",1)
    s Qty=$G(^DHCPEDataEx("DHCPEPreIOrdItem","Qty",ItemID))
    i +Qty=0 s Qty=1
    s Amount=..GetCurItemPrice(ItemID,SetAmount)
    s Price=Amount/Qty
    &SQL(update Sqluser.OE_OrdItem set OEORI_UnitCost=:Amount,OEORI_Price=:Price,OEORI_QtyPackUOM=:Qty where OEORI_RowId=:OEID)
    q
UpdatePriceErr
    q
}

// 修改体检日期时，判断是否可以预约的其它信息获取

ClassMethod GetOtherInfo(PreIADM)
{
    ;s val=##class(web.DHCPE.TransAdmInfo).GetOtherInfo
    ;VIPLevel, GIType
    s GIType="I"
    s GID=$P(^DHCPEPreIADM(PreIADM),"^",2)
    s:GID'="" GIType="G"
    s VIPLevel=$P(^DHCPEPreIADM(PreIADM),"^",18)
    q VIPLevel_"^"_GIType
}

/// w ##class(web.DHCPE.TransAdmInfo).UpdateAdmDate()
ClassMethod UpdateAdmDate(PreIADM, Date, DetailId = "")
{
	s ^tmpwgy("UpdateAdmDate")=$LB(PreIADM, Date, DetailId )
	s oldInfo="",newInfo=""  
    s Time=$P(Date,"^",2)
    s Date=$P(Date,"^",1)
    s Time = $P(Time,"-",1)
    s:Time="" Time=$P(^DHCPEPreIADM(PreIADM),"^",6)
    s:Time[(":") Time=##class(websys.Conversions).TimeHtmlToLogical(Time)
    i Date="" d
    .s Date=$P(^DHCPEPreIADM(PreIADM),"^",4)
    e  d
    .s Date=##class(websys.Conversions).DateHtmlToLogical(Date)
    
    s oldInfo = $ZD($P(^DHCPEPreIADM(PreIADM),"^",4),3)_" "_$ZT($P(^DHCPEPreIADM(PreIADM),"^",6))_" 排班ID："_$P(^DHCPEPreIADM(PreIADM),"^",30)
    s newInfo = $ZD(Date,3)_" "_$ZT(Time)_" 排班ID："_$CASE(DetailId="",1:$P(^DHCPEPreIADM(PreIADM),"^",30),:DetailId)
    s IADM=$O(^DHCPEIADM(0,"CRMADM",PreIADM,0))
    s SQLCODE=0
    TSTART
    i DetailId = ""
    {
    	&SQL(Update Sqluser.DHC_PE_PreIADM set PIADM_BookDateBegin=:Date,PIADM_BookDateEnd=:Date,PIADM_BookTime=:Time where PIADM_RowID=:PreIADM)
        i SQLCODE'=0
    	{
        	TROLLBACK
        	q "更新预约记录失败"_SQLCODE
    	}
    }else{
    	&SQL(Update Sqluser.DHC_PE_PreIADM set PIADM_BookDateBegin=:Date,PIADM_BookDateEnd=:Date,PIADM_BookTime=:Time,PIADM_DetailID=:DetailId where PIADM_RowID=:PreIADM)
    	 i SQLCODE'=0
    	{
        	TROLLBACK
        	q "更新预约记录失败"_SQLCODE
    	}else{
	    	//插入预约修改日期日志
	    	 d ##class(web.DHCPE.AdmRecordManager).Insert(PreIADM,"P","UpdateDate","","修改前："_oldInfo_"修改后："_newInfo)
    	}
    }
   
    i IADM'="" d
    .&SQL(Update Sqluser.DHC_PE_IADM set IADM_AdmDate=:Date,IADM_AdmTime=:Time where IADM_RowID=:IADM)
    .q:SQLCODE'=0
    .s PAADM=$P(^DHCPEIADM(IADM),"^",1)
    .&SQL(Update Sqluser.PA_Adm set PAADM_AdmDate=:Date where PAADM_RowID=:PAADM)
    i SQLCODE'=0
    {
        TROLLBACK
        q "更新就诊记录失败"
    }
    TCOMMIT
    q 0
}

}
