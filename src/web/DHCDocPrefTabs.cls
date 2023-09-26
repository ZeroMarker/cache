/// @author: wanghc
/// @date:   2012/7/25
/// desc: 导入导出模版
Class web.DHCDocPrefTabs Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

/*
tanjishan 2019-05-23 使用说明
--------------
1、医嘱模板
	查询:d ##class(%ResultSet).RunQuery("web.DHCDocPrefTabs","FindPrefTabs","User.CTLoc","9")
	导出:d ##Clas(web.DHCDocPrefTabs).ExportPreferenceXls()
	导出目录:D:\DtHealth\app\dthis\web\\temp\excel\*OrdTemplate.xls
	导入:d ##Clas(web.DHCDocPrefTabs).ImportPreferenceXls()
2、诊断模板
	查询:d ##class(%ResultSet).RunQuery("web.DHCDocPrefTabs","FindDiagTemp","User.CTLoc","9")
	导出:d ##Clas(web.DHCDocPrefTabs).ExportDiagTempXls()
	导出目录:D:\DtHealth\app\dthis\web\\temp\excel\*DiagTemp.xls
	导入:d ##Clas(web.DHCDocPrefTabs).ImportDiagTempXls()
3、医嘱套
	查询:d ##class(%ResultSet).RunQuery("web.DHCDocPrefTabs","FindARCOS","User.CTLoc","9")
	导出:d ##Clas(web.DHCDocPrefTabs).ExportARCOSXls()
	导出目录:D:\DtHealth\app\dthis\web\\temp\excel\*ARCOS.xls
	导入:d ##Clas(web.DHCDocPrefTabs).ImportARCOSXls()
4、用户常用信息
	查询:d ##class(%ResultSet).RunQuery("web.DHCDocPrefTabs","FindDocItemDefault","User.CTLoc","9")
	导出:d ##Clas(web.DHCDocPrefTabs).ExportDocItemDefaultXls()
	导出目录:D:\DtHealth\app\dthis\web\\temp\excel\*DocItemDefault.xls
	导入:d ##Clas(web.DHCDocPrefTabs).ImportDocItemDefaultXls()
*/
/// 查询医嘱模版	
Query FindPrefTabs(objtype, objvalue, paramKey As %String = "", HospRowId = "") As websys.Query(CONTAINID = 0, ROWSPEC = "HospDesc,FavCatType,TypeValue,TypeValueDesc,TypeValueCode,Cat,SubCat,ItemType,ItemID,ItemDesc,PartCodeInfo,itemNotes")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocPrefTabs","FindPrefTabs","User.SSUser","10209")
/// d ##class(%ResultSet).RunQuery("web.DHCDocPrefTabs","FindPrefTabs","User.CTLoc","9")
ClassMethod FindPrefTabsExecute(ByRef QHandle As %Library.Binary, objtype, objvalue, paramKey As %String = "", HospRowId = "") As %Library.Status
{
	s objtype=$ZCVT(objtype,"U")
	s paramKey=$ZCVT(paramKey,"U")
	Set langid=..%LanguageID()
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s iCatType="" f  s iCatType=$O(^User.ARCOrdFavCatI("IndexSequece",iCatType)) Q:iCatType=""  d
	.s CatType=$TR(iCatType," ")
	.s Type=$ZCVT($P(CatType,"|",1),"U")
	.q:(objtype'="")&&(objtype'=Type)
	.s iTypeValue="" f  s iTypeValue=$O(^User.ARCOrdFavCatI("IndexSequece",iCatType,iTypeValue)) Q:iTypeValue=""  d
	..s TypeValue=$TR(iTypeValue," ")
	..q:(objvalue'="")&&(objvalue'=$ZCVT(TypeValue,"U"))
	..s CONTEXT=$ZCVT($P(CatType,"|",2),"U")
	..q:(paramKey'="")&&(paramKey'=CONTEXT)
	..i Type="USER.SSUSER" d
	...s TypeValueDesc=$p($g(^SSU("SSUSR",+TypeValue)),"^",2),TypeValueCode=$p($g(^SSU("SSUSR",+TypeValue)),"^",1)
	...s TypeValueDesc =##class(User.SSUser).GetTranByDesc("SSUSRName",TypeValueDesc,langid)
	..e  i Type="USER.CTLOC"'="" d 
	...s TypeValueDesc=$p($g(^CTLOC(+TypeValue)),"^",2),TypeValueCode=$p($g(^CTLOC(+TypeValue)),"^",1)
	...s TypeValueDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",TypeValueDesc,langid)
	..e  d
	...s TypeValueDesc=$p($g(^CT("HOSP",+TypeValue)),"^",2),TypeValueCode=$p($g(^CT("HOSP",+TypeValue)),"^",1)
	...s TypeValueDesc=##class(User.CTHospital).GetTranByDesc("HOSPDesc",TypeValueDesc,langid)
	..s CatSeq="" f  s CatSeq=$O(^User.ARCOrdFavCatI("IndexSequece",iCatType,iTypeValue,CatSeq)) Q:CatSeq=""  d
	...s CatID=0  f  s CatID=$O(^User.ARCOrdFavCatI("IndexSequece",iCatType,iTypeValue,CatSeq,CatID)) Q:CatID=""  d
	....s HospID=##class(DHCDoc.Order.Fav).GetCatHospID(CatID)
	....q:(HospRowId'="")&&(HospRowId'=HospID)
	....s HospDesc=$P($G(^CT("HOSP",+HospID)),"^",2)
	....s HospDesc=##class(User.CTHospital).GetTranByDesc("HOSPDesc",HospDesc,langid)
	....s Cat=$LG(^User.ARCOrdFavCatD(CatID),4)
	....s FavCatType=$LG(^User.ARCOrdFavCatD(CatID),2)
	....s SubSeq="" f  s SubSeq=$O(^User.ARCOrdFavSubCatI("IndexSequece",CatID,SubSeq)) Q:SubSeq=""  d
	.....s SubCatID=0 f  s SubCatID=$O(^User.ARCOrdFavSubCatI("IndexSequece",CatID,SubSeq,SubCatID)) Q:SubCatID=""  d
	......s SubCat=$LG(^User.ARCOrdFavSubCatD(SubCatID),3)
	......s ItemSeq="" f  s ItemSeq=$O(^User.ARCOrdFavItemI("IndexSequece",SubCatID,ItemSeq)) Q:ItemSeq=""  d
	.......s FavItemID=0 f  s FavItemID=$O(^User.ARCOrdFavItemI("IndexSequece",SubCatID,ItemSeq,FavItemID)) Q:FavItemID=""  d
	........s ItemID=$LG(^User.ARCOrdFavItemD(FavItemID),3)
	........i ItemID["||" d
	.........s ItemDesc=$P(^ARCIM(+ItemID,1,1),"^",2),ItemType="ARCIM",isValid=##class(web.DHCDocOrderEntry).ValARCItem(ItemID)
	.........s ItemDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ItemDesc,langid)
	........e  s ItemDesc=$P(^ARCOS(ItemID),"^",2),ItemType="ARCOS",isValid=##class(web.DHCDocOrderEntry).ValARCOS(ItemID)
	........q:isValid
	........s PartCodeInfo=$LG(^User.ARCOrdFavItemD(FavItemID),7)
	........s PartInfo=##Class(web.DHCAPPExaReportQuery).GetPartLabel(PartCodeInfo)
	........s:PartInfo'="" ItemDesc=ItemDesc_PartInfo
	........s itemNotes=$LG(^User.ARCOrdFavItemD(FavItemID),6)
	........s:itemNotes'="" ItemDesc=ItemDesc_"["_itemNotes_"]"
	........s ^CacheTemp(repid,ind)=$lb(HospDesc,FavCatType,TypeValue,TypeValueDesc,TypeValueCode,Cat,SubCat,ItemType,ItemID,ItemDesc,PartCodeInfo,itemNotes)
	........s ind=ind+1
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// 把部位ID转化成部位代码
/// w ##Class(web.DHCDocPrefTabs).GetPartCodeInfo("9B3A12B^2")
ClassMethod GetPartCodeInfo(ListData As %String) As %String
{
	s ListCode=""
	if (ListData=""){
		q ListCode
	}
	s mPartList=$p(ListData,"^",1)  /// 部位串
	s DispID=$p(ListData,"^",2)     /// 后处理
	s DispCode=$p($g(^DHCAPDIM(+DispID)),"^",1) 	 ///后处理描述
	s HospID=$p($g(^DHCAPDIM(+DispID)),"^",4)
	s mPartCode=""
	F m=1:1:$L(mPartList,"A") D
	.s mdata=$p(mPartList,"A",m)
	.q:mdata=""
	.s PartID=$p(mdata,"B",1)       /// 部位ID
    .s PartCode=$p(^DHCAPPART(PartID),"^",1)   /// 部位描述
	.s mPosiIDs=$p(mdata,"B",2)      /// 体位ID串
	.s mPosiCodes=""
	.F n=1:1:$L(mPosiIDs,",") D
	..s PosiID=$p(mPosiIDs,",",n)
	..q:PosiID=""
	..s PosiCode=$p(^DHCAPPOS(PosiID),"^",1)   /// 体位
	..i mPosiCodes="" s mPosiCodes=PosiCode
	..e  s mPosiCodes=mPosiCodes_","_PosiCode
	.
	.i mPartCode="" s mPartCode=PartCode_"B"_mPosiCodes
	.e  s mPartCode=mPartCode_"A"_PartCode_"B"_mPosiCodes
	s $P(ListCode,"^",1)=mPartCode
	s $P(ListCode,"^",2)=DispCode
	s $P(ListCode,"^",3)=HospID
	Q ListCode
}

/// 把部位代码转化成部位id
/// w ##Class(web.DHCDocPrefTabs).GetPartDataInfo("颅脑B003A鼻咽B^002^2")
ClassMethod GetPartDataInfo(ListCode As %String) As %String
{
	s $ZT="GetPartDataInfoErr"
	s ListData=""
	q:(ListCode="") ListData
	s mPartCode=$p(ListCode,"^",1)  /// 部位串
	s DispCode=$p(ListCode,"^",2)     /// 后处理
	s HospID=$p(ListCode,"^",3)
	if (DispCode'=""){
		s DispID=$O(^DHCAPDIM(0,"Code",DispCode,HospID,""))
	}else{
		s DispID=""
	}
	s mPartList=""
	F m=1:1:$L(mPartCode,"A") D
	.s mdata=$p(mPartCode,"A",m)
	.q:mdata=""
	.s PartCode=$p(mdata,"B",1)
	.s PartID=""       /// 部位ID
    .s:PartCode'="" PartID=$O(^DHCAPPART(0,"Code",PartCode,0))
	.s mPosiCodes=$p(mdata,"B",2)      /// 体位ID串
	.s mPosiIDs=""
	.F n=1:1:$L(mPosiCodes,",") D
	..s PosiCode=$p(mPosiCodes,",",n)
	..q:PosiCode=""
	..s PosiID=$O(^DHCAPPOS(0,"Code",PosiCode,HospID,0))
	..i mPosiIDs="" s mPosiIDs=PosiID
	..e  s mPosiIDs=mPosiIDs_","_PosiID
	.
	.i mPartList="" s mPartList=PartID_"B"_mPosiIDs
	.e  s mPartList=mPartList_"A"_PartID_"B"_mPosiIDs
	s $P(ListData,"^",1)=mPartList
	s $P(ListData,"^",2)=DispID
	Q ListData
GetPartDataInfoErr
	q ""
}

Query FindObjValue(Type, value, HospId As %String = "") As websys.Query(CONTAINID = 0, ROWSPEC = "objValue:%String:描述,objCode:%String:代码,objId")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocPrefTabs","FindObjValue","User.CTLoc")
ClassMethod FindObjValueExecute(ByRef QHandle As %Library.Binary, Type, value, HospId As %String = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i Type="" Set QHandle=$lb(0,repid,0) Quit $$$OK
	Set langid=..%LanguageID()
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s value=$$ALPHAUP^SSUTIL4(value)
	s Type=$ZCVT(Type,"U")
	s iCatType="" f  s iCatType=$O(^User.ARCOrdFavCatI("IndexSequece",iCatType)) Q:iCatType=""  d
	.s CatType=$TR(iCatType," ")
	.s objtype=$ZCVT($P(CatType,"|",1),"U")
	.q:(objtype'=Type)
	.s iTypeValue="" f  s iTypeValue=$O(^User.ARCOrdFavCatI("IndexSequece",iCatType,iTypeValue)) Q:iTypeValue=""  d
	..s TypeValue=$TR(iTypeValue," ")
	..q:TypeValue=""
	..s CatSeq="" f  s CatSeq=$O(^User.ARCOrdFavCatI("IndexSequece",iCatType,iTypeValue,CatSeq)) Q:CatSeq=""  d
	...s CatID=0  f  s CatID=$O(^User.ARCOrdFavCatI("IndexSequece",iCatType,iTypeValue,CatSeq,CatID)) Q:CatID=""  d
	....s HospID=##class(DHCDoc.Order.Fav).GetCatHospID(CatID)
	....q:(HospID'="")&&(HospId'=HospID)
	....s ValueLIST(TypeValue)=""
	s objId="" for{
		s objId=$O(ValueLIST(objId)) Q:objId=""
		i Type="USER.SSUSER" d
		.s objValue=$p($g(^SSU("SSUSR",objId)),"^",2),objCode=$p($g(^SSU("SSUSR",objId)),"^",1)
		.s objValue =##class(User.SSUser).GetTranByDesc("SSUSRName",objValue,langid)
		e  i Type="USER.CTLOC" d
		.s objValue=$p($g(^CTLOC(objId)),"^",2),objCode=$p($g(^CTLOC(objId)),"^",43)
		.s objValue=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",objValue,langid)
		e  d
		.s objValue=$p($g(^CT("HOSP",objId)),"^",2),objCode=$p($g(^CT("HOSP",objId)),"^",1)
		.s objValue=##class(User.CTHospital).GetTranByDesc("HOSPDesc",objValue,langid)
		Set ^CacheTemp(repid,ind)=$lb(objValue,objCode,objId)
		Set ind=ind+1
	}
	/*
	s objId = "" 
	for  set objId = $o(^websys.PreferencesI("Index",Type,objId)) q:objId=""  d
	.q:(Type="User.SSUser")&&('$d(^SSU("SSUSR",objId)))
	.&sql(select id,AppKey into:id,:AppKey from websys.preferences where appsubkey='OEOrder.PrefTabs.EditList' and ObjectType=:Type and ObjectReference=:objId)
	.q:id=""
	.Q:(Type="User.SSUser")&&($p(AppKey,"_",2)'=("HospDr"_HospId))
	.Q:(Type="User.CTLoc")&&($p(^CTLOC(objId),"^",22)'=HospId)
	.i Type="User.SSGroup" &SQL(SELECT SSGRP_Desc,SSGRP_Desc INTO:valueDesc,:valueCode FROM SQLUSER.SS_Group WHERE SSGRP_Rowid=:objId )
	.i Type="User.SSUser" &SQL(SELECT SSUSR_Name,SSUSR_Initials INTO:valueDesc ,:valueCode FROM SQLUSER.SS_User WHERE SSUSR_Rowid=:objId )
	.i Type="User.CTLoc" &SQL(SELECT CTLOC_Desc ,CTLOC_Code INTO:valueDesc,:valueCode FROM SQLUSER.CT_Loc WHERE CTLOC_Rowid=:objId)
	.i Type="User.CTHospital" &SQL(SELECT HOSP_Desc,HOSP_Code INTO:valueDesc,:valueCode  FROM SQLUSER.CT_Hospital WHERE HOSP_Rowid=:objId )
	.i Type="User.PACTrust" &SQL(SELECT TRUST_Desc,TRUST_Code INTO:valueDesc,:valueCode FROM SQLUSER.PAC_Trust WHERE TRUST_Rowid=:objId )
	.i Type="SITE" s valueDesc="DHCHEALTH",valueCode="DHCHEALTH"
	.q:($$ALPHAUP^SSUTIL4(valueDesc)'[value)&&($$ALPHAUP^SSUTIL4(valueCode)'[value)&&(value'="")&&(Type'="User.CTLoc")
	.q:(Type="User.CTLoc")&&(##class(web.DHCOPAdmReg).CheckLocDesc(objId,value)'=1)
	.Set ^CacheTemp(repid,ind)=$lb(valueDesc,valueCode,objId)
	.Set ind=ind+1
	*/
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// d ##class(web.DHCDocPrefTabs).ExportALLTxt()
ClassMethod ExportAllTxt()
{
	s rs = ##class(%ResultSet).%New("web.DHCDocPrefTabs:FindPrefTabs")
	s objtype=""
	for  {
		S objtype = $o(^websys.PreferencesI("Index", objtype))		
		q:objtype=""
		&sql(select count(1) into:count from websys.Preferences where appsubkey='OEOrder.PrefTabs.EditList' and objecttype=:objtype )
		continue:count=0
		continue:count=""
		Set file=##class(%File).%New("PrefTabs_"_$tr(objtype,".","_")_".txt")
		Do file.Open("WSN")
		Do file.WriteLine("类型描述	类型代码	类型	应用代码	EPR图表	EPR图表尺寸	表名	列名	医嘱或医嘱套	药品描述	药品代码	不显示别名	别名和代码一致则不显示别名")
		s objvalue=""
		for {
			set objvalue = $o(^websys.PreferencesI("Index",objtype,objvalue))
			q:objvalue=""
			do rs.Execute(objtype,objvalue)
			s len = rs.GetColumnCount()
			while(rs.%Next()){
				s str=rs.GetData(1)
				for i=2:1:len s str=str_$c(9)_rs.GetData(i)
				Do file.WriteLine(str)
			}			
			d rs.%Close()
		}
		do file.Close()
		do file.%Close()
	}
	q 1
}

/// d ##class(web.DHCDocPrefTabs).ExportTxt("User.CTLoc","194")
/// d ##class(web.DHCDocPrefTabs).ExportTxt("User.SSUser","11")
ClassMethod ExportTxt(objtype, objvalue)
{
	q:objtype="" 1
	q:objvalue="" 1
	s rs = ##class(%ResultSet).%New("web.DHCDocPrefTabs:FindPrefTabs")
	Set file=##class(%File).%New("PrefTabs_"_$tr(objtype,".","_")_objvalue_".txt")
	Do file.Open("WSN")
	Do file.WriteLine("类型描述	类型代码	类型	应用代码	EPR图表	EPR图表尺寸	表名	列名	医嘱或医嘱套	药品描述	药品代码	不显示别名	别名和代码一致则不显示别名")
	do rs.Execute(objtype,objvalue)
	s len = rs.GetColumnCount()
	while(rs.%Next()){
		s str=rs.GetData(1)
		for i=2:1:len s str=str_$c(9)_rs.GetData(i)
		Do file.WriteLine(str)
	}			
	d rs.%Close()		
	do file.Close()
	do file.%Close()
	q 1
}

/// d ##class(web.DHCDocPrefTabs).ImportTxt("PrefTabs_User_SSGroup.txt")
/// 类型描述	类型代码	类型	应用代码	EPR图表	EPR图表尺寸	表名	列名	医嘱或医嘱套	药品描述	药品代码	不显示别名	别名和代码一致则不显示别名
ClassMethod ImportTxt(fileName)
{
	Set flag=##class(%File).Exists(fileName)
	w:'flag fileName_" not exists "
	q:'flag 1
	k ^TempError("PrefTabs")
	k ^SavePrefercenes("ORDER")
	s ch9 = $c(9)
	s ch4 = $c(4)	
	set file = ##class(%File).%New()
	s file.Name=fileName	
	Do file.Open("RWS")
	while('file.AtEnd){
		set lineItem = file.ReadLine()
		set typedesc = $p(lineItem,ch9,1)
		set typecode = $p(lineItem,ch9,2)
		continue:typecode=""
		set Type = $p(lineItem,ch9,3)
		set TypeRef=""
		i Type="User.SSGroup" &SQL(SELECT SSGRP_Rowid INTO:TypeRef FROM SQLUSER.SS_Group WHERE SSGRP_Desc=:typecode )
		i Type="User.SSUser" &SQL(SELECT SSUSR_Rowid INTO:TypeRef FROM SQLUSER.SS_User WHERE SSUSR_Initials=:typecode )
		i Type="User.CTLoc" &SQL(SELECT CTLOC_Rowid INTO:TypeRef FROM SQLUSER.CT_Loc WHERE CTLOC_Code=:typecode )
		i Type="User.CTHospital" &SQL(SELECT HOSP_Rowid INTO:TypeRef FROM SQLUSER.CT_Hospital WHERE HOSP_Code=:typecode )
		i Type="User.PACTrust" &SQL(SELECT TRUST_Desc INTO:TypeRef FROM SQLUSER.PAC_Trust WHERE TRUST_Code=:typecode )
		i Type="SITE" s TypeRef=typecode //"DHCHEALTH"
		s:TypeRef="" ^TempError("PrefTabs","ErrorType",Type,typecode)=typecode
		continue:TypeRef=""
		set appkey = $p(lineItem,ch9,4)			//ORDERW50008 应用代码
		continue:appkey=""
		set EPRChartCode = $p(lineItem,ch9,5)	//EPR图表
		set EPRChartId = ""
		&sql(select ID INTO:EPRChartId from epr.Chart where Name =:EPRChartCode)
		set EPRChartSize = $p(lineItem,ch9,6)	//EPR图表尺寸
		set Tab=$p(lineItem,ch9,7)				//表名
		continue:Tab=""
		set Col=$p(lineItem,ch9,8) //列名
		continue:Col=""
		set ARCIMorARCOS = $p(lineItem,ch9,9)
		set Desc=$p(lineItem,ch9,10) 							//药品描述
		set Code=$p(lineItem,ch9,11) //药品代码
		continue:Code=""
		s:ARCIMorARCOS="" ARCIMorARCOS="ARCIM"
		if ARCIMorARCOS="ARCIM" {
			set ArcimId = $O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
			if (ArcimId'=""){				
				set ArcV  = $O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code),ArcimId,""))
				set ArcimId=ArcimId_"||"_ArcV 
			}
		} elseif (ARCIMorARCOS="ARCOS"){
			set ArcimId = $o(^ARCOS(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
		}
		s:+ArcimId=0 ^TempError("PrefTabs","ErrorArcim",ARCIMorARCOS,Code)=Desc
		continue:+ArcimId=0
		set NoShowAlias=$p(lineItem,ch9,12) //不显示别名,
		set NoShowAliasSameCode=$p(lineItem,ch9,13) //别名和代码一致则不显示别名
		s Data=""
		s ^SavePrefercenes("ORDER",Type,TypeRef,appkey,"OEOrder.PrefTabs.EditList")=$lb(EPRChartId,EPRChartSize,Data,NoShowAlias,NoShowAliasSameCode)
		S COUNT=$I(^SavePrefercenes("ORDER",Type,TypeRef,appkey,"OEOrder.PrefTabs.EditList",Tab,Col))
		s ^SavePrefercenes("ORDER",Type,TypeRef,appkey,"OEOrder.PrefTabs.EditList",Tab,Col,COUNT)=ARCIMorARCOS_ch4_ArcimId
	}
	d ..Save()
	q 1
}

ClassMethod Save()
{
	s Type=""
	for  {
		set Type=$O(^SavePrefercenes("ORDER",Type))
		q:Type=""
		set TypeRef=""
		for{
			set TypeRef = $O(^SavePrefercenes("ORDER",Type,TypeRef))
			q:TypeRef=""
			set appkey=""
			for {
				set appkey = $O(^SavePrefercenes("ORDER",Type,TypeRef,appkey))
				q:appkey=""
				set id=$O(^websys.PreferencesI("Index",Type,TypeRef,appkey,"OEOrder.PrefTabs.EditList",""))		
				i (id=""){
					s obj = ##class(websys.Preferences).%New()
				}else{
					s obj = ##class(websys.Preferences).%OpenId(id)
				}
				s Data = ..getData(Type,TypeRef,appkey)
				s obj.AppKey = appkey
				s obj.AppSubKey = "OEOrder.PrefTabs.EditList"
				s obj.Data=Data
				s obj.ObjectType = Type
				s obj.ObjectReference = TypeRef
				d obj.%Save()
				;w "prefercenes.id = "_obj.%Id(),!
			}
		} 
	}
	q 1
}

ClassMethod getData(Type, TypeRef, appkey)
{
	s ch1 = $c(1)
	s ch28 = $c(28)
	s TabList=""
	s Tab=""				
	for{						
		s Tab=$o(^SavePrefercenes("ORDER",Type,TypeRef,appkey,"OEOrder.PrefTabs.EditList",Tab))		
		q:Tab=""
		s TabItem=Tab
		s Col=""
		for{
			s Col=$o(^SavePrefercenes("ORDER",Type,TypeRef,appkey,"OEOrder.PrefTabs.EditList",Tab,Col))
			q:Col=""
			s TabItem=TabItem_ch1_Col
			s count = $o(^SavePrefercenes("ORDER",Type,TypeRef,appkey,"OEOrder.PrefTabs.EditList",Tab,Col,""),-1)			
			for i=1:1:count {
				s TabItem=TabItem_ch28_^SavePrefercenes("ORDER",Type,TypeRef,appkey,"OEOrder.PrefTabs.EditList",Tab,Col,i)
			}
		}
		s $list(TabList,($listlength(TabList)+1))=TabItem
	}
	s $list(^SavePrefercenes("ORDER",Type,TypeRef,appkey,"OEOrder.PrefTabs.EditList"),3)=TabList
	q ^SavePrefercenes("ORDER",Type,TypeRef,appkey,"OEOrder.PrefTabs.EditList")
}

/// Creator:      彭春桥
/// CreatDate:    2014.09.04
/// Description:: 取医嘱模版数据
/// Table:        websys.Preferences
/// Input:        
/// Output:         
/// Return:       
/// Others:       w ##class(web.DHCDocPrefTabs).GetOETabItems("User.SSUser",13069,"ORDERWNewOrderEntryO_HospDr2")
ClassMethod GetOETabItems(objtype As %String, objvalue As %String, Key As %String = "") As %String
{
	s ^tempscl("GetOETabItems")=objtype_","_objvalue_","_Key
	s i=1
	k ^GetOETabItems("ORDER")	
	s ^GetOETabItems("ORDER",objtype,objvalue)=""
	s websysPrefId=""
	s rs = ##class(%ResultSet).%New("web.DHCDocPrefTabs:FindPrefTabs")
	do rs.Execute(objtype,objvalue)
	while(rs.%Next()){
		//valueDesc:%String:类型描述,valueCode:%String:类型代码,Type:%String:类型,
		//AppKey:%String:应用代码,EPRChartCode:%String:EPR图表,
		//EPRChartSize:%String:EPR图表尺寸,Tab:%String:表名,Col:%String:列名,
		//ARCIMorARCOS:%String:医嘱或医嘱套,Desc:%String:药品描述,Code:%String:药品代码
		//,NoShowAlias:%String:不显示别名,NoShowAliasSameCode:%String:别名和代码一致则不显示别名
		s valueDesc=rs.GetDataByName("valueDesc")
		s AppKey=rs.GetDataByName("AppKey")
		//不导按工作流保存的
		//continue:((Key="")&&(AppKey'="ORDER"))
		//按工作流 如 Key=ORDERW50008
		continue:((Key'="")&&(AppKey'=Key))
		
		s Type=rs.GetDataByName("Type")
		s Tab=rs.GetDataByName("Tab")
		s Col=rs.GetDataByName("Col")
		s itemrowid=rs.GetDataByName("itemrowid")
		s ARCIMorARCOS=rs.GetDataByName("ARCIMorARCOS")
		//不导出医嘱套
		//continue:ARCIMorARCOS="ARCOS"
		s Desc=rs.GetDataByName("Desc")
		s Code=rs.GetDataByName("Code")
		s Index=rs.GetDataByName("Index")
		s OrdItemNotes=rs.GetDataByName("OrdItemNotes")
		
		s tabIndex=..FormateIndex($p(Index,"||",1))
		s ColIndex=..FormateIndex($p(Index,"||",2))
		s CodeIndex=..FormateIndex($p(Index,"||",3))
		s Tab=tabIndex_"!"_Tab
		s websysPrefId=rs.GetDataByName("websysPrefId")
		s ^GetOETabItems("ORDER",objtype,objvalue,Tab,ColIndex_"!"_Col,CodeIndex_"!"_Code)=valueDesc_"^"_Type_"^"_Tab_"^"_Col_"^"_ARCIMorARCOS_"^"_Code_"^"_Desc_"^"_itemrowid_"^"_websysPrefId_"^"_OrdItemNotes

	}	
	d rs.%Close()
	if (websysPrefId="")&&(Key'=""){
		s websysPrefId=$o(^websys.PreferencesI("Index", objtype, objvalue, Key, "OEOrder.PrefTabs.EditList", ""))
		Q "!!"_websysPrefId
	}	
	s allTable="",websysPrefId=""
	s Tab=""
	f  s Tab=$o(^GetOETabItems("ORDER",objtype,objvalue,Tab)) q:Tab=""  d
	.//表名
	.s onetabName=$p(Tab,"!",2)
	.s groupsStr=""
	.s Col=""
	.f  s Col=$o(^GetOETabItems("ORDER",objtype,objvalue,Tab,Col)) q:Col=""  d
	..s groupname=$p(Col,"!",2)
	..s onegroupStr=""
	..s Code=""
	..f  s Code=$o(^GetOETabItems("ORDER",objtype,objvalue,Tab,Col,Code)) q:Code=""  d
	...s DESC=$p(^GetOETabItems("ORDER",objtype,objvalue,Tab,Col,Code),"^",7)
	...s Type=$p(^GetOETabItems("ORDER",objtype,objvalue,Tab,Col,Code),"^",5)
	...//q:Type=""
	...s itemrowid=$p(^GetOETabItems("ORDER",objtype,objvalue,Tab,Col,Code),"^",8)
	...s websysPrefId=$p(^GetOETabItems("ORDER",objtype,objvalue,Tab,Col,Code),"^",9)
	...s OrdItemNotes=$p(^GetOETabItems("ORDER",objtype,objvalue,Tab,Col,Code),"^",10)
	...s tepstr=$replace(Code,",","")_$c(4)_DESC_$C(4)_Type_$C(4)_itemrowid_$C(4)_websysPrefId_$C(4)_OrdItemNotes
	...i onegroupStr="" d
	....s onegroupStr=tepstr
	...else  d
	....s onegroupStr=onegroupStr_"^"_tepstr
	..s onegroup=groupname_"::"_onegroupStr
	..i groupsStr="" d
	...s groupsStr=onegroup
	..else  d
	...s groupsStr=groupsStr_$c(28)_onegroup
	.s onetable=onetabName_"@"_groupsStr
	.i allTable="" d
	..s allTable=onetable
	.else  d
	..s allTable=allTable_","_onetable	
	k ^GetOETabItems("ORDER")
	s ^tempscl("allTable")=allTable	
	q allTable_"!!"_websysPrefId
}

ClassMethod FormateIndex(SeqNo)
{
	If $L(SeqNo)=2 Set SeqNo="0"_SeqNo
	If $L(SeqNo)=1 Set SeqNo="00"_SeqNo
	Q SeqNo
}

/// 导出医嘱模版  彭春桥
/// w ##class(web.DHCDocPrefTabs).ExportPreferenceXls("","","ALL","") //ORDERWNewOrderEntryO
/// w ##class(web.DHCDocPrefTabs).ExportPreferenceXls("User.SSUser","11")
/// Set file=##class(%File).%New("\DtHealth\app\dthis\web\temp\componentxml\"_xlsname_"医嘱模版.xls")
ClassMethod ExportPreferenceXls(objtype, objvalue, xlsname As %String = "", paramKey As %String = "") As %String
{
	s ^tempscl("ggg")=objtype_","_objvalue_","_xlsname_","_paramKey
	
	i xlsname="" s xlsname=$tr(objtype,".","_")_objvalue
	s rs = ##class(%ResultSet).%New("web.DHCDocPrefTabs:FindPrefTabs")
	s componentxml ="\\temp\\excel\\"
	s path = ##class(ext.util.String).GetPhysicalPath("",componentxml)
	s path="\"_$p(path,"\",2,$l(path,"\"))
	
	Set PhyDir = ##class(ext.util.String).GetPhysicalPath("",componentxml)
	if ('##class(%File).DirectoryExists(PhyDir)){
		d ##class(%File).CreateDirectory(PhyDir)
	}
	
	Set file=##class(%File).%New(PhyDir_xlsname_"OrdTemplate.xls")
	Do file.Open("NWRS") //WSN
	Do file.WriteLine("*院区代码"_$c(9)_"类型描述"_$c(9)_"*类型代码"_$c(9)_"*类型"_$c(9)_"*应用代码"_$c(9)_"*表名"_$c(9)_"*列名"_$c(9)_"*医嘱或医嘱套"_$c(9)_"项目描述"_$c(9)_"*项目代码 "_$c(9)_"*列索引"_$c(9)_"部位代码列表")
	do rs.Execute(objtype,objvalue,paramKey)
	s len = rs.GetColumnCount()
	while(rs.%Next()){
		s HospCode=rs.GetDataByName("HospCode")
		s valueDesc=rs.GetDataByName("valueDesc")
		s valueCode=rs.GetDataByName("valueCode")
		s AppKey1=rs.GetDataByName("AppKey")
		
		s Type=rs.GetDataByName("Type")
		s Tab=rs.GetDataByName("Tab")
		s Col=rs.GetDataByName("Col")
		s ARCIMorARCOS=rs.GetDataByName("ARCIMorARCOS")
		//不导出医嘱套
		//continue:ARCIMorARCOS="ARCOS"
		s Desc=rs.GetDataByName("Desc")
		s Code=rs.GetDataByName("Code")
		s Index=rs.GetDataByName("Index")
		s Index=$p(Index,"||",1,2)
		s itemrowid=rs.GetDataByName("itemrowid")
		s PartCodeInfo=rs.GetDataByName("PartCodeInfo")
		if (ARCIMorARCOS="ARCOS") s Code=$tr(Code,"-","")
		s str=HospCode_$c(9)_valueDesc_$c(9)_valueCode_$c(9)_Type_$c(9)_AppKey1_$c(9)_Tab_$c(9)_Col_$c(9)_ARCIMorARCOS_$c(9)_Desc_$c(9)_Code_$C(9)_Index_$C(9)_PartCodeInfo
		Do file.WriteLine(str)
	}			
	d rs.%Close()		
	do file.Close()
	do file.%Close()
	q 1
}

/// Creator:      彭春桥
/// CreatDate:    2014.09.04
/// Description:: 导入医嘱模版
/// Table:        websys.Preferences
/// Input:        
/// Output:         
/// Return:       
/// w ##class(web.DHCDocPrefTabs).ImportXls("C:\fakepath\63OrdTemplate.xls","User.SSUser",153,"")
/// "类型描述"_$c(9)_"类型"_$c(9)_"表名"_$c(9)_"列名"_$c(9)_"医嘱或医嘱套"_$c(9)_"药品描述"_$c(9)_"药品代码 "
ClassMethod ImportXlsOld(fileName, objtype, objvalue, Key As %String = "") As %String
{
	s ^temlscl("fff")=fileName_","_objtype_","_objvalue_","_Key
	//上传本地文件到服务器
	s fileName=$p(fileName,"\",$l(fileName,"\"))	
	s componentxml = "\temp\componentxml\"
	s dirname = ##class(ext.util.String).GetPhysicalPath("",componentxml)
	/*s fileStream=##class(%FileBinaryStream).%New()
	s fileStream.Filename =##class(%File).GetFilename(fileName)
	s file = ##class(%FileBinaryStream).%New()
	s file.Filename=dirname_fileStream.Filename
	Do fileStream.Rewind()
	While('fileStream.AtEnd){
		Set bytes = fileStream.Read(1024)
		Do file.Write(bytes)
	}
	Do file.Flush()
	Do file.%Save()
	Do file.%Close()
	d fileStream.Clear()
	s fileStream=""*/
	/*
	s filename = $g(%request.Data("filename",1))
		s pathname = ##class(%File).NormalizeFilename(dirname_"/"_filename)
		if (##class(%File).Exists(pathname)){
			s stream=##class(%FileCharacterStream).%New()
			s stream.Filename=pathname
			d stream.Rewind()
			while('stream.AtEnd){ w stream.ReadLine(),!}
			d stream.Clear()
			s stream=""
			d %response.Flush()	
		}else{
			d %response.Abort()
			w "404 没找到"_dirname_filename_"文件"	
		}
	*/
	Set file=""
	Set flag=##class(%File).Exists(dirname_fileName)
	q:'flag fileName_"服务器文件不存在! "
	q:'flag 1
	k ^TempError("PrefTabs")
	k ^SavePrefercenes("ORDER")
	s ch9 = $c(9)
	s ch4 = $c(4)	
	set file = ##class(%FileCharacterStream).%New() //##class(%File).%New()
	//s file.Name=fileName
	s file.Filename=##class(%File).NormalizeFilename(dirname_"/"_fileName)
	d file.Rewind()	
	//Do file.Open("RWS")
	while('file.AtEnd){
		set lineItem = file.ReadLine()
		set Type = objtype
		set TypeRef=objvalue
		continue:TypeRef=""
		set appkey = "ORDER"			//ORDERW50008 应用代码
		i Key'="" set appkey = Key
		continue:appkey=""
		set EPRChartCode = ""	//EPR图表
		set EPRChartId = ""
		&sql(select ID INTO:EPRChartId from epr.Chart where Name =:EPRChartCode)
		set EPRChartSize = ""	//EPR图表尺寸
		set Tab=$p(lineItem,ch9,3)				//表名
		continue:Tab=""
		set Col=$p(lineItem,ch9,4) //列名
		continue:Col=""
		set ARCIMorARCOS = $p(lineItem,ch9,5)
		set Desc=$p(lineItem,ch9,6) //药品描述
		set Code=$p(lineItem,ch9,7) //药品代码
		continue:Code=""
		s ARCIMorARCOS="ARCIM"
		if ARCIMorARCOS="ARCIM" {
			set ArcimId = $O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
			if (ArcimId'=""){				
				set ArcV  = $O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code),ArcimId,""))
				set ArcimId=ArcimId_"||"_ArcV 
			}
		} elseif (ARCIMorARCOS="ARCOS"){
			set ArcimId = $o(^ARCOS(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
		}
		s:+ArcimId=0 ^TempError("PrefTabs","ErrorArcim",ARCIMorARCOS,Code)=Desc
		continue:+ArcimId=0
		set NoShowAlias="0" //不显示别名,
		set NoShowAliasSameCode="0" //别名和代码一致则不显示别名
		s Data=""
		s ^SavePrefercenes("ORDER",Type,TypeRef,appkey,"OEOrder.PrefTabs.EditList")=$lb(EPRChartId,EPRChartSize,Data,NoShowAlias,NoShowAliasSameCode)
		S COUNT=$I(^SavePrefercenes("ORDER",Type,TypeRef,appkey,"OEOrder.PrefTabs.EditList",Tab,Col))
		s ^SavePrefercenes("ORDER",Type,TypeRef,appkey,"OEOrder.PrefTabs.EditList",Tab,Col,COUNT)=ARCIMorARCOS_ch4_ArcimId
	}
	d ..Save()
	q 1
}

/// 批量导入医嘱模板
/// 谭吉善 2019-05-22
/// w ##class(web.DHCDocPrefTabs).ImportPreferenceXls($LG(^Wqy("ImportPref",2),1),$LG(^Wqy("ImportPref",2),2))
ClassMethod ImportPreferenceXls(Data As %String, LogonHospDr As %String = "") As %String
{
	s LogonHospDr=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospDr)
	;s ^Wqy("ImportPref",$I(^Wqy("ImportPref")))=$LB(Data,LogonHospDr)
	s len=$l(Data,$c(1))
	For i=1:1:len{
		s OneData=$P(Data,$c(1),i)
		s FavCatType=$P(OneData,$C(2),1)
		continue:FavCatType=""
		s TypeValue=$P(OneData,$C(2),2) 
		s Cat=$P(OneData,$C(2),3)
		s SubCat=$P(OneData,$C(2),4) 
		s ItemID=$P(OneData,$C(2),5) 
		s ItemType=$P(OneData,$C(2),8)
		continue:ItemID=""
		if (ItemType="ARCOS"){s ItemID=..GetArcosIdByCode(ItemID)}
		else{s ItemID=..GetArcimIdByCode(ItemID)}
		continue:ItemID=""
		s PartCodeInfo=$P(OneData,$C(2),6)
		s Note=$P(OneData,$C(2),7)
		d ImportCat
		continue:CatID=""
		d ImportSubCat
		continue:SubCatID=""
		d ImportItem
	}
	q 1
ImportCat
	s Type=$P(FavCatType,"|",1)
	s CONTEXT=$P(FavCatType,"|",2)
	s HospID=$P(FavCatType,"|",3)
	s AdmType=$P(FavCatType,"|",4)
	s:+HospID=0 HospID=""
	i Type="User.SSUser" s UserID=TypeValue,LocID=""	;$O(^CTLOC(0,"Hosp",+HospID,0))
	e  i Type="User.CTLoc" s UserID="",LocID=TypeValue
	e  s UserID="",LocID=$O(^CTLOC(0,"Hosp",+TypeValue,0)),HospID=TypeValue
	if (AdmType'="")&&(LocID=""){
		s LocID=$P(..GetUserLogLoc(UserID,AdmType,HospID),"^",1)
	}
	
	;对应的信息 子类
	s TypeObj=##class(DHCDoc.Order.Fav).GetCatTypeData(Type, CONTEXT, LocID, UserID,HospID)
	s CatType=TypeObj.CatType,TypeValue=TypeObj.TypeValue
	Q:Cat=""
	s FindID=$O(^User.ARCOrdFavCatI("IndexName"," "_$ZCVT(CatType,"U")," "_$ZCVT(TypeValue,"U")," "_$ZCVT(Cat,"U"),0))

	s ret=##class(DHCDoc.Order.Fav).SaveCat(Type,CONTEXT,Cat,LocID,UserID,FindID,HospID)
	s CatID=$P(ret,"^",2)
	Q
ImportSubCat
	s FindID=$O(^User.ARCOrdFavSubCatI("IndexName",CatID," "_$ZCVT(SubCat,"U"),0))
	s ret=##class(DHCDoc.Order.Fav).SaveSubCat(CatID,SubCat,UserID,FindID)
	s SubCatID=$P(ret,"^",2)
	Q
ImportItem
	s ret=##class(DHCDoc.Order.Fav).SaveItem(SubCatID,ItemID,UserID,"",Note,PartCodeInfo)
	s ItemID=$P(ret,"^",2)
	Q
}

ClassMethod GetArcimIdByCode(arcimCode As %String)
{
    s arcimId = ""
    q:arcimCode="" arcimId
    s arcimPar = $o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(arcimCode),0))
    s:arcimPar'="" arcimSub = $o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(arcimCode),arcimPar,0))
    if (arcimPar'="")&&(arcimSub '= "") {
        s arcimId = arcimPar_"||"_arcimSub
    }
    q arcimId
}

/// w ##class(web.DHCDocPrefTabs).GetArcosIdByCode("jmsx-jwy")
ClassMethod GetArcosIdByCode(ArcosCode As %String)
{
	s arcosrowid=$O(^ARCOS(0,"Code",$$ALPHAUP^SSUTIL4(ArcosCode),0))
	q arcosrowid
}

ClassMethod GetUserLogLoc(UserID, AdmType = "", HospID = "")
{
	Q:UserID="" ""
	k LocList
	s LocID=$P($G(^SSU("SSUSR",UserID)),"^",4)
	s:LocID'="" LocList(LocID)=""
	s ChildSub=0 for{
		s ChildSub=$O(^SSU("SSUSR",UserID,"OTHLL",ChildSub)) Q:ChildSub=""
		s LocID=$P(^SSU("SSUSR",UserID,"OTHLL",ChildSub),"^",1)
		s:LocID'="" LocList(LocID)=""
	}
	s LocIDStr=""
	s LocID=0 for{
		s LocID=$O(LocList(LocID)) Q:LocID=""
		if AdmType'=""{
			continue:'$D(^PAC("ADMLOC",0,"AdmType",AdmType,LocID))
		}
		if HospID'=""{
			continue:HospID'=$P(^CTLOC(LocID),"^",22)
		}
		i LocIDStr="" s LocIDStr=LocID
		e  s LocIDStr=LocIDStr_"^"_LocID
	}
	Q LocIDStr
}

ClassMethod GetObjectValue(ObjectCode As %String, ObjectType As %String, HospCode As %String = "") As %String
{
	s SQLCODE=0,ObjectValue=""
	if (ObjectCode=""){
		q ""
	}
	if (ObjectType="User.SSUser"){
		s ObjectValue=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(ObjectCode),0))
	}elseif (ObjectType="User.SSGroup"){
		&SQL(SELECT SSGRP_Rowid INTO :ObjectValue FROM SQLUSER.SS_Group WHERE SSGRP_Desc=:ObjectCode )
	}elseif (ObjectType="User.CTLoc"){
		&SQL(SELECT CTLOC_Rowid into:ObjectValue FROM SQLUSER.CT_Loc WHERE CTLOC_Code=:ObjectCode and (CTLOC_Hospital_DR->HOSP_Code=:HospCode OR :HospCode is null) )
	}elseif (ObjectType="User.CTHospital"){
		&SQL(SELECT HOSP_Rowid INTO:ObjectValue  FROM SQLUSER.CT_Hospital WHERE HOSP_Code=:ObjectCode )
	}elseif (ObjectType="User.PACTrust"){
		&SQL(SELECT TRUST_Rowid INTO:ObjectValue FROM SQLUSER.PAC_Trust WHERE TRUST_Code=:ObjectCode )
	}elseif (ObjectType="SITE"){
		s ObjectValue=ObjectCode
	}elseif (ObjectType="User.CTUOM"){
		&SQL(SELECT CTUOM_RowId into:ObjectValue FROM SQLUSER.CT_Uom WHERE CTUOM_Desc=:ObjectCode)
	}
	if (SQLCODE){s ObjectValue=""}
	q ObjectValue
}

/*
"User.SSUser,153,,普通颗粒剂"_$c(2)_"饮片颗粒"_$c(2)_"ARCIM"_$c(2)_"赤芍[1g]"_$c(2)_"C01N024"_$c(1)_"普通颗粒剂"_$c(2)_"中药"_$c(2)_"ARCIM"_$c(2)_"枸杞子[1g]"_$c(2)_"C05N039"_$c(1)_"普通颗粒剂"_$c(2)_"中药"_$c(2)_"ARCIM"_$c(2)_"枫蓼肠胃康颗粒[8g*6袋]"_$c(2)_"Z01N026"_$c(1)_"普通颗粒剂"_$c(2)_"测试"_$c(2)_"ARCIM"_$c(2)_"板蓝根颗粒qq[5g*10袋]"_$c(2)_"Z09N00122"_$c(1)_"普通颗粒剂"_$c(2)_"测试"_$c(2)_"ARCIM"_$c(2)_"感冒清热颗粒[12g*10袋]"_$c(2)_"Z01N002"_$c(1)_"科室模板1"_$c(2)_"列1"_$c(2)_"ARCOS"_$c(2)_"红丝带1号"_$c(2)_"XDCF001"_$c(1)_"模板2"_$c(2)_"列1"_$c(2)_"ARCOS"_$c(2)_"红丝带2号"_$c(2)_"XDCF002"_$c(1)_"sclceshi"_$c(2)_"列1"_$c(2)_"ARCIM"_$c(2)_"复方甘草片[力生][100片]"_$c(2)_"H05N001"_$c(1)_"常用"_$c(2)_"医嘱套"_$c(2)_"ARCOS"_$c(2)_"门诊肝病初诊常规"_$c(2)_"YZT3035"_$c(1)_"常用"_$c(2)_"医嘱套"_$c(2)_"ARCOS"_$c(2)_"门诊肝病复诊常规"_$c(2)_"YZT3034"_$c(1)_"常用"_$c(2)_"西药"_$c(2)_"ARCIM"_$c(2)_"葡萄糖注射液[百特][10%100ml]"_$c(2)_"H21N005"_$c(1)_"常用"_$c(2)_"西药"_$c(2)_"ARCIM"_$c(2)_"利巴韦林片[100mg*24片]"_$c(2)_"H15N001"_$c(1)_"常用"_$c(2)_"西药"_$c(2)_"ARCIM"_$c(2)_"卡马西平片[得理多][200mg*30片]"_$c(2)_"H03N012"_$c(1)_"常用"_$c(2)_"西药"_$c(2)_"ARCOS"_$c(2)_"祛湿凉血解毒方"_$c(2)_"XDCF028"_$c(1)_"常用"_$c(2)_"检验"_$c(2)_"ARCIM"_$c(2)_"全血细胞分析(18项以上指标)(血常规)(门/急)"_$c(2)_"HY0125"_$c(1)_"常用"_$c(2)_"检验"_$c(2)_"ARCIM"_$c(2)_"*乙肝e抗原"_$c(2)_"HY0287"_$c(1)_"常用"_$c(2)_"检验"_$c(2)_"ARCIM"_$c(2)_"乙肝病毒定量(HBV-DNA)"_$c(2)_"HY0160"_$c(1)_"常用"_$c(2)_"检查"_$c(2)_"ARCIM"_$c(2)_"彩超(肝胆脾)"_$c(2)_"WL0075"_$c(1)_"常用"_$c(2)_"检查"_$c(2)_"ARCIM"_$c(2)_"彩超(肝胆脾胰腹水)"_$c(2)_"WL0086"_$c(1)_"常用"_$c(2)_"检查"_$c(2)_"ARCIM"_$c(2)_"送常规病理"_$c(2)_"BLSH001"_$c(1)_"常用"_$c(2)_"治疗"_$c(2)_"ARCIM"_$c(2)_"下颌关节脱位*"_$c(2)_"ZL0226"_$c(1)_"常用"_$c(2)_"治疗"_$c(2)_"ARCIM"_$c(2)_"一般穿刺"_$c(2)_"ZL0233"_$c(1)_"化验"_$c(2)_"三大常规"_$c(2)_"ARCIM"_$c(2)_"全血细胞分析(五分类)(血常规)"_$c(2)_"HY0155"_$c(1)_"化验"_$c(2)_"三大常规"_$c(2)_"ARCIM"_$c(2)_"尿10项仪器检验(尿常规)"_$c(2)_"HY0074"_$c(1)_"化验"_$c(2)_"三大常规"_$c(2)_"ARCIM"_$c(2)_"粪便常规+潜血"_$c(2)_"HY1029"_$c(1)_"化验"_$c(2)_"三大常规"_$c(2)_"ARCIM"_$c(2)_"悬滴标本检查(02动力+制动)"_$c(2)_"HY0061"_$c(1)_"化验"_$c(2)_"病原学检查"_$c(2)_"ARCIM"_$c(2)_"甲丁戊肝系列"_$c(2)_"HY1054"_$c(1)_"化验"_$c(2)_"病原学检查"_$c(2)_"ARCIM"_$c(2)_"丙肝病毒抗体"_$c(2)_"HY0199"_$c(1)_"化验"_$c(2)_"病原学检查"_$c(2)_"ARCIM"_$c(2)_"进口乙肝系列-1(乙肝五项)"_$c(2)_"HY1051"_$c(1)_"化验"_$c(2)_"病原学检查"_$c(2)_"ARCIM"_$c(2)_"*乙肝e抗原"_$c(2)_"HY0287"_$c(1)_"化验"_$c(2)_"影像学检查"_$c(2)_"ARCIM"_$c(2)_"彩超(肝胆脾胰腹水)"_$c(2)_"WL0086"_$c(1)_"化验"_$c(2)_"影像学检查"_$c(2)_"ARCIM"_$c(2)_"特需彩超(多系统)"_$c(2)_"WL0146"_$c(1)_"化验"_$c(2)_"影像学检查"_$c(2)_"ARCIM"_$c(2)_"特需彩超(单系统)"_$c(2)_"WL0141"_$c(1)_"化验"_$c(2)_"生化"_$c(2)_"ARCIM"_$c(2)_"肝功I(肝功(全)/心肌酶/PreALB/ADA)"_$c(2)_"HY1044"_$c(1)_"化验"_$c(2)_"生化"_$c(2)_"ARCIM"_$c(2)_"甲胎蛋白(进口试剂)"_$c(2)_"HY0151"_$c(1)_"化验"_$c(2)_"免疫学"_$c(2)_"ARCIM"_$c(2)_"尿HCG早孕测定"_$c(2)_"HY0163"_$c(1)_"化验"_$c(2)_"免疫学"_$c(2)_"ARCIM"_$c(2)_"绒毛膜促性腺激素"_$c(2)_"HY0167"_$c(1)_"化验"_$c(2)_"免疫学"_$c(2)_"ARCIM"_$c(2)_"自身抗体(自身免疫性肝病7项)"_$c(2)_"HY1068"_$c(1)_"西药"_$c(2)_"保肝药"_$c(2)_"ARCIM"_$c(2)_"护肝片[葵花][0.36g*100片]"_$c(2)_"Z01N030"_$c(1)_"西药"_$c(2)_"保肝药"_$c(2)_"ARCIM"_$c(2)_"护肝颗粒[2g*12袋]"_$c(2)_"Z01N115"
*/

// w ##class(web.DHCDocPrefTabs).ImportXls("User.CTLoc","56","ORDERWNewOrderEntry",$g(^tempscl("ImportXls")))

ClassMethod ImportOnePreferenceData(objtype, objvalue, Key As %String = "", lineItem As %String) As %String
{
	s ^tempscl("ImportXls")=lineItem
	;s lineItem="普通颗粒剂"_$c(2)_"饮片颗粒"_$c(2)_"ARCIM"_$c(2)_"赤芍[1g]"_$c(2)_"C01N024"_$c(1)_"普通颗粒剂"_$c(2)_"中药"_$c(2)_"ARCIM"_$c(2)_"枸杞子[1g]"_$c(2)_"C05N039"_$c(1)_"普通颗粒剂"_$c(2)_"中药"_$c(2)_"ARCIM"_$c(2)_"枫蓼肠胃康颗粒[8g*6袋]"_$c(2)_"Z01N026"_$c(1)_"普通颗粒剂"_$c(2)_"测试"_$c(2)_"ARCIM"_$c(2)_"板蓝根颗粒qq[5g*10袋]"_$c(2)_"Z09N00122"_$c(1)_"普通颗粒剂"_$c(2)_"测试"_$c(2)_"ARCIM"_$c(2)_"感冒清热颗粒[12g*10袋]"_$c(2)_"Z01N002"_$c(1)_"科室模板1"_$c(2)_"列1"_$c(2)_"ARCOS"_$c(2)_"红丝带1号"_$c(2)_"XDCF001"_$c(1)_"模板2"_$c(2)_"列1"_$c(2)_"ARCOS"_$c(2)_"红丝带2号"_$c(2)_"XDCF002"_$c(1)_"sclceshi"_$c(2)_"列1"_$c(2)_"ARCIM"_$c(2)_"复方甘草片[力生][100片]"_$c(2)_"H05N001"_$c(1)_"常用"_$c(2)_"医嘱套"_$c(2)_"ARCOS"_$c(2)_"门诊肝病初诊常规"_$c(2)_"YZT3035"_$c(1)_"常用"_$c(2)_"医嘱套"_$c(2)_"ARCOS"_$c(2)_"门诊肝病复诊常规"_$c(2)_"YZT3034"_$c(1)_"常用"_$c(2)_"西药"_$c(2)_"ARCIM"_$c(2)_"葡萄糖注射液[百特][10%100ml]"_$c(2)_"H21N005"_$c(1)_"常用"_$c(2)_"西药"_$c(2)_"ARCIM"_$c(2)_"利巴韦林片[100mg*24片]"_$c(2)_"H15N001"_$c(1)_"常用"_$c(2)_"西药"_$c(2)_"ARCIM"_$c(2)_"卡马西平片[得理多][200mg*30片]"_$c(2)_"H03N012"_$c(1)_"常用"_$c(2)_"西药"_$c(2)_"ARCOS"_$c(2)_"祛湿凉血解毒方"_$c(2)_"XDCF028"_$c(1)_"常用"_$c(2)_"检验"_$c(2)_"ARCIM"_$c(2)_"全血细胞分析(18项以上指标)(血常规)(门/急)"_$c(2)_"HY0125"_$c(1)_"常用"_$c(2)_"检验"_$c(2)_"ARCIM"_$c(2)_"*乙肝e抗原"_$c(2)_"HY0287"_$c(1)_"常用"_$c(2)_"检验"_$c(2)_"ARCIM"_$c(2)_"乙肝病毒定量(HBV-DNA)"_$c(2)_"HY0160"_$c(1)_"常用"_$c(2)_"检查"_$c(2)_"ARCIM"_$c(2)_"彩超(肝胆脾)"_$c(2)_"WL0075"_$c(1)_"常用"_$c(2)_"检查"_$c(2)_"ARCIM"_$c(2)_"彩超(肝胆脾胰腹水)"_$c(2)_"WL0086"_$c(1)_"常用"_$c(2)_"检查"_$c(2)_"ARCIM"_$c(2)_"送常规病理"_$c(2)_"BLSH001"_$c(1)_"常用"_$c(2)_"治疗"_$c(2)_"ARCIM"_$c(2)_"下颌关节脱位*"_$c(2)_"ZL0226"_$c(1)_"常用"_$c(2)_"治疗"_$c(2)_"ARCIM"_$c(2)_"一般穿刺"_$c(2)_"ZL0233"_$c(1)_"化验"_$c(2)_"三大常规"_$c(2)_"ARCIM"_$c(2)_"全血细胞分析(五分类)(血常规)"_$c(2)_"HY0155"_$c(1)_"化验"_$c(2)_"三大常规"_$c(2)_"ARCIM"_$c(2)_"尿10项仪器检验(尿常规)"_$c(2)_"HY0074"_$c(1)_"化验"_$c(2)_"三大常规"_$c(2)_"ARCIM"_$c(2)_"粪便常规+潜血"_$c(2)_"HY1029"_$c(1)_"化验"_$c(2)_"三大常规"_$c(2)_"ARCIM"_$c(2)_"悬滴标本检查(02动力+制动)"_$c(2)_"HY0061"_$c(1)_"化验"_$c(2)_"病原学检查"_$c(2)_"ARCIM"_$c(2)_"甲丁戊肝系列"_$c(2)_"HY1054"_$c(1)_"化验"_$c(2)_"病原学检查"_$c(2)_"ARCIM"_$c(2)_"丙肝病毒抗体"_$c(2)_"HY0199"_$c(1)_"化验"_$c(2)_"病原学检查"_$c(2)_"ARCIM"_$c(2)_"进口乙肝系列-1(乙肝五项)"_$c(2)_"HY1051"_$c(1)_"化验"_$c(2)_"病原学检查"_$c(2)_"ARCIM"_$c(2)_"*乙肝e抗原"_$c(2)_"HY0287"_$c(1)_"化验"_$c(2)_"影像学检查"_$c(2)_"ARCIM"_$c(2)_"彩超(肝胆脾胰腹水)"_$c(2)_"WL0086"_$c(1)_"化验"_$c(2)_"影像学检查"_$c(2)_"ARCIM"_$c(2)_"特需彩超(多系统)"_$c(2)_"WL0146"_$c(1)_"化验"_$c(2)_"影像学检查"_$c(2)_"ARCIM"_$c(2)_"特需彩超(单系统)"_$c(2)_"WL0141"_$c(1)_"化验"_$c(2)_"生化"_$c(2)_"ARCIM"_$c(2)_"肝功I(肝功(全)/心肌酶/PreALB/ADA)"_$c(2)_"HY1044"_$c(1)_"化验"_$c(2)_"生化"_$c(2)_"ARCIM"_$c(2)_"甲胎蛋白(进口试剂)"_$c(2)_"HY0151"_$c(1)_"化验"_$c(2)_"免疫学"_$c(2)_"ARCIM"_$c(2)_"尿HCG早孕测定"_$c(2)_"HY0163"_$c(1)_"化验"_$c(2)_"免疫学"_$c(2)_"ARCIM"_$c(2)_"绒毛膜促性腺激素"_$c(2)_"HY0167"_$c(1)_"化验"_$c(2)_"免疫学"_$c(2)_"ARCIM"_$c(2)_"自身抗体(自身免疫性肝病7项)"_$c(2)_"HY1068"_$c(1)_"西药"_$c(2)_"保肝药"_$c(2)_"ARCIM"_$c(2)_"护肝片[葵花][0.36g*100片]"_$c(2)_"Z01N030"_$c(1)_"西药"_$c(2)_"保肝药"_$c(2)_"ARCIM"_$c(2)_"护肝颗粒[2g*12袋]"_$c(2)_"Z01N115"
	s ch9 = $c(9)
	s ch4 = $c(4)
	set Type = objtype
    set TypeRef=objvalue
    q:TypeRef="" 0
	set appkey = "ORDER"			//ORDERW50008 应用代码
	i Key'="" set appkey = Key
	set EPRChartCode = ""	//EPR图表
	set EPRChartId = ""
	&sql(select ID INTO:EPRChartId from epr.Chart where Name =:EPRChartCode)
	set EPRChartSize = ""	//EPR图表尺寸
	set id=$O(^websys.PreferencesI("Index",Type,TypeRef,appkey,"OEOrder.PrefTabs.EditList",""))
	set id=$O(^websys.PreferencesI("Index",Type,TypeRef,appkey,"OEOrder.PrefTabs.EditList",""))
    i (id=""){
		s obj = ##class(websys.Preferences).%New()
	}else{
		s obj = ##class(websys.Preferences).%OpenId(id)
		s OldPreferList=obj.Data
		s OldPreferList=$list(OldPreferList,3)
		s OldPreferData=$LISTTOSTRING(OldPreferList,",",1)
	}
	k PreferIndexArr
	k PreferDataArr
	s TabNameIdex=0
	s ColNameIdex=0
	For i=1:1:$l(lineItem,$c(1)) {
		set onelineItem=$p(lineItem,$c(1),i)
		set Tab=$p(onelineItem,$c(2),1)				//表名
		set Col=$p(onelineItem,$c(2),2) 			//列名
		set ARCIMorARCOS =$p(onelineItem,$c(2),3)	//类型
		set Code=$p(onelineItem,$c(2),5) 			//药品代码
		set Index=$p(onelineItem,$c(2),6)
		set itemrowid=$p(onelineItem,$c(2),7)
		set PartData=$p(onelineItem,$c(2),8)
		set TabIndex=$p(Index,"||",1)
		set ColIndex=$p(Index,"||",2)
		continue:Code=""
		if ARCIMorARCOS="ARCIM" {
			if (itemrowid'=""){
				s ArcimId=itemrowid
			}else{
				set ArcimId = $O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
				if (ArcimId'=""){				
					set ArcV  = $O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code),ArcimId,""))
					set ArcimId=ArcimId_"||"_ArcV 
				}
			}
			if (PartData'=""){
				s ArcimId=ArcimId_"*S*"_$replace(PartData,"^","*")
			}
			
		}else{
			if (itemrowid'=""){
				s ArcimId=itemrowid
			}else{
				set Code=$tr(Code,"-","")
				set ArcimId = $o(^ARCOS(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
			}
		}
		continue:ArcimId=""
		s Tab=Tab_"$"_TabIndex //防止表明重复，无法判断
		s Col=Col_"$"_Index //防止列明为空，无法判断
		s Tab=$replace(Tab,",",".")
		s Col=$replace(Col,",",".")
		if ($D(PreferIndexArr(Tab))){
			s TabNameNum=$G(PreferIndexArr(Tab))
		}else{
			s TabNameIdex=TabNameIdex+1
			s TabNameNum=TabNameIdex
			s PreferIndexArr(Tab)=TabNameNum
		}
		
		if ($D(PreferIndexArr(Tab,Col))){
			s ColNameNum=$G(PreferIndexArr(Tab,Col))
		}else{
			s ColNameIdex=ColNameIdex+1
			s ColNameNum=ColNameIdex
			s PreferIndexArr(Tab,Col)=ColNameNum
		}
		if ('$D(PreferDataArr(TabNameNum))){
			s PreferDataArr(TabNameNum)=Tab
		}
		if ('$D(PreferDataArr(TabNameNum,ColNameNum))){
			s PreferDataArr(TabNameNum,ColNameNum)=Col
		}
		
		s ColData=$G(PreferDataArr(TabNameNum,ColNameNum,"Data"))
		//表名重复不导入
		if (id'=""){
			if (OldPreferData'=""){
				s RepeatFlag=0
				for k=1:1:$l(OldPreferData,","){
					s oneOldPreferData=$p(OldPreferData,",",k)
					continue:oneOldPreferData=""
					s oldOneTabName=$p($p(oneOldPreferData,$c(28),1),$c(1),1)
					if (oldOneTabName=$p(Tab,"$",1)) s RepeatFlag=1
				}
				if (RepeatFlag=1){
					kill PreferDataArr(TabNameNum),PreferDataArr(TabNameNum,ColNameNum)
					continue
				}
			}
		}
		if (ColData=""){
			s ColData=ARCIMorARCOS_$C(4)_ArcimId
		}else{
			s ColData=ColData_$C(28)_ARCIMorARCOS_$C(4)_ArcimId
		}
		s PreferDataArr(TabNameNum,ColNameNum,"Data")=ColData
	}
	s PreferData=""
	s TabNameNum=0
	for {
		s TabNameNum=$O(PreferDataArr(TabNameNum))
		q:TabNameNum=""
		s TabName=$G(PreferDataArr(TabNameNum))
		s TabName=$p(TabName,"$",1)
		s AllColData=""
		s ColNameNum=0
		for {
			s ColNameNum=$O(PreferDataArr(TabNameNum,ColNameNum))
			q:ColNameNum=""
			s ColName=$G(PreferDataArr(TabNameNum,ColNameNum))
			s ColData=$G(PreferDataArr(TabNameNum,ColNameNum,"Data"))
			s ColName=$p(ColName,"$",1) //
			if (AllColData=""){
				s AllColData=ColName_$C(28)_ColData
			}else{
				s AllColData=AllColData_$C(1)_ColName_$C(28)_ColData
			}
		}
		if (PreferData=""){
			s PreferData=TabName_$C(1)_AllColData
		}else{
			s PreferData=PreferData_","_TabName_$C(1)_AllColData
		}

	}
	if (id'="") {
		s OldPreferList=obj.Data
		s OldPreferList=$list(OldPreferList,3)
		s OldPreferData=$LISTTOSTRING(OldPreferList,",",1)
		if (OldPreferData'=""){
			if (PreferData="") s PreferData=OldPreferData
		   	else  s PreferData=OldPreferData_","_PreferData
	    }
	}
	s PreferList=$LISTFROMSTRING(PreferData,",")
	s Data=$LB(EPRChartId,EPRChartSize,PreferList,0,0)
	s obj.AppKey = appkey
	s obj.AppSubKey = "OEOrder.PrefTabs.EditList"
	s obj.Data=Data
	s obj.ObjectType = Type
	s obj.ObjectReference = TypeRef
	s sc=obj.%Save()
	d obj.%Close()
	q sc
}

/// Creator:      彭春桥
/// CreatDate:    2014.09.04
/// Description:: 查询科室
Query LookUpCTLoc(desc As %Library.String) As %Library.Query(CONTAINID = 3, ROWSPEC = "ID:%String,CTLOC:%String")
{
}

ClassMethod LookUpCTLocClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpCTLocFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCDocPrefTabs","LookUpCTLoc","zxy")

ClassMethod LookUpCTLocExecute(ByRef qHandle As %Library.Binary, desc As %Library.String) As %Library.Status
{
	
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s CTLocId=0
	s desc=$zcvt(desc,"U")
	S ^PENG("desc")=desc
	for {
		s CTLocId=$O(^CTLOC(CTLocId)) Q:CTLocId=""
		s CTLocDesc=$p(^CTLOC(CTLocId),"^",2)
		//continue:((desc'="")&&(CTLocDesc'[desc))
		continue:##class(web.DHCOPAdmReg).CheckLocDesc(CTLocId,desc)'=1 
		s flagO=$d(^PAC("ADMLOC",0,"AdmType","O",CTLocId))
		s flagE=$d(^PAC("ADMLOC",0,"AdmType","E",CTLocId))
		d OuputRow111
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow111
	set Data=$lb(CTLocId,CTLocDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod LookUpCTLocFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpCTLocExecute ]
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

/// Creator:      彭春桥
/// CreatDate:    2014.09.04
/// Description:: 查询用户
Query LookUpUser(desc As %Library.String) As %Library.Query(CONTAINID = 3, ROWSPEC = "ID:%String,USER:%String")
{
}

ClassMethod LookUpUserClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpUserFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCDocPrefTabs","LookUpUser","王")

ClassMethod LookUpUserExecute(ByRef qHandle As %Library.Binary, desc As %Library.String) As %Library.Status
{
	
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	i desc=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s USERID=0
	s desc=$zcvt(desc,"U")
	for {
		s USERID=$O(^SSU("SSUSR",USERID)) Q:USERID=""
		s USERIDNAME=$p(^SSU("SSUSR",USERID),"^",2)
		// 判断是否医生
		s CTCareProv9=$p(^SSU("SSUSR",USERID),"^",9)
		s CTCareProv14=$p(^SSU("SSUSR",USERID),"^",14)
		continue:((CTCareProv9="")&&(CTCareProv14=""))
		s SSUSRInitials=$p(^SSU("SSUSR",USERID),"^",1)
		continue:((desc'="")&&($zcvt(USERIDNAME,"U")'[desc)&&($zcvt(SSUSRInitials,"U")'[desc))	
		d OuputRow222
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow222
	set Data=$lb(USERID,USERIDNAME)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod LookUpUserFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpUserExecute ]
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

/*w ##class(web.DHCDocPrefTabs).websysSaveOETabsNew("","User.SSUser",4634,"ORDERW50007O","scl测试^1",0,"_$c(28)_"ARCIM"_$c(4)_"465||1"_$c(1,28,1,28,1,28,1,28))*/

/*
w ##class(web.DHCDocPrefTabs).websysSaveOETabsNew(5067,"User.SSUser",4634,"ORDERWNewOrderEntryI","123^1!!个人模板ys01^2!!新增A^3!!新增B^4",4,"_$c(28)_"ARCIM"_$c(4)_"1811||1"_$c(1,28,1,28,1,28,1,28))
*/
ClassMethod websysSaveOETabsNew(id As %Library.String = "", objectType As %String, objectReference As %String, AppKey As %String, TableNameList As %String, SelTabNameIndex As %String, UpdateVal As %String)
{
	s ^tempscl("websysSaveOETabsNew")=id_","_objectType_","_objectReference_","_AppKey_","_TableNameList_","_SelTabNameIndex_","_UpdateVal
	TS
	//s SelTabNameIndex=SelTabNameIndex+1
	s groupitemDelim=$C(28)
	s itemdataDelim=$C(4)
	s tabgroupDelim=$C(1)
	s TABLIST="",ChartID="",eprChartFrameSize="",NoShowAlias=0,NoShowAliasSameCode=0
	if (id=""){
		set OldDataJson=""
		s obj=##Class(websys.Preferences).%New()
		for tabidx=1:1:$l(TableNameList,"!!"){
			s OneTableNameStr=$p(TableNameList,"!!",tabidx)
			s tableName=$p(OneTableNameStr,"^",1)
			s tabIndex=$p(OneTableNameStr,"^",2)
			if (tabIndex=SelTabNameIndex){
				s TABLISTValue=tableName_tabgroupDelim_UpdateVal
			}else{
				s TABLISTValue=tableName
			}
			s $List(TABLIST,tabidx)= TABLISTValue
		}
		s subkey="OEOrder.PrefTabs.EditList"
	 	s obj.AppKey=AppKey
	 	s obj.AppSubKey=subkey
	 	s obj.ObjectType=objectType
	 	s obj.ObjectReference=objectReference
	}else{
		set OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("websys.Preferences"_$c(2)_id)
		s OldDataJson=##Class(web.DHCDocDataChangeLog).GetDocPreTabs(OldDataJson)
		s obj=##Class(websys.Preferences).%OpenId(id)
		s OldData=obj.Data
		for tabidx=1:1:$l(TableNameList,"!!"){
			s OneTableNameStr=$p(TableNameList,"!!",tabidx)
			s tableName=$p(OneTableNameStr,"^",1)
			s tabIndex=$p(OneTableNameStr,"^",2)
			if (tabIndex=SelTabNameIndex){
				s TABLISTValue=tableName_tabgroupDelim_UpdateVal
			}elseif (tabIndex>$listlength($list(OldData,3))){
				s TABLISTValue=tableName_tabgroupDelim_""
			}else{
				s OldDataList=$list($list(OldData,3),tabIndex)
				s TABLISTValue=OldDataList
			}
			s $List(TABLIST,tabidx)= TABLISTValue
		}
	}
	s Data=$LB(ChartID,eprChartFrameSize,TABLIST,NoShowAlias,NoShowAliasSameCode)
	s ^tempscl("csnihao")=Data
	s obj.Data=Data
	s sc=obj.%Save()
	if $$$ISERR(sc){
		b //
		Do $System.Status.DisplayError()
		Trollback
		Quit "-100"
	}
	TC
	d obj.%Close() 
	s id=obj.%Id() 
	s obj=""
	
	set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("websys.Preferences"_$c(2)_id)
	s NewDataJson=##Class(web.DHCDocDataChangeLog).GetDocPreTabs(NewDataJson)
	;医生站业务数据修改日志
	d ##class(web.DHCDocDataChangeLog).SaveLog("websys.Preferences","websys.Preferences","医嘱模板信息","websys.Preferences_"_id,"","U",NewDataJson,OldDataJson)
	Q 0_"^"_id
}

// w ##class(web.DHCDocPrefTabs).websysDelOETabsNew()

ClassMethod websysDelOETabsNew(id As %Library.String = "", SelTabIndex As %String) As %String
{
	Q:id="" 0
	set OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("websys.Preferences"_$c(2)_id)
	s OldDataJson=##Class(web.DHCDocDataChangeLog).GetDocPreTabs(OldDataJson)
	s obj=##Class(websys.Preferences).%OpenId(id)
	s OldData=obj.Data
	s ChartID=$list(OldData,1)
	s eprChartFrameSize=$list(OldData,2)
	s NoShowAlias=$list(OldData,4)
	s NoShowAliasSameCode=$list(OldData,5)
	s listTable=$list(OldData,3)
	s TABLIST=""
	s tabidx=1
	for i=1:1:$listlength(listTable) {
		if ("^"_SelTabIndex_"^")'[("^"_i_"^") {
			s $List(TABLIST,tabidx)=$list(listTable,i)
			s tabidx=tabidx+1
		}
	}
	s Data=$LB(ChartID,eprChartFrameSize,TABLIST,NoShowAlias,NoShowAliasSameCode)
	s ^tempscl("ff")=Data
	b //12
	s obj.Data=Data
	s save=obj.%Save()
	
	d obj.%Close()
	
	set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("websys.Preferences"_$c(2)_id)
	s NewDataJson=##Class(web.DHCDocDataChangeLog).GetDocPreTabs(NewDataJson)
	;医生站业务数据修改日志
	d ##class(web.DHCDocDataChangeLog).SaveLog("websys.Preferences","websys.Preferences","医嘱模板信息","websys.Preferences_"_id,"","D",NewDataJson,OldDataJson)
	
	q 0
}

/// 查询诊断模版列表
Query FindDiagTemp(objtype, objvalue, HospRowId = "") As websys.Query(CONTAINID = 0, ROWSPEC = "HospDesc:%String:*院区,FavCatType:%String:*分类代码,TypeValue:%String:分类值ID,TypeValueDesc:%String:*分类值描述,TypeValueCode:%String:*分类值代码,Cat:%String:模板分类名,DiagType:%String:*类型,ICDCode:%String:*ICD代码,ICDDesc:%String:*ICD描述,Note:%String:备注,SyndCode:%String:证型代码,SyndDesc:%String:证型描述,SyndNote:%String:证型备注,Prefix:%String:前缀")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocPrefTabs","FindDiagTemp","User.SSUser","6")
/// d ##class(%ResultSet).RunQuery("web.DHCDocPrefTabs","FindDiagTemp","","")
ClassMethod FindDiagTempExecute(ByRef QHandle As %Library.Binary, objtype, objvalue, HospRowId = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s objtype=$ZCVT(objtype,"U")
	s iCatType="" f  s iCatType=$O(^User.MRCDiagFavCatI("IndexSequece",iCatType)) Q:iCatType=""  d
	.s CatType=$TR(iCatType," ")
	.s Type=$ZCVT($P(CatType,"|",1),"U")
	.q:(objtype'="")&&(objtype'=Type)
	.s iTypeValue="" f  s iTypeValue=$O(^User.MRCDiagFavCatI("IndexSequece",iCatType,iTypeValue)) Q:iTypeValue=""  d
	..s TypeValue=$TR(iTypeValue," ")
	..q:(objvalue'="")&&(objvalue'=$ZCVT(TypeValue,"U"))
	..i Type="USER.SSUSER" s TypeValueDesc=$p($g(^SSU("SSUSR",+TypeValue)),"^",2),TypeValueCode=$p($g(^SSU("SSUSR",+TypeValue)),"^",1)
	..e  i Type="USER.CTLOC"'="" s TypeValueDesc=$p($g(^CTLOC(+TypeValue)),"^",2),TypeValueCode=$p($g(^CTLOC(+TypeValue)),"^",1)
	..e  s TypeValueDesc=$p($g(^CT("HOSP",+TypeValue)),"^",2),TypeValueCode=$p($g(^CT("HOSP",+TypeValue)),"^",1)
	..s Seq="" f  s Seq=$O(^User.MRCDiagFavCatI("IndexSequece",iCatType,iTypeValue,Seq)) Q:Seq=""  d
	...s CatID=0 f  s CatID=$O(^User.MRCDiagFavCatI("IndexSequece",iCatType,iTypeValue,Seq,CatID)) Q:CatID=""  d
	....s HospID=##class(DHCDoc.Diagnos.Fav).GetCatHospID(CatID)
	....Q:(HospRowId'="")&&(HospRowId'=HospID)
	....s HospDesc=$P($G(^CT("HOSP",+HospID)),"^",2)
	....s Cat=$LG(^User.MRCDiagFavCatD(CatID),4)
	....s FavCatType=$LG(^User.MRCDiagFavCatD(CatID),2)
	....s rsItem=##class(%ResultSet).%New("DHCDoc.Diagnos.Fav:QueryItem")
	....d rsItem.Execute(CatID,"Y")
	....f  Q:'rsItem.Next()  d
	.....s ICDRowid=rsItem.GetDataByName("ICDRowid")
	.....s ICDCode=$CASE(ICDRowid,"":"",:$P(^MRC("ID",ICDRowid),"^",4))
	.....s ICDDesc=rsItem.GetDataByName("ICDDesc")
	.....s Note=rsItem.GetDataByName("Note")
	.....s Type=rsItem.GetDataByName("Type")
	.....s Prefix=rsItem.GetDataByName("Prefix")
	.....s DiagType=$CASE(Type,1:"中医",2:"证型",:"西医")
	.....s ItemID=rsItem.GetDataByName("ID")
	.....s SyndCount=0
	.....s rsSynd=##class(%ResultSet).%New("DHCDoc.Diagnos.Fav:QuerySyndrome")
	.....d rsSynd.Execute(ItemID)
	.....f  Q:'rsSynd.Next()  d
	......s SyndCount=SyndCount+1
	......s SyndromeID=rsSynd.GetDataByName("SyndromeID")
	......s SyndCode=$CASE(SyndromeID,"":"",:$P(^MRC("ID",SyndromeID),"^",4))
	......s SyndDesc=rsSynd.GetDataByName("SyndDesc")
	......s SyndNote=rsSynd.GetDataByName("Note")
	......d OutputRow
	.....i 'SyndCount d
	......s (SyndCode,SyndDesc,SyndNote)=""
	......d OutputRow
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	s ^CacheTemp(repid,ind)=$lb(HospDesc,FavCatType,TypeValue,TypeValueDesc,TypeValueCode,Cat,DiagType,ICDCode,ICDDesc,Note,SyndCode,SyndDesc,SyndNote,Prefix)
	s ind=ind+1
	Q
}

/// 导入诊断模板列表 谭吉善
/// w ##class(web.DHCDocPrefTabs).ExportDiagTempXls("","","ALL","") //ORDERWNewOrderEntryO
/// w ##class(web.DHCDocPrefTabs).ExportDiagTempXls("User.SSUser","11")
/// Set file=##class(%File).%New("\DtHealth\app\dthis\web\temp\componentxml\"_xlsname_"医嘱模版.xls")
ClassMethod ExportDiagTempXls(objtype, objvalue, xlsname As %String = "") As %String
{
	s ^tempscl("ExportDiagTempXls")=objtype_","_objvalue_","_xlsname
	i xlsname="" s xlsname=$tr(objtype,".","_")_objvalue
	s rs = ##class(%ResultSet).%New("web.DHCDocPrefTabs:FindDiagTemp")
	s componentxml ="\\temp\\excel\\"
	s path = ##class(ext.util.String).GetPhysicalPath("",componentxml)
	s path="\"_$p(path,"\",2,$l(path,"\"))
	
	Set PhyDir = ##class(ext.util.String).GetPhysicalPath("",componentxml)
	if ('##class(%File).DirectoryExists(PhyDir)){
		d ##class(%File).CreateDirectory(PhyDir)
	}
	
	Set file=##class(%File).%New(PhyDir_xlsname_"DiagTemp.xls")
	Do file.Open("NWRS")
	
	Do file.WriteLine("*院区代码"_$c(9)_"*类型"_$c(9)_"类型描述"_$c(9)_"*类型代码"_$c(9)_"*模板标号"_$c(9)_"*列位置"_$c(9)_"*列编号"_$c(9)_"*顺序编号"_$c(9)_"总描述"_$c(9)_"描述"_$c(9)_"*描述代码"_$c(9)_"证型代码")
	do rs.Execute(objtype,objvalue)
	s len = rs.GetColumnCount()
	while(rs.%Next()){
		s MASHospCode=rs.GetDataByName("MASHospCode")
		s MASType=rs.GetDataByName("MASType")
		s MASTypeDesc=rs.GetDataByName("MASTypeDesc")
		s MASTypeCode=rs.GetDataByName("MASTypeCode")
		s MASDesc=rs.GetDataByName("MASDesc")
		
		s MASIndex=rs.GetDataByName("MASIndex")
		s ICDListNum=rs.GetDataByName("ICDListNum")
		s ICDListIndex=rs.GetDataByName("ICDListIndex")
		s ALLDesc=rs.GetDataByName("ALLDesc")
		s ICDDesc=rs.GetDataByName("ICDDesc")
		s ICDCode=rs.GetDataByName("ICDCode")
		s ICDSyndromeCodeInfo=rs.GetDataByName("ICDSyndromeCodeInfo")
		
		
		s str=MASHospCode_$c(9)_MASType_$c(9)_MASTypeDesc_$c(9)_MASTypeCode_$c(9)_MASDesc_$c(9)_MASIndex_$c(9)_ICDListNum_$c(9)_ICDListIndex_$c(9)_ALLDesc_$c(9)_ICDDesc_$c(9)_ICDCode_$C(9)_ICDSyndromeCodeInfo
		Do file.WriteLine(str)
	}			
	d rs.%Close()		
	do file.Close()
	do file.%Close()
	q 1
}

/// 批量导入诊断模板
/// 谭吉善 2019-05-22
/// w ##class(web.DHCDocPrefTabs).ImportDiagTempXls(^tan("ImportDiagTempXls"))
ClassMethod ImportDiagTempXls(Data As %String, LogonHospDr As %String = "") As %String
{
	;s ^Wqy("ImportDiagTempXls",$I(^Wqy("ImportDiagTempXls")))=Data
	s LogonHospDr=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospDr)
	s SuccessNum=0
	s len=$l(Data,$c(1))
	f i=1:1:len {
		s OneData=$P(Data,$c(1),i)
		s TypeCode=$P(OneData,$C(2),1)
		s TypeValue=$P(OneData,$C(2),2)
		continue:TypeCode=""
		s DiagType=$P(OneData,$C(2),3)
		s DiagType=$CASE(DiagType,"证型":2,"中医":1,:"西医")
		s ICDCode=$P(OneData,$C(2),4)
		s Note=$P(OneData,$C(2),5)
		s SyndCode=$P(OneData,$C(2),6)
		s SyndNote=$P(OneData,$C(2),7)
		s Prefix=$P(OneData,$C(2),8)
		s Cat=$P(OneData,$C(2),9)
		
		d ImportCat
		continue:CatID=""
		d ImportItem
		continue:ItemID=""
		d ImportSynd
		s SuccessNum=SuccessNum+1
	}
	q SuccessNum
ImportCat
	s CatID=""
	Q:Cat=""
	s Type=$P(TypeCode,"|",1),CONTEXT=$P(TypeCode,"|",2),HospID=$P(TypeCode,"|",3)
	i Type="User.SSUser" s UserID=TypeValue,LocID=$O(^CTLOC(0,"Hosp",+HospID,0))
	e  s UserID="",LocID=TypeValue
	if (UserID'="")&&(LocID=""){
		s LocID=$P(^SSU("SSUSR",UserID),"^",4) 
	}
	s TypeObj=##class(DHCDoc.Diagnos.Fav).GetCatTypeData(Type, LocID, UserID,CONTEXT)
	s CatType=TypeObj.CatType,TypeValue=TypeObj.TypeValue
	s ret=##class(DHCDoc.Diagnos.Fav).SaveCat(Type,Cat,LocID,UserID,CONTEXT)
	s CatID=$P(ret,"^",2)
	Q
ImportItem
	s ItemID=""
	s ICDRowid=""
	if ICDCode'=""{
		&SQL(SELECT MRCID_RowId INTO :ICDRowid FROM SQLUser.MRC_ICDDx WHERE MRCID_ICD9CM_Code=:ICDCode)
	}
	Q:(ICDRowid="")&&(Note="")
	s ret=##class(DHCDoc.Diagnos.Fav).SaveItem(CatID,ICDRowid,Note,DiagType,UserID,Prefix)
	s ItemID=$P(ret,"^",2)
	Q
ImportSynd
	s SyndID=""
	s SyndRowid=""
	if SyndCode'=""{
		&SQL(SELECT MRCID_RowId INTO :SyndRowid FROM SQLUser.MRC_ICDDx WHERE MRCID_ICD9CM_Code=:SyndCode)
	}
	Q:(SyndRowid="")&&(SyndNote="")
	s ret=##class(DHCDoc.Diagnos.Fav).SaveSyndrome(ItemID,SyndRowid,SyndNote,UserID)
	s SyndID=$P(ret,"^",2)
	Q
}

/// 查询医嘱套列表
/// 谭吉善 2019-05-24
Query FindARCOS(objtype, objvalue, HospRowId = "") As websys.Query(CONTAINID = 0, ROWSPEC = "ARCOSNum:%String:*医嘱套流水,ARCOSRowid:%String:主键,ARCOSCode:%String:医嘱套代码,ARCOSDesc:%String:*医嘱套名称,ARCOSAlias:%String:别名,ARCOSOrdCat:%String:*大类,ARCOSOrdSubCat:%String:*子类,ARCOSEffDateFrom:%String:起始日期,UserName:%String:用户,UserCode:%String:*用户工号,LocDesc:%String:科室,LocCode:%String:*科室代码,FavMedUnitDesc:%String:*科室组,HospCode:%String:*院区代码,CelerType:%String:快速标识,CMPrescTypeCode:%String:处方类型,CMDuratDesc:%String:付数,CMFreqDesc:%String:频次,CMInstrDesc:%String:用法,CMDoseQty:%String:一次用量,CMNotes:%String:备注,P1:%String,P2:%String,P3:%String,P4:%String,ARCIMCode:%String:医嘱项代码,ARCIMDesc:%String:医嘱项名称,DoseQty:%String:单次剂量,DoseUOM:%String:剂量单位,Frequence:%String:频次,Duration:%String:疗程,Instruction:%String:用法,PackQty:%String:数量,PackQtyBillUOM:%String:数量单位,DHCDocOrdRecLocCode:%String:接收科室代码,DHCDocOrdRecHospCode:%String:接收科室院区代码,ARCOSItmLinkDoctor:%String:关联,Tremark:%String:备注,OECPRDesc:%String:医嘱类型,SampleDesc:%String:标本,NO:%String:序号,OrderPriorRemarks:%String:附加说明,DHCDocOrdStage:%String:阶段,DHCMustEnter:%String:必填,SpeedFlowRate:%String:流速,FlowRateUnit:%String:流速单位,OrderBodyPartLabel:%String:部位,NotifyClinician:%String:加急,SkinTest:%String:皮试,SkinTestAction:%String:皮试备注,RemoveCeler:%String:快速例外")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocPrefTabs","FindARCOS","User.CTLoc","111")
/// d ##class(%ResultSet).RunQuery("web.DHCDocPrefTabs","FindARCOS","","")
ClassMethod FindARCOSExecute(ByRef QHandle As %Library.Binary, objtype, objvalue, HospRowId = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^temptan("FindARCOS")=objtype_","_objvalue_","_HospRowId
	s HospRowId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospRowId)
 	s DefHospId=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("ARC_ItmMast",HospRowId)
	s ARCOSNum=0
	///web.DHCUserFavItems.FindUserOrderSet
	&SQL(DECLARE EmpCursor CURSOR FOR
		Select ARCOS_Rowid,ARCOS_Code,ARCOS_Desc,ARCOS_OrdCat_DR->ORCAT_Desc,
		ARCOS_OrdSubCat_DR->ARCIC_Desc,ARCOS_EffDateFrom,ARCOS_OrdCat_DR,
		ARCOS_OrdSubCat_DR,Fav_Rowid ,SQLUser.DHC_UserFavItems.Fav_User_Dr,SQLUser.DHC_UserFavItems.Fav_ItemRowid,
		SQLUser.DHC_UserFavItems.Fav_Dep_Dr,SQLUser.DHC_UserFavItems.Fav_MedUnit_Dr,
		ARCOS_PrescTypeCode,ARCOS_DurationDR,ARCOS_FrequencyDR,ARCOS_Instr_DR,ARCOS_InstrLinkDosage_DR,
		ARCOS_Notes,SQLUser.DHC_UserFavItems.Fav_CelerType,SQLUser.DHC_UserFavItems.Fav_Hosp_Dr
		into :ARCOSRowid,:ARCOSCode,:ARCOSDesc,:ARCOSOrdCat,:ARCOSOrdSubCat,
		  :ARCOSEffDateFrom,:ARCOSOrdCatDR,:ARCOSOrdSubCatDR,:FavRowid,:FavUserDr,:FavItemRowid,
		  :FavDepDr,:FavMedUnitDr,
		  :CMPrescTypeCode,:CMDuratId,:CMFreqId,:CMInstrId,:CMDosageId,:CMNotes,:CelerType,:HospDr
		From SQLUser.ARC_OrdSets,SQLUser.DHC_UserFavItems 
		Where 
		SQLUser.ARC_OrdSets.ARCOS_Rowid=SQLUser.DHC_UserFavItems.Fav_ItemRowid and SQLUser.DHC_UserFavItems.Fav_UseHosp_Dr=:HospRowId
		order by ARCOS_Rowid desc) 
	&SQL(OPEN EmpCursor)
	for  {
		&SQL(FETCH EmpCursor)
		QUIT:SQLCODE
		if (objtype="User.SSUser"){
			continue:(FavUserDr'=objvalue)
		}elseif (objtype="User.CTLoc"){
			continue:(FavDepDr'=objvalue)
		}
		s ARCOSAlias=""
		s ARCOSAliasRowid=$O(^ARC("ALIAS",0,"ARCOS",ARCOSRowid,0))
		//if ARCOSAliasRowid'="" s ARCOSAlias=$P(^ARC("ALIAS",ARCOSAliasRowid),"^",6)
		
		s rs = ##class(%ResultSet).%New("web.DHCUserFavItems:FindAlias")
		do rs.Execute(ARCOSRowid)
		s ARCOSItemNum=0
		while(rs.%Next()){
			if (ARCOSAlias="") s ARCOSAlias=rs.GetDataByName("ALiCode")
			else  s ARCOSAlias=ARCOSAlias_" "_rs.GetDataByName("ALiCode")
		}
		d rs.%Close()
		
		s (HospCode,UserName ,UserCode,LocDesc,LocCode,FavMedUnitDesc)=""
		s ARCOSOrdCatCode=$P(^OEC("ORCAT",ARCOSOrdCatDR),"^",1)
		s ARCOSOrdSubCatCode=$P(^ARC("IC",ARCOSOrdSubCatDR),"^",1)
		if (HospDr'=""){
			continue:HospDr'=HospRowId
			s HospCode=$P(^CT("HOSP",HospDr),"^",1)
		}
		s ARCOSEffDateFrom=..%ZD(ARCOSEffDateFrom)
		if (FavUserDr'=""){
			continue:(##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_User",FavUserDr,HospRowId)="N")
			&SQL(SELECT SSUSR_Name,SSUSR_Initials INTO:UserName ,:UserCode FROM SQLUSER.SS_User WHERE SSUSR_Rowid=:FavUserDr )
		}
		if (FavDepDr'=""){
			continue:$p(^CTLOC(FavDepDr),"^",22)'=HospRowId
			&SQL(SELECT CTLOC_Desc ,CTLOC_Code,CTLOC_Hospital_DR->HOSP_Code INTO:LocDesc,:LocCode,:HospCode FROM SQLUSER.CT_Loc WHERE CTLOC_Rowid=:FavDepDr )
		}
		if (FavMedUnitDr'=""){
			s FavMedUnitDesc=##class(web.DHCUserFavItems).GetMedUnitDesc(FavMedUnitDr)
		}
		///草药医嘱套扩展信息
		s (CMDuratCode,CMDuratDesc,CMFreqCode,CMFreqDesc,CMInstrCode,CMInstrDesc)=""
		s (CMDoseQty)=""
		if (CMDuratId'=""){
			s CMDuratDesc=$P($G(^PHCDU(CMDuratId)),"^",1)
		}
		if (CMFreqId'=""){
			s CMFreqDesc=$P($G(^PHCFR(CMFreqId)),"^",3)
		}
		if (CMInstrId'=""){
			s CMInstrDesc=$P($G(^PHCIN(CMInstrId)),"^",2)
		}
		s:CMDosageId'="" CMDoseQty=$P(^PHCDO(CMDosageId),"^",3)
		s ARCOSDesc=##class(web.DHCDocUtil).EvalJSON(ARCOSDesc)
		s ARCOSNum=ARCOSNum+1
		set MainData=$lb(ARCOSNum,ARCOSRowid,ARCOSCode,ARCOSDesc,ARCOSAlias,
			ARCOSOrdCat,ARCOSOrdSubCat,ARCOSEffDateFrom,UserName,UserCode,
			LocDesc,LocCode,FavMedUnitDesc,HospCode,CelerType,
			CMPrescTypeCode,CMDuratDesc,CMFreqDesc,CMInstrDesc,CMDoseQty
			,CMNotes,"-","-","-","-"								/*预留*/
		)
		s rs = ##class(%ResultSet).%New("web.DHCARCOrdSets:FindOSItem")
		do rs.Execute(ARCOSRowid,"1")
		s ARCOSItemNum=0
		while(rs.%Next()){
			s Rowid=rs.GetDataByName("ARCOSItemRowid")
			s ARCOSItemData=$G(^ARCOS(+Rowid,"DATE",$p(Rowid,"||",2),"ITM",$p(Rowid,"||",3)))
			s ARCOSItemDataExt=$G(^ARCOS(+Rowid,"DATE",$p(Rowid,"||",2),"ITM",$p(Rowid,"||",3),"DHC"))
			s ARCIMRowid=rs.GetDataByName("ARCIMRowid")
			s ARCIMDesc=rs.GetDataByName("ARCIMDesc")
			//套中套尚不支持导入导出
			if (ARCIMRowid'["||"){
				continue
			}
			continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ARCIMRowid,DefHospId)="N"
			s ARCIMCode=$P(^ARCIM(+ARCIMRowid,$P(ARCIMRowid,"||",2),1),"^",1)
			
			s ARCIMDesc=##class(web.DHCDocUtil).EvalJSON(ARCIMDesc)
			s DoseQty=rs.GetDataByName("ARCOSItemDoseQty")
			s DoseUOM=rs.GetDataByName("ARCOSItemUOM")
			
			s Frequence=rs.GetDataByName("ARCOSItemFrequence")
			s Frequence=$P(Frequence,"-",1)
			s OrderFreqDispTimeStr=$p($G(^ARCOS(+Rowid,"DATE",$p(Rowid,"||",2),"ITM",$p(Rowid,"||",3),"DHC")),"^",11)
			s OrderFreqRowid=rs.GetDataByName("ARCOSItemFrequenceDR")
			if (OrderFreqDispTimeStr'="")&&(OrderFreqRowid'=""){
				s WeekFlag=$P(^PHCFR(OrderFreqRowid),"^",9)
				s FreeTimeFreqFlag=$P(^PHCFR(OrderFreqRowid),"^",13)
				if (FreeTimeFreqFlag="Y"){
					s OrderFreqFreeTimeStr=""
					for i=1:1:$L(OrderFreqDispTimeStr,$C(1)){
						s ArrData=$P(OrderFreqDispTimeStr,$C(1),i)
						s DispTime=$P(ArrData,$C(2),1)
						s PHCDTRowID=$P(ArrData,$C(2),3)
						s PHCDTDesc=$P($G(^PHCFR(+PHCDTRowID,"DT",$P(PHCDTRowID,"_",2))),"^",2)
						if (OrderFreqFreeTimeStr=""){
							s OrderFreqFreeTimeStr=$P(ArrData,$C(2),1)_"^"_$P(ArrData,$C(2),2)_"^"_PHCDTDesc
						}else{
							s OrderFreqFreeTimeStr=OrderFreqFreeTimeStr_"|"_$P(ArrData,$C(2),1)_"^"_$P(ArrData,$C(2),2)_"^"_PHCDTDesc
						}
					}
					s Frequence=Frequence_"-"_OrderFreqFreeTimeStr
					}
				if (WeekFlag="Y"){
					s OrderFreqDispTimeStr=$replace(OrderFreqDispTimeStr,$C(1),"|")
					s OrderFreqDispTimeStr=$replace(OrderFreqDispTimeStr,$C(2),"^")
					s Frequence=Frequence_"-"_OrderFreqDispTimeStr
					}
				}
			//s ITMFreqTimeDoseQtyStr=$p($G(^ARCOS(+Rowid,"DATE",$p(Rowid,"||",2),"ITM",$p(Rowid,"||",3),"DHC")),"^",10)
			//if ITMFreqTimeDoseQtyStr'="" s DoseQty=ITMFreqTimeDoseQtyStr
			s Duration=rs.GetDataByName("ARCOSItemDuration")
			s Instruction=rs.GetDataByName("ARCOSItemInstruction")
			s PackQty=rs.GetDataByName("ARCOSItemQty")
			s PackQtyBillUOM=rs.GetDataByName("ARCOSItemBillUOM")
			s DHCDocOrdRecLocDR=$p(ARCOSItemData,"^",21)
			s DHCDocOrdRecLocCode="",DHCDocOrdRecHospCode=""
			if (DHCDocOrdRecLocDR'=""){
				s DHCDocOrdRecLocCode=$P(^CTLOC(DHCDocOrdRecLocDR),"^",1)
				s DHCDocOrdRecHospDr=$P(^CTLOC(DHCDocOrdRecLocDR),"^",22)
				if (DHCDocOrdRecHospDr'=""){
					s DHCDocOrdRecHospCode=$P(^CT("HOSP",DHCDocOrdRecHospDr),"^",1)
				}
			}
			
			s ARCOSItmLinkDoctor=rs.GetDataByName("ARCOSItmLinkDoctor")	///组关系
			s Tremark=rs.GetDataByName("Tremark")
			s OECPRDesc=rs.GetDataByName("ARCOSDHCDocOrderType")
			s SampleDesc=rs.GetDataByName("SampleDesc")
			s NO=rs.GetDataByName("NO")
			s OrderPriorRemarks=rs.GetDataByName("OrderPriorRemarks")
			s DHCDocOrdStage=rs.GetDataByName("DHCDocOrdStage")
			s DHCMustEnter=rs.GetDataByName("DHCMustEnter")
			s DHCMustEnter=$CASE(DHCMustEnter,"Y":"Y","是":"Y",:"N")
			s SpeedFlowRate=rs.GetDataByName("SpeedFlowRate")
			s FlowRateUnit=rs.GetDataByName("FlowRateUnit")
			
			
			s OrderBodyPartLabel=$p(ARCOSItemDataExt,"^",7)
			s OrderBodyPartLabel=$replace(OrderBodyPartLabel,"*","^")
			s OrderBodyPartLabel=##Class(web.DHCDocPrefTabs).GetPartCodeInfo(OrderBodyPartLabel)
			s OrderBodyPartLabel=$replace(OrderBodyPartLabel,"^","*")
			s NotifyClinician=$p(ARCOSItemDataExt,"^",8)
			s RemoveCeler=$p(ARCOSItemDataExt,"^",9)
			
			s SkinTest=$p(ARCOSItemData,"^",24)
 			s SkinTestAction=$p(ARCOSItemData,"^",25)
			if (SkinTestAction'=""){
				s SkinTestAction=$P($G(^OEC("ACT",SkinTestAction)),"^",2)
			}
			s $List(MainData,26)=ARCIMCode
			s $List(MainData,27)=ARCIMDesc
			s $List(MainData,28)=DoseQty
			s $List(MainData,29)=DoseUOM
			s $List(MainData,30)=Frequence
			s $List(MainData,31)=Duration
			s $List(MainData,32)=Instruction
			s $List(MainData,33)=PackQty
			s $List(MainData,34)=PackQtyBillUOM
			s $List(MainData,35)=DHCDocOrdRecLocCode
			s $List(MainData,36)=DHCDocOrdRecHospCode
			s $List(MainData,37)=ARCOSItmLinkDoctor
			s $List(MainData,38)=Tremark
			s $List(MainData,39)=OECPRDesc
			s $List(MainData,40)=SampleDesc
			s $List(MainData,41)=NO
			s $List(MainData,42)=OrderPriorRemarks
			s $List(MainData,43)=DHCDocOrdStage
			s $List(MainData,44)=DHCMustEnter
			s $List(MainData,45)=SpeedFlowRate
			s $List(MainData,46)=FlowRateUnit
			s $List(MainData,47)=OrderBodyPartLabel
			s $List(MainData,48)=NotifyClinician
			s $List(MainData,49)=SkinTest
			s $List(MainData,50)=SkinTestAction
			s $List(MainData,51)=RemoveCeler
			s ARCOSItemNum=ARCOSItemNum+1
			Set ^CacheTemp(repid,ind)=MainData
			Set ind=ind+1
		}
		d rs.%Close()
		if (ARCOSItemNum=0){
			Set ^CacheTemp(repid,ind)=MainData
			Set ind=ind+1
		}
	}
	&SQL(close EmpCursor)
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// 导出医嘱套列表 谭吉善
/// w ##class(web.DHCDocPrefTabs).ExportARCOSXls("","","ALL")
/// w ##class(web.DHCDocPrefTabs).ExportARCOSXls("User.SSUser","11")
ClassMethod ExportARCOSXls(objtype, objvalue, xlsname As %String = "") As %String
{
	s ^tempscl("ExportARCOSXls")=objtype_","_objvalue_","_xlsname
	i xlsname="" s xlsname=$tr(objtype,".","_")_objvalue
	s ClassQuery="web.DHCDocPrefTabs:FindARCOS"
	s rs = ##class(%ResultSet).%New(ClassQuery)
	s componentxml ="\\temp\\excel\\"
	s path = ##class(ext.util.String).GetPhysicalPath("",componentxml)
	s path="\"_$p(path,"\",2,$l(path,"\"))
	
	Set PhyDir = ##class(ext.util.String).GetPhysicalPath("",componentxml)
	if ('##class(%File).DirectoryExists(PhyDir)){
		d ##class(%File).CreateDirectory(PhyDir)
	}
	
	Set file=##class(%File).%New(PhyDir_xlsname_"ARCOS.xls")
	Do file.Open("NWRS")
	s TitleList=..GetQueryTitleList(ClassQuery)
	s TitlenNameList=$P(TitleList,$C(1),2)
	s TitleIDList=$P(TitleList,$C(1),1)
	Do file.WriteLine(TitlenNameList)
	do rs.Execute(objtype,objvalue)
	s len = rs.GetColumnCount()
	while(rs.%Next()){
		s OneColumn=""
		for i=1:1:$L(TitleIDList,$C(9)){
			s OneData=rs.GetDataByName($P(TitleIDList,$C(9),i))
			if (OneColumn=""){
				s OneColumn=OneData
			}else{
				s OneColumn=OneColumn_$C(9)_OneData
			}
		}
		Do file.WriteLine(OneColumn)
	}			
	d rs.%Close()		
	do file.Close()
	do file.%Close()
	q 1
}

/// 批量导入医嘱套
/// 谭吉善 2019-05-22
/// w ##class(web.DHCDocPrefTabs).ImportARCOSXls(^tan("ImportARCOSXls",1),2)
ClassMethod ImportARCOSXls(Data As %String, LogonHospDr As %String = "") As %String
{
	;s ^tan("ImportARCOSXls",$I(^tan("ImportARCOSXls")))=Data
	s LogonHospDr=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospDr)
	s MsgInfo=""
	s SuccessNum=0
	k ARCOSList
	For i=1:1:$l(Data,$c(1)) {
		s OneData=$P(Data,$c(1),i)
		s ARCOSNum=$P(OneData,$C(2),1)
		s ARCOSData=$P(OneData,$C(2),1,25)
		s ARCOSItemData=$P(OneData,$C(2),26,$L(OneData,$C(2)))
		
		s ARCOSList(ARCOSNum)=ARCOSData
		s ItemNum=$G(ARCOSList(ARCOSNum,"Num"))+1
		s ARCOSList(ARCOSNum,"Num")=ItemNum
		s ARCOSList(ARCOSNum,"Num",ItemNum)=ARCOSItemData
	}
	s ARCOSNum=""
	for {
		s ARCOSNum=$O(ARCOSList(ARCOSNum))
		q:(ARCOSNum="")
		s ARCOSData=$G(ARCOSList(ARCOSNum))
		
		s ARCOSCode=$P(ARCOSData,$C(2),2)
		s ARCOSDesc=$P(ARCOSData,$C(2),3)
		s ARCOSAlias=$P(ARCOSData,$C(2),4)
		s ARCOSOrdCat=$P(ARCOSData,$C(2),5)
		s ARCOSOrdSubCat=$P(ARCOSData,$C(2),6)
		s ARCOSEffDateFrom=$P(ARCOSData,$C(2),7)
		s UserCode=$P(ARCOSData,$C(2),8)
		s LocCode=$P(ARCOSData,$C(2),9)
		s FavMedUnitDesc=$P(ARCOSData,$C(2),10)
		s HospCode=$P(ARCOSData,$C(2),11)
		s CelerType=$P(ARCOSData,$C(2),12)
		s CMPrescTypeCode=$P(ARCOSData,$C(2),13)
		s CMDuratDesc=$P(ARCOSData,$C(2),14)
		s CMFreqDesc=$P(ARCOSData,$C(2),15)
		s CMInstrDesc=$P(ARCOSData,$C(2),16)
		s CMDoseQty=$P(ARCOSData,$C(2),17)
		s CMNotes=$P(ARCOSData,$C(2),18)
		
		s (UserRowid,FavDepListID,DocMedUnit,HospID)=""
		if (UserCode'=""){
			s UserRowid=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),0))
		}
		if (LocCode'=""){
			&SQL(SELECT CTLOC_Rowid into:FavDepListID FROM SQLUSER.CT_Loc WHERE CTLOC_Code=:LocCode and CTLOC_Hospital_DR->HOSP_Code=:HospCode )
			if (SQLCODE){
				s FavDepListID=""
			}
		}
		if (FavMedUnitDesc'=""){
			&SQL(SELECT MU_RowId into:DocMedUnit FROM SQLUSER.DHC_CTLoc_MedUnit WHERE CTMU_Desc=:FavMedUnitDesc)
		}
		if (HospCode'=""){
			s HospID=$O(^CT("HOSP",0,"Code",HospCode,""))
		}else{
			s HospID=""
		}
		;i ARCOSDesc["-" s ARCOSDesc=$P(ARCOSDesc,"-",2)
		s ARCOSCatID=$O(^OEC("ORCAT",0,"Code",ARCOSOrdCat,0))
		s ARCOSSubCatID=$O(^ARC("IC",0,"Code",ARCOSOrdSubCat,0))
		//w ARCOSEffDateFrom,!
		//时间格式有问题，不再导入
		s ARCOSEffDateFrom=""	//..%ZDH(ARCOSEffDateFrom)
		s UserID=$O(^SSU("SSUSR",0))
		if (ARCOSDesc="")||(ARCOSCatID="")||(ARCOSSubCatID="")||(ARCOSAlias=""){
			s MsgInfo=MsgInfo_";编号"_ARCOSNum_"医嘱套主数据不完整"
			continue
		}
		if (UserRowid="")&&(FavDepListID="")&&(DocMedUnit="")&&(HospID=""){
			s MsgInfo=MsgInfo_";编号"_ARCOSNum_"医嘱套使用权限不正确"
			continue
		}
		TS
		s ret=##class(web.DHCUserFavItems).InsertUserARCOS(UserRowid,ARCOSCode,ARCOSDesc,ARCOSCatID,ARCOSSubCatID,
			ARCOSEffDateFrom,$p(ARCOSAlias," ",1),UserID,FavDepListID,DocMedUnit,HospID,CelerType,LogonHospDr)
		if (ret="-1"){
			TRO
			s MsgInfo=MsgInfo_";编号"_ARCOSNum_"医嘱套保存失败"
			continue
		}
		s ItemDetailsNum=0
		s FavRowid=$P(ret,$C(1),1)
		s ARCOSRowid=$P(ret,$C(1),2)
		//有可能存在多个医嘱套别名
		for aliasNum=2:1:$l(ARCOSAlias," "){
			s oneARCOSAlias=$p(ARCOSAlias," ",aliasNum)
			continue:oneARCOSAlias=""
			d ##class(web.DHCUserFavItems).InsertArcosAlias(ARCOSRowid,oneARCOSAlias)
		}
		s (CMDoseQtyId,CMDuratId,CMFreqId,CMInstrId)=""
		s CMDoseQty=$zcvt(CMDoseQty,"U")
		s CMDuratDesc=$zcvt(CMDuratDesc,"U")
		s CMFreqDesc=$zcvt(CMFreqDesc,"U")
		s CMInstrDesc=$zcvt(CMInstrDesc,"U")
		s CMFreqDesc=$TR(CMFreqDesc," ","")
		s:CMDoseQty'="" CMDoseQtyId=$O(^PHCDO(0,"Desc1",CMDoseQty,0))
		s:CMDuratDesc'="" CMDuratId=$O(^PHCDU(0,"Desc1",CMDuratDesc,0))
		s:CMFreqDesc'="" CMFreqId=$O(^PHCFR(0,"Desc1",CMFreqDesc,0))
		s:CMInstrDesc'="" CMInstrId=$O(^PHCIN(0,"Desc1",CMInstrDesc,0))
		if (CMPrescTypeCode'=""){
			b ;----arocs
			s ret=##class(DHCDoc.DHCDocConfig.OrdSets).SaveOSCNInfo(ARCOSRowid,CMPrescTypeCode,CMDoseQtyId,CMDuratId,CMFreqId,CMInstrId,CMNotes)
			if (ret){
				TRO
				s MsgInfo=MsgInfo_";编号"_ARCOSNum_"医嘱套草药附加说明相关信息保存失败"
				continue
			}
		}
		s ItemNum=""
		for {
			s ItemNum=$O(ARCOSList(ARCOSNum,"Num",ItemNum))
			q:(ItemNum="")
			s ARCOSItemData=ARCOSList(ARCOSNum,"Num",ItemNum)
			
			s ARCIMCode=$P(ARCOSItemData,$C(2),1)
			if (ARCIMCode=""){
				continue
			}
			s DoseQty=$P(ARCOSItemData,$C(2),2)
			///TODO,不规则分发剂量频次的处理
			;s DoseQty=$P(DoseQty,"-")
			
			s DoseUOM=$P(ARCOSItemData,$C(2),3)
			s Frequence=$P(ARCOSItemData,$C(2),4)
			s Duration=$P(ARCOSItemData,$C(2),5)
			s Instruction=$P(ARCOSItemData,$C(2),6)
			s PackQty=$P(ARCOSItemData,$C(2),7)
			s PackQtyBillUOM=$P(ARCOSItemData,$C(2),8)
			s DHCDocOrdRecLocCode=$P(ARCOSItemData,$C(2),9)
			s DHCDocOrdRecHospCode=$P(ARCOSItemData,$C(2),10)
			s ARCOSItmLinkDoctor=$P(ARCOSItemData,$C(2),11)
			s Tremark=$P(ARCOSItemData,$C(2),12)
			s OECPRDesc=$P(ARCOSItemData,$C(2),13)
			s SampleDesc=$P(ARCOSItemData,$C(2),14)
			s NO=$P(ARCOSItemData,$C(2),15)
			s OrderPriorRemarks=$P(ARCOSItemData,$C(2),16)
			s DHCDocOrdStage=$P(ARCOSItemData,$C(2),17)
			s DHCMustEnter=$P(ARCOSItemData,$C(2),18)
			s DHCMustEnter=$CASE(DHCMustEnter,"Y":"Y","是":"Y",:"N")
			s SpeedFlowRate=$P(ARCOSItemData,$C(2),19)
			s FlowRateUnit=$P(ARCOSItemData,$C(2),20)
			s OrderBodyPartLabel=$P(ARCOSItemData,$C(2),21)
			s NotifyClinician=$P(ARCOSItemData,$C(2),22)
			s SkinTest=$P(ARCOSItemData,$C(2),23)
			s SkinTestAction=$P(ARCOSItemData,$C(2),24)
			s RemoveCeler=$P(ARCOSItemData,$C(2),25)
			s (ARCIMRowid,DoseUOMID,FrequenceID,DurationID,InstructionID)=""
			if (ARCIMCode'=""){
				s ARCIMRowid=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ARCIMCode),0))
				if (ARCIMRowid'=""){
					s ARCIMRowid=ARCIMRowid_"||"_$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ARCIMCode),ARCIMRowid,0))
				}
			}
			if (ARCIMRowid=""){
				b
				s MsgInfo=MsgInfo_";编号"_ARCOSNum_"医嘱套,"_ARCIMCode_"找不到有效医嘱项"
				s ItemDetailsNum=-1
				q
			}
			s OrderFreqDispTime=$P(Frequence,"-",2)
			s Frequence=$P(Frequence,"-",1)
			s DoseUOM=$zcvt(DoseUOM,"U")
			s Frequence=$zcvt(Frequence,"U")
			s CMFreqDesc=$zcvt(CMFreqDesc,"U")
			s Instruction=$zcvt(Instruction,"U")
			s:DoseUOM'="" DoseUOMID=$O(^CT("UOM",0,"Desc",DoseUOM,0))
			s:Frequence'="" FrequenceID=$O(^PHCFR(0,"Desc1",Frequence,0))
			s:Duration'="" DurationID=$O(^PHCDU(0,"Desc1",Duration,0))
			s:Instruction'="" InstructionID=$O(^PHCIN(0,"Desc1",Instruction,0))
			s (OECPRRowId,SampleId)=""
			s OECPRDesc=$zcvt(OECPRDesc,"U")
			s:OECPRDesc'="" OECPRRowId=$O(^OECPR(0,"Desc",OECPRDesc,0))
			
			if (SampleDesc'=""){
				i $d(^DHCLISBSVersion(1)) {
					s BTHospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospCode),""))
					i '$l(BTHospitalDR) s BTHospitalDR = $o(^dbo.BTHospitalD(""))
					i $l(BTHospitalDR) {
						s i=0
						for {
							s i=$O(^dbo.BTSpecimenD(i))
							q:(i="")
							s iHospDr=$lg($g(^dbo.BTSpecimenD(i)),6)
							if (iHospDr'=BTHospitalDR){
								continue
							}
							s iSampleDesc=$lg($g(^dbo.BTSpecimenD(i)),3)
							if (iSampleDesc'=SampleDesc){
								continue
							}
							s SampleId=$lg($g(^dbo.BTSpecimenD(i)),2)
							q
						}
					}
				}else{
					s i=0
					for {
						s i=$O(^TTAB("SPEC",i))
						q:(i="")
						s iSampleDesc=$p($G(^TTAB("SPEC",i)),"\",1)
						if (iSampleDesc'=SampleDesc){
							continue
						}
						s SampleId=i
						q
					}
				}
			}
			
			s OrderPriorRemarksDR=$CASE(OrderPriorRemarks,"取药医嘱":"ONE","出院带药":"OUT","PRN":"PRN","自备药":"OM","嘱托":"ZT",:"")
			s OrderRecLoc=..GetObjectValue(DHCDocOrdRecLocCode,"User.CTLoc", DHCDocOrdRecHospCode)
			
			s DHCDocOrderStageID=$CASE(DHCDocOrdStage,"术前":"SQ","术中":"SZ","术后":"SH","产中":"CZ",:"")
			s (PackQtyBillUOMDR,FlowRateUnitDR,SkinTestActionDr)=""
			s:PackQtyBillUOM'="" PackQtyBillUOMDR=$O(^CT("UOM",0,"Desc",PackQtyBillUOM,0))
			s FlowRateUnit=$zcvt(FlowRateUnit,"U")
			s:FlowRateUnit'="" FlowRateUnitDR=$O(^OEC("SFR",0,"Desc",FlowRateUnit,0))
			s OrderBodyPartLabel=$replace(OrderBodyPartLabel,"*","^")
			s OrderBodyPartLabel=##Class(web.DHCDocPrefTabs).GetPartDataInfo(OrderBodyPartLabel)
			s OrderBodyPartLabel=$replace(OrderBodyPartLabel,"^","*")
			s:SkinTestAction'="" SkinTestActionDr=$O(^OEC("ACT",0,"Desc",SkinTestAction,0))
			s OrderFreqTimeDoseStr=""
			s OrderFreqDispTimeStr=""
			if FrequenceID'=""{
				if (OrderFreqDispTime'=""){
					s WeekFlag=$P(^PHCFR(FrequenceID),"^",9)
					s FreeTimeFreqFlag=$P(^PHCFR(FrequenceID),"^",13)
					s Freqi=1
					if (FreeTimeFreqFlag="Y"){
						for i=1:1:$L(OrderFreqDispTime,"|"){
							s ArrData=$P(OrderFreqDispTime,"|",i)
							s PHCDTRowID=""
							s FreqTimeDose=$P(ARCOSItemData,$C(2),2)
							for {
								s PHCDTRowID=$O(^PHCFR(+FrequenceID,"DT",PHCDTRowID))
								q:PHCDTRowID=""
								s Desc=$P($G(^PHCFR(+FrequenceID,"DT",PHCDTRowID)),"^",2)
								if (Desc=$P(ArrData,"^",3)){
									if (OrderFreqDispTimeStr=""){
										s OrderFreqDispTimeStr=$P(ArrData,"^",1)_$C(2)_$P(ArrData,"^",2)_$C(2)_+FrequenceID_"_"_PHCDTRowID
									}else{
										s OrderFreqDispTimeStr=OrderFreqDispTimeStr_$C(1)_$P(ArrData,"^",1)_$C(2)_$P(ArrData,"^",2)_$C(2)_+FrequenceID_"_"_PHCDTRowID
									}
									if (FreqTimeDose["-"){
										if (OrderFreqTimeDoseStr=""){
											s OrderFreqTimeDoseStr=+FrequenceID_"_"_PHCDTRowID_"$"_$P(FreqTimeDose,"-",Freqi)
										}else{
											s OrderFreqTimeDoseStr=OrderFreqTimeDoseStr_"!"_+FrequenceID_"_"_PHCDTRowID_"$"_$P(FreqTimeDose,"-",Freqi)
										}
									}
									s Freqi=Freqi+1
								}
							}
						}
					}
					if (WeekFlag="Y"){
						s OrderFreqDispTime=$replace(OrderFreqDispTime,"|",$C(1))
						s OrderFreqDispTime=$replace(OrderFreqDispTime,"^",$C(2))
						s OrderFreqDispTimeStr=OrderFreqDispTime
					}
				}elseif DoseQty'=""{
					s SameFreqDifferentDosesFlag="N"
					s DARCIMRowid=$o(^DHCItmMast("0","ARCIM",ARCIMRowid,""))
					if (DARCIMRowid'="") s SameFreqDifferentDosesFlag=$P(^DHCItmMast(DARCIMRowid),"^",22)
					b ;同频次不同剂量医嘱
					if SameFreqDifferentDosesFlag="Y"{
						s PHCDTRowID=0	for {
							s PHCDTRowID=$O(^PHCFR(+FrequenceID,"DT",PHCDTRowID)) Q:PHCDTRowID=""
							s DispTime=$p(^PHCFR(+FrequenceID,"DT",PHCDTRowID),"^")
							continue:DispTime=""
							s DispTimeList(DispTime)=PHCDTRowID
						}
						s DispCount=0
						s DispTime="" for{
							s DispTime=$O(DispTimeList(DispTime)) Q:DispTime=""
							s str=FrequenceID_"_"_DispTimeList(DispTime)_"$"_$P(DoseQty,"-",$I(DispCount))
							if OrderFreqTimeDoseStr="" s OrderFreqTimeDoseStr=str
							else  s OrderFreqTimeDoseStr=OrderFreqTimeDoseStr_"!"_str
						}
					}
				}
			}
			s:OrderFreqTimeDoseStr'="" DoseQty=""
			b ;OrderFreqTimeDoseStr
			s ExpStr=DHCDocOrderStageID_"^"_DHCMustEnter_"^"_PackQtyBillUOMDR_"^"_SpeedFlowRate_"^"_FlowRateUnitDR
			s ExpStr=ExpStr_"^"_OrderBodyPartLabel_"^"_SkinTest_"^"_SkinTestActionDr_"^"_NotifyClinician_"^"_RemoveCeler
			s ExpStr=ExpStr_"^"_OrderFreqTimeDoseStr_"^"_OrderFreqDispTimeStr
			
			s retSub=##class(web.DHCARCOrdSets).InsertItem(ARCOSRowid,ARCIMRowid,PackQty,DoseQty,DoseUOMID,
				FrequenceID,DurationID,InstructionID,ARCOSItmLinkDoctor,Tremark,
				OECPRRowId,SampleId,NO,OrderPriorRemarksDR,OrderRecLoc,
				ExpStr)
			if (+retSub<=0){
				s MsgInfo=MsgInfo_";编号"_ARCOSNum_"医嘱套,"_ARCIMCode_"保存失败"_retSub
				s ItemDetailsNum=-1
				q
			}else{
				s ItemDetailsNum=ItemDetailsNum+1
			}
			
		}
		if (ItemDetailsNum<0){
			TRO
		}else{
			TC
			s SuccessNum=SuccessNum+ItemDetailsNum
		}
		
	}
	q SuccessNum_"^"_MsgInfo
}

/// 查询用户常用信息
/// 谭吉善 2019-05-24 ,RelevanceNo:%String
Query FindDocItemDefault(objtype, objvalue, HospRowId = "") As websys.Query(CONTAINID = 0, ROWSPEC = "ObjectType:%String:*存储类型代码,ObjectDesc:%String:存储类型描述,ObjectCode:%String:*保存类型值,HospCode:%String:*院区代码,ARCIMCode:%String:*医嘱项代码,ArcimDesc:%String:医嘱项,Priority:%String:医嘱类型,Dose:%String:单次剂量,DoseUom:%String:剂量单位,Instr:%String:用法,PHFreq:%String:频次,Durat:%String:疗程,PackQty:%String:数量,SkinTest:%String:皮试,SkinAction:%String:皮试备注,Notes:%String:备注,TPAAdmType:%String:就诊类型,SpeedFlowRate:%String:流速,FlowRateUnit:%String:流速单位,ExceedReason:%String:超量原因,RecLocDesc:%String:接收科室,RecLocCode:%String:*接收科室代码,RecLocHospCode:%String:接收科室所在院区代码,OrderFreqTimeDoseStr:%String:同频次不同剂量串,OrderFreqWeekStr:%String:周频次选择串,PackUom:%String:数量单位")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocPrefTabs","FindDocItemDefault","User.CTLoc","111")
/// d ##class(%ResultSet).RunQuery("web.DHCDocPrefTabs","FindDocItemDefault","","")
ClassMethod FindDocItemDefaultExecute(ByRef QHandle As %Library.Binary, objtype, objvalue, HospRowId = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^tan("FindDocItemDefault")=objtype_","_objvalue
	if (HospRowId="")&&($d(%session)) s HospRowId=%session.Get("LOGON.HOSPID")
	s (UserID,LocDr)=""
	if (objtype="User.SSUser"){
		s UserID=objvalue
		d OutputDocItemDefaultData
	}elseif (objtype="User.CTLoc"){
		s LocDr=objvalue
		d OutputDocItemDefaultData
	}else{
		s (UserID,LocDr)=""
		for {
			s UserID=$O(^DHCDID(0,"Contral","User",UserID))
			q:UserID=""
			d OutputDocItemDefaultData
		}
		s (UserID,LocDr)=""
		for {
			s LocDr=$O(^DHCDID(0,"Contral","Location",LocDr))
			q:LocDr=""
			continue:$p(^CTLOC(LocDr),"^",22)'=HospRowId
			d OutputDocItemDefaultData
		}
	}
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDocItemDefaultData
	s rs = ##class(%ResultSet).%New("web.DHCDocItemDefault:Find")
	do rs.Execute(UserID,"","","","","","","","","","","","",LocDr)
	while(rs.%Next()){
		
		s ARCIMDR=rs.GetDataByName("ARCIMDR")
		continue:(ARCIMDR="")
		continue:(""=$G(^ARCIM(+ARCIMDR,$P(ARCIMDR,"||",2),1)))
		s ARCIMCode=$p(^ARCIM(+ARCIMDR,$P(ARCIMDR,"||",2),1),"^",1)
		s ArcimDesc=rs.GetDataByName("ArcimDesc")
		s ContralTypeCode=rs.GetDataByName("ContralTypeCode")
		s ContralType=rs.GetDataByName("ContralType")
		s ContralKey=rs.GetDataByName("ContralKey")
		s ContralDesc=rs.GetDataByName("ContralDesc")
		s Priority=rs.GetDataByName("Priority")
		s Dose=rs.GetDataByName("Dose")
		s DoseUom=rs.GetDataByName("DoseUom")
		s Instr=rs.GetDataByName("Instr")
		s PHFreq=rs.GetDataByName("PHFreq")
		s Durat=rs.GetDataByName("Durat")
		s PackQty=rs.GetDataByName("PackQty")
		s SkinTest=rs.GetDataByName("SkinTest")
		s SkinActionDR=rs.GetDataByName("SkinActionDR")
		s SkinAction=rs.GetDataByName("SkinAction")
		s RelevanceNo=rs.GetDataByName("RelevanceNo")
		s Notes=rs.GetDataByName("Notes")
		s TPAAdmType=rs.GetDataByName("TPAAdmType")
		s SpeedFlowRate=rs.GetDataByName("SpeedFlowRate")
		s FlowRateUnit=rs.GetDataByName("FlowRateUnit")
		s ExceedReason=rs.GetDataByName("ExceedReason")
		s RecLocDr=rs.GetDataByName("RecLocDr")
		s OrderFreqTimeDoseStr=rs.GetDataByName("OrderFreqTimeDoseStr")
		s PHFreqDR=rs.GetDataByName("PHFreqDR")
		s OrderFreqWeekStr=""
		if (PHFreqDR'=""){
			s WeekFlag=$P(^PHCFR(PHFreqDR),"^",9)
			if (WeekFlag="Y"){
				s OrderFreqWeekStr=$P(rs.GetDataByName("PHFreq"),"-",2)
				}
		}
		s Rowid=rs.GetDataByName("Rowid")
		s Data=$g(^DHCDID(Rowid))
		s PHFreq=$P(PHFreq,"-",1)
		s OrderFreqDispTimeStr=$p($g(Data),"^",29)
		if (OrderFreqDispTimeStr'="")&&(PHFreqDR'=""){
			s WeekFlag=$P(^PHCFR(PHFreqDR),"^",9)
			s FreeTimeFreqFlag=$P(^PHCFR(PHFreqDR),"^",13)
			if (FreeTimeFreqFlag="Y"){
				s OrderFreqFreeTimeStr=""
				for i=1:1:$L(OrderFreqDispTimeStr,$C(1)){
					s ArrData=$P(OrderFreqDispTimeStr,$C(1),i)
					s DispTime=$P(ArrData,$C(2),1)
					s PHCDTRowID=$P(ArrData,$C(2),3)
					s PHCDTDesc=$P($G(^PHCFR(+PHCDTRowID,"DT",$P(PHCDTRowID,"_",2))),"^",2)
					if (OrderFreqFreeTimeStr=""){
						s OrderFreqFreeTimeStr=$P(ArrData,$C(2),1)_"^"_$P(ArrData,$C(2),2)_"^"_PHCDTDesc
					}else{
						s OrderFreqFreeTimeStr=OrderFreqFreeTimeStr_"|"_$P(ArrData,$C(2),1)_"^"_$P(ArrData,$C(2),2)_"^"_PHCDTDesc
					}
				}
				s PHFreq=PHFreq_"-"_OrderFreqFreeTimeStr
				}
			if (WeekFlag="Y"){
				s OrderFreqDispTimeStr=$replace(OrderFreqDispTimeStr,$C(1),"|")
				s OrderFreqDispTimeStr=$replace(OrderFreqDispTimeStr,$C(2),"^")
				s PHFreq=PHFreq_"-"_OrderFreqDispTimeStr
				}
			}
	
		
		s PackUom=rs.GetDataByName("PackUom")
		
		s (ObjectType,ObjectDesc,ObjectCode,HospCode)=""
		if ContralTypeCode="User" {
			s ObjectType="User.SSUser"
			s ObjectDesc=$p($g(^SSU("SSUSR",+ContralKey)),"^",2)
			s ObjectCode=$p($g(^SSU("SSUSR",+ContralKey)),"^",1)
		}
		if ContralTypeCode="Location" {
			s ObjectType="User.CTLoc"
			&SQL(SELECT CTLOC_Desc ,CTLOC_Code,CTLOC_Hospital_DR->HOSP_Code INTO:ObjectDesc,:ObjectCode,:HospCode FROM SQLUSER.CT_Loc WHERE CTLOC_Rowid=:ContralKey )
		}
		s (RecLocDesc,RecLocCode,RecLocHospCode)=""
		if (RecLocDr'=""){
			&SQL(SELECT CTLOC_Desc ,CTLOC_Code,CTLOC_Hospital_DR->HOSP_Code INTO:RecLocDesc,:RecLocCode,:RecLocHospCode FROM SQLUSER.CT_Loc WHERE CTLOC_Rowid=:RecLocDr )
		}
		set Data=$lb(ObjectType,ObjectDesc,ObjectCode,HospCode,ARCIMCode,ArcimDesc,Priority,Dose,DoseUom,Instr,PHFreq,Durat,PackQty,SkinTest,SkinAction,Notes,TPAAdmType,SpeedFlowRate,FlowRateUnit,ExceedReason,RecLocDesc,RecLocCode,RecLocHospCode,OrderFreqTimeDoseStr,OrderFreqWeekStr,PackUom) //RelevanceNo
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	q
}

/// 导出用法常用列表 谭吉善
/// w ##class(web.DHCDocPrefTabs).ExportDocItemDefaultXls("","","ALL")
/// w ##class(web.DHCDocPrefTabs).ExportDocItemDefaultXls("User.SSUser",10209,10209)
ClassMethod ExportDocItemDefaultXls(objtype, objvalue, xlsname As %String = "") As %String
{
	s ^tempscl("ExportDocItemDefaultXls")=objtype_","_objvalue_","_xlsname
	i xlsname="" s xlsname=$tr(objtype,".","_")_objvalue
	s ClassQuery="web.DHCDocPrefTabs:FindDocItemDefault"
	s rs = ##class(%ResultSet).%New(ClassQuery)
	s componentxml ="\\temp\\excel\\"
	s path = ##class(ext.util.String).GetPhysicalPath("",componentxml)
	s path="\"_$p(path,"\",2,$l(path,"\"))
	
	Set PhyDir = ##class(ext.util.String).GetPhysicalPath("",componentxml)
	if ('##class(%File).DirectoryExists(PhyDir)){
		d ##class(%File).CreateDirectory(PhyDir)
	}
	
	Set file=##class(%File).%New(PhyDir_xlsname_"DocItemDefault.xls")
	Do file.Open("NWRS")
	s TitleList=..GetQueryTitleList(ClassQuery)
	s TitlenNameList=$P(TitleList,$C(1),2)
	s TitleIDList=$P(TitleList,$C(1),1)
	Do file.WriteLine(TitlenNameList)
	do rs.Execute(objtype,objvalue)
	s len = rs.GetColumnCount()
	while(rs.%Next()){
		s OneColumn=""
		for i=1:1:$L(TitleIDList,$C(9)){
			s OneData=rs.GetDataByName($P(TitleIDList,$C(9),i))
			if (OneColumn=""){
				s OneColumn=OneData
			}else{
				s OneColumn=OneColumn_$C(9)_OneData
			}
		}
		Do file.WriteLine(OneColumn)
	}			
	d rs.%Close()		
	do file.Close()
	do file.%Close()
	q 1
}

/// 批量导入用法常用
/// 谭吉善 2019-05-22
/// w ##class(web.DHCDocPrefTabs).ImportDocItemDefaultXls(^tan("ImportDocItemDefaultXls"),1)
ClassMethod ImportDocItemDefaultXls(Data As %String, LogonUserID As %String, LogonHospID = "") As %String
{
	s ^Tempscl("ImportDocItemDefaultXls")=Data_","_LogonUserID
	s LogonHospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospID)
	//s ^tan("ImportDocItemDefaultXls")=Data
	s MsgInfo=""
	s SuccessNum=0
	For i=1:1:$l(Data,$c(1)) {
		s OneData=$P(Data,$c(1),i)
		s ObjectType=$P(OneData,$C(2),1)
		s ObjectCode=$P(OneData,$C(2),2)
		s HospCode=$P(OneData,$C(2),3)
		s ARCIMCode=$P(OneData,$C(2),4)
		s Priority=$P(OneData,$C(2),5)
		s Dose=$P(OneData,$C(2),6)
		s DoseUom=$P(OneData,$C(2),7)
		s Instr=$P(OneData,$C(2),8)
		s PHFreq=$P(OneData,$C(2),9)
		s Durat=$P(OneData,$C(2),10)
		s PackQty=$P(OneData,$C(2),11)
		s SkinTest=$P(OneData,$C(2),12)
		s SkinAction=$P(OneData,$C(2),13)
		s Notes=$P(OneData,$C(2),14)
		s TPAAdmType=$P(OneData,$C(2),15)
		s SpeedFlowRate=$P(OneData,$C(2),16)
		s FlowRateUnit=$P(OneData,$C(2),17)
		s ExceedReason=$P(OneData,$C(2),18)
		s RecLocCode=$P(OneData,$C(2),19)
		s RecLocHospCode=$P(OneData,$C(2),20)
		s RelevanceNo=$P(OneData,$C(2),21)
		s OrderFreqTimeDoseStr=$P(OneData,$C(2),22)
		if (OrderFreqTimeDoseStr'="") s Dose=""
	    /*s OrderFreqWeekStr=$P(OneData,$C(2),23)
	    s OrderFreqWeekStr=$replace(OrderFreqWeekStr,"#",$C(2))
		s OrderFreqWeekStr=$replace(OrderFreqWeekStr,"!",$C(1))
		if (OrderFreqWeekStr'="") s PHFreq=$p(PHFreq,"-",1)*/
		s OrderFreqDispTime=$p(PHFreq,"-",2)
		s PHFreq=$p(PHFreq,"-",1)
		
	    s PackUom=$P(OneData,$C(2),24)
		if (ARCIMCode=""){
			s MsgInfo=MsgInfo_";第"_i_"行医嘱项代码"_ARCIMCode_"为空"
			continue
		}
		s ARCIMDR=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ARCIMCode),0))
		if (ARCIMDR'=""){
			s ARCIMDR=ARCIMDR_"||"_$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ARCIMCode),ARCIMDR,0))
		}
		if (ARCIMDR=""){
			s MsgInfo=MsgInfo_";第"_i_"行医嘱项代码"_ARCIMCode_"找不到有效医嘱"
			continue
		}
		s ContralKey=..GetObjectValue(ObjectCode,ObjectType,HospCode)
		if (ObjectType="User.SSUser"){
			s ContralType="User"
		}elseif (ObjectType="User.CTLoc"){
			s ContralType="Location"
		}else{
			s MsgInfo=MsgInfo_";第"_i_"行无效的存储类型"
			continue
		}
		if (ContralKey=""){
			s MsgInfo=MsgInfo_";第"_i_"行无效的存储类型值"
			continue
		}
		s (PriorityDR,DoseUomDR,InstrDR,PHFreqDR,DuratDR)=""
		s (SkinActionDr,ExceedReasonDR,FlowRateUnitDR)=""
		s:Priority'="" PriorityDR=$O(^OECPR(0,"Desc",$$ALPHAUP^SSUTIL4(Priority),0))
		s:DoseUom'="" DoseUomDR=$O(^CT("UOM",0,"Desc",$$ALPHAUP^SSUTIL4(DoseUom),0))
		s:Instr'="" InstrDR=$O(^PHCIN(0,"Desc1",$$ALPHAUP^SSUTIL4(Instr),0))
		s:PHFreq'="" PHFreqDR=$O(^PHCFR(0,"Desc1",$$ALPHAUP^SSUTIL4(PHFreq),0))
		s:Durat'="" DuratDR=$O(^PHCDU(0,"Desc1",$$ALPHAUP^SSUTIL4(Durat),0))
		
		s:SkinAction'="" SkinActionDr=$O(^OEC("ACT",0,"Desc",SkinAction,0))
		s OrderSeqNo=""
		if (ExceedReason'=""){
			&SQL(SELECT DHCExceed_RowID INTO :ExceedReasonDR FROM SQLUser.DHCDoc_ExceedReason WHERE DHCExceed_Desc=:ExceedReason)
			if (SQLCODE){
				s ExceedReasonDR=""
			}
		}
		s:FlowRateUnit'="" FlowRateUnitDR=$O(^OEC("SFR",0,"Desc",$$ALPHAUP^SSUTIL4(FlowRateUnit),0))
		s RecLocDr=..GetObjectValue(RecLocCode,"User.CTLoc",HospCode)
		s PAAdmType=$CASE(TPAAdmType,"住院":"I","门诊":"O","急诊":"E","体检":"H",:"O")
		s PackUomDR=..GetObjectValue(PackUom,"User.CTUOM",HospCode)
		s OrderFreqDispTimeStr=""
		if ((OrderFreqDispTime'="")&&(PHFreqDR'="")){
				s WeekFlag=$P(^PHCFR(PHFreqDR),"^",9)
				s FreeTimeFreqFlag=$P(^PHCFR(PHFreqDR),"^",13)
				if (FreeTimeFreqFlag="Y"){
					for i=1:1:$L(OrderFreqDispTime,"|"){
						s ArrData=$P(OrderFreqDispTime,"|",i)
						s PHCDTRowID=""
						for {
							s PHCDTRowID=$O(^PHCFR(+PHFreqDR,"DT",PHCDTRowID))
							q:PHCDTRowID=""
							s Desc=$P($G(^PHCFR(+PHFreqDR,"DT",PHCDTRowID)),"^",2)
							if (Desc=$P(ArrData,"^",3)){
								if (OrderFreqDispTimeStr=""){
									s OrderFreqDispTimeStr=$P(ArrData,"^",1)_$C(2)_$P(ArrData,"^",2)_$C(2)_+PHFreqDR_"_"_PHCDTRowID
								}else{
									s OrderFreqDispTimeStr=OrderFreqDispTimeStr_$C(1)_$P(ArrData,"^",1)_$C(2)_$P(ArrData,"^",2)_$C(2)_+PHFreqDR_"_"_PHCDTRowID
								}
								}
							}
					}
					}
				if (WeekFlag="Y"){
					s OrderFreqDispTime=$replace(OrderFreqDispTime,"|",$C(1))
					s OrderFreqDispTime=$replace(OrderFreqDispTime,"^",$C(2))
					s OrderFreqDispTimeStr=OrderFreqDispTime
					}
				}
			b ;099
		s ItemStr=ARCIMDR_"^"_ContralType_"^"_ContralKey_"^"_PriorityDR_"^"_Dose
		s ItemStr=ItemStr_"^"_DoseUomDR_"^"_InstrDR_"^"_PHFreqDR_"^"_DuratDR_"^"_PackQty
		s ItemStr=ItemStr_"^"_SkinTest_"^"_SkinActionDr_"^"_RelevanceNo_"^"_OrderSeqNo_"^"_Notes
		s ItemStr=ItemStr_"^"_PAAdmType_"^"_ExceedReasonDR_"^"_SpeedFlowRate_"^"_FlowRateUnitDR_"^"_RecLocDr_"^"_OrderFreqTimeDoseStr_"^"_OrderFreqDispTimeStr_"^"_PackUomDR
		s ret=##Class(web.DHCDocItemDefault).Insert(ItemStr, LogonUserID,LogonHospID)
		if (+ret=0){
			s SuccessNum=SuccessNum+1
		}elseif (ret="-101"){
			s MsgInfo=MsgInfo_";第"_i_"行已存在相同的数据，无需导入"
		}else{
			s MsgInfo=MsgInfo_";第"_i_"行导入失败:"_$replace(ret,"^",",")
		}
	}
	q SuccessNum_"^"_MsgInfo
}

/// 获取query的返回列表title
ClassMethod GetQueryTitleList(ClassQuery As %String) As %String
{
	s ROWSPEC=$G(^oddCOM($P(ClassQuery,":"),"q",$P(ClassQuery,":",2),"P","ROWSPEC"))
	s TitleList=""
	s TitlenNameList=""
	for i=1:1:$Length(ROWSPEC,",") {
		s oneTitle=$P(ROWSPEC,",",i)
		s TitleName=$P(oneTitle,":",3)
		i TitleName="" s TitleName=$P(oneTitle,":",1)
		s Title=$P(oneTitle,":",1)
		
		if (TitleList=""){
			s TitleList=Title
		}else{
			s TitleList=TitleList_$C(9)_Title
		}
		if (TitlenNameList=""){
			s TitlenNameList=TitleName
		}else{
			s TitlenNameList=TitlenNameList_$C(9)_TitleName
		}
	}
	q TitleList_$C(1)_TitlenNameList
}

/// 更新医嘱模板->医嘱项备注
/// 入参: websysPrefId模板ID、NameTabIndex修改表索引、ListGroupIndex修改子表索引、OrdItemIndex修改医嘱项索引、OrdItemNotes医嘱备注
/// w ##class(web.DHCDocPrefTabs).websysSaveOEItemNotes(5603,1,1,2,"超声测试备注")
ClassMethod websysSaveOEItemNotes(websysPrefId As %Library.String = "", NameTabIndex As %Library.String = "", ListGroupIndex As %Library.String = "", OrdItemIndex As %Library.String = "", OrdItemNotes As %Library.String = "")
{
	s ^tempscl("websysSaveOEItemNotes")=websysPrefId_","_NameTabIndex_","_ListGroupIndex_","_OrdItemIndex_","_OrdItemNotes
	TS
	s groupitemDelim=$C(28)
	s itemdataDelim=$C(4)
	s tabgroupDelim=$C(1)

	s obj=##Class(websys.Preferences).%OpenId(websysPrefId)
	s OldData=obj.Data
	s ChartID=$lg(OldData,1)
	s eprChartFrameSize=$lg(OldData,2)
	s OldTABLIST=$lg(OldData,3)
	s NoShowAlias=$lg(OldData,4)
	s NoShowAliasSameCode=$lg(OldData,5)
	
	s OldUpdateTab=$lg(OldTABLIST,NameTabIndex)
	s OldUpdateTabLen=$l(OldUpdateTab,tabgroupDelim)
	s OldUpdateTabData=$p(OldUpdateTab,tabgroupDelim,2,OldUpdateTabLen)
	s OldUpdateTabGroupData=$p(OldUpdateTabData,tabgroupDelim,ListGroupIndex)
	/*
	"西药"_$c(28)_
	"ARCIM"_$c(4)_"308||1"_$C(4)_测试备注_$c(28)_"ARCIM"_$c(4)_"11496||1"_$c(28)_"ARCIM"_$c(4)_"5761||1"_$c(28)_"ARCIM"_$c(4)_"2727||1*S*12BA13B*"_$c(28)_"ARCIM"_$c(4)_"311||1"_$c(28)_"ARCIM"_$c(4)_"680||1"_$c(28)_"ARCOS"_$c(4)_"3734"
	*/
	s OldUpdateTabGroupDataLen=$l(OldUpdateTabGroupData,groupitemDelim)
	s OldUpdateTabGroupItemDataStr=$p(OldUpdateTabGroupData,groupitemDelim,2,OldUpdateTabGroupDataLen)
	
	s OldUpdateTabGroupItem=$p(OldUpdateTabGroupItemDataStr,groupitemDelim,OrdItemIndex)
	s $p(OldUpdateTabGroupItem,itemdataDelim,3)=OrdItemNotes
	s NewUpdateTabGroupItem=OldUpdateTabGroupItem
	s $p(OldUpdateTabGroupItemDataStr,groupitemDelim,OrdItemIndex)=NewUpdateTabGroupItem
	s NewUpdateTabGroupItemDataStr=OldUpdateTabGroupItemDataStr
	s $p(OldUpdateTabGroupData,groupitemDelim,2,OldUpdateTabGroupDataLen)=NewUpdateTabGroupItemDataStr
	s NewUpdateTabGroupData=OldUpdateTabGroupData
	s $p(OldUpdateTabData,tabgroupDelim,ListGroupIndex)=NewUpdateTabGroupData
	s NewUpdateTabData=OldUpdateTabData
	s $p(OldUpdateTab,tabgroupDelim,2,OldUpdateTabLen)=NewUpdateTabData
	s NewUpdateTab=OldUpdateTab
	s $list(OldTABLIST,NameTabIndex)=NewUpdateTab
	s NewTABLIST=OldTABLIST
	s Data=$LB(ChartID,eprChartFrameSize,NewTABLIST,NoShowAlias,NoShowAliasSameCode)
	s obj.Data=Data
	s sc=obj.%Save()
	if $$$ISERR(sc){
		Do $System.Status.DisplayError()
		Trollback
		Quit "-100"
	}
	TC
	d obj.%Close() 
	s id=obj.%Id()
	s obj=""
	Q 0_"^"_id
}

ClassMethod SetTemplClipBoradrData(MACAddress As %String, ClipBoradrData As %String) As %String
{
	q:MACAddress="" "-1"
	if $d(^DHCDocTemplClipBoradrData(MACAddress,+$h)){
		s ^DHCDocTemplClipBoradrData(MACAddress,+$h)=ClipBoradrData
	}else{
		;删除非本日数据，本日可粘贴多次
		k ^DHCDocTemplClipBoradrData(MACAddress)
		s ^DHCDocTemplClipBoradrData(MACAddress,+$h)=ClipBoradrData
	}
	Q 0
}

ClassMethod GetTemplClipBoradrData(MACAddress As %String) As %String
{
	s Data=$g(^DHCDocTemplClipBoradrData(MACAddress,+$h))
	d ..SetTemplClipBoradrData(MACAddress ,"")
	Q Data
}

// 修改模板表名

ClassMethod websysChangeOETabsName(id As %Library.String = "", SelTabIndex As %String, Name As %String) As %String
{
	Q:id="" 0
	set OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("websys.Preferences"_$c(2)_id)
	s OldDataJson=##Class(web.DHCDocDataChangeLog).GetDocPreTabs(OldDataJson)
	s obj=##Class(websys.Preferences).%OpenId(id)
	s OldData=obj.Data
	s ChartID=$list(OldData,1)
	s eprChartFrameSize=$list(OldData,2)
	s NoShowAlias=$list(OldData,4)
	s NoShowAliasSameCode=$list(OldData,5)
	s listTable=$list(OldData,3)
	s TABLIST=""
	s tabidx=1
	for i=1:1:$listlength(listTable) {
		if ("^"_SelTabIndex_"^")[("^"_i_"^") {
			s OneStr=$list(listTable,i)
			s $P(OneStr,$C(1),1)=Name
			s $List(TABLIST,tabidx)=OneStr
		}else{
			s $List(TABLIST,tabidx)=$list(listTable,i)
			}
		s tabidx=tabidx+1
	}
	s Data=$LB(ChartID,eprChartFrameSize,TABLIST,NoShowAlias,NoShowAliasSameCode)
	s ^tempscl("ff")=Data
	b //12
	s obj.Data=Data
	s save=obj.%Save()
	
	d obj.%Close()
	
	set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("websys.Preferences"_$c(2)_id)
	s NewDataJson=##Class(web.DHCDocDataChangeLog).GetDocPreTabs(NewDataJson)
	;医生站业务数据修改日志
	d ##class(web.DHCDocDataChangeLog).SaveLog("websys.Preferences","websys.Preferences","医嘱模板信息","websys.Preferences_"_id,"","U",NewDataJson,OldDataJson)
	
	q 0
}

}
