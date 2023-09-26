Class DHCLIS.BLD.DHCBDApprovalReqForm Extends %RegisteredObject
{

/// CreatDate：    20170309
/// Description:： 查询审批单列表(申请单)
/// Table：        
/// Input：        
/// Output：       
/// Return：       
/// Others：  
/// d ##Class(%ResultSet).RunQuery("DHCLIS.BLD.DHCBDApprovalReqForm","QryApprovalReqFormList","20150101","20180101","REF","","","","","","","","","",20,1,"106^10^^13^1")
Query QryApprovalReqFormList(fSttDate, fEndDate, fApprovalCode, fApproveType, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "ApprovalListDR,ApprovalNo,AddDate,AddTime,AddUserName,ApproveType,ApproveDate,ApproveTime,ApproveUserName,ApprovOpinion,ApprovalReason,ApproveTypeDes")
{
}

ClassMethod QryApprovalReqFormListExecute(ByRef qHandle As %Binary, fSttDate, fEndDate, fApprovalCode, fApproveType, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	Set UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5),LocationDR=$p(Sessions,"^",3)
    s RowCount=0
 	s PageSize=+$g(PageSize),PageIndex=+$g(PageIndex),ToRow=0,FormRow=0
 	i PageIndex>0,PageSize>0 s ToRow=PageIndex*PageSize,FormRow=ToRow-PageSize+1
 	
 	s fSttDate = $tr(fSttDate,"-")
 	s fEndDate = $tr(fEndDate,"-")
 	s DepartAppRoval="1"  //1 需要医务科审批才能接收申请单,0否则不需要医务科审批可以接收申请单，但是审批单状态还是医务科待审，医务科可以后补，不影响流程
	s ParameterDR=$o(^dbo.SYSParameterI("IndexCode"," DEPARTAPPROVAL"," SYS"," DHCC","")) 
	i $l(ParameterDR){
	  s ParameterData=$g(^dbo.SYSParameterD(ParameterDR))
	  s DepartAppRoval=$lg(ParameterData,5) 
	}
	s ApprovalDR=""
 	i $l(fApprovalCode) s ApprovalDR =$o(^dbo.BBApprovalTypeI("IndexCode",##Class(LIS.Util.Common).IndexData(fApprovalCode),""))
 	//查询日期内的审批单
 
	
	s AddDate = fSttDate-1
		
	for {
			s AddDate = $o(^dbo.BDApprovalListI("IndexAddDate",AddDate))
			q:AddDate=""
			q:AddDate>fEndDate
			s BDApprovalListDR=""
			for {
				s BDApprovalListDR = $o(^dbo.BDApprovalListI("IndexAddDate",AddDate,BDApprovalListDR))
				q:BDApprovalListDR=""
				s BDApprovalListData = $g(^dbo.BDApprovalListD(BDApprovalListDR))
				s ReqList = $lg(BDApprovalListData,13)
				s ApprovalTypeDR= $lg(BDApprovalListData,3)
				i $l(ApprovalDR),ApprovalTypeDR'=ApprovalDR continue
				s flag=""
	 	        s i = 0 
	 	        for {
	 		      s i =i+1
		 	      q:i>$l(ReqList,",")
		 	      s ReqFormNo = $p(ReqList,",",i)
		 	      i '$l(ReqFormNo) continue
		 	      s ReqFormDR = $o(^dbo.BDReqFormI("IndexReqFormNo",##Class(LIS.Util.Common).IndexData(ReqFormNo),""))
		 	      s ReqFormData = $g(^dbo.BDReqFormD(ReqFormDR))
		 	      s IsExcess = $lg(ReqFormData,50) 
		 	      s Status = $lg(ReqFormData,51)  
		          i IsExcess=1 { 
					      i (DepartAppRoval="1")
				         {
			              i (Status=##class(BLD.ENUM.Common.ReqFormStatus).#DepartWait) s flag="1" q
				         }
				         else{
			               i (Status=##class(BLD.ENUM.Common.ReqFormStatus).#Auth)||(Status=##class(BLD.ENUM.Common.ReqFormStatus).#Receive)||(Status=##class(BLD.ENUM.Common.ReqFormStatus).#TisWait)  s flag="1" q
			             } 
			         
			         
		          }
	 	        }  
	 	        
	 	        s fApproveTypes=""
	 	        i (fApproveType=##class(BLD.ENUM.Common.ApproveType).#Wait){   
		 	        
	 	            s fApproveTypes=##class(BLD.ENUM.Common.ApproveType).#Wait_","_##class(BLD.ENUM.Common.ApproveType).#DeptApprove
		 	        s ApproveDate=$lg(BDApprovalListData,7)
		 	        i $l(ApproveDate) continue
	 	           
	 	          i flag'="1"  continue
	 	        }   
	 	      
	 	        i $l(fApproveTypes) s fApproveTypes=","_fApproveTypes_","
	 	        e  i $l(fApproveType) s fApproveTypes=","_fApproveType_","
				s ApprovalNo = $lg(BDApprovalListData,2) 
				s AddDate = $lg(BDApprovalListData,4)
				s AddTime = $lg(BDApprovalListData,5)
				s AddUserDR = $lg(BDApprovalListData,6)
				s AddUserName=""
				i $l(AddUserDR) s AddUserName=$lg(^dbo.SYSUserD(AddUserDR),3)
				s BDApproveType=$lg(BDApprovalListData,11)
				s ApproveTypeDes=##class(BLD.ENUM.Common.ApproveType).GetStatus(BDApproveType)
				s ApproveType=","_BDApproveType_","
				
				s ApproveDate = $lg(BDApprovalListData,7)
				s ApproveTime = $lg(BDApprovalListData,8)
				s ApproveUserDR = $lg(BDApprovalListData,9)
				s ApproveUserName=""
				i $l(ApproveUserDR) s ApproveUserName = $lg($g(^dbo.SYSUserD(ApproveUserDR)),3)
				s ApprovOpinion = $lg(BDApprovalListData,12)
				s ApprovalReason = $lg(BDApprovalListData,16)
				i $l(fApproveTypes),(fApproveTypes'[ApproveType) continue
				s ApproveType=BDApproveType 
				i $L(fApproveType) s ApproveType=fApproveType
				i fApprovalCode="API",ApproveTypeDes="未提交" continue
				s Data=$lb(BDApprovalListDR,ApprovalNo,AddDate,AddTime,AddUserName,ApproveType,ApproveDate,ApproveTime,ApproveUserName,ApprovOpinion,ApprovalReason,ApproveTypeDes)
				d OutPut
			}
			
		}
 	
 	
	Set qHandle=$lb(0,repid,0)
    q $$$OK
 	
OutPut
	set ColFields="BDApprovalListDR,ApprovalNo,AddDate,AddTime,AddUserName,ApproveType,ApproveDate,ApproveTime,ApproveUserName,ApprovOpinion,ApprovalReason,ApproveTypeDes"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryApprovalReqFormListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryApprovalReqFormListExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryApprovalReqFormListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryApprovalReqFormListExecute ]
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
/// d ##Class(%ResultSet).RunQuery("BLD.WS.BLL.DHCBDApprovalList","QryReqFormListByApr","3","","","","","","","","","","","",20,1,"106^10^^13^1")
Query QryReqFormListByApr(ApprovalListDR, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "ReqFormNo,AdmNo,PatName,Sex,Age,BookDate,Status,ReqTypeCode,ReqTypeName,CheckDate,CheckTime,CheckUserName,Location,Ward,BedNo,ABO,RH,RegNo,MedicalRecordNo,ProductList,IDNumber,Diagnosis")
{
}

ClassMethod QryReqFormListByAprExecute(ByRef qHandle As %Binary, ApprovalListDR, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	//Session数据
	Set UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5),LocationDR=$p(Sessions,"^",3)
    //总数与分页
	s RowCount=0
 	s PageSize=+$g(PageSize),PageIndex=+$g(PageIndex),ToRow=0,FormRow=0
 	i PageIndex>0,PageSize>0 s ToRow=PageIndex*PageSize,FormRow=ToRow-PageSize+1
 	
 	i $l(ApprovalListDR) {
	 	s ApprovalData = $g(^dbo.BDApprovalListD(ApprovalListDR))
	 	s ReqList = $lg(ApprovalData,13)
	 	s i = 0 
	 	for {
	 		s i =i+1
		 	q:i>$l(ReqList,",")
		 	s ReqFormNo = $p(ReqList,",",i)
		 	i '$l(ReqFormNo) continue
		 	s ReqFormDR = $o(^dbo.BDReqFormI("IndexReqFormNo",##Class(LIS.Util.Common).IndexData(ReqFormNo),""))
		 	s ReqFormData = $g(^dbo.BDReqFormD(ReqFormDR))
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
	 	
 	}
	
	
	
 	Set qHandle=$lb(0,repid,0)
    q $$$OK
 	
OutPut
	set ColFields="ReqFormNo,AdmNo,PatName,Sex,Age,BookDate,Status,ReqTypeCode,ReqTypeName,CheckDate,CheckTime,CheckUserName,Location,Ward,BedNo,ABO,RH,RegNo,MedicalRecordNo,ProductList,IDNumber,Diagnosis"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryReqFormListByAprClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReqFormListByAprExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReqFormListByAprFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReqFormListByAprExecute ]
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
/// CreatDate：    20170928
/// Description:： 审批大量审批单
/// Table：       
/// Input：        
/// Output：       
/// Return：       
/// Others
/// w ##Class(DHCLIS.BLD.DHCBDApprovalReqForm).ApprovalReqForm("20","可","9")
ClassMethod ApprovalReqForm(ApprovalListDR As %String, ApprovOpinion As %String, UserID As %String, modeType As %String)
{
    s ^TMP("SZW")=$lb(ApprovalListDR,ApprovOpinion,UserID)
	Set $ZTrap = "ErrorHandle"
	s ApprovalListDR = $g(ApprovalListDR) s ApprovOpinion = $g(ApprovOpinion) s UserID = $g(UserID)
	s CurrentDate = $tr($zd($h,3),"-")
	s CurrentTime = $p($h,",",2)  
	i '$l(ApprovalListDR) q "-1^入参有误"
	i '$l(UserID) q "-1^用户入参有误"
	i '$d(^dbo.BDApprovalListD(ApprovalListDR)) q "-1^未查询到相关审批单"
	S userCode=$P($G(^SSU("SSUSR",UserID)),"^",1)
	S userName=$P($G(^SSU("SSUSR",UserID)),"^",2)
	
	i '$l(userCode) q "-1^用户入参有误"
	//s userCode = $ZCVT(userCode,"U")
	s IndexUserCode=##Class(LIS.Util.Common).IndexData(userCode)
	i '$d(^dbo.SYSUserI("IndexCode",IndexUserCode)) q "-1^用户入参有误"
	s UserDR = $o(^dbo.SYSUserI("IndexCode",IndexUserCode,""))
	
    s Data="<Data>"
    s Data=Data_"<P0>"_ApprovOpinion_"</P0>"
    s Data=Data_"<P1>"_UserDR_"</P1>" 
    //s Data=Data_"<P2>"_UserDR_"</P2>" 
    s Data=Data_"</Data>"
    s $namespace="DHC-LISDATA"
    I modeType="API" s ret=##Class(BLD.WS.BLL.DHCBDApprovalList).DepartApprovalISSUE(ApprovalListDR,Data,"")
    E  s ret=##Class(BLD.WS.BLL.DHCBDApprovalList).DepartApprovalReqForm(ApprovalListDR,Data,"")
    s $namespace="DHC-APP"
      b ; 111
	q ret
	
ErrorHandle
	TROLLBACK
	s RetValue="-1^错误"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
    Quit RetValue
 
END
	TROLLBACK
	Quit RetValue
}

/// Creator：      SZW
/// CreatDate：    20170928
/// Description:： 拒绝审批大量审批单
/// Table：       
/// Input：        
/// Output：       
/// Return：       
/// Others
/// w ##Class(DHCLIS.BLD.DHCBDApprovalReqForm).RefuseApprovalReqForm("14","1111111","2696")
ClassMethod RefuseApprovalReqForm(ApprovalListDR As %String, ApprovOpinion As %String, UserID As %String)
{
	s ^TMP("SZW")=$lb(ApprovalListDR,ApprovOpinion,UserID)
	Set $ZTrap = "ErrorHandle"
	s ApprovalListDR = $g(ApprovalListDR) s ApprovOpinion = $g(ApprovOpinion) s UserID = $g(UserID)
	s CurrentDate = $tr($zd($h,3),"-")
	s CurrentTime = $p($h,",",2)
	
	
	i '$l(ApprovalListDR) q "-1^入参有误"
	i '$l(UserID) q "-1^用户入参有误"
	i '$d(^dbo.BDApprovalListD(ApprovalListDR)) q "-1^未查询到相关审批单"
	
	S userCode=$P($G(^SSU("SSUSR",UserID)),"^",1)
	S userName=$P($G(^SSU("SSUSR",UserID)),"^",2)
	
	i '$l(userCode) q "-1^用户入参有误"
	//s userCode = $ZCVT(userCode,"U")
	s IndexUserCode=##Class(LIS.Util.Common).IndexData(userCode)
	i '$d(^dbo.SYSUserI("IndexCode",IndexUserCode)) q "-1^用户入参有误"
	s UserDR = $o(^dbo.SYSUserI("IndexCode",IndexUserCode,""))
	
	
	//开始事务
	TSTART
	
	s objApproval = ##class(dbo.BDApprovalList).%OpenId(ApprovalListDR)
	if (objApproval.ApproveType '= 10) s RetValue="-1^审批单状态有误"  goto END
	s objApproval.ApproveType = 30
	s objApproval.ApproveDate = CurrentDate
	s objApproval.ApproveTime = CurrentTime
	s objApproval.ApproveUserDR = UserDR
	s objApproval.ApprovOpinion = ApprovOpinion
	s ReqFormNoList = objApproval.ReqList
	s sc = objApproval.%Save()
	If $system.Status.IsError(sc)  s RetValue="-1^更新审批单参数错误:"_$system.Status.GetErrorText(sc) goto END
	
	s index=0
	for {
		s index = index +1
		q:index>$l(ReqFormNoList,",")
		s ReqFormNo = $tr($p(ReqFormNoList,",",index)," ")
		i '$l(ReqFormNo) continue
		s ReqFormDR = $o(^dbo.BDReqFormI("IndexReqFormNo",##Class(LIS.Util.Common).IndexData(ReqFormNo),""))
		i '$l(ReqFormDR) continue
		s ReqFormData = $g(^dbo.BDReqFormD(ReqFormDR))
		s IsExcess = $lg(ReqFormData,50)
		i IsExcess=1 {
			s objReqForm = ##class(dbo.BDReqForm).%OpenId(ReqFormDR)
			i objReqForm.Status '=20 s RetValue="-1^大量用血申请单状态错误" goto END
			s objReqForm.Status = 30
			s sc = objReqForm.%Save()
			if $system.Status.IsError(sc)  s RetValue="-1^更新申请单参数错误:"_$system.Status.GetErrorText(sc) goto END
		}
	}
	
	TCOMMIT
	
	q 0
	
	
ErrorHandle
	TROLLBACK
	s RetValue="-1^错误"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
    Quit RetValue
 
END
	TROLLBACK
	Quit RetValue
}

/// Creator：     zyx
/// CreatDate：   20200513
/// Description:：取消审批大量审批单
/// Table：       
/// Input：        
/// Output：       
/// Return：       
/// Others
ClassMethod ReturnApprovalReqForm(ApprovalListDR As %String, UserID As %String)
{
	s ^TMPLISCTSZYX("SZW")=$lb(ApprovalListDR,UserID)
	Set $ZTrap = "ErrorHandle"
	s ApprovalListDR = $g(ApprovalListDR)  s UserID = $g(UserID)
	s CurrentDate = $tr($zd($h,3),"-")
	s CurrentTime = $p($h,",",2)  
	i '$l(ApprovalListDR) q "-1^入参有误"
	i '$l(UserID) q "-1^用户入参有误"
	i '$d(^dbo.BDApprovalListD(ApprovalListDR)) q "-1^未查询到相关审批单"
	S userCode=$P($G(^SSU("SSUSR",UserID)),"^",1)
	S userName=$P($G(^SSU("SSUSR",UserID)),"^",2)
	
	i '$l(userCode) q "-1^用户入参有误"
	//s userCode = $ZCVT(userCode,"U")
	s IndexUserCode=##Class(LIS.Util.Common).IndexData(userCode)
	i '$d(^dbo.SYSUserI("IndexCode",IndexUserCode)) q "-1^用户入参有误"
	s UserDR = $o(^dbo.SYSUserI("IndexCode",IndexUserCode,""))
	 
   
    s $namespace="DHC-LISDATA"
    s ret=##Class(BLD.WS.BLL.DHCBDApprovalList).DepartUnApprovalReqForm(ApprovalListDR,UserDR,"")
      s $namespace="DHC-APP"
	q ret
	
ErrorHandle
	TROLLBACK
	s RetValue="-1^错误"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
    Quit RetValue
 
END
	TROLLBACK
	Quit RetValue
}

}
