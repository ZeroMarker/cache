/// 创建者：李阳
/// 创建日期：2015-02-27
/// 功能：处理儿童死亡报告卡
Class DHCMed.DTHService.ReportChildSrv Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// 获取报告信息
/// 入参：
/// 	ChRepID:儿童死亡报告卡ID,(DHCMed.DTH.ChildReport)
///     DthRepID:医学死亡证明书ID，(DHCMed.DTH.Report)
/// 输出：
/// 	可以用于打印或显示的信息
/// w ##class(DHCMed.DTHService.ReportChildSrv).GetReportString(1,15)
ClassMethod GetReportString(aChRepID As %String, aDthRepID As %String)
{
	New (aChRepID,aDthRepID,%session)
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	Set return=""
	Quit:(aDthRepID="")&&(aChRepID="") return
	
	If (aChRepID="")&&(aDthRepID'="") {
		Set aChRepID=##class(DHCMed.DTH.ChildReport).GetRepIDByDthID(aDthRepID)
	}
	
	Set ChRepInfo=""
	If (aChRepID'="") { //报告ID不为空
		Set objChRep=##class(DHCMed.DTH.ChildReport).GetObjById(aChRepID)
		If $IsObject(objChRep){
			Set $p(ChRepInfo,"^",1)=aChRepID
			Set $p(ChRepInfo,"^",2)=objChRep.PatientID   // 基本信息ID Pa_Patmas
			Set $p(ChRepInfo,"^",3)=objChRep.EpisodeID   // 就诊表 ID
			Set $p(ChRepInfo,"^",4)=objChRep.DthReportID   // 死亡报告ID DHCMed.DTH.Report
			Set aDthRepID=objChRep.DthReportID
			Set $p(ChRepInfo,"^",5)=objChRep.Name   // 姓名
			Set $p(ChRepInfo,"^",6)=objChRep.FatherName   // 父亲姓名
			Set $p(ChRepInfo,"^",7)=objChRep.MotherName   // 母亲姓名
			Set $p(ChRepInfo,"^",8)=$tr(objChRep.FamTel," ","")   //  联系电话
			Set $p(ChRepInfo,"^",9)=..GetDicString(objChRep.Sex,Languages)   // 性别 1--男 2--女 3--性别不明
			;Set $p(ChRepInfo,"^",10)=$zd(objChRep.Birthday,3)   // 出生日期
			Set $p(ChRepInfo,"^",10)=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objChRep.Birthday)   // 出生日期
			Set $p(ChRepInfo,"^",11)=..GetDicString(objChRep.RegType)   // 户籍类型 1--本地户籍 2--非本地户籍居住1年以下 3--非本地户籍居住1年以上
			Set $p(ChRepInfo,"^",12)=objChRep.Weight   // 出生体重
			Set $p(ChRepInfo,"^",13)=..GetDicString(objChRep.WeightType)   // 出生体重类别：1--测量 2--估计
			Set $p(ChRepInfo,"^",14)=objChRep.PregnancyWeek   // 怀孕___周
			Set $p(ChRepInfo,"^",15)=..GetDicString(objChRep.BirthdayPlace)   // 出生地点 1--省（市）医院 2--区县医院 3--街道（乡镇）卫生院 4--村（诊断）卫生室 5--途中  6--家中
			;Set $p(ChRepInfo,"^",16)=$zd(objChRep.DeathDate,3)   //死亡日期
			Set $p(ChRepInfo,"^",16)=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objChRep.DeathDate)   //死亡日期
			Set $p(ChRepInfo,"^",17)=objChRep.DeathAgeYear   /// 死亡年龄 年
			Set $p(ChRepInfo,"^",18)=objChRep.DeathAgeMonth   /// 死亡年龄 月
			Set $p(ChRepInfo,"^",19)=objChRep.DeathAgeDay   /// 死亡年龄 日
			Set $p(ChRepInfo,"^",20)=..GetDicString(objChRep.DeathPosition)   /// 死亡地点 1--医院 2--途中 3--家中
			Set $p(ChRepInfo,"^",21)=..GetDicString(objChRep.CareBeforeDeath)   /// 死亡前治疗 1--住院 2--门诊 3--未治疗
			Set $p(ChRepInfo,"^",22)=..GetDicString(objChRep.DiagnoseLv)   /// 诊断级别 1--省（市） 2--区县 3--街道（乡镇） 4--村（诊所） 5--未就诊
			Set $p(ChRepInfo,"^",23)=..GetDicString(objChRep.NotCareReason)   /// 未治疗或未就医主要原因 1--经济原因 2--交通不便 3--来不及送医院 4--家长认为病情不严重 5--风俗习惯 6--其他（请注明）
			Set $p(ChRepInfo,"^",24)=objChRep.NotCareReasonTxt   /// 未治疗或未就医主要原因 需要注明
			Set $p(ChRepInfo,"^",25)=..GetDicString(objChRep.DiagnoseBasis)   // 最高诊断依据 尸检、病理、手术、临床+理化、临床、死后推断、不详
			Set $p(ChRepInfo,"^",26)=..GetDicString(objChRep.Category)   //分类编号
			Set $p(ChRepInfo,"^",27)=objChRep.ICD10   //ICD-10编码
			Set $p(ChRepInfo,"^",28)=objChRep.RepDocDR
			Set $p(ChRepInfo,"^",29)=objChRep.RepLocDR
			Set $p(ChRepInfo,"^",30)=$p($g(^SSU("SSUSR",objChRep.RepUsrDR)),"^",2) //fix bug 117824 报告人显示为姓名
			;Set $p(ChRepInfo,"^",31)=$zd(+objChRep.RepDate,3)
			Set $p(ChRepInfo,"^",31)=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(+objChRep.RepDate)
			Set $p(ChRepInfo,"^",32)=$zt(+objChRep.RepTime,1)
			Set (DeathNo,RepStatus) ="" 
			Set objDthRep=##class(DHCMed.DTH.Report).GetObjById(aDthRepID)
			If $IsObject(objDthRep){
				Set DeathNo=objDthRep.DeathNo   //编号
				Set RepStatus = objDthRep.RepStatusDR
			}
			Set $p(ChRepInfo,"^",33)=..GetDicString(RepStatus)   // 状态
			Set $p(ChRepInfo,"^",34)=DeathNo   //编号
			Set $p(ChRepInfo,"^",35)=objChRep.IsReplenish   //是否补卡
			Set $p(ChRepInfo,"^",36)=objChRep.DeathAgeHour   //死亡年龄 小时	
			Set $p(ChRepInfo,"^",37)=objChRep.ResumeText   //备注，退回原因
			
			//上报医院
			Set o=##class(DHCMed.Base.Ctloc).GetObjById(objChRep.RepLocDR)
			Set:'$IsObject(o) o=##class(DHCMed.Base.Ctloc).%New()
			Set objHos=##class(DHCMed.Base.Hospital).GetObjById(o.HospitalDr)
			Set:'$IsObject(objHos) objHos=##class(DHCMed.Base.Hospital).%New()
			Set $p(ChRepInfo,"^",38)=objHos.Descs
			
			Set objReport=##class(DHCMed.DTH.Report).GetObjById(objChRep.DthReportID)
			;//**************************************
			//add By zhoubo 2015-06-26
			Set CurrCountyDesc="", CurrVillageDesc=""  //fix bug 117579
			set CurrCountyID=objReport.MEPDCounty
			if CurrCountyID'="" {
				set CurrCountyDesc=##class(DHCMed.SS.AreaDic).GetShordDescById(CurrCountyID)
			}
			set CurrVillageID=objReport.MEPDVillage
			if CurrVillageID'="" {
				set CurrVillageDesc=##class(DHCMed.SS.AreaDic).GetShordDescById(CurrVillageID)
			}
			Set $p(ChRepInfo,"^",39)=CurrCountyDesc
			Set $p(ChRepInfo,"^",40)=CurrVillageDesc
			;//******************************************
		}
	}
	
	Set DthRepInfo=""
	If (aDthRepID'="") { //有死亡证明书
		Set objDthRep=##class(DHCMed.DTH.Report).GetObjById(aDthRepID)
		If $IsObject(objDthRep){
			Set $p(DthRepInfo,"^",1)=$tr(objDthRep.FamTel," ","") // 联系电话
			;Set $p(DthRepInfo,"^",2)=$zd(objDthRep.DeathDate,3) //死亡日期
			Set $p(DthRepInfo,"^",2)=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objDthRep.DeathDate) //死亡日期
			Set $p(DthRepInfo,"^",3)=$zt(objDthRep.DeathTime,1) // 死亡时间
			;Set $p(DthRepInfo,"^",4)=$zd(objDthRep.Birthday,3) //出生日期
			Set $p(DthRepInfo,"^",4)=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objDthRep.Birthday) //出生日期
			Set $p(DthRepInfo,"^",5)=objDthRep.AReason
			Set $p(DthRepInfo,"^",6)=objDthRep.BReason
			Set $p(DthRepInfo,"^",7)=objDthRep.CReason
			Set $p(DthRepInfo,"^",8)=objDthRep.DReason	
			Set $p(DthRepInfo,"^",9)=objDthRep.BaseReason
			
			If (aChRepID="") { //死亡证明书已填写好，儿童死亡报告卡没填写
				Set $p(ChRepInfo,"^",50)="" //先分配50个空位
				Set $p(ChRepInfo,"^",2)=objDthRep.PatientID   // 基本信息ID Pa_Patmas
				Set $p(ChRepInfo,"^",3)=objDthRep.EpisodeID   // 就诊表 ID
				Set $p(ChRepInfo,"^",4)=objDthRep.%Id()   // 死亡报告ID DHCMed.DTH.Report
				Set $p(ChRepInfo,"^",5)=objDthRep.Name   // 姓名	
				Set $p(ChRepInfo,"^",8)=objDthRep.FamTel   //  联系电话
				Set SexCode=##class(DHCMed.SSService.DictionarySrv).GetIDByDesc("","DTCSex",objDthRep.Sex)
				Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("DTCSex",SexCode,"1")
				Set $p(ChRepInfo,"^",9)=..GetDicString(objDic)   // 性别 1--男 2--女 3--性别不明
				;Set $p(ChRepInfo,"^",10)=$zd(objDthRep.Birthday,3)   // 出生日期
				Set $p(ChRepInfo,"^",10)=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objDthRep.Birthday)   // 出生日期
				;Set $p(ChRepInfo,"^",16)=$zd(objDthRep.DeathDate,3)   //死亡日期
				Set $p(ChRepInfo,"^",16)=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objDthRep.DeathDate)   //死亡日期
				Set Age=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(objDthRep.PatientID,objDthRep.EpisodeID,objDthRep.DeathDate,objDthRep.DeathTime)
		
				Set AgeY="",AgeM="",AgeD=""
				Set tmpAge=Age
				If tmpAge["岁" {
					Set AgeY=+tmpAge
					Set tmpAge=$p(tmpAge,"岁",2)
				}
				If tmpAge["月" {
					Set AgeM=+tmpAge
					Set tmpAge=$p(tmpAge,"月",2)
				}
				If tmpAge["天" {
					Set AgeD=+tmpAge
				}
				Set $p(ChRepInfo,"^",17)=AgeY   /// 死亡年龄 年
				Set $p(ChRepInfo,"^",18)=AgeM   /// 死亡年龄 月
				Set $p(ChRepInfo,"^",19)=AgeD   /// 死亡年龄 天
				Set $p(ChRepInfo,"^",27)=objDthRep.BaseReasonICD   ///根本死因ICD同死亡医学证明书上编码的ICD10
				Set $p(ChRepInfo,"^",33)=$c(2)_$c(2)_"新建"   //状态
				Set $p(ChRepInfo,"^",36)=""   //死亡年龄 小时			
				Set $p(ChRepInfo,"^",34)=objDthRep.DeathNo //儿童死亡报告卡编号=死亡证明书编号
			}
		}
	}
	
	Quit ChRepInfo_$C(1)_DthRepInfo
}

ClassMethod GetDicString(obj, Languages As %String = "") As %String
{
	New (obj,Languages)
	Set return=""
	Quit:'$IsObject(obj) return
	Set $p(return,$c(2),1)=obj.%Id()
	Set $p(return,$c(2),2)=obj.Code
	Set $p(return,$c(2),3)=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,obj.Description)
	Quit return
}

/// 打印儿童死亡报告卡
/// w ##Class(DHCMed.DTHService.ReportChildSrv).PrintDTHChildReport("fill(xlSheet,MergCells,DeleteRows",1)
ClassMethod PrintDTHChildReport(itmjs As %String, aReportID As %String) As %String
{
	n (aReportID,itmjs)
	Set ret=1
	set fillxlSheet=$p(itmjs,",",1)
	set mergCells=$p(itmjs,",",2)
	set deleteRows=$p(itmjs,",",3)	
	Set delimiter="^"
	
	Set t=..GetReportString(aReportID,"")  //参数位置变化
	Set t1=$p(t,$c(1),1)
	Set t2=$p(t,$c(1),2)	
	
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,5),"O","JS")_"',12,3);"  // 姓名
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,6),"O","JS")_"',11,3);"  // 父亲姓名
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,7),"O","JS")_"',11,8);"  // 母亲姓名
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,8),"O","JS")_"',12,8);"  //  联系电话
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($$GetCode($p(t,delimiter,9)),"O","JS")_"',15,11);"  // 性别 1--男 2--女 3--性别不明
	&javascript<#(retval)#>
	
	//add By zhoubo 2015-06-26
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,39),"O","JS")_"',10,2);" //住址区
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,40),"O","JS")_"',10,7);"  //住址村
	&javascript<#(retval)#>
	
	Set tt=$p(t,delimiter,10)  // 出生日期
	if (tt["/") {
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(tt,9,9),"O","JS")_"',17,4);"  
		&javascript<#(retval)#>
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(tt,10,10),"O","JS")_"',17,5);"  
		&javascript<#(retval)#>	
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(tt,4,4),"O","JS")_"',17,6);"  
		&javascript<#(retval)#>	
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(tt,5,5),"O","JS")_"',17,7);"  
		&javascript<#(retval)#>
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(tt,1,1),"O","JS")_"',17,8);"  
		&javascript<#(retval)#>	
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(tt,2,2),"O","JS")_"',17,9);"  
		&javascript<#(retval)#>	
	}else {
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(tt,3,3),"O","JS")_"',17,4);"  
		&javascript<#(retval)#>
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(tt,4,4),"O","JS")_"',17,5);"  
		&javascript<#(retval)#>	
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(tt,6,6),"O","JS")_"',17,6);"  
		&javascript<#(retval)#>	
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(tt,7,7),"O","JS")_"',17,7);"  
		&javascript<#(retval)#>
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(tt,9,9),"O","JS")_"',17,8);"  
		&javascript<#(retval)#>	
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(tt,10,10),"O","JS")_"',17,9);"  
		&javascript<#(retval)#>	
	}
	
		
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($$GetCode($p(t,delimiter,11)),"O","JS")_"',14,11);"  // 户籍类型 1--本地户籍 2--非本地户籍居住1年以下 3--非本地户籍居住1年以上
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,12),"O","JS")_"',18,3);"  // 出生体重
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($$GetCode($p(t,delimiter,13)),"O","JS")_"',18,11);"  // 出生体重类别：1--测量 2--估计
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,14),"O","JS")_"',19,3);"  // 怀孕___周
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($$GetCode($p(t,delimiter,15)),"O","JS")_"',26,11);"  // 出生地点 1--省（市）医院 2--区县医院 3--街道（乡镇）卫生院 4--村（诊断）卫生室 5--途中  6--家中
	&javascript<#(retval)#>
	
	Set tt=$p(t,delimiter,16)  //死亡日期
	if (tt["/") {
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(tt,9,9),"O","JS")_"',28,4);"  
		&javascript<#(retval)#>
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(tt,10,10),"O","JS")_"',28,5);"  
		&javascript<#(retval)#>	
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(tt,4,4),"O","JS")_"',28,6);"  
		&javascript<#(retval)#>	
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(tt,5,5),"O","JS")_"',28,7);"  
		&javascript<#(retval)#>
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(tt,1,1),"O","JS")_"',28,8);"  
		&javascript<#(retval)#>	
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(tt,2,2),"O","JS")_"',28,9);"  
		&javascript<#(retval)#>	
	}else {
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(tt,3,3),"O","JS")_"',28,4);"  
		&javascript<#(retval)#>
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(tt,4,4),"O","JS")_"',28,5);"  
		&javascript<#(retval)#>	
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(tt,6,6),"O","JS")_"',28,6);"  
		&javascript<#(retval)#>	
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(tt,7,7),"O","JS")_"',28,7);"  
		&javascript<#(retval)#>
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(tt,9,9),"O","JS")_"',28,8);"  
		&javascript<#(retval)#>	
		set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(tt,10,10),"O","JS")_"',28,9);"  
		&javascript<#(retval)#>	
	}
	
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,17),"O","JS")_"',29,4);"  /// 死亡年龄 年
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,18),"O","JS")_"',29,6);"  /// 死亡年龄 月
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,19),"O","JS")_"',29,8);"  /// 死亡年龄 日
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($$GetCode($p(t,delimiter,20)),"O","JS")_"',17,22);"  /// 死亡地点 1--医院 2--途中 3--家中
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($$GetCode($p(t,delimiter,21)),"O","JS")_"',19,22);"  /// 死亡前治疗 1--住院 2--门诊 3--未治疗
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($$GetCode($p(t,delimiter,22)),"O","JS")_"',24,22);"  /// 诊断级别 1--省（市） 2--区县 3--街道（乡镇） 4--村（诊所） 5--未就诊
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($$GetCode($p(t,delimiter,23)),"O","JS")_"',30,22);"  /// 未治疗或未就医主要原因 1--经济原因 2--交通不便 3--来不及送医院 4--家长认为病情不严重 5--风俗习惯 6--其他（请注明）
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,24),"O","JS")_"',31,13);"  /// 未治疗或未就医主要原因 需要注明
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($$GetCode($p(t,delimiter,25)),"O","JS")_"',34,22);"  // 最高诊断依据 尸检、病理、手术、临床+理化、临床、死后推断、不详
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($$GetCode($p(t,delimiter,26)),"O","JS")_"',14,20);"  //分类编号
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,27),"O","JS")_"',15,20);"  //ICD-10编码
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,38),"O","JS")_"',37,4);" //上报医院
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,30),"O","JS")_"',37,12);" //上报医师
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,31),"O","JS")_"',37,19);" //上报日期	
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p($p(t,delimiter,31),"-",1),"O","JS")_"',2,8);" //年份	
	&javascript<#(retval)#>	
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,34),"O","JS")_"',9,2);"  //编号
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($s($p(t,delimiter,35)="0":"",1:"√"),"O","JS")_"',7,19);"  //是否补卡
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,36),"O","JS")_"',29,10);"  //死亡年龄 小时		
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t2,delimiter,5),"O","JS")_"',32,8);"  // A原因
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t2,delimiter,6),"O","JS")_"',10,19);"  // B原因
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t2,delimiter,7),"O","JS")_"',11,19);"  // C原因
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t2,delimiter,8),"O","JS")_"',12,19);"  //  D原因
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t2,delimiter,9),"O","JS")_"',13,16);"  //  根本原因
	&javascript<#(retval)#>		
		
		
	Quit ret

GetCode(txt)
	Quit $p(txt,$c(2),2)
}

/// Creator：     李阳
/// CreatDate：   2015-03-09
/// Description:  查询死亡患者信息（儿童）
/// d ##class(%ResultSet).RunQuery("DHCMed.DTHService.ReportChildSrv","QryDeathPatients","2015-01-01","2015-10-28","","","","")
Query QryDeathPatients(aDateType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String, aExamConts As %String, aExamSepeare As %String, aRepStatus As %String) As %Query(ROWSPEC = "Paadm:%String,PatientID:%String,RegNo:%String,MrNo:%String,PatientName:%String,Sex:%String,Age:%String,AdmType:%String,DecDate:%String,DecTime:%String,DoctorName:%String,AdmitDate:%String,Department:%String,Ward:%String,Room:%String,Bed:%String,DisDate:%String,ChRepID:%String,ChRepDate:%String,ChRepTime:%String,ChRepUser:%String,ChRepStatus:%String,ChRepLocID:%String,ChRepLoc:%String,ReportID:%String,RepDate:%String,RepTime:%String,RepUser:%String,RepStatus:%String,RepLocID:%String,RepLoc:%String") [ SqlProc ]
{
}

ClassMethod QryDeathPatientsExecute(ByRef qHandle As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String, aExamConts As %String, aExamSepeare As %String, aRepStatus As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo'="" aDateTo=+aDateTo
	Set:$g(aExamSepeare)="" aExamSepeare="^"
	
	Set (PatName,RegNo,MrNo)=""
	For indCont=1:1:$l(aExamConts,aExamSepeare) {
		Set ExamCont=$p(aExamConts,aExamSepeare,indCont)
		Set:ExamCont["PatName=" PatName=$e(ExamCont,$l("PatName=")+1,$l(ExamCont))
		Set:ExamCont["MrNo=" MrNo=$e(ExamCont,$l("MrNo=")+1,$l(ExamCont))
		Set:ExamCont["RegNo=" RegNo=$e(ExamCont,$l("RegNo=")+1,$l(ExamCont))
	}
	
	Set DateIndex=$s(aDateType=1:"IndexDate",1:"IndexDeathDate") //1：按报告日期查询 2：按死亡日期查询
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCMed.DTHi("REP",DateIndex,xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		
		Set xRepID=0
		For {
			Set xRepID=$o(^DHCMed.DTHi("REP",DateIndex,xDate,xRepID))
			Quit:xRepID=""
			
		    //fix bug 197114 by pylian 20160419增加病案号查询
		    Set objRep=##Class(DHCMed.DTH.Report).GetObjById(xRepID)
			Continue:'$IsObject(objRep) 
            Set PatMrNo=objRep.MrNo
			Continue:((MrNo'="")&&(MrNo'=PatMrNo))
			set PapmiNo=objRep.PapmiNo
			continue:(RegNo'="")&&(RegNo'=PapmiNo)
			set PatientName=objRep.Name
			continue:(PatName'="")&&(PatientName'[PatName)
			continue:'$IsObject(objRep.RepStatusDR)
			set RepStatus=objRep.RepStatusDR.%Id()
			continue:RepStatus=""
			continue:((aRepStatus'="")&&(aRepStatus'=RepStatus))
			Set Data=..BuildChildRepData(xRepID,aLocID,aHospID)
			Continue:Data=""
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryDeathPatientsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDeathPatientsExecute ]
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

ClassMethod QryDeathPatientsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDeathPatientsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 取死亡患者信息
ClassMethod BuildChildRepData(aRepID As %String, aLocID As %String = "", aHospID As %String = "") As %String
{
	New (aRepID,aLocID,aHospID)
	Set return=""
	Quit:aRepID="" return
	
	Set objRep=##Class(DHCMed.DTH.Report).GetObjById(aRepID)
	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.RepStatusDR) return
	Set RepStatus=objRep.RepStatusDR.Description
	Quit:(RepStatus["删除")||(RepStatus["作废") return
	
	Set PatientID=objRep.PatientID
	Set EpisodeID=objRep.EpisodeID
	Set MrNo=objRep.MrNo
	Set:MrNo="" MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,"I")
	Set Birthday=objRep.Birthday
	Set DecDate=objRep.DeathDate
	;Set:DecDate'="" DecDate=$zd(DecDate,3)
	Set:DecDate'="" DecDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DecDate)
	Set DecTime=objRep.DeathTime
	Set:DecTime'="" DecTime=$zt(DecTime,1)
	Set AdmType=$p($g(^PAADM(+EpisodeID)),"^",2)
	Set AdmType=$s(AdmType="I":"住院",AdmType="O":"门诊",AdmType="E":"急诊",AdmType="H":"体检",1:"其他")
	
	Set Age=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,"",DecDate,DecTime)
	Set:+Age<0 Age=objRep.Age //根据死亡报告所填死亡日期和时间取得年龄为负值时 取死亡报告记录年龄
	If (Age["岁") {
		Set PatAge=+Age
	} Else {
		Set PatAge=1
	}
	Quit:(PatAge>=5) return   //5岁以下儿童需要填报儿童死亡报卡
   	Quit:(Age="未知") return
   	
	Set RepDate=objRep.RepDate
	;Set:RepDate'="" RepDate=$zd(RepDate,3)
	Set:RepDate'="" RepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)
	Set RepTime=objRep.RepTime
	Set:RepTime'="" RepTime=$zt(RepTime,1)
	Set RepUser=objRep.RepUsrDR
	Set:RepUser'="" RepUser=$p($g(^SSU("SSUSR",RepUser)),"^",2)
	Set RepLocID=objRep.RepLocDR
	Set:RepLocID'="" RepLocDesc=$p($g(^CTLOC(RepLocID)),"^",2)
	Set:RepLocDesc["-" RepLocDesc=$p(RepLocDesc,"-",2)
	If aLocID'="" {
		Quit:RepLocID'=aLocID return
	} Else {
		If aHospID'="" {
			Set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(RepLocID,aHospID)
			Quit:flg<1 return
		}
	}
	
	Set objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	Quit:'$IsObject(objPaadm) return
   	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
   	Quit:'$IsObject(objPatient) return
   	
  	Set (cReportID,cRepDate,cRepTime,cRepUser,cRepStatus,cRepLocDesc,cRepLocID)=""
  	Set cRepID=""
  	For {
  		Set cRepID=$o(^DHCMed.DTHi("ChildREP","IndexPatientID"," "_PatientID,cRepID))
  		Quit:cRepID=""
  		
		Set objChRep=##Class(DHCMed.DTH.ChildReport).GetObjById(cRepID)
		Continue:'$IsObject(objChRep)
		Continue:'$IsObject(objChRep.RepStatusDR)
		Set cRepStatus=objChRep.RepStatusDR.Description
		Continue:(cRepStatus["删除")
		
		Set cReportID=cRepID
		Set cRepDate=objChRep.RepDate
		;Set:cRepDate'="" cRepDate=$zd(cRepDate,3)
		Set:cRepDate'="" cRepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(cRepDate)
		Set cRepTime=objChRep.RepTime
		Set:cRepTime'="" cRepTime=$zt(cRepTime,2)
		Set cRepUser=objChRep.RepUsrDR
		Set:cRepUser'="" cRepUser=$p($g(^SSU("SSUSR",cRepUser)),"^",2)
		Set cRepLocID=objChRep.RepLocDR
		Set:cRepLocID'="" cRepLocDesc=$p($g(^CTLOC(cRepLocID)),"^",2)
		Set:cRepLocDesc["-" cRepLocDesc=$p(cRepLocDesc,"-",2)	
  	}
  	Set:cRepStatus="" cRepStatus="未报"
  	
	Set $li(return,1)=EpisodeID
	Set $li(return,2)=PatientID
	Set $li(return,3)=objPatient.PapmiNo
	Set $li(return,4)=MrNo
	Set $li(return,5)=objPatient.PatientName
	Set $li(return,6)=objPatient.Sex
	Set $li(return,7)=Age
	Set $li(return,8)=AdmType
	Set $li(return,9)=DecDate
	Set $li(return,10)=DecTime
	Set $li(return,11)=objPaadm.DoctorName
	Set $li(return,12)=objPaadm.AdmitDate
	Set AdmLoc=objPaadm.Department
	Set:AdmLoc["-" AdmLoc=$p(AdmLoc,"-",2)
	Set $li(return,13)=AdmLoc
	Set AdmWard=objPaadm.Ward
	Set:AdmWard["-" AdmWard=$p(AdmWard,"-",2)
	Set $li(return,14)=AdmWard
	Set $li(return,15)=objPaadm.Room
	Set $li(return,16)=objPaadm.Bed
	Set $li(return,17)=objPaadm.DisDate
	Set:$li(return,17)="1840-12-31" $li(return,17)=""
	Set $li(return,18)=cReportID
	Set $li(return,19)=cRepDate
	Set $li(return,20)=cRepTime
	Set $li(return,21)=cRepUser
	Set $li(return,22)=cRepStatus
	Set $li(return,23)=cRepLocID
	Set $li(return,24)=cRepLocDesc
	Set $li(return,25)=aRepID
	Set $li(return,26)=RepDate
	Set $li(return,27)=RepTime
	Set $li(return,28)=RepUser
	Set $li(return,29)=RepStatus
	Set $li(return,30)=RepLocID
	Set $li(return,31)=RepLocDesc
	Quit return
}

}
