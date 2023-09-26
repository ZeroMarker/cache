/// 名称: DHCMA.CPW.BT.PathMast
/// 描述: 临床路径字典
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.BT.PathMast Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 关联医院
Relationship ChildHosp As DHCMA.CPW.BT.PathHosp [ Cardinality = children, Inverse = Parref ];

/// 路径代码 
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 路径名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 专科类型
Property BTTypeDr As DHCMA.CPW.BT.PathType;

/// 病种指针（路径）
Property BTEntityDr As DHCMA.CPW.BT.PathEntity;

/// 病种指针（按病种付费）
Property BTPCEntityDr As %String;

/// 病种指针（特定（单）病种质量控制）
Property BTQCEntityDr As %String;

/// 合并症指针(添加BTIsAsCompl后此字段作废)
Property BTPathComplDr As DHCMA.CPW.BT.PathCompl;

/// 是否可作为合并症路径
Property BTIsAsCompl As %Boolean [ InitialExpression = 0 ];

/// 就诊类型（门诊O、住院I）
Property BTAdmType As %String(MAXLEN = 3, TRUNCATE = 1);

/// 是否手术路径
Property BTIsOper As %Boolean;

/// 统计归类
Property BTStaCategoryDr As DHCMA.Util.BT.Dictionary;

/// 有效标志 
Property BTIsActive As %Boolean;

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人ID（指向DHCMA.CPW.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

Index IdxofCode On BTCode [ Unique ];

Index IdxofEntity On BTEntityDr;

Index IdxofPathType On BTTypeDr;

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-26
/// Description:  根据ID取临床路径字典字典信息
/// Table：       DHCMA.CPW.BT.PathMast
/// Input：       aId :  DHCMA.CPW.BT.PathMast.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.BT.PathMast).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.PathMast
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.PathMast).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.PathMast).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-26
/// Description:  删除临床路径字典字典信息
/// Table：       DHCMA.CPW.BT.PathMast
/// Input：       aId :  DHCMA.CPW.BT.PathMast.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathMast).DeleteById(1)
ClassMethod DeleteById(aId As %String, aHospID As %String = "") As %String
{
	New (aId,aHospID)
	
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.CPW.BT.PathMast")
	Quit:Flg'=1 -777
	
	Set sc = ##class(DHCMA.CPW.BT.PathMast).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
		//数据院区关联处理 add by yankai20210803
		If aHospID'=""{
			Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
			If (ret="Y")||(ret=1){
				Do ##class(DHCMA.Util.IO.MultiHospInterface).DelAllDataHospRelRecs("DHCMA_CPW_BT.PathMast",aId,aHospID)
			}
		}
	}
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-26
/// Description:  更新临床路径字典字典信息
/// Table：       DHCMA.CPW.BT.PathMast
/// Input：       各属性列表 ^分隔
/// BTCode As %String BTDesc As %String  BTTypeDr As DHCMA.CPW.BT.PathType
/// BTEntityDr As DHCMA.CPW.BT.PathEntity BTPCEntityDr As DHCMA.CPW.SD.PCEntity BTQCEntityDr As DHCMA.CPW.SD.QCEntity 
/// BTIsActive As %Boolean;BTActDate As %Date;  BTActTime As %Time; BTActUserID As %String
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathMast).Update("^t3^评估字典^0^0^0^0^1^2018-02-03^8:00^8")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^", aHospID As %String = "") As %String
{
	New (aInputStr,aSeparete,aHospID)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"  
	Set ID      	    = 	$p(aInputStr,aSeparete,1)       ///获取数据（表的字段）
	Set Code     		= 	$p(aInputStr,aSeparete,2)
	Set Desc    		= 	$p(aInputStr,aSeparete,3)
	Set TypeDr  		= 	$p(aInputStr,aSeparete,4)
	Set EntityDr  	= 	$p(aInputStr,aSeparete,5)
	Set PCEntityDr 	= 	$p(aInputStr,aSeparete,6)
	Set QCEntityDr 	= 	$p(aInputStr,aSeparete,7)
	Set IsActive    	=  +$p(aInputStr,aSeparete,8)
	Set ActDate   =$p(aInputStr,aSeparete,9)
	Set ActTime = $p(aInputStr,aSeparete,10)
	Set ActUserID		= 	$p(aInputStr,aSeparete,11)
	Quit:(Code="")||(Desc="") return
	Set AdmType			= 	$p(aInputStr,aSeparete,12)
	Set PathComplDr		=	$p(aInputStr,aSeparete,13)
	Set IsOper			=	$p(aInputStr,aSeparete,14)
	Set StaCategoryDr	=	$p(aInputStr,aSeparete,15)
	Set IsAsCompl		=	$p(aInputStr,aSeparete,16)
	Set:IsAsCompl="" IsAsCompl=0
	
	Set objType=##class(DHCMA.CPW.BT.PathType).GetObjById(TypeDr)
	Set objEntity=##class(DHCMA.CPW.BT.PathEntity).GetObjById(EntityDr) 
	Set objPathCompl=##class(DHCMA.CPW.BT.PathCompl).GetObjById(PathComplDr)
	Set objStaCategory=##class(DHCMA.Util.BT.Dictionary).GetObjById(StaCategoryDr) 

	Set:ActDate["-" ActDate=$zdh(ActDate,3)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime=$zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)

	Set tID=$o(^DHCMA.CPW.BT.PathMastI("IdxofCode"," "_$zcvt(Code,"U"),0)) //这两句似乎无用，没有建立索引
	Quit:(tID'="")&(ID'=tID) -2                //根据代码找ID,如果id对不上号 返回-2（这是因为code唯一，应该是更新时遇到code id不对等）
	
	If ID="" {                                  //根据ID判断是添加还是修改
		Set obj=##class(DHCMA.CPW.BT.PathMast).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.BT.PathMast).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return

	Set obj.BTCode    	= Code      //写入数据
	Set obj.BTDesc    	= Desc
	Set obj.BTTypeDr	= objType
	Set obj.BTEntityDr 	= objEntity
	Set obj.BTPCEntityDr= PCEntityDr //修改表结构，两个字段存ID。jpp 2020-05-22
	Set obj.BTQCEntityDr= QCEntityDr
	Set obj.BTPathComplDr = objPathCompl
	Set obj.BTIsActive 	= IsActive
	Set obj.BTActDate   = ActDate
	Set obj.BTActTime   = ActTime
	Set obj.BTActUserID = ActUserID
	Set obj.BTAdmType	= AdmType
	Set obj.BTIsOper	= IsOper
	Set obj.BTStaCategoryDr=objStaCategory
	Set obj.BTIsAsCompl = IsAsCompl
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
			Do ##class(DHCMA.Util.IO.MultiHospInterface).SaveDataRelHosp("DHCMA_CPW_BT.PathMast",return,aHospID)	
		}
	}
	
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-09-19
/// Description:  更新时判断Code是否重复
/// Table：       DHCMA.CPW.BT.PathMast
/// Input：       aCode：    代码
/// Return：      重复：ID，不重复：0
/// w ##class(DHCMA.CPW.BT.PathMast).CheckPTCode("t3")
ClassMethod CheckPTCode(aCode As %String, aID As %String = "") As %String
{
	New (aCode,aID)
	Set return=""
	Quit:(aCode="") return
	
	If ($d(^DHCMA.CPW.BT.PathMastI("IdxofCode"," "_$zcvt(aCode,"U"))))
	{
		Set ID=$o(^DHCMA.CPW.BT.PathMastI("IdxofCode"," "_$zcvt(aCode,"U"),0))
		Set return=ID
		Set:(aID'="")&&(aID=ID) return=0
	}else{
		set return=0
	}
	
	Quit return
}

Storage Default
{
<Data name="PathMastDefaultData">
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
<Value>BTEntityDr</Value>
</Value>
<Value name="6">
<Value>BTPCEntityDr</Value>
</Value>
<Value name="7">
<Value>BTQCEntityDr</Value>
</Value>
<Value name="8">
<Value>BTIsActive</Value>
</Value>
<Value name="9">
<Value>BTActDate</Value>
</Value>
<Value name="10">
<Value>BTActTime</Value>
</Value>
<Value name="11">
<Value>BTActUserID</Value>
</Value>
<Value name="12">
<Value>BTAdmType</Value>
</Value>
<Value name="13">
<Value>BTPathComplDr</Value>
</Value>
<Value name="14">
<Value>BTIsOper</Value>
</Value>
<Value name="15">
<Value>BTStaCategoryDr</Value>
</Value>
<Value name="16">
<Value>BTIsAsCompl</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.BT.PathMastD</DataLocation>
<DefaultData>PathMastDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.BT.PathMastD</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.PathMastI</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.PathMastS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
