/// 名称: DHCMA.CPW.BT.PathForm
/// 描述: 临床路径表单（版本）
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.BT.PathForm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 表单阶段
Relationship ChildEp As DHCMA.CPW.BT.PathFormEp [ Cardinality = children, Inverse = Parref ];

/// 症候诊断
Relationship ChildSymp As DHCMA.CPW.BT.PathFormSymp [ Cardinality = children, Inverse = Parref ];

/// 路径指针
Property FormPathDr As DHCMA.CPW.BT.PathMast [ Required ];

/// 参考费用
Property FormCost As %String(MAXLEN = 50, TRUNCATE = 1);

/// 标准住院日
Property FormDays As %String(MAXLEN = 50, TRUNCATE = 1);

/// 适用对象
Property FormApply As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 进入路径标准
Property FormHelpDoc As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 是否有效
Property FormIsActive As %Boolean;

/// 处置日期
Property FormActDate As %Date;

/// 处置时间
Property FormActTime As %Time;

/// 处置人（指向DHCMA.CPW.EP.SSUser.OID）
Property FormActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 路径版本
Property FormVersion As %Integer;

/// 发布标志
Property FormIsOpen As %Boolean;

/// 发布日期
Property FormVerDate As %Date;

/// 发布时间
Property FormVerTime As %Time;

/// 发布人（指向DHCMA.CPW.EP.SSUser.OID）
Property FormVerUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 表单OID（主要处理旧系统升级问题）
Property FormOID As %String(MAXLEN = 50, TRUNCATE = 1);

Index IdxofVersion On (FormPathDr, FormVersion);

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  根据ID取对象
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       aId : DHCMA.CPW.BT.PathForm.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.BT.PathForm).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.PathForm
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.PathForm).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.PathForm).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2018-08-24
/// Description:  更新实体对象
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathForm).Update("^1^2000-3000元^10-20天^试用对象符合咳嗽^doc^1^2018-08-29^15:24^9!!1^2^0^^^^")
/// w ##class(DHCMA.CPW.BT.PathForm).Update("^1^^^^^1^^^9!!1^^0^^^^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID			 = $p(aInputStr,aSeparete,1)
	Set FormPathDr   = +$p(aInputStr,aSeparete,2)
	Set FormCost     = $p(aInputStr,aSeparete,3)
	Set FormDays     = $p(aInputStr,aSeparete,4)
	Set FormApply    = $p(aInputStr,aSeparete,5)
	Set FormHelpDoc	 = $p(aInputStr,aSeparete,6)
	Set FormIsActive = +$p(aInputStr,aSeparete,7)
	Set FormActDate  = $p(aInputStr,aSeparete,8)
	Set FormActTime	 = $p(aInputStr,aSeparete,9)
	Set FormActUserID= $p(aInputStr,aSeparete,10)
	Set FormVersion  = +$p(aInputStr,aSeparete,11)
	Set FormIsOpen   = +$p(aInputStr,aSeparete,12)
	Set FormVerDate  = $p(aInputStr,aSeparete,13)
	Set FormVerTime	 = $p(aInputStr,aSeparete,14)
	Set FormVerUserID= $p(aInputStr,aSeparete,15)	
	Set FormOID      = $p(aInputStr,aSeparete,16)
	
	Set:FormActDate'="" FormActDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(FormActDate)
	Set:FormActTime[":" FormActTime = $zth(FormActTime,1)
	Set:FormActDate="" FormActDate=+$h
	Set:FormActTime="" FormActTime=$p($h,",",2)
	Set:FormVerDate'="" FormVerDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(FormVerDate)
	Set:FormVerTime[":" FormVerTime = $zth(FormVerTime,1)
	
	Quit:(FormPathDr="") -1
	Set objPathMast = ##class(DHCMA.CPW.BT.PathMast).GetObjById(FormPathDr)
	Quit:'$Isobject(objPathMast) -1
	
	Set tID=$o(^DHCMA.CPW.BT.PathFormI("IdxofVersion",FormPathDr,FormVersion,0))
	Quit:(tID'="")&(ID'=tID) -2
	//Set objFormActUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(FormActUserID)
	//Set objFormVerUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(FormVerUserID)
	
	If ID="" {
		Set obj=##class(DHCMA.CPW.BT.PathForm).%New()
		Set FormVersion=+$o(^DHCMA.CPW.BT.PathFormI("IdxofVersion",FormPathDr,""),-1)
		Set FormVersion=$s(FormVersion<0:1,1:FormVersion+1)
	}Else{
		Set obj=##class(DHCMA.CPW.BT.PathForm).%OpenId(ID)
		Set FormVersion = obj.FormVersion
	}
	Quit:'$IsObject(obj) return
	
	Set obj.FormPathDr	 = objPathMast  //对象
	Set obj.FormCost	 = FormCost
	Set obj.FormDays     = FormDays
	Set obj.FormApply	 = FormApply
	Set obj.FormHelpDoc	 = FormHelpDoc
	Set obj.FormIsActive = FormIsActive
	Set obj.FormActDate	 = FormActDate
	Set obj.FormActTime	 = FormActTime
	Set obj.FormActUserID= FormActUserID
	Set obj.FormVersion  = FormVersion
	Set obj.FormIsOpen   = FormIsOpen
	Set obj.FormVerDate  = FormVerDate
	Set obj.FormVerTime  = FormVerTime
	Set obj.FormVerUserID= FormVerUserID  //指向
	Set obj.FormOID      = FormOID
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
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       aId : DHCMA.CPW.BT.PathForm.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathForm).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.BT.PathForm).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-11-07
/// Description:  更新参考费用和标准住院日
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       aId : DHCMA.CPW.BT.PathForm.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathForm).UpdateCostDay(1)
ClassMethod UpdateCostDay(aId As %String, aCost As %String, aDay As %String) As %String
{
	New (aId,aCost,aDay)
	Set return=""
	Quit:aId="" return
	Set obj=##class(DHCMA.CPW.BT.PathForm).GetObjById(aId)
	Quit:'$IsObject(obj) return
	
	Set obj.FormCost=aCost
	Set obj.FormDays=aDay
	
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

/// Creator：     jiangpengpeng
/// CreatDate：   2018-11-07
/// Description:  更新试用文档
/// Table：       DHCMA.CPW.BT.PathForm
/// Input：       aId : DHCMA.CPW.BT.PathForm.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathForm).UpdateDoc(1)
ClassMethod UpdateDoc(aId As %String, aDoc As %String, aApplyDoc As %String) As %String
{
	New (aId,aDoc,aApplyDoc)
	Set return=""
	Quit:aId="" return
	
	Set obj=##class(DHCMA.CPW.BT.PathForm).GetObjById(aId)
	Quit:'$IsObject(obj) return
	
	Set obj.FormHelpDoc = aDoc
	Set obj.FormApply = aApplyDoc

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

Storage Default
{
<Data name="PathFormDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FormPathDr</Value>
</Value>
<Value name="3">
<Value>FormCost</Value>
</Value>
<Value name="4">
<Value>FormDays</Value>
</Value>
<Value name="5">
<Value>FormApply</Value>
</Value>
<Value name="6">
<Value>FormHelpDoc</Value>
</Value>
<Value name="7">
<Value>FormIsActive</Value>
</Value>
<Value name="8">
<Value>FormActDate</Value>
</Value>
<Value name="9">
<Value>FormActTime</Value>
</Value>
<Value name="10">
<Value>FormActUserID</Value>
</Value>
<Value name="11">
<Value>FormVersion</Value>
</Value>
<Value name="12">
<Value>FormIsOpen</Value>
</Value>
<Value name="13">
<Value>FormVerDate</Value>
</Value>
<Value name="14">
<Value>FormVerTime</Value>
</Value>
<Value name="15">
<Value>FormVerUserID</Value>
</Value>
<Value name="16">
<Value>FormOID</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.BT.PathFormD</DataLocation>
<DefaultData>PathFormDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.BT.PathFormD</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.PathFormI</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.PathFormS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
