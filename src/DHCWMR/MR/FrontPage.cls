/// 名称 : DHCWMR.MR.FrontPage
/// 说明 : 住院病案首页主表
Class DHCWMR.MR.FrontPage Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock ]
{

Relationship ChildAdm As DHCWMR.MR.FrontPageAdm [ Cardinality = children, Inverse = Parref ];

Relationship ChildICD As DHCWMR.MR.FrontPageICD [ Cardinality = children, Inverse = Parref ];

Relationship ChildOper As DHCWMR.MR.FrontPageOper [ Cardinality = children, Inverse = Parref ];

Relationship ChildICU As DHCWMR.MR.FrontPageICU [ Cardinality = children, Inverse = Parref ];

Relationship ChildFees As DHCWMR.MR.FrontPageFees [ Cardinality = children, Inverse = Parref ];

Relationship ChildAdd As DHCWMR.MR.FrontPageAdd [ Cardinality = children, Inverse = Parref ];

/// 就诊号
Property FPEpisodeID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病人ID
Property FPPatientID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 住院号
Property FPADMNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医院ID（指向CT_Hospital）
/// 主要是为了处理集团化医院字典不统一的情况
Property FPHospID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病案类型（中医C、西医W）
Property FPMRType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出院日期
Property FPDischDate As %Date;

/// 出院时间
Property FPDischTime As %Time;

/// 归档日期
Property FPFilingDate As %Date;

/// 归档时间
Property FPFilingTime As %Time;

/// 归档标志
Property FPIsFiling As %Boolean;

/// 编码日期
Property FPCodingDate As %Date;

/// 编码时间
Property FPCodingTime As %Time;

/// 编码标志
Property FPIsCoding As %Boolean;

/// 更新日期
Property FPUpdateDate As %Date;

/// 更新时间
Property FPUpdateTime As %Time;

/// 错误标记
Property FPIsError As %Boolean;

Index IndexEpisodeID On FPEpisodeID;

Index IndexADMNo On FPADMNo;

Index IndexDischDate On (FPDischDate, FPDischTime);

Index IndexFilingDate On (FPFilingDate, FPFilingTime);

Index IndexCodingDate On (FPCodingDate, FPCodingTime);

Index IndexIsError On FPIsError;

/// Creator：     zhufei
/// CreatDate：   2015-08-27
/// Description:  根据ID取病案首页信息
/// Table：       DHCWMR.MR.FrontPage
/// Input：       Id : DHCWMR.MR.FrontPage.ID
/// Return：      返回Object
/// w ##class(DHCWMR.MR.FrontPage).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.MR.FrontPage
{
	new (aId)
	quit:'##class(DHCWMR.MR.FrontPage).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.MR.FrontPage).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  更新住院病案首页主记录
/// Table：       DHCWMR.MR.FrontPage
/// Input：       InputStr ：ID^EpisodeID^PatientID^ADMNo^HospID^病案类型^出院日期^出院时间^归档日期^归档时间^归档标志^编码日期^编码时间^编码标志
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCWMR.MR.FrontPage).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String = "^") As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID=$p(aInputStr,aSeparate,1)
	Set EpisodeID=$p(aInputStr,aSeparate,2)
	Set PatientID=$p(aInputStr,aSeparate,3)
	Set ADMNo=$p(aInputStr,aSeparate,4)
	Set HospID=$p(aInputStr,aSeparate,5)
	Set MRType=$p(aInputStr,aSeparate,6)
	Set DischDate=$p(aInputStr,aSeparate,7)
	Set DischTime=$p(aInputStr,aSeparate,8)
	Set FilingDate=$p(aInputStr,aSeparate,9)
	Set FilingTime=$p(aInputStr,aSeparate,10)
	Set IsFiling=$p(aInputStr,aSeparate,11)
	Set CodingDate=$p(aInputStr,aSeparate,12)
	Set CodingTime=$p(aInputStr,aSeparate,13)
	Set IsCoding=$p(aInputStr,aSeparate,14)
	Set IsError=+$p(aInputStr,aSeparate,15)
	
	If ID="" {
		Set obj=##class(DHCWMR.MR.FrontPage).%New()
	} Else {
		Set obj=##class(DHCWMR.MR.FrontPage).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.FPEpisodeID     = EpisodeID
	Set obj.FPPatientID     = PatientID
	Set obj.FPADMNo         = ADMNo
	Set obj.FPHospID        = HospID
	Set obj.FPMRType        = MRType
	Set obj.FPDischDate     = DischDate
	Set obj.FPDischTime     = DischTime
	Set obj.FPFilingDate    = FilingDate
	Set obj.FPFilingTime    = FilingTime
	Set obj.FPIsFiling      = IsFiling
	Set obj.FPCodingDate    = CodingDate
	Set obj.FPCodingTime    = CodingTime
	Set obj.FPIsCoding      = IsCoding
	Set obj.FPUpdateDate    = +$h
	Set obj.FPUpdateTime    = $p($h,",",2)
	Set obj.FPIsError       = IsError
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-08-27
/// Description:  根据Code取病案首页内容
/// Table：       DHCWMR.MR.FrontPage
/// Input：       Code : 字典代码
/// Return：      返回String
/// w obj.GetData(1)
Method GetData(aCode As %String) As %String
{
	New (aCode,%this)
	Set return=""
	Set aCode=$tr(aCode,".","")
	Set aCode=$zcvt(aCode,"U")
	Quit:$l(aCode)'=9 return
	
	Set DataType=$e(aCode,1,2)
	If (DataType="P0")||(DataType="P1") {  //病人基本信息
		Set Count=%this.ChildAdm.Count()
		Set oref=%this.ChildAdm.GetAt(Count)
		/*
		Set cd=$system.CLS.DumpContext(oref,0)
		Set inst=$piece(cd,"^",8)
		For indP=1:1:inst {
			Set pd=$system.CLS.Property(indP,oref,0)
			Set ivar=$piece(pd,"^")
			Continue:ivar'=aCode
			Set cmd="Set return=oref."_aCode
			Xecute cmd
			Quit
		}
		*/
		// Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("DHCWMR.MR.FrontPageAdm")      // P7以下使用
		Set cdef = ##class(%Library.CompiledClass).%OpenId("DHCWMR.MR.FrontPageAdm")              // P8以上
		Set inst=cdef.Properties.Count()
		For indP=1:1:inst {
			Set objProperty=cdef.Properties.GetAt(indP)
			Continue:objProperty.Private=1 //私有属性不能序列化
			Set ivar=objProperty.Name
			Continue:ivar'=aCode
			Set cmd="Set return=oref."_aCode
			Xecute cmd
			Quit
		}
	} ElseIf (DataType="P2")||(DataType="P3") {  //诊断信息
		Set Parref=%this.%Id()
		Set PDType=$e(aCode,2,3)
		Set PDIndex=$e(aCode,4,5)
		Set FieldName="PD"_$e(aCode,6,9)
		Set ChildSub=$o(^DHCWMR.MR.FrontPageI("ICD","IndexTypeIndex",Parref," "_PDType,+PDIndex,0))
		If ChildSub'="" {
			Set oref=##class(DHCWMR.MR.FrontPageICD).GetObjById(Parref_"||"_ChildSub)
			Quit:'$IsObject(oref) return
			/*
			Set cd=$system.CLS.DumpContext(oref,0)
			Set inst=$piece(cd,"^",8)
			For indP=1:1:inst {
				Set pd=$system.CLS.Property(indP,oref,0)
				Set ivar=$piece(pd,"^")
				Continue:ivar'=FieldName
				Set cmd="Set return=oref."_FieldName
				Xecute cmd
				Quit
			}
			*/
			// Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("DHCWMR.MR.FrontPageICD")      // P7以下使用
			Set cdef = ##class(%Library.CompiledClass).%OpenId("DHCWMR.MR.FrontPageICD")              // P8以上
			Set inst=cdef.Properties.Count()
			For indP=1:1:inst {
				Set objProperty=cdef.Properties.GetAt(indP)
				Continue:objProperty.Private=1 //私有属性不能序列化
				Set ivar=objProperty.Name
				Continue:ivar'=FieldName
				Set cmd="Set return=oref."_FieldName
				Xecute cmd
				Quit
			}
		}
	} ElseIf (DataType="P4") {  //手术信息
		Set Parref=%this.%Id()
		Set POType=$e(aCode,2,3)
		Set POIndex=$e(aCode,4,5)
		Set FieldName="PO"_$e(aCode,6,9)
		Set ChildSub=$o(^DHCWMR.MR.FrontPageI("OPER","IndexTypeIndex",Parref," "_POType,+POIndex,0))
		If ChildSub'="" {
			Set oref=##class(DHCWMR.MR.FrontPageOper).GetObjById(Parref_"||"_ChildSub)
			Quit:'$IsObject(oref) return
			/*
			Set cd=$system.CLS.DumpContext(oref,0)
			Set inst=$piece(cd,"^",8)
			For indP=1:1:inst {
				Set pd=$system.CLS.Property(indP,oref,0)
				Set ivar=$piece(pd,"^")
				Continue:ivar'=FieldName
				Set cmd="Set return=oref."_FieldName
				Xecute cmd
				Quit
			}
			*/
			// Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("DHCWMR.MR.FrontPageOper")      // P7以下使用
			Set cdef = ##class(%Library.CompiledClass).%OpenId("DHCWMR.MR.FrontPageOper")              // P8以上
			Set inst=cdef.Properties.Count()
			For indP=1:1:inst {
				Set objProperty=cdef.Properties.GetAt(indP)
				Continue:objProperty.Private=1 //私有属性不能序列化
				Set ivar=objProperty.Name
				Continue:ivar'=FieldName
				Set cmd="Set return=oref."_FieldName
				Xecute cmd
				Quit
			}
		}
	} ElseIf (DataType="P5") {  //重症监护信息
		Set Parref=%this.%Id()
		Set PIType=$e(aCode,2,3)
		Set PIIndex=$e(aCode,4,5)
		Set FieldName="PI"_$e(aCode,6,9)
		Set ChildSub=$o(^DHCWMR.MR.FrontPageI("ICU","IndexTypeIndex",Parref," "_PIType,+PIIndex,0))
		If ChildSub'="" {
			Set oref=##class(DHCWMR.MR.FrontPageICU).GetObjById(Parref_"||"_ChildSub)
			Quit:'$IsObject(oref) return
			/*
			Set cd=$system.CLS.DumpContext(oref,0)
			Set inst=$piece(cd,"^",8)
			For indP=1:1:inst {
				Set pd=$system.CLS.Property(indP,oref,0)
				Set ivar=$piece(pd,"^")
				Continue:ivar'=FieldName
				Set cmd="Set return=oref."_FieldName
				Xecute cmd
				Quit
			}
			*/
			// Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("DHCWMR.MR.FrontPageICU")      // P7以下使用
			Set cdef = ##class(%Library.CompiledClass).%OpenId("DHCWMR.MR.FrontPageICU")              // P8以上
			Set inst=cdef.Properties.Count()
			For indP=1:1:inst {
				Set objProperty=cdef.Properties.GetAt(indP)
				Continue:objProperty.Private=1 //私有属性不能序列化
				Set ivar=objProperty.Name
				Continue:ivar'=FieldName
				Set cmd="Set return=oref."_FieldName
				Xecute cmd
				Quit
			}
		}
	} ElseIf (DataType="P6") {  //费用信息
		Set Count=%this.ChildFees.Count()
		Set oref=%this.ChildFees.GetAt(Count)
		/*
		Set cd=$system.CLS.DumpContext(oref,0)
		Set inst=$piece(cd,"^",8)
		For indP=1:1:inst {
			Set pd=$system.CLS.Property(indP,oref,0)
			Set ivar=$piece(pd,"^")
			Continue:ivar'=aCode
			Set cmd="Set return=oref."_aCode
			Xecute cmd
			Quit
		}
		*/
		// Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("DHCWMR.MR.FrontPageFees")      // P7以下使用
		Set cdef = ##class(%Library.CompiledClass).%OpenId("DHCWMR.MR.FrontPageFees")              // P8以上
		Set inst=cdef.Properties.Count()
		For indP=1:1:inst {
			Set objProperty=cdef.Properties.GetAt(indP)
			Continue:objProperty.Private=1 //私有属性不能序列化
			Set ivar=objProperty.Name
			Continue:ivar'=aCode
			Set cmd="Set return=oref."_aCode
			Xecute cmd
			Quit
		}
	} ElseIf (DataType="P7") {  //附页内容及扩展内容
		Set Parref=%this.%Id()
		Set ChildSub=$o(^DHCWMR.MR.FrontPageI("ADD","IndexCode",Parref," "_aCode,0))
		If ChildSub'="" {
			Set objAdd=##class(DHCWMR.MR.FrontPageAdd).GetObjById(Parref_"||"_ChildSub)
			Quit:'$IsObject(objAdd) return
			Set return=objAdd.PAValue
		}
	} Else {} //备用
	
	Quit return
}

/// Do ##class(DHCWMR.MR.FrontPage).Test(1)
ClassMethod Test(aId As %String) As %String
{
	New (aId)
	Set return=0
	Quit:aId="" return
	
	Set obj=..GetObjById(aId)
	Quit:'$IsObject(obj) return
	//d $System.OBJ.Dump(obj)
	//w obj.GetData("P00010000"),!
	w obj.GetData("P70010000"),!
	w obj.GetData("P70010001"),!
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FPEpisodeID</Value>
</Value>
<Value name="3">
<Value>FPPatientID</Value>
</Value>
<Value name="4">
<Value>FPADMNo</Value>
</Value>
<Value name="5">
<Value>FPHospID</Value>
</Value>
<Value name="6">
<Value>FPMRType</Value>
</Value>
<Value name="7">
<Value>FPDischDate</Value>
</Value>
<Value name="8">
<Value>FPDischTime</Value>
</Value>
<Value name="9">
<Value>FPFilingDate</Value>
</Value>
<Value name="10">
<Value>FPFilingTime</Value>
</Value>
<Value name="11">
<Value>FPIsFiling</Value>
</Value>
<Value name="12">
<Value>FPCodingDate</Value>
</Value>
<Value name="13">
<Value>FPCodingTime</Value>
</Value>
<Value name="14">
<Value>FPIsCoding</Value>
</Value>
<Value name="15">
<Value>FPUpdateDate</Value>
</Value>
<Value name="16">
<Value>FPUpdateTime</Value>
</Value>
<Value name="17">
<Value>FPIsError</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.MR.FrontPageD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.MR.FrontPageD</IdLocation>
<IndexLocation>^DHCWMR.MR.FrontPageI</IndexLocation>
<StreamLocation>^DHCWMR.MR.FrontPageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
