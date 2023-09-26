Class DHCDoc.DHCDocCure.AssScaleConfig Extends %RegisteredObject
{

/// Creator: 	nk
/// CreateDate: 2021-05-21
/// Descritp:   复制评定量表维护表
/// Input:      ID-被复制的评定量表ID HospID-复制到的院区ID
/// Ouput:      新评定量表ID
/// w ##Class(DHCDoc.DHCDocCure.AssScaleConfig).Insert("","")
ClassMethod CopyAssScaleToHosp(ID As %String, HospID As %String) As %String
{
	s AssScaleStr=..GetAssScale(ID)
	s CopyCode=$p(AssScaleStr,"^",2)
	s CopyDesc=$p(AssScaleStr,"^",3)
	s CopyHospID=$p(AssScaleStr,"^",4)
	s CopyHtml=$lg(^User.DHCDocCureAssScaleD(ID),4)
	
	s mListData=""
	s ChildSub=""
	for{
		s ChildSub=$o(^User.DHCDocCureAssScaleD(ID,"ChildDHCDocCureAssScaleForm",ChildSub))
		Q:ChildSub=""
		s CopyKey=$lg(^User.DHCDocCureAssScaleD(ID,"ChildDHCDocCureAssScaleForm",ChildSub),2)
		s CopyTex=$lg(^User.DHCDocCureAssScaleD(ID,"ChildDHCDocCureAssScaleForm",ChildSub),3)
		s CopyType=$lg(^User.DHCDocCureAssScaleD(ID,"ChildDHCDocCureAssScaleForm",ChildSub),4)
		s ListData=CopyKey_"^"_CopyTex_"^"_CopyType
		if mListData=""{
			s mListData=ListData	
		}else{
			s mListData=mListData_"@"_ListData	
		}
	}
	
	Ts
	s NewID=..InsAssScaleMain(CopyCode, CopyHospID,HospID)
	if NewID<0{
		Tro
		Q "-10"	
	}
	s Err=..InsHtml(NewID,CopyHtml,mListData)
	i Err'=0{
		Tro
		Q Err
	}
	Tc
	
	Q NewID
}

/// Creator: 	nk
/// CreateDate: 2021-05-21
/// Descritp:   保存评定量表维护表
/// Input:      mListData-评定量表内容
/// Ouput:      评定量表ID
/// w ##Class(DHCDoc.DHCDocCure.AssScaleConfig).Insert("","")
ClassMethod Insert(ID As %String, Code As %String, Desc As %String, Cat As %String, HospID As %String) As %String
{
	s tmpstr=ID_"^"_Code_"^"_Desc_"^"_HospID
	s Err=..CheckRepeat(tmpstr)
	q:Err'=0 Err
	i ID="" D
	.s ID=..InsAssScaleMain(Code, Desc,Cat,HospID)
	E  D
	.s ID=..UpdAssScaleMain(ID, Code, Desc,Cat,HospID)
	Q ID
}

/// Creator: 	nk
/// CreateDate: 2021-05-20
/// Descript: 	插入评定量表维护表
/// Input:      
/// Output: 
ClassMethod InsAssScaleMain(AssScaleCode, AssScaleDesc, AssScaleCat As %String, HospID As %String = "") As %String
{
	&SQL(INSERT INTO SQLUser.DHC_DocCureAssScale(DCAS_Code, DCAS_Desc, DCAS_Cat_Dr,DCAS_Hosp_Dr) VALUES(:AssScaleCode,:AssScaleDesc,:AssScaleCat,:HospID))
	i SQLCODE'=0 {
		Q SQLCODE
	}else{
	 	s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHC_DocCureAssScale",HospID,+$H)
	 	s RowID=+%ROWID
	 	d ##class(DHCDoc.Common.Hospital).SaveHOSP("DHC_DocCureAssScale",RowID,HospID)
 	}
	Q RowID
}

ClassMethod CheckRepeat(ItmTempStr As %String) As %String
{
	s ret=0
	s ID=$p(ItmTempStr,"^",1)   	///ID
	s ICode=$p(ItmTempStr,"^",2)   	///代码
	s IDesc=$p(ItmTempStr,"^",3)   	///描述
	s hospDr=$p(ItmTempStr,"^",4)		///医院ID
	i $d(^User.DHCDocCureAssScaleI("DCASCodeIndex",ICode)) d ;$$ALPHAUP^SSUTIL4(ICode)
	.s CatID=""
	.f  s CatID=$o(^User.DHCDocCureAssScaleI("DCASCodeIndex",ICode,CatID)) q:(CatID="")||(ret'=0)  d
	..Q:(ID'="")&&(CatID=ID)
	..s HospID=$lg(^User.DHCDocCureAssScaleD(CatID),6)
	..q:HospID'=hospDr
	..s ret=-1
	i $d(^User.DHCDocCureAssScaleI("DCASDescIndex",$$ALPHAUP^SSUTIL4(IDesc)))  d
	.s CatID=""
	.f  s CatID=$o(^User.DHCDocCureAssScaleI("DCASDescIndex",$$ALPHAUP^SSUTIL4(IDesc),CatID))  q:(CatID="")||(ret'=0)  d
	..Q:(ID'="")&&(CatID=ID)
	..s HospID=$lg(^User.DHCDocCureAssScaleD(CatID),6)
	..q:HospID'=hospDr
	..s ret=-2
	q ret
}

/// Creator: 	nk
/// CreateDate: 2021-05-20
/// Descript: 	更新评定量表维护表
/// Input:      
/// Output: 
ClassMethod UpdAssScaleMain(ID, AssScaleCode, AssScaleDesc, AssScaleCat As %String, HospID As %String = "") As %String
{
	&SQL(update SQLUser.DHC_DocCureAssScale set DCAS_Code=:AssScaleCode, DCAS_Desc=:AssScaleDesc, DCAS_Cat_Dr=:AssScaleCat where DCAS_RowID=:ID)
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Creator: 	nk
/// CreateDate: 2021-05-21
/// Descritp:   保存评定量表维护表
/// Input:      mListData-评定量表内容
/// Ouput:      评定量表ID
/// w ##Class(DHCDoc.DHCDocCure.AssScaleConfig).InsHtml("29","")
ClassMethod InsHtml(ID As %String, Html As %String, FormEls As %String, HospID As %String = "") As %String
{
	
	s Err=0
	TS
	/// 插入评定量表维护表Html
	s Err=..InsAssScaleHtml(ID, Html)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 删除相关字表内容重新插入
	s Err=..DelAssScaleForm(ID)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 插入评定量表表单元素
	s Err=..InsAssScaleForm(ID, FormEls)
	i Err'=0 tro
	Q:Err'=0 "-13"
	TC
	Q Err
}

/// Creator: 	 nk
/// CreateDate:  2021-05-21
/// Descript:    删除评定量表子表
/// Input:       EpisodeID - 就诊ID
/// Output: 
/// w ##Class(web.DHCEMCScore).DelAssScaleForm("24")
ClassMethod DelAssScaleForm(ID As %String) As %String
{
	s SQLCODE=0

	&SQL(delete from SQLUser.DHC_DocCureAssScaleForm where DCASF_ParRef_Dr=:ID)
	if SQLCODE=100 s SQLCODE=0
	Q SQLCODE
}

/// Creator: 	nk
/// CreateDate: 2021-05-20
/// Descript: 	插入评定量表维护表Html
/// Input:      
/// Output: 
ClassMethod InsAssScaleHtml(ID As %String, AssScaleHtml As %String, HospID As %String = "") As %String
{
	;&SQL(update SQLUser.DHC_DocCureAssScale set DCAS_Html=:AssScaleHtml where DCAS_RowID=:ID)
	s myrtn=0
	s obj=##class(User.DHCDocCureAssScale).%OpenId(ID,0,.sc)
	if $IsObject(obj){
		;s obj.DCASHtml=AssScaleHtml
		;s myStream=##class(%Stream.GlobalCharacter).%New()
		;s myStream=$$GetStream(.AssScaleHtml)
		;d obj.DCASHtmlStream.CopyFrom(myStream)
		d obj.DCASHtmlStream.Write(AssScaleHtml)
		s sc=obj.%Save()
	    If $$$ISERR(sc) {
		    s myrtn="-102"
		}
	    d obj.%Close()
	}else{
		s myrtn="-100"	
	}
	Q myrtn
GetStream(plist)
	s myStream=##class(%Stream.GlobalCharacter).%New()
	s i=0
	for{
		s i=$o(plist(i))
		Q:i=""
		d myStream.Write(plist(i))
	}
	Q myStream
}

/// Creator: 	nk
/// CreateDate: 2021-05-21
/// Descript: 	插入评定量表表单元素
/// Input:      EpisodeID - 就诊ID
/// Output: 	
/// W ##Class(DHCDoc.DHCDocCure.AssScaleConfig).InsAssScaleForm("")
ClassMethod InsAssScaleForm(ID As %String, mListData As %String) As %String
{
	s Len = $L(mListData,"@")
	s quitflag=0
	F i=1:1:Len Q:quitflag'="0"  D
	.s ListData=$p(mListData,"@",i)  /// 项目列表
	.Q:ListData=""
	.s key=$p(ListData,"^",1)        /// 元素ID
	.s Tex=$p(ListData,"^",2)        /// 元素值
	.s Type=$p(ListData,"^",3)       /// 元素类型
	.&SQL(Insert Into SQLUser.DHC_DocCureAssScaleForm(DCASF_ParRef_Dr,DCASF_key,DCASF_Text,DCASF_Type)
		values(:ID,:key,:Tex,:Type))
	.i SQLCODE'=0 s quitflag="1"
	Q quitflag
}

/// Creator: 	nk
/// CreateDate: 2021-05-20
/// Descript: 	取评定量表维护表
/// Input:      
/// Output:
/// w ##class(DHCDoc.DHCDocCure.AssScaleConfig).GetScoreScale("15")
ClassMethod GetAssScale(ID As %String, langid As %String = "") As %String
{
	s:(langid="")&&($d(%session)) langid=%session.Get("LOGON.LANGID")
	if '$d(^User.DHCDocCureAssScaleD(ID)){
		Q ""
	}
	s AssScaleCode=$lg(^User.DHCDocCureAssScaleD(ID),2)
	s AssScaleDesc=$lg(^User.DHCDocCureAssScaleD(ID),3)
	s AssScaleDesc=##class(User.DHCDocCureAssScale).GetTranByDesc("DCASDesc",AssScaleDesc,langid)
	s AssScaleHospID=$lg(^User.DHCDocCureAssScaleD(ID),6)
	s DCASCat=""
	s AssScaleCatID=$lg(^User.DHCDocCureAssScaleD(ID),7)
	if AssScaleCatID'="" d
	.s DCASCat=$p($g(^DHCDocCT("DefineData",+AssScaleCatID,"D",$p(AssScaleCatID,"||",2))),"^",2)
	s ListData=ID_"^"_AssScaleCode_"^"_AssScaleDesc_"^"_AssScaleHospID_"^"_AssScaleCatID_"^"_DCASCat
	
	Q ListData
}

/// Creator: 	nk
/// CreateDate: 2021-05-20
/// Descript: 	取评定量表维护表Html
/// Input:      
/// Output:
/// w ##class(DHCDoc.DHCDocCure.AssScaleConfig).GetAssScaleTabHtml("1","")
ClassMethod GetAssScaleTabHtml(ID As %String, ScaleCode As %String = "") As %String
{
	s TabHtml=""
	Q:(ID="")&&(ScaleCode="") TabHtml
	i ID="" s ID=$o(^User.DHCDocCureAssScaleI("DCASCodeIndex",ScaleCode,""))
	i ID'=""{
		//s TabHtmlStreamNode=$lg(^User.DHCDocCureAssScaleD(ID),8)
		//s:TabHtmlStreamNode'="" TabHtml=$g(^User.DHCDocCureAssScaleS(TabHtmlStreamNode,1))
		s obj=##class(User.DHCDocCureAssScale).%OpenId(ID,0,.sc)
		if $IsObject(obj){
			s TabHtml=obj.DCASHtmlStream.Read()
		}
	}
	Q TabHtml
}

/// Descript:    自动生成表单ID
/// Input:       EpisodeID - 就诊ID
/// Output: 
/// w ##Class(DHCDoc.DHCDocCure.AssScaleConfig).GetFormEleID("24")
ClassMethod GetFormEleID(ID As %String) As %String
{
   	s Code=$lg(^User.DHCDocCureAssScaleD(ID),2)
   	if Code=""{
		Q ""   
	}else{
   		Q $i(^User.DHCDocCureAssScaleI("AssScale_ElementID",Code))
	}
}

/// Descript:查询评定量表
Query QryAssScale(Code As %String = "", Desc As %String = "", HospID As %String = "") As %Query(ROWSPEC = "ID:%String,DCASCode:%String,DCASDesc:%String,DCASHtml:%String,DCASLockFlag:%String,DCASCat:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.AssScaleConfig","QryAssScale")
ClassMethod QryAssScaleExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", HospID As %String = "") As %Status
{
	s ind=0
	s Code=$ZCVT(Code,"U")
	s Desc=$ZCVT(Desc,"U")
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHC_DocCureAssScale",HospID,+$H)
	s ID=""
	for{
		s ID=$o(^User.DHCDocCureAssScaleD(ID))	
		Q:ID=""
		s DCASHospID=$lg(^User.DHCDocCureAssScaleD(ID),6)
		s HospShowDataFlag=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_DocCureAssScale",ID,HospID)
		continue:HospShowDataFlag="N"
		s DCASCode=$lg(^User.DHCDocCureAssScaleD(ID),2)
		if Code'=""{
			continue:$ZCVT(DCASCode,"U")'[Code
		}
		s DCASDesc=$lg(^User.DHCDocCureAssScaleD(ID),3)
		if Desc'=""{
			continue:$ZCVT(DCASDesc,"U")'[Desc
		}
		s DCASHtml=$lg(^User.DHCDocCureAssScaleD(ID),4)
		s DCASLockFlag=$lg(^User.DHCDocCureAssScaleD(ID),5)
		s DCASCat=""
		s DCASCatID=$lg(^User.DHCDocCureAssScaleD(ID),7)
		if DCASCatID'="" d
 		.s DCASCat=$p($g(^DHCDocCT("DefineData",+DCASCatID,"D",$p(DCASCatID,"||",2))),"^",2)
		d OutputAssScale
	}
	Quit $$$OK 
OutputAssScale
	set Data=$lb(ID,DCASCode,DCASDesc,DCASHtml,DCASLockFlag,DCASCat)
 	set qHandle($I(ind))=Data
	quit
}

ClassMethod QryAssScaleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAssScaleExecute ]
{
	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

/// Descript:查询评定量表
Query QryAssScaleTree(Code As %String = "", Desc As %String = "", HospID As %String = "", ScaleCat As %String = "") As %Query(ROWSPEC = "ID,DCASCode,DCASDesc,DCASCat,_parentId:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.AssScaleConfig","QryAssScaleTree","","",2)
ClassMethod QryAssScaleTreeExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", HospID As %String = "", ScaleCat As %String = "") As %Status
{
	s ind=0
	s Code=$ZCVT(Code,"U")
	s Desc=$ZCVT(Desc,"U")
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHC_DocCureAssScale",HospID,+$H)
	s rset=##class(%ResultSet).%New("web.PilotProject.DHCDocPilotProject:FindDefineData")
	do rset.Execute("治疗工作站","治疗评定量表分类")
	s columns = rset.GetColumnCount()
	While (rset.Next()) {
		s DCASCatID=rset.GetData(3)
		s DCASCatCode=rset.GetData(2)
		s DCASCat=rset.GetData(1)
		continue:(ScaleCat'="")&&(ScaleCat'=DCASCatID)
		
		set Data=$lb($replace(DCASCatID,"||","-"),"",DCASCat,"","")
 		set qHandle($I(ind))=Data
 	
		s ID=""
		for{
			s ID=$o(^User.DHCDocCureAssScaleI("DCASCatIndex"," "_DCASCatID,ID))
			Q:ID=""
			s DCASHospID=$lg(^User.DHCDocCureAssScaleD(ID),6)
			s HospShowDataFlag=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_DocCureAssScale",ID,HospID)
			continue:HospShowDataFlag="N"
			s DCASCode=$lg(^User.DHCDocCureAssScaleD(ID),2)
			if Code'=""{
				continue:$ZCVT(DCASCode,"U")'[Code
			}
			s DCASDesc=$lg(^User.DHCDocCureAssScaleD(ID),3)
			if Desc'=""{
				continue:$ZCVT(DCASDesc,"U")'[Desc
			}	
			d OutputAssScale
		}
	}
	Quit $$$OK 
OutputAssScale
	set Data=$lb(ID,DCASCode,DCASDesc,DCASCat,$replace(DCASCatID,"||","-"))
 	set qHandle($I(ind))=Data
	quit
}

ClassMethod QryAssScaleTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAssScaleTreeExecute ]
{
	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

/// Descritp:	类型
/// w ##Class(DHCDoc.DHCDocCure.AssScaleConfig).GetAssScaleCat()
ClassMethod GetAssScaleCat() As %String
{
	s Stream=##class(%Stream.GlobalCharacter).%New()
	k TmpArr
	s rset=##class(%ResultSet).%New("web.PilotProject.DHCDocPilotProject:FindDefineData")
	do rset.Execute("治疗工作站","治疗评定量表分类")
	s columns = rset.GetColumnCount()
	s row=0
	While (rset.Next()) {
		s id=rset.GetData(3)
		s desc=rset.GetData(1)
		s row=row+1
		s TmpArr(row)=id_"^"_desc
	}

	d Stream.Write("[")
	s index="", count=0
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s ListData=$g(TmpArr(index))
	.s count = count+1
	.i count=1 D
	..d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonData("value^text",ListData))
	.e  D
	..d Stream.Write(","_##class(DHCDoc.DHCDocCure.Util).getJsonData("value^text",ListData))
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descritp:	类型
/// w ##Class(DHCDoc.DHCDocCure.AssScaleConfig).JsRelType()
ClassMethod JsRelType() As %String
{
	s Stream=##class(%Stream.GlobalCharacter).%New()
	s TmpArr(1)="^"
	k TmpArr
	d Stream.Write("[")
	s index="", count=0
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s ListData=$g(TmpArr(index))
	.s count = count+1
	.i count=1 D
	..d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonData("value^text",ListData))
	.e  D
	..d Stream.Write(","_##class(DHCDoc.DHCDocCure.Util).getJsonData("value^text",ListData))
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descript:根据量表设置ID删除量表设置表
ClassMethod DelAssScaleSet(ID As %String)
{
	Q:ID="" 0
	&sql(delete from SQLUser.DHC_DocCureAssScaleSet where DCASS_RowID=:ID)
	s ret=SQLCODE
	Q ret
}

/// Descript:保存量表设置
/// Input:ID-评定量表ID Key-保存要素，CTLOC(评定科室) ARCIM(关联收费医嘱项) ConfigIdStr-配置信息
/// Output:0 成功 ；非0 失败
ClassMethod SaveAssScaleSet(ID As %String, Key As %String, ConfigIdStr As %String, HospID As %String = "")
{
	s ^tmplog("SaveAssScaleSet")=$lb(ID,Key,ConfigIdStr,HospID)
	q:ID="" "-100"
	s ret=0
	Ts
	if Key="CTLOC"{
		&sql(delete from SQLUser.DHC_DocCureAssScaleSet where DCASS_ParRef_Dr=:ID and DCASS_key=:Key and DCASS_Hosp_Dr=:HospID)
		s ret=SQLCODE
	}else{
		
	}
	s:ret=100 ret=0
	if ret{
		Tro
		s ret="-101"
	}else{
		s len=$l(ConfigIdStr,"^")
		for loop=1:1:len{
			s Value=$p(ConfigIdStr,"^",loop)
			continue:Value=""
			s FindSameVale=0
			if Key="ARCIM"{
				if $d(^User.DHCDocCureAssScaleSetI("DCASSkeyHospValueIndex"," "_Key,HospID," "_Value,ID)){
					s FindSameVale=1	
				}
			}
			if FindSameVale=1{
				Tro
				s ret="-103"
				Q	
			}
			
			k PLIST
			s PLIST(0)=ID
			s PLIST(2)=Key
			s PLIST(3)=Value	
			s PLIST(4)=HospID		
			&sql(insert into SQLUser.DHC_DocCureAssScaleSet values :PLIST())
			if SQLCODE{
				Tro
				s ret="-102"
				Q
			}
		}
	}
	if ret=0{
		Tc	
	}
	Q ret
}

ClassMethod CheckAssScaleSetLoc(Loc As %String, AssScaleID As %String, HospID As %String = "")
{
	s ret=0
	if ($g(HospID)="")&&($d(%session)) s HospID=%session.Get("LOGON.HOSPID")
	Q:(Loc="")!(AssScaleID="")!(HospID="") ret
	if $d(^User.DHCDocCureAssScaleSetI("DCASSkeyHospValueIndex"," CTLOC",HospID," "_Loc,AssScaleID)){
		s ret=1	
	}
	Q ret
}

Query FindLoc(Loc As %String, Hospital As %String, AssScaleID As %String, OpenForAllHosp As %String = "") As %Query(ROWSPEC = "LocRowID:%String,LocDesc:%String,LocContactName:%String,selected:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.AssScaleConfig","FindLoc","","2","1")
ClassMethod FindLocExecute(ByRef qHandle As %Binary, Loc As %String, Hospital As %String, AssScaleID As %String, OpenForAllHosp As %String = "") As %Status
{
	s ^tmplog("FindLocExecute")=$lb(Loc,Hospital,AssScaleID,OpenForAllHosp)
	s ind=0
	s Loc=$ZCVT(Loc,"U")
	s rowid=0 f  s rowid=$o(^CTLOC(rowid)) q:rowid=""  d
	.q:(##class(DHCDoc.DHCDocCure.Apply).GetCureLocFlag(rowid,"","",Hospital)'=1)
	.s CTWardFlag=$p($g(^CTLOC(rowid)),"^",5)
	.s CTHosp=$p($g(^CTLOC(rowid)),"^",22)
	.Q:(Hospital'="")&&(Hospital'=CTHosp)
	.s CTDesc=$p($g(^CTLOC(rowid)),"^",2)
	.s CTDesc=$ZCVT(CTDesc,"U")
	.s CTCode=$p($g(^CTLOC(rowid)),"^",1)
	.;用作放助记码的地方
	.s CTContactName=$p($g(^CTLOC(rowid)),"^",43)
	.s CTContactName=$ZCVT(CTContactName,"U")
	.if CTContactName="" s CTContactName=CTCode
	.Q:(Loc'="")&&((CTDesc'[(Loc))&&(CTContactName'[(Loc)))
	.s selected=0
	.s selected=..CheckAssScaleSetLoc(rowid,AssScaleID,Hospital)
	.Do OutputRowFindLoc
	Quit $$$OK
OutputRowFindLoc
	set Data=$lb(rowid,CTDesc,CTContactName,selected)
 	set qHandle($I(ind))=Data
	quit
}

ClassMethod FindLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocExecute ]
{
	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

Query FindArcim(AssScaleID As %String = "", Hospital As %String = "", OpenForAllHosp As %String = "") As %Query(ROWSPEC = "ID:%String,ArcimID:%String,arcitmcode:%String,arcitmdesc:%String,arcitmprice:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.AssScaleConfig","FindArcim","1","2")
ClassMethod FindArcimExecute(ByRef qHandle As %Binary, AssScaleID As %String = "", Hospital As %String = "", OpenForAllHosp As %String = "") As %Status
{
	s ^tmplog("FindLocExecute")=$lb(AssScaleID,Hospital,OpenForAllHosp)
	s ind=0
	s ArcimID=""
	for{
		s ArcimID=$o(^User.DHCDocCureAssScaleSetI("DCASSkeyValueIndex"," ARCIM",ArcimID))
		Q:ArcimID=""
		s ChildSub=""
		for{
			s ChildSub=$o(^User.DHCDocCureAssScaleSetI("DCASSkeyValueIndex"," ARCIM",ArcimID,AssScaleID,ChildSub))
			Q:ChildSub=""
			continue:'$d(^User.DHCDocCureAssScaleD(AssScaleID,"ChildDHCDocCureAssScaleSet",ChildSub))
			s itmmastid=$lg(^User.DHCDocCureAssScaleD(AssScaleID,"ChildDHCDocCureAssScaleSet",ChildSub),3)
			s HospDr=$lg(^User.DHCDocCureAssScaleD(AssScaleID,"ChildDHCDocCureAssScaleSet",ChildSub),4)
			continue:(Hospital'="")&&(HospDr'=Hospital)
			s itmmastver=$p(itmmastid,"||",2)
			s arcitmcode=$p(^ARCIM(+itmmastid,itmmastver,1),"^",1) //医嘱项代码
			s arcitmdesc=$p(^ARCIM(+itmmastid,itmmastver,1),"^",2) //医嘱项名称
			s arcitmprice=##Class(web.UDHCJFPRICE).GetOrderPrice("","",itmmastid,+$h,"","","","",Hospital)
			s arcitmprice=$fn(+$p(arcitmprice,"^"),"N") 					//医嘱项价格
			s ID=AssScaleID_"||"_ChildSub
			Do OutputRow
		}
	}
	Quit $$$OK
OutputRow
	set Data=$lb(ID,itmmastid,arcitmcode,arcitmdesc,arcitmprice)
 	set qHandle($I(ind))=Data
	quit
}

ClassMethod FindArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcimExecute ]
{
	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

/// Descript:查询评定量表并导出数据
Query QryAssScaleToExcel(ExportID As %String = "", HospID As %String = "") As %Query(ROWSPEC = "DCASCode:%String,DCASDesc:%String,DCASHtml:%String,DCASLockFlag:%String,DCASCatCode:%String,DCASCat:%String,DCASTabHtml:%String,DCASHospID:%String,DCASElementID:%String,mListData:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.AssScaleConfig","QryAssScaleToExcel",2)
ClassMethod QryAssScaleToExcelExecute(ByRef qHandle As %Binary, ExportID As %String = "", HospID As %String = "") As %Status
{
	s ind=0
	;s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	;s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHC_DocCureAssScale",HospID,+$H)
	s ID=""
	for{
		s ID=$o(^User.DHCDocCureAssScaleD(ID))	
		Q:ID=""
		s DCASHospID=$lg(^User.DHCDocCureAssScaleD(ID),6)
		;s HospShowDataFlag=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_DocCureAssScale",ID,HospID)
		;continue:HospShowDataFlag="N"
		continue:(ExportID'="")&&(("^"_ExportID_"^")'[("^"_ID_"^"))
		s DCASCode=$lg(^User.DHCDocCureAssScaleD(ID),2)
		s DCASDesc=$lg(^User.DHCDocCureAssScaleD(ID),3)
		s DCASDesc=DCASDesc_$c(1)_DCASCode
		s DCASHtml=$lg(^User.DHCDocCureAssScaleD(ID),4)
		s DCASLockFlag=$lg(^User.DHCDocCureAssScaleD(ID),5)
		s (DCASCatCode,DCASCat)=""
		s DCASCatID=$lg(^User.DHCDocCureAssScaleD(ID),7)
		if DCASCatID'="" d
		.s DCASCatCode=$p($g(^DHCDocCT("DefineData",+DCASCatID,"D",$p(DCASCatID,"||",2))),"^",1)
 		.s DCASCat=$p($g(^DHCDocCT("DefineData",+DCASCatID,"D",$p(DCASCatID,"||",2))),"^",2)
 		s DCASCat=DCASCat_$c(1)_DCASCatCode
		s DCASTabHtml=""
		//s TabHtmlStreamNode=$lg(^User.DHCDocCureAssScaleD(ID),8)
		//s:TabHtmlStreamNode'="" DCASTabHtml=$g(^User.DHCDocCureAssScaleS(TabHtmlStreamNode,1))
		s obj=##class(User.DHCDocCureAssScale).%OpenId(ID,0,.sc)
		if $IsObject(obj){
			s DCASTabHtml=obj.DCASHtmlStream.Read()
		}
		s DCASTabHtml=$replace(DCASTabHtml,$c(9),"$9$")
		s DCASTabHtml=$replace(DCASTabHtml,$c(10),"$10$")
		s DCASTabHtml=$replace(DCASTabHtml,$c(13),"$13$")
		s DCASTabHtml=$replace(DCASTabHtml,",","，")
		s DCASTabHtml=$replace(DCASTabHtml,"  ","")
		;s DCASTabHtml=##class(ext.util.String).EvalJSON(DCASTabHtml)
		s DCASElementID=$g(^User.DHCDocCureAssScaleI("AssScale_ElementID",DCASCode))
		
		s mListData=""
		s ChildSub="" for{
			s ChildSub=$o(^User.DHCDocCureAssScaleD(ID,"ChildDHCDocCureAssScaleForm",ChildSub))
			Q:ChildSub=""
			s CopyKey=$lg(^User.DHCDocCureAssScaleD(ID,"ChildDHCDocCureAssScaleForm",ChildSub),2)
			s CopyTex=$lg(^User.DHCDocCureAssScaleD(ID,"ChildDHCDocCureAssScaleForm",ChildSub),3)
			s CopyType=$lg(^User.DHCDocCureAssScaleD(ID,"ChildDHCDocCureAssScaleForm",ChildSub),4)
			s ListData=CopyKey_$c(1)_CopyTex_$c(1)_CopyType
			if mListData=""{
				s mListData=ListData	
			}else{
				s mListData=mListData_$c(2)_ListData	
			}
		}
		d OutputAssScale
		
	}
	Quit $$$OK 
OutputAssScale
	set Data=$lb(DCASCode,DCASDesc,DCASHtml,DCASLockFlag,DCASCatCode,DCASCat,DCASTabHtml,DCASHospID,DCASElementID,mListData)
 	set qHandle($I(ind))=Data
	quit
}

ClassMethod QryAssScaleToExcelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAssScaleToExcelExecute ]
{
	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

/// creator:倪康
/// createdate:20200723
/// description:用于后台导出评定量表相关信息
/// windows路径命令:w ##class(DHCDoc.DHCDocCure.AssScaleConfig).AssScaleToExcel("d:\AssScaleToExcel.xls")
/// 小机路径命令:w ##class(DHCDoc.DHCDocCure.AssScaleConfig).AssScaleToExcel("","/tmp/AssScaleToExcel.xls")
/// 导出excel到对应服务器目录查找
/// input:文件路径
ClassMethod AssScaleToExcel(filename)
{
	q:filename="" "无路径!"
	s num=1
 	o filename:"WNS"
 	u filename
	s rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.AssScaleConfig:QryAssScaleToExcel")
	do rset.Execute("")
	s columns = rset.GetColumnCount()
	s row=0
	While (rset.Next()) {
		;ID:%String,DCASCode:%String,DCASDesc:%String,DCASHtml:%String,DCASLockFlag:%String,DCASCatCode:%String,DCASCat:%String,DCASTabHtml:%String,DCASHospID:%String,DCASElementID:%String,mListData:%String
		s DCASCode=rset.GetDataByName("DCASCode")
		s DCASDesc=rset.GetDataByName("DCASDesc")
		s DCASHtml=rset.GetDataByName("DCASHtml")
		s DCASLockFlag=rset.GetDataByName("DCASLockFlag")
		s DCASCatCode=rset.GetDataByName("DCASCatCode")
		s DCASCat=rset.GetDataByName("DCASCat")
		s DCASTabHtml=rset.GetDataByName("DCASTabHtml")
		s DCASHospID=rset.GetDataByName("DCASHospID")
		s DCASElementID=rset.GetDataByName("DCASElementID")
		s mListData=rset.GetDataByName("mListData")
		s row=row+1
		i row=1{
 			w "量表代码"_$c(9)_"量表名称"_$c(9)_"量表表单Html"_$c(9)_"加锁标志"_$c(9)_"所属分类代码"_$c(9)_"所属分类名称"_$c(9)_"量表表单Html流"_$c(9)_"院区ID"_$c(9)_"当前表单ID序号"_$c(9)_"量表表单元素"
		}
		s outputdata=DCASCode_$c(9)_DCASDesc_$c(9)_DCASHtml_$c(9)_DCASLockFlag_$c(9)_DCASCatCode_$c(9)_DCASCat_$c(9)_DCASTabHtml_$c(9)_DCASHospID_$c(9)_DCASElementID_$c(9)_mListData
 		s outputdata=$tr(outputdata,$c(13,10),"")
 		w !,outputdata
	}
 	c filename
    q "导出完成!"
}

/// CTOR:   nk
/// DATE:   2021-07-23
/// DESC:   治疗医嘱项批量导入Excel
/// INPUT:  量表代码
/// 		量表名称
/// 		量表表单Html
/// 		加锁标志
/// 		所属分类代码
/// 		所属分类名称
/// 		量表表单Html流
/// 		院区ID
/// 		当前表单ID序号
/// 		量表表单元素信息串 元素ID_$c(2)_元素描述_$c(2)_元素类型_$c(1)_元素ID_$c(2)_元素描述_$c(2)_元素类型_$c(1)_...
/// OUTPUT: SQLCODE
/// DEBUG:  w ##class(DHCDoc.DHCDocCure.AssScaleConfig).ImportFromExcel(^tmp("data",1),"94")
ClassMethod ImportFromExcel(excelStr As %String, DefineRowId As %String, ExpStr As %String = "") As %String
{
	s ImportHospName=""
	s ImportHospId=$p(ExpStr,"^",1) //导入院区
	s:ImportHospId'="" ImportHospName=$p(^CT("HOSP",ImportHospId),"^",2)
	s Hospital=$p(excelStr,"^",8)
	if Hospital="" s Hospital=ImportHospId
	s $p(excelStr,"^",8)=Hospital
	
	s InPara=excelStr
	s InPara=$replace(InPara,"^""","^")
	s InPara=$replace(InPara,"""^","^")
    s DCASCode=$p(InPara,"^",1)
    Q:DCASCode="" "-1^量表代码不能为空!"
    s DCASID=$o(^User.DHCDocCureAssScaleI("DCASCodeIndex",DCASCode,""))
    s Desc=$p(InPara,"^",2)
    s DCASDesc=$p(Desc,$c(1),1)
    Q:DCASDesc="" "-1^量表描述不能为空!"
    s DCASHtml=$p(InPara,"^",3)
    s DCASLockFlag=$p(InPara,"^",4)
    s CatCode=$p(InPara,"^",5)
    s CatDesc=$p(InPara,"^",6)
    s CatID=##class(User.DHCDocCTDefineData).GetIdByCode(CatCode,DefineRowId)
    Q:CatID="" "-1^未获取到对应的量表分类ID!"
    
    s DCASTabHtml=$p(InPara,"^",7)
    s DCASTabHtml=$replace(DCASTabHtml,"$9$",$c(9))
    s DCASTabHtml=$replace(DCASTabHtml,"$10$",$c(10))
    s DCASTabHtml=$replace(DCASTabHtml,"$13$",$c(13))
    s DCASTabHtml=$replace(DCASTabHtml,"""""","""")
   
    s HospID=$p(InPara,"^",8)
    s DCASElementID=$p(InPara,"^",9)
    s mListData=$p(InPara,"^",10)
    s mListData=$tr(mListData,$c(1),"^")
    s mListData=$tr(mListData,$c(2),"@")
    s myRtn=0
    Ts
	s ret=##Class(DHCDoc.DHCDocCure.AssScaleConfig).Insert(DCASID, DCASCode, DCASDesc , CatID , HospID)
    if +ret<0{
	    TRO 1
	    s myRtn="-1^插入量表主表失败,错误信息:"_$case(ret,"-1":"表单代码不能重复","-2":"表单名称不能重复",:ret)
	}else{
		s DCASID=+ret
		s ret=##Class(DHCDoc.DHCDocCure.AssScaleConfig).InsHtml(DCASID,DCASTabHtml,mListData)
		if +ret<0{
		    TRO 1
		    s myRtn="-1^插入量表表单数据失败,错误信息:"_$case(ret,"-11":"插入评定量表维护表Html失败","-12":"删除相关字表内容重新插入失败","-13":"插入评定量表表单元素失败",:ret)
		}else{
			TC
			s ^User.DHCDocCureAssScaleI("AssScale_ElementID",DCASCode)=DCASElementID
		}	
	}
	
	
    q myRtn
}

/// CTOR:   nk
/// DATE:   2021-07-23
/// DESC:   治疗评定量表批量导入Excel
/// DEBUG:  w ##class(DHCDoc.DHCDocCure.AssScaleConfig).ImportTotalExcel("D:\assscale.xlsx")
ClassMethod ImportTotalExcel(ByRef excelStrArr, ExpStr As %String = "", IgnoreRepeat As %String = "") As %String
{
	m ^tmp("data")=excelStrArr
	s mDefineRowId=""
	s ModuleRowId=""
	f  s ModuleRowId=$o(^DHCDocCT("Module",ModuleRowId)) Q:ModuleRowId=""  d
	.s ModuleDesc=$p($g(^DHCDocCT("Module",ModuleRowId)),"^",1)
	.q:ModuleDesc'="治疗工作站"
	.s CTDefineRowId=""
	.f  s CTDefineRowId=$o(^DHCDocCTi(0,"Define","ModuleDR",ModuleRowId,CTDefineRowId)) q:CTDefineRowId=""  d
	..s Define=$p($g(^DHCDocCT("Define",CTDefineRowId)),"^",2)
	..q:Define'="治疗评定量表分类"
	..s mDefineRowId=CTDefineRowId
	Q:mDefineRowId="" "-1^未获取到治疗评定量表分类"
	s findRepeat=0,RepeatCodeStr=""
	if IgnoreRepeat'="Y"{
		s loop=0
		for{
			s loop=$o(excelStrArr(loop))
			q:loop=""
			s excelStr=excelStrArr(loop)
			s totalLen=$l(excelStr,"!")
				
			f tloop=1:1:totalLen {
				s cInput = $p(excelStr,"!",tloop)
				s DCASCode=$p(cInput,"^",1)
			    continue:DCASCode=""
			    s Desc=$p(cInput,"^",2)
	    		s DCASDesc=$p(Desc,$c(1),1)
			    s DCASID=$o(^User.DHCDocCureAssScaleI("DCASCodeIndex",DCASCode,""))
			    if DCASID'=""{
				    s findRepeat=1
				    if RepeatCodeStr="" s RepeatCodeStr=DCASCode
				    else  s RepeatCodeStr=RepeatCodeStr_","_DCASCode
				}
			}
		}
	}
	Q:findRepeat=1 "Repeat^"_RepeatCodeStr
	
	
    Ts
	s mRtn=0
	s loop=0
	for{
		s loop=$o(excelStrArr(loop))
		q:loop=""
		s excelStr=excelStrArr(loop)
		s totalLen=$l(excelStr,"!")
		
		f tloop=1:1:totalLen {
			s cInput = $p(excelStr,"!",tloop)
			s rtn=..ImportFromExcel(cInput,mDefineRowId,ExpStr)
			i rtn'=0{
				s mRtn=$p(cInput,"^",1)_","_$p(cInput,"^",2)_","_rtn
			}
			q:rtn'=0 
		}
		q:mRtn'=0 
	}
	if mRtn=0{
		Tc
	}else{
		Tro	
	}
	
    q mRtn
}

}
