/// 类名：web.DHCENS.STBLL.LIS.METHOD.PatLisOrdInfo
/// 描述：取得检验医嘱信息
/// 编写者：WuXianPu
/// 编写日期：2012-10-31
Class web.DHCENS.STBLL.LIS.METHOD.PatLisOrdInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2012—05-09
/// Description：取得检验医嘱信息
/// Table：
/// Input： 1||1^1||2^……
/// Return：检验医嘱信息
/// Others: w ##class(web.DHCENS.STBLL.LIS.METHOD.PatLisOrdInfo).SendLisInfoByOrdRowID("297674||3@652937^297674||4@652937^297674||6^@652937").Read()
ClassMethod SendLisInfoByOrdRowID(ordids As %String) As %GlobalCharacterStream
{
	set $zt = "Exception"
	set request=##class(web.DHCENS.STBLL.LIS.MODEL.Request).%New()
	
	set header=##class(web.DHCENS.STBLL.LIS.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set request.header=header
	set body=##class(web.DHCENS.STBLL.LIS.MODEL.Body).%New()
	set OrRowid=$p($p(ordids,"@",1),"^",1)
	set AdmDr=$p(^OEORD(+OrRowid),"^",1)
	
	s invprtInfo=##class(web.DHCENS.STBLL.LIS.METHOD.PatLisOrdInfo).GetInvprtInfo(ordids)
	
	set PatDr=$P($g(^PAADM(AdmDr)),"^",1)
	set Pat=##class(web.DHCENS.STBLL.EMPI.MODEL.PaPatientNew).%New()
	set Pat=##class(web.DHCENS.STBLL.EMPI.METHOD.Patient).PAPatientByPatId(PatDr)
	set body.PATPatientInfo=Pat
	
	set Adm=##class(web.DHCENS.STBLL.EMPI.MODEL.PAAdmInfo).%New()
	set Adm=##class(web.DHCENS.STBLL.EMPI.METHOD.PAAdm).PAAdmInfoByAdm(AdmDr)
	;set Adm=##class(web.DHCENS.STBLL.EMPI.METHOD.PAAdm).PAAdmInfoByAdmToLIS(AdmDr)
	if invprtInfo'=""
	{
		set Adm.Charger=$p(invprtInfo,"^",2)
		set Adm.ChargeDate=$p(invprtInfo,"^",1)
	}
	set body.PATAdmInfo=Adm
	s dia=##class(web.DHCENS.STBLL.LIS.MODEL.DiagnosisList).%New()
	s dia=##class(web.DHCENS.STBLL.LIS.METHOD.PatLisOrdInfo).GetDia(AdmDr)
    set body.PAADMDiagnose=dia
	
	
    set objList = ##class(web.DHCENS.STBLL.LIS.MODEL.PatLisOrdListInfo).%New()
    
    s invprtid=$p($p(ordids,"@",2),"^",1)           //由于门诊结算那里医嘱号添加了发票号，格式转换那里会将发票号带进来，如5531||3@11761^5531||4@11761^5531||5@11761^5531||6@11761^5531||7@11761^5531||8@11761
	s ordids=$replace(ordids,"@"_invprtid,"")        //所以替换成空，得到需要的医嘱号串  2019-10-03 hcg
	set OrdIDs=$p(ordids,"@",1)
    /// 直接取配置过滤后的检验医嘱
    if (ordids'= "") {
	    set objList = ..GenerateLisReq(OrdIDs)  //($p(ordids,"@",1))
	    set objList.UpdateDate=""
	    set objList.UpdateTime=""
	    set objList.UpdateUserCode="-"
	    set objList.UpdateUserDesc=""
    } 
    set body.PatLisOrdList=objList
    set request.body=body
    d request.XMLExportToStream(.stream)
    Quit stream
Exception
    s stream=##class(%GlobalCharacterStream).%New()
    d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator：WuXianPu
/// CreatDate：2012—10-31
/// Description：分别通过医嘱号取得化验医嘱信息
/// Table：
/// Input：医嘱号^医嘱号^医嘱号………
/// Return：化验医嘱信息
/// Others：w ##class(web.DHCENS.STBLL.LIS.METHOD.PatLisOrdInfo).GenerateLisReq("3||22")	
ClassMethod GenerateLisReq(ordids As %String) As web.DHCENS.STBLL.LIS.MODEL.PatLisOrdListInfo
{
	set objList = ##class(web.DHCENS.STBLL.LIS.MODEL.PatLisOrdListInfo).%New()	
	set count = $L(ordids,"^")	
	for i = 1:1:count {
		set rowid = $P(ordids,"^",i)
		continue:rowid=""
		set item=##class(web.DHCENS.STBLL.LIS.MODEL.PatLisOrdInfo).%New()		
	    set item = ..GetLisItem(rowid)	
	    i item.OEORIOrderItemID'="" {
			// 判断医嘱状态				
			/*s OrderStatusDr=$p($g(^OEORD(+rowid,"I",$p(rowid,"||",2),1)),"^",13)
			s tmpOrderStatus=$p($g(^OEC("OSTAT",OrderStatusDr)),"^",1)		
			i (tmpOrderStatus="D") {
				set item.SendFlag="CA"
			}
			else {
				set item.SendFlag="NW"
			}*/
	    	do objList.OrderList.Insert(item)	
	    }    
	}
	Q objList
}

/// Creator：WuXianPu
/// CreatDate：2016—06-23
/// Description：通过医嘱号取得化验医嘱信息
/// Table：
/// Input：医嘱号
/// Return：化验医嘱信息
/// Others：w ##class(web.DHCENS.STBLL.LIS.METHOD.PatLisOrdInfo).GetLisItem("533||5")
ClassMethod GetLisItem(rowid As %String) As web.DHCENS.STBLL.LIS.MODEL.PatLisOrdInfo
{
	set PatOrd = ##class(web.DHCENS.STBLL.LIS.MODEL.PatLisOrdInfo).%New()
	set admRowId=..GetAdmInfoByOrdRowid(rowid)
	set patRowId=..GetPatInfoByOrdRowid(rowid)
	set ord = $P(rowid,"||",1)
	set sub = $P(rowid,"||",2)	
	set ordstr1 = $g(^OEORD(ord,"I",sub,1))
	set ordstr2 = $g(^OEORD(ord,"I",sub,2))
	set ordstr3 = $g(^OEORD(ord,"I",sub,3))
	set ordstr7 = $g(^OEORD(ord,"I",sub,7))
    set arcimId = $P(ordstr1,"^",2)
	q:arcimId="" PatOrd
    set arcSub = $P(arcimId,"||",1)
    set arcVer = $P(arcimId,"||",2)
	//设置医嘱子类信息
    set OrdSubCatRowID = $p($g(^ARCIM(arcSub,arcVer,1)),"^",10)
     if (OrdSubCatRowID '= "")
     {
	    set PatOrd.OrdSubCatCode = $p($g(^ARC("IC",OrdSubCatRowID)),"^",1)
	    set PatOrd.OrdSubCatDesc = $p($g(^ARC("IC",OrdSubCatRowID)),"^",2)
    }

    //设置医嘱大类信息
    set OrdCatRowID = $p($g(^ARC("IC",OrdSubCatRowID)),"^",8)
    if (OrdCatRowID '= "")
    {
	    set PatOrd.OrdCatCode = $p($g(^OEC("ORCAT",OrdCatRowID)),"^",1)
	    set PatOrd.OrdCatDesc = $p($g(^OEC("ORCAT",OrdCatRowID)),"^",2)  
    }
			
	set appDeptRowID = $P(ordstr1,"^",3)
	if appDeptRowID'="" {
		set PatOrd.AppDeptCode=$p($g(^CTLOC(appDeptRowID)),"^",1)
		set PatOrd.AppDeptDesc=$p($g(^CTLOC(appDeptRowID)),"^",2)
	}
	
    set arcimId = $P(ordstr1,"^",2)
    if arcimId'="" {
	    set arcSub = $P(arcimId,"||",1)
	    set arcVer = $P(arcimId,"||",2)
		set PatOrd.OEORIARCItmMastCode=$p($g(^ARCIM(arcSub,arcVer,1)),"^",1)
		set PatOrd.OEORIARCItmMastDesc=$p($g(^ARCIM(arcSub,arcVer,1)),"^",2)
		set ExtId="0"  for  set ExtId=$o(^ARCIM(arcSub,arcVer,"EXT",ExtId)) q:ExtId=""  d
		.set ExtToDate=$p($g(^ARCIM(arcSub,arcVer,"EXT",ExtId)),"^",2)
		.q:ExtToDate'=""
		.set ExtCode=$p($g(^ARCIM(arcSub,arcVer,"EXT",ExtId)),"^",4)
		.set ExtDesc=$p($g(^ARCIM(arcSub,arcVer,"EXT",ExtId)),"^",6)
		.set:PatOrd.ExtCode'="" PatOrd.ExtCode=PatOrd.ExtCode_","_ExtCode
		.set:PatOrd.ExtCode="" PatOrd.ExtCode=ExtCode
		.set:PatOrd.ExtDesc'="" PatOrd.ExtDesc=PatOrd.ExtDesc_","_ExtDesc
		.set:PatOrd.ExtDesc="" PatOrd.ExtDesc=ExtDesc
    }    
	set docRowID = $P(ordstr1,"^",11)
	if docRowID'="" {
		set userId=$o(^SSU("SSUSR",0,"CTPCP",docRowID,""))	
		if userId'="" {
			set PatOrd.DocCode=$p($g(^SSU("SSUSR",userId)),"^",1)
			set PatOrd.DocDesc=$p($g(^SSU("SSUSR",userId)),"^",2)
		}	
	}	
	set verifyDate = $P(ordstr3,"^",7)
	set:verifyDate'="" PatOrd.VerifyDate=$ZD(verifyDate,3)
	set verifyTime = $P(ordstr1,"^",17)
	set:verifyTime'="" PatOrd.VerifyTime=$ZT(verifyTime)	
	set PatOrd.OEORISpecimenID=$p($g(^OEORD(ord,"I",sub,3)),"^",20)
	set specName=..GetSpecName(rowid)
	if specName'="^" {
		set PatOrd.OEORISpecimenCode=$p(specName,"^",1)
		set PatOrd.OEORISpecimenDesc=$p(specName,"^",2)
		set PatOrd.Container=$p(specName,"^",3)
		set PatOrd.ContainerDesc=$p(specName,"^",4)
	}
	set PatOrd.OEORIOrderQty=$P(ordstr1,"^",12)	
	set PatOrd.OEORIOrderItemID=rowid	
	
	set recDeptRowID = $P(ordstr3,"^",6)
	if recDeptRowID'="" {
		set PatOrd.RecDeptCode=$p($g(^CTLOC(recDeptRowID)),"^",1)
		set PatOrd.RecDeptDesc=$p($g(^CTLOC(recDeptRowID)),"^",2)
	}
    set ordStatusRowID = $P(ordstr1,"^",13)   
    if ordStatusRowID'="" { 
		set PatOrd.OrderStatus=$p($g(^OEC("OSTAT",ordStatusRowID)),"^",1)
    }
	set PatOrd.BillStatus=$P(ordstr3,"^",5)
	set PatOrd.TSPrice=..GetPrice(rowid)
	set PatOrd.Note=$g(^OEORD(ord,"I",sub,"DEP",1))
	
	s OrdExecId=$o(^DHCOrdExec(0,"OEOREDR",rowid_"||1",""))
	if $l(OrdExecId) {
		set CollectDate=$P(^DHCOrdExec(OrdExecId),"^",13)
		i $l(CollectDate) s PatOrd.ColDate=$ZD(CollectDate,3)
		s CollectTime=$p(^DHCOrdExec(OrdExecId),"^",14)
		i $l(CollectTime) s PatOrd.ColTime=$ZT(CollectTime,2)
		set ColUserCode=$P(^DHCOrdExec(OrdExecId),"^",12)
		set:ColUserCode'="" PatOrd.SpecUserCode=$p($g(^SSU("SSUSR",ColUserCode)),"^",1)
		set:ColUserCode'="" PatOrd.SpecUserDesc=$p($g(^SSU("SSUSR",ColUserCode)),"^",2)
	} 
	s NotifyClinician="N"
	s NotifyClinicianNew=$p($g(^OEORD(ord,"I",sub,11)),"^",55)
	s:NotifyClinicianNew="Y" NotifyClinician=NotifyClinicianNew
	s PatOrd.SpecFlag=NotifyClinician 
	
	set PatOrd.RepDate="" ;..GetlabReportDate(rowid)
	set PatOrd.RepTime=""
	set PatOrd.RepLoct=""
	set PatOrd.GTSeq=""
	set PatOrd.ColInfo=""
	set PatOrd.OEORIChargingStatus=$P(ordstr3,"^",5)
	set MrAdm=$p($g(^PAADM(admRowId)),"^",61)
	set PhySiCycleId=$p($g(^MR(MrAdm,"DHC")),"^",9)
	set:PhySiCycleId'="" PatOrd.PhysiCycleCode=$p($g(^DHCPHYC(PhySiCycleId)),"^",1) //生理周期代码
	set:PhySiCycleId'="" PatOrd.PhysiCycle=$p($g(^DHCPHYC(PhySiCycleId)),"^",2) //生理周期描述
	
	/*
    set DiagnoseStr=..GetDiagnoses(admRowId)
    set Length=$l(DiagnoseStr,"!")
    set tmpStr=""
    for i=1:1:Length {
	    s tmpStr=tmpStr_";"_$p($p(DiagnoseStr,"!",i),"^",5)
    }
    set PatOrd.Diagnose = $E(tmpStr,2,$L(tmpStr))*/
    Q PatOrd
}

ClassMethod GetlabReportDate(oeoridr) As %String
{
	;医嘱项Rowid
	s reportDate=" "
	s arcimdr=$p(^OEORD(+oeoridr,"I",$p(oeoridr,"||",2),1),"^",2) ;OEORI_ItmMast_DR->ARC_ItmMast
   	s extsub=$o(^ARCIM(+arcimdr,$p(arcimdr,"||",2),"EXT","0")) ;取第一条记录
   	q:extsub="" ""
   	s extCode=$p(^ARCIM(+arcimdr,$p(arcimdr,"||",2),"EXT",extsub),"^",4)
   	q:extCode="" ""
   	q:'$d(^TTAB("TS",$g(extCode))) ""
   	s reportDate=$p(^TTAB("TS",extCode),"\",33)
   	q reportDate
}

/*获取第三方LIS系统的检验项目标本容器代码*/
ClassMethod GetLabContainers(ArcimID As %String, SpecimenDR As %String) As %String
{
	q:ArcimID="" ""
	s temord=$o(^ARCIM(+ArcimID,$p(ArcimID,"||",2),"EXT",""),-1)
	s ExtCode="",ContainerCode="",ContainerName=""
	if (temord'="") {
		s ExtCode=$p(^ARCIM(+ArcimID,$p(ArcimID,"||",2),"EXT",temord),"^",4)
	}
	Quit:ExtCode=""
	s ContainerDR="" f  s ContainerDR=$o(^TTAB("TS",ExtCode,"SC",ContainerDR)) q:ContainerDR=""  d
	.s TmpSpecDR="" f  s TmpSpecDR=$o(^TTAB("TS",ExtCode,"SC",ContainerDR,TmpSpecDR)) q:TmpSpecDR=""  d
	..i TmpSpecDR=SpecimenDR d
	...s ContainerCode=ContainerDR
	set ContainerMount=""
	s:ContainerCode'="" ContainerName=$p($g(^TTAB("CON",ContainerCode)),"\",1)
	s:ContainerCode'="" ContainerMount=$p($g(^TTAB("CON",ContainerCode)),"\",3)
	q ContainerCode_"^"_ContainerName_"^"_ContainerMount
}

ClassMethod GetSpecName(oerowid) As %String
{
	s OEORDRowId=$p(oerowid,"||",1)
	s OEORIChildsub=$p(oerowid,"||",2)
	s AdmNo=$p($g(^OEORD(OEORDRowId)),"^",1)
	s LocDr=$p($g(^PAADM(AdmNo)),"^",4)
	s HospDr=$p($g(^CTLOC(LocDr)),"^",22)
	s HospCode=$p($g(^CT("HOSP",HospDr)),"^",1)
	s btHospDr=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
	/// 检验标本代码、标本名称、容器代码、容器名称
	set labSpecCode="",labSpecName="",Contaniner="",ContainerCode="",ContaninerDesc="",ContainerDr=""		
	if $d(^OEORD(OEORDRowId,"I",OEORIChildsub,"SPEC",1))'=0 d
	.set labSpecCode=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,"SPEC",1)),"^",1)
	.set:labSpecCode'="" SpecDr=$O(^dbo.BTSpecimenI("IndexCode",btHospDr,##Class(LIS.Util.Common).IndexData(labSpecCode),""))
	.set:SpecDr'="" labSpecName=$lg(^dbo.BTSpecimenD(SpecDr),3)
	.set ContainerCode=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,"SPEC",1)),"^",11)
	.set:ContainerCode'="" ContainerDr=$O(^dbo.BTContainerI("IndexCode",btHospDr,##Class(LIS.Util.Common).IndexData(ContainerCode),""))
	.set:ContainerDr'="" ContaninerDesc=$lg(^dbo.BTContainerD(ContainerDr),3)
	q labSpecCode_"^"_labSpecName_"^"_ContainerCode_"^"_ContaninerDesc
}

ClassMethod GetAdmInfoByOrdRowid(rowid As %String) As %String
{
	set admNo = $P($g(^OEORD(+rowid)),"^",1)
	Quit admNo
}

ClassMethod GetPatInfoByOrdRowid(rowid As %String) As %String
{
	set patDr = ""
    set admNo = $P($g(^OEORD(+rowid)),"^",1)
    set patDr = $P($g(^PAADM(admNo)),"^",1)
	Quit patDr
}

/// w ##class(web.DHCENS.Method.AdmInfo).GetDiagnoses("5")
/// Desc:	所有诊断
/// Input:	argAdmId: 就诊rowid
/// Output:	诊断类型代码^诊断类型描述^RowId^诊断代码^诊断描述!诊断类型代码^诊断类型描述^RowId^诊断代码^诊断描述
ClassMethod GetDiagnoses(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retValue = ""
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	
	s themrdiachildsub = ""
	s mrdiachildsub = ""
	s admDiagTypeCode="",admDiagTypeDesc=""
	for  {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
		if (mrdiachildsub'=0) {
		    s admDiagTypeId=$g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",1))
	        s:admDiagTypeId'="" admDiagTypeCode=$p($g(^MRC("DTYP",admDiagTypeId)),"^",1)
	        s:admDiagTypeId'="" admDiagTypeDesc=$p($g(^MRC("DTYP",admDiagTypeId)),"^",2)
		    s themrdiachildsub = mrdiachildsub
		    s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
	        if (mricdid="") {
		        set mricdCode=""
		        set mricdDesc=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1))
		    }
		    else {
		        s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
		        s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
		    }
		    if (mricdDesc'=""){
			    if (retValue = ""){	
			    	s retValue = admDiagTypeCode_"^"_admDiagTypeDesc_"^"_mricdid_"^"_mricdCode_"^"_mricdDesc
			    }
			    else {	
			    	s retValue = retValue_"!"_admDiagTypeCode_"^"_admDiagTypeDesc_"^"_mricdid_"^"_mricdCode_"^"_mricdDesc
			    }
		    }
		}
	}
	q retValue
}

/// 获取医嘱价格
/// w ##class(web.DHCENS.STBLL.LIS.METHOD.PatLisOrdInfo).GetPrice("1629||28")
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

/// 根据发票ID获取收费员和收费时间
/// w ##class(web.DHCENS.STBLL.LIS.METHOD.PatLisOrdInfo).GetInvprtInfo("5531||3@11761^5531||4@11761^5531||5@11761^5531||6@11761^5531||7@11761^5531||8@11761")
ClassMethod GetInvprtInfo(ordids As %String) As %String
{
	s $zt="Exception"
	s invprtid=$p($p(ordids,"@",2),"^",1)
	q:invprtid="" "^"
	s chargeDate=$p($g(^DHCINVPRT(invprtid)),"^",5) //日期
	s chargeTime=$p($g(^DHCINVPRT(invprtid)),"^",20) //时间
	s charger=$p($g(^DHCINVPRT(invprtid)),"^",21) //收费员ID
	s:chargeDate'="" chargeDate=$zd(chargeDate,3)
	s:chargeTime'="" chargeTime=$zt(chargeTime)
	if charger'=""
	{
		s chargercode=$p(^SSU("SSUSR",charger),"^",1)  //人员代码
		s chargerdesc=$p(^SSU("SSUSR",charger),"^",2)  //人员描述
		}
	s chargeDateTime=chargeDate_" "_chargeTime
	q chargeDateTime_"^"_chargerdesc_"^"_chargercode
Exception
	q ordids_"-1^"_$ze
}

/// w ##class(web.DHCENS.STBLL.LIS.METHOD.PatLisOrdInfo).GetDia("").XMLExportToString(.a)
ClassMethod GetDia(AdmNo As %String) As web.DHCENS.STBLL.LIS.MODEL.DiagnosisList
{
	s $zt="Exception"
	s mainobj=##class(web.DHCENS.STBLL.LIS.MODEL.DiagnosisList).%New()
	set MRDIADR=$p(^PAADM(AdmNo),"^",61)
	set DiaSub=0
	for{
		set DiaSub=$o(^MR(MRDIADR,"DIA",DiaSub))
		Quit:DiaSub=""
		set IcdDesc="",IcdCode=""
		set IcdDr=$p(^MR(MRDIADR,"DIA",DiaSub),"^",1)
		set:IcdDr'="" IcdDesc=$p(^MRC("ID",IcdDr),"^",2),IcdCode=$p(^MRC("ID",IcdDr),"^",1)
		set MrID=MRDIADR_"||"_DiaSub
		set MrDesc=	$G(^MR(MRDIADR,"DIA",DiaSub,"DES"))				;诊断文字描述
		set:IcdDesc="" IcdDesc=MrDesc
		set:MrDesc'="" IcdDesc=IcdDesc_"("_MrDesc_")"
		set IcdDesc=$tr(IcdDesc,";","")
		set diagObj=##class(web.DHCENS.STBLL.LIS.MODEL.Diagnosis).%New()
		set diagObj.DiagCode=IcdCode
		set:IcdDesc="" IcdDesc=$p($g(^MR(MRDIADR,"DIA",DiaSub,"DES",1)),"^",1)
		set IcdDesc=$Replace(IcdDesc,"<","小于")
		set IcdDesc=$Replace(IcdDesc,">","大于")
		set IcdDesc=$Replace(IcdDesc,"|","^")
		set IcdDesc=$Replace(IcdDesc,";","^")
		set diagObj.DiagDesc=IcdDesc
		do mainobj.Diagnosis.Insert(diagObj)
	}
    q mainobj
Exception
	s obj=##class(web.DHCENS.STBLL.LIS.MODEL.DiagnosisList).%New()
	q obj
}

ClassMethod GetPatOrdList(inputContent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	s $zt="Err"
	set specimenNo=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	if $$$ISERR(tSC) {
		Quit "-1^"_tSC
	}else{
		set tSC=tDocument.EvaluateExpression("/Request/Body/GetPatOrdListRt/SpecimenID","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set specimenNo=tRes.GetAt(1).Value							
			set specimenNo=$tr(specimenNo,$c(0),"")
		}
	}
	set ordRowID=""
	set ordID=$o(^OEORD(0,"EpisNo",specimenNo,""))
	set ordSub="" f  s ordSub=$o(^OEORD(0,"EpisNo",specimenNo,ordID,ordSub)) q:ordSub=""  d
	.i ordRowID'="" s ordRowID=ordRowID_"^"_ordID_"||"_ordSub
	.e  d  s ordRowID=ordID_"||"_ordSub
	s stream=##class(%GlobalCharacterStream).%New()
	s stream=..SendLisInfoByOrdRowID(ordRowID)
	q stream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	q stream
}

}
