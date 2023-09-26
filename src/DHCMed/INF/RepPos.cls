/// 名称: DHCMed.INF.RepPos
/// 描述: 医政管理 感染部位
/// 编写者：ChenJB
/// 编写日期: 2010-05-12
Class DHCMed.INF.RepPos Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// 感染报告
Property InfRepDr As %Integer [ Required ];

/// 感染部位 字典
Property InfPosCode As %String;

/// 感染日期
Property InfDate As %Date;

/// 感染诊断 DHC_Med.INF.InfDiagnose
Property InfDiagDR As %Integer;

/// 侵害性操作 字典
Property InroadOpr As %String;

/// 感染结束日期
Property InfEndDate As %Date;

/// 感染天数
Property InfDays As %Integer;

/// 侵害性操作开始日期
Property InfOprStartDate As %Date;

/// 侵害性操作开始时间
Property InfOprStartTime As %Time;

/// 侵害性操作结束日期
Property InfOprEndDate As %Date;

/// 侵害性操作结束时间
Property InfOprEndTime As %Time;

/// 备注
Property ResumeText As %String;

/// 感染报告 父子索引
Index InfRepDr On InfRepDr;

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.RepPos
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: InfRepDr 3: InfPosCode 4: InfDate 5: InfDiagDR 6: InroadOpr 7: InfEndDate 8: InfDays
/// 9: InfOprStartDate 10: InfOprStartTime 11: InfOprEndDate 12: InfOprEndTime 13: ResumeText
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..InfRepDr_separete
	set return=return_..InfPosCode_separete
	set return=return_..InfDate_separete
	set return=return_..InfDiagDR_separete
	set return=return_..InroadOpr_separete
	set return=return_..InfEndDate_separete
	set return=return_..InfDays_separete
	set return=return_..InfOprStartDate_separete
	set return=return_..InfOprStartTime_separete
	set return=return_..InfOprEndDate_separete
	set return=return_..InfOprEndTime_separete
	set return=return_..ResumeText
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染部位信息
/// Table：       DHCMed.INF.RepPos
/// Input：       ID:    DHCMed.INF.RepPos.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.RepPos).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.RepPos
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.RepPos).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.RepPos).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  根据ID取感染报告信息
/// Table：       DHCMed.INF.RepPos
/// Input：       ID:    DHCMed.INF.RepPos.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.RepPos).GetStringById(1)
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
/// Description:  更新感染部位信息
/// Table：       DHCMed.INF.RepPos
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: InfRepDr 3: InfPosCode 4: InfDate 5: InfDiagDR 6: InroadOpr 7: InfEndDate 8: InfDays
/// 9: InfOprStartDate 10: InfOprStartTime 11: InfOprEndDate 12: InfOprEndTime 13: ResumeText
ClassMethod Update(InStr As %String, separete As %String) As %String
{
 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.RepPos).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.RepPos).%OpenId(ID)
		}
	set obj.InfRepDr=$p(InStr,separete,2)
	set obj.InfPosCode=$p(InStr,separete,3)
	set InfDate=$p(InStr,separete,4)
	//set RepTime=$p(InStr,separete,5)
	set:InfDate["-" InfDate=$zdh(InfDate,3)
	set:InfDate["/" InfDate=$zdh(InfDate,4)   //  14/05/2010
	//set:RepTime[":" RepTime=$zth(RepTime,1)
	//set:RepDate="" RepDate=+$h
	//set:RepTime="" RepTime=$p($h,",",2)
	set obj.InfDate=+InfDate
	//set obj.RepTime=+RepTime
	set obj.InfDiagDR=$p(InStr,separete,5)
	set obj.InroadOpr=$p(InStr,separete,6)
	set InfEndDate=$p(InStr,separete,7)
	set:InfEndDate["-" InfEndDate=$zdh(InfEndDate,3)
	set:InfEndDate["/" InfEndDate=$zdh(InfEndDate,4)   //  14/05/2010
	set obj.InfEndDate=+InfEndDate
	set obj.InfDays=$p(InStr,separete,8)
	set InfOprStartDate=$p(InStr,separete,9)
	set InfOprStartTime=$p(InStr,separete,10)
	set:InfOprStartDate["-" InfOprStartDate=$zdh(InfOprStartDate,3)
	set:InfOprStartDate["/" InfOprStartDate=$zdh(InfOprStartDate,4)   //  14/05/2010
	set:InfOprStartTime[":" InfOprStartTime=$zth(InfOprStartTime,1)
	set obj.InfOprStartDate=+InfOprStartDate
	set obj.InfOprStartTime=+InfOprStartTime
	set InfOprEndDate=$p(InStr,separete,11)
	set InfOprEndTime=$p(InStr,separete,12)
	set:InfOprEndDate["-" InfOprEndDate=$zdh(InfOprEndDate,3)
	set:InfOprEndDate["/" InfOprEndDate=$zdh(InfOprEndDate,4)   //  14/05/2010
	set:InfOprEndTime[":" InfOprEndTime=$zth(InfOprEndTime,1)
	set obj.InfOprEndDate=+InfOprEndDate
	set obj.InfOprStartTime=+InfOprEndTime
	set obj.ResumeText=$p(InStr,separete,13)
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
/// Description:  删除感染部位
/// Table：       DHCMed.INF.RepPos
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.RepPos).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// Creator：     LYH
/// CreatDate：   2011-06-09
/// Description:  通过报告ID删除感染部位
/// Table：       DHCMed.INF.RepPos
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMed.INF.RepPos).DeleteByRepID(231)
ClassMethod DeleteByRepID(Id)
{
	new (Id)
	
	s ret=0
	q:'$d(^DHCMed.INF.SummaryI("InfRepDr",Id)) ret
	s SumID=$o(^DHCMed.INF.SummaryI("InfRepDr",Id,""),-1)
	q:SumID="" ret
	q:'$d(^DHCMed.INF.RepPosI("InfRepDr",SumID)) ret
	s PosID=""
	
	f  s PosID=$o(^DHCMed.INF.RepPosI("InfRepDr",SumID,PosID)) q:PosID=""  d
	.s str=..DeleteById(PosID)
	q ret
}

Storage Default
{
<Data name="RepPosDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InfDate</Value>
</Value>
<Value name="3">
<Value>InfDays</Value>
</Value>
<Value name="4">
<Value>InfDiagDR</Value>
</Value>
<Value name="5">
<Value>InfEndDate</Value>
</Value>
<Value name="6">
<Value>InfOprEndDate</Value>
</Value>
<Value name="7">
<Value>InfOprEndTime</Value>
</Value>
<Value name="8">
<Value>InfOprStartDate</Value>
</Value>
<Value name="9">
<Value>InfOprStartTime</Value>
</Value>
<Value name="10">
<Value>InfPosCode</Value>
</Value>
<Value name="11">
<Value>InfRepDr</Value>
</Value>
<Value name="12">
<Value>InroadOpr</Value>
</Value>
<Value name="13">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.RepPosD</DataLocation>
<DefaultData>RepPosDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.RepPosD</IdLocation>
<IndexLocation>^DHCMed.INF.RepPosI</IndexLocation>
<StreamLocation>^DHCMed.INF.RepPosS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
