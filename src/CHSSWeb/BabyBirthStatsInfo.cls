Class CHSSWeb.BabyBirthStatsInfo Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: hwb
/// CreatDate：2011-06-09
/// Description:婴儿出生统计
/// Table：chss.ChildBirthCertificate
/// Input: chss.ChildBirthCertificate
/// Output：
/// Return：
/// Others：
ClassMethod ListChart(CommunityCode, BirthStart, BirthEnd) As %String
{
	Set count=0
	Set resultString = "" 
	
	Set json = ##class(Code.JsonObj).%New()
    Set tmp = ""
   	Set AllArcNum=0
   
    Set sqlStr="select count(*) as Num from CHSS.ChildBirthCertificate where 1>0"
    if (BirthStart '= "" || BirthEnd '= "")
	{
		set sqlStr=sqlStr_" and Birth between '"_$ZDateH(BirthStart,3)_"' and '"_$ZDateH(BirthEnd,3)_"'"
	}
	set sqlStr=sqlStr_" and CommunityCode ="_CommunityCode
	Set result = ##class(%Library.ResultSet).%New()
	do result.Prepare(sqlStr)
	do result.Execute()
	while(result.Next())
	{
		set AllArcNum=result.Data("Num")
	}
	do result.Close()
    
    set Sex=0
    set ArcNum=0
    set PerNum=0
	
	set sql = "select sex->CTSEX_Desc As Sex, count(sex->CTSEX_Desc) ArcNum, ROUND(100*count(sex->CTSEX_Desc)/"_AllArcNum_",2) As PerNum from CHSS.ChildBirthCertificate where 1>0"
	if (BirthStart '= "" || BirthEnd '= "")
	{
		set sql=sql_" and Birth between '"_$ZDateH(BirthStart,3)_"' and '"_$ZDateH(BirthEnd,3)_"'"
	}

	set sql=sql_" and CommunityCode ="_CommunityCode
	set sql=sql_" group by sex->CTSEX_Desc"
    Set result = ##class(%Library.ResultSet).%New()
	do result.Prepare(sql)
	do result.Execute()
	
	While(result.Next())
	{
		Set babySex=result.Data("Sex")
		Set ArcNum=result.Data("ArcNum")
		Set PerNum=result.Data("PerNum")

		//判断小数点后有没数字
		if ($p($p(PerNum,".",2),"0",1) = "")
		{
			set PerNum=$p(PerNum,".",1)_"%"
		}
		else
		{
			set PerNum=$p(PerNum,".",1)_"."_$p($p(PerNum,".",2),"00",1)_"%"
		}
		
		Set tmp = babySex_"^"_ArcNum_"^"_PerNum
    
     	Set count=count+1
     	do json.InsertRowData(tmp)
    }
    
    do result.Close()
    
    Set resultString = json.getJsonData("babySex^ArcNum^PerNum",count)
    k json
    Quit resultString
}

/// Creator: hwb
/// CreatDate：2011-06-10
/// Description:婴儿出生走势分析
/// Table：chss.ChildBirthCertificate
/// Input: chss.ChildBirthCertificate
/// Output：
/// Return：
/// Others：
ClassMethod BabyBirthNumList(CommunityCode, searchYear) As %String
{
	Set count=12
	Set resultString = "" 
	
	set January="1月"
	set February="2月"
	set March="3月"
	set April="4月"
	set May="5月"
	set June="6月"
	set July="7月"
	set August="8月"
	set September="9月"
	set October="10月"
	set November="11月"
	set December="12月"
	
	set JanNum=0
	set FebNum=0
	set MarNum=0
	set AprNum=0
	set MayNum=0
	set JunNum=0
	set JulNum=0
	set AugNum=0
	set SepNum=0
	set OctNum=0
	set NovNum=0
	set DecNum=0
	
	Set json = ##class(Code.JsonObj).%New()
    Set tmp = ""
   	Set searchMonth=0
   	Set aa=0
   
    Set sqlStr="select * from CHSS.ChildBirthCertificate where 1>0"
    set sqlStr=sqlStr_" and Birth between '"_$ZDateH(searchYear_"-"_01_"-"_01,3)_"' and '"_$ZDateH(searchYear_"-"_12_"-"_31,3)_"'"
	set sqlStr=sqlStr_" and CommunityCode ="_CommunityCode
	set sqlStr=sqlStr_" order by Birth"
	Set result = ##class(%Library.ResultSet).%New()
	do result.Prepare(sqlStr)
	do result.Execute()
	while(result.Next())
	{
		set searchMonth=$Piece($zd(result.Data("Birth"),3),"-",2)
		if searchMonth="01" do
			.set JanNum=JanNum+1
		if searchMonth="02" do
			.set FebNum=FebNum+1
		if searchMonth="03" do
			.set MarNum=MarNum+1
		if searchMonth="04" do
			.set AprNum=AprNum+1
		if searchMonth="05" do
			.set MayNum=MayNum+1
		if searchMonth="06" do
			.set JunNum=JunNum+1
		if searchMonth="07" do
			.set JulNum=JulNum+1
		if searchMonth="08" do
			.set AugNum=AugNum+1
		if searchMonth="09" do
			.set SepNum=SepNum+1
		if searchMonth="10" do
			.set OctNum=OctNum+1
		if searchMonth="11" do
			.set NovNum=NovNum+1
		if searchMonth="12" do
			.set DecNum=DecNum+1
	}
	do json.InsertRowData(January_"^"_JanNum)
	do json.InsertRowData(February_"^"_FebNum)
	do json.InsertRowData(March_"^"_MarNum)
	do json.InsertRowData(April_"^"_AprNum)
	do json.InsertRowData(May_"^"_MayNum)
	do json.InsertRowData(June_"^"_JunNum)
	do json.InsertRowData(July_"^"_JulNum)
	do json.InsertRowData(August_"^"_AugNum)
	do json.InsertRowData(September_"^"_SepNum)
	do json.InsertRowData(October_"^"_OctNum)
	do json.InsertRowData(November_"^"_NovNum)
	do json.InsertRowData(December_"^"_DecNum)
    
	do result.Close()
    Set resultString = json.getJsonData("searchMonth^babyBirthNum",count)
    k json
    Quit resultString
}

Storage Default
{
<Data name="BabyBirthStatsInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.BabyBirthStatsInfoD</DataLocation>
<DefaultData>BabyBirthStatsInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.BabyBirthStatsInfoD</IdLocation>
<IndexLocation>^CHSSWeb.BabyBirthStatsInfoI</IndexLocation>
<StreamLocation>^CHSSWeb.BabyBirthStatsInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
