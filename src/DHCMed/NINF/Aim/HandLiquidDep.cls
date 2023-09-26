Class DHCMed.NINF.Aim.HandLiquidDep Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 导入excel的指针
Property ImportDR As %String(TRUNCATE = 1) [ Required ];

/// 部门编码
Property DepCode As %String(TRUNCATE = 1);

/// 科室名称
Property LocDesc As %String(TRUNCATE = 1);

Index IndexOfImportDR On ImportDR;

ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	set id=0
	set ID=$p(InStr,"^",1)	
	if ID="" {
		set obj=##class(DHCMed.NINF.Aim.HandLiquidDep).%New()
		} 
	else {
		set obj=##class(DHCMed.NINF.Aim.HandLiquidDep).%OpenId(ID)
		}
	set obj.ImportDR= $p(InStr,"^",2)
	set obj.DepCode  = $p(InStr,"^",3)
	set obj.LocDesc = $p(InStr,"^",4)
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

ClassMethod GetObjById(id As %String) As DHCMed.NINF.Aim.HandLiquidDep
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.Aim.HandLiquidDep).%ExistsId(+id) return
	set obj=##Class(DHCMed.NINF.Aim.HandLiquidDep).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

Storage Default
{
<Data name="HandLiquidDepDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DepCode</Value>
</Value>
<Value name="3">
<Value>ImportDR</Value>
</Value>
<Value name="4">
<Value>LocDesc</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.Aim.HandLiquidDepD</DataLocation>
<DefaultData>HandLiquidDepDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.Aim.HandLiquidDepD</IdLocation>
<IndexLocation>^DHCMed.NINF.Aim.HandLiquidDepI</IndexLocation>
<StreamLocation>^DHCMed.NINF.Aim.HandLiquidDepS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
