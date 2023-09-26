/// 病案修改日志
Class DHCWMR.SS.MergerLog Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 修改类型（0：修改号码，1：合并病案，2：拆分病案）
Property MLType As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 修改前病案ID
Property MLBMainDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 修改前病案号码
Property MLBMrNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 修改后的病案ID
Property MLEMainDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 修改后的病案号码
Property MLEMrNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 修改前病案卷ID（多卷ID以#分割） 
Property MLBVolIDs As %String(MAXLEN = 100, TRUNCATE = 1);

/// 修改后病案卷ID（多卷ID以#分割） 
Property MLEVolIDs As %String(MAXLEN = 100, TRUNCATE = 1);

/// 修改时间
Property MLDate As %Date;

/// 修改时间
Property MLTime As %Time;

/// 修改科室(指向CT_Loc)
Property MLLoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 修改用户(指向SS_User)
Property MLUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// Creator：     liyi
/// CreatDate：   2014-09-12
/// Description:  插入病案修改日志
/// Table：       DHCWMR.SS.MergerLog
/// Input：       InputStr ：ID^MLType^MLBMainDr^MLBMrNo^MLEMainDr^MLEMrNo^MLBVolIDs^MLEVolIDs^MLDate^MLTime^MLLoc^MLUser
///               Separate : 分隔符
/// Return：      返回%Id()值
/// w ##class(DHCWMR.SS.MergerLog).Update()
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID=$p(aInputStr,aSeparate,1)
	Set Type=$p(aInputStr,aSeparate,2)
	Set BMainDr=$p(aInputStr,aSeparate,3)
	Set BMrNo=$p(aInputStr,aSeparate,4)
	Set EMainDr=$p(aInputStr,aSeparate,5)
	Set EMrNo=$p(aInputStr,aSeparate,6)
	Set BVolIDs=$p(aInputStr,aSeparate,7)
	Set EVolIDs=$p(aInputStr,aSeparate,8)
	Set Date=$p(aInputStr,aSeparate,9)
	Set Time=$p(aInputStr,aSeparate,10)
	Set Loc=$p(aInputStr,aSeparate,11)
	Set User=$p(aInputStr,aSeparate,12)
	Quit:(Type="") return
	
	If ID="" {
		Set obj=##class(DHCWMR.SS.MergerLog).%New()
	} Else {
		Set obj=##class(DHCWMR.SS.MergerLog).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.MLType    = Type
	Set obj.MLBMainDr = BMainDr
	Set obj.MLBMrNo   = BMrNo
	Set obj.MLEMainDr = EMainDr
	Set obj.MLEMrNo   = EMrNo
	Set obj.MLBVolIDs = BVolIDs
	Set obj.MLEVolIDs = EVolIDs
	Set obj.MLDate    = Date
	Set obj.MLTime    = Time
	Set obj.MLLoc     = Loc
	Set obj.MLUser    = User
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}	
	Quit return
}

Storage Default
{
<Data name="MergerLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MLType</Value>
</Value>
<Value name="3">
<Value>MLBMainDr</Value>
</Value>
<Value name="4">
<Value>MLBMrNo</Value>
</Value>
<Value name="5">
<Value>MLLMainDr</Value>
</Value>
<Value name="6">
<Value>MLLMrNo</Value>
</Value>
<Value name="7">
<Value>MLDate</Value>
</Value>
<Value name="8">
<Value>MLTime</Value>
</Value>
<Value name="9">
<Value>MLLoc</Value>
</Value>
<Value name="10">
<Value>MLUser</Value>
</Value>
<Value name="11">
<Value>MLEMainDr</Value>
</Value>
<Value name="12">
<Value>MLEMrNo</Value>
</Value>
<Value name="13">
<Value>MLBVolIDs</Value>
</Value>
<Value name="14">
<Value>MLEVolIDs</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.SS.MergerLogD</DataLocation>
<DefaultData>MergerLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.SS.MergerLogD</IdLocation>
<IndexLocation>^DHCWMR.SS.MergerLogI</IndexLocation>
<StreamLocation>^DHCWMR.SS.MergerLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
