/// Creator: 李明忠
/// CreatDate: 2011-08-31
/// Description: 奖金核算系统收入接口数据导入
Class dhc.bonus.udata.uInterIncome Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：李明忠
/// CreatDate：2011-08-31
/// Description: 获取住院收入
/// Table：
/// Input：startDate:开始日期;endDate:结束日期
/// Output：
/// Return：有效住院收入接口数据导入成功标示
/// Others：w ##class(dhc.bonus.udata.uInterIncome).InIncome("2011-01-01","2011-01-31")
ClassMethod InIncome(startDate, endDate) As %String
{
	n (startDate,endDate)
	
	d SGGetInData^SGGetFeeData(startDate,endDate)
	
	i $D(^TEMPDHCWL($j,"JJExport")) d
	.s locDr = ""
	.f  s locDr=$O(^TEMPDHCWL($j,"JJExport",locDr)) q:locDr=""  d
	..s itemDr=0
	..f  s itemDr=$O(^TEMPDHCWL($j,"JJExport",locDr,itemDr)) q:itemDr=""  d
	...s value=^TEMPDHCWL($j,"JJExport",locDr,itemDr)
	...s ItemDr="In_"_itemDr
	...i $D(^DHCCBOUNSINTERINCOME("dhc","bouns","inter","inIncome",$j,locDr,ItemDr)) d
	....s ^DHCCBOUNSINTERINCOME("dhc","bouns","inter","inIncome",$j,locDr,ItemDr)=^DHCCBOUNSINTERINCOME("dhc","bouns","inter","inIncome",$j,locDr,ItemDr)+value
	...e  d
	....s ^DHCCBOUNSINTERINCOME("dhc","bouns","inter","inIncome",$j,locDr,ItemDr)=value
	
	//整理数据
	s locName="",itemName="",count=0
	i $D(^DHCCBOUNSINTERINCOME("dhc","bouns","inter","inIncome",$j)) d
	.s locDr=0
	.f  s locDr=$O(^DHCCBOUNSINTERINCOME("dhc","bouns","inter","inIncome",$j,locDr)) q:locDr=""  d
	..s itemDr=0
	..f  s itemDr=$O(^DHCCBOUNSINTERINCOME("dhc","bouns","inter","inIncome",$j,locDr,itemDr)) q:itemDr=""  d
	...s value=^DHCCBOUNSINTERINCOME("dhc","bouns","inter","inIncome",$j,locDr,itemDr)
	...s count=count+1
	...s ^DHCCJXBOUNSINTERININCOME(count)=locDr_"^"_locName_"^"_itemDr_"^"_itemName_"^"_value
	
	k ^TEMPDHCWL($j,"JJExport")
	k ^DHCCBOUNSINTERINCOME("dhc","bouns","inter","inIncome",$j)
}

/// Creator：李明忠
/// CreatDate：2011-08-31
/// Description: 获取门诊收入
/// Table：
/// Input：startDate:开始日期;endDate:结束日期
/// Output：
/// Return：有效门诊收入接口数据导入成功标示
/// Others：w ##class(dhc.bonus.udata.uInterIncome).OutIncome("2011-01-01","2011-01-31")
ClassMethod OutIncome(startDate, endDate) As %String
{
	n (startDate,endDate)
	
	d SGGetOutData^SGGetFeeData(startDate,endDate)
	
	i $D(^TEMPDHCWL($j,"JJExport")) d
	.s locDr = ""
	.f  s locDr=$O(^TEMPDHCWL($j,"JJExport",locDr)) q:locDr=""  d
	..s itemDr=0
	..f  s itemDr=$O(^TEMPDHCWL($j,"JJExport",locDr,itemDr)) q:itemDr=""  d
	...s value=^TEMPDHCWL($j,"JJExport",locDr,itemDr)
	...s ItemDr="Out_"_itemDr
	...i $D(^DHCCBOUNSINTERINCOME("dhc","bouns","inter","outIncome",$j,locDr,ItemDr)) d
	....s ^DHCCBOUNSINTERINCOME("dhc","bouns","inter","outIncome",$j,locDr,ItemDr)=^DHCCBOUNSINTERINCOME("dhc","bouns","inter","outIncome",$j,locDr,ItemDr)+value
	...e  d
	....s ^DHCCBOUNSINTERINCOME("dhc","bouns","inter","outIncome",$j,locDr,ItemDr)=value
	
	//整理数据
	s locName="",itemName="",count=0
	i $D(^DHCCBOUNSINTERINCOME("dhc","bouns","inter","outIncome",$j)) d
	.s locDr=0
	.f  s locDr=$O(^DHCCBOUNSINTERINCOME("dhc","bouns","inter","outIncome",$j,locDr)) q:locDr=""  d
	..s itemDr=0
	..f  s itemDr=$O(^DHCCBOUNSINTERINCOME("dhc","bouns","inter","outIncome",$j,locDr,itemDr)) q:itemDr=""  d
	...s value=^DHCCBOUNSINTERINCOME("dhc","bouns","inter","outIncome",$j,locDr,itemDr)
	...s count=count+1
	...s ^DHCCJXBOUNSINTEROUTINCOME(count)=locDr_"^"_locName_"^"_itemDr_"^"_itemName_"^"_value
	
	k ^TEMPDHCWL($j,"JJExport")
	k ^DHCCBOUNSINTERINCOME("dhc","bouns","inter","outIncome",$j)
}

/// Creator：李明忠
/// CreatDate：2011-09-20
/// Description: 获取挂号工作量
/// Table：
/// Input：startDate:开始日期;endDate:结束日期
/// Output：
/// Return：有效挂号工作量接口数据导入成功标示
/// Others：w ##class(dhc.bonus.udata.uInterIncome).Register("2011-05-01","2011-05-31")
ClassMethod Register(startDate, endDate) As %String
{
	n (startDate,endDate)
	
	d SGGetRegData^SGGetFeeData(startDate,endDate)
	;接口数据规则
	;1: ^TEMPDHCWL(1417308,"gh","JJExport","Out_105||1","正副主任") = 1123 
	;2: ^TEMPDHCWL(1417308,"gh","JJExport","Out_105||1","急诊") = 23 
	;3: ^TEMPDHCWL(1417308,"gh","JJExport","Out_105||1","普通门诊") = 2453 
	;3: ^TEMPDHCWL(1417308,"gh","JJExport","Out_105||1","简易门诊") = 2453 
	;注：1、正副主任、急诊、普通门诊、简易门诊分别拼写代码：zfzr、jz、ptmz、jymz
	;注：2、在Global中“gh”结点表示挂号
	
	i $D(^TEMPDHCWL($j,"gh","JJExport")) d
	.s locDr = ""
	.f  s locDr=$O(^TEMPDHCWL($j,"gh","JJExport",locDr)) q:locDr=""  d
	..s itemName=""
	..f  s itemName=$O(^TEMPDHCWL($j,"gh","JJExport",locDr,itemName)) q:itemName=""  d
	...i itemName="正副主任" s itemDr="zfzr"
	...i itemName="急诊" s itemDr="jz"
	...i itemName="普通门诊" s itemDr="ptmz"
	...i itemName="简易门诊" s itemDr="jymz"
	...s value=^TEMPDHCWL($j,"gh","JJExport",locDr,itemName)
	...i $D(^DHCCBOUNSINTERINCOME("dhc","bouns","inter","register",$j,locDr,itemDr)) d
	....s ^DHCCBOUNSINTERINCOME("dhc","bouns","inter","register",$j,locDr,itemDr)=^DHCCBOUNSINTERINCOME("dhc","bouns","inter","register",$j,locDr,itemDr)+value
	...e  d
	....s ^DHCCBOUNSINTERINCOME("dhc","bouns","inter","register",$j,locDr,itemDr)=value
	
	//整理数据
	s locName="",itemName="",count=0
	i $D(^DHCCBOUNSINTERINCOME("dhc","bouns","inter","register",$j)) d
	.s locDr=0
	.f  s locDr=$O(^DHCCBOUNSINTERINCOME("dhc","bouns","inter","register",$j,locDr)) q:locDr=""  d
	..s itemDr=""
	..f  s itemDr=$O(^DHCCBOUNSINTERINCOME("dhc","bouns","inter","register",$j,locDr,itemDr)) q:itemDr=""  d
	...i itemDr="zfzr" s itemName="正副主任"
	...i itemDr="jz" s itemName="急诊"
	...i itemDr="ptmz" s itemName="普通门诊"
	...i itemDr="jymz" s itemName="简易门诊"
	...s value=^DHCCBOUNSINTERINCOME("dhc","bouns","inter","register",$j,locDr,itemDr)
	...s count=count+1
	...s ^DHCCJXBOUNSINTERREGISTER(count)=locDr_"^"_locName_"^"_itemDr_"^"_itemName_"^"_value
	
	k ^TEMPDHCWL($j,"gh","JJExport")
	k ^DHCCBOUNSINTERINCOME("dhc","bouns","inter","register",$j)
}

Storage Default
{
<StreamLocation>^dhc.bonus.udata.uInterIncomeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
