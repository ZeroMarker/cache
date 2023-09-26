/// 名称: DHCMA.CPW.BT.PathVarCat
/// 描述: 变异原因分类（与病人相关、与医护人员相关、与信息系统相关...）
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.BT.PathVarCat Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 类型代码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 类型名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

Index IdxofCode On BTCode [ Unique ];

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-24
/// Description:  根据ID取变异分类字典信息
/// Table：       DHCMA.CPW.BT.PathVarCat
/// Input：       aId :  DHCMA.CPW.BT.PathVarCat.ID
/// Return：      返回obj
/// zw ##class(DHCMA.CPW.BT.PathVarCat).GetObjById(2)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.PathVarCat
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.PathVarCat).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.PathVarCat).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-24
/// Description:  根据Code取变异分类字典信息
/// Table：       DHCMA.CPW.BT.PathVarCat
/// Input：       aCode :  DHCMA.CPW.BT.PathVarCat.BTCode
/// Return：      返回String
/// zw ##class(DHCMA.CPW.BT.PathVarCat).GetObjByCode("t0")
ClassMethod GetObjByCode(aCode As %String) As %String
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	Set ID=$o(^DHCMA.CPW.BT.PathVarCatI("IdxofCode"," "_$zcvt(aCode,"U"),0))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-24
/// Description:  删除变异分类字典信息
/// Table：       DHCMA.CPW.BT.PathVarCat
/// Input：       aId : DHCMA.CPW.BT.PathVarCat.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathVarCat).DeleteById(1)
ClassMethod DeleteById(aId As %String, aHospID As %String = "") As %String
{
	New (aId,aHospID)
	
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.CPW.BT.PathVarCat")
	Quit:Flg'=1 -777
	
	Set sc = ##class(DHCMA.CPW.BT.PathVarCat).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
		//数据院区关联处理 add by yankai20210803
		If aHospID'=""{
			Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
			If (ret="Y")||(ret=1){
				Do ##class(DHCMA.Util.IO.MultiHospInterface).DelAllDataHospRelRecs("DHCMA_CPW_BT.PathVarCat",aId,aHospID)
			}
		}
	}
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-24
/// Description:  更新时判断Code是否重复
/// Table：       DHCMA.CPW.BT.PathVarCat
/// Input：       aCode：    代码
/// Return：      重复：ID，不重复：0
/// w ##class(DHCMA.CPW.BT.PathVarCat).CheckPTCode("t0")
ClassMethod CheckPTCode(aCode As %String, aID As %String = "") As %String
{
	New (aCode,aID)
	Set return=""
	Quit:(aCode="") return
	
	If ($d(^DHCMA.CPW.BT.PathVarCatI("IdxofCode"," "_$zcvt(aCode,"U"))))
	{
		Set ID=$o(^DHCMA.CPW.BT.PathVarCatI("IdxofCode"," "_$zcvt(aCode,"U"),0))
		Set return=ID
		Set:(aID'="")&&(aID=ID) return=0
	}else{
		set return=0
	}
	
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-24
/// Description:  更新变异分类字典信息
/// Table：       DHCMA.CPW.BT.PathVarCat
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathVarCat).Update("^t0^test")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^", aHospID As %String = "") As %String
{
	New (aInputStr,aSeparete,aHospID)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete="^"  
	Set ID       = $p(aInputStr,aSeparete,1)       ///获取数据（表的字段）
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Quit:(Code="")||(Desc="") return

	Set tID=$o(^DHCMA.CPW.BT.PathVarCatI("IdxofCode"," "_$zcvt(Code,"U"),0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -2                //根据代码找ID,如果id对不上号 返回-2（这是因为code唯一，应该是更新时遇到code id不对等）
	
	If ID="" {                                  //根据ID判断是添加还是修改
		Set obj=##class(DHCMA.CPW.BT.PathVarCat).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.BT.PathVarCat).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode     = Code      //写入数据
	Set obj.BTDesc     = Desc
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
			Do ##class(DHCMA.Util.IO.MultiHospInterface).SaveDataRelHosp("DHCMA_CPW_BT.PathVarCat",return,aHospID)	
		}
	}
	Quit return
}

Storage Default
{
<Data name="VarCateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.BT.PathVarCatD</DataLocation>
<DefaultData>VarCateDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.BT.PathVarCatD</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.PathVarCatI</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.PathVarCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
