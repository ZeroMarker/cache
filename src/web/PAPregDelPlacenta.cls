Class web.PAPregDelPlacenta Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 76;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "PLAC_RowId";

Parameter SQLDESCRIPTION = "PLAC_RowId";

Parameter SQLROWID = "PLAC_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetLatestPlacentaOrder(PARREF As %Library.String = "") As %Library.Integer
{
	&sql(select max(PLAC_PlacentaNo) into:PlacentaOrder from SQLUser.PA_PregDelPlacenta where  PLAC_ParRef=:PARREF)
	q $g(PlacentaOrder)
}

/// yanglei
/// //delId为User.PAPregDelivery 
ClassMethod GetMaxPlacDod(delId As %String) As %String
{
	s maxPlacDod=""
	&SQL(select PLAC_DelDate into:maxPlacDod from SQLUser.PA_PregDelPlacenta where PLAC_ParRef=:delId)
	i SQLCODE=0&(maxPlacDod'="")
	q maxPlacDod
	else
	q ""
}

/// yanglei
/// //delId为User.PAPregDelivery 
ClassMethod GetMaxPlacTod(delId As %String) As %String
{
	s maxPlacDod="",maxPlacTod=""
	&SQL(select PLAC_DelDate into:maxPlacDod from SQLUser.PA_PregDelPlacenta where PLAC_ParRef=:delId)
	i SQLCODE=0&maxPlacDod'=""
	{&SQL(select PLAC_DelTime into:maxPlacTod from SQLUser.PA_PregDelPlacenta where PLAC_ParRef=:delId and PLAC_DelDate=:maxPlaDod)
	q maxPlacTod
	}
	else
	{q ""}
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
	set ^TEMP("yl","PAPregDelPlacentaAterSave")=compref_","_id_","_new
	set $zt="saveError"
    //update from SQLUser.PA_PregDelPlacenta  PLAC_UpdateDate 	PLAC_UpdateTime 	PLAC_UpdateUser_DR 	PLAC_UpdateHospital_DR
    q:id="" 1
    
    s (CordInsertionID,MembranceCond,MembRuptureCode,MachineTurn,PLACSize,LiquorAmoutID,LiquorAbnormalID,LiquorStatusID,LiquorStatusID)=""
   
    s CordInsertionID=##class(web.PACCordInsertion).GetIdFromCodeOrDescription(%request.Get("CordInsertion"))
    
    set placentaObj=##class(User.PAPregDelPlacenta).%OpenId(id)
    set placentaObj.PLACUpdateDate=+$h
    set placentaObj.PLACUpdateTime=$p($h,",",2)  
     do placentaObj.PLACUpdateUserDRSetObjectId($g(%session.Data("LOGON.USERID")))
      //胎膜情况
    do:CordInsertionID'="" placentaObj.PLACMembraneCondDRSetObjectId(%request.Get("MembranceCond"))
    do placentaObj.PLACCordInsertionDRSetObjectId(CordInsertionID)
    
    set rs=placentaObj.%Save()
    set placentaObj=""
    
  

	//脐长
	set CordLength=%request.Get("CordLength")
	//脐附着
	set CordInsertionID=%request.Get("CordInsertionID")
	//胎膜破裂代码
	set MembRuptureCode=%request.Get("MembRuptureCode")
	//机转
	set MachineTurn=%request.Get("MachineTurn")
	//胎盘大小
	set PLACSize=%request.Get("PLACSize")
	//羊水量
	set LiquorAmoutID=%request.Get("LiquorAmoutID")
	//羊水异常
	set LiquorAbnormalID=%request.Get("LiquorAbnormalID")
	//羊水性状
	set LiquorStatusID=%request.Get("LiquorStatusID")
    set ^TEMP("yl","PAPregDelPlacta")=CordLength_","_CordInsertionID_","_MembRuptureCode_","_MachineTurn_","_PLACSize_","_LiquorAmoutID
    s pregDr=$p(id,"||",1)
    s delSub=$p(id,"||",2)
    s PlacSub=$p(id,"||",3)
    s PlacInfo=$g(^PAPRG(pregDr,"DEL",delSub,"PLAC",PlacSub,"DHC"))
    s:PlacInfo="" ^PAPRG(pregDr,"DEL",delSub,"PLAC",PlacSub,"DHC")=""
    s $p(^PAPRG(pregDr,"DEL",delSub,"PLAC",PlacSub,"DHC"),"^",1)=MembRuptureCode
    s $p(^PAPRG(pregDr,"DEL",delSub,"PLAC",PlacSub,"DHC"),"^",2)=MachineTurn
    s $p(^PAPRG(pregDr,"DEL",delSub,"PLAC",PlacSub,"DHC"),"^",3)=PLACSize
    s $p(^PAPRG(pregDr,"DEL",delSub,"PLAC",PlacSub,"DHC"),"^",4)=LiquorAmoutID
    s $p(^PAPRG(pregDr,"DEL",delSub,"PLAC",PlacSub,"DHC"),"^",5)=LiquorAbnormalID
	s $p(^PAPRG(pregDr,"DEL",delSub,"PLAC",PlacSub,"DHC"),"^",6)=LiquorStatusID
	
	s BabyIDDetail=%request.Get("BabyIDDetail")    
	i BabyIDDetail'="" d
    .s num=$l(BabyIDDetail,"^")
    .f i=1:1:num d
    ..s BabyID=$p(BabyIDDetail,"^",i)
	..q:BabyID=""
	..&SQL(Update SQLUser.DHC_PA_PregDelBaby set BABY_Placenta_dr=:id	 Where  BABY_RowID=:BabyID )
	
	
	quit 1
saveError
     set ^TEMP("yl","PAPregDelPlacenta.AfterSave",$h)=$ze
     q 0
}

ClassMethod websysDeleteRenumber(id As %Library.String)
{
	q:id=""
	&sql(delete from SQLUser.PA_PregDelPlacenta where PLAC_RowId=:id)
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
	q $$$OK
}

}
