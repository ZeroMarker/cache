Import SQLUser

/// 体检公用类 Create by MLH 2006-05-11
Class web.DHCPE.DHCPECommon Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

/// Creator: xueying
/// CreateDate: 2018-08-08
/// Descript: custom类型元素下拉框样式hisui
/// w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle()
ClassMethod GetDefaultStyle(name, width)
{
	if (width="")||(width=0) s width=155
	q "<select name='"_name_"' id='"_name_"' style='width:"_width_"px;HEIGHT:30px;' class='hisui-combobox'>"
}

ClassMethod GetDefaultStyleNoEdit(name, width)
{
	if (width="")||(width=0) s width=155
	q "<select name='"_name_"' id='"_name_"' style='width:"_width_"px;HEIGHT:30px;' editable='false' class='hisui-combobox'>"
}

/// Creator: xueying
/// added by xy 20180906
/// function:获取服务器IP
ClassMethod getSet() As %String
{
   //w ##class(web.DHCPE.DHCPECommon).getSet()
	s id=$O(^Nur.DHCMGNurseSetD(""))
	if id="" q ""
	s db=$ListGet(^Nur.DHCMGNurseSetD(id),2)
	s websv=$ListGet(^Nur.DHCMGNurseSetD(id),3)
	s genpath=$ListGet(^Nur.DHCMGNurseSetD(id),4)
	//q db_"^"_websv_"^"_genpath
	Q websv
}

// 导入数据Created by MLH

ClassMethod ExportAllData()
{
	d ..ExpDHCPEStation()			//站点信息DHC_PE_Station
	d ..ExpDHCPEStationOrder()  	//站点和体检大项（医嘱）对照表DHC_PE_StationOrder
	d ..ExpDHCPEOrderDetail()		//细项表DHC_PE_OrderDetail
	d ..ExpDHCPEOrderDetailRelate()	//大项和细项组合关系对照表DHC_PE_OrderDetailRelate
	d ..ExpDHCPEODStandard()		//体检标准DHC_PE_ODStandard
	
	//d ..ExpDHCPEExpertDiagnosis()	//专家诊断主表DHC_PE_ExpertDiagnosis
	//d ..ExpDHCPEEDCondition()		//专家诊断条件表DHC_PE_EDCondition
	q 0
}

ClassMethod ExpDHCPEStation()
{
	s f="/trakcare/ExpDHCPEStation.TXT"
 	s num=1
 	o f:"WNS"
 	u f
 	w !,"Code^Desc^Place^Sequence^Active"
 	s STRowId=0
 	f  s STRowId=$o(^DHCPEST(STRowId)) q:STRowId=""  d
 	.s Code=$p(^DHCPEST(STRowId),"^",1)
 	.s Desc=$p(^DHCPEST(STRowId),"^",2)
 	.s Place=$p(^DHCPEST(STRowId),"^",3)
 	.s Sequence=$p(^DHCPEST(STRowId),"^",4)
 	.s Active=$p(^DHCPEST(STRowId),"^",5)
	.w !,Code,"^",Desc,"^",Place,"^",Sequence,"^",Active
 	.s num=num+1
 	c f
 	q 0
}

ClassMethod ExpDHCPEStationOrder()
{
	s f="/trakcare/ExpDHCPEStationOrder.TXT"
 	s num=1
 	o f:"WNS"
 	u f
 	w !,"StationCode^ArcimRowId^ArcimCode^ArcimDesc"
 	s STRowId=0
 	f  s STRowId=$o(^DHCPEST(STRowId)) q:STRowId=""  d
 	.s ChdRowId=0
 	.f  s ChdRowId=$o(^DHCPEST(STRowId,"O",ChdRowId)) q:ChdRowId=""  d
 	..s Arcim=^DHCPEST(STRowId,"O",ChdRowId)
 	..q:$g(^ARCIM($p(Arcim,"||",1),1,1))=""
 	..s ArcimCode=$p(^ARCIM($p(Arcim,"||",1),1,1),"^",1)
 	..s ArcimDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(Arcim)
 	..s STCode=$p(^DHCPEST(STRowId),"^",1)
	..w !,STCode,"^",Arcim,"^",ArcimCode,"^",ArcimDesc
 	..s num=num+1
 	c f
 	q 0
}

ClassMethod ExpDHCPEOrderDetail()
{
	s f="/trakcare/ExpDHCPEOrderDetail.TXT"
 	s num=1
 	o f:"WNS"
 	u f
 	//w !,"STCode^STDecs^DetailCode^Desc^Type^Expression^Unit^Summary^Advice^Explain^Sequence^Sex^LabtrakCode"
 	s STRowId=0
 	f  s STRowId=$o(^DHCPEST(STRowId)) q:STRowId=""  d
 	.s ChdRowId=0
 	.f  s ChdRowId=$o(^DHCPEST(STRowId,"OD",ChdRowId)) q:ChdRowId=""  d
 	..s ODStr=$g(^DHCPEST(STRowId,"OD",ChdRowId))
 	..q:ODStr=""
 	..s STCode=$p(^DHCPEST(STRowId),"^",1)
 	..s STDecs=$p(^DHCPEST(STRowId),"^",2)
	..//w !,STCode,"^",STDecs,"^^",ODStr
 	..s num=num+1
 	c f
 	q 0
}

ClassMethod ExpDHCPEOrderDetailRelate()
{
	s f="/trakcare/ExpDHCPEOrderDetailRelate.TXT"
 	s num=1
 	o f:"WNS"
 	u f
 	w !,"ArcimCode^ArcimDesc^DetailCode^DetailDesc"
 	s ODRRowId=0
 	f  s ODRRowId=$o(^DHCPEODR(ODRRowId)) q:ODRRowId=""  d
 	.s Arcim=$p(^DHCPEODR(ODRRowId),"^",1)
 	.q:$g(^ARCIM($p(Arcim,"||",1),1,1))=""
 	.s ArcimCode=$p(^ARCIM($p(Arcim,"||",1),1,1),"^",1)
 	.s ArcimDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(Arcim)
 	.s DetailRowId=$p(^DHCPEODR(ODRRowId),"^",2)
 	.q:$g(^DHCPEST($p(DetailRowId,"||",1),"OD",$p(DetailRowId,"||",2)))=""
 	.s DetailCode=$p($g(^DHCPEST($p(DetailRowId,"||",1),"OD",$p(DetailRowId,"||",2))),"^",11)
 	.s DetailDesc=$p($g(^DHCPEST($p(DetailRowId,"||",1),"OD",$p(DetailRowId,"||",2))),"^",1)
	.w !,ArcimCode,"^",ArcimDesc,"^",DetailCode,"^",DetailDesc
 	.s num=num+1
 	c f
 	q 0
}

ClassMethod ExpDHCPEODStandard()
{
	s f="/trakcare/ExpDHCPEODStandard.TXT"
 	s num=1
 	o f:"WNS"
 	u f
 	//w !,"STCode^STDesc^DetailCode^DetailDesc^Sex^TextVal^Unit_DR^Min^Max^NatureValue"
 	s STRowId=0
 	f  s STRowId=$o(^DHCPEST(STRowId)) q:STRowId=""  d
 	.s ODRowId=0
 	.f  s ODRowId=$o(^DHCPEST(STRowId,"OD",ODRowId)) q:ODRowId=""  d
 	..s ChdRowId=0
 	..f  s ChdRowId=$o(^DHCPEST(STRowId,"OD",ODRowId,"ODS",ChdRowId)) q:ChdRowId=""  d
 	...s ODSStr=$g(^DHCPEST(STRowId,"OD",ODRowId,"ODS",ChdRowId))
 	...q:ODSStr=""
 	...s STCode=$p($g(^DHCPEST(STRowId)),"^",1)
 	...s STDesc=$p($g(^DHCPEST(STRowId)),"^",2)
 	...q:STCode=""
 	...s DetailCode=$p($g(^DHCPEST(STRowId,"OD",ODRowId)),"^",11)
 	...s DetailDesc=$p($g(^DHCPEST(STRowId,"OD",ODRowId)),"^",1)
	...//w !,STCode,"^",STDesc,"^",DetailCode,"^",DetailDesc,"^",ODSStr
 	...s num=num+1
 	c f
 	q 0
}

ClassMethod KillPEGlobal()
{
	;d KillBaseData //基本数据
	d KillPEData   //业务数据
	q 0
KillBaseData
	k ^DHCPEST    //1、站点信息DHC_PE_Station
				  //2、站点和体检大项（医嘱）对照表DHC_PE_StationOrder
				  //3、细项表DHC_PE_OrderDetail
			      //4、体检标准DHC_PE_ODStandard
				  //5、站点等候客户排队表DHC_PE_StationWait（DHC_PE_Station的子表）
	k ^DHCPEODR   //大项和细项组合关系对照表DHC_PE_OrderDetailRelate
	
	k ^DHCPEED    //专家诊断主表DHC_PE_ExpertDiagnosis,专家诊断条件表DHC_PE_EDCondition
	k ^DHCPEGC	  //安全组权限表DHC_PE_GroupChart
	q
KillPEData
	k ^DHCPEGBI   //团体客户基本信息登记表DHC_PE_GBaseInfo
	k ^DHCPEGADM  //1、团体客户ADM表 DHC_PE_GADM
				  //2、团体分组表 DHC_PE_GTeam（团体ADM表的子表）
	k ^DHCPEIADM  //体检人员表ADM表DHC_PE_IADM
	k ^DHCPEACO	  //视同收费项目费用状态表DHC_PE_AsChargedOrder（挂账）
	k ^DHCPECRMO  //与CRM大项对照表DHC_PE_CRMOrder
	
	k ^DHCPERLT   //体检结果表DHC_PE_Result
	k ^DHCPERPT   //体检报告DHC_PE_Report
	k ^DHCPESS    //科室小结
	k ^DHCPEGA	  //总检建议DHC_PE_GeneralAdvice
				  //总检建议明细表DHC_PE_GeneralAdviceDetail
	k ^DHCPEGS	  //总检结论DHC_PE_GeneralSummarize
	
	k ^DHCPEPreIBI
   k ^DHCPEPreIADM
   k ^DHCPEIADM
  k ^DHCPEPreGBI
  k ^DHCPEPreA
  k ^DHCPEPAPBR
  k ^DHCPEGBI
  k ^DHCPEGADM
  k ^DHCPECRMO
  k ^DHCPESS
  k ^DHCPEGS
  k ^DHCPEGGS
  k ^DHCPEGSDM
  k ^DHCPERPT
 k ^DHCPERLT
 k ^DHCPEINVPRT
 k ^DHCPEUSERREPORT
 k ^DHCPEACO
 k ^DHCPEAP
 k ^DHCPEData("DHCPEResult","RIS","ReportUser")
 k ^DHCPEDataEx("DHCPEIADM","Diet")
 k ^DHCPEDataEx("DHCPEIADM","Gift")
 k ^DHCPEDataEx("DHCPEPreIADM","PayType")
 k ^DHCPEDataEx("DHCPEPreIADM","Percent")
 k ^DHCPEDataEx("DHCPEPreIADM","InsureUnit")
 k ^DHCPEDataEx("DHCPEPreIADM","DietFlag")
 k ^DHCPEDataEx("DHCPEPreIADM","GiftFlag")
 k ^DHCPEDataEx("DHCPEPreIADM","GTEAM")
 k ^DHCPEDataEx("DHCPEPreIADM","GTEAM","IADM")
 k ^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime")
 k ^DHCPEDataEx("DHCPEPreGADM","Percent")
 k ^DHCPEDataEx("DHCPEPreGADM","ADMType")
 k ^DHCPEDataEx("DHCPEPreGADM","GetReportDateTime")
 k ^DHCPEDataEx("DHCPEPreGADM","PayType")
 k ^DHCPEDataEx("DHCPEPreGADM","DietFlag")
 k ^DHCPEDataEx("DHCPEPreGADM","GiftFlag")
 k ^DHCPECBVIPLevel("PIBI") 
	q
}

ClassMethod ImportAllData()
{
	d ..ImpDHCPEStation()
	//d ..ImpDHCPEStationOrder()
	//d ..ImpDHCPEOrderDetail()
	//d ..ImpDHCPEOrderDetailRelate()
	//d ..ImpDHCPEODStandard()
	q 0
}

ClassMethod ImpDHCPEStation()
{
	k ^zTSA($zn)
 	d upload
 	k ^zTSA($zn)
 	q
 	;
upload 
 	s file="\TrakCare\DataLoad\Station.txt",sub="DHCPEStation"
 	d file(file,sub)
 	d Station
 	q
file(file,sub) ;process file
	b
 	//s $zt="close^"_$zn
 	w "File Upload Starting...",!
 	//o file
 	o file:"RS":2
 	u file
 	//s sRec=""
 	f  d
 	. r sRec
 	. s num=$g(^zTSA($zn,sub,0))+1
 	. s ^zTSA($zn,sub,0)=num
 	. s ^zTSA($zn,sub,num)=$tr(sRec,$c(4),"^")
close c file
 	w "File Upload Finished!",!!
 	q
 	;;;;;;;;;;;;;;;;;;;;;;;;;;;        
Station ; insert DHC_PE_Station
 	k
 	k ^REJECT($ZN)
 	;  
 	//"Code^Desc^Place^Sequence^Active"
 	s ind=1,sub="DHCPEStation"
 	f  s ind=$o(^zTSA($ZN,sub,ind)) q:ind=""  d
 	.s STStr=^zTSA($ZN,sub,ind)
 	.s Code=$p(STStr,"^",1)
 	.s Desc=$p(STStr,"^",2)
 	.s Place=$p(STStr,"^",3)
 	.s Sequence=$p(STStr,"^",4)
 	.;
 	.i Code="" d rej("Code is NULL: "_ind) q
 	.s Code=$ZCVT(Code,"U")
 	.i Code'="" s STRecord="" s STRecord=$o(^DHCPEST(0,"Code",$ZCVT(Code,"U"),"")) d:$d(STRecord)'=0 rej("Desc is alreafy exist: "_ind_","_Code)
 	.i $d(STRecord)'=0 q
 	.;
 	.i Desc="" d rej("Desc is NULL: "_ind_","_Desc) q
 	.i Desc'="" s STRecord="" s STRecord=$o(^DHCPEST(0,"Desc",$ZCVT(Desc,"U"),"")) d:$d(STRecord)'=0 rej("Desc is alreafy exist: "_ind_","_Desc)
 	.i $d(STRecord)'=0 q
  	.;////
 	.&SQL(INSERT INTO DHC_PE_Station(ST_Code,ST_Desc,ST_Place,ST_Sequence) VALUES (:Code,:Desc,:Place,:Sequence))
	.i $g(SQLCODE) d rej(ind_","_code_" -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
 	.;
 	q
rej(param) 
 //n (param) 
 s count=$o(^REJECT($ZN,""),-1)+1,^REJECT($ZN,count)=param
 w !,^REJECT($zn,count)
 q
}

ClassMethod ImpDHCPEOrderDetail()
{
	k ^zTSA($zn)
 	d upload
 	k ^zTSA($zn)
 	q
 	;
upload 
 	s file="D:\TrakCare\DataLoad\ExpDHCPEOrderDetail.txt",sub="DHCPEOrderDetail"
 	d file(file,sub)
 	d OrderDetail
 	q
file(file,sub) ;process file
 	//s $zt="close^"_$zn
 	w "File Upload Starting...",!
 	o file
 	u file
 	f  d
 	. r sRec
 	. s num=$g(^zTSA($zn,sub,0))+1
 	. s ^zTSA($zn,sub,0)=num
 	. s ^zTSA($zn,sub,num)=$tr(sRec,$c(9),"^")
close c file
 	w "File Upload Finished!",!!
 	q
 	;;;;;;;;;;;;;;;;;;;;;;;;;;;        
OrderDetail ; insert DHC_PE_OrderDetail
 	k
 	k ^REJECT($ZN)
 	;  
 	s ind=1,sub="DHCPEOrderDetail"
 	//"STCode^STDecs^DetailCode^Desc^Type^Expression^Unit^Summary^Advice^Explain^Sequence^Sex^LabtrakCode"
 	f  s ind=$o(^zTSA($ZN,sub,ind)) q:ind=""  d
 	.s ODStr=^zTSA($ZN,sub,ind)
 	.s STCode=$p(ODStr,"^",1)
 	.;
 	.i STCode="" d rej("STCode is NULL: "_ind) q
 	.;
 	.s STRowId=$o(^DHCPEST(0,"Code",STCode,0))
 	.i STRowId="" d rej("STRowId is NULL: "_ind) q
 	.;
 	.s DetailCode=$p(ODStr,"^",3)
 	.i DetailCode="" d rej("DetailCode is NULL: "_ind) q
	.s DetailCode=$ZCVT(DetailCode,"U")
 	.i DetailCode'="" s DetailRecord="" s DetailRecord=$o(^DHCPEST(0,"OD_Code",$ZCVT(DetailCode,"U"),STRowId,"")) d:$d(DetailRecord)'=0 rej("DetailCode is alreafy exist: "_ind_","_DetailCode)
 	.i $d(DetailRecord)'="" q
 	.;
 	.s Desc=$p(ODStr,"^",4)
 	.i Desc="" d rej("Desc is NULL: "_ind) q
 	.;
 	.s Type=$p(ODStr,"^",5)
 	.s Expression=$p(ODStr,"^",6)
 	.s Sex=$p(ODStr,"^",12)
 	.s LabtrakCode=$p(ODStr,"^",13)
 	.;
 	.&SQL(INSERT INTO DHC_PE_OrderDetail(OD_ParRef,OD_Code,OD_Desc,OD_Type,OD_Expression,OD_Sex,OD_LabtrakCode) VALUES (:STRowId,:DetailCode,:Desc,:Type,:Expression,:Sex,:LabtrakCode))
	.i $g(SQLCODE) d rej(ind_","_code_" -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
 	.;
 	q
rej(param) 
	//n (param) 
	s count=$o(^REJECT($ZN,""),-1)+1,^REJECT($ZN,count)=param
	w !,^REJECT($zn,count)
	q
}

ClassMethod ImpDHCPEOrderDetailRelate()
{
	k ^zTSA($zn)
 	d upload
 	k ^zTSA($zn)
 	q
 	;
upload 
 	s file="D:\TrakCare\DataLoad\ExpDHCPEOrderDetailRelate.txt",sub="DHCPEOrderDetailRelate"
 	d file(file,sub)
 	d OrderDetailRelate
 	q
file(file,sub) ;process file
 	//s $zt="close^"_$zn
 	w "File Upload Starting...",!
 	o file
 	u file
 	f  d
 	. r sRec
 	. s num=$g(^zTSA($zn,sub,0))+1
 	. s ^zTSA($zn,sub,0)=num
 	. s ^zTSA($zn,sub,num)=$tr(sRec,$c(9),"^")
close c file
 	w "File Upload Finished!",!!
 	q
 	;;;;;;;;;;;;;;;;;;;;;;;;;;;        
OrderDetailRelate ; insert DHC_PE_OrderDetailRelate
 	k
 	k ^REJECT($ZN)
 	;  
 	s ind=1,sub="DHCPEOrderDetailRelate"
	//"ArcimCode^ArcimDesc^DetailCode^DetailDesc"
 	f  s ind=$o(^zTSA($ZN,sub,ind)) q:ind=""  d
 	.s ODRStr=^zTSA($ZN,sub,ind)
 	.s ArcimCode=$p(ODStr,"^",1)
 	.;
 	.i ArcimCode="" d rej("ArcimCode is NULL: "_ind) q
	.s ArcimRowId=$o(^ARCIM(0,"Code",$ZCVT(ArcimCode,"U"),0)) 
 	.i ArcimRowId="" d rej("ArcimRowId is not exist: "_ind) q
 	.;
 	.s DetailCode=$p(ODRStr,"^",3)
 	.i DetailCode="" d rej("DetailCode is NULL: "_ind) q
 	.&SQL(Select OD_RowId Into :DetailRowId from DHC_PE_OrderDetail Where OD_Code=:DetailCode)
 	.;
 	.&SQL(INSERT INTO DHC_PE_OrderDetailRelate(ODR_ARCIM_DR,ODR_OD_DR) VALUES (:ArcimRowId,:DetailRowId))
	.i $g(SQLCODE) d rej(ind_","_code_" -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
 	.;
 	q
rej(param) 
 //n (param) 
 s count=$o(^REJECT($ZN,""),-1)+1,^REJECT($ZN,count)=param
 w !,^REJECT($zn,count)
 q
}

ClassMethod ImpDHCPEODStandard()
{
	k ^zTSA($zn)
 	d upload
 	k ^zTSA($zn)
 	q
 	;
upload 
 	s file="D:\TrakCare\DataLoad\ExpDHCPEODStandard.txt",sub="DHCPEODStandard"
 	d file(file,sub)
 	d ODStandard
 	q
file(file,sub) ;process file
 	//s $zt="close^"_$zn
 	w "File Upload Starting...",!
 	o file
 	u file
 	f  d
 	. r sRec
 	. s num=$g(^zTSA($zn,sub,0))+1
 	. s ^zTSA($zn,sub,0)=num
 	. s ^zTSA($zn,sub,num)=$tr(sRec,$c(9),"^")
close c file
 	w "File Upload Finished!",!!
 	q
 	;;;;;;;;;;;;;;;;;;;;;;;;;;;        
ODStandard ; insert DHC_PE_DHCPEODStandard
 	k
 	k ^REJECT($ZN)
 	;  
 	s ind=1,sub="DHCPEODStandard"
	//"STCode^STDesc^DetailCode^DetailDesc^Sex^TextVal^Unit_DR^Min^Max^NatureValue"
 	f  s ind=$o(^zTSA($ZN,sub,ind)) q:ind=""  d
 	.s ODSStr=^zTSA($ZN,sub,ind)
 	.s STCode=$p(ODSStr,"^",1)
 	.i STCode="" d rej("STCode is NULL: "_ind) q
 	.;
 	.s STRowId=$o(^DHCPEST(0,"Code",STCode,0))
 	.i STRowId="" d rej("STRowId is NULL: "_ind) q
	.;
	.s DetailCode=$p(ODSStr,"^",3)
	.i DetailCode="" d rej("DetailCode is NULL: "_ind) q
	.;
	.&SQL(Select OD_RowId Into :DetailRowId from DHC_PE_OrderDetail Where OD_Code=:DetailCode)
	.s Parref=STRowId_"||"_DetailRowId
 	.;
 	.s Sex=$p(ODSStr,"^",5)
 	.s TextVal=$p(ODSStr,"^",6)
 	.s Min=$p(ODSStr,"^",8)
 	.s Max=$p(ODSStr,"^",9)
 	.s NatureValue=$p(ODSStr,"^",10)
 	.;
 	.&SQL(INSERT INTO DHC_PE_ODStandard(ODS_ParRef,ODS_Sex,ODS_TextVal,ODS_Min,ODS_Max,ODS_NatureValue) VALUES (:Parref,:Sex,:TextVal,:Min,:Max,:NatureValue))
	.i $g(SQLCODE) d rej(ind_","_code_" -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
 	.;
 	q
rej(param) 
 //n (param) 
 s count=$o(^REJECT($ZN,""),-1)+1,^REJECT($ZN,count)=param
 w !,^REJECT($zn,count)
 q
}

ClassMethod Replace(expression As %String, find As %String, replacewith As %String) As %String [ Language = basic ]
{
	return Replace(expression,find,replacewith)
}

// w ##class(web.DHCPE.DHCPECommon).GetPY("国")

/// /##class(web.DHCPE.DHCPECommon).GetComponentID
ClassMethod GetComponentID(Name)
{
	s ID=0
	&SQL(select id into :ID from websys.Component where name = :Name)
	q ID
}

/// w ##class(web.DHCPE.DHCPECommon).RegNoMask(1)
ClassMethod RegNoMask(RegNo, CTLocID As %String = "")
{
	i CTLocID="" 
	{
		s:$D(%session) CTLocID=%session.Get("LOGON.CTLOCID")
		s:CTLocID="" CTLocID = $O(^DHCPESetting("DHCPE","RegNoLength",""))
	}
	q:RegNo="" ""
	//s RegNo=$ZCVT(RegNo,"U")
	//s length=+$G(^DHCPESetting("DHCPE","RegNoLength"))
	s length=+$G(^DHCPESetting("DHCPE","RegNoLength",CTLocID))
	q:length=0 RegNo
	s ZeroStr=$E("00000000000000000000000000",1,length)
	s RegNo=$E(ZeroStr,1,length-$l(RegNo))_RegNo
	
	q RegNo
}

// s value=##class(web.DHCPE.DHCPECommon).UnEscape(value)

ClassMethod UnEscape(InStr As %String) As %String
{
	;w ##class(web.DHCPE.DHCPECommon).UnEscape("%u738B");
	s num=1,retStr="",tmpNum=1	
	f num=1:1:$l(InStr,"%") d
	.s char=$p(InStr,"%",num) 
	.i num=1 d
	..s retStr=$e(char,1,$l(char))
	.e  d
	..i $e(char,1,1)'="u" d
	...s retStr=retStr_$char($zhex($e(char,1,2)))_$e(char,3,$l(char))
	..e  d
	...s retStr=retStr_$char($zhex($e(char,2,5)))_$e(char,6,$l(char))
	q retStr
}

// w ##class(web.DHCPE.DHCPECommon).GetCurAge("1978-09-09")

ClassMethod GetCurAge(Birth, Date As %String = "")
{
	i $L(Birth,"-")=3
	{
		s Birth=$ZDH(Birth,3)
	}
	i $L(Birth,"/")=3
	{
		s Birth=$ZDH(Birth,4)
	}
	
	i Date="" s Date=$H
	i $L(Date,"-")=3
	{
		s Date=$ZDH(Date,3)
	}
	i $L(Date,"/")=3
	{
		s Date=$ZDH(Date,4)
	}
	q +##class(web.DHCLCNUREXCUTE).CalAge(Birth,Date)
}

/// 得到医嘱名称 w ##class(web.DHCPE.DHCPECommon).GetArcDesc(200,"C")
/// Type:A:Arc_ItmMast  P:DHC_PE_PreIOrdItem  O:OE_OrdItem  C:DHC_PE_CrmOrder
ClassMethod GetArcDesc(ID, Type As %String = "A", LocID As %String = "")
{
	i (LocID="")&&($D(%session)) s LocID=%session.Get("LOGON.CTLOCID")
	s ArcDesc=""
	s IsARCIMAbbrev=0
	i Type="A" d
	.d GetArcDesc(ID)
	i Type="O" d
	.s ArcID=$P(^OEORD(+ID,"I",$P(ID,"||",2),1),"^",2)
	.d GetArcDesc(ArcID)
	i Type="P" d
	.s:LocID="" LocID = $P(^DHCPEPreIADM(+ID),"^",26)
	.s ArcID=$P(^DHCPEPreIADM(+ID,"ORDITEM",$P(ID,"||",2)),"^",1)
	.d GetArcDesc(ArcID)
	i Type="C" d
	.s PreItemID=$P(^DHCPECRMO(ID),"^",2)
	.s ArcID=$P(^DHCPEPreIADM(+PreItemID,"ORDITEM",$P(PreItemID,"||",2)),"^",1)
	.d GetArcDesc(ArcID)
	d TranslateGetArcDesc
	q ArcDesc
GetArcDesc(ArcID)
    q:ArcID=""
	//s AbridgeFlag=$G(^DHCPESetting("DHCPE","ItemAbridgeFlag"))
	s AbridgeFlag=$G(^DHCPESetting("DHCPE","ItemAbridgeFlag",LocID))
	i AbridgeFlag="Y" d
	.s ArcDesc=$P(^ARCIM(+ArcID,1,1),"^",3)
	.s IsARCIMAbbrev=1
	e  d
	.s ArcDesc=$P(^ARCIM(+ArcID,1,1),"^",2)
	q

TranslateGetArcDesc
	s ArcDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",ArcDesc,"ARCIMDesc","cls")
	s:IsARCIMAbbrev=1 ArcDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",ArcDesc,"ARCIMAbbrev","cls")
}

/// 得到建议对照的科室
ClassMethod GetEDloc(CurLoc As %String = "")
{
	s:CurLoc="" CurLoc=%session.Get("LOGON.CTLOCID")
	s loc=$G(^DHCPESetting("DHCPE","OPLoc",CurLoc))
	s:loc="" loc=CurLoc
	q loc
}

/// 得到拍照的ftp信息
ClassMethod GetPhotoFTP(LocID As %String = "")
{
	i LocID="" s LocID=%session.Get("LOGON.CTLOCID")
	//q $G(^DHCPESetting("DHCPE","PhotoFTP"))
	q $G(^DHCPESetting("DHCPE","PhotoFTP",LocID))
}

ClassMethod GetOneExportInfo(ID, Type, ExStr As %String = "")
{
	s User=%session.Get("LOGON.USERID")
	s RetID=$O(^TempDHCPEExportCommon(User,Type,ID))
	;q:RetID="" ""
	i ID="" d
	.s RetInfo=..GetExportTitle(Type,ExStr)
	e  d
	.s RetInfo=$G(^TempDHCPEExportCommon(User,Type,ID))
	s RetInfo=$replace(RetInfo,$c(10),"") //替换空格
	
	q RetID_"^"_RetInfo
}

ClassMethod GetExportTitle(Type, ExStr As %String = "")
{
	q:Type="DHCPERecPaper" "登记号^姓名^性别^出生日期^单位^到达日期^发生日期"
	q:Type="DHCPEHighRisk" "姓名^性别^年龄^登记号^团体/VIP等级^部门^电话^高危结果^高危描述/建议^状态"
	q:Type="DHCPEIllnessStatistic" "登记号^姓名^性别^出生日期"
	q:Type="DHCPEInvList" "发票号^姓名^登记号^金额^状态^收费员^收费日期^结帐标志^结帐日期^性别^年龄^作废日期^退费申请人^套餐"
	q:Type="DHCPEQueryPos" "登记号^姓名^性别^年龄^项目^结果"
	q:(Type="DHCPESpecDetail")&&(ExStr="Detail") "采集人^姓名^ID号^标本号^项目名称"
	q:(Type="DHCPESpecDetail")&&(ExStr="Item") "采集人^项目名称^数量^容器^检验状态"
	q:(Type="DHCPESpecDetail") "采集人^数量"
	q:(Type="DHCPESpecial") "项目^登记号^姓名^复查^VIP等级^单位^电话^到达日期^检查日期^报告日期"
}

/*Query内容
s User=%session.Get("LOGON.USERID")
s ExportName="DHCPERecPaper"
k s ^TempDHCPEExportCommon(UserID,ExportName)
在
Set ^CacheTemp(repid,ind)=Data
的后面添加
s ^TempDHCPEExportCommon(UserID,ExportName,ind)=TRegNo_"^"_TName_"^"_TSex_"^"_TDob_"^"_TGroup_"^"_TArrivedDate_"^"_TDate
*/

/*组件内容
GetExportInfo
s val=##Class(%CSP.Page).Encrypt($lb("web.DHCPE.DHCPECommon.GetOneExportInfo"))
*/

/*js内容
function BExport_click()
{
	var obj;
	obj=document.getElementById("prnpath");
	if (obj&& ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEExportCommon.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	var ExportName="DHCPERecPaper"
	var obj=document.getElementById("GetExportInfo");
	if (obj) {var encmeth=obj.value} else{var encmeth=""}
	xlApp= new ActiveXObject("Excel.Application"); //固定
	xlBook= xlApp.Workbooks.Add(Templatefilepath); //固定
	xlsheet= xlBook.WorkSheets("Sheet1"); //Excel下标的名称
	var Info=cspRunServerMethod(encmeth,"",ExportName);
	
	var Row=1;
	while (Info!="")
	{
		var DataArr=Info.split("^");
		var DataLength=DataArr.length;
		for (i=1;i<DataLength;i++)
		{
			xlsheet.cells(Row,i).value=DataArr[i];
		}
		var Sort=DataArr[0];
		if (Sort=="") break;
		Row=Row+1;
		Info=cspRunServerMethod(encmeth,Sort,ExportName);
	}
	xlsheet.SaveAs("d:\\"+ExportName+".xls");
		
	xlApp.Visible= true;
	xlApp.UserControl= true;
}
*/

// w ##class(web.DHCPE.DHCPECommon).GetImageFromCode("")

ClassMethod GetImageFromCode(Code As %Library.String) As %Library.String
{
	q:Code="" ""
	i Code'=""  q "websys/edit.gif"
}

// w ##class(web.DHCPE.DHCPECommon).GetCardNoLength(1)

ClassMethod GetCardNoLength(CardTypeDR)
{
	s length=0
	s length=$p($G(^DHCCARDTYPEDef(CardTypeDR)),"^",17)
	q length
}

// w ##class(web.DHCPE.DHCPECommon).CardNoMask(8011,10)

ClassMethod CardNoMaskNew(CardNo, CardNoLength)
{
	q:CardNo="" ""
	s CardNo=$ZCVT(CardNo,"U")
	s ZeroStr=$E("00000000000000000000000000",1,CardNoLength)
	s CardNoNew=$E(ZeroStr,1,CardNoLength-$l(CardNo))_CardNo
	q CardNoNew
}

// w ##class(web.DHCPE.DHCPECommon).CardNoMask(1)

ClassMethod CardNoMask(CardNo)
{
    q:CardNo="" ""
    s CardTypeDR=""
    s CardTypeDR=$G(^DHCPESetting("DHCPE","CardType")) //卡类型ID DHC_CardTypeDef
	s CardLength=+$P(^DHCCARDTYPEDef(CardTypeDR),"^",17)
	q:CardLength=0 CardNo
	i CardLength'=0 d
	.s CardNo=$E("00000000000000000000",1,CardLength-$l(CardNo))_CardNo
	q CardNo
}

ClassMethod GetSYSDatefomat()
{
     s dateformat=$lg(^websys.ConfigurationD(1),10)
     q dateformat
}

ClassMethod GetHospitalName(HOSPID)
{
	q:HOSPID="" ""
	s HospDesc=$p($g(^CT("HOSP",HOSPID)),"^",2)
	Q HospDesc
}

// w ##class(web.DHCPE.DHCPECommon).GetRegNoLength()

ClassMethod GetRegNoLength(CTLocID As %String = "")
{
	i CTLocID="" s CTLocID=%session.Get("LOGON.CTLOCID")
	s length=0
	//s length=+$G(^DHCPESetting("DHCPE","RegNoLength"))
	s length=+$G(^DHCPESetting("DHCPE","RegNoLength",CTLocID))
	q length
}

// w ##class(web.DHCPE.DHCPECommon).IsLetter()

// function:判断输入的字符串是不是字母

ClassMethod IsLetter(Info As %String) As %String
{
	s flag=0
	i Info="" q flag
	i Info'=""  s Info=$ZCVT(Info,"U") 
	f i=1:1:$L(Info) d
	.s letter=$e(Info,i)
	.i "ABCDEFGHIGKLMNOPQRSTUVWXYZ"[letter d
	..s flag=1 q
	.q:flag=1
	q flag
}

/// function:判断体检人员是否个人、团体？提供pacs组
/// 入参：就诊ID
/// 返回值：I 个人  G 团体
/// w ##class(web.DHCPE.DHCPECommon).IsIGMember()
ClassMethod IsIGMember(PAADM)
{
	S IADMRowId=$O(^DHCPEIADM(0,"PAADM",PAADM,0)) 
	q:IADMRowId="" "err^就诊信息有误"
	S GADM=$P($g(^DHCPEIADM(IADMRowId)),"^",2)
	i GADM'="" s Type="G"
	E  s Type="I"
	Q Type
}

/// w ##class(web.DHCPE.DHCPECommon).GetInvnoNotZM("abc0012")
/// function：获取除去字母发票开头的发票号
ClassMethod GetInvnoNotZM(Invno)
{
	Q:Invno="" ""
	s zmLength=##class(web.DHCPE.DHCPECommon).GetStrNum(Invno)
	q $e(Invno,zmLength,$l(Invno))
}

/// w ##class(web.DHCPE.DHCPECommon).GetStrNum("abc0012")
/// function：获取发票开头的的长度
ClassMethod GetStrNum(tinfo As %String) As %String
{
	s flag=0,Zimu=""
	i tinfo="" q flag
	f i=1:1:$L(tinfo) d
	.s Zimu=$e(tinfo,i)
	.i (((Zimu>0)&&(Zimu<9))||(Zimu=0)||(Zimu=9)) d
	..s flag=i s i=$L(tinfo) q
	q flag
}

/// Creator: xueying
/// CreateDate: 2018-03-14
/// Descript: 打印病理条码是否调用新产组申请
/// w ##class(web.DHCPE.DHCPECommon).GetPrintPISTiaoma()
ClassMethod GetPrintPISTiaoma()
{
	q:'$d(^DHCPESetting("DHCPE","PrintPISTiaomaNew")) "0"
	s flag=0
	i $g(^DHCPESetting("DHCPE","PrintPISTiaomaNew"))="Y" d
	.s flag=1
	q flag
}

/// Creator: xueying
/// CreateDate: 2018-03-15
/// Descript: 病理发送申请使用前台?后台
/// w ##class(web.DHCPE.DHCPECommon).GetSendPisFBWay()
ClassMethod GetSendPisFBWay(LocID As %String = "") As %String
{
	i LocID="" s LocID=%session.Get("LOGON.CTLOCID")
	q:'$d(^DHCPESetting("DHCPE","SendPisFBWay",LocID)) ""
	q $g(^DHCPESetting("DHCPE","SendPisFBWay",LocID))
}

/// Creator: xueying
/// CreateDate: 2018-03-13
/// Descript: 根据医嘱ID获取医嘱项ID
/// w ##class(web.DHCPE.DHCPECommon).GetArcItmByOrdItem()
ClassMethod GetArcItmByOrdItem(OrdItem)
{
 
  	q:OrdItem="" ""
 	s ItmMast=$p($g(^OEORD($p(OrdItem,"||",1),"I",$p(OrdItem,"||",2),1)),"^",2)
	 q ItmMast
}

/// Creator: xueying
/// CreateDate: 2018-03-13
/// Descript: 病理后台发送申请是否调用新产组申请
/// w ##class(web.DHCPE.DHCPECommon).GetSendPisInterface()
ClassMethod GetSendPisInterface(LocID As %String = "") As %String
{
	i LocID="" s LocID=%session.Get("LOGON.CTLOCID")
	/*
	q:'$d(^DHCPESetting("DHCPE","SendPisInterface")) "0"
	s flag=0
	i $g(^DHCPESetting("DHCPE","SendPisInterface"))="Y" d
	.s flag=1
	q flag
	*/
	q:'$d(^DHCPESetting("DHCPE","SendPisInterface",LocID)) "0"
	s flag=0
	i $g(^DHCPESetting("DHCPE","SendPisInterface",LocID))="Y" d
	.s flag=1
	q flag
}

/// 获取新/旧版报告权限
/// d ##class(web.DHCPE.DHCPECommon).NewVerReport()
ClassMethod GetNewVerReport(LocID)
{
	
	i LocID="" s LocID=%session.Get("LOGON.CTLOCID")
	s flag="N"
	q:'$d(^DHCPESetting("DHCPE","NewVerReport",LocID)) "N"
	i $g(^DHCPESetting("DHCPE","NewVerReport",LocID))="Y" S flag="Y"
	q flag
}

/// Creator: xueying
/// CreateDate: 2018-12-07
/// Descript: 根据医嘱ID取病理申请单单ID
/// w ##class(web.DHCPE.DHCPECommon).GetPISAPPIDByOeordID()
ClassMethod GetPISAPPIDByOeordID(Oeori)
{
   
    q:Oeori="" ""
    S ID=""
    q:'$d(^DHCAPPPM(0,"OrdItem",Oeori)) ""
	s ID=$o(^DHCAPPPM(0,"OrdItem",Oeori,"")) /// 申请单ID
	q $g(ID)
}

/// 获取默认视同收费方式
/// d ##class(web.DHCPE.DHCPECommon).GetCashierSystem()
ClassMethod GetCashierSystem(LocID)
{
	i LocID="" s LocID=%session.Get("LOGON.CTLOCID")
	q:'$d(^DHCPESetting("DHCPE","CashierSystem",LocID)) "N"
	q $g(^DHCPESetting("DHCPE","CashierSystem",LocID))
}

/// 获取病人类型
/// d ##class(web.DHCPE.DHCPECommon).GetPatType()
ClassMethod GetPatType(RegNo As %String = "", CTLocID As %String = "")
{
	//i RegNo="" s PatType=$p($g(^DHCPESetting("DHCPE","DefPatientType")),"^",1)
	i RegNo="" s PatType=$p($g(^DHCPESetting("DHCPE","DefPatientType",CTLocID)),"^",1)
	i RegNo'="" d
	.s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo,CTLocID)
	.S RegNo=$$ALPHAUP^SSUTIL4(RegNo)
	.s PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
	.s PatType=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",10)
	q PatType
}

/// 获取性别描述
/// d ##class(web.DHCPE.DHCPECommon).GetSexDescByID()
ClassMethod GetSexDescByID(SexID As %String = "")
{
	q:SexID="" ""
	q $p($g(^CT("SEX",SexID)),"^",2)
}

/// 获取证件类型描述
/// d ##class(web.DHCPE.DHCPECommon).GetICardTypeDescByID()
ClassMethod GetICardTypeDescByID(ID As %String = "")
{
	q:ID="" ""
	q $p($g(^PAC("CARD",ID)),"^",2)
}

/// 判断医嘱是否谢绝检查
/// d ##class(web.DHCPE.DHCPECommon).IsRefuseCheck()
ClassMethod IsRefuseCheck(OEORDItemID As %String = "")
{
    s flag=0
	q:OEORDItemID="" flag
	i $d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORDItemID)) s flag=1
	q flag
}

/// 判断医嘱是否是用户
/// d ##class(web.DHCPE.DHCPECommon).IsUser()
ClassMethod IsUser(UserID As %String = "")
{
    s flag=0
	q:UserID="" flag
	i $d(^SSU("SSUSR",UserID)) s flag=1
	q flag
}

/// 判断医嘱是否是科室
/// d ##class(web.DHCPE.DHCPECommon).IsCTLoc()
ClassMethod IsCTLoc(LocID As %String = "")
{
    s flag=0
	q:LocID="" flag
	i $d(^CTLOC(LocID)) s flag=1
	q flag
}

/// 判断医嘱是否是套餐
/// d ##class(web.DHCPE.DHCPECommon).IsSets()
ClassMethod IsSets(SetsID As %String = "")
{
    s flag=0
	q:SetsID="" flag
	i $d(^ARCOS(SetsID)) s flag=1
	q flag
}

/// 判断医嘱是否是医嘱项
/// w ##class(web.DHCPE.DHCPECommon).IsArcItem("1||2")
ClassMethod IsArcItem(ItemID As %String = "")
{
    s flag=0
	q:ItemID="" flag
	q:'$d(^ARCIM($p(ItemID,"||",1),$p(ItemID,"||",2))) flag
	i $d(^ARCIM($p(ItemID,"||",1),$p(ItemID,"||",2))) s flag=1
	q flag
}

/// 判断是否是目标疾病
/// w ##class(web.DHCPE.DHCPECommon).IsIllness("1")
ClassMethod IsIllness(IllnessID As %String = "")
{
    s flag=0
	q:IllnessID="" flag
	q:'$d(^User.DHCPEOMEIllnessD(IllnessID)) flag
	i $d(^User.DHCPEOMEIllnessD(IllnessID)) s flag=1
	q flag
}

/// 根据预约ID获取就诊ID
/// d ##class(web.DHCPE.DHCPECommon).GetPaadmByPIADM(69)
ClassMethod GetPaadmByPIADM(PIADM)
{
	s IADM=$o(^DHCPEIADM(0,"CRMADM",PIADM,0))
	q:IADM="" ""
	s PAADM=$p($g(^DHCPEIADM(IADM)),"^",1)
	q PAADM
}

/// 根据就诊ID获取预约ID
/// d ##class(web.DHCPE.DHCPECommon).GetPIADMByPaadm()
ClassMethod GetPIADMByPaadm(PAADM)
{
	S IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	q:IADM="" ""
	s PIADM=$p($g(^DHCPEIADM(IADM)),"^",4)
	q PIADM
}

/// 判断医嘱是否属于检查检验站点
/// w ##class(web.DHCPE.DHCPECommon).IsLisRisStation("11548||1")
ClassMethod IsLisRisStation(ARICM, LocID As %String = "")
{
    q:ARICM="" 0
    s StationID=$O(^DHCPEST(0,"STORD_ARCIM",ARICM,0))
	q:StationID="" 0
	s flag=0
	//s RisStation="^"_$g(^DHCPESetting("DHCPE","StationId_Ris"))_"^"
	//s LabStation="^"_$g(^DHCPESetting("DHCPE","StationId_Lab"))_"^"
	s RisStation="^"_$g(^DHCPESetting("DHCPE","StationId_Ris",LocID))_"^"
	s LabStation="^"_$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))_"^"
	

	s StationID="^"_StationID_"^"
	if ((RisStation[StationID)||(LabStation[StationID)) d
	.s flag=1
	else  d
	.s flag=0
	q flag
}

/// Description: 根据院区获取年龄
/// Input:       PAPMIRowId（pa_patmas的ID），HospID（医院ID），LocID（科室ID）
/// Dubug:  w ##class(web.DHCPE.DHCPECommon).GetPapmiAge()
ClassMethod GetPapmiAge(PAPMIRowId As %Library.String = "", HospID As %Library.String = "", LocID As %Library.String = "")
{
	s Age=""
	q:PAPMIRowId="" ""
	i (LocID=""){
		s:$D(%session) LocID = %session.Get("LOGON.CTLOCID")
	}
	s MHospital=$g(^DHCPESetting("DHCPE","MHospital",LocID))
	
	if MHospital="Y" d
	.s Age=##class(web.DHCBillInterface).GetPapmiAge(PAPMIRowId,"",HospID)
	else  d
	.s Age=##class(web.DHCBillInterface).GetPapmiAge(PAPMIRowId)
	q Age
}

/// Creator： xy
/// CreatDate： 20220415
/// Description: 自动根据检验版本去掉检验相关global前面的空格 
/// Dubug: d ##class(web.DHCPE.DHCPECommon).LisIndexData()
ClassMethod LisIndexData(str)
{
	s $ZT="LisIndexDataErr"
	q ##Class(LIS.Util.Common).IndexData(str) //检验自动处理检验相关global前面的空格(因为带空格的索引严重影响sql查询效率)
LisIndexDataErr
	q " "_str //如果没有方法##Class(LIS.Util.Common).IndexData()，返回空格+str
}

/// Description: 获取支付方式code
/// Input:       PayModeID（支付方式ID）
/// Dubug:  w ##class(web.DHCPE.DHCPECommon).GetPayModeCode()
ClassMethod GetPayModeCode(PayModeID As %Library.String = "")
{
	s PayModeCode=""
	q:PayModeID="" ""
	i PayModeID'="" s PayModeCode=$p($g(^CT("CTPM",PayModeID)),"^",1)
	q PayModeCode
}

}
