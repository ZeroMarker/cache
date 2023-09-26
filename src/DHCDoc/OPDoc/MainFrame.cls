Class DHCDoc.OPDoc.MainFrame Extends DHCDoc.Util.RegisteredObject
{

ClassMethod GetBtnCfgData(url, EpisodeID = "", HospID = "", HISUIStyleCode = "")
{
	s data=[]
	s rows=##class(DHCDoc.Util.QueryToJSON).%New("DHCDoc.OPDoc.MainFrame","QueryBtnCfg",url,EpisodeID,HospID,HISUIStyleCode).ToArray()
	for i=1:1:rows.%Size(){
		s row=rows.%Get(i-1)
		if +row.prevGroupFlag&&data.%Size(){
			s lastRow=data.%Get(data.%Size()-1)
			if 'lastRow.items{
				s lastRow.items=[]
			}
			d lastRow.items.%Push(row)
			continue
		}
		d data.%Push(row)
	}
	Q data
}

Query QueryBtnCfg(url, EpisodeID = "", HospID = "", HISUIStyleCode = "") As %Query(ROWSPEC = "id,text,iconCls,style,handler,url,tooltip,shortcut,prevGroupFlag")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.MainFrame","QueryBtnCfg","opdoc.patient.list.csp",2975,2,"lite")
ClassMethod QueryBtnCfgExecute(ByRef qHandle As %Binary, url, EpisodeID = "", HospID = "", HISUIStyleCode = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s MainID=..GetBtnCSPCfgID(url,HospID)
	Q:MainID="" $$$OK
	s CareProvType=##class(web.DHCDocOrderCommon).GetCareProvType(%session.Get("LOGON.USERID"))
	s PAAdmType=$CASE(EpisodeID,"":"",:##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID))
	s Num="" for{
		s Num=$O(^User.DocCFTreatStatusInfoI("mainIndex",MainID,Num)) Q:Num=""
		s ID=0 for{
			s ID=$O(^User.DocCFTreatStatusInfoI("mainIndex",MainID,Num,1,ID)) Q:ID=""
			s obj=##class(User.DocCFTreatStatusInfo).%OpenId(ID)
			continue:'+obj.IsActive
			;continue:'+obj.IsVisible
			s express=obj.express
			if express'=""{
				x ("(out,EpisodeID,HospID,HISUIStyleCode,CareProvType,PAAdmType) s out="_express,
					.val,EpisodeID,HospID,HISUIStyleCode,CareProvType,PAAdmType)
				continue:'+val
			}
			s style=$CASE(HISUIStyleCode,"lite":obj.liteCustomStyle,:obj.customStyle)
			d rows.%Push($LB(obj.toolId,obj.name,obj.iconStyle,style,obj.clickHandler,obj.URLconfig,obj.tooltip,obj.shortcut,obj.prevGroupFlag))
		}
	}
	Quit $$$OK
}

ClassMethod QueryBtnCfgFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBtnCfgExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QueryTreatStep(EpisodeID = "", HospID = "") As %Query(ROWSPEC = "id,text,handler,url,isRefresh,disabled,mergeUp")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.MainFrame","QueryTreatStep","")
ClassMethod QueryTreatStepExecute(ByRef qHandle As %Binary, EpisodeID = "", HospID = "") As %Status [ ProcedureBlock = 0 ]
{
	s PatientID=$P($G(^PAADM(+EpisodeID)),"^",1)
	s rows=[]
	s qHandle=rows.%GetIterator()
	s DisplayNum="" for{
		s DisplayNum=$o(^User.DocCFStreamlineInfoI("DisplayNum",DisplayNum)) Q:DisplayNum=""
		s ID=0 for{
			s ID=$o(^User.DocCFStreamlineInfoI("DisplayNum",DisplayNum,ID)) Q:ID=""
			s obj=##class(User.DocCFStreamlineInfo).%OpenId(ID)
			s HospDr=obj.HospDrGetObjectId()
			continue:(HospID'="")&&(HospDr'="")&&(HospDr'=HospID)
			continue:obj.IsActive'=1
			s express=obj.ConditionalExpre
			s disabled=$CASE(express'="",0:0,:'+@express)
			s mergeUp=obj.PreLineClass'=""
			d rows.%Push($LB(obj.ItemID,obj.ItemName,obj.ItemClick,obj.StrLink,obj.isRefresh,disabled,mergeUp))
		}
	}
	Quit $$$OK
}

ClassMethod QueryTreatStepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTreatStepExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

ClassMethod GetBtnCSPCfgID(CSP, HospID = "")
{
	s MainID="" for{
		s MainID=$O(^User.DocCFTreatStatusMainInfoI("urlCSPname",CSP,MainID)) Q:MainID=""
		s HospDr=$LG(^User.DocCFTreatStatusMainInfoD(MainID),6)
		continue:(HospID'="")&&(HospDr'="")&&(HospDr'=HospID)
		Q
	}
	Q MainID
}

/// w ##class(DHCDoc.OPDoc.MainFrame).CopyBtnCfg("opdoc.outpatrecadm.csp","opdoc.main.framework.csp",2)
/// w ##class(DHCDoc.OPDoc.MainFrame).CopyBtnCfg("opdoc.outpatientlist.csp","opdoc.patient.list.csp",2)
ClassMethod CopyBtnCfg(OldCSP, NewCSP, HospID)
{
	s OldMainID=..GetBtnCSPCfgID(OldCSP,HospID)
	s NewMainID=..GetBtnCSPCfgID(NewCSP,HospID)
	s Num="" for{
		s Num=$O(^User.DocCFTreatStatusInfoI("mainIndex",OldMainID,Num)) Q:Num=""
		s ID=0 for{
			s ID=$O(^User.DocCFTreatStatusInfoI("mainIndex",OldMainID,Num,1,ID)) Q:ID=""
			k PLIST
			&SQL(SELECT * INTO :PLIST() FROM SQLUser.DocCFTreatStatusInfo WHERE TreatStatusConfigID=:ID)
			k PLIST(1)
			s PLIST(2)=NewMainID
			&SQL(INSERT INTO SQLUser.DocCFTreatStatusInfo VALUES :PLIST())
		}
	}
	Q 0
}

ClassMethod IsShowCardBill(EpisodeID, GroupID = "", HospID = "") As %Boolean
{
	s GroupShowFlag=##Class(web.UDHCOPGSConfig).GetGroupCPPFlag(GroupID,HospID)
	Q:GroupShowFlag'="Y" 0
	s VisitStatus=$P($G(^PAADM(+EpisodeID)),"^",20)
	Q:(VisitStatus'="A")&&(VisitStatus'="D") 0
	;1:当前状态为留观,2:曾经留观但当前非留观,-1:非留观
	s GetStayStatusFlag=##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID)
	if GetStayStatusFlag=1{
		s AdmHospID=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
		//0:普通收费模式；1：押金收费模式
		s StayPayMode=##class(web.DHCBillInterface).IGetStayPayMode(AdmHospID)
		Q:StayPayMode=1 0
	}
	Q 1
}

ClassMethod IsShowHLYYBtn(LocID, HospID = "")
{
	s CurrCompany=..%GetConfig("CurrCompany",HospID)
	s CurrCompanyCode=$p(CurrCompany,"^",2)
	Q:CurrCompanyCode="" 0
	s HLYYAdmDep=..%GetConfig("DTAdmDep",HospID) 
	Q:(HLYYAdmDep'="")&&(("^"_HLYYAdmDep_"^")'[("^"_LocID_"^")) 0
	Q 1
}

}
