/// Import SQLUSER
Class web.DHCWL.V1.MRBase.ICDConfig Extends %RegisteredObject
{

ClassMethod getMRICDCateData(filterRule As %String, page As %String, rows As %String) As %String
{


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
	.;s Str=Str_"{ICDCId:'"_ID_"',ICDCCode:'"_ICDCCode_"',ICDCDesc:'"_ICDCDesc_"',ICDCCate:'"_ICDCCate_"',ICDCRemark:'"_ICDCRemark_"'},"
	.s rec="{""ICDCId"":"""_ID_""",""ICDCCode"":"""_ICDCCode_""",""ICDCDesc"":"""_ICDCDesc_""",""ICDCCate"":"""_ICDCCate_""",""ICDCRemark"":"""_ICDCRemark_"""}"
	.if Str="" s Str=rec
	.e  s Str=Str_","_rec
	
	i Str'="" d
	.;s Return="{result:"_page_",totalNum:"_totalNum_",root:["_$e(Str,1,$l(Str)-1)_"]}"
	.s Return="{""curPage"":"_page_",""total"":"_totalNum_",""rows"":["_Str_"]}"
	else  d
	.s Return="{result:"_0_",totalNum:"_0_",root:[]}"
	k ^||TEMPDHCWL($j)
	Q $g(Return)
}

Query MRICDCateData(filterRule As %String) As %Query(ROWSPEC = "ICDCId:%String,ICDCCode:%String,ICDCDesc:%String,ICDCCate:%String,ICDCRemark:%String")
{
}

ClassMethod MRICDCateDataExecute(ByRef qHandle As %Binary, filterRule As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	/*
	s filterCode=$P(filterRule,"^",1)
	s filterCode=$ZCVT(filterCode,"U")
	s filterDesc=$P(filterRule,"^",2)
	s filterCateGory=$P(filterRule,"^",3)
	s filterRemark=$P(filterRule,"^",4)
	*/
	s result=0,totalNum=0,Str=""

	s ID="0"
	for {
		s ID=$o(^DHCMRICDCate(ID))
		q:ID=""
		s ICDCCode=$P(^DHCMRICDCate(ID),"^",1)
		s ICDCDesc=$P(^DHCMRICDCate(ID),"^",2)
		s ICDCCate=$P(^DHCMRICDCate(ID),"^",3)
		s ICDCRemark=$P(^DHCMRICDCate(ID),"^",4)
		s Data=$lb(ID,ICDCCode,ICDCDesc,ICDCCate,ICDCRemark)
		d OuputRow1
	}


	

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow1
	;set Data=$lb(Values,Desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod MRICDCateDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MRICDCateDataExecute ]
{
	Quit $$$OK
}

ClassMethod MRICDCateDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MRICDCateDataExecute ]
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

ClassMethod GetMRICDCateData2(filterRule As %String, page As %String, rows As %String)
{
		s start=((page-1)*rows)
		s limit=rows
		s qryName="%DynamicQuery:SQL"  //固定写法
		s end=start+limit
		s start=start+1
		//上面是固定写法 
		//////////////////////////////////////////
		
		s sql="SELECT ICDC_RowId AS ICDCId, ICDC_Type AS ICDCCode, ICDC_Desc AS ICDCDesc, ICDC_CateGory AS ICDCCate, ICDC_Remark AS ICDCRemark FROM DHCMR_ICDCate WHERE ICDC_RowId>0"
		if $g(filterRule)'="" {
			s conf=" and (ICDC_RowId like '%"_filterRule_"%' or ICDC_Type like '%"_filterRule_"%' or ICDC_Desc like '%"_filterRule_"%' or ICDC_CateGory like '%"_filterRule_"%'  or ICDC_Remark like '%"_filterRule_"%')"	
			s sql=sql_conf
		}
		//w !,sql
		s jsonPro="ICDCId,ICDCCode,ICDCDesc,ICDCCate,ICDCRemark"
		s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,start,end,jsonPro,page)
				
		w json.GetHead()
		d{
			s obj=json.Next()
			w obj
		}while(obj'="")
		i json.GetCount()=0 w "]}"
}

/// add by wz.2017-12-29
ClassMethod editMRICDCateDetails2(editStr As %String) As %String
{
	//n (editStr)
	s result="Error"
	;s ^yu(1)=editStr
	s ICDCId=$P(editStr,"^",1)
	s ICDCDId=$P(editStr,"^",2)
	s ICDCDDesc=$P(editStr,"^",3)
	s ICDCDICD=$P(editStr,"^",4)
	
	
	q:+ICDCId=0 "请选择ICD分类"
	i +ICDCDId'=0 d
	.s ICDCDobj = ##class(User.DHCMRICDCateDetails).%OpenId(ICDCDId)
	.s ICDCDobj.ICDCDDesc=ICDCDDesc
	.s ICDCDobj.ICDCDICDList=ICDCDICD
	.d ICDCDobj.%Save()
	.s result="ok"
	else  i (+ICDCDId=0) d
	.s result="添加出错."
	.;Q:value=""
	.s SortId=$O(^DHCMRICDCateDetails(0,"ICDCDrSort",ICDCId,""),-1)
	.s SortId=SortId+1
	.&SQL(INSERT INTO sqluser.DHCMR_ICDCateDetails (ICDCD_Desc,ICDCD_ICDList, ICDCD_Sort, ICDCateDr) VALUES (:ICDCDDesc,:ICDCDICD,:SortId,:ICDCId))
	.i SQLCODE=0 s result="ok"
	.else  s result="添加出错."
	else  d
	.s result="请先编辑Code."
	Q result
}

ClassMethod GetMRICDCateDetails(ICDCId, page As %String, rows As %String)
{
		s start=((page-1)*rows)
		s limit=rows
		s qryName="%DynamicQuery:SQL"  //固定写法
		s end=start+limit
		s start=start+1
		//上面是固定写法 
		//////////////////////////////////////////
		
		s sql="SELECT ICDCD_RowId AS ICDCDId,ICDCD_Desc AS ICDCDDesc , ICDCD_ICDList AS ICDCDICD, ICDCD_Sort AS ICDCDSort "
		s sql=sql_"FROM SQLUser.DHCMR_ICDCateDetails "
		s sql=sql_"WHERE ICDCateDr = "_ICDCId_" ORDER BY ICDCD_Sort"

		s jsonPro="ICDCDId,ICDCDDesc,ICDCDICD,ICDCDSort"
		s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,start,end,jsonPro,page)
				
		w json.GetHead()
		d{
			s obj=json.Next()
			w obj
		}while(obj'="")
		i json.GetCount()=0 w "]}"
}

ClassMethod addMRICDCate(ICDInfo) As %String
{
	//n (ICDInfo)
	s ICDCCode=$P(ICDInfo,"^",1)
	s ICDCDesc=$P(ICDInfo,"^",2)
	s ICDCCate=$P(ICDInfo,"^",3)
	s ICDCRemark=$P(ICDInfo,"^",4)
	q:ICDCCode="" "编码不能为空."
	//s ICDCCode=$$ALPHAUP^SSUTIL4(ICDCCode)
	s SQLCODE=-1
	S Result=""
	i '$D(^DHCMRICDCate(0,"Code",ICDCCode)) d
	.i ICDCCate="" s ICDCCate="诊断"
	.&sql(INSERT INTO sqluser.DHCMR_ICDCate(ICDC_Type,ICDC_Desc,ICDC_Remark,ICDC_CateGory) VALUES(:ICDCCode,:ICDCDesc,:ICDCRemark,:ICDCCate))
	else  d
	.;s ICDCRowid=$O(^DHCMRICDCate(0,"Code",ICDCCode,""))
	.;&sql(UPDATE sqluser.DHCMR_ICDCate(ICDC_Type,ICDC_Desc,ICDC_Remark,ICDC_CateGory) VALUES(:ICDCCode,:ICDCDesc,:ICDCRemark,:ICDCCate) WHERE ICDC_RowId=:ICDCRowid)
	.s Result="编码已经存在"
	q:Result'="" Result
	i SQLCODE=0 s Result="ok"
	else  s Result="保存出错."
	Q $g(Result)
}

}
