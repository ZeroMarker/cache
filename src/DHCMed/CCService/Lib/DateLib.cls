/// 日期操作类
/// 创建者：李阳
/// 创建日期：2010-10-08
Class DHCMed.CCService.Lib.DateLib Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 日期比较
/// 参数:
/// Date1:第一个日期,格式:YYYY-MM-DD，或者DD/MM/YYYY，或者Cache内部格式
/// Date2:第二个日期,格式:YYYY-MM-DD，或者DD/MM/YYYY，或者Cache内部格式
/// 返回值：两个日期相差的天数（Date1-Date2）
ClassMethod Compare(Date1, Date2)
{
		n (Date1,Date2)
		s ret=0
		s:Date1["-" Date1=$zdh(Date1,3)
		s:Date1["/" Date1=$zdh(Date1,4)
		s:Date2["-" Date2=$zdh(Date2,3)
		s:Date2["/" Date2=$zdh(Date2,4)		
		s Date1=+Date1
		s Date2=+Date2
		q Date1-Date2
}

/// 获取日期的年份
/// 参数：日期
/// 返回值：日期的年份部分
ClassMethod GetYear(Date)
{
		n (Date)
		s:Date["-" Date=$zdh(Date,3)
		s:Date["/" Date=$zdh(Date,4)
		s Date=+Date
		s Date=$zd(Date,3)
		q $p(Date,"-",1)
}

/// 获取日期的月份
/// 参数：日期
/// 返回值：日期的月份部分
ClassMethod GetMonth(Date)
{
		n (Date)
		s:Date["-" Date=$zdh(Date,3)
		s:Date["/" Date=$zdh(Date,4)
		s Date=+Date
		s Date=$zd(Date,3)
		q $p(Date,"-",2)
}

/// 获取日期的天数部分
/// 参数：日期
/// 返回值：日期的天数部分
ClassMethod GetDay(Date)
{
		n (Date)
		s:Date["-" Date=$zdh(Date,3)
		s:Date["/" Date=$zdh(Date,4)
		s Date=+Date
		s Date=$zd(Date,3)
		q $p(Date,"-",3)
}

}
