/// creator:王清雍
/// date:2021-06-05
/// desc:新诊断模板前后台交互类
/// table:MRC_DiagFavCat(模板分类),MRC_DiagFavItem(模板诊断项目),MRC_DiagFavSynd(证型)
Class DHCDoc.Diagnos.Fav Extends DHCDoc.Util.RegisteredObject
{

/// w ##class(DHCDoc.Diagnos.Fav).GetFavData("User.SSUser",6,10209)
ClassMethod GetFavData(Type, LocID, UserID, CONTEXT = "", EpisodeID = "", OnlyCatNode = "")
{
	s FavStream=##class(%Stream.GlobalCharacter).%New()
	d ..GetFavCatJSON(Type,LocID,UserID,CONTEXT,EpisodeID,OnlyCatNode).%ToJSON(.FavStream)
	d FavStream.OutputToDevice()
	Q ""
}

/// w ##class(DHCDoc.Diagnos.Fav).GetFavCatJSON("User.SSUser",6,10209).%ToJSON()
ClassMethod GetFavCatJSON(Type, LocID, UserID, CONTEXT = "", EpisodeID = "", OnlyCatNode = "") As %DynamicArray
{
	s rows=[]
	s rs=##class(%ResultSet).%New("DHCDoc.Diagnos.Fav:QueryCat")
	d rs.Execute(Type,LocID,UserID,CONTEXT)
	while rs.Next(){
		s ID=rs.GetDataByName("ID")
		s Name=rs.GetDataByName("Name")
		s obj={"id":(ID),"text":(Name)}
		s:OnlyCatNode'=1 obj.children=..GetFavItemJSON(ID, EpisodeID)
		d rows.%Push(obj)
	}
	Q rows
}

/// w ##class(DHCDoc.Diagnos.Fav).GetFavSubCatJSON(1,1).%ToJSON()
ClassMethod GetFavItemJSON(CatID, EpisodeID = "") As %DynamicArray
{
	s rows=[]
	s rs=##class(%ResultSet).%New("DHCDoc.Diagnos.Fav:QueryItem")
	d rs.Execute(CatID)
	while rs.Next(){
		s ID=rs.GetDataByName("ID")
		s ICDRowid=rs.GetDataByName("ICDRowid")
		s ICDDesc=rs.GetDataByName("ICDDesc")
		s Note=rs.GetDataByName("Note")
		s Type=rs.GetDataByName("Type")
		s Prefix=rs.GetDataByName("Prefix")
		s SDSInfo=rs.GetDataByName("SDSInfo")
		s text=ICDDesc
		i text="" s text=Note
		e  i Note'="" s text=text_"("_Note_")"
		s obj={"id":(CatID_"_"_ID),"text":(text),"attributes":{"ICDRowid":(ICDRowid),"ICDDesc":(ICDDesc),"Note":(Note),"Type":(Type),"Prefix":(Prefix),"SDSInfo":(SDSInfo)}}
		if Type{
			s obj.children=..GetFavSyndrome(ID, EpisodeID)
		}
		d rows.%Push(obj)
	}
	Q rows
}

ClassMethod GetFavSyndrome(ItemID, EpisodeID = "") As %DynamicArray
{
	s rows=[]
	s CatID=$LG(^User.MRCDiagFavItemD(ItemID),2)
	s IDPrefix=CatID_"_"_ItemID_"_"
	s rs=##class(%ResultSet).%New("DHCDoc.Diagnos.Fav:QuerySyndrome")
	d rs.Execute(ItemID)
	while rs.Next(){
		s ID=rs.GetDataByName("ID")
		s SyndromeID=rs.GetDataByName("SyndromeID")
		s SyndDesc=rs.GetDataByName("SyndDesc")
		s Note=rs.GetDataByName("Note")
		s text=SyndDesc
		i text="" s text=Note
		e  i Note'="" s text=text_"("_Note_")"
		d rows.%Push({"id":(IDPrefix_ID),"text":(text),"attributes":{"SyndromeID":(SyndromeID),"SyndDesc":(SyndDesc),"Note":(Note)}})
	}
	Q rows
}

ClassMethod SaveCats(Type, LocID, UserID, SaveRows, CONTEXT = "")
{
	s rows=[].%FromJSON(SaveRows)
	s err=0
	TS
	for i=1:1:rows.%Size(){
		s row=rows.%Get(i-1)
		s ID=row.ID
		s Name=row.Name
		s ret=..SaveCat(Type, Name, LocID, UserID, CONTEXT,ID)
		s err=$P(ret,"^",1)
		Q:err'=0
	}
	if err'=0 TRO
	else  TC
	Q err
}

/// w ##class(DHCDoc.Diagnos.Fav).SaveCat("User.SSUser","分类1",6,10209,"","")
ClassMethod SaveCat(Type, Name, LocID, UserID, CONTEXT = "", ID = "")
{
	s TypeObj=..GetCatTypeData(Type, LocID, UserID,CONTEXT)
	s CatType=TypeObj.CatType,TypeValue=TypeObj.TypeValue
	Q:Name="" "分类名称不能为空"
	s FindID=$O(^User.MRCDiagFavCatI("IndexName"," "_$ZCVT(CatType,"U")," "_$ZCVT(TypeValue,"U")," "_$ZCVT(Name,"U"),0))
	Q:(FindID'="")&&(FindID'=ID) "分类名称重复^"_FindID
	LOCK ^DHCDocDiagFAVLOCK(CatType,TypeValue)
	k PLIST
	s PLIST(2)=CatType
	s PLIST(3)=TypeValue
	s PLIST(4)=Name
	s PLIST(6)=UserID
	if ID=""{
		s Sequece=$O(^User.MRCDiagFavCatI("IndexSequece"," "_$ZCVT(CatType,"U")," "_$ZCVT(TypeValue,"U"),""),-1)+1
		s PLIST(5)=Sequece
		&SQL(INSERT INTO SQLUser.MRC_DiagFavCat VALUES :PLIST())
	}else{
		&SQL(UPDATE SQLUser.MRC_DiagFavCat VALUES :PLIST() WHERE ID=:ID)
	}
	LOCK -^DHCDocDiagFAVLOCK(CatType,TypeValue)
	Q:SQLCODE SQLCODE
	Q SQLCODE_"^"_%ROWID
}

/// w ##class(DHCDoc.Diagnos.Fav).UpdateCatSeq("[2,1]")
ClassMethod UpdateCatSeq(IDStr)
{
	s IDArr=[].%FromJSON(IDStr)
	s CatType=$LG(^User.MRCDiagFavCatD(IDArr.%Get(0)),2)
	s TypeValue=$LG(^User.MRCDiagFavCatD(IDArr.%Get(0)),3)
	LOCK ^DHCDocDiagFAVLOCK(CatType,TypeValue)
	TS
	for i=1:1:IDArr.%Size(){
		s ID=IDArr.%Get(i-1)
		&SQL(UPDATE SQLUser.MRC_DiagFavCat SET Sequece=NULL WHERE ID=:ID)
		s:SQLCODE=100 SQLCODE=0
		Q:SQLCODE
	}
	if 'SQLCODE{
		for i=1:1:IDArr.%Size(){
			s ID=IDArr.%Get(i-1)
			&SQL(UPDATE SQLUser.MRC_DiagFavCat SET Sequece=:i WHERE ID=:ID)
			Q:SQLCODE
		}
	}
	if SQLCODE TRO
	else  TC
	LOCK -^DHCDocDiagFAVLOCK(CatType,TypeValue)
	Q SQLCODE
}

ClassMethod GetCatTypeData(Type, LocID, UserID, CONTEXT = "") As %DynamicObject
{
	Q {"CatType":(..GetCatType(Type, CONTEXT, LocID)),"TypeValue":($CASE(Type,"User.SSUser":UserID,"User.CTLoc":LocID,"User.CTHospital":$P(^CTLOC(LocID),"^",22)))}
}

ClassMethod GetCatType(Type, CONTEXT, LocID)
{
	s CatType=Type_"|"_CONTEXT
	if Type="User.SSUser"{
		s HospID=$P(^CTLOC(LocID),"^",22)
		;个人模板增加院区标识区分
		s CatType=CatType_"|"_HospID
	}
	Q CatType
}

/// 获取大类院区ID
ClassMethod GetCatHospID(CatID)
{
	Q:'$D(^User.MRCDiagFavCatD(CatID)) ""
	s CatType=$LG(^User.MRCDiagFavCatD(CatID),2)
	s CatTypeValue=$LG(^User.MRCDiagFavCatD(CatID),3)
	s Type=$P(CatType,"|",1)
	s HospID=$CASE(Type,"User.SSUser":$P(CatType,"|",3),"User.CTLoc":$P(^CTLOC(CatTypeValue),"^",22),"User.CTHospital":CatTypeValue,:"")
	s:+HospID=0 HospID=""
	Q HospID
}

ClassMethod DeleteCat(ID)
{
	TS
	&SQL(DELETE FROM SQLUser.MRC_DiagFavSynd WHERE ItemDR->CatDR=:ID)
	S:SQLCODE=100 SQLCODE=0
	if 'SQLCODE{
		&SQL(DELETE FROM SQLUser.MRC_DiagFavItem WHERE CatDR=:ID)
		S:SQLCODE=100 SQLCODE=0
	}
	if 'SQLCODE{
		&SQL(DELETE FROM SQLUser.MRC_DiagFavCat WHERE ID=:ID)
	}
	if SQLCODE TRO
	else  TC
	Q SQLCODE
}

ClassMethod SaveItems(CatID, SaveRows, UserID)
{
	s rows=[].%FromJSON(SaveRows)
	s err=0
	TS
	for i=1:1:rows.%Size(){
		s row=rows.%Get(i-1)
		s ID=row.ID
		s ICDRowid=row.ICDRowid
		s Note=row.Note
		s Type=row.Type
		s Prefix=row.Prefix
		s SDSInfo=row.SDSInfo
		s SyndData=row.SyndData
		s ret=..SaveItem(CatID, ICDRowid, Note, Type,UserID,Prefix,SDSInfo,ID,SyndData)
		s err=$P(ret,"^",1)
		Q:err'=0
	}
	if err'=0 TRO
	else  TC
	Q err
}

/// w ##class(DHCDoc.Diagnos.Fav).SaveItem(1,1,"测试备注",0,10209,"")
ClassMethod SaveItem(CatID, ICDRowid, Note, Type, UserID, Prefix = "", SDSInfo = "", ID = "", SyndData = "")
{
	s iICDRowid=ICDRowid
	s:iICDRowid="" iICDRowid=-100000000000000
	s FindID=$O(^User.MRCDiagFavItemI("IndexItem",CatID,iICDRowid," "_$ZCVT(Note,"U")," "_$ZCVT(Prefix,"U")," "_$ZCVT(SDSInfo,"U"),0))
	Q:(FindID'="")&&(FindID'=ID) "诊断项目重复^"_FindID
	TS
	LOCK ^DHCDocDiagFAVLOCK("Cat",CatID)
	k PLIST
	s PLIST(2)=CatID
	s PLIST(3)=ICDRowid
	s PLIST(4)=Note
	s PLIST(5)=Type
	s PLIST(7)=UserID
	s PLIST(8)=Prefix
	s PLIST(9)=SDSInfo
	if ID=""{
		s Sequece=$O(^User.MRCDiagFavItemI("IndexSequece",CatID,""),-1)+1
		s PLIST(6)=Sequece
		&SQL(INSERT INTO SQLUser.MRC_DiagFavItem VALUES :PLIST())
		s:'SQLCODE ID=%ROWID
	}else{
		&SQL(UPDATE SQLUser.MRC_DiagFavItem VALUES :PLIST() WHERE ID=:ID)
	}
	if 'SQLCODE&&(SyndData'=""){
		if $IsObject(SyndData){
			s SyndData=SyndData.%ToJSON()
		}
		s SQLCODE=..SaveSyndromes(%ROWID,SyndData,UserID)
	}
	LOCK -^DHCDocDiagFAVLOCK("Cat",CatID)
	if SQLCODE'=0{
		TRO
		Q SQLCODE
	}else{
		TC
		Q SQLCODE_"^"_ID
	}
}

/// w ##class(DHCDoc.Diagnos.Fav).UpdatItemSeq(1,"[2,1]")
ClassMethod UpdatItemSeq(CatID, IDStr)
{
	LOCK ^DHCDocDiagFAVLOCK("Cat",CatID)
	TS
	&SQL(UPDATE SQLUser.MRC_DiagFavItem SET Sequece=NULL WHERE CatDR=:CatID)
	s:SQLCODE=100 SQLCODE=0
	if 'SQLCODE{
		s IDArr=[].%FromJSON(IDStr)
		for i=1:1:IDArr.%Size(){
			s ID=IDArr.%Get(i-1)
			s:ID["_" ID=$P(ID,"_",$L(ID,"_"))
			&SQL(UPDATE SQLUser.MRC_DiagFavItem SET Sequece=:i,CatDR=:CatID WHERE ID=:ID)
			Q:SQLCODE
		}
	}
	if SQLCODE TRO
	else  TC
	LOCK -^DHCDocDiagFAVLOCK("Cat",CatID)
	Q SQLCODE
}

ClassMethod DeleteItem(ID)
{
	TS
	&SQL(DELETE FROM SQLUser.MRC_DiagFavSynd WHERE ItemDR=:ID)
	S:SQLCODE=100 SQLCODE=0
	if 'SQLCODE{
		&SQL(DELETE FROM SQLUser.MRC_DiagFavItem WHERE ID=:ID)
	}
	if SQLCODE TRO
	else  TC
	Q SQLCODE
}

ClassMethod SaveSyndromes(ItemID, SaveRows, UserID)
{
	s rows=[].%FromJSON(SaveRows)
	s err=0
	TS
	for i=1:1:rows.%Size(){
		s row=rows.%Get(i-1)
		s ID=row.ID
		s SyndromeID=row.SyndromeID
		s Note=row.Note
		s ret=..SaveSyndrome(ItemID, SyndromeID, Note,UserID,ID)
		s err=$P(ret,"^",1)
		Q:err'=0
	}
	if err'=0 TRO
	else  TC
	Q err
}

ClassMethod SaveSyndrome(ItemID, SyndromeID, Note, UserID, ID = "")
{
	s iSyndromeID=SyndromeID
	s:iSyndromeID="" iSyndromeID=-100000000000000
	s FindID=$O(^User.MRCDiagFavSyndI("IndexItem",ItemID,iSyndromeID," "_$ZCVT(Note,"U"),0))
	Q:(FindID'="")&&(FindID'=ID) "证型项目重复^"_FindID
	LOCK ^DHCDocDiagFAVLOCK("Item",ItemID)
	k PLIST
	s PLIST(2)=ItemID
	s PLIST(3)=SyndromeID
	s PLIST(4)=Note
	s PLIST(6)=UserID
	if ID=""{
		s Sequece=$O(^User.MRCDiagFavSyndI("IndexSequece",ItemID,""),-1)+1
		s PLIST(5)=Sequece
		&SQL(INSERT INTO SQLUser.MRC_DiagFavSynd VALUES :PLIST())
	}else{
		&SQL(UPDATE SQLUser.MRC_DiagFavSynd VALUES :PLIST() WHERE ID=:ID)
	}
	LOCK -^DHCDocDiagFAVLOCK("Item",ItemID)
	Q:SQLCODE SQLCODE
	Q SQLCODE_"^"_%ROWID
}

/// w ##class(DHCDoc.Diagnos.Fav).UpdatSyndromeSeq(1,"[2,1]")
ClassMethod UpdatSyndromeSeq(ItemID, IDStr)
{
	LOCK ^DHCDocDiagFAVLOCK("Item",ItemID)
	TS
	&SQL(UPDATE SQLUser.MRC_DiagFavSynd SET Sequece=NULL WHERE ItemDR=:ItemID)
	s:SQLCODE=100 SQLCODE=0
	if 'SQLCODE{
		s IDArr=[].%FromJSON(IDStr)
		for i=1:1:IDArr.%Size(){
			s ID=IDArr.%Get(i-1)
			s:ID["_" ID=$P(ID,"_",$L(ID,"_"))
			&SQL(UPDATE SQLUser.MRC_DiagFavSynd SET Sequece=:i,ItemDR=:ItemID WHERE ID=:ID)
			Q:SQLCODE
		}
	}
	if SQLCODE TRO
	else  TC
	LOCK -^DHCDocDiagFAVLOCK("Item",ItemID)
	Q SQLCODE
}

ClassMethod DeleteSyndrome(ID)
{
	&SQL(DELETE FROM SQLUser.MRC_DiagFavSynd WHERE ID=:ID)
	Q SQLCODE
}

Query QueryCat(Type, LocID, UserID, CONTEXT = "") As %Query(ROWSPEC = "ID,Name")
{
}

ClassMethod QueryCatExecute(ByRef qHandle As %Binary, Type, LocID, UserID, CONTEXT = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s TypeObj=..GetCatTypeData(Type, LocID, UserID,CONTEXT)
	s CatType=TypeObj.CatType,TypeValue=TypeObj.TypeValue
	s iCatType=" "_$ZCVT(CatType,"U"),iTypeValue=" "_$ZCVT(TypeValue,"U")
	s Seq="" for{
		s Seq=$O(^User.MRCDiagFavCatI("IndexSequece",iCatType,iTypeValue,Seq)) Q:Seq=""
		s ID=0 for{
			s ID=$O(^User.MRCDiagFavCatI("IndexSequece",iCatType,iTypeValue,Seq,ID)) Q:ID=""
			s obj=##class(User.MRCDiagFavCat).%OpenId(ID)
			d rows.%Push($LB(ID,obj.Name))
		}
	}
	Quit $$$OK
}

ClassMethod QueryCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCatExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QueryItem(CatID, AllDiagFlag = "") As %Query(ROWSPEC = "ID,ICDRowid,ICDDesc,Note,Type,Prefix,SDSInfo")
{
}

ClassMethod QueryItemExecute(ByRef qHandle As %Binary, CatID, AllDiagFlag = "") As %Status
{
	s rows=[]
	Set langid=..%LanguageID()
	s qHandle=rows.%GetIterator()
	s SDSDiagEntry=##class(web.DHCDocDiagnosEntryV8).GetSDSDiagEntryFlag(%session.Data("LOGON.CTLOCID"))
	s rs=##class(%Library.ResultSet).%New()
    s SqlStr="SELECT ID,ICDDR,Note,Type,Prefix,SDSInfo FROM SQLUser.MRC_DiagFavItem "
			_"WHERE CatDR="_CatID_" AND (ICDDR IS NULL OR "
		  	_"(ICDDR->MRCID_DateActiveFrom IS NOT NULL AND ICDDR->MRCID_DateActiveFrom<=+$H "
		  	_"AND (ICDDR->MRCID_DateActiveTo IS NULL OR ICDDR->MRCID_DateActiveTo>+$H) "
		  	_"AND ICDDR->MRCID_Valid<>'N') "
		  _") ORDER BY Sequece"
	d rs.Prepare(SqlStr)
	d rs.Execute()
	while rs.Next(){
		s ID=rs.GetDataByName("ID")
		s ICDRowid=rs.GetDataByName("ICDDR")
		s Note=rs.GetDataByName("Note")
		s Type=rs.GetDataByName("Type")
		s Prefix=rs.GetDataByName("Prefix")
		s SDSInfo=rs.GetDataByName("SDSInfo")
		s SDSTermDR=$P(SDSInfo,"^",2)
		if SDSTermDR'=""{
			continue:'SDSDiagEntry&&(AllDiagFlag'="Y")
			s SDSDisplayIDStr=$P(SDSInfo,"^",3)
			s Supplement=$P(SDSInfo,"^",5)
			s ICDDesc=##class(web.DHCBL.MKB.SDSDiagnosFuseInterface).GetDisplayName(SDSTermDR,SDSDisplayIDStr,Supplement)
		}else{
			s ICDDesc=$P($G(^MRC("ID",+ICDRowid)),"^",2)
			s ICDDesc=##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc",ICDDesc,langid)
		}
		d rows.%Push($LB(ID,ICDRowid,ICDDesc,Note,Type,Prefix,SDSInfo))
	}
	Quit $$$OK
}

ClassMethod QueryItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItemExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QuerySyndromeNew(ItemID) As %Query(ROWSPEC = "ID,SyndromeID,SyndDesc,Note")
{
}

ClassMethod QuerySyndromeNewExecute(ByRef qHandle As %Binary, ItemID) As %Status
{
	s rows=[]
	Set langid=..%LanguageID()
	s qHandle=rows.%GetIterator()
	s rs=##class(%Library.ResultSet).%New()
    s SqlStr="SELECT ID,SyndromeDR,SyndromeDR->MRCID_Desc,Note FROM SQLUser.MRC_DiagFavSynd WHERE ItemDR="_ItemID_" ORDER BY Sequece"
	d rs.Prepare(SqlStr)
	d rs.Execute()
	while rs.Next(){
		s ID=rs.GetDataByName("ID")
		s SyndromeID=rs.GetDataByName("SyndromeDR")
		s SyndDesc=rs.GetDataByName("MRCID_Desc")
		s SyndDesc =##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc",SyndDesc,langid)
		s Note=rs.GetDataByName("Note")
		d rows.%Push($LB(ID,SyndromeID,SyndDesc,Note))
	}
	Quit $$$OK
}

ClassMethod QuerySyndromeNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySyndromeNewExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QuerySyndrome(ItemID) As %SQLQuery(ROWSPEC = "ID,SyndromeID,SyndDesc,Note")
{
	SELECT ID,SyndromeDR,SyndromeDR->MRCID_Desc,Note FROM SQLUser.MRC_DiagFavSynd WHERE ItemDR=:ItemID ORDER BY Sequece
}

/// w ##class(DHCDoc.Diagnos.Fav).CopyCat(5,"User.SSUser",95,10209)
ClassMethod CopyCat(FromCatID, Type, LocID, UserID, CONTEXT = "")
{
	s Name=$LG(^User.MRCDiagFavCatD(FromCatID),4)
	TS
	s ret=..SaveCat(Type, Name, LocID, UserID, CONTEXT)
	s err=$P(ret,"^",1)
	if err=0{
		s ToCatID=$P(ret,"^",2)
		s err=..CopyItem(FromCatID,ToCatID,UserID)
	}
	if err'=0 TRO
	else  TC
	Q err
}

ClassMethod CopyItem(FromCatID, ToCatID, UserID)
{
	s err=0
	s rs=##class(%ResultSet).%New("DHCDoc.Diagnos.Fav:QueryItem")
	d rs.Execute(FromCatID)
	TS
	while rs.Next(){
		s FromItemID=rs.GetDataByName("ID")
		s ICDRowid=rs.GetDataByName("ICDRowid")
		s Note=rs.GetDataByName("Note")
		s Type=rs.GetDataByName("Type")
		s Prefix=rs.GetDataByName("Prefix")
		s SDSInfo=rs.GetDataByName("SDSInfo")
		s ret=..SaveItem(ToCatID,ICDRowid,Note,Type,UserID,Prefix,SDSInfo)
		s err=$P(ret,"^",1)
		if err=0{
			s ToItemID=$P(ret,"^",2)
			s err=..CopySyndrome(FromItemID,ToItemID,UserID)
		}
		Q:err'=0
	}
	if err'=0 TRO
	else  TC
	Q err
}

ClassMethod CopySyndrome(FromItemID, ToItemID, UserID)
{
	s err=0
	TS
	s rs=##class(%ResultSet).%New("DHCDoc.Diagnos.Fav:QuerySyndrome")
	d rs.Execute(FromItemID)
	while rs.Next(){
		s SyndromeID=rs.GetDataByName("SyndromeID")
		s Note=rs.GetDataByName("Note")
		s ret=..SaveSyndrome(ToItemID,SyndromeID,Note,UserID)
		s err=$P(ret,"^",1)
		Q:err'=0
	}
	if err'=0 TRO
	else  TC
	Q err
}

ClassMethod GetFavTypeJSON(CONTEXT, LocID, UserID, EditMode = "")
{
	s FavTypeData=[
        {"text":"个人","id":"SSUser"},
        {"text":"科室","id":"CTLoc"}
    ]
    s FindFlag=0
    if EditMode'="Y"{	;非编辑模式找有模板的分类
	    for i=1:1:FavTypeData.%Size(){
		    s Type="User."_FavTypeData.%Get(i-1).id
			s TypeObj=..GetCatTypeData(Type,LocID,UserID,CONTEXT)
			s CatType=TypeObj.CatType,TypeValue=TypeObj.TypeValue
			s iCatType=" "_$ZCVT(CatType,"U"),iTypeValue=" "_$ZCVT(TypeValue,"U")
			if $D(^User.MRCDiagFavCatI("IndexName",iCatType,iTypeValue)){
				s FavTypeData.%Get(i-1).selected=1
				s FindFlag=1
				Q
			}
		}
	}
	s:'FindFlag FavTypeData.%Get(0).selected=1
	Q FavTypeData.%ToJSON()
}

/// 获取用户可以登录的科室列表并查询该科室是否有科室模板维护权限
ClassMethod GetUserLogLocs(UserID, HospID = "")
{
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s LocID=$P(^SSU("SSUSR",UserID),"^",4)
	s GroupID=$P(^SSU("SSUSR",UserID),"^",5)
	d OneLoc
	s OTHSub=0 for{
		s OTHSub=$O(^SSU("SSUSR",UserID,"OTHLL",OTHSub)) Q:OTHSub=""
		s EndDate=$P(^SSU("SSUSR",UserID,"OTHLL",OTHSub),"^",5)
		continue:(EndDate'="")&&(EndDate<=+$H)
		s LocID=$P(^SSU("SSUSR",UserID,"OTHLL",OTHSub),"^",1)
		s GroupID=$P(^SSU("SSUSR",UserID,"OTHLL",OTHSub),"^",2)
		d OneLoc
	}
	s retObj=[]
	s LocID=0 for{
		s LocID=$O(LocList(LocID)) Q:LocID=""
		s LocDesc=$P(^CTLOC(LocID),"^",2)
		d retObj.%Push({"id":(LocID),"text":(LocDesc),"AuthFlag":(LocList(LocID))})
	}
	Q retObj.%ToJSON()
OneLoc
	s LocHospID=$P($G(^CTLOC(+LocID)),"^",22)
	Q:HospID'=LocHospID
	Q:'##class(DHCDoc.DHCDocConfig.LocExt).LocActive(LocID)
	if $G(LocList(LocID))'=1{	;同一科室有多个安全组的情况,找到有权限的安全组即可
		s LocList(LocID)=..GetLocAuth(GroupID,LocHospID)
	}
	Q
}

/// d ##class(DHCDoc.Diagnos.Fav).ClearAllData()
ClassMethod ClearAllData()
{
	k ^User.MRCDiagFavSyndI,^User.MRCDiagFavSyndD
	k ^User.MRCDiagFavItemI,^User.MRCDiagFavItemD
	k ^User.MRCDiagFavCatI,^User.MRCDiagFavCatD
	Q 0
}

ClassMethod GetLocAuth(GroupID = "", HospID = "") As %Boolean
{
	s:GroupID="" GroupID=%session.Get("LOGON.GROUPID")
	s:HospID="" HospID=%session.Get("LOGON.HOSPID")
	Q +..%GetConfig1("DiagFavLocAuth",GroupID,HospID)
}

ClassMethod GetHospAuth(GroupID = "", HospID = "") As %Boolean
{
	s:GroupID="" GroupID=%session.Get("LOGON.GROUPID")
	s:HospID="" HospID=%session.Get("LOGON.HOSPID")
	Q +..%GetConfig1("DiagFavHospAuth",GroupID,HospID)
}

}
