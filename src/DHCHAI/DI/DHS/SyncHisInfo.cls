/// 名称: DHCHAI.DI.DHS.SyncHisInfo
/// 描述: 同步东华就诊数据
/// 编写者：liyi
/// 编写日期: 2017-07-04
Class DHCHAI.DI.DHS.SyncHisInfo Extends (%RegisteredObject, DHCHAI.Abstract, User.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2017-03-23
/// Description:  根据日期同步东华HIS患者信息
/// Input：       aDateTo：结束日期
/// 			  aDateFrom : 开始日期
/// 			  aHospCode：医院代码
/// Return：      处理就诊数量
/// w ##class(DHCHAI.DI.DHS.SyncHisInfo).SyncAdmByDate("HIS01","2018-03-01","2018-04-09","")
ClassMethod SyncAdmByDate(aSCode As %String, aDateFrom As %String, aDateTo As %String, aHospCode As %String = "", aLocID As %String = "") As %String
{
	New (aSCode,aDateFrom,aDateTo,aHospCode,aLocID)
	Set return="",Count=0
	Quit:aSCode="" return
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="HIS" return  //HIS系统
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	//出院患者
	Set DischDateIndex=##class(DHCHAI.IO.FromAdmSrv).GetDischDateIndex()  //取出院时间索引
	For xDate=aDateFrom:1:aDateTo {
		Set xEpisodeID=0
		For {
			Set xEpisodeID=$o(^PAADMi(DischDateIndex,xDate,xEpisodeID))
			Quit:xEpisodeID=""
			
			Set AdmStr = $g(^PAADM(+xEpisodeID))
			Set AdmLoc	= $p(AdmStr,"^",4)
			Continue:(aLocID'="")&&(AdmLoc'=aLocID)   
	
			Set ret = ..SyncAdmByEpisodeID(aSCode,xEpisodeID,aHospCode)		//就诊信息+病人信息
			Continue:ret<1
			Set Count = Count+1
		}
	}
	//在院患者
	Set xWardID=""
	For {
		Set xWardID=$o(^PAADMi("CurrWard",xWardID))
		Quit:xWardID=""
		
		Set xRoomID=""
		For {
			Set xRoomID=$o(^PAADMi("CurrWard",xWardID,xRoomID))
			Quit:xRoomID=""
			
			Set xEpisodeID=""
			For {
				Set xEpisodeID=$o(^PAADMi("CurrWard",xWardID,xRoomID,xEpisodeID))
				Quit:xEpisodeID=""
				
				Set AdmStr = $g(^PAADM(+xEpisodeID))
				Set AdmLoc	= $p(AdmStr,"^",4)
				Continue:(aLocID'="")&&(AdmLoc'=aLocID)   
			
				Set ret = ..SyncAdmByEpisodeID(aSCode,xEpisodeID,aHospCode)		//就诊信息+病人信息
				Continue:ret<1
				Set Count = Count+1
			}
		}
	}
	Set return=Count
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-03-23
/// Description:  根据EpisodeID同步病人基本信息、就诊信息
/// Table：       DHCHAI.DP.PAAdm
/// Input：       aEpisodeID : 东华HIS就诊ID
/// 			  aHospCode：医院代码
/// Return：      返回DHCHAI.DP.PAAdm.%Id
/// w ##class(DHCHAI.DI.DHS.SyncHisInfo).SyncAdmByEpisodeID("HIS01","26")
ClassMethod SyncAdmByEpisodeID(aSCode As %String, aEpisodeID As %String, aHospCode As %String = "") As %String
{
	New (aSCode,aEpisodeID,aHospCode)
	Set return=0
	Quit:(aSCode="")||(aEpisodeID="") return
	
	Set AdmInfo = ##Class(DHCHAI.DI.DIO.FromHisSrv).GetAdmInfo(aEpisodeID)
	Quit:AdmInfo="" return
	Set HospCode = $p(AdmInfo,"^",34)
	Quit:(aHospCode'="")&&(aHospCode'=HospCode) return	//过滤非本医院
	
	Set EpisodeIDX=aSCode_"||"_aEpisodeID
	Set AdmLoc   = $p(AdmInfo,"^",21)
	Set AdmWard  = $p(AdmInfo,"^",22)
	Set AdmBed   = $p(AdmInfo,"^",24)
	Set DischLoc = $p(AdmInfo,"^",27)
	Set DischWard= $p(AdmInfo,"^",28)
	Set (AdmLocDr,AdmWardDr,AdmBedDr,DischLocDr,DischWardDr)=""
	Set objAdmLoc = ##class(DHCHAI.BT.Location).GetObjByXCode(aSCode,AdmLoc)
	Set objAdmWard = ##class(DHCHAI.BT.Location).GetObjByXCode(aSCode,AdmWard)
	Set objDischLoc = ##class(DHCHAI.BT.Location).GetObjByXCode(aSCode,DischLoc)
	Set objDischWard = ##class(DHCHAI.BT.Location).GetObjByXCode(aSCode,DischWard)
	if $isobject(objAdmLoc) {
		Set AdmLocDr=objAdmLoc.%Id()
	}else{
		Set:AdmLoc'="" AdmLocDr=..SyncLocationByID(aSCode,AdmLoc)
	}
	if $isobject(objAdmWard) {
		Set AdmWardDr=objAdmWard.%Id()
	}else{
		Set:AdmWard'="" AdmWardDr=..SyncLocationByID(aSCode,AdmWard)
	}
	if $isobject(objDischLoc) {
		Set DischLocDr=objDischLoc.%Id()
	}else{
		Set:DischLoc'="" DischLocDr=..SyncLocationByID(aSCode,DischLoc)
	}
	if $isobject(objDischWard) {
		Set DischWardDr=objDischWard.%Id()
	}else{
		Set:DischWard'="" DischWardDr=..SyncLocationByID(aSCode,DischWard)
	}
	
	Set objAdmBed = ##class(DHCHAI.BT.PACBed).GetObjByXCode(AdmLocDr,AdmBed)
	if $isobject(objAdmBed) {
		Set AdmBedDr=objAdmBed.%Id()
	}else{
		Set:AdmBed'="" AdmBedDr=..SyncPACBedByID(aSCode,AdmBed)
	}
	
	Set EpisodeDr=""
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(EpisodeIDX)
	If $IsObject(objAdm){
		Set EpisodeDr=objAdm.%Id()
	}
	
	//就诊类型个性化处理
	Set AdmType=$p(AdmInfo,"^",17)
	Set AdmType=##class(DHCHAI.CUS.ToSyncHisInfo).GetAdmType(AdmType,AdmLocDr)
	Set:AdmType="" AdmType=$p(AdmInfo,"^",17) //如果取值为空，还原原来的值
	
	Set IsNewBaby=$p(AdmInfo,"^",30)
	Set BirthWeight=$p(AdmInfo,"^",31)
	Set AdmitWeight=$p(AdmInfo,"^",32)
	Set BirthDay=$p(AdmInfo,"^",8) 
	Set AdmDate=$p(AdmInfo,"^",19)
	
    Set XLocDr="",IsNICU=0
    Set objBed=##class(DHCHAI.BT.PACBed).GetObjById(AdmBedDr)
    If $Isobject(objBed) {
	    Set XLocDr=objBed.BTXLocDr.%Id() 	//包括虚拟病区
	    Set objXLoc=##class(DHCHAI.BT.Location).GetObjById(XLocDr)
	    If $Isobject(objXLoc) {
		    Set IsNICU=objXLoc.BTIsNICU
	    }
    }
    
    Set NewBabyFlag=##class(DHCHAI.BT.Config).GetValByCode("NewBabyFlag") //判断是否新生儿参数 空/1：入院年龄，2：就诊科室
    If (NewBabyFlag'="")&&(NewBabyFlag'=1) { 
		Set:IsNICU=1 IsNewBaby=1
    }Else {
	    If BirthDay'=""{
			Set:(AdmDate-BirthDay<=28) IsNewBaby=1	//新生儿：出生28天以内
		}
    } 
	Set Apgar=""
    If IsNewBaby=1{
		set AdmitWeight=##class(DHCHAI.IO.FromHisSrv).GetFirstItemValue(aEpisodeID,"")
		set:AdmitWeight'="" AdmitWeight=AdmitWeight*1000
		set:AdmitWeight'="" AdmitWeight=AdmitWeight_"g"
		Set Apgar=##class(DHCHAI.DI.DIO.FromNisSrv).GetApgarByAdm(aEpisodeID)    //新生儿阿普加评分
	}
	
	//特殊处理住院病人住院天数取值
	//处理bug555426：新院感4.0—疑似病例筛查-在院-住院病人人数统计不正确
	Set VisitStatus=$p(AdmInfo,"^",18)
	If (AdmType="I")&(VisitStatus="A") {
		Set AdmDays=-1
	} Else {
		Set AdmDays=$p(AdmInfo,"^",29)
	}
	
	//add 2020-03-12判断患者是否离床超过一日
	Set DischDate = $p(AdmInfo,"^",25)
	Set DischTime = $p(AdmInfo,"^",26) 
	Set OutBedInfo= ##class(DHCHAI.IO.FromHisSrv).GetPatOutBedFlag(aEpisodeID)
	Set OutBedFlag=$p(OutBedInfo,"^",1)
	Set OutbedDate=$p(OutBedInfo,"^",2)
	Set OutbedTime=$p(OutBedInfo,"^",3)	
	
	If (EpisodeDr'="")&&(VisitStatus="A") {    //当前就诊状态为在院患者判断是否离床超过一日	
		Set tID=$o(^DHCHAI.DP.OutofbedI("IndexEpisodeDr",EpisodeDr,0))
		Set obj=##class(DHCHAI.DP.Outofbed).%OpenId(tID)
		Set (OutDischDate,OutDischTime)=""
		Set OprStatus=0
		If ($IsObject(obj)) {
			Set OutDischDate = obj.DischDate 
			Set OutDischTime = obj.DischTime 
			Set OprStatus= obj.OprStatus
		}
		
	   	If (OutBedFlag=1) {   //离床超过一日
	   		Set InputPatStr =tID
		   	Set InputPatStr =InputPatStr_"^"_EpisodeDr  
		    Set InputPatStr =InputPatStr_"^"_VisitStatus
		    Set InputPatStr =InputPatStr_"^"_OutbedDate 
		    Set InputPatStr =InputPatStr_"^"_OutbedTime 
		    Set InputPatStr =InputPatStr_"^"_OprStatus 
		    Set InputPatStr =InputPatStr_"^"_OutDischDate
		    Set InputPatStr =InputPatStr_"^"_OutDischTime 
		    Set InputPatStr =InputPatStr_"^"_1   
		    Set InputPatStr =InputPatStr_"^"_""
		    Set InputPatStr =InputPatStr_"^"_""
		    Set flg = ##class(DHCHAI.DP.Outofbed).Update(InputPatStr,"^")
		    //没有再次分配床位
		    Set VisitStatus =objAdm.PAVisitStatus
    		Set DischDate = objAdm.PADischDate  //出院日期赋值标记后的日期
    		Set DischTime = objAdm.PADischTime  //出院时间赋值标记后的时间
    		If $IsObject(objAdm.PADischLocDr) {
	    		Set DischLocDr = objAdm.PADischLocDr.%Id()
    		}
    		If $IsObject(objAdm.PADischWardDr) {
	    		Set DischWardDr = objAdm.PADischWardDr.%Id()
    		}
		    Set AdmDays=DischDate-AdmDate   //修复bug:557856统一住院天数计算
		    Set:AdmDays=0 AdmDays=1	   
			Set:AdmDays<0 AdmDays=-1	    //离床未出院患者按未出院算
    		
	   } Else {  //非离床一日、再次配置分配床位后就诊状态、出院日期时间取HIS时间
	   		If (tID) { //原先已加入离床列表
	   			Set obj=##class(DHCHAI.DP.Outofbed).%OpenId(tID)
				If ($IsObject(obj)) {
				    Set obj.VisitStatus = "A"
					Set obj.DischDate	= ""   
					Set obj.DischTime	= ""
					Set obj.IsActive	= 0    //有效改成无效
					Set obj.UpdateDate	= +$h    
					Set obj.UpdateTime	= $p($h,",",2)  
					
					Set sc=obj.%Save()
					If $system.Status.IsError(sc) {        //检查Save是否成功
				   		Do $system.OBJ.DisplayError(sc) 
				   		Set return=-1
					}Else{
						Set return=obj.%Id()
					}
					Do obj.%Close()
				}		   
	   		}
	   }
	} Else {
		If (EpisodeDr'="")&&($d(^DHCHAI.DP.OutofbedI("IndexEpisodeDr",EpisodeDr))) {  //已存在患者列表并存在离床列表中
			Set tID=$o(^DHCHAI.DP.OutofbedI("IndexEpisodeDr",EpisodeDr,0))
			Set obj=##class(DHCHAI.DP.Outofbed).%OpenId(tID)
			If ($IsObject(obj)) {
			    Set obj.VisitStatus = VisitStatus
				Set obj.DischDate	= $p(AdmInfo,"^",25)   
				Set obj.DischTime	= $p(AdmInfo,"^",26) 
				Set obj.IsActive	= 0    //有效改成无效
				Set obj.UpdateDate	= +$h    
				Set obj.UpdateTime	= $p($h,",",2)  
				
				Set sc=obj.%Save()
				If $system.Status.IsError(sc) {        //检查Save是否成功
			   		Do $system.OBJ.DisplayError(sc) 
			   		Set return=-1
				}Else{
					Set return=obj.%Id()
				}
				Do obj.%Close()
			}		   
		}
	}
	If (AdmType="I")&(VisitStatus="A") {
		Set DischDate=""
		Set DischTime=""
	}
	Set InputStr = EpisodeDr
	Set InputStr = InputStr_"^"_EpisodeIDX      	//就诊序号
	Set InputStr = InputStr_"^"_$p(AdmInfo,"^",2)	//病人主索引
	Set InputStr = InputStr_"^"_$p(AdmInfo,"^",3)	//登记号
	Set InputStr = InputStr_"^"_$p(AdmInfo,"^",4)	//病案号
	Set InputStr = InputStr_"^"_$p(AdmInfo,"^",5)	//姓名
	Set InputStr = InputStr_"^"_$p(AdmInfo,"^",6)	//性别（M男、F女、O其他）
	Set InputStr = InputStr_"^"_$p(AdmInfo,"^",7)	//民族
	Set InputStr = InputStr_"^"_BirthDay         	//出生日期
	Set InputStr = InputStr_"^"_$p(AdmInfo,"^",35)	//年龄
	Set InputStr = InputStr_"^"_$p(AdmInfo,"^",9)	//身份证号码
	Set InputStr = InputStr_"^"_$p(AdmInfo,"^",10)	//现住址
	Set InputStr = InputStr_"^"_$p(AdmInfo,"^",11)	//工作单位
	Set InputStr = InputStr_"^"_$p(AdmInfo,"^",12)	//联系人
	Set InputStr = InputStr_"^"_$p(AdmInfo,"^",13)	//联系人电话
	Set InputStr = InputStr_"^"_$p(AdmInfo,"^",14)	//死亡标志
	Set InputStr = InputStr_"^"_$p(AdmInfo,"^",15)	//死亡日期
	Set InputStr = InputStr_"^"_$p(AdmInfo,"^",16)	//死亡时间
	Set InputStr = InputStr_"^"_AdmType         	//就诊类型
	Set InputStr = InputStr_"^"_VisitStatus	        //就诊状态 //update 2020-03-12
	Set InputStr = InputStr_"^"_$p(AdmInfo,"^",19)	//入院日期
	Set InputStr = InputStr_"^"_$p(AdmInfo,"^",20)	//入院时间
	Set InputStr = InputStr_"^"_AdmLocDr			//就诊科室
	Set InputStr = InputStr_"^"_AdmWardDr			//就诊病区
	Set InputStr = InputStr_"^"_$p(AdmInfo,"^",23)	//就诊房间
	Set InputStr = InputStr_"^"_AdmBedDr         	//就诊床位
	Set InputStr = InputStr_"^"_DischDate        	//出院日期   //update 2020-03-12
	Set InputStr = InputStr_"^"_DischTime	        //出院时间
	Set InputStr = InputStr_"^"_DischLocDr			//出院科室
	Set InputStr = InputStr_"^"_DischWardDr			//出院病区
	Set InputStr = InputStr_"^"_AdmDays         	//住院天数
	Set InputStr = InputStr_"^"_IsNewBaby       	//新生儿标志
	Set InputStr = InputStr_"^"_BirthWeight      	//新生儿出生体重
	Set InputStr = InputStr_"^"_AdmitWeight     	//新生儿入院体重
	Set InputStr = InputStr_"^"_+$h
	Set InputStr = InputStr_"^"_+$p($h,",",2)
	Set InputStr = InputStr_"^"_$p(AdmInfo,"^",36)	//住院次数
	Set InputStr = InputStr_"^"_$p(AdmInfo,"^",37)	//主管医生
	Set InputStr = InputStr_"^"_Apgar   			//(新生儿)阿普加评分

	Set ret = ##class(DHCHAI.DP.PAAdm).Update(InputStr,"^")
	if ret>0 {
		Set return = ret
		//删除出院日期之后的转科记录
		Do ##class(DHCHAI.DP.PAAdmTrans).DeleteByDischDateTime(return)
		//同步转科记录
		Do ##class(DHCHAI.DI.DHS.SyncHisInfo).SyncAdmTransLoc(aSCode,EpisodeIDX)
	}else{
		//记录错误日志
		Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeIDX,"DHCHAI.DP.PAAdm","Update",$lb(InputStr,"^"))
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-03-23
/// Description:  根据EpisodeID同步病人转科记录（科室+病区+床位）
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       aEpisodeID : 东华HIS就诊ID
/// Return：      返回处理条数
/// w ##class(DHCHAI.DI.DHS.SyncHisInfo).SyncAdmTransLoc("HIS02","HIS02||64")
ClassMethod SyncAdmTransLoc(aSCode As %String, aEpisodeIDX As %String) As %String
{
	New (aSCode,aEpisodeIDX)
	Set return = 0
	Quit:(aSCode="")||(aEpisodeIDX="") return
	Set $ZT="SyncAdmTransLocErr"
	
	Set EpisodeID=$p(aEpisodeIDX,"||",2)
	Set HISCode=$p(aEpisodeIDX,"||",1)
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Quit:HISCode'=objSYS.BTHISCode return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="HIS" return  //HIS系统
	
	//就诊记录检查
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aEpisodeIDX)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	Set DischDate=objAdm.PADischDate
	Set DischTime=objAdm.PADischTime
	
	Set VisitStatus =objAdm.PAVisitStatus 
	Quit:VisitStatus="P" return  //update 20191008 等待状态不同步转科记录
		
	//调用取转科记录接口
	Set TransList=""
	Set flg=##Class(DHCHAI.DI.DIO.FromHisSrv).GetTransInfo(EpisodeID,.TransList)
	Quit:(+flg)<1 return
	Quit:TransList="" return
	
	For indTI=1:1:$listlength(TransList) {
		Set tmpTrans=$listget(TransList,indTI)
		Continue:tmpTrans=""
		Set TransType=$listget(tmpTrans,1)
		Set TransID=$listget(tmpTrans,2)
	    Set TransLoc=$listget(tmpTrans,3)
	    Set TransBed=$listget(tmpTrans,4)
	    Set TransSttDate=$listget(tmpTrans,5)
	    Set TransSttTime=$listget(tmpTrans,6)
	    Set TransEndDate=$listget(tmpTrans,7)
	    Set TransEndTime=$listget(tmpTrans,8)
	    Set PAAdmDoc=$listget(tmpTrans,9)
	    Continue:(TransLoc="")&&(TransBed="")
	    
	    If TransEndDate'="" {
		    Set TransDays=TransEndDate-TransSttDate+1     //转科天数与住院天数不一致？？
	    } Else {
		    Set TransDays=-1
		    If DischDate'="" {
			    Set TransEndDate=DischDate
			    Set TransEndTime=DischTime
			    Set TransDays=TransEndDate-TransSttDate+1
			    Continue:TransDays<1
			}
		}
	    
	    //科室/病区
	    Set objTransLoc=##class(DHCHAI.BT.Location).GetObjByXCode(aSCode,TransLoc)
		If $IsObject(objTransLoc) {
			Set TransLocDr=objTransLoc.%Id()
		}Else{
			Set TransLocDr=..SyncLocationByID(aSCode,TransLoc)
		}
		//床位
		If TransBed'="" {
		    Set objTransBed=##class(DHCHAI.BT.PACBed).GetObjByXCode(TransLocDr,TransBed)
			If $IsObject(objTransBed) {
				Set TransBedDr=objTransBed.%Id()
			}Else{
				Set TransBedDr=..SyncPACBedByID(aSCode,TransBed)
			}
		} Else {
			Set TransBedDr=""
		}
		
		Set TransDr=""
		Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjByTransID(TransType,EpisodeDr,TransID)
		If $IsObject(objTrans) {
			Set TransDr=objTrans.%Id()
		}
		
        Set InputStr = TransDr
        Set InputStr = InputStr_"^"_TransID           //HIS转科ID
		Set InputStr = InputStr_"^"_EpisodeDr         //就诊记录指针
		Set InputStr = InputStr_"^"_TransType         //转科类型（科室/病区/床位）
		Set InputStr = InputStr_"^"_TransLocDr        //转科ID
		Set InputStr = InputStr_"^"_TransBedDr        //转床ID
		Set InputStr = InputStr_"^"_TransSttDate      //转科日期
		Set InputStr = InputStr_"^"_TransSttTime      //转科时间
		Set InputStr = InputStr_"^"_TransDays         //在科天数
		Set InputStr = InputStr_"^"_TransEndDate      //出科日期
		Set InputStr = InputStr_"^"_TransEndTime      //出科时间
		Set InputStr = InputStr_"^"_+$h
		Set InputStr = InputStr_"^"_+$p($h,",",2)
		Set InputStr = InputStr_"^"_PAAdmDoc      	  //管床医生
		
		
		Set ret = ##class(DHCHAI.DP.PAAdmTrans).Update(InputStr,"^")
		If (+ret)>0 {
			Set return = return+1
		}else{
			//记录错误日志
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,"DHCHAI.DP.PAAdmTrans","Update",$lb(InputStr,"^"))
		}
	}
	
	//设置转病区/转床对应关联科室 add by zf 20181219
	Set flg=..SetTransWardLoc(EpisodeDr)
	
	Quit return
	
SyncAdmTransLocErr
	Set return="-999^"_$ZError
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-03-23
/// Description:  根据EpisodeID同步病人转科病区关联科室
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       aEpisodeID : 东华HIS就诊ID
/// Return：      返回处理条数
/// w ##class(DHCHAI.DI.DHS.SyncHisInfo).SetTransWardLoc("5392")
ClassMethod SetTransWardLoc(aEpisodeDr As %String) As %String
{
	New (aEpisodeDr)
	Set return=0
	Quit:(aEpisodeDr="") return
	
	Set $ZT="SetTransWardLocErr"
	
	Kill arrTransLoc
	Set xTransID=0
	For {
		Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDr",aEpisodeDr,xTransID))
		Quit:xTransID=""
		
		Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
		Continue:'$isobject(objTrans)
		Set TransType=objTrans.PATransType
		Continue:(TransType'="E")
		Continue:'$isobject(objTrans.PATransLocDr)
		Set LocDr=objTrans.PATransLocDr.%Id()
		Set TransDate=objTrans.PATransDate
		Set TransTime=objTrans.PATransTime
		Set arrTransLoc(+TransDate,+TransTime,LocDr)=xTransID
	}
	
	Set xTransID=0
	For {
		Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDr",aEpisodeDr,xTransID))
		Quit:xTransID=""
		
		Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
		Continue:'$isobject(objTrans)
		Set TransType=objTrans.PATransType
		Continue:(TransType'="W")&&(TransType'="B")
		Continue:'$isobject(objTrans.PATransLocDr)
		Set LocDr=objTrans.PATransLocDr.%Id()
		Set TransDate=objTrans.PATransDate
		Set TransTime=objTrans.PATransTime
		Set TransDate=+TransDate
		Set TransTime=+TransTime
		Set LinkLocDr=""
		If $IsObject(objTrans.PALinkLocDr) {
			Set LinkLocDr=objTrans.PALinkLocDr.%Id()
		}
		
		Set tLinkLocDr=""
		Set xTransDate=TransDate+1
		For {
			Set xTransDate=$o(arrTransLoc(xTransDate),-1)
			Quit:xTransDate=""
			Quit:tLinkLocDr'=""
			
			Set xTransTime=$s(TransDate=xTransDate:TransTime+1,1:"")
			For {
				Set xTransTime=$o(arrTransLoc(xTransDate,xTransTime),-1)
				Quit:xTransTime=""
				Set tLinkLocDr=$o(arrTransLoc(xTransDate,xTransTime,0))
				Quit
			}
		}
		Continue:tLinkLocDr=""
		Continue:LinkLocDr=tLinkLocDr //关联科室无变化，不更新
		
		Set InputStr=xTransID_"^"_tLinkLocDr
		Set ret=##class(DHCHAI.DP.PAAdmTrans).UpdateLinkLoc(InputStr,"^")
		If (+ret)>0 {
			Set return=return+1
		}else{
			//记录错误日志
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(aEpisodeDr,"DHCHAI.DP.PAAdmTrans","UpdateLinkLoc",$lb(InputStr,"^"))
		}
	}
	Kill arrTransLoc
	Quit return
	
SetTransWardLocErr
	Set return="-999^"_$ZError
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-03-23
/// Description:  根据EpisodeID同步病人临床诊断
/// Table：       DHCHAI.DP.MRDiagnos
/// Input：       aEpisodeIDX : 东华HIS就诊ID
/// Return：      返回处理条数
/// w ##class(DHCHAI.DI.DHS.SyncHisInfo).SyncAdmDiagnos("HIS01","HIS01||50098968","2018-01-25","2018-01-25")
ClassMethod SyncAdmDiagnos(aSCode As %String, aEpisodeIDX As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aSCode,aEpisodeIDX,aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:aSCode="" return
	Quit:(aEpisodeIDX="")||(aDateFrom="")||(aDateTo="") return
	Set $ZT="SyncAdmDiagnosErr"
	
	Set EpisodeID=$p(aEpisodeIDX,"||",2)
	Set HISCode=$p(aEpisodeIDX,"||",1)
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Quit:HISCode'=objSYS.BTHISCode return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="HIS" return  //HIS系统
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	//就诊记录检查
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aEpisodeIDX)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	
	// 先把病人所有诊断无效
	Set xID=""
	For {
		Set xID = $o(^DHCHAI.DP.MRDiagnosI("IndexEpisodeDr",EpisodeDr,xID))
		Quit:xID=""
		
		////update 20190920 只把临床诊断置成无效，使用索引更好
		Set objDiag= ##class(DHCHAI.DP.MRDiagnos).GetObjById(xID)
	    Continue:'$IsObject(objDiag)
	    Continue:objDiag.MRDiagSource'="C"
	    
		D ##class(DHCHAI.DP.MRDiagnos).CancelById(xID)
	}
	//调用取诊断记录接口
	//同步更新临床所有诊断 update cpj 2018-01-26 
	Set DiagnosInfo = ##class(DHCHAI.DI.DIO.FromHisSrv).GetMrDiagnos(EpisodeID,"","")
	Set DiagnosCount = $listlength(DiagnosInfo)
	Quit:DiagnosCount=0 return
	For Index = 1:1:DiagnosCount{
		Set TmpDiagnos = $list(DiagnosInfo,Index)
		Continue:TmpDiagnos=""
		
		Set XCode      = $list(TmpDiagnos,1)  //记录ID
		Set DiagDesc   = $list(TmpDiagnos,3)
		Set DiagNote   = $list(TmpDiagnos,4)
		Set DiagDesc   = $s(DiagDesc="":DiagNote,1:DiagDesc)
		Continue:(XCode="")||((DiagDesc="")&&(DiagNote=""))
		
		Set IsActive=1  //是否有效
		
		//检查诊断是否有效
		Set objICDDxMap=##class(DHCHAI.DP.MRICDDxMap).GetObjByDiagDesc(aSCode,DiagDesc)
		If $IsObject(objICDDxMap) {
			Continue:objICDDxMap.BTIsActive'=1
		}
		
        Set DiagnosDr=""
        Set objDiagnos=##class(DHCHAI.DP.MRDiagnos).GetObjByXCode(aSCode,XCode)
        If $IsObject(objDiagnos) {
	        Set DiagnosDr=objDiagnos.%Id()
        }
        
        Set InputStr = DiagnosDr
		Set InputStr = InputStr_"^"_EpisodeDr					//就诊记录指针
		Set InputStr = InputStr_"^"_$list(TmpDiagnos,2)			//诊断ICD10
		Set InputStr = InputStr_"^"_DiagDesc					//诊断名称
		Set InputStr = InputStr_"^"_DiagNote					//诊断备注
		Set InputStr = InputStr_"^"_$list(TmpDiagnos,5)			//诊断类型代码
		Set InputStr = InputStr_"^"_$list(TmpDiagnos,6)			//诊断类型描述
		Set InputStr = InputStr_"^"_$list(TmpDiagnos,7)			//诊断日期
		Set InputStr = InputStr_"^"_$list(TmpDiagnos,8)			//诊断时间
		Set InputStr = InputStr_"^"_"C"							//诊断来源（C临床、E首页、F编目）
		Set InputStr = InputStr_"^"_aSCode						//子系统代码
		Set InputStr = InputStr_"^"_XCode						//记录索引码
		Set InputStr = InputStr_"^"_IsActive					//有效标志
		Set InputStr = InputStr_"^"_+$h
		Set InputStr = InputStr_"^"_+$p($h,",",2)
		Set DiagnosDr = ##class(DHCHAI.DP.MRDiagnos).Update(InputStr,"^")
		If (+DiagnosDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DP.MRDiagnos"
			Set ErrMethod = "Update"
			Set ErrArgStr = $lb(InputStr,"^")
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
		Continue:(+DiagnosDr)<1
		
		//计数
		Set Count=Count+1
		
		//诊断名称存入对照表 
		Set objMRICDDxMap=##class(DHCHAI.DP.MRICDDxMap).GetObjByDiagDesc(aSCode,DiagDesc)
		If '$isobject(objMRICDDxMap){
			Set MapItemDr=""
			Set objMRICDDx=##class(DHCHAI.DP.MRICDDx).GetObjByCodeDesc("",DiagDesc)
			Set:$isobject(objMRICDDx) MapItemDr=objMRICDDx.%Id()
			
			Set InputStr = ""
			Set InputStr = InputStr_"^"_DiagDesc					//诊断名称
			Set InputStr = InputStr_"^"_MapItemDr					//标准名称
			Set InputStr = InputStr_"^"_""							//标准备注
			Set InputStr = InputStr_"^"_aSCode						//子系统代码
			Set InputStr = InputStr_"^"_1							//有效标志
			Set InputStr = InputStr_"^"_""							//处置日期
			Set InputStr = InputStr_"^"_""							//处置时间
			Set InputStr = InputStr_"^"_""							//处置人
			Set ICDDxMapDr=##class(DHCHAI.DP.MRICDDxMap).Update(InputStr,"^")
			If (+ICDDxMapDr)<1 {
				//记录错误日志
				Set ErrClass  = "DHCHAI.DP.MRICDDxMap"
				Set ErrMethod = "Update"
				Set ErrArgStr = $lb(InputStr,"^")
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
			}
		}
		// 诊断类型对照（重复记录不再处理）
		Set DiagTypeCode = $list(TmpDiagnos,5)	
		Set DiagTypeDesc = $list(TmpDiagnos,6)
		If (DiagTypeDesc'="")&&(DiagTypeCode'="") {
			Set InputStr=""
			Set $p(InputStr,"^",1)="DiagType"  // 诊断类型
			Set $p(InputStr,"^",2)=DiagTypeCode
			Set $p(InputStr,"^",3)=DiagTypeDesc
			Set PhraseMapDr=##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap(InputStr,aSCode)
			If (+PhraseMapDr)<1 {
				//记录错误日志
				Set ErrClass  = "DHCHAI.DPS.PhraseMapSrv"
				Set ErrMethod = "SavePhraseMap"
				Set ErrArgStr = $lb(InputStr,aSCode)
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
			}
		}
	}
	Set return=Count
	Quit return
SyncAdmDiagnosErr
	Set return="-999^"_$ZError
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-08-16
/// Description:  根据EpisodeID同步病人医嘱信息
/// Table：       DHCHAI.DP.OEOrdItem
/// Input：       aEpisodeIDX : 东华HIS就诊ID
/// 			  aDateFrom：结束日期
/// 			  aDateTo：结束日期
/// Return：      返回处理条数
/// w ##class(DHCHAI.DI.DHS.SyncHisInfo).SyncAdmOEOrdItem("HIS01","HIS01||198","2020-01-01","2020-02-29")
ClassMethod SyncAdmOEOrdItem(aSCode As %String, aEpisodeIDX As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aSCode,aEpisodeIDX,aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:aSCode="" return
	Quit:(aEpisodeIDX="")||(aDateFrom="")||(aDateTo="") return
	Set $ZT="SyncAdmOEOrdItemErr"
	
	Set EpisodeID=$p(aEpisodeIDX,"||",2)
	Set HISCode=$p(aEpisodeIDX,"||",1)
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Quit:HISCode'=objSYS.BTHISCode return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="HIS" return  //HIS系统
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	//就诊记录检查
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aEpisodeIDX)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	
	Set objPhraseType=##class(DHCHAI.DP.PhraseType).GetObjByCodeDesc("ARCOrdCat","")
	Quit:'$IsObject(objPhraseType) return
	Set PhraseTypeID=objPhraseType.%Id()
	
	Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromHisSrv:QryOrdItemList")
  	Set sc=rs.Execute(EpisodeID,aDateFrom,aDateTo)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
		Set OEItemID=rs.Data("OEItemID")
		Continue:OEItemID=""
		
		//根据医嘱大类+子类判断是否同步
		Set MapOrdCat=""
		Set ArcimCode=rs.Data("ArcimCode")
		Set ArcimDesc=rs.Data("ArcimDesc")
		Set ArcOrdType=rs.Data("ArcOrdType")
		Set ArcCatDesc=rs.Data("ArcCatDesc")
		Set ArcSubCatDesc=rs.Data("ArcSubCatDesc")
		Set PHCCatDesc=rs.Data("PHCCatDesc")
		Set PHCSubCatDesc=rs.Data("PHCSubCatDesc")
		Set PHCPoisonDesc=rs.Data("PHCPoisonDesc")
		Set AntiFlag=rs.Data("AntiFlag")
		Set PHCGeneric=rs.Data("PHCGeneric")  //药品通用名 add by zf 20171128
		Set PHChemical=rs.Data("PHChemical")  //药品化学名 add by zf 20171128
		
		If ArcOrdType="R" {
			If (PHCSubCatDesc'="")&(MapOrdCat="") {
				Set tDesc="药学子类."_PHCSubCatDesc
				Set MapOrdCat=##class(DHCHAI.DP.PhraseMap).GetMapValue(aSCode,"ARCOrdCat",tDesc)
			}
			If (PHCCatDesc'="")&(MapOrdCat="") {
				Set tDesc="药学大类."_PHCCatDesc
				Set MapOrdCat=##class(DHCHAI.DP.PhraseMap).GetMapValue(aSCode,"ARCOrdCat",tDesc)
			}
			If (PHCPoisonDesc'="")&(MapOrdCat="") {
				Set tDesc="管制分类."_PHCPoisonDesc
				Set MapOrdCat=##class(DHCHAI.DP.PhraseMap).GetMapValue(aSCode,"ARCOrdCat",tDesc)
			}
			If (AntiFlag'="")&(MapOrdCat="") {
				Set tDesc="抗生素标志."_AntiFlag
				Set MapOrdCat=##class(DHCHAI.DP.PhraseMap).GetMapValue(aSCode,"ARCOrdCat",tDesc)
			}
		} Else {
			
			If (ArcimDesc'="")&(MapOrdCat="") {
				Set tDesc="医嘱名."_ArcimDesc
				Set MapOrdCat=##class(DHCHAI.DP.PhraseMap).GetMapValue(aSCode,"ARCOrdCat",tDesc)
			}
			If (ArcSubCatDesc'="")&(MapOrdCat="") {
				Set tDesc="医嘱子类."_ArcSubCatDesc
				Set MapOrdCat=##class(DHCHAI.DP.PhraseMap).GetMapValue(aSCode,"ARCOrdCat",tDesc)
			}
			If (ArcCatDesc'="")&(MapOrdCat="") {
				Set tDesc="医嘱大类."_ArcCatDesc
				Set MapOrdCat=##class(DHCHAI.DP.PhraseMap).GetMapValue(aSCode,"ARCOrdCat",tDesc)
			}
		}
		Continue:(MapOrdCat'="DRT")&(MapOrdCat'="ANT")&(MapOrdCat'="ISO")&(MapOrdCat'="COD")  //DRT器械相关治疗、ANT抗菌药物、ISO隔离类医嘱、COD会诊医嘱
		
		//根据医嘱项判断是否同步
		Set AntUseFlag=0
		Set ArcimDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(ArcimDesc,"'")  //处理特殊字符
		Set PHCGeneric=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(PHCGeneric,"'")  //处理特殊字符
		Set PHChemical=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(PHChemical,"'")  //处理特殊字符
		
		If MapOrdCat="ANT" {
			Set AntUseFlag=1
			Set objAntiMastMap=##class(DHCHAI.DP.OEAntiMastMap).GetObjByAntiDesc(aSCode,ArcimDesc)
			
			If $IsObject(objAntiMastMap){
				Continue:objAntiMastMap.BTIsActive'=1
			} Else {
				Set InputStr = ""
				Set InputStr = InputStr_"^"_ArcimDesc		//医嘱名称
				Set InputStr = InputStr_"^"_PHCGeneric		//药品通用名 add by zf 20171128
				Set InputStr = InputStr_"^"_PHChemical		//药品化学名 add by zf 20171128
				Set InputStr = InputStr_"^"_""				//标准名称
				Set InputStr = InputStr_"^"_""				//标准备注
				Set InputStr = InputStr_"^"_aSCode			//子系统代码
				Set InputStr = InputStr_"^"_1				//有效标志
				Set InputStr = InputStr_"^"_""				//处置日期
				Set InputStr = InputStr_"^"_""				//处置时间
				Set InputStr = InputStr_"^"_""				//处置人
				Set ret = ##class(DHCHAI.DP.OEAntiMastMap).Update(InputStr,"^")
				If ret<1{
					//记录错误日志
					Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,"DHCHAI.DP.OEAntiMastMap","Update",$lb(InputStr,"^"))
				}
			}
		} Else {   //器械相关治疗等医嘱
			Set objItmMastMap=##class(DHCHAI.DP.OEItmMastMap).GetObjByOrdDesc(aSCode,ArcimDesc)
			If $IsObject(objItmMastMap){
				Continue:objItmMastMap.BTIsActive'=1
			} Else {
				Set InputStr = ""
				Set InputStr = InputStr_"^"_ArcimDesc		//医嘱名称
				Set InputStr = InputStr_"^"_ArcCatDesc_"."_ArcSubCatDesc //医嘱分类
				Set InputStr = InputStr_"^"_""				//标准名称
				Set InputStr = InputStr_"^"_""				//标准备注
				Set InputStr = InputStr_"^"_aSCode			//子系统代码
				Set InputStr = InputStr_"^"_1				//有效标志
				Set InputStr = InputStr_"^"_""				//处置日期
				Set InputStr = InputStr_"^"_""				//处置时间
				Set InputStr = InputStr_"^"_""				//处置人
				Set ret = ##class(DHCHAI.DP.OEItmMastMap).Update(InputStr,"^")
				If ret<1{
					//记录错误日志
					Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,"DHCHAI.DP.OEItmMastMap","Update",$lb(InputStr,"^"))
				}
			}
		}
		
		//取医嘱信息接口
		Set OrdItemInfo=##Class(DHCHAI.DI.DIO.FromHisSrv).GetOrderInfo(OEItemID)
		Continue:OrdItemInfo=""
	    
		Set OEItemID=$p(OrdItemInfo,"^",1)
		Set OEOrdStatus=$p(OrdItemInfo,"^",2)
		Set OEItemID2=$p(OrdItemInfo,"^",3)     //主医嘱ID（OEItemID2为空，OEItemID为主医嘱）
		Set OEOrdStatus2=$p(OrdItemInfo,"^",4)  //主医嘱状态
		Set OEPriority=$p(OrdItemInfo,"^",10)
		
		Set FillerNo=OEItemID2  //主医嘱ID（滚医嘱方式）
		If FillerNo'="" {
			Set objFiller=##class(DHCHAI.DP.OEOrdItem).GetObjByXCode(aSCode,FillerNo)
			If $IsObject(objFiller){
				Set FillerNo=objFiller.%Id()
			} Else {
				Set OEItemID=OEItemID2
				Set OEOrdStatus=OEOrdStatus2
				Set FillerNo=""
			}
		} Else {
			Set FillerNo=""
		}
		
		//S1长期（滚执行记录）、S2长期（滚医嘱）、N临时
		Set MapPriority=##class(DHCHAI.DP.PhraseMap).GetMapValue(aSCode,"OEPriority",OEPriority)
		Continue:MapPriority=""
		
		//执行E、停止D、作废U
		Set MapStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue(aSCode,"OEOrdStatus",OEOrdStatus)
		Continue:MapStatus=""
		
		Set IsActive=1
		If MapPriority="S1" {
			Set:MapStatus="U" IsActive=0
		} ElseIf MapPriority="S2" {
			If FillerNo="" {  //主医嘱
				Set:MapStatus="U" IsActive=0
				Set:MapStatus="D" IsActive=0  //主医嘱停止无效
			} Else {
				Set IsActive=0 //非主医嘱，全部无效
			}
		} ElseIf MapPriority="N" {
			Set:MapStatus="U" IsActive=0
			Set:MapStatus="D" IsActive=0  //临时医嘱停止，医嘱无效
		} ElseIf MapPriority="OUT"{		// 出院带药
			Set:MapStatus="U" IsActive=0
			Set:MapStatus="D" IsActive=0  //出院带药停止，医嘱无效
		}
		
		//开医嘱科室
		Set OEOrdLocID=$p(OrdItemInfo,"^",33)
		Set OEOrdLocCode=$p(OrdItemInfo,"^",34)
		Set OEOrdLocDesc=$p(OrdItemInfo,"^",35)
		Set OEOrdLocDr=""
		If OEOrdLocID'="" {
			Set objOrdLoc=##class(DHCHAI.BT.Location).GetObjByXCode(aSCode,OEOrdLocID)
			If $IsObject(objOrdLoc) {
				Set OEOrdLocDr=objOrdLoc.%Id()
			} Else {
				Set OEOrdLocDr=..SyncLocationByID(aSCode,OEOrdLocID)
			}
		}
		//医嘱接收科室
		Set OERecLocID=$p(OrdItemInfo,"^",36)
		Set OERecLocCode=$p(OrdItemInfo,"^",37)
		Set OERecLocDesc=$p(OrdItemInfo,"^",38)
		Set OERecLocDr=""
		If OERecLocID'="" {
			Set objRecLoc=##class(DHCHAI.BT.Location).GetObjByXCode(aSCode,OERecLocID)
			If $IsObject(objRecLoc) {
				Set OERecLocDr=objRecLoc.%Id()
			} Else {
				Set OERecLocDr=..SyncLocationByID(aSCode,OERecLocID)
			}
		}
		//医生
		Set OEDocID=$p(OrdItemInfo,"^",39)    //医护人员ID
		Set OEDocCode=$p(OrdItemInfo,"^",15)  //医生工号
		Set OEDocName=$p(OrdItemInfo,"^",16)  //医生姓名
		Set OEDocDr=##class(DHCHAI.BT.CareProv).GetObjByXCode(aSCode,OEDocID)
		
		 // add 20190826 增加抗菌药物使用目的与手术相关的判断
		Set AntUsePurpose = $p(OrdItemInfo,"^",27)		//使用目的 
		Set AntOthPurpose = $p(OrdItemInfo,"^",28)		//其他目的
		Set SttDate = $p(OrdItemInfo,"^",17)
		If (AntUseFlag=1)&&(AntUsePurpose="")&&(AntOthPurpose="") {  //抗菌用药标志
			Set AntUsePurpose=##class(DHCHAI.DI.DHS.SyncHisInfo).CheckOperAnti(EpisodeDr,SttDate)
		}          		
		
		//索引码
		Set XCode=OEItemID,OEOrdItemDr=""
		Set objOEOrdItem=##class(DHCHAI.DP.OEOrdItem).GetObjByXCode(aSCode,XCode)
		If $IsObject(objOEOrdItem){
			Set OEOrdItemDr=objOEOrdItem.%Id()
		}
		
		//医嘱备注
		Set DepProcNotes = $p(OrdItemInfo,"^",41)
		
		Set InputStr = OEOrdItemDr
		Set InputStr = InputStr_"^"_EpisodeDr					//就诊记录指针
		Set InputStr = InputStr_"^"_$p(OrdItemInfo,"^",5)		//医嘱代码
		Set InputStr = InputStr_"^"_##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr($p(OrdItemInfo,"^",6),"'")		//医嘱名称
		Set InputStr = InputStr_"^"_$p(OrdItemInfo,"^",7)		//医嘱分类
		Set InputStr = InputStr_"^"_$p(OrdItemInfo,"^",8)		//医嘱大类
		Set InputStr = InputStr_"^"_$p(OrdItemInfo,"^",9)		//医嘱子类
		Set InputStr = InputStr_"^"_OEPriority          		//医嘱类型
		Set InputStr = InputStr_"^"_OEOrdStatus     	        //医嘱状态
		Set InputStr = InputStr_"^"_$p(OrdItemInfo,"^",11)		//开医嘱日期
		Set InputStr = InputStr_"^"_$p(OrdItemInfo,"^",12)		//开医嘱时间
		Set InputStr = InputStr_"^"_OEOrdLocDr				    //开医嘱科室
		Set InputStr = InputStr_"^"_OEOrdLocID_"|"_OEOrdLocCode_"|"_OEOrdLocDesc  //开医嘱科室
		Set InputStr = InputStr_"^"_OEDocID_"|"_OEDocCode_"|"_OEDocName  //开医嘱医生
		Set InputStr = InputStr_"^"_$p(OrdItemInfo,"^",17)		//医嘱开始日期
		Set InputStr = InputStr_"^"_$p(OrdItemInfo,"^",18)		//医嘱开始时间
		Set InputStr = InputStr_"^"_$p(OrdItemInfo,"^",19)		//停医嘱日期
		Set InputStr = InputStr_"^"_$p(OrdItemInfo,"^",20)		//停医嘱时间
		Set InputStr = InputStr_"^"_$p(OrdItemInfo,"^",21)		//药品通用名
		Set InputStr = InputStr_"^"_$p(OrdItemInfo,"^",22)		//给药途径
		Set InputStr = InputStr_"^"_$p(OrdItemInfo,"^",23)		//单次剂量
		Set InputStr = InputStr_"^"_$p(OrdItemInfo,"^",24)		//剂量单位
		Set InputStr = InputStr_"^"_$p(OrdItemInfo,"^",25)		//频次
		Set InputStr = InputStr_"^"_aSCode						//子系统代码
		Set InputStr = InputStr_"^"_XCode					    //记录索引码
		Set InputStr = InputStr_"^"_IsActive             		//有效标志
		Set InputStr = InputStr_"^"_+$h                         //更新日期
		Set InputStr = InputStr_"^"_+$p($h,",",2)               //更新时间
		Set InputStr = InputStr_"^"_$p(OrdItemInfo,"^",26)		//管制分类
		Set InputStr = InputStr_"^"_$p(OrdItemInfo,"^",27)		//使用目的
		Set InputStr = InputStr_"^"_$p(OrdItemInfo,"^",28)		//其他目的
		Set InputStr = InputStr_"^"_$p(OrdItemInfo,"^",29)		//是否送检
		Set InputStr = InputStr_"^"_$p(OrdItemInfo,"^",30)		//感染部位
		Set InputStr = InputStr_"^"_$p(OrdItemInfo,"^",31)		//使用日期
		Set InputStr = InputStr_"^"_$p(OrdItemInfo,"^",32)		//使用时间
		Set InputStr = InputStr_"^"_AntUseFlag           		//抗菌用药标志
		
		// add by zf 增加内容
		Set InputStr = InputStr_"^"_OEDocDr              		//开医嘱医生
		Set InputStr = InputStr_"^"_OERecLocDr              	//医嘱接收科室ID
		Set InputStr = InputStr_"^"_OERecLocID_"|"_OERecLocCode_"|"_OERecLocDesc  //医嘱接收科室
		Set InputStr = InputStr_"^"_FillerNo                    //主医嘱ID
		///add by wpl 添加医嘱阶段 2020-07-08
		Set InputStr = InputStr_"^"_$p(OrdItemInfo,"^",40)
		Set InputStr = InputStr_"^"_DepProcNotes                //医嘱备注
		// add pylian 20220909 抗菌药物医嘱首次执行时间
		Set InputStr = InputStr_"^"_$p(OrdItemInfo,"^",42)      //医嘱首次执行时间  42
		Set InputStr = InputStr_"^"_$p(OrdItemInfo,"^",43)      //医嘱首次执行时间  43
		
		Set ret=##class(DHCHAI.DP.OEOrdItem).Update(InputStr,"^")
		If (+ret)>0 {
			Set Count=Count+1
		} Else {
			//记录错误日志
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,"DHCHAI.DP.OEOrdItem","Update",$lb(InputStr,"^"))
		}
		If AntUseFlag=1{
			// 抗菌药物给药途径对照（重复记录不再处理）
			Set Instruc = $p(OrdItemInfo,"^",22)
			If Instruc'="" {
				Set InputStr=""
				Set $p(InputStr,"^",1)="AntiAdminRoute"  // 抗菌药物给药途径
				Set $p(InputStr,"^",2)=Instruc
				Set $p(InputStr,"^",3)=Instruc
				Set PhraseMapDr=##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap(InputStr,aSCode)
				If (+PhraseMapDr)<1 {
					//记录错误日志
					Set ErrClass  = "DHCHAI.DPS.PhraseMapSrv"
					Set ErrMethod = "SavePhraseMap"
					Set ErrArgStr = $lb(InputStr,aSCode)
					Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
				}
			}
			// 抗菌药物管制分类对照（重复记录不再处理）
			Set AntDrgPoison = $p(OrdItemInfo,"^",26)
			If AntDrgPoison'="" {
				Set InputStr=""
				Set $p(InputStr,"^",1)="DrgPoison"  // 管制分类
				Set $p(InputStr,"^",2)=AntDrgPoison
				Set $p(InputStr,"^",3)=AntDrgPoison
				Set PhraseMapDr=##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap(InputStr,aSCode)
				If (+PhraseMapDr)<1 {
					//记录错误日志
					Set ErrClass  = "DHCHAI.DPS.PhraseMapSrv"
					Set ErrMethod = "SavePhraseMap"
					Set ErrArgStr = $lb(InputStr,aSCode)
					Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
				}
			}
			// 抗菌药物用药目的对照（重复记录不再处理）
			Set AntUsePurpose = $p(OrdItemInfo,"^",27)
			If AntUsePurpose'="" {
				Set InputStr=""
				Set $p(InputStr,"^",1)="AntiMedPurpose"  // 抗菌药物用药目的
				Set $p(InputStr,"^",2)=AntUsePurpose
				Set $p(InputStr,"^",3)=AntUsePurpose
				Set PhraseMapDr=##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap(InputStr,aSCode)
				If (+PhraseMapDr)<1 {
					//记录错误日志
					Set ErrClass  = "DHCHAI.DPS.PhraseMapSrv"
					Set ErrMethod = "SavePhraseMap"
					Set ErrArgStr = $lb(InputStr,aSCode)
					Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
				}
			}
		}
		// 医嘱剂量单位对照（重复记录不再处理）
		Set DoseQtyUom = $p(OrdItemInfo,"^",24)
		If DoseQtyUom'="" {
			Set InputStr=""
			Set $p(InputStr,"^",1)="OEDoseUnit"  // 医嘱剂量单位
			Set $p(InputStr,"^",2)=DoseQtyUom
			Set $p(InputStr,"^",3)=DoseQtyUom
			Set PhraseMapDr=##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap(InputStr,aSCode)
			If (+PhraseMapDr)<1 {
				//记录错误日志
				Set ErrClass  = "DHCHAI.DPS.PhraseMapSrv"
				Set ErrMethod = "SavePhraseMap"
				Set ErrArgStr = $lb(InputStr,aSCode)
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
			}
		}
		// 频次对照（重复记录不再处理）
		Set PhcFreq = $p(OrdItemInfo,"^",25)
		If PhcFreq'="" {
			Set InputStr=""
			Set $p(InputStr,"^",1)="OEPhcFreq"  // 频次
			Set $p(InputStr,"^",2)=PhcFreq
			Set $p(InputStr,"^",3)=PhcFreq
			Set PhraseMapDr=##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap(InputStr,aSCode)
			If (+PhraseMapDr)<1 {
				//记录错误日志
				Set ErrClass  = "DHCHAI.DPS.PhraseMapSrv"
				Set ErrMethod = "SavePhraseMap"
				Set ErrArgStr = $lb(InputStr,aSCode)
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
			}
		}
	}
	Do rs.Close()
	
	Set return=Count
	Quit return
	
SyncAdmOEOrdItemErr
	Set return="-999^"_$ZError
	Quit return
}

/// *********************************************************************************
/// 以下内容为：医院、科室、用户信息
/// *********************************************************************************
/// Creator：     liyi
/// CreatDate：   2017-04-14
/// Description:  同步医院信息
/// Table：       DHCHAI.BT.Hospital
/// Input：		  aUserID：用户表DHCHAI.BT.SysUser.ID
/// Return：      正常：处理数据条数
/// w ##Class(DHCHAI.DI.DHS.SyncHisInfo).SyncHospital("HIS01")
ClassMethod SyncHospital(aSCode As %String, aUserID As %String = "") As %String
{
	New (aSCode,aUserID)
	Set return=0,Count=0
	Quit:aSCode="" return
	
	// 先把所有医院置无效，处理HIS医院删除的问题
	Set xHsopID=""
	For {
		Set xHsopID = $o(^DHCHAI.BT.HospitalD(xHsopID))
		Quit:xHsopID=""
	    
	    Set obj=##class(DHCHAI.BT.Hospital).%OpenId(xHsopID)
		Continue:'$IsObject(obj) 
		Set obj.BTIsActive		= 0
		Set sc=obj.%Save()
		if $system.Status.IsError(sc) {        //检查Save是否成功
	   		Do $system.OBJ.DisplayError(sc)
	   		Set return=-1
		}else{
			Set return=obj.%Id()
		}
		Do obj.%Close()
	}
	
	Set xID=0
	For {
		Set xID=$o(^CT("HOSP",xID))
		Quit:xID=""
		
		Set Code=$p($g(^CT("HOSP",xID)),"^",1)
		Set Desc=$p($g(^CT("HOSP",xID)),"^",2)
		Set XCode=xID  //关联代码
		Continue:(Code="")||(Desc="")||(XCode="")
		
		Set FromDate	= $p($g(^CT("HOSP",xID)),"^",9)  //医院开始日期
		Set ToDate		= $p($g(^CT("HOSP",xID)),"^",10) //医院结束日期
		Set IsActive=1
		If ((FromDate'="")&&(FromDate>+$h))||((ToDate'="")&&(ToDate<+$h)){
			Set IsActive=0
		}
		
		Set (ID,Desc2,GroupDr,ActDate,ActTime,ActUserDr)=""
		Set obj=##class(DHCHAI.BT.Hospital).GetObjByXCode(aSCode,XCode)
		If $IsObject(obj){
			Set ID=obj.%Id()
			Set Desc2=obj.BTDesc2
			Set:$IsObject(obj.BTGroupDr) GroupDr=obj.BTGroupDr.%Id()
			//Set IsActive=obj.BTIsActive
			Set ActDate=obj.BTActDate
			Set ActTime=obj.BTActTime
			Set:$IsObject(obj.BTActUserDr) ActUserDr=obj.BTActUserDr.%Id()
			// 二次同步有效性需和HIS保持一致
			Set obj.BTIsActive=IsActive
			Set sc=obj.%Save()
			if $system.Status.IsError(sc) {        //检查Save是否成功
		   		Do $system.OBJ.DisplayError(sc) 
		   		Set return=-1
			}
		}
		Set:aUserID'="" ActUserDr=aUserID
		Continue:IsActive=0
		
		Set InputStr=ID
		Set InputStr=InputStr_"^"_Code
		Set InputStr=InputStr_"^"_Desc
		Set InputStr=InputStr_"^"_Desc2
		Set InputStr=InputStr_"^"_GroupDr
		Set InputStr=InputStr_"^"_aSCode_"||"_XCode
		Set InputStr=InputStr_"^"_(+IsActive)
		Set InputStr=InputStr_"^"_ActDate
		Set InputStr=InputStr_"^"_ActTime
		Set InputStr=InputStr_"^"_ActUserDr
		Set HospDr=##class(DHCHAI.BT.Hospital).Update(InputStr,"^")
		If (+HospDr)>0{
			Set Count=Count+1
			
			Set MapID=""
			Set objMap=##class(DHCHAI.BT.HospitalMap).GetObjByXCode(aSCode,XCode)
			Set:$IsObject(objMap) MapID=objMap.%Id()
			Set InputStr=MapID
			Set InputStr=InputStr_"^"_HospDr
			Set InputStr=InputStr_"^"_Code
			Set InputStr=InputStr_"^"_Desc
			Set InputStr=InputStr_"^"_aSCode
			Set InputStr=InputStr_"^"_XCode
			Set InputStr=InputStr_"^"_ActDate
			Set InputStr=InputStr_"^"_ActTime
			Set InputStr=InputStr_"^"_ActUserDr
			Set flg=##class(DHCHAI.BT.HospitalMap).Update(InputStr)
			If (+flg)<0 {
				//记录错误日志
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog("","DHCHAI.BT.HospitalMap","Update",$lb(InputStr,"^"))
			}
			
			Set MapID=""
			Set objMap=##class(DHCHAI.BT.HospitalMap).GetObjByXCode("HISSYS",XCode)
			Set:$IsObject(objMap) MapID=objMap.%Id()
			Set InputStr=MapID
			Set InputStr=InputStr_"^"_HospDr
			Set InputStr=InputStr_"^"_Code
			Set InputStr=InputStr_"^"_Desc
			Set InputStr=InputStr_"^"_"HISSYS"
			Set InputStr=InputStr_"^"_XCode
			Set InputStr=InputStr_"^"_ActDate
			Set InputStr=InputStr_"^"_ActTime
			Set InputStr=InputStr_"^"_ActUserDr
			Set flg=##class(DHCHAI.BT.HospitalMap).Update(InputStr)
			If (+flg)<0 {
				//记录错误日志
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog("","DHCHAI.BT.HospitalMap","Update",$lb(InputStr,"^"))
			}
		}else{
			//记录错误日志
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog("","DHCHAI.BT.Hospital","Update",$lb(InputStr,"^"))
		}
	}
	Quit Count
}

/// Creator：     liyi
/// CreatDate：   2017-04-14
/// Description:  同步科室信息
/// Table：       DHCHAI.BT.Location
/// Input：		  aHospCode:DHCHAI.BT.Hospital.BTCode
/// 			  aUserID：用户表DHCHAI.BT.SysUser.ID
/// 		      aLocID：HIS科室ID
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCHAI.DI.DHS.SyncHisInfo).SyncLocation("HIS02")
ClassMethod SyncLocation(aSCode As %String, aHospCode As %String = "", aUserID As %String = "") As %String
{
	New (aSCode,aHospCode,aUserID)
	Set return=0,Count=0
	Quit:aSCode="" return
	
	Set xID=0
	For {
		Set xID=$o(^CTLOC(xID))
		Quit:xID=""
		
		Set Location=##Class(DHCHAI.DI.DIO.FromHisSrv).GetLocation(xID)
		Continue:Location=""
		Set HospID   = $p(Location,"^",6)
		Set HospCode = $p(Location,"^",7)
		Set HospDesc = $p(Location,"^",8)
		Continue:(aHospCode'="")&&(aHospCode'=HospCode)	//非本院区
		
		Set flg=..SyncLocationByID(aSCode,xID,aUserID)
		If (+flg)>0 {
			Set Count=Count+1
		}
	}
	// 处理关联科室信息
	Set xID=0
	For {
		Set xID=$o(^CTLOC(xID))
		Quit:xID=""
		
		Set Location=##Class(DHCHAI.DI.DIO.FromHisSrv).GetLocation(xID)
		Continue:Location=""
		Set HospID   = $p(Location,"^",6)
		Set HospCode = $p(Location,"^",7)
		Set HospDesc = $p(Location,"^",8)
		Continue:(aHospCode'="")&&(aHospCode'=HospCode)	//非本院区
		
		Set flg=..SyncLocLinkByID(aSCode,xID,aUserID)
	}
	Quit Count
}

/// w ##Class(DHCHAI.DI.DHS.SyncHisInfo).SyncLocLinkByID("HIS01",2,"")
ClassMethod SyncLocLinkByID(aSCode As %String, aLocID As %String, aUserID As %String = "") As %String
{
	New (aSCode,aLocID,aUserID)
	Set return=""
	Quit:(aSCode="")||(aLocID="") return
	
	Set Location=##Class(DHCHAI.DI.DIO.FromHisSrv).GetLocation(aLocID)
	Quit:Location="" return
	
	Set objLoc = ##class(DHCHAI.BT.Location).GetObjByXCode(aSCode,aLocID)
	Quit:'$IsObject(objLoc) return
		
	Set xSub=""
	For {
		Set xSub = $o(^DHCHAI.BT.LocationD(objLoc.%Id(),"Link",xSub))
		Quit:xSub=""
		
		D ##class(DHCHAI.BT.LocationLink).CancelById(objLoc.%Id()_"||"_xSub,aUserID)
	}
	Set ds = ##class(%Library.ResultSet).%New("DHCHAI.DI.DIO.FromHisSrv:GetLinkLocation")
	Do ds.Execute(aLocID)
	while(ds.Next()) {
		Set xLinkLocID 	= ds.Data("LinkLocID")		//关联科室的HIS科室ID
		Set objLinkLoc = ##class(DHCHAI.BT.Location).GetObjByXCode(aSCode,xLinkLocID)
		Continue:'$IsObject(objLinkLoc)
		Set InputStr=""
		Set InputStr=InputStr_"^"_objLoc.%Id()
		Set InputStr=InputStr_"^"_objLinkLoc.%Id()
		Set InputStr=InputStr_"^"_1
		Set InputStr=InputStr_"^"_+$h
		Set InputStr=InputStr_"^"_+$p($h,",",2)
		Set InputStr=InputStr_"^"_aUserID
		Set flg=##class(DHCHAI.BT.LocationLink).Update(InputStr)
		If (+flg)<0 {
			//记录错误日志
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog("","DHCHAI.BT.LocationLink","Update",$lb(InputStr,"^"))
		}
	}
	Quit return
}

/// w ##Class(DHCHAI.DI.DHS.SyncHisInfo).SyncLocationByID("HIS01",2,"")
ClassMethod SyncLocationByID(aSCode As %String, aLocID As %String, aUserID As %String = "") As %String
{
	New (aSCode,aLocID,aUserID)
	Set return=""
	Quit:(aSCode="")||(aLocID="") return
	
	Set Location=##Class(DHCHAI.DI.DIO.FromHisSrv).GetLocation(aLocID)
	Quit:Location="" return
	
	Set (Desc2,TypeDr,CateDr,GroupDr,HospDr,IsOPER,IsICU,IsNICU,ICUTpDr,ActDate,ActTime,ActUserDr,ParLocDr,IndNo)=""
	Set Code  = $p(Location,"^",2)
	Set Desc  = $p(Location,"^",3)
	//科室名称2特殊处理
	If $p(Desc,"-",2)'=""{
		Set Desc2 = $p(Desc,"-",2)
	}
	Set Type  = $p(Location,"^",4)	//科室类型
	Set Cate  = $p(Location,"^",5)	//科室标记
	Set HospID = $p(Location,"^",6)
	Set HospCode = $p(Location,"^",7)
	Set HospDesc = $p(Location,"^",8)
	Set IsActive = $p(Location,"^",9)
	Set XCode	= aLocID  //关联代码
	Quit:(Code="")||(Desc="")||(XCode="") return
	
	Set HospDr=""
	Set objHosp=##class(DHCHAI.BT.Hospital).GetObjByXCode(aSCode,HospID)
	Set:$IsObject(objHosp) HospDr=objHosp.%Id()
	
	If Type'="" {
		Set objType=##class(DHCHAI.BT.Dictionary).GetObjByCode("LocType",Type)
		If $IsObject(objType){
			Set TypeDr=objType.%Id()
		}
	}
	If Cate'="" {
		Set objCate=##class(DHCHAI.BT.Dictionary).GetObjByCode("LocCate",Cate)
		If $IsObject(objCate){
			Set CateDr=objCate.%Id()
		}
	}
	
	//停用的设置无效
	Set:Desc["未用" IsActive=0
	Set:Desc["停用" IsActive=0
	Set:Desc["作废" IsActive=0
	Set:Desc["删除" IsActive=0
	Set:Desc["无效" IsActive=0
	
	Set ID=""
	Set obj=##class(DHCHAI.BT.Location).GetObjByXCode(aSCode,XCode)
	If $IsObject(obj){
		Set ID=obj.%Id()
		Set Desc2=obj.BTDesc2
		Set:$IsObject(obj.BTTypeDr)&&("EW"[obj.BTTypeDr.BTCode) TypeDr=obj.BTTypeDr.%Id()
		//Set:$IsObject(obj.BTCateDr) CateDr=obj.BTCateDr.%Id()
		Set:$IsObject(obj.BTGroupDr) GroupDr=obj.BTGroupDr.%Id()
		//Set:$IsObject(obj.BTHospDr) HospDr=obj.BTHospDr.%Id()
		Set IsOPER=obj.BTIsOPER
		Set IsICU=obj.BTIsICU
		Set IsNICU=obj.BTIsNICU
		Set:$IsObject(obj.BTICUTpDr) ICUTpDr=obj.BTICUTpDr.%Id()
		//Set IsActive=obj.BTIsActive  //有效性与HIS保持一致,不沿用最初有效性
		Set ActDate=obj.BTActDate
		Set ActTime=obj.BTActTime
		Set:$IsObject(obj.BTActUserDr) ActUserDr=obj.BTActUserDr.%Id()
		Set:$IsObject(obj.BTParLocDr) ParLocDr=obj.BTParLocDr.%Id()
		Set IndNo=obj.BTIndNo
	}
	Set:aUserID'="" ActUserDr=aUserID
	
	Set InputStr=ID
	Set InputStr=InputStr_"^"_Code
	Set InputStr=InputStr_"^"_Desc
	Set InputStr=InputStr_"^"_Desc2
	Set InputStr=InputStr_"^"_TypeDr
	Set InputStr=InputStr_"^"_CateDr
	Set InputStr=InputStr_"^"_GroupDr
	Set InputStr=InputStr_"^"_HospDr
	Set InputStr=InputStr_"^"_IsOPER
	Set InputStr=InputStr_"^"_IsICU
	Set InputStr=InputStr_"^"_IsNICU
	Set InputStr=InputStr_"^"_ICUTpDr
	Set InputStr=InputStr_"^"_aSCode_"||"_XCode
	Set InputStr=InputStr_"^"_(+IsActive)
	Set InputStr=InputStr_"^"_ActDate
	Set InputStr=InputStr_"^"_ActTime
	Set InputStr=InputStr_"^"_ActUserDr
	Set InputStr=InputStr_"^"_ParLocDr
	Set InputStr=InputStr_"^"_IndNo
	Set LocDr=##class(DHCHAI.BT.Location).Update(InputStr,"^")
	If (+LocDr)>0{
		Set return=LocDr
		
		Set MapID=""
		Set objMap=##class(DHCHAI.BT.LocationMap).GetObjByXCode(aSCode,XCode)
		Set:$IsObject(objMap) MapID=objMap.%Id()
		Set InputStr=MapID
		Set InputStr=InputStr_"^"_LocDr
		Set InputStr=InputStr_"^"_Code
		Set InputStr=InputStr_"^"_Desc
		Set InputStr=InputStr_"^"_aSCode
		Set InputStr=InputStr_"^"_XCode
		Set InputStr=InputStr_"^"_ActDate
		Set InputStr=InputStr_"^"_ActTime
		Set InputStr=InputStr_"^"_ActUserDr
		Set flg=##class(DHCHAI.BT.LocationMap).Update(InputStr)
		If (+flg)<0 {
			//记录错误日志
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog("","DHCHAI.BT.LocationMap","Update",$lb(InputStr,"^"))
		}
	}else{
		//记录错误日志
		Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog("","DHCHAI.BT.Location","Update",$lb(InputStr,"^"))
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-04-17
/// Description:  同步用户信息
/// Table：       DHCHAI.BT.SysUser
/// Input：		  aHospCode:DHCHAI.BT.Hospital.BTCode
/// 			  aUserID：用户表DHCHAI.BT.SysUser.ID
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCHAI.DI.DHS.SyncHisInfo).SyncSSUser("HIS02")
ClassMethod SyncSSUser(aSCode As %String, aHospCode As %String = "", aUserID As %String = "") As %String
{
	New (aSCode,aHospCode,aUserID)
	Set return=0,Count=0
	Quit:aSCode="" return
	
	Set xID=0
	For {
		Set xID=$o(^SSU("SSUSR",xID))
		Quit:xID=""
		
		Set User=##Class(DHCHAI.DI.DIO.FromHisSrv).GetUser(xID)
		Continue:User=""
		Set LocID		= $p(User,"^",5)	//默认科室
		Set LocCode		= $p(User,"^",6)	//默认科室
		Set LocDesc		= $p(User,"^",7)	//默认科室
		
		Set objLoc=##class(DHCHAI.BT.Location).GetObjByXCode(aSCode,LocID)
		If $IsObject(objLoc){
			If $IsObject(objLoc.BTHospDr){
				Continue:(aHospCode'="")&&(aHospCode'=objLoc.BTHospDr.BTCode)	//非本院区
			}
		}
		
		Set flg=..SyncSSUserByID(aSCode,xID,aUserID)
		If (+flg)>0 {
			Set Count=Count+1
		}
	}
	Quit Count
}

/// w ##Class(DHCHAI.DI.DHS.SyncHisInfo).SyncSSUserByID()
ClassMethod SyncSSUserByID(aSCode As %String, aSSUserID As %String, aUserID As %String = "") As %String
{
	New (aSCode,aSSUserID,aUserID)
	Set return=""
	Quit:(aSCode="")||(aSSUserID="") return
	
	Set User=##Class(DHCHAI.DI.DIO.FromHisSrv).GetUser(aSSUserID)
	Quit:User="" return
	
	Set (Password,LocDr,TypeDr,IsActive,ActDate,ActTime,ActUserDr)=""
	Set XCode       = aSSUserID         //关联代码
	Set Code  		= $p(User,"^",2)
	Set Desc  		= $p(User,"^",3)
	Set Password	= $p(User,"^",4)
	Set LocID		= $p(User,"^",5)	//默认科室
	Set LocCode		= $p(User,"^",6)	//默认科室
	Set LocDesc		= $p(User,"^",7)	//默认科室
	Set Type		= $p(User,"^",8)
	Set IsActive	= $p(User,"^",9)
	Set CarePrvID	= $p(User,"^",10)
	Set CarePrvCode = $p(User,"^",11)
	Set CarePrvDesc = $p(User,"^",12)
	Quit:(Code="")||(Desc="")||(XCode="") return
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjByXCode(aSCode,LocID)
	If $IsObject(objLoc){
		Set LocDr=objLoc.%Id()
	}
	If Type'="" {
		Set objType=##class(DHCHAI.BT.Dictionary).GetObjByCode("UserType",Type)
		If $IsObject(objType){
			Set TypeDr=objType.%Id()
		}
	}
	
	//保存医护人员表信息
	Set CareProvDr=""
	Set objCareProv=##class(DHCHAI.BT.CareProv).GetObjByXCode(aSCode,CarePrvID)
	Set:$IsObject(objCareProv) CareProvDr=objCareProv.%Id()
	Set InputStr=CareProvDr
	Set InputStr=InputStr_"^"_CarePrvCode
	Set InputStr=InputStr_"^"_CarePrvDesc
	Set InputStr=InputStr_"^"_TypeDr
	Set InputStr=InputStr_"^"_aSCode_"||"_CarePrvID
	Set flg=##class(DHCHAI.BT.CareProv).Update(InputStr)
	If (+flg)<0 {
		//记录错误日志
		Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog("","DHCHAI.BT.CareProv","Update",$lb(InputStr,"^"))
	} Else {
		Set CareProvDr=+flg
		Set:CareProvDr<1 CareProvDr=""
	}
	
	Set ID=""
	Set obj=##class(DHCHAI.BT.SysUser).GetObjByXCode(aSCode,XCode)
	If $IsObject(obj){
		Set ID=obj.%Id()
		Set Password	= obj.BTPassword
		Set IsActive	= obj.BTIsActive
		Set ActDate		= obj.BTActDate
		Set ActTime		= obj.BTActTime
		Set:$IsObject(obj.BTActUserDr) ActUserDr=obj.BTActUserDr.%Id()
		Set:$IsObject(obj.BTLocDr) LocDr=obj.BTLocDr.%Id()
		Set:$IsObject(obj.BTTypeDr) TypeDr=obj.BTTypeDr.%Id()
	}
	Set:aUserID'="" ActUserDr=aUserID
	
	Set InputStr=ID
	Set InputStr=InputStr_"^"_Code
	Set InputStr=InputStr_"^"_Desc
	Set InputStr=InputStr_"^"_Password
	Set InputStr=InputStr_"^"_LocDr
	Set InputStr=InputStr_"^"_TypeDr
	Set InputStr=InputStr_"^"_aSCode_"||"_XCode
	Set InputStr=InputStr_"^"_(+IsActive)
	Set InputStr=InputStr_"^"_ActDate
	Set InputStr=InputStr_"^"_ActTime
	Set InputStr=InputStr_"^"_ActUserDr
	Set InputStr=InputStr_"^"_CareProvDr
	Set UserDr=##class(DHCHAI.BT.SysUser).Update(InputStr,"^")
	If (+UserDr)>0{
		Set return=UserDr
		
		Set MapID=""
		Set objMap=##class(DHCHAI.BT.SysUserMap).GetObjByXCode(aSCode,XCode)
		Set:$IsObject(objMap) MapID=objMap.%Id()
		Set InputStr=MapID
		Set InputStr=InputStr_"^"_UserDr
		Set InputStr=InputStr_"^"_Code
		Set InputStr=InputStr_"^"_Desc
		Set InputStr=InputStr_"^"_aSCode
		Set InputStr=InputStr_"^"_XCode
		Set InputStr=InputStr_"^"_ActDate
		Set InputStr=InputStr_"^"_ActTime
		Set InputStr=InputStr_"^"_ActUserDr
		Set flg=##class(DHCHAI.BT.SysUserMap).Update(InputStr)
		If (+flg)<0 {
			//记录错误日志
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog("","DHCHAI.BT.SysUserMap","Update",$lb(InputStr,"^"))
		}
	}else{
		//记录错误日志
		Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog("","DHCHAI.BT.SysUser","Update",$lb(InputStr,"^"))
	}
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-09-13
/// Description:  同步医院床位信息
/// Table：       DHCHAI.BT.PACBed
/// Input：		  aLocID    DHCHAI.BT.Location
/// Return：      正常：处理数据条数
/// w ##Class(DHCHAI.DI.DHS.SyncHisInfo).SyncPACBed("HIS02")
ClassMethod SyncPACBed(aSCode As %String, aHospCode As %String = "", aUserID As %String = "") As %String
{
	New (aSCode,aHospCode,aUserID)
	Set return="",Count=0
	Quit:aSCode="" return
	
	Set xWardID=0
	For {
		Set xWardID=$o(^PAWARD(xWardID))
		Quit:xWardID=""
		
		Set IsActive=$p($g(^PAWARD(xWardID)),"^",6)
		Continue:IsActive="N"   // 过滤未激活的病区
		Set WardID=$p($g(^PAWARD(xWardID)),"^",5)
		Set objLoc=##class(DHCHAI.BT.Location).GetObjByXCode(aSCode,WardID)
		If $IsObject(objLoc){
			If $IsObject(objLoc.BTHospDr){
				Continue:(aHospCode'="")&&(aHospCode'=objLoc.BTHospDr.BTCode)	//非本院区
			}
		}
		
		Set xID=0
		For {
			Set xID=$o(^PAWARD(xWardID,"BED",xID))
			Quit:xID=""
			
			Set BedID=xWardID_"||"_xID
			Set flg=..SyncPACBedByID(aSCode,BedID,aUserID)
			If (+flg)>0 {
				Set Count=Count+1
			}
		}
	}
	Quit Count
}

/// w ##Class(DHCHAI.DI.DHS.SyncHisInfo).SyncPACBedByID()
ClassMethod SyncPACBedByID(aSCode As %String, aBedID As %String, aUserID As %String = "") As %String
{
	New (aSCode,aBedID,aUserID)
	Set return=""
	Quit:(aSCode="")||(aBedID="") return
	
	Set (ID,IndNo,XLocDr,RoomDr,ActDate,ActTime,ActUserDr)=""
	Set Desc=$p($g(^PAWARD(+aBedID,"BED",+$p(aBedID,"||",2))),"^",1)
	Set IsActive=1
	Set:Desc["停用" IsActive=0
	Set:Desc["测试" IsActive=0
	Set:Desc["作废" IsActive=0
	Set:Desc["删除" IsActive=0
	Set:Desc["无效" IsActive=0
	Set XCode=aBedID
	Quit:(Desc="")||(XCode="") return
	
	Set WardID=$p($g(^PAWARD(+aBedID)),"^",5)
	Set objLoc=##class(DHCHAI.BT.Location).GetObjByXCode(aSCode,WardID)
	Quit:'$IsObject(objLoc) return
	Set LocDr=objLoc.%Id()
	
	Set obj=##class(DHCHAI.BT.PACBed).GetObjByXCode(LocDr,XCode)
	If $IsObject(obj){
		Set ID=obj.%Id()
		Set IndNo     = obj.BTIndNo
		Set:$IsObject(obj.BTXLocDr) XLocDr = obj.BTXLocDr.%Id()
		Set:$IsObject(obj.BTRoomDr) RoomDr = obj.BTRoomDr.%Id()
		Set IsActive  = obj.BTIsActive
		Set ActDate   = obj.BTActDate
		Set ActTime   = obj.BTActTime
		Set:$IsObject(obj.BTActUserDr) ActUserDr = obj.BTActUserDr.%Id()
	}
	Set:aUserID'="" ActUserDr=aUserID
	
	//自动生成床顺序号
	If (IndNo="") {
		Set IndNo=+$o(^DHCHAI.BT.PACBedI("IndexLocDrIndNo",LocDr,""),-1)+1
		Set:IndNo="" IndNo=1
	}
	
	Set InputStr=ID
	Set InputStr=InputStr_"^"_LocDr
	Set InputStr=InputStr_"^"_Desc
	Set InputStr=InputStr_"^"_IndNo
	Set InputStr=InputStr_"^"_XLocDr
	Set InputStr=InputStr_"^"_RoomDr
	Set InputStr=InputStr_"^"_XCode
	Set InputStr=InputStr_"^"_(+IsActive)
	Set InputStr=InputStr_"^"_ActDate
	Set InputStr=InputStr_"^"_ActTime
	Set InputStr=InputStr_"^"_ActUserDr
	Set flg=##class(DHCHAI.BT.PACBed).Update(InputStr,"^")
	If (+flg)>0{
		Set return=flg
	}else{
		//记录错误日志
		Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog("","DHCHAI.BT.PACBed","Update",$lb(InputStr,"^"))
	}
	Quit return
}

/// w ##class(DHCHAI.DI.DHS.SyncHisInfo).OldDataUpdate()
ClassMethod OldDataUpdate() As %String
{
	New 
	Set EpisodeDr = ""
	For {
		Set EpisodeDr=$o(^DHCHAI.DP.PAAdmD(EpisodeDr))
		Quit:EpisodeDr=""
		//设置转病区/转床对应关联科室 add by zf 20181219
		Set flg=..SetTransWardLoc(EpisodeDr)
	}
	Quit "0"
}

/// Creator：     pylian
/// CreatDate：   2019-08-28
/// Description:  手术与抗菌药物使用时间关系判断。
/// Table：       DHCHAI.DP.OROperAnaes
/// Input：       aEpisodeDr
/// Return：     
/// w ##class(DHCHAI.DI.DHS.SyncHisInfo).CheckOperAnti("5391","64397")
ClassMethod CheckOperAnti(aEpisodeDr As %String, aSttDate As %String) As %String
{
	New (aEpisodeDr,aSttDate)
	Set return=0
	Quit:(aSttDate="")||(aEpisodeDr="") return
	
	Set DateFrom = aSttDate-7
	Set DateTo   = aSttDate+1
	Set AntUsePurpose="",flg=0
	Set xDate=DateFrom-1
	For{
		Set xDate=$o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDrOperDate",aEpisodeDr,xDate))
		Quit:(xDate="")||(flg=1)
		Quit:xDate>DateTo
		Set xID=""
		For {	
			Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDrOperDate",aEpisodeDr,xDate,xID))
			Quit:(xID="")||(return=1)
			Set obj=##class(DHCHAI.DP.OROperAnaes).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.OREpisodeDr)
			Continue:obj.ORIsActive'=1
			Set OperDate=xDate
			Continue:OperDate=""
			Set Incision = obj.ORIncision
			If (Incision="")||(Incision="0类切口")||(Incision="Ⅰ类切口") {   //术前一天，术后两天为预防用药
				Set tDays=OperDate-aSttDate
				Continue:tDays>1
				Continue:tDays<-2
				Set AntUsePurpose = "预防-手术-清洁手术 "
			} ElseIf (Incision="Ⅱ类切口")||(Incision="Ⅲ类切口") { //术前一天，术后七天为预防用药
				Set tDays=OperDate-aSttDate
				Continue:tDays>1
				Continue:tDays<-7
				Set AntUsePurpose = "预防-手术-清洁-感染"
			}	
			Else {  //术前一天，术后为预防用药 
				Set tDays=OperDate-aSttDate
				Continue:tDays>1
				Set AntUsePurpose = "预防-手术-污染手术"
			}
			Set flg=1
		}
	}
	Set return=AntUsePurpose
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2022-07-13
/// Description:  根据EpisodeID同步病人住院证
/// Table：       DHCHAI.DP.PADocBooking
/// Input：       aEpisodeID : 东华HIS就诊ID
/// Return：      返回处理条数
/// w ##class(DHCHAI.DI.DHS.SyncHisInfo).SyncIPBooking("HIS01","HIS01||295")
ClassMethod SyncIPBooking(aSCode As %String, aEpisodeIDX As %String) As %String
{
	New (aSCode,aEpisodeIDX)
	Set return = 0
	Quit:(aSCode="")||(aEpisodeIDX="") return
	Set $ZT="SyncIPBookingErr"
	
	Set EpisodeID=$p(aEpisodeIDX,"||",2)
	Set HISCode=$p(aEpisodeIDX,"||",1)
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Quit:HISCode'=objSYS.BTHISCode return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="HIS" return  //HIS系统
	
	//就诊记录检查
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aEpisodeIDX)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()

	Set xBookID=""
    For {
	    Set xBookID=$o(^DHCDocIPBK(0,"EpisodeIDTo",EpisodeID,xBookID))
	    Quit:xBookID=""
	     
	    Set IPBookingData = $g(^DHCDocIPBK(xBookID))
	    Continue:IPBookingData=""
	   
	   	Set IsActive=1
	    Set CurStateID = $p(IPBookingData,"^",8)   //当前状态ID 指向DHCDocIPBDictory
	    Continue:CurStateID=""
	    Set CurState =$p($g(^DHCDocIPBDIC(CurStateID)),"^",1)
	    Set:CurState="Cancel" IsActive=0

	    Set EpisodeIDF = $p(IPBookingData,"^",2)   //HIS门急诊就诊ID
	    Set EpisodeDrF = ##class(DHCHAI.DI.DHS.SyncHisInfo).SyncOEAdm(aSCode,EpisodeIDF)  //门急诊数据插入就诊表
	    Continue:(+EpisodeDrF)<1
	    
	    Set CreateDate = $p(IPBookingData,"^",4)
	    Set CreateTime = $p(IPBookingData,"^",5)
	    	
		Set BookingDr=""
		Set BookingDr = $o(^MA.HAI.DP.PADocBookingI("IndexEpisodeDr",EpisodeDr,0))
	    
        Set InputStr = BookingDr
        Set InputStr = InputStr_"^"_EpisodeDr                 //住院就诊ID
		Set InputStr = InputStr_"^"_EpisodeDrF                //门、急诊就诊记录
		Set InputStr = InputStr_"^"_aSCode_"||"_xBookID       //住院证ID
		Set InputStr = InputStr_"^"_aEpisodeIDX               //HIS住院就诊ID
		Set InputStr = InputStr_"^"_aSCode_"||"_EpisodeIDF    //HIS门急诊就诊ID		
		Set InputStr = InputStr_"^"_CreateDate        	      //住院证创建日期
		Set InputStr = InputStr_"^"_CreateTime        	      //住院证创建时间
		Set InputStr = InputStr_"^"_IsActive
		Set InputStr = InputStr_"^"_+$h
		Set InputStr = InputStr_"^"_+$p($h,",",2)
		
		Set ret = ##class(DHCHAI.DP.PADocBooking).Update(InputStr,"^")
		If (+ret)>0 {
			Set return = return+1
		}else{
			//记录错误日志
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,"DHCHAI.DP.PADocBooking","Update",$lb(InputStr,"^"))
		}
	}
	
	Quit return
	
SyncIPBookingErr
	Set return="-999^"_$ZError
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2022-07-13
/// Description:  同步门、急诊患者
/// Table：       
/// Input：       aEpisodeID : 东华HIS就诊ID
/// Return：      返回处理条数
/// w ##class(DHCHAI.DI.DHS.SyncHisInfo).SyncOEAdm("HIS01","410")
ClassMethod SyncOEAdm(aSCode As %String, aEpisodeID As %String) As %String
{
	New (aSCode,aEpisodeID,aHospCode)
	Set return=0
	Quit:(aSCode="")||(aEpisodeID="") return
	
	Set AdmStr = $g(^PAADM(+aEpisodeID))
	Set AdmType= $p(AdmStr,"^",2)	//就诊类型
	Quit:(AdmType'="O")&(AdmType'="E") return
	Set PatientID = $p(AdmStr,"^",1)
	Quit:PatientID="" return
	
	Set PapmiNo  	= $p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	Set PatName  	= $p($g(^PAPER(PatientID,"ALL")),"^",1)
	Set BirthDay 	= $p($g(^PAPER(PatientID,"ALL")),"^",6)
	Set HomeAddress	= $g(^PAPER(PatientID,"PER","ADD",1))
	Set Company		= $p($g(^PAPER(PatientID,"PER",4)),"^",18)
	Set RelativeName= $p($g(^PAPER(PatientID,"PER",2)),"^",13)
	Set RelativeTel	= $p($g(^PAPER(PatientID,"ALL")),"^",4)
	Set DeathDate	= $p($g(^PAPER(PatientID,"ALL")),"^",13)
	Set DeathTime	= $p($g(^PAPER(PatientID,"ALL")),"^",8)
	Set IsDeath  	= $s(DeathDate'="":1,1:0)
	Set Nation 		= $p($g(^PAPER(PatientID,"PER",2)),"^",1)
	Set:Nation'="" Nation=$p($g(^CT("NAT",Nation)),"^",2)
	Set IdentityCode= $p($g(^PAPER(PatientID,"ALL")),"^",9)
	Set Sex	 = $p($g(^CT("SEX",$p($g(^PAPER(PatientID,"ALL")),"^",7))),"^",2)
	Set Sex	 = $s(Sex="男":"M",Sex="女":"F",1:"O")
	
	
	Set AdmDateTime = ##Class(DHCHAI.IO.FromAdmSrv).GetAdmDateTime(+aEpisodeID)	//入院日期
	Set AdmDate	= $p(AdmDateTime,"^",1)
	Set AdmTime	= $p(AdmDateTime,"^",2)
	Set AdmLoc	= $p(AdmStr,"^",4)
	Set HospID  = $p($g(^CTLOC(AdmLoc)),"^",22)
	Set HospCode = $p($g(^CT("HOSP",HospID)),"^",1)
	Set AdmWard	= $p(AdmStr,"^",70)
	Set AdmWard=$p($g(^PAWARD(+AdmWard)),"^",5)  //病区科室转换一下
	Set AdmRoom	= $p(AdmStr,"^",69)
	Set AdmBed	= $p(AdmStr,"^",73)
	
	Set DischDateTime = ##Class(DHCHAI.IO.FromAdmSrv).GetDischDateTime(+aEpisodeID)
	Set DischDate = $p(DischDateTime,"^",1)
	Set DischTime = $p(DischDateTime,"^",2)
	Set Age = ##class(DHCHAI.IO.FromHisSrv).GetPapmiAge(PatientID,aEpisodeID,AdmDate,AdmTime)
	Set VisitStatus = $p(AdmStr,"^",20)	//就诊状态
	Set IsActive = 1
	Set:(VisitStatus="P")||(VisitStatus="C") IsActive =0
	
	Set (AdmLocDr,AdmWardDr,AdmBedDr)=""
	Set objAdmLoc = ##class(DHCHAI.BT.Location).GetObjByXCode(aSCode,AdmLoc)
	Set objAdmWard = ##class(DHCHAI.BT.Location).GetObjByXCode(aSCode,AdmWard)
	if $isobject(objAdmLoc) {
		Set AdmLocDr=objAdmLoc.%Id()
	}else{
		Set:AdmLoc'="" AdmLocDr=..SyncLocationByID(aSCode,AdmLoc)
	}
	if $isobject(objAdmWard) {
		Set AdmWardDr=objAdmWard.%Id()
	}else{
		Set:AdmWard'="" AdmWardDr=..SyncLocationByID(aSCode,AdmWard)
	}
	Set objAdmBed = ##class(DHCHAI.BT.PACBed).GetObjByXCode(AdmLocDr,AdmBed)
	if $isobject(objAdmBed) {
		Set AdmBedDr=objAdmBed.%Id()
	}else{
		Set:AdmBed'="" AdmBedDr=..SyncPACBedByID(aSCode,AdmBed)
	}
	
	Set PAAdmTimes	= $p(AdmStr,"^",29)
	Set AdmDocDr    = $p(AdmStr,"^",9)  //主管医生
	Set AdmDocCode="",AdmDocDesc=""
	If AdmDocDr'="" {
		Set AdmDocCode=$p($g(^CTPCP(AdmDocDr,1)),"^",1)
		Set AdmDocDesc=$p($g(^CTPCP(AdmDocDr,1)),"^",2)
	}
	Set PAAdmDoc=AdmDocDr_"|"_AdmDocCode_"|"_AdmDocDesc
	
	Set EpisodeIDX=aSCode_"||"_aEpisodeID
	Set EpisodeDr=""
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(EpisodeIDX)
	If $IsObject(objAdm){
		Set EpisodeDr=objAdm.%Id()
	}
	
	Set InputStr = EpisodeDr
	Set InputStr = InputStr_"^"_EpisodeIDX      	//就诊序号
	Set InputStr = InputStr_"^"_PatientID	        //病人主索引
	Set InputStr = InputStr_"^"_PapmiNo	            //登记号
	Set InputStr = InputStr_"^"_""	                //病案号
	Set InputStr = InputStr_"^"_PatName	            //姓名
	Set InputStr = InputStr_"^"_Sex	                //性别（M男、F女、O其他）
	Set InputStr = InputStr_"^"_Nation	            //民族
	Set InputStr = InputStr_"^"_BirthDay            //出生日期
	Set InputStr = InputStr_"^"_Age	                //年龄
	Set InputStr = InputStr_"^"_IdentityCode 	    //身份证号码
	Set InputStr = InputStr_"^"_HomeAddress	        //现住址
	Set InputStr = InputStr_"^"_Company	            //工作单位
	Set InputStr = InputStr_"^"_RelativeName	    //联系人
	Set InputStr = InputStr_"^"_RelativeTel	        //联系人电话
	Set InputStr = InputStr_"^"_IsDeath	            //死亡标志
	Set InputStr = InputStr_"^"_DeathDate	        //死亡日期
	Set InputStr = InputStr_"^"_DeathTime	        //死亡时间
	Set InputStr = InputStr_"^"_AdmType         	//就诊类型
	Set InputStr = InputStr_"^"_VisitStatus	        //就诊状态 
	Set InputStr = InputStr_"^"_AdmDate	            //入院日期
	Set InputStr = InputStr_"^"_AdmTime	            //入院时间
	Set InputStr = InputStr_"^"_AdmLocDr			//就诊科室
	Set InputStr = InputStr_"^"_AdmWardDr			//就诊病区
	Set InputStr = InputStr_"^"_AdmRoom	            //就诊房间
	Set InputStr = InputStr_"^"_AdmBedDr         	//就诊床位
	Set InputStr = InputStr_"^"_DischDate        	//出院日期   
	Set InputStr = InputStr_"^"_DischTime	        //出院时间
	Set InputStr = InputStr_"^"_""			        //出院科室
	Set InputStr = InputStr_"^"_""			        //出院病区
	Set InputStr = InputStr_"^"_1         	        //住院天数
	Set InputStr = InputStr_"^"_0       	        //新生儿标志
	Set InputStr = InputStr_"^"_""      	        //新生儿出生体重
	Set InputStr = InputStr_"^"_""        	        //新生儿入院体重
	Set InputStr = InputStr_"^"_+$h                 //更新日期
	Set InputStr = InputStr_"^"_+$p($h,",",2)       //更新时间
	Set InputStr = InputStr_"^"_PAAdmTimes	        //住院次数
	Set InputStr = InputStr_"^"_PAAdmDoc	        //主管医生
	Set InputStr = InputStr_"^"_"" 
    
	Set ret = ##class(DHCHAI.DP.PAAdm).Update(InputStr,"^")
	if ret>0 {
		Set return = ret
	}else{
		//记录错误日志
		Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeIDX,"DHCHAI.DP.PAAdm","Update",$lb(InputStr,"^"))
	}
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-09-17
/// Description:  根据EpisodeID同步病人会诊数据
/// Table：       DHCHAI.DP.EmConsult
/// Input：       aEpisodeIDX : 东华HIS就诊ID
/// Return：      返回处理条数
/// w ##class(DHCHAI.DI.DHS.SyncHisInfo).SyncAdmEmConsult("HIS01","HIS01||54226839","2019-07-01","2019-07-25")
ClassMethod SyncAdmEmConsult(aSCode As %String, aEpisodeIDX As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aSCode,aEpisodeIDX,aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:aSCode="" return
	Quit:(aEpisodeIDX="")||(aDateFrom="")||(aDateTo="") return
	
	Set EpisodeID=$p(aEpisodeIDX,"||",2)
	Set HISCode=$p(aEpisodeIDX,"||",1)
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Quit:HISCode'=objSYS.BTHISCode return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="HIS" return  //HIS系统
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	//就诊记录检查
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aEpisodeIDX)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	
	// 先把病人所有会诊无效
	Set xID=""
	For {
		Set xID = $o(^DHCHAI.DP.EmConsultI("IndexEpisodeDr",EpisodeDr,xID))
		Quit:xID=""
		D ##class(DHCHAI.DP.EmConsult).CancelById(xID)
	}

	Set EmConsultInfo = ##class(DHCHAI.DI.DIO.FromHisSrv).GetEmConsult(EpisodeID,aDateFrom,aDateTo)
	Set EmConsultCount = $listlength(EmConsultInfo)
	Quit:EmConsultCount=0 return
	For Index = 1:1:EmConsultCount{
		Set TmpEmConsult = $list(EmConsultInfo,Index)
		Continue:TmpEmConsult=""
	
		Set OrdItemDr   = $list(TmpEmConsult,2)
		Set RLocDr      = $list(TmpEmConsult,3)
		Set RDate       = $list(TmpEmConsult,4)
		Set RTime       = $list(TmpEmConsult,5)
		Set RUserDr     = $list(TmpEmConsult,6)
		Set TrePro      = $list(TmpEmConsult,7)
		Set Purpose     = $list(TmpEmConsult,8)
		Set Category    = $list(TmpEmConsult,9)
		Set DocLev      = $list(TmpEmConsult,10)
		Set NDate       = $list(TmpEmConsult,11)
		Set NTime       = $list(TmpEmConsult,12)
		Set NPlace      = $list(TmpEmConsult,13)
		Set ALocDr      = $list(TmpEmConsult,14)
		Set AUserDr     = $list(TmpEmConsult,15)
		Set ADate       = $list(TmpEmConsult,16)
		Set ATime       = $list(TmpEmConsult,17)
		Set TreMeasures = $list(TmpEmConsult,18)
		Set RStatus     = $list(TmpEmConsult,19)
		Set Type        = $list(TmpEmConsult,20)
		Set CDate       = $list(TmpEmConsult,21)
		Set CTime       = $list(TmpEmConsult,22)
		Set CUserDr     = $list(TmpEmConsult,23)
		Set CLocDr      = $list(TmpEmConsult,24)
		Set EmFlag      = $list(TmpEmConsult,25)
		Set OutFlag     = $list(TmpEmConsult,26)
		Set Opintion    = $list(TmpEmConsult,27)
		Set ConsentAnti = $list(TmpEmConsult,28)	
		Set XCode      = $list(TmpEmConsult,1)  //记录ID
		Continue:(XCode="")||(Opintion="")
		
		Set (OrdItemID,RUserID,AUserID,CUserID,RLocID,ALocID,CLocID) =""
		Set objOrdItem=##class(DHCHAI.DP.OEOrdItem).GetObjByXCode(aSCode,OrdItemDr)
		If $IsObject(objOrdItem){
			Set OrdItemID=objOrdItem.%Id()
		} 
		Set objRUser=##class(DHCHAI.BT.CareProv).GetObjByXCode(aSCode,RUserDr)
		If $IsObject(objRUser){
			Set RUserID=objRUser.%Id()
		} 
		Set objAUser=##class(DHCHAI.BT.CareProv).GetObjByXCode(aSCode,AUserDr)
		If $IsObject(objAUser){
			Set AUserID=objAUser.%Id()
		} 
		Set objCUser=##class(DHCHAI.BT.CareProv).GetObjByXCode(aSCode,CUserDr)
		If $IsObject(objCUser){
			Set CUserID=objCUser.%Id()
		} 
		
		If RLocDr'="" {
			Set objRLoc=##class(DHCHAI.BT.Location).GetObjByXCode(aSCode,RLocDr)
			If $IsObject(objRLoc) {
				Set RLocID=objRLoc.%Id()
			} Else {
				Set RLocID=..SyncLocationByID(aSCode,RLocDr)
			}
		}
		If ALocDr'="" {
			Set objALoc=##class(DHCHAI.BT.Location).GetObjByXCode(aSCode,ALocDr)
			If $IsObject(objALoc) {
				Set ALocID=objALoc.%Id()
			} Else {
				Set ALocID=..SyncLocationByID(aSCode,ALocDr)
			}
		}
		If CLocDr'="" {
			Set objCLoc=##class(DHCHAI.BT.Location).GetObjByXCode(aSCode,CLocDr)
			If $IsObject(objCLoc) {
				Set CLocID=objCLoc.%Id()
			} Else {
				Set CLocID=..SyncLocationByID(aSCode,CLocDr)
			}
		}
		Set IsActive=1  //是否有效
		
        Set EmConsultDr=""
        Set objEmConsult=##class(DHCHAI.DP.EmConsult).GetObjByXCode(aSCode,XCode)
        If $IsObject(objEmConsult) {
	        Set EmConsultDr=objEmConsult.%Id()
        }
        
        Set InputStr = EmConsultDr                              // ID
		Set InputStr = InputStr_"^"_EpisodeDr					// 就诊记录指针
		Set InputStr = InputStr_"^"_OrdItemID  			        // 医嘱记录
		Set InputStr = InputStr_"^"_RLocID     					// 申请科室
		Set InputStr = InputStr_"^"_RDate      				    // 申请日期 
		Set InputStr = InputStr_"^"_RTime      			        // 申请时间
		Set InputStr = InputStr_"^"_RUserID  			        // 申请医生 
		Set InputStr = InputStr_"^"_TrePro     			        // 病情及诊疗经过  
		Set InputStr = InputStr_"^"_Purpose    			        // 会诊的理由和目的 
		Set InputStr = InputStr_"^"_Category   	                // 会诊类别  
        Set InputStr = InputStr_"^"_DocLev     			        // 医生级别  
		Set InputStr = InputStr_"^"_NDate      					// 会诊日期 
		Set InputStr = InputStr_"^"_NTime      				    // 会诊时间
		Set InputStr = InputStr_"^"_NPlace     			        // 会诊地点  
		Set InputStr = InputStr_"^"_ALocID     			        // 审核科室  
		Set InputStr = InputStr_"^"_AUserID    			        // 审核人 
		Set InputStr = InputStr_"^"_ADate      			        // 审核日期 
		Set InputStr = InputStr_"^"_ATime      	                // 审核时间 
        Set InputStr = InputStr_"^"_TreMeasures			        // 最终治疗措施  
		Set InputStr = InputStr_"^"_RStatus    					// 申请状态  
		Set InputStr = InputStr_"^"_Type       				    // 会诊类型
		Set InputStr = InputStr_"^"_CDate      			        // 完成日期  
		Set InputStr = InputStr_"^"_CTime      			        // 完成时间  
		Set InputStr = InputStr_"^"_CUserID    			        // 完成人 
		Set InputStr = InputStr_"^"_CLocID     			        // 会诊科室 
		Set InputStr = InputStr_"^"_EmFlag                      // 是否加急  
        Set InputStr = InputStr_"^"_OutFlag                     // 是否院外  
        Set InputStr = InputStr_"^"_Opintion                    // 会诊意见 
	    Set InputStr = InputStr_"^"_ConsentAnti                 // 是否同意使用抗生素
		Set InputStr = InputStr_"^"_aSCode						//子系统代码
		Set InputStr = InputStr_"^"_XCode						//记录索引码
		Set InputStr = InputStr_"^"_IsActive					//有效标志
		Set InputStr = InputStr_"^"_+$h
		Set InputStr = InputStr_"^"_+$p($h,",",2)
       
		Set EmConsultDr = ##class(DHCHAI.DP.EmConsult).Update(InputStr,"^")
		
		If (+EmConsultDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DP.EmConsult"
			Set ErrMethod = "Update"
			Set ErrArgStr = $lb(InputStr,"^")
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
		Continue:(+EmConsultDr)<1
		
		//计数
		Set Count=Count+1
		
	}
	Set return=Count
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2022-01-17
/// Description:  处理历史品种通用名数据未同步问题
/// Table：       DHCHAI.DP.EmConsult
/// Input：       aSCode:系统代码
/// Return：      返回处理条数
/// w ##class(DHCHAI.DI.DHS.SyncHisInfo).SyncChemical("HIS01")
ClassMethod SyncChemical(aSCode As %String) As %String
{
	New (aSCode)
	Set return=0,Count=0
	Quit:aSCode="" return

    Set xAntiDesc=""
    For {
   		Set xAntiDesc = $o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",aSCode,xAntiDesc))
   		Quit:xAntiDesc=""
   		
   		Set xID=""
   		For {
   			Set xID = $o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",aSCode,xAntiDesc,xID))
   			Quit:xID=""
	   		 
	   		Set objMast=##Class(DHCHAI.DP.OEAntiMastMap).GetObjById(xID)
	   		Continue:'$IsObject(objMast)
	   		       
   	       	Set AntiDesc=$$ALPHAUP^SSUTIL4(xAntiDesc)
	   		Set xItemSub=""
	   		Set xItemSub=$o(^ARCIM(0,"Desc",AntiDesc,0))
		   	Continue:xItemSub=""
		   
			Set DrgFormID=$p($g(^ARCIM(+xItemSub,1,1)),"^",12)	
			Set DrgMastID=+DrgFormID			
			Set PHCGenericDr=+$p($g(^PHCD(DrgMastID,4)),"^",1)
			Set PHCGeneric=""
			Set:PHCGenericDr'="" PHCGeneric=$p($g(^PHCGE("GE",PHCGenericDr)),"^",2)
			Set:PHCGenericDr'="" PHChemicalDr=$p($g(^PHCGE("GE",PHCGenericDr,"DHC")),"^",3)    
			Set PHChemical=""
			Set:PHChemicalDr'="" PHChemical=$p($g(^DHCPHCM(PHChemicalDr)),"^",2)
			Continue:PHChemical=""
			Set obj=##class(DHCHAI.DP.OEAntiMastMap).%OpenId(xID)
			Set obj.BTChemical = PHChemical
			Set sc=obj.%Save()
			If $system.Status.IsError(sc) {        //检查Save是否成功
		   		Do $system.OBJ.DisplayError(sc)
			}Else {
				Set Count =Count+1
			}
			Do obj.%Close()
		   		
	   	}
    }
	Set return = Count
	
	Quit return
}

}
