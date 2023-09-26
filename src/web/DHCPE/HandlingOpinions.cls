/// 名称:  web.DHCPE.HandlingOpinions.cls
/// 描述:  职业健康体检 - 处理意见模板
/// 编写者： zhongricheng
/// 编写日期:  2020.02.17
/// 产品组： 体检
Class web.DHCPE.HandlingOpinions Extends %RegisteredObject
{

/// Creator：      zhongricheng 
/// CreatDate：    2020.02.17 
/// Description:： 保存处理意见模板  包括 新增、修改
/// Table：        DHC_PE_HandlingOpinions
/// Input：        Id (空 新增    非空 修改)  DataStr (代码^检查种类^检查结论^处理意见^顺序^激活^备注)
/// Return：       -1 失败
/// Others：       w ##class(web.DHCPE.HandlingOpinions).HOSave("1","0a0B1^7^13^测试用^1^Y^备注")
ClassMethod HOSave(Id, DataStr, SplitChar As %String = "^") As %String
{
	q:(DataStr="") "-1^数据不能为空！"
	s Code=$$ALPHAUP^SSUTIL4($p(DataStr,SplitChar,1))
	q:Code="" "-1^代码不能为空！"
	q:((Id="")&&($d(^User.DHCPEHandlingOpinionsI("HOCodeIndex"," "_Code)))) "-1^代码已存在！"
	q:((Id'="")&&($o(^User.DHCPEHandlingOpinionsI("HOCodeIndex"," "_Code,0))'=Id)) "-1^代码已存在！"
	s Type=$p(DataStr,SplitChar,2)
	s Conclusion=$p(DataStr,SplitChar,3)
	q:Conclusion="" "-1^检查结论不能为空！"
	s Desc=$p(DataStr,SplitChar,4)
	q:Desc="" "-1^处理意见不能为空！"
	s Sort=$p(DataStr,SplitChar,5)
	q:Desc="" "-1^顺序不能为空！"
	s Active=$p(DataStr,SplitChar,6)
	s Remark=$p(DataStr,SplitChar,7)
	
	if (Id'="") {
		s obj=##class(User.DHCPEHandlingOpinions).%OpenId(Id)
	} else {
		s obj=##class(User.DHCPEHandlingOpinions).%New()
	}
	
	s obj.HOCode=Code
	d obj.HOOMETypeDRSetObjectId(Type)
	d obj.HOConclusionDRSetObjectId(Conclusion)
	s obj.HODesc=Desc
	s obj.HOSort=Sort
	s obj.HOActive=Active
	s obj.HORemark=Remark
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc)) {
		q "-1^"_$System.Status.GetErrorText(sc)
	} else {
		q obj.%Id()
	}
}

/// Creator：      zhongricheng 
/// CreatDate：    2020.02.17 
/// Description:： 删除处理意见模板  删除可能会导致 总检过的报告取不到处理意见
/// Table：        DHC_PE_HandlingOpinions
/// Input：        Id
/// Return：       
/// Others：       w ##class(web.DHCPE.HandlingOpinions).HODelete("","")
ClassMethod HODelete(ID) As %String
{
	s obj=##class(User.DHCPEHandlingOpinions).%New()
	s sc=obj.%DeleteId(Id)
	d obj.%Close()
	If ($System.Status.IsError(Id)) {
		q "-1^"_$System.Status.GetErrorText(sc)
	} else {
		q obj.%Id()
	}
}

/// Creator：      zhongricheng 
/// CreatDate：    2020.02.17 
/// Description:： 处理意见模板
/// Table：        DHC_PE_HandlingOpinions
/// Input：        代码  检查结论  检查种类
/// Return：       
/// Others：       d ##class(%ResultSet).RunQuery("web.DHCPE.HandlingOpinions","QueryHO","","","")
Query QueryHO(Code As %Library.String = "", Conclusion As %Library.String = "", OMEType As %Library.String = "", Active As %Library.String = "") As websys.Query(ROWSPEC = "TId:%String,TCode:%String,TOMEType:%String,TOMETypeDesc:%String,TConclusion:%String,TConclusionDesc:%String,TDesc:%String,TSort:%String,TActive:%String,TRemark:%String")
{
}

ClassMethod QueryHOExecute(ByRef qHandle As %Binary, Code As %Library.String = "", Conclusion As %Library.String = "", OMEType As %Library.String = "", Active As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	
	s job=$j
	k ^TempDHCPEHO(job)
	if (Code'="") {
		s iCode=$$ALPHAUP^SSUTIL4(Code)
		i $d(^User.DHCPEHandlingOpinionsI("HOCodeIndex"," "_iCode)) d
		.s HOId=$o(^User.DHCPEHandlingOpinionsI("HOCodeIndex"," "_iCode,0))
		.q:((Active'="")&&(Active'=$lg(^User.DHCPEHandlingOpinionsD(HOId),7)))
		.s iConclusion=$lg(^User.DHCPEHandlingOpinionsD(HOId),4)
		.q:((Conclusion'="")&&(Conclusion'=iConclusion))
		.s iOMEType=$lg(^User.DHCPEHandlingOpinionsD(HOId),3)
		.q:((OMEType'="")&&(OMEType'=iOMEType))
		.s iSort=$lg(^User.DHCPEHandlingOpinionsD(HOId),6)
		.s ^TempDHCPEHO(job,"Sort",iSort,HOId)=""
		
		s iCode=" "_iCode
		f  s iCode=$o(^User.DHCPEHandlingOpinionsI("HOCodeIndex",iCode)) q:((iCode="")||(("^"_iCode)'[("^ "_Code)))  d
		.s HOId=0
		.f  s HOId=$o(^User.DHCPEHandlingOpinionsI("HOCodeIndex",iCode,HOId)) q:HOId=""  d
		..q:((Active'="")&&(Active'=$lg(^User.DHCPEHandlingOpinionsD(HOId),7)))
		..s iConclusion=$lg(^User.DHCPEHandlingOpinionsD(HOId),4)
		..q:((Conclusion'="")&&(Conclusion'=iConclusion))
		..s iOMEType=$lg(^User.DHCPEHandlingOpinionsD(HOId),3)
		..q:((OMEType'="")&&(OMEType'=iOMEType))
		..s iSort=$lg(^User.DHCPEHandlingOpinionsD(HOId),6)
		..s ^TempDHCPEHO(job,"Sort",iSort,HOId)=""
	} elseif (Conclusion'="") {
		s HOId=0
		f  s HOId=$o(^User.DHCPEHandlingOpinionsI("HOConclusionIndex",Conclusion,HOId)) q:HOId=""  d
		.q:((Active'="")&&(Active'=$lg(^User.DHCPEHandlingOpinionsD(HOId),7)))
		.s iOMEType=$lg(^User.DHCPEHandlingOpinionsD(HOId),3)
		.q:((OMEType'="")&&(OMEType'=iOMEType))
		.s iSort=$lg(^User.DHCPEHandlingOpinionsD(HOId),6)
		.s ^TempDHCPEHO(job,"Sort",iSort,HOId)=""
	} elseif (OMEType'="") {
		s HOId=0
		f  s HOId=$o(^User.DHCPEHandlingOpinionsI("HOOMETypeIndex",OMEType,HOId)) q:HOId=""  d
		.q:((Active'="")&&(Active'=$lg(^User.DHCPEHandlingOpinionsD(HOId),7)))
		.s iSort=$lg(^User.DHCPEHandlingOpinionsD(HOId),6)
		.s ^TempDHCPEHO(job,"Sort",iSort,HOId)=""
	} else {
		s HOId=0
		f  s HOId=$o(^User.DHCPEHandlingOpinionsD(HOId)) q:HOId=""  d
		.q:((Active'="")&&(Active'=$lg(^User.DHCPEHandlingOpinionsD(HOId),7)))
		.s iSort=$lg(^User.DHCPEHandlingOpinionsD(HOId),6)
		.s ^TempDHCPEHO(job,"Sort",iSort,HOId)=""
	}
	
	if ('$d(^TempDHCPEHO(job))) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s TSort=""
	f  s TSort=$o(^TempDHCPEHO(job,"Sort",TSort)) q:TSort=""  d
	.s TId=0
	.f  s TId=$o(^TempDHCPEHO(job,"Sort",TSort,TId)) q:TId=""  d
	..s TCode=$lg(^User.DHCPEHandlingOpinionsD(TId),2)
	..s TOMEType=$lg(^User.DHCPEHandlingOpinionsD(TId),3)
	..s TOMETypeDesc=""
	..s:TOMEType'="" TOMETypeDesc=$lg(^User.DHCPEOMETypeD(TOMEType),3)
	..s TConclusion=$lg(^User.DHCPEHandlingOpinionsD(TId),4)
	..s TConclusionDesc=""
	..s:TConclusion'="" TConclusionDesc=$lg(^User.DHCPEConclusionD(TConclusion),3)
	..s TDesc=$lg(^User.DHCPEHandlingOpinionsD(TId),5)
	..s TSort=$lg(^User.DHCPEHandlingOpinionsD(TId),6)
	..s TActive=$lg(^User.DHCPEHandlingOpinionsD(TId),7)
	..s TRemark=$lg(^User.DHCPEHandlingOpinionsD(TId),8)
	..d OutHOData
	
	k ^TempDHCPEHO(job)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutHOData      
	set Data=$lb(TId,TCode,TOMEType,TOMETypeDesc,TConclusion,TConclusionDesc,TDesc,TSort,TActive,TRemark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

}
