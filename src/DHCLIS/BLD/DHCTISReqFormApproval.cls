Class DHCLIS.BLD.DHCTISReqFormApproval Extends %RegisteredObject
{

/// CreatDate：    20170309
/// Description:： 查询审批单列表(申请单)
/// Table：        
/// Input：        
/// Output：       
/// Return：       
/// Others：  
/// d ##Class(%ResultSet).RunQuery("DHCLIS.BLD.DHCTISReqFormApproval","QryTisApprovalReqFormList","20180710","20180719","","","","","","","","","","",20,1,"106^10^^13^1")
Query QryTisApprovalReqFormList(fSttDate, fEndDate, fApproveType, pLocationCode, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "ReqFormDR,ReqFormNo,Status,LocationName,CheckDate,CheckTime,CheckUserName,HeadCheckRemark,HeadCheckDate,HeadCheckTime,HeadCheckUser")
{
}

ClassMethod QryTisApprovalReqFormListExecute(ByRef qHandle As %Binary, fSttDate, fEndDate, fApproveType, pLocationCode, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
	  
 	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	Set UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5),LocationDR=$p(Sessions,"^",3)
    s RowCount=0
 	s PageSize=+$g(PageSize),PageIndex=+$g(PageIndex),ToRow=0,FormRow=0
 	i PageIndex>0,PageSize>0 s ToRow=PageIndex*PageSize,FormRow=ToRow-PageSize+1
 	
 	s fSttDate = $tr(fSttDate,"-")
 	s fEndDate = $tr(fEndDate,"-")
  
  	//查询日期内的审批单
 	i $l(fSttDate),$l(fEndDate){  
		s CheckDate = fSttDate-1 
		for {
			s CheckDate = $o(^dbo.BDReqFormI("IndexCheckDate",CheckDate)) 
			q:CheckDate=""
			q:CheckDate>fEndDate
			s ReqFormDR=""
			for {
				s ReqFormDR = $o(^dbo.BDReqFormI("IndexCheckDate",CheckDate,ReqFormDR))
				q:ReqFormDR=""
				s ReqFormData=$g(^dbo.BDReqFormD(ReqFormDR))
				s ReqFormNo=$lg(ReqFormData,2)
				s SurName=$lg(ReqFormData,10)
				s Status=$lg(ReqFormData,51)
				s HeadCheckDate=$lg(ReqFormData,108)
				i (Status=10)||(Status=15) continue
				i (Status=25)||(Status=35),'$l(HeadCheckDate) continue
				i $l(fApproveType),(","_fApproveType_",")'[(","_Status_",") continue
				s LocationDR=$lg(ReqFormData,23)
				s LocationName=""
				i $l(LocationDR) 
				{
					s LocationCode=$lg($g(^dbo.BTLocationD(LocationDR)),2)
					i $l(pLocationCode),pLocationCode'=LocationCode continue
					s LocationName=$lg($g(^dbo.BTLocationD(LocationDR)),3)
				}
			
				i $l(LocationName,"-")>1 s LocationName=$p(LocationName,"-",2)
				s CheckDate = $lg(ReqFormData,63)
				s CheckTime = $lg(ReqFormData,64)
				s CheckUserDR = $lg(ReqFormData,65)
				s CheckUserName="",HeadCheckRemark="",HeadCheckDate="",HeadCheckTime="",HeadCheckUser=""
				 
				i $l(CheckUserDR) s CheckUserName = $lg($g(^dbo.SYSUserD(CheckUserDR)),3)
			    s HeadCheckDate=$lg(ReqFormData,108)
			    s HeadCheckTime=$lg(ReqFormData,109)
			    s HeadCheckUserDR=$lg(ReqFormData,110)
			    s HeadCheckRemark=$lg(ReqFormData,111)
			    i (Status=25),'$l(HeadCheckUserDR) continue
			    i $l(HeadCheckUserDR) s HeadCheckUser = $lg($g(^dbo.SYSUserD(HeadCheckUserDR)),3)
				s Data=$lb(ReqFormDR,ReqFormNo,Status,LocationName,CheckDate,CheckTime,CheckUserName,HeadCheckRemark,HeadCheckDate,HeadCheckTime,HeadCheckUser)
				d OutPut
			}
			
		}
 	}
 	
	Set qHandle=$lb(0,repid,0)
    q $$$OK
 	
OutPut
	set ColFields="ReqFormDR,ReqFormNo,Status,LocationName,CheckDate,CheckTime,CheckUserName,HeadCheckRemark,HeadCheckDate,HeadCheckTime,HeadCheckUser"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryTisApprovalReqFormListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTisApprovalReqFormListExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTisApprovalReqFormListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTisApprovalReqFormListExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      SZW
/// CreatDate：    20170410
/// Description:： 根据审批单查询申请单信息
/// Table：        
/// Input：        
/// Output：       
/// Return：       
/// Others：  
/// d ##Class(%ResultSet).RunQuery("DHCLIS.BLD.DHCTISReqFormApproval","QryReqFormInfoByFormDR","200","","","","","","","","","","","",20,1,"106^10^^13^1")
Query QryReqFormInfoByFormDR(ReqFormDR, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "ReqFormNo,AdmNo,PatName,Sex,Age,BookDate,Status,ReqTypeCode,ReqTypeName,CheckDate,CheckTime,CheckUserName,Location,Ward,BedNo,ABO,RH,RegNo,MedicalRecordNo,ProductList,IDNumber,Diagnosis")
{
}

ClassMethod QryReqFormInfoByFormDRExecute(ByRef qHandle As %Binary, ReqFormDR, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	//Session数据
	Set UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5),LocationDR=$p(Sessions,"^",3)
    //总数与分页
	s RowCount=0
 	s PageSize=+$g(PageSize),PageIndex=+$g(PageIndex),ToRow=0,FormRow=0
 	i PageIndex>0,PageSize>0 s ToRow=PageIndex*PageSize,FormRow=ToRow-PageSize+1
 	
 	i $l(ReqFormDR) { 
		 	s ReqFormData = $g(^dbo.BDReqFormD(ReqFormDR))
		 	s ReqFormNo= $lg(ReqFormData,2)
		 	s AdmNo = $lg(ReqFormData,4)
		 	s BookDate = $lg(ReqFormData,40)
		 	s Status = $lg(ReqFormData,51) 
		 	s ReqTypeDR = $lg(ReqFormData,3)
		 	
		 	s (ReqTypeCode,ReqTypeName)=""
		 	i $l(ReqTypeDR) {
				s ReqTypeCode = $lg(^dbo.BBReqTypeD(ReqTypeDR),2)
				s ReqTypeName = $lg(^dbo.BBReqTypeD(ReqTypeDR),3)
			}
		 	s PatName = $lg(ReqFormData,10)
		 	s IDNumber = $lg(ReqFormData,17)
			s SpeciesDR = $lg(ReqFormData,12)
			s Sex = ""
			i $l(SpeciesDR) s Sex = $lg(^dbo.BTSpeciesD(SpeciesDR),3)
			s Age = $lg(ReqFormData,85)
			s WardDR = $lg(ReqFormData,24)
			s Ward=""
			i $l(WardDR) s Ward = $lg(^dbo.BTWardD(WardDR),3)
			i $l(Ward,"-")>1 s Ward=$p(Ward,"-",2)
			s BedNo=$lg(ReqFormData,25)
			s LocationDR= $lg(ReqFormData,23)
			s Location=""
			i $l(LocationDR) s Location = $lg(^dbo.BTLocationD(LocationDR),3)
			i $l(Location,"-")>1 s Location=$p(Location,"-",2)
			s CheckDate=$lg(ReqFormData,63)
			s CheckTime=$lg(ReqFormData,64)
			s CheckUserDR = $lg(ReqFormData,65)
			s CheckUserName=""
			i $l(CheckUserDR) s CheckUserName = $lg($g(^dbo.SYSUserD(CheckUserDR)),3)
			s ABODR = $lg(ReqFormData,18)
			s RHDR = $lg(ReqFormData,19)
			S (ABO,RH)=""
			i $l(ABODR) s ABO = $lg($g(^dbo.BTABOBGD(ABODR)),3)
			i $l(RHDR) s RH = $lg($g(^dbo.BTRHBGD(RHDR)),3)
			s RegNo = $lg(ReqFormData,8)
			s MedicalRecordNo = $lg(ReqFormData,9)
			s Diagnosis = $lg(ReqFormData,26)
		 	s ProductList = ""
	 		s ReqProductDR = ""
	 		s jsonArray=##Class(LIS.JSON.Json).%New()
			S json=##Class(LIS.JSON.Json).%New()
		 	for {
			 	s ReqProductDR = $o(^dbo.BDReqFormProductI("IndexMaster",ReqFormDR,ReqProductDR))
			 	q:ReqProductDR=""
			 	s ReqFormProductDR = $o(^dbo.BDReqFormProductI("IndexMaster",ReqFormDR,ReqProductDR,""))
			 	s ReqFormProductData = $g(^dbo.BDReqFormProductD(ReqFormProductDR))
			 	s ReqProductDR = $lg(ReqFormProductData,3)
			 	s ReqProduct = $lg($g(^dbo.BBReqProductD(ReqProductDR)),3)
			 	s PurposeDR = $lg(ReqFormProductData,4)
			 	s Purpose = $lg(^dbo.BBPurposeD(PurposeDR),3)
			 	s Volumn = $lg(ReqFormProductData,5)
			 	s Unit = $lg(ReqFormProductData,6)
			 	s ReqBloodGroupDR = $lg(ReqFormProductData,9)
		 		s ReqBloodGroup = $lg(^dbo.BBBloodGroupD(ReqBloodGroupDR),3)
		 		D json.AddKeyValue("ReqProduct",ReqProduct) 
				D json.AddKeyValue("Volumn",Volumn) 
				D json.AddKeyValue("Purpose",Purpose) 
				D json.AddKeyValue("Unit",Unit) 
				D json.AddKeyValue("ReqBloodGroup",ReqBloodGroup) 
				S oneItem=json.GetJsonString()
				D jsonArray.InsertRow(oneItem)
		 	}
		 	s ProductList = jsonArray.GetRowsJson()
		 	S Data = $lb(ReqFormNo,AdmNo,PatName,Sex,Age,BookDate,Status,ReqTypeCode,ReqTypeName,CheckDate,CheckTime,CheckUserName,Location,Ward,BedNo,ABO,RH,RegNo,MedicalRecordNo,ProductList,IDNumber,Diagnosis,AgeDesc)
	 		D OutPut
	 	  
	 	
 	}
	
	
	
 	Set qHandle=$lb(0,repid,0)
    q $$$OK
 	
OutPut
	set ColFields="ReqFormNo,AdmNo,PatName,Sex,Age,BookDate,Status,ReqTypeCode,ReqTypeName,CheckDate,CheckTime,CheckUserName,Location,Ward,BedNo,ABO,RH,RegNo,MedicalRecordNo,ProductList,IDNumber,Diagnosis"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryReqFormInfoByFormDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReqFormInfoByFormDRExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReqFormInfoByFormDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReqFormInfoByFormDRExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      baoguotao
/// CreatDate：    20180629
/// Description:：输血科审批申请单列表
/// Table：        
/// Input：        ReqFormDR：申请单DR
/// 	           P0: ApprovOpinion   申请原因
/// Output：       无
/// Return：      1 成功，否则返回错误信息     
/// Others: w ##Class(DHCLIS.BLD.DHCTISReqFormApproval).ApprovalReqForm("364","<Data><P6></P6><P8></P8><P3>62</P3><P12></P12><P2>7</P2><P10></P10><P11></P11><P13></P13><P4></P4><P14></P14><P0>Down</P0><P1>7968^^62^36^1</P1><P9></P9><P7></P7><P5></P5></Data>")
ClassMethod ApprovalReqForm(ReqFormDR As %String, UserID As %String, ApprovalType As %String, ApprovOpinion As %String)
{
  	s ReqFormDR=$g(ReqFormDR),UserID=$g(UserID),ApprovalType=$g(ApprovalType),ApprovOpinion=$g(ApprovOpinion)
    s RetValue="" 
	Set $ZTrap = "ErrorHandle" 
	S userCode=$P($G(^SSU("SSUSR",UserID)),"^",1)
	S userName=$P($G(^SSU("SSUSR",UserID)),"^",2)
	i '$l(userCode) q "-1^用户入参有误"
	s userCode = $ZCVT(userCode,"U")
	i '$d(^dbo.SYSUserI("IndexCode",##Class(LIS.Util.Common).IndexData(userCode))) q "-1^用户入参有误"
	s UserDR = $o(^dbo.SYSUserI("IndexCode",##Class(LIS.Util.Common).IndexData(userCode),""))
	s objReqForm= ##class(dbo.BDReqForm).%OpenId(ReqFormDR) 
   	s Status = objReqForm.Status
   	i (ApprovalType="TisApproval"){
   	  i Status'=21 s RetValue="申请单状态有误" q RetValue
   	}
   	i (ApprovalType="DirectorApproval"){
   	  i Status'=23 s RetValue="申请单状态有误" q RetValue
   	}
   	s DepartAuthProcess="1"
	s ParameterDR=$o(^dbo.SYSParameterI("IndexCode"," DEPARTAUTHPROCESS"," SYS"," DHCC",""))
    i $l(ParameterDR){
	   s ParameterData=$g(^dbo.SYSParameterD(ParameterDR))
	   s DepartAuthProcess=$lg(ParameterData,5) 
	}
	s ParameterDR=$o(^dbo.SYSParameterI("IndexCode"," TISAUTHPROCESS"," SYS"," DHCC",""))
	s TisAuthProcess=""
    i $l(ParameterDR){
	  s ParameterData=$g(^dbo.SYSParameterD(ParameterDR))
	  s TisAuthProcess=$lg(ParameterData,5) 
	}

   	TSTART  
    s RetValue="0"  
    s objReqForm= ##class(dbo.BDReqForm).%OpenId(ReqFormDR) 
   	s Status = objReqForm.Status
    s objReqForm.Status=25  
   	i (TisAuthProcess="1"){
	    i (ApprovalType="DirectorApproval"){
           s objReqForm.Status=21 
	    }
	    i (ApprovalType="TisApproval"){
		   i (objReqForm.IsExcess="1"){  
		      i (DepartAuthProcess="1"){ 
               s objReqForm.Status=20
		      }
		   }
	    }
	    
     } 
     else
     {
	    i (objReqForm.IsExcess="1"){  
	     i (DepartAuthProcess="1"){ 
           s objReqForm.Status=20  
	     }
	   }
     } 
    s labN="DHC-LISDATA"
    s WebN="DHC-APP"
    
      //判断当前申请单状态 若为审核状态则插入医嘱
	If (objReqForm.Status = 25)
		{
			
			s OrdListInfo=$g(^|labN|DHCBLDReqFormordList(ReqFormDR))
			s admId=$lg(OrdListInfo,1)
			s OrdItmList=$lg(OrdListInfo,2)
			s Usercode=$lg(OrdListInfo,3)
			s LocHisCode=$lg(OrdListInfo,4)
			s HospitalCode=$lg(OrdListInfo,5)
			s InsType=$lg(OrdListInfo,6)
			s OrdItmDRList=$lg(OrdListInfo,7)
			s SYSUserDR=$lg(OrdListInfo,8)
			//插入his医嘱
			s $namespace=labN
		    s Ret=##class(Interface.Common.DHCOrderItem).SaveOrderItem(admId,OrdItmList,Usercode,LocHisCode,HospitalCode)
            b ;po
            //i $TLEVEL'=ReqOrdLevel TROLLBACK  s RetValue="-1^医嘱插入失败！" Q  ///预防处理同进程事务没有完成 
            b ;;;01
            i Ret=0 s RetValue="-1^医嘱插入失败！" Q
            i Ret=100 s RetValue="-1^医嘱插入失败！" Q
            i $e(Ret,0,2)="-1" s RetValue=Ret Q
            s IsdealOrdFlag=1
			i Ret["*"
			{
				i (InsType="10")||(InsType="15")||(InsType="20")||(InsType="25")||(InsType="30")
				{
					s IssueRecordDR="" 
					s RetValue=##class(BLDSP.HisOrder).SaveReqFormCostItem(ReqFormDR, InsType, OrdItmDRList, Ret, SYSUserDR, IssueRecordDR)
				  
				}
			}
			s $namespace=WebN
			//审核已经存入记录表中的医嘱信息
		 	s ExecDate = $tr($zd($h,3),"-","")
			s ExecTime = $p($h,",",2)
		 	s OrdItmDRIndex=1
		 	s BDReqFormCostItemDRs=""
		 	s retLabNo="" 
			f
			{
				q:OrdItmDRIndex>$l(OrdItmDRList,"^")
				s OrdItmDRs = $p(OrdItmDRList,"^",OrdItmDRIndex) 
				s HisOrderRet = $p(Ret,"^",OrdItmDRIndex)
				i '$l(OrdItmDRs) s OrdItmDRIndex = OrdItmDRIndex + 1 continue
				s BDReqFormCostItemDR = $p(OrdItmDRs,"@",1)
				i '$l(BDReqFormCostItemDR) s OrdItmDRIndex = OrdItmDRIndex + 1 continue 
				s objReqFormCostItem = ##class(dbo.BDReqFormCostItem).%OpenId(BDReqFormCostItemDR)
				s objReqFormCostItem.ExecDate = ExecDate
				s objReqFormCostItem.ExecTime = ExecTime
				s objReqFormCostItem.ItemStatus = 20
				s objReqFormCostItem.ExecUserDR= SYSUserDR
				s objReqFormCostItem.HISOrderID = $p(HisOrderRet,"*",2)
				s sc = objReqFormCostItem.%Save()
				If ($system.Status.IsError(sc)) {
			 		d ErrorHandle
			 		q
		 		}
		 		b ;09zyx
		 		s thisOrdId=$p($p(HisOrderRet,"*",2),"||",1)
			    s thisOrdSubId=$p($p(HisOrderRet,"*",2),"||",2) 
			    //i $l($p($g(^[WebNamespace]OEORD(thisOrdId,"I",thisOrdSubId,3)),"^",20) ) s retLabNo=$p($g(^[WebNamespace]OEORD(thisOrdId,"I",thisOrdSubId,3)),"^",20) 
			   s retLabNo=$P(Ret,"@@",2)
			    i $l(retLabNo)
			    {
				  //s RetVal= ##Class(HIS.DHCOrderItem).UpdExaReqStatus("AP",objReqFormCostItem.HISOrderID,UserID,retLabNo)
			    }
				s OrdItmDRIndex = OrdItmDRIndex + 1
			}
			
			//关联标本信息
			//如果本次申请无血型复查则关联上次血型复查标本
		    i '$l(retLabNo) {
				s PreReqformDR=""
				for {
					s PreReqformDR=$o(^dbo.BDReqFormI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(admId),PreReqformDR),-1)
					q:(PreReqformDR="")||($l(retLabNo))
					s PreReqformStatus = $lg($g(^dbo.BDReqFormD(PreReqformDR)),51)
					s PreReqformSampleNo= $lg($g(^dbo.BDReqFormD(PreReqformDR)),46)
					i (PreReqformStatus>=25),$l(PreReqformSampleNo) s retLabNo=PreReqformSampleNo q
				}
			} 
			s objReqForm.SampleNo = retLabNo
			s objReqForm.UseSampleNo = retLabNo
			
			
		}
     
     
     b ;zyx08
   	 s sc = objReqForm.%Save()
   	 b ;zyx07
	 If ($system.Status.IsError(sc)) {
	   s RetValue=$SYSTEM.Status.GetErrorText(sc) 
	   d ErrorHandle
	   q
	 } 
	 b ;;;
     i RetValue'=0 TROLLBACK  q 
     i IsdealOrdFlag=1 d  k ^DHCBLDReqFormordList(ReqFormDR)
     s objReqFormOperateRec=##class(dbo.BDReqFormOperateRecord).%New()
     s objReqFormOperateRec.OperateDate=$zd($h,8)
     s objReqFormOperateRec.OperateTime=$p($h,",",2)
     s objReqFormOperateRec.OperateType=23
     s objReqFormOperateRec.OperateUserDR=UserDR
     s objReqFormOperateRec.ReqtFormDR=ReqFormDR
     s objReqFormOperateRec.Remark=ApprovOpinion
     i (ApprovalType="TisApproval"){
       s objReqFormOperateRec.WorkGroupDR=WorkGroupDR
       s objReqFormOperateRec.OperateType=21
     }
     s sc = objReqFormOperateRec.%Save()
	 If ($system.Status.IsError(sc)) {
	   s RetValue=$SYSTEM.Status.GetErrorText(sc) 
	   d ErrorHandle
	   q
	 } 
	 

  i RetValue'=0 TROLLBACK  q RetValue
  TCOMMIT
  q RetValue    
	
ErrorHandle
	TROLLBACK
	//s RetValue="-1^错误"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
    Quit RetValue
}

/// Creator：      baoguotao
/// CreatDate：    20180629
/// Description:：输血科审批申请单列表
/// Table：        
/// Input：        ReqFormDR：申请单DR
/// 	           P0: ApprovOpinion   申请原因
/// Output：       无
/// Return：      1 成功，否则返回错误信息     
/// Others: w ##Class(DHCLIS.BLD.DHCTISReqFormApproval).RefuseApprovalReqForm("364","<Data><P6></P6><P8></P8><P3>62</P3><P12></P12><P2>7</P2><P10></P10><P11></P11><P13></P13><P4></P4><P14></P14><P0>Down</P0><P1>7968^^62^36^1</P1><P9></P9><P7></P7><P5></P5></Data>")
ClassMethod RefuseApprovalReqForm(ReqFormDR As %String, UserID As %String, ApprovalType As %String, ApprovOpinion As %String)
{
 	s ReqFormDR=$g(ReqFormDR),UserID=$g(UserID),ApprovalType=$g(ApprovalType),ApprovOpinion=$g(ApprovOpinion)
    s RetValue="0" 
	Set $ZTrap = "ErrorHandle" 
	S userCode=$P($G(^SSU("SSUSR",UserID)),"^",1)
	S userName=$P($G(^SSU("SSUSR",UserID)),"^",2)
	i '$l(userCode) q "-1^用户入参有误"
	s userCode = $ZCVT(userCode,"U")
	i '$d(^dbo.SYSUserI("IndexCode",##Class(LIS.Util.Common).IndexData(userCode))) q "-1^用户入参有误"
	s UserDR = $o(^dbo.SYSUserI("IndexCode",##Class(LIS.Util.Common).IndexData(userCode),""))
	s objReqForm= ##class(dbo.BDReqForm).%OpenId(ReqFormDR) 
   	s Status = objReqForm.Status
   	i (ApprovalType="TisApproval"){
   	  i Status'=21 s RetValue="申请单状态有误" q RetValue
   	}
   	i (ApprovalType="DirectorApproval"){
   	  i Status'=23 s RetValue="申请单状态有误" q RetValue
   	}
   	   
   	TSTART  
     
   	s objReqForm.Status=24   
   	s objReqForm.HeadCheckDate=$zd($h,8)
   	s objReqForm.HeadCheckTime=$p($h,",",2)
   	s objReqForm.HeadCheckRemark=ApprovOpinion
   	s sc = objReqForm.%Save()
	 If ($system.Status.IsError(sc)) {
	   s RetValue=$SYSTEM.Status.GetErrorText(sc) 
	   d ErrorHandle
	   q RetValue
	}  
    i RetValue'=0 TROLLBACK  q RetValue
    s objReqFormOperateRec=##class(dbo.BDReqFormOperateRecord).%New()
    s objReqFormOperateRec.OperateDate=$zd($h,8)
    s objReqFormOperateRec.OperateTime=$p($h,",",2)
    s objReqFormOperateRec.OperateType=24
    s objReqFormOperateRec.OperateUserDR=UserDR
    s objReqFormOperateRec.ReqtFormDR=ReqFormDR
    s objReqFormOperateRec.Remark=ApprovOpinion
    s sc = objReqFormOperateRec.%Save()
	If ($system.Status.IsError(sc)) {
	   s RetValue=$SYSTEM.Status.GetErrorText(sc) 
	   d ErrorHandle
	   q RetValue
	}  
	
    i RetValue'=0 TROLLBACK  q RetValue   
	TCOMMIT 
    q RetValue

ErrorHandle
	TROLLBACK
    Quit RetValue
}

}
