/// 名称: DHCHAI.IR.OccExpTypeEpd
/// 描述: 职业暴露感染筛查规则
/// 编写者：zhufei
/// 编写日期: 2019-02-20
Class DHCHAI.IR.OccExpTypeEpd Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.OccExpType [ Cardinality = parent, Inverse = ChildEpd ];

/// 规则描述
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 感染类型（"OEPatInfType"）
Property BTEpdTypeDr As DHCHAI.BT.Dictionary [ Required ];

/// 检验项目
Property BTLabItemDr As DHCHAI.DP.LabTCMap [ Required ];

/// 比较运算符（"OECompOperator"）
Property BTLabOperator As DHCHAI.BT.Dictionary;

/// 阳性结果（多个值#分隔）
Property BTLabItemRst As %String(MAXLEN = 200, TRUNCATE = 1);

/// 检验项目2
Property BTLabItem2Dr As DHCHAI.DP.LabTCMap;

/// 比较运算符2
Property BTLabOperator2 As DHCHAI.BT.Dictionary;

/// 阳性结果3
Property BTLabItem2Rst As %String(MAXLEN = 200, TRUNCATE = 1);

/// 检验项目3
Property BTLabItem3Dr As DHCHAI.DP.LabTCMap;

/// 比较运算符3
Property BTLabOperator3 As DHCHAI.BT.Dictionary;

/// 阳性结果3
Property BTLabItem3Rst As %String(MAXLEN = 200, TRUNCATE = 1);

/// 是否有效
Property BTIsActive As %Boolean;

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 更新人
Property BTActUser As DHCHAI.BT.SysUser;

/// 备注
Property BTNote As %String(MAXLEN = 500, TRUNCATE = 1);

/// Creator：     lyao
/// CreatDate：   2019-02-25
/// Description:  暴露感染筛查规则
/// Table：       DHCHAI.IR.OccExpTypeEpd
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// d ##class(DHCHAI.IR.OccExpTypeEpd).Update("1^^559^ceshi2^2^563^2^3^563^2^1^233^8")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set Parref	    = $p(InStr,aSeparete,1)
	Set ChildSub    = $p(InStr,aSeparete,2)
	Set BTDescDr	= $p(InStr,aSeparete,3)  //感染类型
	Set BBTDesc		= $p(InStr,aSeparete,4)  //筛查规则描述
	Set DrTypeDr    = $p(InStr,aSeparete,5)  //检验项目1
	Set Desco       = $p(InStr,aSeparete,6)  //比较运算符1
	Set RstTypeDr   = $p(InStr,aSeparete,7)	 // 结果1
	Set DrtTypeDr	= $p(InStr,aSeparete,8)  //检验项目2
	Set RsttTypeDr	= $p(InStr,aSeparete,9)  //比较运算符2
	Set Desctt      = $p(InStr,aSeparete,10) //结果2
	Set IsActive    = +$p(InStr,aSeparete,11) //有效
	Set Descto      = $p(InStr,aSeparete,12)  //备注
	Set ActDate		= $p(InStr,aSeparete,13)	//日期
	Set ActTime		= $p(InStr,aSeparete,14)	//时间
	Set ActUser		= $p(InStr,aSeparete,15)  //用户
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	Quit:(BTDescDr="")||(BBTDesc="")||(IsActive="") return
	
	Set objParref = ##class(DHCHAI.IR.OccExpType).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objBacType = ##class(DHCHAI.BT.Dictionary).GetObjById(BTDescDr) //感染类型
	Set objDrTypeDr = ##class(DHCHAI.DP.LabTCMap).GetObjById(DrTypeDr) //检验项目
	Set objDrtTypeDr = ##class(DHCHAI.DP.LabTCMap).GetObjById(DrtTypeDr) //检验项目2
	Set objRstTypeDr = ##class(DHCHAI.BT.Dictionary).GetObjById(Desco) //比较运算符
	Set objRsttTypeDr = ##class(DHCHAI.BT.Dictionary).GetObjById(RsttTypeDr) //比较运算符
	Set objActUser =##class(DHCHAI.BT.SysUser).GetObjById(ActUser)
	If (ChildSub="") {
		Set obj=##class(DHCHAI.IR.OccExpTypeEpd).%New()

	} Else {
		Set obj=##class(DHCHAI.IR.OccExpTypeEpd).%OpenId(Parref_"||"_ChildSub)

	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref	       = objParref
	Set obj.BTDesc	       = BBTDesc       //筛查规则描述
	Set obj.BTEpdTypeDr	   = objBacType        //暴露感染类型
	Set obj.BTLabItemDr	   = objDrTypeDr      //检验项目
	Set obj.BTLabItemRst   = RstTypeDr     //比较运算符
	Set obj.BTLabOperator  = objRstTypeDr          //比较运算符
	Set obj.BTLabItem2Dr   = objDrtTypeDr     //检验项目2
	Set obj.BTLabItem2Rst  = Desctt    //比较运算符2	
	Set obj.BTLabOperator2 = objRsttTypeDr        //阳性结果22
	Set obj.BTIsActive	   = IsActive      //是否有效
	Set obj.BTNote	       = Descto        //备注
	Set obj.BTActDate	   = ActDate
	Set obj.BTActTime	   = ActTime
	Set obj.BTActUser      =objActUser
	
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

/// Creator：     lyao
/// CreatDate：   2019-03-01
/// Description:  根据ID描述
/// Table：       DHCHAI.IR.OccExpTypeEpd
/// Input：       ID:    DHCHAI.IR.OccExpTypeEpd.ID
/// Return：      返回Object
/// zw ##class(DHCHAI.IR.OccExpTypeEpd).GetObjById("1||8")
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.OccExpTypeEpd
{
	New (aId)
	Quit:'##class(DHCHAI.IR.OccExpTypeEpd).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.OccExpTypeEpd).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     lyao
/// CreatDate：   2019-03-01
/// Description:  暴露感染筛查规则对照
/// Table：       DHCHAI.DP.LabTestSetMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码 zw ##class(DHCHAI.IR.OccExpTypeEpd).GetObjById("1||33")
/// w ##class(DHCHAI.IR.OccExpTypeEpd).UpdateMap("1||33","559","HCV")  zw ##class(DHCHAI.IR.OccExpTypeEpd).%OpenId("1||33") 
ClassMethod UpdateMap(ID As %String, SetID As %String, DicDesc As %String) As %String
{
	New (ID,SetID,DicDesc)
	Set return=0
	Quit:(ID="")||(SetID="") return
	
	Set objMap =##class(DHCHAI.IR.OccExpTypeEpd).GetObjById("ID")
	Set obj=##class(DHCHAI.IR.OccExpTypeEpd).%OpenId(ID)
	Quit:'$IsObject(obj) return
	Set obj.BTNote	= DicDesc
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

/// Creator：     lyao
/// CreatDate：   2019-03-01
/// Description:  删除暴漏感染筛查规则
/// Table：       DHCHAI.IR.OccExpTypeEpd
/// Input：      
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.OccExpTypeEpd).DeleteById("1||12")
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.OccExpTypeEpd).%DeleteId(aId)
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
<Data name="OccExpTypeEpdDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTDesc</Value>
</Value>
<Value name="3">
<Value>BTEpdTypeDr</Value>
</Value>
<Value name="4">
<Value>BTLabItemDr</Value>
</Value>
<Value name="5">
<Value>BTLabOperator</Value>
</Value>
<Value name="6">
<Value>BTLabItemRst</Value>
</Value>
<Value name="7">
<Value>BTLabItem2Dr</Value>
</Value>
<Value name="8">
<Value>BTLabOperator2</Value>
</Value>
<Value name="9">
<Value>BTLabItem2Rst</Value>
</Value>
<Value name="10">
<Value>BTLabItem3Dr</Value>
</Value>
<Value name="11">
<Value>BTLabOperator3</Value>
</Value>
<Value name="12">
<Value>BTLabItem3Rst</Value>
</Value>
<Value name="13">
<Value>BTIsActive</Value>
</Value>
<Value name="14">
<Value>BTActDate</Value>
</Value>
<Value name="15">
<Value>BTActTime</Value>
</Value>
<Value name="16">
<Value>BTActUser</Value>
</Value>
<Value name="17">
<Value>BTNote</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Epd")</DataLocation>
<DefaultData>OccExpTypeEpdDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Epd")</IdLocation>
<IndexLocation>^DHCHAI.IR.OccExpTypeI("Epd")</IndexLocation>
<StreamLocation>^DHCHAI.IR.OccExpTypeEpdS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
