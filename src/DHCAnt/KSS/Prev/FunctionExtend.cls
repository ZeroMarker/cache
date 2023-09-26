/// CTOR: QP
/// DATE: 2017-04-24
/// DESC: 抗菌药物KSS-V4.1.0之前版本-功能扩展类
Class DHCAnt.KSS.Prev.FunctionExtend Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2017-04-24
/// DESC: 根据会诊科室 或 会诊医生 -> 判断 是否为感染性疾病科
/// IN  : 科室ID,医护人员id
/// 
/// OUT : 1：是/ 0：否		
/// EXEC: w ##class(DHCAnt.KSS.Prev.FunctionExtend).ComIsInfectDep(16,288)
ClassMethod ComIsInfectDep(loc As %String = "", doc As %String = "")
{
	n (loc,doc)
	s mRtn=0
	q:(loc="")&&(doc="") mRtn
	
	i loc'="" d
	.s rowId=""
	.f  s rowId=$o(^User.DHCAntiConsultLocInfoD(rowId)) q:rowId=""  d
	..s infectDepFlag=$li(^User.DHCAntiConsultLocInfoD(rowId),7)
	..s consultDep=$li(^User.DHCAntiConsultLocInfoD(rowId),2)
	..i ((consultDep=loc)&&(infectDepFlag=1)) s mRtn=1
	..q:mRtn=1
	.i ((mRtn'=1)&&(doc'="")) d
	..s rowId=""
	..f  s docId=$o(^User.DHCAntiConsultDocInfoD(rowId)) q:rowId=""  d
	...s infectDepFlag=$li($g(^User.DHCAntiConsultDocInfoD(rowId)),5)
	...s consultDoc=$list(^User.DHCAntiConsultDocInfoD(rowId),3)
	...i (consultDoc=doc)&&(infectDepFlag=1) s mRtn=1
	...q:mRtn=1
	e  d
	.s rowId=""
	.f  s docId=$o(^User.DHCAntiConsultDocInfoD(rowId)) q:rowId=""  d
	..s infectDepFlag=$li($g(^User.DHCAntiConsultDocInfoD(rowId)),5)
	..s consultDoc=$list(^User.DHCAntiConsultDocInfoD(rowId),3)
	..i (consultDoc=doc)&&(infectDepFlag=1) s mRtn=1
	..q:mRtn=1

	q mRtn
}

/// CTOR: QP
/// DATE: 2017-04-24
/// DESC: 初始化数据Global
/// IN  : 
/// 
/// OUT : 
/// EXEC: w ##class(DHCAnt.KSS.Prev.FunctionExtend).ComIsInfectDep()
ClassMethod ComInitConfig()
{
	n
	//碳青霉烯类抗菌药
	s ^DHCANTMAINDATA("KSS","CQMX")="8||,9||1"	//医嘱项id串，用逗号分隔，例如：5||1,6||1
	
	//替加环素类抗菌药
	s ^DHCANTMAINDATA("KSS","TGC")="5||1,6||1"	//医嘱项id串，用逗号分隔，例如：5||1,6||1

	q 1
}

/// CTOR: QP
/// DATE: 2017-04-24
/// DESC: 根据医嘱项判断是否为，碳青霉烯类抗菌药物或替加环素类
/// IN  : 医嘱项ID, mode: 1 2 3
/// 	  mode=1 代表 碳青霉烯类抗菌药物
/// 		  mode=2 代表 替加环素类
/// 		  mode=3 代表 碳青霉烯类抗菌药物 和 替加环素类
/// OUT : 1：是 /  0：否
/// EXEC: w ##class(DHCAnt.KSS.Prev.FunctionExtend).ComIsCqmxOrTgc("5||1", 1)
ClassMethod ComIsCqmxOrTgc(arcim As %String = "", mode As %String = "")
{
	n (arcim, mode)
	s mRtn=0
	q:arcim="" mRtn
	i mode="" s mode=3	//若没指定，则默认两者都有
	s CQMXArray=$g(^DHCANTMAINDATA("KSS","CQMX"))
	s TGCArray=$g(^DHCANTMAINDATA("KSS","TGC"))
	i mode=1 s mRtn=..InArray(CQMXArray,arcim)
	i mode=2 s mRtn=..InArray(TGCArray,arcim) 
	i mode=3 s mRtn=(..InArray(TGCArray,arcim))||(..InArray(CQMXArray,arcim))
	q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 工具方法，判断数值包含
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCAnt.KSS.Prev.FunctionExtend).InArray("I")
ClassMethod InArray(kssarray As %String, docId As %String) As %String
{
	s rtn=0,data=""
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

}
