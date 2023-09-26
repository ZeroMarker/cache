/// 名称 : DHCMed.DC.BTHospital
/// 说明 : 【系统字典】医院
Class DHCMed.DC.BTHospital Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码(与DHCMed_SS.Hospital.HospCode一致)
Property Code As %String(MAXLEN = 100, TRUNCATE = 1);

/// 名称
Property CName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 名称（全称）
Property FullDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 缩写码(与各个子系统医院代码对应)
Property SCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property Active As %Boolean;

Index IndexSCode On (SCode, Code) [ Unique ];

/// Creator：     zhufei
/// CreatDate：   2016-03-29
/// Description:  根据代码或缩写码取医院字典
/// Table：       DHCMed.DC.BTHospital
/// Input：       SCode : DHCMed.DC.BTHospital.SCode
/// Return：      返回String
/// w ##class(DHCMed.DC.BTHospital).GetIDBySCode("LIS01")
ClassMethod GetIDBySCode(aSCode As %String) As %String
{
	New (aSCode)
	Set return=""
	Quit:aSCode="" return
	
	Set xCode=""
	For {
		Set xCode=$o(^DHCMed.DC.BTHospitalI("IndexSCode"," "_$zcvt(aSCode,"U"),xCode))
		Quit:xCode=""
		
		Set xID=$o(^DHCMed.DC.BTHospitalI("IndexSCode"," "_$zcvt(aSCode,"U"),xCode,0))
		Continue:xID=""
		
		Set obj=..GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:obj.Active'=1
		
		Set return=return_","_xID
	}
	Set:return'="" return=$e(return,2,$l(return))
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  根据ID取医院字典
/// Table：       DHCMed.DC.BTHospital
/// Input：       ID:    DHCMed.DC.BTHospital.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.DC.BTHospital).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DC.BTHospital
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DC.BTHospital).%ExistsId(+id) return
	set obj=##Class(DHCMed.DC.BTHospital).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  更新医院字典
/// Table：       DHCMed.DC.BTHospital
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.DC.BTHospital).Update("^BEJING_AZ^BEIJINGANZHEN^BEIJINGANZHEN^HIS1^1")
ClassMethod Update(InStr As %String, separete As %String = "^") As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set ID       = $p(InStr,separete,1)
	set Code     = $p(InStr,separete,2)
	set CName    = $p(InStr,separete,3)
	set FullDesc = $p(InStr,separete,4)
	set SCode    = $p(InStr,separete,5)
	set Active   = +$p(InStr,separete,6)
	quit:(Code="")||(CName="")||(SCode="") return
	
	//字典代码唯一性
	set tID=$o(^DHCMed.DC.BTHospitalI("IndexSCode"," "_$zcvt(SCode,"U")," "_$zcvt(Code,"U"),0))
	quit:(ID'="")&&(tID'="")&&(ID'=tID) "-100"
	set:(ID="")&&(tID'="") ID=tID
	
	if ID="" {
		set obj=##class(DHCMed.DC.BTHospital).%New()
	}else{
		set obj=##class(DHCMed.DC.BTHospital).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.Code     = Code
	set obj.CName    = CName
	set obj.FullDesc = FullDesc
	set obj.SCode    = SCode
	set obj.Active   = Active
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

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  删除医院字典
/// Table：       DHCMed.DC.BTHospital
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.DC.BTHospital).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set ret=-1
	}else{
		set ret=0
	}
	quit ret
}

/// w ##Class(DHCMed.DC.BTHospital).Test()
ClassMethod Test()
{
	&SQL(insert into DHCMed_DC.BTHospital set Code='BJDT',CName='北京地坛医院',FullDesc='北京地坛医院',SCode='HIS01',Active=1)
	&SQL(insert into DHCMed_DC.BTHospital set Code='BJDT',CName='北京地坛医院',FullDesc='北京地坛医院',SCode='LIS01',Active=1)
	&SQL(insert into DHCMed_DC.BTHospital set Code='BJDT',CName='北京地坛医院',FullDesc='北京地坛医院',SCode='NIS01',Active=1)
	&SQL(insert into DHCMed_DC.BTHospital set Code='BJDT',CName='北京地坛医院',FullDesc='北京地坛医院',SCode='ORIS01',Active=1)
	&SQL(insert into DHCMed_DC.BTHospital set Code='BJDT',CName='北京地坛医院',FullDesc='北京地坛医院',SCode='RIS01',Active=1)
	&SQL(insert into DHCMed_DC.BTHospital set Code='BJDT',CName='北京地坛医院',FullDesc='北京地坛医院',SCode='HDIS01',Active=1)
	Quit "OK"
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>FullDesc</Value>
</Value>
<Value name="5">
<Value>SCode</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DC.BTHospitalD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DC.BTHospitalD</IdLocation>
<IndexLocation>^DHCMed.DC.BTHospitalI</IndexLocation>
<StreamLocation>^DHCMed.DC.BTHospitalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
