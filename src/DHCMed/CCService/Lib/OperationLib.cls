/// 手术信息监控
Class DHCMed.CCService.Lib.OperationLib Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

ClassMethod HasOperation(OperNameList, AnaList, CuteTypeList)
{
		New (%EpisodeID,%ExtraData,%ErrorData,OperNameList,AnaList,CuteTypeList)
		Set ret=0
		Set OrdsOperFlag=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFInfOperDataSource","")
	 	Set OrdsOperFlag=+OrdsOperFlag
	 	If OrdsOperFlag=1 {        //取安贞手术申请信息
	 		//略    
	 	} ElseIf OrdsOperFlag=2 {  //取手术麻醉系统信息
	 		//手术排班表DHC_AN_OPArrange    ^DHCANOPArrange(0,"Adm",{OPA_Adm_dr},{OPA_RowId})
			//麻醉表OR_Anaesthesia          ^OR({PA_Adm.PAADM_RowID},"ANA",{ANA_Childsub})  
			//手术表OR_Anaest_Operation     ^OR({PA_Adm.PAADM_RowID},"ANA",{Childsub},"OP",{ANAOP_Childsub})
    		Set OperArr=0
    		For {
	    		Set OperArr=$o(^DHCANOPArrange(0,"Adm",+aEpisodeID,OperArr))
	    		Quit:OperArr=""
	    		
	    		Set OperStatus=$p($g(^DHCANOPArrange(OperArr)),"^",27)
	    		Continue:OperStatus="NotApp"
	    		Set AnaRowID=$p($g(^DHCANOPArrange(OperArr)),"^",2)
	    		Set Paadm=$p(AnaRowID,"||",1)
	    		Set AnaChild=$p(AnaRowID,"||",2)
	    		Continue:(AnaChild="")||(Paadm="")
	    		Set OperStartDate=$p($g(^DHCANOPArrange(OperArr)),"^",14)
	    		If OperStartDate'="" {
		    		Set OperStartDate=$zd(OperStartDate,3)
		    		Set OperStartTime=$p($g(^DHCANOPArrange(OperArr)),"^",15)
	    			Set OperStartTime=$zt(+OperStartTime,2)
		    	} Else {
			    	Set OperStartTime=""
			    }
	    		Set OperEndDate=$p($g(^DHCANOPArrange(OperArr)),"^",16)
	    		If OperEndDate'="" {
		    		Set OperEndDate=$zd(OperEndDate,3)
		    		Set OperEndTime=$p($g(^DHCANOPArrange(OperArr)),"^",17)
	    			Set OperEndTime=$zt(+OperEndTime,2)
		    	} Else {
			    	Set OperEndTime=""
			    }
	    		
	    		Set OPChild=0
	    		For {
		    		Set OPChild=$o(^OR(Paadm,"ANA",AnaChild,"OP",OPChild))
		    		Quit:OPChild=""
		    		
		    		Set AnaOpRowID=Paadm_"||"_AnaChild_"||"_OPChild
		    		Set tmpOper=$g(^OR(Paadm,"ANA",AnaChild,"OP",OPChild))
		    		Continue:tmpOper=""
		    		
		    		Set (OperationID,OperationDesc,OperDocID,OperDocDesc)=""
					Set (OperationTypeID,OperationTypeDesc,AnesthesiaID,AnesthesiaDesc)=""
					Set (CuteTypeID,CuteTypeDesc,CuteHealingID,CuteHealingDesc)=""
					Set (CuteInfFlagID,CuteInfFlagDesc,OperInfTypeID,OperInfTypeDesc,InHospInfFlagID,InHospInfFlagDesc)=""
					Set (DataSource)=""
					
		    		Set OperationID=$p(tmpOper,"^",6)
		    		Set:OperationID'="" OperationDesc=$p($g(^ORC("OPER",OperationID)),"^",2)
		    		
		    		Set OperDoc=$p(tmpOper,"^",8)
		    		Set tmpOperDocDesc=$p($g(^CTPCP(+OperDoc)),"^",2)
					Set:OperDoc'="" OperDoc=$o(^SSU("SSUSR",0,"CTPCP",OperDoc,0))
					Set objSSUser=##class(DHCMed.Base.SSUser).GetObjById(OperDoc)
					If $IsObject(objSSUser) {
						Set OperDocID=objSSUser.Rowid
						Set OperDocDesc=objSSUser.Name
					}
					Set:(OperDocDesc="")&&(tmpOperDocDesc'="") OperDocDesc="*"_tmpOperDocDesc
					
					Set AnesthesiaDesc=$p($g(^OR(Paadm,"ANA",AnaChild)),"^",5)
					Set:AnesthesiaDesc'="" AnesthesiaDesc=$p(^ORC("ANMET",+AnesthesiaDesc),"^",2)
					Set:$p(AnesthesiaDesc,"-",2)'="" AnesthesiaDesc=$p(AnesthesiaDesc,"-",2)
					If (AnesthesiaDesc'="") {
						Set AnesthesiaID=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc("NINFInfAnesthesia",AnesthesiaDesc)
						Set:AnesthesiaID="" AnesthesiaDesc="*"_AnesthesiaDesc
					}
					Set tmp=$$BuildHasOperationResult(1)
					Set %ExtraData=%ExtraData_$lb(tmp)
					Set ret=1
		    	}
	    	}
	 	} ElseIf OrdsOperFlag=3 {  //取电子病历系统信息
	 		//略
		} Else {                   //取手术医嘱信息
			Set xOrdID=$o(^OEORD(0,"Adm",+aEpisodeID,""))
			Set xArcimID=""
			For {
				Set xArcimID=$o(^OEORDi(0,"ARCIM",+xOrdID,xArcimID))
				Quit:xArcimID=""
				
				Set objArcim=##class(DHCMed.Base.Arcim).GetObjById(xArcimID)
				Continue:'$IsObject(objArcim)
				
				Set ARCItmSubCatDesc=objArcim.ARCICDesc
				Set ARCItmCatDesc=objArcim.ORCATDesc
				Continue:ARCItmCatDesc'["手术"
				Continue:ARCItmSubCatDesc["其它手术"
				
				Set ArcimID=xArcimID
				Set ArcimDesc=objArcim.ARCIMDesc
				
				Set xOrdDate=0
				For {
					Set xOrdDate=$o(^OEORDi(0,"ARCIM",+xOrdID,xArcimID,xOrdDate))
					Quit:xOrdDate=""
					Set xSubID=0
					For {
						Set xSubID=$o(^OEORDi(0,"ARCIM",+xOrdID,xArcimID,xOrdDate,xSubID))
						Quit:xSubID=""
						
						Set OEItemID=xOrdID_"||"_xSubID
						Set objOEItem=##class(DHCMed.Base.OrdItem).GetObjById(OEItemID)
						Continue:'$IsObject(objOEItem)
						
						Set StatusCode=objOEItem.OSTATCode
						Continue:(StatusCode="D")||(StatusCode="S")
						
						Set (OperationID,OperationDesc,OperDocID,OperDocDesc)=""
						Set (OperStartDate,OperStartTime,OperEndDate,OperEndTime)=""
						Set (OperationTypeID,OperationTypeDesc,AnesthesiaID,AnesthesiaDesc)=""
						Set (CuteTypeID,CuteTypeDesc,CuteHealingID,CuteHealingDesc)=""
						Set (CuteInfFlagID,CuteInfFlagDesc,OperInfTypeID,OperInfTypeDesc,InHospInfFlagID,InHospInfFlagDesc)=""
						Set (DataSource)=""
						
						Set OperationDesc=ArcimDesc
						Set OperDoc=objOEItem.OEORIDoctorDR
						Set:OperDoc'="" OperDoc=$o(^SSU("SSUSR",0,"CTPCP",OperDoc,0))
						Set objSSUser=##class(DHCMed.Base.SSUser).GetObjById(OperDoc)
						If $IsObject(objSSUser) {
							Set OperDocID=objSSUser.Rowid
							Set OperDocDesc=objSSUser.Name
						}
						
					 	Set OEStartDate=objOEItem.OEORISttDat
					 	Set OperStartDate=OEStartDate
					 	If (OperStartDate'="") {
						 	Set OperStartDate=$zd(+OperStartDate,3)
						 	Set OperStartTime=$zt(0,2)
						} Else {
							Set OperStartTime=""
						}
					 	Set OperEndDate=OperStartDate
					 	Set OperEndTime=OperStartTime
						Set tmp=$$BuildHasOperationResult(1)
						Set %ExtraData=%ExtraData_$lb(tmp)	
						Set ret=1
					}
				}
			}
		}
		Quit ret		
BuildHasOperationResult(arg0) //Add By LiYang 2012-06-20
	//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
	Set tmp=""
	Set $p(tmp,$c(3),1)=OperationDesc
	Set $p(tmp,$c(3),2)=OperStartDate
	Set $p(tmp,$c(3),3)=OperStartTime
	Set $p(tmp,$c(3),4)=OperationDesc
	Set $p(tmp,$c(3),5)=OperationID
	Set $p(tmp,$c(3),6)=+OperDoc
	Set $p(tmp,$c(3),7)="OperNameList:"_OperNameList_",AnaList:"_AnaList_",CuteTypeList:"_CuteTypeList
	Quit tmp
}

}
