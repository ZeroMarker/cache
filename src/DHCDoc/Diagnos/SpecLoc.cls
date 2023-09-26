Class DHCDoc.Diagnos.SpecLoc Extends DHCDoc.Util.RegisteredObject
{

/// 取病人某个表单某天的ID
ClassMethod GetMainID(PatientID, CatID, Date = "")
{
	s ID=""
	Q:CatID="" ID
	s Date=##class(websys.Conversions).DateHtmlToLogical(Date)
	s:Date="" Date=+$H
	s Time=$O(^User.MRSpecLocDiagI("IndexDateTime",PatientID,CatID,Date,""),-1)
	if Time'=""{ 
		s ID=$O(^User.MRSpecLocDiagI("IndexDateTime",PatientID,CatID,Date,Time,""),-1)
	}
	Q ID
}

ClassMethod Save(EpisodeID, PatientID, CatID, UserID, SerialNum = "")
{
	if (PatientID="")&&(EpisodeID'="") s PatientID=$P(^PAADM(EpisodeID),"^",1)
	Q:PatientID="" -101
	s obj=##class(User.MRSpecLocDiag).%New()
	d obj.AdmDRSetObjectId(EpisodeID)
	d obj.PatientDRSetObjectId(PatientID)
	d obj.DiagCatDRSetObjectId(CatID)
	d obj.UserDRSetObjectId(UserID)
	
	s obj.InsertDate=+$H
	s obj.InsertTime=$P($H,",",2)
	s obj.CustomSerialNum=SerialNum
	s obj.Active="Y"
	s sc=obj.%Save()
	if $$$ISERR(sc){
		Q -100
	}
	Q obj.%Id()
}

/// w ##class(DHCDoc.Diagnos.SpecLoc).SaveItem(814,349,4,$LG(^Wqy("SaveItem"),4),10209)
ClassMethod SaveItem(EpisodeID, PatientID, CatID, SaveData, UserID, Date = "", ParID = "", SerialNum = "")
{
	;s ^Wqy("SaveItem")=$LB(EpisodeID, PatientID, CatID, SaveData, UserID)
	s JsonObj={}.%FromJSON(SaveData)
	TS
	//s ParID=..GetMainID(PatientID, CatID,Date)
	if ParID=""{
		s ParID=..Save(EpisodeID, PatientID, CatID,UserID,SerialNum)
		if ParID<0{
			TRO
			Q ParID
		}
	}else{
		s ParObj=##class(User.MRSpecLocDiag).%OpenId(ParID)
		d ParObj.UpdateUserDRSetObjectId(UserID)
		s sc=ParObj.%Save()
		if $$$ISERR(sc){
			Q -100
		}
	}
	s err=0
	s iter=JsonObj.%GetIterator()
	while iter.%GetNext(.ItemCode,.value){
		s ItemID=$O(^User.DHCSpecLocDiagItemI("IndexCode",CatID," "_$ZCVT(ItemCode,"U"),0))
		continue:ItemID=""
		s ID=JsonObj.ID
		s:ID="" ID=$O(^User.MRSpecLocDiagItemI("IndexItem",ParID,ItemID,0))
		if ID=""{
			s obj=##class(User.MRSpecLocDiagItem).%New()
		}else{
			s obj=##class(User.MRSpecLocDiagItem).%OpenId(ID)
		}
		d obj.ParRefDRSetObjectId(ParID)
		d obj.ItemDRSetObjectId(ItemID)
		s obj.Value=value
		s sc=obj.%Save()
		if $$$ISERR(sc){
			s err=-1
			Q 
		}
			
	}
	if err TRO
	else  TC
	Q err_"^"_ParID
}

ClassMethod DeleteRecord(ID, UserID)
{
	TS
	/*&SQL(DELETE FROM SQLUser.MR_SpecLocDiagItem WHERE ParRefDR=:ID)
	s:SQLCODE=100 SQLCODE=0
	if 'SQLCODE{
		&SQL(DELETE FROM SQLUser.MR_SpecLocDiag WHERE ID=:ID)
	}*/
	s obj=##class(User.MRSpecLocDiag).%OpenId(ID)
	
	d:UserID'="" obj.UpdateUserDRSetObjectId(UserID)
	s obj.UpdateDate=+$H
	s obj.UpdateTime=$P($H,",",2)
	s obj.Active="N"
	s sc=obj.%Save()
	if $$$ISERR(sc){
		TRO
		Q -100
	}
	TC
	Q 0
}

ClassMethod GetOneCatJson(ParID)
{
	s retObj={}
	if ParID'=""{
		s ItemID=0 for{
			s ItemID=$O(^User.MRSpecLocDiagItemI("IndexItem",ParID,ItemID)) Q:ItemID=""
			s ID=$O(^User.MRSpecLocDiagItemI("IndexItem",ParID,ItemID,0))
			s obj=##class(User.MRSpecLocDiagItem).%OpenId(ID)
			;翻译放在datagrid的formattert中去
			s Value=obj.Value	;..%Translate("opdoc.specloc.diag.csp",obj.Value)
			d retObj.%Set(obj.ItemDR.Code,Value)
		}
	}
	Q retObj
}

ClassMethod GetPatData(EpisodeID, PatientID, CatID, Date = "", ParID = "")
{
	Q ..GetOneCatJson(ParID).%ToJSON()
}

/// w ##class(DHCDoc.Diagnos.SpecLoc).GetPatHistoryData(349,2)
ClassMethod GetPatHistoryData(PatientID, CatID, SerialNum = "")
{
	s rows=[]
	Set langid=..%LanguageID()
	s ParID=0 for{
		s ParID=$O(^User.MRSpecLocDiagI("IndexPat",PatientID,CatID,ParID)) Q:ParID=""
		s OrdSerialNum=$LG(^User.MRSpecLocDiagD(ParID),9)
		continue:(SerialNum'=OrdSerialNum)
		s DiagActive=$LG(^User.MRSpecLocDiagD(ParID),10)
		continue:(DiagActive="N")
		s ParObj=##class(User.MRSpecLocDiag).%OpenId(ParID)
		s row=..GetOneCatJson(ParID)
		s row.ID=ParID
		s row.AdmDR=ParObj.AdmDRGetObjectId()
		s row.PatientDR=ParObj.PatientDRGetObjectId()
		s row.InsertDate=##class(websys.Conversions).DateLogicalToHtml(ParObj.InsertDate)
		s row.InsertTime=##class(websys.Conversions).TimeLogicalToHtml(ParObj.InsertTime)
		s row.UserDR=ParObj.UserDRGetObjectId()
		s row.User=ParObj.UserDR.SSUSRName
		s row.User=##class(User.SSUser).GetTranByDesc("SSUSRName",row.User,langid)
		s row.UpdateUser=##class(User.SSUser).GetTranByDesc("SSUSRName",ParObj.UpdateUserDR.SSUSRName,langid)
		s OutList(ParObj.InsertDate,ParObj.InsertTime,ParID)=row
	}
	s Date="" f  s Date=$O(OutList(Date),-1) Q:Date=""  d
	.s Time="" f  s Time=$O(OutList(Date,Time),-1) Q:Time=""  d
	..s ParID="" f  s ParID=$O(OutList(Date,Time,ParID),-1) Q:ParID=""  d
	...d rows.%Push(OutList(Date,Time,ParID))
	Q {"rows":(rows),"total":(rows.%Size())}.%ToJSON()
}

ClassMethod GetHistoryColumns(CatID)
{
	s retObj=[]
	d retObj.%Push({"field":"ID","hidden":1})
	d retObj.%Push({"field":"AdmDR","hidden":1})
	d retObj.%Push({"field":"PatientDR","hidden":1})
	d retObj.%Push({"field":"UserDR","hidden":1})
	d retObj.%Push({"field":"InsertDate","title":"填写日期"})
	d retObj.%Push({"field":"InsertTime","title":"填写时间"})
	d retObj.%Push({"field":"User","title":"填写用户"})
	d retObj.%Push({"field":"UpdateUser","title":"更新用户"})
	s rs=##class(%ResultSet).%New("DHCDoc.Diagnos.SpecLocTemp:QueryCatItem")
	d rs.Execute(CatID)
	while rs.Next(){
		s Active=rs.GetDataByName("Active")
		continue:Active'="Y"
		s Code=rs.GetDataByName("Code")
		s Name=rs.GetDataByName("Name")
		d retObj.%Push({"field":(Code),"title":(Name)})
	}
	Q retObj.%ToJSON()
}

/// 格式化显示牙位图数据 已移动到前台处理
ClassMethod GetToothMapDesc(ToothData)
{
	s ret=""
	s ToothData={}.%FromJSON(ToothData)
	for Area="UpLeftAreaTeeth","UpRightAreaTeeth","DownLeftAreaTeeth","DownRightAreaTeeth"{
		s AreaData=ToothData.%Get(Area)
		for i=1:1:AreaData.%Size(){
			s OneTooth=AreaData.%Get(i-1)
			s ToothDesc=OneTooth.ToothDisplayName
			s ToothCode=OneTooth.ToothCode
			s SurfaceDesc="",SurfaceCode=""
			s SurfaceData=OneTooth.ToothSurfaceItems	
			for j=1:1:SurfaceData.%Size(){
				s OneSurface=SurfaceData.%Get(j-1)
				s SurfaceCode=SurfaceCode_OneSurface.Code
				i SurfaceDesc="" s SurfaceDesc=OneSurface.ToothSurfaceDisplayName
				e  s SurfaceDesc=SurfaceDesc_","_OneSurface.ToothSurfaceDisplayName
			}
			s:SurfaceDesc'="" ToothDesc=ToothDesc_"("_ SurfaceDesc_")"
			s:SurfaceCode'="" ToothCode=ToothCode_SurfaceCode
			i ret="" s ret=ToothDesc_"["_ToothCode_"]"
			e  s ret=ret_"、"_ToothDesc_"["_ToothCode_"]"
		}
	}
	Q ret
}

/// 更新医嘱关联的自定义表单
/// 如果一个人有多个表单
ClassMethod AutoSpecDiagnos(OrderRowIDStr, User) As %String
{
	s ^temp("AutoSpecDiagnos")=$LB(OrderRowIDStr, User)
	//s $ZT="AutoSpecDiagnosErr"
	s OrdItm = $p(OrderRowIDStr,"^",1)
	q:(OrdItm="") ""
	s EpisodeID=$P(^OEORD(+OrdItm),"^",1)
	q:(EpisodeID="") ""
	s SpecLocDiagCatID=""
	for {
		s SpecLocDiagCatID=$O(^User.MRSpecLocDiagI("IndexAdm",EpisodeID,SpecLocDiagCatID))
		q:(SpecLocDiagCatID="")
		s ParID=""
		for {
			s ParID=$O(^User.MRSpecLocDiagI("IndexAdm",EpisodeID,SpecLocDiagCatID,ParID))
			q:(ParID="")
			s DiagOrdSerialNum=$LG(^User.MRSpecLocDiagD(ParID),9)
			s DiagUserDR=$LG(^User.MRSpecLocDiagD(ParID),5)
			s DiagActive=$LG(^User.MRSpecLocDiagD(ParID),10)
			continue:(DiagActive="N")
			continue:(DiagUserDR'=User)
			s SerialNumType=$P(DiagOrdSerialNum,"|",1)
			continue:(SerialNumType'="ord")
			s OrdSerialNum=$P(DiagOrdSerialNum,"|",2)
			continue:($D(^OEORDi(0,"IndexSerialNum",OrdSerialNum,+OrdItm)))
			d ..DeleteRecord(ParID,"")
		}
	}
	q 0
AutoSpecDiagnosErr
	s $ZT=""
	q $ZE
}

/// 获取医嘱项关联的自定义表单ID
/// 理论上检查、检验、病历、治疗记录因为有自己的自定义表单，需要通过自己的表单去处理结构化数据
ClassMethod GetArcimLinkSpecLocDiag(ArcimDr As %String, HOSPID As %String, langid As %String) As %String
{
	q:(ArcimDr="")||(HOSPID="") ""
	s SpecLocDiagCatCode=""
	s ArcimDesc=$P(^ARCIM(+ArcimDr,$P(ArcimDr,"||",2),1),"^",2)
	s ID=$O(^DHCItmMast("0","ARCIM",ArcimDr,0))
	Q:ID="" ""
	s SpecLocDiagCatCode=$P(^DHCItmMast(ID),"^",39)
	q:(SpecLocDiagCatCode="") ""
	&SQL(select ID,Name into :SpecLocDiagCatID,:SpecLocDiagCatName from SQLUser.DHC_SpecLocDiagCat where Code=:SpecLocDiagCatCode)
	s SpecLocDiagCatName=##class(websys.Translation).Get("opdoc.specloc.diag.csp",SpecLocDiagCatName,langid)
	q SpecLocDiagCatID_"^"_SpecLocDiagCatCode_"^"_SpecLocDiagCatName
}

ClassMethod GetOrdLinkSpecLocDiag(OrderRowID As %String, HOSPID As %String, langid)
{
	q:(OrderRowID="") ""
	s EpisodeID=$P(^OEORD(+OrderRowID),"^",1)
	q:(EpisodeID="") ""
	s OrdSerialNum=$p($g(^OEORD(+OrderRowID,"I",$P(OrderRowID,"||",2),"DHC")),"^",75)
	s CustomSerialNum="ord|"_OrdSerialNum
	s SpecLocDiagCatID=""
	&SQL(SELECT DiagCatDR into :SpecLocDiagCatID from SQLUser.MR_SpecLocDiag where AdmDR=:EpisodeID and active<>'N' and CustomSerialNum =:CustomSerialNum )
	if (SQLCODE)||(SpecLocDiagCatID=""){
		q ""
	}
	s (SpecLocDiagCatCode,SpecLocDiagCatName)=""
	&SQL(select Code,Name into :SpecLocDiagCatCode,:SpecLocDiagCatName from SQLUser.DHC_SpecLocDiagCat where ID=:SpecLocDiagCatID)
	s SpecLocDiagCatName=##class(websys.Translation).Get("opdoc.specloc.diag.csp",SpecLocDiagCatName,langid)
	q SpecLocDiagCatID_"^"_SpecLocDiagCatCode_"^"_SpecLocDiagCatName
}

}
