/// 门诊检查服务
Class DtPortal.OD.OD16InspectService Extends %RegisteredObject
{

/// 名称:DtPortal.OD.OD16InspectService
/// CreatDate： 2021-03-02
/// Description: 预约完成率
/// Input：          
/// Return： 
/// 服务代码 OD16.01.01
/// d ##class(%ResultSet).RunQuery("DtPortal.OD.OD16InspectService","OD160101","O","")
Query OD160101(patType As %String = "", hospitalId As %String = "") As DtPortal.Query(ROWSPEC = "typeDesc,dueNum,finishNum")
{
}

ClassMethod OD160101Execute(ByRef qHandle As %Binary, patType As %String = "", hospitalId As %String = "") As %Status
{
	//New (qHandle,userCode)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	s hospitalCode=""
	set arcimIDs="4863||1^101||2"   //##Class(DtPortal.Configure.arcim).getArcImID(OrderCode,1)  //医嘱ID串
	s dueNum=0,finishNum=0
	s typeDesc="CT"
	s stDate=+$h-7
	s eDate=+$h
	s type="CT"
	k ^||tempOD160101(type)
	d ##class(DtPortal.OD.OD16InspectService).findArcimByOrderSub(type,"CT")
	s info=..getDueInfo(type,patType,hospitalId,stDate,eDate,arcimIDs)
	s dueNum=$p(info,"^",1)
	s finishNum=$p(info,"^",2)
	
	d OD020201
	q $$$OK
	

  
OD020201
    s Data=$lb(typeDesc,dueNum,finishNum)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

// 

ClassMethod getDueInfo(type As %String = "", patType As %String = "", hospitalId As %String = "", stDate As %String = "", eDate As %String = "", arcimIDs As %String = "")
{
	s dueNum=0,finishNum=0
	set rowid=""
	for 
	{
		set rowid=$o(^||tempOD160101(18,rowid))
		//set rowid=$p(arcimIDs,"^",index)
		
		quit:rowid=""
		w !,rowid

		for ordDate=stDate:1:eDate
		{
			
			//for index=1:1:$l(arcimIDs,"^")
		
			set ordID=""
			for
			{
				set ordID=$o(^OEORDi(0,"DateARCIM",ordDate,rowid,ordID))
				quit:ordID=""
				//b ;01
				set Paadm=$p(^OEORD(+ordID),"^",1)
				//Continue:(patType'="")&&$p($g(^PAADM(+Paadm)),"^",2)'=patType   //就诊类型过滤
				//Continue:$p($g(^PAADM(+Paadm)),"^",20)'="A"   //就诊状态过滤
				set LocID=$p(^PAADM(Paadm),"^",4)
				set wardID=$p(^PAADM(Paadm),"^",70)
				continue:wardID="" 
				set OrdSub=""
				for
				{
					set OrdSub=$o(^OEORDi(0,"DateARCIM",ordDate,rowid,ordID,OrdSub))
					quit:OrdSub=""
					
					
					set OreSub=""
					for
					{
						set OreSub=$o(^OEORDi(0,"DateARCIM",ordDate,rowid,ordID,OrdSub,OreSub))
						quit:OreSub=""
					
						set ordStatusId=$p($g(^OEORD(ordID,"I",OrdSub,"X",OreSub,"BILL")),"^",1)  
	 					set ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
	 					continue:(ordStat'="V")&(ordStat'="E") 
					    
					    s ifBK=0,ifFinish=0  //预约、完成
					    set ESExamID=""
					    for{
						   s ESExamID=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemIDExamID"," "_ordID_"||"_OrdSub,ESExamID))
						   q:ESExamID=""
						   s EsStatusDr=""
						   //b ;02
						   for {
							   //b ;01
							  s EsStatusDr=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemIDExamID"," "_ordID_"||"_OrdSub,ESExamID,EsStatusDr),-1)
							  q:EsStatusDr=""
			
							  set StatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),11)
							  set PreStatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),12)
							  w !,StatusCode
							  if (StatusCode="BK") {	//获取预约日期
							   	  s ifBK=1
								  s OperateDate=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),7)
								  q:OperateDate'=+$h	//非当天预约退出
							  }elseif((StatusCode="RP")||(StatusCode="CM")||(StatusCode="PRP")){
								  s ifFinish=1
								  q:ifFinish=1
							  }
							  
							  
							  
							  /*
							  if (StatusCode="SC")&&(PreStatusCode="AP") {
								  s OperateDate=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),7)
								  s OperateID=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),5)
								  s OperateName=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),6)
								  s ExamPartID=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),13)
								  s ExamPart=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),4)
							  }
							  
							  if (StatusCode="DIAG")&&(PreStatusCode="SC") {
								s CheckDate=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),7)
								s CheckDocCode=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),5)
								s CheckDocDesc=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),6)
							  }
							  */
								
							  
						   }
						   
						   if (ifBK=1){
							  s dueNum=dueNum+1
							  if (ifFinish=1){
						      	s finishNum=finishNum+1
						      }
							  
							
						   }
						   
						}
					}
				}
			
			}
		}
	
	}
	q dueNum_"^"_finishNum
}

// 根据医嘱子类查询医嘱

// d ##class(DtPortal.OD.OD16InspectService).findArcimByOrderSub(18,"CT")

ClassMethod findArcimByOrderSub(subId = "", type = "")
{
	
	S ARCIMSubscript=0
	for
	{
		s ARCIMSubscript=$o(^ARCIM(0,"ARCIC_DR",subId,ARCIMSubscript))  q:ARCIMSubscript=""
		s ARCIMVersion=0
		for 
		{
			s ARCIMVersion=$o(^ARCIM(0,"ARCIC_DR",subId,ARCIMSubscript,ARCIMVersion))  q:ARCIMVersion=""
			s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
			s ^||tempOD160101(type,ARCIMRowId)=""
		}
	}
	//b ;001
}

}
