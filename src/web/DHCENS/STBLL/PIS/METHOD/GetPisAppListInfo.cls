Class web.DHCENS.STBLL.PIS.METHOD.GetPisAppListInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：lipan
/// CreatDate：2016—06-17
/// Description:获取病理申请单信息
/// Table：
/// Input：医嘱号
/// w ##class(web.DHCENS.STBLL.PIS.METHOD.GetPisAppListInfo).SendAppBillNew("48||2").Read()
ClassMethod SendAppBillNew(OrdRowIDs As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	quit:OrdRowIDs="" 0
	set request=##class(web.DHCENS.STBLL.PIS.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.PIS.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set request.header=header
	set body=##class(web.DHCENS.STBLL.PIS.MODEL.Body).%New()	
	set OrRowid=$p(OrdRowIDs,"^",1)
	;set APPString=##Class(web.DHCAPPPisInterface).ToPisSystem(OrRowid)
	set APPString=##class(web.DHCDocAPPBL).ToPisSystem(OrRowid)

	set Mainobj=##class(web.DHCENS.STBLL.PIS.MODEL.PISAPPMainInfo).%New()
	
	set CardNo=""
	set admRowId=$p($g(^OEORD(+OrRowid)),"^",1)
	set patRowId=$p($g(^PAADM(admRowId)),"^",1)
	set LocDr=$p($g(^PAADM(admRowId)),"^",4)
	set HospDr=$p($g(^CTLOC(LocDr)),"^",22)
	set:HospDr'="" Mainobj.HospitalCode=$p($g(^CT("HOSP",HospDr)),"^",1)
	set:HospDr'="" Mainobj.HospitalDesc=$p($g(^CT("HOSP",HospDr)),"^",2)	
	set Mainobj.RegNo                         =$p(APPString,"^",1) 
	set Mainobj.Name                          =$p(APPString,"^",2) 
	set Mainobj.SexCode                       =$p(APPString,"^",3) 
	set Mainobj.SexDesc=..GetSexDescByCode(Mainobj.SexCode)
	set Mainobj.Age                           =$p(APPString,"^",4) 
	set Mainobj.PatDeptCode                   =$p(APPString,"^",5) 
	set Mainobj.PatDeptDesc=..GetLocDescByCode(Mainobj.PatDeptCode) 
	set Mainobj.PatWardCode                   =$p(APPString,"^",6) 
	set Mainobj.PatWardDesc=..GetWardDescByCode(Mainobj.PatWardCode)
	set Mainobj.PatBedNO                      =$p(APPString,"^",7) 
	set Mainobj.Telephone                     =$p(APPString,"^",8) 
	set Mainobj.BirthDay                      =$p(APPString,"^",9) 
	set Mainobj.PATIdentityNum=$p($g(^PAPER(patRowId,"PAT",3)),"^",6)
	set CredentialTypeRowID=$p($g(^PAPER(patRowId,"PAT",3)),"^",7) 
	set:CredentialTypeRowID'="" Mainobj.identyTypeCode=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",1)
	set:CredentialTypeRowID'="" Mainobj.identyTypeDesc=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",2)
	set Mainobj.Address                       =$p(APPString,"^",10) 
	set Mainobj.OrdDeptCode                   =$p(APPString,"^",11) 
	set Mainobj.OrdDeptDesc=..GetLocDescByCode(Mainobj.OrdDeptCode)
	set Mainobj.FeeType                       =$p(APPString,"^",12) 
	set Mainobj.DocumentID                    =$p(APPString,"^",13) 
	set Mainobj.AppCode                       =$p(APPString,"^",14) 
	set Mainobj.AppName                       =$p(APPString,"^",15) 
	set Mainobj.OrdDoctorCode                 =$p(APPString,"^",16) 
	set Mainobj.OrdDoctorName                 =$p(APPString,"^",17) 
	set Mainobj.OrdDate                       =$p(APPString,"^",18) 
	set Mainobj.OrdTime                       =$p(APPString,"^",19) 
	set Mainobj.AdmRowID                      =$p(APPString,"^",20) 
	set Mainobj.OrdHospital=Mainobj.HospitalDesc 
	set AdmType=$p($g(^PAADM(admRowId)),"^",2)
	set Mainobj.PAADMTypeCode= AdmType
	set Mainobj.PAADMTypeDesc= $case(AdmType,"O":"门诊","I":"住院","E":"急诊","H":"体检",:"其他")
	set appBillList=##class(web.DHCENS.STBLL.PIS.MODEL.PISOrdInfo).%New()
	set length=$l(OrdRowIDs,"^")
	for i=1:1:length {	
		set appBill=##class(web.DHCENS.STBLL.PIS.MODEL.PISSpecInfo).%New()
		set appBill = ..GetAppBillByOrder($p(OrdRowIDs,"^",i)) //获取申请单对象
		d appBillList.PISOrdInfo.Insert(appBill)
	}
	
   	set Mainobj.OrdListInfo=(appBillList)			
	set body.PISAppBills=Mainobj
		
    set request.body=body
	d request.XMLExportToStream(.stream)
	q stream
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

ClassMethod GetAppBillByOrder(OrdID As %String) As web.DHCENS.STBLL.PIS.MODEL.PISSpecInfo
{
	set $zt="Exception"
	set Obj=##class(web.DHCENS.STBLL.PIS.MODEL.PISSpecInfo).%New()
	;set APPString=##Class(web.DHCAPPPisInterface).ToPisSystem(OrdID)
	set APPString=##class(web.DHCDocAPPBL).ToPisSystem(OrdID)
	s Obj.AppID=$p(APPString,"^",21) 
	s Obj.OperationInfo=$p(APPString,"^",22) 
	s Obj.TumorInfo=$p(APPString,"^",23) 
	s Obj.GynecologyInfo=$p(APPString,"^",24) 
	s Obj.ClinicInfo=$p(APPString,"^",25) 
	s Obj.IsUrgent=$p(APPString,"^",26) 
	s Obj.IsFrozen=$p(APPString,"^",27)
	s SysDateFormat=##class(websys.Conversions).DateFormat() 
	s Obj.SpecOffDateTime=..FormatDateTime($p(APPString,"^",28)) 
	s Obj.SpecFixedDateTime=..FormatDateTime($p(APPString,"^",29))
	s Obj.SamplingDeptDesc=$p(APPString,"^",30)  
	s Obj.SamplingDeptCode=..GetLocCodeByDesc(Obj.SamplingDeptDesc)
	s Obj.SamplingDoctorDesc=$p(APPString,"^",31) 
	s Obj.SamplingDoctorCode=..GetUserCodeByDesc(Obj.SamplingDoctorDesc)
	s Obj.SamplingDateTime=..FormatDateTime($p(APPString,"^",32)) 
	s Obj.InfectionInfo=$p(APPString,"^",33) 
	s Obj.DocumentInfo=$p(APPString,"^",34) 
	s Obj.HumanPapillomavirusDateTime=..FormatDateTime($p(APPString,"^",35)) 
	s Obj.TestMethod=$p(APPString,"^",36) 
	s Obj.ClinicalDiagnosis=$p(APPString,"^",37) 
	s Obj.Treatment=$p(APPString,"^",38) 
	s Obj.GeneralSpecExamination=$p(APPString,"^",39) 
	s Obj.ConsultationRequirements=$p(APPString,"^",40) 
	s Obj.ConsultationDoctor=$p(APPString,"^",41) 
	s Obj.SamplingPosition=$p(APPString,"^",42) 
	s Obj.SamplingType=$p(APPString,"^",43) 
	s Obj.DOTFOTD=$p(APPString,"^",44) 
	s Obj.MedicalHistory=$p(APPString,"^",45) 
	s Obj.ClinicPhysicalExam=$p(APPString,"^",46) 
	s Obj.AutopsyInfo=$p(APPString,"^",47) 
	s SpecInfo=$p(APPString,"^",48)
	s SpecLen=$l(SpecInfo,$c(2))
	for SpecNum=1:1:SpecLen
	{
		s SpecDetailInfo=$p(SpecInfo,$c(2),SpecNum)
		s SpecDetailObj=##class(web.DHCENS.STBLL.PIS.MODEL.PISSpecDetailInfo).%New()
		s SpecDetailObj.SpecNO=$p(SpecDetailInfo,$c(1),1)	
		s SpecDetailObj.SpecName=$p(SpecDetailInfo,$c(1),2)	
		s SpecDetailObj.SpecPosition=$p(SpecDetailInfo,$c(1),3)	
		s SpecDetailObj.SpecQty=$p(SpecDetailInfo,$c(1),4)	
		s SpecDetailObj.OriginalNO=$p(SpecDetailInfo,$c(1),5)	
		s SpecDetailObj.SepDate=..FormatDateTime($p(SpecDetailInfo,$c(1),6))	
		s SpecDetailObj.FixDate=..FormatDateTime($p(SpecDetailInfo,$c(1),7))	
		d Obj.SpecInfo.Insert(SpecDetailObj)
	}
	s OrdInfoString=$p(APPString,"^",49)
	s OrdInfoCount=$l(OrdInfoString,"@")
	f tmpOrdNum=1:1:OrdInfoCount
	{
		s tmpOrdInfoString=""
		s OrdInfoObj=##class(web.DHCENS.STBLL.PIS.MODEL.PISOrdInfo).%New()
		s tmpOrdInfoString=$p(OrdInfoString,"@",tmpOrdNum)
		q:tmpOrdInfoString=""
		s ArcimRowid=$p(tmpOrdInfoString,"#",4)
		s:ArcimRowid'="" Obj.OrdCode=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",1)
		s Obj.OrdRowID=$p(tmpOrdInfoString,"#",5)
		s Obj.OrdDesc=$p(tmpOrdInfoString,"#",1)
	}
	s Obj.TraDoctorCode=$p(APPString,"^",51) 
	s Obj.ExamType=$p(APPString,"^",52)
	s Obj.PisCutBasType=$p(APPString,"^",54)
	s Adm=$p($g(^OEORD(+OrdID)),"^",1)
	s MrAdm=$p($g(^PAADM(Adm)),"^",61)
	set PhySiCycleId=$p($g(^MR(MrAdm,"DHC")),"^",9)
	set:PhySiCycleId'="" Obj.PhysiCycleCode=$p($g(^DHCPHYC(PhySiCycleId)),"^",1) //生理周期代码
	set:PhySiCycleId'="" Obj.PhysiCycle=$p($g(^DHCPHYC(PhySiCycleId)),"^",2) //生理周期描述
	s Obj.RISRSystemType="PIS" //系统类型
	set RecDeptRowID = $p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),3)),"^",6)
    set:RecDeptRowID'="" Obj.PISRRAcceptDeptCode= $p($g(^CTLOC(RecDeptRowID)),"^",1) 
    set:RecDeptRowID'="" Obj.PISRRAcceptDeptDesc= $p($g(^CTLOC(RecDeptRowID)),"^",2) 
	s Obj.PISRPrice=..GetPrice(OrdID)
	s Obj.Purpose=$p(APPString,"^",55) //送检目的
	s Obj.TestItem=$p(APPString,"^",56) //分子病理申请单检测项目
	s Obj.OrignalDiag=$p(APPString,"^",39) ///病理会诊申请-病理原诊断
	if (Obj.ClinicalDiagnosis="")&&(##class(%Dictionary.MethodDefinition).%ExistsId("web.DHCSTKUTIL||GetMRDiagnosDesc"))
	{
		s Obj.ClinicalDiagnosis=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(Adm,"")
	}
	q Obj
Exception
	set obj=##class(web.DHCENS.STBLL.PIS.MODEL.PISSpecInfo).%New()
	q obj
}

/// Debug:w ##class(web.DHCENS.STBLL.PIS.METHOD.GetPisAppListInfo).GetSexDescByCode("1")
ClassMethod GetSexDescByCode(SexCode As %String) As %String
{
	q:SexCode="" ""
	set SexDesc=""
	set SexID=$o(^CT("SEX",0,"Code",SexCode,""))
	set:SexID'="" SexDesc=$p($g(^CT("SEX",SexID)),"^",2)
	q SexDesc
}

/// Debug:w ##class(web.DHCENS.STBLL.PIS.METHOD.GetPisAppListInfo).GetLocDescByCode("ZYMZ046")
ClassMethod GetLocDescByCode(LocCode As %String) As %String
{
	q:LocCode="" ""
	set LocDesc=""
	set LocID=$o(^CTLOC(0,"Code",LocCode,""))
	if LocID=""
	{
		s LocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),""))	
		s:LocID="" LocID=$o(^CTLOC(0,"Code",$zcvt(LocCode,"U"),""))	
	}
	set:LocID'="" LocDesc=$p($g(^CTLOC(LocID)),"^",2)
	q LocDesc
}

/// Debug:w ##class(web.DHCENS.STBLL.PIS.METHOD.GetPisAppListInfo).GetWardDescByCode("ZYYJ026")
ClassMethod GetWardDescByCode(WardCode As %String) As %String
{
	q:WardCode="" ""
	set WardDesc=""
	set WardID=$o(^PAWARD(0,"WARD_Code",WardCode,""))
	if WardID=""
	{
		s WardID=$o(^PAWARD(0,"WARD_Code",$$ALPHAUP^SSUTIL4(WardCode),""))	
		s:WardID="" WardID=$o(^PAWARD(0,"WARD_Code",$zcvt(WardCode,"U"),""))	
	}
	set:WardID'="" WardDesc=$p($g(^PAWARD(WardID)),"^",2)
	q WardDesc
}

/// Debug:w ##class(web.DHCENS.STBLL.PIS.METHOD.GetPisAppListInfo).GetLocCodeByDesc("急诊内科门诊")
ClassMethod GetLocCodeByDesc(LocDesc As %String) As %String
{
	q:LocDesc="" ""
	set LocCode=""
	set LocID=$o(^CTLOC(0,"Desc",LocDesc,""))
	if LocID=""
	{
		s LocID=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LocDesc),""))	
		s:LocID="" LocID=$o(^CTLOC(0,"Desc",$zcvt(LocDesc,"U"),""))	
	}
	set:LocID'="" LocCode=$p($g(^CTLOC(LocID)),"^",1)
	q LocCode
}

/// Debug:w ##class(web.DHCENS.STBLL.PIS.METHOD.GetPisAppListInfo).GetUserCodeByDesc("医生01")
ClassMethod GetUserCodeByDesc(UserDesc As %String) As %String
{
	q:UserDesc="" ""
	set UserCode=""
	set UserID=$o(^SSU("SSUSR",0,"SSUSR_Name",UserDesc,""))
	if UserID=""
	{
		s UserID=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(UserDesc),""))	
		s:UserID="" UserID=$o(^SSU("SSUSR",0,"SSUSR_Name",$zcvt(UserDesc,"U"),""))	
	}
	set:UserID'="" UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)
	q UserCode
}

ClassMethod GetPrice(rowid As %String) As %String
{
	set $zt="Exception"
    set EpissubtypeDR=""
    set tempRowid=##class(web.DHCENS.STBLL.UTIL.Common).ReplaceStr(rowid,"_","||")
    set tmpAdm=$p($g(^OEORD(+tempRowid)),"^",1)
    set EpissubtypeDR=$P($g(^PAADM(tmpAdm,1)),"^",6)
       
    // 取子医嘱中医嘱价格，当医嘱类型的子类是Price时，取医嘱表中OEORI_Price中价格，
    // 然后调用计费组方法set tmpchild=##CLASS(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeDR,"",childarcimId,$P(childordstr3,"^",7),"","","",$p(childordstr3,"^",25))
    set childIndex="",childOrdPrice=0
    set ord=+rowid
    set arcimId = $P($g(^OEORD(ord,"I",$p(rowid,"||",2),1)),"^",2)
    set arcSub = $P(arcimId,"||",1)
    set arcVer = $P(arcimId,"||",2)
    
    
    f  s childIndex=$o(^OEORDi(0,"OEORI",ord,tempRowid,childIndex))  q:childIndex=""  d
	.set childordstr1 = $g(^OEORD(ord,"I",childIndex,1))
	.set childordstr3 = $g(^OEORD(ord,"I",childIndex,3))
	.set childarcimId = $P(childordstr1,"^",2)
	.set ItmMastFirst=$p(childarcimId,"||",1)
	.set ItmMastLast=$p(childarcimId,"||",2)
	.set ItemCatRowID=$p($g(^ARCIM(ItmMastFirst,ItmMastLast,1)),"^",10)
	
    
	.set ItmCatType=$p($g(^ARC("IC",ItemCatRowID)),"^",7)
	.set tmpchild=0
	.i ItmCatType="P" d
	..set tmpchild=##CLASS(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeDR,"",childarcimId,$P(childordstr3,"^",7),"","","",$p(childordstr3,"^",25))
	.set childOrdPrice=+childOrdPrice++($P(tmpchild,"^",1))
	
	set OrdSubCatRowID=$p($g(^ARCIM(arcSub,arcVer,1)),"^",10)
    //取父医嘱价格信息，方式同取子医嘱类方法相同
	set CatType=$p($g(^ARC("IC",OrdSubCatRowID)),"^",7)
	set tmpPrice=""
	set VerifyDate=$P($g(^OEORD(ord,"I",$p(rowid,"||",2),3)),"^",7)
	set AdmID=$p($g(^OEORD(ord)),"^",1)
	q:AdmID="" ""
	set LocDr=$p($g(^PAADM(AdmID)),"^",4)
	q:LocDr="" ""
	set HospDr=$p($g(^CTLOC(LocDr)),"^",22)
	if (CatType="P") {
		s tmpPrice=$p(ordstr3,"^",25)
    	set price = ##CLASS(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeDR,"",arcimId,VerifyDate,"","","",+tmpPrice,HospDr)
	}
	else {
    	set price = ##CLASS(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeDR,"",arcimId,VerifyDate,"","","","",HospDr)
	}
    set TotalPrice=childOrdPrice+price
    Quit TotalPrice
Exception
	Quit "价格异常"
}

/// Creator：ZhangXinying
/// CreatDate：2022—06-17
/// Description:返回格式化日期信息
/// Table：
/// Input：HIS页面日期
/// Output:YYYY-MM-DD HH:MM:SS格式日期
/// Debug:w ##class(web.DHCENS.STBLL.PIS.METHOD.GetPisAppListInfo).FormatDateTime("26/07/2021 11:06:29")
ClassMethod FormatDateTime(DateT As %String) As %String
{
	s $zt="err"
	q:(DateT="")||(DateT=" ") ""
	s SysDateFormat=##class(websys.Conversions).DateFormat() 
	s Date="",Time="",DateNumDT="",FormatDate=""
	s:(DateT'="")&&(DateT[" ") DateNumDT=$zdth(DateT,SysDateFormat)
	s:DateNumDT'="" Date=$zd($p(DateNumDT,",",1),3)
	s:DateNumDT'="" Time=$zt($p(DateNumDT,",",2))
	s:Date'="" FormatDate=Date_" "_Time
	q FormatDate
err
	s $zt=""
	q "-1^"_$ze
}

}
