Import SQLUser

Class web.DHCANChargeInWeb Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetCustomData(OPAAdmdr, opaId, mulOeoriStr) As %String
{
	s oeoriStr=""
	q:OPAAdmdr="" ""
	q:opaId="" ""
	q:mulOeoriStr="" ""
	f i=1:1:$l(mulOeoriStr,"#") d
		.s oeoriStr=$p(mulOeoriStr,"#",i)
		.s ^DHCANChargeInWeb(OPAAdmdr,opaId,+oeoriStr)=$p(oeoriStr,"!",2)
	q "OK"
}

//w ##class(web.DHCANChargeInWeb).CheckChargeState("1039301","48","47063!1295||1^2010-1-8^14:09^^1^10^619^14^1^^1^52#47070!12683||1^2010-1-8^15:06^^1^2^611^14^2^^1^52")

ClassMethod CheckChargeState(EpisodeID, DHCOPERNO, mulOeoriStr) As %String
{
	s canCharge="true"
	s cannotChargeOeoriId=""
	s cannotChargeOeoriIdString=""
	q:EpisodeID="" ""
	q:DHCOPERNO="" ""
	q:mulOeoriStr="" ""
	f i=1:1:$l(mulOeoriStr,"#") 
	{
		s oeoriStr=$p(mulOeoriStr,"#",i)
		q:$D(^DHCANChargeInWebi(EpisodeID,DHCOPERNO,+oeoriStr))=0
		s OrdId=^DHCANChargeInWebi(EpisodeID,DHCOPERNO,+oeoriStr)
		s drugOrdStatus=##class(web.DHCOperPrice).GetDrugOrdStatus(OrdId)
	
		If $p(drugOrdStatus,"^",2)="O"              //门诊病人
		{
 			If $p(drugOrdStatus,"^",3)="B"          //已划价，未收费
 			{
	 			set canCharge="false"
	 			set cannotChargeOeoriId=+oeoriStr
	 			If cannotChargeOeoriIdString=""
				{
					set cannotChargeOeoriIdString=+oeoriStr
 				}
 				ElseIf cannotChargeOeoriIdString'=""
 				{
	 				set cannotChargeOeoriIdString=cannotChargeOeoriIdString_"#"_+oeoriStr
				}
 			}
		}
	}
	If canCharge="true"
	{
		q "OK"
 	}
 	ElseIf canCharge="false"  //已划价，未收费
 	{
	 	q cannotChargeOeoriIdString
	}
}

ClassMethod ProcessOldOrder(EpisodeID, DHCOPERNO, mulOeoriStr, UserId) As %String
{
	s ret=""
	q:EpisodeID="" ""
	q:DHCOPERNO="" ""
	q:mulOeoriStr="" ""
	q:UserId="" ""
	f i=1:1:$l(mulOeoriStr,"#") 
	{
		s oeoriStr=$p(mulOeoriStr,"#",i)
		
		//表示新医嘱,写入
		if '$D(^DHCANChargeInWebi(EpisodeID,DHCOPERNO,+oeoriStr)) 
		{
			s ^DHCANChargeInWeb(OPAAdmdr,opaId,+oeoriStr)=$p(oeoriStr,"!",2)
			q
		}
	
		s OrdId=^DHCANChargeInWebi(EpisodeID,DHCOPERNO,+oeoriStr)
		s drugOrdStatus=##class(web.DHCOperPrice).GetDrugOrdStatus(OrdId)
		//表示医嘱是不合法的,写入
		if $p(drugOrdStatus,"^",1)="0"
		{
			s ^DHCANChargeInWeb(OPAAdmdr,opaId,+oeoriStr)=$p(oeoriStr,"!",2)
			q
		}  
		//门诊病人        
		If $p(drugOrdStatus,"^",2)="O"              
		{
			//未划价
 			If $p(drugOrdStatus,"^",3)="TB"             
			{
				//停医嘱
				set ret=##Class(web.UDHCStopOrderLook).StopOrder("","",OrdId_"&&",UserId,"")
				s ^DHCANChargeInWeb(OPAAdmdr,opaId,+oeoriStr)=$p(oeoriStr,"!",2)
				q
 			}
 			//已划价，未收费
 			ElseIf $p(drugOrdStatus,"^",3)="B"          
 			{
	 			//等待,不会有这种情况
	 			q
 			}
 			//已收费
 			ElseIf $p(drugOrdStatus,"^",3)="P"          
 			{
	 			//退费
	 			set TarRowid=##class(web.DHCOperPrice).GetTarRowid(OrdId)
	 			//停医嘱
 				set ret=##class(web.DHCPACSPrice).ReturnFee(TarRowid,OrdId,UserId,"")
	 			set ret=##Class(web.UDHCStopOrderLook).StopOrder("","",OrdId_"&&",UserId,"")
	 			s ^DHCANChargeInWeb(OPAAdmdr,opaId,+oeoriStr)=$p(oeoriStr,"!",2)
	 			q
 			}
 		}
 		//住院病人
 		ElseIf $p(drugOrdStatus,"^",2)="O"          
 		{
	 		//未划价
 			If $p(drugOrdStatus,"^",3)="TB"             
			{
				//停医嘱
				set ret=##Class(web.UDHCStopOrderLook).StopOrder("","",OrdId_"&&",UserId,"")
				s ^DHCANChargeInWeb(OPAAdmdr,opaId,+oeoriStr)=$p(oeoriStr,"!",2)
				q
 			}
 			//已收费
 			ElseIf $p(drugOrdStatus,"^",3)="P"          
 			{
	 			//退费
	 			set TarRowid=##class(web.DHCOperPrice).GetTarRowid(OrdId)
 				set ret=##class(web.DHCPACSPrice).ReturnFee(TarRowid,OrdId,UserId,"")
 				//停医嘱
	 			set ret=##Class(web.UDHCStopOrderLook).StopOrder("","",OrdId_"&&",UserId,"")
	 			s ^DHCANChargeInWeb(OPAAdmdr,opaId,+oeoriStr)=$p(oeoriStr,"!",2)
	 			q
 			}
 		}
	}
}

/// -1--已划价，未收费,等待；0--正常删除;
ClassMethod DeleteOrderCheckState(EpisodeID, DHCOPERNO, DrugRowid, UserId) As %String
{
	s ret=""
	q:'$D(^DHCANChargeInWebi(EpisodeID,DHCOPERNO,DrugRowid)) "0"
	
	s OrdId=^DHCANChargeInWebi(EpisodeID,DHCOPERNO,DrugRowid)
	s drugOrdStatus=##class(web.DHCOperPrice).GetDrugOrdStatus(OrdId)
	
	q:$p(drugOrdStatus,"^",1)="0" "0"          //表示医嘱是不合法的
	If $p(drugOrdStatus,"^",2)="O"              //门诊病人
	{
 		If $p(drugOrdStatus,"^",3)="TB"             //未划价
		{
			//停医嘱
			set ret=##Class(web.UDHCStopOrderLook).StopOrder("","",OrdId_"&&",UserId,"")
			q "0"
 		}
 		ElseIf $p(drugOrdStatus,"^",3)="B"          //已划价，未收费
 		{
	 		//等待
	 		q "-2"
 		}
 		ElseIf $p(drugOrdStatus,"^",3)="P"          //以收费
 		{
	 		//退费
	 		set TarRowid=##class(web.DHCOperPrice).GetTarRowid(OrdId)
	 		//停医嘱
 			set ret=##class(web.DHCPACSPrice).ReturnFee(TarRowid,OrdId,UserId,"")
	 		set ret=##Class(web.UDHCStopOrderLook).StopOrder("","",OrdId_"&&",UserId,"")
	 		q "0"
 		}
 	}
 	ElseIf $p(drugOrdStatus,"^",2)="O"          //住院病人
 	{
 		If $p(drugOrdStatus,"^",3)="TB"             //未划价
		{
			//停医嘱
			set ret=##Class(web.UDHCStopOrderLook).StopOrder("","",OrdId_"&&",UserId,"")
			q "0"
 		}
 		ElseIf $p(drugOrdStatus,"^",3)="P"          //以收费
 		{
	 		//退费
	 		set TarRowid=##class(web.DHCOperPrice).GetTarRowid(OrdId)
 			set ret=##class(web.DHCPACSPrice).ReturnFee(TarRowid,OrdId,UserId,"")
 			//停医嘱
	 		set ret=##Class(web.UDHCStopOrderLook).StopOrder("","",OrdId_"&&",UserId,"")
	 		q "0"
 		}
 	}
}

}
