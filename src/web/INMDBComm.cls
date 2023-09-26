/// Creator:
/// Descriptions:基础数据业务类
/// Date:
Class web.INMDBComm Extends %RegisteredObject
{

/// Creator:
/// Createdate:
/// Description:根据公共代码主表code、子表code获取值
/// Input:
/// Output:
/// Other:
ClassMethod GetCodeDescByCode(type, code) As %String
{
	q:(type="")!(code="") ""
	s par=$O(^CT.DHCINM.DB.MgSetCodeI("Code"," "_$zcvt($tr(type," ",""),"U"),""))
	q:par="" ""
	s id=$O(^CT.DHCINM.DB.MgSetCodeSubI("Code",par," "_$zcvt($tr(code," ",""),"U"),""))
	s obj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(par_"||"_id)
	s desc=""
	s:$IsObject(obj) desc=obj.SubDesc
	q desc
}

/// Creator:lulin
/// Description:根据id获取公共代码
/// Date:2020-12-07
/// Table:
/// Input:
/// Output：
/// Return:
ClassMethod GetCommCode(id As %String) As %String
{
	q:id="" ""
	q:id'["||" ""
	s Desc=""
	s obj=$G(^CT.DHCINM.DB.MgSetCodeSubD($P(id,"||",1),$P(id,"||",2)))
	s Desc=$LG(obj,3)
	q Desc
}

/// Creator:
/// Createdate:
/// Description:树形结构展现表格数据形式输出
/// Input:ref:临时数组名称，不可为tmp，index：默认"",jsonFlag：是否输出json格式，isWriteFlag:默认0
/// Output:
/// Other:
ClassMethod ShowTreeData(ref As %String = "", index As %String = "", jsonFlag, isWriteFlag) As %String
{
	i isWriteFlag d
	.i jsonFlag=1 d
	..w ##class(web.INMVueComm).StrToJson(@ref)
	.e  d
	..w @ref
	f  s index=$O(@ref@(index)) q:index=""  d
	.w:((isWriteFlag=1)&&(jsonFlag=1)) ","
	.s isWriteFlag=0
	.s:$g(@ref@(index))'="" isWriteFlag=1
	.d ..ShowTreeData($name(@ref@(index)),"",jsonFlag,isWriteFlag)
}

/// Creator:lulin
/// Createdate:2020-07-12
/// Description:根据答题方式、类型获取题目数量【任务发布获取数量】
/// Input:类型、应急预案、单选/多选，题型
/// Output:
/// Other:w ##class(web.INMDBComm).GetSpareNum("S","53||1","N","54||1")
ClassMethod GetSpareNum(SubMode, SubTypeDR, TheoryMode, TheoryTypeDR) As %String
{
	s num=0,nowDate=+$H
	s id="" f  s id=$O(^CF.DHCINM.DB.TeaTheoryI("type",TheoryTypeDR,id)) q:id=""  d
	.s objLB=$G(^CF.DHCINM.DB.TeaTheoryD(id))
	.q:objLB=""
	.s tTheoryMode=$LG(objLB,8)
	.s StartDate=$LG(objLB,5)
	.s EndDate=$LG(objLB,6)
	.q:((StartDate'="")&&(StartDate>nowDate))
	.q:((EndDate'="")&&(EndDate<nowDate))
	.q:(TheoryMode'=tTheoryMode)
	.s num=..GetSpareSubNum(SubMode, SubTypeDR,id)
	q num
}

/// Creator:lulin
/// Createdate:2020-07-12
/// Description:上个方法得回调函数
/// Input:
/// Output:
/// Other:
ClassMethod GetSpareSubNum(SubMode, SubTypeDR, parId) As %String
{
	s num=0,nowDate=+$H
	i $O(^CF.DHCINM.DB.TeaTheoryI("par"," "_parId,""))=""  d
	.s subId="" f  s subId=$O(^CF.DHCINM.DB.TeaTheorySubD(parId,subId)) q:subId=""  d
	..s subObjLB=$G(^CF.DHCINM.DB.TeaTheorySubD(parId,subId))
	..q:subObjLB=""
	..s tSubMode=$LG(subObjLB,4)
	..s tSubTypeDR=$LG(subObjLB,5)
	..s SubStatus=$LG(subObjLB,12)
	..q:SubStatus'="Y"
	..q:(SubMode'=tSubMode)
	..q:(tSubTypeDR'=SubTypeDR)
	..s num=num+1
	e  d
	.s id="" f  s id=$O(^CF.DHCINM.DB.TeaTheoryI("par"," "_parId,id)) q:id=""  d
	..s objLB=$G(^CF.DHCINM.DB.TeaTheoryD(id))
	..q:objLB=""
	..s tTheoryMode=$LG(objLB,8)
	..s StartDate=$LG(objLB,5)
	..s EndDate=$LG(objLB,6)
	..q:((StartDate'="")&&(StartDate>nowDate))
	..q:((EndDate'="")&&(EndDate<nowDate))
	..s num=num+..GetSpareSubNum(SubMode, SubTypeDR,id)
	q num
}

/// Creator:lulin
/// Createdate:2020-07-12
/// Description:根据答题方式、类型获取题目数量【任务发布获取数量】新
/// Input:类型、ParID、id
/// Output:
/// Other:w ##class(web.INMDBComm).GetSpareNum("S","2")
ClassMethod GetSpareNumNew(SubMode, ParID) As %String
{
	s num=0,nowDate=+$H
	s subId="" f  s subId=$O(^CF.DHCINM.DB.TeaTheorySubD(ParID,subId)) q:subId=""  d
	.s subObjLB=$G(^CF.DHCINM.DB.TeaTheorySubD(ParID,subId))
	.q:subObjLB=""
	.s tSubMode=$LG(subObjLB,4)
	.s tSubTypeDR=$LG(subObjLB,5)
	.s SubStatus=$LG(subObjLB,12)
	.q:SubStatus'="Y"
	.q:(SubMode'=tSubMode)
	.s num=num+1
	q num
}

/// Creator:lulin
/// Createdate:2020-06-18
/// Description:根据id获取理论题的作答次数和正确率
/// Input:
/// Output:
/// Other:w ##class(web.INMDBComm).GetTeachTheorySubNum("3||1")
ClassMethod GetTeachTheorySubNum(rw) As %String
{
	s answerNum=0,correctNum=0
	s answer=$LG($g(^CF.DHCINM.DB.TeaTheorySubD($P(rw,"||",1),$P(rw,"||",2))),7)
	//练习
	s testId="" f  s testId=$O(^DHCINM.Tea.LearnTheoryTestI("Theory",rw,testId)) q:testId=""  d
	.s testObjLB=$G(^DHCINM.Tea.LearnTheoryTestD(testId))
	.q:testObjLB=""
	.s answerNum=answerNum+1
	.s CorrectFlag=$lg(testObjLB,9)
	.s:CorrectFlag=1 correctNum=correctNum+1
	//考试
	s examId="" f  s examId=$O(^DHCINM.Tea.ExamTheorySubI("ExamSubDR",rw,examId)) q:examId=""  d
	.s examSubId="" f  s examSubId=$O(^DHCINM.Tea.ExamTheorySubI("ExamSubDR",rw,examId,examSubId)) q:examSubId=""  d
	..s examSubObj=$G(^DHCINM.Tea.ExamTheorySubD(examId,examSubId))
	..q:examSubObj=""
	..s answerNum=answerNum+1
	..s CorrectFlag=$lg(examSubObj,15)
	..s:CorrectFlag=1 correctNum=correctNum+1 
	//真题模考
	s DryRunId="" f  s DryRunId=$O(^DHCINM.Tea.LearnDryRunSubI("ExamSubDR",rw,DryRunId)) q:DryRunId=""  d
	.s DryRunObjLB=$G(^DHCINM.Tea.LearnDryRunD(DryRunId))
	.q:DryRunObjLB=""
	.s dryRunStatus=$LG(DryRunObjLB,11)
	.q:dryRunStatus'="Y"
	.s DryRunSubId="" f  s DryRunSubId=$O(^DHCINM.Tea.LearnDryRunSubI("ExamSubDR",rw,DryRunId,DryRunSubId)) q:DryRunSubId=""  d
	..s examSubObj=$G(^DHCINM.Tea.LearnDryRunSubD(DryRunId,DryRunSubId))
	..q:examSubObj=""
	..s answerNum=answerNum+1
	..s Result=$LG(examSubObj,3)
	..s:Result=answer correctNum=correctNum+1 
	s rate=""
	i answerNum'=0 d
	.s rate=$fn(correctNum/answerNum*100,"",2)_"%"
	q answerNum_"^"_rate_"^"_correctNum
}

/// 公共方法分割线-----------
/// Creator:
/// Createdate:
/// Description:保存公共代码父项
/// Input:
/// Output:
/// Other:
ClassMethod SaveSetCode(parr As %String) As %String
{
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s flag=..IsExist($zcvt($tr(tmp("SetCode")," ",""),"U"))
	i ((flag=2)&&(id="")) q "此记录已经存在"
	i id="" s obj=##class(CT.DHCINM.DB.MgSetCode).%New()
	e  s obj=##class(CT.DHCINM.DB.MgSetCode).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("CT.DHCINM.DB.MgSetCode","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..s $ZOBJPROPERTY(obj,p)=$zcvt($tr(tmp(p)," ",""),"U")
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:
/// Createdate:
/// Description:判断公共代码父项代码是否存在
/// Input:
/// Output:
/// Other:
ClassMethod IsExist(code As %String) As %String
{
	s flag=0
	s rid=$O(^CT.DHCINM.DB.MgSetCodeI("Code"," "_$zcvt($tr(code," ",""),"U"),""))
	i rid'="" d
	.s flag=2
	q flag
}

/// Creator:
/// Createdate:
/// Description:获取公共代码数据
/// Input:
/// Output:
/// Other:
ClassMethod GetSetCode(id As %String) As %String
{
	s obj=##class(CT.DHCINM.DB.MgSetCode).%OpenId(id)
	s ret="",tmp=""
	s p="" f  s p=$O(^oddCOM("CT.DHCINM.DB.MgSetCode","a",p)) q:p=""  d
	.q:p["%"
	.q:p["ChildSub"
	.s tmp(p)=$ZOBJPROPERTY(obj,p)
	s k="" 
	f {
		s k=$O(tmp(k))
		q:k=""
		s ret=ret_k_"|"_tmp(k)_"^"	
	}
	s ret=ret_"RowID|"_id
	q ret
}

/// Creator:
/// Createdate:
/// Description:获取公共代码数据列表
/// Input:
/// Output:
/// Other:
Query FindSetCodes(setstr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindSetCodesExecute(ByRef qHandle As %Binary, setstr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s code="" f  s code=$O(^CT.DHCINM.DB.MgSetCodeI("Code",code)) q:code=""  d
	.s rowid="" f  s rowid=$O(^CT.DHCINM.DB.MgSetCodeI("Code",code,rowid)) q:rowid=""  d
	..s obj=##class(CT.DHCINM.DB.MgSetCode).%OpenId(rowid)
	..q:'$IsObject(obj)
	..s SetCode=obj.SetCode
	..s SetDesc=obj.SetDesc
	..q:((setstr'="")&&(SetDesc'[$zcvt($tr(setstr," ",""),"U")))
	..s SetRemark=obj.SetRemark
	..s ret="SetCode|"_SetCode_"^SetDesc|"_SetDesc_"^SetRemark|"_SetRemark_"^setrw|"_rowid
	..do OutputSetData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputSetData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSetCodesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSetCodesExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindSetCodesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSetCodesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:
/// Createdate:
/// Description:获取公共代码子表数据列表
/// Input:
/// Output:
/// Other:
Query FindSetSubCode(substr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindSetSubCodeExecute(ByRef qHandle As %Binary, substr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s sort="" f  s sort=$O(^CT.DHCINM.DB.MgSetCodeSubI("Sort",substr,sort)) q:sort=""  d
	.s raw="" f  s raw=$O(^CT.DHCINM.DB.MgSetCodeSubI("Sort",substr,sort,raw)) q:raw=""  d
	..s obj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(substr_"||"_raw)
	..s SubCode=obj.SubCode
	..s SubDesc=obj.SubDesc
	..q:((input'="")&&(SubDesc'[$tr(input," ","")))
	..s SubRemark=obj.SubRemark
	..i obj.SubStDate'="" s SubStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.SubStDate)
	..e  s SubStDate=""
	..i obj.SubEndDate'="" s SubEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.SubEndDate)
	..e  s SubEndDate=""
	..s SubSymbol=obj.SubSymbol
	..s ret="SubCode|"_SubCode_"^SubDesc|"_SubDesc_"^SubRemark|"_SubRemark_"^SubStDate|"_SubStDate_"^SubEndDate|"_SubEndDate_"^par|"_substr_"^raw|"_raw_"^SubSymbol|"_SubSymbol
	..do OutputSubData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputSubData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSetSubCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSetSubCodeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindSetSubCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSetSubCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:
/// Createdate:
/// Description:保存公共代码子表数据
/// Input:
/// Output:
/// Other://subCode|藏族^subDesc|藏族^subRemark|2^subStDate|2017-08-02^subEndDate|^subSymbol|^Par|1^raw|
ClassMethod SaveSubCode(parr As %String) As %String
{
	
	s tmp=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s Par=$g(tmp("Par"))
	s raw=$g(tmp("raw"))
	s SubCode=$tr($g(tmp("subCode"))," ","")
	s codeId=$O(^CT.DHCINM.DB.MgSetCodeSubI("Code",Par," "_SubCode,""))
	q:((codeId'="")&&((raw="")||(codeId'=raw))) 2
	
	i raw="" d
	.s obj=##class(CT.DHCINM.DB.MgSetCodeSub).%New()
	.s obj.Parref=##class(CT.DHCINM.DB.MgSetCode).%OpenId(Par)
	e  d
	.s obj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(Par_"||"_raw)
	s obj.SubCode=$zcvt($tr($g(tmp("subCode"))," ",""),"U")
	s obj.SubDesc=$zcvt($tr($g(tmp("subDesc"))," ",""),"U")
	s obj.SubRemark=$zcvt($tr($g(tmp("subRemark"))," ",""),"U")
	i $g(tmp("subStDate"))'="" s obj.SubStDate=$zdh($g(tmp("subStDate")),3)
	e  s obj.SubStDate=""
	i $g(tmp("subEndDate"))'="" s obj.SubEndDate=$zdh($g(tmp("subEndDate")),3)
	e  s obj.SubEndDate=""
	s obj.SubSymbol=$zcvt($tr($g(tmp("subSymbol"))," ",""),"U")
	s obj.SubSort=$tr($g(tmp("subSort"))," ","")
	s obj.subFiterSymbol=$zcvt($tr($g(tmp("subFiterSymbol"))," ",""),"U")
	s sc=obj.%Save()
	q sc
}

/// Creator:
/// Createdate:
/// Description:获取公共代码子表序号
/// Input:
/// Output:
/// Other:
ClassMethod ComCodeSubSort(par As %String) As %String
{
	s n=1
	s sort="" f  s sort=$O(^CT.DHCINM.DB.MgSetCodeSubI("Sort",par,sort)) q:sort=""  d
	.s rw="" f  s rw=$O(^CT.DHCINM.DB.MgSetCodeSubI("Sort",par,sort,rw)) q:rw=""  d
	..s obj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(par_"||"_rw)
	..i obj.SubSort'="" s n=n+1
	q n
}

/// Creator:
/// Createdate:
/// Description:设置公共代码子表序号
/// Input:
/// Output:
/// Other:
ClassMethod SetCodeSubSort(rowid As %String, type As %String) As %String
{
	q:rowid="" ""
	s ret=0
	s par=$p(rowid,"||",1)
	s rw=$p(rowid,"||",2)
	s obj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(rowid)
	s sort=obj.SubSort
	i type="up"
	{
		i sort="1" s ret=0
		e  d
		.s ret=sort-1
		.s obj.SubSort=sort-1
		.s row=$O(^CT.DHCINM.DB.MgSetCodeSubI("Sort",par,sort-1,""))
		.s bobj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(par_"||"_row)
		.s bobj.SubSort=sort
		.d bobj.%Save()
		.d obj.%Save()
	}
	elseif type="down"
	{
		s maxSort=$O(^CT.DHCINM.DB.MgSetCodeSubI("Sort",par,""),-1)
		i sort=maxSort s ret=1
		e  d
		.s ret=sort+1
		.s obj.SubSort=sort+1
		.s row=$O(^CT.DHCINM.DB.MgSetCodeSubI("Sort",par,sort+1,""))
		.s bobj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(par_"||"_row)
		.s bobj.SubSort=sort
		.d bobj.%Save()
		.d obj.%Save()
	} 
	q ret
}

/// Creator:
/// Createdate:
/// Description:判断公共代码子项代码是否存在
/// Input:
/// Output:
/// Other:
ClassMethod IsSubExist(par As %String, code As %String) As %String
{
	s flag=0
	s id=$O(^CT.DHCINM.DB.MgSetCodeSubI("Code",par," "_$zcvt($tr(code," ",""),"U"),""))
	i id'="" s flag=2
	q flag
}

/// Creator:
/// Createdate:
/// Description:获取公共代码子项信息
/// Input:
/// Output:
/// Other:
ClassMethod GetSubItem(id As %String) As %String
{
	s ret=""
	q:id="" ""
	s obj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(id)
	s subCode=obj.SubCode
	s subDesc=obj.SubDesc
	s subRemark=obj.SubRemark
	i obj.SubStDate'="" s subStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.SubStDate)
	e  s subStDate=""
	i obj.SubEndDate'="" s subEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.SubEndDate)
	e  s subEndDate=""
	s subSymbol=obj.SubSymbol
	s subSort=obj.SubSort
	s subFiterSymbol=obj.subFiterSymbol
	s ret="subCode|"_subCode_"^subDesc|"_subDesc_"^subRemark|"_subRemark
	_"^subStDate|"_subStDate_"^subEndDate|"_subEndDate
	_"^subSymbol|"_subSymbol_"^raw|"_$P(id,"||",2)
	_"^subSort|"_subSort_"^subFiterSymbol|"_subFiterSymbol
	q ret
}

/// Creator:
/// Createdate:
/// Description:保存病区信息
/// Input:
/// Output:
/// Other:d ##class(web.INMDBComm).SaveWard("CTLocDR|31^WardTypeDR|1__1^WardCode|中西医结合二科护理单元^WardDesc|中西医结合二科护理单元^WardSpell|ZXYJHEKHLDY^WardAreaDR|^WardLimits|2__1,2__2^WardLocDR|^WardStDate|2017-08-17^WardEndDate|^rw|^WardShort|^")
ClassMethod SaveWard(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s flag=0
	s id=$o(^CF.DHCINM.DB.MgWardI("Code"," "_$zcvt($tr(tmp("WardCode")," ",""),"U"),""))
	i $g(tmp("rw"))="" d
	.i id'="" s flag=-2
	.;e  s flag=0
	e  d
	.i ((id'="")&&($g(tmp("rw"))'=id)) s flag=-2
	q:flag=-2 -2
	i $g(tmp("rw"))'="" d
	.s obj=##class(CF.DHCINM.DB.MgWard).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(CF.DHCINM.DB.MgWard).%New()
	i ($g(tmp("CTLocDR"))'="")&&($d(^CTLOC(tmp("CTLocDR")))) d
	.s obj.CTLocDR=##class(User.CTLoc).%OpenId(tmp("CTLocDR"))
	.i obj.CTLocDR.CTLOCHospitalDR'="" d
	..s obj.CTHospitalDR=obj.CTLocDR.CTLOCHospitalDR
	e  s obj.CTLocDR=""
	i $g(tmp("WardTypeDR"))'="" d
	.s obj.WardTypeDR=##class(CT.DHCINM.Set.MgSysParamSub).%OpenId($tr(tmp("WardTypeDR"),"__","||"))
	e  s obj.WardTypeDR=""
	s obj.WardCode=$g(tmp("WardCode"))
	s obj.WardDesc=$g(tmp("WardDesc"))
	i $g(tmp("WardDesc"))'="" d
	.s obj.WardSpell=##class(web.INMVueComm).ToChineseSpell(tmp("WardDesc"))
	s obj.WardShort=$g(tmp("WardShort"))
	d obj.WardLimits.Clear()
	f i=1:1:$L(tmp("WardLimits")) d
	.s itm=$P(tmp("WardLimits"),",",i)
	.q:itm=""
	.d obj.WardLimits.Insert($tr(itm,"__","||"))
	i $g(tmp("WardStDate"))'="" s obj.WardStDate=$zdh(tmp("WardStDate"),3)
	e  s obj.WardStDate=""
	i $g(tmp("WardEndDate"))'="" s obj.WardEndDate=$zdh(tmp("WardEndDate"),3)
	e  s obj.WardEndDate=""
	s obj.WardSort=$g(tmp("WardSort"))
	i $g(tmp("WardAreaDR"))'="" d
	.s WardAreaObj=##class(CF.DHCINM.DB.MgWardArea).%OpenId($g(tmp("WardAreaDR")))
	.i $IsObject(WardAreaObj) s obj.WardAreaDR=WardAreaObj
	e  s obj.WardAreaDR=""
	s obj.WardRemark=$g(tmp("WardRemark"))
	i $g(tmp("HospitalDR"))'="" d
	.s hospitalObj=##class(CF.DHCINM.DB.MgHospitalSet).%OpenId($g(tmp("HospitalDR")))
	.s obj.HospitalDR=hospitalObj
	e  s obj.HospitalDR=""
	s obj.WardBedNum=$g(tmp("WardBedNum"))
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:
/// Createdate:
/// Description:获取病区信息
/// Input:
/// Output:
/// Other:w ##class(web.INMDBComm).GetWard(1)
ClassMethod GetWard(id As %String) As %String
{
	q:id="" ""
	s obj=##class(CF.DHCINM.DB.MgWard).%OpenId(id)
	q:'$IsObject(obj) ""
	s ret="rw|"_id
	s ret=ret_"^WardCode|"_obj.WardCode
	s ret=ret_"^WardDesc|"_obj.WardDesc
	i obj.WardTypeDR'="" d
	.s ret=ret_"^WardTypeDR|"_$tr(obj.WardTypeDR.%Id(),"|","_")
	.s ret=ret_"^WardTypeDesc|"_obj.WardTypeDR.SubDesc
	s wardlimits="",limitdesc=""
	f i=1:1:obj.WardLimits.Count() d
	.s itmObj=##class(CT.DHCINM.Set.MgSysParamSub).%OpenId(obj.WardLimits.GetAt(i))
	.i wardlimits="" d
	..s wardlimits=obj.WardLimits.GetAt(i),limitdesc=itmObj.SubDesc
	.e  d
	..s wardlimits=wardlimits_","_obj.WardLimits.GetAt(i),limitdesc=limitdesc_","_itmObj.SubDesc
	s ret=ret_"^WardLimits|"_$tr(wardlimits,"|","_")_"^LimitDesc|"_limitdesc
	i obj.CTLocDR'="" d
	.s ret=ret_"^CTLocDR|"_obj.CTLocDR.%Id()
	.i obj.CTLocDR.CTLOCDesc["-" s ret=ret_"^CTLocDesc|"_$P(obj.CTLocDR.CTLOCDesc,"-",2)
	.e  s ret=ret_"^CTLocDesc|"_obj.CTLocDR.CTLOCDesc
	i obj.CTHospitalDR'="" d
	.s ret=ret_"^CTHospitalDR|"_obj.CTHospitalDR.%Id()
	.s ret=ret_"^CTHospitalDesc|"_obj.CTHospitalDR.HOSPDesc
	s ret=ret_"^WardSpell|"_obj.WardSpell
	s ret=ret_"^WardShort|"_obj.WardShort
	i obj.WardAreaDR'="" d
	.s ret=ret_"^WardAreaDR|"_obj.WardAreaDR.%Id()
	.s ret=ret_"^WardAreaDesc|"_obj.WardAreaDR.AreaDesc
	i obj.WardStDate'="" s ret=ret_"^WardStDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.WardStDate)
	i obj.WardEndDate'="" s ret=ret_"^WardEndDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.WardEndDate)
	i obj.WardSort'="" s ret=ret_"^WardSort|"_obj.WardSort
	i obj.WardRemark'="" s ret=ret_"^WardRemark|"_obj.WardRemark
	s HospitalDR="",HospitalDesc=""
	i $IsObject(obj.HospitalDR)  d
	.s HospitalDR=obj.HospitalDR.%Id()
	.s HospitalDesc=obj.HospitalDR.HospitalName
	s ret=ret_"^HospitalDR|"_HospitalDR_"^HospitalDesc|"_HospitalDesc_"^WardBedNum|"_obj.WardBedNum
	q ret
}

/// Creator:
/// Createdate:
/// Description:病区关联ctloc和代码是否重复
/// Input:
/// Output:
/// Other:
ClassMethod CheckWard(locid As %String, code As %String) As %String
{
	q:(locid="")&(code="") 0
	s id=""
	i locid'="" d
	.s id=$O(^CF.DHCINM.DB.MgWardI("CTLoc",locid,""))
	q:id'="" 1
	i code'="" d
	.s id=$O(^CF.DHCINM.DB.MgWardI("Code"," "_$zcvt(code,"U"),""))
	q:id'="" 1
	q 0
}

/// Creator:
/// Createdate:
/// Description:获取病区信息列表
/// Input:
/// Output:
/// Other:w ##class(%ResultSet).RunQuery("web.INMDBComm","FindWardList","^Y","")
Query FindWardList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tmpLocWard=""
	s locId=$P(parr,"^",1)
	s status=$P(parr,"^",2)
	i locId'="" d
	.s wardid="" f  s wardid=$O(^CF.DHCINM.DB.MgWardLocUnitI("Loc",$tr(locId," ",""),wardid)) q:wardid=""  d
	..q:wardid=""
	..s tmpLocWard(wardid)=wardid
	s sort="" f  s sort=$O(^CF.DHCINM.DB.MgWardI("Sort",sort)) q:sort=""  d
	.s id="" f  s id=$O(^CF.DHCINM.DB.MgWardI("Sort",sort,id)) q:id=""  d
	..s obj=##class(CF.DHCINM.DB.MgWard).%OpenId(id)
	..q:((locId'="")&&('$d(tmpLocWard(id)))) 
	..q:((input'="")&&((obj.WardSpell_obj.WardDesc)'[$zcvt($tr(input," ",""),"U")))
	..q:((status="Y")&&(obj.WardStDate'="")&&(obj.WardStDate>+$H))
	..q:((status="Y")&&(obj.WardEndDate'="")&&(obj.WardEndDate<+$H))
	..s ret=..GetWard(id)
	..d OutWard
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWard
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:
/// Createdate:
/// Description:获取未停用病区列表
/// Input:
/// Output:
/// Other: w ##class(%ResultSet).RunQuery("web.INMDBComm","FindInuseWardList","","")
Query FindInuseWardList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindInuseWardListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tmpLocWard=""
	s nowDate=+$H
	i parr'="" d
	.s wardid="" f  s wardid=$O(^CF.DHCINM.DB.MgWardLocUnitI("Loc",$tr(parr," ",""),wardid)) q:wardid=""  d
	..q:wardid=""
	..s tmp(wardid)=wardid
	s sort="" f  s sort=$O(^CF.DHCINM.DB.MgWardI("Sort",sort)) q:sort=""  d
	.s id="" f  s id=$O(^CF.DHCINM.DB.MgWardI("Sort",sort,id)) q:id=""  d
	..s obj=##class(CF.DHCINM.DB.MgWard).%OpenId(id)
	..q:((parr'="")&&('$d(tmpLocWard(id)))) 
	..q:((input'="")&&((obj.WardSpell_obj.WardDesc)'[$zcvt($tr(input," ",""),"U")))
	..q:((obj.WardStDate'="")&&(obj.WardStDate>nowDate))
	..q:((obj.WardEndDate'="")&&(obj.WardEndDate<nowDate))
	..s ret=..GetWard(id)
	..q:ret=""
	..d OutWard
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWard
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindInuseWardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInuseWardListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindInuseWardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:
/// Createdate:
/// Description:保存片区
/// Input:
/// Output:
/// Other:
ClassMethod SaveWardArea(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s flag=..IsExistArea(parr)
	q:flag=-1 "此记录已经存在，保存失败"
	i $g(tmp("rw"))'="" d
	.s obj=##class(CF.DHCINM.DB.MgWardArea).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(CF.DHCINM.DB.MgWardArea).%New()
	s obj.AreaCode=$g(tmp("AreaCode"))
	s obj.AreaDesc=$g(tmp("AreaDesc"))
	i $g(tmp("AreaNurHeadDR"))'="" d
	.s obj.AreaNurHeadDR=##class(CF.DHCINM.HR.Persons).%OpenId(tmp("AreaNurHeadDR"))
	e  s obj.AreaNurHeadDR=""
	i $g(tmp("AreaStDate"))'="" s obj.AreaStDate=$zdh(tmp("AreaStDate"),3)
	e  s obj.AreaStDate=""
	i $g(tmp("AreaEndDate"))'="" s obj.AreaEndDate=$zdh(tmp("AreaEndDate"),3)
	e  s obj.AreaEndDate=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:
/// Createdate:
/// Description:判断片区代码是否存在
/// Input:
/// Output:
/// Other:
ClassMethod IsExistArea(parr As %String) As %String
{
	q:parr="" 0
	s flag=0
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	s id=$o(^CF.DHCINM.DB.MgWardAreaI("Code"," "_$zcvt($tr($g(tmp("AreaCode"))," ",""),"U"),""))
	i rw="" d
	.i id'="" s flag=-1
	e  d
	.i ((id'="")&&(rw'=id)) s flag=-1
	q flag
}

/// Creator:
/// Createdate:
/// Description:获取片区信息
/// Input:
/// Output:
/// Other:
ClassMethod GetWardArea(id As %String) As %String
{
	q:id="" ""
	s obj=##class(CF.DHCINM.DB.MgWardArea).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^AreaCode|"_obj.AreaCode
	s ret=ret_"^AreaDesc|"_obj.AreaDesc
	i obj.AreaNurHeadDR'="" d
	.s ret=ret_"^AreaNurHeadDR|"_obj.AreaNurHeadDR.%Id()
	.s ret=ret_"^NurHeadName|"_obj.AreaNurHeadDR.PerName
	i obj.AreaStDate'="" d
	.s ret=ret_"^AreaStDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.AreaStDate)
	i obj.AreaEndDate'="" d
	.s ret=ret_"^AreaEndDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.AreaEndDate)
	q ret
}

/// Creator:
/// Createdate:
/// Description:获取片区信息列表
/// Input:
/// Output:
/// Other:
Query FindWardAreaList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardAreaListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s status=$P(parr,"&",1)
	s code="" f  s code=$O(^CF.DHCINM.DB.MgWardAreaI("Code",code)) q:code=""  d
	.s id="" f  s id=$O(^CF.DHCINM.DB.MgWardAreaI("Code",code,id)) q:id=""  d
	..s obj=##class(CF.DHCINM.DB.MgWardArea).%OpenId(id)
	..q:'$IsObject(obj)
	..q:((status="Y")&&(obj.AreaStDate'="")&&(obj.AreaStDate>+$H))
	..q:((status="Y")&&(obj.AreaEndDate'="")&&(obj.AreaEndDate<+$H))
	..s ret=..GetWardArea(id)
	..d OutWardArea
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWardArea
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardAreaListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardAreaListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardAreaListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardAreaListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:
/// Createdate:
/// Description:保存科室信息
/// Input:
/// Output:
/// Other: d ##class(web.INMDBComm).SaveWardLoc("LocCode|ZXYJHYK^LocDesc|中西医结合一科^CTLocDR|6^LocNurHeadDR|^LocStDate|2017-08-17^LocEndDate|^rw|^")
ClassMethod SaveWardLoc(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))'="" d
	.s obj=##class(CF.DHCINM.DB.MgWardLoc).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(CF.DHCINM.DB.MgWardLoc).%New()
	s obj.LocCode=$g(tmp("LocCode"))
	s obj.LocDesc=$g(tmp("LocDesc"))
	i $g(tmp("CTLocDR"))'="" d
	.s obj.CTLocDR=##class(User.CTLoc).%OpenId(tmp("CTLocDR"))
	e  s obj.CTLocDR=""
	i $g(tmp("LocNurHeadDR"))'="" d
	.s obj.LocNurHeadDR=##class(CF.DHCINM.HR.Persons).%OpenId(tmp("LocNurHeadDR"))
	e  s obj.LocNurHeadDR=""
	i $g(tmp("LocStDate"))'="" s obj.LocStDate=$zdh(tmp("LocStDate"),3)
	e  s obj.LocStDate=""
	i $g(tmp("LocEndDate"))'="" s obj.LocEndDate=$zdh(tmp("LocEndDate"),3)
	e  s obj.LocEndDate=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:
/// Createdate:
/// Description:获取科室信息
/// Input:
/// Output:
/// Other:
ClassMethod GetWardLoc(id As %String) As %String
{
	q:id="" ""
	s obj=##class(CF.DHCINM.DB.MgWardLoc).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^LocCode|"_obj.LocCode
	s ret=ret_"^LocDesc|"_obj.LocDesc
	i obj.CTLocDR'="" d
	.s ret=ret_"^CTLocDR|"_obj.CTLocDR.%Id()
	.i obj.CTLocDR.CTLOCDesc["-" s ret=ret_"^CTLocDesc|"_$P(obj.CTLocDR.CTLOCDesc,"-",2)
	.e  s ret=ret_"^CTLocDesc|"_obj.CTLocDR.CTLOCDesc
	i obj.LocNurHeadDR'="" d
	.s ret=ret_"^LocNurHeadDR|"_obj.LocNurHeadDR.%Id()
	.s ret=ret_"^NurHeadName|"_obj.LocNurHeadDR.PerName
	i obj.LocStDate'="" d
	.s ret=ret_"^LocStDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.LocStDate)
	i obj.LocEndDate'="" d
	.s ret=ret_"^LocEndDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.LocEndDate)
	q ret
}

/// Creator:
/// Createdate:
/// Description:保存科室信息列表
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMDBComm","FindWardLocList","")
Query FindWardLocList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardLocListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s status=$P(parr,"^",1)
	s code="" f  s code=$O(^CF.DHCINM.DB.MgWardLocI("Code",code)) q:code=""  d
	.s id="" f  s id=$O(^CF.DHCINM.DB.MgWardLocI("Code",code,id)) q:id=""  d
	..s obj=##class(CF.DHCINM.DB.MgWardLoc).%OpenId(id)
	..s locShell=##class(web.INMVueComm).ToChineseSpell(obj.LocDesc)
	..q:((input'="")&&(($zcvt(locShell_obj.LocDesc,"U"))'[$zcvt($tr(input," ",""),"U")))
	..q:((status="Y")&&(obj.LocStDate'="")&&(obj.LocStDate>+$H))
	..q:((status="Y")&&(obj.LocEndDate'="")&&(obj.LocEndDate<+$H))
	..s ret=..GetWardLoc(id)
	..d OutWardLoc
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWardLoc
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardLocListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:
/// Createdate:
/// Description:获取公共代码子表信息
/// Input:
/// Output:
/// Other: d ##class(%ResultSet).RunQuery("web.INMDBComm","FindPubCode","聘任职称")
Query FindPubCode(type As %String = "") As %Query(ROWSPEC = "SubCode,SubDesc,SubValue,SubColor,SubSymbol")
{
}

ClassMethod FindPubCodeExecute(ByRef qHandle As %Binary, type As %String = "") As %Status
{
	s ^TMP("FindPubCodeExecute")=type
	s repid=$I(^CacheTemp)
	s ind=1
	s par="" f  s par=$O(^CT.DHCINM.DB.MgSetCodeI("Code"," "_$zcvt($tr(type," ",""),"U"),par)) q:par=""  d
	.s sort="" f  s sort=$O(^CT.DHCINM.DB.MgSetCodeSubI("Sort",par,sort)) q:sort=""  d
	..s raw="" f  s raw=$O(^CT.DHCINM.DB.MgSetCodeSubI("Sort",par,sort,raw)) q:raw=""  d
	...;s obj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(par_"||"_raw)
	...s objLB=$g(^CT.DHCINM.DB.MgSetCodeSubD(par,raw))
	...q:objLB=""
	...s date=+$H
	...s SubStDate=$LG(objLB,5)
	...s SubEndDate=$LG(objLB,6)
	...q:(SubStDate'="")&&(date<SubStDate)
	...q:((SubEndDate'="")&&(date>SubEndDate))
	...s SubCode=$LG(objLB,2)
	...s SubDesc=$LG(objLB,3)
	...s SubColor=$LG(objLB,4)
	...s SubSymbol=$LG(objLB,7)
	...do OutputPub
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPub
	set Data=$lb(SubCode,SubDesc,par_"||"_raw,SubColor,SubSymbol)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPubCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPubCodeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPubCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPubCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:
/// Createdate:
/// Description:保存全局班次信息
/// Input:
/// Output:
/// Other: w ##class(web.INMDBComm).SaveArgPost("PostDesc|A^PostType|P^HolidayTime|^PostStTime1|08:00^PostEndTime1|^PostEndTime1T|16:00^PostNextDay1|false^PostStTime2|^PostEndTime2|^PostEndTime2T|^PostNextDay2|false^PostStTime3|^PostEndTime3|^PostEndTime3T|^PostNextDay3|false^PostMinutes|^PostDayMinutes|^PostNextMinutes|^PostUseType|H^PostUseLimit|^PostFontColor|^PostBgColor|^PostRemark|^PostStatus|Y^PostCategory|W^PostCrtDate|2020-05-26^PostCrtTime|2020-05-26^PostCrtUser|^rw|^PostLevel|一线班^PostSort|1^isEditFlag|false^PostTime1|^PostTime2|^")
ClassMethod SaveArgPost(parr As %String, crtUser As %String) As %String
{
	q:parr="" 0
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s Flag=1
	s PostDesc=$TR($G(tmp("PostDesc"))," ","")
	s isExistName=0
	s tRw="" f  s tRw=$O(^CF.DHCINM.DB.MgArgPostI("Desc"," "_$ZCVT(PostDesc,"U"),tRw)) q:(tRw="")||(isExistName=1)  d
	.s tRwObj=##class(CF.DHCINM.DB.MgArgPost).%OpenId(tRw)
	.q:'$IsObject(tRwObj)
	.q:tRw=$g(tmp("rw"))
	.i tRwObj.PostDesc=PostDesc s isExistName=1
	q:isExistName=1 "名称重复"
	TS
	i $g(tmp("rw"))'="" d
	.s obj=##class(CF.DHCINM.DB.MgArgPost).%OpenId(tmp("rw"))
	.;【南通中医需求，更改全局排班自动更改病区排班时间】
	.;i (($d(^CF.DHCINM.DB.MgArgWardPostI("Post",tmp("rw"))))) d
	.;粤北需要全局的名称作为代码，病区岗位名称可维护，去掉修改全局班次同事修改
	.i (obj.PostDesc'=$g(tmp("PostDesc")))&&($d(^CF.DHCINM.DB.MgArgWardPostI("Post",tmp("rw")))) d
	..s wardPostId="" f  s wardPostId=$O(^CF.DHCINM.DB.MgArgWardPostI("Post",tmp("rw"),wardPostId)) q:(wardPostId="")||(Flag=0)  d
	...s wardPostObj=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(wardPostId)
	...s wardPostObj.PostDesc=$g(tmp("PostDesc"))
	...;【南通中医需求，更改全局排班自动更改病区排班时间】
	...;s wardPostObj.PostStTime1=$g(tmp("PostStTime1"))
	...;s wardPostObj.PostEndTime1=$g(tmp("PostEndTime1"))
	...;s wardPostObj.PostStTime2=$g(tmp("PostStTime2"))
	...;s wardPostObj.PostEndTime2=$g(tmp("PostEndTime2"))
	...;s wardPostObj.PostStTime3=$g(tmp("PostStTime3"))
	...;s wardPostObj.PostEndTime3=$g(tmp("PostEndTime3"))
	...;s wardPostObj.PostMinutes=$g(tmp("PostMinutes"))
	...;s wardPostObj.PostDayMinutes=$g(tmp("PostDayMinutes"))
	...;s wardPostObj.PostNextMinutes=$g(tmp("PostNextMinutes"))
	...s sc=wardPostObj.%Save()
	...i $$$ISERR(sc) s Flag=0
	e  d
	.s obj=##class(CF.DHCINM.DB.MgArgPost).%New()
	.s obj.PostCode=$zd(+$h,8)_$tr($zt($P($h,",",2),1),":","")
	.s obj.PostCrtDate=+$h
	.s obj.PostCrtTime=$P($h,",",2)
	.s obj.PostCrtUser=crtUser
	q:Flag=0 0
	s obj.PostDesc=$g(tmp("PostDesc"))
	s obj.PostType=$g(tmp("PostType"))
	s obj.HolidayTime=$g(tmp("HolidayTime"))
	s obj.PostStTime1=$g(tmp("PostStTime1"))
	s obj.PostEndTime1=$g(tmp("PostEndTime1"))
	s obj.PostStTime2=$g(tmp("PostStTime2"))
	s obj.PostEndTime2=$g(tmp("PostEndTime2"))
	s obj.PostStTime3=$g(tmp("PostStTime3"))
	s obj.PostEndTime3=$g(tmp("PostEndTime3"))
	s obj.PostMinutes=$g(tmp("PostMinutes"))
	s obj.PostDayMinutes=$g(tmp("PostDayMinutes"))
	s obj.PostNextMinutes=$g(tmp("PostNextMinutes"))
	s obj.PostUseType=$g(tmp("PostUseType"))
	s obj.PostUseLimit=$g(tmp("PostUseLimit"))
	s obj.PostFontColor=$g(tmp("PostFontColor"))
	s obj.PostBgColor=$g(tmp("PostBgColor"))
	s obj.PostRemark=$g(tmp("PostRemark"))
	s obj.PostStatus=$g(tmp("PostStatus"))
	s obj.PostCategory=$g(tmp("PostCategory"))
	s obj.PostLevel=$g(tmp("PostLevel"))
	s obj.PostSort=$g(tmp("PostSort"))
	s obj.IsDuty=$g(tmp("IsDuty"))
	s obj.IsWishPost=$g(tmp("IsWishPost"))
	s obj.IsPaid=$g(tmp("IsPaid"))
	s sc=obj.%Save()
	if $$$ISOK(sc) {
		TC
		q 1
	}else{
		TRO
		d $System.Status.DisplayError(sc)
		q 0	
	}
}

/// Creator:
/// Createdate:
/// Description:获取全局班次信息
/// Input:
/// Output:
/// Other: w ##class(web.INMDBComm).GetArgPost(1)
ClassMethod GetArgPost(id As %String) As %String
{
	q:id="" ""
	s obj=##class(CF.DHCINM.DB.MgArgPost).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^PostCode|"_obj.PostCode
	s ret=ret_"^PostDesc|"_obj.PostDesc
	s ret=ret_"^PostType|"_obj.PostType
	s ret=ret_"^TypeDesc|"_$case(obj.PostType,"P":"值班","H":"休假","S":"特殊",:"")
	s ret=ret_"^HolidayTime|"_obj.HolidayTime
	s ret=ret_"^TimeDesc|"_$case(obj.HolidayTime,"A":"全天","H":"半天","L":"哺乳期",:"")
	s ret=ret_"^PostStTime1|"_obj.PostStTime1
	s ret=ret_"^PostEndTime1|"_obj.PostEndTime1
	s ret=ret_"^PostStTime2|"_obj.PostStTime2
	s ret=ret_"^PostEndTime2|"_obj.PostEndTime2
	s ret=ret_"^PostStTime3|"_obj.PostStTime3
	s ret=ret_"^PostEndTime3|"_obj.PostEndTime3
	s ret=ret_"^PostMinutes|"_obj.PostMinutes
	s ret=ret_"^PostDayMinutes|"_obj.PostDayMinutes
	s ret=ret_"^PostNextMinutes|"_obj.PostNextMinutes
	s ret=ret_"^PostUseType|"_obj.PostUseType
	s ret=ret_"^UseTypeDesc|"_$case(obj.PostUseType,"H":"全院通用","A":"指定片区","L":"指定科室","W":"指定病区",:"")
	s ret=ret_"^PostUseLimit|"_obj.PostUseLimit
	s ret=ret_"^PostSort|"_obj.PostSort
	s IsDuty=obj.IsDuty
	s:IsDuty="" IsDuty="Y"
	s IsPaid="N"
	s:obj.IsPaid="Y" IsPaid="Y" 
	s ret=ret_"^IsDuty|"_IsDuty_"^IsWishPost|"_obj.IsWishPost_"^IsPaid|"_IsPaid

	s limitdesc=""
	f i=1:1:$L(obj.PostUseLimit,",") d
	.s limitid=$P(obj.PostUseLimit,",",i)
	.q:limitid=""
	.i obj.PostUseType="A" d
	..s limit=##class(CF.DHCINM.DB.MgWardArea).%OpenId(limitid)
	..s limitdesc=limitdesc_limit.AreaDesc_","
	.i obj.PostUseType="L" d
	..s limit=##class(CF.DHCINM.DB.MgWardLoc).%OpenId(limitid)
	..s limitdesc=limitdesc_limit.LocDesc_","
	.i obj.PostUseType="W" d
	..s limit=##class(CF.DHCINM.DB.MgWard).%OpenId(limitid)
	..s limitdesc=limitdesc_limit.WardDesc_","
	i limitdesc'="" d
	.s ret=ret_"^UseLimitDesc|"_$E(limitdesc,1,$L(limitdesc)-1)
	s ret=ret_"^PostFontColor|"_obj.PostFontColor
	s ret=ret_"^PostBgColor|"_obj.PostBgColor
	s ret=ret_"^PostStatus|"_obj.PostStatus
	s ret=ret_"^StatusDesc|"_$Case(obj.PostStatus,"Y":"启用","N":"停用",:"")
	s ret=ret_"^PostRemark|"_obj.PostRemark
	i obj.PostCrtDate'="" s ret=ret_"^PostCrtDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.PostCrtDate)
	i obj.PostCrtTime'="" s ret=ret_"^PostCrtTime|"_$zt(obj.PostCrtTime,1)
	i obj.PostCrtUser'="" d
	.i obj.PostCrtUser=0 s ret=ret_"^PostCrtUser|0"_"^CrtUserName|管理员"
	.e  d
	..s PostCrtUser="",CrtUserName=""
	..s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(obj.PostCrtUser)
	..q:'$IsObject(userObj)
	..s PostCrtUser=obj.PostCrtUser
	..s CrtUserName=userObj.UserName
	..s ret=ret_"^PostCrtUser|"_PostCrtUser
	..s ret=ret_"^CrtUserName|"_CrtUserName
	s CategoryDesc=##class(INMSetComm).GetParamSubByCode("POSTTYPE",obj.PostCategory,"SubDesc")
	s PostCategory=obj.PostCategory
	s PostLevel=obj.PostLevel
	s ret=ret_"^CategoryDesc|"_CategoryDesc_"^PostCategory|"_PostCategory_"^PostLevel|"_PostLevel
	
	q ret
}

/// Creator:
/// Createdate:
/// Description:删除全局班次信息
/// Input:
/// Output:
/// Other:
ClassMethod DeleteArgPost(id As %String) As %String
{
	q:id="" ""
	q:$d(^CF.DHCINM.DB.MgArgWardPostI("Post",id)) "已关联病区排班,不能删除！"
	s sort=0
	s obj=##class(CF.DHCINM.DB.MgArgPost).%OpenId(id)
	s sort=obj.PostSort
	s sc=obj.%DeleteId(id)
	s postid="" f  s postid=$O(^CF.DHCINM.DB.MgArgPostI("Sort",sort+1,postid)) q:postid=""  d
	.s PostObj=##class(CF.DHCINM.DB.MgArgPost).%OpenId(postid)
	.s PostObj.PostSort=sort
	.s sort=sort+1
	.d PostObj.%Save()
	q $$$ISOK(sc)
}

/// Creator:
/// Createdate:
/// Description:获取病区班次信息列表
/// Input:
/// Output:
/// Other: w ##class(%ResultSet).RunQuery("web.INMDBComm","FindPostForWard","","")
Query FindPostForWard(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPostForWardExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	s status=$P(parr,"^",2)
	s limitFlag=$P(parr,"^",3)
	s sort="" f  s sort=$O(^CF.DHCINM.DB.MgArgPostI("Sort",sort)) q:sort=""  d
	.s Row="" f  s Row=$O(^CF.DHCINM.DB.MgArgPostI("Sort",sort,Row)) q:Row=""  d
	..s obj=##class(CF.DHCINM.DB.MgArgPost).%OpenId(Row)
	..q:'$IsObject(obj)
	..s desc=obj.PostDesc
	..q:(input'="")&&($zcvt(desc,"U")'[$zcvt(input,"U"))
	..q:((status'="")&&(obj.PostStatus'=status))
	..s usetype=obj.PostUseType
	..s uselimit=obj.PostUseLimit
	..s len=$l(uselimit,",")
	..s flag=0
	..f i=1:1:len d
	...s itm=$p(uselimit,",",i)
	...q:itm=""
	...i ((ward'="")&&(itm=ward)) s flag=1
	..q:((limitFlag=1)&&(usetype="W")&&(flag=0))
	..s ret=..GetArgPost(Row)
	..d OutPostForWard
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPostForWard
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPostForWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPostForWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPostForWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPostForWardExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:
/// Createdate:
/// Description:保存病区班次信息
/// Input:
/// Output:
/// Other: w ##class(web.INMDBComm).SaveWardPost(^TmpXBl("WardPost"))
ClassMethod SaveWardPost(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	q:($g(tmp("WardDR"))="")!($g(tmp("PostDR"))="") ""
	s isExistName=0
	s tRw="" f  s tRw=$O(^CF.DHCINM.DB.MgArgWardPostI("WardPost",$g(tmp("WardDR")),$g(tmp("PostDR")),tRw)) q:(tRw="")||(isExistName=1)  d
	.s tRwObj=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(tRw)
	.q:'$IsObject(tRwObj)
	.q:tRw=$g(tmp("rw"))
	.i tRwObj.PostDesc=$g(tmp("PostDesc")) s isExistName=1
	q:isExistName=1 "名称重复"
	i $g(tmp("rw"))'="" d
	.s obj=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(CF.DHCINM.DB.MgArgWardPost).%New()
	.s obj.PostCrtDate=+$h
	.s obj.PostCrtTime=$P($h,",",2)
	.i $g(tmp("PostCrtUser"))'="" s obj.PostCrtUser=##class(CF.DHCINM.DB.MgUser).%OpenId(tmp("PostCrtUser"))
	s obj.PostDesc=$g(tmp("PostDesc"))
	i $g(tmp("PostDR"))'="" s obj.PostDR=##class(CF.DHCINM.DB.MgArgPost).%OpenId(tmp("PostDR"))
	e  s obj.PostDR=""
	i $g(tmp("WardDR"))'="" s obj.WardDR=##class(CF.DHCINM.DB.MgWard).%OpenId(tmp("WardDR"))
	e  s obj.WardDR=""
	s obj.PostClass=$g(tmp("PostClass"))
	s obj.PostStTime1=$g(tmp("PostStTime1"))
	s obj.PostEndTime1=$g(tmp("PostEndTime1"))
	s obj.PostStTime2=$g(tmp("PostStTime2"))
	s obj.PostEndTime2=$g(tmp("PostEndTime2"))
	s obj.PostStTime3=$g(tmp("PostStTime3"))
	s obj.PostEndTime3=$g(tmp("PostEndTime3"))
	s obj.PostMinutes=$g(tmp("PostMinutes"))
	s obj.PostDayMinutes=$g(tmp("PostDayMinutes"))
	s obj.PostNextMinutes=$g(tmp("PostNextMinutes"))
	s obj.PostRemark=$g(tmp("PostRemark"))
	i $g(tmp("PostSort"))'="" s obj.PostSort=$g(tmp("PostSort"))
	e  i $g(tmp("WardDR"))'="" s obj.PostSort=..GetWardPostSort(tmp("WardDR"))
	s obj.PostCategory=$g(tmp("PostCategory"))
	s obj.PostFactor=$g(tmp("PostFactor"))
	s sc=obj.%Save()
	d $System.Status.DisplayError(sc)
	q $$$ISOK(sc)
}

/// Creator:
/// Createdate:
/// Description:获取病区班次信息
/// Input:
/// Output:
/// Other: w ##class(web.INMDBComm).GetWardPost(1)
ClassMethod GetWardPost(id As %String) As %String
{
	q:id="" ""
	s obj=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^PostDesc|"_obj.PostDesc
	i obj.WardDR'="" d
	.s ret=ret_"^WardDR|"_obj.WardDR.%Id()
	.s ret=ret_"^WardDesc|"_obj.WardDR.WardDesc
	i obj.PostDR'="" d
	.s ret=ret_"^PostDR|"_obj.PostDR.%Id()
	.s ret=ret_"^PostDesc2|"_obj.PostDR.PostDesc
	.s ret=ret_"^PostType|"_obj.PostDR.PostType
	.s ret=ret_"^TypeDesc|"_$case(obj.PostDR.PostType,"P":"值班","H":"休假","S":"特殊",:"")
	.s ret=ret_"^HolidayTime|"_obj.PostDR.HolidayTime
	.s ret=ret_"^TimeDesc|"_$case(obj.PostDR.HolidayTime,"A":"全天","H":"半天","L":"哺乳期",:"")
	.s CategoryDesc=##class(INMSetComm).GetParamSubByCode("POSTTYPE",obj.PostDR.PostCategory,"SubDesc")
	.s ret=ret_"^CategoryDesc|"_CategoryDesc
	s ret=ret_"^PostClass|"_obj.PostClass
	s ret=ret_"^PostStTime1|"_obj.PostStTime1
	s ret=ret_"^PostEndTime1|"_obj.PostEndTime1
	s ret=ret_"^PostStTime2|"_obj.PostStTime2
	s ret=ret_"^PostEndTime2|"_obj.PostEndTime2
	s ret=ret_"^PostStTime3|"_obj.PostStTime3
	s ret=ret_"^PostEndTime3|"_obj.PostEndTime3
	s ret=ret_"^PostMinutes|"_obj.PostMinutes
	s ret=ret_"^PostDayMinutes|"_obj.PostDayMinutes
	s ret=ret_"^PostNextMinutes|"_obj.PostNextMinutes
	s ret=ret_"^PostRemark|"_obj.PostRemark
	s ret=ret_"^PostSort|"_obj.PostSort
	s ret=ret_"^PostCategory|"_obj.PostCategory
	i obj.PostCrtDate'="" s ret=ret_"^PostCrtDate|"_##class(web.INMHISComm).DateLogicalToHtml(obj.PostCrtDate)
	i obj.PostCrtTime'="" s ret=ret_"^PostCrtTime|"_$zt(obj.PostCrtTime,1)
	i obj.PostCrtUser'="" d
	.s ret=ret_"^PostCrtUser|"_obj.PostCrtUser.%Id()
	.s ret=ret_"^CrtUserName|"_obj.PostCrtUser.UserName
	s PostLevel=""
	i obj.PostDR'="" d
	.s postobj=##class(CF.DHCINM.DB.MgArgPost).%OpenId(obj.PostDR.%Id())
	.q:'$IsObject(postobj)
	.s PostLevel=postobj.PostLevel
	s ret=ret_"^PostLevel|"_PostLevel
	s PostFactor=obj.PostFactor
	s ret=ret_"^PostFactor|"_PostFactor
	s PostFontColor="",PostBgColor=""
	s:$IsObject(obj.PostDR) PostFontColor=obj.PostDR.PostFontColor,PostBgColor=obj.PostDR.PostBgColor
	s ret=ret_"^PostFontColor|"_PostFontColor
	s ret=ret_"^PostBgColor|"_PostBgColor
	q ret
}

/// Creator:
/// Createdate:
/// Description:删除病区班次信息
/// Input:
/// Output:
/// Other:
ClassMethod DeleteWardPost(id As %String) As %String
{
	q:id="" ""
	q:$d(^DHCINM.Arg.MgArrangeSubI("Post",id)) "已被使用不可删除"
	q:$d(^DHCINM.Arg.MgLeaveAppI("LeaveType",id)) "已被使用不可删除"
	s obj=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(id)
	s ward=obj.WardDR.%Id()
	s sc=obj.%DeleteId(id)
	d ..GetWardPostSort(ward)
	q $$$ISOK(sc)
}

/// Creator:
/// Createdate:
/// Description:移动病区班次
/// Input:
/// Output:
/// Other: w ##class(web.INMDBComm).SortWardPost("2","1")
ClassMethod SortWardPost(id1 As %String, id2 As %String) As %String
{
	;s ^tmpXbl("SortWardPost")=id1_"^"_id2
	q:(id1="")!(id2="") 0
	s obj1=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(id1)
	s obj2=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(id2)
	s order=obj1.PostSort
	s obj1.PostSort=obj2.PostSort
	s obj2.PostSort=order
	s sc1=obj1.%Save()
	s sc2=obj2.%Save()
	q $$$ISOK(sc1)&&$$$ISOK(sc2)
}

/// Creator:
/// Createdate:
/// Description:获取病区班次最大序号
/// Input:
/// Output:
/// Other: w ##class(web.INMDBComm).GetWardPostSort(1)
ClassMethod GetWardPostSort(warddr As %String) As %String
{
	q:warddr="" 0
	s order=1
	s sort="" f  s sort=$O(^CF.DHCINM.DB.MgArgWardPostI("WardSort",warddr,sort)) q:sort=""  d
	.s id="" f  s id=$O(^CF.DHCINM.DB.MgArgWardPostI("WardSort",warddr,sort,id)) q:id=""  d
	..s tmp(order)=id
	..s order=order+1
	s num="" f  s num=$O(tmp(num)) q:num=""  d
	.s id=tmp(num)
	.s obj=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(id)
	.s obj.PostSort=num
	.d obj.%Save()
	q order
}

/// Creator:
/// Createdate:
/// Description:获取病区班次信息列表
/// Input:
/// Output:
/// Other: d ##class(%ResultSet).RunQuery("web.INMDBComm","FindWardPostList","^46","")
Query FindWardPostList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardPostListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s postdr=$P(parr,"^",1)
	s warddr=$P(parr,"^",2)
	s type=$P(parr,"^",3)
	i (postdr="")&&(warddr="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	i postdr'="" d
	.s id="" f  s id=$O(^CF.DHCINM.DB.MgArgWardPostI("Post",postdr,id)) q:id=""  d
	..s obj=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(id)
	..q:(warddr'="")&&(obj.WardDR'="")&&(warddr'=obj.WardDR.%Id())
	..q:obj.PostDR.PostStatus'="Y"
	..s ret=..GetWardPost(id)
	..d OutWardPost
	e  d
	.s sort="" f  s sort=$O(^CF.DHCINM.DB.MgArgWardPostI("WardSort",warddr,sort)) q:sort=""  d
	..s id="" f  s id=$O(^CF.DHCINM.DB.MgArgWardPostI("WardSort",warddr,sort,id)) q:id=""  d
	...s obj=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(id)
	...q:obj.PostDR.PostStatus'="Y"
	...s posttype=obj.PostDR.PostType
	...q:(type'="")&&(type'=posttype)
	...s ret=..GetWardPost(id)
	...d OutWardPost
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWardPost
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardPostListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardPostListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardPostListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardPostListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:
/// Createdate:
/// Description:保存楼层信息
/// Input:
/// Output:
/// Other:
ClassMethod SaveFloor(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s flag=..IsExistFloor(parr)
	q:flag=1 "此代码已存在！"
	i $g(tmp("rw"))'="" d
	.s obj=##class(CF.DHCINM.DB.MgFloor).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(CF.DHCINM.DB.MgFloor).%New()
	s obj.FloorCode=$g(tmp("FloorCode"))
	s obj.FloorDesc=$g(tmp("FloorDesc"))
	s obj.FloorShort=$g(tmp("FloorShort"))
	s obj.FloorRemark=$g(tmp("FloorRemark"))
	s obj.FloorStatus=$g(tmp("FloorStatus"))
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:
/// Createdate:
/// Description:判断楼层code是否存在
/// Input:
/// Output:
/// Other:
ClassMethod IsExistFloor(parr As %String) As %String
{
	q:parr="" ""
	s flag=0
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	s FloorCode=$zcvt($tr($g(tmp("FloorCode"))," ",""),"U")
	s id=$o(^CF.DHCINM.DB.MgFloorI("Code"," "_FloorCode,""))
	i id="" d
	.s flag=0
	e  i id'="" d
	.i rw="" s flag=1
	.e  i rw'="" d
	..i rw'=id s flag=1
	..e  s flag=0
	q flag
}

/// Creator:
/// Createdate:
/// Description:获取楼层信息
/// Input:
/// Output:
/// Other:
ClassMethod GetFloor(id As %String) As %String
{
	q:id="" ""
	s obj=##class(CF.DHCINM.DB.MgFloor).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^FloorCode|"_obj.FloorCode
	s ret=ret_"^FloorDesc|"_obj.FloorDesc
	s ret=ret_"^FloorShort|"_obj.FloorShort
	s ret=ret_"^FloorRemark|"_obj.FloorRemark
	s ret=ret_"^FloorStatus|"_obj.FloorStatus
	s ret=ret_"^StatusDesc|"_$case(obj.FloorStatus,"Y":"启用","N":"停用",:"")
	s wards="",warddescs=""
	f i=1:1:obj.FloorWards.Count() d
	.s ward=obj.FloorWards.GetAt(i)
	.q:ward=""
	.s wardobj=##class(CF.DHCINM.DB.MgWard).%OpenId(ward)
	.q:'$IsObject(wardobj)
	.i wards="" s wards=ward,warddescs=wardobj.WardDesc
	.e  s wards=wards_","_ward,warddescs=warddescs_","_wardobj.WardDesc
	s ret=ret_"^FloorWards|"_wards
	s ret=ret_"^WardDescs|"_warddescs
	q ret
}

/// Creator:
/// Createdate:
/// Description:获取楼层病区信息
/// Input:
/// Output:
/// Other:
ClassMethod GetFloorWards(floors As %String) As %String
{
	q:floors="" ""
	s ret=""
	f i=1:1:$L(floors,",") d
	.s id=$P(floors,",",i)
	.q:id=""
	.s obj=##class(CF.DHCINM.DB.MgFloor).%OpenId(id)
	.f j=1:1:obj.FloorWards.Count() d
	..s ward=obj.FloorWards.GetAt(j)
	..q:(ward="")||($g(tmp(ward))'="")
	..s wardobj=##class(CF.DHCINM.DB.MgWard).%OpenId(ward)
	..s tmp(ward)=wardobj.WardDesc
	..i ret="" s ret=ward_"|"_wardobj.WardDesc
	..e  s ret=ret_"^"_ward_"|"_wardobj.WardDesc
	q ret
}

/// Creator:
/// Createdate:
/// Description:获取楼层信息列表
/// Input:
/// Output:
/// Other: d ##class(%ResultSet).RunQuery("web.INMDBComm","FindFloorList","","")
Query FindFloorList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindFloorListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s id="" f  s id=$O(^CF.DHCINM.DB.MgFloorD(id)) q:id=""  d
	.s obj=##class(CF.DHCINM.DB.MgFloor).%OpenId(id)
	.s code=obj.FloorCode
	.s desc=obj.FloorDesc
	.q:(input'="")&&($zcvt(code_desc,"U")'[$zcvt(input,"U"))
	.s ret=..GetFloor(id)
	.d OutFloor
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutFloor
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindFloorListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindFloorListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindFloorListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindFloorListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:
/// Createdate:
/// Description:保存楼层关联病区
/// Input:
/// Output:
/// Other:
ClassMethod SaveFloorWard(id As %String, wards As %String) As %String
{
	q:id="" 0
	s obj=##class(CF.DHCINM.DB.MgFloor).%OpenId(id)
	d obj.FloorWards.Clear()
	f i=1:1:$L(wards,",") d
	.s ward=$P(wards,",",i)
	.q:ward=""
	.d obj.FloorWards.Insert(ward)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:
/// Createdate:
/// Description:保存科室所辖病区
/// Input:
/// Output:
/// Other:
ClassMethod SaveLocWard(locs As %String, wards As %String) As %String
{
	;q:(locid="")!(wards="") 0
	q:(locs="")!(wards="") 0
	s insertId=locs,finds=wards
	s:$L(locs,",")>1 finds=locs,insertId=wards
	f i=1:1:$L(finds,",") d
	.s id=$p(finds,",",i)
	.q:id=""
	.s obj=##class(CF.DHCINM.DB.MgWardLocUnit).%New()
	.i $L(locs,",")>1 d
	..s obj.UnitLocDR=id
	..s obj.UnitWardDR=insertId
	.e  d
	..s obj.UnitLocDR=insertId
	..s obj.UnitWardDR=id
	.s obj.UnitDesc=""
	.s sc=obj.%Save()
	
	q 1
}

/// Creator:
/// Createdate:
/// Description:删除科室所辖病区
/// Input:
/// Output:
/// Other:
ClassMethod DeleteLocWard(parr As %String) As %String
{
	;q:(locid="")!(wards="") 0
	q:(parr="") 0
	f i=1:1:$l(parr,",") d
	.s obj=##class(CF.DHCINM.DB.MgWardLocUnit).%OpenId($p(parr,",",i))
	.q:'$IsObject(obj)
	.s sc=obj.%DeleteId(obj.%Id())
	q 1
}

/// Creator:
/// Createdate:
/// Description:获取科室所辖病区id
/// Input:
/// Output:
/// Other:
ClassMethod GetLocWard(locid As %String) As %String
{
	q:locid="" 0
	s ret=""
	s id="" f  s id=$O(^CF.DHCINM.DB.MgWardI("Loc",locid,id)) q:id=""  d
	.i ret="" s ret=id
	.e  s ret=ret_","_id
	q ret
}

/// Creator:
/// Createdate:
/// Description:获取科室病区关联列表
/// Input:
/// Output:
/// Other:
Query FindWardLockUnitList(locid As %String = "", wardid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardLockUnitListExecute(ByRef qHandle As %Binary, locid As %String = "", wardid As %String = "") As %Status
{
	s ^TMPLL("WardLockUnitList")=locid_"%"_wardid
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	i (locid="")&&(wardid=""){
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK
	}
	s typ="Loc",findId=locid
	s:wardid'="" typ="Ward",findId=wardid
	s nextId=""  f  s nextId=$O(^CF.DHCINM.DB.MgWardLocUnitI(typ,findId,nextId)) q:nextId=""  d
	.s id=""  f  s id=$O(^CF.DHCINM.DB.MgWardLocUnitI(typ,findId,nextId,id)) q:id=""  d
	..s obj=##class(CF.DHCINM.DB.MgWardLocUnit).%OpenId(id)
	..s locObj=##class(CF.DHCINM.DB.MgWardLoc).%OpenId(obj.UnitLocDR)
	..s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(obj.UnitWardDR)
	..q:('$IsObject(locObj))||('$IsObject(wardObj))
	..s ret="wardDesc|"_wardObj.WardDesc_"^locDesc|"_locObj.LocDesc_"^wardDR|"_obj.UnitWardDR_"^locDR|"_obj.UnitLocDR_"^rw|"_id
	..d OutWardLockUnitData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWardLockUnitData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardLockUnitListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardLockUnitListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardLockUnitListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardLockUnitListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:
/// Createdate:
/// Description:获取片区所辖科室id
/// Input:
/// Output:
/// Other:
ClassMethod GetAreaLoc(areaid As %String) As %String
{
	q:areaid="" 0
	s ret=""
	s id="" f  s id=$O(^CF.DHCINM.DB.MgWardLocI("Area",areaid,id)) q:id=""  d
	.i ret="" s ret=id
	.e  s ret=ret_","_id
	q ret
}

/// Creator:
/// Createdate:
/// Description:保存片区所辖科室
/// Input:
/// Output:
/// Other:
ClassMethod SaveAreaLoc(areaid As %String, locs As %String) As %String
{
	;q:(areaid="")!(locs="") 0
	q:areaid="" 0
	s areaObj=##class(CF.DHCINM.DB.MgWardArea).%OpenId(areaid)
	
	s id="" f  s id=$O(^CF.DHCINM.DB.MgWardLocI("Area",areaid,id)) q:id=""  d
	.q:(","_locs_",")[(","_id_",")
	.s obj=##class(CF.DHCINM.DB.MgWardLoc).%OpenId(id)
	.s obj.LocAreaDR=""
	.d obj.%Save()
	f i=1:1:$L(locs,",") d
	.s loc=$P(locs,",",i)
	.q:loc=""
	.s obj=##class(CF.DHCINM.DB.MgWardLoc).%OpenId(loc)
	.s obj.LocAreaDR=areaObj
	.d obj.%Save()
	q 1
}

/// Creator:
/// Createdate:
/// Description:获取公共代码子表信息的sort信息
/// Input:
/// Output:
/// Other:
ClassMethod GetSortSetCode(RowID As %String) As %String
{
	q:RowID="" "0"
	s sort=0
	s obj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(RowID)
	q:'$IsObject(obj) "0"
	s sort=obj.SubSort
	q sort
}

/// Creator:
/// Createdate:
/// Description:移动全局班次位置
/// Input:
/// Output:
/// Other:
ClassMethod MovePostSort(rowid As %String, type As %String) As %String
{
	q:rowid="" ""
	s ret=0
	s obj=##class(CF.DHCINM.DB.MgArgPost).%OpenId(rowid)
	q:'$IsObject(obj) ""
	s sort=obj.PostSort
	i type="up"
	{
		i sort="1" s ret=0
		e  d
		.s ret=sort-1
		.s obj.PostSort=sort-1
		.s row=$O(^CF.DHCINM.DB.MgArgPostI("Sort",sort-1,""))
		.s bobj=##class(CF.DHCINM.DB.MgArgPost).%OpenId(row)
		.s bobj.PostSort=sort
		.d bobj.%Save()
		.d obj.%Save()
	}
	elseif type="down"
	{
		s maxSort=$O(^CF.DHCINM.DB.MgArgPostI("Sort",""),-1)
		i sort=maxSort s ret=-1
		e  d
		.s ret=sort+1
		.s obj.PostSort=sort+1
		.s row=$O(^CF.DHCINM.DB.MgArgPostI("Sort",sort+1,""))
		.s bobj=##class(CF.DHCINM.DB.MgArgPost).%OpenId(row)
		.s bobj.PostSort=sort
		.d bobj.%Save()
		.d obj.%Save()
	} 
	q ret
}

/// Creator:
/// Createdate:
/// Description:获取全局岗位代码序号
/// Input:
/// Output:
/// Other:
ClassMethod ComArgPostSort() As %String
{
	s n=1
	s sort="" f  s sort=$O(^CF.DHCINM.DB.MgArgPostI("Sort",sort)) q:sort=""  d
	.s rw="" f  s rw=$O(^CF.DHCINM.DB.MgArgPostI("Sort",sort,rw)) q:rw=""  d
	..s obj=##class(CF.DHCINM.DB.MgArgPost).%OpenId(rw)
	..i obj.PostSort'="" s n=obj.PostSort+1
	q n
}

/// Creator:
/// Createdate:
/// Description:关联排班类型
/// Input:
/// Output:
/// Other:
ClassMethod SaveWardArgPost(parr As %String, ward As %String, user As %String) As %String
{
	q:parr="" ""
	s len=$L(parr,"^")
	f i=1:1:len
	{
		s itm=$p(parr,"^",i)
		i itm="" continue
		s ArgObj=##class(CF.DHCINM.DB.MgArgPost).%OpenId(itm)
		q:'$IsObject(ArgObj)
		s RowID=""
		//粤北人民可以可引入多个，注释下一行
		s RowID=$O(^CF.DHCINM.DB.MgArgWardPostI("WardPost",ward,itm,""))
		i RowID="" s WardArgObj=##class(CF.DHCINM.DB.MgArgWardPost).%New()
		e  s WardArgObj=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(RowID)
		s WardArgObj.PostDesc=ArgObj.PostDesc
		s WardArgObj.WardDR=##class(CF.DHCINM.DB.MgWard).%OpenId(ward)
		s WardArgObj.PostDR=##class(CF.DHCINM.DB.MgArgPost).%OpenId(itm)
		s WardArgObj.PostStTime1=ArgObj.PostStTime1
		s WardArgObj.PostEndTime1=ArgObj.PostEndTime1
		s WardArgObj.PostStTime2=ArgObj.PostStTime2
		s WardArgObj.PostEndTime2=ArgObj.PostEndTime2
		s WardArgObj.PostStTime3=ArgObj.PostStTime3
		s WardArgObj.PostEndTime3=ArgObj.PostEndTime3
		s WardArgObj.PostMinutes=ArgObj.PostMinutes
		s WardArgObj.PostDayMinutes=ArgObj.PostDayMinutes
		s WardArgObj.PostNextMinutes=ArgObj.PostNextMinutes
		i WardArgObj.PostSort="" s WardArgObj.PostSort=..GetWardArgPostSort(ward)
		s WardArgObj.PostCrtDate=+$H
		s WardArgObj.PostCrtTime=$p($h,",",2)
		s WardArgObj.PostCategory=ArgObj.PostCategory
		i user'=0 s WardArgObj.PostCrtUser=##class(CF.DHCINM.DB.MgUser).%OpenId(user)
		s WardArgObj.PostRemark=ArgObj.PostRemark
		s sc=WardArgObj.%Save()
		
	}
	q 1
}

/// Creator:
/// Createdate:
/// Description:获取病区岗位的顺序号
/// Input:
/// Output:
/// Other:
ClassMethod GetWardArgPostSort(ward As %String) As %String
{
	s flag=1
	s sort=$O(^CF.DHCINM.DB.MgArgWardPostI("WardSort",ward,""),-1)
	i sort="" s flag=1
	e  s flag=sort+1
	q flag
}

/// Creator:
/// Createdate:
/// Description:获取病区的顺序号
/// Input:
/// Output:
/// Other:
ClassMethod GetWardSort() As %String
{
	s n=1
#;	s sort="" f  s sort=$O(^CF.DHCINM.DB.MgWardI("Sort",sort)) q:sort=""  d
#;	.s rw="" f  s rw=$O(^CF.DHCINM.DB.MgWardI("Sort",sort,rw)) q:rw=""  d
#;	..s obj=##class(CF.DHCINM.DB.MgWard).%OpenId(rw)
#;	..i obj.WardSort'="" s n=n+1
	s last=$O(^CF.DHCINM.DB.MgWardI("Sort",""),-1)
	s last=last+1
	q last

	q n
}

/// Creator:
/// Createdate:
/// Description:移动病区班次位置
/// Input:
/// Output:
/// Other:
ClassMethod MoveWardSort(rowid As %String, type As %String) As %String
{
	q:rowid="" "入参为空,请刷新重试"
	s ret=1
	s obj=##class(CF.DHCINM.DB.MgWard).%OpenId(rowid)
	s sort=obj.WardSort
	i type="up"
	{
		i sort="1" s ret="已经置顶了"
		e  d
		.s obj.WardSort=sort-1
		.s row=$O(^CF.DHCINM.DB.MgWardI("Sort",sort-1,""))
		.s bobj=##class(CF.DHCINM.DB.MgWard).%OpenId(row)
		.s bobj.WardSort=sort
		.d bobj.%Save()
		.d obj.%Save()
	}
	elseif type="down"
	{
		s maxSort=$O(^CF.DHCINM.DB.MgWardI("Sort",""),-1)
		i sort=maxSort s ret="已经置低了"
		e  d
		.s obj.WardSort=sort+1
		.s row=$O(^CF.DHCINM.DB.MgWardI("Sort",sort+1,""))
		.s bobj=##class(CF.DHCINM.DB.MgWard).%OpenId(row)
		.s bobj.WardSort=sort
		.d bobj.%Save()
		.d obj.%Save()
	} 
	q ret
}

/// Creator:
/// Createdate:
/// Description:通过更新全局某个时间【南通中医，白班、夜班更新时间】批量更新病区排班时间
/// Input:
/// Output:
/// Other:
ClassMethod UpdatePostTime(parr) As %String
{
	q:parr="" 0
	s fromTime=$P(parr,"^")
	s toTime=$P(parr,"^",2)
	s flag=1
	TS
	s id="" f  s id=$O(^CF.DHCINM.DB.MgArgPostD(id)) q:(id="")||(flag'=1)  d
	.s obj=##class(CF.DHCINM.DB.MgArgPost).%OpenId(id)
	.q:'$IsObject(obj)
	.q:(obj.PostCategory'="W")&&(obj.PostCategory'="N")
	.i obj.PostStTime1=fromTime  s obj.PostStTime1=toTime
	.e  i obj.PostStTime2=fromTime  s obj.PostStTime2=toTime
	.e  i obj.PostStTime3=fromTime  s obj.PostStTime3=toTime
	.e  i obj.PostEndTime1=fromTime  s obj.PostEndTime1=toTime
	.e  i obj.PostEndTime2=fromTime  s obj.PostEndTime2=toTime
	.e  i obj.PostEndTime3=fromTime  s obj.PostEndTime3=toTime
	.s minutes=..caculateMinute(obj.PostStTime1,obj.PostEndTime1,obj.PostStTime2,obj.PostEndTime2,obj.PostStTime3,obj.PostEndTime3)
	.s obj.PostMinutes=$P(minutes,"^")
	.s obj.PostDayMinutes=$P(minutes,"^",2)
	.s obj.PostNextMinutes=$P(minutes,"^",3)
	.s flag=flag&&obj.%Save()
	.q:flag'=1
	.s subid=""  f  s subid=$O(^CF.DHCINM.DB.MgArgWardPostI("Post",id,subid)) q:(subid="")||(flag'=1)  d
	..s wardObj=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(subid)
	..q:'$IsObject(wardObj)
	..i wardObj.PostStTime1=fromTime  s wardObj.PostStTime1=toTime
	..e  i wardObj.PostStTime2=fromTime  s wardObj.PostStTime2=toTime
	..e  i wardObj.PostStTime3=fromTime  s wardObj.PostStTime3=toTime
	..e  i wardObj.PostEndTime1=fromTime  s wardObj.PostEndTime1=toTime
	..e  i wardObj.PostEndTime2=fromTime  s wardObj.PostEndTime2=toTime
	..e  i wardObj.PostEndTime3=fromTime  s wardObj.PostEndTime3=toTime
	..s wardminutes=..caculateMinute(wardObj.PostStTime1,wardObj.PostEndTime1,wardObj.PostStTime2,wardObj.PostEndTime2,wardObj.PostStTime3,wardObj.PostEndTime3)
	..s wardObj.PostMinutes=$P(wardminutes,"^")
	..s wardObj.PostDayMinutes=$P(wardminutes,"^",2)
	..s wardObj.PostNextMinutes=$P(wardminutes,"^",3)
	..s flag=flag&&wardObj.%Save()
	if flag=1{
		TC
		q 1	
	}else{
		TRO
		q 0	
	}
}

/// Creator:
/// Createdate:
/// Description:计算小时数
/// Input:
/// Output:
/// Other:
ClassMethod caculateMinute(sttime1, endtime1, sttime2, endtime2, sttime3, endtime3) As %String
{
      s time=0,daytime=0,nexttime=0,daylength=24*60
      if (sttime1'="")&&(endtime1'="") {
        if (sttime1["次日") {
          s sttime1=(24+$E($p(sttime1,":"),3,4))*60+$p(sttime1,":",1)
        }else{
          s sttime1=($p(sttime1,":"))*60+$p(sttime1,":",1)
        }
        if (endtime1["次日") {
          s endtime1=(24+$E($p(endtime1,":"),3,4))*60+$p(endtime1,":",1)
        }else{
          s endtime1=($p(endtime1,":"))*60+$p(endtime1,":",1)
        }
        s time=time+endtime1-sttime1
        if (sttime1<daylength){
          if (endtime1>daylength){
            s daytime=daytime+daylength-sttime1
          }else{
            s daytime=daytime+endtime1-sttime1
          }
        }
        if (endtime1>daylength){
          if (sttime1<daylength){
            s nexttime=nexttime+(endtime1-daylength)
          }
          else{
            s nexttime=nexttime+(endtime1-sttime1)
          }
        }
      }
      if (sttime2'="")&&(endtime2'="") {
        if (sttime2["次日") {
          s sttime2=(24+$E($p(sttime2,":"),3,4))*60+$p(sttime2,":",1)
        }else{
          s sttime2=($p(sttime2,":"))*60+$p(sttime2,":",1)
        }
        if (endtime2["次日") {
          s endtime2=(24+$E($p(endtime2,":"),3,4))*60+$p(endtime2,":",1)
        }else{
          s endtime2=($p(endtime2,":"))*60+$p(endtime2,":",1)
        }
        s time=time+endtime2-sttime2
        if (sttime2<daylength){
          if (endtime2>daylength){
            s daytime=daytime+daylength-sttime2
          }else{
            s daytime=daytime+endtime2-sttime2
          }
        }
        if (endtime2>daylength){
          if (sttime2<daylength){
            s nexttime=nexttime+(endtime2-daylength)
          }
          else{
            s nexttime=nexttime+(endtime2-sttime2)
          }
        }
      }
      if (sttime3'="")&&(endtime3'="") {
        if (sttime3["次日") {
          s sttime3=(24+$E($p(sttime3,":"),3,4))*60+$p(sttime3,":",1)
        }else{
          s sttime3=($p(sttime3,":"))*60+$p(sttime3,":",1)
        }
        if (endtime3["次日") {
          s endtime3=(24+$E($p(endtime3,":"),3,4))*60+$p(endtime3,":",1)
        }else{
          s endtime3=($p(endtime3,":"))*60+$p(endtime3,":",1)
        }
        s time=time+endtime3-sttime3
        if (sttime3<daylength){
          if (endtime3>daylength){
            s daytime=daytime+daylength-sttime3
          }else{
            s daytime=daytime+endtime3-sttime3
          }
        }
        if (endtime3>daylength){
          if (sttime3<daylength){
            s nexttime=nexttime+(endtime3-daylength)
          }
          else{
            s nexttime=nexttime+(endtime3-sttime3)
          }
        }
      }
      s PostMinutes=(time\60)_"时"_(time#60)_"分"
      s PostDayMinutes=(daytime\60)_"时"_(daytime#60)_"分"
      s PostNextMinutes=(nexttime\60)_"时"_(nexttime#60)_"分"
      q PostDayMinutes_"^"_PostDayMinutes_"^"_PostNextMinutes
}

/// Creator:
/// Createdate:
/// Description:根据病区id获取关联科室名称
/// Input:
/// Output:
/// Other:
ClassMethod GetWardRelateLocDesc(id) As %String
{
	q:id="" ""
	s retDesc=""
	s locid="" f  s locid=$O(^CF.DHCINM.DB.MgWardLocUnitI("Ward",id,locid)) q:locid=""  d
	.s locObj=##class(CF.DHCINM.DB.MgWardLoc).%OpenId(locid)
	.q:'$IsObject(locObj)
	.i retDesc="" s retDesc=locObj.LocDesc
	.e  s retDesc=retDesc_","_locObj.LocDesc
	q retDesc
}

/// Creator:
/// Createdate:
/// Description:保存节假日信息
/// Input:
/// Output:
/// Other:
ClassMethod SaveHolidaySet(parr As %String) As %String
{
	s tmp=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(CF.DHCINM.DB.MgHolidaySet).%New()
	e  s obj=##class(CF.DHCINM.DB.MgHolidaySet).%OpenId(id)
	s obj.HolidayYear=$g(tmp("HolidayYear"))
	i $g(tmp("HolidayCode"))'="" s obj.HolidayID=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId($g(tmp("HolidayCode")))
	e  s obj.HolidayCode=""
	s obj.HolidayDate=$g(tmp("HolidayDate"))
	s sc=obj.%Save()
	
	q $$$ISOK(sc)
}

/// Creator:
/// Createdate:
/// Description:查询节假日信息列表
/// Input:
/// Output:
/// Other: d ##class(%ResultSet).RunQuery("web.INMDBComm","FindHolidayList","")
Query FindHolidayList(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindHolidayListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s year="" f  s year=$O(^CF.DHCINM.DB.MgHolidaySetI("code",year)) q:year=""  d
	.q:((parr'="")&&(year'=parr))
	.s code="" f  s code=$O(^CF.DHCINM.DB.MgHolidaySetI("code",year,code)) q:code=""  d
	..s rowid="" f  s rowid=$O(^CF.DHCINM.DB.MgHolidaySetI("code",year,code,rowid)) q:rowid=""  d
	...s obj=##class(CF.DHCINM.DB.MgHolidaySet).%OpenId(rowid)
	...s holidayyear=obj.HolidayYear
	...s holidaycode=obj.HolidayID.SubDesc
	...s holidaydate=$replace(obj.HolidayDate,",","--")
	...s ret="holidayyear|"_holidayyear_"^holidaycode|"_holidaycode_"^holidaydate|"_holidaydate_"^rowid|"_rowid
	...d OutHolidayList
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutHolidayList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHolidayListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHolidayListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindHolidayListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHolidayListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:
/// Createdate:
/// Description:查询节假日信息
/// Input:
/// Output:
/// Other:
ClassMethod GetHolidayData(id As %String) As %String
{
	q:id="" ""
	s ret=""
	s obj=##class(CF.DHCINM.DB.MgHolidaySet).%OpenId(id)
	q:'$IsObject(obj) ""
	s HolidayYear=obj.HolidayYear
	i obj.HolidayID'="" s HolidayID=obj.HolidayID.%Id()
	e  s HolidayID=""
	s HolidayDate=obj.HolidayDate
	s ret="HolidayYear|"_HolidayYear_"^HolidayCode|"_HolidayID_"^HolidayDate|"_HolidayDate_"^RowID|"_id
	q ret
}

/// Creator:
/// Createdate:
/// Description:判断节假日信息code是否存在
/// Input:
/// Output:
/// Other:
ClassMethod IsExistCode(parr As %String) As %String
{
	s ^TMP("existcode")=parr
	s tmp=""
	s flag=1
	//HolidayYear|2018^HolidayCode|15||3^HolidayDate|2018-04-05,2018-04-07^RowID|1
	;s ^CF.DHCINM.DB.MgHolidaySetI("code",2018,"15||3",1)
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s rowid=""  f  s rowid=$O(^CF.DHCINM.DB.MgHolidaySetI("code",$g(tmp("HolidayYear")),$g(tmp("HolidayCode")),rowid)) q:rowid=""  d
	.i id'="" d
	..i rowid=id  s flag=0
	.e  d
	..s obj=##class(CF.DHCINM.DB.MgHolidaySet).%OpenId(rowid)
	..i obj.HolidayID.SubDesc="班" s flag=0
	s rowid=$O(^CF.DHCINM.DB.MgHolidaySetI("code",$g(tmp("HolidayYear")),$g(tmp("HolidayCode")),""))
	i rowid="" s flag=0
	q flag
}

/// Creator:lulin
/// Createdate:2020-06-01
/// Description:判断用户工号是否已存在
/// Input:
/// Output:
/// Other:1:已存在。0:不存在
ClassMethod IsExistUserCode(code As %String = "", id As %String = "") As %String
{
	s codeId=$O(^CF.DHCINM.DB.MgUserI("UserID"," "_$zcvt($tr(code," ",""),"U"),""))
	s retFlag=0
	s:((codeId'="")&&(id'=codeId)) retFlag=1
	q retFlag
}

/// Creator:lulin
/// Createdate:2020-06-01
/// Description:判断HISId是否已存在对应
/// Input:
/// Output:
/// Other:
ClassMethod IsExistSSUser(SSUserId, id) As %String
{
	s codeId=$O(^CF.DHCINM.DB.MgUserI("SSUser"," "_$zcvt($tr(SSUserId," ",""),"U"),""))
	s retFlag=0
	s:((codeId'="")&&(id'=codeId)) retFlag=1
	q retFlag
}

/// Creator:lulin
/// Createdate:2020-06-01
/// Description:保存用户信息
/// Input:
/// Output:
/// Other:
ClassMethod SaveUser(parr As %String) As %String
{
	q:parr="" "入参为空"
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	s codeIsRepeat=..IsExistUserCode($g(tmp("UserID")),rw)
	q:codeIsRepeat=1 "此用户工号已存在"
	s SSUserErrorRet=""
	s SSUserCode=$g(tmp("SSUserCode"))
	s SSUserId=""
	i SSUserCode'="" d
	.s SSUserId=##class(web.INMHISComm).GetUserIdByCode(SSUserCode)
	.s:SSUserId="" SSUserErrorRet="无此HIS用户"
	.i SSUserId'="" d
	..s SSUserRepeat=..IsExistSSUser(SSUserId,rw)
	..s:SSUserRepeat=1 SSUserErrorRet="此用户HIS工号已存在"
	q:SSUserErrorRet'="" SSUserErrorRet
	s tmp("UserDR")=SSUserId
	i rw="" d
	.s obj=##class(CF.DHCINM.DB.MgUser).%New()
	.s obj.Password="UUUUUU&&&&&&"
	e  d
	.s obj=##class(CF.DHCINM.DB.MgUser).%OpenId(rw)
	s className="CF.DHCINM.DB.MgUser"
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.s ptype=^oddCOM(className,"a",p,"P","XSDTYPE")
	.q:'$d(tmp(p))
	.s value=$zcvt($tr(tmp(p)," ",""),"U")
	.i ((ptype="date")&&(value'="")) d
	..s value=$zdh(value,3)
	.s $ZOBJPROPERTY(obj,p)=value
	TS
	s sc=$$$ISOK(obj.%Save())
	if 'sc{
		TRO
		q "保存用户信息失败"	
	}
	s roleFlag=..SaveUserRole($g(tmp("UserRole")),obj.%Id())
	if roleFlag{
		TC
		q 1	
	}else{
		TRO
		q "保存角色信息失败"
	}
}

/// Creator:lulin
/// Createdate:2020-06-01
/// Description:保存用户角色信息
/// Input:
/// Output:
/// Other:
ClassMethod SaveUserRole(roles, userId) As %String
{
	;可以考虑增加开始日期、结束日期。
	s tmpRole=""
	f i=1:1:$L(roles,",") d
	.s role=$P(roles,",",i)
	.q:role=""
	.s tmpRole(role)=1
	s nowDate=+$H
	TS
	s flag=1
	s rw="" f  s rw=$O(^CF.DHCINM.DB.MgUserRoleD(userId,rw)) q:((rw="")||(flag'=1))  d
	.s obj=##class(CF.DHCINM.DB.MgUserRole).%OpenId(userId_"||"_rw)
	.q:'$IsObject(obj)
	.s startDate=obj.RoleStDate
	.s endDate=obj.RoleEndDate
	.q:(endDate'="")&&(endDate<=nowDate)
	.s role=obj.RoleID
	.i $g(tmpRole(role))'=1 d
	..s obj.RoleEndDate=+$H
	..s flag=((flag)&&($$$ISOK(obj.%Save())))
	.e  d
	..s tmpRole(role)=0
	if flag'=1 {
		TRO	
		q 0
	}
	s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(userId)
	s role="" f  s role=$O(tmpRole(role)) q:((role="")||(flag'=1))  d
	.q:$G(tmpRole(role))'=1
	.s obj=##class(CF.DHCINM.DB.MgUserRole).%New()
	.s obj.Parref=userObj
	.s obj.RoleID=role
	.s obj.RoleStDate=+$H
	.s flag=((flag)&&($$$ISOK(obj.%Save())))
	if flag=1 {
		TC	
		q 1
	}else{
		TRO	
		q 0
	}
}

/// Creator:lulin
/// Createdate:2020-06-01
/// Description:获取用户信息
/// Input:
/// Output:
/// Other:
ClassMethod GetUser(rw) As %String
{
	s obj=##class(CF.DHCINM.DB.MgUser).%OpenId(rw)
	s className="CF.DHCINM.DB.MgUser"
	s nowDate=+$H
	s ret="rw|"_rw
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.s key=p
	.s value=$tr($ZOBJPROPERTY(obj,p)," ","")
	.i p["Code" s tmp(p)=$zcvt($tr(value," ",""),"U")
	.s ptype=^oddCOM(className,"a",p,"P","XSDTYPE")
	.i ((ptype="date")&&(value'="")) d
	..s value=##class(web.INMHISComm).DateLogicalToHtml(value)
	.i ((p="UserDR")&&(value'="")) d
	..s value=$P($G(^SSU("SSUSR",value)),"^",1)
	..s key="SSUserCode"
	.s ret=ret_"^"_key_"|"_value
	s perid=obj.PerDR,PerWardDesc="",PerName=""
	i perid'="" d
	.s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(perid)
	.i $IsObject(perObj) d
	..s PerName=perObj.PerName,PerWard=perObj.PerDepDR
	..i PerWard'="" d
	...s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(PerWard)
	...s:$IsObject(wardObj) PerWardDesc=wardObj.WardDesc
	s ret=ret_"^PerWardDesc|"_PerWardDesc_"^PerName|"_PerName
	s SSUerName=""
	i obj.UserDR'="" d
	.s SSUerName=$P($G(^SSU("SSUSR",obj.UserDR)),"^",2)
	s ret=ret_"^SSUerName|"_SSUerName
	s UserRole="",UserRoleDesc=""
	s userRoleId="" f  s userRoleId=$O(^CF.DHCINM.DB.MgUserRoleD(rw,userRoleId)) q:userRoleId=""  d
	.s userRoleObj=##class(CF.DHCINM.DB.MgUserRole).%OpenId(rw_"||"_userRoleId)
	.q:'$IsObject(userRoleObj)
	.s RoleStDate=userRoleObj.RoleStDate
	.s RoleEndDate=userRoleObj.RoleEndDate
	.q:((RoleStDate'="")&&(RoleStDate>nowDate))
	.q:((RoleEndDate'="")&&(RoleEndDate<=nowDate))
	.s RoleID=userRoleObj.RoleID
	.q:RoleID=""
	.s roleObj=##class(CT.DHCINM.Set.MgRoles).%OpenId(RoleID)
	.q:'$IsObject(roleObj)
	.s roleDesc=roleObj.RoleDesc
	.i UserRole="" s UserRole=RoleID,UserRoleDesc=roleDesc
	.e  d
	..s UserRole=UserRole_","_RoleID,UserRoleDesc=UserRoleDesc_","_roleDesc
	s ret=ret_"^UserRole|"_UserRole_"^UserRoleDesc|"_UserRoleDesc
	q ret
}

/// Creator:
/// Createdate:
/// Description:查询用户信息列表
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMDBComm","FindUserList","")
Query FindUserList(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindUserListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s id="" f  s id=$O(^CF.DHCINM.DB.MgUserD(id)) q:id=""  d
	.s UserID=$LG(^CF.DHCINM.DB.MgUserD(id),3)
	.s UserName=$LG(^CF.DHCINM.DB.MgUserD(id),2)
	.s shellName=##class(web.INMVueComm).ToChineseSpell(UserName)
	.q:((UserID_UserName_shellName)'[parr)
	.s ret=..GetUser(id)
	.d OutPutData
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindUserListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindUserListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindUserListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindUserListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:
/// Createdate:
/// Description:保存数据时获取序号
/// Input:
/// Output:
/// Other:
ClassMethod GetTeaTheorySort(par) As %String
{
	s sort=0
	s id="" f  s id=$O(^CF.DHCINM.DB.TeaTheoryI("par"," "_par,id)) q:id=""  d
	.s obj=##class(CF.DHCINM.DB.TeaTheory).%OpenId(id)
	.q:'$IsObject(obj)
	.s brotherSort=obj.TheorySort
	.s brotherSort=$P(brotherSort,".",$l(brotherSort,"."))
	.i brotherSort>sort d
	..s sort=brotherSort
	s sort=sort+1
	q sort
}

/// 获取理论考核根节点病区
ClassMethod GetTheoryWard(id) As %String
{
	s ward=""
	q:id="" ""
	s parID=$lg($g(^CF.DHCINM.DB.TeaTheoryD(id)),3)
	i ((parID="")||(parID=0)) {
		q $lg($g(^CF.DHCINM.DB.TeaTheoryD(id)),10)
	}else{
		q ..GetTheoryWard(parID)
	}
}

/// 
/// Createdate:
/// Description:校验时候有修改、新增权限
/// Input:
/// Output:
/// Other:
ClassMethod EditFlag(id As %String = "", loginID As %String = "") As %String
{
	q:((id="")||(id=0)) 1
	k tmpWard
	s tmpWard=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(loginID,.tmpWard)
	q:isAll=1 1
	s ward=..GetTheoryWard(id)
	i ((ward="")||('$d(tmpWard(ward)))){
		q 0	
	}else{
		q 1	
	}
}

/// Creator:
/// Createdate:
/// Description:保存理论项目维护父表
/// Input:
/// Output:
/// Other:
ClassMethod SaveTeachTheory(parr As %String) As %String
{
	q:parr="" "入参为空"
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	s Creator=$g(tmp("Creator"))
	k tmpWard
	s tmpWard=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(Creator,.tmpWard)
	s TheoryParDR=$g(tmp("TheoryParDR")) 
	s Ward=$g(tmp("Ward")) 
	q:((isAll'=1)&&(TheoryParDR=0)&&(Ward="")) "请选择所管病区类别" ;非护理部新增、维护必须选择病区
	s errRet="",fatherSort=""
	i ((TheoryParDR'=0)&&(rw="")) d ;非第一层节点,新增校验时候时所管病区
	.s TheoryParObj=##class(CF.DHCINM.DB.TeaTheory).%OpenId(TheoryParDR)
	.s:'$IsObject(TheoryParObj) errRet="未找到父节点数据请刷新重试"
	.i $IsObject(TheoryParObj) d
	..s fatherSort=TheoryParObj.TheorySort
	..;根节点是否为所辖病区。
	..s dataWard=..GetTheoryWard(TheoryParDR)
	..i isAll'=1  d
	...s:((dataWard="")||('$d(tmpWard(dataWard)))) errRet="非所管病区类别,不可新增"
	q:errRet'="" errRet
	i rw="" d
	.s obj=##class(CF.DHCINM.DB.TeaTheory).%New()
	.s obj.TheoryParDR=TheoryParDR ;TheoryParDR
	.s sort=1
	.s sort=..GetTeaTheorySort(TheoryParDR)
	.s:fatherSort'="" sort=fatherSort_"."_sort
	.s obj.TheorySort=sort ;TheorySort
	e  d
	.s obj=##class(CF.DHCINM.DB.TeaTheory).%OpenId(rw)
	.;根节点是否为所辖病区。
	.s dataWard=..GetTheoryWard(TheoryParDR)
	.i isAll'=1  d
	..s:((dataWard="")||('$d(tmpWard(dataWard)))) errRet="非所管病区类别,不可编辑"
	q:errRet'="" errRet
	s className="CF.DHCINM.DB.TeaTheory"
	s p="" f  s p=$O(^oddCOM("CF.DHCINM.DB.TeaTheory","a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="TheorySort"
	.q:p="TheoryParDR"
	.q:p="TheoryTypeDR"
	.s ptype=^oddCOM(className,"a",p,"P","XSDTYPE")
	.q:'$d(tmp(p))
	.s value=$zcvt($tr(tmp(p)," ",""),"U")
	.i ((ptype="date")&&(value'="")) d
	..s value=$zdh(value,3)
	.s $ZOBJPROPERTY(obj,p)=value
	s TheoryTypeDR=$g(tmp("TheoryTypeDR"))
	i TheoryTypeDR'="" d
	.s TheoryTypeObj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(TheoryTypeDR)
	.s obj.TheoryTypeDR=TheoryTypeObj ;TheoryTypeDR
	s flag=$$$ISOK(obj.%Save())
	if flag{
		q 1	
	}else{
		q "保存失败"	
	}
}

/// Creator:
/// Createdate:
/// Description:停用理论项目维护
/// Input:
/// Output:
/// Other:
ClassMethod StopTeachTheory(id As %String = "") As %String
{
	q:id="" "入参为空"
	s obj=##class(CF.DHCINM.DB.TeaTheory).%OpenId(id)
	q:'$IsObject(obj) "未查询到数据,请刷新重试"
	q:((obj.EndDate'="")&&(obj.EndDate<=+$H)) "已停用"
	s obj.EndDate=+$H
	s flag=$$$ISOK(obj.%Save())
	if flag{
		q 1	
	}else{
		q "保存失败"	
	}
}

/// Creator:
/// Createdate:
/// Description:获取理论项目维护父表
/// Input:
/// Output:
/// Other:
ClassMethod GetTeachTheory(id) As %String
{
	s obj=##class(CF.DHCINM.DB.TeaTheory).%OpenId(id)
	s className="CF.DHCINM.DB.TeaTheory"
	s ret=""
	s ret="rw|"_id
	s p="" f  s p=$O(^oddCOM("CF.DHCINM.DB.TeaTheory","a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="TheoryTypeDR"
	.s ptype=^oddCOM(className,"a",p,"P","XSDTYPE")
	.s value=$ZOBJPROPERTY(obj,p)
	.i ((ptype="date")&&(value'="")) d
	..s value=##class(web.INMHISComm).DateLogicalToHtml(value)
	.s ret=ret_"^"_p_"|"_value
	i $IsObject(obj.TheoryTypeDR) d
	.s ret=ret_"^TheoryTypeDR|"_obj.TheoryTypeDR.%Id()
	q ret
}

/// Creator:
/// Createdate:
/// Description:获取理论项目维护父树形结构
/// Input:0,selectMode:E\I
/// Output:
/// Other:w ##class(web.INMDBComm).FindTeachTheoryTree(0,"T","54||1",1)
ClassMethod FindTeachTheoryTree(par, selectMode As %String = "", selectType As %String = "", dateFlag As %String = "0") As %Text
{
	s nowDate=+$H
	s tmp=""
	s id="" f  s id=$O(^CF.DHCINM.DB.TeaTheoryI("par"," "_par,id)) q:id=""  d
	.s objLB=$G(^CF.DHCINM.DB.TeaTheoryD(id))
	.q:objLB=""
	.s TheoryTypeDR=$LG(objLB,7)
	.s TheoryMode=$LG(objLB,8)
	.s typeFlag=1,modeFlag=1
	.s:par'=0 typeFlag=0,modeFlag=0
	.s:((selectMode="")&&(selectType="")) typeFlag=0,modeFlag=0
	.i (par=0)&&((selectMode'="")||(selectType'="")) d
	..i selectMode'=""  d
	...s:((selectMode="E")&&(TheoryMode="Y")) modeFlag=0 ;只取应急预案
	...s:((selectMode'="E")&&(TheoryMode'="Y")) modeFlag=0
	..i selectType'=""  d ;选择了是应急预案得也要类型一直
	...s:(TheoryTypeDR=selectType) typeFlag=0
	.q:((typeFlag=1)||(modeFlag=1))
	.s sort=$LG(objLB,4)
	.s sort=$P(sort,".",$l(sort,"."))
	.s tmp(sort)=id
	w "["
	s isFirst=1
	s retSort="" f  s retSort=$O(tmp(retSort)) q:retSort=""  d
	.s id=$g(tmp(retSort))
	.s objLB=$G(^CF.DHCINM.DB.TeaTheoryD(id))
	.q:objLB=""
	.s sort=$LG(objLB,4)
	.s startDate=$LG(objLB,5)
	.s endDate=$LG(objLB,6)
	.s stopFlag=0
	.s:((startDate'="")&&(startDate>nowDate)) stopFlag=1
	.s:((endDate'="" )&&(endDate<=nowDate)) stopFlag=1
	.q:((dateFlag=1)&&(stopFlag=1))
	.s label=$LG(objLB,2)
	.w:isFirst'=1 ","
	.w "{"_"""id"""_":"""_id_""",""label"":"""_label_""",""stopFlag"":"""_stopFlag_""""
	.s childId=$O(^CF.DHCINM.DB.TeaTheoryI("par"," "_id,""))
	.i childId'="" d
	..w ",""children"":"
	..d ..FindTeachTheoryTree(id,selectMode,selectType,dateFlag)
	.w "}"
	.s isFirst=0
	w "]"
	q ""
}

/// Creator:lulin
/// Createdate:2020-06-18
/// Description:保存理论项目维护子表
/// Input:
/// Output:
/// Other:
ClassMethod SaveTeachTheorySub(parr As %String, loginID As %String = "") As %String
{
	s ^TMP("SaveTeachTheorySub")=parr
	q:parr="" "入参为空"
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	s par=$g(tmp("par"))
	q:par="" "请选择类别"
	;---如果已被答题，不可修改---
	q:((rw'="")&&(($d(^DHCINM.Tea.LearnTheoryTestI("Theory",rw))))) "已存在对应练习题,不可修改"
	q:((rw'="")&&(($d(^DHCINM.Tea.ExamTheorySubI("ExamSubDR",rw))))) "已存在对应答题,不可修改"
	q:((rw'="")&&(($d(^DHCINM.Tea.LearnDryRunSubI("ExamSubDR",rw))))) "已存在对应答题,不可修改"
	k tmpWard
	s tmpWard=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(loginID,.tmpWard)
	s editFlagWard=..GetTheoryWard(par)
	i ((isAll'=1)&&((editFlagWard="")||('$d(tmpWard(editFlagWard))))){
		q "非所管病区数据，无维护权限"	
	}
	s ret=""
	i rw="" d
	.s obj=##class(CF.DHCINM.DB.TeaTheorySub).%New()
	.s parObj=##class(CF.DHCINM.DB.TeaTheory).%OpenId(par)
	.i $IsObject(parObj) d
	..s obj.Parref=parObj
	.e  d
	..s ret="未发现父节点,请刷新重试"
	e  d
	.s obj=##class(CF.DHCINM.DB.TeaTheorySub).%OpenId(rw)
	s className="CF.DHCINM.DB.TeaTheorySub"
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:p="SubUrl"
	.q:((p="SubTypeDR")||(p="SubOption")||(p="SubUsedLevel")||(p="SubUsedGroup"))
	.s ptype=^oddCOM(className,"a",p,"P","XSDTYPE")
	.q:'$d(tmp(p))
	.s value=$zcvt($tr(tmp(p)," ",""),"U")
	.i ((ptype="date")&&(value'="")) d
	..s value=$zdh(value,3)
	.s $ZOBJPROPERTY(obj,p)=value
	s SubTypeDR=$g(tmp("SubTypeDR"))
	i SubTypeDR'="" d
	.s SubTypeObj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(SubTypeDR)
	.s obj.SubTypeDR=SubTypeObj
	s SubOption=$g(tmp("SubOption"))
	d obj.SubOption.Clear()
	f i=1:1:$L(SubOption,"」") d
	.s itm=$P(SubOption,"」",i)
	.q:itm=""
	.d obj.SubOption.Insert(itm)
	s SubUsedLevel=$g(tmp("SubUsedLevel"))
	d obj.SubUsedLevel.Clear()
	f i=1:1:$L(SubUsedLevel,",") d
	.s itm=$P(SubUsedLevel,",",i)
	.q:itm=""
	.d obj.SubUsedLevel.Insert(itm)
	s SubUsedGroup=$g(tmp("SubUsedGroup"))
	d obj.SubUsedGroup.Clear()
	f i=1:1:$L(SubUsedGroup,",") d
	.s itm=$P(SubUsedGroup,",",i)
	.q:itm=""
	.d obj.SubUsedGroup.Insert(itm)
	s flag=$$$ISOK(obj.%Save())
	if flag{
		q obj.%Id()
	}else{
		q "保存失败"	
	}
}

/// Creator:lulin
/// Createdate:2020-06-18
/// Description:获取理论项目维护子表
/// Input:
/// Output:
/// Other:w ##class(web.INMDBComm).GetTeachTheorySub("3||1")
ClassMethod GetTeachTheorySub(rw) As %String
{
	s obj=##class(CF.DHCINM.DB.TeaTheorySub).%OpenId(rw)
	s className="CF.DHCINM.DB.TeaTheorySub"
	s ret="rw|"_rw
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:p="SubUrl"
	.q:((p="SubTypeDR")||(p="SubOption")||(p="SubUsedLevel")||(p="SubUsedGroup"))
	.s ptype=^oddCOM(className,"a",p,"P","XSDTYPE")
	.s value=$ZOBJPROPERTY(obj,p)
	.i ((ptype="date")&&(value'="")) d
	..s value=$zdh(value,3)
	.s ret=ret_"^"_p_"|"_value
	s SubTypeDR=obj.SubTypeDR,SubTypeDRDesc=""
	s:$IsObject(SubTypeDR) SubTypeDR=obj.SubTypeDR.%Id(),SubTypeDRDesc=obj.SubTypeDR.SubCode
	s ret=ret_"^SubTypeDR|"_SubTypeDR_"^SubTypeDRDesc|"_SubTypeDRDesc
	s SubUrl=""
	f i=1:1:obj.SubUrl.Count() d
	.s itm=obj.SubUrl.GetAt(i)
	.i SubUrl="" d
	..s SubUrl=itm
	.e  d
	..s SubUrl=SubUrl_","_itm
	s ret=ret_"^SubUrl|"_SubUrl
	s SubOption=""
	f i=1:1:obj.SubOption.Count() d
	.s itm=obj.SubOption.GetAt(i)
	.i SubOption="" d
	..s SubOption=itm
	.e  d
	..s SubOption=SubOption_"」"_itm
	s ret=ret_"^SubOption|"_SubOption
	s SubUsedLevel="",SubUsedLevelDesc=""
	f i=1:1:obj.SubUsedLevel.Count() d
	.s itm=obj.SubUsedLevel.GetAt(i)
	.q:itm=""
	.s codeSubObj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(itm)
	.q:'$IsObject(codeSubObj)
	.i SubUsedLevel="" d
	..s SubUsedLevel=itm,SubUsedLevelDesc=codeSubObj.SubDesc
	.e  d
	..s SubUsedLevel=SubUsedLevel_","_itm,SubUsedLevelDesc=SubUsedLevelDesc_","_codeSubObj.SubDesc
	s ret=ret_"^SubUsedLevel|"_SubUsedLevel_"^SubUsedLevelDesc|"_SubUsedLevelDesc
	s SubUsedGroup="",SubUsedGroupDesc=""
	f i=1:1:obj.SubUsedGroup.Count() d
	.s itm=obj.SubUsedGroup.GetAt(i)
	.q:itm=""
	.s codeSubObj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(itm)
	.q:'$IsObject(codeSubObj)
	.i SubUsedGroup="" d
	..s SubUsedGroup=itm,SubUsedGroupDesc=codeSubObj.SubDesc
	.e  d
	..s SubUsedGroup=SubUsedGroup_","_itm,SubUsedGroupDesc=SubUsedGroupDesc_","_codeSubObj.SubDesc
	s ret=ret_"^SubUsedGroup|"_SubUsedGroup_"^SubUsedGroupDesc|"_SubUsedGroupDesc
	s SubModeDesc=$case(obj.SubMode,"S":"单选题","M":"多选题","B":"填空题","A":"问答题",:obj.SubMode)
	s ret=ret_"^SubModeDesc|"_SubModeDesc
	s num=..GetTeachTheorySubNum(rw)
	s AnswerNum=$P(num,"^",1)
	s AnswerRate=$P(num,"^",2)
	s CorrentNum=$P(num,"^",3)
	s ret=ret_"^AnswerNum|"_AnswerNum_"^AnswerRate|"_AnswerRate_"^CorrentNum|"_CorrentNum
	q ret
}

/// Creator:lulin
/// Createdate:2020-06-18
/// Description:获取理论项目维护子表图片
/// Input:
/// Output:
/// Other:
ClassMethod SaveTeachTheorySubUrl(parr As %String) As %String
{
	
	s rw=$P(parr,"^",1)
	s url=$tr($p(parr,"^",2)," ","")
	s obj=##class(CF.DHCINM.DB.TeaTheorySub).%OpenId(rw)
	q:'$IsObject(obj) "0"
#;	f i=1:1:$L(url,",") d
#;	.s itm=$P(url,",",i)
#;	.q:itm=""
	d obj.SubUrl.Insert(url)
	s sc=obj.%Save()
	i $$$ISOK(sc){
		q 1	
	}else{
		q 0
	}
}

/// Creator:lulin
/// Createdate:2020-06-18
/// Description:删除理论项目维护子表图片
/// Input:
/// Output:
/// Other:
ClassMethod DeleteTeachTheorySubUrl(parr As %String) As %String
{
	s id=$p(parr,"^")
	s url=$tr($p(parr,"^",2)," ","")
	s obj=##class(CF.DHCINM.DB.TeaTheorySub).%OpenId(id)
	q:'$IsObject(obj) "0"
	s newRefer=""
	d obj.SubUrl.RemoveAt(obj.SubUrl.Find(url))
	s sc=obj.%Save()
	i $$$ISOK(sc){
		q 1	
	}else{
		q 0
	}
}

/// Creator:lulin
/// Createdate:2020-06-18
/// Description:查询理论项目维护子表
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMDBComm","FindTeachTheorySubList","2^^^^^")
Query FindTeachTheorySubList(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindTeachTheorySubListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s par=$P(parr,"^",1)
	s findLevel=$P(parr,"^",2)
	s findType=$P(parr,"^",3)
	s findGroup=$P(parr,"^",4)
	s findInput=$zcvt($P(parr,"^",5),"U")
	s stopFlag=$P(parr,"^",6)
	s ret=""
	if par=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
	s id="" f  s id=$O(^CF.DHCINM.DB.TeaTheorySubD(par,id)) q:id=""  d
	.s objLB=$G(^CF.DHCINM.DB.TeaTheorySubD(par,id))
	.q:objLB=""
	.s SubDesc=$LG(objLB,2)
	.s shellDesc=##class(web.INMVueComm).ToChineseSpell(SubDesc)
	.s code=$zcvt(SubDesc_shellDesc,"U")
	.q:((findInput'="")&&(code'[findInput))
	.s level=$LG(objLB,10)
	.q:((findLevel'="")&&($LF(level,findLevel)<1))
	.s group=$LG(objLB,11)
	.q:((findGroup'="")&&($LF(group,findGroup)<1))
	.s typeDR=$LG(objLB,5)
	.q:((findType'="")&&(typeDR'=findType))
	.s SubStatus=$LG(objLB,12)
	.q:((SubStatus="N")&&(stopFlag=1))
	.s ret=..GetTeachTheorySub(par_"||"_id)
	.d OutPutRowData
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTeachTheorySubListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTeachTheorySubListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindTeachTheorySubListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTeachTheorySubListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2020-06-22
/// Description:保存技操项目维护
/// Input:
/// Output:
/// Other:
ClassMethod SaveTeaOpera(parr As %String) As %String
{
	q:parr="" "入参为空"
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	s ret=""
	i rw="" d
	.s obj=##class(CF.DHCINM.DB.TeaOpera).%New()
	e  d
	.s obj=##class(CF.DHCINM.DB.TeaOpera).%OpenId(rw)
	s className="CF.DHCINM.DB.TeaOpera"
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:((p="OperaType")||(p="OperaStand")||(p="OperaResult"))
	.s ptype=^oddCOM(className,"a",p,"P","XSDTYPE")
	.q:'$d(tmp(p))
	.s value=$zcvt($tr(tmp(p)," ",""),"U")
	.i ((ptype="date")&&(value'="")) d
	..s value=$zdh(value,3)
	.s $ZOBJPROPERTY(obj,p)=value
	s OperaType=$g(tmp("OperaType"))
	i OperaType'="" d
	.s OperaType=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(OperaType)
	.s obj.OperaType=OperaType
	s OperaStand=$g(tmp("OperaStand"))
	d obj.OperaStand.Clear()
	f i=1:1:$L(OperaStand,"「") d
	.s itm=$P(OperaStand,"「",i)
	.q:itm=""
	.d obj.OperaStand.Insert(itm)
	s OperaResult=$g(tmp("OperaResult"))
	d obj.OperaResult.Clear()
	f i=1:1:$L(OperaResult,"「") d
	.s itm=$P(OperaResult,"「",i)
	.q:itm=""
	.d obj.OperaResult.Insert(itm)
	s sc=obj.%Save()
	i $$$ISOK(sc){
		q obj.%Id()	
	}else{
		q 0
	}
}

/// Creator:lulin
/// Createdate:2020-06-18
/// Description:获取技操维护项目数据
/// Input:
/// Output:
/// Other:w ##class(web.INMDBComm).GetTeaOpera("1")
ClassMethod GetTeaOpera(rw) As %String
{
	s obj=##class(CF.DHCINM.DB.TeaOpera).%OpenId(rw)
	s className="CF.DHCINM.DB.TeaOpera"
	s ret="rw|"_rw
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:((p="OperaType")||(p="OperaStand")||(p="OperaResult"))
	.s ptype=^oddCOM(className,"a",p,"P","XSDTYPE")
	.s value=$ZOBJPROPERTY(obj,p)
	.i ((ptype="date")&&(value'="")) d
	..s value=##class(web.INMHISComm).DateLogicalToHtml(value)
	.s ret=ret_"^"_p_"|"_value
	s OperaType="",OperaTypeDesc=""
	i $IsObject(obj.OperaType) d
	.s OperaType=obj.OperaType.%Id(),OperaTypeDesc=obj.OperaType.SubDesc
	s ret=ret_"^OperaType|"_OperaType_"^OperaTypeDesc|"_OperaTypeDesc
	s OperaStand=""
	f i=1:1:obj.OperaStand.Count() d
	.s itm=obj.OperaStand.GetAt(i)
	.q:itm=""
	.i OperaStand="" d
	..s OperaStand=itm
	.e  d
	..s OperaStand=OperaStand_"「"_itm
	s ret=ret_"^OperaStand|"_OperaStand
	s OperaResult=""
	f i=1:1:obj.OperaResult.Count() d
	.s itm=obj.OperaResult.GetAt(i)
	.q:itm=""
	.i OperaResult="" d
	..s OperaResult=itm
	.e  d
	..s OperaResult=OperaResult_"「"_itm
	s ret=ret_"^OperaResult|"_OperaResult
	s OperaModeDesc=$case(obj.OperaMode,"A":"是否模式","B":"符合模式","C":"得分模式","D":"扣分模式","E":"选项模式","F":"扣分原因模式",:obj.OperaMode)
	s ret=ret_"^OperaModeDesc|"_OperaModeDesc
	s OperaStandTypeDesc=$case(obj.OperaStandType,"A":"统一","O":"自定义",:obj.OperaStandType)
	s ret=ret_"^OperaStandTypeDesc|"_OperaStandTypeDesc
	q ret
}

/// Creator:lulin
/// Createdate:2020-06-23
/// Description:删除技操维护项目
/// Input:
/// Output:
/// Other:
ClassMethod DeleteTeaOpera(rw) As %String
{
	s obj=##class(CF.DHCINM.DB.TeaOpera).%OpenId(rw)
	s isUsed=..CheckTeaOperaUsed(rw)
	if isUsed'=0{
		q "此数据已被使用,不可删除"
	}
	s flag=obj.%DeleteId(rw)
	q flag
}

/// Creator:lulin
/// Createdate:2020-06-22
/// Description:查询技操项目维护
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMDBComm","FindTeachTheorySubList","3^19||2^^^")
Query FindTeaOperaList(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindTeaOperaListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s findType=$P(parr,"^",1)
	s findMode=$P(parr,"^",2)
	s findNowDateFlag=$P(parr,"^",3)
	s findInput=$zcvt($P(parr,"^",4),"U")
	s nowDate=+$H
	s ret=""
	s id="" f  s id=$O(^CF.DHCINM.DB.TeaOperaD(id)) q:id=""  d
	.s objLB=$G(^CF.DHCINM.DB.TeaOperaD(id))
	.q:objLB=""
	.s SubDesc=$LG(objLB,3)
	.s shellDesc=##class(web.INMVueComm).ToChineseSpell(SubDesc)
	.s code=$zcvt(SubDesc_shellDesc,"U")
	.q:((findInput'="")&&(code'[findInput))
	.s mode=$LG(objLB,4)
	.q:((findMode'="")&&(mode'=findMode))
	.s typeDR=$LG(objLB,2)
	.q:((findType'="")&&(typeDR'=findType))
	.s startDate=$LG(objLB,10)
	.s endDate=$LG(objLB,11)
	.q:((findNowDateFlag=1)&&(startDate'="")&&(startDate>nowDate))
	.q:((findNowDateFlag=1)&&(endDate'="")&&(endDate<nowDate))
	.s ret=..GetTeaOpera(id)
	.d OutPutRowData
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTeaOperaListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTeaOperaListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindTeaOperaListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTeaOperaListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:lulin
/// Createdate:2020-06-23
/// Description:获取技操维护项目指标树形数据
/// Input:
/// Output:
/// Other:w ##class(web.INMDBComm).FindTeaOperaSubTree("4","")
ClassMethod FindTeaOperaSubTree(parref, par) As %String
{
	s nowDate=+$H
	s tmp=""
	s id="" f  s id=$O(^CF.DHCINM.DB.TeaOperaSubI("par",parref," "_par,id)) q:id=""  d
	.s objLB=$G(^CF.DHCINM.DB.TeaOperaSubD(parref,id))
	.q:objLB=""
	.s sort=$LG(objLB,6)
	.s sort=$P(sort,".",$l(sort,"."))
	.s tmp(sort)=id
	w "["
	s isFirst=1
	s retSort="" f  s retSort=$O(tmp(retSort)) q:retSort=""  d
	.s id=$g(tmp(retSort))
	.s objLB=$G(^CF.DHCINM.DB.TeaOperaSubD(parref,id))
	.q:objLB=""
	.s sort=$LG(objLB,6)
	.s startDate=$LG(objLB,7)
	.s endDate=$LG(objLB,8)
	.s SubScore=$lg(objLB,4)
	.s stopFlag=0
	.s:((startDate'="")&&(startDate>nowDate)) stopFlag=1
	.s:((endDate'="" )&&(endDate<nowDate)) stopFlag=1
	.s label=$LG(objLB,2)
	.w:isFirst'=1 ","
	.s label=label_"("_SubScore_")"
	.w "{"_"""id"""_":"""_parref_"||"_id_""",""label"":"""_label_""",""stopFlag"":"""_stopFlag_""",""children"":"
	.d ..FindTeaOperaSubTree(parref,parref_"||"_id)
	.w "}"
	.s isFirst=0
	w "]"
	q ""
}

/// Creator:lulin
/// Createdate:2020-06-23
/// Description:获取技操维护项目指标数据
/// Input:
/// Output:
/// Other:w ##class(web.INMDBComm).FindTeaOperaSubTree("4")
ClassMethod GetTeaOperaSub(rw) As %String
{
	s obj=##class(CF.DHCINM.DB.TeaOperaSub).%OpenId(rw)
	s className="CF.DHCINM.DB.TeaOperaSub"
	s ret="rw|"_rw
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:(p="SubStand")
	.s ptype=^oddCOM(className,"a",p,"P","XSDTYPE")
	.s value=$ZOBJPROPERTY(obj,p)
	.i ((ptype="date")&&(value'="")) d
	..s value=##class(web.INMHISComm).DateLogicalToHtml(value)
	.s ret=ret_"^"_p_"|"_value
	s SubStand=""
	f i=1:1:obj.SubStand.Count() d
	.s itm=obj.SubStand.GetAt(i)
	.q:itm=""
	.i SubStand="" d
	..s SubStand=itm
	.e  d
	..s SubStand=SubStand_"「"_itm
	s ret=ret_"^SubStand|"_SubStand
	q ret
}

/// Creator:lulin
/// Createdate:2020-06-23
/// Description:保存技操维护项目指标数据
/// Input:
/// Output:
/// Other:
ClassMethod SaveTeaOperaSub(parr) As %String
{
	s tmp=""
	s parr=$replace(parr,"\","\\")
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s subPar=$g(tmp("SubPar"))
	s:subPar=0 subPar=""
	s parref=$g(tmp("parref"))
	s parrefObj=##class(CF.DHCINM.DB.TeaOpera).%OpenId(parref)
	q:'$IsObject(parrefObj) "保存失败,未获取表单信息,请刷新重试!"
	s subScore=$g(tmp("SubScore"))
	s errorRet=""
	i ((parrefObj.OperaMode="E")&&(parrefObj.OperaStandType="A")) d //选项模式分值不能小于设定的
	.f i=1:1:parrefObj.OperaStand.Count() d
	..s tScore=$P(parrefObj.OperaStand.GetAt(i),"」",2)
	..s:tScore>subScore errorRet="分值不能小于选项最高分"
	q:errorRet'="" errorRet
	s:subScore="" subScore=1
	TS
	s id=$g(tmp("rw"))
	s IsScore=1
	i id'="" d
	.s obj=##class(CF.DHCINM.DB.TeaOperaSub).%OpenId(id)
	.s IsScore='$d(^CF.DHCINM.DB.TeaOperaSubI("par"," "_obj.%Id())) ;无子节点需要进行父树节点数据计算
	.s:(IsScore)&&(obj.SubScore=subScore) IsScore=0 ;无子节点但是分数未改变不需要计算
	e  d
	.s obj=##class(CF.DHCINM.DB.TeaOperaSub).%New()
	.s obj.Parref=parrefObj
	.s SubSort=..GetTeaOperaSubSort(parref,subPar)
	.i subPar'="" d
	..s subParObj=##class(CF.DHCINM.DB.TeaOperaSub).%OpenId(subPar)
	..s:$IsObject(subParObj) SubSort=subParObj.SubSort_"."_SubSort
	.s obj.SubSort=SubSort
	.s obj.SubPar=subPar
	s obj.SubDesc=$g(tmp("SubDesc"))
	s obj.SubStandard=$g(tmp("SubStandard"))
	s:IsScore obj.SubScore=subScore
	s SubStand=$g(tmp("SubStand"))
	d obj.SubStand.Clear()
	f i=1:1:$L(SubStand,"「") d
	.s itm=$P(SubStand,"「",i)
	.q:itm=""
	.d obj.SubStand.Insert(itm)
	s errorRet=""
	i ((parrefObj.OperaMode="E")&&(parrefObj.OperaStandType="O")) d //选项模式分值不能小于设定的
	.f i=1:1:obj.SubStand.Count() d
	..s tScore=$P(obj.SubStand.GetAt(i),"」",2)
	..s:tScore>subScore errorRet="分值不能小于选项最高分"
	q:errorRet'="" errorRet
	i $g(tmp("StartDate")) s obj.StartDate=$zdh(tmp("StartDate"),3)
	e  s obj.StartDate=""
	i $g(tmp("EndDate")) s obj.EndDate=$zdh(tmp("EndDate"),3)
	e  s obj.EndDate=""
	s sc=obj.%Save()
	s flag=$$$ISOK(sc)
	if flag'=1{
		tro
		q "保存失败"	
	}
	i ($$$ISOK(sc)=1)&&(IsScore) d
	.s flag=..CalcuOperaSubScore(parref,obj.SubPar)
	if flag
	{
		TC
		q 1
	}else{
		Tro
		q "计算分数错误"
	}
}

/// Creator:lulin
/// Createdate:2020-06-28
/// Description:保存技操维护项目指标数据--上传
/// Input:
/// Output:
/// Other:w ##class(web.INMDBComm).SaveImportTeaOperaSub("SubSort|1.1^SubDesc|测试2^SubStandard|^StartDate|2020-06-22^EndDate|^SubScore|17^SubStand|测试」5^parsort|1^parref|11^index|1")
ClassMethod SaveImportTeaOperaSub(parr) As %String
{
	s tmp=""
	s parr=$replace(parr,"\","\\")
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s parrefId=tmp("parref")
	s parObj=##class(CF.DHCINM.DB.TeaOpera).%OpenId(parrefId)
	s parSort=$g(tmp("parsort"))
	s tSort=$g(tmp("SubSort"))
	TS
	s isExist=0,parid="",tId=""
	//查看是否已存在即其父节点id
	s id="" f  s id=$O(^CF.DHCINM.DB.TeaOperaSubD(parrefId,id)) q:((id="")||(isExist=1))  d
	.s obj=##class(CF.DHCINM.DB.TeaOperaSub).%OpenId(parrefId_"||"_id)
	.i (obj.SubSort=parSort)&&(obj.SubSort'=tSort)&&(parSort'=tSort) s parid=parrefId_"||"_id
	.q:obj.SubSort'=tSort
	.s isExist=1,tId=parrefId_"||"_id
	s flag=1
	i isExist=0 d ;不存在此节点
	.i (parid="")&&($L(parSort)>1)&&(parSort'=tSort)  d
	..s upObj=##class(CF.DHCINM.DB.TeaOperaSub).%New()
	..s upObj.Parref=parObj
	..s upObj.SubSort=$g(tmp("parsort"))
	..s sc=upObj.%Save()
	..s flag=(flag&&$$$ISOK(sc))
	..i flag s parid=upObj.%Id()
	.s obj=##class(CF.DHCINM.DB.TeaOperaSub).%New()
	e  d
	.s obj=##class(CF.DHCINM.DB.TeaOperaSub).%OpenId(tId)
	s obj.SubSort=tSort
	s obj.Parref=parObj
	s obj.SubPar=parid
	s IsScore=1
	s obj.SubDesc=$g(tmp("SubDesc"))
	s SubStand=$g(tmp("SubStand"))
	d obj.SubStand.Clear()
	f i=1:1:$L(SubStand,"「") d
	.s itm=$P(SubStand,"「",i)
	.q:itm=""
	.d obj.SubStand.Insert(itm)
	s obj.SubStandard=$g(tmp("SubStandard"))
	if flag'=1{
		tro
		d parObj.%DeleteId(parrefId)
		q 1	
	}
	s:$g(tmp("SubScore")) obj.SubScore=+$g(tmp("SubScore"))
	s StartDate=$g(tmp("StartDate"))
	i StartDate d
	.s:StartDate["/" StartDate=$replace(StartDate,"/","-")
	.s obj.StartDate=$zdh(StartDate,3)
	e  s obj.StartDate=""
	s EndDate=$g(tmp("EndDate"))
	i EndDate d
	.s:EndDate["/" EndDate=$replace(EndDate,"/","-")
	.s obj.EndDate=$zdh(EndDate,3)
	e  s obj.EndDate=""
	s sc=obj.%Save()
	s flag=$$$ISOK(sc)
	i (flag)&&(obj.SubScore'="") d
	.s flag=..CalcuOperaSubScore(parrefId,obj.SubPar)
	if flag
	{
		TC
		q tmp("index")
	}else{
		Tro
		d parObj.%DeleteId(tmp("rw"))
		q "-1"
	}
}

/// Creator:
/// Createdate:
/// Description:保存数据时获取序号
/// Input:
/// Output:
/// Other:
ClassMethod GetTeaOperaSubSort(parref, par) As %String
{
	s sort=0
	s id="" f  s id=$O(^CF.DHCINM.DB.TeaOperaSubI("par",parref," "_par,id)) q:id=""  d
	.s obj=##class(CF.DHCINM.DB.TeaOperaSub).%OpenId(parref_"||"_id)
	.q:'$IsObject(obj)
	.s brotherSort=obj.SubSort
	.s brotherSort=$P(brotherSort,".",$l(brotherSort,"."))
	.i brotherSort>sort d
	..s sort=brotherSort
	s sort=sort+1
	q sort
}

/// Creator:lulin
/// Createdate:2020-06-23
/// Description:保存技操维护项目指标数据
/// Input:
/// Output:
/// Other:
ClassMethod CalcuOperaSubScore(par, id As %String) As %String
{
	s total=0,flag=0
	if id="" 
	{
		s rw="" f  s rw=$O(^CF.DHCINM.DB.TeaOperaSubD(par,rw)) q:rw=""  d
		.s subobj=##class(CF.DHCINM.DB.TeaOperaSub).%OpenId(par_"||"_rw)
		.q:'$IsObject(subobj)
		.q:subobj.SubPar'=""
		.s subscore=subobj.SubScore
		.s:subscore="" subscore=0
		.s total=total+subscore
		s parobj=##class(CF.DHCINM.DB.TeaOpera).%OpenId(par)
		s parobj.OperaScore=total
		s sc=parobj.%Save()
		s flag=$$$ISOK(sc)
	}
	else
	{
		s parobj=##class(CF.DHCINM.DB.TeaOperaSub).%OpenId(id)
		s total=..GetTeaOperaChildrenScore(id)
		s parobj.SubScore=total
		s sc=parobj.%Save()
		s flag=$$$ISOK(sc)
		s:flag flag=..CalcuOperaSubScore(par,parobj.SubPar)
	}
	q flag
}

/// Creator:lulin
/// Createdate:2020-06-23
/// Description:获取节点下子节点所有分数和
/// Input:
/// Output:
/// Other:
ClassMethod GetTeaOperaChildrenScore(id) As %String
{
	s score=0
	s par=+$g(id)
	s rw="" f  s rw=$o(^CF.DHCINM.DB.TeaOperaSubI("par",par," "_id,rw)) q:rw=""  d
	.s subobj=##class(CF.DHCINM.DB.TeaOperaSub).%OpenId(par_"||"_rw)
	.q:'$IsObject(subobj)
	.s subscore=subobj.SubScore
	.s:subscore="" subscore=0
	.s score=score+subscore
	q score
}

/// Creator:lulin
/// Createdate:2020-06-23
/// Description:删除技操维护项目指标数据
/// Input:
/// Output:
/// Other:
ClassMethod DeleteTeaOperaSub(rw) As %String
{
	s obj=##class(CF.DHCINM.DB.TeaOperaSub).%OpenId(rw)
	s isUsed=..CheckTeaOperaUsed(rw)
	if isUsed'=0
	{
		q -1	
	}
	TS
	s fatherid=obj.SubPar
	s sort=obj.SubSort
	s flag=obj.%DeleteId(rw)
	if $d(^CF.DHCINM.DB.TeaOperaSubI("par",+rw," "_rw)) ;删除子类
	{
		s childRW="" f  s childRW=$o(^CF.DHCINM.DB.TeaOperaSubD(+rw,childRW)) q:childRW=""  d
		.s childobj=##class(CF.DHCINM.DB.TeaOperaSub).%OpenId(+rw_"||"_childRW)
		.s childsort=childobj.SubSort
		.q:$l(childsort)<=$l(sort)
		.i $e(childsort,0,$l(sort))=sort  d childobj.%DeleteId(+rw_"||"_childRW)
	}
	s flag=..CalcuOperaSubScore(+rw,fatherid)
	if flag=1{
		TC	
	}else{
		Tro
	}
	q flag
}

/// Creator:lulin
/// Createdate:2020-06-23
/// Description:检测技操考核指标是否存在已使用
/// Input:
/// Output:
/// Other:
ClassMethod CheckTeaOperaUsed(id As %String = "") As %String
{
	s result=0
	q:id="" 0
	//检测考核发布、检查项目
	i $l(id,"||")=2 d ;子表
	.s result=$d(^DHCINM.Tea.ExamOperaSubI("Refer",id))
	e  i $l(id,"||")=1 d ;父表
	.;子表是否有被引用
	.s subid="" f subid=$o(^CF.DHCINM.DB.TeaOperaSubD(id,subid)) q:(subid="")||(result'=0)  d
	..s result=$d(^DHCINM.Tea.ExamOperaSubI("Refer",id_"||"_subid))
	.i result=0 d 
	..s result=$d(^DHCINM.Tea.ExamOperaI("CheckItem",id))
	.i result=0 d
	..s releaseId="" f  s releaseId=$O(^DHCINM.Tea.ExamReleaseI("Mode"," E",releaseId)) q:(releaseId="")||(result'=0)  d
	...s releaseObj=##class(DHCINM.Tea.ExamRelease).%OpenId(releaseId)
	...q:'$IsObject(releaseObj)
	...s:releaseObj.QuestRange.Find(id)>0 result=1
	q result
}

/// Creator:lulin
/// Createdate:2020-06-23
/// Description:获取考核文档导出数据
/// Input:
/// Output:
/// Other:d ##class(web.INMDBComm).FindExportTeaOpera(4)
ClassMethod FindExportTeaOpera(id As %String = "") As %String
{
	s ^TMP("FindExportTeaOpera")=1
	s tmp=""
	s sortLength=0,sortTimes=10
	s subid="" f  s subid=$O(^CF.DHCINM.DB.TeaOperaSubD(id,subid)) q:subid=""  d
	.s objLB=$g(^CF.DHCINM.DB.TeaOperaSubD(id,subid))
	.q:objLB=""
	.s sort=$LG(objLB,6)
	.q:sort=""
	.s @("tmpOpera("_$tr(sort,".",",")_")")=..GetTeaOperaSub(id_"||"_subid)
	w "["
	d ..ShowTreeData("tmpOpera","",1,0)
	w "]"
	q ""
}

Query FindQualItemsList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindQualItemsListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s type=$p(parr,"^",1)
	s keywork=$p(parr,"^",2)
	s rowid="" f  s rowid=$O(^CT.DHCINM.DB.MgQualItemD(rowid)) q:rowid=""  d
	.s obj=##class(CT.DHCINM.DB.MgQualItem).%OpenId(rowid)
	.q:'$IsObject(obj)
	.s QualYear=obj.QualYear
	.q:(type=0)&&(QualYear'[keywork)
	.s QualCode=$zcvt(obj.QualCode,"U")
	.s QualDesc=obj.QualDesc
	.q:(type=1)&&(QualDesc'[keywork)
	.s QualType=""
	.i obj.QualType'="" d
	..s len=$l(obj.QualType,",")
	..f i=1:1:len d
	...s itm=$p(obj.QualType,",",i)
	...q:itm=""
	...s QualTypeObj=##class(CT.DHCINM.Set.MgSysParamSub).%OpenId(itm)
	...i QualType="" s QualType=QualTypeObj.SubDesc
	...e  s QualType=QualType_","_QualTypeObj.SubDesc
	.q:(type=2)&&(QualType'[keywork)
	.s QualScore=obj.QualScore
	.s:QualScore="" QualScore=0
	.s PercentDefault=##class(web.INMSetComm).GetParamSubByCode("Compatible","Percent","SubValue")
	.s PercentDefault=$case(PercentDefault,1:"是否模式",2:"符合模式",:"是否模式")
	.s NumberDefault=##class(web.INMSetComm).GetParamSubByCode("Compatible","Number","SubValue")
	.s NumberDefault=$case(NumberDefault,1:"得分模式",2:"扣分模式",:"得分模式")
	.i (obj.QualScoreType=1)||(obj.QualScoreType="") s QualScoreType=$case(obj.QualScoreTypeSub,1:"是否模式",2:"符合模式",:PercentDefault)
	.e  s QualScoreType=$case(obj.QualScoreTypeSub,3:"得分模式",4:"扣分模式",5:"选项模式",6:"扣分原因模式",:NumberDefault)
	.q:(type=3)&&(QualScoreType'[keywork)
	.i obj.QualPass'="" s QualPass=obj.QualPass
	.e  d
	..s PassDefault=##class(web.INMSetComm).GetParamSubByCode("Compatible","Pass","SubValue")
	..s:PassDefault="" PassDefault=60
	..s QualPass=PassDefault
	.s QualStatus="启用"
	.s:((obj.QualStDate'="")&&(obj.QualStDate>+$h))||((obj.QualEndDate'="")&&(obj.QualEndDate<+$h)) QualStatus="停用"
	.q:(type=4)&&(QualStatus'[keywork)
	.s QualScore=obj.QualScore
	.s ret="qualYear|"_QualYear_"^qualDesc|"_QualDesc_"^qualType|"_QualType_"^qualCode|"_QualCode_"^rowid|"_rowid_"^qualScore|"_QualScore_"^qualScoreType|"_QualScoreType_"^qualTyperw|"_obj.QualType_"^qualPass|"_QualPass_"^qualStatus|"_QualStatus
	.s ret=ret_"^QualScore|"_QualScore_"^QualClassDesc|"_..GetCommCode(obj.QualClassDR)
	.do OutQualData
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQualData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindQualItemsListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQualItemsListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindQualItemsListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQualItemsListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:获取质控项目记录
/// Date:2017-09-07
/// Table: CT.DHCINM.DB.MgQualItem
/// Input:
/// Output：
/// Return:
ClassMethod GetQualItem(id As %String) As %String
{
	q:id="" ""
	s obj=##class(CT.DHCINM.DB.MgQualItem).%OpenId(id)
	q:'$IsObject(obj) ""
	s QualYear=obj.QualYear
	s QualCode=obj.QualCode
	s QualDesc=obj.QualDesc
	s QualType=obj.QualType
	s QualScore=obj.QualScore
	s:QualScore="" QualScore=0
	s QualScoreType=""
	s:obj.QualScoreType'="" QualScoreType=obj.QualScoreType
	i obj.QualScoreTypeSub'="" s QualScoreTypeSub=obj.QualScoreTypeSub
	e  i (QualScoreType=1)||(QualScoreType="") d
	.s PercentDefault=##class(web.INMSetComm).GetParamSubByCode("Compatible","Percent","SubValue")
	.s:PercentDefault="" PercentDefault=1
	.s QualScoreTypeSub=$case(PercentDefault,1:1,2:2,:1)
	e  d
	.s NumberDefault=##class(web.INMSetComm).GetParamSubByCode("Compatible","Number","SubValue")
	.s:NumberDefault="" NumberDefault=3
	.s QualScoreTypeSub=$case(NumberDefault,3:3,4:4,:3)
	s QualStandardMode=obj.QualStandardMode
	s QualStandardList=""
	i obj.QualStandardList'="" s QualStandardList=obj.QualStandardList
	e  i QualScoreTypeSub=1 s QualStandardList="是@√,否@×,不适用@-"
	e  i QualScoreTypeSub=2 s QualStandardList="完全符合@-,部分符合@-,不符合@-"
	s QualInsert=obj.QualInsert
	s QualInsertCount=1
	s:obj.QualInsertCount'="" QualInsertCount=obj.QualInsertCount
	i obj.QualPass'="" s QualPass=obj.QualPass
	e  d
	.s PassDefault=##class(web.INMSetComm).GetParamSubByCode("Compatible","Pass","SubValue")
	.s:PassDefault="" PassDefault=60
	.s QualPass=PassDefault
	s QualStDate="",QualEndDate=""
	s:obj.QualStDate'="" QualStDate=$zd(obj.QualStDate,3)
	s:obj.QualEndDate'="" QualEndDate=$zd(obj.QualEndDate,3)
	s QualScoreFlag=obj.QualScoreFlag
	s:QualScoreFlag="" QualScoreFlag="N"
	s ret="RowID|"_id_"^QualYear|"_QualYear_"^QualCode|"_QualCode_"^QualDesc|"_QualDesc_"^QualType|"_QualType_"^QualScore|"_QualScore
	s ret=ret_"^QualScoreType|"_QualScoreType_"^QualScoreTypeSub|"_QualScoreTypeSub_"^QualStandardMode|"_QualStandardMode
	s ret=ret_"^QualStandardList|"_QualStandardList_"^QualInsert|"_QualInsert_"^QualInsertCount|"_QualInsertCount
	s ret=ret_"^QualPass|"_QualPass_"^QualStDate|"_QualStDate_"^QualEndDate|"_QualEndDate_"^QualScoreFlag|"_QualScoreFlag
	s ret=ret_"^QualClassDR|"_obj.QualClassDR
	q ret
}

/// Creator: 
/// CreatDate: 
/// Update:lulin 2018-05-23
/// Description: 删除质控标准父表
/// Table：CT.DHCINM.DB.MgQualItem
/// Input：
/// Return：1:成功。2：已使用。0：失败
/// Other:w ##class(web.INMDBComm).DeleteQual(1)
ClassMethod DeleteQual(id As %String) As %String
{
	q:id="" 0
	q:$d(^DHCINM.CHK.MgCheckResultI("qualID",id)) 2
	s obj=##class(CT.DHCINM.DB.MgQualItem).%OpenId(id)
	s flag=obj.%DeleteId(id)
	q flag
}

/// Creator:gzj 
/// CreatDate: 2017-09-07
/// Description: 判断质控项目唯一性
/// Table：CT.DHCINM.DB.MgQualItem
/// Input：
/// Return： 记录存在返回-1 否则0
ClassMethod IsQualExist(tmp) As %String
{
	s flag=0
	s id=$g(tmp("RowID"))
	s code=$g(tmp("QualCode"))
	s type=$g(tmp("QualType"))
	q:code="" flag
	
	s rw=$O(^CT.DHCINM.DB.MgQualItemI("year",tmp("QualYear")," "_$zcvt($tr(code," ",""),"U")," "_$tr(type,"__","||"),""))
	i id=""
	{
		i rw'="" s flag=-1
	}elseif id'=""
	{
		i ((rw'="")&&(rw'=id)) s flag=-1
	}
	
	q flag
}

/// Creator:gzj 
/// CreatDate: 2017-09-07
/// Description: 保存质控项目
/// Table：CT.DHCINM.DB.MgQualItem
/// Input：
/// Return：成功返回 id
ClassMethod SaveQualItem(parr As %String) As %String
{
	s tmp=""
	s parr=$replace(parr,"\","\\")
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s flag=0
	s flag=..IsQualExist(.tmp)
	q:flag=-1 flag 
	s id=$g(tmp("RowID"))
	i id'="" s obj=##class(CT.DHCINM.DB.MgQualItem).%OpenId(id)
	e  s obj=##class(CT.DHCINM.DB.MgQualItem).%New()
	s p="" f  s p=$O(^oddCOM("CT.DHCINM.DB.MgQualItem","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..i p="QualCode" s tmp(p)=$zcvt($tr(tmp(p)," ",""),"U")
	..s ptype=^oddCOM("CT.DHCINM.DB.MgQualItem","a",p,"P","XSDTYPE")
	..i ((ptype="date")&&(tmp(p)'="")) d
	...s tmp(p)=$replace(tmp(p),"/","-")
	...s:$L(tmp(p),"-")=3 tmp(p)=$zdh(tmp(p),3)
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	s sc=obj.%Save()
	i $$$ISOK(sc) q obj.%Id()
	e  q 0
}

/// creator:lulin
/// createdate:2018-06-19
/// description:获取质控标准导出数据
/// table:CT.DHCINM.DB.MgQualItem,CT.DHCINM.DB.MgQualItemSub
/// input:质控标准ID
/// output:
/// other:d ##class(%ResultSet).RunQuery("web.INMDBComm","FindExportQualData","1")
Query FindExportQualData(id As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindExportQualDataExecute(ByRef qHandle As %Binary, id As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i id="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	k @"tmp"
	s subId="" f  s subId=$o(^CT.DHCINM.DB.MgQualItemSubD(id,subId)) q:subId=""  d
	.s obj=##class(CT.DHCINM.DB.MgQualItemSub).%OpenId(id_"||"_subId)
	.q:'$IsObject(obj)
	.s sort=obj.SubSort
	.q:sort=""
	.s subDesc=obj.SubDesc
	.s subStandard=obj.SubStandard
	.s stdate=obj.SubStDate
	.s:stdate'="" stdate=$zd(stdate,3)
	.s enddate=obj.SubEndDate
	.s:enddate'="" enddate=$zd(enddate,3)
	.s score=obj.SubScore
	.s:$d(^CT.DHCINM.DB.MgQualItemSubI("par"," "_id_"||"_subId)) score=""
	.s standardlist=obj.SubStandardList
	.s @("tmp("_$tr(sort,".",",")_")")="sort|"_sort_"^desc|"_subDesc_"^standard|"_subStandard_"^stdate|"_stdate_"^enddate|"_enddate_"^score|"_score_"^standardlist|"_standardlist
	
	s sort="tmp("""")" f  s sort=$q(@sort) q:sort=""  d
	.s ret=@sort
	.d OutExportQualData
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutExportQualData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindExportQualDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExportQualDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindExportQualDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExportQualDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator:lulin
/// createdate:2018-06-21
/// description:保存导入质控标准子项
/// table:CT.DHCINM.DB.MgQualItem,CT.DHCINM.DB.MgQualItemSub
/// input:
/// output:
/// other:w ##class(web.INMDBComm).SaveImporQualSubData("sort|1.0.1^desc|抢救车清洁无尘土^standard|^stdate|^enddate|^score|2^parsort|1.0^rw|26")
ClassMethod SaveImporQualSubData(parr) As %String
{
	//sort|1.0^desc|急救车管理要求^standard|^stdate|^enddate|^score|^parsort|1^rw|21
	//sort|5.0.5^desc|5.5护理人员对跌倒坠床发生后上报处理流程知晓率^standard|^stdate|2019-01-01^enddate|^score|4^parsort|5.0^rw|16^index|25
	//sort|1.0^desc|急救车管理要求^standard|^stdate|^enddate|^score|^parsort|1^rw|21
	//sort|1.0.4^desc|责任护士掌握患者主要阳性体征^standard|^stdate|^enddate|^score|3^parsort|1.0^rw|1^index|4
	s tmp=""
	s parr=$tr($replace(parr,"\","\\"),$c(9,10,13,32),"")
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s parObj=##class(CT.DHCINM.DB.MgQualItem).%OpenId(tmp("rw"))
	TS
	s isExist=0,parid="",tId=""
	//查看是否已存在即其父节点id
	s id="" f  s id=$O(^CT.DHCINM.DB.MgQualItemSubD(tmp("rw"),id)) q:((id="")||(isExist=1))  d
	.s obj=##class(CT.DHCINM.DB.MgQualItemSub).%OpenId(tmp("rw")_"||"_id)
	.i (obj.SubSort=$g(tmp("parsort")))&&(obj.SubSort'=tmp("sort")) s parid=tmp("rw")_"||"_id
	.q:obj.SubSort'=tmp("sort")
	.s isExist=1,tId=tmp("rw")_"||"_id
	s flag=1
	i (parid="")&&($L($g(tmp("parsort")),".")>1)  d
	.s upObj=##class(CT.DHCINM.DB.MgQualItemSub).%New()
	.s upObj.Parref=parObj
	.s upObj.SubSort=$g(tmp("parsort"))
	.s sc=upObj.%Save()
	.s flag=(flag&&$$$ISOK(sc))
	.s:flag=1 parid=upObj.%Id()
	i isExist=0 d
	.s obj=##class(CT.DHCINM.DB.MgQualItemSub).%New()
	.s obj.SubSort=tmp("sort")
	.s obj.Parref=parObj
	e  d
	.s obj=##class(CT.DHCINM.DB.MgQualItemSub).%OpenId(tId)
	s obj.SubPar=parid
	s IsScore=1
	s obj.SubDesc=$g(tmp("desc"))
	s obj.SubStandard=$g(tmp("standard"))
	if flag'=1{
		tro
		 d parObj.%DeleteId(tmp("rw"))
		q 1	
	}
	s:$g(tmp("score")) obj.SubScore=+$g(tmp("score"))
	s stdate=$g(tmp("stdate"))
	i stdate d 
	.s:stdate["/" stdate=$replace(stdate,"/","-")
	.s obj.SubStDate=$zdh(stdate,3)
	s enddate=$g(tmp("enddate"))
	i enddate d 
	.s:enddate["/" enddate=$replace(enddate,"/","-")
	.s obj.SubEndDate=$zdh(tmp("enddate"),3)
	s:$g(tmp("standardlist"))'="" obj.SubStandardList=tmp("standardlist")
	s sc=obj.%Save()
	s flag=$$$ISOK(sc)
	i (flag)&&($g(tmp("score"))) d
	.s flag=..CalcuScore(tmp("rw"),obj.SubPar)
	if flag
	{
		TC
		q tmp("index")
	}else{
		Tro
		d parObj.%DeleteId(tmp("rw"))
		q "-1"
	}
}

/// Creator:lulin
/// Description:计算质控分数并修改
/// Date:2018年2月3日 09:55:09
/// Table: CT.DHCINM.DB.MgQualItemSub
/// Input:添加、修改节点的父节点id
/// Output：
/// Return:
ClassMethod CalcuScore(par, id As %String) As %String
{
	s total=0
	if id="" 
	{
		s rw="" f  s rw=$O(^CT.DHCINM.DB.MgQualItemSubD(par,rw)) q:rw=""  d
		.s subobj=##class(CT.DHCINM.DB.MgQualItemSub).%OpenId(par_"||"_rw)
		.q:'$IsObject(subobj)
		.q:subobj.SubPar'=""
		.s subscore=subobj.SubScore
		.s:subscore="" subscore=0
		.s total=total+subscore
		s parobj=##class(CT.DHCINM.DB.MgQualItem).%OpenId(par)
		q:'$IsObject(parobj) 2
		s parobj.QualScore=total
		s sc=parobj.%Save()
		s flag=$$$ISOK(sc)
	}
	else
	{
		s parobj=##class(CT.DHCINM.DB.MgQualItemSub).%OpenId(id)
		q:'$IsObject(parobj) 2
		s total=..GetItemScore(id)
		s parobj.SubScore=total
		s sc=parobj.%Save()
		s flag=$$$ISOK(sc)
		s:flag flag=..CalcuScore(par,parobj.SubPar)
	}
	q flag
}

/// Creator:lulin
/// Description:获取质控检查项子节点分数之和
/// Date:2018年2月3日 09:55:09
/// Table: CT.DHCINM.DB.MgQualItemSub
/// Input:父节点id
/// Output：
/// Return:
ClassMethod GetItemScore(parid) As %String
{
	s score=0
	s par=+$g(parid)
	s rw="" f  s rw=$o(^CT.DHCINM.DB.MgQualItemSubI("par"," "_parid,par,rw)) q:rw=""  d
	.s subobj=##class(CT.DHCINM.DB.MgQualItemSub).%OpenId(par_"||"_rw)
	.q:'$IsObject(subobj)
	.s subscore=subobj.SubScore
	.s:subscore="" subscore=0
	.s score=score+subscore
	q score
}

/// Creator:gzj
/// Updater:lulin
/// Description:获取质控管理树的数组。
/// others:字符串超长处理，将返回值分开使用w，最后返回""
ClassMethod GetQualTree(par) As %Text
{
	;s ret=""
	w "["
	s tmp=""
	;s now=+$now()
	s rowid="" f  s rowid=$O(^CT.DHCINM.DB.MgQualItemSubD(par,rowid)) q:rowid=""  d
	.s obj=##class(CT.DHCINM.DB.MgQualItemSub).%OpenId(par_"||"_rowid)
	.;q:(obj.SubStDate>now)||((obj.SubEndDate'="")&&(obj.SubEndDate<now))
	.;s subStandard=obj.SubStandard
	.s subScore=$fn(obj.SubScore,"",1)
	.s subDesc=obj.SubDesc_"("_subScore_")"
	.s subPar=obj.SubPar
	.;仅获取第一层（一级质控），SubPar为空的。根据此节点依次获取子节点。
	.q:subPar'=""
	.s stopFlag=0
	.i ((obj.SubStDate>+$H)||((obj.SubEndDate'="")&&(obj.SubEndDate<+$H))) d
	..s stopFlag=1
	.s tmp(1,$p(obj.SubSort,"."))=rowid_"^"_subDesc_"^"_stopFlag
	s IsExist=0
	s sort="" f  s sort=$o(tmp(1,sort)) q:sort=""  d
	.i IsExist w ","
	.s rowid=$p(tmp(1,sort),"^")
	.s subDesc=##class(web.INMVueComm).FilterSpecialSymbols($p(tmp(1,sort),"^",2))
	.s stopFlag=$p(tmp(1,sort),"^",3)
	.w "{"_"""id"""_":"""_par_"||"_rowid_""",""label"":"""_subDesc_""",""stopFlag"":"""_stopFlag_""",""children"":"
	.d ..GetSubItems(par,rowid,2)
	.w "}"
	.s IsExist=1
	w "]"
	q ""
}

/// 回调函数获取子节点
ClassMethod GetSubItems(parid, rowid, level) As %Text
{
	w "["
	k tmp(level)
	;s now=+$now()
	s rw="" f  s rw=$O(^CT.DHCINM.DB.MgQualItemSubI("par"," "_parid_"||"_rowid,parid,rw)) q:rw=""  d
	.s obj=##class(CT.DHCINM.DB.MgQualItemSub).%OpenId(parid_"||"_rw)
	.q:(obj.SubPar'=(parid_"||"_rowid))
	.;q:(obj.SubStDate>now)||((obj.SubEndDate'="")&&(obj.SubEndDate<now))
	.s subStandard=obj.SubStandard
	.s subScore=$fn(obj.SubScore,"",1)
	.s subDesc=obj.SubDesc_"("_subScore_")"
	.s subPar=obj.SubPar
	.s stopFlag=0
	.i ((obj.SubStDate>+$H)||((obj.SubEndDate'="")&&(obj.SubEndDate<+$H))) d
	..s stopFlag=1
	.s tmp(level,$p(obj.SubSort,".",$l(obj.SubSort,".")))=rw_"^"_subDesc_"^"_stopFlag
	s IsExist=0
	s sort="" f  s sort=$o(tmp(level,sort)) q:sort=""  d
	.i IsExist w ","
	.s rw=$p(tmp(level,sort),"^")
	.s subDesc=##class(web.INMVueComm).FilterSpecialSymbols($p(tmp(level,sort),"^",2))
	.s stopFlag=$p(tmp(level,sort),"^",3)
	.w "{"_"""id"""_":"""_parid_"||"_rw_""",""label"":"""_subDesc_""",""stopFlag"":"""_stopFlag_""",""children"":"
	.d ..GetSubItems(parid,rw,level+1)
	.w "}"
	.s IsExist=1
	w "]"
}

/// Creator: 
/// CreatDate: 
/// Update:lulin 2018-05-23
/// Description: 删除质控标准条目
/// Table：CT.DHCINM.DB.MgQualItem
/// Input：
/// Return：1:成功。2：已使用。0：失败
ClassMethod DeleteQualItms(id As %String) As %String
{
	q:id="" 0
	q:$d(^DHCINM.CHK.MgCheckResultSubI("qualID",id)) 2
	s obj=##class(CT.DHCINM.DB.MgQualItemSub).%OpenId(id)
	TS
	s fatherid=obj.SubPar
	s sort=obj.SubSort
	s flag=obj.%DeleteId(id)
	if $d(^CT.DHCINM.DB.MgQualItemSubI("par"," "_id)) 
	{
		s rw="" f  s rw=$o(^CT.DHCINM.DB.MgQualItemSubD(+id,rw)) q:rw=""  d
		.s childobj=##class(CT.DHCINM.DB.MgQualItemSub).%OpenId(+id_"||"_rw)
		.s childsort=childobj.SubSort
		.q:$l(childsort)<=$l(sort)
		.i $e(childsort,0,$l(sort))=sort  d childobj.%DeleteId(+id_"||"_rw)
	}
	s flag=..CalcuScore(+id,fatherid)
	if flag=1{
		TC	
	}else{
		Tro
	}
	q flag
}

/// Creator:gzj
/// Description:保存质控项目明细
/// Date:2017-09-09
/// Table: CT.DHCINM.DB.MgQualItemSub
/// Input:
/// Output：
/// Return:
ClassMethod SaveQualSub(parr As %String) As %String
{
	s tmp=""
	s parr=$replace(parr,"\","\\")
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	TS
	s id=$g(tmp("RowID"))
	s IsScore=1
	i id'="" d
	.s obj=##class(CT.DHCINM.DB.MgQualItemSub).%OpenId(id)
	.s IsScore='$d(^CT.DHCINM.DB.MgQualItemSubI("par"," "_obj.%Id()))  //无子节点需计算分数
	.s:(IsScore)&&(obj.SubScore=tmp("SubScore")) IsScore=0
	e  d
	.s obj=##class(CT.DHCINM.DB.MgQualItemSub).%New()
	.s obj.Parref=##class(CT.DHCINM.DB.MgQualItem).%OpenId(+tmp("SubPar"))
	.s obj.SubSort=..ComputeNodeSort(tmp("SubPar"))
	.i tmp("SubSort")'="1" s obj.SubPar=tmp("SubPar")
	.s IsScore=1
	.;s:(tmp("SubScore")=0) IsScore=0
	s obj.SubDesc=$g(tmp("SubDesc"))
	s obj.SubStandard=$g(tmp("SubStandard"))
	s:IsScore obj.SubScore=+$g(tmp("SubScore"))
	i $g(tmp("SubStDate")) s obj.SubStDate=$zdh(tmp("SubStDate"),3)
	e  s obj.SubStDate=""
	i $g(tmp("SubEndDate")) s obj.SubEndDate=$zdh(tmp("SubEndDate"),3)
	e  s obj.SubEndDate=""
	s:((obj.Parref.QualScoreType=2)&&(((obj.Parref.QualScoreTypeSub=5)&&(obj.Parref.QualStandardMode=2))||(obj.Parref.QualScoreTypeSub=6))) obj.SubStandardList=$g(tmp("SubStandardList"))
	s sc=obj.%Save()
	s flag=$$$ISOK(sc)
	i ($$$ISOK(sc)=1)&&(IsScore) d
	.s flag=..CalcuScore(+tmp("SubPar"),obj.SubPar)
	if flag
	{
		TC
	}
	else
	{
		Tro
	}
	d $System.Status.DisplayError(sc)
	q flag
}

/// Creator:gzj
/// Updater:lulin
/// Description:新增质控标准计算质控sort
/// Date:2018年2月8日
/// Table: CT.DHCINM.DB.MgQualItemSub
/// Input:
/// Output：
/// Return:
/// Others:二级：i.0；三级：i.0.j;四级：i.0.j.z。一级为父类（大标题****质控）
ClassMethod ComputeNodeSort(parid) As %String
{
	s NodeSort=""
	i parid[".0" d //计算二级质控排序
	.s par=$p(parid,".",1)
	.s n=1 //n个二级质控
	.s rw="" f  s rw=$O(^CT.DHCINM.DB.MgQualItemSubD(par,rw)) q:rw=""  d
	..s obj=##class(CT.DHCINM.DB.MgQualItemSub).%OpenId(par_"||"_rw)
	..q:obj.SubPar'=""
	..s sort=obj.SubSort
	..s nextsort=$P(sort,".")+1
	..s:nextsort>n n=nextsort
	.s NodeSort=n_".0"
	e  d //计算非二级质控排序
	.s par=$P(parid,"||",1)
	.s sort="",NodeSort="",n=1 //获取要要排的序号
	.s rw="" f  s rw=$O(^CT.DHCINM.DB.MgQualItemSubD(par,rw)) q:rw=""  d
	..s obj=##class(CT.DHCINM.DB.MgQualItemSub).%OpenId(par_"||"_rw)
	..q:(obj.SubPar'=parid) //父节点不对应的q
	..s sort=obj.SubSort
	..s nextsort=$P(sort,".",$l(sort,"."))+1
	..s:nextsort>n n=nextsort
	.s obj=##class(CT.DHCINM.DB.MgQualItemSub).%OpenId(parid)
	.s NodeSort=obj.SubSort_"."_n
	q NodeSort
}

/// Creator:gzj
/// Description:根据key(id)查找Tree的节点信息
/// Date:2017-09-12
/// Table: CT.DHCINM.DB.MgQualItemSub
/// Input:
/// Output：
/// Return:
ClassMethod GetTreeData(id As %String) As %String
{
	s obj=##class(CT.DHCINM.DB.MgQualItemSub).%OpenId(id)
	q:'$IsObject(obj) ""
	s SubDesc=obj.SubDesc
	s SubStandard=obj.SubStandard
	s SubScore=$fn(obj.SubScore,"",1)
	i obj.SubStDate'="" s SubStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.SubStDate)
	e  s SubStDate=""
	i obj.SubEndDate'="" s SubEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.SubEndDate)
	e  s SubEndDate=""
	s SubStandardList=obj.SubStandardList
	s parent=##class(CT.DHCINM.DB.MgQualItem).%OpenId($p(id,"||"))
	q:'$IsObject(parent) ""
	s QualScoreType=""
	s:parent.QualScoreType'="" QualScoreType=parent.QualScoreType
	s QualScoreTypeSub=""
	i parent.QualScoreTypeSub'="" s QualScoreTypeSub=parent.QualScoreTypeSub
	e  i (QualScoreType=1)||(QualScoreType="") d
	.s PercentDefault=##class(web.INMSetComm).GetParamSubByCode("Compatible","Percent","SubValue")
	.s:PercentDefault="" PercentDefault=1
	.s QualScoreTypeSub=$case(PercentDefault,1:1,2:2,:1)
	s SubStandardList=""
	i obj.SubStandardList'="" s SubStandardList=obj.SubStandardList
	e  i QualScoreTypeSub=1 s SubStandardList="是@-,否@-,不适用@-"
	e  i QualScoreTypeSub=2 s SubStandardList="完全符合@-,部分符合@-,不符合@-"
	e  i (QualScoreTypeSub=5)&&(parent.QualStandardMode=1) s SubStandardList=parent.QualStandardList
	s ret="RowID|"_id_"^SubDesc|"_SubDesc_"^SubStandard|"_SubStandard_"^SubScore|"_SubScore_"^SubStDate|"_SubStDate_"^SubEndDate|"_SubEndDate_"^SubStandardList|"_SubStandardList
	q ret
}

/// Description: 保存专科护士再认证项目
/// Date: 2020-07-24
/// Creator: wangpf
/// Table: CT.DHCINM.DB.MgReAdmItem
/// Input: parr
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMDBComm).SaveReAdmItem("")
ClassMethod SaveReAdmItem(parr As %String = "") As %String
{
	q:parr="" 0
	
	s code=$p(parr,"^")
	s option=$p(parr,"^",2)
	s optionList=$lfs(option,"」")
	s result=$p(parr,"^",3)
	s desc=$p(parr,"^",4)
	s standard=$p(parr,"^",5)
	s stDate=$p(parr,"^",6)
	s:stDate'="" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",7)
	s:endDate'="" endDate=$zdh(endDate,3)
	s rw=$p(parr,"^",8)
	
	i rw="" s obj=##class(CT.DHCINM.DB.MgReAdmItem).%New()
	e  s obj=##class(CT.DHCINM.DB.MgReAdmItem).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.ItemCode=code
	d obj.ItemOption.Clear()
	s ptr=0 f  s status=$listnext(optionList,ptr,opt) q:status'=1  d
	.d obj.ItemOption.Insert(opt)
	s obj.ItemResult=result
	s obj.ItemDesc=desc
	s obj.ItemStandard=standard
	s obj.ItemStDate=stDate
	s obj.ItemEndDate=endDate
	s sc=obj.%Save()
	b ;01
	q $$$ISOK(sc)
}

/// Description: 保存专科护士再认证项目值
/// Date: 2020-07-24
/// Creator: wangpf
/// Table: CT.DHCINM.DB.MgReAdmItem
/// Input: parr id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMDBComm).SaveReAdmItemValue("")
ClassMethod SaveReAdmItemValue(parr As %String = "") As %String
{
	q:parr="" 0
	
	s value=$p(parr,"^")
	s valueList=$lfs(value,"」")
	s rw=$p(parr,"^",2)
	
	s obj=##class(CT.DHCINM.DB.MgReAdmItem).%OpenId(rw)
	q:'$IsObject(obj) 0
	d obj.ItemOptionValue.Clear()
	s ptr=0 f  s status=$listnext(valueList,ptr,val) q:status'=1  d
	.d obj.ItemOptionValue.Insert(val)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取专科护士再认证项目
/// Date: 2020-07-24
/// Creator: wangpf
/// Table: CT.DHCINM.DB.MgReAdmItem
/// Input: id
/// Output: 专科护士再认证项目
/// Other: w ##class(web.INMDBComm).GetReAdmItem(1)
ClassMethod GetReAdmItem(id As %String = "") As %String
{
	q:(id="")||('$d(^CT.DHCINM.DB.MgReAdmItemD(id))) ""
	
	s itemGlo=^CT.DHCINM.DB.MgReAdmItemD(id)
	s itemCode=$lg(itemGlo,2)
	s option=$lg(itemGlo,3)
	s optionString=$lts(option,"」")
	s optionValue=$lg(itemGlo,4)
	s optionValueString=$lts(optionValue,"」")
	s itemResult=$lg(itemGlo,5)
	s itemDesc=$lg(itemGlo,6)
	s itemStandard=$lg(itemGlo,7)
	s itemStDate=$lg(itemGlo,8)
	s:itemStDate'="" itemStDate=$zd(itemStDate,3)
	s itemEndDate=$lg(itemGlo,9)
	s:itemEndDate'="" itemEndDate=$zd(itemEndDate,3)
	s now=+$h
	i (itemStDate>now)||((itemEndDate'="")&&(itemEndDate<now)) s itemStatus="N",itemStatusDesc="停用"
	e  s itemStatus="Y",itemStatusDesc="启用"
	s ret="ItemCode|"_itemCode_"^ItemOption|"_optionString_"^ItemOptionValue|"_optionValueString_"^ItemResult|"_itemResult
	s ret=ret_"^ItemDesc|"_itemDesc_"^ItemStandard|"_itemStandard_"^ItemStDate|"_itemStDate_"^ItemEndDate|"_itemEndDate
	s ret=ret_"^ItemStatus|"_itemStatus_"^ItemStatusDesc|"_itemStatusDesc_"^rw|"_id
	q ret
}

/// Description：获取专科护士再认证项目列表
/// Date:2020-07-24
/// Creator:wangpf
/// Table:CT.DHCINM.DB.MgReAdmItem
/// Input: 
/// Output:专科护士再认证项目列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMDBComm","FindReAdmItemList")
Query FindReAdmItemList() As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindReAdmItemListExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s id="" f  s id=$o(^CT.DHCINM.DB.MgReAdmItemD(id)) q:id=""  d
	.s ret=..GetReAdmItem(id)
	.d OutItemList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutItemList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindReAdmItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindReAdmItemListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindReAdmItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindReAdmItemListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:liwenzhen
/// Createdate:2020-07-16
/// Description:保存调查表
/// Input:
/// Output:
/// Other: w ##class("web.INMDBComm").SaveSurveyForm("RowId|^Code|1^Type|S^Desc|1^Relevant|15__1,15__2^StDate|2020-07-12^EndDate|^")
ClassMethod SaveSurveyForm(parr As %String) As %String
{
	q:parr="" "入参为空"
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("RowId"))
	s ret=""
	i rw="" d
	.s obj=##class(CF.DHCINM.DB.SurveyForm).%New()
	e  d
	.s obj=##class(CF.DHCINM.DB.SurveyForm).%OpenId(rw)
	s className="CF.DHCINM.DB.SurveyForm"
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:p="Relevant"
	.s ptype=^oddCOM(className,"a",p,"P","XSDTYPE")
	.q:'$d(tmp(p))
	.s value=$tr(tmp(p)," ","")
	.i (ptype="date")&&(value'="") d
	..s value=$zdh(value,3)
	.s $ZOBJPROPERTY(obj,p)=value
	s Relevant=$g(tmp("Relevant"))
	i Relevant'="" d
	.d obj.Relevant.Clear()
	.f i=1:1:$l(tmp("Relevant"),",") d
	..s relevant=$p(tmp("Relevant"),",",i)
	..q:relevant=""
	..d obj.Relevant.Insert(relevant)
	s Situation=$g(tmp("Situation"))
	i Situation'="" d
	.d obj.Situation.Clear()
	.f i=1:1:$l(tmp("Situation"),",") d
	..s Situation=$p(tmp("Situation"),",",i)
	..q:Situation=""
	..d obj.Situation.Insert(Situation)
	s sc=obj.%Save()
	q sc
}

/// Creator:liwenzhen
/// Createdate:2020-07-16
/// Description:保存问卷说明或随访未完成情况
/// Input:
/// Output:
/// Other: w ##class("web.INMDBComm").SaveInSurvey("RowId|5^Situation|已随访」」0「未随访」」1")
ClassMethod SaveInSurvey(parr As %String, type As %String) As %String
{
	q:parr="" "入参为空"
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("RowId"))
	q:rw="" "RowId为空"
	s ret=""
	s obj=##class(CF.DHCINM.DB.SurveyForm).%OpenId(rw)
	i type="E" d
	.s obj.Explain=$g(tmp("Explain"))
	e  d
	.d obj.Situation.Clear()
	.f i=1:1:$l(tmp("Situation"),"「") d
	..s Situation=$p(tmp("Situation"),"「",i)
	..q:Situation=""
	..d obj.Situation.Insert(Situation)
	s sc=obj.%Save()
	q sc
}

/// Creator:liwenzhen
/// Createdate:2020-07-16
/// Description:删除调查表
/// Input:
/// Output:
/// Other: w ##class("web.INMDBComm").DeleteSurveyForm()
ClassMethod DeleteSurveyForm(rowId As %String) As %String
{
	s releaseId=$O(^DHCINM.Survey.MgSurveyReleaseI("surveyContent"," "_rowId,""))
	q:releaseId'="" "该表单已被使用，不能删除！"
	s sc=##class(CF.DHCINM.DB.SurveyForm).%DeleteId(rowId)
	q $$$ISOK(sc)
}

/// Creator:liwenzhen
/// Createdate:2020-07-16
/// Description:查询调查表
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMDBComm","FindSurveyForm","","",0,0)
Query FindSurveyForm(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindSurveyFormExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s ^TMP("FindSurveyForm")=parr_"%"_input
	s repid=$I(^CacheTemp)
	s ind=1
	s descInput=$P(parr,"^",1)		
	s ret=""
	s type="" f  s type=$o(^CF.DHCINM.DB.SurveyFormI("type",type)) q:type=""  d
	.s evId="" f  s evId=$O(^CF.DHCINM.DB.SurveyFormI("type",type,evId)) q:evId=""  d	
	..s obj=##class(CF.DHCINM.DB.SurveyForm).%OpenId(evId)
	..s FormDesc=obj.FormDesc
	..q:(descInput'="")&&(FormDesc'[descInput)
	..s ret="RowId|"_evId
	..s ret=ret_"^Code|"_obj.Code_"^FormDesc|"_obj.FormDesc_"^Type|"_$case(obj.Type,"S":"护理调查","E":"护理评价",:"")
	..s Relevant=""
	..s len=obj.Relevant.Count()
	..f j=1:1:len d
	...s relevantId=obj.Relevant.GetAt(j)
	...q:relevantId=""
	...s item=$lg((^CT.DHCINM.Set.MgSysParamSubD($p(relevantId,"||",1),$p(relevantId,"||",2))),3)
	...i Relevant="" s Relevant=item
	...e  s Relevant=Relevant_","_item
	..s ret=ret_"^Relevant|"_Relevant
	..s status="启用"
	..s:(+$h<obj.StDate)||((obj.EndDate'="")&&(+$h>=obj.EndDate)) status="停用"
	..s ret=ret_"^Status|"_status
	..d OutSurveyForm
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutSurveyForm
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:liwenzhen
/// Createdate:2020-07-16
/// Description:根据rowId查询调查表
/// Input:
/// Output:
/// Other:w ##class("web.INMDBComm").GetSurveyFormData("1")
ClassMethod GetSurveyForm(rowId As %String) As %String
{
	q:rowId="" ""
	s ret=""
	s obj=##class(CF.DHCINM.DB.SurveyForm).%OpenId(rowId)
	q:'$IsObject(obj) ""
	s Relevant=""
	s len=obj.Relevant.Count()
	f j=1:1:len d
	.s relevantId=obj.Relevant.GetAt(j)
	.q:relevantId=""
	.s item=$tr(relevantId,"||","__")
	.i Relevant="" s Relevant=item
	.e  s Relevant=Relevant_","_item
	s StDate=$zd(obj.StDate,3)
	s EndDate=""
	s:obj.EndDate'="" EndDate=$zd(obj.EndDate,3)
	s ret="Code|"_obj.Code_"^Type|"_obj.Type_"^FormDesc|"_obj.FormDesc_"^Relevant|"_Relevant_"^RowId|"_rowId
	s ret=ret_"^StDate|"_StDate_"^EndDate|"_EndDate
	q ret
}

/// Creator:liwenzhen
/// Createdate:2020-07-26
/// Description:根据rowId获取问卷说明或随访未完成情况
/// Input:
/// Output:
/// Other:w ##class("web.INMDBComm").GetExplain("1","S")
ClassMethod GetExplain(rowId As %String, type As %String) As %String
{
	q:rowId="" ""
	s ret=""
	s obj=##class(CF.DHCINM.DB.SurveyForm).%OpenId(rowId)
	q:'$IsObject(obj) ""
	i type="E" d
	.s ret=""_$replace($tr(obj.Explain," ",""),$c(10),"")
	e  d
	.s Situation=""
	.f i=1:1:obj.Situation.Count()  d
	..s rowData=obj.Situation.GetAt(i)
	..q:rowData=""
	..i Situation="" d
	...s Situation=rowData
	..e  d
	...s Situation=Situation_"「"_rowData
	.s ret=Situation
	s ret="Explain|"_ret
	q ret
}

/// Creator:liwenzhen
/// Createdate:2020-07-16
/// Description:判断调查表code是否存在
/// Input:
/// Output: 1：已存在 0：不存在
/// Other: w ##class("web.INMDBComm").IsExistSurCode("RowId|^Code|cs^Type|S^FormDesc|ddd^Relevant|16__2^StDate|2021-03-16^EndDate|^IsCount|^TotalScore|^")
ClassMethod IsExistSurCode(parr As %String) As %String
{
	s ^TMP("existcode")=parr
	s tmp=""
	s flag=1
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowId"))
	s rowid=$O(^CF.DHCINM.DB.SurveyFormI("code"," "_$zcvt($g(tmp("Code")),"U"),""))
	i (rowid="")||(rowid=id) s flag=0
	q flag
}

/// Creator:liwenzhen
/// Createdate:2020-07-16
/// Description:保存调查表子表
/// Input:
/// Output:
/// Other: w ##class("web.INMDBComm").SaveSurveyFormSub("QuesTypeDesc|单选^QuesDesc|您对入院护士的接待是否满意^QuesType|S^WriteTips|^QuesOption|是」1」」「否」0」」^IsRequired|^JumpType|^ArrangeType|^RowId|^QuesScore|1^Parref|4")
ClassMethod SaveSurveyFormSub(parr As %String) As %String
{
	q:parr="" "入参为空"
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s parref=$g(tmp("Parref"))
	q:parref="" "保存失败"
	s rw=$g(tmp("RowId"))
	s ret=""
	Ts
	s parObj=##class(CF.DHCINM.DB.SurveyForm).%OpenId(parref)
	i rw="" d
	.s obj=##class(CF.DHCINM.DB.SurveyFormSub).%New()
	.s obj.Status="Y"
	.s parObj.TotalScore=parObj.TotalScore+$g(tmp("QuesScore"))
	.s sort=$o(^CF.DHCINM.DB.SurveyFormSubI("parr",parref,""),-1)+1
	.s obj.QuesSort=sort
	e  d
	.s obj=##class(CF.DHCINM.DB.SurveyFormSub).%OpenId(rw)
	.s parObj.TotalScore=parObj.TotalScore-obj.QuesScore+$g(tmp("QuesScore"))
	s flag=1
	s flag=$$$ISOK(parObj.%Save())
	s className="CF.DHCINM.DB.SurveyFormSub"
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:p="QuesOption"
	.q:p="QuesSort"
	.s ptype=^oddCOM(className,"a",p,"P","XSDTYPE")
	.q:'$d(tmp(p))
	.s value=$g(tmp(p))
	.i ($g(tmp("QuesType"))="多项填空")&&(p="QuesDesc") d
	..s value=$tr(value,"|","_")
	.s:p'="ArrangeType" value=$zcvt($tr(value," ",""),"U")
	.i ((ptype="date")&&(value'="")) d
	..s value=$zdh(value,3)
	.s $ZOBJPROPERTY(obj,p)=value
 	s obj.Parref=##class(CF.DHCINM.DB.SurveyForm).%OpenId(parref)
	s QuesOption=$g(tmp("QuesOption"))
	d obj.QuesOption.Clear()
	f i=1:1:$L(QuesOption,"「") d
	.s itm=$P(QuesOption,"「",i)
	.q:itm=""
	.d obj.QuesOption.Insert(itm)
	s flag=$$$ISOK(obj.%Save())
	i flag=1 d
	.TC
	e  d
	.TRo
	q flag
}

/// Creator:liwenzhen
/// Createdate:2020-07-16
/// Description:获取题
/// Input:
/// Output:
/// Other:w ##class(web.INMDBComm).GetSurveyFormSub("3__7")
ClassMethod GetSurveyFormSub(rowId As %String) As %String
{
	s:rowId["__" rowId=$tr(rowId,"__","||")
	s obj=##class(CF.DHCINM.DB.SurveyFormSub).%OpenId(rowId)
	q:'$IsObject(obj) ""
	s ret="RowId|"_$tr(rowId,"||","__")
	s className="CF.DHCINM.DB.SurveyFormSub"
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:p="QuesOption"
	.s value=$ZOBJPROPERTY(obj,p)
	.s:p="RelatedQues" value=$tr(value,"||","__")
	.s ptype=$g(^oddCOM(className,"a",p,"P","XSDTYPE"))
	.i ((ptype="date")&&(value'="")) d
	..s value=##class(web.INMHISComm).DateLogicalToHtml(value)
	.i ((ptype="time")&&(value'="")) d
	..s value=$zt(value)
	.s ret=ret_"^"_p_"|"_value
	s QuesOption=""
	f i=1:1:obj.QuesOption.Count()  d
	.s rowData=obj.QuesOption.GetAt(i)
	.q:rowData=""
	.i QuesOption="" d
	..s QuesOption=rowData
	.e  d
	..s QuesOption=QuesOption_"「"_rowData
	s ret=ret_"^QuesOption|"_QuesOption
	q ret
}

/// Creator:liwenzhen
/// Createdate:2020-07-16
/// Description:查询调查表维护
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMDBComm","FindSurveyFormSub","7","",0,0)
Query FindSurveyFormSub(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindSurveyFormSubExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s ^TMP("FindSurveyFormSub")=parr_"%"_input
	s repid=$I(^CacheTemp)
	s ind=1
	s parref=$P(parr,"^",1)	
	s type=$P(parr,"^",2)
	s ret=""
	s sort="" f  s sort=$o(^CF.DHCINM.DB.SurveyFormSubI("parr",parref,sort)) q:sort=""  d
	.s id="" f  s id=$O(^CF.DHCINM.DB.SurveyFormSubI("parr",parref,sort,id)) q:id=""  d	
	..s obj=##class(CF.DHCINM.DB.SurveyFormSub).%OpenId(parref_"||"_id)
	..q:'$IsObject(obj)
	..s QuesStatus=obj.Status
	..q:(type'="")&&(type'=QuesStatus)
	..s QuesDesc=obj.QuesDesc
	..s QuesType=obj.QuesType
	..s WriteTips=obj.WriteTips
	..s IsRequired=$zcvt(obj.IsRequired,"L")
	..s:IsRequired="" IsRequired="false"
	..s JumpType=obj.JumpType
	..s ArrangeType=obj.ArrangeType
	..s IsCount=obj.IsCount
	..s QuesOption=""
	..s Answer=""
	..f i=1:1:obj.QuesOption.Count()  d
	...s rowData=obj.QuesOption.GetAt(i)
	...q:rowData=""
	...s:$p(rowData,"」",4)="true" Answer=$p(rowData,"」",5)
	...i QuesOption="" d
	....s QuesOption=rowData
	...e  d
	....s QuesOption=QuesOption_"「"_rowData
	..s Rules=IsRequired_"」不能为空"
	..s QuesMin=obj.QuesMin
	..s:(QuesMin="")&&(QuesType="滑动") QuesMin=0
	..s QuesMax=obj.QuesMax
	..s:(QuesMax="")&&(QuesType="滑动") QuesMax=100
	..s RelatedQues="",RelatedSub="",RelatedSort="",RelatedSubSort=""
	..i obj.RelatedQues'="" d
	...s RelatedQues=obj.RelatedQues
	...s RelatedSub=obj.RelatedSub
	...s RelatedSort=$lg(^CF.DHCINM.DB.SurveyFormSubD($p(RelatedQues,"||",1),$p(RelatedQues,"||",2)),4) //题目序号
	...f m=1:1:$l(RelatedSub,",") d
	....s:RelatedSubSort'="" RelatedSubSort=RelatedSubSort_","_($p(RelatedSub,",",m)+1)
	....s:RelatedSubSort="" RelatedSubSort=($p(RelatedSub,",",m)+1) 
	..s showFlag=..GetQuesShowFlag(parref,id,"N")
	..s ret="RowId|"_parref_"__"_id_"^Answer|"_Answer
	..s ret=ret_"^QuesDesc|"_QuesDesc_"^QuesType|"_QuesType_"^WriteTips|"_WriteTips_"^IsRequired|"_IsRequired
	..s ret=ret_"^QuesOption|"_QuesOption_"^JumpType|"_JumpType_"^ArrangeType|"_ArrangeType_"^IsCount|"_IsCount
	..s ret=ret_"^Rules|"_Rules_"^QuesScore|"_obj.QuesScore_"^QuesStatus|"_QuesStatus
	..s ret=ret_"^QuesMin|"_QuesMin_"^QuesMax|"_QuesMax_"^QuesMinDesc|"_obj.QuesMinDesc_"^QuesMaxDesc|"_obj.QuesMaxDesc
	..s ret=ret_"^InputHeight|"_obj.InputHeight_"^InputWidth|"_obj.InputWidth_"^RelatedQues|"_$tr(RelatedQues,"||","__")_"^RelatedSub|"_RelatedSub
	..s ret=ret_"^RelatedSort|"_RelatedSort_"^RelatedSubSort|"_RelatedSubSort_"^ShowFlag|"_showFlag
	..i type'="Y"  d
	...s ret=ret_"^Sort|"_obj.QuesSort
	...d OutSurveyFormSub
	..e  d
	...s tmp(sort)=ret
	i type="Y" d
	.s num=0
	.s sort=""  f  s sort=$o(tmp(sort)) q:sort=""  d
	..s num=num+1
	..s ret=tmp(sort)_"^Sort|"_num
	..d OutSurveyFormSub
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutSurveyFormSub
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:liwenzhen
/// Createdate:2020-07-16
/// Description:查询调查表
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMDBComm","FindSurveyFormByRe","RotNurseAssess","","",0,0)
Query FindSurveyFormByRe(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindSurveyFormByReExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s ^TMP("FindSurveyForm")=parr_"%"_input
	s repid=$I(^CacheTemp)
	s ind=1
	s relevant=$P(parr,"^",1)		
	s ret=""
	s type="" f  s type=$o(^CF.DHCINM.DB.SurveyFormI("type",type)) q:type=""  d
	.s evId="" f  s evId=$O(^CF.DHCINM.DB.SurveyFormI("type",type,evId)) q:evId=""  d	
	..s obj=##class(CF.DHCINM.DB.SurveyForm).%OpenId(evId)
	..s status="启用"
	..s:(+$h<obj.StDate)||((+$h>obj.EndDate)&&(obj.EndDate'="")) status="停用"
	..q:status="停用"
	..s Relevant=""
	..s len=obj.Relevant.Count()
	..s flag=0
	..f j=1:1:len q:flag=1  d
	...s relevantId=obj.Relevant.GetAt(j)
	...q:relevantId=""
	...s code=$lg((^CT.DHCINM.Set.MgSysParamSubD($p(relevantId,"||",1),$p(relevantId,"||",2))),2)
	...b ;001
	...i (relevant'="")&&(relevant=code) s flag=1
	..q:flag=0
	..s FormDesc=obj.FormDesc
	..s ret="RowId|"_evId
	..s ret=ret_"^Code|"_obj.Code_"^Desc|"_obj.FormDesc_"^Type|"_$case(obj.Type,"S":"护理调查","E":"护理评价",:"")
	..s ret=ret_"^Status|"_status
	..d OutSurveyForm
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutSurveyForm
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:liwenzhen
/// Createdate:2020-07-28
/// Description:移动题
/// Input:
/// Output:
/// Other: w ##class("web.INMDBComm").MoveQuestion("4__1^0")
ClassMethod MoveQuestion(parr As %String) As %String
{
	q:parr="" "入参为空"
	s rowId=$tr($p(parr,"^",1),"__","||")
	s parId=$p(rowId,"||",1) //父表id
	s newSort=$p(parr,"^",2)
	s tmpSort=""
	s subObj=##class(CF.DHCINM.DB.SurveyFormSub).%OpenId(rowId)
	q:'$IsObject(subObj) "保存失败"
	s oldSort=subObj.QuesSort
	s num=newSort-oldSort 
	i $p(num,"-",2)'="" d 
	.f i=newSort:1:(oldSort-1) d
	..s id=$O(^CF.DHCINM.DB.SurveyFormSubI("parr",parId,i,""))
	..q:id=""
	..s sort=$lg(^CF.DHCINM.DB.SurveyFormSubD(parId,id),4)+1  // 负数上移
	..s tmpSort(parId_"||"_id)=sort
	e  d 
	.f i=(oldSort+1):1:newSort d
	..s id=$O(^CF.DHCINM.DB.SurveyFormSubI("parr",parId,i,""))
	..q:id=""
	..s sort=$lg(^CF.DHCINM.DB.SurveyFormSubD(parId,id),4)-1  // 正数下移
	..s tmpSort(parId_"||"_id)=sort
	s updateFlag=0
	s id="" f  s id=$o(tmpSort(id)) q:id=""  d
	.s obj=##class(CF.DHCINM.DB.SurveyFormSub).%OpenId(id)
	.s obj.QuesSort=tmpSort(id)
	.s sc=obj.%Save()
	.s updateFlag=1
	q:updateFlag=0 "无数据修改"
	s subObj.QuesSort=newSort
	s sc=subObj.%Save()
	q sc
}

/// Creator:liwenzhen
/// Createdate:2020-07-28
/// Description:作废或撤销作废题
/// Input:
/// Output:
/// Other: w ##class("web.INMDBComm").ChangeQuesStatus("4__2^N")
ClassMethod ChangeQuesStatus(parr As %String) As %String
{
	q:parr="" "入参为空"
	s rowId=$tr($p(parr,"^",1),"__","||")
	s type=$p(parr,"^",2)
	s obj=##class(CF.DHCINM.DB.SurveyFormSub).%OpenId(rowId)
	q:'$IsObject(obj) "操作失败"
	s obj.Status=type
	s sc=obj.%Save()
	q sc
}

/// Creator:liwenzhen
/// Createdate:2021-04-06
/// Description:查询可关联题目
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMDBComm","FindQuestions","1","1__3","G")
Query FindQuestions(parr As %String = "", rowId As %String = "", type As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindQuestionsExecute(ByRef qHandle As %Binary, parr As %String = "", rowId As %String = "", type As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s parref=$P(parr,"^",1)	
	s ret=""
	s:rowId["__" rowId=$tr(rowId,"__","||")
	s subObj=##class(CF.DHCINM.DB.SurveyFormSub).%OpenId(rowId)
	i '$IsObject(subObj) d
	.s sort=$o(^CF.DHCINM.DB.SurveyFormSubI("parr",parr,""),-1)
	e  d
	.s sort=subObj.QuesSort
	i type="G" d  s order=-1
	e  d  s order=1
	s tmp=""
	f  s sort=$o(^CF.DHCINM.DB.SurveyFormSubI("parr",parr,sort),order) q:sort=""  d
	.s id="" f  s id=$O(^CF.DHCINM.DB.SurveyFormSubI("parr",parr,sort,id)) q:id=""  d	
	..s obj=##class(CF.DHCINM.DB.SurveyFormSub).%OpenId(parr_"||"_id)
	..q:'$IsObject(obj)
	..q:obj.Status'="Y"
	..q:(obj.QuesType'="单选")&&(obj.QuesType'="多选")&&(type="G")
	..s QuesDesc=sort_"、"_obj.QuesDesc_"["_obj.QuesType_"]"
	..s ret="RowId|"_parr_"__"_id_"^QuesDesc|"_QuesDesc
	..s tmp(sort)=ret
	s sort="" f  s sort=$o(tmp(sort)) q:sort=""  d
	.s ret=$g(tmp(sort))
	.d OutSurveyFormSub

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutSurveyFormSub
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:liwenzhen
/// Createdate:2021-04-06
/// Description:判断当前题目是否显示
/// Input:surveyDR父表ID，subId子表ID，type是否已保存
/// Output:
/// Other: w ##class(web.INMDBComm).GetQuesShowFlag("1","4","N")
ClassMethod GetQuesShowFlag(surveyDR As %String, subId As %String, type As %String) As %String
{
	s flag="Y"
	q:surveyDR="" "N"
	i type="N" d
	.s obj=$g(^CF.DHCINM.DB.SurveyFormSubD(surveyDR,subId))
	.s parr=surveyDR
	.s relatedQues=$lg(obj,20)
	.s relatedSub=$lg(obj,21)
	e  d
	.s quesDR=$lg(^DHCINM.Survey.MgFormSubD(surveyDR,subId),12)
	.s obj=$g(^CF.DHCINM.DB.SurveyFormSubD($p(quesDR,"||",1),$p(quesDR,"||",2)))
	.s parr=$p(quesDR,"||",1)
	.s relatedQues=$lg(obj,20)
	.s relatedSub=$lg(obj,21)
	.s relatedId=$o(^DHCINM.Survey.MgFormSubI("quesDR",surveyDR," "_relatedQues,""))
	.s answer=$lg(^DHCINM.Survey.MgFormSubD(surveyDR,relatedId),11)
	s tmpJump(" N")=" N",tmpJump(" X")=" X"
	s jumpType="" f  s jumpType=$o(tmpJump(jumpType)) q:(jumpType="")||(flag="N")  d
	.s quesSort="" f  s quesSort=$o(^CF.DHCINM.DB.SurveyFormSubI("JumpType",parr,jumpType,quesSort)) q:(quesSort="")||(flag="N")  d
	..q:quesSort>=$lg(obj,4)
	..s id="" f  s id=$o(^CF.DHCINM.DB.SurveyFormSubI("JumpType",parr,jumpType,quesSort,id)) q:(id="")||(flag="N")  d
	...s prvObj=$g(^CF.DHCINM.DB.SurveyFormSubD(parr,id))
	...q:$lg(prvObj,12)="N" // 状态为作废时，直接显示
	...s prvRelatedQues=$lg(prvObj,20)
	...q:prvRelatedQues=""
	...s prvRelatedSub=$lg(prvObj,21)
	...s RelatedQuesSort=$lg(^CF.DHCINM.DB.SurveyFormSubD($p(prvRelatedQues,"||",1),$p(prvRelatedQues,"||",2)),4)
	...q:RelatedQuesSort<=$lg(obj,4) //判断当前题目是否在两个跳题之间
	...i type="N" d 
	....q:($lg(prvObj,3)'="单选")&&($lg(prvObj,3)'="多选")
	....s quesOption=$lg(prvObj,10) //判断未保存状态下，存在默认答案的情况
	....f i=1:1:$ll(quesOption) q:flag="N"  d
	.....s isDefault=$p($lg(quesOption,i),"」",4)
	.....q:isDefault'="true"
	.....s index=$p($lg(quesOption,i),"」",5)
	.....i (((","_prvRelatedSub_",")[(","_index_",")))||(jumpType=" N") s flag="N"
	q:flag="N" "N"
	q:$lg(obj,7)'="G" "Y"
	i type="Y" d
	.f i=1:1:$l(relatedSub,",") q:flag="Y"  d
	.i (","_answer_",")[(","_$p(relatedSub,",",i)_",") s flag="Y"
	.e  s flag="N"
	i type="N" d
	.s relatedObj=""
	.s:(relatedQues'="") relatedObj=$g(^CF.DHCINM.DB.SurveyFormSubD($p(relatedQues,"||",1),$p(relatedQues,"||",2)))
	.s quesOption=$lg(relatedObj,10)
	.q:$lg(relatedObj,12)="N"
	.s flag="N"
	.f m=1:1:$ll(quesOption) q:flag="Y"  d
	..s isDefault=$p($lg(quesOption,m),"」",4)
	..q:isDefault'="true"
	..s index=$p($lg(quesOption,m),"」",5)
	..i (","_relatedSub_",")[(","_index_",") s flag="Y"
	..e  s flag="N"
	q flag
}

/// Creator:liwenzhen
/// Createdate:2021-04-20
/// Description:改变答案后获取显示的题目
/// Input:
/// Output:
/// Other:【弃用】
/// Test:d ##class(%ResultSet).RunQuery("web.INMDBComm","FindShowQues","2__2","0","Y")
Query FindShowQues(rowId As %String = "", answer As %String = "", type As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindShowQuesExecute(ByRef qHandle As %Binary, rowId As %String = "", answer As %String = "", type As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s curId=$tr(rowId,"__","||")
	s curParr=$p(curId,"||",1)
	s curObj=$g(^DHCINM.Survey.MgFormSubD($p(curId,"||",1),$p(curId,"||",2)))
	i type="Y" d
	.s quesDR=$lg(curObj,12) ;DB子表Id
	.s parr=$p(quesDR,"||",1) ;DB父表Id
	e  d
	.s quesDR=curId
	.s parr=$p(curId,"||",1)
	s id="" f  s id=$o(^CF.DHCINM.DB.SurveyFormSubI("related",parr," "_quesDR,id)) q:id=""  d
	.s relatedObj=$g(^CF.DHCINM.DB.SurveyFormSubD(parr,id))
	.s relatedSub=$lg(relatedObj,21)
	.s showFlag="N"
	.s:(","_relatedSub_",")[(","_answer_",") showFlag="Y"
	.s RowId=id
	.i type="Y" d
	..s RowId=curParr_"__"_$o(^DHCINM.Survey.MgFormSubI("quesDR",curParr," "_parr_"||"_id,""))
	.s ret="RowId|"_RowId_"^ShowFlag|"_showFlag
	.d OutQuestion
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQuestion
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:lulin
/// Createdate:2020-06-13
/// Description:保存医院
/// Input:parr
/// Output:
/// Other:
ClassMethod SaveHospitalSet(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))'="" d
	.s obj=##class(CF.DHCINM.DB.MgHospitalSet).%OpenId(tmp("rw"))
	e  s obj=##class(CF.DHCINM.DB.MgHospitalSet).%New()
	s obj.HospitalName=$g(tmp("HospitalName"))
	i $g(tmp("StartDate"))'="" s obj.StartDate=$zdh(tmp("StartDate"),3)
	e  s obj.StartDate=""
	i $g(tmp("EndDate"))'="" s obj.EndDate=$zdh(tmp("EndDate"),3)
	e  s obj.EndDate=""
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:lulin
/// Createdate:2020-06-13
/// Description:获取医院信息
/// Input:id
/// Output:
/// Other:
ClassMethod GetHospitalSet(id As %String) As %String
{
	q:id="" ""
	s obj=##class(CF.DHCINM.DB.MgHospitalSet).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^HospitalName|"_obj.HospitalName
	i obj.StartDate'="" s ret=ret_"^StartDate|"_$zd(obj.StartDate,3)
	i obj.EndDate'="" s ret=ret_"^EndDate|"_$zd(obj.EndDate,3)
	q ret
}

/// Creator:lulin
/// Createdate:2020-06-13
/// Description:查询医院列表
/// Input:parr
/// Output:
/// Other:
Query FindHospitalSetList(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindHospitalSetListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s status=$P(parr,"^",1)
	s rw="" f  s rw=$O(^CF.DHCINM.DB.MgHospitalSetD(rw)) q:rw=""  d
	.s objlb=$g(^CF.DHCINM.DB.MgHospitalSetD(rw))
	.q:objlb=""
	.s stDate=$lg(objlb,3)
	.s endDate=$lg(objlb,4)
	.q:((status="Y")&&(stDate'="")&&(stDate>+$H))
	.q:((status="Y")&&(endDate'="")&&(endDate<+$H))
	.s ret=..GetHospitalSet(rw)
	.d OutPutRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHospitalSetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHospitalSetListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindHospitalSetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHospitalSetListExecute ]
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

/// Other: w ##class("web.INMDBComm").ChangeQues("")
ClassMethod ChangeQues(parr As %String) As %String
{
	s parref="" f  s parref=$o(^CF.DHCINM.DB.SurveyFormSubI("parr",parref)) q:parref=""  d
	.s sort="" f  s sort=$o(^CF.DHCINM.DB.SurveyFormSubI("parr",parref,sort)) q:sort=""  d
	..s id="" f  s id=$O(^CF.DHCINM.DB.SurveyFormSubI("parr",parref,sort,id)) q:id=""  d	
	...s obj=##class(CF.DHCINM.DB.SurveyFormSub).%OpenId(parref_"||"_id)
	...s QuesOption=""
	...f i=1:1:obj.QuesOption.Count()  d
	....s rowData=obj.QuesOption.GetAt(i)
	....q:rowData=""
	....s rowData=rowData_"」"_(i-1)
	....i QuesOption="" d
	.....s QuesOption=rowData
	....e  d
	.....s QuesOption=QuesOption_"「"_rowData
	...d obj.QuesOption.Clear()
	...f i=1:1:$L(QuesOption,"「") d
	....s itm=$P(QuesOption,"「",i)
	....q:itm=""
	....d obj.QuesOption.Insert(itm)
	...s sc=obj.%Save()
	q sc
}

/// Creator:lulin
/// Createdate:2020-08-10
/// Description:引用CTLoc信息到护管中
/// Input:
/// Output:
/// Other:w ##class(web.INMDBComm).SaveWardLocCTLoc(326,"W")
ClassMethod SaveWardLocCTLoc(parr As %String, type As %String) As %String
{
	q:((type'="W")&&(type'="L")) "未获取有效信息"
	s saveFlag=1
	TS
	f i=1:1:$L(parr,"^") q:saveFlag'=1  d
	.s id=$P(parr,"^",i)
	.q:id=""
	.s flag=0
	.s wardid=$O(^CF.DHCINM.DB.MgWardI("CTLoc",id,""))
	.s:wardid'="" flag=1
	.i flag=0 d
	..s wardLocId=$O(^CF.DHCINM.DB.MgWardLocI("Loc",id,""))
	..s:wardLocId'="" flag=1
	.q:flag=1
	.s obj=##class(User.CTLoc).%OpenId(id)
	.q:'$IsObject(obj)
	.i type="L" d
	..s locObj=##class(CF.DHCINM.DB.MgWardLoc).%New()
	..s locObj.CTLocDR=obj
	..s locObj.LocCode=obj.CTLOCCode
	..s locObj.LocDesc=obj.CTLOCDesc
	..s locObj.LocStDate=+$H
	..s saveFlag=(saveFlag&&($$$ISOK(locObj.%Save())))
	.e  d
	..s wardObj=##class(CF.DHCINM.DB.MgWard).%New()
	..s wardObj.CTLocDR=obj
	..s wardObj.WardCode=obj.CTLOCCode
	..s wardObj.WardDesc=obj.CTLOCDesc
	..s wardObj.WardTypeDR=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId("1||1")
	..s wardObj.CTHospitalDR=obj.CTLOCHospitalDR
	..s wardObj.WardSpell=obj.CTLOCContactName
	..s wardObj.WardStDate=+$H
	..s wardObj.WardSort=$O(^CF.DHCINM.DB.MgWardI("Sort",""),-1)+1
	..s sc=$$$ISOK(wardObj.%Save())
	..s saveFlag=(saveFlag&&sc)
	..b ;001
	if saveFlag=1{
		TC
		q 1	
	}else{
		TRO
		q "保存失败"	
	}
}

/// Creator:lulin
/// Createdate:2020-12-11
/// Description:保存理论导入项目维护子表
/// Input:
/// Output:
/// Other:
ClassMethod SaveImportTeachTheorySub(parr As %String, index) As %String
{
	s result=..SaveTeachTheorySub(parr)
	if result["||"{
		q index	
	}else{
		q "第"_index+2_"行"_result	
	}
}

/// Creator:gyg
/// Createdate:
/// Description:获取病区意愿班次信息列表
/// Input:
/// Output:
/// Other: d ##class(%ResultSet).RunQuery("web.INMDBComm","FindWardWishPostList","^1^P")
Query FindWardWishPostList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardWishPostListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s postdr=$P(parr,"^",1)
	s warddr=$P(parr,"^",2)
	s type=$P(parr,"^",3)
	i (postdr="")&&(warddr="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	i postdr'="" d
	.s id="" f  s id=$O(^CF.DHCINM.DB.MgArgWardPostI("Post",postdr,id)) q:id=""  d
	..s obj=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(id)
	..q:(warddr'="")&&(obj.WardDR'="")&&(warddr'=obj.WardDR.%Id())
	..q:obj.PostDR.PostStatus'="Y"
	..s ret=..GetWardPost(id)
	..d OutWardPost
	e  d
	.s sort="" f  s sort=$O(^CF.DHCINM.DB.MgArgWardPostI("WardSort",warddr,sort)) q:sort=""  d
	..s id="" f  s id=$O(^CF.DHCINM.DB.MgArgWardPostI("WardSort",warddr,sort,id)) q:id=""  d
	...s obj=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(id)
	...q:obj.PostDR.PostStatus'="Y"
	...s posttype=obj.PostDR.PostType
	...s flag=0 //成都第二用于筛选意愿排班休假班次
	...i (posttype="H") d
	....i (obj.PostDR.IsWishPost="Y") d
	.....s flag=1
	...q:(type'="")&&(type'=posttype)&&(flag=0)
	...s ret=..GetWardPost(id)
	...d OutWardPost
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWardPost
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardWishPostListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardWishPostListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardWishPostListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardWishPostListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator: jyc
/// createdate:20200707
/// description:获取夜班班次列表
/// table:
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.INMDBComm","FindArgNightPostList","N","")
Query FindArgNightPostList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindArgNightPostListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s type=$P(parr,"^",1)
	s ward=$P(parr,"^",2)
	s id="" f  s id=$O(^CF.DHCINM.DB.MgArgPostD(id)) q:id=""  d
	s sort="" f  s sort=$O(^CF.DHCINM.DB.MgArgPostI("Sort",sort)) q:sort=""  d
	.s id="" f  s id=$O(^CF.DHCINM.DB.MgArgPostI("Sort",sort,id)) q:id=""  d
	..s obj=##class(CF.DHCINM.DB.MgArgPost).%OpenId(id)
	..s code=obj.PostCode
	..s desc=obj.PostDesc
	..q:(type'="")&&(obj.PostCategory'=type)
	..q:(ward'="")&&($d(^CF.DHCINM.DB.MgArgWardPostI("WardPost",ward,id))=0)
	..s ret=..GetArgPost(id)
	..d OutArgPost
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutArgPost
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindArgNightPostListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArgNightPostListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArgNightPostListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArgNightPostListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SaveImpQualSubPat(parr) As %String
{
	i $CLASSNAME(parr)'["CSP.CharacterStream" {
		s stream=##class(%CSP.CharacterStream).%New()
		d stream.Write(parr)
		s parr=stream
	}
	s flag=1
	while ('parr.AtEnd){
		s tmpParr=parr.ReadLine()
		s sc=..SaveImporQualSubData($tr(tmpParr,$c(9,10,13)))
		i +sc<0 s flag=0 q
	}
	q flag
}

ClassMethod SaveImpteaSubPat(parr) As %String
{
	i $CLASSNAME(parr)'["CSP.CharacterStream" {
		s stream=##class(%CSP.CharacterStream).%New()
		d stream.Write(parr)
		s parr=stream
	}
	s flag=1
	while ('parr.AtEnd){
		s tmpParr=parr.ReadLine()
		s sc=..SaveImportTeaOperaSub($tr(tmpParr,$c(9,10,13)))
		i +sc<0 s flag=0 q
	}
	q flag
}

/// creator: lulin
/// createdate:2021-05-22
/// description:复制质控项目
/// table:
/// input:
/// output:
/// other:w ##class(web.INMDBComm).CopyQualItem(2,2021)
ClassMethod CopyQualItem(parr As %String = "", toYear As %String = "") As %String
{
	q:((parr="")||(toYear="")) "入参为空,请重试"
	s exitRet="",sc=1,scFlag=0
	TS
	f i=1:1:$L(parr,",") q:sc'=1  d
	.s id=$P(parr,",",i)
	.q:id=""
	.s obj=##class(CT.DHCINM.DB.MgQualItem).%OpenId(id)
	.q:'$IsObject(obj)
	.s qualDesc=obj.QualDesc
	.s existFlag=0
	.i $d(^CT.DHCINM.DB.MgQualItemI("year",toYear," "_obj.QualCode))'=0 d
	..s existFlag=1
	..i exitRet="" d
	...s exitRet=qualDesc
	..e  d
	...s exitRet=exitRet_","_qualDesc
	.q:existFlag'=0
	.s newObj=##class(CT.DHCINM.DB.MgQualItem).%New()
	.s newObj.QualYear=toYear
	.s p="" f  s p=$O(^oddCOM("CT.DHCINM.DB.MgQualItem","a",p)) q:p=""  d
	..q:((p["%")||(p["ChildSub"))
	..q:(p["QualYear")
	..s $ZOBJPROPERTY(newObj,p)=$ZOBJPROPERTY(obj,p)
	.s sc=sc&&$$$ISOK(newObj.%Save())
	.q:sc'=1
	.k subParTmp
	.s subParTmp=""
	.s subId="" f  s subId=$O(^CT.DHCINM.DB.MgQualItemSubD(id,subId)) q:((subId="")||(sc'=1))  d
	..s subObj=##class(CT.DHCINM.DB.MgQualItemSub).%OpenId(id_"||"_subId)
	..q:'$IsObject(subObj)
	..s newSubObj=##class(CT.DHCINM.DB.MgQualItemSub).%New()
	..s newSubObj.Parref=newObj
	..s:subObj.SubPar'="" newSubObj.SubPar=$g(subParTmp(subObj.SubPar))
	..s subP="" f  s subP=$O(^oddCOM("CT.DHCINM.DB.MgQualItemSub","a",subP)) q:subP=""  d
	...q:((subP["%")||(subP["Parref"))
	...q:subP["SubPar"
	...s $ZOBJPROPERTY(newSubObj,subP)=$ZOBJPROPERTY(subObj,subP)
	..s sc=sc&&$$$ISOK(newSubObj.%Save())
	..s subParTmp(id_"||"_subId)=newSubObj.%Id()
	.s scFlag=1
	if sc=1 {
		TC
		s ret=1
		s:exitRet'="" ret="【"_exitRet_"】已存在"
		s:((scFlag=1)&&(exitRet'="")) ret=ret_",其他保存成功"
		q ret
	}else{
		TRO
		q "保存失败"	
	}
}

/// creator: zhengzhong
/// description: 查询医嘱项目列表
/// table: CT.DHCINM.DB.MgMOrder
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.INMDBComm","FindWorkLoadItmList","","df")
Query FindWorkLoadItmList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWorkLoadItmListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s Ret=""
    s id="" f  s id=$O(^CT.DHCINM.DB.MgMOrderD(id)) q:id=""  d
    .s Obj=##class(CT.DHCINM.DB.MgMOrder).%OpenId(id)
    .s Acronym =##class(web.INMVueComm).ToChineseSpell(Obj.WorkItm)
    .q:((input'="")&&((Obj.WorkItm_Obj.WorkCode)'[$tr(input," ",""))&&(Acronym'[$tr(input," ","")))
    .s WorkItm=Obj.WorkItm
    .s WorkCode=Obj.WorkCode
    .s WorkColor=Obj.WorkColor
    .s Ret="rowid|"_id_"^WorkItm|"_WorkItm_"^WorkCode|"_WorkCode_"^WorkColor|"_WorkColor
    .d OutWard
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutWard
    set Data=$lb(Ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod FindWorkLoadItmListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWorkLoadItmListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod FindWorkLoadItmListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWorkLoadItmListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
    }
    Else  { 
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// creator: zhengzhong
/// desc:保存医嘱配置项目表
/// table:CT.DHCINM.DB.MgMOrder
/// input:
/// output:
/// other: w ##class(web.INMDBComm).SaveWorkLoadItm("WorkItm|测试^WorkCode|test^WorkColor|red^rowid|3^")
ClassMethod SaveWorkLoadItm(parr As %String) As %String
{
    s ^TMP("SaveWorkLoadItm")=parr
    q:(parr = "") "未获取有效信息,请刷新重试" //未获取有效信息
    d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
    s code=$g(tmp("WorkCode"))
    s codeRW=$O(^CT.DHCINM.DB.MgMOrderI("WorkCode"," "_code,""))
    s rw=tmp("rowid")
    q:((codeRW'="")&&(codeRW'=rw)) "存在相同代码,不可保存"
	i $g(tmp("rowid"))'="" d
	.s obj = ##class(CT.DHCINM.DB.MgMOrder).%OpenId(tmp("rowid"))
	e  s obj = ##class(CT.DHCINM.DB.MgMOrder).%New()
	
	s obj.WorkItm =$g(tmp("WorkItm")) //项目名称
	s obj.WorkCode =$g(tmp("WorkCode")) //项目代码
	s obj.WorkColor =$g(tmp("WorkColor")) //颜色
	s sc = $$$ISOK(obj.%Save())
	if (sc=1)
	{
		q 1
	}
	else{
		q "保存失败"	
	}
}

/// creator: zhengzhong
/// description: 获取工作量配置项目列表
/// table: CT.DHCINM.DB.MgMOrder
/// input:
/// output:
/// other: w ##class(CT.DHCINM.DB.MgMOrder).GetWorkLoadItm(1)
ClassMethod GetWorkLoadItm(id As %String) As %String
{
    q:id="" ""
    s Obj=##class(CT.DHCINM.DB.MgMOrder).%OpenId(id)
    s Ret="rowid|"_id
    s Ret=Ret_"^WorkItm|"_Obj.WorkItm
    s Ret=Ret_"^WorkCode|"_Obj.WorkCode
    s WorkColor=Obj.WorkColor
    s Ret=Ret_"^WorkColor|"_WorkColor
    q Ret
}

/// creator: zhengzhong
/// description: 删除医嘱项目
/// table: CT.DHCINM.DB.MgMOrder
/// input:
/// output:
/// other:w ##class(web.INMDBComm).DeleteWorkLoadItm(1)
ClassMethod DeleteWorkLoadItm(id As %String) As %String
{
    q:id="" ""
    s Obj=##class(CT.DHCINM.DB.MgMOrder).%OpenId(id)
    i '$IsObject(Obj) q 0
    s sc=Obj.%DeleteId(id)
    q 1
}

/// creator: zhengzhong
/// desc:查询关联医嘱
/// table:CT.DHCINM.DB.MgMOrderSub
/// input: id ：选中行id 父医嘱id    input： 查询内容
/// output:
/// other:  d ##class(%ResultSet).RunQuery("web.INMDBComm","FindWorkLoadItmSub","1","")
Query FindWorkLoadItmSub(id As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWorkLoadItmSubExecute(ByRef qHandle As %Binary, id As %String = "", input As %String = "") As %Status
{
	s ^TMP("FindWorkLoadItmSub")=id_"$"_input
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    q:id="" ""
    s subID="" f  s subID=$O(^CT.DHCINM.DB.MgMOrderSubD(id,subID)) q:subID=""  d
    .s subRowId = id_"||"_subID
    .s subObj=##class(CT.DHCINM.DB.MgMOrderSub).%OpenId(subRowId)
    .q:'$IsObject(subObj)
    .s orderItmId=subObj.WorkRelArcim   ///医嘱项id
    .q:orderItmId=""
    .d OutputRow
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
    
    
OutputRow
    ;s des=$O(^ARC("ALIAS",0,"Desc",orderItmId,""))
    ;s Ret="OrdId|"_orderItmId_"^OrdItm|"_des_"^SubRowId|"_subRowId
    s ARCIMRowid=$P(orderItmId,"||",1)
    q:(ARCIMRowid="")
    s ARCIMSub=$P(orderItmId,"||",2) 
    q:ARCIMSub=""
    s ItmName=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)  ;ord name  
    s ItmName=$tr(ItmName,"|","-")
    s ItmName=$tr(ItmName,":","-")
    s ItmName=$tr(ItmName,"[","(")
    s ItmName=$tr(ItmName,"]",")")
    s ItmName=$tr(ItmName,"\","")
    s ItmName=$tr(ItmName,"'","")   //有'会报错
    ;s ItmName=$tr(ItmName,"[","(")
    ;s ItmName=$tr(ItmName,"]",")")
    s ItmSort=##class(web.INMVueComm).ToChineseSpell(ItmName)
    q:((input'="")&(ItmName'[$tr(input," ",""))&(ItmSort'[$tr($ZConvert(input,"U")," ","")))
    ;s Ret=Ret_aa_"|"_id_"-"_ItmName_"^"        OrdId,OrdItm
    s Ret="OrdId|"_orderItmId_"^OrdItm|"_ItmName_"^SubRowId|"_subRowId
    set Data=$lb(Ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod FindWorkLoadItmSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWorkLoadItmSubExecute ]
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

ClassMethod FindWorkLoadItmSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWorkLoadItmSubExecute ]
{
    Set repid=$LIST(qHandle,2)
    ;Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// creator: zhengzhong
/// desc:保存关联医嘱   "itmId|6^workRelInstruct|^workRelArcim|11548!1^"
/// table:CT.DHCINM.DB.MgMOrderSub
/// input:
/// output:
/// other: w ##class(web.INMDBComm).SaveWorkRelArcim("itmId|3^workRelArcim|11362!1,11363!1")
ClassMethod SaveWorkRelArcim(parr As %String) As %String
{
    s ^TMP("SaveWorkLoadItmSub")=parr
    q:parr="" ""
    s Sc=0
    d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
    s ItmId = ($g(tmp("itmId")))
    f i=1:1:$L($g(tmp("workRelArcim")),",") d
    .s id=$p($g(tmp("workRelArcim")),",",i)
    .q:id=""
    .s ARCIMRowid=$p(id,"!",1)
    .s ARCIMSub=$p(id,"!",2)
    .s WorkRelArcim=ARCIMRowid_"||"_ARCIMSub
    .s SubId=$O(^CT.DHCINM.DB.MgMOrderSubI("ItmArcimInstr"," "_WorkRelArcim,ItmId,""))
    .q:SubId'=""
    .s ItmObj=##class(CT.DHCINM.DB.MgMOrder).%OpenId(tmp("itmId")) ///父
    .q:'$IsObject(ItmObj)
    .s SubObj=##class(CT.DHCINM.DB.MgMOrderSub).%New() ///子
    .s SubObj.Parref=ItmObj   ///指向父
    .s SubObj.WorkRelArcim=WorkRelArcim
    .s Sc=SubObj.%Save()
    q $$$ISOK(Sc)
}

/// creator: zhengzhong
/// description: 删除关联医嘱
/// table: CT.DHCINM.DB.MgMOrderSub
/// input:
/// output:
/// other: w ##class(web.INMDBComm).DeleteWorkLoadItm(1)
ClassMethod DeleteWorkLoadItmSub(ids As %String) As %String
{
    q:ids="" ""
    f i=1:1:$L(ids,",") d
    .s id=$P(ids,",",i)
    .s Obj=##class(CT.DHCINM.DB.MgMOrderSub).%OpenId(id)
    .i '$IsObject(Obj) q
    .s sc=Obj.%DeleteId(id)
    q $$$ISOK(sc)
}

/// creator: lulin
/// description: 判断患者医嘱是否存在
/// table: CT.DHCINM.DB.MgMOrderSub
/// input:
/// output:
/// other:
ClassMethod IfOrddailyExist(EpisodeID, MgMOrderCode, stDate) As %String
{
 
 s num=$l(MgMOrderCode,"^")
 s ret=0
 for i=1:1:num q:ret=1  d
 .q:ret=1
 .s code=$p(MgMOrderCode,"^",i)
 .q:code=""
 .s id="" f  s id=$O(^CT.DHCINM.DB.MgMOrderI("WorkCode"," "_code,id)) q:id=""  d
 ..s subId="" f  s subId=$O(^CT.DHCINM.DB.MgMOrderSubD(id,subId)) q:((subId="")||(ret=1))  d
 ...s subObjLB=$g(^CT.DHCINM.DB.MgMOrderSubD(id,subId))
 ...q:subObjLB=""
 ...s WorkRelArcim=$lg(subObjLB,2)
 ...s ret=##class(web.INMHISComm).GetCareType(EpisodeID, WorkRelArcim,stDate)
 q ret
}

/// Description: 2021-09-29
/// Date: lulin
/// Creator:
/// Table:
/// Input:
/// Output: 
/// Other:
ClassMethod GetRealTime(st As %String = "", end As %String = "", index, tmpTime, date) As %String
{
	q:((st="")||(end="")) ""
	i st["次日" d
	.s st=86400+$zth($replace(st,"次日",""))
	e  d
	.s st=$zth(st)
	i end["次日" d
	.s end=86400+$zth($replace(end,"次日",""))
	e  d
	.s end=$zth(end)
	s tmpTime(index)=(date+st)_"^"_(date+end)
	q ""
}

/// Description: 检测时间冲突
/// Date: 2021-09-23
/// Creator: wangpf
/// Table:
/// Input:
/// Output: -1：格式不正确 0：不冲突 1：冲突
/// Other: w ##class(web.INMArgComm).CheckTmpRepeat(.tmp)
ClassMethod CheckTmpRepeat(tmpTime) As %String
{
	k tmp3
	s index4=1,tmp3="",flag=0
	s index2="" f  s index2=$o(tmpTime(index2)) q:(index2="")||(flag'=0)  d
	.s time1=tmpTime(index2)
	.s stTime1=$p(time1,"^")
	.s endTime1=$p(time1,"^",2)
	.s index3="" f  s index3=$o(tmp3(index3)) q:(index3="")||(flag'=0)  d
	..s time2=tmp3(index3)
	..s stTime2=$p(time2,"^")
	..s endTime2=$p(time2,"^",2)
	..i (stTime1'="")&&(endTime1'="")&&(stTime2'="")&&(endTime2'="")&&(stTime1<endTime2)&&(stTime2<endTime1) s flag=1
	.q:flag'=0
	.s tmp3(index4)=time1
	.s index4=index4+1
	q flag
}

/// Description: 病区排班组保存
/// Date: 2021-09-29
/// Creator: lulin
/// Table:
/// Input:
/// Output:
/// Other:w ##class(web.INMDBComm).SaveWardPostGroup("GroupDesc|组合1^GroupPost|129,130^rw|^GroupWard|1")
ClassMethod SaveWardPostGroup(parr As %String = "") As %String
{
	k tmp
	s tmp=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s groupWard=$g(tmp("GroupWard"))
	s rw=$g(tmp("rw"))
	s GroupPost=$g(tmp("GroupPost"))
	q:(groupWard="")||('$d(^CF.DHCINM.DB.MgWardD(groupWard))) "未获取病区数据"
	i rw="" d
	.s obj=##class(CF.DHCINM.DB.MgWardPostGroup).%New()
	e  s obj=##class(CF.DHCINM.DB.MgWardPostGroup).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.GroupDesc=$g(tmp("GroupDesc"))
	d obj.GroupWardSetObjectId(groupWard)
	d obj.GroupPost.Clear()
	k tmpTime
	s index=1
	s len=$l(GroupPost,",")
	f i=1:1:len d
	.s postId=$p(GroupPost,",",i)
	.q:(postId="")||('$d(^CF.DHCINM.DB.MgArgWardPostD(postId)))
	.s postGlo=^CF.DHCINM.DB.MgArgWardPostD(postId)
	.s tDate=(i-1)*86400
	.s st1=$lg(postGlo,6)
	.s end1=$lg(postGlo,7)
	.s st2=$lg(postGlo,8)
	.s end2=$lg(postGlo,9)
	.s st3=$lg(postGlo,18)
	.s end3=$lg(postGlo,19)
	.d ..GetRealTime(st1,end1,index,.tmpTime,tDate)
	.d ..GetRealTime(st2,end2,index+1,.tmpTime,tDate)
	.d ..GetRealTime(st3,end3,index+2,.tmpTime,tDate)
	.s index=index+3
	.d obj.GroupPost.Insert(postId)
	s flag=..CheckTmpRepeat(.tmpTime)
	q:flag'=0 "存在时间交叉"
	s sc=obj.%Save()
	if $$$ISOK(sc){
		q 1	
	}else{
		q "保存失败"
	}
}

/// Description: 病区排班组获取
/// Date: 2021-09-29
/// Creator: lulin
/// Table:
/// Input:
/// Output:
/// Other:w ##class(web.INMDBComm).GetWardPostGroup(1)
ClassMethod GetWardPostGroup(rw As %String = "") As %String
{
	q:rw="" ""
	s obj=##class(CF.DHCINM.DB.MgWardPostGroup).%OpenId(rw)
	q:'$IsObject(obj) ""
	q:'$IsObject(obj.GroupWard) ""
	s GroupDesc=obj.GroupDesc
	s GroupWard=obj.GroupWard.%Id()
	s GroupWardDesc=obj.GroupWard.WardDesc
	s GroupPost="",GroupPostDesc=""
	f i=1:1:obj.GroupPost.Count()  d
	.s postId=obj.GroupPost.GetAt(i)
	.q:(postId="")||('$d(^CF.DHCINM.DB.MgArgWardPostD(postId)))
	.s postGlo=$g(^CF.DHCINM.DB.MgArgWardPostD(postId))
	.s postName=$lg(postGlo,2)
	.i GroupPost="" s GroupPost=postId,GroupPostDesc=postName
	.e  s GroupPost=GroupPost_","_postId,GroupPostDesc=GroupPostDesc_","_postName
	s ret="GroupDesc|"_GroupDesc_"^GroupWard|"_GroupWard_"^GroupWardDesc|"_GroupWardDesc
	_"^GroupWardDesc|"_GroupWardDesc_"^GroupPost|"_GroupPost_"^GroupPostDesc|"_GroupPostDesc
	_"^rw|"_rw
	q ret
}

/// Description: 病区排班组获取
/// Date: 2021-09-29
/// Creator: lulin
/// Table:
/// Input:
/// Output:
/// Other:w ##class(web.INMDBComm).DeleteWardPostGroup(1)
ClassMethod DeleteWardPostGroup(rw As %String = "") As %String
{
	q:rw="" "入参不能为空"
	s obj=##class(CF.DHCINM.DB.MgWardPostGroup).%OpenId(rw)
	q:'$IsObject(obj) "未获取数据,请刷新重试"
	s sc=$$$ISOK(##class(CF.DHCINM.DB.MgWardPostGroup).%DeleteId(rw))
	if sc{
		q 1	
	}else{
		q "删除失败"	
	}
}

/// Description: 病区排班组列表
/// Date: 2021-09-29
/// Creator: lulin
/// Table:
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.INMDBComm","FindWardPostGroupList",1)
Query FindWardPostGroupList(WardID As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardPostGroupListExecute(ByRef qHandle As %Binary, WardID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s ret=""
    if WardID=""{
	    Set qHandle=$lb(0,repid,0)
    	Quit $$$OK
	}
	s id="" f  s id=$O(^CF.DHCINM.DB.MgWardPostGroupI("Ward",WardID,id)) q:id=""  d
	.s ret=..GetWardPostGroup(id)
	.q:ret=""
	.d OutputRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod FindWardPostGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardPostGroupListExecute ]
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

ClassMethod FindWardPostGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardPostGroupListExecute ]
{
    Set repid=$LIST(qHandle,2)
    ;Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetCommSymbol(id As %String = "") As %String
{
	q:id="" ""
	s parId=$p(id,"||"),subId=$p(id,"||",2)
	q:(+parId=0)||(+subId="") ""
	q $lg($g(^CT.DHCINM.DB.MgSetCodeSubD(parId,subId)),7)
}

}
