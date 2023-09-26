/// CTOR: QP
/// DATE: 2020-06-11
/// DESC: 公共Func
Class DHCDoc.Chemo.COM.Func Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-04-26
/// DESC: 获取模板类型描述
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetTPLTypeDesc("USER")
ClassMethod GetTPLTypeDesc(mCode As %String)
{
	s mRtn=""
	i mCode="USER" s mRtn="用户"
	i mCode="DEP" s mRtn="科室"
	i mCode="HOSP" s mRtn="医院"
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-04-26
/// DESC: 获取化疗单状态描述
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetPlanStatusDesc("N")
ClassMethod GetPlanStatusDesc(mCode As %String)
{
	s mRtn=""
	i mCode="Y" s mRtn="有效"
	i mCode="N" s mRtn="未生效"
	i mCode="S" s mRtn="停止"
	i mCode="U" s mRtn="完成"
	i mCode="D" s mRtn="删除"
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-04-26
/// DESC: 根据PSID得到模板ID
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetTPIDByPSID()
ClassMethod GetTPIDByPSID(PSID As %String)
{
	
	s mRtn=""
	Q:PSID="" mRtn
	s mRtn=$p(^BS.DOC.Chemo.PlanD(+PSID),"^",3)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-04-26
/// DESC: 获取模板描述
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetTPLDesc(1)
ClassMethod GetTPLDesc(TPID As %String)
{
	s mRtn=""
	q:TPID="" mRtn
	s type=$p(^CF.DOC.Chemo.TemplateD(TPID),"^",1)
	s desc=$p(^CF.DOC.Chemo.TemplateD(TPID),"^",2)
	i type="HOSP" {
		s mRtn=$p(^CT("HOSP",desc),"^",2)	
	}
	i type="DEP" {
		s mRtn=$p(^CTLOC(desc) ,"^",2)	
	}
	i type="USER" {
		s mRtn=$p(^SSU("SSUSR",desc) ,"^",2)	
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-04-26
/// DESC: 获取模板总阶段数
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetTPLStage(1)
ClassMethod GetTPLStage(TPID As %String)
{
	q:'$d(^CF.DOC.Chemo.TemplateD(TPID)) ""
	s mRtn=$p(^CF.DOC.Chemo.TemplateD(TPID),"^",4)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-05-08
/// DESC: 获取模板阶段总组数
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetTPLStageGroups("240||1","CUR")
ClassMethod GetTPLStageGroups(TSID As %String, InType = "")
{
	s ^QP("DKJ")=$LB(TSID,InType)
	S TPID=$p(TSID,"||",1)
	S SID=$p(TSID,"||",2)
	Q:(TPID="")||(SID="") 0
	i (InType="CUR")||(InType="HIS") {
		S PLID=TPID
		s mRtn=+$o(^BS.DOC.Chemo.PlanI("ChemoPlanGroup","Code",PLID,SID,""),-1)
		s TPID=$p(^BS.DOC.Chemo.PlanD(TPID),"^",3)
		//i (mRtn=0)||(mRtn="") s mRtn=1	//如果是空模板生成的，默认返回1组
		//s mRtn=+$o(^CF.DOC.Chemo.TemplateI("ChemoTemplateGroup","Code",TPID,SID,""),-1)
	} else {
		s mRtn=+$o(^CF.DOC.Chemo.TemplateI("ChemoTemplateGroup","Code",TPID,SID,""),-1)
	}	
	s ^QP("GetTPLStageGroups")=$LB(TSID,InType,mRtn)
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-04-28
/// DESC: 获取附加说明
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetOrderPriorRemarks("ONE")
ClassMethod GetOrderPriorRemarks(mCode As %String)
{
	s mRtn=""
	i mCode="ONE" s mRtn="取药医嘱"
	i mCode="OUT" s mRtn="出院带药"
	i mCode="ZT" s mRtn="嘱托"
	i mCode="OM" s mRtn="自备药"
	i mCode="PRN" s mRtn="PRN"
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-04-28
/// DESC: 获取医嘱阶段
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetOrderStage("SQ")
ClassMethod GetOrderStage(mCode As %String)
{
	s mRtn=""
	i mCode="SQ" s mRtn="术前"
	i mCode="SZ" s mRtn="术中"
	i mCode="SH" s mRtn="术后"
	i mCode="CZ" s mRtn="产中"
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-05-08
/// DESC: 得到当前时间传
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetCurrentDateTime()
ClassMethod GetCurrentDateTime(DateFormat As %String = "", TimeFormat As %String = "") As %String
{
	i DateFormat="" s DateFormat=##Class(websys.Conversions).DateFormat()
	i TimeFormat="" s TimeFormat=1
	s Curr=$H
	s CurrDateNum=$P(Curr,",",1)
	s CurrTimeNum=$P(Curr,",",2)
	;dd/mm/yyyy hh:mm
	s CurrDate=$ZD(CurrDateNum,DateFormat)
	s CurrTime=$ZT(CurrTimeNum,TimeFormat)
	Quit CurrDate_"^"_CurrTime_"^"_CurrDateNum_"^"_CurrTimeNum
}

/// CTOR: QP
/// DATE: 2020-05-08
/// DESC: 解析模板化疗日期
/// IN  : Format 1:HTML串(默认)，2:Logical串。
/// 		Max 获取最大值
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetTplPlanDate("t+1,t+2",1,1)
ClassMethod GetTplPlanDate(PlanDate, Format = "1", Max = "") As %String
{
	s mRtn=""
	q:PlanDate="" ""
	s cDate=+$h
	s Len=$l(PlanDate,",")
	s maxValue=""
	f j=1:1:Len {
		s item=$p(PlanDate,",",j)
		s count=$p(item,"+",2)
		s itemDate=cDate+count
		i maxValue="" {
			s maxValue=itemDate
		} else {
			i maxValue<itemDate s maxValue=itemDate
		}
		i Format=1 {
			s itemDateHtml=##class(websys.Conversions).DateLogicalToHtml(itemDate)
		} else {
			s itemDateHtml=itemDate
		}
		i mRtn="" s mRtn=itemDateHtml
		e  s mRtn=mRtn_","_itemDateHtml
	}
	
	i Max'="" {
		s mRtn=maxValue
		i Format=1 s mRtn=##class(websys.Conversions).DateLogicalToHtml(mRtn)
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-05-08
/// DESC: 医嘱类型
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetOrderPrior("JSON")
ClassMethod GetOrderPrior(Type As %String = "") As %String
{
	s langid=..%LanguageID()
	s max=20
	s ret=""
	s rowid=0 f  s rowid=$o(^OECPR(rowid)) q:rowid=""  d
	.s code=$p($g(^OECPR(rowid)),"^",1)
	.s priority=$p($g(^OECPR(rowid)),"^",3)
	.Q:priority=0
	.s desc=$p($g(^OECPR(rowid)),"^",2)
	.Q:desc'["临时"
	.s desc= ##class(User.OECPriority).GetTranByDesc("OECPRDesc",desc,langid)
	.s max=max+1
	.i priority="" s priority=max
	.i Type="JSON" s priorarr(priority)=rowid_":"_desc
	.else  s priorarr(priority)=rowid_$C(1)_code_$C(1)_desc
	;为了排序
	if (Type=""){
		s priority="" for {
			s priority=$O(priorarr(priority))
			Q:priority=""
			i ret="" s ret=priorarr(priority)
			e  s ret=ret_"^"_priorarr(priority)
		}
	} elseif(Type="JSON"){
		s priority="" for {
			s priority=$O(priorarr(priority))
			Q:priority=""
			i ret="" s ret=priorarr(priority)
			e  s ret=ret_";"_priorarr(priority)
		}
		i ret="" s ret=":;"	
		e  s ret=":;"_ret
	}	
	
	q ret
}

/// CTOR: QP
/// DATE: 2020-05-08
/// DESC: 获取计算公式
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetFormulaStr()
ClassMethod GetFormulaStr() As %String
{
	s Delimiter=";"
	s Blank=":"
	s BSA="BSA:BSA"
	s GFR="GFR:GFR"
	s WGT="WGT:WGT"
	s mRtn=Blank_Delimiter_BSA_Delimiter_GFR_Delimiter_WGT
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2020-05-08
/// DESC: 获取组类型
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetGroupTypeStr()
ClassMethod GetGroupTypeStr() As %String
{
	s Delimiter=";"
	s Blank=":"
	
	s paref=$o(^DHCDocCTi(0,"Define","Code","CHEMOGORUP",""))
	Q:paref="" Blank
	s mRtn=Blank
	s sub=0
	f  s sub=$o(^DHCDocCT("DefineData",paref,"D",sub)) q:sub=""  d
	.s code=$p(^DHCDocCT("DefineData",paref,"D",sub),"^",1)
	.s desc=$p(^DHCDocCT("DefineData",paref,"D",sub),"^",2)
	.s id=paref_"||"_sub
	.s record=id_":"_desc
	.s mRtn=mRtn_Delimiter_record
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2020-05-08
/// DESC: 医嘱类型
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetPriorRemarks("JSON")
ClassMethod GetPriorRemarks(type As %String = "", EpisodeType As %String = "") As %String
{
 
	s Delimiter="^"
	if (type="JSON"){
		s PRNRemarks="PRN:PRN"
		s ONERemarks="ONE:取药医嘱"
		s OMRemarks="OM:自备药"
		s OUTRemarks="OUT:出院带药"
		s ZTRemarks="ZT:嘱托"
		
		s Delimiter=";"
	}else{
		s PRNRemarks=1_$C(1)_"PRN"_$C(1)_"PRN"
		s ONERemarks=2_$C(1)_"ONE"_$C(1)_"取药医嘱"
		s OMRemarks=3_$C(1)_"OM"_$C(1)_"自备药"
		s OUTRemarks=4_$C(1)_"OUT"_$C(1)_"出院带药"
		s ZTRemarks=5_$C(1)_"ZT"_$C(1)_"嘱托"
	}
	i EpisodeType'="I" {
		s OrderPriorRemarks=ONERemarks_Delimiter_OMRemarks_Delimiter_ZTRemarks
		//s OrderPriorRemarks=OMRemarks_Delimiter_ZTRemarks
	}else{
		s OrderPriorRemarks=ONERemarks_Delimiter_OMRemarks_Delimiter_ZTRemarks
	}
	q OrderPriorRemarks
}

/// CTOR: QP
/// DATE: 2020-05-08
/// DESC: 获取剂量单位
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetDosageUom("920||1")
ClassMethod GetDosageUom(Arcim As %String = "") As %String
{
	s langid=..%LanguageID()
	s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(Arcim)
	q:DrgformRowid="" ""
	s PHCDRowid=$P(DrgformRowid,"||",1)
	s ChildSub=$P(DrgformRowid,"||",2)
	s FormDoseQty=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",5) ;Pharmacy base UOM
	s FormDoseUOMRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",4)
	s FormDoseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(FormDoseUOMRowid)
	s mRtn=FormDoseQty_$C(1)_FormDoseUOMDesc_$C(1)_FormDoseUOMRowid
	s PHUseEqQty=##Class(web.DHCDocConfig).GetConfigNode("PHUseEqQty")
	
	s leq=0  f  s leq=$o(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",leq)) q:leq=""  d
	.s eqrec=^PHCD(PHCDRowid,"DF",ChildSub,"EQ",leq)
	.s FormDoseUOMRowid=$p(eqrec,"^"),eqqty=$p(eqrec,"^",2),eqdefaultqty=$p(eqrec,"^",3)
	.if eqdefaultqty'="" s FormDoseQty=eqdefaultqty
	.e  d
	..i PHUseEqQty=1 s FormDoseQty=eqqty
	..e  s FormDoseQty=""
	.s FormDoseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(FormDoseUOMRowid)
	.s FormDoseUOMDesc= ##class(User.CTUOM).GetTranByDesc("CTUOMDesc",FormDoseUOMDesc,langid)
	.i (FormDoseQty'="")&(FormDoseQty<1)&(FormDoseQty'=0) s FormDoseQty="0"_FormDoseQty
	.s mRtn=FormDoseQty_$C(1)_FormDoseUOMDesc_$C(1)_FormDoseUOMRowid_$C(2)_mRtn 
	  
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-05-09
/// DESC: 获取数量单位
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetQtyUom("920||1")
ClassMethod GetQtyUom(ArcimRowid As %String = "", AdmType = "", RecDepRowid = "") As %String
{
	s mRtn=##class(web.DHCDocOrderCommon).GetBillUOMStr(ArcimRowid,RecDepRowid,"OrderEntry","",AdmType)
	Q mRtn
	s langid=..%LanguageID()
	s BillUOMRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
	s CheckCHNFlag=##class(web.DHCSTINTERFACE).GetStruModeFlag(ArcimRowid)
	if (CheckCHNFlag="Y") {
		S Phcdf=$P($g(^ARCIM(+ArcimRowid,$P(ArcimRowid,"||",2),1)),"^",12)
		if (Phcdf'=""){
			s BillUOMRowid=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4)
		}
	}
	s BillUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BillUOMRowid)
	s BillUOMDesc= ##class(User.CTUOM).GetTranByDesc("CTUOMDesc",BillUOMDesc,langid)
	s PackQty=""
	s mRtn=BillUOMRowid_$C(1)_BillUOMDesc_$C(1)_"Y"
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-05-09
/// DESC: 获取接受科室
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetRecLoc("920||1")
ClassMethod GetRecLoc2(ArcimRowid As %String = "") As %String
{
	
	s ReturnMesag=##class(web.DHCARCOrdSets).GetLocRecLoc(ArcimRowid)
	
	s LenR=$L(ReturnMesag,$c(2))
	s mRtn=""
	for J=1:1:LenR{
		s SUStr=$P(ReturnMesag,$c(2),J)
		s SRowID=$P(SUStr,$C(1),1)
		Continue:SRowID=""
		s SDesc=$P(SUStr,$C(1),2)
		s Default=$P(SUStr,$C(1),3)
		i mRtn="" s mRtn=SRowID_$C(1)_SDesc_$C(1)_Default
		e  s mRtn=mRtn_$C(2)_SRowID_$C(1)_SDesc_$C(1)_Default
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-05-09
/// DESC: 获取接受科室
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetRecLoc("920||1")
ClassMethod GetRecLoc(EpisodeID = "", ArcimRowid As %String = "") As %String
{

	
	//s ReturnMesag=##class(web.DHCARCOrdSets).GetLocRecLoc(ArcimRowid)
	s ReturnMesag=##class(web.DHCDocOrderCommon).GetRecloc(EpisodeID, ArcimRowid)
	s LenR=$L(ReturnMesag,$c(2))
	s mRtn=""
	for J=1:1:LenR{
		s SUStr=$P(ReturnMesag,$c(2),J)
		s SRowID=$P(SUStr,$C(1),1)
		Continue:SRowID=""
		s SDesc=$P(SUStr,$C(1),2)
		s Default=$P(SUStr,$C(1),3)
		i mRtn="" s mRtn=SRowID_$C(1)_SDesc_$C(1)_Default
		e  s mRtn=mRtn_$C(2)_SRowID_$C(1)_SDesc_$C(1)_Default
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-05-13
/// DESC: 获取化疗单开始日期
/// IN  : 1：html, 2:logical
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetPlanStartDate("43","2")
ClassMethod GetPlanStartDate(PLID = "", Format = "") As %String
{
	s mRtn=""
	Q:PLID="" mRtn
	s TPID=$p(^BS.DOC.Chemo.PlanD(PLID),"^",3)
	s totalNum=##class(DHCDoc.Chemo.COM.Func).GetTPLStage(TPID)
	
	//还没制定第一周期计划,根据模板的第1周期日期的开始日期走
	i '$d(^BS.DOC.Chemo.PlanI("ChemoPlanStage","Stage",PLID,1)) {	
		s mRtn=..GetTemplateStartDate(TPID,Format)
	} else {
		s sub=$o(^BS.DOC.Chemo.PlanI("ChemoPlanStage","Stage",PLID,1,""))
		q:sub="" mRtn
		s mRtn=$p(^BS.DOC.Chemo.PlanD(PLID,sub),"^",3)
		i Format=1 s mRtn=##class(websys.Conversions).DateLogicalToHtml(mRtn)
	}	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-05-13
/// DESC: 获取化疗单结束日期
/// IN  : 1：html, 2:logical
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetPlanEndDate("24","2")
ClassMethod GetPlanEndDate(PLID = "", Format = "") As %String
{
	s mRtn=""
	Q:PLID="" mRtn
	s TPID=$p(^BS.DOC.Chemo.PlanD(PLID),"^",3)
	s totalNum=##class(DHCDoc.Chemo.COM.Func).GetTPLStage(TPID)
	
	//还没制定第一周期计划
	i '$d(^BS.DOC.Chemo.PlanI("ChemoPlanStage","Stage",PLID,1)) {	
		s mRtn=..GetTemplateEndDate(TPID,Format)
		
	} else {
		f j=totalNum:-1:1 {
			q:mRtn'=""
			continue:'$d(^BS.DOC.Chemo.PlanI("ChemoPlanStage","Stage",PLID,j))		
			s sub=$o(^BS.DOC.Chemo.PlanI("ChemoPlanStage","Stage",PLID,j,""))
			continue:sub=""
			s endDate=$p(^BS.DOC.Chemo.PlanD(PLID,sub),"^",4)
			s mRtn=endDate
		}
		
		i Format=1 s mRtn=##class(websys.Conversions).DateLogicalToHtml(mRtn)
	}
		
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-05-13
/// DESC: 获取模板开始日期
/// IN  : 1：html, 2:logical
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetTemplateStartDate(1)
ClassMethod GetTemplateStartDate(TPID = "", Format = 1) As %String
{
	s mRtn=""
	Q:TPID="" mRtn
	Q:'$d(^CF.DOC.Chemo.TemplateI("ChemoTemplateStage","Stage",TPID,1)) mRtn
	s sub=$o(^CF.DOC.Chemo.TemplateI("ChemoTemplateStage","Stage",TPID,1,""))
	q:sub="" mRtn
	s startDate=$p(^CF.DOC.Chemo.TemplateD(TPID,sub),"^",3)
	s mRtn=##class(DHCDoc.Chemo.COM.Func).GetTplPlanDate(startDate,Format)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-05-13
/// DESC: 获取模板结束日期
/// IN  : 1：html, 2:logical
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetTemplateEndDate(1)
ClassMethod GetTemplateEndDate(TPID = "", Format = 1) As %String
{
	s mRtn=""
	Q:TPID="" mRtn
	s totalStage=..GetTPLStage(TPID)
	f j=totalStage:-1:1 {
		q:mRtn'=""
		continue:'$d(^CF.DOC.Chemo.TemplateI("ChemoTemplateStage","Stage",TPID,j))
		s sub=$o(^CF.DOC.Chemo.TemplateI("ChemoTemplateStage","Stage",TPID,j,""))
		continue:sub=""
		s endDate=$p(^CF.DOC.Chemo.TemplateD(TPID,sub),"^",4)
		s mRtn=##class(DHCDoc.Chemo.COM.Func).GetTplPlanDate(endDate,Format)
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-05-15
/// DESC: 获取患者所处阶段
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetPatStage(53)
ClassMethod GetPatStage(PLID) As %String
{
	s mRtn=""
	Q:PLID="" mRtn 
	s cDate=+$h
	s stage=""
	f  s stage=$o(^BS.DOC.Chemo.PlanI("ChemoPlanStage","Stage",PLID,stage)) q:(stage="")||(mRtn'="")  d
	.s sub=$o(^BS.DOC.Chemo.PlanI("ChemoPlanStage","Stage",PLID,stage,""))
	.q:sub=""
	.s startDate=$p(^BS.DOC.Chemo.PlanD(PLID,sub),"^",3)
	.s endDate=$p(^BS.DOC.Chemo.PlanD(PLID,sub),"^",4)
	.i endDate>=cDate s mRtn=stage
	
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-05-15
/// DESC: 获取模型类属性
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetClassPropertyList("DHCDoc.THPY.Model.StageInfo")
ClassMethod GetClassPropertyList(Name As %String, ClsFlag As %String = "1") As %String
{
	s myItems=""
	s myobj=##class(%Dictionary.CompiledClass).%OpenId(Name)
	s myCount = myobj.Properties.Count()
	s mylist=""
	i ClsFlag=1 s mylist=$p(Name,".",$l(Name,"."))
	For i = 1:1:myCount {
		s myproperty=myobj.Properties.GetAt(i)
		s myName=myproperty.Name
		if myName="%%OID" continue
		if myName="%Concurrency" continue
		if (mylist="")
		{
			s mylist= myName
		}else
		{
	    	s mylist=mylist_"^"_myName
		}
	}
	
	q mylist
}

/// CTOR: QP
/// DATE: 2020-05-14
/// DESC: 医护人员转换成SSUSER
/// 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).TransCTCareToSSUser("954")
ClassMethod TransCTCareToSSUser(ctCareId) As %String
{
	s mRet=""
	q:ctCareId="" mRet
	q:'$d(^SSU("SSUSR",0,"CTPCP",ctCareId)) mRet
	s mRet=$o(^SSU("SSUSR",0,"CTPCP",ctCareId,""))
	q mRet
}

/// CTOR: QP
/// DATE: 2020-06-17
/// DESC: 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetMaxValue("2020-06-18,2020-06-20,2020-06-21",1,+$h)
ClassMethod GetMaxValue(InValue, DateFlag = "", CompareVal = "") As %String
{
	
	s Max=""
	Q:InValue="" Max
	s Len=$l(InValue,",")
	
	f j=1:1:Len {
		s item=$p(InValue,",",j)
		i DateFlag=1 {
			s item=##class(websys.Conversions).DateHtmlToLogical(item)
			continue:item<=CompareVal
		}
		i Max="" s Max=item
		e  i item>Max  s Max=item
	
	}
	i DateFlag=1 {
		s Max=##class(websys.Conversions).DateLogicalToHtml(Max)
	}
	Q Max
}

/// CTOR: QP
/// DATE: 2020-06-17
/// DESC: 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetMinValue("2020-06-18,2020-06-20,2020-06-21",1)
ClassMethod GetMinValue(InValue, DateFlag = "", CompareVal = "") As %String
{
	
	s Min=""
	Q:InValue="" Min
	s Len=$l(InValue,",")
	
	f j=1:1:Len {
		s item=$p(InValue,",",j)
		i DateFlag=1 {
			s item=##class(websys.Conversions).DateHtmlToLogical(item)
			continue:item<=CompareVal
		}
		i Min="" s Min=item
		e  i item<Min  s Min=item
	
	}
	i DateFlag=1 {
		s Min=##class(websys.Conversions).DateLogicalToHtml(Min)
	}
	Q Min
}

/// CTOR: QP
/// DATE: 2020-06-17
/// DESC: 降序
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).SortValue("2020-06-20,2020-06-18,2020-06-21","ASC")
ClassMethod SortValue(InValue, Sort = "", DateFlag = "") As %String
{
	
	s mRtn=""
	Q:InValue="" mRtn
	s Len=$l(InValue,",")
	f j=1:1:Len {
		s item=$p(InValue,",",j)
		s MData(item)=""
	}
	i Sort="ASC" s Sort=1
	e  s Sort=-1
	s key=""
	f  s key=$o(MData(key),Sort) q:key=""  d
	.i mRtn="" s mRtn=key
	.e  s mRtn=mRtn_","_key
	
	Q mRtn
	/*
	f j=1:1:Len {
		s item=$p(InValue,",",j)
		i DateFlag=1 {
			s item=##class(websys.Conversions).DateHtmlToLogical(item)
			
		}
		
	
	}
	i DateFlag=1 {
		s Min=##class(websys.Conversions).DateLogicalToHtml(Min)
	}
	*/
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 工具方法，判断数值包含
/// IN  : 
/// OUT : 
/// 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).InArray("I")
ClassMethod InArray(kssarray As %String, docId As %String) As %String
{
	s rtn=0,data=""
	q:kssarray="" rtn
	s multiLen=$l(kssarray,",")
	f len=1:1:multiLen {
		s data=$p(kssarray,",",len)
		q:data="" 
		i data=docId{
			s rtn=1	
			q
		}
		
	}
	q rtn
}

/// CTOR: QP
/// DATE: 2020-07-20
/// DESC: 字符串拼接
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).LinkString("12,123",",","^")
ClassMethod LinkString(Para = "", Sep = "", LinkSep = ",") As %String
{
	s mRtn=""
	Q:(Para="")||(Sep="") mRtn
	
	f i=1:1:$l(Para,Sep) {
		s item=$p(Para,Sep,i)
		i mRtn="" s mRtn=item
		e  s mRtn=mRtn_LinkSep_item	
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-12-20
/// DESC: 获取患者结算信息
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetEstDischInfo(1,.a)
ClassMethod GetEstDischInfo(AdmId, ByRef EstJson) As %String
{
	s mRtn=""
	s EstJson= {
		"DischConfirmed":"",
		"DischargeDate":"",
		"DischargeTime":""
	}
	Q:AdmId="" mRtn
	s DischConfirmed=$p(^PAADM(AdmId,2),"^",25)
	s DischargeDate=$p(^PAADM(AdmId),"^",59)
	s DischargeTime=$p(^PAADM(AdmId),"^",60)
	d EstJson.%Set("DischConfirmed",DischConfirmed)
	d EstJson.%Set("DischargeDate",DischargeDate)
	d EstJson.%Set("DischargeTime",DischargeTime)
	
	Q DischConfirmed
}

/// CTOR: QP
/// DATE: 2020-04-28
/// DESC: 获取错误描述
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func).GetErrorDesc("USER")
ClassMethod GetErrorDesc(mCode As %String)
{
	s mRtn=""
	i mCode="-101" s mRtn="保存模板失败!"
	i mCode="-102" s mRtn="删除模板失败!"
	i mCode="-103" s mRtn="保存模板化疗组失败!"
	i mCode="-104" s mRtn="模板化疗组配置已存在!"
	i mCode="-105" s mRtn="删除模板化疗组失败!"
	i mCode="-106" s mRtn="保存模板化疗组项目失败!"
	i mCode="-107" s mRtn="删除模板化疗组项目失败!"
	i mCode="-108" s mRtn="模板化疗组项目配置已存在!"
	i mCode="-109" s mRtn="保存化疗项目变更原因失败!"
	i mCode="-110" s mRtn="删除化疗项目变更原因失败!"
	i mCode="-111" s mRtn="保存终身剂量失败!"
	i mCode="-112" s mRtn="删除终身剂量失败!"
	i mCode="-113" s mRtn="终身剂量已存在!"
	i mCode="-114" s mRtn="保存化疗单失败！"
	i mCode="-115" s mRtn="保存化疗组失败！"
	i mCode="-116" s mRtn="保存化疗组项目失败！"
	i mCode="-117" s mRtn="保存化疗项目失败！"
	i mCode="-118" s mRtn="保存化疗单项目医嘱失败！"
	i mCode="-119" s mRtn="调整医嘱剂量失败！"
	
	i mCode="-120" s mRtn="保存模板周期失败！"
	i mCode="-121" s mRtn="模板周期已存在！"
	i mCode="-122" s mRtn="删除模板周期失败！"
	
	i mCode="-123" s mRtn="保存化疗周期失败！"
	
	i mCode="-124" s mRtn="保存外院剂量失败！"
	i mCode="-125" s mRtn="停止化疗方案失败！"
	i mCode="-126" s mRtn="停止化疗方案医嘱失败！"
	i mCode="-127" s mRtn="保存就诊关联失败！"
	i mCode="-128" s mRtn="保存化疗日期表失败！"
	i mCode="-129" s mRtn="保存化疗日期状态表失败！"
	i mCode="-130" s mRtn="保存化疗项目调整比例表失败！"
	i mCode="-131" s mRtn="保存化疗变更原因记录表失败！"
	
	i mCode="-132" s mRtn="申请医生发送消息失败！"
	i mCode="-133" s mRtn="化疗方案审核发送消息失败！"
	
	i mCode="-134" s mRtn="停止所选日期化疗方案失败！"
	i mCode="-135" s mRtn="停止所选日期化疗方案医嘱失败！"
	
	i mCode="-136" s mRtn="审核医嘱时，发送申请失败！"
	
	i mCode="-137" s mRtn="保存化疗日期审核状态表失败！"
	i mCode="-138" s mRtn="完成化疗方案失败！"
	i mCode="-139" s mRtn="化疗医嘱相关处理失败！"
	i mCode="-140" s mRtn="保存化疗日期申请化疗项目失败！"
	i mCode="-141" s mRtn="保存其余周期信息失败！"
	
	i mCode="-142" s mRtn="保存化疗组，获取PGID失败！"
	i mCode="-143" s mRtn="保存空白组失败！"
	
	i mCode="-144" s mRtn="作废所选日期化疗方案失败！"
	i mCode="-145" s mRtn="作废所选日期化疗方案医嘱失败！"
	
	i mCode="-146" s mRtn="保存主药备注及标题失败！"
	i mCode="-147" s mRtn="删除化疗方案失败！"
	i mCode="-148" s mRtn="保存后停止日期方案失败！"
	i mCode="-149" s mRtn="化疗方案已经发送申请，不能停止！"
	
	i mCode="-150" s mRtn="无暂存的天数！"
	i mCode="-151" s mRtn="无法获取PDID！"
	i mCode="-152" s mRtn="必填项为空！"
	
	;i mCode="-153" s mRtn="保存本次医嘱其它日期(ContainDay)的申请失败！"
	i mCode="-153" s mRtn="不连续天数不允许保存！"
	
	i mCode="-154" s mRtn="中止化疗医嘱失败！"
	
	i mCode="-155" s mRtn="调整模板阶段顺序失败！"
	i mCode="-156" s mRtn="调整模板化疗组顺序失败！"
	i mCode="-157" s mRtn="调整模板化疗项目顺序失败！"
	i mCode="-158" s mRtn="保存化疗项目日期顺序失败！"
	i mCode="-159" s mRtn="调整开始日期失败！"
	i mCode="-160" s mRtn="提交时，停止上次拒绝的医嘱失败！"
	i mCode="-161" s mRtn="存在审核科室和审核医生不相同，请检查！"
	
	i mCode="-162" s mRtn="复制周期失败！"
	i mCode="-163" s mRtn="复制化疗组失败！"
	i mCode="-164" s mRtn="复制化疗项目失败！"
	i mCode="-165" s mRtn="复制一天失败！"
	i mCode="-166" s mRtn="更新主药信息失败！"
	Q mRtn
}

}
