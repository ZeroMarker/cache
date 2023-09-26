Import SQLUser

Class web.DHCVISTopSet Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCVISTopSet).GetUTCTime()
ClassMethod GetUTCTime(date As %String = "", time As %String = "") As %String
{
	i date'="" s date=$ZDH(date,3) 
	e  s date=+$h
	i time'="" s time=$ZTH(time)
	e  s time=$P($h,",",2)
	s start=$ZDH("1970-1-1",3)
	s zoneValue=$ZTH("8:00")
	s utcValue=(date-start)*86400+time-zoneValue
	q utcValue
}

}
