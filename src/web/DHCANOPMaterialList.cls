Class web.DHCANOPMaterialList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 20191017+dyl+手术其他非主要信息展示
/// w ##class(web.DHCANOPMaterialList).InsertMaterial(200,10,"1",6)
ClassMethod InsertMaterial(opaId As %String, cssdpack As %String, number As %String, userId As %String)
{
    q:opaId="" "opaId不能为空"
    q:cssdpack="" "材料包不能为空"
    q:number="" "数量不能为空"
	s curdate=+$h
	s curtime=$p($h,",",2)
	s iId="",ret=""
 	f  s iId = $o(^DHCANOPMaterial("MDetail",0,"CSSDOnOpaId",opaId,iId)) q:iId=""  d
 	.s materialList = $g(^DHCANOPMaterial("MDetail",iId))
 	.s tcssdr = $list(materialList,1)
 	.i cssdpack=tcssdr s ret="已登记该材料包,请在原有基础上添加"
 	q:ret'="" ret
	&SQL(insert into SQLUSER.DHC_AN_OpMaterialList(ANOPM_OpaId,ANOP_MCssdDr,ANOP_MCssdNum,ANOP_MUpdateUserDr,ANOP_MUpdateDate,ANOP_MUpdateTime) Values (:opaId,:cssdpack,:number,:userId,:curdate,:curtime ))
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	q SQLCODE
}

/// w ##class(web.DHCANOPMaterialList).DeleteMaterial("3")
ClassMethod DeleteMaterial(rowId) As %String
{
	s ret=0
	i rowId'="" d
			.&SQL(delete from SQLUSER.DHC_AN_OpMaterialList where ANOPMaterial_RowId=:rowId)
			.i SQLCODE TROLLBACK 
			.i SQLCODE'=0 d
				..i ret=0 s ret=SQLCODE
				..e  s ret=ret_"/"_SQLCODE
	q ret
}

/// w ##class(web.DHCANOPMaterialList).UpdateMaterial("5","申","3","Y","Y","","A")
ClassMethod UpdateMaterial(rowId As %String, cssdpack As %String, number As %String, userId As %String) As %String
{
	q:rowId="" "请选择一条记录更新"
    q:cssdpack="" "材料包不能为空"
    q:number="" "数量不能为空"
    s curvalue=$g(^DHCANOPMaterial("MDetail",rowId))
    s opaId=$list(curvalue,6)
	s uId="",ret=""
 	f  s uId = $o(^DHCANOPMaterial("MDetail",0,"CSSDOnOpaId",opaId,uId)) q:uId=""  d
 	.s materialList = $g(^DHCANOPMaterial("MDetail",uId))
 	.s tcssdr = $list(materialList,1)
 	.i (cssdpack=tcssdr)&(rowId'=uId) s ret="已登记该材料包,请在原有基础上添加"
 	q:ret'="" ret

	s curdate=+$h
	s curtime=$p($h,",",2)

	s ret=0

	&Sql(update SQLUser.DHC_AN_OpMaterialList set ANOP_MCssdDr=:cssdpack,ANOP_MCssdNum=:number,ANOP_MUpdateUserDr=:userId,ANOP_MUpdateDate=:curdate,ANOP_MUpdateTime=:curtime where ANOPMaterial_RowId=:rowId)
	.i SQLCODE TROLLBACK 
			.i SQLCODE'=0 d
				..i ret=0 s ret=SQLCODE
				..e  s ret=ret_"/"_SQLCODE
	q ret
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPMaterialList","FindMaterialList","","","")
Query FindMaterialList(opaId) As %Query(ROWSPEC = "RowId:%String,tcssdr:%String,cssdpack:%String,tnumber:%String")
{
}

ClassMethod FindMaterialListExecute(ByRef qHandle As %Binary, opaId) As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	s Id=""
 	f  s Id = $o(^DHCANOPMaterial("MDetail",0,"CSSDOnOpaId",opaId,Id)) q:Id=""  d
 	.s materialList = $g(^DHCANOPMaterial("MDetail",Id))
 	.s tcssdr = $list(materialList,1)
 	.s cssdpack=$li(^User.CSSDPackageD(tcssdr),5)
	.i $l(cssdpack,"-")>1 s cssdpack=$p(cssdpack,"-",2)
 	.s tnumber = $list(materialList,2)
 	.d OutPut
 	s qHandle=$lb(0,repid,0)
	q $$$OK
OutPut
 	s Data=$lb(Id,tcssdr,cssdpack,tnumber)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q 0
}

ClassMethod FindMaterialListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMaterialListExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {			
 		s Row=^CacheTemp(repid,ind)
 		//w "<b>"_$List(Row,3)_"</b>"
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindMaterialListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMaterialListExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPMaterialList","MaterialList","2019-08-07","","N")
Query MaterialList(stdate, enddate, showDetail As %String = "N") As %Query(ROWSPEC = "opaId,room,ordno,Id,tcssdr,cssdpack,tnumber,opName,regNo,patName")
{
}

ClassMethod MaterialListExecute(ByRef qHandle As %Binary, stdate, enddate, showDetail As %String = "N") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 		s sdate=##Class(web.DHCANOPCom).ConvertToDateH(stdate)
	s edate=##Class(web.DHCANOPCom).ConvertToDateH(enddate)
	k roomList,cssdList
 f date=sdate:1:+edate d
	.s opaId=""
	.f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
		..s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
		..s oproom=""
		..i oproomdr'="" s oproom=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
		..e  s oproom="未排"
		..q:oproom=""
		..s opordno=$P(^DHCANOPArrange(opaId),"^",26) 
		..i +opordno=0 s opordno="未排"
		..
		..s roomList(oproom,opordno,opaId)=""
	s tmproomdr="" 
	f  s tmproomdr=$o(roomList(tmproomdr)) q:tmproomdr=""  d
		.s tmpord=""
		.f  s tmpord=$o(roomList(tmproomdr,tmpord)) q:tmpord=""  d
			..s tmpopaId=""
			..f  s tmpopaId=$o(roomList(tmproomdr,tmpord,tmpopaId)) q:tmpopaId=""  d
				...q:$d(^DHCANOPMaterial("MDetail",0,"CSSDOnOpaId",tmpopaId))<1
		 		...s admId=$P(^DHCANOPArrange(tmpopaId),"^",1)
		 		...s chl=$P($P(^DHCANOPArrange(tmpopaId),"^",2),"||",2)
		 		...s papmiId=$p($g(^PAADM(admId)),"^",1)
		 		...s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		 		...s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
		 		...s opName=""
		 		...s subchl=0 f  s subchl=$O(^OR(admId,"ANA",chl,"OP",subchl)) q:(subchl="")  d
					....s opdr=$P(^OR(admId,"ANA",chl,"OP",subchl),"^",6)       		;ANAOP_Type_DR     ；手术名称
					....i opdr'=""  d
						.....i $P($g(^ORC("OPER",+opdr)),"^",2)'="" d     
							......i opName'="" s opName=opName_";"  
							......s opName=opName_$P($g(^ORC("OPER",+opdr)),"^",2)     
		 		...d OutPutRoomTotal
				...s Id=""
			 	...f  s Id = $o(^DHCANOPMaterial("MDetail",0,"CSSDOnOpaId",tmpopaId,Id)) q:Id=""  d
				 	....s materialList = $g(^DHCANOPMaterial("MDetail",Id))
				 	....s tcssdr = $list(materialList,1)
				 	....s cssdpack=$li(^User.CSSDPackageD(tcssdr),5)
					....i $l(cssdpack,"-")>1 s cssdpack=$p(cssdpack,"-",2)
				 	....s tnumber = $list(materialList,2)
				 	....s cssdList(tcssdr,tmpopaId)=cssdpack_"^"_tnumber
				 	....q:showDetail="N"
				 	....d OutPutdetail
 	s cssdid=""
 	f  s cssdid=$o(cssdList(cssdid)) q:cssdid=""  d
 		.s singlenum=0
 		.s cssdopaId="" f  s cssdopaId=$o(cssdList(cssdid,cssdopaId)) q:cssdopaId=""  d
 			..s cssdpack=$p(cssdList(cssdid,cssdopaId),"^",1)
 			..s num=$p(cssdList(cssdid,cssdopaId),"^",2)
 			..s singlenum=singlenum+num
 		.d OutPutTotalPack
 	s qHandle=$lb(0,repid,0)
	q $$$OK

OutPutTotalPack
 	s Data=$lb("总计","","","",cssdid,cssdpack,singlenum,"","","")
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q 0
 		
OutPutdetail
	
 	s Data=$lb("","","",Id,tcssdr,cssdpack,tnumber,"","","")
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q 0
 	
OutPutRoomTotal
	q:showDetail="N"
 	s Data=$lb(tmpopaId,tmproomdr,tmpord,"-","-","-","-",opName,regNo,patName)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q 0
}

ClassMethod MaterialListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaterialListExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {			
 		s Row=^CacheTemp(repid,ind)
 		//w "<b>"_$List(Row,3)_"</b>"
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod MaterialListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaterialListExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// w ##class(web.DHCANOPMaterialList).GetPatBaseInfo(130,"164","","In")
ClassMethod GetPatBaseInfo(EpisodeID, opaId, userId, type) As %String
{
	s ward="",operLocId="",operLocDesc="",appDocId="",appDocDesc="",bedCode=""
	s opDescStr="",anMethodStr="",preDiagStr="",otherinfo="",postinfo="",outinfo=""
	s admReasonDr=$p($g(^PAADM(EpisodeID,1)),"^",7)
	i admReasonDr'="" s admReason=$P(^PAC("ADMREA",admReasonDr),"^",2) //费别
	s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)
	s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
	i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
	i curWardId'="" s ward=$P($G(^PAWARD(curWardId)),"^",2)
	i $l(ward,"-")>1 s ward=$p(ward,"-",2)
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
		s SecretLevel="",secretCode=""	;病人密级级别
	s SecretLevel=##class(web.DHCClinicCom).GetPatLevelByPapmiId(EpisodeID)
	;secretCode:密级,patLevel:级别
	i SecretLevel'="" s secretCode=$p($g(SecretLevel),"^",4),patLevel=$p($g(SecretLevel),"^",2)

	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,EpisodeID)
	s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	
	s locId=$P($g(^PAADM(EpisodeID)),"^",4)
	s locDes=$P(^CTLOC(locId),"^",2)
	i type="In" d
		.s IPDefOpLocId=$g(^DHCCLSet("AnOp","IPDefOpLoc"))
		.i IPDefOpLocId'="" d
			..s operLocId=IPDefOpLocId
			..s operLocDesc=$p(^CTLOC(operLocId),"^",2)
	s operLoc=operLocId_"!"_operLocDesc
	i userId'="" d
		.s appDocId=$p($g(^SSU("SSUSR",userId)),"^",14)
		.q:appDocId=""
		.s appDocDesc=##class(web.DHCANOPCom).GetNameById(appDocId)
	s appDoc=appDocId_"!"_appDocDesc
	s appLoc=locId_"!"_locDes
	i opaId="" d SetRetData1 q retStr
	s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	s anaSub=$P(anaId,"||",2)
	s EpisodeID=$P(anaId,"||",1)
	s opSub=0 f  s opSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",opSub)) q:(opSub="")  d
		.s preDigDrStr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",4)     ;ANAOP_PreopDiag_DR 术前诊断S //zhangtao add
		.s num=$l(preDigDrStr,"|")
		.f di=1:1:num d
			..s dr=$p(preDigDrStr,"|",di)
			..q:dr=""
			..s desc=$P(^MRC("ID",dr),"^",2)
			..s item=desc
			..i preDiagStr="" s preDiagStr=item
			..e  s preDiagStr=preDiagStr_","_item
	.s opDes=""
	.s opDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",6)         ;ANAOP_Type_DR     ；手术名称
	.i opDr'="" d
		..i $D(^ORC("OPER",opDr)) d
			...s opDes=$P(^ORC("OPER",opDr),"^",2)
		..i opDescStr'=""  s opDescStr=opDescStr_","_opDes
		..e  s opDescStr=opDes
	
	s anMethDr=$P(^OR(EpisodeID,"ANA",anaSub),"^",5)       ;ANA_Method	麻醉方法
	i anMethDr'="" d
		.s anMethNum=$l(anMethDr,"|")
		.f i=1:1:anMethNum d
		..s anMethId=$p(anMethDr,"|",i)
		..q:anMethId=""
		..s anMethDesc=$p($g(^ORC("ANMET",anMethId)),"^",2)
		..i $P(anMethDesc,"-",2)'="" s anMethDesc=$P(anMethDesc,"-",2)
		..i anMethodStr="" s anMethodStr=anMethId_"!"_anMethDesc
		..e  s anMethodStr=anMethodStr_","_anMethId_"!"_anMethDesc	
	d SetRetData1 q retStr
SetRetData1
	//病人基本信息
	s patientBaseInfo=EpisodeID_"^"_patName_"^"_regNo_"^"_sex_"^"_age_"^"_locDes_"^"_ward_"^"_bedCode_"^"_admReason_"^"_SecretLevel_"^"_secretCode
    s operInfo=anMethodStr_"^"_opDescStr_"^"_preDiagStr
    //
    s retStr=patientBaseInfo_"@"_operInfo_"@"
}

}
