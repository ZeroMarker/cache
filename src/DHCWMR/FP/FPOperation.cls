/// 病案编目手术信息
Class DHCWMR.FP.FPOperation Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.FP.FrontPage [ Cardinality = parent, Inverse = ChildOperation ];

/// 诊断库版本
Property FPOVCode As DHCWMR.FP.ICDVersion;

/// 顺序号
Property FPOIndex As %Integer;

/// 手术ICD
Property FPOICDDr As DHCWMR.FP.ICDDx;

/// 类型（手术、操作）
Property FPOType As DHCWMR.SS.Dictionary;

/// 手术开始日期
Property FPOSttDate As %Date;

/// 手术开始时间
Property FPOSttTime As %Time;

/// 手术结束时间
Property FPOEndTime As %Time;

/// 手术结束日期
Property FPOEndDate As %Date;

/// 术者（SS_User.ID）
Property FPOOperator As %String(MAXLEN = 100, TRUNCATE = 1);

/// 术者-姓名
Property FPOOperatorTxt As %String(MAXLEN = 100, TRUNCATE = 1);

/// 一助（SS_User.ID）
Property FPOAssistant1 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 一助-姓名
Property FPOAssistant1Txt As %String(MAXLEN = 100, TRUNCATE = 1);

/// 二助（SS_User.ID）
Property FPOAssistant2 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 二助-姓名
Property FPOAssistant2Txt As %String(MAXLEN = 100, TRUNCATE = 1);

/// 麻醉方式("NarcosisType")
Property FPONarcosisType As DHCWMR.SS.Dictionary;

/// 麻醉医师（SS_User.ID）
Property FPONarcosisDoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 麻醉医师-姓名
Property FPONarcosisDocTxt As %String(MAXLEN = 100, TRUNCATE = 1);

/// 切口类型("FPCutType")
Property FPOCutType As DHCWMR.SS.Dictionary;

/// 愈合情况("FPHealing")
Property FPOHealing As DHCWMR.SS.Dictionary;

/// 手术级别("OperationRank")
Property FPOOperLevel As DHCWMR.SS.Dictionary;

/// 首页数据（"#"分隔）
Property FPODataSource As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 暂存数据（"^"分隔）
Property FPOTempData As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 顺序号 索引
Index IndexFPOIndex On (Parref, FPOIndex);

/// 类型、顺序号 索引
Index IndexTypeIndex On (Parref, FPOType, FPOIndex);

/// Creator：     zhufei
/// CreatDate：   2014-08-26
/// Description:  根据ID取编目手术信息
/// Table：       DHCWMR.FP.FPOperation
/// Input：       Id : DHCWMR.FP.FPOperation.ID
/// Return：      返回obj
/// w ##class(DHCWMR.FP.FPOperation).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.FP.FPOperation
{
	new (aId)
	set return=""
	quit:aId="" return
	quit:'##class(DHCWMR.FP.FPOperation).%ExistsId(aId) return
	set obj=##Class(DHCWMR.FP.FPOperation).%OpenId(aId)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-08-26
/// Description:  更新编目手术信息
/// Table：       DHCWMR.FP.FPOperation
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:Code 3:Description 4:Type 5:HospitalDr 6:Active 7:DateFrom 8:DateTo 9:ProductCode
/// w ##class(DHCWMR.FP.FPOperation).Update("","")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref=$p(aInputStr,aSeparate,1)
	Set ChildSub=$p(aInputStr,aSeparate,2)
	Set VCode=$p(aInputStr,aSeparate,3)
	Set RowIndex=+$p(aInputStr,aSeparate,4)
	Set ICDDr=$p(aInputStr,aSeparate,5)
	Set Type=$p(aInputStr,aSeparate,6)
	Set SttDate=$p(aInputStr,aSeparate,7)
	Set:SttDate["-" SttDate=$zdh(SttDate,3)
	Set SttTime=$p(aInputStr,aSeparate,8)
	Set:SttTime[":" SttTime=$zth(SttTime,1)
	Set EndTime=$p(aInputStr,aSeparate,9)
	Set:EndTime[":" EndTime=$zth(EndTime,1)
	Set EndDate=$p(aInputStr,aSeparate,10)
	Set:EndDate["-" EndDate=$zdh(EndDate,3)
	Set Operator=$p(aInputStr,aSeparate,11)
	Set OperatorTxt=$p(aInputStr,aSeparate,12)
	Set Assistant1=$p(aInputStr,aSeparate,13)
	Set Assistant1Txt=$p(aInputStr,aSeparate,14)
	Set Assistant2=$p(aInputStr,aSeparate,15)
	Set Assistant2Txt=$p(aInputStr,aSeparate,16)
	Set NarcosisType=$p(aInputStr,aSeparate,17)
	Set NarcosisDoc=$p(aInputStr,aSeparate,18)
	Set NarcosisDocTxt=$p(aInputStr,aSeparate,19)
	Set CutType=$p(aInputStr,aSeparate,20)
	Set Healing=$p(aInputStr,aSeparate,21)
	Set OperLevel=$p(aInputStr,aSeparate,22)
	Set DataSource=$p(aInputStr,aSeparate,23)
	Set TempData=$p(aInputStr,aSeparate,24)
	Quit:(Parref="") return
	
	//术者
	If Operator'="" {
		Set UserName=##Class(DHCWMR.FPService.SSUserSrv).GetUserNameByID(Operator)
		If UserName'=OperatorTxt {
			Set Operator=""
		}
	}
	//一助
	If Assistant1'="" {
		Set UserName=##Class(DHCWMR.FPService.SSUserSrv).GetUserNameByID(Assistant1)
		If UserName'=Assistant1Txt {
			Set Assistant1=""
		}
	}
	//二助
	If Assistant2'="" {
		Set UserName=##Class(DHCWMR.FPService.SSUserSrv).GetUserNameByID(Assistant2)
		If UserName'=Assistant2Txt {
			Set Assistant2=""
		}
	}
	//麻醉医师
	If NarcosisDoc'="" {
		Set UserName=##Class(DHCWMR.FPService.SSUserSrv).GetUserNameByID(NarcosisDoc)
		If UserName'=NarcosisDocTxt {
			Set NarcosisDoc=""
		}
	}
	
	Set objICD=##class(DHCWMR.FP.ICDDx).GetObjById(ICDDr)
	If $IsObject(objICD){
		Set objVersion=objICD.IDVCode
	} Else {
		Set objVersion=""
	}
	
	Set objParref=##class(DHCWMR.FP.FrontPage).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	If ChildSub="" {
		Set obj=##class(DHCWMR.FP.FPOperation).%New()
	}Else{
		Set obj=##class(DHCWMR.FP.FPOperation).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref            = objParref
	Set obj.FPOVCode          = objVersion
	Set obj.FPOIndex          = RowIndex
	Set obj.FPOICDDr          = objICD
	Set obj.FPOType           = ##class(DHCWMR.SS.Dictionary).GetObjById(Type)
	Set obj.FPOSttDate        = SttDate
	Set obj.FPOSttTime        = SttTime
	Set obj.FPOEndTime        = EndTime
	Set obj.FPOEndDate        = EndDate
	Set obj.FPOOperator       = Operator
	Set obj.FPOOperatorTxt    = OperatorTxt
	Set obj.FPOAssistant1     = Assistant1
	Set obj.FPOAssistant1Txt  = Assistant1Txt
	Set obj.FPOAssistant2     = Assistant2
	Set obj.FPOAssistant2Txt  = Assistant2Txt
	Set obj.FPONarcosisType   = ##class(DHCWMR.SS.Dictionary).GetObjById(NarcosisType)
	Set obj.FPONarcosisDoc    = NarcosisDoc
	Set obj.FPONarcosisDocTxt = NarcosisDocTxt
	Set obj.FPOCutType        = ##class(DHCWMR.SS.Dictionary).GetObjById(CutType)
	Set obj.FPOHealing        = ##class(DHCWMR.SS.Dictionary).GetObjById(Healing)
	Set obj.FPOOperLevel      = ##class(DHCWMR.SS.Dictionary).GetObjById(OperLevel)
	Set obj.FPODataSource     = DataSource
	Set obj.FPOTempData       = TempData
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-08-26
/// Description:  删除编目手术信息
/// Table：       DHCWMR.FP.FPOperation
/// Input：       Id : DHCWMR.FP.FPOperation.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId)
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.FP.FPOperation).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FPOVCode</Value>
</Value>
<Value name="3">
<Value>FPOIndex</Value>
</Value>
<Value name="4">
<Value>FPOICDDr</Value>
</Value>
<Value name="5">
<Value>FPOType</Value>
</Value>
<Value name="6">
<Value>FPOSttDate</Value>
</Value>
<Value name="7">
<Value>FPOSttTime</Value>
</Value>
<Value name="8">
<Value>FPOEndDate</Value>
</Value>
<Value name="9">
<Value>FPOEndTime</Value>
</Value>
<Value name="10">
<Value>FPOOperator</Value>
</Value>
<Value name="11">
<Value>FPOOperatorTxt</Value>
</Value>
<Value name="12">
<Value>FPOAssistant1</Value>
</Value>
<Value name="13">
<Value>FPOAssistant1Txt</Value>
</Value>
<Value name="14">
<Value>FPOAssistant2</Value>
</Value>
<Value name="15">
<Value>FPOAssistant2Txt</Value>
</Value>
<Value name="16">
<Value>FPONarcosisType</Value>
</Value>
<Value name="17">
<Value>FPONarcosisDoc</Value>
</Value>
<Value name="18">
<Value>FPONarcosisDocTxt</Value>
</Value>
<Value name="19">
<Value>FPOCutType</Value>
</Value>
<Value name="20">
<Value>FPOHealing</Value>
</Value>
<Value name="21">
<Value>FPOOperLevel</Value>
</Value>
<Value name="22">
<Value>FPODataSource</Value>
</Value>
<Value name="23">
<Value>FPOTempData</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("O")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("O")</IdLocation>
<IndexLocation>^DHCWMR.FP.FrontPageI("FPO")</IndexLocation>
<StreamLocation>^DHCWMR.FP.FPOperationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
