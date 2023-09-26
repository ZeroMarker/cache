Import SQLUser

/// description: 配液排班公共类
Class web.DHCSTPIVAS.ScheCommon Extends %RegisteredObject
{

/// description: 节日是否可休假
/// input:		 festDate(logical格式)
/// output:		 Y(可以)
/// w ##class(web.DHCSTPIVAS.ScheCommon).FestCanRest(64649)
ClassMethod FestCanRest(festDate)
{
	q:+festDate=0 "N"
	s festStr=##class(web.DHCSTPIVAS.Common).FestivalDay(festDate)
	s festName=$p(festStr,"^",2)
	s festList=..FestivalList()
	q:$lf(festList,festName)>0 "Y"
	q "N"
}

/// description: 中国法定节假日名称List
/// w ##class(web.DHCSTPIVAS.ScheCommon).FestivalList()
ClassMethod FestivalList()
{
	q $lb("中秋节","春节","劳动节","国庆节","元旦","端午节","清明节","清明")
}

/// description: 是否周末
/// w ##class(web.DHCSTPIVAS.ScheCommon).WeekEnd()
ClassMethod WeekEnd(wDate)
{
	s weekDay=$zd(wDate,10)			
	i (weekDay=6)||(weekDay=0) s weFlag="Y"
	e  s weFlag="N"					
	q weFlag
}

}
