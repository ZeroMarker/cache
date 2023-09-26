Class CIS.AN.BL.PrintConfigration Extends %RegisteredObject
{

/// w ##class(CIS.AN.BL.PrintConfigration).AddPrintTable("arrange","unarrangelist.xls","4")
ClassMethod AddPrintTable(code As %String, template As %String = "", startRow As %String = "", description As %String = "") As %String
{
	s code=$g(code)
	q:code="" "E^code is null"
	s $zt="Error"
	//^CF.AN.PrintConfigrationI("ICode"," ARRANGE",1)
	i ($d(^CF.AN.PrintConfigrationI("ICode"," "_$System.SQL.UPPER(code)))>0)&&($o(^CF.AN.PrintConfigrationI("ICode"," "_$System.SQL.UPPER(code),0))'="") d
	.s obj=##class(CF.AN.PrintConfigration).%OpenId($o(^CF.AN.PrintConfigrationI("ICode"," "_$System.SQL.UPPER(code),0)))
	e  d
	.s obj=##class(CF.AN.PrintConfigration).%New()
	s obj.Code=code
	s obj.Template=template
	s obj.StartRow=startRow
	s obj.Description=description
	s sc=obj.%Save()
	q:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	q "S^"_obj.%Id()
Error
	q "E^"_$ze
}

/// Creator：        唐潇
/// CreatDate：      2020-03-17
/// Description：    查询打印配置表单
/// Table：          CF.AN.PrintConfigration
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.PrintConfigration","FindPrintTable")
Query FindPrintTable() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT * from CF_AN.PrintConfigration
}

/// w ##class(CIS.AN.BL.PrintConfigration).AddPrintConfigData("RoomDesc","术间","column","50","A",1)
ClassMethod AddPrintConfigData(field As %String, fieldDesc As %String, printType As %String, width As %String, location As %String, printTable As %String) As %String
{
	s field=$g(field),fieldDesc=$g(fieldDesc),printType=$g(printType),width=$g(width),location=$g(location),printTable=$g(printTable)
	q:field="" "E^field is null"
	q:printType="" "E^printType is null"
	q:width="" "E^width is null"
	q:location="" "E^location is null"
	q:printTable="" "E^printTable is null"
	s $zt="Error"
	s obj=##class(CF.AN.PrintConfigrationData).%New()
	s obj.Field=field
	s obj.FieldDesc=fieldDesc
	s obj.Location=location
	d obj.PrintTableSetObjectId(printTable)
	s obj.PrintType=printType
	s obj.Width=width
	s sc=obj.%Save()
	q:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	q "S^"_obj.%Id()
Error
	q "E^"_$ze
}

/// w ##class(CIS.AN.BL.PrintConfigration).SavePrintConfigData(1,"RoomDesc","术间","column","50","A",1)
ClassMethod SavePrintConfigData(saveId As %String, field As %String, fieldDesc As %String, printType As %String, width As %String, location As %String, printTable As %String) As %String
{
	s saveId=$g(saveId),field=$g(field),fieldDesc=$g(fieldDesc),printType=$g(printType),width=$g(width),location=$g(location),printTable=$g(printTable)
	q:saveId="" "E^saveId is null"
	q:field="" "E^field is null"
	q:printType="" "E^printType is null"
	q:width="" "E^width is null"
	q:location="" "E^location is null"
	q:printTable="" "E^printTable is null"
	q:'##class(CF.AN.PrintConfigrationData).%ExistsId(saveId) "E^ saveId is not exist"
	s $zt="Error"
	s obj=##class(CF.AN.PrintConfigrationData).%OpenId(saveId)
	s obj.Field=field
	s obj.FieldDesc=fieldDesc
	s obj.Location=location
	d obj.PrintTableSetObjectId(printTable)
	s obj.PrintType=printType
	s obj.Width=width
	s sc=obj.%Save()
	q:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	q "S^"_obj.%Id()
Error
	q "E^"_$ze
}

/// Creator：        唐潇
/// CreatDate：      2020-03-17
/// Description：    查询打印配置数据
/// Table：          CF.AN.PrintConfigrationData
/// Input:          printTable  打印表单ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.PrintConfigration","FindPrintConfigDatas")
Query FindPrintConfigDatas(printTable As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,
       Field,
       FieldDesc,
       PrintType,
       %External(PrintType) As PrintTypeDesc,
       Width,
       Location,
       PrintTable,
       PrintTable->Code As TableCode,
       PrintTable->Description As TableDesc,
       PrintTable->Template As Template,
       PrintTable->StartRow As StartRow
       from CF_AN.PrintConfigrationData
       where (PrintTable=:printTableor) or (:printTableor is null)
}

/// w ##class(CIS.AN.BL.PrintConfigration).DeletePrintConfigData(1)
ClassMethod DeletePrintConfigData(delId As %String) As %String
{
	s delId=$g(delId)
	q:delId="" "E^delId is null"
	q:'##class(CF.AN.PrintConfigrationData).%ExistsId(delId) "E^ delId is not exist"
	s $zt="Error"
	d ##class(CF.AN.PrintConfigrationData).%DeleteId(delId)
	q "S^操作成功"
Error
	q "E^"_$ze
}

}
