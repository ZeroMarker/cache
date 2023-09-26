Class DHCEWELL.DHCEPRInterFaceXZZX Extends %RegisteredObject
{

/// /d ##class(%ResultSet).RunQuery("DHCEWELL.DHCEPRInterFaceXZZX","MROperationRecord",1)
/// 徐州中心手术明细
Query MROperationRecord(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "MEDOPID,CARDTYPE,CARDNO,HPSNO,MRNO,OPERCODE,OPERNAME,OPERNO,OPERDATE,NNIS,IFELESUR,OPDOCIDCARD,OPDOCNAME,FIRASSINAME,SECASSINAME,WOUNDGRADE,WOUNDTYPE,ANESMETHODCODE,ANESMETHODNAME,ANESIDCARD,ANESNAME,ORGANCODE,ORGANNAME,DPTCODE,DPTNAME,RCDDT,POFDT") [ SqlName = MR_OperationRecord, SqlProc ]
{
}

ClassMethod MROperationRecordExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	/*
	MEDOPID =   //病案中手术唯一ID号
	CARDTYPE =   //患者就诊卡证类型
	CARDNO =   //患者就诊卡证号码
	HPSNO =   //住院号
	MRNO =   //病案号
	OPERCODE =   //手术及操作编码
	OPERNAME =   //手术及操作名称
	OPERNO =   //手术及操作序号
	OPERDATE =   //手术及操作日期
	NNIS =   //手术级别
	IFELESUR =   //手术类别
	OPDOCIDCARD =   //手术医生（或操作者）身份证号码
	OPDOCNAME =   //手术医生（或操作者）姓名
	FIRASSINAME =   //第一助手姓名
	SECASSINAME =   //第二助手姓名
	WOUNDGRADE =   //手术切口分类代码
	WOUNDTYPE =   //手术切口愈合等级代码
	ANESMETHODCODE =   //麻醉方法代码
	ANESMETHODNAME =   //麻醉方法名称
	ANESIDCARD =   //麻醉医师身份证号
	ANESNAME =   //麻醉医师姓名
	ORGANCODE =   //手术医疗机构编号
	ORGANNAME =   //手术医疗机构名称
	DPTCODE =   //手术科室编码
	DPTNAME =   //手术科室名称
	RCDDT =   //记录日期时间
	POFDT =   //归录日期时间
	--------------
	*/
	s (MEDOPID,CARDTYPE,CARDNO,HPSNO,MRNO,OPERCODE,OPERNAME,OPERNO,OPERDATE,NNIS,IFELESUR,OPDOCIDCARD,OPDOCNAME,FIRASSINAME,SECASSINAME,WOUNDGRADE,WOUNDTYPE,ANESMETHODCODE,ANESMETHODNAME,ANESIDCARD,ANESNAME,ORGANCODE,ORGANNAME,DPTCODE,DPTNAME,RCDDT,POFDT)=""

	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	i EndDate<StartDate Set qHandle=$lb(0,repid,0)	Quit $$$OK
	
	s tmpEpisodeID=""
	
	f tmpdate=+StartDate:1:+EndDate
	{
		s tmpEpisodeID=""
		for {
		s tmpEpisodeID= $o(^PAADMi("DischDate",tmpdate,tmpEpisodeID))
		q:(tmpEpisodeID = "")
		
		s MEDOPID = ""  //病案中手术唯一ID号
		s CARDTYPE = "01"  //患者就诊卡证类型
		s strpaid = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(tmpEpisodeID)
		s CARDNO = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(strpaid) //患者就诊卡证号码
		s HPSNO = tmpEpisodeID //住院号
		s MRNO =  CARDNO //病案号
		
		s strRe  = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_tmpEpisodeID," "_"CG37"))
		continue:(strRe = "")
		//s arr=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,"HDSD00.11")
		s arr=##Class(EPRservice.BOScatterData).GetStandDataByGlossaryCategory(tmpEpisodeID,"HDSD00.11")
		for i=1:1:8 {
				
				s OPERCODE=$s(i=1:arr.GetAt("HDSD00.11.089"),i=2:arr.GetAt("HDSD00.11.410"),i=3:arr.GetAt("HDSD00.11.425"),i=4:arr.GetAt("HDSD00.11.440"),i=5:arr.GetAt("HDSD00.11.455"),i=6:arr.GetAt("HDSD00.11.470"),i=7:arr.GetAt("HDSD00.11.485"),i=8:arr.GetAt("HDSD00.11.500"),1:"") //手术及操作编码
				s OPERNAME=$s(i=1:arr.GetAt("HDSD00.11.090"),i=2:arr.GetAt("HDSD00.11.414"),i=3:arr.GetAt("HDSD00.11.429"),i=4:arr.GetAt("HDSD00.11.444"),i=5:arr.GetAt("HDSD00.11.459"),i=6:arr.GetAt("HDSD00.11.474"),i=7:arr.GetAt("HDSD00.11.489"),i=8:arr.GetAt("HDSD00.11.504"),1:"") //手术及操作名称
				continue:((SSCZBM="")&&(SSCZMC=""))
				s OPERNO = ""  //手术及操作序号
				s OPERDATE=$s(i=1:arr.GetAt("HDSD00.11.091"),i=2:arr.GetAt("HDSD00.11.411"),i=3:arr.GetAt("HDSD00.11.426"),i=4:arr.GetAt("HDSD00.11.441"),i=5:arr.GetAt("HDSD00.11.456"),i=6:arr.GetAt("HDSD00.11.471"),i=7:arr.GetAt("HDSD00.11.486"),i=8:arr.GetAt("HDSD00.11.501"),1:"")
				s OPERDATE=$p(SSKSSJ,"年",1)_$p($p(SSKSSJ,"年",2),"月",1)_$p($p(SSKSSJ,"月",2),"日",1) //手术及操作日期
				s NNIS=$s(i=1:arr.GetAt("HDSD00.11.092"),i=2:arr.GetAt("HDSD00.11.413"),i=3:arr.GetAt("HDSD00.11.428"),i=4:arr.GetAt("HDSD00.11.443"),i=5:arr.GetAt("HDSD00.11.458"),i=6:arr.GetAt("HDSD00.11.473"),i=7:arr.GetAt("HDSD00.11.488"),i=8:arr.GetAt("HDSD00.11.503"),1:"")
				s NNIS=$s(SSJB="一级":1,SSJB="二级":2,SSJB="三级":3,SSJB="四级":4) //手术级别
				s IFELESUR ="2"  //手术类别
				
				//s OPDOCIDCARD=$s(i=1:arr.GetAt("HDSD00.11.407"),i=2:arr.GetAt("HDSD00.11.415"),i=3:arr.GetAt("HDSD00.11.430"),i=4:arr.GetAt("HDSD00.11.445"),i=5:arr.GetAt("HDSD00.11.460"),i=6:arr.GetAt("HDSD00.11.475"),i=7:arr.GetAt("HDSD00.11.490"),i=8:arr.GetAt("HDSD00.11.505"),1:"")
				s OPDOCIDCARD = "" //手术医生（或操作者）身份证号码
				s OPDOCNAME=$s(i=1:arr.GetAt("HDSD00.11.094"),i=2:arr.GetAt("HDSD00.11.416"),i=3:arr.GetAt("HDSD00.11.431"),i=4:arr.GetAt("HDSD00.11.446"),i=5:arr.GetAt("HDSD00.11.461"),i=6:arr.GetAt("HDSD00.11.476"),i=7:arr.GetAt("HDSD00.11.491"),i=8:arr.GetAt("HDSD00.11.506"),1:"") //手术医生（或操作者）姓名
			
				//s SSYSZ1GH=$s(i=1:arr.GetAt("HDSD00.11.408"),i=2:arr.GetAt("HDSD00.11.417"),i=3:arr.GetAt("HDSD00.11.432"),i=4:arr.GetAt("HDSD00.11.447"),i=5:arr.GetAt("HDSD00.11.462"),i=6:arr.GetAt("HDSD00.11.477"),i=7:arr.GetAt("HDSD00.11.492"),i=8:arr.GetAt("HDSD00.11.507"),1:"")
				s FIRASSINAME=$s(i=1:arr.GetAt("HDSD00.11.001"),i=2:arr.GetAt("HDSD00.11.418"),i=3:arr.GetAt("HDSD00.11.433"),i=4:arr.GetAt("HDSD00.11.448"),i=5:arr.GetAt("HDSD00.11.463"),i=6:arr.GetAt("HDSD00.11.478"),i=7:arr.GetAt("HDSD00.11.493"),i=8:arr.GetAt("HDSD00.11.508"),1:"") //第一助手姓名
			
				//s SSYSZ2GH=$s(i=1:arr.GetAt("HDSD00.11.409"),i=2:arr.GetAt("HDSD00.11.419"),i=3:arr.GetAt("HDSD00.11.434"),i=4:arr.GetAt("HDSD00.11.449"),i=5:arr.GetAt("HDSD00.11.464"),i=6:arr.GetAt("HDSD00.11.479"),i=7:arr.GetAt("HDSD00.11.494"),i=8:arr.GetAt("HDSD00.11.509"),1:"")
				s SSYSZ2XM=$s(i=1:arr.GetAt("HDSD00.11.002"),i=2:arr.GetAt("HDSD00.11.420"),i=3:arr.GetAt("HDSD00.11.435"),i=4:arr.GetAt("HDSD00.11.450"),i=5:arr.GetAt("HDSD00.11.465"),i=6:arr.GetAt("HDSD00.11.480"),i=7:arr.GetAt("HDSD00.11.495"),i=8:arr.GetAt("HDSD00.11.510"),1:"") //第二助手姓名
			
				
				s WOUNDGRADE = $s(i=1:arr.GetAt("HDSD00.11.093"),i=2:arr.GetAt("HDSD00.11.421"),i=3:arr.GetAt("HDSD00.11.436"),i=4:arr.GetAt("HDSD00.11.451"),i=5:arr.GetAt("HDSD00.11.466"),i=6:arr.GetAt("HDSD00.11.481"),i=7:arr.GetAt("HDSD00.11.496"),i=8:arr.GetAt("HDSD00.11.511"),1:"") //手术切口分类代码
				s WOUNDTYPE = $s(i=1:arr.GetAt("HDSD00.11.082"),i=2:arr.GetAt("HDSD00.11.422"),i=3:arr.GetAt("HDSD00.11.437"),i=4:arr.GetAt("HDSD00.11.452"),i=5:arr.GetAt("HDSD00.11.467"),i=6:arr.GetAt("HDSD00.11.482"),i=7:arr.GetAt("HDSD00.11.497"),i=8:arr.GetAt("HDSD00.11.512"),1:"") //手术切口愈合等级代码
				
				s ANESMETHODCODE=$s(i=1:arr.GetAt("HDSD00.11.073"),i=2:arr.GetAt("HDSD00.11.423"),i=3:arr.GetAt("HDSD00.11.438"),i=4:arr.GetAt("HDSD00.11.453"),i=5:arr.GetAt("HDSD00.11.468"),i=6:arr.GetAt("HDSD00.11.483"),i=7:arr.GetAt("HDSD00.11.498"),i=8:arr.GetAt("HDSD00.11.513"),1:"") //麻醉方法代码
				/*
				1	全身麻醉
				11	吸入麻醉
				12	静脉麻醉
				13	基础麻醉
				2	椎管内麻醉
				21	蛛网膜下腔阻滞麻醉
				22	硬脊椎外腔阻滞麻醉
				3	局部麻醉
				31	神经丛阻滞麻醉
				32	神经节阻滞麻醉
				33	神经阻滞麻醉
				34	区域阻滞麻醉
				35	局部浸润麻醉
				36	表面麻醉
				4	复合麻醉
				41	静吸复合全麻
				42	针药复合麻醉
				43	神经丛与硬膜外阻滞复合麻醉
				44	全麻复合全身降温
				45	全麻复合控制性降压
				9	其他麻醉方法
				*/
				s ANESMETHODNAME=$s(ANESMETHODCODE="全身麻醉":1,ANESMETHODCODE="吸入麻醉 （气管内插管、喉罩、面罩）":11,ANESMETHODCODE="静脉麻醉 （全凭静脉麻醉）":12,ANESMETHODCODE="静吸复合麻醉":12,ANESMETHODCODE="基础麻醉 （直肠注入、肌肉注射）":13,1:ANESMETHODNAME)
				s ANESMETHODNAME=$s(ANESMETHODCODE="椎管内麻醉":2,ANESMETHODCODE="蛛网膜下腔阻滞麻醉":21,ANESMETHODCODE="硬脊椎外腔阻滞麻醉":22,1:ANESMETHODNAME)
				s ANESMETHODNAME=$s(ANESMETHODCODE="局部麻醉":3,ANESMETHODCODE="神经丛阻滞麻醉":31,ANESMETHODCODE="神经节阻滞麻醉":32,ANESMETHODCODE="神经阻滞麻醉":33,ANESMETHODCODE="局部阻滞麻醉":34,ANESMETHODCODE="局部浸润麻醉":35,ANESMETHODCODE="表面麻醉":36,1:ANESMETHODNAME)
				s ANESMETHODNAME=$s(ANESMETHODCODE="复合麻醉":4,ANESMETHODCODE="静吸复合全麻":41,ANESMETHODCODE="针药复合麻醉":42,ANESMETHODCODE="神经丛与硬膜外阻滞复合麻醉":43,ANESMETHODCODE="全麻复合全身降温":44,ANESMETHODCODE="全麻复合控制性降压":45,1:ANESMETHODNAME) //麻醉方法名称
				s ANESMETHODNAME=$s(ANESMETHODCODE="其他":9,+$G(ANESMETHODCODE)>0:ANESMETHODCODE,1:9)
				
				s ANESIDCARD = "" //麻醉医师身份证号
				s ANESNAME=$s(i=1:arr.GetAt("HDSD00.11.074"),i=2:arr.GetAt("HDSD00.11.424"),i=3:arr.GetAt("HDSD00.11.439"),i=4:arr.GetAt("HDSD00.11.454"),i=5:arr.GetAt("HDSD00.11.469"),i=6:arr.GetAt("HDSD00.11.484"),i=7:arr.GetAt("HDSD00.11.499"),i=8:arr.GetAt("HDSD00.11.514"),1:"") //麻醉医师姓名
				s ORGANCODE = ""  //手术医疗机构编号
				s ORGANNAME = ""  //手术医疗机构名称
				s DPTCODE = ""  //手术科室编码
				s DPTNAME = ""  //手术科室名称
				s RCDDT = OPERDATE  //记录日期时间
				s POFDT = OPERDATE  //归录日期时间
				set ^CacheTemp(repid, ind) = $LB(MEDOPID,CARDTYPE,CARDNO,HPSNO,MRNO,OPERCODE,OPERNAME,OPERNO,OPERDATE,NNIS,IFELESUR,OPDOCIDCARD,OPDOCNAME,FIRASSINAME,SECASSINAME,WOUNDGRADE,WOUNDTYPE,ANESMETHODCODE,ANESMETHODNAME,ANESIDCARD,ANESNAME,ORGANCODE,ORGANNAME,DPTCODE,DPTNAME,RCDDT,POFDT)
				set ind = ind + 1
		
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod MROperationRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MROperationRecordExecute ]
{
	
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod MROperationRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MROperationRecordExecute ]
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

/// /d ##class(%ResultSet).RunQuery("web.DHCEPRInterfaceQYHY","OutHospitalRecord","2015-12-05","2015-12-05")
/// 徐州中心出院小结
Query OutHospitalRecord(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "OUTHOSID,CARDTYPE,CARDNO,NAME,SEX,BIRTHDAY,HPSNO,MRNO,OHRECDREC,IHDDISCODE,IHDDISNAME,IHDDISCODE1,IHDDISNAME1,IHDDISCODE2,IHDDISNAME2,IHDDISCODE3,IHDDISNAME3,IHDDISCODE4,IHDDISNAME4,IHDDISCODE5,IHDDISNAME5,IHDDISDES,INHPDT,ISOPERATION,OPERATIONCODE,OPERATIONNAME,OPERATIONCODE,OPERATIONNAME,OPERATIONCODE,OPERATIONNAME,OPERATIONCODE,OPERATIONNAME,OPERATIONCODE,OPERATIONNAME,OPERATIONCODE,OPERATIONNAME,OPERATIONDES,OPERATIONDT,OHDDISCODE,OHDDISNAME,OHDDISCODE1,OHDDISNAME1,OHDDISCODE2,OHDDISNAME2,OHDDISCODE3,OHDDISNAME3,OHDDISCODE4,OHDDISNAME4,OHDDISCODE5,OHDDISNAME5,OHDDISCODE6,OHDDISNAME6,OHDDISCODE7,OHDDISNAME7,OHDDISCODE8,OHDDISNAME8,OHDDISCODE9,OHDDISNAME9,OHDDISDES,OUTHPDT,INHPILLCON,HPCURPRO,WOUNDTYPE,OUTHPILLCON,OUTHPODR,DIECAUSE,IFAUTOPSY,ORGANCODE,ORGANNAME,OHDPTCODE,OHDPTNAME,MAJDOCNAME,DOCIDCARD,DOCNAME,RCDDT,POFDT") [ SqlName = OutHospitalRecord, SqlProc ]
{
}

ClassMethod OutHospitalRecordExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	/*
	---------
	出院唯一ID号	OUTHOSID
	患者就诊卡证类型	CARDTYPE
	患者就诊卡证号码	CARDNO
	病人姓名	NAME
	性别代码	SEX
	出生日期	BIRTHDAY
	住院号	HPSNO
	病案号	MRNO
	出院记录/死亡记录标识	OHRECDREC
	入院诊断疾病编码	IHDDISCODE
	入院诊断疾病名称	IHDDISNAME
	入院其他诊断①疾病编码	IHDDISCODE1
	入院其他诊断①疾病名称	IHDDISNAME1
	入院其他诊断②疾病编码	IHDDISCODE2
	入院其他诊断②疾病名称	IHDDISNAME2
	入院其他诊断③疾病编码	IHDDISCODE3
	入院其他诊断③疾病名称	IHDDISNAME3
	入院其他诊断④疾病编码	IHDDISCODE4
	入院其他诊断④疾病名称	IHDDISNAME4
	入院其他诊断⑤疾病编码	IHDDISCODE5
	入院其他诊断⑤疾病名称	IHDDISNAME5
	医生对入院诊断的描述	IHDDISDES
	入院日期时间	INHPDT
	是否做过手术	ISOPERATION
	主要手术编码	OPERATIONCODE
	主要手术名称	OPERATIONNAME
	其他手术①编码	OPERATIONCODE
	其他手术①名称	OPERATIONNAME
	其他手术②编码	OPERATIONCODE
	其他手术②名称	OPERATIONNAME
	其他手术③编码	OPERATIONCODE
	其他手术③名称	OPERATIONNAME
	其他手术④编码	OPERATIONCODE
	其他手术④名称	OPERATIONNAME
	其他手术⑤编码	OPERATIONCODE
	其他手术⑤名称	OPERATIONNAME
	医生对手术情况的描述	OPERATIONDES
	手术日期时间	OPERATIONDT
	出院（或死亡）主要诊断疾病编码	OHDDISCODE
	出院（或死亡）主要诊断疾病名称	OHDDISNAME
	出院（或死亡）其他诊断①疾病代码	OHDDISCODE1
	出院（或死亡）其他诊断①疾病名称	OHDDISNAME1
	出院（或死亡）其他诊断②疾病代码	OHDDISCODE2
	出院（或死亡）其他诊断②疾病名称	OHDDISNAME2
	出院（或死亡）其他诊断③疾病代码	OHDDISCODE3
	出院（或死亡）其他诊断③疾病名称	OHDDISNAME3
	出院（或死亡）其他诊断④疾病代码	OHDDISCODE4
	出院（或死亡）其他诊断④疾病名称	OHDDISNAME4
	出院（或死亡）其他诊断⑤疾病代码	OHDDISCODE5
	出院（或死亡）其他诊断⑤疾病名称	OHDDISNAME5
	出院（或死亡）其他诊断⑥疾病代码	OHDDISCODE6
	出院（或死亡）其他诊断⑥疾病名称	OHDDISNAME6
	出院（或死亡）其他诊断⑦疾病代码	OHDDISCODE7
	出院（或死亡）其他诊断⑦疾病名称	OHDDISNAME7
	出院（或死亡）其他诊断⑧疾病代码	OHDDISCODE8
	出院（或死亡）其他诊断⑧疾病名称	OHDDISNAME8
	出院（或死亡）其他诊断⑨疾病代码	OHDDISCODE9
	出院（或死亡）其他诊断⑨疾病名称	OHDDISNAME9
	医生对出院（或死亡）诊断的描述	OHDDISDES
	出院（或死亡）日期时间	OUTHPDT
	入院时情况	INHPILLCON
	住院经过（抢救经过）	HPCURPRO
	伤口愈合	WOUNDTYPE
	出院时情况	OUTHPILLCON
	出院医嘱	OUTHPODR
	死亡原因	DIECAUSE
	是否尸体病理解剖	IFAUTOPSY
	医疗机构编号	ORGANCODE
	医疗机构名称	ORGANNAME
	出院科室编码	OHDPTCODE
	出院科室名称	OHDPTNAME
	主治医师姓名	MAJDOCNAME
	医生身份证号	DOCIDCARD
	医生姓名	DOCNAME
	记录日期时间	RCDDT
	归档日期时间	POFDT
	*/
	
	s (OUTHOSID,CARDTYPE,CARDNO,NAME,SEX,BIRTHDAY,HPSNO,MRNO,OHRECDREC,IHDDISCODE,IHDDISNAME,IHDDISCODE1,IHDDISNAME1,IHDDISCODE2,IHDDISNAME2,IHDDISCODE3,IHDDISNAME3,IHDDISCODE4,IHDDISNAME4,IHDDISCODE5,IHDDISNAME5,IHDDISDES,INHPDT,ISOPERATION,OPERATIONCODE,OPERATIONNAME,OPERATIONCODE,OPERATIONNAME,OPERATIONCODE,OPERATIONNAME,OPERATIONCODE,OPERATIONNAME,OPERATIONCODE,OPERATIONNAME,OPERATIONCODE,OPERATIONNAME,OPERATIONDES,OPERATIONDT,OHDDISCODE,OHDDISNAME,OHDDISCODE1,OHDDISNAME1,OHDDISCODE2,OHDDISNAME2,OHDDISCODE3,OHDDISNAME3,OHDDISCODE4,OHDDISNAME4,OHDDISCODE5,OHDDISNAME5,OHDDISCODE6,OHDDISNAME6,OHDDISCODE7,OHDDISNAME7,OHDDISCODE8,OHDDISNAME8,OHDDISCODE9,OHDDISNAME9,OHDDISDES,OUTHPDT,INHPILLCON,HPCURPRO,WOUNDTYPE,OUTHPILLCON,OUTHPODR,DIECAUSE,IFAUTOPSY,ORGANCODE,ORGANNAME,OHDPTCODE,OHDPTNAME,MAJDOCNAME,DOCIDCARD,DOCNAME,RCDDT,POFDT)=""
	
	s YLJGDM="49361024400" 
	
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	i EndDate<StartDate Set qHandle=$lb(0,repid,0)	Quit $$$OK
	
	s tmpEpisodeID=""

	f tmpdate=+StartDate:1:+EndDate
	{
		s tmpEpisodeID=""
		for{
			s tmpEpisodeID= $o(^PAADMi("DischDate",tmpdate,tmpEpisodeID))
			q:(tmpEpisodeID = "")
			
			s argPapmiDR=$p(^PAADM(tmpEpisodeID),"^",1)
			//s argadmmother=""
			//s argadmmother=$p(^PAADM(tmpEpisodeID),"^",62)
			s deathdate=$p(^PAPER(argPapmiDR,"ALL"),"^",13)
			//continue:(deathdate'="")
			//continue:(argadmmother'="")
			//出院唯一ID号	
			s OUTHOSID = ""
			//患者就诊卡证类型	
			s CARDTYPE = ""
			//患者就诊卡证号码	
			s CARDNO = ""
			s strpaid = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(tmpEpisodeID)
			s KH = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(strpaid)
			//s strRe  = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_tmpEpisodeID," "_"CG37"))
			//continue:(strRe = "")
			s arr=##Class(EPRservice.BOScatterData).GetStandDataByGlossaryCategory(tmpEpisodeID,"HDSD00.14.13")
			
			
			//病人姓名	
			s NAME = arr.GetAt("HDSD00.14.030")
			//性别代码	
			s SEX = arr.GetAt("HDSD00.14.115")
			//出生日期	
			s BIRTHDAY = arr.GetAt("HDSD00.14.115")
			//住院号	
			s HPSNO = tmpEpisodeID
			//病案号	
			s MRNO = strpaid

			//出院记录/死亡记录标识	
			s OHRECDREC = $s(deathdate="":1,deathdate'="":2)
			//入院诊断疾病编码	
			s IHDDISCODE = arr.GetAt("HDSD00.14.082")
			//入院诊断疾病名称	
			s IHDDISNAME = arr.GetAt("HDSD00.14.137")
			//入院其他诊断①疾病编码	
			s IHDDISCODE1 = ""
			//入院其他诊断①疾病名称	
			s IHDDISNAME1 = ""
			//入院其他诊断②疾病编码	
			s IHDDISCODE2 = ""
			//入院其他诊断②疾病名称	
			s IHDDISNAME2 = ""
			//入院其他诊断③疾病编码	
			s IHDDISCODE3 = ""
			//入院其他诊断③疾病名称	
			s IHDDISNAME3 = ""
			//入院其他诊断④疾病编码	
			s IHDDISCODE4 = ""
			//入院其他诊断④疾病名称	
			s IHDDISNAME4 = ""
			//入院其他诊断⑤疾病编码	
			s IHDDISCODE5 = ""
			//入院其他诊断⑤疾病名称	
			s IHDDISNAME5 = ""
			//医生对入院诊断的描述	
			s IHDDISDES = arr.GetAt("HDSD00.14.300")
			//入院日期时间	
			s INHPDT = arr.GetAt("HDSD00.14.081")
			//是否做过手术	
			s ISOPERATION = ""
			//主要手术编码	
			s OPERATIONCODE = ""
			//主要手术名称	
			s OPERATIONNAME = ""
			//其他手术①编码	
			s OPERATIONCODE =  ""
			//其他手术①名称	
			s OPERATIONNAME =  ""
			//其他手术②编码	
			s OPERATIONCODE =  ""
			//其他手术②名称	
			s OPERATIONNAME =  ""
			//其他手术③编码	
			s OPERATIONCODE =  ""
			//其他手术③名称	
			s OPERATIONNAME =  ""
			//其他手术④编码	
			s OPERATIONCODE =  ""
			//其他手术④名称	
			s OPERATIONNAME =  ""
			//其他手术⑤编码	
			s OPERATIONCODE =  ""
			//其他手术⑤名称	
			s OPERATIONNAME =  ""
			//医生对手术情况的描述	
			s OPERATIONDES =  ""
			//手术日期时间	
			s OPERATIONDT =  ""
			//出院（或死亡）主要诊断疾病编码	
			s OHDDISCODE = arr.GetAt("HDSD00.14.017")
			//出院（或死亡）主要诊断疾病名称	
			s OHDDISNAME = arr.GetAt("HDSD00.14.018")
			//出院（或死亡）其他诊断①疾病代码	
			s OHDDISCODE1 =  ""
			//出院（或死亡）其他诊断①疾病名称	
			s OHDDISNAME1 =  ""
			//出院（或死亡）其他诊断②疾病代码	
			s OHDDISCODE2 =  ""
			//出院（或死亡）其他诊断②疾病名称	
			s OHDDISNAME2 =  ""
			//出院（或死亡）其他诊断③疾病代码	
			s OHDDISCODE3 =  ""
			//出院（或死亡）其他诊断③疾病名称	
			s OHDDISNAME3 =  ""
			//出院（或死亡）其他诊断④疾病代码	
			s OHDDISCODE4 =  ""
			//出院（或死亡）其他诊断④疾病名称	
			s OHDDISNAME4 =  ""
			//出院（或死亡）其他诊断⑤疾病代码	
			s OHDDISCODE5 =  ""
			//出院（或死亡）其他诊断⑤疾病名称	
			s OHDDISNAME5 =  ""
			//出院（或死亡）其他诊断⑥疾病代码	
			s OHDDISCODE6 =  ""
			//出院（或死亡）其他诊断⑥疾病名称	
			s OHDDISNAME6 =  ""
			//出院（或死亡）其他诊断⑦疾病代码	
			s OHDDISCODE7 =  ""
			//出院（或死亡）其他诊断⑦疾病名称	
			s OHDDISNAME7 =  ""
			//出院（或死亡）其他诊断⑧疾病代码	
			s OHDDISCODE8 =  ""
			//出院（或死亡）其他诊断⑧疾病名称	
			s OHDDISNAME8 =  ""
			//出院（或死亡）其他诊断⑨疾病代码	
			s OHDDISCODE9 =  ""
			//出院（或死亡）其他诊断⑨疾病名称	
			s OHDDISNAME9 =  ""
			//医生对出院（或死亡）诊断的描述	
			s OHDDISDES = arr.GetAt("HDSD00.14.301")
			//出院（或死亡）日期时间	
			s OUTHPDT = arr.GetAt("HDSD00.14.014")
			//入院时情况	
			s INHPILLCON = arr.GetAt("HDSD00.14.080")
			//住院经过（抢救经过）	
			s HPCURPRO = ""
			//伤口愈合	
			s WOUNDTYPE = ""
			//出院时情况	
			s OUTHPILLCON = arr.GetAt("HDSD00.14.013")
			//出院医嘱	
			s OUTHPODR = arr.GetAt("HDSD00.14.016")
			//死亡原因	
			s DIECAUSE = ""
			//是否尸体病理解剖	
			s IFAUTOPSY = ""
			//医疗机构编号	
			s ORGANCODE =""
			//医疗机构名称	
			s ORGANNAME = ""
			//出院科室编码	
			s OHDPTCODE = ""
			//出院科室名称	
			s OHDPTNAME = arr.GetAt("HDSD00.14.062")
			//主治医师姓名	
			s MAJDOCNAME = arr.GetAt("HDSD00.14.138")
			//医生身份证号	
			s DOCIDCARD = ""
			//医生姓名	
			s DOCNAME = arr.GetAt("HDSD00.14.141")
			//记录日期时间	
			s RCDDT = ""
			//归档日期时间	
			s POFDT = arr.GetAt("HDSD00.14.076")


			set ^CacheTemp(repid, ind) = $LB(OUTHOSID,CARDTYPE,CARDNO,NAME,SEX,BIRTHDAY,HPSNO,MRNO,OHRECDREC,IHDDISCODE,IHDDISNAME,IHDDISCODE1,IHDDISNAME1,IHDDISCODE2,IHDDISNAME2,IHDDISCODE3,IHDDISNAME3,IHDDISCODE4,IHDDISNAME4,IHDDISCODE5,IHDDISNAME5,IHDDISDES,INHPDT,ISOPERATION,OPERATIONCODE,OPERATIONNAME,OPERATIONCODE,OPERATIONNAME,OPERATIONCODE,OPERATIONNAME,OPERATIONCODE,OPERATIONNAME,OPERATIONCODE,OPERATIONNAME,OPERATIONCODE,OPERATIONNAME,OPERATIONDES,OPERATIONDT,OHDDISCODE,OHDDISNAME,OHDDISCODE1,OHDDISNAME1,OHDDISCODE2,OHDDISNAME2,OHDDISCODE3,OHDDISNAME3,OHDDISCODE4,OHDDISNAME4,OHDDISCODE5,OHDDISNAME5,OHDDISCODE6,OHDDISNAME6,OHDDISCODE7,OHDDISNAME7,OHDDISCODE8,OHDDISNAME8,OHDDISCODE9,OHDDISNAME9,OHDDISDES,OUTHPDT,INHPILLCON,HPCURPRO,WOUNDTYPE,OUTHPILLCON,OUTHPODR,DIECAUSE,IFAUTOPSY,ORGANCODE,ORGANNAME,OHDPTCODE,OHDPTNAME,MAJDOCNAME,DOCIDCARD,DOCNAME,RCDDT,POFDT)
			set ind = ind + 1
		}
	}
	Quit $$$OK
}

ClassMethod OutHospitalRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OutHospitalRecordExecute ]
{
	
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod OutHospitalRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OutHospitalRecordExecute ]
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

/// /d ##class(%ResultSet).RunQuery("web.DHCEPRInterfaceQYHY","InHospitalRecord","2015-12-05","2015-12-05")
/// 徐州中心入院记录
Query InHospitalRecord(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "INHOSID,CARDTYPE,CARDNO,NAME,SEX,BIRTHDAY,HPSNO,MRNO,HPDATE,SOURCECODE,PROVIDEHXNAME,RELACODE,SUBJCOMPLAINT,PRESHX,PREVHX,PERHIS,OBSHIS,FAMHIS,TEMP,PR,RR,SBP,DBP,PHYEX,SPESIT,AUXIEX,CASABS,TCMFOURWAYS,PDDISCODE,PDDISNAME,PDDISCODE1,PDDISNAME1,PDDISCODE2,PDDISNAME2,PDDISCODE3,PDDISNAME3,PDDISCODE4,PDDISNAME4,PDDISCODE5,PDDISNAME5,PDDISDES,PDDOCNAME,MDDISCODE,MDDISNAME,MDDISCODE1,MDDISNAME1,MDDISCODE2,MDDISNAME2,MDDISCODE3,MDDISNAME3,MDDISCODE4,MDDISNAME4,MDDISCODE5,MDDISNAME5,MDDISCODE6,MDDISNAME6,MDDISCODE7,MDDISNAME7,MDDISCODE8,MDDISNAME8,MDDISCODE9,MDDISNAME9,MDDISDES,RSPHYIDCARD,RSPHYNAME,IHDISDATE,RDDISCODE,RDDISNAME,RDDISCODE1,RDDISNAME1,RDDISCODE2,RDDISNAME2,RDDISCODE3,RDDISNAME3,RDDISCODE4,RDDISNAME4,RDDISCODE5,RDDISNAME5,RDDISDES,RDDOCNAME,RDDISDATE,IFDIFCASE,IFCRICASE,IFINFCASE,IFUNPNEU,ORGANCODE,ORGANNAME,IHDPTCODE,IHDPTNAME,RCDDT,POFDT") [ SqlName = InHospitalRecord, SqlProc ]
{
}

ClassMethod InHospitalRecordExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	/*
	入院唯一ID号	INHOSID
	患者就诊卡证类型	CARDTYPE
	患者就诊卡证号码	CARDNO
	病人姓名	NAME
	性别代码	SEX
	出生日期	BIRTHDAY
	住院号	HPSNO
	病案号	MRNO
	入院日期时间	HPDATE
	入院病人来源代码	SOURCECODE
	供史者姓名	PROVIDEHXNAME
	与患者关系代码	RELACODE
	病人主诉	SUBJCOMPLAINT
	现病史描述	PRESHX
	既往史描述	PREVHX
	个人史	PERHIS
	婚育史（包括：月经史）	OBSHIS
	家族史	FAMHIS
	体温（℃）	TEMP
	脉博（次/min） 	PR
	呼吸频率 	RR
	收缩压（mmHg） 	SBP
	舒张压（mmHg） 	DBP
	体格检查	PHYEX
	专科情况	SPESIT
	辅助检查（实验室及器械检查）	AUXIEX
	病历摘要	CASABS
	中医“四诊”观察结果等详细描述	TCMFOURWAYS
	初步主要诊断疾病编码	PDDISCODE
	初步主要诊断疾病名称	PDDISNAME
	初步其他诊断①疾病编码	PDDISCODE1
	初步其他诊断①疾病名称	PDDISNAME1
	初步其他诊断②疾病编码	PDDISCODE2
	初步其他诊断②疾病名称	PDDISNAME2
	初步其他诊断③疾病编码	PDDISCODE3
	初步其他诊断③疾病名称	PDDISNAME3
	初步其他诊断④疾病编码	PDDISCODE4
	初步其他诊断④疾病名称	PDDISNAME4
	初步其他诊断⑤疾病编码	PDDISCODE5
	初步其他诊断⑤疾病名称	PDDISNAME5
	医生对初步诊断的描述	PDDISDES
	初步诊断医师姓名	PDDOCNAME
	入院主要诊断疾病编码	MDDISCODE
	入院主要诊断疾病名称	MDDISNAME
	入院其他诊断①疾病代码	MDDISCODE1
	入院其他诊断①疾病名称	MDDISNAME1
	入院其他诊断②疾病代码	MDDISCODE2
	入院其他诊断②疾病名称	MDDISNAME2
	入院其他诊断③疾病代码	MDDISCODE3
	入院其他诊断③疾病名称	MDDISNAME3
	入院其他诊断④疾病代码	MDDISCODE4
	入院其他诊断④疾病名称	MDDISNAME4
	入院其他诊断⑤疾病代码	MDDISCODE5
	入院其他诊断⑤疾病名称	MDDISNAME5
	入院其他诊断⑥疾病代码	MDDISCODE6
	入院其他诊断⑥疾病名称	MDDISNAME6
	入院其他诊断⑦疾病代码	MDDISCODE7
	入院其他诊断⑦疾病名称	MDDISNAME7
	入院其他诊断⑧疾病代码	MDDISCODE8
	入院其他诊断⑧疾病名称	MDDISNAME8
	入院其他诊断⑨疾病代码	MDDISCODE9
	入院其他诊断⑨疾病名称	MDDISNAME9
	医生对入院诊断的描述	MDDISDES
	主治医师身份证号码	RSPHYIDCARD
	主治医师姓名	RSPHYNAME
	入院诊断日期	IHDISDATE
	修正主要诊断疾病编码	RDDISCODE
	修正主要诊断疾病名称	RDDISNAME
	修正其他诊断①疾病编码	RDDISCODE1
	修正其他诊断①疾病名称	RDDISNAME1
	修正其他诊断②疾病编码	RDDISCODE2
	修正其他诊断②疾病名称	RDDISNAME2
	修正其他诊断③疾病编码	RDDISCODE3
	修正其他诊断③疾病名称	RDDISNAME3
	修正其他诊断④疾病编码	RDDISCODE4
	修正其他诊断④疾病名称	RDDISNAME4
	修正其他诊断⑤疾病编码	RDDISCODE5
	修正其他诊断⑤疾病名称	RDDISNAME5
	医生对修正诊断的描述	RDDISDES
	修正诊断医师姓名	RDDOCNAME
	修正诊断日期	RDDISDATE
	是否疑难病例	IFDIFCASE
	是否危重病例	IFCRICASE
	是否传染病或疑似病例	IFINFCASE
	是否不明原因肺炎病例	IFUNPNEU
	医疗机构编号	ORGANCODE
	医疗机构名称	ORGANNAME
	入院科室编码	IHDPTCODE
	入院科室名称	IHDPTNAME
	记录日期时间	RCDDT
	归档日期时间	POFDT
	*/
	
	s (INHOSID,CARDTYPE,CARDNO,NAME,SEX,BIRTHDAY,HPSNO,MRNO,HPDATE,SOURCECODE,PROVIDEHXNAME,RELACODE,SUBJCOMPLAINT,PRESHX,PREVHX,PERHIS,OBSHIS,FAMHIS,TEMP,PR,RR,SBP,DBP,PHYEX,SPESIT,AUXIEX,CASABS,TCMFOURWAYS,PDDISCODE,PDDISNAME,PDDISCODE1,PDDISNAME1,PDDISCODE2,PDDISNAME2,PDDISCODE3,PDDISNAME3,PDDISCODE4,PDDISNAME4,PDDISCODE5,PDDISNAME5,PDDISDES,PDDOCNAME,MDDISCODE,MDDISNAME,MDDISCODE1,MDDISNAME1,MDDISCODE2,MDDISNAME2,MDDISCODE3,MDDISNAME3,MDDISCODE4,MDDISNAME4,MDDISCODE5,MDDISNAME5,MDDISCODE6,MDDISNAME6,MDDISCODE7,MDDISNAME7,MDDISCODE8,MDDISNAME8,MDDISCODE9,MDDISNAME9,MDDISDES,RSPHYIDCARD,RSPHYNAME,IHDISDATE,RDDISCODE,RDDISNAME,RDDISCODE1,RDDISNAME1,RDDISCODE2,RDDISNAME2,RDDISCODE3,RDDISNAME3,RDDISCODE4,RDDISNAME4,RDDISCODE5,RDDISNAME5,RDDISDES,RDDOCNAME,RDDISDATE,IFDIFCASE,IFCRICASE,IFINFCASE,IFUNPNEU,ORGANCODE,ORGANNAME,IHDPTCODE,IHDPTNAME,RCDDT,POFDT)=""
	
	s YLJGDM="49361024400" 
	
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	i EndDate<StartDate Set qHandle=$lb(0,repid,0)	Quit $$$OK
	
	s tmpEpisodeID=""

	f tmpdate=+StartDate:1:+EndDate
	{
		s tmpEpisodeID=""
		for{
			s tmpEpisodeID= $o(^PAADMi("DischDate",tmpdate,tmpEpisodeID))
			q:(tmpEpisodeID = "")
			
			s argPapmiDR=$p(^PAADM(tmpEpisodeID),"^",1)
			//s argadmmother=""
			//s argadmmother=$p(^PAADM(tmpEpisodeID),"^",62)
			s deathdate=$p(^PAPER(argPapmiDR,"ALL"),"^",13)
			//continue:(deathdate'="")
			//continue:(argadmmother'="")
			//出院唯一ID号	
			s INHOSID = ""
			//患者就诊卡证类型	
			s CARDTYPE = ""
			//患者就诊卡证号码	
			s CARDNO = ""
			s strpaid = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(tmpEpisodeID)
			s KH = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(strpaid)
			//s strRe  = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_tmpEpisodeID," "_"CG37"))
			//continue:(strRe = "")
			s arr=##Class(EPRservice.BOScatterData).GetStandDataByGlossaryCategory(tmpEpisodeID,"HDSD00.14.13")
			
			//病人姓名	
			s NAME = arr.GetAt("HDSD00.13.039")
			//性别代码	
			s SEX = arr.GetAt("HDSD00.13.096")
			//出生日期	
			s BIRTHDAY = ""
			//住院号	
			s HPSNO = tmpEpisodeID
			//病案号	
			s MRNO = strpaid
			//入院日期时间	
			s HPDATE = arr.GetAt("HDSD00.13.057")
			//入院病人来源代码	
			s SOURCECODE = ""
			//供史者姓名	
			s PROVIDEHXNAME = arr.GetAt("HDSD00.13.004")
			//与患者关系代码	
			s RELACODE = arr.GetAt("HDSD00.13.009")
			//病人主诉	
			s SUBJCOMPLAINT = arr.GetAt("HDSD00.13.114")
			//现病史描述	
			s PRESHX = arr.GetAt("HDSD00.13.095")
			//既往史描述	
			s PREVHX = arr.GetAt("HDSD00.13.042")
			//个人史	
			s PERHIS = arr.GetAt("HDSD00.13.036")
			//婚育史（包括：月经史）	
			s OBSHIS = arr.GetAt("HDSD00.13.041")
			//家族史	
			s FAMHIS = arr.GetAt("HDSD00.13.043")
			//体温（℃）	
			s TEMP = arr.GetAt("HDSD00.13.088")
			//脉博（次/min） 	
			s PR = arr.GetAt("HDSD00.13.080")
			//呼吸频率 	
			s RR = arr.GetAt("HDSD00.13.077")
			//收缩压（mmHg） 	
			s SBP = arr.GetAt("HDSD00.13.085")
			//舒张压（mmHg） 	
			s DBP = arr.GetAt("HDSD00.13.086")
			//体格检查	
			s PHYEX = arr.GetAt("HDSD00.13.094")
			//专科情况	
			s SPESIT = arr.GetAt("HDSD00.13.118")
			//辅助检查（实验室及器械检查）	
			s AUXIEX = arr.GetAt("HDSD00.13.035")
			//病历摘要	
			s CASABS = ""
			//中医“四诊”观察结果等详细描述	
			s TCMFOURWAYS = arr.GetAt("HDSD00.13.112")
			//初步主要诊断疾病编码	
			s PDDISCODE = arr.GetAt("HDSD00.13.022")
			//初步主要诊断疾病名称	
			s PDDISNAME = arr.GetAt("HDSD00.13.023")
			//初步其他诊断①疾病编码	
			s PDDISCODE1 = ""
			//初步其他诊断①疾病名称	
			s PDDISNAME1 =""
			//初步其他诊断②疾病编码	
			s PDDISCODE2 = ""
			//初步其他诊断②疾病名称	
			s PDDISNAME2 =""
			//初步其他诊断③疾病编码	
			s PDDISCODE3 = ""
			//初步其他诊断③疾病名称	
			s PDDISNAME3 =""
			//初步其他诊断④疾病编码	
			s PDDISCODE4 = ""
			//初步其他诊断④疾病名称	
			s PDDISNAME4 = ""
			//初步其他诊断⑤疾病编码	
			s PDDISCODE5 = ""
			//初步其他诊断⑤疾病名称	
			s PDDISNAME5 = ""
			//医生对初步诊断的描述	
			s PDDISDES = ""
			//初步诊断医师姓名	
			s PDDOCNAME = arr.GetAt("HDSD00.13.117")
			//入院主要诊断疾病编码	
			s MDDISCODE = arr.GetAt("HDSD00.13.050")
			//入院主要诊断疾病名称	
			s MDDISNAME = arr.GetAt("HDSD00.13.051")
			//入院其他诊断①疾病代码	
			s MDDISCODE1 = ""
			//入院其他诊断①疾病名称	
			s MDDISNAME1 =""
			//入院其他诊断②疾病代码	
			s MDDISCODE2 = ""
			//入院其他诊断②疾病名称	
			s MDDISNAME2 = ""
			//入院其他诊断③疾病代码	
			s MDDISCODE3 = ""
			//入院其他诊断③疾病名称	
			s MDDISNAME3 = ""
			//入院其他诊断④疾病代码	
			s MDDISCODE4 = ""
			//入院其他诊断④疾病名称	
			s MDDISNAME4 = ""
			//入院其他诊断⑤疾病代码	
			s MDDISCODE5 = ""
			//入院其他诊断⑤疾病名称	
			s MDDISNAME5 = ""
			//入院其他诊断⑥疾病代码	
			s MDDISCODE6 = ""
			//入院其他诊断⑥疾病名称	
			s MDDISNAME6 = ""
			//入院其他诊断⑦疾病代码	
			s MDDISCODE7 =""
			//入院其他诊断⑦疾病名称	
			s MDDISNAME7 =""
			//入院其他诊断⑧疾病代码	
			s MDDISCODE8 = ""
			//入院其他诊断⑧疾病名称	
			s MDDISNAME8 = ""
			//入院其他诊断⑨疾病代码	
			s MDDISCODE9 = ""
			//入院其他诊断⑨疾病名称	
			s MDDISNAME9 = ""
			//医生对入院诊断的描述	
			s MDDISDES = ""
			//主治医师身份证号码	
			s RSPHYIDCARD = ""
			//主治医师姓名	
			s RSPHYNAME = arr.GetAt("HDSD00.13.115")
			//入院诊断日期	
			s IHDISDATE = arr.GetAt("HDSD00.13.049")
			//修正主要诊断疾病编码	
			s RDDISCODE = arr.GetAt("HDSD00.13.098")
			//修正主要诊断疾病名称	
			s RDDISNAME = arr.GetAt("HDSD00.13.099")
			//修正其他诊断①疾病编码	
			s RDDISCODE1 = ""
			//修正其他诊断①疾病名称	
			s RDDISNAME1 = ""
			//修正其他诊断②疾病编码	
			s RDDISCODE2 = ""
			//修正其他诊断②疾病名称	
			s RDDISNAME2 = ""
			//修正其他诊断③疾病编码	
			s RDDISCODE3 = ""
			//修正其他诊断③疾病名称	
			s RDDISNAME3 = ""
			//修正其他诊断④疾病编码	
			s RDDISCODE4 =""
			//修正其他诊断④疾病名称	
			s RDDISNAME4 = ""
			//修正其他诊断⑤疾病编码	
			s RDDISCODE5 = ""
			//修正其他诊断⑤疾病名称	
			s RDDISNAME5 = ""
			//医生对修正诊断的描述	
			s RDDISDES = ""
			//修正诊断医师姓名	
			s RDDOCNAME = arr.GetAt("HDSD00.13.117")
			//修正诊断日期	
			s RDDISDATE = arr.GetAt("HDSD00.13.097")
			//是否疑难病例	
			s IFDIFCASE = ""
			//是否危重病例	
			s IFCRICASE = ""
			//是否传染病或疑似病例	
			s IFINFCASE = arr.GetAt("HDSD00.13.038")
			//是否不明原因肺炎病例	
			s IFUNPNEU = ""
			//医疗机构编号	
			s ORGANCODE = ""
			//医疗机构名称	
			s ORGANNAME = ""
			//入院科室编码	
			s IHDPTCODE = ""
			//入院科室名称	
			s IHDPTNAME = arr.GetAt("HDSD00.13.045")
			//记录日期时间	
			s RCDDT = ""
			//归档日期时间	
			s POFDT = arr.GetAt("HDSD00.13.049")



			set ^CacheTemp(repid, ind) = $LB(INHOSID,CARDTYPE,CARDNO,NAME,SEX,BIRTHDAY,HPSNO,MRNO,HPDATE,SOURCECODE,PROVIDEHXNAME,RELACODE,SUBJCOMPLAINT,PRESHX,PREVHX,PERHIS,OBSHIS,FAMHIS,TEMP,PR,RR,SBP,DBP,PHYEX,SPESIT,AUXIEX,CASABS,TCMFOURWAYS,PDDISCODE,PDDISNAME,PDDISCODE1,PDDISNAME1,PDDISCODE2,PDDISNAME2,PDDISCODE3,PDDISNAME3,PDDISCODE4,PDDISNAME4,PDDISCODE5,PDDISNAME5,PDDISDES,PDDOCNAME,MDDISCODE,MDDISNAME,MDDISCODE1,MDDISNAME1,MDDISCODE2,MDDISNAME2,MDDISCODE3,MDDISNAME3,MDDISCODE4,MDDISNAME4,MDDISCODE5,MDDISNAME5,MDDISCODE6,MDDISNAME6,MDDISCODE7,MDDISNAME7,MDDISCODE8,MDDISNAME8,MDDISCODE9,MDDISNAME9,MDDISDES,RSPHYIDCARD,RSPHYNAME,IHDISDATE,RDDISCODE,RDDISNAME,RDDISCODE1,RDDISNAME1,RDDISCODE2,RDDISNAME2,RDDISCODE3,RDDISNAME3,RDDISCODE4,RDDISNAME4,RDDISCODE5,RDDISNAME5,RDDISDES,RDDOCNAME,RDDISDATE,IFDIFCASE,IFCRICASE,IFINFCASE,IFUNPNEU,ORGANCODE,ORGANNAME,IHDPTCODE,IHDPTNAME,RCDDT,POFDT)
			set ind = ind + 1
		}
	}
	Quit $$$OK
}

ClassMethod InHospitalRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InHospitalRecordExecute ]
{
	
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod InHospitalRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InHospitalRecordExecute ]
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

/// /d ##class(%ResultSet).RunQuery("web.DHCEPRInterfaceQYHY","CourseRecord","2015-12-05","2015-12-05")
/// 徐州中心病程记录
Query CourseRecord(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "PROGRESSID,CARDTYPE,CARDNO,NAME,SEX,BIRTHDAY,HPSNO,MRNO,PROGRESSDATE,PROGRESSMARK,TCMFOURWAYS,MDISCODE,MDISNAME,HOSCOURSE,DOCCONT,IFDIFCASE,IFCRICASE,IFINFCASE,IFUNPNEU,ORGANCODE,ORGANNAME,DPTCODE,DPTNAME,DOCIDCARD,DOCNAME,POFDT") [ SqlName = CourseRecord, SqlProc ]
{
}

ClassMethod CourseRecordExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	/*
	病程记录唯一ID号	PROGRESSID
	患者就诊卡证类型	CARDTYPE
	患者就诊卡证号码	CARDNO
	病人姓名	NAME
	性别代码	SEX
	出生日期	BIRTHDAY
	住院号	HPSNO
	病案号	MRNO
	病程记录日期	PROGRESSDATE
	首次/日常病程记录标识	PROGRESSMARK
	中医“四诊”观察结果详细描述	TCMFOURWAYS
	主要诊断疾病代码	MDISCODE
	主要诊断疾病名称	MDISNAME
	病程记录的详细描述	HOSCOURSE
	医嘱内容的详细描述	DOCCONT
	是否疑难病例	IFDIFCASE
	是否危重病例	IFCRICASE
	是否传染病或疑似病例	IFINFCASE
	是否不明原因肺炎病例	IFUNPNEU
	医疗机构编号	ORGANCODE
	医疗机构名称	ORGANNAME
	科室编码	DPTCODE
	科室名称	DPTNAME
	医生身份证号码	DOCIDCARD
	医生姓名	DOCNAME
	归档日期时间	POFDT
	*/
	
	s (PROGRESSID,CARDTYPE,CARDNO,NAME,SEX,BIRTHDAY,HPSNO,MRNO,PROGRESSDATE,PROGRESSMARK,TCMFOURWAYS,MDISCODE,MDISNAME,HOSCOURSE,DOCCONT,IFDIFCASE,IFCRICASE,IFINFCASE,IFUNPNEU,ORGANCODE,ORGANNAME,DPTCODE,DPTNAME,DOCIDCARD,DOCNAME,POFDT)=""
	
	s YLJGDM="49361024400" 
	
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	i EndDate<StartDate Set qHandle=$lb(0,repid,0)	Quit $$$OK
	
	s tmpEpisodeID=""

	f tmpdate=+StartDate:1:+EndDate
	{
		s tmpEpisodeID=""
		for{
			s tmpEpisodeID= $o(^PAADMi("DischDate",tmpdate,tmpEpisodeID))
			q:(tmpEpisodeID = "")
			
			s argPapmiDR=$p(^PAADM(tmpEpisodeID),"^",1)
			//s argadmmother=""
			//s argadmmother=$p(^PAADM(tmpEpisodeID),"^",62)
			s deathdate=$p(^PAPER(argPapmiDR,"ALL"),"^",13)
			//continue:(deathdate'="")
			//continue:(argadmmother'="")
			//出院唯一ID号	
			s PROGRESSID = ""
			//患者就诊卡证类型	
			s CARDTYPE = ""
			//患者就诊卡证号码	
			s CARDNO = ""
			s strpaid = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(tmpEpisodeID)
			s KH = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(strpaid)
			//s strRe  = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_tmpEpisodeID," "_"CG37"))
			//continue:(strRe = "")
			s strECRowID = ""
			s strECRowID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_tmpEpisodeID," "_"ML37",strECRowID))
			q:(strECRowID = "")
			s objECRecord = ##Class(EPRinstance.ECRecord).%OpenId(strECRowID)
    
			Set key = ""
			do
			{ 
		    	S objInstanceData = objECRecord.Instances.GetNext(.key)
			    if (objInstanceData '= "")
		     	{ 
		     	 
					continue:((objInstanceData.Status="UnSave")||(objInstanceData.Status="Delete"))
					
			     	s strInTitle ="$"_objInstanceData.Title_"$"
		     	  	if ((strInTitle = "$首次病程记录$")||(strInTitle = "$病程记录$"))
		     	  	{
			     	  	s strInterID =""
			     	  	s strMark = ""
			     	  	if (strInTitle = "$首次病程记录$")
			     	  	{
				     	  	s strInterID ="HDSD00.14.01"
				     	    s strMark = 1
			     	  	}
			     	  	elseif (strInTitle = "$病程记录$")
			     	  	{
				     	  	s strInterID ="HDSD00.14.02"
				     	  	s strMark = 2
			     	  	}
						s arr=##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(tmpEpisodeID,strInterID)
			
						//病人姓名	
						s NAME = arr.GetAt("HDSD00.14.030")
						//性别代码	
						s SEX = arr.GetAt("HDSD00.14.115")
						//出生日期	
						s BIRTHDAY = ""
						//住院号	
						s HPSNO = tmpEpisodeID
						//病案号	
						s MRNO = strpaid
						//病程记录日期	
						s PROGRESSDATE = arr.GetAt("HDSD00.14.046")
						//首次/日常病程记录标识	
						s PROGRESSMARK = strMark
						//中医“四诊”观察结果详细描述	
						s TCMFOURWAYS = ""
						//主要诊断疾病代码	
						s MDISCODE = arr.GetAt("HDSD00.14.023")
						//主要诊断疾病名称	
						s MDISNAME = arr.GetAt("HDSD00.14.024")
						//病程记录的详细描述	
						s HOSCOURSE = arr.GetAt("HDSD00.14.139")
						//医嘱内容的详细描述	
						s DOCCONT = arr.GetAt("HDSD00.14.118")
						//是否疑难病例	
						s IFDIFCASE = ""
						//是否危重病例	
						s IFCRICASE =""
						//是否传染病或疑似病例	
						s IFINFCASE = ""
						//是否不明原因肺炎病例	
						s IFUNPNEU = ""
						//医疗机构编号	
						s ORGANCODE = ""
						//医疗机构名称	
						s ORGANNAME = ""
						//科室编码	
						s DPTCODE = ""
						//科室名称	
						s DPTNAME = arr.GetAt("HDSD00.14.062")
						//医生身份证号码	
						s DOCIDCARD = ""
						//医生姓名	
						s DOCNAME = $s(strMark=1:arr.GetAt("HDSD00.14.141"),i=2:arr.GetAt("HDSD00.14.117"))
						//归档日期时间	
						s POFDT = arr.GetAt("HDSD00.14.076")

						set ^CacheTemp(repid, ind) = $LB(PROGRESSID,CARDTYPE,CARDNO,NAME,SEX,BIRTHDAY,HPSNO,MRNO,PROGRESSDATE,PROGRESSMARK,TCMFOURWAYS,MDISCODE,MDISNAME,HOSCOURSE,DOCCONT,IFDIFCASE,IFCRICASE,IFINFCASE,IFUNPNEU,ORGANCODE,ORGANNAME,DPTCODE,DPTNAME,DOCIDCARD,DOCNAME,POFDT)
						set ind = ind + 1
		     	  	}
			  	} 
			} 
			while (key '="" )

			
		}
	}
	Quit $$$OK
}

ClassMethod CourseRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CourseRecordExecute ]
{
	
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod CourseRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CourseRecordExecute ]
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

/// Desc:	获取指定术语集范畴下的所有术语值
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	术语值数组
/// Debug:	w ##Class(EPRservice.BIL.BIToHIP).GetDataByGlossaryCategory("14743959","HDSD00.14.01","21163794||1")
ClassMethod GetDataByGlossaryCategory(AEpisodeID As %String, ACategoryInternalID As %String, instanceDataID As %String = "") As %ArrayOfDataTypes
{
	s glossaryCategoryID = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
	q:(glossaryCategoryID="") ""

	s retArray = ##Class(%ArrayOfDataTypes).%New()

	s glossaryID = ""
	for {
		s glossaryID = $O(^DHCEPRM.GlossaryI("IdxCategoryID"," "_glossaryCategoryID,glossaryID))
		q:(glossaryID="")
	
		s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryID)
		continue:(objGlossary="")
	
		s internalID = objGlossary.InternalID
		;s value = ##class(EPRservice.BOScatterData).GetScatterDataByGlossaryID(AEpisodeID,glossaryID)
		
		//通过注册号，术语rowId获取业务数据
		s strDataValue = ..GetScatterDataByGlossaryID(AEpisodeID,glossaryID,instanceDataID)
		if (strDataValue ="")
		{
			s strDataValue = ##class(EPRservice.BOScatterData).GetScatterDataByGlossaryID(AEpisodeID,glossaryID)
		}
		/*S objStandData =  ##Class(EPRservice.entity.EStandDataInfo).%New()
		S objStandData.strInternalID = internalID
		s strValue=$tr(value,"<","(")
		s strValue=$tr(strValue,">",")")
		S objStandData.displayName = strValue
		*/
		w internalID_":"_strDataValue,!
		d retArray.SetAt(strDataValue, internalID)
	
	}
	q retArray
}

/// Desc: 	使用术语集取电子病历打散数据
/// Return:	metaItemInfo$|value&|metaItemInfo$|value
/// Debug: 	w ##class(EPRservice.BLL.BLDataETranFactory).GetScatterDataByGlossaryID("58","1811","810||2")
ClassMethod GetScatterDataByGlossaryID(AEpisodeID As %String, AGlossaryID As %String, instanceDataID As %String = "") As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	q:($d(AGlossaryID) = 0)||(AGlossaryID = "") ret
	s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(AGlossaryID)
	q:(objGlossary = "") ret
	
	s name = objGlossary.Name
	s type = objGlossary.GlossaryType
	
	if ($zcvt(type,"U") = "TG")
	{
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",AGlossaryID,rowID))
			q:(rowID = "")
			
			s objItem = ##Class(EPRmeta.GlossaryItem).%OpenId(rowID)
			
			s itemCode = objItem.ItemCode
			s valueType = objItem.ValueType
			s templateID = objItem.TemplateID
			s ret = ""
			if (instanceDataID = ""){
			s ret = ##Class(EPRservice.BOScatterData).GetScatterData(AEpisodeID,templateID,itemCode,valueType)
			}else{
			s ret = ##Class(EPRservice.BOScatterData).GetMultipleScatterData(AEpisodeID,templateID,itemCode,instanceDataID,valueType)
			}
			q:(ret '= "")&&(ret '= "Null")
		}	
	}
	else
	{
		s parGlossaryID = objGlossary.ParentID
		q:(parGlossaryID = "") ret

		s objParGlossary = ##Class(EPRmeta.Glossary).%OpenId(parGlossaryID)
		q:(objParGlossary = "") ret
			
		s parRowID = ""
		for {
			s parRowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",parGlossaryID,parRowID))
			q:(parRowID = "")
			
			s objParItem = ##Class(EPRmeta.GlossaryItem).%OpenId(parRowID)
			
			s parItemCode = objParItem.ItemCode
			s parValueType = objParItem.ValueType
			s parTemplateID = objParItem.TemplateID

			//s parItemValue = ##Class(EPRservice.BOScatterData).GetScatterData(AEpisodeID,parTemplateID,parItemCode,parValueType)
			//if (parItemValue = "")
			//{
			//	q
			//}
			s kbRowID = ""
			for {
				s kbRowID = $o(^DHCEPRM.GlossaryKBItemI("IdxGlossaryID",AGlossaryID,kbRowID))
				q:(kbRowID = "")
			
				s objParItem = ##Class(EPRmeta.GlossaryKBItem).%OpenId(kbRowID)
				s curItemCode = objParItem.ItemCode
				s curValueType = objParItem.ValueType
				s kbPartNo = objParItem.KBPartNo
				S KBNodeID = objParItem.KBNodeID
			
				s curTextSimpleRowID= ""
				for
				{
					s curTextSimpleRowID = $o(^DHCEPRI.ITextDescSimpleI("IdxForUpdate"," "_instanceDataID," "_parItemCode," "_KBNodeID," "_kbPartNo," "_curItemCode,curTextSimpleRowID))
					q:(curTextSimpleRowID = "")
					s curItemType = $e($tr(curItemCode," ",""),0,1)
					s curTextSimpleValue = ##Class(EPRservice.BOScatterData).GetITextDescSimpleValue(curTextSimpleRowID,curItemType,$tr(curValueType," ",""))
					if (curTextSimpleValue '= "")
					{
						s ret = curTextSimpleValue
						q	
					}	
				}	
			}	
		}
	}
	s:(ret="Null") ret = ""
	q ret
}

}
