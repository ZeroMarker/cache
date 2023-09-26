/// 名称: DHCMed.CCService.Lib.LisReport
/// 描述: 与LIS相关的函数库
/// 编写者：zhufei
/// 编写日期: 2011-03-22
Class DHCMed.CCService.Lib.LisReport Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Lib.LisReport).Test()
ClassMethod Test()
{
	// 查找检验医嘱及检验项目内容SQL，仅供参考
	// select cttsf_parref->ctts_name,CTTSF_DataItem_DR->cttc_code,CTTSF_DataItem_DR->cttc_desc,CTTSF_DataItem_DR->cttc_units,CTTSF_DataItem_DR->cttc_resultformat from CT_TestSetFields where CTTSF_DataItem_DR->cttc_desc like "%白细胞%"
	New
	
	/*
	Set %EpisodeID=2058424
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckLabItem("检验||E9999|不等于| ||||@不等于")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Set %EpisodeID=2058424
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckItemAbnor("检验||E6010|异常标记|H||白细胞异常")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	
	Set %EpisodeID=46456
	Set %ExtraData=""
	Set %ErrorData=""
	Set %CurrentDate=""
	Set return=..GetRstAbnorOrder("医嘱||2556||血液分析")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	*/
	Set %EpisodeID=20233303
	Set %ExtraData=""
	Set %ErrorData=""
	Set %CurrentDate=""
	Set return=..CheckLabItem("检验||A0010|小于|4||||@*白细胞小于4")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Quit "Over"
}

/// Creator：     zhufei
/// CreatDate：   2011-03-22
/// Description:  通过Lab表达式取检验监控结果
/// Table：       
/// Input：       LabExp : 检验项目检查表达式
/// Return：      返回检验项目数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.LisReport).CheckLabItem("")
ClassMethod CheckLabItem(argLabExp As %String) As %String
{
	New (argLabExp,%EpisodeID,%ExtraData,%ErrorData)
	Set return=0,Count=0
	Quit:argLabExp="" return
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="CheckLabItemErr"
	
	Set LabExp2=$p(argLabExp,"||",2)
	Set LabExp3=$p(argLabExp,"||",3)
	Set TestCode=$p(LabExp2,"|",1)
	Set ComCode=$p(LabExp2,"|",2)
	Set ComValue=$p(LabExp2,"|",3)
	Set ComArcimDesc=$p(LabExp2,"|",4)   //add by wuqk 2011-11-10
	Set ComSpecimenDesc=$p(LabExp2,"|",5)   //add by wuqk 2011-11-10
	Quit:(TestCode="")||(ComCode="") return
	Set OrderID=$o(^OEORD(0,"Adm",%EpisodeID,0))
	Quit:OrderID="" return
	Set SubID=0
	
	Set LabTestSetRow=""
	For {
		Set SubID=$o(^OEORD(OrderID,"I",SubID))
		Quit:SubID=""
		Set LabTestSetRow=$P($g(^OEORD(OrderID,"I",SubID,3)),"^",35)
		Continue:LabTestSetRow=""
		Set VisitNumber=$p(LabTestSetRow,"||",1)
 		Set TestSet=$p(LabTestSetRow,"||",2)
 		Set TestSetCount=$p(LabTestSetRow,"||",3)
 		Continue:(VisitNumber="")||(TestSet="")||(TestSetCount="")
 		// ********************************************************************** //
 		// Add By LiYang 2012-12-28 FixBug 检验结果未过滤掉未审核结果
 		Continue:$p($g(^TEPI(VisitNumber,1,TestSet,TestSetCount)),"\",31)'="A"
 		// ********************************************************************** //
 		
 		Continue:'$d(^TEPI(VisitNumber,1,TestSet,TestSetCount,"DATA",TestCode))
		;Set SubID=$o(^OEORDi(0,"LabTS",OrderID,LabTestSetRow,0))
		;Continue:SubID=""
		Set StatusID=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",13)
		Set StatusDesc=$p($g(^OEC("OSTAT",+StatusID)),2)
		Continue:StatusDesc["停止"
		
		Set Arcim=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",2)      //医嘱项
		Set ArcimDesc=$p($g(^ARCIM(+$p(Arcim,"||",1),+$p(Arcim,"||",2),1)),"^",2)
		
		Continue:(ArcimDesc'[ComArcimDesc)&(ComArcimDesc'="")    //add by wuqk 2011-11-10
		Set Lab1=$p($g(^OEORD(OrderID,"I",SubID,8)),"^",16)  //标本 OEORI_Lab1________  8______________  16
		set:Lab1'="" Lab1=$p($g(^DHCSpS("SPS",Lab1)),"^",2)
		Continue:(Lab1'[ComSpecimenDesc)&(ComSpecimenDesc'="")    //add by wuqk 2011-11-10
		
		
		Set tmpResult=$g(^TEPI(VisitNumber,1,TestSet,TestSetCount,"DATA",TestCode))
		Set tmpResult=$p(tmpResult,"\",1)
		Set LabResult=..GetTestCodeResult(VisitNumber,TestCode,tmpResult)
		Set ItemDesc=$p(LabResult,$c(2),2)    //检验项目描述
		Set ItemResult=$p(LabResult,$c(2),3)  //结果
		Continue:..ComResult(ItemResult,ComCode,ComValue)=0
		Set ItemUnit=$p(LabResult,$c(2),4)    //检验项目的单位
		Set AbnorFlag=$p(LabResult,$c(2),5)   //异常标记
		
		//Modify by wuqk 2012-1-19
		//Set ItemRangs=$p(LabResult,$c(2),6)   //参考范围
		Set ItemRangs=$g(^TEPI(VisitNumber,1,TestSet,TestSetCount,"DATA",TestCode,"Ranges"))
		//Modify End
		
		Set Synonym=$p(LabResult,$c(2),7)     //英文缩写
		
		Set Count=Count+1
		;Set StartDate=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",9)  //医嘱开始日期
		;Set StartTime=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",10) //医嘱开始时间
		
		Set StartDate=$p($g(^TEPI(VisitNumber,1,TestSet,TestSetCount)),"\",69)
		Set StartTime=$p($g(^TEPI(VisitNumber,1,TestSet,TestSetCount)),"\",70)
		If StartDate="" {
			Set StartDate=$p($g(^TEPI(VisitNumber,1,TestSet,TestSetCount)),"\",1)
			Set StartTime=$p($g(^TEPI(VisitNumber,1,TestSet,TestSetCount)),"\",2)
		}
		
		Set Doctor=$p($g(^OEORD(+OrderID,"I",SubID,1)),"^",11)   //开医嘱医生
		Set:StartDate'="" StartDate=$zd(StartDate,3)
		Set:StartTime'="" StartTime=$zt(StartTime,2)
		Set Doctor=$p($g(^CTPCP(+Doctor,1)),"^",2)
		
		//add by zf 2014-01-24 发生日期和发生时间
		Set OccurDate=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",9)  //医嘱开始日期
		Set OccurTime=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",10) //医嘱开始时间
		
		;Set LabRst="医嘱:"_ArcimDesc_" "_StartDate_" "_StartTime_" "_Doctor_",检验项目:"_ItemDesc_",结果:"_ItemResult_ItemUnit_",异常标记:"_AbnorFlag_",参考范围:"_ItemRangs
		Set LabRst="医嘱:"_ArcimDesc_",检验项目:"_ItemDesc_",结果:"_ItemResult_" "_ItemUnit_",异常标记:"_AbnorFlag_",参考范围:"_ItemRangs
		Set LabRst=$$BuildCheckLabItemResult(LabRst)  ////格式化输出
		Set %ExtraData=%ExtraData_$lb(LabRst)
	}
	
	Set return=Count
	Quit return
	
CheckLabItemErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
BuildCheckLabItemResult(arg0) //Add By LiYang 2012-06-20
	Set tmpDesc=arg0
	//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
	Set objUser=##class(DHCMed.Base.SSUser).GetByCTPCP(+$p($g(^OEORD(+OrderID,"I",SubID,1)),"^",11))
	Set:$IsObject(objUser)=0 objUser=##class(DHCMed.Base.SSUser).%New()
	Do objUser.%Close()	
	Set:StartDate["-" StartDate=$zdh(StartDate,3)
	Set:StartTime[":" StartTime=$zth(StartTime,2)
	Set tmp=""
	Set $p(tmp,$c(3),1)=tmpDesc
	Set $p(tmp,$c(3),2)=+StartDate
	Set $p(tmp,$c(3),3)=+StartTime 
	Set $p(tmp,$c(3),4)=ItemResult_ItemUnit
	Set $p(tmp,$c(3),5)=OrderID_"||"_SubID
	Set $p(tmp,$c(3),6)=+objUser.Rowid
	
	//update by lyh 2012-11-28 拼凑检验表达式
	Set PatientID=$p($g(^PAADM(%EpisodeID)),"^",1)
	Set OEItemID=OrderID_"||"_SubID
	Set $p(tmp,$c(3),7)="PatientBanner=1&PatientID="_PatientID_"&TestSetRow="_LabTestSetRow_"&OrderID="_OEItemID
	
	Set $p(tmp,$c(3),8)=OccurDate
	Set $p(tmp,$c(3),9)=OccurTime
	
	Quit tmp
}

/// Creator：     zhufei
/// CreatDate：   2011-03-22
/// Description:  通过Lab表达式取检验监控结果
/// Table：       
/// Input：       LabExp : 检验项目检查表达式
/// Return：      返回检验项目数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.LisReport).CheckItemAbnor("")
ClassMethod CheckItemAbnor(argLabExp As %String) As %String
{
	New (argLabExp,%EpisodeID,%ExtraData,%ErrorData)
	Set return=0,Count=0
	Quit:argLabExp="" return
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="CheckItemAbnorErr"
	
	Set LabExp2=$p(argLabExp,"||",2)
	Set LabExp3=$p(argLabExp,"||",3)
	Set TestCode=$p(LabExp2,"|",1)
	Set ComCode=$p(LabExp2,"|",2)
	Set ComValue=$p(LabExp2,"|",3)
	Quit:(TestCode="")||(ComCode="") return
	Quit:ComCode'="异常标记" return
	
	Set OrderID=$o(^OEORD(0,"Adm",%EpisodeID,0))
	Quit:OrderID="" return
	Set LabTestSetRow=""
	For {
		Set LabTestSetRow=$o(^OEORDi(0,"LabTS",OrderID,LabTestSetRow))
		Quit:LabTestSetRow=""
		Set VisitNumber=$p(LabTestSetRow,"||",1)
 		Set TestSet=$p(LabTestSetRow,"||",2)
 		Set TestSetCount=$p(LabTestSetRow,"||",3)
 		Continue:(VisitNumber="")||(TestSet="")||(TestSetCount="")
 		
 		// ********************************************************************** //
 		// Add By LiYang 2012-12-28 FixBug 检验结果未过滤掉未审核结果
 		Continue:$p($g(^TEPI(VisitNumber,1,TestSet,TestSetCount)),"\",31)'="A"
 		// ********************************************************************** //
 		
 		Continue:'$d(^TEPI(VisitNumber,1,TestSet,TestSetCount,"DATA",TestCode))
 		
		Set SubID=$o(^OEORDi(0,"LabTS",OrderID,LabTestSetRow,0))
		Continue:SubID=""
		Set StatusID=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",13)
		Set StatusDesc=$p($g(^OEC("OSTAT",+StatusID)),2)
		Continue:StatusDesc["停止"
		
		Set tmpResult=$g(^TEPI(VisitNumber,1,TestSet,TestSetCount,"DATA",TestCode))
		Set tmpResult=$p(tmpResult,"\",1)
		Set LabResult=..GetTestCodeResult(VisitNumber,TestCode,tmpResult)
		Set ItemDesc=$p(LabResult,$c(2),2)    //检验项目描述
		Set ItemResult=$p(LabResult,$c(2),3)  //结果
		Set ItemUnit=$p(LabResult,$c(2),4)    //检验项目的单位
		Set AbnorFlag=$p(LabResult,$c(2),5)   //异常标记
		//Continue:AbnorFlag'[ComValue
		Continue:((AbnorFlag'["L")&&(AbnorFlag'["H"))
		Set ItemRangs=$p(LabResult,$c(2),6)   //参考范围
		Set Synonym=$p(LabResult,$c(2),7)     //英文缩写
		
		Set Count=Count+1
		Set Arcim=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",2)      //医嘱项
		Set ArcimDesc=$p($g(^ARCIM(+$p(Arcim,"||",1),+$p(Arcim,"||",2),1)),"^",2)
		;Set StartDate=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",9)  //医嘱开始日期
		;Set StartTime=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",10) //医嘱开始时间
		
		Set StartDate=$p($g(^TEPI(VisitNumber,1,TestSet,TestSetCount)),"\",69)
		Set StartTime=$p($g(^TEPI(VisitNumber,1,TestSet,TestSetCount)),"\",70)
		If StartDate="" {
			Set StartDate=$p($g(^TEPI(VisitNumber,1,TestSet,TestSetCount)),"\",1)
			Set StartTime=$p($g(^TEPI(VisitNumber,1,TestSet,TestSetCount)),"\",2)
		}
		
		Set Doctor=$p($g(^OEORD(+OrderID,"I",SubID,1)),"^",11)   //开医嘱医生
		Set:StartDate'="" StartDate=$zd(StartDate,3)
		Set:StartTime'="" StartTime=$zt(StartTime,2)
		Set Doctor=$p($g(^CTPCP(+Doctor,1)),"^",2)
		
		//add by zf 2014-01-24 发生日期和发生时间
		Set OccurDate=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",9)  //医嘱开始日期
		Set OccurTime=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",10) //医嘱开始时间
		
		Set LabRst="医嘱:"_ArcimDesc_" "_StartDate_" "_StartTime_" "_Doctor_"(检验项目:"_ItemDesc_",结果:"_ItemResult_ItemUnit_",异常标记:"_AbnorFlag_",参考范围:"_ItemRangs_")"
		Set LabRst=$$BuildCheckItemAbnorResult(LabRst) //格式化输出
		Set %ExtraData=%ExtraData_$lb(LabRst)
	}
	
	Set return=Count
	Quit return
	
CheckItemAbnorErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
BuildCheckItemAbnorResult(arg0) //Add By LiYang 2012-06-20
	Set tmpDesc=arg0
	//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
	Set objUser=##class(DHCMed.Base.SSUser).GetByCTPCP(+$p($g(^OEORD(+OrderID,"I",SubID,1)),"^",11))
	Set:$IsObject(objUser)=0 objUser=##class(DHCMed.Base.SSUser).%New()
	Do objUser.%Close()		
	Set tmp=""
	Set $p(tmp,$c(3),1)=tmpDesc
	Set $p(tmp,$c(3),2)=+StartDate
	Set $p(tmp,$c(3),3)=+StartTime
	Set $p(tmp,$c(3),4)=ItemResult_ItemUnit
	Set $p(tmp,$c(3),5)=OrderID_"||"_SubID
	Set $p(tmp,$c(3),6)=+objUser.Rowid

	//update by lyh 2012-11-28 拼凑检验表达式
	Set PatientID=$p($g(^PAADM(%EpisodeID)),"^",1)
	Set OEItemID=OrderID_"||"_SubID
	Set $p(tmp,$c(3),7)="PatientBanner=1&PatientID="_PatientID_"&TestSetRow="_LabTestSetRow_"&OrderID="_OEItemID
	
	Set $p(tmp,$c(3),8)=OccurDate
	Set $p(tmp,$c(3),9)=OccurTime
	
	Quit tmp
}

/// ret=1:成功  ret=0:不成功
/// w ##Class(DHCMed.CCService.Lib.LisReport).ComResult(140.8,"大于",10)
ClassMethod ComResult(argResult, argComCode, argComValue) As %String
{
	New (argResult,argComCode,argComValue)
	Set return=0
	If argComCode="等于" {
		Set:argResult=argComValue return=1
	}ElseIf argComCode="大于" {
		Set:(+argResult)>(+argComValue) return=1
	}ElseIf argComCode="小于" {
		Set:(+argResult)<(+argComValue) return=1
	}ElseIf argComCode="大于等于" {
		Set:(+argResult)>=(+argComValue) return=1
	}ElseIf argComCode="小于等于" {
		Set:(+argResult)>=(+argComValue) return=1
	}ElseIf argComCode="不等于" {
		Set:argResult'=argComValue return=1
	}ElseIf argComCode="包含" {
		Set:argResult[argComValue return=1
	}ElseIf argComCode="被包含" {
		Set:argResult]argComValue return=1
	}ElseIf argComCode="不包含" {
		Set:argResult'[argComValue return=1
	}ElseIf argComCode="=" {
		Set:argResult=argComValue return=1
	}ElseIf argComCode=">" {
		Set:(+argResult)>(+argComValue) return=1
	}ElseIf argComCode="<" {
		Set:(+argResult)<(+argComValue) return=1
	}ElseIf argComCode=">=" {
		Set:(+argResult)>=(+argComValue) return=1
	}ElseIf argComCode="<=" {
		Set:(+argResult)<=(+argComValue) return=1
	}ElseIf argComCode="'=" {
		Set:argResult'=argComValue return=1
	}ElseIf argComCode="[" {
		Set:argResult[argComValue return=1
	}ElseIf argComCode="]" {
		Set:argResult[argComValue return=1
	}ElseIf argComCode="'[" {
		Set:argResult'[argComValue return=1
	}Else{
		Set:argResult=argComValue return=1
	}
    Quit return
}

/// 获取检验项目的异常标记
/// TestCode:检验项代码，TCResult:检验结果，TCRanges：检验项范围值（默认为空）
/// [Previously private]
ClassMethod GetAbnorFlag(TestCode As %String, TCResult As %String, TCRanges As %String = "") As %String
{
	Set FormatFlag=""
	//Set currNS=$znspace
	Set:$Data(^TTAB("TC",TestCode))'=0 FormatFlag=$Piece(^TTAB("TC",TestCode),"\",3)
	Quit:FormatFlag=""!TCResult=""!TestCode="" ""
	Set:TCRanges="" PType="0",TCRanges=..GetTCRanges(TestCode, "","", "", PType, "", "", "", "1","")
	Set:'$l(TCRanges) TCRanges=..GetMultiScope(TestCode)
	Set AbnorFlag=$Select(FormatFlag["N":$$GetAbnorFlagByNum(TCResult,TCRanges),FormatFlag["S":$$GetAbnorFlagByStCommen(TestCode,TCResult),FormatFlag["X":$$GetAbnorFlagByFreeText(TestCode,TCResult),1:"")
	//Set $znspace=currNS
	Quit AbnorFlag
	
	 ;数据型
GetAbnorFlagByNum(TCResult,TCRanges)
	s TCResult=$g(TCResult),TCRanges=$g(TCRanges)
	s (retvalue,retranges,retcolor)=""
	s retflag="N",lowflag="L",highflag="H"
	s reslow=$p(TCRanges,$c(1),1),reshigh=$p(TCRanges,$c(1),2)
	;panic unaccept
	s resPaniclow=$p(TCRanges,$c(1),3),resPanichigh=$p(TCRanges,$c(1),4)
	s resUnAcceptlow=$p(TCRanges,$c(1),9),resUnAccepthigh=$p(TCRanges,$c(1),10)
	;i TCRanges="" q ""
	i $l(TCRanges,$c(10))>1 q retvalue_$c(28)_retflag
	Set TCResult=$tr(TCResult,"><")
	;
	/*
	Set $znspace="LABDATA"
	Set lowflag=$p(^CF("LAB",1),"^",18),highflag=$p(^CF("LAB",1),"^",19)
	s rangsta=$p(^CF("LAB",1),"^",16),rangend=$p(^CF("LAB",1),"^",17)
	s iNormalBColor=$P(^CF("LAB",1,"COLOUR",0),"^",1)
	s iNormalFColor=$P(^CF("LAB",1,"COLOUR",0),"^",2)
    s iAboveBColor=$P(^CF("LAB",1,"COLOUR",11),"^",1)
    s iAboveFColor=$P(^CF("LAB",1,"COLOUR",11),"^",2)
    s iBelowBColor=$P(^CF("LAB",1,"COLOUR",12),"^",1)
    s iBelowFcolor=$P(^CF("LAB",1,"COLOUR",12),"^",2)
    ;
    s iUnAcceptBColor=$P(^CF("LAB",1,"COLOUR",2),"^",1)
    s iUnAcceptFColor=$P(^CF("LAB",1,"COLOUR",2),"^",2)
    s iPanicColor=$P($tr(^CF("LAB",1,"COLOUR",15),$c(13,10)),"^",11)
    Set $znspace=currNS
    ;
    s retcolor=iNormalBColor_$c(1)_iNormalFColor
    i TCRanges="" q retvalue_$c(28)_retranges_$c(28)_retcolor_$c(28)_retflag
	 
	i TCRanges="" q retvalue_$c(28)_retflag
	
	;---------add 20070914  修改范围值的显示
	i reslow="",reshigh="" d 
	.s retranges="" 
	i "<>"[$e(reslow) d ;($e(reslow,1)="<")!($e(reslow,1)=">") d
	.s retranges=rangsta_reslow_rangend
	e  d
	.s retranges=rangsta_reslow_"-"_reshigh_rangend
	;-----------
	*/
	i TCRanges="" q retvalue_$c(28)_retflag
	i '$ISVALIDNUM(TCResult) q retvalue_$c(28)_retflag
	;UnAccept check
	s rang=resUnAcceptlow_resUnAccepthigh
	i $l(rang) d
	.i (rang'["<")&(rang'[">") d
	..i TCResult<resUnAcceptlow s retvalue=lowflag,retflag="U" q
	..i TCResult>resUnAccepthigh s retvalue=highflag,retflag="U" q
	.i (rang["<") d
	..s lowvalue=$$res(rang) ;$p(rang,"<",2) modify 20070914
	..i TCResult>lowvalue s retvalue=highflag,retflag="U" q
	.i (rang["<") d
	..s highvlaue=$$res(rang) ;$p(rang,">",2) modify 20070914
	..i TCResult<highvlaue s retvalue=lowflag,retflag="U" q
	;Panic check
	s rang=resPaniclow_resPanichigh
	i $l(rang),retflag="N" d
	.i (rang'["<")&(rang'[">") d
	..i TCResult<resPaniclow s retvalue=lowflag,retflag="M" q
	..i TCResult>resPanichigh s retvalue=highflag,retflag="M" q
	.i (rang["<") d
	..s lowvalue=$$res(rang) ;$p(rang,"<",2) modify 20070914
	..i TCResult>lowvalue s retvalue=highflag,retflag="M" q
	.i (rang[">") d
	..s highvlaue=$$res(rang) ;$p(rang,">",2) modify 20070914
	..i TCResult<highvlaue s retvalue=lowflag,retflag="M" q
	;normal check
	s rang=reslow_reshigh
	i $l(rang),retflag="N" d
	.i (rang'["<")&(rang'[">") d
	..i TCResult<reslow s retvalue=lowflag,retflag="L" q
	..i TCResult>reshigh s retvalue=highflag,retflag="H" q
	.i (rang["<") d
	..s lowflag=$$res(rang) ;$p(rang,"<",2) modify 20070914
	..i TCResult>lowflag s retvalue=highflag,retflag="H" 
	.i (rang[">") d
	..s highflag=$$res(rang) ;$p(rang,">",2) modify 20070914
	..i TCResult<highflag s retvalue=lowflag,retflag="L"	
	q retvalue_$c(28)_retflag
	//q retflag
	
	;标准备注型	
GetAbnorFlagByStCommen(TestCode,TCResult)
	Set TestCode=$g(TestCode),TCResult=$g(TCResult)
	i '$l(TCResult) q $c(28,28,28)
	;
	/*
	Set $znspace="LABDATA"
	s iNormalBColor=$P(^CF("LAB",1,"COLOUR",0),"^",1)
	s iNormalFColor=$P(^CF("LAB",1,"COLOUR",0),"^",2)
    s iAboveBColor=$P(^CF("LAB",1,"COLOUR",11),"^",1)
    s iAboveFColor=$P(^CF("LAB",1,"COLOUR",11),"^",2)
    Set $znspace=currNS
    ;
    s retcolor=iNormalBColor_$c(1)_iNormalFColor
    */
    s retflag="N",retvalue=""
    ;s retvalue=TCResult
    ;s ^aareflag=TestCode_":"_TCResult
    i $d(^TTAB("TC",TestCode,2,TCResult)) d
    .s retflag=$p(^TTAB("TC",TestCode,2,TCResult),"\",1)
    .i retflag="A" s retvalue="*"
    q retvalue_$c(28)_retflag
    //q retflag
    
	;文本类型
GetAbnorFlagByFreeText(TestCode,TCResult)
	Set TestCode=$g(TestCode),TCResult=$g(TCResult)
	;
	/*
	Set $znspace="LABDATA"
	s iNormalBColor=$P(^CF("LAB",1,"COLOUR",0),"^",1)
	s iNormalFColor=$P(^CF("LAB",1,"COLOUR",0),"^",2)
    s iAboveBColor=$P(^CF("LAB",1,"COLOUR",11),"^",1)
    s iAboveFColor=$P(^CF("LAB",1,"COLOUR",11),"^",2)
    Set $znspace=currNS
    ;
    s retcolor=iNormalBColor_$c(1)_iNormalFColor
    */
    s retflag="N",retvalue=""
    ;s retvalue=TCResult
    s temstr=""
    s std="" f  s std=$o(^TTAB("TC",TestCode,2,std)) q:std=""  d
    .i $p(^TTAB("TC",TestCode,2,std),"\",1)="A" d
    ..i $d(^TTAB("TC",TestCode,2,std,1)),TCResult[$g(^TTAB("TC",TestCode,2,std,1)) ,retvalue="*",retflag="A"
    q retvalue_$c(28)_retflag
    // q retflag
    
res(rang) ; check < >
 i rang[">" s rang=$tr(rang,">")+.00000001
 i rang["<" s rang=$tr(rang,"<")-.00000001
 q rang
}

/// 获取项目的范围值
/// TestCode:项目代码,Age:年龄,Species:性别,Pregn:怀孕(0),PatientType:病人类型(0\0-IN),Date:日期,Cond:临床条件(0),Loc:0,mi:1\2,Weeks:周(0)
/// [Previously private]
ClassMethod GetTCRanges(TestCode As %String, Age As %Integer = "", Species As %String = "", Pregn As %String = "", PatientType As %String = "0", Date As %String = "", Cond As %String = "", Loc As %String = "", mi As %String = "1", Weeks As %Integer = "") As %String
{
 Set (j,x,xf,age0,type,exist,result,format)=""
 Set result=""
 Set tc=$g(TestCode),age=$g(Age),spec=$g(Species),pregn=$g(Pregn),ptype=$g(PatientType),date=$g(Date),cond=$g(Cond),loc=$g(Loc),mi=$g(mi),weeks=$g(Weeks)
 ;
 If '$l(age) Set age=0
 If '$l(spec) Set spec="M"
 ;;
 Set format=$p($g(^TTAB("TC",tc)),"\",3)
 i '$l(date) s date=+$h
 i '$d(^TTAB("TC",tc,4,date)) s date=$o(^TTAB("TC",tc,4,date),-1)
 i $l(date) d
 .For type=ptype,$e(ptype) i $d(^TTAB("TC",tc,4,date,type)) d  q
 ..k xf s x="" f  s x=$o(^TTAB("TC",tc,4,date,type,x)) q:x=""  d
 ...i $l($p(^(x),"\",23)),'$l(age) q
 ...i $l($p(^(x),"\",23)),$l($p(^(x),"\",23),"-")'>1 Set $p(^(x),"\",23)="0-"_$p(^(x),"\",23) //如果年龄只有最大值，则改为“0-最大值”的格式
 ...i $l($p(^(x),"\",23)),age<$p($p(^(x),"\",23),"-",1) q
 ...i $l($p(^(x),"\",23)),age>$p($p(^(x),"\",23),"-",2) q
 ...i $l($p(^(x),"\",22)),$p(^(x),"\",22)'=spec q
 ...i $l($p(^(x),"\",21)),$p(^(x),"\",21)'=cond q
 ...i $l($p(^(x),"\",24)),$p(^(x),"\",24)'=loc q
 ...i $l($p(^(x),"\",25)),'$l(age) q
 ...i $l($p(^(x),"\",25)),weeks<$p($p(^(x),"\",25),"-",1) q
 ...i $l($p(^(x),"\",25)),weeks>$p($p(^(x),"\",25),"-",2) q
 ...s xf=(''$l($p(^(x),"\",21)))+(''$l($p(^(x),"\",22)))+(''$l($p(^(x),"\",23)))+(''$l($p(^(x),"\",24)))+(''$l($p(^(x),"\",25))),xf(xf,x)=^(x)
 ..s xf=$o(xf(""),-1) i $l(xf) s x=$o(xf(xf,"")) i $l(x) d
 ...s (aaLow,aaHigh,aaPLow,aaPHigh)=""
 ...//i $l(mi) s rowid=tc_"||"_date_"||"_type_"||"_x_"||"_mi i '$$select^LVBCTTCG(rowid) d
 ...//.s aaLow=PLIST(3),aaHigh=PLIST(4),aaPLow=PLIST(5),aaPHigh=PLIST(6)
 ...i $l(mi) d Select 
 ...s xx=$p(xf(xf,x),"\",1,8)_"\"_$p(xf(xf,x),"\",17,18)
 ...i $l(aaLow)!$l(aaHigh) s $p(xx,"\",3)=aaLow,$p(xx,"\",4)=aaHigh
 ...i pregn["Y" s xx=$p(xf(xf,x),"\",9,16)_"\"_$p(xf(xf,x),"\",19,20) d
 ....s exist="" f j=1:1:10 i $l($p(xx,"\",j)) s exist=1 q
 ....i 'exist d
 .....s xx=$p(xf(xf,x),"\",1,8)_"\"_$p(xf(xf,x),"\",17,18)
 .....i $l(aaPLow)!$l(aaPHigh) s $p(xx,"\",3)=aaPLow,$p(xx,"\",4)=aaPHigh
 ...s result=$p(xx,"\",1)_$c(1)_$p(xx,"\",2)_$c(1)_$p(xx,"\",5)_$c(1)_$p(xx,"\",6)_$c(1)_$p(xx,"\",7)_$c(1)_$p(xx,"\",8)_$c(1)_$p(xx,"\",3)_$c(1)_$p(xx,"\",4)_$c(1)_$p(xx,"\",9)_$c(1)_$p(xx,"\",10)
 For j=1:1:$l(result,$c(1)) s x=$p(result,$c(1),j) i $l(x) d
 .i ($e(x)="<")!($e(x)=">") d  q
 ..s $p(result,$c(1),j)=$e(x)_$j($e(x,2,$l(x)),0,$e(format,2,4))
 ..i $e(x,2)="." s $p(result,$c(1),j)=$e(x)_0_$e(x,2,$l(x))
 .s $p(result,$c(1),j)=$j(x,0,$e(format,2,4))
 .i $e($p(result,$c(1),j))="." s $p(result,$c(1),j)=0_$p(result,$c(1),j)
  //w !,"@Debug Start-------------------------------------",!
  //w "result:"_result
  //w !,"@Debug End---------------------------------------",!
 Quit result
 
Select
 set tc=$g(tc),date=$g(date), type=$g(type),x=$g(x),mi=$g(mi),ValDeli="\"
 If $Data(^TTAB("TC",tc,4,date,type,x,mi))=0 Quit
 Set rangesAAStr=^TTAB("TC",tc,4,date,type,x,mi)
 Set aaLow=$Piece(rangesAAStr,ValDeli,1)
 Set aaHigh=$Piece(rangesAAStr,ValDeli,2)
 Set aaPLow=$Piece(rangesAAStr,ValDeli,3)
 Set aaPHigh=$Piece(rangesAAStr,ValDeli,4)
 Quit
}

/// 检验项目结果多范围值的获取
/// [Previously private]
ClassMethod GetMultiScope(ItemCode, LabNo, date) As %String
{
   
   ;先判断有没有临床条件?若有临床条件则不需要返回多范围了
   s ItemCode=$g(ItemCode),LabNo=$g(LabNo),date=$g(date)
   ;s conditions=""    ?????  Liuzf-20090422
   ;s conditions=$P($g(^TEPI(LabNo,0)),"\",17)  ???? Liuzf-20090422
   ;i conditions'="" q ""        ???? Liuzf-20090422
   s Scopy=""
   i '$l(date) s date=+$h
   i '$d(^TTAB("TC",ItemCode,4,date)) s date=$o(^TTAB("TC",ItemCode,4,date),-1)
   i $l(date) d
   .s num=1
   .s ord="" f  s ord=$o(^TTAB("TC",ItemCode,4,date,0,ord)) q:ord=""  d
   ..i $p(^TTAB("TC",ItemCode,4,date,0,ord),"\",21)'="" d
   ...s clc=$p(^TTAB("TC",ItemCode,4,date,0,ord),"\",21)
   ...s temL=$p(^TTAB("TC",ItemCode,4,date,0,ord),"\",1)
   ...s temH=$p(^TTAB("TC",ItemCode,4,date,0,ord),"\",2)
   ...i $l(temH) s temrange=^TTAB("CLC",clc)_"("_$j(temL,3,2)_"-"_$j(temH,3,2)_")"
   ...i '$l(temH) s temrange=^TTAB("CLC",clc)_"("_temL_")"
   ...;s temrange=^TTAB("CLC",clc)_"("_$j($p(^TTAB("TC",ItemCode,4,date,0,ord),"\",1),3,2)_"-"_$j($p(^TTAB("TC",ItemCode,4,date,0,ord),"\",2),3,2)_")"
   ...i (num#2)=0 d
   ....s Scopy=Scopy_temrange_$c(10,13)
   ...e  d
   ....s Scopy=Scopy_temrange_$c(32)
   ...s num=num+1
   q Scopy
}

/// 根据日期获取检验项目的单位 //$$Units^DHCCTTCU(TC,recdate) ;
/// [Previously private]
ClassMethod GetTCUnitByDate(tc, date) As %String
{
  ;table CT_TestCodePrevUnits
  s tc=$g(tc),date=$g(date)
  i '$l(tc) q ""
  i '$l(date) s date=+$h
  s date=date+1
  s last=$o(^TTAB("TC",tc,6,""),-1)
  q:($Data(^TTAB("TC",tc))'=1)&($Data(^TTAB("TC",tc))'=11) ""
  s unit=$p(^TTAB("TC",tc),"\",2)
  i date>last s last="" q unit
  i $d(^TTAB("TC",tc,6,date)) q $p(^TTAB("TC",tc,6,date),"\",1) 
  s last=date s last=$o(^TTAB("TC",tc,6,last)) ; q:(last<date)!(last="")
  ;i last="" s last=$o(^TTAB("TC",tc,6,""))
  q $p(^TTAB("TC",tc,6,last),"\",1)
}

/// 获取检验项目的描述，结果，单位，异常值，参考范围信息，英文缩写
/// [Previously private]
ClassMethod GetTestCodeResult(LabNo As %String, TC As %String, Result As %String) As %String
{
	New (LabNo,TC,Result)
	Set return=""
	Quit:TC="" return
	Quit:'$d(^TTAB("TC",TC)) return
	
	Set ItemName=$p(^TTAB("TC",TC),"\",1)        //项目名称
	Set ItemDate=$p(^TEPI(LabNo),"\",10)
	Set Synonym=$p(^TTAB("TC",TC),"\",12)        //英文缩写
	Set ItemUnits=..GetTCUnitByDate(TC,ItemDate) //项目单位
	Set ItemType=$p(^TTAB("TC",TC),"\",3)        //输出数据类型
	Set ItemResult=Result
	If ItemType="V" {         //微生物 Micro Pathogen||V
		If ItemResult'="" {
			set xItemResult=ItemResult
			set xItemResult=$ZCVT($g(xItemResult),"U")
			set xItemResult=$tr(xItemResult," ","")
			Set:$d(^TTAB("BUG",xItemResult)) ItemResult=$p($g(^TTAB("BUG",xItemResult)),"\",1)
		}
	}
	If ItemType["N" {         //??
		Set Decimal=$e(ItemType,2)
		Set:Decimal="" Decimal="0"
		Set ItemResult=$$CheckResDecimal(ItemResult,Decimal)
	}
	If ItemType["S" {         //Standard Comment标准意见
		If ItemResult'="" {
			Set:$d(^TTAB("TC",TC,2,ItemResult,1)) ItemResult=$p($g(^TTAB("TC",TC,2,ItemResult,1)),"\",1)
		}
	}
	If ItemType="B2" {        //血型结果
		If ItemResult'="" {
			Set:$d(^TTAB("BB-BG",ItemResult)) ItemResult=$p($g(^TTAB("BB-BG",ItemResult)),"\",1)
		}
	}
	
	Set ResFlag=..GetAbnorFlag(TC ,ItemResult)  //异常标志
	Set RefRanges=..GetTCRanges(TC)             //参考范围
	Set RefRanges=$tr(RefRanges,$C(1),"~")      //参考范围高低值之间用“~”分隔
	Set:'$l(RefRanges) RefRanges=..GetMultiScope(TC)
	Set $p(return,$c(2),1)=TC
	Set $p(return,$c(2),2)=ItemName
	Set $p(return,$c(2),3)=$tr(ItemResult,$c(13,10),"")
	Set $p(return,$c(2),4)=ItemUnits
	Set $p(return,$c(2),5)=ResFlag
	Set $p(return,$c(2),6)=RefRanges
	Set $p(return,$c(2),7)=Synonym
	Quit return
	
CheckResDecimal(res,dec)
	Set res=$Get(res),dec=+$Get(dec)
	Set ret=""
	If res="" Quit ret
	If dec="" Quit ret
	Set flag=""
	If ($Extract(res)="<")!($Extract(res)=">") s flag=$Extract(res),res=$TRanslate(res,"<>")
	Set res=+res
	Set ret=$fn(res,"",dec)
	Quit flag_ret
}

/// 获得检验项目的类别
/// [Previously private]
ClassMethod GetItemOrderType(ItemCatId As %String) As %String
{
	s OrderTypeStr=^ARC("IC",ItemCatId) Quit:OrderTypeStr="" ""
	s OrderType=$P(OrderTypeStr,"^",7)	Quit:OrderType="" ""
	Quit OrderType
}

/// 获得检验项目的名称
/// [Previously private]
ClassMethod GetLabItemNameDesc(ARCIMId As %String) As %String
{
	Quit:ARCIMId'["||" ""
	Set ItemId=$P(ARCIMId,"||",1) Quit:ItemId="" ""
	Set ItemSub=$P(ARCIMId,"||",2) Quit:ItemSub="" ""
	Set ItemCatId=$Piece(^ARCIM(ItemId,ItemSub,1),"^",10) Quit:ItemCatId="" ""
	Quit:..GetItemOrderType(ItemCatId)'="L" ""
	Set ItemDesc=$Piece(^ARCIM(ItemId,ItemSub,1),"^",2)
	Quit ItemDesc
}

/// 获得医嘱项目对应的检验医嘱关联代码TestSetCode
/// [Previously private]
ClassMethod GetExtTestSetCode(ARCIMId As %String) As %String
{
	Quit:ARCIMId'["||" ""
	Set ItemId=$P(ARCIMId,"||",1) Quit:ItemId="" ""
	Set ItemSub=$P(ARCIMId,"||",2) Quit:ItemSub="" ""
	Set:$Data(^ARCIM(ItemId,ItemSub,"EXT",1)) ItemExternalCodesStr=^ARCIM(ItemId,ItemSub,"EXT",1)
	Set TestSetCode=""
	Set:ItemExternalCodesStr'="" TestSetCode=$Piece(ItemExternalCodesStr,"^",4)
	Quit TestSetCode
}

/// 根据标本代码获取标本名称描述
/// [Previously private]
ClassMethod GetSpecimenDesc(SpecCode As %String) As %String
{
	S SpecDesc=""
	Q:'$l(SpecCode) SpecDesc
	S DataFlag=$D(^TTAB("SPEC",SpecCode))
	Q:(DataFlag'=1)&(DataFlag'=11) SpecDesc
	S SpeData=^TTAB("SPEC",SpecCode)
	S SpecDesc=$P(SpeData,"\",1)
	Q SpecDesc
}

/// Creator：     zhufei
/// CreatDate：   2012-11-02
/// Description:  通过医嘱项取检验结果异常的医嘱
/// Table：       
/// Input：       Input: "医嘱||860||血常规"
/// Return：      返回医嘱结果  ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.LisReport).GetRstAbnorOrder("")
ClassMethod GetRstAbnorOrder(argInput As %String) As %String
{
	New (argInput,%EpisodeID,%ExtraData,%ErrorData) //Modified  By LiYang 2012-11-21 取消%CurrentDate
	Set return=0,Count=0
	Quit:argInput="" return
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	//Set %CurrentDate=$g(%CurrentDate) //Modified  By LiYang 2012-11-21 取消%CurrentDate
	
	Set $ZT="GetRstAbnorOrderErr"
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
			Continue:(%CurrentDate'="")&&(SttDate'=%CurrentDate)
			Set SubID=0
			For {
				Set SubID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate,SubID))
				Quit:SubID=""
				
				Set LabAbnorRst=..GetRstAbnorOrderRst(OrderID_"||"_SubID)
				Continue:LabAbnorRst=""
				
				Set Count=Count+1
				Set StartDate=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",9)  //医嘱开始日期
				Set StartTime=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",10) //医嘱开始时间
				Set Doctor=$p($g(^OEORD(+OrderID,"I",SubID,1)),"^",11)   //开医嘱医生
				Set:StartDate'="" StartDate=$zd(StartDate,3)
				Set:StartTime'="" StartTime=$zt(StartTime,2)
				Set Doctor=$p($g(^CTPCP(+Doctor,1)),"^",2)
				
				//add by zf 2014-01-24 发生日期和发生时间
				Set OccurDate=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",9)  //医嘱开始日期
				Set OccurTime=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",10) //医嘱开始时间
				
				Set OeordItemRst=ArcimName_"["_LabAbnorRst_"]"	//_" "_StartDate_" "_StartTime_" "_Doctor update by liuyh 2013-02-27
				Set OeordItemRst=$$BuildRstAbnorOrder(OeordItemRst)
				Set %ExtraData=%ExtraData_$lb(OeordItemRst)
			}
		}
	}
	
	Set return=Count
	Quit return
	
GetRstAbnorOrderErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
	
BuildRstAbnorOrder(arg0)
	Set tmpDesc=arg0
	//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
	Set objUser=##class(DHCMed.Base.SSUser).GetByCTPCP(+$p($g(^OEORD(+OrderID,"I",SubID,1)),"^",11))
	Set:$IsObject(objUser)=0 objUser=##class(DHCMed.Base.SSUser).%New()
	Do objUser.%Close()
	Set tmp=""
	Set $p(tmp,$c(3),1)=tmpDesc
	Set $p(tmp,$c(3),2)=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",9)
	Set $p(tmp,$c(3),3)=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",10)
	Set $p(tmp,$c(3),4)=tmpDesc
	Set $p(tmp,$c(3),5)=OrderID_"||"_SubID
	Set $p(tmp,$c(3),6)=+objUser.Rowid
	
	//update by lyh 2012-11-28 拼凑检验表达式
	Set PatientID=$p($g(^PAADM(%EpisodeID)),"^",1)
	Set OEItemID=OrderID_"||"_SubID
	Set objOEItem=##class(DHCMed.Base.OrdItem).GetObjById(OEItemID)	 	
	Set LabTestSetRow=objOEItem.OEORILabEpisodeNo
	Set $p(tmp,$c(3),7)="PatientBanner=1&PatientID="_PatientID_"&TestSetRow="_LabTestSetRow_"&OrderID="_OEItemID
	
	Set $p(tmp,$c(3),8)=OccurDate
	Set $p(tmp,$c(3),9)=OccurTime
	
	//Set $p(tmp,$c(3),7)="argInput"_argInput
	Quit tmp
}

/// 判断医嘱检验结果是否异常
/// w ##Class(DHCMed.CCService.Lib.LisReport).GetRstAbnorOrderRst()
ClassMethod GetRstAbnorOrderRst(aOEItemID As %String) As %String
{
	New (aOEItemID)
	Set return=""
	Quit:aOEItemID="" return
	
	Set LabTestSetRow=$p($g(^OEORD(+aOEItemID,"I",+$p(aOEItemID,"||",2),3)),"^",35)
	Set VisitNumber=$p(LabTestSetRow,"||",1)
	Set TestSet=$p(LabTestSetRow,"||",2)
	Set TestSetCount=$p(LabTestSetRow,"||",3)
	Quit:(VisitNumber="")||(TestSet="")||(TestSetCount="") return
	
	Set TestCode=""
	For {
		Set TestCode=$o(^TEPI(VisitNumber,1,TestSet,TestSetCount,"DATA",TestCode))
		Quit:TestCode=""
		
		Set tmpResult=$g(^TEPI(VisitNumber,1,TestSet,TestSetCount,"DATA",TestCode))
		Set tmpResult=$p(tmpResult,"\",1)
		Set LabResult=..GetTestCodeResult(VisitNumber,TestCode,tmpResult)
		Set ItemDesc=$p(LabResult,$c(2),2)    //检验项目描述
		Set ItemResult=$p(LabResult,$c(2),3)  //结果
		Set ItemUnit=$p(LabResult,$c(2),4)    //检验项目的单位
		Set AbnorFlag=$p(LabResult,$c(2),5)   //异常标记
		Continue:AbnorFlag=""
		Continue:AbnorFlag["N"
		
		Set return=return_ItemDesc_":{"_ItemResult_":"_AbnorFlag_"};"
	}
	
	Quit return
}

}
