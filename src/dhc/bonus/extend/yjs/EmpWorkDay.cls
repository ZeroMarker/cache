/// 人事考勤信息 来源 HISHR.TimeLeaveInfo
Class dhc.bonus.extend.yjs.EmpWorkDay Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = EmpWorkDayID ]
{

Index BonusYearInx On BonusYear As Exact;

Index BonusPeriodInx On BonusPeriod As Exact;

Index DeptCodeInx On DeptCode As Exact;

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property DeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property EmpCardID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Property EmpName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

//来源 HISHR.TimeLeaveInfo 的  LeaveDays

Property WorkDays As %Library.Float [ SqlColumnNumber = 7 ];

//来源 HISHR.PersonInfo 的 FlexStrField6

Property SharyRate As %Library.Float [ SqlColumnNumber = 8 ];

//系统时间

Property UpdateDate As %Library.TimeStamp [ SqlColumnNumber = 9 ];

//杭创代码

Property FlexStrField2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

//老代码

Property FlexStrField4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

//科室名称

Property DeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12 ];

Property IsCheck As %Library.Integer [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="EmpWorkDayDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusYear</Value>
</Value>
<Value name="3">
<Value>BonusPeriod</Value>
</Value>
<Value name="4">
<Value>DeptCode</Value>
</Value>
<Value name="5">
<Value>EmpCardID</Value>
</Value>
<Value name="6">
<Value>EmpName</Value>
</Value>
<Value name="7">
<Value>WorkDays</Value>
</Value>
<Value name="8">
<Value>SharyRate</Value>
</Value>
<Value name="9">
<Value>UpdateDate</Value>
</Value>
<Value name="10">
<Value>FlexStrField2</Value>
</Value>
<Value name="11">
<Value>FlexStrField4</Value>
</Value>
<Value name="12">
<Value>DeptName</Value>
</Value>
<Value name="13">
<Value>IsCheck</Value>
</Value>
</Data>
<DataLocation>^dhcbsEmpWorkDayD</DataLocation>
<DefaultData>EmpWorkDayDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsEmpWorkDayD</IdLocation>
<IndexLocation>^dhcbsEmpWorkDayI</IndexLocation>
<StreamLocation>^dhcbsEmpWorkDayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
