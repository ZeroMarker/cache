Import SQLUser

Class web.AJAXTEST Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod Reasonajax() As %String
{
	;检索拒发药原因AJAX测试
	&sql(DECLARE ajax CURSOR FOR
    Select  rf_rowid,rf_code,rf_desc from dhc_strefusereason)
	&sql(OPEN ajax)
    s num=0
    s SQLCODE=0
    s mess=""
    f  &sql(FETCH ajax INTO :rowid,:code,:desc) q:SQLCODE  d
    .s num=num+1
    .i mess="" s mess=mess_"{""Rowid"":'"_rowid_"',""Code"":'"_code_"',""Name"":'"_desc_"'}"
    .e  s mess=mess_",{""Rowid"":'"_rowid_"',""Code"":'"_code_"',""Name"":'"_desc_"'}"
    s mess="{""TotalRowNum"":"""_num_""",""Str"":["_mess_"]}"
    &SQL(CLOSE ajax)
    Write mess
}

ClassMethod ReasonAdd(Code, Name) As %String
{
	;增加拒发药原因
	&sql(insert into dhc_strefusereason (rf_code,rf_desc) values(:Code,:Name))
	i SQLCODE'=0 w "{""success"":""false"",""info"":""添加失败!"_SQLCODE_"""}"
	e  w "{""success"":""true"",""info"":""添加成功!""}"
}

ClassMethod ReasonEdit(Rowid, Code, Name) As %String
{
	;更新拒发药原因
	&sql(update  dhc_strefusereason set rf_code=:Code,rf_desc=:Name where rf_Rowid=:Rowid)
	i SQLCODE'=0 w "{""success"":""false"",""info"":""更新失败!"_SQLCODE_"""}"
	e  w "{""success"":""true"",""info"":""更新成功!""}"
}

ClassMethod ReasonDel(Rowid) As %String
{
	;删除拒发药原因
	s ^tmplqxxx("d")=Rowid_"^"_Code_"^"_Name
	&sql(delete  from dhc_strefusereason where rf_Rowid=:Rowid)
	i SQLCODE'=0 w "{""success"":""false"",""info"":""删除失败!"_SQLCODE_"""}"
	e  w "{""success"":""true"",""info"":""删除成功!""}"
}

}
