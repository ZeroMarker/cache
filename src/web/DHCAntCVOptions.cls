Class web.DHCAntCVOptions Extends %RegisteredObject
{

ClassMethod SaveBaseOpt(Code = "", Value = "", Note = "")
{
	q:(Code="") "-1^键值不能为空"
	q ..Save("Base",Code,Value,Note)
}

ClassMethod SaveBaseOptByRequest()
{
	s $zt="Err"
	m temp=%request.Data
	set TId="",rtn=0
	for {
		set TId=$o(temp(TId))
		q:TId=""
		s Type=$p(TId,"||",1)
		s Code=$p(TId,"||",2)
		continue:Type'="Base"
		d ..SaveBaseOpt(Code,$g(temp(TId,1)))
	}
	q 1
Err
	q "-1^"_$ze
}

ClassMethod GetBaseOpt(Code = "")
{
	q ..GetValue("Base",Code)
}

ClassMethod SetBaseOpt(Code = "", Value = "")
{
	q:(Code="") "-1^键值不能为空"
	q ..Save("Base",Code,Value,"keep")
}

/// d ##class(web.DHCAntCVOptions).InitCVType()
ClassMethod InitCVType()
{
	w "插入检验："_..SaveCVType(1,"检验","检验"),!
	w "插入病理："_..SaveCVType(2,"病理","病理"),!
	w "插入心电："_..SaveCVType(3,"心电","心电"),!
	w "插入超声："_..SaveCVType(4,"超声","超声"),!
	w "插入内镜："_..SaveCVType(5,"内镜","内镜"),!
	w "插入放射："_..SaveCVType(6,"放射","放射"),!
}

/// d ##class(web.DHCAntCVOptions).InitBase()
ClassMethod InitBase()
{
	
	//w "病历填写链接："_..SaveBaseOpt("EmrEditLink","emr.record.interface.csp?EpisodeID={EpisodeID}&UserCode={UserCode}&UserID={UserID}&GroupID={GroupID}&CTLocID={CTLocID}&DocID=66&FromType=CRITICAL&FromCode={AntCVID}"),!
	w "病历填写链接："_..SaveBaseOpt("EmrEditLinkI","emr.interface.ip.main.csp?EpisodeID={EpisodeID}&DocID=66&InstanceID={InstanceID}&FromType=CRITICAL&FromCode={AntCVID}"),!
	
	w "病历浏览链接："_..SaveBaseOpt("EmrViewLink","emr.browse.csp?EpisodeID={EpisodeID}&InstanceID={InstanceID}"),!
	w "显示写病历按钮："_..SaveBaseOpt("ShowEditEmrI",1),!

	
	w "下医嘱链接："_..SaveBaseOpt("OrderEditLink","oeorder.oplistcustom.new.csp?PatientID={PatientID}&EpisodeID={EpisodeID}&mradm={mradm}&AntCVID={AntCVID}"),!
	w "草药医嘱链接："_..SaveBaseOpt("CYOrderEditLink","opdoc.oeorder.cmlistcustom.csp?PatientID={PatientID}&EpisodeID={EpisodeID}&mradm={mradm}&AntCVID={AntCVID}"),!
	w "显示下医嘱按钮"_..SaveBaseOpt("ShowEditOrderO",1),!
	w "显示下医嘱按钮"_..SaveBaseOpt("ShowEditOrderEO",1),!
	w "显示下医嘱按钮"_..SaveBaseOpt("ShowEditOrderEI",1),!
	w "显示下医嘱按钮"_..SaveBaseOpt("ShowEditOrderI",1),!

	
	w "显示处理意见"_..SaveBaseOpt("ShowTransAdvice",1),!
}

ClassMethod SaveCVType(Code = "", Desc = "", Note = "")
{
	q:(Code="") "-1^类型代码不能为空"
	q:(Desc="") "-1^类型描述不能为空"
	q ..Save("CVType",Code,Desc,Note)
}

ClassMethod DeleteCVType(Code = "")
{
	q:(Code="") "-1^类型代码不能为空"
	if $d(^DHCAntCVReport(Code)) q "-1^此类型在危急值报告表存在引用，无法删除"
	q ..Delete("CVType",Code)
}

ClassMethod GetCVTypeDesc(Code = "")
{
	q ..GetValue("CVType",Code)
}

ClassMethod Save(Type = "", Code = "", Value = "", Note = "", Seq = "")
{
	q:(Type="") "-1^类型不能为空"
	q:(Code="") "-1^Code不能为空"
	
	if $d(^User.DHCAntCVOptionsD(Type,Code)){
		s obj=##class(User.DHCAntCVOptions).%OpenId(Type_"||"_Code)
	}else{
		s obj=##class(User.DHCAntCVOptions).%New()
	}
	if $IsObject(obj){
		s obj.CVOptType=Type
		s obj.CVOptCode=Code
		s obj.CVOptValue=Value
		s obj.CVOptSeq=Seq
		i Note'="keep" s obj.CVOptNote=Note  //Note 如果传keep则不修改
		set sc = obj.%Save()
		if $$$ISERR(sc){
			Quit "-1^保存失败"_$system.Status.GetErrorText(sc)
		}
		Set Id = obj.%Id()
		do obj.%Close()
		Set obj = ""
		q Id
	}else{
		q "-1^未知错误"	
	}
}

ClassMethod Delete(Type = "", Code = "")
{
	q:(Type="") "-1^类型不能为空"
	q:(Code="") "-1^Code不能为空"
	
	if $d(^User.DHCAntCVOptionsD(Type,Code)){
		set sc = ##class(User.DHCAntCVOptions).%DeleteId(Type_"||"_Code)
		if $$$ISERR(sc){
			Quit "-1^"_$system.Status.GetErrorText(sc)
		}
		q 1
	}
	q "-1^不存在"
}

ClassMethod GetValue(Type = "", Code = "")
{
	q:(Type="") ""
	q:(Code="") ""
	s info=$g(^User.DHCAntCVOptionsD(Type,Code))
	q $lg(info,2)
}

/// ext查询界面的json数组
/// tkMakeServerCall(web.DHCAntCVOptions,GetExtJsonArray)
ClassMethod GetExtJsonArray()
{
	set rtn="["
	set TCode=""
	for {
		Set TCode=$o(^User.DHCAntCVOptionsD("CVType",TCode))
		Quit:TCode=""
		set TDesc=$lg(^User.DHCAntCVOptionsD("CVType",TCode),2)
		if rtn="[" set rtn=rtn_"['"_TCode_"','"_TDesc_"']"
		else  set rtn=rtn_",['"_TCode_"','"_TDesc_"']"
	}
	set rtn=rtn_"]"
	q rtn
}

/// d ##class(%ResultSet).RunQuery("web.DHCAntCVOptions","Find","CVType")
Query Find(OptsType = "", q = "") As websys.Query(CONTAINID = 1, ROWSPEC = "TId:%String,TType:%String,TCode:%String,TDesc:%String,TNote:%String,TSeq")
{
}

ClassMethod FindExecute(ByRef QHandle As %Library.Binary, OptsType = "", q = "") As %Library.Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	set TType=""
	for {
		Set TType=$o(^User.DHCAntCVOptionsD(TType))
		Quit:TType=""
		continue:TType'=OptsType
		set TCode=""
		for {
			s TCode=$o(^User.DHCAntCVOptionsD(TType,TCode))
			q:TCode=""
			set g=^User.DHCAntCVOptionsD(TType,TCode)
			
			set TDesc=$lg(g,2)
			continue:(q'="")&&($zcvt(TDesc,"U")'[$zcvt(q,"U"))&&($zcvt(TCode,"U")'[$zcvt(q,"U"))
			set TNote=$lg(g,3)
			set TId=TType_"||"_TCode
			set TSeq=$lg(g,4)
			
			s seqKey=TSeq
			if seqKey="" s seqKey="zzz999"
			s sortArr(seqKey,TCode)=$lb(TId,TType,TCode,TDesc,TNote,TSeq)
			
			
		}
	}
	
	s seqKey=""
	for {
		s seqKey=$o(sortArr(seqKey))
		q:seqKey=""
		s TCode=""
		for {
			s TCode=$o(sortArr(seqKey,TCode))
			q:TCode=""
				
			Set ^CacheTemp(repid,ind)=sortArr(seqKey,TCode)
			set ind=ind+1
		}	
	}
	
	
	Set QHandle=$lb(0,repid,0) 
	Quit $$$OK
}

ClassMethod SaveDICType(Code = "", Desc = "", Note = "")
{
	q:(Code="") "-1^字典代码不能为空"
	q:(Desc="") "-1^字典描述不能为空"
	q ..Save("DICType",Code,Desc,Note)
}

ClassMethod DeleteDICType(Code = "", DeleteData = 0)
{
	q:(Code="") "-1^类型代码不能为空"
	if $d(^User.DHCAntCVOptionsD(Code)) q "-1^此字典存在数据，无法删除"
	q ..Delete("DICType",Code)
}

/// d ##class(web.DHCAntCVOptions).InitDic()
ClassMethod InitDic()
{
	w "接收时联系结果字典："_..SaveDICType("ConResultRec","接收时联系结果字典","接收时联系结果字典"),!
	w "已通知："_..Save("ConResultRec","F","已通知","","a01"),!
	w "已通知："_..Save("ConResultRec","C","未联系到","","a11"),!
	
	w "处理时联系结果字典："_..SaveDICType("ConResultExec","处理时联系结果字典","处理时联系结果字典"),!
	w "已通知："_..Save("ConResultExec","F","已通知","","a01"),!
	w "未联系到："_..Save("ConResultExec","C","未联系到","","a11"),!	
	w "无需处理："_..Save("ConResultExec","NoNeedExec","无需处理","","b11"),!
}

}
