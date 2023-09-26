/// 就诊出库条打印记录（自动）
Class DHCWMR.MO.LendBar Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 病案类型
Property MLMrType As DHCWMR.SS.MrType;

/// 就诊号
Property MLEpisodeID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 就诊前病历出库记录
Property MLLendRecordDr As DHCWMR.MO.LendRecord;

/// 打印标记
Property MLPrintFlg As %Boolean;

/// 就诊前病历是否出库
Property MLIsLend As %Boolean;

/// 创建日期
Property MLCreateDate As %Date;

/// 病案类型 + 创建时间 + 打印标记 索引
Index IndexMrTypeCreateDatePrintFlg On (MLMrType, MLCreateDate, MLPrintFlg);

/// 就诊号索引
Index IndexEpisodeID On MLEpisodeID;

/// 出库记录索引
Index IndexLendRecordDr On MLLendRecordDr;

/// Creator：     liyi
/// CreatDate：   2015-11-16
/// Description:  取病打印记录
/// Table：       DHCWMR.MO.LendBar
/// Input：       Id : DHCWMR.MO.LendBar.ID
/// Return：      返回Object
/// w ##class(DHCWMR.MO.LendBar).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.MO.LendBar
{
	new (aId)
	quit:'##class(DHCWMR.MO.LendBar).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.MO.LendBar).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2015-11-16
/// Description:  更新打印记录
/// Table：       DHCWMR.MO.LendBar
/// Input：       InputStr 
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCWMR.MO.LendBar).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID			=$p(aInputStr,aSeparate,1)
	Set MrTypeID	=$p(aInputStr,aSeparate,2)
	Set EpisodeID	=$p(aInputStr,aSeparate,3)
	Set LendRecordDr=$p(aInputStr,aSeparate,4)
	Set PrintFlg	=$p(aInputStr,aSeparate,5)
	Set IsLend		=$p(aInputStr,aSeparate,6)
	Set CreateDate	=$p(aInputStr,aSeparate,7)
	set:CreateDate["-" CreateDate=$zdh(CreateDate,3)
	set:CreateDate["/" CreateDate=$zdh(CreateDate,4)
	Quit:(EpisodeID="")||(PrintFlg="")||(IsLend="")||(CreateDate="")||(MrTypeID="") return
	
	Set objLendRecord = ""
	Set:LendRecordDr'="" objLendRecord=##class(DHCWMR.MO.LendRecord).GetObjById(LendRecordDr)
	
	Set objMrType = ##class(DHCWMR.SS.MrType).GetObjById(MrTypeID)
	Quit:'$IsObject(objMrType) return
	
	If ID="" {
		Set obj=##class(DHCWMR.MO.LendBar).%New()
	} Else {
		Set obj=##class(DHCWMR.MO.LendBar).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.MLMrType		= objMrType
	Set obj.MLEpisodeID     = EpisodeID
	Set obj.MLLendRecordDr  = objLendRecord
	Set obj.MLPrintFlg     	= PrintFlg
	Set obj.MLIsLend     	= IsLend
	Set obj.MLCreateDate    = CreateDate
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

/// Creator：     liyi
/// CreatDate：   2015-11-04
/// Description:  更新打印标志
/// Table：       DHCWMR.MO.LendBar
/// Input：       InputStr ：ID^打印标志
///               Separate : 分隔符
/// Return：      返回%Id()值
/// w ##class(DHCWMR.MO.LendBar).UpdatePrintFlag("","^")
ClassMethod UpdatePrintFlag(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID 				= $p(aInputStr,aSeparate,1)
	Set PrintFlag		= $p(aInputStr,aSeparate,2)
	Quit:(ID="")||(PrintFlag="") return
	
	Set obj=##class(DHCWMR.MO.LendBar).%OpenId(ID)
	Quit:'$IsObject(obj) return
	
	Set obj.MLPrintFlg		=PrintFlag
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-11-16
/// Description:  删除打印记录
/// Table：       DHCWMR.MO.LendBar
/// Input：       Id : DHCWMR.MO.LendBar.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCWMR.MO.LendBar).%DeleteId(aId)
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
<Value>MLMrType</Value>
</Value>
<Value name="3">
<Value>MLEpisodeID</Value>
</Value>
<Value name="4">
<Value>MLLendRecordDr</Value>
</Value>
<Value name="5">
<Value>MLPrintFlg</Value>
</Value>
<Value name="6">
<Value>MLIsLend</Value>
</Value>
<Value name="7">
<Value>MLCreateDate</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.MO.LendBarD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.MO.LendBarD</IdLocation>
<IndexLocation>^DHCWMR.MO.LendBarI</IndexLocation>
<StreamLocation>^DHCWMR.MO.LendBarS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
