Class web.DHCNUREMRNEWOnPageIP Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s episodeID = $Get(%request.Data("EpisodeID",1),"")
	q:(episodeID="") $$$OK
	
	s patientID = $Get(%request.Data("PatientID",1),"")
	//q:(patientID="") $$$OK
	
	s parentID = $Get(%request.Data("node",1),"-1")
	s ^okkkkk(parentID)=""
	
	s ifAllModel=$Get(%request.Data("IfAllModel",1),"")
	s searchCode=$Get(%request.Data("SearchCode",1),"")
	s workGroupID = $g(%session.Data("LOGON.GROUPID")) 	//当前登录医生的安全组
	s userID = %session.Get("LOGON.USERID")				//当前登录用户ID
	s userLoc = %session.Get("LOGON.CTLOCID")			//当前登录用户科室

	s searchCode=$ZConvert(searchCode,"U")
	i searchCode="BI" s searchCode="BARTHEL"
	d ..GetJason(parentID, episodeID, userID, userLoc, workGroupID,ifAllModel,searchCode)
	
	Quit $$$OK
}

ClassMethod GetJason(parentID, episodeID, userID, userLoc, workGroupID, ifAllModel, searchCode)
{
	s ^CaheTempDHCEPRDebug("actionappointchapter","input") = parentID_"^"_episodeID_"^"_userID_"^"_userLoc_"^"_workGroupID_"^"_ifAllModel_"^"_searchCode
	s type = $E(parentID,1,2)
	s id = $E(parentID,3,$l(parentID))
	w "["
	if type = "RT"
	{	
	  d ..GetCategoryJason(episodeID, userID, userLoc, workGroupID)
	}
	elseif type = "CG"
	{	
	  d ..GetCateChapterJason(id,episodeID, userID, userLoc, workGroupID,ifAllModel,searchCode)
	}elseif type = "VU"
	{	
	  d ..GetVUEJason(episodeID, userID, userLoc, workGroupID)
	}
	
	w "]"
}

/// pengjunfu 2017-10-18
/// 获取新版诊疗界面护理病历界面保存过记录的模版数据
ClassMethod GetVUEJason(episodeID, userID, userLoc, workGroupID)
{
	s parentId = " 0"
	s curCategoryId = ""
	i '$d(^User.DHCNURMenuI("LocIndex"," "_userLoc)) s userLoc=""
	k depsort
	s code=""  f  s code=$O(^User.DHCNURMenuI("codeIndex",code)) q:(code="")  d
	.s subchl=""  f  s subchl=$O(^User.DHCNURMenuI("codeIndex",code,subchl)) q:(subchl="")  d
  	..s seqsub=$tr(code," ","")
  	..q:seqsub=""
  	..s depsort(seqsub)=subchl
	s count = 0
	s ch=""
	for {
		s ch=$O(depsort(ch)) 
	    q:ch=""
	    s curCategoryId=depsort(ch)
		q:(curCategoryId="") 
		s a=##class(User.DHCNURMenu).%OpenId(curCategoryId)
		s desc =a.name
		s code=a.code
		s gid=curCategoryId
		s qflag=""

		//^User.DHCNURMenuSubI("gIdCode"," 6"," DHCNURPGD_YLGTYHLD",6,229)
		i qflag'="" continue
		
		s subMenuCount = 0
		k depcodesort
		s submseq=""  f  s submseq=$O(^User.DHCNURMenuSubI("gIdCode"," "_gid,submseq)) q:(submseq="")  d
	    .s submchl=""  f  s submchl=$O(^User.DHCNURMenuSubI("gIdCode"," "_gid,submseq,gid,submchl)) q:(submchl="")  d
        ..s submseqsub=$tr(submseq," ","")
        ..q:submseqsub=""
        ..s depcodesort(submseqsub)=gid_"||"_submchl
        s subch = ""
        s subMenus=##class(%ListOfDataTypes).%New()
		for {
		    s subch=$O(depcodesort(subch)) 
	        q:subch=""
	        s rowid=depcodesort(subch)
 	        s a=##class(User.DHCNURMenuSub).%OpenId(rowid)
			s code=a.Code
			s name=a.Name
			s flag=..ifSaved(episodeID,code)
			continue:flag=0
			s subMenu=##class(%ArrayOfDataTypes).%New()
			d subMenu.SetAt(flag,"flag")
			d subMenu.SetAt(code,"code")
			d subMenu.SetAt(name,"name")
			d subMenus.Insert(subMenu)
		}

			
			
		continue:subMenus.Count()=0
		s count = count + 1
		if count>1 w ","
		s menu=##class(%ArrayOfDataTypes).%New()
		d menu.SetAt(gid,"ID")
		d menu.SetAt(desc,"name")
		d menu.SetAt(subMenus,"subMenus")
		d ##class(Nur.JSON).EncodeByWrite(menu)
	}
}

// w ##class(web.DHCNUROnPage).GetCategoryJason("171","5211","5","103")

ClassMethod GetCategoryJason(episodeID, userID, userLoc, workGroupID)
{
	//s parentId = "RT0"
	//s parentType = $e(parentId,1,2)
	//s parentId = $e(parentId, 3, $l(parentId))	
	//s parentId = " "_parentId
	
	//s isTplPrivActive = ##class(EPRservice.DocRestLogic.PrivLogic).CheckTPrivActivity()
	//s curPatInfo = ##class(EPRservice.DocRestLogic.PrivLogic).GetPatInfo(episodeID)
	
	//遍历根节点的第一层目录(Category类型)
	s parentId = " 0"
	s curCategoryId = ""
	s count = 0
	for {
		s curCategoryId = $o(^User.DHCNURMenuD(curCategoryId))
		q:(curCategoryId="")
		s a=##class(User.DHCNURMenu).%OpenId(curCategoryId)
		s desc =a.name
		s code=a.code
		
		s count = count + 1
		if count>2 d
		.w "{"
		.w "id:'CG"_curCategoryId_"'"
		.w ",text:'"_desc_"'"
		.w ",cls:'folder'"
		
		.//w ",checked:false"
		.w "}"
		.if count=3 d
		..w ","
	}
}

ClassMethod ifexist(DepModelStr, code)
{
	s l=$l(DepModelStr,"^")
	s ^oiii(code)=DepModelStr
	s ret=""
	f i=0:1:l
	{
	 s itm=$P(DepModelStr,"^",i)
	 s codes=$p(itm,"|")
	 s codesdesc=$p(itm,"|",2)
     //if itm="" continue
     s codes=$ZConvert(codes,"U")
     i codes=code s ret=codesdesc
     //q:ret=1
	}
	q ret
}

/// w ##class(web.DHCNUREMRNEWOnPageIP).GetCateChapterJason("9","2194037",4147,"500","23","1","BRANDEN")
ClassMethod GetCateChapterJason(parentId, episodeID, userID, userLoc, workGroupID, ifAllModel, searchCode)
{
	
	//s parentType = $e(parentId,1,2)
	//s parentId = $e(parentId, 3, $l(parentId))
	s ^tmpyjn("GetCateChapterJason")=$lb(parentId, episodeID, userID, userLoc, workGroupID, ifAllModel, searchCode)
    i parentId=10 s id = 2
    i parentId=9 s id = 1
	//遍历第二层节点(CategoryChapter)
	//s ^objcyf13(id)=id
	s DepModelStr=..GetDepModel(userLoc)
	s AllStr=..GetDepModel("All") ///全院都显示的模板
	
	s DepModelStr=$zconvert(DepModelStr,"U")
	s count = 0
	s sort=""
	s chl=""  f  s chl=$O(^User.DHCNURMenuSubD(id,chl)) q:(chl="")  d
    .q:chl=""
    .s seqsub=""
    .s a=##class(User.DHCNURMenuSub).%OpenId(id_"||"_chl)
    .s seqsub=a.Seq
   
    .q:seqsub=""
    .s sort(id_"||"_chl)=id_"||"_chl
    
    s ch = ""
	for {
	    s ch=$O(sort(ch)) 
        q:ch=""
        s rowid=sort(ch)
        
        s a=##class(User.DHCNURMenuSub).%OpenId(rowid)
		s code=a.Code
		s name=a.Name
		s tmpName=##class(ext.util.String).ToChineseSpell(name)
		s tmpSearchCode=##class(ext.util.String).ToChineseSpell(searchCode)
		
		continue:tmpSearchCode'=searchCode&&(searchCode'="")&&(name'[searchCode)
		continue:tmpSearchCode=searchCode&&(searchCode'="")&&(tmpName'[searchCode)
		s code22=$ZConvert(code,"U")
		
		set realCode=code
		if code["_LIST" set realCode = $replace(code,"_LIST","")
		if realCode="DHCNURBG_ZYDGBGPGLB"  s realCode="DHCNURPGD_ZYDGBGPGB"
		if realCode="DHCNURPGD_ZKCPGD1"  s realCode="DHCNURPGD_ZKCPGD"
		s flag=..GetModelDataStatus(episodeID,realCode)
		
		if (flag=0)&(ifAllModel=0)&&(code'="DHCNURPGD_SCHLJL")&&(code'="DHCNURXH_YBHLJLD")&&(workGroupID'="104")&&(workGroupID'="175") continue   //住院未保存过的全院模板不显示 首次和一般护理除外 急诊医师和急诊护士安全组也除外 add by yjn 20171215
		//i (DepModelStr'[code22)&(flag=0) continue
		s ifret=..ifexist(DepModelStr,code22)
		s allret=..ifexist(AllStr,code22)
		
		i (ifret="")&(flag=0)&&(allret="") continue
		i ((userLoc=123)!(userLoc=436)!(userLoc=437))&&(allret'="") continue				; ljk 2016-11-02 急诊科不显示全院显示模版
		
		
		if (ifAllModel=2)&&(ifret="") continue  //增加只显示本科室模板的页签
		if (ifAllModel=1)&&(allret="") continue  
		
		s count = count + 1
		if count > 1 {w ","}
		w "{"
		w "id:'"_code_"'"
		i flag'=0 w ",text:'"_name_"'"
		e  w ",text:'"_name_"'"
		w ",leaf:'ture'"
		i flag'=0 w ",icon:'../scripts/nurse/image/unSaveSingle.gif'"
		e  w ",icon:'../scripts/nurse/image/saveSingle.gif'"
		w ",cls:'folder'"
		//w ",checked:false"
		w ",hasImage:true"
		//w ",attributes:true"
			//w "[{hasImage:true}]" 
		w "}"
			
	}
}

ClassMethod GetDepModel(LocId As %String) As %String
{
	//w ##class(web.DHCNurseRecordComm).GetDepModel("1")
	i LocId'="" d
	.s DepModelStr=$G(^DHCNurDepModelSet(LocId))
	.f ii=1:1:$L(DepModelStr,"^") d
	..s DepModel=$P(DepModelStr,"^",ii)
	..q:DepModel=""
	..s ModelKey=$P(DepModel,"|",1)
	..s ModelName=$P(DepModel,"|",2)
	..s ModelSort=$P(DepModel,"|",3)
	..s DepModel(ModelKey)=ModelKey_"|"_ModelName
	s ret=""
	s sort="" f  s sort=$O(DepModel(sort)) q:sort=""  d
	.s ret=ret_DepModel(sort)_"^"
 	q ret
}

ClassMethod IsHasImage(episodeID As %String, parentId As %String, curCategoryId As %String) As %String
{
	set now = $Horolog
	set endDate = $ZD(now, 3)
	set endTime = $ZT(now, 2)		
	set docIdList = ##class(EPRmeta.EPRTemplateCategory).GetSubPrtTemplateCategory(parentId, curCategoryId)		//若为第二层目录,传入两个参数
	q:(docIdList = "") "0"
	
	set logIdList = ##class(EPRservice.BOEPRLogs).GetLogIDByDate(episodeID, "1840-12-31", "0:00", endDate, endTime,  docIdList)	
	q:(logIdList = "") "0"

	//返回值格式：totImgaeCount$docID1^logsID1^printType1^imageCount1^hasTitlePage1#docID2^logsID2^printType2^imageCount2^hasTitlePage2
	set imageList = ##class(EPRservice.BOEPImage).GetEPImageCount(episodeID,logIdList)	
	s imageCount = $p(imageList, "$", 1)
	q:(imageCount = 0) "0"

	q "1"
}

/// CreateTime:2010-11-09
/// Creator:houj
/// Description:判断目录是否已经启用，即至少指定了一个安全组可以使用该目录
/// Input：	eprCategoryId：病历结构树第一层的id
/// Output: 无
/// Return: 1:已启用，0：未启用
/// Others:
ClassMethod IsEPRCateogryActived(eprCategoryId As %String) As %String
{
	s ssGroupID = $o(^DHCEPRM.EPRDOC.EPRSSGroupI("IdxCatalogSSGroup"," "_eprCategoryId,0))
	q:(ssGroupID="") "0"
	q "1"
}

/// d ##class(web.eprajax.actionappointchapter).Test()
ClassMethod Test()
{
	s input = $g(^CaheTempDHCEPRDebug("actionappointchapter","input"))
	s episodeID = $p(input,"^",1)
	s userID = $p(input,"^",2)
	s userLoc = $p(input,"^",3)
	s workGroupID = $p(input,"^",4)
	d ..GetJason(episodeID, userID, userLoc, workGroupID)
}

// d ##class(web.DHCNUREMRNEWOnPage).GetInCode("DHCNURLIST_DDZC")

ClassMethod GetInCode(RecTyp) As %String
{
   s ret="" 
   s RecTyp=$zconvert(RecTyp,"U")
   s id="" f  s id=$O(^User.DHCNURListLinkI("CodeIndex"," "_RecTyp,id)) q:id=""  d
 	.s a=##class(User.DHCNURListLink).%OpenId(id)
 	.s ret=a.InCode
  q ret
}

ClassMethod ifSaved(EpisodeID, EmrCode)
{
	s code=$ZConvert(EmrCode,"U")
	s DHCMoudid=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeID,""))
	q:DHCMoudid'="" 1
	s par=""  s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_EpisodeID,par))
	s id=""
	if par'=""
	{
		 s rw="" f  s rw=$o(^Nur.DHCNurseRecSubD(par,rw),1) q:(rw="")!(id'="")  d
		 .s tmp("Id")=par_"||"_rw
		 .s a=##class(Nur.DHCNurseRecSub).%OpenId(tmp("Id"))
		 .s CareDate=a.CareDate
		 .s CareDate=$zd(CareDate,3)
		 .s typ=a.RecTyp
		 .s typ=$ZConvert(typ,"U")
		 .i (typ=EmrCode)&&(a.RecCancelUser="") s id=CareDate
	 }	 
	 q:$g(id)'="" 1
	q 0
}

ClassMethod GetModelDataStatus(EpisodeID, EmrCode) As %String
{
	//w ##class(web.DHCNUREMRNEWOnPageIP).GetModelDataStatus("96","DHCNURPGD_BZSPDLB_LIST")
	s ret=0
	//s ^objcyfds(EpisodeID,EmrCode)=""
	s subFlag=0 //子模板标记
	if (EpisodeID'="")&&(EmrCode'="")
	{
	 s code=$ZConvert(EmrCode,"U")
	 s EmrCode=$ZConvert(EmrCode,"U")
	 s inflag=..GetInCode(code)
	 i inflag'="" s code=inflag
	 s id=""
	 ///健康宣教单
	 if (EmrCode="DHCNUREDUCATIONREC")
	 {
		 s EduId=$O(^User.DHCNurEducationRecI("Epi",EpisodeID,""))
		 i EduId'="" q 1
	 }
	 s DHCMoudid=""  f  s DHCMoudid=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeID,DHCMoudid)) q:DHCMoudid=""  d
	 .i DHCMoudid'="" d
	 ..s b=##class(Nur.DHCMoudData).%OpenId(DHCMoudid)
	 ..s EmrDate=b.EmrDate
	 ..s EmrDate=$zd(EmrDate,3)
	 ..;b ;3
	 ..i code="DHCNURXHFFYC" d
	 ...s Item12=b.Item12
	 ...s Item13=b.Item13
	 ...s Item14=b.Item14
	 ...s Item70=b.Item70
	 ...s Item71=b.Item71
	 ...i Item12'="" s EmrDate=Item12
	 ...i Item13'="" s EmrDate=Item13
     ...i Item14'="" s EmrDate=Item14
	 ...i Item70'="" s EmrDate=Item70
	 ...i Item71'="" s EmrDate=Item71
	 ..i code="DHCNURXHFFDD" d
	 ...s Item12=b.Item12
	 ...s Item13=b.Item13
	 ...s Item14=b.Item14
	 ...s Item68=b.Item68
	 ...s Item69=b.Item69
	 ...i Item12'="" s EmrDate=Item12
	 ...i Item13'="" s EmrDate=Item13
     ...i Item14'="" s EmrDate=Item14
	 ...i Item68'="" s EmrDate=Item68
	 ...i Item69'="" s EmrDate=Item69
	 
	 ..i (b.RecCancelUser="") s id=EmrDate
	 ..;b 
	 s par=""  s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_EpisodeID,par))
	 if par'=""
	 {
		 s rw="" f  s rw=$o(^Nur.DHCNurseRecSubD(par,rw),1) q:(rw="")!(id'="")  d
		 .s tmp("Id")=par_"||"_rw
		 .s a=##class(Nur.DHCNurseRecSub).%OpenId(tmp("Id"))
		 .s CareDate=a.CareDate
		 .s CareDate=$zd(CareDate,3)
		 .s typ=a.RecTyp
		 .s typ=$ZConvert(typ,"U")
		 .i (typ=EmrCode)&&(a.RecCancelUser="") s id=CareDate
	 }	 
	 if (EmrCode="DHCNURPFLIST")&(par'="")
	 {
		 //s id=""
		 s p="" f  s p=$O(^Nur.DHCMoudDataI("EmrCode"," DHCNURPFB"," "_EpisodeID,p),1) q:(p="")!(id'="")  d
 	     .s chl=""  f  s chl=$O(^Nur.DHCMoudDataD(p,"ChildRec",chl),1) q:(chl="")!(id'="")  d
 	     ..s a=##class(Nur.DHCMoudDataSub).%OpenId(p_"||"_chl)
 	     ..s canceluser=a.RecCancelUser
 	     ..q:(canceluser'="")
         ..s Item20=a.Item20
         ..s RecDate=a.EmrDate
         ..i Item20="" s Item20=$zd(RecDate,3)
         ..s id=Item20
	 }
	 // by lmm 多次列表模板
	 
	  s colorid="" f  s colorid=$o(^Nur.DHCNurChangeColorSetD(colorid)) q:colorid=""  d
	  .s a=##class(Nur.DHCNurChangeColorSet).%OpenId(colorid)
	  .s Keyword1=a.Keyword1
	  .s Keyword2=a.Keyword2
	  .s:Keyword2=EmrCode subFlag=1
	  .i (EmrCode=Keyword1) d	
	  ..s p="" f  s p=$O(^Nur.DHCMoudDataI("EmrCode"," "_Keyword2," "_EpisodeID,p),1) q:(p="")!(id'="")  d
 	  ...s chl=""  f  s chl=$O(^Nur.DHCMoudDataD(p,"ChildRec",chl),1) q:(chl="")!(id'="")  d
 	  ....s a=##class(Nur.DHCMoudDataSub).%OpenId(p_"||"_chl)
 	  ....s canceluser=a.RecCancelUser
 	  ....q:(canceluser'="")
      ....s id=chl
      
     //end
	}
	q:subFlag=1 0  //多次列表模板的单次模板过滤 by lmm
	i id'="" s ret=id
	q ret
}

/// yjn
/// 该方法判断某个单据的模板是否保存过
/// w ##class(web.DHCNUREMRNEWOnPage).JudgeIfSaved("PrnReport","DHCNURMouldPrn_SCHLJL")
ClassMethod JudgeIfSaved(typ As %String, EmrCode As %String) As %String
{
	s ret=0
	if EmrCode="" q 0
	s code=$ZConvert(EmrCode,"U")
	s EmrCode=$ZConvert(EmrCode,"U")
	s inflag=..GetInCode(code)
	i inflag'="" s code=inflag
	if (typ="WinTmp") {
		if ($o(^Nur.DHCNurseRecSubI("TypDat"," "_code,""))'="") {
			s ret=1
		}elseif ($o(^Nur.DHCMoudDataI("EmrCode"," "_code,""))'="") {
			s ret=1
		}else {
			s ret=0
		}
	}elseif (typ="PrnReport") {
		s modelTyp=""
		for {
			s modelTyp=$o(^User.DHCNURMoudelLinkI("PrintCodeIndex",modelTyp))
			q:(modelTyp="")!(ret=1)
			if ($o(^User.DHCNURMoudelLinkI("PrintCodeIndex",modelTyp," "_code))'="") {
				if ($o(^Nur.DHCNurseRecSubI("TypDat"," "_code,""))'="") {
					s ret=1
				}elseif ($o(^Nur.DHCMoudDataI("EmrCode"," "_code,""))'="") {
					s ret=1
				}
			}
		}	
	}
	q ret
}

/**************************************************/
/// 取某次就诊的开始日期，结束日期
/// InPut:EpisodeID
/// OutPut:StartDate,EndDate
ClassMethod GetDateByAdm(EpisodeID) As %String
{
	s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
	i AdmDate'=""  s StartDate=$zd(AdmDate,3)
	else  s StartDate=$Zd(+$h,3)
	s DischgDate=$p($g(^PAADM(EpisodeID)),"^",59)
    i DischgDate'=""  s EndDate=$zd(DischgDate,3)
    else  s EndDate=$Zd(+$h,3)
    
    q StartDate_"^"_EndDate
}

/// Creator：      huhm
/// CreatDate：    20090514
/// Description:： 根据就诊号或卡号(登记号)得到检验医嘱列表
/// Table：        OE_Order,OE_OrdItem,OE_OrdSpecimen
/// Input：        就诊号
/// Output：       医嘱ID,医嘱名称,医嘱申请日期和时间,结果状态,检验号,
///                报告ID,标本,标本采集日期和时间,接收日期和时间
///                审核日期和时间,是否有预报告,危急提示
///                OrdRowId,OrdName,ReqDate,ReqTime,ReportStus,LabEpisode,
///                LabTestSetRow,SpecName,SpecDate,SpecTime,RecDate,RecTime,
///                AuthDate,AuthTime,PreReport,WarnComm
/// Return：         函数返回值的说明
/// Others：        其它说明
Query QueryOrderList(parr As %String) As %Query(ROWSPEC = "OEOrdItemID:%String,OrdItemName:%String,OrdItemDate:%String,OrdItemTime:%String,ResultStatus:%String,LabEpisode:%String,LabTestSetRow:%String,OrdSpecimen:%String,SpecDate:%String,SpecTime:%String,RecDate:%String,RecTime:%String,AuthDate:%String,AuthTime:%String,PreReport:%String,WarnComm:%String,ResultFlagDesc:%String,Note:%String")
{
}

// d ##class(%ResultSet).RunQuery("web.DHCNURZSKOnPage","QueryOrderList","76##^^^^#2017-03-14#2017-03-29")

ClassMethod QueryOrderListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s ^tmpyjn("QueryOrderList")=$lb(parr)
    s EpisodeID=$p(parr,"#",1)
	s PatientID=$p(parr,"#",2)
	s Search=$p(parr,"#",3)
	s stdate=$p(parr,"#",4)
	s edate=$p(parr,"#",5)
	
	
	s ^obj65(1)=EpisodeID
	s ^obj65(2)=PatientID
	s ^obj65(3)=Search
	s ^obj65(4)=stdate
	s ^obj65(5)=edate
	s EpisodeID=$g(EpisodeID),PatientID=$g(PatientID)
	s SearchCriteria=$g(Search)
	s FromDate=$p(SearchCriteria,"^",1)
	i $l(FromDate) s FromDate=$zdh(FromDate,4)
	s ToDate=$p(SearchCriteria,"^",2)
	i $l(ToDate) S ToDate=$zdh(ToDate,4)
	//科室
	s LocCode=$p(SearchCriteria,"^",3)
	s LocId=""
	i $l(LocCode) s LocId=$o(^CTLOC(0,"Code",LocCode,""),-1)
	//是否审核
	s AuthFlag=$p(SearchCriteria,"^",4)
	//i '$l(AuthFlag) s AuthFlag="N"
	//所有医嘱
	s AllTS=$p(SearchCriteria,"^",5)
	i '$l(AllTS) s AllTS="N"
	k ^TMP($zn,$j)
    s ^WANGLI("LIS",EpisodeID)=EpisodeID_","_PatientID_","_SearchCriteria
	i AuthFlag="N",$l(EpisodeID) d GetOrderByEpisode(EpisodeID)
	i AuthFlag="",$l(EpisodeID) d GetOrderByEpisode(EpisodeID)
	i AuthFlag="Y",$l(PatientID) d
	.//^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
	.//s PAPERId=$o(^PAPERi("PAPMI_PatNo",CardID,""))
	.//i '$l(PAPERId) q
	.//^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
	.s type="" f  s type=$o(^PAPERdr(PatientID,"ADM",type)) q:type=""  d
	..s ADMId="" f  s ADMId=$o(^PAPERdr(PatientID,"ADM",type,ADMId),-1) q:ADMId=""  d
	...s AdmLoc=$p(^PAADM(ADMId),"^",4)
	...i $l(LocCode),LocCode'=AdmLoc q
	...d GetOrderByEpisode(ADMId)
	s date="" f  s date=$o(^TMP($zn,$j,date),-1) q:date=""  d
	.s time="" f  s time=$o(^TMP($zn,$j,date,time),-1) q:time=""  d
	..s LabNo="" f  s LabNo=$o(^TMP($zn,$j,date,time,LabNo)) q:LabNo=""  d
	...s OrdId="" f  s OrdId=$o(^TMP($zn,$j,date,time,LabNo,OrdId)) q:OrdId=""  d
	....s Data=$g(^TMP($zn,$j,date,time,LabNo,OrdId))
	....d OutputRow
	//i '$l(EpisodeID)	
	Set qHandle=$lb(0,repid,0)
	k TMP($zn,$j)
	Quit $$$OK
	
GetOrderByEpisode(EpisodeNo)
	k LabNoInfo
	s OrdId=""
	f {
		s OrdId=$o(^OEORD(0,"Adm",EpisodeNo,OrdId))
		q:OrdId=""
		s SubId=""
		f {
			s SubId=$o(^OEORD(OrdId,"I",SubId),-1)
			q:SubId=""
			s OrdRowId=OrdId_"||"_SubId
			s OrdStr1=$g(^OEORD(OrdId,"I",SubId,1))
			s OrdStr3=$g(^OEORD(OrdId,"I",SubId,3))
			s ItmMastDr=$p(OrdStr1,"^",2)
			s ItmStatusDD=$p(OrdStr1,"^",13)
			
			s ItmStatusFlag="N"
			i ItmStatusDD="2" s ItmStatusFlag="Y" //add by wudan  2011-10-08
			i ItmStatusDD="4" s ItmStatusFlag="Y" //add by wudan  2011-10-08
			i ItmStatusDD="10" s ItmStatusFlag="Y" //add by wudan  2011-10-08
			
			i $l(ItmMastDr),##class(web.DHCNurknowInterface).isLabTS(ItmMastDr){
				s OrdName=""
				i $l(ItmMastDr),$d(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)){
					s OrdName=$p(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1),"^",2)
				}
				//申请日期时间
				s ReqTime=$p(OrdStr1,"^",17)
				i $l(ReqTime) s ReqTime=$zt(ReqTime,2)
				s ReqDate=$p(OrdStr3,"^",7)
				s Stdate="",Edate=""
				i stdate'="" s Stdate=$zdh(stdate,3)
				i edate'="" s Edate=$zdh(edate,3)
				q:(Stdate'="")&(ReqDate<Stdate)
				q:(Edate'="")&(ReqDate>Edate)
				//比较日期
				s flag="N"
				//b 100
				i $l(ReqDate){
					i $l(FromDate),ReqDate-FromDate<0 s flag="Y"
					i flag="N",$l(ToDate),ReqDate-ToDate>0 s flag="Y"
				}
				//比较科室
				//i flag="N",$l(
				i $l(ReqDate) s ReqDate=$zd(ReqDate,3)
				//检验号
				s LabEpisode=$p(OrdStr3,"^",20)
				//b 20
				//报告ID
				s LabTestSetRow=$p(OrdStr3,"^",35)
				s ReportStus="N"
				s (RecDate,RecTime,AuthDate,AuthTime,TransComm)=""
				s ReportFlag="N"  //预报告
				//b 200 
			
				i flag="N"{
					i $l(LabTestSetRow){
						//i LabNo="2003044081" b ;预报告
						s LabNo=$p(LabTestSetRow,"||",1)
						s TS=$p(LabTestSetRow,"||",2)
						s TSCnt=$p(LabTestSetRow,"||",3)
					
						i $l(LabNo),$l(TS),$l(TSCnt),$d(^TEPI(LabNo,1,TS,TSCnt)){
						
							i $p(^TEPI(LabNo,1,TS,TSCnt),"\",31)="A" s ReportStus="Y"
							//i ('$l(AuthFlag))!('((ReportStus="N")&(AuthFlag="Y")))
							
							i AuthFlag="Y" {
								i ReportStus'="Y" s flag="Y"
							}
							i AuthFlag="N" {
								i ReportStus="Y" s flag="Y"
							}
							i flag="N"{
								//b 200
								//接收日期时间
								/*
								s RecDate=$p(^TEPI(LabNo,1,TS,TSCnt),"\",21)
								i $l(RecDate) s RecDate=$zd(RecDate,3)
								s RecTime=$p(^TEPI(LabNo,1,TS,TSCnt),"\",22)
								i $l(RecTime) s RecTime=$zt(RecTime*60,2)
								s RecDate="2009-09-08"
								;$p(##class(web.DHCNurCom).GetSpecCollInfo(OrdRowId),"^",3)
								s RecTime="19:09:08"
								;=$p(##class(web.DHCNurCom).GetSpecCollInfo(OrdRowId),"^",4)
								
								*/
								//审核日期时间
								s AuthDate=$p(^TEPI(LabNo,1,TS,TSCnt),"\",4)
								i $l(AuthDate) s AuthDate=$zd(AuthDate,3)
								s AuthTime=$p(^TEPI(LabNo,1,TS,TSCnt),"\",5)
								i $l(AuthTime) s AuthTime=$zt(AuthTime*60,2)
								s LabNoInfo(LabNo)=AuthDate_"^"_AuthTime
								
								//是否有预报告
								i $p(^TEPI(LabNo,1,TS,TSCnt),"\",31)'="A",$d(^DHCPreReport(LabNo,TS,TSCnt)) s ReportFlag="Y"
								//危急提示
								s TransComm=##Class(web.DHCLabCommon).GetWarnComment(LabNo,TS,TSCnt)
							}
						} else{
							i AuthFlag="Y" s flag="Y"
						}
					} else {
						i AuthFlag="Y" s flag="Y"
					}	
				}	
				i flag="N"{			
					//标本OE_OrdSpecimen
					s SpecDr=$o(^OEORD(OrdId,"I",SubId,"SPEC",""),-1)
					s (SpecCode,SpecName)=""
					i $l(SpecDr) s SpecCode=$p(^OEORD(OrdId,"I",SubId,"SPEC",SpecDr),"^",1)
					i $l(SpecCode),$d(^TTAB("SPEC",SpecCode)){
						s SpecName=$p($g(^TTAB("SPEC",SpecCode)),"\",1)
					}
					/*采集日期时间Collection
					s (SpecDate,SpecTime)=""
					s OrdExecId=$o(^DHCOrdExec(0,"DHCOEORI",OrdRowId,""),-1)
					i $l(OrdExecId){
						s SpecDate=$p(^DHCOrdExec(OrdExecId),"^",13)
						i $l(SpecDate) s SpecDate=$zd(SpecDate,3)
						s SpecTime=$p(^DHCOrdExec(OrdExecId),"^",14)
						i $l(SpecTime) s SpecTime=$zt(SpecTime,2)
					}
					*/
					
					s SpecDate=$p(##class(web.DHCNurCom).GetSpecCollInfo(OrdRowId),"^",3)
					s SpecTime=$p(##class(web.DHCNurCom).GetSpecCollInfo(OrdRowId),"^",4)
					
					//b 400					
					;s RecDate=$p(##class(web.DHCENS.Util.Common).GetRuturnTime(OrdRowId,"R"),"^",1)
					;s RecTime=$p(##class(web.DHCENS.Util.Common).GetRuturnTime(OrdRowId,"R"),"^",2)
					s RecDate=""
					s RecTime=""		
					s ResultFlag=$p(^OEORD(OrdId,"I",SubId,1),"^",5)
					
	
					s ResultFlag=$$ALPHAUP^SSUTIL4(ResultFlag)
					s ResStatDR=$o(^OEC("RESST",0,"Code",ResultFlag,""),-1)
					i ResStatDR'="" d
					.s ResultFlagDesc=$p($g(^OEC("RESST",ResStatDR)),"^",2)
					e  d
					.s ResultFlagDesc=""
					
					s RESSUB=$o(^OEORD(OrdId,"I",SubId,"RES",""),-1)
					i RESSUB'="" d
					.s Note=$g(^OEORD(OrdId,"I",SubId,"RES",RESSUB,"TXT"))
					e  d
					.s Note=""
					i LabEpisode'="" {
						i $d(LabNoInfo(LabEpisode)) d
						.s ReportStus="Y"
						.s AuthDate=$p(LabNoInfo(LabEpisode),"^",1)
						.s AuthTime=$p(LabNoInfo(LabEpisode),"^",2)
					}else{
						s LabEpisode="No LabNo"
						s ReportStus="N",AuthDate="",AuthTime=""
					}
			        
					if ReportStus'="Y",ResultFlag'="RE" s ReportStus="N"
					if ItmStatusFlag="N" {
						set Data=$lb(OrdRowId,OrdName,ReqDate,ReqTime,ReportStus,LabEpisode,LabTestSetRow,SpecName,SpecDate,SpecTime,RecDate,RecTime,AuthDate,AuthTime,ReportFlag,TransComm,ResultFlagDesc,Note)
						s ^TMP($zn,$j,ReqDate,ReqTime,LabEpisode,OrdRowId)=Data
					}
				}
				//d OutputRow
			}
		}
	}
	q
	
OutputRow
	//set Data=$lb(OrdRowId,OrdName,ReqDate,ReqTime,ReportStus,LabEpisode,LabTestSetRow,SpecName,SpecDate,SpecTime,RecDate,RecTime,AuthDate,AuthTime,ReportFlag,TransComm)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryOrderListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrderListExecute ]
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

ClassMethod QueryOrderListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrderListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      huhm
/// CreatDate：    20090514
/// Description:： 根据就诊号或卡号(登记号)得到检验医嘱列表
/// Table：        OE_Order,OE_OrdItem,OE_OrdSpecimen
/// Input：        就诊号
/// Output：       医嘱ID,医嘱名称
///                OrdRowId,OrdName,
/// Return：         函数返回值的说明
/// Others：        其它说明
Query QueryOrderListLis(parr As %String) As %Query(ROWSPEC = "OEOrdItemID:%String,OrdItemName:%String,TSResultAnomaly:%String")
{
}

// d ##class(%ResultSet).RunQuery("web.DHCNURZSKOnPage","QueryOrderListLis","76##^^^^#2017-03-14#2017-03-29")

ClassMethod QueryOrderListLisExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1

    s EpisodeID=$p(parr,"#",1)
	s PatientID=$p(parr,"#",2)
	s Search=$p(parr,"#",3)
	s stdate=$p(parr,"#",4)
	s edate=$p(parr,"#",5)
	;b ;11
	s EpisodeID=$g(EpisodeID),PatientID=$g(PatientID)
	s SearchCriteria=$g(Search)
	s FromDate=$p(SearchCriteria,"^",1)
	i $l(FromDate) s FromDate=$zdh(FromDate,4)
	s ToDate=$p(SearchCriteria,"^",2)
	i $l(ToDate) S ToDate=$zdh(ToDate,4)
	//科室
	s LocCode=$p(SearchCriteria,"^",3)
	s LocId=""
	i $l(LocCode) s LocId=$o(^CTLOC(0,"Code",LocCode,""),-1)
	//是否审核
	s AuthFlag=$p(SearchCriteria,"^",4)
	//所有医嘱
	s AllTS=$p(SearchCriteria,"^",5)
	i '$l(AllTS) s AllTS="N"
	k ^TMP($zn,$j)
    s ^WANGLI("LIS",EpisodeID)=EpisodeID_","_PatientID_","_SearchCriteria
	i AuthFlag="N",$l(EpisodeID) d GetOrderByEpisode(EpisodeID)
	i AuthFlag="",$l(EpisodeID) d GetOrderByEpisode(EpisodeID)
	i AuthFlag="Y",$l(PatientID) d
	.s type="" f  s type=$o(^PAPERdr(PatientID,"ADM",type)) q:type=""  d
	..s ADMId="" f  s ADMId=$o(^PAPERdr(PatientID,"ADM",type,ADMId),-1) q:ADMId=""  d
	...s AdmLoc=$p(^PAADM(ADMId),"^",4)
	...i $l(LocCode),LocCode'=AdmLoc q
	...d GetOrderByEpisode(ADMId)
	s date="" f  s date=$o(^TMP($zn,$j,date),-1) q:date=""  d
	.s time="" f  s time=$o(^TMP($zn,$j,date,time),-1) q:time=""  d
	..s LabNo="" f  s LabNo=$o(^TMP($zn,$j,date,time,LabNo)) q:LabNo=""  d
	...s OrdId="" f  s OrdId=$o(^TMP($zn,$j,date,time,LabNo,OrdId)) q:OrdId=""  d
	....s Data=$g(^TMP($zn,$j,date,time,LabNo,OrdId))
	....d OutputRow
	Set qHandle=$lb(0,repid,0)
	k TMP($zn,$j)
	Quit $$$OK
	
GetOrderByEpisode(EpisodeNo)
	k LabNoInfo
	s TSResultAnomaly=""
	s OrdId=""
	f {
		s OrdId=$o(^OEORD(0,"Adm",EpisodeNo,OrdId))
		q:OrdId=""
		s SubId=""
		f {
			s SubId=$o(^OEORD(OrdId,"I",SubId),-1)
			q:SubId=""
			s OrdRowId=OrdId_"||"_SubId
			s OrdStr1=$g(^OEORD(OrdId,"I",SubId,1))
			s OrdStr3=$g(^OEORD(OrdId,"I",SubId,3))
			s ItmMastDr=$p(OrdStr1,"^",2)
			s ItmStatusDD=$p(OrdStr1,"^",13)
			
			s ItmStatusFlag="N"
			i ItmStatusDD="2" s ItmStatusFlag="Y" //add by wudan  2011-10-08
			i ItmStatusDD="4" s ItmStatusFlag="Y" //add by wudan  2011-10-08
			i ItmStatusDD="10" s ItmStatusFlag="Y" //add by wudan  2011-10-08
			
			i $l(ItmMastDr),##class(web.DHCNurknowInterface).isLabTS(ItmMastDr){
				s OrdName=""
				i $l(ItmMastDr),$d(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)){
					s OrdName=$p(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1),"^",2)
				}
				//申请日期时间
				s ReqTime=$p(OrdStr1,"^",17)
				i $l(ReqTime) s ReqTime=$zt(ReqTime,2)
				s ReqDate=$p(OrdStr3,"^",7)
				s Stdate="",Edate=""
				i stdate'="" s Stdate=$zdh(stdate,3)
				i edate'="" s Edate=$zdh(edate,3)
				q:(Stdate'="")&(ReqDate<Stdate)
				q:(Edate'="")&(ReqDate>Edate)
				//比较日期
				s flag="N"
				i $l(ReqDate){
					i $l(FromDate),ReqDate-FromDate<0 s flag="Y"
					i flag="N",$l(ToDate),ReqDate-ToDate>0 s flag="Y"
				}
				//比较科室
				i $l(ReqDate) s ReqDate=$zd(ReqDate,3)
				//检验号
				s LabEpisode=$p(OrdStr3,"^",20)
				//报告ID
				s LabTestSetRow=$p(OrdStr3,"^",35)
				s ReportStus="N"
				s (RecDate,RecTime,AuthDate,AuthTime,TransComm)=""
				s ReportFlag="N"  //预报告
			
				i flag="N"{
					i $l(LabTestSetRow){
						s LabNo=$p(LabTestSetRow,"||",1)
						s TS=$p(LabTestSetRow,"||",2)
						s TSCnt=$p(LabTestSetRow,"||",3)
					
						i $l(LabNo),$l(TS),$l(TSCnt),$d(^TEPI(LabNo,1,TS,TSCnt)){
						
							i $p(^TEPI(LabNo,1,TS,TSCnt),"\",31)="A" s ReportStus="Y"
							
							i AuthFlag="Y" {
								i ReportStus'="Y" s flag="Y"
							}
							i AuthFlag="N" {
								i ReportStus="Y" s flag="Y"
							}
							i flag="N"{
								//审核日期时间
								s AuthDate=$p(^TEPI(LabNo,1,TS,TSCnt),"\",4)
								i $l(AuthDate) s AuthDate=$zd(AuthDate,3)
								s AuthTime=$p(^TEPI(LabNo,1,TS,TSCnt),"\",5)
								i $l(AuthTime) s AuthTime=$zt(AuthTime*60,2)
								s LabNoInfo(LabNo)=AuthDate_"^"_AuthTime
								
								//是否有预报告
								i $p(^TEPI(LabNo,1,TS,TSCnt),"\",31)'="A",$d(^DHCPreReport(LabNo,TS,TSCnt)) s ReportFlag="Y"
								//危急提示
								s TransComm=##Class(web.DHCLabCommon).GetWarnComment(LabNo,TS,TSCnt)
								//结果异常标志
								s TSResultAnomaly=##class(web.DHCLabResultStatus).checkTSResultStatus(LabTestSetRow)

							}
						} else{
							i AuthFlag="Y" s flag="Y"
						}
					} else {
						i AuthFlag="Y" s flag="Y"
					}	
				}	
				i flag="N"{			
					//标本OE_OrdSpecimen
					s SpecDr=$o(^OEORD(OrdId,"I",SubId,"SPEC",""),-1)
					s (SpecCode,SpecName)=""
					i $l(SpecDr) s SpecCode=$p(^OEORD(OrdId,"I",SubId,"SPEC",SpecDr),"^",1)
					i $l(SpecCode),$d(^TTAB("SPEC",SpecCode)){
						s SpecName=$p(^TTAB("SPEC",SpecCode),"\",1)
					}
					
					s SpecDate=$p(##class(web.DHCNurCom).GetSpecCollInfo(OrdRowId),"^",3)
					s SpecTime=$p(##class(web.DHCNurCom).GetSpecCollInfo(OrdRowId),"^",4)
								
					;s RecDate=$p(##class(web.DHCENS.Util.Common).GetRuturnTime(OrdRowId,"R"),"^",1)
					;s RecTime=$p(##class(web.DHCENS.Util.Common).GetRuturnTime(OrdRowId,"R"),"^",2)
					s RecDate=""
					s RecTime=""
							
					s ResultFlag=$p(^OEORD(OrdId,"I",SubId,1),"^",5)
					
	
					s ResultFlag=$$ALPHAUP^SSUTIL4(ResultFlag)
					s ResStatDR=$o(^OEC("RESST",0,"Code",ResultFlag,""),-1)
					i ResStatDR'="" d
					.s ResultFlagDesc=$p($g(^OEC("RESST",ResStatDR)),"^",2)
					e  d
					.s ResultFlagDesc=""
					
					s RESSUB=$o(^OEORD(OrdId,"I",SubId,"RES",""),-1)
					i RESSUB'="" d
					.s Note=$g(^OEORD(OrdId,"I",SubId,"RES",RESSUB,"TXT"))
					e  d
					.s Note=""
					i LabEpisode'="" {
						i $d(LabNoInfo(LabEpisode)) d
						.s ReportStus="Y"
						.s AuthDate=$p(LabNoInfo(LabEpisode),"^",1)
						.s AuthTime=$p(LabNoInfo(LabEpisode),"^",2)
					}else{
						s LabEpisode="No LabNo"
						s ReportStus="N",AuthDate="",AuthTime=""
					}
			        
					if ReportStus'="Y",ResultFlag'="RE" s ReportStus="N"
					if (ItmStatusFlag="N")&(ReportStus="Y") {
						set Data=$lb(OrdRowId,OrdName,TSResultAnomaly)
						s ^TMP($zn,$j,ReqDate,ReqTime,LabEpisode,OrdRowId)=Data
					}
				}
			}
		}
	}
	q
	
OutputRow
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryOrderListLisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrderListLisExecute ]
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

ClassMethod QueryOrderListLisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrderListLisExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      huhm
/// CreatDate：    20090514
/// Description:： 根据就诊号或卡号(登记号)得到就诊诊断列表
/// Table：        MR_Diagnos
/// Input：        就诊号
/// OutPut:        诊断类型,诊断ICD描述,诊断注释,诊断状态,下诊断医生,下诊断日期,下诊断时间
/// d ##class(%ResultSet).RunQuery("web.DHCNURZSKOnPage","GetPatDiga","107101")
Query GetPatDiga(Adm As %String) As %Query(ROWSPEC = "DigaType,DigaICDDesc,DigaNoteDesc,DigaStatus,DigaDoc,DigaDate,DigaTime")
{
}

ClassMethod GetPatDigaExecute(ByRef qHandle As %Binary, Adm) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    i Adm="" Quit $$$OK
        
     f a2=1:1:$g(^MR(Adm,"DIA",0)) d
     .s icdr=$p($g(^MR(Adm,"DIA",a2)),"^",1)
     .s diatypeId=$o(^MR(Adm,"DIA",a2,"TYP",0))
     .q:diatypeId=""
     .s diatypedr=$p(^MR(Adm,"DIA",a2,"TYP",diatypeId),"^",1)
     .i $g(diatypedr)'="" s DigaType=$P($g(^MRC("DTYP",diatypedr)),"^",2)  ;诊断类型
     .e  s DigaType=""
     .s DocCtProve=$p($g(^MR(Adm,"DIA",a2)),"^",4)
     .s statusdr=$p($g(^MR(Adm,"DIA",a2)),"^",9)
     .i statusdr'="" s DigaStatus=$p(^MRC("DSTAT",statusdr),"^",2) ;状态
     .e  s DigaStatus=""
     .s DigaDoc=$p(^CTPCP(DocCtProve,1),"^",2)  ;医生
     .s DigaDate=$ZD($p($g(^MR(Adm,"DIA",a2)),"^",7),3) ;日期
     .s DigaTime=$ZT($p($g(^MR(Adm,"DIA",a2)),"^",8),2) ;时间
     .s DigaNoteDesc=""
     .f de=1:1:$g(^MR(Adm,"DIA",a2,"DES",0)) d
     ..s DigaNoteDesc=$g(DigaNoteDesc)_$g(^MR(Adm,"DIA",a2,"DES",de)) ;注释
     .i icdr'="" d
     ..s DigaICDDesc=$P($g(^MRC("ID",icdr)),"^",2)   ;ICD疾病描述
     ..d OutPutDiga
     .e  d 
     ..s DigaICDDesc=""
     ..d OutPutDiga
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutPutDiga
	set Data=$lb(DigaType,DigaICDDesc,DigaNoteDesc,DigaStatus,DigaDoc,DigaDate,DigaTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPatDigaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatDigaExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPatDigaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatDigaExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
