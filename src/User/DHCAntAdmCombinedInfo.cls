Class User.DHCAntAdmCombinedInfo Extends %Persistent
{

/// d ##class(User.DHCAntAdmCombinedInfo).%BuildIndices() 重新生成索引
Relationship ChildDAACS As User.DHCAntAdmCombinedSub [ Cardinality = children, Inverse = DAACIParRef ];

/// PA_ADM 表 RowID   
Property ADMDr As %String;

/// 最大联用数
Property MaxNum As %String;

/// 抗生素品种数
Property KSSNum As %String;

/// 抗生素医嘱项 Arc_itmmast (通过”^”区分多个)
Property KSSInfo As %String(MAXLEN = 1500);

/// 抗生素药理最小分类数
Property MinorSubCatNum As %String;

/// 抗生素药理最小分类(通过”^”区分多个)
Property MinorSubCatInfo As %String;

Property StrDate As %Date;

Property StrTime As %Time;

Property UpdateDate As %Date;

Property UpdateTime As %Time;

Property Note As %String;

/// 备注
Property Note1 As %String;

Index ADM On ADMDr As AlphaUp;

Index NUM On MaxNum As AlphaUp;

Index UpDate On UpdateDate;

ClassMethod Save(parr) As %String
{
	s DAACID=$p(parr,"&",1)
	s ADMDr=$p(parr,"&",2)
	s MaxNum=$p(parr,"&",3)
	s KSSNum=$p(parr,"&",4)
	s KSSInfo=$p(parr,"&",5)
	s MinorSubCatNum=$p(parr,"&",6)
	s MinorSubCatInfo=$p(parr,"&",7)
	s Date=$p(parr,"&",8)
	s Time=$p(parr,"&",9)
	s Note=$p(parr,"&",10)
	s Note1=$p(parr,"&",11)
	
	i DAACID="" d
	.s a=##class(User.DHCAntAdmCombinedInfo).%New()
	.s a.StrDate=Date
	.s a.StrTime=Time
	e  d
	.s a=##class(User.DHCAntAdmCombinedInfo).%OpenId(DAACID)
	
	i ADMDr'="" s a.ADMDr=ADMDr
	i MaxNum'="" s a.MaxNum=MaxNum
	i KSSNum'="" s a.KSSNum=KSSNum
	i KSSInfo'="" s a.KSSInfo=KSSInfo
	i KSSInfo="+" s a.KSSInfo=""
	i MinorSubCatNum'="" s a.MinorSubCatNum=MinorSubCatNum
	i MinorSubCatInfo'="" s a.MinorSubCatInfo=MinorSubCatInfo
	i Date'="" s a.UpdateDate=Date
	i Time'="" s a.UpdateTime=Time
	i Note'="" s a.Note=Note
	i Note1'="" s a.Note1=Note1
	
	d a.%Save()
	q a.%Id()
}

Storage Default
{
<Data name="DHCAntAdmCombinedInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ADMDr</Value>
</Value>
<Value name="3">
<Value>MaxNum</Value>
</Value>
<Value name="4">
<Value>KSSNum</Value>
</Value>
<Value name="5">
<Value>KSSInfo</Value>
</Value>
<Value name="6">
<Value>MinorSubCatNum</Value>
</Value>
<Value name="7">
<Value>MinorSubCatInfo</Value>
</Value>
<Value name="8">
<Value>StrDate</Value>
</Value>
<Value name="9">
<Value>StrTime</Value>
</Value>
<Value name="10">
<Value>UpdateDate</Value>
</Value>
<Value name="11">
<Value>UpdateTime</Value>
</Value>
<Value name="12">
<Value>Note</Value>
</Value>
<Value name="13">
<Value>Note1</Value>
</Value>
</Data>
<DataLocation>^User.DHCAntAdmCombinedInfoD</DataLocation>
<DefaultData>DHCAntAdmCombinedInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCAntAdmCombinedInfoD</IdLocation>
<IndexLocation>^User.DHCAntAdmCombinedInfoI</IndexLocation>
<StreamLocation>^User.DHCAntAdmCombinedInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
