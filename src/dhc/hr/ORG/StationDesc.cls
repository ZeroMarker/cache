Class dhc.hr.ORG.StationDesc Extends %Persistent
{

/// Creator: chinaway
/// CreatDate: 2016-08-30
/// Description: 获取岗位说明书所需资格信息
/// Table：  StationQualify
/// Input: 
/// Return: 返回json串
/// Others: w ##class(dhc.hr.ORG.StationDesc).GetQualify("1096")
ClassMethod GetQualify(stationID As %String, Output reValue As %Text) As %String [ SqlProc ]
{
	q:stationID=""
	s reValue=""
	s count=0,rowid="",rowid1="",rowid2=""
	s sColumn="ID^QualifyType^QualifyTypeValue^QualifyTypeCode"
	s json=##class(dhc.hr.comm.JsonObj).%New()
	
	f  s rowid=$O(^HISHR.StationQualifyI("StaCodeIdx"," "_stationID,rowid)) q:rowid=""  d
	.s temp=""
	.s qcode=$LIST(^HISHR.StationQualifyD(rowid),3)
	.s qvalue=$LIST(^HISHR.StationQualifyD(rowid),4)
	.s rowid1=$O(^HISHR.FieldInfoInfoI("MasterIdx"," ORG"," STATIONDEFINECONFIG"," "_$ZCVT(qcode,"U"),rowid1))
	.i rowid1'="" d
	..s qcodename=$LIST(^HISHR.FieldInfoInfoD(rowid1),6)
	..s dtype=$LIST(^HISHR.FieldInfoInfoD(rowid1),14)
	..i dtype="DropDownList" d
	...s dict=$LIST(^HISHR.FieldInfoInfoD(rowid1),17)
	...s title=$LIST(^HISHR.FieldInfoInfoD(rowid1),18)
	...i (dict'="" && title'="" && dict'=$c(0) && title'=$c(0)) d
	....s qvalue=..GetNameByCode(dict,title,qvalue)
	....b
	
	.s temp=rowid_"^"_qcodename_"^"_qvalue_"^"_qcode		
	.s count=count+1			
	.d json.InsertRowData(temp)	
	
	i count=0 d
	.f  s rowid2=$O(^HISHR.FieldInfoInfoI("TableVisible"," STATIONDEFINECONFIG"," 1",rowid2)) q:rowid2=""  d
	
	..s qcode=$LIST(^HISHR.FieldInfoInfoD(rowid2),5)
	..s qcodename=$LIST(^HISHR.FieldInfoInfoD(rowid2),6)
	..s temp="^"_qcodename_"^^"_qcode		
	..s count=count+1			
	..d json.InsertRowData(temp)	
	
	s reValue=json.getJsonData(sColumn,count) 

	q reValue
}

/// Creator: chinaway
/// CreatDate: 2016-09-5
/// Description: 获取编码表中文信息
/// Table：  
/// Input: tabcode-编码表名
/// Return: 
/// Others: w ##class(dhc.hr.ORG.StationDesc).GetNameByCode("SexTypeInfo","SexType^CONTEXT","01")
ClassMethod GetNameByCode(tabcode, fields, code) As %String
{
	s rev=""

	s bmcode=$p(fields,"^",1)
	s bmtext=$p(fields,"^",2)
	s sql="SELECT "_bmtext_" AS text FROM HISHR."_tabcode_" WHERE "_bmcode_"='"_code_"'"
	i $l(fields,"^")=3 d
	.s sql=sql_" AND "_$p(fields,"^",3)
	s result=##Class(%Library.ResultSet).%New()
	d result.Prepare(sql)
	d result.Execute()
	while(result.Next())
	{
		s rev=result.Data("text")
	}
	d result.Close()			
	
    q rev
}

/// Creator: chinaway
/// CreatDate: 2016-08-30
/// Description: 获取岗位说明书工作职责信息
/// Table：  StationDutyInfo
/// Input: 
/// Return: 返回json串
/// Others: w ##class(dhc.hr.ORG.StationDesc).GetDuty("1096")
ClassMethod GetDuty(stationID As %String, Output reValue As %Text) As %Text [ SqlProc ]
{
	q:stationID=""
	s returnValue=""
	s count=0,rowid="",rowid1="",rowid2=""
	s sColumn="ID^WorkSummary^WorkDetails^WorkProportion"
	s json=##class(dhc.hr.comm.JsonObj).%New()
	
	f  s rowid=$O(^HISHR.StationDutyI("StaCodeIdx"," "_stationID,rowid)) q:rowid=""  d
	.s temp=""
	.s summary=$LIST(^HISHR.StationDutyD(rowid),3)
	.s details=$LIST(^HISHR.StationDutyD(rowid),4)
	.s proportion=$LIST(^HISHR.StationDutyD(rowid),5)
	
	.s temp=rowid_"^"_summary_"^"_details_"^"_proportion		
	.s count=count+1			
	.d json.InsertRowData(temp)	

	
	s reValue=json.getJsonData(sColumn,count) 

	q reValue
}

Storage Default
{
<Data name="StationDescDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.hr.ORG.StationDescD</DataLocation>
<DefaultData>StationDescDefaultData</DefaultData>
<IdLocation>^dhc.hr.ORG.StationDescD</IdLocation>
<IndexLocation>^dhc.hr.ORG.StationDescI</IndexLocation>
<StreamLocation>^dhc.hr.ORG.StationDescS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
