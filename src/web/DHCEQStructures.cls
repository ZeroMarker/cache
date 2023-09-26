/// Create by GR0021 构筑物资产卡片
Class web.DHCEQStructures Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// VAL=AssetType_"^"_SRowID_"^"_...
/// w ##Class(web.DHCEQStructures).Save("3^^1^2^1^^4^N","0","1")
ClassMethod Save(VAL As %Library.String = "", SOURCETYPE As %Library.String = "", SOURCEID As %Library.String = "", ISDEL As %Library.String = "")
{
	i (+ISDEL=1)	 //删除记录
	{
		Set SRowID = $Piece(VAL,"^",2)
		i (SRowID'="")
		{
			&SQL(update SQLUSER.DHC_EQStructures set S_InvalidFlag='Y' where S_RowID = :SRowID)
		}	
	}
	else
	{
		New List,SRowID
		quit:""=SOURCETYPE -1
		quit:""=SOURCEID -1
		Set SRowID = $Order(^DHCEQStructures(0,"Source",SOURCETYPE,SOURCEID,-1))
		//q:""=SRowID -1
	
		//Set List(1) = $Piece(VAL,"^",2)		;SRowID
		Set List(2) = $Piece(VAL,"^",3)		;SStructDR
 		Set List(3) = $Piece(VAL,"^",4)		;SPlace
    	Set List(4) = $Piece(VAL,"^",5)		;SOwnerFlag
    	Set List(5) = $Piece(VAL,"^",6)		;SOwnerKind
  		If $Piece(VAL,"^",7)'="" Set List(6) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(VAL,"^",7),"date")		;SCompletionDate
  		Set List(7) = $Piece(VAL,"^",8)		;SRemark
  		Set List(8) = "N"					;SInvalidFlag
   		Set List(9) =SOURCETYPE			;SSourceType
   		Set List(10) =SOURCEID				;SSourceID
	
		If (SRowID'="") 
		{
			&SQL(Update SQLUSER.DHC_EQStructures Values :List() where S_RowID = :SRowID)
		}
		Else
		{
			&SQL(Insert Into SQLUSER.DHC_EQStructures Values :List())
		}
	}
	Quit SQLCODE
}

/// w ##Class(web.DHCEQStructures).GetDHCEQStructuresByID(0,1)
ClassMethod GetDHCEQStructuresByID(SOURCETYPE As %Library.String = "", SOURCEID As %Library.String = "")
{
	
	New SRowID,result
	//--------------------------DHC_EQStructures-------------------------------------------
	s SCount=7
	Set SRowID= $Order(^DHCEQStructures(0,"Source",SOURCETYPE,SOURCEID,""))
	if SRowID="" quit ""
	if $P($Get(^DHCEQStructures(SRowID)),"^",7)="Y" Quit "" //SInvalidFlag
	
	Set result=SRowID
	Set result=result_"^"_$P($Get(^DHCEQStructures(SRowID)),"^",1)
	Set result=result_"^"_$P($Get(^DHCEQStructures(SRowID)),"^",2)		;SStructDR
	Set result=result_"^"_$P($Get(^DHCEQStructures(SRowID)),"^",3)		;SPlace
	Set result=result_"^"_$P($Get(^DHCEQStructures(SRowID)),"^",4)		;SOwnerKind
	Set result=result_"^"												
	If $P($Get(^DHCEQStructures(SRowID)),"^",5)'="" Set result=result_##Class(web.DHCEQCommon).TransValueToPage($P($Get(^DHCEQStructures(SRowID)),"^",5),"date") ;SCompletionDate 		
	Set result=result_"^"_$P($Get(^DHCEQStructures(SRowID)),"^",6)		;SRemark
	
	
	//--------------------------DHC_EQEquip--------------------------------------------------
	s EQCount=1
	Set result=result_"^"
	i SOURCETYPE=1	Set result=result_##Class(web.DHCEQCommon).TransValueToPage($p(^DHCEQEquip(SOURCEID),"^",53),"date")  //EQ_AddDate
	
	
	//--------------------------DHC_EQCBuildingStruct--------------------------------------------------
	s BSCount=1
	Set result=result_"^"
	i $P($Get(^DHCEQStructures(SRowID)),"^",1)'=""  Set result=result_$p(^DHCEQCCode("DHCEQCBuildingStruct",$P($Get(^DHCEQStructures(SRowID)),"^",1)),"^",2)
	
	//----------------------------------------------------------------------------------------------
	
	
	
	
	Quit result
}

ClassMethod SOwnerFlagList(name, width, type As %String = "") As %String
{
	;;下拉列表 ////
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=0>无产权</option>"
	w "<option value=1>有产权</option>"
	w "<option value=2>产权待界定</option>"
	
	w "</select>",!
}

ClassMethod SOwnerKindList(name, width, type As %String = "") As %String
{
	;;下拉列表 ////
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=0>国有</option>"
	w "<option value=1>集体</option>"
	
	w "</select>",!
}

}
