Class web.DHCEQ.Plat.CTEquipAttribute Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// ----------------------------------
/// 创建:JYP  2019-09-02 
/// 描述:通过JSON对象保存设备属性
/// 	入参:Data:来源类型ID(1:设备项,2:验收单,3:设备)
/// 		 Type:对应来源ID
/// w ##Class(web.DHCEQ.Plat.CTEquipAttribute).SaveData("1","1")
/// ----------------------------------
ClassMethod SaveData(Data, Type As %String = "")
{
	k PLIST,RowID
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
    s Result=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQCEquipAttribute",JsonData,.PLIST)
	s RowID = JsonData.%Get("EARowID")         //modify by jyp 2019-08-26

	if (Type="1")
	{
		&SQL(update sqluser.DHC_EQCEquipAttribute set EA_InvalidFlag='Y' where EA_RowID=:RowID)
		If SQLCODE
		{
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",SQLCODE)
		}
	}
	ELSE
	{	
    	if Type="2" s RowID=""
    	if RowID'=""
    	{
			&SQL(Update SQLUSER.DHC_EQCEquipAttribute Values :PLIST() where EA_RowID = :RowID)
			if SQLCODE
			{
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",SLQCODE)
			}
		}
		else
		{
			&SQL(insert into sqluser.DHC_EQCEquipAttribute values :PLIST())
			if SQLCODE
			{
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",SLQCODE)
			}
		}
	}
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
}

/// ----------------------------------
/// 创建:JYP  2019-09-02 
/// 描述:   查询设备属性明细
/// 	入参:Code:代码
/// 		 Name:名称
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTEquipAttribute","GetEquipAttributeData","","")
/// ----------------------------------
Query GetEquipAttributeData(Code As %String = "", Name As %String = "") As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TCode:%String,TName:%String,TGroup:%String,TRemark:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String")
{
}

ClassMethod GetEquipAttributeDataExecute(ByRef qHandle As %Binary, Code As %String = "", Name As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0

	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCEquipAttribute",rowid)) quit:rowid=""  d
	.q:($p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",5)="Y")
	.d ResetVariablesGetEquipAttributeData
	.s EARowID = rowid
	.s EACode = $p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",1)
	.q:(Code'="")&&(EACode'[Code)
	.s EAName = $p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",2)
	.q:(Name'="")&&(EAName'[Name)
	.s EAGroup = $p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",3)
	.s EARemark = $p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",4)
	.s EAHold1 = $p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",6)
	.s EAHold2 = $p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",7)
	.s EAHold3 = $p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",8)
	.s EAHold4 = $p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",9)
	.s EAHold5 = $p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",10)
	.d OutputRowGetEquipAttributeData
	
	Quit $$$OK
OutputRowGetEquipAttributeData
	Set TRow=TRow+1
	Set Data=$lb(TRow,EARowID,EACode,EAName,EAGroup,EARemark,EAHold1,EAHold2,EAHold3,EAHold4,EAHold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	quit
ResetVariablesGetEquipAttributeData
	Set (EARowID,EACode,EAName,EAGroup,EARemark,EAHold1,EAHold2,EAHold3,EAHold4,EAHold5)=""
	quit
}

ClassMethod GetEquipAttributeDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipAttributeDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEquipAttributeDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipAttributeDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
