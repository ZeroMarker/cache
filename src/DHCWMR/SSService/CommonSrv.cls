/// 名称: DHCWMR.SSService.CommonSrv
/// 描述: 病案公共服务
/// 编写者：zhufei
/// 编写日期: 2014-09-16
Class DHCWMR.SSService.CommonSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 登记号输入补零
/// w ##Class(DHCWMR.SSService.CommonSrv).RegNoCon(2)
ClassMethod RegNoCon(aPapmiNo As %String) As %String
{
	New (aPapmiNo)
	Set return=""
	Quit:aPapmiNo="" return
	
	Set len=8
	Set PATCFid=$o(^CF("PATCF",""))
	Set:PATCFid'="" len=$p($g(^CF("PATCF",PATCFid,3)),"^",5)
	Set $p(return,"0",len-$l(aPapmiNo)+1)=aPapmiNo
	Quit return
}

/// 卡号输入补零
/// w ##Class(DHCWMR.SSService.CommonSrv).CardNoCon(2)
ClassMethod CardNoCon(aCardNo As %String) As %String
{
	New (aCardNo)
	Set return=""
	Quit:aCardNo="" return
	
	Set len=##Class(DHCWMR.SS.Config).GetValByKey("CARDLEN","0")
	Set $p(return,"0",len-$l(aCardNo)+1)=aCardNo
	Quit return
}

/// 登记号取病人基本信息表（PatientID）
/// w ##Class(DHCWMR.SSService.CommonSrv).GetPatientID("0000000001")
ClassMethod GetPatientID(aRegNo As %String) As %String
{
	New (aRegNo)
	Set return=""
	Quit:aRegNo="" return
	Set RegNo=..RegNoCon(aRegNo)
	Quit:RegNo="" return
	Set return=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
	Quit return
}

/// 卡号取病人基本信息表（PatientID）
/// w ##Class(DHCWMR.SSService.CommonSrv).GetPatByCardNo("000222222222")
ClassMethod GetPatByCardNo(aCardNo As %String) As %String
{
	New (aCardNo)
	Set return=""
	Quit:aCardNo="" return
	
	Set aCardNo=..CardNoCon(aCardNo)
	
	Set CardID=$o(^DHCCARDi("CF",0,"CardNo",aCardNo,0))
	Quit:CardID="" return
	Set return=$p($g(^DHCCARD("CF",CardID)),"^",4)
	Quit return
}

/// 数字或字母全角转半角
/// w ##Class(DHCWMR.SSService.CommonSrv).ChangeMrNo("ａ0 ,1123")
ClassMethod ChangeMrNo(aMrNo As %String) As %String
{
	New (aMrNo)
	Set return=""
	Quit:aMrNo="" return
	
	Set MrNo=""
	Set CharList1="1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	Set CharList2="１２３４５６７８９０ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ"
	
	//过滤非字母、数字字符
	For indChar=1:1:$l(aMrNo) {
		Set xChar=$e(aMrNo,indChar,indChar)
		Continue:xChar=""
		Continue:(CharList1'[xChar)&&(CharList2'[xChar)
		Set MrNo=MrNo_xChar
	}
	Quit:MrNo="" return
	
	//字母或数字，全角转半角
	For indChar=1:1:$l(MrNo) {
		Set xChar=$e(MrNo,indChar,indChar)
		Continue:xChar=""
		Continue:CharList2'[xChar
		Set CharListSub=$p(CharList2,xChar,1)
		Set yChar=$e(CharList1,$l(CharListSub)+1,$l(CharListSub)+2)
		Set MrNo=$tr(MrNo,xChar,yChar)
	}
	Set return=$zcvt(MrNo,"U")
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-03-21
/// Description:  根据配置修改日期存储格式【From系统平台】
/// Input：       aDate : 日期
/// Return:		  返回String Cache日期格式
/// w ##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical("2017-03-12")
ClassMethod DateHtmlToLogical(aDate As %String) As %String
{
	New (aDate)
	Set return=""
	Quit:aDate="" return
	
	Set $ZT="DateHtmlToLogicalErr"
	Set return=##class(websys.Conversions).DateHtmlToLogical(aDate)
	Quit return
	
DateHtmlToLogicalErr
	Set return=..GetDateHtmlToLogical(aDate)
	Quit return
}

ClassMethod GetDateHtmlToLogical(aDate As %String) As %String
{
	New (aDate)
	Set return=""
	Quit:aDate="" return
	
	Set $ZT="GetDateHtmlToLogicalErr"
	Set:aDate["-" return=$zdh(aDate,3)
	Set:aDate["/" return=$zdh(aDate,4)
	Quit return
	
GetDateHtmlToLogicalErr
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-03-21
/// Description:  根据配置修改日期输出格式【From系统平台】
/// Input：       aDate : 日期
/// Return:		  返回String 日期格式：2017-01-01
/// w ##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(+$h)
ClassMethod DateLogicalToHtml(aDate As %String) As %String
{
	New (aDate)
	Set return=""
	Quit:aDate="" return
	
	Set $ZT="DateLogicalToHtmlErr"
	Set return=##class(websys.Conversions).DateLogicalToHtml(aDate)
	Quit return
	
DateLogicalToHtmlErr
	Set return=..GetDateLogicalToHtml(aDate)
	Quit return
}

ClassMethod GetDateLogicalToHtml(aDate As %String) As %String
{
	New (aDate)
	Set return=""
	Quit:aDate="" return
	
	Set $ZT="GetDateLogicalToHtmlErr"
	Set return=$zd(aDate,3)
	Quit return
	
GetDateLogicalToHtmlErr
	Quit return
}

/// 将正常日期格式转换为Cache的日期格式
/// 输入条件：
///    日期，如：2014-08-22
ClassMethod GetCacheDate(DateStr) As %Date
{
		n (DateStr)
		Set:DateStr["年" DateStr=$tr(DateStr,"年","-")
		Set:DateStr["月" DateStr=$tr(DateStr,"月","-")
		Set:DateStr["日" DateStr=$tr(DateStr,"日","")
		Set:DateStr["/" DateStr=$zdh(DateStr,4)
		Set:DateStr["-" DateStr=$zdh(DateStr,3)
		Quit DateStr
}

/// 将正常时间格式转换为Cache的日期格式
/// 输入条件：
///    日期，如：12:00
ClassMethod GetCacheTime(DateStr) As %Date
{
		n (DateStr)
		Set:DateStr[":" DateStr=$zth(DateStr,1)
		Set:DateStr'="" DateStr=+DateStr
		Quit DateStr
}

/// 转换日期时间格式（转换后格式：62552,2013）
/// w ##Class(DHCWMR.SSService.CommonSrv).GetCacheDateTime(aDateTime)
ClassMethod GetCacheDateTime(aDateTime As %String) As %String
{
	New (aDateTime)
	Set return=""
	Quit:aDateTime="" return
	
	Set aDateTime=$tr(aDateTime,"年","-")
	Set aDateTime=$tr(aDateTime,"月","-")
	Set aDateTime=$tr(aDateTime,"日","")
	Set aDateTime=$tr(aDateTime,"小","")
	Set aDateTime=$tr(aDateTime,"时",":")
	Set aDateTime=$tr(aDateTime,"分",":")
	Set aDateTime=$tr(aDateTime,"秒","")
	If $e(aDateTime,$l(aDateTime),$l(aDateTime))=":" {
		Set aDateTime=$e(aDateTime,1,$l(aDateTime)-1)
	}
	If aDateTime[" " {
		Set xDate=$p(aDateTime," ",1)
		Set:xDate["-" xDate=$zdh(xDate,3)
		Set:xDate["/" xDate=$zdh(xDate,4)
		Set xTime=$p(aDateTime," ",2)
		Set:xTime[":" xTime=$zth(xTime,1)
	}
	Set return=xDate_","_xTime
	
	Quit return
}

/// 取患者安床时间（安床时间作为入院时间）
/// w ##Class(DHCWMR.SSService.CommonSrv).GetAdmitDate(4)
ClassMethod GetAdmitDate(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set xTransID=0
	For {
		Set xTransID=$o(^PAADM(aEpisodeID,"TRANS",xTransID))
		Quit:xTransID=""
		Quit:return'=""  //update by zf 20150330
		
		Set tmpTrans=$g(^PAADM(aEpisodeID,"TRANS",xTransID))
		Set TransLoc=$p(tmpTrans,"^",8)  //取床位字段
		Continue:TransLoc=""
		Set TransDate=$p(tmpTrans,"^",1)
		Set:TransDate'="" TransDate=$zd(TransDate,3)
		Set TransTime=$p(tmpTrans,"^",2)
		Set:TransTime'="" TransTime=$zt(TransTime,1)
		Set return=TransDate_" "_TransTime
	}
	If return="" {
		Set AdmDate=$p($g(^PAADM(aEpisodeID)),"^",6)
		Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
		Set AdmTime=$p($g(^PAADM(aEpisodeID)),"^",7)
		Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
		Set return=AdmDate_" "_AdmTime
	}
	
	Quit return
}

/// 取入院科室、病区、床位
/// w ##Class(DHCWMR.SSService.CommonSrv).GetAdmitDept(4)
ClassMethod GetAdmitDept(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set xTransID=0,TransLoc="",TransWard="",TransBed=""
	For {
		Set xTransID=$o(^PAADM(aEpisodeID,"TRANS",xTransID))
		Quit:xTransID=""
		Continue:(TransWard'="")&&(TransLoc'="")
		
		Set tmpTrans=$g(^PAADM(aEpisodeID,"TRANS",xTransID))
		If TransLoc="" {
			Set TransLoc=$p(tmpTrans,"^",6)
		}
		If TransWard="" {
			Set TransBed=$p(tmpTrans,"^",8)
			If TransBed'="" {
				Set TransWard=$p(TransBed,"||",1)
				Set TransWard=$p($g(^PAWARD(+TransWard)),"^",5)
			}
		}
	}
	If TransLoc="" {
		Set TransLoc=$p($g(^PAADM(+aEpisodeID)),"^",4)
	}
	If TransWard="" {
		Set TransWard=$p($g(^PAADM(+aEpisodeID)),"^",70)
		Set TransWard=$p($g(^PAWARD(+TransWard)),"^",5)
	}
	Set return=TransLoc_","_TransWard_","_TransBed
	Quit return
}

/// 取入院诊断、门急诊诊断
/// w ##Class(DHCWMR.SSService.CommonSrv).GetAdmitDiagnos(Paadm)
ClassMethod GetAdmitDiagnos(aPaadm As %String) As %String
{
	New (aPaadm)
	Set return=""
	Quit:aPaadm="" return
	
	Quit return
}

/// 取出院日期、出院时间（默认为最终结算日期）
/// 不同项目要求可能不一样（最终结算/医疗结算/统计日期）
/// w ##Class(DHCWMR.SSService.CommonSrv).GetDischDate(Paadm)
ClassMethod GetDischDate(aPaadm As %String) As %String
{
	New (aPaadm)
	Set return=""
	Quit:aPaadm="" return
	
	Set AdmType=$p($g(^PAADM(aPaadm)),"^",2)
	If AdmType="I" {
		Set AdmStatus=$p($g(^PAADM(aPaadm)),"^",20)
		Quit:AdmStatus'="D" return
		//Update by pylian 2016-01-21 修改出院时间取值方式
		Set DischDateTime=##Class(DHCWMR.IO.FromAdmSrv).GetDischDateTime(aPaadm)
		Set DischDate=$p(DischDateTime,"^",1)
		Set DischTime=$p(DischDateTime,"^",2)
		//Set DischDate=$p($g(^PAADM(aPaadm)),"^",17)  //最终结算日期
		Set:DischDate'="" DischDate=$zd(DischDate,3)
		//Set DischTime=$p($g(^PAADM(aPaadm)),"^",18)  //最终结算时间
		Set:DischTime'="" DischTime=$zt(DischTime)
		Quit:DischDate="" return
	} ElseIf AdmType="E" {
		Set DischDate=$p($g(^PAADM(aPaadm)),"^",6)  //就诊日期
		Set:DischDate'="" DischDate=$zd(DischDate,3)
		Set DischTime=$p($g(^PAADM(aPaadm)),"^",7)  //就诊时间
		Set:DischTime'="" DischTime=$zt(DischTime)
		Quit:DischDate="" return
	} ElseIf AdmType="O" {
		Set DischDate=$p($g(^PAADM(aPaadm)),"^",6)  //就诊日期
		Set:DischDate'="" DischDate=$zd(DischDate,3)
		Set DischTime=$p($g(^PAADM(aPaadm)),"^",7)  //就诊时间
		Set:DischTime'="" DischTime=$zt(DischTime)
		Quit:DischDate="" return
	}
	
	Set return=DischDate_" "_DischTime
	Quit return
}

/// 取医疗结算日期、医疗结算时间
/// w ##Class(DHCWMR.SSService.CommonSrv).GetEstimDischDate(Paadm)
ClassMethod GetEstimDischDate(aPaadm As %String) As %String
{
	New (aPaadm)
	Set return=""
	Quit:aPaadm="" return
	
	Set DischDate=$p($g(^PAADM(aPaadm)),"^",59)  //医疗结算日期
	;Set:DischDate'="" DischDate=$zd(DischDate,3)
	Set:DischDate'="" DischDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(DischDate)
	Set DischTime=$p($g(^PAADM(aPaadm)),"^",60)  //医疗结算时间
	Set:DischTime'="" DischTime=$zt(DischTime)
	Quit:DischDate="" return
	
	Set return=DischDate_" "_DischTime
	Quit return
}

/// 取出院科室、病区、床位
/// w ##Class(DHCWMR.SSService.CommonSrv).GetDischDept(4)
ClassMethod GetDischDept(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set xTransID="",TransLoc="",TransWard="",TransBed=""
	For {
		Set xTransID=$o(^PAADM(aEpisodeID,"TRANS",xTransID),-1)
		Quit:xTransID=""
		Quit:(TransWard'="")&&(TransLoc'="")
		
		Set tmpTrans=$g(^PAADM(aEpisodeID,"TRANS",xTransID))
		If TransLoc="" {
			Set TransLoc=$p(tmpTrans,"^",6)
		}
		If TransWard="" {
			Set TransBed=$p(tmpTrans,"^",8)
			If TransBed'="" {
				Set TransWard=$p(TransBed,"||",1)
				Set TransWard=$p($g(^PAWARD(+TransWard)),"^",5)
			}
		}
	}
	If TransLoc="" {
		Set TransLoc=$p($g(^PAADM(+aEpisodeID)),"^",4)
	}
	If TransWard="" {
		Set TransWard=$p($g(^PAADM(+aEpisodeID)),"^",70)
		Set TransWard=$p($g(^PAWARD(+TransWard)),"^",5)
	}
	Set return=TransLoc_","_TransWard_","_TransBed
	Quit return
}

/// 取出院诊断
/// w ##Class(DHCWMR.SSService.CommonSrv).GetDischDiagnos(Paadm)
ClassMethod GetDischDiagnos(aPaadm As %String) As %String
{
	New (aPaadm)
	Set return=""
	Quit:aPaadm="" return
	
	Quit return
}

/// 取死亡日期、死亡时间
/// w ##Class(DHCWMR.SSService.CommonSrv).GetDeathDate(9726218)
ClassMethod GetDeathDate(aPaadm As %String) As %String
{
	New (aPaadm)
	Set return=""
	Quit:aPaadm="" return
	Set DeathDate=##class(DHCWMR.IO.FromMedSrv).GetDeathDateTime(aPaadm)
	Quit:DeathDate="" return
	Set return=$zd(DeathDate,3)
	Quit return
}

/// 字符串替换
/// w ##Class(DHCWMR.SSService.CommonSrv).ReplaceString()
ClassMethod ReplaceString(Str, OldStr, NewStr) As %String
{
	new (Str,OldStr,NewStr)
	set intCounter = 1
	while (1)
	{
		set tmp =$e(Str, intCounter, intCounter + $l(OldStr) - 1) 
		if (tmp = OldStr)
		{
			 set $e(Str, intCounter, intCounter + $l(OldStr) - 1) = NewStr
			 set intCounter = intCounter + $l(NewStr) - $l(OldStr)
		}
		quit:intCounter>=$l(Str)
		set intCounter = intCounter + 1
	}
	quit Str
}

/// 格式化条码号
/// w ##Class(DHCWMR.SSService.CommonSrv).FormatBarcode("01",1)
ClassMethod FormatBarcode(aTpCode As %String, aBarcode As %String, aSSHospCode As %String = "") As %String
{
	New (aTpCode,aBarcode,aSSHospCode)
	Set return=""
	Quit:aBarcode="" return
	
	Set aBarcode=$tr(aBarcode," ","")
	Quit:aBarcode="" return
	
	If (aTpCode="01")||(aTpCode="02") {
		Set $p(return,"0",12-$l(aBarcode))=aBarcode
		Set return=aTpCode_return
	} Else {
		Set return=aBarcode
	}
	
	Quit return
}

/// 获取模板文件存放目录
/// w ##class(DHCWMR.SSService.CommonSrv).GetTemplatePath()
ClassMethod GetTemplatePath() As %String
{
	New
	Set strPath=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("PrintTemplatePath")
	If strPath="" {
		Set objConfig=##class(websys.Configuration).%OpenId(1)
		Do objConfig.%Close()
		Set strPath=objConfig.PathToReports
	} Else {
		Set strPath=$tr(strPath,"/","\")
	}
	Quit strPath
}

/// Creator：     zhufei
/// CreatDate：   2014-10-29
/// Description:  查询用户/医护人员列表
/// Table：       CT_CareProv
/// Input：       Alias : 别名
///               Loc : 科室
/// Return：      返回Query
/// D ##class(%ResultSet).RunQuery("DHCWMR.SSService.CommonSrv","QryCareProvByAlias","","7","","")
Query QryCareProvByAlias(aAlias As %String, aCTPLocID As %String, aCTPIntTp As %String, aAddItem As %String) As %Query(ROWSPEC = "CTPID:%String,CTPCode:%String,CTPDesc:%String,CTPPinYin:%String,CTPTpDesc:%String,CTPIntTp:%String") [ SqlProc ]
{
}

ClassMethod QryCareProvByAliasExecute(ByRef qHandle As %Binary, aAlias As %String, aCTPLocID As %String, aCTPIntTp As %String, aAddItem As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	//Set ^ZF=$lb(aAlias, aCTPLocID, aAddItem)
 	
 	//Quit:aCTPLocID="" $$$OK
 	
	Set aAddItem=$g(aAddItem)
	If (aAddItem'="") {
		Set addItemCode=$p(aAddItem,"^",1)
		Set addItemDesc=$p(aAddItem,"^",2)
		Set Data=$lb(addItemCode,addItemDesc,addItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Set yAlias=$$ALPHAUP^SSUTIL4(aAlias)
	If yAlias'="" {
		//完全匹配 姓名
	 	Set xID=0
		For {
	 		Set xID=$o(^CTPCP(0,"Decs",yAlias,xID))
	 		Quit:xID=""
	 		Set CTPID=xID
			Do BuildDataByAlias
		}
		//完全匹配 工号
	 	Set xID=0
		For {
			
	 		Set xID=$o(^CTPCP(0,"Code",yAlias,xID))
	 		Quit:xID=""
	 		Set CTPID=xID
			Do BuildDataByAlias
		}
		//完全匹配 姓名拼音
	 	Set xCTPDesc=""
		For {
	 		Set xCTPDesc=$o(^CTPCP(0,"SMCNo",yAlias,xCTPDesc))
	 		Quit:xCTPDesc=""
	 		Set xCTPID=0
	 		For {
		 		Set xCTPID=$o(^CTPCP(0,"SMCNo",yAlias,xCTPDesc,xCTPID))
	 			Quit:xCTPID=""
	 			Set CTPID=xCTPID
				Do BuildDataByAlias
		 	}
		}
	}
	
	//包含关系 姓名
	Set xAlias=yAlias
	For {
		Set xAlias=$o(^CTPCP(0,"Decs",xAlias))
		Quit:xAlias=""
		Quit:$p(xAlias,yAlias,1)'=""
		
	 	Set xID=0
		For {
	 		Set xID=$o(^CTPCP(0,"Decs",xAlias,xID))
	 		Quit:xID=""
	 		Set CTPID=xID
			Do BuildDataByAlias
		}
	}
	//包含关系 姓名拼音
	Set xAlias=yAlias
	For {
		Set xAlias=$o(^CTPCP(0,"SMCNo",xAlias))
		Quit:xAlias=""
		Quit:$p(xAlias,yAlias,1)'=""
	 	
		Set xCTPDesc=""
		For {
	 		Set xCTPDesc=$o(^CTPCP(0,"SMCNo",xAlias,xCTPDesc))
	 		Quit:xCTPDesc=""
	 		
	 		Set xCTPID=0
	 		For {
		 		Set xCTPID=$o(^CTPCP(0,"SMCNo",xAlias,xCTPDesc,xCTPID))
	 			Quit:xCTPID=""
	 			Set CTPID=xCTPID
				Do BuildDataByAlias
		 	}
		}
	}
	//匹配首拼
	Set xCTPID=0
	For {
		Set xCTPID = $o(^CTPCP(xCTPID))
		Quit:xCTPID=""
		
		Set OtherName = $p($g(^CTPCP(xCTPID,3)),"^",28)
		Continue:OtherName=""
		Continue:$zcvt(OtherName,"U")'[yAlias
		
 		Set CTPID=xCTPID
		Do BuildDataByAlias
	}
 	
	Quit $$$OK
	
BuildDataByAlias
	Set CTPCode=$p($g(^CTPCP(CTPID,1)),"^",1)
	Set CTPDesc=$p($g(^CTPCP(CTPID,1)),"^",2)
	Set CTPPinYin=$p($g(^CTPCP(CTPID,1)),"^",6)
	Set CTPOthName = $p($g(^CTPCP(CTPID,3)),"^",28)
	Quit:($zcvt(CTPCode,"U")'[$zcvt(aAlias,"U"))&&($zcvt(CTPDesc,"U")'[$zcvt(aAlias,"U"))&&($zcvt(CTPPinYin,"U")'[$zcvt(aAlias,"U"))&&($zcvt(CTPOthName,"U")'[$zcvt(aAlias,"U"))
	Quit:(CTPDesc["测试")||(CTPDesc["作废")
	
	Set CTPTpID=$p($g(^CTPCP(CTPID,1)),"^",4)
	Set CTPTpDesc=$p($g(^CT("CPT",+CTPTpID)),"^",2)
	Set CTPIntTp=$p($g(^CT("CPT",+CTPTpID)),"^",4)
	Quit:(aCTPIntTp'="")&(CTPIntTp'=aCTPIntTp)  //检查类型 DOCTOR、NURSE
	If (aCTPLocID'=""){
		Quit:'$d(^RB("RES",0,"CTPCP",CTPID,aCTPLocID)) //检查科室
	}
 	Set Data=$LB(CTPID,CTPCode,CTPDesc,CTPPinYin,CTPTpDesc,CTPIntTp)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	
 	Quit
}

ClassMethod QryCareProvByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCareProvByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCareProvByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCareProvByAliasExecute ]
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

/// 查询科室列表
/// d ##Class(%ResultSet).RunQuery("DHCWMR.SSService.CommonSrv","QryLoctionByAlias","","","E","","")
Query QryLoctionByAlias(aAlias As %String, aHospitalIDs As %String, aLocType As %String, aAdmType As %String, aAddItem As %String) As %Query(ROWSPEC = "LocRowId:%String,LocDesc:%String,LocDesc1:%String")
{
}

ClassMethod QryLoctionByAliasExecute(ByRef qHandle As %Binary, aAlias As %String, aHospitalIDs As %String, aLocType As %String, aAdmType As %String, aAddItem As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aAlias=$g(aAlias)
	Set aHospitalIDs=$g(aHospitalIDs)
	Set aLocType=$g(aLocType)
	Set aAdmType=$g(aAdmType)
	Set aAddItem=$g(aAddItem)
	Set:aLocType'="" aLocType=$ZCVT($g(aLocType),"U")
	Set:aAdmType'="" aAdmType=$ZCVT($g(aAdmType),"U")
	
 	//add by zf 20130225 增加附加选项
	If (aAddItem'="")&&(aAlias="") {
		Set addItemCode=$p(aAddItem,"^",1)
		Set addItemDesc=$p(aAddItem,"^",2)
		Set Data=$lb(addItemCode,addItemCode,addItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Set LocID=0
	For {
		Set LocID=$o(^CTLOC(LocID))
		Quit:LocID=""
		Set tmpLoc=$g(^CTLOC(LocID))
		Set LocDesc=$p(tmpLoc,"^",2)
		Set LocDep=$p(tmpLoc,"^",19)
		Set LocType=$p(tmpLoc,"^",13)
		
		Continue:(aAlias'="")&&($zcvt(LocDesc,"U")'[$zcvt(aAlias,"U"))           //别名
		Continue:(aLocType'="")&&(LocType'=aLocType)                             //科室类型
		
		//主要处理集团化医院情况和总院分院情况
		If aHospitalIDs'="" {
			Set flg=##Class(DHCWMR.SSService.HospitalSrv).CheckHospital(LocID,aHospitalIDs)
			Continue:flg<1
		}
		
		//增加科室按门诊、住院分类的过滤
		If (aLocType'="W")&&(aAdmType'="") {
			Continue:'$d(^PAC("ADMLOC",0,"AdmType",aAdmType,LocID))
		}
		
		Set LocDesc1=LocDesc
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		
		Set Data=$lb(LocID,LocDesc,LocDesc1)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryLoctionByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLoctionByAliasExecute ]
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

ClassMethod QryLoctionByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLoctionByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// 查询付款方式字典（CT_SocialStatus）
/// d ##Class(%ResultSet).RunQuery("DHCWMR.SSService.CommonSrv","QuerySocialStatus","")
Query QuerySocialStatus(aAddItem As %String) As %Query(ROWSPEC = "ItemID:%String,ItemCode:%String,ItemDesc:%String")
{
}

ClassMethod QuerySocialStatusExecute(ByRef qHandle As %Binary, aAddItem As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aAddItem=$g(aAddItem)
	If (aAddItem'="") {
		Set addItemCode=$p(aAddItem,"^",1)
		Set addItemDesc=$p(aAddItem,"^",2)
		Set Data=$lb(addItemCode,addItemDesc,addItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Set xID=0
	For {
		Set xID=$o(^CT("SS",xID))
		Quit:xID=""
		Set ItemCode=$p($g(^CT("SS",xID)),"^",1)
		Set ItemDesc=$p($g(^CT("SS",xID)),"^",2)
		Set Data=$lb(xID,ItemCode,ItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QuerySocialStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySocialStatusExecute ]
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

ClassMethod QuerySocialStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySocialStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// 查询证件类型字典（PAC_CardType）
/// d ##Class(%ResultSet).RunQuery("DHCWMR.SSService.CommonSrv","QueryCardType","")
Query QueryCardType(aAddItem As %String) As %Query(ROWSPEC = "ItemID:%String,ItemCode:%String,ItemDesc:%String")
{
}

ClassMethod QueryCardTypeExecute(ByRef qHandle As %Binary, aAddItem As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aAddItem=$g(aAddItem)
	If (aAddItem'="") {
		Set addItemCode=$p(aAddItem,"^",1)
		Set addItemDesc=$p(aAddItem,"^",2)
		Set Data=$lb(addItemCode,addItemDesc,addItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Set xID=0
	For {
		Set xID=$o(^PAC("CARD",xID))
		Quit:xID=""
		Set ItemCode=$p($g(^PAC("CARD",xID)),"^",1)
		Set ItemDesc=$p($g(^PAC("CARD",xID)),"^",2)
		Set DateFrom=$p($g(^PAC("CARD",xID)),"^",3)
		Continue:(DateFrom'="")&(DateFrom>+$h)
		Set IsActive = $p($g(^PAC("CARD",xID,"DHC")),"^",1)
		Continue:IsActive'="Y"
		Set DateTo=$p($g(^PAC("CARD",xID)),"^",4)
		Continue:(DateTo'="")&(DateTo<+$h)
		Set Data=$lb(xID,ItemCode,ItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QueryCardTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCardTypeExecute ]
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

ClassMethod QueryCardTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCardTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// 查询性别字典（CT_Sex）
/// d ##Class(%ResultSet).RunQuery("DHCWMR.SSService.CommonSrv","QuerySex","")
Query QuerySex(aAddItem As %String) As %Query(ROWSPEC = "ItemID:%String,ItemCode:%String,ItemDesc:%String")
{
}

ClassMethod QuerySexExecute(ByRef qHandle As %Binary, aAddItem As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aAddItem=$g(aAddItem)
	If (aAddItem'="") {
		Set addItemCode=$p(aAddItem,"^",1)
		Set addItemDesc=$p(aAddItem,"^",2)
		Set Data=$lb(addItemCode,addItemDesc,addItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Set xID=0
	For {
		Set xID=$o(^CT("SEX",xID))
		Quit:xID=""
		Set ItemCode=$p($g(^CT("SEX",xID)),"^",1)
		Set ItemDesc=$p($g(^CT("SEX",xID)),"^",2)
		Set DateFrom=$p($g(^CT("SEX",xID)),"^",4)
		Continue:(DateFrom'="")&(DateFrom>+$h)
		Set DateTo=$p($g(^CT("SEX",xID)),"^",5)
		Continue:(DateTo'="")&(DateTo<+$h)
		Set Data=$lb(xID,ItemCode,ItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QuerySexFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySexExecute ]
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

ClassMethod QuerySexClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySexExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// 查询婚姻状况字典（CT_Marital）
/// d ##Class(%ResultSet).RunQuery("DHCWMR.SSService.CommonSrv","QueryMarital","")
Query QueryMarital(aAddItem As %String) As %Query(ROWSPEC = "ItemID:%String,ItemCode:%String,ItemDesc:%String")
{
}

ClassMethod QueryMaritalExecute(ByRef qHandle As %Binary, aAddItem As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aAddItem=$g(aAddItem)
	If (aAddItem'="") {
		Set addItemCode=$p(aAddItem,"^",1)
		Set addItemDesc=$p(aAddItem,"^",2)
		Set Data=$lb(addItemCode,addItemDesc,addItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Set xID=0
	For {
		Set xID=$o(^CT("MAR",xID))
		Quit:xID=""
		Set ItemCode=$p($g(^CT("MAR",xID)),"^",1)
		Set ItemDesc=$p($g(^CT("MAR",xID)),"^",2)
		Set DateFrom=$p($g(^CT("MAR",xID)),"^",4)
		Continue:(DateFrom'="")&(DateFrom>+$h)
		Set DateTo=$p($g(^CT("MAR",xID)),"^",5)
		Continue:(DateTo'="")&(DateTo<+$h)
		Set Data=$lb(xID,ItemCode,ItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QueryMaritalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMaritalExecute ]
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

ClassMethod QueryMaritalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMaritalExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// 查询民族字典（CT_Nation）
/// d ##Class(%ResultSet).RunQuery("DHCWMR.SSService.CommonSrv","QueryNation","")
Query QueryNation(aAlias As %String, aAddItem As %String) As %Query(ROWSPEC = "ItemID:%String,ItemCode:%String,ItemDesc:%String")
{
}

ClassMethod QueryNationExecute(ByRef qHandle As %Binary, aAlias As %String, aAddItem As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aAlias=$g(aAlias)
	Set aAddItem=$g(aAddItem)
	If (aAddItem'="") {
		Set addItemCode=$p(aAddItem,"^",1)
		Set addItemDesc=$p(aAddItem,"^",2)
		Set Data=$lb(addItemCode,addItemDesc,addItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Set xID=0
	For {
		Set xID=$o(^CT("NAT",xID))
		Quit:xID=""
		Set ItemCode=$p($g(^CT("NAT",xID)),"^",1)
		Set ItemDesc=$p($g(^CT("NAT",xID)),"^",2)
		Continue:(aAlias'="")&($zcvt(ItemDesc,"U")'[$zcvt(aAlias,"U"))
		Set:$p(ItemDesc,"-",2)'="" ItemDesc=$p(ItemDesc,"-",2)
		Set Data=$lb(xID,ItemCode,ItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QueryNationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryNationExecute ]
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

ClassMethod QueryNationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryNationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// 查询国籍字典（CT_Country）
/// d ##Class(%ResultSet).RunQuery("DHCWMR.SSService.CommonSrv","QueryCountry","")
Query QueryCountry(aAlias As %String, aAddItem As %String) As %Query(ROWSPEC = "ItemID:%String,ItemCode:%String,ItemDesc:%String")
{
}

ClassMethod QueryCountryExecute(ByRef qHandle As %Binary, aAlias As %String, aAddItem As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aAlias=$g(aAlias)
	Set aAddItem=$g(aAddItem)
	If (aAddItem'="") {
		Set addItemCode=$p(aAddItem,"^",1)
		Set addItemDesc=$p(aAddItem,"^",2)
		Set Data=$lb(addItemCode,addItemDesc,addItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Set xID=0
	For {
		Set xID=$o(^CT("COU",xID))
		Quit:xID=""
		Set ItemCode=$p($g(^CT("COU",xID)),"^",1)
		Set ItemDesc=$p($g(^CT("COU",xID)),"^",2)
		Continue:(aAlias'="")&($zcvt(ItemDesc,"U")'[$zcvt(aAlias,"U"))
		Set:$p(ItemDesc,"-",2)'="" ItemDesc=$p(ItemDesc,"-",2)
		Set DateFrom=$p($g(^CT("COU",xID)),"^",4)
		Continue:(DateFrom'="")&(DateFrom>+$h)
		Set DateTo=$p($g(^CT("COU",xID)),"^",5)
		Continue:(DateTo'="")&(DateTo<+$h)
		Set Data=$lb(xID,ItemCode,ItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QueryCountryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCountryExecute ]
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

ClassMethod QueryCountryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCountryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// 查询联系关系字典（CT_Relation）
/// d ##Class(%ResultSet).RunQuery("DHCWMR.SSService.CommonSrv","QueryRelation","")
Query QueryRelation(aAlias As %String, aAddItem As %String) As %Query(ROWSPEC = "ItemID:%String,ItemCode:%String,ItemDesc:%String")
{
}

ClassMethod QueryRelationExecute(ByRef qHandle As %Binary, aAlias As %String, aAddItem As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aAlias=$g(aAlias)
	Set aAddItem=$g(aAddItem)
	If (aAddItem'="") {
		Set addItemCode=$p(aAddItem,"^",1)
		Set addItemDesc=$p(aAddItem,"^",2)
		Set Data=$lb(addItemCode,addItemDesc,addItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Set xID=0
	For {
		Set xID=$o(^CT("RLT",xID))
		Quit:xID=""
		Set ItemCode=$p($g(^CT("RLT",xID)),"^",1)
		Set ItemDesc=$p($g(^CT("RLT",xID)),"^",2)
		Continue:(aAlias'="")&($zcvt(ItemDesc,"U")'[$zcvt(aAlias,"U"))
		Set:$p(ItemDesc,"-",2)'="" ItemDesc=$p(ItemDesc,"-",2)
		Set DateFrom=$p($g(^CT("RLT",xID)),"^",3)
		Continue:(DateFrom'="")&(DateFrom>+$h)
		Set DateTo=$p($g(^CT("RLT",xID)),"^",4)
		Continue:(DateTo'="")&(DateTo<+$h)
		Set Data=$lb(xID,xID,ItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QueryRelationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRelationExecute ]
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

ClassMethod QueryRelationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRelationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// 
/// 查询职业字典（CT_Occupation）
/// d ##Class(%ResultSet).RunQuery("DHCWMR.SSService.CommonSrv","QueryOccupation","")
Query QueryOccupation(aAlias As %String, aAddItem As %String) As %Query(ROWSPEC = "ItemID:%String,ItemCode:%String,ItemDesc:%String")
{
}

ClassMethod QueryOccupationExecute(ByRef qHandle As %Binary, aAlias As %String, aAddItem As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aAlias=$g(aAlias)
	Set aAddItem=$g(aAddItem)
	If (aAddItem'="") {
		Set addItemCode=$p(aAddItem,"^",1)
		Set addItemDesc=$p(aAddItem,"^",2)
		Set Data=$lb(addItemCode,addItemDesc,addItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Set xID=0
	For {
		Set xID=$o(^CT("OCC",xID))
		Quit:xID=""
		Set ItemCode=$p($g(^CT("OCC",xID)),"^",1)
		Set ItemDesc=$p($g(^CT("OCC",xID)),"^",2)
		Continue:(aAlias'="")&($zcvt(ItemDesc,"U")'[$zcvt(aAlias,"U"))
		Set:$p(ItemDesc,"-",2)'="" ItemDesc=$p(ItemDesc,"-",2)
		Set DateFrom=$p($g(^CT("OCC",xID)),"^",3)
		Continue:(DateFrom'="")&(DateFrom>+$h)
		Set DateTo=$p($g(^CT("OCC",xID)),"^",4)
		Continue:(DateTo'="")&(DateTo<+$h)
		Set Data=$lb(xID,xID,ItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QueryOccupationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOccupationExecute ]
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

ClassMethod QueryOccupationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOccupationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// 查询省字典（CT_Province）
/// d ##Class(%ResultSet).RunQuery("DHCWMR.SSService.CommonSrv","QueryProvince","","")
Query QueryProvince(aAlias As %String, aAddItem As %String) As %Query(ROWSPEC = "ItemID:%String,ItemCode:%String,ItemDesc:%String")
{
}

ClassMethod QueryProvinceExecute(ByRef qHandle As %Binary, aAlias As %String, aAddItem As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aAlias=$g(aAlias)
	Set aAddItem=$g(aAddItem)
	If (aAddItem'="") {
		Set addItemCode=$p(aAddItem,"^",1)
		Set addItemDesc=$p(aAddItem,"^",2)
		Set Data=$lb(addItemCode,addItemDesc,addItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Set xID=0
	For {
		Set xID=$o(^CT("PROV",xID))
		Quit:xID=""
		Set ItemCode=$p($g(^CT("PROV",xID)),"^",1)
		Set ItemDesc=$p($g(^CT("PROV",xID)),"^",2)
		Continue:(aAlias'="")&($zcvt(ItemDesc,"U")'[$zcvt(aAlias,"U"))
		Set:$p(ItemDesc,"-",2)'="" ItemDesc=$p(ItemDesc,"-",2)
		Set DateFrom=$p($g(^CT("PROV",xID)),"^",4)
		Continue:(DateFrom'="")&(DateFrom>+$h)
		Set DateTo=$p($g(^CT("PROV",xID)),"^",5)
		Continue:(DateTo'="")&(DateTo<+$h)
		Set Data=$lb(xID,xID,ItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QueryProvinceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryProvinceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryProvinceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryProvinceExecute ]
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

/// 查询城市字典（CT_City）
/// d ##Class(%ResultSet).RunQuery("DHCWMR.SSService.CommonSrv","QueryCity","","","")
Query QueryCity(aAlias As %String, aProvinceDr As %String, aAddItem As %String) As %Query(ROWSPEC = "ItemID:%String,ItemCode:%String,ItemDesc:%String")
{
}

ClassMethod QueryCityExecute(ByRef qHandle As %Binary, aAlias As %String, aProvinceDr As %String, aAddItem As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aProvinceDr="" $$$OK
	
	Set aAlias=$g(aAlias)
	Set aAddItem=$g(aAddItem)
	If (aAddItem'="") {
		Set addItemCode=$p(aAddItem,"^",1)
		Set addItemDesc=$p(aAddItem,"^",2)
		Set Data=$lb(addItemCode,addItemDesc,addItemDesc)
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit:'$d(^CT("CIT",0,"ProvCode",aProvinceDr))

	Set xCityCode=""
	For {
		Set xCityCode = $o(^CT("CIT",0,"ProvCode",aProvinceDr,xCityCode))
		Quit:xCityCode=""
		Set xCityId=""
		For {
			Set xCityId = $o(^CT("CIT",0,"ProvCode",aProvinceDr,xCityCode,xCityId))
			Quit:xCityId=""
			Set xID = xCityId
			Set ItemCode=$p($g(^CT("CIT",xID)),"^",1)
			Set ItemDesc=$p($g(^CT("CIT",xID)),"^",2)
			Continue:(aAlias'="")&($zcvt(ItemDesc,"U")'[$zcvt(aAlias,"U"))
			Set:$p(ItemDesc,"-",2)'="" ItemDesc=$p(ItemDesc,"-",2)
			Set DateFrom=$p($g(^CT("CIT",xID)),"^",5)
			Continue:(DateFrom'="")&(DateFrom>+$h)
			Set DateTo=$p($g(^CT("CIT",xID)),"^",6)
			Continue:(DateTo'="")&(DateTo<+$h)
			Set Data=$lb(xID,xID,ItemDesc)
	    	Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QueryCityClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCityExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryCityFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCityExecute ]
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
