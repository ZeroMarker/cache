/// 名称: DHCMed.NINF.BC.LocGroup
/// 描述: 疑似病例筛查 科室分组
/// 编写者：zhufei
/// 编写日期: 2013-12-03
Class DHCMed.NINF.BC.LocGroup Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 科室代码(CT_Loc.ID)
Property LGDeptCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = LG_DeptCode ];

/// 科室描述
Property LGDeptDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = LG_DeptDesc ];

/// 医院代码(CT_Hospital.ID)
Property LGHospCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = LG_HospCode ];

/// 医院名称
Property LGHospDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = LG_HospDesc ];

/// 科室/病区（E/W）
Property LGLocType As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = LG_LocType ];

/// 科室组
Property LGLocGroup As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = LG_LocGroup ];

/// ICU科室标记(ICU/NICU)
Property LGICUFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = LG_ICUFlag ];

/// 手术科室标记(OP)
Property LGOperFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = LG_OperFlag ];

/// 备注
Property LGResume As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = LG_Resume ];

/// 科室类型+科室代码 索引
Index IndexTypeCode On (LGLocType As Exact, LGDeptCode As Exact);

/// 科室代码 索引
Index IndexDeptCode On LGDeptCode As Exact;

/// Creator：     zhufei
/// CreatDate：   2013-12-03
/// Description:  根据ID取科室分组
/// Table：       DHCMed.NINF.BC.LocGroup
/// Input：       ID:    DHCMed.NINF.BC.LocGroup.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.NINF.BC.LocGroup).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.NINF.BC.LocGroup
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.BC.LocGroup).%ExistsId(+id) return
	set obj=##Class(DHCMed.NINF.BC.LocGroup).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-12-03
/// Description:  更新科室分组
/// Table：       DHCMed.NINF.BC.LocGroup
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.NINF.BC.LocGroup).Update("^9^内三科^E^内科^^^","^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set:$g(separete)="" separete=..#SEPARATE
	set ID       = $p(InStr,separete,1)
	set DeptCode = $p(InStr,separete,2)
	set DeptDesc = $p(InStr,separete,3)
	set HospCode = $p(InStr,separete,4)
	set HospDesc = $p(InStr,separete,5)
	set LocType  = $p(InStr,separete,6)
	set LocGroup = $p(InStr,separete,7)
	set ICUFlag  = $p(InStr,separete,8)
	set OperFlag = $p(InStr,separete,9)
	set Resume   = $p(InStr,separete,10)
	quit:(LocType="")||(DeptCode="") return
	
	//数据唯一性判断
	set tmpID=$o(^DHCMed.NINF.BC.LocGroupI("IndexTypeCode"," "_$zcvt(LocType,"U")," "_$zcvt(DeptCode,"U"),0))
	quit:(ID'="")&&((tmpID'=ID)&&(tmpID'="")) return
	set:tmpID'="" ID=tmpID
	
	if ID="" {
		set obj=##class(DHCMed.NINF.BC.LocGroup).%New()
	}else{
		set obj=##class(DHCMed.NINF.BC.LocGroup).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.LGDeptCode = DeptCode
	set obj.LGDeptDesc = DeptDesc
	set obj.LGHospCode = HospCode
	set obj.LGHospDesc = HospDesc
	set obj.LGLocType  = LocType
	set obj.LGLocGroup = LocGroup
	set obj.LGICUFlag  = ICUFlag
	set obj.LGOperFlag = OperFlag
	set obj.LGResume   = Resume
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
/// CreatDate：   2013-12-03
/// Description:  删除科室分组
/// Table：       DHCMed.NINF.BC.LocGroup
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.NINF.BC.LocGroup).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set ret=-1
	}else{
		set ret=0
	}
	quit ret
}

/// Creator：     zhufei
/// CreatDate：   2013-12-03
/// Description:  根据科室类型+科室ID取科室分组
/// Table：       DHCMed.NINF.BC.LocGroup
/// Input：       科室类型 LocType  E/W
///               科室ID   LocID
/// Return：      返回科室分组
/// w ##class(DHCMed.NINF.BC.LocGroup).GetLocGrpByLocID(1)
ClassMethod GetLocGrpByLocID(aLocType As %String, aLocID As %String) As %String
{
	new (aLocType,aLocID)
	set return="其他科"
	quit:(aLocType="")||(aLocID="") return
	
	set ID=$o(^DHCMed.NINF.BC.LocGroupI("IndexDeptCode",aLocID,0))
	quit:ID="" return
	set obj=##class(DHCMed.NINF.BC.LocGroup).GetObjById(ID)
	quit:'$IsObject(obj) return
	set return=obj.LGLocGroup
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LGDeptCode</Value>
</Value>
<Value name="3">
<Value>LGDeptDesc</Value>
</Value>
<Value name="4">
<Value>LGHospCode</Value>
</Value>
<Value name="5">
<Value>LGHospDesc</Value>
</Value>
<Value name="6">
<Value>LGLocType</Value>
</Value>
<Value name="7">
<Value>LGLocGroup</Value>
</Value>
<Value name="8">
<Value>LGICUFlag</Value>
</Value>
<Value name="9">
<Value>LGOperFlag</Value>
</Value>
<Value name="10">
<Value>LGResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.BC.LocGroupD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.BC.LocGroupD</IdLocation>
<IndexLocation>^DHCMed.NINF.BC.LocGroupI</IndexLocation>
<StreamLocation>^DHCMed.NINF.BC.LocGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
