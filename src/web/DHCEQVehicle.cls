Class web.DHCEQVehicle Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(web.DHCEQVehicle).SaveData("","",val,3,360,2)
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", SourceType As %Library.String = "", SourceID As %Library.String = "", isDel As %Library.String = "")
{
	new PLIST,rowid,SQLCODE
	s SQLCODE=0
	i (+isDel=1)	 //删除记录
	{
		s rowid=$p(val,"^",2)
		i (rowid'="")
		{
			&SQL(update SQLUSER.DHC_EQVehicle set V_InvalidFlag='Y' where V_RowID = :rowid)
		}
			
	}
	If (+isDel=2)
	{
		s rowid= $Order(^DHCEQVehicle(0,"Source",SourceType,SourceID,""))
		Set PLIST(2)=$Piece(val,"^",3)      //V_EquipDR
	 	Set PLIST(3)=$Piece(val,"^",4)      //V_VehicleNo
	 	Set PLIST(4)=$Piece(val,"^",5)      //V_EngineNo
	 	Set PLIST(5)=$Piece(val,"^",6)	    //V_CarFrameNo
	 	Set PLIST(6)=$Piece(val,"^",7)      //V_Displacemint
	 	Set PLIST(7)=$Piece(val,"^",8)      //V_Mileage
	 	Set PLIST(14)=$Piece(val,"^",15)     //V_SeatNum
	 	Set PLIST(15)=$Piece(val,"^",16)     //V_Origin
	 	Set PLIST(16)=$Piece(val,"^",17)    //V_Purpose
	 	Set PLIST(17)=$Piece(val,"^",18)	//V_Plait
	 	Set PLIST(18)=SourceType
	 	Set PLIST(19)=SourceID
	 	Set PLIST(20)="N"
	 	If (rowid="")
	 	{
			&SQL(Insert Into SQLUSER.DHC_EQVehicle Values :PLIST())
	 	}
		Else
		{
			&SQL(Update SQLUSER.DHC_EQVehicle Values :PLIST() where V_RowID=:rowid)
		}
	}
 	If SQLCODE Quit SQLCODE
	Quit 0
}

/// w ##Class(web.DHCEQVehicle).GetDHCEQVehicleByID("","",0,28)
ClassMethod GetDHCEQVehicleByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", SourceType As %Library.String = "", SourceID As %Library.String = "")
{
	; ^DHCEQVehicle(0,"Source",0,380,1)=
	New rowid,result
	Set rowid= $Order(^DHCEQVehicle(0,"Source",SourceType,SourceID,""))
	if rowid="" Quit ""
	Set result= $Get(^DHCEQVehicle(rowid))
	If $Piece(result,"^",19)="Y" Quit ""
	
	set result=rowid_"^"_result
	Quit result
}

ClassMethod PlaitList(name, width, type As %String = "") As %String
{
	;;下拉列表 ////
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=0></option>"
	w "<option value=1>财政在编</option>"
	w "<option value=2>非财政在编</option>"	
	w "</select>",!
}

ClassMethod VPurposeList(name, width, type As %String = "") As %String
{
	;;下拉列表 ////
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=1></option>"
	w "<option value=1>领导干部用车</option>"	
	w "<option value=2>一般公务用车</option>"
	w "<option value=3>执法执勤用车</option>"	
	w "<option value=4>专业技术用车</option>"
	w "<option value=5>其它用车</option>"
	w "</select>",!
}

}
