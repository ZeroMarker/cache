<?xml version="1.0" encoding="UTF-8"?>
<Export generator="Cache" version="24" zv="Cache for Windows (x86-64) 2010.2.8 (Build 1104U)" ts="2016-05-03 09:09:05">
<Class name="dhc.bonus.data.EmpBonusPay">
<Description>
人员奖金发放表</Description>
<ClassType>persistent</ClassType>
<ProcedureBlock>0</ProcedureBlock>
<SqlRowIdName>EmpBonusPayID</SqlRowIdName>
<Super>%Persistent</Super>
<TimeChanged>64034,41304.893864</TimeChanged>
<TimeCreated>64034,40964.903864</TimeCreated>

<Property name="EmpCode">
<Description>
人员工号</Description>
<Type>%Library.String</Type>
<SqlColumnNumber>2</SqlColumnNumber>
<Parameter name="COLLATION" value="Exact"/>
<Parameter name="MAXLEN" value="30"/>
<Parameter name="TRUNCATE" value="0"/>
</Property>

<Property name="EmpName">
<Description>
人员项目</Description>
<Type>%Library.String</Type>
<SqlColumnNumber>3</SqlColumnNumber>
<Parameter name="COLLATION" value="Exact"/>
<Parameter name="MAXLEN" value="30"/>
<Parameter name="TRUNCATE" value="0"/>
</Property>

<Property name="EmpUnitID">
<Description>
所属科室</Description>
<Type>dhc.bonus.data.BonusUnit</Type>
<SqlColumnNumber>4</SqlColumnNumber>
</Property>

<Property name="PayUnitID">
<Description>
发放科室</Description>
<Type>dhc.bonus.data.BonusUnit</Type>
<SqlColumnNumber>5</SqlColumnNumber>
</Property>

<Property name="BonusYear">
<Description>
发放年份</Description>
<Type>%Library.String</Type>
<SqlColumnNumber>6</SqlColumnNumber>
<Parameter name="COLLATION" value="Exact"/>
<Parameter name="MAXLEN" value="30"/>
<Parameter name="TRUNCATE" value="0"/>
</Property>

<Property name="BonusPeriod">
<Description>
发放月份</Description>
<Type>%Library.String</Type>
<SqlColumnNumber>7</SqlColumnNumber>
<Parameter name="COLLATION" value="Exact"/>
<Parameter name="MAXLEN" value="30"/>
<Parameter name="TRUNCATE" value="0"/>
</Property>

<Property name="DataType">
<Description>
奖金类型</Description>
<Type>%Library.String</Type>
<SqlColumnNumber>8</SqlColumnNumber>
<Parameter name="COLLATION" value="Exact"/>
<Parameter name="MAXLEN" value="30"/>
<Parameter name="TRUNCATE" value="0"/>
</Property>

<Property name="DataValue">
<Description>
奖金金额</Description>
<Type>%Library.Float</Type>
<SqlColumnNumber>9</SqlColumnNumber>
</Property>

<Property name="UpdateDate">
<Description>
更新日期</Description>
<Type>%Library.String</Type>
<SqlColumnNumber>10</SqlColumnNumber>
</Property>

<Storage name="Default">
<Type>%Library.CacheStorage</Type>
<DataLocation>^dhcbsEmpBonusPayD</DataLocation>
<DefaultData>EmpBonusPayDefaultData</DefaultData>
<IdLocation>^dhcbsEmpBonusPayD</IdLocation>
<IndexLocation>^dhcbsEmpBonusPayI</IndexLocation>
<StreamLocation>^dhcbsEmpBonusPayS</StreamLocation>
<Data name="EmpBonusPayDefaultData">
<Structure>listnode</Structure>
<Subscript/>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EmpCode</Value>
</Value>
<Value name="3">
<Value>EmpName</Value>
</Value>
<Value name="4">
<Value>EmpUnitID</Value>
</Value>
<Value name="5">
<Value>PayUnitID</Value>
</Value>
<Value name="6">
<Value>BonusYear</Value>
</Value>
<Value name="7">
<Value>BonusPeriod</Value>
</Value>
<Value name="8">
<Value>DataType</Value>
</Value>
<Value name="9">
<Value>DataValue</Value>
</Value>
<Value name="10">
<Value>UpdateDate</Value>
</Value>
</Data>
</Storage>
</Class>
</Export>
