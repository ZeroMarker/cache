Class DHCDoc.OPDoc.TreatPrint Extends DHCDoc.Util.RegisteredObject
{

// d ##class(DHCDoc.OPDoc.TreatPrint).PrintOrder()

ClassMethod PrintOrder()
{
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCDocQryOEOrder"
	set rs.QueryName="GetOrdByAdm"
	set sc=rs.Execute("230")
	s dataHeadConfig="ArcimDesc:医嘱名称,OrdBilled:计费状态,OrdStatus:状态,DoseQty:单次剂量,DoseUnit:单位,PHFreq:频次,Instr:用法,Dura:疗程,PrescNo:处方号,ArcPrice:单价/元,OrderPackQty:数量,PackUOMDesc:单位,ReLoc:接收科室,Doctor:开医嘱人,OrderSum:金额,OrdDepProcNotes:备注,AdmReason:费别"
	s indexTitleData("UserAdd")=""
	s indexTitleData("PrescNo")=""
	w "{"
	w """id"":""opdocPrintRecadmOrder"","
	d ..FormatDataTable(.rs,dataHeadConfig,.conf,.indexTitleData,0)
	w ",""title"":""处方号："_indexTitleData("PrescNo")_":"_indexTitleData("UserAdd")_""""
	w "}"
	d rs.Close()
	q ""
}

ClassMethod FormatDataTable(ByRef rs As %ResultSet, dataHeadConfig As %String, ByRef needColMap, ByRef indexTitleData, isTruncated = 0)
{
	w ..FormatDataTableCols(.rs,dataHeadConfig,.needColMap,isTruncated)
	w ",""rows"":["
	s c=..FormatJson(.rs,.needColMap,.indexTitleData)
	w "],""total"":"_ c
}

// w ##class(DHCDoc.OPDoc.TreatPrint).FormatDataTable("","")

ClassMethod FormatDataTableCols(ByRef rs As %ResultSet, dataHeadConfig As %String, ByRef needColMap, isTruncated = 0) As %String
{
	s status=""
	k dataHeadConfigMap,dataHeadConfigMap2,allPro,needColMap
	
	f i=1:1:rs.GetColumnCount() {
		s allPro(rs.GetColumnName(i))=i
		i 'isTruncated s needColMap(i)=rs.GetColumnName(i)
	}
	f i=1:1:$L(dataHeadConfig,","){
		s m=$P(dataHeadConfig,",",i)
		s d=$P(m,":",1)
		s h=$P(m,":",2)
		i '((h="")||(h="null")) {
			s dataHeadConfigMap(h)=d
			s dataHeadConfigMap2(i)=h
		}
		s:isTruncated needColMap(allPro(d))=d
		if ('$d(allPro(d))){
			s status="Config of "_h_"->"_d_" is wrong, no "_d_" column in this query!"
			q
		}
	}
	q:status'="" status
	s json= """head"":["
	s count=0
	s h="" f  {
		s h=$o(dataHeadConfigMap2(h))
		q:h=""
		s:count>0 json=json_","
		s json=json_ """"_dataHeadConfigMap2(h)_""""
		s count=count+1
	}
	s json=json_ "],""rowCols"":["
	s count=0
	s h="" f {
		s h=$o(dataHeadConfigMap2(h)) 
		q:h=""
		s:count>0 json=json_","
		s json=json_ "{""data"":"_""""_dataHeadConfigMap(dataHeadConfigMap2(h))_"""}"
		s count=count+1
	}
	s json=json_ "]"
	q json
}

// w ##class(DHCDoc.OPDoc.TreatPrint).FormatDataTable("","")

ClassMethod FormatDataTableCols2(dataHeadConfig As %String, ByRef colDefine As DHCDoc.Util.MapIndex, transCSPName = "opdoc.treatprint.csp") As %String
{
	k headMap,headMap2,hiddenMap
	f i=1:1:$L(dataHeadConfig,","){
		s m=$P(dataHeadConfig,",",i)
		s d=$P(m,":",1)
		s h=$P(m,":",2)
		continue:( (h="") || (h="null") || ( '$d(colDefine.map(d)) ) )
		s headMap(d)=##class(websys.Translation).Get(transCSPName,h)
		s headMap2(i)=d
		s isHidden="N"
		if (h=d){
			s isHidden="Y"
		}
		s hiddenMap(i)=isHidden
	}
	
	s json= """head"":["
	s i="" f  {
		s i=$o(headMap2(i))
		q:i=""
		s:i>1 json=json_","
		s json=json_ """"_headMap(headMap2(i))_""""
	}
	s json=json_ "],""rowCols"":["
	s count=0
	
	s i="" f {
		s i=$o(headMap2(i)) 
		q:i=""
		s:i>1 json=json_","
		s json=json_ "{""data"":"_""""_headMap2(i)_"""}"
	}
	
	s json=json_ "],""HiddenCols"":["
	s i="" f {
		s i=$o(hiddenMap(i)) 
		q:i=""
		s:i>1 json=json_","
		s json=json_ "{"""_headMap2(i)_""":"_""""_hiddenMap(i)_"""}"
	}
	
	s json=json_ "]"
	q json
}

ClassMethod FormatJson(rs As %ResultSet, ByRef needColMap = "", ByRef indexTitleData) As %Integer
{
	k allPro,proType
	s len=rs.GetColumnCount()
	f i=1:1:len {
		s allPro(i)=""""_rs.GetColumnName(i)_""":"
		s proType(i)=rs.GetColumnType(i)
	}
	s count=0
	While rs.Next(.sc) {
		if $$$ISERR(sc) Quit
		Write:count>0 (",")
		s count=count+1
		Write ( "{")
		s countPro=0
		s i="" f  {
			s i=$o(needColMap(i))
			q:i=""
			s colName=needColMap(i)
			Write:countPro>0 (",")
			s countPro=countPro+1
			Write ( allPro(i))
			s v=rs.GetData(i)
			s:(($d(indexTitleData(colName)))&&(v'="")) indexTitleData(colName)=v
			s t=proType(i)
			if ( (t=3) ||(t=5)||(t=14)||(t=15)||(t=18) ){
				s:v="" v=0
				Write (v)
			}elseif (t=16){
				i (v=1) {
					s v="true" 
				}else {
					 s v="false"
				}
				Write (v) 
			}else{
				Write ("""")
				s v=..ReplaceStr(v,"'","\'")
				s v=..ReplaceStr(v,"""","\""")
 				s v=..ReplaceStr(v,$c(13),"\n")
			 	s v=..ReplaceStr(v,$c(10),"\r")
			    s v=..ReplaceStr(v,$c(2),"<$C2>")
			 	s v=..ReplaceStr(v,$c(5),"<$C5>")
			 	s v=..ReplaceStr(v,$c(7),"<$C7>")
				Write (v)
				Write ("""")
			}
		}
		Write ( "}")
	}
	d rs.Close()
	q count
}

/*
colMap:
(index,ColName)=ColType
*/
ClassMethod BuildJsonForGlobalList(ByRef colMap)
{
	k jsonPro,proType
	s i="" f i=$o(colMap(i)) {
		q:i=""
		s name=$o(colMap(i,""))
		s jsonPro(i)=""""_name_""":"
		s proType(i)=colMap(i,name)
	}
}

// w ##class(DHCDoc.OPDoc.TreatPrint).ReplaceStr("1234""5Abcd","""","\""")

ClassMethod ReplaceStr(str, src = "", dem = "") As %String
{
	q:((src="")||(str="")) str
	s strLen=$l(str),srcLen=$l(src),demLen=$l(dem)
	s flag=0
	f i=1:1:strLen {
		s flag=1
		f j=1:1:srcLen {
			if ($e(str,i+j-1)=$e(src,j)){
			}else{
				s flag=0
				q
			}
		}
		if (flag=1){
			s $e(str,i,i+srcLen-1)=dem
			s i=i+demLen-1
		}
	}
	q str
}

/// Creator:guorongyong
/// CreateDate:2014-08-11
/// Desc:是否毒麻处方(1 是毒麻处方,0 不是毒麻处方)
/// input: PrescNo 处方号
/// output: 1 是毒麻处方,0 不是毒麻处方
/// w ##class(DHCDoc.OPDoc.TreatPrint).IsDMPresc("")
ClassMethod IsDMPresc(PrescNo As %String) As %String
{
	s ret=0
	Q:PrescNo="" ret
	s ord=0
	for {
		s ord=$O(^OEORD(0,"PrescNo",PrescNo,ord)) q:ord=""
		s chl=0
		for {
			s chl=$O(^OEORD(0,"PrescNo",PrescNo,ord,chl)) q:chl=""
			s ArcimId=$p(^OEORD(ord,"I",chl,1),"^",2)
			continue:ArcimId=""
			s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescTypeByItem(ArcimId)
			i (PHPrescType=8)||(PHPrescType=6) s ret=1 quit
		}
		Q:ret=1
	}
	
	Q ret
}

// d ##class(DHCDoc.OPDoc.TreatPrint).QueryOEForPrintJson(230)

// 打印数据展示

ClassMethod QueryOEForPrintJson(episodeID As %String, menuItems As %String = "CFZ,CFD,SYDO,ZSDO,JYDO,ZLDO,JCDMZ,BLDMZ", StDate As %String, EndDate As %String, OrdComStatus As %String = "")
{
	Set langid=..%LanguageID()
	d ..QueryOEForPrintData(episodeID,.colDefine,menuItems,"Y",StDate,EndDate,OrdComStatus)
	s RecLocIndex=colDefine.index("ReLoc")
	s DoctorIndex=colDefine.index("Doctor")
	s menuItemsIndex=colDefine.index("MenueItems")
	s printHisCountIndex=colDefine.index("printHisCount")
	s IsDMPrescIndex=colDefine.index("IsDMPresc")
	s len=colDefine.count()
	s list=""
	s tIndx="QueryOEForPrint_"_$j
	w "["
	s tableCount=0
	s orderType2="" f   s orderType2=$o(^CacheTemp(tIndx,orderType2)) q:orderType2=""  d
	.s orderType=$e(orderType2,3,$l(orderType2))
	.i orderType="R" d
	..s prescNo="" f  s prescNo=$o(^CacheTemp(tIndx,orderType2,prescNo)) q:prescNo=""  d
	...k MenuOEMap
	...s col="PrintFlag:选择,SeqNo:序号,OrdBilled:计费状态/撤销,OrdCreateDate:下医嘱日期,OrdCreateTime:医嘱时间,ArcimDesc:医嘱名称,DoseQty:单次剂量,PHFreq:频次,Instr:用法,Dura:疗程,OrderPackQty:数量,OrdDepProcNotes:备注,AdmReason:费别,OrdStatus:状态,OEItemID:医嘱ID" //,ArcPrice:单价/元,ReLoc:接收科室,Doctor:开医嘱人,OrderSum:金额,
	...w:tableCount>0 ","
	...s tableCount=tableCount+1
	...w "{"
	...w ..FormatDataTableCols2(col,.colDefine)
	...w ",""id"":"""_prescNo_"_Table"","
	...w """rows"":["
	...s recLoc="",doc="",prelist=""
	...s IsCMPresType = ##Class(web.DHCDocPrescript).IsPrescType(prescNo) //是否是草药处方
	...s rowCount=0,PrescSum=0,CMprescSum=0
	...s isDmFlag=0
	...s IsNeedLinkDiagPresc=##class(web.DHCDocDiagLinkToPrse).IsPrescNoNeedLinkDiag(prescNo)
	...s MainSeqNo=1
	...s Count="" f  s Count=$o(^CacheTemp(tIndx,orderType2,prescNo,Count)) q:Count=""  d
	....w:rowCount>0 ","
	....s rowCount=rowCount+1
	....s list=^CacheTemp(tIndx,orderType2,prescNo,Count)
	....s OEItemID=$list(list,14)
	....s recLoc=$lg(list,RecLocIndex)
	....s doc=$lg(list,DoctorIndex)
	....s menusStr=$lg(list,menuItemsIndex)
	....s menusStrLen=$l(menusStr,",")
	....s IsDMPresc=$lg(list,IsDMPrescIndex)
	....s:IsDMPresc=1 isDmFlag=1
	....s AdmReason=$list(list,57) //费别
	....s AdmReason=##class(User.PACAdmReason).GetTranByDesc("READesc",AdmReason,langid)
	....s OrdPrice=$list(list,32) //单价
	....s OrderSum=$list(list,47) //单条总金额
	....;s OrderSum=$J(OrderSum,6,2)
	....s OrderSum=$fn(OrderSum,"",2)
	....s PrescSum=PrescSum+OrderSum
	....i IsCMPresType="1" d //草药处方
	.....s DoseQty=$list(list,6)
	.....s Duration=$list(list,13) 
	.....s Instruc=$list(list,10)
	.....s CMprescSum=CMprescSum+$fn((OrdPrice*DoseQty*(+Duration)),"",2) //$fn( ;+$J((OrdPrice*DoseQty),6,2)
	....s SeqNo=$list(list,56)
	....s MasterSeqNo=$list(list,53)
    ....i MasterSeqNo'="",prelist'="" d
	.....s PreSeqNo=$list(prelist,56)
	.....i PreSeqNo["." s $list(list,56)=$p(PreSeqNo,".",1)_"."_($p(PreSeqNo,".",2)+1)
	.....e  s $list(list,56)=PreSeqNo_".1"  
	....e  d
	.....s $list(list,56)=MainSeqNo,MainSeqNo=MainSeqNo+1
	....s prelist=list
	
	
	....f i=1:1:menusStrLen d
	.....s a=$p(menusStr,",",i)
	.....q:a=""
	.....i $d(MenuOEMap(a)) s MenuOEMap(a)=MenuOEMap(a)_","_OEItemID 
	.....else  s MenuOEMap(a)=OEItemID
	....;d BuildJsonForList(colDefine,list)
	....d ##class(DHCDoc.Util.FormatData).JsonList(colDefine,list)
	...w "]"
	...i IsCMPresType="1" d //草药处方
	....s queid=$o(^PAQUE1(0,"PrescNo",prescNo,""))
	....s orderqty=$p(^PAQUE1(queid,"DHC"),"^",13) //一次用量
	....w ",""title"":"""_##class(websys.Translation).Get("opdoc.treatprint.csp","处方-处方号：")_prescNo_"-"_recLoc_"-"_doc_##class(websys.Translation).Get("opdoc.treatprint.csp","-共")_Duration
	....w ##class(websys.Translation).Get("opdoc.treatprint.csp","用法:")_Instruc_##class(websys.Translation).Get("opdoc.treatprint.csp"," 一次用量:")_orderqty
	....w "【"_AdmReason_"】"_##class(websys.Translation).Get("opdoc.treatprint.csp","单付金额:")_$fn(CMprescSum/Duration,"",2)_##class(websys.Translation).Get("opdoc.treatprint.csp","元 合计金额:")_$fn(CMprescSum,"",2)_##class(websys.Translation).Get("opdoc.treatprint.csp","元")_""""
	...e  d
	....w ",""title"":"""_##class(websys.Translation).Get("opdoc.treatprint.csp","处方-处方号：")_prescNo_"-"_recLoc_"-"_doc_"- 【"_AdmReason_##class(websys.Translation).Get("opdoc.treatprint.csp","】金额:")_$fn(PrescSum,"",2)_##class(websys.Translation).Get("opdoc.treatprint.csp","元")_""""
	
	...w ",""config"":{""selectConsistent"":true,""checkHeaders"":{""0"":true},"
	...if isDmFlag=1  d
	....w """IsDMPresc"":true,"
	...if IsNeedLinkDiagPresc=1 d
	....w """IsNeedLinkDiagPresc"":true,"
	...d BuildMenuOEConfig
	...w "}"
	...if isDmFlag d
	....i IsCMPresType w ",""titleClass"":""danger-head cmpresc-head"""
	....e  w ",""titleClass"":""danger-head"""
	...else  if IsCMPresType d
	....w ",""titleClass"":""normal-head cmpresc-head"""
	...else  d
	....w ",""titleClass"":""normal-head"""
	...w "}"
	.else  if orderType="L" d
	..s col="PrintFlag:选择,SeqNo:序号,OrdBilled:计费状态/撤销,OrdCreateDate:下医嘱日期,OrdCreateTime:医嘱时间,ArcimDesc:医嘱名称,OrderPackQty:数量,LabNo:检验号,OrdLabSpec:标本,AdmReason:费别,ReportDate:报告日期,ReportTime报告时间,PAADMDate:就诊日期,OrdDepProcNotes:备注,OrdStatus:状态,ReportLinkInfo:检验报告"
	..s title=##class(websys.Translation).Get("opdoc.treatprint.csp","检验")
	..d BuildNotR
	.else  if orderType="S" d
	..s col="PrintFlag:选择,SeqNo:序号,OrdBilled:计费状态/撤销,OrdCreateDate:下医嘱日期,OrdCreateTime:医嘱时间,ArcimDesc:医嘱名称,OrderPackQty:数量,AdmReason:费别,ReportDate:报告日期,ReportTime报告时间,PAADMDate:就诊日期,OrdDepProcNotes:备注,OrdStatus:状态,ReportLinkInfo:检查报告"
	..s title=##class(websys.Translation).Get("opdoc.treatprint.csp","检查")
	..d BuildNotR
	.else  d
	..s col="PrintFlag:选择,SeqNo:序号,OrdBilled:计费状态/撤销,OrdCreateDate:下医嘱日期,OrdCreateTime:医嘱时间,ArcimDesc:医嘱名称,OrderPackQty:数量,AdmReason:费别,OrdDepProcNotes:备注,OrdStatus:状态" //,ReLoc:接收科室,Doctor:开医嘱人,OrderSum:金额
	..s title=##class(websys.Translation).Get("opdoc.treatprint.csp","其他")
	..d BuildNotR
	w "]"
	q ""
BuildMenuOEConfig
    s printHisCount=$lg(list,printHisCountIndex)
	w """menuOEConfig"":{"
	s mi=0
    s menu="" f  s menu=$o(MenuOEMap(menu)) q:menu=""  d
    .w:mi>0 ","
    .s mi=mi+1
    .w """"_menu_""":{"
    .s oeStr=MenuOEMap(menu)
    .s oei=0
    .f j=1:1:$l(oeStr,",") d
    ..w:oei>0 ","
    ..s oei=oei+1
    ..//
    ..s OEPrintCount=##class(DHCDoc.OPDoc.PrintHistory).GetPrintCount($p(oeStr,",",j),menu)
    ..w """"_$p(oeStr,",",j)_""":"_OEPrintCount_""
    .w "}"
    w "}"
    q
BuildNotR
    w:tableCount>0 ","
    s tableCount=tableCount+1
	w "{"
	w ..FormatDataTableCols2(col,.colDefine)
	w ",""id"":"""_orderType_"_Table"","
	w """rows"":["
	s rowCount=0
	k MenuOEMap
	s SeqNo=1
	s Count="" f  s Count=$o(^CacheTemp(tIndx,orderType2,Count)) q:Count=""  d
	.w:rowCount>0 ","
	.s rowCount=rowCount+1
	.s list=^CacheTemp(tIndx,orderType2,Count)
	.s OEItemID=$list(list,14)
	.s $list(list,56)=SeqNo,SeqNo=SeqNo+1
	.s menusStr=$lg(list,menuItemsIndex)
	.s menusStrLen=$l(menusStr,",")
	.f i=1:1:menusStrLen d
	..s a=$p(menusStr,",",i)
	..q:a=""
	..i $d(MenuOEMap(a)) s MenuOEMap(a)=MenuOEMap(a)_","_OEItemID 
	..else  s MenuOEMap(a)=OEItemID
	.d ##class(DHCDoc.Util.FormatData).JsonList(colDefine,list)
	w "]"
	w ",""title"":"""_title_""""
	w ",""config"":{""selectConsistent"":false,""checkHeaders"":{""0"":true},"
	d BuildMenuOEConfig
	w "}"
	w ",""titleClass"":""normal-head"""
	w "}"
    q
	k ^CacheTemp(tIndx)
}

/// appending fileds:IsDMPresc:是否毒麻,PrintFlag:是否打印,PatName:病人姓名,PatIDNo:病人身份证号,PatMasID:PA_PatMas的ID
/// ReportDate:检查日期,ReportTime检查时间,PAADMDate:就诊日期
///  base on the query of web.DHCDocQryOEOrder:GetOrdByAdm
ClassMethod QueryOEForPrintData(episodeID As %String, ByRef colDefine As DHCDoc.Util.MapIndex, menuItems As %String = "", IsMergetShowCol As %String = "N", StDate As %String = "", EndDate As %String = "", OrdComStatus As %String = "")
{
	s colDefine=##class(DHCDoc.Util.MapIndex).%New()
	s strList=$g(^DHCCLNurseExec("VarDef",0,"SYDO","PhcIn")) //输液用法  //$g(^DHCCLNurseExec("VarDef",0,"SYDO","OrCat")) //输液子类
	s ZSDStrList=$g(^DHCCLNurseExec("VarDef",0,"ZSDO","PhcIn")) //注射子类 //$g(^DHCCLNurseExec("VarDef",0,"ZSDO","OrCat")) //注射子类
	s JYDStrList=$g(^DHCCLNurseExec("VarDef",0,"JYDO","OrCat")) //检验单
	s ZLDStrList=$g(^DHCCLNurseExec("VarDef",0,"ZLDO","OrCat")) //治疗单子类
	s RegLinkOrdListStr=##class(web.DHCOPAdmReg).GetRegLinkOrdListByAdm(episodeID)
	k SYDMap,RQMIMap,ZSDMap,JYDMap,ZLDMap
	f i=1:1:$l(strList,"^"){
		s a=$p(strList,"^",i)
		s:a'="" SYDMap(a)=1
	}
	f i=1:1:$l(ZSDStrList,"^"){
		s a=$p(ZSDStrList,"^",i)
		s:a'="" ZSDMap(a)=1
	}
	f i=1:1:$l(JYDStrList,"^"){
		s a=$p(JYDStrList,"^",i)
		s:a'="" JYDMap(a)=1
	}
	f i=1:1:$l(ZLDStrList,"^"){
		s a=$p(ZLDStrList,"^",i)
		s:a'="" ZLDMap(a)=1
	}
	
	f i=1:1:$l(menuItems,","){
		s a=$p(menuItems,",",i)
		s:a'="" RQMIMap(a)=1
	}
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCDocQryOEOrder"
	set rs.QueryName="GetOrdByAdm"
	set sc=rs.Execute(episodeID,"",StDate,EndDate,"","","","","","","","",OrdComStatus)
	s len=rs.GetColumnCount()
	f i=1:1:len {
		d colDefine.add(rs.GetColumnName(i))
		s colDefine.map(rs.GetColumnName(i),"Type")=rs.GetColumnType(i)
	}
	d colDefine.add("IsDMPresc")
	s colDefine.map("IsDMPresc","Type")=10 //varchar
	d colDefine.add("PrintFlag")
	s colDefine.map("PrintFlag","Type")=16 //bool
	d colDefine.add("PatName")
	d colDefine.add("PatIDNo")
	d colDefine.add("PatMasID")
	d colDefine.add("ReportDate")
	d colDefine.add("ReportTime")
	d colDefine.add("PAADMDate")
	d colDefine.add("MenueItems")
	d colDefine.add("printHisCount")
	s colDefine.map("printHisCount","Type")=5 //INTEGER
	d colDefine.add("isCanCancelPermission")
	d colDefine.add("ReqID")
	s PAADMDate=$p(^PAADM(episodeID),"^",6)
	s tIndx="QueryOEForPrint_"_$j
	k ^CacheTemp(tIndx)
	s OESubType="",count=1
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		s printFlag=0
		s OEItemID=rs.Data("OEItemID")
		s OEID=$p(OEItemID,"||",1)
		s OEORID=$p(OEItemID,"||",2)
		s OEORIItmMastDR=$p(^OEORD(OEID,"I",OEORID,1),"^",2)
		s UserDepartId=$p($g(^OEORD(OEID,"I",OEORID,7)),"^",2) //开单科室
		;过滤非本科室开立医嘱
		continue:(UserDepartId'=%session.Get("LOGON.CTLOCID"))
		;过滤挂号相关医嘱
		continue:("^"_RegLinkOrdListStr_"^")[("^"_OEORIItmMastDR_"^")
		if OEORIItmMastDR'="" {
			//子类ID
			s ARCIMItemCatDR=$p(^ARCIM(+OEORIItmMastDR,$p(OEORIItmMastDR,"||",2),1),"^",10)
			s OESubType=ARCIMItemCatDR //$p(^ARC("IC",ARCIMItemCatDR),"^",7)
		}
		s menuItems="DZD"
		s Instr=$p($g(^OEORD(OEID,"I",OEORID,2)),"^",7) 
		s AdmID=$p(^OEORD(OEID),"^",1)
		s PAPMIID=$p(^PAADM(AdmID),"^",1)
		s PatName=$p(^PAPER(PAPMIID,"ALL"),"^",1)
		S PatIDNo=$p(^PAPER(PAPMIID,"PAT",3),"^",6)
		s PrescNo=rs.Data("PrescNo")
		s OrderType=rs.Data("OrderType")
		if (OrderType'="R")&&(OrderType'="L"){
			s IsExamItemFlag=##class(web.DHCDocOrderCommon).GetItemServiceFlag(OEORIItmMastDR)
			if (IsExamItemFlag=1) {
				s OrderType="S"
			}
	    }
		s printCount=0 //##class(DHCDoc.OPDoc.PrintHistory).GetPrintCount(OEItemID)
		s IsDMPresc=0
		s:PrescNo'="" IsDMPresc=..IsDMPresc(PrescNo)
		s RptRowIdStr=$$GetRisReportId(OEItemID)
		zn "DHC-PACS"
		s ReportInfo=##class(PACS.RISInterface).GetReportInfo($p(RptRowIdStr,"^",2))
		zn "DHC-APP"

		s ReqID=""
		if OrderType="R" {
			s menuItems=menuItems_",CFZ,CFD"
			s:$d(RQMIMap("CFZ")) printFlag=1
			s:$d(RQMIMap("CFD")) printFlag=1
			if (OESubType'=""){
				if (Instr'="")&&(..GetOrdMenuOEChkMap(OEItemID,"输液单")){ ///$d(SYDMap(Instr))
					s menuItems=menuItems_",SYDO"
					s:$d(RQMIMap("SYDO")) printFlag=1
				}
				if (Instr'="")&&(..GetOrdMenuOEChkMap(OEItemID,"注射单")){ ///$d(ZSDMap(Instr))
					s menuItems=menuItems_",ZSDO"
					s:$d(RQMIMap("ZSDO")) printFlag=1
				}
			} 
		}else{
			s TraType=##Class(web.DHCAPPInterface).GetTraCatType("^^"_OEItemID)
			if (TraType="E"){
				s menuItems=menuItems_",JCDMZ"
				s ReqID=$o(^DHCAPREP(0,"OrdItem",OEItemID,""))
			}elseif(TraType="P"){
				s ReqID=$o(^DHCAPPPM(0,"OrdItem",OEItemID,""))
				s PisStatus=$p(^DHCAPPPM(ReqID),"^",9)
				continue:PisStatus'="Y"
				s menuItems=menuItems_",BLDMZ"
			}
		}
		if (OrderType="L"){
			if (..GetOrdMenuOEChkMap(OEItemID,"检验单")){ ///$d(JYDMap(OESubType))
				s menuItems=menuItems_",JYDO"
			}
		}
		if ((..GetOrdMenuOEChkMap(OEItemID,"治疗单"))&&($p($G(^OEORD(OEID,"I",OEORID,11)),"^",39)="")){ //$d(ZLDMap(OESubType))
			s menuItems=menuItems_",ZLDO"
		}
		if printCount>0{
			s printFlag=0
		}
		s list=$lb()
		s index=0
		f index=1:1:len{
			s $list(list,index)=rs.GetData(index)
		}
		if (IsMergetShowCol="Y"){
			//单次剂量、单位合并一列显示
			s DoseQty=rs.Data("DoseQty")
			s DoseUnit=rs.Data("DoseUnit")
			;判断判断是数字打头的情况
			if +$E(DoseUnit,1)=$E(DoseUnit,1) s DoseUnit="("_DoseUnit_")"
			if (DoseUnit'="") s DoseQty=DoseQty_DoseUnit
			s $list(list,6)=DoseQty
			//数量、数量单位合并一列显示
			//OrderPackQty:数量/单位,PackUOMDesc:单位
			s OrderPackQty=rs.Data("OrderPackQty")
			s PackUOMDesc=rs.Data("PackUOMDesc")
			;判断判断是数字打头的情况
			if +$E(PackUOMDesc,1)=$E(PackUOMDesc,1) s PackUOMDesc="("_PackUOMDesc_")"
			//s OrderPackQty=OrderPackQty_PackUOMDesc
			s CheckCHNFlag=##class(web.DHCSTINTERFACE).GetStruModeFlag(OEORIItmMastDR)
			if (CheckCHNFlag="Y"){ s OrderPackQty=OrderPackQty_DoseUnit }
			else{s OrderPackQty=OrderPackQty_PackUOMDesc}
			s $list(list,29)=OrderPackQty
		}
		
		s $list(list,index+1)=IsDMPresc
		s $list(list,index+2)=printFlag
		s $list(list,index+3)=PatName
		s $list(list,index+4)=PatIDNo
		s $list(list,index+5)=PAPMIID
		s $list(list,index+6)=$p(ReportInfo,"^",21)
		s $list(list,index+7)=$p(ReportInfo,"^",20)
		s $list(list,index+8)=PAADMDate
		s $list(list,index+9)=menuItems
		s $list(list,index+10)=printCount
		s $list(list,index+11)=##class(web.UDHCStopOrderLook).isCanCancel(OEItemID)
		s $list(list,index+12)=ReqID
		if OrderType="R"{
			;处方号未生成的不展示
			if (PrescNo=""){s PrescNo="处方号未生成"}
			s ^CacheTemp(tIndx,"01"_OrderType,PrescNo,count)=list
		}elseif OrderType="L" {
			s ^CacheTemp(tIndx,"02"_OrderType,count)=list
		}elseif OrderType="S" {
			s ^CacheTemp(tIndx,"03"_OrderType,count)=list
		}else{
			s ^CacheTemp(tIndx,"04"_"O",count)=list
		}
		s count=count+1
	}
	d rs.Close()
GetRisReportId(oeitm)
	s RptRowId="",StudyNo=""
    s RegRowid=$o(^DHCPACRegInfoi("OEORI",oeitm,0))
    i RegRowid'="" {
    	s StudyNo=$p(^DHCPACRegInfo(RegRowid),"^",2)
    	s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,0)) 
    }
    Q RptRowId_"^"_StudyNo
}

/*
304,292||3^292||5^292||10^292||6^292||7^292||8^292||9,O16111600001^O16111600003^O16111600004,CFD
*/

// d ##class(DHCDoc.OPDoc.TreatPrint).PrescriptPrintData(660,"614||14^614||15^614||16","","JYDO")

// 打印 预览数据获取

ClassMethod PrescriptPrintData(episodeID, selectedOEItemID, listFilter = "", PrintType As %String = "", type As %String = "", StDate As %String, EndDate As %String)
{
	s ^tempscl("PrescriptPrintData")=episodeID_","_selectedOEItemID_","_listFilter_","_PrintType
    if (PrintType["CF"){ //处方(西药、毒麻、草药)
    
	    q ..GetPrescPrintData(episodeID,selectedOEItemID,listFilter,PrintType,type,StDate,EndDate)
	    
	}elseif(PrintType="DZD"){ //导诊单
	
		q ..GetDZDPrintData(episodeID,selectedOEItemID,listFilter,PrintType)
		
	}elseif(PrintType="SYDO")||(PrintType="ZSDO"){ //输液、注射单
	
		q ..GetSYZSPrintData(episodeID,selectedOEItemID,listFilter,PrintType,StDate,EndDate,type)
		
	}elseif(PrintType="JYDO"){ //化验告知单
	
		q ..GetJYDPrintData(episodeID,selectedOEItemID,listFilter,PrintType,type)
		
	}elseif(PrintType="ZLDO"){ //治疗单
		q ..GetZLDPrintData(episodeID,selectedOEItemID,listFilter,PrintType,StDate,EndDate,type)
	}elseif(PrintType="JCDMZ"){ //检查申请单
		q ..GetJCDMZPrintData(episodeID,selectedOEItemID,listFilter,PrintType,type)
	}elseif(PrintType="BLDMZ"){ //病理申请单
		q ..GetBLDMZPrintData(episodeID,selectedOEItemID,listFilter,PrintType,type)
	}elseif(PrintType="MZBL"){ //门诊病历
	
	}elseif(PrintType="ZDZMS"){ //诊断证明书
		//q ..GetEMRCertificatePrintData(episodeID,selectedOEItemID,listFilter,PrintType)
	}
}

ClassMethod GetEMRCertificatePrintData(episodeID, selectedOEItemID, listFilter = "", PrintType As %String = "")
{
	s LogUserID=%session.Get("LOGON.USERID")
	s EMRSignInfo=##class(web.UDHCPrescript).GetEMRSignUseID(episodeID,LogUserID,"EMRCertificate")
	s SignUserID=$p(EMRSignInfo,"^",1)
	s SignUserName=$p(EMRSignInfo,"^",2)
	if (SignUserID=""){
		w "[{]"
		q "]"
	}
	s checkTitle="",listRowId=episodeID_PrintType
	s PatInfoStr=..GetPatBaseInfo(episodeID)
	s PANo=$p(PatInfoStr,"^",1)
	s AdmDep=$p(PatInfoStr,"^",3)
	s AdmDate=$p(PatInfoStr,"^",4)
	s Name=$p(PatInfoStr,"^",6)
	s Sex=$p(PatInfoStr,"^",7)
	s Age=$p(PatInfoStr,"^",8)
	s Company=$p(PatInfoStr,"^",9)
    s SessHospDesc=$p(PatInfoStr,"^",17)
	w "["
	w "{"_"""checkTitle"""_":"_""""_checkTitle_""""_","_"""listRowId"""_":"_""""_listRowId_""""_","_"""data"""_":{"
	w """PANo"""_":"_""""_PANo_""""_","_"""Name"""_":"_""""_Name_""""_","_"""Age"""_":"_""""_Age_""""
	w ","_"""Sex"""_":"_""""_Sex_""""_","_"""AdmDep"""_":"_""""_AdmDep_""""
	w ","_"""AdmDate"""_":"_""""_AdmDate_""""_","_"""WorkStat"""_":"_""""_Company_""""_","_"""HosName"""_":"_""""_SessHospDesc_""""
	w ","_"""MyList"""_":[{"
	s EMRInfo=##class(web.UDHCPrescript).GetEMRCertificateInfo(EpisodeID,LogUserID)
	s SignData=$p(EMRInfo,$c(1),2)
	s LingChuangDia=$p(EMRInfo,$c(1),3)
	s WorkStat=$p(EMRInfo,$c(1),4)
	s Page=1,TotaPage=1
	s EMRList=$p(EMRInfo,$c(1),5)
	for i=1:1:EMRList.split("|||").length{
		s EMRName=$p($p(EMRList.split("|||"),i),"^",1)
		s EMRDetail=$p($p(EMRList.split("|||"),i),"^",2)
		if (EMRDetail.indexOf($c(10))){
			
		}
	}
	q "]"
}

ClassMethod GetJYDPrintDataOld(episodeID, selectedOEItemID, listFilter = "", PrintType As %String = "")
{
	s listRowId=episodeID_PrintType 
	if ((listFilter'="")&&(("^"_listFilter_"^")'[("^"_listRowId_""))){
		w "[{}"
		q "]"
	}
	s PatInfoStr=..GetPatBaseInfo(episodeID)
	s PANo=$p(PatInfoStr,"^",1)
	s PatientMedicareNo=$p(PatInfoStr,"^",2)
	s AdmDep=$p(PatInfoStr,"^",3)
	s AdmDate=$p(PatInfoStr,"^",4)
	s MRNo=$p(PatInfoStr,"^",5)
	s Name=$p(PatInfoStr,"^",6)
	s Sex=$p(PatInfoStr,"^",7)
	s Age=$p(PatInfoStr,"^",8)
	s Company=$p(PatInfoStr,"^",9)
	s Childweight=$p(PatInfoStr,"^",10)
    s Diagnose1=$p(PatInfoStr,"^",11)
    s Diagnose2=$p(PatInfoStr,"^",12)
    s Diagnose3=$p(PatInfoStr,"^",13)
    s Diagnose4=$p(PatInfoStr,"^",14)
    s Diagnose5=$p(PatInfoStr,"^",15)
    s Diagnose6=$p(PatInfoStr,"^",16)
    s SessHospDesc=$p(PatInfoStr,"^",17)
    s AdmReason=$p(PatInfoStr,"^",18)	
	s Diagnose1=$p(PatInfoStr,"^",11)
    s Diagnose2=$p(PatInfoStr,"^",12)
    s Diagnose3=$p(PatInfoStr,"^",13)
    s Diagnose4=$p(PatInfoStr,"^",14)
    s Diagnose5=$p(PatInfoStr,"^",15)
    s Diagnose6=$p(PatInfoStr,"^",16)
    s MRDiagnos=Diagnose1_" "_Diagnose2_" "_Diagnose3_" "_Diagnose4_" "_Diagnose5_" "_Diagnose6
	s PrintTime=$zd(+$h,3)_" "_..%ZT(..%SysTime(),1)
	s SessHospDesc=SessHospDesc_"检验告知单"
	s checkTitle="" //,listRowId=episodeID_PrintType
	//检验单需要考虑分页问题
	s PageOnLine=17 //一页显示行数
	s tIndx="QuerySYZSForPrint_"_$j
	k ^CacheTemp(tIndx)
	s Group=0,Count=0
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.UDHCOrderItemLabPrint"
	set rs.QueryName="GetOrderItems"
	set sc=rs.Execute(episodeID,"")
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		s OrdRowid=rs.Data("Rowid")
		continue:(selectedOEItemID'="")&&(("^"_selectedOEItemID_"^")'[("^"_OrdRowid_"^"))
		s OrderName=rs.Data("OrderName")_"("_$fn(rs.Data("Price"),"",2)_"元)"
		s spec=rs.Data("Spec")
		s LabEpisodeNo=rs.Data("LabEpisodeNo")
		s ProcessingNotes=rs.Data("ProcessingNotes")
		if (ProcessingNotes=""){
			s ProcessingNotes=rs.Data("DepProcNotes")
		}
		s RecDep=rs.Data("RecDep")
		s Count=Count+1
		s ^CacheTemp(tIndx,Count)=OrderName_"^"_spec_"^"_LabEpisodeNo_"^"_ProcessingNotes_"^"_RecDep
	}
	w "["
	s Len=$o(^CacheTemp(tIndx,""),-1)
	s PageSum=Len/PageOnLine
	if (PageSum[".") s PageSum=$p(PageSum,".",1)+1
	for PageNum=1:1:PageSum{
		s MinLen=PageOnLine*(PageNum-1)+1
		s MaxLen=PageOnLine*PageNum
		if (Len<MaxLen) s MaxLen=Len
		if (PageNum>1) w ","
		
		w "{"_"""checkTitle"""_":"_""""_checkTitle_""""_","_"""listRowId"""_":"_""""_listRowId_""""_","_"""data"""_":{"
		w """HosName"""_":"_""""_SessHospDesc_""""_","_"""PANo"""_":"_""""_PANo_"""" 
		w ","_"""AdmDep"""_":"_""""_AdmDep_""""_","_"""PrintDate"""_":"_""""_PrintTime_""""
		w ","_"""Name"""_":"_""""_Name_""""_","_"""Sex"""_":"_""""_Sex_""""
		w ","_"""Age"""_":"_""""_Age_""""_","_"""MRDiagnos"""_":"_""""_MRDiagnos_""""
		w ","_"""AdmDoc"""_":"_""""_%session.Get("LOGON.USERNAME")_""""
		w ","_"""MyList"""_":[{"
		s index=MinLen-1
		f  s index=$o(^CacheTemp(tIndx,index)) q:(index="")||(index>MaxLen)  d
		.s OrderName=$p(^CacheTemp(tIndx,index),"^",1)
		.s spec=$p(^CacheTemp(tIndx,index),"^",2)
		.s LabEpisodeNo=$p(^CacheTemp(tIndx,index),"^",3)
		.s ProcessingNotes=$p(^CacheTemp(tIndx,index),"^",4)
		.s LabGroupNumber=""
		.i index>MinLen w "},{"
		.w """MyList"""_":["""_LabGroupNumber_""""_"]"
		.w ","_"""OrderNmae"""_":["""_OrderName_""""_"]"
		.w ","_"""spec"""_":["""_spec_""""_"]"
		.w ","_"""No"""_":["""_LabEpisodeNo_""""_"]"
		.w ","_"""note"""_":["""_ProcessingNotes_""""_"]"
		w "}]"
		s PrintPage="第 "_PageNum_" 页  共 "_PageSum_" 页"
		w ","_"""PageNum"""_":"_""""_PrintPage_""""	
		w "}}"
	}
	q "]"
}

ClassMethod GetZLDPrintDataOld(episodeID, selectedOEItemID, listFilter = "", PrintType As %String = "", StDate, EndDate)
{
	s listRowId=episodeID_PrintType //_PageSum
	if ((listFilter'="")&&(("^"_listFilter_"^")'[("^"_listRowId_""))){
		w "[{}"
		q "]"
	}
	if (selectedOEItemID=""){
		w "[{}"
		q "]"
	}
	s PatInfoStr=..GetPatBaseInfo(episodeID)
	s PANo=$p(PatInfoStr,"^",1)
	s PatientMedicareNo=$p(PatInfoStr,"^",2)
	s AdmDep=$p(PatInfoStr,"^",3)
	s AdmDate=$p(PatInfoStr,"^",4)
	s MRNo=$p(PatInfoStr,"^",5)
	s Name=$p(PatInfoStr,"^",6)
	s Sex=$p(PatInfoStr,"^",7)
	s Age=$p(PatInfoStr,"^",8)
    s SessHospDesc=$p(PatInfoStr,"^",17)
    s CardNo=$p(PatInfoStr,"^",19)
	//治疗单需要考虑分页问题
	s PageOnLine=17 //一页显示行数
	s SessHospDesc=SessHospDesc_"治疗单"
	s tIndx="QueryZLDForPrint_"_$j
	k ^CacheTemp(tIndx)
	s Group=0,Count=0,SumFee=0
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCDocTransFusion"
	set rs.QueryName="FindOrdItem"
	set sc=rs.Execute(episodeID, "@"_PrintType, "", "", StDate,EndDate)
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		s oeoriId=rs.Data("oeoriId")
		if (selectedOEItemID'="")&&(("^"_selectedOEItemID_"^")'[("^"_oeoriId_"^")) continue
		s Count=Count+1
		s ArcimDesc=rs.Data("arcimDesc")
		s DoseQtyUnit=rs.Data("doseQtyUnit")
		s phOrdQtyUnit=rs.Data("phOrdQtyUnit")
		s price=rs.Data("price")
		s SumFee=SumFee+rs.Data("totalAmount")
		s ^CacheTemp(tIndx,Count)=ArcimDesc_"^"_DoseQtyUnit_"^"_phOrdQtyUnit_"^"_price
	}
	s SumFee=SumFee_"元"
	s PrintTime=$zd(+$h,3)_" "_..%ZT(..%SysTime(),1)
	w "["
	s checkTitle=""
	s Len=$o(^CacheTemp(tIndx,""),-1)
	s PageSum=Len/PageOnLine
	if (PageSum[".") s PageSum=$p(PageSum,".",1)+1
	for PageNum=1:1:PageSum{
		s MinLen=PageOnLine*(PageNum-1)+1
		s MaxLen=PageOnLine*PageNum
		if (Len<MaxLen) s MaxLen=Len
		if (PageNum>1) w ","
		w "{"_"""checkTitle"""_":"_""""_checkTitle_""""_","_"""listRowId"""_":"_""""_listRowId_""""_","_"""data"""_":{"
		w """HosName"""_":"_""""_SessHospDesc_""""_","_"""RegNo"""_":"_""""_CardNo_""""
		w ","_"""CTLOCName"""_":"_""""_AdmDep_""""_","_"""PrintTime"""_":"_""""_PrintTime_""""
		w ","_"""PName"""_":"_""""_Name_""""_","_"""SumFee"""_":"_""""_SumFee_""""
		w ","_"""Age"""_":"_""""_Age_""""_","_"""CaseHistoryNo"""_":"_""""_MRNo_""""_","_"""DoctorName"""_":"_""""_%session.Get("LOGON.USERNAME")_""""
		w ","_"""MyList"""_":[{"
		for i=MinLen:1:MaxLen {
			s OneOrdItemInfo=$g(^CacheTemp(tIndx,i))
			continue:OneOrdItemInfo=""
			s MyList=""
			s ArcimDesc=$p(OneOrdItemInfo,"^",1)
			s doseQtyUnit=$p(OneOrdItemInfo,"^",2)
			s phOrdQtyUnit=$p(OneOrdItemInfo,"^",3)
			s price=$p(OneOrdItemInfo,"^",4)
			s ArcimDesc1="",doseQtyUnit1="",phOrdQtyUnit1="",price1=""
			if (i>MinLen) w "},{" 
			w """MyList"""_":["""_MyList_""""_"]"
			w ","_"""ArcimDesc"""_":["""_ArcimDesc_""""_"]"
			w ","_"""doseQtyUnit"""_":["""_doseQtyUnit_""""_"]"
			w ","_"""phOrdQtyUnit"""_":["""_phOrdQtyUnit_""""_"]"
			w ","_"""price"""_":["""_price_""""_"]"
			
			w ","_"""ArcimDesc1"""_":["""_ArcimDesc1_""""_"]"
			w ","_"""doseQtyUnit1"""_":["""_doseQtyUnit1_""""_"]"
			w ","_"""phOrdQtyUnit1"""_":["""_phOrdQtyUnit1_""""_"]"
			w ","_"""price1"""_":["""_price1_""""_"]"
		}
		/*if (MaxLen=Len){
			s OneOrdItemInfo=$g(^CacheTemp(tIndx,MaxLen))
			s MyList=$p(OneOrdItemInfo,"^",1)
			s ArcimDesc1="",doseQtyUnit1="",phOrdQtyUnit1="",price1=""
			w "},{"
			w """MyList"""_":["""_MyList_""""_"]"
			w ","_"""Rec"""_":["""_Rec_""""_"]"
			w ","_"""Count"""_":["""_Count_""""_"]"
			w ","_"""No"""_":["""_No_""""_"]"
			w ","_"""Addr"""_":["""_Addr_""""_"]"
			w "},"
			s OneOrdItemInfo=$p(OrdItemInfo,$c(2),MaxLen+2)
			s MyList=$p(OneOrdItemInfo,"^",1)
			w "{"
			w """MyList"""_":["""_MyList_""""_"]"
			w ","_"""Rec"""_":["""_Rec_""""_"]"
			w ","_"""Count"""_":["""_Count_""""_"]"
			w ","_"""No"""_":["""_No_""""_"]"
			w ","_"""Addr"""_":["""_Addr_""""_"]"
		}*/
		w "}]"
		s PrintPage="第 "_PageNum_" 页  共 "_PageSum_" 页"
		w ","_"""PrintPage"""_":"_""""_PrintPage_""""	
		w "}}"
		
		/*s index=MinLen-1
		f  s index=$o(^CacheTemp(tIndx,index)) q:(index="")||(index>MaxLen)  d
		.if (index>MinLen) w "," 
		.s MyList=$g(^CacheTemp(tIndx,index))
		.w """"_MyList_""""
		w "]}}"*/
	}
	k ^CacheTemp(tIndx)
	q "]"
}

// w ##class(DHCDoc.OPDoc.TreatPrint).GetJCDMZPrintData(574,"530||3","","JCDMZ","PreView")

ClassMethod GetJCDMZPrintDataOld(episodeID, selectedOEItemID, listFilter = "", PrintType As %String = "", type As %String = "") As %String
{
	s ^tempscl("GetJCDMZPrintData")=episodeID_","_selectedOEItemID_","_listFilter_","_PrintType_","_type
	if (selectedOEItemID=""){
		w "[{}"
		q "]"
	}
	k TMPJCDMZData
	s OrdLen = $l(selectedOEItemID,"^")
	f i=1:1:OrdLen d
	.s OrdItm = $p(selectedOEItemID,"^",i)
	.s Params = ""
	.s $p(Params,"^",3)=OrdItm
	.s TraType=##Class(web.DHCAPPInterface).GetTraCatType(Params) /// P/E/L
	.Q:TraType'="E"
	.s ReqID=$o(^DHCAPREP(0,"OrdItem",OrdItm,""))
	.q:+ReqID=0
	.s listRowId=episodeID_"JCDMZ"_ReqID
	.Q:((listFilter'="")&&(("^"_listFilter_"^")'[("^"_listRowId_"")))
	.s TMPJCDMZData("E",ReqID)=""
	w "["
	s ReqID="",num=0,checkTitle=""
	f  s ReqID = $o(TMPJCDMZData("E",ReqID)) q:ReqID=""  d
	.if (num>0) w ","
	.k ServiceOrdCongeriesArr
	.d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(##Class(web.DHCAPPPrintCom).GetExaReqPrintData(ReqID,""),.ServiceOrdCongeriesArr)
	.s listRowId=episodeID_"JCDMZ"_ReqID
	.s PrintTemp=$g(ServiceOrdCongeriesArr("PrintTemp")) //打印模板xml名称
	.w "{"_"""checkTitle"""_":"_""""_checkTitle_""""_","_"""listRowId"""_":"_""""_listRowId_""""_","_"""PrintTemp"""_":"_""""_PrintTemp_""""_","_"""data"""_":{"
	.s id=0,Itemnum=0
	.f  s id=$o(ServiceOrdCongeriesArr(id)) q:id=""  d
	..i Itemnum>0 w ","
	..w """"_id_""""_":"_""""_$g(ServiceOrdCongeriesArr(id))_""""
	..s Itemnum=Itemnum+1 
	.w ","_"""MyList"""_":["
	.w "]}}"
	.s num=num+1
	.i type="Print" d ##Class(web.DHCAPPExaReport).UpdNurPrtInfo(ReqID,%session.Get("LOGON.USERID"))
	/*.if (num>0) w ","
	.s PatSymInfoLen=$l(ServiceOrdCongeriesArr("PatSymInfo"))
	.i PatSymInfoLen\42<=1 s LabelName(0)=ServiceOrdCongeriesArr("PatSymInfo")
	.e  d
	..for i=1:1:PatSymInfoLen\42 d
	...Q:i>4
	...s substr=$e(ServiceOrdCongeriesArr("PatSymInfo"),(i-1)*42+1,(i-1)*42+41)
	...if i=4 s LabelName(i)=substr_"..."
	...s LabelName(i)=substr
	.w "{"_"""checkTitle"""_":"_""""_checkTitle_""""_","_"""listRowId"""_":"_""""_listRowId_""""_","_"""data"""_":{"
	.w """RegNo"""_":"_""""_ServiceOrdCongeriesArr("PatNo")_""""_","_"""HosName"""_":"_""""_ServiceOrdCongeriesArr("ExaReqTitle")_"检查申请单"_ServiceOrdCongeriesArr("PrintFlag")_"""" 
	.w ","_"""EmgFlag"""_":"_""""_ServiceOrdCongeriesArr("arEmgFlag")_""""_","_"""PatNo"""_":"_""""_"*"_ServiceOrdCongeriesArr("PatNo")_"*"_""""
	.w ","_"""Name"""_":"_""""_ServiceOrdCongeriesArr("PatName")_""""_","_"""Age"""_":"_""""_ServiceOrdCongeriesArr("PatAge")_""""
	.w ","_"""MedicareNo"""_":"_""""_ServiceOrdCongeriesArr("MedicareNo")_""""_","_"""InLoc"""_":"_""""_ServiceOrdCongeriesArr("PatLoc")_""""_","_"""Sex"""_":"_""""_ServiceOrdCongeriesArr("PatSex")_""""
	.w ","_"""InsuranceNo"""_":"_""""_ServiceOrdCongeriesArr("InsuranceNo")_""""_","_"""PatientNowValue1"""_":"_""""_$g(LabelName(0))_""""
	.w ","_"""PatientNowValue2"""_":"_""""_$g(LabelName(1))_""""_","_"""PatientNowValue3"""_":"_""""_$g(LabelName(2))_""""
	.w ","_"""PatientNowValue4"""_":"_""""_$g(LabelName(3))_""""_","_"""PatientNowValue5"""_":"_""""_$g(LabelName(4))_""""
	.w ","_"""MainDiagoseValue1"""_":"_""""_ServiceOrdCongeriesArr("PatDiagDesc1")_""""_","_"""MainDiagoseValue2"""_":"_""""_ServiceOrdCongeriesArr("PatDiagDesc2")_""""
	.w ","_"""PurposeValue1"""_":"_""""_ServiceOrdCongeriesArr("arItemDesc1")_""""_","_"""PurposeValue2"""_":"_""""_ServiceOrdCongeriesArr("arItemDesc2")_""""
	.w ","_"""RecLoc"""_":"_""""_ServiceOrdCongeriesArr("arRepExLoc")_""""_","_"""LocAddress"""_":"_""""_ServiceOrdCongeriesArr("arRepExLocAdrr")_""""
	.w ","_"""HopeDate"""_":"_""""_ServiceOrdCongeriesArr("arReqTime")_""""_","_"""AppDoc"""_":"_""""_ServiceOrdCongeriesArr("arUserCode")_""""
	.w ","_"""CardNo"""_":"_""""_ServiceOrdCongeriesArr("CardNo")_""""_","_"""PatCardMoney"""_":"_""""_ServiceOrdCongeriesArr("PatCardMoney")_""""
	.w ","_"""ExaReqNoCost"""_":"_""""_ServiceOrdCongeriesArr("ExaReqNoCost")_""""_","_"""OthOptList"""_":"_""""_ServiceOrdCongeriesArr("OthOptList")_""""
	.w ","_"""Type"""_":"_""""_ServiceOrdCongeriesArr("Type")_""""_","_"""SSDesc"""_":"_""""_ServiceOrdCongeriesArr("SSDesc")_""""
	.w ","_"""AdmBed"""_":"_""""_ServiceOrdCongeriesArr("AdmBed")_""""_","_"""NoteList"""_":"_""""_$tr(ServiceOrdCongeriesArr("NoteList"),"$","\n")_""""
	.w ","_"""InsuCardNo"""_":"_""""_ServiceOrdCongeriesArr("InsuCardNo")_""""_","_"""InsuNo"""_":"_""""_ServiceOrdCongeriesArr("InsuNo")_""""
	.w ","_"""PrintFlag"""_":"_""""_ServiceOrdCongeriesArr("PrintFlag")_""""_","_"""PreInFlag"""_":"_""""_ServiceOrdCongeriesArr("PreInFlag")_""""
	.w ","_"""GreenFlag"""_":"_""""_ServiceOrdCongeriesArr("GreenFlag")_""""_","_"""Location"""_":"_""""_ServiceOrdCongeriesArr("arRepExLocAdrr")_"  "_ServiceOrdCongeriesArr("arRepExLoc")_"  "_"刷卡检查"_""""
	.w ","_"""MyList"""_":["
	.w "]}}"
	.s num=num+1
	.i type="Print" d ##Class(web.DHCAPPExaReport).UpdNurPrtInfo(ReqID,%session.Get("LOGON.USERID"))*/
	k TMPJCDMZData,ServiceOrdCongeriesArr
	Q "]"
}

// w ##class(DHCDoc.OPDoc.TreatPrint).GetBLDMZPrintData(1896,"1770||12","","BLDMZ")

ClassMethod GetBLDMZPrintDataOld(episodeID, selectedOEItemID, listFilter = "", PrintType As %String = "") As %String
{
	if (selectedOEItemID=""){
		w "[{}"
		q "]"
	}
	
	k TMPJCDMZData
	s OrdLen = $l(selectedOEItemID,"^")
	f i=1:1:OrdLen d
	.s OrdItm = $p(selectedOEItemID,"^",i)
	.s Params = ""
	.s $p(Params,"^",3)=OrdItm
	.s TraType=##Class(web.DHCAPPInterface).GetTraCatType(Params) /// P/E/L
	.Q:TraType'="P"
	.s ReqID=$o(^DHCAPPPM(0,"OrdItem",OrdItm,""))
	.q:+ReqID=0
	.s listRowId=episodeID_"BLDMZ"_ReqID
	.Q:((listFilter'="")&&(("^"_listFilter_"^")'[("^"_listRowId_"")))
	.s TMPBLDMZData("P",ReqID)=""
	w "["
	s ReqID="",num=0,checkTitle=""
	f  s ReqID = $o(TMPBLDMZData("P",ReqID)) q:ReqID=""  d
	.k ServiceOrdCongeriesArr
	.d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(##Class(web.DHCAPPPrintCom).GetPisPrintCon(ReqID),.ServiceOrdCongeriesArr)
	.s listRowId=episodeID_"BLDMZ"_ReqID
	.if (num>0) w ","
	.s PrintTemp=$g(ServiceOrdCongeriesArr("PrintTemp")) //打印模板xml名称
	.w "{"_"""checkTitle"""_":"_""""_checkTitle_""""_","_"""listRowId"""_":"_""""_listRowId_""""_","_"""PrintTemp"""_":"_""""_PrintTemp_""""_","_"""data"""_":{"
	.s id=0,Itemnum=0
	.f  s id=$o(ServiceOrdCongeriesArr(id)) q:id=""  d
	..i Itemnum>0 w ","
	..w """"_id_""""_":"_""""_$g(ServiceOrdCongeriesArr(id))_""""
	..s Itemnum=Itemnum+1 
	.w ","_"""MyList"""_":["
	.w "]}}"
	.s num=num+1
	/*.w "{"_"""checkTitle"""_":"_""""_checkTitle_""""_","_"""listRowId"""_":"_""""_listRowId_""""_","_"""data"""_":{"
	.w """PatNo"""_":"_""""_ServiceOrdCongeriesArr("PatNo")_""""_","_"""PatNoBarCode"""_":"_""""_"*"_ServiceOrdCongeriesArr("Oeori")_"*"_"""" 
	.w ","_"""BarCode"""_":"_""""_ServiceOrdCongeriesArr("Oeori")_""""_","_"""PatName"""_":"_""""_ServiceOrdCongeriesArr("PatName")_""""
	.w ","_"""PatSex"""_":"_""""_ServiceOrdCongeriesArr("PatSex")_""""_","_"""PatAge"""_":"_""""_ServiceOrdCongeriesArr("PatAge")_""""
	.w ","_"""MedicareNo"""_":"_""""_ServiceOrdCongeriesArr("MedicareNo")_""""_","_"""PatBod"""_":"_""""_ServiceOrdCongeriesArr("PatBod")_""""_","_"""BillType"""_":"_""""_ServiceOrdCongeriesArr("BillType")_""""
	.w ","_"""PatBed"""_":"_""""_ServiceOrdCongeriesArr("PatBed")_""""_","_"""PatAddr"""_":"_""""_ServiceOrdCongeriesArr("PatAddr")_""""
	.w ","_"""PatTelH"""_":"_""""_ServiceOrdCongeriesArr("PatTelH")_""""_","_"""PatWard"""_":"_""""_ServiceOrdCongeriesArr("PatWard")_""""
	.w ","_"""UserName"""_":"_""""_ServiceOrdCongeriesArr("UserName")_""""_","_"""ReqLoc"""_":"_""""_ServiceOrdCongeriesArr("ReqLoc")_""""
	.w ","_"""CreatDate"""_":"_""""_ServiceOrdCongeriesArr("CreatDate")_""""
	
	.w ","_"""EmgFlag"""_":"_""""_$g(ServiceOrdCongeriesArr("EmgFlag"))_""""_","_"""FrostFlag"""_":"_""""_$g(ServiceOrdCongeriesArr("FrostFlag"))_""""
	.w ","_"""PisNo"""_":"_""""_$g(ServiceOrdCongeriesArr("PisNo"))_""""_","_"""PisReqNo"""_":"_""""_$g(ServiceOrdCongeriesArr("PisReqNo"))_""""
	.w ","_"""ItemDesc"""_":"_""""_$g(ServiceOrdCongeriesArr("ItemDesc"))_""""_","_"""PisReqSpec"""_":"_""""_$g(ServiceOrdCongeriesArr("PisReqSpec"))_""""
	.w ","_"""MedRecord"""_":"_""""_$g(ServiceOrdCongeriesArr("MedRecord"))_""""_","_"""PisTesDiag"""_":"_""""_$g(ServiceOrdCongeriesArr("PisTesDiag"))_""""
	.w ","_"""SepDate"""_":"_""""_$g(ServiceOrdCongeriesArr("SepDate"))_""""_","_"""GreenFlag"""_":"_""""_$g(ServiceOrdCongeriesArr("GreenFlag"))_""""
	.w ","_"""MyList"""_":["
	.w "]}}"
	.s num=num+1*/
	k TMPBLDMZData,ServiceOrdCongeriesArr
	Q "]"
}

ClassMethod GetSYZSPrintDataOld(episodeID, selectedOEItemID, listFilter = "", PrintType As %String = "", StDate, EndDate)
{
	s listRowId=episodeID_PrintType //_PageSum
	if ((listFilter'="")&&(("^"_listFilter_"^")'[("^"_listRowId_""))){
		w "[{}"
		q "]"
	}
	if (selectedOEItemID=""){
		w "[{}"
		q "]"
	}
	s PatInfoStr=..GetPatBaseInfo(episodeID)
	s PANo=$p(PatInfoStr,"^",1)
	s PatientMedicareNo=$p(PatInfoStr,"^",2)
	s AdmDep=$p(PatInfoStr,"^",3)
	s AdmDate=$p(PatInfoStr,"^",4)
	s MRNo=$p(PatInfoStr,"^",5)
	s Name=$p(PatInfoStr,"^",6)
	s Sex=$p(PatInfoStr,"^",7)
	s Age=$p(PatInfoStr,"^",8)
	s Company=$p(PatInfoStr,"^",9)
	s Childweight=$p(PatInfoStr,"^",10)
    s Diagnose1=$p(PatInfoStr,"^",11)
    s Diagnose2=$p(PatInfoStr,"^",12)
    s Diagnose3=$p(PatInfoStr,"^",13)
    s Diagnose4=$p(PatInfoStr,"^",14)
    s Diagnose5=$p(PatInfoStr,"^",15)
    s Diagnose6=$p(PatInfoStr,"^",16)
    s SessHospDesc=$p(PatInfoStr,"^",17)
    s AdmReason=$p(PatInfoStr,"^",18)
    s CardNo=$p(PatInfoStr,"^",19)
	//输液、注射单需要考虑分页问题
	s PageOnLine=20 //一页显示行数
	if (PrintType="SYDO") s SessHospDesc=SessHospDesc_"输液单"
	if (PrintType="ZSDO") s SessHospDesc=SessHospDesc_"注射单"
	if (PrintType="ZLDO") s SessHospDesc=SessHospDesc_"治疗单"
	s tIndx="QuerySYZSForPrint_"_$j
	k ^CacheTemp(tIndx)
	s Group=0,Count=0
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCDocTransFusion"
	set rs.QueryName="FindOrdItem"
	set sc=rs.Execute(episodeID, "@"_PrintType, "", "", StDate,EndDate)
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		s oeoriId=rs.Data("oeoriId")
		s ArcimDesc=rs.Data("arcimDesc")
		s DoseQtyUnit=rs.Data("doseQtyUnit")
		s PhcfrCode=rs.Data("phcfrCode")
		s PhcinDesc=rs.Data("phcinDesc")
		s notes=rs.Data("notes")
		s PlanSum=+##class(web.DHCDocTransFusion).GetExecSum(oeoriId)
		s OEORIDR=rs.Data("OEORIDR")
		s LastItemFlag=0
		if (selectedOEItemID'="")&&(("^"_selectedOEItemID_"^")'[("^"_oeoriId_"^")) continue
		if OEORIDR'=oeoriId {
			s ArcimDesc="_"_ArcimDesc
		}else {
			s Group=Group+1
			if (Group>1){
				s str="",sum=1
				s ExecPlan=##class(web.DHCDocTransFusion).GetExecPlan(LastMainOrd)
				for k=1:1:$l(ExecPlan,"#"){
					s DateStr=$p(ExecPlan,"#",k)
					continue:DateStr=""
					s week=$zd($zdh($p(DateStr,"^",2),3),10)
					s week=$case(week,0:"(日)",1:"(一)",2:"(二)",3:"(三)",4:"(四)",5:"(五)",6:"(六)")
					s Date=$p(DateStr,"^",1)
					i str="" s str=Date_week
					e  s str=str_"&nbsp&nbsp&nbsp&nbsp"_Date_week
					if (sum>=5){
						s Count=Count+1
						s ^CacheTemp(tIndx,Count)=str_"</br>"
						s str=""
						s sum=0 //Count=Count+1,
					}
					s sum=sum+1
				}
				i str'="" s Count=Count+1 s ^CacheTemp(tIndx,Count)=str_"</br>"
			}
			s Count=Count+1
			s ^CacheTemp(tIndx,Count)="------------------------------------第"_Group_"组------------------------------------</br>"
			s LastMainOrd=oeoriId
		} 
		s Count=Count+1
		s ^CacheTemp(tIndx,Count)=ArcimDesc_"&nbsp/&nbsp"_DoseQtyUnit_"&nbsp&nbsp"_PhcfrCode_"&nbsp&nbsp"_PhcinDesc_"&nbsp&nbsp"_notes_"&nbsp&nbsp"_PlanSum_"次"_"</br>"
	}
	s Count=Count+1
	//取最后一组的执行记录
	if (LastMainOrd'=""){
		s str="",sum=1
		s ExecPlan=##class(web.DHCDocTransFusion).GetExecPlan(LastMainOrd)
		for k=1:1:$l(ExecPlan,"#"){
			s DateStr=$p(ExecPlan,"#",k)
			continue:DateStr=""
			s week=$zd($zdh($p(DateStr,"^",2),3),10)
			s week=$case(week,0:"(日)",1:"(一)",2:"(二)",3:"(三)",4:"(四)",5:"(五)",6:"(六)")
			s Date=$p(DateStr,"^",1)
			i str="" s str=Date_week
			e  s str=str_"&nbsp&nbsp&nbsp&nbsp"_Date_week
			if (sum>=5){
				s Count=Count+1
				s ^CacheTemp(tIndx,Count)=str_"</br>"
				s str=""
				s Count=Count+1,sum=0
			}
			s sum=sum+1
		}
		i str'="" s Count=Count+1 s ^CacheTemp(tIndx,Count)=str_"</br>"
	}
	//s ^CacheTemp(tIndx,Count)=$zd(+$h,3)_"</br>"
	s PrintTime=$zd(+$h,3)_" "_..%ZT(..%SysTime(),1)
	w "["
	s checkTitle=""
	s Len=$o(^CacheTemp(tIndx,""),-1)
	m ^tempscl("sceshi")=^CacheTemp(tIndx)
	s PageSum=Len/PageOnLine
	if (PageSum[".") s PageSum=$p(PageSum,".",1)+1
	for PageNum=1:1:PageSum{
		s MinLen=PageOnLine*(PageNum-1)+1
		s MaxLen=PageOnLine*PageNum
		if (Len<MaxLen) s MaxLen=Len
		if (PageNum>1) w ","
		w "{"_"""checkTitle"""_":"_""""_checkTitle_""""_","_"""listRowId"""_":"_""""_listRowId_""""_","_"""data"""_":{"
		w """HosName"""_":"_""""_SessHospDesc_""""_","_"""RegNo"""_":"_""""_CardNo_"""" //","_"""HosNameType"""_":"_""""_HosNameType_""""_
		w ","_"""CTLOCName"""_":"_""""_AdmDep_""""_","_"""PrintTime"""_":"_""""_PrintTime_""""
		w ","_"""PName"""_":"_""""_Name_""""_","_"""Sex"""_":"_""""_Sex_""""
		w ","_"""Age"""_":"_""""_Age_""""_","_"""CaseHistoryNo"""_":"_""""_MRNo_""""_","_"""DoctorName"""_":"_""""_%session.Get("LOGON.USERNAME")_""""
		w ","_"""MyList"""_":["
		s index=MinLen-1
		f  s index=$o(^CacheTemp(tIndx,index)) q:(index="")||(index>MaxLen)  d
		.s MyList=$g(^CacheTemp(tIndx,index))
		.Q:MyList=""
		.if (index>MinLen) w "," 
		.w """"_MyList_""""
		w "]}}"
	}
	k ^CacheTemp(tIndx)
	q "]"
}

// w ##class(DHCDoc.OPDoc.TreatPrint).GetDZDPrintData(643,"595||3^595||10^595||11^595||12^595||13^595||9^595||4^595||8^595||1^595||14^595||15^595||2^595||5^595||6^595||7","","DZD")

// 

ClassMethod GetDZDPrintDataOld(episodeID, selectedOEItemID, listFilter = "", PrintType As %String = "")
{
	s ^temoscl("GetDZDPrintData")=episodeID_","_selectedOEItemID_","_listFilter_","_PrintType
	s listRowId=episodeID_"DZD"
	if ((listFilter'="")&&(("^"_listFilter_"^")'[("^"_listRowId_""))){
		w "[{}"
		q "]"
	}
	s PatInfoStr=..GetPatBaseInfo(episodeID)
	s PANo=$p(PatInfoStr,"^",1)
	s PatientMedicareNo=$p(PatInfoStr,"^",2)
	s AdmDep=$p(PatInfoStr,"^",3)
	s AdmDate=$p(PatInfoStr,"^",4)
	s MRNo=$p(PatInfoStr,"^",5)
	s Name=$p(PatInfoStr,"^",6)
	s Sex=$p(PatInfoStr,"^",7)
	s Age=$p(PatInfoStr,"^",8)
	s Company=$p(PatInfoStr,"^",9)
	s Childweight=$p(PatInfoStr,"^",10)
    s Diagnose1=$p(PatInfoStr,"^",11)
    s Diagnose2=$p(PatInfoStr,"^",12)
    s Diagnose3=$p(PatInfoStr,"^",13)
    s Diagnose4=$p(PatInfoStr,"^",14)
    s Diagnose5=$p(PatInfoStr,"^",15)
    s Diagnose6=$p(PatInfoStr,"^",16)
    s SessHospDesc=$p(PatInfoStr,"^",17)
    s AdmReason=$p(PatInfoStr,"^",18)
    //导诊单需要考虑分页问题
	s PageOnLine=17 //一页显示行数
	s SessHospDesc=SessHospDesc_"导诊单"
	if (selectedOEItemID=""){
		w "[{}"
		q "]"
	}
	s OrdItemInfo=##class(web.UDHCPrescript).GetOrdItemInfoNew(episodeID,selectedOEItemID) //$g(%session.Data("LOGON.CTLOCID"))
	if (OrdItemInfo=""){
		w "[{]"
		q "]"
	}
	w "["
	s checkTitle=""
	s Len=$l(OrdItemInfo,$c(2))-2
	s PageSum=Len/PageOnLine
	if (PageSum[".") s PageSum=$p(PageSum,".",1)+1
	for PageNum=1:1:PageSum{
		s MinLen=PageOnLine*(PageNum-1)+1
		s MaxLen=PageOnLine*PageNum
		if (Len<MaxLen) s MaxLen=Len
		if (PageNum>1) w ","
		s listRowId=episodeID_"DZD" //_PageSum
		s PANoBarCode="*"_PANo_"*"
		w "{"_"""checkTitle"""_":"_""""_checkTitle_""""_","_"""listRowId"""_":"_""""_listRowId_""""_","_"""data"""_":{"
		w """PANoBarCode"""_":"_""""_PANoBarCode_""""_","_"""PANo"""_":"_""""_PANo_""""_","_"""Name"""_":"_""""_Name_""""
		w ","_"""Sex"""_":"_""""_Sex_""""_","_"""Age"""_":"_""""_Age_""""
		w ","_"""AdmDep"""_":"_""""_AdmDep_""""_","_"""PANo"""_":"_""""_PANo_""""
		w ","_"""AdmDate"""_":"_""""_AdmDate_""""_","_"""AdmReasonDesc"""_":"_""""_AdmReason_""""
		w ","_"""Diagnose1"""_":"_""""_Diagnose1_""""_","_"""Diagnose2"""_":"_""""_Diagnose2_""""
		w ","_"""HosName"""_":"_""""_SessHospDesc_""""_","_"""UserName"""_":"_""""_%session.Get("LOGON.USERNAME")_""""    
		w ","_"""MyList"""_":[{"
		for i=MinLen:1:MaxLen {
			s OneOrdItemInfo=$p(OrdItemInfo,$c(2),i)
			continue:OneOrdItemInfo=""
			s MyList=$p(OneOrdItemInfo,"^",1)
			s Rec=$p(OneOrdItemInfo,"^",2)
			s Count="",No=""
			s Addr=$p(OneOrdItemInfo,"^",3)
			if (i>MinLen) w "},{" 
			w """MyList"""_":["""_MyList_""""_"]"
			w ","_"""Rec"""_":["""_Rec_""""_"]"
			w ","_"""Count"""_":["""_Count_""""_"]"
			w ","_"""No"""_":["""_No_""""_"]"
			w ","_"""Addr"""_":["""_Addr_""""_"]"
		}
		if (MaxLen=Len){
			s OneOrdItemInfo=$p(OrdItemInfo,$c(2),MaxLen+1)
			s MyList=$p(OneOrdItemInfo,"^",1)
			s Rec="",Count="",No="",Addr=""
			w "},{"
			w """MyList"""_":["""_MyList_""""_"]"
			w ","_"""Rec"""_":["""_Rec_""""_"]"
			w ","_"""Count"""_":["""_Count_""""_"]"
			w ","_"""No"""_":["""_No_""""_"]"
			w ","_"""Addr"""_":["""_Addr_""""_"]"
			w "},"
			s OneOrdItemInfo=$p(OrdItemInfo,$c(2),MaxLen+2)
			s MyList=$p(OneOrdItemInfo,"^",1)
			w "{"
			w """MyList"""_":["""_MyList_""""_"]"
			w ","_"""Rec"""_":["""_Rec_""""_"]"
			w ","_"""Count"""_":["""_Count_""""_"]"
			w ","_"""No"""_":["""_No_""""_"]"
			w ","_"""Addr"""_":["""_Addr_""""_"]"
		}
		w "}]"
		s PrintPage="第 "_PageNum_" 页  共 "_PageSum_" 页"
		w ","_"""PrintPage"""_":"_""""_PrintPage_""""	
		w "}}"
	}
	q "]"
}

ClassMethod GetPrescPrintDataOld(episodeID, selectedOEItemID, listFilter = "", PrintType As %String = "", type As %String = "", StDate As %String, EndDate As %String)
{
	s ^Tempscl("GetPrescPrintData")=episodeID_","_selectedOEItemID_","_listFilter_","_PrintType
	s selPrescNoStr=..GetSelPerscNoStr(selectedOEItemID)
	if (selPrescNoStr=""){
		w "[{}"
		q "]"
	}
	;2019-01-10改为调用药房组接口获取打印数据
	;w ##class(PHA.OP.COM.Print).PrescPrintData("O181125000001") //web.DHCOUTPHA.Common.Print
	i type="Print" s PrtType=""
	e  s PrtType="DISPPREVIEW"
	s tIndx="QueryOEForPrint_"_$j
	s PrescNoCount=1
	w "["
	for i=1:1:$l(selPrescNoStr,"^"){
		s prescNo=$p(selPrescNoStr,"^",i)
		s listRowId=prescNo_PrintType
		continue:(listFilter'="")&&(("^"_listFilter_"^")'[("^"_listRowId_"^"))
		i PrintType="CFZ" s ZfFlag="正方"
		e  s ZfFlag="底方"
		k PrescOrdCongeriesArr
		s PrescData=##class(PHA.OP.COM.Print).PrescPrintData(prescNo,ZfFlag,PrtType,1)
		continue:PrescData="{}"
		d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(PrescData,.PrescOrdCongeriesArr)
		if (PrescNoCount>1) w ","
		s PrintTemp=$g(PrescOrdCongeriesArr("Templet")) //打印模板xml名称
		w "{"_"""checkTitle"""_":"_""""_prescNo_""""_","_"""listRowId"""_":"_""""_listRowId_""""_","_"""PrintTemp"""_":"_""""_PrintTemp_""""_","_"""data"""_":{"
		s id=0,Itemnum=0
		for {
			s id=$o(PrescOrdCongeriesArr("Para",id))
			Q:id=""
			i Itemnum>0 w ","
			s Onedata=$g(PrescOrdCongeriesArr("Para",id))
			if (id["Diagnose") {
				s Onedata=##class(ext.util.String).Replace(Onedata,$c(10), "\n")
			}
			w """"_id_""""_":"_""""_Onedata_""""
			s Itemnum=Itemnum+1 
		}
		s IsCMPresType = ##Class(web.DHCDocPrescript).IsPrescType(prescNo) //是否是草药处方
		if IsCMPresType="1" {
			w ","_"""listitem1"""_":["
		}else{
			w ","_"""MyList"""_":["
		}
		s id=0,Itemnum=0
		for {
			s id=$o(PrescOrdCongeriesArr("List",id))
			Q:id=""
			i Itemnum>0 w ","
			if IsCMPresType="1" {
				w "{"
				s ItemData=$g(PrescOrdCongeriesArr("List",id))
				for j=1:1:$l(ItemData,"^"){
					i j>1 w ","
					s listitem="listitem"_j
					w """"_listitem_""""_":["""_##class(web.DHCDocUtil).EvalJSON($p(ItemData,"^",j))_""""_"]"
					;w """"_listitem_""""_":"""_$p(ItemData,"^",j)_""""
				}
				w "}"
			}else{
				w """"_##class(web.DHCDocUtil).EvalJSON($g(PrescOrdCongeriesArr("List",id)))_""""
			}
			s Itemnum=Itemnum+1 
		}
		w "]}}"
		s PrescNoCount=PrescNoCount+1
	}
	q "]"
	/*s PatInfoStr=..GetPatBaseInfo(episodeID)
	s PANo=$p(PatInfoStr,"^",1)
	s PatientMedicareNo=$p(PatInfoStr,"^",2)
	s AdmDep=$p(PatInfoStr,"^",3)
	s AdmDate=$p(PatInfoStr,"^",4)
	s MRNo=$p(PatInfoStr,"^",5)
	s Name=$p(PatInfoStr,"^",6)
	s Sex=$p(PatInfoStr,"^",7)
	s Age=$p(PatInfoStr,"^",8)
	s Company=$p(PatInfoStr,"^",9)
	s Childweight=$p(PatInfoStr,"^",10)
    s Diagnose1=$p(PatInfoStr,"^",11)
    s Diagnose2=$p(PatInfoStr,"^",12)
    s Diagnose3=$p(PatInfoStr,"^",13)
    s Diagnose4=$p(PatInfoStr,"^",14)
    s Diagnose5=$p(PatInfoStr,"^",15)
    s Diagnose6=$p(PatInfoStr,"^",16)
    s SessHospDesc=$p(PatInfoStr,"^",17)
    s AdmReason=$p(PatInfoStr,"^",18)
    d ..QueryOEForPrintData(episodeID,.colDefine,"","N",StDate,EndDate)
	s tIndx="QueryOEForPrint_"_$j
    s PrescTitle="",Childweight=""
    s AdmDepDr=$p(^PAADM(episodeID),"^",4)
    s CTLocPrintTypeID=##class(web.DHCDocPrescript).GetCTLocPrintTypeID(AdmDepDr)
    if (CTLocPrintTypeID=1){
	    s rtn=##class(web.UDHCPrescript).SetGetChildWeight(episodeID,"")
	    if (rtn'="") {
		    s Childweight="体重:"_$p(rtn,"^",2)_"Kg"
		}
		s PrescTitle="[儿科]"
	}
	if (CTLocPrintTypeID=2){
		s PrescTitle="[急]"
	}
    s SessHospDesc=SessHospDesc_"处方笺" 
    i PrintType="CFZ" s zf="【正方】"
    e  s zf="【底方】" 
    s prescNoNum=0,CMprescNoNum=0
	w "["
	s orderType="" f   s orderType=$o(^CacheTemp(tIndx,orderType)) q:orderType=""  d
	.i orderType["R" d
	..s prescNo="" f  s prescNo=$o(^CacheTemp(tIndx,orderType,prescNo)) q:prescNo=""  d
	...q:("^"_selPrescNoStr_"^")'[("^"_prescNo_"")
	...s listRowId=prescNo_PrintType
	...q:(listFilter'="")&&(("^"_listFilter_"^")'[("^"_listRowId_"^"))
	...s BillType=##class(web.DHCDocPrescript).GetPrescType(prescNo) //费别
	...s IsCMPresType = ##Class(web.DHCDocPrescript).IsPrescType(prescNo) //是否是草药处方
	...s SerialNo=##class(User.PAQue1PrtSerial).GetPrtSerial(prescNo,"")
	...i SerialNo="",type="Print" s SerialNo=##class(User.PAQue1PrtSerial).InsertPrtSerial(prescNo,"",%session.Get("LOGON.USERID"))
	...i IsCMPresType="1" d //草药处方
	....s CMrowCount=0,CMprescSum=0
	....s CMprescNoNum=CMprescNoNum+1
	....s queid=$o(^PAQUE1(0,"PrescNo",prescNo,""))
	....s orderqty=$p(^PAQUE1(queid,"DHC"),"^",13) //一次用量
	....i (CMprescNoNum'=1)||(prescNoNum'=0) w ","
	....w "{"_"""checkTitle"""_":"_""""_prescNo_""""_","_"""listRowId"""_":"_""""_prescNo_PrintType_""""_","_"""data"""_":{"
	....w """PatLoc"""_":"_""""_AdmDep_""""_","_"""PatNo"""_":"_""""_PANo_""""_","_"""AdmDate"""_":"_""""_AdmDate_""""
	....w ","_"""PatName"""_":"_""""_Name_""""_","_"""PatSex"""_":"_""""_Sex_""""_","_"""PatAge"""_":"_""""_Age_""""
	....w ","_"""PatName"""_":"_""""_Name_""""_","_"""PatSex"""_":"_""""_Sex_""""_","_"""PatAge"""_":"_""""_Age_""""
	....w ","_"""PatICD"""_":"_""""_Diagnose1_"&nbsp"_Diagnose2_"&nbsp"_Diagnose3_"&nbsp"_Diagnose4_"&nbsp"_Diagnose5_"&nbsp"_Diagnose6_""""
	....w ","_"""PrescType"""_":"_""""_BillType_""""_","_"""ZDF"""_":"_""""_zf_""""
	....w ","_"""HosName"""_":"_""""_SessHospDesc_""""
	....w ","_"""PrescNo"""_":"_""""_prescNo_""""
	....w ","_"""PrescSerialNo"""_":"_""""_SerialNo_""""
	....w ","_"""MyList"""_":[]"
	....s IsARCOSFormula=##class(web.UDHCPrescript).IsPresnoFormula(prescNo) 
	....s BillType=##class(web.DHCDocPrescript).GetPrescType(prescNo) //费别
	....s Count="" f  s Count=$o(^CacheTemp(tIndx,orderType,prescNo,Count)) q:Count=""  d
	.....s CMrowCount=CMrowCount+1
	.....s list=^CacheTemp(tIndx,orderType,prescNo,Count)
	.....s OEItemID=$list(list,14)
	.....s OrderName=$list(list,5) //医嘱名称
	.....if (IsARCOSFormula="1") d
	......s ARCIMARcosRowId=$p($g(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),3)),"^",10)
	......i ##class(web.UDHCPrescript).IsARCOSFormula(ARCIMARcosRowId)'="1" s OrderName="*"_OrderName
	.....s DoseQty=$list(list,6)
	.....s DoseQtyDom=$list(list,7)
	.....s OrdNotes=$list(list,26) //备注
	.....s OrdPrice=$list(list,32) //单价
	.....s Duration=$list(list,13)
	.....s Instruc=$list(list,10)
	.....s CMprescSum=CMprescSum+$fn((OrdPrice*DoseQty),"",2)
	.....s txt1="txt"_CMrowCount_"1",txt2="txt"_CMrowCount_"2",txt3="txt"_CMrowCount_"3",txt4="txt"_CMrowCount_"4"
	
	.....s arcimid=$p($g(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),1)),"^",2)
	.....s MaxQty=$p($g(^ARCIM(+arcimid,$p(arcimid,"||",2),9)),"^",30) //单次最大剂量
	.....s dosage=$p($g(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),2)),"^",1) ;用药剂量
	.....if (dosage>MaxQty)&&(MaxQty>0) s OverQtyInfo=$p(##class(web.DHCOutPhCommon).GetOrdDoc(prescNo,""),"^",2)
	.....else  s OverQtyInfo=""
	
	.....w ","_""""_txt1_""""_":"_""""_OrderName_DoseQty_DoseQtyDom_""""
	.....w ","_""""_txt2_""""_":"_""""_OrdNotes_""""
	.....w ","_""""_txt4_""""_":"_""""_OverQtyInfo_""""
	.....i PrintType="CFD" w ","_""""_txt3_""""_":"_""""_$fn(OrdPrice,"",2)_"""" //*DoseQty
	....w ","_"""YFSM"""_":"_""""_"共"_Duration_"用法:"_Instruc_"&nbsp&nbsp"_"一次用量:"_orderqty_""""
	....w ","_"""TotalMoney"""_":"_""""_"一付金额:&nbsp&nbsp"_$fn(CMprescSum,"",2)_"元&nbsp&nbsp合计金额:"_$fn(CMprescSum*Duration,"",2)_"元"_""""
	....w ","_"""IsCMPresType"""_":"_""""_IsCMPresType_""""
	....w "}}"
	...e  d //西药处方
	....s rowCount=0,prescSum=0
	....s prescNoNum=prescNoNum+1
	....i (prescNoNum'=1)||(CMprescNoNum'=0) w ","
	....w "{"_"""checkTitle"""_":"_""""_prescNo_""""_","_"""listRowId"""_":"_""""_prescNo_PrintType_""""_","_"""data"""_":{"
	....w """PANo"""_":"_""""_PANo_""""_","_"""zf"""_":"_""""_zf_""""_","_"""PatientMedicareNo"""_":"_""""_PatientMedicareNo_""""
	....w ","_"""PrescNo"""_":"_""""_prescNo_""""_","_"""AdmDep"""_":"_""""_AdmDep_""""
	....w ","_"""AdmDate"""_":"_""""_AdmDate_""""_","_"""MRNo"""_":"_""""_MRNo_""""_","_"""Name"""_":"_""""_Name_""""
	....w ","_"""Sex"""_":"_""""_Sex_""""_","_"""Age"""_":"_""""_Age_""""_","_"""Company"""_":"_""""_Company_""""
	....w ","_"""Childweight"""_":"_""""_Childweight_""""_","_"""Diagnose1"""_":"_""""_Diagnose1_""""_","_"""Diagnose2"""_":"_""""_Diagnose2_""""
	....w ","_"""Diagnose3"""_":"_""""_Diagnose3_""""_","_"""Diagnose4"""_":"_""""_Diagnose4_""""
	....w ","_"""Diagnose5"""_":"_""""_Diagnose5_""""_","_"""Diagnose6"""_":"_""""_Diagnose6_""""
	....w ","_"""HosName"""_":"_""""_SessHospDesc_""""
	....w ","_"""PrescTitle"""_":"_""""_PrescTitle_""""
	....w ","_"""Childweight"""_":"_""""_Childweight_""""
	....//w ","_"""PrescSerialNo"""_":"_""""_"*"_prescNo_"*"_""""
	....w ","_"""PrescSerialNo"""_":"_""""_SerialNo_""""
    ....if prescNo["MJ" d
    .....s PrescSupplyInfo=##class(web.DHCDocCheckPoison).GetAgencyInfoByPrescNo(prescNo,episodeID)
    .....s PAPMIAgencyCredNo=$p(PrescSupplyInfo,"^",1)
    .....w ","_"""SupplyCard"""_":"_""""_"代办人身份证号:"_PAPMIAgencyCredNo_"""" 
	....w ","_"""MyList"""_":["
	....s MainSeqNo=1,prelist=""
	....s Count="" f  s Count=$o(^CacheTemp(tIndx,orderType,prescNo,Count)) q:Count=""  d
	.....s rowCount=rowCount+1
	.....s list=^CacheTemp(tIndx,orderType,prescNo,Count)
	.....s OEItemID=$list(list,14)
	.....s RecLoc=$list(list,33) //取药科室
	.....s OrderName=$list(list,5) //医嘱名称
	.....s Instr=$list(list,10)
	.....s DoseQty=$list(list,6)_""_$list(list,7)
	.....s Frequence=$list(list,9)
	.....;s OneOrdSum=$list(list,44)
	.....s OneOrdSum=$list(list,47)
	.....//s OneOrdSum=##class(web.DHCOPCommonFunLib).Trim(OneOrdSum)
	.....s OneOrdSum=$fn(OneOrdSum,"",2)
	.....s prescSum=prescSum+OneOrdSum
	.....s PackUOMDesc="",ArcimId=$P($G(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),1)),"^",2)
	.....s BillingUOMDR=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),8),"^",14)
	.....if BillingUOMDR'="" s PackUOMDesc=$p(^CT("UOM",BillingUOMDR),"^",2)
	.....s OrderRecDepRowid=$P($G(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),3)),"^",6) ;OEORI_RecDep_DR
	.....;协议单位
	.....s ProtocolPackUOMDR=$p($g(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),"DHC")),"^",13)
	.....i ProtocolPackUOMDR'="" d
	......s BillingUOMDR=ProtocolPackUOMDR
	......s PackUOMDesc=$p($g(^CT("UOM",BillingUOMDR)),"^",2)
	
	.....s PackQty=$j($list(list,16),"",2)_""_PackUOMDesc //$list(list,17)
	.....s ARCIMRowId=$list(list,54)
	.....s SeqNo=$list(list,56)
	.....s MasterId=$list(list,53)
	.....i MasterId'="",prelist'="" d
	......s PreSeqNo=$list(prelist,56)
	......i PreSeqNo["." s $list(list,56)=$p(PreSeqNo,".",1)_"."_($p(PreSeqNo,".",2)+1)
	......e  s $list(list,56)=PreSeqNo_".1"  
	.....e  d
	......s $list(list,56)=MainSeqNo,MainSeqNo=MainSeqNo+1
	.....s prelist=list
	.....s SeqNo=$list(list,56)
	
	.....s PoisonClass=""
	.....s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(ARCIMRowId)
	.....if PoisonRowid'="" set PoisonClass=$p($g(^PHCPO(PoisonRowid)),"^",1)
	.....s SkinTest=$list(list,69)
	.....s OrderName=SeqNo_" "_OrderName_" X "_PackQty_"</br>"_"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp用法:&nbsp每次"_DoseQty_"&nbsp"_Frequence_"&nbsp"_Instr_"&nbsp"_SkinTest
	.....i rowCount'=1 w ","
	.....w """"_OrderName_""""
	....w "],"
	....s docstr=##class(web.DHCOutPhCommon).GetOrdDoc(prescNo,"")
    ....s docctloc=$p(docstr,"^",1)
    ....s doctor=$p(docstr,"^",2)
	....w """UserAddName"""_":"_""""_doctor_""""_","_"""Sum"""_":"_""""_$fn(prescSum,"",2)_""""_","_"""RecLoc"""_":"_""""_RecLoc_""""
	....w ","_"""BillType"""_":"_""""_BillType_""""		
	....if (PoisonClass="DX")||(PoisonClass="MZ")||(PoisonClass="J1")  w ","_"""PoisonClass"""_":"_"""[麻 精一]"""
	....if (PoisonClass="J2") w ","_"""PoisonClass"""_":"_"""[精二]"""
	....w "}}"
	q "]"*/
}

ClassMethod GetSelPerscNoStr(selectedOEItemID As %String) As %String
{
	s selPrescNoStr=""
	Q:selectedOEItemID="" selPrescNoStr
	k SelPerscArr
	for i=1:1:$l(selectedOEItemID,"^"){
		s oneOEItemID=$p(selectedOEItemID,"^",i)
		s prescNo=$p(^OEORD(+oneOEItemID,"I",$p(oneOEItemID,"||",2),1),"^",14) 
		continue:prescNo=""
		s DMFlag=##Class(DHCDoc.OPDoc.TreatPrint).CheckPrescIsDMFlag(prescNo)
		s SelPerscArr(DMFlag,prescNo)=""
		
	}
	s Loop=""
	for {
		s Loop=$O(SelPerscArr(Loop),-1)
		q:(Loop="")
		s prescNo=""
		for {
			s prescNo=$O(SelPerscArr(Loop,prescNo))
			q:(prescNo="")
			i selPrescNoStr="" s selPrescNoStr=prescNo
			else  if ("^"_selPrescNoStr_"^")'[("^"_prescNo_"") s selPrescNoStr=selPrescNoStr_"^"_prescNo
		}
	}
	
	Q selPrescNoStr
}

ClassMethod GetPatBaseInfo(episodeID As %String) As %String
{
	s PatientID=$p(^PAADM(episodeID),"^",1)
	s PANo=$p(^PAPER(PatientID,"PAT",1),"^",1) //登记号
	s cfRowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,""),-1)
    s PatientMedicareNo="" //就诊卡号
    i cfRowId'="" s PatientMedicareNo=$p($g(^DHCCARD("CF",cfRowId)),"^",2)
	s AdmDepDr=$p(^PAADM(episodeID),"^",4)
	s AdmDep=$p(^CTLOC(AdmDepDr),"^",2)
	s AdmDepDesc=$p(AdmDep,"-",2)
	i AdmDepDesc'="" s AdmDep=AdmDepDesc //就诊科室
	s AdmDate=$p(^PAADM(episodeID),"^",6) //就诊日期
	s AdmDate=..%ZD(AdmDate)
	s MRNo=##class(web.DHCDocOrderCommon).GetMrNo("",PatientID,"O") //病历号 
	s Name=$p(^PAPER(PatientID,"ALL"),"^",1)
	s Sex=""
	s SexDr=$p(^PAPER(PatientID,"ALL"),"^",7)
	i SexDr'="" s Sex=$p($g(^CT("SEX",SexDr)),"^",2)
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(episodeID)
	s Age=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,episodeID,AdmHospitalId)
	s Company=$p(^PAPER(PatientID,"PER",4),"^",18) //工作单位 
	s Childweight=##class(web.DHCOutPhCommon).GetPatWeight(episodeID) //体重
	s MRADMID=$p(^PAADM(episodeID),"^",61) 
	s diagnodesc=##class(DHCDoc.Diagnos.Common).GetAdmDiagDesc(episodeID)	;..GetMRDiagnosDesc(MRADMID,";","") //##class(web.DHCMRDiagnos).GetMRDiagnosDesc(MRADMID,";")
	s Diagnose1="",Diagnose2="",Diagnose3="",Diagnose4="",Diagnose5="",Diagnose6=""
	i diagnodesc'="" d
	.s Diagnose1=$p(diagnodesc,";",1)
	.s Diagnose2=$p(diagnodesc,";",2) 
	.s Diagnose3=$p(diagnodesc,";",3) 
	.s Diagnose4=$p(diagnodesc,";",4)  
	.s Diagnose5=$p(diagnodesc,";",5)  
	.s Diagnose6=$p(diagnodesc,";",6) 
	Set SessLoc = $g(%session.Data("LOGON.CTLOCID")),SessHospDesc=""
    if SessLoc>0 d 
    .Set SessHosp = $p(^CTLOC(SessLoc),"^",22)
    .Set:SessHosp>0 SessHospDesc=$p(^CT("HOSP",SessHosp),"^",2)
    s AdmReason=$p($g(^PAADM(episodeID,1)),"^",7)
    s AdmReasonDesc=""
    s:AdmReason'="" AdmReasonDesc=$p($g(^PAC("ADMREA",AdmReason)),"^",2) 
    i SessHospDesc'="" s SessHospDesc=SessHospDesc
    s CardNo=##class(DHCDoc.OPDoc.AjaxInterface).GetPatCardNo(PatientID)
    s CurrentWard=""
    s CurrentWardDR=$p($g(^PAADM(episodeID)),"^",70)
    if (CurrentWardDR'=""){
		s CurrentWard=$P(^PAWARD(CurrentWardDR),"^",2)
	}
    
    s BedNo=""
    s PAADMBedDR=$p($g(^PAADM(episodeID)),"^",73)
    
    if (PAADMBedDR'=""){
    	s BedNo=$P($G(^PAWARD(+PAADMBedDR,"BED",$P(PAADMBedDR,"||",2))),"^",1)
    }
    s str=PANo_"^"_PatientMedicareNo_"^"_AdmDep_"^"_AdmDate_"^"_MRNo_"^"_Name_"^"_Sex_"^"_Age_"^"_Company_"^"_Childweight
    s str=str_"^"_Diagnose1_"^"_Diagnose2_"^"_Diagnose3_"^"_Diagnose4_"^"_Diagnose5_"^"_Diagnose6_"^"_SessHospDesc_"^"_AdmReasonDesc_"^"_CardNo_"^"_diagnodesc
    s str=str_"^"_CurrentWard_"^"_BedNo
    q str
}

ClassMethod GetEMRInfo()
{
	w "["
	s title="主诉",text="主诉内容主诉内容主诉内容主诉内容主诉内容主诉内容主诉内容主诉内容主诉内容主诉内容主诉内容主诉内容主诉内容主诉内容主诉内容主诉内容主诉内容主诉内容主诉内容主诉内容主诉内容主诉内容主诉内容主诉内容按规划法尔加艾尔符号温哥华"
	w "{"_"""title"""_":"_""""_title_""""_","_"""text"""_":"_""""_text_""""_"}"
	s title="现病史",text="现病史内容现病史内容现病史内容现病史内容现病史内容现病史内容现病史内容"
	w ",{"_"""title"""_":"_""""_title_""""_","_"""text"""_":"_""""_text_""""_"}"
	s title="既往史和其他病史",text="现病史内容现病史内容现病史内容现病史内容现病史内容现病史内容现病史内容"
	w ",{"_"""title"""_":"_""""_title_""""_","_"""text"""_":"_""""_text_""""_"}"
	s title="过敏史",text="现病史内容现病史内容现病史内容现病史内容现病史内容现病史内容现病史内容"
	w ",{"_"""title"""_":"_""""_title_""""_","_"""text"""_":"_""""_text_""""_"}"
	s title="医嘱信息",text="现病史内容现病史内容现病史内容现病史内容现病史内容现病史内容现病史内容"
	w ",{"_"""title"""_":"_""""_title_""""_","_"""text"""_":"_""""_text_""""_"}"
	q "]"
}

// 

ClassMethod CheckLocType(episodeID As %String) As %String
{
	s AdmDepDr=$p(^PAADM(episodeID),"^",4)
    s CTLocPrintTypeID=##class(web.DHCDocPrescript).GetCTLocPrintTypeID(AdmDepDr)
    q CTLocPrintTypeID
}

ClassMethod test()
{
  S str=""
	s ExecPlan=##class(web.DHCDocTransFusion).GetExecPlan("4040||10")
	for k=1:1:$l(ExecPlan,"#"){
		s Date=$p(ExecPlan,"#",k)
		continue:Date=""
		s week=$zd($zdh($p(Date,"^",2),3),10)
		s str=str_$p(Date,"^",1)_"("_week_")"_" "_"          "
	}
	w str
}

ClassMethod GetPrintDateRange(episodeID As %String) As %String
{
	//s StartDate=""
	s date=..%SysDate()
	s time=..%SysTime()
	s AdmDate=$P(^PAADM(episodeID),"^",6)
	s AdmType=$p(^PAADM(episodeID),"^",2)
	i AdmType="E" {
		s PatCurStat=##class(web.DHCADMVisitStat).GetStayStatus(episodeID)
	 	i " 1 2 "[(" "_PatCurStat_" ") Q ..%ZD(date-1)
 	}
 	Q ..%ZD(AdmDate)
	/*s AdmType=$p(^PAADM(episodeID),"^",2)
	i AdmType="E" {
		s LimitTime=..%GetConfig("EPAdmDayLimit")
		s LimitType=..%GetConfig("EPLimitType")
	}else{
		s LimitTime=..%GetConfig("OPAdmDayLimit")
		s LimitType=..%GetConfig("OPLimitType")
	}
	if (LimitType="Day"){
		i LimitTime="" s LimitTime=1
		s StartDate=..%SysDate()-LimitTime+1
	}
	if (LimitType="Hour"){
		if (LimitTime'=""){
			if (time-(LimitTime*3600))>0{
				s StartDate=date
			}else{
				s StartDate=$p(+$H-($ZABS(time-(LimitTime*3600))/(3600*24)),".",1)
			}
		}
	}
	i StartDate'="" s StartDate=..%ZD(StartDate)*/
	Q StartDate
}

// w ##class(DHCDoc.OPDoc.TreatPrint).GetPrescPrintDataTest(2101,"2001||3^2001||4","","CFZ","","","")

// w ##class(DHCDoc.OPDoc.TreatPrint).GetPrescPrintData(2101,"2001||6^2001||7^2001||8^2001||9^2001||10","","CFZ","","","")

ClassMethod GetPrescPrintData(episodeID, selectedOEItemID, listFilter = "", PrintType As %String = "", type As %String = "", StDate As %String, EndDate As %String)
{
	s ^Tempscl("GetPrescPrintData")=episodeID_","_selectedOEItemID_","_listFilter_","_PrintType
	s PrintDataAll=[]  //返回打印对象
	//包含毒麻与普通处方的排序，用于住院一键打印时提醒用户放毒麻专用纸
	s selPrescNoStr=..GetSelPerscNoStr(selectedOEItemID)
	if (selPrescNoStr=""){
		w PrintDataAll.%ToJSON()
		q ""
	}
	;2019-01-10改为调用药房组接口获取打印数据
	;w ##class(PHA.OP.COM.Print).PrescPrintData("O181125000001") //web.DHCOUTPHA.Common.Print
	i type="Print" s PrtType=""
	e  s PrtType="DISPPREVIEW"
	s tIndx="QueryOEForPrint_"_$j
	s PrescNoCount=1
	for i=1:1:$l(selPrescNoStr,"^"){
		s prescNo=$p(selPrescNoStr,"^",i)
		s listRowId=prescNo_PrintType
		continue:(listFilter'="")&&(("^"_listFilter_"^")'[("^"_listRowId_"^"))
		i PrintType="CFZ" s ZfFlag="正方"
		e  s ZfFlag="底方"
		k PrescOrdCongeriesArr
		s PrescData=##class(PHA.FACE.OUT.Com).GetPreDataForPrint(prescNo,ZfFlag,PrtType,StDate)
		continue:PrescData="{}"
		d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(PrescData,.PrescOrdCongeriesArr)
		s PrintTemp=$g(PrescOrdCongeriesArr("Templet")) //打印模板xml名称
		s templateId=##Class(web.DHCDocPrescript).GetXMLTemplateId(PrintTemp)
		//每页数据对象
		s onepage={}
		d onepage.%Set("checkTitle",prescNo)
		d onepage.%Set("listRowId",listRowId)
		d onepage.%Set("PrintTemp",PrintTemp)
		d onepage.%Set("templateId",templateId)
		// 页数据的data对象
		s dataobj = ##class(%DynamicObject).%New() 
		s dataobj.MyList= ##class(%DynamicArray).%New()
		s id=0
		for {
			s id=$o(PrescOrdCongeriesArr("Para",id))
			Q:id=""
			s Onedata=$g(PrescOrdCongeriesArr("Para",id))
			if (id["Diagnose") {
				s Onedata=##class(ext.util.String).Replace(Onedata,$c(10), "\n")
			}
			d dataobj.%Set(id,Onedata)
		}
		;获取处方背景色
		s PrescTitle=$g(PrescOrdCongeriesArr("Para","PrescTitle"))
		s PrescBgColor=..GetPrescBgColor(PrescTitle)
		d onepage.%Set("PrescBgColor",PrescBgColor)
		s IsCMPresType = ##Class(web.DHCDocPrescript).IsPrescType(prescNo) //是否是草药处方
		k orderlist
		s id=0
		for {
			s id=$o(PrescOrdCongeriesArr("List",id))
			Q:id=""
			if IsCMPresType="1" {
				s ItemData=$g(PrescOrdCongeriesArr("List",id))
				s CMPresColumnLen=$l(ItemData,"^")
				for j=1:1:CMPresColumnLen{
					s isub=$I(orderlist(0))
					s orderlist(isub)=##class(web.DHCDocUtil).EvalJSON($p(ItemData,"^",j))
				}
			}else{
				s isub=$I(orderlist(0))
				s orderlist(isub)=##class(web.DHCDocUtil).EvalJSON($g(PrescOrdCongeriesArr("List",id)))
			}
		}
		;数据转换
		k MyList
		//需要考虑分页问题
		//一页显示行数
		s PageOnLine=##class(DHCDoc.OPDoc.TreatPrint).GetXMLListPageRows(templateId,100)
		s ListNum=1 //数据列 
		if (IsCMPresType=1){
			s PageOnLine=PageOnLine*CMPresColumnLen
		}
		s PageNum=##class(web.DHCDocPrintTool).GetPrintList(.orderlist,PageOnLine,ListNum,0,.MyList)
		if (IsCMPresType=1){
			s pagedr=0
			for {
				s pagedr=$O(MyList(pagedr)) Q:pagedr=""
				s subdr=0,count=1,one={}
				for {
					s subdr=$O(MyList(pagedr,subdr)) Q:subdr=""
					s order=$G(MyList(pagedr,subdr))
					d one.%Set("listitem"_count,order)
					if (count#CMPresColumnLen)=0 {
						s count=1
						d dataobj.MyList.%Push(one)
						s one={}
					}else{
						s count=count+1
					}
				}
				d dataobj.MyList.%Push(one)
				s XMLName=PrintTemp
				s onepagedata=##class(web.DHCDocPrintTool).getXMLJSONObj(XMLName,dataobj)
			    s onepage.data=onepagedata
				s newdataobj = ##class(%DynamicObject).%New()
				s newdataobj=newdataobj.%FromJSON(onepage.%ToJSON()) 
				d PrintDataAll.%Push(newdataobj) //插入一页打印数据
				s dataobj.MyList=[]
			}
		}else{
			s pagedr=0
			for {
				s pagedr=$O(MyList(pagedr)) Q:pagedr=""
				s sum=0
				s subdr=0
				for {
					s subdr=$O(MyList(pagedr,subdr)) Q:subdr=""  
					s order=$G(MyList(pagedr,subdr))
					s one={"MyList":""}
					s one.MyList=order
					d dataobj.MyList.%Push(one)
				}
				//设置一页的data数据
				s XMLName=PrintTemp
				s onepagedata=##class(web.DHCDocPrintTool).getXMLJSONObj(XMLName,dataobj)
			    s onepage.data=onepagedata
				s newdataobj = ##class(%DynamicObject).%New()
				s newdataobj=newdataobj.%FromJSON(onepage.%ToJSON()) 
				d PrintDataAll.%Push(newdataobj) //插入一页打印数据
				s dataobj.MyList=[]
			}
		}
	}
	w PrintDataAll.%ToJSON()
	q ""
}

/// w ##class(DHCDoc.OPDoc.TreatPrint).GetDZDPrintData(3063,"2913||61","","DZD")
ClassMethod GetDZDPrintData(episodeID, selectedOEItemID, listFilter = "", PrintType As %String = "")
{
	s ^temoscl("GetDZDPrintData")=episodeID_","_selectedOEItemID_","_listFilter_","_PrintType
	s PrintDataAll=[]  //返回打印对象
	s listRowId=episodeID_"DZD"
	if ((listFilter'="")&&(("^"_listFilter_"^")'[("^"_listRowId_""))){
		w PrintDataAll.%ToJSON()
		q ""
	}
	if (selectedOEItemID=""){
		w PrintDataAll.%ToJSON()
		q ""
	}
	s OrdItemInfo=##class(web.UDHCPrescript).GetOrdItemInfoNew(episodeID,selectedOEItemID) //$g(%session.Data("LOGON.CTLOCID"))
	if (OrdItemInfo=""){
		w PrintDataAll.%ToJSON()
		q ""
	}
	s listRowId=episodeID_"DZD"
	s PatInfoStr=..GetPatBaseInfo(episodeID)
	s PANo=$p(PatInfoStr,"^",1)
	s PatientMedicareNo=$p(PatInfoStr,"^",2)
	s AdmDep=$p(PatInfoStr,"^",3)
	s AdmDate=$p(PatInfoStr,"^",4)
	s MRNo=$p(PatInfoStr,"^",5)
	s Name=$p(PatInfoStr,"^",6)
	s Sex=$p(PatInfoStr,"^",7)
	s Age=$p(PatInfoStr,"^",8)
	s Company=$p(PatInfoStr,"^",9)
	s Childweight=$p(PatInfoStr,"^",10)
    /*s Diagnose1=$p(PatInfoStr,"^",11)
    s Diagnose2=$p(PatInfoStr,"^",12)
    s Diagnose3=$p(PatInfoStr,"^",13)
    s Diagnose4=$p(PatInfoStr,"^",14)
    s Diagnose5=$p(PatInfoStr,"^",15)
    s Diagnose6=$p(PatInfoStr,"^",16)*/
    s Diagnose1="",Diagnose2=""
	k TmpPatDiagArr,TmpOnePatDiagArr
    s diagDesc=$p(PatInfoStr,"^",20) //所有诊断
    D ##Class(web.DHCAPPExaRepCom).splitString(diagDesc, "59", "10", .TmpPatDiagArr)  /// 拆分字符串
    s index=""
    for {
	    s index=$o(TmpPatDiagArr(index)) q:index=""
	    s TmpOnePatDiagArr("Diagnose"_(index+1))=$g(TmpPatDiagArr(index))
	}
	s Diagnose1=$g(TmpOnePatDiagArr("Diagnose1"))
	s Diagnose2=$g(TmpOnePatDiagArr("Diagnose2"))
    s SessHospDesc=$p(PatInfoStr,"^",17)
    s AdmReason=$p(PatInfoStr,"^",18)
	
	s SessHospDesc=SessHospDesc_"导诊单"
	s PrintTemp=..GetXMLName(PrintType)
	s templateId=##Class(web.DHCDocPrescript).GetXMLTemplateId(PrintTemp)
	//导诊单需要考虑分页问题
	//一页显示行数
	s PageOnLine=##class(DHCDoc.OPDoc.TreatPrint).GetXMLListPageRows(templateId,17)
	s onepage={}
	d onepage.%Set("checkTitle","")
	d onepage.%Set("listRowId",listRowId)
	d onepage.%Set("PrintTemp",PrintTemp)
	// 页数据的data对象
	s dataobj = ##class(%DynamicObject).%New() 
	s dataobj.MyList= ##class(%DynamicArray).%New()
	
	d dataobj.%Set("PANoBarCode","*"_PANo_"*")
	d dataobj.%Set("PANo",PANo)
	d dataobj.%Set("Name",Name)
	d dataobj.%Set("Sex",Sex)
	d dataobj.%Set("Age",Age)
	d dataobj.%Set("AdmDep",AdmDep)
	d dataobj.%Set("PANo",PANo)
	d dataobj.%Set("AdmDate",AdmDate)
	d dataobj.%Set("AdmReasonDesc",AdmReason)
	d dataobj.%Set("Diagnose1",Diagnose1)
	d dataobj.%Set("Diagnose2",Diagnose2)
	d dataobj.%Set("UserName",%session.Get("LOGON.USERNAME")) 
	d dataobj.%Set("HosName",SessHospDesc)
	k orderlist
	for i=1:1:$l(OrdItemInfo,$c(2)) {
		s OneOrdItemInfo=$p(OrdItemInfo,$c(2),i)
		continue:OneOrdItemInfo=""
		s MyList=$p(OneOrdItemInfo,"^",1)
		s Rec=""
		s Count=$p(OneOrdItemInfo,"^",3),No=$p(OneOrdItemInfo,"^",4)
		s Addr=$p(OneOrdItemInfo,"^",5)
		if (MyList>15){
			s isub=$I(orderlist(0))
			s orderlist(isub)=$e(MyList,0,15)_"^"_Rec_"^"_Count_"^"_No_"^"_Addr
			s isub=$I(orderlist(0))
			s orderlist(isub)=$e(MyList,15,$L(MyList))_"^^^^"
		}else{
			s isub=$I(orderlist(0))
			s orderlist(isub)=MyList_"^"_Rec_"^"_Count_"^"_No_"^"_Addr
			}
	}
	;数据转换
	k MyList
	s PageNum=##class(web.DHCDocPrintTool).GetPrintList(.orderlist,PageOnLine,1,0,.MyList)
	s pagedr=0
	for {
		s pagedr=$O(MyList(pagedr)) Q:pagedr=""  
		s PrintPage="第 "_pagedr_" 页  共 "_PageNum_" 页"
		s dataobj.PrintPage=PrintPage
		s subdr=0
		for {
			s subdr=$O(MyList(pagedr,subdr)) Q:subdr=""
			s order=$G(MyList(pagedr,subdr))
			s one={"MyList":"","Rec":"","Count":"","No":"","Addr":""}
			s one.MyList=$P(order,"^",1)
			s one.Rec=$P(order,"^",2)
			s one.Count=$P(order,"^",3)
			s one.No=$P(order,"^",4)
			s one.Addr=$P(order,"^",5)
			d dataobj.MyList.%Push(one)
		}
		//设置一页的data数据
		s XMLName=PrintTemp
		s onepagedata=##class(web.DHCDocPrintTool).getXMLJSONObj(XMLName,dataobj)
	    s onepage.data=onepagedata
		s newdataobj = ##class(%DynamicObject).%New()
		s newdataobj=newdataobj.%FromJSON(onepage.%ToJSON()) 
		d PrintDataAll.%Push(newdataobj) //插入一页打印数据
		s dataobj.MyList=[]
	}
	w PrintDataAll.%ToJSON()
	Q ""
}

/// w ##class(DHCDoc.OPDoc.TreatPrint).GetSYZSPrintData(2101,"2001||13^2001||15^2001||17^2001||18","","SYDO","","")
ClassMethod GetSYZSPrintData(episodeID, selectedOEItemID, listFilter = "", PrintType As %String = "", StDate, EndDate, type As %String = "")
{
	s listRowId=episodeID_PrintType //_PageSum
	s PrintDataAll=[]  //返回打印对象
	if ((listFilter'="")&&(("^"_listFilter_"^")'[("^"_listRowId_""))){
		w PrintDataAll.%ToJSON()
		Q ""
	}
	if (selectedOEItemID=""){
		w PrintDataAll.%ToJSON()
		Q ""
	}
	
	s PatInfoStr=..GetPatBaseInfo(episodeID)
	s PANo=$p(PatInfoStr,"^",1)
	s PatientMedicareNo=$p(PatInfoStr,"^",2)
	s AdmDep=$p(PatInfoStr,"^",3)
	s AdmDate=$p(PatInfoStr,"^",4)
	s MRNo=$p(PatInfoStr,"^",5)
	s Name=$p(PatInfoStr,"^",6)
	s Sex=$p(PatInfoStr,"^",7)
	s Age=$p(PatInfoStr,"^",8)
	s Company=$p(PatInfoStr,"^",9)
	s Childweight=$p(PatInfoStr,"^",10)
    s Diagnose1=$p(PatInfoStr,"^",11)
    s Diagnose2=$p(PatInfoStr,"^",12)
    s Diagnose3=$p(PatInfoStr,"^",13)
    s Diagnose4=$p(PatInfoStr,"^",14)
    s Diagnose5=$p(PatInfoStr,"^",15)
    s Diagnose6=$p(PatInfoStr,"^",16)
    s SessHospDesc=$p(PatInfoStr,"^",17)
    s AdmReason=$p(PatInfoStr,"^",18)
    s CardNo=$p(PatInfoStr,"^",19)
    s PrintTemp=..GetXMLName(PrintType)
    s templateId=##Class(web.DHCDocPrescript).GetXMLTemplateId(PrintTemp)
	//输液、注射单需要考虑分页问题
	//一页显示行数
	s PageOnLine=##class(DHCDoc.OPDoc.TreatPrint).GetXMLListPageRows(templateId,20)
	s onepage={}
	d onepage.%Set("checkTitle","")
	d onepage.%Set("listRowId",listRowId)
	d onepage.%Set("PrintTemp",PrintTemp)
	// 页数据的data对象
	s dataobj = ##class(%DynamicObject).%New() 
	s dataobj.MyList= ##class(%DynamicArray).%New()
	if (PrintType="SYDO") s SessHospDesc=SessHospDesc_"输液单"
	if (PrintType="ZSDO") s SessHospDesc=SessHospDesc_"注射单"
	if (PrintType="ZLDO") s SessHospDesc=SessHospDesc_"治疗单"
	d dataobj.%Set("HosName",SessHospDesc)
	d dataobj.%Set("RegNo",CardNo)
	d dataobj.%Set("CTLOCName",AdmDep)
	d dataobj.%Set("PANo",PANo)
	s PrintTime=""
	if (type="Print") s PrintTime=$zd(+$h,3)_" "_..%ZT(..%SysTime(),1)
	d dataobj.%Set("PrintTime",PrintTime)
	d dataobj.%Set("PName",Name)
	d dataobj.%Set("Sex",Sex)
	d dataobj.%Set("Age",Age)
	d dataobj.%Set("CaseHistoryNo",MRNo)
	d dataobj.%Set("DoctorName",%session.Get("LOGON.USERNAME"))
	
	k orderlist
	s Group=0,Count=0
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCDocTransFusion"
	set rs.QueryName="FindOrdItem"
	set sc=rs.Execute(episodeID, "@"_PrintType, "", "", StDate,EndDate)
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		s oeoriId=rs.Data("oeoriId")
		s ArcimDesc=rs.Data("arcimDesc")
		s DoseQtyUnit=rs.Data("doseQtyUnit")
		s PhcfrCode=rs.Data("phcfrCode")
		s PhcinDesc=rs.Data("phcinDesc")
		s notes=rs.Data("notes")
		s PlanSum=+##class(web.DHCDocTransFusion).GetExecSum(oeoriId)
		s OEORIDR=rs.Data("OEORIDR")
		s LastItemFlag=0
		if (selectedOEItemID'="")&&(("^"_selectedOEItemID_"^")'[("^"_oeoriId_"^")) continue
		if OEORIDR'=oeoriId {
			s ArcimDesc="_"_ArcimDesc
		}else{
			s Group=Group+1
			if (Group>1){
				s ExecStr=""
				s ExecPlan=##class(web.DHCDocTransFusion).GetExecPlan(LastMainOrd)
				for k=1:1:$l(ExecPlan,"#"){
					s DateStr=$p(ExecPlan,"#",k)
					continue:DateStr=""
					s week=$zd($zdh($p(DateStr,"^",2),3),10)
					s week=$case(week,0:"(日)",1:"(一)",2:"(二)",3:"(三)",4:"(四)",5:"(五)",6:"(六)")
					s Date=$p(DateStr,"^",1)
					i ExecStr="" s ExecStr=Date_week
					e  s ExecStr=ExecStr_"    "_Date_week  //&nbsp&nbsp&nbsp&nbsp
					if (k#5=0) {
						s isub=$I(orderlist(0))
						s orderlist(isub)=ExecStr
						s ExecStr=""
					}
				}
				if (ExecStr'="") {
					s isub=$I(orderlist(0))
					s orderlist(isub)=ExecStr
				}
			}
			s isub=$I(orderlist(0))
			s orderlist(isub)="------------------------------------第"_Group_"组------------------------------------"
			s LastMainOrd=oeoriId
		}
		s isub=$I(orderlist(0))
		s orderlist(isub)=ArcimDesc_"  "_DoseQtyUnit_"  "_PhcfrCode_"  "_PhcinDesc_"  "_notes_"  "_PlanSum_"次"
	}
	//取最后一组的执行记录
	if (LastMainOrd'="") {
		s ExecStr=""
		s ExecPlan=##class(web.DHCDocTransFusion).GetExecPlan(LastMainOrd)
		for k=1:1:$l(ExecPlan,"#"){
			s DateStr=$p(ExecPlan,"#",k)
			continue:DateStr=""
			s week=$zd($zdh($p(DateStr,"^",2),3),10)
			s week=$case(week,0:"(日)",1:"(一)",2:"(二)",3:"(三)",4:"(四)",5:"(五)",6:"(六)")
			s Date=$p(DateStr,"^",1)
			i ExecStr="" s ExecStr=Date_week
			e  s ExecStr=ExecStr_"    "_Date_week
			if (k#5=0) {
				s isub=$I(orderlist(0))
				s orderlist(isub)=ExecStr
				s ExecStr=""
			}
		}
		if (ExecStr'="") {
			s isub=$I(orderlist(0))
			s orderlist(isub)=ExecStr
		}
	}
	;数据转换
	k MyList
	s PageNum=##class(web.DHCDocPrintTool).GetPrintList(.orderlist,PageOnLine,1,0,.MyList)
	s pagedr=0
	for {  
		s pagedr=$O(MyList(pagedr)) Q:pagedr=""
		s PrintPage="第 "_pagedr_" 页  共 "_PageNum_" 页"
		s dataobj.PrintPage=PrintPage
		s subdr=0
		for {
			s subdr=$O(MyList(pagedr,subdr)) Q:subdr=""  
			s order=$G(MyList(pagedr,subdr))
			s one={"MyList":""}
			s one.MyList=order
			d dataobj.MyList.%Push(one)
		}
		//设置一页的data数据
		s XMLName=PrintTemp
		s onepagedata=##class(web.DHCDocPrintTool).getXMLJSONObj(XMLName,dataobj)
	    s onepage.data=onepagedata
		s newdataobj = ##class(%DynamicObject).%New()
		s newdataobj=newdataobj.%FromJSON(onepage.%ToJSON()) 
		d PrintDataAll.%Push(newdataobj) //插入一页打印数据
		s dataobj.MyList=[]
	}
	w PrintDataAll.%ToJSON()
	Q ""
}

/// 总览打印、检验检查申请单中的检验告知单统一使用该方法打印
ClassMethod GetJYDPrintData(episodeID, selectedOEItemID, listFilter = "", PrintType As %String = "", type As %String = "")
{
	s listRowId=episodeID_PrintType 
	s PrintDataAll=[]  //返回打印对象
	b ;1
	if ((listFilter'="")&&(("^"_listFilter_"^")'[("^"_listRowId_""))){
		w PrintDataAll.%ToJSON()
		Q ""
	}
	if (selectedOEItemID=""){
		w PrintDataAll.%ToJSON()
		Q ""
	}
	
	s PatInfoStr=..GetPatBaseInfo(episodeID)
	s PANo=$p(PatInfoStr,"^",1)
	s PatientMedicareNo=$p(PatInfoStr,"^",2)
	s AdmDep=$p(PatInfoStr,"^",3)
	s AdmDate=$p(PatInfoStr,"^",4)
	s MRNo=$p(PatInfoStr,"^",5)
	s Name=$p(PatInfoStr,"^",6)
	s Sex=$p(PatInfoStr,"^",7)
	s Age=$p(PatInfoStr,"^",8)
	s Company=$p(PatInfoStr,"^",9)
	s Childweight=$p(PatInfoStr,"^",10)
    s Diagnose1=$p(PatInfoStr,"^",11)
    s Diagnose2=$p(PatInfoStr,"^",12)
    s Diagnose3=$p(PatInfoStr,"^",13)
    s Diagnose4=$p(PatInfoStr,"^",14)
    s Diagnose5=$p(PatInfoStr,"^",15)
    s Diagnose6=$p(PatInfoStr,"^",16)
    s SessHospDesc=$p(PatInfoStr,"^",17)
    s AdmReason=$p(PatInfoStr,"^",18)	
	s Diagnose1=$p(PatInfoStr,"^",11)
    s Diagnose2=$p(PatInfoStr,"^",12)
    s Diagnose3=$p(PatInfoStr,"^",13)
    s Diagnose4=$p(PatInfoStr,"^",14)
    s Diagnose5=$p(PatInfoStr,"^",15)
    s Diagnose6=$p(PatInfoStr,"^",16)
    s MRDiagnos=Diagnose1_" "_Diagnose2_" "_Diagnose3_" "_Diagnose4_" "_Diagnose5_" "_Diagnose6
    s BedNo=$p(PatInfoStr,"^",22)
    s PrintTime=""
    if (type="Print") {
		s PrintTime=..%ZD(+$h)_" "_..%ZT(..%SysTime(),1)
	}
	s SessHospDesc=SessHospDesc_"检验告知单"
	s checkTitle="" //,listRowId=episodeID_PrintType
	
	s PrintTemp=..GetXMLName(PrintType)
	s templateId=##Class(web.DHCDocPrescript).GetXMLTemplateId(PrintTemp)
	//检验单需要考虑分页问题
	//一页显示行数
	s PageOnLine=##class(DHCDoc.OPDoc.TreatPrint).GetXMLListPageRows(templateId)
	s onepage={}
	d onepage.%Set("checkTitle","")
	d onepage.%Set("listRowId",listRowId)
	d onepage.%Set("PrintTemp",PrintTemp)
	d onepage.%Set("templateId",templateId)
	// 页数据的data对象
	s dataobj = ##class(%DynamicObject).%New() 
	s dataobj.MyList= ##class(%DynamicArray).%New()
	d dataobj.%Set("HosName",SessHospDesc)
	d dataobj.%Set("PANo",PANo)
	d dataobj.%Set("AdmDep",AdmDep)
	d dataobj.%Set("PrintDate",PrintTime)
	d dataobj.%Set("Name",Name)
	d dataobj.%Set("Sex",Sex)
	d dataobj.%Set("Age",Age)
	d dataobj.%Set("MRDiagnos",MRDiagnos)
	if (BedNo'="") d dataobj.%Set("BedNO","床号:"_BedNo)
	//d dataobj.%Set("AdmDoc",%session.Get("LOGON.USERNAME"))
	
	k orderlist
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.UDHCOrderItemLabPrint"
	set rs.QueryName="GetOrderItems"
	set sc=rs.Execute(episodeID,"")
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		s OrdRowid=rs.Data("Rowid")
		continue:(selectedOEItemID'="")&&(("^"_selectedOEItemID_"^")'[("^"_OrdRowid_"^"))
		s Doctor=""
		s DoctorID=$p($g(^OEORD(+OrdRowid,"I",$p(OrdRowid,"||",2),1)),"^",11)
		s:$g(DoctorID)'="" Doctor=$p(^CTPCP(DoctorID,1),"^",2) d dataobj.%Set("AdmDoc",Doctor)
		s OrderName=rs.Data("OrderName")_"("_$fn(rs.Data("Price"),"",2)_"元)"
		s spec=rs.Data("Spec")
		s LabEpisodeNo=rs.Data("LabEpisodeNo")
		s ProcessingNotes=rs.Data("ProcessingNotes")
		if (ProcessingNotes="")||(ProcessingNotes=" "){
			s ProcessingNotes=rs.Data("DepProcNotes")
		}
		s ProcessingNotes=$replace(ProcessingNotes,$C(1),"")
		s ProcessingNotes=$replace(ProcessingNotes,$C(2),"")
		s Container=rs.Data("Container")
		s RecDep=rs.Data("RecDep")
		s OrderNotifyClinician=rs.Data("OrderNotifyClinician")
		s isub=$I(orderlist(0))
		s orderlist(isub)=OrderName_"^"_spec_"^"_LabEpisodeNo_"^"_ProcessingNotes_"^"_Container_"^"_RecDep_"^"_OrderNotifyClinician
	}
	;数据转换
	k MyList
	s PageNum=##class(web.DHCDocPrintTool).GetPrintList(.orderlist,PageOnLine,1,0,.MyList)
	s pagedr=0
	for {  
		s pagedr=$O(MyList(pagedr)) Q:pagedr=""
		s PrintPage="第 "_pagedr_" 页  共 "_PageNum_" 页"
		s dataobj.PageNum=PrintPage
		s subdr=0
		for {
			s subdr=$O(MyList(pagedr,subdr)) Q:subdr=""  
			s order=$G(MyList(pagedr,subdr))
			s one={"MyList":"","OrderNmae":"","spec":"","No":"","note":"","Container":"","RepDep":"","OrderNotifyClinician":""}
			s one.OrderNmae=$p(order,"^",1)
			s one.spec=$p(order,"^",2)
			s one.No=$p(order,"^",3)
			s one.note=$p(order,"^",4)
			s one.Container=$p(order,"^",5)
			s one.RepDep=$p(order,"^",6)
			s one.OrderNotifyClinician=$p(order,"^",7)
			d dataobj.MyList.%Push(one)
		}
		//设置一页的data数据
		s XMLName=PrintTemp
		s onepagedata=##class(web.DHCDocPrintTool).getXMLJSONObj(XMLName,dataobj)
	    s onepage.data=onepagedata
		s newdataobj = ##class(%DynamicObject).%New()
		s newdataobj=newdataobj.%FromJSON(onepage.%ToJSON()) 
		d PrintDataAll.%Push(newdataobj) //插入一页打印数据
		s dataobj.MyList=[]
	}
	w PrintDataAll.%ToJSON()
	Q ""
}

/// w ##class(DHCDoc.OPDoc.TreatPrint).GetZLDPrintData("2284","2083||2^2083||3","","ZLDO","12/03/2020","","PreView")
ClassMethod GetZLDPrintData(episodeID, selectedOEItemID, listFilter = "", PrintType As %String = "", StDate, EndDate, type As %String = "")
{
	s listRowId=episodeID_PrintType
	s PrintDataAll=[]  //返回打印对象
	if ((listFilter'="")&&(("^"_listFilter_"^")'[("^"_listRowId_""))){
		w PrintDataAll.%ToJSON()
		Q ""
	}
	if (selectedOEItemID=""){
		w PrintDataAll.%ToJSON()
		Q ""
	}
	
	s PatInfoStr=..GetPatBaseInfo(episodeID)
	s PANo=$p(PatInfoStr,"^",1)
	s PatientMedicareNo=$p(PatInfoStr,"^",2)
	s AdmDep=$p(PatInfoStr,"^",3)
	s AdmDate=$p(PatInfoStr,"^",4)
	s MRNo=$p(PatInfoStr,"^",5)
	s Name=$p(PatInfoStr,"^",6)
	s Sex=$p(PatInfoStr,"^",7)
	s Age=$p(PatInfoStr,"^",8)
    s SessHospDesc=$p(PatInfoStr,"^",17)
    s CardNo=$p(PatInfoStr,"^",19)
    s Diagnose1="",Diagnose2=""
	k TmpPatDiagArr,TmpOnePatDiagArr
    s diagDesc=$p(PatInfoStr,"^",20) //所有诊断
    D ##Class(web.DHCAPPExaRepCom).splitString(diagDesc, "59", "10", .TmpPatDiagArr)  /// 拆分字符串
    s index=""
    for {
	    s index=$o(TmpPatDiagArr(index)) q:index=""
	    s TmpOnePatDiagArr("Diagnose"_(index+1))=$g(TmpPatDiagArr(index))
	}
	s Diagnose1=$g(TmpOnePatDiagArr("Diagnose1"))
	s Diagnose2=$g(TmpOnePatDiagArr("Diagnose2"))
	
	s SessHospDesc=SessHospDesc_"治疗单"
	
	s PrintTemp=..GetXMLName(PrintType)
	s templateId=##Class(web.DHCDocPrescript).GetXMLTemplateId(PrintTemp)
	//治疗单需要考虑分页问题
	//一页显示行数
	s PageOnLine=##class(DHCDoc.OPDoc.TreatPrint).GetXMLListPageRows(templateId,17)
	s onepage={}
	d onepage.%Set("checkTitle","")
	d onepage.%Set("listRowId",listRowId)
	d onepage.%Set("PrintTemp",PrintTemp)
	// 页数据的data对象
	s dataobj = ##class(%DynamicObject).%New() 
	s dataobj.MyList= ##class(%DynamicArray).%New()
	
	d dataobj.%Set("HosName",SessHospDesc)
	d dataobj.%Set("RegNo",CardNo)
	d dataobj.%Set("CTLOCName",AdmDep)
	d dataobj.%Set("PANo",PANo)
	s PrintTime=""
	if (type="Print") s PrintTime=$zd(+$h,3)_" "_..%ZT(..%SysTime(),1)
	d dataobj.%Set("PrintTime",PrintTime)
	d dataobj.%Set("PName",Name)
	d dataobj.%Set("Age",Age)
	d dataobj.%Set("CaseHistoryNo",MRNo)
	d dataobj.%Set("Diagnose1",Diagnose1)
	d dataobj.%Set("Diagnose2",Diagnose2)
	d dataobj.%Set("DoctorName",%session.Get("LOGON.USERNAME"))
	s SumFee=0
	s ProPatFlag=""
	k orderlist
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCDocTransFusion"
	set rs.QueryName="FindOrdItem"
	set sc=rs.Execute(episodeID, "@"_PrintType, "", "", StDate,EndDate)
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		s oeoriId=rs.Data("oeoriId")
		if (selectedOEItemID'="")&&(("^"_selectedOEItemID_"^")'[("^"_oeoriId_"^")) continue
		s ArcimDesc=rs.Data("arcimDesc")
		s DoseQtyUnit=rs.Data("doseQtyUnit")
		if DoseQtyUnit="" s DoseQtyUnit="-"
		s phOrdQtyUnit=rs.Data("phOrdQtyUnit")
		s price=rs.Data("price")
		s SumFee=SumFee+rs.Data("totalAmount")
		s phcfrCode=rs.Data("phcfrCode")
		if phcfrCode="" s phcfrCode="-"
		s Durat=rs.Data("Durat")
		s PPRowID=$p($G(^OEORD(+oeoriId,"I",$p(oeoriId,"||",2),"DHC")),"^",10)
		i PPRowID'="" s ProPatFlag="【科研】"
		if Durat="" s Durat="-"
		s isub=$I(orderlist(0))
		s orderlist(isub)=ArcimDesc_"^"_DoseQtyUnit_"^"_phOrdQtyUnit_"^"_price_"^"_phcfrCode_"^"_Durat
	}
	d dataobj.%Set("ProPatFlag",ProPatFlag)
	s SumFee=$fn(SumFee,"",2)_"元"
	d dataobj.%Set("SumFee",SumFee)
	;数据转换
	k MyList
	s PageNum=##class(web.DHCDocPrintTool).GetPrintList(.orderlist,PageOnLine,1,0,.MyList)
	s pagedr=0
	for {  
		s pagedr=$O(MyList(pagedr)) Q:pagedr=""
		s PrintPage="第 "_pagedr_" 页  共 "_PageNum_" 页"
		s dataobj.PrintPage=PrintPage
		s subdr=0
		s one={"MyList":"","ArcimDesc":"","doseQtyUnit":"","freq":"","induration":"","phOrdQtyUnit":"","price":""}
		s one.ArcimDesc="项目名称"
		s one.doseQtyUnit="单次数量"
		s one.phOrdQtyUnit="总量"
		s one.price="小计"
		s one.freq="频次"
		s one.induration="疗程"
		d dataobj.MyList.%Push(one)
		for {
			s subdr=$O(MyList(pagedr,subdr)) Q:subdr=""  
			s order=$G(MyList(pagedr,subdr))
			;s one={"MyList":"","ArcimDesc":"","doseQtyUnit":"","phOrdQtyUnit":"","price":"","ArcimDesc1":"","doseQtyUnit1":"","phOrdQtyUnit1":"","price1":""}
			s one={"MyList":"","ArcimDesc":"","doseQtyUnit":"","freq":"","induration":"","phOrdQtyUnit":"","price":""}
			s one.ArcimDesc=$p(order,"^",1)
			s one.doseQtyUnit=$p(order,"^",2)
			s one.phOrdQtyUnit=$p(order,"^",3)
			s one.price=$p(order,"^",4)
			s one.freq=$p(order,"^",5)
			s one.induration=$p(order,"^",6)
			d dataobj.MyList.%Push(one)
		}
		//设置一页的data数据
		s XMLName=PrintTemp
		s onepagedata=##class(web.DHCDocPrintTool).getXMLJSONObj(XMLName,dataobj)
	    s onepage.data=onepagedata
		s newdataobj = ##class(%DynamicObject).%New()
		s newdataobj=newdataobj.%FromJSON(onepage.%ToJSON()) 
		d PrintDataAll.%Push(newdataobj) //插入一页打印数据
		s dataobj.MyList=[]
	}
	w PrintDataAll.%ToJSON()
	Q ""
}

// w ##class(DHCDoc.OPDoc.TreatPrint).GetJCDMZPrintData(574,"530||3","","JCDMZ","PreView")

ClassMethod GetJCDMZPrintData(episodeID, selectedOEItemID, listFilter = "", PrintType As %String = "", type As %String = "") As %String
{
	s ^tempscl("GetJCDMZPrintData")=episodeID_","_selectedOEItemID_","_listFilter_","_PrintType_","_type
	s PrintDataAll=[]  //返回打印对象
	if (selectedOEItemID=""){
		w PrintDataAll.%ToJSON()
		Q ""
	}
	k TMPJCDMZData
	s OrdLen = $l(selectedOEItemID,"^")
	for i=1:1:OrdLen {
		s OrdItm = $p(selectedOEItemID,"^",i)
		s Params = ""
		s $p(Params,"^",3)=OrdItm
		s TraType=##Class(web.DHCAPPInterface).GetTraCatType(Params) /// P/E/L
		continue:TraType'="E"
		s ReqID=$o(^DHCAPREP(0,"OrdItem",OrdItm,""))
		continue:+ReqID=0
		s listRowId=episodeID_"JCDMZ"_ReqID
		continue:((listFilter'="")&&(("^"_listFilter_"^")'[("^"_listRowId_"")))
		s TMPJCDMZData("E",ReqID)=""
	}
	//每页数据对象
	s onepage={}
	// 页数据的data对象
	s dataobj = ##class(%DynamicObject).%New() 
	s dataobj.MyList= ##class(%DynamicArray).%New()
	s ReqID=""
	for {
		s ReqID = $o(TMPJCDMZData("E",ReqID)) q:ReqID=""
		k ServiceOrdCongeriesArr
		d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(##Class(web.DHCAPPPrintCom).GetExaReqPrintData(ReqID,""),.ServiceOrdCongeriesArr)
		s listRowId=episodeID_"JCDMZ"_ReqID
		s PrintTemp=$g(ServiceOrdCongeriesArr("PrintTemp")) //打印模板xml名称
		d onepage.%Set("checkTitle","")
		d onepage.%Set("listRowId",listRowId)
		d onepage.%Set("PrintTemp",PrintTemp)
		// 页数据的data对象
		s dataobj = ##class(%DynamicObject).%New() 
		s dataobj.MyList= ##class(%DynamicArray).%New()
		s id=0
		for {
			s id=$o(ServiceOrdCongeriesArr(id)) q:id="" 
			d dataobj.%Set(id,$g(ServiceOrdCongeriesArr(id)))
		}
		//设置一页的data数据
		s XMLName=PrintTemp
		s onepagedata=##class(web.DHCDocPrintTool).getXMLJSONObj(XMLName,dataobj)
	    s onepage.data=onepagedata
		s newdataobj = ##class(%DynamicObject).%New()
		s newdataobj=newdataobj.%FromJSON(onepage.%ToJSON()) 
		d PrintDataAll.%Push(newdataobj) //插入一页打印数据
		s dataobj.MyList=[]
		if type="Print" d ##Class(web.DHCAPPExaReport).UpdNurPrtInfo(ReqID,%session.Get("LOGON.USERID"))
	}
	w PrintDataAll.%ToJSON()
	Q ""
}

/// w ##class(DHCDoc.OPDoc.TreatPrint).GetBLDMZPrintData(3180,"2873||6","","BLDMZ","Print")
ClassMethod GetBLDMZPrintData(episodeID, selectedOEItemID, listFilter = "", PrintType As %String = "", type As %String = "") As %String
{
	s ^Tempscl("GetBLDMZPrintData")=episodeID_","_selectedOEItemID_","_listFilter_","_PrintType
	s PrintDataAll=[]  //返回打印对象
	if (selectedOEItemID=""){
		w PrintDataAll.%ToJSON()
		Q ""
	}
	k TMPJCDMZData
	s OrdLen = $l(selectedOEItemID,"^")
	f i=1:1:OrdLen  {
		s OrdItm = $p(selectedOEItemID,"^",i)
		s Params = ""
		s $p(Params,"^",3)=OrdItm
		s TraType=##Class(web.DHCAPPInterface).GetTraCatType(Params) /// P/E/L
		continue:TraType'="P"
		s ReqID=$o(^DHCAPPPM(0,"OrdItem",OrdItm,""))
		continue:+ReqID=0
		s listRowId=episodeID_"BLDMZ"_ReqID
		continue:((listFilter'="")&&(("^"_listFilter_"^")'[("^"_listRowId_"")))
		s TMPBLDMZData("P",ReqID)=""
	}
	//每页数据对象
	s onepage={}
	// 页数据的data对象
	s dataobj = ##class(%DynamicObject).%New() 
	s dataobj.MyList= ##class(%DynamicArray).%New()
	s ReqID=""
	for {
		s ReqID = $o(TMPBLDMZData("P",ReqID)) q:ReqID="" 
		s PisType=$p(^DHCAPPPM(ReqID),"^",20)    /// 申请单类型
		s PrintTemp=##Class(web.DHCDocAPPBL).GetPisPrintTemp(PisType,episodeID)
		s PisReqPara=##class(web.DHCDocAPPBL).GetPisPrintCon(ReqID)
		s PisReqList=##class(web.DHCDocAPPBL).GetPrintList(ReqID)
		//k ServiceOrdCongeriesArr
		//d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(##Class(web.DHCAPPPrintCom).GetPisPrintCon(ReqID),.ServiceOrdCongeriesArr)
		//s PrintTemp=$g(ServiceOrdCongeriesArr("PrintTemp")) //打印模板xml名称
		s listRowId=episodeID_"BLDMZ"_ReqID
		d onepage.%Set("checkTitle","")
		d onepage.%Set("listRowId",listRowId)
		d onepage.%Set("PrintTemp",PrintTemp)
		// 页数据的data对象
		s dataobj = ##class(%DynamicObject).%New() 
		s dataobj.MyList= ##class(%DynamicArray).%New()
		for ParaIndex=1:1:$l(PisReqPara,"^") {
			s onePisReqPara=$p(PisReqPara,"^",ParaIndex)
			s id=$p(onePisReqPara,$C(2),1)
			s text=$p(onePisReqPara,$C(2),2)
			d dataobj.%Set(id,text)
		}
		for Index=1:1:$l(PisReqList,$c(2)) {
			s listValueStr=$p(PisReqList,$C(2),Index)
			s one={"SpecSeqNo":"",
				   "SpecName":"",
				   "SpecPart":"",
				   "SpecNum":"",
				   "SpecLeaveTime":"",
				   "SpecFixedTime":""
			}
			s one.SpecSeqNo=$p(listValueStr,"^",1)
			s one.SpecName=$p(listValueStr,"^",2)
			s one.SpecPart=$p(listValueStr,"^",3)
			s one.SpecNum=$p(listValueStr,"^",4)
			s one.SpecLeaveTime=$p(listValueStr,"^",5)
			s one.SpecFixedTime=$p(listValueStr,"^",6)
			d dataobj.MyList.%Push(one)
		}
		/*s id=0
		for {
			s id=$o(ServiceOrdCongeriesArr(id)) q:id="" 
			d dataobj.%Set(id,$g(ServiceOrdCongeriesArr(id)))
		}*/
		//设置一页的data数据
		s XMLName=PrintTemp
		s onepagedata=##class(web.DHCDocPrintTool).getXMLJSONObj(XMLName,dataobj)
	    s onepage.data=onepagedata
		s newdataobj = ##class(%DynamicObject).%New()
		s newdataobj=newdataobj.%FromJSON(onepage.%ToJSON()) 
		d PrintDataAll.%Push(newdataobj) //插入一页打印数据
		s dataobj.MyList=[]
		//if (type="Print") {
			//知情同意书
			s PrintCall=##class(web.DHCDocAPPBL).GetPisPrintTemp(PisType,episodeID,1) 
			if (PrintCall'=""){
				d onepage.%Set("checkTitle","-知情同意书")
				d onepage.%Set("listRowId",listRowId)
				d onepage.%Set("PrintTemp",PrintCall)
				s onepagedata=##class(web.DHCDocPrintTool).getXMLJSONObj(PrintCall,dataobj)
				s onepage.data=onepagedata
				s newdataobj = ##class(%DynamicObject).%New()
				s newdataobj=newdataobj.%FromJSON(onepage.%ToJSON()) 
				d PrintDataAll.%Push(newdataobj)
			}
			//d ##class(web.DHCDocAPPBL).RecordPrintTime(ReqID)
		//}
	}
	w PrintDataAll.%ToJSON()
	Q ""
}

ClassMethod GetXMLName(PrintType As %String) As %String
{
	s XMLName=""
	Q:PrintType="" XMLName
	s id=0
	for {
		s id=$o(^User.DocCFTreatPrintMainInfoD(id)) Q:(id="")||(XMLName'="")
		s Data=$g(^User.DocCFTreatPrintMainInfoD(id))
		s Code=$lg(Data,28)
		continue:(Code'=PrintType)
		s XMLName=$lg(Data,17)
	}
	Q XMLName
}

/// 获取模板配置的mylist每页行数
/// w ##class(DHCDoc.OPDoc.TreatPrint).GetXMLListPageRows(13)
ClassMethod GetXMLListPageRows(TemplateId, DefaultPageRows As %String = "20") As %String
{
	//##class(web.DHCXMLPConfig).ReadXmlByID(reportID)
	s obj=##class(User.DHCXMLPConfig).%OpenId(TemplateId)
	s PageRows=DefaultPageRows
	While('obj.XPCFileData.AtEnd){
		s Data=obj.XPCFileData.Read()
		if (Data'["<ListData"){
			continue
		}
		s ListDataProperty=$P($P(Data,"<ListData ",2),">",1)
		if (ListDataProperty=""){
			continue
		}
		s PageRows=$P($P(ListDataProperty,"PageRows=""",2),"""",1)
	}
	d obj.%Close()
	q PageRows
}

/// 判断处方是否为毒麻处方
/// w ##Class(DHCDoc.OPDoc.TreatPrint).CheckPrescIsDMFlag("I191230000002")
ClassMethod CheckPrescIsDMFlag(PrescNo As %String) As %String
{
	s DMFlag="0"
	q:(PrescNo="") DMFlag
	s OEOrd=$O(^OEORD(0,"PrescNo",$$ALPHAUP^SSUTIL4(PrescNo),""))
	q:(OEOrd="") DMFlag
	s EpisodeID=$P(^OEORD(OEOrd),"^",1)
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	
	s Sub=0
    for {
        s Sub=$O(^OEORD(0,"PrescNo",$$ALPHAUP^SSUTIL4(PrescNo),OEOrd,Sub))
        q:Sub=""
        s ARCIMRowId=$p($g(^OEORD(OEOrd,"I",Sub,1)),"^",2)
        continue:(ARCIMRowId="")
        s TtemStat=$P($G(^OEORD(OEOrd,"I",Sub,1)),"^",13) ;OEORI_Billed
        s statcode=""
        i TtemStat'="" {
            s statcode=$p($g(^OEC("OSTAT",TtemStat)),"^",1)
        }
        continue:(statcode="")
        continue:(PAAdmType'="I")&&(statcode'="V")&&(statcode'="E")
        continue:(PAAdmType="I")&&(statcode'="V")&&(statcode'="E")&&(statcode'="D")
        s OrderPHPrescType=##Class(web.DHCDocOrderCommon).GetPHPrescTypeByItem(ARCIMRowId)
        continue:(OrderPHPrescType'=6)&&(OrderPHPrescType'=8)
        s DMFlag="1"
        q
    }
    q DMFlag
}

/// 获取毒麻处方处方数
/// w ##Class(DHCDoc.OPDoc.TreatPrint).GetDMPrescCount("413||37^413||38^413||39^413||36")
ClassMethod GetDMPrescCount(OrdItemList As %String, StDate As %String = "", EndDate As %String = "") As %String
{
	s StDate=..%ZDH(StDate)
	i StDate="" s StDate=..%SysDate()
	s EndDate=..%ZDH(EndDate)
	i EndDate="" s EndDate=..%SysDate()
	s DMPrescCount=0
	k PrescArr
	for i=1:1:$l(OrdItemList,"^") {
		s OrdItem=$p(OrdItemList,"^",i)
		s ord=+OrdItem,chl=$p(OrdItem,"||",2)
		s PrescNo=$P($G(^OEORD(ord,"I",chl,1)),"^",14)
		continue:PrescNo=""
		s PrescArr(PrescNo)=""
	}
	s PrescNo=""
	for {
		s PrescNo=$O(PrescArr(PrescNo))
		q:(PrescNo="")
		s DMFlag=##Class(DHCDoc.OPDoc.TreatPrint).CheckPrescIsDMFlag(PrescNo)
		if (DMFlag="1"){
			s ord=$o(^OEORD(0,"PrescNo",PrescNo,""))
			s chl=$o(^OEORD(0,"PrescNo",PrescNo,ord,""))
			s PriorityDr=$p($g(^OEORD(+ord,"I",chl,1)),"^",8)
			s LongPriorFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDr)
			if (LongPriorFlag=1) {
				s OrdStartDate=$p($g(^OEORD(+ord,"I",chl,1)),"^",9)
				for date=StDate:1:EndDate {
					if (date<OrdStartDate) continue
					if '$d(^OEORDi(0,"OrdItem",+ord,chl,date)) continue
					s DMPrescCount=DMPrescCount+1
				}
			}else{
				s DMPrescCount=DMPrescCount+1
			}
		}
	}
	q DMPrescCount
}

ClassMethod GetMRDiagnosDesc(MRAdmRowid As %String, DelimStr As %String, Type As %String = "") As %String
{
	q:MRAdmRowid="" ""
	s retval=""
	s i=0
	Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
	d obj.Execute(MRAdmRowid)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("MRDIAICDCodeDRDesc")
	.s Rowid=obj.Data("ID")
	.s CodeRowid=obj.Data("MRDIAICDCodeDR")
	.s MRDesc=obj.Data("MRDIADesc")
	.i CodeRowid'=""  d
	..s ZXFlag=$p($g(^MRC("ID",+CodeRowid)),"^",13) 	;证型标志
	..s ZYZDFlag=$p($g(^MRC("ID",+CodeRowid)),"^",15) 	;中医诊断标志
	..i ZYZDFlag'="Y" d
	...s DiagnosCat="西医"
	..e  i (ZYZDFlag="Y")&&(ZXFlag'="Y") d
	...s DiagnosCat="中医"
	..e  d
	...s DiagnosCat="证型"
	.e  d
	..//非ICD诊断
	..s Questionnaire=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",22)
	..s DiagnosCat=$s(Questionnaire=1:"西医",Questionnaire=2:"中医",Questionnaire=3:"证型",1:"")
	.i DiagnosCat="" s DiagnosCat="西医"
	.q:(Type="GC")&&(DiagnosCat="西医")  				;中医诊断
	.q:(Type="GX")&&(DiagnosCat'="西医")  				;西医诊断
	.q:(Type="ZX")&&(DiagnosCat'="证型")  				;证型  
	.i MRDesc'="",$LISTVALID(MRDesc) d
	..s MRDesc=$LG(MRDesc,1)
	..s MRDesc=##class(web.DHCDocUtil).Replace(MRDesc,"'", "&#39;")
	.i Desc="" d
	..s Desc=MRDesc
	.e  d
	..i MRDesc'="" s Desc=Desc_MRDesc
	.s DiagnosPrefix=$p($g(^MR(+Rowid,"DIA",$p(Rowid,"||",2),1)),"^",26)
 	.s DiagnosPrefix=##class(web.DHCDocUtil).Replace(DiagnosPrefix,"'", "&#39;")
 	.s Desc=DiagnosPrefix_Desc
	.//证型与诊断不要区分(需求810128)
	.i DiagnosCat'="证型"  d
	..s i=i+1
	..s Desc=i_"."_Desc
	.i retval="" d
	..s retval=Desc
	.e  d
	..s retval=$s(DiagnosCat="证型":retval_" "_Desc,1:retval_DelimStr_Desc)
	.
	d obj.Close()
	Q retval
}

/// w ##class(DHCDoc.OPDoc.TreatPrint).GetOrdMenuOEChkMap("2885||2")
ClassMethod GetOrdMenuOEChkMap(OEORIRowId As %String, OETypeDesc As %String) As %String
{
	s Adm=$p(^OEORD(+OEORIRowId),"^",1)
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(Adm)
	s LgParams=..GetSessionStr()
	s DisposeStatCode=##class(web.DHCEMNurExe).updateDisposeStatCode(+OEORIRowId,$p(OEORIRowId,"||",2),"")
	s QueryType=##Class(web.DHCEMInterfaceCom).GetFormExecCode(OETypeDesc,AdmHospitalId)
	s CheckCon=##class(web.DHCEMNurExe).CheckCon(LgParams,QueryType,+OEORIRowId,$p(OEORIRowId,"||",2),DisposeStatCode,"false","true")
	Q CheckCon
}

ClassMethod GetSessionStr() As %String
{
	s LgHospId=%session.Get("LOGON.HOSPID")
	s LgLocId=%session.Get("LOGON.CTLOCID")
	s LgGroupId=%session.Get("LOGON.GROUPID")
	s LgUserId=%session.Get("LOGON.USERID")
	s LgParams=LgHospId_"^"_LgLocId_"^"_LgGroupId_"^"_LgUserId
	Q LgParams
}

/// 获取处方底色
/// 急诊处方印刷用纸为淡黄色，右上角标注“急诊”
/// 儿科处方印刷用纸为淡绿色，右上角标注 “儿科“
/// 麻醉药品和第一类精神药品处方印刷用纸为淡红色，右上角标注“麻、精一”
/// 第二类精神药品处方印刷用纸为白色，右上角标注“精二”
ClassMethod GetPrescBgColor(PrescTitle) As %String
{
	s BgColor="#FFFFFF"
	Q:PrescTitle["急" "#dec674"
	Q:PrescTitle["儿" "#84bf96"
	Q:PrescTitle["麻" "#FF7373"
	Q BgColor
}

/***
  **Description      :获取显示在打印总览页面的病历信息
  **Author           :zhouc
  **Time             :2022/07/22
  **debugger         :w ##Class(DHCDoc.OPDoc.TreatPrint).GetShowEMInfo(1692)
  **Parameter        :EpisodeID As %String 就诊号 ;InstanceID 病历实例ID
  **Returns          :
***/
ClassMethod GetShowEMInfo(EpisodeID As %String, InstanceID As %String)
{
    s ShowNodes="初步诊断^医嘱项目"
    
	s EMRInfo=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.emr.ScatterDataForOPToMedic",EpisodeID,InstanceID)
	q:EMRInfo="" EMRInfo
    s EMRInfoJson = ##class(%DynamicAbstractObject).%FromJSON(EMRInfo)
    s ShowEMRInfoArr=##class(%DynamicArray).%New()
    
    s EMRInfoLen=EMRInfoJson.%Size()
    f EMRNodeInd=0:1:(EMRInfoLen-1){
	    s EMRItem=EMRInfoJson.%Get(EMRNodeInd)
	    continue:'$ISOBJECT(EMRItem)
	    s EMRItemDesc=EMRItem.Name
	    s EMRItemVal=EMRItem.Text
		s ShowItemObj=##class(%DynamicObject).%New()
		s ShowItemObj.Name=EMRItemDesc
		s ShowItemObj.Text=EMRItemVal
		s ShowFlag="0"
	    f ShowNodeInd=1:1:$l(ShowNodes,"^"){
		    s ShowNode=$p(ShowNodes,"^",ShowNodeInd)
			continue:EMRItemDesc'[ShowNode
			s ShowFlag="1"
			q
		}
		s ShowItemObj.ShowFlag=ShowFlag
		d ShowEMRInfoArr.%Push(ShowItemObj)
		k ShowItemObj
	}
    
    s ShowEMRInfoJson=ShowEMRInfoArr.%ToJSON()
    k ShowEMRInfoArr
    s ShowEMRInfoJson=$replace(ShowEMRInfoJson,"\n",$c(10))
	q ShowEMRInfoJson
}

}
