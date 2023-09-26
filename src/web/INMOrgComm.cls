/// Creator:dhh
/// Date:2020-05-23
/// Description:制度内容
Class web.INMOrgComm Extends %RegisteredObject
{

/// Creator:dhh
/// Description:保存制度维护父表数据
/// Date:2020-06-02
/// Table: DHCINM.OrgManage.OrgSystem
/// Input:
/// Output： 
/// Return: w ##class(web.INMOrgComm).SaveOrgSystem("SystemDesc|sdf^SystemPar|2^StartDate|2021-01-21^EndDate|^SystemStaus|Y^rw|")
ClassMethod SaveOrgSystem(parr, nurseid) As %String
{
	q:parr="" "入参为空"
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	i rw="" d
	.s obj=##class(DHCINM.OrgManage.OrgSystem).%New()
	.s SystemPar=$g(tmp("SystemPar")) 
	.s obj.SystemPar=SystemPar
	.s sort=1,fatherSort=""
	.i (SystemPar'="")&&(SystemPar'="0") d
	..s ParObj=##class(DHCINM.OrgManage.OrgSystem).%OpenId(SystemPar)
	..s:$IsObject(ParObj) fatherSort=ParObj.SystemSort
	.s sort=..GetSystemSort(SystemPar)
	.s:fatherSort'="" sort=fatherSort_"."_sort
	.s obj.SystemSort=sort
	.s obj.SystemStatus="Y"
	.s obj.Creator=nurseid
	e  d
	.s obj=##class(DHCINM.OrgManage.OrgSystem).%OpenId(rw)
	.s obj.SystemStatus="Y"
	s className="DHCINM.OrgManage.OrgSystem"
	s p="" f  s p=$O(^oddCOM("DHCINM.OrgManage.OrgSystem","a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="SystemSort"
	.q:p="SystemPar"
	.q:p="ContentExt"
	.s ptype=^oddCOM(className,"a",p,"P","XSDTYPE")
	.q:'$d(tmp(p))
	.s value=$zcvt($tr(tmp(p)," ",""),"U")
	.i ((ptype="date")&&(value'="")) d
	..s value=$zdh(value,3)
	.s $ZOBJPROPERTY(obj,p)=value
	s flag=$$$ISOK(obj.%Save())
	if flag {
		s his=##class(DHCINM.OrgManage.OrgHis).%New()
		d his.OrgDRSetObjectId(obj.%Id())
		s his.OrgType=1
		s his.Updator=nurseid
		s his.OrgDRDesc=obj.SystemDesc
		d his.%Save()
	}
	if flag{
		q 1	
	}else{
		q "保存失败"	
	}
}

/// Creator:
/// Createdate:
/// Description:保存数据时获取序号
/// Input:
/// Output:
/// Other:
ClassMethod GetSystemSort(par) As %String
{
	s sort=0
	s id="" f  s id=$O(^DHCINM.OrgManage.OrgSystemI("par"," "_par,id)) q:id=""  d
	.s obj=##class(DHCINM.OrgManage.OrgSystem).%OpenId(id)
	.q:'$IsObject(obj)
	.s brotherSort=obj.SystemSort
	.s brotherSort=$P(brotherSort,".",$l(brotherSort,"."))
	.i brotherSort>sort d
	..s sort=brotherSort
	s sort=sort+1
	q sort
}

/// Creator:dhh
/// Createdate:
/// Description:获取制度维护父表
/// Input:
/// Output:
/// Other:
ClassMethod GetSys(id) As %String
{
	s obj=##class(DHCINM.OrgManage.OrgSystem).%OpenId(id)
	s className="DHCINM.OrgManage.OrgSystem"
	s ret=""
	s ret="rw|"_id
	s p="" f  s p=$O(^oddCOM("DHCINM.OrgManage.OrgSystem","a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="SystemText"
	.q:p="ContentExt"
	.s ptype=^oddCOM(className,"a",p,"P","XSDTYPE")
	.s value=$ZOBJPROPERTY(obj,p)
	.i ((ptype="date")&&(value'="")) d
	..s value=##class(web.INMHISComm).DateLogicalToHtml(value)
	.s ret=ret_"^"_p_"|"_value
	q ret
}

/// Creator:
/// Createdate:
/// Description:获取制度维护父树形结构
/// Input:
/// Output:  d ##class(DHCINM.OrgManage.OrgSystem).%BuildIndices()
/// Other: w ##class(web.INMOrgComm).FindSystemTree("A","0")
ClassMethod FindSystemTree(par, dateFlag As %String = "0", appFlag As %String = "0", appRet As %ListOfDataTypes = "") As %ListOfDataTypes
{
	s:appRet="" appRet=##class(%ListOfDataTypes).%New()
	s nowDate=+$H
	s tmp=""
	s id="" f  s id=$O(^DHCINM.OrgManage.OrgSystemI("par"," "_par,id)) q:id=""  d
	.s objLB=$G(^DHCINM.OrgManage.OrgSystemD(id))
	.q:objLB=""
	.s sort=$LG(objLB,4)
	.s sort=$P(sort,".",$l(sort,"."))
	.s tmp(sort)=id
	w:appFlag'=1 "["
	s isFirst=1
	s retSort="" f  s retSort=$O(tmp(retSort)) q:retSort=""  d
	.s id=$g(tmp(retSort))
	.s objLB=$G(^DHCINM.OrgManage.OrgSystemD(id))
	.q:objLB=""
	.s sort=$LG(objLB,4)
	.s startDate=$LG(objLB,5)
	.s endDate=$LG(objLB,6)
	.s stopFlag=0
	.s:((startDate'="")&&(startDate>nowDate)) stopFlag=1
	.s:((endDate'="" )&&(endDate<=nowDate)) stopFlag=1
	.q:((dateFlag=1)&&(stopFlag=1))
	.s label=$LG(objLB,2)
	.w:(isFirst'=1)&&(appFlag'=1) ","
	.w:appFlag'=1 "{"_"""id"""_":"""_id_""",""label"":"""_label_""",""stopFlag"":"""_stopFlag_""""
	.s tRet=##class(%ArrayOfDataTypes).%New()
	.d tRet.SetAt(id,"id")
	.d tRet.SetAt(label,"label")
	.d tRet.SetAt(stopFlag,"stopFlag")
	.s childId=$O(^DHCINM.OrgManage.OrgSystemI("par"," "_id,""))
	.i childId'="" d
	..w:appFlag'=1 ",""children"":"
	..d tRet.SetAt(..FindSystemTree(id,dateFlag,appFlag),"children")
	.w:appFlag'=1 "}"
	.s isFirst=0
	.d appRet.Insert(tRet)
	w:appFlag'=1 "]"
	q:appFlag=1 appRet
	q ""
}

/// creator:dhh
/// createdate:20200619
/// description: 保存制度正文
/// table: DHCINM.OrgManage.WorkPoints
/// input:
/// output:
/// other: w ##class(web.INMOrgComm).SaveSysContent("1","")
ClassMethod SaveSysContent(parr As %String, contextExt As %String = "", nurseid As %String = "") As %String
{
	s ^TMP("SaveSysContent")=parr
	s id=$p(parr,"^","1")
	q:id="" "入参错误,请刷新界面"
	s obj=##class(DHCINM.OrgManage.OrgSystem).%OpenId(id)
	q:'$IsObject(obj) "未获取保存数据节点,请刷新重试"
	
	s status=$P(parr,"^","2")
	;q:obj.SystemStatus="N" "已发布不可进行保存或发布"
	TS
	s obj.SystemStatus=status
	i $CLASSNAME(contextExt)["CSP.CharacterStream" {
		d obj.ContentExt.CopyFromAndSave(contextExt)
	}else {
		d obj.ContentExt.Write(contextExt)
	}
	s sc=$$$ISOK(obj.%Save())
	i sc {
		s his=##class(DHCINM.OrgManage.OrgHis).%New()
		s his.OrgDR=obj
		s his.OrgType=2
		s his.Updator=nurseid
		s his.OrgDRDesc=obj.SystemDesc
		s sc=his.%Save()
	}
	if sc{
		TC
		q obj.%Id()	
	}else{
		TRO
		q "保存失败"	
	}
}

/// creator:dhh
/// createdate:20200619
/// description: 获取制度正文
/// table: DHCINM.OrgManage.OrgSystem
/// input:
/// output:
/// other: w ##class(web.INMOrgComm).GetSysContent("3")
ClassMethod GetSysContent(id As %String, appFlag As %String = 0) As %String
{
	q:id="" 0
	s ret=""
	s obj=##class(DHCINM.OrgManage.OrgSystem).%OpenId(id)
	q:'$IsObject(obj) 0
	s FileUrl=""
	s Status=obj.SystemStatus
	f i=1:1:obj.FileUrl.Count()  d
	.s tData=obj.FileUrl.GetAt(i)
	.q:tData=""
	.i FileUrl="" s FileUrl=tData
	.e  d
	..s FileUrl=FileUrl_","_tData
	i appFlag=1 {
		s str="Status|"_Status_"^FileUrl|"_FileUrl_"^ContentExt|"
		while ('obj.ContentExt.AtEnd){
			s str=str_obj.ContentExt.Read()
		}
		q str
		
	}
	w "{""Status"":"""_Status_""",""FileUrl"":"""_FileUrl_""",""ContentExt"":"""
	while ('obj.ContentExt.AtEnd){
		w $tr(obj.ContentExt.Read(),$c(10,13))
	}
	w """}"
	q ""
}

/// Creator:dhh
/// Createdate:2020-08-10
/// Description:保存制度文件
/// Input:
/// Output:
/// Other:
ClassMethod SaveOrgDataUrl(parr As %String) As %String
{
	
	s rw=$P(parr,"^",1)
	s url=$tr($p(parr,"^",2)," ","")
	s obj=##class(DHCINM.OrgManage.OrgSystem).%OpenId(rw)
	q:'$IsObject(obj) "0"
#;	f i=1:1:$L(url,",") d
#;	.s itm=$P(url,",",i)
#;	.q:itm=""
	d obj.FileUrl.Insert(url)
	s sc=obj.%Save()
	i $$$ISOK(sc){
		q 1	
	}else{
		q 0
	}
}

/// Creator:dhh
/// Createdate:2020-08-10
/// Description:删除制度文件
/// Input:
/// Output:
/// Other:
ClassMethod DeleteOrgDataUrl(parr As %String) As %String
{
	s id=$p(parr,"^")
	s url=$tr($p(parr,"^",2)," ","")
	s obj=##class(DHCINM.OrgManage.OrgSystem).%OpenId(id)
	q:'$IsObject(obj) "0"
	s newRefer=""
	d obj.FileUrl.RemoveAt(obj.FileUrl.Find(url))
	s sc=obj.%Save()
	i $$$ISOK(sc){
		q 1	
	}else{
		q 0
	}
}

/// creator:dhh
/// createdate:20200619
/// description: 删除制度
/// table: DHCINM.OrgManage.OrgSystem
/// input:
/// output:
/// other: w ##class(web.INMOrgComm).DeleteSys(4)
ClassMethod DeleteSys(id As %String, nurseid As %String) As %String
{
	q:id="" "入参为空"
	s obj=##class(DHCINM.OrgManage.OrgSystem).%OpenId(id)
	q:'$IsObject(obj) "未获取有效数据,请刷新重试"
	q:obj.SystemStatus="N" "已发布,不可删除"
	TS
	s ret=..IsAduitSub(id)
	if ret'=1{
		TRO
		q ret	
	}
	s sc =$$$ISOK(obj.%DeleteId(id))
	if sc {
		s his=##class(DHCINM.OrgManage.OrgHis).%New()
		;s his.OrgDR=obj
		s his.OrgType=3
		s his.Updator=nurseid
		s his.OrgDRDesc=obj.SystemDesc
		s sc=his.%Save()
	}
	if 'sc{
		TRO
		q "删除失败"	
	}else{
		TC
		q 1	
	}
}

ClassMethod IsAduitSub(id) As %String
{
	s ret=1
	s ParSub="" f  s ParSub=$O(^DHCINM.OrgManage.OrgSystemI("par"," "_id,ParSub)) q:((ParSub="")||(ret'=1))  d
	.s SubObj=##class(DHCINM.OrgManage.OrgSystem).%OpenId(ParSub)
	.s:SubObj.SystemStatus="N" ret="存在子节点已发布"
	.i ret=1 d
	..i $d(^DHCINM.OrgManage.OrgSystemI("par"," "_id))'=0 d
	...s ret=..IsAduitSub(ParSub)
	.q:ret'=1
	.s sc=$$$ISOK(SubObj.%DeleteId(ParSub))
	.s:'sc ret="删除子节点数据失败"	
	q ret
}

/// Creator:dhh
/// Description:保存护理文件父表数据
/// Date:2020-06-02
/// Table: DHCINM.OrgManage.OrgSysFile
/// Input:
/// Output： 
/// Return: w ##class(web.INMOrgComm).SaveFileFolder("SystemDesc|院级文件^SystemPar|0^StartDate|2020-07-15^EndDate|^rw|")
ClassMethod SaveFileFolder(parr) As %String
{
	q:parr="" "入参为空"
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	i rw="" d
	.s obj=##class(DHCINM.OrgManage.OrgSysFile).%New()
	.s FilePar=$g(tmp("FilePar")) 
	.s obj.FilePar=FilePar
	.s sort=1,fatherSort=""
	.i (FilePar'="")&&(FilePar'="0") d
	..s ParObj=##class(DHCINM.OrgManage.OrgSysFile).%OpenId(FilePar)
	..s:$IsObject(ParObj) fatherSort=ParObj.FileSort
	.s sort=..GetFileSort(FilePar)
	.s obj.LimiteType="A"
	.s LimiteType=$g(tmp("LimiteType"))
	.s Limits=$g(tmp("Limits"))
	.i LimiteType'="" d
	..s obj.LimiteType=LimiteType
	..s:(LimiteType'="A")&&(Limits'="") obj.Limits=Limits
	.s:fatherSort'="" sort=fatherSort_"."_sort
	.s obj.FileSort=sort
	e  d
	.s obj=##class(DHCINM.OrgManage.OrgSysFile).%OpenId(rw)
	s className="DHCINM.OrgManage.OrgSysFile"
	s p="" f  s p=$O(^oddCOM("DHCINM.OrgManage.OrgSysFile","a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="FileSort"
	.q:p="FilePar"
	.s ptype=^oddCOM(className,"a",p,"P","XSDTYPE")
	.q:'$d(tmp(p))
	.s value=$zcvt($tr(tmp(p)," ",""),"U")
	.i ((ptype="date")&&(value'="")) d
	..s value=$zdh(value,3)
	.s $ZOBJPROPERTY(obj,p)=value
	s flag=$$$ISOK(obj.%Save())
	if flag{
		q 1	
	}else{
		q "保存失败"	
	}
}

/// Creator:dhh
/// Createdate:
/// Description:获取护理文件维护父表
/// Input:
/// Output:
/// Other:
ClassMethod GetFile(id) As %String
{
	s obj=##class(DHCINM.OrgManage.OrgSysFile).%OpenId(id)
	s className="DHCINM.OrgManage.OrgSysFile"
	s ret=""
	s ret="rw|"_id
	s p="" f  s p=$O(^oddCOM("DHCINM.OrgManage.OrgSysFile","a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.s ptype=^oddCOM(className,"a",p,"P","XSDTYPE")
	.s value=$ZOBJPROPERTY(obj,p)
	.i ((ptype="date")&&(value'="")) d
	..s value=##class(web.INMHISComm).DateLogicalToHtml(value)
	.s ret=ret_"^"_p_"|"_value
	q ret
}

/// Creator:dhh
/// Createdate:
/// Description:保存上传护理文件信息
/// Input:
/// Output:
/// Other: w ##class(web.INMOrgComm).SaveOrgFileUrl("wallhaven-ymdejk^jpg^1.28MB^2020-08-31^^http://127.0.0.1:8080//Fileupdate/servlet/VueFileuploadServlet?filesname=images/OrgFileList/4^0","4")
ClassMethod SaveOrgFileUrl(parr As %String) As %String
{
	s gParam=""
    s nFlag=##class(web.INMVueComm).SplitStr(parr,"^","|",.gParam)
    s FileName=$g(gParam("FileName"))
    s FileSize=$g(gParam("FileSize"))
    s FileType=$g(gParam("FileType"))
    s StartDate=##class(web.INMHISComm).DateHtmlToLogical($g(gParam("StartDate")))
    s EndDate=##class(web.INMHISComm).DateHtmlToLogical($g(gParam("EndDate")))
    s FileUrl=$g(gParam("FileUrl"))
    s Creator=$g(gParam("Creator"))
    s pid=$g(gParam("pid"))
    q:FileUrl="" 0
    q:pid="" 0
    
    s obj=##class(DHCINM.OrgManage.OrgSysFileSub).%New()
    s obj.FileName=FileName
    s obj.FileType=FileType
    s obj.FileSize=FileSize
    s obj.StartDate=StartDate
    s obj.EndDate=EndDate
    s obj.Creator=Creator
    s obj.CreateDate=+$h
    d obj.FileUrl.Insert(FileUrl)
    s obj.Parref=##class(DHCINM.OrgManage.OrgSysFile).%OpenId(pid)
    
    s sortIdx=$o(^DHCINM.OrgManage.OrgSysFileSubI("Sort",pid,""),-1)
    s sortIdx=$e(sortIdx,2,*)
    s obj.SubSort=sortIdx+1

    s sc=obj.%Save()
    q:$$$ISERR(sc) 0
    q:$$$ISOK(sc) 1
}

/// Creator:dhh
/// Createdate:
/// Description:查询上传护理文件信息
/// Input:
/// Output: d ##class(%ResultSet).RunQuery("web.INMOrgComm","FindTableList","4","",0)
Query FindTableList(parr As %String = "", input As %String, nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindTableListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String, nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
    s ind=1,ret="",gRet="",gParam="",StartDate="",EndDate=""

    s nFlag=##class(web.INMVueComm).SplitStr(parr,"^","|",.gParam)
    s pid=$g(gParam("pid"))
    s Input=$g(gParam("Input"))
    
    s sort="" f  s sort=$o(^DHCINM.OrgManage.OrgSysFileSubI("Sort",pid,sort)) q:sort=""  d
    .s sortIdx=$e(sort,2,*)
    .q:sortIdx=""
    .s sid="" f  s sid=$o(^DHCINM.OrgManage.OrgSysFileSubI("Sort",pid,sort,sid)) q:sid=""  d
    ..s obj=##class(DHCINM.OrgManage.OrgSysFileSub).%OpenId(pid_"||"_sid)
    ..s FileName=obj.FileName
    ..q:((Input'="")&&($zcvt(FileName,"U")'[$zcvt(Input,"U")))
    ..s StDate=##class(web.INMHISComm).DateLogicalToHtmlNew(obj.StartDate)
    ..s EndDate=##class(web.INMHISComm).DateLogicalToHtmlNew(obj.EndDate)
    
    ..s gRet("FileName")=FileName
    ..s gRet("FileDate")=StDate_"至"_EndDate
    ..s gRet("FileSize")=obj.FileSize
    ..s gRet("FileUrl")=obj.FileUrl.GetAt(1)
    ..s gRet("FileType")=obj.FileType
    ..s gRet("rw")=pid_"||"_sid
    
    ..s ret=##class(web.INMPersonComm).PackageResp(.gRet)
    ..d OutFindTableList
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutFindTableList
    set Data=$lb(ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

/// creator:dhh
/// createdate:20200717
/// description: 删除上传护理文件记录
/// table: DHCINM.OrgManage.OrgSysFileSub
/// input:
/// output:
/// other: w ##class(web.INMOrgComm).DeleteOrgFileUrl("4||11")
ClassMethod DeleteOrgFileUrl(id As %String) As %String
{
	q:id="" 0
    s pid=$p(id,"||")
    s obj=##class(DHCINM.OrgManage.OrgSysFileSub).%OpenId(id)
    s currSort=obj.SubSort
    q:'$IsObject(obj) 0
    s sc =obj.%DeleteId(id)
    s mainSc=sc
    ;以下调整次序的部分好像也可以不用--20230322--ChenPeng
    s sort=" "_currSort f  s sort=$o(^DHCINM.OrgManage.OrgSysFileSubI("Sort",pid,sort)) q:sort=""  d
    .s sid="" f  s sid=$o(^DHCINM.OrgManage.OrgSysFileSubI("Sort",pid,sort,sid)) q:sid=""  d
    ..s tObj=##class(DHCINM.OrgManage.OrgSysFileSub).%OpenId(pid_"||"_sid)
    ..s tObj.SubSort=tObj.SubSort-1
    ..s sc=sc&&tObj.%Save()
    
    q $$$ISOK(mainSc)
}

/// Creator:
/// Createdate:
/// Description:保存护理文件数据时获取序号
/// Input:
/// Output:
/// Other:
ClassMethod GetFileSort(par) As %String
{
	s sort=0
	s id="" f  s id=$O(^DHCINM.OrgManage.OrgSysFileI("par"," "_par,id)) q:id=""  d
	.s obj=##class(DHCINM.OrgManage.OrgSysFile).%OpenId(id)
	.q:'$IsObject(obj)
	.s brotherSort=obj.FileSort
	.s brotherSort=$P(brotherSort,".",$l(brotherSort,"."))
	.i brotherSort>sort d
	..s sort=brotherSort
	s sort=sort+1
	q sort
}

/// Creator:
/// Createdate:
/// Description:获取护理文件维护父树形结构
/// Input:
/// Output: 
/// Other: w ##class(web.INMOrgComm).FindFileTree("0","0","8","2")
ClassMethod FindFileTree(par, dateFlag As %String = "0", role As %String, nurseid As %String, appFlag As %String = "0", appRet As %ListOfDataTypes = "") As %ListOfDataTypes
{
	s:appRet="" appRet=##class(%ListOfDataTypes).%New()
	s nowDate=+$H
	s tmp="",tmpWard="",isAll=0,roleFlag=0,wardFlag=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s id="" f  s id=$O(^DHCINM.OrgManage.OrgSysFileI("par"," "_par,id)) q:id=""  d
	.s objLB=$G(^DHCINM.OrgManage.OrgSysFileD(id))
	.q:objLB=""
	.s sort=$LG(objLB,4)
	.s sort=$P(sort,".",$l(sort,"."))
	.s tmp(sort)=id
	w:appFlag'=1 "["
	s isFirst=1
	s retSort="" f  s retSort=$O(tmp(retSort)) q:retSort=""  d
	.s id=$g(tmp(retSort))
	.s objLB=$G(^DHCINM.OrgManage.OrgSysFileD(id))
	.q:objLB=""
	.s sort=$LG(objLB,4)
	.s LimiteType=$LG(objLB,5)
	.s Limits=$LG(objLB,6)
	.s stopFlag=0,roleFlag=0,wardFlag=0
	.i (LimiteType="")||(LimiteType'="A") d
	..i LimiteType="L" d
	...;s roleid=..GetTopRoleByLoginId(nurseid)
	...s:(Limits="NURHEAD")&&(role>6) roleFlag=1
	...s:(Limits="ZNURHEAD")&&(role>5) roleFlag=1
	..i LimiteType="W" d
	...s:(isAll=0)&&((Limits="")||('$d(tmpWard(Limits)))) wardFlag=1
	.;q:((dateFlag=1)&&(stopFlag=1))
	.q:((wardFlag=1)||(roleFlag=1))
	.s label=$LG(objLB,2)
	.w:(isFirst'=1)&&(appFlag'=1) ","
	.w:appFlag'=1 "{"_"""id"""_":"""_id_""",""label"":"""_label_""",""stopFlag"":"""_stopFlag_""""
	.s tRet=##class(%ArrayOfDataTypes).%New()
	.d tRet.SetAt(id,"id")
	.d tRet.SetAt(label,"label")
	.d tRet.SetAt(stopFlag,"stopFlag")
	.s childId=$O(^DHCINM.OrgManage.OrgSysFileI("par"," "_id,""))
	.i childId'="" d
	..w:appFlag'=1 ",""children"":"
	..d tRet.SetAt(..FindFileTree(id,dateFlag,role,nurseid,appFlag),"children")
	.w:appFlag'=1 "}"
	.s isFirst=0
	.d appRet.Insert(tRet)
	w:appFlag'=1 "]"
	q:appFlag=1 appRet
	q ""
}

/// 获取最高角色/
/// 
ClassMethod GetTopRoleByLoginId(id)
{
	q:(id="") ""
	s loginName=""
	q:id=0 0
	s min=100
	s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(id)
	q:'$IsObject(perObj)
	s roleId="" f  s roleId=$O(^CF.DHCINM.DB.MgUserRoleI("Record"," "_id,roleId)) q:roleId=""  d
	.s isRoleFlag=0
	.s roleNurseId=""  f   s roleNurseId=$O(^CF.DHCINM.DB.MgUserRoleI("Record"," "_id,roleId,roleNurseId)) q:(roleNurseId="")||(isRoleFlag=1)  d
	..s roleNurseObj=##class(CF.DHCINM.DB.MgUserRole).%OpenId(roleId_"||"_roleNurseId)
	..q:'$IsObject(roleNurseObj)
	..q:(roleNurseObj.RoleStDate'="")&&(roleNurseObj.RoleStDate>+$H)
	..q:(roleNurseObj.RoleEndDate'="")&&(roleNurseObj.RoleEndDate<+$H)
	..s isRoleFlag=1
	.i isRoleFlag=1  d
	..i roleId<min  d
	...s min=roleId
	q min
}

/// creator:dhh
/// createdate:20200717
/// description: 删除护理文件夹
/// table: DHCINM.OrgManage.OrgSysFile
/// input:
/// output:
/// other: w ##class(web.INMOrgComm).DeleteSys("1")
ClassMethod DeleteSysFile(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCINM.OrgManage.OrgSysFile).%OpenId(id)
	q:'$IsObject(obj) 0
	s sc =obj.%DeleteId(id)
	s ret=1
	s ParSub="" f  s ParSub=$O(^DHCINM.OrgManage.OrgSysFileI("par"," "_id,ParSub)) q:ParSub=""  d
	.s SubObj=##class(DHCINM.OrgManage.OrgSysFile).%OpenId(ParSub)
	.s scSub=SubObj.%DeleteId(ParSub)
	.s:$$$ISERR(scSub) ret=0
	s:$$$ISERR(sc) ret=0
	q ret
}

/// creator:dhh
/// createdate:20200619
/// description: 保存工作计划
/// table:DHCINM.OrgManage.WorkPlanning
/// input:
/// output:
/// other: w ##class(web.INMOrgComm).SaveWorkPlanning("实施护士岗位管理^0")
ClassMethod SaveWorkPlanning(parr) As %String
{
	s WorkPlanning=$p(parr,"^",1)
	s WorkPerson=$p(parr,"^",2)
	s RowID=$p(parr,"^",3)
	i RowID'="" d
	.s obj=##class(DHCINM.OrgManage.WorkPlanning).%OpenId(RowID)
	e  s obj=##class(DHCINM.OrgManage.WorkPlanning).%New()
	s obj.WorkPlanning=WorkPlanning
	;s obj.WorkPerson=WorkPerson
	i WorkPerson'="" d
	.s obj.WorkPerson=##class(CF.DHCINM.DB.MgUser).%OpenId(WorkPerson)
	s obj.WorkDate=$p($h,",",1)
	s obj.WorkTime=$p($h,",",2)
	s obj.WorkStatus="Y"
	s obj.WorkText=""
	s sc=obj.%Save()
	;d $System.Status.DisplayError(sc)
	q $$$ISOK(sc)
}

/// creator:dhh
/// createdate:20200619
/// description: 获取工作规划信息
/// table:DHCINM.OrgManage.WorkPlanning
/// input:
/// output:
/// other: w ##class(web.INMOrgComm).GetWorkPlanning(1)
ClassMethod GetWorkPlanning(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCINM.OrgManage.WorkPlanning).%OpenId(id)
	s ret="rw|"_id
	i obj.WorkPlanning'="" d
	.s ret=ret_"^WorkPlanning|"_obj.WorkPlanning
	.s:obj.WorkPerson="" ret=ret_"^WorkPerson|管理员"
	.s:obj.WorkPerson'="" ret=ret_"^WorkPerson|"_obj.WorkPerson.UserName
	i obj.WorkDate'="" d
	.s ret=ret_"^WorkDate|"_$zd(obj.WorkDate,3)
	i obj.WorkTime'="" d
	.s ret=ret_"^WorkTime|"_$zt(obj.WorkTime,1)
	i obj.WorkStatus'="" d
	.s ret=ret_"^WorkStatus|"_$case(obj.WorkStatus,"Y":"已保存","N":"已发布",:"")
	;s ret=ret_"^WorkText|"_obj.WorkText
	q ret
}

/// creator:dhh
/// createdate:20200619
/// description: 删除工作规划信息
/// table:DHCINM.OrgManage.WorkPlanning
/// input:
/// output:
/// other: w ##class(web.INMOrgComm).DeleteWorkPlanning(1)
ClassMethod DeleteWorkPlanning(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCINM.OrgManage.WorkPlanning).%OpenId(id)
	q:'$IsObject(obj) 0
	s sc =obj.%DeleteId(id)
	s ret=1
	s:$$$ISERR(sc) ret=0
	q ret
}

/// creator:dhh
/// createdate:20200619
/// description: 获取工作规划记录
/// table:DHCINM.OrgManage.WorkPlanning
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.INMOrgComm","FindWorkPlanningList","")
Query FindWorkPlanningList(input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWorkPlanningListExecute(ByRef qHandle As %Binary, input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tmpWard=""
	s id="" f  s id=$O(^DHCINM.OrgManage.WorkPlanningD(id)) q:id=""  d
	.s obj=##class(DHCINM.OrgManage.WorkPlanning).%OpenId(id)
	.q:'$IsObject(obj)
	.s info=obj.WorkPlanning
	.q:((input'="")&&(info'="")&&($zcvt(info,"U")'[$zcvt(input,"U")))
	.s ret=..GetWorkPlanning(id)
	.d OutWorkPlanning
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWorkPlanning
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWorkPlanningListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWorkPlanningListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWorkPlanningListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWorkPlanningListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// creator:dhh
/// createdate:20200619
/// description: 保存工作规划正文
/// table:DHCINM.OrgManage.WorkPlanning
/// input:
/// output:
/// other: w ##class(web.INMOrgComm).SaveWorkPlanningContent("1","")
ClassMethod SaveWorkPlanningContent(parr As %String, contextExt As %String = "") As %String
{
	s id=$p(parr,"^")
	q:id="" 0
	s obj=##class(DHCINM.OrgManage.WorkPlanning).%OpenId(id)
	q:'$IsObject(obj) 0
	i $CLASSNAME(contextExt)["CSP.CharacterStream" {
		d obj.ContentExt.CopyFromAndSave(contextExt)
	}
	else {
		d obj.ContentExt.Write(contextExt)
	}
	s obj.WorkDate=$p($h,",",1)
	s obj.WorkTime=$p($h,",",2)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// creator:dhh
/// createdate:20200619
/// description: 获取工作规划正文
/// table:DHCINM.OrgManage.WorkPlanning
/// input:
/// output:
/// other: w ##class(web.INMOrgComm).GetWorkPlanningContent("1")
ClassMethod GetWorkPlanningContent(id As %String) As %String
{
	q:id="" 0
	s myValue=""
	s obj=##class(DHCINM.OrgManage.WorkPlanning).%OpenId(id)
	q:'$IsObject(obj) 0
	while ('obj.ContentExt.AtEnd){
		w $tr(obj.ContentExt.Read(),$c(10,13))
	}
	q ""
}

/// creator:dhh
/// createdate:20200619
/// description: 发布工作规划正文
/// table:DHCINM.OrgManage.WorkPlanning
/// input:
/// output:
/// other: w ##class(web.INMOrgComm).SubmitWorkPlanningContent("1")
ClassMethod SubmitWorkPlanningContent(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCINM.OrgManage.WorkPlanning).%OpenId(id)
	q:'$IsObject(obj) 0
	if (obj.WorkStatus'="N"){
		s obj.WorkStatus="N"
		s sc=obj.%Save()
		q $$$ISOK(sc)
	} 
	if (obj.WorkStatus="N"){
		q 2
	}
}

/// creator:dhh
/// createdate:20200619
/// description: 保存工作计划
/// table: DHCINM.OrgManage.WorkPlan
/// input:
/// output:
/// other: w ##class(web.INMOrgComm).SaveWorkPlan("年^0^^2020-01-01^年度")
ClassMethod SaveWorkPlan(parr As %String) As %String
{
	s WorkPlan=$p(parr,"^",1)
	s WorkPerson=$p(parr,"^",2)
	s RowID=$p(parr,"^",3)
	s WorkYear=$p(parr,"^",4)
	s WorkType=$p(parr,"^",5)
	i RowID'="" d
	.s obj=##class(DHCINM.OrgManage.WorkPlan).%OpenId(RowID)
	e  s obj=##class(DHCINM.OrgManage.WorkPlan).%New()
	s obj.WorkPlan=WorkPlan
	;s obj.WorkPerson=WorkPerson
	i WorkPerson'="" d
	.s obj.WorkPerson=##class(CF.DHCINM.DB.MgUser).%OpenId(WorkPerson)
	s obj.WorkDate=$p($h,",",1)
	s obj.WorkYear=$zdh(WorkYear,3)

	s obj.WorkType=WorkType
	s obj.WorkStatus="Y"
	s obj.WorkText=""
	s sc=obj.%Save()
	;d $System.Status.DisplayError(sc)
	q $$$ISOK(sc)
}

/// creator:dhh
/// createdate:20200619
/// description: 获取工作规划记录
/// table:DHCINM.OrgManage.WorkPlanning
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.INMOrgComm","FindWorkPlanList","2021-01-01","年度","")
Query FindWorkPlanList(year As %String = "", type As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWorkPlanListExecute(ByRef qHandle As %Binary, year As %String = "", type As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s years=$zdh(year,3)
	s workYear="" f  s workYear=$O(^DHCINM.OrgManage.WorkPlanI("YearType",workYear)) q:workYear=""  d
	.q:(years'="")&&(workYear'=years)
	.s workType="" f  s workType=$O(^DHCINM.OrgManage.WorkPlanI("YearType",workYear,workType)) q:workType=""  d
	..q:(type'="")&&(workType'=(" "_type))
	..s id="" f  s id=$O(^DHCINM.OrgManage.WorkPlanI("YearType",workYear,workType,id)) q:id=""  d
	...s info=$lg(^DHCINM.OrgManage.WorkPlanD(id),2)
	...q:((input'="")&&(info'="")&&($zcvt(info,"U")'[$zcvt(input,"U")))
	...s ret=..GetWorkPlan(id)
	...d OutWorkPlan
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWorkPlan
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWorkPlanListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWorkPlanListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWorkPlanListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWorkPlanListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// creator:dhh
/// createdate:20200619
/// description: 获取工作计划信息
/// table:DHCINM.OrgManage.WorkPlanning
/// input:
/// output:
/// other: w ##class(web.INMOrgComm).GetWorkPlan(1)
ClassMethod GetWorkPlan(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCINM.OrgManage.WorkPlan).%OpenId(id)
	s ret="rw|"_id
	i obj.WorkPlan'="" d
	.s ret=ret_"^WorkPlan|"_obj.WorkPlan
	.s:obj.WorkPerson="" ret=ret_"^WorkPerson|管理员"
	.s:obj.WorkPerson'="" ret=ret_"^WorkPerson|"_obj.WorkPerson.UserName
	i obj.WorkDate'="" d
	.s ret=ret_"^WorkDate|"_$zd(obj.WorkDate,3)
	i obj.WorkYear'="" d
	.s ret=ret_"^WorkYear|"_+$zd(obj.WorkYear,3)
	i obj.WorkStatus'="" d
	.s ret=ret_"^WorkStatus|"_$case(obj.WorkStatus,"Y":"已保存","N":"已发布",:"")
	i obj.WorkType'="" d
	.s ret=ret_"^WorkType|"_obj.WorkType
	s ret=ret_"^WorkText|"_obj.WorkText
	q ret
}

/// creator:dhh
/// createdate:20200619
/// description: 删除工作计划
/// table:DHCINM.OrgManage.WorkPlan
/// input:
/// output:
/// other: w ##class(web.INMOrgComm).DeleteWorkPlan(1)
ClassMethod DeleteWorkPlan(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCINM.OrgManage.WorkPlan).%OpenId(id)
	q:'$IsObject(obj) 0
	s sc =obj.%DeleteId(id)
	s ret=1
	s:$$$ISERR(sc) ret=0
	q ret
}

/// creator:dhh
/// createdate:20200619
/// description: 保存工作规划正文
/// table:DHCINM.OrgManage.WorkPlanning
/// input:
/// output:
/// other: w ##class(web.INMOrgComm).SaveWorkPlanContent("1","")
ClassMethod SaveWorkPlanContent(parr As %String, contextExt As %String = "") As %String
{
	s id=$p(parr,"^")
	s Status=$P(parr,"^",2)
	q:id="" "入参错误,请刷新界面重试!"
	s obj=##class(DHCINM.OrgManage.WorkPlan).%OpenId(id)
	q:'$IsObject(obj) "未获取数据对象,请刷新重试!"
	q:((Status="N")&&(obj.WorkStatus="N")) "已发布,不可重复发布"
	i $CLASSNAME(contextExt)["CSP.CharacterStream" {
		d obj.ContentExt.CopyFromAndSave(contextExt)
	}
	else {
		d obj.ContentExt.Write(contextExt)
	}
	s obj.WorkDate=$p($h,",",1)
	s obj.WorkStatus=Status
	s sc=$$$ISOK(obj.%Save())
	if sc{
		q 1	
	}else{
		q "保存失败"	
	}
}

/// creator:dhh
/// createdate:20200619
/// description: 获取工作规划正文
/// table:DHCINM.OrgManage.WorkPlanning
/// input:
/// output:
/// other: w ##class(web.INMOrgComm).GetWorkPlanContent("1")
ClassMethod GetWorkPlanContent(id As %String) As %String
{
	q:id="" 0
	s myValue=""
	s obj=##class(DHCINM.OrgManage.WorkPlan).%OpenId(id)
	q:'$IsObject(obj) 0
	while ('obj.ContentExt.AtEnd){
		w $tr(obj.ContentExt.Read(),$c(10,13))
	}
	q ""
}

/// creator:dhh
/// createdate:20200619
/// description: 保存工作重点
/// table: DHCINM.OrgManage.WorkPoints
/// input:
/// output:
/// other: w ##class(web.INMOrgComm).SaveWorkPoints("年^0^^2020-01-01^年度")
ClassMethod SaveWorkPoints(parr As %String) As %String
{
	s WorkPoint=$p(parr,"^",1)
	s WorkPerson=$p(parr,"^",2)
	s RowID=$p(parr,"^",3)
	s WorkYear=$p(parr,"^",4)
	s WorkType=$p(parr,"^",5)
	i RowID'="" d
	.s obj=##class(DHCINM.OrgManage.WorkPoints).%OpenId(RowID)
	e  s obj=##class(DHCINM.OrgManage.WorkPoints).%New()
	s obj.WorkPoint=WorkPoint
	;s obj.WorkPerson=WorkPerson
	i WorkPerson'="" d
	.s obj.WorkPerson=##class(CF.DHCINM.DB.MgUser).%OpenId(WorkPerson)
	s obj.WorkDate=$p($h,",",1)
	s obj.WorkYear=$zdh(WorkYear,3)
	s obj.WorkType=WorkType
	s obj.WorkStatus="Y"
	s obj.WorkText=""
	s sc=obj.%Save()
	;d $System.Status.DisplayError(sc)
	q $$$ISOK(sc)
}

/// creator:dhh
/// createdate:20200619
/// description: 获取工作规划记录
/// table: DHCINM.OrgManage.WorkPoints
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.INMOrgComm","FindWorkPointsList","2021-01-01","年度","")
Query FindWorkPointsList(year As %String = "", type As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWorkPointsListExecute(ByRef qHandle As %Binary, year As %String = "", type As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s years=$zdh(year,3)
	s workYear="" f  s workYear=$O(^DHCINM.OrgManage.WorkPointsI("YearType",workYear)) q:workYear=""  d
	.q:(years'="")&&(workYear'=years)
	.s workType="" f  s workType=$O(^DHCINM.OrgManage.WorkPointsI("YearType",workYear,workType)) q:workType=""  d
	..q:(type'="")&&(workType'=(" "_type))
	..s id="" f  s id=$O(^DHCINM.OrgManage.WorkPointsI("YearType",workYear,workType,id)) q:id=""  d
	...s info=$lg(^DHCINM.OrgManage.WorkPointsD(id),2)
	...q:((input'="")&&(info'="")&&($zcvt(info,"U")'[$zcvt(input,"U")))
	...s ret=..GetWorkPoints(id)
	...d OutWorkPoints
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWorkPoints
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWorkPointsListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWorkPointsListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWorkPointsListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWorkPointsListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// creator:dhh
/// createdate:20200619
/// description: 获取工作计划信息
/// table: DHCINM.OrgManage.WorkPoints
/// input:
/// output:
/// other: w ##class(web.INMOrgComm).GetWorkPoints(1)
ClassMethod GetWorkPoints(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCINM.OrgManage.WorkPoints).%OpenId(id)
	s ret="rw|"_id
	i obj.WorkPoint'="" d
	.s ret=ret_"^WorkPoint|"_obj.WorkPoint
	.s:obj.WorkPerson="" ret=ret_"^WorkPerson|管理员"
	.s:obj.WorkPerson'="" ret=ret_"^WorkPerson|"_obj.WorkPerson.UserName
	i obj.WorkDate'="" d
	.s ret=ret_"^WorkDate|"_$zd(obj.WorkDate,3)
	i obj.WorkYear'="" d
	.s ret=ret_"^WorkYear|"_+$zd(obj.WorkYear,3)
	i obj.WorkStatus'="" d
	.s ret=ret_"^WorkStatus|"_$case(obj.WorkStatus,"Y":"已保存","N":"已发布",:"")
	i obj.WorkType'="" d
	.s ret=ret_"^WorkType|"_obj.WorkType
	s ret=ret_"^WorkText|"_obj.WorkText
	q ret
}

/// creator:dhh
/// createdate:20200619
/// description: 删除工作计划
/// table: DHCINM.OrgManage.WorkPoints
/// input:
/// output:
/// other: w ##class(web.INMOrgComm).DeleteWorkPoints(1)
ClassMethod DeleteWorkPoints(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCINM.OrgManage.WorkPoints).%OpenId(id)
	q:'$IsObject(obj) 0
	s sc =obj.%DeleteId(id)
	s ret=1
	s:$$$ISERR(sc) ret=0
	q ret
}

/// creator:dhh
/// createdate:20200619
/// description: 保存工作规划正文
/// table: DHCINM.OrgManage.WorkPoints
/// input:
/// output:
/// other: w ##class(web.INMOrgComm).SaveWorkPointsContent("1","")
ClassMethod SaveWorkPointsContent(parr As %String, contextExt As %String = "") As %String
{
	s id=$p(parr,"^")
	s Status=$P(parr,"^",2)
	q:id="" "入参错误,请刷新界面重试!"
	s obj=##class(DHCINM.OrgManage.WorkPoints).%OpenId(id)
	q:'$IsObject(obj) "未获取数据对象,请刷新重试!"
	q:((Status="N")&&(obj.WorkStatus="N")) "已发布,不可重复发布"
	i $CLASSNAME(contextExt)["CSP.CharacterStream" {
		d obj.ContentExt.CopyFromAndSave(contextExt)
	}
	else {
		d obj.ContentExt.Write(contextExt)
	}
	s obj.WorkDate=$p($h,",",1)
	s obj.WorkStatus=Status
	s sc=$$$ISOK(obj.%Save())
	if sc{
		q 1	
	}else{
		q "保存失败"	
	}
}

/// creator:dhh
/// createdate:20200619
/// description: 获取工作规划正文
/// table: DHCINM.OrgManage.WorkPoints
/// input:
/// output:
/// other: w ##class(web.INMOrgComm).GetWorkPointsContent("1")
ClassMethod GetWorkPointsContent(id As %String) As %String
{
	q:id="" 0
	s myValue=""
	s obj=##class(DHCINM.OrgManage.WorkPoints).%OpenId(id)
	q:'$IsObject(obj) 0
	while ('obj.ContentExt.AtEnd){
		w $tr(obj.ContentExt.Read(),$c(10,13))
	}
	q ""
}

/// creator:dhh
/// createdate:20200619
/// description: 根据年份，类型获取工作计划
/// table:DHCINM.OrgManage.WorkPlan
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.INMOrgComm","FindWorkPlanListByType","2020-01-01","年度")
Query FindWorkPlanListByType(year As %String = "", type As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWorkPlanListByTypeExecute(ByRef qHandle As %Binary, year As %String = "", type As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s years=$zdh(year,3)
	s workType="" f  s workType=$O(^DHCINM.OrgManage.WorkPlanI("YearType",years,workType)) q:workType=""  d
	.q:(type'="")&&(workType'=(" "_type))
	.s id="" f  s id=$O(^DHCINM.OrgManage.WorkPlanI("YearType",years,workType,id)) q:id=""  d
	..s obj=##class(DHCINM.OrgManage.WorkPlan).%OpenId(id)
	..s ret="rw|"_id
	..i obj.WorkPlan'="" d
	...s ret=ret_"^WorkPlan|"_obj.WorkPlan
	...d OutWorkPlanType
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWorkPlanType
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWorkPlanListByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWorkPlanListByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWorkPlanListByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWorkPlanListByTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// creator:dhh
/// createdate:20200619
/// description: 带入工作计划
/// table: DHCINM.OrgManage.WorkPoints
/// input:
/// output:
/// other: w ##class(web.INMOrgComm).SaveImportPoint("1")
ClassMethod SaveImportPoint(parr As %String) As %String
{
	q:parr="" 0
	s obj=##class(DHCINM.OrgManage.WorkPlan).%OpenId(parr)
	q:'$IsObject(obj) 0
	s pointobj=##class(DHCINM.OrgManage.WorkPoints).%New()
	s pointobj.WorkPoint=obj.WorkPlan
	s pointobj.WorkPerson=obj.WorkPerson
	s pointobj.WorkDate=obj.WorkDate
	s pointobj.WorkType=obj.WorkType
	s pointobj.WorkStatus=obj.WorkStatus
	s pointobj.WorkYear=obj.WorkYear
	s pointobj.WorkText=obj.WorkText
	s pointobj.ContentExt=obj.ContentExt
	s sc=pointobj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取APP制度维护父树形结构
/// Date: 2022-02-08
/// Creator: wangpf
/// Table: DHCINM.OrgManage.OrgSystem
/// Input: 人员id nurseid
/// Output: APP制度维护父树形结构
/// Other: d ##class(web.INMOrgComm).FindSystemTree2(0,0,"科室")
ClassMethod FindSystemTree2(par As %String = "", dateFlag As %String = "0", input As %String = "0", appRet As %ListOfDataTypes = "") As %ListOfDataTypes
{
	s:appRet="" appRet=##class(%ListOfDataTypes).%New()
	s nowDate=+$H
	
	k tmp
	s id="" f  s id=$O(^DHCINM.OrgManage.OrgSystemI("par"," "_par,id)) q:id=""  d
	.s objLB=$G(^DHCINM.OrgManage.OrgSystemD(id))
	.q:objLB=""
	.s sort=$LG(objLB,4)
	.s sort=$P(sort,".",$l(sort,"."))
	.s tmp(sort)=id
	
	s retSort="" f  s retSort=$O(tmp(retSort)) q:retSort=""  d
	.s id=tmp(retSort)
	.s objLB=$G(^DHCINM.OrgManage.OrgSystemD(id))
	.q:objLB=""
	.s startDate=$LG(objLB,5)
	.s endDate=$LG(objLB,6)
	.s stopFlag=0
	.s:((startDate'="")&&(startDate>nowDate)) stopFlag=1
	.s:((endDate'="" )&&(endDate<=nowDate)) stopFlag=1
	.q:((dateFlag=1)&&(stopFlag=1))
	.s sort=$LG(objLB,4)
	.s level=$l(sort,".")
	.i level=3 s type="F"
	.e  s type="D"
	.s label=$LG(objLB,2)
	.i (input="")||((input'="")&&(label[input)) d
	..s tRet=##class(%ArrayOfDataTypes).%New()
	..d tRet.SetAt(id,"id")
	..d tRet.SetAt(label,"label")
	..d tRet.SetAt(stopFlag,"stopFlag")
	..d tRet.SetAt(type,"type")
	..i type="F" d appRet.Insert(tRet)
	..e  d
	...s flag=0,lastKey="",key="" f  s item=appRet.GetNext(.key) q:(key="")||(flag'=0)  d
	....s tType=item.GetAt("type")
	....i tType="F" s flag=1
	....e  s lastKey=key
	...s key=+lastKey+1
	...s:key<1 key=appRet.Count()+1
	...d appRet.InsertAt(tRet,key)
	.q:input=""
	.d ..FindSystemTree2(id,dateFlag,input,.appRet)
	q appRet
}

/// Description: 获取APP文件维护父树形结构
/// Date: 2022-02-08
/// Creator: wangpf
/// Table: DHCINM.OrgManage.OrgSystem
/// Input: 人员id nurseid
/// Output: APP文件维护父树形结构
/// Other: d ##class(web.INMOrgComm).FindFileTree2(0,0,"",0)
ClassMethod FindFileTree2(par As %String = "", dateFlag As %String = "0", input As %String = "", nurseid As %String = "", appRet As %ListOfDataTypes = "") As %ListOfDataTypes
{
	s:appRet="" appRet=##class(%ListOfDataTypes).%New()
	s nowDate=+$H
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	i nurseid=0 s topRoleLevel=0
	e  d
	.s topRoleId=+##class(web.INMLoginComm).GetTopRoleByLoginId(nurseid)
	.i topRoleId=0 s topRoleLevel=9999
	.e  s topRoleLevel=$lg(^CT.DHCINM.Set.MgRolesD(topRoleId),6)
	
	k tmp
	s id="" f  s id=$O(^DHCINM.OrgManage.OrgSysFileI("par"," "_par,id)) q:id=""  d
	.s objLB=$G(^DHCINM.OrgManage.OrgSysFileD(id))
	.q:objLB=""
	.s sort=$LG(objLB,4)
	.s sort=$P(sort,".",$l(sort,"."))
	.s tmp(sort)=id
	
	s retSort="" f  s retSort=$O(tmp(retSort)) q:retSort=""  d
	.s id=tmp(retSort)
	.s objLB=$G(^DHCINM.OrgManage.OrgSysFileD(id))
	.q:objLB=""
	.s LimiteType=$LG(objLB,5)
	.s Limits=$LG(objLB,6)
	.s flag=0
	.i (LimiteType="")||(LimiteType'="A") d
	..i LimiteType="L" d
	...s:(Limits="NURHEAD")&&(topRoleLevel>4) flag=1
	...s:(Limits="ZNURHEAD")&&(topRoleLevel>3) flag=1
	..e  i LimiteType="W" d
	...s:(isAll=0)&&((Limits="")||('$d(tmpWard(Limits)))) flag=1
	.q:flag'=0
	.s label=$LG(objLB,2)
	.i (input="")||((input'="")&&(label[input)) d
	..s tRet=##class(%ArrayOfDataTypes).%New()
	..d tRet.SetAt(id,"id")
	..d tRet.SetAt(label,"label")
	..d tRet.SetAt("D","type")
	..d tRet.SetAt("","ext")
	..d tRet.SetAt("","url")
	..d tRet.SetAt("","createDate")
	..s flag=0,lastKey="",key="" f  s item=appRet.GetNext(.key) q:(key="")||(flag'=0)  d
	...s tType=item.GetAt("type")
	...i tType="F" s flag=1
	...e  s lastKey=key
	..s key=+lastKey+1
	..s:key<1 key=appRet.Count()+1
	..d appRet.InsertAt(tRet,key)
	.q:input=""
	.d ..FindFileTree2(id,dateFlag,input,nurseid,.appRet)
	
	i par'="" d
	.s parLevel=$l($lg($g(^DHCINM.OrgManage.OrgSysFileD(par)),4),".")
	.i parLevel=2 d
	..s subId="" f  s subId=$o(^DHCINM.OrgManage.OrgSysFileSubI("parr",par,subId)) q:subId=""  d
	...s subGlo=^DHCINM.OrgManage.OrgSysFileD(par,"ChildSub",subId)
	...q:subGlo=""
	...s startDate=$LG(subGlo,3)
	...s endDate=$LG(subGlo,4)
	...s stopFlag=0
	...s:(startDate="")||(startDate>nowDate) stopFlag=1
	...s:(endDate'="" )&&(endDate<nowDate) stopFlag=1
	...q:(dateFlag=1)&&(stopFlag=1)
	...s subLabel=$lg(subGlo,2)
	...s subType=$lg(subGlo,9)
	...s subDesc=subLabel_$case(subType,"":"",:"."_subType)
	...q:(input'="")&&(subDesc'[input)
	...s subUrl=$lg($lg(subGlo,6),1)
	...s subDate=$lg(subGlo,8)
	...s:subDate'="" subDate=$zd(startDate,3)
	...s tRet=##class(%ArrayOfDataTypes).%New()
	...d tRet.SetAt(par_"||"_subId,"id")
	...d tRet.SetAt(subLabel,"label")
	...d tRet.SetAt("F","type")
	...d tRet.SetAt(subType,"ext")
	...d tRet.SetAt(subUrl,"url")
	...d tRet.SetAt(subDate,"createDate")
	...d appRet.Insert(tRet)
	q appRet
}

/// Output: d ##class(%ResultSet).RunQuery("web.INMOrgComm","FindOrgLogList","4","",0)
Query FindOrgLogList(parr As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindOrgLogListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s type=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	s id="" f  s id=$O(^DHCINM.OrgManage.OrgHisD(id)) q:id=""  d	
	.s obj=##class(DHCINM.OrgManage.OrgHis).%OpenId(id)
	.q:'$IsObject(obj)
	.s updateDate=obj.UpdateDate
	.q:((stDate'="")&&(stDate>updateDate))||((endDate'="")&&(endDate<updateDate))
	.s:updateDate'="" updateDate=$zd(updateDate,3)
	.s updateTime=obj.UpdateTime
	.s:updateTime'="" updateTime=$zt(updateTime)
	.s desc=obj.OrgDRDesc
	.q:(type'="")&&(type'=obj.OrgType)
	.s typeDesc=$case(obj.OrgType,1:"新增",2:"修改",3:"删除",:"")
	.s updator=obj.Updator
	.s updatorName=""
	.i updator=0 s updatorName="管理员"
	.e  i updator'="" s updatorName=$lg($g(^CF.DHCINM.DB.MgUserD(updator)),2)
	.s ret="OrgDRDesc|"_desc_"^OrgTypeDesc|"_typeDesc_"^Updator|"_updator
	.s ret=ret_"^UpdatorName|"_updatorName_"^UpdateDate|"_updateDate_"^UpdateTime|"_updateTime
	.d OutList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator: ChenPeng
/// Createdate: 2023-03-23
/// Description: 移动护理文件的次序
/// Input: {rowId: "2||6", type: "up"}
/// Output: {-1:排序失败,0:到头了无法排序,1:排序成功}
/// Debug: w ##class(web.INMOrgComm).SetCodeSubSort("rowId|2||6^type|U")
ClassMethod SetSysFileSubSort(parr As %String) As %String
{
    s gParam=""
    s nFlag=##class(web.INMVueComm).SplitStr(parr,"^","|",.gParam)
    s rowId=$g(gParam("rowId"))
    s type=$g(gParam("type"))
    q:rowId="" -1
    q:type="" -1
    s pid=$p(rowId,"||")
    s order=$case(type,"U":-1,"D":1,:-1)
    s currObj=##class(DHCINM.OrgManage.OrgSysFileSub).%OpenId(rowId)
    q:'$IsObject(currObj) -1
    s currSort=currObj.SubSort
    s maxSort=$O(^DHCINM.OrgManage.OrgSysFileSubI("Sort",pid,""),-1)
    s maxSort=$e(maxSort,2,*)
    s minSort=$O(^DHCINM.OrgManage.OrgSysFileSubI("Sort",pid,""))
    s minSort=$e(minSort,2,*)
    s nextSort=currSort+order
    ; 如果当前文件的序号等于上下限，那么说明到头了，不能排序了
    q:(nextSort<minSort)||(nextSort>maxSort) 0
    s nextSid=$O(^DHCINM.OrgManage.OrgSysFileSubI("Sort",pid," "_nextSort,""))
    q:nextSid="" -1
    s nextObj=##class(DHCINM.OrgManage.OrgSysFileSub).%OpenId(pid_"||"_nextSid)
    q:'$IsObject(nextObj) -1
    
    s currObj.SubSort=nextSort
    s nextObj.SubSort=currSort
    ts
    s sc=currObj.%Save()
    s sc=sc&&nextObj.%Save()
    tro:$$$ISERR(sc)
    tc:$$$ISOK(sc)
    
    q:$$$ISOK(sc) 1
    q:$$$ISERR(sc) -1
}

/// Creator: ChenPeng
/// Createdate: 2023-03-23
/// Description: 初始化护理文件的排序数据，仅用于没有排序数据时候初始化
/// Input: NULL
/// Output: NULL
/// Debug: d ##class(web.INMOrgComm).InitSysFileSubSort()
ClassMethod InitSysFileSubSort() As %String
{
    s pid="" f  s pid=$o(^DHCINM.OrgManage.OrgSysFileSubI("parr",pid)) q:pid=""  d
    .s idx=0
    .s sid="" f  s sid=$o(^DHCINM.OrgManage.OrgSysFileSubI("parr",pid,sid)) q:sid=""  d
    ..s idx=idx+1
    ..s obj=##class(DHCINM.OrgManage.OrgSysFileSub).%OpenId(pid_"||"_sid)
    ..s obj.SubSort=idx
    ..s sc=obj.%Save()
}

}
