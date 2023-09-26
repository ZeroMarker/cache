/// 单病种值域字典
Class DHCMA.CPW.SD.Dictionary Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 1000, TRUNCATE = 1) [ Required ];

/// 字典分类  
Property BTTypeDr As DHCMA.CPW.SD.DicType [ Required ];

/// 排序码
Property BTIndNo As %Integer;

/// 有效标志
Property BTIsActive As %Boolean;

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人ID（指向DHCMA.Util.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 是否默认项
Property BTIsDefault As %Boolean;

/// 备注
Property BTResume As %String;

/// 字典分组
Property BTGroup As %String;

/// 字典分类索引
Index IdxofTypeDr On BTTypeDr;

/// 字典分类 + 代码 索引
Index IdxofTypeDrCode On (BTTypeDr, BTCode) [ Unique ];

/// 字典分类 + 名称 索引
Index IdxofTypeDrDesc On (BTTypeDr, BTDesc);

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-24
/// Description:  根据ID取系统字典信息
/// Table：       DHCMA.CPW.SD.Dictionary
/// Input：       aId :  DHCMA.CPW.SD.Dictionary.ID
/// Return：      返回obj
/// zw ##class(DHCMA.CPW.SD.Dictionary).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.Dictionary
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.Dictionary).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.Dictionary).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-30
/// Description:  删除系统字典信息
/// Table：       DHCMA.CPW.SD.Dictionary
/// Input：       aId :  DHCMA.CPW.BT.PathCompl.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathCompl).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.Dictionary).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-30
/// Description:  更新系统字典信息
/// Table：       DHCMA.CPW.SD.Dictionary
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Dictionary).Update("2^2^测试23^1^90^1^2018-09-10^16:32:57^118","^")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID       = $p(aInputStr,aSeparete,1)       //获取数据（表的字段）
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Set TypeDr   = $p(aInputStr,aSeparete,4)
	Set IndNo	 = +$p(aInputStr,aSeparete,5)
	Set IsActive = +$p(aInputStr,aSeparete,6)
	Set ActDate  = $p(aInputStr,aSeparete,7)
	Set ActTime  = $p(aInputStr,aSeparete,8)
	Set ActUserID= $p(aInputStr,aSeparete,9)
	Set IsDefault= $p(aInputStr,aSeparete,10)
	Set BTResume= $p(aInputStr,aSeparete,11)
	Set BTGroup= $p(aInputStr,aSeparete,12)
	Quit:(Code="")||(Desc="")||(TypeDr="") return
	
	Set:ActDate["-" ActDate=$zdh(ActDate,3)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime=$zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	If (ID="")&&($d(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",TypeDr," "_$ZCVT(Code,"U")))) {
		Set ID=$o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",TypeDr," "_$ZCVT(Code,"U"),0))
	}
	If ID="" {                                  
		Set obj=##class(DHCMA.CPW.SD.Dictionary).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.Dictionary).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	//写入数据
	Set obj.BTCode     = Code
	Set obj.BTDesc     = Desc
	Set obj.BTTypeDr   = ##class(DHCMA.CPW.SD.DicType).GetObjById(TypeDr)
	Set obj.BTIndNo    = IndNo
	Set obj.BTIsActive = IsActive
	Set obj.BTActDate  = ActDate
	Set obj.BTActTime  = ActTime
	Set obj.BTActUserID= ActUserID
	Set obj.BTIsDefault= IsDefault
	Set obj.BTResume   = BTResume
	Set obj.BTGroup    = BTGroup
	//检查Save是否成功
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// s a=##class(DHCMA.CPW.SD.Dictionary).GetObjByPCodeItemDesc("CS-5-1","大于500ml(实际量ml)")
ClassMethod GetObjByPCodeItemDesc(PCode As %String, Alias As %String) As DHCMA.CPW.SD.Dictionary
{
	n (PCode,Alias)
	Set return="",Alias=$ZCVT(Alias,"U")
	Set DicTypeObj=##class(DHCMA.CPW.SD.DicType).GetObjByCode(PCode)
	Quit:'$IsObject(DicTypeObj) return
	Set DicId=DicTypeObj.%Id()
	Set ItemID=$o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrDesc",DicId," "_Alias,""),-1)
	Set ItemObj=##class(DHCMA.CPW.SD.Dictionary).GetObjById(ItemID)
	Quit:'$IsObject(ItemObj) return
	Quit ItemObj
}

/// s a=##class(DHCMA.CPW.SD.Dictionary).GetObjByPCodeItemCode("CS-5-1","b")
ClassMethod GetObjByPCodeItemCode(PCode As %String, Alias As %String) As DHCMA.CPW.SD.Dictionary
{
	n (PCode,Alias)
	Set return="",Alias=$ZCVT(Alias,"U")
	Set DicTypeObj=##class(DHCMA.CPW.SD.DicType).GetObjByCode(PCode)
	Quit:'$IsObject(DicTypeObj) return
	Set DicId=DicTypeObj.%Id()
	Set ItemID=$o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",DicId," "_Alias,""),-1)
	Set ItemObj=##class(DHCMA.CPW.SD.Dictionary).GetObjById(ItemID)
	Quit:'$IsObject(ItemObj) return
	Quit ItemObj
}

/// Creator：     liuzhenhe
/// CreatDate：   2019-01-16
/// Description:  根据分类和代码取系统字典信息
/// Table：       DHCMA.CPW.SD.Dictionary
/// Input：       DHCMA.CPW.SD.Dictionary.BTTypeDr,BTCode
/// Return：      返回obj
/// s a= ##class(DHCMA.CPW.SD.Dictionary).GetObjByCode("CAP-Adult-1-2-1","y")
ClassMethod GetObjByCode(aTypeCode As %String, aCode As %String) As DHCMA.CPW.SD.Dictionary
{
	New (aTypeCode,aCode)
	Quit:(aTypeCode="")&&(aCode="") ""
	Set objType=##class(DHCMA.CPW.SD.DicType).GetObjByCode(aTypeCode)
	Quit:'$IsObject(objType) ""
	Set TypeDr=objType.%Id()
	Set ID=$o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",TypeDr," "_$zcvt(aCode,"U"),0))
	Set obj=..GetObjById(ID)
	Quit obj
}

Storage Default
{
<Data name="DictionaryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
<Value name="4">
<Value>BTTypeDr</Value>
</Value>
<Value name="5">
<Value>BTIndNo</Value>
</Value>
<Value name="6">
<Value>BTIsActive</Value>
</Value>
<Value name="7">
<Value>BTActDate</Value>
</Value>
<Value name="8">
<Value>BTActTime</Value>
</Value>
<Value name="9">
<Value>BTActUserID</Value>
</Value>
<Value name="10">
<Value>BTIsDefault</Value>
</Value>
<Value name="11">
<Value>BTResume</Value>
</Value>
<Value name="12">
<Value>BTGroup</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.DictionaryD</DataLocation>
<DefaultData>DictionaryDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.DictionaryD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.DictionaryI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.DictionaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
