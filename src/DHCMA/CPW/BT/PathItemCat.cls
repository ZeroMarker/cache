/// 名称: DHCMA.CPW.BT.PathItemCat
/// 描述: 临床路径表单 项目分类（长期医嘱、临时医嘱、出院医嘱...）
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.BT.PathItemCat Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 项目分类代码 
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 项目分类名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 项目大类（主要诊疗工作、重点医嘱、主要护理工作）
Property BTTypeDr As DHCMA.Util.BT.Dictionary [ Required ];

/// 权限(D诊疗，N护理，OE医嘱，NE护嘱
Property BTPowerDr As DHCMA.Util.BT.Dictionary;

Index IdxofCode On BTCode [ Unique ];

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-24
/// Description:  根据ID取项目分类字典信息
/// Table：       DHCMA.CPW.BT.PathItemCat
/// Input：       aId :  DHCMA.CPW.BT.PathItemCat.ID
/// Return：      返回obj
/// w ##class( DHCMA.CPW.BT.PathItemCat).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.PathItemCat
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.PathItemCat).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.PathItemCat).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-24
/// Description:  根据Code取项目分类字典信息
/// Table：       DHCMA.CPW.BT.PathItemCat
/// Input：       aCode :  DHCMA.CPW.BT.PathItemCat.BTCode
/// Return：      返回String
/// zw ##class(DHCMA.CPW.BT.PathItemCat).GetObjByCode("t2")
ClassMethod GetObjByCode(aCode As %String) As %String
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	Set ID=$o(^DHCMA.CPW.BT.PathItemCatI("IdxofCode"," "_$zcvt(aCode,"U"),0))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-24
/// Description:  删除项目分类字典信息
/// Table：       DHCMA.CPW.BT.PathItemCat
/// Input：       aId :  DHCMA.CPW.BT.PathItemCat.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathItemCat).DeleteById(1)
ClassMethod DeleteById(aId As %String, aHospID As %String = "") As %String
{
	New (aId,aHospID)
	
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.CPW.BT.PathItemCat")
	Quit:Flg'=1 -777
	
	Set sc = ##class(DHCMA.CPW.BT.PathItemCat).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
		//数据院区关联处理 add by yankai20210803
		If aHospID'=""{
			Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
			If (ret="Y")||(ret=1){
				Do ##class(DHCMA.Util.IO.MultiHospInterface).DelAllDataHospRelRecs("DHCMA_CPW_BT.PathItemCat",aId,aHospID)
			}
		}
	}
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-24
/// Description:  更新时判断Code是否重复
/// Table：       DHCMA.CPW.BT.PathItemCat
/// Input：       aCode：    代码
/// Return：      重复：ID，不重复：0
/// w ##class(DHCMA.CPW.BT.PathItemCat).CheckPTCode("t3")
ClassMethod CheckPTCode(aCode As %String, aID As %String = "") As %String
{
	New (aCode,aID)
	Set return=""
	Quit:(aCode="") return
	
	If ($d(^DHCMA.CPW.BT.PathItemCatI("IdxofCode"," "_$zcvt(aCode,"U"))))
	{
		Set ID=$o(^DHCMA.CPW.BT.PathItemCatI("IdxofCode"," "_$zcvt(aCode,"U"),0))
		Set return=ID
		Set:(aID'="")&&(aID=ID) return=0
	}else{
		set return=0
	}
	
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-24
/// Description:  更新项目分类字典信息
/// Table：       DHCMA.CPW.BT.PathItemCat
/// Input：       各属性列表 ^分隔
/// BTCode As %String BTDesc As %String   注意往这个类里写入方法：BTTypeDr As DHCMA.Util.BT.Dictionary
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathItemCat).Update("^t3^医生^0")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^", aHospID As %String = "") As %String
{
	New (aInputStr,aSeparete,aHospID)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"  
	Set ID       = $p(aInputStr,aSeparete,1)       ///获取数据（表的字段）
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Set TypeDr  = +$p(aInputStr,aSeparete,4)
	Set PowerDr	 = $p(aInputStr,aSeparete,5)
	Quit:(Code="")||(Desc="")||(TypeDr="") return

	Set objType=##class(DHCMA.Util.BT.Dictionary).GetObjById(TypeDr)
	Set objPower=##class(DHCMA.Util.BT.Dictionary).GetObjById(PowerDr)
	
	Set tID=$o(^DHCMA.CPW.BT.PathItemCatI("IdxofCode"," "_$zcvt(Code,"U"),0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -2                //根据代码找ID,如果id对不上号 返回-2（这是因为code唯一，应该是更新时遇到code id不对等）
	
	If ID="" {                                  //根据ID判断是添加还是修改
		Set obj=##class(DHCMA.CPW.BT.PathItemCat).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.BT.PathItemCat).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.BTCode     = Code      //写入数据
	Set obj.BTDesc     = Desc
	Set obj.BTTypeDr   = objType
	Set obj.BTPowerDr    = objPower
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
			Do ##class(DHCMA.Util.IO.MultiHospInterface).SaveDataRelHosp("DHCMA_CPW_BT.PathItemCat",return,aHospID)	
		}
	}
	
	Quit return
}

Storage Default
{
<Data name="PathItemCatDefaultData">
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
<Value>BTPowerDr</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.BT.PathItemCatD</DataLocation>
<DefaultData>PathItemCatDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.BT.PathItemCatD</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.PathItemCatI</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.PathItemCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
