/// CTOR: QP
/// DATE: 2020-09-24
/// DESC: 数据
Class DHCDoc.GCPSW.BS.Data Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-09-24
/// DESC: 自动同步数据到主库上
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Data).AutoSyncData()
ClassMethod AutoSyncData()
{
	k ^BS.DOC.GCPSW.TempTask($j)
	
	s Ret=1
	s ws=##class(DHCDoc.GCPSW.ENS.ServiceSoap).%New()
	s startDate=+$H,startTime=$p($H,",",2)
	
	;获取数据
	s A=..GetResult("data")
	;b ;089
	s A=..GetResultAdm(A,"data")
	s A=..GetResultLis(A,"data")
	;s A=..GetTaskLog(A,"data")
	
	s B=..GetResult("idx")
	s B=..GetResultAdm(B,"idx")
	s B=..GetResultLis(B,"idx")
	;s B=..GetTaskLog(B,"idx")
	;b ;0012
	;开始记录
	s ws=##class(DHCDoc.GCPSW.ENS.ServiceSoap).%New()
	s LID=##class(DHCDoc.GCPSW.BS.TaskLog).Save("","","WS")
	;s SLID=ws.RecStart()
	s startDate=+$H,startTime=$p($H,",",2)
	
	s i=0
	f  s i=$o(^BS.DOC.GCPSW.TempTask($j,"data",i)) q:i=""  d
	.s mList=$g(^BS.DOC.GCPSW.TempTask($j,"data",i))
	.s Ret=ws.SyncData(mList)
	
	s j=0
	f  s j=$o(^BS.DOC.GCPSW.TempTask($j,"idx",j)) q:j=""  d
	.s mList=$g(^BS.DOC.GCPSW.TempTask($j,"idx",j))
	.s Ret=ws.SyncIndex(mList)
	
	;s endDate=+$H,endTime=$p($H,",",2)
	;s InList="^WSG^"_startDate_"^"_startTime_"^"_endDate_"^"_endTime
	;d ws.RecEnd(InList)
	
	//结束
	k ^BS.DOC.GCPSW.TempTask($j)
	d ##class(DHCDoc.GCPSW.BS.TaskLog).Save("",LID)
	
	
	;同步日志数据
	s A=..GetTaskLog("data")
	s B=..GetTaskLog("idx")
	
	s i=0
	f  s i=$o(^BS.DOC.GCPSW.TempTask($j,"data",i)) q:i=""  d
	.s mList=$g(^BS.DOC.GCPSW.TempTask($j,"data",i))
	.s Ret=ws.SyncData(mList)
	
	s j=0
	f  s j=$o(^BS.DOC.GCPSW.TempTask($j,"idx",j)) q:j=""  d
	.s mList=$g(^BS.DOC.GCPSW.TempTask($j,"idx",j))
	.s Ret=ws.SyncIndex(mList)
	
	//结束
	k ^BS.DOC.GCPSW.TempTask($j)
	
	;同步计数器
	;^BS.DOC.GCPSW.Result(0)
	
	
	Q Ret
}

/// CTOR: QP
/// DATE: 2020-09-24
/// DESC: 获取Result 数据
/// IN  : AllFlag:1，取所有数据，否则同步日志表里最新完成日期为起点的数据
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Data).GetResult("data")
ClassMethod GetResult(Type)
{
	s A=0
	s wsDate=..GetWSStartDate()
	i Type="data" {
		s id="",num=0,mList=""
		f  s id=$o(^BS.DOC.GCPSW.ResultD(id)) q:id=""  d
		.s AddDate=$p(^BS.DOC.GCPSW.ResultD(id),"^",5)
		.s isExit=..FilterDate(AddDate,wsDate)
		.q:isExit=1
		.s num=num+1
		.s rec=$g(^BS.DOC.GCPSW.ResultD(id))
		.s rec=id_"@"_rec
		.i (num#500)=0 d
		..s ^BS.DOC.GCPSW.TempTask($j,"data",$i(A))=mList
		..s mList=""
		.e  d
		..i mList="" s mList=rec
		..e  s mList=mList_"!"_rec
		
		i mList'="" s ^BS.DOC.GCPSW.TempTask($j,"data",$i(A))=mList
	} 
	i Type="idx" {
		s num=0,mList=""
		s prj=""
		f  s prj=$o(^BS.DOC.GCPSW.ResultI("RPrj",prj)) q:prj=""  d
		.s id=""
		.f  s id=$o(^BS.DOC.GCPSW.ResultI("RPrj",prj,id)) q:id=""  d
		..q:'$d(^BS.DOC.GCPSW.ResultD(id))
		..s AddDate=$p(^BS.DOC.GCPSW.ResultD(id),"^",5)
		..s isExit=..FilterDate(AddDate,wsDate)
		..q:isExit=1
		..s num=num+1
		..s rec="RPrj^"_prj_"^"_id
		..i (num#500)=0 d
		...s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		...s mList=""
		..e  d
		...i mList="" s mList=rec
		...e  s mList=mList_"!"_rec
		
		i mList'="" s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		
		s num=0,mList=""
		s prj=""
		f  s prj=$o(^BS.DOC.GCPSW.ResultI("PrjPat",prj)) q:prj=""  d
		.s patientID=""
		.f  s patientID=$o(^BS.DOC.GCPSW.ResultI("PrjPat",prj,patientID)) q:patientID=""  d
		..s id=$o(^BS.DOC.GCPSW.ResultI("PrjPat",prj,patientID,""))
		..q:'$d(^BS.DOC.GCPSW.ResultD(id))
		..s AddDate=$p(^BS.DOC.GCPSW.ResultD(id),"^",5)
		..s isExit=..FilterDate(AddDate,wsDate)
		..q:isExit=1
		..s num=num+1
		..s rec="PrjPat^"_prj_"^"_patientID_"^"_id
		..i (num#500)=0 d
		...s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		...s mList=""
		..e  d
		...i mList="" s mList=rec
		...e  s mList=mList_"!"_rec
		
		i mList'="" s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		
		
	}
	Q A
}

/// CTOR: QP
/// DATE: 2020-09-24
/// DESC: 获取ResultAdm 数据
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Data).GetResultAdm()
ClassMethod GetResultAdm(A, Type)
{
	s wsDate=..GetWSStartDate()
	i Type="data" {
		s id="",num=0,mList=""
		f  s id=$o(^BS.DOC.GCPSW.ResultD(id)) q:id=""  d
		.s sub=""
		.f  s sub=$o(^BS.DOC.GCPSW.ResultD(id,"A",sub)) q:sub=""  d
		..s recAdm=$g(^BS.DOC.GCPSW.ResultD(id,"A",sub))
		..s AddDate=$p(^BS.DOC.GCPSW.ResultD(id,"A",sub),"^",4)
		..s isExit=..FilterDate(AddDate,wsDate)
		..q:isExit=1
		..s node=id_"^A^"_sub
		..s recAdm=node_"@"_recAdm
		..s num=num+1
		..i (num#500)=0 d
		...s ^BS.DOC.GCPSW.TempTask($j,"data",$i(A))=mList
		...s mList=""
		..e  d
		...i mList="" s mList=recAdm
		...e  s mList=mList_"!"_recAdm
		
		i mList'="" s ^BS.DOC.GCPSW.TempTask($j,"data",$i(A))=mList
	}
	i Type="idx" {
		
		//Oeori索引
		s num=0,mList=""
		s RID=""
		f  s RID=$o(^BS.DOC.GCPSW.ResultI("ResultAdm","Oeori",RID)) q:RID=""  d
		.s oeori=""
		.f  s oeori=$o(^BS.DOC.GCPSW.ResultI("ResultAdm","Oeori",RID,oeori)) q:oeori=""  d
		..s sub=""
		..f  s sub=$o(^BS.DOC.GCPSW.ResultI("ResultAdm","Oeori",RID,oeori,sub)) q:sub=""  d
		...q:'$d(^BS.DOC.GCPSW.ResultD(RID,"A",sub))	//过滤垃圾数据
		...s recAdm=$g(^BS.DOC.GCPSW.ResultD(RID,"A",sub))
		...s AddDate=$p(^BS.DOC.GCPSW.ResultD(RID,"A",sub),"^",4)
		...s isExit=..FilterDate(AddDate,wsDate)
		...q:isExit=1
		...s num=num+1
		...s rec="ResultAdm^Oeori^"_RID_"^"_oeori_"^"_sub
		...i (num#500)=0 d
		....s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		....s mList=""
		...e  d
		....i mList="" s mList=rec
		....e  s mList=mList_"!"_rec
		
		i mList'="" s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		
		//Arcim索引
		s num=0,mList=""
		s RID=""
		f  s RID=$o(^BS.DOC.GCPSW.ResultI("ResultAdm","Arcim",RID)) q:RID=""  d
		.s arcim=""
		.f  s arcim=$o(^BS.DOC.GCPSW.ResultI("ResultAdm","Arcim",RID,arcim)) q:arcim=""  d
		..s sub=""
		..f  s sub=$o(^BS.DOC.GCPSW.ResultI("ResultAdm","Arcim",RID,arcim,sub)) q:sub=""  d
		...q:'$d(^BS.DOC.GCPSW.ResultD(RID,"A",sub))
		...s recAdm=$g(^BS.DOC.GCPSW.ResultD(RID,"A",sub))
		...s AddDate=$p(^BS.DOC.GCPSW.ResultD(RID,"A",sub),"^",4)
		...s isExit=..FilterDate(AddDate,wsDate)
		...q:isExit=1
		...s num=num+1
		...s rec="ResultAdm^Arcim^"_RID_"^"_arcim_"^"_sub
		...i (num#500)=0 d
		....s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		....s mList=""
		...e  d
		....i mList="" s mList=rec
		....e  s mList=mList_"!"_rec
		
		i mList'="" s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		
		//Adm索引
		s num=0,mList=""
		s RID=""
		f  s RID=$o(^BS.DOC.GCPSW.ResultI("ResultAdm","Adm",RID)) q:RID=""  d
		.s arcim=""
		.f  s arcim=$o(^BS.DOC.GCPSW.ResultI("ResultAdm","Adm",RID,arcim)) q:arcim=""  d
		..s sub=""
		..f  s sub=$o(^BS.DOC.GCPSW.ResultI("ResultAdm","Adm",RID,arcim,sub)) q:sub=""  d
		...q:'$d(^BS.DOC.GCPSW.ResultD(RID,"A",sub))
		...s recAdm=$g(^BS.DOC.GCPSW.ResultD(RID,"A",sub))
		...s AddDate=$p(^BS.DOC.GCPSW.ResultD(RID,"A",sub),"^",4)
		...s isExit=..FilterDate(AddDate,wsDate)
		...q:isExit=1
		...s num=num+1
		...s rec="ResultAdm^Adm^"_RID_"^"_arcim_"^"_sub
		...i (num#500)=0 d
		....s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		....s mList=""
		...e  d
		....i mList="" s mList=rec
		....e  s mList=mList_"!"_rec
		
		i mList'="" s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		
		//AddDate索引
		s num=0,mList=""
		s RID=""
		f  s RID=$o(^BS.DOC.GCPSW.ResultI("ResultAdm","AddDate",RID)) q:RID=""  d
		.s arcim=""
		.f  s arcim=$o(^BS.DOC.GCPSW.ResultI("ResultAdm","AddDate",RID,arcim)) q:arcim=""  d
		..s sub=""
		..f  s sub=$o(^BS.DOC.GCPSW.ResultI("ResultAdm","AddDate",RID,arcim,sub)) q:sub=""  d
		...q:'$d(^BS.DOC.GCPSW.ResultD(RID,"A",sub))
		...s recAdm=$g(^BS.DOC.GCPSW.ResultD(RID,"A",sub))
		...s AddDate=$p(^BS.DOC.GCPSW.ResultD(RID,"A",sub),"^",4)
		...s isExit=..FilterDate(AddDate,wsDate)
		...q:isExit=1
		...s num=num+1
		...s rec="ResultAdm^AddDate^"_RID_"^"_arcim_"^"_sub
		...i (num#500)=0 d
		....s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		....s mList=""
		...e  d
		....i mList="" s mList=rec
		....e  s mList=mList_"!"_rec
		
		i mList'="" s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		
	}
	
	Q A
}

/// CTOR: QP
/// DATE: 2021-03-05
/// DESC: 获取ResultLis 数据
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Data).GetResultAdm()
ClassMethod GetResultLis(A, Type)
{
	s wsDate=..GetWSStartDate()
	i Type="data" {
		s id="",num=0,mList=""
		f  s id=$o(^BS.DOC.GCPSW.ResultD(id)) q:id=""  d
		.s sub=""
		.f  s sub=$o(^BS.DOC.GCPSW.ResultD(id,"L",sub)) q:sub=""  d
		..q:'$d(^BS.DOC.GCPSW.ResultD(id,"L",sub))
		..s recAdm=$g(^BS.DOC.GCPSW.ResultD(id,"L",sub))
		..s AddDate=$p(^BS.DOC.GCPSW.ResultD(id,"L",sub),"^",5)
		..s isExit=..FilterDate(AddDate,wsDate)
		..q:isExit=1
		..s node=id_"^L^"_sub
		..s recAdm=node_"@"_recAdm
		..s num=num+1
		..i (num#500)=0 d
		...s ^BS.DOC.GCPSW.TempTask($j,"data",$i(A))=mList
		...s mList=""
		..e  d
		...i mList="" s mList=recAdm
		...e  s mList=mList_"!"_recAdm
		
		i mList'="" s ^BS.DOC.GCPSW.TempTask($j,"data",$i(A))=mList
	}
	i Type="idx" {
		
		//Code索引
		s num=0,mList=""
		s RID=""
		f  s RID=$o(^BS.DOC.GCPSW.ResultI("ResultLis","Code",RID)) q:RID=""  d
		.s Code=""
		.f  s Code=$o(^BS.DOC.GCPSW.ResultI("ResultLis","Code",RID,Code)) q:Code=""  d
		..s sub=""
		..f  s sub=$o(^BS.DOC.GCPSW.ResultI("ResultLis","Code",RID,Code,sub)) q:sub=""  d
		...q:'$d(^BS.DOC.GCPSW.ResultD(RID,"L",sub))
		...s recAdm=$g(^BS.DOC.GCPSW.ResultD(RID,"L",sub))
		...s AddDate=$p(^BS.DOC.GCPSW.ResultD(RID,"L",sub),"^",5)
		...s isExit=..FilterDate(AddDate,wsDate)
		...q:isExit=1
		...s num=num+1
		...s rec="ResultLis^Code^"_RID_"^"_Code_"^"_sub
		...i (num#500)=0 d
		....s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		....s mList=""
		...e  d
		....i mList="" s mList=rec
		....e  s mList=mList_"!"_rec
		
		i mList'="" s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		
		//ArcimCode索引
		s num=0,mList=""
		s RID=""
		f  s RID=$o(^BS.DOC.GCPSW.ResultI("ResultLis","ArcimCode",RID)) q:RID=""  d
		.s Arcim=""
		.f  s Arcim=$o(^BS.DOC.GCPSW.ResultI("ResultLis","ArcimCode",RID,Arcim)) q:Arcim=""  d
		..s Code=""
		..f  s Code=$o(^BS.DOC.GCPSW.ResultI("ResultLis","ArcimCode",RID,Arcim,Code)) q:Code=""  d
		...s sub=""
		...f  s sub=$o(^BS.DOC.GCPSW.ResultI("ResultLis","ArcimCode",RID,Arcim,Code,sub)) q:sub=""  d
		....q:'$d(^BS.DOC.GCPSW.ResultD(RID,"L",sub))
		....s recAdm=$g(^BS.DOC.GCPSW.ResultD(RID,"L",sub))
		....s AddDate=$p(^BS.DOC.GCPSW.ResultD(RID,"L",sub),"^",5)
		....s isExit=..FilterDate(AddDate,wsDate)
		....q:isExit=1
		....s num=num+1
		....s rec="ResultLis^ArcimCode^"_RID_"^"_Arcim_"^"_Code_"^"_sub
		....i (num#500)=0 d
		.....s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		.....s mList=""
		....e  d
		.....i mList="" s mList=rec
		.....e  s mList=mList_"!"_rec
		
		i mList'="" s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList

	}
	
	Q A
}

/// CTOR: QP
/// DATE: 2021-04-21
/// DESC: 获取GCPSWTaskLog 数据
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Data).GetResultAdm()
ClassMethod GetTaskLog(Type)
{
	s A=0
	s wsDate=..GetWSStartDate()
	i Type="data" {
		s id="",num=0,mList=""
		f  s id=$o(^BS.DOC.GCPSW.TaskLogD(id)) q:id=""  d
		.s AddDate=$p(^BS.DOC.GCPSW.TaskLogD(id),"^",2)
		.s isExit=..FilterDate(AddDate,wsDate)
		.q:isExit=1
		.s num=num+1
		.s rec=$g(^BS.DOC.GCPSW.TaskLogD(id))
		.s rec=id_"@"_rec_"@"_"TaskLog"
		.i (num#500)=0 d
		..s ^BS.DOC.GCPSW.TempTask($j,"data",$i(A))=mList
		..s mList=""
		.e  d
		..i mList="" s mList=rec
		..e  s mList=mList_"!"_rec
		
		i mList'="" s ^BS.DOC.GCPSW.TempTask($j,"data",$i(A))=mList
	} 
	i Type="idx" {
		;1 EndDate索引
		s num=0,mList=""
		s prj=""
		f  s prj=$o(^BS.DOC.GCPSW.TaskLogI("EndDate",prj)) q:prj=""  d
		.s id=""
		.f  s id=$o(^BS.DOC.GCPSW.TaskLogI("EndDate",prj,id)) q:id=""  d
		..q:'$d(^BS.DOC.GCPSW.TaskLogD(id))
		..s AddDate=$p(^BS.DOC.GCPSW.TaskLogD(id),"^",2)
		..s isExit=..FilterDate(AddDate,wsDate)
		..q:isExit=1
		..s num=num+1
		..s rec="TaskLog-EndDate^"_prj_"^"_id
		..i (num#500)=0 d
		...s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		...s mList=""
		..e  d
		...i mList="" s mList=rec
		...e  s mList=mList_"!"_rec
		
		i mList'="" s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		
		;2 StartDate索引
		s num=0,mList=""
		s prj=""
		f  s prj=$o(^BS.DOC.GCPSW.TaskLogI("StartDate",prj)) q:prj=""  d
		.s id=""
		.f  s id=$o(^BS.DOC.GCPSW.TaskLogI("StartDate",prj,id)) q:id=""  d
		..q:'$d(^BS.DOC.GCPSW.TaskLogD(id))
		..s AddDate=$p(^BS.DOC.GCPSW.TaskLogD(id),"^",2)
		..s isExit=..FilterDate(AddDate,wsDate)
		..q:isExit=1
		..s num=num+1
		..s rec="TaskLog-StartDate^"_prj_"^"_id
		..i (num#500)=0 d
		...s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		...s mList=""
		..e  d
		...i mList="" s mList=rec
		...e  s mList=mList_"!"_rec
		
		i mList'="" s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		
		;3 Prj索引
		s num=0,mList=""
		s prj=""
		f  s prj=$o(^BS.DOC.GCPSW.TaskLogI("Prj",prj)) q:prj=""  d
		.s id=""
		.f  s id=$o(^BS.DOC.GCPSW.TaskLogI("Prj",prj,id)) q:id=""  d
		..q:'$d(^BS.DOC.GCPSW.TaskLogD(id))
		..s AddDate=$p(^BS.DOC.GCPSW.TaskLogD(id),"^",2)
		..s isExit=..FilterDate(AddDate,wsDate)
		..q:isExit=1
		..s num=num+1
		..s rec="TaskLog-Prj^"_prj_"^"_id
		..i (num#500)=0 d
		...s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		...s mList=""
		..e  d
		...i mList="" s mList=rec
		...e  s mList=mList_"!"_rec
		
		i mList'="" s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		
		;4 Type索引
		s num=0,mList=""
		s prj=""
		f  s prj=$o(^BS.DOC.GCPSW.TaskLogI("Type",prj)) q:prj=""  d
		.s id=""
		.f  s id=$o(^BS.DOC.GCPSW.TaskLogI("Type",prj,id)) q:id=""  d
		..q:'$d(^BS.DOC.GCPSW.TaskLogD(id))
		..s AddDate=$p(^BS.DOC.GCPSW.TaskLogD(id),"^",2)
		..s isExit=..FilterDate(AddDate,wsDate)
		..q:isExit=1
		..s num=num+1
		..s rec="TaskLog-Type^"_prj_"^"_id
		..i (num#500)=0 d
		...s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		...s mList=""
		..e  d
		...i mList="" s mList=rec
		...e  s mList=mList_"!"_rec
		
		i mList'="" s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		
		;5 EndDatePrj索引
		s num=0,mList=""
		s EndDate=""
		f  s EndDate=$o(^BS.DOC.GCPSW.TaskLogI("EndDatePrj",EndDate)) q:EndDate=""  d
		.s prj=""
		.f  s prj=$o(^BS.DOC.GCPSW.TaskLogI("EndDatePrj",EndDate,prj)) q:prj=""  d
		..s id=""
		..f  s id=$o(^BS.DOC.GCPSW.TaskLogI("EndDatePrj",EndDate,prj,id)) q:id=""  d
		...q:'$d(^BS.DOC.GCPSW.TaskLogD(id))
		...s AddDate=$p(^BS.DOC.GCPSW.TaskLogD(id),"^",2)
		...s isExit=..FilterDate(AddDate,wsDate)
		...q:isExit=1
		...s num=num+1
		...s rec="TaskLog-EndDatePrj^"_EndDate_"^"_prj_"^"_id
		...i (num#500)=0 d
		....s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		....s mList=""
		...e  d
		....i mList="" s mList=rec
		....e  s mList=mList_"!"_rec
		
		i mList'="" s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		
		;6 StartDatePrj索引
		s num=0,mList=""
		s EndDate=""
		f  s EndDate=$o(^BS.DOC.GCPSW.TaskLogI("StartDatePrj",EndDate)) q:EndDate=""  d
		.s prj=""
		.f  s prj=$o(^BS.DOC.GCPSW.TaskLogI("StartDatePrj",EndDate,prj)) q:prj=""  d
		..s id=""
		..f  s id=$o(^BS.DOC.GCPSW.TaskLogI("StartDatePrj",EndDate,prj,id)) q:id=""  d
		...q:'$d(^BS.DOC.GCPSW.TaskLogD(id))
		...s AddDate=$p(^BS.DOC.GCPSW.TaskLogD(id),"^",2)
		...s isExit=..FilterDate(AddDate,wsDate)
		...q:isExit=1
		...s num=num+1
		...s rec="TaskLog-StartDatePrj^"_EndDate_"^"_prj_"^"_id
		...i (num#500)=0 d
		....s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		....s mList=""
		...e  d
		....i mList="" s mList=rec
		....e  s mList=mList_"!"_rec
		
		i mList'="" s ^BS.DOC.GCPSW.TempTask($j,"idx",$i(A))=mList
		
		
	}
	Q A
}

/// CTOR: QP
/// DATE: 2020-09-24
/// DESC: 过滤日期
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Data).GetAllFlag()
ClassMethod FilterDate(AddDate, wsDate)
{
	s mRtn=0
	q:(wsDate'="")&&(AddDate<wsDate) 1
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-24
/// DESC: 获取WS的开始日期
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Data).GetAllFlag()
ClassMethod GetAllFlag()
{
	s AllFlag=0
	//应该判断是否是第一次，先这么的吧
	i '$d(^BS.DOC.GCPSW.TaskLogI("Type","WS")) s AllFlag=1
	
	Q AllFlag
}

/// CTOR: QP
/// DATE: 2020-09-24
/// DESC: 获取WS的开始日期
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Data).GetWSStartDate()
ClassMethod GetWSStartDate()
{
	s mRtn=""
	s AllFlag=..GetAllFlag()
	Q:AllFlag=1 mRtn
	s id=$o(^BS.DOC.GCPSW.TaskLogI("Type","WS",""),-1)
	Q:id="" mRtn
	s endDate=$p(^BS.DOC.GCPSW.TaskLogD(id),"^",4)
	Q:endDate'="" endDate
	s startDate=$p(^BS.DOC.GCPSW.TaskLogD(id),"^",2)
	
	Q startDate
}

/// CTOR: QP
/// DATE: 2020-09-24
/// DESC: 获取WS的开始日期
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Data).Test()
ClassMethod Test()
{
	&SQL(
		UPDATE SQLUser.GCPSW_ResultAdm
		SET PA_AddDate = +$h
	)
	Q 1
}

/// CTOR: QP
/// DATE: 2020-09-24
/// DESC: 清理业务数据
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Data).ClearBSData()
ClassMethod ClearBSData()
{
	;GCPSW_Result
	;GCPSW_ResultAdm
	;GCPSW_ResultLis
	
	;清除筛选结果
	k ^BS.DOC.GCPSW.Result
	k ^BS.DOC.GCPSW.ResultI
	k ^BS.DOC.GCPSW.ResultD
	
	;GCPSW_TaskLog
	;清除日志
	k ^BS.DOC.GCPSW.TaskLog
	k ^BS.DOC.GCPSW.TaskLogD
	k ^BS.DOC.GCPSW.TaskLogI
	
	
	
	&SQL(TRUNCATE TABLE SQLUser.GCPSW_Warning)
	
	&SQL(TRUNCATE TABLE SQLUser.GCPSW_PrjKPIItem)
	&SQL(TRUNCATE TABLE SQLUser.GCPSW_PrjKPI)
	&SQL(TRUNCATE TABLE SQLUser.GCPSW_Prj)
	
	Q 1
}

/// CTOR: QP
/// DATE: 2021-11-16
/// DESC: 清理配置数据
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.Data).ClearCFGData()
ClassMethod ClearCFGData()
{
	
	Q 1
}

}
