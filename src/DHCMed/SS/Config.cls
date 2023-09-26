/// 名称: DHCMed.SS.Config
/// 描述: 医政管理配置项目表
/// 编写者：wuqk
/// 编写日期: 2010-04-02
Class DHCMed.SS.Config Extends (%Persistent, DHCMed.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 键
Property Keys As %String(TRUNCATE = 1) [ Required ];

/// 描述
Property Description As %String(TRUNCATE = 1) [ Required ];

/// 值
Property Val As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 值说明
Property ValueDesc As %String(TRUNCATE = 1);

/// 使用产品   指向 DHCMed.SS.Products
Property ProductDr As %Integer;

/// 医院       指向 CT_Hospital
Property HospitalDr As %Integer;

/// 备注
Property Resume As %String(TRUNCATE = 1);

Index IndexKeyHosp On (Keys, HospitalDr) [ Unique ];

/// Creator：     wuqk
/// CreatDate：   2010-03-24
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.SS.Config
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:Keys 3:Description 4:Val 5:ValueDesc 6:ProductDr 7:HospitalDr 8:Resume
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..Keys_separete
	set return=return_..Description_separete
	set return=return_..Val_separete
	set return=return_..ValueDesc_separete
	set return=return_..ProductDr_separete
	set return=return_..HospitalDr_separete
	set return=return_..Resume
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-04-06
/// Description:  根据ID取配置信息
/// Table：       DHCMed.SS.Config
/// Input：       ID:    DHCMed.SS.Config.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.SS.Config).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.SS.Config
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.SS.Config).%ExistsId(+id) return
	set obj=##Class(DHCMed.SS.Config).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-04-06
/// Description:  根据ID取配置信息
/// Table：       DHCMed.SS.Config
/// Input：       ID:    DHCMed.SS.Config.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.SS.Config).GetStringById(1)
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

/// Creator：     wuqk
/// CreatDate：   2010-03-24
/// Description:  更新Menu
/// Table：       DHCMed.SS.Config
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:Keys 3:Description 4:Val 5:ValueDesc 6:ProductDr 7:HospitalDr 8:Resume
/// w ##Class(DHCMed.SS.Config).Update("48^INFHDMResDate^横断面调查日期,调查当天必须先初始化对象数据^^^14^0^^","^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set id=0
	set ID=$p(InStr,separete,1)
	
	Set Keys=$p(InStr,separete,2)
	Set HospitalID=$p(InStr,separete,7)
	
	if ID="" {
		set obj=##class(DHCMed.SS.Config).%New()
		} 
	else {
		set obj=##class(DHCMed.SS.Config).%OpenId(ID)
		}
	set obj.Keys=$p(InStr,separete,2)
	set obj.Description=$p(InStr,separete,3)
	set obj.Val=$p(InStr,separete,4)
	set obj.ValueDesc=$p(InStr,separete,5)
	set obj.ProductDr=+$p(InStr,separete,6)
	set obj.HospitalDr=+$p(InStr,separete,7)
	set obj.Resume=$p(InStr,separete,8)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		//d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

/// Creator：     wuqk
/// CreatDate：   2010-03-24
/// Description:  删除配置
/// Table：       DHCMed.SS.Config
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMed.SS.Config")
	Quit:Flg'=1 -777
	set sc = ##class(DHCMed.SS.Config).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// Creator：     zhufei
/// CreatDate：   2013-02-20
/// Description:  通过代码取基础配置值
/// Table：       DHCMed.SS.Config
/// Input：       Key,HospID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##Class(DHCMed.SS.Config).GetValueByKeyHosp("NINFWebServerAddress","")
ClassMethod GetValueByKeyHosp(aKey As %String, aHospID As %String) As %String
{
	new (aKey,aHospID)
	set return=""
	quit:aKey="" return
	
	set aHospID=+$g(aHospID)
	set ID=$o(^DHCMed.SS.ConfigI("IndexKeyHosp"," "_$ZCVT(aKey,"U"),aHospID,0))
	set obj=##class(DHCMed.SS.Config).GetObjById(ID)
	quit:'$IsObject(obj) return
	set return=obj.Val
	
	quit return
}

Storage Default
{
<Data name="ConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Keys</Value>
</Value>
<Value name="3">
<Value>Val</Value>
</Value>
<Value name="4">
<Value>HospitalDr</Value>
</Value>
<Value name="5">
<Value>ProductDr</Value>
</Value>
<Value name="6">
<Value>Resume</Value>
</Value>
<Value name="7">
<Value>ValueDesc</Value>
</Value>
<Value name="8">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^DHCMed.SS.ConfigD</DataLocation>
<DefaultData>ConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.SS.ConfigD</IdLocation>
<IndexLocation>^DHCMed.SS.ConfigI</IndexLocation>
<StreamLocation>^DHCMed.SS.ConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
