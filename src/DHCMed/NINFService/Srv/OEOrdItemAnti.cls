/// 名称:	DHCMed.NINFService.Srv.OEOrdItemAnti           
/// 描述:	抗生素、合成抗菌药、抗真菌药使用记录 
/// 编写者： fcz
/// 编写日期: 2012-06-14
Class DHCMed.NINFService.Srv.OEOrdItemAnti Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     fcz
/// CreatDate：   2012-06-14
/// Description:  查询一段时间内抗生素、合成抗菌药、抗真菌药使用记录
/// Table：       
/// Input:        argDateFrom,argDateTo,argLoc,argOrdItm
/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Srv.OEOrdItemAnti","QryAntiByDateLoc","2012-07-01","2012-07-10","31","")
Query QryAntiByDateLoc(argDateFrom As %String, argDateTo As %String, argLoc As %String, argOrdItm As %String) As %Query(ROWSPEC = "RowID:%String,OrdLoc:%String,Doctor:%String,PatName:%String,PatSex:%String,PatAge:%String,AdmLoc:%String,CurrWard:%String,CurrBedCode:%String,OrdName:%String,OrdType:%String,PHCCateg:%String,PHCSubCat:%String,SttDate:%String,SttTime:%String,PHCFreqDesc2:%String,PHCInstrucDesc1:%String,OrdDoseQty:%String,UOMDesc:%String,PAPMIMedicare:%String,SttDateTime:%String,EndDateTime:%String")
{
}

ClassMethod QryAntiByDateLocExecute(ByRef qHandle As %Binary, argDateFrom As %String, argDateTo As %String, argLoc As %String, argOrdItm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set PHCCategList=$lb("抗感染药物")
	Set PHCSubCatList=$lb("抗生素","化学合成抗菌药物","抗真菌药物")
	
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	Quit:(argLoc="")&&(argOrdItm="") $$$OK
	Set xDateFrom=$zdh(argDateFrom,3)
	Set xDateTo=$zdh(argDateTo,3)
	Quit:(xDateFrom>xDateTo) $$$OK
	Quit:(xDateFrom+31<xDateTo) $$$OK      //允许查询时间相差31天
	Set OrdLocDR=0
	For {
		Set OrdLocDR=$o(^OEORDi(0,"UserDepartment",OrdLocDR))
		Quit:OrdLocDR=""
		Continue:(argLoc'="")&&(argLoc'=OrdLocDR)         //过滤科室
		Set OrdLoc=$p($g(^CTLOC(OrdLocDR)),"^",2)           //开医嘱科室
		
		For xDate=xDateFrom:1:xDateTo
		{
			Set OEOrdRowID=0
			For {
				Set OEOrdRowID=$o(^OEORDi(0,"UserDepartment",OrdLocDR,xDate,OEOrdRowID))	
				Quit:OEOrdRowID=""
	  			
	  			Set Paadm=$p($g(^OEORD(OEOrdRowID)),"^",1)
				Set Type=$p($g(^PAADM(Paadm)),"^",2)
				Continue:Type'="I"                                          //过滤非住院病人
				
				Set PAPMIDR=$p($g(^PAADM(Paadm)),"^",1)
				Set LocDR=$p($g(^PAADM(Paadm)),"^",4)
				Set AdmLoc=$p($g(^CTLOC(LocDR)),"^",2)                      //就诊科室
				Set AdmLoc=$p(AdmLoc,"-",2)                              
				Set CurrWardDR=$p($g(^PAADM(Paadm)),"^",70)
				Set CurrWard=$p($g(^PAWARD(CurrWardDR)),"^",2)              //当前病区
				Set CurrWard=$p(CurrWard,"-",2) 
				Set CurrBedDR=$p($g(^PAADM(Paadm)),"^",73)                  //当前床号
				Set CurrBedCode=""
				Set:CurrBedDR'="" CurrBedCode=$p($g(^PAWARD(CurrWardDR,"BED",$p(CurrBedDR,"||",2))),"^",1)                
				Set PatName=$p($g(^PAPER(PAPMIDR,"ALL")),"^",1)             //病人姓名
				Set Birthday=$p($g(^PAPER(PAPMIDR,"ALL")),"^",6)
				Set:Birthday'="" PatAge=..CalculateAge(+Birthday,+$h)       //病人年龄
				Set SexDR=$p($g(^PAPER(PAPMIDR,"ALL")),"^",7)
				Set PatSex=$p($g(^CT("SEX",SexDR)),"^",2)                   //病人性别
				Set PAPMIMedicare=$p($g(^PAPER(PAPMIDR,"PAT","1")),"^",22)  //病历号
				
				Set OEORIChildSub=0
				For	{
					Set OEORIChildSub=$o(^OEORDi(0,"UserDepartment",OrdLocDR,xDate,OEOrdRowID,OEORIChildSub))
					Quit:OEORIChildSub=""
					Set RowID=OEOrdRowID_"||"_OEORIChildSub
					
					Set OrdItm1=$g(^OEORD(OEOrdRowID,"I",OEORIChildSub,1))
					Continue:OrdItm1=""
					Set OrdItm2=$g(^OEORD(OEOrdRowID,"I",OEORIChildSub,2))
					Continue:OrdItm2=""
					
					Set ItmStatDR=$p(OrdItm1,"^",13)      
					Set OrdStatus=$p($g(^OEC("OSTAT",ItmStatDR)),"^",1)
					Continue:OrdStatus="D"                                 //过滤停止的医嘱
					Set ItmMastDR=$p(OrdItm1,"^",2)
					Continue:(argOrdItm'="")&&(argOrdItm'=ItmMastDR)       //过滤医嘱项
					Set ARCIMSub=$p(ItmMastDR,"||",1)
					Set ARCIMVer=$p(ItmMastDR,"||",2)
					Set OrdName=$p($g(^ARCIM(ARCIMSub,ARCIMVer,1)),"^",2)  //医嘱名称
					Set OrdType=$p(OrdItm1,"^",8)
					Set OrdType=$p($g(^OECPR(OrdType)),"^",2)              //医嘱类型
					Set PHCStr=..GetPhcCatAndPhcSubcat(ItmMastDR)
					Continue:PHCStr=""
					Set PHCCateg=$list(PHCStr,1)
					Set PHCSubCat=$list(PHCStr,2)
					Continue:(PHCCategList'="")&&($listfind(PHCCategList,PHCCateg)<1)
					Continue:(PHCSubCatList'="")&&($listfind(PHCSubCatList,PHCSubCat)<1)
					
					//Set OrdLoc=$p(OrdItm1,"^",3)
					//Continue:(argLoc'="")&&(argLoc'=OrdLoc)                             //过滤科室
					//Set OrdLoc=$p($g(^CTLOC(OrdLoc)),"^",2)                             //开医嘱科室
					Set SttDate=$p(OrdItm1,"^",9)
					Set:SttDate'="" SttDate=$zd(SttDate,3)                                //医嘱开始日期
					Set SttTime=$p(OrdItm1,"^",10)
					Set:SttTime'="" SttTime=$zt(SttTime,2)                                //医嘱开始时间
					Set SttDateTime=SttDate_" "_SttTime
					Set EndDate=$p($g(^OEORD(OEOrdRowID,"I",OEORIChildSub,9)),"^",9)
					Set:EndDate'="" EndDate=$zd(EndDate,3)
					Set EndTime=$p($g(^OEORD(OEOrdRowID,"I",OEORIChildSub,9)),"^",10)
					Set:EndTime'="" EndTime=$zt(EndTime,2)                                
					Set EndDateTime=EndDate_" "_EndTime								      //医嘱停止日期时间
					Set Doctor=$p(OrdItm1,"^",11)
					Set Doctor=$p($g(^CTPCP(+Doctor,1)),"^",2)                            //开医嘱医生
			         
					Set OrdDoseQty=$p(OrdItm2,"^",1)                                      //剂量
					Set (UOMDesc,PHCFreqDesc2,PHCInstrucDesc1)=""
					Set UnitDR=$p(OrdItm2,"^",3)
					Set:UnitDR'="" UOMDesc=$p($g(^CT("UOM",UnitDR)),"^",2)                //单位
					Set PHFreqDR=$p(OrdItm2,"^",4)
					Set:PHFreqDR'="" PHCFreqDesc2=$p($g(^PHCFR(PHFreqDR)),"^",4)          //频次
					Set InstrDR=$p(OrdItm2,"^",7)
					Set:InstrDR'="" PHCInstrucDesc1=$p($g(^PHCIN(InstrDR)),"^",2)         //用法
					Set PHCInstrucDesc1=$p(PHCInstrucDesc1,"-",2)
					
	
					Set Data=$lb(RowID,OrdLoc,Doctor,PatName,PatSex,PatAge,AdmLoc,CurrWard,CurrBedCode,OrdName,OrdType,PHCCateg,PHCSubCat,SttDate,SttTime,PHCFreqDesc2,PHCInstrucDesc1,OrdDoseQty,UOMDesc)
					Set Data=Data_$lb(PAPMIMedicare,SttDateTime,EndDateTime)
					Set ^CacheTemp(repid,ind)=Data
	    			Set ind=ind+1
				}
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryAntiByDateLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntiByDateLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAntiByDateLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntiByDateLocExecute ]
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

/// Creator：     fcz
/// CreatDate：   2012-06-14
/// Description:  查询药学大类、药学子类
/// Table：       
/// Input:        aArcim
/// return:       返回药学大类Code、Desc，药学子类Code、Desc
/// w ##class(DHCMed.NINFService.Srv.OEOrdItemAnti).GetPhcCatAndPhcSubcat("1000||1")
ClassMethod GetPhcCatAndPhcSubcat(aArcim As %String) As %List
{
	New (aArcim)
	Set return=""
	Quit:aArcim="" return
	
	Set DrgFormRowID=$p(^ARCIM(+aArcim,1,1),"^",12)       //PHC_DrgForm:药学形态
	Set DrugRowID=+DrgFormRowID                           //PHC_DrgMast药理学项
    Quit:DrugRowID=0 return
    Set PhcSubCatRowID=$p(^PHCD(DrugRowID,1),"^",3)       //PHC_SubCat药理学子分类
    Quit:PhcSubCatRowID="" return
    Set CatID=+PhcSubCatRowID                            //phc_cat药理学分类
    Set SubID=+$p(PhcSubCatRowID,"||",2)
    Set CategDesc=$p($g(^PHCC(CatID)),"^",2)
    Set SubCatDesc=$p($g(^PHCC(CatID,"SC",SubID)),"^",2)
    Quit:(CategDesc="")||(SubCatDesc="") return
    
    Set return=$lb(CategDesc,SubCatDesc)
    Quit return
}

ClassMethod CalculateAge(argBirthday As %String, argToday As %String) As %String
{
	New (argBirthday,argToday)
	Set return=""
	Set argBirthday=+argBirthday
	Set argToday=+argToday
    Quit:(argBirthday=0)||(argToday=0)||(argBirthday>argToday) return
    Set argBirthday=$zd(argBirthday,3)
    Set argToday=$zd(argToday,3)
    Set AgeYear=$p(argToday,"-",1)-$p(argBirthday,"-",1)
    Set AgeMth=$p(argToday,"-",2)-$p(argBirthday,"-",2)
    Set AgeDay=$p(argToday,"-",3)-$p(argBirthday,"-",3)
	If AgeDay<0 {
		Set AgeMth=AgeMth-1
		Set AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+$p(argToday,"-",2))
		If $p(argToday,"-",2)=2 {
			Set:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
		}
	}
	If AgeMth<0 {
	    Set AgeYear=AgeYear-1
	    Set AgeMth=12+AgeMth
	}
    If AgeYear>0 {
	    Set return=AgeYear_"岁"
	} Else {
		Set:AgeMth>0 return=AgeMth_"月"
		Set return=return_AgeDay_"天"
	}
    Quit return
}

/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Srv.OEOrdItemAnti","QryArcimByAnti","青霉素")
Query QryArcimByAnti(argAlias As %String) As %Query(ROWSPEC = "OrdRowID:%String,OrdCode:%String,OrdDesc:%String")
{
}

ClassMethod QryArcimByAntiExecute(ByRef qHandle As %Binary, argAlias As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set JIndex=$j,ZIndex=$zn
	
	//关联医嘱项
	Kill ^TMP(ZIndex,JIndex,"ARCItemMast")
	
	Set PHCCategList=$lb("抗感染药物")
	Set PHCSubCatList=$lb("抗生素","化学合成抗菌药物","抗真菌药物")
	
	//医嘱别名查询医嘱项
	//^ARC("ALIAS",0,"Desc",$$ALPHAUP({ALIAS_Text})_" ",$$ALPHAUP({ALIAS_Desc}),{ALIAS_RowId},1)
	Set argAlias=$$ALPHAUP^SSUTIL4(argAlias)
	Set Alias=$o(^ARC("ALIAS",0,"Desc",argAlias),-1)
	For {
		Set Alias=$o(^ARC("ALIAS",0,"Desc",Alias)) 
	  	Quit:(Alias="")||($e(Alias,1,$l(argAlias))'=argAlias)
	  
	  	Set ARCDesc=""
	  	For {
			Set ARCDesc=$o(^ARC("ALIAS",0,"Desc",Alias,ARCDesc))
			Quit:ARCDesc=""
			
			Set ARCRowid=0
			For {
				Set ARCRowid=$o(^ARC("ALIAS",0,"Desc",Alias,ARCDesc,ARCRowid))
				Quit:ARCRowid=""
				Continue:'$d(^ARC("ALIAS",ARCRowid))
				
				Set ARCType=$p(^ARC("ALIAS",ARCRowid),"^",5)
				Continue:ARCType'="ARCIM"
				Set ARCAlias=$p(^ARC("ALIAS",ARCRowid),"^",6)
				Set ARCAlias=$$ALPHAUP^SSUTIL4(ARCAlias)
				Continue:$e(ARCAlias,1,$l(argAlias))'=argAlias
				Set ARCItemID=$p(^ARC("ALIAS",ARCRowid),"^",1)
				Continue:ARCItemID=""
				Continue:$d(^TMP(ZIndex,JIndex,"ARCItemMast",ARCItemID))
				Do BuildDataToARCIM
				Set ^TMP(ZIndex,JIndex,"ARCItemMast",ARCItemID)=""
					
			}
		}
	}
	
	//医嘱名称查询医嘱项
	//^ARCIM(0,"Desc",$$ALPHAUP({ARCIM_Desc}),{ARCIM_Subscript},{ARCIM_Version})
	Set Alias=$o(^ARCIM(0,"Desc",argAlias),-1)
	For {
		Set Alias=$o(^ARCIM(0,"Desc",Alias))
		Quit:(Alias="")||($e(Alias,1,$l(argAlias))'=argAlias)
		
		Set ItemSub=0
		For {
			Set ItemSub=$o(^ARCIM(0,"Desc",Alias,ItemSub)) 
			Quit:ItemSub=""
			
			Set ItemVer=0
			For {
				Set ItemVer=$o(^ARCIM(0,"Desc",Alias,ItemSub,ItemVer))
				Quit:ItemVer=""
				
				Set ARCItemID=ItemSub_"||"_ItemVer
				Continue:$d(^TMP(ZIndex,JIndex,"ARCItemMast",ARCItemID))
				Do BuildDataToARCIM
				Set ^TMP(ZIndex,JIndex,"ARCItemMast",ARCItemID)=""	
			}
		} 	
	}
	Kill ^TMP(ZIndex,JIndex,"ARCItemMast")
	
	Quit $$$OK
	
BuildDataToARCIM
	Set ARCItemSub=$p(ARCItemID,"||",1)
	Set ARCItemVer=$p(ARCItemID,"||",2)
	Quit:(ARCItemSub="")||(ARCItemVer="")
	Set ARCItemCode=$p($g(^ARCIM(ARCItemSub,ARCItemVer,1)),"^",1)
	Set ARCItemDesc=$p($g(^ARCIM(ARCItemSub,ARCItemVer,1)),"^",2)
	Set PhcStr=##Class(DHCMed.NINFService.Srv.OEOrdItemAnti).GetPhcCatAndPhcSubcat(ARCItemID)
	Quit:PhcStr=""
	Set PHCCateg=$list(PhcStr,1)
	Set PHCSubCat=$list(PhcStr,2)
	Quit:(PHCCategList'="")&&($listfind(PHCCategList,PHCCateg)<1)       //按药学大类过滤医嘱项
	Quit:(PHCSubCatList'="")&&($listfind(PHCSubCatList,PHCSubCat)<1)    //按药学子类过滤医嘱项
	
	Set Data=$lb(ARCItemID,ARCItemCode,ARCItemDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod QryArcimByAntiClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryArcimByAntiExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryArcimByAntiFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryArcimByAntiExecute ]
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

}
