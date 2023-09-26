Class dhc.qm.udata.uPatShow Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

ClassMethod IfRepCode(PatShowCode) As %String
{
	new (PatShowCode)
	s rowid=0
	s rowid=$o(^DHCCJXQMPatShowI("PatShowCode",PatShowCode,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Others:w ##class(dhc.qm.udata.uPatShow).List("","",0,25)
ClassMethod List(sortField, sortDir, start, limit) As %String
{
	n (sortField,sortDir,start,limit)
	s sqlStr="SELECT PatShow_rowid, PatShow_code, PatShow_name, PatShow_desc, PatShow_active FROM dhc_qm_data.PatShow"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()

	s count=0
	s resultString=""
	s end=start+limit-1

	s json=##class(herp.comm.JsonObj).%New()
	s jsonTitle="rowid^code^name^desc^active"
	While(result.Next())
	{
	s rowid= result.Data("PatShow_rowid")
	s code= result.Data("PatShow_code")
	s name= result.Data("PatShow_name")
	s desc= result.Data("PatShow_desc")
	s active= result.Data("PatShow_active")


	s temp=rowid_"^"_code_"^"_name_"^"_desc_"^"_active
	i (count>=start)&(count<=end) d
	.d json.InsertRowData(temp)
	s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

/// Others:w ##class(dhc.qm.udata.uPatShow).InsertRec("code1","name","desc","Y")
ClassMethod InsertRec(code, name, desc, active) As %String
{
	n (code,name,desc,active)

	s rowid=0
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"


	&sql(INSERT INTO dhc_qm_data.PatShow VALUES (:code,:name,:desc,:active ))

	q SQLCODE
}

/// Others:w ##class(dhc.qm.udata.uPatShow).UpdateRec(2,"code3","","","")
ClassMethod UpdateRec(rowid, code, name, desc, active) As %String
{
	n (rowid,code,name,desc,active)

	i code'=""
	{
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepCode"
	}

 	i code =""  s Plist(2) = $list(^DHCCJXQMPatShowD(rowid),2)
 	i name =""  s Plist(3) = $list(^DHCCJXQMPatShowD(rowid),3)
 	i desc =""  s Plist(4) = $list(^DHCCJXQMPatShowD(rowid),4)
 	i active =""  s Plist(5) = $list(^DHCCJXQMPatShowD(rowid),5)
 	i code '=""  s Plist(2) = code
 	i name '=""  s Plist(3) = name
 	i desc '=""  s Plist(4) = desc
 	i active '=""  s Plist(5) = active
	&sql(UPDATE dhc_qm_data.PatShow VALUES Plist() where %ID=:rowid)
	q SQLCODE
}

ClassMethod Delete(rowid) As %String
{
	&sql( DELETE FROM dhc_qm_data.PatShow WHERE %ID=:rowid)

	q SQLCODE
}

/// 创建：wbg 2015年6月21日
/// 说明：按医嘱执行日期查询病区病人信息
/// 入参：开始日期，结束日期，病房id，医嘱号
/// 出参：就诊号^病案号^病人姓名^医嘱名称^要求执行日期^实际执行日期^管床医生code^管床医生姓名^医嘱号
/// d ##class(dhc.qm.udata.uPatShow).GetAdminfobyOrdexDate("2014-01-01","2014-01-31","5","1284||1,1370||1")
ClassMethod GetAdminfobyOrdexDate(StDate, EnDate, Wardid, arcitemstr)
{
	s RoomDR=""
	f  s RoomDR=$O(^PAADMi("CurrWard",Wardid,RoomDR)) q:RoomDR=""  d
	.s adm=""
	.f  s adm=$O(^PAADMi("CurrWard",Wardid,RoomDR,adm))  q:adm=""  d
	..s ORDId=""
	..f  s ORDId=$O(^OEORD(0,"Adm",adm,ORDId)) q:ORDId=""  d
    ...s n=$L(arcitemstr,",")
	...f i=1:1:n d
	....s arcitem=$P(arcitemstr,",",i)
	....s SttDate=""
	....f  s SttDate=$O(^OEORDi(0,"ARCIM",ORDId,arcitem,SttDate)) q:SttDate=""  d
	.....s OrdSub=""
	.....f  s OrdSub=$O(^OEORDi(0,"ARCIM",ORDId,arcitem,SttDate,OrdSub)) q:OrdSub=""  d
    ......s OrdExsub=""
	......f  s OrdExsub=$O(^OEORD(ORDId,"I",OrdSub,"X",OrdExsub)) q:OrdExsub=""  d
	.......s OrdExDate=$P(^OEORD(ORDId,"I",OrdSub,"X",OrdExsub),"^",19) //实际执行日期
	.......q:OrdExDate=""
	.......;b ;OrdExsub
	.......q:((OrdExDate<$zdh(StDate,3))||(OrdExDate>($h-1))) //执行时间要超过24小时
	.......s ExStDate=$P(^OEORD(ORDId,"I",OrdSub,"X",OrdExsub),"^",1) //要求执行日期
	.......s Papmidr=$P(^PAADM(adm),"^",1)
	.......S PatName=$P(^PAPER(Papmidr,"ALL"),"^",1)
	.......s PatNO=$P(^PAPER(Papmidr,"PAT",1),"^",1)
	.......s Medicare=$P(^PAPER(Papmidr,"PAT",1),"^",22) //病案号
	.......S AdmDocDR=$P(^PAADM(adm),"^",9)
	.......s AdmDocCode=$P(^CTPCP(AdmDocDR,1),"^",1)
	.......s AdmDocName=$P(^CTPCP(AdmDocDR,1),"^",2) //管床医生
	.......s ArcitDesc=$P(^ARCIM(+arcitem,$P(arcitem,"||",2),1),"^",2)
	.......w !,adm_"^"_Medicare_"^"_PatName_"^"_ArcitDesc_"^"_$zd(ExStDate,3)_"^"_$Zd(OrdExDate,3)_"^"_AdmDocCode_"^"_AdmDocName_"^"_ORDId_"||"_OrdSub
}

Storage Default
{
<StreamLocation>^dhc.qm.udata.uPatShowS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
