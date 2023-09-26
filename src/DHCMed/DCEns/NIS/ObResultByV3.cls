/// 名称: DHCMed.DCEns.NIS.ObResultByV3
/// 描述: 护理记录数据输入服务类（V3 第三方）
/// 编写者：zhufei
/// 编写日期: 2016-04-14
Class DHCMed.DCEns.NIS.ObResultByV3 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(DHCMed.DCEns.NIS.ObResultByV3).test()
ClassMethod test()
{
	Set PapmiNo="03130021"
	Set aPaadm="21558071"
	Set itemName="体温"
	Set obWebService=##class(DHCMed.DCEns.NIS.BasicHttpBindingIPDAService).%New()
	Set retString=obWebService.GetData(PapmiNo,aPaadm,itemName)
	w retString,!
}

/// *********************************************************************************
/// 以下内容为：同步护理记录数据方法
/// *********************************************************************************
/// Creator：     zhufei
/// CreatDate：   2016-04-14
/// Description:  根据起止日期同步护理记录数据
/// Table：       DHCMed.DC.NIS.Observations
/// Input：       FromDate:开始日期
///               ToDate:结束日期
///               HospCode:医院缩写码（DHCMed_DC_SYS.BTHospital.SCode）
/// Return：      OK
/// w ##class(DHCMed.DCEns.NIS.ObResultByV3).SyncObsByDate("2016-04-28","2016-04-28","NIS01",1)
ClassMethod SyncObsByDate(aFromDate As %String, aToDate As %String, aHospCode As %String, aInitFlag As %String = "0") As %String
{
	New (aFromDate,aToDate,aHospCode,aInitFlag)
	Set return="0^入参错误",Count=0
	Quit:(aFromDate="")||(aToDate="")||(aHospCode="") return
	
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	
	If aInitFlag=1 {
		//护理记录数据
		Kill ^DHCMed.DC.NIS.ObservationsD
		Kill ^DHCMed.DC.NIS.ObservationsI
	}
	
	Set return="-1^医院缩写码维护错误"
	Set SSHospCodeList=##class(DHCMed.DCEns.HospitalSrv).GetCodeBySCode(aHospCode)
	Quit:SSHospCodeList="" return
	
	Set xHospCode=""
	For {
		Set xHospCode=$o(^DHCMed.DC.HIS.InHospitalI("IndexInHospital",xHospCode))
		Quit:xHospCode=""
		
		Set tHospCode=$tr(xHospCode," ","")
		Set tSSHospCodeList=##class(DHCMed.DCEns.HospitalSrv).GetCodeBySCode(tHospCode)
		Continue:tSSHospCodeList=""
		
		Set HospCodeFlag=0
		For indHosp=1:1:$ll(tSSHospCodeList) {
			Set tSSHospCode=$list(tSSHospCodeList,indHosp)
			Continue:tSSHospCode=""
			Continue:$listfind(SSHospCodeList,tSSHospCode)<1
			Set HospCodeFlag=1
			Quit
		}
		Continue:HospCodeFlag<1
		
		Set xAdmType=""
		For {
			Set xAdmType=$o(^DHCMed.DC.HIS.InHospitalI("IndexInHospital",xHospCode,xAdmType))
			Quit:xAdmType=""
			
			Continue:(xAdmType'="I")&&(xAdmType'="E")&&(xAdmType'="EP")
			
			Set xAdmDays=""
			For {
				Set xAdmDays=$o(^DHCMed.DC.HIS.InHospitalI("IndexInHospital",xHospCode,xAdmType,xAdmDays))
				Quit:xAdmDays=""
				
				Set xDate=$s(xAdmDays>0:aFromDate-xAdmDays,1:"")
				For {
					Set xDate=$o(^DHCMed.DC.HIS.InHospitalI("IndexInHospital",xHospCode,xAdmType,xAdmDays,xDate))
					Quit:xDate=""
					
					Quit:(xAdmDays>0)&&(xDate>(aToDate-xAdmDays+1))
					Quit:(xAdmDays<0)&&(xDate>aToDate)
					
					Set xID=0
					For {
						Set xID=$o(^DHCMed.DC.HIS.InHospitalI("IndexInHospital",xHospCode,xAdmType,xAdmDays,xDate,xID))
						Quit:xID=""
						
						Set objAdm=##class(DHCMed.DC.HIS.InHospital).GetObjById(xID)
						Continue:'$IsObject(objAdm)
						Continue:objAdm.IsActive'=1
						Set EpisodeID=objAdm.EpisodeID
						
						Set Count=Count+1
						W:(Count#100)=0 "已处理 "_Count_" 条数据!",!
						
						Set flg=..UpdateObservations(EpisodeID,aHospCode,aFromDate,aToDate)
					}
				}
			}
		}
	}
	
	Quit "OK"
}

/// Creator：     zhufei
/// CreatDate：   2016-04-14
/// Description:  同步就诊记录时间段内护理记录
/// Table：       DHCMed.DC.NIS.Observations
/// Input：       aPaadm:就诊ID
/// 	          aFromDate:开始日期
///               aToDate:结束日期
/// Return：      
/// w ##Class(DHCMed.DCEns.NIS.ObResultByV3).UpdateObservations(5,"59172","59175","NIS01")
ClassMethod UpdateObservations(aPaadm As %String, aHospCode As %String, aFromDate As %String, aToDate As %String) As %String
{
	New (aPaadm,aHospCode,aFromDate,aToDate)
	Set return=0
	Quit:(aPaadm="") return
	
	//安贞医院调用特有接口
	Set aFromDate=$zd(aFromDate,3)
	Set aToDate = $zd(aToDate,3)
	Set PatValue=##class(web.DHCThreeNew).GetPatValueAZ(aPaadm,aFromDate,aToDate)
	Quit:PatValue="" return
	For patIndex=1:1:$l(PatValue,"^")
	{
		Set value = $p(PatValue,"^",patIndex)
		Continue:value=""
		
		Set EntryDate = $p(value,"|",1)
		Set EntryTime = $p(value,"|",2)
		Set:(EntryDate'="")&&(EntryDate["-") EntryDate=$zdh(EntryDate,3)
		Set:(EntryTime'="")&&(EntryTime[":") EntryTime=$zth(EntryTime,3)
		Set ItemValue1 = $p(value,"|",3)	//体温
		Set ItemValue2 = $p(value,"|",4)	//身高
		Set ItemValue3 = $p(value,"|",5)	//体重
		Set ItemValue4 = $p(value,"|",6)	//大便次数
		Continue:(ItemValue1<0)||(ItemValue2<0)||(ItemValue3<0)||(ItemValue4<0)	//数据异常
		
		Set obItemID = ""
		For {
			Set obItemID = $o(^DHCMed.DC.NIS.BTObItemD(obItemID))
			Quit:obItemID=""
			
			Set objObItem=##class(DHCMed.DC.NIS.BTObItem).GetObjById(obItemID)
			Continue:'$isobject(objObItem)
			Set Active=objObItem.Active
			Continue:Active'=1
			Continue:(aHospCode'="")&&(aHospCode'=objObItem.HospCode)	//过滤非对应子系统
			Set itemName=objObItem.CName
			Set ItemValue=$s(itemName="体温":ItemValue1,itemName="身高":ItemValue2,itemName="体重":ItemValue3,itemName="大便次数":ItemValue4,1:"")
			Continue:ItemValue=""
			Set InputStr = ""
			Set InputStr = InputStr_"^"_aPaadm
			Set InputStr = InputStr_"^"_obItemID
			Set InputStr = InputStr_"^"_ItemValue
			Set InputStr = InputStr_"^"_EntryDate
			Set InputStr = InputStr_"^"_EntryTime
			Set InputStr = InputStr_"^"_""
			Set InputStr = InputStr_"^"_1
			Set return=##class(DHCMed.DC.NIS.Observations).Update(InputStr,"^")
		}
	}
	/*
	Set AdmStr = $g(^PAADM(+aPaadm))
	Set Papmi = $p(AdmStr,"^",1)
	Quit:Papmi="" return
	
	Set PapmiNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
	Quit:PapmiNo="" return
	
	Set obItemID = ""
	For {
		Set obItemID = $o(^DHCMed.DC.NIS.BTObItemD(obItemID))
		Quit:obItemID=""
		
		Set objObItem=##class(DHCMed.DC.NIS.BTObItem).GetObjById(obItemID)
		Continue:'$isobject(objObItem)
		Set Active=objObItem.Active
		Continue:Active'=1
		Continue:(aHospCode'="")&&(aHospCode'=objObItem.HospCode)	//过滤非对应子系统
		Set itemName=objObItem.CName
		//调用webservice
		Set obWebService=##class(DHCMed.DCEns.NIS.BasicHttpBindingIPDAService).%New()
		Set retString=obWebService.GetData(PapmiNo,aPaadm,itemName)
		For aIndex=1:1:$l(retString,"~")
		{
			Set currString = $p(retString,"~", aIndex)
			Continue:currString=""	
			Set EntryDateTime = ..UnEscape($p(currString, "^", 1))
			Set ItemName = ..UnEscape($p(currString, "^", 2))
			Set ItemValue = ..UnEscape($p(currString, "^", 3))
			Continue:ItemValue<0 //接口负数为空
			Set ItemUnit = ..UnEscape($p(currString, "^", 4))
			Set EntryUser = ..UnEscape($p(currString, "^", 5))
			Set EntryDate = $p(EntryDateTime," " ,1)
			Set EntryTime = $p(EntryDateTime," " ,2)
			Set:(EntryDate'="")&&(EntryDate["-") EntryDate=$zdh(EntryDate,3)
			Set:(EntryTime'="")&&(EntryTime[":") EntryTime=$zth(EntryTime,3)
			Set RecordID=aIndex
			Continue:(EntryDate'="")&&(EntryDate<aFromDate)
			Continue:(EntryDate'="")&&(EntryDate>aToDate)
			Set InputStr = RecordID
			Set InputStr = InputStr_"^"_aPaadm
			Set InputStr = InputStr_"^"_obItemID
			Set InputStr = InputStr_"^"_ItemValue
			Set InputStr = InputStr_"^"_EntryDate
			Set InputStr = InputStr_"^"_EntryTime
			Set InputStr = InputStr_"^"_EntryUser
			Set InputStr = InputStr_"^"_1
			Set return=##class(DHCMed.DC.NIS.Observations).Update(InputStr,"^")
		}
	}
	*/
	Quit return
}

/// *********************************************************************************
/// 以下内容为：同步护理管理基础数据方法
/// *********************************************************************************
/// Creator：     zhufei
/// CreatDate：   2016-04-19
/// Description:  护理管理基础数据同步
/// Table：       DHCMed.DC.NIS.*
/// Input：       HospCode ：医院缩写码（DHCMed_DC_SYS.BTHospital.SCode）
/// Return：      OK
/// w ##class(DHCMed.DCEns.NIS.ObResultByV3).ProcBaseData("NIS01")
ClassMethod ProcBaseData(aHospCode As %String, aInitFlag As %String = "0") As %String
{
	New (aHospCode,aInitFlag)
	Set return="0^入参为空"
	Quit:aHospCode="" return
	
	Set return="-1^医院缩写码维护错误"
	Set flg=##class(DHCMed.DC.BTHospital).GetIDBySCode(aHospCode)
	Quit:flg="" return
	
	//处理【基础字典】护理项目
	If aInitFlag=1 {
		Kill ^DHCMed.DC.NIS.BTObItemD
		Kill ^DHCMed.DC.NIS.BTObItemI
	}
	Set flg=..ChangeBTObItem(aHospCode)
	
	Quit "OK"
}

ClassMethod ChangeBTObItem(aHospCode As %String) As %String
{
	New (aHospCode)
	Set InputStr = "1^体温^"_aHospCode_"^TW^1"
	Set flg=##class(DHCMed.DC.NIS.BTObItem).Update(InputStr)
	Set InputStr = "2^大便次数^"_aHospCode_"^DBCS^1"
	Set flg=##class(DHCMed.DC.NIS.BTObItem).Update(InputStr)
	Quit 1
}

/// Creator ：gaojb     
/// CreatDate ：2010-9-9    
/// Description : 解码非ASCII字符
/// Input ：InStr: 需要解码的字串
/// Output : 
/// Return ：成功－解码后的字串，失败－"Error"
/// Others :
ClassMethod UnEscape(InStr As %String) As %String
{
	s $zt="ERROR"
	q:(InStr="") ""
	s num=1,tmpNum=1,retStr=""
	
	for num=1:1:$l(InStr,"%") {
		s char=$p(InStr,"%",num)
	
		if (num=1)
		{
			s retStr=$e(char,1,$l(char))
		}
		else
		{
			if ($zcvt($e(char,1,1),"U")'="U")
			{
				s retStr=retStr_$char($zhex($e(char,1,2)))_$e(char,3,$l(char))
			}
			else
			{
				s retStr=retStr_$char($zhex($e(char,2,5)))_$e(char,6,$l(char))
			}
		}
	}
	
	s retStr=$tr(retStr,"`","%")
	q retStr
	
ERROR
	q "Error"
}

}
