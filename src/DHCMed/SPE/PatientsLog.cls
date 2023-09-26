/// ClassName:    DHCMed.SPE.Patients
/// Description:  特殊患者记录日志
/// Creator：     zhufei
/// CreatDate:    2014-07-24
Class DHCMed.SPE.PatientsLog Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.SPE.Patients [ Cardinality = parent, Inverse = ChildLog ];

/// 处置状态("SPEStatus")
Property PSLStatus As DHCMed.SS.Dictionary;

/// 处置意见（消息体）
Property PSLOpinion As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 处置日期（消息发送日期）
Property PSLActDate As %Date;

/// 处置时间（消息发送时间）
Property PSLActTime As %Time;

/// 处置人(SS_User.ID  消息发送时间)
Property PSLActUser As %String(TRUNCATE = 1);

/// 消息类型(1临床消息、2管理科消息)
Property PSLNewsType As %Integer;

/// 是否阅读
Property PSLIsRead As %Integer;

/// 阅读日期
Property PSLReadDate As %Date;

/// 阅读时间
Property PSLReadTime As %Time;

/// 阅读人(SS_User.ID)
Property PSLReadUser As %String(TRUNCATE = 1);

/// 是否有效
Property PSLIsActive As %Boolean;

/// 更新日期
Property PSLUpdateDate As %Date;

/// 更新时间
Property PSLUpdateTime As %Time;

/// 更新人(SS_User.ID)
Property PSLUpdateUser As %String(TRUNCATE = 1);

Index IndexIsReadNews On (PSLIsRead, PSLActDate, PSLActTime);

Index IndexActDateTime On (PSLActDate, PSLActTime);

Index IndexReadDateTime On (PSLReadDate, PSLReadTime);

/// Creator：     zhufei
/// CreatDate：   2014-07-24
/// Description:  取值特殊患者记录日志
/// Table：       DHCMed.SPE.PatientsLog
/// Input：       DHCMed.SPE.PatientsLog.ID
/// Return：      返回obj
/// w ##class(DHCMed.SPE.PatientsLog).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.SPE.PatientsLog
{
	New (aId)
	Set obj=##Class(DHCMed.SPE.PatientsLog).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2014-07-24
/// Description:  更新特殊患者记录日志
/// Table：       DHCMed.SPE.PatientsLog
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.SPE.PatientsLog).Update("2^^4613^1^366^初步意见^^63392^76394^366","^")
ClassMethod Update(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	
	Set ParRef=$p(aInput,aSeparate,1)
	Set ChildSub=$p(aInput,aSeparate,2)
	If (ChildSub="") {
		Set obj=##class(DHCMed.SPE.PatientsLog).%New()
	} Else {
		Set obj=##class(DHCMed.SPE.PatientsLog).%OpenId(ParRef_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ParRef=##class(DHCMed.SPE.Patients).GetObjById(ParRef)
	Set obj.PSLStatus=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,3))
	Set obj.PSLOpinion=$p(aInput,aSeparate,4)
	Set obj.PSLActDate=$p(aInput,aSeparate,5)
	Set obj.PSLActTime=$p(aInput,aSeparate,6)
	Set obj.PSLActUser=$p(aInput,aSeparate,7)
	Set obj.PSLNewsType=$p(aInput,aSeparate,8)
	Set obj.PSLIsRead=$p(aInput,aSeparate,9)
	Set obj.PSLReadDate=$p(aInput,aSeparate,10)
	Set obj.PSLReadTime=$p(aInput,aSeparate,11)
	Set obj.PSLReadUser=$p(aInput,aSeparate,12)
	Set obj.PSLIsActive=+$p(aInput,aSeparate,13)
	Set obj.PSLUpdateDate=+$h
	Set obj.PSLUpdateTime=$p($h,",",2)
	Set obj.PSLUpdateUser=$p(aInput,aSeparate,14)
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-07-24
/// Description:  删除特殊患者记录日志
/// Table：       DHCMed.SPE.PatientsLog
/// Input：       DHCMed.SPE.PatientsLog.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.SPE.PatientsLog).DeleteById()
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.SPE.PatientsLog).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PSLStatus</Value>
</Value>
<Value name="3">
<Value>PSLOpinion</Value>
</Value>
<Value name="4">
<Value>PSLActDate</Value>
</Value>
<Value name="5">
<Value>PSLActTime</Value>
</Value>
<Value name="6">
<Value>PSLActUser</Value>
</Value>
<Value name="7">
<Value>PSLIsRead</Value>
</Value>
<Value name="8">
<Value>PSLReadDate</Value>
</Value>
<Value name="9">
<Value>PSLReadTime</Value>
</Value>
<Value name="10">
<Value>PSLReadUser</Value>
</Value>
<Value name="11">
<Value>PSLNewsType</Value>
</Value>
<Value name="12">
<Value>PSLIsActive</Value>
</Value>
<Value name="13">
<Value>PSLUpdateDate</Value>
</Value>
<Value name="14">
<Value>PSLUpdateTime</Value>
</Value>
<Value name="15">
<Value>PSLUpdateUser</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Log")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Log")</IdLocation>
<IndexLocation>^DHCMed.SPEi("Pat",0,"Log")</IndexLocation>
<StreamLocation>^DHCMed.SPE.PatientsLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
