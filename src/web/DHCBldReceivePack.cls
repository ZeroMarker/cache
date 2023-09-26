Class web.DHCBldReceivePack Extends %RegisteredObject
{

/// Creator：      wwh
/// CreatDate：    2014-09-21
/// Description:： 获取血制品信息
/// Table：        无
/// Input：        donorID:血袋编码(献血码),productID:血制品编码(区别码)
/// Return：       1RowID:血制品RowID,2DonorID:血袋编码,3ProductID:血制品编码,4ProductDesc:血制品描述,5BloodGroupID:血型ID,6BloodGroup:血型,
/// 			   7Volume:血制品量,8Unit:血制品单位,9ProductGroupID:血成份ID,10ProductGroup:血成份,11StoreStatus:库存状态,
/// 				   12TransStatus:处理状态,13TransDesc:处理操作,14ExpireDateTime:失效日期时间,15IssueDateTime:发血日期时间,
/// 			   16IssueUser:发血者,17XMMajor:主侧配血结果,18XMMinor:次侧配血结果,19XMResult:交叉配血结果,
/// 			   20XMDateTime:配血日期时间,21XMUser:配血者,22PatName:受血者姓名,23PatSex:受血者性别,24PatAge:受血者年龄,
/// 			   25PatientID:受血者登记号,26PatBldGroup:受血者血型,27Location:就诊科室,28LabRowID:检验医嘱RowID,
/// 			   29IsTrans:是否已经输用,30IsReaction:是否不良反应,31IsRetrieve:是否已回收,32AdmID:就诊号,33Ward:病区,34Bed:床号
/// Others：           
/// W ##Class(web.DHCBldReceivePack).GetPack("=0160214041135","=<P0065V00")
ClassMethod GetPack(donorID As %String, productBC As %String) As %String
{
	
	s PackBarCode=$g(donorID),ProdcutBarCode=$g(productBC)   
	s retStr="" 
	s packpattern="[@*=<|]"
	s PackBarCode=$tr(PackBarCode,packpattern)
	s supplierCode=$e(PackBarCode,1,5)
	s supplierDR=$o(^dbo.BBSupplierI("IndexCode",##Class(LIS.Util.Common).IndexData(supplierCode),""))
	i '$l(supplierDR) s retStr="-1^未查询到血液血站信息" Q retStr
	s BloodProductDR="",BarCodeExit=0
	for{
	  s BloodProductDR=$o(^dbo.BBBloodProductSupplierI("IndexSupplier",supplierDR,BloodProductDR)) 
	  q:(BloodProductDR="")||(BarCodeExit=1)
	  s BloodProductSupplierDR=""
	  for
	  {
		 s BloodProductSupplierDR=$o(^dbo.BBBloodProductSupplierI("IndexSupplier",supplierDR,BloodProductDR,BloodProductSupplierDR)) 
	     q:(BloodProductSupplierDR="")||(BarCodeExit=1)
	     s BloodProductSupplierData=$g(^dbo.BBBloodProductSupplierD(BloodProductSupplierDR))
	     s BarCode=$lg(BloodProductSupplierData,4)
	     s SpecialChar=$lg(BloodProductSupplierData,7)
	     s Positions=$lg(BloodProductSupplierData,8) 
	     s ProdcutBarCode=$tr(ProdcutBarCode,SpecialChar)  
	  }
	} 
	
	i '$d(^dbo.BDPackI("IndexBarcode",##Class(LIS.Util.Common).IndexData(PackBarCode),##Class(LIS.Util.Common).IndexData(ProdcutBarCode))) q ""
	s RowID=$o(^dbo.BDPackI("IndexBarcode",##Class(LIS.Util.Common).IndexData(PackBarCode),##Class(LIS.Util.Common).IndexData(ProdcutBarCode),""),-1)
	s BDPackData=$g(^dbo.BDPackD(RowID))
	s DonorID=$lg(BDPackData,2)
	s ProductID=$lg(BDPackData,6)
	s BloodProductDR=$lg(BDPackData,3)
	s BloodProductData=$g(^dbo.BBBloodProductD(BloodProductDR))
	s ProductDesc=$lg(BloodProductData,3)
	s BloodGroupDR=$lg(BDPackData,9)
	s BloodGroupID=BloodGroupDR
	s BloodGroupData=$g(^dbo.BBBloodGroupD(BloodGroupDR))
	s BloodGroup=$lg(BloodGroupData,3)
	s BloodABOCode=$lg(BloodGroupData,4)
	s BloodRhCode=$lg(BloodGroupData,5)
	s Volume=$lg(BDPackData,10)
	s Unit=$lg(BloodProductData,15)
	s BloodComponentsDR=$lg(BloodProductData,10)
	s ProductGroupID=BloodComponentsDR
	s ProductGroup=$lg($g(^dbo.BBBloodComponentsD(BloodComponentsDR)),3)
	s StoreStatusDR=$lg(BDPackData,34),StoreStatus=""
	i $l(StoreStatusDR) s StoreStatus=$lg(^dbo.BBPackStatusD(StoreStatusDR),3)
	s TransDR=$o(^dbo.BDPackTransactionI("IndexPack",RowID,""),-1)
	s NewPackStatusDR=$lg(^dbo.BDPackTransactionD(TransDR),9)
	s TransStatus=$lg(^dbo.BBPackStatusD(NewPackStatusDR),3)
	s TransactionDR=$lg(^dbo.BDPackTransactionD(TransDR),6),TransDesc=""
	i $l(TransactionDR) s TransDesc=$lg(^dbo.BBTransactionD(TransactionDR),3)
	s ExpiredDate=$lg(BDPackData,13),ExpireDateTime=""
	i $l(ExpiredDate) s ExpiredDate=$e(ExpiredDate,1,4)_"-"_$e(ExpiredDate,5,6)_"-"_$e(ExpiredDate,7,8)
	s ExpiredTime=$lg(BDPackData,14)
	i $l(ExpiredTime) s ExpiredTime=$zt(ExpiredTime)
	s ExpireDateTime=ExpiredDate_" "_ExpiredTime
	s IssRecordDR="",ReqFormDR=""
	&sql(SELECT IssueRecordDR INTO IssRecordDR FROM dbo.BD_IssueRecordItems WHERE PackDR=:RowID AND IsReturned=0)
	s IssueDateTime="",IssueUser=""
	i IssRecordDR>0 d
	.s IssRecordData=$g(^dbo.BDIssueRecordD(IssRecordDR))
	.s IssueDate=$lg(IssRecordData,4),IssueDT=""
	.s IssueTime=$lg(IssRecordData,5)
	.s ReqFormDR=$lg(IssRecordData,11)
	.i $l(IssueDate) s IssueDate=$e(IssueDate,1,4)_"-"_$e(IssueDate,5,6)_"-"_$e(IssueDate,7,8)
	.i $l(IssueTime) s IssueTime=$zt(IssueTime)
	.s IssueDateTime=IssueDate_" "_IssueTime
	.s IssueUserDR=$lg(IssRecordData,6),IssueUser=""
	.i $l(IssueUserDR) s IssueUser=$lg(^dbo.SYSUserD(IssueUserDR),3)
	s XMMajor="",XMMinor="",XMResult="",XMUser=""
	s XMPalnDR=""
	&sql(select RowID into XMPalnDR from dbo.BD_XMPlan where PackDR=:RowID and ReqFormDR=:ReqFormDR)
	i XMPalnDR>0 d
	.s XMPlanData=$g(^dbo.BDXMPlanD(XMPalnDR))
	.s XMCheckDate=$lg(XMPlanData,27)
 	.s XMCheckTime=$lg(XMPlanData,28),XMDateTime=""
 	.i $l(XMCheckDate) s XMCheckDate=$e(XMCheckDate,1,4)_"-"_$e(XMCheckDate,5,6)_"-"_$e(XMCheckDate,7,8)
 	.i $l(XMCheckTime) s XMCheckTime=$zt(XMCheckTime)
 	.s XMDateTime=XMCheckDate_" "_XMCheckTime
 	.b ; 2
 	.s XMCheckUserDR=$lg(XMPlanData,29),XMUser=""
 	.i $l(XMCheckUserDR) s XMUser=$lg(^dbo.SYSUserD(XMCheckUserDR),3)
 	.s XMResult=$lg(XMPlanData,24) //最终结果
 	.s XMMethodDR=$lg(XMPlanData,22),XMMethod=""
	.i $l(XMMethodDR) s XMMethod=$lg($g(^dbo.BBXMMethodD(XMMethodDR)),3)
	.s XMMajor=$lg(XMPlanData,12)
    .s XMMinor=$lg(XMPlanData,18)
    
 	s ReqFormData=$g(^dbo.BDReqFormD(ReqFormDR))
 	s SurName=$lg(ReqFormData,10),PatName=""
    s GivenName=$lg(ReqFormData,11)
    i SurName'=GivenName s PatName=SurName_GivenName
    e  s PatName=SurName
	s SpeciesDR=$lg(ReqFormData,12),PatSex=""
    i $l(SpeciesDR) s PatSex=$lg($g(^dbo.BTSpeciesD(SpeciesDR)),3)
 	s PatAge=$lg(ReqFormData,85)
 	s PatientID=$lg(ReqFormData,8)
 	s ABODR=$lg(ReqFormData,18),ABO="未知"
 	i $l(ABODR) s ABO=$lg(^dbo.BTABOBGD(ABODR),3)
 	s RHDR=$lg(ReqFormData,19),RH=""
 	i $l(RHDR) s RH=$lg(^dbo.BTRHBGD(RHDR),3)
 	s PatBldGroup=ABO_RH
 	s LocationDR=$lg(ReqFormData,23),Location=""
    i $l(LocationDR) s Location=$lg(^dbo.BTLocationD(LocationDR),3)
	s SampleNo=$lg(ReqFormData,46)
	s InfusionStartDate=$lg(BDPackData,62),IsTrans="否"
	i $l(InfusionStartDate) s IsTrans="是"
	s ReactionDR="",IsReaction="否"
	&sql(select RowID into ReactionDR from dbo.BD_ReactionLinkPack where PackDR=:RowID)
    if ReactionDR>0 s IsReaction="是"
	s CallbackDate=$lg(BDPackData,69),IsRetrieve="否"
	i $l(CallbackDate) s IsRetrieve="是"
	s AdmID=$lg(ReqFormData,4)
	s WardDR=$lg(ReqFormData,24),Ward=""
    i $l(WardDR) s Ward=$lg(^dbo.BTWardD(WardDR),3)
    s BedNo=$lg(ReqFormData,25)
	s RetValue=RowID_"^"_DonorID_"^"_ProductID_"^"_ProductDesc_"^"_BloodGroupID_"^"_BloodGroup_"^"_Volume_"^"_Unit_"^"_ProductGroupID
	s RetValue=RetValue_"^"_ProductGroup_"^"_StoreStatus_"^"_TransStatus_"^"_TransDesc_"^"_ExpireDateTime_"^"_IssueDateTime
	s RetValue=RetValue_"^"_IssueUser_"^"_XMMajor_"^"_XMMinor_"^"_XMResult_"^"_XMDateTime_"^"_XMUser_"^"_PatName_"^"_PatSex_"^"_PatAge
	s RetValue=RetValue_"^"_PatientID_"^"_PatBldGroup_"^"_Location_"^"_SampleNo_"^"_IsTrans_"^"_IsReaction_"^"_IsRetrieve_"^"_AdmID_"^"_Ward_"^"_BedNo
	q RetValue
}

/// ^DHCBBIssueRecord(0,"DEBTORNO","0002211782",20141225006,"=0160214041135","=<P0065V00 1") = "" 
/// ^DHCBBIssueRecord(0,"DEBTORNO","0002211782",20141225006,"=0160214067491","=<P0065V00 1") = "" 
///   W ##Class(web.DHCBldReceivePack).GetIssueRecord("0002211782","20141225006")
ClassMethod GetIssueRecord(RegNo As %String, IssNo As %String) As %String
{
	S RegNo=$G(RegNo),IssNo=$G(IssNo)
	Q:'$L(RegNo) ""
	Q:'$L(IssNo) ""
	S labdata=##Class(LIS.Core.Util).GetLabDataNS()
    S index=0,records=""
    Q:'$D(^|labdata|DHCBBIssueRecord(IssNo)) ""
	S donorID="" F  S donorID=$O(^|labdata|DHCBBIssueRecord(IssNo,donorID)) Q:'$L(donorID)  D
	.S packSubID="" F  S packSubID=$O(^|labdata|DHCBBIssueRecord(IssNo,donorID,packSubID)) Q:'$L(packSubID)  D
	..Q:'$D(^TBBP(donorID,packSubID))
	..;W donorID,packSubID,!
	..S record=$$GetPackData(donorID,packSubID)
	..S:$L(record) records=records_record_$C(2)
  	S:$L(records) records=$E(records,1,$L(records)-1)
	Q records
  	
GetPackData(donorID,packSubID)
	S donorID=$G(donorID),packSubID=$G(packSubID)
	Q:'$L(donorID) ""
	Q:'$L(packSubID) ""
	S (RowID,DonorID,ProductID,ProductDesc,BloodGroupID,BloodGroup,Volume,Unit,ProductGroupID,ProductGroup,StoreStatus,TransStatus,TransDesc,ExpireDateTime,IssueDateTime,IssueUser,XMMajor,XMMinor,XMResult,XMDateTime,XMUser,PatName,PatSex,PatAge,PatientID,PatBldGroup,Location,LabRowID,IsTrans,IsReaction,IsRetrieve,admID,ward,bed)=""
	S labdata=##Class(LIS.Core.Util).GetLabDataNS()
	S data=$G(^|labdata|TBBP(donorID,packSubID))
	Q:'$L(data) ""
	S stockStatusID=$P(data,"\",3)
	S transStatusID=$P(data,"\",2)
	S BldProductID=$P(data,"\",4)
	S BloodGroupID=$P(data,"\",5)
	S supplierID=$P(data,"\",12)
	S Supplier=""
	S:$L(supplierID) Supplier=$P($G(^|labdata|TTAB("BB-SUP",supplierID)),"\",1)
	S extendData=$G(^|labdata|Dhcbbpackprice(donorID,packSubID))
	S DonorName=$P(extendData,"\",2)   		//献血者
	S IsFilterWBC=$P(extendData,"\",3)  	//是否滤白
	S IsTest=$P(extendData,"\",4)			//是否化验
	S IsIrradiance=$P(extendData,"\",10)	//是否辐照
	S RowID=donorID_"||"_packSubID
	S DonorID=donorID
	S ProductID=$P(packSubID," ",1)
	S ProductDesc=""
	S:$L(BldProductID) ProductDesc=$P($G(^|labdata|TTAB("BB-BP",BldProductID)),"\",1)
	S ProductGroupID=""
	S:$L(BldProductID) ProductGroupID=$P($G(^|labdata|TTAB("BB-BP",BldProductID)),"\",21)
	S ProductGroup=""
	S:$L(ProductGroupID) ProductGroup=$P($G(^|labdata|TTAB("BB-PG",ProductGroupID)),"\",1)
	
	S BloodGroup=""
	S:$L(BloodGroupID) BloodGroup=$P($G(^|labdata|TTAB("BB-BG",BloodGroupID)),"\",1)
	S Volume=$P(data,"\",21)
	S Unit=""
	S:$L(BldProductID) Unit=$P($G(^|labdata|TTAB("BB-BP",BldProductID,"REM",1)),"&",1)
	S StoreStatus=$S(stockStatusID="IN-1":"库存",stockStatusID="IN-0":"库存(不可用)",stockStatusID="OUT":"出库",1:"")
	S TransStatus=""
	S TransDesc=""
	S:$L(transStatusID) TransStatus=$P($G(^|labdata|TTAB("BB-ST",transStatusID)),"\",1)
	S ExpireDate=##Class(LIS.Core.Util).CvtClientDate($P(data,"\",7),"")
	S ExpireTime=##Class(LIS.Core.Util).CvtClientTime($P(data,"\",34),"")
	S ExpireDateTime=ExpireDate_" "_ExpireTime
	
    S (IssueDateTime,IssueUser,XMMajor,XMMinor,XMResult,XMDateTime,XMUser,Location)=""
    S (PatName,PatSex,PatAge,PatientID,PatBldGroup,IsTrans,IsReaction,IsRetrieve)=""
    S lastTransIndex=$O(^|labdata|TBBP(donorID,packSubID,"TRAN",""),-1)
    S labno="",tsCode="",tsCnt=""
   	
    I $L(lastTransIndex) {
		S lastTransData=$G(^|labdata|TBBP(donorID,packSubID,"TRAN",lastTransIndex))
		S lastTransID=$P(lastTransData,"\",1)
		S:$L(lastTransID) TransDesc=$P($G(^|labdata|TTAB("BB-TR",lastTransID)),"\",1)
		S LabRowID=$P(lastTransData,"\",7)
		S labno=$P(LabRowID,"||",1) 
		S tsCode=$P(LabRowID,"||",2)  
		S tsCnt=$P(LabRowID,"||",3)   
	}
	S issueRecordID=""
	I '$L(labno) {
		S LabRowID=$O(^|labdata|DHCBBIssueRecord(0,"PACKID",donorID,packSubID,""))
		S labno=$P(LabRowID,"||",1) 
		S tsCode=$P(LabRowID,"||",2)  
		S tsCnt=$P(LabRowID,"||",3) 
		S:$L(LabRowID) issueRecordID=$O(^|labdata|DHCBBIssueRecord(0,"PACKID",donorID,packSubID,LabRowID,""))	
	}
    S admID=##Class(LIS.LAB.Patient).GetAdmIDByLabno(labno)
    S ward=##Class(LIS.Core.Patient).GetWard(admID)
    S bed=##Class(LIS.Core.Patient).GetBed(admID)
    I $L(labno),$L(tsCode),$L(tsCnt) {
	    S labData=$G(^|labdata|TEPI(labno))
	    S gName=$P(labData,"\",1)
	    S sName=$P(labData,"\",2)
        S PatName=gName_" "_sName
        S:gName=sName PatName=gName
        S sexID=$P(labData,"\",3)
  		S:$L(sexID) PatSex=$P($G(^|labdata|TTAB("SP",sexID)),"\",1)
        S DOB=$P(labData,"\",4)
   	    S PatAge=##Class(LIS.Core.Util).GetAge(DOB)
        S PatientID=$P(labData,"\",18)
        S PatBldGroupID=""
        S:$L(PatientID) PatBldGroupID=$P($G(^|labdata|TDEB(PatientID)),"\",4)
        S:$L(PatientID)&&('$L(PatBldGroupID)) PatBldGroupID=$P($G(^|labdata|TDEB(PatientID)),"\",10) 
        S:$L(PatBldGroupID) PatBldGroup=$P($G(^|labdata|TTAB("BB-BG",PatBldGroupID)),"\",1)
 		S LocationID=$P(labData,"\",36)
 		S:$L(LocationID) Location=$P($G(^|labdata|TTAB("USLOC",LocationID)),"\",1)
 		S:Location["-" Location=$P(Location,"-",2)
	    S xmrData=$G(^|labdata|TEPI(labno,1,tsCode,tsCnt,"BBP",donorID,packSubID))
	    S XMMajorID=$P($P(xmrData,"\",4),",",1)
        S XMMinorID=$P($P(xmrData,"\",4),",",2)
        S XMResultID=$P(xmrData,"\",1)
		I XMMajorID=0 {
			S XMMajor="相合"	
		} ELSEIF XMMajorID="" {
			S XMMajor=""
		} ELSEIF XMMajorID["||" {
			S XMMajor=XMMajorID
			S XMMajorMainID=$P(XMMajorID,"||",1)
			S XMMajorSubID=$P(XMMajorID,"||",2)
			I $L(XMMajorMainID),$L(XMMajorSubID),$D(^|labdata|TTABDHCC("XMR",XMMajorMainID,XMMajorSubID)) {
				S XMMajor=$P($G(^|labdata|TTABDHCC("XMR",XMMajorMainID,XMMajorSubID)),"\",1)
			}
		} ELSEIF XMMajorID?1.N {
			S XMMajor="不相合"	
		} ELSE {
			S XMMajor = XMMajorID
		} 
	    
	    I XMMinorID=0 {
			S XMMinor="相合"	
		} ELSEIF XMMinorID="" {
			S XMMinor=""
		} ELSEIF XMMinorID["||" {
			S XMMinor=XMMinorID
			S XMMinorMainID=$P(XMMinorID,"||",1)
			S XMMinorSubID=$P(XMMinorID,"||",2)
			I $L(XMMinorMainID),$L(XMMinorSubID),$D(^|labdata|TTABDHCC("XMR",XMMinorMainID,XMMinorSubID)) {
				S XMMinor=$P($G(^|labdata|TTABDHCC("XMR",XMMinorMainID,XMMinorSubID)),"\",1)
			}
		} ELSEIF XMMinorID?1.N {
			S XMMinor="不相合"	
		} ELSE {
			S XMMinor = XMMinorID
		}
		
		I XMResultID="C" {
			S XMResult="相合"
		} ELSEIF XMResultID="A" {
			S XMResult="可接受"
		} ELSEIF XMResultID="I" {
			S XMResult="不相合"
		} ELSE {
			S XMResult=XMResultID
		}
		
		S xmData=$G(^|labdata|DHCVisitTSBBPacksInfo(labno,1,tsCode,tsCnt,"BBP",donorID,packSubID))
		S IssueUserID=$P(xmData,"\",1)
		S:$L(IssueUserID) IssueUser=$P($G(^|labdata|SSU("SSUSR",1,IssueUserID)),"^",2)
		S IssueDate=##Class(LIS.Core.Util).CvtClientDate($P(xmData,"\",2),"")
		S IssueTime=##Class(LIS.Core.Util).CvtClientTime($P(xmData,"\",3),"")
    	S IssueDateTime=IssueDate_" "_IssueTime
    	S XMUserID=$P(xmData,"\",4)
    	S:$L(XMUserID) XMUser=$P($G(^|labdata|SSU("SSUSR",1,XMUserID)),"^",2)
    	S XMDate=##Class(LIS.Core.Util).CvtClientDate($P(xmData,"\",5),"")
    	S XMTime=##Class(LIS.Core.Util).CvtClientTime($P(xmData,"\",6),"")
    	S XMDateTime=XMDate_" "_XMTime
	}
	
	I $L(issueRecordID) {
		S issueData=$G(^DHCBBIssueRecord(issueRecordID,donorID,packSubID))
		I $L(issueData) {
			S XMMajor=$P(issueData,"\",9)
			S XMMinor=$P(issueData,"\",11)
			S XMResult=$P(issueData,"\",13)
			S XMUser=##Class(LIS.LAB.Util).GetUser($P(issueData,"\",14))
			S XMDate=##Class(LIS.Core.Util).CvtClientDate($P(issueData,"\",15))
			S XMTime=##Class(LIS.Core.Util).CvtClientTime($P(issueData,"\",16))
			S XMDateTime=XMDate_" "_XMTime
			S IssueDate=##Class(LIS.Core.Util).CvtClientDate($P(issueData,"\",3))
			S IssueTime=##Class(LIS.Core.Util).CvtClientTime($P(issueData,"\",4))
			S IssueDateTime=IssueDate_" "_IssueTime
			S IssueUser=##Class(LIS.LAB.Util).GetUser($P(issueData,"\",2))
		}		
	}
	
    S record="",index=0,deli="^"
    S index=index+1,$P(record,deli,index)=RowID
    S index=index+1,$P(record,deli,index)=DonorID
    S index=index+1,$P(record,deli,index)=ProductID
    S index=index+1,$P(record,deli,index)=ProductDesc
    S index=index+1,$P(record,deli,index)=BloodGroupID
    S index=index+1,$P(record,deli,index)=BloodGroup
    S index=index+1,$P(record,deli,index)=Volume
    S index=index+1,$P(record,deli,index)=Unit
    S index=index+1,$P(record,deli,index)=ProductGroupID
    S index=index+1,$P(record,deli,index)=ProductGroup
    S index=index+1,$P(record,deli,index)=StoreStatus
    S index=index+1,$P(record,deli,index)=TransStatus
    S index=index+1,$P(record,deli,index)=TransDesc
    S index=index+1,$P(record,deli,index)=ExpireDateTime
    S index=index+1,$P(record,deli,index)=IssueDateTime
    S index=index+1,$P(record,deli,index)=IssueUser
    S index=index+1,$P(record,deli,index)=XMMajor
    S index=index+1,$P(record,deli,index)=XMMinor
    S index=index+1,$P(record,deli,index)=XMResult
    S index=index+1,$P(record,deli,index)=XMDateTime
    S index=index+1,$P(record,deli,index)=XMUser
    S index=index+1,$P(record,deli,index)=PatName
    S index=index+1,$P(record,deli,index)=PatSex
    S index=index+1,$P(record,deli,index)=PatAge
    S index=index+1,$P(record,deli,index)=PatientID
    S index=index+1,$P(record,deli,index)=PatBldGroup
    S index=index+1,$P(record,deli,index)=Location
    S index=index+1,$P(record,deli,index)=LabRowID
    S index=index+1,$P(record,deli,index)=IsTrans
    S index=index+1,$P(record,deli,index)=IsReaction
    S index=index+1,$P(record,deli,index)=IsRetrieve
    S index=index+1,$P(record,deli,index)=admID
    S index=index+1,$P(record,deli,index)=ward
    S index=index+1,$P(record,deli,index)=bed
   
	Q record
}

///  w ##Class(web.DHCBldReceivePack).GetPackDateTime("=0160213010298||=<P0173V00 1")
ClassMethod GetPackDateTime(PackRowID) As %String
{
	S ^TMPPACK($ZN,$J,PackRowID)="" 
	S PackID=$p(PackRowID,"||",1), PackSub=$p(PackRowID,"||",2)
	S ProcductDR=$p(^TBBP(PackID,PackSub),"\",4)
	S bldproductno=$P(^TTAB("BB-BP",ProcductDR),"\",7) ;????????????
	S bldproductno=$P(PackSub," ")
	I '$l(bldproductno) Q ""
	S bldbagno=$e(PackID,1,$l(PackID))
	;s rw=$O(^Nur.BloodBagReciveI("Blood"," "_bldbagno," "_bldproductno,""))
	S rw=$O(^Nur.BloodBagReciveI("BloodPref"," "_PackRowID,""))
	I '$l(rw) q ""
	s a=##class(Nur.BloodBagRecive).%OpenId(rw)
	s recdate=a.ReciveDate
	s rectime=a.ReciveTime
	s stdate=a.TransStartDate
	s sttime=a.TransStartTime
	s eddate=a.TransEdDate
	s edutime=a.TransEdTime
	S RecUsr=a.ReciveUser 
	s TransFirstCheckUsr=a.TransFirstUser
	S TransSecondCheckUsr=a.TransSecondUser
	S EpisNum=a.EpisodeId
	s papmiId=+^PAADM(EpisNum)
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    Q recdate_"^"_rectime_"^"_stdate_"^"_sttime_"^"_eddate_"^"_edutime_"^"_RecUsr_"^"_TransFirstCheckUsr_"^"_TransSecondCheckUsr_"^"_regNo
}

}
