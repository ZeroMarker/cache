/// 名称: DHCMA.CPW.BT.PathLoc
/// 描述: 科室常用路径维护
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.BT.PathLoc Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 科室ID（指向DHCMA.CPW.EP.Location.OID）
Property PDLocID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 路径指针
Property PDPathDr As DHCMA.CPW.BT.PathMast [ Required ];

/// 有效标志
Property PDIsActive As %Boolean;

/// 处置日期
Property PDActDate As %Date;

/// 处置时间
Property PDActTime As %Time;

/// 处置人ID（指向DHCMA.CPW.EP.SSUser.OID）
Property PDActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 科室路径 索引
Index IdxofLocPath On (PDLocID, PDPathDr) [ Unique ];

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  根据ID取对象
/// Table：       DHCMA.CPW.BT.PathLoc
/// Input：       aId : DHCMA.CPW.BT.PathLoc.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.BT.PathForm).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.PathLoc
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.PathLoc).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.PathLoc).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  更新实体对象
/// Table：       DHCMA.CPW.BT.PathLoc
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathLoc).Update("^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID			 = $p(aInputStr,aSeparete,1)
	Set PDLocID      = $p(aInputStr,aSeparete,2)
	Set PDPathDr     = $p(aInputStr,aSeparete,3)	
	Set PDIsActive   = +$p(aInputStr,aSeparete,4)
	Set PDActDate    = $p(aInputStr,aSeparete,5)
	Set PDActTime	 = $p(aInputStr,aSeparete,6)
	Set PDActUserID  = $p(aInputStr,aSeparete,7)
	
	
	Set:PDActDate'="" PDActDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(PDActDate)
	Set:PDActTime[":" PDActTime = $zth(PDActTime,1)
	Set:PDActDate="" PDActDate=+$h
	Set:PDActTime="" PDActTime=$p($h,",",2)
	
	Quit:(PDPathDr="")||(PDLocID="") -1
	Set objPathMast = ##class(DHCMA.CPW.BT.PathMast).GetObjById(PDPathDr)
	Quit:'$Isobject(objPathMast) -1
	Set BTAdmType =objPathMast.BTAdmType
	Set objLoc=##class(DHCMA.Util.EPx.Location).GetObjByOID(PDLocID) 
	Quit:'$Isobject(objLoc) -1
	Set AdmLocType=objLoc.BTAdmType
	Quit:AdmLocType="" -3
	Quit:BTAdmType'[AdmLocType -4		// 根据路径设置的就诊路径允许关联对应就诊类型科室下
	
	Set tID=$o(^DHCMA.CPW.BT.PathLocI("IdxofLocPath"," "_$zcvt(PDLocID,"U"),PDPathDr,0))
	Quit:(tID'="")&(ID'=tID) -2

	If ID="" {
		Set obj=##class(DHCMA.CPW.BT.PathLoc).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.BT.PathLoc).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.PDLocID	     = PDLocID
	Set obj.PDPathDr	 = objPathMast  //对象
	Set obj.PDIsActive   = PDIsActive
	Set obj.PDActDate	 = PDActDate
	Set obj.PDActTime	 = PDActTime
	Set obj.PDActUserID  = PDActUserID
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  删除对象信息
/// Table：       DHCMA.CPW.BT.PathLoc
/// Input：       aId : DHCMA.CPW.BT.PathLoc.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathLoc).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.BT.PathLoc).%DeleteId(aId)
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
<Data name="PathLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PDLocID</Value>
</Value>
<Value name="3">
<Value>PDPathDr</Value>
</Value>
<Value name="4">
<Value>PDIsActive</Value>
</Value>
<Value name="5">
<Value>PDActDate</Value>
</Value>
<Value name="6">
<Value>PDActTime</Value>
</Value>
<Value name="7">
<Value>PDActUserID</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.BT.PathLocD</DataLocation>
<DefaultData>PathLocDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.BT.PathLocD</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.PathLocI</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.PathLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
