/// 体检操作人员库（方便后期用于人员对照）
Class User.DHCPESSUser Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_PE_SSUser ]
{

Parameter ClassName = "User.DHCPESSUser";

/// 人员代码（工号）
Property SSUCode As %String(MAXLEN = 100) [ Required, SqlFieldName = SSU_Code ];

/// 人员姓名
Property SSUName As %String(MAXLEN = 100) [ Required, SqlFieldName = SSU_Desc ];

/// 人员类型标识（默认用户HIS、第三方检查TRIS、第三方检验TLIS、第三方其他THIS）
Property SSUTypeFlag As %String(MAXLEN = 10) [ SqlFieldName = SSU_HISFlag ];

/// HIS用户对照 指向SS_User
Property SSUUserDR As %String(MAXLEN = 100) [ SqlFieldName = SSU_User_DR ];

/// 扩展信息
Property SSUExpInfo As %String(MAXLEN = 500) [ SqlFieldName = SSU_ExpInfo ];

/// 更新日期
Property SSUUpdateDate As %Date [ SqlFieldName = SSU_UpdateDate ];

/// 更新时间
Property SSUUpdateTime As %Time [ SqlFieldName = SSU_UpdateTime ];

/// 工号+姓名 唯一索引
Index IdxOfCodeName On (SSUCode, SSUName) [ Unique ];

/// 工号+人员类型标识 索引
Index IdxOfCodeType On (SSUCode, SSUTypeFlag);

/// 姓名+人员类型标识 索引
Index IdxOfNameType On (SSUName, SSUTypeFlag);

/// HIS用户指针 索引
Index IdxOfUserDR On SSUUserDR;

/// 取体检操作人员
/// w ##class(User.DHCPESSUser).GetPESSUser()
ClassMethod GetPESSUser(aCode As %String, aName As %String, aTypeFlag As %String = "") As User.DHCPESSUser
{
	New (aCode,aName,aTypeFlag)
	Set return=""
	
	Set ID=""
	If (ID="")&&(aCode'="")&&(aName'=""){
		Set ID=$o(^CF.PE.SSUserI("IdxOfCodeName"," "_$zcvt(aCode,"U")," "_$zcvt(aName,"U"),0))
	}
	If (ID="")&&(aCode'="")&&(aTypeFlag'=""){
		Set ID=$o(^CF.PE.SSUserI("IdxOfCodeType"," "_$zcvt(aCode,"U")," "_$zcvt(aTypeFlag,"U"),0))
	}
	Quit:ID="" return
	
	Set objUser=..GetObjById(ID)
	If $IsObject(objUser) {
		Set return=objUser.%Id()
		Set return=return_"^"_objUser.SSUCode
		Set return=return_"^"_objUser.SSUName
		Set return=return_"^"_objUser.SSUTypeFlag
		Set return=return_"^"_objUser.SSUUserDR
		Set return=return_"^"_objUser.SSUExpInfo
		Quit return
	}
	Quit return
}

/// 更新体检操作人员
/// w ##class(User.DHCPESSUser).SetPESSUser()
ClassMethod SetPESSUser(aCode As %String, aName As %String, aTypeFlag As %String = "") As %String
{
	New (aCode,aName,aTypeFlag)
	Set return=""
	Quit:(aCode="")||(aName="") return
	
	Set return=..GetPESSUser(aCode,aName)
	Quit:return'="" return
	
	Set InputStr=""_"^"_aCode_"^"_aName_"^"_aTypeFlag
	Set ID=..Update(InputStr,"^")
	If (+ID)>0 {
		Set return=..GetPESSUser(aCode,aName)
	} Else {
		Set return=""
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2022-03-25
/// Description:  更新体检操作人员
/// Table：       User.DHCPESSUser
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(User.DHCPESSUser).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID        = $p(aInputStr,aSeparete,1)
	Set Code      = $p(aInputStr,aSeparete,2)
	Set Name      = $p(aInputStr,aSeparete,3)
	Set TypeFlag  = $p(aInputStr,aSeparete,4)
	Set ExpInfo   = ""
	Quit:(Code="")||(Name="") return
	
	Set UserDR=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(Code),0))
	//Set UserDR=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(Name),0))
	
	Set ID=$o(^CF.PE.SSUserI("IdxOfCodeName"," "_$zcvt(Code,"U")," "_$zcvt(Name,"U"),0))
	If ID="" {
		Set obj=##class(User.DHCPESSUser).%New()
	}Else{
		Set obj=##class(User.DHCPESSUser).%OpenId(ID)
		Set TypeFlag=obj.SSUTypeFlag
		Set:UserDR'="" TypeFlag="HIS"
	}
	Quit:'$IsObject(obj) return
	
	Set obj.SSUCode       = Code
	Set obj.SSUName       = Name
	Set obj.SSUTypeFlag   = TypeFlag
	Set obj.SSUUserDR     = UserDR
	Set obj.SSUExpInfo    = ExpInfo
	Set obj.SSUUpdateDate = +$h
	Set obj.SSUUpdateTime = $p($h,",",2)
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
/// CreatDate：   2022-03-25
/// Description:  删除体检操作人员
/// Table：       User.DHCPESSUser
/// Input：       aId : User.DHCPESSUser.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(User.DHCPESSUser).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(User.DHCPESSUser).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="DHCPESSUserDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SSUCode</Value>
</Value>
<Value name="3">
<Value>SSUName</Value>
</Value>
<Value name="4">
<Value>SSUTypeFlag</Value>
</Value>
<Value name="5">
<Value>SSUUserDR</Value>
</Value>
<Value name="6">
<Value>SSUExpInfo</Value>
</Value>
<Value name="7">
<Value>SSUUpdateDate</Value>
</Value>
<Value name="8">
<Value>SSUUpdateTime</Value>
</Value>
</Data>
<DataLocation>^CF.PE.SSUserD</DataLocation>
<DefaultData>DHCPESSUserDefaultData</DefaultData>
<IdLocation>^CF.PE.SSUserD</IdLocation>
<IndexLocation>^CF.PE.SSUserI</IndexLocation>
<StreamLocation>^CF.PE.SSUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
