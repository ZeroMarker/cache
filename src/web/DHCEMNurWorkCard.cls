Class web.DHCEMNurWorkCard Extends %Persistent
{

/// w ##class(web.DHCEMNurWorkCard).cardNumber()
ClassMethod cardNumber()
{
	s TMPData("cardType",1,"adm")="就诊人次"
	s TMPData("cardType",2,"zl")="治疗人次"
	s TMPData("cardType",3,"jmcx")="静脉采血人次"
	s TMPData("cardType",4,"sy")="输液人次"
	s TMPData("cardType",5,"visit")="复诊人次"
	s TMPData("cardType",6,"sav")="抢救人次"
	s TMPData("cardType",7,"fr")="发热人次"
	s TMPData("cardType",8,"fw")="腹泻人次"
	s TMPData("cardType",9,"green")="绿通人次"
	s TMPData("cardType",10,"sw")="三无人次"
	s TMPData("cardType",11,"qs")="群伤人次"
	s TMPData("cardType",12,"zdbz")="重点病种"
	
	
	s date=+$h
	s admId=0
	f {
		s admId=$o(^PAADMi("NNType","E",date,admId))
		q:admId=""
		s patId=$p(^PAADM(admId),"^",1)
		s emChkId =$o(^DHCEMPCA(0,"AdmChkLev",admId,""))
		s isHasOrdType=##class(web.DHCEMNurWorkCard).hasOrdType(admId)
		s isZl=$p(isHasOrdType,"^",1)
		s isJmcx=$p(isHasOrdType,"^",2)
		s isSy=$p(isHasOrdType,"^",3)
		s isVisitPat= ##class(web.DHCEMNurWorkCard).isVisit(admId)
		s isSav = ##class(web.DHCEMNurWorkCard).isHasThisStatus(admId,"抢救")
		s isObs = ##class(web.DHCEMNurWorkCard).isHasThisStatus(admId,"留观")
		s isGreen = ##class(web.DHCEMPatGreenRec).checkGreenRec(admId,"")	///绿色通道
		s isSw="",sixSick ="",emPcsTemp=""
		i emChkId'="" {
			s emPatTypeID=+$p(^DHCEMPCL(emChkId),"^",40) 	/// 特殊人群
    		s:$p($g(^DHCEMPT(emPatTypeID)),"^",2)["三无" isSw=1
    		s sixSick=##class(web.DHCEMPatCheckLevQuery).GetSixSick(emChkId)
    		s emPcsId=$o(^DHCEMPCS(0,"PatCheckLev",emChkId,""),-1)
			s emPcsTemp=$p($g(^DHCEMPCS(+emPcsId)),"^",3)   /// 体温
    	}
		s isQs=$d(^DHCEMGPS(0,"PAPMI",patId))
		s isFr=$s(emPcsTemp>38:"1",1:"")	///发热
		
		d $i(TMPData("cardNumber",1,"adm"))
		d:isZl $i(TMPData("cardNumber",2,"zl"))
		d:isJmcx $i(TMPData("cardNumber",3,"jmcx"))
		d:isSy $i(TMPData("cardNumber",4,"sy"))
		d:isVisitPat $i(TMPData("cardNumber",5,"visit"))
		d:isSav $i(TMPData("cardNumber",6,"sav"))
		d:isFr $i(TMPData("cardNumber",7,"fr"))
		d:isGreen $i(TMPData("cardNumber",9,"green"))
		d:isSw $i(TMPData("cardNumber",10,"sw"))
		d:isQs $i(TMPData("cardNumber",11,"qs"))
		d:sixSick $i(TMPData("cardNumber",12,"zdbz"))
	}
	
#;	s TMPData("cardNumber",1,"adm")=73 //hxy 2022-11-09 st 测试数据，后期删除
#;	s TMPData("cardNumber",2,"zl")=58
#;	s TMPData("cardNumber",3,"jmcx")=25
#;	s TMPData("cardNumber",4,"sy")=48
#;	s TMPData("cardNumber",5,"visit")=15
#;	s TMPData("cardNumber",6,"sav")=10
#;	s TMPData("cardNumber",7,"fr")=33
#;	s TMPData("cardNumber",8,"fw")=9
#;	s TMPData("cardNumber",9,"green")=7
#;	s TMPData("cardNumber",10,"sw")=4
#;	s TMPData("cardNumber",11,"qs")=8
#;	s TMPData("cardNumber",12,"zdbz")=12 //ed
	
	s count=0
	w "["
	s index=""
	F  s index=$o(TMPData("cardType",index)) Q:index=""  D
	.s type=""
	.F  s type=$o(TMPData("cardType",index,type)) Q:type=""  D
	..s value=+$g(TMPData("cardNumber",index,type))
	..s name=TMPData("cardType",index,type)
	..s count=count+1
	..w $case(count,1:"",:",")
	..w ##class(web.DHCAPPJsonCommon).getJsonData("type^name^value",type_"^"_name_"^"_value)
	w "]"
	q ""
}

/// w ##class(web.DHCEMNurWorkCard).obsCardNumber()
ClassMethod obsCardNumber()
{
	s TMPData("cardType",1,"zry")="待入院人次"
	s TMPData("cardType",2,"jh")="监护人次"
	s TMPData("cardType",3,"jmcx")="静脉采血人次"
	s TMPData("cardType",4,"zdbz")="重点病种"
	s TMPData("cardType",5,"bw")="病危人次"
	s TMPData("cardType",6,"sav")="抢救人次"
	s TMPData("cardType",7,"obs")="留观人次" //留观转抢救数
	s TMPData("cardType",8,"eicu")="留观转EICU数"
	
	
	s date=+$h
	s admId=0
	f {
		s admId=$o(^PAADMi("NNType","E",date,admId))
		q:admId=""
		s patId=$p(^PAADM(admId),"^",1)
   		s isDeath = $p(^PAPER(patId,"ALL"),"^",12)
		s emChkId =$o(^DHCEMPCA(0,"AdmChkLev",admId,""))
		s isHasOrdType=##class(web.DHCEMNurWorkCard).hasOrdType(admId)
		s isZl=$p(isHasOrdType,"^",1)
		s isJmcx=$p(isHasOrdType,"^",2)
		s isSy=$p(isHasOrdType,"^",3)
		s isJH=$p(isHasOrdType,"^",4)
		s isSav = ##class(web.DHCEMNurWorkCard).isHasThisStatus(admId,"抢救")
		s isObs = ##class(web.DHCEMNurWorkCard).isHasThisStatus(admId,"留观")
		s isGreen = ##class(web.DHCEMPatGreenRec).checkGreenRec(admId,"")	///绿色通道
		s isSw="",sixSick =""
		i emChkId'="" {
			s emPatTypeID=+$p(^DHCEMPCL(emChkId),"^",40) 	/// 特殊人群
    		s:$p($g(^DHCEMPT(emPatTypeID)),"^",2)["三无" isSw=1
    		s sixSick=##class(web.DHCEMPatCheckLevQuery).GetSixSick(emChkId)
    	}
		s IPBKRowID=$o(^DHCDocIPBK(0,"EpisodeIDFrom",admId,""),-1)
		
		d:IPBKRowID $i(TMPData("cardNumber","zry"))
		d:isJH $i(TMPData("cardNumber","jh"))
		d:isJmcx $i(TMPData("cardNumber","jmcx"))
		d:sixSick $i(TMPData("cardNumber","zdbz"))
		d:isDeath $i(TMPData("cardNumber","bw"))
		d:isSav $i(TMPData("cardNumber","sav"))
		d:isObs $i(TMPData("cardNumber","obs"))
		d:isGreen $i(TMPData("cardNumber","eicu"))
		
	}
	
#;	s TMPData("cardNumber","zry")=8 //hxy 2022-11-09 st 测试数据，后期删除
#;	s TMPData("cardNumber","jh")=7
#;	s TMPData("cardNumber","jmcx")=6
#;	s TMPData("cardNumber","zdbz")=4
#;	s TMPData("cardNumber","bw")=7
#;	s TMPData("cardNumber","sav")=7
#;	s TMPData("cardNumber","obs")=2
#;	s TMPData("cardNumber","eicu")=3 //ed
	
	s count=0
	w "["
	s index=""
	F  s index=$o(TMPData("cardType",index)) Q:index=""  D
	.s type=""
	.F  s type=$o(TMPData("cardType",index,type)) Q:type=""  D
	..s value=+$g(TMPData("cardNumber",type))
	..s name=TMPData("cardType",index,type)
	..s count=count+1
	..w $case(count,1:"",:",")
	..w ##class(web.DHCAPPJsonCommon).getJsonData("type^name^value",type_"^"_name_"^"_value)
	w "]"
	q ""
}

/// 是否含有治疗医嘱^是否含有采血医嘱^是否含有输液医嘱
/// 
ClassMethod hasOrdType(admId)
{
	
	s isZl="",isJmcx="",isSy="",isJH=""
	s ord=0
	f{
		s ord=$o(^OEORD(0,"Adm",admId,ord))
		q:ord=""
		s itm=0
		f{
			s itm=$o(^OEORD(ord,"I",itm))
			q:itm=""
			s phcinDesc = ##class(web.DHCEMOrdInfoVO).getPhcinDesc(ord,itm)
			s ordType=##class(web.DHCEMShowOrdNum).GetOECCatByOEORDItmDr(ord_"||"_itm)
			s arciName = ##class(web.DHCEMOrdInfoVO).getArcimDesc(ord,itm)
			s arciCatDesc = ##class(web.DHCEMShowOrdNum).GetARCICatByOEORDItmDr(ord_"||"_itm)
			s labNo=$p($g(^OEORD(ord,"I",itm,3)),"^",20)
			s isPs = ##class(web.DHCEMSkinTest).IsSkinOrder(ord,itm)
			
			s:ordType["处置治疗" isZl=1
			s:arciName["采血" isJmcx=1
			s:phcinDesc["静脉滴注" isSy=1
			s:arciName["血氧饱和度监测" isJH=1
		}
	}
	q isZl_"^"_isJmcx_"^"_isSy_"^"_isJH
}

/// 是否是复诊就诊
ClassMethod isVisit(admId)
{
	s ret=""
	s queState=""
	s queRowId=$o(^User.DHCQueueI("QuePaadmDrIndex",admId,""))
	i queRowId'="" {
		s oref=##Class(User.DHCQueue).%OpenId(queRowId,0)
		s queStateDr=oref.QueStateDrGetObjectId()
		s queState=$lg(^User.DHCPerStateD(queStateDr),4)
		s:queState="复诊" ret=1
		q:ret'=""
	}
	
	q ret
}

/// 是否包含这个状态
ClassMethod isHasThisStatus(admId, sDesc)
{
	s ret=""
	s avsId=0
	f {
		s avsId	= $o(^DHCADMVisitStatus(0,"PAADM",admId,avsId))
		q:avsId=""
		s pvsId=$P(^DHCADMVisitStatus(avsId),"^",2)
		s walkStatus=$p(^DHCPACVisitStatus(pvsId),"^",1,2)
		s:walkStatus[sDesc ret=1
		q:ret'=""
	}
	q ret
}

ClassMethod allSeeOrdNumber(admId)
{
	;episodeIDStr, groupID, hospID, wardID, locID
	;s wardId=$p(^PAADM(admId,"^",70))
	;w ##class(Nur.NIS.Service.OrderExcute.OrderTask).GetDefaultSeeOrderNum(1,)
}

Storage Default
{
<Data name="DHCEMNurWorkCardDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEMNurWorkCardD</DataLocation>
<DefaultData>DHCEMNurWorkCardDefaultData</DefaultData>
<IdLocation>^web.DHCEMNurWorkCardD</IdLocation>
<IndexLocation>^web.DHCEMNurWorkCardI</IndexLocation>
<StreamLocation>^web.DHCEMNurWorkCardS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
