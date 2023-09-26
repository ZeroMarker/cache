Class ABN.dao.DHCDocAllergyInterface Extends %RegisteredObject
{

/// @desc 保存医嘱时,调用
/// 保存变态科试验医嘱
/// 
/// @params: 	OerdItemID	医嘱id, 	OE_OrdItem->OEORI_RowId
/// 			EpisodeID   病人就诊id,	PA_Adm->PAADM_RowId
/// 			ArcosID		医嘱套id,   ARCOrdSets->ARCOS_RowId
/// @return 
///        0 成功
/// 	  -1 失败
/// w ##class(ABN.dao.DHCDocAllergyInterface).SaveTest("27431||30",27752)
ClassMethod SaveTest(OeordItemID, EpisodeID)
{
	k ^Temp("ABN.dao.DHCDocAllergyInterface","SaveTest","Error")
	k ^Temp("ABN.dao.DHCDocAllergyInterface","SaveTest","inputParam")
	s ^Temp("ABN.dao.DHCDocAllergyInterface","SaveTest","inputParam",OeordItemID)=EpisodeID
	q:OeordItemID="" 0
	q:EpisodeID="" 0
	s Oeord = +OeordItemID
	s Oeordsub = $p(OeordItemID,"||",2)	
	s AcosId = ##class(web.DHCCTAllergyCureARCOS).GetAllergyARCOS(OeordItemID)
	q:+AcosId=0 0
	s ^Temp("ABN.dao.DHCDocAllergyInterface","SaveTest","inputParam",OeordItemID,AcosId)=""
	s Type = $p(^DHCCTACARCOS(AcosId),"^",4)
	s IsSkinFood = ##class(web.DHCCTAllergyCureARCOS).IsSkinFood(Type)		;食物组医嘱
	s IsSkinInhale = ##class(web.DHCCTAllergyCureARCOS).IsSkinInhale(Type)  ;吸入组医嘱
	s IsPatchType = ##class(web.DHCCTAllergyCureARCOS).IsPatchType(Type)    ;斑贴组医嘱
	s PatientID = $p(^PAADM(EpisodeID),"^",1)	
	q:$d(^ABN.DHCNurSkinTestRecSubI("OrdRowId"," "_OeordItemID)) -100	;已保存过的
	q:$d(^ABN.DHCNurPatchTestSubI("OrdRowId"," "_OeordItemID)) -100
	s ^Temp("ABN.dao.DHCDocAllergyInterface","SaveTest","inputParam",OeordItemID,"insert")=""
	s OEORIInstrDR=$p(^OEORD(Oeord,"I",Oeordsub,2),"^",7)	;用法	
	s ArcimId = $p(^OEORD(Oeord,"I",Oeordsub,1),"^",2)
	s Doctor = $p(^OEORD(Oeord,"I",Oeordsub,1),"^",11)
	s:Doctor'="" Doctor = $o(^SSU("SSUSR",0,"CTPCP",Doctor,""),-1)	;ssuser
	s $zt = "ERROR"
	i IsSkinFood||IsSkinInhale d
	.s TestId = ##class(ABN.dao.DHCNurSkinTestRec).CreateSkinBill(PatientID,EpisodeID,$s(IsSkinInhale:"S",1:"P"),Doctor)
	.d ##class(ABN.dao.DHCNurSkinTestRecSub).SaveSkinSub(TestId,OeordItemID,ArcimId,AcosId)
	i IsPatchType d
	.s TestId = ##class(ABN.dao.DHCNurPatchTest).CreatePatchBill(PatientID,EpisodeID,Doctor)
	.d ##class(ABN.dao.DHCNurPatchTestSub).SavePatchSub(TestId,OeordItemID,ArcimId,AcosId)
	q 0
		
ERROR
	S ^Temp("ABN.dao.DHCDocAllergyInterface","SaveTest","Error",$h)=$ze
	q -1_"^"_$ze
}

/// w ##class(ABN.dao.DHCDocAllergyInterface)UpdateAllergy(AllergyCureId, OeoriRowid)
/// 医生站保存医嘱后再回调,治疗单内写入医嘱Id,后台通过处方单成分插入费用医嘱
/// @params: AllergyCureId   治疗单Id
/// @params: OeoriRowid      医嘱Id
/// @return: 0^AllergyCureId
ClassMethod UpdateAllergy(AllergyCureId, OeoriRowid)
{
	s ^Temp("wanghc","ABN.dao.DHCDocAllergyInterface")=AllergyCureId_","_OeoriRowid
	s EpisodeID=""
	s CureObj = ##class(User.DHCDocAllergyCure).%OpenId(AllergyCureId)
	d CureObj.DACOEORIDRSetObjectId(OeoriRowid)
	s arcim = $p($g(^OEORD(+OeoriRowid,"I",$p(OeoriRowid,"||",2),1)),"^",2)
	d CureObj.DACARCIMDRSetObjectId(arcim)
	s EpisodeID = CureObj.DACPAADMDRGetObjectId()
	s sc=CureObj.%Save()
	If $$$ISERR(sc) Quit "-306^"_sc
	d CureObj.%Close()
	s CureObj=""
	;保存成分费用医嘱 2013-04-18
	if $d(^DHCDACi("DACOEORI",OeoriRowid)){
		s ReceiveDep = %session.Data("LOGON.CTLOCID") ;249
		s User=%session.Data("LOGON.USERID") ;2021
		s Loc=%session.Data("LOGON.CTLOCID") ;249
		s CureId = $o(^DHCDACi("DACOEORI",OeoriRowid,"")) 
		If CureId {
			d ##class(web.DHCDocAllergyCure).SaveFeeOrder(CureId,EpisodeID,ReceiveDep,User,Loc)
		}
	}
	q 0_"^"_AllergyCureId
}

ClassMethod Save(reqJson, userTableName, dateFormat As %Integer = 3)
{
	s ^Temp("JsonObject","Save",userTableName)=reqJson
	s $zt="ERROR"
	q:reqJson="" "-306^NullInparam"
	q:userTableName="" "-306^NullInparam"
	s jsonObj = ##class(ext.util.JsonObject).%New()
	s jsonObj.ContainNullValue=1	//删除属性值时用到
	s jsonObj.DateFormat=dateFormat
	d jsonObj.FromObject(reqJson)
	s obj = jsonObj.Bean(userTableName)	
	d jsonObj.%Close()
	s jsonObj=""
	s sc = obj.%Save()	
	If $$$ISERR(sc) Quit "-306^"_sc		
	s id = obj.%Id() 
	d obj.%Close()
	s obj = ""	
	q 0_"^"_id
ERROR 
	S ^Temp("JsonObject",userTableName,"Save","Error")=$ze
	s $ze=""
	q "-1^SaveError!"
}

/// d ##class(%ResultSet).RunQuery("ABN.dao.DHCDocAllergyInterface","FindPatInfo","9")
Query FindPatInfo(EpisodeID) As websys.Query(ROWSPEC = "PatientID,EpisodeID,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAPMIAge,Diagnosis,Mdeicare:%String:病案号,PAAdmDepCodeDesc") [ SqlProc ]
{
}

/// @params User.DHCDocAllergyCure表rowid
/// d ##class(%ResultSet).RunQuery("ABN.dao.DHCNurSkinTestRecSub","Find","1")
/// 不考虑一个病人有多个试验方式
ClassMethod FindPatInfoExecute(ByRef qHandle As %Binary, EpisodeID) As %Status
{
		set repid = $I(^CacheTemp)
		if $g(ind) = "" set ind = 0
		i EpisodeID="" set qHandle = $lb(0,repid,0) q $$$OK		
		s:EpisodeID'="" PatientID=$p(^PAADM(EpisodeID),"^",1)
		Set PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
		Set PAPMIName=$P(^PAPER(PatientID,"ALL"),"^",1)
		Set Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
		Set PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
		Set DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
		If DobDate'="" Do
		.Set PAPMIDOB=$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
		.Set PAPMIAge=$fn((+$H-DobDate)/365,"",0)
		Else  Set PAPMIDOB="",PAPMIAge=""
		Set mradm=$P(^PAADM(EpisodeID),"^",61)
		set Diagnosis=""
		If mradm'="" Set Diagnosis=##class(web.DHCDocOutPatientList).GetMRAdmDiagnosis(mradm) 
		set Mdeicare=$p(^PAPER(PatientID,"PAT",1),"^",22) //取得病人——病案号
		Set Loc=$P($g(^PAADM(EpisodeID)),"^",4)
		Set PAAdmDepCodeDesc=$P($g(^CTLOC(Loc)),"^",2) //就诊科室
		set:$l(PAAdmDepCodeDesc,"-")=2 PAAdmDepCodeDesc=$p(PAAdmDepCodeDesc,"-",2)

		set ind=ind+1
		set ^CacheTemp(repid,ind) = $lb(PatientID,EpisodeID,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAPMIAge,Diagnosis,Mdeicare,PAAdmDepCodeDesc)
		set qHandle = $lb(0,repid,0)
		Q $$$OK
}

/// Adm: {PA_Adm.PAADM_Rowid}
/// OrdItemStr:"医嘱项Rowid^医嘱数量^接收科室^医嘱自定义价格^标本代码^费别Rowid^开始日期^医嘱套Rowid^医嘱备注"_$C(1)_
/// 			;"医嘱项Rowid^医嘱数量^接收科室^医嘱自定义价格^标本代码^费别Rowid^开始日期^医嘱套Rowid^医嘱备注"
/// User:录入用户Rowid
/// Loc :录入科室Rowid
/// LABDATA:"LABDATA"
/// DocUserId:下医嘱医生用户Rowid
/// InsType:产生"未激活"医嘱标识,现在为"Lab"产生"未激活"医嘱,其他产生"核实医嘱"
/// w ##CLASS(ABN.dao.DHCDocAllergyInterface).InsertOrderItem(5809,"2048||1^1^194^^^^62642^^变态反应科执行治疗",3879,194,"LABDATA",1001,"")
ClassMethod InsertOrderItem(Adm, OrdItemStr, User, Loc, LABDATA, DocUserId, InsType)
{
	k ^Temp("wanghc","ABN.dao.DHCDocAllergyInterface","InsertOrderItem")
	s ^Temp("wanghc","insert",Adm)=Adm_","_ OrdItemStr_","_ User_","_ Loc_","_ LABDATA_","_ DocUserId_","_ InsType
	s $ZT ="Error"
	zn "DHC-DATA"
	s rtn = $$InsertOrderItem^DHCDocInterface(Adm,OrdItemStr,User,Loc,LABDATA,DocUserId,InsType)
	ZN "DHC-APP"
	q rtn
Error
	zn "DHC-APP"
	s ^Temp("wanghc","ABN.dao.DHCDocAllergyInterface","InsertOrderItem")=$ZE
	Q "-1^"_$ZE
}

/// @param: 	{OE_OrdItem->RowId} OeordItemID     						医嘱表的rowid
/// @return: {%String} 			SkinID^SkinDesc^SkinType^IsExec			
/// 				如果SkinType="Skin"  SkinID = ABN.DHCNurSkinTestRecSub表RowId IsExec=Y/N
/// 				如果SkinType="Patch" SkinID =  ABN.DHCNurPatchTestSub 表RowId IsExec=Y/N	
/// w ##class(ABN.dao.DHCDocAllergyInterface).GetSkinInfo("27431||68")
ClassMethod GetSkinInfo(OeordItemID)
{
	k ^Temp("wanghc","ABN.dao.DHCDocAllergyInterface","GetSkinInfo")
	s ^Temp("wanghc","ABN.dao.DHCDocAllergyInterface","GetSkinInfo")=OeordItemID
	s rtn = ##class(web.DHCCTAllergyCureARCOS).GetAllergyARCOS(OeordItemID)
	b
	s SkinID=0,SkinDesc="",SkinType="",IsExec="N"
	i rtn=0{
		;皮内注射
		s SkinID = $o(^ABN.DHCNurCureRecChildI("Oeorditem"," "_OeordItemID,""))		
		i SkinID'="" d
		.s subID = $o(^ABN.DHCNurCureRecChildI("Oeorditem"," "_OeordItemID,SkinID,""))
		.s SkinID = SkinID_"||"_subID
		.s ItmMastdr = $p(^OEORD(+OeordItemID,"I",$p(OeordItemID,"||",2),1),"^",2)
		.s ItmMastDesc = $p(^ARCIM(+ItmMastdr,$p(ItmMastdr,"||",2),1),"^",2)
		.s SkinDesc=ItmMastDesc
		.s SkinType="Exec"
		.s IsExec = "N"
	}else{
		s Type = $p(^DHCCTACARCOS(rtn),"^",4)
		s IsSkinFood = ##class(web.DHCCTAllergyCureARCOS).IsSkinFood(Type)		;食物组医嘱
		s IsSkinInhale = ##class(web.DHCCTAllergyCureARCOS).IsSkinInhale(Type)  ;吸入组医嘱
		s IsPatchType = ##class(web.DHCCTAllergyCureARCOS).IsPatchType(Type)    ;斑贴组医嘱
		s SkinType="Skin",SkinDesc=""
	
		if IsSkinFood d
		.s SkinID = $o(^ABN.DHCNurSkinTestRecSubI("OrdRowId"," "_OeordItemID,""))
		.s Obj = ##class(ABN.DHCNurSkinTestRec).%OpenId(+SkinID)
		.s:$IsObject(Obj) IsExec = Obj.IsExec, SkinDesc = Obj.GetDesc()
		.s SkinType="Skin"
	
		if IsSkinInhale d
		.s SkinID = $o(^ABN.DHCNurSkinTestRecSubI("OrdRowId"," "_OeordItemID,""))
		.s Obj = ##class(ABN.DHCNurSkinTestRec).%OpenId(+SkinID)
		.s SkinType="Skin"
		.s:$IsObject(Obj) IsExec = Obj.IsExec,SkinDesc=Obj.GetDesc()	
	
		if IsPatchType d
		.s SkinID = $o(^ABN.DHCNurPatchTestSubI("OrdRowId"," "_OeordItemID,""))
		.s Obj = ##class(ABN.DHCNurPatchTest).%OpenId(+SkinID)
		.s:$IsObject(Obj) IsExec = Obj.IsExec,SkinDesc = Obj.GetDesc()
		.s SkinType="Patch"
	}
	
	s:$g(IsExec)'="Y" IsExec = "N"	
	q SkinID_"^"_SkinDesc_"^"_SkinType_"^"_IsExec
}

//执行医嘱

ClassMethod RunExecOrdGroup(oeoriId, SeatNo, ctlocId, queryTypeCode, userId)
{
	s rtn =  ##class(web.DHCNurCom).UpdateOrdGroup("",oeoriId_"^"_SeatNo_"^"_ctlocId_"^^"_queryTypeCode,userId,1)
	q rtn
}

//撤销医嘱

ClassMethod CancelExecGroup(oeoriId, userId)
{
	s rtn = ##class(web.DHCNurCom).UpdateOrdGroup("",oeoriId,userId,0)
	q rtn
}

ClassMethod UpdatePatientQueueState(IPAddress, TreatAdmDr, QueueState, locId, userId)
{
	s ^Temp("wanghc","UpdatePatientQueueState")=IPAddress_","_TreatAdmDr_","_QueueState_","_locId_","_userId
	//IPAddress,TreatAdmDr,QueueState,locId,userId
	s rtn = ##class(web.DHCVISTreatQueue).UpdateQueueState(IPAddress,TreatAdmDr,QueueState,locId,userId)
	q rtn
}

}
