Import SQLUser

Class web.DHCEMPatSeat Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      huaxiaoying
/// CreatDate：    2016-07-20
/// Description:： 同时先后保存科室座位图字典表
/// Table：        DHC_EmPatSeat
/// Input：	       str
/// Return
/// d ##class(web.DHCEMPatSeat).SavePatSeat("4*4^")
ClassMethod SavePatSeat(str)
{
    ;s LocDr=%session.Get("LOGON.CTLOCID")
	;s SEType="类型"
	s SENum=$p(str,"^",1)
	s LocDr=$p(str,"^",2)
    ;s SEActiveFlag="Y"
	
	if ($d(^DHCEMPSE(0,"Loc",LocDr)))
	{
		q 1
	}
	else{
	
	s obj=##class(User.DHCEmPatSeat).%New()
	s obj.SELocDr=##class(User.CTLoc).%OpenId(LocDr,0)
	;s obj.SEType=SEType
	s obj.SENum=SENum
	s obj.SEWidth=100
	s obj.SEHeight=50
	;s obj.SEActiveFlag=SEActiveFlag
	s sc=obj.%Save()
	;&sql(delete DHCNurSySeat where SyLoc=:LocDr ) 
	
	q 0
	}
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-08-04
/// Description:： 更新科室座位图字典表
/// Table：        DHC_EmPatSeat
/// Input：	       LocDr
/// Return
/// w ##class(web.DHCEMPatSeat).UpdPatSeatrow(102)
ClassMethod UpdPatSeatrow(LocDr)
{
	s ID=""
	s ID=$o(^DHCEMPSE(0,"Loc",LocDr,ID))
	s SENum=$p(^DHCEMPSE(ID),"^",3)
	s SENumrow=$p(SENum,"*",1)+1
	s SENumcol=$p(SENum,"*",2)
	s SENum=SENumrow_"*"_SENumcol
	
	s obj=##class(User.DHCEmPatSeat).%OpenId(ID)
	s obj.SENum=SENum
	s sc=obj.%Save()
	q 0
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-08-04
/// Description:： 更新科室座位图字典表
/// Table：        DHC_EmPatSeat
/// Input：	       LocDr
/// Return
/// w ##class(web.DHCEMPatSeat).UpdPatSeatcol(102)
ClassMethod UpdPatSeatcol(LocDr)
{
	s ID=""
	s ID=$o(^DHCEMPSE(0,"Loc",LocDr,ID))
	s SENum=$p(^DHCEMPSE(ID),"^",3)
	s SENumrow=$p(SENum,"*",1)
	s SENumcol=$p(SENum,"*",2)+1
	s SENum=SENumrow_"*"_SENumcol
	if (SENumcol>6){
		q 2	
	}else{
	s obj=##class(User.DHCEmPatSeat).%OpenId(ID)
	s obj.SENum=SENum
	s sc=obj.%Save()
	q 0
	}
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-07-19
/// Description:： 保存科室座位图明细表
/// Table：		   DHC_EmPatSeatItm
/// Input：	       str
/// Return
/// d ##class(web.DHCEMPatSeat).SavePatSeatItm("4*4^Y^1-2^002号^1") //("4*4^Y^1-2^002号^成人")
/// 
/// d ##class(web.DHCEMPatSeat).SavePatSeatItm("*^Y^4-4^D^2^100") //("4*4^Y^1-2^002号^成人")
ClassMethod SavePatSeatItm(str)
{
    s SENum=$p(str,"^",1)
	s SEActiveFlag=$p(str,"^",2)
	s SECode=$p(str,"^",3)
	s SEDesc=$p(str,"^",4)
    s SEType=$p(str,"^",5)
    s LocDr=$p(str,"^",6)
    q:SEType="" -3
    s SETheParRef=""
    ;s LocDr=%session.Get("LOGON.CTLOCID")
    s PatSeatId=0
	f  s PatSeatId=$o(^DHCEMPSE(PatSeatId))  q:PatSeatId=""  d
	.s SELocDr=$p(^DHCEMPSE(PatSeatId),"^",1)
	.q:SELocDr'=LocDr
	.s SETheParRef=PatSeatId
	b ; SETheParRef
	if ($d(^DHCEMPSE(0,"Desc",SEDesc,SETheParRef)))
	{
		q 1
	}
	else{
		s obj=##class(User.DHCEmPatSeatItm).%New()
		s obj.SETheParRef=##class(User.DHCEmPatSeat).%OpenId(SETheParRef,0)
		s SEChildSub=$o(^DHCEMPSE(SETheParRef,"SE",""),-1)+1
		s obj.SEChildSub=SEChildSub
		s obj.SECode=SECode
		s obj.SEDesc=SEDesc
		s obj.SEType=##class(User.DHCEmPatSeatCat).%OpenId(SEType,0) ;SEType 2016-12-14 指向User.DHCEmPatSeatCat 2017-01-23
		s obj.SEPatDescDr=""
		d obj.%Save()
		d obj.%Close()
		q 0
	}
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-07-20
/// Description:： 列出科室座位图字典表
/// Table：        DHC_EmPatSeat
/// Input：	       str
/// Return
/// w ##class(web.DHCEMPatSeat).ListPatSeat()
ClassMethod ListPatSeat(LocDr)
{
	;s LocDr=%session.Get("LOGON.CTLOCID")
	s PatSeatId=0
	s SENum="",SEWidth="",SEHeight=""
	f  s PatSeatId=$o(^DHCEMPSE(PatSeatId))  q:PatSeatId=""  d
	.s SELocDr=$p(^DHCEMPSE(PatSeatId),"^",1)
	.q:SELocDr'=LocDr
	.s SENum= $p(^DHCEMPSE(PatSeatId),"^",3) 
	.s SEWidth= $p(^DHCEMPSE(PatSeatId),"^",5) ;2016-12-07
	.s SEHeight= $p(^DHCEMPSE(PatSeatId),"^",6) ;2016-12-07
    q """"_SENum_"-"_SEWidth_"*"_SEHeight_""""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-07-20
/// Description:： 列出科室座位图字典明细表
/// Table：        DHC_EmPatSeatItm
/// Input：	       str
/// Return
/// w ##class(web.DHCEMPatSeat).ListPatSeatItm(285) 
ClassMethod ListPatSeatItm(LocDr)
{
    ;s LocDr=%session.Get("LOGON.CTLOCID")
	s PatSeatId=0
	s SeatItmStr=""
	f  s PatSeatId=$o(^DHCEMPSE(PatSeatId))  q:PatSeatId=""  d
	.s SELocDr=$p(^DHCEMPSE(PatSeatId),"^",1)
	.q:SELocDr'=LocDr
	.s SeatItmSub=""
	.f  s SeatItmSub=$o(^DHCEMPSE(PatSeatId,"SE",SeatItmSub))  q:SeatItmSub=""  d
	..s SECode=$p(^DHCEMPSE(PatSeatId,"SE",SeatItmSub),"^",1)
	..s SEDesc=$p(^DHCEMPSE(PatSeatId,"SE",SeatItmSub),"^",2)
	..s SEType=$p(^DHCEMPSE(PatSeatId,"SE",SeatItmSub),"^",3)
	..s SEType=$p($g(^DHCEMPSC(SEType)),"^",2) ;2016-12-14 
	..s SeatItmStr=SeatItmStr_SECode_"^"_SEDesc_"^"_SEType_"*"
	s SeatItmStr = $e(SeatItmStr,1,$l(SeatItmStr)-1)   //去掉最后一个*符号
    q """"_SeatItmStr_""""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-07-21
/// Description:： 删除科室座位图字典表、明细表
/// Table：        DHC_EmPatSeatItm、DHC_EmPatSeat
/// Input：	       str
/// Return
/// w ##class(web.DHCEMPatSeat).DeletePatSeat()
ClassMethod DeletePatSeat(LocDr)
{
	;s LocDr=%session.Get("LOGON.CTLOCID")
	s Rs=0
	s PatSeatId=0
	f  s PatSeatId=$o(^DHCEMPSE(PatSeatId))  q:PatSeatId=""  d
	.b ;err1
	.s SELocDr=$p(^DHCEMPSE(PatSeatId),"^",1)
	.q:SELocDr'=LocDr
  	.s child=""
  	.f  s child=$o(^DHCEMPSE(PatSeatId,"SE",child)) quit:(child="")!(+Rs'=0)  d
  	..s SeatItmId=PatSeatId_"||"_child
  	..q:+$p(^DHCEMPSE(PatSeatId,"SE",child),"^",4)="0"
  	..b ;err2
  	..s Rs=2
  	i +Rs=0 d
  	.d ##class(User.DHCEmPatSeat).%DeleteId(PatSeatId)
  	.d ##Class(web.DHCEMPatSeat).ClearAllSeat(LocDr)
  	;&sql(delete DHCNurSySeat where SyLoc=:LocDr ) 
  	q Rs
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-07-21
/// Description:： 删除科室座位图字典表、明细表（所有）
/// Table：        DHC_EmPatSeatItm、DHC_EmPatSeat
/// Input：	       str
/// Return
/// w ##class(web.DHCEMPatSeat).ClearAllSeat()
ClassMethod ClearAllSeat(LocDr)
{
	;s LocDr=%session.Get("LOGON.CTLOCID")
	s Rs=""
	s PatSeatId=0
	f  s PatSeatId=$o(^DHCEMPSE(PatSeatId))  q:PatSeatId=""  d
	.s SELocDr=$p(^DHCEMPSE(PatSeatId),"^",1)
	.q:SELocDr'=LocDr
  	.s obj=##class(User.DHCEmPatSeat).%DeleteId(PatSeatId)
  	.s child=""
  	.f  s child=$o(^DHCEMPSE(PatSeatId,"SE",child)) quit:(child="")!(Rs'="")  d
  	..s SeatItmId=PatSeatId_"||"_child
 	..s obj=##class(User.DHCEmPatSeatItm).%DeleteId(SeatItmId)
  	q 0
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-07-21
/// Description:： 删除科室座位图字典表、明细表
/// Table：        DHC_EmPatSeatItm、DHC_EmPatSeat
/// Input：	       str
/// Return
/// w ##class(web.DHCEMPatSeat).DeletePatSeat()
ClassMethod DeletePatSeat1(LocDr)
{
    
	;s LocDr=%session.Get("LOGON.CTLOCID")
	
	S ResFlag="Y"
	&sql(select SySeatDes into :SeatDesc from DHCNurSySeat where SyLoc=:LocDr and SySeatFlag=:ResFlag)
	I (SQLCODE=0){
		Q 2
	}Else {
		s PatSeatId=0
		f  s PatSeatId=$o(^DHCEMPSE(PatSeatId))  q:PatSeatId=""  d
		.s SELocDr=$p(^DHCEMPSE(PatSeatId),"^",1)
		.q:SELocDr'=LocDr
	  	.s obj=##class(User.DHCEmPatSeat).%DeleteId(PatSeatId)
	  	.s child=""
	  	.f  s child=$o(^DHCEMPSE(PatSeatId,"SE",child)) quit:child=""  d
	  	..s SeatItmId=PatSeatId_"||"_child
	  	..s obj=##class(User.DHCEmPatSeatItm).%DeleteId(SeatItmId)
	  	;&sql(delete DHCNurSySeat where SyLoc=:LocDr ) 
	  	q 0 
		}
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-07-21
/// Description:： 删除科室座位图明细表
/// Table：        DHC_EmPatSeatItm
/// Input：	       str
/// Return
/// w ##class(web.DHCEMPatSeat).DeletePatSeatItm()
ClassMethod DeletePatSeatItm1(Code, LocDr)
{
    
	;s LocDr=%session.Get("LOGON.CTLOCID")
	//Code:2-6
	S ResFlag=""
	&sql(select SySeatFlag into :ResFlag from DHCNurSySeat where SyLoc=:LocDr and SySeatDes=:Code)
	IF (SQLCODE=0){
		if (ResFlag="N"){
			s PatSeatId=0
			f  s PatSeatId=$o(^DHCEMPSE(PatSeatId))  q:PatSeatId=""  d
			.s SELocDr=$p(^DHCEMPSE(PatSeatId),"^",1)
			.q:SELocDr'=LocDr
		  	.s child=""
		  	.f  s child=$o(^DHCEMPSE(PatSeatId,"SE",child)) quit:child=""  d
		  	..s SECode=$p(^DHCEMPSE(PatSeatId,"SE",child),"^",1)
		  	..q:SECode'=Code
		  	..s SeatItmId=PatSeatId_"||"_child
		  	..s obj=##class(User.DHCEmPatSeatItm).%DeleteId(SeatItmId) 
		  	q 0
			
		}ELSE{
			Q 2 
			}
	}Else {
		;Q 1
		s PatSeatId=0
		f  s PatSeatId=$o(^DHCEMPSE(PatSeatId))  q:PatSeatId=""  d
		.s SELocDr=$p(^DHCEMPSE(PatSeatId),"^",1)
		.q:SELocDr'=LocDr
	  	.s child=""
	  	.f  s child=$o(^DHCEMPSE(PatSeatId,"SE",child)) quit:child=""  d
	  	..s SECode=$p(^DHCEMPSE(PatSeatId,"SE",child),"^",1)
	  	..q:SECode'=Code
	  	..s SeatItmId=PatSeatId_"||"_child
	  	..s obj=##class(User.DHCEmPatSeatItm).%DeleteId(SeatItmId) 
	  	q 0 
	}
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-07-21
/// Description:： 删除科室座位图明细表
/// Table：        DHC_EmPatSeatItm
/// Input：	       str
/// Return         2 有人不能删除，0无人能删除
/// w ##class(web.DHCEMPatSeat).DeletePatSeatItm()
ClassMethod DeletePatSeatItm(Code, LocDr)
{
	s Rs=2     
	s PatSeatId=0
	f  s PatSeatId=$o(^DHCEMPSE(PatSeatId))  q:PatSeatId=""  d
	.s SELocDr=$p(^DHCEMPSE(PatSeatId),"^",1)
	.q:SELocDr'=LocDr
  	.s child=""
  	.f  s child=$o(^DHCEMPSE(PatSeatId,"SE",child)) quit:child=""  d
  	..s SECode=$p(^DHCEMPSE(PatSeatId,"SE",child),"^",1)
  	..q:SECode'=Code
  	..q:+$p(^DHCEMPSE(PatSeatId,"SE",child),"^",4)'="0"
  	..s SeatItmId=PatSeatId_"||"_child
  	..s obj=##class(User.DHCEmPatSeatItm).%DeleteId(SeatItmId) 
  	..s Rs=0
  	q Rs
}

/// Creator：      huaxiaoying
/// CreatDate：    2017-02-13
/// Description:： 删除该整行 
/// Table：        DHC_EmPatSeat、DHC_EmPatSeatItm
/// Input：	       LocDr：科室id,Code：座位代码,
/// Return
/// d ##class(web.DHCEMPatSeat).DeletePatSeatRow("1-4","4")
ClassMethod DeletePatSeatRow(Code, LocDr)
{
 
	s ID="",IfHavePat=0,IfHaveSeat=0,SeatStr="",num=0,return=""
	s ID=$o(^DHCEMPSE(0,"Loc",LocDr,ID))
	S tabRow=$p(Code,"-",1)
	s child=""
	f  s child=$o(^DHCEMPSE(ID,"SE",child)) quit:child=""  d
	.s SECode=$p(^DHCEMPSE(ID,"SE",child),"^",1)
	.s SECodeRow=$p(SECode,"-",1)
  	.q:SECodeRow'=tabRow
  	.s IfHaveSeat=1 //2017-02-15
	.i +$p(^DHCEMPSE(ID,"SE",child),"^",4)'="0" d
	..s IfHavePat=1
	..s SEDesc=$p(^DHCEMPSE(ID,"SE",child),"^",2) //2017-02-15↓
	..i num=0  d								  //2017-02-15
	...s SeatStr=SeatStr_SEDesc
	..else  d
	...s SeatStr=SeatStr_"、"_SEDesc			  //2017-02-15
	..s num=num+1								  //2017-02-15↑
	.
	if (IfHavePat=1)
	{
		q """"_SeatStr_"^1"_"""" //q IfHavePat //2017-02-15
	}else{
		if (IfHaveSeat=1){//2017-02-15
			q 2
		}else{
			S return=..DeletePatSeatRowYes(Code, LocDr)
			q return
			/*s SeatItmSub=""
			f  s SeatItmSub=$o(^DHCEMPSE(ID,"SE",SeatItmSub))  q:SeatItmSub=""  d
			.s SECode=$p(^DHCEMPSE(ID,"SE",SeatItmSub),"^",1)
			.s SECodeRow=$p(SECode,"-",1)
			.s SECodeCol=$p(SECode,"-",2)
			.s ItmID=ID_"||"_SeatItmSub
			.i SECodeRow=tabRow d
			..s Itmobj=##class(User.DHCEmPatSeatItm).%DeleteId(ItmID) 
			.e  d
			.i SECodeRow>tabRow d
			..s SECodeRow=SECodeRow-1
			..s SECode=SECodeRow_"-"_SECodeCol
			..s Itmobj=##class(User.DHCEmPatSeatItm).%OpenId(ItmID)
			..s Itmobj.SECode=SECode
			..s sc=Itmobj.%Save()
			.
			s SENum=$p(^DHCEMPSE(ID),"^",3)
			s SENumrow=$p(SENum,"*",1)-1
			s SENumcol=$p(SENum,"*",2)
			s SENum=SENumrow_"*"_SENumcol
			i SENumrow=0  d
			.s obj=##class(User.DHCEmPatSeat).%DeleteId(ID) 
			else  d
			.s obj=##class(User.DHCEmPatSeat).%OpenId(ID)
			.s obj.SENum=SENum
			.s sc=obj.%Save()
			q 0	*/

		}
		
	}
}

/// Creator：      huaxiaoying
/// CreatDate：    2017-02-15
/// Description:： 删除该整行 ,供DeletePatSeatRow调用
/// Table：        DHC_EmPatSeat、DHC_EmPatSeatItm
/// Input：	       LocDr：科室id,Code：座位代码,
/// Return         0
/// d ##class(web.DHCEMPatSeat).DeletePatSeatRowYes("1-4","4")
ClassMethod DeletePatSeatRowYes(Code, LocDr)
{
	
	s ID=""
	s ID=$o(^DHCEMPSE(0,"Loc",LocDr,ID))
	S tabRow=$p(Code,"-",1)
	
	s SeatItmSub=""
	f  s SeatItmSub=$o(^DHCEMPSE(ID,"SE",SeatItmSub))  q:SeatItmSub=""  d
	.s SECode=$p(^DHCEMPSE(ID,"SE",SeatItmSub),"^",1)
	.s SECodeRow=$p(SECode,"-",1)
	.s SECodeCol=$p(SECode,"-",2)
	.s ItmID=ID_"||"_SeatItmSub
	.i SECodeRow=tabRow d
	..s Itmobj=##class(User.DHCEmPatSeatItm).%DeleteId(ItmID) 
	.e  d
	.i SECodeRow>tabRow d
	..s SECodeRow=SECodeRow-1
	..s SECode=SECodeRow_"-"_SECodeCol
	..s Itmobj=##class(User.DHCEmPatSeatItm).%OpenId(ItmID)
	..s Itmobj.SECode=SECode
	..s sc=Itmobj.%Save()
	.
	s SENum=$p(^DHCEMPSE(ID),"^",3)
	s SENumrow=$p(SENum,"*",1)-1
	s SENumcol=$p(SENum,"*",2)
	s SENum=SENumrow_"*"_SENumcol
	i SENumrow=0  d
	.s obj=##class(User.DHCEmPatSeat).%DeleteId(ID) 
	else  d
	.s obj=##class(User.DHCEmPatSeat).%OpenId(ID)
	.s obj.SENum=SENum
	.s sc=obj.%Save()
	q 0
}

/// Creator：      huaxiaoying
/// CreatDate：    2017-02-13
/// Description:： 删除该整列 
/// Table：        DHC_EmPatSeat、DHC_EmPatSeatItm
/// Input：	       LocDr：科室id,Code：座位代码,
/// Return
/// d ##class(web.DHCEMPatSeat).DeletePatSeatCol()
ClassMethod DeletePatSeatCol(Code, LocDr)
{
	s ID="",IfHavePat=0,IfHaveSeat=0,SeatStr="",num=0,return=""
	s ID=$o(^DHCEMPSE(0,"Loc",LocDr,ID))
	S tabCol=$p(Code,"-",2)
	s child=""
	f  s child=$o(^DHCEMPSE(ID,"SE",child)) quit:child=""  d
	.s SECode=$p(^DHCEMPSE(ID,"SE",child),"^",1)
	.s SECodeCol=$p(SECode,"-",2)
  	.q:SECodeCol'=tabCol
  	.s IfHaveSeat=1 //2017-02-15
	.i +$p(^DHCEMPSE(ID,"SE",child),"^",4)'="0" d
	..s IfHavePat=1
	..s SEDesc=$p(^DHCEMPSE(ID,"SE",child),"^",2) //2017-02-15↓↓
	..i num=0  d
	...s SeatStr=SeatStr_SEDesc
	..else  d
	...s SeatStr=SeatStr_"、"_SEDesc
	..s num=num+1								  //2017-02-15↑↑
	.
	if (IfHavePat=1)
	{
		q """"_SeatStr_"^1"_"""" //q IfHavePat //2017-02-15
	}else{
		if (IfHaveSeat=1){//2017-02-15
			q 2
		}else{
			S return=..DeletePatSeatColYes(Code, LocDr)
			q return
		}
		/*s SeatItmSub=""
		f  s SeatItmSub=$o(^DHCEMPSE(ID,"SE",SeatItmSub))  q:SeatItmSub=""  d
		.s SECode=$p(^DHCEMPSE(ID,"SE",SeatItmSub),"^",1)
		.s SECodeRow=$p(SECode,"-",1)
		.s SECodeCol=$p(SECode,"-",2)
		.s ItmID=ID_"||"_SeatItmSub
		.i SECodeCol=tabCol d
		..s Itmobj=##class(User.DHCEmPatSeatItm).%DeleteId(ItmID) 
		.e  d
		.i SECodeCol>tabCol d
		..s SECodeCol=SECodeCol-1
		..s SECode=SECodeRow_"-"_SECodeCol
		..s Itmobj=##class(User.DHCEmPatSeatItm).%OpenId(ItmID)
		..s Itmobj.SECode=SECode
		..s sc=Itmobj.%Save()
		.
		s SENum=$p(^DHCEMPSE(ID),"^",3)
		s SENumrow=$p(SENum,"*",1)
		s SENumcol=$p(SENum,"*",2)-1
		s SENum=SENumrow_"*"_SENumcol
		i SENumcol=0  d
		.s obj=##class(User.DHCEmPatSeat).%DeleteId(ID) 
		else  d
		.s obj=##class(User.DHCEmPatSeat).%OpenId(ID)
		.s obj.SENum=SENum
		.s sc=obj.%Save()
		q 0	*/
	}
}

/// Creator：      huaxiaoying
/// CreatDate：    2017-02-15
/// Description:： 删除该整列, 供DeletePatSeatCol调用
/// Table：        DHC_EmPatSeat、DHC_EmPatSeatItm
/// Input：	       LocDr：科室id,Code：座位代码,
/// Return
/// d ##class(web.DHCEMPatSeat).DeletePatSeatColYes()
ClassMethod DeletePatSeatColYes(Code, LocDr)
{
	s ID=""
	s ID=$o(^DHCEMPSE(0,"Loc",LocDr,ID))
	S tabCol=$p(Code,"-",2)
	
	s SeatItmSub=""
	f  s SeatItmSub=$o(^DHCEMPSE(ID,"SE",SeatItmSub))  q:SeatItmSub=""  d
	.s SECode=$p(^DHCEMPSE(ID,"SE",SeatItmSub),"^",1)
	.s SECodeRow=$p(SECode,"-",1)
	.s SECodeCol=$p(SECode,"-",2)
	.s ItmID=ID_"||"_SeatItmSub
	.i SECodeCol=tabCol d
	..s Itmobj=##class(User.DHCEmPatSeatItm).%DeleteId(ItmID) 
	.e  d
	.i SECodeCol>tabCol d
	..s SECodeCol=SECodeCol-1
	..s SECode=SECodeRow_"-"_SECodeCol
	..s Itmobj=##class(User.DHCEmPatSeatItm).%OpenId(ItmID)
	..s Itmobj.SECode=SECode
	..s sc=Itmobj.%Save()
	.
	s SENum=$p(^DHCEMPSE(ID),"^",3)
	s SENumrow=$p(SENum,"*",1)
	s SENumcol=$p(SENum,"*",2)-1
	s SENum=SENumrow_"*"_SENumcol
	i SENumcol=0  d
	.s obj=##class(User.DHCEmPatSeat).%DeleteId(ID) 
	else  d
	.s obj=##class(User.DHCEmPatSeat).%OpenId(ID)
	.s obj.SENum=SENum
	.s sc=obj.%Save()
	q 0
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-08-02
/// Description:： 判断该床位是否有床
/// Table：        DHC_EmPatSeatItm
/// Input：	       CODE
/// Return
/// w ##class(web.DHCEMPatSeat).IfHaveBed()
ClassMethod IfHaveBed(CODE, LocDr)
{
	s ID=""
	s ID=$o(^DHCEMPSE(0,"Loc",LocDr,ID))
	if ($d(^DHCEMPSE(0,"Code",CODE,ID)))
		{
			q 1
		}else{
			q 2
		}
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-08-03
/// Description:： 当前安全组科室下拉
/// Table：        
/// Input：	       
/// Return
/// d ##class(web.DHCEMPatSeat).ListLoc()
ClassMethod ListLocOld(q = "")
{
	s grpdr=%session.Get("LOGON.GROUPID")
	s count=0
	w "["
	s sub=""
	f  s sub=$o(^SSU("SSGRP",grpdr,"ST",sub)) q:sub=""  d
	.s ctlocdr=$p(^SSU("SSGRP",grpdr,"ST",sub),"^",1)
	.q:'$d(^CTLOC(ctlocdr)) //add hxy 2016-08-03
	.s ctlocdesc=$p(^CTLOC(ctlocdr),"^",2)
	.q:(q'="")&(ctlocdesc'[($$ALPHAUP^SSUTIL4(q))) // 2017-01-06
	.s ctloctype=$p(^CTLOC(ctlocdr),"^",13)
	.;q:ctloctype'="D" //注释2016-10-25 
    .s tmp=ctlocdr_"^"_ctlocdesc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData("id^text",tmp)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("id^text",tmp)
	w "]"
	q ""
	    
	;w ##CLASS(web.DHCSTCNTSCOMMON).GetStockPhlocDs(1)
}

/// Creator：      qqa
/// CreatDate：    2017-07-11
/// Description:： 当前安全组科室下拉
/// Table：        
/// Input：	       
/// Return
/// d ##class(web.DHCEMPatSeat).ListLoc()
ClassMethod ListLoc(HospDr, q = "")
{
	
	
	k ^TMP("DHCEM","web.DHCEMPatSeat","ListLoc")
	s repid=$i(^CacheTemp)
	f i =1:1:2 d
	.s:i=1 TypeDesc="E"
	.s:i=2 TypeDesc="O"
	.s LocDesc = ""
	.f  s LocDesc = $o(^PAC("ADMLOC",0,"TypeDesc",TypeDesc,LocDesc)) q:LocDesc=""  d
	..s PacDr = ""
	..f  s PacDr = $o(^PAC("ADMLOC",0,"TypeDesc",TypeDesc,LocDesc,PacDr)) q:PacDr=""  d
	...q:$d(^PAC("ADMLOC",PacDr))=0
	...s LocDr = $p(^PAC("ADMLOC",PacDr),"^",2)
	...q:$d(^CTLOC(LocDr))=0
	...q:$p(^CTLOC(LocDr),"^",14)'="Y"
	...q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("CT_Loc",LocDr,HospDr)'="Y" //hxy 2020-05-24
	...s StDate = $p(^CTLOC(LocDr),"^",24)
	...s EndDate = $p(^CTLOC(LocDr),"^",25)
	...q:(StDate'="")&&(+$h<StDate)
	...q:(EndDate'="")&&(+$h>EndDate)
	...s LocName = $p(^CTLOC(LocDr),"^",2)
	...s:LocName["-" LocName = $p(LocName,"-",2)
	...s LocContactName = $p(^CTLOC(LocDr),"^",43)
	...;q:+LocContactName=0
	...s LocName = LocContactName_"-"_LocName
	...q:(q'="")&($$ALPHAUP^SSUTIL4(LocName)'[($$ALPHAUP^SSUTIL4(q)))
	...s Tmp = LocDr_"^"_$p(LocName,"-",2)
	...s ^TMP("DHCEM","web.DHCEMPatSeat","ListLoc",repid,LocDr)=Tmp
	 
	w "["
	s LocDr="",count=0
	f  s LocDr = $o(^TMP("DHCEM","web.DHCEMPatSeat","ListLoc",repid,LocDr))  q:LocDr=""  d
	.s count = count+1
	.s Tmp=^TMP("DHCEM","web.DHCEMPatSeat","ListLoc",repid,LocDr)
	.i count=1 d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData("id^text",Tmp)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("id^text",Tmp)
	w "]"
	k ^TMP("DHCEM","web.DHCEMPatSeat","ListLoc")
	q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-08-04
/// Description:： 该行上下方增加一行
/// Table：        DHC_EmPatSeat、DHC_EmPatSeatItm
/// Input：	       LocDr：科室id,Code：座位代码,type：1上2下
/// Return
/// d ##class(web.DHCEMPatSeat).AddRowtop()
ClassMethod AddRowtop(LocDr, Code, TypeModel)
{
	s ID=""
	s ID=$o(^DHCEMPSE(0,"Loc",LocDr,ID))
	s SENum=$p(^DHCEMPSE(ID),"^",3)
	s SENumrow=$p(SENum,"*",1)+1
	s SENumcol=$p(SENum,"*",2)
	s SENum=SENumrow_"*"_SENumcol
	
	s obj=##class(User.DHCEmPatSeat).%OpenId(ID)
	s obj.SENum=SENum
	s sc=obj.%Save()
	
	S tabRow=$p(Code,"-",1)
	
	s SeatItmSub=""
	f  s SeatItmSub=$o(^DHCEMPSE(ID,"SE",SeatItmSub))  q:SeatItmSub=""  d
	.s SECode=$p(^DHCEMPSE(ID,"SE",SeatItmSub),"^",1)
	.s SECodeRow=$p(SECode,"-",1)
	.s SECodeCol=$p(SECode,"-",2)
	.i TypeModel=1 d
	..i SECodeRow>=tabRow d
	...s SECodeRow=SECodeRow+1
	.e  d
	..i SECodeRow>tabRow d
	...s SECodeRow=SECodeRow+1
	.s SECode=SECodeRow_"-"_SECodeCol
	.s ItmID=ID_"||"_SeatItmSub
	
	.s Itmobj=##class(User.DHCEmPatSeatItm).%OpenId(ItmID)
	.s Itmobj.SECode=SECode
	.s sc=Itmobj.%Save()
	;d ##class(web.DHCEMPatientSeat).UpdateSeatDesc(LocDr)
	q 0
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-08-04
/// Description:： 该列前后方增加一列
/// Table：        DHC_EmPatSeat、DHC_EmPatSeatItm
/// Input：	       LocDr：科室id,Code：座位代码,type：1前2后
/// Return
/// d ##class(web.DHCEMPatSeat).AddColleft()
ClassMethod AddColleft(LocDr, Code, TypeModel)
{
	s ID=""
	s ID=$o(^DHCEMPSE(0,"Loc",LocDr,ID))
	s SENum=$p(^DHCEMPSE(ID),"^",3)
	s SENumrow=$p(SENum,"*",1)
	s SENumcol=$p(SENum,"*",2)+1
	s SENum=SENumrow_"*"_SENumcol
	;if (SENumcol>6){  //hxy 注释 2016-10-19
	;	q 2			   //hxy 注释 2016-10-19
	;}else{            //hxy 注释 2016-10-19
	s obj=##class(User.DHCEmPatSeat).%OpenId(ID)
	s obj.SENum=SENum
	s sc=obj.%Save()
	
	S tabRow=$p(Code,"-",2)
	
	s SeatItmSub=""
	f  s SeatItmSub=$o(^DHCEMPSE(ID,"SE",SeatItmSub))  q:SeatItmSub=""  d
	.s SECode=$p(^DHCEMPSE(ID,"SE",SeatItmSub),"^",1)
	.s SECodeRow=$p(SECode,"-",1)
	.s SECodeCol=$p(SECode,"-",2)
	.i TypeModel=1 d
	..i SECodeCol>=tabRow d
	...s SECodeCol=SECodeCol+1
	.e  d
	..i SECodeCol>tabRow d
	...s SECodeCol=SECodeCol+1
	.s SECode=SECodeRow_"-"_SECodeCol
	.s ItmID=ID_"||"_SeatItmSub
	
	.s Itmobj=##class(User.DHCEmPatSeatItm).%OpenId(ItmID)
	.s Itmobj.SECode=SECode
	.s sc=Itmobj.%Save()
	;d ##class(web.DHCEMPatientSeat).UpdateSeatDesc(LocDr)
	q 0
	;}   //hxy 注释 2016-10-19
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-10-20
/// Description:： 保存设置座位图使用界面的宽x高
/// Table：        DHC_EmPatSeat
/// Input：	       str
/// Return
/// d ##class(web.DHCEMPatSeat).SavePatSeatStyle()
ClassMethod SavePatSeatStyle(str)
{
	s seat=$p(str,"^",1)
	s seatw=$p(seat,"*",1)
	s seath=$p(seat,"*",2)
	s LocDr=$p(str,"^",2)
	s ID=""
	s ID=$o(^DHCEMPSE(0,"Loc",LocDr,ID))
	
	s obj=##class(User.DHCEmPatSeat).%OpenId(ID)
	s obj.SEWidth=seatw
	s obj.SEHeight=seath
	s sc=obj.%Save()
	q 0
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-12-14
/// Description:： 床铺类型下拉
/// Table：        DHC_EmPatSeatCat
/// Input：	       
/// Return
/// d ##class(web.DHCEMPatSeat).ListType()
ClassMethod ListType(HospDr)
{
	;s HospDr=%session.Get("LOGON.HOSPID") //hxy 2019-09-18 云his公有
	s count=0
	w "["
	s pscId=""
	f  s pscId=$o(^DHCEMPSC(pscId)) q:pscId=""  d
	.q:pscId=0
	.s desc=$p(^DHCEMPSC(pscId),"^",2)
	.s PSCActiveFlag=$p(^DHCEMPSC(pscId),"^",3)
	.q:PSCActiveFlag="N"
	.s PSCHospDr=$p(^DHCEMPSC(pscId),"^",4)
	.;q:HospDr'=PSCHospDr //hxy 2019-09-18 云his公有
	.s RealHospDr=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmPatSeatCat",HospDr) //hxy 2020-05-24 st
	.q:PSCHospDr'=RealHospDr //ed
    .s tmp=pscId_"^"_desc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData("id^text",tmp)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("id^text",tmp)
	w "]"
	q ""
}

}
