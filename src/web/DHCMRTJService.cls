Import SQLUSER

Class web.DHCMRTJService Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 获取DHCMRBed表的数据
/// 返回字符串：{result:20,totalNum:908,root:[{Id:1,Code:'Code'}]}
/// 空：{result:0,totalNum:0,root:[]}
/// w ##Class(web.DHCMRTJService).GetMRBed()
ClassMethod GetMRBed(paraValues As %String = "", PagePar As %String = "") As %String
{
	n (paraValues,PagePar)
	s startPage=$P(PagePar,"^",1)
	s endPage=$P(PagePar,"^",2)
	i +startPage=0 s startPage=0
	i +endPage=0 s endPage=20
	s ^yu($H)=paraValues_"!!"_PagePar
	
	s Datepara=$P(paraValues,"&",1)
	//i (Datepara["-")&&($L(Datepara,"-")=3) s Datepara=$ZDH(Datepara,3)
	i $g(Datepara)'="" s Datepara=##class(websys.Conversions).DateHtmlToLogical(Datepara)
	s IsActivepara=$P(paraValues,"&",2)
	s LocTypepara=$P(paraValues,"&",3)
	i LocTypepara="Ward" s LocTypepara="W"
	i LocTypepara="Loc" s LocTypepara="E"
	s LocCodepara=$P(paraValues,"&",4)
	s LocDescpara=$P(paraValues,"&",5)

	k ^||TEMPDHCWL($j)
	s Id=0
	s result=0,totalNum=0,Str=""
	f  s Id=$O(^DHCMRBed(Id)) Q:Id=""  d
	.s Date=$P(^DHCMRBed(Id),"^",1)
	.s LocId=$P(^DHCMRBed(Id),"^",2)
	.s GDNum=$P(^DHCMRBed(Id),"^",3)
	.s SYNum=$P(^DHCMRBed(Id),"^",4)
	.s BZNum=$P(^DHCMRBed(Id),"^",5)
	.s WardId=$P(^DHCMRBed(Id),"^",6)
	.Q:(LocTypepara="E")&&(+LocId=0)
	.Q:(LocTypepara="W")&&(+WardId=0)
	.Q:(Datepara'="")&&(IsActivepara="true")&&(Datepara'=Date)
	.s ^||TEMPDHCWL($j,"Date",Date,Id)=LocId_"^"_GDNum_"^"_SYNum_"^"_BZNum_"^"_WardId
	
	s Date=""
	f  s Date=$O(^||TEMPDHCWL($j,"Date",Date)) Q:Date=""  d
	.s Id=""
	.f  s Id=$O(^||TEMPDHCWL($j,"Date",Date,Id)) Q:Id=""  d
	..s LocId=$P(^||TEMPDHCWL($j,"Date",Date,Id),"^",1)
	..s GDNum=$P(^||TEMPDHCWL($j,"Date",Date,Id),"^",2)
	..s SYNum=$P(^||TEMPDHCWL($j,"Date",Date,Id),"^",3)
	..s BZNum=$P(^||TEMPDHCWL($j,"Date",Date,Id),"^",4)
	..s WardId=$P(^||TEMPDHCWL($j,"Date",Date,Id),"^",5)
	..i LocId'="" s LocOrWard=$P(^CTLOC(LocId),"^",2)
	..else  s LocOrWard=$P(^PAWARD(WardId),"^",2)
	..q:(LocDescpara'="")&&(LocDescpara'[LocOrWard)
	..s totalNum=totalNum+1
	..s result=result+1
	..Q:((result<startPage)||(result>endPage))
	..s Str=Str_"{ID:'"_Id_"',Date:'"_##class(websys.Conversions).DateLogicalToHtml(Date)_"',LocOrWard:'"_LocOrWard_"',GDNum:'"_GDNum_"',SYNum:'"_SYNum_"',BZNum:'"_BZNum_"'},"
	i Str'="" d
	.s Return="{result:"_result_",totalNum:"_totalNum_",root:["_$e(Str,1,$l(Str)-1)_"]}"
	else  d
	.s Return="{result:"_0_",totalNum:"_0_",root:[]}"
	Q $g(Return)
}

/// 根据传入的科室病区标志,取得CT_Loc表中科室和病区
/// s ret=##Class(web.DHCMRTJService).GetLocOrWard("")
ClassMethod GetLocOrWard(LocOrWard As %String) As %Text
{
	n (LocOrWard)
	s ResultList="['',''],",count=0
	i LocOrWard="" s LocOrWard="Loc"
	Q:LocOrWard="" "["_$e(ResultList,1,$l(ResultList)-1)_"]"
	k ^||TEMPDHCWL($j)
	s ID=0
	f  s ID=$O(^CTLOC(ID)) Q:+ID=0  d
	.s LocCode=$P(^CTLOC(ID),"^",1)
	.s LocDesc=$P(^CTLOC(ID),"^",2)
	.s LocType=$P(^CTLOC(ID),"^",13)
	.s LocDepdr=$P(^CTLOC(ID),"^",19)
	.s isLocLinkFlag=..isCTLocLink(ID)   ////是否为科室病区关联
	.Q:(LocOrWard="Ward")&&(LocType'="W")
	.Q:(LocOrWard="Loc")&&((+isLocLinkFlag=0)||(LocType'="E"))
	.s ^||TEMPDHCWL($j,"Desc",LocDesc,count)=LocCode   ///解决汉字排序
	.s count=count+1
	
	s LocDesc=""
	f  s LocDesc=$O(^||TEMPDHCWL($j,"Desc",LocDesc)) Q:LocDesc=""  d
	.s count=""
	.f  s count=$O(^||TEMPDHCWL($j,"Desc",LocDesc,count)) Q:count=""  d
	..s LocCode=$g(^||TEMPDHCWL($j,"Desc",LocDesc,count))
	..s Desc=LocDesc
	..;i Desc["-" s Desc=$P(Desc,"-",2)
	..s ResultList=ResultList_"['"_LocCode_"','"_Desc_"'],"
	q "["_$e(ResultList,1,$l(ResultList)-1)_"]"
}

/// 判断科室是否存在CT_LocLinkLocation关联
/// 存在返回：1,否则：0
ClassMethod isCTLocLink(Locid As %String) As %String
{
	n (Locid)
	s ret=0
	q:+Locid=0 ret
	q:$D(^CTLOC(Locid,"LINK")) "1"
	q ret
}

/// 根据科室病区描述取科室病区的类型
ClassMethod GetTypeByLoc(LocWardType As %String) As %String
{
	n (LocWardType)
	s result=""
	s ID=0
	f  s ID=$O(^CTLOC(ID)) Q:+ID=0  d
	.s LocCode=$P(^CTLOC(ID),"^",1)
	.s LocDesc=$P(^CTLOC(ID),"^",2)
	.s LocType=$P(^CTLOC(ID),"^",13)
	.s LocDepdr=$P(^CTLOC(ID),"^",19)
	.Q:LocDesc'=LocWardType
	.s result=LocCode_"||"_LocType_"||"_ID
	q result
}

/// 根据DHCMRBed的RowID返回结果
ClassMethod GetTypeByLocbyId(MRId As %String) As %String
{
	n (MRId)
	s result=""
	q:'$D(^DHCMRBed(MRId)) result
	s LocId=$P(^DHCMRBed(MRId),"^",2)
	s WardId=$P(^DHCMRBed(MRId),"^",6)
	i LocId'="" s result="||E||"
	i WardId'="" s result="||W||"
	q result
}

/// 增加或更新床位信息
/// s ret=##Class(web.DHCMRTJService).addBed(paraValues)
ClassMethod addBed(paraValues As %String) As %String
{
	n (paraValues)
	s Date=$P(paraValues,"&",1)
	//Q:(Date["-")&&($L(Date,"-")'=3) "日期格式错误!"
	//i (Date["-")&&($L(Date,"-")=3) s Date=$ZDH(Date,3)
	Q:$g(Date)="" "日期格式错误!"
	//w !,Date
	s Date=##class(websys.Conversions).DateHtmlToLogical(Date)
	//w !,Date
	s LocType=$P(paraValues,"&",2)
	s LocCode=$P(paraValues,"&",3)
	s LocDesc=$P(paraValues,"&",4)
	s GDNum=$P(paraValues,"&",5)
	s SYNum=$P(paraValues,"&",6)
	s BZNum=$P(paraValues,"&",7)
	Q:(Date="")||(LocType="")||(LocCode="")||(LocDesc="")||(GDNum="")||(SYNum="")||(BZNum="") "字段信息不全!"
	s LocInfo=..GetTypeByLoc(LocDesc)
	Q:LocInfo="" "科室不规范"
	s LocID=$P(LocInfo,"||",3)
	s LocType=$P(LocInfo,"||",2)
	s NowDateTime=$ZD(+$H,3)_" "_$ZT($P($H,",",2),1)
	s SQLCODE=-1
	i (LocType="W")&&(LocID'="") d
	.s WardRowid=$O(^PAWARD(0,"WARD_LocationDR",LocID,""))
	.i $D(^DHCMRBed(0,"Ward",WardRowid,"Date",Date)) d
	..s MRBedRowid=$O(^DHCMRBed(0,"Ward",WardRowid,"Date",Date,""),-1)
	..TStart
	..&sql(update DHCMRBed set MR_GDNum=:GDNum, MR_SYNum=:SYNum, MR_BZNum=:BZNum,MR_DateTime=:NowDateTime where MR_RowId=:MRBedRowid)
	..i SQLCODE=0 TCommit
	..else  TRollback
	.else  d
	..TStart
	..&sql(insert into DHCMRBed (MR_Date,MR_GDNum,MR_SYNum,MR_BZNum,MR_Ward,MR_DateTime) values(:Date,:GDNum,:SYNum,:BZNum,:WardRowid,:NowDateTime))
	..i SQLCODE=0 TCommit
	..else  TRollback
	else  i ((LocType="E")&&(LocID'="")) d
	.i $D(^DHCMRBed(0,"Loc",LocID,"Date",Date)) d
	..s MRBedRowid=$O(^DHCMRBed(0,"Loc",LocID,"Date",Date,""),-1)
	..TStart
	..&sql(update DHCMRBed set MR_GDNum=:GDNum, MR_SYNum=:SYNum, MR_BZNum=:BZNum,MR_DateTime=:NowDateTime where MR_RowId=:MRBedRowid)
	..i SQLCODE=0 TCommit
	..else  TRollback
	.else  d
	..TStart
	..&sql(insert into DHCMRBed (MR_Date,MR_GDNum,MR_SYNum,MR_BZNum,MR_Loc,MR_DateTime) values(:Date,:GDNum,:SYNum,:BZNum,:LocID,:NowDateTime))
	..i SQLCODE=0 TCommit
	..else  TRollback
	i SQLCODE=0 Q "ok"
	e  Q "Error"
}

///  --------------------------以上是bed相关----------------------
/// 获取DHCMRICDCate信息 返回已经维护的Code,Desc,CateGory,Remark
/// ycm 2015-11-03
/// filterRule
/// 返回字符串：{result:20,totalNum:908,root:[{Id:1,Code:'Code',Name:'',Desc:'',Active:'',Creator:''}]}
/// 空：{result:0,totalNum:0,root:[]}
/// w ##Class(web.DHCMRTJService).getMRICDCateData()
ClassMethod getMRICDCateData(filterRule) As %String
{
	n (filterRule)
	s filterCode=$P(filterRule,"^",1)
	s filterCode=$ZCVT(filterCode,"U")
	s filterDesc=$P(filterRule,"^",2)
	s filterCateGory=$P(filterRule,"^",3)
	s filterRemark=$P(filterRule,"^",4)
	s result=0,totalNum=0,Str=""
	k ^||TEMPDHCWL($j)
	s ID="0"
	f  s ID=$O(^DHCMRICDCate(ID)) Q:ID=""  d
	.s ICDCCode=$P(^DHCMRICDCate(ID),"^",1)
	.s ICDCDesc=$P(^DHCMRICDCate(ID),"^",2)
	.s ICDCCate=$P(^DHCMRICDCate(ID),"^",3)
	.s ICDCRemark=$P(^DHCMRICDCate(ID),"^",4)
	.Q:(filterCode'="")&&($ZCVT(ICDCCode,"U")'[filterCode)
	.Q:(filterDesc'="")&&(ICDCDesc'[filterDesc)
	.Q:(filterCateGory'="")&&(ICDCCate'[filterCateGory)
	.Q:(filterRemark'="")&&(ICDCRemark'[filterRemark)
	.s ^||TEMPDHCWL($j,"ICD",ID)=ICDCCode_"^"_ICDCDesc_"^"_ICDCCate_"^"_ICDCRemark
	
	s ID=""
	f  s ID=$O(^||TEMPDHCWL($j,"ICD",ID)) Q:ID=""  d
	.s ICDCCode=$P(^||TEMPDHCWL($j,"ICD",ID),"^",1)
	.s ICDCDesc=$P(^||TEMPDHCWL($j,"ICD",ID),"^",2)
	.s ICDCCate=$P(^||TEMPDHCWL($j,"ICD",ID),"^",3)
	.s ICDCRemark=$P(^||TEMPDHCWL($j,"ICD",ID),"^",4)
	.s totalNum=totalNum+1
	.s result=result+1
	.s Str=Str_"{ICDCId:'"_ID_"',ICDCCode:'"_ICDCCode_"',ICDCDesc:'"_ICDCDesc_"',ICDCCate:'"_ICDCCate_"',ICDCRemark:'"_ICDCRemark_"'},"
	i Str'="" d
	.s Return="{result:"_result_",totalNum:"_totalNum_",root:["_$e(Str,1,$l(Str)-1)_"]}"
	else  d
	.s Return="{result:"_0_",totalNum:"_0_",root:[]}"
	k ^||TEMPDHCWL($j)
	Q $g(Return)
}

/// 根据获得的信息，保存DHCMRICDCate
/// ycm 2015-11-03
/// 
/// w ##Class(web.DHCMRTJService).addMRICDCate(ICDInfo)
ClassMethod addMRICDCate(ICDInfo) As %String
{
	n (ICDInfo)
	s ICDCCode=$P(ICDInfo,"^",1)
	s ICDCDesc=$P(ICDInfo,"^",2)
	s ICDCCate=$P(ICDInfo,"^",3)
	s ICDCRemark=$P(ICDInfo,"^",4)
	q:ICDCCode="" "编码不能为空."
	//s ICDCCode=$$ALPHAUP^SSUTIL4(ICDCCode)
	s SQLCODE=-1
	TStart
	i '$D(^DHCMRICDCate(0,"Code",ICDCCode)) d
	.i ICDCCate="" s ICDCCate="诊断"
	.&sql(INSERT INTO DHCMR_ICDCate(ICDC_Type,ICDC_Desc,ICDC_Remark,ICDC_CateGory) VALUES(:ICDCCode,:ICDCDesc,:ICDCRemark,:ICDCCate))
	else  d
	.s ICDCRowid=$O(^DHCMRICDCate(0,"Code",ICDCCode,""))
	.&sql(UPDATE DHCMR_ICDCate(ICDC_Type,ICDC_Desc,ICDC_Remark,ICDC_CateGory) VALUES(:ICDCCode,:ICDCDesc,:ICDCRemark,:ICDCCate) WHERE ICDC_RowId=:ICDCRowid)
	i SQLCODE=0 TCommit
	else  TRollback
	i SQLCODE=0 s Result="ok"
	else  s Result="保存出错."
	Q $g(Result)
}

/// 根据分类Id,删除分类信息
/// ycm 2015-11-03
/// w ##Class(web.DHCMRTJService).DelICDCateData(ICDCRowid)
ClassMethod DelICDCateData(ICDCRowid As %String) As %String
{
	n (ICDCRowid)
	Q:'$D(^DHCMRICDCate(ICDCRowid)) "删除错误."
	s SQLCODE=-1
	TStart
	&SQL(DELETE FROM DHCMR_ICDCate WHERE ICDC_RowId=:ICDCRowid)
	i SQLCODE=0 d
	.&SQL(DELETE FROM DHCMR_ICDCateDetails WHERE ICDCateDr=:ICDCRowid)
	.i SQLCODE=100 s SQLCODE=0   ///删除不存在的时候报100
	i SQLCODE=0 TCommit
	else  TRollback
	i SQLCODE=0 s Result="ok"
	else  s Result="删除失败."
	Q $g(Result)
}

/// 根据传入的DHCMRICDCate 的RowID，获取相应明细字段
/// ycm 2015-11-03
/// ICDCId   输出时根据Sort排序输出
/// 返回字符串：{result:20,totalNum:908,root:[{Id:1,Code:'Code',Name:'',Desc:'',Active:'',Creator:''}]}
/// 空：{result:0,totalNum:0,root:[]}
/// w ##Class(web.DHCMRTJService).GetMRICDCateDetails(ICDCId)
ClassMethod GetMRICDCateDetails(ICDCId) As %String
{
	n (ICDCId)
	s result=0,totalNum=0,Str=""
	k ^||TEMPDHCWL($j)
	q:+ICDCId=0 "{result:"_0_",totalNum:"_0_",root:[]}"
	s Sort=""
	f  s Sort=$O(^DHCMRICDCateDetails(0,"ICDCDrSort",ICDCId,Sort)) Q:Sort=""  d
	.s ID=""
	.f  s ID=$O(^DHCMRICDCateDetails(0,"ICDCDrSort",ICDCId,Sort,ID)) Q:ID=""  d
	..s ICDCDDesc=$P(^DHCMRICDCateDetails(ID),"^",1)
	..s ICDCDICD=$P(^DHCMRICDCateDetails(ID),"^",2)
	..s ICDCDSort=$P(^DHCMRICDCateDetails(ID),"^",3)
	..s totalNum=totalNum+1
	..s result=result+1
	..s Str=Str_"{ICDCDId:'"_ID_"',ICDCDICD:'"_ICDCDICD_"',ICDCDDesc:'"_ICDCDDesc_"',ICDCDSort:'"_ICDCDSort_"'},"
	i Str'="" d
	.s Return="{result:"_result_",totalNum:"_totalNum_",root:["_$e(Str,1,$l(Str)-1)_"]}"
	else  d
	.s Return="{result:"_0_",totalNum:"_0_",root:[]}"
	k ^||TEMPDHCWL($j)
	Q $g(Return)
}

/// 根据ICD分类ID，明细ID,删除DHCMRICDCateDetails
/// ycm 2015-11-03
/// w ##Class(web.DHCMRTJService).DelMRICDCDetails(ICDCRowid)
ClassMethod DelMRICDCDetails(ICDCRowid As %String, ICDCDId As %String) As %String
{
	n (ICDCRowid,ICDCDId)
	Q:'$D(^DHCMRICDCate(ICDCRowid)) "删除错误."
	s SQLCODE=-1
	TStart
	i +ICDCDId'=0 d
	.&SQL(DELETE FROM DHCMR_ICDCateDetails WHERE ICDCateDr=:ICDCRowid and ICDCD_RowId=:ICDCDId)
	i ICDCDId="A" d
	.&SQL(DELETE FROM DHCMR_ICDCateDetails WHERE ICDCateDr=:ICDCRowid)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE=0 TCommit
	else  TRollback
	i SQLCODE=0 s Result="ok"
	else  s Result="删除失败."
	Q $g(Result)
}

/// 更新DHCMRICDCateDetails的顺序
/// ycm 2015-11-03
/// w ##Class(web.DHCMRTJService).MRICDCateDetailsSort("","")
ClassMethod MRICDCateDetailsSort(ICDCId As %String, IdStr As %Text, pageSize As %Integer, pageNumber As %Integer) As %String
{
	n (ICDCId,IdStr,pageSize,pageNumber)
	s result="ok"
	Q:'$D(^DHCMRICDCate(ICDCId)) "保存顺序失败."
	k ^||TEMPDHCWL($j)
	s len=$L(IdStr,"-")
	s updatedICDCDID=""
	f i=1:1:len d
	.s ICDCDId=$P(IdStr,"-",i)
	.Q:+ICDCDId=0
	.Q:'$D(^DHCMRICDCateDetails(ICDCDId))
	.s ICDCDDesc=$P(^DHCMRICDCateDetails(ICDCDId),"^",1)
	.s ICDCDICDList=$P(^DHCMRICDCateDetails(ICDCDId),"^",2)
	.s ^||TEMPDHCWL($j,"Sort",i)=ICDCDDesc_"^"_ICDCDICDList
	.if updatedICDCDID'="" s updatedICDCDID=updatedICDCDID_","_ICDCDId
	.e  s updatedICDCDID=ICDCDId
	
	s baseInx=(pageNumber-1)*pageSize
	s SQLCODE=-1
	Tstart 
	if updatedICDCDID'="" d
	.s sql="DELETE FROM DHCMR_ICDCateDetails WHERE ICDCD_RowId in ("_updatedICDCDID_")"
	.s rs=##class(%Library.ResultSet).%New()
	.d rs.Prepare(sql)
	.d rs.Execute()	
	.i SQLCODE=100 s SQLCODE=0
	
	
	i SQLCODE=0 d
	.s Id=""
	.f  s Id=$O(^||TEMPDHCWL($j,"Sort",Id)) Q:Id=""  d
	..s ICDCDDesc=$P(^||TEMPDHCWL($j,"Sort",Id),"^",1)
	..s ICDCDICDList=$P(^||TEMPDHCWL($j,"Sort",Id),"^",2)
	..s newSort=baseInx+Id
	..&SQL(INSERT INTO DHCMR_ICDCateDetails (ICDCD_Desc, ICDCD_ICDList, ICDCD_Sort, ICDCateDr) VALUES (:ICDCDDesc,:ICDCDICDList,:newSort,:ICDCId))
	i SQLCODE=0 TCommit
	else  Trollback
	i SQLCODE=0 s result="ok"
	else  s result="保存顺序失败"
	Q result
}

/// 根据ICD分类、记录、字段、值配置短信编辑的内容
/// ycm 2015-06-18
/// 返回字符串：ok-->用户添加成功,Error-->失败
/// w ##Class(web.DHCMRTJService).editMRICDCateDetails("2^8^MKCDFilterRult^k")
ClassMethod editMRICDCateDetails(editStr As %String) As %String
{
	n (editStr)
	s result="Error"
	;s ^yu(1)=editStr
	s ICDCId=$P(editStr,"^",1)
	s ICDCDId=$P(editStr,"^",2)
	s filed=$P(editStr,"^",3)
	s value=$P(editStr,"^",4)
	q:+ICDCId=0 "请选择ICD分类"
	i +ICDCDId'=0 d
	.s ICDCDobj = ##class(User.DHCMRICDCateDetails).%OpenId(ICDCDId)
	.i filed="ICDCDDesc" s ICDCDobj.ICDCDDesc=value
	.i filed="ICDCDICD" s ICDCDobj.ICDCDICDList=value
	.d ICDCDobj.%Save()
	.s result="ok"
	else  i (+ICDCDId=0) d
	.s result="添加出错."
	.Q:value=""
	.s ICDCDDesc="",ICDCDICDList=""
	.i filed="ICDCDDesc" s ICDCDDesc=value
	.i filed="ICDCDICD" s ICDCDICDList=value
	.s SortId=$O(^DHCMRICDCateDetails(0,"ICDCDrSort",ICDCId,""),-1)
	.s SortId=SortId+1
	.&SQL(INSERT INTO DHCMR_ICDCateDetails (ICDCD_Desc,ICDCD_ICDList, ICDCD_Sort, ICDCateDr) VALUES (:ICDCDDesc,:ICDCDICDList,:SortId,:ICDCId))
	.i SQLCODE=0 s result="ok"
	.else  s result="添加出错."
	else  d
	.s result="请先编辑Code."
	Q result
}

/// ----------------------------以上是ICD相关---------------------
/// 将原来的ICD维护程序的数据导入到新表 DHCMRICDCate,DHCMRICDCateDetails
/// w ##Class(web.DHCMRTJService).ImportICDData()
ClassMethod ImportICDData() As %String
{
	s DiagGrp=0
	f  s DiagGrp=$O(^DHCMRICDConfig(0,"MRICDCFG_CATEGORY",DiagGrp)) Q:DiagGrp=""  d
	.s SQLCODE=-1
	.TStart
	.&SQL(INSERT INTO DHCMR_ICDCate(ICDC_Desc) VALUES(:DiagGrp))
	.i SQLCODE=0 TCommit
	.else  TRollback
	.s ICDCRowid=+$g(%ROWID)
	.s ICDCate=0,num=0
	.f  s ICDCate=$O(^DHCMRICDConfig(0,"MRICDCFG_CATEGORY",DiagGrp,ICDCate)) Q:ICDCate=""  d
	..s ICDList=$P(^DHCMRICDConfig(ICDCate),"^",3)
	..s ICDCateDesc=$P(^DHCMRICDConfig(ICDCate),"^",2)
	..s num=num+1
	..TStart
	..&SQL(INSERT INTO DHCMR_ICDCateDetails(ICDCD_Desc ,ICDCD_ICDList,ICDCD_Sort,ICDCateDr) VALUES(:ICDCateDesc,:ICDList,:num,:ICDCRowid))
	..i SQLCODE=0 TCommit
	..else  TRollback
	
	q 1
}

Storage Default
{
<Data name="DHCMRTJServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCMRTJServiceD</DataLocation>
<DefaultData>DHCMRTJServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCMRTJServiceD</IdLocation>
<IndexLocation>^web.DHCMRTJServiceI</IndexLocation>
<StreamLocation>^web.DHCMRTJServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
