/// 病案收费表
Class DHCWMR.MF.FeeRecord Extends (%Persistent, DHCWMR.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildDTL As DHCWMR.MF.FeeRecordDtl [ Cardinality = children, Inverse = Parref ];

/// 病案类型
Property FRMrTypeDr As DHCWMR.SS.MrType;

/// 病案主表
Property FRMainDr As DHCWMR.SS.Main;

/// 病案收费项
Property FRFeeItemDr As DHCWMR.MF.FeeItem;

/// 收费指针(指向DHC_InvprtMedical表)
Property FRInvprtDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 收费状态（正常N、退费C）
Property FRStatus As %String(MAXLEN = 100, TRUNCATE = 1);

/// 收费日期
Property FRFeeDate As %Date;

/// 收费时间
Property FRFeeTime As %Time;

/// 收费员(指向SS_User)
Property FRFeeUserID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 收费科室(指向CT_Loc)
Property FRFeeLocID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 退费日期
Property FRRetDate As %Date;

/// 退费时间
Property FRRetTime As %Time;

/// 退费员(指向SS_User)
Property FRRetUserID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 退费科室(指向CT_Loc)
Property FRRetLocID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 总金额
Property FRMoney As %String(MAXLEN = 100, TRUNCATE = 1);

/// 收费日期索引
Index IndexFeeDate On FRFeeDate;

/// 病案号索引
Index IndexMainDr On FRMainDr;

/// 收费指针索引
Index IndexInvprtDr On FRInvprtDr;

/// Creator:          李毅
/// CreateDate:       2015-07-21
/// Description:      根据ID病案收费信息
/// OperationTable:   DHCWMR.MF.FeeRecord
/// Input:            Id : DHCWMR.MF.FeeRecord.ID
/// Output:           返回Object
/// w ##Class(DHCWMR.MF.FeeRecord).GetObjById(21)
ClassMethod GetObjById(aId As %String) As DHCWMR.MF.FeeRecord
{
	new (aId)
	set return=""
	quit:'##class(DHCWMR.MF.FeeRecord).%ExistsId(aId) return
	set obj=##Class(DHCWMR.MF.FeeRecord).%OpenId(aId)
	quit:'$IsObject(obj) return
	quit:'$IsObject(obj.FRMainDr) return
	if obj.FRMainDr.SMIsActive'=1 {
		Set objMain=##class(DHCWMR.SS.Main).GetActMainByID(obj.FRMainDr.%Id())
		If $IsObject(objMain){
			Set obj.FRMainDr=objMain
			Set sc=obj.%Save()
			If $System.Status.IsError(sc) {  //检查Save是否成功
		   		Set return=""
			} Else {
				Set return=obj
			}
		}
	}
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator:      李毅
/// CreateDate:   2015-07-21
/// Description:  更新病案收费信息
/// Table：       DHCWMR.MF.FeeRecord
/// Input：       InputStr : %Id^MrTypeDr^MrNo^FeeItemDr^InvprtDr^Status^FeeDate^FeeTime^FeeUserID^FeeLocID^RetDate^RetTime^RetUserID^RetLocID^Money
///               Separate ：分隔符
/// Return：      返回新纪录的%Id()值
/// w ##class(DHCWMR.MF.FeeRecord).Update("","")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID			=$p(aInputStr,aSeparate,1)
	Set MrTypeDr	=$p(aInputStr,aSeparate,2)
	Set MainID		=$p(aInputStr,aSeparate,3)
	Set FeeItemDr	=$p(aInputStr,aSeparate,4)
	Set InvprtDr	=$p(aInputStr,aSeparate,5)	
	Set Status		=$p(aInputStr,aSeparate,6)
	Set FeeDate		=$p(aInputStr,aSeparate,7)
	set:FeeDate["-" FeeDate=$zdh(FeeDate,3)
	set:FeeDate["/" FeeDate=$zdh(FeeDate,4)
	Set FeeTime		=$p(aInputStr,aSeparate,8)
	set:FeeTime[":" FeeTime=$zth(FeeTime,1)
	Set FeeUserID	=$p(aInputStr,aSeparate,9)	
	Set FeeLocID	=$p(aInputStr,aSeparate,10)
	Set RetDate		=$p(aInputStr,aSeparate,11)
	set:RetDate["-" RetDate=$zdh(RetDate,3)
	set:RetDate["/" RetDate=$zdh(RetDate,4)
	//set:RetDate="" RetDate=+$h
	Set RetTime		=$p(aInputStr,aSeparate,12)
	set:RetTime[":" RetTime=$zth(RetTime,1)
	//set:RetTime="" RetTime=$p($h,",",2)
	Set RetUserID	=$p(aInputStr,aSeparate,13)	
	Set RetLocID	=$p(aInputStr,aSeparate,14)	
	Set Money		=$p(aInputStr,aSeparate,15)
	Quit:MainID="" return
	
	Set objMain=##Class(DHCWMR.SS.Main).GetObjById(MainID)
	Quit:'$IsObject(objMain) return
	Quit:'$IsObject(objMain.SMMrType) return
	Set MrTypeDr=objMain.SMMrType.%Id()
	
	Set objFeeItem=##class(DHCWMR.MF.FeeItem).GetObjById(FeeItemDr)
	Quit:'$IsObject(objFeeItem) return
	
	If ID="" {
		Set obj=##class(DHCWMR.MF.FeeRecord).%New()
	} Else {
		Set obj=##class(DHCWMR.MF.FeeRecord).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return

	Set obj.FRMrTypeDr	=objMain.SMMrType
	Set obj.FRMainDr	=objMain	
	Set obj.FRFeeItemDr	=objFeeItem
	Set obj.FRInvprtDr	=InvprtDr	
	Set obj.FRStatus	=Status	
	Set obj.FRFeeDate	=FeeDate	
	Set obj.FRFeeTime	=FeeTime	
	Set obj.FRFeeUserID	=FeeUserID	
	Set obj.FRFeeLocID	=FeeLocID	
	Set obj.FRRetDate	=RetDate	
	Set obj.FRRetTime	=RetTime	
	Set obj.FRRetUserID	=RetUserID	
	Set obj.FRRetLocID	=RetLocID	
	Set obj.FRMoney		=Money
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}	
	Quit return
}

/// Creator:      李毅
/// CreateDate:   2015-07-21
/// Description:  删除病案收费信息
/// Table：       DHCWMR.MF.FeeRecord
/// Input：       Id : DHCWMR.MF.FeeRecord.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.MF.FeeRecord).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

/// 处理因修改病案号导致MainDr改变数据处理
/// w ##class(DHCWMR.MF.FeeRecord).UpdateErrorMainDr(363)
ClassMethod UpdateErrorMainDr(aHisMainIDs As %String) As %String
{
	New (aHisMainIDs)
	Set return=0
	Quit:(aHisMainIDs="") return
	
	For indM=1:1:$l(aHisMainIDs,",") {
		Set xMainID=$p(aHisMainIDs,",",indM)
		Continue:xMainID=""
		
		Set xRecordID=""
		For {
			Set xRecordID=$o(^DHCWMR.MF.FeeRecordI("IndexMainDr",xMainID,xRecordID))
			Quit:xRecordID=""
			Set obj=..GetObjById(xRecordID)
			Set:'$IsObject(obj) return=-1
		}
	}
	Quit:return<0 return
	
	Set return=1
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FRMrTypeDr</Value>
</Value>
<Value name="3">
<Value>FRMainDr</Value>
</Value>
<Value name="4">
<Value>FRFeeItemDr</Value>
</Value>
<Value name="5">
<Value>FRInvprtDr</Value>
</Value>
<Value name="6">
<Value>FRStatus</Value>
</Value>
<Value name="7">
<Value>FRFeeDate</Value>
</Value>
<Value name="8">
<Value>FRFeeTime</Value>
</Value>
<Value name="9">
<Value>FRFeeUserID</Value>
</Value>
<Value name="10">
<Value>FRFeeLocID</Value>
</Value>
<Value name="11">
<Value>FRRetDate</Value>
</Value>
<Value name="12">
<Value>FRRetTime</Value>
</Value>
<Value name="13">
<Value>FRRetUserID</Value>
</Value>
<Value name="14">
<Value>FRRetLocID</Value>
</Value>
<Value name="15">
<Value>FRMoney</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.MF.FeeRecordD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.MF.FeeRecordD</IdLocation>
<IndexLocation>^DHCWMR.MF.FeeRecordI</IndexLocation>
<StreamLocation>^DHCWMR.MF.FeeRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
