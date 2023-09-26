Class web.DHCBL.KB.Measure Extends %RegisteredObject
{

/// Description:为combobox查询取数据
/// Table：%BI.Measure
/// Input：rowid,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.Measure","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "RowId:%String,CatName:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowId=rowid
		s CatName=$listget($g(^BI.MeasureD(RowId)),3)
		d OutputRow
	}
	else
	{
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s RowId=0
		for {
			s RowId=$o(^BI.MeasureD(RowId))
			q:RowId=""
	
			s CatName=$listget($g(^BI.MeasureD(RowId)),3)
			if ($ZCONVERT(CatName,"U")[desc)
			{
				d OutputRow
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowId,CatName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

/*
/// TestSave
/// w ##class(web.DHCBL.KB.Measure).SaveData()
ClassMethod SaveData() As %String
{
    	
	s result = ""
    s obj=##class(%BI.Measure).%New()

	; 保存操作test
    s obj.CatName="指标编码"
	s obj.ClassName="Data.StatDoctorKPI"
	s obj.Definition="Values"

	s sc=obj.%Save()
	d obj.%Close()	
	
	If $$$ISOK(sc){
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}"    
	}else{
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
	}			
	q result
}
*/
}
