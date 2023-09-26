Class web.DHCPE.GroupDiagnosisPercent Extends %Persistent
{

/// Descript:保存疾病发病率
/// Creator:	sunxintao
/// CreateDate:	2022-12-06
/// Input:		
/// 				Year:年份
/// 				Type：类型 (C：合同; G:PreGADM的ID, D:部门)
/// Output:	// 
/// Debug:d ##Class(web.DHCPE.GroupDiagnosisPercent).SavePercent(GType, GID, Year, EDID, Percent)
ClassMethod SavePercent(GType, GID, Year, EDID, Percent)
{
	q:(GType="")||(GID="")||(Year="")||(EDID="")||(Percent="") ""
	s ^DHCPEGroupDiagnosisHistoryPercent("YearDiagnosis",GType,GID,+Year,EDID)=Percent
	s ^DHCPEGroupDiagnosisHistoryPercent("DiagnosisYear",GType,GID,EDID,+Year)=Percent
	q 0
}

/// Descript:获取疾病发病率列表
/// Creator:	sunxintao
/// CreateDate:	2022-12-06
/// Input:		
/// 				Year:年份
/// 				Type：类型 (C：合同; G:PreGADM的ID, D:部门)
/// Output:	// 
/// Debug:d ##Class(%ResultSet).RunQuery("web.DHCPE.GroupDiagnosisPercent","QueryDiagnosis","2018","G",50)
Query QueryDiagnosis(Year As %Library.String = "", Type As %Library.String = "", GID As %Library.String = "") As %Query(ROWSPEC = " DiagnosisDesc:%String,DiagnosisType:%String,Percent:%String,Year:%String,Type:%String,EDID:%String")
{
}

ClassMethod QueryDiagnosisExecute(ByRef qHandle As %Binary, Year As %Library.String = "", Type As %Library.String = "", GID As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	i (""=Year)||(Type="")||(GID="") {	
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	//s Type="C"
	s ind=1
 	s EDID=0
	f  s EDID=$o(^DHCPEILLS(EDID)) q:EDID=""  d
	.s RowId=EDID
	.s DiagnosisDesc=$p(^DHCPEILLS(EDID),"^",2)
	.s DiagnosisType=$p(^DHCPEILLS(EDID),"^",15)
	.s father=$p(^DHCPEILLS(EDID),"^",17)
	.b:(EDID=2)
	.q:(father="")
	.s IfCompare=$p($g(^DHCPEILLS(father)),"^",19)
	.//s $p(^DHCPEILLS(EDID),"^",16)="Y"
	.q:(IfCompare'="Y")
	.s:(DiagnosisType="1") DiagnosisType="分类"
	.s:(DiagnosisType="2") DiagnosisType="疾病"
	.s:(DiagnosisType="3") DiagnosisType="项目"
	.b 
	.s Percent=$g(^DHCPEGroupDiagnosisHistoryPercent("YearDiagnosis",Type,GID,+Year,+EDID))
    .d QueryOut
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryOut      
	set Data=$lb(DiagnosisDesc,DiagnosisType,Percent,Year,Type,EDID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryDiagnosisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDiagnosisExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryDiagnosisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDiagnosisExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Descript:获取历年年份
/// Creator:	sunxintao
/// CreateDate:	2022-12-06
/// Input:		
/// 				
/// Output:	// 
/// Debug:d ##Class(%ResultSet).RunQuery("web.DHCPE.GroupDiagnosisPercent","QueryYear")
Query QueryYear() As %Query(ROWSPEC = " Year:%String")
{
}

ClassMethod QueryYearExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	
	s ind=1
 	for i=1:1:30 d
 	.s year=2017+i
    .d QueryOut
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryOut      
	set Data=$lb(year)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryYearFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryYearExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryYearClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryYearExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Descript:获取团体信息
/// Creator:	sunxintao
/// CreateDate:	2022-12-06
/// Input:		
/// 				
/// Output:	// 
/// Debug:d ##Class(%ResultSet).RunQuery("web.DHCPE.GroupDiagnosisPercent","QueryGInfo","C",1)
Query QueryGInfo(GType, ID) As %Query(ROWSPEC = " ID:%String,TypeDesc:%String,Name:%String,GType:%String")
{
}

ClassMethod QueryGInfoExecute(ByRef qHandle As %Binary, GType, ID) As %Status
{
	Set repid=$I(^CacheTemp)
 	if (GType="")||(ID=""){
	 	
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	 }
	s ind=1
 	if (GType="C"){
	 	s TypeDesc="合同"
	 	s Name=$lg(^User.DHCPEContractD(ID),3)
	 }elseif (GType="G"){
	 	s TypeDesc="团体"
	 	s PreGBI=$p(^DHCPEPreGADM(ID),"^",1)
	 	s Name=$p(^DHCPEPreGBI((PreGBI)),"^",2)
	 	
	 }elseif (GType="D"){
	 	s TypeDesc="部门"
	 	s Name=ID
	 }
	 d QueryOut2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryOut2     
	set Data=$lb(ID,TypeDesc,Name,GType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryGInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryGInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryGInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Storage Default
{
<Data name="GroupDiagnosisPercentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.GroupDiagnoC30FD</DataLocation>
<DefaultData>GroupDiagnosisPercentDefaultData</DefaultData>
<IdLocation>^web.DHCPE.GroupDiagnoC30FD</IdLocation>
<IndexLocation>^web.DHCPE.GroupDiagnoC30FI</IndexLocation>
<StreamLocation>^web.DHCPE.GroupDiagnoC30FS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
