/// 创建者：李阳
/// 创建日期：2011-01-09
/// 重点患者进程事件
/// 
Class DHCMed.IMP.ImpEventProgress Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 重点患者ID
Property ImpPatientID As %Integer [ Required ];

Index ImpPatientIDIndex On ImpPatientID;

/// 类别
/// 字典代码
Property Category As %Integer [ Required ];

Index CategoryIndex On Category;

/// 进程记录内容
Property Contents As %String(MAXLEN = 500);

/// 生效
Property IsActive As %Boolean;

/// 花费时间（小时）
Property CostTime As %Double;

/// 花费金额
Property CostMoney As %Double;

/// 记录日期
Property RecordDate As %Date;

/// 记录时间
Property RecordTime As %Time;

/// 记录人
Property RecordUser As %Integer;

/// 备注
Property ResumeText As %String(MAXLEN = 500);

/// 事件标题
Property Title As %String(MAXLEN = 500);

/// 事件发生日期
Property EventDate As %Date;

Index EventDateIndex On EventDate;

/// 事件时间
Property EventTime As %Time;

/// Add By LiYang 2011-12-21 承办人
Property DutyUser As %Integer;

/// Add By LiYang 2011-12-21 保密级别
Property SecretLevel As %Integer;

/// Add By LiYang 2011-12-21 花费类型 现金 支票 转账
Property CostMoneyType As %Integer;

ClassMethod GetObjById(ID As %String) As DHCMed.IMP.ImpEventProgress
{
	New (ID)
	Set obj=##Class(DHCMed.IMP.ImpEventProgress).%OpenId(ID)
	d obj.%Close()
	Quit obj
}

Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	} 
	set return=..%Id()_separete
	set return=return_obj.ImpPatientID_separete
	set return=return_obj.Category_separete
	set return=return_obj.Title_separete
	set return=return_obj.Contents_separete
	set return=return_obj.IsActive_separete
	set return=return_obj.CostTime_separete
	set return=return_obj.CostMoney_separete
	set return=return_obj.RecordUser_separete
	set return=return_$s(obj.RecordDate="":"",1:$zd(obj.RecordDate,3))_separete
	set return=return_$s(obj.RecordTime="":"",1:$zt(obj.RecordTime,1))_separete
	set return=return_obj.ResumeText_separete
	set return=return_$s(obj.EventDate="":"",1:$zd(obj.EventDate,3))_separete
	set return=return_$s(obj.EventTime="":"",1:$zt(obj.EventTime,2))_separete
	//Add By LiYang 2011-12-21
	set return=return_obj.DutyUser_separete
	set return=return_obj.SecretLevel_separete
	set return=return_obj.CostMoneyType_separete
	q return
}

/// Creator：     李阳
/// CreatDate：   2011-01-13
/// Description:  根据ID重点患者大类信息
/// Input：       id:    DHCMed.IMP.ImpEventProgress.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.Base.Patient).GetStringById(1)
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

/// Creator：     李阳
/// CreatDate：   2011-01-10
/// Description:  更新Menu
/// Table：       DHCMed.IMP.ImpEventProgress
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:Code 3:Description 4:Type 5:HospitalDr 6:Active 7:DateFrom 8:DateTo
/// d ##class(DHCMed.SS.Dictionary).Update("^42^目的^SYS^2^1^01/23/1841^01/23/1841",)
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.IMP.ImpEventProgress).%New()
		} 
	else {
		set obj=##class(DHCMed.IMP.ImpEventProgress).%OpenId(ID)
		}
	set obj.ImpPatientID=$p(InStr,separete,2)
	set obj.Category=$p(InStr,separete,3)
	set obj.Title=$p(InStr,separete,4)
	set obj.Contents=$p(InStr,separete,5)
	set obj.IsActive=+$p(InStr,separete,6)
	set obj.CostTime=$p(InStr,separete,7)
	set obj.CostMoney=$p(InStr,separete,8)
	set obj.RecordUser=$p(InStr,separete,9)
	set obj.RecordDate=+$h
	set obj.RecordTime=$p($h,",",2)
	set obj.ResumeText=$p(InStr,separete,12)
	set:$p(InStr,separete,13)["-" obj.EventDate=$zdh($p(InStr,separete,13),3)
	set:$p(InStr,separete,14)[":" obj.EventTime=$zth($p(InStr,separete,14),1)
	//Add By LiYang 2011-12-21
	set obj.DutyUser=$p(InStr,separete,15)
	set obj.SecretLevel=$p(InStr,separete,16)
	set obj.CostMoneyType=$p(InStr,separete,17)
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

Storage Default
{
<Data name="ImpEventProgressDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Category</Value>
</Value>
<Value name="3">
<Value>Contents</Value>
</Value>
<Value name="4">
<Value>CostMoney</Value>
</Value>
<Value name="5">
<Value>CostTime</Value>
</Value>
<Value name="6">
<Value>ImpPatientID</Value>
</Value>
<Value name="7">
<Value>IsActive</Value>
</Value>
<Value name="8">
<Value>RecordDate</Value>
</Value>
<Value name="9">
<Value>RecordTime</Value>
</Value>
<Value name="10">
<Value>RecordUser</Value>
</Value>
<Value name="11">
<Value>ResumeText</Value>
</Value>
<Value name="12">
<Value>Title</Value>
</Value>
<Value name="13">
<Value>EventDate</Value>
</Value>
<Value name="14">
<Value>EventTime</Value>
</Value>
<Value name="15">
<Value>CostMoneyType</Value>
</Value>
<Value name="16">
<Value>DutyUser</Value>
</Value>
<Value name="17">
<Value>SecretLevel</Value>
</Value>
</Data>
<DataLocation>^DHCMed.IMP.ImpEventProgressD</DataLocation>
<DefaultData>ImpEventProgressDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.IMP.ImpEventProgressD</IdLocation>
<IndexLocation>^DHCMed.IMP.ImpEventProgressI</IndexLocation>
<StreamLocation>^DHCMed.IMP.ImpEventProgressS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
