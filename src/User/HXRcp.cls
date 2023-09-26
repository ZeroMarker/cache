Class User.HXRcp Extends %RegisteredObject
{

/// 获取N小时之后的时间和日期
/// createdate:2023-9-16
/// creator:黄欣然
/// w class(User.HXRcp).GetHuangXinrancpbDateTime(2)
ClassMethod GetHuangXinrancpbDateTime(n As %String = "")
{
	s dateTime = $h
	s date = +dateTime
	s time = $p(dateTime, "," ,2)
	s addTime = n*60*60 ///将小时换算为秒
	s Time = time +addTime ///计算当前时间之后的时间
	while (Time > (24*60*60))
	{
		s Time = Time - (24*60*60)
	    s date = date +1
	}
	s Time = $zt(Time)
	s Date = $zd(date,3)
	q Date_" "_Time
	q ""
}

}
