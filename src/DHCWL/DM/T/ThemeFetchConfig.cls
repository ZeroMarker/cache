/// d ##class(DHCWL.DM.T.ThemeFetchConfig).RebuildIndex()
Class DHCWL.DM.T.ThemeFetchConfig Extends %Persistent
{

Property ThemeBase As ThemeBase [ Required ];

Property FactMetaTable As MetaTableBase [ Required ];

Property LinkPosition As %Integer [ Required ];

Property JoinField As MetaTablePro;

Property ParentConfig As ThemeFetchConfig;

Property ParentJoinField As MetaTablePro;

Index MainI On (ThemeBase, LinkPosition, FactMetaTable) [ PrimaryKey ];

// d ##class(DHCWL.DM.T.ThemeFetchConfig).TestData()

ClassMethod TestData()
{
	&sql(delete DHCWL_DM_T.ThemeFetchConfig)
	k ^DHCWL.DM.T.ThemeFetchConfigD,^DHCWL.DM.T.ThemeFetchConfigI
	s base=##class(ThemeBase).GetByPath("/workload.t")
	s base2=##class(ThemeBase).GetByPath("/workload2.t")
	s base3=##class(ThemeBase).GetByPath("/workload3.t")
	s base4=##class(ThemeBase).GetByPath("/workload4.t")
	s fact=##class(MetaTableBase).GetByPath("/workload.mf")
	s obj=##class(ThemeFetchConfig).%New()
	s obj.ThemeBase=base,obj.FactMetaTable=fact,obj.LinkPosition=1 ;,obj.JoinField=fact.GetProperty("WorkLoad_RecDep_DR")
	
	d obj.%Save()
	w obj.%Id(),","
	s dim=##class(DHCWL.DM.T.MetaTableBase).GetByPath("/ctloc.ml")
	s obj2=##class(ThemeFetchConfig).%New()
	s obj2.ThemeBase=base,obj2.FactMetaTable=dim,obj2.LinkPosition=2 ,obj2.JoinField=dim.GetProperty("CTLOC_RowID")
	s obj2.ParentConfig=obj,obj2.ParentJoinField=fact.GetProperty("WorkLoad_RecDep_DR")
	d obj2.%Save()
	w obj2.%Id(),","
	
	;q
	s obj3=##class(ThemeFetchConfig).%New()
	s obj3.ThemeBase=base,obj3.FactMetaTable=dim,obj3.LinkPosition=3 ,obj3.JoinField=dim.GetProperty("CTLOC_RowID")
	s obj3.ParentConfig=obj,obj3.ParentJoinField=fact.GetProperty("WorkLoad_PatDep_DR")
	d obj3.%Save()
	w obj3.%Id(),","
	
	s obj4=##class(ThemeFetchConfig).%New()
	s obj4.ThemeBase=base,obj4.FactMetaTable=dim,obj4.LinkPosition=4 ,obj4.JoinField=dim.GetProperty("CTLOC_RowID")
	s obj4.ParentConfig=obj,obj4.ParentJoinField=fact.GetProperty("WorkLoad_PatWard_DR")
	d obj4.%Save()
	w obj4.%Id(),","
	
	
	s obj=##class(ThemeFetchConfig).%New()
	s obj.ThemeBase=base2,obj.FactMetaTable=fact,obj.LinkPosition=1 ;,obj.JoinField=fact.GetProperty("WorkLoad_RecDep_DR")
	
	d obj.%Save()
	w obj.%Id(),","
	s dim=##class(MetaTableBase).GetByPath("/ctloc.ml")
	s obj2=##class(ThemeFetchConfig).%New()
	s obj2.ThemeBase=base2,obj2.FactMetaTable=dim,obj2.LinkPosition=2 ,obj2.JoinField=dim.GetProperty("CTLOC_RowID")
	s obj2.ParentConfig=obj,obj2.ParentJoinField=fact.GetProperty("WorkLoad_RecDep_DR")
	d obj2.%Save()
	w obj2.%Id(),","
	
	;q
	s obj3=##class(ThemeFetchConfig).%New()
	s obj3.ThemeBase=base2,obj3.FactMetaTable=dim,obj3.LinkPosition=3 ,obj3.JoinField=dim.GetProperty("CTLOC_RowID")
	s obj3.ParentConfig=obj,obj3.ParentJoinField=fact.GetProperty("WorkLoad_PatDep_DR")
	d obj3.%Save()
	w obj3.%Id(),","
	
	s obj4=##class(ThemeFetchConfig).%New()
	s obj4.ThemeBase=base2,obj4.FactMetaTable=dim,obj4.LinkPosition=4 ,obj4.JoinField=dim.GetProperty("CTLOC_RowID")
	s obj4.ParentConfig=obj,obj4.ParentJoinField=fact.GetProperty("WorkLoad_PatWard_DR")
	d obj4.%Save()
	w obj4.%Id(),","
	
	
	
	
	
	s obj=##class(ThemeFetchConfig).%New()
	s obj.ThemeBase=base3,obj.FactMetaTable=fact,obj.LinkPosition=1 ;,obj.JoinField=fact.GetProperty("WorkLoad_RecDep_DR")
	d obj.%Save()
	w obj.%Id(),","
	
	s workload4=##class(ThemeBase).GetByPath("/WorkLoad4.t")
	s workload4fact=##class(MetaTableBase).GetByPath("/WorkLoad.mf")
	s obj=##class(ThemeFetchConfig).%New()
	s obj.ThemeBase=workload4,obj.FactMetaTable=workload4fact,obj.LinkPosition=1 ;,obj.JoinField=fact.GetProperty("WorkLoad_RecDep_DR")
	
	d obj.%Save()
	w obj.%Id(),","
}

// s list= ##class(DHCWL.DM.T.ThemeFetchConfig).Get(1)

ClassMethod Get(themePath) As %ListOfObjects
{
	s list=##class(%ListOfObjects).%New()
	s themeId=##class(ThemeBase).GetIdByPath(themePath)
	q:(themeId="")||( '$d( ^DHCWL.DM.T.ThemeFetchConfigI("MainI",themeId)) ) list
	s lp="" f  s lp=$o( ^DHCWL.DM.T.ThemeFetchConfigI("MainI",themeId,lp) ) q:lp=""  d
	.s fmti="" f  s fmti=$o( ^DHCWL.DM.T.ThemeFetchConfigI("MainI",themeId,lp,fmti) ) q:fmti=""  d
	..s id=$o( ^DHCWL.DM.T.ThemeFetchConfigI("MainI",themeId,lp,fmti,"") )
	..q:'$d( ^DHCWL.DM.T.ThemeFetchConfigD(id) )
	..s obj=##class(ThemeFetchConfig).%OpenId(id)
	..q:obj=""
	..d list.InsertAt(obj,lp)
	q list
}

ClassMethod GetAt(themePath, position) As ThemeFetchConfig
{
	s themeId=##class(ThemeBase).GetIdByPath(themePath)	
	q:(themeId="")||( ( '$d( ^DHCWL.DM.T.ThemeFetchConfigI("MainI",themeId) ) ) ||  ( '$d( ^DHCWL.DM.T.ThemeFetchConfigI("MainI",themeId,position) ) ) ) ""
	s ftbi=$o( ^DHCWL.DM.T.ThemeFetchConfigI("MainI",themeId,position,"") )
	s id=$o( ^DHCWL.DM.T.ThemeFetchConfigI("MainI",themeId,position,ftbi,"") )
	s obj=##class(ThemeFetchConfig).%OpenId(id)
	q obj
}

Method GetSQL() As %String
{
	s s1=##class(ThemeDims).GetFetchSelect(..ThemeBase.%Id(),..%Id())
	i ..JoinField'="" d
	.i s1'="" d
	..s s1=s1_","_..JoinField.Code
	.e  d
	..s s1=..JoinField.Code
	s themeId=..ThemeBase.%Id(),pnum=0,ps="",fetchId=..%Id()
	k psfMap
	s lp="" f  s lp=$o( ^DHCWL.DM.T.ThemeFetchConfigI("MainI",themeId,lp) ) q:lp=""  d
	.s ftbi=$o( ^DHCWL.DM.T.ThemeFetchConfigI("MainI",themeId,lp,"") )
	.s id=$o( ^DHCWL.DM.T.ThemeFetchConfigI("MainI",themeId,lp,ftbi,"") )
	.q:'$d(^DHCWL.DM.T.ThemeFetchConfigD(id))
	.s pid=$lg(^DHCWL.DM.T.ThemeFetchConfigD(id),6)
	.q:pid=""
	.q:pid'=fetchId
	.s obj=##class(ThemeFetchConfig).%OpenId(id)
	.q:$d(psfMap(obj.ParentJoinField.Code))
	.s pobj=##class(ThemeFetchConfig).%OpenId(pid)
	.s psfMap(obj.ParentJoinField.Code)=""
	s ps="", pjfc="" f  s pjfc=$o(psfMap(pjfc)) q:pjfc=""  d
	.s pnum=pnum+1
	.s:(pnum>1) ps=ps_","
	.s ps=ps_pjfc
	i ps'="" d
	.i s1'="" d
	..s s1=s1_","_ps
	.e  d
	..s s1=ps
	
	s s2=##class(ThemeMetrics).GetFetchSelect(..ThemeBase.%Id(),..%Id())
	s select=""
	i ( (s1'="") && (s2'="") ) d
	.s select=s1_","_s2
	e  i (s1'="") d
	.s select=s1
	e  i s2'="" d
	.s select=s2
	e  d
	.s select="*"
	s sql= " ( SELECT "_select_" FROM "_..FactMetaTable.GetSQLRef()
	s where=##class(ThemeFetchFilter).GetWhere( ..%Id() )
	i where'="" d
	.s sql=sql_" WHERE "_where
	s sql=sql_" ) AS t"_..%Id()
	;s sql=sql_" )"
	q sql
}

Method GetMetaSQL() As %String
{
	s s1=##class(ThemeDims).GetFetchSelect(..ThemeBase.%Id(),..%Id())
	i ..JoinField'="" d
	.i s1'="" d
	..s s1=s1_","_..JoinField.Code
	.e  d
	..s s1=..JoinField.Code
	s themeId=..ThemeBase.%Id(),pnum=0,ps="",fetchId=..%Id()
	k psfMap
	s lp="" f  s lp=$o( ^DHCWL.DM.T.ThemeFetchConfigI("MainI",themeId,lp) ) q:lp=""  d
	.s ftbi=$o( ^DHCWL.DM.T.ThemeFetchConfigI("MainI",themeId,lp,"") )
	.s id=$o( ^DHCWL.DM.T.ThemeFetchConfigI("MainI",themeId,lp,ftbi,"") )
	.q:'$d(^DHCWL.DM.T.ThemeFetchConfigD(id))
	.s pid=$lg(^DHCWL.DM.T.ThemeFetchConfigD(id),6)
	.q:pid=""
	.q:pid'=fetchId
	.s obj=##class(ThemeFetchConfig).%OpenId(id)
	.q:$d(psfMap(obj.ParentJoinField.Code))
	.s pobj=##class(ThemeFetchConfig).%OpenId(pid)
	.s psfMap(obj.ParentJoinField.Code)=""
	s ps="", pjfc="" f  s pjfc=$o(psfMap(pjfc)) q:pjfc=""  d
	.s pnum=pnum+1
	.s:(pnum>1) ps=ps_","
	.s ps=ps_pjfc
	i ps'="" d
	.i s1'="" d
	..s s1=s1_","_ps
	.e  d
	..s s1=ps
	
	s s2=##class(ThemeMetrics).GetFetchSelect(..ThemeBase.%Id(),..%Id())
	s select=""
	i ( (s1'="") && (s2'="") ) d
	.s select=s1_","_s2
	e  i (s1'="") d
	.s select=s1
	e  i s2'="" d
	.s select=s2
	e  d
	.s select="*"
	s sql= " ( select "_select_"  FROM "_..FactMetaTable.GetSQLRef()_" WHERE 1=0"
	s where=##class(ThemeFetchFilter).GetWhere( ..%Id() )
	s sql=sql_" ) AS t"_..%Id()
	;s sql=sql_" )"
	q sql
}

ClassMethod GetJoin(themeId, pos) As %String
{
	q:( (themeId="") || '$d(^DHCWL.DM.T.ThemeFetchConfigI("MainI",themeId)) || '$d(^DHCWL.DM.T.ThemeFetchConfigI("MainI",themeId,pos)) ) ""
	s fId=$o( ^DHCWL.DM.T.ThemeFetchConfigI("MainI",themeId,pos,"") )
	s id=$o( ^DHCWL.DM.T.ThemeFetchConfigI("MainI",themeId,pos,fId,"") )
	s obj=##class(ThemeFetchConfig).%OpenId(id)
	q "t"_obj.%Id()_"."_obj.JoinField.Code_"="_"t"_obj.ParentConfig.%Id()_"."_obj.ParentJoinField.Code
}

Storage Default
{
<Data name="ThemeFetchConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ThemeBase</Value>
</Value>
<Value name="3">
<Value>FactMetaTable</Value>
</Value>
<Value name="4">
<Value>LinkPosition</Value>
</Value>
<Value name="5">
<Value>JoinField</Value>
</Value>
<Value name="6">
<Value>ParentConfig</Value>
</Value>
<Value name="7">
<Value>ParentJoinField</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.ThemeFetchConfigD</DataLocation>
<DefaultData>ThemeFetchConfigDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.ThemeFetchConfigD</IdLocation>
<IndexLocation>^DHCWL.DM.T.ThemeFetchConfigI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.ThemeFetchConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
