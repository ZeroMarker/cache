/// 站点医嘱项设置表/对照表
Class User.DHCPESTOrderSetting Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Not ProcedureBlock, SqlTableName = DHC_PE_STOrderSetting ]
{

Parameter ClassName = "User.DHCPESTOrderSetting";

/// 医嘱项（指向表ARC_ItmMast）
Property STOSItmMastDR As %String [ Required, SqlFieldName = STOS_ItmMastDR ];

/// 医嘱科室ID
Property STOSLocDR As %String [ SqlFieldName = STOS_LocID ];

/// 医嘱子类（指向表ARC_ItemCat）
Property STOSItmCatDR As %String [ Required, SqlFieldName = STOS_ItmCatDR ];

/// 医嘱类型（指向表ARC_ItemCat.ARCIC_OrderType）
Property STOSOrderType As %String [ Required, SqlFieldName = STOS_OrderType ];

/// 站点
Property STOSStationDR As User.DHCPEStation [ Required, SqlFieldName = STOS_StationDR ];

/// 标准项目代码（指向HM.BT.ExamItemCode.EICCode）
Property STOSItemCode As %String [ SqlFieldName = STOS_ItemCode ];

/// 标准项目名称（指向HM.BT.ExamItemCode.EICDesc）
Property STOSItemDesc As %String [ SqlFieldName = STOS_ItemDesc ];

/// 是否有效
Property STOSActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = STOS_Active ];

/// 更新日期
Property STOSUpdateDate As %Date [ SqlFieldName = STOS_UpdateDate ];

/// 更新时间
Property STOSUpdateTime As %Time [ SqlFieldName = STOS_UpdateTime ];

/// 更新人 指向SS_User
Property STOSUpdateUserDR As %String [ SqlFieldName = STOS_UpdateUserDR ];

/// 生成站点项目标记
Property STOSNewOrdFlag As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = STOS_NewOrdFlag ];

/// 生成站点项目日期
Property STOSNewOrdDate As %Date [ SqlFieldName = STOS_NewOrdDate ];

/// 生成站点项目时间
Property STOSNewOrdTime As %Time [ SqlFieldName = STOS_NewOrdTime ];

/// 生成站点项目人 指向SS_User
Property STOSNewOrdUserDR As %String [ SqlFieldName = STOS_NewOrdUserDR ];

/// 报告格式（RF-NOR普通、RF-CAT多层、RF-LIS检验、RF-RIS检查、RF-EKG心电、RF-PIS病理）
Property STOSReportFormat As %String [ SqlFieldName = STOS_ReportFormat ];

/// 导诊单类别
Property STOSUsherItemCatDR As User.DHCPEUsherItemCat [ SqlFieldName = STOS_UsherItemCatDR ];

/// 医嘱项索引
Index IdxOfItmMastDR On (STOSItmMastDR, STOSLocDR) [ Unique ];

/// 站点医嘱项索引
Index IdxOfStationDR On STOSStationDR;

/// Creator：     zhufei
/// CreatDate：   2021-12-08
/// Description:  更新站点医嘱项设置
/// Table：       DHC_PE_STOrderSetting
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(User.DHCPESTOrderSetting).Update()
ClassMethod Update(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aDelimiter)="" aDelimiter="^"
	Set ID            = $p(aInputStr,aDelimiter,1)    //ID
	Set ItmMastDR     = $p(aInputStr,aDelimiter,2)    //医嘱项ID
	Set LocDR         = $p(aInputStr,aDelimiter,3)    //科室ID
	Set ItmCatDR      = $p(aInputStr,aDelimiter,4)    //医嘱子类ID
	Set OrderType     = $p(aInputStr,aDelimiter,5)    //医嘱类型
	Set StationDR     = $p(aInputStr,aDelimiter,6)    //站点ID
	Set ItemCode      = $p(aInputStr,aDelimiter,7)    //标准项目代码
	Set ItemDesc      = $p(aInputStr,aDelimiter,8)    //标准项目描述
	Set Active        = $p(aInputStr,aDelimiter,9)    //是否有效
	Set UpdateUserDR  = $p(aInputStr,aDelimiter,10)   //更新人
	Set ReportFormat  = $p(aInputStr,aDelimiter,11)   //报告格式
	Set UsherItemCatDR= $p(aInputStr,aDelimiter,12)   //导诊单类别
	Quit:(ItmMastDR="")||(LocDR="")||(OrderType="")||(StationDR="") return
	
	Set objStation=##class(User.DHCPEStation).GetObjById(StationDR)
	Quit:'$IsObject(objStation) return
	Set objUsherItemCat=##class(User.DHCPEUsherItemCat).GetObjById(UsherItemCatDR)
	Set Active=$s(Active["Y":"Y",1:"N")
	
	Set tID=$o(^User.DHCPESTOrderSettingI("IdxOfItmMastDR"," "_$zcvt(ItmMastDR,"U")," "_$zcvt(LocDR,"U"),0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -101  //返回错误提示：医嘱项不唯一
	
	If ID="" {
		Set obj=##class(User.DHCPESTOrderSetting).%New()
	}Else{
		Set obj=##class(User.DHCPESTOrderSetting).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.STOSItmMastDR      = ItmMastDR
	Set obj.STOSLocDR          = LocDR
	Set obj.STOSItmCatDR       = ItmCatDR
	Set obj.STOSOrderType      = OrderType
	Set obj.STOSStationDR      = objStation
	Set obj.STOSItemCode       = ItemCode
	Set obj.STOSItemDesc       = ItemDesc
	Set obj.STOSActive         = Active
	Set obj.STOSUpdateDate     = +$h
	Set obj.STOSUpdateTime     = $p($h,",",2)
	Set obj.STOSUpdateUserDR   = UpdateUserDR
	Set obj.STOSReportFormat   = ReportFormat
	Set obj.STOSUsherItemCatDR = objUsherItemCat
	
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
/// CreatDate：   2021-12-08
/// Description:  更新生成站点项目标记
/// Table：       DHC_PE_STOrderSetting
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(User.DHCPESTOrderSetting).UpdateNewOrdFlag()
ClassMethod UpdateNewOrdFlag(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aDelimiter)="" aDelimiter="^"
	Set ID            = $p(aInputStr,aDelimiter,1)    //ID
	Set NewOrdFlag    = $p(aInputStr,aDelimiter,2)    //生成站点项目标记
	Set NewOrdUserDR  = $p(aInputStr,aDelimiter,3)    //生成站点项目人
	Quit:(ID="") return
	
	Set NewOrdFlag=$s(NewOrdFlag["Y":"Y",1:"N")
	
	If ID="" {
		Set obj=##class(User.DHCPESTOrderSetting).%New()
	}Else{
		Set obj=##class(User.DHCPESTOrderSetting).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.STOSNewOrdFlag     = NewOrdFlag
	Set obj.STOSNewOrdDate     = +$h
	Set obj.STOSNewOrdTime     = $p($h,",",2)
	Set obj.STOSNewOrdUserDR   = NewOrdUserDR
	
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
/// CreatDate：   2021-12-08
/// Description:  删除站点医嘱项设置
/// Table：       DHC_PE_STOrderSetting
/// Input：       aId：ID
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(User.DHCPESTOrderSetting).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc=##class(User.DHCPESTOrderSetting).%DeleteId(aId)
	If $system.Status.IsError(sc) {  //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="DHCPESTOrderSettingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>STOSItmMastDR</Value>
</Value>
<Value name="3">
<Value>STOSLocDR</Value>
</Value>
<Value name="4">
<Value>STOSItmCatDR</Value>
</Value>
<Value name="5">
<Value>STOSOrderType</Value>
</Value>
<Value name="6">
<Value>STOSStationDR</Value>
</Value>
<Value name="7">
<Value>STOSItemCode</Value>
</Value>
<Value name="8">
<Value>STOSItemDesc</Value>
</Value>
<Value name="9">
<Value>STOSActive</Value>
</Value>
<Value name="10">
<Value>STOSUpdateDate</Value>
</Value>
<Value name="11">
<Value>STOSUpdateTime</Value>
</Value>
<Value name="12">
<Value>STOSUpdateUserDR</Value>
</Value>
<Value name="13">
<Value>STOSNewOrdFlag</Value>
</Value>
<Value name="14">
<Value>STOSNewOrdDate</Value>
</Value>
<Value name="15">
<Value>STOSNewOrdTime</Value>
</Value>
<Value name="16">
<Value>STOSNewOrdUserDR</Value>
</Value>
<Value name="17">
<Value>STOSReportFormat</Value>
</Value>
<Value name="18">
<Value>STOSUsherItemCatDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCPESTOrderSettingD</DataLocation>
<DefaultData>DHCPESTOrderSettingDefaultData</DefaultData>
<IdLocation>^User.DHCPESTOrderSettingD</IdLocation>
<IndexLocation>^User.DHCPESTOrderSettingI</IndexLocation>
<StreamLocation>^User.DHCPESTOrderSettingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
