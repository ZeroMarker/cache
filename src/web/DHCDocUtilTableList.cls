/// 名称:     web.DHCDocUtilTableList
/// 描述:     dhcdoc.util.tablelist.csp 对应的后台数据处理
/// 编写者:   renyx
/// 编写日期: 2023.01.13
Class web.DHCDocUtilTableList Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// desc：根据数据以及数据类型返回翻译后的数据
/// input: Data:需要翻译的数据，DataType:数据类型
/// output: 翻译后的数据
ClassMethod GetTranslateDataByType(Data As %String, DataType As %String)
{
	Set langid=..%LanguageID()
	if (DataType="ARC_ItmMast"){
		s Data=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",Data,langid)
	}
	q Data
}

ClassMethod GetDataForCmbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmbExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// 由于前段的lookup调用的是基础平台的类，需要进行封装翻译所以增加该方法使用
/// input:MyClassName：查询类名 , MyQueryName：查询方法名 , QueryDescName：查询方法查询条件入参的描述 , QueryHospName：查询方法院区入参的描述 , IDFieldName：查询方法输出的id描述 , DescFieldName：查询方法输出的描述描述 , TableName：前段传过来的表名，用于翻译, QueryDesc：查询的描述 , QueryHosp：院区id
/// output:AppendID：ID,AppendDesc：描述           
/// d ##class(%ResultSet).RunQuery("web.DHCDocUtilTableList","GetDataForCmb","web.DHCBL.CT.ARCItmMast","GetDataForCmb1","desc","hospid","ARCIMRowId","ARCIMDesc","ARC_ItmMast","ptt","2")
ClassMethod GetDataForCmbExecute(ByRef qHandle As %Binary, MyClassName As %String, MyQueryName As %String, QueryDescName As %String, QueryHospName As %String, IDFieldName As %String, DescFieldName As %String, TableName As %String, QueryDesc As %String, QueryHosp As %String) As %Status
{
	//n (MyClassName , MyQueryName , QueryDescName , QueryHospName , IDFieldName , DescFieldName , TableName, QueryDesc , QueryHosp,%session)
	s ^tempren("GetDataForCmbExecute")=$lb(MyClassName , MyQueryName , QueryDescName , QueryHospName , IDFieldName , DescFieldName , TableName, QueryDesc , QueryHosp)
	Set repid=$I(^CacheTemp)
	s ind=1
	; 先组织方法入参
	s ArgumentS=$G(^oddCOM(MyClassName,"q",MyQueryName,25))
	Set result=##Class(%ResultSet).%New(MyClassName_":"_MyQueryName)
	//s sc=rs.Execute("","",QueryDesc,"","","","",QueryHosp) 
	s ExcuteStr="result.Execute("
	for i=1:1:$listlength(ArgumentS){
		s Argument=$LISTGET(ArgumentS,i)
		s val=""
		if (Argument=QueryDescName){
			s val=QueryDesc
		}elseif (Argument=QueryHospName){
			//找到lookup的院区列
			s val=QueryHosp
		}
		i i=1 s ExcuteStr=ExcuteStr_""""_val_""""
		e  s ExcuteStr=ExcuteStr_","""_val_""""
	}
	s ExcuteStr=ExcuteStr_")"
	//s ^tempren("1")="s sc="_ExcuteStr
	x "s sc="_ExcuteStr
	While(result.Next())
	{
		b 
		s AppendID=result.GetDataByName(IDFieldName)
		s AppendDesc=result.GetDataByName(DescFieldName)
		s AppendDesc=..GetTranslateDataByType(AppendDesc,TableName)
		do OutputRow
	}
	//d rs.Close()
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow      
	set Data=$lb(AppendID,AppendDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod GetDataForCmbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmbExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetDataForCmb(MyClassName As %String, MyQueryName As %String, QueryDescName As %String, QueryHospName As %String, IDFieldName As %String, DescFieldName As %String, TableName As %String, QueryDesc As %String, QueryHosp As %String) As %Query(ROWSPEC = "AppendID:%String,AppendDesc:%String")
{
}

}
