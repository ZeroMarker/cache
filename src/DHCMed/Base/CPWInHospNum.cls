/// Creator:		zhaoyu
/// CreateDate:		2012-12-27
/// Description:	650自定义页签临床路径接口开发
Class DHCMed.Base.CPWInHospNum Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:		zhaoyu
/// CreatDate:		2012-12-27
/// Description:	按条件查询在院人数
/// Input:			方式：1-科室/2-路径；状态：I-入径/O-出径/V-变异
/// Debug:	w ##Class(%ResultSet).RunQuery("DHCMed.Base.CPWInHospNum","QryCPWInHospNum","1","I") q
Query QryCPWInHospNum(argType As %String, argStatus As %String) As %Query(ROWSPEC = "Desc:%String,Count:%String") [ SqlProc ]
{
}

ClassMethod QryCPWInHospNumExecute(ByRef qHandle As %Binary, argType As %String, argStatus As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:(argType="")||(argStatus="") $$$OK
	Set Type=$s(argType="1":"科室",argType="2":"路径",1:"Error")
	Set Status=$s(argStatus="I":"入径",argStatus="O":"出径",argStatus="V":"变异",1:"Error")	
	Quit:(Type="Error")||(Status="Error") $$$OK
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"QryCPWInHospNum")
	
	Set WardID=0
	For {
		Set WardID=$o(^PAADMi("CurrWard",WardID))  //通过病区、病房查找在院病人人数
		Quit:WardID=""
		Set RoomID=0
		For {
			Set RoomID=$o(^PAADMi("CurrWard",WardID,RoomID))
			Quit:RoomID=""
			Set Paadm=0
			For {
				Set Paadm=$o(^PAADMi("CurrWard",WardID,RoomID,Paadm))
				Quit:Paadm=""
				
				Set AdmInfo=$g(^PAADM(Paadm))
				Continue:$p(AdmInfo,"^",2)'="I"  //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"  //就诊状态过滤
				
				Set (CPWLoc,CPWDesc)=""
				Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
				Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,""),-1)
				Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
				Continue:'$IsObject(objPathWay)		//过滤非入径患者
				//路径科室，路径科室为空，取就诊科室
				Set CPWLocID=objPathWay.CPWInLoc
				Set:CPWLocID="" CPWLocID=$p(AdmInfo,"^",4)
				Set:CPWLocID'="" CPWLoc=$p($g(^CTLOC(CPWLocID)),"^",2)
				Set:$l($p(CPWLoc,"-",2))>1 CPWLoc=$p(CPWLoc,"-",2)
				//路径名称
				If $IsObject(objPathWay.CPWPathwayDR){
					Set CPWDesc=objPathWay.CPWPathwayDR.CPWDesc
				}
				//Continue:(CPWLoc="")||(CPWDesc="")	//过滤科室和路径
				//是否出径
				Set CPWStatus=objPathWay.CPWStatus
				//是否变异
				Set VarInfo=##Class(web.DHCCPW.MR.ClinPathWaysVariance).GetVarInfo(PathWayID)
				If (VarInfo'=""){
					Set VarCount=$list(VarInfo,1)
				}Else{
					Set VarCount=0
				}
				//计数
				Set Desc=$s(Type="科室":CPWLoc,Type="路径":CPWDesc,1:"Error")
				Set:Desc="" Desc="其它"
				Set:(Status="入径") num=$i(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Count",Desc))
				Set:(CPWStatus="O")&&(Status="出径") num=$i(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Count",Desc))
				Set:(VarCount>0)&&(Status="变异") num=$i(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Count",Desc))
			}
		}
	}
	//	以在院人数为节点排序
	Set xDesc=""
	For {
		Set xDesc=$o(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Count",xDesc))
		Quit:xDesc=""
		
		Set xnum=+$g(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Count",xDesc))
		Set ^TMP(ZIndex,JIndex,"QryCPWInHospNum","Sort",xnum,xDesc)=""	//
	}
	//	输出数据（前十个）
	Set ynum="",index=0
	For {
		Set ynum=$o(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Sort",ynum),-1)
		Quit:ynum=""
		//Quit:index>9	//10+条记录
		
		Set yDesc=""
		For {
			Set yDesc=$o(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Sort",ynum,yDesc))
			Quit:yDesc=""
			Quit:index>9	//10条记录
			Set index=index+1
		
			Set Data=$lb(yDesc,ynum)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP(ZIndex,JIndex,"QryCPWInHospNum")
	Quit $$$OK
}

ClassMethod QryCPWInHospNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWInHospNumExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCPWInHospNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWInHospNumExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	} Else {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

//*********************

/// Creator:		zhaoyu
/// CreatDate:		2012-12-27
/// Description:	科室在院入径人数
/// Input:			方式：1-科室/2-路径；状态：I-入径/O-出径/V-变异
/// Debug:	w ##Class(%ResultSet).RunQuery("DHCMed.Base.CPWInHospNum","QryCPWInHospNum1I") q
Query QryCPWInHospNum1I() As %Query(ROWSPEC = "Desc:%String,Count:%String") [ SqlProc ]
{
}

ClassMethod QryCPWInHospNum1IExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	/*
	Quit:(argType="")||(argStatus="") $$$OK
	Set Type=$s(argType="1":"科室",argType="2":"路径",1:"Error")
	Set Status=$s(argStatus="I":"入径",argStatus="O":"出径",argStatus="V":"变异",1:"Error")	
	Quit:(Type="Error")||(Status="Error") $$$OK
	*/
	Set Type="科室",Status="入径"
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"QryCPWInHospNum")
	
	Set WardID=0
	For {
		Set WardID=$o(^PAADMi("CurrWard",WardID))  //通过病区、病房查找在院病人人数
		Quit:WardID=""
		Set RoomID=0
		For {
			Set RoomID=$o(^PAADMi("CurrWard",WardID,RoomID))
			Quit:RoomID=""
			Set Paadm=0
			For {
				Set Paadm=$o(^PAADMi("CurrWard",WardID,RoomID,Paadm))
				Quit:Paadm=""
				
				Set AdmInfo=$g(^PAADM(Paadm))
				Continue:$p(AdmInfo,"^",2)'="I"  //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"  //就诊状态过滤
				
				Set (CPWLoc,CPWDesc)=""
				Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
				Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,""),-1)
				Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
				Continue:'$IsObject(objPathWay)		//过滤非入径患者
				//路径科室，路径科室为空，取就诊科室
				Set CPWLocID=objPathWay.CPWInLoc
				Set:CPWLocID="" CPWLocID=$p(AdmInfo,"^",4)
				Set:CPWLocID'="" CPWLoc=$p($g(^CTLOC(CPWLocID)),"^",2)
				Set:$l($p(CPWLoc,"-",2))>1 CPWLoc=$p(CPWLoc,"-",2)
				//路径名称
				If $IsObject(objPathWay.CPWPathwayDR){
					Set CPWDesc=objPathWay.CPWPathwayDR.CPWDesc
				}
				//Continue:(CPWLoc="")||(CPWDesc="")	//过滤科室和路径
				//是否出径
				Set CPWStatus=objPathWay.CPWStatus
				//是否变异
				Set VarInfo=##Class(web.DHCCPW.MR.ClinPathWaysVariance).GetVarInfo(PathWayID)
				If (VarInfo'=""){
					Set VarCount=$list(VarInfo,1)
				}Else{
					Set VarCount=0
				}
				//计数
				Set Desc=$s(Type="科室":CPWLoc,Type="路径":CPWDesc,1:"Error")
				Set:Desc="" Desc="其它"
				Set:(Status="入径") num=$i(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Count",Desc))
				Set:(CPWStatus="O")&&(Status="出径") num=$i(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Count",Desc))
				Set:(VarCount>0)&&(Status="变异") num=$i(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Count",Desc))
			}
		}
	}
	//	以在院人数为节点排序
	Set xDesc=""
	For {
		Set xDesc=$o(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Count",xDesc))
		Quit:xDesc=""
		
		Set xnum=+$g(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Count",xDesc))
		Set ^TMP(ZIndex,JIndex,"QryCPWInHospNum","Sort",xnum,xDesc)=""	//
	}
	//	输出数据（前十个）
	Set ynum="",index=0
	For {
		Set ynum=$o(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Sort",ynum),-1)
		Quit:ynum=""
		//Quit:index>9	//10+条记录
		
		Set yDesc=""
		For {
			Set yDesc=$o(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Sort",ynum,yDesc))
			Quit:yDesc=""
			Quit:index>9	//10条记录
			Set index=index+1
		
			Set Data=$lb(yDesc,ynum)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP(ZIndex,JIndex,"QryCPWInHospNum")
	Quit $$$OK
}

ClassMethod QryCPWInHospNum1IClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWInHospNum1IExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCPWInHospNum1IFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWInHospNum1IExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	} Else {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:		zhaoyu
/// CreatDate:		2012-12-27
/// Description:	科室在院出径人数
/// Input:			方式：1-科室/2-路径；状态：I-入径/O-出径/V-变异
/// Debug:	w ##Class(%ResultSet).RunQuery("DHCMed.Base.CPWInHospNum","QryCPWInHospNum1O") q
Query QryCPWInHospNum1O() As %Query(ROWSPEC = "Desc:%String,Count:%String") [ SqlProc ]
{
}

ClassMethod QryCPWInHospNum1OExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	/*
	Quit:(argType="")||(argStatus="") $$$OK
	Set Type=$s(argType="1":"科室",argType="2":"路径",1:"Error")
	Set Status=$s(argStatus="I":"入径",argStatus="O":"出径",argStatus="V":"变异",1:"Error")	
	Quit:(Type="Error")||(Status="Error") $$$OK
	*/
	Set Type="科室",Status="出径"
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"QryCPWInHospNum")
	
	Set WardID=0
	For {
		Set WardID=$o(^PAADMi("CurrWard",WardID))  //通过病区、病房查找在院病人人数
		Quit:WardID=""
		Set RoomID=0
		For {
			Set RoomID=$o(^PAADMi("CurrWard",WardID,RoomID))
			Quit:RoomID=""
			Set Paadm=0
			For {
				Set Paadm=$o(^PAADMi("CurrWard",WardID,RoomID,Paadm))
				Quit:Paadm=""
				
				Set AdmInfo=$g(^PAADM(Paadm))
				Continue:$p(AdmInfo,"^",2)'="I"  //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"  //就诊状态过滤
				
				Set (CPWLoc,CPWDesc)=""
				Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
				Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,""),-1)
				Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
				Continue:'$IsObject(objPathWay)		//过滤非入径患者
				//路径科室，路径科室为空，取就诊科室
				Set CPWLocID=objPathWay.CPWInLoc
				Set:CPWLocID="" CPWLocID=$p(AdmInfo,"^",4)
				Set:CPWLocID'="" CPWLoc=$p($g(^CTLOC(CPWLocID)),"^",2)
				Set:$l($p(CPWLoc,"-",2))>1 CPWLoc=$p(CPWLoc,"-",2)
				//路径名称
				If $IsObject(objPathWay.CPWPathwayDR){
					Set CPWDesc=objPathWay.CPWPathwayDR.CPWDesc
				}
				//Continue:(CPWLoc="")||(CPWDesc="")	//过滤科室和路径
				//是否出径
				Set CPWStatus=objPathWay.CPWStatus
				//是否变异
				Set VarInfo=##Class(web.DHCCPW.MR.ClinPathWaysVariance).GetVarInfo(PathWayID)
				If (VarInfo'=""){
					Set VarCount=$list(VarInfo,1)
				}Else{
					Set VarCount=0
				}
				//计数
				Set Desc=$s(Type="科室":CPWLoc,Type="路径":CPWDesc,1:"Error")
				Set:Desc="" Desc="其它"
				Set:(Status="入径") num=$i(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Count",Desc))
				Set:(CPWStatus="O")&&(Status="出径") num=$i(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Count",Desc))
				Set:(VarCount>0)&&(Status="变异") num=$i(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Count",Desc))
			}
		}
	}
	//	以在院人数为节点排序
	Set xDesc=""
	For {
		Set xDesc=$o(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Count",xDesc))
		Quit:xDesc=""
		
		Set xnum=+$g(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Count",xDesc))
		Set ^TMP(ZIndex,JIndex,"QryCPWInHospNum","Sort",xnum,xDesc)=""	//
	}
	//	输出数据（前十个）
	Set ynum="",index=0
	For {
		Set ynum=$o(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Sort",ynum),-1)
		Quit:ynum=""
		//Quit:index>9	//10+条记录
		
		Set yDesc=""
		For {
			Set yDesc=$o(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Sort",ynum,yDesc))
			Quit:yDesc=""
			Quit:index>9	//10条记录
			Set index=index+1
		
			Set Data=$lb(yDesc,ynum)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP(ZIndex,JIndex,"QryCPWInHospNum")
	Quit $$$OK
}

ClassMethod QryCPWInHospNum1OClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWInHospNum1OExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCPWInHospNum1OFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWInHospNum1OExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	} Else {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:		zhaoyu
/// CreatDate:		2012-12-27
/// Description:	科室在院变异人数
/// Input:			方式：1-科室/2-路径；状态：I-入径/O-出径/V-变异
/// Debug:	w ##Class(%ResultSet).RunQuery("DHCMed.Base.CPWInHospNum","QryCPWInHospNum1V") q
Query QryCPWInHospNum1V() As %Query(ROWSPEC = "Desc:%String,Count:%String") [ SqlProc ]
{
}

ClassMethod QryCPWInHospNum1VExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	/*
	Quit:(argType="")||(argStatus="") $$$OK
	Set Type=$s(argType="1":"科室",argType="2":"路径",1:"Error")
	Set Status=$s(argStatus="I":"入径",argStatus="O":"出径",argStatus="V":"变异",1:"Error")	
	Quit:(Type="Error")||(Status="Error") $$$OK
	*/
	Set Type="科室",Status="变异"
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"QryCPWInHospNum")
	
	Set WardID=0
	For {
		Set WardID=$o(^PAADMi("CurrWard",WardID))  //通过病区、病房查找在院病人人数
		Quit:WardID=""
		Set RoomID=0
		For {
			Set RoomID=$o(^PAADMi("CurrWard",WardID,RoomID))
			Quit:RoomID=""
			Set Paadm=0
			For {
				Set Paadm=$o(^PAADMi("CurrWard",WardID,RoomID,Paadm))
				Quit:Paadm=""
				
				Set AdmInfo=$g(^PAADM(Paadm))
				Continue:$p(AdmInfo,"^",2)'="I"  //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"  //就诊状态过滤
				
				Set (CPWLoc,CPWDesc)=""
				Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
				Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,""),-1)
				Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
				Continue:'$IsObject(objPathWay)		//过滤非入径患者
				//路径科室，路径科室为空，取就诊科室
				Set CPWLocID=objPathWay.CPWInLoc
				Set:CPWLocID="" CPWLocID=$p(AdmInfo,"^",4)
				Set:CPWLocID'="" CPWLoc=$p($g(^CTLOC(CPWLocID)),"^",2)
				Set:$l($p(CPWLoc,"-",2))>1 CPWLoc=$p(CPWLoc,"-",2)
				//路径名称
				If $IsObject(objPathWay.CPWPathwayDR){
					Set CPWDesc=objPathWay.CPWPathwayDR.CPWDesc
				}
				//Continue:(CPWLoc="")||(CPWDesc="")	//过滤科室和路径
				//是否出径
				Set CPWStatus=objPathWay.CPWStatus
				//是否变异
				Set VarInfo=##Class(web.DHCCPW.MR.ClinPathWaysVariance).GetVarInfo(PathWayID)
				If (VarInfo'=""){
					Set VarCount=$list(VarInfo,1)
				}Else{
					Set VarCount=0
				}
				//计数
				Set Desc=$s(Type="科室":CPWLoc,Type="路径":CPWDesc,1:"Error")
				Set:Desc="" Desc="其它"
				Set:(Status="入径") num=$i(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Count",Desc))
				Set:(CPWStatus="O")&&(Status="出径") num=$i(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Count",Desc))
				Set:(VarCount>0)&&(Status="变异") num=$i(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Count",Desc))
			}
		}
	}
	//	以在院人数为节点排序
	Set xDesc=""
	For {
		Set xDesc=$o(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Count",xDesc))
		Quit:xDesc=""
		
		Set xnum=+$g(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Count",xDesc))
		Set ^TMP(ZIndex,JIndex,"QryCPWInHospNum","Sort",xnum,xDesc)=""	//
	}
	//	输出数据（前十个）
	Set ynum="",index=0
	For {
		Set ynum=$o(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Sort",ynum),-1)
		Quit:ynum=""
		//Quit:index>9	//10+条记录
		
		Set yDesc=""
		For {
			Set yDesc=$o(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Sort",ynum,yDesc))
			Quit:yDesc=""
			Quit:index>9	//10条记录
			Set index=index+1
		
			Set Data=$lb(yDesc,ynum)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP(ZIndex,JIndex,"QryCPWInHospNum")
	Quit $$$OK
}

ClassMethod QryCPWInHospNum1VClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWInHospNum1VExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCPWInHospNum1VFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWInHospNum1VExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	} Else {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:		zhaoyu
/// CreatDate:		2012-12-27
/// Description:	路径在院入径人数
/// Input:			方式：1-科室/2-路径；状态：I-入径/O-出径/V-变异
/// Debug:	w ##Class(%ResultSet).RunQuery("DHCMed.Base.CPWInHospNum","QryCPWInHospNum2I") q
Query QryCPWInHospNum2I() As %Query(ROWSPEC = "Desc:%String,Count:%String") [ SqlProc ]
{
}

ClassMethod QryCPWInHospNum2IExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	/*
	Quit:(argType="")||(argStatus="") $$$OK
	Set Type=$s(argType="1":"科室",argType="2":"路径",1:"Error")
	Set Status=$s(argStatus="I":"入径",argStatus="O":"出径",argStatus="V":"变异",1:"Error")	
	Quit:(Type="Error")||(Status="Error") $$$OK
	*/
	Set Type="路径",Status="入径"
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"QryCPWInHospNum")
	
	Set WardID=0
	For {
		Set WardID=$o(^PAADMi("CurrWard",WardID))  //通过病区、病房查找在院病人人数
		Quit:WardID=""
		Set RoomID=0
		For {
			Set RoomID=$o(^PAADMi("CurrWard",WardID,RoomID))
			Quit:RoomID=""
			Set Paadm=0
			For {
				Set Paadm=$o(^PAADMi("CurrWard",WardID,RoomID,Paadm))
				Quit:Paadm=""
				
				Set AdmInfo=$g(^PAADM(Paadm))
				Continue:$p(AdmInfo,"^",2)'="I"  //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"  //就诊状态过滤
				
				Set (CPWLoc,CPWDesc)=""
				Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
				Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,""),-1)
				Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
				Continue:'$IsObject(objPathWay)		//过滤非入径患者
				//路径科室，路径科室为空，取就诊科室
				Set CPWLocID=objPathWay.CPWInLoc
				Set:CPWLocID="" CPWLocID=$p(AdmInfo,"^",4)
				Set:CPWLocID'="" CPWLoc=$p($g(^CTLOC(CPWLocID)),"^",2)
				Set:$l($p(CPWLoc,"-",2))>1 CPWLoc=$p(CPWLoc,"-",2)
				//路径名称
				If $IsObject(objPathWay.CPWPathwayDR){
					Set CPWDesc=objPathWay.CPWPathwayDR.CPWDesc
				}
				//Continue:(CPWLoc="")||(CPWDesc="")	//过滤科室和路径
				//是否出径
				Set CPWStatus=objPathWay.CPWStatus
				//是否变异
				Set VarInfo=##Class(web.DHCCPW.MR.ClinPathWaysVariance).GetVarInfo(PathWayID)
				If (VarInfo'=""){
					Set VarCount=$list(VarInfo,1)
				}Else{
					Set VarCount=0
				}
				//计数
				Set Desc=$s(Type="科室":CPWLoc,Type="路径":CPWDesc,1:"Error")
				Set:Desc="" Desc="其它"
				Set:(Status="入径") num=$i(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Count",Desc))
				Set:(CPWStatus="O")&&(Status="出径") num=$i(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Count",Desc))
				Set:(VarCount>0)&&(Status="变异") num=$i(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Count",Desc))
			}
		}
	}
	//	以在院人数为节点排序
	Set xDesc=""
	For {
		Set xDesc=$o(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Count",xDesc))
		Quit:xDesc=""
		
		Set xnum=+$g(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Count",xDesc))
		Set ^TMP(ZIndex,JIndex,"QryCPWInHospNum","Sort",xnum,xDesc)=""	//
	}
	//	输出数据（前十个）
	Set ynum="",index=0
	For {
		Set ynum=$o(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Sort",ynum),-1)
		Quit:ynum=""
		//Quit:index>9	//10+条记录
		
		Set yDesc=""
		For {
			Set yDesc=$o(^TMP(ZIndex,JIndex,"QryCPWInHospNum","Sort",ynum,yDesc))
			Quit:yDesc=""
			Quit:index>9	//10条记录
			Set index=index+1
		
			Set Data=$lb(yDesc,ynum)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP(ZIndex,JIndex,"QryCPWInHospNum")
	Quit $$$OK
}

ClassMethod QryCPWInHospNum2IClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWInHospNum2IExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCPWInHospNum2IFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWInHospNum2IExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	} Else {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
