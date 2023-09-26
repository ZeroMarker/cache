Class web.DHCPE.NetPre.GetPreInfo Extends %Persistent
{

// 需要保存一个VIP等级取出来赋值

ClassMethod GetInfo(IDCard, LocID)
{
	;w ##class(web.DHCPE.NetPre.GetPreInfo).GetInfo("530323198009080031","53")
	s $ZT="GetInfoErr"
	q:IDCard="" ""
	s UseID=""
	s ID=""
	f  s ID=$O(^User.DHCPENetPreRecordI("IDCardIndex",IDCard,ID),-1) q:(ID="")||(UseID'="")  d
	.s Status=$LG(^User.DHCPENetPreRecordD(ID),7)
	.q:Status'="0"
	.s CurLocID=$LG(^User.DHCPENetPreRecordD(ID),17)
	.b ;CurLocID
	.q:CurLocID'=LocID
	.s UseID=ID
	q:UseID="" ""
	s RegNo=$LG(^User.DHCPENetPreRecordD(UseID),2)
	s SetsID=$LG(^User.DHCPENetPreRecordD(UseID),8)
	s PreDate=$LG(^User.DHCPENetPreRecordD(UseID),9)
	s:PreDate'="" PreDate=##class(websys.Conversions).DateLogicalToHtml(PreDate)
	s Name=$LG(^User.DHCPENetPreRecordD(UseID),3)
	s Sex=$LG(^User.DHCPENetPreRecordD(UseID),4)
	s VIPDesc=$LG(^User.DHCPENetPreRecordD(UseID),16)
	s VIPID=##class(web.DHCPE.VIPLevel).GetVIPIDByDesc(VIPDesc)
	s Tel=$LG(^User.DHCPENetPreRecordD(UseID),19)
	
	s Time=$LG(^User.DHCPENetPreRecordD(UseID),18)
	
	s:Time'="" Time=$ZT(Time,1)
	q UseID_"^"_SetsID_"^"_PreDate_"^"_Name_"^"_Sex_"^"_VIPID_"^"_Time_"^"_Tel_"^"_RegNo
GetInfoErr
	q "ErrInfo"
}

ClassMethod UpdateStatus(ID, String)
{
	//n (ID, String)
	;w ##class(web.DHCPE.NetPre.GetPreInfo).UpdateStatus("3","1^5918^62257")
	s $ZT="UpdateErr"
	s Status=$P(String,"^",1)
	s UserID=$P(String,"^",2)
	s PreID=$P(String,"^",3)
	s RegNo=""
	i PreID'="" d
	.s IBIID=$P(^DHCPEPreIADM(PreID),"^",1)
	.s RegNo=$P(^DHCPEPreIBI(IBIID),"^",1)
	s obj=##class(User.DHCPENetPreRecord).%OpenId(ID)
	s obj.NPRStatus=Status
	s:PreID'="" obj.NPRPreIADM=PreID
	d obj.NPRUpdateUserDRSetObjectId(UserID)
	s obj.NPRUpdateDate=+$H
	s obj.NPRUpdateTime=$P($H,",",2)
	s obj.NPRRegNo=RegNo
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q "0^更新成功"
	}
UpdateErr
	q "-1^异常"
}

/// RefundFlag: 1 退费  2 取消到达
ClassMethod UpdateChargedStatus(PreID, Status, RefundFlag = "0")
{
	;w ##class(web.DHCPE.NetPre.GetPreInfo).UpdateChargedStatus("9532","4",2)
	s $ZT="ChargedErr"
	s NowStatus=""
	s NowPayFlag=""
	&SQL(Select NPR_Status,NPR_PayFlag into :NowStatus,:NowPayFlag from Sqluser.DHC_PE_NetPreRecord where NPR_PreIADM=:PreID)
	i (RefundFlag="1")&&(NowStatus=5) d
	.&SQL(Update Sqluser.DHC_PE_NetPreRecord set NPR_PayFlag='0' where NPR_PreIADM=:PreID)

	q:(NowStatus=5)&&(RefundFlag="0")&&(Status'=6) "已体检"
	i RefundFlag="2" d
	.s:NowPayFlag="1" Status="4"
	.s:NowPayFlag="0" Status="1"
	
	i Status="4" d
	.&SQL(Update Sqluser.DHC_PE_NetPreRecord set NPR_Status=:Status,NPR_PayFlag='1'  where NPR_PreIADM=:PreID)
	e  d
	.i RefundFlag="1" d
	..&SQL(Update Sqluser.DHC_PE_NetPreRecord set NPR_Status=:Status,NPR_PayFlag='0' where NPR_PreIADM=:PreID)
	.e  d
	..&SQL(Update Sqluser.DHC_PE_NetPreRecord set NPR_Status=:Status where NPR_PreIADM=:PreID)
	;d:SQLCODE=0 ##class(HS.BL.JKL.JKLPush).PushStatChange(PreID)
	q SQLCODE
ChargedErr
	q ""
}

// 判断是否允许预约0:不允许 1允许

// w ##class(web.DHCPE.NetPre.GetPreInfo).IsCanPre("09/01/2019","370","1","I","08:00")

ClassMethod IsCanPre(Date, LocID, VIPLevel, GIType As %String = "I", PreTime)
{
	s Date=##class(websys.Conversions).DateHtmlToLogical(Date)
	q:Date<+$H "1^以前日期" 
	s PreNumID=##class(web.DHCPE.PreTemplate).GetRecordID(LocID,Date,VIPLevel,GIType)
	q:PreNumID="" "0^不是工作日,不允许预约"
	
	s:PreTime'="" PreTime=$ZTH(PreTime,1)
	s:PreTime="" PreTime=$P($H,",",2)
	s TimeInfo=##class(web.DHCPE.NetPre.GetPreInfo).GetTimeInfo(PreNumID,PreTime)
	b ;TimeInfo
	s RecordNum=$P(TimeInfo,"^",2)
	s TimeInfo=$P(TimeInfo,"^",1)
	s StartTime=$P(TimeInfo,"-",1)
	s:StartTime'="" StartTime=$ZTH(StartTime,1)
	s EndTime=$P(TimeInfo,"-",2)
	s:EndTime'="" EndTime=$ZTH(EndTime,1)
	s HisNum=..GetHisPreNum(Date,LocID,VIPLevel,GIType,StartTime,EndTime)
	b ;HisNum
	s VIPDesc=$P(^DHCPEVIPLevel("VIP",VIPLevel),"^",2)
	s PreNum=..GetNetPreNum(Date,LocID,VIPDesc,GIType,"0",StartTime,EndTime)
	b ;PreNum
	q:RecordNum<(HisNum+PreNum) "0^预约限额不足"
	q "1^剩余预约限额"_(RecordNum-(HisNum+PreNum))
}

/// 最后一个参数为主场ID
/// w ##class(web.DHCPE.NetPre.GetPreInfo).GetPreNum("63552","53","过期主场","O","","","O","")
ClassMethod GetPreNum(Date, LocID, VIPLevel, GIType As %String = "I", StartTime As %String = "", EndTime As %String = "", PmType As %String = "", preID As %String = "")
{
	;w ##class(web.DHCPE.NetPre.GetPreInfo).GetPreNum(63242,53,"普通","I",StartTime,EndTime)
	;d ##class(HS.BL.ExaminationRegister).QueryHomeFirAvailDate()
	s VIPID=##class(web.DHCPE.VIPLevel).GetVIPIDByDesc(VIPLevel)
	i VIPID="" s VIPID=$G(^DHCPEVIPLevel("VIPapprove"))
	s HisNum=""
	s PreNum=""
	i GIType = "I"  do
	.s HisNum=..GetHisPreNum(Date,LocID,VIPID,GIType,StartTime,EndTime,PmType,preID)
	s PreNum=..GetNetPreNum(Date,LocID,VIPID,GIType,"0",StartTime,EndTime,PmType,preID)
	s HisMaleNum = $p(HisNum,"-",1),HisFemaleNum = $p(HisNum,"-",2)
	s PreMaleNum = $p(PreNum,"-",1),PreFemaleNum = $p(PreNum,"-",2)
	s MaleNum = HisMaleNum + PreMaleNum
	s FemaleNum = HisFemaleNum + PreFemaleNum
	s Num = MaleNum_"-"_FemaleNum
	q Num
}

ClassMethod IsCanPreForHis(Date, LocID, VIPLevel, GIType As %String = "I", PreTime, PIBI As %String = "")
{
	;w ##class(web.DHCPE.NetPre.GetPreInfo).IsCanPreForHis("09/01/2019",370,1,"I","")
	;q:VIPLevel'=1 "1^不是普通不判断" 
	s Date=##class(websys.Conversions).DateHtmlToLogical(Date)
	;q:Date<(+$H+1) "1^以前日期" 
	s PreNumID=##class(web.DHCPE.PreTemplate).GetRecordID(LocID,Date,VIPLevel,GIType)
	;q:PreNumID="" "1^不是工作日,不允许预约"
	s HisNum=..GetHisPreNum(Date,LocID,VIPLevel,GIType,"","","","")
	
	s HisMaleNum=$p(HisNum,"-",1)
	s HisFemaleNum=$p(HisNum,"-",2)
	s SexDR=""
	i PIBI'="" s SexDR=$p($g(^DHCPEPreIBI(PIBI)),"^",3)
	
	s ID=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,Date,VIPLevel,GIType,""))
	q:ID="" ""
	s MaleNum = $LG(^User.DHCPEPreManagerD(ID),11)
	s FemaleNum = $LG(^User.DHCPEPreManagerD(ID),12)
	i (SexDR=1)&&(HisMaleNum>=MaleNum) q "0^已经预约男"_HisMaleNum_"人,超出预约管理设置的最大数,是否继续预约?"
	i (SexDR=2)&&(HisFemaleNum>=FemaleNum) q "0^已经预约女"_HisFemaleNum_"人,超出预约管理设置的最大数,是否继续预约?"	
	//i HisNum>1 q "0^已经预约"_HisNum_",是否继续预约"
	q "1^不到人数"
}

/// 最后一个参数为主场ID
/// w ##class(web.DHCPE.NetPre.GetPreInfo).GetHisPreNum("63522","53","1","I","28801","30600","I","1224")
ClassMethod GetHisPreNum(Date, LocID, VIPLevel, GIType, StartTime, EndTime, PmType, preID)
{
	s HisMaleNum=0,HisFemaleNum=0
	q:Date="" HisMaleNum_"-"_HisFemaleNum
	
	i StartTime="" s StartTime=1
	i EndTime="" s EndTime=86399 ;"23:59:59"
	s Time=StartTime-1
	f  s Time=$O(^DHCPEPreIADM(0,"BookDateTime",Date,Date,Time)) q:(Time="")||(Time<StartTime)||(Time>EndTime)  d
	.s ID=""
	.f  s ID=$O(^DHCPEPreIADM(0,"BookDateTime",Date,Date,Time,ID)) q:ID=""  d
	..
	..s Status=$P($g(^DHCPEPreIADM(ID)),"^",8)
	..q:Status="CANCELPE"
	..
	..s CurLoc=$P($g(^DHCPEPreIADM(ID)),"^",26)
	..q:CurLoc'=LocID
	..
	..s CurVIP=$P($g(^DHCPEPreIADM(ID)),"^",18)
	..i CurVIP="" s CurVIP = 1
	..
	..q:CurVIP'=VIPLevel
	..
	..s GID=$P($g(^DHCPEPreIADM(ID)),"^",2)
	..q:(GID'="")&&(GIType="I")
	..q:(GID="")&&((GIType="G")||(PmType="H"))
	..s GHomeId=""
	..s HomeQuit=0
	..i PmType="H" d
	...s HomeType=$LG(^User.DHCPEPreHomeInfoD(preID),11)
	...i HomeType="G" d
	....s HomeGID=$LG(^User.DHCPEPreHomeInfoD(preID),2)
	....s:GID'=GHomeId HomeQuit=1
	...e  d  ;如果是合同主场，取出合同ID判断
	....s HomeCID=$LG(^User.DHCPEPreHomeInfoD(preID),2)
	....s GCID=$P(^DHCPEPreGADM(GID),"^",25)
	....s:HomeCID'=GCID HomeQuit=1
	..q:HomeQuit=1
	..;i (PmType="H")  s GHomeId = $LG(^User.DHCPEPreHomeInfoD(preID),2)
	..;q:(PmType="H")&&(GID'=GHomeId)
	..s NetFlag=..IsNetPre(ID)
	..q:NetFlag="1"
	..s PIBIDR = $P($g(^DHCPEPreIADM(ID)),"^",1)
	..s Sex=$P($g(^DHCPEPreIBI(PIBIDR)),"^",3)
	..
	..i (Sex=1) s HisMaleNum = HisMaleNum + 1
	..i (Sex=2) s HisFemaleNum = HisFemaleNum + 1
	
	q HisMaleNum_"-"_HisFemaleNum
}

/// 最后一个参数为主场ID
/// w ##class(web.DHCPE.NetPre.GetPreInfo).GetNetPreNum("63552","53","4","O","0","","","O","")
ClassMethod GetNetPreNum(Date, LocID, VIPLevel, GIType, InclueHis As %String = "1", StartTime, EndTime, PmType, preID)
{
	s NetMaleNum=0,NetFemaleNum=0
	s:StartTime="" StartTime=1
	s:EndTime="" EndTime=86399
	s ID=0
	f  s ID=$O(^User.DHCPENetPreRecordI("PreDateIndex",Date,ID)) q:ID=""  do
	.s Status = $LG(^User.DHCPENetPreRecordD(ID),7)
	.q:(Status'=0)&&(Status'=1)&&(Status'=4)&&(Status'=5)
	.s CurLoc=$LG(^User.DHCPENetPreRecordD(ID),17)
	.q:CurLoc'=LocID
	.s CurVIP=$LG(^User.DHCPENetPreRecordD(ID),16)
	.s VIPDESC=##class(web.DHCPE.VIPLevel).GetVIPIDByDesc(CurVIP)
	.i VIPDESC="" s VIPDESC="1"
	.q:(VIPLevel'="")&&(VIPDESC'=VIPLevel)&&(VIPLevel'="4")
	.s PreTime=$LG(^User.DHCPENetPreRecordD(ID),18)
	.q:(PreTime'="")&&((PreTime>EndTime)||(PreTime<StartTime))
	.s PrePmType=$LG(^User.DHCPENetPreRecordD(ID),22)

	.q:(PrePmType'="")&&(PrePmType'=PmType)
	.s PrePmID=$LG(^User.DHCPENetPreRecordD(ID),23)
	.i PrePmID'="" s PrePmID=$p(PrePmID,"||",1)
	.q:(PmType="H")&&(preID'=PrePmID)
	.s PreIADM=$LG(^User.DHCPENetPreRecordD(ID),13)
	.s GID=""
	.i PreIADM'="" d
	..s GID=$P(^DHCPEPreIADM(PreIADM),"^",2)
	.q:(GID'="")&&(GIType="I")
	.q:(GID="")&&(GIType="G")
	.q:(GID="")&&(GIType="O")
	.q:(GID="")&&(GIType="H")
	

	.s Sex=$LG(^User.DHCPENetPreRecordD(ID),4)
	.i (Sex=1) s NetMaleNum = NetMaleNum + 1
	.i (Sex=2) s NetFemaleNum = NetFemaleNum + 1
	q NetMaleNum_"-"_NetFemaleNum
}

ClassMethod GetTimeInfo(PreNumID, Time)
{
	;w ##class(web.DHCPE.NetPre.GetPreInfo).GetTimeInfo(100,28800)
	q:PreNumID="" ""
	s ret=""
	s Num=$LG(^User.DHCPEPreManagerD(PreNumID),4)
	i (+Num)=0
	{
		s MaleNum=$LG(^User.DHCPEPreManagerD(PreNumID),11)
		s FemalNum=$LG(^User.DHCPEPreManagerD(PreNumID),12)
		s Num=MaleNum+FemalNum
	}
	s Sub=0
	f  s Sub=$O(^User.DHCPEPreManagerD(PreNumID,"PMTimeChild",Sub)) q:(Sub="")||(ret'="")  d
 	.s ListInfo=^User.DHCPEPreManagerD(PreNumID,"PMTimeChild",Sub)
 	.s STime=$LG(ListInfo,2)
 	.s ETime=$LG(ListInfo,3)
 	.q:Time<STime
 	.q:Time>ETime
 	.s Num=$LG(ListInfo,5)+$LG(ListInfo,6)
    .s ret=##class(websys.Conversions).TimeLogicalToHtml(STime)_"-"_##class(websys.Conversions).TimeLogicalToHtml(ETime)
 	q ret_"^"_Num
}

/// w ##class(web.DHCPE.NetPre.GetPreInfo).GetHisPreInfo("530323199009060030","53","40692295","PAAAJ0002")
ClassMethod GetHisPreInfo(IDCard, LocID, RegNo As %String = "", PeId)
{
	;0可以预约  1存在未付费预约 2存在已付费预约
	;w ##class(web.DHCPE.NetPre.GetPreInfo).GetHisPreInfo("220104196605021330","53")
	s Num=0
	if PeId=""  do
	.s:RegNo="" RegNo=##class(web.DHCPE.PreIBaseInfo).GetRegNoByIDCard(IDCard)
	.q:RegNo=""
	.s PIBIID=$O(^DHCPEPreIBI(0,"PAPMINo",RegNo,""))
	.q:PIBIID=""
	.s PreID=""
	.f  s PreID=$O(^DHCPEPreIADM(0,"PIBI",PIBIID,PreID)) q:(PreID="")||(Num'=0)  d
	..s CurLocID=$P(^DHCPEPreIADM(PreID),"^",26)
	..q:CurLocID'=LocID
	..s Status=$P(^DHCPEPreIADM(PreID),"^",8)
	..q:Status="CANCELPE"
	..;q:Status="ARRIVED"
	..s PayedFlag=..GetPayedFlag(PreID)
	..s:PayedFlag=0 Num=1
	..s:PayedFlag=1 Num=2
	e  do
	.s PreID=""
	.f  s PreID=$O(^DHCPEPreIADM(0,"HPNo",PeId,PreID)) q:(PreID="")||(Num'=0)  d
	..s CurLocID=$P(^DHCPEPreIADM(PreID),"^",26)
	..q:CurLocID'=LocID
	..s Status=$P(^DHCPEPreIADM(PreID),"^",8)
	..q:Status="CANCELPE"
	..q:Status="ARRIVED"
	..s PayedFlag=..GetPayedFlag(PreID)
	..s:PayedFlag=0 Num=1
	..s:PayedFlag=1 Num=2
	q Num
}

/// w ##class(web.DHCPE.NetPre.GetPreInfo).GetPayedFlag("62342")
ClassMethod GetPayedFlag(CRMID)
{
	;0:未付费 1:已付费
	s Flag=0
	s AsChargeFlag=$P(^DHCPEPreIADM(CRMID),"^",9)
	q:AsChargeFlag="Y" 1
	s PreAuditID=0
	f  s PreAuditID=$O(^DHCPEPreA(0,"CRMADM","I",CRMID,PreAuditID)) q:(PreAuditID="")||(Flag'=0)  d
	.s Status=$P(^DHCPEPreA(PreAuditID),"^",21)
	.q:Status="NU"
	.s ChargeStatus=$P(^DHCPEPreA(PreAuditID),"^",14)
	.s:ChargeStatus="CHARGED" Flag=1
 	
	q Flag
}

ClassMethod IsNetPre(PreID)
{
	s NetFlag=0
	s NetID=""
	f  s NetID=$O(^User.DHCPENetPreRecordI("NPRPreIADMIndex"," "_PreID,NetID)) q:(NetID="")||(NetFlag=1)  d
	.s PayFlag=$LG(^User.DHCPENetPreRecordD(NetID),15)
	.q:PayFlag="3"
	.s NetFlag=1
	q NetFlag
}

ClassMethod GetHisInfo(RegNo, LocID)
{
	;w ##class(web.DHCPE.NetPre.GetPreInfo).GetHisInfo("40696618","53")
	;PreIADM_"^"_RegNo_"^"_Name_"^"_IDCard_"^"_Dob_"^"_Tel_"^"_Age_"^"_Postion_"^"_Sex
	s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
	s RegNoIndex=RegNo
	s RegNoIndex=$ZCVT(RegNoIndex,"U")
	s PaPatID=$O(^PAPERi("PAPMI_PatNo",RegNoIndex,0))
	b ;PaPatID
	q:PaPatID="" "-1^登记号不存在"
	s PreIADM=""
	s PaadmID=""
	f  s PaadmID=$O(^PAPERdr(PaPatID,"ADM","H",PaadmID),-1) q:(PaadmID="")||(PreIADM'="")  d
	.s CurLocID=$P(^PAADM(PaadmID),"^",4)
	.q:CurLocID'=LocID
	.s PIADM=$O(^DHCPEIADM(0,"PAADM",PaadmID,0))
	.b ;PIADM
	.q:PIADM=""
	.s Status=$P(^DHCPEIADM(PIADM),"^",8)
	.q:Status'="ARRIVED"
	.s PreIADM=$P(^DHCPEIADM(PIADM),"^",4)
	i PreIADM="" q "-1^没有预约记录"
	s BaseInfo=##class(web.DHCPE.DocPatientFind).GetBaseInfo(PaPatID)
	q PreIADM_"^"_BaseInfo
}

/// w ##class(web.DHCPE.NetPre.GetPreInfo).GetHPNo("53","05540","刘士勤")
ClassMethod GetHPNo(LocID, EmplNo, Name, Type As %String = "1")
{
	s EPAPMIID=""
	s PAPMIID=""
	f  s PAPMIID=$O(^PAPERi("EmplNo",EmplNo,PAPMIID)) q:(PAPMIID="")||(EPAPMIID'="")  d
	.s ActiveFlag=$P(^PAPER(PAPMIID,"PAT",1),"^",6)
	.q:ActiveFlag="N"
	.s EPAPMIID=PAPMIID
	q:EPAPMIID="" "-1^工号不存在"
	s EName=$P(^PAPER(EPAPMIID,"ALL"),"^",1)
	q:EName'=Name "-2^工号对应的姓名和录入姓名不一致"
	s RegNo=$P(^PAPER(EPAPMIID,"PAT",1),"^",1)
	s PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	q:PIBI="" "-3^体检系统不存在记录"
	s IDCard=$P(^PAPER(EPAPMIID,"PAT",3),"^",6)
	b ;EPAPMIID IDCard
	s HPNo=""
	s id=""
	f  s id=$o(^DHCPEPreIADM(0,"PIBI",PIBI,id),-1) q:(id="")||(id=0)||(HPNo'="")  d
	.s Status=$P(^DHCPEPreIADM(id),"^",8)
	.q:Status="CANCELPE"
	.q:Status="ARRIVED"
	.s OldLocID=$P(^DHCPEPreIADM(id),"^",26)
	.q:OldLocID'=LocID
	.s IADM=$O(^DHCPEIADM(0,"CRMADM",id,0))
	.q:IADM=""
	.s Date=$P(^DHCPEIADM(IADM),"^",5)
	.q:Date<63445
	.s HPNo=$P(^DHCPEPreIADM(id),"^",27)
	q:HPNo="" "-3^体检系统不存在记录"
	q:IDCard="" "-5^工号对应身份证号不存在,请到建卡处补全身份证信息"
	s ErrFlag=0
	i LocID="53" d
	.s LocID="572"
	e  d
	.s LocID=53
	s ErrInfo = ""
	s:(Type="1") ErrInfo=..GetHPNo(LocID,EmplNo,Name,0)
	i ($P(ErrInfo,"^",1)=0)&&(Type=1) d
	.s ErrHPNo=$P(ErrInfo,"^",3)
	.s PreIADM=$O(^DHCPEPreIADM(0,"HPNo",ErrHPNo,0))
	.i $D(^User.DHCPEModifyDateRecordI("PreIADMIndex", PreIADM)) d
	..s ErrFlag="1"
	q:ErrFlag="1" "-4^另一科室已经预约过，不允许再次预约"
	q "0^"_IDCard_"^"_HPNo
}

// w ##class(web.DHCPE.NetPre.GetPreInfo).DeleteNetPre()

ClassMethod DeleteNetPre(Date As %String = "")
{
	s $ZT="DeleteNetPreErr"
	s:Date="" Date=+$H
	s CurPreID=""
	f  s CurPreID=$O(^User.DHCPENetPreRecordI("PreDateIndex",Date,CurPreID)) q:CurPreID=""  d
	.s Status=$LG(^User.DHCPENetPreRecordD(CurPreID),7)
	.q:Status'=0
	.;b ;Status
	.s Ret=..UpdateStatus(CurPreID, "3^5918^")
	.b ;Ret
	q ""
DeleteNetPreErr
	q "DeleteErr"
}

Storage Default
{
<Data name="GetPreInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.NetPre.GetPreInfoD</DataLocation>
<DefaultData>GetPreInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.NetPre.GetPreInfoD</IdLocation>
<IndexLocation>^web.DHCPE.NetPre.GetPreInfoI</IndexLocation>
<StreamLocation>^web.DHCPE.NetPre.GetPreInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
