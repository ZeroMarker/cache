/// 名称: DHCMed.INF.ICUDeviceInfo
/// 描述: 医政管理 感染报告 插管信息
/// 编写者：ChenJB
/// 编写日期: 2010-05-17
Class DHCMed.INF.ICUDeviceInfo Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// InfRepICU
Property InfRepICU As %Integer [ Required ];

/// 设备类型 字典code 气道/呼吸机/中心静脉导管/尿道
Property DeviceType As %String;

/// 导管类型 气道(经鼻插管/经口插管/切口感染)中心静脉导管(PICC/抗感染/其他)
Property PipeType As %String;

/// 导管腔数 字典code 单腔/双腔/三腔/其他
Property CavityType As %String;

/// 操作部位 字典code 左肘上/中心静脉插管/锁骨下静脉/股静脉/左肘下/右肘上/右肘下
Property PipeBody As %String;

/// 置管地点 字典code 病房/手术室/急诊室/ICU/其他
Property PipePlace As %String;

/// 插管日期
Property DoPipeDate As %Date;

/// 插管时间
Property DoPipeTime As %Time;

/// 拔管日期
Property UnPipeDate As %Date;

/// 拔管时间
Property UnPipeTime As %Time;

/// 系统感染征兆 可考虑使用选择字典形式
Property WholeSyptom As %String;

/// 局部感染征兆
Property PartSyptom As %String;

/// UserType
Property UserType As %String;

/// 插管人
Property DoUserDr As %Integer;

/// 感染指向 DHC_Med.INF.RepPos
Property InfectionPos As %Integer;

Property ICUInfDate As %Date;

Property InfICUType As %String;

Index InfRepICU On InfRepICU;

/// Creator：     ChenJB
/// CreatDate：   2010-05-17
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.ICUDeviceInfo
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: InfRepICU
/// 3: DeviceType 4: PipeType 5: CavityType 6: PipeBody 7: PipePlace 8: DoPipeDate 9: DoPipeTime
/// 10: UnPipeDate 11: UnPipeTime 12: WholeSyptom 13: PartSyptom  14:UserType
/// 15: DoUserDr 16: InfectionPos 17: ICUInfDate 18: InfICUType
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..InfRepICU_separete
	set return=return_..DeviceType_separete
	set return=return_..PipeType_separete
	set return=return_..CavityType_separete
	set return=return_..PipeBody_separete
	set return=return_..PipePlace_separete
	set return=return_..DoPipeDate_separete
	set return=return_..DoPipeTime_separete
	set return=return_..UnPipeDate_separete
	set return=return_..UnPipeTime_separete
	set return=return_..WholeSyptom_separete
	set return=return_..PartSyptom_separete
	set return=return_..UserType_separete
	set return=return_..DoUserDr_separete
	set return=return_..InfectionPos_separete
	set return=return_..ICUInfDate_separete
	set return=return_..InfICUType
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-17
/// Description:  根据ID取感染报告 插管信息
/// Table：       DHCMed.INF.ICUDeviceInfo
/// Input：       ID:    DHCMed.INF.ICUDeviceInfo.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.ICUDeviceInfo).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.ICUDeviceInfo
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.ICUDeviceInfo).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.ICUDeviceInfo).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-17
/// Description:  根据ID取感染报告 插管信息
/// Table：       DHCMed.INF.ICUDeviceInfo
/// Input：       ID:    DHCMed.INF.ICUDeviceInfo.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.ICUDeviceInfo).GetStringById(1)
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
/// Table：       DHCMed.INF.ICUDeviceInfo
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: InfRepICU
/// 3: DeviceType 4: PipeType 5: CavityType 6: PipeBody 7: PipePlace 8: DoPipeDate 9: DoPipeTime
/// 10: UnPipeDate 11: UnPipeTime 12: WholeSyptom 13: PartSyptom  14:UserType
/// 15: DoUserDr 16: InfectionPos 17: ICUInfDate 18: InfICUType
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.ICUDeviceInfo).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.ICUDeviceInfo).%OpenId(ID)
		}
	set obj.InfRepICU=$p(InStr,separete,2)
	set obj.DeviceType=$p(InStr,separete,3)
	set obj.PipeType=$p(InStr,separete,4)
	set obj.CavityType=$p(InStr,separete,5)
	set obj.PipeBody=$p(InStr,separete,6)
	set obj.PipePlace=$p(InStr,separete,7)
	set DoPipeDate=$p(InStr,separete,8)
	set DoPipeTime=$p(InStr,separete,9)
	set:DoPipeDate["-" DoPipeDate=$zdh(DoPipeDate,3)
	set:DoPipeDate["/" DoPipeDate=$zdh(DoPipeDate,4)   //  14/05/2010
	set:DoPipeTime[":" DoPipeTime=$zth(DoPipeTime,1)
	set obj.DoPipeDate=DoPipeDate                   //为空时用零默认时间日期值
	set obj.DoPipeTime=DoPipeTime
	set UnPipeDate=$p(InStr,separete,10)
	set UnPipeTime=$p(InStr,separete,11)
	set:UnPipeDate["-" UnPipeDate=$zdh(UnPipeDate,3)
	set:UnPipeDate["/" UnPipeDate=$zdh(UnPipeDate,4)   //  14/05/2010
	set:UnPipeTime[":" UnPipeTime=$zth(UnPipeTime,1)
	set obj.UnPipeDate=UnPipeDate
	set obj.UnPipeTime=UnPipeTime
	set obj.WholeSyptom=$p(InStr,separete,12)
	set obj.PartSyptom=$p(InStr,separete,13)
	set obj.UserType=$p(InStr,separete,14)
	set obj.DoUserDr=$p(InStr,separete,15)
	set obj.InfectionPos=$p(InStr,separete,16)
    set ICUInfDate=$p(InStr,separete,17)
    set:ICUInfDate["-" ICUInfDate=$zdh(ICUInfDate,3)
	set:ICUInfDate["/" ICUInfDate=$zdh(ICUInfDate,4)   //  14/05/2010
	set obj.ICUInfDate=ICUInfDate
	set obj.InfICUType=$p(InStr,separete,18)
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
/// Table：       DHCMed.INF.ICUDeviceInfo
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.ICUDeviceInfo).%DeleteId(+Id)
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
<Data name="ICUDeviceInfoDefaultData">
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
<Value>ICUInfDate</Value>
</Value>
<Value name="8">
<Value>InfRepICU</Value>
</Value>
<Value name="9">
<Value>InfectionPos</Value>
</Value>
<Value name="10">
<Value>PartSyptom</Value>
</Value>
<Value name="11">
<Value>PipeBody</Value>
</Value>
<Value name="12">
<Value>PipePlace</Value>
</Value>
<Value name="13">
<Value>PipeType</Value>
</Value>
<Value name="14">
<Value>UnPipeDate</Value>
</Value>
<Value name="15">
<Value>UnPipeTime</Value>
</Value>
<Value name="16">
<Value>UserType</Value>
</Value>
<Value name="17">
<Value>WholeSyptom</Value>
</Value>
<Value name="18">
<Value>InfICUType</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.ICUDeviceInfoD</DataLocation>
<DefaultData>ICUDeviceInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.ICUDeviceInfoD</IdLocation>
<IndexLocation>^DHCMed.INF.ICUDeviceInfoI</IndexLocation>
<StreamLocation>^DHCMed.INF.ICUDeviceInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
