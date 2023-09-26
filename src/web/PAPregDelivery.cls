Class web.PAPregDelivery Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 153;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "DEL_RowId";

Parameter SQLDESCRIPTION = "DEL_RowId";

Parameter SQLROWID = "DEL_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Default implementation of LookUp Query.
ClassMethod FindByAdmClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindByAdmFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindByAdmExecute(ByRef QHandle As %Library.Binary, PAPregnancyID As %String = "", DELAdmID As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindByAdmFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindByAdmExecute ]
{
}

/// yanglei
/// epId 就诊号（分娩管理)
/// w ##Class(web.PAPregDelivery).GetIdByEpId(77089)
ClassMethod GetIdByEpId(epId As %String) As %String
{
    n TRowid
	s TRowid=""
	&SQL(select DEL_RowId into:TRowid from SQLUser.PA_PregDelivery where DEL_Adm_DR=:epId)
	i SQLCODE=0 q TRowid
	q ""
}

ClassMethod DoAugMethExist(delId As %String) As %Integer
{
}

ClassMethod DoIndMethExist(delId As %String) As %Integer
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave0418(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
	if new {
		s %request.Data("NewDelivery",1)=1
	}
	s ^zhou("over")=$g(%request.Data("TOVERRIDE",1))
	/*
	if ##class(User.PAPregDelivery).%OpenId(id).ChildPAPregDelBaby.Count()=0,$g(%request.Data("TOVERRIDE",1))="" {
		d ##Class(websys.Component).GetComponentMessages(.t,"PAPregDelivery.Edit")
		d msg.AddItem("W","", $s($d(t("ENTER_BABIES")):t("ENTER_BABIES"),1:"Baby/Fetus details have not been entered."), compid, "ENTER_BABIES")
	}
	*/
	q $$$OK
}

/// s val="" i $d(%request.Data("PARREF",1)) s obj2=##Class(User.PAPregnancy).%OpenId($g(%request.Data("PARREF",1))) 
/// i obj2 s val = obj2.PREGFetusThisPreg.PLURDesc
/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
	if new {
		s %request.Data("NewDelivery",1)=1
	}
	s parref=$g(%request.Data("PARREF",1))
	s PREGFetusThisPreg=$g(%request.Data("PREGFetusThisPreg",1))
	s PREGFetusThisPregId = ##class(web.PACBabyPlurality).GetIdFromCodeOrDescription(PREGFetusThisPreg)
	if (parref'="") ,(PREGFetusThisPregId>0){
		set tempObj = ##class(User.PAPregnancy).%OpenId(parref)
		if 
		do tempObj.PREGFetusThisPregSetObjectId(PREGFetusThisPreg)
		do tempObj.%Save()
		do tempObj.%Close()
		set tempObj=""
		set DeliveryOBJ=##class(User.PAPregDelivery).%OpenId(id)
		If $IsObject(DeliveryOBJ){
			do DeliveryOBJ.DELPluralitySetObjectId(PREGFetusThisPregId) 
			do DeliveryOBJ.%Save()
			do DeliveryOBJ.%Close()
			set DeliveryOBJ=""
		}
	}
	
	/*
	if ##class(User.PAPregDelivery).%OpenId(id).ChildPAPregDelBaby.Count()=0,$g(%request.Data("TOVERRIDE",1))="" {
		d ##Class(websys.Component).GetComponentMessages(.t,"PAPregDelivery.Edit")
		d msg.AddItem("W","", $s($d(t("ENTER_BABIES")):t("ENTER_BABIES"),1:"Baby/Fetus details have not been entered."), compid, "ENTER_BABIES")
	}
	*/
	q $$$OK
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
	/*
	q:id=""
	set DeliveryOBJ=##class(User.PAPregDelivery).%OpenId(id)
	set DeliveryOBJ.DELCervixDilation=%request.Get("DELCervixDilation")
	set rs=DeliveryOBJ.%Save()
	*/	
	q:id="" 1
	
	q $$$OK
}

Query FindByAdm(PAPregnancyID As %Library.String, DELAdmID As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,DELLabourMethodDesc,TotalBirths,FirstBirthDate,FirstBirthTime,FirstBirthMethod,FirstBirthOutcome,OnsetDate,OnsetTime")
{
}

// d ##class(web.PAPregDelivery).websysDelete("1810||1")

ClassMethod websysDelete(id As %Library.String)
{
	
	s PregnancyRowID=+id
    s deliverID=$P(id,"||",2)
    q:deliverID=""
    s mEpisodeID=$p(^PAPRG(PregnancyRowID,"DEL",deliverID),"^",1)
    s ifBabyHasOrder=..ifHasOrder(mEpisodeID)
    q:ifBabyHasOrder=1 "婴儿已有医嘱,无法删除!"
	s babyRowID=0  f  s babyRowID=$o(^PAPRG(PregnancyRowID,"DEL",deliverID,"BABY",babyRowID)) q:babyRowID=""  d     
	 .s ID=PregnancyRowID_"||"_deliverID_"||"_babyRowID
	 .d ##class(web.PAPregDelBaby).websysDeleteRenumber(ID)
	 s rs=##class(User.PAPregDelivery).%DeleteId(id)
}

/// Creator：   SongChao
/// CreatDate： 2018.2.28
/// Description： 判断母亲分娩的婴儿是否已经有医嘱
/// Table： 
/// Input：MotherEpisodeID
/// Output：0:没有 1：有
/// Others： ##class( ()
ClassMethod ifHasOrder(MotherEpisodeID)
{
 s babyAdmDr="",ret=0
 f  s babyAdmDr=$o(^PAADMi("Mother",MotherEpisodeID,babyAdmDr)) q:(babyAdmDr=""!ret=1)  d
 .s oeordID=$o(^OEORD(0,"Adm",babyAdmDr,""))
 .i $g(oeordID)'=""  s ret=1
 q ret
}

}
