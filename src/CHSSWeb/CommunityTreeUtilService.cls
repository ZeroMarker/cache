Class CHSSWeb.CommunityTreeUtilService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 根据树传过来的节点，取出对应的下属所有机构
/// 参数：树节点的类型(省,市，县，街道)，树节点的id
/// 
ClassMethod getCommunityCode(level, id)
{
	q:level=""||id="" ""
	s result = ##class(%Library.ResultSet).%New()
	s totalCommunitycode=""	
	s sqlStr=""
	i level="city" d
	.s sqlStr="select a.communitycode as comm,a.communityname as commname  from chss.dicthospital a,chss.dictcity b,chss.dictsection c,chss.dictstreet d where b.rowid=c.rowidparref and c.rowid=d.rowidparref and a.recorddr=d.rowid and (a.communitytype='社区卫生服务中心' or a.communitytype='乡镇卫生院') and b.rowid="_id_" union select a.communitycode,a.communityname from chss.dicthospital a,chss.dictcity b,chss.dictsection c,chss.dictstreet d,chss.dictvillage e where b.rowid=c.rowidparref and c.rowid=d.rowidparref and d.rowid=e.rowidparref   and a.recorddr=e.rowid and (a.communitytype='社区卫生服务站' or a.communitytype='村卫生所') and b.rowid="_id
    i level="section" d
    .s sqlStr="select a.communitycode as comm,a.communityname as commname  from chss.dicthospital a, chss.dictsection c,chss.dictstreet d where c.rowid=d.rowidparref and a.recorddr=d.rowid and (a.communitytype='社区卫生服务中心' or a.communitytype='乡镇卫生院') and c.rowid="_id_" union select a.communitycode,a.communityname from chss.dicthospital a ,chss.dictsection c,chss.dictstreet d,chss.dictvillage e where c.rowid=d.rowidparref and d.rowid=e.rowidparref   and a.recorddr=e.rowid and (a.communitytype='社区卫生服务站' or a.communitytype='村卫生所') and c.rowid="_id
    i level="street" d
    .s sqlStr="select a.communitycode as comm,a.communityname as commname  from chss.dicthospital a,  chss.dictstreet d where a.recorddr=d.rowid and (a.communitytype='社区卫生服务中心' or a.communitytype='乡镇卫生院') and d.rowid="_id_" union select a.communitycode,a.communityname from chss.dicthospital a  ,chss.dictstreet d,chss.dictvillage e where d.rowid=e.rowidparref   and a.recorddr=e.rowid and (a.communitytype='社区卫生服务站' or a.communitytype='村卫生所') and d.rowid="_id
   
	d result.Prepare(sqlStr)
	d result.Execute()	
	s count=0
	s ch=""
	While(result.Next())
	{
    s temp=result.Get("comm")_","_result.Get("commname")
	s totalCommunitycode=totalCommunitycode_ch_temp
	s ch="^"
	}
	d result.Close()
	q totalCommunitycode
}

Storage Default
{
<Data name="CommunityTreeUtilServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.CommunityTre9C4D</DataLocation>
<DefaultData>CommunityTreeUtilServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.CommunityTre9C4D</IdLocation>
<IndexLocation>^CHSSWeb.CommunityTre9C4I</IndexLocation>
<StreamLocation>^CHSSWeb.CommunityTre9C4S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
