Import sqluser

Class web.DHCAdvHoliday Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 保存[节假日数据维护] 
/// Creator:     yangyongtao
/// CreateDate:  2018-01-16
/// Table:	     DHC_AdvHoliday 
/// Input:  	
/// return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCAdvHoliday).SaveHoliday("2^2018-01-16^节假日")
ClassMethod SaveHoliday(DataList As %String) As %String
{
	N (DataList)
	S len=$L(DataList,"||")
	F i=1:1:len D
	.S TmpStr=$p(DataList,"||",i)
	.s Err=..CheckRepeatHoliday(TmpStr)   /// 重复性判断
	.q:Err'=0
	.I $p(TmpStr,"^",1)'="" D
	..S Err=..UpdHoliday(TmpStr)
	.E  D
	..S Err=..InsHoliday(TmpStr)
	Q Err
}

/// Description: 增加[节假日数据维护] 
/// Creator:     yangyongtao
/// CreateDate:  2018-01-16
/// Table:	     DHC_AdvHoliday 
/// Input:  	 DataList:以字符"^"分割,格式为: id^日期^标志
/// return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCAdvHoliday).InsHoliday("")
ClassMethod InsHoliday(DataList As %String) As %String
{
	N (DataList)
	S ADVHoDate=$p(DataList,"^",2)
	S:ADVHoDate'="" ADVHoDate=$zdh(ADVHoDate,3)
	S ADVHoFlagDay=$p(DataList,"^",3)
 	&SQL(INSERT INTO DHC_AdvHoliday(ADVHol_Date,ADVHol_FlagDay) VALUES(:ADVHoDate,:ADVHoFlagDay))
 	Q SQLCODE
}

/// Description: 修改[节假日数据维护] 
/// Creator:     yangyongtao
/// CreateDate:  2018-01-16
/// Table:	     DHC_AdvHoliday 
/// Input:  	 DataList: 以字符"^"分割,格式为: id^日期^标志
/// return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCAdvHoliday).UpdHoliday("2^2018-01-16^节假日")
ClassMethod UpdHoliday(DataList As %String) As %String
{
	N (DataList)
	S ADVHoID=$p(DataList,"^",1)
	S ADVHoDate=$p(DataList,"^",2)
	S:ADVHoDate'="" ADVHoDate=$zdh(ADVHoDate,3)
	S ADVHoFlagDay=$p(DataList,"^",3)
	&SQL(Update DHC_AdvHoliday Set ADVHol_Date=:ADVHoDate,ADVHol_FlagDay=:ADVHoFlagDay WHERE ADVHol_RowID=:ADVHoID)
 	Q SQLCODE
}

/// Description: 删除[节假日数据维护] 
/// Creator:     yangyongtao
/// CreateDate:  2018-01-16
/// Table:	     DHC_AdvHoliday 
/// Input:    	 数据id
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCAdvHoliday).DelAdvDeal("1")
ClassMethod DelHoliday(ADVHoID As %String) As %String
{
	N (ADVHoID)
	&SQL(Delete From DHC_AdvHoliday Where ADVHol_RowID=:ADVHoID)
	Q SQLCODE
}

/// Descript:检查日期是否重复
ClassMethod CheckRepeatHoliday(TmpStr As %String) As %String
{
	N (TmpStr)
	s ADVHoID=$p(TmpStr,"^",1)   		///ID
	s ADVHoDate=$p(TmpStr,"^",2)   	///日期
	S:ADVHoDate'="" ADVHoDate=$zdh(ADVHoDate,3)
	/// 新记录
	q:(ADVHoID="")&($d(^DHCADVHOLIDAY(0,"Holiday",ADVHoDate))) "-1"
	q:ADVHoID="" 0
	
	/// 修改记录
	s Date=$p($g(^DHCADVHOLIDAY(ADVHoID)),"^",1)    //代码
	q:(ADVHoDate'=Date)&($d(^DHCADVHOLIDAY(0,"Holiday",ADVHoDate))) "-2"
	q 0
}

/// Description: 查询[节假日数据维护] 
/// Creator:     yangyongtao
/// CreateDate:  2018-01-16
/// Table:	     DHC_AdvHoliday 
/// Input:  	 params:类型描述
/// Others:		 w ##class(web.DHCAdvHoliday).QueryHoliday("12","1","2018-01-01^2018-01-22")
ClassMethod QueryHoliday(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	S End = page*rows
	S Start = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
    S StDate=$P(params,"^",1)
    S EndDate=$P(params,"^",2)
	S h=0,count=0
	S:StDate'="" StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)
	S:EndDate'="" EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate)
	q:StDate="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	f date=StDate:1:EndDate d
	.S ID="0"
	.f  s ID=$o(^DHCADVHOLIDAY(0,"Holiday",date,ID)) q:ID=""  d
	..S Date=$p(^DHCADVHOLIDAY(ID),"^",1) //日期
	..S:Date'="" Date=$zd(Date,3)
	..S Flag=$p(^DHCADVHOLIDAY(ID),"^",2) //标识
	..S h=h+1
	..S TempStr=ID_"^"_Date_"^"_Flag
	..S ^TMP("DHCADV","web.DHCAdvHoliday","QueryHoliday",pid,h)=TempStr
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^Date^Flag"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCAdvHoliday","QueryHoliday",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCAdvHoliday","QueryHoliday",pid,index))
	.S count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

ClassMethod killTmpGlobal(pid) As %String
{
	K ^TMP("DHCADV","web.DHCAdvHoliday","QueryHoliday",pid)
}

}
