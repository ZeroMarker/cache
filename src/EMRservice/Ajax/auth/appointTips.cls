/// 名称:	EMRservice.Ajax.auth.appointTips
/// 描述:	病历集中授权提示控制
/// 编写者:	yejian
/// 编写日期: 	2022-1-6
/// 产品组：	电子病历产品组
Class EMRservice.Ajax.auth.appointTips Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s $zt = "ErrorHandler"
	s action = $Get(%request.Data("Action",1),"")
	if (action="GetAppointPrinted")
	{
		//AppointDatas "41:268||1^370||1,67:252||2^283||5^386||2^253||3"
		s strAppointDatas = $Get(%request.Data("AppointDatas",1),"")
		s strRes = ##class(EMRservice.Ajax.auth.appointTips).GetAppointPrinted(strAppointDatas)
		w strRes
	}
	Quit $$$OK
ErrorHandler
	q ""
}

/// Desc:       授权之前获取是否已有打印的提示信息
/// Creator:    yejian
/// Createdate: 2022-1-6
/// Input:      strAppointDatas 选中授权数据"就诊号:实例ID^实例ID2,就诊2:实例ID^实例ID2"
/// Output:     不提示 ""，提示"当前病历《病历名字》已于***（时间），由***（操作人）打印过，请注意!"：
/// debug w ##class(EMRservice.Ajax.auth.appointTips).GetAppointPrinted("41:268||1^370||1,67:252||2^283||5^386||2^253||3")
ClassMethod GetAppointPrinted(aAppointDatas As %String) As %String
{
	s strRes =""
	q:(aAppointDatas="") strRes
	s isPrintMsg = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("SetAppointPrintMsg","N")
	q:(isPrintMsg="N") strRes
	s episodeids = $l(aAppointDatas,",")
	//实例ID排重处理
	s listIds = ##class(%ListOfDataTypes).%New()
	for i=1:1:episodeids
	{
		s strDatas = $p(aAppointDatas,",",i)
		s episodeid = $p(strDatas,":",1)
		s instanceDatas = $p(strDatas,":",2)
		s indCount = $l(instanceDatas,"^")
		for j=1:1:indCount
		{
			s instanceID =$p(instanceDatas,"^",j) 
			s rowID = ""
			s rowID = $o(^DHCEMRI.InstancePrintRecordI("IdxInstanceDataID"," "_instanceID,""))
			if (rowID'="")
			{
				s objPrintRecord = ##class(EMRinstance.InstancePrintRecord).%OpenId(rowID)
				s objInstanceData = ##class(EMRinstance.InstanceData).%OpenId(instanceID)
				continue:(objInstanceData="")
				//缓存包含实例执行下一条，否则插入缓存
				s strListID = listIds.Find(instanceID)
				continue:(strListID'="")
				d:(strListID="") listIds.Insert(instanceID)
				s strUser = ""
				s:(objPrintRecord.CreateUserID'="") strUser = $p($g(^SSU("SSUSR",objPrintRecord.CreateUserID)),"^",2) 
				s strMessage = "当前病历《"_objInstanceData.Title_"》已于"_$ZDATE(objPrintRecord.CreateDate,3)_",由"_strUser_"打印过,请注意!"
				d objInstanceData.%Close(),objPrintRecord.%Close()
				k objInstanceData,objPrintRecord
				s strRes =strRes_" "_strMessage
			}
		}
	}
	q strRes
}

}
