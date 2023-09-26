/// CTOR: QP
/// DATE: 2017-04-24
/// DESC: 抗菌药物-上线项目公共类库，兼容新版和旧版
Class DHCAnt.KSS.Prj.Common Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2017-04-24
/// DESC: 初始化数据Global，老版本需要先执行此方法，新版不需要
/// 
/// OUT : 
/// EXEC: w ##class(DHCAnt.KSS.Prj.Common).ComInitConfig()
ClassMethod ComInitConfig()
{
	n
	//碳青霉烯类抗菌药
	s ^DHCANTMAINDATA("KSS","CQMX")="8||1,9||1"	//医嘱项id串，用逗号分隔，例如：5||1,6||1
	
	//替加环素类抗菌药
	s ^DHCANTMAINDATA("KSS","TGC")="5||1,6||1"	//医嘱项id串，用逗号分隔，例如：5||1,6||1

	q 1
}

/// CTOR: QP
/// DATE: 2017-04-24
/// DESC: 根据会诊科室 或 会诊医生 -> 判断 是否为感染性疾病科
/// IN  : 科室ID,医护人员id
/// 
/// OUT : 1：是/ 0：否		
/// EXEC: w ##class(DHCAnt.KSS.Prj.Common).ComIsInfectDep(16,288)
ClassMethod ComIsInfectDep(loc As %String = "", doc As %String = "")
{
	n (loc,doc)
	s mRtn=0
	q:(loc="")&&(doc="") mRtn
	i (..ComIsNewVersion()) s mRtn=..ComIsInfectDepNew(loc,doc)
	e  s mRtn=..ComIsInfectDepOld(loc,doc)
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-04-24
/// DESC: 根据医嘱项判断是否为，碳青霉烯类抗菌药物或替加环素类
/// IN  : 医嘱项ID, mode: 1 2 3
/// 	  mode=1 代表 碳青霉烯类抗菌药物
/// 		  mode=2 代表 替加环素类
/// 		  mode=3 代表 碳青霉烯类抗菌药物 和 替加环素类
/// OUT : 1：是 /  0：否
/// EXEC: w ##class(DHCAnt.KSS.Prj.Common).ComIsCqmxOrTgc("5||1", 1)
ClassMethod ComIsCqmxOrTgc(arcim As %String = "", mode As %String = "")
{
	n (arcim, mode)
	s mRtn=0
	q:arcim="" mRtn
	i (..ComIsNewVersion()) s mRtn=..ComIsCqmxOrTgcNew(arcim,mode)
	e  s mRtn=..ComIsCqmxOrTgcOld(arcim,mode)
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-04-24	
/// 【旧版】
/// EXEC: w ##class(DHCAnt.KSS.Prj.Common).ComIsInfectDep(16,288)
ClassMethod ComIsInfectDepOld(loc As %String = "", doc As %String = "")
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
/// 【新版】
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).ComIsInfectDep(16,288)
ClassMethod ComIsInfectDepNew(loc As %String = "", doc As %String = "")
{
	n (loc, doc)
	s mRtn=0
	q:(loc="")&&(doc="") mRtn
	
	i loc'="" d
	.s pdcId=""
	.f  s pdcId=$o(^DHCAntBasePurposeDataConfigI("PDCType","CONLOC",pdcId)) q:pdcId=""  d
	..s infectDepFlag=$p($g(^DHCAntBasePurposeDataConfigD(pdcId)),"^",9)	//
	..s consultDep=$p(^DHCAntBasePurposeDataConfigD(pdcId),"^",3)
	..i ((consultDep=loc)&&(infectDepFlag=1)) s mRtn=1
	..q:mRtn=1
	.i ((mRtn'=1)&&(doc'="")) d
	..s pdcId=""
	..f  s pdcId=$o(^DHCAntBasePurposeDataConfigI("PDCType","CONDOC",pdcId)) q:pdcId=""  d
	...s infectDepFlag=$p($g(^DHCAntBasePurposeDataConfigD(pdcId)),"^",9)	//
	...s consultDoc=$p(^DHCAntBasePurposeDataConfigD(pdcId),"^",3)
	...i (consultDoc=doc)&&(infectDepFlag=1) s mRtn=1
	...q:mRtn=1
	e  d
	.s pdcId=""
	.f  s pdcId=$o(^DHCAntBasePurposeDataConfigI("PDCType","CONDOC",pdcId)) q:pdcId=""  d
	..s infectDepFlag=$p($g(^DHCAntBasePurposeDataConfigD(pdcId)),"^",9)	//
	..s consultDoc=$p(^DHCAntBasePurposeDataConfigD(pdcId),"^",3)
	..i (consultDoc=doc)&&(infectDepFlag=1) s mRtn=1
	..q:mRtn=1
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-04-24
/// 【旧版】
/// EXEC: w ##class(DHCAnt.KSS.Prev.FunctionExtend).ComIsCqmxOrTgc("5||1", 1)
ClassMethod ComIsCqmxOrTgcOld(arcim As %String = "", mode As %String = "")
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
/// DATE: 2017-04-24
/// 【新版】
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).ComIsCqmxOrTgc("5||1", 1)
ClassMethod ComIsCqmxOrTgcNew(arcim As %String = "", mode As %String = "")
{
	n (arcim, mode)
	s mRtn=0
	q:arcim="" mRtn
	i mode="" s mode=3	//若没指定，则默认两者都有
	s CQMXArray=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("CQMX")
	s TGCArray=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("TGC")
	i mode=1 s mRtn=..InArray(CQMXArray,arcim)
	i mode=2 s mRtn=..InArray(TGCArray,arcim) 
	i mode=3 s mRtn=(..InArray(TGCArray,arcim))||(..InArray(CQMXArray,arcim))
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-04-24
/// DESC: 获取抗菌药物系统版本号,之前版本统一定位3.0
/// IN  : 
/// OUT : 	
/// EXEC: w ##class(DHCAnt.KSS.Prj.Common).GetKSSVersion()
ClassMethod GetKSSVersion()
{
	n 
	s version="3.0"
	i (..ComIsNewVersion()) s version=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("VERSION")
	q version
}

/// CTOR: QP
/// DATE: 2017-04-24
/// DESC: 判断是否为新版
/// IN  : 
/// OUT : 	1:是 / 0:否
/// EXEC: w ##class(DHCAnt.KSS.Prj.Common).ComIsNewVersion()
ClassMethod ComIsNewVersion()
{
	n 
	s mRtn=0
	i $d(^DHCAntBaseMainConfigD) s mRtn=1
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
