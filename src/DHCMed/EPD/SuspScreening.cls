/// 传染病疑似筛查条件
Class DHCMed.EPD.SuspScreening Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 疑似诊断指针
Property BTInfectDr As DHCMed.EPD.SuspInfectDic;

/// 筛查条件
Property BTCondition As %String(MAXLEN = 100, TRUNCATE = 1);

/// 条件说明
Property BTNote As %String(MAXLEN = 500, TRUNCATE = 1);

/// 筛查类型（Key诊断关键词、ICD10诊断编码、LIS检验项目、RIS检查项目、CC主诉症状、PH药品名称）
Property BTType As %String(DISPLAYLIST = ",KEY,ICD10,LIS,RIS,CCK,PHK", VALUELIST = ",K,I,L,R,C,P");

/// 诊断关键词/ICD10/RIS（包含）
Property BTIncludeKey As %String(MAXLEN = 100, TRUNCATE = 1);

/// 诊断关键词/ICD10/RIS（除……外）
Property BTExcludeKeys As %String(MAXLEN = 200, TRUNCATE = 1);

/// 检验项目(DHCMed.EPD.SuspTestCode.ID)多值逗号分隔
Property BTLisItems As %String(MAXLEN = 100, TRUNCATE = 1);

/// 逻辑运算（并且&&）
Property BTLisLogic As %String(MAXLEN = 100, TRUNCATE = 1);

/// 有效标志
Property BTIsActive As %Boolean;

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 更新用户
Property BTActUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否流感筛查项目 add by zf 20191203
Property BTIsFlu As %Boolean;

Index IdxofInfect On BTInfectDr As Exact;

Index IdxofType On BTType As Exact;

/// Creator：     pylian
/// CreatDate：   2019-01-22
/// Description:  根据ID取传染病疑似筛查条件
/// Table：       DHCMed.EPD.SuspScreening
/// Input：       aId : DHCMed.EPD.SuspScreening.ID
/// Return：      返回obj
/// w ##class(DHCMed.EPD.SuspScreening).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.EPD.SuspScreening
{
	New (aId)
	Quit:'##class(DHCMed.EPD.SuspScreening).%ExistsId(aId) ""
	Set obj=##Class(DHCMed.EPD.SuspScreening).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2019-01-22
/// Description:  更新传染病疑似筛查条件
/// Table：       DHCMed.EPD.SuspScreening
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.EPD.SuspScreening).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:aSeparete="" aSeparete="^"
	Set ID          = $p(aInputStr,aSeparete,1)
	Set InfectDr    = $p(aInputStr,aSeparete,2)
	Set Condition   = $p(aInputStr,aSeparete,3)
	Set Note        = $p(aInputStr,aSeparete,4)
	Set Type        = $p(aInputStr,aSeparete,5)
	Set IncludeKey  = $p(aInputStr,aSeparete,6)
	Set ExcludeKeys = $p(aInputStr,aSeparete,7)
	Set LisItems    = $p(aInputStr,aSeparete,8)
	Set LisLogic    = $p(aInputStr,aSeparete,9)
	Set IsActive    = $p(aInputStr,aSeparete,10)
	Set ActDate     = $p(aInputStr,aSeparete,11)
	Set ActTime     = $p(aInputStr,aSeparete,12)
	Set ActUser     = $p(aInputStr,aSeparete,13)
	Set IsFlu       = +$p(aInputStr,aSeparete,14)
	Quit:(InfectDr="") return
	
	Set Type= $ZCVT(Type,"U")
	Set objInfectDic=##class(DHCMed.EPD.SuspInfectDic).GetObjById(InfectDr)
	Quit:'$IsObject(objInfectDic) return
	
	Set:ActDate'="" ActDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime=$zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	
	If ID="" {
		Set obj=##class(DHCMed.EPD.SuspScreening).%New()
	}Else{
		Set obj=##class(DHCMed.EPD.SuspScreening).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTInfectDr    = objInfectDic
	Set obj.BTCondition   = Condition
	Set obj.BTNote        = Note
	Set obj.BTType        = Type
	Set obj.BTIncludeKey  = IncludeKey
	Set obj.BTExcludeKeys = ExcludeKeys
	Set obj.BTLisItems    = LisItems
	Set obj.BTLisLogic    = LisLogic
	Set obj.BTIsActive    = IsActive
	Set obj.BTActDate     = ActDate
	Set obj.BTActTime     = ActTime
	Set obj.BTActUser     = ActUser
	Set obj.BTIsFlu       = IsFlu
    
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

/// Creator：     pylian
/// CreatDate：   2019-01-22
/// Description:  删除传染病疑似筛查条件
/// Table：       DHCMed.EPD.SuspScreening
/// Input：       aId : DHCMed.EPD.SuspScreening.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMed.EPD.SuspScreening).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMed.EPD.SuspScreening")
	Quit:Flg'=1 -777
	Set sc = ##class(DHCMed.EPD.SuspScreening).%DeleteId(aId)
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
<Data name="SuspScreeningDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTInfectDr</Value>
</Value>
<Value name="3">
<Value>BTCondition</Value>
</Value>
<Value name="4">
<Value>BTNote</Value>
</Value>
<Value name="5">
<Value>BTType</Value>
</Value>
<Value name="6">
<Value>BTIncludeKey</Value>
</Value>
<Value name="7">
<Value>BTExcludeKeys</Value>
</Value>
<Value name="8">
<Value>BTLisItems</Value>
</Value>
<Value name="9">
<Value>BTLisLogic</Value>
</Value>
<Value name="10">
<Value>BTIsActive</Value>
</Value>
<Value name="11">
<Value>BTActDate</Value>
</Value>
<Value name="12">
<Value>BTActTime</Value>
</Value>
<Value name="13">
<Value>BTActUser</Value>
</Value>
<Value name="14">
<Value>BTIsFlu</Value>
</Value>
</Data>
<DataLocation>^DHCMed.EPD.SuspScreeningD</DataLocation>
<DefaultData>SuspScreeningDefaultData</DefaultData>
<IdLocation>^DHCMed.EPD.SuspScreeningD</IdLocation>
<IndexLocation>^DHCMed.EPD.SuspScreeningI</IndexLocation>
<StreamLocation>^DHCMed.EPD.SuspScreeningS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
