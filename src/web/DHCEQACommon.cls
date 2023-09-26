Class web.DHCEQACommon Extends %RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

///  IncludeFlag:是否包含无效类组	0:不包含  其他:包含
///  判断配件类组是否有访问权限
ClassMethod AccessoryTypeIsIn(vAccessoryType, CurGroupID As %String = "", IncludeFlag As %String = "0")
{
	//Flag=0可以显示
	//需要加条件的地方加入q:(..AccessoryTypeIsIn(vAccessoryType))即可
	new GroupID,Flag
	set GroupID=CurGroupID
	if GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	s Flag=1
	i (IncludeFlag=0)&($Piece(^DHCEQCCode("DHCEQCAccessoryType",vAccessoryType),"^",4)'="N") q 1 //过滤无效类组,不可显示 Modify DJ 2016-09-27
	i $d(^DHCEQCCode("DHCEQCGroupAccessoryType",0,"Group",GroupID,vAccessoryType)) s Flag=0 
	q Flag
}

/// 根据类组权限，返回默认类组编号1，类组名称2  类组代码3
ClassMethod GetDefaultAccessoryType(vType)
{
	s valAccessoryType=..GetAccessorysByGroup()
	i valAccessoryType="" q ""
	s DefaultAccessoryTypeDR=$P(valAccessoryType,"^",1)
	i vType="1" q DefaultAccessoryTypeDR
	i vType="2" q $P($G(^DHCEQCCode("DHCEQCAccessoryType",DefaultAccessoryTypeDR)),"^",2)
	i vType="3" q $P($G(^DHCEQCCode("DHCEQCAccessoryType",DefaultAccessoryTypeDR)),"^",1)
	//s DefaultAccessoryType=$P($G(^DHCEQCCode("DHCEQCAccessoryType",DefaultAccessoryTypeDR)),"^",2)
	//i vType="2" q DefaultAccessoryType
}

/// IncludeFlag:是否包含无效类组	0:不包含  其他:包含
/// 取安全组的访问配件类组串
ClassMethod GetAccessorysByGroup(GroupID As %Library.String = "", IncludeFlag As %String = "0")
{
	new AccessoryType,Flag,Equips
	if GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	s GETRowID=0
	s Accessorys=""
	s DefaultAccessory=""
	s AccessoryType=0
	f  s AccessoryType=$o(^DHCEQCCode("DHCEQCGroupAccessoryType",0,"Group",GroupID,AccessoryType)) q:AccessoryType=""  d
	.Quit:(IncludeFlag=0)&($Piece(^DHCEQCCode("DHCEQCAccessoryType",AccessoryType),"^",4)'="N")	;过滤无效类组 2013-11-11  Mozy0112
	.s GETRowID=$o(^DHCEQCCode("DHCEQCGroupAccessoryType",0,"Group",GroupID,AccessoryType,0))
	.q:GETRowID=""
	.;s AccessoryType=$p(^DHCEQCCode("DHCEQCGroupAccessoryType",GETRowID),"^",2)
	.s Flag=$p(^DHCEQCCode("DHCEQCGroupAccessoryType",GETRowID),"^",3)
	.i Flag="Y" s DefaultAccessory=AccessoryType
	.q:Flag="Y"
	.s Accessorys=Accessorys_"^"_AccessoryType
	i DefaultAccessory'="" q DefaultAccessory_Accessorys
	q $P(Accessorys,"^",2,$L(Accessorys,"^"))
}

}
