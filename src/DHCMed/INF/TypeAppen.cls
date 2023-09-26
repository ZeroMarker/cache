/// 名称: DHCMed.INF.TypeAppen
/// 描述: 医政管理 感染报告 报告类型与项目关联
/// 编写者：ChenJB
/// 编写日期: 2010-05-17
Class DHCMed.INF.TypeAppen Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// 报告类型 code
Property TypesDr As %String [ Required ];

/// 项目内容 指向DHCMed.INF.RepItem
Property ItemTypeDr As %Integer;

/// 是否必输 Y/N
Property IsRequired As %String;

/// 缺省值
Property DefaultValue As %String;

/// 位置
Property Positions As %Integer;

/// 是否有效
Property IsActive As %Boolean;

/// 给用户提示
Property ToolTip As %String;

/// 备注
Property ResumeText As %String;

/// 报告类型索引
Index TypesDrPos On (TypesDr, Positions);

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.TypeAppen
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: TypesDr 3: ItemTypeDr 4: IsRequired 5: DefaultValue 6: Positions 7: IsActive 
/// 8: ToolTip 9: ResumeText
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..TypesDr_separete
	set return=return_..ItemTypeDr_separete
	set return=return_..IsRequired_separete
	set return=return_..DefaultValue_separete
	set return=return_..Positions_separete
	set return=return_..IsActive_separete
	set return=return_..ToolTip_separete
	set return=return_..ResumeText
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告类型 与附加项目关联
/// Table：       DHCMed.INF.TypeAppen
/// Input：       ID:    DHCMed.INF.TypeAppen.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.TypeAppen).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.TypeAppen
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.TypeAppen).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.TypeAppen).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告类型 与附加项目关联
/// Table：       DHCMed.INF.TypeAppen
/// Input：       ID:    DHCMed.INF.TypeAppen.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.TypeAppen).GetStringById(1)
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

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  更新感染报告类型 与附加项目关联
/// Table：       DHCMed.INF.TypeAppen
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: TypesDr 3: ItemTypeDr 4: IsRequired 5: DefaultValue 6: Positions 7: IsActive 
/// 8: ToolTip 9: ResumeText
ClassMethod Update(InStr As %String, separete As %String) As %String
{
 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.TypeAppen).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.TypeAppen).%OpenId(ID)
		}
	set obj.TypesDr=$p(InStr,separete,2)
	set obj.ItemTypeDr=$p(InStr,separete,3)
	set obj.IsRequired=$p(InStr,separete,4)
	set obj.DefaultValue=$p(InStr,separete,5)
	set obj.Positions=+$p(InStr,separete,6)
	set obj.IsActive=$p(InStr,separete,7)
	set obj.ToolTip=$p(InStr,separete,8)
	set obj.ResumeText=$p(InStr,separete,9)
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

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  删除感染报告类型 与附加项目关联
/// Table：       DHCMed.INF.TypeAppen
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.TypeAppen).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

Storage Default
{
<Data name="TypeAppenDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DefaultValue</Value>
</Value>
<Value name="3">
<Value>IsActive</Value>
</Value>
<Value name="4">
<Value>IsRequired</Value>
</Value>
<Value name="5">
<Value>ItemTypeDr</Value>
</Value>
<Value name="6">
<Value>Positions</Value>
</Value>
<Value name="7">
<Value>ResumeText</Value>
</Value>
<Value name="8">
<Value>ToolTip</Value>
</Value>
<Value name="9">
<Value>TypesDr</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.TypeAppenD</DataLocation>
<DefaultData>TypeAppenDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.TypeAppenD</IdLocation>
<IndexLocation>^DHCMed.INF.TypeAppenI</IndexLocation>
<StreamLocation>^DHCMed.INF.TypeAppenS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
