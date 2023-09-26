Class User.DHCAntAdmCombinedSub Extends %Persistent [ ProcedureBlock ]
{

/// 主表Id
Relationship DAACIParRef As User.DHCAntAdmCombinedInfo [ Cardinality = parent, Inverse = ChildDAACS ];

/// 抗生素联用数
Property CNum As %String;

/// 抗生素联用原因Id(通过”^”区分多个)
Property CURId As %String;

/// 抗生素更换原因Id(通过”^”区分多个)
Property CHRId As %String;

/// 使用目的Id(通过”^”区分多个)
Property DAUPId As %String(MAXLEN = 1500);

/// 更改使用目的Id(通过”^”区分多个)
Property ChaDAUPId As %String;

/// 抗生素医嘱项 Arc_itmmast (通过”^”区分多个)
Property KSSInfo As %String(MAXLEN = 1500);

/// 医嘱类型串(通过"^"来区分)
Property PriorityInfo As %String;

/// 抗生素药理最小分类数
Property MinorSubCatNum As %String;

/// 抗生素药理最小分类(通过”^”区分多个)
Property MinorSubCatInfo As %String;

/// 开始日期
Property StrDate As %Date;

/// 开始时间
Property StrTime As %Time;

/// 结束日期
Property EndDate As %Date;

/// 结束时间
Property EndTime As %Time;

/// 临时使用目的ID
Property Note As %String(MAXLEN = 1500);

/// 作废使用目的ID
Property Note1 As %String(MAXLEN = 1500);

Index SDATE On StrDate;

ClassMethod Save(parr) As %String
{
	s DAACSub=$p(parr,"&",1)
	s DAACID=$p(parr,"&",2)
	s CNum=$p(parr,"&",3)
	s CURId=$p(parr,"&",4)
	s CHRId=$p(parr,"&",5)
	s DAUPId=$p(parr,"&",6)
	s ChaDAUPId=$p(parr,"&",7)
	s KSSInfo=$p(parr,"&",8)
	s PriorityInfo=$p(parr,"&",9)
	s MinorSubCatNum=$p(parr,"&",10)
	s MinorSubCatInfo=$p(parr,"&",11)
	s StrDate=$p(parr,"&",12)
	s StrTime=$p(parr,"&",13)
	s EndDate=$p(parr,"&",14)
	s EndTime=$p(parr,"&",15)
	s Note=$p(parr,"&",16)
	s Note1=$p(parr,"&",17)
	
	i DAACSub="" d
	.Set a=##Class(User.DHCAntAdmCombinedSub).%New()
	.Set a.DAACIParRef=##Class(User.DHCAntAdmCombinedInfo).%OpenId(DAACID)
	e  d
	.s a=##class(User.DHCAntAdmCombinedSub).%OpenId(DAACSub)
	
	i CNum'="" s a.CNum=CNum
	i CURId'="" s a.CURId=CURId
	i CHRId'="" s a.CHRId=CHRId
	i DAUPId'="" s a.DAUPId=DAUPId
	i ChaDAUPId'="" s a.ChaDAUPId=ChaDAUPId
	i KSSInfo'="" s a.KSSInfo=KSSInfo
	i PriorityInfo'="" s a.PriorityInfo=PriorityInfo
	i MinorSubCatNum'="" s a.MinorSubCatNum=MinorSubCatNum
	i MinorSubCatInfo'="" s a.MinorSubCatInfo=MinorSubCatInfo
	i StrDate'="" s a.StrDate=StrDate
	i StrTime'="" s a.StrTime=StrTime
	b ;0011
	i EndDate'="" s a.EndDate=EndDate
	i EndTime'="" s a.EndTime=EndTime
	i Note'="" s a.Note=Note
	i Note="+" s a.Note="" ;;特殊处理,更新程序不处理空
	i DAUPId="+" s a.DAUPId="",a.KSSInfo="",a.PriorityInfo=""
	i Note1'="" s a.Note1=Note1
	
	//d a.%Save()
	s sc=a.%Save()
	If $$$ISERR(sc) {
		d $system.OBJ.DisplayError(sc) 
		Q -101
	} else {
		//s mRtn=a.%Id()
	}
	
	
	q a.%Id()
}

Storage Default
{
<Data name="DHCAntAdmCombinedSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CNum</Value>
</Value>
<Value name="3">
<Value>CURId</Value>
</Value>
<Value name="4">
<Value>CHRId</Value>
</Value>
<Value name="5">
<Value>DAUPId</Value>
</Value>
<Value name="6">
<Value>ChaDAUPId</Value>
</Value>
<Value name="7">
<Value>KSSInfo</Value>
</Value>
<Value name="8">
<Value>PriorityInfo</Value>
</Value>
<Value name="9">
<Value>MinorSubCatNum</Value>
</Value>
<Value name="10">
<Value>MinorSubCatInfo</Value>
</Value>
<Value name="11">
<Value>StrDate</Value>
</Value>
<Value name="12">
<Value>StrTime</Value>
</Value>
<Value name="13">
<Value>EndDate</Value>
</Value>
<Value name="14">
<Value>EndTime</Value>
</Value>
<Value name="15">
<Value>Note</Value>
</Value>
<Value name="16">
<Value>Note1</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildDAACS")</DataLocation>
<DefaultData>DHCAntAdmCombinedSubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ChildDAACS")</IdLocation>
<IndexLocation>^User.DHCAntAdmCombinedSubI</IndexLocation>
<StreamLocation>^User.DHCAntAdmCombinedSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
