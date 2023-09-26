Import sqluser

/// Descript:常用方法（公共）
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-03
Class web.DHCST.Common.UtilCommon Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// Descript:检查字符串ListStr以delim分隔的数组里是否包含字符串SubStr
/// Creator：	Zhouyg
/// CreatDate：	2011-03-08
/// Table:		
/// Input:		ListStr-需检查的字符串,SubStr-被搜索的字符串,delim-分隔符
/// Output:
/// Return:0-不存在,其他返回数组位置
ClassMethod FindInList(ListStr, SubStr, delim) As %Library.String
{
 s lenList=$L(ListStr,delim)
 s i=1
 s Ret=0
 f  s TmpStr=$p(ListStr,delim,i) q:(i>lenList)!(Ret'=0)  d
 .i (TmpStr'="")&(SubStr=TmpStr) s Ret=i q
 .s i=i+1
 q Ret
}

/// Descript:	根据两个传入单位取得转换率
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		fr, to
/// Output:		Return
/// Return：	转换率
/// Others: w ##class(web.DHCST.Common.UtilCommon).UOMFac(14,26)
ClassMethod UOMFac(fr, to)
{
 q:fr=to 1    ;if from-uom is as same as to-uom then return 1
 s rowid=""
 s rowid=$o(^CT("CTCF",0,"UOM",fr,to,rowid)) 
 ;w rowid,!
 i rowid'="" d       
 .s fac=$p(^CT("CTCF",rowid),"^",3)
 .s fac=$p(fac,$c(1))
 e  d
 .s fac=1
 q $g(fac)
}

/// Creator:zdm;
/// CreatDate:2011-04-21
/// Description:取支配科室
/// Table:
/// Input:主科室rowid
/// Return:支配科室
ClassMethod GetSubLoc(leadloc) As %Library.String
{
	q:leadloc="" "" 
	s sublocdr=""
	s strLoc=""
	f  s sublocdr=$o(^DHCDLOC(0,"LEAD",leadloc,sublocdr)) q:sublocdr=""  d
	.s useflag=$p(^DHCDLOC(sublocdr),"^",3) 
	.q:useflag'="Y"
	.i strLoc=""  d
	..s strLoc=sublocdr
	.e  d
	..s strLoc=strLoc_"^"_sublocdr
	.
	q strLoc
}

/// Description:根据ss_user的ID找CT_Hospital的信息
/// Creator:zhouyg
/// CreatDate:2009-08-11
/// Table:ss_user,Ct_loc,Ct_Hospital
/// Input:用户ss_user表RowID
/// Return:医院ID_"^"_医院代码_"^"_医院描述
ClassMethod GetUserHosp(userid) As %Library.String
{
	Q:userid="" ""
	Q:'$D(^SSU("SSUSR",userid)) ""
	S deflocdr=$P(^SSU("SSUSR",userid),"^",4)
	Q:deflocdr="" ""
	Q:'$D(^CTLOC(deflocdr)) ""
	S hospdr=$P(^CTLOC(deflocdr),"^",22)
	Q:hospdr="" ""
	Q:'$D(^CT("HOSP",hospdr)) ""
	S hospcode=$P(^CT("HOSP",hospdr),"^",1)
	S hospdesc=$P(^CT("HOSP",hospdr),"^",2)
	S retstr=hospdr_"^"_hospcode_"^"_hospdesc
	Q retstr
}

/// Description:根据科室的ID找CT_Hospital的信息
/// Creator:zhangdongmei
/// CreatDate:2012-05-04
/// Table:Ct_loc,Ct_Hospital
/// Input:科室表RowID
/// Return:医院ID_"^"_医院代码_"^"_医院描述
ClassMethod GetLocHosp(locid) As %Library.String
{
	Q:locid="" ""
	Q:'$D(^CTLOC(locid)) ""
	S hospdr=$P(^CTLOC(locid),"^",22)
	Q:hospdr="" ""
	Q:'$D(^CT("HOSP",hospdr)) ""
	S hospcode=$P(^CT("HOSP",hospdr),"^",1)
	S hospdesc=$P(^CT("HOSP",hospdr),"^",2)
	S retstr=hospdr_"^"_hospcode_"^"_hospdesc
	Q retstr
}

ClassMethod LocToRowID(TmpLoc) As %Library.String
{
 s PP=""
 &sql( SELECT CTLOC_ROWID INTO :PP FROM CT_LOC WHERE CTLOC_DESC=:TmpLoc)
 q $g(PP)
}

/// w ##class(web.DHCST.Common.UtilCommon).GetLocItmGrp(3) 
/// 获取科室项目组
ClassMethod GetLocItmGrp(locdr) As %Library.String
{
 q:locdr="" ""
 q:$d(^DHCLOC(0,"LOC",locdr))=0 ""
 s dhclocdr="",ligdr=""
 s dhclocdr=$o(^DHCLOC(0,"LOC",locdr,dhclocdr))
 q:dhclocdr="" ""
 q:$d(^DHCLOC(dhclocdr))=0 ""
 s ligdr=$p(^DHCLOC(dhclocdr),"^",2)
 q:ligdr="" ""
 q:$d(^DHCLIG(ligdr))=0 ""
 s ligdesc=$p(^DHCLIG(ligdr),"^",2)
 q $g(ligdesc)
}

/// Descript:获取科室组名称
/// Creator：zhangxiao
/// CreatDate：2013-12-09
/// Table:		
/// Input:	科室id
/// Output:
/// Return:科室组名称
/// w ##class(web.DHCST.Common.UtilCommon).GetLocGrpItm(3)
ClassMethod GetLocGrpItm(locdr) As %Library.String
{
 q:locdr="" ""
 q:$d(^DHCLOC(0,"LOC",locdr))=0 ""
 s dhclocdr="",ligdr=""
 s dhclocdr=$o(^DHCLOC(0,"LOC",locdr,dhclocdr))
 q:dhclocdr="" ""
 q:$d(^DHCLOC(dhclocdr))=0 ""
 s Slgdr=$p(^DHCLOC(dhclocdr),"^",3)
 q:Slgdr="" ""
 q:$d(^DHCSLG(Slgdr))=0 ""
 s Slgdesc=$p(^DHCSLG(Slgdr),"^",2)
 q $g(Slgdesc)
}

/// Descript:根据取整比例将目标数据取整
/// Creator：zhangdongmei
/// CreatDate：2012-07-26
/// Table:		
/// Input:	目标数，取整比例
/// Output:
/// Return:取整后的数
ClassMethod GetFinalQty(qty As %String, intfac As %String) As %String
{
 	s intfac=+intfac
 	s qtyint=$p(qty,".",1)
 	s qtydec=$p(qty,".",2)
 	i qtydec<intfac  d
 	.s finalqty=qtyint
 	e  d
 	.s finalqty=qtyint+1
 	.
 	q finalqty
}

/// Descript:计算%Library.ResultSet对象中的记录总数
/// Creator：zhangdongmei
/// CreatDate：2012-10-16
/// Table:		
/// Input:%Library.ResultSet对象
/// Output:
/// Return:记录数
ClassMethod GetResultCount(result) As %Library.String
{
	s count=0
	While(result.Next())
	{ 	
		s count = count+1
	}
	q count
}

/// 数据行之间的分隔符
/// Author:zhwh
/// Date:2012-10-25
/// Argu:
/// Return:字符
ClassMethod RowDataDelim() As %Library.String
{
  q $c(1)
}

/// 备注内容"行"之间的分隔符
/// Author:zhwh
/// Date:2012-10-25
/// Argu:
/// Return:字符
ClassMethod MemoDelim() As %Library.String
{
  q $c(3)
}

/// 检索某安全组的可访问科室
/// Author:zhwh
/// Date:2012-11-22
/// Argu: 
///  GroupId  -安全组rowid
///  LocDesc - 科室名称
///  Type - 科室类型
/// Return:
///  科室属性(科室rowid,名称)
Query GrpStockLocation(GroupId As %String, LocDesc As %String, Type As %String = "", Hosp = "") As %Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GrpStockLocationExecute(ByRef qHandle As %Binary, GroupId As %String, LocDesc As %String, Type As %String = "", Hosp = "") As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 ;
 q:GroupId="" $$$OK
 s Type=$g(Type)
 s sqlStr="Select st_ctloc_dr AS RowId,st_ctloc_dr->ctloc_desc  AS Description from ss_groupstocklocations where st_parref="_GroupId _" AND (ST_ActiveFlag IS NULL OR ST_ActiveFlag='Y')"
 i LocDesc'="" d
 .s LocDesc=$$ALPHAUP^SSUTIL4(LocDesc)
 .s sqlStr = sqlStr_" and %ALPHAUP(st_ctloc_dr->ctloc_desc) %STARTSWITH "_"'"_LocDesc_"'"
 
 i Type'="" d
 .s sqlStr = sqlStr_" and st_ctloc_dr->ctloc_type="_"'"_Type_"'"
 .
 s sqlStr = sqlStr_" ORDER BY st_ctloc_dr"
 //w sqlStr,!
 s result=##class(%ResultSet).%New()
 d result.Prepare(sqlStr)
 s sc=result.Execute()
 i $$$ISERR(sc) q $$$OK
 
 while (result.Next())
 {
	  s RowId=result.Data("RowId")
	  continue:(Hosp'="")&&(Hosp'=$p(^CTLOC(RowId),"^",22))
	  s locData = ^CTLOC(RowId)
	  s dateTo = $p(locData, "^", 25)
	  continue:(dateTo '= "")&&(dateTo <= (+$h))
	  s Description=result.Data("Description")
	  d OutPutStockLoc
 }
 d result.Close()
 q $$$OK
OutPutStockLoc
  s Data=$lb(RowId,Description)
  s ^CacheTemp(repid,ind)=Data
  s ind=ind+1
  q
}

ClassMethod GrpStockLocationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GrpStockLocationExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GrpStockLocationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GrpStockLocationExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Descript:根据供应商Id,库存项id,厂商id判断资质信息
/// Creater:    zhangxiao
/// CreateDate: 2013-05-28
/// Table:
/// Input:供应商id^库存项id^厂商id
/// Output:     
/// Return：0 合格  1供应商资质过期  2 没有维护供应商资质  3 没有厂商id   4 没有厂商资质信息
/// 5厂商资质不合格   6 没有维护库存厂商表  7厂商药品资质过期
/// w ##class(web.DHCST.Common.UtilCommon).Check("509^11^11")
/// w ##class(web.DHCST.Common.UtilCommon).Check("508^101^59")
ClassMethod Check(DataList As %String) As %Library.String
{
	//s ^ZX(111)=DataList
	s apcdr=$p(DataList,"^",1)
	s inci=$p(DataList,"^",2)
	s phmanfdr=$p(DataList,"^",3)
	s zdate=$p($h,",",1)
	s zdate=zdate+30
	s ret=0
	s ret=..CheckVendor(zdate,apcdr)
	i (ret=0) d
	.s ret=..CheckPhManf(zdate,phmanfdr,inci)
	q ret
}

/// Descript:	判断供应商资质信息
/// Creater:	zhangxiao
/// CreateDate:	2013-05-28
/// Table:DHC_STVendor ,DHC_STVendor
/// Input:+$h, venodrID
/// Output:		
/// Return：0 资质没有过期        
ClassMethod CheckVendor(zedate As %Integer, apcdr As %String) As %String
{
  s ^tmpdhy("CheckVendor")=zedate_","_apcdr
  q:zedate="" 0
  q:apcdr="" 0
  q:'$d(^DHCSTV(0,apcdr)) 2
  s dhcdr=$o(^DHCSTV(0,apcdr,""))
  q:dhcdr="" 2
  s lstpodate=$p(^APC("APCVM",apcdr,1),"^",6) //合同截止日期
  q:((lstpodate'="")&(lstpodate<zedate)&((zedate-lstpodate)>30)) 100    //合同已经过期
  q:((lstpodate'="")&(lstpodate<zedate)&((zedate-lstpodate)<30)) 101   //合同即将过期
  s comlicdate=$p(^DHCSTV(dhcdr),"^",2)
  q:((comlicdate'="")&(comlicdate<zedate)&((zedate-comlicdate)>30)) 1    //工商执照已经过期
  q:((comlicdate'="")&(comlicdate<zedate)&((zedate-comlicdate)<30)) 30   //工商执照即将过期
  //q:((comlicdate'="")&(comlicdate<zedate)) 1    //工商执照有效期
  s revregdate=$p(^DHCSTV(dhcdr),"^",24)
  q:((revregdate'="")&(revregdate<zedate)&((zedate-revregdate)>30)) 3     //税务登记已经过期
  q:((revregdate'="")&(revregdate<zedate)&((zedate-revregdate)<30)) 31     //税务登记即将过期
  s drugmanlicdate=$p(^DHCSTV(dhcdr),"^",5)
  q:((drugmanlicdate'="")&(drugmanlicdate<zedate)&((zedate-drugmanlicdate)>30)) 4    //药品经营许可证已经过期
  q:((drugmanlicdate'="")&(drugmanlicdate<zedate)&((zedate-drugmanlicdate)<30)) 32    //药品经营许可证即将过期
  s matmanlicdate=$p(^DHCSTV(dhcdr),"^",15)
  q:((matmanlicdate'="")&(matmanlicdate<zedate)&((zedate-matmanlicdate)>30)) 5       //医疗器械经营许可证已经过期
  q:((matmanlicdate'="")&(matmanlicdate<zedate)&((zedate-matmanlicdate)<30)) 33       //医疗器械经营许可证即将过期
  s matenroldate=$p(^DHCSTV(dhcdr),"^",13)
  q:((matenroldate'="")&(matenroldate<zedate)&((zedate-matenroldate)>30)) 6         //医疗器械注册证已经过期
   q:((matenroldate'="")&(matenroldate<zedate)&((zedate-matenroldate)<30)) 34         //医疗器械注册证即将过期
  s sanitationdate=$p(^DHCSTV(dhcdr),"^",26)
  q:((sanitationdate'="")&(sanitationdate<zedate)&((zedate-sanitationdate)>30)) 7       //卫生许可证已经过期
  q:((sanitationdate'="")&(sanitationdate<zedate)&((zedate-sanitationdate)<30)) 35       //卫生许可证即将过期
  s orgcodedate=$p(^DHCSTV(dhcdr),"^",19)
  q:((orgcodedate'="")&(orgcodedate<zedate)&((zedate-orgcodedate)>30)) 8            //组织机构代码已经过期
  q:((orgcodedate'="")&(orgcodedate<zedate)&((zedate-orgcodedate)<30)) 36            //组织机构代码即将过期
  s gspdate=$p(^DHCSTV(dhcdr),"^",7)
  q:((gspdate'="")&(gspdate<zedate)&((zedate-gspdate)>30)) 9                    //GSP认证已经过期
  q:((gspdate'="")&(gspdate<zedate)&((zedate-gspdate)<30)) 37                    //GSP认证即将过期
  s matprodate=$p(^DHCSTV(dhcdr),"^",17)
  q:((matprodate'="")&(matprodate<zedate)&((zedate-matprodate)>30)) 10             //医疗器械生产许可证已经过期
  q:((matprodate'="")&(matprodate<zedate)&((zedate-matprodate)<30)) 38            //医疗器械生产许可证即将过期
  s propermitdate=$p(^DHCSTV(dhcdr),"^",22)
  q:((propermitdate'="")&(propermitdate<zedate)&((zedate-propermitdate)>30)) 11          //生产制造认可表已经过期
  q:((propermitdate'="")&(propermitdate<zedate)&((zedate-propermitdate)<30)) 39          //生产制造认可表即将过期
  s impenroldate=$p(^DHCSTV(dhcdr),"^",9)
  q:((impenroldate'="")&(impenroldate<zedate)&((zedate-impenroldate)>30)) 12         // 进口医疗器械注册证已经过期
  q:((impenroldate'="")&(impenroldate<zedate)&((zedate-impenroldate)<30)) 40         // 进口医疗器械注册证即将过期
  s implicdate=$p(^DHCSTV(dhcdr),"^",11)
  q:((implicdate'="")&(implicdate<zedate)&((zedate-implicdate)>30)) 13               //进口注册登记表已经过期
  q:((implicdate'="")&(implicdate<zedate)&((zedate-implicdate)<30)) 41               //进口注册登记表即将过期
  s agentlicdate=$p(^DHCSTV(dhcdr),"^",30)
  q:((agentlicdate'="")&(agentlicdate<zedate)&((zedate-agentlicdate)>30)) 14           //代理销售授权书已经过期
  q:((agentlicdate'="")&(agentlicdate<zedate)&((zedate-agentlicdate)<30)) 42           //代理销售授权书即将过期
  s qualitydate=$p(^DHCSTV(dhcdr),"^",31)
  q:((qualitydate'="")&(qualitydate<zedate)&((zedate-qualitydate)>30)) 15              //质量承诺书已经过期
  q:((qualitydate'="")&(qualitydate<zedate)&((zedate-qualitydate)<30)) 43              //质量承诺书即将过期
  s salesdate=$p(^DHCSTV(dhcdr),"^",33)
  q:((salesdate'="")&(salesdate<zedate)&((zedate-salesdate)>30)) 16                    //业务员授权书已经过期
  q:((salesdate'="")&(salesdate<zedate)&((zedate-salesdate)<30)) 44                    //业务员授权书即将过期
  q 0
}

/// Descript:	判断厂商资质信息
/// Creater:	zhangxiao
/// CreateDate:	2013-05-28
/// Table:DHC_Manf_AddionInfo ,  DHC_ItmRemark 
/// Input:+$h, manfID, incId
/// Output:		
/// Return：0 合格   
ClassMethod CheckPhManf(zedate As %Integer, phmanfdr As %String, inci As %String) As %String
{
	//n (zedate,phmanfdr,inci)
	q:inci="" 0
	q:phmanfdr="" 17       //没有厂商信息
	q:'$d(^DHCMANF(0,"MANF",phmanfdr)) 18
	s manfdr=$o(^DHCMANF(0,"MANF",phmanfdr,""))   // 厂商附加信息rowid
	q:manfdr="" 18
	s DrugProductExpDate=$p(^DHCMANF(manfdr),"^",4)
	q:((DrugProductExpDate'="")&(DrugProductExpDate<zedate)&((zedate-DrugProductExpDate)>30)) 19 //厂商药品生产许可证已经过期
	q:((DrugProductExpDate'="")&(DrugProductExpDate<zedate)&((zedate-DrugProductExpDate)<30)) 45 //厂商药品生产许可证即将过期
	s MatProductExpDate=$p(^DHCMANF(manfdr),"^",6)
	q:((MatProductExpDate'="")&(MatProductExpDate<zedate)&((zedate-MatProductExpDate)>30)) 20 //厂商材料生产许可证已经过期
	q:((MatProductExpDate'="")&(MatProductExpDate<zedate)&((zedate-MatProductExpDate)<30)) 46 //厂商材料生产许可证即将过期
	s ComLicDate=$p(^DHCMANF(manfdr),"^",9)
	q:((ComLicDate'="")&(ComLicDate<zedate)&((zedate-ComLicDate)>30)) 21         //厂商工商执照已经过期
	q:((ComLicDate'="")&(ComLicDate<zedate)&((zedate-ComLicDate)<30)) 47         //厂商工商执照即将过期
	s BusinessRegExpDate=$p(^DHCMANF(manfdr),"^",12)
	q:((BusinessRegExpDate'="")&(BusinessRegExpDate<zedate)&((zedate-BusinessRegExpDate)>30)) 22  //工商注册号已经过期
	q:((BusinessRegExpDate'="")&(BusinessRegExpDate<zedate)&((zedate-BusinessRegExpDate)<30)) 48  //工商注册号即将过期
	s OrgCodeExpDate=$p(^DHCMANF(manfdr),"^",14)
	q:((OrgCodeExpDate'="")&(OrgCodeExpDate<zedate)&((zedate-OrgCodeExpDate)>30)) 23  //组织机构代码已经过期
	q:((OrgCodeExpDate'="")&(OrgCodeExpDate<zedate)&((zedate-OrgCodeExpDate)<30)) 49  //组织机构代码即将过期
	s MatManLicExpDate=$p(^DHCMANF(manfdr),"^",17)
	q:((MatManLicExpDate'="")&(MatManLicExpDate<zedate)&((zedate-MatManLicExpDate)>30)) 24  //器械经营许可证已经过期
	q:((MatManLicExpDate'="")&(MatManLicExpDate<zedate)&((zedate-MatManLicExpDate)<30)) 50  //器械经营许可证即将过期
	q:'$d(^ITMREK(0,"INCIMNF",inci,phmanfdr)) 25
	s ItmRemark=$o(^ITMREK(0,"INCIMNF",inci,phmanfdr,""))
	q:ItmRemark="" 25
	s TextExpDate=$p(^ITMREK(ItmRemark),"^",10)          
	q:((TextExpDate'="")&(TextExpDate<zedate)&((zedate-TextExpDate)>30)) 26  //物资批准文号有效期已经过期
	q:((TextExpDate'="")&(TextExpDate<zedate)&((zedate-TextExpDate)<30)) 51  //物资进口注册证效期即将过期
	s RegCertExpDate=$p(^ITMREK(ItmRemark),"^",12)         
	q:((RegCertExpDate'="")&(RegCertExpDate<zedate)&((zedate-RegCertExpDate)>30)) 27 //物资进口注册证效期已经过期
	q:((RegCertExpDate'="")&(RegCertExpDate<zedate)&((zedate-RegCertExpDate)<30)) 52 //物资进口注册证效期即将过期
	q 0
}

/// Descript:返回一条record(json)
/// Creator：wangjiabin
/// CreatDate：2013-06-24
/// Table:		
/// Input:数据串, 标题串, 分隔符
/// Output:
/// Return:记录数
ClassMethod GetJsonStr(dataStr, titleStr, del = "^") As %Library.String
{
	q:dataStr="" "{}"
	q:titleStr="" "{}"
	s len=$l(dataStr,del)
	s tlen=$l(titleStr,del)
	q:len'=tlen "{}"
	s jsonStr="{"
	f i=1:1:len  d
	.s data=$p(dataStr,del,i)
	.s data=..Replace(data,"\","\\")	;替换转义序列,防js显示错误
	.s data=..Replace(data,"'","\'")
	.s title=$p(titleStr,del,i)
	.i i=1 d
	..s jsonStr=jsonStr_title_":'"_data_"'"
	.e  d
	..s jsonStr=jsonStr_","_title_":'"_data_"'"
	.
	s jsonStr=jsonStr_"}"
	
	s jsonStr=$tr(jsonStr,$c(13,10))
	q jsonStr
}

ClassMethod Replace(data, frStr, toStr) As %Library.String
{
	q $Replace(data,frStr,toStr)
}

/// w ##class(web.DHCST.Common.UtilCommon).SplitDelim()
ClassMethod SplitDelim()
{
	q "|@|"
}

/// Description:给小于1少0的小数补0
/// Creator:	hulihua
/// CreateDate:	2019-01-28
/// Table:      number-原数字
/// Input:		
/// Output:	    
/// Return：	补零后的数字    
/// Others:     
/// Debug:		w ##class(web.DHCST.Common.UtilCommon).AddZero(".5")
ClassMethod AddZero(number)
{
	q:$F(number,".")=0 number
	q:(number'<1)||(number'>-1) number
	q:$p(number,".")'="" number
	s newnumber=$fn(number,"",$l($p(number,".",2)))
	q newnumber
}

/// 获取IP 2021-08-02 yangsj
/// w ##class(web.DHCST.Common.UtilCommon).ServerIP()
ClassMethod ServerIP()
{
	new
	s SERVER=$p($zu(54,13,$zu(54,0)),",")
	q SERVER
}

/// 新建一个方法存旧供应商 和 厂商的资质信息验证
/// 没有任何作用，就是替换方法时给旧方法做个记录
///  2021-09-07 yangsj
Method RecordCertInfo()
{
	/*
	.s ApcWarn=""
    .s ret=##class(web.DHCST.Common.UtilCommon).Check(VenId_"^"_Inci_"^"_ManfId)
    .i (ret=1) d
    ..s ApcWarn="供应商工商执照将在30天内过期"
    .i (ret=3) d
    ..s ApcWarn="供应商税务登记号将在30天内过期!"
    .i (ret=4) d
    ..s ApcWarn="供应商药品经营许可证将在30天内过期!"
    .i (ret=5) d
    ..s ApcWarn="供应商医疗器械经营许可证将在30天内过期!"
    .i (ret=6) d
    ..s ApcWarn="供应商医疗器械注册证将在30天内过期!"
    .i (ret=7) d
    ..s ApcWarn="供应商卫生许可证将在30天内过期!"
    .i (ret=8) d
    ..s ApcWarn="供应商组织机构代码将在30天内过期!"
    .i (ret=9) d
    ..s ApcWarn="供应商GSP认证将在30天内过期!"
    .i (ret=10) d
    ..s ApcWarn="供应商医疗器械生产许可证将在30天内过期!"
    .i (ret=11) d
    ..s ApcWarn="供应商生产制造认可表将在30天内过期!"
    .i (ret=12) d
    ..s ApcWarn="供应商进口医疗器械注册证将在30天内过期!"
    .i (ret=13) d
    ..s ApcWarn="供应商进口注册登记表将在30天内过期!"
    .i (ret=14) d
    ..s ApcWarn="供应商代理销售授权书将在30天内过期!"
    .i (ret=15) d
    ..s ApcWarn="供应商质量承诺书将在30天内过期!"
    .i (ret=16) d
    ..s ApcWarn="供应商业务员授权书将在30天内过期!"
    .i (ret=19) d
    ..s ApcWarn="厂商药品生产许可证将在30天内过期!"
    .i (ret=20) d
    ..s ApcWarn="厂商物资生产许可证将在30天内过期!"
    .i (ret=21) d
    ..s ApcWarn="厂商工商执照在30天内过期!"
    .i (ret=22) d
    ..s ApcWarn="厂商工商注册号将在30天内过期!"
    .i (ret=24) d
    ..s ApcWarn="厂商器械经营许可证将在30天内过期!"
    .i (ret=26) d
    ..s ApcWarn="物资批准文号将在30天内过期!"
    .i (ret=27) d
    ..s ApcWarn="物资进口注册证将在30天内过期!"
	*/
}

}
