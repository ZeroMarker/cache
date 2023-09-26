/// CTOR: QP
/// DATE: 2020-09-17
/// DESC: 检验筛选条件
Class DHCDoc.GCPSW.BS.Lis Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-09-17
/// DESC: 根据子项ID,获取子项指标HTML
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Lis).GetItemHTML("5||1","1||3")
ClassMethod GetItemHTML(ITID = "", PKID = "", IsVal = "")
{
	s mRtn=""
	s PID=+PKID
	s KID=$P(PKID,"||",2)
	s SUB=""
	f  s SUB=$o(^CF.DOC.GCPSW.PrjD(PID,"K",KID,"I",SUB)) Q:SUB=""  d
	.s KPI=$p(^CF.DOC.GCPSW.PrjD(PID,"K",KID,"I",SUB),"^",1)
	.q:KPI=""
	.s cKTID=+KPI,cItem=$p(KPI,"||",2),cSub=$p(KPI,"||",3)
	.s cITID=cKTID_"||"_cItem
	.q:cITID'=ITID
	.s KPICode=$p(^CF.DOC.GCPSW.KPITypeD(cKTID,"I",cItem,"K",cSub),"^",1)
	.s KPIName=$p(^CF.DOC.GCPSW.KPITypeD(cKTID,"I",cItem,"K",cSub),"^",2)
	.s val=$p(^CF.DOC.GCPSW.PrjD(PID,"K",KID,"I",SUB),"^",3)
	.s section=$p(^CF.DOC.GCPSW.PrjD(PID,"K",KID,"I",SUB),"^",2)
	.s stdVal=$p(^CF.DOC.GCPSW.PrjD(PID,"K",KID,"I",SUB),"^",5)
	.s rule=$p(^CF.DOC.GCPSW.PrjD(PID,"K",KID,"I",SUB),"^",10)
	.s sid="s-"_KPICode
	.s eid="e-"_KPICode
	.i section=1 d
	..i IsVal=1 d
	...s sVal=$p(val,",",1)
	...s eVal=$p(val,",",2)
	..e  d
	...s sVal=""
	...s eVal=""
	..s mRtn=mRtn_"<li>"
	..s mRtn=mRtn_"<label class='field'>"_KPIName_"</label>"
	..s mRtn=mRtn_"<input id='"_sid_"' class='textbox fill' type='text' rule='"_rule_"' value='"_sVal_"' style='width:30px;'>"
	..s mRtn=mRtn_"<span class='c-span2'>~</span>"
	..s mRtn=mRtn_"<input id='"_eid_"' class='textbox fill' type='text' rule='"_rule_"' value='"_eVal_"' style='width:30px;margin-left:10px;'>"      					
	..s mRtn=mRtn_"</li>"
	.e  d
	..i IsVal'=1 s val=""
	..s mRtn=mRtn_"<li>"
	..s mRtn=mRtn_"<label class='field'>"_KPIName_"</label>"
	..s mRtn=mRtn_"<input type='text' class='textbox' rule='"_rule_"' id='"_KPICode_"' value='"_val_"' >"
	..s mRtn=mRtn_"</li>"
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-17
/// DESC: 根据子项ID,获取子项指标Val串
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Lis).GetLisVal("5||2,5||1","1||3")
ClassMethod GetLisVal(ITVal = "", PKID = "")
{
	s mRtn=""
	//5||2#Test^12-5||1#WhiteCell^1!s-Platelet^1!e-Platelet^3
	
	Q:ITVal="" mRtn
	s PID=+PKID
	s KID=$P(PKID,"||",2)
	
	f i=1:1:$l(ITVal,",") d
	.s ITID=$p(ITVal,",",i)
	.s ITStr=""
	.s SUB=""
	.f  s SUB=$o(^CF.DOC.GCPSW.PrjD(PID,"K",KID,"I",SUB)) Q:SUB=""  d
	..s KPI=$p(^CF.DOC.GCPSW.PrjD(PID,"K",KID,"I",SUB),"^",1)
	..q:KPI=""
	..s cKTID=+KPI,cItem=$p(KPI,"||",2),cSub=$p(KPI,"||",3)
	..s cITID=cKTID_"||"_cItem
	..q:cITID'=ITID
	..s record=""
	..s KPICode=$p(^CF.DOC.GCPSW.KPITypeD(cKTID,"I",cItem,"K",cSub),"^",1)
	..s KPIName=$p(^CF.DOC.GCPSW.KPITypeD(cKTID,"I",cItem,"K",cSub),"^",2)
	..s val=$p(^CF.DOC.GCPSW.PrjD(PID,"K",KID,"I",SUB),"^",3)
	..s section=$p(^CF.DOC.GCPSW.PrjD(PID,"K",KID,"I",SUB),"^",2)
	..s stdVal=$p(^CF.DOC.GCPSW.PrjD(PID,"K",KID,"I",SUB),"^",5)
	..s rule=$p(^CF.DOC.GCPSW.PrjD(PID,"K",KID,"I",SUB),"^",10)
	..i rule="" s rule="FULL"	;默认精确匹配
	..s sid="s-"_KPICode
	..s eid="e-"_KPICode
	..i section=1 d
	...s sVal=$p(val,",",1)
	...s eVal=$p(val,",",2)
	...s record=sid_"^"_sVal_"^"_rule_"!"_eid_"^"_eVal_"^"_rule
	...i ITStr="" s ITStr=record
	...e  s ITStr=ITStr_"!"_record
	..e  d 
	...s record=KPICode_"^"_val_"^"_rule
	...i ITStr="" s ITStr=record
	...e  s ITStr=ITStr_"!"_record
	.s ITStr=ITID_"#"_ITStr
	.i mRtn="" s mRtn=ITStr
	.e  s mRtn=mRtn_"/"_ITStr
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-17
/// DESC: 根据子项ID,获取子项指标Val串
/// IN  : ITVal 筛选值，PKID：GCPSW_PrjKPI
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Lis).GetLisValNew("3||1,3||2","2||4")
ClassMethod GetLisValNew(ITVal = "", PKID = "")
{
	s mRtn=""
	//ITID^代码^值^匹配类型^是否区间#细项代码^细项医嘱项
	//3||1^0013^1,2^FULL^1#D001^3950||1!D002^3949||1!D003^11730||1
	
	Q:ITVal="" mRtn
	s PID=+PKID
	s KID=$P(PKID,"||",2)
	
	f i=1:1:$l(ITVal,",") d
	.s ITStr=""
	.;子项
	.s ITID=$p(ITVal,",",i)
	.s KTID=+ITID,KS=$p(ITID,"||",2)
	.s ITCode=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",KS),"^",1)
	.Q:'$d(^CF.DOC.GCPSW.PrjI("PrjKPIItem","KPIType",PID,KID,ITID))
	.s SUB=$O(^CF.DOC.GCPSW.PrjI("PrjKPIItem","KPIType",PID,KID,ITID,""))
	.q:SUB=""
	.;指标值
	.s val=$p(^CF.DOC.GCPSW.PrjD(PID,"K",KID,"I",SUB),"^",3)
	.s section=$p(^CF.DOC.GCPSW.PrjD(PID,"K",KID,"I",SUB),"^",2)
	.i section'=1 s section=0
	.s stdVal=$p(^CF.DOC.GCPSW.PrjD(PID,"K",KID,"I",SUB),"^",5)
	.s rule=$p(^CF.DOC.GCPSW.PrjD(PID,"K",KID,"I",SUB),"^",10)
	.;根据子项获取细项
	.Q:'$D(^CF.DOC.GCPSW.KPITypeD(KTID,"I",KS,"K"))
	.s IK="",IKInfo=""
	.f  s IK=$O(^CF.DOC.GCPSW.KPITypeD(KTID,"I",KS,"K",IK)) Q:IK=""  d
	..s IKCode=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",KS,"K",IK),"^",1)
	..s IKArcim=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",KS,"K",IK),"^",9)
	..Q:(IKCode="")||(IKArcim="")
	..s IKRecord=IKCode_"^"_IKArcim
	..i IKInfo="" s IKInfo=IKRecord
	..e  s IKInfo=IKInfo_"!"_IKRecord
	.Q:IKInfo=""
	.;子项信息
	.s ITInfo=""
	.i rule="" s rule="FULL"	;默认精确匹配
	.s ITInfo=ITID_"^"_ITCode_"^"_val_"^"_rule_"^"_section
	.;子项+细项
	.s ITStr=ITInfo_"#"_IKInfo
	.i mRtn="" s mRtn=ITStr
	.e  s mRtn=mRtn_"/"_ITStr
	
	Q mRtn
}

}
