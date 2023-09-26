/// 名称: DHCHAI.AM.AssessModel
/// 描述: 疑似病例筛查评估模型
/// 编写者：zhufei
/// 编写日期: 2019-03-13
Class DHCHAI.AM.AssessModel Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 评估模型代码
Property AMCode As %String(MAXLEN = 50, TRUNCATE = 1);

/// 评估模型定义
Property AMDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property AMIsActive As %Boolean;

/// 就诊状态（A在院、D出院）
Property AMAdmStatus As %String(MAXLEN = 50, TRUNCATE = 1);

/// 开始日期
Property AMSttDate As %Date;

/// 结束日期
Property AMEndDate As %Date;

/// 类方法
Property AMClassName As %String(MAXLEN = 200, TRUNCATE = 1);

/// 规则说明
Property AMNote As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 启用规则
Property AMSuRule As %String(MAXLEN = 500, TRUNCATE = 1);

/// 评估类型（1：评估，2：统计）
Property AMType As %String(MAXLEN = 50, TRUNCATE = 1);

/// 代码索引
Index IdxofCode On AMCode;

/// Creator：     zhufei
/// CreatDate：   2019-03-13
/// Description:  根据ID取评估模型信息
/// Table：       DHCHAI.AM.AssessModel
/// Input：       aId : DHCHAI.AM.AssessModel.ID
/// Return：      返回obj
/// w ##class(DHCHAI.AM.AssessModel).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.AM.AssessModel
{
	New (aId)
	Quit:'##class(DHCHAI.AM.AssessModel).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.AM.AssessModel).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2019-03-13
/// Description:  更新评估模型信息
/// Table：       DHCHAI.AM.AssessModel
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.AM.AssessModel).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID        = $p(aInputStr,aSeparete,1)
	Set Code      = $p(aInputStr,aSeparete,2)
	Set Desc      = $p(aInputStr,aSeparete,3)
	Set IsActive  = +$p(aInputStr,aSeparete,4)
	Set AdmStatus = $p(aInputStr,aSeparete,5)
	Set SttDate   = $p(aInputStr,aSeparete,6)
	Set EndDate   = $p(aInputStr,aSeparete,7)
	Set ClassName = $p(aInputStr,aSeparete,8)
	Set Note      = $p(aInputStr,aSeparete,9)
	Set SuRule    = $p(aInputStr,aSeparete,10)
	Set Type      = $p(aInputStr,aSeparete,11)
	Quit:(Code="")||(Desc="") return
	
	Set:SttDate'="" SttDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(SttDate)
	Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(EndDate)
	
	Set tID=$o(^DHCHAI.AM.AssessModelI("IdxofCode"," "_$zcvt(Code,"U"),0))
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCHAI.AM.AssessModel).%New()
	}Else{
		Set obj=##class(DHCHAI.AM.AssessModel).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.AMCode       = Code
	Set obj.AMDesc       = Desc
	Set obj.AMIsActive   = IsActive
	Set obj.AMAdmStatus  = AdmStatus
	Set obj.AMSttDate    = SttDate
	Set obj.AMEndDate    = EndDate
	Set obj.AMClassName  = ClassName
	Set obj.AMNote       = Note
	Set obj.AMSuRule     = SuRule
	Set obj.AMType       = Type
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-03-13
/// Description:  删除评估模型信息
/// Table：       DHCHAI.AM.AssessModel
/// Input：       aId : DHCHAI.AM.AssessModel.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.AM.AssessModel).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.AM.AssessModel).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="AssessModelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AMCode</Value>
</Value>
<Value name="3">
<Value>AMDesc</Value>
</Value>
<Value name="4">
<Value>AMIsActive</Value>
</Value>
<Value name="5">
<Value>AMAdmStatus</Value>
</Value>
<Value name="6">
<Value>AMSttDate</Value>
</Value>
<Value name="7">
<Value>AMEndDate</Value>
</Value>
<Value name="8">
<Value>AMClassName</Value>
</Value>
<Value name="9">
<Value>AMNote</Value>
</Value>
<Value name="10">
<Value>AMSuRule</Value>
</Value>
<Value name="11">
<Value>AMType</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.AM.AssessModelD</DataLocation>
<DefaultData>AssessModelDefaultData</DefaultData>
<IdLocation>^DHCHAI.AM.AssessModelD</IdLocation>
<IndexLocation>^DHCHAI.AM.AssessModelI</IndexLocation>
<StreamLocation>^DHCHAI.AM.AssessModelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
