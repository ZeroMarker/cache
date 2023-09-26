/// 名称: DHCMed.INF.ICUInfo
/// 描述: 医政管理 感染报告 插管信息
/// 编写者：ChenJB
/// 编写日期: 2010-05-17
Class DHCMed.INF.ICUInfo Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// 感染报告
Property InfRepDr As %Integer [ Required ];

/// InfBeICULoc 上次 
Property InfBeICUCode As %String;

/// InBeICUDate
Property InBeICUDate As %Date;

/// InfICULoc 入ICU科别
Property InfICUCode As %String;

/// 入ICU日期
Property InICUDate As %Date;

/// 入ICU时间
Property InICUTime As %Time;

/// 由那个科室转入ICU CT_Loc
Property InICULoc As %Integer;

/// 转出ICU日期
Property OutICUDate As %Date;

/// 出ICU时间
Property OutICUTime As %Time;

/// 转出到科室 CT_Loc
Property OutICULoc As %Integer;

/// 出ICU是否带管
Property OutStatus As %String;

/// 24小时后是否带管 Y/N
Property OutHStatus As %String;

/// 带管类型
Property OutDeviceCode As %String;

/// 备注 -》其他症状
Property ResumeText As %String;

Index InfRepDr On InfRepDr;

/// Creator：     ChenJB
/// CreatDate：   2010-05-17
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.ICUInfo
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: InfRepDr 3: InfBeICUCode 4: InBeICUDate 5: InfICUCode 6: InICUDate 7: InICUTime 8: InICULoc 9: OutICUDate 
/// 10: OutICUTime 11: OutICULoc 12: OutStatus 13: OutHStatus 14 OutDeviceCode 15: ResumeText
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..InfRepDr_separete
	set return=return_..InfBeICUCode_separete
	set return=return_..InBeICUDate_separete
	set return=return_..InfICUCode_separete	
	set return=return_..InICUDate_separete
	set return=return_..InICUTime_separete
	set return=return_..InICULoc_separete
	set return=return_..OutICUDate_separete
	set return=return_..OutICUTime_separete
	set return=return_..OutICULoc_separete
	set return=return_..OutStatus_separete
	set return=return_..OutHStatus_separete
	set return=return_..OutDeviceCode_separete
	set return=return_..ResumeText
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-17
/// Description:  根据ID取感染报告 插管信息
/// Table：       DHCMed.INF.ICUInfo
/// Input：       ID:    DHCMed.INF.ICUInfo.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.ICUInfo).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.ICUInfo
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.ICUInfo).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.ICUInfo).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-17
/// Description:  根据ID取感染报告 插管信息
/// Table：       DHCMed.INF.ICUInfo
/// Input：       ID:    DHCMed.INF.ICUInfo.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.ICUInfo).GetStringById(1)
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
/// CreatDate：   2010-05-17
/// Description:  更新感染报告插管信息
/// Table：       DHCMed.INF.ICUInfo
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: InfRepDr 3: InfBeICUCode 4: InBeICUDate 5: InfICUCode 6: InICUDate 7: InICUTime 8: InICULoc 9: OutICUDate 
/// 10: OutICUTime 11: OutICULoc 12: OutStatus 13: OutHStatus 14 OutDeviceCode 15: ResumeText
ClassMethod Update(InStr As %String, separete As %String) As %String
{
 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.ICUInfo).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.ICUInfo).%OpenId(ID)
		}
	set obj.InfRepDr=$p(InStr,separete,2)
	set obj.InfBeICUCode=$p(InStr,separete,3)
	set BeICUDt=$p(InStr,separete,4)
	set:BeICUDt["-" BeICUDt=$zdh(BeICUDt,3)
	set:BeICUDt["/" BeICUDt=$zdh(BeICUDt,4)   //  14/05/2010
	set obj.InBeICUDate=BeICUDt
	set obj.InfICUCode=$p(InStr,separete,5)	
	set InICUDate=$p(InStr,separete,6)
	set InICUTime=$p(InStr,separete,7)
	set:InICUDate["-" InICUDate=$zdh(InICUDate,3)
	set:InICUDate["/" InICUDate=$zdh(InICUDate,4)   //  14/05/2010
	set:InICUTime[":" InICUTime=$zth(InICUTime,1)
	set obj.InICUDate=InICUDate                   //为空时用零默认时间日期值
	set obj.InICUTime=InICUTime
	set obj.InICULoc=$p(InStr,separete,8)
	set OutICUDate=$p(InStr,separete,9)
	set OutICUTime=$p(InStr,separete,10)
	set:OutICUDate["-" OutICUDate=$zdh(OutICUDate,3)
	set:OutICUDate["/" OutICUDate=$zdh(OutICUDate,4)   //  14/05/2010
	set:OutICUTime[":" OutICUTime=$zth(OutICUTime,1)
	set obj.OutICUDate=OutICUDate                   //为空时用零默认时间日期值
	set obj.OutICUTime=OutICUTime
	set obj.OutICULoc=$p(InStr,separete,11)
	set obj.OutStatus=$p(InStr,separete,12)
	set obj.OutHStatus=$p(InStr,separete,13)
	set obj.OutDeviceCode=$p(InStr,separete,14)
	set obj.ResumeText=$p(InStr,separete,15)
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
/// CreatDate：   2010-05-17
/// Description:  删除感染报告 插管
/// Table：       DHCMed.INF.ICUInfo
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.ICUInfo).%DeleteId(+Id)
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
<Data name="ICUInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CavityType</Value>
</Value>
<Value name="3">
<Value>DeviceType</Value>
</Value>
<Value name="4">
<Value>DoPipeDate</Value>
</Value>
<Value name="5">
<Value>DoPipeTime</Value>
</Value>
<Value name="6">
<Value>DoUserDr</Value>
</Value>
<Value name="7">
<Value>InICUDate</Value>
</Value>
<Value name="8">
<Value>InICULoc</Value>
</Value>
<Value name="9">
<Value>InICUTime</Value>
</Value>
<Value name="10">
<Value>InfRepDr</Value>
</Value>
<Value name="11">
<Value>InfectionDr</Value>
</Value>
<Value name="12">
<Value>OutHStatus</Value>
</Value>
<Value name="13">
<Value>OutICUDate</Value>
</Value>
<Value name="14">
<Value>OutICULoc</Value>
</Value>
<Value name="15">
<Value>OutICUTime</Value>
</Value>
<Value name="16">
<Value>OutStatus</Value>
</Value>
<Value name="17">
<Value>PartSyptom</Value>
</Value>
<Value name="18">
<Value>PipeBody</Value>
</Value>
<Value name="19">
<Value>PipePlace</Value>
</Value>
<Value name="20">
<Value>PipeType</Value>
</Value>
<Value name="21">
<Value>ResumeText</Value>
</Value>
<Value name="22">
<Value>UnPipeDate</Value>
</Value>
<Value name="23">
<Value>UnPipeTime</Value>
</Value>
<Value name="24">
<Value>WholeSyptom</Value>
</Value>
<Value name="25">
<Value>InBeICUDate</Value>
</Value>
<Value name="26">
<Value>InfBeICUCode</Value>
</Value>
<Value name="27">
<Value>InfICUCode</Value>
</Value>
<Value name="28">
<Value>OutDeviceCode</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.ICUInfoD</DataLocation>
<DefaultData>ICUInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.ICUInfoD</IdLocation>
<IndexLocation>^DHCMed.INF.ICUInfoI</IndexLocation>
<StreamLocation>^DHCMed.INF.ICUInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
