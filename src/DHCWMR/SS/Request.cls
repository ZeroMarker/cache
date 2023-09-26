/// 病案操作登记/申请表
Class DHCWMR.SS.Request Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildDtl As DHCWMR.SS.RequestDtl [ Cardinality = children, Inverse = Parref ];

/// 病案类型
Property RQMrType As DHCWMR.SS.MrType;

/// 操作项目
Property RQItemDr As DHCWMR.SS.WorkItem;

/// 申请状态（R申请、A响应、U作废）
Property RQReqStatus As %String(MAXLEN = 100, TRUNCATE = 1);

/// 申请日期
Property RQRequestDate As %Date;

/// 申请时间
Property RQRequestTime As %Time;

/// 申请人（指向SS_User）
Property RQRequestUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 创建日期
Property RQCreateDate As %Date;

/// 创建时间
Property RQCreateTime As %Time;

/// 创建人（指向SS_User）
Property RQCreateUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 更新日期
Property RQUpdateDate As %Date;

/// 更新时间
Property RQUpdateTime As %Time;

/// 更新人（指向SS_User）
Property RQUpdateUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备注信息
Property RQResume As %String(MAXLEN = 100, TRUNCATE = 1);

/// 批次号
Property RQBatchNumber As %String(MAXLEN = 100, TRUNCATE = 1);

/// 质控问题描述
Property RQQCReason As %String(MAXLEN = 500, TRUNCATE = 1);

/// 委托人姓名
Property RQClientName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 委托人与患者关系（"RelationType"） 指向DHCWMR.SS.Dictionary
Property RQClientRelation As %String(MAXLEN = 100, TRUNCATE = 1);

/// 委托人证明材料（"Certificate"） 指向DHCWMR.SS.Dictionary
Property RQCardTypeDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 委托人身份证号/证件编号
Property RQPersonalID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 委托人联系电话
Property RQTelephone As %String(MAXLEN = 100, TRUNCATE = 1);

/// 委托人联系地址
Property RQAddress As %String(MAXLEN = 100, TRUNCATE = 1);

/// 委托人备注信息
Property RQClientNote As %String(MAXLEN = 500, TRUNCATE = 1);

/// 借阅科内电话
Property RQLLocTel As %String(MAXLEN = 100, TRUNCATE = 1);

/// 借阅人工号
Property RQLUserCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 借阅人姓名
Property RQLUserName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 借阅人电话
Property RQLUserTel As %String(MAXLEN = 100, TRUNCATE = 1);

/// 借阅目的（"LendAim"） 指向DHCWMR.SS.Dictionary
Property RQLPurpose As %String(MAXLEN = 100, TRUNCATE = 1);

/// 借阅预计归还日期
Property RQLBackDate As %String(MAXLEN = 100, TRUNCATE = 1);

/// 借阅病历归还状态（"ReturnStatus"） 指向DHCWMR.SS.Dictionary
Property RQLReturnStatus As %String(MAXLEN = 100, TRUNCATE = 1);

/// 借阅备注信息
Property RQLNote As %String(MAXLEN = 500, TRUNCATE = 1);

/// 复印内容（"MRCopyInfo"） 指向DHCWMR.SS.Dictionary
Property RQCContent As %String(MAXLEN = 100, TRUNCATE = 1);

/// 复印目的（"CopyAim"） 指向DHCWMR.SS.Dictionary
Property RQCPurpose As %String(MAXLEN = 100, TRUNCATE = 1);

/// 复印数量
Property RQCPageNumber As %String(MAXLEN = 100, TRUNCATE = 1);

/// 复印单价
Property RQCUnitPrice As %String(MAXLEN = 100, TRUNCATE = 1);

/// 复印金额
Property RQCMoneyCount As %String(MAXLEN = 100, TRUNCATE = 1);

/// 复印备注信息
Property RQCNote As %String(MAXLEN = 500, TRUNCATE = 1);

/// 封存内容（"StoreContent"） 指向DHCWMR.SS.Dictionary
Property RQSContent As %String(MAXLEN = 100, TRUNCATE = 1);

/// 封存原因（"StoreReason"） 指向DHCWMR.SS.Dictionary
Property RQSPurpose As %String(MAXLEN = 100, TRUNCATE = 1);

/// 封存数量
Property RQSCount As %String(MAXLEN = 100, TRUNCATE = 1);

/// 封存医师工号
Property RQSDocCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 封存医师姓名
Property RQSDocName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 封存医务处人员工号
Property RQSMedUserCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 封存医务处人员姓名
Property RQSMedUserName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 封存备注信息
Property RQSNote As %String(MAXLEN = 500, TRUNCATE = 1);

/// 批次号 索引
Index IndexBatchNumber On RQBatchNumber [ Unique ];

/// 病案类型+操作项目+登记日期索引
Index IndexItemDrDate On (RQMrType, RQItemDr, RQReqStatus, RQRequestDate, RQRequestTime);

/// Creator：     zhufei
/// CreatDate：   2014-11-29
/// Description:  根据ID取申请记录
/// Table：       DHCWMR.SS.Request
/// Input：       Id : DHCWMR.SS.Request.ID
/// Return：      返回Object
/// w ##class(DHCWMR.SS.Request).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.SS.Request
{
	new (aId)
	quit:'##class(DHCWMR.SS.Request).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.SS.Request).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2014-11-29
/// Description:  更新病案申请记录
/// Table：       DHCWMR.SS.Request
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.SS.Request).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	new (aInputStr,aSeparate)
	set return=0
	quit:aInputStr="" return
	
	set ID          = $p(aInputStr,aSeparate,1)
	set MrTypeID    = $p(aInputStr,aSeparate,2)
	set WorkItemID  = $p(aInputStr,aSeparate,3)
	set RequestDate = $p(aInputStr,aSeparate,4)
	set:RequestDate["-" RequestDate=$zdh(RequestDate,3)
	set RequestTime = $p(aInputStr,aSeparate,5)
	set:RequestTime[":" RequestTime=$zth(RequestTime,1)
	set RequestUser = $p(aInputStr,aSeparate,6)
	set CreateDate  = $p(aInputStr,aSeparate,7)
	set:CreateDate["-" CreateDate=$zdh(CreateDate,3)
	set:CreateDate="" CreateDate=+$h
	set CreateTime  = $p(aInputStr,aSeparate,8)
	set:CreateTime[":" CreateTime=$zth(CreateTime,1)
	set:CreateTime="" CreateTime=$p($h,"^",2)
	set CreateUser  = $p(aInputStr,aSeparate,9)
	set UpdateDate  = $p(aInputStr,aSeparate,10)
	set:UpdateDate["-" UpdateDate=$zdh(UpdateDate,3)
	set:UpdateDate="" UpdateDate=+$h
	set UpdateTime  = $p(aInputStr,aSeparate,11)
	set:UpdateTime[":" UpdateTime=$zth(UpdateTime,1)
	set:UpdateTime="" UpdateTime=$p($h,"^",2)
	set UpdateUser  = $p(aInputStr,aSeparate,12)
	set ReqStatus   = $p(aInputStr,aSeparate,13)
	set Resume      = $p(aInputStr,aSeparate,14)
	set BatchNumber = $p(aInputStr,aSeparate,15)
	quit:(MrTypeID="")||(WorkItemID="")||(BatchNumber="") return
	
	if ID="" {
		set ID=$o(^DHCWMR.SS.RequestI("IndexBatchNumber"," "_BatchNumber,0))
	}
	
	set objMrType=##class(DHCWMR.SS.MrType).GetObjById(MrTypeID)
	quit:'$IsObject(objMrType) return
	set objWorkItem=##class(DHCWMR.SS.WorkItem).GetObjById(WorkItemID)
	quit:'$IsObject(objWorkItem) return
	
	if ID="" {
		set obj=##class(DHCWMR.SS.Request).%New()
	}else{
		set obj=##class(DHCWMR.SS.Request).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.RQMrType         = objMrType
	set obj.RQItemDr         = objWorkItem
	set obj.RQRequestDate    = RequestDate
	set obj.RQRequestTime    = RequestTime
	set obj.RQRequestUser    = RequestUser
	set obj.RQCreateDate     = CreateDate
	set obj.RQCreateTime     = CreateTime
	set obj.RQCreateUser     = CreateUser
	set obj.RQUpdateDate     = UpdateDate
	set obj.RQUpdateTime     = UpdateTime
	set obj.RQUpdateUser     = UpdateUser
	set obj.RQReqStatus      = ReqStatus
	set obj.RQResume         = Resume
	Set obj.RQBatchNumber    = BatchNumber
	set obj.RQQCReason       = $p(aInputStr,aSeparate,16)
	set obj.RQClientName     = $p(aInputStr,aSeparate,17)
	set obj.RQClientRelation = $p(aInputStr,aSeparate,18)
	set obj.RQCardTypeDr     = $p(aInputStr,aSeparate,19)
	set obj.RQPersonalID     = $p(aInputStr,aSeparate,20)
	set obj.RQTelephone      = $p(aInputStr,aSeparate,21)
	set obj.RQAddress        = $p(aInputStr,aSeparate,22)
	set obj.RQClientNote     = $p(aInputStr,aSeparate,23)
	set obj.RQLLocTel        = $p(aInputStr,aSeparate,24)
	set obj.RQLUserCode      = $p(aInputStr,aSeparate,25)
	set obj.RQLUserName      = $p(aInputStr,aSeparate,26)
	set obj.RQLUserTel       = $p(aInputStr,aSeparate,27)
	set obj.RQLPurpose       = $p(aInputStr,aSeparate,28)
	set obj.RQLBackDate      = $p(aInputStr,aSeparate,29)
	set obj.RQLReturnStatus  = $p(aInputStr,aSeparate,30)
	set obj.RQLNote          = $p(aInputStr,aSeparate,31)
	set obj.RQCContent       = $p(aInputStr,aSeparate,32)
	set obj.RQCPurpose       = $p(aInputStr,aSeparate,33)
	set obj.RQCPageNumber    = $p(aInputStr,aSeparate,34)
	set obj.RQCUnitPrice     = $p(aInputStr,aSeparate,35)
	set obj.RQCMoneyCount    = $p(aInputStr,aSeparate,36)
	set obj.RQCNote          = $p(aInputStr,aSeparate,37)
	set obj.RQSContent       = $p(aInputStr,aSeparate,38)
	set obj.RQSPurpose       = $p(aInputStr,aSeparate,39)
	set obj.RQSCount         = $p(aInputStr,aSeparate,40)
	set obj.RQSDocCode       = $p(aInputStr,aSeparate,41)
	set obj.RQSDocName       = $p(aInputStr,aSeparate,42)
	set obj.RQSMedUserCode   = $p(aInputStr,aSeparate,43)
	set obj.RQSMedUserName   = $p(aInputStr,aSeparate,44)
	set obj.RQSNote          = $p(aInputStr,aSeparate,45)
	
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=obj.%Id()
	}
	do obj.%Close()
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-11-29
/// Description:  删除病案申请记录
/// Table：       DHCWMR.SS.Request
/// Input：       Id : DHCWMR.SS.Request.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.SS.Request).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RQMrType</Value>
</Value>
<Value name="3">
<Value>RQItemDr</Value>
</Value>
<Value name="4">
<Value>RQReqStatus</Value>
</Value>
<Value name="5">
<Value>RQRequestDate</Value>
</Value>
<Value name="6">
<Value>RQRequestTime</Value>
</Value>
<Value name="7">
<Value>RQRequestUser</Value>
</Value>
<Value name="8">
<Value>RQCreateDate</Value>
</Value>
<Value name="9">
<Value>RQCreateTime</Value>
</Value>
<Value name="10">
<Value>RQCreateUser</Value>
</Value>
<Value name="11">
<Value>RQUpdateDate</Value>
</Value>
<Value name="12">
<Value>RQUpdateTime</Value>
</Value>
<Value name="13">
<Value>RQUpdateUser</Value>
</Value>
<Value name="14">
<Value>RQResume</Value>
</Value>
<Value name="15">
<Value>RQBatchNumber</Value>
</Value>
<Value name="16">
<Value>RQQCReason</Value>
</Value>
<Value name="17">
<Value>RQClientName</Value>
</Value>
<Value name="18">
<Value>RQClientRelation</Value>
</Value>
<Value name="19">
<Value>RQCardTypeDr</Value>
</Value>
<Value name="20">
<Value>RQPersonalID</Value>
</Value>
<Value name="21">
<Value>RQTelephone</Value>
</Value>
<Value name="22">
<Value>RQAddress</Value>
</Value>
<Value name="23">
<Value>RQClientNote</Value>
</Value>
<Value name="24">
<Value>RQLLocTel</Value>
</Value>
<Value name="25">
<Value>RQLUserCode</Value>
</Value>
<Value name="26">
<Value>RQLUserName</Value>
</Value>
<Value name="27">
<Value>RQLUserTel</Value>
</Value>
<Value name="28">
<Value>RQLPurpose</Value>
</Value>
<Value name="29">
<Value>RQLBackDate</Value>
</Value>
<Value name="30">
<Value>RQLReturnStatus</Value>
</Value>
<Value name="31">
<Value>RQLNote</Value>
</Value>
<Value name="32">
<Value>RQCContent</Value>
</Value>
<Value name="33">
<Value>RQCPurpose</Value>
</Value>
<Value name="34">
<Value>RQCPageNumber</Value>
</Value>
<Value name="35">
<Value>RQCUnitPrice</Value>
</Value>
<Value name="36">
<Value>RQCMoneyCount</Value>
</Value>
<Value name="37">
<Value>RQCNote</Value>
</Value>
<Value name="38">
<Value>RQSContent</Value>
</Value>
<Value name="39">
<Value>RQSPurpose</Value>
</Value>
<Value name="40">
<Value>RQSCount</Value>
</Value>
<Value name="41">
<Value>RQSDocCode</Value>
</Value>
<Value name="42">
<Value>RQSDocName</Value>
</Value>
<Value name="43">
<Value>RQSMedUserCode</Value>
</Value>
<Value name="44">
<Value>RQSMedUserName</Value>
</Value>
<Value name="45">
<Value>RQSNote</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.SS.RequestD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.SS.RequestD</IdLocation>
<IndexLocation>^DHCWMR.SS.RequestI</IndexLocation>
<StreamLocation>^DHCWMR.SS.RequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
