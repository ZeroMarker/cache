/// 名称: DHCMed.INF.RepInfoRel
/// 描述: 医政管理 感染报告 附加项目关联信息
/// 编写者：ChenJB
/// 编写日期: 2010-05-17
Class DHCMed.INF.RepInfoRel Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// 关联类型A   Lab Aricm Opr
Property TypeA As %String;

/// A Rowid
Property Arowid As %String;

/// 关联类型B   Lab Aricm Opr
Property TypeB As %String;

/// B Rowid
Property Browid As %String;

/// 报告类型 父子索引
Index TypeAB On (TypeA, Arowid, TypeB, Browid) [ Unique ];

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.RepInfoRel
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: InfRepDr 3: ItemsDr 4: ItemsValue 
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..TypeA_separete
	set return=return_..Arowid_separete
	set return=return_..TypeB_separete
	set return=return_..Browid_separete
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告 附加项目关联信息
/// Table：       DHCMed.INF.RepInfoRel
/// Input：       ID:    DHCMed.INF.RepInfoRel.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.RepInfoRel).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.RepInfoRel
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.RepInfoRel).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.RepInfoRel).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告 附加项目关联信息
/// Table：       DHCMed.INF.RepInfoRel
/// Input：       ID:    DHCMed.INF.RepInfoRel.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.RepInfoRel).GetStringById(1)
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
/// Description:  更新感染报告 附加项目关联信息
/// Table：       DHCMed.INF.RepInfoRel
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: InfRepDr 3: ItemsDr 4: ItemsValue 
ClassMethod Update(InStr As %String, separete As %String) As %String
{
 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.RepInfoRel).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.RepInfoRel).%OpenId(ID)
		}
	
	set obj.TypeA=$p(InStr,separete,2)
	set obj.Arowid=$p(InStr,separete,3)
	set obj.TypeB=$p(InStr,separete,4)
	set obj.Browid=$p(InStr,separete,5)
	
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
/// Description:  删除感染报告 附加项目关联信息
/// Table：       DHCMed.INF.RepInfoRel
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.RepInfoRel).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  删除感染报告 附加项目关联信息
/// Table：       DHCMed.INF.RepInfoRel
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteByTypeA(TypeA, Arowid, TypeB)
{
	new (TypeA,Arowid,TypeB)
	s ret=-1
	q:(TypeA="")!(Arowid="")!(TypeB="") ret
	s TypeAIdx=" "_$zcvt(TypeA,"U")
	s ArowidIdx=" "_$zcvt(Arowid,"U")
	s TypeBIdx=" "_$zcvt(TypeB,"U")
	s Browid=""
	f  s Browid=$o(^DHCMed.INF.RepInfoRelI("TypeAB",TypeAIdx,ArowidIdx,TypeBIdx,Browid)) q:Browid=""  d
	.s rowid=""
	.f  s rowid=$o(^DHCMed.INF.RepInfoRelI("TypeAB",TypeAIdx,ArowidIdx,TypeBIdx,Browid,rowid)) q:rowid=""  d
	..s ret=..DeleteById(rowid)
	quit ret
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  删除感染报告 附加项目关联信息
/// Table：       DHCMed.INF.RepInfoRel
/// Input：       Id
/// Return：      成功：返回1，失败：返回<0的代码
ClassMethod HaveRel(TypeA, Arowid, TypeB, Browid) As %String
{
	new (TypeA,Arowid,TypeB,Browid)
	s ret=-1
	q:(TypeA="")!(Arowid="")!(TypeB="")!(Browid="") ret
	s TypeAIdx=" "_$zcvt(TypeA,"U")
	s ArowidIdx=" "_$zcvt(Arowid,"U")
	s TypeBIdx=" "_$zcvt(TypeB,"U")
	s BrowidIdx=" "_$zcvt(Browid,"U")
	s:$d(^DHCMed.INF.RepInfoRelI("TypeAB",TypeAIdx,ArowidIdx,TypeBIdx,BrowidIdx)) ret=1
	quit ret
}

Storage Default
{
<Data name="RepInfoRelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Arowid</Value>
</Value>
<Value name="3">
<Value>Browid</Value>
</Value>
<Value name="4">
<Value>TypeA</Value>
</Value>
<Value name="5">
<Value>TypeB</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.RepInfoRelD</DataLocation>
<DefaultData>RepInfoRelDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.RepInfoRelD</IdLocation>
<IndexLocation>^DHCMed.INF.RepInfoRelI</IndexLocation>
<StreamLocation>^DHCMed.INF.RepInfoRelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
