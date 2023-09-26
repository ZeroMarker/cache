Import SQLUser

/// Creator: bianshuai
/// CreateDate: 2014-09-27
/// Descript: 手术项目、分类维护
Class web.DHCSTPHCMMAINTOPER Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:保存手术类别
/// w ##class(web.DHCSTPHCMMAINTOPER).SaveOperCategory("^SDFASDF^ASD")
ClassMethod SaveOperCategory(DataList As %String) As %String
{
	n (DataList)
	s len=$L(DataList,"||")
	f i=1:1:len d
	.s TmpStr=$p(DataList,"||",i)
	.i $p(TmpStr,"^",1)'="" d
	..s ret=..UpdOperCat(TmpStr)
	.e  d
	..s ret=..InsOperCat(TmpStr)
	q 0
}

/// Descript:更新手术类别
/// w ##class(web.DHCSTPHCMMAINTOPER).UpdOperCat("^SDFASDF^ASD")
ClassMethod UpdOperCat(DataList As %String) As %String
{
	N (DataList)
	S phocgid=$p(DataList,"^",1)
	S CatCode=$p(DataList,"^",2)
	S CatDesc=$p(DataList,"^",3)
	&SQL(UPDATE DHCPH_OperCateGory Set PHOCG_Code=:CatCode,PHOCG_Desc=:CatDesc WHERE PHOCG_RowId=:phocgid)
 	Q SQLCODE
}

/// Descript:增加手术类别
/// w ##class(web.DHCSTPHCMMAINTOPER).InsOperCat("^SDFASDF^ASD")
ClassMethod InsOperCat(DataList As %String) As %String
{
	N (DataList)
	S CatCode=$p(DataList,"^",2)
	S CatDesc=$p(DataList,"^",3)
 	&SQL(INSERT INTO DHCPH_OperCateGory(PHOCG_Code,PHOCG_Desc) VALUES(:CatCode,:CatDesc))
 	Q SQLCODE
}

/// Descript:删除手术类别
ClassMethod DelOperCategory(phocgid As %String) As %String
{
	N (phocgid)
	&SQL(Delete From DHCPH_OperCateGory Where PHOCG_RowId=:phocgid)
	Q PhocgID
}

/// Descript:保存手术项目
/// w ##class(web.DHCSTPHCMMAINTOPER).SaveOperItem("^SDFASDF^ASD")
ClassMethod SaveOperItem(DataList As %String) As %String
{
	n (DataList)
	s len=$L(DataList,"||")
	f i=1:1:len d
	.s TmpStr=$p(DataList,"||",i)
	.i $p(TmpStr,"^",1)'="" d
	..s ret=..UpdOperItem(TmpStr)
	.e  d
	..s ret=..InsOperItem(TmpStr)
	q 0
}

/// Descript:更新手术项目
/// w ##class(web.DHCSTPHCMMAINTOPER).UpdOperItem("^SDFASDF^ASD")
ClassMethod UpdOperItem(DataList As %String) As %String
{
	N (DataList)
	S phoiid=$p(DataList,"^",1)
	S Code=$p(DataList,"^",2)
	S Desc=$p(DataList,"^",3)
	S CatDr=$p(DataList,"^",4)
	&SQL(UPDATE DHCPH_OperItem Set PHOI_Code=:Code,PHOI_Desc=:Desc,PHOI_CateGroy_Dr=:CatDr WHERE PHOI_RowId=:phoiid)
 	Q SQLCODE
}

/// Descript:增加手术项目
/// w ##class(web.DHCSTPHCMMAINTOPER).InsOperItem("^SDFASDF^ASD")
ClassMethod InsOperItem(DataList As %String) As %String
{
	N (DataList)
	S Code=$p(DataList,"^",2)
	S Desc=$p(DataList,"^",3)
	S CatDr=$p(DataList,"^",4)
 	&SQL(INSERT INTO DHCPH_OperItem(PHOI_Code,PHOI_Desc,PHOI_CateGroy_Dr) VALUES(:Code,:Desc,:CatDr))
 	Q SQLCODE
}

/// Descript:删除手术项目
ClassMethod DelOperItem(phoiid As %String) As %String
{
	N (phoiid)
	&SQL(Delete From DHCPH_OperItem Where PHOI_RowId=:phoiid)
	Q PhocgID
}

/// Descript:查询手术类别
/// Table:DHCPH_OperCateGory
/// w ##class(web.DHCSTPHCMMAINTOPER).QueryOperCategory("12","1","")
ClassMethod QueryOperCategory(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	s End = page*rows
	s Start=(page-1)*rows+1
    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
	s h=0,count=0
	s ID=""
	f  s ID=$o(^DHCPHOCG(ID)) q:ID=""  d
	.s Code=$p(^DHCPHOCG(ID),"^",1) //代码
	.s Desc=$p(^DHCPHOCG(ID),"^",2) //描述
	.s h=h+1
	.s TempStr=ID_"^"_Code_"^"_Desc
	.s ^TMP("DHCST","web.DHCSTPHCMMAINTOPER","QueryOperCategory",pid,h)=TempStr
	
	i h=0 w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) //输出json结尾符
	q:h=0 "0"
	///转换数据为Json格式
	S Title="ID^Code^Desc"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMMAINTOPER","QueryOperCategory",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCSTPHCMMAINTOPER","QueryOperCategory",pid,index))
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

/// Descript:查询手术项目
ClassMethod QueryOperItem(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	s End = page*rows
	s Start=(page-1)*rows+1
    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s opitmid=$p(params,"^",1)
    s opcatid=$p(params,"^",2)
	s h=0,count=0
	s ID=""
	f  s ID=$o(^DHCPHOI(ID)) q:ID=""  d
	.s Code=$p(^DHCPHOI(ID),"^",1) //代码
	.s Desc=$p(^DHCPHOI(ID),"^",2) //描述
	.s CatDr=$p(^DHCPHOI(ID),"^",3) //类型
	.q:(opitmid'="")&(opitmid'=ID)
	.q:(opcatid'="")&(opcatid'=CatDr)
	.s CatDesc=""
	.i CatDr'="" d
	..S CatDesc=$p(^DHCPHOCG(CatDr),"^",2)
	.s h=h+1
	.s TempStr=ID_"^"_Code_"^"_Desc_"^"_CatDr_"^"_CatDesc
	.s ^TMP("DHCST","web.DHCSTPHCMMAINTOPER","QueryOperItem",pid,h)=TempStr
	
	i h=0 w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) //输出json结尾符
	q:h=0 "0"
	///转换数据为Json格式
	S Title="ID^Code^Desc^CatDr^CatDesc"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMMAINTOPER","QueryOperItem",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCSTPHCMMAINTOPER","QueryOperItem",pid,index))
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

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCST","web.DHCSTPHCMAUDITPRECON","QueryOperCategory",pid)
	k ^TMP("DHCST","web.DHCSTPHCMAUDITPRECON","QueryOperItem",pid)
}

/// Creator:bianshuai
/// CreateDate:2014-08-24
/// Descritp:手术类别
ClassMethod SelOperCateGory() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM DHCPH_OperCateGory"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("PHOCG_RowId")
		s Desc = result.Data("PHOCG_Desc")
		s tmp=RowId_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("val^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("val^text",tmp)
	}
	w "]"
}

/// Creator:qunianpeng
/// CreateDate:2016-09-21
/// Descritp:手术类别
ClassMethod SelOperCateGoryNew() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM orc_operation"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("OPER_RowId")
		s Desc = result.Data("OPER_Desc")
		s ActiveDateTo=result.Data("OPER_ActiveDateTo")
		continue:((ActiveDateTo'="")&&(ActiveDateTo<+$h))  //lbb 2019/06/21 过滤截止日期为当前日期之前的日期
		s OPERValid=result.Data("OPER_Valid")
		continue:OPERValid="N"                             //lbb 2019/06/21 过滤无效的手术
		s Desc=##class(PHA.FACE.IN.Com).GetTransDesc("User.orcoperation","OPERDesc","",Desc)
		s tmp=RowId_"^"_Desc
		s count = count+1
		q:count=537
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("val^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("val^text",tmp)
	}
	w "]"
}

/// Creator:bianshuai
/// CreateDate:2014-08-24
/// Descritp:手术项目
ClassMethod SelOperItem() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM DHCPH_OperItem"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("PHOI_RowId")
		s Desc = result.Data("PHOI_Desc")
		s tmp=RowId_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("val^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("val^text",tmp)
	}
	w "]"
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^TMP("PHCMMAINTOPER"))
}

}
