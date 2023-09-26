/// 名称: DHCMed.INF.ICUGrade
/// 描述: ICU病人病情等级人数
/// 编写者：liuyh
/// 编写日期: 2011-03-21
Class DHCMed.INF.ICUGrade Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// 科室
Property CtlocDr As %String(MAXLEN = 20) [ Required ];

/// 年份
Property Year As %String(MAXLEN = 100) [ Required ];

/// 月份
Property Month As %String(MAXLEN = 100) [ Required ];

/// 第一周
Property WeekOneA As %String;

/// 第二周
Property WeekTwoA As %String;

/// 第三周
Property WeekThreeA As %String;

/// 第四周
Property WeekFourA As %String;

/// 第一周
Property WeekOneB As %String;

/// 第二周
Property WeekTwoB As %String;

/// 第三周
Property WeekThreeB As %String;

/// 第四周
Property WeekFourB As %String;

/// 第一周
Property WeekOneC As %String;

/// 第二周
Property WeekTwoC As %String;

/// 第三周
Property WeekThreeC As %String;

/// 第四周
Property WeekFourC As %String;

/// 第一周
Property WeekOneD As %String;

/// 第二周
Property WeekTwoD As %String;

/// 第三周
Property WeekThreeD As %String;

/// 第四周
Property WeekFourD As %String;

/// 第一周
Property WeekOneE As %String;

/// 第二周
Property WeekTwoE As %String;

/// 第三周
Property WeekThreeE As %String;

/// 第四周
Property WeekFourE As %String;

/// 报告人
Property RepUser As %String;

/// 报告日期
Property RepDate As %String;

Index YearIndex On (Year, Month, CtlocDr) [ Unique ];

/// Creator：     liuyh
/// CreatDate：   2011-03-21
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.ICUGrade
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:CtlocDr 3:Year 4:Month 
/// 5:WeekOneA 6:WeekTwoA 7:WeekThreeA 8:WeekFourA
/// 9:WeekOneB 10:WeekTwoB 11:WeekThreeB 12:WeekFourB
/// 13:WeekOneC 14:WeekTwoC 15:WeekThreeC 16:WeekFourC
/// 17:WeekOneD 18:WeekTwoD 19:WeekThreeD 20:WeekFourD
/// 21:WeekOneE 22:WeekTwoE 23:WeekThreeE 24:WeekFourE
/// 25:RepUser 26:RepDate
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..CtlocDr_separete
	set return=return_..Year_separete
	set return=return_..Month_separete
	set return=return_..WeekOneA_separete
	set return=return_..WeekTwoA_separete
	set return=return_..WeekThreeA_separete
	set return=return_..WeekFourA_separete
	set return=return_..WeekOneB_separete
	set return=return_..WeekTwoB_separete
	set return=return_..WeekThreeB_separete
	set return=return_..WeekFourB_separete
	set return=return_..WeekOneC_separete
	set return=return_..WeekTwoC_separete
	set return=return_..WeekThreeC_separete
	set return=return_..WeekFourC_separete
	set return=return_..WeekOneD_separete
	set return=return_..WeekTwoD_separete
	set return=return_..WeekThreeD_separete
	set return=return_..WeekFourD_separete
	set return=return_..WeekOneE_separete
	set return=return_..WeekTwoE_separete
	set return=return_..WeekThreeE_separete
	set return=return_..WeekFourE_separete
	set return=return_..RepUser_separete
	set return=return_..RepDate
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2010-04-06
/// Description:  根据ID取ICU病人等级对象
/// Table：       DHCMed.INF.ICUGrade
/// Input：       ID:    DHCMed.INF.ICUGrade.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.ICUGrade).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.ICUGrade
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.ICUGrade).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.ICUGrade).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2010-04-06
/// Description:  根据ID取ICU病人等级
/// Table：       DHCMed.CC.ItemCat
/// Input：       id: DHCMed.INF.ICUGrade.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.ICUGrade).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2011-03-21
/// Description:  更新监控项目大类
/// Table：       DHCMed.INF.ICUGrade
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:CtlocDr 3:Year 4:Month 
/// 5:WeekOneA 6:WeekTwoA 7:WeekThreeA 8:WeekFourA
/// 9:WeekOneB 10:WeekTwoB 11:WeekThreeB 12:WeekFourB
/// 13:WeekOneC 14:WeekTwoC 15:WeekThreeC 16:WeekFourC
/// 17:WeekOneD 18:WeekTwoD 19:WeekThreeD 20:WeekFourD
/// 21:WeekOneE 22:WeekTwoE 23:WeekThreeE 24:WeekFourE
/// 25:RepUser 26:RepDate
ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	s ^LYH=InStr
	set id=0
	set ID=$p(InStr,"^",1)	
	if ID="" {
		set obj=##class(DHCMed.INF.ICUGrade).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.ICUGrade).%OpenId(ID)
		}
	set obj.CtlocDr=$p(InStr,"^",2)
	set obj.Year=$p(InStr,"^",3)
	set obj.Month=$p(InStr,"^",4)
	set obj.WeekOneA=$p(InStr,"^",5)
	set obj.WeekTwoA=$p(InStr,"^",6)
	set obj.WeekThreeA=$p(InStr,"^",7)
	set obj.WeekFourA=$p(InStr,"^",8)
	set obj.WeekOneB=$p(InStr,"^",9)
	set obj.WeekTwoB=$p(InStr,"^",10)
	set obj.WeekThreeB=$p(InStr,"^",11)
	set obj.WeekFourB=$p(InStr,"^",12)
	set obj.WeekOneC=$p(InStr,"^",13)
	set obj.WeekTwoC=$p(InStr,"^",14)
	set obj.WeekThreeC=$p(InStr,"^",15)
	set obj.WeekFourC=$p(InStr,"^",16)
	set obj.WeekOneD=$p(InStr,"^",17)
	set obj.WeekTwoD=$p(InStr,"^",18)
	set obj.WeekThreeD=$p(InStr,"^",19)
	set obj.WeekFourD=$p(InStr,"^",20)
	set obj.WeekOneE=$p(InStr,"^",21)
	set obj.WeekTwoE=$p(InStr,"^",22)
	set obj.WeekThreeE=$p(InStr,"^",23)
	set obj.WeekFourE=$p(InStr,"^",24)
	set obj.RepUser=$p(InStr,"^",25)
	set obj.RepDate=$p(InStr,"^",26)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

/// Creator：     liuyh
/// CreatDate：   2011-03-21
/// Description:  删除ICU病人等级
/// Table：       DHCMed.CC.ItemCat
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.INF.ICUGrade).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// 判断该科室、年份、月份 是否已报告数据
/// ret=1 已报告
/// ret=-1 未报告
/// w ##class(DHCMed.INF.ICUGrade).IsYearIndex(1,2011,1)
ClassMethod IsYearIndex(ctloc As %String, year As %String, month As %String) As %String
{
	n (ctloc,year,month)
	s ret=-1
	s:$d(^DHCMed.INF.ICUGradeI("YearIndex"," "_year," "_month," "_ctloc)) ret=1
	q ret
}

Storage Default
{
<Data name="ICUGradeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CtlocDr</Value>
</Value>
<Value name="3">
<Value>ICUGrade</Value>
</Value>
<Value name="4">
<Value>Month</Value>
</Value>
<Value name="5">
<Value>RepDate</Value>
</Value>
<Value name="6">
<Value>RepUser</Value>
</Value>
<Value name="7">
<Value>WeekFour</Value>
</Value>
<Value name="8">
<Value>WeekOne</Value>
</Value>
<Value name="9">
<Value>WeekThree</Value>
</Value>
<Value name="10">
<Value>WeekTwo</Value>
</Value>
<Value name="11">
<Value>Year</Value>
</Value>
<Value name="12">
<Value>WeekFourA</Value>
</Value>
<Value name="13">
<Value>WeekFourB</Value>
</Value>
<Value name="14">
<Value>WeekFourC</Value>
</Value>
<Value name="15">
<Value>WeekFourD</Value>
</Value>
<Value name="16">
<Value>WeekFourE</Value>
</Value>
<Value name="17">
<Value>WeekOneA</Value>
</Value>
<Value name="18">
<Value>WeekOneB</Value>
</Value>
<Value name="19">
<Value>WeekOneC</Value>
</Value>
<Value name="20">
<Value>WeekOneD</Value>
</Value>
<Value name="21">
<Value>WeekOneE</Value>
</Value>
<Value name="22">
<Value>WeekThreeA</Value>
</Value>
<Value name="23">
<Value>WeekThreeB</Value>
</Value>
<Value name="24">
<Value>WeekThreeC</Value>
</Value>
<Value name="25">
<Value>WeekThreeD</Value>
</Value>
<Value name="26">
<Value>WeekThreeE</Value>
</Value>
<Value name="27">
<Value>WeekTwoA</Value>
</Value>
<Value name="28">
<Value>WeekTwoB</Value>
</Value>
<Value name="29">
<Value>WeekTwoC</Value>
</Value>
<Value name="30">
<Value>WeekTwoD</Value>
</Value>
<Value name="31">
<Value>WeekTwoE</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.ICUGradeD</DataLocation>
<DefaultData>ICUGradeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.ICUGradeD</IdLocation>
<IndexLocation>^DHCMed.INF.ICUGradeI</IndexLocation>
<StreamLocation>^DHCMed.INF.ICUGradeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
