/// 名称: DHCHAI.IR.ICULog
/// 描述: ICU三管日志表()的业务封装，定义常用属性和方法
/// 编写者：chenjb
/// 编写日期: 2017-01-17
Class DHCHAI.IR.ICULog Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 数据来源(1医嘱、2插拔管记录)
Property ILDatType As %Integer;

/// 调查科室
Property ILLocDr As DHCHAI.BT.Location;

/// 调查日期
Property ILDate As %Date;

/// 使用呼吸机人数
Property ILIsVAP As %Integer;

/// 脐/中心静脉置管人数
Property ILIsPICC As %Integer;

/// 泌尿道插管人数
Property ILIsUC As %Integer;

/// 手术人数
Property ILIsOper As %Integer;

/// 入科人数
Property ILNewCnt As %Integer;

/// 在科人数
Property ILAdmCnt As %Integer;

/// 出科人数
Property ILOutCnt As %Integer;

/// 体重分类（新生儿）
/// 1 : <=1000
/// 2 : 1000~1500
/// 3 : 1501~2500
/// 4 : >2500
/// 5 : 未填写
Property ILWtCat As %Integer;

/// 更新日期
Property ILLogDate As %Date;

/// 更新时间
Property ILLogTime As %Time;

/// 更新人
Property ILLogUser As DHCHAI.BT.SysUser;

/// 阿普加(Apgar)评分分组（新生儿）
/// 1 : 8-10
/// 2 : 4-7
/// 3 : 0-3
/// 4 : 未填写
Property ILApGroup As %Integer;

/// 非血透管人数
Property ILIsCVC As %Integer;

/// 血透置管人数
Property ILIsCRRT As %Integer;

/// 输液港置管人数
Property ILIsPORT As %Integer;

/// 静脉置管总人数
Property ILIsJMZGSum As %Integer;

Index IndexLocDate On (ILLocDr, ILDate);

Index IndexLocDateWtCat On (ILLocDr, ILDate, ILWtCat);

Index IndexLocDateApGroup On (ILLocDr, ILDate, ILApGroup);

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  根据RowId取医院信息
/// Table：       DHCHAI.IR.ICULog
/// Input：       RowID    DHCHAI.IR.ICULog
/// Return：      返回obj
/// Others：       
ClassMethod GetObjById(RowId As %String) As DHCHAI.IR.ICULog
{
	new (RowId)
	set return=""
	quit:RowId="" return
	quit:'$d(^DHCHAI.IR.ICULogD(+RowId)) return
	set obj=##Class(DHCHAI.IR.ICULog).%OpenId(+RowId)
	quit obj
}

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  更新
/// Table：       DHCHAI.IR.CCInfItem
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1 RowId 2 ILDatType 3 ILLocDr 4 ILDate 5 ILIsVAP 6 ILIsPICC 7 ILIsUC 8 ILIsOper 9 ILNewCnt
/// 10 ILAdmCnt 11 ILOutCnt 12 ILWtCat 13 ILLogDate 14 ILLogTime 15 ILLogUser
/// w ##class(DHCHAI.IR.ICULog).Update("^1^1^1^1^2017-01-16^11:33^1^处置意见^1^2017-01-17^11:43^1^反馈意见","")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	New (InStr,separete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(separete)="" separete=..#SEPARATE
	Set ID        = $p(InStr,separete,1)
	Set ILDatType = $p(InStr,separete,2)	
	Set ILLocDr   = $p(InStr,separete,3)
	Set ILDate    = $p(InStr,separete,4)
	Set ILIsVAP   = $p(InStr,separete,5)
	Set ILIsPICC  = $p(InStr,separete,6)
	Set ILIsUC    = $p(InStr,separete,7)
	Set ILIsOper  = $p(InStr,separete,8)
	Set ILNewCnt  = $p(InStr,separete,9)
	Set ILAdmCnt  = $p(InStr,separete,10)
	Set ILOutCnt  = $p(InStr,separete,11)
	Set ILWtCat   = $p(InStr,separete,12)
	Set ILLogDate = $p(InStr,separete,13)
	Set ILLogTime = $p(InStr,separete,14)
	Set ILLogUser = $p(InStr,separete,15)
	Set ApGroup	  = $p(InStr,separete,16)
	Set ILIsCVC   = $p(InStr,separete,17)
	Set ILIsCRRT  = $p(InStr,separete,18)
	Set ILIsPORT  = $p(InStr,separete,19)
	Set ILIsJMZGSum = $p(InStr,separete,20)
	
	Quit:(ILLocDr="")||(ILDate="") return
	
	Set:ILLogDate="" ILLogDate = +$h
	Set:ILLogTime="" ILLogTime=$p($h,",",2)
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(ILLocDr)
	Quit:'$IsObject(objLoc) return
	Set IsNICU=objLoc.BTIsNICU
	
	Set objUser=##class(DHCHAI.BT.SysUser).GetObjById(ILLogUser)
	
	//Set:ILDate["-" ILDate=$zdh(ILDate,3)
	//Set:ILDate["/" ILDate=$zdh(ILDate,1)
	Set:ILDate'="" ILDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ILDate)
	Set:ILDate="" ILDate=+$h
	If (ILWtCat=""){
		//科室+日期 唯一索引
		Set xID=$o(^DHCHAI.IR.ICULogI("IndexLocDateApGroup",ILLocDr,ILDate,+ApGroup,""))
		Set:xID'="" ID=xID
	}elseIf (ApGroup=""){
		Set xID=$o(^DHCHAI.IR.ICULogI("IndexLocDateWtCat",ILLocDr,ILDate,+ILWtCat,""))
		Set:xID'="" ID=xID
	}
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.ICULog).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.ICULog).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return	
	
	Set obj.ILDatType = +ILDatType	
	Set obj.ILLocDr   = objLoc
	Set obj.ILDate    = ILDate
	Set obj.ILIsVAP   = ILIsVAP
	Set obj.ILIsPICC  = ILIsPICC
	Set obj.ILIsUC    = ILIsUC
	Set obj.ILIsOper  = ILIsOper
	Set obj.ILNewCnt  = ILNewCnt
	Set obj.ILAdmCnt  = ILAdmCnt
	Set obj.ILOutCnt  = ILOutCnt
	Set obj.ILWtCat   = +ILWtCat
	Set obj.ILLogDate = ILLogDate
	Set obj.ILLogTime = ILLogTime
	Set obj.ILLogUser = objUser
	Set obj.ILApGroup = +ApGroup
	Set obj.ILIsCVC   = +ILIsCVC
	Set obj.ILIsCRRT  = +ILIsCRRT
	Set obj.ILIsPORT  = +ILIsPORT
	Set obj.ILIsJMZGSum = +ILIsJMZGSum
	
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
/// Table：       DHCHAI.IR.ICULog
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCHAI.IR.ICULog).%DeleteId(+Id)
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
<Data name="ICULogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ILDatType</Value>
</Value>
<Value name="3">
<Value>ILLocDr</Value>
</Value>
<Value name="4">
<Value>ILDate</Value>
</Value>
<Value name="5">
<Value>ILIsVAP</Value>
</Value>
<Value name="6">
<Value>ILIsPICC</Value>
</Value>
<Value name="7">
<Value>ILIsUC</Value>
</Value>
<Value name="8">
<Value>ILIsOper</Value>
</Value>
<Value name="9">
<Value>ILNewCnt</Value>
</Value>
<Value name="10">
<Value>ILAdmCnt</Value>
</Value>
<Value name="11">
<Value>ILOutCnt</Value>
</Value>
<Value name="12">
<Value>ILWtCat</Value>
</Value>
<Value name="13">
<Value>ILLogDate</Value>
</Value>
<Value name="14">
<Value>ILLogTime</Value>
</Value>
<Value name="15">
<Value>ILLogUser</Value>
</Value>
<Value name="16">
<Value>ILApGroup</Value>
</Value>
<Value name="17">
<Value>ILIsCVC</Value>
</Value>
<Value name="18">
<Value>ILIsCRRT</Value>
</Value>
<Value name="19">
<Value>ILIsPORT</Value>
</Value>
<Value name="20">
<Value>ILIsJMZGSum</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.ICULogD</DataLocation>
<DefaultData>ICULogDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.ICULogD</IdLocation>
<IndexLocation>^DHCHAI.IR.ICULogI</IndexLocation>
<StreamLocation>^DHCHAI.IR.ICULogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
