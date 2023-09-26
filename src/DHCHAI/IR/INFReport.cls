/// 名称: DHCHAI.IR.INFReport
/// 描述: 医院感染报告
/// 编写者：chenjb
/// 编写日期: 2017-01-17
Class DHCHAI.IR.INFReport Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 更新日志
Relationship ChildLog As DHCHAI.IR.INFRepLog [ Cardinality = children, Inverse = Parref ];

/// 报告扩展
Relationship ChildExt As DHCHAI.IR.INFRepExt [ Cardinality = children, Inverse = Parref ];

/// 就诊记录
Property IREpisodeDr As DHCHAI.DP.PAAdm;

/// 报告类型（1医院感染报告、2新生儿感染报告、3ICU调查表、4手术切口调查表、5多重耐药调查表、6抗菌药物调查表 7横断面调查）
Property IRRepType As %Integer;

/// 报告日期
Property IRRepDate As %Date;

/// 报告时间
Property IRRepTime As %Time;

/// 报告科室
Property IRRepLocDr As DHCHAI.BT.Location;

/// 报告人
Property IRRepUser As DHCHAI.BT.SysUser;

/// 报告状态
Property IRStatusDr As DHCHAI.BT.Dictionary;

/// 入科来源
Property IRInLocDr As DHCHAI.BT.Location;

/// 出科去向
Property IROutLocDr As DHCHAI.BT.Location;

/// 入科时间
Property IRInDate As %Date;

/// 出科时间
Property IROutDate As %Date;

/// APACHEⅡ评分
Property IRAPACHEScore As %String;

/// 转出ICU带管情况
Property IROutIntubats As list Of DHCHAI.BT.Dictionary;

/// 转出ICU48带管情况
Property IROut48Intubats As list Of DHCHAI.BT.Dictionary;

/// 代报标志
Property IRReplaceFlag As %Boolean;

/// add 20220127 是否存在病原学信息
Property IRIsInfLab As %Boolean;

/// add 20220127 是否存在抗菌药物信息
Property IRIsInfAnti As %Boolean;

/// add 20220127 是否存在手术信息
Property IRIsInfOpr As %Boolean;

Index IndexPaadmType On (IREpisodeDr As Exact, IRRepType As Exact);

Index IndexRepDate On (IRRepType As Exact, IRRepDate As Exact);

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  根据ID取医院感染报告信息
/// Table：       DHCHAI.IR.INFReport
/// Input：       Id : DHCHAI.IR.INFReport.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.INFReport).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.INFReport
{
	New (aId)
	Quit:'##class(DHCHAI.IR.INFReport).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.INFReport).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  更新医院感染报告信息
/// Table：       DHCHAI.IR.INFReport
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.INFReport).Update("^1^3^^^22^^1^^^^^^^^3,4^2,3^4,8^^^^^^^^","")
ClassMethod Update(InStr As %String, separete As %String = "^") As %String
{
	New (InStr,separete)
	Set return=0
	Quit:InStr="" return
	Kill ^TMP($j,"SyncInfRep","DHCHAI.IR.INFReport")
	Set CHR2 = "#"
	Set:$g(separete)="" separete=..#SEPARATE
	Set ID               = $p(InStr,separete,1)
	Set IREpisodeDr      = $p(InStr,separete,2)
	Set IRRepType        = $p(InStr,separete,3)
	Set IRRepDate        = $p(InStr,separete,4)
	Set IRRepTime        = $p(InStr,separete,5)
	Set IRRepLocDr       = $p(InStr,separete,6)
	Set IRRepUser        = $p(InStr,separete,7)
	Set IRStatusDr       = $p(InStr,separete,8)
	Set LinkDiagDrs      = $p(InStr,separete,9)
	Set LinkICDDrs       = $p(InStr,separete,10)
	Set LinkLabDrs       = $p(InStr,separete,11)
	Set LinkAntiDrs      = $p(InStr,separete,12)
	Set LinkOPSDrs       = $p(InStr,separete,13)
	Set LinkMRBDrs       = $p(InStr,separete,14)
	Set LinkInvOperDrs   = $p(InStr,separete,15)
	Set LinkPreFactDrs   = $p(InStr,separete,16)
	Set LinkICUUCDrs     = $p(InStr,separete,17)
	Set LinkICUVAPDrs    = $p(InStr,separete,18)
	Set LinkICUPICCDrs   = $p(InStr,separete,19)
	Set IRInLocDr        = $p(InStr,separete,20)
	Set IROutLocDr       = $p(InStr,separete,21)
	Set IRInDate         = $p(InStr,separete,22)
	Set IROutDate        = $p(InStr,separete,23)
	Set IRAPACHEScore    = $p(InStr,separete,24)
	Set IROutIntubats    = $p(InStr,separete,25)
	Set IROut48Intubats  = $p(InStr,separete,26)
	Set LinkCSSDrs 		 = $p(InStr,separete,27)
	Set OldReportID 	 = $p(InStr,separete,28)  // 旧版报告ID
	// add 20220127 是否存在病原学信息、抗菌药物、手术信息
	Set IsInfLab         = $p(InStr,separete,29)
	Set IsInfAnti        = $p(InStr,separete,30)
	Set IsInfOpr         = $p(InStr,separete,31)
	
	Quit:(IREpisodeDr="")||(IRRepLocDr="")||(IRRepUser="") return
	
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(IREpisodeDr)
	Quit:'$IsObject(objEpisode) return
	
	Set:IRRepDate'="" IRRepDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(IRRepDate)
	Set:IRRepDate="" IRRepDate=+$h   //为空赋值当前日期
	Set:IRRepTime[":" IRRepTime=$zth(IRRepTime,1)
	Set:IRRepTime="" IRRepTime=+$p($h,",",2)
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.INFReport).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.INFReport).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IREpisodeDr   = objEpisode
	Set obj.IRRepType     = IRRepType    //报告类型
	Set obj.IRRepDate     = IRRepDate    //报告日期
	set obj.IRRepTime     = IRRepTime    //报告时间
	Set obj.IRRepLocDr    = ##class(DHCHAI.BT.Location).GetObjById(IRRepLocDr)       //报告科室
	Set obj.IRRepUser     = ##class(DHCHAI.BT.SysUser).GetObjById(IRRepUser)         //报告人员
	/*
	If (IRRepType=3) {  // ICU调查表传过来的参数是状态代码
		Set obj.IRStatusDr = ##class(DHCHAI.BT.Dictionary).GetObjByCode("InfReportStatus",IRStatusDr)     //状态
	}Else {
		*/
	Set obj.IRStatusDr = ##class(DHCHAI.BT.Dictionary).GetObjById(IRStatusDr)     //状态
	
	Set obj.IRInLocDr     = ##class(DHCHAI.BT.Location).GetObjById(IRInLocDr)        //入科来源
	Set obj.IROutLocDr    = ##class(DHCHAI.BT.Location).GetObjById(IROutLocDr)       //出科去向
	Set obj.IRAPACHEScore = IRAPACHEScore  //评分
   
    // add 20220127 是否存在病原学信息、抗菌药物、手术信息
	Set obj.IRIsInfLab    = IsInfLab
	Set obj.IRIsInfAnti   = IsInfAnti
	Set obj.IRIsInfOpr    = IsInfOpr
	
	//List 数据对象
	Set idxLB=""   //去除重复
	For ind=1:1:$length(IROutIntubats,CHR2) {
		Set idxID=$p(IROutIntubats,CHR2,ind)
		Continue:idxID=""
		Continue:($listfind(idxLB,idxID)>0)
		Set idxLB=idxLB_$lb(idxID)
		Set objIdxID=##class(DHCHAI.BT.Dictionary).GetObjById(idxID) 
		Continue:'$IsObject(objIdxID)
		Do obj.IROutIntubats.Insert(objIdxID)
	}
	
	//List 数据对象
	Set idxLB=""   //去除重复
	For ind=1:1:$length(IROut48Intubats,CHR2) {
		Set idxID=$p(IROut48Intubats,CHR2,ind)
		Continue:idxID=""
		Continue:($listfind(idxLB,idxID)>0)
		Set idxLB=idxLB_$lb(idxID)
		Set objIdxID=##class(DHCHAI.BT.Dictionary).GetObjById(idxID) 
		Continue:'$IsObject(objIdxID)
		Do obj.IROut48Intubats.Insert(objIdxID)
	}
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set ReportID=obj.%Id()
		Set return=ReportID
		Set ^TMP($j,"SyncInfRep","DHCHAI.IR.INFReport",ReportID)=OldReportID
		Set ActInfo=IRRepDate_"^"_IRRepTime_"^"_IRRepUser
		Set flg=##class(DHCHAI.IR.INFRepExt).SaveRepExt(ReportID,"DHCHAI.IR.INFDiagnos",LinkDiagDrs,ActInfo)
		Set flg=##class(DHCHAI.IR.INFRepExt).SaveRepExt(ReportID,"DHCHAI.IR.INFICD",LinkICDDrs,ActInfo)
		Set flg=##class(DHCHAI.IR.INFRepExt).SaveRepExt(ReportID,"DHCHAI.IR.INFLab",LinkLabDrs,ActInfo)
		Set flg=##class(DHCHAI.IR.INFRepExt).SaveRepExt(ReportID,"DHCHAI.IR.INFAnti",LinkAntiDrs,ActInfo)
		Set flg=##class(DHCHAI.IR.INFRepExt).SaveRepExt(ReportID,"DHCHAI.IR.INFOPS",LinkOPSDrs,ActInfo)
		Set flg=##class(DHCHAI.IR.INFRepExt).SaveRepExt(ReportID,"DHCHAI.IR.INFMBR",LinkMRBDrs,ActInfo)
		Set flg=##class(DHCHAI.IR.INFRepExt).SaveRepExt(ReportID,"DHCHAI.IR.INFInvOper",LinkInvOperDrs,ActInfo)
		Set flg=##class(DHCHAI.IR.INFRepExt).SaveRepExt(ReportID,"DHCHAI.IR.INFPreFactor",LinkPreFactDrs,ActInfo)
		Set flg=##class(DHCHAI.IR.INFRepExt).SaveRepExt(ReportID,"DHCHAI.IR.INFICUUC",LinkICUUCDrs,ActInfo)
		Set flg=##class(DHCHAI.IR.INFRepExt).SaveRepExt(ReportID,"DHCHAI.IR.INFICUVAP",LinkICUVAPDrs,ActInfo)
		Set flg=##class(DHCHAI.IR.INFRepExt).SaveRepExt(ReportID,"DHCHAI.IR.INFICUPICC",LinkICUPICCDrs,ActInfo)
		Set flg=##class(DHCHAI.IR.INFRepExt).SaveRepExt(ReportID,"DHCHAI.IR.INFCSS",LinkCSSDrs,ActInfo)
		// add by zhoubo 
		Set flg=##class(DHCHAI.IR.INFRepExt).SaveRepExt(ReportID,"DHCHAI.IR.INFReport",ReportID,ActInfo)
	}
	Do obj.%Close()
	Kill ^TMP($j,"SyncInfRep","DHCHAI.IR.INFReport")
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-10-20
/// Description:  取报告扩展信息
/// Table：       DHCHAI.IR.INFReport、DHCHAI.IR.INFRepExt
/// Input：       aDataType : DHCHAI.IR.INFRepExt.IRDataType
/// Return：      返回obj
/// s obj=##class(DHCHAI.IR.INFReport).GetObjById(2)
/// w obj.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
Method GetRepLinkIDs(aDataType As %String) As %String
{
	New (aDataType)
	Set return=""
	Quit:aDataType="" return
	
	Set ReportID=..%Id()
	Quit:ReportID="" return
	
	Set Count=0
	Set xSub=0
	For {
		Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt(aDataType,"U"),ReportID,xSub))
		Quit:xSub=""
		
		Set RepExtID=ReportID_"||"_xSub
		Set obj=##class(DHCHAI.IR.INFRepExt).GetObjById(RepExtID)
		Continue:'$IsObject(obj)
		Set ObjectID=obj.IRObjectID
		Continue:ObjectID=""
		Set return=return_","_ObjectID
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-10-20
/// Description:  取报告扩展信息
/// Table：       DHCHAI.IR.INFReport、DHCHAI.IR.INFRepExt
/// Input：       aDataType : DHCHAI.IR.INFRepExt.IRDataType
/// Return：      返回obj
/// s obj=##class(DHCHAI.IR.INFReport).GetObjById(2)
/// s arr=obj.GetRepLinkObjs("DHCHAI.IR.INFDiagnos")
Method GetRepLinkObjs(aDataType As %String) As %ArrayOfObjects
{
	New (aDataType)
	Set return=##class(%ArrayOfObjects).%New()
	Quit:aDataType="" return
	
	Set ObjectIDs=..GetRepLinkIDs(aDataType)
	Quit:ObjectIDs="" return
	
	Set Count=0
	For indO=1:1:$l(ObjectIDs,",") {
		Set ObjectID=$p(ObjectIDs,",",indO)
		Continue:ObjectID=""
		
		Set obj=""
		Set:aDataType="DHCHAI.IR.INFDiagnos" obj=##class(DHCHAI.IR.INFDiagnos).GetObjById(ObjectID)
		Set:aDataType="DHCHAI.IR.INFICD" obj=##class(DHCHAI.IR.INFICD).GetObjById(ObjectID)
		Set:aDataType="DHCHAI.IR.INFLab" obj=##class(DHCHAI.IR.INFLab).GetObjById(ObjectID)
		Set:aDataType="DHCHAI.IR.INFAnti" obj=##class(DHCHAI.IR.INFAnti).GetObjById(ObjectID)
		Set:aDataType="DHCHAI.IR.INFOPS" obj=##class(DHCHAI.IR.INFOPS).GetObjById(ObjectID)
		Set:aDataType="DHCHAI.IR.INFMBR" obj=##class(DHCHAI.IR.INFMBR).GetObjById(ObjectID)
		Set:aDataType="DHCHAI.IR.INFInvOper" obj=##class(DHCHAI.IR.INFInvOper).GetObjById(ObjectID)
		Set:aDataType="DHCHAI.IR.INFPreFactor" obj=##class(DHCHAI.IR.INFPreFactor).GetObjById(ObjectID)
		Set:aDataType="DHCHAI.IR.INFICUUC" obj=##class(DHCHAI.IR.INFICUUC).GetObjById(ObjectID)
		Set:aDataType="DHCHAI.IR.INFICUVAP" obj=##class(DHCHAI.IR.INFICUVAP).GetObjById(ObjectID)
		Set:aDataType="DHCHAI.IR.INFICUPICC" obj=##class(DHCHAI.IR.INFICUPICC).GetObjById(ObjectID)
		Continue:obj=""
		
		Set Count=Count+1
		Do return.SetAt(obj,Count)
	}
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  删除医院感染报告信息
/// Table：       DHCHAI.IR.INFReport
/// Input：       Id : DHCHAI.IR.INFReport.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.INFReport).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.INFReport).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-04-12
/// Description:  处理医院感染报告多条感染信息问题
/// Table：       DHCHAI.IR.INFReport
/// w ##class(DHCHAI.IR.INFReport).CheckRepDiagnos()
ClassMethod CheckRepDiagnos() As %String
{
	Set return=""
    
    Set Count=0
    
    Set xID=""
    For {
		Set xID=$o(^DHCHAI.IR.INFReportD(xID))
	   	Quit:xID=""
	   	
	   	Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(xID)
	   	Continue:'$IsObject(objRep)
		Continue:'$IsObject(objRep.IRStatusDr)
	   	Continue:(objRep.IRRepType'=1)
	   	Set LinkDiags = objRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
	   	Continue:$l(LinkDiags,",")<2  //少于两条感染信息不做处理
				 
		Set LinkICDs       = objRep.GetRepLinkIDs("DHCHAI.IR.INFICD")
		Set LinkLabs       = objRep.GetRepLinkIDs("DHCHAI.IR.INFLab")
		Set LinkAntis      = objRep.GetRepLinkIDs("DHCHAI.IR.INFAnti")
		Set LinkOPSs       = objRep.GetRepLinkIDs("DHCHAI.IR.INFOPS")
		Set LinkInvOpers   = objRep.GetRepLinkIDs("DHCHAI.IR.INFInvOper")
		Set LinkPreFactors = objRep.GetRepLinkIDs("DHCHAI.IR.INFPreFactor")
	  
	   	For indx = 2:1:$l(LinkDiags,","){ //从第二条感染信息开始
			Set xDiagID = $p(LinkDiags,",",indx)
			Continue:xDiagID=""
			
			Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
			Continue:'$IsObject(objDiags)
			
			Set obj=##class(DHCHAI.IR.INFReport).%New()  //生成新报告DHCHAI.IR.INFReport
			Set obj.IREpisodeDr = objRep.IREpisodeDr
			Set obj.IRRepType   = objRep.IRRepType
			Set obj.IRRepDate   = objRep.IRRepDate
			Set obj.IRRepTime   = objRep.IRRepTime
			Set obj.IRRepLocDr  = objRep.IRRepLocDr
			Set obj.IRRepUser   = objRep.IRRepUser
			Set obj.IRStatusDr  = objRep.IRStatusDr
			Set obj.IRInLocDr   = objRep.IRInLocDr
			Set obj.IROutLocDr  = objRep.IROutLocDr
			Set obj.IRInDate    = objRep.IRInDate
			Set obj.IROutDate   = objRep.IROutDate
			Set obj.IRAPACHEScore  = objRep.IRAPACHEScore
			Set obj.IROutIntubats  = objRep.IROutIntubats
			Set obj.IROut48Intubats = objRep.IROut48Intubats
		
			Set sc=obj.%Save()
			If $system.Status.IsError(sc) {        //检查Save是否成功
		   		Do $system.OBJ.DisplayError(sc) 
		   		Set return=-1
			}Else{  //生成DHCHAI.IR.INFRepExt
				Set ReportID=obj.%Id()
				Set ActInfo=objRep.IRRepDate_"^"_objRep.IRRepTime_"^"_objRep.IRRepUser.%Id()
				Set flg=##class(DHCHAI.IR.INFRepExt).SaveRepExt(ReportID,"DHCHAI.IR.INFDiagnos",xDiagID,ActInfo)
				Set flg=##class(DHCHAI.IR.INFRepExt).SaveRepExt(ReportID,"DHCHAI.IR.INFICD",LinkICDs,ActInfo)
				Set flg=##class(DHCHAI.IR.INFRepExt).SaveRepExt(ReportID,"DHCHAI.IR.INFLab",LinkLabs,ActInfo)
				Set flg=##class(DHCHAI.IR.INFRepExt).SaveRepExt(ReportID,"DHCHAI.IR.INFAnti",LinkAntis,ActInfo)
				Set flg=##class(DHCHAI.IR.INFRepExt).SaveRepExt(ReportID,"DHCHAI.IR.INFOPS",LinkOPSs,ActInfo)
				Set flg=##class(DHCHAI.IR.INFRepExt).SaveRepExt(ReportID,"DHCHAI.IR.INFInvOper",LinkInvOpers,ActInfo)
				Set flg=##class(DHCHAI.IR.INFRepExt).SaveRepExt(ReportID,"DHCHAI.IR.INFPreFactor",LinkPreFactors,ActInfo)
				
				Set xLogSubID = ""
				For {
					Set xLogSubID = $o(^DHCHAI.IR.INFReportD(xID,"LOG",xLogSubID))
					Quit:xLogSubID=""
					Set xLogID = xID_"||"_xLogSubID
					Set objLog = ##class(DHCHAI.IR.INFRepLog).GetObjById(xLogID)
					Continue:'$IsObject(objLog)
					
					Set StatusDr  = objLog.IRStatusDr.%Id()
					Set Opinion   = objLog.IROpinion
					Set UpdateDate  = objLog.IRUpdateDate
					Set UpdateTime  = objLog.IRUpdateTime
					Set UpdateUserDr = objLog.IRUpdateUserDr.%Id()
					Set LogInfo = ReportID_"^"_StatusDr_"^"_Opinion_"^"_UpdateDate_"^"_UpdateTime_"^"_UpdateUserDr
				
					Set flg =##Class(DHCHAI.IR.INFRepLog).Update(LogInfo,"^")
					Continue:flg<0
				}					
			}
			Do obj.%Close()
			
			//删除已保存的感染诊断信息	
			Set xRepID=$o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," "_$zcvt("DHCHAI.IR.INFDiagnos","U")," "_xDiagID,xID,0))
		    Set flg=##class(DHCHAI.IR.INFRepExt).DeleteById(xID_"||"_xRepID)
   		}
   		Set Count=Count+1		
    }
    Set return = Count
    
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2022-02-17
/// Description:  处理历史医院感染报告无病原学、抗菌药物、手术信息影响改造后界面显示效果问题
/// Table：       DHCHAI.IR.INFReport
/// w ##class(DHCHAI.IR.INFReport).CheckRepLabAntOpr()
ClassMethod CheckRepLabAntOpr() As %String
{
	Set return=""
    
    Set Count=0
    
    Set xID=""
    For {
		Set xID=$o(^DHCHAI.IR.INFReportD(xID))
	   	Quit:xID=""
	   	
	   	Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(xID)
	   	Continue:'$IsObject(objRep)
		Continue:'$IsObject(objRep.IRStatusDr)
	   	Continue:(objRep.IRRepType'=1)
	   	Set IsInfLab  = objRep.IRIsInfLab
	   	Set IsInfAnti = objRep.IRIsInfAnti
	   	Set IsInfOpr  = objRep.IRIsInfOpr
		Continue:(IsInfLab'="")&&(IsInfAnti'="")&&(IsInfOpr'="")
	
		Set LinkLabs   = objRep.GetRepLinkIDs("DHCHAI.IR.INFLab")
		Set LinkAntis  = objRep.GetRepLinkIDs("DHCHAI.IR.INFAnti")
		Set LinkOPSs   = objRep.GetRepLinkIDs("DHCHAI.IR.INFOPS")
         
	    Set (InfLab,InfAnti,InfOpr)=0
		Set:LinkLabs'="" InfLab=1
		Set:LinkAntis'="" InfAnti=1
		Set:LinkOPSs'="" InfOpr=1
		w !,xID," ",LinkLabs," ",LinkAntis," ",LinkOPSs
		Set obj=##class(DHCHAI.IR.INFReport).%OpenId(xID)  
		Set obj.IRIsInfLab  = InfLab
		Set obj.IRIsInfAnti = InfAnti
		Set obj.IRIsInfOpr  = InfOpr
		
		Set sc=obj.%Save()
		If $system.Status.IsError(sc) {        //检查Save是否成功
	   		Do $system.OBJ.DisplayError(sc) 
	   		Set return=-1
		}Else {
			Set return=obj.%Id()
			Set Count=Count+1	
		}
		Do obj.%Close()
   			
    }
    Set return = Count
    
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2020-10-09
/// Description:  根据报告ID判断报告类型
/// Table：       DHCHAI.IR.INFReport
/// w ##class(DHCHAI.IR.INFReport).GetRepType()
ClassMethod GetRepType(aID As %String) As %String
{
	New (aID)
	Set return=""
	   	
   	Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(aID)
   	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.IRStatusDr) return
   	Set RepType = objRep.IRRepType 
   	Set return = RepType
	Quit return
}

/// Creator：     ShenC
/// CreatDate：   2021-09-09
/// Description:  更新院感报告代报标志(1/0)
/// Table：       DHCHAI.IR.INFReport
/// w ##class(DHCHAI.IR.INFReport).UpdateReplaceFlag(1,1)
ClassMethod UpdateReplaceFlag(aRepID As %String, aReplaceFlag As %String) As %String
{
	New (aRepID,aReplaceFlag)
	Set return=""
	Quit:(aRepID="")||(aReplaceFlag="") return
	   
   	Set obj=##class(DHCHAI.IR.INFReport).%OpenId(aRepID)
	Quit:'$IsObject(obj) return
	//保存标志
	Set obj.IRReplaceFlag=aReplaceFlag
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
   	Quit return
}

Storage Default
{
<Data name="INFReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IREpisodeDr</Value>
</Value>
<Value name="3">
<Value>IRRepType</Value>
</Value>
<Value name="4">
<Value>IRRepDate</Value>
</Value>
<Value name="5">
<Value>IRRepTime</Value>
</Value>
<Value name="6">
<Value>IRRepLocDr</Value>
</Value>
<Value name="7">
<Value>IRRepUser</Value>
</Value>
<Value name="8">
<Value>IRStatusDr</Value>
</Value>
<Value name="9">
<Value>IRInLocDr</Value>
</Value>
<Value name="10">
<Value>IROutLocDr</Value>
</Value>
<Value name="11">
<Value>IRInDate</Value>
</Value>
<Value name="12">
<Value>IROutDate</Value>
</Value>
<Value name="13">
<Value>IRAPACHEScore</Value>
</Value>
<Value name="14">
<Value>IROutIntubats</Value>
</Value>
<Value name="15">
<Value>IROut48Intubats</Value>
</Value>
<Value name="16">
<Value>IRReplaceFlag</Value>
</Value>
<Value name="17">
<Value>IRIsInfLab</Value>
</Value>
<Value name="18">
<Value>IRIsInfAnti</Value>
</Value>
<Value name="19">
<Value>IRIsInfOpr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.INFReportD</DataLocation>
<DefaultData>INFReportDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.INFReportD</IdLocation>
<IndexLocation>^DHCHAI.IR.INFReportI</IndexLocation>
<StreamLocation>^DHCHAI.IR.INFReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
