Class web.DHCENS.STBLL.OPERATION.Method.GetOperationAppInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：lipan
/// CreatDate：2016—06-19
/// Description:手术申请信息
/// Table：
/// Input：手术申请ID
/// w ##class(web.DHCENS.STBLL.OPERATION.Method.GetOperationAppInfo).SendOperApp("25").Read()
ClassMethod SendOperApp(opRowId As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	if opRowId=""{
		set stream=##class(%GlobalCharacterStream).%New()
		d stream.Write("手术申请ID不能为空")
		Quit stream
		
	}
	set request=##class(web.DHCENS.STBLL.OPERATION.Model.Request).%New()
	set header=##class(web.DHCENS.STBLL.OPERATION.Model.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set request.header=header
	set body=##class(web.DHCENS.STBLL.OPERATION.Model.Body).%New()
	
	set OperApps=##class(web.DHCENS.STBLL.OPERATION.Model.OperAppInfo).%New()
	set OperApps = ..GetAnOpApp(opRowId) //获取申请单对象
	
	set body.OperApps=OperApps
	
	set request.body=body
	d request.XMLExportToStream(.stream)
	b ;99
	Quit stream
	
Exception
	b ;b
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

ClassMethod GetAnOpApp(OpRowId As %String) As web.DHCENS.STBLL.OPERATION.Model.OperAppInfo
{
	set Obj=##class(web.DHCENS.STBLL.OPERATION.Model.OperAppInfo).%New()
	set admRowid=$P($G(^DHCANOPArrange(OpRowId)),"^",1)
	set Ret=..GetPatNoByAdmID(admRowid)
	set RegisterNo=$p(Ret,"^",2)
	set OpaAppDate=$P($G(^DHCANOPArrange(OpRowId)),"^",14)
    set:OpaAppDate'="" OpaAppDate=$ZD(OpaAppDate,3)
    set OpaAppTime=$P($G(^DHCANOPArrange(OpRowId)),"^",15)
    set:OpaAppTime'="" OpaAppTime=$ZT(OpaAppTime)
    set ReqDateTime=$G(OpaAppDate)_" "_$G(OpaAppTime)
    set OperatingDeptCode="",OperatingDeptDesc=""
    set PatDeptDr=$P($G(^DHCANOPArrange(OpRowId)),"^",21)
    i PatDeptDr'="" {
		s PatDeptCode=$P($G(^CTLOC(PatDeptDr)),"^",1)
		s PatDeptDesc=$P($G(^CTLOC(PatDeptDr)),"^",2)
		s:PatDeptCode'="" OperatingDeptCode=$G(PatDeptCode)
		s:PatDeptDesc'="" OperatingDeptDesc=$G(PatDeptDesc)
    }
    set SEQUENCE=$P($G(^DHCANOPArrange(OpRowId)),"^",26)    
	set Obj.PATPatientID=RegisterNo
	set Obj.PAADMVisitNumber=admRowid
	set Obj.SCHEDULEID=$G(OpRowId)
	set AdmInfo=..GetAdmInfoByRowid(admRowid)
	set Obj.DEPTSTAYED=$p(AdmInfo,"^",1)
	set Obj.BEDNO=$p(AdmInfo,"^",2)
	set Obj.SCHEDULEDDATETIME=ReqDateTime
	set Obj.SEQUENCE=SEQUENCE
	
	set operRoomDr=$P($G(^DHCANOPArrange(OpRowId)),"^",20)
    set:operRoomDr'="" Obj.OPERATINGROOMNO=$p(^DHCANC("OPRoom",operRoomDr),"^",1)
	s AnaId=$P($G(^DHCANOPArrange(OpRowId)),"^",2)
	s AdmId=$P(AnaId,"||",1)
	s AnaSub=$P(AnaId,"||",2)	
	
    s AnmedthodDr=$P($G(^OR(AdmId,"ANA",AnaSub)),"^",5)
    s AnaDr=$P($G(^OR(AdmId,"ANA",AnaSub)),"^",6)    
    s OpaEmergencyFlage=$P($G(^OR(AdmId,"ANA",AnaSub)),"^",32)
    
    //ANA_SourceType 急诊(1)/择期(0)
    s Obj.EMERGENCYINDICATOR=$case(OpaEmergencyFlage,"B":"0","E":"1",:"0")
    
    
	s AnaOpSub=0,OperDiagCode="",OperDiagDesc="",OplevelDesc=""
	s AnaOpSub=$O(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub))
	s OpasDr1="",OpasDr2="",OpasDr3="",OpasDr4="",OperDiagDr="",OpSurgeonDr=""
	s AnassDr1="",AnassDr2="",AnassDr3="",AnassDr4="",AnassDr5="",AnassDr6="",AnassDr7=""
	s OpscnDr1="",OpscnDr2="",OperDr=""
	s OpcirnDr1="",OpcirnDr2="",OpcirnDr3=""
	s AnaNotes=""
	s OperPositionId=""	
    
	i AnaOpSub'="" {
		s OperDiagDr=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub)),"^",4)
	    s OpSurgeonDr=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub)),"^",8)
	    s OpasDr1=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"ASS",1)),"^",1)
	    s OpasDr2=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"ASS",2)),"^",1)	
	    s OpasDr3=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"ASS",3)),"^",1)
	    s OpasDr4=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"ASS",4)),"^",1)
    
	    s AnassDr1=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"ANASS",1)),"^")
		s AnassDr2=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"ANASS",2)),"^")
	    s AnassDr3=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"ANASS",21)),"^")
	    s AnassDr4=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"ANASS",22)),"^")
	    s AnassDr5=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"ANASS",23)),"^")
	    s AnassDr6=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"ANASS",24)),"^")
	    s AnassDr7=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"ANASS",25)),"^")
	    s OpscnDr1=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"SCN",1)),"^")
	    s OpscnDr2=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"SCN",21)),"^")
		s OpcirnDr1=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"CIRN",1)),"^")
	    s OpcirnDr2=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"CIRN",21)),"^")
	    s OpcirnDr3=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"CIRN",3)),"^")
	    s AnaNotes=$G(^OR(AdmId,"ANA",AnaSub,"TXT"))
		s OperPositionId=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"POS",1)),"^")
		s OperDr=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub)),"^",6)
		
		s OperRoomId=$P($G(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub)),"^",10)
		b ;xxx
		s:OperRoomId'="" Obj.OPERATINGROOM=$P($G(^CTLOC(OperRoomId)),"^",1)
	}

	i OperDiagDr'="" {
		s OperDiagDesc=$P($G(^MRC("ID",OperDiagDr)),"^",2)		
	    s Obj.DIAGBEFOREOPERATION=$G(OperDiagDesc)
	}
    
    s OperDesc="",oplevelDesc="",OperCode=""
    
    set OperObj=##class(web.DHCENS.STBLL.OPERATION.Model.OperDetail).%New()
	set OperObj.OPERATIONCODE=""
	i OperDr'=""{
		b ;hh
		s OperCode=$P($G(^ORC("OPER",OperDr)),"^",1)
		s OperDesc=$P($G(^ORC("OPER",OperDr)),"^",2)
		s OperationScale=$P($G(^ORC("OPER",OperDr)),"^",7)
		s OperObj.OPERATIONNO=$G(OperCode)
	    s OperObj.OPERATION=$G(OperDesc)
	    s:OperationScale'="" Obj.OPERATIONSCALE=$p($G(^ORC("CATEG",OperationScale)),"^",2)
	}else {
    // 手写手术名称
	    s OperObj.OPERATION=$g(^OR(AdmId,"ANA",AnaSub,"OP",AnaOpSub,"REM",2))
	}
	
	set Obj.PATIENTCONDITION=""
	
	i $P($G(^DHCANOPArrange(OpRowId)),"^",10)="" {
    	set Obj.ISOLATIONINDICATOR=1
	}else {
    	set Obj.ISOLATIONINDICATOR=$P($G(^DHCANOPArrange(OpRowId)),"^",10)
    }
	
	i OpSurgeonDr'="" {
		s OpSurgeonCode=$P($G(^CTPCP(OpSurgeonDr,1)),"^",1)
		s Obj.SURGEON=$G(OpSurgeonCode)
		
		s userrowid=$o(^SSU("SSUSR",0,"CTPCP",OpSurgeonDr,""))
		s deptrowid=$p(^SSU("SSUSR",userrowid),"^",4)
		set:deptrowid'="" Obj.OPERATINGDEPT=$p(^CTLOC(deptrowid),"^",1)
		
	}
	s OpasId1="",OpasId2="",OpasId3="",OpasId4="",AnmedthodDesc=""
	
	set:OpasDr1'="" OpasId1=$P($G(^CTPCP(OpasDr1,1)),"^",1)
	set:OpasDr2'="" OpasId2=$P($G(^CTPCP(OpasDr2,1)),"^",1)
	set:OpasDr3'="" OpasId3=$P($G(^CTPCP(OpasDr3,1)),"^",1)
	set:OpasDr4'="" OpasId4=$P($G(^CTPCP(OpasDr4,1)),"^",1)
	
	i AnmedthodDr'="" {
	   	s Length=$l(AnmedthodDr,"|")
	   	for k=1:1:Length-1 {
		   	if (AnmedthodDesc'="") {
			    s AnmedthodDesc=AnmedthodDesc_"^"_$P($G(^ORC("ANMET",$p(AnmedthodDr,"|",k))),"^",2)
			    s AnmedthodCode=AnmedthodCode_"^"_$P($G(^ORC("ANMET",$p(AnmedthodDr,"|",k))),"^",1)
		   	}else{
			    s AnmedthodDesc=$P($G(^ORC("ANMET",$p(AnmedthodDr,"|",k))),"^",2)
			    s AnmedthodCode=$P($G(^ORC("ANMET",$p(AnmedthodDr,"|",k))),"^",1)
		   	}
	   	}
   	}
    i $l(AnmedthodDesc,"-")>1 {
	    s AnmedthodDesc=$p(AnmedthodDesc,"-",2)
	    s Obj.ANESTHESIAMETHOD=$G(AnmedthodDesc)
    }
    i AnaDr'=""{
		s AnaId=$P($G(^CTPCP(AnaDr,1)),"^",1)
		s AnaCode=$P($G(^CTPCP(AnaDr,1)),"^",1)
		s Obj.ANESTHESIADOCTOR=$G(AnaCode)
    }
    s AnassId1="",AnassId2="",AnassId3="",AnassId4="",AnassId5="",AnassId6="",AnassId7=""
	s AnassDesc1="",AnassDesc2="",AnassDesc3="",AnassDesc4="",AnassDesc5="",AnassDesc6="",AnassDesc7=""
	set:AnassDr1'="" AnassId1=$P($G(^CTPCP(AnassDr1,1)),"^",1)
	set:AnassDr2'="" AnassId2=$P($G(^CTPCP(AnassDr2,1)),"^",1)
	set:AnassDr3'="" AnassId3=$P($G(^CTPCP(AnassDr3,1)),"^",1)
	set:AnassDr4'="" AnassId4=$P($G(^CTPCP(AnassDr4,1)),"^",1)
	set:AnassDr5'="" AnassId5=$P($G(^CTPCP(AnassDr5,1)),"^",1)
	set:AnassDr6'="" AnassId6=$P($G(^CTPCP(AnassDr6,1)),"^",1)
	set:AnassDr7'="" AnassId7=$P($G(^CTPCP(AnassDr7,1)),"^",1)
	
	
	set Obj.FIRSTASSISTANT=$G(OpasId1)  
	set Obj.SECONDASSISTANT=$G(OpasId2)  
	set Obj.THIRDASSISTANT=$G(OpasId3)  
	set Obj.FOURTHASSISTANT=$G(OpasId4)  

	set Obj.SECONDANESTHESIADOCTOR=$G(AnassId1)
	set Obj.THIRDANESTHESIADOCTOR=$G(AnassId2)
	set Obj.ANESTHESIAASSISTANT=$G(AnassId3)
	set Obj.SECONDANESTHESIAASSISTANT=$G(AnassId4)
	set Obj.THIRDANESTHESIAASSISTANT=$G(AnassId5)
	set Obj.FOURTHANESTHESIAASSISTANT=$G(AnassId6)
	set Obj.BLOODTRANDOCTOR=$G(AnassId7)
	
	s OpscnId1="",OpscnId2=""
	set:OpscnDr1'="" OpscnId1=$P($G(^CTPCP(OpscnDr1,1)),"^",1)
	set:OpscnDr2'="" OpscnId2=$P($G(^CTPCP(OpscnDr2,1)),"^",1)
    set Obj.FIRSTOPERATIONNURSE=$G(OpscnId1)
    set Obj.SECONDOPERATIONNURSE=$G(OpscnId2)
    
    s OpcirnId1="",OpcirnId2="",OpcirnId3=""
	set:OpcirnDr1'="" OpcirnId1=$P($G(^CTPCP(OpcirnDr1,1)),"^",1)
	set:OpcirnDr2'="" OpcirnId2=$P($G(^CTPCP(OpcirnDr2,1)),"^",1)
	set:OpcirnDr3'="" OpcirnId3=$P($G(^CTPCP(OpcirnDr3,1)),"^",1)
	
	set Obj.FIRSTSUPPLYNURSE=$G(OpcirnId1)
	set Obj.SECONDSUPPLYNURSE=$G(OpcirnId2)
	set Obj.THIRDSUPPLYNURSE=$G(OpcirnId3)
	set Obj.NOTESONOPERATION=$G(AnaNotes)
	set OPAAppDate=$p($g(^DHCANOPArrange(OpRowId)),"^",3)
	set OPAAppTime=$p($g(^DHCANOPArrange(OpRowId)),"^",5)
	if (OPAAppDate'="")&&(OPAAppTime'=""){
		set Obj.REQDATETIME=$zd(OPAAppDate,3)_" "_$zt(OPAAppTime)
	}else{
		set curTime=$h
		set Obj.REQDATETIME=$zd(+curTime,3)_" "_$zt($p(curTime,",",2))
	}

	s EnteredBy=$P($G(^DHCANOPArrange(OpRowId)),"^",6)
    set:EnteredBy'="" Obj.ENTEREDBY=$P($G(^CTPCP(EnteredBy,1)),"^",1)
	set Obj.STATUS=$P($G(^DHCANOPArrange(OpRowId)),"^",27)
	
	set AdmTypeCode=$p($g(^PAADM(admRowid)),"^",2)
	set Obj.AdmTypeCode=AdmTypeCode
	set Obj.AdmTypeDesc=$case(AdmTypeCode,"O":"门诊","I":"住院","E":"急诊","H":"体检","N":"新生儿")
	set AdmStatusCode=$p($g(^PAADM(admRowid)),"^",20)
	set:AdmStatusCode'="" Obj.AdmStatusCode=AdmStatusCode
	set:AdmStatusCode'="" Obj.AdmStatusDesc=$case(AdmStatusCode,"A":"在就诊","C":"取消就诊","D":"出院","P":"预约")
	d Obj.OPERATIONS.Insert(OperObj)
	q Obj
}

/// 通过就诊rowid得到病人Rowid^登记号^就诊号
ClassMethod GetPatNoByAdmID(adm As %String) As %String
{
	q:adm="" ""
	s RegisterNo=""
	s patId=$p(^PAADM(adm),"^",1)
	s RegisterNo=$p($g(^PAPER(patId,"PAT",1)),"^",1)
	s Ret=patId_"^"_RegisterNo_"^"_adm
	q Ret
}

/// 通过就诊rowid得到病人就诊信息
ClassMethod GetAdmInfoByRowid(adm As %String) As %String
{
	q:adm="" ""
	s AdmDeptCode=""
	s AdmDetpRowID=$P($g(^PAADM(adm)),"^",4)
	s:AdmDetpRowID'="" AdmDeptCode=$p($g(^CTLOC(AdmDetpRowID)),"^",1)
	
	s CurrentBedNo=""
	s CurrentBedRowID=$P($g(^PAADM(adm)),"^",73)
	i ($d(CurrentBedRowID)'=0)&&(CurrentBedRowID'="")&&($l(CurrentBedRowID,"||")>1)
	{
		s BedWordRowID = $p(CurrentBedRowID,"||",1)
		s BedChildSub = $p(CurrentBedRowID,"||",2)
		i $d(^PAWARD(BedWordRowID,"BED"))=10
		{
			s CurrentBedNo=$p($g(^PAWARD(BedWordRowID,"BED",BedChildSub)),"^",1)
		}
	}
	q AdmDeptCode_"^"_CurrentBedNo
}

}
