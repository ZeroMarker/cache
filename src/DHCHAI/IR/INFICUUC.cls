/// 名称: DHCHAI.IR.INFICUUC
/// 描述: 医院感染 ICU泌尿道插管
/// 编写者：chenjb
/// 编写日期: 2017-01-17
Class DHCHAI.IR.INFICUUC Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property IREpisodeDr As DHCHAI.DP.PAAdm;

/// 调查科室
Property IRLocDr As DHCHAI.BT.Location;

/// 插管日期
Property IRIntuDate As %Date;

/// 置管时间
Property IRIntuTime As %Time;

/// 拔管日期
Property IRExtuDate As %Date;

/// 置管时间
Property IRExtuTime As %Time;

/// 尿管类型
Property IRUCType As DHCHAI.BT.Dictionary;

/// 置管人员
Property IROperDoc As DHCHAI.BT.Dictionary;

/// 置管地点
Property IROperLoc As DHCHAI.BT.Dictionary;

/// 是否感染
Property IRIsInf As %Boolean;

/// 感染日期
Property IRInfDate As %Date;

/// 感染症状
Property IRInfSymptoms As DHCHAI.BT.Dictionary;

/// 病原体
Property IRBacteria As DHCHAI.DP.LabBacteria;

/// 更新日期
Property IRUpdateDate As %Date;

/// 更新时间
Property IRUpdateTime As %Time;

/// 更新人
Property IRUpdateUserDr As DHCHAI.BT.SysUser;

/// add 是否审核(单条记录是否审核)
Property IRIsCheck As %Boolean;

Index IdxofIREpisodeDr On IREpisodeDr;

Index IndexIRInfDate On IRInfDate;

Index IndexEpisInfDate On (IREpisodeDr, IRInfDate);

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  根据RowId取医院信息
/// Table：       DHCHAI.IR.INFICUUC
/// Input：       RowID    DHCHAI.IR.INFICUUC
/// Return：      返回obj
/// Others：       
ClassMethod GetObjById(RowId As %String) As DHCHAI.IR.INFICUUC
{
	new (RowId)
	set return=""
	quit:RowId="" return
	quit:'$d(^DHCHAI.IR.INFICUUCD(+RowId)) return
	set obj=##Class(DHCHAI.IR.INFICUUC).%OpenId(+RowId)
	quit obj
}

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  更新
/// Table：       DHCHAI.IR.INFICUUC
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1 RowId 2 IREpisodeDr 3 IRLocDr 4 IRIntuDate 5 IRIntuTime 6 IRExtuDate 7 IRExtuTime 8 IRUCType 9 IROperDoc 10 IROperLoc 11 IRIsInf 12 IRInfDate 13 IRInfSymptoms 14 IRBacteria 15 IRUpdateUserDr
/// w ##class(DHCHAI.IR.INFICUPICC).Update("1^1^22^2017-07-20^^2017-07-21^^56^59^63^67^75^0^^^^","")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	 
	New (InStr,separete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(separete)="" separete=..#SEPARATE
	Set ID=$p(InStr,separete,1)
	Set IREpisodeDr=$p(InStr,separete,2)
	Set IRLocDr=$p(InStr,separete,3)
	If ID="" {
		Set obj=##class(DHCHAI.IR.INFICUUC).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.INFICUUC).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IREpisodeDr=##class(DHCHAI.DP.PAAdm).GetObjById(IREpisodeDr)
	Set obj.IRLocDr = ##class(DHCHAI.BT.Location).GetObjById(IRLocDr)  //调查科室
	
	Set IRIntuDate=$p(InStr,separete,4)
	Set IRIntuTime=$p(InStr,separete,5)
	
	Set IRExtuDate =$p(InStr,separete,6) 
	Set IRExtuTime =$p(InStr,separete,7) 
	Set IRUCType =$p(InStr,separete,8)
	Set IROperDoc =$p(InStr,separete,9)
	Set IROperLoc =$p(InStr,separete,10)
	Set IRIsInf =$p(InStr,separete,11)
	Set IRInfDate =$p(InStr,separete,12) //感染日期
	Set IRInfSymptoms =$p(InStr,separete,13)
	Set IRBacteria =$p(InStr,separete,14)
	Set IRUpdateUserDr =$p(InStr,separete,15)
	Set IRIsCheck =$p(InStr,separete,16)
	//插拔管时间
	//Set:IRIntuDate["-" IRIntuDate=$zdh(IRIntuDate,3)
	//Set:IRIntuDate["/" IRIntuDate=$zdh(IRIntuDate,1)
	Set:IRIntuDate'="" IRIntuDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(IRIntuDate)
	Set obj.IRIntuDate =IRIntuDate
	Set:IRIntuTime[":" IRIntuTime = $zth(IRIntuTime,1)
	Set obj.IRIntuTime = IRIntuTime
	//Set:IRExtuDate["-" IRExtuDate=$zdh(IRExtuDate,3)
	//Set:IRExtuDate["/" IRExtuDate=$zdh(IRExtuDate,1)
	Set:IRExtuDate'="" IRExtuDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(IRExtuDate)
	Set obj.IRExtuDate =IRExtuDate
	Set:IRExtuTime[":" IRExtuTime = $zth(IRExtuTime,1)
	Set obj.IRExtuTime = IRExtuTime
	//管类型
	Set objIRUCType=##class(DHCHAI.BT.Dictionary).GetObjById(IRUCType)
	Set obj.IRUCType = objIRUCType
	//置管人员
	Set objIROperDoc=##class(DHCHAI.BT.Dictionary).GetObjById(IROperDoc)
	Set obj.IROperDoc = objIROperDoc
	Set objIROperLoc=##class(DHCHAI.BT.Dictionary).GetObjById(IROperLoc)
	Set obj.IROperLoc = objIROperLoc
	//是否感染
	Set obj.IRIsInf = IRIsInf
	//Set:IRInfDate["-" IRInfDate=$zdh(IRInfDate,3)
	//Set:IRInfDate["/" IRInfDate=$zdh(IRInfDate,1)
	Set:IRInfDate'="" IRInfDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(IRInfDate)
	Set obj.IRInfDate =IRInfDate
	//感染症状
	Set objIRInfSymptoms=##class(DHCHAI.BT.Dictionary).GetObjById(IRInfSymptoms)
	Set obj.IRInfSymptoms = objIRInfSymptoms
	//病原体
	Set objIRBacteria =##class(DHCHAI.DP.LabBacteria).GetObjById(IRBacteria)
	Set obj.IRBacteria = objIRBacteria
	//更新时间人员
	Set obj.IRUpdateDate = +$h
	Set obj.IRUpdateTime = $p($h,",",2)
	Set objUpdateUser=##class(DHCHAI.BT.SysUser).GetObjById(IRUpdateUserDr)
	Set obj.IRUpdateUserDr = objUpdateUser
	Set obj.IRIsCheck =IRIsCheck
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

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  删除
/// Table：       DHCHAI.IR.INFICUUC
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCHAI.IR.INFICUUC).%DeleteId(+Id)
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
<Data name="INFICUUCDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IREpisodeDr</Value>
</Value>
<Value name="3">
<Value>IRLocDr</Value>
</Value>
<Value name="4">
<Value>IRIntuDate</Value>
</Value>
<Value name="5">
<Value>IRExtuDate</Value>
</Value>
<Value name="6">
<Value>IRUCType</Value>
</Value>
<Value name="7">
<Value>IROperDoc</Value>
</Value>
<Value name="8">
<Value>IROperLoc</Value>
</Value>
<Value name="9">
<Value>IRIsInf</Value>
</Value>
<Value name="10">
<Value>IRInfDate</Value>
</Value>
<Value name="11">
<Value>IRInfSymptoms</Value>
</Value>
<Value name="12">
<Value>IRBacteria</Value>
</Value>
<Value name="13">
<Value>IRUpdateDate</Value>
</Value>
<Value name="14">
<Value>IRUpdateTime</Value>
</Value>
<Value name="15">
<Value>IRUpdateUserDr</Value>
</Value>
<Value name="16">
<Value>IRIntuTime</Value>
</Value>
<Value name="17">
<Value>IRExtuTime</Value>
</Value>
<Value name="18">
<Value>IRIsCheck</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.INFICUUCD</DataLocation>
<DefaultData>INFICUUCDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.INFICUUCD</IdLocation>
<IndexLocation>^DHCHAI.IR.INFICUUCI</IndexLocation>
<StreamLocation>^DHCHAI.IR.INFICUUCS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
