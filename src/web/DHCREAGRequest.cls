Class web.DHCREAGRequest Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 67;

/// Creator：      huhm
/// CreatDate：    20100810
/// Description:： 复制请领单
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others
ClassMethod CopyRequest(RequestId As %String, user As %String) As %String
{
	s NewReqNo=##Class(web.DHCREAGSysPara).GetEpisode("5")
	i '$l(NewReqNo) q "-1^"
	s DepartT=$li(^lab.DHCREAGRequestD(RequestId),6)
	s DepartF=$li(^lab.DHCREAGRequestD(RequestId),7)
	s remark=$li(^lab.DHCREAGRequestD(RequestId),13)
	s date=+$h,time=$p($h,",",2)
	SET $ZTRAP="ErrorHandle",$ECODE=""   //捕获错误开始
	TSTART
	&sql(insert into lab.DHCREAGRequest(RequestNo,CreateDate,CreateTime,CreateUserDR,ToDepartmentDR,DepartmentDR,Status,Printed,Remarks)
	values(:NewReqNo,:date,:time,:user,:DepartT,:DepartF,'N','N',:remark))
	if SQLCODE Quit $$Rollback("表lab.DHCREAGRequest插入失败。代码："_SQLCODE)
	//w %RowId
	s id=$o(^lab.DHCREAGRequestI("MasterIndex"," "_NewReqNo,""))
	i '$l(id) Quit $$Rollback("无主索引")
	s subid="" f  s subid=$o(^lab.DHCREAGRequestD(RequestId,"Items",subid)) q:(subid="")!(SQLCODE)  d
	.s str=$g(^lab.DHCREAGRequestD(RequestId,"Items",subid))
	.s reag=$li(str,2)
	.s quan=$li(str,3)
	.&sql(insert into lab.DHCREAGRequestItems(ParRef,ReagentDR,ReqstQty,TransQty,Status) values(:id,:reag,:quan,:quan,'N'))
	i SQLCODE Quit $$Rollback("试剂复制失败。代码："_SQLCODE)
	TCOMMIT
	q "0"_$c(2)_NewReqNo_$c(2)_id
Rollback(para)
  s para=$g(para)
  TROLLBACK
  s ^TMP($zn,"error")=para
  q "1"_$c(2)_para
  //错误处理
ErrorHandle
  s RetMsg="错误信息:"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
  q $$Rollback(RetMsg)
}

/// Creator：      huhm
/// CreatDate：    20100817
/// Description:： 取消打印状态
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
ClassMethod CancelPrint(RequestId As %String, user As %String) As %String
{
	n (RequestId)
	s RequestId=$g(RequestId)
	s ^TMP($zn,"CancelPrint","para")=RequestId
	s status=$li(^lab.DHCREAGRequestD(RequestId),8)
	i status="Y" q "已领用"
	s Printed=$li(^lab.DHCREAGRequestD(RequestId),12)
	//i Printed'="Y" q "已取消打印"
	&sql(update lab.DHCREAGRequest set Printed='N',PrintDate=null,PrintTime=null where ID=:RequestId)
	q SQLCODE
}

/// Creator：      huhm
/// CreatDate：    20100805
/// Description:： 保存打印信息
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
ClassMethod SavePrinted(RequestId As %String, user As %String) As %String
{
	n (RequestId,user)
	s RequestId=$g(RequestId),user=$g(user)
	s PrnDate=+$h,PrnTime=$p($h,",",2)
	i '$l(RequestId) q 100
	&sql(update lab.DHCREAGRequest set PrintUserDR=:user,Printed='Y',PrintDate=:PrnDate,PrintTime=:PrnTime where ID=:RequestId)
	q SQLCODE
}

ClassMethod QryUnChkRequestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUnChkRequestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryUnChkRequestExecute(ByRef qHandle As %Binary, Depart As %String, PrnStus As %String) As %Status
{
	s Depart=$g(Depart),PrnStus=$g(PrnStus)
	i '$l(PrnStus) s PrnStus="N"
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCREAGRequestI("StatusIndex"," N","D02",1)=
	//s id="" f  s id=$o(^lab.DHCREAGRequestI("StatusIndex"," N",Depart,id)) q:id=""  d
	s id="" f  s id=$o(^lab.DHCREAGRequestI("PrintedIndex"," "_PrnStus,id)) q:id=""  d
	.s str=$g(^lab.DHCREAGRequestD(id))
	.s ReqNo=$li(str,2)
	.s CrtDate=$li(str,3)
	.s CrtTime=$li(str,4)
	.s CrtUser=$li(str,5)
	.s ToDepDr=$li(str,6)
	.s FromDepDr=$li(str,7)
	.s stus=$li(str,8)  //领用状态
	.i stus="Y" q
	.i FromDepDr'=Depart q
	.s Remark="abc" //$li(str,13)
	.s CrtDT=$zd(CrtDate,3)_" "_$zt(CrtTime,1)
	.///
	.s FromDepName=""
	.i $l(FromDepDr),$d(^lab.DHCCTDepartmentD(FromDepDr)) s FromDepName=$li(^lab.DHCCTDepartmentD(FromDepDr),3)
	.s ToDepName=""
	.i $l(ToDepDr),$d(^lab.DHCCTDepartmentD(ToDepDr)) s ToDepName=$li(^lab.DHCCTDepartmentD(ToDepDr),3)
	.s CrtUserName=""
	.i $l(CrtUser),$d(^lab.DHCCTUserD(CrtUser)) s CrtUserName=$li(^lab.DHCCTUserD(CrtUser),3)
	.d OutputRow			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(id,ReqNo,ToDepName,FromDepName,CrtDT,CrtUserName,Remark,ToDepDr,FromDepDr,CrtUser)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryUnChkRequestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUnChkRequestExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

/// Creator：      huhm
/// CreatDate：    20100729
/// Description:： 未完成的请领单查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryUnChkRequest(Depart As %String, PrnStus As %String) As %Query(ROWSPEC = "RequestID:%String,RequestNo:%String,ToDepart:%String,FromDepart:%String,CreateDT:%String,CreateUser:%String,Remark:%String,ToDepartDr:%String,FromDepartDr:%String,CrtUserDr:%String")
{
}

ClassMethod QryPrintRequestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPrintRequestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPrintRequestExecute(ByRef qHandle As %Binary, Depart As %String, DateFrom As %String, DateTo As %String, ToDepart As %String, type As %String) As %Status
{
	s Depart=$g(Depart),DateFrom=$g(DateFrom),DateTo=$g(DateTo),ToDepart=$g(ToDepart)
	s DateFrom=$zdh(DateFrom,3),DateTo=$zdh(DateTo,3),type=$g(type)
	s ^TMP($zn,"Print","para")=Depart_","_DateFrom_","_DateTo_","_ToDepart_","_type
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCREAGRequestI("PrintDateIndex","D01",61943,25)=
	s dt=(DateFrom-1) f  s dt=$o(^lab.DHCREAGRequestI("PrintDateIndex",Depart,dt)) q:(dt>DateTo)!(dt="")  d
	.s id="" f  s id=$o(^lab.DHCREAGRequestI("PrintDateIndex",Depart,dt,id)) q:id=""  d
	..//
	..s str=$g(^lab.DHCREAGRequestD(id))
	..s ReqNo=$li(str,2)
	..s CrtDate=$li(str,3)
	..s CrtTime=$li(str,4)
	..s CrtUser=$li(str,5)
	..s ToDepDr=$li(str,6)
	..i $l(ToDepart),ToDepart'=ToDepDr q
	..//s FromDepDr=$li(str,7)
	..//i FromDepDr'=Depart q
	..s stus=$li(str,8)  //领用状态
	..i type="1",stus'="N" q
	..i type="2",stus'="Y" q
	..s PrnTime=$li(str,10)
	..s PrnUser=$li(str,11)
	..s Remark=$li(str,13)
	..s CrtDT=$zd(CrtDate,3)_" "_$zt(CrtTime,2)
	..s PrnDT=$zd(dt,3)_" "_$zt(PrnTime,2)
	..///
	..//s FromDepName=""
	..//i $l(FromDepDr),$d(^lab.DHCCTDepartmentD(FromDepDr)) s FromDepName=$li(^lab.DHCCTDepartmentD(FromDepDr),3)
	..s ToDepName=""
	..i $l(ToDepDr),$d(^lab.DHCCTDepartmentD(ToDepDr)) s ToDepName=$li(^lab.DHCCTDepartmentD(ToDepDr),3)
	..s CrtUserName=""
	..i $l(CrtUser),$d(^lab.DHCCTUserD(CrtUser)) s CrtUserName=$li(^lab.DHCCTUserD(CrtUser),3)
	..s PrnUserName=""
	..i $l(PrnUser),$d(^lab.DHCCTUserD(PrnUser)) s PrnUserName=$li(^lab.DHCCTUserD(PrnUser),3)
	..s status="未领用"
	..i stus="Y" s status="领用"
	..d OutputPrint			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPrint
	set Data=$lb(id,ReqNo,ToDepName,PrnDT,PrnUserName,CrtDT,CrtUserName,status,Remark,ToDepDr,CrtUser,PrnUser)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryPrintRequestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPrintRequestExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

/// Creator：      huhm
/// CreatDate：    20100809
/// Description:： 查询已打印的请领单
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryPrintRequest(Depart As %String, DateFrom As %String, DateTo As %String, ToDepart As %String, type As %String) As %Query(ROWSPEC = "RequestID:%String,RequestNo:%String,ToDepart:%String,PrintDT:%String,PrintUser:%String,CreateDT:%String,CreateUser:%String,Status:%String,Remark:%String,ToDepartDr:%String,CrtUserDr:%String,PrnUserDr:%String")
{
}

ClassMethod QryPrtReqstByIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPrtReqstByIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPrtReqstByIdExecute(ByRef qHandle As %Binary, Depart As %String, RequestNo As %String) As %Status
{
	s Depart=$g(Depart),RequestNo=$g(RequestNo)
	s ^TMP($zn,"Print","id")=Depart_","_RequestNo
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	i '$l(RequestNo)  q $$$OK
	//^lab.DHCREAGRequestI("MasterIndex"," QL2010080013",23)=
	s ReqNo=$c(32)_$zcvt(RequestNo,"U")
	s id="" f  s id=$o(^lab.DHCREAGRequestI("MasterIndex",ReqNo,id)) q:id=""  d
	.s str=$g(^lab.DHCREAGRequestD(id))
	.s ReqNo=$li(str,2)
	.s CrtDate=$li(str,3)
	.s CrtTime=$li(str,4)
	.s CrtUser=$li(str,5)
	.s ToDepDr=$li(str,6)
	.//i $l(ToDepart),ToDepart'=ToDepDr q
	.s FromDepDr=$li(str,7)
	.i FromDepDr'=Depart q
	.s stus=$li(str,8)  //领用状态
	.s PrnTime=$li(str,10)
	.s PrnUser=$li(str,11)
	.s PrnStus=$li(str,12)
	.i PrnStus'="Y" q
	.s Remark=$li(str,13)
	.s CrtDT=$zd(CrtDate,3)_" "_$zt(CrtTime,2)
	.s PrnDT=$zd(dt,3)_" "_$zt(PrnTime,2)
	.///
	.//s FromDepName=""
	.//i $l(FromDepDr),$d(^lab.DHCCTDepartmentD(FromDepDr)) s FromDepName=$li(^lab.DHCCTDepartmentD(FromDepDr),3)
	.s ToDepName=""
	.i $l(ToDepDr),$d(^lab.DHCCTDepartmentD(ToDepDr)) s ToDepName=$li(^lab.DHCCTDepartmentD(ToDepDr),3)
	.s CrtUserName=""
	.i $l(CrtUser),$d(^lab.DHCCTUserD(CrtUser)) s CrtUserName=$li(^lab.DHCCTUserD(CrtUser),3)
	.s PrnUserName=""
	.i $l(PrnUser),$d(^lab.DHCCTUserD(PrnUser)) s PrnUserName=$li(^lab.DHCCTUserD(PrnUser),3)
	.s status="未领用"
	.i stus="Y" s status="领用"
	.d OutputId			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputId
	set Data=$lb(id,ReqNo,ToDepName,PrnDT,PrnUserName,CrtDT,CrtUserName,status,Remark,ToDepDr,CrtUser,PrnUser)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryPrtReqstByIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPrtReqstByIdExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

/// Creator：      huhm
/// CreatDate：    20100810
/// Description:： 根据请领单号查询请领单
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryPrtReqstById(Depart As %String, RequestNo As %String) As %Query(ROWSPEC = "RequestID:%String,RequestNo:%String,ToDepart:%String,PrintDT:%String,PrintUser:%String,CreateDT:%String,CreateUser:%String,Status:%String,Remark:%String,ToDepartDr:%String,CrtUserDr:%String,PrnUserDr:%String")
{
}

}
