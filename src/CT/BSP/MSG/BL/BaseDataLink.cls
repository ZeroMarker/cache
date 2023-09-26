Class CT.BSP.MSG.BL.BaseDataLink Extends %RegisteredObject
{

/// 基础数据校验
ClassMethod BaseDataCheck(RefType, RefObjId)
{
	if (RefType="H") {
		if RefObjId="" q "-1^请选择医院"
		if '$d(^CT("HOSP",RefObjId)) q "-1^选择的医院不正确"
	}elseif (RefType="G") {
		if RefObjId="" q "-1^请选择安全组"
		if '$d(^SSU("SSGRP",RefObjId)) q "-1^选择的安全组不正确"
	}elseif (RefType="L") {
		if RefObjId="" q "-1^请选择科室"
		if '$d(^CTLOC(RefObjId)) q "-1^选择的科室不正确"
	}elseif (RefType="U") {
		if RefObjId="" q "-1^请选择用户"
		if '$d(^SSU("SSUSR",RefObjId)) q "-1^选择的用户不正确"
	}else{
		q "-1^类型不支持"_RefType	
	}
	q 1
}

ClassMethod GetId(LinkKey, SrcRefType, SrcRefObjId, LinkRefType, LinkRefObjId)
{
	s ret=""
	s oid=""
	for {
		s oid=$o(^CT.BSP.MSG.BaseDataLinkI("SRCDATA",LinkKey,SrcRefType,SrcRefObjId,oid))
		q:oid=""
		
		s type=$lg(^CT.BSP.MSG.BaseDataLinkD(oid),5)
		s objid=$lg(^CT.BSP.MSG.BaseDataLinkD(oid),6)
		if type=LinkRefType,objid=LinkRefObjId {
			s ret=oid
			q	
		}
		
	}
	q ret
}

ClassMethod LinkCheck(Id, LinkKey, SrcRefType, SrcRefObjId, LinkRefType, LinkRefObjId)
{
	if LinkKey="" q "-1^关联类型为空"
	
	s ck=..BaseDataCheck(SrcRefType,SrcRefObjId)
	if ck'=1 q ck
	
	s ck=..BaseDataCheck(LinkRefType,LinkRefObjId)
	if ck'=1 q ck
	
	s oid=..GetId(LinkKey, SrcRefType, SrcRefObjId, LinkRefType, LinkRefObjId)
	if oid'="",oid'=Id q "-1^此关联记录已存在"
	q 1
}

ClassMethod Save(Id, LinkKey, SrcRefType, SrcRefObjId, LinkRefType, LinkRefObjId)
{
	s ck=..LinkCheck(Id, LinkKey, SrcRefType, SrcRefObjId, LinkRefType, LinkRefObjId)
	if ck'=1 q ck
	
	if Id="" {
		s obj=##class(CT.BSP.MSG.BaseDataLink).%New()	
	}else{
		s obj=##class(CT.BSP.MSG.BaseDataLink).%OpenId(Id)
	}
	
	if '$IsObject(obj) q "-1^未知错误"_Id
	
	s obj.LinkKey=LinkKey
	s obj.SrcRefType=SrcRefType
	s obj.SrcRefObjId=SrcRefObjId
	s obj.LinkRefType=LinkRefType
	s obj.LinkRefObjId=LinkRefObjId
	s sc=obj.%Save()
	if $$$ISERR(sc) {
		s ret="-1^"_$system.Status.GetErrorText(sc)	
	}else{
		s ret=obj.%Id()	
	}
	s obj=""
	q ret
}

ClassMethod Delete(Id)
{
	if Id="" q "-1^Id为空"
	if '$d(^CT.BSP.MSG.BaseDataLinkD(Id)) q "-1^Id="_Id_"不存在"
	s sc=##class(CT.BSP.MSG.BaseDataLink).%DeleteId(Id)
	if $$$ISERR(sc) {
		s ret="-1^"_$system.Status.GetErrorText(sc)	
	}else{
		s ret=Id
	}
	q ret
}

ClassMethod GetRefTypeDesc(reftype)
{
	
	q $case(reftype,"H":"医院","G":"安全组","L":"科室","U":"个人",:reftype)
}

ClassMethod GetRefObjDesc(reftype, objid)
{
	if reftype="H" {
		s desc=$p($g(^CT("HOSP",objid),"^Err"_objid),"^",2)
		q desc	
	}elseif reftype="L" {
		s desc=$p($g(^CTLOC(objid),"^Err"_objid),"^",2)
		q desc	
	}elseif reftype="U" {
		s desc=$p($g(^SSU("SSUSR",objid),"^Err"_objid),"^",2)
		q desc	
	}elseif reftype="G" {
		s desc=$p($g(^SSU("SSGRP",objid),"Err"_objid),"^",1)
		q desc	
	}else{
		q objid	
	}
}

/// debug:d ##class(%ResultSet).RunQuery("CT.BSP.MSG.BL.BaseDataLink","Find","","")
Query Find(LinkKey = "", q = "") As websys.Query(CONTAINID = 0, ROWSPEC = "TId,LinkKey,TSrcRefType,TSrcRefTypeDesc,TSrcRefObjId,TSrcRefObjDesc,TLinkRefType,TLinkRefTypeDesc,TLinkRefObjId,TLinkRefObjDesc")
{
}

ClassMethod FindExecute(ByRef QHandle As %Library.Binary, LinkKey As %String = "", q As %String = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	set ind=1 s QHandle=$lb(0,repid,0) 
	
	if LinkKey="" q $$$OK
	
	s qU=$zcvt(q,"U")
	
	s iSrcRefType=""
	for {
		s iSrcRefType=$o(^CT.BSP.MSG.BaseDataLinkI("SRCDATA",LinkKey,iSrcRefType))
		q:iSrcRefType=""
		
		s iSrcRefObjId=""
		for {
			s iSrcRefObjId=$o(^CT.BSP.MSG.BaseDataLinkI("SRCDATA",LinkKey,iSrcRefType,iSrcRefObjId))
			q:iSrcRefObjId=""
			
			s id=""
			for {
				s id=$o(^CT.BSP.MSG.BaseDataLinkI("SRCDATA",LinkKey,iSrcRefType,iSrcRefObjId,id))
				q:id=""
				d OutputRow
			}
			
		}
	}

	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	s g=^CT.BSP.MSG.BaseDataLinkD(id)
	s TSrcRefType=$lg(g,3)
	s TSrcRefObjId=$lg(g,4)
	s TSrcRefTypeDesc=..GetRefTypeDesc(TSrcRefType)
	s TSrcRefObjDesc=..GetRefObjDesc(TSrcRefType,TSrcRefObjId)
	s TLinkRefType=$lg(g,5)
	s TLinkRefObjId=$lg(g,6)
	s TLinkRefTypeDesc=..GetRefTypeDesc(TLinkRefType)
	s TLinkRefObjDesc=..GetRefObjDesc(TLinkRefType,TLinkRefObjId)
	if qU'="",$zcvt(TSrcRefObjDesc_","_TLinkRefObjDesc,"U")'[qU,##class(ext.util.String).ToChineseSpell($zcvt(TSrcRefObjDesc_","_TLinkRefObjDesc,"U"))'[qU {
		q	
	}

	Set ^CacheTemp(repid,ind)=$lb(id,LinkKey,TSrcRefType,TSrcRefTypeDesc,TSrcRefObjId,TSrcRefObjDesc,TLinkRefType,TLinkRefTypeDesc,TLinkRefObjId,TLinkRefObjDesc)
	Set ind=ind+1
}

/// 根据源对象获取消息接收对象代码
ClassMethod GetLinkedBySrcObj(LinkKey, SrcRefType, SrcRefObjId)
{
	s ret=""
	s oid=""
	for {
		s oid=$o(^CT.BSP.MSG.BaseDataLinkI("SRCDATA",LinkKey,SrcRefType,SrcRefObjId,oid))
		q:oid=""
		
		s type=$lg(^CT.BSP.MSG.BaseDataLinkD(oid),5)
		s objid=$lg(^CT.BSP.MSG.BaseDataLinkD(oid),6)
		
		s ret=ret_$s(ret="":"",1:",")_type_"-"_objid
		
	}
	q ret
}

}
