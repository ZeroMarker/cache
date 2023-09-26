/// 名称: DHCMed.NINF.Aim.Check72
/// 描述: 人工气道、留置深静脉、留置导尿72小时后调查表
/// 编写者：LK
/// 编写日期: 2012-04-18
Class DHCMed.NINF.Aim.Check72 Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 临床上报表
Property CRReportDR As %String(TRUNCATE = 1) [ Required ];

Index CRReportDR On CRReportDR [ Unique ];

/// 经气管插管
Property PipeByTracheal As %String;

/// 气管切开
Property CutTracheal As %String;

/// 置管天数
Property PipeDays1 As %String;

///  置留原因
Property SaveReason1 As %String;

///  锁骨下
Property UnClavicle As %String;

/// 颈内
Property InDveck As %String;

///  股静脉
Property FeMoVen As %String;

///  肘静脉
Property CuVein As %String;

/// 置管天数2
Property PipeDays2 As %String;

///  置留原因2
Property SaveReason2 As %String;

///  双腔气囊
Property DoubleAir As %String;

///  三腔气囊
Property ThreeAir As %String;

///  置留天数3
Property PipeDays3 As %String;

///   置留原因3
Property SaveReason3 As %String;

/// Creator：     LK
/// CreatDate：   2012-04-18
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.NINF.Aim.Check72
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1 CRReportDR 2 PipeByTracheal 3 CutTracheal 4 PipeDays1 5 SaveReason1
/// 6 UnClavicle 7 InDveck 8 FeMoVen 9 CuVein 10 PipeDays2 11 SaveReason2
/// 12 DoubleAir 13 ThreeAir 14 PipeDays3 15 SaveReason3
Method ToString(separete As %String = "") As %String
{
	if separete=""{
		set separete=..#SEPARATE}
		set return=..%Id()_separete
		set return=return_..CRReportDR_separete
		set return=return_..PipeByTracheal_separete
		set return=return_..CutTracheal_separete
		set return=return_..PipeDays1_separete
		set return=return_..SaveReason1_separete
		set return=return_..UnClavicle_separete
		set return=return_..InDveck_separete
		set return=return_..FeMoVen_separete
		set return=return_..CuVein_separete
		set return=return_..PipeDays2_separete
		set return=return_..SaveReason2_separete
		set return=return_..DoubleAir_separete
		set return=return_..ThreeAir_separete
		set return=return_..PipeDays3_separete
		set return=return_..SaveReason3
		quit return
}

/// Creator：     LK
/// CreatDate：   2012-04-18
/// Description:  根据ID取感染报告信息
/// Table：       DHCMed.NINF.Aim.Check72
/// Input：       ID:    DHCMed.NINF.Aim.Check72.ID
/// Return：      返回obj
/// write ##class(DHCMed.NINF.Aim.IvcCheck).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.NINF.Aim.Check72
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.Aim.Check72).%ExistsId(+id) return
	set obj=##Class(DHCMed.NINF.Aim.Check72).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

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

/// Creator：     LK
/// CreatDate：   2012-04-18
/// Description:  更新报告信息
/// Table：       DHCMed.NINF.Aim.Check72
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1 CRReportDR 2 PipeByTracheal 3 CutTracheal 4 PipeDays1 5 SaveReason1
/// 6 UnClavicle 7 InDveck 8 FeMoVen 9 CuVein 10 PipeDays2 11 SaveReason2
/// 12 DoubleAir 13 ThreeAir 14 PipeDays3 15 SaveReason3
///  ##class(DHCMed.NINF.Aim.Check721).Update("^2^3^4^^^^^^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.NINF.Aim.Check72).%New()
		} 
	else {
			set obj=##class(DHCMed.NINF.Aim.Check72).%OpenId(ID)
		}
	b //001
	set obj.CRReportDR=$p(InStr,separete,2)
	set obj.PipeByTracheal=$p(InStr,separete,3)
	set obj.CutTracheal=$p(InStr,separete,4)
	set obj.PipeDays1=$p(InStr,separete,5)
	set obj.SaveReason1=$p(InStr,separete,6)
	set obj.UnClavicle=$p(InStr,separete,7)
	set obj.InDveck=$p(InStr,separete,8)
	set obj.FeMoVen=$p(InStr,separete,9)
	set obj.PipeDays2=$p(InStr,separete,10)
	set obj.SaveReason2=$p(InStr,separete,11)
	set obj.DoubleAir=$p(InStr,separete,12)
	set obj.ThreeAir=$p(InStr,separete,13)
	set obj.PipeDays3=$p(InStr,separete,14)
	set obj.SaveReason3=$p(InStr,separete,15)
	set sc=obj.%Save()
	b //002
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

/// Creator：     LK
/// CreatDate：   2012-04-18
/// Description:  删除报告
/// Table：       DHCMed.NINF.Aim.Check72
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.NINF.Aim.Check72).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// write ##class(DHCMed.NINF.Aim.Check72).UpdateDataFromEPR(1)
ClassMethod UpdateDataFromEPR(CRReportDR As %String) As %String
{
	n (CRReportDR)
	
	s ret=-1
	
	q:(CRReportDR="") ret
	s RepID=""
	i $d(^DHCMed.NINF.Aim.IvcCheckI("CRReportDR"," "_CRReportDR)) d
	.s RepID=$o(^DHCMed.NINF.Aim.IvcCheckI("CRReportDR"," "_CRReportDR,""),-1)
	
	b ///000
	s objCRReport=##class(DHCMed.CR.Report).%OpenId(CRReportDR)
	q:'$IsObject(objCRReport)
	s EpisodeID=objCRReport.EpisodeID
	s InstanceDataID=objCRReport.InstanceID
	q:(EpisodeID="")||(InstanceDataID="") ret
	b ///001
	
	s tmp = RepID
	s tmp = tmp _ "^" _CRReportDR
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"姓名S0001#TYPE:Simple#TID:656#TVER:0#SCODE:S0001#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"病区I0002#TYPE:Simple#TID:656#TVER:0#SCODE:I0002#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"床号S0003#TYPE:Simple#TID:656#TVER:0#SCODE:S0003#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"住院号S0004#TYPE:Simple#TID:656#TVER:0#SCODE:S0004#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"留置人工气道评估表M0005#TYPE:Simple#TID:656#TVER:0#SCODE:M0005#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"留置原因1G0006#TYPE:Segment#TID:618#TVER:0#GCODE:G0006",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"医生签名1S0007#TYPE:Simple#TID:656#TVER:0#SCODE:S0007#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"置管天数1O0009#TYPE:Simple#TID:656#TVER:0#SCODE:O0009#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"留置深静脉导管评估表M0016#TYPE:Simple#TID:656#TVER:0#SCODE:M0016#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"置管天数2O0010#TYPE:Simple#TID:656#TVER:0#SCODE:O0010#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"留置原因2G0011#TYPE:Segment#TID:618#TVER:0#GCODE:G0011",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"医生签名2S0012#TYPE:Simple#TID:656#TVER:0#SCODE:S0012#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"留置导尿管评估表M0017#TYPE:Simple#TID:656#TVER:0#SCODE:M0017#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"置管天数3O0013#TYPE:Simple#TID:656#TVER:0#SCODE:O0013#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"留置原因3G0014#TYPE:Segment#TID:618#TVER:0#GCODE:G0014",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"医生签名3S0015#TYPE:Simple#TID:656#TVER:0#SCODE:S0015#VTYPE:V",InstanceDataID)

	s ret=..Update(tmp)
	
	q ret
}

ClassMethod GetDataFromEPR(EpisodeID As %String, ItemPara As %String, InstanceDataID As %String) As %String
{
	new (EpisodeID, ItemPara ,InstanceDataID)
	
	set ret=##class(EPRservice.BOScatterData).GetEPRMultipleData(EpisodeID, ItemPara ,InstanceDataID)
	
	quit ret
}

Storage Default
{
<Data name="Check72DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CRReportDR</Value>
</Value>
<Value name="3">
<Value>CuVein</Value>
</Value>
<Value name="4">
<Value>CutTracheal</Value>
</Value>
<Value name="5">
<Value>DoubleAir</Value>
</Value>
<Value name="6">
<Value>FeMoVen</Value>
</Value>
<Value name="7">
<Value>InDveck</Value>
</Value>
<Value name="8">
<Value>PipeByTracheal</Value>
</Value>
<Value name="9">
<Value>PipeDays1</Value>
</Value>
<Value name="10">
<Value>PipeDays2</Value>
</Value>
<Value name="11">
<Value>PipeDays3</Value>
</Value>
<Value name="12">
<Value>SaveReason1</Value>
</Value>
<Value name="13">
<Value>SaveReason2</Value>
</Value>
<Value name="14">
<Value>SaveReason3</Value>
</Value>
<Value name="15">
<Value>ThreeAir</Value>
</Value>
<Value name="16">
<Value>UnClavicle</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.Aim.Check72D</DataLocation>
<DefaultData>Check72DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.Aim.Check72D</IdLocation>
<IndexLocation>^DHCMed.NINF.Aim.Check72I</IndexLocation>
<StreamLocation>^DHCMed.NINF.Aim.Check72S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
