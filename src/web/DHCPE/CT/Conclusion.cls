/// 名称: 系统配置 - 职业病体检 - 职业病结论分类
/// 编写者：zhongricheng
/// 编写日期: 2021-08-04
Class web.DHCPE.CT.Conclusion Extends %RegisteredObject
{

/// Description: 更新职业病结论分类
/// Table：职业病结论分类 User.DHCPEConclusion   DHC_PE_Conclusion
/// Input: ID 表Id,可空白  InfoStr 数据串 
/// Return：code -1 失败   msg 原因
/// Creator：zhongricheng
/// CreatDate：2021-08-04
/// dubug: w ##class(web.DHCPE.CT.Conclusion).UpdateConclusion("1","")
ClassMethod UpdateConclusion(ID, InfoStr, CTLOCID, USERID)
{
	S Code=$p(InfoStr,"^",1)
	q:Code="" ..OutInfo(-1,"编码不能为空")
	S Desc=$p(InfoStr,"^",2)
	q:Desc="" ..OutInfo(-1,"结论分类不能为空")
	
	s ConCode="",ConDesc=""
	if ID="" d
	.s obj=##class(User.DHCPEConclusion).%New()
	e  d
	.s obj=##class(User.DHCPEConclusion).%OpenId(ID)
	.s ConCode=$LG(^User.DHCPEConclusionD(ID),2)
	.S ConDesc=$LG(^User.DHCPEConclusionD(ID),3)
	
	q:(ConCode'=Code)&&($d(^User.DHCPEConclusionI("CCodeIndex"," "_Code))) ..OutInfo(-1,"该编码已经使用，不能重复")
	q:(ConDesc'=Desc)&&($d(^User.DHCPEConclusionI("CDescIndex"," "_Desc))) ..OutInfo(-1,"该描述已经使用，不能重复")
	
	s:CTLOCID="" CTLOCID=%session.Get("LOGON.CTLOCID")
	s:USERID="" USERID=%session.Get("LOGON.USERID")

	s obj.CCode=Code
	s obj.CDesc=Desc
	s obj.CActive=$p(InfoStr,"^",3)
	//s obj.CVIPLevel=$p(InfoStr,"^",4)
	s obj.CExpInfo=$p(InfoStr,"^",5)
	s obj.CSeverity=$p(InfoStr,"^",6)
	s obj.CRemark=$p(InfoStr,"^",7)
	s sc=obj.%Save()
	d obj.%Close()
	if ($System.Status.IsError(sc)) {
		q ..OutInfo(-1,$System.Status.GetErrorText(sc))
	} else {
		d ##class(User.DHCPEConclusion).SaveDataToPowerControl(obj.%Id(),CTLOCID,USERID)
		q ..OutInfo(obj.%Id())
	}
}

/// Description: 删除职业病结论分类
/// Table：职业病结论分类 User.DHCPEConclusion 
/// Input: ID 表Id
/// Return：code -1 失败   msg 原因
/// Creator：zhongricheng
/// CreatDate：2021-08-04
/// dubug: w ##class(web.DHCPE.CT.Conclusion).DeleteConclusion("1")
ClassMethod DeleteConclusion(ID)
{
	q:$d(^User.DHCPEOMEIllnessI("ConclusionIndex",ID)) ..OutInfo(-1,"该结论分类被目标疾病使用,需要将其关联关系解除")
	q:$d(^User.DHCPEHandlingOpinionsI("HOConclusionIndex",ID)) ..OutInfo(-1,"该结论分类被职业健康处理意见模板使用,需要将其关联关系解除")
	s obj=##class(User.DHCPEConclusion).%New()
	s sc=obj.%DeleteId(ID)
	d obj.%Close()
	if ($System.Status.IsError(sc)) {
		q ..OutInfo(-1,$System.Status.GetErrorText(sc))
	} else {
		q ..OutInfo(obj.%Id())
	}
}

/// Description: 查询职业病结论分类
/// Table：职业病结论分类 User.DHCPEConclusion 
/// Input: Active 激活状态
/// Return：
/// Creator：zhongricheng
/// CreatDate：2021-08-04
/// dubug: d ##class(ResultSet).RunQuery("web.DHCPE.CT.Conclusion","FindConclusion","")
Query FindConclusion(Active As %String = "") As websys.Query(ROWSPEC = "TRowId:%String,TCode:%String,TDesc:%String,TActive:%String,TExpInfo:%String,TSeverity:%String,TRemark:%String")
{
}

ClassMethod FindConclusionExecute(ByRef qHandle As %Binary, Active As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	s ID=""
 	f  s ID=$o(^User.DHCPEConclusionD(ID)) q:ID=""  d
	.s TActive=$lg(^User.DHCPEConclusionD(ID),4)
	.q:((Active'="")&&(Active'=TActive))
 	.s TCode=$lg(^User.DHCPEConclusionD(ID),2)
	.s TDesc=$lg(^User.DHCPEConclusionD(ID),3)
	.s TExpInfo=$lg(^User.DHCPEConclusionD(ID),6)
	.s TSeverity=$lg(^User.DHCPEConclusionD(ID),7)
	.s TRemark=$lg(^User.DHCPEConclusionD(ID),8)
	.d OutConclusion
	Quit $$$OK
	
OutConclusion      
	set Data=$lb(ID,TCode,TDesc,TActive,TExpInfo,TSeverity,TRemark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Description: 输出json格式字符串
/// Table：
/// Input: code 代码  msg 信息
/// Return：{"code":"1","msg":"成功"}
/// Creator：zhongricheng
/// CreatDate：2021-08-04
/// dubug: w ##class(web.DHCPE.CT.Conclusion).OutInfo("1","3")
ClassMethod OutInfo(code, msg As %String = "")
{
	s json={}
	s json.code=code
	s json.msg=msg
	q json.%ToJSON()
}

}
