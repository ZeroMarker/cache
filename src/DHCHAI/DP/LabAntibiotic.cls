/// 名称: DHCHAI.DP.LabAntibiotic
/// 描述: 抗生素
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.LabAntibiotic Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTAntCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property BTAntDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 分类
Property BTAntCatDr As DHCHAI.DP.LabAntiCat;

/// whone码
Property BTWCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 有效标志
Property BTIsActive As %Boolean [ Required ];

/// 多值别名（多个值!!分割）
Property BTAntDescs As %String(MAXLEN = "", TRUNCATE = 1);

/// 代码索引
Index IndexCode On BTAntCode As Exact;

/// 名称索引
Index IndexDesc On BTAntDesc As Exact;

/// 分类索引
Index IndexAntCatDr On BTAntCatDr;

/// Creator：     liyi
/// CreatDate：   2017-04-17
/// Description:  根据代码、名称取抗生素
/// Table：       DHCHAI.DP.LabAntibiotic
/// Input：       aCode:    抗生素代码
/// 			  aDesc:    抗生素名称
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabAntibiotic).GetObjByCodeDesc("TLV30","")
ClassMethod GetObjByCodeDesc(aCode As %String, aDesc As %String) As DHCHAI.DP.LabAntibiotic
{
	New (aCode,aDesc)
	Set return=""
	Quit:((aCode="")&&(aDesc=""))||((aCode'="")&&(aDesc'="")) return
	
	Set id=""
	Set:aCode'="" id = $o(^DHCHAI.DP.LabAntibioticI("IndexCode",aCode,0))
	Set:aDesc'="" id = $o(^DHCHAI.DP.LabAntibioticI("IndexDesc",aDesc,0))
	Quit:id="" return
	
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取抗生素
/// Table：       DHCHAI.DP.LabAntibiotic
/// Input：       ID:    DHCHAI.DP.LabAntibiotic.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabAntibiotic).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.LabAntibiotic
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.LabAntibiotic).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.LabAntibiotic).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新抗生素
/// Table：       DHCHAI.DP.LabAntibiotic
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabAntibiotic).Update("3^WA0003^乙酰螺旋霉素123^^ASP^1")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	= $p(InStr,aSeparete,1)
	Set AntCode		= $p(InStr,aSeparete,2)
	Set AntDesc		= $p(InStr,aSeparete,3)
	Set AntCatDr	= $p(InStr,aSeparete,4)
	Set WCode		= $p(InStr,aSeparete,5)
	Set IsActive	= +$p(InStr,aSeparete,6)
	Set AntDescs	= $p(InStr,aSeparete,7)
	Quit:(AntCode="")||(AntDesc="")||(IsActive="") return
	Set AntDesc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(AntDesc)  //去掉特殊字符
	//代码唯一性
	Set tID =$o(^DHCHAI.DP.LabAntibioticI("IndexCode",AntCode,0))
	Set tDe =$o(^DHCHAI.DP.LabAntibioticI("IndexDesc",AntDesc,0)) 
	Quit:(((tID'="")&(ID'=tID)) || ((tDe'="")&(ID'=tDe))) -100
	//Quit:((tID="")||(tDe="")) -100  // 初始无法导入
	Set objAntCat = ##class(DHCHAI.DP.LabAntiCat).GetObjById(AntCatDr)
	if ID="" {
		Set obj=##class(DHCHAI.DP.LabAntibiotic).%New()
	}else{
		Set obj=##class(DHCHAI.DP.LabAntibiotic).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTAntCode	= AntCode
	Set obj.BTAntDesc	= AntDesc
	Set obj.BTAntCatDr	= objAntCat
	Set obj.BTWCode		= WCode
	Set obj.BTIsActive	= IsActive
	Set obj.BTAntDescs  = AntDescs
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
/// Description:  删除抗生素
/// Table：       DHCHAI.DP.LabAntibiotic
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.DP.LabAntibiotic")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.DP.LabAntibiotic).%DeleteId(+Id)
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
/// Description:  导入抗生素
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##Class(DHCHAI.DP.LabAntibiotic).ImportLabAnt("^ANT016^Plazomicin^氨基糖苷类^PLZ^1","^")
ClassMethod ImportLabAnt(aInStr As %String, aSeparate As %String) As %String
{
	New (aInStr,aSeparate)
	Set return = ""
	Quit:(aInStr="")||(aSeparate="") return
	
	Set AntiCatDr = ""
	Set AntiCatDesc	= $p(aInStr,aSeparate,4)
	Set objAntiCat  = ##class(DHCHAI.DP.LabAntiCat).GetObjByCodeDesc("",AntiCatDesc)
	Set:$isobject(objAntiCat) AntiCatDr = objAntiCat.%Id()
	Set $p(aInStr,aSeparate,4) = AntiCatDr 
	
	Set AntDesc = $p(aInStr,aSeparate,3)
	Set AntDesc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(AntDesc)  //去掉特殊字符
	Set ID =$o(^DHCHAI.DP.LabAntibioticI("IndexDesc",AntDesc,0))
	If ID="" {
		Set tAntDesc=AntDesc
		Set tAntDesc=$tr(tAntDesc," ","")
		Set tAntDesc=$tr(tAntDesc,"（","(")
		Set tAntDesc=$tr(tAntDesc,"）",")")
		Set ID =$o(^DHCHAI.DP.LabAntibioticI("IndexDesc",tAntDesc,0))
	}
	Set $p(aInStr,aSeparate,1)=ID
	
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
<Value>BTAntCode</Value>
</Value>
<Value name="3">
<Value>BTAntDesc</Value>
</Value>
<Value name="4">
<Value>BTAntCatDr</Value>
</Value>
<Value name="5">
<Value>BTWCode</Value>
</Value>
<Value name="6">
<Value>BTIsActive</Value>
</Value>
<Value name="7">
<Value>BTAntDescs</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.LabAntibioticD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.LabAntibioticD</IdLocation>
<IndexLocation>^DHCHAI.DP.LabAntibioticI</IndexLocation>
<StreamLocation>^DHCHAI.DP.LabAntibioticS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
