/// 名称: DHCMed.INF.RepOPR
/// 描述: 医政管理 感染报告 手术信息
/// 编写者：ChenJB
/// 编写日期: 2010-05-17
Class DHCMed.INF.RepOPR Extends (%Persistent, DHCMed.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

/// 感染报告
Property InfRepDr As %Integer [ Required ];

/// 手术名称
Property OperationDesc As %String;

/// 是否急诊手术 Y/N
Property EmerOprFlag As %String;

/// 开始日期
Property DateFrom As %Date;

/// 开始时间
Property TimeFrom As %Time;

/// 结束日期
Property DateTo As %Date;

/// 结束时间
Property TimeTo As %Time;

/// 术者 SS_User
Property OprDoc As %Integer;

/// 麻醉方式 字典Code
Property Anaesthesia As %String;

/// 切口类型 字典 Code
Property CuteType As %String;

/// 愈合情况 字典Code
Property Concrescence As %String;

/// 手术是否切口 Y/N
Property CuteInfFlag As %String;

/// 手术切口类型 字典Code
Property OprCuteType As %String;

/// 是否引起感染 Y/N
Property InfectionFlag As %String;

/// 手术医嘱 指向 OE_OrdItem
Property OEORIDr As %String;

/// 手术编码Code
Property OperICD9Map As %String;

/// 备注
Property ResumeText As %String;

/// OprCDZBInfo
Property OprCDZBInfo As %String;

/// OprZGInfo
Property OprZGInfo As %String;

/// OprZGDtInfo
Property OprZGDtInfo As %Date;

/// OprInfDate
Property OprInfDate As %Date;

/// OprInfNongY
Property OprInfNongY As %String;

/// OprDiasInfo
Property OprDiasInfo As %String;

/// OprSXInfo
Property OprSXInfo As %String;

/// OprSHUXInfo
Property OprSHUXInfo As %String;

/// OprCKongInfo
Property OprCKongInfo As %String;

/// OprLGuanInfo
Property OprLGuanInfo As %String;

/// OprWKYLInfo
Property OprWKYLInfo As %String;

/// Text1
Property Text1 As %String;

/// 31: OprSXLInfo 32: OprSHUXLInfo
Property OprSXLInfo As %String;

/// 31: OprSXLInfo 32: OprSHUXLInfo
Property OprSHUXLInfo As %String;

/// 33: OprSKQJD
Property OprSKQJD As %String;

/// 34: OprBWFL
Property OprBWFL As %String;

/// 35: OprDangerCls OprInfCtLoc
Property OprDangerCls As %String;

/// 36: OprInfCtLoc
Property OprInfCtLoc As %Integer;

/// 报告类型索引
Index InfRepDr On InfRepDr;

/// 报告类型及医嘱ID索引
Index InfRepOeoriIdx On (InfRepDr, OEORIDr);

Index InfRepCtL On (InfRepDr, OprInfCtLoc);

/// 报告类型及手术名称
Index InfRepOperDesc On (InfRepDr, OperationDesc);

/// Creator：     ChenJB
/// CreatDate：   2010-05-17
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.INF.RepOPR
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1: Rowid 2: InfRepDr 3: OperationDesc 4: EmerOprFlag 5: DateFrom 6: TimeFrom 7: DateTo 8: TimeTo
/// 9: OprDoc 10: Anaesthesia 11: CuteType 12: Concrescence 13: CuteInfFlag 14: OprCuteType 15: InfectionFlag
/// 16: OEORIDr 17: OperICD9Map 18: ResumeText 19: OprCDZBInfo 20: OprZGInfo 21: OprZGDtInfo 
/// 22: OprInfDate 23: OprInfNongY 24: OprDiasInfo 25: OprSXInfo 26: OprSHUXInfo 27: OprCKongInfo
/// 28: OprLGuanInfo 29: OprWKYLInfo 30: Text1 31: OprSXLInfo 32: OprSHUXLInfo 33: OprSKQJD 34: OprBWFL 35: OprDangerCls 36: OprInfCtLoc
Method ToString(separete As %String = "") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..InfRepDr_separete
	set return=return_..OperationDesc_separete
	set return=return_..EmerOprFlag_separete
	set return=return_..DateFrom_separete
	set return=return_..TimeFrom_separete
	set return=return_..DateTo_separete
	set return=return_..TimeTo_separete
	set return=return_..OprDoc_separete
	set return=return_..Anaesthesia_separete
	set return=return_..CuteType_separete
	set return=return_..Concrescence_separete
	set return=return_..CuteInfFlag_separete
	set return=return_..OprCuteType_separete
	set return=return_..InfectionFlag_separete
	set return=return_..OEORIDr_separete
	set return=return_..OperICD9Map_separete
	set return=return_..ResumeText_separete
	set return=return_..OprCDZBInfo_separete
	set return=return_..OprZGInfo_separete
	set return=return_..OprZGDtInfo_separete
	set return=return_..OprInfDate_separete
	set return=return_..OprInfNongY_separete
	set return=return_..OprDiasInfo_separete
	set return=return_..OprSXInfo_separete
	set return=return_..OprSHUXInfo_separete
	set return=return_..OprCKongInfo_separete
	set return=return_..OprLGuanInfo_separete
	set return=return_..OprWKYLInfo_separete
	set return=return_..Text1_separete
	set return=return_..OprSXLInfo_separete
	set return=return_..OprSHUXLInfo_separete
	set return=return_..OprSKQJD_separete
	set return=return_..OprBWFL_separete
	set return=return_..OprDangerCls_separete
	set return=return_..OprInfCtLoc
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-17
/// Description:  根据ID取感染报告手术信息
/// Table：       DHCMed.INF.RepOPR
/// Input：       ID:    DHCMed.INF.RepOPR.ID
/// Return：      返回obj
/// w ##class(DHCMed.INF.RepOPR).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.INF.RepOPR
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.INF.RepOPR).%ExistsId(+id) return
	set obj=##Class(DHCMed.INF.RepOPR).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-17
/// Description:  根据ID取感染报告 手术信息
/// Table：       DHCMed.INF.RepOPR
/// Input：       ID:    DHCMed.INF.RepOPR.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.INF.RepOPR).GetStringById(1)
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
/// Description:  更新感染报告手术信息
/// Table：       DHCMed.INF.RepOPR
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: InfRepDr 3: OperationDesc 4: EmerOprFlag 5: DateFrom 6: TimeFrom 7: DateTo 8: TimeTo
/// 9: OprDoc 10: Anaesthesia 11: CuteType 12: Concrescence 13: CuteInfFlag 14: OprCuteType 15: InfectionFlag
/// 16: OEORIDr 17: OperICD9Map 18: ResumeText 19: OprCDZBInfo 20: OprZGInfo 21: OprZGDtInfo 
/// 22: OprInfDate 23: OprInfNongY 24: OprDiasInfo 25: OprSXInfo 26: OprSHUXInfo 27: OprCKongInfo
/// 28: OprLGuanInfo 29: OprWKYLInfo 30: Text1 31: OprSXLInfo 32: OprSHUXLInfo 33: OprSKQJD 34: OprBWFL 35: OprDangerCls 36: OprInfCtLoc
ClassMethod Update(InStr As %String, separete As %String) As %String
{
 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.INF.RepOPR).%New()
		} 
	else {
		set obj=##class(DHCMed.INF.RepOPR).%OpenId(ID)
		}
	set obj.InfRepDr=$p(InStr,separete,2)
	set obj.OperationDesc=$p(InStr,separete,3)
	set obj.EmerOprFlag=$p(InStr,separete,4)
	set DateFrom=$p(InStr,separete,5)
	set TimeFrom=$p(InStr,separete,6)
	set:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	set:DateFrom["/" DateFrom=$zdh(DateFrom,4)   //  14/05/2010
	set:TimeFrom[":" TimeFrom=$zth(TimeFrom,1)
	set obj.DateFrom=+DateFrom                   //为空时用零默认时间日期值
	set obj.TimeFrom=+TimeFrom
	set DateTo=$p(InStr,separete,7)
	set TimeTo=$p(InStr,separete,8)
	set:DateTo["-" DateTo=$zdh(DateTo,3)
	set:DateTo["/" DateTo=$zdh(DateTo,4)   //  14/05/2010
	set:TimeTo[":" TimeTo=$zth(TimeTo,1)
	set obj.DateTo=+DateTo
	set obj.TimeTo=+TimeTo
	set obj.OprDoc=$p(InStr,separete,9)
	set obj.Anaesthesia=$p(InStr,separete,10)
	set obj.CuteType=$p(InStr,separete,11)
	set obj.Concrescence=$p(InStr,separete,12)
	set obj.CuteInfFlag=$p(InStr,separete,13)
	set obj.OprCuteType=$p(InStr,separete,14)
	set obj.InfectionFlag=$p(InStr,separete,15)
	set obj.OEORIDr=$p(InStr,separete,16)
	set obj.OperICD9Map=$p(InStr,separete,17)
	set obj.ResumeText=$p(InStr,separete,18)
	set obj.OprCDZBInfo=$p(InStr,separete,19)
	set obj.OprZGInfo=$p(InStr,separete,20)
	set tmpDT=$p(InStr,separete,21)
	set:tmpDT["-" tmpDT=$zdh(tmpDT,3)
	set:tmpDT["/" tmpDT=$zdh(tmpDT,4)   //  14/05/2010
	set obj.OprZGDtInfo=tmpDT
	set tmpDT=$p(InStr,separete,22)
	set:tmpDT["-" tmpDT=$zdh(tmpDT,3)
	set:tmpDT["/" tmpDT=$zdh(tmpDT,4)   //  14/05/2010
	set obj.OprInfDate=tmpDT
	set obj.OprInfNongY=$p(InStr,separete,23)
	set obj.OprDiasInfo=$p(InStr,separete,24)
	set obj.OprSXInfo=$p(InStr,separete,25)
	set obj.OprSHUXInfo=$p(InStr,separete,26)
	set obj.OprCKongInfo=$p(InStr,separete,27)
	set obj.OprLGuanInfo=$p(InStr,separete,28)
	set obj.OprWKYLInfo=$p(InStr,separete,29)
	set obj.Text1=$p(InStr,separete,30)
	set obj.OprSXLInfo=$p(InStr,separete,31)
	set obj.OprSHUXLInfo=$p(InStr,separete,32)
	set obj.OprSKQJD=$p(InStr,separete,33)
	set obj.OprBWFL=$p(InStr,separete,34)
	set obj.OprDangerCls=$p(InStr,separete,35)
	set obj.OprInfCtLoc=$p(InStr,separete,36)
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
/// Description:  删除感染报告 手术
/// Table：       DHCMed.INF.RepOPR
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.INF.RepOPR).%DeleteId(+Id)
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
<Data name="RepOPRDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Anaesthesia</Value>
</Value>
<Value name="3">
<Value>Concrescence</Value>
</Value>
<Value name="4">
<Value>CuteInfFlag</Value>
</Value>
<Value name="5">
<Value>CuteType</Value>
</Value>
<Value name="6">
<Value>DateFrom</Value>
</Value>
<Value name="7">
<Value>DateTo</Value>
</Value>
<Value name="8">
<Value>EmerOprFlag</Value>
</Value>
<Value name="9">
<Value>InfRepDr</Value>
</Value>
<Value name="10">
<Value>InfectionFlag</Value>
</Value>
<Value name="11">
<Value>OEORIDr</Value>
</Value>
<Value name="12">
<Value>OperICD9Map</Value>
</Value>
<Value name="13">
<Value>OperationDesc</Value>
</Value>
<Value name="14">
<Value>OprCuteType</Value>
</Value>
<Value name="15">
<Value>OprDoc</Value>
</Value>
<Value name="16">
<Value>ResumeText</Value>
</Value>
<Value name="17">
<Value>TimeFrom</Value>
</Value>
<Value name="18">
<Value>TimeTo</Value>
</Value>
<Value name="19">
<Value>OprCDZBInfo</Value>
</Value>
<Value name="20">
<Value>OprCKongInfo</Value>
</Value>
<Value name="21">
<Value>OprDiasInfo</Value>
</Value>
<Value name="22">
<Value>OprInfDate</Value>
</Value>
<Value name="23">
<Value>OprInfNongY</Value>
</Value>
<Value name="24">
<Value>OprLGuanInfo</Value>
</Value>
<Value name="25">
<Value>OprSHUXInfo</Value>
</Value>
<Value name="26">
<Value>OprSXInfo</Value>
</Value>
<Value name="27">
<Value>OprWKYLInfo</Value>
</Value>
<Value name="28">
<Value>OprZGDtInfo</Value>
</Value>
<Value name="29">
<Value>OprZGInfo</Value>
</Value>
<Value name="30">
<Value>Text1</Value>
</Value>
<Value name="31">
<Value>OprSHUXLInfo</Value>
</Value>
<Value name="32">
<Value>OprSXLInfo</Value>
</Value>
<Value name="33">
<Value>OprSKQJD</Value>
</Value>
<Value name="34">
<Value>OprBWFL</Value>
</Value>
<Value name="35">
<Value>OprDangerCls</Value>
</Value>
<Value name="36">
<Value>OprInfCtLoc</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INF.RepOPRD</DataLocation>
<DefaultData>RepOPRDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INF.RepOPRD</IdLocation>
<IndexLocation>^DHCMed.INF.RepOPRI</IndexLocation>
<StreamLocation>^DHCMed.INF.RepOPRS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
