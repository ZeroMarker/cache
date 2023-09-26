Class web.DHCEQWashSP Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 24;

//设备入库打印

//d ##Class(web.DHCEQWashSP).GetPath();

ClassMethod GetPath(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
	&sql(select pathtoreports into :path from websys.configuration)
	q path
}

ClassMethod GetEquipDR(EquipDR As %Library.String = "")
{
	s TNo = $p($g(^DHCEQEquip(EquipDR)),"^",71)
	q TNo
}

ClassMethod GetList(WashDR As %Library.String = "")
{
	s Data=""
	s Num=0
	
	s sumQty=0
	s Rowid=0
	f  s Rowid=$o(^DHCEQWashList(Rowid))  quit:Rowid=""  d
	.s Model=""
	.s WashD=$p($g(^DHCEQWashList(Rowid)),"^",1)
	.q:WashD'=WashDR
	.s MasterItemDR=$p($g(^DHCEQWashList(Rowid)),"^",2) //设备项
	.i MasterItemDR '=""  d
	..s MasterItem = $p($g(^DHCEQCCode("DHCEQCMasterItem",MasterItemDR)),"^",1)
	.s ModelDR=$p($g(^DHCEQWashList(Rowid)),"^",3) //规格
	.i ModelDR '=""  d
	..s Model = $p($g(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)
	.s QuantityNum=$p($g(^DHCEQWashList(Rowid)),"^",4) //数量
	.s LocDR= $p($g(^DHCEQWashList(Rowid)),"^",5)
	.i LocDR '=""  d
	..s Loc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",LocDR)
	.s LocSendUserDR = $p($g(^DHCEQWashList(Rowid)),"^",6)
	.i LocSendUserDR '=""  d
	..s LocSendUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",LocSendUserDR)
	.s ReturnUserDR = $p($g(^DHCEQWashList(Rowid)),"^",7)
	.i ReturnUserDR '=""  d
	..s ReturnUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",ReturnUserDR)
	.s ReceiveUserDR = $p($g(^DHCEQWashList(Rowid)),"^",8)
	.i ReceiveUserDR '=""  d
	..s ReceiveUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",ReceiveUserDR)
	.s sumQty=sumQty+QuantityNum
	.s Data=Data_":"_MasterItem_"^"_Model_"^"_QuantityNum_"^"_Loc_"^"_LocSendUser_"^"_ReturnUser_"^"_ReceiveUser
	.s Num=Num+1
	i Data'=""  d
	.s Data=Data_":"_"合计"_"^"_"^"_"^"_"^"_sumQty_"^"_"^"_"^"_"^"_"^"_"^"_"^"
	.s Num=Num+1
	q Data_"_"_Num
}

}
