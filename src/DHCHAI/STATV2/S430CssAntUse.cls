/// 名称: DHCHAI.STATV2.S430CssAntUse
/// 描述: 抗菌药物使用情况汇总表
/// 编写者：zhoubo
/// 编写日期: 2019-11-20
Class DHCHAI.STATV2.S430CssAntUse Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2019-11-20
/// Description:  抗菌药物使用情况统计
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aSurNumID ：调查ID
/// 			  aStaType ：科室/病区类型 
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S430CssAntUse","CssQryAntUse","2","W","","6,7")
Query CssQryAntUse(aSurNumID As %String, aStaType As %String, aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "SurNumber:%String,DimensKey:%String,DimensDesc:%String,HospSurSum:%String,HospAntUse:%String,HospAntUseZL:%String,AntUseZLRatio:%String,HospAntUseYF:%String,AntUseYFRatio:%String,HospAntUseZLYF:%String,AntUseZLYFRatio:%String,HospAntUseWZZ:%String,HospAntUseQT:%String,HospAntUseDL:%String,AntUseDLRatio:%String,HospAntUseEL:%String,AntUseELRatio:%String,HospAntUseSL:%String,AntUseSLRatio:%String,HospAntUseESIL:%String,AntUseESILRatio:%String,HospAntUseSLYS:%String,AntUseSLYSRatio:%String") [ SqlProc ]
{
}

ClassMethod CssQryAntUseExecute(ByRef qHandle As %Binary, aSurNumID As %String, aStaType As %String, aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Quit:(aSurNumID="") $$$OK
    Set SurvData = $g(^DHCHAI.IR.SurveyExecD(aSurNumID))
    Quit:SurvData="" $$$OK
    Set DateFrom = $li(SurvData,5)    //通过调查定义表取开始结束日期
    Set DateTo   = $li(SurvData,6)
    Set SurNumber = $li(SurvData,2)
    Set HospDr    = $li(SurvData,3)
    Quit:HospDr="" $$$OK
    Set HospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(HospDr,"|")
    Set DateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DateFrom)
    Set DateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DateTo)
    
    /// 取所有需要调查的科室  默认是全院科室    
    Set NIndex="CssQryAntUse"
    Kill ^TMP($zn,$j,NIndex)
    
    Set StatDimensStr = aStatDimens
    Set:StatDimensStr="" StatDimensStr=..GetStatDimensStr(aStaType)
    Quit:StatDimensStr="" $$$OK
    Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
    Set:StatType'="W" StatType="E"  //不是病区就是科室
    Set LocCount=$l(aLocIDs,",")  //科室、病区入参个数
    
    //同期在科:某段时间的在科人数
    Set LocEpisArray=##class(DHCHAI.IRS.UtilHCSSSrv).GetLocEpisByBed(HospDr,DateFrom,DateTo,StatType)         //##class(DHCHAI.DPS.PAAdmTransSrv).GetCSSEpisByLocDate(StatType,aDateFrom,aDateTo,"")
 
    For index1=1:1:LocEpisArray.Count() {
        Set TransInfo=LocEpisArray.GetAt(index1)   
        Continue:TransInfo=""
        
        Set LocDr   = $LIST(TransInfo,1)
        Set Paadm  = $LIST(TransInfo,2)
        //未调查
        Continue:'..CheckCssRep(aSurNumID,Paadm)
        Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
        Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
        Set HospDr  = $li(LocData,8)
        Continue:(HospIDs'="")&&($listfind(HospIDs,HospDr)<1)
        Set GroupDr  = $li(LocData,7)
        If GroupDr="" {
            Set GroupDesc="其他科"
            Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
        }
        Set LocDesc=""
        If LocData'="" {
            Set LocDesc2   = $li(LocData,4)
            Set tmpLocDesc = $li(LocData,3)
            Set LocDesc = $s(LocDesc2'="":LocDesc2,1:tmpLocDesc)
        }

        Set AntDescs =..GetAntInfoByCss(aSurNumID,Paadm)
		Set (AntFlg,Pos,Com)=""
		If (AntDescs'="") {
			Set AntFlg = +$p(AntDescs,"^",1)
			Set Pos=$p(AntDescs,"^",2)  //目的
			Set Com=$p(AntDescs,"^",3)  //联合
		}
		//统计维度
        Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,LocDr)
		Continue:StatDimensInfo=""
		For indDimens=1:1:$l(StatDimensInfo,"^") {
			Set DimensKey=$p(StatDimensInfo,"^",indDimens)
			Continue:DimensKey=""
			
			// 实查人数
			Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"SurPat"))
			// 全院抗菌用药人数
			If (AntFlg=1){
				Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUse"))
				if ((Pos="治疗")||(Pos="治疗用药")){
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseZL"))
				}ElseIf ((Pos="预防")||(Pos="预防用药")){
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseYF"))
				}ElseIf (Pos="治疗+预防"){
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseZLYF"))
				}ElseIf (Pos="无指征"){
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseWZZ"))
				}Else{
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseQT"))
				}
				//全院联用
				If (Com="一联"){
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseDL"))
				}
				ElseIf (Com="二联"){
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseEL"))
				}
				ElseIf (Com="三联"){
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseSL"))
				}
				ElseIf (Com="四联及以上"){
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseESIL"))
				}Else{
					//四联以上
					//Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseSLYS"))
				}
			}
		}
	}
	
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListToString(HospIDs,"|")
	// 输出Data
	Set ArryStatDimens=..GetArrayStatDimens(StatDimensStr,aHospIDs,"","","","I")
	Set xDimensKey=""
	For DimIndx=1:1:ArryStatDimens.Count() {
		Set DimList=ArryStatDimens.GetAt(DimIndx)
		Set xDimensKey	=$lg(DimList,1)
		Set DimensDesc	=$lg(DimList,3)
		Set IsActive	=$lg(DimList,4)
		Continue:xDimensKey=""
        Set LocDr = +$p(xDimensKey,"-",3)
        Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
        // 全院
        Set HospSurSum     =+$g(^TMP($zn,$j,NIndex,xDimensKey,"SurPat"))  //全院实查人
        Set HospAntUse     =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUse"))
        Set HospAntUseZL   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseZL"))
        Set HospAntUseYF   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseYF"))
        Set HospAntUseZLYF =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseZLYF"))  
        Set HospAntUseWZZ  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseWZZ")) 
        Set HospAntUseQT   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseQT")) 
        Set HospAntUseDL   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseDL"))
        Set HospAntUseEL   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseEL")) 
        Set HospAntUseSL   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseSL"))  
        Set HospAntUseESIL   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseESIL")) 
        Set HospAntUseSLYS   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseSLYS")) 
        
        Set (AntUseZLRatio,AntUseYFRatio,AntUseZLYFRatio)="0.00%"
        Set:HospAntUse>0 AntUseZLRatio=$fn((HospAntUseZL/HospAntUse)*100,"",2)_"%" //治疗占比
        Set:HospAntUse>0 AntUseYFRatio=$fn((HospAntUseYF/HospAntUse)*100,"",2)_"%" //治疗占比
        Set:HospAntUse>0 AntUseZLYFRatio=$fn((HospAntUseZLYF/HospAntUse)*100,"",2)_"%" //治疗占比
        Set (AntUseDLRatio,AntUseELRatio,AntUseSLRatio,AntUseESILRatio,AntUseSLYSRatio)="0.00%"
        Set:HospAntUse>0 AntUseDLRatio=$fn((HospAntUseDL/HospAntUse)*100,"",2)_"%" //联用占比
        Set:HospAntUse>0 AntUseELRatio=$fn((HospAntUseEL/HospAntUse)*100,"",2)_"%" //联用占比
        Set:HospAntUse>0 AntUseSLRatio=$fn((HospAntUseSL/HospAntUse)*100,"",2)_"%" //联用占比
        Set:HospAntUse>0 AntUseESILRatio=$fn((HospAntUseESIL/HospAntUse)*100,"",2)_"%" //联用占比
        Set:HospAntUse>0 AntUseSLYSRatio=$fn((HospAntUseSLYS/HospAntUse)*100,"",2)_"%" //联用占比
        
        Set:xDimensKey'="" xDimensKey=xDimensKey_"-"_aStaType
        
        Set Data=$lb(SurNumber,xDimensKey,DimensDesc,HospSurSum,HospAntUse,HospAntUseZL,AntUseZLRatio,HospAntUseYF,AntUseYFRatio,HospAntUseZLYF,AntUseZLYFRatio,HospAntUseWZZ,HospAntUseQT)
        Set Data=Data_$lb(HospAntUseDL,AntUseDLRatio,HospAntUseEL,AntUseELRatio,HospAntUseSL,AntUseSLRatio,HospAntUseESIL,AntUseESILRatio,HospAntUseSLYS,AntUseSLYSRatio)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
        If (LocCount>1) {
            Set ^TMP($zn,$j,NIndex,"Sum","SurPat") = HospSurSum +$g(^TMP($zn,$j,NIndex,"Sum","SurPat"))  //全院实查人
            Set ^TMP($zn,$j,NIndex,"Sum","AntUse") = HospAntUse +$g(^TMP($zn,$j,NIndex,"Sum","AntUse"))
            Set ^TMP($zn,$j,NIndex,"Sum","AntUseZL") = HospAntUseZL +$g(^TMP($zn,$j,NIndex,"Sum","AntUseZL"))
            Set ^TMP($zn,$j,NIndex,"Sum","AntUseYF") = HospAntUseYF +$g(^TMP($zn,$j,NIndex,"Sum","AntUseYF"))
            Set ^TMP($zn,$j,NIndex,"Sum","AntUseZLYF") = HospAntUseZLYF +$g(^TMP($zn,$j,NIndex,"Sum","AntUseZLYF"))  
            Set ^TMP($zn,$j,NIndex,"Sum","AntUseWZZ") = HospAntUseWZZ +$g(^TMP($zn,$j,NIndex,"Sum","AntUseWZZ")) 
            Set ^TMP($zn,$j,NIndex,"Sum","AntUseQT") = HospAntUseQT +$g(^TMP($zn,$j,NIndex,"Sum","AntUseQT")) 
            Set ^TMP($zn,$j,NIndex,"Sum","AntUseDL") = HospAntUseDL +$g(^TMP($zn,$j,NIndex,"Sum","AntUseDL"))
            Set ^TMP($zn,$j,NIndex,"Sum","AntUseEL") = HospAntUseEL +$g(^TMP($zn,$j,NIndex,"Sum","AntUseEL")) 
            Set ^TMP($zn,$j,NIndex,"Sum","AntUseSL") = +$g(^TMP($zn,$j,NIndex,"Sum","AntUseSL"))  
            Set ^TMP($zn,$j,NIndex,"Sum","AntUseESIL") = HospAntUseESIL +$g(^TMP($zn,$j,NIndex,"Sum","AntUseESIL")) 
            Set ^TMP($zn,$j,NIndex,"Sum","AntUseSLYS") = HospAntUseSLYS +$g(^TMP($zn,$j,NIndex,"Sum","AntUseSLYS")) 
        }
    }
    If (LocCount>1) {
        Set HospSurSum     =+$g(^TMP($zn,$j,NIndex,"Sum","SurPat"))  //全院实查人
        Set HospAntUse     =+$g(^TMP($zn,$j,NIndex,"Sum","AntUse"))
        Set HospAntUseZL   =+$g(^TMP($zn,$j,NIndex,"Sum","AntUseZL"))
        Set HospAntUseYF   =+$g(^TMP($zn,$j,NIndex,"Sum","AntUseYF"))
        Set HospAntUseZLYF =+$g(^TMP($zn,$j,NIndex,"Sum","AntUseZLYF"))  
        Set HospAntUseWZZ  =+$g(^TMP($zn,$j,NIndex,"Sum","AntUseWZZ")) 
        Set HospAntUseQT   =+$g(^TMP($zn,$j,NIndex,"Sum","AntUseQT")) 
        Set HospAntUseDL   =+$g(^TMP($zn,$j,NIndex,"Sum","AntUseDL"))
        Set HospAntUseEL   =+$g(^TMP($zn,$j,NIndex,"Sum","AntUseEL")) 
        Set HospAntUseSL   =+$g(^TMP($zn,$j,NIndex,"Sum","AntUseSL"))  
        Set HospAntUseESIL   =+$g(^TMP($zn,$j,NIndex,"Sum","AntUseESIL")) 
        Set HospAntUseSLYS   =+$g(^TMP($zn,$j,NIndex,"Sum","AntUseSLYS")) 
        Set (AntUseZLRatio,AntUseYFRatio,AntUseZLYFRatio)="0.00%"
        Set:HospAntUse>0 AntUseZLRatio=$fn((HospAntUseZL/HospAntUse)*100,"",2)_"%" //治疗占比
        Set:HospAntUse>0 AntUseYFRatio=$fn((HospAntUseYF/HospAntUse)*100,"",2)_"%" //治疗占比
        Set:HospAntUse>0 AntUseZLYFRatio=$fn((HospAntUseZLYF/HospAntUse)*100,"",2)_"%" //治疗占比
        Set (AntUseDLRatio,AntUseELRatio,AntUseSLRatio,AntUseESILRatio,AntUseSLYSRatio)="0.00%"
        Set:HospAntUse>0 AntUseDLRatio=$fn((HospAntUseDL/HospAntUse)*100,"",2)_"%" //联用占比
        Set:HospAntUse>0 AntUseELRatio=$fn((HospAntUseEL/HospAntUse)*100,"",2)_"%" //联用占比
        Set:HospAntUse>0 AntUseSLRatio=$fn((HospAntUseSL/HospAntUse)*100,"",2)_"%" //联用占比
        Set:HospAntUse>0 AntUseESILRatio=$fn((HospAntUseESIL/HospAntUse)*100,"",2)_"%" //联用占比
        Set:HospAntUse>0 AntUseSLYSRatio=$fn((HospAntUseSLYS/HospAntUse)*100,"",2)_"%" //联用占比
        
        Set:xDimensKey'="" xDimensKey=xDimensKey_"-"_aStaType
        Set Data=$lb(SurNumber,"","全部",HospSurSum,HospAntUse,HospAntUseZL,AntUseZLRatio,HospAntUseYF,AntUseYFRatio,HospAntUseZLYF,AntUseZLYFRatio,HospAntUseWZZ,HospAntUseQT)
        Set Data=Data_$lb(HospAntUseDL,AntUseDLRatio,HospAntUseEL,AntUseELRatio,HospAntUseSL,AntUseSLRatio,HospAntUseESIL,AntUseESILRatio,HospAntUseSLYS,AntUseSLYSRatio)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
    }
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod CssQryAntUseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CssQryAntUseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CssQryAntUseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CssQryAntUseExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhoubo
/// CreatDate：   2019-11-20
/// Description:  抗菌药物使用情况病人明细
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aSurNumID ：调查ID
/// 			  aDimensKey: 维度
///               aStaType : 统计类型
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S430CssAntUse","CssQryAntUseDtl","2","0001-00-0000-H-1","W","","","1","6,7")
Query CssQryAntUseDtl(aSurNumID As %String, aDimensKey As %String, aStaType As %String, aAntiPos As %String = "", aAntiCom As %String = "", aCssFlg As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupDr:%String,GroupDesc:%String,LocID:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,AntFlg:%String,AntiPos:%String,AntiCom:%String") [ SqlProc ]
{
}

ClassMethod CssQryAntUseDtlExecute(ByRef qHandle As %Binary, aSurNumID As %String, aDimensKey As %String, aStaType As %String, aAntiPos As %String = "", aAntiCom As %String = "", aCssFlg As %String = "", aLocIDs As %Text = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Quit:(aSurNumID="") $$$OK
    Set SurvData = $g(^DHCHAI.IR.SurveyExecD(aSurNumID))
    Quit:SurvData="" $$$OK
    Set DateFrom = $li(SurvData,5)    //通过调查定义表取开始结束日期
    Set DateTo   = $li(SurvData,6)
    Set SurNumber = $li(SurvData,2)
    Set HospDr   = $li(SurvData,3)
    Quit:HospDr="" $$$OK
    
    Set DateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DateFrom)
    Set DateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DateTo)
    
    Set DimensMark  = $p(aDimensKey,"-",4)  
    Set aLocType   = $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")
    Set aLocGroup   = $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")
    Set aLocDr=""
    Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
    
    Set StaType =$p(aDimensKey,"-",$l(aDimensKey,"-"))          //1.统计类型(W|E)-aLocType
    Set aHospIDs    = +$p(aDimensKey,"-",1)                     //2.统计院区-aHospIDs
    Set:aHospIDs="0" aHospIDs=""    
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set HospGrpDr=""
    Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)
    Set StatType=aLocType
    Set:StatType'="W" StatType="E"  //不是病区就是科室
    Set:aLocType="" StatType=aStaType
    Set aAntiPos=$Case(aAntiPos,"ZL":"治疗用药","YF":"预防用药","ZLYF":"治疗+预防","WZZ":"无指征",:aAntiPos)    //因为不识别治疗+预防 所以传参用编码替换
    Set aAntiCom=$Case(aAntiCom,"1":"一联","2":"二联","3":"三联","4":"四联及以上",:"")
    Set NIndex="CssQryAntUseDtl"
    Kill ^TMP($zn,$j,NIndex)

    //横断面调查病人就诊列表
    Set LocEpisArray=##class(DHCHAI.IRS.UtilHCSSSrv).GetLocEpisByBed(HospDr,DateFrom,DateTo,StatType)         
    Set xPaadms=""
 
    For index1=1:1:LocEpisArray.Count() {
        Set TransInfo=LocEpisArray.GetAt(index1)   
        Continue:TransInfo=""
        
        Set LocID   = $LIST(TransInfo,1)
        Set Paadm  = $LIST(TransInfo,2)
        Set TransID = $LIST(TransInfo,3)
        //未调查
        Continue:'..CheckCssRep(aSurNumID,Paadm)
        Continue:(aLocDr'="")&(aLocDr'=LocID)
        Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocID_","))
        Set TransData = $g(^DHCHAI.DP.PAAdmTransD(TransID))
        Continue:TransData=""
        Set TransType=$li(TransData,4)
        Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
        Set HospDr  = $li(LocData,8)
        //医院分组过滤
        Continue:HospDr=""
        Set HospInfo="",HospGroupDr=""
        Set HospInfo=$g(^DHCHAI.BT.HospitalD(HospDr))
        Set HospDesc=$lg(HospInfo,3)
        Set HospGroupDr=$lg(HospInfo,5)
        Continue:(HospGrpDr'="")&&(HospGroupDr'=HospGrpDr)      
        //院区过滤
        Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
        Set HospGrpInfo=$g(^DHCHAI.BT.HospGroupD(+HospGroupDr)) 
        Set HospGrpDesc=$lg(HospGrpInfo,3)   
        Set:HospGrpDesc="" HospGrpDesc="全院" 
		Set GroupDr  = $li(LocData,7)
		If GroupDr="" {
			Set GroupDesc="其他科"
			Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
		}Else{
			Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupDr))
			Set GroupDesc=$li(GroupData,3)
		}
		Set LocDesc=""
		If LocData'="" {
			Set LocDesc2   = $li(LocData,4)
			Set tmpLocDesc = $li(LocData,3)
			Set LocDesc = $s(LocDesc2'="":LocDesc2,1:tmpLocDesc)
		}

		Set TransDate=$li(TransData,7)
		Set:TransDate'="" TransDate=$zd(TransDate,3)
		Set TransTime=$li(TransData,8)
		Set:TransTime'="" TransTime=$zt(TransTime,1)
		Set OutLocDate=$li(TransData,10)
		Set:OutLocDate'="" OutLocDate=$zd(OutLocDate,3)
		Set OutLocTime=$li(TransData,11)
		Set:OutLocTime'="" OutLocTime=$zt(OutLocTime,1)
		Set TransDateTime=TransDate_" "_TransTime
		Set OutLocDateTime=OutLocDate_" "_OutLocTime
		
		//按科室组、科室/病区过滤
		Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)

        Set AntDescs =..GetAntInfoByCss(aSurNumID,Paadm)
        Set (AntFlg,AntiPos,AntiCom)=""
        If (AntDescs'="") {
            Set AntFlg = +$p(AntDescs,"^",1)
            Set AntiPos=$p(AntDescs,"^",2)  //目的
            Set AntiCom=$p(AntDescs,"^",3)  //联合
        }

        Continue:(aCssFlg="")&&(AntFlg'="1")
        Continue:((aAntiPos'="")&&(aAntiPos'[AntiPos))
        Continue:((aAntiCom'="")&&(aAntiCom'=AntiCom))
        Set AntFlg=$s(AntFlg=1: "是",1:"否")
        Set PatData =..BuildPaadmData(Paadm)
        Continue:PatData=""
        //取统计维度
        Set DimensDesc =""
        Set:DimensMark="" DimensDesc="全部"
        Set:DimensMark="A" DimensDesc=HospGrpDesc
        Set:DimensMark="H" DimensDesc=HospDesc          //医院名称
        Set:DimensMark="G" DimensDesc=GroupDesc             //分组名称
        Set:(DimensMark="E")||(DimensMark="W") DimensDesc=LocDesc  //科室、病区名称
        Set AdmTimes = $lg($g(^DHCHAI.DP.PAAdmD(Paadm)),38)   //就诊次数

        Set Data=$lb(DimensDesc,AdmTimes)_PatData_$lb(TransID,GroupDr,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime,AntFlg,AntiPos,AntiCom)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod CssQryAntUseDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CssQryAntUseDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CssQryAntUseDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CssQryAntUseDtlExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhoubo
/// CreatDate：   2019-11-20
/// Description:  获取抗菌药物信息（此方法考虑作废）
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       抗菌药物信息
/// w ##class(DHCHAI.STATV2.S430CssAntUse).GetAntInfo("35","65410","65510")
ClassMethod GetAntInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=""
	Quit:((aEpisodeID="")||(aDateFrom="")||(aDateTo="")) return
	
	Set RepType="7"  //横断面调查

	Set xID = ""
	For {
		Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
		Quit:xID=""
		// Add by zhaoyj 2022-06-17 Global方式
		Set INFRepData=$g(^DHCHAI.IR.INFReportD(xID))
		Quit:INFRepData=""
		Set RepStatus=$lg(INFRepData,8)
		Continue:RepStatus=""        //1 保存 2 提交 3 审核 4 作废
		Continue:$lg($g(^DHCHAI.BT.DictionaryD(RepStatus)),2)="4"
		Set IRRepDate=$lg(INFRepData,4)
		//处理bug:zhoubo横断面抗菌药报表在取抗菌用药情况是进行了报告日期和横断面调查开始日期和结束日期的判断，
		//但如果医生确实是后面才进行了卡片的填写的话，就导致数据不会被统计到：可以计算到结束日期后面14天
		Continue:(IRRepDate<aDateFrom)||(IRRepDate>(aDateTo+14))
		Continue:return'=""
		
		Set LinkCSSs=""
		Set xSub=0
		For {
			Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFCSS","U"),xID,xSub))
			Quit:xSub=""
		
			Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xSub))
			Continue:INFRepExtData=""
			Set DataID=$lg(INFRepExtData,3)
			Continue:DataID=""
			Set LinkCSSs=LinkCSSs_","_DataID
		}
		Set:LinkCSSs'="" LinkCSSs=$e(LinkCSSs,2,$l(LinkCSSs))
		
		Continue:LinkCSSs=""
		Set xData = $g(^DHCHAI.IR.INFCSSD(+LinkCSSs))  //子父表一对一
		Continue:xData=""
		Set (AntUsePurpose,CombinedMed)=""
		Set AntiIsFlag    = $lg(xData,20)      //是否抗菌药物
		Set AntPur     = $lg(xData,22)
		Set:AntPur'="" AntUsePurpose=$lg($g(^DHCHAI.BT.DictionaryD(AntPur)),3)
		Set CombineMedDr = $lg(xData,23)
		Set:CombineMedDr'="" CombinedMed =$lg($g(^DHCHAI.BT.DictionaryD(CombineMedDr)),3)
		Set return = AntiIsFlag_"^"_AntUsePurpose_"^"_CombinedMed
    }
    Quit return
}

/// w ##class(DHCHAI.STATV2.S430CssAntUse).GetAntInfoByCss(,"393")
ClassMethod GetAntInfoByCss(aSurNumID As %String, aEpisodeID As %String) As %String
{
    New (aSurNumID,aEpisodeID)
    Set return=""
    Quit:(aSurNumID="")||(aEpisodeID="") return
    Set xCSSID=0
    For {
        Set xCSSID=$o(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,aEpisodeID,xCSSID))
        Quit:xCSSID=""
        
        Set CSSData=$g(^DHCHAI.IR.INFCSSD(xCSSID))
        Continue:CSSData=""
        Continue:$lg(CSSData,5)'=1
        Continue:$lg(CSSData,6)=""

        //过滤删除的报告
        Set ReportID=""
        Set arrReport=##class(DHCHAI.IR.INFRepExt).GetINFReportsAddID("DHCHAI.IR.INFCSS",xCSSID)
        For indRep=1:1:arrReport.Count() {
            Set RepData=arrReport.GetAt(indRep)
            Continue:RepData=""
            Set IRStatusDr=$lg(RepData,8)
            Continue:IRStatusDr=""
            Set RepStatus=$lg($g(^DHCHAI.BT.DictionaryD(IRStatusDr)),2)
            //1保存、2提交、3审核、4作废、5退回、6取消审核
            Continue:(RepStatus="4")
             Set ReportID=$lg(RepData,1)
        }
        Continue:ReportID=""
        Set xData = CSSData  //子父表一对一
        Set (AntUsePurpose,CombinedMed)=""
        Set AntiIsFlag    = $lg(xData,20)      //是否抗菌药物
        Set AntPur     = $lg(xData,22)
        Set:AntPur'="" AntUsePurpose=$lg($g(^DHCHAI.BT.DictionaryD(AntPur)),3)
        Set CombineMedDr = $lg(xData,23)
        Set:CombineMedDr'="" CombinedMed =$lg($g(^DHCHAI.BT.DictionaryD(CombineMedDr)),3)
        Set return = AntiIsFlag_"^"_AntUsePurpose_"^"_CombinedMed
    }
	Quit return
}

/*
/// Creator：     zhoubo
/// CreatDate：   2019-11-20
/// Description:  抗菌药物使用情况病人明细
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aSurNumID ：调查ID
///               aDimensKey: 维度
///               aStaType : 1:统计抗菌药物患者信息
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S430CssAntUse","ActQryAntUseDtl","2020-01-01","2021-01-01","0001-07-0099-W-4","W","预防用药","")
Query ActQryAntUseDtl(aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "1", aPurpose As %String, aComMed As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,GroupDesc:%String,LocDesc:%String,WardDesc:%String,TransDateTime:%String,OutLocDateTime:%String,AntFlg:%String,AntiPos:%String,AntiCom:%String") [ SqlProc ]
{
}

ClassMethod ActQryAntUseDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "1", aPurpose As %String = "", aComMed As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Quit:(aDateFrom="")||(aDateTo="") $$$OK
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
    Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
    Quit:(aDateFrom>aDateTo) $$$OK
 
    Set DimensMark  = $p(aDimensKey,"-",4)
    Set aHospIDs    = +$p(aDimensKey,"-",1)
    Set:+aHospIDs="0" aHospIDs=""
    Set aLocType    = $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")
    Set aLocGroup   = $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")
    Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
    
    Set NIndex="ActQryAntUseDtl"
    Kill ^TMP($zn,$j,NIndex)

    Set StatType=aLocType
    Set:StatType'="W" StatType="E"  //不是病区就是科室
    
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set StatType=aLocType
    Set:StatType'="W" StatType="E"  //不是病区就是科室
    
    
    set aSurNumID=0
    set RepID=""
    for{
        set aSurNumID=$o(^DHCHAI.IR.SurveyExecI("SurvNumber",aSurNumID))
        quit:aSurNumID=""
        set RepID = $o(^DHCHAI.IR.SurveyExecI("SurvNumber",aSurNumID,RepID))
        Set SurvData = $g(^DHCHAI.IR.SurveyExecD(RepID))
    
        Quit:SurvData="" 
        Set SurNumber = $lg(SurvData,2)
            //横断面调查病人就诊列表
        Set ListLocArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetCSSEpisByLocDate(StatType,aDateFrom,aDateTo,"")
        For index1=1:1:ListLocArray.Count() {
            Set CSSEpisInfo=ListLocArray.GetAt(index1)
            Continue:CSSEpisInfo=""
            
            Set Paadm       = $lg(CSSEpisInfo,1)
            Set TransID     = $lg(CSSEpisInfo,2)
            Set TransLocDr  = $lg(CSSEpisInfo,3)
            Set LinkLocDr   = $lg(CSSEpisInfo,4)
            Continue:(TransID="")||(TransLocDr="")
            Set TransData = $g(^DHCHAI.DP.PAAdmTransD(TransID))
            Continue:TransData=""
            //未调查
            Continue:'$d(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,Paadm))
            Set TransType=$li(TransData,4)
            If TransType="E" {
                Set LocDr  = $li(TransData,5)
                Set WardDr = ""
            } Else {
                Set LocDr  = $li(TransData,14)
                Set WardDr = $li(TransData,5)
            }
            Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
            Set HospDr  = $li(LocData,8)
            Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
            Set GroupDr  = $li(LocData,7)
            If GroupDr="" {
                Set GroupDesc="其他科"
                Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
            }
            Set LocDesc=""
            If LocData'="" {
                Set LocDesc2   = $li(LocData,4)
                Set tmpLocDesc = $li(LocData,3)
                Set LocDesc = $s(LocDesc2'="":LocDesc2,1:tmpLocDesc)
            }
            Set WardDesc="",WardData=""
            Set:WardDr'="" WardData = $g(^DHCHAI.BT.LocationD(WardDr))
            If WardData'="" {
                Set LocDesc2   = $li(WardData,4)
                Set tmpLocDesc = $li(WardData,3)
                Set WardDesc = $s(LocDesc2'="":LocDesc2,1:tmpLocDesc)
            }
            Set TransDate=$li(TransData,7)
            Set:TransDate'="" TransDate=$zd(TransDate,3)
            Set TransTime=$li(TransData,8)
            Set:TransTime'="" TransTime=$zt(TransTime,1)
            Set OutLocDate=$li(TransData,10)
            Set:OutLocDate'="" OutLocDate=$zd(OutLocDate,3)
            Set OutLocTime=$li(TransData,11)
            Set:OutLocTime'="" OutLocTime=$zt(OutLocTime,1)
            Set TransDateTime=TransDate_" "_TransTime
            Set OutLocDateTime=OutLocDate_" "_OutLocTime
            //按科室组、科室/病区过滤
            Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
            Continue:(aLocType'="")&&((LocDr'=aLocDr)&&(WardDr'=aLocDr))
            Set AntDescs =..GetAntInfo(Paadm,aDateFrom,aDateTo)
            Set (AntFlg,AntiPos,AntiCom)=""
            If (AntDescs'="") {
                Set AntFlg = +$p(AntDescs,"^",1)
                Set AntiPos=$p(AntDescs,"^",2)  //目的
                Set AntiCom=$p(AntDescs,"^",3)  //联合
            }
            if (aPurpose'=""){
                Continue:AntiPos'=aPurpose
            }
            if (aComMed'=""){
                Continue:AntiCom'=aComMed   
            }
            Continue:((aStaType=1)&&(aStaType'=AntFlg))
            Set AntFlg=$s(AntFlg=1: "是",1:"否")
            Set PatData =..BuildPaadmData(Paadm)
            Continue:PatData=""
            
            Set Data=PatData_$lb(GroupDesc,LocDesc,WardDesc,TransDateTime,OutLocDateTime,AntFlg,AntiPos,AntiCom)
            Set ^CacheTemp(repid,ind)=Data
            Set ind=ind+1
        }
    }

    Kill ^TMP($zn,$j,NIndex)
    Quit $$$OK
}

ClassMethod ActQryAntUseDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CssQryAntUseDtlExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod ActQryAntUseDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CssQryAntUseDtlExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Creator：     chenr
/// CreatDate：   2020-09-22
/// Description:  实时现患抗菌药物使用情况统计
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aSurNumID ：调查ID
///               aStaType ：科室/病区类型 
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S430CssAntUse","ActQryAntUse","2020-01-01","2021-01-01","1|3|4","W","1")
Query ActQryAntUse(aDateFrom As %String, aDateTo As %String, aHospIDs As %String = "", aLocType As %String = "E", aQryCon As %String = "1") As %Query(ROWSPEC = "SurNumber:%String,DimensKey:%String,DimensDesc:%String,HospSurSum:%String,HospAntUse:%String,HospAntUseZL:%String,AntUseZLRatio:%String,HospAntUseYF:%String,AntUseYFRatio:%String,HospAntUseQT:%String,AntUseQTRatio:%String,HospAntUseDL:%String,AntUseDLRatio:%String,HospAntUseEL:%String,AntUseELRatio:%String,HospAntUseSL:%String,AntUseSLRatio:%String,HospAntUseSLYS:%String,AntUseSLYSRatio:%String") [ SqlProc ]
{
}

ClassMethod ActQryAntUseExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aHospIDs As %String = "", aLocType As %String = "E", aQryCon As %String = "1") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    Quit:(aDateFrom="")||(aDateTo="") $$$OK
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
    Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
    Quit:(aDateFrom>aDateTo) $$$OK
    Set:aLocType'="W" aLocType="E"
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
    Set StatDimensStr=..GetStatDimensStr(aLocType)
    Quit:StatDimensStr="" $$$OK
    Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
    Set:StatType'="W" StatType="E"  //不是病区就是科室
    /// 取所有需要调查的科室  默认是全院科室    
    Set NIndex="ActQryAntUse"
    Kill ^TMP($zn,$j,NIndex)
    
    //同期在科:某段时间的在科人数
    Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,StatType,"","I")
    For index1=1:1:ListLocArray.Count() {
        Set TransInfo=ListLocArray.GetAt(index1)
        Continue:TransInfo=""
        
        Set Paadm      = $LIST(TransInfo,1)
        Set LocID      = $LIST(TransInfo,2)
        Set TransType  = $LIST(TransInfo,3)
        Set TransDates = $LIST(TransInfo,4)
        Set LnkLocDr   = $LIST(TransInfo,5)
        If TransType="E" {
            Set LocDr  = LocID
            Set WardDr = ""
            Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
        } Else {
            Set LocDr  = LnkLocDr
            Set WardDr = LocID
            Set LocData = $g(^DHCHAI.BT.LocationD(WardDr))
        }
        Set HospDr=$li(LocData,8)
        Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1) 
        Set GroupDr  = $li(LocData,7)
        If GroupDr="" {
            Set GroupDesc="其他科"
            Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
        }
        Set AntDescs =..GetAntInfo(Paadm,aDateFrom,aDateTo)
        Set (AntFlg,Pos,Com)=""
        If (AntDescs'="") {
            Set AntFlg = +$p(AntDescs,"^",1)
            Set Pos=$p(AntDescs,"^",2)  //目的
            Set Com=$p(AntDescs,"^",3)  //联合
        }
        //统计维度
        Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
            Continue:StatDimensInfo=""
            For indDimens=1:1:$l(StatDimensInfo,"^") {
                Set DimensKey=$p(StatDimensInfo,"^",indDimens)
                Continue:DimensKey=""
                // 实查人数
                if '$d(^TMP($zn,$j,NIndex,DimensKey,"SurPat",Paadm)){
                    Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"SurPat"))
                    Set ^TMP($zn,$j,NIndex,DimensKey,"SurPat",Paadm)=""
                }
                // 全院抗菌用药人数
                If (AntFlg=1){
                    Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUse"))
                if (Pos="治疗用药"){
                    Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseZL"))
                }ElseIf (Pos="预防用药"){
                    Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseYF"))
                }Else{//其他目的
                    Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseQT"))
                }
                //全院联用
                If (Com="一联"){
                    Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseDL"))
                }
                ElseIf (Com="二联"){
                    Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseEL"))
                }
                ElseIf (Com="三联"){
                    Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseSL"))
                }
                Else{
                    //四联及四联以上
                    Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseSLYS"))
                }
            }
        }
    }
    // 输出Data
	Set ArryStatDimens=..GetArrayStatDimens(StatDimensStr,aHospIDs,"","","","I")
	Set xDimensKey=""
	For DimIndx=1:1:ArryStatDimens.Count() {
		Set DimList=ArryStatDimens.GetAt(DimIndx)
		Set xDimensKey	=$lg(DimList,1)
		Set DimensDesc	=$lg(DimList,3)
		Set IsActive	=$lg(DimList,4)
		Continue:xDimensKey=""
		// 全院
		Set HospSurSum     =+$g(^TMP($zn,$j,NIndex,xDimensKey,"SurPat"))  //全院实查人
		Set HospAntUse     =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUse"))
		Set HospAntUseZL   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseZL"))	//治疗
		Set HospAntUseYF   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseYF"))	//预防
		
		Set HospAntUseQT   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseQT")) 	//其他
		
		Set HospAntUseDL   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseDL"))
		Set HospAntUseEL   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseEL")) 
		Set HospAntUseSL   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseSL"))  
		Set HospAntUseSLYS   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseSLYS")) //四联及以上
		
		Set (AntUseZLRatio,AntUseYFRatio,AntUseQTRatio)="0.00%"
		Set:HospSurSum>0 AntUseZLRatio=$fn((HospAntUseZL/HospSurSum)*100,"",2)_"%" //治疗占比
		Set:HospSurSum>0 AntUseYFRatio=$fn((HospAntUseYF/HospSurSum)*100,"",2)_"%" //预防占比
		
		Set:HospSurSum>0 AntUseQTRatio=$fn((HospAntUseQT/HospSurSum)*100,"",2)_"%" //其他占比
		
		
		Set (AntUseDLRatio,AntUseELRatio,AntUseSLRatio,AntUseSLYSRatio)="0.00%"
		Set:HospSurSum>0 AntUseDLRatio=$fn((HospAntUseDL/HospSurSum)*100,"",2)_"%" //单用占比
		Set:HospSurSum>0 AntUseELRatio=$fn((HospAntUseEL/HospSurSum)*100,"",2)_"%" //二联占比
		Set:HospSurSum>0 AntUseSLRatio=$fn((HospAntUseSL/HospSurSum)*100,"",2)_"%" //三联占比

		Set:HospSurSum>0 AntUseSLYSRatio=$fn((HospAntUseSLYS/HospSurSum)*100,"",2)_"%" //四联及以上占比
		
		Set Data=$lb(SurNumber,xDimensKey,DimensDesc,HospSurSum,HospAntUse,HospAntUseZL,AntUseZLRatio,HospAntUseYF,AntUseYFRatio,HospAntUseQT,AntUseQTRatio)
		Set Data=Data_$lb(HospAntUseDL,AntUseDLRatio,HospAntUseEL,AntUseELRatio,HospAntUseSL,AntUseSLRatio,HospAntUseSLYS,AntUseSLYSRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod ActQryAntUseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CssQryAntUseExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod ActQryAntUseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CssQryAntUseExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Creator：     chenrui
/// CreatDate：   2021-02-08
/// Description:  实时现患-抗菌药物使用情况病人明细
///               aDimensKey: 维度
///               aStaType : 1:统计抗菌药物患者信息
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S430CssAntUse","ActQryAntUseDtl","2019-02-01","2019-03-01","0001-07-0099-W-4","W","预防用药","")
Query QryActAntUseDtl(aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "W", aPurpose As %String, aComMed As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,GroupDesc:%String,LocDesc:%String,WardDesc:%String,TransDateTime:%String,OutLocDateTime:%String,AntFlg:%String,AntiPos:%String,AntiCom:%String") [ SqlProc ]
{
}

ClassMethod QryActAntUseDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String = "W", aPurpose As %String = "", aComMed As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Quit:(aDateFrom="")||(aDateTo="") $$$OK
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
    Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
    Quit:(aDateFrom>aDateTo) $$$OK
 
    Set DimensMark  = $p(aDimensKey,"-",4)
    Set aHospIDs    = +$p(aDimensKey,"-",1)
    Set:+aHospIDs="0" aHospIDs=""
    Set aLocType    = $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")
    Set aLocGroup   = $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")
    Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
    
    Set NIndex="QryActAntUseDtl"
    Kill ^TMP($zn,$j,NIndex)
    Set StatType=aLocType
    Set:StatType="" StatType=aStaType  //不是病区就是科室
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
   
    
        
    //同期在科:某段时间的在科人数
    Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,StatType,"","I")
    For index1=1:1:ListLocArray.Count() {
        Set TransInfo=ListLocArray.GetAt(index1)
        Continue:TransInfo=""
        
        Set Paadm      = $LIST(TransInfo,1)
        Set LocID      = $LIST(TransInfo,2)
        Set TransType  = $LIST(TransInfo,3)
        Set TransDates = $LIST(TransInfo,4)
        Set LnkLocDr   = $LIST(TransInfo,5)
        Continue:(TransID="")||(TransLocDr="")
        Set TransData = $g(^DHCHAI.DP.PAAdmTransD(TransID))
        Continue:TransData=""
        If TransType="E" {
            Set LocDr  = LocID
            Set WardDr = ""
            Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
        } Else {
            Set LocDr  = LnkLocDr
            Set WardDr = LocID
            Set LocData = $g(^DHCHAI.BT.LocationD(WardDr))
        }
        Set HospDr=$li(LocData,8)
        Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1) 
        Set GroupDr  = $li(LocData,7)
        If GroupDr="" {
            Set GroupDesc="其他科"
            Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
        }
        Set LocDesc=""
        If LocData'="" {
            Set LocDesc2   = $li(LocData,4)
            Set tmpLocDesc = $li(LocData,3)
            Set LocDesc = $s(LocDesc2'="":LocDesc2,1:tmpLocDesc)
        }
        Set WardDesc="",WardData=""
        Set:WardDr'="" WardData = $g(^DHCHAI.BT.LocationD(WardDr))
        If WardData'="" {
            Set LocDesc2   = $li(WardData,4)
            Set tmpLocDesc = $li(WardData,3)
            Set WardDesc = $s(LocDesc2'="":LocDesc2,1:tmpLocDesc)
        }
        Set TransDate=$li(TransData,7)
        Set:TransDate'="" TransDate=$zd(TransDate,3)
        Set TransTime=$li(TransData,8)
        Set:TransTime'="" TransTime=$zt(TransTime,1)
        Set OutLocDate=$li(TransData,10)
        Set:OutLocDate'="" OutLocDate=$zd(OutLocDate,3)
        Set OutLocTime=$li(TransData,11)
        Set:OutLocTime'="" OutLocTime=$zt(OutLocTime,1)
        Set TransDateTime=TransDate_" "_TransTime
        Set OutLocDateTime=OutLocDate_" "_OutLocTime
        //按科室组、科室/病区过滤
        Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
        Continue:(aLocType'="")&&((LocDr'=aLocDr)&&(WardDr'=aLocDr))
    
        Set AntDescs =..GetAntInfo(Paadm,aDateFrom,aDateTo)
        Set (AntFlg,AntiPos,AntiCom)=""
        If (AntDescs'="") {
            Set AntFlg = +$p(AntDescs,"^",1)
            Set AntiPos=$p(AntDescs,"^",2)  //目的
            Set AntiCom=$p(AntDescs,"^",3)  //联合
        }
        Continue:((aPurpose'="")&&(AntiPos'=aPurpose))
        Continue:((aComMed'="")&&(AntiCom'=aComMed))
        Set:AntFlg'="" AntFlg=$s(AntFlg=1: "是",1:"否")
        Set PatData =..BuildPaadmData(Paadm)
        Continue:PatData=""
            
        Set Data=PatData_$lb(GroupDesc,LocDesc,WardDesc,TransDateTime,OutLocDateTime,AntFlg,AntiPos,AntiCom)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
    }
    Kill ^TMP($zn,$j,NIndex)
    Quit $$$OK
}

ClassMethod QryActAntUseDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryActAntUseDtlExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryActAntUseDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryActAntUseDtlExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}
*/
}
