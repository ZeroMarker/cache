Import SQLUser

Class web.DHCEQEquipBatchUpdate Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 124;

/**************************************************************************/
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST, Flag, InstockListDR
 /************************************************/
 s Flag=isDel //更新范围,1:全部,0部分
 s ModelOperMethod=##class(web.DHCEQCommon).GetSysInfo("201004") //2009-07-10 党军
 if ##class(web.DHCEQCommon).ExistsElement(val,"Name")=1
 {	s PLIST(2) =##class(web.DHCEQCommon).GetDataByName(val,"Name") }
 if ##class(web.DHCEQCommon).ExistsElement(val,"ABCType")=1
 {	s PLIST(3) =##class(web.DHCEQCommon).GetDataByName(val,"ABCType") }
 if ModelOperMethod=1 //2009-07-10 党军 begin
 {
 	if ##class(web.DHCEQCommon).ExistsElement(val,"Model")=1
 	{	s PLIST(4) =##class(web.DHCEQCommon).GetDataByName(val,"Model") }
 }
 else
 {
	if ##class(web.DHCEQCommon).ExistsElement(val,"ModelDR")=1
 	{	s PLIST(4) =##class(web.DHCEQCommon).GetDataByName(val,"ModelDR") }
 } //2009-07-10 党军 end
 if ##class(web.DHCEQCommon).ExistsElement(val,"EquiCatDR")=1
 {	s PLIST(5) =##class(web.DHCEQCommon).GetDataByName(val,"EquiCatDR") }
 if ##class(web.DHCEQCommon).ExistsElement(val,"UnitDR")=1
 {	s PLIST(6) =##class(web.DHCEQCommon).GetDataByName(val,"UnitDR") }
 if ##class(web.DHCEQCommon).ExistsElement(val,"Code")=1
 {	s PLIST(7) =##class(web.DHCEQCommon).GetDataByName(val,"Code") }
 if ##class(web.DHCEQCommon).ExistsElement(val,"LeaveFactoryDate")=1
 {	
 	if ##class(web.DHCEQCommon).GetDataByName(val,"LeaveFactoryDate")'=""
 	{
	 	s PLIST(12) =##class(web.DHCEQCommon).TransValueFromPage(##class(web.DHCEQCommon).GetDataByName(val,"LeaveFactoryDate"),"date")
 	}
 }
 if ##class(web.DHCEQCommon).ExistsElement(val,"CountryDR")=1
 {	s PLIST(17) =##class(web.DHCEQCommon).GetDataByName(val,"CountryDR") }
 if ##class(web.DHCEQCommon).ExistsElement(val,"OriginDR")=1
 {	s PLIST(21) =##class(web.DHCEQCommon).GetDataByName(val,"OriginDR") }
 if ##class(web.DHCEQCommon).ExistsElement(val,"FromDeptDR")=1
 {	s PLIST(22) =##class(web.DHCEQCommon).GetDataByName(val,"FromDeptDR") }
 if ##class(web.DHCEQCommon).ExistsElement(val,"BuyTypeDR")=1
 {	s PLIST(24) =##class(web.DHCEQCommon).GetDataByName(val,"BuyTypeDR") }
 if ##class(web.DHCEQCommon).ExistsElement(val,"ManuFactoryDR")=1
 {	s PLIST(27) =##class(web.DHCEQCommon).GetDataByName(val,"ManuFactoryDR") }
 if ##class(web.DHCEQCommon).ExistsElement(val,"LimitYearsNum")=1
 {	s PLIST(32) =##class(web.DHCEQCommon).GetDataByName(val,"LimitYearsNum") }
 if ##class(web.DHCEQCommon).ExistsElement(val,"DepreMethodDR")=1
 {	s PLIST(34) =##class(web.DHCEQCommon).GetDataByName(val,"DepreMethodDR") }
 if ##class(web.DHCEQCommon).ExistsElement(val,"DepreTotalFee")=1
 {	s PLIST(36) =##class(web.DHCEQCommon).GetDataByName(val,"DepreTotalFee") }
 if ##class(web.DHCEQCommon).ExistsElement(val,"DesignWorkLoadNum")=1
 {	s PLIST(37) =##class(web.DHCEQCommon).GetDataByName(val,"DesignWorkLoadNum") }
 if ##class(web.DHCEQCommon).ExistsElement(val,"WorkLoadUnitDR")=1
 {	s PLIST(38) =##class(web.DHCEQCommon).GetDataByName(val,"WorkLoadUnitDR") }
 if ##class(web.DHCEQCommon).ExistsElement(val,"MemoryCode")=1
 {	s PLIST(62) =##class(web.DHCEQCommon).GetDataByName(val,"MemoryCode") }
 if ##class(web.DHCEQCommon).ExistsElement(val,"EquipTypeDR")=1
 {	s PLIST(64) =##class(web.DHCEQCommon).GetDataByName(val,"EquipTypeDR") }
 if ##class(web.DHCEQCommon).ExistsElement(val,"PurchaseTypeDR")=1
 {	s PLIST(65) =##class(web.DHCEQCommon).GetDataByName(val,"PurchaseTypeDR") }
 if ##class(web.DHCEQCommon).ExistsElement(val,"PurposeTypeDR")=1
 {	s PLIST(66) =##class(web.DHCEQCommon).GetDataByName(val,"PurposeTypeDR") }
 if ##class(web.DHCEQCommon).ExistsElement(val,"ServiceDR")=1
 {	s PLIST(70) =##class(web.DHCEQCommon).GetDataByName(val,"ServiceDR") }
 if ##class(web.DHCEQCommon).ExistsElement(val,"ServiceTel")=1
 {	s PLIST(74) =##class(web.DHCEQCommon).GetDataByName(val,"ServiceTel") }
 if ##class(web.DHCEQCommon).ExistsElement(val,"StatCatDR")=1
 {	s PLIST(76) =##class(web.DHCEQCommon).GetDataByName(val,"StatCatDR") }
 if ##class(web.DHCEQCommon).ExistsElement(val,"InStockListDR")=1
 {	s InstockListDR =##class(web.DHCEQCommon).GetDataByName(val,"InStockListDR")}
 /***********************************************/
 Set $ZT="ERROR" //2009-07-10 党军
 TSTART //2009-07-10 党军
 s PLIST(4)=##Class(web.DHCEQCModel).UpdModel(PLIST(4)) //2009-07-09 党军 begin
 if SQLCODE
 {
	 TROLLBACK
	 q SQLCODE
 } //2009-07-09 党军  end
 i (Flag=1) //更新全部
 {
	 &SQL(Update SQLUSER.DHC_EQEquip Values :PLIST() where EQ_InStockListDR = :InstockListDR)
	 s Flag="All"
 }
 else //更新部分
 {
	 
 }
 if SQLCODE
 {
	 TROLLBACK //2009-07-10 党军
	 q SQLCODE
 }
 TCOMMIT //2009-07-10 党军
 q Flag
ERROR //2009-07-10 党军 begin
 	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK		       //回滚事务
 	Quit "<ERROR>"_ErrorMsg     //返回错误消息 ; //2009-07-10 党军 end
}

/**************************************************************************/
}
