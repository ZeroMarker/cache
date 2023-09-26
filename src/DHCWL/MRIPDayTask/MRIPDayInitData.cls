Class DHCWL.MRIPDayTask.MRIPDayInitData Extends %RegisteredObject
{

/// Creator:		陈乙
/// CreatDate:		2016-3-23
/// Description:	初始化任务医嘱对应设置
/// return:			返回1表示初始化成功。0表示失败。
/// w ##class(DHCWL.MRIPDayTask.MRIPDayInitData).InitOrdSetting()
ClassMethod InitOrdSetting() As %String
{
	s ret=1
	k ^||TEMPDHCWL		;可以不用K
	s ^||TEMPDHCWL(1)="BWRC-病危人次"
	s ^||TEMPDHCWL(2)="BZRC-病重人次"
	s ^||TEMPDHCWL(3)="HLRS1-一级护理人数"
	s ^||TEMPDHCWL(4)="HLRS2-二级护理人数"
	s ^||TEMPDHCWL(5)="HLRS3-三级护理人数"
	s ^||TEMPDHCWL(6)="TJHLRS-特级护理人数"
	s ^||TEMPDHCWL(7)="DQJ-大抢救"
	s ^||TEMPDHCWL(8)="ZQJ-中抢救"
	s ^||TEMPDHCWL(9)="XQJ-小抢救"
	s id=""
	f  s id=$o(^||TEMPDHCWL(id)) q:id=""  d
	.s code=$p($g(^||TEMPDHCWL(id)),"-",1)
	.s desc=$p($g(^||TEMPDHCWL(id)),"-",2)
	.i $d(^DHCWL.MRIPDayTask.OrdItmI("OrdItmCodeIndex",code)) d
	..w !,desc_":该统计项code已存在，不可重复插入！"
	..s ret=0
	.e  d
	..&sql(insert into DHCWL_MRIPDayTask.OrdItm (OrdItm_Code,OrdItm_Desc) values (:code,:desc))
	..i SQLCODE'=0 d
	...W !,desc_"：初始化失败！"
	...s ret=0
	
	q ret
}

}
