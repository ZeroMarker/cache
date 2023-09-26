Class web.DHCPE.Statistic.WorkStatistic Extends %RegisteredObject
{

/// Creator：      ln
/// CreateDate：   2019-09-09
/// Description:：获取体检科工作量数据
/// Table：       DHC_PE_AdmRecordManager  
/// Input：       BeginDate,EndDate,GroupDR,VIPLevel
/// Output：      UserDR:用户ID,UserCode:工号,User:姓名,Date:日期,Type:类型,Type:类型描述,Num:数量
/// Return：无        
/// Others：d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.WorkStatistic","ReceptionWorkStatistic","2021-07-01","2021-07-09","","","User","12187","","BREGISTER","152","164","13811") 
///         d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.WorkStatistic","ReceptionWorkStatistic","2020-03-24","2020-03-24","","","User","11849","","APREINSERT","304","164","11849")                       
Query ReceptionWorkStatistic(BeginDate As %Library.String = "", EndDate As %Library.String = "", GroupDR As %Library.String = "", VIPLevel As %Library.String = "", ShowFlag As %Library.String = "", OpUser As %Library.String = "", OpDate As %Library.String = "", OpType As %Library.String = "", CurLoc As %Library.String = "", CurGroup As %Library.String = "", CurUser As %Library.String = "") As websys.Query(ROWSPEC = "UserDR:%String,UserCode:%String,User:%String,Date:%String,Type:%String,TypeDesc:%String,Num:%Float,RegNo:%String,Name:%String,Sex:%String,Age:%String,VIPLevel:%String,Tel:%String,CheckDate:%String,GroupName:%String,GTName:%String,Position:%String,Now:%String") [ SqlProc ]
{
}

ClassMethod ReceptionWorkStatisticExecute(ByRef qHandle As %Binary, BeginDate As %String, EndDate As %String, GroupDR As %Library.String = "", VIPLevel As %Library.String = "", ShowFlag As %Library.String = "", OpUser As %Library.String = "", OpDate As %Library.String = "", OpType As %Library.String = "", CurLoc As %Library.String = "", CurGroup As %Library.String = "", CurUser As %Library.String = "") As %Status
{
 
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i ((BeginDate="")&(EndDate="")&(GroupDR=""))
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s Job=$j
 	k ^TempDHCPEPreStatistic(Job)
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	i EndDate'=""  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	i BeginDate="" s BeginDate=0
	i EndDate="" s EndDate=+$H
	
	s DocFlag=0
	s GroupDesc=$p(^SSU("SSGRP",CurGroup),"^",1)
	i GroupDesc="体检前台" d
	.s PEType="^PREInsert^Register^Arrived^PrintDJD^PrintBar^CANCELPE^RecPaper^SendAudit^ReportStatus^Complete^FetchReport^"
	e  i GroupDesc="体检采血" d
	.s PEType="^SpecCollect^"
	.s DocFlag=1
	e  i (GroupDesc="体检医生")||(GroupDesc="体检总检医生") d
	.s PEType="^GAuditStationS^GMainAuditStationS^"
	.s DocFlag=1
	e  d
	.s PEType="^PREInsert^Register^Arrived^PrintDJD^PrintBar^CANCELPE^RecPaper^SendAudit^ReportStatus^Complete^FetchReport^SpecCollect^GAuditStationS^GMainAuditStationS^"
	s PEType=$ZCVT(PEType,"U")
	
	s Date=BeginDate-1
	f  s Date=$o(^User.DHCPEAdmRecordManagerI("AdmDateTypeIndex",Date)) q:((Date="")||(Date>EndDate))  d
	.s Type=""
	.f  s Type=$o(^User.DHCPEAdmRecordManagerI("AdmDateTypeIndex",Date,Type)) q:(Type="")  d
	..q:PEType'[("^"_Type_"^")
	..s PreIADM=""
	..f  s PreIADM=$o(^User.DHCPEAdmRecordManagerI("AdmDateTypeIndex",Date,Type,PreIADM)) q:PreIADM=""  d
	...d SetReceptionWork
	
	if ('$d(^TempDHCPEPreStatistic(Job))) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
    if (ShowFlag="User")
    {
		s UserDR="",Num=0
		f  s UserDR=$o(^TempDHCPEPreStatistic(Job,"User",UserDR)) q:UserDR=""  d
		.s UserCode=$p($g(^SSU("SSUSR",UserDR)),"^",1)
		.s User=$p($g(^SSU("SSUSR",UserDR)),"^",2)
		.s Type=""
		.f  s Type=$o(^TempDHCPEPreStatistic(Job,"User",UserDR,Type)) q:Type=""  d
		..s TType=##class(web.DHCPE.AdmRecordManager).GetRecordTypeDesc(Type)
		..s:Type="LREPORTSTATUS" TType="打印报告"
		..i OpUser="" d
		...s Num=$G(^TempDHCPEPreStatistic(Job,"User",UserDR,Type))
		...s Info=""
		...d OutWorkStatisticInfo
		..e  d
		...s PIADM=""
		...f  s PIADM=$o(^TempDHCPEPreStatistic(Job,"User",UserDR,Type,PIADM)) q:PIADM=""  d
		....s Info=..GetBaseInfo("Pre",PIADM)
		....d OutWorkStatisticInfo
    }
    else 
    {
	    s Date=""
	    f  s Date=$o(^TempDHCPEPreStatistic(Job,"Date",Date)) q:Date=""  d
	    .s TDate=##class(websys.Conversions).DateLogicalToHtml(Date)
	    .q:(OpDate'="")&&(OpDate'=TDate)
	    .s Type=""
	    .f  s Type=$o(^TempDHCPEPreStatistic(Job,"Date",Date,Type)) q:Type=""  d
	    ..s TType=##class(web.DHCPE.AdmRecordManager).GetRecordTypeDesc(Type)
		..s:Type="LREPORTSTATUS" TType="打印报告"
		..i OpDate="" d
		...s Num=$G(^TempDHCPEPreStatistic(Job,"Date",Date,Type))
		...s Info=""
		...d OutWorkStatisticInfo
		..e  d
		...s PIADM=""
		...f  s PIADM=$o(^TempDHCPEPreStatistic(Job,"Date",Date,Type,PIADM)) q:PIADM=""  d
		....s Info=..GetBaseInfo("Pre",PIADM)
		....d OutWorkStatisticInfo
	}
	
	k ^TempDHCPEPreStatistic(Job)
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SetItemNumVariable
    // 医嘱名称
    s (UserCode,User,TDate,Type,TType,PIADM)=""
    q
SetReceptionWork
    q:PreIADM=""
    s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PreIADM,CurLoc) 
	q:LocFlag=1
	s PreGADM=$p(^DHCPEPreIADM(PreIADM),"^",2)
	q:(GroupDR="ALLI")&&(PreGADM'="")
	q:(GroupDR="ALLG")&&(PreGADM="")
	s GADM=""
	i PreGADM'="" d
	.s GADM=$o(^DHCPEGADM(0,"CRMGADM",PreGADM,0))
	q:((GroupDR'="")&&(GroupDR'="ALLI")&&(GroupDR'="ALLG")&&(GroupDR'=GADM))
	s VIP=$p(^DHCPEPreIADM(PreIADM),"^",18)
	q:((VIPLevel'="")&&(VIPLevel'=VIP))
	s id=""
	f  s id=$o(^User.DHCPEAdmRecordManagerI("AdmDateTypeIndex",Date,Type,PreIADM,id)) q:id=""  d
	.s UserDR=$LG(^User.DHCPEAdmRecordManagerD(id),7)
	.q:(DocFlag=1)&&(UserDR'=CurUser)
	.q:(OpUser'="")&&(OpUser'=UserDR)
	.s Remark=$LG(^User.DHCPEAdmRecordManagerD(id),4)
	.q:((Type="REPORTSTATUS")&&(Remark'="P"))
	.q:$D(^TempDHCPEPreStatistic(Job,"PreType",Type,PreIADM))
	.s ^TempDHCPEPreStatistic(Job,"PreType",Type,PreIADM)=""
	.s TType=..GetNewType(Type)
	.q:(OpType'="")&&(OpType'=TType)
	.s ^TempDHCPEPreStatistic(Job,"User",UserDR,TType)=$G(^TempDHCPEPreStatistic(Job,"User",UserDR,TType))+1
	.s ^TempDHCPEPreStatistic(Job,"User",UserDR,TType,PreIADM)=""
	.s ^TempDHCPEPreStatistic(Job,"Date",Date,TType)=$G(^TempDHCPEPreStatistic(Job,"Date",Date,TType))+1
	.s ^TempDHCPEPreStatistic(Job,"Date",Date,TType,PreIADM)=""
	
	q
OutWorkStatisticInfo
    set Now=##class(websys.Conversions).DateLogicalToHtml(+$H)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($H,",",2))
	set Data=$lb(UserDR,UserCode,User,TDate,Type,TType,Num,$p(Info,"^",1),$p(Info,"^",2),$p(Info,"^",3),$p(Info,"^",4),$p(Info,"^",5),$p(Info,"^",6),$p(Info,"^",7),$p(Info,"^",8),$p(Info,"^",9),$p(Info,"^",10),Now)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetNewType(Type)
{
	q:Type="PREINSERT" "APREINSERT"
	q:Type="REGISTER" "BREGISTER"
	q:Type="ARRIVED" "CARRIVED"
	q:Type="CANCELPE" "DCANCELPE"
	q:Type="PRINTDJD" "EPRINTDJD"
	q:Type="PRINTBAR" "FPRINTBAR"
	q:Type="SPECCOLLECT" "GSPECCOLLECT"
	q:Type="RECPAPER" "HRECPAPER"
	q:Type="SENDAUDIT" "ISENDAUDIT"
	q:Type="GAUDITSTATIONS" "JGAUDITSTATIONS"
	q:Type="GMAINAUDITSTATIONS" "KGMAINAUDITSTATIONS"
	q:Type="REPORTSTATUS" "LREPORTSTATUS"
	q:Type="COMPLETE" "MCOMPLETE"
	q:Type="FETCHREPORT" "NFETCHREPORT"
	q:Type="" ""
}

/// Creator：      ln
/// CreateDate：   2019-09-11
/// Description:：个人基本信息输出方法
/// Table：       DHC_PE_PreIBaseInfo 
/// Input：       Type:IADM  DHC_PE_IADM    PAADM     Pre   DHC_PE_PreIADM
/// Output：      RegNo_"^"_Name_"^"_Sex_"^"_Age_"^"_VIPLevel_"^"_Tel_"^"_CheckDate_"^"_GroupName_"^"_GTName_"^"_Position
/// Return：无  
/// Others：      w ##class(web.DHCPE.Statistic.WorkStatistic).GetBaseInfo("PAADM","2442")
ClassMethod GetBaseInfo(Type, id)
{
	q:id="" ""
	i Type="IADM" d
	.s PreIADM=$p(^DHCPEIADM(id),"^",4)
	e  i Type="PAADM" d
	.s IADM=$o(^DHCPEIADM(0,"PAADM",id,0))
	.s PreIADM=$p(^DHCPEIADM(IADM),"^",4)
	e  d
	.s PreIADM=id
	s PIBIDR=$P($G(^DHCPEPreIADM(PreIADM)),"^",1)
	s RegNo=$p(^DHCPEPreIBI(PIBIDR),"^",1)
	s Name=$p(^DHCPEPreIBI(PIBIDR),"^",2)
	s Sex="",Age=""
	s PIBISex=$p(^DHCPEPreIBI(PIBIDR),"^",3)
	s:(PIBISex'="") Sex=$p(^CT("SEX",PIBISex),"^",2)
	S PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
	s PatLoc=$P($G(^DHCPEPreIADM(PreIADM)),"^",26)
	s HospID=$p(^CTLOC(PatLoc),"^",22)
	//i PAPMIRowId'="" s Age=##class(web.DHCBillInterface).GetPapmiAge(PAPMIRowId)
	s Age=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PAPMIRowId,HospID,PatLoc)
	s PIADMVIP = ##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",PreIADM)
	s VIPLevel=$P(PIADMVIP,"^",2)
	s Tel=$p($g(^DHCPEPreIBI(PIBIDR)),"^",8) 
	s:Tel="" Tel=$p($g(^DHCPEPreIBI(PIBIDR)),"^",6)
	s:Tel="" Tel=$p($g(^DHCPEPreIBI(PIBIDR)),"^",7) 
	s CheckDate=##class(web.DHCPE.PreIADM).GetCheckDate(PreIADM,"PreADM")
	s Position=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PreIADM)
	s GADMDR=$P($G(^DHCPEPreIADM(PreIADM)),"^",2)
	s GroupName="",GTName=""
	i GADMDR'="" d
	.s PGBIDR=$p($g(^DHCPEPreGADM(GADMDR)),"^",1)
	.s GroupName=$p($g(^DHCPEPreGBI(PGBIDR)),"^",2)
	.s GTeamDR=$P($G(^DHCPEPreIADM(PreIADM)),"^",3)
	.s GTName=$P($g(^DHCPEPreGADM(+GTeamDR,"Team",$p(GTeamDR,"||",2))),"^",1)
	q RegNo_"^"_Name_"^"_Sex_"^"_Age_"^"_VIPLevel_"^"_Tel_"^"_CheckDate_"^"_GroupName_"^"_GTName_"^"_Position
}

/// Creator：      ln
/// CreateDate：   2020-03-21
/// Description:：体检医嘱数量查询
/// Table：       DHC_PE_ItemDetailRecord  
/// Input：       BeginDate,EndDate,ARCIM
/// Output：      ItemID:医嘱ID,ArcItemDesc:医嘱名称,Num:数量,PreNum:预约,ADDNum:加项,VNum:核实,ENum:执行,DNum:停止
/// Return：无        
/// Others：d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.WorkStatistic","ItemDetailStatistic","2020-04-01","2020-04-01","11548||1","","","","304")                       
Query ItemDetailStatistic(BeginDate As %Library.String = "", EndDate As %Library.String = "", ARCIM As %Library.String = "", ItmMastDR As %Library.String = "", PType As %Library.String = "", ItemStat As %Library.String = "", CurLoc As %Library.String = "") As websys.Query(ROWSPEC = "ItemID:%String,ArcItemDesc:%String,Num:%Float,PreNum:%Float,ADDNum:%Float,VNum:%Float,ENum:%Float,DNum:%Float,RefuseNum:%Float,RangeDNum:%Float,RegNo:%String,Name:%String,Sex:%String,Age:%String,VIPLevel:%String,Tel:%String,GroupName:%String,Now:%String") [ SqlProc ]
{
}

ClassMethod ItemDetailStatisticExecute(ByRef qHandle As %Binary, BeginDate As %String, EndDate As %String, ARCIM As %Library.String = "", ItmMastDR As %Library.String = "", PType As %Library.String = "", ItemStat As %Library.String = "", CurLoc As %Library.String = "") As %Status
{
 
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i ((BeginDate="")&(EndDate=""))
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s Job=$j
 	k ^TempDHCPEItemDetail(Job)
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	i EndDate'=""  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	i BeginDate="" s BeginDate=+$H
	i EndDate="" s EndDate=+$H
	
	s Date=BeginDate-1
	f  s Date=$O(^User.DHCPEItemDetailRecordI("IDRDateIndex",Date)) q:(Date="")||(Date>EndDate)  d
 	.s ID=""
 	.f  s ID=$O(^User.DHCPEItemDetailRecordI("IDRDateIndex",Date,ID)) q:(ID="")  d
 	..d SetItemDetailInfo
 	
 	if ('$d(^TempDHCPEItemDetail(Job))) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
 	
 	if (ItmMastDR="")
 	{
	 	s ItemID=""
	 	f  s ItemID=$o(^TempDHCPEItemDetail(Job,"Item",ItemID)) q:ItemID=""  d
	 	.d SetItemNumVariable	
	 	.s ArcItemDesc=$P(^ARCIM(+ItemID,1,1),"^",2)
	 	.s Num=$G(^TempDHCPEItemDetail(Job,"Item",ItemID))
	 	.s PreNum=$G(^TempDHCPEItemDetail(Job,"Item",ItemID,"PreType","PRE"))
	 	.s ADDNum=$G(^TempDHCPEItemDetail(Job,"Item",ItemID,"PreType","ADD"))
	 	.s VNum=$G(^TempDHCPEItemDetail(Job,"Item",ItemID,"ItemStat","1"))
	 	.s ENum=$G(^TempDHCPEItemDetail(Job,"Item",ItemID,"ItemStat","6"))
	 	.s DNum=$G(^TempDHCPEItemDetail(Job,"Item",ItemID,"ItemStat","4"))
	 	.s RefuseNum=$G(^TempDHCPEItemDetail(Job,"Item",ItemID,"ItemStat","Refuse"))
	 	.s RangeDNum=$G(^TempDHCPEItemDetail(Job,"Item",ItemID,"ItemStat","DeleteItem"))
	 	.s Info=""
		.d OutItemDetailInfo
 	}	
 	else
 	{
	 	s ItemID=ItmMastDR
	 	d SetItemNumVariable
	 	s ArcItemDesc=$P(^ARCIM(+ItemID,1,1),"^",2)
	 	s OEORD=""
	 	f  s OEORD=$o(^TempDHCPEItemDetail(Job,"Item",ItemID,"OEORD",OEORD)) q:OEORD=""  d
	 	.s PAADM=$p(^OEORD(+OEORD),"^",1)
	 	.s Info=..GetBaseInfo("PAADM",PAADM)
	 	.d OutItemDetailInfo
 	}
 	
 	k ^TempDHCPEItemDetail(Job)
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SetItemNumVariable
    // 医嘱名称
    s ArcItemDesc=""
    // 数量：医嘱总数、预约、加项、核实、执行、停止、放弃、本时间段内停止
    s (Num,PreNum,ADDNum,VNum,ENum,DNum,RefuseNum,RangeDNum)=0
    // 明细信息：
    s (PAADM,RegNo,Name,Sex,Age,VIP,Tel,GroupName)=""
    q
SetItemDetailInfo    
    s OEORI=$LG(^User.DHCPEItemDetailRecordD(ID),2)
 	s Type=$LG(^User.DHCPEItemDetailRecordD(ID),3)
 	q:$D(^TempDHCPEItemDetail(Job,"ReItem",OEORI,Type))
 	s ^TempDHCPEItemDetail(Job,"ReItem",OEORI,Type)=""
 	q:(ItemStat="DeleteItem")&&(Type="A")
 	s OEORD=+OEORI
 	s OESub=$P(OEORI,"||",2)
 	s ArcItemID=$P(^OEORD(OEORD,"I",OESub,1),"^",2)
 	q:(ARCIM'="")&&(ARCIM'=ArcItemID)
 	q:(ItmMastDR'="")&&(ItmMastDR'=ArcItemID)
 	s OrderDepart=$P(^OEORD(OEORD,"I",OESub,1),"^",3)
 	q:(CurLoc'="")&&(CurLoc'=OrderDepart)
 	s CrmOrderID=$O(^DHCPECRMO(0,"OEORI",OEORI,0))
 	q:CrmOrderID=""
 	s PreItemID=$P(^DHCPECRMO(CrmOrderID),"^",2)
 	s PreType=$P(^DHCPEPreIADM(+PreItemID,"ORDITEM",$P(PreItemID,"||",2)),"^",15)
 	q:(PType'="")&&(PType'=PreType)
 	s ItemStatDR=$P(^OEORD(OEORD,"I",OESub,1),"^",13)
 	q:('$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORI))&&(ItemStat="Refuse"))
 	q:(ItemStat'="")&&(ItemStat'=ItemStatDR)&&(ItemStat'="Refuse")&&(ItemStat'="DeleteItem")
 	i Type="A" d
 	.s ^TempDHCPEItemDetail(Job,"Item",ArcItemID)=$G(^TempDHCPEItemDetail(Job,"Item",ArcItemID))+1
 	.s ^TempDHCPEItemDetail(Job,"Item",ArcItemID,"PreType",PreType)=$G(^TempDHCPEItemDetail(Job,"Item",ArcItemID,"PreType",PreType))+1
 	.i $D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORI)) d
 	..s ^TempDHCPEItemDetail(Job,"Item",ArcItemID,"ItemStat","Refuse")=$G(^TempDHCPEItemDetail(Job,"Item",ArcItemID,"ItemStat","Refuse"))+1
    .e  d
 	..s ^TempDHCPEItemDetail(Job,"Item",ArcItemID,"ItemStat",ItemStatDR)=$G(^TempDHCPEItemDetail(Job,"Item",ArcItemID,"ItemStat",ItemStatDR))+1
 	e  d
 	.s ^TempDHCPEItemDetail(Job,"Item",ArcItemID,"ItemStat","DeleteItem")=$G(^TempDHCPEItemDetail(Job,"Item",ArcItemID,"ItemStat","DeleteItem"))+1
 	q:(ItemStat'="DeleteItem")&&(Type="D")
 	s ^TempDHCPEItemDetail(Job,"Item",ArcItemID,"OEORD",OEORI)=""
    
    q
OutItemDetailInfo
    set Now=##class(websys.Conversions).DateLogicalToHtml(+$H)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($H,",",2))
	set Data=$lb(ItemID,ArcItemDesc,Num,PreNum,ADDNum,VNum,ENum,DNum,RefuseNum,RangeDNum,$p(Info,"^",1),$p(Info,"^",2),$p(Info,"^",3),$p(Info,"^",4),$p(Info,"^",5),$p(Info,"^",6),$p(Info,"^",8),Now)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator：      ln
/// CreateDate：   2020-03-23
/// Description:：体检套餐数量查询
/// Table：       DHC_PE_PreIOrdEnt,^DHCPEDataEx("DHCPEPreIADM","PreOrdSet",PreIADM) 
/// Input：       BeginDate,EndDate
/// Output：      SetID:套餐ID,SetsDesc:套餐名称,Num:数量
/// Return：无        
/// Others：d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.WorkStatistic","SetDetailStatistic","2020-03-01","2020-03-24","","304")  
Query SetDetailStatistic(BeginDate As %Library.String = "", EndDate As %Library.String = "", OrdSetID As %Library.String = "", CurLoc As %Library.String = "") As websys.Query(ROWSPEC = "SetID:%String,SetsDesc:%String,Num:%Float,RegNo:%String,Name:%String,Sex:%String,Age:%String,VIPLevel:%String,Tel:%String,GroupName:%String,Now:%String") [ SqlProc ]
{
}

ClassMethod SetDetailStatisticExecute(ByRef qHandle As %Binary, BeginDate As %String, EndDate As %String, OrdSetID As %Library.String = "", CurLoc As %Library.String = "") As %Status
{
 
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i ((BeginDate="")&(EndDate=""))
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s Job=$j
 	k ^TempDHCPESetDetail(Job)
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	i EndDate'=""  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	i BeginDate="" s BeginDate=+$H
	i EndDate="" s EndDate=+$H
	
	s Date=BeginDate-1
	f  s Date=$o(^User.DHCPEAdmRecordManagerI("AdmDateTypeIndex",Date)) q:((Date="")||(Date>EndDate))  d
	.s PreIADM=""
	.f  s PreIADM=$o(^User.DHCPEAdmRecordManagerI("AdmDateTypeIndex",Date,"ARRIVED",PreIADM)) q:PreIADM=""  d
	..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PreIADM,CurLoc) 
	..q:LocFlag=1
	..s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
	..q:(Status="CANCELPE")
	..d GetOneOrdEnt
	
	if ('$d(^TempDHCPESetDetail(Job))) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
		
 	s SetID=""
 	f  s SetID=$o(^TempDHCPESetDetail(Job,"Set",SetID)) q:SetID=""  d
 	.s Num=$G(^TempDHCPESetDetail(Job,"Set",SetID))
 	.s ^TempDHCPESetDetail(Job,"SetNum",Num,SetID)=""
 	
 	s Num=""
 	f  s Num=$o(^TempDHCPESetDetail(Job,"SetNum",Num),-1) q:Num=""  d
 	.s SetID=""
 	.f  s SetID=$o(^TempDHCPESetDetail(Job,"SetNum",Num,SetID)) q:SetID=""  d
 	..s SetsDesc=$p(^ARCOS(SetID),"^",2)
 	..s (PAADM,RegNo,Name,Sex,Age,VIP,Tel,GroupName,Info)=""
 	..i OrdSetID="" d
	...d OutSetDetail
	..e  d
	...s PIADM=""
	...f  s PIADM=$o(^TempDHCPESetDetail(Job,"Set",SetID,PIADM)) q:PIADM=""  d
	....s Info=..GetBaseInfo("Pre",PIADM)
	....d OutSetDetail
	
	k ^TempDHCPESetDetail(Job)
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetOneOrdEnt
    s PIADMchildsub=0                     //获取套餐名
    f  s PIADMchildsub=$o(^DHCPEPreIADM(PreIADM,"ORDENT",PIADMchildsub))  Q:PIADMchildsub=""  d 
    .s PIOEItemStat=$p($g(^DHCPEPreIADM(PreIADM,"ORDENT",PIADMchildsub)),"^",9)
    .i PIOEItemStat=1   d
    ..s PIOEOrderSetsDR=$p(^DHCPEPreIADM(PreIADM,"ORDENT",PIADMchildsub),"^",1)
    ..q:(OrdSetID'="")&&(OrdSetID'=PIOEOrderSetsDR)
    ..s ARCOSOrdSubCatDR=$p($G(^ARCOS(PIOEOrderSetsDR)),"^",9)
    ..q:ARCOSOrdSubCatDR=""
    ..s OrcatDesc=$p($G(^ARC("IC",ARCOSOrdSubCatDR)),"^",2)
    ..q:OrcatDesc'="体检医嘱套"
    ..q:$D(^TempDHCPESetDetail(Job,"Set",PIOEOrderSetsDR,PreIADM))
    ..s ^TempDHCPESetDetail(Job,"Set",PIOEOrderSetsDR,PreIADM)=""
    ..s ^TempDHCPESetDetail(Job,"Set",PIOEOrderSetsDR)=$G(^TempDHCPESetDetail(Job,"Set",PIOEOrderSetsDR))+1
    
	s OrderSets=$G(^DHCPEDataEx("DHCPEPreIADM","PreOrdSet",PreIADM))
	q:(OrdSetID'="")&&(OrdSetID'=OrderSets)
    s i=$l(OrderSets,"^")
    s j=1
    while (j<=i){
    	s PIOEOrderSetsDR=$p(OrderSets,"^",j)
    	s j=j+1
    	continue:PIOEOrderSetsDR=""
    	s ARCOSOrdSubCatDR=$p($G(^ARCOS(PIOEOrderSetsDR)),"^",9)
    	continue:ARCOSOrdSubCatDR=""
    	s OrcatDesc=$p($G(^ARC("IC",ARCOSOrdSubCatDR)),"^",2)
    	continue:OrcatDesc'="体检医嘱套"
    	q:$D(^TempDHCPESetDetail(Job,"Set",PIOEOrderSetsDR,PreIADM))
        s ^TempDHCPESetDetail(Job,"Set",PIOEOrderSetsDR,PreIADM)=""
        s ^TempDHCPESetDetail(Job,"Set",PIOEOrderSetsDR)=$G(^TempDHCPESetDetail(Job,"Set",PIOEOrderSetsDR))+1
    }
    q
OutSetDetail
    set Now=##class(websys.Conversions).DateLogicalToHtml(+$H)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($H,",",2))
	set Data=$lb(SetID,SetsDesc,Num,$p(Info,"^",1),$p(Info,"^",2),$p(Info,"^",3),$p(Info,"^",4),$p(Info,"^",5),$p(Info,"^",6),$p(Info,"^",8),Now)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator：      ln
/// CreateDate：   2020-03-20
/// Description:：体检医生工作量查询
/// Table：       DHC_PE_Result
/// Input：      
/// Output：      
/// Return：无        
/// Others：d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.WorkStatistic","DoctorWorkStatistic","2021-09-06","2021-09-06","","","","","","","Item","13811","3650||1","I","152","164","13811")                       
Query DoctorWorkStatistic(BeginDate As %Library.String = "", EndDate As %Library.String = "", DocNo As %Library.String = "", DocDR As %Library.String = "", GroupDR As %Library.String = "", StationDR As %Library.String = "", OEItem As %Library.String = "", VIPLevel As %Library.String = "", ShowFlag As %Library.String = "", User As %Library.String = "", ItmMastDR As %Library.String = "", PerType As %Library.String = "", CurLoc As %Library.String = "", CurGroup As %Library.String = "", CurUser As %Library.String = "") As websys.Query(ROWSPEC = "UserID:%String,SSUSRInitials:%String,UserName:%String,Item:%String,ItmMastDesc:%String,INum:%Float,GNum:%Float,PAADM:%String,RegNo:%String,Name:%String,Sex:%String,Age:%String,VIPLevel:%String,Tel:%String,GroupName:%String,Date:%String,Now:%String") [ SqlProc ]
{
}

ClassMethod DoctorWorkStatisticExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "", DocNo As %Library.String = "", DocDR As %Library.String = "", GroupDR As %Library.String = "", StationDR As %Library.String = "", OEItem As %Library.String = "", VIPLevel As %Library.String = "", ShowFlag As %Library.String = "", User As %Library.String = "", ItmMastDR As %Library.String = "", PerType As %Library.String = "", CurLoc As %Library.String = "", CurGroup As %Library.String = "", CurUser As %Library.String = "") As %Status
{
 
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i ((BeginDate="")&(EndDate=""))
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s Job=$j
 	k ^TempDHCPEDoctorWork(Job)
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	i EndDate'=""  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	i BeginDate="" s BeginDate=$H
	i EndDate="" s EndDate=$H
	
	s DocFlag=0
	s GroupDesc=$p(^SSU("SSGRP",CurGroup),"^",1)
	i GroupDesc="体检医生" s DocFlag=1
	
	s AdmDate=BeginDate-1
	f  s AdmDate=$o(^DHCPERLT(0,"DateUser",AdmDate)) q:(AdmDate="")||(AdmDate>EndDate)  d
	.s UserID=0
	.f  s UserID=$o(^DHCPERLT(0,"DateUser",AdmDate,UserID)) q:(UserID="")  d
	..q:(User'="")&&(User'=UserID)
	..q:(DocFlag=1)&&(CurUser'=UserID)
	..s OEOrdItem=""
	..f  s OEOrdItem=$o(^DHCPERLT(0,"DateUser",AdmDate,UserID,OEOrdItem)) q:(OEOrdItem="")  d
	...d GetDocWorkInfo
	
	if ('$d(^TempDHCPEDoctorWork(Job))) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s UserID=""
	f  s UserID=$o(^TempDHCPEDoctorWork(Job,"Doc",UserID)) q:UserID=""  d
	.d SetDocWorkVariable
	.s UserName=$p($g(^SSU("SSUSR",UserID)),"^",2)
	.s SSUSRInitials=$p($g(^SSU("SSUSR",UserID)),"^",1)
	.i ShowFlag="Item" d
	..s Item=""
	..f  s Item=$o(^TempDHCPEDoctorWork(Job,"Doc",UserID,"ItemInfo",Item)) q:Item=""  d
	...s ItmMastDesc=$p(^ARCIM(+Item,$p(Item,"||",2),1),"^",2)
	...i User="" d
	....s INum=$G(^TempDHCPEDoctorWork(Job,"Doc",UserID,"ItemInfo",Item,"I"))
	....s GNum=$G(^TempDHCPEDoctorWork(Job,"Doc",UserID,"ItemInfo",Item,"G"))
	....s Info=""
	....d OutDocWorkInfo
	...e  d
	....s PType=""
	....f  s PType=$o(^TempDHCPEDoctorWork(Job,"Doc",UserID,"ItemInfo",Item,PType)) q:PType=""  d
	.....s PAADM="" 
	.....f  s PAADM=$o(^TempDHCPEDoctorWork(Job,"Doc",UserID,"ItemInfo",Item,PType,PAADM)) q:PAADM=""  d
	......s Info=..GetBaseInfo("PAADM",PAADM)
	......s OEORD=""
	......f  s OEORD=$o(^TempDHCPEDoctorWork(Job,"Doc",UserID,"ItemInfo",Item,PType,PAADM,OEORD)) q:OEORD=""  d
	.......s Date=$G(^TempDHCPEDoctorWork(Job,"Doc",UserID,"ItemInfo",Item,PType,PAADM,OEORD))
	.......s Date=##class(websys.Conversions).DateLogicalToHtml(Date)
    .......d OutDocWorkInfo
    .e  d
    ..i User="" d
    ...s INum=$G(^TempDHCPEDoctorWork(Job,"Doc",UserID,"PerInfo","I"))
    ...s GNum=$G(^TempDHCPEDoctorWork(Job,"Doc",UserID,"PerInfo","G"))
    ...s Info=""
    ...d OutDocWorkInfo
    ..e  d
    ...s PType=""
    ...f  s PType=$o(^TempDHCPEDoctorWork(Job,"Doc",UserID,"PerInfo",PType)) q:PType=""  d
    ....s PAADM=""
    ....f  s PAADM=$o(^TempDHCPEDoctorWork(Job,"Doc",UserID,"PerInfo",PType,PAADM)) q:PAADM=""  d
    .....s Info=..GetBaseInfo("PAADM",PAADM)
    .....s ItmMastDesc=""
    .....s Item=""
    .....f  s Item=$o(^TempDHCPEDoctorWork(Job,"Doc",UserID,"PerInfo",PType,PAADM,Item)) q:Item=""  d
    ......s ItemDate=$G(^TempDHCPEDoctorWork(Job,"Doc",UserID,"PerInfo",PType,PAADM,Item))
	......s:Date="" Date=ItemDate
    ......s ItemDesc=$p(^ARCIM(+Item,$p(Item,"||",2),1),"^",2)
    ......i ItmMastDesc="" d
    .......s ItmMastDesc=ItemDesc
    ......e  d
    .......s ItmMastDesc=ItmMastDesc_"、"_ItemDesc
    .....s Date=##class(websys.Conversions).DateLogicalToHtml(Date)
    .....d OutDocWorkInfo
    
    k ^TempDHCPEDoctorWork(Job)  
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SetDocWorkVariable
    // 医生ID、工号、姓名、项目ID、项目描述
    s (SSUSRInitials,UserName,Item,ItmMastDesc)=""
    // 个检人数，团检人数
    s (INum,GNum)=0
    // 明细信息：
    s (PAADM,RegNo,Name,Sex,Age,VIP,Tel,GroupName,Date)=""
    q
GetDocWorkInfo	
    q:OEOrdItem="" 
 	s OEORIItemStatDR=$P($G(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),1)),"^",13)
 	q:OEORIItemStatDR'="6"
 	s ARCItem=$P($G(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),1)),"^",2)
    s Station=$o(^DHCPEST(0,"STORD_ARCIM",ARCItem,0))
	Q:(OEItem'="")&&(ARCItem'=OEItem)
	q:(ItmMastDR'="")&&(ARCItem'=ItmMastDR)
    q:(StationDR'="")&&(StationDR'=Station)
    
 	s PAADM=$p(^OEORD(+OEOrdItem),"^",1)
 	s IADM=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
 	q:IADM=""
 	
 	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IADM,CurLoc) 
 	q:LocFlag="1"
 	s GADM=$P($g(^DHCPEIADM(IADM)),"^",2)
 	q:(GroupDR="ALLI")&&(GADM'="")
	q:(GroupDR="ALLG")&&(GADM="")
 	q:(GroupDR'="")&&(GroupDR'=GADM)&&(GroupDR'="ALLI")&&(GroupDR'="ALLG")
 	s PType="I"
 	i GADM'="" s PType="G"
 	q:(PerType'="")&&(PType'=PerType)
 	
 	s PreIADM=$P($g(^DHCPEIADM(IADM)),"^",4)
 	i PreIADM'=""  s VIPLevelID=$p($g(^DHCPEPreIADM(PreIADM)),"^",18)
 	q:(VIPLevel'="")&&(VIPLevel'=VIPLevelID)
 	s QFlag=0
 	s spec=$P($G(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),3)),"^",20)
	i spec="" d
	.s RLTUser=$p($g(^SSU("SSUSR",UserID)),"^",2)	//检查医师名称	SS_User
    .s SSUSRInitials =$P($G(^SSU("SSUSR",UserID)),"^",1)
    .s:(DocNo'="")&(SSUSRInitials'=DocNo) QFlag=1
   	.s:(DocDR'="")&(DocDR'=UserID) QFlag=1
    e  d
    .i UserID="" d
    ..s CurName=""
    ..s UserID=$G(^DHCENSCheckHeal("CHECKTHEAL",spec))
    ..s:DocDR'="" CurName=$P($G(^SSU("SSUSR",DocDR)),"^",1)
    ..s:UserID'[CurName QFlag=1
    ..i DocNo'="" d
    ...s CurUserID=$O(^SSU("SSUSR",0,"SSUSR_Initials",DocNo,0))
    ...s:CurUserID'="" CurName=$P($G(^SSU("SSUSR",CurUserID)),"^",1)
    ...s:UserID'[CurName QFlag=1
    .e  d
    ..s:(DocNo'="")&(UserID'=DocNo) QFlag=1
    ..i DocDR'="" d
    ...s DocInitials=$P($G(^SSU("SSUSR",DocDR)),"^",1)
    ...s:(DocDR'="")&(UserID'=DocInitials) QFlag=1
    q:QFlag=1
    s ^TempDHCPEDoctorWork(Job,"Doc",UserID,"ItemInfo",ARCItem,PType)=$G(^TempDHCPEDoctorWork(Job,"Doc",UserID,"ItemInfo",ARCItem,PType))+1
 	s ^TempDHCPEDoctorWork(Job,"Doc",UserID,"ItemInfo",ARCItem,PType,PAADM,OEOrdItem)=AdmDate
 	q:$D(^TempDHCPEDoctorWork(Job,"Doc",UserID,"PAADM",PAADM))
 	s ^TempDHCPEDoctorWork(Job,"Doc",UserID,"PAADM",PAADM)=""
 	s ^TempDHCPEDoctorWork(Job,"Doc",UserID,"PerInfo",PType)=$G(^TempDHCPEDoctorWork(Job,"Doc",UserID,"PerInfo",PType))+1
    s ^TempDHCPEDoctorWork(Job,"Doc",UserID,"PerInfo",PType,PAADM,ARCItem)=AdmDate
		
	q
OutDocWorkInfo
    set Now=##class(websys.Conversions).DateLogicalToHtml(+$H)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($H,",",2))
	set Data=$lb(UserID,SSUSRInitials,UserName,Item,ItmMastDesc,INum,GNum,PAADM,$p(Info,"^",1),$p(Info,"^",2),$p(Info,"^",3),$p(Info,"^",4),$p(Info,"^",5),$p(Info,"^",6),$p(Info,"^",8),Date,Now)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator：      ln
/// CreateDate：   2020-03-20
/// Description:：科室工作量统计
/// Table：       DHC_PE_Result 
/// Input：       BeginDate, EndDate, DocNo, DocDR, GroupDR, StationDR, OEItem, VIPLevel, CTLOCID, USERID
/// Output：      
/// Return：无        
/// Others：d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.WorkStatistic","StationWorkStatistic","2020-03-01","2020-03-20","","","","","","Item","265","11489||1","I","304")
///         d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.WorkStatistic","StationWorkStatistic","2020-03-01","2020-03-20","","","","","","Coll","","","","304")                       
Query StationWorkStatistic(BeginDate As %Library.String = "", EndDate As %Library.String = "", GroupDR As %Library.String = "", LocDR As %Library.String = "", OEItem As %Library.String = "", VIPLevel As %Library.String = "", PayFlag As %Library.String = "", ShowFlag As %Library.String = "", RecLoc As %Library.String = "", ItmMastDR As %Library.String = "", PerType As %Library.String = "", CurLoc As %Library.String = "") As websys.Query(ROWSPEC = "RecLocDR:%String,LocDesc:%String,Item:%String,ItmMastDesc:%String,INum:%Float,GNum:%Float,IFactAmount:%Float,GFactAmount:%Float,RegNo:%String,Name:%String,Sex:%String,Age:%String,VIPLevel:%String,Tel:%String,GroupName:%String,FactAmount:%Float,Now:%String") [ SqlProc ]
{
}

ClassMethod StationWorkStatisticExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "", GroupDR As %Library.String = "", LocDR As %Library.String = "", OEItem As %Library.String = "", VIPLevel As %Library.String = "", PayFlag As %Library.String = "", ShowFlag As %Library.String = "", RecLoc As %Library.String = "", ItmMastDR As %Library.String = "", PerType As %Library.String = "", CurLoc As %Library.String = "") As %Status
{
 
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i ((BeginDate="")&(EndDate=""))
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s Job=$j
 	k ^TempDHCPEStationWork(Job)
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	i EndDate'=""  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	i BeginDate="" s BeginDate=+$H
	i EndDate="" s EndDate=+$H
	
	s AdmDate=BeginDate-1
	f  s AdmDate=$o(^DHCPERLT("0","DateOrder",AdmDate)) q:(AdmDate="")||(AdmDate>EndDate)  d
	.s OEOrdItem=0
	.f  s OEOrdItem=$o(^DHCPERLT("0","DateOrder",AdmDate,OEOrdItem)) q:OEOrdItem=""  d
	..d SetStationWorkInfo
	
	if ('$d(^TempDHCPEStationWork(Job))) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s RecLocDR=""
	f  s RecLocDR=$o(^TempDHCPEStationWork(Job,"RecLoc",RecLocDR)) q:RecLocDR=""  d
	.d SetStationWorkVariable
	.s LocDesc=$p(^CTLOC(RecLocDR),"^",2) 
	.i ShowFlag="Item" d
	..s Item=""
	..f  s Item=$o(^TempDHCPEStationWork(Job,"RecLoc",RecLocDR,"Item",Item)) q:Item=""  d
	...s ItmMastDesc=$p(^ARCIM(+Item,$p(Item,"||",2),1),"^",2)
	...i RecLoc="" d
	....s INum=$G(^TempDHCPEStationWork(Job,"RecLoc",RecLocDR,"Item",Item,"I"))
	....s IFactAmount=$G(^TempDHCPEStationWork(Job,"RecLoc",RecLocDR,"ItemAmount",Item,"I","FactAmount"))
	....s GNum=$G(^TempDHCPEStationWork(Job,"RecLoc",RecLocDR,"Item",Item,"G"))
	....s GFactAmount=$G(^TempDHCPEStationWork(Job,"RecLoc",RecLocDR,"ItemAmount",Item,"G","FactAmount"))
	....s Info=""
	....d OutStationWorkInfo
	...e  d
	....s PType=""
	....f  s PType=$o(^TempDHCPEStationWork(Job,"RecLoc",RecLocDR,"Item",Item,PType)) q:PType=""  d
	.....s PAADM=""
	.....f  s PAADM=$o(^TempDHCPEStationWork(Job,"RecLoc",RecLocDR,"Item",Item,PType,PAADM)) q:PAADM=""  d
	......s Info=..GetBaseInfo("PAADM",PAADM)
	......s FactAmount=$G(^TempDHCPEStationWork(Job,"RecLoc",RecLocDR,"Item",Item,PType,PAADM))
	......d OutStationWorkInfo
	.e  d 
	..i RecLoc="" d
	...s INum=$G(^TempDHCPEStationWork(Job,"RecLoc",RecLocDR,"Coll","I"))
	...s IFactAmount=$G(^TempDHCPEStationWork(Job,"RecLoc",RecLocDR,"CollAmount","I","FactAmount"))
	...s GNum=$G(^TempDHCPEStationWork(Job,"RecLoc",RecLocDR,"Coll","G"))
	...s GFactAmount=$G(^TempDHCPEStationWork(Job,"RecLoc",RecLocDR,"CollAmount","G","FactAmount"))
	...s Info=""
	...d OutStationWorkInfo
	..e  d
	...s PType=""
	...f  s PType=$o(^TempDHCPEStationWork(Job,"RecLoc",RecLocDR,"Coll",PType)) q:PType=""  d
	....s PAADM=""
	....f  s PAADM=$o(^TempDHCPEStationWork(Job,"RecLoc",RecLocDR,"Coll",PType,PAADM)) q:PAADM=""  d
	.....s Info=..GetBaseInfo("PAADM",PAADM)
	.....s Item=""
	.....f  s Item=$o(^TempDHCPEStationWork(Job,"RecLoc",RecLocDR,"Coll",PType,PAADM,Item)) q:Item=""  d
	......s ItmMastDesc=$p(^ARCIM(+Item,$p(Item,"||",2),1),"^",2)
	......s FactAmount=$G(^TempDHCPEStationWork(Job,"RecLoc",RecLocDR,"Coll",PType,PAADM,Item))
	......d OutStationWorkInfo
	
	
	k ^TempDHCPEStationWork(Job)
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SetStationWorkVariable
    // 接收科室、项目ID、项目描述
    s (LocDesc,Item,ItmMastDesc)=""
    // 个检人数，团检人数
    s (INum,GNum,IFactAmount,GFactAmount,FactAmount)=0
    // 明细信息：
    s (PAADM,RegNo,Name,Sex,Age,VIP,Tel,GroupName,Date)=""
    q
SetStationWorkInfo	
    q:OEOrdItem=""
	s OEORDRowId=$p(OEOrdItem,"||",1)
	s OEORIChildsub=$p(OEOrdItem,"||",2)
	s OEORIItemStatDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
 	q:OEORIItemStatDR'="6"
 	s ARCItem=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	Q:(""'=OEItem)&&(ARCItem'=OEItem) 	
	q:(""'=ItmMastDR)&&(ARCItem'=ItmMastDR)

	s RecDepDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	Q:(""'=LocDR)&&(LocDR'=RecDepDR)
	q:(""'=RecLoc)&&(RecDepDR'=RecLoc)
	s PAADM=$p(^OEORD(OEORDRowId),"^",1)
	s IADM=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
 	q:IADM=""
 	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IADM,CurLoc) 
 	q:LocFlag="1"
 	s GADM=$P($g(^DHCPEIADM(IADM)),"^",2)
 	q:(GroupDR="ALLI")&&(GADM'="")
	q:(GroupDR="ALLG")&&(GADM="")
 	q:(GroupDR'="")&&(GroupDR'=GADM)&&(GroupDR'="ALLI")&&(GroupDR'="ALLG")
 	s PType="I"
 	i GADM'="" s PType="G"
 	q:(PerType'="")&&(PerType'=PType)
 	s PreIADM=$P($g(^DHCPEIADM(IADM)),"^",4)
 	i PreIADM'=""  s VIPLevelID=$p($g(^DHCPEPreIADM(PreIADM)),"^",18)
 	q:(VIPLevel'="")&&(VIPLevel'=VIPLevelID)
 	s crmodr=$O(^DHCPECRMO(0,"OEORI",OEOrdItem,0))
 	q:(crmodr="")
	s PIOIDR=$P($G(^DHCPECRMO(crmodr)),"^",2)
	s BillStatus=$P($G(^DHCPECRMO(crmodr)),"^",4)
	q:((BillStatus="P")&&(PayFlag="N"))
	q:((BillStatus'="P")&&(PayFlag="Y"))
	s FactAmount=$p(^DHCPEPreIADM(+PIOIDR,"ORDITEM",$p(PIOIDR,"||",2)),"^",6)           //+##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(PIOIDR,"","")
 	s ^TempDHCPEStationWork(Job,"RecLoc",RecDepDR,"Item",ARCItem,PType)=$G(^TempDHCPEStationWork(Job,"RecLoc",RecDepDR,"Item",ARCItem,PType))+1
 	s ^TempDHCPEStationWork(Job,"RecLoc",RecDepDR,"ItemAmount",ARCItem,PType,"FactAmount")=$G(^TempDHCPEStationWork(Job,"RecLoc",RecDepDR,"ItemAmount",ARCItem,PType,"FactAmount"))+FactAmount
 	s ^TempDHCPEStationWork(Job,"RecLoc",RecDepDR,"Item",ARCItem,PType,PAADM)=FactAmount
 	s ^TempDHCPEStationWork(Job,"RecLoc",RecDepDR,"Coll",PType)=$G(^TempDHCPEStationWork(Job,"RecLoc",RecDepDR,"Coll",PType))+1
 	s ^TempDHCPEStationWork(Job,"RecLoc",RecDepDR,"CollAmount",PType,"FactAmount")=$G(^TempDHCPEStationWork(Job,"RecLoc",RecDepDR,"CollAmount",PType,"FactAmount"))+FactAmount
 	s ^TempDHCPEStationWork(Job,"RecLoc",RecDepDR,"Coll",PType,PAADM,ARCItem)=FactAmount
 		
	q
OutStationWorkInfo
    set Now=##class(websys.Conversions).DateLogicalToHtml(+$H)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($H,",",2))
	set Data=$lb(RecLocDR,LocDesc,Item,ItmMastDesc,INum,GNum,IFactAmount,GFactAmount,$p(Info,"^",1),$p(Info,"^",2),$p(Info,"^",3),$p(Info,"^",4),$p(Info,"^",5),$p(Info,"^",6),$p(Info,"^",8),FactAmount,Now)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

}
