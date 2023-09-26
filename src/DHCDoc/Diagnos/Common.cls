Class DHCDoc.Diagnos.Common Extends DHCDoc.Util.RegisteredObject
{

/// w ##class(DHCDoc.Diagnos.Common).GetHistoryDiag(1)
ClassMethod GetHistoryDiag(PatientID, LocID = "", LocRange = "", HospID = "")
{
	s:(LocID="")&&$D(%session) LocID=%session.Get("LOGON.CTLOCID")
	Set langid=..%LanguageID()
	s:HospID="" HospID=$P($G(^CTLOC(+LocID)),"^",22)
	for AdmType="O","E","I"{
		s AdmID=0 for{
			s AdmID=$O(^PAPERdr(PatientID,"ADM",AdmType,AdmID)) Q:AdmID=""
			s MRAdmID=$P(^PAADM(AdmID),"^",61)
			continue:MRAdmID=""
			s AdmLocID=$P(^PAADM(AdmID),"^",4)
			if (LocRange'="")&&(LocRange'="AllLoc"){
				continue:(LocRange="CurLoc")&&(AdmLocID'=LocID)
				continue:(LocRange="OtherLoc")&&(AdmLocID=LocID)
			}
			s AdmHospID=$P(^CTLOC(AdmLocID),"^",22)
			continue:(HospID'="")&&(AdmHospID'=HospID)
			s AdmDate=$P(^PAADM(AdmID),"^",6)
			s AdmTime=$P(^PAADM(AdmID),"^",7)
			s DiagSub=0 for{
				s DiagSub=$O(^MR(MRAdmID,"DIA",DiagSub)) Q:DiagSub=""
				s ICDRowid=$P(^MR(MRAdmID,"DIA",DiagSub),"^",1)
				s Note=$G(^MR(MRAdmID,"DIA",DiagSub,"DES",1))
				continue:(ICDRowid="")&&(Note="")
				s AddDate=$P(^MR(MRAdmID,"DIA",DiagSub),"^",42)
				s:AddDate="" AddDate=AdmDate
				s AddTime=$P(^MR(MRAdmID,"DIA",DiagSub),"^",41)
				s:AddTime="" AddTime=AdmTime
				s DiagRowid=MRAdmID_"||"_DiagSub
				s DiagObj=$CASE(ICDRowid,"":$G(DiagList("NOTE",Note),{}),:$G(DiagList("ICD",ICDRowid),{}))
				if (AddDate>DiagObj.AddDate)||((AddDate=DiagObj.AddDate)&&(AdmTime>DiagObj.AddTime)){
					s DiagObj.AddDate=AddDate
					s DiagObj.AddTime=AddTime
					s DiagObj.DiagRowid=DiagRowid
					if DiagObj.DiagRowids=""{
						s DiagObj.DiagRowids=[(DiagRowid)]
					}else{
						d DiagObj.DiagRowids.%Push(DiagRowid)
					}
				}else{
					d DiagObj.DiagRowids.%Push(DiagRowid)
				}
				if ICDRowid'=""{
					s DiagList("ICD",ICDRowid)=DiagObj
				}else{
					s DiagList("NOTE",Note)=DiagObj
				}
				
			}
		}
	}
	for Node1="ICD","NOTE"{
		s Node2="" for{
			s Node2=$O(DiagList(Node1,Node2)) Q:Node2=""
			s DiagObj=DiagList(Node1,Node2)
			s AddDate=DiagObj.AddDate,DiagRowid=DiagObj.DiagRowid
			s AdmID=$P(^MR(+DiagRowid,"PRO",1),"^",9)
			s AdmLocID=$P(^PAADM(AdmID),"^",4)
			s OutList(AddDate,AdmLocID,DiagRowid)=DiagObj.DiagRowids
		}
	}
	s rows=[]
	s AddDate="" for{
		s AddDate=$O(OutList(AddDate),-1) Q:AddDate=""
		s Date=##class(websys.Conversions).DateLogicalToHtml(AddDate)
		s DateObj={"Date":(Date),"LocList":[]}
		s AdmLocID=0 for{
			s AdmLocID=$O(OutList(AddDate,AdmLocID)) Q:AdmLocID=""
			s AdmLoc=$P(^CTLOC(AdmLocID),"^",2)
			s AdmLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",AdmLoc,langid)
			s LocObj={"Loc":(AdmLoc),"Diagnos":[]}
			s DiagRowid="" for{
				s DiagRowid=$O(OutList(AddDate,AdmLocID,DiagRowid)) Q:DiagRowid=""
				s DiagRowids=OutList(AddDate,AdmLocID,DiagRowid)
				s MRAdmID=+DiagRowid,DiagSub=$P(DiagRowid,"||",2)
				s AdmID=$p($G(^MR(MRAdmID,"PRO",1)),"^",9)
				s ADMNo=$p(^PAADM(AdmID),"^",81)
				s AddDocID=$P(^MR(MRAdmID,"DIA",DiagSub),"^",4)
				s AddDoc=$P($G(^CTPCP(+AddDocID,1)),"^",2)
				Set AddDoc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",AddDoc,langid)
				s ICDRowid=$P(^MR(MRAdmID,"DIA",DiagSub),"^",1)
				s ICDCode="",ICDDesc=""
				if ICDRowid'=""{
					s ICDCode=$P($G(^MRC("ID",ICDRowid)),"^",1)
					s ICDDesc=$P($G(^MRC("ID",ICDRowid)),"^",2)
					s ICDDesc =##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc",ICDDesc,langid)
				}
				s Note=$G(^MR(MRAdmID,"DIA",DiagSub,"DES",1))
				s text=ICDDesc
				i text="" s text=Note
				e  i Note'="" s text=text_"("_Note_")"
				s DiagStatDr=$p(^MR(MRAdmID,"DIA",DiagSub),"^",9)
				s DiagStat=$p($g(^MRC("DSTAT",+DiagStatDr)),"^",2)
				s DiagStat =##class(User.MRCDiagnosStatus).GetTranByDesc("DSTATDesc",DiagStat,langid)
				s TCMTreatmentID=$P($G(^MR(MRAdmID,"DIA",DiagSub,1)),"^",29)
				s TCMTreatment=$P($G(^MRC("TCMT",+TCMTreatmentID)),"^",2)
				s TCMTreatment=##class(User.MRCTCMTreatment).GetTranByDesc("TCMTDesc",TCMTreatment,langid)
				s:TCMTreatment'="" text=text_"["_TCMTreatment_"]"
				s LongDiagnosFlagRowId=$P($G(^MR(MRAdmID,"DIA",DiagSub,1)),"^",23)
				;结构化诊断信息返回
			    s SDSInfo=##class(web.DHCBL.MKB.SDSDiagnosFuseInterface).GetStructDiagnos(ADMNo,DiagRowid)
			    if SDSInfo'=""{
				    s SDSRowId=$P(SDSInfo,"^",1)
				    s SDSTermDR=$P(SDSInfo,"^",2)
				    s SDSDisplayIDStr=$P(SDSInfo,"^",3)
				    s SDSDisplayName=$P(SDSInfo,"^",4)
				    s SDSWordID=$P(SDSInfo,"^",8)
				    s Supplement=$P(SDSInfo,"^",9)
				    s:SDSDisplayName'="" text=SDSDisplayName
				    i Note'="" s text=text_"("_Note_")"
				    s SDSInfo=SDSRowId_"^"_SDSTermDR_"^"_SDSDisplayIDStr_"^"_SDSWordID_"^"_Supplement
			    }
				s PrefixDesc=$p($G(^MR(MRAdmID,"DIA",DiagSub,1)),"^",26)
				s:PrefixDesc'="" text="("_PrefixDesc_")"_text
				s obj={}
				s obj.text=text
				s obj.ICDRowid=ICDRowid
				s obj.ICDCode=ICDCode
				s obj.ICDDesc=ICDDesc
				s obj.Note=Note
				s obj.PrefixDesc=PrefixDesc
				s obj.DiagRowid=DiagRowid
				s obj.DiagRowids=DiagRowids
				s obj.DiagStat=DiagStat
				s obj.DiagType=..GetDiagnosCat(DiagRowid)
				s obj.AddDoc=AddDoc
				s obj.SDSInfo=SDSInfo
				s obj.TCMTreatmentID=TCMTreatmentID
				s obj.TCMTreatment=TCMTreatment
				s obj.LongDiagnosFlagRowId=LongDiagnosFlagRowId
				d LocObj.Diagnos.%Push(obj)
			}
			d DateObj.LocList.%Push(LocObj)
		}
		d rows.%Push(DateObj)
	}
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d rows.%ToJSON(.Stream)
	d Stream.OutputToDevice()
	Q ""
}

/// 获取ICD诊断分类ID：西医、中医、证型
ClassMethod GetICDCatID(ICDRowid)
{
	Q:ICDRowid="" ""
	s BillFlag1=$P($G(^MRC("ID",ICDRowid)),"^",13)
	s BillFlag3=$P($G(^MRC("ID",ICDRowid)),"^",15)
	s DiagCatID=$SELECT(BillFlag3'="Y":1,(BillFlag3="Y")&&(BillFlag1'="Y"):2,1:3)
	Q DiagCatID
}

ClassMethod GetDiagnosCatID(DiagRowid)
{
	s DiagCatID=""
	s ICDRowid=$P(^MR(+DiagRowid,"DIA",$P(DiagRowid,"||",2)),"^",1)
	if ICDRowid'=""{
		s DiagCatID=..GetICDCatID(ICDRowid)
	}else{
		s DiagCatID=$P($G(^MR(+DiagRowid,"DIA",$P(DiagRowid,"||",2))),"^",22)
		s:DiagCatID="" DiagCatID=1
	}
	Q DiagCatID
}

ClassMethod GetDiagCatByID(DiagnosCatID, TransFlag As %String = "")
{
	s:TransFlag="" TransFlag="Y"
	s DiagnosCat=$CASE(DiagnosCatID,2:"中医",3:"证型",:"西医")
	if TransFlag="Y"{
		s DiagnosCat=..%Translate("diagnosentry.v8.csp",DiagnosCat)
	}
	Q DiagnosCat
}

ClassMethod GetDiagnosCat(DiagRowid As %String, TransFlag As %String = "")
{
	s DiagnosCatID=..GetDiagnosCatID(DiagRowid)
	Q ..GetDiagCatByID(DiagnosCatID,TransFlag)
}

ClassMethod GetEditLog(DiagRowids, ReturnType = "")
{
	Set langid=..%LanguageID()
	i DiagRowids'["[" s DiagRowids=[(DiagRowids)]
	e  s DiagRowids=[].%FromJSON(DiagRowids)
	s ClassName="User.MRDiagnos"
	for i=1:1:DiagRowids.%Size(){
		s DiagRowid=DiagRowids.%Get(i-1)
		s ObjectReference=" "_$ZCVT(ClassName,"U")_"_"_DiagRowid
		s ID=0 for{
			s ID=$O(^User.DHCDocDataChangeLogI("ObjectReferenceIndex",ObjectReference,ID)) Q:ID=""
			s Data=^User.DHCDocDataChangeLogD(ID)
			s NewValue=$LG(Data,10)
			s:NewValue="" NewValue="[{}]"
			s NewObj=[].%FromJSON(NewValue).%Get(0)
			s OldValue=$LG(Data,14)
			s:OldValue="" OldValue="[{}]"
			s OldObj=[].%FromJSON(OldValue).%Get(0)
			s Changes=[]
			s iter = NewObj.%GetIterator()
			while iter.%GetNext(.key,.newValue) {
				s oldValue=OldObj.%Get(key)
				if newValue'=oldValue{
					s NewPropertyInfo=##class(web.DHCDocDataChangeLog).GetPropDescByCode(ClassName,key,newValue)
					s OldPropertyInfo=##class(web.DHCDocDataChangeLog).GetPropDescByCode(ClassName,key,oldValue)
					s Property=$p(NewPropertyInfo,"^",1)
					s NewPropertyValue=$p(NewPropertyInfo,"^",2,$l(NewPropertyInfo,"^"))
					s OldPropertyValue=$p(OldPropertyInfo,"^",2,$l(NewPropertyInfo,"^"))
					if (Property="长效诊断"){
						s NewPropertyValue=$CASE(NewPropertyValue,"L":"本科","H":"全科",:"")
						s OldPropertyValue=$CASE(OldPropertyValue,"L":"本科","H":"全科",:"")
					}
					if (key="MRDIA_ICDCode_DR"){
						s NewPropertyValue =##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc",NewPropertyValue,langid)
						s OldPropertyValue =##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc",OldPropertyValue,langid)
					}
					if (key="MRDIA_DiagStat_DR"){
						s NewPropertyValue =##class(User.MRCDiagnosStatus).GetTranByDesc("DSTATDesc",NewPropertyValue,langid)
						s OldPropertyValue =##class(User.MRCDiagnosStatus).GetTranByDesc("DSTATDesc",OldPropertyValue,langid)
					}
					if (key="MRDIA_TCMTreat_DR"){
						s NewPropertyValue =##class(User.MRCTCMTreatment).GetTranByDesc("TCMTDesc",NewPropertyValue,langid)
						s OldPropertyValue =##class(User.MRCTCMTreatment).GetTranByDesc("TCMTDesc",OldPropertyValue,langid)
					}
					s NewPropertyValue=..%Translate("diagnosentry.v8.csp",NewPropertyValue)
					s OldPropertyValue=..%Translate("diagnosentry.v8.csp",OldPropertyValue)
					s Property=..%Translate("diagnosentry.v8.csp",Property)
					d Changes.%Push({"Property":(Property),"OldValue":(OldPropertyValue),"NewValue":(NewPropertyValue)})
				}
			}
			continue:'Changes.%Size()
			s UserID=$LG(Data,5)
			s User=$P($G(^SSU("SSUSR",+UserID)),"^",2)
			s Date=$LG(Data,7)
			s Time=$LG(Data,8)
			s OperateType=$LG(Data,9)
			d SetLogList
		}
		;获取结构化诊断日志
		s AdmID=$p($G(^MR(+DiagRowid,"PRO",1)),"^",9)
		s ADMNo=$p(^PAADM(AdmID),"^",81)
		s SDSRowId=$P(##class(web.DHCBL.MKB.SDSDiagnosFuseInterface).GetStructDiagnos(ADMNo,DiagRowid),"^",1)
		if SDSRowId'=""{
			s SDSLogStr=##class(web.DHCBL.MKB.SDSDiagnosLog).GetLog(SDSRowId,"")
			s Len=$L(SDSLogStr,"*")
			f j=1:1:Len{
				s OneSDSLogStr=$P(SDSLogStr,"*",j)
				s Logs=$P(OneSDSLogStr,"^",4)
				continue:Logs=""
				s Changes=[]
				s len2=$L(Logs,"&%")
				f k=1:1:len2{
					s OneLog=$P(Logs,"&%",k)
					continue:OneLog=""
					s Property=$P(OneLog,":",1)
					s Values=$P(OneLog,":",2)
					s OldPropertyValue=$P(Values,"->",1)
					s NewPropertyValue=$P(Values,"->",2)
					continue:NewPropertyValue=OldPropertyValue
					s NewPropertyValue=..%Translate("diagnosentry.v8.csp",NewPropertyValue)
					s OldPropertyValue=..%Translate("diagnosentry.v8.csp",OldPropertyValue)
					s Property=..%Translate("diagnosentry.v8.csp",Property)
					d Changes.%Push({"Property":(Property),"OldValue":(OldPropertyValue),"NewValue":(NewPropertyValue)})
				}
				continue:'Changes.%Size()
				s User=$P(OneSDSLogStr,"^",1)
				s Date=..%ZDH($P(OneSDSLogStr,"^",2))
				s Time=..%ZTH($P(OneSDSLogStr,"^",3))
				s OperateType=$P(OneSDSLogStr,"^",5)
				d SetLogList
			}
		}
	}
	s rows=[]
	s Date="" for{
		s Date=$O(LogList(Date)) Q:Date=""
		s Time="" for{
			s Time=$O(LogList(Date,Time)) Q:Time=""
			s ID=0 for{
				s ID=$O(LogList(Date,Time,ID)) Q:ID=""
				d rows.%Push(LogList(Date,Time,ID))
			}
		}
	}
	Q:$ZCVT(ReturnType,"U")="OBJ" rows
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d rows.%ToJSON(.Stream)
	d Stream.OutputToDevice()
	Q ""
SetLogList
	s User =##class(User.SSUser).GetTranByDesc("SSUSRName",User,langid)
	if '$D(LogList(Date,Time,User)){
		s OperateType=$CASE(OperateType,"A":"增加","U":"修改","D":"删除","R":"读取",:OperateType) 
		s OperateType=..%Translate("diagnosentry.v8.csp",OperateType)
		s LogList(Date,Time,User)={"Date":(..%ZD(Date)),"Time":(..%ZT(Time)),"User":(User),"OperateType":(OperateType),"Changes":(Changes)}
	}else{
		for ChangeIndex=1:1:Changes.%Size(){
			d LogList(Date,Time,User).Changes.%Push(Changes.%Get(ChangeIndex-1))
		}
	}
	Q
}

/// 获取单个诊断的描述  
/// Input:NotLinkChildDiag为Y不拼接证型
ClassMethod GetDiagDesc(DiagRowid, NotLinkChildDiag = "", langid = "")
{
	s MRADMID=+DiagRowid,DiagSub=$P(DiagRowid,"||",2)
	if langid="" Set langid=..%LanguageID()
	Q:DiagSub="" ""
	Q:$G(^MR(MRADMID,"DIA",DiagSub))="" ""
	s EpisodeID=$p($G(^MR(MRADMID,"PRO",1)),"^",9)
	s ADMNo=$p(^PAADM(EpisodeID),"^",81)
	s SDSInfo=##class(web.DHCBL.MKB.SDSDiagnosFuseInterface).GetStructDiagnos(ADMNo,DiagRowid)
	s SDSDesc=$P(SDSInfo,"^",4)
	s ICDRowid=$P(^MR(MRADMID,"DIA",DiagSub),"^",1)
	s ICDDesc=$P($G(^MRC("ID",+ICDRowid)),"^",2)
	s ICDDesc =##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc",ICDDesc,langid)
	s DESSub=$G(^MR(MRADMID,"DIA",DiagSub,"DES",0))
	s Note=$CASE(+DESSub,0:"",:$G(^MR(MRADMID,"DIA",DiagSub,"DES",DESSub)))
	s Prefix=$P($G(^MR(MRADMID,"DIA",DiagSub,1)),"^",26)
	;优先显示结构化诊断
	s Desc=SDSDesc
	s:Desc="" Desc=ICDDesc
	s:Note'="" Desc=$CASE(Desc,"":Note,:Desc_"("_Note_")")
	s:Prefix'="" Desc="("_Prefix_")"_Desc
	s TCMTreatmentID=$P($G(^MR(MRADMID,"DIA",DiagSub,1)),"^",29)
	s TCMTreatment=$P($G(^MRC("TCMT",+TCMTreatmentID)),"^",2)
	s TCMTreatment=##class(User.MRCTCMTreatment).GetTranByDesc("TCMTDesc",TCMTreatment,langid)
	s:TCMTreatment'="" Desc=Desc_"["_TCMTreatment_"]"
	if NotLinkChildDiag'="Y"{
		;拼接子诊断(证型)
		s ChildSub=0 for{
			s ChildSub=$O(^MR(MRADMID,"DIA",0,"Link",DiagRowid,ChildSub)) Q:ChildSub=""
			s ChildDesc=..GetDiagDesc(MRADMID_"||"_ChildSub)
			s:ChildDesc'="" Desc=Desc_"("_ChildDesc_")"
		}
	}
	Q Desc
}

/// 获取患者就诊的诊断
/// 入参: DiagTypeCode:诊断类型代码,不为空只查询指定类型的诊断;  MainFlag:Y只查询主诊断; OnlyICD为Y只查ICD诊断; DisplayNum为Y显示序号; Separator每个诊断直接的分割符(默认为分号)
/// w ##class(DHCDoc.Diagnos.Common).GetAdmDiagDesc(EpisodeID[,DiagTypeCode,MainFlag,OnlyICD,DisplayNum,Separator])
ClassMethod GetAdmDiagDesc(EpisodeID, DiagTypeCode = "", MainFlag = "", OnlyICD = "", DisplayNum = "", Separator = "", langid = "")
{
	s DiagStr=""
	Q:EpisodeID="" DiagStr
	s:Separator="" Separator=";"
	if langid="" Set langid=..%LanguageID()
	s DiagTypeID=$CASE(DiagTypeCode,"":"",:$O(^MRC("DTYP",0,"Code",DiagTypeCode,0)))
	s mradm=$P(^PAADM(EpisodeID),"^",61)
	s sub=0 for{
		s sub=$O(^MR(mradm,"DIA",sub)) Q:sub=""
		if (OnlyICD="Y"){
			s ICDRowid=$P($G(^MR(mradm,"DIA",sub)),"^",1)
			continue:ICDRowid=""
		}
		s DiagDr=$P($G(^MR(mradm,"DIA",sub)),"^",15)
		continue:DiagDr'=""
		if (MainFlag="Y"){
			s MainDiagFlag=$p($g(^MR(mradm,"DIA",sub,1)),"^",20)
			continue:MainDiagFlag'="Y"
		}
		if DiagTypeID'=""{
			S DiagTypeSub=$G(^MR(mradm,"DIA",sub,"TYP",0))
			s MRDiagTypeID=$CASE(DiagTypeSub,"":"",:$G(^MR(mradm,"DIA",sub,"TYP",DiagTypeSub)))
			continue:MRDiagTypeID'=DiagTypeID
		}
		s Sequence=$P($G(^MR(mradm,"DIA",sub,"EPR")),"^",2)
		s:Sequence="" Sequence=99999
		s DiagList(Sequence,sub)=""
	}
	s Sequence="" for{
		s Sequence=$O(DiagList(Sequence)) Q:Sequence=""
		s sub=0 for{
			s sub=$O(DiagList(Sequence,sub)) Q:sub=""
			s Desc=..GetDiagDesc(mradm_"||"_sub)
			s:DisplayNum="Y" Desc=$I(DiagSeq)_"."_Desc
			i DiagStr="" s DiagStr=Desc
			e  s DiagStr=DiagStr_Separator_Desc
		}
	}
	Q DiagStr
}

Query QueryCMTreatment(desc, SessionStr = "") As %Query(ROWSPEC = "TCMTRowId,TCMTCode,TCMTDesc")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.Diagnos.Common","QueryCMTreatment","cs")
ClassMethod QueryCMTreatmentExecute(ByRef qHandle As %Binary, desc, SessionStr = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s:SessionStr="" SessionStr=..%SessionStr()
	s HospID=$P(SessionStr,"^",4)
	s langid=$P(SessionStr,"^",6)
	s desc=$$ALPHAUP^SSUTIL4(desc)
	s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("MRC_TCMTreatment",HospID)
	s CurDate=..%SysDate()
	s TCMTRowId=0 for{
		s TCMTRowId=$o(^MRC("TCMT",TCMTRowId)) q:TCMTRowId=""
		s Data=$G(^MRC("TCMT",TCMTRowId))
		s TCMTValid=$p($g(Data),"^",5) //临床可用标识
		continue:TCMTValid'="Y"
		s TCMTDateFrom=$p($g(Data),"^",6) //开始日期
		continue:(TCMTDateFrom="")||(CurDate<TCMTDateFrom)
		s TCMTDateTo=$p($g(Data),"^",7)  //结束日期
		continue:(TCMTDateTo'="")&&(CurDate>=TCMTDateFrom)
		s TCMTAlias=$p($g(Data),"^",8)  //检索码
		s TCMTCode=$p($g(Data),"^",1)   //中医治法代码
		s TCMTDesc=$p($g(Data),"^",2)   //中医治法名称
		s TCMTDesc=##class(User.MRCTCMTreatment).GetTranByDesc("TCMTDesc",TCMTDesc,langid)
		s ContainPos=$FIND($ZCVT(TCMTAlias,"U"),desc)
		s:'ContainPos ContainPos=$FIND($ZCVT(TCMTDesc,"U"),desc)
		continue:'ContainPos
		s OutList(ContainPos,$L(TCMTDesc),TCMTRowId)=$LB(TCMTRowId,TCMTCode,TCMTDesc)
	}
	s ContainPos=0 for{
		s ContainPos=$O(OutList(ContainPos)) Q:ContainPos=""
		s Len=0 for{
			s Len=$O(OutList(ContainPos,Len)) Q:Len=""
			s TCMTRowId=0 for{
				s TCMTRowId=$O(OutList(ContainPos,Len,TCMTRowId)) Q:TCMTRowId=""
				d rows.%Push(OutList(ContainPos,Len,TCMTRowId)) 
			}
		}
	}
	Q $$$OK
}

ClassMethod QueryCMTreatmentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCMTreatmentExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QueryICD(desc, ICDType, EpisodeID = "", SessionStr = "", rows = "", page = "") As %Query(ROWSPEC = "ICDDesc:%String:诊断名称,Rowid,ICDCode:%String:诊断编码,DiagInsuCode:%String:国家医保诊断编码,DiagInsuName:%String:国家医保诊断名称")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.Diagnos.Common","QueryICD","fr","0","8446","17473^28^92^2^^20^102822^^yr68LGomWr")
ClassMethod QueryICDExecute(ByRef qHandle As %Binary, desc, ICDType, EpisodeID = "", SessionStr = "", rows = "", page = "") As %Status
{
	s dataList=[]
	s qHandle=dataList.%GetIterator()
	s:SessionStr="" SessionStr=..%SessionStr()
	s ^Wqy("QueryICD")=$LB(desc, ICDType, EpisodeID, SessionStr)
	s UserID=$P(SessionStr,"^",1)
	s LocID=$P(SessionStr,"^",2)
	s HospID=$P(SessionStr,"^",4)
	s langid=$P(SessionStr,"^",6)
	s DiagOrderByUserFreq=+..%GetConfig("DiagOrderByUserFreq",HospID)
	s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("MRC_ICDDx",HospID)
	;获取表是公有G ，私有S，管控C，绝对私有A标识
	s ICDDxDataType=##class(DHCDoc.Common.Hospital).GetDataType("MRC_ICDDx")
	s AccurateMode=0
	s len=$L(desc)
	if $E(desc,len)="#"{
		s AccurateMode=1
		s desc=$E(desc,1,len-1)
	}
    s desc=$ZCVT(desc,"U")
    if (EpisodeID'="") {
	    s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
		s AdmReason=$p($G(^PAADM(EpisodeID,1)),"^",7)
	}else{
		s AdmType="",AdmReason=""
	}
	;ICD类型转MRC_ICDDx MRCID_DiagnosticType 的枚举值
	s ICDType=$CASE(ICDType,1:"TCM",2:"ST",:"WM")
	s Rowid=0 for{
		s Rowid=$O(^MRC("ID",0,"Diagnostic",ICDType,Rowid)) Q:Rowid=""
		;先判断是否有效还是先匹配？ 目前先判断是否有效
		continue:'$$ValidICD(Rowid)
		s MatchPos=$$Match(Rowid)
		continue:'MatchPos
		s ICDDesc=$p(^MRC("ID",Rowid),"^",2)
		s RecordCount=0
		if (DiagOrderByUserFreq){
			s RecordCount=+##class(DHCDoc.Log.DHCDocCTUseCount).GetCount("User.MRCICDDx",Rowid,UserID,"U")
		}
		s ICDList(RecordCount,MatchPos,$L(ICDDesc),Rowid)=ICDDesc
	}
	;zw ICDList
	s SttIndex="",EndIndex="",index=0
	if (rows>0)&&(page>0){
		s SttIndex=rows*(page-1)+1
		s EndIndex=rows*page
	}
	s NowDate=..%ZD(+$H),ExpStr=""
	s RecordCount="" f  s RecordCount=$O(ICDList(RecordCount),-1) Q:RecordCount=""  d
	.s MatchPos=0 f  s MatchPos=$O(ICDList(RecordCount,MatchPos)) Q:MatchPos=""  d
	..s len=0 f  s len=$O(ICDList(RecordCount,MatchPos,len)) Q:len=""  d
	...s Rowid=0 f  s Rowid=$O(ICDList(RecordCount,MatchPos,len,Rowid)) Q:Rowid=""  d
	....s index=index+1	;为了解决医保组方法效率低的问题,只输出显示页的数据 
	....i ((SttIndex'="")&&(index<SttIndex))||((EndIndex'="")&&(index>EndIndex)) d
	.....s (ICDDesc,ICDCode,DiagInsuCode,DiagInsuName)=""
	....e  d
	.....s ICDDesc=ICDList(RecordCount,MatchPos,len,Rowid)
	.....s ICDDesc=##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc",ICDDesc,langid)
	.....s ICDCode=$p(^MRC("ID",Rowid),"^",1)
	.....;获取医保编码效率有点低	##class(web.DHCINSUPort).GetStdInfoByMRCICDDxRowId
    .....s DiagInsuInfo=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.diag.GetInsuInfo",Rowid,HospID,AdmReason,NowDate,ExpStr)
    .....s DiagInsuCode=$P(DiagInsuInfo,"^",1)
    .....s DiagInsuName=$P(DiagInsuInfo,"^",2)
	....d dataList.%Push($LB(ICDDesc,Rowid,ICDCode,DiagInsuCode,DiagInsuName))
	Q $$$OK
Match(Rowid)
	Q:desc="" 1
	s MatchPos=0
	s AliasRowid=0 for {
		s AliasRowid=$o(^MRC("ID",Rowid,"ALIAS",AliasRowid)) Q:AliasRowid=""
		s Alias=$g(^MRC("ID",Rowid,"ALIAS",AliasRowid))
		s MatchPos=$$GetMatchPos(Alias)
		Q:MatchPos
	}
	Q:MatchPos MatchPos
	s ICDDesc=$p(^MRC("ID",Rowid),"^",2)
	Q $$GetMatchPos(ICDDesc)
GetMatchPos(str)
	s str=$ZCVT(str,"U")
	Q:AccurateMode str=desc
	Q $FIND(str,desc)
ValidICD(Rowid)
    Q:'$d(^MRC("ID",Rowid)) 0
	;院区权限
	Q:(ICDDxDataType'="G")&&'$D(^User.BDPMappingHospI("DataRef","MRC_ICDDx",HospID,Rowid)) 0
	s MRCIDValid=$P($G(^MRC("ID",Rowid)),"^",27)
	Q:MRCIDValid="N" 0
	s DateFrom=$P($G(^MRC("ID",Rowid)),"^",6)
	s DateTo=$P($G(^MRC("ID",Rowid)),"^",7)
	Q:(DateFrom'="")&&(DateFrom>+$H) 0
	Q:(DateTo'="")&&(DateTo<+$H) 0
	s MetastaticSite=$P($G(^MRC("ID",Rowid)),"^",40) ;Y 肿瘤形态学编码 医生不使用
	s IPCode=$P($G(^MRC("ID",Rowid)),"^",41)  ;Injury/Poisoning 损伤中毒外部原因 医生不使用
	Q:(MetastaticSite="Y")||(IPCode="Y") 0
	;ICD诊断限制就诊类型
	if AdmType'=""{
		s AvailableType=$p($G(^MRC("ID",Rowid)),"^",47)
		Q:(AdmType'="")&&(AvailableType'="")&&((","_AvailableType_",")'[(","_AdmType_",")) 0
	}
	Q 1
}

ClassMethod QueryICDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryICDExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

/// 诊断是否为入院登记诊断
ClassMethod IsInHospRegDiag(DiagRowid) As %Boolean
{
	s DocDr=$P($G(^MR(+DiagRowid,"DIA",$P(DiagRowid,"||",2))),"^",4)
	s DocUserId=$O(^SSU("SSUSR",0,"CTPCP",+DocDr,0))
	s CreateUserDr=$P($G(^MR(+DiagRowid,"DIA",$P(DiagRowid,"||",2),1)),"^",18)
	Q DocUserId'=CreateUserDr
}

}
