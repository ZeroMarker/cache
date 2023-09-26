Import SQLUser

/// 院内感染查询统计 DHCMedQuery.EXE
Class web.DHCMedInfSta Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right ]
{

Parameter BUILD = 18;

ClassMethod StaDrugByLocRepPlaceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaDrugByLocRepPlaceExecute ]
{
	s repid=$LIST(qHandle,2)
 	k ^CacheTemp(repid)
	Q $$$OK
}

ClassMethod StaDrugByLocRepPlaceExecute(ByRef qHandle As %Binary, RepPlace As %String, From As %String, To As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	q:(From="")!(To="")!(RepPlace="") $$$OK
	s From=+$zdh(From,3)   //2009-04-14
	s To=+$zdh(To,3)
	s i=0
	
	k ^CacheTemp("StaDrugByLocRepPlace", $j)
	//^DHCMedIR(0,"InfPlaceDate",{MIR_InfPlace},{MIR_Date},{MIR_Rowid})
    s DepStr=##Class(web.DHCMedBaseCtl).GetAllDep()
    f i=1:1:($l(DepStr,$c(1))-1)
    {
	    s DepValue=$p(DepStr,$c(1),i)
        s DepRowId=$p(DepValue,$c(2),1)
        s ^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId)=""
    }
    //s ^CacheTemp()
	s tmpDate = From-1
    f  s tmpDate=$o(^DHCMedIR(0,"InfPlaceDate",RepPlace,tmpDate)) q:(tmpDate="")!(tmpDate>=To)  d
    .s tmpRepRowId=0
    .f  s tmpRepRowId=$o(^DHCMedIR(0,"InfPlaceDate",RepPlace,tmpDate,tmpRepRowId)) q:tmpRepRowId=""  d
    ..//删除和被订正报告是无效的
    ..s RepStatus=$p(^DHCMedIR(tmpRepRowId),"^",11)
    ..q:(RepStatus="0")!(RepStatus="10")
    ..s DepRowId=$p(^PAADM($p(^DHCMedIR(tmpRepRowId),"^",1)),"^",4)
    ..q:'$d(^CacheTemp("StaDrugByLocRepPlace",$j,DepRowId))
    ..s ^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"Count")=+$g(^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"Count"))+1
    ..//使用抗菌药物
    ..i $d(^DHCMedIR(tmpRepRowId,"D"))  d
    ...s ^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"DrugYes")=+$g(^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"DrugYes"))+1
    ...//抗菌药物使用目的
    ...//抗菌药物联用
    ...s DurgSub=0
    ...f  s DurgSub=$o(^DHCMedIR(tmpRepRowId,"D",DurgSub)) q:DurgSub=""  d
    ....s Aim=$p(^DHCMedIR(tmpRepRowId,"D",DurgSub),"^",7)
    ....s:Aim="" Aim=1
    ....s Unite=$p(^DHCMedIR(tmpRepRowId,"D",DurgSub),"^",12)
    ....s:Unite="" Unite=1
    ....s ^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"Aim",Aim)=+$g(^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"Aim",Aim))+1
    ....s ^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"Unite",Unite)=+$g(^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"Unite",Unite))+1
    ..e  d  //没使用抗菌药
    ...s ^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"DrugNo")=+$g(^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"DrugNo"))+1
    ..i $d(^DHCMedIR(tmpRepRowId,"PY"))  d  //做细菌培养
    ...s ^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"PYYes")=+$g(^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"PYYes"))+1
    ..e  d  //未作细菌培养
    ...s ^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"PYNo")=+$g(^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"PYNo"))+1

    d BuildStaByLocRepPlaceData
	
	k ^CacheTemp("StaDrugByLocRepPlace", $j)
	Quit $$$OK
	
BuildStaByLocRepPlaceData
    s (CountSum,DrugYesSum,DrugNoSum,Aim1Sum,Aim2Sum,Aim3Sum,Unite1Sum,Unite2Sum,Unite3Sum,Unite4Sum,PYYesSum,PYNoSum)=0
    s DepRowId=0
    f  s DepRowId=$o(^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId)) q:DepRowId=""  d
    .s LocDesc=$p($g(^CTLOC(+DepRowId)),"^",2)    //科室
    .s Count=+$g(^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"Count"))      //实查人数
    .s CountSum=CountSum+Count
    .s DrugYes=+$g(^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"DrugYes"))  //使用抗菌药物
    .s DrugYesSum=DrugYesSum+DrugYes
    .s DrugNo=+$g(^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"DrugNo"))    //未使用抗菌药
    .s DrugNoSum=DrugNoSum+DrugNo
    .s Aim1=+$g(^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"Aim",1))       //治疗
    .s Aim1Sum=Aim1Sum+Aim1
    .s Aim2=+$g(^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"Aim",2))       //预防
    .s Aim2Sum=Aim2Sum+Aim2
    .s Aim3=+$g(^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"Aim",3))       //治疗+预防
    .s Aim3Sum=Aim3Sum+Aim3
    .s Unite1=+$g(^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"Unite",1))   //一联   
    .s Unite1Sum=Unite1Sum+Unite1
    .s Unite2=+$g(^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"Unite",2))   //二联
    .s Unite2Sum=Unite2Sum+Unite2
    .s Unite3=+$g(^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"Unite",3))   //三联
    .s Unite3Sum=Unite3Sum+Unite3
    .s Unite4=+$g(^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"Unite",4))   //四联
    .s Unite5=+$g(^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"Unite",5))   //四联以上
    .s Unite4Sum=Unite4Sum+Unite4+Unite5
    .s PYYes=+$g(^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"PYYes"))      //做送检
    .s PYYesSum=PYYesSum+PYYes
    .s PYNo=+$g(^CacheTemp("StaDrugByLocRepPlace", $j,DepRowId,"PYNo"))        //未做送检
    .s PYNoSum=PYNoSum+PYNo
	.s Data=$lb("") 
	.s $li(Data,1)=$s(LocDesc["-":$p(LocDesc,"-",2),1:LocDesc)
	.s $li(Data,2)=Count
	.s $li(Data,3)=DrugYes
	.i DrugYes=0  d
	..s $li(Data,4)=0_"%"
	.e  d
	..s $li(Data,4)=+$fn((DrugYes*100)/(DrugYes+DrugNo),"+",2)_"%"                     //精确到小数后两位
	.s $li(Data,5)=DrugNo                        
	.s $li(Data,6)=Aim1
	.s $li(Data,7)=Aim2
	.s $li(Data,8)=Aim3                        
	.s $li(Data,9)=Unite1
	.s $li(Data,10)=Unite2
	.s $li(Data,11)=Unite3
	.s $li(Data,12)=Unite4+Unite5
	.s $li(Data,13)=PYYes
	.i PYYes=0  d
	..s $li(Data,14)=0_"%"
	.e  d
	..s $li(Data,14)=+$fn((PYYes*100)/(PYYes+PYNo),"+",2)_"%"
	.s $li(Data,15)=PYNo
			
 	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	//全院统计
	s Data=$lb("")        
	s $li(Data,1)="全院"
	s $li(Data,2)=CountSum
	s $li(Data,3)=DrugYesSum
	i DrugYesSum=0  d
	.s $li(Data,4)=0_"%"
	e  d
	.s $li(Data,4)=+$fn((DrugYesSum*100)/(DrugYesSum+DrugNoSum),"+",2)_"%" 
	s $li(Data,5)=DrugNoSum                       
	s $li(Data,6)=Aim1Sum
	s $li(Data,7)=Aim2Sum
	s $li(Data,8)=Aim3Sum                        
	s $li(Data,9)=Unite1Sum
    s $li(Data,10)=Unite2Sum
	s $li(Data,11)=Unite3Sum
	s $li(Data,12)=Unite4Sum
	s $li(Data,13)=PYYesSum
	i PYYesSum=0  d
	.s $li(Data,14)=0_"%"
    e  d
	.s $li(Data,14)=+$fn((PYYesSum*100)/(PYYesSum+PYNoSum),"+",2)_"%"
	s $li(Data,15)=PYNoSum		
 	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
}

ClassMethod StaDrugByLocRepPlaceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaDrugByLocRepPlaceExecute ]
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

/// 院感病原体监测汇总表
/// d ##Class(%ResultSet).RunQuery("web.DHCMedInfSta","StaDrugByLocRepPlace","1","2008-01-01","2009-04-15")
/// ROWSPEC = "科室:%String,Count:%String,DrugYes:%String,DrugYesPer:%String,DrugNo:%String,Aim1:%String,Aim2:%String,Aim3:%String,Unite1:%String,Unite2:%String,Unite3:%String,Unite4:%String,PYYes:%String,PYYesPer:%String,PYNo:%String"
Query StaDrugByLocRepPlace(RepPlace As %String, From As %String, To As %String) As %Query(ROWSPEC = "科室:%String,实查人数:%String,使用抗菌药:%String,使用率:%String,未使用药:%String,治疗:%String,预防:%String,治疗+预防:%String,一联:%String,二联:%String,三联:%String,四联及以上:%String,做培养:%String,培养率:%String,未做培养:%String")
{
}

ClassMethod StaPathogenyByRepPlaceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaPathogenyByRepPlaceExecute ]
{
	s repid=$LIST(qHandle,2)
 	k ^CacheTemp(repid)
	Q $$$OK
}

ClassMethod StaPathogenyByRepPlaceExecute(ByRef qHandle As %Binary, RepPlace As %String, From As %String, To As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	q:(From="")!(To="")!(RepPlace="") $$$OK
	s:From["-" From=$zdh(From,3)
	s:From["/" From=$zdh(From,4)
	s From=+From
	s:To["-" To=$zdh(To,3)
	s:To["/" To=$zdh(To,4)
	s To=+To
	
	k ^CacheTemp("StaPathogenyByRepPlace", $j)
	//s PID=##Class(web.DHCMedInfDictionaryCtl).QueryPathogenDic("","","Y")
	//s Rowid=0
	//f  s Rowid=$o(^CacheTemp("PathogenDic",PID,Rowid)) q:(Rowid="")  d
	//.s ^CacheTemp("StaPathogenyByRepPlace", $j,Rowid)=""
	s tmpDate = From-1
    f  s tmpDate=$o(^DHCMedIR(0,"InfPlaceDate",RepPlace,tmpDate)) q:(tmpDate="")!(tmpDate>To)  d
    .s tmpRepRowId=0
    .f  s tmpRepRowId=$o(^DHCMedIR(0,"InfPlaceDate",RepPlace,tmpDate,tmpRepRowId)) q:tmpRepRowId=""  d
    ..s RepStatus=$p(^DHCMedIR(tmpRepRowId),"^",11)
    ..q:(RepStatus="0")!(RepStatus="10")  //删除和被订正报告是无效的
	..s PYSub=0    //病原学检验
	..f  s PYSub=$o(^DHCMedIR(tmpRepRowId,"PY",PYSub)) q:PYSub=""  d
	...s POSub=0   //病原学检验病原体
	...s InfPosDR=$p(^DHCMedIR(tmpRepRowId,"PY",PYSub),"^",2)
	...q:InfPosDR=""
	...s PYFlag=$s($p(^DHCMPOS(InfPosDR),"^",3)["Y":1,1:0)
	...q:PYFlag=0
	...f  s POSub=$o(^DHCMedIR(tmpRepRowId,"PY",PYSub,"O",POSub)) q:POSub=""  d
	....s ^CacheTemp("StaPathogenyByRepPlace", $j,POSub)=(+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub)))+1
	....s ^CacheTemp("StaPathogenyByRepPlace", $j,POSub,InfPosDR)=(+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub,InfPosDR)))+1
	
	s POSub=0
	f  s POSub=$o(^CacheTemp("StaPathogenyByRepPlace", $j,POSub)) q:POSub=""  d
	.s POSubDesc=$p(^DHCMInfPD(+POSub),"^",2)    //病原体
	.//1|上呼吸道^2|下呼吸道^3|胸膜腔^4|泌尿道^5|胃肠道^
	.//7|腹盆腔内组织^8|表浅切口^9|深度切口^10|器官腔隙^12|动静脉^
	.//13|血液^14|皮肤软组织^15|骨和关节^16|生殖系统^18|中枢神经系统^
	.//19|眼耳口腔^20|其它^25|心脏瓣膜^26|心肌或心包^27|纵隔^
	.//28|输血^29|其它肾等^30|烧伤部位^
	.s Count=+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub))
	.s InfPos1=+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub,1))
	.s InfPos2=+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub,2))
	.s InfPos3=+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub,3))
	.s InfPos4=+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub,4))
	.s InfPos5=+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub,5))
	.s InfPos7=+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub,7))
	.s InfPos8=+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub,8))
	.s InfPos9=+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub,9))
	.s InfPos10=+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub,10))
	.s InfPos12=+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub,12))
	.s InfPos13=+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub,13))
	.s InfPos14=+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub,14))
	.s InfPos15=+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub,15))
	.s InfPos16=+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub,16))
	.s InfPos18=+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub,18))
	.s InfPos19=+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub,19))
	.s InfPos20=+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub,20))
	.s InfPos25=+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub,25))
	.s InfPos26=+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub,26))
	.s InfPos27=+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub,27))
	.s InfPos28=+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub,28))
	.s InfPos29=+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub,29))
	.s InfPos30=+$g(^CacheTemp("StaPathogenyByRepPlace", $j,POSub,30))
	.s Data=$lb(POSubDesc,Count,InfPos1,InfPos2,InfPos3,InfPos4,InfPos5,InfPos7,InfPos8,InfPos9,InfPos10,InfPos12,InfPos13,InfPos14,InfPos15,InfPos16,InfPos18,InfPos19,InfPos20,InfPos25,InfPos26,InfPos27,InfPos28,InfPos29,InfPos30)
 	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	k ^CacheTemp("StaPathogenyByRepPlace",$j)
	
	Quit $$$OK
}

ClassMethod StaPathogenyByRepPlaceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaPathogenyByRepPlaceExecute ]
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

/// 院感感染部位一览表
/// d ##Class(%ResultSet).RunQuery("web.DHCMedInfSta","StaPathogenyByRepPlace","1","2008-01-01","2009-04-15")
Query StaPathogenyByRepPlace(RepPlace As %String, From As %String, To As %String) As %Query(ROWSPEC = "病原体:%String,总数:%String,上呼吸道:%String,下呼吸道:%String,胸膜腔:%String,泌尿道:%String,胃肠道:%String,腹盆腔内组织:%String,表浅切口:%String,深度切口:%String,器官腔隙:%String,动静脉:%String,血液:%String,皮肤软组织:%String,骨和关节:%String,生殖系统:%String,中枢神经系统:%String,眼耳口腔:%String,其它:%String,心脏瓣膜:%String,心肌或心包:%String,纵隔:%String,输血:%String,其它肾等:%String,烧伤部位:%String")
{
}

}
