/// 名称:EMRservice.HISInterface.StdDictionary
/// 描述:电子病历取字典外部接口
/// 编写者：wangyu
/// 编写日期: 2020-05-12
Class EMRservice.HISInterface.StdDictionary Extends (%RegisteredObject, %XML.Adaptor)
{

/// Create:	wangyu
/// Desc:	查询【自费药品】
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
/// Others:    d ##class(%ResultSet).RunQuery("EMRservice.HISInterface.StdDictionary", "GetStdDictionaryList","5")
/// d ##class(%ResultSet).RunQuery("web.DHCInterFacelyn","GetInsuTar","5")
Query GetStdDictionaryList(AEpisodeID As %String) As %Query(ROWSPEC = "INTIMxmmc:%String,INTIMxmcode:%String")
{
}

ClassMethod GetStdDictionaryListExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
  	s ind=1 
	q:(##class(%Dictionary.CompiledClass).%ExistsId("web.DHCInterFacelyn") = "0")
	q:(##class(%Dictionary.CompiledQuery).%ExistsId("web.DHCInterFacelyn||GetInsuTar") = "0")
	s ds = ##Class(%Library.ResultSet).%New("web.DHCInterFacelyn:GetInsuTar")
	d ds.Execute(AEpisodeID)
	While (ds.Next())
	{
		s CodeValue = ds.Data("INTIMxmmc")
		s DescValue = ds.Data("INTIMxmcode")
		d OutPut
	}
	Set qHandle=$lb(0,repid,0)
  	Quit $$$OK
OutPut
    set Data=$lb(CodeValue,DescValue)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetStdDictionaryListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStdDictionaryListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetStdDictionaryListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStdDictionaryListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}
