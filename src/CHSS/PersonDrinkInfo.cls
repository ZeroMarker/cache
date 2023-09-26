Class CHSS.PersonDrinkInfo Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = DrinkRowId, SqlTableName = PersonDrinkInfo ]
{

//个人健康相关ID

Property RelateROWID As CHSS.PersonLifeStyle;

//饮酒类别

Property DrinkType As %String(MAXLEN = 80, TRUNCATE = 1);

//年喝酒（月/年）

Property YearDrink As %Numeric;

//月喝酒（次/月）

Property TimesOfMonth As %Numeric;

//喝酒量（量/次）

Property QuanityOfDrink As %Numeric;

Index RelateIndex On RelateROWID;

Storage Default
{
<Data name="PersonDrinkInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DrinkType</Value>
</Value>
<Value name="3">
<Value>QuanityOfDrink</Value>
</Value>
<Value name="4">
<Value>RelateROWID</Value>
</Value>
<Value name="5">
<Value>TimesOfMonth</Value>
</Value>
<Value name="6">
<Value>YearDrink</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonDrinkInfoD</DataLocation>
<DefaultData>PersonDrinkInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonDrinkInfoD</IdLocation>
<IndexLocation>^CHSS.PersonDrinkInfoI</IndexLocation>
<StreamLocation>^CHSS.PersonDrinkInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
