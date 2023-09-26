/// 名称: DHCMA.CPW.BT.PathVariat
/// 描述: 变异原因字典
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.BT.PathVariat Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码  
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 变异原因分类
Property BTCatDr As DHCMA.CPW.BT.PathVarCat;

/// 变异原因类型（未入径原因、出径原因、变异原因）
Property BTTypeDr As DHCMA.Util.BT.Dictionary [ Required ];

/// 就诊类型（门诊O、住院I、门诊+住院IO）
Property BTAdmType As %String(MAXLEN = 3, TRUNCATE = 1);

/// 正负变异类型
Property BTIsExactly As %Boolean;

/// 有效标志
Property BTIsActive As %Boolean;

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人ID（指向DHCMA.CPW.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

Index IdxofCode On BTCode [ Unique ];

Index IdxofTypeCat On (BTTypeDr, BTCatDr);

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-24
/// Description:  根据ID取变异原因字典信息
/// Table：       DHCMA.CPW.BT.PathVariat
/// Input：       aId :  DHCMA.CPW.BT.PathVariat
/// Return：      返回obj
/// w ##class( DHCMA.CPW.BT.PathVariat).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.PathVariat
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.PathVariat).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.PathVariat).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-24
/// Description:  根据Code取变异原因字典信息
/// Table：       DHCMA.CPW.BT.PathVariat
/// Input：       aCode :  DHCMA.CPW.BT.PathVariat.BTCode
/// Return：      返回String
/// zw ##class(DHCMA.CPW.BT.PathVariat).GetObjByCode("01")
ClassMethod GetObjByCode(aCode As %String) As %String
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	Set ID=$o(^DHCMA.CPW.BT.PathVariatI("IdxofCode"," "_$zcvt(aCode,"U"),0))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-24
/// Description:  删除变异原因字典信息
/// Table：       DHCMA.CPW.BT.PathVariat
/// Input：       aId :  DHCMA.CPW.BT.PathVariat.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathVariat).DeleteById(1)
ClassMethod DeleteById(aId As %String, aHospID As %String = "") As %String
{
	New (aId,aHospID)
	
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.CPW.BT.PathVariat")
	Quit:Flg'=1 -777
	
	Set sc = ##class(DHCMA.CPW.BT.PathVariat).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
		//数据院区关联处理 add by yankai20210803
		If aHospID'=""{
			Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
			If (ret="Y")||(ret=1){
				Do ##class(DHCMA.Util.IO.MultiHospInterface).DelAllDataHospRelRecs("DHCMA_CPW_BT.PathVariat",aId,aHospID)
			}
		}
	}
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-24
/// Description:  更新时判断Code是否重复
/// Table：       DHCMA.CPW.BT.PathVariat
/// Input：       aCode：    代码
/// Return：      重复：ID，不重复：0
/// w ##class(DHCMA.CPW.BT.PathVariat).CheckPTCode("01")
ClassMethod CheckPTCode(aCode As %String, aID As %String = "") As %String
{
	New (aCode,aID)
	Set return=""
	Quit:(aCode="") return
	
	If ($d(^DHCMA.CPW.BT.PathVariatI("IdxofCode"," "_$zcvt(aCode,"U"))))
	{
		Set ID=$o(^DHCMA.CPW.BT.PathVariatI("IdxofCode"," "_$zcvt(aCode,"U"),0))
		Set return=ID
		Set:(aID'="")&&(aID=ID) return=0
	}else{
		set return=0
	}	
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-24
/// Description:  更新变异原因字典信息
/// Table：       DHCMA.CPW.BT.PathVariat
/// Input：       各属性列表 ^分隔
/// BTCode As %String BTDesc As %String BTCatDr As DHCMA.CPW.BT.PathVarCat BTTypeDr As DHCMA.Util.BT.Dictionary 
/// BTIsExactly As %Boolean BTIsActive As %Boolean BTActDate As %Date BTActTime As %Time BTActUserID As %String
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathVariat).Update("^01^提前出院^002^0^1^0^2018-3-10^8:00^8")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^", aHospID As %String = "") As %String
{
	New (aInputStr,aSeparete,aHospID)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"  
	Set ID       = $p(aInputStr,aSeparete,1)       ///获取数据（表的字段）
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Set CatDr  	= $p(aInputStr,aSeparete,4)
	Set TypeDr  = $p(aInputStr,aSeparete,5)
	Set IsExactly = $p(aInputStr,aSeparete,6)
	Set IsActive  = $p(aInputStr,aSeparete,7)
	Set ActDate   =$p(aInputStr,aSeparete,8)
	Set ActTime = $p(aInputStr,aSeparete,9)
	Set ActUserID = $p(aInputStr,aSeparete,10)
	Set AdmType   = $p(aInputStr,aSeparete,11)
	Quit:(Code="")||(Desc="")||(TypeDr="") return

	Set:ActDate["-" ActDate=$zdh(ActDate,3)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime=$zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)

	Set tID=$o(^DHCMA.CPW.BT.PathVariatI("IdxofCode"," "_$zcvt(Code,"U"),0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -2                //根据代码找ID,如果id对不上号 返回-2（这是因为code唯一，应该是更新时遇到code id不对等）
	
	If ID="" {                                  //根据ID判断是添加还是修改
		Set obj=##class(DHCMA.CPW.BT.PathVariat).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.BT.PathVariat).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode     = Code      //写入数据
	Set obj.BTDesc     = Desc
	Set obj.BTCatDr    =##class(DHCMA.CPW.BT.PathVarCat).GetObjById(CatDr)
	Set obj.BTTypeDr   =##class(DHCMA.Util.BT.Dictionary).GetObjById(TypeDr)  
	Set obj.BTIsExactly= IsExactly
	Set obj.BTIsActive = IsActive
	Set obj.BTActDate  = ActDate
	Set obj.BTActTime  = ActTime
	Set obj.BTActUserID= ActUserID
	Set obj.BTAdmType  = AdmType
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
			Do ##class(DHCMA.Util.IO.MultiHospInterface).SaveDataRelHosp("DHCMA_CPW_BT.PathVariat",return,aHospID)	
		}
	}
	Quit return
}

Storage Default
{
<Data name="PathVariatDefaultData">
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
<Value>BTCatDr</Value>
</Value>
<Value name="5">
<Value>BTTypeDr</Value>
</Value>
<Value name="6">
<Value>BTIsExactly</Value>
</Value>
<Value name="7">
<Value>BTIsActive</Value>
</Value>
<Value name="8">
<Value>BTActDate</Value>
</Value>
<Value name="9">
<Value>BTActTime</Value>
</Value>
<Value name="10">
<Value>BTActUserID</Value>
</Value>
<Value name="11">
<Value>BTAdmType</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.BT.PathVariatD</DataLocation>
<DefaultData>PathVariatDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.BT.PathVariatD</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.PathVariatI</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.PathVariatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
