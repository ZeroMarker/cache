Import SQLUser

/// 创建时间		：2007.09.06
/// 创建人			：xuwm
/// 存在系统		：体检系统
/// 关联数据		: 
/// 索引			:
/// 主要功能		: 阳性体征查询 
/// 主要功能		：
/// 最后修改时间	：
/// 最后修改人		：
Class web.DHCPE.Report.PosQuery Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 14;

ClassMethod ExportItem(DateFrom As %Library.String = "", DateTo As %Library.String = "", Standards As %Library.String = "", GroupID As %Library.String = "", VIPLevel As %Library.String = "")
{
	
 s User=%session.Get("LOGON.USERID")
  s CurLocID=%session.Get("LOGON.CTLOCID")
 k ^DHCPETMPPQ(User)	

 f iLoop=1:1:$l(Standards,"^") d
 .s Standard=$P(Standards,"^",iLoop)
 .// DHC_PE_Station.{ ST_RowId }
 .s STRowId=$P($G(Standard),"||",1)
 .// DHC_PE_OrderDetail.{ OD_ChildSub }
 .s ODChildSub=$P($G(Standard),"||",2)
 .Q:(""=STRowId)||(""=ODChildSub)
 .s ODDesc=$P($G(^DHCPEST(STRowId,"OD",ODChildSub)),"^",1)
 .s RLTODDR=STRowId_"||"_ODChildSub
 .s ^DHCPETMPPQ(User,"OrderDetail", RLTODDR)=1
	
 i DateFrom'="" s DateFrom=$zdh(DateFrom,4)
 i DateFrom=""  s DateFrom=+$h
 
 i DateTo'="" s DateTo=$zdh(DateTo,4)
 i DateTo=""  s DateTo=+$h	
 
 i GroupID'="" d
 .s TeamID=0
 .f  s TeamID=$o(^DHCPEIADM(0,"GADM",GroupID,TeamID)) q:TeamID=""  d
 ..s IAdmRowId=0
 ..f  s IAdmRowId=$o(^DHCPEIADM(0,"GADM",GroupID,TeamID,IAdmRowId)) q:IAdmRowId=""  d
 ...
 ...d GetPIADMInfo	
	
 e  d
 .
 .s DateBegin=DateFrom
 .s DateEnd=DateTo
 .s:(0'=+DateBegin) DateBegin=$O(^DHCPEIADM(0,"AdmDateTime",DateBegin),-1)
 .// DHC_PE_IADM.{ IADM_AdmDate }
 .s IADMAdmDate=+DateBegin
 .f  s IADMAdmDate=$O(^DHCPEIADM(0, "AdmDateTime", IADMAdmDate)) q:((""'=DateEnd)&(IADMAdmDate>+DateEnd)||(""=IADMAdmDate))  d
 ..// DHC_PE_IADM.{ IADM_AdmTime }
 ..s IADMAdmTime=0
 ..f  s IADMAdmTime=$O(^DHCPEIADM(0, "AdmDateTime", IADMAdmDate, IADMAdmTime)) q:(""=IADMAdmTime)  d
 ...s IAdmRowId=0
 ...f  s IAdmRowId=$O(^DHCPEIADM(0, "AdmDateTime", IADMAdmDate, IADMAdmTime, IAdmRowId)) q:(""=IAdmRowId)  d
 ....
 ....d GetPIADMInfo
 

 s paadm=0,^DHCPETMPPQ(User,"AllADM")=1
 f  s paadm=$o(^DHCPETMPPQ(User,"ADM",paadm)) q:paadm=""  d
 .s ^DHCPETMPPQ(User,"AllADM")=$g(^DHCPETMPPQ(User,"AllADM"))_"^"_paadm
 
 q $g(^DHCPETMPPQ(User,"AllADM"))
 
 
GetPIADMInfo
 q:IAdmRowId=""
 
 s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IAdmRowId)
 q:LocFlag=1
 s Status=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
 Q:'("ARRIVED"=Status)
 s ArrDate=$P($g(^DHCPEIADM(IAdmRowId)),"^",5)
 i ""'=ArrDate s ArrDate=$ZD(ArrDate,3)
 // DHC_PE_IADM.{ IADM_PAADM_DR }
 s ADM=$P($g(^DHCPEIADM(IAdmRowId)),"^",1)
 Q:ADM=""
 s CRMAdm=$P($g(^DHCPEIADM(IAdmRowId)),"^",4)
 q:CRMAdm=""
 s PIADMVIP = ##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",CRMAdm)
 s TVIPlevel=$P(PIADMVIP,"^",1)
 q:(VIPLevel'="")&&(VIPLevel'=TVIPlevel)
 s GName=""
 s PreGADM=$P($g(^DHCPEPreIADM(CRMAdm)),"^",2)
 i PreGADM'="" d
 .s PreGBI=$P($g(^DHCPEPreGADM(PreGADM)),"^",1)
 .s GName=$P($g(^DHCPEPreGBI(PreGBI)),"^",2)
 s HPNo=$P($g(^DHCPEPreIADM(CRMAdm)),"^",27)
 // 取患者信息
 s PapmiNo=$p($g(^PAADM(ADM)),"^",1)
 s PAPMIIPNo=$p(^PAPER(PapmiNo,"PAT",1),"^",1)
 s PAPMIName=$p(^PAPER(PapmiNo,"ALL"),"^",1)
 s Sex=$p($g(^PAPER(PapmiNo,"ALL")),"^",7)
 i ""'=Sex s Sex=$p($g(^CT("SEX",Sex)),"^",2)
 s PAPMIDOB=$p($g(^PAPER(PapmiNo,"ALL")),"^",6)
 s Age=##class(web.DHCLCNUREXCUTE).CalAge(PAPMIDOB,+$h)
 s Age=$P(Age,"Y",1)
 i ""'=PAPMIDOB s PAPMIDOB=$ZD(PAPMIDOB,3)
 s ^DHCPETMPPQ(User,"Title",1)="登记号"_"^"_"体检号"_"^"_"姓名"_"^"_"性别"_"^"_"年龄"_"^"_"出生日期"_"^"_"体检日期"_"^"_"团体"
 s ^DHCPETMPPQ(User,"ADM", ADM)=PAPMIIPNo_"^"_HPNo_"^"_PAPMIName_"^"_Sex_"^"_Age_"^"_PAPMIDOB_"^"_ArrDate_"^"_GName
 s ODDR=0,Flag=0
 f  s ODDR=$O(^DHCPETMPPQ(User,"OrderDetail", ODDR)) Q:(""=ODDR)  d
 .// DHC_PE_Result.{ RLT_RowId }
 .;i +ODDR=$g(^DHCPESetting("DHCPE","StationId_Lab"))  d
 .i +ODDR=$g(^DHCPESetting("DHCPE","StationId_Lab",CurLocID)) d
 ..s RLTRowId=0,Result=""
 ..s STRowId=$p(ODDR,"||",1)
 ..s ODChildSub=$p(ODDR,"||",2)
 ..s ODDesc=$P($G(^DHCPEST(STRowId,"OD",ODChildSub)),"^",1)
 ..
 ..f  s RLTRowId=$O(^DHCPERLT(0,"ADM",ADM,RLTRowId)) Q:(""=RLTRowId)  d
 ...// DHC_PE_Result.{ RLT_Result }
 ...
 ...s RLTODDR=$P(^DHCPERLT(RLTRowId), "^", 3)
 ...s RLTDesc=$P($g(^DHCPEST(+RLTODDR,"OD",$P(RLTODDR,"||",2))),"^",1)
 ...s:ODDesc=RLTDesc Flag=1
 ...q:ODDesc'=RLTDesc
 ...s Result=$P(^DHCPERLT(RLTRowId), "^", 4)
 ..
 ..s ^DHCPETMPPQ(User,"ADM", ADM)=$g(^DHCPETMPPQ(User,"ADM", ADM))_"^"_Result
 ..s ^DHCPETMPPQ(User,"Title",1)=$g(^DHCPETMPPQ(User,"Title",1))_"^"_ODDesc
 .e  d
 ..s RLTRowId=0,Result=""
 ..s STRowId=$p(ODDR,"||",1)
 ..s ODChildSub=$p(ODDR,"||",2)
 ..s ODDesc=$P($G(^DHCPEST(STRowId,"OD",ODChildSub)),"^",1)
 ..
 ..f  s RLTRowId=$O(^DHCPERLT(0,"PAADM_OD",ADM, ODDR, RLTRowId)) Q:(""=RLTRowId)  d
 ...// DHC_PE_Result.{ RLT_Result }
 ...s Result=$P(^DHCPERLT(RLTRowId), "^", 4)
 ...s Flag=1
 ..s ^DHCPETMPPQ(User,"ADM", ADM)=$g(^DHCPETMPPQ(User,"ADM", ADM))_"^"_Result
 ..s ^DHCPETMPPQ(User,"Title",1)=$g(^DHCPETMPPQ(User,"Title",1))_"^"_ODDesc
 i Flag=0 k ^DHCPETMPPQ(User,"ADM", ADM)
}

ClassMethod ExportItemInfo(ADM)
{
	s User=%session.Get("LOGON.USERID")
	q:ADM="" ""
	if ADM=1 s ret=$g(^DHCPETMPPQ(User,"Title",1))
	else  s ret=$g(^DHCPETMPPQ(User,"ADM", ADM))
	q ret
}

/// 阳性体征  
Query PosQuery(Standards As %Library.String = "", PatName As %Library.String = "", RegNo As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", QueryType As %Library.String = "", VIPLevel As %Library.String = "", GroupID As %Library.String = "") As %Query(ROWSPEC = "PAADM_RowId:%String, PAPMI_IPNo:%String, PAPMI_Name:%String, PAPMI_Sex_DR_Name:%String, PAPMI_DOB:%String")
{
}

ClassMethod PosQueryExecute(ByRef qHandle As %Binary, Standards As %Library.String = "", PatName As %Library.String = "", RegNo As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", QueryType As %Library.String = "", VIPLevel As %Library.String = "", GroupID As %Library.String = "") As %Status
{
 Set repid=$I(^CacheTemp)
 i (""=Standards) {
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
 }
 k ^DHCPETMPPQ
 Set repid=$I(^CacheTemp)
 s ind=1
 i DateFrom'="" s DateFrom=##class(websys.Conversions).DateHtmlToLogical(DateFrom)
 i DateTo'=""   s DateTo=##class(websys.Conversions).DateHtmlToLogical(DateTo)

 f iLoop=1:1:$l(Standards,"^") d
 .s Standard=$P(Standards,"^",iLoop)
 .s STRowId=$P($G(Standard),"||",1)
 .s ODChildSub=$P($G(Standard),"||",2)
 .s ODSChildSub=$P($G(Standard),"||",3)
 .Q:(""=STRowId)||(""=ODChildSub)
 .s ODDesc=$P($G(^DHCPEST(STRowId,"OD",ODChildSub)),"^",1)
 .i ODSChildSub'="" d
 ..s ODSTextVal=$P($G(^DHCPEST(STRowId, "OD", ODChildSub, "ODS", ODSChildSub)), "^", 2)
 ..s RLTODDR=STRowId_"||"_ODChildSub
 ..s ^DHCPETMPPQ("OrderDetail", RLTODDR)=0
 ..s ^DHCPETMPPQ("OrderDetailList", RLTODDR)=1+$G(^DHCPETMPPQ("OrderDetailList", RLTODDR))
 ..s ^DHCPETMPPQ("OrderDetailList", RLTODDR, ^DHCPETMPPQ("OrderDetailList", RLTODDR))=ODSTextVal
 ..s ODSTextVal=$ZCVT(ODSTextVal,"U")
 ..s ^DHCPETMPPQ("ResultText", ODSTextVal, RLTODDR)=0
 .e  d
 ..s RLTODDR=STRowId_"||"_ODChildSub
 ..s ^DHCPETMPPQ("OrderDetail", RLTODDR)=1
 ..s ^DHCPETMPPQ("OrderDetailList", RLTODDR)=1
 ..s ^DHCPETMPPQ("OrderDetailList", RLTODDR, 1)=ODDesc
 

 i DateFrom=""  s DateFrom=0
 i DateTo=""  s DateTo=+$h
 s DateBegin=DateFrom
 s DateEnd=DateTo
 s:(0'=+DateBegin) DateBegin=$O(^DHCPEIADM(0,"AdmDateTime",DateBegin),-1)
 s IADMAdmDate=+DateBegin
 f  s IADMAdmDate=$O(^DHCPEIADM(0, "AdmDateTime", IADMAdmDate)) q:((""'=DateEnd)&(IADMAdmDate>+DateEnd)||(""=IADMAdmDate))  d
 .s IADMAdmTime=0
 .f  s IADMAdmTime=$O(^DHCPEIADM(0, "AdmDateTime", IADMAdmDate, IADMAdmTime)) q:(""=IADMAdmTime)  d
 ..s IAdmRowId=0
 ..f  s IAdmRowId=$O(^DHCPEIADM(0, "AdmDateTime", IADMAdmDate, IADMAdmTime, IAdmRowId)) q:(""=IAdmRowId)  d
 ...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IAdmRowId)          
 ...q:LocFlag=1
 ...s Status=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
 ...Q:'(("ARRIVED"=Status)||("COMPLETED"=Status))
 ...s ADM=$P($g(^DHCPEIADM(IAdmRowId)),"^",1)
 ...Q:ADM=""
 ...s PIADMVIP = ##class(web.DHCPE.PreCommon).GetVIPLevel("IADM",IAdmRowId)
 ...s TVIPlevel=$P(PIADMVIP,"^",1)
 ...q:(VIPLevel'="")&&(VIPLevel'=TVIPlevel)
 ...;s PIADMVIP=$P(PIADMVIP,"^",2)
 ...s GADM=$P($g(^DHCPEIADM(IAdmRowId)),"^",2)
 ...q:(GroupID'="")&&(GroupID'=GADM)
 ...// 取患者信息
 ...s PapmiNo=$p($g(^PAADM(ADM)),"^",1)
 ...s PAPMIIPNo=$p(^PAPER(PapmiNo,"PAT",1),"^",1)
 ...Q:(""'=RegNo)&(RegNo'=PAPMIIPNo)
 ...s PAPMIName=$p(^PAPER(PapmiNo,"ALL"),"^",1)
 ...Q:(""'=PatName)&(PAPMIName'[PatName)
 ...s Sex=$p($g(^PAPER(PapmiNo,"ALL")),"^",7)
 ...i ""'=Sex s Sex=$p($g(^CT("SEX",Sex)),"^",2)
 ...s PAPMIDOB=$p($g(^PAPER(PapmiNo,"ALL")),"^",6)
 ...i ""'=PAPMIDOB s PAPMIDOB=##class(websys.Conversions).DateLogicalToHtml(PAPMIDOB)
 ...
 ...s ^DHCPETMPPQ("PosQuery","Total")=+$G(^DHCPETMPPQ("PosQuery","Total"))+1
 ...s ^DHCPETMPPQ("PosQuery","Sex",Sex)=+$G(^DHCPETMPPQ("PosQuery","Sex",Sex))+1
 ...s ODDR=0
 ...f  s ODDR=$O(^DHCPETMPPQ("OrderDetail", ODDR)) Q:(""=ODDR)  d
 ....i $g(^DHCPETMPPQ("OrderDetail",ODDR))=1 d
 .....s RLTRowId=0
 .....f  s RLTRowId=$O(^DHCPERLT(0,"PAADM_OD",ADM, ODDR, RLTRowId)) Q:(""=RLTRowId)  d
 ......s Result=$P(^DHCPERLT(RLTRowId), "^", 4)
 ......Q:(""=Result) // 防止空的值
 ......s Normal=$P(^DHCPERLT(RLTRowId), "^", 7)
 ......Q:+Normal'=0
 ......s STRowId=$p(ODDR,"||",1)
 ......s ODChildSub=$p(ODDR,"||",2)
 ......s ODDesc=$P($G(^DHCPEST(STRowId,"OD",ODChildSub)),"^",1)
 ......s ^DHCPETMPPQ("ADM", ADM, ODDR, ODDesc)=0
 ....i $g(^DHCPETMPPQ("OrderDetail",ODDR))=0 d
 .....s RLTRowId=0
 .....f  s RLTRowId=$O(^DHCPERLT(0,"PAADM_OD",ADM, ODDR, RLTRowId)) Q:(""=RLTRowId)  d
 ......s Result=$P(^DHCPERLT(RLTRowId), "^", 4)
 ......Q:(""=Result) // 防止空的值
 ......s ODResult=Result
 ......s ODType=$p($G(^DHCPEST($p(ODDR,"||",1),"OD",$p(ODDR,"||",2))),"^",2)
 ......i (ODType="C")||(ODType="N") d
 .......s ODSChildSub=0
 .......f  s ODSChildSub=$o(^DHCPEST($p(ODDR,"||",1),"OD",$p(ODDR,"||",2),"ODS",ODSChildSub)) q:ODSChildSub=""  d
 ........s ODSRowId=ODDR_"||"_ODSChildSub
 ........s ODSMin=$p(^DHCPEST($p(ODDR,"||",1),"OD",$p(ODDR,"||",2),"ODS",ODSChildSub),"^",4)
 ........s ODSMax=$p(^DHCPEST($p(ODDR,"||",1),"OD",$p(ODDR,"||",2),"ODS",ODSChildSub),"^",5)
 ........s ODSSex=$p(^DHCPEST($p(ODDR,"||",1),"OD",$p(ODDR,"||",2),"ODS",ODSChildSub),"^",1)
 ........s ODSTextVal=$p(^DHCPEST($p(ODDR,"||",1),"OD",$p(ODDR,"||",2),"ODS",ODSChildSub),"^",2)
 ........q:ODSTextVal=""
 ........i (+ODResult>=+ODSMin)&&(+ODResult<=+ODSMax)  s Result=ODSTextVal 
 ......Q:(0=$D(^DHCPETMPPQ("ResultText", Result, ODDR)))
 ......s ^DHCPETMPPQ("ADM", ADM, ODDR, Result)=0

 s TotalPerson=+$G(^DHCPETMPPQ("PosQuery","Total"))
 s Data=$lb("","体检总人数",TotalPerson, "患病率", "")
 ;d PosQuery
 
 
 s ADM=0
 f  s ADM=$O(^DHCPETMPPQ("ADM", ADM)) Q:(""=ADM)  d
 .s PapmiNo=$p($g(^PAADM(ADM)),"^",1)
 .s PAPMIIPNo=$p(^PAPER(PapmiNo,"PAT",1),"^",1)
 .Q:(""'=RegNo)&(RegNo'=PAPMIIPNo)
 .s PAPMIName=$p(^PAPER(PapmiNo,"ALL"),"^",1)
 .Q:(""'=PatName)&(PAPMIName'[PatName)
 .s Sex=$p($g(^PAPER(PapmiNo,"ALL")),"^",7)
 .i ""'=Sex s Sex=$p($g(^CT("SEX",Sex)),"^",2)
 .s PAPMIDOB=$p($g(^PAPER(PapmiNo,"ALL")),"^",6)
 .i ""'=PAPMIDOB s PAPMIDOB=##class(websys.Conversions).DateLogicalToHtml(PAPMIDOB)
 .i ("A"'=QueryType) d
 ..s ^DHCPETMPPQ("PosQuery","HaveIllness")=+$G(^DHCPETMPPQ("PosQuery","HaveIllness"))+1
 ..s ^DHCPETMPPQ("PosQuery","HaveIllness",Sex)=+$G(^DHCPETMPPQ("PosQuery", "HaveIllness",Sex))+1
 .Q:("A"'=QueryType)
 .s AFlag=1
 .s ODDR=""
 .f  s ODDR=$O(^DHCPETMPPQ("OrderDetailList", ODDR)) Q:(""=ODDR)||(AFlag=0)  d
 ..s iLLoop=0
 ..f  s iLLoop=$O(^DHCPETMPPQ("OrderDetailList", ODDR, iLLoop)) Q:(""=iLLoop)||(AFlag=0)  d
 ...s Result=$G(^DHCPETMPPQ("OrderDetailList", ODDR, iLLoop))
 ...s:(0=$D(^DHCPETMPPQ("ADM", ADM, ODDR, Result))) AFlag=0
 .i (1=AFlag) d
 ..s ^DHCPETMPPQ("PosQuery","HaveIllness")=+$G(^DHCPETMPPQ("PosQuery","HaveIllness"))+1
 ..s ^DHCPETMPPQ("PosQuery","HaveIllness",Sex)=+$G(^DHCPETMPPQ("PosQuery", "HaveIllness",Sex))+1

 
 s HaveIllPerson=+$G(^DHCPETMPPQ("PosQuery","HaveIllness"))
 s TotalPerent=0
 i +$G(^DHCPETMPPQ("PosQuery","Total"))'=0 d
 .s TotalPerent=+$FN(+$G(^DHCPETMPPQ("PosQuery","HaveIllness"))/(+$G(^DHCPETMPPQ("PosQuery","Total")))*100,"",2)
 s TotalPerent=TotalPerent_"%"
 s Data=$lb("","患病总人数",HaveIllPerson, TotalPerent, "")
 ;d PosQuery
 
 s IllSexTotalStr=""
 s IllSex=""
 f  s IllSex=$O(^DHCPETMPPQ("PosQuery","HaveIllness",IllSex )) Q:(""=IllSex)  d
 .s IllSexTotal=^DHCPETMPPQ("PosQuery","HaveIllness",IllSex )
 .s SexTotal=^DHCPETMPPQ("PosQuery","Sex",IllSex)
 .s SexPercent=$FN(IllSexTotal/SexTotal*100,"",2)_"%"
 .s Data=$lb("", IllSex_"性患病总人数", IllSexTotal, SexPercent, "")
 .i IllSexTotalStr="" s IllSexTotalStr=IllSex_"性患病总人数:"_IllSexTotal_"人,"_IllSex_"性患病率:"_SexPercent
 .e  s IllSexTotalStr=IllSexTotalStr_","_IllSex_"性患病总人数:"_IllSexTotal_"人,"_IllSex_"性患病率:"_SexPercent
 .; PosQuery

 w "<br><font color = blue size=2 >体检总人数:"_TotalPerson_"人,患病总人数:"_HaveIllPerson_"人,患病率:"_TotalPerent_","_IllSexTotalStr_"</font>"
 s ADM=0
 f  s ADM=$O(^DHCPETMPPQ("ADM", ADM)) Q:(""=ADM)  d
 .// 取患者信息
 .s PapmiNo=$p($g(^PAADM(ADM)),"^",1)
 .// 登记号 
 .s PAPMIIPNo=$p(^PAPER(PapmiNo,"PAT",1),"^",1)
 .Q:(""'=RegNo)&(RegNo'=PAPMIIPNo)
 .// 姓名 
 .s PAPMIName=$p(^PAPER(PapmiNo,"ALL"),"^",1)
 .Q:(""'=PatName)&(PAPMIName'[PatName)
 .// 性别 
 .s Sex=$p($g(^PAPER(PapmiNo,"ALL")),"^",7)
 .i ""'=Sex s Sex=$p($g(^CT("SEX",Sex)),"^",2)
 .// 出生日期 
 .s PAPMIDOB=$p($g(^PAPER(PapmiNo,"ALL")),"^",6)
 .i ""'=PAPMIDOB s PAPMIDOB=##class(websys.Conversions).DateLogicalToHtml(PAPMIDOB)
 .s Data=$lb(ADM,PAPMIIPNo, PAPMIName, Sex, PAPMIDOB)
 .d:("A"'=QueryType) PosQuery
 .
 .Q:("A"'=QueryType)
 .s AFlag=1
 .s ODDR=""
 .f  s ODDR=$O(^DHCPETMPPQ("OrderDetailList", ODDR)) Q:(""=ODDR)||(AFlag=0)  d
 ..s iLLoop=0
 ..f  s iLLoop=$O(^DHCPETMPPQ("OrderDetailList", ODDR, iLLoop)) Q:(""=iLLoop)||(AFlag=0)  d
 ...s Result=$G(^DHCPETMPPQ("OrderDetailList", ODDR, iLLoop))
 ...s:(0=$D(^DHCPETMPPQ("ADM", ADM, ODDR, Result))) AFlag=0
 .s Data=$lb(ADM,PAPMIIPNo, PAPMIName, Sex, PAPMIDOB)
 .d:(1=AFlag) PosQuery

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
PosQuery
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 q
}

ClassMethod PosQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PosQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {			
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod PosQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PosQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 辅助函数 生成HTML页面上的性别列表 CT_Sex
/// 使用 DHCPEDiagnosisCollect.csp
ClassMethod OutSexListToHTML(ContrlWidth As %String = "")
{
	s:(""=ContrlWidth) ContrlWidth="130"
	w "<select id=Sex name='select' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex=0>"
	w "<option value=''></option>"
	s SexId=0
	f  s SexId=$O(^CT("SEX",SexId)) Q:(""=SexId)  d
	.s CTSEXDesc=$P($G(^CT("SEX",SexId)),"^",2)
	.w "<option value='"_SexId_"'>"_CTSEXDesc_"</option>"
	w "</select>"
}

/// 辅助函数 生成HTML页面上的性别列表 CT_Sex
/// 使用 DHCPEDiagnosisCollect.csp
ClassMethod OutMarriedListToHTML(ContrlWidth As %String = "")
{
	s:(""=ContrlWidth) ContrlWidth="130"
	w "<select id=Married name='select' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex=0>"
	w "<option value=''></option>"
	s MarriedId=0
	f  s MarriedId=$O(^CT("MAR",MarriedId)) Q:(""=MarriedId)  d
	.s CTMarriedDesc=$P($G(^CT("MAR",MarriedId)),"^",2)
	.w "<option value='"_MarriedId_"'>"_CTMarriedDesc_"</option>"
	w "</select>"
}

/// 查询指定患者的阳性特征
/// 只要客户的结果录入就进入统计
Query SearchADMPosQuery(ADMID As %Library.String = "", Standards As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "") As %Query(ROWSPEC = "ST_Desc:%String, OD_Desc:%String, ODS_TextVal:%String, SAQ_IsSelect:%String")
{
}

ClassMethod SearchADMPosQueryExecute(ByRef qHandle As %Binary, ADMID As %Library.String = "", Standards As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	k ^DHCPETMPSAQ
	
	f iLoop=1:1:$l(Standards,"^") d
	.s Standard=$P(Standards,"^",iLoop)
	.Q:(""=Standard)
	.
	.// DHC_PE_Station.{ ST_RowId }
	.s STRowId=$P($G(Standard),"||",1)
	.// DHC_PE_OrderDetail.{ OD_ChildSub }
	.s ODChildSub=$P($G(Standard),"||",2)
	.s ODDesc=$P($G(^DHCPEST(STRowId,"OD",ODChildSub)),"^",1)
	.// DHC_PE_ODStandard.{ ODS_ChildSub }
	.s ODSChildSub=$P($G(Standard),"||",3)
	.Q:(""=STRowId)||(""=ODChildSub)
	.
	.// DHC_PE_ODStandard.{ ODS_TextVal }
	.i (""'=ODSChildSub) s ODSTextVal=$P($G(^DHCPEST(STRowId, "OD", ODChildSub, "ODS", ODSChildSub)), "^", 2)
	.e  s ODSTextVal=ODDesc
	.// DHC_PE_Result.{ RLT_OD_DR }=DHC_PE_ODStandard.{ ODS_ParRef }
	.s RLTODDR=STRowId_"||"_ODChildSub
	.// DHC_PE_ODStandard.{ ODS_NatureValue }
	.s ^DHCPETMPSAQ("OrderDetail", RLTODDR, ODSTextVal)=0
	
	Set repid=$I(^CacheTemp)
 	s ind=1
	s:ADMID="" ADMID=0
	s IAdmRowId=0
	f  s IAdmRowId=$O(^DHCPEIADM(0, "PAADM", ADMID, IAdmRowId)) q:(""=IAdmRowId)  d
	.
	.// DHC_PE_IADM.{ IADM_Status }
	.s Status=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
	.Q:'(("ARRIVED"=Status)||("COMPLETED"=Status))
	.
	.
	.//IADM_RegDate	DHC_PE_IADM	登记日期
	.s RegDate=+$p($g(^DHCPEIADM(IAdmRowId)),"^",5)
	.q:(""'=DateFrom)&(RegDate<DateFrom)
	.q:(""'=DateTo)&(RegDate>DateTo)
	.
	.
	.// DHC_PE_Result.{ RLT_RowId }
	.s SSRRLTDR=0
	.f  s SSRRLTDR=$O(^DHCPERLT(0,"ADM", ADMID, SSRRLTDR)) Q:(""=SSRRLTDR)  d
	..// DHC_PE_Result.{ RLT_Normal }
	..s RLTNormal=+$P($G(^DHCPERLT(SSRRLTDR)),"^",7)
	..Q:(0'=+RLTNormal)  // 过滤正常体征
	..
	..// DHC_PE_Result.{ RLT_Result } -> DHC_PE_ODStandard.{ ODS_TextVal }
	..s RLTResult=$P($G(^DHCPERLT(SSRRLTDR)),"^",4)
	..Q:(""=RLTResult)
	..s Result=RLTResult
	..s RLTODDR=$P($G(^DHCPERLT(SSRRLTDR)),"^",3)
	..s flag=1
    ..s ODType=$p($G(^DHCPEST($p(RLTODDR,"||",1),"OD",$p(RLTODDR,"||",2))),"^",2)
	..s ODSChildSub=0
	..f  s ODSChildSub=$o(^DHCPEST($p(RLTODDR,"||",1),"OD",$p(RLTODDR,"||",2),"ODS",ODSChildSub)) q:ODSChildSub=""  d
	...s ODSRowId=RLTODDR_"||"_ODSChildSub
	...i (ODType="C")||(ODType="N") d
	....s ODSMin=$p(^DHCPEST($p(RLTODDR,"||",1),"OD",$p(RLTODDR,"||",2),"ODS",ODSChildSub),"^",4)
	....s ODSMax=$p(^DHCPEST($p(RLTODDR,"||",1),"OD",$p(RLTODDR,"||",2),"ODS",ODSChildSub),"^",5)
	....s ODSSex=$p(^DHCPEST($p(RLTODDR,"||",1),"OD",$p(RLTODDR,"||",2),"ODS",ODSChildSub),"^",1)
	....s ODSTextVal=$p(^DHCPEST($p(RLTODDR,"||",1),"OD",$p(RLTODDR,"||",2),"ODS",ODSChildSub),"^",2)
	....q:ODSTextVal=""
	....i (+RLTResult>=+ODSMin)&&(+RLTResult<=+ODSMax) d
	.....s RLTResult=ODSTextVal
	.....s Result=ODSTextVal
    ...s ODSTextVal=$p(^DHCPEST($p(RLTODDR,"||",1),"OD",$p(RLTODDR,"||",2),"ODS",ODSChildSub),"^",2)
    ...i ODSTextVal=RLTResult s flag=0
    
    
	..s SID=$P(RLTODDR,"||",1)
	..s STDesc=$P($G(^DHCPEST(SID)), "^", 2)
	..Q:(""=STDesc)
	..s ODChildSub=$P(RLTODDR,"||",2)
	..Q:(""=SID)||(""=ODChildSub)
	..s ODDesc=$P($G(^DHCPEST(SID,"OD",ODChildSub)), "^", 1) 
	..Q:(""=ODDesc)
	..i flag=1 s RLTResult=ODDesc

	
	..
	..// 显示当前体检人所有的体征, 用*标示选择的体征
	..s IsSelect=""
	..s:(0'=$D(^DHCPETMPSAQ("OrderDetail", RLTODDR, RLTResult))) IsSelect="*"
	..
	..
	..d SearchADMPosQuery
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SearchADMPosQuery
	set Data=$lb(STDesc, ODDesc, Result, IsSelect)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchADMPosQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchADMPosQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {			
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchADMPosQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchADMPosQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query QueryPos(ODDR As %Library.String = "", SResult As %Library.String = "", EResult As %Library.String = "", SDate As %Library.String = "", EDate As %Library.String = "") As %Query(ROWSPEC = "PAADM:%String, TRegNo:%String, TName:%String, TDate:%String, TResult:%String,TAge:%String,TTel:%String,TSex:%String")
{
}

ClassMethod QueryPosExecute(ByRef qHandle As %Binary, ODDR As %Library.String = "", SResult As %Library.String = "", EResult As %Library.String = "", SDate As %Library.String = "", EDate As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s User=%session.Get("LOGON.USERID")
 	k ^DHCPETMPQueryPos(User,"QueryPos")
	s Total=0
	s i=0
 	i ODDR=""
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	i SResult="" s SResult=0
 	i EResult="" s EResult=1000000000000000000
 	
 	i SDate'="" s SDate=##class(websys.Conversions).DateHtmlToLogical(SDate) 
 	i EDate'="" s EDate=##class(websys.Conversions).DateHtmlToLogical(EDate) 
 	
 	i SDate="" s SDate=0
 	i EDate="" s EDate=+$H
 	s PAADM=0
 	f  s PAADM=$O(^DHCPERLT(0,"PAADM_OD",PAADM)) q:PAADM=""  d
 	.q:'$D(^DHCPERLT(0,"PAADM_OD",PAADM,ODDR))
 	.d Reset
 	.s RltID=0
 	.
 	.f  s RltID=$O(^DHCPERLT(0,"PAADM_OD",PAADM,ODDR,RltID)) q:RltID=""  d
 	..q:'$D(^DHCPERLT(RltID))
 	..s TDate=$P($G(^DHCPERLT(RltID)),"^",6)
 	..q:(TDate<SDate)||(TDate>EDate)
 	..s Total=Total+1
 	..s TResult=$P($G(^DHCPERLT(RltID)),"^",4)
 	..q:(TResult<SResult)||(TResult>EResult)
 	..d GetOneInfo
 	w "这段时间总"_Total_"人检查此项,符合条件"_i_"人"
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetOneInfo
	s PerID=$P($G(^PAADM(PAADM)),"^",1)
	s TName=$P($G(^PAPER(PerID,"ALL")),"^",1)
	s TRegNo=$P($G(^PAPER(PerID,"PAT",1)),"^",1)
	S Sex="",Tel=""
	s Age=##class(web.DHCBillInterface).GetPapmiAge(PerID)
	s PIBIDR=$O(^DHCPEPreIBI(0,"PAPMINo",TRegNo,0))
	i ""'=PIBIDR  d
    .s Tel1=$p($g(^DHCPEPreIBI(PIBIDR)),"^",8) //联系电话 
	.s Tel2=$p($g(^DHCPEPreIBI(PIBIDR)),"^",6) 
	.i Tel2="" s Tel2=$p($g(^DHCPEPreIBI(PIBIDR)),"^",7)
	.i Tel1'=""  S Tel=Tel1
	.e  s Tel=Tel2
	.s SexDR=$p($g(^DHCPEPreIBI(PIBIDR)),"^",3)

	i SexDR'="" s Sex=$P(^CT("SEX",SexDR),"^",2)

	s TDate=##class(websys.Conversions).DateLogicalToHtml(TDate)
	s i=i+1
	d Build
	q

Reset
	s (TRegNo, TName, TDate, TResult,Age,Tel,Sex)=""
	q 
Build
	set Data=$lb(PAADM, TRegNo, TName, TDate, TResult,Age,Tel,Sex)
		s ^DHCPETMPQueryPos(User,"QueryPos","List",ind)=TRegNo_"^"_TName_"^"_Age_"^"_Sex_"^"_Tel_"^"_TDate_"^"_TResult
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPosExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetQueryPosRows(User)
{
 
 s iLLoop=0 ,Rows=0
 f  s iLLoop=$O(^DHCPETMPQueryPos(User,"QueryPos","List",iLLoop)) Q:(""=iLLoop)  d
 .s Rows=Rows+1
 q Rows
}

ClassMethod GetQueryPosData(User, i)
{
	
	q:'$d(^DHCPETMPQueryPos(User,"QueryPos","List",i)) ""
	q $g(^DHCPETMPQueryPos(User,"QueryPos","List",i))
}

/*
Query QueryPos(ODDR,SResult,EResult,SDate,EDate) As %SQLQuery(ROWSPEC = "RLT_ADM_DR:%String, RLT_Result:%String")
{
	select RLT_ADM_DR,RLT_Result from dhc_pe_result where ((rlt_od_dr=:ODDR) and (+rlt_result<:EResult and +rlt_result>:SResult) )
}*/
Query FromDescOrderDetail(Desc As %Library.String = "") As %SQLQuery(ROWSPEC = "OD_Desc:%String:名称, OD_Code:%String:编码, OD_RowId:%String:ID,OD_Type:%String:类型")
{
	select OD_Desc, OD_Code, OD_RowId,OD_Type
	from DHC_PE_OrderDetail
	where OD_Desc like '%'||:Desc||'%'
}

Query FromDescOrderDetailA() As %SQLQuery(ROWSPEC = "OD_Desc:%String, OD_Code:%String, OD_RowId:%String,OD_Type:%String")
{
	select OD_Desc, OD_Code, OD_RowId,OD_Type
	from DHC_PE_OrderDetail
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.PosQuery","FromDescOrderDetailB")
Query FromDescOrderDetailB(CTLOCID As %String = "") As websys.Query(ROWSPEC = "OD_Desc:%String,OD_Code:%String,OD_RowId:%String,OD_Type:%String")
{
}

ClassMethod FromDescOrderDetailBExecute(ByRef qHandle As %Binary, CTLOCID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s StId=0
	f  s StId=$o(^DHCPEST(StId)) q:StId=""  d
	.s LocShowDFlag = ##class(User.DHCPEStation).GetLocShowDataFlag(StId,CTLOCID)
	.q:LocShowDFlag'="Y"
	.s sub=0
	.f  s sub=$o(^DHCPEST(StId,"OD",sub)) q:sub=""  d
	..s ODID=StId_"||"_sub
	..s LocShowDFlag=##class(User.DHCPEOrderDetail).GetLocShowDataFlag(ODID,CTLOCID)
	..q:LocShowDFlag="N"
	..s ODDesc=$P($g(^DHCPEST(StId,"OD",sub)),"^",1)
	..s ODCode=$p($g(^DHCPEST(StId,"OD",sub)),"^",11)
	..s ODType=$P($g(^DHCPEST(StId,"OD",sub)),"^",2)
	..
	..Set Data=$lb(ODDesc, ODCode, ODID, ODType)
	..Set ^CacheTemp(repid,ind)=Data
 	..Set ind=ind+1
	
	Quit $$$OK
}

Storage Default
{
<Data name="PosQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCP.PosQueryD</DataLocation>
<DefaultData>PosQueryDefaultData</DefaultData>
<IdLocation>^web.DHCP.PosQueryD</IdLocation>
<IndexLocation>^web.DHCP.PosQueryI</IndexLocation>
<StreamLocation>^web.DHCP.PosQueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
