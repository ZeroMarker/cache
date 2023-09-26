Class web.DHCENS.STBLL.DRUG.METHOD.UpdatePharmaceutStatus Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right ]
{

/// Description:配药完成 MessageID,301:配药完成，302:取消配药，303:重分窗口
/// Debug:w ##class(web.DHCENS.STBLL.DRUG.METHOD.UpdatePharmaceutStatus).UpdatePharmaceutStatus("<Request> <ResultCode></ResultCode> <ResultContent></ResultContent> <Status> <UpdatePharmaceutStatus> <pharmacyid>192.168.0.101</pharmacyid> <!--发药机IP地址--> <patientid>0000000833</patientid> <!--患者登记号--> <presno>O200415000010</presno> <!--处方号--> <winno>门诊配药1</winno> <!--配药窗口号--> <datetime>2020-04-15 16:09:09</datetime> <!--发药日期时间--> <MessageID>301</MessageID> <!--配药状态：301配药完成，302取消配药，303重分窗口--> <UserCode>yf01</UserCode> <!--更新人代码--> <UpdateOPDrugStatus> <ADVICE_CODE>1186||11</ADVICE_CODE> <!--医嘱明细ID --> <DRUG_CODE>XKF000673</DRUG_CODE> <!--药品代码--> <QUANTITY>1</QUANTITY> <!--药品数量--> </UpdateOPDrugStatus> </UpdatePharmaceutStatus> </Status></Request>")
ClassMethod UpdatePharmaceutStatus(Input As %String) As %String
{
	Set $zt="SendMessageET"
	set reader = ##class(%XML.Reader).%New()
    do reader.OpenString(Input)
    do reader.Correlate("Request","web.DHCENS.STBLL.DRUG.MODEL.UpdatePharmaceutStatusList")
    set presno="",UserCode="",MessageID="",winno="",tmpInput=""
    while reader.Next(.obj,.sc)
    {
	    set Length=obj.Status.Count()
	    for i=1:1:Length
	    {
		    set ObjUpdate=obj.Status.GetAt(i)
		    set MessageID=ObjUpdate.MessageID
		    set winno=ObjUpdate.winno
		    set phlno=ObjUpdate.pharmacyid
		    if presno=""
		    {
	    		set presno=ObjUpdate.presno
		    }
		    else
		    {
			    set presno=presno_"^"_ObjUpdate.presno
		    }
		    set DrugLength=ObjUpdate.OrugOrdStatus.Count()
		    set tmpInput=""
		    for j=1:1:DrugLength
		    {
			    set ObjDrugStatus=ObjUpdate.OrugOrdStatus.GetAt(j)
			    if tmpInput=""
			    {
				    set tmpInput=ObjDrugStatus.AdviceCode_$c(2)_ObjDrugStatus.DrugCode_$c(2)_ObjDrugStatus.Quantity
			    }
			    else
			    {
				    set tmpInput=tmpInput_"###"_ObjDrugStatus.AdviceCode_$c(2)_ObjDrugStatus.DrugCode_$c(2)_ObjDrugStatus.Quantity
			    }
		    }
		    set presno=presno_$c(28)_tmpInput
	    	set UserCode=ObjUpdate.UserCode
	    }
    }
	
	set result=##Class(web.DHCSTInterfacePH).RecDataToInsertPHDisp(MessageID,presno,UserCode,winno)
	if (result=0)
	{
		Quit "<ROOT><RETVAL></RETVAL><RETMSG>成功</RETMSG><RETCODE>1</RETCODE></ROOT>"
	}
	else
	{
		Quit "<ROOT><RETVAL>0</RETVAL><RETMSG>"_result_"</RETMSG><RETCODE>0</RETCODE></ROOT>"
	}
SendMessageET
	Quit "<ROOT><RETVAL>0</RETVAL><RETMSG><![CDATA["_$ze_"]]></RETMSG><RETCODE>0</RETCODE></ROOT>"
}

}
