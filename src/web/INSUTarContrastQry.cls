Class web.INSUTarContrastQry Extends %RegisteredObject
{

/// 查询医保目录对照信息
/// Creator JinShuai1010
/// input:Type,HisCode,HisDesc,HisAlias,InsuCode,InsuDesc,InsuAlias,HospId
Query GetTarConInfo(Type As %String, HisCode As %String, HisDesc As %String, HisAlias As %String, InsuCode As %String, InsuDesc As %String, InsuAlias As %String, HospId As %String) As %Query(ROWSPEC = "INTCTHisDesc:%String,INTCTHisCode:%String,TARIPrice:%String,INTCTInsuCode:%String,INTCTInsuDesc:%String,INTCTActiveDate:%String,INTCTExpiryDate:%String,HISRowId:%String,INSURowId:%String,TarConRowId:%String") [ SqlProc ]
{
}

/// d ##Class(%ResultSet).RunQuery("web.INSUTarContrastQry","GetTarConInfo","00A","","","","XJ01CAA040E001020702699","","","2")
ClassMethod GetTarConInfoExecute(ByRef qHandle As %Binary, Type As %String, HisCode As %String, HisDesc As %String, HisAlias As %String, InsuCode As %String, InsuDesc As %String, InsuAlias As %String, HospId As %String) As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)	
	
	q:$g(Type)="" $$$OK

	s Flag=0
	//根据医保拼音码查询
	i (+Flag=0)&&(InsuAlias'="") d
	.s id=""
	.f  s id=$O(^DHCINTIM(id)) q:id=""  d
	..s str=$g(^DHCINTIM(id))
	..s IInsuAlias=$P(str,"^",5)
	..q:IInsuAlias'[InsuAlias
	..s insuId=id
	..s Nid=""
	..f  s Nid=$O(^DHCINTCT(Nid)) q:Nid=""  d
	...s Nstr=$g(^DHCINTCT(Nid))
	...s hospid=$p(Nstr,"^",27)
	...q:hospid'=HospId
	...i +insuId=+$P(Nstr,"^",4) d
	.... s TarConRowId=Nid
	.... s ConID=Nid
	.... s hisId=$P(Nstr,"^",1)
	.... d InsuSelect
	.... s Flag=1

	//根据医保编码模糊查询
	//	^DHCINTCT("0","HOSP",{INTCT_HospDr},"INSUTID",{INTCT_Insu_Dr},{INTCT_Rowid})
	//INSUTarItems    (^DHCINTIM)      	^DHCINTIM("0","CODE",$$ALPHAUP({INTIM_xmbm}),{INTIM_Rowid})
	//^DHCINTIM("0","HOSP",{INTIM_HospDr},"CODE",$$ALPHAUP({INTIM_xmbm}),{INTIM_Rowid})
	//i (+Flag=0)&&(InsuCode'="") d
	
	
	
	
	
	i (+Flag=0)&&(InsuCode'="") d
	
	.s DHCINTIMDR=""
	.s FromtInsuCode=$$ALPHAUP^SSUTIL4(InsuCode)
	.s DHCINTIMDR=$O(^DHCINTIM("0","HOSP",HospId,"CODE",FromtInsuCode,DHCINTIMDR))
	.s id=""
	.f    s id=$O(^DHCINTCT("0","HOSP",HospId,"INSUTID",DHCINTIMDR,id))  q:id=""   d
	..s ConStr=$g(^DHCINTCT(id))
	..s ConType=$P(ConStr,"^",12)
	..s IInsuCode=$P(ConStr,"^",5)
	..s insuId=$P(ConStr,"^",4)
	..s hisId=$P(ConStr,"^",1)
	..s TarConRowId=id
	..s ConID=id
	..b ;3
	..q:insuId=""
	..b ;
	..d InsuSelect
	..s Flag=1
	
	
    //根据医保名称模糊查询
	i (+Flag=0)&&(InsuDesc'="") d
	.s id=""
	.f    s id=$O(^DHCINTCT(id))  q:id=""   d
	..s ConStr=$g(^DHCINTCT(id))
	..s ConType=$P(ConStr,"^",12)
	..s hospid=$p(ConStr,"^",27)
	..q:hospid'=HospId
	..q:ConType'=Type
	..s IInsuDesc=$P(ConStr,"^",6)
	..q:IInsuDesc'[InsuDesc
	
	..s insuId=$P(ConStr,"^",4)
	..s hisId=$P(ConStr,"^",1)
	..s ConID=id
	..s TarConRowId=id
	..q:insuId=""
	..d InsuSelect
	..s Flag=1

	
	//根据收费项拼音码查询
	i (+Flag=0)&&(HisAlias'="") d
	.s id=""
	.f    s id=$O(^DHCTARAL(id)) q:id=""  d
	..s str=$g(^DHCTARAL(id))
	..s HHisAlias=$P(str,"^",3)
	..q:HHisAlias'[HisAlias
	
	..s hisId=$P(str,"^",1)
	..s Cid=""
	..f    s Cid=$O(^DHCINTCT(Cid)) q:Cid=""  d
	...s Cstr=$g(^DHCINTCT(Cid))
	...s hospid=$p(Cstr,"^",27)
	...q:hospid'=HospId
	...i +hisId=+$P(Cstr,"^",1) d
	....s ConID=Cid
	....s TarConRowId=Cid
	....s insuId=$P(Cstr,"^",4)
	....d HisSelect
	....s Flag=1
	
	
	//根据收费项编码模糊查询
	i (+Flag=0)&&(HisCode'="") d
	.s id=""
	.f    s id=$O(^DHCINTCT(id))  q:id=""   d
	..s ConStr=$g(^DHCINTCT(id))
	
	..s ConType=$P(ConStr,"^",12)
	..s hospid=$p(ConStr,"^",27)
	..q:hospid'=HospId
	..q:ConType'=Type
	..s HHisCode=$P(ConStr,"^",2)
	..q:HHisCode'[HisCode
	..s insuId=$P(ConStr,"^",4)
	..s hisId=$P(ConStr,"^",1)
	..s TarConRowId=id
	..s ConID=id
	..q:hisId=""
	
	..d HisSelect
	..s Flag=1
	
	//根据收费项名称模糊查询
	i (+Flag=0)&&(HisDesc'="") d
	.s id=""
	.f    s id=$O(^DHCINTCT(id))  q:id=""   d
	..s ConStr=$g(^DHCINTCT(id))
	..s ConType=$P(ConStr,"^",12)
	..s hospid=$p(ConStr,"^",27)
	..q:hospid'=HospId
	..q:ConType'=Type
	..s HHisDesc=$P(ConStr,"^",3)
	..q:HHisDesc'[HisDesc
	..s insuId=$P(ConStr,"^",4)
	..s hisId=$P(ConStr,"^",1)
	..s ConID=id
	..s TarConRowId=id
	..q:hisId=""
	..d HisSelect
	..s Flag=1
	

   Quit $$$OK
	
InsuSelect	

	s InsuStr=$g(^DHCINTIM(insuId))
	s InsuType=$P(InsuStr,"^",2)
	
	q:InsuType'=Type
	s INTCTInsuCode=$P(InsuStr,"^",3) 
	q:(InsuCode'="")&&(INTCTInsuCode'[InsuCode)
	s INTCTInsuDesc=$P(InsuStr,"^",4)  
	q:(InsuDesc'="")&&(INTCTInsuDesc'[InsuDesc)
	s Alias=$p(InsuStr,"^",5)
	q:(InsuAlias'="")&&(Alias'[InsuAlias)
	
	s HisStr=$g(^DHCTARI(hisId))
    s INTCTHisCode=$p(HisStr,"^",1)
    q:(HisCode'="")&&(INTCTHisCode'[HisCode)
    s INTCTHisDesc=$p(HisStr,"^",2)
    q:(HisDesc'="")&&(INTCTHisDesc'[HisDesc)
    s Aid=""
    f Aid=$O(^DHCTARAL(Aid))   q:Aid=""   d
    .f AStr=$g(^DHCTARAL("A",hisId,Aid))
    .f hisAlias=$p(AStr,"^",3)
    .q:(HisAlias'="")&&(hisAlias'[HisAlias)
   d BuildData
	
	q
HisSelect
    s HisStr=$g(^DHCTARI(hisId))
    s INTCTHisCode=$p(HisStr,"^",1)
    q:(HisCode'="")&&(INTCTHisCode'[HisCode)
    s INTCTHisDesc=$p(HisStr,"^",2)
    q:(HisDesc'="")&&(INTCTHisDesc'[HisDesc)
    s Aid=""
    f Aid=$O(^DHCTARAL(Aid))   q:Aid=""   d
    .f AStr=$g(^DHCTARAL("A",hisId,Aid))
    .f hisAlias=$p(AStr,"^",3)
    .q:(HisAlias'="")&&(hisAlias'[HisAlias)
    s InsuStr=$g(^DHCINTIM(insuId))
	s InsuType=$P(InsuStr,"^",2)
	
	q:InsuType'=Type
	s INTCTInsuCode=$P(InsuStr,"^",3) 
	q:(InsuCode'="")&&(INTCTInsuCode'[InsuCode)
	s INTCTInsuDesc=$P(InsuStr,"^",4)  
	q:(InsuDesc'="")&&(INTCTInsuDesc'[InsuDesc)
	s Alias=$p(InsuStr,"^",5)
	q:(InsuAlias'="")&&(Alias'[InsuAlias)
   d BuildData
    q
BuildData
    //处理出参
   s InsuStr=$g(^DHCINTIM(insuId))
   s InsuType=$P(InsuStr,"^",2)

	q:InsuType'=Type
	s INTCTInsuCode=$P(InsuStr,"^",3)    
    s INTCTInsuDesc=$P(InsuStr,"^",4)
    
    s HisStr=$g(^DHCTARI(hisId))
    s INTCTHisCode=$p(HisStr,"^",1)
    s INTCTHisDesc=$p(HisStr,"^",2)
    s TARIPrice=$p($g(^DHCTARI((hisId),"P",(1))),"^",5)
    i TARIPrice<1  d
    . s TARIPrice="0"_TARIPrice
    
    s ConStr=$g(^DHCINTCT(ConID))
    s INTCTActiveDate=##class(websys.Conversions).DateLogicalToHtml($p(ConStr,"^",13))
    s ExpiryDate=$p(ConStr,"^",20)
	
    i ExpiryDate'="" d
    .s INTCTExpiryDate=##class(websys.Conversions).DateLogicalToHtml(ExpiryDate)
	e                d
	.s INTCTExpiryDate=""
	
    s HISRowId=hisId
    s INSURowId=insuId
    
    d BuildQryNew 
   q

BuildQryNew 	

    s Data=$lb(INTCTHisDesc,INTCTHisCode,TARIPrice,INTCTInsuCode,INTCTInsuDesc,INTCTActiveDate,INTCTExpiryDate,HISRowId,INSURowId,TarConRowId) 
    s ^CacheTemp(repid,ind)=Data  
    s ind=ind+1
    
	Quit $$$OK
}

ClassMethod GetTarConInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTarConInfoExecute ]
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

ClassMethod GetTarConInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTarConInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

///  根据收费找医嘱项
/// input:收费项编码
/// Creator JinShuai1010
Query GetArcItmInfo(TarRowid As %String, HospId As %String) As %Query(ROWSPEC = "ARCIMDesc:%String,ARCIMCode:%String,ARCIMRowId:%String,ARCIMEffDate:%String,ARCIMEffDateTo:%String") [ SqlProc ]
{
}

/// d ##Class(%ResultSet).RunQuery("web.INSUTarContrastQry","GetArcItmInfo","1771","2")
ClassMethod GetArcItmInfoExecute(ByRef qHandle As %Binary, TarRowid As %String, HospId As %String) As %Status
{
	
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
    s OLTARCIMDR=0   //医嘱项rowid  123||1
	s ARCIMSubscript=0 //医嘱项  123
	s ARCIMVersion=0   //医嘱项  1
 


    s rset=##class(BILL.Interface.Inside.Service).IQryARCIMListByTarItm(TarRowid,,)

	 While (rset.Next()){

		s ARCIMRowId=rset.GetDataByName("id")	        //医嘱项iD
        s ARCIMSubscript=$p(ARCIMRowId,"||",1)
        s ARCIMVersion=$p(ARCIMRowId,"||",2)
  
   
        s HospitalDR=$g(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",1))
        q:HospitalDR'=HospId                       //判断院区
		s ARCIMCode=rset.GetDataByName("code")  
		s ARCIMDesc=rset.GetDataByName("text")
		s ARCIMEffDate=rset.GetDataByName("effDateFrom")
		s ARCIMEffDateTo=rset.GetDataByName("effDateTo")
		
         b ;rset
	}

    s Data=$lb(ARCIMDesc,ARCIMCode,ARCIMRowId,ARCIMEffDate,ARCIMEffDateTo) 
    s ^CacheTemp(repid,ind)=Data  
    s ind=ind+1
    
    d rset.Close()
	k rset
	
	Quit $$$OK
}

ClassMethod GetArcItmInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetArcItmInfoExecute ]
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

ClassMethod GetArcItmInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetArcItmInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

// 2022/11/30

// 查询所有医保目录

Query GetAllArcItmInfo(Qrydesc As %String, HospId As %String) As %Query(ROWSPEC = "TARICode:%String,TARIDesc:%String") [ SqlProc ]
{
}

/// d ##Class(%ResultSet).RunQuery("web.INSUTarContrastQry","GetAllArcItmInfo","ASP","2")
ClassMethod GetAllArcItmInfoExecute(ByRef qHandle As %Binary, Qrydesc As %String, HospId As %String) As %Status
{
	
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

    


    s id=0
	f    s id=$O(^DHCINTIM(id))  q:id=""  d
	.s TARIstr=$g(^DHCINTIM(id))
	.s TARICode=$p(TARIstr,"^",3)
    .s TARIDesc=$p(TARIstr,"^",4)
	.s INTIMxmrj=$p(TARIstr,"^",5)
	.s tHospId=$p(TARIstr,"^",45)
	.b ;tHospId
    .q:tHospId'=HospId
	.i (TARICode[Qrydesc)||(TARIDesc[Qrydesc)||(INTIMxmrj[Qrydesc) d
	..d BuildQryNew 
	
   
BuildQryNew 

    s Data=$lb(TARICode,TARIDesc) 
    s ^CacheTemp(repid,ind)=Data  
    s ind=ind+1



	Quit $$$OK
}

ClassMethod GetAllArcItmInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllArcItmInfoExecute ]
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

ClassMethod GetAllArcItmInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllArcItmInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

// W ##class(web.INSUTarContrastQry).UpdateConTar("54^","2022-12-28","","1","5147^","00A","1","23","2")

ClassMethod UpdateConTar(InString As %String, ActiveDate As %String, ExpiryDate As %String, Account As %String, HisID As %String, INSUType As %String, userID As %String, INSUID As %String, HospDr As %String = "") As %String
{
	s Active=$zdh(ActiveDate,3)
	i ExpiryDate=""    d
	.s Expiry=""
    else      d
	.s Expiry=$zdh(ExpiryDate,3)

	s index=1
	while(1){

		s rowid=$p(InString,"^",index)
		s HisRowid=$p(HisID,"^",index)
		q:rowid=""
        
		
		s Constr=$g(^DHCINTCT(rowid))
		s INTCTHospDr=$P(Constr,"^",27)
		q:HospDr'=INTCTHospDr
        s INTCTHisDr=$P(Constr,"^",1)
        s INTCTHisCode=$P(Constr,"^",2)
		s INTCTHisDesc=$P(Constr,"^",3)
		s INTCTInsuDr=$P(Constr,"^",4)
		s INTCTInsuCode=$P(Constr,"^",5)
		s INTCTInsuDesc=$P(Constr,"^",6)
		s INTCTClass=$P(Constr,"^",7)
		s INTCTLevel=$P(Constr,"^",8)
		s INTCTPatTypeDr=$P(Constr,"^",9)
		s INTCTAmount=$P(Constr,"^",10)
		s INTCTDrAddFlag=$P(Constr,"^",11)
		s INTCTDicType=$P(Constr,"^",12)
		s INTCTActiveDate=$P(Constr,"^",13)
		s INTCTZText=$P(Constr,"^",14)
		s INTCTUserDR=$P(Constr,"^",15)
		s INTCTDate=$P(Constr,"^",16)
		s INTCTTime=$P(Constr,"^",17)
		s INTCTADDIP=$P(Constr,"^",18)
		s INTCTUnique=$P(Constr,"^",19)
		s INTCTExpiryDate=$P(Constr,"^",20)
		s INTCTUpLoadDate=$P(Constr,"^",21)
		s INTCTUpLoadTime=$P(Constr,"^",22)
		s INTCTDownLoadDate=$P(Constr,"^",23)
		s INTCTDownLoadTime=$P(Constr,"^",24)
		s INTCTLastModDate=$P(Constr,"^",25)
		s INTCTLastModTime=$P(Constr,"^",26)
		s INTCTHospDr=$P(Constr,"^",27)
		s INTCTAuditUser=$P(Constr,"^",28)
		s INTCTAuditDate=$P(Constr,"^",29)
		s INTCTAuditTime=$P(Constr,"^",30)

        &SQL(

	     UPDATE  SQLUser.INSU_TarContrast
	     SET 	INTCT_ExpiryDate=:Active
	    WHERE INTCT_Rowid=:rowid
	  )   //原纪录失效
       
        	
			
	

       s HisStr=$g(^DHCTARI(HisRowid))
	   s HisCode=$p(HisStr,"^",1)
	   s HisDesc=$p(HisStr,"^",2)
	   s INSUstr=$g(^DHCINTIM(INSUID))

	   s INSUCode=$p(INSUstr,"^",3)
	   s INSUDesc=$p(INSUstr,"^",4)
	
		&SQL(
	     INSERT  INTO SQLUser.INSU_TarContrast
		 (INTCT_His_Dr,INTCT_HisCode,INTCT_HisDesc,INTCT_Insu_Dr,INTCT_InsuCode,INTCT_InsuDesc,INTCT_Amount,INTCT_ActiveDate,INTCT_DicType,INTCT_User_Dr,INTCT_ExpiryDate,INTCT_HospDr)
		VALUES 
		 (:HisRowid,:HisCode,:HisDesc,:INSUID,:INSUCode,:INSUDesc,:Account,:Active,:INSUType,:userID,:Expiry,:HospDr)    
	  ) //插入新纪录

		s index=index+1
		
		

	}
	
	if (SQLCODE=0)
	   {
		   s result="0"
		   
		   }
		else
		{
			s result="1"
			}
			q result
}

// 添加失效时间

// w ##class(web.INSUTarContrastQry).AddExpiry("249^255^259^","2022-12-05","2")

ClassMethod AddExpiry(InString As %String, ExpiryDate As %String, HospDr As %String) As %String
{
    s index=1
    i ExpiryDate="" {q "请输入失效时间"}
   
	s Expiry=$zdh(ExpiryDate,3)
	while(1){
		s rowid=$p(InString,"^",index)
		q:rowid=""
		s tHospDr=$p($g(^DHCINTCT(rowid)),"^",27)
	
		
		q:tHospDr'=HospDr
		
		&SQL(

	     UPDATE  SQLUser.INSU_TarContrast
	     SET 	INTCT_ExpiryDate=:Expiry
	     WHERE INTCT_Rowid=:rowid
	)
		s index=index+1
		
        
		

	}
	q SQLCODE
}

}
