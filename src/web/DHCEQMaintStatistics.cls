Import SQLUser

/// Modified By HZY 2011-08-30 HZY0010
/// Description：修改查询 MaintStatistics .
Class web.DHCEQMaintStatistics Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 6;

ClassMethod GetOneMaintStatistics(PNum)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i PNum=0 q $o(^DHCEQTemp("MaintStatistics",User,""),-1)
	q $g(^DHCEQTemp("MaintStatistics",User,PNum))
}

ClassMethod MaintStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaintStatisticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod MaintStatisticsExecute(ByRef qHandle As %Binary, UseLocDR, EquipDR, MaintUserDR, StartDate, EndDate, QXType As %String = "", MaintType As %String = "") As %Status
{
	new repid, index, rowid, Maintcount, MaintFee
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	k ^DHCEQTemp("MaintStatistics",User)
	s index=1
	s TRow=0
	s rowid=0
	s PNum=1
	s Maintcount=0 //维修总次数
	s MaintFee=0 //维护总费用
	d BuildDataGetMaintStatistics
	Quit $$$OK
BuildDataGetMaintStatistics
	f  s rowid=$o(^DHCEQMaint(rowid))  quit:rowid=""  d
	.d ResetVariablesGetMaintStatistics
	.s TRowID=rowid
	.s TSourceID=$p($g(^DHCEQMaint(rowid)),"^",3)
	.;q:(TRequestLocDR="")              //不为空的记录是维修记录,为空的是保养记录
	.s TStatus=$p($g(^DHCEQMaint(rowid)),"^",13)
	.q:(TStatus'="2")                  //0为新增记录状态,1为已提交记录状态
	.i ((TSourceID'="")&&($p($g(^DHCEQMaint(rowid)),"^",2)="3"))  d
	..s TRequestNo=$p($g(^DHCEQMaintRequest(TSourceID)),"^",43)
	..s TRequestDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintRequest(TSourceID)),"^",13),"date")
	..s TRequestLocDR=$p($g(^DHCEQMaintRequest(TSourceID)),"^",2)
	..s TRequestLocDR=##class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLocDR)
	.s TEquipDR=$p($g(^DHCEQMaint(rowid)),"^",1)
	.q:(EquipDR'="")&&(EquipDR'=TEquipDR)
	.s TEquip=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.s TModelDR=$p($g(^DHCEQEquip(TEquipDR)),"^",3)
	.;add by dj 2009-05-21  dj0007
	.i TModelDR'="" s TModelDR=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TEquipDR=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	.
	.s TMaintDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaint(rowid)),"^",5),"date")
	.i StartDate="" s StartDate=0
	.i EndDate="" s EndDate=+$H
	.q:($p($g(^DHCEQMaint(rowid)),"^",5)>EndDate)||($p($g(^DHCEQMaint(rowid)),"^",5)<StartDate)
	.s TMaintUserDR=$p($g(^DHCEQMaint(rowid)),"^",7)
	.q:(MaintUserDR'="")&&(MaintUserDR'=TMaintUserDR)
	.i TMaintUserDR'=""  d
	..s TMaintUserDR=##class(web.DHCEQCommon).GetTrakNameByID("user",TMaintUserDR)
	.s TUseLocDR=$p($g(^DHCEQMaint(rowid)),"^",12)
	.q:(UseLocDR'="")&&(UseLocDR'=TUseLocDR)
	.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TUseLocDR))) //2010-10-29 DJ
	.s TMaintType=$p($g(^DHCEQMaint(rowid)),"^",2)
	.q:(MaintType'="")&&(TMaintType'=MaintType)
	.//Start Modified By HZY 2011-08-30 HZY0010
	.i TUseLocDR'="" d
	..s TUseLocDR=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	.//End Modified By HZY 2011-08-30 HZY0010
	.s TMaintFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMaint(rowid)),"^",9),"")
	.s Maintcount=Maintcount + 1
	.s MaintFee=##Class(web.DHCEQCommon).FormatNumber(MaintFee + TMaintFee,"")
	.i TMaintType=1 s TMaintType="保养"
	.i TMaintType=2 s TMaintType="检查"
	.i TMaintType=3 s TMaintType="维修"
	.Set TRow=TRow+1
	.d OutputRowGetMaintStatistics
	
	d ResetVariablesGetMaintStatistics
	s TRowID="-1"
	s TRow="合计"
	s TMaintDate="维护总次数:"
	s TMaintUserDR=Maintcount
	s TUseLocDR="维护总费用:"
	s TMaintFee=##Class(web.DHCEQCommon).FormatNumber(MaintFee,"")
	d OutputRowGetMaintStatistics
	quit
OutputRowGetMaintStatistics
	s Data=$lb(TRowID,TRequestLocDR,TRequestNo,TEquip,TEquipDR,TModelDR,TRequestDate,TMaintDate,TMaintUserDR,TUseLocDR,TMaintFee,TMaintType,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set ^DHCEQTemp("MaintStatistics",User,PNum)=TRowID_"^"_TRequestLocDR_"^"_TRequestNo_"^"_TEquip_"^"_TEquipDR_"^"_TModelDR_"^"_TRequestDate_"^"_TMaintDate_"^"_TMaintUserDR_"^"_TUseLocDR_"^"_TMaintFee_"^"_TMaintType
	s PNum=PNum+1
	quit
ResetVariablesGetMaintStatistics
	s (TRowID,TRequestLocDR,TRequestNo,TEquip,TEquipDR,TModelDR,TRequestDate,TMaintDate,TMaintUserDR,TUseLocDR,TMaintFee,TMaintType)=""
	quit
}

ClassMethod MaintStatisticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaintStatisticsExecute ]
{
	
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query MaintStatistics(UseLocDR, EquipDR, MaintUserDR, StartDate, EndDate, QXType As %String = "", MaintType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TRequestLocDR:%String,TRequestNo:%String,TEquip:%String,TEquipDR:%String,TModelDR:%String,TRequestDate:%String,TMaintDate:%String,TMaintUserDR:%String,TUseLocDR:%String,TMaintFee:%String,TMaintType:%String,TRow:%String")
{
}

ClassMethod GetPath(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
	&sql(select pathtoreports into :path from websys.configuration)
	q path
}

/**************************************************************************************************/
ClassMethod MaintTypeList(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=1>保养</option>"
	w "<option value=2>检查</option>"
	w "<option value=3>维修</option>"
	w "</select>",!
}

/// Modiy	20150616       ZY0129
/// d ##class(%ResultSet).RunQuery("web.DHCEQMaintStatistics","MaintListCostFee")
Query MaintListCostFee(QXType As %String = "", MonthStr As %String = "") As %Query(ROWSPEC = "Type:%String,RowID:%String,Equip:%String,EquipNo:%String,Model:%String,MaintRequestID:%String,RequestLocDR:%String,RequestLoc:%String,RequestNO:%String,UpdateDate:%String,TotalFee:%String,CostMonths:%String,CostFee:%String") [ SqlProc ]
{
}

ClassMethod MaintListCostFeeExecute(ByRef qHandle As %Binary, QXType As %String = "", MonthStr As %String = "") As %Status
{
	new repid, index,rowid
	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
	s index=1
	i MonthStr=""  d
	.s MonthStr=+$h
	e  d
	.s MonthStr=MonthStr_"-01"
	.s MonthStr=$ZDH(MonthStr_"-01",3)
	
	s rowid=0
	For  s rowid=$Order(^DHCEQMaint(rowid))  Quit:rowid=""  d
	.d ResVariablesMaintListCostFee
	.s DataList=$g(^DHCEQMaint(rowid))
	.s Type=$p(DataList,"^",2)
	.quit:Type'="3"	//类型:1,保养;2,检查;3,维修
	.quit:$p(DataList,"^",13)'="2"	//Status
	.s RowID = rowid
	.s EquipDR = $p(DataList,"^",1)
	.i EquipDR '=""  d
	..s Equip = $p($g(^DHCEQEquip(EquipDR)),"^",1)
	..s EquipNo = $p($g(^DHCEQEquip(EquipDR)),"^",71)
	..s Model = $p($g(^DHCEQEquip(EquipDR)),"^",3)
	..s Model = ##Class(web.DHCEQCommon).GetTrakNameByID("model",Model)
	.s MaintRequestID=$p(DataList,"^",3)
	.i MaintRequestID'="" d
	..s RequestLocDR = $p(^DHCEQMaintRequest(MaintRequestID),"^",2)
	..s RequestLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",RequestLocDR)
	..s RequestNO=$p(^DHCEQMaintRequest(MaintRequestID),"^",43)
	.
	.s UpdateDate=##class(web.DHCEQCommon).TransValueToPage(UpdateDate,"date")
	.
	.s TotalFee=$p(DataList,"^",9)
	.s CostMonths=+$p(DataList,"^",26) //记录维修费用分摊的月份
	.i CostMonths<1 s CostMonths=1
	.s AvgFee=TotalFee/CostMonths
	.s CostFee=AvgFee
	.//最后一个月用总金额-之前扣除的金额
	.s PasdMonths=##Class(web.DHCEQMonthDepre).GetMonthDiffrent($p(DataList,"^",19),+$H)
	.i (CostMonths-PasdMonths)=1 d
	..s CostFee=TotalFee-(PasdMonths*AvgFee)
	.s CostFee=##Class(web.DHCEQCommon).FormatNumber(AvgFee,"",2)
	.i PasdMonths>=CostMonths  s CostFee=0
	.d OutputRowMaintListCostFee
	Quit $$$OK
OutputRowMaintListCostFee
	s Data=$lb(Type,RowID,Equip,EquipNo,Model,MaintRequestID,RequestLocDR,RequestLoc,RequestNO,UpdateDate,TotalFee,CostMonths,CostFee)
	s ^CacheTemp(repid,index)=Data
	s index=index+1
	quit
ResVariablesMaintListCostFee
	s (DataList,Type,RowID,Equip,EquipNo,Model,MaintRequestID,RequestLocDR,RequestLoc,RequestNO,UpdateDate,TotalFee,CostMonths,CostFee)=""
	Quit
}

ClassMethod MaintListCostFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaintListCostFeeExecute ]
{
	s AtEnd=$LIST(qHandle,1)
 	s repid=$LIST(qHandle,2)
 	s ind=$LIST(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 		}
 	Else      {
 		s Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod MaintListCostFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaintListCostFeeExecute ]
{
	s repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
