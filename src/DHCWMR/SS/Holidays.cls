/// 节假日、工作日
Class DHCWMR.SS.Holidays Extends (%Persistent, DHCWMR.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 年份
Property HYear As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 节日名称
Property HName As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 节日别名
Property HAlias As %String(MAXLEN = 100, TRUNCATE = 1);

/// 日期
Property HDate As %Date [ Required ];

/// 类型(节假日H、工作日W)
Property HType As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 日期索引
Index IndexDate On HDate;

/// Creator：     liyi
/// CreatDate：   2014-12-01
/// Description:  取节假日
/// Table：       DHCWMR.SS.Holidays
/// Input：       Id : DHCWMR.SS.Holidays.ID
/// Return：      返回Object
/// w ##class(DHCWMR.SS.Holidays).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.SS.Holidays
{
	new (aId)
	quit:'##class(DHCWMR.SS.Holidays).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.SS.Holidays).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2014-12-01
/// Description:  更新节假日
/// Table：       DHCWMR.SS.Holidays
/// Input：       InputStr ：ID^节日名称^日期^类型^备注
///               Separate : 分隔符
/// Return：      返回%Id()值
/// w ##class(DHCWMR.SS.Holidays).Update()
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID    =$p(aInputStr,aSeparate,1)
	Set Name  =$p(aInputStr,aSeparate,2)
	Set Date  =$p(aInputStr,aSeparate,3)
	Set Type  =$p(aInputStr,aSeparate,4)
	Set HAlias=$p(aInputStr,aSeparate,5)
	
	;Set:Date["-" Date=$zdh(Date,3)
	;Set:Date["/" Date=$zdh(Date,4)
	Set:Date'="" Date=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(Date)
	Set Year = +$zdate(Date,3)
	Quit:(Date="")||(Type="")||(Year="") return
	
	If ID="" {
		Set ID=$o(^DHCWMR.SS.HolidaysI("IndexDate",Date,""))
	} Else {
		Set xID=$o(^DHCWMR.SS.HolidaysI("IndexDate",Date,""))
		Set return=-100
		Quit:(xID'="")&&(xID'=ID) return
	}
	
	If ID="" {
		Set obj=##class(DHCWMR.SS.Holidays).%New()
	} Else {
		Set obj=##class(DHCWMR.SS.Holidays).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.HName    = Name
	Set obj.HYear    = Year
	Set obj.HDate    = Date
	Set obj.HType    = Type
	Set obj.HAlias  = HAlias
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
/// CreatDate：   2014-12-01
/// Description:  删除节假日
/// Table：       DHCWMR.SS.Holidays
/// Input：       Id : DHCWMR.SS.Holidays.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCWMR.SS.Holidays).%DeleteId(aId)
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
<Data name="HolidaysDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HDate</Value>
</Value>
<Value name="3">
<Value>HYear</Value>
</Value>
<Value name="4">
<Value>HType</Value>
</Value>
<Value name="5">
<Value>HAlias</Value>
</Value>
<Value name="6">
<Value>HName</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.SS.HolidaysD</DataLocation>
<DefaultData>HolidaysDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.SS.HolidaysD</IdLocation>
<IndexLocation>^DHCWMR.SS.HolidaysI</IndexLocation>
<StreamLocation>^DHCWMR.SS.HolidaysS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
