/// 名称: DHCMA.CPW.BT.PathEntity
/// 描述: 临床路径病种字典
/// 编写日期: 2018-07-31
Class DHCMA.CPW.BT.PathEntity Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 编写者：zhufei
/// 病种代码  
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 病种名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 专科类型
Property BTTypeDr As DHCMA.CPW.BT.PathType;

/// 有效标志
Property BTIsActive As %Boolean;

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人ID（指向DHCMA.CPW.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

Index IdxofCode On BTCode [ Unique ];

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-24
/// Description:  根据ID取临床路径病种字典信息
/// Table：       DHCMA.CPW.BT.PathEntity
/// Input：       aId :  DHCMA.CPW.BT.PathEntity.ID
/// Return：      返回obj
/// w ##class( DHCMA.CPW.BT.PathEntity).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.PathEntity
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.PathEntity).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.PathEntity).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-24
/// Description:  根据Code取临床路径病种字典信息
/// Table：       DHCMA.CPW.BT.PathEntity
/// Input：       aCode :  DHCMA.CPW.BT.PathEntity.BTCode
/// Return：      返回String
/// zw ##class(DHCMA.CPW.BT.PathEntity).GetObjByCode("2")
ClassMethod GetObjByCode(aCode As %String) As %String
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	Set ID=$o(^DHCMA.CPW.BT.PathEntityI("IdxofCode"," "_$zcvt(aCode,"U"),0))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-24
/// Description:  删除临床路径病种字典信息
/// Table：       DHCMA.CPW.BT.PathEntity
/// Input：       aId :  DHCMA.CPW.BT.PathEntity.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathEntity).DeleteById(1)
ClassMethod DeleteById(aId As %String, aHospID As %String = "") As %String
{
	New (aId,aHospID)
	
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.CPW.BT.PathEntity")
	Quit:Flg'=1 -777
	
	Set sc = ##class(DHCMA.CPW.BT.PathEntity).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
		//数据院区关联处理 add by yankai20210803
		If aHospID'=""{
			Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
			If (ret="Y")||(ret=1){
				Do ##class(DHCMA.Util.IO.MultiHospInterface).DelAllDataHospRelRecs("DHCMA_CPW_BT.PathEntity",aId,aHospID)
			}
		}
		
	}
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-24
/// Description:  更新时判断Code是否重复
/// Table：       DHCMA.CPW.BT.PathEntity
/// Input：       aCode：    代码
/// Return：      重复：ID，不重复：0
/// w ##class(DHCMA.CPW.BT.PathEntity).CheckPTCode("2")
ClassMethod CheckPTCode(aCode As %String, aID As %String = "") As %String
{
	New (aCode,aID)
	Set return=""
	Quit:(aCode="") return
	
	If ($d(^DHCMA.CPW.BT.PathEntityI("IdxofCode"," "_$zcvt(aCode,"U"))))
	{
		Set ID=$o(^DHCMA.CPW.BT.PathEntityI("IdxofCode"," "_$zcvt(aCode,"U"),0))
		Set return=ID
		Set:(aID'="")&&(aID=ID) return=0
	}else{
		set return=0
	}
	
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-24
/// Description:  更新临床路径病种字典信息
/// Table：       DHCMA.CPW.BT.PathEntity
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathEntity).Update("^2^单病种2^1^t0^2018-3-10^13:00^13")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^", aHospID As %String = "") As %String
{
	New (aInputStr,aSeparete,aHospID)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete="^"  
	Set ID       = $p(aInputStr,aSeparete,1)       
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Set IsActive  = +$p(aInputStr,aSeparete,4)
	Set TypeDr  = $p(aInputStr,aSeparete,5)
	Set ActDate   =$p(aInputStr,aSeparete,6)
	Set ActTime = $p(aInputStr,aSeparete,7)
	Set ActUserID = $p(aInputStr,aSeparete,8)
	Quit:(Code="")||(Desc="") return

	Set objType=##class(DHCMA.CPW.BT.PathType).GetObjById(TypeDr)

	Set:ActDate["-" ActDate=$zdh(ActDate,3)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime=$zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)

	Set tID=$o(^DHCMA.CPW.BT.PathEntityI("IdxofCode"," "_$zcvt(Code,"U"),0))
	Quit:(tID'="")&(ID'=tID) -2                //根据代码找ID,如果id对不上号 返回-2（这是因为code唯一，应该是更新时遇到code id不对等）

	
	If ID="" {                                  //根据ID判断是添加还是修改
		Set obj=##class(DHCMA.CPW.BT.PathEntity).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.BT.PathEntity).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode     = Code      //写入数据
	Set obj.BTDesc     = Desc
	Set obj.BTIsActive = IsActive
	Set obj.BTTypeDr   = objType
	Set obj.BTActDate    = ActDate
	Set obj.BTActTime     = ActTime
	Set obj.BTActUserID    = ActUserID
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	//数据院区关联处理 add by yankai20210803
	If (+return>0)&&(aHospID'=""){
		Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
		If (ret="Y")||(ret=1){
			Do ##class(DHCMA.Util.IO.MultiHospInterface).SaveDataRelHosp("DHCMA_CPW_BT.PathEntity",return,aHospID)	
		}
	}
	
	Quit return
}

Storage Default
{
<Data name="PathEntityDefaultData">
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
<Value>BTIsActive</Value>
</Value>
<Value name="6">
<Value>BTActDate</Value>
</Value>
<Value name="7">
<Value>BTActTime</Value>
</Value>
<Value name="8">
<Value>BTActUserID</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.BT.PathEntityD</DataLocation>
<DefaultData>PathEntityDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.BT.PathEntityD</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.PathEntityI</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.PathEntityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
