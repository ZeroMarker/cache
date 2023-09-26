/// 名称: DHCMed.CCService.Sys.ImportSrv
/// 描述: 导入监控中心基础数据
/// 编写者：zhufei
/// 编写日期: 2011-05-16
Class DHCMed.CCService.Sys.ImportSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Sys.ImportSrv).PackageData()
ClassMethod PackageData()
{
	New
	
	Set $ZT="PackageDataErr"
	
	Set PLIST(1)="^001^MRDiagnos^Y^诊断"
	Set PLIST(1,1)="^诊断^GetNumByID^##class(DHCMed.CCService.Lib.MRDiagnos).GetNumByID([诊断])^1^Integer,诊断数量^通过诊断ID取临床诊断数量"
	Set PLIST(1,2)="^诊断^GetNumByName^##class(DHCMed.CCService.Lib.MRDiagnos).GetNumByName([诊断描述])^1^Integer,诊断数量^通过关键词取临床诊断数量,入参可多值,逗号分隔"
	Set PLIST(1,3)="^诊断^GetNumByICD10^##class(DHCMed.CCService.Lib.MRDiagnos).GetNumByICD10([ICD10])^1^Integer,诊断数量^通过ICD10代码取临床诊断数量"
	
	Set PLIST(2)="^002^OEOrdItem^Y^医嘱"
	Set PLIST(2,1)="^医嘱^GetNumByID^##class(DHCMed.CCService.Lib.OEOrdItem).GetNumByID([医嘱])^1^Integer,医嘱数量^通过医嘱项取医嘱单医嘱数量"
	Set PLIST(2,2)="^医嘱^GetPhsByCat1^##class(DHCMed.CCService.Lib.OEOrdItem).GetPhsByCat([药学项大类],+$h,+$h)^1^integer,返回药品种类^根据药学项大类查询患者当天药品使用种类"
	Set PLIST(2,3)="^医嘱^GetPhsBySubCat1^##class(DHCMed.CCService.Lib.OEOrdItem).GetPhsBySubCat([药学项子类],+$h,+$h)^1^Integer,返回药品种类^根据药学项子类查询患者当天药品使用种类"
	Set PLIST(2,4)="^医嘱^GetPhsByCat^##class(DHCMed.CCService.Lib.OEOrdItem).GetPhsByCat([药学项大类],"","")^1^Integer,返回药品种类^根据药学项大类查询患者药品使用种类"
	Set PLIST(2,5)="^医嘱^GetPhsBySubCat^##class(DHCMed.CCService.Lib.OEOrdItem).GetPhsBySubCat([药学项子类],"","")^1^Integer,返回药品种类^根据药学项子类查询患者药品使用种类"
	
	Set PLIST(3)="^003^LisReport^Y^检验"
	Set PLIST(3,1)="^检验^CheckLabItem^##class(DHCMed.CCService.Lib.LisReport).CheckLabItem([检验])^1^Integer,返回检验医嘱数量^通过检验指标取检验医嘱数量"
	Set PLIST(3,2)="^检验^CheckItemAbnor^##class(DHCMed.CCService.Lib.LisReport).CheckItemAbnor([检验])^1^Integer,返回异常检验医嘱数量^通过检验指标取异常检验医嘱数量"
	
	Set PLIST(4)="^004^Observations^Y^体温"
	Set PLIST(4,1)="^体温^CheckOBSItem^##class(DHCMed.CCService.Lib.Observations).CheckOBSItem([体温])^1^Integer,返回体温超标记录数量^通过体温高低值取体温超标记录数量,入参可多值,逗号分隔"
	
	Set PLIST(5)="^005^Epidemic^Y^传染病"
	Set PLIST(5,1)="^传染病^IsEpdPatient^##class(DHCMed.CCService.Lib.Epidemic).IsEpdPatient()^1^是否传染病患者(-1,0,1)^是否传染病患者"
	
	Set PLIST(6)="^006^Infection^Y^院感"
	Set PLIST(6,1)="^院感^IsInfPatient^##class(DHCMed.CCService.Lib.Infection).IsInfPatient(""1"")^1^是否院感患者(-1,0,1)^是否院感患者"
	
	Set PLIST(7)="^007^PaPatmas^Y^基本信息"
	Set PLIST(7,1)="^基本信息^GetPatAge^##class(DHCMed.CCService.Lib.PaPatmas).GetPatAge()^1^Integer,返回患者年龄^返回患者年龄(岁),不足一岁按一岁算,用于年龄筛选"
	
	Set PLIST(8)="^008^EPRVersion1^Y^电子病历1.0"
	Set PLIST(8,1)="^电子病历1.0^CheckSingleData^##class(DHCMed.CCService.Lib.EPRV1Data).CheckSingleData([单元Code],[关键字])^1^ret=0:模板单元不存在关键字，ret=1:模板单元存在关键字^电子病历V1.0唯一模板单元检查填写内容是否包含某写关键字"
	
	Set PLIST(9)="^009^EPRVersion2^Y^电子病历2.0"
	Set PLIST(9,1)="^电子病历2.0^CheckSingleData^##class(DHCMed.CCService.Lib.EPRV2Data).CheckSingleData([单元Code],[关键字])^1^ret=0:模板单元不存在关键字，ret=1:模板单元存在关键字^电子病历V2.0唯一模板单元检查填写内容是否包含某写关键字"
	Set PLIST(9,2)="^电子病历2.0^CheckMultiData^##class(DHCMed.CCService.Lib.EPRV2Data).CheckMultiData([单元Code],[关键字])^1^ret=0:模板单元不存在关键字，ret=1:模板单元存在关键字^电子病历V2.0可重复模板单元检查填写内容是否包含某写关键字"
	
	Kill ^DHCMed.CCF("PMethod")
	Kill ^DHCMed.CCF("Package")
	Kill ^DHCMed.CCFi("PMethod")
	Kill ^DHCMed.CCFi("Package")
	
	TStart
	Set PacInd=0,flg=0
	For {
		Set PacInd=$o(PLIST(PacInd))
		Quit:PacInd=""
		Set InputStr=$g(PLIST(PacInd))
		Set $p(InputStr,"^",4)="Y"
		Set flg=##class(DHCMed.CC.MethodPackage).Update(InputStr)
		If flg<0 TRollBack
		Quit:flg<0
		
		Write "PackageID="_flg,!
		
		Set PacakgeID=flg
		Set FunInd=0
		For {
			Set FunInd=$o(PLIST(PacInd,FunInd))
			Quit:FunInd=""
			Set InputStr=$g(PLIST(PacInd,FunInd))
			Set $p(InputStr,"^",2)=PacakgeID
			Set $p(InputStr,"^",5)="Y"
			Set flg=##class(DHCMed.CC.MethodInfo).Update(InputStr)
			If flg<0 TRollBack
			Quit:flg<0
			
			Write "MethodID="_flg,!
		}
		Quit:flg<0
	}
	Quit:flg<0 "Error!"
	TCommit
	
	Quit "Over!"
	
PackageDataErr
	Write $ZError,!
	Quit "Error!"
}

/// w ##Class(DHCMed.CCService.Sys.ImportSrv).ClearSubject()
ClassMethod ClearSubject()
{
	New
	
	Kill ^DHCMed.CC("ISubCat")
	Kill ^DHCMed.CC("ItemCat")
	Kill ^DHCMed.CC("ItemDic")
	Kill ^DHCMed.CC("SItem")
	
	Kill ^DHCMed.CCi("ISubCat")
	Kill ^DHCMed.CCi("ItemCat")
	Kill ^DHCMed.CCi("ItemDic")
	Kill ^DHCMed.CCi("SItem")
	
	Quit "Over!"
}

/// w ##Class(DHCMed.CCService.Sys.ImportSrv).DeleteSubject("INFCC")
ClassMethod DeleteSubject(SubjectCode) As %String
{
	n (SubjectCode)
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:'$IsObject(objSubject) "OK"
	Set SubjectID=objSubject.%Id()
	Set ItmID=""
	Set IsActive=""
	For {
		Set IsActive=$o(^DHCMed.CCi("SItem",0,"IndexSubjectID",SubjectID,IsActive))
		Quit:IsActive=""
		Set ItmID=""
		For {
			Set ItmID=$o(^DHCMed.CCi("SItem",0,"IndexSubjectID",SubjectID,IsActive,ItmID))
			Quit:ItmID=""
			w ItmID,!
			Set objItm=##class(DHCMed.CC.SubjectItm).GetObjById(ItmID)
			Continue:'$IsObject(objItm)
			Set flg=##class(DHCMed.CC.ItemDic).DeleteById(objItm.ItemDic)
			Set flg=##class(DHCMed.CC.SubjectItm).DeleteById(ItmID)
		}
	}
	
	Set StartConfigID=""
	For {
		Set StartConfigID=$o(^DHCMed.CCi("StartConfig","SubjectIDIndex",SubjectID,StartConfigID))
		Quit:StartConfigID=""
		Set flg=##class(DHCMed.CC.SubjectVMStartConfig).DeleteById(StartConfigID)
	}
	
	Set ItmCat=""
	For {
		Set ItmCat=$o(^DHCMed.CCi("ItemCat",0,"SubjectIndex",SubjectID,ItmCat))
		Quit:ItmCat=""
		Set Code=""
		For {
			Set Code=$o(^DHCMed.CCi("ISubCat",0,"ISCCodeIndex",ItmCat,Code))
			Quit:Code=""
			Set SubID=""
			For {
				Set SubID=$o(^DHCMed.CCi("ISubCat",0,"ISCCodeIndex",ItmCat,Code,SubID))
				Quit:SubID=""
				Set flg=##class(DHCMed.CC.ItemSubCat).DeleteById(SubID)
			}
		}
		Set flg=##class(DHCMed.CC.ItemCat).DeleteById(ItmCat)	
	}
	Set flg=##class(DHCMed.CC.Subject).DeleteById(SubjectID)
	Quit "OK"
}

ClassMethod ClearMethodPackage() As %String
{
	Kill ^DHCMed.CCF
	Kill ^DHCMed.CCFi
	Quit "OK"
}

}
