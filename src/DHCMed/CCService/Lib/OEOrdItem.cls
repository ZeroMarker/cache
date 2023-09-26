/// 名称: DHCMed.CCService.Lib.OEOrdItem
/// 描述: 与医嘱项相关的函数库
/// 编写者：zhufei
/// 编写日期: 2011-03-18
Class DHCMed.CCService.Lib.OEOrdItem Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Lib.OEOrdItem).Test()
ClassMethod Test()
{
	New
	
	Set %AutoRunFlag=1
	Set %CurrentDate=$zdh("2012-09-15",3)
	Set %FromDate=$zdh("2012-09-15",3)
	Set %ToDate=$zdh("2012-09-15",3)
	
	Set %EpisodeID=3341438
	Set %ExtraData=$lb("")
	Set %ErrorData=$lb("")
	Set return=..GetNumByID("医嘱||16680||导尿管[三腔][三腔(16F18F20F22F24F")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	/*
	Set %EpisodeID=242
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..GetItemCountByPhsCat("抗生素")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Set %EpisodeID=3029690
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..GetPhsBySubCat("抗感染药物","","")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Set %EpisodeID=5583036
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..GetAntiByFlag()
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Set %EpisodeID=5583036
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..GetAntiByPoison("抗生素一级|抗生素二级")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	*/
	Quit "Over"
}

/// Modified By LiYang 2012-03-04 增加一个参数，是否统计所有医嘱
/// Creator：     zhufei
/// CreatDate：   2011-03-18
/// Description:  通过ID取医嘱数量
/// Table：       MR_Diagnos,MRC_Icddx
/// Input：       Input: "医嘱||860||QMSPSJ-青霉素皮试剂2500iu"
///               All:Y:包括所有医嘱项目，包括已经停止的，  N：活动医嘱 
/// Return：      返回临床诊断数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.OEOrdItem).GetNumByID("")
ClassMethod GetNumByID(argInput As %String, All As %String) As %String
{
	New (argInput,All,%EpisodeID,%ExtraData,%ErrorData,%FromDate,%ToDate)
	Set return=0,Count=0
	Quit:argInput="" return
	
	Set $ZT="GetNumByIDErr"
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set All=$g(All)   //增加一个参数，是否统计所有医嘱
	
	Set ArcimID=$p(argInput,"||",2)
	Quit:ArcimID="" return
	Set ArcimID=ArcimID_"||1"
	Set ArcimName=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)
	Set OrderID=0
	For {
		Set OrderID=$o(^OEORD(0,"Adm",%EpisodeID,OrderID))
		Quit:OrderID=""
		Set SttDate=0
		For {
			Set SttDate=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate))
			Quit:SttDate=""
			Continue:(%FromDate'="")&&(SttDate<%FromDate)  //add by zf 增加时间段判断
			Continue:(%ToDate'="")&&(SttDate>%ToDate)      //add by zf 增加时间段判断
			
			Set SubID=0
			For {
				Set SubID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate,SubID))
				Quit:SubID=""
				
				Continue:(..IsValidOEItem(OrderID_"||"_SubID,All)=0)
				
				Set Count=Count+1
				Set StartDate=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",9)  //医嘱开始日期
				Set StartTime=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",10) //医嘱开始时间
				Set Doctor=$p($g(^OEORD(+OrderID,"I",SubID,1)),"^",11)   //开医嘱医生
				Set:StartDate'="" StartDate=$zd(StartDate,3)
				Set:StartTime'="" StartTime=$zt(StartTime,2)
				Set Doctor=$p($g(^CTPCP(+Doctor,1)),"^",2)
				
				//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
				Set Record=""
				Set $p(Record,$c(3),1)=ArcimName  //_" "_StartDate_" "_StartTime_" "_Doctor
				Set $p(Record,$c(3),2)=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",9)
				Set $p(Record,$c(3),3)=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",10)
				Set $p(Record,$c(3),4)=ArcimName_" "_StartDate_" "_StartTime_" "_Doctor
				Set $p(Record,$c(3),5)=OrderID_"||"_SubID
				Set $p(Record,$c(3),6)=+$p($g(^OEORD(+OrderID,"I",SubID,8)),"^",12)
				Set $p(Record,$c(3),7)="argInput"_argInput
				Set %ExtraData=%ExtraData_$lb(Record)
			}
		}
	}
	
	Set return=Count
	Quit return
	
GetNumByIDErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2011-03-18
/// Description:  通过ID取医嘱数量
/// Table：       MR_Diagnos,MRC_Icddx
/// Input：       Input: "医嘱||860||QMSPSJ-青霉素皮试剂2500iu"
/// Return：      返回临床诊断数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.OEOrdItem).GetNumByID1("")
ClassMethod GetNumByID1(argInput As %String) As %String
{
	New (argInput,%EpisodeID,%ExtraData,%ErrorData,%FromDate,%ToDate)
	Set return=0,Count=0
	Quit:argInput="" return
	
	Set $ZT="GetNumByIDErrs"
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	
	Set ArcimID=$p(argInput,"||",2)
	Quit:ArcimID="" return
	Set ArcimID=ArcimID_"||1"
	Set ArcimName=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)
	Set OrderID=0
	For {
		Set OrderID=$o(^OEORD(0,"Adm",%EpisodeID,OrderID))
		Quit:OrderID=""
		Set SttDate=0
		For {
			Set SttDate=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate))
			Quit:SttDate=""
			Continue:(%FromDate'="")&&(SttDate<%FromDate)  //add by zf 增加时间段判断
			Continue:(%ToDate'="")&&(SttDate>%ToDate)      //add by zf 增加时间段判断
			
			Set SubID=0
			For {
				Set SubID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate,SubID))
				Quit:SubID=""
				
				Continue:(..IsValidOEItem(OrderID_"||"_SubID)=0)
				
				Set StatusID=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",13)
				Set StatusDesc=$p($g(^OEC("OSTAT",+StatusID)),2)
				Set Count=Count+1
				Set StartDate=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",9)  //医嘱开始日期
				Set StartTime=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",10) //医嘱开始时间
				Set Doctor=$p($g(^OEORD(+OrderID,"I",SubID,1)),"^",11)   //开医嘱医生
				Set:StartDate'="" StartDate=$zd(StartDate,3)
				Set:StartTime'="" StartTime=$zt(StartTime,2)
				Set Doctor=$p($g(^CTPCP(+Doctor,1)),"^",2)
				
				//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
				Set Record=""
				Set $p(Record,$c(3),1)=ArcimName  //_" "_StartDate_" "_StartTime_" "_Doctor
				Set $p(Record,$c(3),2)=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",9)
				Set $p(Record,$c(3),3)=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",10)
				Set $p(Record,$c(3),4)=ArcimName_" "_StartDate_" "_StartTime_" "_Doctor
				Set $p(Record,$c(3),5)=OrderID_"||"_SubID
				Set $p(Record,$c(3),6)=+$p($g(^OEORD(+OrderID,"I",SubID,8)),"^",12)
				Set $p(Record,$c(3),7)="argInput"_argInput
				Set %ExtraData=%ExtraData_$lb(Record)
			}
		}
	}
	
	Set return=Count
	Quit return
	
GetNumByIDErrs
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2011-03-27
/// Description:  通过药理学分类名称取患者使用抗生素种类
/// Table：       OE_OrdItem
///               PHC_SubCat药理学子分类
///               PHC_Cat药理学分类
/// Input：       Input: "药理学分类名称"
/// Return：      返回临床诊断数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.OEOrdItem).GetPhsByCat("抗生素")
ClassMethod GetPhsByCat(argCatName As %String, argDateFrom As %String = "", argDateTo As %String = "") As %String
{
	New (argCatName,argDateFrom,argDateTo,%EpisodeID,%ExtraData,%ErrorData,%FromDate,%ToDate) //Modified  By LiYang 2012-11-21 取消%CurrentDate
	Set return=0,Count=0
	Quit:argCatName="" return
	
	Set $ZT="GetPhsByCatErr"
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	
	Set OrderID=0
	For {
		Set OrderID=$o(^OEORD(0,"Adm",%EpisodeID,OrderID))
		Quit:OrderID=""
		Set ArcimID=""
		For {
			Set ArcimID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID))
			Quit:ArcimID=""
			Set CategInfo=..GetPhcCat(ArcimID)
			Set CategName=$p(CategInfo,"/",3)    //2->3 by wuqk 2011-09-06
			//w !,CategInfo
			Continue:argCatName'=CategName
			Set ArcimName=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)
			Set SttDate=0,flg=0
			For {
				Set SttDate=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate))
				Quit:SttDate=""
				Continue:(argDateFrom'="")&&(SttDate<argDateFrom)
				Continue:(argDateTo'="")&&(SttDate>argDateTo)
				Continue:(%FromDate'="")&&(SttDate<%FromDate)  //add by zf 增加时间段判断
				Continue:(%ToDate'="")&&(SttDate>%ToDate)      //add by zf 增加时间段判断
				
				Set SubID=0
				For {
					Set SubID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate,SubID))
					Quit:SubID=""
					
					Continue:(..IsValidOEItem(OrderID_"||"_SubID)=0)
					
					Set flg=1
					Set StartDate=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",9)  //医嘱开始日期
					Set StartTime=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",10) //医嘱开始时间
					Set Doctor=$p($g(^OEORD(+OrderID,"I",SubID,1)),"^",11)   //开医嘱医生
					Set:StartDate'="" StartDate=$zd(StartDate,3)
					Set:StartTime'="" StartTime=$zt(StartTime,2)
					Set Doctor=$p($g(^CTPCP(+Doctor,1)),"^",2)
					
					//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
					Set Record=""
					Set $p(Record,$c(3),1)=ArcimName  //_" "_StartDate_" "_StartTime_" "_Doctor
					Set $p(Record,$c(3),2)=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",9)
					Set $p(Record,$c(3),3)=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",10)
					Set $p(Record,$c(3),4)=ArcimName
					Set $p(Record,$c(3),5)=OrderID_"||"_SubID
					Set $p(Record,$c(3),6)=+$p($g(^OEORD(+OrderID,"I",SubID,8)),"^",12)
					Set $p(Record,$c(3),7)="argCatName"_argCatName
					Set %ExtraData=%ExtraData_$lb(Record)
				}
			}
			Set:flg=1 Count=Count+1
		}
	}
	
	Set return=Count
	Quit return
	
GetPhsByCatErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2011-03-27
/// Description:  通过药理学分类名称取患者使用抗生素种类
/// Table：       OE_OrdItem
///               PHC_SubCat药理学子分类
///               PHC_Cat药理学分类
/// Input：       Input: "药理学子分类名称"
/// Return：      返回临床诊断数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.OEOrdItem).GetPhsBySubCat("抗生素")
ClassMethod GetPhsBySubCat(argSubCatName As %String, argDateFrom As %String, argDateTo As %String) As %String
{
	New (argSubCatName,argDateFrom,argDateTo,%EpisodeID,%ExtraData,%ErrorData,%FromDate,%ToDate)
	Set return=0,Count=0
	Quit:argSubCatName="" return
	
	Set $ZT="GetPhsBySubCatErr"
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	
	Set OrderID=0
	For {
		Set OrderID=$o(^OEORD(0,"Adm",%EpisodeID,OrderID))
		Quit:OrderID=""
		Set ArcimID=""
		For {
			Set ArcimID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID))
			Quit:ArcimID=""
			Set SubCatInfo=..GetPhcSubCat(ArcimID)
			Set SubCatName=$p(SubCatInfo,"/",3)    //2->3 by wuqk 2011-09-06
			Continue:argSubCatName'=SubCatName
			Set ArcimName=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)
			Set SttDate=0,flg=0
			For {
				Set SttDate=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate))
				Quit:SttDate=""
				Continue:(argDateFrom'="")&&(SttDate<argDateFrom)
				Continue:(argDateTo'="")&&(SttDate>argDateTo)
				Continue:(%FromDate'="")&&(SttDate<%FromDate)  //add by zf 增加时间段判断
				Continue:(%ToDate'="")&&(SttDate>%ToDate)      //add by zf 增加时间段判断
				
				Set SubID=0
				For {
					Set SubID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate,SubID))
					Quit:SubID=""
					
					Continue:(..IsValidOEItem(OrderID_"||"_SubID)=0)
					
					Set flg=1
					Set StartDate=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",9)  //医嘱开始日期
					Set StartTime=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",10) //医嘱开始时间
					Set Doctor=$p($g(^OEORD(+OrderID,"I",SubID,1)),"^",11)   //开医嘱医生
					Set:StartDate'="" StartDate=$zd(StartDate,3)
					Set:StartTime'="" StartTime=$zt(StartTime,2)
					Set Doctor=$p($g(^CTPCP(+Doctor,1)),"^",2)
					
					//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
					Set Record=""
					Set $p(Record,$c(3),1)=ArcimName  //_" "_StartDate_" "_StartTime_" "_Doctor
					Set $p(Record,$c(3),2)=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",9)
					Set $p(Record,$c(3),3)=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",10)
					Set $p(Record,$c(3),4)=ArcimName
					Set $p(Record,$c(3),5)=OrderID_"||"_SubID
					Set $p(Record,$c(3),6)=+$p($g(^OEORD(+OrderID,"I",SubID,8)),"^",12)
					Set $p(Record,$c(3),7)="argSubCatName"_argSubCatName
					Set %ExtraData=%ExtraData_$lb(Record)
				}
			}
			Set:flg=1 Count=Count+1
		}
	}
	
	Set return=Count
	Quit return
	
GetPhsBySubCatErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Add By LiYang 2012-03-01
/// 功能：统计某个医嘱子类数量
/// 参数：ItemCateName:医嘱子类名称（关键子即可）
/// 返回值：该子类医嘱数量
/// %ExtraData 中存储的是医嘱明细信息
ClassMethod GetItemCountByItemCat(ItemCateName)
{
	New (ItemCateName,%EpisodeID,%ExtraData,%ErrorData,%FromDate,%ToDate)
	Set return=0,Count=0
	
	Set $ZT="GetItemCountByItemCatErr"
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	
	Set OrderID=0
	For {
		Set OrderID=$o(^OEORD(0,"Adm",%EpisodeID,OrderID))
		Quit:OrderID=""
		Set ArcimID=""
		For {
			Set ArcimID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID))
			Quit:ArcimID=""
			Set objArcim=##class(DHCMed.Base.Arcim).GetObjById(ArcimID)
			Continue:objArcim.ARCICDesc'[ItemCateName
			Set SttDate=0,flg=0
			For {
				Set SttDate=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate))
				Quit:SttDate=""
				Continue:(%FromDate'="")&&(SttDate<%FromDate)  //add by zf 增加时间段判断
				Continue:(%ToDate'="")&&(SttDate>%ToDate)      //add by zf 增加时间段判断
				
				Set SubID=0
				For {
					Set SubID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate,SubID))
					Quit:SubID=""
					
					Continue:(..IsValidOEItem(OrderID_"||"_SubID)=0)
					
					Set OrderItemID=OrderID_"||"_SubID
					Set objItm=##class(DHCMed.Base.OrdItem).GetObjById(OrderItemID)
					Do objItm.%Close()
					
					Set Count=Count+1
					
					//add by lyh 2013-04-25 增加送检标本
					Set SpecCode="",SpecimenDesc=""
					/* update by zf 修改检验医嘱标本取值方法
					Set SpecDr=$o(^OEORD(OrderID,"I",SubID,"SPEC",""),-1)
					Set:SpecDr'="" SpecCode=$p(^OEORD(OrderID,"I",SubID,"SPEC",SpecDr),"^",1)
					Set:SpecCode'="" SpecimenDesc=$p(^TTAB("SPEC",SpecCode),"\",1)
					*/
					Set tSpecimenInfo=##class(DHCMed.SSIO.FromHisSrv).GetOrdSpecimen(OrderID_"||"_SubID)
					Set SpecDr=$p(tSpecimenInfo,"^",1)
					Set SpecCode=$p(tSpecimenInfo,"^",2)
					Set SpecimenDesc=$p(tSpecimenInfo,"^",3)
					
					//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
					Set Record=""
					Set $p(Record,$c(3),1)=objArcim.ARCIMDesc_"("_SpecimenDesc_")"  //_" "_$zd(objItm.OEORIDate,3)_" "_objItm.OEORIDoseQty_objItm.CTUOMDesc_" "_objItm.OSTATDesc
					Set $p(Record,$c(3),2)=objItm.OEORISttDat
					Set $p(Record,$c(3),3)=objItm.OEORISttTim
					Set $p(Record,$c(3),4)=objItm.ARCIMDesc
					Set $p(Record,$c(3),5)=OrderID_"||"_SubID
					Set $p(Record,$c(3),6)=objItm.OEORIDoctorDR
					Set $p(Record,$c(3),7)="ItemCateName"_ItemCateName
					Set %ExtraData=%ExtraData_$lb(Record)
				}
			}
		}
	}
	
	Set return=Count
	Quit return
	
GetItemCountByItemCatErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Add By LiYang 2012-03-01
/// 功能：统计某个药学类医嘱数量
/// 参数：PhsCatName:医嘱药学分类名称（关键子即可）
/// 返回值：该子类医嘱数量
/// %ExtraData 中存储的是医嘱明细信息
ClassMethod GetItemCountByPhsCat(PhsCatName)
{
	New (PhsCatName,%EpisodeID,%ExtraData,%ErrorData,%FromDate,%ToDate)
	Set return=0,Count=0
	
	Set $ZT="GetItemCountByPhsCatErr"
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	
	Set OrderID=0
	For {
		Set OrderID=$o(^OEORD(0,"Adm",%EpisodeID,OrderID))
		Quit:OrderID=""
		Set ArcimID=""
		For {
			Set ArcimID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID))
			Quit:ArcimID=""
			Set CategInfo=..GetPhcCat(ArcimID)
			Set CategName=$p(CategInfo,"/",3)    //2->3 by wuqk 2011-09-06
			Continue:CategName'[PhsCatName		
			Set objArcim=##class(DHCMed.Base.Arcim).GetObjById(ArcimID)
			Set SttDate=0,flg=0
			For {
				Set SttDate=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate))
				Quit:SttDate=""
				Continue:(%FromDate'="")&&(SttDate<%FromDate)  //add by zf 增加时间段判断
				Continue:(%ToDate'="")&&(SttDate>%ToDate)      //add by zf 增加时间段判断
				
				Set SubID=0
				For {
					Set SubID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate,SubID))
					Quit:SubID=""
					
					Continue:(..IsValidOEItem(OrderID_"||"_SubID)=0)
					
					Set OrderItemID=OrderID_"||"_SubID
					Set objItm=##class(DHCMed.Base.OrdItem).GetObjById(OrderItemID)
					Do objItm.%Close()
					Continue:'$IsObject(objItm)
					
					Set Count=Count+1
					
					//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
					Set Record=""
					Set $p(Record,$c(3),1)=objArcim.ARCIMDesc  //_"  医嘱日期："_$zd(objItm.OEORIDate,3)_" 剂量："_objItm.OEORIDoseQty_objItm.CTUOMDesc_" "_objItm.OSTATDesc
					Set $p(Record,$c(3),2)=objItm.OEORISttDat
					Set $p(Record,$c(3),3)=objItm.OEORISttTim
					Set $p(Record,$c(3),4)=objItm.ARCIMDesc
					Set $p(Record,$c(3),5)=OrderID_"||"_SubID
					Set $p(Record,$c(3),6)=objItm.OEORIDoctorDR
					Set $p(Record,$c(3),7)="PhsCatName"_PhsCatName
					Set %ExtraData=%ExtraData_$lb(Record)
				}
			}
		}
	}
	Set return=Count
	Quit return
	
GetItemCountByPhsCatErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2012-08-31
/// Description:  通过抗生素标记（药学项）取抗生素医嘱信息
/// Table：       OE_OrdItem
/// Input：       
/// Return：      return<0：程序错误   return>0：正确
/// w ##class(DHCMed.CCService.Lib.OEOrdItem).GetAntiByFlag()
ClassMethod GetAntiByFlag(aDateFrom As %String = "", aDateTo As %String = "") As %String
{
	New (aDateFrom,aDateTo,%EpisodeID,%ExtraData,%ErrorData,%FromDate,%ToDate)
	Set return=0,Count=0
	
	Set $ZT="GetAntiByFlagErr"
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	
	Set OrderID=0
	For {
		Set OrderID=$o(^OEORD(0,"Adm",%EpisodeID,OrderID))
		Quit:OrderID=""
		Set ArcimID=""
		For {
			Set ArcimID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID))
			Quit:ArcimID=""
			
			//抗生素标记
			Set AntiFlag=##Class(DHCMed.CCService.Lib.OEOrdItem).GetAntiFlag(ArcimID)
			Continue:AntiFlag'="Y"
			
			Set ArcimName=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)
			Set SttDate=0,flg=0
			For {
				Set SttDate=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate))
				Quit:SttDate=""
				Continue:(aDateFrom'="")&&(SttDate<aDateFrom)
				Continue:(aDateTo'="")&&(SttDate>aDateTo)
				Continue:(%FromDate'="")&&(SttDate<%FromDate)  //add by zf 增加时间段判断
				Continue:(%ToDate'="")&&(SttDate>%ToDate)      //add by zf 增加时间段判断
				
				Set SubID=0
				For {
					Set SubID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate,SubID))
					Quit:SubID=""
					
					Continue:(..IsValidOEItem(OrderID_"||"_SubID)=0)
					
					Set flg=1
					Set StartDate=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",9)  //医嘱开始日期
					Set:StartDate'="" StartDate=$zd(StartDate,3)
					Set StartTime=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",10) //医嘱开始时间
					Set:StartTime'="" StartTime=$zt(StartTime,2)
					Set Doctor=$p($g(^OEORD(+OrderID,"I",SubID,1)),"^",11)   //开医嘱医生
					Set DoctorName=$p($g(^CTPCP(+Doctor,1)),"^",2)
					Set:Doctor'="" Doctor=$o(^SSU("SSUSR",0,"CTPCP",+Doctor,0))
					
					//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
					Set Record=""
					Set $p(Record,$c(3),1)=ArcimName	//_"("_StartDate_" "_StartTime_" "_DoctorName_")" update by liuyh 2013-02-27
					Set $p(Record,$c(3),2)=StartDate
					Set $p(Record,$c(3),3)=StartTime
					Set $p(Record,$c(3),4)=ArcimName
					Set $p(Record,$c(3),5)=ArcimID
					Set $p(Record,$c(3),6)=+Doctor
					Set $p(Record,$c(3),7)="aDateFrom:"_aDateFrom_",aDateTo:"_aDateTo
					Set %ExtraData=%ExtraData_$lb(Record)
				}
			}
			Set:flg=1 Count=Count+1
		}
	}
	
	Set return=Count
	Quit return
	
GetAntiByFlagErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2012-08-31
/// Description:  通过管制分类（药学项）取抗生素医嘱信息
/// Table：       OE_OrdItem
/// Input：       
/// Return：      return<0：程序错误   return>0：正确
/// w ##class(DHCMed.CCService.Lib.OEOrdItem).GetAntiByPoison("")
ClassMethod GetAntiByPoison(aPoison As %String, aDateFrom As %String = "", aDateTo As %String = "") As %String
{
	New (aPoison,aDateFrom,aDateTo,%EpisodeID,%ExtraData,%ErrorData,%FromDate,%ToDate)
	Set return=0,Count=0
	Quit:aPoison="" return
	
	Set $ZT="GetAntiByPoisonErr"
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	
	If (aPoison'="") {
		Set PoisonList=##Class(DHCMed.CCService.Lib.Common).GetListFromString(aPoison,"|")
	} Else {
		Set PoisonList=""
	}
	
	Set OrderID=0
	For {
		Set OrderID=$o(^OEORD(0,"Adm",%EpisodeID,OrderID))
		Quit:OrderID=""
		Set ArcimID=""
		For {
			Set ArcimID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID))
			Quit:ArcimID=""
			
			//抗生素管制分类
			Set AntiPoison=##Class(DHCMed.CCService.Lib.OEOrdItem).GetAntiPoison(ArcimID)
			Set PoisonCode=$p(AntiPoison,"^",1)
			Set PoisonDesc=$p(AntiPoison,"^",2)
			If (PoisonList'="") {
				Continue:(PoisonCode="")||(PoisonDesc="")
				Continue:($listfind(PoisonList,PoisonCode)<1)&&($listfind(PoisonList,PoisonDesc)<1)
			}
			
			Set ArcimName=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)
			Set SttDate=0,flg=0
			For {
				Set SttDate=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate))
				Quit:SttDate=""
				Continue:(aDateFrom'="")&&(SttDate<aDateFrom)
				Continue:(aDateTo'="")&&(SttDate>aDateTo)
				Continue:(%FromDate'="")&&(SttDate<%FromDate)  //add by zf 增加时间段判断
				Continue:(%ToDate'="")&&(SttDate>%ToDate)      //add by zf 增加时间段判断
				
				Set SubID=0
				For {
					Set SubID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate,SubID))
					Quit:SubID=""
					
					Continue:(..IsValidOEItem(OrderID_"||"_SubID)=0)
					
					Set flg=1
					Set StartDate=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",9)  //医嘱开始日期
					Set:StartDate'="" StartDate=$zd(StartDate,3)
					Set StartTime=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",10) //医嘱开始时间
					Set:StartTime'="" StartTime=$zt(StartTime,2)
					Set Doctor=$p($g(^OEORD(+OrderID,"I",SubID,1)),"^",11)   //开医嘱医生
					Set DoctorName=$p($g(^CTPCP(+Doctor,1)),"^",2)
					Set:Doctor'="" Doctor=$o(^SSU("SSUSR",0,"CTPCP",+Doctor,0))
					
					//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
					Set Record=""
					Set $p(Record,$c(3),1)=ArcimName	//_"("_AntiPoison_" "_StartDate_" "_StartTime_" "_DoctorName_")" update by liuyh 2013-02-27
					Set $p(Record,$c(3),2)=StartDate
					Set $p(Record,$c(3),3)=StartTime
					Set $p(Record,$c(3),4)=ArcimName
					Set $p(Record,$c(3),5)=ArcimID
					Set $p(Record,$c(3),6)=+Doctor
					Set $p(Record,$c(3),7)="aDateFrom:"_aDateFrom_",aDateTo:"_aDateTo
					Set %ExtraData=%ExtraData_$lb(Record)
				}
			}
			Set:flg=1 Count=Count+1
		}
	}
	
	Set return=Count
	Quit return
	
GetAntiByPoisonErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

ClassMethod GetPhcCat(arcim)
{
     n (arcim) 
     s s=""
     s drgfrmrowid=$p($g(^ARCIM(+arcim,1,1)),"^",12)        ;PHC_DrgForm:药学形态
     s drugrowid=+drgfrmrowid                           ;PHC_DrgMast药理学项
     q:drugrowid=0 s
     s psubcatrowid=$p($g(^PHCD(drugrowid,1)),"^",3)        ;PHC_SubCat药理学子分类
     ;s pmincatrowid=$p($g(^PHCD(drugrowid,1)),"^",6)        ;PHC_MinorSubCat药理学最小分类
     s phccat=+psubcatrowid                             ;phc_cat药理学分类
     s s=phccat_"/"_$p($g(^PHCC(phccat)),"^",1)_"/"_$p($g(^PHCC(phccat)),"^",2)
     q s
}

ClassMethod GetPhcSubCat(arcim)
{
     n (arcim) 
     s s=""
     s drgfrmrowid=$p($g(^ARCIM(+arcim,1,1)),"^",12)        ;PHC_DrgForm:药学形态
     s drugrowid=+drgfrmrowid                           ;PHC_DrgMast药理学项
     q:drugrowid=0 s
     s psubcatrowid=$p($g(^PHCD(drugrowid,1)),"^",3)        ;PHC_SubCat药理学子分类
     q:psubcatrowid="" ""
     ;s pmincatrowid=$p($g(^PHCD(drugrowid,1)),"^",6)        ;PHC_MinorSubCat药理学最小分类
     s phccat=+psubcatrowid                             ;phc_cat药理学分类
     s phcsub=$p(psubcatrowid,"||",2)
     s s=psubcatrowid_"/"_$p($g(^PHCC(+phccat,"SC",+phcsub)),"^",1)_"/"_$p($g(^PHCC(+phccat,"SC",+phcsub)),"^",2)
     q s
}

/// Creator：     zhufei
/// CreatDate：   2012-08-31
/// Description:  取药品管制分类
/// Table：       ARC_ItmMast 医嘱项
///               PHC_DrgForm 药学形态
/// Input：       argArcimID : 医嘱项ID
/// Return：      return=抗生素标记
/// w ##class(DHCMed.CCService.Lib.OEOrdItem).GetAntiFlag("")
ClassMethod GetAntiFlag(argArcimID As %String) As %String
{
	New (argArcimID)
	Set return=""
	
	Set $ZT="GetAntiFlagErr"
	
	Set DrgFormID=$p(^ARCIM(+argArcimID,1,1),"^",12)   ;PHC_DrgForm 药学形态
	Quit:DrgFormID="" return
	Set AntiFlag=$p($g(^PHCD(+DrgFormID,"DF",$p(DrgFormID,"||",2),"DHC")),"^",8)
	Set return=AntiFlag
	
	Quit return
	
GetAntiFlagErr
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2012-08-31
/// Description:  取药品管制分类
/// Table：       ARC_ItmMast 医嘱项
///               PHC_DrgForm 药学形态
///               PHC_DrgMast 药理学项
///               PHC_Poison  管制分类
/// Input：       argArcimID : 医嘱项ID
/// Return：      return=管制分类名称
/// w ##class(DHCMed.CCService.Lib.OEOrdItem).GetAntiPoison("")
ClassMethod GetAntiPoison(argArcimID As %String) As %String
{
	New (argArcimID)
	Set return=""
	
	Set $ZT="GetAntiPoisonErr"
	
	Set DrgFormID=$p(^ARCIM(+argArcimID,1,1),"^",12)   ;PHC_DrgForm 药学形态
	Quit:DrgFormID="" return
	Set DrgMastID=+DrgFormID                           ;PHC_DrgMast 药理学项
	Set PoisonID=$p($g(^PHCD(DrgMastID,1)),"^",4)      ;PHC_Poison  管制分类
	Set PoisonCode=$p($g(^PHCPO(+PoisonID)),"^",1)
	Set PoisonDesc=$p($g(^PHCPO(+PoisonID)),"^",2)
	Quit:(PoisonCode="")||(PoisonDesc="") return
	Set return=PoisonCode_"^"_PoisonDesc
	
	Quit return
	
GetAntiPoisonErr
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2012-08-31
/// Description:  判断医嘱是否有效
/// Table：       OE_OrdItem
/// Input：       
/// Return：      return=0：无效   return=1：有效
/// w ##class(DHCMed.CCService.Lib.OEOrdItem).IsValidOEItem("")
ClassMethod IsValidOEItem(argOEItemID As %String, argIsAll As %String = "N") As %String
{
	New (argOEItemID,argIsAll)
	Set return=0
	Quit:argOEItemID="" return
	
	Set $ZT="IsValidOEItemErr"
	
	Set StatusID=$p($g(^OEORD(+argOEItemID,"I",+$p(argOEItemID,"||",2),1)),"^",13)
	Set StatusCode=$p($g(^OEC("OSTAT",+StatusID)),"^",1)
	Set StatusDesc=$p($g(^OEC("OSTAT",+StatusID)),"^",2)
	Quit:(StatusCode="")||(StatusDesc="") return
	
	//作废,未审核,预开医嘱
	Set StatusList=$lb("U","I","P")
	Quit:($listfind(StatusList,StatusCode)>0) return
	
	//停止医嘱
	If (StatusCode="D")&&(argIsAll'="Y") {
		Quit return
	}
	
	Set return=1
	Quit return
	
IsValidOEItemErr
	Quit 0
}

}
