Import sqluser

/// creator:yunhaibao
/// createdate:20161025
/// description:BS版本药库导货位程序
/// model: 药品代码	药品名称	货位码	科室名称(全称)	
/// others:导入前请仔细核对,文件为制表符格式的txt文件
/// input:fileName-文件路径,sub-节点(默认空即可),inputflag-1:仅导入字典,2:同时导入字典以及药品名称
/// windows路径:w ##class(web.DHCST.Tools.InputStkBin).StartInput("D:\tmp\yunstockbin.txt","","2")
/// 小机路径:w ##class(web.DHCST.Tools.InputStkBin).StartInput("/tmp/yunstockbin.txt","")
Class web.DHCST.Tools.InputStkBin Extends (%RegisteredObject, %XML.Adaptor, web.DHCST.StkTypeG) [ Not ProcedureBlock ]
{

/// 执行导入的总入口
ClassMethod StartInput(fileName As %String, sub As %String = "", inputflag) As %String
{
  n (fileName,sub,inputflag)
  q:(inputflag'="1")&&(inputflag'="2") "入参导入类型必填"
  i sub="" s sub="web.DHCST.Tools.InputStkBin"
  s p=$zn
  k ^zTSA(p,sub)
  s ret=##class(web.DHCST.Tools.LoadData).LoadData(fileName,sub,p)
  s cnt=0
  s successCnt=0
  s i=1
  f  s i=$O(^zTSA(p,sub,i)) q:i=""  d
  .s rowStr=$G(^zTSA(p,sub,i))
  .s cnt=cnt+1
  .tstart
  .s insRet=..InsertStkBin(rowStr,inputflag)
  .i insRet=0 d
  ..tcommit
  ..s successCnt=successCnt+1
  .e  d
  ..tro
  k ^zTSA(p,sub)  //删除临时global
  q "总记录数:"_cnt_",成功记录数:"_successCnt
}

ClassMethod InsertStkBin(rowData, inputflag)
{
	n (rowData,inputflag)
	s inputlocdesc=$p(rowData,"^",4)
	i inputlocdesc="" w "科室为空",!
	q:inputlocdesc="" -1
	s ctlocid=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(inputlocdesc),""))
	i ctlocid="" w "科室不存在",!
	q:ctlocid="" -1
	s hosp=$p(^CTLOC(ctlocid),"^",22)
	s inputincicode=$p(rowData,"^",1)
	i (inputflag=2)&&(inputincicode="") w "代码为空",!
	q:(inputflag=2)&&(inputincicode="") -1
	s incirowid=##class(PHA.IN.COM.Method).GetInciByCode(inputincicode,hosp)
  	i (inputflag=2)&&(incirowid="") w "代码"_inputincicode_"不存在",!
  	q:(inputflag=2)&&(incirowid="") -1
	s inputincidesc=$p(rowData,"^",2)
	s inputstkbin=$p(rowData,"^",3)
	i inputstkbin="" w "货位为空",!
	q:inputstkbin="" -1

	s stkbinid="",stkbinrowid=""
	f  s stkbinid=$o(^INC("SB",0,"Desc",$$ALPHAUP^SSUTIL4(inputstkbin),stkbinid)) q:(stkbinid="")||(stkbinrowid'="")  d
	.q:+stkbinid=0
	.s stkbincode=$p(^INC("SB",stkbinid),"^",1)
	.i stkbincode["P" d
	..s stkbinloc=$p(stkbincode,"P",1)
	..i stkbinloc=ctlocid s stkbinrowid=stkbinid
	i stkbinrowid="" d
	.s locbincode=..GetNextCode(ctlocid)
	.&sql(insert into inc_stkbin (incsb_code,incsb_desc) values (:locbincode,:inputstkbin))
	.s stkbinrowid=%ROWID
	s succ=0
	i inputflag=2 d
	.&sql(select %ID into :incil from inc_itmloc where incil_inci_parref=:incirowid and incil_ctloc_dr=:ctlocid)
	.i SQLCODE'=0 d
	..&sqL(insert into inc_itmloc (incil_inci_parref,incil_ctloc_dr)values(:incirowid,:ctlocid) )
	..i SQLCODE'=0 d
	...w "插入inc_itmloc失败",!
	...s succ=-1
	..q:SQLCODE'=0
	..s incil=%ROWID
	..&sql(insert into dhc_incitmloc (incil_incil_dr) values (:incil) )
	..i SQLCODE'=0 d
	...w "插入dhc_incitmloc失败",!
	...s succ=-1
	..q:SQLCODE'=0
	..s dhcincil=%ROWID
	..s ret=..InsertDHCLocBin(incil,stkbinrowid)
	..i ret'=0 s succ=-1
	.e  d
	..i '$d(^DHCINCIL(0,"INCIL",incil)) d
	...&sql(insert into dhc_incitmloc (incil_incil_dr) values (:incil) )
	...i SQLCODE'=0 d
	....w "插入dhc_incitmloc失败",!
	....s succ=-1
	...q:SQLCODE'=0
	..s ret=..InsertDHCLocBin(incil,stkbinrowid)
	..i ret'=0 s succ=-2	
	q:succ'=0 -2
	q 0
}

ClassMethod GetNextCode(Loc As %String) As %String
{
 n (Loc)
 s ch=+Loc_"P"
 &sql(select  max(to_number($PIECE(incsb_code,:ch,2))) into :max from inc_stkbin  where incsb_code %STARTSWITH :ch)
 s max=$g(max)+1
 q ch_max
}

ClassMethod InsertDHCLocBin(incil, stkbindr)
{
	s insflag=0
    s exist=0
    s incilb=""
    f  s incilb=$o(^DHCINCILB(0,"Loc",incil,incilb)) q:incilb=""  d
    .s stkbin=$p(^DHCINCILB(incilb),"^",2)
    .i stkbin=stkbindr d
    ..s exist=1
    i exist'=1 d
	.&sql(Insert into DHC_IncItmLocBin(INCILB_ItmLoc_Dr,INCILB_StkBin_Dr)values(:incil,:stkbindr))
	.i SQLCODE'=0 d
	..w "插入DHC_IncItmLocBin失败",!
	..s insflag=-10
	q insflag
}

}
