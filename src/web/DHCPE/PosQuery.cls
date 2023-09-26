Import SQLUser

Class web.DHCPE.PosQuery Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 43;

Query SearchARCIM(Desc As %Library.String = "") As %Query(ROWSPEC = "项目:%String,代码:%String")
{
}

ClassMethod SearchARCIMExecute(ByRef qHandle As %Binary, Desc As %Library.String = "") As %Status
{
	s ind=1
	Set repid=$I(^CacheTemp)	
	
	i Desc="" 
	{
	s STRowId=0
	f  s STRowId=$O(^DHCPEST(STRowId)) q:STRowId=""  d
	.s Childsub=0
	.f  s Childsub=$o(^DHCPEST(STRowId,"O",Childsub)) q:Childsub=""  d
	..s ARCIMID=$p($g(^DHCPEST(STRowId,"O",Childsub)),"^",1)
    ..s Subscript=$p(ARCIMID,"||",1)
    ..s Version=$p(ARCIMID,"||",2)
	..s ARCIMDesc=$p($g(^ARCIM(Subscript,Version,1)),"^",2)
	..s ARCIMCode=$p($g(^ARCIM(Subscript,Version,1)),"^",1)
    ..s Data=$lb(ARCIMDesc,ARCIMCode)
    ..d SearchARCIM
	}
    else
    {
	    s STRowId=0
	    f  s STRowId=$O(^DHCPEST(STRowId)) q:STRowId=""  d
	    .s Childsub=0
	    .f  s Childsub=$o(^DHCPEST(STRowId,"O",Childsub)) q:Childsub=""  d
	    ..s ARCIMID=$p($g(^DHCPEST(STRowId,"O",Childsub)),"^",1)
        ..s Subscript=$p(ARCIMID,"||",1)
        ..s Version=$p(ARCIMID,"||",2)
    
        ..s ARCIMDesc=$p($g(^ARCIM(Subscript,Version,1)),"^",2)
	    ..s ARCIMCode=$p($g(^ARCIM(Subscript,Version,1)),"^",1)
  		
	    ..q:ARCIMCode'[$ZCONVERT(Desc,"U")
        ..s Data=$lb(ARCIMDesc,ARCIMCode)
 		..d SearchARCIM
 		
 		
 	    s STRowId=0
	    f  s STRowId=$O(^DHCPEST(STRowId)) q:STRowId=""  d
	    .s Childsub=0
	    .f  s Childsub=$o(^DHCPEST(STRowId,"O",Childsub)) q:Childsub=""  d
	    ..s ARCIMID=$p($g(^DHCPEST(STRowId,"O",Childsub)),"^",1)
        ..s Subscript=$p(ARCIMID,"||",1)
        ..s Version=$p(ARCIMID,"||",2)
    
        ..s ARCIMDesc=$p($g(^ARCIM(Subscript,Version,1)),"^",2)
	    ..s ARCIMCode=$p($g(^ARCIM(Subscript,Version,1)),"^",1)
 		
 		..q:ARCIMDesc'[$ZCONVERT(Desc,"U")
        ..s Data=$lb(ARCIMDesc,ARCIMCode)
 		..d SearchARCIM	
    }

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SearchARCIM
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchARCIMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchARCIMExecute ]
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

ClassMethod SearchARCIMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchARCIMExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 查询阳性(非正常)的标准 DHCPEPosQuery.StandardList (阳性特征) 
/// d ##class(%resultSet).RunQuery("web.DHCPE.PosQuery","SearchPosStandard","6^","8570||1:8||195#^","","","","","")
Query SearchPosStandard(ParRef As %Library.String = "", Desc As %Library.String = "") As %Query(ROWSPEC = "ODS_RowId:%String, ST_Desc:%String, OD_Desc:%String")
{
}

ClassMethod SearchPosStandardExecute(ByRef qHandle As %Binary, ParRef As %Library.String = "", Desc As %Library.String = "") As %Status
{
	s ind=1
	Set repid=$I(^CacheTemp)
	
	s labStationId=^DHCPESetting("DHCPE","StationId_Lab")
	s STRowId=0
	s:(0'=+ParRef) STRowId=$O(^DHCPEST(ParRef),-1)
	f  s STRowId=$O(^DHCPEST(STRowId)) Q:(""=STRowId)||((""'=ParRef)&(ParRef'=STRowId))  d 
	.s OChildSub=0
	.f  s OChildSub=$O(^DHCPEST(STRowId,"O",OChildSub)) Q:(""=OChildSub)  d
	..s ARCIMID=$p($g(^DHCPEST(STRowId,"O",OChildSub)),"^",1)
	..q:ARCIMID'["||"
    ..s ARCIMDesc=$p($g(^ARCIM(+ARCIMID,$p(ARCIMID,"||",2),1)),"^",2)
	..q:(""'=Desc)&(ARCIMDesc'[Desc)
	..s Sequence=""
	..f  s Sequence=$O(^DHCPEODR(0,"Sequence",ARCIMID,Sequence)) q:Sequence=""  d
	...s ODRRowId=""
	...f  s ODRRowId=$O(^DHCPEODR(0,"Sequence",ARCIMID,Sequence,ODRRowId)) q:ODRRowId=""  d
	....s ODDR=$P($g(^DHCPEODR(ODRRowId)),"^",2)
	....q:ODDR=""
	....s ODDesc=$P($g(^DHCPEST(+ODDR,"OD",$P(ODDR,"||",2))),"^",1)
	....q:ODDesc=""
	....s Data=$lb(ODDR, ARCIMDesc, ODDesc)
	....d SearchPosStandardPut
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SearchPosStandardPut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchPosStandardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPosStandardExecute ]
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

ClassMethod SearchPosStandardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPosStandardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 查找体检项目
/// d ##class(web.DHCPE.PosQuery).GetPETestList("","","")
/// 						站点ID						大项名称（按大项名称查）		细项名称（按项目名称查）			
ClassMethod GetPETestList(SId As %Library.String = "", AName As %Library.String, OName As %Library.String)
{
	k ^xwmTemp("PETestList")
	s ^xwmTemp("PETestList")=0
	//DHC_PE_Station	站点
	s STRowId=0
	f  s STRowId=$O(^DHCPEST(STRowId)) Q:(""=STRowId)  d
	.Q:(""'=SId)&(STRowId'=SId)
	.s STDesc=$P($G(^DHCPEST(STRowId)),"^",2)
	.s ^xwmTemp("PETestList", STRowId)=STDesc
	.//DHC_PE_StationOrder	医嘱项目
	.s STORDChildsub=0
	.f  s STORDChildsub=$O(^DHCPEST(STRowId,"O",STORDChildsub)) Q:(""=STORDChildsub)  d
	..s STORDARCIMDR=$P($G(^DHCPEST(STRowId,"O",STORDChildsub)),"^",1)
	..s ARCIMDesc=$p(^ARCIM($p(STORDARCIMDR,"||",1),$p(STORDARCIMDR,"||",2),1),"^",2)
	..s ^xwmTemp("PETestList", STRowId, STORDARCIMDR)=ARCIMDesc
	..//DHC_PE_OrderDetailRelate	医嘱项目下的细项
	..s ODRRowId="0" //8570||1
	..
	..f  s ODRRowId=$O(^DHCPEODR(0,"ARCIM",STORDARCIMDR,ODRRowId)) Q:(""=ODRRowId)  d
	...
	...s ODRODDR=$P($G(^DHCPEODR(ODRRowId)),"^",2)
	...Q:(""=ODRODDR)
	...// DHC_PE_OrderDetail
	...s ODDesc=$P($G(^DHCPEST($p(ODRODDR,"||",1),"OD",$p(ODRODDR,"||",2)) ),"^",1)
	...Q:(""'=OName)&(ODDesc'[OName)
	...s ^xwmTemp("PETestList", STRowId, STORDARCIMDR, ODRODDR)=ODDesc
	...//w ^xwmTemp("PETestList", STRowId, STORDARCIMDR, ODRODDR),!
}

/// 将项目列表输出为XML(树型)格式
/// d ##class(web.DHCPE.PosQuery).OutGetPETestListToXML("","","8","","")
/// 由于获取全部项目数据时的数据量很大，%Library.String类型的字符串无法承受,项目只能是在生成页面时，直接write进页面
ClassMethod OutGetPETestListToXML(itmjs As %Library.String = "", itmjsex As %Library.String = "", SId As %Library.String = "", AName As %Library.String, OName As %Library.String)
{
	d ..GetPETestList(SId,AName,OName)
	s LineEnd=$c(13)_$C(10)
	
	s root="<xml id=xmlTree>"_LineEnd
	
	// 根节点
	s root=root_"<tree>"_LineEnd
	
	s root=root_"<Node>"_LineEnd
	s root=root_"<ID>D"_"Tree"_"</ID>"_LineEnd
	s root=root_"<Name>D"_""_"</Name>"_LineEnd
	s root=root_"<Value>"_""_"</Value>"_LineEnd
	s root=root_"<depth>0</depth>"_LineEnd
	s root=root_"<Text>"_"项目列表"_"</Text>"_LineEnd
	s root=root_"<URL>"_""_"</URL>"_LineEnd
	s root=root_"<Image>"_LineEnd
	s root=root_"<ID>I"_""_"</ID>"_LineEnd
	s root=root_"</Image>"_LineEnd
	//s root=root_"<checked>"_LineEnd
	//s root=root_"<ID>C"_""_"</ID>"_LineEnd
	//s root=root_"<Value>"_""_"</Value>"_LineEnd
	//s root=root_"</checked>"_LineEnd

	w root
	s root=""
	
	//	站点
	s STRowId=0
	s iLLoop1=0
	s strSLine=""
	f  s STRowId=$O(^xwmTemp("PETestList",STRowId)) Q:(""=STRowId)  d
	.s STDesc=$G(^xwmTemp("PETestList",STRowId))
	.s strSLine=strSLine_"<Node>"_LineEnd
	.s strSLine=strSLine_"<ID>D"_(+iLLoop1+1)_"</ID>"_LineEnd
	.s strSLine=strSLine_"<Name>D"_(+iLLoop1+1)_"</Name>"_LineEnd
	.s strSLine=strSLine_"<Value>"_STRowId_"</Value>"_LineEnd
	.s strSLine=strSLine_"<depth>0</depth>"_LineEnd
	.s strSLine=strSLine_"<Text>"_STDesc_"("_STRowId_")"_"</Text>"_LineEnd
	.s strSLine=strSLine_"<URL>"_""_"</URL>"_LineEnd
	.s strSLine=strSLine_"<Image>"_LineEnd
	.s strSLine=strSLine_"<ID>I"_(+iLLoop1+1)_"</ID>"_LineEnd
	.s strSLine=strSLine_"</Image>"_LineEnd
	.s strSLine=strSLine_"<checked>"_LineEnd
	.s strSLine=strSLine_"<ID>C"_(+iLLoop1+1)_"</ID>"_LineEnd
	.s strSLine=strSLine_"<Value>"_STRowId_"</Value>"_LineEnd
	.s strSLine=strSLine_"</checked>"_LineEnd
	.//	医嘱项目
	.s ARCIMID=0
	.s iLLoop2=0
	.s strALine=""
	.f  s ARCIMID=$O(^xwmTemp("PETestList", STRowId, ARCIMID)) Q:(""=ARCIMID)  d
	..s ARCIMDesc=$G(^xwmTemp("PETestList", STRowId, ARCIMID))
	..s strALine=strALine_"<Node>"_LineEnd
	..s strALine=strALine_"<ID>D"_(+iLLoop1+1)_(+iLLoop2+1)_"</ID>"_LineEnd
	..s strALine=strALine_"<Name>D"_(+iLLoop1+1)_(+iLLoop2+1)_"</Name>"_LineEnd
	..s strALine=strALine_"<Value>"_ARCIMID_"</Value>"_LineEnd
	..s strALine=strALine_"<depth>1</depth>"_LineEnd
	..s strALine=strALine_"<Text>"_ARCIMDesc_"</Text>"_LineEnd
	..s strALine=strALine_"<URL>"_ARCIMID_"</URL>"_LineEnd
	..s strALine=strALine_"<Image>"_LineEnd
	..s strALine=strALine_"<ID>I"_(+iLLoop1+1)_(+iLLoop2+1)_"</ID>"_LineEnd
	..s strALine=strALine_"</Image>"_LineEnd
	..s strALine=strALine_"<checked>"_LineEnd
	..s strALine=strALine_"<ID>C"_(+iLLoop1+1)_(+iLLoop2+1)_"</ID>"_LineEnd
	..s strALine=strALine_"<Value>"_ARCIMID_"</Value>"_LineEnd
	..s strALine=strALine_"</checked>"_LineEnd
	..//	医嘱项目下的细项
	..s ODRODDR="0"
	..s iLLoop3=0
	..s strOLine=""
	..f  s ODRODDR=$O(^xwmTemp("PETestList", STRowId, ARCIMID, ODRODDR)) Q:(""=ODRODDR)  d
	...s ODDesc=$G(^xwmTemp("PETestList", STRowId, ARCIMID, ODRODDR))
	...
	...s strOLine=strOLine_"<Node>"_LineEnd
	...s strOLine=strOLine_"<ID>D"_(+iLLoop1+1)_(+iLLoop2+1)_(+iLLoop3+1)_"</ID>"_LineEnd
	...s strOLine=strOLine_"<Name>D"_(+iLLoop1+1)_(+iLLoop2+1)_(+iLLoop3+1)_"</Name>"_LineEnd
	...s strOLine=strOLine_"<depth>3</depth>"_LineEnd
	...s strOLine=strOLine_"<Text>"_ODDesc_"</Text>"_LineEnd
	...s strOLine=strOLine_"<URL>"_ODRODDR_"</URL>"_LineEnd
	...//s strOLine=strOLine_"<Image>"_1_"</Image>"_LineEnd_LineEnd
	...s strOLine=strOLine_"<checked>"_LineEnd
	...s strOLine=strOLine_"<ID>C"_(+iLLoop1+1)_(+iLLoop2+1)_(+iLLoop3+1)_"</ID>"_LineEnd
	...s strOLine=strOLine_"<Value>"_ODRODDR_"</Value>"_LineEnd
	...s strOLine=strOLine_"</checked>"_LineEnd
	...s strOLine=strOLine_"<ChildCount>"_0_"</ChildCount>"_LineEnd
	...s strOLine=strOLine_"</Node>"_LineEnd
	...i ""'=strOLine s strALine=strALine_strOLine //将细项输出到大项
	...s strOLine=""
	...s iLLoop3=+iLLoop3+1
	...
	..
	..s strALine=strALine_"<ChildCount>"_iLLoop3_"</ChildCount>"_LineEnd
	..s strALine=strALine_"</Node>"_LineEnd
	..i ""'=strALine s strSLine=strSLine_strALine ////将大项输出到到站点
	..s strALine=""
	..s iLLoop2=+iLLoop2+1
	..
	.s strSLine=strSLine_"<ChildCount>"_iLLoop2_"</ChildCount>"_LineEnd
	.s strSLine=strSLine_"</Node>"_LineEnd
	.//以站点为单位输出到页面
	.w strSLine
	.s strSLine=""
	.s iLLoop1=+iLLoop1+1

	s root=root_"<ChildCount>"_iLLoop1_"</ChildCount>"_LineEnd
	s root=root_"</Node>"_LineEnd
	s root=root_"</tree>"_LineEnd
	s root=root_"</xml>"_LineEnd
	w root

	Q 1
}

/// 暂未使用
/// 辅助函数 生成HTML页面上的性别列表 CT_Sex
ClassMethod OutSexListToHTML()
{
	w "<select id=Sex name='select'>"
	w "<option value=''></option>"
	s SexId=0
	f  s SexId=$O(^CT("SEX",SexId)) Q:(""=SexId)  d
	.s CTSEXDesc=$P($G(^CT("SEX",SexId)),"^",2)
	.w "<option value='"_SexId_"'>"_CTSEXDesc_"</option>"
	w "</select>"
}

/// 获取团体列表 
/// d ##class(web.DHCPE.PosQuery).GetGroupList("开发")
ClassMethod GetGroupList(itmjs As %Library.String = "", itmjsex As %Library.String = "", GName As %Library.String = "")
{
	k ^xwmTemp("GroupList")
	
	// DHC_PE_GBaseInfo	团体客户基本信息登记表
	s GBIRowId=0
	f  s GBIRowId=$O(^DHCPEGBI(GBIRowId)) Q:(""=GBIRowId)  d
	.s GBIDesc=$P($G(^DHCPEGBI(GBIRowId)),"^",2)
	.Q:(""'=GName)&(GBIDesc'[GName)
	.s ^xwmTemp("GroupList",GBIRowId)=GBIDesc
}

/// 获取团体列表 
/// d ##class(web.DHCPE.PosQuery).OutGroupListToXML()
ClassMethod OutGroupListToXML(itmjs As %Library.String = "", itmjsex As %Library.String = "", GName As %Library.String = "", IsReturn As %Library.String = "1")
{
	d ..GetGroupList(itmjs,itmjsex,GName)
	i "1"=IsReturn d
	.s LineEnd=$c(13)_$c(10)
	.s ret="<xml id=xmlGroupList>"_LineEnd
	e  d
	.s LineEnd=""
	.s ret=""
	
	s ret=ret_"<GroupList>"_LineEnd
	s ret=ret_"<Text>"_"体检单位列表"_"</Text>"_LineEnd
	s GBIRowId=0
	s iLLoop=1
	f  s GBIRowId=$O(^xwmTemp("GroupList",GBIRowId)) Q:(""=GBIRowId)  d
	.s GBIDesc=$G(^xwmTemp("GroupList",GBIRowId))
	.s ret=ret_"<Group>"_LineEnd
	.s ret=ret_"<ID>"_"GP"_iLLoop_"</ID>"_LineEnd
	.s ret=ret_"<Text>"_GBIDesc_"</Text>"_LineEnd
	.s ret=ret_"<Value>"_GBIRowId_"</Value>"_LineEnd
	.s ret=ret_"</Group>"_LineEnd
	.s iLLoop=+iLLoop+1
	
	s ret=ret_"</GroupList>"_LineEnd
	s ret=ret_" </xml>"_LineEnd
	Q ret
}

/// 获取团体列表 
/// d ##class(web.DHCPE.PosQuery).OutGroupListToHTML()
ClassMethod OutGroupListToHTML(itmjs As %Library.String = "", itmjsex As %Library.String = "", GName As %Library.String = "", IsReturn As %Library.String = "1")
{
	d ..GetGroupList(itmjs,itmjsex,GName)
	s LineEnd=$c(13)_$c(10)
	w " <Table id=tGroupList>"_LineEnd
	// DHC_PE_GBaseInfo	团体客户基本信息登记表
	s GBIRowId=0
	
	f  s GBIRowId=$O(^xwmTemp("GroupList",GBIRowId)) Q:(""=GBIRowId)  d
	.s GBIDesc=$G(^xwmTemp("GroupList",GBIRowId))
	.w "  <tr>"_LineEnd
	.w "    <td><input type='checkbox' value='"_GBIRowId_"'/></td>"_LineEnd
	.w "    <td>"_GBIDesc_"</td>"_LineEnd
	.w "  </tr>"_LineEnd
	w " </Table>"_LineEnd
	Q ""
}

/// d ##class(web.DHCPE.PosQuery).GetPosResult("6^7^8^","8570||1:;8||195;8||196;^","","","","","")
/// 						团体列表(已 ^ 分割)		项目列表(已 ^ 分割,大项与细项用 : 分割)	体检起始日期					体检结束日期				起始年龄						结束年龄						性别			
ClassMethod GetPosResult(GList As %Library.String = "", TestList As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", AgeFrom As %Library.String = "", AgeTo As %Library.String = "", Sex As %Library.String = "")
{
	k ^xwmTemp("PosResult")
	s ^xwmTemp("PosResult",0)=0
	
	// 团体客户基本信息登记表 DHC_PE_GBaseInfo 第一层循环 团体-团体条件
	f iGLLoop=1:1:$Length(GList,"^") d
	.s GBIRowId=$P(GList,"^",iGLLoop)
	.Q:(""=GBIRowId)
	.
	.// DHC_PE_GBaseInfo.{ GBI_Desc }	团体名称
	.s GBIDesc=$P($G(^DHCPEGBI(GBIRowId)),"^",2)
	.
	.// DHC_PE_GADM	团体客户ADM表 第二层循环 团体内客户
	.s GADMRowId="0"
	.f  s GADMRowId=$O(^DHCPEGADM(0,"GBI",GBIRowId,GADMRowId)) Q:(""=GADMRowId)  d
	..
	..// DHC_PE_GADM.{ GADM_AdmDate }	体检日期
	..s AdmDate=$P($G(^DHCPEGADM(GADMRowId)),"^",2)
	..Q:(""=AdmDate)
	..Q:(""'=DateFrom)&(""'=AdmDate)&(DateFrom>AdmDate)
	..Q:(""'=DateTo)&(""'=AdmDate)&(DateTo<AdmDate)
	..s AdmDate=$ZD(AdmDate,3)
	..
	..// DHC_PE_IADM 第三层循环 团体客户的就诊(检验)记录
	..s IADMRowId="0"
	..f  s IADMRowId=$O(^DHCPEIADM(0,"GADM",GADMRowId,IADMRowId)) Q:(""=IADMRowId)  d
	...// DHC_PE_IADM.{ IADM_PAADM_DR }
	...s IADMPAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
	...
	...// PA_ADM.{ PAADM_PAPMI_DR }
	...s PAPMIdr=$p($G(^PAADM(IADMPAADMDR)),"^",1)
	...
	...
	...// PA_PatMas.{ PAPMI_Sex_DR }	性别
	...s PAPERSex=$p(^PAPER(PAPMIdr,"ALL"),"^",7)
	...Q:(""'=Sex)&(Sex'=PAPERSex)
	...//  CT_Sex
	...i PAPERSex'="" s PAPERSex=$p(^CT("SEX",PAPERSex),"^",2)
	...
	...// PA_PatMas.{ PAPMI_Name }	姓名
	...s PAPERName=$p(^PAPER(PAPMIdr,"ALL"),"^",1)
	...
	...// PA_PatMas.{ PAPMI_Sex_DR_Dob }	出生日期
	...s PAPERDob=$p(^PAPER(PAPMIdr,"ALL"),"^",6)
	...
 	...i PAPERDob'="" d
 	....//年龄
 	....s Age=##class(web.DHCLCNUREXCUTE).CalAge(PAPERDob,+$h)
 	....s Age=+$P(Age,"Y",1)
 	....s PAPERDob=$ZD(PAPERDob,3)
	....
	...e  d
	....s Age=""
	...
	...Q:(""'=AgeFrom)&(""'=Age)&(+AgeFrom>+Age)
	...Q:(""'=AgeTo)&(""'=Age)&(+AgeTo<+Age)
	...
	...// 按医嘱项查找结果值 现在不能处理一次检验中有重复项目的情况
	...s ODSID=""
	...f  s ODSID=$o(^DHCPEGenED("NotIsStandard",IADMPAADMDR,ODSID)) q:(""=ODSID)  d
	....
 	....s SID=$P(ODSID,"||",1) // DHC_PE_Station.{ST_RowId}
 	....s ODChildSub=$P(ODSID,"||",2)	// DHC_PE_OrderDetail.{OD_ChildSub}
 	....s ODSChildSub=$P(ODSID,"||",3) // DHC_PE_ODStandard.{ODS_ChildSub}
	....s ODDR=SID_"||"_ODChildSub // DHC_PE_OrderDetail.{OD_RowId}
	....
	....Q:(TestList'[(";"_ODDR_";"))
	....
	....// 细项名称 DHC_PE_OrderDetail.{ OD_Desc }(细项表)
	....s ODDesc=$p($g(^DHCPEST(SID,"OD",ODChildSub)),"^",1)
	....
	....s RLTRowId="0"
	....s RLTRowId=$O(^DHCPERLT(0,"PAADM_OD",IADMPAADMDR,ODDR,RLTRowId))
	....Q:(""=RLTRowId)
	....s ItmMast=ODDR
	....s ARCIMDesc=""
	....s RLTNormal="1"
	....s OEORDRowId=IADMPAADMDR
	....s OEORIChildsub=IADMPAADMDR
	....// RLT_Result 结果
	....s RLTResult=$P($G(^DHCPERLT(RLTRowId)),"^",4)
	....
	....s OutData=AdmDate_"^"_GBIDesc_"^"_PAPERName_"^"_PAPERSex_"^"_Age_"^"_ARCIMDesc_"^"_ODDesc_"^"_RLTResult_"^"_RLTNormal
	....s ^xwmTemp("PosResult", ItmMast, ODDR, IADMPAADMDR, OEORDRowId, OEORIChildsub)=OutData
	....
	....
}

/*
/// d ##class(web.DHCPE.PosQuery).GetPosResult("6^7^8^","8570||1:8||195;8||196;^","","","","","")
/// 						团体列表(已 ^ 分割)		项目列表(已 ^ 分割,大项与细项用 : 分割)	体检起始日期					体检结束日期				起始年龄						结束年龄						性别			
ClassMethod GetPosResult(GList As %Library.String = "", TestList As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", AgeFrom As %Library.String = "", AgeTo As %Library.String = "", Sex As %Library.String = "")
{
	k ^xwmTemp("PosResult")
	s ^xwmTemp("PosResult",0)=0
	
	// 团体客户基本信息登记表 DHC_PE_GBaseInfo 第一层循环 团体-团体条件
	f iGLLoop=1:1:$Length(GList,"^") d
	.s GBIRowId=$P(GList,"^",iGLLoop)
	.Q:(""=GBIRowId)
	.
	.// DHC_PE_GBaseInfo.{ GBI_Desc }	团体名称
	.s GBIDesc=$P($G(^DHCPEGBI(GBIRowId)),"^",2)
	.
	.// DHC_PE_GADM	团体客户ADM表 第二层循环 团体内客户
	.s GADMRowId="0"
	.f  s GADMRowId=$O(^DHCPEGADM(0,"GBI",GBIRowId,GADMRowId)) Q:(""=GADMRowId)  d
	..
	..// DHC_PE_GADM.{ GADM_AdmDate }	体检日期
	..s AdmDate=$P($G(^DHCPEGADM(GADMRowId)),"^",2)
	..Q:(""=AdmDate)
	..Q:(""'=DateFrom)&(""'=AdmDate)&(DateFrom>AdmDate)
	..Q:(""'=DateTo)&(""'=AdmDate)&(DateTo<AdmDate)
	..s AdmDate=$ZD(AdmDate,3)
	..
	..// DHC_PE_IADM 第三层循环 团体客户的就诊(检验)记录
	..s IADMRowId="0"
	..f  s IADMRowId=$O(^DHCPEIADM(0,"GADM",GADMRowId,IADMRowId)) Q:(""=IADMRowId)  d
	...// DHC_PE_IADM.{ IADM_PAADM_DR }
	...s IADMPAADMDR=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
	...
	...// PA_ADM.{ PAADM_PAPMI_DR }
	...s PAPMIdr=$p($G(^PAADM(IADMPAADMDR)),"^",1)
	...
	...
	...// PA_PatMas.{ PAPMI_Sex_DR }	性别
	...s PAPERSex=$p(^PAPER(PAPMIdr,"ALL"),"^",7)
	...Q:(""'=Sex)&(Sex'=PAPERSex)
	...//  CT_Sex
	...i PAPERSex'="" s PAPERSex=$p(^CT("SEX",PAPERSex),"^",2)
	...
	...// PA_PatMas.{ PAPMI_Name }	姓名
	...s PAPERName=$p(^PAPER(PAPMIdr,"ALL"),"^",1)
	...
	...// PA_PatMas.{ PAPMI_Sex_DR_Dob }	出生日期
	...s PAPERDob=$p(^PAPER(PAPMIdr,"ALL"),"^",6)
	...
 	...i PAPERDob'="" d
 	....//年龄
 	....s Age=##class(web.DHCLCNUREXCUTE).CalAge(PAPERDob,+$h)
 	....s Age=+$P(Age,"Y",1)
 	....s PAPERDob=$ZD(PAPERDob,3)
	....
	...e  d
	....s Age=""
	...
	...Q:(""'=AgeFrom)&(""'=Age)&(+AgeFrom>+Age)
	...Q:(""'=AgeTo)&(""'=Age)&(+AgeTo<+Age)
	...// OE_Order.{ OEORD_RowId } 第四层循环 每次就诊的医嘱项
	...s OEORDRowId="0"
	...f  s OEORDRowId=$O(^OEORD(0,"Adm",IADMPAADMDR,OEORDRowId)) Q:(""=OEORDRowId)  d
	....// 检验项目 大项列表 		第五层循环 过滤检验项目-项目条件
	....f iTLLoop=1:1:$Length(TestList,"^") d
	.....s Test=$P(TestList,"^",iTLLoop)
	.....Q:(""=Test)
	.....s ItmMast=$P(Test,":",1)
	.....
	.....//大项名称  Arc_ItmMast.{ ARCIM_Desc }
	.....s ARCIMDesc=$p($g(^ARCIM($P(ItmMast,"||",1),$P(ItmMast,"||",2),1)),"^",2)
	.....
	.....// 细项列表		第六层循环 过滤检验项目内检验指标-医嘱子项条件
	.....s ODDRs=$P(Test,":",2) 
	.....f iOLLoop=1:1:$Length(ODDRs,";") d
	......s ODDR=$P(ODDRs,";",iOLLoop)
	......Q:(""=ODDR)
	......
	......// 按医嘱项查找结果值 能处理一次检验中有重复项目的情况
	......// OE_OrdItem
	......s OEORISttDat=""		// OE_OrdItem.{ OEORI_SttDat }
	......f  s OEORISttDat=$O(^OEORDi(0, "ARCIM", OEORDRowId, ItmMast, OEORISttDat)) Q:(""=OEORISttDat)  d
	.......s OEORIChildsub=0	// OE_OrdItem.{ OEORI_Childsub }
	.......f  s OEORIChildsub=$O(^OEORDi(0, "ARCIM", OEORDRowId, ItmMast, OEORISttDat, OEORIChildsub)) Q:(""=OEORIChildsub)  d
	........s OEORIRowId=OEORDRowId_"||"_OEORIChildsub
	........
	........// DHC_PE_Result 体检结果表
	........s RLTRowId="0"
	........
	........f  s RLTRowId=$O(^DHCPERLT(0,"ADMOD", IADMPAADMDR, OEORIRowId, ODDR, RLTRowId)) Q:(""=RLTRowId)  d
	.........
	.........// RLT_Normal	是否正常
	.........s RLTNormal=$P($G(^DHCPERLT(RLTRowId)),"^",7)
	.........Q:("1"=RLTNormal)
	.........
	.........// 细项名称 DHC_PE_OrderDetail.{ OD_Desc }(细项表)
	.........s ODDesc=$p($g(^DHCPEST($P(ODDR,"||",1),"OD",$P(ODDR,"||",2))),"^",1)
	.........
	.........// RLT_Result 结果
	.........s RLTResult=$P($G(^DHCPERLT(RLTRowId)),"^",4)
	.........
	.........s OutData=AdmDate_"^"_GBIDesc_"^"_PAPERName_"^"_PAPERSex_"^"_Age_"^"_ARCIMDesc_"^"_ODDesc_"^"_RLTResult_"^"_RLTNormal
	.........s ^xwmTemp("PosResult", ItmMast, ODDR, IADMPAADMDR, OEORDRowId, OEORIChildsub)=OutData
	.........
}

*/

/*
ClassMethod OutPosResult(GList As %Library.String = "", TestList As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", AgeFrom As %Library.String = "", AgeTo As %Library.String = "", Sex As %Library.String = "")
{
	
	d ..GetPosResult(GList,TestList,DateFrom,DateTo,AgeFrom,AgeTo,Sex)
	s ItmMast=0
	f  s ItmMast=$O(^xwmTemp("PosResult",ItmMast)) Q:(""=ItmMast)  d 
	.s ODDR=0
	.f  s ODDR=$O(^xwmTemp("PosResult",ItmMast,ODDR)) Q:(""=ODDR)  d 
	..s PAADM=0
	..f  s PAADM=$O(^xwmTemp("PosResult",ItmMast,ODDR,PAADM)) Q:(""=PAADM)  d 
	...s OEORDRowId=0
	...f  s OEORDRowId=$O(^xwmTemp("PosResult",ItmMast,ODDR,PAADM,OEORDRowId)) Q:(""=OEORDRowId)  d 
	....s OEORiDRowId=0
	....f  s OEORiDRowId=$O(^xwmTemp("PosResult",ItmMast,ODDR,PAADM,OEORDRowId,OEORiDRowId)) Q:(""=OEORiDRowId)  d
	.....w ^xwmTemp("PosResult",ItmMast,ODDR,PAADM,OEORDRowId,OEORiDRowId),!
}
*/
/// d ##class(%resultSet).RunQuery("web.DHCPE.PosQuery","GetPosResult","6^","8570||1:8||195#^","","","","","")
Query SearchPosResult(GList As %Library.String = "", TestList As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", AgeFrom As %Library.String = "", AgeTo As %Library.String = "", Sex As %Library.String = "") As %Query(ROWSPEC = "AdmDate:%String, GBI_Desc:%String, PAPER_Name:%String, PAPER_Sex:%String, Age:%String, ARCIM_Desc:%String, OD_Desc:%String, RLTResult:%String, RLT_Normal:%String")
{
}

ClassMethod SearchPosResultExecute(ByRef qHandle As %Binary, GList As %Library.String, TestList As %Library.String, DateFrom As %Library.String, DateTo As %Library.String, AgeFrom As %Library.String, AgeTo As %Library.String, Sex As %Library.String) As %Status
{
	s ind=1
	Set repid=$I(^CacheTemp)	
 	if ((""=GList)&(""=TestList)) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	d ..GetPosResult(GList,TestList,DateFrom,DateTo,AgeFrom,AgeTo,Sex)

	s ItmMast=0
	f  s ItmMast=$O(^xwmTemp("PosResult",ItmMast)) Q:(""=ItmMast)  d 
	.s ODDR=0
	.f  s ODDR=$O(^xwmTemp("PosResult",ItmMast,ODDR)) Q:(""=ODDR)  d 
	..s PAADM=0
	..f  s PAADM=$O(^xwmTemp("PosResult",ItmMast,ODDR,PAADM)) Q:(""=PAADM)  d 
	...s OEORDRowId=0
	...f  s OEORDRowId=$O(^xwmTemp("PosResult",ItmMast,ODDR,PAADM,OEORDRowId)) Q:(""=OEORDRowId)  d 
	....s OEORiDRowId=0
	....f  s OEORiDRowId=$O(^xwmTemp("PosResult",ItmMast,ODDR,PAADM,OEORDRowId,OEORiDRowId)) Q:(""=OEORiDRowId)  d
	.....s CurData=$G(^xwmTemp("PosResult",ItmMast,ODDR,PAADM,OEORDRowId,OEORiDRowId))
	.....s AdmDate=$P(CurData,"^",1)
	.....s GBIDesc=$P(CurData,"^",2)
	.....s PAPERName=$P(CurData,"^",3)
	.....s PAPERSex=$P(CurData,"^",4)
	.....s Age=$P(CurData,"^",5)
	.....s ARCIMDesc=$P(CurData,"^",6)
	.....s ODDesc=$P(CurData,"^",7)
	.....s RLTResult=$P(CurData,"^",8)
	.....s RLTNormal=$P(CurData,"^",9)
	.....s Data=$lb( AdmDate, GBIDesc, PAPERName, PAPERSex, Age, ARCIMDesc, ODDesc, RLTResult, RLTNormal)
	.....d PosResultPut

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PosResultPut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchPosResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPosResultExecute ]
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

ClassMethod SearchPosResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPosResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Storage Default
{
<Data name="PosQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCP.PosQueryD</DataLocation>
<DefaultData>PosQueryDefaultData</DefaultData>
<IdLocation>^web.DHCP.PosQueryD</IdLocation>
<IndexLocation>^web.DHCP.PosQueryI</IndexLocation>
<StreamLocation>^web.DHCP.PosQueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
