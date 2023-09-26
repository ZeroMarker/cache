/// 医保字典处理类
Class web.INSUDictionaryContrast Extends %RegisteredObject
{

/// 功能说明：医保字典信息获取
///           医保字典信息保存在医保字典表中，在字典中的dickey字段为[字典识别码+医保类型]
/// 入参说明：KeyCode   --> 字典识别码
///           InsuType  --> 医保类型
///           ExtStr    --> 扩展参数(检索关键字^院区)
/// w ##class(web.INSUDictionaryContrast).GetINSUDicAjax(10,1,"AKA130","BJA","门诊")
ClassMethod GetINSUDicAjax(rows, page, KeyCode As %String, InsuType As %String, ExtStr As %String) As %String
{
	s HospId=$p(ExtStr,"^",2)
	s:($g(%session)'="")&&(HospId="") HospId=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	s IDList=##class(%ListOfDataTypes).%New()
	s ^CacheTemp("GetINSUDicAjax")=$lb(rows, page, KeyCode,InsuType,ExtStr)
	i ((KeyCode'="")&&(InsuType'="")) d
	.s SearchKey=$p(ExtStr,"^",1)         ;检索关键字
	.s DicKey=KeyCode_InsuType
	.s:KeyCode="Tari" DicKey="TariType" // 此处需要处理 20200309tangzf
	.s:KeyCode="DLL" DicKey="DLLType" // 此处需要处理 20200309tangzf
	.s GroupHospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId(DicKey,HospId)
	.s rowid=""
	.f  s rowid=$o(^DHCINDID(0,"IType", DicKey, rowid)) q:rowid=""  d
	..s dicInfo=$g(^DHCINDID(rowid))
	..s dicdesc=$p(dicInfo,"^",3)
	..s quitFlg=..GetQuitFlgByDesc(SearchKey, dicdesc, "")   ;根据关键字过滤
	..q:quitFlg="1"
	..;+2019-7-30 tangzf 医院授权判断 start
	..s TmpHospital=$p($g(^DHCINDID(rowid)), "^", 15)
	..Q:GroupHospDr'=TmpHospital
	..;+2019-7-30 tangzf 医院授权判断 end
	..s objDic=##class(%ArrayOfDataTypes).%New()
	..d objDic.SetAt($p(dicInfo,"^",1),"keycode")   ;字典key
	..d objDic.SetAt($p(dicInfo,"^",2),"diccode")   ;字典编码
	..d objDic.SetAt(dicdesc,"dicdesc")             ;字典描述
	..;d objDic.SetAt($p(dicInfo,"^",4),"concode")   ;字典对照编码
	..;d objDic.SetAt($p(dicInfo,"^",5),"condesc")   ;字典对照描述
	..;d objDic.SetAt($p(dicInfo,"^",6),"common")    ;备注
	..d IDList.Insert(objDic)

	s data=##Class(%ListOfDataTypes).%New()
	s startrow=(page-1)*rows+1
	s maxrow=startrow-1+rows
	i maxrow>IDList.Size d
	.s maxrow=IDList.Size
	i maxrow<=IDList.Size d
	.f i=startrow:1:maxrow d
	..s obj=IDList.GetAt(i)
	..d data.Insert(obj)
	
	s result("total")=IDList.Size
	s result("rows")=data
	s ret=##Class(web.INSUEncodeJson).Encode(.result)
	q ret
}

/// 功能说明：获取his字典以及对照信息
/// 入参说明：KeyCode    --> 字典识别key
///           InsuType   --> 医保类别
///           HospitalNo --> 医院编码
///           ExtStr     --> 字典查询类名^字典查询方法名^检索关键字
/// s ExtStr="web.INSUDictionaryContrast^GetHisDosageList^吸入"
/// s ExtStr="web.INSUDictionaryContrast^GetQrequencyList^"
/// s ExtStr="web.INSUDictionaryContrast^GetHisDosageList^"
/// w ##class(web.INSUDictionaryContrast).GetHisDicAndConAjax(10,1,"Dosage","BJA","",ExtStr)
/// w ##class(web.INSUDictionaryContrast).GetHisDicAndConAjax(10,1,"LocCode","BJA","",ExtStr)
ClassMethod GetHisDicAndConAjax(rows, page, KeyCode As %String, InsuType As %String, HospitalNo As %String, ExtStr As %String) As %String
{
	s classNM=$p(ExtStr, "^", 1)      ;类名
	s methodNM=$p(ExtStr, "^", 2)     ;方法名
	s SearchKey=$p(ExtStr, "^", 3)      ;查询关键字
	s InsuConType=$p(ExtStr, "^", 4)      ;对照类型
	s:InsuConType="3" InsuConType=""
	
	s ^CacheTemp("GetHisDicAndConAjax")=$lb(rows,page,KeyCode,InsuType,HospitalNo,ExtStr)
	
	s IDList=##class(%ListOfDataTypes).%New()
	s haveMethodFlg=##class(websys.Conversions).IsValidMethodName(classNM, methodNM)
	i haveMethodFlg="1" d
	.i (KeyCode="DLL")||(KeyCode="Tari") d
	..s IDList=$zobjclassmethod(classNM, methodNM, SearchKey, HospitalNo, KeyCode)
	.e  d
	..s IDList=$zobjclassmethod(classNM, methodNM, SearchKey, HospitalNo, "")
	.s DicSize=IDList.Size
	.q:DicSize=0  ;没有取得字典集合时退出
	.;s IDList=##class(insuqc.utility.SortList).Sort(IDList, "HisCode", "asc")  ;排序
	 //num start
	 s ConNum=0
	 s UnConNum=0
	s data=##Class(%ListOfDataTypes).%New()
	s maxrow=IDList.Size
	s tmpIndex=1
	f i=1:1:IDList.Size d
	.s objDic=IDList.GetAt(i)
	.s HisCode=objDic.GetAt("HisCode")    ;his字典编码
	.s HisDesc=objDic.GetAt("HisDesc")    ;his字典描述
	.s conInfo=..GetContrastInfo(KeyCode, HisCode, InsuType, "1","",HospitalNo)  ;对照信息
	.i conInfo="" s UnConNum=UnConNum+1               ;add by xubaobao 2019 03 28  增加对照关系检索条件
	.i conInfo'="" s ConNum=ConNum+1
	.i conInfo="" s ConType="1"                ;add by xubaobao 2019 03 28  增加对照关系检索条件
	.i conInfo'="" s ConType="2"
	.q:(ConType'=InsuConType)&&(InsuConType'="")
	.s ^||TMPINSUContrast("GetHisDicAndConAjax",tmpIndex,HisCode,HisDesc)=conInfo
	.s tmpIndex=tmpIndex+1
	//end
	s IDListSize=$o(^||TMPINSUContrast("GetHisDicAndConAjax",""),-1)
	b //22222
	s startrow=(page-1)*rows+1
	s maxrow=startrow-1+rows
	i maxrow>IDListSize d
	.s maxrow=IDListSize
	i maxrow<=IDListSize d
	.f i=startrow:1:maxrow d
	..s HisCode=$o(^||TMPINSUContrast("GetHisDicAndConAjax",i,""))   ;his字典编码
	..s HisDesc=$o(^||TMPINSUContrast("GetHisDicAndConAjax",i,HisCode,""))    ;his字典描述
	..s conInfo=$g(^||TMPINSUContrast("GetHisDicAndConAjax",i,HisCode,HisDesc))  ;对照信息
	..i conInfo="" s ConType="1"                ;add by xubaobao 2019 03 28  增加对照关系检索条件
	..i conInfo'="" s ConType="2"
	..;q:(ConType'=InsuConType)&&(InsuConType'="")
	..s MedCode=$p(conInfo, "^", 1)        ;医保字典编码
	..s MedDesc=$p(conInfo, "^", 2)        ;医保字典描述
	..s UserNM=$p(conInfo, "^", 3)         ;操作员
	..s UpdateDt=$p(conInfo, "^", 4)       ;日期
	..s UpdateTime=$p(conInfo, "^", 5)     ;时间
	..s RowId=$p(conInfo, "^", 6)          ;对照的Dr	
	
	..s objDicCon=##class(%ArrayOfDataTypes).%New()
	..d objDicCon.SetAt(HisCode, "HisCode")
	..d objDicCon.SetAt(HisDesc, "HisDesc")
	..d objDicCon.SetAt(MedCode, "MedCode")
	..d objDicCon.SetAt(MedDesc, "MedDesc")
	..d objDicCon.SetAt(UserNM, "UserNM")
	..d objDicCon.SetAt(UpdateDt, "UpdateDt")
	..d objDicCon.SetAt(UpdateTime, "UpdateTime")
	..d objDicCon.SetAt(RowId, "RowId")
	..d data.Insert(objDicCon)           ;对照集合
	set TotalNum=IDList.Size
	if InsuConType="1"  d // 未对照 
	.s TotalNum=UnConNum
	if InsuConType="2"  d // 对照
	.s TotalNum=ConNum
	s result("total")=TotalNum
	s result("rows")=data
	s ret=##Class(web.INSUEncodeJson).Encode(.result)
	k ^||TMPINSUContrast("GetHisDicAndConAjax")
	q ret
}

/// 功能说明：保存his字典与医保字典的对照关系
/// w ##class(web.INSUDictionaryContrast).SaveDicConAjax("Dosage","BJA","","3^缓释胶囊^jn01^胶囊^1")
ClassMethod SaveDicConAjax(KeyCode As %String, InsuType As %String, HospitalNo As %String, ConInfo As %String) As %String
{
	s statis="-1"
	s info=""
	s ^TMPINSUQC("SaveDicConAjax")=$lb(KeyCode,InsuType,HospitalNo,ConInfo)
	s:($g(%session)'="")&&(HospitalNo="") HospitalNo=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	
	
	s HisCode=$p(ConInfo, "^", 1)    ;his字典编码
	i (((KeyCode'="")&&(InsuType'="")&&(HisCode'=""))||(KeyCode'="DLL")||(KeyCode'="Tari")) d
	.s ConDr=..DicHaveCon(KeyCode, InsuType, HospitalNo, HisCode)   ;判断是否已经存在对照关系
	.i ConDr="" d
	..s objCon=##class(User.INSUDicData).%New()
	.e  d
	..s objCon=##class(User.INSUDicData).%OpenId(ConDr)

	.s dicType=KeyCode_"Con"_InsuType
	.i (KeyCode="DLL")||(KeyCode="Tari") d
	..s dicType="AdmReasonDrTo"_KeyCode_"Type"
	.s TmpHospitalNo=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId(dicType,HospitalNo)
	.s objCon.INDIDDicType=dicType                  ;字典识别key
	.s objCon.INDIDDicCode=HisCode                  ;his字典编码
	.s objCon.INDIDDicDesc=$p(ConInfo, "^", 2)      ;his字典描述
	.s objCon.INDIDDicBill1=$p(ConInfo, "^", 3)     ;医保字典编码
	.s objCon.INDIDDicBill2=$p(ConInfo, "^", 4)     ;医保字典描述
	.s UserDr=$p(ConInfo, "^", 5) ;操作员Dr
	.s nowDt=$h
	.s UpdateDate=$p(nowDt, ",", 1)   ;对照日期
	.s UpdateTime=$p(nowDt, ",", 2)   ;对照时间
	.s CommonInfo=UserDr_"|"_UpdateDate_"|"_UpdateTime
	.s objCon.INDIDDicDemo=CommonInfo               ;备注信息
	.s objCon.INDIDDicBill3=$p(ConInfo, "^", 6)      ;医院编码
	.s objCon.INDIDHospDr=TmpHospitalNo
	.s sc=objCon.%Save()
	.i $System.Status.IsError(sc) d
	..s info=$system.Status.GetErrorText(sc)
	.e  d
	..s statis=objCon.%Id()
	e  d
	.s info="参数不正确:KeyCode:"_KeyCode_"|InsuType:"_InsuType_"|HospitalNo:"_HospitalNo_"|ConInfo:"_ConInfo

	s Result("status")=statis
	s Result("info")=info
	s flag=##class(web.INSUEncodeJson).Encode(.Result)
	q flag
}

/// 功能说明：删除his字典与医保字典的对照关系
/// w ##class(web.INSUDictionaryContrast).DelDicConAjax("1","")
ClassMethod DelDicConAjax(RowId As %String, ExtStr As %String) As %String
{
	s statis="-1"
	s info=""
	
	i ##class(User.INSUDicData).%ExistsId(RowId) d
	.s sc=##class(User.INSUDicData).%DeleteId(RowId)
	.i $System.Status.IsError(sc) d
	..s info=$system.Status.GetErrorText(sc)
	.e  d
	..s statis=RowId
	e  d
	.s statis="0"
	.s info="当前对照关系在后台数据库不存在,可能已经被别人删除了"
	
	s Result("status")=statis
	s Result("info")=info
	s flag=##class(web.INSUEncodeJson).Encode(.Result)
	q flag
}

/// 功能说明：判断字典是否已经存在对照关系
/// w ##class(web.INSUDictionaryContrast).DicHaveCon
ClassMethod DicHaveCon(KeyCode As %String, InsuType As %String, HospitalNo As %String, HisCode As %String) As %String
{
	s ^CacheTemp("DicHaveCon")=$lb(KeyCode , InsuType , HospitalNo , HisCode)
	s haveRowid=""

	s DicType=KeyCode_"Con"_InsuType
	i (KeyCode="DLL")||(KeyCode="Tari") d
	.s DicType="AdmReasonDrTo"_KeyCode_"Type"
	;+2019-7-30 tangzf 医院授权判断 start
	s:($g(%session)'="")&&(HospitalNo="") HospitalNo=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	s HospitalNo=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId(DicType,HospitalNo)
	
	s tmpRowId=""
	f  s tmpRowId=$o(^DHCINDID("0","ITypeCode", DicType, HisCode,tmpRowId)) q:(tmpRowId="")||(haveRowid'="")  d
	.s TmpHospital=$p($g(^DHCINDID(tmpRowId)), "^", 15)
	.q:TmpHospital'=HospitalNo
	.s haveRowid=tmpRowId
	;+2019-7-30 tangzf 医院授权判断 end
	q haveRowid
}

/// 功能说明：根据his字典获取对照后的医保字典信息
/// 入参说明：KeyCode    --> 字典类别识别码
///           HisCode    --> his字典编码
///           InsuType   --> 医保类型
///           HospitalNo --> 医院编码(默认为空，仅有少数与院区有关的字典才需要传这个参数[例：科室])
///           AllInfoFlg --> 返回对照的全部信息还是仅仅返回医保编码 (1 全部信息 0 仅返回医保编码)
/// 返 回 值：医保字典编码^医保字典描述^对照人^对照日期^对照时间^....
///           为空的时候代表没有对照信息
/// w ##class(web.INSUDictionaryContrast).GetContrastInfo("Dosage","yqr","BJA","1","AdmReasonDrToTariType")
ClassMethod GetContrastInfo(KeyCode As %String, HisCode As %String, InsuType As %String, AllInfoFlg As %String = "0", DicType As %String = "", HospitalNo = "") As %String
{
	s RtnInfo=""
	;q:((HisCode="")||(KeyCode="")||(InsuType="")) RtnInfo
	q:(((HisCode="")||(KeyCode="")||(InsuType="")))&&((KeyCode'="DLL")&&(KeyCode'="Tari")) RtnInfo
	s:($g(%session)'="")&&(HospitalNo="") HospitalNo=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	i DicType="" d
	.s DicType=KeyCode_"Con"_InsuType
	i (KeyCode="DLL")||(KeyCode="Tari") d
	.s DicType="AdmReasonDrTo"_KeyCode_"Type"                  //获取费别到DLL对照
	s HospitalNo=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId(DicType,HospitalNo)
	;b ;GetCon
	q:$d(^DHCINDID("0","ITypeCode",DicType, HisCode))=0 RtnInfo
	// tangzf 2020-03-21 start
	s rowid="",TmprowId=""
	f  s TmprowId=$o(^DHCINDID("0","ITypeCode",DicType, HisCode, TmprowId), -1)  q:(TmprowId="")||(rowid'="")  d
	.;+2019-7-30 tangzf 医院授权判断 start
	.s TmpHospital=$p($g(^DHCINDID(TmprowId)), "^", 15)
	.q:HospitalNo'=TmpHospital
	.s rowid=TmprowId
	.;+2019-7-30 tangzf 医院授权判断 end
	// tangzf 2020-03-21 end
	;s rowid=$o(^DHCINDID("0","ITypeCode",DicType, HisCode, ""), -1)
	q:rowid="" RtnInfo
	s DicDataInfo=$g(^DHCINDID(rowid))    ;对照信息
	s MedCode=$p(DicDataInfo, "^", 4)           ;医保编码
	s MedDesc=$p(DicDataInfo, "^", 5)           ;医保表述
	s DicDemo=$p(DicDataInfo, "^", 6)           ;备注信息
	
	s userDr=$p(DicDemo, "|", 1)
	s userNM=""
	s:userDr'="" userNM=$p($g(^SSU("SSUSR",userDr)), "^", 2)
	s:userNM="" userNM=userDr
	s ConDt=""   ;对照日期
	s iConDt=$p(DicDemo, "|", 2)
	;s:iConDt'="" ConDt=$zd(iConDt, 3) //- DingSH 20191011
	s:iConDt'="" ConDt=##class(websys.Conversions).DateLogicalToHtml(iConDt) //DingSH 20191011
	s ConTime=""    ;对照时间
	s iConTime=$p(DicDemo, "|", 3)
	;s:iConTime'="" ConTime=$zt(iConTime) //- DingSH 20191011
	s:iConTime'="" ConTime=##class(websys.Conversions).TimeLogicalToHtml(iConTime) //DingSH 20191011
	s RtnCon=MedCode_"^"_MedDesc_"^"_userNM_"^"_ConDt_"^"_ConTime_"^"_rowid
	i AllInfoFlg="1" d
	.s RtnInfo=RtnCon
	e  d
	.s RtnInfo=MedCode
	
	q RtnInfo
}

/// 功能说明：获取字典的集合信息
/// w ##class(web.INSUDictionaryContrast).GetDicDataList("DLLType", "")
ClassMethod GetDicDataList(DicKey As %String, ExtStr As %String) As %String
{
	s ret=##class(%ListOfDataTypes).%New()
	s HospitalNo=$p(ExtStr,"^",1)
	s:($g(%session)'="")&&(HospitalNo="") HospitalNo=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	s HospitalNo=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId(DicKey,HospitalNo)
	s rowid=""
	f  s rowid=$o(^DHCINDID(0,"IType", DicKey, rowid)) q:rowid=""  d
	.s dicInfo=$g(^DHCINDID(rowid))
	.s objDic=##class(%ArrayOfDataTypes).%New()
	.;+2019-7-30 tangzf 医院授权判断 start
	.s TmpHospital=$p($g(^DHCINDID(rowid)), "^", 15)
	.q:HospitalNo'=TmpHospital
	.;+2019-7-30 tangzf 医院授权判断 end
	.d objDic.SetAt($p(dicInfo,"^",1),"keycode")   ;字典key
	.d objDic.SetAt($p(dicInfo,"^",2),"diccode")   ;字典编码
	.d objDic.SetAt($p(dicInfo,"^",3),"dicdesc")   ;字典描述
	.d objDic.SetAt($p(dicInfo,"^",4),"concode")   ;字典对照编码
	.d objDic.SetAt($p(dicInfo,"^",5),"condesc")   ;字典对照描述
	.d objDic.SetAt($p(dicInfo,"^",6),"common")    ;备注
	.d ret.Insert(objDic)
	
	s flag=##class(web.INSUEncodeJson).Encode(ret)
	q flag
}

/// 功能说明：获取院区编码下拉框数据
/// w ##class(web.INSUDictionaryContrast).GetHospitalList()
ClassMethod GetHospitalList() As %String
{
	s ret=##class(%ListOfDataTypes).%New()
	
	s recNum=0
	s RowID="0"
	f  s RowID=$o(^CT("HOSP",RowID)) q:RowID=""  d
	.s info=$g(^CT("HOSP",RowID))
	.s recNum=recNum+1
	
	.s objHospital=##class(%ArrayOfDataTypes).%New()
	.d objHospital.SetAt($p(info,"^",1),"code")
	.d objHospital.SetAt($p(info,"^",2),"desc")
	.d:recNum="1" objHospital.SetAt("true","selected")
	.d ret.Insert(objHospital)
	
	s flag=##class(web.INSUEncodeJson).Encode(ret)
	q flag
}

/// 功能说明：获取his的剂型字典集合
/// 入参说明：SearchKey   --> 查询关键字
///           HospitalNo  --> 院区编码(与院区有关的字典需要这个参数，如：剂型字典)
///           ExtStr      --> 备用参数
/// s rtnList=##class(web.INSUDictionaryContrast).GetHisDosageList("","","","")
ClassMethod GetHisDosageList(SearchKey As %String, HospitalNo As %String, ExtStr As %String) As %ListOfDataTypes
{
	s DicList=##class(%ListOfDataTypes).%New()
	
	s rowid="0"
	f  s rowid=$o(^PHCF(rowid)) q:rowid=""  d
	.s info=$g(^PHCF(rowid))
	.s HisDesc=$p(info, "^", 2)
	.s quitFlg=..GetQuitFlgByDesc(SearchKey, HisDesc, "")   ;根据关键字过滤
	.q:quitFlg="1"
	.s objDic=##class(%ArrayOfDataTypes).%New()
	.;s HisCode=rowid
	.s HisCode=$p(info, "^", 1)	;upt 20220107 HZH
	.d objDic.SetAt(HisCode, "HisCode")   ;字典编码
	.d objDic.SetAt(HisDesc, "HisDesc")   ;字典描述
	.d DicList.Insert(objDic)
	
	q DicList
}

/// 功能说明：根据字典描述判断是否为符合过滤条件
ClassMethod GetQuitFlgByDesc(SearchKey As %String, HisDesc As %String, ExtStr As %String) As %String
{
	s quitFlg="0"
	
	i SearchKey'="" d
	.q:HisDesc[SearchKey
	.s pymTmp=..GetCNCODE(HisDesc, 4, "")
	.s SearchKey=$zcvt(SearchKey, "U")
	.q:pymTmp[SearchKey
	.s quitFlg="1"
	
	q quitFlg
}

/// Description:返回汉字的编码信息
/// Input：	HANZI:汉字
/// 			FLAG:返回何种编码(1:ASC码,2:汉字,3:拼音,4:首拼,5:四角码6:五笔码7:区位码8:笔划数9:郑码)
/// 			SPLIT:分割符(可以为空)
/// Output：
/// 	非0:返回编码信息:ASC码^汉字^拼音^首拼^四角码^五笔码^区位码^笔划数^郑码
/// 	0：未找到编码信息
/// CreatDate:2011-06-08
/// w ##class(web.INSUDictionaryContrast).GetCNCODE("东华",4,"^")
/// w ##class(web.INSUDictionaryContrast).GetCNCODE("东华",4,"")
ClassMethod GetCNCODE(HANZIS As %String = "", FLAG As %String = "", SPLIT As %String = "") As %String
{
	s Rtnstr="0"
	q:$g(HANZIS)="" Rtnstr
	s Rtnstr=""
	f i=1:1:$l(HANZIS) d
	.s HANZI=$EXTRACT(HANZIS,i)
	.s ASCIICODE=$ASCII(HANZI)
	.i $D(^DHCCharacterEncoding("0","ASCII",ASCIICODE))'=0 d
	..s rowid=$o(^DHCCharacterEncoding("0","ASCII",ASCIICODE,""))
	..s tmpstr=""
	..s:FLAG="" tmpstr=$g(^DHCCharacterEncoding(rowid))
	..s:FLAG'="" tmpstr=$p(^DHCCharacterEncoding(rowid),"^",FLAG)
	..i Rtnstr=""  d
	...s Rtnstr=tmpstr
	..e  d
	...s Rtnstr=Rtnstr_SPLIT_tmpstr
	.e  d
	..s:Rtnstr="" Rtnstr="?"
	..s Rtnstr=Rtnstr_SPLIT_"?"
	q Rtnstr
}

/// 功能说明：获取his的科室字典集合
/// 创建时间：2019-03-26
/// 创建人  ：Xubaobao
/// 入参说明：SearchKey   --> 查询关键字
///           HospitalNo  --> 院区编码(与院区有关的字典需要这个参数，如：科室字典)
///           ExtStr      --> 备用参数
/// s rtnList=##class(web.INSUDictionaryContrast).GetHisLocList("","","","")
ClassMethod GetHisLocList(SearchKey As %String, HospitalNo As %String, ExtStr As %String) As %ListOfDataTypes
{
	s DicList=##class(%ListOfDataTypes).%New()
	s:($g(%session)'="")&&(HospitalNo="") HospitalNo=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	s HospitalNo=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("CT_Loc",HospitalNo)
	s rowid="0"
	f  s rowid=$o(^CTLOC(rowid)) q:rowid=""  d
	.s info=$g(^CTLOC(rowid))
	.;st
	.set DateF=$p(info, "^", 24)
	.Set DateT=$p(info, "^", 25)
	.Quit:(+DateF'=0)&&(DateF>+$h)
    .Quit:(+DateT'=0)&&(DateT<+$h)
    .;end
	.s HisDesc=$p(info, "^", 2)
	.;+2019-7-30 tangzf 医院授权判断 start
	.s DataHosp=$p(info,"^",22)
	.q:DataHosp'=HospitalNo
	.;+2019-7-30 tangzf 医院授权判断 end
	.s quitFlg=..GetQuitFlgByDesc(SearchKey, HisDesc, "")   ;根据关键字过滤
	.q:quitFlg="1"
	.s objDic=##class(%ArrayOfDataTypes).%New()
	.;s HisCode=rowid
	.s HisCode=$p(info, "^", 1)	;upt 20220107 HZH
	.d objDic.SetAt(HisCode, "HisCode")   ;字典编码
	.d objDic.SetAt(HisDesc, "HisDesc")   ;字典描述
	.d DicList.Insert(objDic)
	
	q DicList
}

/// 功能说明：获取his的操作员字典集合
/// 创建时间：2019-03-26
/// 创建人  ：Xubaobao
/// 入参说明：SearchKey   --> 查询关键字
///           HospitalNo  --> 院区编码(与院区有关的字典需要这个参数，如：操作员字典)
///           ExtStr      --> 备用参数
/// s rtnList=##class(web.INSUDictionaryContrast).GetHisOperatorList("","","","")
ClassMethod GetHisOperatorList(SearchKey As %String, HospitalNo As %String, ExtStr As %String) As %ListOfDataTypes
{
	s DicList=##class(%ListOfDataTypes).%New()
	
	s rowid="0"
	f  s rowid=$o(^SSU("SSUSR",rowid)) q:rowid=""  d
	.s info=$g(^SSU("SSUSR",rowid))
	.s HisDesc=$p(info, "^", 2)
	.s GruopDr=$p(info, "^", 5)
	.;+2019-7-30 tangzf 医院授权判断 start
	.s CheckHosipitalSession=##class(web.DHCBILLINSUCloudCommon).CheckDataSession("SS_User",rowid,HospitalNo,"","Y")
	.q:CheckHosipitalSession'="Y" ; 该院区无权查看该数据
	.;+2019-7-30 tangzf 医院授权判断 end
	.s GroupDesc=$p(^SSU("SSGRP",GruopDr),"^",1)
	.q:(GroupDesc'["医保")&(GroupDesc'["收费")&(GroupDesc'["挂号")
	.s quitFlg=..GetQuitFlgByDesc(SearchKey, HisDesc, "")   ;根据关键字过滤
	.q:quitFlg="1"
	.s objDic=##class(%ArrayOfDataTypes).%New()
	.;s HisCode=rowid
	.s HisCode=$p(info, "^", 1)	;upt 20220107 HZH
	.d objDic.SetAt(HisCode, "HisCode")   ;字典编码
	.d objDic.SetAt(HisDesc, "HisDesc")   ;字典描述
	.d DicList.Insert(objDic)
	
	q DicList
}

/// 功能说明：获取his的出院原因字典集合
/// 创建时间：2019-03-26
/// 创建人  ：Xubaobao
/// 入参说明：SearchKey   --> 查询关键字
///           HospitalNo  --> 院区编码(与院区有关的字典需要这个参数，如：出院原因字典)
///           ExtStr      --> 备用参数
/// s rtnList=##class(web.INSUDictionaryContrast).GetHisDischConditList("","","","")
ClassMethod GetHisDischConditList(SearchKey As %String, HospitalNo As %String, ExtStr As %String) As %ListOfDataTypes
{
	s DicList=##class(%ListOfDataTypes).%New()
	
	s rowid="0"
	f  s rowid=$o(^PAC("DISCON",rowid)) q:rowid=""  d
	.s info=$g(^PAC("DISCON",rowid))
	.s HisDesc=$p(info, "^", 2)
	.;st
	.set DateF=$p(info, "^", 4)
	.Set DateT=$p(info, "^", 5)
	.Quit:(+DateF'=0)&&(DateF>+$h)
    .Quit:(+DateT'=0)&&(DateT<+$h)
    .;end
	.s quitFlg=..GetQuitFlgByDesc(SearchKey, HisDesc, "")   ;根据关键字过滤
	.q:quitFlg="1"
	.s objDic=##class(%ArrayOfDataTypes).%New()
	.;s HisCode=rowid
	.s HisCode=$p(info, "^", 1)	;upt 20220107 HZH
	.d objDic.SetAt(HisCode, "HisCode")   ;字典编码
	.d objDic.SetAt(HisDesc, "HisDesc")   ;字典描述
	.d DicList.Insert(objDic)
	
	q DicList
}

/// 功能说明：获取his的疗程字典集合
/// 创建时间：2019-03-26
/// 创建人  ：Xubaobao
/// 入参说明：SearchKey   --> 查询关键字
///           HospitalNo  --> 院区编码(与院区有关的字典需要这个参数，如：疗程字典)
///           ExtStr      --> 备用参数
/// s rtnList=##class(web.INSUDictionaryContrast).GetHisDurationList("","","")
ClassMethod GetHisDurationList(SearchKey As %String, HospitalNo As %String, ExtStr As %String) As %ListOfDataTypes
{
	s DicList=##class(%ListOfDataTypes).%New()
	
	s rowid="0"
	f  s rowid=$o(^PHCDU(rowid)) q:rowid=""  d
	.s info=$g(^PHCDU(rowid))
	.s HisDesc=$p(info, "^", 3)
	.s PHCDUDesc2=$p(info, "^", 4)
	.;st
	.set DateF=$p(info, "^", 5)
	.Set DateT=$p(info, "^", 6)
	.Quit:(+DateF'=0)&&(DateF>+$h)
    .Quit:(+DateT'=0)&&(DateT<+$h)
    .;end
	.;q:PHCDUDesc2="饮片"      ;此处参考可医生站下医嘱界面疗程取值
	.s quitFlg=..GetQuitFlgByDesc(SearchKey, HisDesc, "")   ;根据关键字过滤
	.q:quitFlg="1"
	.s objDic=##class(%ArrayOfDataTypes).%New()
	.s HisCode=rowid
	.d objDic.SetAt(HisCode, "HisCode")   ;字典编码
	.d objDic.SetAt(HisDesc, "HisDesc")   ;字典描述
	.d DicList.Insert(objDic)
	
	q DicList
}

/// 功能说明：获取his的费用类型字典集合
/// 创建时间：2019-03-26
/// 创建人  ：Xubaobao
/// 入参说明：SearchKey   --> 查询关键字
///           HospitalNo  --> 院区编码(与院区有关的字典需要这个参数，如：疗程字典)
///           ExtStr      --> 备用参数
/// s rtnList=##class(web.INSUDictionaryContrast).GetHisTarCateList("","","")
ClassMethod GetHisTarCateList(SearchKey As %String, HospitalNo As %String, ExtStr As %String) As %ListOfDataTypes
{
	s DicList=##class(%ListOfDataTypes).%New()
	
	s rowid="0"
	f  s rowid=$o(^DHCTarC("CC",rowid)) q:rowid=""  d
	.s info=$g(^DHCTarC("CC",rowid))
	.s HisDesc=$p(info, "^", 2)
	.;+2019-7-30 tangzf 医院授权判断 start
	.s CheckHosipitalSession=##class(web.DHCBILLINSUCloudCommon).CheckDataSession("DHC_TarCate",rowid,HospitalNo,"","Y")
	.q:CheckHosipitalSession'="Y" ; 该院区无权查看该数据
	.;+2019-7-30 tangzf 医院授权判断 end
	.s quitFlg=..GetQuitFlgByDesc(SearchKey, HisDesc, "")   ;根据关键字过滤
	.q:quitFlg="1"
	.s objDic=##class(%ArrayOfDataTypes).%New()
	.;s HisCode=rowid
	.s HisCode=$p(info, "^", 1)	;upt 20220107 HZH
	.d objDic.SetAt(HisCode, "HisCode")   ;字典编码
	.d objDic.SetAt(HisDesc, "HisDesc")   ;字典描述
	.d DicList.Insert(objDic)
	
	q DicList
}

/// 功能说明：获取his的费别字典集合
/// 创建时间：2019-03-26
/// 创建人  ：Xubaobao
/// 入参说明：SearchKey   --> 查询关键字
///           HospitalNo  --> 院区编码(与院区有关的字典需要这个参数，如：疗程字典)
///           ExtStr      --> 备用参数
/// s rtnList=##class(web.INSUDictionaryContrast).GetHisAdmreasonList("","","")
ClassMethod GetHisAdmreasonList(SearchKey As %String, HospitalNo As %String, ExtStr As %String) As %ListOfDataTypes
{
	s DicList=##class(%ListOfDataTypes).%New()
	
	s rowid="0"
	f  s rowid=$o(^PAC("ADMREA",rowid)) q:rowid=""  d
	.Set READateFrom=$p(^PAC("ADMREA",rowid),"^",3)
	.s info=$g(^PAC("ADMREA",rowid))
	.Quit:(+READateFrom'=0)&&(READateFrom>+$h)
    .Set READateTo=$p(^PAC("ADMREA",rowid),"^",4)
    .Quit:(+READateTo'=0)&&(READateTo<+$h)
	.;+2019-7-30 tangzf 医院授权判断 start
	.s CheckHosipitalSession=##class(web.DHCBILLINSUCloudCommon).CheckDataSession("PAC_AdmReason",rowid,HospitalNo,"","Y")
	.q:CheckHosipitalSession'="Y" ; 该院区无权查看该数据
	.;+2019-7-30 tangzf 医院授权判断 end
	.s HisDesc=$p(info, "^", 2)
	.s NationalCode=+$p(info, "^", 5)      ;住院是否掉医保接口
	.s AdmSource=+$p(info, "^", 9)         ;门诊是否掉医保接口
	.q:(NationalCode<1)&&(AdmSource<1)&&(ExtStr="DLL")
	.s quitFlg=..GetQuitFlgByDesc(SearchKey, HisDesc, "")   ;根据关键字过滤
	.q:quitFlg="1"
	.s objDic=##class(%ArrayOfDataTypes).%New()
	.s HisCode=rowid
	.d objDic.SetAt(HisCode, "HisCode")   ;字典编码
	.d objDic.SetAt(HisDesc, "HisDesc")   ;字典描述
	.d DicList.Insert(objDic)
	
	q DicList
}

/// 功能说明：医保字典信息获取
///           医保字典信息保存在医保字典表中
/// 入参说明：InsuType  --> 医保类型
///           ExtStr    --> 扩展参数(检索关键字^)
/// w ##class(web.INSUDictionaryContrast).GetINSUDLLTypeDicAjax(10,1,"AKA130","BJA","门诊")
ClassMethod GetINSUDLLTypeDicAjax(rows, page, Type As %String, ExtStr As %String) As %String
{
	s HospitalNo=$p(ExtStr,"^",2)
	s:($g(%session)'="")&&(HospitalNo="") HospitalNo=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	s HospitalNo=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("DLLType",HospitalNo)
	
	s IDList=##class(%ListOfDataTypes).%New()
	s SearchKey=$p(ExtStr,"^",1)
	s DicKey="DLLType"
	s rowid=""
	f  s rowid=$o(^DHCINDID(0,"IType", DicKey, rowid)) q:rowid=""  d
	.s dicInfo=$g(^DHCINDID(rowid))
	.;+2019-7-30 tangzf 医院授权判断 start
	.s TmpHospital=$p($g(^DHCINDID(rowid)), "^", 15)
	.q:HospitalNo'=TmpHospital
	.;+2019-7-30 tangzf 医院授权判断 end
	.s dicdesc=$p(dicInfo,"^",3)
	.s quitFlg=..GetQuitFlgByDesc(SearchKey, dicdesc, "")   ;根据关键字过滤
	.q:quitFlg="1"
	.s objDic=##class(%ArrayOfDataTypes).%New()
	.d objDic.SetAt($p(dicInfo,"^",1),"keycode")   ;字典key
	.d objDic.SetAt($p(dicInfo,"^",2),"diccode")   ;字典编码
	.d objDic.SetAt(dicdesc,"dicdesc")             ;字典描述
	.;d objDic.SetAt($p(dicInfo,"^",4),"concode")   ;字典对照编码
	.;d objDic.SetAt($p(dicInfo,"^",5),"condesc")   ;字典对照描述
	.;d objDic.SetAt($p(dicInfo,"^",6),"common")    ;备注
	.d IDList.Insert(objDic)

	s data=##Class(%ListOfDataTypes).%New()
	s startrow=(page-1)*rows+1
	s maxrow=startrow-1+rows
	i maxrow>IDList.Size d
	.s maxrow=IDList.Size
	i maxrow<=IDList.Size d
	.f i=startrow:1:maxrow d
	..s obj=IDList.GetAt(i)
	..d data.Insert(obj)
	
	s result("total")=IDList.Size
	s result("rows")=data
	s ret=##Class(web.INSUEncodeJson).Encode(.result)
	q ret
}

/// 功能说明：获取费别对照字典的集合信息
/// w ##class(web.INSUDictionaryContrast).GetAdmreasonConDicDataList("SYS", "")
ClassMethod GetAdmreasonConDicDataList(DicKey As %String, ExtStr As %String) As %String
{
	s ret=##class(%ListOfDataTypes).%New()
	s HospitalNo=$p(ExtStr,"^",1)
	s:($g(%session)'="")&&(HospitalNo="") HospitalNo=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	s HospitalNo=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId(DicKey,HospitalNo)
	s rowid=""
	f  s rowid=$o(^DHCINDID(0,"IType", DicKey, rowid)) q:rowid=""  d
	.s dicInfo=$g(^DHCINDID(rowid))
	.;+2019-7-30 tangzf 医院授权判断 start
	.s TmpHospital=$p($g(^DHCINDID(rowid)), "^", 15)
	.q:HospitalNo'=TmpHospital
	.;+2019-7-30 tangzf 医院授权判断 end
	.;q:($p(dicInfo,"^",2)'="DLLType")!($p(dicInfo,"^",2)'="TariType")
	.s objDic=##class(%ArrayOfDataTypes).%New()
	.d objDic.SetAt($p(dicInfo,"^",1),"keycode")   ;字典key
	.d objDic.SetAt($p(dicInfo,"^",2),"diccode")   ;字典编码
	.d objDic.SetAt($p(dicInfo,"^",3),"dicdesc")   ;字典描述
	.d objDic.SetAt($p(dicInfo,"^",4),"concode")   ;字典对照编码
	.d objDic.SetAt($p(dicInfo,"^",5),"condesc")   ;字典对照描述
	.d objDic.SetAt($p(dicInfo,"^",6),"common")    ;备注
	.d ret.Insert(objDic)
	
	s flag=##class(web.INSUEncodeJson).Encode(ret)
	q flag
}

/// Creator: tangzf
/// CreateDate: 2020-03-09
/// Descript: 医保对照界面维护 左边HIS数据 方法  频率
/// 			 该方法写完以后 需要在 对照节目进行维护
/// Table : 
/// Input:		
/// 				SearchKey   --> 查询关键字
///       		HospitalNo  --> 院区编码(与院区有关的字典需要这个参数，如：疗程字典)
///             ExtStr      --> 备用参数
/// Output: 
/// Return: ListOfDataTypes
/// DeBug:  
/// s rtnList=##class(web.INSUDictionaryContrast).GetHisAdmreasonList("","","")
ClassMethod GetHisQrequencyList(SearchKey As %String, HospitalNo As %String, ExtStr As %String) As %ListOfDataTypes
{
	s DicList=##class(%ListOfDataTypes).%New()
	
	s rowid="0"
	f  s rowid=$o(^PHCFR(rowid)) q:rowid=""  d
	.s info=$g(^PHCFR(rowid))
	.s HisDesc=$p(info, "^", 3)
	.q:$p(info, "^", 6)'="Y"
	.// 以下代码不需要改动
	.s quitFlg=..GetQuitFlgByDesc(SearchKey, HisDesc, "")   ;根据关键字过滤
	.q:quitFlg="1"
	.s objDic=##class(%ArrayOfDataTypes).%New()
	.s HisCode=$p(info, "^", 1)
	.d objDic.SetAt(HisCode, "HisCode")   ;字典编码
	.d objDic.SetAt(HisDesc, "HisDesc")   ;字典描述
	.d DicList.Insert(objDic)
	
	q DicList
}

/// Creator: tangzf
/// CreateDate: 2020-03-09
/// Descript: 医保对照界面维护 左边HIS数据 方法 HIS用法  
/// 			 该方法写完以后 需要在 对照节目进行维护
/// Table : 
/// Input:		
/// 				SearchKey   --> 查询关键字
///       		HospitalNo  --> 院区编码(与院区有关的字典需要这个参数，如：疗程字典)
///             ExtStr      --> 备用参数
/// Output: 
/// Return: ListOfDataTypes
/// DeBug:  
/// s rtnList=##class(web.INSUDictionaryContrast).GetHisAdmreasonList("","","")
ClassMethod GetHisDirectionList(SearchKey As %String, HospitalNo As %String, ExtStr As %String) As %ListOfDataTypes
{
	s DicList=##class(%ListOfDataTypes).%New()
	
	s rowid="0"
	f  s rowid=$o(^PHCIN(rowid)) q:rowid=""  d
	.s info=$g(^PHCIN(rowid))
	.s HisDesc=$p(info, "^", 2)
	.q:$p(info, "^", 4)'="Y"
	.// 以下代码不需要改动
	.s quitFlg=..GetQuitFlgByDesc(SearchKey, HisDesc, "")   ;根据关键字过滤
	.q:quitFlg="1"
	.s objDic=##class(%ArrayOfDataTypes).%New()
	.s HisCode=$p(info, "^", 1)
	.d objDic.SetAt(HisCode, "HisCode")   ;字典编码
	.d objDic.SetAt(HisDesc, "HisDesc")   ;字典描述
	.d DicList.Insert(objDic)
	
	q DicList
}

/// Creator: DingSH
/// CreateDate: 2022-11-28
/// Descript: 医保对照界面维护 左边HIS数据 方法  急诊分诊级别
/// 			 该方法写完以后 需要在 对照节目进行维护
/// Table :  CT_Acuity 公有数据
/// Input:		
/// 				SearchKey   --> 查询关键字
///       		HospitalNo  --> 院区编码(与院区有关的字典需要这个参数，如：疗程字典)
///             ExtStr      --> 备用参数
/// Output: 
/// Return: ListOfDataTypes
/// DeBug:  
/// s rtnList=##class(web.INSUDictionaryContrast).GetHisCTAcuityList("","","")
ClassMethod GetHisCTAcuityList(SearchKey As %String, HospitalNo As %String, ExtStr As %String) As %ListOfDataTypes
{
	s DicList=##class(%ListOfDataTypes).%New()
	//s:($g(%session)'="")&&(HospitalNo="") HospitalNo=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	//s HospitalNo=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId(DicKey,HospitalNo)
	s rowid="0"
	f  s rowid=$o(^CT("ACU",rowid)) q:rowid=""  d
	.s info=$g(^CT("ACU",rowid))
	.s CTACUDesc=$p(info, "^", 2)
	.// 以下代码不需要改动
	.s quitFlg=..GetQuitFlgByDesc(SearchKey, CTACUDesc, "")   ;根据关键字过滤
	.q:quitFlg="1"
	.s objDic=##class(%ArrayOfDataTypes).%New()
	.s CTACUCode=$p(info, "^", 1)
	.s CTACUDesc=$p(info, "^", 2)
	.d objDic.SetAt(CTACUCode, "HisCode")   ;字典编码
	.d objDic.SetAt(CTACUDesc, "HisDesc")   ;字典描述
	.d DicList.Insert(objDic)
	
	q DicList
}

}
