/// 名称: CT.IPMR.BT.Holidays
/// 描述: 节假日
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.BT.Holidays Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 年份
Property BHYear As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 节日名称
Property BHName As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 节日别名
Property BHAlias As %String(MAXLEN = 100, TRUNCATE = 1);

/// 日期
Property BHDate As %Date [ Required ];

/// 类型(节假日H、工作日W)(假日WEND)
Property BHType As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 日期索引
Index IndexDate On BHDate;

/// 日期类型索引
Index IndexDateType On (BHType As Exact, BHDate);

/// Creator：     whui
/// CreatDate：   2019-10-16
/// Description:  取节假日
/// Table：       CT.IPMR.BT.Holidays
/// Input：       aId : CT.IPMR.BT.Holidays.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.BT.Holidays).GetObjById(1)
ClassMethod GetObjById(aId As %String) As CT.IPMR.BT.Holidays
{
	New (aId)
	Quit:'##class(CT.IPMR.BT.Holidays).%ExistsId(aId) ""
	Set obj = ##Class(CT.IPMR.BT.Holidays).%OpenId(aId)
	do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     whui
/// CreatDate：   2019-10-16
/// Description:  更新节假日
/// Table：       CT.IPMR.BT.Holidays
/// Input：       InputStr ：ID^节日名称^日期^类型^节日别名
///               Separate : 分隔符
/// Return：      返回%Id()值
/// w ##class(CT.IPMR.BT.Holidays).Update("^元旦^2019-01-01^H^元旦","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID		= $p(aInputStr,aSeparate,1)
	Set Name	= $p(aInputStr,aSeparate,2)
	Set Date	= $p(aInputStr,aSeparate,3)
	Set Type	= $p(aInputStr,aSeparate,4)
	Set Alias	= $p(aInputStr,aSeparate,5)
	
	Set Date = ##Class(MA.IPMR.ImedicalSrv).DateHtmlToLogical(Date)
	Set Year = +$zdate(Date,3)
	Quit:(Date="")||(Type="")||(Year="") return
	
	If ID=""{
		Set ID=$o(^CT.IPMR.BT.HolidaysI("IndexDate",Date,""))
	}Else{
		Set xID=$o(^CT.IPMR.BT.HolidaysI("IndexDate",Date,""))
		Set return=-100
		Quit:(xID'="")&&(xID'=ID) return
	}
	
	If ID=""{
		Set obj=##class(CT.IPMR.BT.Holidays).%New()
	}Else{
		Set obj=##class(CT.IPMR.BT.Holidays).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BHName	= Name
	Set obj.BHDate	= Date
	Set obj.BHType	= Type
	Set obj.BHAlias	= Alias
	Set obj.BHYear	= Year
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	
	Quit return
}

/// Creator：     whui
/// CreatDate：   2019-10-16
/// Description:  删除节假日
/// Table：       CT.IPMR.BT.Holidays
/// Input：       aId : CT.IPMR.BT.Holidays.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.BT.Holidays).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set return=-1	
	Set sc = ##class(CT.IPMR.BT.Holidays).%DeleteId(aId)
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
<Value>BHYear</Value>
</Value>
<Value name="3">
<Value>BHName</Value>
</Value>
<Value name="4">
<Value>BHAlias</Value>
</Value>
<Value name="5">
<Value>BHDate</Value>
</Value>
<Value name="6">
<Value>BHType</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.BT.HolidaysD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.BT.HolidaysD</IdLocation>
<IndexLocation>^CT.IPMR.BT.HolidaysI</IndexLocation>
<StreamLocation>^CT.IPMR.BT.HolidaysS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
