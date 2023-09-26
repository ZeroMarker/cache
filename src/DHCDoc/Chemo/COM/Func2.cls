/// CTOR: QP
/// DATE: 2020-08-04
/// DESC: 小程序Func2
Class DHCDoc.Chemo.COM.Func2 Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-08-04
/// DESC: 通过所选模板，得到PLID
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).GetPLIDByTpl("")
ClassMethod GetPLIDByTpl(PLIDS As %String, TSID As %String)
{
	s mRtn=""
	Q:(PLIDS="")||(TSID="") mRtn
	s InTPID=+TSID
	f i=1:1:$l(PLIDS,",") d
	.q:mRtn'=""
	.s PLID=$P(PLIDS,",",i)
	.s TPID=$P(^BS.DOC.Chemo.PlanD(PLID),"^",3)
	.i InTPID=TPID s mRtn=PLID
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-08-11
/// DESC: 改变医嘱状态
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).ChgOrderStatus()
ClassMethod ChgOrderStatus(oeori As %String, status As %String)
{
	Q:(oeori="")||(status="") -1
	
	S status=$zcvt(status,"U")
	S StatDR=$O(^OEC("OSTAT",0,"Code",status,""))
	Q:StatDR="" -2
	
	&SQL(
		UPDATE SQLUser.OE_OrdItem SET OEORI_ItemStat_DR=:StatDR
		WHERE OEORI_RowId=:oeori
	)
	Q SQLCODE
}

/// CTOR: QP
/// DATE: 2020-08-04
/// DESC: 得到日期状态描述
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).GetDateStatus("U")
ClassMethod GetDateStatus(mCode)
{
	s mRtn=""
	s langid=..%LanguageID()
	i mCode="" s mRtn="未开立"	//未保存
	i mCode="N" s mRtn="暂存"	//未激活
	i mCode="A" s mRtn="已保存"	//未完成
	i mCode="Y" s mRtn="已审核"
	i mCode="S" s mRtn="中止"
	i mCode="C" s mRtn="作废"
	i mCode="U" s mRtn="完成"
	i mCode="R" s mRtn="拒绝"
	s mRtn=##class(User.ChemoPlanDate).GetTranByDesc("PDStatus",mRtn,langid)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-08-04
/// DESC: 得到各状态的颜色代码
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).GetDateColor("U")
ClassMethod GetDateColor(mCode)
{
	s mRtn=""
	i mCode="S" s mRtn="#FB7E22"
	i mCode="U" s mRtn="#01571A"
	i mCode="R" s mRtn="#F35E5E"
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-08-16
/// DESC: 得到组符号
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).GetLinkSymbol("145||1||1||2","CUR")
ClassMethod GetLinkSymbol(PGIID = "", InType = "")
{
	Q:(PGIID="")||(InType="") ""
	s PLID=$p(PGIID,"||",1)
	s SID=$p(PGIID,"||",2)
	s Sub=$p(PGIID,"||",3)
	s id=$p(PGIID,"||",4)
	k LinkArr
	i InType="TPL" {
		//咱是不做处理
	} else {
		s InLink=$p(^BS.DOC.Chemo.PlanD(PLID,SID,Sub,id),"^",9)
		q:InLink="" ""
		Q:InLink'["." "┏"
		s InPrex=$p(InLink,".",1)
		s id=""
		f  s id=$o(^BS.DOC.Chemo.PlanD(PLID,SID,Sub,id)) q:id=""  d
		.s Link=$p(^BS.DOC.Chemo.PlanD(PLID,SID,Sub,id),"^",9)
		.q:Link=""
		.s Prex=$p(Link,".",1)
		.q:Prex'=InPrex
		.s LinkArr(Link)=id
	}
	s nexLink=$o(LinkArr(InLink))
	Q:nexLink="" "┗"
	Q "┃"
}

/// CTOR: QP
/// DATE: 2020-08-12
/// DESC: 将医嘱更改为核实状态
/// IN  : 
/// OUT : 0成功
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).VerifyOrder()
ClassMethod VerifyOrder(Adm, OrderList, User, Loc)
{
	s mRtn=0
	Q:OrderList="" mRtn
	f i=1:1:$l(OrderList,"^") {
		Q:mRtn'=0
		s oeori=$p(OrderList,"^",i)
		s mRtn=..ChgOrderStatus(oeori,"V")
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-08-11
/// DESC: 改变医嘱状态
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).Test()
ClassMethod Test()
{
	s rtn=0
	s oeoriAry="174||2,174||3,174||4,174||5,174||6,174||7,174||8,174||9,174||10"
	f i=1:1:$l(oeoriAry,",") {
		Q:rtn'=0
		s oeori=$P(oeoriAry,",",i)
		s rtn=##class(DHCDoc.Chemo.COM.Func2).ChgOrderStatus(oeori,"I")
	
	}
	Q rtn
}

/// CTOR: QP
/// DATE: 2020-08-12
/// DESC: 树形数据过滤
/// IN  : 
/// OUT : 1退出，0不退
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).FilterTree("HOSP","35",$c(1,1,1)_"1","","2707")
ClassMethod FilterTree(InType, PLID, InExt, IsView, InPatientID = "")
{
	s No=1,OK=0
	Q:(PLID="")||(InType="") No
	s ^QP("JHK")=$LB(InType, PLID, InExt, IsView, InPatientID)
	
	if (IsView=1) {	//预览
		s InContent=$P(InExt,$C(1),1)
		s InContent=$zcvt(InContent,"U")
		s PDAID=$P(InExt,$C(1),2)
		s ViewPLID=$P(InExt,$C(1),3)
		//Q:PLID'=ViewPLID
		i (InType="HIS") {
			
			s name=$p(^BS.DOC.Chemo.PlanD(PLID),"^",2)
			s Status=$p(^BS.DOC.Chemo.PlanD(PLID),"^",7)
			s name=$zcvt(name,"U")
			Q:(Status="Y")||(Status="D") No
			Q:InContent="" OK
			q:name'[InContent No
		}
		i (InType="CUR") {
			s name=$p(^BS.DOC.Chemo.PlanD(PLID),"^",2)
			s Status=$p(^BS.DOC.Chemo.PlanD(PLID),"^",7)
			B ;0011
			Q:(ViewPLID'=PLID)&&(ViewPLID'="") No
			Q:(Status'="Y") No
		}
	
		
	} else {
		s InContent=$P(InExt,$C(1),1)
		s InContent=$zcvt(InContent,"U")
		i (InType="HIS") {
			s name=$p(^BS.DOC.Chemo.PlanD(PLID),"^",2)
			s Status=$p(^BS.DOC.Chemo.PlanD(PLID),"^",7)
			s name=$zcvt(name,"U")
			;Q:Status="Y" No
			Q:(Status="Y")||(Status="D") No
			Q:InContent="" OK
			q:name'[InContent No
		}
		i (InType="CUR") {
			s name=$p(^BS.DOC.Chemo.PlanD(PLID),"^",2)
			s Status=$p(^BS.DOC.Chemo.PlanD(PLID),"^",7)
			Q:(Status'="Y") No
		}
		i ((InType="DEP")||(InType="HOSP")||(InType="USER")) {
			s InContent=$P(InExt,$C(1),1)
			s InContent=$zcvt(InContent,"U")
			s isZY=$P(InExt,$C(1),4)
			i isZY=1 {
				s TPLIDS=##class(DHCDoc.Chemo.BS.Apply).GetCurrentTPL(InPatientID)
				Q:TPLIDS="" No
				i TPLIDS'="" {
					Q:(##class(DHCDoc.Chemo.COM.Func).InArray(TPLIDS,PLID)'=1) No
				}
			}
			s name=$p(^CF.DOC.Chemo.TemplateD(PLID),"^",3)
			s otherName=$p(^CF.DOC.Chemo.TemplateD(PLID),"^",14)
			s stagenum=+$p(^CF.DOC.Chemo.TemplateD(PLID),"^",4)
			s active=$p(^CF.DOC.Chemo.TemplateD(PLID),"^",5)
			Q:(active'="Y")||(stagenum=0) No
			Q:InContent="" OK
			s name=$zcvt(name,"U")
			s otherName=$zcvt(otherName,"U")
			q:(name'[InContent)&&(otherName'[InContent) No
		}
	}
	Q OK
}

/// CTOR: QP
/// DATE: 2020-08-13
/// DESC: 处理cache中的小数
/// 	  
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).ComDealToNum(.25)
ClassMethod ComDealToNum(num)
{
	q:(num="")||(num=0) num
	i num<1 s num="0"_num
	q num
}

/// CTOR: QP
/// DATE: 2020-08-13
/// DESC: 根据项目获取主药标志
/// 	  
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).IsMainDrug("133||1||4||1")
ClassMethod IsMainDrug(ItemDR)
{
	Q:ItemDR="" "N"
	s a=##class(User.ChemoPlanItem).%OpenId(ItemDR)
	Q:'$ISObject(a) "N"
	s TPLItem=a.PGITplGroupItemGetObjectId()
	Q:TPLItem="" "N"
	s b=##class(User.ChemoTemplateItem).%OpenId(TPLItem)
	Q:'$ISObject(b) "N"
	s mainFlag=b.TPGIMainDrug
	d a.%Close()
	d b.%Close()
	Q:mainFlag="Y" mainFlag
	
	Q "N"
}

/// CTOR: QP
/// DATE: 2020-08-14
/// DESC: 是否为主药组
/// 	  
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).IsMainDrug("")
ClassMethod IsMainDrugGroup(PSID, GroupCode, InType)
{
	s mRtn=0
	Q:(PSID="")||(GroupCode="")||(InType="") mRtn
	s PLID=+PSID
	s SUB=$P(PSID,"||",2)
	i (InType="CUR")||(InType="HIS") {
		s id=$o(^BS.DOC.Chemo.PlanI("ChemoPlanGroup","Code",PLID,SUB,GroupCode,""))
		Q:id="" mRtn
		s mRtn=$p(^BS.DOC.Chemo.PlanD(PLID,SUB,id),"^",8)
		i mRtn="Y" s mRtn=1
		e  s mRtn=0
	} else {
		s id=$o(^CF.DOC.Chemo.TemplateI("ChemoTemplateGroup","Code",PLID,SUB,GroupCode,""))
		Q:id="" mRtn
		s mRtn=$p(^CF.DOC.Chemo.TemplateD(PLID,SUB,id),"^",6)
		i mRtn="Y" s mRtn=1
		e  s mRtn=0
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-08-19
/// DESC: 获取化疗组描述
/// 	  
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).GetChemoDicDesc("哈哈")
ClassMethod GetChemoDicDesc(id)
{
	s mRtn=""
	Q:id="" mRtn
	s Par=+id,sub=$p(id,"||",2)
	Q:sub="" mRtn
	Q:'$D(^DHCDocCT("DefineData",Par,"D",sub)) mRtn
	s mRtn=$p(^DHCDocCT("DefineData",Par,"D",sub),"^",2)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-08-19
/// DESC: 获取化疗组代码
/// 	  
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).GetChemoDicCode("102||1",1)
ClassMethod GetChemoDicCode(id, active = "")
{
	s mRtn=""
	s ^TEMP("qp",11111)=$lb(id,active)
	Q:id="" mRtn
	s Par=+id,sub=$p(id,"||",2)
	Q:sub="" mRtn
	Q:'$D(^DHCDocCT("DefineData",Par,"D",sub)) mRtn
	s mRtn=$p(^DHCDocCT("DefineData",Par,"D",sub),"^",1)
	i active=1 {
		s StartDate=$p(^DHCDocCT("DefineData",Par,"D",sub),"^",3)
		s EndDate=$p(^DHCDocCT("DefineData",Par,"D",sub),"^",4)
		i StartDate'="" {
			Q:StartDate>+$h ""
		}
		i EndDate'="" {
			Q:EndDate<+$H ""
		}
	} 
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-08-19
/// DESC: 获取化疗组代码
/// 	  
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).GetChemoDicIdByDesc("CHEMOGORUP","化疗前药（Pre-me")
ClassMethod GetChemoDicIdByDesc(code, desc)
{
	s mRtn=""
	Q:(code="")||(desc="") mRtn
	q:'$d(^DHCDocCTi(0,"Define","Code",code)) mRtn
	s par=$o(^DHCDocCTi(0,"Define","Code",code,""))
	q:par="" mRtn
	s id=""
	f  s id=$o(^DHCDocCT("DefineData",par,"D",id)) q:(id="")||(mRtn'="")  d
	.s cDesc=$p(^DHCDocCT("DefineData",par,"D",id),"^",2)
	.i cDesc[desc s mRtn=par_"||"_id
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-08-19
/// DESC: 
/// 	  
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).ReplaceStr()
ClassMethod ReplaceStr(Str, OldStr, NewStr) As %String
{
	set intCounter = 1
	while (1)
	{
		set tmp =$e(Str, intCounter, intCounter + $l(OldStr) - 1) 
		if (tmp = OldStr)
		{
			 set $e(Str, intCounter, intCounter + $l(OldStr) - 1) = NewStr
			 set intCounter = intCounter + $l(NewStr) - $l(OldStr)
		}
		quit:intCounter>=$l(Str)
		set intCounter = intCounter + 1
	}
	quit Str
}

/// CTOR: QP
/// DATE: 2020-08-25
/// DESC: FilterToHtml
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).FilterToHtml()
ClassMethod FilterToHtml(value, print = "") As %String
{
	//n (EpisodeID)
	//s value=##class(web.DHCDocPassWork).ReplaceStr(value,",","，")
	//解析回车符
	i print="" {
		s value=##class(web.DHCDocPassWork).ReplaceStr(value,$C(10),"<br/>")
	} else {
		s value=##class(web.DHCDocPassWork).ReplaceStr(value,$C(10),"\n")
	}
	q value
}

/// CTOR: QP
/// DATE: 2020-08-26
/// DESC: 解析日期
/// 	  
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).ParseDate("")
ClassMethod ParseDate()
{
	s mRtn=""
}

/// CTOR: QP
/// DATE: 2020-10-26
/// DESC: 解析日期成DayN
/// 	  
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).ParseToDayNum("18||1","2020-10-16,2020-10-17")
ClassMethod ParseToDayNum(PSID, ShowDate)
{
	s mRtn=""
	Q:(PSID="")||(ShowDate="") mRtn
	s PLID=+PSID,SUB=$P(PSID,"||",2)
	s StartDate=$p(^BS.DOC.Chemo.PlanD(PLID,SUB),"^",3)
	f i=1:1:$l(ShowDate,",") {
		s date=$p(ShowDate,",",i)
		s date=##class(websys.Conversions).DateHtmlToLogical(date)
		s date="D"_(date-StartDate+1)
		i mRtn="" s mRtn=date
		e  s mRtn=mRtn_","_date	
	}
	
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-10-26
/// DESC: 解析DayN为日期
/// 	  
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).ParseDayNumToDate("302||1||1","D1,D2,D3")
ClassMethod ParseDayNumToDate(PGID, ShowDate)
{
	s mRtn=""
	Q:(PGID="")||(ShowDate="") mRtn
	s PLID=+PGID,SUB=$P(PGID,"||",2)
	s StartDate=$p(^BS.DOC.Chemo.PlanD(PLID,SUB),"^",3)
	f i=1:1:$l(ShowDate,",") {
		s date=$p(ShowDate,",",i)
		s date=($p(date,"D",2))+StartDate-1
		s date=##class(websys.Conversions).DateLogicalToHtml(date)
		i mRtn="" s mRtn=date
		e  s mRtn=mRtn_","_date	
	}
	
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-10-26
/// DESC: 根据公式计算单次剂量
/// 	  
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).CaclDoseByFormula(128,531,"BSA","100")
ClassMethod CaclDoseByFormula(PatientID, EpisodeID, Formula, BSAUnit)
{
	s mRtn=""
	S VSInfo=##class(DHCDoc.Chemo.COM.CallMethod).GetLastVSInfo(EpisodeID,"")
	S Height = $P(VSInfo,$C(1),1)
	s Weight = $P(VSInfo,$C(1),2)
	s Age = ##class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID)
	S SexDR=$P(^PAPER(PatientID,"ALL"),"^",7)
	Q:SexDR="" mRtn
	S Sex=$p(^CT("SEX",SexDR),"^",1)
	S SC=##class(DHCDoc.Chemo.COM.CallMethod).GetSCValue(EpisodeID)
	;B ;001	
	if (Formula="BSA") {
		s BSA=$num(($ZSQR((Height*Weight)/3600)),2)
		S mRtn=$num(BSA*BSAUnit,1)
		
	} elseif (Formula="GFR") {
		Q:SC="" mRtn
		s GFR=..CalcGFR(Age,Weight,SC,Sex)
		Q:GFR="" mRtn
   		s mRtn=$num((BSAUnit*(GFR+25)),2)  
	} elseif (Formula="WGT") {
		S mRtn=BSAUnit*Weight
	} else {
		
	}
	
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-10-26
/// DESC: 计算GFR
/// 	  
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).ParseDayNumToDate("302||1||1","D1,D2,D3")
ClassMethod CalcGFR(Age, Weight, SC, Sex)
{
	s mRtn=""
	S Percent = 1
	if (Sex = 1) {
		S Percent = 1
	} else {
		S Percent = 0.85
	}
  
	S mRtn=(((140-Age)*Weight*88.4)/(72*SC)*Percent)
	S mRtn=$num(mRtn,2)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-10-30
/// DESC: 计算
/// 	  
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).CalcPackQty()
ClassMethod GetSessionStr()
{
	S mRtn = ""
	s USERID=$g(%session.Get("LOGON.USERID"))
	s GROUPID=$g(%session.Get("LOGON.GROUPID"))
	s LOCID=$g(%session.Get("LOGON.CTLOCID"))
	s HOSPID=$g(%session.Get("LOGON.HOSPID"))
	s WARDID=$g(%session.Get("LOGON.WARDID"))
	s LANGID=$g(%session.Get("LOGON.LANGID"))
	s mRtn=USERID_"^"_GROUPID_"^"_LOCID_"^"_HOSPID_"^"_WARDID_"^"_LANGID
	
    Q mRtn
}

/// CTOR: QP
/// DATE: 2020-10-30
/// DESC: 计算
/// 	  
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).CalcPackQty("531","209||1||2||2","TPL","12213^28^4^2^undefined^20")
ClassMethod CalcPackQty(EpisodeID, ItemDR, Type, SessionStr, dosage = "")
{
	//s param="{""EpisodeID"":""438"",""OrderPriorRowid"":""3"",""OrderARCIMRowid"":""100||1"",""OrderDoseQty"":""1.98"",""OrderDoseUOMRowid"":""87"",
	//""OrderFreqRowid"":""14"",""OrderDurRowid"":""1"",""OrderPackQty"":"""",""OrderPackUOMRowid"":""2"",""OrderStartDate"":"""",
	//""OrderMultiDate"":"""",""OrderPrice"":0,""LinkedMasterOrderPriorRowid"":"""",""OrderFreqDispTimeStr"":"""",""OrderFirstDayTimes"":"""",
	//""IsNotChangeFirstDayTimeFlag"":"""",""IsNotNeedChangeFlag"":"""",""OrderFreqTimeDoseStr"":"""",
	//""OrderRecDepRowid"":""19"",""SessionStr"":""12213^28^4^2^undefined^20"",""OrderMasterARCIMRowid"":""""}"
	
	s OrderPriorRowid=$o(^OECPR(0,"Code","NORM",""))
	s (OrderARCIMRowid,OrderDoseQty,OrderDoseUOMRowid,OrderFreqRowid,OrderDurRowid,OrderPackUOMRowid,OrderPackQty)=""
	//s SessionStr=""	//..GetSessionStr()
	s ^QP("CalcPackQty")=$LB(EpisodeID, ItemDR, Type, SessionStr)
	i Type="TPL" {
		s a=##class(User.ChemoTemplateItem).%OpenId(ItemDR)
		s OrderARCIMRowid=a.TPGIArcimDRGetObjectId()
		s OrderDoseQty=dosage	//a.TPGIDosage
		s OrderDoseUOMRowid=a.TPGIDosageUomDRGetObjectId()
		s OrderFreqRowid=a.TPGIFreqDRGetObjectId()
		s OrderDurRowid=a.TPGIDuratDRGetObjectId()
		s OrderPackUOMRowid=a.TPGIUomDRGetObjectId()
		s OrderPackQty=a.TPGIQty
		s OrderRecDepRowid=a.TPGIRecLocGetObjectId()
	} else {
		s b=##class(User.ChemoPlanItem).%OpenId(ItemDR)
		s OrderARCIMRowid=b.PGIArcimDRGetObjectId()
		s OrderDoseQty=b.PGIDosage
		s OrderDoseUOMRowid=b.PGIDosageUomDRGetObjectId()
		s OrderFreqRowid=b.PGIFreqDRGetObjectId()
		s OrderDurRowid=b.PGIDuratDRGetObjectId()
		s OrderPackQty=b.PGIQty
		s OrderPackUOMRowid=b.PGIUomDRGetObjectId()
		s OrderRecDepRowid=b.PGIRecLocGetObjectId()
	}
	
	s param="{""EpisodeID"":"""_EpisodeID_""",""OrderPriorRowid"":"""_OrderPriorRowid_""",""OrderARCIMRowid"":"""_OrderARCIMRowid_""",""OrderDoseQty"":"""_OrderDoseQty_""",""OrderDoseUOMRowid"":"""_OrderDoseUOMRowid_""",""OrderFreqRowid"":"""_OrderFreqRowid_""",""OrderDurRowid"":"""_OrderDurRowid_""",""OrderPackQty"":"""_OrderPackQty_""",""OrderPackUOMRowid"":"""_OrderPackUOMRowid_""",""OrderStartDate"":"""",""OrderMultiDate"":"""",""OrderPrice"":0,""LinkedMasterOrderPriorRowid"":"""",""OrderFreqDispTimeStr"":"""",""OrderFirstDayTimes"":"""",""IsNotChangeFirstDayTimeFlag"":"""",""IsNotNeedChangeFlag"":"""",""OrderFreqTimeDoseStr"":"""",""OrderRecDepRowid"":"""_OrderRecDepRowid_""",""SessionStr"":"""_SessionStr_""",""OrderMasterARCIMRowid"":""""}"
	//s ^QP("DDD",11,1)=param
	//w param,!
	s mRtn=""
	//s mRtn=##Class(DHCDoc.Chemo.COM.CallMethod).CalPackQty(param)
	s mRtn=##Class(web.DHCOEOrdItemView).CalPackQty(param)
	k mRtnArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(mRtn,.mRtnArr)
	i $d(mRtnArr("OrderPackQty")) {Q mRtnArr("OrderPackQty")}
	
	Q ""
}

/// CTOR: QP
/// DATE: 2020-10-30
/// DESC: 计算
/// 	  
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).CalcCombinePackQty("531","209||1||2||2","TPL","12213^28^4^2^undefined^20")
ClassMethod CalcCombinePackQty(ByRef QTYList)
{
	
	s EpisodeID=QTYList("EpisodeID")
	s OrderPriorRowid=QTYList("OrderPriorRowid")
	s OrderARCIMRowid=QTYList("OrderARCIMRowid")
	s OrderDoseQty=QTYList("OrderDoseQty")
	s OrderDoseUOMRowid=QTYList("OrderDoseUOMRowid")
	s OrderFreqRowid=QTYList("OrderFreqRowid")
	s OrderDurRowid=QTYList("OrderDurRowid")
	s OrderPackQty=QTYList("OrderPackQty")
	s OrderPackUOMRowid=QTYList("OrderPackUOMRowid")
	s OrderRecDepRowid=QTYList("OrderRecDepRowid")
	i OrderRecDepRowid="" s OrderRecDepRowid=##class(DHCDoc.Chemo.COM.CallMethod).GetDefaultRecLoc(EpisodeID,OrderARCIMRowid)
	s SessionStr=QTYList("SessionStr")
	
	s param="{""EpisodeID"":"""_EpisodeID_""",""OrderPriorRowid"":"""_OrderPriorRowid_""",""OrderARCIMRowid"":"""_OrderARCIMRowid_""",""OrderDoseQty"":"""_OrderDoseQty_""",""OrderDoseUOMRowid"":"""_OrderDoseUOMRowid_""",""OrderFreqRowid"":"""_OrderFreqRowid_""",""OrderDurRowid"":"""_OrderDurRowid_""",""OrderPackQty"":"""_OrderPackQty_""",""OrderPackUOMRowid"":"""_OrderPackUOMRowid_""",""OrderStartDate"":"""",""OrderMultiDate"":"""",""OrderPrice"":0,""LinkedMasterOrderPriorRowid"":"""",""OrderFreqDispTimeStr"":"""",""OrderFirstDayTimes"":"""",""IsNotChangeFirstDayTimeFlag"":"""",""IsNotNeedChangeFlag"":"""",""OrderFreqTimeDoseStr"":"""",""OrderRecDepRowid"":"""_OrderRecDepRowid_""",""SessionStr"":"""_SessionStr_""",""OrderMasterARCIMRowid"":""""}"
	//w param,!
	s mRtn=""
	s mRtn=##Class(DHCDoc.Chemo.COM.CallMethod).CalPackQty(param)
	
	s OtherARCOS=##class(DHCDoc.Chemo.BS.Data).GetData("BD","OTHER-ARCOS")
	s Flag=##class(DHCDoc.Chemo.COM.Func2).InArcos(OtherARCOS,OrderARCIMRowid)
	i Flag=1 {	//心电监测
		i mRtn'="" s mRtn=OrderPackQty*mRtn
	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-11-30
/// DESC: 组织数据从小到大排列，并判断是否连续
/// 	  
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).BuildNumAsc(65713,"65713,65714,65715","O")
ClassMethod BuildNumAsc(SDate, Days, AdmType)
{
	S mRtn = ""
	s ShortOrder="",LongOrder=""
	Q:(SDate="")||(Days="") mRtn
	i AdmType="I" {
		;住院规则
		s MList(1)=""
		s MList(2)=""
		s MList(3)=""
		s MList(4)=""
		s MList(5)=""
		s MList(6)=""
		s MList(7)=""
		s num7=0,num8=0	//7天以内的个数
		f i=1:1:$l(Days,",") {
			s date=$p(Days,",",i)
			s j=date-SDate+1
			s MList(j)=date
			i j<=7 {
				s NList(j)=date
				s num7=num7+1
			}
			i j>7 s num8=num8+1
		}
		s over7=$O(MList(7))
		;说明有超过Day7的天数
		i over7'="" {
			s k=7
			f  s k=$o(MList(k)) d
			.s date=MList(k)
			.i ShortOrder="" s ShortOrder=date
			.e  s ShortOrder=ShortOrder_","_date
		}
		;7天以内的为长嘱
		Q:num7=0 LongOrder_$c(1)_ShortOrder
		i num7=1 {
			s num=$o(NList(""))
			s date=$o(NList(num))
			i ShortOrder="" s ShortOrder=date
			e  s ShortOrder=ShortOrder_","_date	
		} else {
			;判断是否连续
			s LXNum=""
			s h=""
			f  s h=$o(NList(h)) q:h=""  d
			.s date=NList(h)
			.i LXNum="" s LXNum=date
			.e  s LXNum=LXNum_","_date
			s isLX=..IsLX(LXNum)
			i isLX=1 {
				;连续
				s num=$o(NList(""))
				s date=(NList(num))
				s LongOrder=date_"^"_num7
			} else {
				;不连续
				s freq="QW135"
				s LongOrder=date_"^"_num7_"^"_freq
			}
		}
		Q LongOrder_$c(1)_ShortOrder
		
	} else {
		//门诊规则
		s num=0
		f i=1:1:$l(Days,",") {
			s date=$p(Days,",",i)
			s j=date-SDate+1
			s MList(j)=date
			s num=num+1
		}
		Q:num=0 LongOrder_$c(1)_ShortOrder
		i num=1 {
			s ShortOrder=Days_"^"_num
		} else {
			s LXNum=""
			s h=""
			f  s h=$o(MList(h)) q:h=""  d
			.s date=MList(h)
			.i LXNum="" s LXNum=date
			.e  s LXNum=LXNum_","_date

			s isLX=..IsLX(LXNum)
			i isLX=1 {
				s date=$p(LXNum,",",1)
				s ShortOrder=date_"^"_num
			} else {
				s h=""
				f  s h=$o(MList(h)) q:h=""  d
				.s date=MList(h)
				.i ShortOrder="" s ShortOrder=date_"^"_1
				.e  s ShortOrder=ShortOrder_","_date_"^"_1
			
			}
		}
		Q LongOrder_$c(1)_ShortOrder
	}
    Q ""
}

/// CTOR: QP
/// DATE: 2020-11-30
/// DESC: 判断数据是否连续
/// OUT : 1连续，0不连续	  
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).IsLX("65713,65714,65715")
ClassMethod IsLX(LXNum)
{
	s mRtn=1
	s lastNum=""
	f i=1:1:$l(LXNum,",") {
		s num=$p(LXNum,",",i)
		i lastNum="" {
			s lastNum=num
		} else {
			i (num-lastNum)'=1 {
				s mRtn=0
				Q 	
			}
			s lastNum=num
		}
		
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-01-12
/// DESC: 得到科室所属的院区
/// OUT : 	  
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).GetDepHosp(2)
ClassMethod GetDepHosp(locid)
{
	s mRtn=""
	s mRtn=$p(^CTLOC(locid),"^",22)
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-01-12
/// DESC: 得到科室类型
/// OUT : O/I/E/H
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).GetDepType(2)
ClassMethod GetDepType(locid)
{
	s mRtn=""
	i $d(^PAC("ADMLOC",0,"AdmType","O",locid)) {
		s mRtn="O"
	} elseif ($d(^PAC("ADMLOC",0,"AdmType","E",locid))) {
		s mRtn="E"
	} elseif ($d(^PAC("ADMLOC",0,"AdmType","I",locid))) {
		s mRtn="I"
	} elseif ($d(^PAC("ADMLOC",0,"AdmType","H",locid))) {
		s mRtn="H"
	} else {}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-01-13
/// DESC: 判断用户是否属于某个院区
/// OUT : 1/0
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).IsUserToHosp(2,2)
ClassMethod IsUserToHosp(Userid, InHosp)
{
	s NO=0,OK=1
	Q:(Userid="")||(InHosp="") NO
	s DefaultHosp=$p(^SSU("SSUSR",Userid),"^",98)	;
	Q:DefaultHosp=InHosp OK
    s sub="",findFlag=0
	f  s sub=$o(^SSU("SSUSR",Userid,"OTHLL",sub)) q:(sub="")||(findFlag=1)  d	//SS_UserOtherLogonLoc
	.s cHosp=$p(^SSU("SSUSR",Userid,"OTHLL",sub),"^",3)
	.q:cHosp=""
	.i cHosp=InHosp s findFlag=1
	
	Q findFlag
	/**
		1. isToHosp=1
		2. 当前的就诊类型 和 
	
	**/
}

/// CTOR: QP
/// DATE: 2021-01-13
/// DESC: 获取Day1的科室和医生
/// OUT : 1/0
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).GetDay1LocAndDoc("692||1")
ClassMethod GetDay1LocAndDoc(PSID)
{
	S ^QP("tem",1)=PSID
	s mRtn=""
	s PLID=$P(PSID,"||",1)
	S SID=$P(PSID,"||",2)
	s SDate=$p(^BS.DOC.Chemo.PlanD(PLID,SID),"^",3)	;
	
	//s PDDate=##class(websys.Conversions).DateHtmlToLogical(SDate)
	s PDID=$O(^BS.DOC.Chemo.PlanDateI("PSID",PSID,SDate,""))
	if (PDID'="") {
		S PDObj=##class(User.ChemoPlanDate).%OpenId(PDID)
		s PDNeedUser=PDObj.PDNeedUserGetObjectId()
		s PDNeedLoc=PDObj.PDNeedLocGetObjectId()
		s mRtn=PDNeedUser_"^"_PDNeedLoc
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-03-24
/// DESC: 判断是否在某个医嘱套内
/// OUT : 1/0
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).InArcos(110,"4483||1")
ClassMethod InArcos(ArcosID, InArcim)
{
	s mRtn=0
	Q:(ArcosID="")||(InArcim'="") mRtn
	s SUB=""
	f  s SUB=$O(^ARCOS(ArcosID,"DATE",SUB)) Q:(SUB="")||(mRtn=1)  D
	.s ID=""
	.f  s ID=$O(^ARCOS(ArcosID,"DATE",SUB,"ITM",ID)) Q:(ID="")||(mRtn=1)  D
	..s arcim=$p(^ARCOS(ArcosID,"DATE",SUB,"ITM",ID),"^",1)
	..q:InArcim'=arcim
	..s mRtn=1
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-03-24
/// DESC: 判断是否在某个医嘱套内
/// OUT : 1/0
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).GetDateboxDefaultDate()
ClassMethod GetDateboxDefaultDate()
{
	//s mRtn=0
	s mRtn=##class(websys.Conversions).DateLogicalToHtml(+$h)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-05-07
/// DESC: 将字符串数字排序
/// 	IN  : Sort:ASC/DESC
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).SortNum("3,2,1","ASC",.RList)
ClassMethod SortNum(NumberStr, Sort = "ASC", ByRef RList)
{
	s mRtn=""
	Q:NumberStr="" mRtn
	k RList
	f i=1:1:$l(NumberStr,",") {
		s cnum=$p(NumberStr,",",i)
		s RList(cnum)=""
	}
	
	s cnum=""
	i Sort="ASC" s st=1
	e  s st=-1
	f  s cnum=$o(RList(cnum),st) q:cnum=""  d
	.i mRtn="" s mRtn=cnum
	.e  s mRtn=mRtn_","_cnum
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-05-08
/// DESC: 判断是否包含日期
/// 	
/// OUT : 1包含，0不包含
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).ContainDate("2021-05-07,2021-05-08","2021-05-08")
ClassMethod ContainDate(DateStr, CDate)
{
	s mRtn=0
	Q:(DateStr="")||(CDate="") mRtn
	
	s CDate=##class(websys.Conversions).DateHtmlToLogical(CDate)
	f i=1:1:$l(DateStr,",") {
		s date=$p(DateStr,",",i)
		s date=##class(websys.Conversions).DateHtmlToLogical(date)	
		i date=CDate {
			s mRtn=1
			Q	
		}
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-12-21
/// DESC: 是否是整数
/// 	
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).IsNumber("221.c")
ClassMethod IsNumber(DateStr, CDate)
{
	s mRtn=0
	
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-03-24
/// DESC: 排序化疗日期
/// 
/// OUT : 1/0
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).DoChemoDate()
ClassMethod DoChemoDate(ChemoDate = "")
{
	Q:ChemoDate="" ""
	K TList
	f i=1:1:$L(ChemoDate,",") {
		S CDate=$p(ChemoDate,",",i)	
		s CDate=##class(websys.Conversions).DateHtmlToLogical(CDate)
		s TList(CDate)=""
		
	}
	s mRtn=""
	S CDate=""
	f  s CDate=$o(TList(CDate)) Q:CDate=""  D
	.s dt=##class(websys.Conversions).DateLogicalToHtml(CDate)
	.i mRtn="" s mRtn=dt
	.e  s mRtn=mRtn_","_dt
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2022-02-18
/// DESC: 格式化日期
/// 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.Func2).FormatDate("2022-02-18")
ClassMethod FormatDate(ChemoDate = "")
{
	Q:ChemoDate="" ""
	s ChemoDate=##class(websys.Conversions).DateHtmlToLogical(ChemoDate)
	S ChemoDate=$zd(ChemoDate,3)	
	S Month=$p(ChemoDate,"-",2)
	S Day=$p(ChemoDate,"-",3)
	
	Q Month_"-"_Day
}

}
