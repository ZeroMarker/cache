Import SQLUser

Class web.DHCANArrange Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCANArrange).UpdateANArr("4","534^536^539^502^509","","","","","","2183","","1224","","","11/03/2010")
ClassMethod UpdateANArr(roomId As %Library.String = "", opId As %Library.String = "", ctcpAnDoc As %Library.String = "", ctcpAnDocO As %Library.String = "", ctcpAnDocJ As %Library.String = "", ansupervisid As %Library.String = "", ctcpAnNur As %Library.String = "", ctcpDevNur As %Library.String = "", ctcpDevNurJ As %Library.String = "", ctcpTourNur As %Library.String = "", ctcpTourNurJ As %Library.String = "", anDocNote As %String = "", opdate As %String = "", delete As %String = "") As %String
{
	//s ^Tmpck("UpdateANArr",$h)=roomId_"*"_opId_"*"_ctcpAnDoc_"*"_ctcpAnDocO_"*"_ctcpAnDocJ_"*"_ansupervisid_"*"_ctcpAnNur_"*"_ctcpDevNur_"*"_ctcpDevNurJ_"*"_ctcpTourNur_"*"_ctcpTourNurJ_"*"_anDocNote_"*"_opdate_"*"_delete
	q:roomId="" "手术间ID为空!"
	s $zt="ERRORUpdateANArr"
	i opdate'="" s nowDate=$ZDH(opdate,4) //ck  090929
	e  s nowDate=+$H
	s nowTime=$P($H,",",2)
	s upDate=+$H  //ck 091013 更新时间
	s userId=%session.Data("LOGON.USERID")
	;s userId="3819"
	s retStr=""
	s SQLCODE=-1
	b //1
	TSTART
	;i anDocNote'="" s ^TempAnDocNote("Date",nowDate)=anDocNote
	/*
	i roomId'="" d
	.s ctcpDr=""
	.s ctcpDr=$O(^DHCANArr(0,"DateRoom",nowDate,roomId,ctcpDr)) 
	.q:ctcpDr=""
	.s arrRowId=""
	.f  s arrRowId=$o(^DHCANArr(0,"AnArrDate",nowDate,arrRowId)) q:arrRowId=""  d
	..s arrOpDr=$p(^DHCANArr(arrRowId),"^",4)
	..f opNum=1:1:$l(opId,"^")  d
	...s opDr=$p(opId,"^",opNum)
	...q:opDr'=arrOpDr
	...s arrNurDoc=$P($G(^DHCANArr(anArrRowId)),"^",6)
	...s docCat=$P($G(^DHCANArr(anArrRowId)),"^",7)
	...s nurCat=$P($G(^DHCANArr(anArrRowId)),"^",8)
	...i (ctcpDevNur'="")!(ctcpDevNur'="0") d
	....q:(arrNurDoc'="N")&(nurCat'="D")
	...i (ctcpAnDoc'="")!(ctcpAnDoc'="0") d
	....;q:(arrNurDoc'="D")&(docCat'="A")
	....&SQL(delete from DHC_AN_Arrange  where AN_Arr_RowId=:anArrRowId)
	....;&SQL(delete from DHC_AN_Arrange  where AN_Arr_Room_DR=:roomId and AN_Arr_Date=:nowDate and AN_Arr_Op_DR=:opDr)
	....i SQLCODE'=0 s retStr="删除排班失败!"
	....i SQLCODE'=0 TROLLBACK
	q:retStr'="" retStr
	*/
	i (delete="DA")!((delete="D")&(ctcpAnDoc'="")) d
	.f opNum=1:1:$l(opId,"^") d
	..s opDr=$p(opId,"^",opNum)
	..s anArrRowId="" f  s anArrRowId=$O(^DHCANArr(0,"AnArrDate",nowDate,anArrRowId)) q:anArrRowId=""  d
	...s arrOpDr=$P($G(^DHCANArr(anArrRowId)),"^",4)
	...q:arrOpDr'=opDr
	...s arrNurDoc=$P($G(^DHCANArr(anArrRowId)),"^",6)
	...q:arrNurDoc'="D"
	...s docCat=$P($G(^DHCANArr(anArrRowId)),"^",7)
	...q:docCat'="A"
	...&SQL(delete from DHC_AN_Arrange  where AN_Arr_RowId=:anArrRowId)
	...i SQLCODE'=0 s retStr="更新麻醉医师失败!"
	...i SQLCODE'=0 TROLLBACK
	;q:retStr'="" retStr

	i ctcpAnDoc'="" d
	.s ctcpDr=ctcpAnDoc
	.s arrNurDoc="D"
	.s docCat="A"
	.s nurCat=""
	.s ctcpNum=1
	.f opNum=1:1:$l(opId,"^") d
	..s opDr=$p(opId,"^",opNum)
	..&SQL(insert into DHC_AN_Arrange (AN_Arr_Date,AN_Arr_Time,AN_Arr_Room_DR,AN_Arr_Op_DR,AN_Arr_Ctcp_DR,AN_Arr_NurDoc,AN_Arr_DocCat,AN_Arr_NurCat,AN_Arr_CtcpNum,AN_Arr_UpdateDate,AN_Arr_UpdateTime,AN_Arr_UpdateUserId,AN_Arr_Note) values (:nowDate,:nowTime,:roomId,:opDr,:ctcpDr,:arrNurDoc,:docCat,:nurCat,:ctcpNum,:upDate,:nowTime,:userId,:anDocNote))
	..i SQLCODE'=0 s retStr="麻醉医师插入失败!"
	..i SQLCODE'=0 TROLLBACK
	e  d
	.q:delete'="D"
	.f opNum=1:1:$l(opId,"^") d
	..s opDr=$p(opId,"^",opNum)
	..s anArrRowId="" f  s anArrRowId=$O(^DHCANArr(0,"AnArrDate",nowDate,anArrRowId)) q:anArrRowId=""  d
	...s arrOpDr=$P($G(^DHCANArr(anArrRowId)),"^",4)
	...q:arrOpDr'=opDr
	...s arrNurDoc=$P($G(^DHCANArr(anArrRowId)),"^",6)
	...q:arrNurDoc'="D"
	...s docCat=$P($G(^DHCANArr(anArrRowId)),"^",7)
	...q:docCat'="A"
	...;&SQL(update DHC_AN_Arrange set AN_Arr_EditFlag='D'  where AN_Arr_RowId=:anArrRowId)
	...&SQL(delete from DHC_AN_Arrange  where AN_Arr_RowId=:anArrRowId)
	...i SQLCODE'=0 s retStr="更新麻醉医师失败!"
	...i SQLCODE'=0 TROLLBACK
	;q:retStr'="" retStr

	i (delete="DO")!((delete="D")&(ctcpAnDocO'="")) d
	.f opNum=1:1:$l(opId,"^") d
	..s opDr=$p(opId,"^",opNum)
	..s anArrRowId="" f  s anArrRowId=$O(^DHCANArr(0,"AnArrDate",nowDate,anArrRowId)) q:anArrRowId=""  d
	...s arrOpDr=$P($G(^DHCANArr(anArrRowId)),"^",4)
	...q:arrOpDr'=opDr
	...s arrNurDoc=$P($G(^DHCANArr(anArrRowId)),"^",6)
	...q:arrNurDoc'="D"
	...s docCat=$P($G(^DHCANArr(anArrRowId)),"^",7)
	...q:docCat'="O"
	...&SQL(delete from DHC_AN_Arrange  where AN_Arr_RowId=:anArrRowId)
	...i SQLCODE'=0 s retStr="更新麻醉助手失败!"
	...i SQLCODE'=0 TROLLBACK
	;q:retStr'="" retStr

	i ctcpAnDocO'="" d
	.s num=$L(ctcpAnDocO,"^")
	.f i=1:1:num d
	..s ctcpDr=$P(ctcpAnDocO,"^",i)
	..s arrNurDoc="D"
	..s docCat="O"
	..s nurCat=""
	..s ctcpNum=i
	..f opNum=1:1:$l(opId,"^") d
	...s opDr=$p(opId,"^",opNum)
	...&SQL(insert into DHC_AN_Arrange (AN_Arr_Date,AN_Arr_Time,AN_Arr_Room_DR,AN_Arr_Op_DR,AN_Arr_Ctcp_DR,AN_Arr_NurDoc,AN_Arr_DocCat,AN_Arr_NurCat,AN_Arr_CtcpNum,AN_Arr_UpdateDate,AN_Arr_UpdateTime,AN_Arr_UpdateUserId) values (:nowDate,:nowTime,:roomId,:opDr,:ctcpDr,:arrNurDoc,:docCat,:nurCat,:ctcpNum,:upDate,:nowTime,:userId))
	...i SQLCODE'=0 s retStr="麻醉助手插入失败!"
	...i SQLCODE'=0 TROLLBACK
	e  d
	.q:delete'="D"
	.f opNum=1:1:$l(opId,"^") d
	..s opDr=$p(opId,"^",opNum)
	..s anArrRowId="" f  s anArrRowId=$O(^DHCANArr(0,"AnArrDate",nowDate,anArrRowId)) q:anArrRowId=""  d
	...s arrOpDr=$P($G(^DHCANArr(anArrRowId)),"^",4)
	...q:arrOpDr'=opDr
	...s arrNurDoc=$P($G(^DHCANArr(anArrRowId)),"^",6)
	...q:arrNurDoc'="D"
	...s docCat=$P($G(^DHCANArr(anArrRowId)),"^",7)
	...q:docCat'="O"
	...&SQL(delete from DHC_AN_Arrange  where AN_Arr_RowId=:anArrRowId)
	...i SQLCODE'=0 s retStr="更新麻醉助手失败!"
	...i SQLCODE'=0 TROLLBACK
	;q:retStr'="" retStr

	i ctcpAnDocJ'="" d
	.s num=$L(ctcpAnDocJ,"^")
	.f i=1:1:num d
	..s ctcpDr=$P(ctcpAnDocJ,"^",i)
	..s arrNurDoc="D"
	..s docCat="J"
	..s nurCat=""
	..s ctcpNum=i
	..f opNum=1:1:$l(opId,"^") d
	...s opDr=$p(opId,"^",opNum)
	...&SQL(insert into DHC_AN_Arrange (AN_Arr_Date,AN_Arr_Time,AN_Arr_Room_DR,AN_Arr_Op_DR,AN_Arr_Ctcp_DR,AN_Arr_NurDoc,AN_Arr_DocCat,AN_Arr_NurCat,AN_Arr_CtcpNum,AN_Arr_UpdateDate,AN_Arr_UpdateTime,AN_Arr_UpdateUserId) values (:nowDate,:nowTime,:roomId,:opDr,:ctcpDr,:arrNurDoc,:docCat,:nurCat,:ctcpNum,:upDate,:nowTime,:userId))
	...i SQLCODE'=0 s retStr="其他麻醉师插入失败!"
	...i SQLCODE'=0 TROLLBACK
	;q:retStr'="" retStr

	i (delete="DS")!((delete="D")&(ansupervisid'="")) d
	.f opNum=1:1:$l(opId,"^") d
	..s opDr=$p(opId,"^",opNum)
	..s anArrRowId="" f  s anArrRowId=$O(^DHCANArr(0,"AnArrDate",nowDate,anArrRowId)) q:anArrRowId=""  d
	...s arrOpDr=$P($G(^DHCANArr(anArrRowId)),"^",4)
	...q:arrOpDr'=opDr
	...s arrNurDoc=$P($G(^DHCANArr(anArrRowId)),"^",6)
	...q:arrNurDoc'="D"
	...s docCat=$P($G(^DHCANArr(anArrRowId)),"^",7)
	...q:docCat'="S"
	...&SQL(delete from DHC_AN_Arrange  where AN_Arr_RowId=:anArrRowId)
	...i SQLCODE'=0 s retStr="更新麻醉指导失败!"
	...i SQLCODE'=0 TROLLBACK
	;q:retStr'="" retStr

	i ansupervisid'=""  d   //ck091202
	.s ctcpDr=ansupervisid
	.s arrNurDoc="D"
	.s docCat="S"
	.s nurCat=""
	.s ctcpNum=1
	.f opNum=1:1:$l(opId,"^") d
	..s opDr=$p(opId,"^",opNum)
	..&SQL(insert into DHC_AN_Arrange (AN_Arr_Date,AN_Arr_Time,AN_Arr_Room_DR,AN_Arr_Op_DR,AN_Arr_Ctcp_DR,AN_Arr_NurDoc,AN_Arr_DocCat,AN_Arr_NurCat,AN_Arr_CtcpNum,AN_Arr_UpdateDate,AN_Arr_UpdateTime,AN_Arr_UpdateUserId) values (:nowDate,:nowTime,:roomId,:opDr,:ctcpDr,:arrNurDoc,:docCat,:nurCat,:ctcpNum,:upDate,:nowTime,:userId))
	..i SQLCODE'=0 s retStr="麻醉指导插入失败!"
	..i SQLCODE'=0 TROLLBACK
	e  d
	.q:delete'="D"
	.f opNum=1:1:$l(opId,"^") d
	..s opDr=$p(opId,"^",opNum)
	..s anArrRowId="" f  s anArrRowId=$O(^DHCANArr(0,"AnArrDate",nowDate,anArrRowId)) q:anArrRowId=""  d
	...s arrOpDr=$P($G(^DHCANArr(anArrRowId)),"^",4)
	...q:arrOpDr'=opDr
	...s arrNurDoc=$P($G(^DHCANArr(anArrRowId)),"^",6)
	...q:arrNurDoc'="D"
	...s docCat=$P($G(^DHCANArr(anArrRowId)),"^",7)
	...q:docCat'="S"
	...&SQL(delete from DHC_AN_Arrange  where AN_Arr_RowId=:anArrRowId)
	...i SQLCODE'=0 s retStr="更新麻醉指导失败!"
	...i SQLCODE'=0 TROLLBACK
	;q:retStr'="" retStr

	i (delete="NA")!((delete="N")&(ctcpAnNur'="")) d
	.f opNum=1:1:$l(opId,"^") d
	..s opDr=$p(opId,"^",opNum)
	..s anArrRowId="" f  s anArrRowId=$O(^DHCANArr(0,"AnArrDate",nowDate,anArrRowId)) q:anArrRowId=""  d
	...s arrOpDr=$P($G(^DHCANArr(anArrRowId)),"^",4)
	...q:arrOpDr'=opDr
	...s arrNurDoc=$P($G(^DHCANArr(anArrRowId)),"^",6)
	...q:arrNurDoc'="N"
	...s docCat=$P($G(^DHCANArr(anArrRowId)),"^",7)
	...q:docCat'="A"
	...&SQL(delete from DHC_AN_Arrange  where AN_Arr_RowId=:anArrRowId)
	...i SQLCODE'=0 s retStr="更新麻醉护士失败!"
	...i SQLCODE'=0 TROLLBACK
	;q:retStr'="" retStr

	i ctcpAnNur'="" d
	.q:ctcpAnNur="N"
	.s ctcpDr=ctcpAnNur
	.s arrNurDoc="N"
	.s docCat=""
	.s nurCat="A"
	.s ctcpNum=1
	.f opNum=1:1:$l(opId,"^") d
	..s opDr=$p(opId,"^",opNum)
	..&SQL(insert into DHC_AN_Arrange (AN_Arr_Date,AN_Arr_Time,AN_Arr_Room_DR,AN_Arr_Op_DR,AN_Arr_Ctcp_DR,AN_Arr_NurDoc,AN_Arr_DocCat,AN_Arr_NurCat,AN_Arr_CtcpNum,AN_Arr_UpdateDate,AN_Arr_UpdateTime,AN_Arr_UpdateUserId) values (:nowDate,:nowTime,:roomId,:opDr,:ctcpDr,:arrNurDoc,:docCat,:nurCat,:ctcpNum,:upDate,:nowTime,:userId))
	..i SQLCODE'=0 s retStr="麻醉护士插入失败!"
	..i SQLCODE'=0 TROLLBACK
	e  d
	.q:delete'="N"
	.f opNum=1:1:$l(opId,"^") d
	..s opDr=$p(opId,"^",opNum)
	..s anArrRowId="" f  s anArrRowId=$O(^DHCANArr(0,"AnArrDate",nowDate,anArrRowId)) q:anArrRowId=""  d
	...s arrOpDr=$P($G(^DHCANArr(anArrRowId)),"^",4)
	...q:arrOpDr'=opDr
	...s arrNurDoc=$P($G(^DHCANArr(anArrRowId)),"^",6)
	...q:arrNurDoc'="N"
	...s docCat=$P($G(^DHCANArr(anArrRowId)),"^",7)
	...q:docCat'="A"
	...&SQL(delete from DHC_AN_Arrange  where AN_Arr_RowId=:anArrRowId)
	...i SQLCODE'=0 s retStr="更新麻醉护士失败!"
	...i SQLCODE'=0 TROLLBACK
	;q:retStr'="" retStr

	i (delete="ND")!((delete="N")&(ctcpDevNur'="")) d
	.f opNum=1:1:$l(opId,"^") d
	..s opDr=$p(opId,"^",opNum)
	..s anArrRowId="" f  s anArrRowId=$O(^DHCANArr(0,"AnArrDate",nowDate,anArrRowId)) q:anArrRowId=""  d
	...s arrOpDr=$P($G(^DHCANArr(anArrRowId)),"^",4)
	...q:arrOpDr'=opDr
	...s arrNurDoc=$P($G(^DHCANArr(anArrRowId)),"^",6)
	...q:arrNurDoc'="N"
	...s nurCat=$P($G(^DHCANArr(anArrRowId)),"^",8)
	...q:nurCat'="D"
	...&SQL(delete from DHC_AN_Arrange  where AN_Arr_RowId=:anArrRowId)
	...i SQLCODE'=0 s retStr="更新器械护士失败!"
	...i SQLCODE'=0 TROLLBACK
	;q:retStr'="" retStr

	i ctcpDevNur'="" d
	.s num=$L(ctcpDevNur,"^")
	.f i=1:1:num d
	..s ctcpDr=$P(ctcpDevNur,"^",i)
	..s arrNurDoc="N"
	..s docCat=""
	..s nurCat="D"
	..s ctcpNum=i
	..f opNum=1:1:$l(opId,"^") d
	...s opDr=$p(opId,"^",opNum)
	...&SQL(insert into DHC_AN_Arrange (AN_Arr_Date,AN_Arr_Time,AN_Arr_Room_DR,AN_Arr_Op_DR,AN_Arr_Ctcp_DR,AN_Arr_NurDoc,AN_Arr_DocCat,AN_Arr_NurCat,AN_Arr_CtcpNum,AN_Arr_UpdateDate,AN_Arr_UpdateTime,AN_Arr_UpdateUserId) values (:nowDate,:nowTime,:roomId,:opDr,:ctcpDr,:arrNurDoc,:docCat,:nurCat,:ctcpNum,:upDate,:nowTime,:userId))
	...i SQLCODE'=0 s retStr="器械护士插入失败!"
	...i SQLCODE'=0 TROLLBACK
	e  d
	.q:delete'="N"
	.f opNum=1:1:$l(opId,"^") d
	..s opDr=$p(opId,"^",opNum)
	..s anArrRowId="" f  s anArrRowId=$O(^DHCANArr(0,"AnArrDate",nowDate,anArrRowId)) q:anArrRowId=""  d
	...s arrOpDr=$P($G(^DHCANArr(anArrRowId)),"^",4)
	...q:arrOpDr'=opDr
	...s arrNurDoc=$P($G(^DHCANArr(anArrRowId)),"^",6)
	...q:arrNurDoc'="N"
	...s nurCat=$P($G(^DHCANArr(anArrRowId)),"^",8)
	...q:nurCat'="D"
	...&SQL(delete from DHC_AN_Arrange  where AN_Arr_RowId=:anArrRowId)
	...i SQLCODE'=0 s retStr="更新器械护士失败!"
	...i SQLCODE'=0 TROLLBACK
	;q:retStr'="" retStr

	i ctcpDevNurJ'="" d
	.s num=$L(ctcpDevNurJ,"^")
	.f i=1:1:num d
	..s ctcpDr=$P(ctcpDevNurJ,"^",i)
	..s arrNurDoc="N"
	..s docCat=""
	..s nurCat="J"
	..s ctcpNum=i
	..f opNum=1:1:$l(opId,"^") d
	...s opDr=$p(opId,"^",opNum)
	...&SQL(insert into DHC_AN_Arrange (AN_Arr_Date,AN_Arr_Time,AN_Arr_Room_DR,AN_Arr_Op_DR,AN_Arr_Ctcp_DR,AN_Arr_NurDoc,AN_Arr_DocCat,AN_Arr_NurCat,AN_Arr_CtcpNum,AN_Arr_UpdateDate,AN_Arr_UpdateTime,AN_Arr_UpdateUserId) values (:nowDate,:nowTime,:roomId,:opDr,:ctcpDr,:arrNurDoc,:docCat,:nurCat,:ctcpNum,:upDate,:nowTime,:userId))
	...i SQLCODE'=0 s retStr="交器械护士插入失败!"
	...i SQLCODE'=0 TROLLBACK
	;q:retStr'="" retStr

	b //13
	i (delete="NT")!((delete="N")&(ctcpTourNur'="")) d
	.f opNum=1:1:$l(opId,"^") d
	..s opDr=$p(opId,"^",opNum)
	..s anArrRowId="" f  s anArrRowId=$O(^DHCANArr(0,"AnArrDate",nowDate,anArrRowId)) q:anArrRowId=""  d
	...s arrOpDr=$P($G(^DHCANArr(anArrRowId)),"^",4)
	...q:arrOpDr'=opDr
	...s arrNurDoc=$P($G(^DHCANArr(anArrRowId)),"^",6)
	...q:arrNurDoc'="N"
	...s nurCat=$P($G(^DHCANArr(anArrRowId)),"^",8)
	...q:nurCat'="T"
	...b  //13.1
	...s arrCtcpDr=$P($G(^DHCANArr(anArrRowId)),"^",5)
	...&SQL(delete from DHC_AN_Arrange  where AN_Arr_RowId=:anArrRowId)
	...;i $d(^DHCANArr(anArrRowId))>0 k ^DHCANArr(anArrRowId)
	...;i $d(^DHCANArr(0,"AnArrDate",nowDate,anArrRowId))>0 k ^DHCANArr(0,"AnArrDate",nowDate,anArrRowId)
	...;i $d(^DHCANArr(0,"DateCtcp",nowDate,arrCtcpDr,roomId,anArrRowId))>0 k ^DHCANArr(0,"DateCtcp",nowDate,arrCtcpDr,roomId,anArrRowId)
	...;i $d(^DHCANArr(0,"DateRoom",nowDate,roomId,arrCtcpDr,anArrRowId))>0 k ^DHCANArr(0,"DateRoom",nowDate,roomId,arrCtcpDr,anArrRowId)
	...i SQLCODE'=0 s retStr="删除巡回护士失败!"
	...i SQLCODE'=0 TROLLBACK
	;q:retStr'="" retStr

	i ctcpTourNur'="" d
	.s num=$L(ctcpTourNur,"^")
	.f i=1:1:num d
	..s ctcpDr=$P(ctcpTourNur,"^",i)
	..s arrNurDoc="N"
	..s docCat=""
	..s nurCat="T"
	..s ctcpNum=i
	..f opNum=1:1:$l(opId,"^") d
	...s opDr=$p(opId,"^",opNum)
	...&SQL(insert into DHC_AN_Arrange (AN_Arr_Date,AN_Arr_Time,AN_Arr_Room_DR,AN_Arr_Op_DR,AN_Arr_Ctcp_DR,AN_Arr_NurDoc,AN_Arr_DocCat,AN_Arr_NurCat,AN_Arr_CtcpNum,AN_Arr_UpdateDate,AN_Arr_UpdateTime,AN_Arr_UpdateUserId) values (:nowDate,:nowTime,:roomId,:opDr,:ctcpDr,:arrNurDoc,:docCat,:nurCat,:ctcpNum,:upDate,:nowTime,:userId))
	...i SQLCODE'=0 s retStr="巡回护士插入失败!"
	...i SQLCODE'=0 TROLLBACK
	e  d
	.q:delete'="N"
	.f opNum=1:1:$l(opId,"^") d
	..s opDr=$p(opId,"^",opNum)
	..s anArrRowId="" f  s anArrRowId=$O(^DHCANArr(0,"AnArrDate",nowDate,anArrRowId)) q:anArrRowId=""  d
	...s arrOpDr=$P($G(^DHCANArr(anArrRowId)),"^",4)
	...q:arrOpDr'=opDr
	...s arrNurDoc=$P($G(^DHCANArr(anArrRowId)),"^",6)
	...q:arrNurDoc'="N"
	...s nurCat=$P($G(^DHCANArr(anArrRowId)),"^",8)
	...q:nurCat'="T"
	...&SQL(delete from DHC_AN_Arrange  where AN_Arr_RowId=:anArrRowId)
	...i SQLCODE'=0 s retStr="更新巡回护士失败!"
	...i SQLCODE'=0 TROLLBACK
	;q:retStr'="" retStr

	i ctcpTourNurJ'="" d
	.s num=$L(ctcpTourNurJ,"^")
	.f i=1:1:num d
	..s ctcpDr=$P(ctcpTourNurJ,"^",i)
	..s arrNurDoc="N"
	..s docCat=""
	..s nurCat="X"
	..s ctcpNum=i
	..f opNum=1:1:$l(opId,"^") d
	...s opDr=$p(opId,"^",opNum)
	...&SQL(insert into DHC_AN_Arrange (AN_Arr_Date,AN_Arr_Time,AN_Arr_Room_DR,AN_Arr_Op_DR,AN_Arr_Ctcp_DR,AN_Arr_NurDoc,AN_Arr_DocCat,AN_Arr_NurCat,AN_Arr_CtcpNum,AN_Arr_UpdateDate,AN_Arr_UpdateTime,AN_Arr_UpdateUserId) values (:nowDate,:nowTime,:roomId,:opDr,:ctcpDr,:arrNurDoc,:docCat,:nurCat,:ctcpNum,:upDate,:nowTime,:userId))
	...i SQLCODE'=0 s retStr="交巡回护士插入失败!"
	...i SQLCODE'=0 TROLLBACK
	;q:retStr'="" retStr

	s opaRoom="",opstTime="",opaSeq=""
	s userId=%session.Data("LOGON.USERID")
	;s retStrDocNur=..SendMessage(opId,roomId,opaSeq,ctcpAnDoc,ctcpAnNur,ctcpDevNur,ctcpTourNur,opstTime)
	s retStrDocNur=..SendMessage(opId,opaRoom,opaSeq,ctcpAnDoc,ctcpAnNur,ctcpDevNur,ctcpTourNur,opstTime,userId)
	;s retStrDocNur="0"
	i retStrDocNur'="0" s retStr=retStrDocNur_"Message"
	;i retStrDocNur'="0" s retStr="发送消息失败！"
	i retStrDocNur'="0" TROLLBACK
	i retStrDocNur="0" s retStr=""
	i retStr="" TCOMMIT
	
	q retStr
	
ERRORUpdateANArr
	s retStr=$ZE
	TROLLBACK
	q "-1^Arr"_retStr
}

/// w ##class(web.DHCANArrange).UpdateANArr("4","^168^166","","","","","580","","","","","27/11/2009")
ClassMethod UpdateANArr1(roomId As %Library.String = "", opId As %Library.String = "", ctcpAnDoc As %Library.String = "", ctcpAnDocO As %Library.String = "", ctcpAnDocJ As %Library.String = "", ctcpAnNur As %Library.String = "", ctcpDevNur As %Library.String = "", ctcpDevNurJ As %Library.String = "", ctcpTourNur As %Library.String = "", ctcpTourNurJ As %Library.String = "", anDocNote As %String = "", opdate As %String = "") As %String
{
	//s ^Tmpck("UpdateANArr1",$h)=roomId_"*"_opId_"*"_ctcpAnDoc_"*"_ctcpAnDocO_"*"_ctcpAnDocJ_"*"_ansupervisid_"*"_ctcpAnNur_"*"_ctcpDevNur_"*"_ctcpDevNurJ_"*"_ctcpTourNur_"*"_ctcpTourNurJ_"*"_anDocNote_"*"_opdate
	q:roomId="" "手术间ID为空!"
	s $zt="ERRORUpdateANArr1"
	i opdate'="" s nowDate=$ZDH(opdate,4) //ck  090929
	e  s nowDate=+$H
	s nowTime=$P($H,",",2)
	s upDate=+$H  //ck 091013 更新时间
	s userId=%session.Data("LOGON.USERID")
	s retStr=""
	s SQLCODE=-1

	TSTART
	s opIdLen=$l(opId,"^")
	i opIdLen>0  d
	.s opaId=opId
	.s opId=""
	e  q "opId错误！" 
	
	i roomId'="" d
	.s ctcpDr=$O(^DHCANArr(0,"DateRoom",nowDate,roomId,""))
	.q:ctcpDr=""
	.s arrDate=$ZD(nowDate,4)
	.&SQL(delete from DHC_AN_Arrange  where AN_Arr_Room_DR=:roomId and AN_Arr_Date=:nowDate)
	.i SQLCODE'=0 s retStr="删除排班失败!"
	.i SQLCODE'=0 TROLLBACK
	q:retStr'="" retStr
	i ctcpAnDoc'="" d
	.s ctcpDr=ctcpAnDoc
	.s arrNurDoc="D"
	.s docCat="A"
	.s nurCat=""
	.s ctcpNum=1
	.&SQL(insert into DHC_AN_Arrange (AN_Arr_Date,AN_Arr_Time,AN_Arr_Room_DR,AN_Arr_Op_DR,AN_Arr_Ctcp_DR,AN_Arr_NurDoc,AN_Arr_DocCat,AN_Arr_NurCat,AN_Arr_CtcpNum,AN_Arr_UpdateDate,AN_Arr_UpdateTime,AN_Arr_UpdateUserId,AN_Arr_Note) values (:nowDate,:nowTime,:roomId,:opId,:ctcpDr,:arrNurDoc,:docCat,:nurCat,:ctcpNum,:upDate,:nowTime,:userId,:anDocNote))
	.i SQLCODE'=0 s retStr="麻醉指导医师插入失败!"
	.i SQLCODE'=0 TROLLBACK
	q:retStr'="" retStr
	i ctcpAnDocO'="" d
	.s num=$L(ctcpAnDocO,"^")
	.f i=1:1:num d
	..s ctcpDr=$P(ctcpAnDocO,"^",i)
	..s arrNurDoc="D"
	..s docCat="O"
	..s nurCat=""
	..s ctcpNum=i
	..&SQL(insert into DHC_AN_Arrange (AN_Arr_Date,AN_Arr_Time,AN_Arr_Room_DR,AN_Arr_Op_DR,AN_Arr_Ctcp_DR,AN_Arr_NurDoc,AN_Arr_DocCat,AN_Arr_NurCat,AN_Arr_CtcpNum,AN_Arr_UpdateDate,AN_Arr_UpdateTime,AN_Arr_UpdateUserId) values (:nowDate,:nowTime,:roomId,:opId,:ctcpDr,:arrNurDoc,:docCat,:nurCat,:ctcpNum,:upDate,:nowTime,:userId))
	..i SQLCODE'=0 s retStr="麻醉主治医师插入失败!"
	..i SQLCODE'=0 TROLLBACK
	q:retStr'="" retStr
	i ctcpAnDocJ'="" d
	.s num=$L(ctcpAnDocJ,"^")
	.f i=1:1:num d
	..s ctcpDr=$P(ctcpAnDocJ,"^",i)
	..s arrNurDoc="D"
	..s docCat="J"
	..s nurCat=""
	..s ctcpNum=i
	..&SQL(insert into DHC_AN_Arrange (AN_Arr_Date,AN_Arr_Time,AN_Arr_Room_DR,AN_Arr_Op_DR,AN_Arr_Ctcp_DR,AN_Arr_NurDoc,AN_Arr_DocCat,AN_Arr_NurCat,AN_Arr_CtcpNum,AN_Arr_UpdateDate,AN_Arr_UpdateTime,AN_Arr_UpdateUserId) values (:nowDate,:nowTime,:roomId,:opId,:ctcpDr,:arrNurDoc,:docCat,:nurCat,:ctcpNum,:upDate,:nowTime,:userId))
	..i SQLCODE'=0 s retStr="其他麻醉师插入失败!"
	..i SQLCODE'=0 TROLLBACK
	q:retStr'="" retStr
	i ctcpAnNur'="" d
	.s ctcpDr=ctcpAnNur
	.s arrNurDoc="N"
	.s docCat=""
	.s nurCat="A"
	.s ctcpNum=1
	.&SQL(insert into DHC_AN_Arrange (AN_Arr_Date,AN_Arr_Time,AN_Arr_Room_DR,AN_Arr_Op_DR,AN_Arr_Ctcp_DR,AN_Arr_NurDoc,AN_Arr_DocCat,AN_Arr_NurCat,AN_Arr_CtcpNum,AN_Arr_UpdateDate,AN_Arr_UpdateTime,AN_Arr_UpdateUserId) values (:nowDate,:nowTime,:roomId,:opId,:ctcpDr,:arrNurDoc,:docCat,:nurCat,:ctcpNum,:upDate,:nowTime,:userId))
	.i SQLCODE'=0 s retStr="麻醉助手插入失败!"
	.i SQLCODE'=0 TROLLBACK
	q:retStr'="" retStr
	i ctcpDevNur'="" d
	.s num=$L(ctcpDevNur,"^")
	.f i=1:1:num d
	..s ctcpDr=$P(ctcpDevNur,"^",i)
	..s arrNurDoc="N"
	..s docCat=""
	..s nurCat="D"
	..s ctcpNum=i
	..&SQL(insert into DHC_AN_Arrange (AN_Arr_Date,AN_Arr_Time,AN_Arr_Room_DR,AN_Arr_Op_DR,AN_Arr_Ctcp_DR,AN_Arr_NurDoc,AN_Arr_DocCat,AN_Arr_NurCat,AN_Arr_CtcpNum,AN_Arr_UpdateDate,AN_Arr_UpdateTime,AN_Arr_UpdateUserId) values (:nowDate,:nowTime,:roomId,:opId,:ctcpDr,:arrNurDoc,:docCat,:nurCat,:ctcpNum,:upDate,:nowTime,:userId))
	..i SQLCODE'=0 s retStr="器械护士插入失败!"
	..i SQLCODE'=0 TROLLBACK
	q:retStr'="" retStr
	i ctcpDevNurJ'="" d
	.s num=$L(ctcpDevNurJ,"^")
	.f i=1:1:num d
	..s ctcpDr=$P(ctcpDevNurJ,"^",i)
	..s arrNurDoc="N"
	..s docCat=""
	..s nurCat="J"
	..s ctcpNum=i
	..&SQL(insert into DHC_AN_Arrange (AN_Arr_Date,AN_Arr_Time,AN_Arr_Room_DR,AN_Arr_Op_DR,AN_Arr_Ctcp_DR,AN_Arr_NurDoc,AN_Arr_DocCat,AN_Arr_NurCat,AN_Arr_CtcpNum,AN_Arr_UpdateDate,AN_Arr_UpdateTime,AN_Arr_UpdateUserId) values (:nowDate,:nowTime,:roomId,:opId,:ctcpDr,:arrNurDoc,:docCat,:nurCat,:ctcpNum,:upDate,:nowTime,:userId))
	..i SQLCODE'=0 s retStr="交器械护士插入失败!"
	..i SQLCODE'=0 TROLLBACK
	q:retStr'="" retStr
	i ctcpTourNur'="" d
	.s num=$L(ctcpTourNur,"^")
	.f i=1:1:num d
	..s ctcpDr=$P(ctcpTourNur,"^",i)
	..s arrNurDoc="N"
	..s docCat=""
	..s nurCat="T"
	..s ctcpNum=i
	..&SQL(insert into DHC_AN_Arrange (AN_Arr_Date,AN_Arr_Time,AN_Arr_Room_DR,AN_Arr_Op_DR,AN_Arr_Ctcp_DR,AN_Arr_NurDoc,AN_Arr_DocCat,AN_Arr_NurCat,AN_Arr_CtcpNum,AN_Arr_UpdateDate,AN_Arr_UpdateTime,AN_Arr_UpdateUserId) values (:nowDate,:nowTime,:roomId,:opId,:ctcpDr,:arrNurDoc,:docCat,:nurCat,:ctcpNum,:upDate,:nowTime,:userId))
	..i SQLCODE'=0 s retStr="巡回护士插入失败!"
	..i SQLCODE'=0 TROLLBACK
	q:retStr'="" retStr
	i ctcpTourNurJ'="" d
	.s num=$L(ctcpTourNurJ,"^")
	.f i=1:1:num d
	..s ctcpDr=$P(ctcpTourNurJ,"^",i)
	..s arrNurDoc="N"
	..s docCat=""
	..s nurCat="X"
	..s ctcpNum=i
	..&SQL(insert into DHC_AN_Arrange (AN_Arr_Date,AN_Arr_Time,AN_Arr_Room_DR,AN_Arr_Op_DR,AN_Arr_Ctcp_DR,AN_Arr_NurDoc,AN_Arr_DocCat,AN_Arr_NurCat,AN_Arr_CtcpNum,AN_Arr_UpdateDate,AN_Arr_UpdateTime,AN_Arr_UpdateUserId) values (:nowDate,:nowTime,:roomId,:opId,:ctcpDr,:arrNurDoc,:docCat,:nurCat,:ctcpNum,:upDate,:nowTime,:userId))
	..i SQLCODE'=0 s retStr="交巡回护士插入失败!"
	..i SQLCODE'=0 TROLLBACK
	q:retStr'="" retStr
	s opaRoom="",opaSeq="",opstTime=""
	s userId=%session.Data("LOGON.USERID")
	s retStr1=..SendMessage(opaId,opaRoom,opaSeq,ctcpAnDoc,ctcpAnNur,ctcpDevNur,ctcpTourNur,opstTime,userId)
	i retStr1'="0"  d
	.TROLLBACK
	.s retStr=retStr1
	.;s retStr="发送消息失败！"
	i retStr1="0" s retStr=""
	i retStr="" TCOMMIT
	
	q retStr
	
ERRORUpdateANArr1
	TROLLBACK
	q "-1"
}

/// 更新排班信息
/// 通过手术间ID取得排班信息 加载到手术申请界面
/// w ##class(web.DHCANArrange).GetANArr(1)
ClassMethod GetANArr(roomId As %Library.String = "", opdate As %Library.String = "")
{
	q:roomId="" "手术间不能为空!"
	i opdate="" s nowDate=+$h
	;s nowDate=+$H
	i opdate'="" s nowDate=$zdh(opdate)
	s retVal=""
	s (ctcpAnDoc,ctcpAnDocO,ctcpAnDocJ,ctcpAnNur,ctcpDevNur,ctcpDevNurJ,ctcpTourNur,ctcpTourNurJ)=""	
	s ctcpDr=""
	f  s ctcpDr=$O(^DHCANArr(0,"DateRoom",nowDate,roomId,ctcpDr)) q:ctcpDr=""  d
	.s anArrRowId=""
	.f  s anArrRowId=$O(^DHCANArr(0,"DateRoom",nowDate,roomId,ctcpDr,anArrRowId)) q:anArrRowId=""  d
	..s arrNurDoc=$P($G(^DHCANArr(anArrRowId)),"^",6)
	..s docCat=$P($G(^DHCANArr(anArrRowId)),"^",7)
	..s nurCat=$P($G(^DHCANArr(anArrRowId)),"^",8)
	..i (arrNurDoc="D")&(docCat="A") d
	...s ctcpAnDoc=..GetCtcpInfo(ctcpDr)
	..i (arrNurDoc="D")&(docCat="O") d
	...i ctcpAnDocO="" s ctcpAnDocO=..GetCtcpInfo(ctcpDr)
	...e  s ctcpAnDocO=ctcpAnDocO_"^"_(..GetCtcpInfo(ctcpDr))
	..i (arrNurDoc="D")&(docCat="J") d
	...i ctcpAnDocJ="" s ctcpAnDocJ=..GetCtcpInfo(ctcpDr)
	...e  s ctcpAnDocJ=ctcpAnDocJ_"^"_(..GetCtcpInfo(ctcpDr))
	..i (arrNurDoc="N")&(nurCat="A") d
	...s ctcpAnNur=..GetCtcpInfo(ctcpDr)
	..i (arrNurDoc="N")&(nurCat="D") d
	...i ctcpDevNur="" s ctcpDevNur=..GetCtcpInfo(ctcpDr)
	...e  s ctcpDevNur=ctcpDevNur_"^"_(..GetCtcpInfo(ctcpDr))
	..i (arrNurDoc="N")&(nurCat="J") d
	...i ctcpDevNurJ="" s ctcpDevNurJ=..GetCtcpInfo(ctcpDr)
	...e  s ctcpDevNurJ=ctcpDevNurJ_"^"_(..GetCtcpInfo(ctcpDr))
	..i (arrNurDoc="N")&(nurCat="T") d
	...i ctcpTourNur="" s ctcpTourNur=..GetCtcpInfo(ctcpDr)
	...e  s ctcpTourNur=ctcpTourNur_"^"_(..GetCtcpInfo(ctcpDr))
	..i (arrNurDoc="N")&(nurCat="X") d
	...i ctcpTourNurJ="" s ctcpTourNurJ=..GetCtcpInfo(ctcpDr)
	...e  s ctcpTourNurJ=ctcpTourNurJ_"^"_(..GetCtcpInfo(ctcpDr))

	i ctcpAnDoc'="" s retVal="SetElementValue('anadoc','andocid','"_$ZCVT(ctcpAnDoc,"O","JS")_"');"
	i ctcpAnDocO'="" s retVal=retVal_"InitList('anadocO','"_$ZCVT(ctcpAnDocO,"O","JS")_"');"
	i ctcpAnDocJ'="" s retVal=retVal_"InitList('janadocO','"_$ZCVT(ctcpAnDocJ,"O","JS")_"');"
	i ctcpDevNur'="" s retVal=retVal_"InitList('scrubnurseO','"_$ZCVT(ctcpDevNur,"O","JS")_"');"
	i ctcpDevNurJ'="" s retVal=retVal_"InitList('jbnurseO','"_$ZCVT(ctcpDevNurJ,"O","JS")_"');"
	i ctcpTourNur'="" s retVal=retVal_"InitList('circulnurseO','"_$ZCVT(ctcpTourNur,"O","JS")_"');"
	i ctcpTourNurJ'="" s retVal=retVal_"InitList('jxhnurseO','"_$ZCVT(ctcpTourNurJ,"O","JS")_"');"
	i ctcpAnNur'="" s retVal=retVal_"SetElementValue('anaNurse','anaNurseId','"_$ZCVT(ctcpAnNur,"O","JS")_"');"
    &javascript<#(retVal)#>
    q
}

/// 091202修改 麻醉指导医生
/// 通过手术间ID取得排班信息 加载到手术排班界面
/// w ##class(web.DHCANArrange).GetAnOpArr(1)
ClassMethod GetAnOpArr(roomId As %Library.String = "", opdate As %Library.String = "")
{
	q:roomId="" "手术间不能为空!"
	i opdate="" s nowDate=+$H
	e  s nowDate=$zdh(opdate,4)

	s retVal=""
	s anDocNote=""
	s anDocNote=$g(^DHCAnDocNote("Date",nowDate))
	s (ctcpAnDoc,ctcpAnDocO,ctcpAnDocJ,ansupervisor,ctcpAnNur,ctcpDevNur,ctcpDevNurJ,ctcpTourNur,ctcpTourNurJ,ansupervisid,anNur1)=""	
	s ctcpDr=""
	f  s ctcpDr=$O(^DHCANArr(0,"DateRoom",nowDate,roomId,ctcpDr)) q:ctcpDr=""  d
	.s anArrRowId=""
	.f  s anArrRowId=$O(^DHCANArr(0,"DateRoom",nowDate,roomId,ctcpDr,anArrRowId)) q:anArrRowId=""  d
	..s arrNurDoc=$P($G(^DHCANArr(anArrRowId)),"^",6)
	..s docCat=$P($G(^DHCANArr(anArrRowId)),"^",7)
	..s nurCat=$P($G(^DHCANArr(anArrRowId)),"^",8)
	..s arrNote=$P($G(^DHCANArr(anArrRowId)),"^",10)
	..i (arrNurDoc="D")&(docCat="A") d
	...s ctcpAnDoc=..GetCtcpInfo(ctcpDr)
	..i (arrNurDoc="D")&(docCat="S") d
	...s ansupervisor=..GetCtcpInfo(ctcpDr)
	..;i arrNote'="" s anDocNote=arrNote
	..i (arrNurDoc="D")&(docCat="O") d
	...i ctcpAnDocO="" s ctcpAnDocO=..GetCtcpInfo(ctcpDr)
	...e  s ctcpAnDocO=ctcpAnDocO_"^"_(..GetCtcpInfo(ctcpDr))
	..i (arrNurDoc="D")&(docCat="J") d
	...i ctcpAnDocJ="" s ctcpAnDocJ=..GetCtcpInfo(ctcpDr)
	...e  s ctcpAnDocJ=ctcpAnDocJ_"^"_(..GetCtcpInfo(ctcpDr))
	..i (arrNurDoc="N")&(nurCat="A") d
	...;s ctcpAnNur=..GetCtcpInfo(ctcpDr)
	...s anNur1=..GetCtcpInfo(ctcpDr)
	..i (arrNurDoc="N")&(nurCat="D") d
	...i ctcpDevNur="" s ctcpDevNur=..GetCtcpInfo(ctcpDr)
	...e  s ctcpDevNur=ctcpDevNur_"^"_(..GetCtcpInfo(ctcpDr))
	..i (arrNurDoc="N")&(nurCat="J") d
	...i ctcpDevNurJ="" s ctcpDevNurJ=..GetCtcpInfo(ctcpDr)
	...e  s ctcpDevNurJ=ctcpDevNurJ_"^"_(..GetCtcpInfo(ctcpDr))
	..i (arrNurDoc="N")&(nurCat="T") d
	...i ctcpTourNur="" s ctcpTourNur=..GetCtcpInfo(ctcpDr)
	...e  s ctcpTourNur=ctcpTourNur_"^"_(..GetCtcpInfo(ctcpDr))
	..i (arrNurDoc="N")&(nurCat="X") d
	...i ctcpTourNurJ="" s ctcpTourNurJ=..GetCtcpInfo(ctcpDr)
	...e  s ctcpTourNurJ=ctcpTourNurJ_"^"_(..GetCtcpInfo(ctcpDr))
	
	///巡回护士默认用上一个工作日的(不包括周六、日)
	i (ctcpTourNurJ="")&&(ctcpTourNur="")&&($ZD(nowDate,10)'=0)&&($ZD(nowDate,10)'=6) d
	.i $ZD(nowDate,10)=1 s arrDate=nowDate-3
	.e  s arrDate=nowDate-1
	.s ctcpDr=""
	.f  s ctcpDr=$O(^DHCANArr(0,"DateRoom",arrDate,roomId,ctcpDr)) q:ctcpDr=""  d
	..s anArrRowId=""
	..f  s anArrRowId=$O(^DHCANArr(0,"DateRoom",arrDate,roomId,ctcpDr,anArrRowId)) q:anArrRowId=""  d
	...s arrNurDoc=$P($G(^DHCANArr(anArrRowId)),"^",6)
	...s docCat=$P($G(^DHCANArr(anArrRowId)),"^",7)
	...s nurCat=$P($G(^DHCANArr(anArrRowId)),"^",8)
	...i (arrNurDoc="N")&(nurCat="T") d
	....i ctcpTourNur="" s ctcpTourNur=..GetCtcpInfo(ctcpDr)
	....e  s ctcpTourNur=ctcpTourNur_"^"_(..GetCtcpInfo(ctcpDr))
	...i (arrNurDoc="N")&(nurCat="X") d
	....i ctcpTourNurJ="" s ctcpTourNurJ=..GetCtcpInfo(ctcpDr)
	....e  s ctcpTourNurJ=ctcpTourNurJ_"^"_(..GetCtcpInfo(ctcpDr))
	
	i ctcpAnDoc'="" s retVal="SetElementValue('andoc','anDocId','"_$ZCVT(ctcpAnDoc,"O","JS")_"');"
	i ctcpAnDocO'="" s retVal=retVal_"InitList('ctcpAnDocO','"_$ZCVT(ctcpAnDocO,"O","JS")_"');"
	i ctcpAnDocJ'="" s retVal=retVal_"InitList('ctcpAnDocJ','"_$ZCVT(ctcpAnDocJ,"O","JS")_"');"
	i ctcpDevNur'="" s retVal=retVal_"InitList('ctcpDevNur','"_$ZCVT(ctcpDevNur,"O","JS")_"');"
	i ctcpDevNurJ'="" s retVal=retVal_"InitList('ctcpDevNurJ','"_$ZCVT(ctcpDevNurJ,"O","JS")_"');"
	i ctcpTourNur'="" s retVal=retVal_"InitList('ctcpTourNur','"_$ZCVT(ctcpTourNur,"O","JS")_"');"
	i ctcpTourNurJ'="" s retVal=retVal_"InitList('ctcpTourNurJ','"_$ZCVT(ctcpTourNurJ,"O","JS")_"');"
	i anNur1'="" s retVal=retVal_"InitList('anNur1','"_$ZCVT(anNur1,"O","JS")_"');"   //ck  091013
	i ctcpAnNur'="" s retVal=retVal_"SetElementValue('anNur','anNurId','"_$ZCVT(ctcpAnNur,"O","JS")_"');"
	i anDocNote'="" s retVal=retVal_"SetElementValue('anDocNote','','"_$ZCVT(anDocNote,"O","JS")_"');"
	;i ansupervisid'="" s retVal=retVal_"InitList('ansupervisid','"_$ZCVT(ansupervisid,"O","JS")_"');"   //ck  091013    
    i ansupervisor'="" s retVal=retVal_"SetElementValue('ansupervisor','ansupervisid','"_$ZCVT(ansupervisor,"O","JS")_"');"
    &javascript<#(retVal)#>
    q
}

/// GetAnOpArr
/// 通过手术间ID取得排班信息 加载到手术排班界面
/// w ##class(web.DHCANArrange).GetAnOpArr(1)
ClassMethod GetAnOpArr1(roomId As %Library.String = "", opdate As %Library.String = "")
{
	q:roomId="" "手术间不能为空!"
	i opdate="" s nowDate=+$H
	e  s nowDate=$zdh(opdate,4)

	s retVal=""
	s anDocNote=""
	s (ctcpAnDoc,ctcpAnDocO,ctcpAnDocJ,ctcpAnNur,ctcpDevNur,ctcpDevNurJ,ctcpTourNur,ctcpTourNurJ,anNur1)=""	
	s ctcpDr=""
	f  s ctcpDr=$O(^DHCANArr(0,"DateRoom",nowDate,roomId,ctcpDr)) q:ctcpDr=""  d
	.s anArrRowId=""
	.f  s anArrRowId=$O(^DHCANArr(0,"DateRoom",nowDate,roomId,ctcpDr,anArrRowId)) q:anArrRowId=""  d
	..s arrNurDoc=$P($G(^DHCANArr(anArrRowId)),"^",6)
	..s docCat=$P($G(^DHCANArr(anArrRowId)),"^",7)
	..s nurCat=$P($G(^DHCANArr(anArrRowId)),"^",8)
	..s arrNote=$P($G(^DHCANArr(anArrRowId)),"^",10)
	..i (arrNurDoc="D")&(docCat="A") d
	...s ctcpAnDoc=..GetCtcpInfo(ctcpDr)
	..i arrNote'="" s anDocNote=arrNote
	..i (arrNurDoc="D")&(docCat="O") d
	...i ctcpAnDocO="" s ctcpAnDocO=..GetCtcpInfo(ctcpDr)
	...e  s ctcpAnDocO=ctcpAnDocO_"^"_(..GetCtcpInfo(ctcpDr))
	..i (arrNurDoc="D")&(docCat="J") d
	...i ctcpAnDocJ="" s ctcpAnDocJ=..GetCtcpInfo(ctcpDr)
	...e  s ctcpAnDocJ=ctcpAnDocJ_"^"_(..GetCtcpInfo(ctcpDr))
	..i (arrNurDoc="N")&(nurCat="A") d
	...;s ctcpAnNur=..GetCtcpInfo(ctcpDr)
	...s anNur1=..GetCtcpInfo(ctcpDr)
	..i (arrNurDoc="N")&(nurCat="D") d
	...i ctcpDevNur="" s ctcpDevNur=..GetCtcpInfo(ctcpDr)
	...e  s ctcpDevNur=ctcpDevNur_"^"_(..GetCtcpInfo(ctcpDr))
	..i (arrNurDoc="N")&(nurCat="J") d
	...i ctcpDevNurJ="" s ctcpDevNurJ=..GetCtcpInfo(ctcpDr)
	...e  s ctcpDevNurJ=ctcpDevNurJ_"^"_(..GetCtcpInfo(ctcpDr))
	..i (arrNurDoc="N")&(nurCat="T") d
	...i ctcpTourNur="" s ctcpTourNur=..GetCtcpInfo(ctcpDr)
	...e  s ctcpTourNur=ctcpTourNur_"^"_(..GetCtcpInfo(ctcpDr))
	..i (arrNurDoc="N")&(nurCat="X") d
	...i ctcpTourNurJ="" s ctcpTourNurJ=..GetCtcpInfo(ctcpDr)
	...e  s ctcpTourNurJ=ctcpTourNurJ_"^"_(..GetCtcpInfo(ctcpDr))
	
	///巡回护士默认用上一个工作日的(不包括周六、日)
	i (ctcpTourNurJ="")&&(ctcpTourNur="")&&($ZD(nowDate,10)'=0)&&($ZD(nowDate,10)'=6) d
	.i $ZD(nowDate,10)=1 s arrDate=nowDate-3
	.e  s arrDate=nowDate-1
	.s ctcpDr=""
	.f  s ctcpDr=$O(^DHCANArr(0,"DateRoom",arrDate,roomId,ctcpDr)) q:ctcpDr=""  d
	..s anArrRowId=""
	..f  s anArrRowId=$O(^DHCANArr(0,"DateRoom",arrDate,roomId,ctcpDr,anArrRowId)) q:anArrRowId=""  d
	...s arrNurDoc=$P($G(^DHCANArr(anArrRowId)),"^",6)
	...s docCat=$P($G(^DHCANArr(anArrRowId)),"^",7)
	...s nurCat=$P($G(^DHCANArr(anArrRowId)),"^",8)
	...i (arrNurDoc="N")&(nurCat="T") d
	....i ctcpTourNur="" s ctcpTourNur=..GetCtcpInfo(ctcpDr)
	....e  s ctcpTourNur=ctcpTourNur_"^"_(..GetCtcpInfo(ctcpDr))
	...i (arrNurDoc="N")&(nurCat="X") d
	....i ctcpTourNurJ="" s ctcpTourNurJ=..GetCtcpInfo(ctcpDr)
	....e  s ctcpTourNurJ=ctcpTourNurJ_"^"_(..GetCtcpInfo(ctcpDr))
	
	i ctcpAnDoc'="" s retVal="SetElementValue('andoc','anDocId','"_$ZCVT(ctcpAnDoc,"O","JS")_"');"
	i ctcpAnDocO'="" s retVal=retVal_"InitList('ctcpAnDocO','"_$ZCVT(ctcpAnDocO,"O","JS")_"');"
	i ctcpAnDocJ'="" s retVal=retVal_"InitList('ctcpAnDocJ','"_$ZCVT(ctcpAnDocJ,"O","JS")_"');"
	i ctcpDevNur'="" s retVal=retVal_"InitList('ctcpDevNur','"_$ZCVT(ctcpDevNur,"O","JS")_"');"
	i ctcpDevNurJ'="" s retVal=retVal_"InitList('ctcpDevNurJ','"_$ZCVT(ctcpDevNurJ,"O","JS")_"');"
	i ctcpTourNur'="" s retVal=retVal_"InitList('ctcpTourNur','"_$ZCVT(ctcpTourNur,"O","JS")_"');"
	i ctcpTourNurJ'="" s retVal=retVal_"InitList('ctcpTourNurJ','"_$ZCVT(ctcpTourNurJ,"O","JS")_"');"
	i anNur1'="" s retVal=retVal_"InitList('anNur1','"_$ZCVT(anNur1,"O","JS")_"');"   //ck  091013
	i ctcpAnNur'="" s retVal=retVal_"SetElementValue('anNur','anNurId','"_$ZCVT(ctcpAnNur,"O","JS")_"');"
	i anDocNote'="" s retVal=retVal_"SetElementValue('anDocNote','','"_$ZCVT(anDocNote,"O","JS")_"');"
    &javascript<#(retVal)#>
    q
}

/// sjq，安排今天以后的手术申请时（当前时间不等于手术开始时间时），只处理巡回护士
ClassMethod SetTourNur(roomId As %Library.String = "", opId As %Library.String = "", opdate As %Library.String = "")
{
	s (ctcpAnDoc,ctcpAnDocO,ctcpAnDocJ,ctcpAnNur,ctcpDevNur,ctcpDevNurJ,ctcpTourNur,ctcpTourNurJ)=""	
	s retStr="" 
	q:(roomId="")!(opId="") "手术间ID手术申请ID必须非空!"
	s anaId=$P($G(^DHCANOPArrange(opId)),"^",2)
	q:anaId="" "手术申请不存在!"
	s admId=+anaId
    s anaSub=$p(anaId,"||",2)
	i opdate'="" s nowDate=$ZDH(opdate,4) //ck  090929
	e  s nowDate=+$H
	s anDocNote=""

	s ctcpDr=""
	f  s ctcpDr=$O(^DHCANArr(0,"DateRoom",nowDate,roomId,ctcpDr)) q:ctcpDr=""  d
	.s anArrRowId=""
	.f  s anArrRowId=$O(^DHCANArr(0,"DateRoom",nowDate,roomId,ctcpDr,anArrRowId)) q:anArrRowId=""  d
	..s arrNurDoc=$P($G(^DHCANArr(anArrRowId)),"^",6)
	..s nurCat=$P($G(^DHCANArr(anArrRowId)),"^",8)
	..i (arrNurDoc="N")&(nurCat="T") d
	...i ctcpTourNur="" s ctcpTourNur=ctcpDr
	...e  s ctcpTourNur=ctcpTourNur_"^"_ctcpDr
    
    s anaopSub=0
    f  s anaopSub=$o(^OR(admId,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
    .q:$p(^OR(admId,"ANA",anaSub,"OP",anaopSub),"^",12)'="M"
    .
    .i ctcpTourNur'="" d
    ..k ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN")
    ..s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN",0)=100
    ..f i=1:1:$L(ctcpTourNur,"^") d
    ...q:$P(ctcpTourNur,"^",i)=""
    ...s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN",i)=$P(ctcpTourNur,"^",i)

	q ""
}

/// 更新手术申请医护人员排班信息
/// w ##class(web.DHCANArrange).UpdateANOpArr("9","3737","11/09/2010","Y")
/// ClassMethod UpdateANOpArr(roomId As %Library.String = "", opId As %Library.String = "", opdate As %Library.String = "")
ClassMethod UpdateANOpArr(roomId As %Library.String = "", opId As %Library.String = "", opdate As %Library.String = "", setMessage As %String = "")
{
	s (ctcpAnDoc,ctcpAnDocO,ctcpAnDocJ,ctcpAnNur,ctcpDevNur,ctcpDevNurJ,ctcpTourNur,ctcpTourNurJ,mzsupdoc)=""	
	s retStr="0"
	q:(roomId="")!(opId="") "手术间ID手术申请ID必须非空!"
	s $zt="ERRORUpdateANOpArr"
	i setMessage="" s setMessage="Y"
	e  s setMessage=setMessage
	i $l(opdate,"-")>2 s opdate=$ZDH(opdate,3) // starD
	i $l(opdate,"/")>2 s opdate=$ZDH(opdate,4) // starD

	s anaId=$P($G(^DHCANOPArrange(opId)),"^",2)

	q:anaId="" "手术申请不存在!"
	s admId=+anaId
    s anaSub=$p(anaId,"||",2)
	s nowDate=opdate
	s anDocNote=""

	//sjq添加
	s anOpArrangeDate=$P(^DHCANOPArrange(opId),"^",14)
	i anOpArrangeDate'=nowDate q ..SetTourNur(roomId,opId,opdate)
	s ctcpDr=""
	f  s ctcpDr=$O(^DHCANArr(0,"DateRoom",nowDate,roomId,ctcpDr)) q:ctcpDr=""  d
	.s anArrRowId=""
	.f  s anArrRowId=$O(^DHCANArr(0,"DateRoom",nowDate,roomId,ctcpDr,anArrRowId)) q:anArrRowId=""  d
	..s arrOpDr=$P($G(^DHCANArr(anArrRowId)),"^",4)
	..q:arrOpDr'=opId
	..s arrNurDoc=$P($G(^DHCANArr(anArrRowId)),"^",6)
	..s docCat=$P($G(^DHCANArr(anArrRowId)),"^",7)
	..s nurCat=$P($G(^DHCANArr(anArrRowId)),"^",8)
	..s arrNote=$P($G(^DHCANArr(anArrRowId)),"^",10)
	..i (arrNurDoc="D")&(docCat="A") d
	...s ctcpAnDoc=ctcpDr
	..i (arrNurDoc="D")&(docCat="O") d
	...i ctcpAnDocO="" s ctcpAnDocO=ctcpDr
	...e  s ctcpAnDocO=ctcpAnDocO_"^"_ctcpDr
	..i (arrNurDoc="D")&(docCat="S") d
	...s mzsupdoc=ctcpDr
	..i arrNote'="" s anDocNote=arrNote
	..i (arrNurDoc="D")&(docCat="J") d
	...i ctcpAnDocJ="" s ctcpAnDocJ=ctcpDr
	...e  s ctcpAnDocJ=ctcpAnDocJ_"^"_ctcpDr
	..i (arrNurDoc="N")&(nurCat="A") d
	...s ctcpAnNur=ctcpDr
	..i (arrNurDoc="N")&(nurCat="D") d
	...i ctcpDevNur="" s ctcpDevNur=ctcpDr
	...e  s ctcpDevNur=ctcpDevNur_"^"_ctcpDr
	..i (arrNurDoc="N")&(nurCat="J") d
	...i ctcpDevNurJ="" s ctcpDevNurJ=ctcpDr
	...e  s ctcpDevNurJ=ctcpDevNurJ_"^"_ctcpDr
	..i (arrNurDoc="N")&(nurCat="T") d
	...i ctcpTourNur="" s ctcpTourNur=ctcpDr
	...e  s ctcpTourNur=ctcpTourNur_"^"_ctcpDr
	..i (arrNurDoc="N")&(nurCat="X") d
	...i ctcpTourNurJ="" s ctcpTourNurJ=ctcpDr
	...e  s ctcpTourNurJ=ctcpTourNurJ_"^"_ctcpDr

	;TSTART
	s opaStat=$P(^DHCANOPArrange(opId),"^",27)
	i opaStat="R" d
	.;i (ctcpAnDoc'="")!(ctcpAnNur'="")!(mzsupdoc'="") d
	.&sql(update sqluser.OR_Anaesthesia set ana_anaesthetist_dr=:ctcpAnDoc,ANA_ORAnaNurse_DR=:ctcpAnNur,ANA_Supervisor_DR=:mzsupdoc where ana_rowid=:anaId)
	.i SQLCODE'=0 s retStr="更新麻醉表失败!"
	;i SQLCODE'=0 TROLLBACK

	&sql(update SQLUSER.DHC_AN_OPArrange set OPA_OpRoom_dr=:roomId,OPA_AnDocNote=:anDocNote where opa_rowid=:opId)
	i SQLCODE'=0 s retStr="更新手术间失败!"
	;i SQLCODE'=0 TROLLBACK

	i setMessage="Y" d
	.s opaSeq="",ctcpAnDoc="",ctcpAnNur="",ctcpDevNur="",ctcpTourNur="",opaId="",opstTime=""
	.s opaId=opId
	.s opaRoom=$p(^DHCANC("OPRoom",roomId),"^",2)
	.s opaSeqArr=$p($g(^DHCANOPArrange(opaId)),"^",26)
	.s retStrStatus=##Class(web.UDHCANOPArrange).UpdateAnOpStatus(opaId,"A")
	.i retStrStatus="-1" s retStr="更新状态失败！"
	.;i retStrStatus="-1" TROLLBACK
	.i retStrStatus="0" s retStr="0"
	.;q:((ctcpDevNur="")&(ctcpTourNur=""))!((ctcpAnDoc="")&(ctcpAnNur=""))
	.s userId=%session.Data("LOGON.USERID")
	.s retStrRoom=..SendMessage(opaId,opaRoom,opaSeq,ctcpAnDoc,ctcpAnNur,ctcpDevNur,ctcpTourNur,opstTime,userId)
	.i retStrRoom'="0" s retStr=retStrRoom
	.;i retStrRoom'="0" s retStr="发送消息失败！"
	.;i retStrRoom'="0" TROLLBACK
	.i retStrRoom="0" s retStr="0"
	e  s retStr="0"
	;i retStr=0 TCOMMIT
    s anaopSub=0
    f  s anaopSub=$o(^OR(admId,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
    .q:$p(^OR(admId,"ANA",anaSub,"OP",anaopSub),"^",12)'="M"
	.i ctcpAnDocO'="" d
	..k ^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS")
	..s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",0)=100
    ..f i=1:1:$L(ctcpAnDocO,"^")  d
    ...q:$P(ctcpAnDocO,"^",i)=""
    ...s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",i)=$P(ctcpAnDocO,"^",i)
    .e  d
    ..k ^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS")
    ..s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",0)=""
    .
    .i ctcpAnDocJ'="" d
    ..s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",0)=200
    ..f i=1:1:$L(ctcpAnDocJ,"^")  d
    ...q:$P(ctcpAnDocJ,"^",i)=""
    ...s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",20+i)=$P(ctcpAnDocJ,"^",i)
    .
    .i ctcpDevNur'="" d
    ..k ^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN")
    ..s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN",0)=100
    ..f i=1:1:$L(ctcpDevNur,"^") d
    ...q:$P(ctcpDevNur,"^",i)=""
    ...s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN",i)=$P(ctcpDevNur,"^",i)
    .e  d
    ..k ^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN")
    ..s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN",0)=""
    .
    .i ctcpDevNurJ'="" d
    ..s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN",0)=200
    ..f i=1:1:$L(ctcpDevNurJ,"^") d
    ...q:$P(ctcpDevNurJ,"^",i)=""
    ...s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN",20+i)=$P(ctcpDevNurJ,"^",i)
    .
    .i ctcpTourNur'="" d
    ..k ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN")
    ..s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN",0)=100
    ..f i=1:1:$L(ctcpTourNur,"^") d
    ...q:$P(ctcpTourNur,"^",i)=""
    ...s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN",i)=$P(ctcpTourNur,"^",i)
    .e  d
    ..k ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN")
    ..s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN",0)=""
    .
    .i ctcpTourNurJ'="" d
    ..s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN",0)=200
    ..f i=1:1:$L(ctcpTourNurJ,"^") d
    ...q:$P(ctcpTourNurJ,"^",i)=""
    ...s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN",20+i)=$P(ctcpTourNurJ,"^",i)
	q retStr
	
ERRORUpdateANOpArr
	TROLLBACK
	q "-1^back"
}

/// .f  s anArrRowId=$o(^DHCANArr(0,"AnArrDate",nowDate,anArrRowId)) q:anArrRowId=""  d
/// 更新手术申请医护人员排班信息
ClassMethod UpdateANOpArr1(roomId As %Library.String = "", opId As %Library.String = "", opdate As %Library.String = "") As %String
{
	s (ctcpAnDoc,ctcpAnDocO,ctcpAnDocJ,ctcpAnNur,ctcpDevNur,ctcpDevNurJ,ctcpTourNur,ctcpTourNurJ,mzsupdoc)=""	
	s retStr=""
	q:(roomId="")!(opId="") "手术间ID手术申请ID必须非空!"
	s $zt="ERRORUpdateANOpArr1"
	i $l(opdate,"-")>2 s opdate=$ZDH(opdate,3) // starD
	i $l(opdate,"/")>2 s opdate=$ZDH(opdate,4) // starD
	s anaId=$P($G(^DHCANOPArrange(opId)),"^",2)

	q:anaId="" "手术申请不存在!"
	s admId=+anaId
    s anaSub=$p(anaId,"||",2)
	s nowDate=opdate
	s anDocNote=""

	s anOpArrangeDate=$P(^DHCANOPArrange(opId),"^",14)
	i anOpArrangeDate'=nowDate q ..SetTourNur(roomId,opId,opdate)
	s ctcpDr=""
	f  s ctcpDr=$O(^DHCANArr(0,"DateRoom",nowDate,roomId,ctcpDr)) q:ctcpDr=""  d
	.s anArrRowId=0
	.f  s anArrRowId=$O(^DHCANArr(0,"DateRoom",nowDate,roomId,ctcpDr,anArrRowId)) q:anArrRowId=""  d
	..s arrOpDr=$P($G(^DHCANArr(anArrRowId)),"^",4)
	..q:arrOpDr'=opId
	..s arrNurDoc=$P($G(^DHCANArr(anArrRowId)),"^",6)
	..s docCat=$P($G(^DHCANArr(anArrRowId)),"^",7)
	..s nurCat=$P($G(^DHCANArr(anArrRowId)),"^",8)
	..s arrNote=$P($G(^DHCANArr(anArrRowId)),"^",10)
	..i (arrNurDoc="D")&(docCat="A") d
	...s ctcpAnDoc=ctcpDr
	..i (arrNurDoc="D")&(docCat="O") d
	...i ctcpAnDocO="" s ctcpAnDocO=ctcpDr
	...e  s ctcpAnDocO=ctcpAnDocO_"^"_ctcpDr
	..i (arrNurDoc="D")&(docCat="S") d
	...s mzsupdoc=ctcpDr
	..i arrNote'="" s anDocNote=arrNote
	..i (arrNurDoc="D")&(docCat="J") d
	...i ctcpAnDocJ="" s ctcpAnDocJ=ctcpDr
	...e  s ctcpAnDocJ=ctcpAnDocJ_"^"_ctcpDr
	..i (arrNurDoc="N")&(nurCat="A") d
	...s ctcpAnNur=ctcpDr
	..i (arrNurDoc="N")&(nurCat="D") d
	...i ctcpDevNur="" s ctcpDevNur=ctcpDr
	...e  s ctcpDevNur=ctcpDevNur_"^"_ctcpDr
	..i (arrNurDoc="N")&(nurCat="J") d
	...i ctcpDevNurJ="" s ctcpDevNurJ=ctcpDr
	...e  s ctcpDevNurJ=ctcpDevNurJ_"^"_ctcpDr
	..i (arrNurDoc="N")&(nurCat="T") d
	...i ctcpTourNur="" s ctcpTourNur=ctcpDr
	...e  s ctcpTourNur=ctcpTourNur_"^"_ctcpDr
	..i (arrNurDoc="N")&(nurCat="X") d
	...i ctcpTourNurJ="" s ctcpTourNurJ=ctcpDr
	...e  s ctcpTourNurJ=ctcpTourNurJ_"^"_ctcpDr
	
	TSTART
	i (ctcpAnDoc'="")!(ctcpAnNur'="")!(mzsupdoc'="") d
	.&sql(update sqluser.OR_Anaesthesia set ana_anaesthetist_dr=:ctcpAnDoc,ANA_ORAnaNurse_DR=:ctcpAnNur,ANA_Supervisor_DR=:mzsupdoc where ana_rowid=:anaId)
	.i SQLCODE'=0 s retStr="更新麻醉表失败!"
	.i SQLCODE'=0 TROLLBACK

	&sql(update SQLUSER.DHC_AN_OPArrange set OPA_OpRoom_dr=:roomId,OPA_AnDocNote=:anDocNote where opa_rowid=:opId)
	i SQLCODE'=0 s retStr="更新手术间失败!"
	i SQLCODE'=0 TROLLBACK	
	
    s anaopSub=0
    f  s anaopSub=$o(^OR(admId,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
    .q:$p(^OR(admId,"ANA",anaSub,"OP",anaopSub),"^",12)'="M"
	.i ctcpAnDocO'="" d
	..k ^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS")
	..s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",0)=100
    ..f i=1:1:$L(ctcpAnDocO,"^")  d
    ...q:$P(ctcpAnDocO,"^",i)=""
    ...s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",i)=$P(ctcpAnDocO,"^",i)
    .
    .i ctcpAnDocJ'="" d
    ..s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",0)=200
    ..f i=1:1:$L(ctcpAnDocJ,"^")  d
    ...q:$P(ctcpAnDocJ,"^",i)=""
    ...s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"ANASS",20+i)=$P(ctcpAnDocJ,"^",i)
    .
    .i ctcpDevNur'="" d
    ..k ^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN")
    ..s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN",0)=100
    ..f i=1:1:$L(ctcpDevNur,"^") d
    ...q:$P(ctcpDevNur,"^",i)=""
    ...s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN",i)=$P(ctcpDevNur,"^",i)
    .
    .i ctcpDevNurJ'="" d
    ..s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN",0)=200
    ..f i=1:1:$L(ctcpDevNurJ,"^") d
    ...q:$P(ctcpDevNurJ,"^",i)=""
    ...s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"SCN",20+i)=$P(ctcpDevNurJ,"^",i)
    .
    .i ctcpTourNur'="" d
    ..k ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN")
    ..s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN",0)=100
    ..f i=1:1:$L(ctcpTourNur,"^") d
    ...q:$P(ctcpTourNur,"^",i)=""
    ...s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN",i)=$P(ctcpTourNur,"^",i)
    .
    .i ctcpTourNurJ'="" d
    ..s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN",0)=200
    ..f i=1:1:$L(ctcpTourNurJ,"^") d
    ...q:$P(ctcpTourNurJ,"^",i)=""
    ...s ^OR(admId,"ANA",anaSub,"OP",anaopSub,"CIRN",20+i)=$P(ctcpTourNurJ,"^",i)

	i retStr="" TCOMMIT
	q retStr
	
ERRORUpdateANOpArr1
	TROLLBACK
	q "-1"
}

/// 判断麻醉师,护士是否可以排班
/// w ##class(web.DHCANArrange).GetCtcpFlag("3832","")
ClassMethod GetCtcpFlag(ctcpId As %Library.String = "", nowDate As %String = "")
{
	s retStr3=0
	q:ctcpId="" retStr3
	s ctcpTrvTp=..GetCtcpCat(ctcpId)
	q:ctcpTrvTp="" retStr3
	i nowDate'="" s nowDate=nowDate
	e  s nowDate=+$H
	s maxNum=0
	i ctcpTrvTp="D" d
	.s roomId=""
	.f  s roomId=$O(^DHCANArr(0,"DateCtcp",nowDate,ctcpId,roomId)) q:roomId=""  d
	..s anArrRowId=""
	..f  s anArrRowId=$O(^DHCANArr(0,"DateCtcp",nowDate,ctcpId,roomId,anArrRowId)) q:anArrRowId=""  d
	...s maxNum=maxNum+1
	.i maxNum<3 s retStr3=1
	i ctcpTrvTp="N" d
	.s maxNum=0
	.s roomId=""
	.f  s roomId=$O(^DHCANArr(0,"DateCtcp",nowDate,ctcpId,roomId)) q:roomId=""  d
	..s anArrRowId=""
	..f  s anArrRowId=$O(^DHCANArr(0,"DateCtcp",nowDate,ctcpId,roomId,anArrRowId)) q:anArrRowId=""  d
	...s maxNum=maxNum+1
	.i maxNum<1 s retStr3=1
	q retStr3
}

/// 取得医护人员类别 护士  N  医生 D
ClassMethod GetCtcpCat(ctcpId As %Library.String = "")
{
	s retStr2=""
	q:ctcpId="" retStr2
	s ctcpTrvTpDr=$P($G(^CTPCP(ctcpId,1)),"^",4)
	q:ctcpTrvTpDr="" retStr2
	s ctcpTrvTp=$P($G(^CT("CPT",ctcpTrvTpDr)),"^",4)
	i ctcpTrvTp="DOCTOR"  s retStr2="D"
	i ctcpTrvTp="NURSE"  s retStr2="N"
	q retStr2
}

/// 取得医护人员信息  姓名!DR
ClassMethod GetCtcpInfo(ctcpId As %Library.String = "")
{
	s retStr1="!"
	q:ctcpId="" retStr1
	;s ctcpDesc=$P($G(^CTPCP(ctcpId,1)),"^",2)
	s ctcpDesc=##class(web.DHCANOPCom).GetNameById(ctcpId)
	q:ctcpDesc="" retStr1
	s retStr1=ctcpDesc_"!"_ctcpId
	q retStr1
}

/// 麻醉科护士
Query AnNurse() As %Query(ROWSPEC = "ctcpDesc,ctcpDr")
{
}

ClassMethod AnNurseExecute(ByRef qHandle As %Binary) As %Status
{
	 Set repid=$I(^CacheTemp)
     If $g(ind)="" Set ind=1
	 s num=$L($G(^DHCANOPSET("anloc")),"^")
	 f i=1:1:num d
	 .s str=$P(^DHCANOPSET("anloc"),"^",i)
	 .s id=$P(str,"|")
	 .s ctLoc(id)=""
	 s loc="" f  s loc=$O(ctLoc(loc)) q:loc=""  d
	 .s rw="" f  s rw=$O(^RB("RES",0,"CTLOC",loc,rw)) q:rw=""  d
	 ..s ctcpDr=$P(^RB("RES",rw),"^",2)
	 ..q:ctcpDr=""
	 ..q:(..GetCtcpCat(ctcpDr)'="N")!(..GetCtcpFlag(ctcpDr)'=1)
	 ..s ctcpDesc=$p(^CTPCP(ctcpDr,1),"^",2)
     ..Do OutputAnNurse	
     Set qHandle=$lb(0,repid,0)
	 Quit $$$OK
OutputAnNurse
	set Data=$lb(ctcpDesc,ctcpDr)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod AnNurseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AnNurseExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
 Set AtEnd=1
 Set Row=""
 }
 Else  {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod AnNurseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AnNurseExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// 麻醉科医生
Query AnDoc(desc As %String) As %Query(ROWSPEC = "ctcpDesc,ctcpDr")
{
}

ClassMethod AnDocExecute(ByRef qHandle As %Binary, desc As %String = "") As %Status
{
	 Set repid=$I(^CacheTemp)
     If $g(ind)="" Set ind=1
     s desc=$$ALPHAUP^SSUTIL4(desc)
     ;s ctcpDrStr="",ctcpDescStr=""
	 s num=$L($G(^DHCANOPSET("anloc")),"^")
	 f i=1:1:num d
	 .s str=$P(^DHCANOPSET("anloc"),"^",i)
	 .s id=$P(str,"|")
	 .s ctLoc(id)=""
	 s loc="" f  s loc=$O(ctLoc(loc)) q:loc=""  d
	 .s rw="" f  s rw=$O(^RB("RES",0,"CTLOC",loc,rw)) q:rw=""  d
	 ..s ctcpDr=$P(^RB("RES",rw),"^",2)
	 ..q:ctcpDr=""
	 ..;q:(..GetCtcpCat(ctcpDr)'="D")!(..GetCtcpFlag(ctcpDr)'=1)
	 ..;s ctcpAlias=$p(^CTPCP(ctcpDr,1),"^",1)
	 ..s ctcpAlias=$p(^CTPCP(ctcpDr,3),"^",28)
	 ..q:($p(ctcpAlias,desc)'="")&(desc'="")
	 ..s ctcpDesc=$p($p(^CTPCP(ctcpDr,1),"^",2),"-",1)
	 ..;q:($p(ctcpDesc,desc)'="")&(desc'="")
     ..Do OutputAnDoc
     .s clcpRowId="" f  s clcpRowId=$o(^DHCCLCPI("CtLoc",loc,clcpRowId)) q:clcpRowId=""  d
     ..s ctcpDr="~"_clcpRowId
     ..s ctcpDesc=$li($g(^DHCCLCP(clcpRowId)),2)
     ..s ctcpAlias=$li($g(^DHCCLCP(clcpRowId)),3)
     ..q:ctcpAlias=""
     ..q:($p(ctcpAlias,desc)'="")&(desc'="")
     ..;q:($p(ctcpDesc,desc)'="")&(desc'="")
     ..Do OutputAnDoc	
     Set qHandle=$lb(0,repid,0)
	 Quit $$$OK
OutputAnDoc
	set Data=$lb(ctcpDesc,ctcpDr)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod AnDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AnDocExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
 Set AtEnd=1
 Set Row=""
 }
 Else  {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod AnDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AnDocExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCANArrange","OpNurse","h","26/05/2010")
/// 手术室护士
Query OpNurse(nurseDesc As %String, opdate As %String) As %Query(ROWSPEC = "姓名,ID,班次,日期,工作")
{
}

ClassMethod OpNurseExecute(ByRef qHandle As %Binary, nurseDesc As %String, opdate As %String) As %Status
{
	 Set repid=$I(^CacheTemp)
     If $g(ind)="" Set ind=1
     s nurseDesc=$$ALPHAUP^SSUTIL4(nurseDesc)
     k ^OpNurseTemp
     i opdate'="" s opdate=$zdh(opdate,4)
     e  s opdate=+$h
     s ctcpDrStr="",ctcpDescStr=""
	 s num=$L($G(^DHCANOPSET("oploc")),"^")
	 f i=1:1:num d
	 .s str=$P(^DHCANOPSET("oploc"),"^",i)
	 .s id=$P(str,"|")
	 .s ctLoc(id)=""
	 s loc="" f  s loc=$O(ctLoc(loc)) q:loc=""  d
	 .s rw="" f  s rw=$O(^RB("RES",0,"CTLOC",loc,rw)) q:rw=""  d
	 ..s ctcpDr=$P(^RB("RES",rw),"^",2)
	 ..q:ctcpDr=""
	 ..s ctcpType=..GetCtcpCat(ctcpDr)
	 ..q:(ctcpType'="N")
	 ..;q:(..GetCtcpFlag(ctcpDr,opdate)'=1)
	 ..s ctcpDesc=$p($g(^CTPCP(ctcpDr,1)),"^",2)
	 ..;s ctcpCode=$p($g(^CTPCP(ctcpDr,1)),"^",1)
	 ..s ctcpCode=$p($g(^CTPCP(ctcpDr,3)),"^",28)
	 ..q:(($p(ctcpCode,nurseDesc)'="")&(nurseDesc'=""))
	 ..i ctcpDrStr="" s ctcpDrStr=ctcpDr
	 ..e  s ctcpDrStr=ctcpDrStr_"^"_ctcpDr
	 ..i ctcpDescStr="" s ctcpDescStr=ctcpDesc
	 ..e  s ctcpDescStr=ctcpDescStr_"^"_ctcpDesc
	 .s clcpRowId="" f  s clcpRowId=$o(^DHCCLCPI("CtLoc",loc,clcpRowId)) q:clcpRowId=""  d
     ..s ctcpDr="~"_clcpRowId
     ..s ctcpDesc=$li($g(^DHCCLCP(clcpRowId)),2)
     ..s ctcpAlias=$li($g(^DHCCLCP(clcpRowId)),3)
     ..q:ctcpAlias=""
     ..q:($p(ctcpAlias,nurseDesc)'="")&(nurseDesc'="")
	 ..i ctcpDrStr="" s ctcpDrStr=ctcpDr
	 ..e  s ctcpDrStr=ctcpDrStr_"^"_ctcpDr
	 ..i ctcpDescStr="" s ctcpDescStr=ctcpDesc
	 ..e  s ctcpDescStr=ctcpDescStr_"^"_ctcpDesc
	 
	 f j=1:1:$l(ctcpDrStr,"^") d
	 .s ctcpDr=$p(ctcpDrStr,"^",j)
	 .s ctcpDesc=$p(ctcpDescStr,"^",j)
	 .s DPArrangeId="",ARRPerDR="",retARRPerDR="",retDate="",ARRPostDRDesc="白班"
     .f  s DPArrangeId=$o(^User.DHCMGPersonArrangeD(DPArrangeId)) q:DPArrangeId=""  d
     ..s ARRPerDR=$li(^User.DHCMGPersonArrangeD(DPArrangeId),5)
     ..s ARRPerDRDate=$li(^User.DHCMGPersonArrangeD(DPArrangeId),2)
     ..;i ARRPerDR'=ctcpDr s retARRPerDR="0"
     ..;e  s retARRPerDR="1"
     ..;i ARRPerDRDate'=opdate s retDate="0"
     ..;e  s retDate="1"
     ..i (ARRPerDR=ctcpDr)&(ARRPerDRDate=opdate) d
     ...s ARRPostDR=$li(^User.DHCMGPersonArrangeD(DPArrangeId),6) 
     ...i ARRPostDR="N" s ARRPostDRDesc="夜班"
     ...e  s ARRPostDRDesc="休假"
     .s arrWork=..GetNurseArr(opdate,ctcpDr)
     .s ^OpNurseTemp($J,opdate,ARRPostDRDesc,ctcpDr,j)=$lb(ctcpDesc,ctcpDr,ARRPostDRDesc,$zd(opdate,4),arrWork)
     
     s postDesc=""
     f  s postDesc=$O(^OpNurseTemp($J,opdate,postDesc),-1) q:postDesc=""  d
	 .s ctcp=""
	 .f  s ctcp=$O(^OpNurseTemp($J,opdate,postDesc,ctcp)) q:ctcp=""  d
	 ..s j=""
	 ..f  s j=$O(^OpNurseTemp($J,opdate,postDesc,ctcp,j)) q:j=""  d
     ...Do OutputOpNurse	
     Set qHandle=$lb(0,repid,0)
	 Quit $$$OK
OutputOpNurse
	;set Data=$lb(ctcpDesc,ctcpDr,ARRPostDRDesc)
	set Data=^OpNurseTemp($J,opdate,postDesc,ctcp,j)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod OpNurseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OpNurseExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
 Set AtEnd=1
 Set Row=""
 }
 Else  {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod OpNurseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OpNurseExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCANArrange","IsUseOperRoom","")
/// 通过ctlocId查找有手术预约的手术间
Query IsUseOperRoom(ctlocId As %Library.String) As %Query(ROWSPEC = "roomCode,roomDesc,roomId,roomFloor")
{
}

ClassMethod IsUseOperRoomExecute(ByRef qHandle As %Binary, ctlocId As %Library.String) As %Status
{
	 Set repid=$I(^CacheTemp)
	 If $g(ind)="" Set ind=1
	 ;i ctlocId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	 s roomId=""
	 f  s roomId=$O(^DHCANC("OPRoom",roomId)) q:roomId=""  d
		 .q:roomId=0
		 .s roomDesc=$P($G(^DHCANC("OPRoom",roomId)),"^",2)
		 .s roomCode=$P($G(^DHCANC("OPRoom",roomId)),"^",1)
		 .s room=roomCode
		 .q:(room'="")&($P(roomDesc,room)'="")
		 .s oprCtlocDr=$p($g(^DHCANC("OPRoom",roomId)),"^",3)
		 .;q:((oprCtlocDr'=ctlocId)&(ctlocId'=52))
		 .s roomFloor=""
		 .s floorId=$P($G(^DHCANC("OPRoom",roomId)),"^",4)
		 .i floorId'="" s roomFloor=$P($G(^DHCANC("Floor",floorId)),"^",2)
		 .d OutputOpRoom
	 
     Set qHandle=$lb(0,repid,0)
	 Quit $$$OK
OutputOpRoom
	set Data=$lb(roomCode,roomDesc,roomId,roomFloor)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod IsUseOperRoomFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IsUseOperRoomExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
 Set AtEnd=1
 Set Row=""
 }
 Else  {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod IsUseOperRoomClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IsUseOperRoomExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// 通过ID和date获取手术间详细信息
/// d ##class(%ResultSet).RunQuery("web.DHCANArrange","GetOperRoomInfo","","61861","","311")
Query GetOperRoomInfo(room As %Library.String = "", opdate As %Library.String = "", oprFloor As %String = "", ctlocId As %String) As %Query(ROWSPEC = "OPRoomCode,OPRoomDesc,OPRoomId,OPRoomFloor,OPRoomDate,docStat,nurStat")
{
}

ClassMethod GetOperRoomInfoExecute(ByRef qHandle As %Binary, room As %Library.String = "", opdate As %Library.String = "", oprFloor As %String = "", ctlocId As %String) As %Status
{
	 Set repid=$I(^CacheTemp)
     If $g(ind)="" Set ind=1
 	 
 	 //OPA_NeedAnaesthetist  44
 	 
     s OPRoomCode="",OPRoomDesc="",OPRoomId="",OPRoomFloor="",OPRoomDate="",docStat="",nurStat="",arrNurDoc="",statCount=""
	 i opdate'="" s date=opdate
	 e  s date=+$H
	 s OPRoomDate=$zd(date,4)
	 s opaId=""
	 f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
	 .s OPRStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
	 .q:OPRStatus'="R"
	 .s OPRoomDr=$P($G(^DHCANOPArrange(opaId)),"^",20)
	 .q:OPRoomDr=""
	 .s NeedAnaesthetist=$P($G(^DHCANOPArrange(opaId)),"^",44)
	 .;q:NeedAnaesthetist'="Y"
	 .s OPRCtlocDr=$p($g(^DHCANC("OPRoom",OPRoomDr)),"^",3)
	 .q:((OPRCtlocDr'=ctlocId)&(ctlocId'=52)) //麻醉科ID为52

	 .s adm=$P(^DHCANOPArrange(opaId),"^",1)
	 .s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	 .s mzdr="",mzsupdr="",mzassdr="",xshdr="",xchdr="",docFlagStr="",nurFlagStr="",docFlag=0,nurFlag=0
	 
	 .s mzdr=$P(^OR(adm,"ANA",chl),"^",6)
	 .s mzsupdr=$P(^OR(adm,"ANA",chl),"^",7)
	 .s ass=0 f  s ass=$o(^OR(adm,"ANA",chl,"OP",1,"ANASS",ass)) q:ass=""  d
	 ..s mzzsdr=$p($g(^OR(adm,"ANA",chl,"OP",1,"ANASS",ass)),"^",1)
	 ..i mzassdr="" s mzassdr=mzzsdr
	 ..e  s mzassdr=mzassdr_"^"_mzzsdr
	 .i (mzdr'="")!(mzsupdr'="")!(mzassdr'="") s docStat="Y" ;,docFlag="1"
	 .e  s docStat="" ;,docFlag="0"
	 
	 .s sub=0 f  s sub=$O(^OR(adm,"ANA",chl,"OP",sub)) q:sub=""  d
	 ..s xs=0 f  s xs=$O(^OR(adm,"ANA",chl,"OP",sub,"SCN",xs)) q:xs=""  d
	 ...s xsdr=$P(^OR(adm,"ANA",chl,"OP",sub,"SCN",xs),"^",1)
	 ...i xshdr="" s xshdr=xsdr
	 ...e  s xshdr=xshdr_"^"_xsdr
	 ..s xc=0 f  s xc=$O(^OR(adm,"ANA",chl,"OP",sub,"CIRN",xc)) q:xc=""  d
	 ...s xcdr=$P(^OR(adm,"ANA",chl,"OP",sub,"CIRN",xc),"^",1)
	 ...i xchdr="" s xchdr=xcdr
	 ...e  s xchdr=xchdr_"^"_xcdr
	 .i (xshdr'="")!(xchdr'="") s nurStat="Y" ;,nurFlag="1"
	 .e  s nurStat="" ;,nurFlag="0"
	 .;s ^TmpRoomList(OPRoomDr,opaId)=docFlag_"|"_nurFlag
	 .s ^TmpOperRoom("OPRoomId",OPRoomDr)=OPRoomDr_"^"_docStat_"^"_nurStat	
	 /*
	 s roomId="" f  s roomId=$o(^TmpRoomList(roomId)) q:roomId=""  d
	 .s opId="" f  s opId=$o(^TmpRoomList(roomId,opId)) q:opId=""  d
	 ..i docFlagStr="" s docFlagStr=$p(^TmpRoomList(roomId,opId),"|",1)
	 ..e  s docFlagStr=docFlagStr_"^"_$p(^TmpRoomList(roomId,opId),"|",1)
	 ..i nurFlagStr="" s nurFlagStr=$p(^TmpRoomList(roomId,opId),"|",2)
	 ..e  s nurFlagStr=nurFlagStr_"^"_$p(^TmpRoomList(roomId,opId),"|",2)
	 
	 .i docFlagStr'["0" s docStat="Y"
	 .e  s docStat=""
	 .i nurFlagStr'["0" s nurStat="Y"
	 .e  s nurStat=""
	 .s ^TmpOperRoom("OPRoomId",roomId)=roomId_"^"_docStat_"^"_nurStat
	 .;s ^TmpOperRoom("OPRoomId",OPRoomDr)=OPRoomDr_"^"_docStat_"^"_nurStat
	 */
	 s OPRoomId=""
	 f  s OPRoomId=$O(^TmpOperRoom("OPRoomId",OPRoomId)) q:OPRoomId=""  d   ///判断同一个手术间有几台手术
	 .s OPRoomCode=$P($G(^DHCANC("OPRoom",OPRoomId)),"^",1)
	 .s OPRoomDesc=$P($G(^DHCANC("OPRoom",OPRoomId)),"^",2)
	 .s docStat=$p(^TmpOperRoom("OPRoomId",OPRoomId),"^",2)
	 .s nurStat=$p(^TmpOperRoom("OPRoomId",OPRoomId),"^",3)
	 .q:(room'="")&(room'=OPRoomCode)
	 .i (room="")!(room=OPRoomCode) d
	 ..s floorId=$P($G(^DHCANC("OPRoom",OPRoomId)),"^",4)
	 ..i floorId'="" s OPRoomFloor=$P($G(^DHCANC("Floor",floorId)),"^",2)
	 ..q:(OPRoomFloor'=oprFloor)&(oprFloor'="")
	 ..k ^TmpOperRoom("OPRoomId",OPRoomId)
	 ..d OutPutOPInfo
     Set qHandle=$lb(0,repid,0)
	 Quit $$$OK

OutPutOPInfo
	set Data=$lb(OPRoomCode,OPRoomDesc,OPRoomId,OPRoomFloor,OPRoomDate,docStat,nurStat)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOperRoomInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperRoomInfoExecute ]
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

ClassMethod GetOperRoomInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperRoomInfoExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// 判断手术间是否有手术申请
/// w ##class(web.DHCANArrange).GetOperRoomStat(1)
ClassMethod GetOperRoomStat(room As %Library.String = "", opdate As %Library.String)
{
	s retFlag=0
	q:room="" retFlag
	;s opDate=+$H
	;s date=opDate
	s opaId=""
	f  s opaId=$O(^DHCANOPArrange(0,"SDate",opdate,opaId)) q:(opaId="")!(retFlag=1)  d
	.s opRoomId=$P($G(^DHCANOPArrange(opaId)),"^",20)
	.q:opRoomId=""
	.i room=opRoomId s retFlag=1
	q retFlag
}

/// 更新所有手术申请的麻醉和手术室安排
ClassMethod UpdateAllOpArr(roomId As %Library.String = "", opId As %String = "", opdate As %String = "")
{
	;w ##class(web.DHCANArrange).UpdateAllOpArr("4","560^561","25/03/2010")
	s retStr=""
	q:roomId="" "手术间不能为空!"
	s opdate=$ZDH(opdate,4)
	f arrNum=1:1:$L(opId,"^") d
	.s opaId=$p(opId,"^",arrNum)
	.s retStr1=..UpdateANOpArr(roomId,opaId,opdate,"N")
	q retStr1
}

/// 计算手术开始时间结束时间
/// w ##class(web.DHCANArrange).GetArrangeTime("1^2^3","28^29^30")
ClassMethod GetArrangeTime(rowIdStr As %Library.String = "", opaIdStr As %Library.String = "")
{
	s retStr="",retValue=""
	k DHCANARR,DHCANARRTIME
	q:rowIdStr="" retStr
	q:opaIdStr="" "手术申请不存在!"
	s strLen=$L(opaIdStr,"^")
	f i=1:1:strLen d
	.s rowId=$P(rowIdStr,"^",i)
	.q:rowId=""
	.s opaId=$P(opaIdStr,"^",i)
	.q:opaId=""
	.s roomId=$P(^DHCANOPArrange(opaId),"^",20)
	.q:roomId=""
	.s seqNo=$P(^DHCANOPArrange(opaId),"^",26)
	.q:seqNo=""
	.s opStDate=$P(^DHCANOPArrange(opaId),"^",14)
	.q:(opStDate="")!(opStDate=0)
	.s opEstiTime=$P(^DHCANOPArrange(opaId),"^",37)
	.q:(opEstiTime=0)!(opEstiTime="")
	.s DHCANARR(roomId,seqNo)=rowId_"^"_opaId_"^"_opStDate_"^"_opEstiTime
	s roomId=""
	f  s roomId=$O(DHCANARR(roomId)) q:(roomId=0)!(roomId="")  d
	.s seqNo=""
	.s index=1
	.f  s seqNo=$O(DHCANARR(roomId,seqNo)) q:(seqNo=0)!(seqNo="")  d
	..s opEstiTime=$P(DHCANARR(roomId,seqNo),"^",4)
	..s opStDate=$P(DHCANARR(roomId,seqNo),"^",3)
	..i index=1 d
	...s opStTime=$ZTH("8:00")
	...s opEndDate=$P(DHCANARR(roomId,seqNo),"^",3)
	...s opEndTime=$ZTH("8:00")+opEstiTime
	..e  d
	...s seqNo1=$O(DHCANARR(roomId,seqNo),-1)
	...s opStTime=$ZTH("0:20")+$P(DHCANARRTIME(roomId,seqNo1),"^",7)
	...s opStDate=$P(DHCANARRTIME(roomId,seqNo1),"^",6)
	...s opEndTime=opStTime+opEstiTime
	...i opEndTime>86400 d
	....s opEndDate=opStDate+1
	....s opEndTime=opEndTime-86400
	...e  s opEndDate=opStDate
	..s rowId=$P(DHCANARR(roomId,seqNo),"^",1)
	..s opaId=$P(DHCANARR(roomId,seqNo),"^",2)
	..s DHCANARRTIME(roomId,seqNo)=rowId_"^"_opaId_"^"_opStDate_"^"_opStTime_"^"_opEstiTime_"^"_opEndDate_"^"_opEndTime
	..s index=index+1
	..i opStDate=opEndDate s strTime=$ZD(opStDate,4)_" "_$ZT(opStTime,2)_"~"_$ZT(opEndTime,2)
	..e  s strTime=$ZD(opStDate,4)_" "_$ZT(opStTime,2)_"~"_$ZD(opEndDate,4)_" "_$ZT(opEndTime,2)
	..i retValue="" s retValue="SetTableElementValue('opdatestrz"_rowId_"','"_strTime_"');"
	..e  s retValue=retValue_"SetTableElementValue('opdatestrz"_rowId_"','"_strTime_"');"
	&javascript<#(retValue)#>
	q retStr
}

/// 更新手术时间
ClassMethod UpdateArrangeTime(rowIdStr As %Library.String = "", opaIdStr As %Library.String = "")
{
	s retStr="",retValue=""
	s $zt="ERRORUpdateArrangeTime"
	k DHCANARR,DHCANARRTIME
	q:rowIdStr="" retStr
	q:opaIdStr="" "手术申请不存在!"
	TSTART
	s strLen=$L(opaIdStr,"^")
	f i=1:1:strLen d
	.s rowId=$P(rowIdStr,"^",i)
	.q:rowId=""
	.s opaId=$P(opaIdStr,"^",i)
	.q:opaId=""
	.s roomId=$P(^DHCANOPArrange(opaId),"^",20)
	.q:roomId=""
	.s seqNo=$P(^DHCANOPArrange(opaId),"^",26)
	.q:seqNo=""
	.s opStDate=$P(^DHCANOPArrange(opaId),"^",14)
	.q:(opStDate="")!(opStDate=0)
	.s opEstiTime=$P(^DHCANOPArrange(opaId),"^",37)
	.q:(opEstiTime=0)!(opEstiTime="")
	.s DHCANARR(roomId,seqNo)=rowId_"^"_opaId_"^"_opStDate_"^"_opEstiTime
	s roomId=""
	f  s roomId=$O(DHCANARR(roomId)) q:(roomId=0)!(roomId="")  d
	.s seqNo=""
	.s index=1
	.f  s seqNo=$O(DHCANARR(roomId,seqNo)) q:(seqNo=0)!(seqNo="")  d
	..s opEstiTime=$P(DHCANARR(roomId,seqNo),"^",4)
	..s opStDate=$P(DHCANARR(roomId,seqNo),"^",3)
	..i index=1 d
	...s opStTime=$ZTH("8:00")
	...s opEndDate=$P(DHCANARR(roomId,seqNo),"^",3)
	...s opEndTime=$ZTH("8:00")+opEstiTime
	..e  d
	...s seqNo1=$O(DHCANARR(roomId,seqNo),-1)
	...s opStTime=$ZTH("0:20")+$P(DHCANARRTIME(roomId,seqNo1),"^",7)
	...s opStDate=$P(DHCANARRTIME(roomId,seqNo1),"^",6)
	...s opEndTime=opStTime+opEstiTime
	...i opEndTime>86400 d
	....s opEndDate=opStDate+1
	....s opEndTime=opEndTime-86400
	...e  s opEndDate=opStDate
	..s rowId=$P(DHCANARR(roomId,seqNo),"^",1)
	..s opaId=$P(DHCANARR(roomId,seqNo),"^",2)
	..s DHCANARRTIME(roomId,seqNo)=rowId_"^"_opaId_"^"_opStDate_"^"_opStTime_"^"_opEstiTime_"^"_opEndDate_"^"_opEndTime
	..s index=index+1
	..&sql(update SQLUSER.DHC_AN_OPArrange set 

OPA_StartDate=:opStDate,OPA_StartTime=:opStTime,OPA_EndDate=:opEndDate,OPA_EndTime=:opEndTime where opa_rowid=:opaId)
	..i SQLCODE'=0 s retStr="更新失败!"
	..i SQLCODE'=0 TROLLBACK
	TCOMMIT
	q retStr
	
ERRORUpdateArrangeTime
	TROLLBACK
	q "-1"
}

ClassMethod SetPermissions()
{
	s userId=%session.Data("LOGON.USERID")
	s careProvDr=$P($G(^SSU("SSUSR",userId)),"^",14)
	q:careProvDr=""
	s carProvTypeDr=$P($G(^CTPCP(careProvDr,1)),"^",4)
	q:carProvTypeDr="" ""
	s type=$P($G(^CT("CPT",carProvTypeDr)),"^",4)
	q:type=""
	&SQL(select ID into :componentId from websys.Component where Name='DHCANOPArrangeDetail')
	i (componentId'="")&(type="DOCTOR") d
	.s retVal="DisableById('"_$ZCVT(componentId,"O","JS")_"','devNur');"
	.s retVal=retVal_"DisableById('"_$ZCVT(componentId,"O","JS")_"','ctcpDevNur');"
	.s retVal=retVal_"DisableById('"_$ZCVT(componentId,"O","JS")_"','devNurJ');"
	.s retVal=retVal_"DisableById('"_$ZCVT(componentId,"O","JS")_"','ctcpDevNurJ');"
	.s retVal=retVal_"DisableById('"_$ZCVT(componentId,"O","JS")_"','tourNur');"
	.s retVal=retVal_"DisableById('"_$ZCVT(componentId,"O","JS")_"','ctcpTourNur');"
	.s retVal=retVal_"DisableById('"_$ZCVT(componentId,"O","JS")_"','tourNurJ');"
	.s retVal=retVal_"DisableById('"_$ZCVT(componentId,"O","JS")_"','ctcpTourNurJ');"
	
	i (componentId'="")&(type="NURSE") d
	.s retVal="DisableById('"_$ZCVT(componentId,"O","JS")_"','anDoc');"
	.s retVal=retVal_"DisableById('"_$ZCVT(componentId,"O","JS")_"','anNur');"
	.s retVal=retVal_"DisableById('"_$ZCVT(componentId,"O","JS")_"','anDocO');"
	.s retVal=retVal_"DisableById('"_$ZCVT(componentId,"O","JS")_"','ctcpAnDocO');"
	.s retVal=retVal_"DisableById('"_$ZCVT(componentId,"O","JS")_"','anDocJ');"
	.s retVal=retVal_"DisableById('"_$ZCVT(componentId,"O","JS")_"','ctcpAnDocJ');"
	.s retVal=retVal_"DisableById('"_$ZCVT(componentId,"O","JS")_"','anDocNote');"
	.s retVal=retVal_"DisableById('"_$ZCVT(componentId,"O","JS")_"','anNur1');"   //ck 091013
	.s retVal=retVal_"DisableById('"_$ZCVT(componentId,"O","JS")_"','ansupervisor');"

    &javascript<#(retVal)#>
    q
}

/// 排班详细信息
Query FindArrangeDatail(roomId As %Library.String, arrDate As %Library.String, careProvDr As %Library.String) As %Query(ROWSPEC = "roomDesc,roomFloor,ctcpAnDoc,anDocNote,ctcpAnDocO,ctcpAnDocJ,ctcpAnNur,ctcpDevNur,ctcpDevNurJ,ctcpTourNur,ctcpTourNurJ,ctcpDesc")
{
}

ClassMethod FindArrangeDatailExecute(ByRef qHandle As %Binary, roomId As %Library.String = "", arrDate As %Library.String = "", careProvDr As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i arrDate="" s arrDate=+$H

	//i (roomId'="")&($G(^DHCANC("OPRoom",roomId))="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
	//i (careProvDr'="")&($G(^CTPCP(careProvDr,1))="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
	 //ypz 090224 begin
	k ctcpData
	//^DHCANOPSET("oploc")手术科室
	s num=$L($G(^DHCANOPSET("oploc")),"^")
	 f i=1:1:num d
	 .s str=$P(^DHCANOPSET("oploc"),"^",i)
	 .s id=$P(str,"|")
	 .s ctLoc(id)="" //初始化ctLoc数组
	 //第一层循环获取手术室科室对应的资源id--rw，
	 //第二层循环获取资源中对应科室中的人员id，
	 //只取护士的名字（trackcare中医护人员不会重名)
	 s loc="" f  s loc=$O(ctLoc(loc)) q:loc=""  d
	 .s rw="" f  s rw=$O(^RB("RES",0,"CTLOC",loc,rw)) q:rw=""  d
	 ..s ctcpDr=$P(^RB("RES",rw),"^",2)
	 ..q:ctcpDr=""
	 ..s ctcpType=..GetCtcpCat(ctcpDr)
	 ..q:(ctcpType'="N")
	 ..//q:(..GetCtcpFlag(ctcpDr)'=1)
	 ..;s ctcpDesc=$p(^CTPCP(ctcpDr,1),"^",2)
	 ..s ctcpDesc=##class(web.DHCANOPCom).GetNameById(ctcpDr)
	 ..s ctcpData(ctcpDesc)="^^^^^^^^^"
	 //第一层循环获取麻醉室科室对应的资源id--rw，
	 //第二层循环获取资源中对应科室中的人员id，
	 //只取护士的名字（trackcare中医护人员不会重名）
	 s num=$L($G(^DHCANOPSET("anloc")),"^")
	 f i=1:1:num d
	 .s str=$P(^DHCANOPSET("anloc"),"^",i)
	 .s id=$P(str,"|")
	 .s ctLoc(id)=""
	 s loc="" f  s loc=$O(ctLoc(loc)) q:loc=""  d
	 .s rw="" f  s rw=$O(^RB("RES",0,"CTLOC",loc,rw)) q:rw=""  d
	 ..s ctcpDr=$P(^RB("RES",rw),"^",2)
	 ..q:ctcpDr=""
	 ..q:(..GetCtcpCat(ctcpDr)'="D") //!(..GetCtcpFlag(ctcpDr)'=1)
	 ..;s ctcpDesc=$p(^CTPCP(ctcpDr,1),"^",2)
	 ..s ctcpDesc=##class(web.DHCANOPCom).GetNameById(ctcpDr)
	..s ctcpData(ctcpDesc)="^^^^^^^^^^"
	//ypz 090224 end
	
	i roomId'="" d
	.d GetArrangeDetail
	e  d
	.f  s roomId=$O(^DHCANArr(0,"DateRoom",arrDate,roomId)) q:roomId=""  d
	..d GetArrangeDetail
	
	//ypz 090225 begin
	//排序
	s ctcpDescRoomDesc=""
        f  s ctcpDescRoomDesc=$o(ctcpData(ctcpDescRoomDesc)) q:ctcpDescRoomDesc=""  d
	.s ctcpDesc=$p(ctcpDescRoomDesc,"^",1)
	.s roomDesc=$p(ctcpData(ctcpDescRoomDesc),"^",1)
	.s roomFloor=$p(ctcpData(ctcpDescRoomDesc),"^",2)
	.s ctcpAnDoc=$p(ctcpData(ctcpDescRoomDesc),"^",3)
	.s anDocNote=$p(ctcpData(ctcpDescRoomDesc),"^",4)
	.s ctcpAnDocO=$p(ctcpData(ctcpDescRoomDesc),"^",5)
	.s ctcpAnDocJ=$p(ctcpData(ctcpDescRoomDesc),"^",6)
	.s ctcpAnNur=$p(ctcpData(ctcpDescRoomDesc),"^",7)
	.s ctcpDevNur=$p(ctcpData(ctcpDescRoomDesc),"^",8)
	.s ctcpDevNurJ=$p(ctcpData(ctcpDescRoomDesc),"^",9)
	.s ctcpTourNur=$p(ctcpData(ctcpDescRoomDesc),"^",10)
	.s ctcpTourNurJ=$p(ctcpData(ctcpDescRoomDesc),"^",11)
	.d OutputArrange
	//ypz 090225 end
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputArrange
	set Data=$lb(roomDesc,roomFloor,ctcpAnDoc,anDocNote,ctcpAnDocO,ctcpAnDocJ,ctcpAnNur,ctcpDevNur,ctcpDevNurJ,ctcpTourNur,ctcpTourNurJ,ctcpDesc) //ypz 090224
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit

GetArrangeDetail
	s (roomDesc,roomFloor,ctcpAnDoc,anDocNote,ctcpAnDocO,ctcpAnDocJ,ctcpAnNur,ctcpDevNur,ctcpDevNurJ,ctcpTourNur,ctcpTourNurJ)=""
	//取房间、楼层信息
	s roomDesc=$P($G(^DHCANC("OPRoom",roomId)),"^",2)
	s roomFloor=""
	s floorId=$P($G(^DHCANC("OPRoom",roomId)),"^",4)
	i floorId'="" s roomFloor=$P($G(^DHCANC("Floor",floorId)),"^",2)
	s isCare=0
	s ctcpDr=""
	//循环排班工作表
	f  s ctcpDr=$O(^DHCANArr(0,"DateRoom",arrDate,roomId,ctcpDr)) q:ctcpDr=""  d
	.s anArrRowId=""
	.i (careProvDr'="")&(ctcpDr=careProvDr) s isCare=1
	.q:(careProvDr'="")&(isCare'=1) //ypz 090224
	.//循环排班工作表，查找排班信息
	.f  s anArrRowId=$O(^DHCANArr(0,"DateRoom",arrDate,roomId,ctcpDr,anArrRowId)) q:anArrRowId=""  d
	..s (ctcpAnDoc,anDocNote,ctcpAnDocO,ctcpAnDocJ,ctcpAnNur,ctcpDevNur,ctcpDevNurJ,ctcpTourNur,ctcpTourNurJ)="" //ypz
	..s arrNurDoc=$P($G(^DHCANArr(anArrRowId)),"^",6)
	..s docCat=$P($G(^DHCANArr(anArrRowId)),"^",7)
	..s nurCat=$P($G(^DHCANArr(anArrRowId)),"^",8)
	..s arrNote=$P($G(^DHCANArr(anArrRowId)),"^",10)
	..;s cacpDesc=$P($G(^CTPCP(ctcpDr,1)),"^",2)
	..s cacpDesc=##class(web.DHCANOPCom).GetNameById(ctcpDr)
	..i (arrNurDoc="D")&(docCat="A") d
	...s ctcpAnDoc=cacpDesc
	..i arrNote'="" s anDocNote=arrNote
	..i (arrNurDoc="D")&(docCat="O") d
	...i ctcpAnDocO="" s ctcpAnDocO=cacpDesc
	...e  s ctcpAnDocO=ctcpAnDocO_","_cacpDesc
	..i (arrNurDoc="D")&(docCat="J") d
	...i ctcpAnDocJ="" s ctcpAnDocJ=cacpDesc
	...e  s ctcpAnDocJ=ctcpAnDocJ_","_cacpDesc
	..i (arrNurDoc="N")&(nurCat="A") d
	...s ctcpAnNur=cacpDesc
	..i (arrNurDoc="N")&(nurCat="D") d
	...i ctcpDevNur="" s ctcpDevNur=cacpDesc
	...e  s ctcpDevNur=ctcpDevNur_","_cacpDesc
	..i (arrNurDoc="N")&(nurCat="J") d
	...i ctcpDevNurJ="" s ctcpDevNurJ=cacpDesc
	...e  s ctcpDevNurJ=ctcpDevNurJ_","_cacpDesc
	..i (arrNurDoc="N")&(nurCat="T") d
	...i ctcpTourNur="" s ctcpTourNur=cacpDesc
	...e  s ctcpTourNur=ctcpTourNur_","_cacpDesc
	..i (arrNurDoc="N")&(nurCat="X") d
	...i ctcpTourNurJ="" s ctcpTourNurJ=cacpDesc
	...e  s ctcpTourNurJ=ctcpTourNurJ_","_cacpDesc
	..//s ^sjqDebug("sjq",1)=cacpDesc
	..i cacpDesc'="" d //ypz 090225
	...k ctcpData(cacpDesc) //ypz 090225
	...s ctcpData(cacpDesc_"^"_roomDesc)=roomDesc_"^"_roomFloor_"^"_ctcpAnDoc_"^"_anDocNote_"^"_ctcpAnDocO_"^"_ctcpAnDocJ_"^"_ctcpAnNur_"^"_ctcpDevNur_"^"_ctcpDevNurJ_"^"_ctcpTourNur_"^"_ctcpTourNurJ  //ypz 090225
	//i (careProvDr'="")&(isCare=1) d
	//.d OutputArrange
	//i (careProvDr="") d
	//.d OutputArrange
	q
}

ClassMethod FindArrangeDatailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArrangeDatailExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
 Set AtEnd=1
 Set Row=""
 }
 Else  {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindArrangeDatailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArrangeDatailExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// 取得所有 麻醉医师 护士
Query FindAllDocNur(careProv As %Library.String) As %Query(ROWSPEC = "ctcpDesc,ctcpDr")
{
}

ClassMethod FindAllDocNurExecute(ByRef qHandle As %Binary, careProv As %Library.String = "") As %Status
{
	 Set repid=$I(^CacheTemp)
     If $g(ind)="" Set ind=1
	 s num=$L($G(^DHCANOPSET("anloc")),"^")
	 f i=1:1:num d
	 .s str=$P(^DHCANOPSET("anloc"),"^",i)
	 .s id=$P(str,"|")
	 .s ctLoc(id)=""
	 s loc="" f  s loc=$O(ctLoc(loc)) q:loc=""  d
	 .s rw="" f  s rw=$O(^RB("RES",0,"CTLOC",loc,rw)) q:rw=""  d
	 ..s ctcpDr=$P(^RB("RES",rw),"^",2)
	 ..q:ctcpDr=""
	 ..;s ctcpDesc=$p(^CTPCP(ctcpDr,1),"^",2)
	 ..s ctcpDesc=##class(web.DHCANOPCom).GetNameById(ctcpDr)
	 ..q:(careProv'="")&(ctcpDesc'[careProv)
     ..Do OutputCtCp
	 s num=$L($G(^DHCANOPSET("oploc")),"^")
	 f i=1:1:num d
	 .s str=$P(^DHCANOPSET("oploc"),"^",i)
	 .s id=$P(str,"|")
	 .s ctLoc(id)=""
	 s loc="" f  s loc=$O(ctLoc(loc)) q:loc=""  d
	 .s rw="" f  s rw=$O(^RB("RES",0,"CTLOC",loc,rw)) q:rw=""  d
	 ..s ctcpDr=$P(^RB("RES",rw),"^",2)
	 ..q:ctcpDr=""
	 ..s ctcpType=..GetCtcpCat(ctcpDr)
	 ..q:(ctcpType'="N")
	 ..;s ctcpDesc=$p(^CTPCP(ctcpDr,1),"^",2)
	 ..s ctcpDesc=##class(web.DHCANOPCom).GetNameById(ctcpDr)
	 ..q:(careProv'="")&(ctcpDesc'[careProv)
     ..Do OutputOpNurse	
     Set qHandle=$lb(0,repid,0)
	 Quit $$$OK
OutputCtCp
	set Data=$lb(ctcpDesc,ctcpDr)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindAllDocNurFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllDocNurExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
 Set AtEnd=1
 Set Row=""
 }
 Else  {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAllDocNurClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllDocNurExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// 根据出生日计算年龄
ClassMethod CalAge(IBirth As %String, IToday As %String)
{
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$G(IBirth) ""
    s XBirth=$ZD(IBirth)
    s XToday=$ZD(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $P(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
}

/// ck 091120
///  opaId -- RowId
/// opaSeqNote手术申请流水号，OperDate手术日期及时间, OperLoc手术室, OperRoom手术间, OpSeq台次
/// anDoc麻醉医师, anNur麻醉助手, devNur1器械护士1, devNur2器械护士2, tourNur1巡回护士1, tourNur2巡回护士2
/// operAtor处理人, operTime处理时间, opaStatus状态, remark备注
/// opaSeqNote As %String, OperDate As %String, OperLoc As %String, OperRoom As %String, OpSeq As %String, anDoc As %String = "", anNur As %String = "", devNur1 As %String = "", devNur2 As %String = "", tourNur1 As %String = "", tourNur2 As %String = "", operAtor As %String, operTime As %String, opaStatus As %String, remark As %String = ""
ClassMethod OperParameters(opaId As %String, opaRoom As %String = "", opaSeq As %String = "", anDoctor As %String = "", anNurse As %String = "", devNurse1 As %String = "", devNurse2 As %String = "", tourNurse1 As %String = "", tourNurse2 As %String = "", opstTime As %String = "", userId As %String) As %String
{
	q:opaId="" "opaId不能为空！"
	s opaSeqNote="",operDate="",operLoc="",operAtor="",operTime="",opaStatus="",remark="",startTime="",operRoom=""
	s operLocName=""
	;b //114
	i userId'="" s operAtor=$P(^SSU("SSUSR",userId),"^",2)
	e  s operAtor=%session.Data("LOGON.USERNAME")
	;s operAtor="hsz"
	;b //211
	s operTime=$TR($ZD(+$h,3),"-")_$TR($ZT($p($h,",",2)),":")
	s opaSeqNote=$p($g(^DHCANOPArrange(opaId)),"^",41)
	s startDate=$p($g(^DHCANOPArrange(opaId)),"^",14)
	i opstTime="" s startTime=$p($g(^DHCANOPArrange(opaId)),"^",15)
	e  s startTime=opstTime
	s operDate=$TR($ZD(startDate,3),"-")_$TR($ZT(startTime,2),":")
	s oproomDr=$p($g(^DHCANOPArrange(opaId)),"^",20)
	i oproomDr'="" d
	.i opaRoom="" s operRoom=$p(^DHCANC("OPRoom",oproomDr),"^",2)
	.e  s operRoom=opaRoom
	.s operLocDr=$p(^DHCANC("OPRoom",oproomDr),"^",3)
	.i operLocDr'="" d
	..s operLoc=$p($g(^CTLOC(operLocDr)),"^",1)
	..s operLocName=$p($p($g(^CTLOC(operLocDr)),"^",2),"-",2)
	i opaSeq="" s opSeq=$p($g(^DHCANOPArrange(opaId)),"^",26)
	e  s opSeq=opaSeq
	s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
	i opaStatus="D"  d
	.s retReasonId=$p($g(^DHCANOPArrange(opaId)),"^",35)
	.q:retReasonId=""
	.s remark=$p($g(^ORC("SUSP",retReasonId)),"^",2)
	s adm=$P(^DHCANOPArrange(opaId),"^",1)
	q:adm=""
	s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	s mzdr=$P(^OR(adm,"ANA",chl),"^",6)
	i mzdr'="" d
	.;i anDoctor="" s anDoc=$TR($P($G(^CTPCP(mzdr,1)),"^",2)," ","")   //麻醉主治医生
	.i anDoctor="" s anDoc=##class(web.DHCANOPCom).GetNameById(mzdr)
	.e  s anDoc=anDoctor
	e  s anDoc=""

	s mzNurId=$P(^OR(adm,"ANA",chl),"^",8)
	i mzNurId'="" d
	.;i anNurse="" s anNur=$TR($P($G(^CTPCP(mzNurId,1)),"^",2)," ","")   //麻醉助手
	.i anNurse="" s anNur=##class(web.DHCANOPCom).GetNameById(mzNurId)
	.e  s anNur=anNurse
	e  s anNur=""
	s i=0
	s sub=0
	s devNur=""
	s tourNur=""
	f  s sub=$O(^OR(adm,"ANA",chl,"OP",sub)) q:(sub="")!(i=1)  d
	.s i=i+1
	.s p=0  //器械护士
	.s dev=0 
	.f  s dev=$O(^OR(adm,"ANA",chl,"OP",sub,"SCN",dev)) q:(dev="")!(p=3)  d
	..q:dev>20
	..s devNurdr=$P(^OR(adm,"ANA",chl,"OP",sub,"SCN",dev),"^",1)
	..q:devNurdr=""
	..s p=p+1
	..;s devNur=$G(devNur)_" "_$TR($P(^CTPCP(devNurdr,1),"^",2)," ","")
	..;s deNur=$g(decNur)_" "_##class(web.DHCANOPCom).GetNameById(devNurdr)
	..i devNur="" s devNur=##class(web.DHCANOPCom).GetNameById(devNurdr)
	..e  s devNur=devNur_" "_##class(web.DHCANOPCom).GetNameById(devNurdr)
	.s p=0  //巡回护士
	.s tour=0 
	.f  s tour=$O(^OR(adm,"ANA",chl,"OP",sub,"CIRN",tour)) q:(tour="")!(p=3)   d
	..q:tour>20
	..s tourNurdr=$P(^OR(adm,"ANA",chl,"OP",sub,"CIRN",tour),"^",1)
	..q:tourNurdr=""
	..s p=p+1
	..;s tourNur=$G(tourNur)_" "_$TR($P($G(^CTPCP(tourNurdr,1)),"^",2)," ","")
	..;s tourNur=$g(tourNur)_" "_##class(web.DHCANOPCom).GetNameById(tourNurdr)
	..i tourNur="" s tourNur=##class(web.DHCANOPCom).GetNameById(tourNurdr)
	..e  s tourNur=tourNur_" "_##class(web.DHCANOPCom).GetNameById(tourNurdr)
	s devNur1="",devNur2="",tourNur1="",tourNur2=""
	i devNurse1="" s devNur1=$p(devNur," ",2)
	e  s devNur1=devNurse1
	i devNurse2="" s devNur2=$p(devNur," ",3)
	e  s devNur2=devNurse2
	i tourNurse1="" s tourNur1=$p(tourNur," ",2)
	e  s tourNur1=tourNurse1
	i tourNurse2="" s tourNur2=$p(tourNur," ",3)
	e  s tourNur2=tourNurse2
	s operStr="<OperationSchedule><OperaApplyFlow>"_opaSeqNote_"</OperaApplyFlow><ScheduledDateTime>"_operDate_"</ScheduledDateTime><OperatingLoc>"_operLoc_"|"_operLocName_"</OperatingLoc><OperatingRoom>"_operRoom_"</OperatingRoom><OpSeq>"_opSeq_"</OpSeq><AnesthesiaDoctor>"_anDoc_"</AnesthesiaDoctor><AnesthesiaAssistant>"_anNur_"</AnesthesiaAssistant><FirstOperationNurse>"_devNur1_"</FirstOperationNurse><SecondOperationNurse>"_devNur2_"</SecondOperationNurse><FirstSupplyNurse>"_tourNurse1_"</FirstSupplyNurse><SecondSupplyNurse>"_tourNurse2_"</SecondSupplyNurse><Operator>"_operAtor_"</Operator><OperateTime>"_operTime_"</OperateTime><Status>"_opaStatus_"</Status><Remark>"_remark_"</Remark></OperationSchedule>"
	q operStr
}

/// ck 091124
/// 发送平台消息
/// opaId (rowid)
/// d ##class(web.DHCANArrange).SendMessage("157764","2","1","","","","","","3819")
ClassMethod SendMessage(opaId As %String, opaRoom As %String = "", opaSeq As %String = "", anDoctor As %String = "", anNurse As %String = "", devNurse As %String = "", tourNurse As %String = "", opstTime As %String = "", userId As %String = "") As %String
{
	;q:"0"
	q:$g(^DHCCLSet("AnOp","SendMessage"))'="Y" "0"	//设置发送平台消息与否
	q:opaId="" "opaId不能为空！"
	s reStr=""
	s StrMsg="",ResultContent="无返回消息"
	i devNurse'="" s devNurse1=$p(devNurse,"^",1)
	e  s devNurse1=""
	i devNurse'="" s devNurse2=$p(devNurse,"^",2)
	e  s devNurse2=""
	i tourNurse'="" s tourNurse1=$p(tourNurse,"^",1)
	e  s tourNurse1=""
	i tourNurse'="" s tourNurse2=$p(tourNurse,"^",2)
	e  s tourNurse2=""
	s opaIdLen=$l(opaId,"^")
	s len=1
	for len=1:1:opaIdLen
	{
		s opaId=$p(opaId,"^",len)
		q:opaId=""
		s Str=..OperParameters(opaId,opaRoom,opaSeq,anDoctor,anNurse,devNurse1,devNurse2,tourNurse1,tourNurse2,opstTime,userId)
		;s Str="<OperationSchedule><OperaApplyFlow></OperaApplyFlow><ScheduledDateTime></ScheduledDateTime><OperatingLoc></OperatingLoc><OperatingRoom></OperatingRoom><OpSeq></OpSeq><AnesthesiaDoctor></AnesthesiaDoctor><AnesthesiaAssistant></AnesthesiaAssistant><FirstOperationNurse></FirstOperationNurse><SecondOperationNurse></SecondOperationNurse><FirstSupplyNurse></FirstSupplyNurse><SecondSupplyNurse></SecondSupplyNurse><Operator></Operator><OperateTime></OperateTime><Status></Status><Remark></Remark></OperationSchedule>"
		s StrMsg=StrMsg_Str
	}
	s StrMsg="<?xml version="_$c(34)_"1.0"_$c(34)_" encoding="_$c(34)_"UTF-8"_$c(34)_"?><Request><OperationScheduleList>"_StrMsg
	s StrMsg=StrMsg_"</OperationScheduleList></Request>"
	s StreamTarStr=##class(%GlobalCharacterStream).%New()
	s StreamSendTarFlag=##class(%GlobalCharacterStream).%New()
    d StreamTarStr.Write(StrMsg)
    //zym 20120329
    ;s obj=##class(web.DHCENS.WebService.DHCSoap).%New()
    s obj=##class(web.DHCENS.WebServiceNew.DHCCRisXiangYaOneSoap).%New()
    
    s StreamSendTarFlag=obj.DhcService("OperationSchedule",StreamTarStr)
    d StreamSendTarFlag.Rewind()
    
    s Len=StreamSendTarFlag.SizeGet()
    d StreamSendTarFlag.Rewind()
    s SendTarFlag=StreamSendTarFlag.Read(Len)
    i SendTarFlag="" d
    .s StreamSendTarFlag=obj.DhcService("OperationSchedule",StreamTarStr)
    .d StreamSendTarFlag.Rewind()
    .s Len=StreamSendTarFlag.SizeGet()
    .d StreamSendTarFlag.Rewind()
    .s SendTarFlag=StreamSendTarFlag.Read(Len)
    i SendTarFlag=""  d
    .s reStr="无返回消息"
    .s ^tmpcc($p($h,",",1),$p($h,",",2),opaId)=StrMsg_"*"_SendTarFlag
    e  d
    .s ResultContent=$p($P(SendTarFlag,"ResultContent>",2),"</",1)
    .s SendTarFlag=$P(SendTarFlag,"Returncode>",2)
    .i (SendTarFlag="0</") s reStr="0"
    .e  d
    ..s reStr="-111"
    ..s ^tmpcc($p($h,",",1),$p($h,",",2),opaId)=StrMsg_"*"_SendTarFlag
    ..;s reStr=ResultContent
    q reStr
}

/// ck 091130
/// 更新手术时间,发送消息
/// DHC_AN_OPArrange
/// opaId,opsttime
/// 成功返回空,失败返回非空
/// opaId  opsttime
ClassMethod UpdateOpsttime(opaId As %String = "", opsttime As %String = "") As %String
{
	s $zt="ERRORUpdateOpsttime"
	TSTART
	s retStr=""
	i opsttime'="" s opsttime=$zth(opsttime)
	e  s opsttime=$p($h,",",2)
	&sql(update SQLUSER.DHC_AN_OPArrange set OPA_StartTime=:opsttime where opa_rowid=:opaId)
	i SQLCODE'=0 s retStr="时间更新失败！"
	i SQLCODE'=0 TROLLBACK
	
	s ctcpAnDoc="",ctcpAnNur="",ctcpDevNur="",ctcpTourNur="",opaRoom="",opaSeq=""
	s opId=opaId
	s opaSeq=$p($g(^DHCANOPArrange(opId)),"^",26)
	s oproomDr=$p($g(^DHCANOPArrange(opId)),"^",20)
	i oproomDr'="" s opaRoom=$p(^DHCANC("OPRoom",oproomDr),"^",2)
	e  s retStr="手术间不能为空！"
	s userId=%session.Data("LOGON.USERID")
	s retStrSeqNo=..SendMessage(opId,opaRoom,opaSeq,ctcpAnDoc,ctcpAnNur,ctcpDevNur,ctcpTourNur,opsttime,userId)
	i retStrSeqNo'="0" s retStr=retStrSeqNo
	;i retStrSeqNo'="0" s retStr="发送消息失败！"
	i retStrSeqNo'="0" TROLLBACK
	i retStrSeqNo="0" s retStr=""
	i retStr="" TCOMMIT
	q retStr
	
ERRORUpdateOpsttime
	TROLLBACK
	q "-1"
}

/// ck20100329
/// 是否计费(计费完以后才能术后登记和手术护理记录)
/// DHC_AN_OPArrange
/// opaId
/// 成功返回空 失败返回非空
ClassMethod IsPaidOrNo(opaId As %String = "") As %String
{
	q:opaId="" "opaId不能为空!"
	s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
	q:EpisodeID="" "就诊号不能为空!"
	s retStr=""
	s str=""
	s UserID=%session.Data("LOGON.USERID")
	s ctlocID=%session.Data("LOGON.CTLOCID")
	s retStr=##Class(web.DHCOperPrice).SavePrice(EpisodeID,opaId,UserID,ctlocID)
	i retStr="-100" s str="划价医嘱为空!"
	i (retStr'="0</")&(retStr'="-100") s str="划价失败!"
	i retStr="0</" s str=""
	q str
}

/// ck 20100426
/// DHC_AN_OPArrange
/// 撤销登记时改变状态为离室,并且通过平台发送消息
/// opaId
/// 成功返回空,失败返回非空
ClassMethod CancelReg(opaId As %String) As %String
{
	q:opaId="" "opaId不能为空!"
	s $zt="ERRORCancelReg"
	s retStr="",opaStatus=""
	TSTART
	s opaStat=$p($g(^DHCANOPArrange(opaId)),"^",27)
	i opaStat'="F" s retStr="状态错误!"
	s opaStatus="L"
	&sql(update SQLUSER.DHC_AN_OPArrange set OPA_Status=:opaStatus where opa_rowid=:opaId)
	i SQLCODE'=0 s retStr="更新状态出错!"
	i SQLCODE'=0 TROLLBACK

	s opaRoom="",opaSeq="",ctcpAnDoc="",ctcpAnNur="",ctcpDevNur="",ctcpTourNur="",opsttime=""
	s userId=%session.Data("LOGON.USERID")
	s retStrSeqNo=..SendMessage(opaId,opaRoom,opaSeq,ctcpAnDoc,ctcpAnNur,ctcpDevNur,ctcpTourNur,opsttime,userId)
	i retStrSeqNo'="0" s retStr=retStrSeqNo
	;i retStrSeqNo'="0" s retStr="发送消息失败！"
	i retStrSeqNo'="0" TROLLBACK
	i retStrSeqNo="0" s retStr=""
	i retStr="" TCOMMIT
	q retStr
	
ERRORCancelReg
	TROLLBACK
	q "-1"
}

/// ck 20100511
/// 取已安排房间台次时间(时间取的是本台手术的开始时间和下台手术的开始时间)
/// DHC_AN_OPArrange  DHC_ANC_OperRoom 
/// opdate日期 ctcpDr护士Id
/// arrWork
/// w ##class(web.DHCANArrange).GetNurseArr("61859","545")
ClassMethod GetNurseArr(opdate As %String, ctcpDr As %String) As %String
{
	k ^roomTemp
	k ^opaTemp
	k ^timeTemp
	k ^nurseTemp
	s opaRoom=""
	s opaArrTime=""
	s opaArrSeq=""
	s opaWork=""
	s opaRowId=""
	f  s opaRowId=$o(^DHCANOPArrange(0,"SDate",opdate,opaRowId)) q:opaRowId=""  d
	.s opaAnaestDr=$p(^DHCANOPArrange(opaRowId),"^",2)
	.s opaRoomDr=$p(^DHCANOPArrange(opaRowId),"^",20)
	.i opaRoomDr'="" s opaRoom=$p(^DHCANC("OPRoom",opaRoomDr),"^",2)
	.s opaSeq=$p(^DHCANOPArrange(opaRowId),"^",26)
	.q:opaSeq=""
	.s opaSTime=$p(^DHCANOPArrange(opaRowId),"^",15)
	.s ^roomTemp(opdate,"Room",opaRoomDr,opaSeq)=opaRoomDr_"^"_opaSeq_"^"_opaSTime
	.s opSub=0 f  s opSub=$o(^OR($p(opaAnaestDr,"||",1),"ANA",$p(opaAnaestDr,"||",2),"OP",opSub)) q:opSub=""  d
	..s scn="" f  s scn=$o(^OR($p(opaAnaestDr,"||",1),"ANA",$p(opaAnaestDr,"||",2),"OP",opSub,"SCN",scn)) q:scn=""  d
    ...s ctcp=^OR($p(opaAnaestDr,"||",1),"ANA",$p(opaAnaestDr,"||",2),"OP",opSub,"SCN",scn)
	...q:(ctcp=100)!(ctcp="")
	...s ^opaTemp(opdate,"OPARowId",ctcp,opaSeq,opaRoomDr)=opaRoom_"^"_opaSeq_"^"_opaSTime
    ..s cirn="" f  s cirn=$o(^OR($p(opaAnaestDr,"||",1),"ANA",$p(opaAnaestDr,"||",2),"OP",opSub,"CIRN",cirn)) q:cirn=""  d
	...s ctcp=^OR($p(opaAnaestDr,"||",1),"ANA",$p(opaAnaestDr,"||",2),"OP",opSub,"CIRN",cirn)
	...q:(ctcp=100)!(ctcp="")
	...s ^opaTemp(opdate,"OPARowId",ctcp,opaSeq,opaRoomDr)=opaRoom_"^"_opaSeq_"^"_opaSTime

	s arrRoomId="" f  s arrRoomId=$o(^roomTemp(opdate,"Room",arrRoomId)) q:arrRoomId=""  d
	.s arrSeqNo="" f  s arrSeqNo=$o(^roomTemp(opdate,"Room",arrRoomId,arrSeqNo)) q:arrSeqNo=""  d
	..s arrOpaTime=$p(^roomTemp(opdate,"Room",arrRoomId,arrSeqNo),"^",3)
	..i opaArrTime="" s opaArrTime=arrOpaTime
	..e  s opaArrTime=opaArrTime_"^"_arrOpaTime
	..i opaArrSeq="" s opaArrSeq=arrSeqNo
	..e  s opaArrSeq=opaArrSeq_"^"_arrSeqNo
	.f os=1:1:$l(opaArrSeq,"^") d
	..s time=$p(opaArrTime,"^",os)_"~"_$p(opaArrTime,"^",os+1)
	..s ^timeTemp(opdate,"Time",arrRoomId,$p(opaArrSeq,"^",os))=time

	s nurseId="" f  s nurseId=$o(^opaTemp(opdate,"OPARowId",nurseId)) q:nurseId=""  d
	.s arrNurse=""
	.s arrSeq="" f  s arrSeq=$o(^opaTemp(opdate,"OPARowId",nurseId,arrSeq)) q:arrSeq=""  d
	..s arrRoom="" f  s arrRoom=$o(^opaTemp(opdate,"OPARowId",nurseId,arrSeq,arrRoom)) q:arrRoom=""  d
	...s arrTime=$p($g(^timeTemp(opdate,"Time",arrRoom,arrSeq)),"^",1)
	...i arrNurse="" s arrNurse=arrRoom_"-"_arrSeq_"-"_arrTime
	...e  s arrNurse=arrNurse_"^"_arrRoom_"-"_arrSeq_"-"_arrTime
	...s ^nurseTemp(opdate,nurseId)=arrNurse

	i $g(^nurseTemp(opdate,ctcpDr))'="" d
	.s arrNurseWork=$g(^nurseTemp(opdate,ctcpDr))
	.f nl=1:1:$l(arrNurseWork,"^") d
	..s arrNWork=$p(arrNurseWork,"^",nl)
	..s arrNRoom=$p(^DHCANC("OPRoom",$p(arrNWork,"-",1)),"^",2)
	..s arrNSeq=$p(arrNWork,"-",2)
	..s arrNSTime=$p($p(arrNWork,"-",3),"~",1)
	..s arrNETime=$p($p(arrNWork,"-",3),"~",2)
	..i arrNETime="" d
	...i opaWork="" s opaWork=arrNRoom_"间"_arrNSeq_"台"_"("_$zt(arrNSTime,2)_"~"_")"
	...e  s opaWork=opaWork_" "_arrNRoom_"间"_arrNSeq_"台"_"("_$zt(arrNSTime,2)_"~"_")"
	..e  d
	...i opaWork="" s opaWork=arrNRoom_"间"_arrNSeq_"台"_"("_$zt(arrNSTime,2)_"~"_$zt(arrNETime,2)_")"
	...e  s opaWork=opaWork_" "_arrNRoom_"间"_arrNSeq_"台"_"("_$zt(arrNSTime,2)_"~"_$zt(arrNETime,2)_")"

    q opaWork
}

/// chenkai--2010-05-21
/// 判断护士手术时间是否重复,是则返回安排的工作,否则返回空
/// ct_careprov
/// opdate手术日期opaTime手术时间ctcpDr护士ID
/// retStr
/// w ##class(web.DHCANArrange).IsArrNurse("26/05/2010","08:00","2183")
ClassMethod IsArrNurse(opdate As %String, opaTime As %String, ctcpDr As %String) As %String
{
	q:opaTime="" "时间不能为空!"
	s opdate=$zdh(opdate,4)
	s retStr=""
	s nurseArr=""
	i $g(^nurseTemp(opdate,ctcpDr)) d
	.s nurseArr=..GetNurseArr(opdate,ctcpDr)
	;s nurseName=$p(^CTPCP(ctcpDr,1),"^",2)
	s nurseName=##class(web.DHCANOPCom).GetNameById(ctcpDr)
	q:nurseArr=""
	f opaTimeLen=1:1:$l(opaTime,"^") d
	.s arrSTime=$zth($p(opaTime,"^",opaTimeLen))
	.f arrNLen=1:1:$l(nurseArr," ") d
	..s arrWork=$p(nurseArr," ",arrNLen)
	..s arrNSTime=$zth($p($p(arrWork,"(",2),"~",1))
	..i $p($p(arrWork,")",1),"~",2)'="" d
	...s arrNETime=$zth($p($p(arrWork,")",1),"~",2))
	..e  s arrNETime=$zth("23:59:59")+1
	..i (arrSTime>=arrNSTime)&(arrSTime<=arrNETime) d
	...i retStr="" s retStr=nurseName_"在"_nurseArr_"有手术"
	q retStr
}

/// ck 20100622
/// 取安全组用户
/// SS_USER
/// w ##class(web.DHCANArrange).GetGroupUser("105")
ClassMethod GetGroupUser(groupId As %String) As %String
{
	q:groupId="" "安全组不能为空!"
	s retStr=""
	s userId=""
	f  s userId=$o(^SSU("SSUSR",0,"Group",groupId,userId)) q:userId=""  d
	.i retStr="" s retStr=userId
	.e  s retStr=retStr_"@"_userId
	q retStr
}

/// ck 20100623
/// 取急诊,换台,取消的消息
/// 
ClassMethod GetMESSMessage(opaId As %String, opaRoomOld As %String, opaSeqOld As %String, messageType As %String) As %String
{
	q:opaId="" "opaId不能为空！"
	s retStr=""
	s adm=""
	i messageType="N" s adm=opaId //新急诊opaId传的是adm
	e  s adm=$p($g(^DHCANOPArrange(opaId)),"^",1)
	q:adm=""
	s papmiId=$p($g(^PAADM(adm)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s opaRoomDr=$p($g(^DHCANOPArrange(opaId)),"^",20)
	i opaRoomDr'="" s opaRoom=$p($g(^DHCANC("OPRoom",opaRoomDr)),"^",2)
	s opaSeq=$p($g(^DHCANOPArrange(opaId)),"^",26)
	i messageType="E" d  //急诊消息
	.s retStr=patName_"在"_opaRoom_"间"_opaSeq_"台"_"有急诊手术"
	i messageType="T" d  //换台消息
	.s retStr=patName_"从"_opaRoomOld_"间"_opaSeqOld_"台"_"换到"_opaRoom_"间"_opaSeq_"台"
	i messageType="R" d  //取消消息
	.s retStr=patName_"在"_opaRoomOld_"间"_opaSeqOld_"台"_"手术已取消"
	i messageType="N" d  //新急诊消息
	.s retStr=patName_"有新的急诊手术"
	q retStr
}

/// ck 201007
/// 
/// w ##class(web.DHCANArrange).GetRoomAndSeq("635")
ClassMethod GetRoomAndSeq(opaId As %String) As %String
{
	q:opaId="" "opaId不能为空！"
	s opaRoom="",opaSeq=""
	i $d(^TempRoomAndSeq(opaId)) d
	.s opaRoom=$p($g(^TempRoomAndSeq(opaId)),"^",2)
	.s opaSeq=$p($g(^TempRoomAndSeq(opaId)),"^",3)
	e  d
	.s opaRoomId=$p($g(^DHCANOPArrange(opaId)),"^",20)
	.i opaRoomId'="" s opaRoom=$p($g(^DHCANC("OPRoom",opaRoomId)),"^",2)
	.s opaSeq=$p($g(^DHCANOPArrange(opaId)),"^",26)
	i $l(opaSeq,".")>1 d
	.s opaSeq=(opaSeq+0.5)_"+"
	q opaRoom_"^"_opaSeq
}

/// ck 201007
/// 
ClassMethod GetOpdate(opaId As %String) As %String
{
	q:opaId="" "opaId不能为空！"
	s opdate=""
	s opdate=$p($g(^DHCANOPArrange(opaId)),"^",14)
	s opdate=$zd(opdate,4)
	q opdate
}

/// ck 20100719
/// 
ClassMethod GetRoomById(roomId As %String) As %String
{
	q:roomId="" "roomId不能为空！"
	s opaRoom=$p($g(^DHCANC("OPRoom",roomId)),"^",2)
	q opaRoom
}

/// ck 20100719
/// d ##class(%ResultSet).RunQuery("web.DHCANArrange","GetOpname","645")
Query GetOpname(opaId As %String) As %Query(ROWSPEC = "i:%String,opname:%String")
{
}

ClassMethod GetOpnameExecute(ByRef qHandle As %Binary, opaId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s opdes=""
	s adm=$P(^DHCANOPArrange(opaId),"^",1)
	s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d
	.s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6)
	.i opdr'=""  d
	..i $P($g(^ORC("OPER",+opdr)),"^",2)'="" d
	...i opdes'="" s opdes=opdes_";"
	...s opdes=opdes_$P($g(^ORC("OPER",+opdr)),"^",2)
	.e  d
	..i $g(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))'="" d
	...i opdes'="" s opdes=opdes_";"
	...s opdes=opdes_$G(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))
	f i=1:1:$l(opdes,";") d
	.s opname=$p(opdes,";",i)
 	.Do OutputOpname	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputOpname
	set Data=$lb(i,opname)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOpnameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpnameExecute ]
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

ClassMethod GetOpnameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpnameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 周六 返回0 周日-周五返回1
/// w ##class(web.DHCANArrange).GetWeekday()
ClassMethod GetWeekday()
{
	s retDate=+$H
	s remainder=+$H#7
	i remainder=2 s retDate=$zd(+$H+2,4)  //周六返回时间为周一
	e  s retDate=$zd(+$H+1,4)  //周日到周五返回时间为第二天
	q retDate
}

/// w ##class(web.DHCANArrange).GetWeek("11/01/2014","App")
ClassMethod GetWeek(day, type)
{
	i day="" s day=+$h
	e  s day=$zdh(day,4)
	i type="App" d
	.s weekday=(+day-2)#7
	.i weekday=0 s printday=$zd(day+2,3),weekday=weekday+1
	.e  s printday=$zd(day+1,3)
	i type="Op" d
	.s weekday=(+day-3)#7
	.s printday=$zd(day,3)
	s retday=weekday_"^"_printday
	q retday
}

/// ck 取麻醉师备注 一天一条
/// w ##class(web.DHCANArrange).GetAnDocNote("2010-09-15")
ClassMethod GetAnDocNote(date) As %String
{
	i date="" s date=+$H
	e  d
	.i $l(date,"/")>2 s date=$zdh(date,4)
	.i $l(date,"-")>2 s date=$zdh(date,3)
	q $g(^DHCAnDocNote("Date",date))
}

/// 排班护士^护士长^麻醉师
/// "Y^N^N" "N^Y^Y"
ClassMethod AnOpAccess(str1 As %String, str2 As %String, str3 As %String) As %String
{
	q "Y^N^N"
	;s ^TempAnOp("AnOp")="Y^N^N"  //初始化后就注释掉
	i str1'="" d
	.s $p(^TempAnOp("AnOp"),"^",1)=str1
	.i $p(^TempAnOp("AnOp"),"^",1)="N" s $p(^TempAnOp("AnOp"),"^",2)="Y",$p(^TempAnOp("AnOp"),"^",3)="Y"
	.e  s $p(^TempAnOp("AnOp"),"^",2)="N",$p(^TempAnOp("AnOp"),"^",3)="N"
	i (str2'="")!(str3'="") d
	.i str2'="" s $p(^TempAnOp("AnOp"),"^",2)=str2
	.i str3'="" s $p(^TempAnOp("AnOp"),"^",3)=str3
	.i ($p(^TempAnOp("AnOp"),"^",2)="N")&($p(^TempAnOp("AnOp"),"^",3)="N") s $p(^TempAnOp("AnOp"),"^",1)="Y"
	.e  s $p(^TempAnOp("AnOp"),"^",1)="N"
	q ^TempAnOp("AnOp")
}

/// ck 20100901
/// w ##class(web.DHCANArrange).GetIdByDescOrAlias("shj")
ClassMethod GetIdByDescOrAlias(desc As %String) As %String
{
	s retStr="",retCtcpStr=""
	s desc=$$ALPHAUP^SSUTIL4(desc)
	s ctlocId=$g(%session.Data("LOGON.CTLOCID"))
	;s ctlocId=311
	s rw="" f  s rw=$O(^RB("RES",0,"CTLOC",ctlocId,rw)) q:rw=""  d
	.s ctcpDr=$P(^RB("RES",rw),"^",2)
	.q:ctcpDr=""
	.;q:(..GetCtcpFlag(ctcpDr)'=1)
	.;s ctcpAlias=$p(^CTPCP(ctcpDr,1),"^",1)
	.s ctcpAlias=$p(^CTPCP(ctcpDr,3),"^",28)
	.s ctcpDesc=$p($p(^CTPCP(ctcpDr,1),"^",2),"-",1)
	.s flag=0
	.i desc'="" d
	..;i $p(ctcpAlias,desc)="" d
	..i ctcpAlias=desc d
	...i retStr="" s retStr=ctcpDesc_"^"_ctcpDr
	...e  s retStr=retStr_";"_ctcpDesc_"^"_ctcpDr
	..e  d
	...;i $p(ctcpDesc,desc)="" d
	...i ctcpDesc=desc d
	....i retStr="" s retStr=ctcpDesc_"^"_ctcpDr
	....e  s retStr=retStr_";"_ctcpDesc_"^"_ctcpDr
	...e  d
	....s flag=1
	.e  q
	.i flag=1 q
	
	s clcpRowId="" f  s clcpRowId=$o(^DHCCLCPI("CtLoc",ctlocId,clcpRowId)) q:clcpRowId=""  d
	.s ctcpDr="~"_clcpRowId
    .s ctcpDesc=$li($g(^DHCCLCP(clcpRowId)),2)
    .s ctcpAlias=$li($g(^DHCCLCP(clcpRowId)),3)
    .s editFlag=$li($g(^DHCCLCP(clcpRowId,1)),2)
    .q:editFlag'="N"
    .i desc'="" d
	..;i $p(ctcpAlias,desc)="" d
	..i ctcpAlias=desc d
	...i retStr="" s retStr=ctcpDesc_"^"_ctcpDr
	...e  s retStr=retStr_";"_ctcpDesc_"^"_ctcpDr
	..e  d
	...;i $p(ctcpDesc,desc)="" d
	...i ctcpDesc=desc d
	....i retStr="" s retStr=ctcpDesc_"^"_ctcpDr
	....e  s retStr=retStr_";"_ctcpDesc_"^"_ctcpDr
	...e  d
	....s flag=1
	.e  q
	.i flag=1 q
	
	f len=1:1:$l(retStr,";") d
	.s retCtcp=$P(retStr,";",len)
	.i retCtcpStr'[retCtcp d
	..i retCtcpStr="" s retCtcpStr=retCtcp
	..e  s retCtcpStr=retCtcpStr_";"_retCtcp
    q retCtcpStr
}

/// ck 20100914 通过本机ip获取手术间,--IP对应多个房间的时候返回空
/// 返回 手术间ID^手术间Desc
ClassMethod GetRoomIdByIp(ipConfig As %String = "") As %String
{
	s curTime=$zts
	s userId=%session.Data("LOGON.USERID")
	;i userId=3819 d
	s ^tmpAnop("GetRoomIdByIp",userId,curTime,"input")=ipConfig
	s retStr=""
	s flag=0
	i ipConfig="" s ipConfig=$zu(67,15,$j)
	;i userId=3819 d
	s ^tmpAnop("GetRoomIdByIp",userId,curTime,"input1")=ipConfig
	s roomId="" f  s roomId=$o(^DHCANRoomEquip(0,"Room",roomId)) q:roomId=""  d
	.s anreId="" f  s anreId=$o(^DHCANRoomEquip(0,"Room",roomId,anreId)) q:anreId=""  d
	..s anreETAddress=$p($g(^DHCANRoomEquip(anreId)),"^",7)
	..q:anreETAddress=""
	..i ("|"_anreETAddress_"|")[("|"_ipConfig_"|") d
	...s retStr=roomId_"^"_$p($g(^DHCANC("OPRoom",roomId)),"^",2)
	...s flag=flag+1
	;i userId=3819 d
	s ^tmpAnop("GetRoomIdByIp",userId,curTime,"output")=flag_"/"_retStr_"/"_$zts
	i flag>1 s retStr=""
	;i userId=3819 d
	s ^tmpAnop("GetRoomIdByIp",userId,curTime,"output1")=flag_"/"_retStr_"/"_$zts
	q retStr
}

/// type "A"返回划价状态  "C"返回收费状态
ClassMethod AuditOrCharge(opaId As %String, type As %String, ctlocId As %String) As %String
{
	q:opaId="" "opaId不能为空！"
	s retStr="-1"
	s EpisodeID=$p($g(^DHCANOPArrange(opaId)),"^",1)
	s adm=EpisodeID
	s AnaesthesiaID=$p($g(^DHCANOPArrange(opaId)),"^",2)
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
    s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s exOeoriDr="",isPaidStr="",retPaid="",isPlanPriceStr="",retPlanPrice=""
	f  s exOeoriDr=$o(^DHCEXDE(0,"OEORI",EpisodeID,exOeoriDr)) q:exOeoriDr=""  d
	.s exRowId="",isPlanPrice="",isPaid=""
	.f  s exRowId=$o(^DHCEXDE(0,"OEORI",EpisodeID,exOeoriDr,exRowId)) q:exRowId=""  d
	..s anaestDr=$p($g(^OEORD(+exOeoriDr,"I",$p(exOeoriDr,"||",2),4)),"^",9)
	..q:anaestDr'=AnaesthesiaID
	..s itemStatDR=$p($g(^OEORD(+exOeoriDr,"I",$p(exOeoriDr,"||",2),1)),"^",13)
	..q:(itemStatDR=4)!(itemStatDR="")!(itemStatDR=5)!(itemStatDR=6)
	..s recDept=$P($G(^DHCEXDE(exRowId)),"^",16)
  	..q:recDept'=ctlocId
	..s exBillingAttr=$p($g(^DHCEXDE(exRowId)),"^",17)
	..q:exBillingAttr="F"
	..i (exBillingAttr="0")!(exBillingAttr="") s isPlanPrice="N"
	..e  s isPlanPrice="Y"
	..s exStatus=$p($g(^DHCEXDE(exRowId)),"^",18)
	..q:exStatus="F"
	..i (exStatus="A")&(exBillingAttr="1") s isPaid="Y"
	..e  s isPaid="N"
	..i isPlanPriceStr="" s isPlanPriceStr=isPlanPrice
	..e  s isPlanPriceStr=isPlanPriceStr_isPlanPrice
    ..i isPaidStr="" s isPaidStr=isPaid
    ..e  s isPaidStr=isPaidStr_"^"_isPaid
    i type="A" d
    .i isPlanPriceStr'="" s retPlanPrice=0
    .e  s retPlanPrice="没有收费项!"
    .s retStr=retPlanPrice
    i type="C" d
    .i isPaidStr'="" d
    ..i isPaidStr["N" s retPaid="存在未审核项目!"
    ..e  s retPaid=0
    ..s retStr=retPaid
	q retStr
}

/// 成功返回0 否则返回非0 ck 20100926
/// type == "AND" || "ANN" || "OP"
ClassMethod SendRegMsg(opaId As %String, type As %String, userId As %String, ctlocId As %String) As %String
{
	q:opaId="" "opaId不能为空！"
	q:userId="" "userId不能为空！"
	s retStr="-1",sendMsg="N",OPCharge="-1",ANCharge="N"
	s enddate=$p(^DHCANOPArrange(opaId),"^",16)
	s endtime=$p(^DHCANOPArrange(opaId),"^",17)
	i enddate="" s enddate=+$h
	i endtime="" s endtime=$p($h,",",2)
	TSTART
	s opastatus=$p(^DHCANOPArrange(opaId),"^",27)
	i ((type="AND")||(type="ANN")) d
	.s AnDocOrd="",AnNurOrd=""
	.i type="AND" s AnDocOrd="Y"
	.i type="ANN" s AnNurOrd="Y"
	.i (opastatus="P")&(type="ANN") &sql(update SQLUSER.DHC_AN_OPArrange set OPA_Status='F',OPA_EndDate=:enddate,OPA_EndTime=:endtime where opa_rowid=:opaId)
	.&sql(update SQLUSER.DHC_AN_OPArrange set OPA_AnaDoctorOrdered=:AnDocOrd,OPA_AnaNurseOrdered=:AnNurOrd where opa_rowid=:opaId)
	.i SQLCODE'=0 s retStr="更新麻醉师收费状态失败!"
	.i SQLCODE'=0 TRollBack
	.s OPCharge=..AuditOrCharge(opaId,"C",ctlocId)
	.s ANCharge="Y"
	i type="OP" d
	.s OpNurOrd="Y"
	.i (opastatus="L")!(opastatus="R") &sql(update SQLUSER.DHC_AN_OPArrange set OPA_Status='F',OPA_EndDate=:enddate,OPA_EndTime=:endtime where opa_rowid=:opaId)
	.&sql(update SQLUSER.DHC_AN_OPArrange set OPA_OpNurseOrdered=:OpNurOrd where opa_rowid=:opaId)
	.i SQLCODE'=0 s retStr="更新手术护士收费状态失败!"
	.i SQLCODE'=0 TRollBack
	.s ANCharge=$p($g(^DHCANOPArrange(opaId)),"^",48)
	.s OPCharge="0"
	;i ((OPCharge="0")&&(ANCharge="Y")) s sendMsg="Y"
	;e  s sendMsg="N"
	s opastatus=$p(^DHCANOPArrange(opaId),"^",27)
	//s userId=%session.Data("LOGON.USERID")
	;i sendMsg="Y" d
	i (opastatus="F")!(opastatus="P") d
	.s opaRoom="",opstTime="",opaSeq="",ctcpAnDoc="",ctcpAnNur="",ctcpDevNur="",ctcpTourNur="",opstTime=""
	.s retStr=..SendMessage(opaId,opaRoom,opaSeq,ctcpAnDoc,ctcpAnNur,ctcpDevNur,ctcpTourNur,opstTime,userId)
	e  s retStr="0"
	TCOMMIT
	q retStr
}

/// ck 20101209
/// 获取医嘱大类
/// w ##class(web.DHCANArrange).GetORCATRowId("B")
ClassMethod GetORCATRowId(ORCATCode As %String) As %String
{
	q:ORCATCode="" "医嘱分类不能为空！"
	s ORCATCode=$$ALPHAUP^SSUTIL4(ORCATCode)
	s ORCATCode=ORCATCode_"%"
	s ORCATRowId=""
	&sql(select  ORCAT_RowId into :ORCATRowId from SQLUser.OEC_OrderCategory where (UPPER(ORCAT_Code) like :ORCATCode))
	q:ORCATRowId="" "该医嘱分类对应的医嘱项不存在！"
	q ORCATRowId
}

/// ck 20101209
/// 获取医嘱子分类
ClassMethod GetARCICRowId(ARCICCode As %String) As %String
{
	q:ARCICCode="" "医嘱分类不能为空！"
	s ARCICCode=$$ALPHAUP^SSUTIL4(ARCICCode)
	s ARCICCode=ORCATCode_"%"
	s ORCATRowIdStr=""
	&sql(declare RowId cursor for select distinct ARCIC_RowId from SQLUser.ARC_ItemCat where (UPPER(ARCIC_Code) like :ARCICCode))
	&sql(open RowId)
	f  &sql(fetch RowId into :ARCICRowId) q:SQLCODE  d
	.i ARCICRowIdStr="" s ARCICRowIdStr=ARCICRowId
 	.e  s ARCICRowIdStr=ARCICRowIdStr_"^"_ARCICRowId
	&sql(close RowId)
	q:ARCICRowIdStr="" "该医嘱分类对应的医嘱项不存在！"
	q ARCICRowIdStr
}

/// w ##class(web.DHCANArrange).GetORCAT("")
ClassMethod GetORCAT(str As %String) As %String
{
	s retStr=""
	s str=str_"%"
	i str'="" d
	.&SQL(declare ORCATStr cursor  for select ORCAT_RowId,ORCAT_Code,ORCAT_Desc from SQLUser.OEC_OrderCategory where UPPER(ORCAT_Code) like UPPER(:str))
	.&SQL(open ORCATStr)
	.f  &SQL(fetch ORCATStr into :ORCATRowId,:ORCATCode,:ORCATDesc) q:SQLCODE  d
	..i retStr="" s retStr=ORCATCode_"-"_ORCATDesc_"^"_ORCATRowId
	..e  s retStr=retStr_$c(1)_ORCATCode_"-"_ORCATDesc_"^"_ORCATRowId
	.&SQL(close ORCATStr)
	e  d
	.&SQL(declare ORCATStr1 cursor  for select ORCAT_RowId,ORCAT_Code,ORCAT_Desc from SQLUser.OEC_OrderCategory)
	.&SQL(open ORCATStr1)
	.f  &SQL(fetch ORCATStr1 into :ORCATRowId,:ORCATCode,:ORCATDesc) q:SQLCODE  d
	..i retStr="" s retStr=ORCATCode_"-"_ORCATDesc_"^"_ORCATRowId
	..e  s retStr=retStr_$c(1)_ORCATCode_"-"_ORCATDesc_"^"_ORCATRowId
	.&SQL(close ORCATStr1)
	q retStr
}

ClassMethod GetArcosByANCORowId(ancorowId As %String) As %String
{
	//w ##class(web.DHCANArrange).GetArcosByANCORowId("111")
	q:ancorowId="" "ID不能为空"
	s ArcosId="-1"
	s AnApply=$p($g(^DHCANC("ComOrd",ancorowId)),"^",9)
	q:AnApply'="Y" "-1"
	s ArcosId=$p($g(^DHCANC("ComOrd",ancorowId)),"^",15)
	i ArcosId="" s ArcosId="-1"
	q ArcosId
}

/// w ##class(web.DHCANArrange).GetAllOrder("YYKXSHCF","134","30644","","10221527")
/// w ##class(web.DHCANArrange).GetAllOrder("ycxsy","134","4","","") error
ClassMethod GetAllOrder(Item As %String, GroupID As %String, Category As %String, SubCategory As %String, EpisodeID As %Library.String) As %String
{
	n (Item,GroupID,Category,SubCategory,EpisodeID)
	i GroupID="154" s GroupID="134"
	i GroupID="136" s GroupID="143"
	s ^tmpAN("GetAllOrder")=Item_","_GroupID_","_Category_","_SubCategory_","_EpisodeID
	s rset=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
	s ^tmpAN("GetAllOrder",+EpisodeID)=Item_","_GroupID_","_Category_","_SubCategory_","_EpisodeID_","_rset
	s ret="",isTooLong=0
	do rset.Execute(Item,GroupID,Category,SubCategory,"","","",EpisodeID,"","","","","","","","")
	while (rset.Next()) {
		;s isstop=##Class(web.DHCANArrange).IsArcimStop(rset.GetData(2))
		;q:isstop'="0"
		i $l(ret)>30000 s ret="",isTooLong=1 break 
		i ret=""  s ret=rset.GetData(1)_"^"_rset.GetData(2)_"^"_rset.GetData(4)_"^"_rset.GetData(12)_"^"_rset.GetData(13)_"^"_rset.GetData(19)
		e  s ret=ret_$c(1)_rset.GetData(1)_"^"_rset.GetData(2)_"^"_rset.GetData(4)_"^"_rset.GetData(12)_"^"_rset.GetData(13)_"^"_rset.GetData(19)
	}
	d rset.Close()
	i isTooLong s ret=""
	q ret
}

/// w ##class(web.DHCANArrange).GetAllCTLoc("","796958")
ClassMethod GetAllCTLoc(desc As %String, EpisodeID As %String) As %String
{
	n (desc,EpisodeID)
	s rset=##class(%ResultSet).%New("web.DHCCLCom:FindLocList")
	s ret=""
	do rset.Execute(desc,"AN^OUTAN^EMAN^INOPDEPT^OUTOPDEPT^EMOPDEPT^OP^OUTOP^EMOP",EpisodeID)
	while (rset.Next()) {
		i ret=""  s ret=rset.GetData(2)_"^"_rset.GetData(1)
		e  s ret=ret_$c(1)_rset.GetData(2)_"^"_rset.GetData(1)
	}
	d rset.Close()
	q ret
}

/// 
/// 
/// w ##class(web.DHCANArrange).GetCTLocByCTLocDr("311")
ClassMethod GetCTLocByCTLocDr(ctlocdr As %String) As %String
{
	q:ctlocdr="" "科室Id不能为空！"
	s retStr=""
	s CTLocDesc=$p($g(^CTLOC(ctlocdr)),"^",2)
	s retStr=CTLocDesc_"^"_ctlocdr
	q retStr
}

/// 20101222
/// 
/// w ##class(web.DHCANArrange).GetRoomIdByOpaId("2053")
ClassMethod GetRoomIdByOpaId(opaId As %String) As %String
{
	q:opaId="" ""
	s opaRoomId=$p($g(^DHCANOPArrange(opaId)),"^",20)
	q:opaRoomId="" ""
	s opaSeq=$p($g(^DHCANOPArrange(opaId)),"^",26)
	q:opaSeq="" ""
	q opaRoomId_"^"_opaSeq
}

ClassMethod GetArcimName(ArcimRowid As %String, Num As %String)
{
	n (ArcimRowid,Num)
  s ArcimName=$P($G(^ARCIM(+ArcimRowid,1,1)),"^",2)	
  s RetPrice=##Class(web.DHCDocOrderEntry).GetOrderPrice("","",ArcimRowid,+$H,"","","","")
  s ArcimPrice=$p(RetPrice,"^",1)
  s arcicId=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10)
  q:arcicId="" ""
  q:'$d(^ARC("IC",arcicId)) ""
  s OrdCatId=$p(^ARC("IC",arcicId),"^",8)
  q:OrdCatId="" ""
  s OrdCatDesc=$p(^OEC("ORCAT",OrdCatId),"^",2)
  s str=ArcimName_"^"_Num_"^"_ArcimRowid_"^"_ArcimPrice_"^"_OrdCatId_"^"_OrdCatDesc
  s retval="ArcimList"_"('"_$ZCVT(str,"O","JS")_"');"
  &javascript<#(retval)#>
}

/// w ##class(web.DHCANArrange).GetOrdCatId("6813||1")
ClassMethod GetOrdCatId(ArcimRowid As %String)
{
  n (ArcimRowid)
  s arcicId=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10)
  q:arcicId="" ""
  q:'$d(^ARC("IC",arcicId)) ""
  s OrdCatId=$p(^ARC("IC",arcicId),"^",8)
  q:OrdCatId="" ""
  q OrdCatId
}

/// 通过groupid获取医嘱套
/// ck 20101224
/// w ##class(web.DHCANArrange).GetArcosByGroupId("134")
ClassMethod GetArcosByGroupId(groupId As %String) As %String
{
	q:groupId="" "groupId不能为空！"
	n (groupId)
	s ret="",AliasText=""
	s rset=##class(%ResultSet).%New("web.DHCANOrder:FindARCOrdSets")
	d rset.Execute(groupId)
	while (rset.Next()) {
		s arcosId=rset.GetData(1)
		s arcosDesc=rset.GetData(2)
		s orcatId=$p(^ARCOS(arcosId),"^",8)
		s orcatcode=$p(^ARCOS(arcosId),"^",1)
		;s AliasRowId=$o(^ARC("ALIAS",0,"ARCOS",arcosId,""))
		;s AliasText=$p(^ARC("ALIAS",AliasRowId),"^",6)
		s AliasTextStr=""
		s AliasRowId="" f  s AliasRowId=$o(^ARC("ALIAS",0,"ARCOS",+arcosId,AliasRowId)) q:AliasRowId=""  d
		.s AliasText=$p(^ARC("ALIAS",AliasRowId),"^",6)
		.i AliasTextStr="" s AliasTextStr=AliasText
		.e  s AliasTextStr=AliasTextStr_"/"_AliasText
		i (((^DHCANOPLimit("Arcos",311)[groupId)!(^DHCANOPLimit("Arcos",312)[groupId))&(orcatId="7"))!((^DHCANOPLimit("Arcos",52)[groupId)&(orcatId="8"))
		{
			i ret=""  s ret=arcosId_"^"_arcosDesc_"^"_orcatcode_"^"_AliasTextStr
			e  s ret=ret_$C(1)_arcosId_"^"_arcosDesc_"^"_orcatcode_"^"_AliasTextStr
		}
	}
	d rset.Close()
	q ret
}

ClassMethod FindOEORDByAdm(EpisodeID As %String, DHCANORowid As %String, UserID As %String, CTloc As %String)
{
	n (EpisodeID,DHCANORowid,UserID,CTloc)
  ;k ^TempOEORD
  s CTlocCode=""
  s CTlocCode=$P($P($G(^CTLOC(CTloc)),"^",2),"-",1)
   s count=0
  //w ##class(web.DHCANArrange).FindOEORDByAdm("1716798","24170","3819","311")
  Set OEORDRowId=$O(^OEORD(0,"Adm",EpisodeID,-1))
  Set OPERDr=$P(^DHCANOPArrange(DHCANORowid),"^",2)
  Set AppRowid=$P(^DHCANOPArrange(DHCANORowid),"^",41)
  If OEORDRowId="" Q "-1"
  Set ChildOEORDRowId=0 For  Set ChildOEORDRowId=$O(^OEORD(OEORDRowId,"I",ChildOEORDRowId)) Q:ChildOEORDRowId=""  Do
  .Set AnaestDR=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,4)),"^",9)
  .s count=count+1
  .q:AnaestDR'=OPERDr
  .Set ItmMast=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",2)
  .Set OEORIItemStat=$p($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",13)
  .Set OEState=$p($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",13)
  .Q:OEORIItemStat="4"
  .Set ItmDesc=$P(^ARCIM($P(ItmMast,"||",1),$P(ItmMast,"||",2),1),"^",2)
  .Set ItmCode=$P(^ARCIM($P(ItmMast,"||",1),$P(ItmMast,"||",2),1),"^",1)
  .Set UserDepartme=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,7)),"^",2)
  .;Q:$G(UserDepartme)'=CTloc
  .Set AppointmentDate=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",9)
  .Set sttdate=AppointmentDate
  .If (AppointmentDate'="") Set AppointmentDate=$ZD(AppointmentDate,3)
  .Set AppointmentTime=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",10)
  .If AppointmentTime'="" Set AppointmentTime=$ZT(AppointmentTime,3)
  .Set TDate=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,3)),"^",7)
  .If TDate'="" Set TDate=$ZD(TDate,3)
  .Set TTime=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",17)
  .If TTime'="" Set TTime=$ZT(TTime,3)
  .Set AdmType=$P(^PAADM(EpisodeID),"^",2)
  .If AdmType="O" Set AdmType="门诊"
  .If AdmType="I" Set AdmType="住院"
  .If AdmType="E" Set AdmType="急诊"
  .Set AdmReason=$P($G(^PAADM(EpisodeID),1),"^",7)
  .Set CheckPrice=##class(web.DHCOperPrice).CheckTar(OEORDRowId,ChildOEORDRowId,EpisodeID,ItmMast,"1","",UserID,AppRowid)
  .Set Price=##class(web.DHCDocOrderEntry).GetOrderPrice("", AdmReason, ItmMast, "", "", "", "", "") 
  .Set Price=$P(Price,"^",1)
  .Set Price=$j(Price,3,2)
  .Set QtyNum=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",12)
  .Set PriceStatus=##class(web.DHCOperPrice).CheckStatus(OEORDRowId,ChildOEORDRowId,EpisodeID)
  .Set SumPrice=QtyNum*Price
  .Set SumPrice=$j(SumPrice,3,2)
  .Set ChangePrice="修改"
  .Set OEORDRowid=OEORDRowId_"||"_ChildOEORDRowId
  .Set EXRowid=$O(^DHCEXDE(0,"OEORI",EpisodeID,OEORDRowid,-1))
  .q:EXRowid=""
  .If EXRowid'="" d
  ..Set Price=##class(web.DHCOperPrice).GetPrice(EpisodeID,OEORDRowid)
  ..Set SumPrice=Price*QtyNum
  ..Set SumPrice=$j(SumPrice,3,2)
  .Set OEORDDr=OEORDRowId_"||"_ChildOEORDRowId
  .Set DoseUOM=$p($g(^OEORD(OEORDRowId,"I",ChildOEORDRowId,2)),"^",3)
  .if DoseUOM'="" Set CTUOMDesc=$p(^CT("UOM",DoseUOM),"^",2)  
  .Else  Set CTUOMDesc=""
  .Set ReLocRowid=$p($g(^OEORD(OEORDRowId,"I",ChildOEORDRowId,3)),"^",6)
  .q:ReLocRowid'=CTloc
  .Set ReLoc=$p($g(^CTLOC(ReLocRowid)),"^",2) s ReLoc=$p(ReLoc,"-",2)
  .Set OEORDDate=$p($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,11)),"^",4)
  .Set OEORDDate=$Zd(OEORDDate,3)
  .Set OEORDTime=$p($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,11)),"^",5)
  .Set OEORDTime=$ZT(OEORDTime,1)
  .Set OEORDUser=$p($g(^OEORD(OEORDRowId,"I",ChildOEORDRowId,7)),"^",1)
  .Set AppLocRowid=$p($g(^OEORD(OEORDRowId,"I",ChildOEORDRowId,7)),"^",2)
  .q:AppLocRowid=""
  .Set AppLoc=$p($g(^CTLOC(AppLocRowid)),"^",2) s AppLoc=$p(AppLoc,"-",2)
  .Set OEORDUserDesc=$p($P(^SSU("SSUSR",OEORDUser),"^",2),"-",1)
  .;Set PriceStatus=""
  .if (PriceStatus'="")&(EXRowid'="") Do
  ..if $P($G(^DHCEXDE(EXRowid)),"^",11)'="" Set OEORDDate=$ZD($P($G(^DHCEXDE(EXRowid)),"^",11),3)
  ..if $P($G(^DHCEXDE(EXRowid)),"^",12)'="" Set OEORDTime=$ZT($P($G(^DHCEXDE(EXRowid)),"^",12),1)
  .Set PriceStatus=$P($G(^DHCEXDE(EXRowid)),"^",17)
  .if PriceStatus="" Set PriceStatus="未划价"
  .if (PriceStatus="0") Set PriceStatus="已划价"
  .if PriceStatus=1 Set PriceStatus="已收费"
  .if PriceStatus="F" Set PriceStatus="退费"
  .Set OrdCatId=##class(web.DHCCLCom).GetOrdCatId(OEORDRowid)
  .Set OrdCatDesc=$p(^OEC("ORCAT",OrdCatId),"^",2)
  .s temp=""
  .;"1"D—检查"2"E—治疗"3"A—西药"4"I—材料"5"B—中药"6"C—化验"7"F—手术"8"G—麻醉"9"H—血费"10"J—床位"11"K—护理"12"L—膳食"13"Z—其他
  .;i CTlocCode="DSSS" d
  ..;i OrdCatId="7" s temp=1  //F—手术
  ..;e  i OrdCatId="3" s temp=3  //A—西药
  ..;e  s temp=2
  ..;s TempOEORD("OrdCatId",temp,EXRowid)=ItmDesc_"^"_ItmMast_"^"_QtyNum_"^"_Price_"^"_SumPrice_"^"_CTUOMDesc_"^"_OEORDDr_"^"_ReLoc_"^"_OEORDDate_"^"_OEORDTime_"^"_OEORDUserDesc_"^"_PriceStatus_"^"_$g(PriceCode)_"^"_ReLocRowid_"^"_AppLoc_"^"_AppLocRowid_"^"_OrdCatId_"^"_OrdCatDesc_"^"_EXRowid
  .i CTlocCode="DSSS" d
  ..i OrdCatId="7" s temp=1  //F—手术
  ..e  i OrdCatId="2" s temp=2
  ..e  i OrdCatId="1" s temp=3
  ..e  i OrdCatId="11" s temp=4
  ..e  i OrdCatId="8" s temp=5
  ..e  i OrdCatId="13" s temp=6
  ..e  i OrdCatId="4" s temp=7
  ..e  i OrdCatId="3" s temp=9  //A—西药
  ..e  s temp=8
  ..s TempOEORD("OrdCatId",temp,EXRowid)=ItmDesc_"^"_ItmMast_"^"_QtyNum_"^"_Price_"^"_SumPrice_"^"_CTUOMDesc_"^"_OEORDDr_"^"_ReLoc_"^"_OEORDDate_"^"_OEORDTime_"^"_OEORDUserDesc_"^"_PriceStatus_"^"_$g(PriceCode)_"^"_ReLocRowid_"^"_AppLoc_"^"_AppLocRowid_"^"_OrdCatId_"^"_OrdCatDesc_"^"_EXRowid
  .e  d
  ..s TempOEORD("OrdCatId",OrdCatId,EXRowid)=ItmDesc_"^"_ItmMast_"^"_QtyNum_"^"_Price_"^"_SumPrice_"^"_CTUOMDesc_"^"_OEORDDr_"^"_ReLoc_"^"_OEORDDate_"^"_OEORDTime_"^"_OEORDUserDesc_"^"_PriceStatus_"^"_$g(PriceCode)_"^"_ReLocRowid_"^"_AppLoc_"^"_AppLocRowid_"^"_OrdCatId_"^"_OrdCatDesc_"^"_EXRowid
  
  s ordno="" f  s ordno=$o(TempOEORD("OrdCatId",ordno)) q:ordno=""  d
  .s OEORDID="" f  s OEORDID=$o(TempOEORD("OrdCatId",ordno,OEORDID)) q:OEORDID=""  d
  ..s str=TempOEORD("OrdCatId",ordno,OEORDID)
  ..s retval="OEORDList"_"('"_$ZCVT(str,"O","JS")_"');"
  ..&javascript<#(retval)#>
}

/// w ##class(web.DHCANArrange).IsStopByEXId("")
ClassMethod IsStopByEXId(exId As %String) As %String
{
	q:exId="" "收费表Id不能为空!"
	s retstr="-1"
	s PriceStatus=$P($G(^DHCEXDE(exId)),"^",17)
	i PriceStatus="" s retstr=0
	e  s retstr=-1
	q retstr
}

/// w ##class(web.DHCANArrange).GetLinkLocByLocId("824")
ClassMethod GetLinkLocByLocId(LocId As %String) As %String
{
	q:LocId="" ""
	s ctlocId="",ctlocIdStr="",linkLocIdStr=""
	f  s ctlocId=$o(^CTLOC(ctlocId)) q:ctlocId=""  d
	.s linkSub=0 f  s linkSub=$o(^CTLOC(ctlocId,"LINK",linkSub)) q:linkSub=""  d
	..q:^CTLOC(ctlocId,"LINK",linkSub)'=LocId
	..i linkLocIdStr="" s linkLocIdStr=ctlocId
	..e  s linkLocIdStr=linkLocIdStr_"^"_ctlocId

	f i=1:1:$l(linkLocIdStr,"^") d
	.s ctloc=$p(linkLocIdStr,"^",i)
	.s linkSub=0 f  s linkSub=$o(^CTLOC(ctloc,"LINK",linkSub)) q:linkSub=""  d
    ..i ctlocIdStr'="" s ctlocIdStr=ctlocIdStr_"^"
    ..s ctlocIdStr=ctlocIdStr_^CTLOC(ctloc,"LINK",linkSub)
	q ctlocIdStr
}

/// w ##class(web.DHCANArrange).GetARCAliasByARCIMDR("17927||1")
ClassMethod GetARCAliasByARCIMDR(ARCIMDR As %String) As %String
{
	q:ARCIMDR="" "ARCIMDR不能为空！"
	s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",ARCIMDR,""))
	q:ALIASRowId=""
	s ALIASText=$p(^ARC("ALIAS",ALIASRowId),"^",6)
	q ALIASText
}

/// w ##class(web.DHCANArrange).OrdSetInsert("","麻醉测试2","MZCS","63AN","52","12586||1")
ClassMethod OrdSetInsert(selectARCId As %String, OrdSetname As %String, ArcAlias As %String, ArcCode As %String, CTloc As %String, arcimStr As %String) As %String
{
	;s arcimStr="12586||1"_$c(1)_"19229||1"
	n (selectARCId,OrdSetname,ArcAlias,ArcCode,CTloc,arcimStr)
	s $zt="ERRORInsertOrder"
	s NowDate=+$H,NowTime=$P($H,",",2)
	s OrdCatDR="",OrdSubCatDR="",ARCOSRowid="",retStr="0",ARCOSDateRowid=""
	i CTloc="311"  d
	.s OrdCatDR="7",OrdSubCatDR="46"  //xiangya  ck
	e  i CTloc="312"  d
	.s OrdCatDR="7",OrdSubCatDR="46"  //xiangya  ck
	e  i CTloc="52"  d
	.s OrdCatDR="8",OrdSubCatDR="49"  //xiangya  ck
	q:OrdCatDR="" "只有手术室和麻醉科的用户能够修改医嘱套"
	
	s ARCOSDateRowid=""
	TSTART
	s ArcCode=$$ALPHAUP^SSUTIL4(ArcCode)
	s ITMChildsub=0
	s OrdSetname=$$ALPHAUP^SSUTIL4(OrdSetname)
	s arcRowId=$o(^ARCOS(0,"Code",ArcCode,""))
	i ((arcRowId'="")&(arcRowId'=selectARCId)&(selectARCId'="")) TRollBack  q "医嘱套代码已存在，请重新输入！"
	i arcRowId="" d
	.&SQL(insert into sqluser.ARC_OrdSets (ARCOS_Code,ARCOS_Desc,ARCOS_OrdCat_DR,ARCOS_OrdSubCat_DR,ARCOS_EffDateFrom) Values (:ArcCode,:OrdSetname,:OrdCatDR,:OrdSubCatDR,:NowDate))
	.i SQLCODE'=0 s retStr="插入医嘱套表失败"_SQLCODE TRollBack  q
	.s ARCOSRowid=%ROWID
	.;s ARCOSDateRowid=..GetOrderSetDate(ARCOSRowid)
	.&SQL(Insert Into SQLUser.ARC_Alias (ALIAS_ARCOS_DR,ALIAS_DateFrom,ALIAS_Text,ALIAS_OrderSubCat_dr,ALIAS_Desc) Values(:ARCOSRowid,:NowDate,:ArcAlias,:OrdSubCatDR,:OrdSetname))
	.i SQLCODE'=0 s retStr="插入别名表失败"_SQLCODE TRollBack  q
	e  d
	.&SQL(update sqluser.ARC_OrdSets set ARCOS_Desc=:OrdSetname,ARCOS_OrdCat_DR=:OrdCatDR,ARCOS_OrdSubCat_DR=:OrdSubCatDR,ARCOS_EffDateFrom=:NowDate where ARCOS_Code=:ArcCode)
	.i SQLCODE'=0 s retStr="更新医嘱套表失败"_SQLCODE TRollBack  q
	.&SQL(update SQLUser.ARC_Alias set ALIAS_DateFrom=:NowDate,ALIAS_Text=:ArcAlias,ALIAS_OrderSubCat_dr=:OrdSubCatDR,ALIAS_Desc=:OrdSetname where ALIAS_ARCOS_DR=:arcRowId)
	.i SQLCODE'=0 s retStr="更新别名表失败"_SQLCODE TRollBack  q
	.s ARCOSRowid=arcRowId
	i retStr'="0" q retStr
	s ARCOSDateRowid=..GetOrderSetDate(ARCOSRowid)
	i ((ARCOSDateRowid="")!(ARCOSDateRowid="0")) d
	.s DateFrom=+$h
	.&SQL(Insert into sqluser.ARC_OrdSetDate (DATE_ParRef,DATE_DateFrom) values (:ARCOSRowid,:DateFrom))
	.i SQLCODE'=0 s retStr="插入ARC_OrdSetDate表失败"_SQLCODE TRollBack  q
	.s ARCOSDateRowid=..GetOrderSetDate(ARCOSRowid)
	i retStr'="0" q retStr
	s ITMChildsub=$o(^ARCOS(ARCOSRowid,"DATE","1","ITM",0))
	s ^abc(1)=ITMChildsub
	i ITMChildsub>0 d
	.&SQL(delete from SQLUser.ARC_OrdSetDateItem where ITM_ParRef=:ARCOSDateRowid)
	.i SQLCODE'=0 s retStr="删除失败"_SQLCODE TRollBack  q
	i retStr'="0" q retStr

	s ^abc(2)=arcimStr
	f i=1:1:$L(arcimStr,$c(1)) d
	.s arcimItem=$P(arcimStr,$c(1),i)
	.s arcimRowid=$P(arcimItem,"^",1)
	.s arcimNum=$P(arcimItem,"^",2)
	.&SQL(insert into sqluser.ARC_OrdSetDateItem (ITM_ParRef,ITM_ARCIM_DR,ITM_Qty,ITM_Visible) Values (:ARCOSDateRowid,:arcimRowid,:arcimNum,'Y'))
	.i SQLCODE'=0 s retStr="插入失败"_SQLCODE TRollBack  q
	i retStr'="0" q retStr
	TCOMMIT
	q retStr

ERRORInsertOrder	; 
	TRollBack
	s ErrorMsg=$ZE	           //得到系统返回的错误消息
 	q "Insert -1:"_ ErrorMsg
}

/// w ##class(web.DHCANArrange).GetOrderSetDate("416")
ClassMethod GetOrderSetDate(ARCOSRowid As %String) As %String
{
	s DATE=$g(DATE) s:'DATE DATE=+$h
	s ord=+$g(ARCOSRowid) q:'ARCOSRowid 0 
	s dfrom=$o(^ARCOS(ARCOSRowid,"DATE",0,"DateFrom",.1+DATE),-1) q:'dfrom 0
	s drow=$o(^ARCOS(ARCOSRowid,"DATE",0,"DateFrom",dfrom,"")) q:'drow 0
	s dto=$p($g(^ARCOS(ARCOSRowid,"DATE",drow)),"^",2) i dto,dto<DATE q 0
	q ARCOSRowid_"||"_drow
}

ClassMethod SavePrice(EpisodeID As %String, DHCOPERNO As %String, UserID As %String, CTlocDr As %String) As %String
{
	n (EpisodeID,DHCOPERNO,UserID,CTlocDr)
  s ^yjy(345)=EpisodeID_","_DHCOPERNO_","_UserID_","_CTlocDr
  s $zt="ERRORSavePrice"
  q:$p(^PAADM(EpisodeID),"^",2)="O" "-1"
  //w ##class(web.DHCANArrange).SavePrice("1570770","21938","2329")
  Set PriceList=""
  Set SetActiveStr=""
  Set CHARGEITEMNO=0
  Set OEORDItemCount=1
  Set jcount=0,SendTarFlag=""
  k ^TempPriceList("PriceList",$j)
  Set ANADr=$P(^DHCANOPArrange(DHCOPERNO),"^",2)
  Set EXOeoriDr="" For  Set EXOeoriDr=$O(^DHCEXDE(0,"OEORI",EpisodeID,EXOeoriDr)) Q:EXOeoriDr=""  Do
  .Set EXRowid=""  For  Set EXRowid=$O(^DHCEXDE(0,"OEORI",EpisodeID,EXOeoriDr,EXRowid))  Q:EXRowid=""  Do
  ..Set EXStatus=$P($G(^DHCEXDE(EXRowid)),"^",18)
  ..Set AppRowid=$P(^DHCANOPArrange(DHCOPERNO),"^",41)
  ..Set AnaestDR=$P($G(^OEORD(+EXOeoriDr,"I",$P(EXOeoriDr,"||",2),4)),"^",9)
  ..Q:ANADr'=AnaestDR
  ..Set OEState=$p($G(^OEORD(+EXOeoriDr,"I",$P(EXOeoriDr,"||",2),1)),"^",13)
  ..Q:OEState=4
  ..Set EXBillingAttr=$P($G(^DHCEXDE(EXRowid)),"^",17)
  ..Set EXTariDr=$P($G(^DHCEXDE(EXRowid)),"^",7)
  ..Q:EXTariDr=""
  ..Set OPERATORNO="",ITEMCODE=""
  ..Set ItemSubCate=$P($G(^DHCTARI(EXTariDr)),"^",4)
  ..Set ITEMNAME=$P($G(^DHCTARI(EXTariDr)),"^",2)
  ..Set ITEMNAME=$TR(ITEMNAME,"[")
  ..Set ITEMNAME=$TR(ITEMNAME,"]")
  ..Set ITEMCLASSDR=$P($G(^DHCTARI(EXTariDr)),"^",4)
  ..Set ITEMCLASS=$P($G(^DHCTarC("CC",ITEMCLASSDR)),"^",1)
  ..Set ITEMCODE1=$P($G(^DHCTARI(EXTariDr)),"^",1)
  ..If (ItemSubCate=3)||(ItemSubCate=4) Set ITEMCODE=$P($G(^DHCTARI(EXTariDr)),"^",1)
  ..Else  Set ITEMCODE=$P($G(^DHCTARI(EXTariDr)),"^",13)
  ..Set PHCDRowid=""
  ..If (ItemSubCate=3)||(ItemSubCate=4) d
  ...Set PHCDRowid=$O(^PHCD(0,"Code",ITEMCODE,-1))
  ...Q:PHCDRowid=""
  ...Set GenRowid=$P($G(^PHCD(PHCDRowid,4)),"^",1)
  ...Set ITEMCODE=$P($G(^PHCGE("GE",GenRowid)),"^",1)
  ..Set GenericDR=$P($G(^ARCIM(EXTariDr,1,8)),"^",20)
  ..Set ITEMSPEC=""
  ..If (ItemSubCate'=3)&(ItemSubCate'=4) d
  ...Set ITEMSPEC=$P($G(^DHCTARI(EXTariDr)),"^",21)
  ..If (ItemSubCate=3)||(ItemSubCate=4) d
  ...Set ITEMCODE1=$P($G(^DHCTARI(EXTariDr)),"^",1)
  ...Set INCIRowid=$O(^INCI(0,"Code",ITEMCODE1,-1))
  ...Q:INCIRowid=""
  ...Set INFORowid=$O(^DHCITMINFO(0,"INCI",INCIRowid,-1))
  ...Q:INFORowid=""
  ...Set ITEMSPEC=$P($G(^DHCITMINFO(INFORowid)),"^",27)
  ..If ITEMCODE="" Set ITEMCODE=$P($G(^DHCTARI(EXTariDr)),"^",1)
  ..Set TARIUOMDr=$P($G(^DHCTARI(EXTariDr)),"^",3)
  ..Set AMOUNT=$P($G(^DHCEXDE(EXRowid)),"^",8)
  ..Set UNITS=$P($G(^CT("UOM",TARIUOMDr)),"^",2)
  ..set CHECKFLOW=$P(^DHCANOPArrange(DHCOPERNO),"^",41)
  ..Q:CHECKFLOW=""
  ..Set EXAMITEMNO=OEORDItemCount
  ..Set OEORDItemCount=OEORDItemCount+1
  ..;Q:EXAMITEMNO=""
  ..Set PATIENTInfo=##class(web.DHCENS.PatientInfo).GetHisAdmByPaadm(EpisodeID)
  ..Set PATIENTID=""
  ..If $p(^PAADM(EpisodeID),"^",2)="O" d
  ...Set PATIENTID=$P(PATIENTInfo,"^",1)
  ...Set VISITID=""
  ..If $p(^PAADM(EpisodeID),"^",2)="I" d
  ...Set PATIENTID=$P(PATIENTInfo,"^",1)
  ...Set VISITID=$P(PATIENTInfo,"^",3)
  ..Set RecDept=$P($G(^DHCEXDE(EXRowid)),"^",16)
  ..q:RecDept'=CTlocDr
  ..Set OEORIOrdDeptDR=$P($G(^OEORD(+EXOeoriDr,"I",$P(EXOeoriDr,"||",2),7)),"^",2)
  ..;lpd 20110303
  ..q:OEORIOrdDeptDR=""
  ..;q:(RecDept'="311")&(OEORIOrdDeptDR'="311")
  ..;
  ..Set ORDEREDBY=$P($G(^CTLOC(OEORIOrdDeptDR)),"^",1)
  ..Set PERFORMEDBY="" ;
  ..Set PERFORMEDBYDr=$P($G(^OEORD(+EXOeoriDr,"I",$P(EXOeoriDr,"||",2),3)),"^",6)
  ..If PERFORMEDBYDr'="" Set PERFORMEDBY=$P($G(^CTLOC(PERFORMEDBYDr)),"^",1)
  ..Set COSTS=$P($G(^DHCEXDE(EXRowid)),"^",10)
  ..Set CHARGES=$J((COSTS*AMOUNT),3,2)
  ..Set BILLINGTIME=$P($G(^DHCEXDE(EXRowid)),"^",12)
  ..Set EXBillingDate=$P($G(^DHCEXDE(EXRowid)),"^",11)
  ..;Set BILLINGDATETIME=$TR($ZD(EXBillingDate,3),"-")_$TR($ZT(BILLINGTIME),":")
  ..Set BILLINGDATETIME=$TR($ZD(+$h,3),"-")_$TR($ZT($p($h,",",2)),":")
  ..Set OPERATORNODr=$P($G(^DHCEXDE(EXRowid)),"^",14)
  ..If OPERATORNODr'="" Set OPERATORNO=$P($G(^CTPCP(OPERATORNODr,1)),"^",1)

  ..;Set OPERATORNODr=$P($G(^DHCEXDE(EXRowid)),"^",13)
  ..;If OPERATORNODr'="" Set OPERATORNO=$P($G(^SSU("SSUSR",OPERATORNODr)),"^",1)
  ..Set VERIFIEDINDICATOR="01 "
  ..Set DoctorName=""
  ..Set DoctorDr=$P($G(^OEORD(+EXOeoriDr,"I",$P(EXOeoriDr,"||",2),1)),"^",11)
  ..If DoctorDr'="" Set DoctorName=$P($g(^CTPCP(DoctorDr,1)),"^",2)
  ..Set BILLINGATTR="0"
  ..If $P($G(^DHCEXDE(EXRowid)),"^",17)="1" Set BILLINGATTR="1" 
  ..Set Status="A" 
  ..if EXStatus="F" Set Status="F" 
  ..Set DHCKey=EXRowid
  ..If (ItemSubCate=3)||(ItemSubCate=4) Set ITEMNAME=$TR(ITEMNAME,ITEMSPEC)
  ..If $p(^PAADM(EpisodeID),"^",2)="O" Do
  ...;Set CHARGEITEMNO=CHARGEITEMNO+1
  ...Set CHARGEITEMNO=""
  ...Set ItemNoRwoid=0 For  Set ItemNoRwoid=$O(^DHCEXDEItem(AppRowid,"OEORI",EXOeoriDr,ItemNoRwoid)) Q:ItemNoRwoid=""  Do
  ....Set ItemNoAppRowid=^DHCEXDEItem(AppRowid,"OEORI",EXOeoriDr,ItemNoRwoid)
  ....If ItemNoAppRowid=EXRowid Set CHARGEITEMNO=ItemNoRwoid
  ...set CHECKFLOW=$P(^DHCANOPArrange(DHCOPERNO),"^",41)
  ...Set PriceList=PriceList_"<OutBillItemsOper>"
  ...Set PriceList=PriceList_"<OperaApplyFlow>"_CHECKFLOW_"</OperaApplyFlow>"
  ...Set PriceList=PriceList_"<OperItemNo>"_EXAMITEMNO_"</OperItemNo>"
  ...Set PriceList=PriceList_"<ChargeItemNo>"_CHARGEITEMNO_"</ChargeItemNo>"
  ...Set PriceList=PriceList_"<PatientId>"_PATIENTID_"</PatientId>"
  ...Set PriceList=PriceList_"<VisitId>"_VISITID_"</VisitId>"
  ...Set PriceList=PriceList_"<ItemClass>"_ITEMCLASS_"</ItemClass>"
  ...Set PriceList=PriceList_"<ItemName>"_ITEMNAME_"</ItemName>"
  ...Set PriceList=PriceList_"<ItemCode>"_ITEMCODE_"</ItemCode>"
  ...Set PriceList=PriceList_"<ItemSpec>"_ITEMSPEC_"</ItemSpec>"
  ...Set PriceList=PriceList_"<Amount>"_AMOUNT_"</Amount>"
  ...Set PriceList=PriceList_"<Units>"_UNITS_"</Units>"
  ...Set PriceList=PriceList_"<OrderedBy>"_ORDEREDBY_"</OrderedBy>"
  ...Set PriceList=PriceList_"<PerformedBy>"_PERFORMEDBY_"</PerformedBy>"
  ...Set PriceList=PriceList_"<Costs>"_COSTS_"</Costs>"
  ...Set PriceList=PriceList_"<Charges>"_CHARGES_"</Charges>"
  ...Set PriceList=PriceList_"<BillingDateTime>"_BILLINGDATETIME_"</BillingDateTime>"
  ...Set PriceList=PriceList_"<OperatorNo>"_OPERATORNO_"</OperatorNo>"
  ...Set PriceList=PriceList_"<VerifiedIndicator>"_VERIFIEDINDICATOR_"</VerifiedIndicator>"
  ...Set PriceList=PriceList_"<DoctorName>"_DoctorName_"</DoctorName>"
  ...Set PriceList=PriceList_"<BillingAttr>"_BILLINGATTR_"</BillingAttr>"
  ...Set PriceList=PriceList_"<Status>"_Status_"</Status>"
  ...Set PriceList=PriceList_"<DhcKey>"_DHCKey_"</DhcKey>"
  ...Set PriceList=PriceList_"<DHCCode>"_ITEMCODE1_"</DHCCode>"
  ...Set PriceList=PriceList_"</OutBillItemsOper>"
  ..
  ..If $p(^PAADM(EpisodeID),"^",2)="I" Do
  ...;Set PriceStatus=$P($G(^DHCEXDE(EXRowid)),"^",17)
  ...;Set CHARGEITEMNO=CHARGEITEMNO+1
  ...Set CHARGEITEMNO=""
  ...Set ItemNoRwoid=0 For  Set ItemNoRwoid=$O(^DHCEXDEItem(AppRowid,"OEORI",EXOeoriDr,ItemNoRwoid)) Q:ItemNoRwoid=""  Do
  ....Set ItemNoAppRowid=^DHCEXDEItem(AppRowid,"OEORI",EXOeoriDr,ItemNoRwoid)
  ....If ItemNoAppRowid=EXRowid Set CHARGEITEMNO=ItemNoRwoid
  ...if EXStatus="F" Set AMOUNT=-AMOUNT,COSTS=-COSTS
  ...set CHECKFLOW=$P(^DHCANOPArrange(DHCOPERNO),"^",41)
  ...Set jcount=jcount+1
  ...Set PriceList=PriceList_"<InpBilldetailOper>"
  ...Set PriceList=PriceList_"<OperaApplyFlow>"_CHECKFLOW_"</OperaApplyFlow>"
  ...Set PriceList=PriceList_"<OperItemNo>"_EXAMITEMNO_"</OperItemNo>"
  ...Set PriceList=PriceList_"<ChargeItemNo>"_CHARGEITEMNO_"</ChargeItemNo>"
  ...Set PriceList=PriceList_"<PatientId>"_PATIENTID_"</PatientId>"
  ...Set PriceList=PriceList_"<VisitId>"_VISITID_"</VisitId>"
  ...Set PriceList=PriceList_"<ItemNo>"_EXAMITEMNO_"</ItemNo>"
  ...Set PriceList=PriceList_"<ItemClass>"_ITEMCLASS_"</ItemClass>"
  ...Set PriceList=PriceList_"<ItemName>"_ITEMNAME_"</ItemName>"
  ...Set PriceList=PriceList_"<ItemCode>"_ITEMCODE_"</ItemCode>"
  ...Set PriceList=PriceList_"<ItemSpec>"_ITEMSPEC_"</ItemSpec>"
  ...Set PriceList=PriceList_"<Amount>"_AMOUNT_"</Amount>"
  ...Set PriceList=PriceList_"<Units>"_UNITS_"</Units>"
  ...Set PriceList=PriceList_"<OrderedBy>"_ORDEREDBY_"</OrderedBy>"
  ...Set PriceList=PriceList_"<PerformedBy>"_PERFORMEDBY_"</PerformedBy>"
  ...Set PriceList=PriceList_"<Costs>"_COSTS_"</Costs>"
  ...Set PriceList=PriceList_"<Charges>"_CHARGES_"</Charges>"
  ...Set PriceList=PriceList_"<BillingDateTime>"_BILLINGDATETIME_"</BillingDateTime>"
  ...Set PriceList=PriceList_"<OperatorNo>"_OPERATORNO_"</OperatorNo>"
  ...Set PriceList=PriceList_"<DhcPbd>"_DHCKey_"</DhcPbd>"
  ...Set PriceList=PriceList_"<DoctorName>"_DoctorName_"</DoctorName>"
  ...Set PriceList=PriceList_"<DHCCode>"_ITEMCODE1_"</DHCCode>"
  ...Set PriceList=PriceList_"</InpBilldetailOper>"
  ...Set ^TempPriceList("PriceList",$j,jcount)=PriceList
  ...Set PriceList=""
  ..i SetActiveStr="" s SetActiveStr=EXRowid
  ..e  Set SetActiveStr=SetActiveStr_"^"_EXRowid

  ;if PriceList="" q "-100"
  if $g(^TempPriceList("PriceList",$j,1))="" q "-100"
  If $p(^PAADM(EpisodeID),"^",2)="O" Do
  .Set Str="<Request><OutBillItemsOperList>"
  .Set Str=Str_PriceList_"</OutBillItemsOperList></Request>"
  .s StreamTarStr=##class(%GlobalCharacterStream).%New()
  .s StreamSendTarFlag=##class(%GlobalCharacterStream).%New()
  .d StreamTarStr.Write(Str)
  .;lpd 20120413
  .;s obj=##class(web.DHCENS.WebService.DHCSoap).%New()
  .s obj=##class(web.DHCENS.WebServiceNew.DHCCRisXiangYaOneSoap).%New()
  .s StreamSendTarFlag=obj.DhcService("OutBillItemsOper",StreamTarStr)
  .d StreamSendTarFlag.Rewind()
  .s Len=StreamSendTarFlag.SizeGet()
  .d StreamSendTarFlag.Rewind()
  .s SendTarFlag=StreamSendTarFlag.Read(Len)
  .Set PAADMType1=$p(^PAADM(EpisodeID),"^",2)
  .Set SendTarFlag=$P(SendTarFlag,"Returncode>",2)
  .If (SendTarFlag="0</") Set ActiveFlag=##class(web.DHCOperPrice).SetStatus(SetActiveStr,PAADMType1,UserID)

  Set PAADMType1=$p(^PAADM(EpisodeID),"^",2)
  if $g(^TempPriceList("PriceList",$j,1))="" q "-100"
  ;if PriceList="" q "-100"
  s itime=""
  i jcount#10'="0" s itime=jcount\10+1
  e  s itime=jcount/10
  If $p(^PAADM(EpisodeID),"^",2)="I" Do
  .s flag=1
  .f icount=1:1:itime d
  ..q:flag=0
  ..s PriceListStr="",DHCKeyStr=""
  ..s istart=icount*10-9,iend=icount*10
  ..f ln=istart:1:iend d
  ...q:ln>jcount
  ...s PriceListStr=PriceListStr_$G(^TempPriceList("PriceList",$j,ln))
  ...i DHCKeyStr="" s DHCKeyStr=$p(SetActiveStr,"^",ln)
  ...e  s DHCKeyStr=DHCKeyStr_"^"_$p(SetActiveStr,"^",ln)
  ..Set Str="<Request><InpBilldetailOperList>"
  ..Set Str=Str_PriceListStr_"</InpBilldetailOperList></Request>"
  ..s StreamTarStr=##class(%GlobalCharacterStream).%New()
  ..s StreamSendTarFlag=##class(%GlobalCharacterStream).%New()
  ..d StreamTarStr.Write(Str)
  ..;lpd 20120413
  ..;s obj=##class(web.DHCENS.WebService.DHCSoap).%New()
  ..s obj=##class(web.DHCENS.WebServiceNew.DHCCRisXiangYaOneSoap).%New()
  ..s StreamSendTarFlag=obj.DhcService("InpBilldetailOper",StreamTarStr)
  ..d StreamSendTarFlag.Rewind()
  ..s Len=StreamSendTarFlag.SizeGet()
  ..d StreamSendTarFlag.Rewind()
  ..s SendTarFlag1=StreamSendTarFlag.Read(Len)
  ..s SendTarFlag=""
  ..Set SendTarFlag=$P(SendTarFlag1,"Returncode>",2)
  ..If (SendTarFlag'="0</") d
  ...s flag=0
  ...s SendTarFlag=$p(SendTarFlag1,"ResultContent>",2)
  ..s ActiveFlag=0
  ..If flag=1 Set ActiveFlag=##class(web.DHCANArrange).SetStatus(DHCKeyStr,PAADMType1,UserID)
  ..i ActiveFlag'="1" s flag=0

  q SendTarFlag
ERRORSavePrice	; 
	TRollBack
	s ErrorMsg=$ZE	           //得到系统返回的错误消息
 	q "-1 SavePrice"_ ErrorMsg
}

ClassMethod SetStatus(SetActiveStr As %String, PAADMType As %String, UserID As %String) As %String
{
	new (SetActiveStr,PAADMType,UserID)
	Set NowDate=+$h
	Set NowTime=$P($h,",",2)
	Tstart
	For i=1:1:$L(SetActiveStr,"^") Do
	.Set flg=1
	.Set ExaRowid=$P(SetActiveStr,"^",i)
	.Q:ExaRowid=""
	.Set EXStatus=$P($G(^DHCEXDE(ExaRowid)),"^",18)
	.Q:EXStatus="F"
	.Set EXBillingAttr=$P($G(^DHCEXDE(ExaRowid)),"^",17)
	.Q:EXBillingAttr'=""
	.Set NowDate=+$h
	.Set NowTime=$P($h,",",2)
	.if PAADMType="I" do
	..//&sql(Update SQLUSER.DHC_ExamDetails Set EX_Status='A',EX_Billing_Attr='1',EX_chargeUser_Dr=:UserID,EX_Billingcharge_Date=:NowDate,EX_Billingcharge_Time=:NowTime Where EX_Rowid=:ExaRowid)
	..If SQLCODE'=0 Set flg=0 TRollback
	.if PAADMType="O" do
	..//&sql(Update SQLUSER.DHC_ExamDetails Set EX_Status='A',EX_Billing_Attr='0',EX_chargeUser_Dr=:UserID,EX_Billingcharge_Date=:NowDate,EX_Billingcharge_Time=:NowTime Where EX_Rowid=:ExaRowid)
	..If SQLCODE'=0 Set flg=0 TRollback
	TC
	Q flg
}

ClassMethod ReturnFee(ReturnStr As %String, DHCANORowid As %String, EpisodeID As %String, Usrid As %String) As %String
{
  //w ##class(web.DHCOperPrice).ReturnFee("240997","181880","10390431","3819")
  Set ^yjy(100)=ReturnStr
  Set PriceList=""
  Set SetActiveStr=""
  Set CHARGEITEMNO=0
  Set OEORDItemCount=1
  Set OEORDRowId=$O(^OEORD(0,"Adm",EpisodeID,-1))
  Set OPERDr=$P(^DHCANOPArrange(DHCANORowid),"^",2)
  Set AppRowid=$P(^DHCANOPArrange(DHCANORowid),"^",41)
  //2010-4-19上午,因退费时报Status未定义,因此在此定义一下,且赋空值
  Set Status=""
  If OEORDRowId="" Q "-1"
  Set ChildOEORDRowId=0 For  Set ChildOEORDRowId=$O(^OEORD(OEORDRowId,"I",ChildOEORDRowId)) Q:ChildOEORDRowId=""  Do
  .Set AnaestDR=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,4)),"^",9)
  .q:AnaestDR'=OPERDr
  .Set ItmMast=$P($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",2)
  .Set OEORIItemStat=$p($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",13)
  .Set OEState=$p($G(^OEORD(OEORDRowId,"I",ChildOEORDRowId,1)),"^",13)
  .Q:OEORIItemStat="4"
  .Set ExaTarInfo=""
  .Set EXOeoriDr=OEORDRowId_"||"_ChildOEORDRowId
  .Set OEORDRowId=OEORDRowId
  .Set ChildOEORDRowId=ChildOEORDRowId
  .Set EXRowid=""  For  Set EXRowid=$O(^DHCEXDE(0,"OEORI",EpisodeID,EXOeoriDr,EXRowid))  Q:EXRowid=""  Do
  ..Set EXStatus=$P($G(^DHCEXDE(EXRowid)),"^",18)
  ..Set EXBillingAttr=$P($G(^DHCEXDE(EXRowid)),"^",17)
  ..Set EXTariDr=$P($G(^DHCEXDE(EXRowid)),"^",7)
  ..Q:EXTariDr=""
  ..Set OPERATORNO="",ITEMCODE=""
  ..Set ItemSubCate=$P($G(^DHCTARI(EXTariDr)),"^",4)
  ..Set ITEMNAME=$P($G(^DHCTARI(EXTariDr)),"^",2)
  ..Set ITEMNAME=$TR(ITEMNAME,"[")
  ..Set ITEMNAME=$TR(ITEMNAME,"]")
  ..Set ITEMCLASSDR=$P($G(^DHCTARI(EXTariDr)),"^",4)
  ..Set ITEMCLASS=$P($G(^DHCTarC("CC",ITEMCLASSDR)),"^",1)
  ..Set ITEMCODE1=$P($G(^DHCTARI(EXTariDr)),"^",1)
  ..If (ItemSubCate=3)||(ItemSubCate=4) Set ITEMCODE=$P($G(^DHCTARI(EXTariDr)),"^",1)
  ..Else  Set ITEMCODE=$P($G(^DHCTARI(EXTariDr)),"^",13)
  ..Set PHCDRowid=""
  ..If (ItemSubCate=3)||(ItemSubCate=4) d
  ...Set PHCDRowid=$O(^PHCD(0,"Code",ITEMCODE,-1))
  ...Q:PHCDRowid=""
  ...Set GenRowid=$P($G(^PHCD(PHCDRowid,4)),"^",1)
  ...Set ITEMCODE=$P($G(^PHCGE("GE",GenRowid)),"^",1)
  ..Set GenericDR=$P($G(^ARCIM(EXTariDr,1,8)),"^",20)
  ..Set ITEMSPEC=""  
  ..If (ItemSubCate'=3)&(ItemSubCate'=4) d
  ...Set ITEMSPEC=$P($G(^DHCTARI(EXTariDr)),"^",21)
  ..If (ItemSubCate=3)||(ItemSubCate=4) d
  ...Set ITEMCODE1=$P($G(^DHCTARI(EXTariDr)),"^",1)
  ...Set INCIRowid=$O(^INCI(0,"Code",ITEMCODE1,-1))
  ...Q:INCIRowid=""
  ...Set INFORowid=$O(^DHCITMINFO(0,"INCI",INCIRowid,-1))
  ...Q:INFORowid=""
  ...Set ITEMSPEC=$P($G(^DHCITMINFO(INFORowid)),"^",27)
  ..If ITEMCODE="" Set ITEMCODE=$P($G(^DHCTARI(EXTariDr)),"^",1)
  ..Set TARIUOMDr=$P($G(^DHCTARI(EXTariDr)),"^",3)
  ..Set AMOUNT=$P($G(^DHCEXDE(EXRowid)),"^",8)
  ..Set UNITS=$P($G(^CT("UOM",TARIUOMDr)),"^",2)
  ..set CHECKFLOW=$P(^DHCANOPArrange(DHCANORowid),"^",41)
  ..Q:CHECKFLOW=""
  ..Set EXAMITEMNO=OEORDItemCount
  ..Set OEORDItemCount=OEORDItemCount+1
  ..Set PATIENTInfo=##class(web.DHCENS.PatientInfo).GetHisAdmByPaadm(EpisodeID)
  ..If $p(^PAADM(EpisodeID),"^",2)="O" d
  ...Set PATIENTID=$P(PATIENTInfo,"^",1)
  ...Set VISITID=""
  ..If $p(^PAADM(EpisodeID),"^",2)="I" d
  ...Set PATIENTID=$P(PATIENTInfo,"^",1)
  ...Set VISITID=$P(PATIENTInfo,"^",3)
  ..Set OEORIOrdDeptDR=$P($G(^OEORD(+EXOeoriDr,"I",$P(EXOeoriDr,"||",2),7)),"^",2)
  ..q:OEORIOrdDeptDR=""
  ..Set ORDEREDBY=$P($G(^CTLOC(OEORIOrdDeptDR)),"^",1)
  ..Set RecDept=$P($G(^DHCEXDE(EXRowid)),"^",16)
  ..Set PERFORMEDBY="" ;
  ..Set PERFORMEDBYDr=$P($G(^OEORD(+EXOeoriDr,"I",$P(EXOeoriDr,"||",2),3)),"^",6)
  ..If PERFORMEDBYDr'="" Set PERFORMEDBY=$P($G(^CTLOC(PERFORMEDBYDr)),"^",1)
  ..Set COSTS=$P($G(^DHCEXDE(EXRowid)),"^",10)
  ..Set CHARGES=$J((COSTS*AMOUNT),3,2)
  ..Set BILLINGTIME=$P($G(^DHCEXDE(EXRowid)),"^",12)
  ..Set EXBillingDate=$P($G(^DHCEXDE(EXRowid)),"^",11)
  ..;Set BILLINGDATETIME=$TR($ZD(EXBillingDate,3),"-")_$TR($ZT(BILLINGTIME),":")
  ..Set BILLINGDATETIME=$TR($ZD(+$h,3),"-")_$TR($ZT($p($h,",",2)),":")
  ..Set OPERATORNODr=$P($G(^DHCEXDE(EXRowid)),"^",14)
  ..If OPERATORNODr'="" Set OPERATORNO=$P($G(^CTPCP(OPERATORNODr,1)),"^",1)

  ..;Set OPERATORNODr=$P($G(^DHCEXDE(EXRowid)),"^",13)
  ..;If OPERATORNODr'="" Set OPERATORNO=$P($G(^SSU("SSUSR",OPERATORNODr)),"^",1)
  ..Set VERIFIEDINDICATOR="01 "
  ..Set DoctorName=""
  ..Set DoctorDr=$P($G(^OEORD(+EXOeoriDr,"I",$P(EXOeoriDr,"||",2),1)),"^",11)
  ..If DoctorDr'="" Set DoctorName=$P($g(^CTPCP(DoctorDr,1)),"^",2)
  ..Set BILLINGATTR="0"
  ..If $P($G(^DHCEXDE(EXRowid)),"^",17)="1" Set BILLINGATTR="1" 
  ..if EXStatus'="F" Set Status="A" 
  ..Set DHCKey=EXRowid
  ..If (ItemSubCate=3)||(ItemSubCate=4) Set ITEMNAME=$TR(ITEMNAME,ITEMSPEC)
  ..q:ReturnStr'[EXRowid
  ..If $p(^PAADM(EpisodeID),"^",2)="O" Do
  ...;Set CHARGEITEMNO=CHARGEITEMNO+1
  ...Set CHARGEITEMNO=""
  ...Set ItemNoRwoid=0 For  Set ItemNoRwoid=$O(^DHCEXDEItem(AppRowid,"OEORI",EXOeoriDr,ItemNoRwoid)) Q:ItemNoRwoid=""  Do
  ....Set ItemNoAppRowid=^DHCEXDEItem(AppRowid,"OEORI",EXOeoriDr,ItemNoRwoid)
  ....If ItemNoAppRowid=EXRowid Set CHARGEITEMNO=ItemNoRwoid
  ...Set RetFlag=0
  ...For l=1:1:$L(ReturnStr,"^") Do
  ....Set RetRowid=$P(ReturnStr,"^",l)
  ....If RetRowid=EXRowid Set RetFlag=1
  ...if RetFlag=1 Set Status="F",OPERATORNO=$P(^SSU("SSUSR",Usrid),"^",1)    ;$P(^CTPCP(Usrid,1),"^",1)
   ...Set PriceList=PriceList_"<OutBillItemsOper>"
  ...Set PriceList=PriceList_"<OperaApplyFlow>"_CHECKFLOW_"</OperaApplyFlow>"
  ...Set PriceList=PriceList_"<OperItemNo>"_EXAMITEMNO_"</OperItemNo>"
  ...Set PriceList=PriceList_"<ChargeItemNo>"_CHARGEITEMNO_"</ChargeItemNo>"
  ...Set PriceList=PriceList_"<PatientId>"_PATIENTID_"</PatientId>"
  ...Set PriceList=PriceList_"<VisitId>"_VISITID_"</VisitId>"
  ...Set PriceList=PriceList_"<ItemClass>"_ITEMCLASS_"</ItemClass>"
  ...Set PriceList=PriceList_"<ItemName>"_ITEMNAME_"</ItemName>"
  ...Set PriceList=PriceList_"<ItemCode>"_ITEMCODE_"</ItemCode>"
  ...Set PriceList=PriceList_"<ItemSpec>"_ITEMSPEC_"</ItemSpec>"
  ...Set PriceList=PriceList_"<Amount>"_AMOUNT_"</Amount>"
  ...Set PriceList=PriceList_"<Units>"_UNITS_"</Units>"
  ...Set PriceList=PriceList_"<OrderedBy>"_ORDEREDBY_"</OrderedBy>"
  ...Set PriceList=PriceList_"<PerformedBy>"_PERFORMEDBY_"</PerformedBy>"
  ...Set PriceList=PriceList_"<Costs>"_COSTS_"</Costs>"
  ...Set PriceList=PriceList_"<Charges>"_CHARGES_"</Charges>"
  ...Set PriceList=PriceList_"<BillingDateTime>"_BILLINGDATETIME_"</BillingDateTime>"
  ...Set PriceList=PriceList_"<OperatorNo>"_OPERATORNO_"</OperatorNo>"
  ...Set PriceList=PriceList_"<VerifiedIndicator>"_VERIFIEDINDICATOR_"</VerifiedIndicator>"
  ...Set PriceList=PriceList_"<DoctorName>"_DoctorName_"</DoctorName>"
  ...Set PriceList=PriceList_"<BillingAttr>"_BILLINGATTR_"</BillingAttr>"
  ...Set PriceList=PriceList_"<Status>"_Status_"</Status>"
  ...Set PriceList=PriceList_"<DhcKey>"_DHCKey_"</DhcKey>"
  ...Set PriceList=PriceList_"<DHCCode>"_ITEMCODE1_"</DHCCode>"
  ...Set PriceList=PriceList_"</OutBillItemsOper>"
  
  ..If $p(^PAADM(EpisodeID),"^",2)="I" Do
  ...;Set CHARGEITEMNO=CHARGEITEMNO+1
  ...Set CHARGEITEMNO=""
  ...Set ItemNoRwoid=0 For  Set ItemNoRwoid=$O(^DHCEXDEItem(AppRowid,"OEORI",EXOeoriDr,ItemNoRwoid)) Q:ItemNoRwoid=""  Do
  ....Set ItemNoAppRowid=^DHCEXDEItem(AppRowid,"OEORI",EXOeoriDr,ItemNoRwoid)
  ....If ItemNoAppRowid=EXRowid Set CHARGEITEMNO=ItemNoRwoid
  ...Set RetFlag=0
  ...For l=1:1:$L(ReturnStr,"^") Do
  ....Set RetRowid=$P(ReturnStr,"^",l)
  ....If RetRowid=EXRowid Set RetFlag=1,AMOUNT=-AMOUNT,COSTS=-COSTS,OPERATORNO=$P(^SSU("SSUSR",Usrid),"^",1)   ;$P(^CTPCP(Usrid,1),"^",1)
  ...if EXStatus="F"  Set AMOUNT=-AMOUNT,COSTS=-COSTS
  ...Set PriceList=PriceList_"<InpBilldetailOper>"
  ...Set PriceList=PriceList_"<OperaApplyFlow>"_CHECKFLOW_"</OperaApplyFlow>"
  ...Set PriceList=PriceList_"<OperItemNo>"_EXAMITEMNO_"</OperItemNo>"
  ...Set PriceList=PriceList_"<ChargeItemNo>"_CHARGEITEMNO_"</ChargeItemNo>"
  ...Set PriceList=PriceList_"<PatientId>"_PATIENTID_"</PatientId>"
  ...Set PriceList=PriceList_"<VisitId>"_VISITID_"</VisitId>"
  ...Set PriceList=PriceList_"<ItemNo>"_EXAMITEMNO_"</ItemNo>"
  ...Set PriceList=PriceList_"<ItemClass>"_ITEMCLASS_"</ItemClass>"
  ...Set PriceList=PriceList_"<ItemName>"_ITEMNAME_"</ItemName>"
  ...Set PriceList=PriceList_"<ItemCode>"_ITEMCODE_"</ItemCode>"
  ...Set PriceList=PriceList_"<ItemSpec>"_ITEMSPEC_"</ItemSpec>"
  ...Set PriceList=PriceList_"<Amount>"_AMOUNT_"</Amount>"
  ...Set PriceList=PriceList_"<Units>"_UNITS_"</Units>"
  ...Set PriceList=PriceList_"<OrderedBy>"_ORDEREDBY_"</OrderedBy>"
  ...Set PriceList=PriceList_"<PerformedBy>"_PERFORMEDBY_"</PerformedBy>"
  ...Set PriceList=PriceList_"<Costs>"_COSTS_"</Costs>"
  ...Set PriceList=PriceList_"<Charges>"_CHARGES_"</Charges>"
  ...Set PriceList=PriceList_"<BillingDateTime>"_BILLINGDATETIME_"</BillingDateTime>"
  ...Set PriceList=PriceList_"<OperatorNo>"_OPERATORNO_"</OperatorNo>"
  ...Set PriceList=PriceList_"<DhcPbd>"_DHCKey_"</DhcPbd>"
  ...Set PriceList=PriceList_"<DoctorName>"_DoctorName_"</DoctorName>"
  ...Set PriceList=PriceList_"<DHCCode>"_ITEMCODE1_"</DHCCode>"
  ...Set PriceList=PriceList_"</InpBilldetailOper>"
  ..Set SetActiveStr=SetActiveStr_"^"_EXRowid

  if PriceList="" q "-100"
  If $p(^PAADM(EpisodeID),"^",2)="O" Do
   .Set Str="<Request><OutBillItemsOperList>"
  .Set Str=Str_PriceList_"</OutBillItemsOperList></Request>"
  .s StreamTarStr=##class(%GlobalCharacterStream).%New()
  .s StreamSendTarFlag=##class(%GlobalCharacterStream).%New()
  .d StreamTarStr.Write(Str)
  .;lpd 20120413
  .;s obj=##class(web.DHCENS.WebService.DHCSoap).%New()
  .s obj=##class(web.DHCENS.WebServiceNew.DHCCRisXiangYaOneSoap).%New()
  .s StreamSendTarFlag=obj.DhcService("OutBillItemsOper",StreamTarStr)
  .d StreamSendTarFlag.Rewind()
  .s Len=StreamSendTarFlag.SizeGet()
  .d StreamSendTarFlag.Rewind()
  .s SendTarFlag=StreamSendTarFlag.Read(Len)
  .Set PAADMType1=$p(^PAADM(EpisodeID),"^",2)
  .Set SendTarFlag=$P(SendTarFlag,"Returncode>",2)
  .If (SendTarFlag="0</") Set ActiveFlag=..SetReturnStatus(ReturnStr)
 
  if PriceList="" q "-100"
  If $p(^PAADM(EpisodeID),"^",2)="I" Do
  .Set Str="<Request><InpBilldetailOperList>"
  .Set Str=Str_PriceList_"</InpBilldetailOperList></Request>"
  .s StreamTarStr=##class(%GlobalCharacterStream).%New()
  .s StreamSendTarFlag=##class(%GlobalCharacterStream).%New()
  .d StreamTarStr.Write(Str)
  .;lpd 20120413
  .;s obj=##class(web.DHCENS.WebService.DHCSoap).%New()
  .s obj=##class(web.DHCENS.WebServiceNew.DHCCRisXiangYaOneSoap).%New()
  .s StreamSendTarFlag=obj.DhcService("InpBilldetailOper",StreamTarStr)
  .d StreamSendTarFlag.Rewind()
  .s Len=StreamSendTarFlag.SizeGet()
  .d StreamSendTarFlag.Rewind()
  .s SendTarFlag=StreamSendTarFlag.Read(Len)
  .Set PAADMType1=$p(^PAADM(EpisodeID),"^",2)
  .Set SendTarFlag=$P(SendTarFlag,"Returncode>",2)
  .If (SendTarFlag="0</") Set ActiveFlag=..SetReturnStatus(ReturnStr,Usrid)
  q SendTarFlag
}

ClassMethod SetReturnStatus(ReturnStr As %String, Usrid As %String) As %String
{
	Set Flag=0
	s RetDate=+$H
	s RetTime=$p($h,",",2)
	s ^Tempabc(1)=RetDate_"^"_RetTime_"^"_Usrid
	Tstart
	For i=1:1:$L(ReturnStr,"^") Do
	.Set ExaRowid=$P(ReturnStr,"^",i)
	.Q:ExaRowid=""
	.//&sql(Update SQLUSER.DHC_ExamDetails Set EX_Status='F',EX_Billing_Attr='F',EX_ReturnDate=:RetDate,EX_ReturnTime=:RetTime,EX_ReturnUserId=:Usrid Where EX_Rowid=:ExaRowid)
	.If (SQLCODE=0) d  Set Flag=1
	.Else  TRollback "-1"
	TCOMMIT
	Q Flag
}

/// w ##class(web.DHCANArrange).Test1()
ClassMethod Test1()
{
	q:"-1"
	S i=0
    f date=52189:1:62289 d
	.s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
	..s i=i+1
	..q:$d(^DHCANOPArrange(opaId))<1
	..s $P(^DHCANOPArrange(opaId),"^",43)=""
	q "0"
	..s adm=$P(^DHCANOPArrange(opaId),"^",1)
	..q:adm=""
	..s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	..i $l($g(^OR(adm,"ANA",chl,"TXT",1)),"|")>1 d
	...i $g(^OR(adm,"ANA",chl,"TXT",2))="" s ^OR(adm,"ANA",chl,"TXT",2)=$p(^OR(adm,"ANA",chl,"TXT",1),"|",1)
	...i $g(^OR(adm,"ANA",chl,"TXT",3))="" s ^OR(adm,"ANA",chl,"TXT",3)=$p(^OR(adm,"ANA",chl,"TXT",1),"|",2)
	..e  d
	...i $g(^OR(adm,"ANA",chl,"TXT",2))="" s ^OR(adm,"ANA",chl,"TXT",2)=^OR(adm,"ANA",chl,"TXT",1)
	..s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:subchl=""  d
	...i $g(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))="" s ^OR(adm,"ANA",chl,"OP",subchl,"REM",2)=^OR(adm,"ANA",chl,"OP",subchl,"REM",1)
	...s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6)
	...i opdr'=""  s $p(^OR(adm,"ANA",chl,"OP",subchl,"DHC"),"^",2)=opdr
	...;e  s $p(^OR(adm,"ANA",chl,"OP",subchl,"DHC"),"^",2)=$G(^OR(adm,"ANA",chl,"OP",subchl,"REM",1))
	q "0"
}

/// w ##class(web.DHCANArrange).GetRoomIdByRoomDesc("20")
ClassMethod GetRoomIdByRoomDesc(desc As %String) As %String
{
	q:desc=""
	s roomId="",retStr=""
	f  s roomId=$o(^DHCANC("OPRoom",roomId)) q:roomId=""  d
	.s oproomdes=$p($g(^DHCANC("OPRoom",roomId)),"^",2)
	.q:oproomdes'=desc
	.s retStr=roomId
	q retStr
}

/// d ##class(%ResultSet).RunQuery("web.DHCANArrange","GetConsumables","23654","3819","311")
Query GetConsumables(opaId As %String, userId As %String, ctlocId As %String) As %Query(ROWSPEC = "arcimDesc,arcimId,qtyNum,price,oeoriId")
{
}

ClassMethod GetConsumablesExecute(ByRef qHandle As %Binary, opaId As %String, userId As %String, ctlocId As %String) As %Status
{
	s repid=$I(^CacheTemp)	
	s ind=1
	
	q:opaId="" "opaId不能为空！"
	s ret=""
	s rset=##class(%ResultSet).%New("web.DHCANOPCom:FindAnaOEOrdItem")
	d rset.Execute(opaId,userId,ctlocId)
	while (rset.Next()) {
		s arcimDesc=rset.GetData(1)
		s arcimId=rset.GetData(2)
		s qtyNum=rset.GetData(3)
		s price=rset.GetData(4)
		s oeoriId=rset.GetData(7)
		s ordCatId=##class(web.DHCCLCom).GetOrdCatId(oeoriId)
		i ((ordCatId="4")&(price>=400)) d
		.d OutputConsumables
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputConsumables
	set Data=$lb(arcimDesc,arcimId,qtyNum,price,oeoriId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetConsumablesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConsumablesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetConsumablesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConsumablesExecute ]
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

/// 麻醉医生返回DOCTOR麻醉护士返回NURSE
/// w ##class(web.DHCANArrange).GetUserIdentity("2329")
ClassMethod GetUserIdentity(userId As %String) As %String
{
	q:userId="" "用户Id不能为空!"
	s ctlocId=$p(^SSU("SSUSR",userId),"^",4)
	;q:ctlocId'="52" "该用户非麻醉科用户!"
	q:ctlocId'="52" ""
	s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	q:ctpcpId="" "该用户未关联到医护人员!"
	s ctcptId=$P($g(^CTPCP(ctpcpId,1)),"^",4)
	q:ctcptId="" "该用户未定义医护类型!"
    s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)
	q:ctcptInternalType="" "该用户类型错误!"
	q ctcptInternalType
}

/// w ##class(web.DHCANArrange).GetAnNote("19/07/2011","19/07/2011","0")
ClassMethod GetAnNote(stdate As %String, enddate As %String, IsAppT As %String) As %String
{
	n (stdate,enddate,IsAppT)
	s retStr=""
	s date=+$H
	s stdate=##Class(web.DHCCLCom).ConvertToDateH(stdate)
	s enddate=##Class(web.DHCCLCom).ConvertToDateH(enddate)
	;s enddate=enddate+IsAppT
	i IsAppT=0 s date=stdate
	e  s date=stdate+1
	s retStr=$p($g(^DHCAnDocNote("Date",date)),"^",1)
	;s retStr=$g(^TempAnDocNote("Date",date))
	q retStr
}

/// d ##class(%ResultSet).RunQuery("web.DHCANArrange","GetAnNote1","24/10/2014","24/10/2014","0")
Query GetAnNote1(stdate As %String, enddate As %String, IsAppT As %String) As %Query(ROWSPEC = "notestr")
{
}

ClassMethod GetAnNote1Execute(ByRef qHandle As %Binary, stdate As %String, enddate As %String, IsAppT As %String) As %Status
{
	s repid=$I(^CacheTemp)	
	s ind=1
	
	s retStr=""
	s date=+$H
	s stdate=##Class(web.DHCCLCom).ConvertToDateH(stdate)
	s enddate=##Class(web.DHCCLCom).ConvertToDateH(enddate)
	;s enddate=enddate+IsAppT
	i IsAppT=0 s date=stdate
	e  s date=stdate+1
	s notestr=$g(^DHCAnDocNote("Date",date))
	;s retStr=$g(^TempAnDocNote("Date",date))
	d Outputnotestr

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
Outputnotestr
	set Data=$lb(notestr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAnNote1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConsumablesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAnNote1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConsumablesExecute ]
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

/// d ##Class(web.DHCANArrange).SaveAnNote("1","03/11/2014","03/11/2014","1")
ClassMethod SaveAnNote(anNote As %String, stdate As %String, enddate As %String, IsAppT As %String, userId As %String = "") As %String
{
	s stdate=##Class(web.DHCCLCom).ConvertToDateH(stdate)
	s enddate=##Class(web.DHCCLCom).ConvertToDateH(enddate)
	;f date=stdate:1:enddate d
	s date=enddate+IsAppT  //暂定按照结束时间保存
	if ($d(^DHCAnDocNote("Date",date)))  d
	.s ^TMPCCQ(+$h,"Note",$p($h,",",2))=^DHCAnDocNote("Date",date)
	else  d
	.s ^TMPCCQ(+$h,"Note",$p($h,",",2))=anNote_"^"_userId
	s ^DHCAnDocNote("Date",date)=anNote_"^"_userId
	q 0
}

/// isArr为N表示不排班isArr为Y表示排班 成功返回0失败返回非0
ClassMethod SetIsArrange(date As %String, isArr As %String) As %String
{
	q:date="" "日期不能为空！"
	q:isArr="" "-1"
	for i=1:1:$l(date,"~") d
	.s arrDate=$zdh($p(date,"~",i),4)
	.s ^DHCANOPIsArr(arrDate)=isArr
	q "0"
}

/// retStr为N表示不排班retStr为Y表示排班
ClassMethod GetIsArrange(date As %String) As %String
{
	q:date="" "日期不能为空！"
	s date=$zdh(date,4)
	s retStr="Y"
	i $g(^DHCANOPIsArr(date))'="" s retStr=$g(^DHCANOPIsArr(date))
	q retStr
}

/// w ##class(web.DHCANArrange).GetAnDragOrder("31008")
ClassMethod GetAnDragOrder(opaId As %String) As %String
{
	q:opaId="" "opaId不能为空！"
	s retStr="",i=0
	s anoId="" f  s anoId=$o(^DHCANOrder(0,"OPApp",opaId,anoId)) q:anoId=""  d
	.q:'$d(^DHCANOrder(anoId))
	.s ancoId=$p(^DHCANOrder(anoId),"^",2)
	.s ancoDesc=$p($g(^DHCANC("ComOrd",+ancoId)),"^",2)
	.s arcimId=$p(^DHCANOrder(anoId),"^",9)
	.s arcimDesc=$p($g(^ARCIM(+arcimId,1,1)),"^",2)
	.s anoQty=+$p(^DHCANOrder(anoId),"^",11)
	.s anoFlag=$p(^DHCANOrder(anoId),"^",17)
	.s anoEditFlag=$p(^DHCANOrder(anoId),"^",25)
	.q:(anoEditFlag'="E")&(anoEditFlag'="N")
	.s anoRecLocId=$p(^DHCANOrder(anoId),"^",26)
	.s anoType=$p(^DHCANOrder(anoId),"^",30)
	.q:anoType'="D"
    .s anoQty2=+$p(^DHCANOrder(anoId),"^",31)
    .s anoQty3=+$p(^DHCANOrder(anoId),"^",32)
    .s i=i+1
	.i retStr="" s retStr=i_"*"_anoId_$c(1)_ancoId_$c(1)_ancoDesc_$c(1)_arcimId_$c(1)_arcimDesc_$c(1)_anoQty_$c(1)_anoFlag_$c(1)_anoEditFlag_$c(1)_anoRecLocId_$c(1)_anoType_$c(1)_anoQty2_$c(1)_anoQty3
	.e  s retStr=retStr_"^"_i_"*"_anoId_$c(1)_ancoId_$c(1)_ancoDesc_$c(1)_arcimId_$c(1)_arcimDesc_$c(1)_anoQty_$c(1)_anoFlag_$c(1)_anoEditFlag_$c(1)_anoRecLocId_$c(1)_anoType_$c(1)_anoQty2_$c(1)_anoQty3
	q retStr
}

/// w ##class(web.DHCANArrange).IsArcimStop("22072||1")
ClassMethod IsArcimStop(arcimId) As %String
{
	q:arcimId="" "arcimId不能为空！"
	s todayDate=+$h
	s retStr="-1",retStr1="-1",retStr2="-1"
	s ARCIMEffDateTo=$p(^ARCIM($p(arcimId,"||",1),$p(arcimId,"||",2),7),"^",1)
	q:((ARCIMEffDateTo<todayDate)&(ARCIMEffDateTo'="")) "-1"
	s OLTTariffDR="" f  s OLTTariffDR=$o(^DHCOLT(0,"ARTTA",arcimId,OLTTariffDR)) q:OLTTariffDR=""  d
	.s TARIEndDate=$p(^DHCTARI(OLTTariffDR),"^",12)
	.s TARIActiveFlag=$p(^DHCTARI(OLTTariffDR),"^",7)
	.q:TARIActiveFlag'="Y"
	.i ((TARIEndDate>=todayDate)!(TARIEndDate="")) d
	..s TPStartDate="" f  s TPStartDate=$o(^DHCTARIi("STT",TPStartDate)) q:TPStartDate=""  d
	...s TPChildSub="" f  s TPChildSub=$o(^DHCTARIi("STT",TPStartDate,OLTTariffDR,TPChildSub)) q:TPChildSub=""  d
	....;s TPRowId=OLTTariffDR_"||"_TPChildSub
	....s TPEndDate=$p(^DHCTARI(OLTTariffDR,"P",TPChildSub),"^",4)
	....i ((TPEndDate>=todayDate)!(TPEndDate="")) s retStr1="0"
	.s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARTTA",arcimId,OLTTariffDR,OLTStartDate)) q:OLTStartDate=""  d
	..s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARTTA",arcimId,OLTTariffDR,OLTStartDate,OLTRowId)) q:OLTRowId=""  d
	...s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	...b
	...i ((OLTEndDate>=todayDate)!(OLTEndDate="")) s retStr2="0"
	.i ((retStr1="0")&(retStr2="0")) s retStr="0"
	.e  s retStr="-1"
	.q:retStr="0"
	q retStr
}

ClassMethod GetCtlocDescById(ctlocId As %String) As %String
{
	q:ctlocId="" "科室ID不能为空!"
	s ctlocDesc=$p($G(^CTLOC(ctlocId)),"^",2)
	q ctlocDesc
}

/// 置门诊病人的费用状态
ClassMethod UpdateOpNurseOrdered(opaId As %String, ordType As %String) As %String
{
	q:opaId="" "opaId不能为空!"
	s admId=$P(^DHCANOPArrange(opaId),"^",1)
	q:admId="" "admId不能为空!"
	s admType=$p($g(^PAADM(admId)),"^",2)
	;q:admType'="O" "非门诊病人不能操作!"
	s $p(^DHCANOPArrange(opaId),"^",50)=ordType
	i ordType="N" d
	.s $p(^DHCANOPArrange(opaId),"^",20)=""
	.s $p(^DHCANOPArrange(opaId),"^",26)=""
	q "0"
}

/// 门诊手术室转到大手术室
ClassMethod UpdateRecLoc(opaId As %String, recLocId As %String) As %String
{
	q:opaId="" "opaId不能为空!"
	s admId=$P(^DHCANOPArrange(opaId),"^",1)
	q:admId="" "admId不能为空!"
	s admType=$p($g(^PAADM(admId)),"^",2)
	;q:admType'="O" "非门诊病人不能操作!"
	s opNurseOrd=$p(^DHCANOPArrange(opaId),"^",50)
	q:opNurseOrd'="Y" "门诊病人未收费不能转到大手术室!"
	s chl=$p($p(^DHCANOPArrange(opaId),"^",2),"||",2)
	s roomId="",seqno=""
	s $P(^OR(admId,"ANA",chl,"OP",1),"^",10)=recLocId
	s $p(^DHCANOPArrange(opaId),"^",20)=""
	s $p(^DHCANOPArrange(opaId),"^",26)=""
	s $P(^DHCANOPArrange(opaId),"^",27)="A"
	s ^DHCANOPLimit("Tran",opaId)="Y^"_$zd(+$h,3)_"^"_$zt($p($h,",",2))_"^"_%session.Data("LOGON.USERID")
	q "0"
}

/// 请求接病人
ClassMethod UpdatePatRequest(opaId As %String, userId As %String) As %String
{
	q:opaId="" "opaId不能为空!"
	q:userId="" "userId不能为空!"
	q:'$d(^DHCANOPArrange(opaId)) "没有排班数据!"
	;s $p(^DHCANOPArrange(opaId),"^",56)=+$h
	;s $p(^DHCANOPArrange(opaId),"^",57)=$p($h,",",2)
	;s $p(^DHCANOPArrange(opaId),"^",58)=userId
	s $p(^DHCANOPArrange(opaId,"Ext"),"^",1)=+$h
	s $p(^DHCANOPArrange(opaId,"Ext"),"^",2)=$p($h,",",2)
	s $p(^DHCANOPArrange(opaId,"Ext"),"^",3)=userId
	q "0"
}

/// 接病人
ClassMethod UpdatePatReceive(opaId As %String) As %String
{
	q:opaId="" "opaId不能为空!"
	q:'$d(^DHCANOPArrange(opaId)) "没有排班数据!"
	;s $p(^DHCANOPArrange(opaId),"^",59)=$p($h,",",2)
	s $p(^DHCANOPArrange(opaId,"Ext"),"^",4)=+$h
	s $p(^DHCANOPArrange(opaId,"Ext"),"^",5)=$p($h,",",2)
	q "0"
}

// 20111221 lpd

/// 申请污物处理
ClassMethod UpdateWuwuRequest(opaId As %String, type As %String) As %String
{
	q:opaId="" "opaId不能为空!"
	q:'$d(^DHCANOPArrange(opaId)) "没有排班数据!"
	;s $p(^DHCANOPArrange(opaId),"^",59)=$p($h,",",2)
	s $p(^DHCANOPArrange(opaId,"Ext"),"^",14)=+$h
	s $p(^DHCANOPArrange(opaId,"Ext"),"^",15)=$p($h,",",2)
	s $p(^DHCANOPArrange(opaId,"Ext","QxType"),"^",1)=type
	q "0"
}

/// 污物处理
ClassMethod UpdateWuwuReceive(opaId As %String) As %String
{
	q:opaId="" "opaId不能为空!"
	q:'$d(^DHCANOPArrange(opaId)) "没有排班数据!"
	;s $p(^DHCANOPArrange(opaId),"^",59)=$p($h,",",2)
	s $p(^DHCANOPArrange(opaId,"Ext"),"^",16)=+$h
	s $p(^DHCANOPArrange(opaId,"Ext"),"^",17)=$p($h,",",2)
	q "0"
}

/// 取消请求接病人
ClassMethod UpdateUnPatRequest(opaId As %String, userId As %String, CancelMemoval As %String) As %String
{
	q:opaId="" "opaId不能为空!"
	q:userId="" "userId不能为空!"
	q:'$d(^DHCANOPArrange(opaId)) "没有排班数据!"
	;s $p(^DHCANOPArrange(opaId),"^",56)=+$h
	;s $p(^DHCANOPArrange(opaId),"^",57)=$p($h,",",2)
	;s $p(^DHCANOPArrange(opaId),"^",58)=userId
	s $p(^DHCANOPArrange(opaId,"Ext"),"^",1)=""
	s $p(^DHCANOPArrange(opaId,"Ext"),"^",2)=""
	s $p(^DHCANOPArrange(opaId,"Ext"),"^",3)=""
	s $p(^DHCANOPArrange(opaId,"Ext"),"^",18)=CancelMemoval
	q "0"
}

/// 取消接病人
ClassMethod UpdateUnPatReceive(opaId As %String, CancelMemoval As %String) As %String
{
	q:opaId="" "opaId不能为空!"
	q:'$d(^DHCANOPArrange(opaId)) "没有排班数据!"
	;s $p(^DHCANOPArrange(opaId),"^",59)=$p($h,",",2)
	s $p(^DHCANOPArrange(opaId,"Ext"),"^",4)=""
	s $p(^DHCANOPArrange(opaId,"Ext"),"^",5)=""
	s $p(^DHCANOPArrange(opaId,"Ext"),"^",19)=CancelMemoval
	q "0"
}

/// 入等候区
ClassMethod UpdateInArea(opaId As %String) As %String
{
	q:opaId="" "opaId不能为空!"
	q:'$d(^DHCANOPArrange(opaId)) "没有排班数据!"
	s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
	s anaSub=$p(anaId,"||",2)
	q:anaSub="" "麻醉指针错!"
	s anaAreaInDate=+$h
	s anaAreaInTime=$p($h,",",2)
	s $p(^OR(+anaId,"ANA",anaSub),"^",35)=anaAreaInDate
	s $p(^OR(+anaId,"ANA",anaSub),"^",36)=anaAreaInTime
	q "0"
}

/// 离等候区
ClassMethod UpdateOutArea(opaId As %String) As %String
{
	q:opaId="" "opaId不能为空!"
	q:'$d(^DHCANOPArrange(opaId)) "没有排班数据!"
	;s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
	;s anaSub=$p(anaId,"||",2)
	;q:anaSub="" "麻醉指针错!"
	;s anaAreaOutDate=+$h
	;s anaAreaOutTime=$p($h,",",2)
	;s $p(^OR(+anaId,"ANA",anaSub),"^",37)=anaAreaOutDate
	;s $p(^OR(+anaId,"ANA",anaSub),"^",38)=anaAreaOutTime
	s $p(^DHCANOPArrange(opaId,"Ext"),"^",7)=+$h
	s $p(^DHCANOPArrange(opaId,"Ext"),"^",8)=$p($h,",",2)
	q "0"
}

/// 申请取血
ClassMethod Updatesqqx(opaId As %String, type As %String, qtstr As %String) As %String
{
	s ^ttt(999)=opaId_"^"_type_"^"_qtstr
	q:opaId="" "opaId不能为空!"
	q:'$d(^DHCANOPArrange(opaId)) "没有排班数据!"
	s $p(^DHCANOPArrange(opaId,"Ext","Blood"),"^",1)=type
	s $p(^DHCANOPArrange(opaId,"Ext","Blood"),"^",2)=+$h
    s $p(^DHCANOPArrange(opaId,"Ext","Blood"),"^",3)=$p($h,",",2)
	s $p(^DHCANOPArrange(opaId,"Ext","Blood"),"^",4)=qtstr
	q "0"
}

/// w ##class(web.DHCANArrange).GetLimitByGroupId("52","147")
/// 有权限安全组返回0，否则返回-1
ClassMethod GetLimitByGroupId(ctlocId As %String, groupId As %String) As %String
{
	//s ^DHCANOPLimit("LimitGroup",52)="136^143^141"
	//s ^DHCANOPLimit("LimitGroup",311)="134"
	//s ^DHCANOPLimit("LimitGroup",312)="140"
	//s ^DHCANOPLimit("Arcos",52)="136^143^141^148^149^147"
	//s ^DHCANOPLimit("Arcos",311)="105^134"
	//s ^DHCANOPLimit("Arcos",312)="140"
	q:ctlocId="" "ctlocId不能为空!"
	q:groupId="" "groupId不能为空!"
	s retStr="-1"
	i ^DHCANOPLimit("LimitGroup",ctlocId)[groupId s retStr="0"
	e  s retStr="-1"
	q retStr
}

ClassMethod GetPrintCtlocCTile(ctlocId As %String) As %String
{
	q:ctlocId="" "ctlocId不能为空!"
	s retStr=""
	s retStr=$p($g(^CTLOC(ctlocId)),"^",2)
	i $l(retStr,"-")=2 s retStr=$p(retStr,"-",2)
	q retStr
}

/// w ##class(web.DHCANArrange).GetFilterArcos()
ClassMethod GetFilterArcos() As %String
{
	s retStr=""
	//s ^DHCANOPLimit("FilterArcos")="90AN"  //麻醉药品医嘱套Code
	s retStr=^DHCANOPLimit("FilterArcos")
	q retStr
}

/// w ##class(web.DHCANArrange).GetGroupIdByUserId(4533)
ClassMethod GetGroupIdByUserId(userId As %String) As %String
{
	q:userId="" "userId不能为空!"
	i userId="" s userId=%session.Data("LOGON.USERID")
	s groupId=$P($G(^SSU("SSUSR",userId)),"^",5)
	q groupId
}

/// w ##class(web.DHCANArrange).TestPaid()
ClassMethod TestPaid() As %String
{
	k ^TempPat("opaId")
	s ctlocdr="311"
	
	s linkLocId=##Class(web.DHCCLCom).GetLinkLocId(ctlocdr)
    s userLocIdStr=linkLocId_"^"_ctlocdr
    
	f date=62372:1:62372 d
    .s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
    ..q:$d(^DHCANOPArrange(opaId))<1
    ..s oproomdes="",bedCode="",WardDes="",Status="",jzstat="",jz="",statNum="",isPaidStat="",hisRegno="",patType=""
    ..s EpisodeID=$p($g(^DHCANOPArrange(opaId)),"^",1)
	..q:EpisodeID=""
	..s patType=$p(^PAADM(EpisodeID),"^",2)
	..q:patType="O"
	..s AnaesthesiaID=$p($g(^DHCANOPArrange(opaId)),"^",2)
	..s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	..s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	..s oaRowId=$o(^DHCENSOA("0","PapmiDr",papmiId,""))
	..s hisRegno=$p(^DHCENSOA(oaRowId),"^",4)
	..s opSeqNote=$P($G(^DHCANOPArrange(opaId)),"^",41)
    ..s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
    ..;q:oproomdr=""
	..i oproomdr'="" s oproomdes=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
	..s opordno=$p(^DHCANOPArrange(opaId),"^",26)
	..;q:opordno=""
	..;s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
	..;s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)  
	..;i curWardId'="" s WardDes=$P($g(^PAWARD(curWardId)),"^",1)
	..;i (bedSub'="")&(curWardId'="") s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
	..;s inPatNo=$p($g(^PAADM(EpisodeID)),"^",29)
	..;s loc=$P(^PAADM(EpisodeID),"^",4)
	..;s locCode=$p(^CTLOC(loc),"^",1)
	..;s locdes=$P(^CTLOC(loc),"^",2)
	..;i $l(locdes,"-")>1 s locdes=$p(locdes,"-",2)
	..;s bedCode=$G(bedCode)
	..s stat=$P(^DHCANOPArrange(opaId),"^",27)
	..q:stat=""
	..q:stat=" "
	..;q:stat="A"
	..q:stat="N"
	..i stat="D" s Status="取消"
	..i stat="R" s Status="安排"
	..i stat="P" s Status="恢复室"
	..i stat="I" s Status="术中"
	..i stat="L" s Status="术毕"
	..i stat="F" s Status="完成"
	..i stat="A" s Status="申请"
	..;i stat="N" s Status="非预约"
    ..s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
    ..;q:opstdate'=date
    ..;s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
    ..;s openddate=$P(^DHCANOPArrange(opaId),"^",16)
    ..;s opendtime=$P(^DHCANOPArrange(opaId),"^",17)
    ..;s opNurseOrd=$p($G(^DHCANOPArrange(opaId)),"^",50)
    ..;i openddate=opstdate s openddate=""
    ..;i openddate'="" s openddate=$ZD(openddate,3)
    ..;i opendtime'="" s opendtime=$ZT(opendtime,2)
    ..;s opdatestr=$ZD(opstdate,3)_" "_$ZT(opsttime,2)_"~"_openddate_" "_opendtime
    ..;s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	..;s meCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	..;s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	..s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	..s operLocId=$P(^OR(EpisodeID,"ANA",chl,"OP",1),"^",10)
	..s admLocId=$p($g(^PAADM(EpisodeID)),"^",4)
	..q:(("^"_userLocIdStr_"^")'[("^"_+operLocId_"^"))&(("^"_userLocIdStr_"^")'[("^"_+admLocId_"^"))
    ..;s opAppdate=$P(^DHCANOPArrange(opaId),"^",3)         //wkz 071225 S
	..;i opAppdate'=""  s opAppdate=$ZD(opAppdate,4)
	..s opSeqNote=$P($G(^DHCANOPArrange(opaId)),"^",41)
	..;s appCtcpId=$P(^DHCANOPArrange(opaId),"^",6)  //ypz 070318
	..;i appCtcpId'="" s appCtcpDesc=##class(web.DHCANOPCom).GetNameById(appCtcpId)
	..s exOeoriDr="" f  s exOeoriDr=$o(^DHCEXDE(0,"OEORI",EpisodeID,exOeoriDr)) q:exOeoriDr=""  d
	...s exRowId="" f  s exRowId=$o(^DHCEXDE(0,"OEORI",EpisodeID,exOeoriDr,exRowId)) q:exRowId=""  d
	....s anaestDr=$p($g(^OEORD(+exOeoriDr,"I",$p(exOeoriDr,"||",2),4)),"^",9)
	....q:anaestDr'=AnaesthesiaID
	....s itemStatDR=$p($g(^OEORD(+exOeoriDr,"I",$p(exOeoriDr,"||",2),1)),"^",13)
	....q:(itemStatDR="4")!(itemStatDR="")
	....s itmMastDr=$p($g(^OEORD(+exOeoriDr,"I",$p(exOeoriDr,"||",2),1)),"^",2)
	....s arcimDesc=$p($g(^ARCIM($p(itmMastDr,"||",1),$p(itmMastDr,"||",2),1)),"^",2)
	....s AppLocRowid=$p($g(^OEORD(+exOeoriDr,"I",$p(exOeoriDr,"||",2),7)),"^",2)
	....q:AppLocRowid=""
	....s exBillingAttr=$p($g(^DHCEXDE(exRowId)),"^",17)
	....q:exBillingAttr="F"
	....s exRecDeptDr=$p($g(^DHCEXDE(exRowId)),"^",16)
	....q:exRecDeptDr'=ctlocdr
	....i (exBillingAttr="0")!(exBillingAttr="") s isPlanPrice="N"
	....e  i exBillingAttr="1" s isPlanPrice="Y"
	....s itemStatDR=$p($g(^OEORD(+exOeoriDr,"I",$p(exOeoriDr,"||",2),1)),"^",13)
	....q:(itemStatDR=4)!(itemStatDR="")!(itemStatDR=5)!(itemStatDR=6)
	....s exStatus=$p($g(^DHCEXDE(exRowId)),"^",18)
	....i exStatus="A" s isPaid="Y"
	....e  i exStatus="" s isPaid="N"
	....s isPaidStat=isPaidStat_isPaid
	..i isPaidStat="" s paidStr="未录费"
	..i (isPaidStat'="")&(isPaidStat'["N") s paidStr="已收费"
	..i isPaidStat["N" s paidStr="未收费"
	..s ^TempPat("opaId",opaId)=opaId_"^"_opSeqNote_"^"_Status_"^"_paidStr_"^"_hisRegno
	q "0"
}

/// schStr=住院号^登记号^已入等候区^未入等候区^登录科室ID
/// w ##class(web.DHCANArrange).GetOperInfo("09/10/2011","09/10/2011","^1234^^^311")
ClassMethod GetOperInfo(stdate As %String, endate As %String, schStr As %String) As %String
{
	n (stdate,endate,schStr)
	s retStr=""
    k ^ANOPTemp("ReceivePat",$j)
    if (stdate="")!(endate="") s sdate=+$H,edate=+$H
    e  s sdate=$zdh(stdate,4),edate=$zdh(endate,4)
    s ^Temp(1)=stdate_"^"_endate_"*"_schStr
    s ctLocId=$p(schStr,"^",5)
    s linkLocId=##Class(web.DHCCLCom).GetLinkLocId(ctLocId)
    s userLocIdStr=linkLocId_"^"_ctLocId
    s j=1
    s SubNode="SDate"
    f date=sdate:1:edate
    {
		s opaId="" f  s opaId=$O(^DHCANOPArrange(0,SubNode,date,opaId)) q:opaId=""  d
		.q:$d(^DHCANOPArrange(opaId))<1
		.s oproomdes="",opordno="",patName="",sex="",age="",medCareNo="",regNo="",locdes="",bedCode="",opdate="",jzstat="",Status="",patWard="",inArea="",oproomdr="",EpisodeID="",loc="",patWardId="",opordcon=""
		.s opdes="",opd="",diag=""
		.s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
		.q:EpisodeID=""
		.s anaId=$P(^DHCANOPArrange(opaId),"^",2)
		.s anaSub=$P(anaId,"||",2)
		.s stat=$P(^DHCANOPArrange(opaId),"^",27)
		.q:stat'="R"
		.i stat="R" s Status="安排"
		.s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
		.s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
		.s opdate=$zd($g(opstdate),3)_" "_$zt($g(opsttime),2)
		.s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
		.q:oproomdr=""
		.s oproomdes=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
		.s opordno=$P(^DHCANOPArrange(opaId),"^",26)
		.q:opordno=""
		.i +opordno=1 s opordcon=$zt($g(opsttime),2)
		.e  s opordcon="接台"_(+opordno-1)
		.s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
		.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
		.s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
		.s age=##class(web.UDHCANOPArrange).CalAge(birth,+$h)
		.s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
		.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		.q:(+regNo'=+$p(schStr,"^",2))&($p(schStr,"^",2)'="")
		.;s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	    .s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	    .s medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
		.q:(+medCareNo'=+$p(schStr,"^",1))&($p(schStr,"^",1)'="")
		.s loc=$P(^PAADM(EpisodeID),"^",4)
		.s locdes=$P(^CTLOC(loc),"^",2)
		.i $l(locdes,"-")=2 s locdes=$p(locdes,"-",2)
		.s i=0
		.s subchl=0 f  s subchl=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl)) q:(subchl="")  d
		..s opdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",6)       		;ANAOP_Type_DR     ；手术名称
		..i +opdr=opdr d
		...i $P($g(^ORC("OPER",+opdr)),"^",2)'="" d     ///ck091117
		....i opdes'="" s opdes=opdes_";"     ///ck091117
		....s opdes=opdes_$P($g(^ORC("OPER",+opdr)),"^",2)     ///ck091117
		..e  d
		...i $g(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"REM",2))'="" d
		....i opdes'="" s opdes=opdes_";"_^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"REM",2)
		....e  s opdes=^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"REM",2)    ///ck091210
		..s i=i+1
		..q:i>1   ///ck091117
		..s sub=subchl
		..s docdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",8)      		;ANAOP_Surgeon_DR   手术医师
		..i +docdr=docdr s opd=##class(web.DHCANOPCom).GetNameById(docdr)
		..e  s opd=$TR($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ","")  //CK 091210 手术医生备注(外来手术医生)	   
		..s predigdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",4)   		;ANAOP_PreopDiag_DR 术前诊断
		..i +predigdr=predigdr s diag=$P($g(^MRC("ID",predigdr)),"^",2)
		..e  d
		...i $g(^OR(EpisodeID,"ANA",anaSub,"TXT",2))'="" s diag=$g(^OR(EpisodeID,"ANA",anaSub,"TXT",2))  //ck 20101116		
		..s operLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",10)
		.s admLocId=$p($g(^PAADM(EpisodeID)),"^",4)
		.q:(("^"_userLocIdStr_"^")'[("^"_+operLocId_"^"))&(("^"_userLocIdStr_"^")'[("^"_+admLocId_"^"))
		.s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
		.s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)  
		.i curWardId'="" s WardDes=$P(^PAWARD(curWardId),"^",1)
		.i (bedSub'="")&(curWardId'="") s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
		.s jz=$P(^OR(EpisodeID,"ANA",anaSub),"^",32) //急诊(E)/择期(B
		.i jz="E" s jzstat="急诊"
		.e  s jzstat="择期"
		.s patWardId=$P($G(^DHCANOPArrange(opaId)),"^",32)
		.i patWardId'="" s patWard=$P($G(^PAWARD(patWardId)),"^",2)
		.i $l(patWard,"-")=2 s patWard=$p(patWard,"-",2)
		.s inAreaDate=$p(^OR(+anaId,"ANA",anaSub),"^",35)
		.s inAreaTime=$p(^OR(+anaId,"ANA",anaSub),"^",36)
		.i inAreaDate'="" s inArea=$zd($g(inAreaDate),3)
		.i inAreaTime'="" s inArea=inArea_" "_$zt($g(inAreaTime),2)
		.q:($p(schStr,"^",3)=1)&(inArea="")
		.q:($p(schStr,"^",4)=1)&(inArea'="")
		.;s inArea=$zd($g(inAreaDate),4)_" "_$zt($g(inAreaTime),2)
		.s j=j+1
		.s ^ANOPTemp("ReceivePat",$j,oproomdr,opordno,j)=oproomdes_"^"_opordno_"^"_patName_"^"_sex_"^"_age_"^"_medCareNo_"^"_regNo_"^"_locdes_"^"_bedCode_"^"_opdate_"^"_jzstat_"^"_Status_"^"_patWard_"^"_inArea_"^"_oproomdr_"^"_opaId_"^"_EpisodeID_"^"_loc_"^"_opordcon_"^"_opdes_"^"_opd_"^"_diag
		.;s ^ANOPTemp("ReceivePat",$j,oproomdr,opordno,j)=$lb("d",oproomdes,opordno,patName,sex,age,medCareNo,regNo,locdes,bedCode,opdate,jzstat,stat,patWard,inArea,oproomdr,opaId,EpisodeID,loc,patWardId)
	}
	s i=0
	s roomId="" f  s roomId=$o(^ANOPTemp("ReceivePat",$j,roomId)) q:roomId=""  d
	.s ord="" f  s ord=$o(^ANOPTemp("ReceivePat",$j,roomId,ord)) q:ord=""  d
	..s j="" f  s j=$o(^ANOPTemp("ReceivePat",$j,roomId,ord,j)) q:j=""  d
	...s i=i+1
	...s retStr=$g(^ANOPTemp("ReceivePat",$j,roomId,ord,j))_"^"_i
	...s retval="GetOperInfo"_"('"_$ZCVT(retStr,"O","JS")_"');"
	...&javascript<#(retval)#>
	i retStr="" d
	.s retval="GetOperInfo"_"('"_$ZCVT(retStr,"O","JS")_"');"
	.&javascript<#(retval)#>
}

ClassMethod SetInAreaDateTime(opaId As %String) As %String
{
	s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	s anaSub=$P(anaId,"||",2)
	s inAreaDate=+$h
	s inAreaTime=$p($h,",",2)
	s $p(^OR(+anaId,"ANA",anaSub),"^",35)=inAreaDate
	s $p(^OR(+anaId,"ANA",anaSub),"^",36)=inAreaTime
	q $zd(inAreaDate,3)_" "_$zt(inAreaTime,2)
}

ClassMethod CheckInAreaDateTime(opaId As %String, patSite As %String) As %String
{
	q:opaId="" "opaId不能为空"
	s anaId=$P($G(^DHCANOPArrange(opaId)),"^",2)
	s anaSub=$P(anaId,"||",2)
	s nowDate=+$h
	s nowTime=+$p($h,",",2)
	s retStr=0
	s ^tempck("inarea")=$zd(nowDate,3)_"/"_$zt(nowTime)
	q:patSite'["1" "0"
	
	s adm=+anaId
	s admType=$p(^PAADM(adm),"^",2)
	s PAPMIDR=$p(^PAADM(adm),"^",1)
	i (admType'="I") d
	.s admdr=""
	.f  s admdr=$o(^PAPERdr(PAPMIDR,"ADM","I",admdr)) q:admdr=""  d
	..s VisitStatus=$p(^PAADM(admdr),"^",20)
	..i (VisitStatus="A") d
	...s anaIdNew=admdr_"||"_anaSub
	...&sql(update SQLUSER.DHC_AN_OPArrange set OPA_Adm_Dr=:admdr where opa_rowid=:opaId)
	...s PATWARDDR=$p(^PAADM(admdr),"^",70)
	...i PATWARDDR'="" s $P(^DHCANOPArrange(opaId),"^",32)=PATWARDDR
	...s $P(^DHCANOPArrange(opaId),"^",2)=anaIdNew
	...m ^OR(admdr)=^OR(adm)
	...s anaId=$P($G(^DHCANOPArrange(opaId)),"^",2)
	
	s userId=%session.Data("LOGON.USERID")
	s inAreaDate=$p(^OR(+anaId,"ANA",anaSub),"^",35)
	s inAreaTime=$p(^OR(+anaId,"ANA",anaSub),"^",36)
	i $p(patSite,"^",1)=1 d   //入等候区
	.s $p(^OR(+anaId,"ANA",anaSub),"^",35)=nowDate
	.s $p(^OR(+anaId,"ANA",anaSub),"^",36)=nowTime
	
	//s inRoomDate=$p(^OR(+anaId,"ANA",anaSub),"^",39)
	s inRoomDate=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",7)
	//s inRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",40)
	s inRoomTime=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",8)
	i $p(patSite,"^",2)=1 d   //入室
	.s $p(^OR(+anaId,"ANA",anaSub),"^",39)=nowDate
	.s $p(^OR(+anaId,"ANA",anaSub),"^",40)=nowTime
	.s rowId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"inRoomRecorder", userId, "", userId)
	.//s $p(^DHCANOPArrange(opaId,"Ext"),"^",7)=nowDate
	.//s $p(^DHCANOPArrange(opaId,"Ext"),"^",8)=nowTime
	.//s $p(^DHCANOPArrange(opaId,"Ext"),"^",9)=userId
	.;s retStr=##class(web.UDHCANOPArrange).UpdateAnOpStatus(opaId,"I")
	;q:retStr'=0 retStr
	
	s inPACUFlag=$p($g(^DHCANOPArrange(opaId,"ANI",1)),"^",101)
	s inPACUDate=$p(^DHCANOPArrange(opaId,"PACU"),"^",6)
	s inPACUTime=$p(^DHCANOPArrange(opaId,"PACU"),"^",7)
	i ($p(patSite,"^",3)=1) d   //入PACU
	.s $p(^DHCANOPArrange(opaId,"PACU"),"^",6)=nowDate
	.s $p(^DHCANOPArrange(opaId,"PACU"),"^",7)=nowTime
	.s retStr=##class(web.UDHCANOPArrange).UpdateAnOpStatus(opaId,"P")
	q:retStr'=0 retStr
	
	s outPACUDate=$p(^DHCANOPArrange(opaId,"PACU"),"^",8)
	s outPACUTime=$p(^DHCANOPArrange(opaId,"PACU"),"^",9)
	i ($p(patSite,"^",4)=1) d   //出PACU
	.s $p(^DHCANOPArrange(opaId,"PACU"),"^",8)=nowDate
	.s $p(^DHCANOPArrange(opaId,"PACU"),"^",9)=nowTime
	.s retStr=##class(web.UDHCANOPArrange).UpdateAnOpStatus(opaId,"L")
	q:retStr'=0 retStr
	
	//s outRoomDate=$p(^OR(+anaId,"ANA",anaSub),"^",41)
	s outRoomDate=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",31)
	//s outRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",42)
	s outRoomTime=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",32)
	i ($p(patSite,"^",5)=1) d   //lishi
	.//s $p(^DHCANOPArrange(opaId,"Ext"),"^",31)=nowDate
	.//s $p(^DHCANOPArrange(opaId,"Ext"),"^",32)=nowTime
	.//s $p(^DHCANOPArrange(opaId,"Ext"),"^",33)=userId
	.s $p(^OR(+anaId,"ANA",anaSub),"^",41)=nowDate
	.s $p(^OR(+anaId,"ANA",anaSub),"^",42)=nowTime
	.s rowId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"outRoomRecorder", userId, "", userId)
	.;s retStr=##class(web.UDHCANOPArrange).UpdateAnOpStatus(opaId,"L")
	//q:retStr'=0 retStr
	
	s ^tempck("inarea",1)=$zd(nowDate,3)_"/"_$zt(nowTime)
	s outAreaDate=$p(^OR(+anaId,"ANA",anaSub),"^",37)
	s outAreaTime=$p(^OR(+anaId,"ANA",anaSub),"^",38)	
	i ($p(patSite,"^",6)=1) d   //出等候区
	.s $p(^OR(+anaId,"ANA",anaSub),"^",37)=nowDate
	.s $p(^OR(+anaId,"ANA",anaSub),"^",38)=nowTime
	.s retStr=##class(web.UDHCANOPArrange).UpdateAnOpStatus(opaId,"F")
	q:retStr'=0 retStr
	
	q "0"
}

ClassMethod SetOPAStatus(opaId As %String) As %String
{
	q:opaId="" 0
	s opastatus=$P(^DHCANOPArrange(opaId),"^",27)
	q:opastatus'="P" 0
	s $P(^DHCANOPArrange(opaId),"^",27)="L"
	;s status="L"
	;&sql(update SQLUSER.DHC_AN_OPArrange set OPA_Status=:status where opa_rowid=:opaId)	
	q SQLCODE
}

ClassMethod SetANOPCustom(opaId As %String, code As %String, desc As %String, userId As %String) As %String
{
	q:opaId="" ""
	q:code="" ""
	q:desc="" ""
	i userId="" s userId=%session.Data("LOGON.USERID")
	s username=$p(^SSU("SSUSR",userId),"^",2)
	s ^DHCCLSet("AnOp","Patient",opaId,code)=username_" "_$zd(+$h,3)_" "_$zt($p($h,",",2))_" "_desc
	s UserCustom=""
	s CustomCode="" f  s CustomCode=$o(^DHCCLSet("AnOp","Patient",opaId,CustomCode)) q:CustomCode=""  d
	.i UserCustom=""  s UserCustom=$g(^DHCCLSet("AnOp","Patient",opaId,CustomCode))
	.e  s UserCustom=UserCustom_","_$g(^DHCCLSet("AnOp","Patient",opaId,CustomCode))
	q UserCustom
}

/// w ##class(web.DHCANArrange).TestForPAV()
ClassMethod TestForPAV() As %String
{
    
    s opaId="" f  s opaId=$O(^DHCANOPArrange(opaId)) q:opaId=""  d
    .;Q:opaId'=93837
    .q:$d(^DHCANOPArrange(opaId))<1
    .s stat=$P(^DHCANOPArrange(opaId),"^",27)
    .q:(stat="")!(stat="N")!(stat="D")
    .s $P(^DHCANOPArrange(opaId,"PAV",1),"^",10)="正常"
    .s $P(^DHCANOPArrange(opaId,"PAV",1),"^",11)="正常"
    .s $P(^DHCANOPArrange(opaId,"PAV",1),"^",13)="无"
    .s $P(^DHCANOPArrange(opaId,"PAV",1),"^",15)="正常"
    .s $P(^DHCANOPArrange(opaId,"PAV",1),"^",16)="正常"
    .s $P(^DHCANOPArrange(opaId,"PAV",1),"^",17)="正常"

	q "0"
}

/// w ##Class(web.DHCANArrange).GetArcimName1("14853||1","")
ClassMethod GetArcimName1(ArcimRowid As %String, Num As %String)
{
	n (ArcimRowid,Num)
  s ArcimName=$P($G(^ARCIM(+ArcimRowid,1,1)),"^",2)	
  s RetPrice=##Class(web.DHCDocOrderEntry).GetOrderPrice("","",ArcimRowid,+$H,"","","","")
  s ArcimPrice=$p(RetPrice,"^",1)
  s arcicId=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10)
  q:arcicId="" ""
  q:'$d(^ARC("IC",arcicId)) ""
  s OrdCatId=$p(^ARC("IC",arcicId),"^",8)
  q:OrdCatId="" ""
  //s ARCID=$p(ArcimRowid,"||",1)
  //s OrdCatAlias=$p($g(^ARC("ALIAS",ARCID)),"^",6)
  s ARCRowId=""
  f  s ARCRowId=$o(^ARC("ALIAS",0,"ARCIM",ArcimRowid,ARCRowId))  q:ARCRowId=""  d
  .s OrdCatAlias=$p($g(^ARC("ALIAS",ARCRowId)),"^",6)
  s OrdCatDesc=$p(^OEC("ORCAT",OrdCatId),"^",2)
  s OrdCatCode=$p(^OEC("ORCAT",OrdCatId),"^",1)
  s OrdCatStr=OrdCatCode_"-"_OrdCatDesc_"^"_OrdCatId
  s str=ArcimName_" "_Num_" "_ArcimRowid_" "_ArcimPrice_" "_OrdCatStr_" "_OrdCatAlias
  q str
}

ClassMethod GetAllOrder1(Item As %String, GroupID As %String, Category As %String, SubCategory As %String, EpisodeID As %Library.String, rowid As %String) As %String
{
	n (Item,GroupID,Category,SubCategory,EpisodeID)
	i GroupID="154" s GroupID="134"
	s ^tmpAN("GetAllOrder")=Item_","_GroupID_","_Category_","_SubCategory_","_EpisodeID
	s rset=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
	s ^tmpAN("GetAllOrder",+EpisodeID)=Item_","_GroupID_","_Category_","_SubCategory_","_EpisodeID_","_rset
	s ret="",isTooLong=0
	do rset.Execute(Item,GroupID,Category,SubCategory,"","","",EpisodeID,"","","","","","","","")
	while (rset.Next()) {
		;s isstop=##Class(web.DHCANArrange).IsArcimStop(rset.GetData(2))
		;q:isstop'="0"
		i $l(ret)>30000 s ret="",isTooLong=1 break 
		i ret=""  s ret=rset.GetData(1)_"^"_rset.GetData(2)_"^"_rset.GetData(4)_"^"_rset.GetData(12)_"^"_rset.GetData(13)_"^"_rset.GetData(19)
		e  s ret=ret_$c(1)_rset.GetData(1)_"^"_rset.GetData(2)_"^"_rset.GetData(4)_"^"_rset.GetData(12)_"^"_rset.GetData(13)_"^"_rset.GetData(19)
		q:rset.GetData(2)'=rowid
	}
	d rset.Close()
	i isTooLong s ret=""
	q ret
}

/// w ##Class(web.DHCANArrange).GetItemRowid("123321")
ClassMethod GetItemRowid(rowid As %String) As %String
{
	q:rowid=""
	s tarid=""
	s tarid=$o(^DHCTARI(0,"InsuName",rowid,tarid))  q:tarid=""  d
	s Code=$p($g(^DHCTARI(tarid)),"^",1)
	q:Code=""
	s arcrowid=0
	s arcrowid=$o(^ARCIM(0,"Code",Code,arcrowid))  q:arcrowid=""  d
	q arcrowid
}

ClassMethod DateLogicalToHtml() As %String
{
	;return month/day/year
	;w ##class(websys.Conversions).DateLogicalToHtml()
	n val,dateformat
	s val=""
	;Q:h="" ""
	s h=$h
	s dateformat=$lg(^websys.ConfigurationD(1),10)
	s desc=$zd(h,3)
	s d=$p(desc,"-",3),m=$p(desc,"-",2),y=$p(desc,"-",1)
	i dateformat="DMY" {s val=d_"/"_m_"/"_y}
	elseif dateformat="MDY" {s val=m_"/"_d_"/"_y}
	elseif dateformat="YMD" {s val=y_"/"_m_"/"_d}
	i val="" s val=$zd(h)
	quit val
}

ClassMethod GetReceiveStat(opaId, opRoomId, patSite) As %String
{

	q:(opaId="")||(opRoomId="")||(patSite="") "输入为空"
	s retStr="1"
    s opRoomDesc=$p(^DHCANC("OPRoom",opRoomId),"^",2)
	s inRoomOpaId=0,numOp=""
	s sdate=$p(^DHCANOPArrange(opaId),"^",14)
	//i sdate["/"  s sdate=$zdh(sdate)
	//i sdate["-"  s sdate=$zdh(sdate,3)
	s sdate=##class(web.DHCClinicCom).ConvertToDateH(sdate)
	f  s inRoomOpaId=$O(^DHCANOPArrange(0,"RoomStatus",opRoomId,"I",inRoomOpaId)) q:(inRoomOpaId="")  d
	.q:inRoomOpaId=opaId
	.i $d(^DHCANOPArrange(0,"RoomStatus",opRoomId,"I",inRoomOpaId))>0  d
	..s papmiId=$p(^PAADM($p(^DHCANOPArrange(inRoomOpaId),"^",1)),"^",1)
	..s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	..s opaStartDate=$p(^DHCANOPArrange(inRoomOpaId),"^",14)
	..;i opaStartDate["/"  s opaStartDate=$zdh(opaStartDate)
	..;i opaStartDate["-"  s opaStartDate=$zdh(opaStartDate,3)
	s inRoomFlag=$p(patSite,"^",2)
	s leaveRoomFlag=$p(patSite,"^",5)
	b ;111
	s retOp=..JudgeOPStatus(sdate,opRoomId,opaId,inRoomFlag,leaveRoomFlag)
	b ;112
	if retOp'="" s numOp=$l(retOp,"^")
	if numOp=3 s retStr=$p(retOp,"^",1)
	if numOp=2   d  
	.s retId=$p(retOp,"^",1)
	.s retStat=$p(retOp,"^",2)
	.if retStat="In"  d
	..s retStr=2    ///入室核查未填写
	.if retStat="Out" d
	..s retStr=3    ///离室核查未填写
	if numOp=1   d 
	.if retOp="In"  d
	..s retStr=0    ///本身的入室核查未填写
	///判断在此手术间中的离室状态的手术有没有填写入室离室核查
	q retStr
}

ClassMethod JudgeOPStatus(startDate, oproomdr, opRowId, inRoomFlag, leaveRoomFlag)
{
	q:startDate=""
	q:oproomdr=""
	q:opRowId=""
	
	s opaId="",ret=""
	f  s opaId=$O(^DHCANOPArrange(0,"SDate",startDate,opaId)) q:(opaId="")  d
	.s oproom=$P(^DHCANOPArrange(opaId),"^",20)
	.q:oproomdr'=oproom
	.;q:opRowId=opaId
	.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
	.s opStopStatus=$P($g(^DHCANOPArrange(opaId)),"^",23)
	.q:(opaStatus'="")&&(opStopStatus="O")
	.;q:((opaStatus'="L")&&(opaStatus'="F"))
	
	.s inRoomDate=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",7)
	.s inRoomTime=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",8)
	.s outRoomDate=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",31)
	.s outRoomTime=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",32)
	.;i inRoomDate="" d
	.;.s ret=opaId_"^"_"In"
	.;.i outRoomDate="" s ret=ret_"^"_"Out" 
	.if opRowId=opaId  d
	..i (inRoomDate="")&&(leaveRoomFlag=1) s ret="In"
	.i (inRoomDate'="")&&(outRoomDate="")&&(opRowId'=opaId) s ret=opaId_"^"_"Out"
	.i (inRoomDate="")&&(outRoomDate'="") s ret=opaId_"^"_"In"
	
	.q:ret'=""
	q ret
}

Query GetOpInfoList(opDate As %String, registerNo As %String, operRoomId As %String) As %Query(ROWSPEC = "oproomdes,opordno,patName,sex,age,medCareNo,regNo,locdes,bedCode,opdate,jzstat,Status,patWard,oproomdr,opaId,EpisodeID,loc,opordcon,opdes,opd,diag,inArea,inRoom,inPACU,outPACU,outRoom,outArea,inRoomRecorder,outRoomRecorder")
{
}

ClassMethod GetOpInfoListExecute(ByRef qHandle As %Binary, opDate As %String, registerNo As %String, operRoomId As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	s ind=1
 	k ^ANOPTemp("ReceivePat",$j)
 	s format=##class(websys.Conversions).DateFormat()
 	i format="" s format=3
 	s ctLocId=%session.Data("LOGON.CTLOCID")
 	s linkLocIdStr=##Class(web.DHCCLCom).GetLinkLocId(ctLocId)
 	s userLocIdStr=linkLocIdStr_"^"_ctLocId
 	s j=1
	s date=##class(web.DHCClinicCom).ConvertToDateH(opDate)
	s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
	.q:$d(^DHCANOPArrange(opaId))<1
	.s oproomdes="",opordno="",patName="",sex="",age="",medCareNo="",regNo="",locdes="",bedCode="",opdate="",jzstat="",Status="",patWard="",inArea="",oproomdr="",EpisodeID="",loc="",patWardId="",opordcon=""
	.s opdes="",opd="",diag="",inRoom="",inPACU="",outPACU="",outRoom="",outArea=""
	.s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
	.q:EpisodeID=""
	.s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	.s anaSub=$P(anaId,"||",2)
	.s stat=$P(^DHCANOPArrange(opaId),"^",27)
	.q:(stat="")!(stat="D")!(stat="C")
    .i stat="R" s Status="安排"
	.i stat="I" s Status="术中"
	.i stat="P" s Status="恢复室"
	.i stat="L" s Status="离室"
	.i stat="F" s Status="完成"
	.s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
	.s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
	.s opdate=$zd($g(opstdate),format)_" "_$zt($g(opsttime),2)
	.s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
	.q:oproomdr=""		
	.s floorId=$p($g(^DHCANC("OPRoom",oproomdr)),"^",4)
	.s pacuFloorId=""
	.s PACUGroupList=$g(^DHCCLSet("AnOp","PACUGroupList"))
	.s num=$l(PACUGroupList,"#")
	.f pi=1:1:num d
	..s PACUGroupStr=$p(PACUGroupList,"#",pi)
	..q:PACUGroupStr=""
	..s PACUGroup=$p(PACUGroupStr,"!",1)
	..i PACUGroup=refGROUPID s pacuFloorId=$p(PACUGroupStr,"!",2)
	.q:(operRoomId'="")&&(oproomdr'=operRoomId)&&(pacuFloorId="")
    .q:(pacuFloorId'="")&&(stat'="P")
    .q:(pacuFloorId'="")&&(pacuFloorId'=floorId)
	.s oproomdes=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
	.s opordno=$P(^DHCANOPArrange(opaId),"^",26)
	.i opordno="" s opordno="未排"
	.q:opordno=""
	.i +opordno=1 s opordcon=$zt($g(opsttime),2)
	.e  s opordcon="接台"_(+opordno-1)
	.s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	.s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	.s age=##class(web.UDHCANOPArrange).CalAge(birth,+$h)
	.s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	.q:(registerNo'="")&&(registerNo'=regNo)
	.;s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	.s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	.s medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
	.s loc=$P(^PAADM(EpisodeID),"^",4)
	.s locdes=$P(^CTLOC(loc),"^",2)
	.i $l(locdes,"-")=2 s locdes=$p(locdes,"-",2)
	.s i=0
	.s subchl=0 f  s subchl=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl)) q:(subchl="")  d
	..s opdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",6)       		;ANAOP_Type_DR     ；手术名称
	..i +opdr=opdr d
	...i $P($g(^ORC("OPER",+opdr)),"^",2)'="" d     
	....i opdes'="" s opdes=opdes_";"     
	....s opdes=opdes_$P($g(^ORC("OPER",+opdr)),"^",2)     
	..e  d
	...i $g(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"REM",1))'="" d
	....i opdes'="" s opdes=opdes_";"_^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"REM",1)
	....e  s opdes=^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"REM",1)    
	..s i=i+1
	..q:i>1   
	..s sub=subchl
	..s docdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",8)      		;ANAOP_Surgeon_DR   手术医师
	..i +docdr=docdr s opd=##class(web.DHCANOPCom).GetNameById(docdr)
	..e  s opd=$TR($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ","")      ; 手术医生备注(外来手术医生)	   
	..s predigdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",4)   	    ;ANAOP_PreopDiag_DR 术前诊断
	..i +predigdr=predigdr s diag=$P($g(^MRC("ID",predigdr)),"^",2)
	..e  d
	...i $g(^OR(EpisodeID,"ANA",anaSub,"TXT",2))'="" s diag=$g(^OR(EpisodeID,"ANA",anaSub,"TXT",2))  //ck 20101116		
	..s operLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",10)
	.s admLocId=$p($g(^PAADM(EpisodeID)),"^",4)
	.//q:(("^"_userLocIdStr_"^")'[("^"_+operLocId_"^"))&(("^"_userLocIdStr_"^")'[("^"_+admLocId_"^"))
	.s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
	.s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)  
	.i curWardId'="" s WardDes=$P(^PAWARD(curWardId),"^",1)
	.i (bedSub'="")&(curWardId'="") s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
	.s jz=$P(^OR(EpisodeID,"ANA",anaSub),"^",32) //急诊(E)/择期(B
	.i jz="E" s jzstat="急诊"
	.e  s jzstat="择期"
	.s patWardId=$P($G(^DHCANOPArrange(opaId)),"^",32)
	.i patWardId'="" s patWard=$P($G(^PAWARD(patWardId)),"^",2)
	.i $l(patWard,"-")=2 s patWard=$p(patWard,"-",2)
	.s inAreaDate=$p(^OR(+anaId,"ANA",anaSub),"^",35)
	.s inAreaTime=$p(^OR(+anaId,"ANA",anaSub),"^",36)
	.s OutAreaDate=$p(^OR(+anaId,"ANA",anaSub),"^",37)
	.s OutAreaTime=$p(^OR(+anaId,"ANA",anaSub),"^",38)
	.s ^tempck("inarea",2)=$zd(OutAreaDate,3)_"/"_$zt(OutAreaTime)
	.s inRoomDate=$p(^OR(+anaId,"ANA",anaSub),"^",39)
	.//s inRoomDate=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",7) 
	.s inRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",40)
	.//s inRoomTime=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",8) 
	.//q:(inRoomFlag=1)&&((inRoomDate="")!(inRoomTime=""))
	.//s userId=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",9)
	.s userId=""
	.s userIdStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"inRoomRecorder")
	.i userIdStr'="" s userId=$p(userIdStr,$c(3),1)
	.s inRoomRecorder=""
	.i userId'="" s inRoomRecorder=$p($g(^SSU("SSUSR",userId)),"^",2)
	.s outRoomDate=$p(^OR(+anaId,"ANA",anaSub),"^",41)
	.//s outRoomDate=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",31) 
	.s outRoomTime=$p(^OR(+anaId,"ANA",anaSub),"^",42)
	.//s outRoomTime=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",32) 
	.//q:(outRoomFlag=1)&&((outRoomDate="")!(outRoomTime=""))
	.//s userId=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",33) 
	.s userId=""
	.s userIdStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"outRoomRecorder")
	.i userIdStr'="" s userId=$p(userIdStr,$c(3),1)
	.s outRoomRecorder="" 
	.i userId'="" s outRoomRecorder=$p($g(^SSU("SSUSR",userId)),"^",2)
	.s inPACUDate=$p(^DHCANOPArrange(opaId,"PACU"),"^",6)
	.s inPACUTime=$p(^DHCANOPArrange(opaId,"PACU"),"^",7)
	.s outPACUDate=$p(^DHCANOPArrange(opaId,"PACU"),"^",8)
	.s outPACUTime=$p(^DHCANOPArrange(opaId,"PACU"),"^",9)
	.i inAreaDate'="" s inArea=$zd($g(inAreaDate),format)
	.i inAreaTime'="" s inArea=inArea_" "_$zt($g(inAreaTime),2)		
	.i OutAreaDate'="" s outArea=$zd($g(OutAreaDate),format)
	.i OutAreaTime'="" s outArea=outArea_" "_$zt($g(OutAreaTime),2)		
	.i inRoomDate'="" s inRoom=$zd(inRoomDate,format)
	.i inRoomTime'="" s inRoom=inRoom_" "_$zt(inRoomTime,2)
	.i inPACUDate'="" s inPACU=$zd(inPACUDate,format)
	.i inPACUTime'="" s inPACU=inPACU_" "_$zt(inPACUTime,2)
	.i outPACUDate'="" s outPACU=$zd(outPACUDate,format)
	.i outPACUTime'="" s outPACU=outPACU_" "_$zt(outPACUTime,2)
	.i outRoomDate'="" s outRoom=$zd(outRoomDate,format)
	.i outRoomTime'="" s outRoom=outRoom_" "_$zt(outRoomTime,2)
	.s ^ANOPTemp("ReceivePat",$j,oproomdr,opordno,j)=$lb(oproomdes,opordno,patName,sex,age,medCareNo,regNo,locdes,bedCode,opdate,jzstat,Status,patWard,oproomdr,opaId,EpisodeID,loc,opordcon,opdes,opd,diag,inArea,inRoom,inPACU,outPACU,outRoom,outArea,inRoomRecorder,outRoomRecorder)
	.s j=j+1

	s oproomdr="" f  s oproomdr=$o(^ANOPTemp("ReceivePat",$j,oproomdr)) q:oproomdr=""  d
	.s opordno=""  f  s opordno=$o(^ANOPTemp("ReceivePat",$j,oproomdr,opordno)) q:opordno=""  d
	..s j=0  f  s j=$o(^ANOPTemp("ReceivePat",$j,oproomdr,opordno,j)) q:j=""  d
	...d OutOPInfoList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutOPInfoList
	Set ^CacheTemp(repid,ind)=^ANOPTemp("ReceivePat",$j,oproomdr,opordno,j)
	Set ind=ind+1
	Quit
}

ClassMethod GetOpInfoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpInfoListExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetOpInfoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpInfoListExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// Creator:yq
/// CreatDate:2018-11-09
/// Decription:根据当前手术日期的病人的手术OpaId
/// return:opaId,-1手术不存在
ClassMethod GetOpaIdByRegNo(opDate, registerNo) As %String
{
	q:registerNo="" "登记号不能为空！"
	s ret="-1"
	i opDate="" s date=+$h
	e  s date=##class(web.DHCClinicCom).ConvertToDateH(opDate)
	s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
	.q:$d(^DHCANOPArrange(opaId))<1
	.s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
	.q:EpisodeID=""
	.s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	.i registerNo=regNo s ret=opaId q
	q ret
}

/// Creator:yq
/// CreatDate:2018-11-09
/// Decription:根据opaId返回病人基本信息
/// return:opaId,-1手术不存在
ClassMethod GetOperInfoByOpaId(opaId) As %String
{
	q:opaId="" "opaId不能为空！"
	s oproomdes="",opordno="",patName="",sex="",age="",medCareNo="",regNo="",locdes="",bedCode="",opdate="",jzstat="",Status="",patWard="",oproomdr="",EpisodeID="",loc="",patWardId="",opordcon="",anmethod="",opdes=""
	s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
	q:EpisodeID=""
	s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
	q:oproomdr=""	
	s oproomdes=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
	s opordno=$P(^DHCANOPArrange(opaId),"^",26)
	i opordno="" s opordno="未排"
	q:opordno=""
	i +opordno=1 s opordcon=$zt($g(opsttime),2)
	e  s opordcon="接台"_(+opordno-1)
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	s age=##class(web.UDHCANOPArrange).CalAge(birth,+$h)
	s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	//s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	s medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
	s loc=$P(^PAADM(EpisodeID),"^",4)
	s locdes=$P(^CTLOC(loc),"^",2)
	i $l(locdes,"-")=2 s locdes=$p(locdes,"-",2)
	s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
	s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)  
	i curWardId'="" s WardDes=$P(^PAWARD(curWardId),"^",1)
	i (bedSub'="")&(curWardId'="") s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
	
	s adm=EpisodeID
	s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	s anmthdr=$P(^OR(adm,"ANA",chl),"^",5)
	s anmthdr=$tr(anmthdr,"|",",")
	i anmthdr'="" d
	.s anmetNum=$l(anmthdr,",")
	.f i=1:1:anmetNum d
	..s anmetId=$p(anmthdr,",",i)
	..q:anmetId=""
	..s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2)
	..i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
	..i anmethod="" s anmethod=anmetDesc
	..;e  s anmethod=anmethod_","_anmetDesc
	..e  i (anmethod'="")&(anmethod'[anmetDesc) s anmethod=anmethod_","_anmetDesc
	..e  i (anmethod'="")&(anmethod[anmetDesc) s anmethod=anmethod
	
	s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d 
	.s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6)       		
	.i opdr'=""  d   //ck091210
	..i $P($g(^ORC("OPER",+opdr)),"^",2)'="" d     
		...i opdes'="" s opdes=opdes_";"     
		...s opdes=opdes_$P($g(^ORC("OPER",+opdr)),"^",2)     
	.e  d
	..i $g(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))'="" d
	...i opdes'="" s opdes=opdes_";"
	...s opdes=opdes_$G(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))    
	
	.s bodsIdList=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",24) 	 
	.s bodsList="",bodsDesc=""
	.i bodsIdList'="" d
	..s bodsIdNum=$l(bodsIdList,"|")
	..f j=1:1:bodsIdNum d
	...s bodsId=$p(bodsIdList,"|",j)
	...q:bodsId=""
	...s bodsDesc2=$p($g(^OEC("BODS",+bodsId)),"^",2)
	...;i bodsList="" s bodsList=bodsId_"|"_bodsDesc
	...;e  s bodsList=bodsList_"!"_bodsId_"|"_bodsDesc	
	...i bodsDesc="" s bodsDesc=bodsDesc2
	...e  s bodsDesc=bodsDesc_","_bodsDesc2 
	
	q oproomdr_"^"_oproomdes_"^"_opordno_"^"_patName_"^"_sex_"^"_age_"^"_medCareNo_"^"_regNo_"^"_locdes_"^"_bedCode_"^"_anmethod_"^"_opdes_"^"_bodsDesc
}

}
