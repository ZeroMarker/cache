Class web.Test2 Extends %Persistent
{

ClassMethod CreateTable() As %Integer
{
 &sql(CREATE TABLE TEST.EMPLOYEE (
    EMPNUM              INT NOT NULL,
    NAMELAST            CHAR (30) NOT NULL,
    NAMEFIRST           CHAR (30) NOT NULL,
    STARTDATE           TIMESTAMP,
    SALARY              MONEY,
    ACCRUEDVACATION     INT,
    ACCRUEDSICKLEAVE    INT,
    CONSTRAINT EMPLOYEEPK PRIMARY KEY (EMPNUM)))
        
 Write "SQL: ",SQLCODE,!
 QUIT SQLCODE
}

Storage Default
{
<Data name="Test2DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.Test2D</DataLocation>
<DefaultData>Test2DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.Test2D</IdLocation>
<IndexLocation>^web.Test2I</IndexLocation>
<StreamLocation>^web.Test2S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
