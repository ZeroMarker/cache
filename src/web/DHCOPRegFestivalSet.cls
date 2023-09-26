Include webimport

IncludeGenerator webimport

Class web.DHCOPRegFestivalSet Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod Delete(ID As %Library.String = "")
{
   ;假日设置不允许删除本日以前的设置记录,因为怕影响统计的数据  guobaoping 20110301
	&sql(select FESTDate into :date from DHC_OPRegFestivalSet where ID=:ID)
	q:date<+$h "RefuseDelete"
	&sql(delete from DHC_OPRegFestivalSet where ID=:ID)	
 q SQLCODE
}

ClassMethod FindFestivalToday()
{
 s Sysdate=..%SysDate()
 s Retcode=""
 &sql(select '今天是'||to_char(FESTDate,'YYYY-mm-DD')||',由于是节假日按'||DOW_Name||'排班表挂号!' 
 into :Retcode
 from DHC_OPRegFestivalSet,ct_dayofweek
 where FESTWeek=DOW_Day and FESTDate=:Sysdate)
 q Retcode
}

ClassMethod QueryFestivalDayList() As %String
{
 set Str=""
 Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
	Do result.Prepare("select %ID,FESTDate from DHC_OPRegFestivalSet order by %ID desc ")
	Do result.Execute()
	do result.Next()
	Set Str= result.Data("ID")_$C(1)_..%ZD(result.Data("FESTDate")) //$zd(result.Data("FESTDate"),3)
	while (result.Next())
	{
	 Set Str=Str_"^"_ result.Data("ID")_$C(1)_..%ZD(result.Data("FESTDate")) //$zd(result.Data("FESTDate"),3)
	}
	quit Str
}

ClassMethod Save(FESTDate As %Library.String = "", FESTWeek As %Library.String = "", FESTCreateUser As %Library.String = "", Comm As %Library.String = "")
{
	s CreateDate=..%SysDate()
	//i $l(FESTDate,"/")=3 s FESTDate=$zdh(FESTDate,4)
	//i $l(FESTDate,"-")=3 s FESTDate=$zdh(FESTDate,3)
	i FESTDate'="" s FESTDate=..%ZDH(FESTDate)
	s Num=0
	&sql(select count(ID) into :Num from DHC_OPRegFestivalSet where FESTDate=:FESTDate)
	if Num'=0 q "Dulpli"
	&sql(insert into DHC_OPRegFestivalSet(FESTDate,FESTWeek,FESTCreateUser,FESTCreateDate,FESTComm)
	values(:FESTDate,:FESTWeek,:FESTCreateUser,:CreateDate,:Comm))
	
 q SQLCODE
}

ClassMethod Save2(FESTDate As %Library.String = "", FESTWeek As %Library.String = "", FESTCreateUser As %Library.String = "", Comm As %Library.String = "")
{
	Q ..Save(FESTDate,FESTWeek,FESTCreateUser,Comm)
}

// 周末是否算节假日

ClassMethod SaveWeekEndFlag(WeekEndFlag As %Library.String = "")
{
 s ^DHCOPRegFestivalSet("WeekEndFlag")=WeekEndFlag	
 q 0
}

// 周末是否算节假日

ClassMethod GetWeekEndFlag()
{
 Q $G(^DHCOPRegFestivalSet("WeekEndFlag"))
}

// 判断是否节假日

ClassMethod CheckDayIsFestival(ImportDate As %Library.String = "")
{
  ;W ##class(web.DHCOPRegFestivalSet).CheckDayIsFestival()
   ;s ImportDate=$zdh(ImportDate,4)
   Q:ImportDate="" "0"
   s ImportDateStr="!"_ImportDate_"!"
   s HolidaysStr=##class(web.DHCDocOrderCommon).GetHolidaysStr()
   Q:(HolidaysStr'="")&&(HolidaysStr[ImportDateStr) "1"
   s WeekEndFlag=..GetWeekEndFlag()
   Q:(WeekEndFlag="1")&&(($ZD(ImportDate,10)=0)||($ZD(ImportDate,10)=6)) "1"
   Q "0"
}

Query QueryDayofWeek() As %SQLQuery(CONTAINID = 1, ROWSPEC = "DOW_Day:%String,DOW_Name:%String")
{
	select DOW_Day,DOW_Name from ct_dayofweek
}

Query QueryRegFestival() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,FESTDate:%String,FESTWeek:%String,FESTCreateDate:%String,FESTCreateUser:%String,FESTComm:%String")
{
 select ID,to_char(FESTDate,'YYYY-mm-DD'),DOW_Name,to_char(FESTCreateDate,'YYYY-mm-DD'),FESTCreateUser,FESTComm 
 from DHC_OPRegFestivalSet,ct_dayofweek
 where FESTWeek=DOW_Day
 order by ID
}

}
