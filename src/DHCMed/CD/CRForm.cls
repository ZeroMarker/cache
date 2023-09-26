/// 名称: DHCMed.CD.CRForm
/// 描述: 慢病设置
/// 编写者：zhufei
/// 编写日期: 2014-03-24
Class DHCMed.CD.CRForm Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 慢病代码
Property CRFCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CRFCode ];

/// 慢病名称
Property CRFDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CRFDesc ];

/// (作废)关联表单
Property FormCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = FormCode ];

/// 是否有效
Property IsActive As %Boolean [ SqlColumnNumber = 5, SqlFieldName = IsActive ];

/// 备注
Property Resume As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = Resume ];

Index IndexCode On CRFCode [ Unique ];

/// Creator：     zhufei		
/// CreatDate：   2014-03-24
/// Description:  根据ID取慢病设置
/// Table：       DHCMed.CD.CRForm
/// Input：       ID:    DHCMed.CD.CRForm.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRForm).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CD.CRForm
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CD.CRForm).%ExistsId(+id) return
	set obj=##Class(DHCMed.CD.CRForm).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-03-24
/// Description:  更新慢病设置
/// Table：       DHCMed.CD.CRForm
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.CD.CRForm).Update("^ZLK^肿瘤卡^^1^备注","^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set:$g(separete)="" separete=..#SEPARATE
	set ID          = $p(InStr,separete,1)
	set CRFCode    = $p(InStr,separete,2)
	set CRFDesc    = $p(InStr,separete,3)
	set FormCode   = $p(InStr,separete,4)
	set IsActive    = $p(InStr,separete,5)
	set Resume      = $p(InStr,separete,6)
	quit:(CRFCode="")||(CRFDesc="") return
	
	Set tID=$o(^DHCMed.CD.CRFormI("IndexCode"," "_$ZCVT(CRFCode,"U"),0))
	Quit:((ID="")&&(tID'="")) -2
	
	if ID="" {
		set obj=##class(DHCMed.CD.CRForm).%New()
	}else{
		set obj=##class(DHCMed.CD.CRForm).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.CRFCode    = CRFCode
	set obj.CRFDesc    = CRFDesc
	set obj.FormCode   = FormCode
	set obj.IsActive   = IsActive
	set obj.Resume     = Resume
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=obj.%Id()
	}
	do obj.%Close()
	
	quit return
}

/// Creator：     zhouruimeng
/// CreatDate：   2015-08-21
/// Description:  根据Code 取慢病的记录
/// Table：       DHCMed.CD.CRForm
/// Input：       Code
/// Return：      Obj:DHCMed.CD.CRForm
ClassMethod GetObjByCode(Code As %String) As DHCMed.CD.CRForm
{
	New (Code)
	Set return=""
	
	Set ID=$o(^DHCMed.CD.CRFormI("IndexCode"," "_$ZCVT(Code,"U"),0))
	Set obj=..GetObjById(+ID)
	Quit:'$IsObject(obj) return
	
	Set return=obj
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-03-24
/// Description:  删除慢病设置
/// Table：       DHCMed.CD.CRForm
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.CD.CRForm).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set ret=-1
	}else{
		set ret=0
	}
	quit ret
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CRFCode</Value>
</Value>
<Value name="3">
<Value>CRFDesc</Value>
</Value>
<Value name="4">
<Value>FormCode</Value>
</Value>
<Value name="5">
<Value>IsActive</Value>
</Value>
<Value name="6">
<Value>Resume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CD.CRFormD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CD.CRFormD</IdLocation>
<IndexLocation>^DHCMed.CD.CRFormI</IndexLocation>
<StreamLocation>^DHCMed.CD.CRFormS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
