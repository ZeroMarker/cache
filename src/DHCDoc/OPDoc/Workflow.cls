Class DHCDoc.OPDoc.Workflow Extends %RegisteredObject
{

ClassMethod SaveCats(SaveRows, UserID)
{
	s rows=[].%FromJSON(SaveRows)
	s err=0
	TS
	for i=1:1:rows.%Size(){
		s row=rows.%Get(i-1)
		s ret=..SaveCat(row.Name,UserID,row.ID)
		s err=$P(ret,"^",1)
		Q:err'=0
	}
	if err'=0 TRO
	else  TC
	Q err
}

/// w ##class(DHCDoc.OPDoc.Workflow).SaveCat("",1,"")
ClassMethod SaveCat(Name, UserID, ID = "")
{
	Q:Name="" "分类名称不能为空"
	s FindID=$O(^User.DHCDocOPWorkflowI("IndexName"," "_$ZCVT(Name,"U"),0))
	Q:(FindID'="")&&(FindID'=ID) "分类名称重复"
	LOCK ^DHCDocWorkflowLOCK
	k PLIST
	s PLIST(2)=Name
	if ID=""{
		s Sequece=$O(^User.DHCDocOPWorkflowI("IndexSequece",""),-1)+1
		s PLIST(3)=Sequece
		s PLIST(4)=UserID
		s PLIST(5)=+$H
		s PLIST(6)=$P($H,",",2)
		&SQL(INSERT INTO SQLUser.DHCDoc_OPWorkflow VALUES :PLIST())
	}else{
		s PLIST(7)=+$H
		s PLIST(8)=$P($H,",",2)
		&SQL(UPDATE SQLUser.DHCDoc_OPWorkflow VALUES :PLIST() WHERE ID=:ID)
	}
	LOCK -^DHCDocWorkflowLOCK
	Q:SQLCODE SQLCODE
	Q SQLCODE_"^"_%ROWID
}

/// w ##class(DHCDoc.OPDoc.Workflow).UpdateCatSeq("[2,1]")
ClassMethod UpdateCatSeq(IDStr)
{
	s IDArr=[].%FromJSON(IDStr)
	LOCK ^DHCDocWorkflowLOCK
	TS
	&SQL(UPDATE SQLUser.DHCDoc_OPWorkflow SET Sequece=NULL)
	if 'SQLCODE{
		for i=1:1:IDArr.%Size(){
			s ID=IDArr.%Get(i-1)
			&SQL(UPDATE SQLUser.DHCDoc_OPWorkflow SET Sequece=:i WHERE ID=:ID)
			Q:SQLCODE
		}
	}
	if SQLCODE TRO
	else  TC
	LOCK -^DHCDocWorkflowLOCK
	Q SQLCODE
}

ClassMethod SaveItems(CatID, SaveRows, UserID)
{
	s rows=[].%FromJSON(SaveRows)
	s err=0
	TS
	for i=1:1:rows.%Size(){
		s row=rows.%Get(i-1)
		s ret=..SaveItem(CatID,row.Code,row.Name,row.ClickEvent,row.Express,row.Link,row.Active,row.XRefresh,row.PreLineClass,UserID,row.ID)
		s err=$P(ret,"^",1)
		Q:err'=0
	}
	if err'=0 TRO
	else  TC
	Q err
}

/// w ##class(DHCDoc.OPDoc.Workflow).SaveItem(1,1,"测试备注",0,10209,"")
ClassMethod SaveItem(CatID, Code, Name, ClickEvent, Express, Link, Active, XRefresh, PreLineClass, UserID, ID = "")
{
	s FindID=$O(^User.DHCDocOPWorkflowItemI("IndexCode",CatID," "_$ZCVT(Code,"U"),0))
	Q:(FindID'="")&&(FindID'=ID) "项目代码重复"
	s FindID=$O(^User.DHCDocOPWorkflowItemI("IndexName",CatID," "_$ZCVT(Name,"U"),0))
	Q:(FindID'="")&&(FindID'=ID) "项目名称重复"
	LOCK ^DHCDocWorkflowLOCK("Cat",CatID)
	k PLIST
	s PLIST(2)=CatID
	s PLIST(3)=Code
	s PLIST(4)=Name
	s PLIST(5)=ClickEvent
	s PLIST(6)=Express
	s PLIST(7)=Link
	s PLIST(9)=Active
	s PLIST(10)=XRefresh
	s PLIST(11)=PreLineClass
	if ID=""{
		s Sequece=$O(^User.DHCDocOPWorkflowItemI("IndexSequece",CatID,""),-1)+1
		s PLIST(8)=Sequece
		s PLIST(12)=UserID
		s PLIST(13)=+$H
		s PLIST(14)=$P($H,",",2)
		&SQL(INSERT INTO SQLUser.DHCDoc_OPWorkflowItem VALUES :PLIST())
	}else{
		s PLIST(15)=+$H
		s PLIST(16)=$P($H,",",2)
		&SQL(UPDATE SQLUser.DHCDoc_OPWorkflowItem VALUES :PLIST() WHERE ID=:ID)
	}
	LOCK -^DHCDocWorkflowLOCK("Cat",CatID)
	Q:SQLCODE SQLCODE
	Q SQLCODE_"^"_%ROWID
}

/// w ##class(DHCDoc.OPDoc.Workflow).UpdatItemSeq(1,"[2,1]")
ClassMethod UpdatItemSeq(CatID, IDStr)
{
	LOCK ^DHCDocWorkflowLOCK("Cat",CatID)
	TS
	&SQL(UPDATE SQLUser.DHCDoc_OPWorkflowItem SET Sequece=NULL WHERE CatDR=:CatID)
	s:SQLCODE=100 SQLCODE=0
	if 'SQLCODE{
		s IDArr=[].%FromJSON(IDStr)
		for i=1:1:IDArr.%Size(){
			s ID=IDArr.%Get(i-1)
			s:ID["_" ID=$P(ID,"_",$L(ID,"_"))
			&SQL(UPDATE SQLUser.DHCDoc_OPWorkflowItem SET Sequece=:i,CatDR=:CatID WHERE ID=:ID)
			Q:SQLCODE
		}
	}
	if SQLCODE TRO
	else  TC
	LOCK -^DHCDocWorkflowLOCK("Cat",CatID)
	Q SQLCODE
}

Query QueryCat() As %SQLQuery
{
	SELECT * FROM SQLUser.DHCDoc_OPWorkflow ORDER BY Sequece
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.Workflow","QueryCatItem","1")
Query QueryCatItem(CatID) As %SQLQuery
{
	SELECT * FROM SQLUser.DHCDoc_OPWorkflowItem WHERE CatDR=:CatID ORDER BY Sequece
}

ClassMethod DeleteCat(CatID)
{
	LOCK ^DHCDocWorkflowLOCK("Cat",CatID)
	TS
	&SQL(DELETE FROM SQLUser.DHCDoc_OPWorkflowItem WHERE CatDR=:CatID)
	s:SQLCODE=100 SQLCODE=0
	if 'SQLCODE{
		&SQL(DELETE FROM SQLUser.DHCDoc_OPWorkflow WHERE ID=:CatID)
	}
	if SQLCODE TRO
	else  TC
	LOCK -^DHCDocWorkflowLOCK("Cat",CatID)
	Q SQLCODE
}

ClassMethod DeleteItem(ID)
{
	&SQL(DELETE FROM SQLUser.DHCDoc_OPWorkflowItem WHERE ID=:ID)
	Q SQLCODE
}

Query QueryHosp() As %Query(ROWSPEC = "id,text,code")
{
}

ClassMethod QueryHospExecute(ByRef qHandle As %Binary) As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s rs=##class(%ResultSet).%New("web.DHCBL.CT.CTHospital:GetDataForCmb1")
	if rs.QueryIsValid(){
		d rs.Execute("","","","","")
		while rs.Next(){
			s id=rs.GetDataByName("HOSPRowId")
			s code=rs.GetDataByName("HOSPCode")
			s text=rs.GetDataByName("HOSPDesc")
			d rows.%Push($LB(id,text,code))
		}
	}
	Quit $$$OK
}

ClassMethod QueryHospFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHospExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QueryGroup() As %Query(ROWSPEC = "id,text,code")
{
}

ClassMethod QueryGroupExecute(ByRef qHandle As %Binary) As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s id=0 for{
		s id=$O(^SSU("SSGRP",id)) Q:id=""
		s text=$P(^SSU("SSGRP",id),"^",1)
		continue:text["停用"
		continue:($P(^SSU("SSGRP",id),"^",151)="N")
		s code=##class(ext.util.String).ToChineseSpell(text)
		d rows.%Push($LB(id,text,code))
	}
	Quit $$$OK
}

ClassMethod QueryGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGroupExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QueryLoc() As %Query(ROWSPEC = "id,text,code")
{
}

ClassMethod QueryLocExecute(ByRef qHandle As %Binary) As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s id=0 for{
		s id=$O(^PAC("ADMLOC",0,"AdmType","O",id)) Q:id=""
		s DateTo=$P(^CTLOC(id),"^",25)
		continue:(DateTo'="")&&(DateTo<=+$H)
		s text=$P(^CTLOC(id),"^",2)
		s code=$P(^CTLOC(id),"^",43)
		continue:($P(^CTLOC(id),"^",14)'="Y")
		d rows.%Push($LB(id,text,code))
	}
	Quit $$$OK
}

ClassMethod QueryLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

ClassMethod SaveCatAuth(CatID, HospIDs, LocIDs, GroupIDs)
{
	&SQL(UPDATE SQLUser.DHCDoc_OPWorkflow SET AuthHospIDs=:HospIDs,AuthLocIDs=:LocIDs,AuthGroupIDs=:GroupIDs WHERE ID=:CatID)
	Q SQLCODE
}

ClassMethod GetUserLogonCat(LocID, GroupID, UserID, EpisodeID)
{
	s CatID=""
	s HospID=$P(^CTLOC(LocID),"^",22)
	s rs=##class(%ResultSet).%New("DHCDoc.OPDoc.Workflow:QueryCat")
	d rs.Execute()
	while rs.Next(){
		s AuthHospIDs=rs.GetDataByName("AuthHospIDs")
		continue:'..CheckAuth(AuthHospIDs,HospID)
		s AuthLocIDs=rs.GetDataByName("AuthLocIDs")
		continue:'..CheckAuth(AuthLocIDs,LocID)
		s AuthGroupIDs=rs.GetDataByName("AuthGroupIDs")
		continue:'..CheckAuth(AuthGroupIDs,GroupID)
		s CatID=rs.GetDataByName("ID")
		Q
	}
	Q CatID
}

ClassMethod CheckAuth(Data, Value)
{
	Q:(Data="")||(Data="[]") 1
	s Flag=0
	s rows=[].%FromJSON(Data)
	s Iterator=rows.%GetIterator()
	while Iterator.%GetNext(.key,.Val){
		if Val=Value{
			s Flag=1
			Q
		}
	}
	Q Flag
}

Query QueryCatListForGroup(GroupID, HospID) As %Query(ROWSPEC = "SeqNo,CatID,CatDesc,LocID,Desc,NewDocGotoWhere,NewDocGotoWhereName")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.Workflow","QueryCatListForGroup","126",2)
/// 获取安全组授权过的科室列表
ClassMethod QueryCatListForGroupExecute(ByRef qHandle As %Binary, GroupID, HospID) As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s HospCodeNode="HospDr_"_HospID
	s SeqNo=0
	s rs=##class(%ResultSet).%New("DHCDoc.OPDoc.Workflow:QueryCat")
	d rs.Execute()
	while rs.Next(){
		s AuthHospIDs=rs.GetDataByName("AuthHospIDs")
		continue:'..CheckAuth(AuthHospIDs,HospID)
		s AuthGroupIDs=rs.GetDataByName("AuthGroupIDs")
		continue:'..CheckAuth(AuthGroupIDs,GroupID)
		s AuthLocIDs=rs.GetDataByName("AuthLocIDs")
		//continue:'..CheckAuth(AuthLocIDs,LocID)

		s CatID=rs.GetDataByName("ID")
		s CatDesc=rs.GetDataByName("Name")
		s:AuthLocIDs="" AuthLocIDs="[]"
		s AuthLocIDs=[].%FromJSON(AuthLocIDs)
		s len=AuthLocIDs.%Size()
		if len{
			for i=1:1:len{
				s LocID=AuthLocIDs.%Get(i-1)
				s Desc=$P(^CTLOC(LocID),"^",2)
				s NewDocGotoWhere=$G(^DHCDocConfig(HospCodeNode,"NewDocGotoWhere",CatID,GroupID,LocID))
				d OutputRow
			}
		}else{
			s LocID=""
			s Desc="通用"
			s NewDocGotoWhere=$G(^DHCDocConfig(HospCodeNode,"NewDocGotoWhere",CatID,GroupID))
			d OutputRow
		}
	}
	Q $$$OK
OutputRow	
	s NewDocGotoWhereName=""
	if (NewDocGotoWhere'=""){
		&SQL(SELECT Name into :NewDocGotoWhereName FROM SQLUser.DHCDoc_OPWorkflowItem WHERE CatDR=:CatID and ID=:NewDocGotoWhere)
	}
	d rows.%Push($LB($I(SeqNo),CatID,CatDesc,LocID,Desc,NewDocGotoWhere,NewDocGotoWhereName))
	Q
}

ClassMethod QueryCatListForGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCatListForGroupExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

/***
  **Description      :获取维护的默认工作流项目
  **Author           :tanjishan
  **Time             :2022/12/05
  **debugger         :##Class(DHCDoc.OPDoc.Workflow).GetDefaultWorkflowItem("18881^126^60^2^^20^61875")
  **Parameter        :input
  **Returns          :%String
***/
ClassMethod GetDefaultWorkflowItem(SessionStr, EpisodeID = "") As %String
{
	s UserID=$P(SessionStr,"^",1)
	s GroupID=$P(SessionStr,"^",2)
	s LocID=$P(SessionStr,"^",3)
	s HospID=$P(SessionStr,"^",4)
	s CatID=..GetUserLogonCat(LocID, GroupID, UserID, EpisodeID)
	Q:CatID="" ""
	s NewDocGotoWhere=""
	s rs=##class(%ResultSet).%New("DHCDoc.OPDoc.Workflow:QueryCatListForGroup")
	d rs.Execute(GroupID,HospID)
	while rs.Next(){
		s mCatID=rs.GetDataByName("CatID")
		continue:CatID'=mCatID
		s mLocID=rs.GetDataByName("LocID")
		continue:(mLocID'="")&&(mLocID'=LocID)
		s NewDocGotoWhere=rs.GetDataByName("NewDocGotoWhere")
		Q:mLocID'=""
	}
	s NewDocGotoWhereCode=""
	if (NewDocGotoWhere>0){
		&SQL(SELECT code into :NewDocGotoWhereCode  from SQLUser.DHCDoc_OPWorkflowItem where id=:NewDocGotoWhere)
	}
	Q NewDocGotoWhereCode
}

Query QueryTreatStep(LocID, GroupID, UserID, EpisodeID = "") As %Query(ROWSPEC = "id,text,handler,url,isRefresh:%Boolean,disabled:%Boolean,mergeUp")
{
}

/// 获取按照科室授权过的门诊工作流
/// d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.Workflow","QueryTreatStep",6,28,10209)
ClassMethod QueryTreatStepExecute(ByRef qHandle As %Binary, LocID, GroupID, UserID, EpisodeID = "") As %Status [ ProcedureBlock = 0 ]
{
	n (qHandle,LocID, GroupID, UserID, EpisodeID,%session)
	s rows=[]
	s qHandle=rows.%GetIterator()
	s CatID=..GetUserLogonCat(LocID, GroupID, UserID,EpisodeID)
	Q:CatID="" $$$OK
	s PatientID=$CASE(EpisodeID,"":"",:$P($G(^PAADM(EpisodeID)),"^",1))
	s rs=##class(%ResultSet).%New("DHCDoc.OPDoc.Workflow:QueryCatItem")
	d rs.Execute(CatID)
	while rs.Next(){
		s Avtive=rs.GetDataByName("Active")
		continue:Avtive'=1
		s id=rs.GetDataByName("Code")
		s text=rs.GetDataByName("Name")
		s text=##class(websys.Translation).Get("opdoc.main.framework.csp",text)
		s handler=rs.GetDataByName("ClickEvent")
		s url=rs.GetDataByName("Link")
		s isRefresh=rs.GetDataByName("XRefresh")
		s express=rs.GetDataByName("Express")
		s disabled=$CASE(express'="",0:0,:'+@express)
		s PreLineClass=rs.GetDataByName("PreLineClass")
		s mergeUp=(PreLineClass'="")
		d rows.%Push($LB(id,text,handler,url,isRefresh,disabled,mergeUp))
	}
	Quit $$$OK
}

ClassMethod QueryTreatStepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTreatStepExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

}
