Import SQLUser

Class web.SCVueJSON Extends %RegisteredObject
{

/// Description:根据表名，返回json数据
/// Creator:	sc
/// CreatDate:	2014-12-14\
/// w ##class(web.SCVueJSON).GetJsonByTableName("DHC_QTRECTYP")
ClassMethod GetJsonByTableName(tab As %String, Page As %String, Limit As %String) As %String
{
	s result=""
	s sql="select * from "_tab
	s xs=##class(%ResultSet).%New()
	d xs.Prepare(sql)
	s ret=xs.Execute(sql)
	s colcnt=xs.GetColumnCount()
	s count = 0
	s StartNum = (Page-1)*Limit
 	s EndNum = StartNum+Limit+1
	while (xs.Next())
	{
	   s count = count+1
	   i (count>StartNum)&&(count<EndNum) d
	   .s objRow = ""
	   .f i=1:1:colcnt d
	   ..s colname=xs.GetColumnName(i)
	   ..s tabRowid=$o(^DHCSSTabField(0,"TF",tab,colname,""))
	   ..s:tabRowid'="" colname=$p(^DHCSSTabField(tabRowid),"^",3)
	   ..s data=xs.GetData(i)
	   ..s data = $REPLACE(data,"""","\""")
	   ..i objRow="" d
	   ...s objRow="{"_colname_":"""_data
	   ..e  d
	   ...s objRow=objRow_""","_colname_":"""_data
	   .s objRow=objRow_"""}"
	   .s result = result_objRow_","
	}
	s result="{total:"_count_",rows:["_result_"]}"
	
	d xs.Close()
	q result
}

/// Description:根据表名,tableRow，返回json数据
/// Creator:	sc
/// CreatDate:	2014-12-14\
/// w ##class(web.SCVueJSON).GetJsonByTableRow("PAC_Ward","WARD_RowID^WARD_Desc^",1,7)
ClassMethod GetJsonByTableRow(tab As %String, Param As %String, Page As %String, Limit As %String) As %String
{
	s result=""
	s count = 1
	s sqlCondition = " where "
	s sql="" 
	f  s colnamevale = $p($g(Param),"^",count) q:colnamevale=""  d
	.s count = count+1
	.s colname =$p($g(colnamevale),":",1)
	.s colval = $p($g(colnamevale),":",2)
	.i colval'="" d
	..s sqlCondition = sqlCondition_colname_" = '"_colval_"' and "
	;s sql = $EXTRACT(sql,0,*-1)_" from "_tab
	s sql = "select * from "_tab_sqlCondition
	s sql =  $EXTRACT(sql,0,*-5)
	;s ^sctmpv1("GetJsonByTableRow") = tab _","_ Param _","_ Page _","_ Limit_"--"_sql
	
	s xs=##class(%ResultSet).%New()
	d xs.Prepare(sql)
	s ret=xs.Execute(sql)
	s colcnt=xs.GetColumnCount()
	s count = 0
	s StartNum = (Page-1)*Limit
 	s EndNum = StartNum+Limit+1
	while (xs.Next())
	{
	   s count = count+1
	   i (count>StartNum)&&(count<EndNum) d
	   .s objRow = ""
	   .f i=1:1:colcnt d
	   ..s colname=xs.GetColumnName(i)
	   ..s tabRowid=$o(^DHCSSTabField(0,"TF",tab,colname,""))
	   ..s:tabRowid'="" colname=$p(^DHCSSTabField(tabRowid),"^",3)
	   ..s data=xs.GetData(i)
	   ..s data = $REPLACE(data,"""","\""")
	   ..i objRow="" d
	   ...s objRow="{"_colname_":"""_data
	   ..e  d
	   ...s objRow=objRow_""","_colname_":"""_data
	   .s objRow=objRow_"""}"
	   .s result = result_objRow_","
	}
	s result="{total:"_count_",rows:["_result_"]}"
	
	d xs.Close()
	q result
}

/// Description:向表中插入数据
/// Creator:	sc
/// CreatDate:	2016-12-15
/// w ##class(web.SCVueJSON).Insert("DHC_WARDITEM","ITEM_ROWID:2^ITEM_CODE:newPat^ITEM_DESC:新入院^ITEM_ORDER:3^ITEM_VISIBLE:true^#%#")
ClassMethod Insert(tab As %String, Param As %String)
{
	;s ^sctmpv1("ins") = tab_","_Param
	;s ss = $p(Param,"^",1)
	;s PList(1) = ""
	s count  = 1
	;s num=$l(Param,"^")
	;b ;ssdfdf
	SET sqltext = "INSERT INTO "_tab_" Values ("
  	f  s val = $p($g(Param),"^",count) q:val="#%#"  d
	.i count>1 d
	..s sqltext = sqltext_"'"_$p($g(val),":",2)_"',"
	..;s PList(count)=val
	.s count = count+1
	s sqltext = $EXTRACT(sqltext,0,*-1)_")"
	TSTART
	s xs=##class(%ResultSet).%New()
	d xs.Prepare(sqltext)
	s ret=xs.Execute(sqltext)
    ;s TYPROWID=0
    ;s TYPROWID=$o(^DHCQTRECTYP("typ",TYPROWID),-1)
    ;TSTART
    ;SET sqltext = "INSERT INTO "_tab_" Values "_:PList
	;&SQL(insert into table_name  Values :PList())
	d xs.Close()
	i ret'=1 d
	.TROLLBACK
	.q:ret
	TCOMMIT
	q ret
}

/// Description:根据表名删除对应数据
/// Creator:	sc
/// CreatDate:	2016-12-15\
/// w ##class(web.SCVueJSON).Delete("DHC_WARDITEM","ITEM_ROWID:6^ITEM_CODE:gm^ITEM_DESC:过敏4^ITEM_ORDER:21^ITEM_VISIBLE:true^#%#")
ClassMethod Delete(tab As %String, Param As %String)
{
	;s ^sctmpv1("del") = tab_","_Param
	
	s idStr = $p($g(Param),"^",1)
	s idKey = $p($g(idStr),":",1)
	s idValue = $p($g(idStr),":",2)
	SET sqltext = "delete from "_tab_" where "_idKey_" = '"_idValue_"'"
	s num=$l(Param,"^")-1
	f i=2:1:num  d
	.s idStr = $p($g(Param),"^",i)
	.s idKey = $p($g(idStr),":",1)
	.s idValue = $p($g(idStr),":",2)
	.s sqltext = sqltext_" and "_idKey_" = '"_idValue_"'"
	TSTART
	s xs=##class(%ResultSet).%New()
	d xs.Prepare(sqltext)
	s ret=xs.Execute(sqltext)
	i ret'=1 d
	.TROLLBACK
	.q:ret
	TCOMMIT
	d xs.Close()
	q ret
}

/// Description:修改表中数据
/// Creator:	sc
/// CreatDate:	2016-12-15
/// w ##class(web.SCVueJSON).Update("DHC_WARDITEM","ITEM_ROWID:2^ITEM_CODE:newPat^ITEM_DESC:新入院^ITEM_ORDER:3^ITEM_VISIBLE:true^#%#")
ClassMethod Update(tab As %String, Param As %String)
{
	s ^sctmpv1("Update") = tab_","_Param
	s idStrCon = $p($g(Param),"^",1)
	s idKeyCon = $p($g(idStrCon),":",1)
	s idValueCon = $p($g(idStrCon),":",2)
	SET sqltext = "UPDATE "_tab_" SET "
	s num=$l(Param,"^")-1
	f i=2:1:num  d
	.s idStr = $p($g(Param),"^",i)
	.s idKey = $p($g(idStr),":",1)
	.s idValue = $p($g(idStr),":",2)
	.s sqltext = sqltext_" "_idKey_" = '"_idValue_"',"
	s sqltext = $e(sqltext,0,*-1)
	s sqltext = sqltext_" where "_idKeyCon_" = '"_idValueCon_"'"
	b ;
	TSTART
	s xs=##class(%ResultSet).%New()
	d xs.Prepare(sqltext)
	s ret=xs.Execute(sqltext)
	i ret'=1 d
	.TROLLBACK
	.q:ret
	TCOMMIT
	d xs.Close()
	q ret
}

Storage Default
{
<Data name="SCVueJSONDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.SCVueJSOND</DataLocation>
<DefaultData>SCVueJSONDefaultData</DefaultData>
<IdLocation>^web.SCVueJSOND</IdLocation>
<IndexLocation>^web.SCVueJSONI</IndexLocation>
<StreamLocation>^web.SCVueJSONS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
