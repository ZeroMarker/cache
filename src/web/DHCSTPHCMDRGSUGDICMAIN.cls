Import SQLUser

/// Creator: bianshuai
/// CreateDate: 2014-11-11
/// Descript: 用药建议字典表维护类
Class web.DHCSTPHCMDRGSUGDICMAIN Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:保存[用药建议字典]
/// w ##class(web.DHCSTPHCMDRGSUGDICMAIN).SaveUpdAdrEvent("^SDFASDF^ASD")
ClassMethod SaveDrgSugDic(DataList As %String) As %String
{
	n (DataList)
	s len=$L(DataList,"||")
	f i=1:1:len d
	.s TmpStr=$p(DataList,"||",i)
	.i $p(TmpStr,"^",1)'="" d
	..s ret=..UpdDrgSugDic(TmpStr)
	.e  d
	..s ret=..InsDrgSugDic(TmpStr)
	q 0
}

/// Descript:更新[用药建议字典]
/// w ##class(web.DHCSTPHCMDRGSUGDICMAIN).UpdDrgSugDic("^SDFASDF^ASD")
ClassMethod UpdDrgSugDic(DataList As %String) As %String
{
	N (DataList)
	S drgSugDicID=$p(DataList,"^",1)
	S drgSugDicCode=$p(DataList,"^",2)
	S drgSugDicDesc=$p(DataList,"^",3)
	&SQL(Update DHC_PHDrgSugDic Set DSD_Code=:drgSugDicCode,DSD_Desc=:drgSugDicDesc WHERE DSD_RowID=:drgSugDicID)
 	Q SQLCODE
}

/// Descript:增加[用药建议字典]
/// w ##class(web.DHCSTPHCMDRGSUGDICMAIN).InsDrgSugDic("^SDFASDF^ASD")
ClassMethod InsDrgSugDic(DataList As %String) As %String
{
	N (DataList)
	S drgSugDicCode=$p(DataList,"^",2)
	S drgSugDicDesc=$p(DataList,"^",3)
 	&SQL(INSERT INTO DHC_PHDrgSugDic(DSD_Code,DSD_Desc) VALUES(:drgSugDicCode,:drgSugDicDesc))
 	Q SQLCODE
}

/// Descript:删除[用药建议字典]
/// w ##class(web.DHCSTPHCMDRGSUGDICMAIN).DelDrgSugDic("1")
ClassMethod DelDrgSugDic(drgSugDicID As %String) As %String
{
	N (drgSugDicID)
	&SQL(Delete From DHC_PHDrgSugDic Where DSD_RowID=:drgSugDicID)
	Q SQLCODE
}

/// Descript:查询[用药建议字典]
/// w ##class(web.DHCSTPHCMDRGSUGDICMAIN).QueryDrgSugDic("12","1","")
ClassMethod QueryDrgSugDic(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	s End = page*rows
	s Start=(page-1)*rows+1
    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s drgSugDicCode=$p(params,"^",1)
    s drgSugDicDesc=$p(params,"^",2)
	s h=0,count=0
	s ID=""
	f  s ID=$o(^DHCPHDSD(ID)) q:ID=""  d
	.s Code=$p(^DHCPHDSD(ID),"^",1) //代码
	.s Desc=$p(^DHCPHDSD(ID),"^",2) //描述
	.q:(drgSugDicCode'="")&(Code'[drgSugDicCode)
	.q:(drgSugDicDesc'="")&(Desc'[drgSugDicDesc)
	.s h=h+1
	.s TempStr=ID_"^"_Code_"^"_Desc
	.s ^TMP("DHCST","web.DHCSTPHCMDRGSUGDICMAIN","QueryDrgSugDic",pid,h)=TempStr
	
	q:h=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^Code^Desc"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMDRGSUGDICMAIN","QueryDrgSugDic",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCSTPHCMDRGSUGDICMAIN","QueryDrgSugDic",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:查询[用药建议字典]
/// w ##class(web.DHCSTPHCMDRGSUGDICMAIN).QueryUserMedAdvDic("")
ClassMethod QueryUserMedAdvDic(params As %String) As %String
{
	n (params)
    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
	s h=0,count=0
	s medAdvDicID=""
	f  s medAdvDicID=$o(^DHCPHDSD(medAdvDicID)) q:medAdvDicID=""  d
	.s Code=$p(^DHCPHDSD(medAdvDicID),"^",1) //代码
	.s Desc=$p(^DHCPHDSD(medAdvDicID),"^",2) //描述
	.s h=h+1
	.s TempStr=medAdvDicID_"^"_Code_"^"_Desc
	.s ^TMP("DHCST","web.DHCSTPHCMDRGSUGDICMAIN","QueryUserMedAdvDic",pid,h)=TempStr
	
	q:h=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s count=0
	s Title="ID^Code^Desc"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMDRGSUGDICMAIN","QueryUserMedAdvDic",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCSTPHCMDRGSUGDICMAIN","QueryUserMedAdvDic",pid,index))
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCST","web.DHCSTPHCMDRGSUGDICMAIN","QueryDrgSugDic",pid)
	k ^TMP("DHCST","web.DHCSTPHCMDRGSUGDICMAIN","QueryUserMedAdvDic",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^TMP("PHCMDRGSUGDICMAIN"))
}

}
