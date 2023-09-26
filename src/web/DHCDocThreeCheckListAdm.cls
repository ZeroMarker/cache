Class web.DHCDocThreeCheckListAdm Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 增加/修改 科室医生主任医师或上级医师维护
/// (主(副)任医师MaterD，上级医师UpD)
/// Creator:qujian
/// CreateTime:20181022
/// w ##class(web.DHCDocThreeCheckListAdm).InsertThreeCheckDoc(158,10376,95,"MaterD",10209,"N")
ClassMethod InsertThreeCheckDoc(ID As %String = "", UserID As %String, LocID As %String, Type As %String, UpdateUserID As %String, Defined As %String = "N", Adm As %String)
{
	q:((UserID="")||(LocID="")||(Type="")||(UpdateUserID="")) ""
	s ^Tempqujian("InsertThreeCheckDoc")=ID_","_UserID_","_LocID_","_Type_","_UpdateUserID_","_Defined
	s Date=..%SysDate()
	s time=..%SysTime()
	s rtn=""
	s Replac=""
	if (ID=""){
		s Rowid=""
		for {
			s Rowid=$O(^DHCDocThreeChecki("LocUser",LocID,UpdateUserID,Rowid))
			q:Rowid=""
			s DocUserID=$P(^DHCDocThreeCheck(Rowid),"^",1)
			s DocType=$P(^DHCDocThreeCheck(Rowid),"^",3)
			if ((DocUserID=UserID)&&(DocType=Type)) s Replac="1"
		}
	}elseif(Adm'="") {
		s DocUserID=$P(^DHCDocThreeCheck(ID),"^",1)
		s DocType=$P(^DHCDocThreeCheck(ID),"^",3)
		s ChildRowid=$o(^DHCDocThreeChecki(0,"ThreeAdm",ID,Adm,"0"))
		if (ChildRowid=""){
			s ActiveFlag="N"
		}else{
			s ActiveFlag=$P(^DHCDocThreeCheck(ID,"ThreeCheck",ChildRowid),"^",2)
		}
		if (DocUserID'=UserID)||(DocType'=Type){
			s Rowid=""
			for {
				s Rowid=$O(^DHCDocThreeChecki("LocUser",LocID,UpdateUserID,Rowid))
				q:Rowid=""
				continue:Rowid=ID
				s DocUserID=$P(^DHCDocThreeCheck(Rowid),"^",1)
				s DocType=$P(^DHCDocThreeCheck(Rowid),"^",3)
				if ((DocUserID=UserID)&&(DocType=Type)) s Replac="1"
				s ChildRowid=$o(^DHCDocThreeChecki(0,"ThreeAdm",Rowid,Adm,"0"))
				if (ChildRowid=""){
					s tmpActiveFlag="N"
				}else{
					s tmpActiveFlag=$P(^DHCDocThreeCheck(Rowid,"ThreeCheck",ChildRowid),"^",2)
				}
				if (tmpActiveFlag="Y")&&(ActiveFlag="Y")&&(DocType=Type) s Replac=2
			}
		}
	}elseif ((Adm="")&&(ID'="")){
		s Rowid=""
		for {
			s Rowid=$O(^DHCDocThreeChecki("LocUser",LocID,UpdateUserID,Rowid))
			q:Rowid=""
			continue:ID=Rowid
			s DocUserID=$P(^DHCDocThreeCheck(Rowid),"^",1)
			s DocType=$P(^DHCDocThreeCheck(Rowid),"^",3)
			if ((DocUserID=UserID)&&(DocType=Type)) s Replac="1"
		}
	}
	if Replac=1 q "3"
	if Replac=2 q "2"
	if (Defined="Y"){
		s NotDefined="N"
		s Rowid=""
		for {
			s Rowid=$O(^DHCDocThreeChecki("LocUser",LocID,UpdateUserID,Rowid))
			q:Rowid=""
			&SQL(Update SQLUser.DHC_DocThreeCheckList set DocThree_Defined=:NotDefined where DocThree_RowId=:Rowid and DocThree_Type=:Type)
			if 'SQLCODE s rtn=SQLCODE
		}
	}
	Q:+rtn'="0" rtn
	if (ID=""){
		&SQL(insert into SQLUser.DHC_DocThreeCheckList 
		(DocThree_UserDR,DocThree_LocDR,DocThree_Type,DocThree_Defined,
		DocThree_Date,DocThree_Time,DocThree_UpdateUserDR
		) Values(:UserID,:LocID,:Type,:Defined,:Date,:time,:UpdateUserID))
		s rtn=SQLCODE
	}else{
		&SQL(Update SQLUser.DHC_DocThreeCheckList set DocThree_UserDR=:UserID,DocThree_LocDR=:LocID, 
		DocThree_Type=:Type,DocThree_Defined=:Defined,DocThree_Date=:Date,
		DocThree_Time=:time,DocThree_UpdateUserDR=:UpdateUserID
		where DocThree_RowId=:ID)
		s rtn=SQLCODE	
	}
	q rtn
}

/// 删除 科室医生主任医师或上级医师维护
/// Creator:qujian
/// CreateTime:20181022
ClassMethod DelectThreeDoc(ID As %String)
{
	q:ID="" ""
	s rtn=""
	ts
	&SQL(DELETE SQLUser.DHC_DocThreeCheckList where DocThree_RowId=:ID)
	if SQLCODE'=0 tro  q SQLCODE
	s ChirdRowid=$o(^DHCDocThreeCheck(ID,"ThreeCheck","0"))
	if (ChirdRowid'=""){
		&SQL(DELETE SQLUser.DHC_DocThreeCheckListAdm where DocThreeCheck_ParRef=:ID)
		if SQLCODE'=0 tro  q SQLCODE
	}
	tc
	q SQLCODE
}

/// 增加 患者主任医师或上级医师
/// Creator:qujian
/// CreateTime:20181022
/// w ##class(web.DHCDocThreeCheckListAdm).InsertThreeDocAdm(2,1,"","Y",4133)
ClassMethod InsertThreeDocAdm(Adm As %String, ThreeDocID As %String, ThreeDocAdmID As %String = "", Type As %String, UpdateUserID As %String)
{
	q:Adm=""||ThreeDocID=""||Type=""||UpdateUserID=""
	s rtn=""
	s Date=..%SysDate()
	s time=..%SysTime()
	if (ThreeDocAdmID=""){
		s ChirdRowid=$o(^DHCDocThreeChecki(0,"ThreeAdm",ThreeDocID,Adm,"0"))
		if ChirdRowid'="" s ThreeDocAdmID=ThreeDocID_"||"_ChirdRowid
		}
	if (ThreeDocAdmID=""){
		&SQL(insert into SQLUser.DHC_DocThreeCheckListAdm 
		(DocThreeCheck_Adm,DocThreeCheck_ActiveFlag,DocThreeCheck_Date,DocThreeCheck_Time,
		DocThreeCheck_UpdateUserDR,DocThreeCheck_ParRef
		) Values(:Adm,:Type,:Date,:time,:UpdateUserID,:ThreeDocID))
		s rtn=SQLCODE
	}else{
		&SQL(Update SQLUser.DHC_DocThreeCheckListAdm set DocThreeCheck_Adm=:Adm,DocThreeCheck_ActiveFlag=:Type, 
		DocThreeCheck_Date=:Date,DocThreeCheck_Time=:time,DocThreeCheck_UpdateUserDR=:UpdateUserID
		where DocThreeCheck_RowId =:ThreeDocAdmID)
		s rtn=SQLCODE
	}
	q rtn
}

/// 查询 患者科室医生
/// 
Query FindThreeDocAdm(UserID As %String, LocID As %String, Adm As %String) As %Query(ROWSPEC = "ThreeDocID:%String,ThreeDocAdmID:%String,UserDesc:%String,UserID:%String,Type:%String,ActiveFlag :%String,Defined:%String")
{
}

ClassMethod FindThreeDocAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindThreeDocAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindThreeDocAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindThreeDocAdmExecute ]
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

ClassMethod FindThreeDocAdmExecute(ByRef qHandle As %Binary, UserID As %String, LocID As %String, Adm As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocThreeCheckListAdm","FindThreeDocAdm","4634",110,2)
	s ^tempqujian("FindThreeDocAdmExecute")=$lb(UserID, LocID , Adm)
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	Set langid=..%LanguageID()
	s Rowid=""
	s number=1
	for {
		s Rowid=$O(^DHCDocThreeChecki("LocUser",LocID,UserID,Rowid))
		q:Rowid=""
		s DocUserID=$P(^DHCDocThreeCheck(Rowid),"^",1)
		s Type=$P(^DHCDocThreeCheck(Rowid),"^",3)
		s Activeflag="N"
		s CHirdsubrowid=""
		if (Adm'=""){
			s ChirdRowid=$o(^DHCDocThreeChecki(0,"ThreeAdm",Rowid,Adm,"0"))
			s CHirdsubrowid=""
			if (ChirdRowid=""){
				s Activeflag="N"
			}else{
				s Activeflag=$P(^DHCDocThreeCheck(Rowid,"ThreeCheck",ChirdRowid),"^",2)
				s CHirdsubrowid=Rowid_"||"_ChirdRowid
			}
		
		}
		s Defined=$P(^DHCDocThreeCheck(Rowid),"^",4)
		s PutINouf(Type,number)=Rowid_"^"_CHirdsubrowid_"^"_DocUserID_"^"_Type_"^"_Activeflag_"^"_Defined
		s number=number+1
	}
	s Typerowid=""
	for{
		s Typerowid=$o(PutINouf(Typerowid))
		q:Typerowid=""
		s rowidsub=""
		for{
			s rowidsub=$o(PutINouf(Typerowid,rowidsub))
			q:rowidsub=""
			s ThreeDocID=$P(PutINouf(Typerowid,rowidsub),"^",1)
			s ThreeDocAdmID=$P(PutINouf(Typerowid,rowidsub),"^",2)
			s TUserID=$P(PutINouf(Typerowid,rowidsub),"^",3)
			s UserDesc=$p(^SSU("SSUSR",TUserID),"^",2)
			s UserDesc=##class(User.SSUser).GetTranByDesc("SSUSRName",UserDesc,langid)
			s Type=$P(PutINouf(Typerowid,rowidsub),"^",4)
			if (Type="MaterD") s Type="主(副)任医师"
			if (Type="UpD") s Type="上级医师"
			s Type=##class(websys.Translation).Get("dhcdocthreechecklist.hui.csp",Type)
			s ActiveFlag=$P(PutINouf(Typerowid,rowidsub),"^",5)
			s Defined=$P(PutINouf(Typerowid,rowidsub),"^",6)
			set Data=$lb(ThreeDocID,ThreeDocAdmID,UserDesc,TUserID,Type,ActiveFlag,Defined)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

// 医生

/// 护士分床时自动增加科室医生患者
/// w ##class(web.DHCDocThreeCheckListAdm).InsertDefinedThreeCheck()
ClassMethod InsertDefinedThreeCheck(UserID As %String, LocID As %String, Adm As %String)
{
	s ^temp("InsertDefinedThreeCheck")=$lb(UserID,LocID,Adm)
	q:((UserID="")||(LocID="")||(Adm="")) ""
	s Rowid=""
	s rtn=""
	for{
		s Rowid=$O(^DHCDocThreeChecki("LocUser",LocID,UserID,Rowid))
		q:Rowid=""
		s Defined=$P(^DHCDocThreeCheck(Rowid),"^",4)
		continue:(Defined'="Y")
		// 判断是否有重复的上级医生
		s Flag=0
		s Type=$P(^DHCDocThreeCheck(Rowid),"^",3)
		s ID=""
		for {
			s ID=$O(^DHCDocThreeChecki("LocUser",LocID,UserID,ID)) q:ID=""
			continue:Rowid=ID
			s DocUserID=$P(^DHCDocThreeCheck(ID),"^",1)
			s DocType=$P(^DHCDocThreeCheck(ID),"^",3)
			continue:DocType'=Type
			s ChirdRowid=$o(^DHCDocThreeChecki(0,"ThreeAdm",ID,Adm,"0"))
			continue:ChirdRowid=""
			s Activeflag=$P(^DHCDocThreeCheck(ID,"ThreeCheck",ChirdRowid),"^",2)
			continue:Activeflag'="Y"
			s Flag=1
		}

		if (Flag=0){
		
			s rtn=..InsertThreeDocAdm(Adm,Rowid,"","Y",UserID)
		}
	}
	q rtn
}

/// 查询默认的科室医生
/// d ##class(%ResultSet).RunQuery("web.DHCDocThreeCheckListAdm","IPDocList",110)
Query IPDocList(LocId, ComparePart = "") As %Query(ROWSPEC = "Desc:%String,RowId:%String")
{
}

ClassMethod IPDocListExecute(ByRef qHandle As %Binary, LocId, ComparePart = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1 
	i LocId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ^tempqujian("IPDocList")=LocId
	Set langid=..%LanguageID()
	s ResRowId=""
	f  s ResRowId=$o(^RB("RES",0,"CTLOC",LocId,ResRowId)) q:ResRowId=""  d
	.s DocId=$p($G(^RB("RES",ResRowId)),"^",2)
	.s admright=$p($G(^RB("RES",ResRowId)),"^",20)
	.q:(admright'="Y")
	.s DocDesc=$p($G(^RB("RES",ResRowId)),"^",17)
	.q:DocId=""
	.s CTCPTypeId=$P($G(^CTPCP(DocId,1)),"^",4)
	.q:CTCPTypeId=""
	.s UserCode=$P($G(^CTPCP(DocId,1)),"^",1)
	.q:(DocDesc'[ComparePart)&&(UserCode'[ComparePart)&&(ComparePart'="")
	.s CTCPType=$P($G(^CT("CPT",CTCPTypeId)),"^",4)
	.s SSUserID=$O(^SSU("SSUSR",0,"CTPCP",DocId,""))
	.q:SSUserID=""
	.s DocDesc=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",DocDesc,langid)
	.;q:CTCPType'="DOCTOR"
	.Do OutputRow2
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(DocDesc,SSUserID)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod IPDocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IPDocListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
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

ClassMethod IPDocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IPDocListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
