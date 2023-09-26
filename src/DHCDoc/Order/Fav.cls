/// creator:王清雍
/// date:2021-03-26
/// desc:新医嘱模板前后台交互类
/// table:ARC_OrdFavCat(模板项目大类),ARC_OrdFavSubCat(模板项目子类),ARC_OrdFavItem(模板项目)
Class DHCDoc.Order.Fav Extends DHCDoc.Util.RegisteredObject
{

/// w ##class(DHCDoc.Order.Fav).GetFavData("User.SSUser","WNewOrderEntry",6,10209,1)
ClassMethod GetFavData(Type, CONTEXT, LocID, UserID, EpisodeID = "", OnlyCatNode = "", SearchAlias = "")
{
	s SearchAlias=$ZCVT(SearchAlias,"U")
	s FavStream=##class(%Stream.GlobalCharacter).%New()
	d ..GetFavCatJSON(Type,CONTEXT,LocID,UserID,EpisodeID,OnlyCatNode,SearchAlias).%ToJSON(.FavStream)
	d FavStream.OutputToDevice()
	Q ""
}

/// w ##class(DHCDoc.Order.Fav).GetFavCatJSON("User.SSUser","WNewOrderEntry",6,10209,1).%ToJSON()
ClassMethod GetFavCatJSON(Type, CONTEXT, LocID, UserID, EpisodeID = "", OnlyCatNode = "", SearchAlias = "") As %DynamicArray
{
	s rows=[]
	s TypeObj=..GetCatTypeData(Type, CONTEXT, LocID, UserID)
	s CatType=TypeObj.CatType,TypeValue=TypeObj.TypeValue
	s iCatType=" "_$ZCVT(CatType,"U"),iTypeValue=" "_$ZCVT(TypeValue,"U")
	s Seq="" for{
		s Seq=$O(^User.ARCOrdFavCatI("IndexSequece",iCatType,iTypeValue,Seq)) Q:Seq=""
		s ID=0 for{
			s ID=$O(^User.ARCOrdFavCatI("IndexSequece",iCatType,iTypeValue,Seq,ID)) Q:ID=""
			s CatDesc=$LG(^User.ARCOrdFavCatD(ID),4)
			s ContainFlag=(SearchAlias="")||($ZCVT(CatDesc,"U")[SearchAlias)
			if 'ContainFlag{
				s CatAlias=##class(ext.util.String).ToChineseSpell(CatDesc)
				s ContainFlag=CatAlias[SearchAlias
			}
			if ContainFlag{
				s SubData=..GetFavSubCatJSON(ID, EpisodeID,OnlyCatNode,"")
			}else{
				s SubData=..GetFavSubCatJSON(ID, EpisodeID,OnlyCatNode,SearchAlias)
			}
			continue:'ContainFlag&&'SubData.%Size()
			d rows.%Push({"id":(ID),"text":(CatDesc),"children":(SubData)})
		}
	}
	Q rows
}

/// w ##class(DHCDoc.Order.Fav).GetFavSubCatJSON(1,1).%ToJSON()
ClassMethod GetFavSubCatJSON(CatID, EpisodeID = "", OnlyCatNode = "", SearchAlias = "") As %DynamicArray
{
	s rows=[]
	s Seq="" for{
		s Seq=$O(^User.ARCOrdFavSubCatI("IndexSequece",CatID,Seq)) Q:Seq=""
		s ID=0 for{
			s ID=$O(^User.ARCOrdFavSubCatI("IndexSequece",CatID,Seq,ID)) Q:ID=""
			s SubCatDesc=$LG(^User.ARCOrdFavSubCatD(ID),3)
			s ContainFlag=(SearchAlias="")||($ZCVT(SubCatDesc,"U")[SearchAlias)
			if 'ContainFlag{
				s SubCatAlias=##class(ext.util.String).ToChineseSpell(SubCatDesc)
				s ContainFlag=SubCatAlias[SearchAlias
			}
			s obj={"id":(CatID_"_"_ID),"text":(SubCatDesc)}
			if OnlyCatNode'=1{
				if ContainFlag{
					s obj.children=..GetFavItemJSON(ID, EpisodeID,"")
				}else{
					s obj.children=..GetFavItemJSON(ID, EpisodeID,SearchAlias)
				}
				continue:'ContainFlag&&'obj.children.%Size()
			}else{
				continue:'ContainFlag
			}
			d rows.%Push(obj)
		}
	}
	Q rows
}

/// w ##class(DHCDoc.Order.Fav).GetFavItemJSON(1,1).%ToJSON()
ClassMethod GetFavItemJSON(SubCatID, EpisodeID = "", SearchAlias = "") As %DynamicArray
{
	s rows=[]
	s CatID=$LG(^User.ARCOrdFavSubCatD(SubCatID),2)
	s IDPrefix=CatID_"_"_SubCatID_"_"
	s Seq="" for{
		s Seq=$O(^User.ARCOrdFavItemI("IndexSequece",SubCatID,Seq)) Q:Seq=""
		s ID=0 for{
			s ID=$O(^User.ARCOrdFavItemI("IndexSequece",SubCatID,Seq,ID)) Q:ID=""
			if SearchAlias'=""{
				s ItemID=$LG(^User.ARCOrdFavItemD(ID),3)
				continue:'##class(web.DHCDocMain).MatchAlias(ItemID,SearchAlias)
			}
			s obj=..GetOneFavItemJSON(ID,EpisodeID)
			continue:'obj.%Size()
			d rows.%Push(obj)
		}
	}
	Q rows
}

ClassMethod GetOneFavItemJSON(ID, EpisodeID = "")
{
	s retObj={}
	Set langid=..%LanguageID()
	s ItemID=$LG(^User.ARCOrdFavItemD(ID),3)
	s ItemType=$SELECT(ItemID["||":"ARCIM",1:"ARCOS")
	Q:(ItemType="ARCIM")&&(##class(web.DHCDocOrderEntry).ValARCItem(ItemID)'=0) retObj
	Q:(ItemType="ARCOS")&&(##class(web.DHCDocOrderEntry).ValARCOS(ItemID)'=0) retObj
	s desc=$SELECT(ItemType="ARCIM":$P($G(^ARCIM(+ItemID,1,1)),"^",2),1:$P($G(^ARCOS(+ItemID)),"^",2))
	Q:desc="" retObj
	i ItemType="ARCIM" s desc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",desc,langid)
	s SubCatID=$LG(^User.ARCOrdFavItemD(ID),2)
	s CatID=$LG(^User.ARCOrdFavSubCatD(SubCatID),2)
	s itemNotes=$TR($LG(^User.ARCOrdFavItemD(ID),6),$C(0))
	s PartInfo=$TR($LG(^User.ARCOrdFavItemD(ID),7),$C(0))
	s OrderType=""
	if ItemType="ARCIM"{
		s ItemCatRowid=$p($g(^ARCIM(+ItemID,$p(ItemID,"||",2),1)),"^",10)
		s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
	}
	s retObj={"id":(CatID_"_"_SubCatID_"_"_ID),"text":(desc),"iconCls":(..GetItemIconCls(ItemID)),"attributes":{}}
	s retObj.attributes.itemid=ItemID
	s retObj.attributes.stock=$SELECT((EpisodeID'="")&&(OrderType="R"):##Class(web.DHCDocOrderEntry).GetRealStock(EpisodeID,ItemID),1:1)
	s retObj.attributes.note=itemNotes
	s retObj.attributes.partDesc=##Class(web.DHCAPPExaReportQuery).GetPartLabel(PartInfo)
	s retObj.attributes.partInfo=PartInfo
	Q retObj
}

ClassMethod GetItemIconCls(ItemID)
{
	Q:ItemID'["||" "icon-paper-group"
	s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(ItemID)
	if PoisonRowid'=""{
		s PoisonCode=$P(^PHCPO(PoisonRowid),"^",1)
		Q:" MZ J1 DX DM "[(" "_PoisonCode_" ") "icon-drug-audit"
		Q:PoisonCode["KSS" "icon-virus-drug"
	}
	Q:##class(DHCDoc.DHCDocCure.Apply).GetCureItemFlag(ItemID) "icon-nail"
	s ItemCatRowid=$p($g(^ARCIM(+ItemID,$p(ItemID,"||",2),1)),"^",10)
	s ItemCat=$P(^ARC("IC",ItemCatRowid),"^",2)
	Q:ItemCat["处置" "icon-injector-water"
	s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
	Q $CASE(OrderType,"R":"icon-drug","L":"icon-tube","X":"icon-analysis","M":"icon-edit",:"")
}

ClassMethod SaveTreeNode(InputStr)
{
	s InputObj={}.%FromJSON(InputStr)
	s ParID=InputObj.ParID,ID=InputObj.ID
	s:(ParID="")&&(ID'="") ParID=$P(ID,"_",1,$L(ID,"_")-1)
	s level=$CASE(ParID,"":1,:$L(ParID,"_")+1)
	s ParID=$P(ParID,"_",$L(ParID,"_")),ID=$P(ID,"_",$L(ID,"_"))
	if level=1{
		s ret=..SaveCat(InputObj.Type,InputObj.CONTEXT,InputObj.Value,InputObj.LocID, InputObj.UserID,ID)
	}elseif level=2{
		s ret=..SaveSubCat(ParID,InputObj.Value,InputObj.UserID,ID)
	}elseif level=3{
		s ret=..SaveItem(ParID,InputObj.Value,InputObj.UserID,ID,InputObj.Note,InputObj.PartInfo)
	}else{
		s ret=-1
	}
	if $P(ret,"^")=0{
		s RetObj={"code":0,"msg":"保存成功"}
		s ID=$P(ret,"^",2)
		if level=1{
			s RetObj.data={"id":(ID),"text":($LG(^User.ARCOrdFavCatD(ID),4))}
		}elseif level=2{
			s CatID=$LG(^User.ARCOrdFavSubCatD(ID),2)
			s RetObj.data={"id":(CatID_"_"_ID),"text":($LG(^User.ARCOrdFavSubCatD(ID),3))}
		}elseif level=3{
			s RetObj.data=..GetOneFavItemJSON(ID,InputObj.EpisodeID)
			
		}
	}else{
		s RetObj={"code":(ret),"msg":("保存失败:"_ret)}
	}
	Q RetObj.%ToJSON()
}

/// w ##class(DHCDoc.Order.Fav).UpdateTreeSeq(3,"[""1_1""]")
ClassMethod UpdateTreeSeq(ParNodeID, IDStr)
{
	s ParIDLen=$CASE(ParNodeID,"":0,:$L(ParNodeID,"_"))
	s ParID=$P(ParNodeID,"_",ParIDLen)
	Q $CASE(ParIDLen,0:..UpdateCatSeq(IDStr),1:..UpdateSubCatSeq(ParID,IDStr),2:..UpdatItemSeq(ParID,IDStr),:100)
}

/// w ##class(DHCDoc.Order.Fav).SaveCat("User.SSUser","WNewOrderEntry","分类1",6,10209,1)
ClassMethod SaveCat(Type, CONTEXT, Name, LocID, UserID, ID = "", HospID = "")
{
	s TypeObj=..GetCatTypeData(Type, CONTEXT, LocID, UserID,HospID)
	s CatType=TypeObj.CatType,TypeValue=TypeObj.TypeValue
	Q:Name="" "分类名称不能为空"
	s FindID=$O(^User.ARCOrdFavCatI("IndexName"," "_$ZCVT(CatType,"U")," "_$ZCVT(TypeValue,"U")," "_$ZCVT(Name,"U"),0))
	Q:(FindID'="")&&(FindID'=ID) "分类名称重复"
	LOCK ^DHCDocOrdFAVLOCK(CatType,TypeValue)
	k PLIST
	s PLIST(2)=CatType
	s PLIST(3)=TypeValue
	s PLIST(4)=Name
	s PLIST(6)=UserID
	if ID=""{
		s Sequece=$O(^User.ARCOrdFavCatI("IndexSequece"," "_$ZCVT(CatType,"U")," "_$ZCVT(TypeValue,"U"),""),-1)+1
		s PLIST(5)=Sequece
		s OldDataJson="",OprType="A"
		&SQL(INSERT INTO SQLUser.ARC_OrdFavCat VALUES :PLIST())
	}else{
		s OprType="U"
		s OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.ARCOrdFavCat"_$c(2)_ID)
		&SQL(UPDATE SQLUser.ARC_OrdFavCat VALUES :PLIST() WHERE ID=:ID)
	}
	LOCK -^DHCDocOrdFAVLOCK(CatType,TypeValue)
	Q:SQLCODE SQLCODE
	s NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.ARCOrdFavCat"_$c(2)_%ROWID)
	s ret=##class(web.DHCDocDataChangeLog).SaveLog("ARC_OrdFavCat","User.ARCOrdFavCat","医嘱模板大类","User.ARCOrdFavCat_"_%ROWID,%ROWID,OprType,NewDataJson,OldDataJson,UserID)
	Q SQLCODE_"^"_%ROWID
}

/// w ##class(DHCDoc.Order.Fav).UpdateCatSeq("[2,1]")
ClassMethod UpdateCatSeq(IDStr)
{
	s IDArr=[].%FromJSON(IDStr)
	s CatType=$LG(^User.ARCOrdFavCatD(IDArr.%Get(0)),2)
	s TypeValue=$LG(^User.ARCOrdFavCatD(IDArr.%Get(0)),3)
	LOCK ^DHCDocOrdFAVLOCK(CatType,TypeValue)
	TS
	for i=1:1:IDArr.%Size(){
		s ID=IDArr.%Get(i-1)
		&SQL(UPDATE SQLUser.ARC_OrdFavCat SET Sequece=NULL WHERE ID=:ID)
		s:SQLCODE=100 SQLCODE=0
		Q:SQLCODE
	}
	if 'SQLCODE{
		for i=1:1:IDArr.%Size(){
			s ID=IDArr.%Get(i-1)
			&SQL(UPDATE SQLUser.ARC_OrdFavCat SET Sequece=:i WHERE ID=:ID)
			Q:SQLCODE
		}
	}
	if SQLCODE TRO
	else  TC
	LOCK -^DHCDocOrdFAVLOCK(CatType,TypeValue)
	Q SQLCODE
}

ClassMethod GetCatTypeData(Type, CONTEXT, LocID, UserID, HospID = "") As %DynamicObject
{
	Q {"CatType":(..GetCatType(Type, CONTEXT, LocID,HospID)),"TypeValue":($CASE(Type,"User.SSUser":UserID,"User.CTLoc":LocID,"User.CTHospital":$P(^CTLOC(LocID),"^",22)))}
}

ClassMethod GetCatType(Type, CONTEXT, LocID, HospID = "")
{
	s CatType=Type_"|"_CONTEXT
	if (Type="User.SSUser"){
		s:(HospID="")&&(LocID'="") HospID=$P(^CTLOC(LocID),"^",22)
		if HospID'=""{
			;个人模板增加院区标识区分
			s CatType=CatType_"|"_HospID
			s SepPrefTypeByLoc=##class(web.DHCDocConfig).GetConfigNode("SepPrefTypeByLoc",HospID)
			if SepPrefTypeByLoc=1{
				s CatType=CatType_"|"_##class(DHCDoc.Order.Common).GetLocAdmType(LocID)
			}
		}
	}
	Q CatType
}

/// 获取大类院区ID
ClassMethod GetCatHospID(CatID)
{
	Q:'$D(^User.ARCOrdFavCatD(CatID)) ""
	s CatType=$LG(^User.ARCOrdFavCatD(CatID),2)
	s CatTypeValue=$LG(^User.ARCOrdFavCatD(CatID),3)
	s Type=$P(CatType,"|",1)
	s HospID=$CASE(Type,"User.SSUser":$P(CatType,"|",3),"User.CTLoc":$P(^CTLOC(CatTypeValue),"^",22),"User.CTHospital":CatTypeValue,:"")
	s:+HospID=0 HospID=""
	Q HospID
}

/// w ##class(DHCDoc.Order.Fav).SaveSubCat(1,"子类0",10209,1)
ClassMethod SaveSubCat(CatID, Name, UserID, ID = "")
{
	s:ID["_" ID=$P(ID,"_",$L(ID,"_"))
	Q:Name="" "子分类名称不能为空"
	s FindID=$O(^User.ARCOrdFavSubCatI("IndexName",CatID," "_$ZCVT(Name,"U"),0))
	Q:(FindID'="")&&(FindID'=ID) "子分类名称重复"
	LOCK ^DHCDocOrdFAVLOCK("Cat",CatID)
	k PLIST
	s PLIST(2)=CatID
	s PLIST(3)=Name
	s PLIST(5)=UserID
	if ID=""{
		s Sequece=$O(^User.ARCOrdFavSubCatI("IndexSequece",CatID,""),-1)+1
		s PLIST(4)=Sequece
		s OldDataJson="",OprType="A"
		&SQL(INSERT INTO SQLUser.ARC_OrdFavSubCat VALUES :PLIST())
	}else{
		s OprType="U"
		s OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.ARCOrdFavSubCat"_$c(2)_ID)
		&SQL(UPDATE SQLUser.ARC_OrdFavSubCat VALUES :PLIST() WHERE ID=:ID)
	}
	LOCK -^DHCDocOrdFAVLOCK("Cat",CatID)
	Q:SQLCODE SQLCODE
	s NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.ARCOrdFavSubCat"_$c(2)_%ROWID)
	s ret=##class(web.DHCDocDataChangeLog).SaveLog("ARC_OrdFavSubCat","User.ARCOrdFavSubCat","医嘱模板子类","User.ARCOrdFavSubCat_"_%ROWID,%ROWID,OprType,NewDataJson,OldDataJson,UserID)
	Q SQLCODE_"^"_%ROWID
}

/// w ##class(DHCDoc.Order.Fav).UpdateSubCatSeq(1,"[2,1]")
ClassMethod UpdateSubCatSeq(CatID, IDStr)
{
	LOCK ^DHCDocOrdFAVLOCK("Cat",CatID)
	TS
	&SQL(UPDATE SQLUser.ARC_OrdFavSubCat SET Sequece=NULL WHERE CatDR=:CatID)
	s:SQLCODE=100 SQLCODE=0
	if 'SQLCODE{
		s IDArr=[].%FromJSON(IDStr)
		for i=1:1:IDArr.%Size(){
			s ID=IDArr.%Get(i-1)
			s:ID["_" ID=$P(ID,"_",$L(ID,"_"))
			&SQL(UPDATE SQLUser.ARC_OrdFavSubCat SET Sequece=:i,CatDR=:CatID WHERE ID=:ID)
			Q:SQLCODE
		}
	}
	if SQLCODE TRO
	else  TC
	LOCK -^DHCDocOrdFAVLOCK("Cat",CatID)
	Q SQLCODE
}

/// w ##class(DHCDoc.Order.Fav).SaveItem(1,"2||1",10209,"")
ClassMethod SaveItem(SubCatID, ItemID, UserID, ID = "", Note = "", PartInfo = "")
{
	Q:ItemID="" "项目不能为空"
	s FindID=$O(^User.ARCOrdFavItemI("IndexItem",SubCatID," "_$ZCVT(ItemID,"U")," "_$ZCVT(PartInfo,"U"),0))
	Q:(FindID'="")&&(FindID'=ID) "项目重复"
	LOCK ^DHCDocOrdFAVLOCK("SubCat",SubCatID)
	k PLIST
	s PLIST(2)=SubCatID
	s PLIST(3)=ItemID
	s PLIST(5)=UserID
	s PLIST(6)=Note
	s PLIST(7)=PartInfo
	if ID=""{
		s Sequece=$O(^User.ARCOrdFavItemI("IndexSequece",SubCatID,""),-1)+1
		s PLIST(4)=Sequece
		s OldDataJson="",OprType="A"
		&SQL(INSERT INTO SQLUser.ARC_OrdFavItem VALUES :PLIST())
	}else{
		s OprType="U"
		s OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.ARCOrdFavItem"_$c(2)_ID)
		&SQL(UPDATE SQLUser.ARC_OrdFavItem VALUES :PLIST() WHERE ID=:ID)
	}
	LOCK -^DHCDocOrdFAVLOCK("SubCat",SubCatID)
	Q:SQLCODE SQLCODE
	s NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.ARCOrdFavItem"_$c(2)_%ROWID)
	s ret=##class(web.DHCDocDataChangeLog).SaveLog("ARC_OrdFavItem","User.ARCOrdFavItem","医嘱模板项目","User.ARCOrdFavItem_"_%ROWID,%ROWID,OprType,NewDataJson,OldDataJson,UserID)
	Q SQLCODE_"^"_%ROWID
}

/// w ##class(DHCDoc.Order.Fav).UpdatItemSeq($LG(^Wqy("UpdatItemSeq"),1),$LG(^Wqy("UpdatItemSeq"),2))
ClassMethod UpdatItemSeq(SubCatID, IDStr)
{
	s ^Wqy("UpdatItemSeq")=$LB(SubCatID, IDStr)
	LOCK ^DHCDocOrdFAVLOCK("SubCat",SubCatID)
	TS
	&SQL(UPDATE SQLUser.ARC_OrdFavItem SET Sequece=NULL WHERE SubCatDR=:SubCatID)
	s:SQLCODE=100 SQLCODE=0
	if 'SQLCODE{
		s IDArr=[].%FromJSON(IDStr)
		for i=1:1:IDArr.%Size(){
			s ID=IDArr.%Get(i-1)
			s:ID["_" ID=$P(ID,"_",$L(ID,"_"))
			continue:'$D(^User.ARCOrdFavItemD(ID))
			;没有校验到唯一索引IndexItem? 手动验证一下
			s ItemID=$LG(^User.ARCOrdFavItemD(ID),3)
			s PartInfo=$LG(^User.ARCOrdFavItemD(ID),7)
			s FindID=$O(^User.ARCOrdFavItemI("IndexItem",SubCatID," "_ItemID," "_PartInfo,0))
			if (FindID'="")&&(FindID'=ID){
				s SQLCODE="该子分类已存在该项目"
				Q
			}
			&SQL(UPDATE SQLUser.ARC_OrdFavItem SET Sequece=:i,SubCatDR=:SubCatID WHERE ID=:ID)
			Q:SQLCODE
		}
	}
	if SQLCODE TRO
	else  TC
	LOCK -^DHCDocOrdFAVLOCK("SubCat",SubCatID)
	Q SQLCODE
}

ClassMethod DeleteTreeNode(Nodes)
{
	s ret=0
	i Nodes'["[" s Nodes=[(Nodes)]
	e  s Nodes=[].%FromJSON(Nodes)
	TS
	for i=1:1:Nodes.%Size(){
		s NodeID=Nodes.%Get(i-1)
		s IDLen=$L(NodeID,"_")
		s ID=$P(NodeID,"_",IDLen)
		s ret=$CASE(IDLen,1:..DeleteCat(ID),2:..DeleteSubCat(ID),3:..DeleteItem(ID),:100)
		Q:ret
	}
	if ret TRO
	else  TC
	Q ret
}

ClassMethod DeleteCat(ID)
{
	s:ID["_" ID=$P(ID,"_",1)
	s SQLCODE=0
	s OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.ARCOrdFavCat"_$c(2)_ID)
	TS
	s SubCat="" for{
		s SubCat=$O(^User.ARCOrdFavSubCatI("IndexName",ID,SubCat)) Q:SubCat=""
		s SubCatID=0 for{
			s SubCatID=$O(^User.ARCOrdFavSubCatI("IndexName",ID,SubCat,SubCatID)) Q:SubCatID=""
			s SQLCODE=..DeleteSubCat(SubCatID)
		}
	}
	if 'SQLCODE{
		&SQL(DELETE FROM SQLUser.ARC_OrdFavCat WHERE ID=:ID)
	}
	s:SQLCODE=100 SQLCODE=0
	if SQLCODE TRO
	else  TC
	if 'SQLCODE{
		s ret=##class(web.DHCDocDataChangeLog).SaveLog("ARC_OrdFavCat","User.ARCOrdFavCat","医嘱模板大类","User.ARCOrdFavCat_"_ID,ID,"D","",OldDataJson)
	}
	Q SQLCODE
}

ClassMethod DeleteSubCat(ID)
{
	s:ID["_" ID=$P(ID,"_",2)
	s OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.ARCOrdFavSubCat"_$c(2)_ID)
	s SQLCODE=0
	TS
	s FavItemID="" for{
		s FavItemID=$O(^User.ARCOrdFavItemI("IndexItem",ID,FavItemID)) Q:FavItemID=""
		s PartInfo="" for{
			s PartInfo=$O(^User.ARCOrdFavItemI("IndexItem",ID,FavItemID,PartInfo)) Q:PartInfo=""
			s ItemID=0 for{
				s ItemID=$O(^User.ARCOrdFavItemI("IndexItem",ID,FavItemID,PartInfo,ItemID)) Q:ItemID=""
				s SQLCODE=..DeleteItem(ItemID)
			}
		}
	}
	if 'SQLCODE{
		&SQL(DELETE FROM SQLUser.ARC_OrdFavSubCat WHERE ID=:ID)
	}
	s:SQLCODE=100 SQLCODE=0
	if SQLCODE TRO
	else  TC
	if 'SQLCODE{
		s ret=##class(web.DHCDocDataChangeLog).SaveLog("ARC_OrdFavSubCat","User.ARCOrdFavSubCat","医嘱模板子类","User.ARCOrdFavSubCat_"_ID,ID,"D","",OldDataJson)
	}
	Q SQLCODE
}

ClassMethod DeleteItem(ID)
{
	s:ID["_" ID=$P(ID,"_",3)
	s OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.ARCOrdFavItem"_$c(2)_ID)
	&SQL(DELETE FROM SQLUser.ARC_OrdFavItem WHERE ID=:ID)
	s:SQLCODE=100 SQLCODE=0
	if 'SQLCODE{
		s ret=##class(web.DHCDocDataChangeLog).SaveLog("ARC_OrdFavItem","User.ARCOrdFavItem","医嘱模板项目","User.ARCOrdFavItem_"_ID,ID,"D","",OldDataJson)
	}
	Q SQLCODE
}

/// w ##class(DHCDoc.Order.Fav).CopyTreeNode($LG(^Wqy("CopyTreeNode"),1),$LG(^Wqy("CopyTreeNode"),2),$LG(^Wqy("CopyTreeNode"),3),$LG(^Wqy("CopyTreeNode"),4),$LG(^Wqy("CopyTreeNode"),5),$LG(^Wqy("CopyTreeNode"),6))
ClassMethod CopyTreeNode(FromNodeID, ToNodeID, Type, CONTEXT, LocID, UserID)
{
	;s ^Wqy("CopyTreeNode")=$LB(FromNodeID, ToNodeID, Type, CONTEXT, LocID, UserID)
	s ret=0
	if FromNodeID["["{
		s FromNodeIDArr=[].%FromJSON(FromNodeID)
		TS
		for i=1:1:FromNodeIDArr.%Size(){
			s FromNodeID=FromNodeIDArr.%Get(i-1)
			s ret=..CopyOneNode(FromNodeID, ToNodeID, Type, CONTEXT, LocID, UserID)
			Q:+ret
		}
		if +ret TRO
		else  TC
	}else{
		s ret=..CopyOneNode(FromNodeID, ToNodeID, Type, CONTEXT, LocID, UserID)
	}
	Q ret
}

ClassMethod CopyOneNode(FromNodeID, ToNodeID, Type, CONTEXT, LocID, UserID)
{
	s FromCatID=$P(FromNodeID,"_",1),FromSubCatID=$P(FromNodeID,"_",2),FromItemID=$P(FromNodeID,"_",3)
	s ToCatID=$P(ToNodeID,"_",1),ToSubCatID=$P(ToNodeID,"_",2)
	if FromItemID'=""{
		Q:ToSubCatID="" "请选择复制目标的子类"
		Q ..CopyItem(FromItemID, ToSubCatID, UserID)	
	}
	if FromSubCatID'=""{
		Q:ToCatID="" "请选择复制目标的大类"
		Q ..CopySubCat(FromSubCatID, ToCatID, UserID)	
	}
	if FromCatID'=""{
		Q ..CopyCat(FromCatID,Type,CONTEXT,LocID,UserID)
	}
	Q 100
}

ClassMethod CopyCat(FromCatID, Type, CONTEXT, LocID, UserID)
{
	s ret=0
	s CatName=$LG(^User.ARCOrdFavCatD(FromCatID),4)
	s TypeObj=..GetCatTypeData(Type, CONTEXT, LocID, UserID)
	s CatType=TypeObj.CatType,TypeValue=TypeObj.TypeValue
	s ToCatID=$O(^User.ARCOrdFavCatI("IndexName"," "_$ZCVT(CatType,"U")," "_$ZCVT(TypeValue,"U")," "_$ZCVT(CatName,"U"),0))
	TS
	if ToCatID=""{
		s ret=..SaveCat(Type,CONTEXT,CatName,LocID,UserID)
		if $P(ret,"^")=0{
			s ToCatID=$P(ret,"^",2)
		}
		s ret=$P(ret,"^")
	}
	if ToCatID'=""{
		s Seq="" for{
			s Seq=$O(^User.ARCOrdFavSubCatI("IndexSequece",FromCatID,Seq)) Q:Seq=""
			s SubCatID=0 for{
				s SubCatID=$O(^User.ARCOrdFavSubCatI("IndexSequece",FromCatID,Seq,SubCatID)) Q:SubCatID=""
				s ret=..CopySubCat(SubCatID, ToCatID, UserID)
				s ret=$P(ret,"^")
				Q:ret'=0
			}
		}
	}
	if ret TRO
	else  TC
	Q ret
}

ClassMethod CopySubCat(FromSubCatID, ToCatID, UserID)
{
	s SubCat=$LG(^User.ARCOrdFavSubCatD(FromSubCatID),3)
	s ToSubCatID=$O(^User.ARCOrdFavSubCatI("IndexName",ToCatID," "_$ZCVT(SubCat,"U"),0))
	if ToSubCatID=""{
		s ret=..SaveSubCat(ToCatID, SubCat, UserID)
		if $P(ret,"^")=0{
			s ToSubCatID=$P(ret,"^",2)
		}
	}
	Q:ToSubCatID="" -1
	s Seq="" for{
		s Seq=$O(^User.ARCOrdFavItemI("IndexSequece",FromSubCatID,Seq)) Q:Seq=""
		s ItemID=0 for{
			s ItemID=$O(^User.ARCOrdFavItemI("IndexSequece",FromSubCatID,Seq,ItemID)) Q:ItemID=""
			d ..CopyItem(ItemID,ToSubCatID,UserID)
		}
	}
	Q 0
}

ClassMethod CopyItem(FromItemID, ToSubCatID, UserID)
{
	s FavItemID=$LG(^User.ARCOrdFavItemD(FromItemID),3)
	s Note=$LG(^User.ARCOrdFavItemD(FromItemID),6)
	s PartInfo=$LG(^User.ARCOrdFavItemD(FromItemID),7)
	Q $P(..SaveItem(ToSubCatID, FavItemID, UserID,"",Note,PartInfo),"^")
}

ClassMethod InsertMultItem(SubCatID, FavItemStr, UserID)
{
	s:SubCatID["_" SubCatID=$P(SubCatID,"_",2)
	Q:SubCatID="" "子类不能为空"
	s FavItemArr=[].%FromJSON(FavItemStr)
	Q:'FavItemArr.%Size() "项目不能为空"
	s SuccessCount=0,FailCount=0
	s ret=""
	for i=1:1:FavItemArr.%Size(){
		s FavItem=FavItemArr.%Get(i-1)
		continue:FavItem.itemid=""
		s ret=..SaveItem(SubCatID, FavItem.itemid, UserID,"",FavItem.note,FavItem.partInfo)
		if $P(ret,"^")=0{
			s SuccessCount=SuccessCount+1
		}else{
			s FailCount=FailCount+1
		}
	}
	Q:'SuccessCount ret
	Q 0
}

ClassMethod UpdateItemNode(ItemIDStr, Note)
{
	s SQLCODE=0
	TS
	s ItemIDArr=[].%FromJSON(ItemIDStr)
	for i=1:1:ItemIDArr.%Size(){
		s ID=ItemIDArr.%Get(i-1)
		s:ID["_" ID=$P(ID,"_",3)
		&SQL(UPDATE SQLUser.ARC_OrdFavItem SET Note=:Note WHERE ID=:ID)
		Q:SQLCODE
	}
	if SQLCODE TRO
	else  TC
	Q SQLCODE
}

ClassMethod GetFavTypeJSON(CONTEXT, LocID, UserID, EditMode = "")
{
	s FavTypeData=[
        {"text":"个人","id":"SSUser"},
        {"text":"科室","id":"CTLoc"},
        {"text":"全院","id":"CTHospital"}
    ]
    s FindFlag=0
    if EditMode'="Y"{	;非编辑模式找有模板的分类
	    for i=1:1:FavTypeData.%Size(){
		    s Type="User."_FavTypeData.%Get(i-1).id
			s TypeObj=..GetCatTypeData(Type, CONTEXT, LocID, UserID)
			s CatType=TypeObj.CatType,TypeValue=TypeObj.TypeValue
			s iCatType=" "_$ZCVT(CatType,"U"),iTypeValue=" "_$ZCVT(TypeValue,"U")
			if $D(^User.ARCOrdFavCatI("IndexName",iCatType,iTypeValue)){
				s FavTypeData.%Get(i-1).selected=1
				s FindFlag=1
				Q
			}
		}
	}
	s:'FindFlag FavTypeData.%Get(0).selected=1
	Q FavTypeData.%ToJSON()
}

/// d ##class(DHCDoc.Order.Fav).ClearAllData()
ClassMethod ClearAllData()
{
	k ^User.ARCOrdFavItemI,^User.ARCOrdFavItemD
	k ^User.ARCOrdFavSubCatI,^User.ARCOrdFavSubCatD
	k ^User.ARCOrdFavCatI,^User.ARCOrdFavCatD
	Q 0
}

/// 把老模板数据(websys.Preferences)导入到新模板表中
/// d ##class(DHCDoc.Order.Fav).ImportOldToNew()
ClassMethod ImportOldToNew()
{
	w "开始导入...",!
	s AppSubKey="OEOrder.PrefTabs.EditList"
	for objtype="User.CTLoc","User.SSUser"{
		s objvalue=0 for{
			s objvalue=$O(^websys.PreferencesI("Index",objtype,objvalue)) Q:objvalue=""
			i objtype="User.CTLoc" s UserID="",LocID=objvalue,objDesc=$P($G(^CTLOC(objvalue)),"^",2)
			e  s UserID=objvalue,LocID=$P($G(^SSU("SSUSR",objvalue)),"^",4),objDesc=$P($G(^SSU("SSUSR",objvalue)),"^",2)
			w objDesc,":",!
			s Appkey="ORDER" for{
				s Appkey=$O(^websys.PreferencesI("Index",objtype,objvalue,Appkey)) Q:(Appkey="")||($E(Appkey,1,5)'="ORDER")
				s CONTEXT=$P(Appkey,"ORDER",2)
				s CONTEXT=$SELECT(CONTEXT["WNewOrderEntry":"WNewOrderEntry",CONTEXT["W50007":"W50007",1:"")
				s HospID=+$P(Appkey,"HospDr",2)
				s:HospID=0 HospID=""
				s ID=0 for{
					s ID=$O(^websys.PreferencesI("Index",objtype,objvalue,Appkey,AppSubKey,ID)) Q:ID=""
					d OnePreference
				}
			}
		}
	}
	w "导入完成!"
	Q
OnePreference
	s Data=$LG(^websys.PreferencesD(ID),3)
	s CatList=$LG(Data,3)
	s CatLen=$LL(CatList)
	k DataList
	for i=1:1:CatLen{
		s CatData=$LG(CatList,i)
		d OneCat	
	}
	if $D(DataList){
		s i=0 for{
			s i=$O(DataList(i)) Q:i=""
			s Cat=DataList(i)
			s CatID=""
			s TypeObj=..GetCatTypeData(objtype, CONTEXT, LocID, UserID,HospID)
			s CatType=TypeObj.CatType,TypeValue=TypeObj.TypeValue
			&SQL(SELECT ID INTO :CatID FROM SQLUser.ARC_OrdFavCat WHERE Type=:CatType AND TypeValue=:TypeValue AND Name=:Cat)
			if CatID=""{
				s ret=..SaveCat(objtype,CONTEXT,Cat,LocID,UserID,CatID,HospID)
				if $P(ret,"^",1)'=0{
					w Cat,":",ret,!
					continue
				}
				s CatID=$P(ret,"^",2)
			}
			s j=0 for{
				s j=$O(DataList(i,j)) Q:j=""
				s SubCat=DataList(i,j)
				s SubCatID=""
				&SQL(SELECT ID INTO :SubCatID FROM SQLUser.ARC_OrdFavSubCat WHERE CatDR=:CatID AND Name=:SubCat)
				if SubCatID=""{
					s ret=..SaveSubCat(CatID,SubCat,UserID,SubCatID)
					if $P(ret,"^",1)'=0{
						w Cat,"-",SubCatID,":",ret,!
						continue
					}
					s SubCatID=$P(ret,"^",2)
				}
				s k=0 for{
					s k=$O(DataList(i,j,k)) Q:k=""
					s ItemID=$LG(DataList(i,j,k),1)
					s PatInfo=$LG(DataList(i,j,k),2)
					s Note=$LG(DataList(i,j,k),3)
					s ret=..SaveItem(SubCatID,ItemID,UserID,"",Note,PatInfo)
					if $P(ret,"^",1)'=0{
						w Cat,"-",SubCatID,"-",ItemID,":",ret,!
					}
				}
			}
		}
	}
	Q
OneCat
	s Cat=$P(CatData,$C(1),1)
	k SubCatList
	for j=2:1:$L(CatData,$C(1)){
		s SubCatData=$P(CatData,$C(1),j)
		d OneSubCat
	}
	if $D(SubCatList){
		s:Cat="" Cat=i
		s SubCatList=Cat
		m DataList($I(DataList))=SubCatList
	}
	Q
OneSubCat
	s SubCat=$P(SubCatData,$C(28),1)
	k ItemList
	for k=2:1:$L(SubCatData,$C(28)){
		s ItemData=$P(SubCatData,$C(28),k)
		d OneItem
	}
	if $D(ItemList){
		s:SubCat="" SubCat=j-1
		s ItemList=SubCat
		m SubCatList($I(SubCatList))=ItemList
	}
	Q
OneItem
	s ItemIDInfo=$P(ItemData,$C(4),2)
	s ItemID=$P(ItemIDInfo,"*",1)
	Q:ItemID=""
	s PatInfo=$P(ItemIDInfo,"*",3,$L(ItemIDInfo,"*"))
	s Note=$P(ItemData,$C(4),3)
	s ItemList($I(ItemList))=$LB(ItemID,PatInfo,Note)
	Q
}

ClassMethod InsertByOrdItems(SubCatID, OrdItemIDStr, UserID, LogonHospID = "")
{
	;s ^Wqy("OrdFav","InsertByOrdItems")=$LB(SubCatID, OrdItemIDStr, UserID, LogonHospID)
	s:SubCatID["_" SubCatID=$P(SubCatID,"_",2)
	Q:SubCatID="" "子类不能为空"
	d ##class(web.DHCDocInPatPortalCommon).OrdItemIDStrToList(OrdItemIDStr,LogonHospID,.OrdList)
	Q:'$D(OrdList) "医嘱不能为空"
	s SuccessCount=0,FailCount=0
	s ret=""
	s OrdItemID="" for{
		s OrdItemID=$O(OrdList(OrdItemID)) Q:OrdItemID=""
		s CMFlag=##class(DHCDoc.Order.Common).IsCNOrdItem(OrdItemID,LogonHospID)
		s Ord=+OrdItemID,Sub=$P(OrdItemID,"||",2)
		d OneOrdItem
		s Sub=0 for{
			s Sub=$O(OrdList(OrdItemID,Sub)) Q:Sub=""
			d OneOrdItem
		}
	}
	Q:'SuccessCount ret
	Q 0
OneOrdItem
	s ARCIMRowid=$P(^OEORD(Ord,"I",Sub,1),"^",2)
	s Note=$CASE(CMFlag,1:$P($G(^OEORD(Ord,"I",Sub,2)),"^",8),:$g(^OEORD(Ord,"I",Sub,"DEP",1)))
	s PartInfo=##Class(DHCDoc.OPDoc.CopyOrderItemList).GetReqPartID(Ord_"||"_Sub)
	s ret=..SaveItem(SubCatID, ARCIMRowid, UserID,"",Note,PartInfo)
	if $P(ret,"^")=0{
		s SuccessCount=SuccessCount+1
	}else{
		s FailCount=FailCount+1
	}
	Q
}

ClassMethod GetLocAuth(GroupID = "", HospID = "") As %Boolean
{
	s:GroupID="" GroupID=%session.Get("LOGON.GROUPID")
	s:HospID="" HospID=%session.Get("LOGON.HOSPID")
	Q +..%GetConfig1("OrdFavLocAuth",GroupID,HospID)
}

ClassMethod GetHospAuth(GroupID = "", HospID = "") As %Boolean
{
	s:GroupID="" GroupID=%session.Get("LOGON.GROUPID")
	s:HospID="" HospID=%session.Get("LOGON.HOSPID")
	Q +..%GetConfig1("OrdFavHospAuth",GroupID,HospID)
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

}
