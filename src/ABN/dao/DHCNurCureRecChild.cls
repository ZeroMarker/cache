Class ABN.dao.DHCNurCureRecChild Extends %RegisteredObject
{

/// WeekNo,CureDate,HealthExcepFlag,Antihistamine,PeakFlowRate,AssessmentDoc,Upperarm,BottleNo,Density,InjectionVolume,MissionWind,blushes,urticaria,Nose,Asthma,LaryngealEdema,Shock,Other,Memo,injectionNurse,Status,MissionWind2,blushes2,oeorditem,Oeorditem)
Query Find(CureID) As websys.Query(ROWSPEC = "ID,WeekNo,CureDate,HealthExcepFlag,Antihistamine,PeakFlowRate,AssessmentDoc,Upperarm,BottleNo,Density,InjectionVolume,MissionWind,blushes,urticaria,Nose,Asthma,LaryngealEdema,Shock,Other,Memo,injectionNurse,Status,MissionWind2,blushes2,Oeorditem,HasBadResponse,InjectFee,InjectFeePaid")
{
}

/// d ##class(%ResultSet).RunQuery("ABN.dao.DHCNurCureRecChild","Find","17","")
ClassMethod FindExecute(ByRef qHandle As %Binary, CureID As %String) As %Status
{
	set repid = $I(^CacheTemp)
	if $g(ind) = "" set ind = 0
	s CureSub = 0 
	f  s CureSub = $o(^ABN.DHCNurCureRecD(CureID,"ChildSub",CureSub)) q:CureSub=""  s item=^(CureSub)  d
	.;s obj = ##class(ABN.DHCNurCureRecChild).%OpenId(CureID_"||"_CureSub)
	.s $list(item,1)=CureID_"||"_CureSub
	.s ind = ind+1
	.s ^CacheTemp(repid,ind) = item
	.;s CheckDate = $list(item,3)
	.;s WeekDate = CheckDate
	.s HasBadResponse=0
	.s BadSub = $o(^ABN.DHCNurCureRecD(CureID,"ChildSub",CureSub,"BadSub",""),-1)	
	.s:BadSub'="" HasBadResponse=1
	.s len=$listlength(^CacheTemp(repid,ind))
	.s $list(^CacheTemp(repid,ind),len+1)=HasBadResponse
	.s oeoriRowid = $lg(item,25) ;收费医嘱的id
	.s InjectFee=0,InjectFeePaid=0
	.i oeoriRowid'="" d
	..s itmDr = $p(^OEORD(+oeoriRowid,"I",$p(oeoriRowid,"||",2),1),"^",2)
	..s StDate = $p(^OEORD(+oeoriRowid,"I",$p(oeoriRowid,"||",2),3),"^",7) ;OEORI_Date
	..s InjectFee = $p(##class(web.UDHCJFPRICE).GetOrderPrice("","",itmDr,StDate, "", "", "", "",""),"^",1)
	..s InjectFeePaid = $p(^OEORD(+oeoriRowid,"I",$p(oeoriRowid,"||",2),3),"^",5)	;OEORI_Billed
	.s ^CacheTemp(repid,ind)=^CacheTemp(repid,ind)_$lb(InjectFee)_$lb(InjectFeePaid)
	set qHandle = $lb(0,repid,0)
	Q $$$OK
}

//导入治疗单

//w ##class(ABN.dao.DHCNurCureRecChild).ExportAllergyCure(6)

ClassMethod ExportAllergyCure(CureID)
{
	s ^Temp("wanghc","export")=CureID
	;s $zt="ERROR"
	s recObj = ##class(ABN.DHCNurCureRec).%OpenId(CureID)
	s PapmiID = recObj.PapmiID
	s Scheme = recObj.Scheme	;Scheme=R K
	s rtn =##class(web.DHCDocAllergyCure).FindCureIDByPatientID(PapmiID,"Y")	//本次治疗单
	b
	q:rtn="" "0^没有治疗单"
	s len = $l(rtn,"^")
	f i=1:1:len d
	.s allergyCureID=$p(rtn,"^",i)
	.s allergyCureObj = ##class(User.DHCDocAllergyCure).%OpenId(allergyCureID)
	.b
	.q:+allergyCureObj.DACInstrDRGetObjectId()=0
	.q:(Scheme="R")&&('##class(ABN.dao.DHCDocAllergyInterface).isNormalInject(allergyCureObj.DACInstrDRGetObjectId()))
	.q:(Scheme="K")&&('##class(ABN.dao.DHCDocAllergyInterface).isDesensitization(allergyCureObj.DACInstrDRGetObjectId()))
	.b
	.s seqno=0
	.f  s seqno=$o(^DHCDACi("SeqNoCNoIndex",allergyCureID,seqno)) q:seqno=""  d
	..s cno=""
	..f  s cno=$o(^DHCDACi("SeqNoCNoIndex",allergyCureID,seqno,cno)) q:cno=""  d
	...s allergyCureSub=0
	...f  s allergyCureSub=$o(^DHCDACi("SeqNoCNoIndex",allergyCureID,seqno,cno,allergyCureSub)) q:allergyCureSub=""  d
	....s allergyCureSubObj = ##class(User.DHCDocAllergyCureRecord).%OpenId(allergyCureID_"||"_allergyCureSub)
	....s cureRecChildObj = ##class(ABN.DHCNurCureRecChild).%New(CureID)
	....s cureRecChildObj.WeekNo=allergyCureSubObj.DACRSeqNo
	....s cureRecChildObj.CureDate=allergyCureSubObj.DACRDate
	....s cureRecChildObj.BottleNo=allergyCureSubObj.DACRConcentrationNo
	....s cureRecChildObj.Density=allergyCureSubObj.DACRLocalDoseQty
	....d cureRecChildObj.CureRecParefSetObjectId(CureID)
	....s sc=cureRecChildObj.%Save()
	....b ; sc
	....d cureRecChildObj.%Close()
	....s cureRecChildObj=""
	....d allergyCureSubObj.%Close()
	....s allergyCureSubObj=""
	.d allergyCureObj.%Close()
	.s allergyCureObj=""
	d recObj.%Close()
	s recObj=""
	q "0^保存成功"
ERROR
	S ^Temp("wanghc","ABN.dao.DHCNurCureRecChild","ExportAllergyCure")=$ze
	s $ze=""
	q "-1^保存错误!"
}

//##class(ABN.dao.DHCNurCureRecChild).Exec("15||41","",194,"Default",3880)

ClassMethod Exec(CureChildId, SeatNo, ctlocId, queryTypeCode, userId)
{
	s ^Temp("wanghc","child","Exec")=CureChildId_","_SeatNo_","_ctlocId_","_queryTypeCode_","_userId
	s obj =  ##class(ABN.DHCNurCureRecChild).%OpenId(CureChildId)
	s oeoriId = obj.Oeorditem
	d obj.%Close()
	s obj= ""
	q:oeoriId="" "0^医嘱为空"
	d ##class(ABN.dao.DHCDocAllergyInterface).RunExecOrdGroup(oeoriId, SeatNo, ctlocId, queryTypeCode, userId)
	q "0^保存成功"
}

ClassMethod Save(reqJson)
{
	k ^Temp("wanghc","save","ABN.dao.DHCNurCureRecChild")
	s ^Temp("wanghc","save","ABN.dao.DHCNurCureRecChild")=reqJson
	s $zt="ERROR"
	q:reqJson="" "-306^"
	s jsonObj = ##class(ext.util.JsonObject).%New()
	s jsonObj.ContainNullValue=1	//删除属性值时用到
	s jsonObj.DateFormat=4
	d jsonObj.FromObject(reqJson)
	s BottleNo = jsonObj.Get("BottleNo")
	s id = jsonObj.Get("ID")
	if (id'=""){
		s cureChildObj = ##class(ABN.DHCNurCureRecChild).%OpenId(id)
		s oeordItemDr = cureChildObj.Oeorditem
		s cureChildObj=""
		i (oeordItemDr'=""){
			s oeordItemBilled =  $p(^OEORD(+oeordItemDr,"I",$p(oeordItemDr,"||",2),3),"^",5)
			q:oeordItemBilled'="P" "-1^没有交费不能保存!"
		}		
	}	
	
	s oeorditem=""
	s User=%session.Data("LOGON.USERID")
	s Loc=%session.Data("LOGON.CTLOCID")
	if ((BottleNo'="")&&(id="")){	//新加时才插入医嘱
		s PARREF = jsonObj.Get("PARREF")
		s ParrefObj = ##class(ABN.DHCNurCureRec).%OpenId(PARREF)
		s PatientID = ParrefObj.PapmiID		
		s Adm=""			
		s DocUserId=$p(^SSU("SSUSR",User),"^",14)	;wanghc 20130219
		;变态反应科，有效的，登录医生，当天的病人就诊
		&sql(select PAADM_RowId into Adm from sqluser.pa_adm 
		where paadm_papmi_dr=:PatientID 
		and paadm_depcode_dr=:Loc 
		and paadm_admdate=+$h 
		and PAADM_VisitStatus="A"		
		and PAADM_AdmDocCodeDR=:DocUserId)
		if Adm=""{
			s Adm1="" f  s Adm1 = $o(^PAPERdr(PatientID,"ADM","O",Adm1),-1) q:((Adm1="")||(Adm'=""))  d
			.q:(Loc'=$p(^PAADM(Adm1),"^",4))		;本科室的号
			.q:("A"'=$p(^PAADM(Adm1),"^",20))	
			.s AdmDate = $p(^PAADM(Adm1),"^",6)
			.q:(AdmDate>+$h)					;过滤预约的号
			.s Adm = Adm1						;多个就诊号
		}
		s ReceiveDep = %session.Data("LOGON.CTLOCID")
		s OrdItemStr=^DHCDocConfig("CureRecArcimId")_"^1^"_ReceiveDep_"^^^^"_+$h_"^^变态反应科执行治疗"	
		s Epissubtype=$p(^PAADM(Adm,1),"^",6)
		s EpissubtypeDesc=$p(^PAC("SUBT",Epissubtype),"^",2)
		if (EpissubtypeDesc["特需"){	//特需的病人插入一般注射(特需)
			s OrdItemStr="18749||1^1^"_ReceiveDep_"^^^^"_+$h_"^^变态反应科执行治疗"
		}
		s LABDATA="LABDATA"
		
		s InsType=""
		;插入一条 皮内注射 收费医嘱 DocUserId->User wanghc20130219
		S rtn = ##class(ABN.dao.DHCDocAllergyInterface).InsertOrderItem(Adm, OrdItemStr, User, Loc, LABDATA, User, InsType)
		s flag = $p(rtn,"^")
		q:flag'=0 "-307^插入注射医嘱出错"
		s oeorditem = $p($p(rtn,"^",2),"*")
		d jsonObj.Put("Oeorditem",oeorditem)
	}
	s obj = jsonObj.Bean("ABN.DHCNurCureRecChild")	
	d jsonObj.%Close()
	s jsonObj=""
	s sc = obj.%Save()	
	If $$$ISERR(sc) Quit "-306^"_sc		
	s id = obj.%Id() 
	d obj.%Close()
	s obj = ""	
	q 0_"^"_id
ERROR 
	S ^Temp("wanghc","ABN.dao.DHCNurCureRecChild","Save")=$ze
	s $ze=""
	q "-1^后台出错!"
}

ClassMethod Delete(ID)
{
	q:ID="" "-1^id为空"
	s $zt="ERROR"
	d ##class(ABN.DHCNurCureRecChild).%DeleteId(ID)
	q "0^"_ID
ERROR 
	S ^Temp("wanghc","ABN.DHCNurCureRecChild","Delete")=$ze
	s $ze=""
	q "-1^后台出错!"
}

ClassMethod GenYNSelectList(id)
{
	
	if (id="SendDrugFlag"){
		s rtn=	"<select  id='"_id_"' name='"_id_"' size=1>"		
		s rtn=rtn_"<option value='ALL'>全部"
		s rtn=rtn_"<option value='W'>未报到"
		s rtn=rtn_"<option value='P'>已打印正配药"
		s rtn=rtn_"<option value='S'>已发药"
		;s rtn=rtn_"<option value='B'>已退药"
		s rtn=rtn_"</select>"
	}else{
		s rtn=	"<select  id='"_id_"' name='"_id_"' size=1>"
		s rtn=rtn_"<option value='Y'>有"
		s rtn=rtn_"<option value='N'>无"
		s rtn=rtn_"</select>"
	}
	q rtn
}

ClassMethod TestGetAdm(PatientID)
{
	s Loc = 249
	s Adm=""
	s Adm1="" f  s Adm1 = $o(^PAPERdr(PatientID,"ADM","O",Adm1),-1) q:((Adm1="")&&(Adm'=""))  d
	.q:(Loc'=$p(^PAADM(Adm1),"^",4))		;本科室的号
	.s AdmDate = $p(^PAADM(Adm1),"^",6)
	.q:(AdmDate>+$h)					;过滤预约的号
	.s Adm = Adm1						;多个就诊号
	s AdmDate = $zd($p(^PAADM(Adm),"^",6),3)
	q Adm_"-"_AdmDate
}

}
