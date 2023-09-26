Class User.JiangMeiLincbp Extends %Persistent
{

/// Function:返回n小时之后的日期和时间
/// CreateDate:2023-9-16
/// Creator:蒋美林
/// d ##class (User.JiangMeiLincpb).GetjiangmeilincpbDateTime(3)
ClassMethod GetjiangmeilincpbDateTime(n As %String)
{
	s DateTime=$h
    s Date=+DateTime  //取日期
	s Time=$p(DateTime,",",2)  
	s AddTime=n*60*60  //小时换算成秒
	s CruntTime=Time=+AddTime
	if (Time>(24*60*60))
	{
		s CruntTime=CruntTime - (24*60*60)
		s Date=Date+1
	}
	s CruntTime=$zt(CruntTime)
	s Date=$zd(date,3)
	q Date_""_CruntTime
}

Storage Default
{
<Data name="JiangMeiLincbpDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^User.JiangMeiLincbpD</DataLocation>
<DefaultData>JiangMeiLincbpDefaultData</DefaultData>
<IdLocation>^User.JiangMeiLincbpD</IdLocation>
<IndexLocation>^User.JiangMeiLincbpI</IndexLocation>
<StreamLocation>^User.JiangMeiLincbpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
