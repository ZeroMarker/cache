Class DHCEWELL.DHCEPRInterfaceQYHY Extends %RegisteredObject
{

/// /d ##class(%ResultSet).RunQuery("web.DHCEPRInterfaceQYHY","QueryQYHYOperDetail",1)
/// 青医附院海洋手术明细
Query QueryQYHYOperDetail(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "YLJGDM,SSMXLSH,KH,KLX,JZLSH,ZQSSBZ,MZZYBZ,RJSSBZ,SSLX,SSCZBM,SSCZMC,SSQZD,SSHZD,SSKSSJ,SSJSSJ,SSJB,SSYSGH,SSYSXM,SSYSZ1GH,SSYSZ1XM,SSYSZ2GH,SSYSZ2XM,MZYSGH,MZYSXM,MZFS,QKYHDJ,MJ,XGBZ,YLYL1,YLYL2") [ SqlName = DZBL_TB_Operation_Detail, SqlProc ]
{
}

ClassMethod QueryQYHYOperDetailExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	/*
	医疗机构代码	YLJGDM	字符串	22	必填	复合主键
	手术明细流水号	SSMXLSH	字符串	32	必填	复合主键；见说明（1）
	卡号	KH	字符串	32	必填	必须与患者基本信息关联，见说明(2)及相关说明。YT3.1.006
	卡类型	KLX	字符串	16	必填	
	就诊流水号	JZLSH	字符串	50	必填	用于与住院就诊记录表或门诊就诊记录表关联的外键
	择期手术标志	ZQSSBZ	字符串	1	必填	编码。1：择期手术；2：非择期手术；9：不明确
	门诊/住院标志	MZZYBZ	字符串	2	必填	1门诊，2住院YT3.1.033
	日间手术标志	RJSSBZ	字符串	2	可选 	1是；0否 
	手术类型	SSLX	字符串	2	必填	1 一般，2抢救，3术中急抢救， 9其他	YT3.1.060
	手术操作编码	SSCZBM	字符串	10	必填	编码。按规定的ICD-9-CM3字典执行　
	手术操作名称	SSCZMC	字符串	256	可选	对应于SSCZBM的中文名称
	手术前诊断	SSQZD	字符串	10	可选	编码。按规定的ICD-10字典执行
	手术后诊断	SSHZD	字符串	10	可选	编码。按规定的ICD-10字典执行
	手术起始时间	SSKSSJ	DATETIME		必填	
	手术结束时间	SSJSSJ	DATETIME		必填	
	手术级别	SSJB	字符串	2	可选	见说明（4）	CV05.10.024
	手术医生工号	SSYSGH	字符串	16	可选	编码。见医护人员字典表
	手术医生姓名	SSYSXM	字符串	32	必填	
	手术医生I助工号	SSYSZ1GH	字符串	16	可选	编码。见医护人员字典表
	手术医生I助姓名	SSYSZ1XM	字符串	32	必填	
	手术医生II助工号	SSYSZ2GH	字符串	16	可选	编码。见医护人员字典表
	手术医生II助姓名	SSYSZ2XM	字符串	32	可选	
	麻醉医师工号	MZYSGH	字符串	16	可选	编码。见医护人员字典表
	麻醉医师姓名	MZYSXM	字符串	32	必填	
	麻醉方式	MZFS	字符串	16	必填	CV06.00.103麻醉方法代码表
	切口、愈合等级	QKYHDJ	字符串	4	必填	CV5501.14手术切口愈合等级代码。见说明（3）
	密级	MJ	字符串	16	可选	见就诊记录表的相关说明
	修改标志	XGBZ	数字	1	必填	编码。0：正常、1：撤销；YT3.1.011
	预留一	YLYL1	字符串	128	可选	为系统处理该数据而预留
	预留二	YLYL2	字符串	128	可选	为系统处理该数据而预留
	
	*/
	s (YLJGDM,SSMXLSH,KH,KLX,JZLSH,ZQSSBZ,MZZYBZ,RJSSBZ,SSLX,SSCZBM,SSCZMC,SSQZD,SSHZD,SSKSSJ,SSJSSJ,SSJB,SSYSGH,SSYSXM,SSYSZ1GH,SSYSZ1XM,SSYSZ2GH,SSYSZ2XM,MZYSGH,MZYSXM,MZFS,QKYHDJ,MJ,XGBZ,YLYL1,YLYL2)=""
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
		for {
		s tmpEpisodeID= $o(^PAADMi("DischDate",tmpdate,tmpEpisodeID))
		q:(tmpEpisodeID = "")
		s JZLSH=tmpEpisodeID
		
		s strpaid = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(tmpEpisodeID)
		s KH = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(strpaid)
		s KLX = 9
		s MZZYBZ=2
		s strRe  = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_tmpEpisodeID," "_"CG37"))
		continue:(strRe = "")
		//s arr=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,"HDSD00.11")
		s arr=##Class(EPRservice.BOScatterData).GetStandDataByGlossaryCategory(tmpEpisodeID,"HDSD00.11")
		for i=1:1:8 {
			
				s SSCZBM=$s(i=1:arr.GetAt("HDSD00.11.089"),i=2:arr.GetAt("HDSD00.11.410"),i=3:arr.GetAt("HDSD00.11.425"),i=4:arr.GetAt("HDSD00.11.440"),i=5:arr.GetAt("HDSD00.11.455"),i=6:arr.GetAt("HDSD00.11.470"),i=7:arr.GetAt("HDSD00.11.485"),i=8:arr.GetAt("HDSD00.11.500"),1:"")
				
				s SSCZMC=$s(i=1:arr.GetAt("HDSD00.11.090"),i=2:arr.GetAt("HDSD00.11.414"),i=3:arr.GetAt("HDSD00.11.429"),i=4:arr.GetAt("HDSD00.11.444"),i=5:arr.GetAt("HDSD00.11.459"),i=6:arr.GetAt("HDSD00.11.474"),i=7:arr.GetAt("HDSD00.11.489"),i=8:arr.GetAt("HDSD00.11.504"),1:"")
				continue:((SSCZBM="")&&(SSCZMC=""))
				s SSKSSJ=$s(i=1:arr.GetAt("HDSD00.11.091"),i=2:arr.GetAt("HDSD00.11.411"),i=3:arr.GetAt("HDSD00.11.426"),i=4:arr.GetAt("HDSD00.11.441"),i=5:arr.GetAt("HDSD00.11.456"),i=6:arr.GetAt("HDSD00.11.471"),i=7:arr.GetAt("HDSD00.11.486"),i=8:arr.GetAt("HDSD00.11.501"),1:"")
				s SSKSSJ=$p(SSKSSJ,"年",1)_$p($p(SSKSSJ,"年",2),"月",1)_$p($p(SSKSSJ,"月",2),"日",1)
				s SSJB=$s(i=1:arr.GetAt("HDSD00.11.092"),i=2:arr.GetAt("HDSD00.11.413"),i=3:arr.GetAt("HDSD00.11.428"),i=4:arr.GetAt("HDSD00.11.443"),i=5:arr.GetAt("HDSD00.11.458"),i=6:arr.GetAt("HDSD00.11.473"),i=7:arr.GetAt("HDSD00.11.488"),i=8:arr.GetAt("HDSD00.11.503"),1:"")
				s SSJB=$s(SSJB="一级":1,SSJB="二级":2,SSJB="三级":3,SSJB="四级":4)
				s SSYSGH=$s(i=1:arr.GetAt("HDSD00.11.407"),i=2:arr.GetAt("HDSD00.11.415"),i=3:arr.GetAt("HDSD00.11.430"),i=4:arr.GetAt("HDSD00.11.445"),i=5:arr.GetAt("HDSD00.11.460"),i=6:arr.GetAt("HDSD00.11.475"),i=7:arr.GetAt("HDSD00.11.490"),i=8:arr.GetAt("HDSD00.11.505"),1:"")
				s SSYSXM=$s(i=1:arr.GetAt("HDSD00.11.094"),i=2:arr.GetAt("HDSD00.11.416"),i=3:arr.GetAt("HDSD00.11.431"),i=4:arr.GetAt("HDSD00.11.446"),i=5:arr.GetAt("HDSD00.11.461"),i=6:arr.GetAt("HDSD00.11.476"),i=7:arr.GetAt("HDSD00.11.491"),i=8:arr.GetAt("HDSD00.11.506"),1:"")
			
				s SSYSZ1GH=$s(i=1:arr.GetAt("HDSD00.11.408"),i=2:arr.GetAt("HDSD00.11.417"),i=3:arr.GetAt("HDSD00.11.432"),i=4:arr.GetAt("HDSD00.11.447"),i=5:arr.GetAt("HDSD00.11.462"),i=6:arr.GetAt("HDSD00.11.477"),i=7:arr.GetAt("HDSD00.11.492"),i=8:arr.GetAt("HDSD00.11.507"),1:"")
				s SSYSZ1XM=$s(i=1:arr.GetAt("HDSD00.11.001"),i=2:arr.GetAt("HDSD00.11.418"),i=3:arr.GetAt("HDSD00.11.433"),i=4:arr.GetAt("HDSD00.11.448"),i=5:arr.GetAt("HDSD00.11.463"),i=6:arr.GetAt("HDSD00.11.478"),i=7:arr.GetAt("HDSD00.11.493"),i=8:arr.GetAt("HDSD00.11.508"),1:"")
			
				s SSYSZ2GH=$s(i=1:arr.GetAt("HDSD00.11.409"),i=2:arr.GetAt("HDSD00.11.419"),i=3:arr.GetAt("HDSD00.11.434"),i=4:arr.GetAt("HDSD00.11.449"),i=5:arr.GetAt("HDSD00.11.464"),i=6:arr.GetAt("HDSD00.11.479"),i=7:arr.GetAt("HDSD00.11.494"),i=8:arr.GetAt("HDSD00.11.509"),1:"")
				s SSYSZ2XM=$s(i=1:arr.GetAt("HDSD00.11.002"),i=2:arr.GetAt("HDSD00.11.420"),i=3:arr.GetAt("HDSD00.11.435"),i=4:arr.GetAt("HDSD00.11.450"),i=5:arr.GetAt("HDSD00.11.465"),i=6:arr.GetAt("HDSD00.11.480"),i=7:arr.GetAt("HDSD00.11.495"),i=8:arr.GetAt("HDSD00.11.510"),1:"")
			
				s MZYSXM=$s(i=1:arr.GetAt("HDSD00.11.074"),i=2:arr.GetAt("HDSD00.11.424"),i=3:arr.GetAt("HDSD00.11.439"),i=4:arr.GetAt("HDSD00.11.454"),i=5:arr.GetAt("HDSD00.11.469"),i=6:arr.GetAt("HDSD00.11.484"),i=7:arr.GetAt("HDSD00.11.499"),i=8:arr.GetAt("HDSD00.11.514"),1:"")
				s MZFS=$s(i=1:arr.GetAt("HDSD00.11.073"),i=2:arr.GetAt("HDSD00.11.423"),i=3:arr.GetAt("HDSD00.11.438"),i=4:arr.GetAt("HDSD00.11.453"),i=5:arr.GetAt("HDSD00.11.468"),i=6:arr.GetAt("HDSD00.11.483"),i=7:arr.GetAt("HDSD00.11.498"),i=8:arr.GetAt("HDSD00.11.513"),1:"")
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
				s MZFS=$s(MZFS="全身麻醉":1,MZFS="吸入麻醉 （气管内插管、喉罩、面罩）":11,MZFS="静脉麻醉 （全凭静脉麻醉）":12,MZFS="静吸复合麻醉":12,MZFS="基础麻醉 （直肠注入、肌肉注射）":13,1:MZFS)
				s MZFS=$s(MZFS="椎管内麻醉":2,MZFS="蛛网膜下腔阻滞麻醉":21,MZFS="硬脊椎外腔阻滞麻醉":22,1:MZFS)
				s MZFS=$s(MZFS="局部麻醉":3,MZFS="神经丛阻滞麻醉":31,MZFS="神经节阻滞麻醉":32,MZFS="神经阻滞麻醉":33,MZFS="局部阻滞麻醉":34,MZFS="局部浸润麻醉":35,MZFS="表面麻醉":36,1:MZFS)
				s MZFS=$s(MZFS="复合麻醉":4,MZFS="静吸复合全麻":41,MZFS="针药复合麻醉":42,MZFS="神经丛与硬膜外阻滞复合麻醉":43,MZFS="全麻复合全身降温":44,MZFS="全麻复合控制性降压":45,1:MZFS)
				s MZFS=$s(MZFS="其他":9,+$G(MZFS)>0:MZFS,1:9)
				
				s QKYHDJ=$s(i=1:arr.GetAt("HDSD00.11.082"),i=2:arr.GetAt("HDSD00.11.422"),i=3:arr.GetAt("HDSD00.11.437"),i=4:arr.GetAt("HDSD00.11.452"),i=5:arr.GetAt("HDSD00.11.467"),i=6:arr.GetAt("HDSD00.11.482"),i=7:arr.GetAt("HDSD00.11.497"),i=8:arr.GetAt("HDSD00.11.512"),1:"")
				
				s QKYHDJ=$s(QKYHDJ=0:0,QKYHDJ="Ⅰ/甲":11,QKYHDJ="Ⅰ/乙":12,QKYHDJ="Ⅰ/丙":13,QKYHDJ="Ⅰ/其他":14,1:QKYHDJ)
				s QKYHDJ=$s(QKYHDJ="Ⅱ/甲":21,QKYHDJ="Ⅱ/乙":22,QKYHDJ="Ⅱ/丙":23,QKYHDJ="Ⅱ/其他":24,1:QKYHDJ)
				s QKYHDJ=$s(QKYHDJ="Ⅲ/甲":31,QKYHDJ="Ⅲ/乙":32,QKYHDJ="Ⅲ/丙":33,QKYHDJ="Ⅲ/其他":34,1:QKYHDJ)
				
				s SSLX=9

				
				set ^CacheTemp(repid, ind) = $LB(YLJGDM,SSMXLSH,KH,KLX,JZLSH,ZQSSBZ,MZZYBZ,RJSSBZ,SSLX,SSCZBM,SSCZMC,SSQZD,SSHZD,SSKSSJ,SSJSSJ,SSJB,SSYSGH,SSYSXM,SSYSZ1GH,SSYSZ1XM,SSYSZ2GH,SSYSZ2XM,MZYSGH,MZYSXM,MZFS,QKYHDJ,MJ,XGBZ,YLYL1,YLYL2)
				set ind = ind + 1
		
			}
		}
	}
	
	
	
	
	
	
	Quit $$$OK
}

ClassMethod QueryQYHYOperDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryQYHYOperDetailExecute ]
{
	
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod QueryQYHYOperDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryQYHYOperDetailExecute ]
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

/// /d ##class(%ResultSet).RunQuery("web.DHCEPRInterfaceQYHY","QueryQYHYDiagDetail",1)
/// 青医附院海洋诊断明细
Query QueryQYHYDiagDetail(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "ZYZDLSH,YLJGDM,JZLSH,MZZYBZ,KH,KLX,ZDLXQF,ZDLB,ZDSJ,ZDBM,BMLX,ZDSM,CYZDBZ,YZDBZ,RYBQ,CYQKBM,MJ,XGBZ,YLYL1,YLYL2") [ SqlName = DZBL_TB_Diagnosis_Detail, SqlProc ]
{
}

ClassMethod QueryQYHYDiagDetailExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	/*
	诊断流水号	ZYZDLSH	字符串	64	必填	复合主键；见说明（1）
	医疗机构代码	YLJGDM	字符串	22	必填	复合主键
	就诊流水号	JZLSH	字符串	50	必填	用于与住院就诊记录表或门诊就诊记录表关联的外键
	门诊/住院标志	MZZYBZ	字符串	2	必填	1：门诊，2：住院YT3.1.033
	卡号	KH	字符串	32	必填	与患者信息表关联的外键，必须具备关联关系。
	卡类型	KLX	字符串	16	必填	
	诊断类型区分	ZDLXQF	字符串	1	必填	编码。1：西医、2：中医	YT3.1.061
	诊断类别代码	ZDLB	字符串	2	必填	西医采用CV5502.20，见说明（2）中医采用CV5502.21，见说明（3）
	诊断时间	ZDSJ	DATETIME		可选	　
	诊断编码	ZDBM	字符串	10	必填	西医：按ICD-10；中医：按国标-95 
	诊断编码类型	BMLX	字符串	2	必填	编码。01：ICD-10；02：国标-95；YT3.1.022
	诊断说明	ZDSM	字符串	512	可选	文字描述
	主要诊断标志	CYZDBZ	字符串	1	必填	编码。1：主要诊断、2：其他诊断YT3.1.062
	疑似诊断标志	YZDBZ	字符串	1	必填	1：仍疑似；0：已确诊YT3.1.063
	入院病情	RYBQ	字符串	1	必填	1.有，2.临床未确定，3.情况不明，4.无CV05.10.019
	出院情况编码	CYQKBM	字符串	1	可选	1：治愈、2：好转、3：未愈、4：死亡、5：其它（出院时 必填）；新版“病案首页”中取消.	CV5501.11
	密级	MJ	字符串	16	可选	见就诊记录表的相关说明
	修改标志	XGBZ	数字	1	必填	编码。0：正常、1：撤销；YT3.1.011
	预留一	YLYL1	字符串	128	可选	为系统处理该数据而预留
	预留二	YLYL2	字符串	128	可选	为系统处理该数据而预留
	*/
	s (ZYZDLSH,YLJGDM,JZLSH,MZZYBZ,KH,KLX,ZDLXQF,ZDLB,ZDSJ,ZDBM,BMLX,ZDSM,CYZDBZ,YZDBZ,RYBQ,CYQKBM,MJ,XGBZ,YLYL1,YLYL2)=""
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
		for {
		s tmpEpisodeID= $o(^PAADMi("DischDate",tmpdate,tmpEpisodeID))
		q:(tmpEpisodeID = "")
		s JZLSH=tmpEpisodeID
		s strpaid = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(tmpEpisodeID)
		s KH = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(strpaid)
		s KLX = 9
		s strRe  = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_tmpEpisodeID," "_"CG37"))
		continue:(strRe = "")
		//s arr=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,"HDSD00.11")
		s arr=##Class(EPRservice.BOScatterData).GetStandDataByGlossaryCategory(tmpEpisodeID,"HDSD00.11")
		for i=1:1:22 {
			
				s ZDBM=$s(i=1:arr.GetAt("HDSD00.11.023"),i=2:arr.GetAt("HDSD00.11.020"),i=3:arr.GetAt("HDSD00.11.307"),i=4:arr.GetAt("HDSD00.11.311"),i=5:arr.GetAt("HDSD00.11.315"),i=6:arr.GetAt("HDSD00.11.319"),i=7:arr.GetAt("HDSD00.11.323"),i=8:arr.GetAt("HDSD00.11.327"),i=9:arr.GetAt("HDSD00.11.331"),i=10:arr.GetAt("HDSD00.11.335"),i=11:arr.GetAt("HDSD00.11.339"),i=12:arr.GetAt("HDSD00.11.343"),i=13:arr.GetAt("HDSD00.11.347"),i=14:arr.GetAt("HDSD00.11.351"),i=15:arr.GetAt("HDSD00.11.355"),i=16:arr.GetAt("HDSD00.11.359"),i=17:arr.GetAt("HDSD00.11.363"),i=18:arr.GetAt("HDSD00.11.367"),i=19:arr.GetAt("HDSD00.11.371"),i=20:arr.GetAt("HDSD00.11.375"),i=21:arr.GetAt("HDSD00.11.379"),i=22:arr.GetAt("HDSD00.11.383"),1:"")
				s ZDSM=$s(i=1:arr.GetAt("HDSD00.11.024"),i=2:arr.GetAt("HDSD00.11.021"),i=3:arr.GetAt("HDSD00.11.306"),i=4:arr.GetAt("HDSD00.11.310"),i=5:arr.GetAt("HDSD00.11.314"),i=6:arr.GetAt("HDSD00.11.318"),i=7:arr.GetAt("HDSD00.11.322"),i=8:arr.GetAt("HDSD00.11.326"),i=9:arr.GetAt("HDSD00.11.330"),i=10:arr.GetAt("HDSD00.11.334"),i=11:arr.GetAt("HDSD00.11.338"),i=12:arr.GetAt("HDSD00.11.342"),i=13:arr.GetAt("HDSD00.11.346"),i=14:arr.GetAt("HDSD00.11.350"),i=15:arr.GetAt("HDSD00.11.354"),i=16:arr.GetAt("HDSD00.11.358"),i=17:arr.GetAt("HDSD00.11.362"),i=18:arr.GetAt("HDSD00.11.366"),i=19:arr.GetAt("HDSD00.11.370"),i=20:arr.GetAt("HDSD00.11.374"),i=21:arr.GetAt("HDSD00.11.378"),i=22:arr.GetAt("HDSD00.11.382"),1:"")
				s CYZDBZ=$s(i=1:1,1:2)
				s RYBQ=$s(i=1:arr.GetAt("HDSD00.11.025"),i=2:arr.GetAt("HDSD00.11.022"),i=3:arr.GetAt("HDSD00.11.308"),i=4:arr.GetAt("HDSD00.11.312"),i=5:arr.GetAt("HDSD00.11.316"),i=6:arr.GetAt("HDSD00.11.320"),i=7:arr.GetAt("HDSD00.11.324"),i=8:arr.GetAt("HDSD00.11.328"),i=9:arr.GetAt("HDSD00.11.332"),i=10:arr.GetAt("HDSD00.11.336"),i=11:arr.GetAt("HDSD00.11.340"),i=12:arr.GetAt("HDSD00.11.344"),i=13:arr.GetAt("HDSD00.11.348"),i=14:arr.GetAt("HDSD00.11.352"),i=15:arr.GetAt("HDSD00.11.356"),i=16:arr.GetAt("HDSD00.11.360"),i=17:arr.GetAt("HDSD00.11.364"),i=18:arr.GetAt("HDSD00.11.368"),i=19:arr.GetAt("HDSD00.11.372"),i=20:arr.GetAt("HDSD00.11.376"),i=21:arr.GetAt("HDSD00.11.380"),i=22:arr.GetAt("HDSD00.11.384"),1:"")	
				continue:((ZDBM="")&&(ZDSM=""))
				s ZYZDLSH=tmpEpisodeID
				//set ^CacheTemp(repid, ind) = $LB(ZYZDLSH,YLJGDM,SSMXLSH,KH,KLX,JZLSH,ZQSSBZ,MZZYBZ,RJSSBZ,SSLX,SSCZBM,SSCZMC,SSQZD,SSHZD,SSKSSJ,SSJSSJ,SSJB,SSYSGH,SSYSXM,SSYSZ1GH,SSYSZ1XM,SSYSZ2GH,SSYSZ2XM,MZYSGH,MZYSXM,MZFS,QKYHDJ,MJ,XGBZ,YLYL1,YLYL2)
				set ^CacheTemp(repid, ind) = $LB(ZYZDLSH,YLJGDM,JZLSH,MZZYBZ,KH,KLX,ZDLXQF,ZDLB,ZDSJ,ZDBM,BMLX,ZDSM,CYZDBZ,YZDBZ,RYBQ,CYQKBM,MJ,XGBZ,YLYL1,YLYL2)
				set ind = ind + 1
		
			}

		//set ^CacheTemp(repid, ind) = $LB(ZYZDLSH,YLJGDM,JZLSH,MZZYBZ,KH,KLX,ZDLXQF,ZDLB,ZDSJ,ZDBM,BMLX,ZDSM,CYZDBZ,YZDBZ,RYBQ,CYQKBM,MJ,XGBZ,YLYL1,YLYL2)
		//set ind = ind + 1
		}
	}
	Quit $$$OK
}

ClassMethod QueryQYHYDiagDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryQYHYDiagDetailExecute ]
{
	
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod QueryQYHYDiagDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryQYHYDiagDetailExecute ]
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

/// /d ##class(%ResultSet).RunQuery("web.DHCEPRInterfaceQYHY","QueryQYHYFirstPage","2015-12-05","2015-12-05")
/// 青医附院海洋住院病案首页主体表，出院小结表
Query QueryQYHYFirstPage(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "JZLSH,YLJGDM,RYSJ,RYLX,KH,KLX,BXLX,YLFFFS,ZYCS,BAH,CH,RYBQ,CYBQ,XM,XB,CSNY,XSECSTZ,XSERYTZ,HYZK,MZ,GJ,JG,CSD,SFZ,LXDH,GZDW,GZDWDH,GZDWYB,ZYBM,JZD,XZZDH,XZZYB,HKDZ,HKDH,HKYB,DQBM,QXBM,JDBM,LXRXM,LXRGX,LXRDZ,LXRDH,LXRTXDZ,RYKSBM,ZKKSBM1,ZKKSBM2,ZKKSBM3,SZBQ,CYSJ,CYKSBM,SJZYTS,CYFS,RYQK,RYQWYZZ,QZRQ,YYGRMC,YYGRJG,MZCYZD,RYCYZD,SQSHZD,LCBLZD,FSBLZD,SSZD,SSZDBM,YWGM,HBSAG_JG,HCVab_JG,HIVab_JG,QJCS,CGCS,SFCXWJN,SSDYL,XX,HXBSXL,XXBSXL,XJSXL,QXSXL,QTSXL,SXFY,CRBBG,ZLBG,XSEBG,SWBG,QTBG,SZ,SZQX,SZQXDW,SJBL,SJ,RSMDSC,XSEJBSC,CHCYL,XSE_XB,XSE_TZ,ZRYSGH,ZRYSXM,ZZYSGH,ZZYSXM,ZYYSGH,ZYYSXM,HSZGH,HSZXM,ZRHSGH,ZRHSXM,JXYSGH,JXYSXM,SXYSGH,SXYSXM,BMYGH,BMYXM,BAZL,ZKYSGH,ZKYSXM,ZKHSGH,ZKHSZM,ZKRQ,BLH,SWGBYY,SWSJ,MZYSGH,MZYSXM,SYFY,SFKYBA,LYFS,NJSYYMC,ZZYJH_31,RYQHMSJ,RYHHMSJ,ZYF,ZLF,ZHF,HLF,SSCLF,JCF,HYF,TSF,SPF,SXF,SYF,XYF,ZCYF,ZCAF,QTF,ZFY,ZFJE,YLFWF,ZLCZF,BLZDF,SYSZDF,YXXZDF,LCZDXMF,FSSZLXMF,LCWLZLF,SSZLF,MZF,SSF,KFF,ZYZLF,KJYWFY,XF,BDBZPF,QDBZPF,NXYZZPF,XBYZZPF,JCYYCLF,ZLYYCLF,SSYYCLF,QTF_1,KZRXM,KZRGH,FZRYSXM,FZRYSGH,ZLLB,SSLCLJ,ISJGZYZJ,ISZYZLSB,ISZYZLJS,ISBZSH,ZYBZLZF,ZYBZLZHZF,ZYZDF,ZYWZF,ZYGSF,ZCYJFF,ZYTNZLF,ZYGCZLF,ZYTSZLF,ZYQTF,ZYTSTPF,ZYZJF,BZ,MJ,XGBZ,YLYL1,YLYL2") [ SqlName = DZBL_TB_CIS_Main, SqlProc ]
{
}

ClassMethod QueryQYHYFirstPageExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	/*
	住院就诊流水号	JZLSH	字符串	50	必填	复合主键；医院HIS的唯一编号
	医疗机构代码	YLJGDM	字符串	22	必填	复合主键
	入院时间	RYSJ	DATETIME		必填	
	入院类型（途径）	RYLX	字符串	2	必填	编码。1：门诊入院、2：急诊入院、3：其他医疗机构转入、9：其他CV09.00.403
	卡号	KH	字符串	32	必填	必须与患者基本信息关联，见前述“挂号”的说明(7)以及相关说明。YT3.1.006
	卡类型	KLX	字符串	16	必填	
	保险类型	BXLX	字符串	20	可选	用来区分对象所属保险类型。见前述“挂号”的说明（5）YT3.1.003
	医疗付费方式	YLFFFS	字符串	4	可选	01.城镇职工基本医疗保险；02.城镇居民基本医疗保险；03.新型农村合作医疗；04.贫困救助；05.商业医疗保险；06.全公费；07.全自费；99.其他
	住院次数	ZYCS	整数	4	可选	对应于病案首页上的“第_次住院”
	病案号	BAH	字符串	32	必填	
	床号	CH	字符串	16	必填	
	入院病区（房）	RYBQ	字符串	32	必填	
	出院病区（房）	CYBQ	字符串	32	必填	
	姓名	XM	字符串	32	必填	
	性别	XB	字符串	1	必填	编码。按国标GB/T2261.1-2003
	出生日期	CSNY	字符串	8	必填	格式：YYYYMMDD
	新生儿出生体重	XSECSTZ	整数	6	可选	单位：克，精确到10克
	新生儿入院体重	XSERYTZ	整数	6	可选	单位：克，精确到10克
	婚姻状况	HYZK	字符串	2	必填	编码。婚姻GB/T2261.2-2003
	民族	MZ	字符串	2	可选	编码。按国标GB3304-91执行
	国籍	GJ	字符串	32	可选	直接上传中文
	籍贯	JG	字符串	64	可选	格式：“X省（区、市）X市
	出生地	CSD	字符串	128	可选	
	身份证号	SFZ	字符串	32	可选	如没有，请填入18个“0”。
	联系电话	LXDH	字符串	20	可选	
	工作单位	GZDW	字符串	64	可选	
	工作单位电话	GZDWDH	字符串	16	可选	
	工作单位邮编	GZDWYB	字符串	6	可选	
	职业	ZYBM	字符串	16	可选	编码。按国标GB/T6565-2009
	居住地（现住址）	JZD	字符串	128	可选	格式：“X省（区、市）X市X县”
	现住址电话	XZZDH	字符串	32	可选	
	现住址邮编	XZZYB	字符串	6	可选	
	户口地址	HKDZ	字符串	256	可选	格式：“X省（区、市）X市X县”
	户口电话	HKDH	字符串	32	可选	
	户口邮编	HKYB	字符串	6	可选	
	地区	DQBM	字符串	32	可选	直接上传中文
	区县	QXBM	字符串	16	可选	编码。按国标编码执行。
	街道	JDBM	字符串	16	可选	编码。卫生局的街道编码执行
	联系人姓名	LXRXM	字符串	32	可选	
	联系人关系	LXRGX	字符串	4	可选	编码。按国标GB/T4761-2008执行
	联系人地址	LXRDZ	字符串	128	可选	
	联系人电话	LXRDH	字符串	20	可选	
	联系人通信地址	LXRTXDZ	字符串	128	可选	
	入院科室编码	RYKSBM	字符串	20	可选	编码。见科室字典表
	转科科室编码1	ZKKSBM1	字符串	20	可选	编码。见科室字典表
	转科科室编码2	ZKKSBM2	字符串	20	可选	编码。见科室字典表
	转科科室编码3	ZKKSBM3	字符串	20	可选	编码。见科室字典表
	所转病区	SZBQ	字符串	128	可选	指“入院病区”和“出院病区”外，患者在本次住院中住过的所有病区。如有多个，以“,”间隔
	出院时间	CYSJ	DATETIME		必填	
	出院科室编码	CYKSBM	字符串	20	必填	编码。见科室字典表
	实际住院天数	SJZYTS	数字	4	必填	
	出院方式	CYFS	字符串	1	必填	编码。1：常规、2：自动、3：转院YT3.1.040
	入院时情况	RYQK	字符串	1	必填	CV5501.12入院病情代码。1危重、2：急诊、3：一般、9：其他	CV5501.12新版“病案首页”中取消
	入院前经外院诊治	RYQWYZZ	字符串	1	可选	编码。1：有、2：无YT3.1.042
	确诊日期	QZRQ	字符串	8	可选	YYYYMMDD
	医院感染名称	YYGRMC	字符串	128	可选	按《卫生部关于印发医院感染诊断标准（试行）的通知》（卫医发[2001]2号）执行；新版“病案首页”中取消
	医院感染结果	YYGRJG	字符串	1	可选	编码。1：治愈、2：好转、3：未愈、4：死亡、5：其它；新版“病案首页”中取消.CV5501.11
	门诊出院诊断符合编码	MZCYZD	字符串	1	可选	CV5501.13诊断符合情况代码。0：未作、1：符合、2：不符合、X：诊断符合情况扩充内容、9：无对照
	入院出院诊断符合编码	RYCYZD	字符串	1	可选	同上述门诊出院诊断符合编码。
	术前术后诊断符合编码	SQSHZD	字符串	1	可选	同上述门诊出院诊断符合编码。
	临床病理诊断符合编码	LCBLZD	字符串	1	可选	同上述门诊出院诊断符合编码。
	放射病理诊断符合编码	FSBLZD	字符串	1	可选	同上述门诊出院诊断符合编码。
	损伤中毒的外部因素	SSZD	字符串	256	可选	填写造成损伤的外部原因及引起中毒的物质
	损伤中毒的外部原因的疾病编码	SSZDBM	字符串	10	可选	ICD-10
	药物过敏	YWGM	字符串	256	可选	填写具体药物的名称，多种以“;”间隔，没有必填“无”
	HBSAG检查结果编码	HBSAG_JG	字符串	1	可选	编码。0：未作、1：阴性、2：阳性；新版“病案首页”中取消YT3.1.036
	HCVab检查结果编码	HCVab_JG	字符串	1	可选	编码。0：未作、1：阴性、2：阳性；新版“病案首页”中取消YT3.1.036
	HIVab检查结果编码	HIVab_JG	字符串	1	可选	编码。0：未作、1：阴性、2：阳性；新版“病案首页”中取消YT3.1.036
	抢救次数	QJCS	数字	4,0	可选	
	成功次数	CGCS	数字	4,0	可选	
	住院是否出现危重、急症、疑难	SFCXWJN	字符串	3	可选	编码。见说明（1）
	手术治疗检查诊断为本院第一例	SSDYL	字符串	4	必填	编码。1：是、2：否。新版“病案首页”中取消 YT3.1.054
	血型	XX	字符串	2	可选	CV04.50.005ABO血型代码表。见说明（2）
	红细胞输血量	HXBSXL	数字	8,1	可选	计量单位：单位；新版“病案首页”中取消
	血小板输血量	XXBSXL	数字	8,1	可选	计量单位：袋；新版“病案首页”中取消
	血浆输血量	XJSXL	数字	8,1	可选	计量单位：ml；新版“病案首页”中取消
	全血输血量	QXSXL	数字	8,1	可选	计量单位：ml；新版“病案首页”中取消
	其它输血量	QTSXL	数字	8,1	可选	计量单位：ml；新版“病案首页”中取消
	有输血反应	SXFY	字符串	1	可选	编码。1：有、2：无；新版“病案首页”中取消
	有传染病报告	CRBBG	字符串	1	可选	编码。1：有、2：无YT3.1.055
	有肿瘤报告	ZLBG	字符串	1	可选	编码。1：有、2：无YT3.1.055
	有新生儿死亡报告	XSEBG	字符串	1	可选	编码。1：有、2：无YT3.1.055
	孕产妇死亡报告	SWBG	字符串	1	可选	编码。1：有、2：无YT3.1.055
	有其它报告	QTBG	字符串	1	可选	编码。1：有、2：无YT3.1.055
	是否随诊	SZ	字符串	1	可选	编码。1：是、2：否；新版“病案首页”中取消YT3.1.054
	随诊期限	SZQX	数字	8,1	可选	新版“病案首页”中取消
	随诊期限单位	SZQXDW	字符	1	可选	编码。1：周、2：月、3：年；新版“病案首页”中取消YT3.1.056
	是否示教病例	SJBL	字符串	1	可选	编码。1：是、2：否YT3.1.055
	（死亡患者）是否尸检	SJ	字符串	1	可选	编码。1：是、2：否YT3.1.055
	是否妊娠梅毒筛查	RSMDSC	字符串	1	可选	编码。1：是、2：否YT3.1.055
	新生儿疾病筛查	XSEJBSC	字符串	3	可选	编码。见说明（3）
	产后出血量	CHCYL	数字	8,1	可选	单位为ml
	新生儿性别	XSE_XB	字符串	1	可选	编码。按国标GB/T2261.1-2003
	新生儿体重	XSE_TZ	数字	8,1	可选	单位为g；新版“病案首页”中取消
	主任医师工号	ZRYSGH	字符串	16	可选	编码。见医护人员字典表
	主任医师姓名	ZRYSXM	字符串	32	必填	
	主治医师工号	ZZYSGH	字符串	16	可选	编码。见医护人员字典表
	主治医师姓名	ZZYSXM	字符串	32	必填	
	住院医师工号	ZYYSGH	字符串	16	可选	编码。见医护人员字典表
	住院医师姓名	ZYYSXM	字符串	32	必填	
	护士长工号	HSZGH	字符串	16	可选	编码。见医护人员字典表
	护士长姓名	HSZXM	字符串	32	可选	
	责任护士工号	ZRHSGH	字符串	16	可选	编码。见医护人员字典表
	责任护士姓名	ZRHSXM	字符串	32	可选	
	进修医师工号	JXYSGH	字符串	16	可选	编码。见医护人员字典表
	进修医师姓名	JXYSXM	字符串	32	可选	
	实习医师工号	SXYSGH	字符串	16	可选	编码。见医护人员字典表
	实习医师姓名	SXYSXM	字符串	32	可选	
	编码员工号	BMYGH	字符串	16	可选	
	编码员姓名	BMYXM	字符串	32	可选	
	病案质量	BAZL	字符串	1	必填	CV5501.15病案质量代码。1：甲、2：乙、3：丙
	质控医师工号	ZKYSGH	字符串	16	可选	编码。见医护人员字典表
	质控医师姓名	ZKYSXM	字符串	32	必填	
	质控护士工号	ZKHSGH	字符串	16	可选	编码。见医护人员字典表
	质控护士姓名	ZKHSZM	字符串	32	可选	
	质控日期	ZKRQ	DATETIME		可选	
	病理号	BLH	字符串	64	可选	
	死亡根本原因	SWGBYY	字符串	256	可选	
	死亡时间	SWSJ	DATETIME		可选	
	门诊医师工号	MZYSGH	字符串	16	可选	编码：医护人员字典表
	门诊医师姓名	MZYSXM	字符串	32	必填	
	输液反应	SYFY	字符串	1	可选	编码。1：有输、2：有反应、3：未输YT3.1.057
	是否为科研病案	SFKYBA	字符串	1	可选	编码。1：是、2：否YT3.1.054
	离院方式	LYFS	字符串	1	可选	编码。1.医嘱离院  2.医嘱转院，拟接收医疗机构名称 3.医嘱转社区卫生服务机构/乡镇卫生院，拟接收医疗机构名称 4.非医嘱离院5.死亡9.其他CV06.00.226
	离院后拟接收医疗机构名称	NJSYYMC	字符串	32	可选	“离院方式”填2和3时，必填写此项
	是否有出院31天内再住院计划	ZZYJH_31	字符串	32	可选	如有，请填写再入院目的；否则填写“无”
	颅脑损伤患者入院前昏迷时间	RYQHMSJ	字符串	20	可选	格式：“X天X小时X分钟”
	颅脑损伤患者入院后昏迷时间	RYHHMSJ	字符串	20	可选	格式：“X天X小时X分钟”
	住院费	ZYF	数字	12,3	必填	收退费均以正数表达，口径按医保
	诊疗费	ZLF	数字	12,3	必填	同上
	治疗费	ZHF	数字	12,3	必填	同上
	护理费	HLF	数字	12,3	必填	同上，即新版“病案首页”中的（3）
	手术材料费	SSCLF	数字	12,3	必填	同上
	检查费	JCF	数字	12,3	必填	同上
	化验费	HYF	数字	12,3	必填	同上
	透视费	TSF	数字	12,3	必填	同上
	摄片费	SPF	数字	12,3	必填	同上
	输血费	SXF	数字	12,3	必填	同上
	输氧费	SYF	数字	12,3	必填	同上
	西药费	XYF	数字	12,3	必填	同上，即新版“病案首页”中的（13）
	中成药费	ZCYF	数字	12,3	必填	同上，即新版“病案首页”中的（14）
	中草药费	ZCAF	数字	12,3	必填	同上，即新版“病案首页”中的（15）
	其他费用	QTF	数字	12,3	必填	同上，即新版“病案首页”中的（4）
	总费用	ZFY	数字	12,3	可选	
	自付金额	ZFJE	数字	12,3	可选	
	一般医疗服务费	YLFWF	数字	12,3	可选	即新版“病案首页”中的（1）
	一般治疗操作费	ZLCZF	数字	12,3	可选	即新版“病案首页”中的（2）
	病理诊断费	BLZDF	数字	12,3	可选	即新版“病案首页”中的（5）
	实验室诊断费	SYSZDF	数字	12,3	可选	即新版“病案首页”中的（6）
	影像学诊断费	YXXZDF	数字	12,3	可选	即新版“病案首页”中的（7）
	临床诊断项目费	LCZDXMF	数字	12,3	可选	即新版“病案首页”中的（8）
	非手术治疗项目费	FSSZLXMF	数字	12,3	可选	即新版“病案首页”中的（9）
	临床物理治疗费	LCWLZLF	数字	12,3	可选	
	手术治疗费	SSZLF	数字	12,3	可选	即新版“病案首页”中的（10）
	麻醉费	MZF	数字	12,3	可选	
	手术费	SSF	数字	12,3	可选	
	康复费	KFF	数字	12,3	可选	即新版“病案首页”中的（11）
	中医治疗费	ZYZLF	数字	12,3	可选	即新版“病案首页”中的（12）
	抗菌药物费用	KJYWFY	数字	12,3	可选	
	血费	XF	数字	12,3	可选	即新版“病案首页”中的（16）
	白蛋白类制品费	BDBZPF	数字	12,3	可选	即新版“病案首页”中的（17）
	球蛋白类制品费	QDBZPF	数字	12,3	可选	即新版“病案首页”中的（18）
	凝血因子类制品费	NXYZZPF	数字	12,3	可选	即新版“病案首页”中的（19）
	细胞因子类制品费	XBYZZPF	数字	12,3	可选	即新版“病案首页”中的（20）
	检查用一次性医用材料费	JCYYCLF	数字	12,3	可选	即新版“病案首页”中的（21）
	治疗用一次性医用材料费	ZLYYCLF	数字	12,3	可选	即新版“病案首页”中的（22）
	手术用一次性医用材料费	SSYYCLF	数字	12,3	可选	即新版“病案首页”中的（23）
	其他费	QTF_1	数字	12,3	可选	即新版“病案首页”中的（24）
	科主任姓名	KZRXM	字符串	32	必填	
	科主任工号	KZRGH	字符串	16	可选	编码。见医护人员字典表
	副主任医师姓名	FZRYSXM	字符串	32	必填	
	副主任医师工号	FZRYSGH	字符串	16	可选	编码。见医护人员字典表
	治疗类别	ZLLB	字符串	2	可选	中医病案首页填写；1.中医（ 1.1 中医   1.2民族医）  2.中西医  3.西医CV06.00.225
	实施临床路径	SSLCLJ	字符串	1	可选	中医病案首页填写；1. 中医  2. 西医  3.否YT3.1.059
	使用医疗机构中药制剂	ISJGZYZJ	字符串	1	可选	中医病案首页填写；1.是  2. 否YT3.1.054
	使用中医诊疗设备	ISZYZLSB	字符串	1	可选	中医病案首页填写；1.是  2. 否YT3.1.054
	使用中医诊疗技术	ISZYZLJS	字符串	1	可选	中医病案首页填写；1.是  2. 否YT3.1.054
	辨证施护	ISBZSH	字符串	1	可选	中医病案首页填写；1.是  2. 否YT3.1.054
	中医辨证论治费	ZYBZLZF	数字	12,3	可选	中医病案首页填写
	中医辨证论治会诊费	ZYBZLZHZF	数字	12,3	可选	中医病案首页填写
	中医诊断费	ZYZDF	数字	12,3	可选	中医病案首页填写
	中医外治费	ZYWZF	数字	12,3	可选	中医病案首页填写
	中医骨伤费	ZYGSF	数字	12,3	可选	中医病案首页填写
	针刺与灸法费	ZCYJFF	数字	12,3	可选	中医病案首页填写
	中医推拿治疗费	ZYTNZLF	数字	12,3	可选	中医病案首页填写
	中医肛肠治疗费	ZYGCZLF	数字	12,3	可选	中医病案首页填写
	中医特殊治疗费	ZYTSZLF	数字	12,3	可选	中医病案首页填写
	中医其他费	ZYQTF	数字	12,3	可选	中医病案首页填写
	中药特殊调配加工费	ZYTSTPF	数字	12,3	可选	中医病案首页填写
	医疗机构中药制剂费	ZYZJF	数字	12,3	可选	中医病案首页填写
	备注	BZ	字符串	256	可选	
	密级	MJ	字符串	16	可选	见就诊记录表的说明
	修改标志	XGBZ	数字	1	必填	编码。0：正常、1：撤销；YT3.1.011见说明（4）
	预留一	YLYL1	字符串	128	可选	为系统处理该数据而预留
	预留二	YLYL2	字符串	128	可选	为系统处理该数据而预留
	*/
	
	s (JZLSH,YLJGDM,RYSJ,RYLX,KH,KLX,BXLX,YLFFFS,ZYCS,BAH,CH,RYBQ,CYBQ,XM,XB,CSNY,XSECSTZ,XSERYTZ,HYZK,MZ,GJ,JG,CSD,SFZ,LXDH,GZDW,GZDWDH,GZDWYB,ZYBM,JZD,XZZDH,XZZYB,HKDZ,HKDH,HKYB,DQBM,QXBM,JDBM)=""
	s (LXRXM,LXRGX,LXRDZ,LXRDH,LXRTXDZ,RYKSBM,ZKKSBM1,ZKKSBM2,ZKKSBM3,SZBQ,CYSJ,CYKSBM,SJZYTS,CYFS,RYQK,RYQWYZZ,QZRQ,YYGRMC,YYGRJG,MZCYZD,RYCYZD,SQSHZD,LCBLZD,FSBLZD,SSZD,SSZDBM,YWGM,HBSAGJG,HCVabJG)=""
	s (HIVabJG,QJCS,CGCS,SFCXWJN,SSDYL,XX,HXBSXL,XXBSXL,XJSXL,QXSXL,QTSXL,SXFY,CRBBG,ZLBG,XSEBG,SWBG,QTBG,SZ,SZQX,SZQXDW,SJBL,SJ,RSMDSC,XSEJBSC,CHCYL,XSEXB,XSETZ,ZRYSGH,ZRYSXM,ZZYSGH,ZZYSXM,ZYYSGH,ZYYSXM)=""
	s (HSZGH,HSZXM,ZRHSGH,ZRHSXM,JXYSGH,JXYSXM,SXYSGH,SXYSXM,BMYGH,BMYXM,BAZL,ZKYSGH,ZKYSXM,ZKHSGH,ZKHSZM,ZKRQ,BLH,SWGBYY,SWSJ,MZYSGH,MZYSXM,SYFY,SFKYBA,LYFS,NJSYYMC,ZZYJH31,RYQHMSJ,RYHHMSJ,ZYF,ZLF,ZHF,HLF)=""
	s (SSCLF,JCF,HYF,TSF,SPF,SXF,SYF,XYF,ZCYF,ZCAF,QTF,ZFY,ZFJE,YLFWF,ZLCZF,BLZDF,SYSZDF,YXXZDF,LCZDXMF,FSSZLXMF,LCWLZLF,SSZLF,MZF,SSF,KFF,ZYZLF,KJYWFY,XF,BDBZPF,QDBZPF,NXYZZPF,XBYZZPF,JCYYCLF,ZLYYCLF,SSYYCLF)=""
	s (QTF1,KZRXM,KZRGH,FZRYSXM,FZRYSGH,ZLLB,SSLCLJ,ISJGZYZJ,ISZYZLSB,ISZYZLJS,ISBZSH,ZYBZLZF,ZYBZLZHZF,ZYZDF,ZYWZF,ZYGSF,ZCYJFF,ZYTNZLF,ZYGCZLF,ZYTSZLF,ZYQTF,ZYTSTPF,ZYZJF,BZ,MJ,XGBZ,YLYL1,YLYL2)=""
	
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
		for {
		s tmpEpisodeID= $o(^PAADMi("DischDate",tmpdate,tmpEpisodeID))
		q:(tmpEpisodeID = "")
		s strpaid = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(tmpEpisodeID)
		s KH = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(strpaid)
		s KLX = 9
		s JZLSH=tmpEpisodeID
		s strRe  = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_tmpEpisodeID," "_"CG37"))
		continue:(strRe = "")
		//s arr=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,"HDSD00.11")
		s arr=##Class(EPRservice.BOScatterData).GetStandDataByGlossaryCategory(tmpEpisodeID,"HDSD00.11")
		//入院时间
			s RYSJ=arr.GetAt("HDSD00.11.085")
		//入院类型（途径）
			s RYLX=arr.GetAt("HDSD00.11.086")
			s RYLX=$s(RYLX="门诊":1,RYLX="急诊":2,RYLX="其他医疗机构转入":3,RYLX="其他":9,1:9)
		//医疗付费方式
			s YLFFFS=arr.GetAt("HDSD00.11.117")
		//住院次数
			s ZYCS=arr.GetAt("HDSD00.11.139")
		//病案号
			s BAH=arr.GetAt("HDSD00.11.006")
		//入院病区（房）
			s RYBQ=arr.GetAt("HDSD00.11.083")
		//出院病区（房）
			s CYBQ=arr.GetAt("HDSD00.11.017")
		//姓名
			s XM=arr.GetAt("HDSD00.11.110")
		//性别
			s XB=arr.GetAt("HDSD00.11.109")
			s XB=$s(XB="男":1,XB="女":2,1:9)
		//出生日期
			s CSNY=arr.GetAt("HDSD00.11.014")
			
			s CSNY=$P(CSNY,"年",1)_$P($p(CSNY,"年",2),"月",1)_$P($p(CSNY,"月",2),"日",1)
		//新生儿出生体重
			s XSECSTZ=arr.GetAt("HDSD00.11.107")
		//新生儿入院体重
			s XSERYTZ=arr.GetAt("HDSD00.11.108")
		//婚姻状况
			s HYZK=arr.GetAt("HDSD00.11.050")
			s HYZK=$s(HYZK="未婚":10,HYZK="已婚":20,HYZK="初婚":21,HYZK="再婚":22,HYZK="复婚":23,HYZK="丧偶":30,HYZK="离婚":40,HYZK="其他":90,10:90)
		//民族
			s MZ=arr.GetAt("HDSD00.11.077")
		//国籍
			s GJ=arr.GetAt("HDSD00.11.563")
		//籍贯
			s JG=arr.GetAt("HDSD00.11.051")
		//出生地
			s CSD=arr.GetAt("HDSD00.11.011")
		//身份证号
			s SFZ=arr.GetAt("HDSD00.11.048")
		//联系电话
			s LXDH=arr.GetAt("HDSD00.11.064")
		//工作单位
			s GZDW=arr.GetAt("HDSD00.11.035")
		//工作单位电话
			s GZDWDH=arr.GetAt("HDSD00.11.034")
		//工作单位邮编
			s GZDWYB=arr.GetAt("HDSD00.11.033")
		//职业
			s ZYBM=arr.GetAt("HDSD00.11.564")
		//居住地（现住址）
			s JZD=arr.GetAt("HDSD00.11.102")
		//现住址电话
			s XZZDH=arr.GetAt("HDSD00.11.026")
		//现住址邮编
			s XZZYB=arr.GetAt("HDSD00.11.106")
		//户口地址
			s HKDZ=arr.GetAt("HDSD00.11.043")
		//户口电话
			s HKDH=arr.GetAt("HDSD00.11.2999")
		//户口邮编
			s HKYB=arr.GetAt("HDSD00.11.047")
		//地区
			s DQBM=arr.GetAt("HDSD00.11.3999")
		//区县
			s QXBM=arr.GetAt("HDSD00.11.4999")
		//街道
			s JDBM=arr.GetAt("HDSD00.11.5999")
		//联系人姓名
			s LXRXM=arr.GetAt("HDSD00.11.065")
		//联系人关系
			s LXRGX=arr.GetAt("HDSD00.11.066")
		//联系人地址
			s LXRDZ=arr.GetAt("HDSD00.11.060")
		//联系人电话
			s LXRDH=arr.GetAt("HDSD00.11.064")
		//联系人通信地址
			s LXRTXDZ=arr.GetAt("HDSD00.11.060")
		//入院科室编码
			s RYKSBM=arr.GetAt("HDSD00.11.084")
		//转科科室编码1
			s ZKKSBM1=arr.GetAt("HDSD00.11.144")
		//出院时间
			s CYSJ=arr.GetAt("HDSD00.11.019")
		//出院科室编码
			s CYKSBM=arr.GetAt("HDSD00.11.049")
		//实际住院天数
			s SJZYTS=arr.GetAt("HDSD00.11.087")
		//损伤中毒的外部因素
			s SSZD=arr.GetAt("HDSD00.11.096")
		//损伤中毒的外部原因的疾病编码
			s SSZDBM=arr.GetAt("HDSD00.11.097")
		//药物过敏
			s YWGM=arr.GetAt("HDSD00.11.116")
		//抢救次数
			s QJCS=arr.GetAt("HDSD00.11.569")
		//成功次数
			s CGCS=arr.GetAt("HDSD00.11.570")
		//血型
			s XX=arr.GetAt("HDSD00.11.597")
		//红细胞输血量
			s HXBSXL=arr.GetAt("HDSD00.11.994")
		//血小板输血量
			s XXBSXL=arr.GetAt("HDSD00.11.995")
		//血浆输血量
			s XJSXL=arr.GetAt("HDSD00.11.996")
		//全血输血量
			s QXSXL=arr.GetAt("HDSD00.11.997")
		//其它输血量
			s QTSXL=arr.GetAt("HDSD00.11.999")
		//有输血反应
			s SXFY=arr.GetAt("HDSD00.11.601")
		//有肿瘤报告
			s ZLBG=arr.GetAt("HDSD00.11.728")
		//是否随诊
			s SZ=arr.GetAt("HDSD00.11.571")
		//随诊期限
			s SZQX=arr.GetAt("HDSD00.11.572")
		//随诊期限单位
			s SZQXDW=arr.GetAt("HDSD00.11.991")
		//是否示教病例
			s SJBL=arr.GetAt("HDSD00.11.891")
		//（死亡患者）是否尸检
			s SJ=arr.GetAt("HDSD00.11.095")
		//新生儿性别
			s XSEXB=arr.GetAt("HDSD00.11.676")
		//新生儿体重
			s XSETZ=arr.GetAt("HDSD00.11.680")
		//主任医师姓名
			s ZRYSXM=arr.GetAt("HDSD00.11.137")
		//主治医师姓名
			s ZZYSXM=arr.GetAt("HDSD00.11.138")
		//住院医师姓名
			s ZYYSXM=arr.GetAt("HDSD00.11.141")
		//责任护士姓名
			s ZRHSXM=arr.GetAt("HDSD00.11.120")
		//进修医师姓名
			s JXYSXM=arr.GetAt("HDSD00.11.054")
		//实习医师姓名
			s SXYSXM=arr.GetAt("HDSD00.11.088")
		//编码员姓名
			s BMYXM=arr.GetAt("HDSD00.11.005")
		//病案质量
			s BAZL=arr.GetAt("HDSD00.11.007")
			s BAZL=$s(BAZL="甲":1,BAZL="乙":2,BAZL="丙":3,1:9)
		//质控医师姓名
			s ZKYSXM=arr.GetAt("HDSD00.11.128")
		//质控护士姓名
			s ZKHSZM=arr.GetAt("HDSD00.11.126")
		//质控日期
			s ZKRQ=arr.GetAt("HDSD00.11.127")
		//病理号
			s BLH=arr.GetAt("HDSD00.11.008")
		//死亡时间
			s SWSJ=arr.GetAt("HDSD00.11.019")
		//输液反应
			s SYFY=arr.GetAt("HDSD00.11.599")
		//离院方式
			s LYFS=arr.GetAt("HDSD00.11.603")
		//离院后拟接收医疗机构名称
			s NJSYYMC=arr.GetAt("HDSD00.11.078")
		//是否有出院31天内再住院计划
			s ZZYJH31=arr.GetAt("HDSD00.11.015")
		//颅脑损伤患者入院前昏迷时间
			s RYQHMSJ=arr.GetAt("HDSD00.11.070")
		//颅脑损伤患者入院后昏迷时间
			s RYHHMSJ=arr.GetAt("HDSD00.11.067")
		//总费用
			s ZFY=arr.GetAt("HDSD00.11.142")
		//自付金额
			s ZFJE=arr.GetAt("HDSD00.11.143")
		//一般医疗服务费
			s YLFWF=arr.GetAt("HDSD00.11.147")
		//一般治疗操作费
			s ZLCZF=arr.GetAt("HDSD00.11.148")
		//病理诊断费
			s BLZDF=arr.GetAt("HDSD00.11.121")
		//实验室诊断费
			s SYSZDF=arr.GetAt("HDSD00.11.149")
		//影像学诊断费
			s YXXZDF=arr.GetAt("HDSD00.11.123")
		//临床诊断项目费
			s LCZDXMF=arr.GetAt("HDSD00.11.122")
		//非手术治疗项目费
			s FSSZLXMF=arr.GetAt("HDSD00.11.129")
		//临床物理治疗费
			s LCWLZLF=arr.GetAt("HDSD00.11.130")
		//手术治疗费
			s SSZLF=arr.GetAt("HDSD00.11.131")
		//麻醉费
			s MZF=arr.GetAt("HDSD00.11.132")
		//手术费
			s SSF=arr.GetAt("HDSD00.11.133")
		//康复费
			s KFF=arr.GetAt("HDSD00.11.055")
		//中医治疗费
			s ZYZLF=arr.GetAt("HDSD00.11.136")
		//抗菌药物费用
			s KJYWFY=arr.GetAt("HDSD00.11.099")
		//血费
			s XF=arr.GetAt("HDSD00.11.115")
		//白蛋白类制品费
			s BDBZPF=arr.GetAt("HDSD00.11.111")
		//球蛋白类制品费
			s QDBZPF=arr.GetAt("HDSD00.11.113")
		//凝血因子类制品费
			s NXYZZPF=arr.GetAt("HDSD00.11.112")
		//细胞因子类制品费
			s XBYZZPF=arr.GetAt("HDSD00.11.114")
		//检查用一次性医用材料费
			s JCYYCLF=arr.GetAt("HDSD00.11.038")
		//治疗用一次性医用材料费
			s ZLYYCLF=arr.GetAt("HDSD00.11.040")
		//手术用一次性医用材料费
			s SSYYCLF=arr.GetAt("HDSD00.11.039")
		//其他费
			s QTF1=arr.GetAt("HDSD00.11.081")
		//科主任姓名
			//s KZRXM=arr.GetAt("HDSD00.11.575")
			s KZRXM=arr.GetAt("HDSD00.11.056")
		//副主任医师姓名
			//s FZRYSXM=arr.GetAt("HDSD00.11.576")
			s FZRYSXM=arr.GetAt("HDSD00.11.137")
		//实施临床路径
			s SSLCLJ=arr.GetAt("HDSD00.11.594")
	
	
	
	
		set ^CacheTemp(repid, ind) = $LB(JZLSH,YLJGDM,RYSJ,RYLX,KH,KLX,BXLX,YLFFFS,ZYCS,BAH,CH,RYBQ,CYBQ,XM,XB,CSNY,XSECSTZ,XSERYTZ,HYZK,MZ,GJ,JG,CSD,SFZ,LXDH,GZDW,GZDWDH,GZDWYB,ZYBM,JZD,XZZDH,XZZYB,HKDZ,HKDH,HKYB,DQBM,QXBM,JDBM,LXRXM,LXRGX,LXRDZ,LXRDH,LXRTXDZ,RYKSBM,ZKKSBM1,ZKKSBM2,ZKKSBM3,SZBQ,CYSJ,CYKSBM,SJZYTS,CYFS,RYQK,RYQWYZZ,QZRQ,YYGRMC,YYGRJG,MZCYZD,RYCYZD,SQSHZD,LCBLZD,FSBLZD,SSZD,SSZDBM,YWGM,HBSAGJG,HCVabJG,HIVabJG,QJCS,CGCS,SFCXWJN,SSDYL,XX,HXBSXL,XXBSXL,XJSXL,QXSXL,QTSXL,SXFY,CRBBG,ZLBG,XSEBG,SWBG,QTBG,SZ,SZQX,SZQXDW,SJBL,SJ,RSMDSC,XSEJBSC,CHCYL,XSEXB,XSETZ,ZRYSGH,ZRYSXM,ZZYSGH,ZZYSXM,ZYYSGH,ZYYSXM,HSZGH,HSZXM,ZRHSGH,ZRHSXM,JXYSGH,JXYSXM,SXYSGH,SXYSXM,BMYGH,BMYXM,BAZL,ZKYSGH,ZKYSXM,ZKHSGH,ZKHSZM,ZKRQ,BLH,SWGBYY,SWSJ,MZYSGH,MZYSXM,SYFY,SFKYBA,LYFS,NJSYYMC,ZZYJH31,RYQHMSJ,RYHHMSJ,ZYF,ZLF,ZHF,HLF,SSCLF,JCF,HYF,TSF,SPF,SXF,SYF,XYF,ZCYF,ZCAF,QTF,ZFY,ZFJE,YLFWF,ZLCZF,BLZDF,SYSZDF,YXXZDF,LCZDXMF,FSSZLXMF,LCWLZLF,SSZLF,MZF,SSF,KFF,ZYZLF,KJYWFY,XF,BDBZPF,QDBZPF,NXYZZPF,XBYZZPF,JCYYCLF,ZLYYCLF,SSYYCLF,QTF1,KZRXM,KZRGH,FZRYSXM,FZRYSGH,ZLLB,SSLCLJ,ISJGZYZJ,ISZYZLSB,ISZYZLJS,ISBZSH,ZYBZLZF,ZYBZLZHZF,ZYZDF,ZYWZF,ZYGSF,ZCYJFF,ZYTNZLF,ZYGCZLF,ZYTSZLF,ZYQTF,ZYTSTPF,ZYZJF,BZ,MJ,XGBZ,YLYL1,YLYL2)
		set ind = ind + 1
		}
	}
	Quit $$$OK
}

ClassMethod QueryQYHYFirstPageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryQYHYFirstPageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod QueryQYHYFirstPageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryQYHYFirstPageExecute ]
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

/// /d ##class(%ResultSet).RunQuery("web.DHCEPRInterfaceQYHY","QueryQYHYDischEMR","2015-12-05","2015-12-05")
/// 青医附院海洋住院病案首页主体表，出院小结表
Query QueryQYHYDischEMR(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "JZLSH,YLJGDM,KS,KSMC,KH,KLX,CH,XM,XB,NL,RYSJ,CYSJ,ZYTS,MZZD,RYZD,CYZD,RYZZTZ,JCHZ,TSJC,ZLGC,HBZ,CYQK,CYYZ,ZLJG,ZLJGMS,ZZYSGH,ZZYSXM,ZYYSGH,ZYYSXM,YYZTB1,YYZTB2,WJLJ,XGBZ,MJ,YLYL1,YLYL2") [ SqlName = DZBL_TB_CIS_LH_Summary, SqlProc ]
{
}

ClassMethod QueryQYHYDischEMRExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	/*
	
	住院就诊流水号	JZLSH	字符串	50	必填	复合主键；同时用于与住院就诊记录表关联的外键
	医疗机构代码	YLJGDM	字符串	22	必填	复合主键
	科室	KS	字符串	15	必填	编码。见科室字典表
	科室名称	KSMC	字符串	30	必填	
	卡号	KH	字符串	32	必填	与患者信息表关联的外键，必须具备关联关系。
	卡类型	KLX	字符串	16	必填	
	床号	CH	字符串	16	必填	
	姓名	XM	字符串	32	必填	
	性别	XB	字符串	1	必填	编码。按国标GB/T2261.1-2003
	年龄	NL	字符串	10	必填	
	入院时间	RYSJ	字符串	8	必填	YYYYMMDD
	出院时间	CYSJ	字符串	8	必填	YYYYMMDD
	住院天数	ZYTS	字符串	5	必填	
	门诊诊断	MZZD	字符串	2048	可选	西医：按ICD-10；中医：按国标-95；多个以“；”间隔
	入院诊断	RYZD	字符串	4000	可选	西医：按ICD-10；中医：按国标-95多个以“；”间隔
	出院诊断	CYZD	字符串	4000	必填	西医：按ICD-10；中医：按国标-95；多个以“；”间隔
	入院时主要症状及体征	RYZZTZ	字符串	4000	必填	该数据项在某些医院的出院小结中还包括入院时主要重要检查结果
	实验室检查及主要会诊	JCHZ	字符串	4000	必填	该数据项在某些医院的出院小结中称为“住院期间主要检查结果”
	住院期间特殊检查	TSJC	字符串	1024	可选	
	诊疗过程	ZLGC	字符串	4000	必填	该数据项在某些医院的出院小结中称为“住院期间病程与诊疗结果”
	合并症	HBZ	字符串	1024	可选	
	出院时情况	CYQK	字符串	1024	必填	该数据项在某些医院的出院小结中称为“出院时情况（症状、体征）”
	出院医嘱	CYYZ	字符串	4000	必填	该数据项在某些医院的出院小结中称为“出院后用药及建议”
	治疗结果	ZLJG	字符串	2	必填	CV5501.11治疗结果代码1.治愈；2.好转；3.无效；4.未治；5.死亡；9.其他
	治疗结果描述	ZLJGMS	字符串	1024	必填	
	主治医师工号	ZZYSGH	字符串	16	可选	编码。见医护人员字典表
	主治医师姓名	ZZYSXM	字符串	32	必填	
	住院医师工号	ZYYSGH	字符串	16	可选	编码。见医护人员字典表
	住院医师姓名	ZYYSXM	字符串	32	必填	
	医院自填报内容1	YYZTB1	字符串	512	可选	由于出院小结在各医院具有灵活性，可根据各自样式自行填写认为重要的内容，供展示；格式：<标题>内容
	医院自填报内容2	YYZTB2	字符串	512	可选	
	文件链接	WJLJ	字符串	256	可选	自由格式内容文件的链接。见“实验室检验报告表头”的相关说明。
	修改标志	XGBZ	数字	1	必填	编码。0：正常、1：撤销；YT3.1.011
	见说明（1）
	密级	MJ	字符串	16	可选	见诊疗记录表的相关说明
	预留一	YLYL1	字符串	128	可选	为系统处理该数据而预留
	预留二	YLYL2	字符串	128	可选	为系统处理该数据而预留
	
	*/
	
	s (JZLSH,YLJGDM,KS,KSMC,KH,KLX,CH,XM,XB,NL,RYSJ,CYSJ,ZYTS,MZZD,RYZD,CYZD,RYZZTZ,JCHZ,TSJC,ZLGC,HBZ,CYQK,CYYZ,ZLJG,ZLJGMS,ZZYSGH,ZZYSXM,ZYYSGH,ZYYSXM,YYZTB1,YYZTB2,WJLJ,XGBZ,MJ,YLYL1,YLYL2)=""
	
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
			s argadmmother=""
			s argadmmother=$p(^PAADM(tmpEpisodeID),"^",62)
			continue:(argadmmother'="")
			s deathdate=$p(^PAPER(argPapmiDR,"ALL"),"^",13)
			continue:(deathdate'="")
			s JZLSH=tmpEpisodeID
			s strpaid = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(tmpEpisodeID)
		s KH = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(strpaid)
			s KLX = 9
			s strRe  = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_tmpEpisodeID," "_"CG37"))
			continue:(strRe = "")
			//s arr=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,"HDSD00.16")
			s arr=##Class(EPRservice.BOScatterData).GetStandDataByGlossaryCategory(tmpEpisodeID,"HDSD00.16")
			
			//科室名称
			s KSMC=arr.GetAt("HDSD00.16.022")
			//床号
			s CH=arr.GetAt("HDSD00.16.001")
			//姓名
			s XM=arr.GetAt("HDSD00.16.019")
			
			//性别
			s XB=arr.GetAt("HDSD00.16.041")
			s XB=$s(XB="男":1,XB="女":2,1:9)
			//年龄
			//s NL=$s(arr.GetAt("HDSD00.16.026")'="":arr.GetAt("HDSD00.16.026")_"岁",1:arr.GetAt("HDSD00.16.026")_"月")
			s NL=arr.GetAt("HDSD00.16.026")
			
			//入院日期时间
			s RYSJ=arr.GetAt("HDSD00.16.031")
			s RYSJ=$p(RYSJ,"年",1)_$p($p(RYSJ,"年",2),"月",1)_$p($p(RYSJ,"月",2),"日",1)
			//出院日期时间
			s CYSJ=arr.GetAt("HDSD00.16.005")
			s CYSJ=$p(CYSJ,"年",1)_$p($p(CYSJ,"年",2),"月",1)_$p($p(CYSJ,"月",2),"日",1)
			//住院天数
			s ZYTS=arr.GetAt("HDSD00.16.036")

			//入院诊断
			s RYZD=arr.GetAt("HDSD00.16.032")
			//出院诊断
			s CYZD=arr.GetAt("HDSD00.16.008")
			//诊疗过程
			s ZLGC=arr.GetAt("HDSD00.16.045")
			//出院时情况
			s CYQK=arr.GetAt("HDSD00.16.004")
			//出院医嘱
			s CYYZ=arr.GetAt("HDSD00.16.007")
			//治疗结果
			s ZLJG=arr.GetAt("HDSD00.16.047")
			//主治医师姓名
			s ZZYSXM=arr.GetAt("HDSD00.16.053")
			//住院医师姓名
			s ZYYSXM=arr.GetAt("HDSD00.16.053")

			set ^CacheTemp(repid, ind) = $LB(JZLSH,YLJGDM,KS,KSMC,KH,KLX,CH,XM,XB,NL,RYSJ,CYSJ,ZYTS,MZZD,RYZD,CYZD,RYZZTZ,JCHZ,TSJC,ZLGC,HBZ,CYQK,CYYZ,ZLJG,ZLJGMS,ZZYSGH,ZZYSXM,ZYYSGH,ZYYSXM,YYZTB1,YYZTB2,WJLJ,XGBZ,MJ,YLYL1,YLYL2)
			set ind = ind + 1
		}
	}
	Quit $$$OK
}

ClassMethod QueryQYHYDischEMRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryQYHYDischEMRExecute ]
{
	
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod QueryQYHYDischEMRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryQYHYDischEMRExecute ]
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

}
