/// 名称: DHCHAI.DP.LabBacteria
/// 描述: 细菌
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.LabBacteria Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTBacCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property BTBacDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 英文名
Property BTBacName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 细菌类型
Property BTTypeDr As DHCHAI.DP.LabBactType;

/// 细菌分类
Property BTCatDr As DHCHAI.DP.LabBactCat;

/// whone码
Property BTWCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 有效标志
Property BTIsActive As %Boolean [ Required ];

/// 多值别名（多个值!!分割）
Property BTBacDescs As %String(MAXLEN = "", TRUNCATE = 1);

/// 细菌菌属  add 2020-07-28
Property BTGenusDr As DHCHAI.DP.LabBactGenus;

/// 常见菌标志
Property BTIsCommon As %Boolean;

/// 是否常见皮肤共生菌
Property BTIsSkinBact As %Boolean;

/// 代码索引
Index IndexCode On BTBacCode As Exact;

/// 名称索引
Index IndexDesc On BTBacDesc As Exact;

/// 英文名索引
Index IndexName On BTBacName As Exact;

/// 分类索引
Index IndexBacCatDr On BTCatDr;

/// Creator：     liyi
/// CreatDate：   2017-04-17
/// Description:  根据代码、名称取细菌
/// Table：       DHCHAI.DP.LabBacteria
/// Input：       aCode:    细菌代码
/// 	     aDesc:    细菌名称
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabBacteria).GetObjByCodeDesc("TLV30","")
ClassMethod GetObjByCodeDesc(aCode As %String, aDesc As %String) As DHCHAI.DP.LabBacteria
{
	New (aCode,aDesc)
	Set return=""
	Quit:((aCode="")&&(aDesc=""))||((aCode'="")&&(aDesc'="")) return
	
	Set id=""
	Set:aCode'="" id = $o(^DHCHAI.DP.LabBacteriaI("IndexCode",aCode,0))
	Set:aDesc'="" id = $o(^DHCHAI.DP.LabBacteriaI("IndexDesc",aDesc,0))
	Quit:id="" return
	
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取细菌
/// Table：       DHCHAI.DP.LabBacteria
/// Input：       ID:    DHCHAI.DP.LabBacteria.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabBacteria).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.LabBacteria
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.LabBacteria).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.LabBacteria).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新细菌
/// Table：       DHCHAI.DP.LabBacteria
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabBacteria).Update("^jsh^巨核细胞^1^1^daf^1")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	= $p(InStr,aSeparete,1)
	Set BacCode		= $p(InStr,aSeparete,2)
	Set BacDesc		= $p(InStr,aSeparete,3)
	Set BacName     = $p(InStr,aSeparete,4)
	Set BacTypeDr   = $p(InStr,aSeparete,5)
	Set BacCatDr	= $p(InStr,aSeparete,6)
	Set WCode		= $p(InStr,aSeparete,7)
	Set IsActive	= +$p(InStr,aSeparete,8)
	Set BacDescs    = $p(InStr,aSeparete,9)
	Set BacGenusDr  = $p(InStr,aSeparete,10)
	Set BTIsCommon  = $p(InStr,aSeparete,11)
	Set BTIsSkinBact= $p(InStr,aSeparete,12)
	Quit:(BacCode="")||(BacDesc="")||(IsActive="") return
	Set BacDesc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(BacDesc)  //去掉特殊字符
	
	//代码唯一性
	Set tID =$o(^DHCHAI.DP.LabBacteriaI("IndexCode",BacCode,0))
	Quit:(tID'="")&(ID'=tID) -100 
	
	Set objBacType = ##class(DHCHAI.DP.LabBactType).GetObjById(BacTypeDr)
	Set objBacCat = ##class(DHCHAI.DP.LabBactCat).GetObjById(BacCatDr)
	Set objBacGenus = ##class(DHCHAI.DP.LabBactGenus).GetObjById(BacGenusDr)
	if ID="" {
		Set obj=##class(DHCHAI.DP.LabBacteria).%New()
	}else{
		Set obj=##class(DHCHAI.DP.LabBacteria).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTBacCode	= BacCode
	Set obj.BTBacDesc	= BacDesc
	Set obj.BTTypeDr	= objBacType
	Set obj.BTCatDr	    = objBacCat
	Set obj.BTWCode		= WCode
	Set obj.BTBacName	= BacName
	Set obj.BTIsActive	= IsActive
	Set obj.BTBacDescs  = BacDescs
	Set obj.BTGenusDr   = objBacGenus
	Set obj.BTIsCommon  = BTIsCommon
	Set obj.BTIsSkinBact = BTIsSkinBact
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

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  删除细菌
/// Table：       DHCHAI.DP.LabBacteria
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.DP.LabBacteria")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.DP.LabBacteria).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  导入细菌
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##Class(DHCHAI.DP.LabBacteria).ImportLabBacteria("^acm^马杜拉放线菌属^+^GPR^^1","^")
ClassMethod ImportLabBacteria(aInStr As %String, aSeparate As %String) As %String
{
	New (aInStr,aSeparate)
	Set return = ""
	Quit:(aInStr="")||(aSeparate="") return
	
	Set BactTypeDr = ""
	Set BactTypeCode	= $p(aInStr,aSeparate,5)
	Set objBactType     = ##class(DHCHAI.DP.LabBactType).GetObjByCodeDesc(BactTypeCode,"")
	Set:$isobject(objBactType) BactTypeDr = objBactType.%Id()
	Set $p(aInStr,aSeparate,5) = BactTypeDr
	
	Set BactCatDr = ""
	Set BactCatCode = $p(aInStr,aSeparate,6)
	Set objBactCat  = ##class(DHCHAI.DP.LabBactCat).GetObjByCodeDesc(BactCatCode,"")
	Set:$isobject(objBactCat) BactCatDr = objBactCat.%Id()
	Set $p(aInStr,aSeparate,6) = BactCatDr
	
	Set BacDesc = $p(aInStr,aSeparate,3)
	Set BacDesc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(BacDesc)  //去掉特殊字符
	Set ID=$o(^DHCHAI.DP.LabBacteriaI("IndexDesc",BacDesc,0))
	If ID="" {
		Set tBacDesc=BacDesc
		Set tBacDesc=$tr(tBacDesc," ","")
		Set tBacDesc=$tr(tBacDesc,"（","(")
		Set tBacDesc=$tr(tBacDesc,"）",")")
		Set ID=$o(^DHCHAI.DP.LabBacteriaI("IndexDesc",tBacDesc,0))
	}
	Set $p(aInStr,aSeparate,1)=ID
	
    // add 2020-07-28
    Set BacGenusDr = ""
	Set BactGenus = $p(aInStr,aSeparate,10)
	Set objBacGenus  = ##class(DHCHAI.DP.LabBactGenus).GetObjByCodeDesc("",BactGenus)
	Set:$isobject(objBacGenus) BacGenusDr = objBacGenus.%Id()
	Set $p(aInStr,aSeparate,10) = BacGenusDr
	
	Set return = ..Update(aInStr,aSeparate)
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTBacCode</Value>
</Value>
<Value name="3">
<Value>BTBacDesc</Value>
</Value>
<Value name="4">
<Value>BTBacName</Value>
</Value>
<Value name="5">
<Value>BTTypeDr</Value>
</Value>
<Value name="6">
<Value>BTCatDr</Value>
</Value>
<Value name="7">
<Value>BTWCode</Value>
</Value>
<Value name="8">
<Value>BTIsActive</Value>
</Value>
<Value name="9">
<Value>BTBacDescs</Value>
</Value>
<Value name="10">
<Value>BTGenusDr</Value>
</Value>
<Value name="11">
<Value>BTIsCommon</Value>
</Value>
<Value name="12">
<Value>BTIsSkinBact</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.LabBacteriaD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.LabBacteriaD</IdLocation>
<IndexLocation>^DHCHAI.DP.LabBacteriaI</IndexLocation>
<StreamLocation>^DHCHAI.DP.LabBacteriaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
