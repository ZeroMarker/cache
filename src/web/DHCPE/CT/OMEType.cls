/// 名称: 系统配置 - 职业病体检 - 职业健康检查种类
/// 编写者：zhongricheng
/// 编写日期: 2021-08-13
Class web.DHCPE.CT.OMEType Extends %RegisteredObject
{

/// Description: 更新职业健康检查种类
/// Table：职业健康检查种类 User.DHCPEOMEType   DHC_PE_OMEType
/// Input: ID 表Id,可空白  InfoStr 数据串 
/// Return：code -1 失败   msg 原因
/// Creator：zhongricheng
/// CreatDate：2021-08-13
/// dubug: w ##class(web.DHCPE.CT.OMEType).UpdateOMEType("1","")
ClassMethod UpdateOMEType(ID, InfoStr)
{
	S Code=$tr($p(InfoStr,"^",1)," ","")
	q:Code="" ..OutInfo(-1,"编码不能为空")
	S Desc=$tr($p(InfoStr,"^",2)," ","")
	q:Desc="" ..OutInfo(-1,"检查种类不能为空")
	
	s OMECode="",OMEDesc=""
	if ID="" d
	.s obj=##class(User.DHCPEOMEType).%New()
	e  d
	.s obj=##class(User.DHCPEOMEType).%OpenId(ID)
	.s OMECode=$LG(^User.DHCPEOMETypeD(ID),2)
	.S OMEDesc=$LG(^User.DHCPEOMETypeD(ID),3)
	
	q:(OMECode'=Code)&&($d(^User.DHCPEOMETypeI("OMETCodeIndex"," "_Code))) ..OutInfo(-1,"该编码已经使用，不能重复")
	q:(OMEDesc'=Desc)&&($d(^User.DHCPEOMETypeI("OMETDescIndex"," "_Desc))) ..OutInfo(-1,"该描述已经使用，不能重复")

	s obj.OMETCode=$P(InfoStr,"^",1)
	s obj.OMETDesc=$P(InfoStr,"^",2)
	s obj.OMETActive=$P(InfoStr,"^",3)
	s obj.OMETExpInfo=$P(InfoStr,"^",4)
	s obj.OMETRemark=$P(InfoStr,"^",5)
	s sc=obj.%Save()
	d obj.%Close()
	i ($System.Status.IsError(sc)) {
		q ..OutInfo(-1,$System.Status.GetErrorText(sc))
	} else {
		q ..OutInfo(obj.%Id())
	}
}

/// Description: 查询职业健康检查种类
/// Table：职业健康检查种类 User.DHCPEOMEType   DHC_PE_OMEType
/// Input: Code 编码   Desc 描述   Active 激活状态
/// Return：
/// Creator：zhongricheng
/// CreatDate：2021-08-13
/// Dubug:d ##class(%ResultSet).RunQuery("web.DHCPE.CT.OMEType","SearchOMEType","01")
Query SearchOMEType(Code As %String = "", Desc As %String = "", Active As %String = "Y") As websys.Query(ROWSPEC = "TID:%String,TCode:%String,TDesc:%String,TActive:%String,TExpInfo:%String,TRemark:%String")
{
}

ClassMethod SearchOMETypeExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", Active As %String = "Y") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	s ID=""
 	f  s ID=$O(^User.DHCPEOMETypeD(ID)) q:ID=""  d
 	.s TCode=$LG(^User.DHCPEOMETypeD(ID),2)
	.q:((Code'="")&&(TCode'[Code))
	.s TDesc=$LG(^User.DHCPEOMETypeD(ID),3)
	.q:((Desc'="")&&(TDesc'[Desc))
	.s TActive=$LG(^User.DHCPEOMETypeD(ID),4)
	.q:Active'=TActive
	.s TExpInfo=$LG(^User.DHCPEOMETypeD(ID),6)
	.s TRemark=$LG(^User.DHCPEOMETypeD(ID),7)
	.d FindBuild
	
	Quit $$$OK
FindBuild      
	set Data=$lb(ID,TCode,TDesc,TActive,TExpInfo,TRemark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetOneOMETypeInfo(ID)
{
	q:ID="" "^^^^^^^^^^^"
	s ID=$P(ID,"$",1)
	s obj=##class(User.DHCPEOMEType).%OpenId(ID)
	s Code=obj.OMETCode
	s Desc=obj.OMETDesc
	s Active=obj.OMETActive
	s PEType=obj.OMETVIPLevel
	s ExpInfo=obj.OMETExpInfo
	s Remark=obj.OMETRemark
	q Code_"^"_Desc_"^"_Active_"^"_PEType_"^"_ExpInfo_"^"_Remark
}

/// Description: 输出json格式字符串
/// Table：
/// Input: code 代码  msg 信息
/// Return：{"code":"1","msg":"成功"}
/// Creator：zhongricheng
/// CreatDate：2021-08-13
/// dubug: w ##class(web.DHCPE.CT.OMEType).OutInfo("1","3")
ClassMethod OutInfo(code, msg As %String = "")
{
	s json={}
	s json.code=code
	s json.msg=msg
	q json.%ToJSON()
}

}
