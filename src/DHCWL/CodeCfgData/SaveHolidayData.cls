Import SQLUser

Class DHCWL.CodeCfgData.SaveHolidayData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(DHCWL.CodeCfgData.SaveHolidayData).Addholiday(.dim)
ClassMethod Addholiday(ByRef dim) As %String
{
	n (dim,%session)
	//s dim("datePara")="2012-01-01*2012-01-02"
	//s dim("holidayFlag")=2
	s sqlPara=0
	s datePara=$g(dim("datePara")) 
	s holidayFlag=$g(dim("holidayFlag"))
	s update=+$h
	f count=1:1:$l(datePara,"*") d
	.;s day=$zdh($p(datePara,"*",count),3)
	.s day=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical($p(datePara,"*",count))
	.q:$d(^DHCWL.CodeCfg.HolidayI("Holiday",day))
	.s ret=..SaveData()
	.s sqlPara=$g(sqlPara)+ret
	s result="保存失败！"
	i sqlPara=0 s result="ok"
	q result
}

ClassMethod SaveData() As %String
{
 &sql(INSERT INTO DHCWL_CodeCfg.DHCWLCodeCfgHoliday(Holiday_Name,Holiday_Type,Holiday_Update) VALUES(:day,:holidayFlag,:update))
 s id=+$g(%ROWID)
 s typeObj=##class(DHCWL.CodeCfg.Holiday).%OpenId(id)
 s rJson=typeObj.GetDataStr()
 i SQLCODE=0  d
 .s ret=typeObj.InsLog("A",rJson)
 q SQLCODE
}

/// w ##class(DHCWL.CodeCfgData.SaveHolidayData).DelItem(.dim)
ClassMethod DelItem(ByRef dim) As %String
{
	n (dim,%session)
	s itemPara=$g(dim("selectItemPara"))
	//s itemPara="13*14"
	f count=1:1:$l(itemPara,"*") d
	.s Id=$p(itemPara,"*",count)
	.q:'$d(^DHCWL.CodeCfg.HolidayD(Id))
    .s typeObj=##class(DHCWL.CodeCfg.Holiday).%OpenId(Id)
    .s rJson=typeObj.GetDataStr()
    .&sql(delete from  DHCWL_CodeCfg.DHCWLCodeCfgHoliday where ID=:Id)
	.s sqlPara=$g(sqlPara)+SQLCODE
	s result="删除失败！"
	i sqlPara=0 d
	.s result="ok"
	.s ret=typeObj.InsLog("D",rJson)
	q result
}

/// w ##class(DHCWL.CodeCfgData.SaveData).UpdateCodeGrp(.dim)
ClassMethod UpdateAP(ByRef dim) As %String
{
	n (dim,%session)
	//s dim("timeAP")="上午"
	//s dim("ID")=18
	s id=$g(dim("ID"))
	s timeAPFlag=$g(dim("timeAP"))
	//i timeAP="上午" s timeAPFlag="A"
	//i timeAP="下午" s timeAPFlag="P"
	//i timeAP="全天" s timeAPFlag="AP" 
	s typeObj=##class(DHCWL.CodeCfg.Holiday).%OpenId(id)
	s rJsonOld=typeObj.GetDataStr()
	s typeObj=""
	&sql(update DHCWL_CodeCfg.DHCWLCodeCfgHoliday set Holiday_AmOrPm=:timeAPFlag where ID=:id)
	s typeObj=##class(DHCWL.CodeCfg.Holiday).%OpenId(id)
	s rJson=typeObj.GetDataStr()
	s result="更新失败！"
	i SQLCODE=0 d
	.s result="ok"
	.s ret=typeObj.InsLog("U",rJson,rJsonOld)
	q result
}

}
