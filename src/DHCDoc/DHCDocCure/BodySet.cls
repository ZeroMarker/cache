Class DHCDoc.DHCDocCure.BodySet Extends DHCDoc.Util.RegisteredObject
{

/// Desc:保存部位标记备注信息及标注后的图片base64数据信息
/// Input:	DCARowId 申请单ID 
/// 		BodyFrontImage 正面图片base64数据
/// 		BodyBackImage 反面图片base64数据
/// 		BodyStr 部位标记备注信息 所属图片描述$$$部位序号$$$所属图片ID$$$部位描述$$$部位备注
/// w ##class(DHCDoc.DHCDocCure.BodySet).SaveBodySet($list(^tmpnk("SaveBodySet"),1),$list(^tmpnk("SaveBodySet"),2),$list(^tmpnk("SaveBodySet"),3),$list(^tmpnk("SaveBodySet"),4))
ClassMethod SaveBodySet(DCARowId As %String, BodyStr As %String, BodyFrontImage, BodyBackImage)
{
	s ^tmplog("SaveBodySet")=$lb(DCARowId,BodyFrontImage,BodyBackImage,BodyStr)
	s myrtn=0
	k BodyStrArr
	if BodyStr'=""{
		s len=$l(BodyStr,"###")
		for loop=1:1:len{
			s aBodySetStr=$p(BodyStr,"###",loop)
			s BodyImage=$p(aBodySetStr,"$$$",1)
			s ID=$p(aBodySetStr,"$$$",2)
			s BodyImageId=$p(aBodySetStr,"$$$",3)
			s BodyStrArr(BodyImageId,ID)=aBodySetStr
		}	
		s BodyStr=""
		s BodyImageId=""
		for{
			s BodyImageId=$o(BodyStrArr(BodyImageId))
			Q:BodyImageId=""
			s BodyID=""
			for{
				s BodyID=$o(BodyStrArr(BodyImageId,BodyID))
				Q:BodyID=""
				if BodyStr="" s BodyStr=BodyStrArr(BodyImageId,BodyID)
				else  s BodyStr=BodyStr_"###"_BodyStrArr(BodyImageId,BodyID)
			}
		}
			
	}
	s obj=##class(User.DHCDocCureApp).%OpenId(DCARowId)
	if $IsObject(obj){
		i $CLASSNAME(BodyFrontImage)["CSP.CharacterStream" {
			d obj.DCABodyFrontImage.CopyFromAndSave(BodyFrontImage)
		}
		else {
			d obj.DCABodyFrontImage.Write(BodyFrontImage)
		}
		/*
		s myImageStream=##class(%Stream.GlobalCharacter).%New()
		s myImageStream=$$GetImageStream(.BodyFrontImage)
		d obj.DCABodyFrontImage.Clear()
		d obj.DCABodyFrontImage.CopyFromAndSave(myImageStream)
		
		Do myImageStream.Rewind()
		s myImageStream=$$GetImageStream(.BodyBackImage)
		d obj.DCABodyBackImage.Clear()
		d obj.DCABodyBackImage.CopyFromAndSave(myImageStream)
		*/
		s obj.DCABodySetStr=BodyStr
		s sc=obj.%Save()
	    If $$$ISERR(sc) {
		    s myrtn="-102"
		}
	    d obj.%Close()
	}else{
		s myrtn="-100"	
	}
	Q myrtn
GetImageStream(plist)
	s ImageStream=##class(%Stream.GlobalCharacter).%New()
	s i=0
	for{
		s i=$o(plist(i))
		Q:i=""
		d ImageStream.Write(plist(i))
	}
	Q ImageStream
}

/// Desc:修改部位标记备注信息
/// Input：ClearFlag:清除保存的部位图片信息
/// w ##class(DHCDoc.DHCDocCure.BodySet).UpdateBodySet($list(^tmpnk("SaveBodySet"),1),$list(^tmpnk("SaveBodySet"),2),$list(^tmpnk("SaveBodySet"),3),$list(^tmpnk("SaveBodySet"),4))
ClassMethod UpdateBodySet(DCARowId As %String, BodyStr As %String, ClearFlag As %String = "")
{
	s myrtn=0
	s obj=##class(User.DHCDocCureApp).%OpenId(DCARowId)
	if $IsObject(obj){
		s obj.DCABodySetStr=BodyStr
		if ClearFlag="Y"{
			d obj.DCABodyFrontImage.Clear()
			d obj.DCABodyBackImage.Clear()
		}
		s sc=obj.%Save()
	    If $$$ISERR(sc) {
		    s myrtn="-102"
		}
	    d obj.%Close()
	}else{
		s myrtn="-100"	
	}
	Q myrtn
}

/// w ##class(DHCDoc.DHCDocCure.BodySet).GetBodySet(352)
ClassMethod GetBodySet(DCARowId As %String)
{
	s BodyFrontImage="",BodyBackImage="",BodyImage=""
	s Stream=##class(%Stream.GlobalCharacter).%New()
	s obj=##class(User.DHCDocCureApp).%OpenId(DCARowId)
	if $IsObject(obj){
		s BodySetStr=obj.DCABodySetStr
		;s ImageStream=##class(%Stream.GlobalCharacter).%New()
		;Do ImageStream.CopyFrom(obj.DCABodyFrontImage)
		
		While (obj.DCABodyFrontImage.AtEnd = 0) {
	        Set len = 1000
	        Set BodyImage=BodyImage_obj.DCABodyFrontImage.Read(.len)
	    }
	    d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonData("BodyImage^BodySetStr",BodyImage_"^"_BodySetStr))
	}else{
		d Stream.Write("{}")
	}
	Set BodyImage=""
	While (Stream.AtEnd = 0) {
        Set len = 1000
        Set BodyImage=BodyImage_Stream.Read(.len)
    }
	    
	Q BodyImage
}

/// w ##class(DHCDoc.DHCDocCure.BodySet).Test()
ClassMethod Test()
{
	s ImageStream=##class(%Stream.GlobalCharacter).%New()
	s i=0
	for{
		s i=$o(^tmpnk("dddd",i))
		Q:i=""
		d ImageStream.Write(^tmpnk("dddd",i))
	}
	Q ImageStream
	Set BodyImage=""
	While (ImageStream.AtEnd = 0) {
        Set len = 1000
        Set BodyImage=BodyImage_ImageStream.Read(.len)
    }
	    
	Q BodyImage
}

/// Desc:保存部位/穴位
/// Input:
/// Debug:
ClassMethod SaveCurePartSet(SetPara As %String, HospID As %String)
{
	Q:SetPara="" -1
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	
	s DDCPSROWID=$P(SetPara,"^")
	s DDCPSType=$P(SetPara,"^",2)
	s DDCPSCode=$P(SetPara,"^",3)
	s DDCPSDesc=$P(SetPara,"^",4)
	s DDCPSDefaultFlag=$P(SetPara,"^",5)
	s DDCPSAvailFlag=$P(SetPara,"^",6)
	s DDCPSAlias=$P(SetPara,"^",7)
	s SDesc=$ZCVT(DDCPSDesc,"U")
	s RowID=$O(^User.DHCDocCurePartSetI("CPSTypeDescIndex"," "_DDCPSType," "_SDesc,""))
	Q:(DDCPSROWID="")&&(RowID'="") 101
	Q:(DDCPSROWID'="")&&(RowID'="")&&(RowID'=DDCPSROWID) 101
	
	K PLIST
	s PLIST(2)=DDCPSCode
	s PLIST(3)=DDCPSDesc
	s PLIST(4)=DDCPSAlias
	s PLIST(5)=DDCPSDefaultFlag
	s PLIST(6)=DDCPSAvailFlag
	s PLIST(7)=DDCPSType
	if DDCPSROWID="" 
	{
	 	&sql(insert into SQLUser.DHC_DocCure_PartSet values :PLIST())
	 	i 'SQLCODE {
		 	s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHC_DocCure_PartSet",HospID,+$H)
		 	s DDCPSROWID=$p(%ROWID,$c(1))
		 	d ##class(DHCDoc.Common.Hospital).SaveHOSP("DHC_DocCure_PartSet",DDCPSROWID,HospID)
	 	}
	}else{
		&sql(update SQLUser.DHC_DocCure_PartSet values :PLIST() where ID=:DDCPSROWID )
	}
	if ('SQLCODE)&&(DDCPSDefaultFlag="Y"){
		s Desc=""
		for{
			s Desc=$O(^User.DHCDocCurePartSetI("CPSTypeDescIndex"," "_DDCPSType,Desc))
			Q:Desc=""
			s ID =""
			for{
				s ID=$O(^User.DHCDocCurePartSetI("CPSTypeDescIndex"," "_DDCPSType,Desc,ID))
				Q:ID=""
				continue:DDCPSROWID=ID
				s CPSDefaultFlag=$lg(^User.DHCDocCurePartSetD(ID),5)
				continue:CPSDefaultFlag'="Y"
				&sql(update SQLUser.DHC_DocCure_PartSet set CPS_DefaultFlag="N" where ID=:ID )
			}
		}
	}
	q SQLCODE_"^"_DDCPSROWID
}

Query QueryPartSetConfig(Type As %String = "", SDesc As %String = "", CPGSRowID As %String = "", SActiveFlag As %String = "", HospID As %String = "", ExpStr As %String = "") As %Query(ROWSPEC = "CPSRowid:%String,CPSCode:%String,CPSDesc:%String,CPSAlias:%String,CPSDefaultFlag:%String,CPSActiveFlag:%String,CPSType:%String,CPSTypeid:%String,CPSHasConfigFlag:%String,SeqNumber:%String,AcupPosition:%String,AcupAttending:%String,AcupOperation:%String,ImgDiagram:%String")
{
}

/// Desc:查询部位/穴位
/// Input:Type：部位-BP？穴位-A？ SDesc:描述 CPGSRowID:部位组 SActiveFlag：仅有效
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.BodySet","QueryPartSetConfig","","","",2,"Y^1")
ClassMethod QueryPartSetConfigExecute(ByRef qHandle As %Binary, Type As %String = "", SDesc As %String = "", CPGSRowID As %String = "", SActiveFlag As %String = "", HospID As %String = "", ExpStr As %String = "") As %Status
{
	s langid=..%LanguageID()
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHC_DocCure_PartSet",HospID,+$H)
	s SDesc=$ZCVT(SDesc,"U")
	
	s NeedAcupDetail=$p(ExpStr,"^",1)
	S DDCISRowid=$p(ExpStr,"^",2)
	S CspName=$p(ExpStr,"^",3)
	if DDCISRowid'=""{
		s child=0
		for{
			s child=$o(^DHCDocCureItemSeti("ExpKey",DDCISRowid,"POA",child))
			Q:child=""
			s mKey=$p(^DHCDocCureItemSet(DDCISRowid,"Exp",child),"^",1)
			s KeyVal=$p(^DHCDocCureItemSet(DDCISRowid,"Exp",child),"^",2)
			s CPSRowid=KeyVal
			d OutputRow
		}
	}else{
		s CPSRowid=0
		for{
			s CPSRowid=$o(^User.DHCDocCurePartSetD(CPSRowid)) q:CPSRowid=""
			d OutputRow
		}
	}
	Quit $$$OK 
OutputRow
	s HospShowDataFlag=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_DocCure_PartSet",CPSRowid,HospID)
	Q:(HospShowDataFlag="N")
	s CPSActiveFlag=$lg(^User.DHCDocCurePartSetD(CPSRowid),6)
	Q:(SActiveFlag'="")&&(CPSActiveFlag'=SActiveFlag)
	s CPSCode=$lg(^User.DHCDocCurePartSetD(CPSRowid),2)
	s CPSDesc=$lg(^User.DHCDocCurePartSetD(CPSRowid),3)
	s CPSDesc=##class(User.DHCDocCurePartSet).GetTranByDesc("CPSDesc",CPSDesc,langid)
	s CPSAlias=$lg(^User.DHCDocCurePartSetD(CPSRowid),4)
	Q:(SDesc'="")&&($ZCVT(CPSDesc,"U")'[SDesc)&&($ZCVT(CPSAlias,"U")'[SDesc)
	s CPSDefaultFlag=$lg(^User.DHCDocCurePartSetD(CPSRowid),5)
	if CspName'=""{
		s CPSDefaultFlag=$case(CPSDefaultFlag,
		"Y":##class(websys.Translation).Get(CspName,"是"),
		:##class(websys.Translation).Get(CspName,"否"))
	}else{
		s CPSDefaultFlag=$case(CPSDefaultFlag,"Y":"是",:"否")	
	}
	if CspName'=""{
		s CPSActiveFlag=$case(CPSActiveFlag,
		"Y":##class(websys.Translation).Get(CspName,"是"),
		:##class(websys.Translation).Get(CspName,"否"))
	}else{
		s CPSActiveFlag=$case(CPSActiveFlag,"Y":"是",:"否")
	}
	
	s CPSTypeId=$lg(^User.DHCDocCurePartSetD(CPSRowid),7)
	Q:(Type'="")&&(Type'=CPSTypeId)
	if CspName'=""{
		s CPSType=$case(CPSTypeId,
		"BP":##class(websys.Translation).Get(CspName,"部位"),
		"A":##class(websys.Translation).Get(CspName,"穴位"))
	}else{
		s CPSType=$case(CPSTypeId,"BP":"部位","A":"穴位")
	}
	s CPSHasConfigFlag=""
	if CPGSRowID'=""{
		s CPSHasConfigFlag=..CheckHasLink(CPGSRowID,CPSRowid,HospID)	
	}
	s (AcupPosition,AcupAttending,AcupOperation,ImgDiagram)=""
	if NeedAcupDetail="Y"{
		s AcupDetail=..GetAcupDetail(CPSRowid)
		;s Arr=##Class(DHCDoc.Util.ArrayData).%New() ;感觉这个效率还是差了点
		;s JsonObj=Arr.%FromJSON(AcupDetail)
		s JsonObj={}.%FromJSON(AcupDetail)
		s AcupPosition=JsonObj.AcupPosition
		s AcupAttending=JsonObj.AcupAttending
		s AcupOperation=JsonObj.AcupOperation
		s ImgDiagram=JsonObj.AcupImgDiagramShow
	}
	
	s qHandle(CPSTypeId,$I(ind))=$lb(CPSRowid,CPSCode,CPSDesc,CPSAlias,CPSDefaultFlag,CPSActiveFlag,CPSType,CPSTypeId,CPSHasConfigFlag,"",AcupPosition,AcupAttending,AcupOperation,ImgDiagram)
	quit
}

ClassMethod QueryPartSetConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPartSetConfigExecute ]
{
	s SeqNumber=0
	s RowId=$O(qHandle(""))
	if RowId'=""{
		s ind=$O(qHandle(RowId,""))
		if ind'=""{
			s SeqNumber=SeqNumber+1
			s Row=qHandle(RowId,ind)
			k qHandle(RowId,ind)
			Quit $$$OK
		}
	}
	s AtEnd=1
	Quit $$$OK
}

/// Desc:保存穴位属性
/// Input:PartId 部位/穴位ID;AcupJson 属性Json串;ImgDiagram图解图片Base64
/// Debug:
ClassMethod AcupDetailSet(PartId As %String, AcupJson As %String, ImgDiagram As %String = "")
{
	s ^tmpnk("AcupDetailSet")=$lb(PartId,AcupJson,ImgDiagram)
	s myrtn=0
	d ##class(DHCDoc.Util.FromJSON).FromJSONToArr(AcupJson,.AcupJsonArr)
	s Obj=##class(User.DHCDocCurePartSet).%OpenId(PartId)
	if $IsObject(Obj){
		s Obj.CPSAcupPosition=AcupJsonArr("AcupPosition")
		s Obj.CPSAcupAttending=AcupJsonArr("AcupAttending")
		s Obj.CPSAcupOperation=AcupJsonArr("AcupOperation")
		if $IsObject(ImgDiagram){
			d Obj.CPSAcupImgDiagram.CopyFrom(ImgDiagram)
		}else{
			d:ImgDiagram'="" Obj.CPSAcupImgDiagram.Write(ImgDiagram)
		}
		s sc=Obj.%Save()
	    If $$$ISERR(sc) {
		    s myrtn="-102"
		}
		d Obj.%Close()
	}
	Q myrtn
}

ClassMethod DelAcupImgDiagram(PartId As %String)
{
	s myrtn=0
	s Obj=##class(User.DHCDocCurePartSet).%OpenId(PartId)
	if $IsObject(Obj){
		d Obj.CPSAcupImgDiagram.Clear()
		s sc=Obj.%Save()
	    If $$$ISERR(sc) {
		    s myrtn="-102"
		}
		d Obj.%Close()
	}
	Q myrtn
}

/// Desc:根据穴位ID获取保存的穴位属性
/// Input:PartId 部位/穴位ID
/// Debug: w ##class(DHCDoc.DHCDocCure.BodySet).GetAcupDetail(2)
ClassMethod GetAcupDetail(PartId As %String)
{
	s JsonObj={} ;##Class(DHCDoc.Util.ArrayData).%New()
	s ImgDiagram=""
	s Obj=##class(User.DHCDocCurePartSet).%OpenId(PartId)
	if $IsObject(Obj){
		s AcupPosition=Obj.CPSAcupPosition
		s AcupAttending=Obj.CPSAcupAttending
		s AcupOperation=Obj.CPSAcupOperation
		s JsonObj.AcupPosition=AcupPosition
		s JsonObj.AcupAttending=AcupAttending
		s JsonObj.AcupOperation=AcupOperation
		
		;s ImageStream=##class(%Stream.GlobalCharacter).%New()
		;Do ImageStream.CopyFrom(Obj.CPSAcupImgDiagram)
		While (Obj.CPSAcupImgDiagram.AtEnd = 0) {
	        Set len = 1000
	        Set ImgDiagram=ImgDiagram_Obj.CPSAcupImgDiagram.Read(.len)
	    }
	    s JsonObj.AcupImgDiagramShow=ImgDiagram
		
		d Obj.%Close()
	}
	Q JsonObj.%ToJSON()
}

Query QueryPartGrpSet(Type As %String = "", SDesc As %String = "", SAuthority As %String = "", SActiveFlag As %String = "", SessionStr As %String = "", HospID As %String = "", NotCheckKeyFlag As %String = "") As %Query(ROWSPEC = "CPGSRowid:%String,CPGSCode:%String,CPGSDesc:%String,CPGSAlias:%String,CPGSDefaultFlag:%String,CPGSActiveFlag:%String,CPGSType:%String,CPGSTypeId:%String,CPGSAuthority:%String,CPGSAuthorityId:%String,AllowUpdateFlag:%String")
{
}

/// 查询治疗部位/穴位组
/// Type：部位-BP？穴位-A？ SDesc:描述 SAuthority:权限类型 NotCheckKeyFlag:Y不判断权限类型
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.BodySet","QueryPartGrpSet","","","","","","","Y")
ClassMethod QueryPartGrpSetExecute(ByRef qHandle As %Binary, Type As %String = "", SDesc As %String = "", SAuthority As %String = "", SActiveFlag As %String = "", SessionStr As %String = "", HospID As %String = "", NotCheckKeyFlag As %String = "") As %Status
{
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHC_DocCure_PartGrpSet",HospID,+$H)
	s SessionUser=$p(SessionStr,"^",1)
	s SessionDept=$p(SessionStr,"^",2)
	s SessionGroup=$p(SessionStr,"^",3)
	s SessionHosp=$p(SessionStr,"^",4)
	s langid=$p(SessionStr,"^",5)
	s CspName=$p(SessionStr,"^",6)
	s:langid="" langid=..%LanguageID()
	s:HospID="" HospID=SessionHosp
	s SDesc=$ZCVT(SDesc,"U")
	s CPGSRowid=0
	for{
		s CPGSRowid=$o(^User.DHCDocCurePartGrpSetD(CPGSRowid)) q:CPGSRowid=""
		s HospShowDataFlag=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_DocCure_PartGrpSet",CPGSRowid,HospID)
		continue:(HospShowDataFlag="N")
		s CPGSDesc=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid),3)
		s CPGSAlias=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid),4)
		continue:(SDesc'="")&&($ZCVT(CPGSDesc,"U")'[SDesc)&&($ZCVT(CPGSAlias,"U")'[SDesc)
		s CPGSActiveFlag=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid),6)
		continue:(SActiveFlag'="")&&(SActiveFlag'=CPGSActiveFlag)
		s CPGSTypeId=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid),7)
		continue:(Type'="")&&(Type'=CPGSTypeId)
		s CPGSAuthorityId=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid),8)
		continue:(SAuthority'="")&&(SAuthority'=CPGSAuthorityId)
		s CPGSAuthKey=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid),9)
		s AllowUpdateFlag="Y"
		if NotCheckKeyFlag'="Y"{
			continue:(CPGSAuthorityId="H")&&(CPGSAuthKey'=HospID)
			continue:(CPGSAuthorityId="D")&&(CPGSAuthKey'=SessionDept)
			continue:(CPGSAuthorityId="U")&&(CPGSAuthKey'=SessionUser)
		}else{
			if (CPGSAuthorityId="H")&&(CPGSAuthKey'=HospID) s AllowUpdateFlag="N"
			if (CPGSAuthorityId="D")&&(CPGSAuthKey'=SessionDept) s AllowUpdateFlag="N"
			if (CPGSAuthorityId="U")&&(CPGSAuthKey'=SessionUser) s AllowUpdateFlag="N"
		}
		d OutputRow
	}
	Quit $$$OK 
OutputRow
	s CPGSCode=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid),2)
	s CPGSDefaultFlag=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid),5)
	if CspName'=""{
		s CPGSDefaultFlag=$case(CPGSDefaultFlag,
		"Y":##class(websys.Translation).Get(CspName,"是"),
		:##class(websys.Translation).Get(CspName,"否"))
	}else{
		s CPGSDefaultFlag=$case(CPGSDefaultFlag,"Y":"是",:"否")
	}
	s CPGSActiveFlag=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid),6)
	if CspName'=""{
		s CPGSActiveFlag=$case(CPGSActiveFlag,
		"Y":##class(websys.Translation).Get(CspName,"是"),
		:##class(websys.Translation).Get(CspName,"否"))
	}else{
		s CPGSActiveFlag=$case(CPGSActiveFlag,"Y":"是",:"否")
	}
	s CPGSTypeId=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid),7)
	if CspName'=""{
		s CPGSType=$case(CPGSTypeId,
		"BP":##class(websys.Translation).Get(CspName,"部位"),
		"A":##class(websys.Translation).Get(CspName,"穴位"))
	}else{
		s CPGSType=$case(CPGSTypeId,"BP":"部位","A":"穴位")
	}
	s CPGSAuthorityId=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid),8)
	if CspName'=""{
		s CPGSAuthority=$case(CPGSAuthorityId,
		"H":##class(websys.Translation).Get(CspName,"全院"),
		"D":##class(websys.Translation).Get(CspName,"科室"),
		"U":##class(websys.Translation).Get(CspName,"个人"))
	}else{
		s CPGSAuthority=$case(CPGSAuthorityId,"H":"全院","D":"科室","U":"个人")
	}
	s qHandle(CPGSTypeId,CPGSAuthorityId,$I(ind))=$lb(CPGSRowid,CPGSCode,CPGSDesc,CPGSAlias,CPGSDefaultFlag,CPGSActiveFlag,CPGSType,CPGSTypeId,CPGSAuthority,CPGSAuthorityId,AllowUpdateFlag)
	quit
}

ClassMethod QueryPartGrpSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPartGrpSetExecute ]
{
	s RowId=$O(qHandle(""))
	if RowId'=""{
		s AuthorityId=$O(qHandle(RowId,""))
		if AuthorityId'=""{
			s ind=$O(qHandle(RowId,AuthorityId,""))
			if ind'=""{
				s Row=qHandle(RowId,AuthorityId,ind)
				k qHandle(RowId,AuthorityId,ind)
				Quit $$$OK
			}
		}
	}
	s AtEnd=1
	Quit $$$OK
}

ClassMethod SaveCurePartGrpSet(SetPara As %String, SessionStr As %String, HospID As %String)
{
	Q:SetPara="" -1
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	
	s CPGSROWID=$P(SetPara,"^")
	s CPGSType=$P(SetPara,"^",2)
	s CPGSCode=$P(SetPara,"^",3)
	s CPGSDesc=$P(SetPara,"^",4)
	s CPGSDefaultFlag=$P(SetPara,"^",5)
	s CPGSAvailFlag=$P(SetPara,"^",6)
	s CPGSAlias=$P(SetPara,"^",7)
	s CPGSAuthority=$P(SetPara,"^",8)
	s SCPGSDesc=$ZCVT(CPGSDesc,"U")
	s RowID=$O(^User.DHCDocCurePartGrpSetI("CPGSTypeDescIndex"," "_CPGSType," "_SCPGSDesc,""))
	Q:(CPGSROWID="")&&(RowID'="") 101
	Q:(CPGSROWID'="")&&(RowID'="")&&(RowID'=CPGSROWID) 101
	
	s SessionUser=$p(SessionStr,"^",1)
	s SessionDept=$p(SessionStr,"^",2)
	s SessionGroup=$p(SessionStr,"^",3)
	s SessionHosp=$p(SessionStr,"^",4)
	s:HospID="" HospID=SessionHosp
	K PLIST
	s PLIST(2)=CPGSCode
	s PLIST(3)=CPGSDesc
	s PLIST(4)=CPGSAlias
	s PLIST(5)=CPGSDefaultFlag
	s PLIST(6)=CPGSAvailFlag
	s PLIST(7)=CPGSType
	s PLIST(8)=CPGSAuthority
	s PLIST(9)=$case(CPGSAuthority,"H":HospID,"D":SessionDept,"U":SessionUser,:SessionUser)
	if CPGSROWID="" 
	{
	 	&sql(insert into SQLUser.DHC_DocCure_PartGrpSet values :PLIST())
	 	i 'SQLCODE {
		 	s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHC_DocCure_PartSet",HospID,+$H)
		 	s CPGSROWID=$p(%ROWID,$c(1))
		 	d ##class(DHCDoc.Common.Hospital).SaveHOSP("DHC_DocCure_PartGrpSet",CPGSROWID,HospID)
	 	}
	}else{
		&sql(update SQLUser.DHC_DocCure_PartGrpSet values :PLIST() where ID=:CPGSROWID )
	}
	if ('SQLCODE)&&(CPGSDefaultFlag="Y"){
		s Desc=""
		for{
			s Desc=$O(^User.DHCDocCurePartGrpSetI("CPGSTypeDescIndex"," "_CPGSType,Desc))
			Q:Desc=""
			s ID =""
			for{
				s ID=$O(^User.DHCDocCurePartGrpSetI("CPGSTypeDescIndex"," "_CPGSType,Desc,ID))
				Q:ID=""
				continue:CPGSROWID=ID
				s CPGSDefaultFlag=$lg(^User.DHCDocCurePartGrpSetD(ID),5)
				continue:CPGSDefaultFlag'="Y"
				s CPGSAuthorityId=$lg(^User.DHCDocCurePartGrpSetD(ID),8)
				continue:CPGSAuthorityId'=CPGSAuthority
				&sql(update SQLUser.DHC_DocCure_PartGrpSet set CPGS_DefaultFlag="N" where ID=:ID )
			}
		}
	}
	q SQLCODE
}

ClassMethod CheckHasLink(CPGSRowid, PartId, HospID)
{
	s HasLink=0
	s ChildSub=""
	for{
		s ChildSub=$o(^User.DHCDocCurePartGrpLinkSetI("CPGLSHospital",HospID,CPGSRowid,ChildSub))
		Q:ChildSub=""
		s CPGLSPartId=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid,"ChildDHCDocCurePartGrpLinkSet",ChildSub),2)
		if PartId=CPGLSPartId{
			s HasLink=1
			Q
		}
	}	
	Q HasLink
}

/// Desc:保存部位/穴位组与部位/穴位的关联
/// Input:CPGSRowid 部位/穴位组ID;PartIdStr 关联的部位/穴位ID串;HospID 院区ID
/// Debug:
ClassMethod SavePartGrpLinkSet(CPGSRowid As %String, PartIdStr As %String, HospID As %String)
{
	s ^tmpnk("SavePartGrpLinkSet")=$lb(CPGSRowid,PartIdStr,HospID)
	s myRtn=0
	s MaxSeq=0
	s ChildSub=""
	for{
		s ChildSub=$o(^User.DHCDocCurePartGrpLinkSetI("CPGLSHospital",HospID,CPGSRowid,ChildSub))
		Q:ChildSub=""
		s CPGLSPartId=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid,"ChildDHCDocCurePartGrpLinkSet",ChildSub),2)
		;s CPGLSHospId=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid,"ChildDHCDocCurePartGrpLinkSet",ChildSub),4)
		;continue:(HospID'=CPGLSHospId)
		if ("^"_PartIdStr_"^")[("^"_CPGLSPartId_"^"){
			s CPGLSPartDesc=$lg(^User.DHCDocCurePartSetD(CPGLSPartId),3)
			s myRtn=CPGLSPartDesc_",项目已关联."
			Q
		}
		s IndexSeq=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid,"ChildDHCDocCurePartGrpLinkSet",ChildSub),3)
		if IndexSeq>MaxSeq s MaxSeq=IndexSeq
	}
	if myRtn'=0{
		Q myRtn	
	}
	
	TS
	s PartIdLen=$l(PartIdStr,"^")
	for loop=1:1:PartIdLen{
		s PartId=$p(PartIdStr,"^",loop)	
		s IndexSeq=MaxSeq+loop
		&SQL(Insert Into SQLUser.DHC_DocCure_PartGrpLinkSet(CPGLS_ParRef_Dr,CPGLS_Part_Dr,CPGLS_IndexSeq,CPGLS_Hospital)
		values(:CPGSRowid,:PartId,:IndexSeq,:HospID))
		
		if SQLCODE{
			s myRtn=SQLCODE	
			Q
		}
	}
	if myRtn=0{
		TC	
	}else{
		Tro	
	}
	Q myRtn
}

/// Desc:删除部位/穴位组与部位/穴位的关联
/// Input:CPGLRowid
/// Debug:
ClassMethod DelPartGrpLinkSet(CPGLRowid As %String)
{
	if CPGLRowid="" Q 100
	&SQL(delete from SQLUser.DHC_DocCure_PartGrpLinkSet where ID=:CPGLRowid)
	Q SQLCODE
}

/// Desc:上移下移 部位/穴位组与部位/穴位的关联
/// Input:CPGLRowid
/// Debug:w ##class(DHCDoc.DHCDocCure.BodySet).MovePartGrpLinkSet("1||17","U")
ClassMethod MovePartGrpLinkSet(CPGLRowid As %String, MoveType As %String)
{
	if CPGLRowid="" Q 100
	s CPGLChild=$p(CPGLRowid,"||",2)
	s CPGLSHospId=$lg(^User.DHCDocCurePartGrpSetD(+CPGLRowid,"ChildDHCDocCurePartGrpLinkSet",CPGLChild),4)	
	s CPGLSIndexSeq=$lg(^User.DHCDocCurePartGrpSetD(+CPGLRowid,"ChildDHCDocCurePartGrpLinkSet",CPGLChild),3)
	s ExCPGLRowid=""
	if MoveType="U"{
		s tmpIndexSeq=1
		s ChildSub=""
		for{
			s ChildSub=$o(^User.DHCDocCurePartGrpLinkSetI("CPGLSHospital",CPGLSHospId,+CPGLRowid,ChildSub))
			Q:ChildSub=""
			continue:CPGLChild=ChildSub
			s IndexSeq=$lg(^User.DHCDocCurePartGrpSetD(+CPGLRowid,"ChildDHCDocCurePartGrpLinkSet",ChildSub),3)
			if (IndexSeq'<tmpIndexSeq)&&(IndexSeq<CPGLSIndexSeq){
				s tmpIndexSeq=IndexSeq	
				s ExCPGLRowid=+CPGLRowid_"||"_ChildSub
			}
		}
	}
	elseif MoveType="D"{
		s tmpIndexSeq=9999
		s ChildSub=""
		for{
			s ChildSub=$o(^User.DHCDocCurePartGrpLinkSetI("CPGLSHospital",CPGLSHospId,+CPGLRowid,ChildSub))
			Q:ChildSub=""
			continue:CPGLChild=ChildSub
			s IndexSeq=$lg(^User.DHCDocCurePartGrpSetD(+CPGLRowid,"ChildDHCDocCurePartGrpLinkSet",ChildSub),3)
			if (IndexSeq<tmpIndexSeq)&&(IndexSeq>CPGLSIndexSeq){
				s tmpIndexSeq=IndexSeq	
				s ExCPGLRowid=+CPGLRowid_"||"_ChildSub
			}
		}
	}
	s myRtn=0
	if ExCPGLRowid=""{
		s myRtn=101	
		Q myRtn
	}
	Ts
	&SQL(update SQLUser.DHC_DocCure_PartGrpLinkSet set CPGLS_IndexSeq=:tmpIndexSeq where ID=:CPGLRowid)
	
	if 'SQLCODE{
		&SQL(update SQLUser.DHC_DocCure_PartGrpLinkSet set CPGLS_IndexSeq=:CPGLSIndexSeq where ID=:ExCPGLRowid)
		s myRtn=SQLCODE
	}
	if 'SQLCODE{
		Tc
	}else{
		s myRtn=SQLCODE
		Tro
	}
	Q myRtn
}

Query QueryPartGrpLinkSet(CPGSRowid As %String = "", HospID As %String = "") As %Query(ROWSPEC = "CPGLRowid:%String,CPGLSPartId:%String,CPGLSPartDesc:%String")
{
}

/// 查询治疗部位/穴位组下关联的部位/穴位信息
/// CPGSRowid：部位/穴位组ID
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.BodySet","QueryPartGrpLinkSet","6",2)
ClassMethod QueryPartGrpLinkSetExecute(ByRef qHandle As %Binary, CPGSRowid As %String = "", HospID As %String = "") As %Status
{
	if CPGSRowid=""{
		Quit $$$OK 
	}
	s langid=..%LanguageID()
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s ChildSub=""
	for{
		s ChildSub=$o(^User.DHCDocCurePartGrpSetD(CPGSRowid,"ChildDHCDocCurePartGrpLinkSet",ChildSub))
		Q:ChildSub=""
		s ID=CPGSRowid_"||"_ChildSub
		s CPGLSPartId=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid,"ChildDHCDocCurePartGrpLinkSet",ChildSub),2)
		s CPGLSIndexSeq=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid,"ChildDHCDocCurePartGrpLinkSet",ChildSub),3)
		s CPGLSHospId=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid,"ChildDHCDocCurePartGrpLinkSet",ChildSub),4)
		continue:(HospID'=CPGLSHospId)
		d OutputRow
	}
	Quit $$$OK 
OutputRow
	s CPGLSPartDesc=$lg(^User.DHCDocCurePartSetD(CPGLSPartId),3)
	s CPGLSPartDesc=##class(User.DHCDocCurePartSet).GetTranByDesc("CPSDesc",CPGLSPartDesc,langid)
	s qHandle(CPGLSIndexSeq,$I(ind))=$lb(ID,CPGLSPartId,CPGLSPartDesc)
	quit
}

ClassMethod QueryPartGrpLinkSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPartGrpLinkSetExecute ]
{
	s RowId=$O(qHandle(""))
	if RowId'=""{
		s ind=$O(qHandle(RowId,""))
		if ind'=""{
			s Row=qHandle(RowId,ind)
			k qHandle(RowId,ind)
			Quit $$$OK
		}
	}
	s AtEnd=1
	Quit $$$OK
}

Query QueryPOATreeConfig(DDCISRowid As %String, Type As %String = "", SDesc As %String = "", SessionStr As %String = "") As %Query(ROWSPEC = "SeqCount:%String,CPSRowid:%String,CPSCode:%String,CPSDesc:%String,CPSAlias:%String,CPSDefaultFlag:%String,CPSType:%String,CPSTypeid:%String,AcupPosition:%String,AcupAttending:%String,AcupOperation:%String,ImgDiagram:%String,_parentId:%String")
{
}

/// Desc:查询部位/穴位组及关联部位/穴位信息
/// Input:Type：部位-BP？穴位-A？ SDesc:描述 CPGSRowID:部位组 SGroup：S 仅部位/穴位;G 仅部位组/穴位组;空 部位/穴位&组
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.BodySet","QueryPOATreeConfig",523,"","","1^1^1^2")
ClassMethod QueryPOATreeConfigExecute(ByRef qHandle As %Binary, DDCISRowid As %String, Type As %String = "", SDesc As %String = "", SessionStr As %String = "") As %Status
{
	s SessionUser=$p(SessionStr,"^",1)
	s SessionDept=$p(SessionStr,"^",2)
	s SessionGroup=$p(SessionStr,"^",3)
	s SessionHosp=$p(SessionStr,"^",4)
	s langid=$p(SessionStr,"^",5)
	s CspName=$p(SessionStr,"^",6)
	
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(SessionHosp)
	s:langid="" langid=..%LanguageID()
	s SeqCount=0
	
	s child=0
	for{
		s child=$o(^DHCDocCureItemSeti("ExpKey",DDCISRowid,"POAGRP",child))
		Q:child=""
		s mKey=$p(^DHCDocCureItemSet(DDCISRowid,"Exp",child),"^",1)
		s KeyVal=$p(^DHCDocCureItemSet(DDCISRowid,"Exp",child),"^",2)
		s CPGSRowid=KeyVal
		s HospShowDataFlag=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_DocCure_PartGrpSet",CPGSRowid,HospID)
		continue:(HospShowDataFlag="N")
		s CPGSDesc=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid),3)
		s CPGSDesc=##class(User.DHCDocCurePartGrpSet).GetTranByDesc("CPGSDesc",CPGSDesc,langid)
		s CPGSAlias=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid),4)
		continue:(SDesc'="")&&($ZCVT(CPGSDesc,"U")'[SDesc)&&($ZCVT(CPGSAlias,"U")'[SDesc)
		s CPGSActiveFlag=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid),6)
		continue:(CPGSActiveFlag'="Y")
		s CPGSTypeId=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid),7)
		continue:(Type'="")&&(Type'=CPGSTypeId)
		s CPGSAuthorityId=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid),8)
		s CPGSAuthKey=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid),9)
		continue:(CPGSAuthorityId="H")&&(CPGSAuthKey'=SessionHosp)
		continue:(CPGSAuthorityId="D")&&(CPGSAuthKey'=SessionDept)
		continue:(CPGSAuthorityId="U")&&(CPGSAuthKey'=SessionUser)
		s CPGSType=$case(CPGSTypeId,
		"BP":##class(websys.Translation).Get("doccure.apply.part.hui.csp","部位"),
		"A":##class(websys.Translation).Get("doccure.apply.part.hui.csp","穴位"))
		s CPGSCode=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid),2)
		s CPGSDefaultFlag=$lg(^User.DHCDocCurePartGrpSetD(CPGSRowid),5)
		s SeqCount=SeqCount+1
		s CPGSDesc=##class(ext.util.String).EvalJSON(CPGSDesc)
		s CPGSAlias=##class(ext.util.String).EvalJSON(CPGSAlias)
		s (AcupPosition,AcupAttending,AcupOperation,ImgDiagram)=""
		s qHandle(CPGSTypeId,$I(ind))=$lb(SeqCount,CPGSRowid,CPGSCode,CPGSDesc,CPGSAlias,CPGSDefaultFlag,CPGSType,CPGSTypeId,AcupPosition,AcupAttending,AcupOperation,ImgDiagram,"")
		
		s rsetLink=##class(%ResultSet).%New("DHCDoc.DHCDocCure.BodySet:QueryPartGrpLinkSet")
		do rsetLink.Execute(CPGSRowid,HospID)
		Set columns = rsetLink.GetColumnCount()
		While (rsetLink.Next()) {
			s CPGLRowid=rsetLink.GetDataByName("CPGLRowid")
			s CPSRowid=rsetLink.GetDataByName("CPGLSPartId")
			s CPSDesc=rsetLink.GetDataByName("CPGLSPartDesc")
			s CPSDesc=##class(User.DHCDocCurePartSet).GetTranByDesc("CPSDesc",CPSDesc,langid)
			s CPSCode=$lg(^User.DHCDocCurePartSetD(CPSRowid),2)
			s CPSAlias=$lg(^User.DHCDocCurePartSetD(CPSRowid),4)
			;Q:(SDesc'="")&&($ZCVT(CPSDesc,"U")'[SDesc)&&($ZCVT(CPSAlias,"U")'[SDesc)
			s CPSDefaultFlag=$lg(^User.DHCDocCurePartSetD(CPSRowid),5)
			s CPSDefaultFlag=$case(CPSDefaultFlag,
			"Y":##class(websys.Translation).Get("doccure.apply.part.hui.csp","是"),
			:##class(websys.Translation).Get("doccure.apply.part.hui.csp","否"))
			s CPSActiveFlag=$lg(^User.DHCDocCurePartSetD(CPSRowid),6)
			continue:CPSActiveFlag'="Y"
			s CPSTypeId=$lg(^User.DHCDocCurePartSetD(CPSRowid),7)
			s CPSType=$case(CPSTypeId,
			"BP":##class(websys.Translation).Get("doccure.apply.part.hui.csp","部位"),
			"A":##class(websys.Translation).Get("doccure.apply.part.hui.csp","穴位"))
			s AcupDetail=..GetAcupDetail(CPSRowid)
			;s Arr=##Class(DHCDoc.Util.ArrayData).%New()
			;s JsonObj=Arr.%FromJSON(AcupDetail)
			s JsonObj={}.%FromJSON(AcupDetail)
			s CPSDesc=##class(ext.util.String).EvalJSON(CPSDesc)
			s CPSAlias=##class(ext.util.String).EvalJSON(CPSAlias)
			s AcupPosition=JsonObj.AcupPosition ;##class(ext.util.String).EvalJSON(JsonObj.AcupPosition)
			s AcupAttending=JsonObj.AcupAttending ;##class(ext.util.String).EvalJSON(JsonObj.AcupAttending)
			s AcupOperation=JsonObj.AcupOperation ;##class(ext.util.String).EvalJSON(JsonObj.AcupOperation)
			s ImgDiagram=JsonObj.AcupImgDiagramShow
			s SeqCount=SeqCount+1
			s qHandle(CPSTypeId,$I(ind))=$lb(SeqCount,$replace(CPGLRowid,"||","-")_"-"_CPSRowid,CPSCode,CPSDesc,CPSAlias,CPSDefaultFlag,CPSType,CPSTypeId,AcupPosition,AcupAttending,AcupOperation,ImgDiagram,CPGSRowid)
		}
	}
	
	Quit $$$OK
}

ClassMethod QueryPOATreeConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPOATreeConfigExecute ]
{
	s RowId=$O(qHandle(""))
	if RowId'=""{
		s ind=$O(qHandle(RowId,""))
		if ind'=""{
			s Row=qHandle(RowId,ind)
			k qHandle(RowId,ind)
			Quit $$$OK
		}
	}
	s AtEnd=1
	Quit $$$OK
}

/// Desc:根据治疗医嘱项ID获取关联的治疗部位/穴位(组)数量
/// Debug:w ##class(DHCDoc.DHCDocCure.BodySet).GetPOASetCount(523,"12175^115^28^2")
ClassMethod GetPOASetCount(DDCISRowid, SessionStr)
{
	s SetCount=0
	Q:DDCISRowid="" SetCount
	
	s SessionHosp=$p(SessionStr,"^",4)
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(SessionHosp)
	s rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.BodySet:QueryPOATreeConfig")
	do rset.Execute(DDCISRowid,"","",SessionStr)
	While (rset.Next()) {
		s SetCount=SetCount+1
	}	
	
	s rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.BodySet:QueryPartSetConfig")
	do rset.Execute("","","","Y",HospID,"^"_DDCISRowid)
	While (rset.Next()) {
		s SetCount=SetCount+1
	}
	
	Q SetCount
}

}
