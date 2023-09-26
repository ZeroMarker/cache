/// CTOR: QP
/// DATE: 2020-11-04
/// DESC: 公共类
Class DHCAnt.KSS.Common.Func Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-11-04
/// DESC: 获取库存项ID
/// IN  : 
/// OUT : 
/// TABL: INC_Itm
/// EXEC: w ##class(DHCAnt.KSS.Common.Func).GetINCI("1956||1")
ClassMethod GetINCI(arcim As %String)
{
	s ARCIMsub=$p(arcim,"||",1)
	s INCIrow=$o(^INCI(0,"ARCIM_DR",ARCIMsub,""))
	
	q $g(INCIrow)
}

/// CTOR: QP
/// DATE: 2020-11-04
/// DESC: 获取药学项目子表ID
/// IN  : 
/// OUT : 
/// TABL: PHC_DrgForm
/// EXEC: w ##class(DHCAnt.KSS.Common.Func).GetDrgForm("1956||1")
ClassMethod GetDrgForm(ARCIMRowid As %String) As %String
{
	s DrgFormRowid=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",12)
	i DrgFormRowid=-1 s DrgFormRowid=""
	q $g(DrgFormRowid)
}

/// CTOR: QP
/// DATE: 2020-11-04
/// DESC: 获取药学项ID
/// IN  : 
/// OUT : 
/// TABL: PHC_DrgMast
/// EXEC: w ##class(DHCAnt.KSS.Common.Func).GetDrgMast("1956||1")
ClassMethod GetDrgMast(ARCIMRowid As %String) As %String
{
	s mRtn=..GetDrgForm(ARCIMRowid)
	i mRtn'="" s mRtn=+mRtn
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-11-04
/// DESC: 获取等效单位(最后一个)
/// IN  : 
/// OUT : 
/// TABL: PHC_DrgMast
/// EXEC: w ##class(DHCAnt.KSS.Common.Func).GetEQUom("1956||1")
ClassMethod GetEQUom(ARCIMRowid As %String) As %String
{
	s mRtn=""
	s phcdf=..GetDrgForm(ARCIMRowid)
	Q:phcdf="" mRtn
	s ph=+phcdf,cdf=$p(phcdf,"||",2)
	s sub=0
	f  s sub=$o(^PHCD(ph,"DF",cdf,"EQ",sub)) q:sub=""  d
	.s euom=$p(^PHCD(ph,"DF",cdf,"EQ",sub),"^",1)
	.q:euom=""
	.s eqty=$p(^PHCD(ph,"DF",cdf,"EQ",sub),"^",2)
	.i euom'="" s mRtn=$p(^CT("UOM",euom),"^",2)
	  		
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-11-04
/// DESC: 获取基本单位
/// IN  : 
/// OUT : 
/// TABL: PHC_DrgMast
/// EXEC: w ##class(DHCAnt.KSS.Common.Func).GetBaseUom("1956||1")
ClassMethod GetBaseUom(ARCIMRowid As %String) As %String
{
	s mRtn=""
	s phcdf=..GetDrgForm(ARCIMRowid)
	Q:phcdf="" mRtn
	s ph=+phcdf,cdf=$p(phcdf,"||",2)
	
	s BaseQty=$p($g(^PHCD(ph,"DF",cdf,2)),"^",5) ;Pharmacy base UOM
	s BaseUOMRowid=$p($g(^PHCD(ph,"DF",cdf,2)),"^",4)
	i BaseUOMRowid'="" s mRtn=$p(^CT("UOM",BaseUOMRowid),"^",2)
	  				
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-12-28
/// DESC: 获取手术状态描述
/// IN  : 
/// OUT : 
/// TABL: PHC_DrgMast
/// EXEC: w ##class(DHCAnt.KSS.Common.Func).GetOPStatus("A")
ClassMethod GetOPStatus(Code As %String) As %String
{
	s mRtn=""
	i Code="A" s mRtn="申请"
	i Code="C" s mRtn="撤销"
	i Code="R" s mRtn="安排"
	i Code="I" s mRtn="术中"
	i Code="P" s mRtn="恢复室"
	i Code="L" s mRtn="离室"
	i Code="F" s mRtn="完成"
	i Code="S" s mRtn="拟日间"
		
	Q mRtn
}

}
