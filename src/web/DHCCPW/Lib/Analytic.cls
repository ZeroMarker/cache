/// 名称: web.DHCCPW.Lib.Analytic
/// 描述: 表达式解析
/// 编写者：zhufei
/// 编写日期: 2012-02-16
Class web.DHCCPW.Lib.Analytic Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(web.DHCCPW.Lib.Analytic).Test()
ClassMethod Test()
{
	New
	
	/*
	//测试关联项目检查方法
	Set %EpisodeID="71858"
	Set %StartDate=""
	Set %StartTime=""
	Set %EndDate=""
	Set %EndTime=""
	Set %ZIndex=$zn
	Set %JIndex=$j
	Set %NIndex="AAAAA"
	
	Set return=..MainToLnkItm(7)
	Set RtnCode=$list(return,1)
	Write "RtnCode="_RtnCode,!
	If RtnCode=-999 {
		Write "ErrorCode="_$list(return,2),!
	} Else {
		Set TitleList=$list(return,2)
		For indTitle=1:1:$listlength(TitleList)
		{
			Set tmpTitle=$list(TitleList,indTitle)
			Write $list(tmpTitle,1)_" "_$list(tmpTitle,2)_" "_$zd($list(tmpTitle,3),3)_" "_$zt($list(tmpTitle,4),1),!
		}
	}
	
	//测试关联医嘱检查方法
	Set %EpisodeID="148"
	Set %StartDate=$zdh("2012-04-09",3)
	Set %StartTime=0
	Set %EndDate=$zdh("2012-04-19",3)
	Set %EndTime=0
	Set return=..MainToArcim("1262||1")
	Set RtnCode=$list(return,1)
	Write "RtnCode="_RtnCode,!
	If RtnCode=-999 {
		Write "ErrorCode="_$list(return,2),!
	} Else {
		Set TitleList=$list(return,2)
		For indTitle=1:1:$listlength(TitleList)
		{
			Set tmpTitle=$list(TitleList,indTitle)
			Write $list(tmpTitle,1)_" "_$list(tmpTitle,2)_" "_$zd($list(tmpTitle,3),3)_" "_$zt($list(tmpTitle,4),1),!
		}
	}
	*/
	
	//测试关联项目检查方法
	Set %EpisodeID="3837636"
	Set %StartDate=""
	Set %StartTime=""
	Set %EndDate=""
	Set %EndTime=""
	Set %ZIndex=$zn
	Set %JIndex=$j
	Set %NIndex="AAAAA"
	
	Set return=..MainToLnkItm(15)
	Set RtnCode=$list(return,1)
	Write "RtnCode="_RtnCode,!
	If RtnCode=-999 {
		Write "ErrorCode="_$list(return,2),!
	} Else {
		Set TitleList=$list(return,2)
		For indTitle=1:1:$listlength(TitleList)
		{
			Set tmpTitle=$list(TitleList,indTitle)
			Write $list(tmpTitle,1)_" "_$list(tmpTitle,2)_" "_$zd($list(tmpTitle,3),3)_" "_$zt($list(tmpTitle,4),1),!
		}
	}
	Set return=..MainToLnkItm(16)
	Set RtnCode=$list(return,1)
	Write "RtnCode="_RtnCode,!
	If RtnCode=-999 {
		Write "ErrorCode="_$list(return,2),!
	} Else {
		Set TitleList=$list(return,2)
		For indTitle=1:1:$listlength(TitleList)
		{
			Set tmpTitle=$list(TitleList,indTitle)
			Write $list(tmpTitle,1)_" "_$list(tmpTitle,2)_" "_$zd($list(tmpTitle,3),3)_" "_$zt($list(tmpTitle,4),1),!
		}
	}
	Set return=..MainToLnkItm(17)
	Set RtnCode=$list(return,1)
	Write "RtnCode="_RtnCode,!
	If RtnCode=-999 {
		Write "ErrorCode="_$list(return,2),!
	} Else {
		Set TitleList=$list(return,2)
		For indTitle=1:1:$listlength(TitleList)
		{
			Set tmpTitle=$list(TitleList,indTitle)
			Write $list(tmpTitle,1)_" "_$list(tmpTitle,2)_" "_$zd($list(tmpTitle,3),3)_" "_$zt($list(tmpTitle,4),1),!
		}
	}
	
	Quit "Over"
}

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  关联医嘱表达式解析主题程序
/// Table：       
/// Input：       ArcimID: 关联医嘱ID
/// Return：      返回检查结果  $lb(Count,$lb($lb(Desc,Date,Time),...))
/// w ##class(web.DHCCPW.Lib.Analytic).MainToArcim("1||1")
ClassMethod MainToArcim(argArcimID As %String) As %String
{
	New (argArcimID,%EpisodeID,%StartDate,%StartTime,%EndDate,%EndTime)
	Set return=$lb(0,"")
	Quit:(argArcimID="")||(%EpisodeID="") return
	Quit:(%StartDate="")||(%StartTime="")||(%EndDate="")||(%EndTime="") return
	
	Set $ZT="MainToArcimErr"
	
	Set StDtTmIndex=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("OEOrdItemStDtTmIndex")
	Set:StDtTmIndex="" StDtTmIndex="StDtTm1"
	
	Set Count=0,ArcimList=""
	If StDtTmIndex="YYGL" {  //航天中心医院
		Set ZYH=##Class(web.DHCCPW.MR.InterfaceToPrj).ChangeAdmToIPNo(%EpisodeID)
		Quit:ZYH="" return
		Set YZDM=""
		For {
			Set YZDM=$o(^DHCMR("OEOrdExec",ZYH,YZDM))
			Quit:YZDM=""
			
			//医嘱项代码转换为医嘱项ID
			//update by zf 20120628
			Set ArcimID="",ArcSub="",ArcVer=""
			Set ArcSub=$o(^ARCIM(0,"Code",YZDM,""))
			Set:ArcSub'="" ArcVer=$o(^ARCIM(0,"Code",YZDM,ArcSub,""))
			If (ArcSub'="")&&(ArcVer'="") {
				Set ArcimID=ArcSub_"||"_ArcVer
			}
			Continue:argArcimID'=ArcimID
			
			Set YZXH=0
			For {
				Set YZXH=$o(^DHCMR("OEOrdExec",ZYH,YZDM,YZXH))
				Quit:YZXH=""
				
				Set tmpData=$g(^DHCMR("OEOrdExec",ZYH,YZDM,YZXH,"OEOrdItem"))
				Continue:tmpData=""
				Set OEItemID=YZXH
				Set ArcimDesc=$listget(tmpData,6)         //医嘱名称
				Set OEItemDateTime=$listget(tmpData,12)   //开始日期时间
				Set OEItemDate=$p(OEItemDateTime," ",1)
				Set OEItemTime=$p(OEItemDateTime," ",2)
				Set OEItemDoc=$listget(tmpData,16)        //YSXM 医生姓名
				
				Set ExecType=$g(^DHCMR("OEOrdExec",ZYH,YZDM,YZXH,"ExecType"))
				If ExecType=1 {  //持续医嘱
					Set StartDate=$o(^DHCMR("OEOrdExec",ZYH,YZDM,YZXH,"ExStDate",0))
					Continue:StartDate=""
					Set StartTime=$o(^DHCMR("OEOrdExec",ZYH,YZDM,YZXH,"ExStDate",StartDate,0))
					Set EndDate=$o(^DHCMR("OEOrdExec",ZYH,YZDM,YZXH,"ExStDate",StartDate))
					If EndDate="" {
						Set EndDate=+$h,EndTime=$p($h,",",2)
					} Else {
						Set EndTime=$o(^DHCMR("OEOrdExec",ZYH,YZDM,YZXH,"ExStDate",EndDate,0))
					}
					
					Continue:EndDate<%StartDate
					Continue:(EndDate=%StartDate)&&(EndTime<%StartTime)
					Continue:StartDate>%EndDate
					Continue:(StartDate=%EndDate)&&(StartTime>%EndTime)
					
					Set Count=Count+1
					Set OEExecID=OEItemID_"||"_StartDate_"||"_StartTime
					Set ArcimList=ArcimList_$lb($lb("OEItemID:"_OEExecID,ArcimDesc,StartDate,StartTime))
				} Else {  //非持续医嘱
					Set xDate=%StartDate-1
					For {
						Set xDate=$o(^DHCMR("OEOrdExec",ZYH,YZDM,YZXH,"ExStDate",xDate))
						Quit:xDate=""
						Quit:xDate>%EndDate
						
						Set xTime=$s(xDate=%StartDate:%StartTime,1:0)
						For {
							Set xTime=$o(^DHCMR("OEOrdExec",ZYH,YZDM,YZXH,"ExStDate",xDate,xTime))
							Quit:xTime=""
							Quit:(xDate=%EndDate)&&(xTime>%EndTime)
							
							Set Count=Count+1
							Set OEExecID=OEItemID_"||"_xDate_"||"_xTime
							Set ArcimList=ArcimList_$lb($lb("OEItemID:"_OEExecID,ArcimDesc,xDate,xTime))
						}
					}
				}
			}
		}
	} ElseIf StDtTmIndex="StDtTmNew" {  //新版本医嘱,医嘱无效通过OE_OrdItem表状态和OE_OrdExec状态判断
		Set ArcimDesc=$p($g(^ARCIM(+argArcimID,+$p(argArcimID,"||",2),1)),"^",2)
		Set xOEItemID=""
		For {
			Set xOEItemID=$o(^DHCMR("OEOrdExec",%EpisodeID,argArcimID,xOEItemID))
			Quit:xOEItemID=""
			
			Set OeoriStatus=""
			Set OeoriStatusID=$p($g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),1)),"^",13)
			Set:OeoriStatusID'="" OeoriStatus=$p($g(^OEC("OSTAT",OeoriStatusID)),"^",1)
			Continue:OeoriStatus=""
			Continue:OeoriStatus["C"  //医嘱状态  撤销
			Continue:OeoriStatus["U"  //医嘱状态  作废
			Continue:OeoriStatus["I"  //医嘱状态  未审核
			
			//取持续医嘱的停止时间,未停取当前时间
			Set OEXDate=$p($g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),3)),"^",34)
			Set OEXTime=+$p($g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),2)),"^",15)
			Set:OEXDate="" OEXDate=+$h,OEXTime=$p($h,",",2)
			
			Set ExecType=$g(^DHCMR("OEOrdExec",%EpisodeID,argArcimID,xOEItemID,"ExecType"))
			
			Set xDate=%StartDate-1
			For {
				Set xDate=$o(^DHCMR("OEOrdExec",%EpisodeID,argArcimID,xOEItemID,"ExStDate",xDate))
				Quit:xDate=""
				Quit:xDate>%EndDate
				
				If ExecType=1 {  //持续医嘱
					Set xTime=0
				} Else {  //非持续医嘱
					Set xTime=$s(xDate=%StartDate:%StartTime,1:0)
				}
				Set xTime=xTime-1
				For {
					Set xTime=$o(^DHCMR("OEOrdExec",%EpisodeID,argArcimID,xOEItemID,"ExStDate",xDate,xTime))
					Quit:xTime=""
					Quit:(xDate=%EndDate)&&(xTime>%EndTime)
					
					Set OEExecID=$o(^DHCMR("OEOrdExec",%EpisodeID,argArcimID,xOEItemID,"ExStDate",xDate,xTime,""))
					Continue:OEExecID=""
					
					Set OeAdmStatus=""
					If $p(OEExecID,"||",3)'=""  //存在执行记录
					{
						Set OeAdmStatusID=$p($g(^OEORD(+OEExecID,"I",$p(OEExecID,"||",2),"X",$p(OEExecID,"||",3))),"^",16)
						Set:OeAdmStatusID'="" OeAdmStatus=$p($g(^OEC("STAT",OeAdmStatusID)),"^",1)
						Continue:OeAdmStatus="D"  //医嘱执行状态  停止执行
						Continue:OeAdmStatus="C"  //医嘱执行状态  撤销执行
						Continue:OeAdmStatus="R"  //医嘱执行状态  拒绝执行
					}
					//Continue:OeAdmStatus=""
					
					If ExecType=1 {  //持续医嘱
						//取当前执行记录的停止日期和时间
						Set OEExecXDate=xDate
						If OEXDate>xDate {
							Set OEExecXTime=$zth("23:59:59",1)
						} ElseIf OEXDate=xDate {
							Set OEExecXTime=xTime
						} Else {    //停止日期小于执行记录日期,执行记录无效
							Continue
						}
						//停止时间小于开始时间,退出
						Continue:OEExecXDate<%StartDate
						Continue:(OEExecXDate=%StartDate)&&(OEExecXTime<%StartTime)
					} Else {
						Continue:xDate>OEXDate
						Continue:(xDate=OEXDate)&&(xTime>OEXTime)
					}
					
					Set Count=Count+1
					Set ArcimList=ArcimList_$lb($lb("OEItemID:"_OEExecID,ArcimDesc,xDate,xTime))
				}
			}
		}
	} Else {   //旧版本医嘱,医嘱无效通过OE_OrdItem表状态判断
		If $l(argArcimID,"||")=2 {
			Set xArcimID=argArcimID
			Do OldOEOrderImpl
		}Else{
			//^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item)
			Set ARCOSRowid=argArcimID
			Quit:$g(^ARCOS(+ARCOSRowid))="" return  //无此医嘱套
			//取医嘱套的日期节点
			Set ARCOSDateID=0
			For {
				Set ARCOSDateID=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateID))
				Quit:ARCOSDateID=""
				//判断医嘱套下的医嘱项
				Set ARCOSItemID=0
				For {
					Set ARCOSItemID=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateID,"ITM",ARCOSItemID))
					Quit:ARCOSItemID=""
					Set ARCOSARCIMID=$p($g(^ARCOS(ARCOSRowid,"DATE",ARCOSDateID,"ITM",ARCOSItemID)),"^",1)
					Continue:$g(^ARCIM(+ARCOSARCIMID,$p(ARCOSARCIMID,"||",2),1))=""  //无此医嘱
					//w "ARCOSARCIMID="_ARCOSARCIMID,!
					Set xArcimID=ARCOSARCIMID
					Do OldOEOrderImpl
				}
				//医嘱套下的医嘱子套
				Set ARCOSOSID=0
				For {
					Set ARCOSOSID=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateID,"OS",ARCOSOSID))
					Quit:ARCOSOSID=""
					Set ARCOSSubID=$p($g(^ARCOS(ARCOSRowid,"DATE",ARCOSDateID,"OS",ARCOSOSID)),"^",1)
					//取医嘱子套的日期节点
					Set ARCOSSubDateID=0
					For {
						Set ARCOSSubDateID=$o(^ARCOS(ARCOSSubID,"DATE",ARCOSSubDateID))
						Quit:ARCOSSubDateID=""
						//取医嘱子套的医嘱项
						Set ARCOSSubItemID=0
						For {
							Set ARCOSSubItemID=$o(^ARCOS(ARCOSSubID,"DATE",ARCOSSubDateID,"ITM",ARCOSSubItemID))
							Quit:ARCOSSubItemID=""
							Set ARCOSSubARCIMID=$p($g(^ARCOS(ARCOSSubID,"DATE",ARCOSSubDateID,"ITM",ARCOSSubItemID)),"^",1)
							Continue:$g(^ARCIM(+ARCOSSubARCIMID,$p(ARCOSSubARCIMID,"||",2),1))=""  //无此医嘱
							//w "ARCOSSubARCIMID="_ARCOSSubARCIMID,!
							Set xArcimID=ARCOSSubARCIMID
							Do OldOEOrderImpl
						}
					}
				}
			}
		}
	}
	
	Set return=$lb(Count,ArcimList)
	Quit return
	
MainToArcimErr
	Set return=$lb(-999,$ZERROR)
	Quit return
	
OldOEOrderImpl
	Set ArcimDesc=$p($g(^ARCIM(+xArcimID,+$p(xArcimID,"||",2),1)),"^",2)
	//w "ArcimID="_xArcimID_",ArcimDesc="_ArcimDesc,!
	Set xOEItemID=""
	For {
		Set xOEItemID=$o(^DHCMR("OEOrdExec",%EpisodeID,xArcimID,xOEItemID))
		Quit:xOEItemID=""
		
		Set OeoriStatus=""
		Set OeoriStatusID=$p($g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),1)),"^",13)
		Set:OeoriStatusID'="" OeoriStatus=$p($g(^OEC("OSTAT",OeoriStatusID)),"^",1)
		Continue:OeoriStatus=""
		//Continue:OeoriStatus["D"  //医嘱状态  停止
		Continue:OeoriStatus["I"  //医嘱状态  未审核
		
		//取持续医嘱的停止时间,未停取当前时间
		Set OEXDate=$p($g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),3)),"^",34)
		Set OEXTime=+$p($g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),2)),"^",15)
		Set:OEXDate="" OEXDate=+$h,OEXTime=$p($h,",",2)
		
		Set ExecType=$g(^DHCMR("OEOrdExec",%EpisodeID,xArcimID,xOEItemID,"ExecType"))
		
		Set xDate=%StartDate-1
		For {
			Set xDate=$o(^DHCMR("OEOrdExec",%EpisodeID,xArcimID,xOEItemID,"ExStDate",xDate))
			Quit:xDate=""
			Quit:xDate>%EndDate
			
			If ExecType=1 {  //持续医嘱
				Set xTime=0
			} Else {  //非持续医嘱
				Set xTime=$s(xDate=%StartDate:%StartTime,1:0)
			}
			
			Set xTime=xTime-1
			For {
				Set xTime=$o(^DHCMR("OEOrdExec",%EpisodeID,xArcimID,xOEItemID,"ExStDate",xDate,xTime))
				Quit:xTime=""
				Quit:(xDate=%EndDate)&&(xTime>%EndTime)
				
				Set OEExecID=$o(^DHCMR("OEOrdExec",%EpisodeID,xArcimID,xOEItemID,"ExStDate",xDate,xTime,""))
				Continue:OEExecID=""
				
				If ExecType=1 {  //持续医嘱
					//取当前执行记录的停止日期和时间
					Set OEExecXDate=xDate
					If OEXDate>xDate {
						Set OEExecXTime=$zth("23:59:59",1)
					} ElseIf OEXDate=xDate {
						Set OEExecXTime=xTime
					} Else {    //停止日期小于执行记录日期,执行记录无效
						Continue
					}
					//停止时间小于开始时间,退出
					Continue:OEExecXDate<%StartDate
					Continue:(OEExecXDate=%StartDate)&&(OEExecXTime<%StartTime)
				} Else {
					Continue:xDate>OEXDate
					Continue:(xDate=OEXDate)&&(xTime>OEXTime)
				}
				
				Set Count=Count+1
				Set ArcimList=ArcimList_$lb($lb("OEItemID:"_OEExecID,ArcimDesc,xDate,xTime))
			}
		}
	}
	Quit
}

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  关联项目表达式解析主题程序
/// Table：       
/// Input：       ItemID: 关联项目ID
/// Return：      返回检查结果  $lb(Count,$lb($lb(Desc,Date,Time),...))
/// w ##class(web.DHCCPW.Lib.Analytic).MainToLnkItm(1)
ClassMethod MainToLnkItm(argItemID As %String) As %String
{
	New (argItemID,%EpisodeID,%StartDate,%StartTime,%EndDate,%EndTime,%ZIndex,%JIndex,%NIndex)
	Set return=$lb(0,"")
	Quit:argItemID="" return
	Quit:(%ZIndex="")||(%JIndex="")||(%ZIndex="")||(%EpisodeID="") return
	
	Set $ZT="MainToLnkItmErr"
	Set Expression=$g(^TMP(%ZIndex,%JIndex,%NIndex,"DHCCPWExpList",argItemID))
	If Expression="" {
		Set objItem=##class(User.DHCMRCBaseLinkItemDic).GetObjById(argItemID)
		If $IsObject(objItem)
		{
			Set Expression=objItem.BLIDExpression
			Set Expression=..changeExpression(Expression)
			Set ^TMP(%ZIndex,%JIndex,%NIndex,"DHCCPWExpList",argItemID)=Expression
		}
	}
	Quit:Expression="" return
	Set exp="Set return=("_Expression_")"
	Xecute exp
	
	Quit return
	
MainToLnkItmErr
	Set return=$lb(-999,$ZERROR)
	Quit return
}

/// w ##Class(web.DHCCPW.Lib.Analytic).changeExpression(exp)
ClassMethod changeExpression(argExp As %String) As %String
{
	New (argExp)
	Set return=""
	Quit:argExp="" return
	
	Set $ZT="changeExpressionErr"
	Set (strLeft,strCenter,strRight)=""
	Set strRight=argExp
	For ind=1:1:$l(argExp,"#")-1
	{
		Set strLeft=$p(strRight,"#",1)
		Set strRight=$e(strRight,$l(strLeft)+2,$l(strRight))
		Set strCenter=$p(strRight,"(",1)
		//w "strLeft1="_strLeft,!
		//w "strCenter1="_strCenter,!
		//w "strRight1="_strRight,!!
		If ($l(strCenter,".")=2)&&(..checkMethod(strCenter)>0) {
			Set strClassMethod=..getClassMethod(strCenter)  //如:  A.B( --> ##AAA.BBB()
			//w "strClassMethod="_strClassMethod,!
			Set strClassMethod=$p(strClassMethod,"(",1)_"("_$p(strClassMethod,"(",2)_"("
			If strClassMethod="" {
				Set strLeft=strLeft_"#"
			}Else{
				Set strLeft=strLeft_strClassMethod
				Set strRight=$e(strRight,$l(strCenter)+2,$l(strRight))
			}
		}Else{
			Set strLeft=strLeft_"#"
		}
		Set return=return_strLeft
		//w "strLeft2="_strLeft,!
		//w "strCenter2="_strCenter,!
		//w "strRight2="_strRight,!!
	}
	Set return=return_strRight
	Set return=..ReplaceString(return,".and.","&&")
	Set return=..ReplaceString(return,".or.","||")
	Set return=..ReplaceString(return,".not","!")
	Set return=..ReplaceString(return,"[","""")
	Set return=..ReplaceString(return,"]","""")
	
	Quit return
	
changeExpressionErr
	Write "Error:"_$ZERROR,!
	Quit ""
}

ClassMethod checkMethod(argMethod As %String) As %String
{
	New (argMethod)
	Set return=1
	Quit:argMethod="" return
	For i=1:1:$l(argMethod)
	{
		Set tmp=$e(argMethod,i,i)
		Continue:tmp="."
		Set tmpASCII=$ASCII(tmp)
		If ((tmpASCII<48)||((tmpASCII>57)&&(tmpASCII<65))||((tmpASCII>90)&&(tmpASCII<97))||(tmpASCII>122)){
			Set return=-1
			Quit
		}
	}
	Quit return
}

ClassMethod getClassMethod(argMethod As %String) As %String
{
	New (argMethod)
	Set return=""
	Quit:argMethod="" return
	
	Set className=$p(argMethod,".",1)
	Set methodName=$p(argMethod,".",2)
	Set className=$ZCVT(className,"U")
	Set methodName=$ZCVT(methodName,"U")
	Quit:(className="")||(methodName="") return
	
	Set objPackage=##class(User.DHCMRCBaseLinkMethodPackage).GetPackageByName(className)
	Quit:'$IsObject(objPackage) return
	Set PackageID=objPackage.%Id()
	Set objMethod=##class(User.DHCMRCBaseLinkMethodDic).GetMethodDicByName(PackageID,methodName)
	Quit:'$IsObject(objMethod) return
	
	Set return=objMethod.BLMDClassMethod
	Quit return
}

ClassMethod ReplaceString(Str, OldStr, NewStr)
{
	n (Str, OldStr, NewStr)
	set intCounter = 1
	while (1)
	{
		set tmp =$e(Str, intCounter, intCounter + $l(OldStr) - 1) 
		if (tmp = OldStr)
		{
			 set $e(Str, intCounter, intCounter + $l(OldStr) - 1) = NewStr
			 set intCounter = intCounter + $l(NewStr) - $l(OldStr)
		}
		quit:intCounter>=$l(Str)
		set intCounter = intCounter + 1
	}
	quit Str
}

}
