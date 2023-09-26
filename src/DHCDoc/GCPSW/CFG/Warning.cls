/// CTOR: QP
/// DATE: 2020-11-05
/// DESC: 禁用药设置
Class DHCDoc.GCPSW.CFG.Warning Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-11-05
/// DESC: 保存
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.Warning).Save("903||1")
ClassMethod Save(PID, mList)
{
	s mRtn=0
	s id=$p(mList,"^",1)
	s type=$p(mList,"^",2)
	s item=$p(mList,"^",3)
	s msg=$p(mList,"^",4)
	s user=$p(mList,"^",5)
	s note=$p(mList,"^",6)
	Q:PID="" "-1"
	
	i id="" {
		i item'=""{
			i $d(^CF.DOC.GCPSW.WarningI("WTypeItem",PID,type,item)) {
				Q -2
			}
		}
		s a=##class(User.GCPSWarning).%New()
		d a.WAddUserSetObjectId(user)
		s a.WAddDate=+$H
		s a.WAddTime=$p($h,",",2)
		
		
	} else {
		s a=##class(User.GCPSWarning).%OpenId(id)
	}
	s a.WItem=item
	s a.WMsg=msg
	s a.WNote=note
	s a.WType=type
	d a.WPrjSetObjectId(PID)
	s sc=a.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		s mRtn=-101
	} else {
		s mRtn=a.%Id()
	}
	d a.%Close()
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-11-05
/// DESC: 删除
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.Warning).Delete("")
ClassMethod Delete(WID As %String)
{
	Q:WID="" 0
	&SQL(DELETE FROM SQLUser.GCPSW_Warning WHERE W_ID=:WID)
	Q:SQLCODE'=0 -102
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-11-09
/// DESC: 查询药理项目
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCPSW.CFG.Warning","QryGCP")
Query QryGCP(InDesc = "", UserID = "") As %Query(ROWSPEC = "id,code,desc,createLoc,startUser,status,IsPITeam")
{
}

ClassMethod QryGCPExecute(ByRef qHandle As %Binary, InDesc = "", UserID = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s id=0
 	f  s id=$o(^DHCDocPP(id)) q:id=""  d
 	.s code=$p(^DHCDocPP(id),"^",1)
 	.s desc=$p(^DHCDocPP(id),"^",2)
 	.s status=$p(^DHCDocPP(id),"^",16)
 	.s status=..GetProjectDesc(status)
 	.s createLoc=$p(^DHCDocPP(id),"^",6)
 	.i createLoc'="" s createLoc=$P(^CTLOC(createLoc),"^",2)
 	.i createLoc["-" s createLoc=$p(createLoc,"-",2)
 	.s startUser=$p($g(^DHCDocPP(id)),"^",10)
	.i startUser'="" s startUser=$p(^SSU("SSUSR",startUser),"^",2)
	.s flag=##class(DHCDoc.GCPSW.COM.Func).IsPITeam(UserID,id,1)
 	.q:flag=0
 	.s exit=..IsExit(id,InDesc)
 	.Q:exit=1
 	.d output1
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	Set Data=$lb(id,code,desc,createLoc,startUser,status,flag)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryGCPClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGCPExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryGCPFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGCPExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// CTOR: QP
/// DATE: 2020-11-09
/// DESC: 查询禁用类型
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCPSW.CFG.Warning","QryType")
Query QryType() As %Query(ROWSPEC = "id,desc")
{
}

ClassMethod QryTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	
 	s id="A",desc="医嘱项"
 	d output2
 	//s id="D",desc="药理学大类"
 	//d output2
 	//s id="I",desc="药理学子类"
 	//d output2
 	s id="N",desc="不明确"
 	d output2
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output2
	Set Data=$lb(id,desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// CTOR: QP
/// DATE: 2020-11-09
/// DESC: 查询消息设置
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCPSW.CFG.Warning","QryMsg",35,"")
Query QryMsg(PID = "", InType = "") As %Query(ROWSPEC = "id,type,typeDesc,itemDr,item,msg,note,PID")
{
}

ClassMethod QryMsgExecute(ByRef qHandle As %Binary, PID = "", InType = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	i PID="" {
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
	s ^QP("dhc")=$lb(PID,InType)
 	s id=0
 	f  s id=$o(^CF.DOC.GCPSW.WarningI("WPrj",PID,id)) q:id=""  d
 	.s type=$p(^CF.DOC.GCPSW.WarningD(id),"^",1)
 	.q:(InType'="")&&(type'=InType)
 	.s typeDesc=..GetTypeDsec(type)
 	.s itemDr=$p(^CF.DOC.GCPSW.WarningD(id),"^",3)
 	.s item=..GetItemDsec(type,itemDr)
 	.s msg=$p(^CF.DOC.GCPSW.WarningD(id),"^",4)
 	.s note=$p(^CF.DOC.GCPSW.WarningD(id),"^",5)
 	.d output3
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output3
	Set Data=$lb(id,type,typeDesc,itemDr,item,msg,note,PID)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryMsgClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMsgExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMsgFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMsgExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// CTOR: QP
/// DATE: 2020-11-05
/// DESC: 获取禁用项目描述
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.Warning).Save("903||1")
ClassMethod GetItemDsec(type, itemDr) As %String
{
	s mRtn=""
	q:(type="")||(itemDr="") mRtn
	i type="A" {
		s arc=+itemDr,sub=$p(itemDr,"||",2)
		Q:sub="" mRtn
		s mRtn=$p(^ARCIM(arc,sub,1),"^",2)
	}
	i type="D" {
		 s mRtn=$p(^PHCC(itemDr),"^",2)
		
	}
	i type="I" {
		s phcat=+itemDr,phcatsub=$p(itemDr,"||",2)
		s mRtn=$p(^PHCC(phcat,"SC",phcatsub),"^",2)
		
	}
	i type="N" {
		Q mRtn
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-11-05
/// DESC: 获取药品药学分类
/// IN  : 
/// OUT : 
/// TABL: DHC_PHCCat
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.Warning).GetPHCCat("5225||1")
ClassMethod GetPHCCat(arcim) As %String
{
	s mRtn=""
	s arcimObj=##class(User.ARCItmMast).%OpenId(arcim)
	s geneId=arcimObj.ARCIMGenericDRGetObjectId()	//PHC_Generic
	s dhcGeneData=$g(^PHCGE("GE",+geneId,"DHC"))
	s phcCatId=$p(dhcGeneData,"^",6)
	;s mRtn=$p(##class(PHA.IN.DHCPHCCat.Query).GetPHCCatAll(phcCatId),"^",2)
	s mRtn=$p($g(^DHCPHCC(phcCatId)),"^",2)
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-11-05
/// DESC: 获取禁用类型描述
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.Warning).GetTypeDsec("A")
ClassMethod GetTypeDsec(type) As %String
{
	s mRtn=""
	q:type="" mRtn
	i type="A" {
		s mRtn="医嘱项"
	}
	i type="D" {
		s mRtn="药理学大类"
	}
	i type="I" {
		s mRtn="药理学子类"
	}
	i type="N" {
		s mRtn="不明确"
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-11-05
/// DESC: 是否退出
/// IN  : 
/// OUT : 1退出
/// TABL: 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.Warning).GetTypeDsec("A")
ClassMethod IsExit(PID, InDesc) As %String
{
	Q:(InDesc)="" 0
	s code=$p(^DHCDocPP(PID),"^",1)
 	s desc=$p(^DHCDocPP(PID),"^",2)
 	s status=$p(^DHCDocPP(PID),"^",16)
	s code=$zcvt(code,"U")
	s desc=$zcvt(desc,"U")
	s InDesc=$zcvt(InDesc,"U")
	i (code'[InDesc)&&(desc'[InDesc) {
		Q 1	
	}
	
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-04-27
/// DESC: 查询医嘱项目
/// IN  : 医嘱描述或首拼
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCPSW.CFG.Warning","FindMasterItem","aqms")
Query FindMasterItem(arcimdesc As %String = "", HospId As %String = "", InOrderType = "") As %Query(ROWSPEC = "ArcimDesc:%String,ArcimDR:%String,factor,stock")
{
}

ClassMethod FindMasterItemExecute(ByRef qHandle As %Binary, arcimdesc As %String = "", HospId As %String = "", InOrderType = "") As %Status
{

 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i (arcimdesc="") {
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	 }
    i (arcimdesc'="") s arcimdesc=$$ALPHAUP^SSUTIL4(arcimdesc)    
    //i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
 	s ArcimID=0 
 	f  s ArcimID=$o(^ARCIM(ArcimID)) q:ArcimID=""  d
	.s ArcimSubID=0 f  s ArcimSubID=$o(^ARCIM(ArcimID,ArcimSubID)) q:ArcimSubID=""  d
	..s ArcimDR=ArcimID_"||"_ArcimSubID
	..s ItemCatDR=$p(^ARCIM(ArcimID,1,1),"^",10)
	..s OrderType=$P(^ARC("IC",ItemCatDR),"^",7) 
	..q:(InOrderType'="")&&(InOrderType'=OrderType)
	..;Q:##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItmMast",ArcimDR,HospId)="N"
	..s Flag=0
	..s factor="",stock=""
	..q:$g(^ARCIM(ArcimID,ArcimSubID,1))=""
	..s dateFrom=$p($p(^ARCIM(ArcimID,ArcimSubID,1),"^",13),",",1)
	..s dateTo=$p($g(^ARCIM(ArcimID,ArcimSubID,7)),"^",1)
	..s h=+$h
	..s OrderOnItsOwn = $p($g(^ARCIM(ArcimID,ArcimSubID,7)),"^",13)
	..q:OrderOnItsOwn="N"
	..q:OrderOnItsOwn=""
	..q:(((h<dateFrom)&&(dateFrom'=""))!((h>dateTo)&&(dateTo'="")))
	..s ArcimDesc=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",2)
	..s OutArcimDesc=ArcimDesc
	..s ArcimDesc=$$ALPHAUP^SSUTIL4(ArcimDesc)   
	..i ArcimDesc[arcimdesc s Flag=1
	..i Flag=0  d
	...s AlisDR=""
	...f  s AlisDR=$O(^ARC("ALIAS",0,"ARCIM",ArcimDR,AlisDR)) q:AlisDR=""  d
	....s AlisDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",AlisDR),"^",6))
	....i AlisDesc[arcimdesc s Flag=1
	..i Flag=1 d
	...Do OutputRow5
	..//s AlisDR=$O(^ARC("ALIAS",0,"ARCIM",ArcimDR,""))
	..//q:AlisDR=""
	..//s AlisDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",AlisDR),"^",6))
	..//s ArcimDesc=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",2)
	..//s ArcimDesc=AlisDesc_"-"_ArcimDesc
	..//q:ArcimDesc'[arcimdesc
	..//Do OutputRow5
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb(OutArcimDesc,ArcimDR,factor,stock)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMasterItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMasterItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindMasterItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMasterItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2020-01-07
/// DESC: 根据代码获取项目状态描述
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.Warning).GetProjectDesc("N")
ClassMethod GetProjectDesc(ProCode As %String)
{
	s mRtn=""
	i ProCode="N" s mRtn="立项"
	i ProCode="H" s mRtn="未进行"
	i ProCode="V" s mRtn="在研"
	i ProCode="P" s mRtn="发补后在研"
	i ProCode="F" s mRtn="已完成"
	i ProCode="A" s mRtn="暂停"
	i ProCode="S" s mRtn="终止"
	i ProCode="B" s mRtn="中止"
	i ProCode="I" s mRtn="审批中"
	i ProCode="U" s mRtn="未批准"
	i ProCode="D" s mRtn="上会未通过"
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-11-09
/// DESC: 是否为临床药理禁用药，开医嘱时提示
/// IN  : 
/// OUT : 1:是，0：否
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.Warning).IsGCPBanDrug("")
ClassMethod IsGCPBanDrug(PID = "", Arcim = "")
{
	Q:(PID="")||(Arcim="") 0
	;判断医嘱项
	i $d(^CF.DOC.GCPSW.WarningI("WItem",PID,Arcim)) {
		Q 1	
	}
	;判断药学分类
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-11-10
/// DESC: 获取临床药理禁用药信息，返回空不需要提示。
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.Warning).GetGCPBanDrugMsg("17","930||1","")
ClassMethod GetGCPBanDrugMsg(PID = "", Arcim = "", Type = "", EpisodeID = "", PatientID = "")
{
	s mRtn=""
	s ^QP("GetGCPBanDrugMsg")=$LB(PID,Arcim,Type,EpisodeID)
	s langid=..%LanguageID()
	i PID="" {
		i PatientID="" {
			s PatientID=$p(^PAADM(EpisodeID),"^",1)
		}
		i PID="" {
			S PID=..GetPID(PatientID)
		}
	}
	Q:(PID="") mRtn
	s MG1=##class(websys.Translation).Get("oeorder.oplistcustom.new.csp","患者正在参加临床试验，禁忌合并使用")
	s MG2=##class(websys.Translation).Get("oeorder.oplistcustom.new.csp","，建议不要使用。如确为临床需要，请联系")
	s MG3=##class(websys.Translation).Get("oeorder.oplistcustom.new.csp","，电话：")
	
	i Type="N" {
		//审核医嘱时，调用
		s id=""
		f  s id=$o(^CF.DOC.GCPSW.WarningI("WType",PID,Type,id)) q:id=""  d
		.s msg=$p(^CF.DOC.GCPSW.WarningD(id),"^",4)
		.q:msg=""
		.s msg= ##class(User.GCPSWarning).GetTranByDesc("WMsg",msg,langid)
		.i mRtn="" s mRtn=msg
		.e  s mRtn=mRtn_"，"_msg
		
		i mRtn'="" {
			s contactAndTel=..GetContactAdnTel(PID)
			s contactDoc=$p(contactAndTel,"^",1)
			s contactDoc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",contactDoc,langid)
			s tel=$p(contactAndTel,"^",2)
			;s mRtn = "[患者正在参加临床试验，禁忌合并使用"_mRtn_"，建议不要使用。如确为临床需要，请联系"_contactDoc_"，电话："_tel_"]"
			s mRtn = "["_MG1_mRtn_MG2_contactDoc_MG3_tel_"]"
		}
		
		
	} 
	i Type="" {
		//开医嘱时调用
		Q:Arcim="" mRtn
		
		s arc=+Arcim,sub=$p(Arcim,"||",2)
		s drugName=$p(^ARCIM(arc,sub,1),"^",2)
		s drugName= ##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",drugName,langid)
		s contactAndTel=..GetContactAdnTel(PID)
		s contactDoc=$p(contactAndTel,"^",1)
		s contactDoc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",contactDoc,langid)
		s tel=$p(contactAndTel,"^",2)
		
		s defaultMsg = "["_MG1_drugName_MG2_contactDoc_MG3_tel_"]"
		//判断医嘱项
		i $d(^CF.DOC.GCPSW.WarningI("WItem",PID,Arcim)) {
			s id=$o(^CF.DOC.GCPSW.WarningI("WItem",PID,Arcim,""))
			q:id="" mRtn
			s msg=$p(^CF.DOC.GCPSW.WarningD(id),"^",4)
			//i msg="" s msg=defaultMsg
			i msg'="" s msg=defaultMsg_"，"_##class(User.GCPSWarning).GetTranByDesc("WMsg",msg,langid)
			e  s msg=defaultMsg
			s mRtn=msg
		} else {
			//判断药学分类
			
			/*
			s phcatStr=##class(DHCDoc.GCPSW.COM.Func).GetPhcatByarc(Arcim)
			q:phcatStr="" mRtn
			s phcat=$p(phcatStr,"^",1)
			s phcsubcat=$p(phcatStr,"^",4)
			s id=""
			i $d(^CF.DOC.GCPSW.WarningI("WItem",PID,phcsubcat)) {
				s id=$o(^CF.DOC.GCPSW.WarningI("WItem",PID,phcsubcat,""))
				
			} else {
				i $d(^CF.DOC.GCPSW.WarningI("WItem",PID,phcat)) {
					s id=$o(^CF.DOC.GCPSW.WarningI("WItem",PID,phcat,""))
				}
			}
			q:id="" mRtn
			s msg=$p(^CF.DOC.GCPSW.WarningD(id),"^",4)
			i msg'="" s msg=defaultMsg_"，"_msg
			e  s msg=defaultMsg
			s mRtn=msg
			*/
		}
		
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-11-10
/// DESC: 获取临床药理禁用药信息，返回空不需要提示。
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.Warning).GetContactAdnTel("971")
ClassMethod GetContactAdnTel(PID = "")
{
	s mRtn=""
	Q:PID="" mRtn
	s id=""
	f  s id=$o(^DHCDocPPC(PID,id)) q:(id="")||(mRtn'="")  d
	.s isContact=$p(^DHCDocPPC(PID,id),"^",10)
	.q:isContact'="Y"
	.s Tel=$p(^DHCDocPPC(PID,id),"^",11)
	.S userid=$p(^DHCDocPPC(PID,id),"^",1)
	.i Tel="" s Tel=$p(^SSU("SSUSR",userid),"^",99)
	.s userName=$p(^SSU("SSUSR",userid),"^",2)
	.S mRtn=userName_"^"_Tel
	
	;如果指定联系人没有维护，则取PI
	i mRtn="" {
		s startUser=$p($g(^DHCDocPP(PID)),"^",10)
		S Tel=$p(^SSU("SSUSR",startUser),"^",99)
		s startUser=$p(^SSU("SSUSR",startUser),"^",2)
		s mRtn=startUser_"^"_Tel
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-11-24
/// DESC: 获取科研项目ID
/// IN  : 5153395，27256509
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.Warning).GetPID("5153395")
ClassMethod GetPID(PatientID = "", EpisodeID = "")
{
	s mRtn=""
	Q:PatientID="" mRtn
	s PID=""
	f  s PID=$O(^DHCDocPPP("PapmiDr",0,PatientID,PID)) Q:(PID="")||(mRtn'="")  d
	.s id=""
	.f  s id=$o(^DHCDocPPP("PapmiDr",0,PatientID,PID,id)) q:(id="")||(mRtn'="")  d
	..s status=$p(^DHCDocPPP(PID,id),"^",2)
	..q:status'="N"
	..s mRtn=PID
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-12-16
/// DESC: 获取预览信息
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.Warning).GetPID("5153395")
ClassMethod GetViewInfo(PID = "", WID = "")
{
	s ^QP("GetViewInfo")=PID_": "_WID
	s mRtn=""
	Q:(WID="") mRtn
	i PID="" s PID=$p(^CF.DOC.GCPSW.WarningD(WID),"^",2)
	s type=$p(^CF.DOC.GCPSW.WarningD(WID),"^",1)
 	s typeDesc=..GetTypeDsec(type)
 	s itemDr=$p(^CF.DOC.GCPSW.WarningD(WID),"^",3)
 	s item=..GetItemDsec(type,itemDr)
 	s msg=$p(^CF.DOC.GCPSW.WarningD(WID),"^",4)
 	
 	s contactAndTel=..GetContactAdnTel(PID)
	s contactDoc=$p(contactAndTel,"^",1)
	s tel=$p(contactAndTel,"^",2)
		
	i type="N" {
		
		s mRtn = "[患者正在参加临床试验，禁忌合并使用"_msg_"，建议不要使用。如确为临床需要，请联系"_contactDoc_"，电话："_tel_"]"
		
	} elseif type="A" {
		s arc=+itemDr,sub=$p(itemDr,"||",2)
		s drugName=$p(^ARCIM(arc,sub,1),"^",2)
		s mRtn = "[患者正在参加临床试验，禁忌合并使用"_drugName_"，建议不要使用。如确为临床需要，请联系"_contactDoc_"，电话："_tel_"]"
		i msg'="" s mRtn=mRtn_"，"_msg
	} else {
		s drugName="xx"
		s mRtn = "[患者正在参加临床试验，禁忌合并使用"_drugName_"，建议不要使用。如确为临床需要，请联系"_contactDoc_"，电话："_tel_"]"
		i msg'="" s mRtn=mRtn_"，"_msg
	}
	Q mRtn
}

}
