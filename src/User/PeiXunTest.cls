/// w ##class(User.PeiXunTest).GetYangHongRuiCPBDateTime("2")
Class User.PeiXunTest Extends %RegisteredObject
{

ClassMethod GetYangHongRuiCPBDateTime(n)
{
	s Date = $p($h,",",1)    ///获取日期
	s Time = $p($h,",",2)
	s Time = $zt(Time)
	s Hour = $p(Time,":",1)
	s Min = $p(Time,":",2)
	s Sec = $p(Time,":",3)
	if (Hour + n < 24)
	{
		s Date = $zd(Date,3)
		s Time = (Hour + n)_":"_Min_":"_Sec
	}
	else
	{
		s Day = (Hour + n)\24
		s Date = $zd(Date + Day,3)
		s Hour = (Hour + n)#24
		s Time = Hour_":"_Min_":"_Sec
	}
	q Date_" "_Time
}

/// Others: w ##class(User.PeiXunTest).GetsingleDataY(1)
ClassMethod GetsingleDataY(PAADMRowId As %String) As %String
{
	q:PAADMRowId="" "PAADMRowId为空"
	s PatName="",  BEDNO=""
	&SQL(
		SELECT Pat_Name, BED_NO INTO :PatName,:BEDNO FROM TempB_YangHongRuiB 
		WHERE PAADM_RowId=:PAADMRowId
		)
	if (SQLCODE=0)
	{
		s result=PatName_" "_BEDNO
	}
	else
	{
		s result="没查到数据"
	}
	q result
}

/// Others: d ##class(User.PeiXunTest).GetsingleDataN(3)
ClassMethod GetsingleDataN(PAADMRowId As %String) As %String
{
	q:PAADMRowId="" "CrsRowId为空"
	k PLIST
	s PatName="", BEDNO=""
	&SQL(
		SELECT Pat_Name ,BED_NO  INTO :PLIST() FROM TempB_YangHongRuiB
		WHERE PAADM_RowId=:PAADMRowId
	)
	if (SQLCODE=0)
	{
		s count=$o(PLIST(""),-1)
		for i=1:1:count
		{
			//w PLIST(i)_" "
			w $g(PLIST(i)) ,!
		}
	}
	else
	{
		s result="没查到数据"
	}
	//q result
}

}
