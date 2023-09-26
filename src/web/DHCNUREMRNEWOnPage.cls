Class web.DHCNUREMRNEWOnPage Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s episodeID = $Get(%request.Data("EpisodeID",1),"")
	q:(episodeID="") $$$OK
	
	s patientID = $Get(%request.Data("PatientID",1),"")
	//q:(patientID="") $$$OK
	
	s parentID = $Get(%request.Data("node",1),"-1")
	s ^okkkkk(parentID)=""
	s workGroupID = $g(%session.Data("LOGON.GROUPID")) 	//当前登录医生的安全组
	s userID = %session.Get("LOGON.USERID")				//当前登录用户ID
	s userLoc = %session.Get("LOGON.CTLOCID")			//当前登录用户科室
	
	d ..GetJason(parentID, episodeID, userID, userLoc, workGroupID)
	
	Quit $$$OK
}

ClassMethod GetJason(parentID, episodeID, userID, userLoc, workGroupID)
{
	s ^CaheTempDHCEPRDebug("actionappointchapter","input") = parentID_"^"_episodeID_"^"_userID_"^"_userLoc_"^"_workGroupID
	s type = $E(parentID,1,2)
	s id = $E(parentID,3,$l(parentID))
	s ^objcyf5(parentID,type)=parentID
	w "["
	if type = "RT"
	{	
	  d ..GetCategoryJason(episodeID, userID, userLoc, workGroupID)
	}
	elseif type = "CG"
	{	
	  d ..GetCateChapterJason(id,episodeID, userID, userLoc, workGroupID)
	}
	
	w "]"
}

//w ##class(web.DHCNUREMRNEWOnPage).GetCategoryJason("50","69","27","132")

ClassMethod GetCategoryJason(episodeID, userID, userLoc, workGroupID)
{
	//s parentId = "RT0"
	//s parentType = $e(parentId,1,2)
	//s parentId = $e(parentId, 3, $l(parentId))	
	//s parentId = " "_parentId
	
	//s isTplPrivActive = ##class(EPRservice.DocRestLogic.PrivLogic).CheckTPrivActivity()
	//s curPatInfo = ##class(EPRservice.DocRestLogic.PrivLogic).GetPatInfo(episodeID)
	s ^tmpgname=episodeID_"^"_userID_"&"_userLoc_"&"_workGroupID
	//遍历根节点的第一层目录(Category类型)
	s parentId = " 0"
	s curCategoryId = ""
	i '$d(^User.DHCNURMenuI("LocIndex"," "_userLoc)) s userLoc=""
		k depsort
		s mseq=""  f  s mseq=$O(^User.DHCNURMenuI("Locsort"," "_userLoc,mseq)) q:(mseq="")  d
	    .s subchl=""  f  s subchl=$O(^User.DHCNURMenuI("Locsort"," "_userLoc,mseq,subchl)) q:(subchl="")  d
        ..s seqsub=$tr(mseq," ","")
        ..q:seqsub=""
        ..s depsort(seqsub)=subchl
	s count = 0
	s ch=""
	for {
		s ch=$O(depsort(ch)) 
	    q:ch=""
	    s curCategoryId=depsort(ch)
		//s curCategoryId =$O(^User.DHCNURMenuI("LocIndex"," "_userLoc,curCategoryId))  //$o(^User.DHCNURMenuD(curCategoryId))
		b ;
		q:(curCategoryId="") 
		s a=##class(User.DHCNURMenu).%OpenId(curCategoryId)
		s desc =a.name
		s code=a.code
		s link=a.Link
		s ifon=a.ifon 
		i ifon'="Y" continue
		s gid=curCategoryId
		i link'="" s gid=link
		s qflag=""
		i '$d(^User.DHCNURMenuSubI("LocGidCode"," "_userLoc)) d //没有按科室保存过子目录
		.i '$d(^User.DHCNURMenuSubI("LocGidCode"," "," "_gid)) d
		..b ;44
		..s qflag=1  //continue  //如果根目录下没有子项则不显示
		i $d(^User.DHCNURMenuSubI("LocGidCode"," "_userLoc))  d
		.b ;
		.i '$d(^User.DHCNURMenuSubI("LocGidCode"," "_userLoc," "_gid)) d
		..s qflag="1" //continue  //如果根目录下没有子项则不显示
		i qflag'="" continue
		s count = count + 1
		if count>1 w ","
		w "{"
		w "id:'CG"_gid_"'"
		w ",text:'"_desc_"'"
		w ",cls:'folder'"
		//w ",checked:false"
		w "}"
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

ClassMethod GetCateChapterJason(parentId, episodeID, userID, userLoc, workGroupID)
{
	
	//s parentType = $e(parentId,1,2)
	//s parentId = $e(parentId, 3, $l(parentId))
	
	    s id = parentId
		//遍历第二层节点(CategoryChapter)
		//s ^objcyf13(id)=id
		s DepModelStr=..GetDepModel(userLoc)
		s AllStr=..GetDepModel("All") ///全院都显示的模板
		s DepModelStr=$zconvert(DepModelStr,"U")
		s count = 0
		k depcodesort
		i '$d(^User.DHCNURMenuSubI("LocSeq"," "_userLoc)) s userLoc=""  //如果某病区没维护 默认取全院的
		s mseq=""  f  s mseq=$O(^User.DHCNURMenuSubI("LocSeq"," "_userLoc," "_id,mseq)) q:(mseq="")  d
	    .s subchl=""  f  s subchl=$O(^User.DHCNURMenuSubI("LocSeq"," "_userLoc," "_id,mseq,id,subchl)) q:(subchl="")  d
        ..//s seqsub=""
        ..//s a=##class(User.DHCNURMenuSub).%OpenId(id_"||"_chl)
        ..s seqsub=$tr(mseq," ","")
        ..q:seqsub=""
        ..s depcodesort(seqsub)=id_"||"_subchl
        s ch = ""
		for {
		    s ch=$O(depcodesort(ch)) 
	        q:ch=""
	        s rowid=depcodesort(ch)
 	        s a=##class(User.DHCNURMenuSub).%OpenId(rowid)
			s code=a.Code
			s name=a.Name
			s code22=$ZConvert(code,"U")
			s flag=..GetModelDataStatus(episodeID,code)
			//i (DepModelStr'[code22)&(flag=0) continue
			//s ifret=..ifexist(DepModelStr,code22)
			//s allret=..ifexist(AllStr,code22)
			//i (ifret="")&(flag=0)&&(allret="") continue
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

//d ##class(web.DHCNUREMRNEWOnPage).GetInCode("DHCNURLIST_DDZC")

ClassMethod GetInCode(RecTyp) As %String
{
   s ret="" 
   s RecTyp=$zconvert(RecTyp,"U")
   s id="" f  s id=$O(^User.DHCNURListLinkI("CodeIndex"," "_RecTyp,id)) q:id=""  d
 	.s a=##class(User.DHCNURListLink).%OpenId(id)
 	.s ret=a.InCode
  q ret
}

ClassMethod GetModelDataStatus(EpisodeID, EmrCode) As %String
{
	//w ##class(web.DHCMGNurData2).GetModelDataStatus("158","DHCNURXH22")
	s ret=0
	//s ^objcyfds(EpisodeID,EmrCode)=""
	if (EpisodeID'="")&&(EmrCode'="")
	{
	 s code=$ZConvert(EmrCode,"U")
	 s EmrCode=$ZConvert(EmrCode,"U")
	 s inflag=..GetInCode(code)
	 i inflag'="" s code=inflag
	 if (EmrCode="DHCNURANHUI22GRID") s EmrCode="DHCNURANHUI22"
	 s id=""
	 s DHCMoudid=""  f  s DHCMoudid=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeID,DHCMoudid)) q:DHCMoudid=""  d
	 .i DHCMoudid'="" d
	 ..s b=##class(Nur.DHCMoudData).%OpenId(DHCMoudid)
	 ..s EmrDate=b.EmrDate
	 ..s EmrDate=$zd(EmrDate,3)
	 ..b ;3
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
	 ..b 
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
	 b ;44
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
	  if (EmrCode="DHCNURCOPYDIAGNOS")
	 {
	     s id=$O(^Nur.DHCNurCopyDiagnosI("EpisodeId"," "_EpisodeID,""))	
	    i id'=""  d
	    .s a=##class(Nur.DHCNurCopyDiagnos).%OpenId(id) 
	    .s id=$zd(a.RecDate,3)	 
     }
	 b ;88
	}
	i id'="" s ret=id
	q ret
}

ClassMethod GetModelDataStatus2(EpisodeID, EmrCode) As %String
{
	//w ##class(web.DHCMGNurData2).GetModelDataStatus("158","DHCNURXH22")
	s ret=0
	//s ^objcyfds(EpisodeID,EmrCode)=""
	if (EpisodeID'="")&&(EmrCode'="")
	{
	 s code=$ZConvert(EmrCode,"U")
	 s EmrCode=$ZConvert(EmrCode,"U")
	 s inflag=..GetInCode(code)
	 i inflag'="" s code=inflag
	 if (EmrCode="DHCNURANHUI22GRID") s EmrCode="DHCNURANHUI22"
	 s id=""
	 s DHCMoudid=""  f  s DHCMoudid=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeID,DHCMoudid)) q:DHCMoudid=""  d
	 .i DHCMoudid'="" d
	 ..s b=##class(Nur.DHCMoudData).%OpenId(DHCMoudid)
	 ..s EmrDate=b.EmrDate
	 ..s EmrDate=$zd(EmrDate,3)
	 ..b ;3
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
	 ..b 
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
	 b ;44
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
	  if (EmrCode="DHCNURCOPYDIAGNOS")
	 {
	    s id=$O(^Nur.DHCNurCopyDiagnosI("EpisodeId"," "_EpisodeID,""))	
	    i id'=""  d
	    .s a=##class(Nur.DHCNurCopyDiagnos).%OpenId(id) 
	    .s id=$zd(a.RecDate,3)
     }
	 b ;88
	}
	i id'="" d
	.s ret=$zdh(id,3)
	.i ret<+$h s ret="0"
	q ret
}

}
