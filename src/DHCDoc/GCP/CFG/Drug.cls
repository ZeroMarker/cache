/// CTOR: QP
/// DATE: 2022-03-11
/// DESC: 药物临床试验项目药品
Class DHCDoc.GCP.CFG.Drug Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2022-03-11
/// DESC: 保存SAE
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.GCP.CFG.Auth).Save(^TEMP("wxnn",1))
ClassMethod Save(BaseParamJson As %String) As %String
{
	s ^TEMP("wxnn",1)=BaseParamJson
	k BaseParamArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(BaseParamJson,.BaseParamArr)
	s ID=BaseParamArr("ID")	
	s CurrentDate=+$h,CurrentTime=$p($h,",",2)
	s DProjectID=BaseParamArr("DProjectID")
	s DArcimDR=BaseParamArr("DArcimDR")
	s InType=BaseParamArr("InType")
	i InType = "ARC" {
		i ID = "" {
			s SaveOBJ = ##class(User.DHCDocPilotProDrug).%New()
			D SaveOBJ.DProjectIDSetObjectId(BaseParamArr("DProjectID"))
			S SaveOBJ.DAddDate=CurrentDate
			S SaveOBJ.DAddTime=CurrentTime
			D SaveOBJ.DAddUserSetObjectId(BaseParamArr("DAddUser"))
			i $d(^User.DHCDocPilotProDrugI("ProjectArcim",DProjectID,DArcimDR)) {
					Quit "-1^配置已存在！"
			}
			
		} else  {
			s SaveOBJ = ##class(User.DHCDocPilotProDrug).%OpenId(ID)	
		}
		D SaveOBJ.DArcimDRSetObjectId(BaseParamArr("DArcimDR"))
		s sc = SaveOBJ.%Save()
		If $$$ISERR(sc) {
			//d $system.OBJ.DisplayError(sc) 
			Quit "-1^保存失败！"
		}
		s MID=SaveOBJ.%Id()
		k SaveOBJ
	} else {
		
	}
	
	q MID_"^保存成功！"
}

/// CTOR: QP
/// DATE: 2022-03-04
/// DESC: 
/// IN  : 
/// OUT : 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCP.CFG.Drug","DrugList",11)
Query DrugList(InPrj = "", InDesc = "") As %Library.Query(ROWSPEC = "id,DArcim,DAddDate,DAddUser")
{
}

ClassMethod DrugListExecute(ByRef qHandle As %Library.Binary, InPrj = "", InDesc = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	if (InPrj="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s InDesc=$zcvt(InDesc,"U")
	s id=""
	f  s id=$o(^User.DHCDocPilotProDrugI("Project",InPrj,id)) q:id=""  d
	.s DArcimDR=$lg(^User.DHCDocPilotProDrugD(id),3)
	.s DAddDate=$lg(^User.DHCDocPilotProDrugD(id),4)
	.s DAddTime=$lg(^User.DHCDocPilotProDrugD(id),5)
	.s DAddUser=$lg(^User.DHCDocPilotProDrugD(id),6)
	.s ARC=+DArcimDR,SUB=$P(DArcimDR,"||",2)
	.s DArcim=$p(^ARCIM(ARC,SUB,1),"^",2)
	.s DArcimUP=$zcvt(DArcim,"U")
	.q:(InDesc'="")&&(DArcimUP'[InDesc)
	.s DAddDate=##class(websys.Conversions).DateLogicalToHtml(DAddDate)
	.s DAddTime=$zt(DAddTime,2)
	.s DAddUser=$p(^SSU("SSUSR",DAddUser),"^",2)
	.s DAddDate=DAddDate_" "_DAddTime
	.d OuputRow1
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OuputRow1
	set Data=$lb(id,DArcim,DAddDate,DAddUser)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod DrugListFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = DrugListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DrugListClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = DrugListFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2022-03-04
/// DESC: 删除
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCP.CFG.Drug).Delete("")
ClassMethod Delete(ID As %String)
{
	Q:ID="" 0
	&SQL(DELETE FROM SQLUser.DHCDocPilotProDrug WHERE ID=:ID)
	Q SQLCODE
}

}
