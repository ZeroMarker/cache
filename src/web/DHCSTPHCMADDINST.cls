Import sqluser

/// 临床药学管理
/// clinical pharmacy manage
Class web.DHCSTPHCMADDINST Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 统一取最大进程号
ClassMethod GetPID() As %String
{
	   s pid=$I(^DHCST("DHCSTPHCM"))
	   q pid
}

ClassMethod GetPID2() As %String
{
	 i $g(a)="" 
	 {
		 q:"123"
	 }
	 q ""
}

/// 保存页签
ClassMethod SaveInstLabel(code, desc, mode) As %String
{
	
	q:$d(^DHCPHPINL(0,"Code",code)) -99
	k PLIST
	s PLIST(2)=desc
	s PLIST(3)=+$o(^DHCPHPINL(0,"Order",""),-1)+1
	s PLIST(4)=code
	s PLIST(5)=mode
	&sql(INSERT INTO DHC_PHInstLabel VALUES :PLIST())
	q:SQLCODE -1
 	q 0
}

/// 初始化页签
/// w ##class(web.DHCSTPHCMADDINST).InitInstLabel()
ClassMethod InitInstLabel() As %String
{
	s label="freq"
	k PLIST
	s PLIST(2)="用药频率限制"
	s PLIST(3)=+$o(^DHCPHPINL(0,"Order",""),-1)+1
	s PLIST(4)=label
	s PLIST(5)="W"	
	i '$d(^DHCPHPINL(0,"Code",label)) d
	.&sql(INSERT INTO DHC_PHInstLabel VALUES :PLIST())
	//
	s label="usage"
	k PLIST
	s PLIST(2)="用药方法限制"
	s PLIST(3)=+$o(^DHCPHPINL(0,"Order",""),-1)+1
	s PLIST(4)=label
	s PLIST(5)="W"	
	i '$d(^DHCPHPINL(0,"Code",label)) d
	.&sql(INSERT INTO DHC_PHInstLabel VALUES :PLIST())
	//
	s label="Indication"
	k PLIST
	s PLIST(2)="适应症"
	s PLIST(3)=+$o(^DHCPHPINL(0,"Order",""),-1)+1
	s PLIST(4)=label
	s PLIST(5)="W"
	i '$d(^DHCPHPINL(0,"Code",label)) d	
	.&sql(INSERT INTO DHC_PHInstLabel VALUES :PLIST())
	//
	s label="Disease"
	k PLIST
	s PLIST(2)="用法用量"
	s PLIST(3)=+$o(^DHCPHPINL(0,"Order",""),-1)+1
	s PLIST(4)=label
	s PLIST(5)="W"	
	i '$d(^DHCPHPINL(0,"Code",label)) d
	.&sql(INSERT INTO DHC_PHInstLabel VALUES :PLIST())
	
	//
	s label="Contraindication"
	k PLIST
	s PLIST(2)="禁忌症"
	s PLIST(3)=+$o(^DHCPHPINL(0,"Order",""),-1)+1
	s PLIST(4)="Contraindication"
	s PLIST(5)="W"	
	i '$d(^DHCPHPINL(0,"Code",label)) d
	.&sql(INSERT INTO DHC_PHInstLabel VALUES :PLIST())
	
	//
	s label="Interact"
	k PLIST
	s PLIST(2)="相互作用"
	s PLIST(3)=+$o(^DHCPHPINL(0,"Order",""),-1)+1
	s PLIST(4)=label
	s PLIST(5)="W"	
	i '$d(^DHCPHPINL(0,"Code",label)) d
	.&sql(INSERT INTO DHC_PHInstLabel VALUES :PLIST())
	q 0
}

/// 获取页签集合
ClassMethod QueryInstLabelDs(rows, page) As %String
{
	s pid=##class(web.DHCSTPHCMADDINST).GetPID()
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	
	s h=0
	s ordernum=""
	f  s ordernum=$o(^DHCPHPINL(0,"Order",ordernum)) q:ordernum=""  d
	.s pinl=""
	.f  s pinl=$o(^DHCPHPINL(0,"Order",ordernum,pinl)) q:pinl=""  d
	..s code=$p(^DHCPHPINL(pinl),"^",1)
	..s desc=$p(^DHCPHPINL(pinl),"^",2)
	..s num=$p(^DHCPHPINL(pinl),"^",3)
	..s mode=$p(^DHCPHPINL(pinl),"^",4)
	..i mode="W" s mode="警示"
	..i mode="C" s mode="管控"
	..i mode="S" s mode="统计"
	..s modecode=$p(^DHCPHPINL(pinl),"^",4)
	..s rowid=pinl
	..s h=h+1
	..s data=code_"^"_desc_"^"_num_"^"_mode_"^"_modecode_"^"_rowid
	..s ^TMP("DHCST","DHCSTPHCMADDINST","QueryInstLabelDs",pid,h)=data
	
	q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPHCMADDINST","QueryInstLabelDs",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPHCMADDINST","QueryInstLabelDs",pid,h)
    .s code=$p(data,"^",1)
    .s desc=$p(data,"^",2)
    .s num=$p(data,"^",3)
    .s mode=$p(data,"^",4)
    .s modecode=$p(data,"^",5)
    .s rowid=$p(data,"^",6)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s code=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("code",code)
    .s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
    .s num=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("num",num)
    .s mode=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("mode",mode)
    .s modecode=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("modecode",modecode)
	.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=code_desc_num_mode_modecode_rowid
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	
	k ^TMP("DHCST","DHCSTPHCMADDINST","QueryInstLabelDs",pid)
	    
    q ""
}

/// 更新页签
ClassMethod UpdateInstLabel(code, desc, mode, rowid) As %String
{
	&sql(update  DHC_PHInstLabel set PINL_Code=:code,PINL_Desc=:desc,PINL_ManageMode=:mode where  PINL_RowID=:rowid )
 	i SQLCODE'=0 q -1
 	q 0
}

/*
ClassMethod AddICD(mrc, main) As %String
{
	
	q:$d(^DHCPHDISL(0,"Dis",mrc,main)) 0

	s sub=+$o(^DHCPHDISL(main,"Itm",""),-1)+1
    k PLIST
    s PLIST(0)=main
    s PLIST(2)=sub
    s PLIST(3)=mrc
    &sql(insert into DHC_PHDiseaseItmList values PLIST())
    q:SQLCODE'=0 SQLCODE

 	q 0
}
*/
/// 对照诊断ICD
/// 获取已对照的诊断集合
ClassMethod QueryContrastICDDs(rows, page, input = "") As %String
{
	
	s pid=##class(web.DHCSTPHCMADDINST).GetPID()
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	
	s h=0
	s dislr=0
	f  s dislr=$o(^DHCPHDISL(dislr) ) q:(dislr="")||(dislr=0)  d
	.s keyflag=$p(^DHCPHDISL(dislr),"^",1)
	.s desc=$p(^DHCPHDISL(dislr),"^",2)
	.q:(input'="")&(desc'[input)
	.s icdflag=$p(^DHCPHDISL(dislr),"^",3)
	.s actflag=$p(^DHCPHDISL(dislr),"^",4)
	.s rowid=dislr
	.s h=h+1
	.s data=keyflag_"^"_desc_"^"_icdflag_"^"_actflag_"^"_rowid
	.s index=desc_"^"_h
	.s ^TMP("DHCST","DHCSTPHCMADDINST","QueryContrastICDDs",pid,index)=data
	
	q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPHCMADDINST","QueryContrastICDDs",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPHCMADDINST","QueryContrastICDDs",pid,h)
    .s keyflag=$p(data,"^",1)
    .s desc=$p(data,"^",2)
    .s icdflag=$p(data,"^",3)
    .s actflag=$p(data,"^",4)
    .s rowid=$p(data,"^",5)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s keyflag=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("keyflag",keyflag)
	.s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	.s icdflag=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("icdflag",icdflag)
	.s actflag=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("actflag",actflag)
	.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=keyflag_desc_icdflag_actflag_rowid
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	
	k ^TMP("DHCST","DHCSTPHCMADDINST","QueryContrastICDDs",pid)
	    
    q ""
}

/*
/// 撤消已对照诊断ICD
ClassMethod DelICDData(rowid) As %String
{
	
	q:'$D(^DHCPHDISL(rowid)) -99
	s actflag=$p(^DHCPHDISL(rowid),"^",4)
	i actflag="Y" s activeflag="N"
	i actflag'="Y" s activeflag="Y"
	&sql(update DHC_PHDiseaseList  set PHDISL_ActiveFlag=:activeflag where PHDISL_RowID=:rowid )
	
	q:SQLCODE -1
 	q 0
}
*/
/// 对照年龄列表
ClassMethod AddAge(agemin, agemax, agedesc) As %String
{
	
	k PLIST
	s PLIST(2)=agedesc
	s PLIST(3)=agemin
	s PLIST(4)=agemax
	&sql(INSERT INTO DHC_PHPatAgeList VALUES :PLIST())
	
	q:SQLCODE -1
 	q 0
}

/// 更新已对照年龄列表
ClassMethod UpdAge(agemin, agemax, agedesc, rowid) As %String
{

	&sql(update DHC_PHPatAgeList set PDA_AgeDesc=:agedesc,PDA_AgeMin=:agemin,PDA_AgeMax=:agemax where PDA_RowID=:rowid )
	q:SQLCODE -1
 	q 0
}

/// 获取年龄对照字典
ClassMethod QueryContrastAgeDs(rows, page) As %String
{
	s pid=##class(web.DHCSTPHCMADDINST).GetPID()
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	
	s h=0
	s pagelr=0
	f  s pagelr=$o(^DHCPHPAGEL(pagelr) ) q:(pagelr="")||(pagelr=0)  d
	.s desc=$p(^DHCPHPAGEL(pagelr),"^",1)
	.s agemin=$p(^DHCPHPAGEL(pagelr),"^",2)
	.s agemax=$p(^DHCPHPAGEL(pagelr),"^",3)
	.s rowid=pagelr
	.s h=h+1
	.s index=agemin_"^"_h
	.s data=desc_"^"_agemin_"^"_agemax_"^"_rowid
	.s ^TMP("DHCST","DHCSTPHCMADDINST","QueryContrastAgeDs",pid,index)=data
	
	q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPHCMADDINST","QueryContrastAgeDs",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPHCMADDINST","QueryContrastAgeDs",pid,h)
    .s desc=$p(data,"^",1)
    .s agemin=$p(data,"^",2)
    .s agemax=$p(data,"^",3)
    .s rowid=$p(data,"^",4)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	.s agemin=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("agemin",agemin)
	.s agemax=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("agemax",agemax)
	.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=desc_agemin_agemax_rowid
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	
	k ^TMP("DHCST","DHCSTPHCMADDINST","QueryContrastAgeDs",pid)
	    
    q ""
}

/// 增加药品病症全部的说明书记录: 频率、用法
ClassMethod AddGolbalDrgData(drugid, optype, oprowid, input) As %String
{
	  
	    //s ^tlq(drugid,optype,oprowid)=input
	    /*
	    s typedr=$o(^DHCPHPINL(0,"Code",optype,""))
		tstart
		//先检查有没有重复项
		s chkflag=0
		s drgdise=..FindGlobalDrgDiseRowId(drugid,typedr)
		i drgdise'="" d
		.s drginstdr=$p(^DHCPHDDIS(drgdise),"^",4)
		.i optype="freq" d 
		..i $D(^DHCPHDISFR(0,"INST",drginstdr,oprowid)) d
		...s chkflag=1
		.i optype="usage" d 
		..i $D(^DHCPHDISUSE(0,"INST",drginstdr,oprowid)) d
		...s chkflag=1
		.i optype="Interact" d 
		..i $D(^DHCPHDINTER(0,"INST",drginstdr,oprowid)) d
		...s chkflag=1
        
		i chkflag=1 tro
		q:chkflag=1 -99

        s mode=$p(input,"^",1)
        
        s err=0
        i drgdise="" d
        .//全局的病症和说明书记录只加一次
        .i typedr="" d
        ..s num=1
        .e  d
		..s num=+$o(^DHCPHINSTRUC(0,"OrderNum",drugid,typedr,""),-1)+1
		.k PLIST
		.s PLIST(2)=typedr
		.s PLIST(3)=num
		.s PLIST(40)=drugid
		.s PLIST(41)=mode
		.&sql(INSERT INTO DHC_PHInstructions VALUES :PLIST())
		.i SQLCODE'=0 s err=-1
		.q:SQLCODE'=0 
		.s drginstdr=$p(%ROWID,$c(1))
		.k PLIST
		.s PLIST(2)=drugid
		.s PLIST(4)="D"
		.s PLIST(5)=drginstdr
		.&sql(INSERT INTO DHC_PHDrugDisease VALUES :PLIST())
		.i SQLCODE'=0 s err=-2
		.q:SQLCODE'=0 
		i err'=0 tro
		q:err'=0 err 
		//频次
		i optype="freq" d  
		.k PLIST
		.s PLIST(2)=oprowid
		.s PLIST(3)=drginstdr
		.&sql(INSERT INTO DHC_PHDiseaseFreq VALUES :PLIST())
		.i SQLCODE'=0 s err=-3
	    //用法
		i optype="usage" d  
		.k PLIST
		.s PLIST(2)=oprowid
		.s PLIST(3)=drginstdr
		.s PLIST(4)=mode
		.&sql(INSERT INTO DHC_PHDiseaseUse VALUES :PLIST())
		.i SQLCODE'=0 s err=-4
		//用量
		/*
		i optype="UseQty" d  
		.s OneDayTimeMin=$p(input,"^",1)
		.s OneDayTimeMax=$p(input,"^",2)
		.s OnceQtyMin=$p(input,"^",3)
		.s OnceQtyMax=$p(input,"^",4)
		.s OnceQtyUom=$p(input,"^",5)
		.s OneDayQtyMin=$p(input,"^",6)
		.s OneDayQtyMax=$p(input,"^",7)
		.s OneDayQtyUom=$p(input,"^",8)
		.s OnceMaxQty=$p(input,"^",9)
		.s OnceMaxQtyUom=$p(input,"^",10)
		.s OneDayMaxQty=$p(input,"^",11)
		.s OneDayMaxQtyUom=$p(input,"^",12)
		.s FristTimeQtyMin=$p(input,"^",13)
		.s FristTimeQtyMax=$p(input,"^",14)
		.s FristTimeQtyUom=$p(input,"^",15)
		.s DurationQtyMin=$p(input,"^",16)
		.s DurationQtyMax=$p(input,"^",17)
		.s DurationQtyUom=$p(input,"^",18)
		.s SpaceQtyMin=$p(input,"^",19)
		.s SpaceQtyMax=$p(input,"^",20)
		.s SpaceQtyUom=$p(input,"^",21)
		.s SpaceQtyUom=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(SpaceQtyUom),""))
		.s Sex=$p(input,"^",22)
		.s AgeStr=$p(input,"^",23)
		.s WeightMin=$p(input,"^",24)
		.s WeightMax=$p(input,"^",25)
		.&sql(update DHC_PHInstructions set PHINST_Sex=:Sex,PHINST_OneDayTimeMin=:OneDayTimeMin,
		PHINST_OneDayTimeMax=:OneDayTimeMax ,PHINST_OnceQtyMin=:OnceQtyMin,PHINST_OnceQtyMax=:OnceQtyMax,
		PHINST_OnceQtyUom_Dr=:OnceQtyUom,PHINST_OneDayQtyMin=:OneDayQtyMin,PHINST_OneDayQtyMax=:OneDayQtyMax,
		PHINST_OneDayQtyUom_Dr=:OneDayQtyUom,PHINST_OnceMaxQty=:OnceMaxQty,PHINST_OnceMaxQtyUom_Dr=:OnceMaxQtyUom,
		PHINST_OneDayMaxQty=:OneDayMaxQty,PHINST_OneDayMaxQtyUom_Dr=:OneDayMaxQtyUom,PHINST_FristTimeQtyMin=:FristTimeQtyMin,
		PHINST_FristTimeQtyMax=:FristTimeQtyMax,PHINST_FristTimeQtyUom_Dr=:FristTimeQtyUom,PHINST_DurationQtyMin=:DurationQtyMin,
		PHINST_DurationQtyMax=:DurationQtyMax,PHINST_DurationQtyUom_Dr=:DurationQtyUom,PHINST_SpaceQtyMax=:SpaceQtyMax,PHINST_SpaceQtyMin=:SpaceQtyMin,
		PHINST_SpaceQtyUom_Dr=:SpaceQtyUom,PHINST_WeightMin=:WeightMin,PHINST_WeightMax=:WeightMax
		
		where PHINST_RowID=:drginstdr
		
		
		 )
		.i SQLCODE'=0 s err=-4
		.
        */
		//年龄
		/*
		i $d(^DHCPHDAGE(0,"INST",drginstdr)) d
		.&sql(delete from DHC_PHDiseaseAge where PDA_Inst_Dr=:drginstdr)
		.i SQLCODE'=0 s err=-5
		
		i err'=0 tro
		q:err'=0 err
		
		s AgeStr=$g(AgeStr)
		s agecnt=$l(AgeStr,",")
		f i=1:1:agecnt q:err'=0  d
		.s age=$p(AgeStr,",",i)
		.q:age=""
		.s ageexist=..FindDrgDiseaseAge(drginstdr,age)
		.q:ageexist=1
		.k PLIST
		.s PLIST(2)=age
		.s PLIST(3)=drginstdr
		.&sql(INSERT INTO DHC_PHDiseaseAge VALUES :PLIST())
		.i SQLCODE'=0 s err=-6
		.q:SQLCODE'=0 
		
		i err'=0 tro
		q:err'=0 err

		//相互作用
		i optype="Interact" d 
		.s mode=$p(input,"^",1) 
		.k PLIST
		.s PLIST(2)=oprowid
		.s PLIST(3)=drginstdr
		.s PLIST(4)=mode
		.
		.&sql(INSERT INTO DHC_PHDiseaseInteract VALUES :PLIST())
		.i SQLCODE'=0 s err=-7
		
		i err'=0 tro
		q:err'=0 err
		
		tcommit
		*/
	 	q 0
}

/// 获取频率对照字典
ClassMethod QuerySelFreqDS(rows, page, drugid) As %String
{
	
	s pid=##class(web.DHCSTPHCMADDINST).GetPID()
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s type="freq"
	s typedr=$o(^DHCPHPINL(0,"Code",type,""))
	s drgdise=..FindGlobalDrgDiseRowId(drugid,typedr)
	q:drgdise="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s drginstdr=$p(^DHCPHDDIS(drgdise),"^",4)

	s h=0
	s freqdr=0
	f  s freqdr=$o(^DHCPHDISFR(0,"INST",drginstdr,freqdr)) q:(freqdr="")||(freqdr=0)  d
	.s desc=$p(^PHCFR(freqdr),"^",4)
	.s rowid=$o(^DHCPHDISFR(0,"INST",drginstdr,freqdr,""))
	.s h=h+1
	.s index=desc_"^"_h
	.s data=desc_"^"_rowid
	.s ^TMP("DHCST","DHCSTPHCMADDINST","QuerySelFreqDS",pid,index)=data
	
	q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPHCMADDINST","QuerySelFreqDS",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPHCMADDINST","QuerySelFreqDS",pid,h)
    .s desc=$p(data,"^",1)
    .s rowid=$p(data,"^",2)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=desc_rowid
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	
	k ^TMP("DHCST","DHCSTPHCMADDINST","QuerySelFreqDS",pid)
	    
    q ""
}

/// 查某药品是否已有全局的药品病症RowID
ClassMethod FindGlobalDrgDiseRowId(drugid, type) As %String
{
		s ret=""
		s dise=$o(^DHCPHDDIS(0,"DrugDis",drugid,""))
		b
		q:dise="" ""
		i $p(dise,"A",2)="" d
		.s drgdise=""
		.f  s drgdise=$o(^DHCPHDDIS(0,"DrugDis",drugid,dise,drgdise)) q:(drgdise="")||(ret'="")  d
		..s drginstdr=$p(^DHCPHDDIS(drgdise),"^",4)
		..s insttype=$p(^DHCPHINSTRUC(drginstdr),"^",1)
		..i insttype=type d
		...s ret=drgdise
		q ret
}

/// 获取频率对照字典
ClassMethod QuerySelUsageDS(rows, page, drugid) As %String
{
	
	s pid=##class(web.DHCSTPHCMADDINST).GetPID()
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s type="usage"
	s typedr=$o(^DHCPHPINL(0,"Code",type,""))
	s drgdise=..FindGlobalDrgDiseRowId(drugid,typedr)
	q:drgdise="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s drginstdr=$p(^DHCPHDDIS(drgdise),"^",4)

	s h=0
	s phcindr=0
	f  s phcindr=$o(^DHCPHDISUSE(0,"INST",drginstdr,phcindr)) q:(phcindr="")||(phcindr=0)  d
	.s desc=$p(^PHCIN(phcindr),"^",2)
	.s rowid=$o(^DHCPHDISUSE(0,"INST",drginstdr,phcindr,""))
	.s h=h+1
	.s index=desc_"^"_h
	.s data=desc_"^"_rowid
	.s ^TMP("DHCST","DHCSTPHCMADDINST","QuerySelFreqDS",pid,index)=data
	
	q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPHCMADDINST","QuerySelFreqDS",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPHCMADDINST","QuerySelFreqDS",pid,h)
    .s desc=$p(data,"^",1)
    .s rowid=$p(data,"^",2)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=desc_rowid
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	
	k ^TMP("DHCST","DHCSTPHCMADDINST","QuerySelFreqDS",pid)
	    
    q ""
}

/// 获取药品的等效单位字典
ClassMethod QueryDrgUomDs(drugid) As %String
{
	s page=1
	s rows=100
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s pid=##class(web.DHCSTPHCMADDINST).GetPID()
	s h=0
	s sub=0
	f  s sub=$o(^PHCD(+drugid,"DF",$p(drugid,"||",2),"EQ",sub)) q:(sub=0)||(sub="")  d
	.s uomdr=$p(^PHCD(+drugid,"DF",$p(drugid,"||",2),"EQ",sub),"^",1)
	.s uom=$p(^CT("UOM",uomdr),"^",1)
	.s h=h+1
	.s index=uom_"^"_h
	.s data=uom_"^"_uomdr
	.s ^TMP("DHCST","DHCSTPHCMADDINST","QueryDrgUomDs",pid,index)=data
	
	q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	
	s uomdr=$p(^PHCD(+drugid,"DF",$p(drugid,"||",2),2),"^",4)
	s uom=$p(^CT("UOM",uomdr),"^",1)
	s h=h+1
	s index=uom_"^"_h
	s data=uom_"^"_uomdr
	s ^TMP("DHCST","DHCSTPHCMADDINST","QueryDrgUomDs",pid,index)=data
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPHCMADDINST","QueryDrgUomDs",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPHCMADDINST","QueryDrgUomDs",pid,h)
    .s desc=$p(data,"^",1)
    .s rowid=$p(data,"^",2)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
	.s desc=##class(web.DHCSTJQUERYCOMMON).JsonCell("desc",desc)
	.s rowid=##class(web.DHCSTJQUERYCOMMON).JsonCell("rowid",rowid)
	.s tmpstr=desc_","_rowid
	.
    .i count=stpage w "[{"_tmpstr
    .i (count'=stpage)&(count<endpage) w "},{"_tmpstr
    .i count=endpage w "},{"_tmpstr_"}]"
	.
	
	k ^TMP("DHCST","DHCSTPHCMADDINST","QueryDrgUomDs",pid)
	    
    q ""
}

/// 增加药品病症相关信息
ClassMethod AddDrgDiseaseData(drugid, type, optype, druginstdr, input, mode) As %String
{
	    //s ^tlq(drugid)=drugid_"%"_type_"%"_optype_"%"_druginstdr_"%"_input_"%"_mode
	    /*
	    s typedr=$o(^DHCPHPINL(0,"Code",type,""))
        tstart
	    s err=0
	    s drginstdr=druginstdr
	    i druginstdr="" d
        .//全局的病症和说明书记录只加一次
		.s num=+$o(^DHCPHINSTRUC(0,"OrderNum",drugid,typedr,""),-1)+1
		.k PLIST
		.s PLIST(2)=typedr
		.s PLIST(3)=num
		.s PLIST(40)=drugid
		.&sql(INSERT INTO DHC_PHInstructions VALUES :PLIST())
		.i SQLCODE'=0 s err=-1
		.q:SQLCODE'=0 
		.s drginstdr=$p(%ROWID,$c(1))
		i err'=0 tro
		i err'=0 q err
		
		//适应症、禁忌症
		i optype="DrugDis" d 
		.s DocUseTips=$p(input,"^",1)
		.s agestr=$p(input,"^",2)
		.s Sex=$p(input,"^",3)
		.s drugdisstr=$p(input,"^",4)
		.s Note=$p(input,"^",5)
		.s managemode=$p(input,"^",6)
		.&sql(update DHC_PHInstructions set PHINST_DocUseTips=:DocUseTips,PHINST_Sex=:Sex,PHINST_Note=:Note,
		PHINST_Mode=:managemode
		where PHINST_RowID=:drginstdr)
		.i SQLCODE'=0 s err=-2
		.q:SQLCODE'=0
		
		i err'=0 tro
		i err'=0 q err
		
		//病症用法用量
		
		i optype="DisUsage" d 
		.s agestr=$p(input,"^",4)
		.s Sex=$p(input,"^",5)
		.s drugdisstr=$p(input,"^",1)
		.s usageidstr=$p(input,"^",2)
		.s usagestr=$p(input,"^",3)
		.s weightmin=$p(input,"^",6)
		.s weightmax=$p(input,"^",7)
		.s BodyAreaMin=$p(input,"^",8)
		.s BodyAreaMax=$p(input,"^",9)
		.s PlanPregnancy=$p(input,"^",10)
		.s Climacteric=$p(input,"^",11)
		.s Menstrual=$p(input,"^",12)
		.s Lactation=$p(input,"^",13)
		.s Pregnant=$p(input,"^",14)
		.s RenalFunction=$p(input,"^",15)
		.s docusetips=$p(input,"^",16)
		.s nurusetips=$p(input,"^",17)
		.s note=$p(input,"^",18)
		.s ManageMode=$p(input,"^",19)
		.
		.s tmpstr=usagestr
		.s OneDayTimeMin=$p(tmpstr,",",1)
		.s OneDayTimeMax=$p(tmpstr,",",2)
		.s OnceQtyMin=$p(tmpstr,",",3)
		.s OnceQtyMax=$p(tmpstr,",",4)
		.s OnceQtyUom=$p(tmpstr,",",5)
		.s OneDayQtyMin=$p(tmpstr,",",6)
		.s OneDayQtyMax=$p(tmpstr,",",7)
		.s OneDayQtyUom=$p(tmpstr,",",8)
		.s OnceMaxQty=$p(tmpstr,",",9)
		.s OnceMaxQtyUom=$p(tmpstr,",",10)
		.s OneDayMaxQty=$p(tmpstr,",",11)
		.s OneDayMaxQtyUom=$p(tmpstr,",",12)
		.s FristTimeQtyMin=$p(tmpstr,",",13)
		.s FristTimeQtyMax=$p(tmpstr,",",14)
		.s FristTimeQtyUom=$p(tmpstr,",",15)
		.s DurationQtyMin=$p(tmpstr,",",16)
		.s DurationQtyMax=$p(tmpstr,",",17)
		.s DurationQtyUom=$p(tmpstr,",",18)
		.s SpaceQtyMin=$p(tmpstr,",",19)
		.s SpaceQtyMax=$p(tmpstr,",",20)
		.s SpaceQtyUom=$p(tmpstr,",",21)
		.i SpaceQtyUom'="" s SpaceQtyUom=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(SpaceQtyUom),""))
		.
		.&sql(update DHC_PHInstructions set PHINST_NurseUseTips=:nurusetips,PHINST_DocUseTips=:docusetips,PHINST_Sex=:Sex,PHINST_Note=:note,
		PHINST_WeightMin=:weightmin,PHINST_WeightMax=:weightmax,
		PHINST_OneDayTimeMin=:OneDayTimeMin,
		PHINST_OneDayTimeMax=:OneDayTimeMax ,PHINST_OnceQtyMin=:OnceQtyMin,PHINST_OnceQtyMax=:OnceQtyMax,
		PHINST_OnceQtyUom_Dr=:OnceQtyUom,PHINST_OneDayQtyMin=:OneDayQtyMin,PHINST_OneDayQtyMax=:OneDayQtyMax,
		PHINST_OneDayQtyUom_Dr=:OneDayQtyUom,PHINST_OnceMaxQty=:OnceMaxQty,PHINST_OnceMaxQtyUom_Dr=:OnceMaxQtyUom,
		PHINST_OneDayMaxQty=:OneDayMaxQty,PHINST_OneDayMaxQtyUom_Dr=:OneDayMaxQtyUom,PHINST_FristTimeQtyMin=:FristTimeQtyMin,
		PHINST_FristTimeQtyMax=:FristTimeQtyMax,PHINST_FristTimeQtyUom_Dr=:FristTimeQtyUom,PHINST_DurationQtyMin=:DurationQtyMin,
		PHINST_DurationQtyMax=:DurationQtyMax,PHINST_DurationQtyUom_Dr=:DurationQtyUom,PHINST_SpaceQtyMax=:SpaceQtyMax,PHINST_SpaceQtyMin=:SpaceQtyMin,
		PHINST_SpaceQtyUom_Dr=:SpaceQtyUom,PHINST_BodyAreaMin=:BodyAreaMin,PHINST_BodyAreaMax=:BodyAreaMax,PHINST_PlanPregnancy=:PlanPregnancy,
		PHINST_Climacteric=:Climacteric,PHINST_Menstrual=:Menstrual,PHINST_Lactation=:Lactation,PHINST_Pregnant=:Pregnant,
		PHINST_RenalFunction=:RenalFunction,PHINST_Mode=:ManageMode


		where PHINST_RowID=:drginstdr)
		.i SQLCODE'=0 s err=-2
		.q:SQLCODE'=0
		
		i err'=0 tro
		i err'=0 q err
       
        
		//年龄
		s agecnt=$l(agestr,",")
		f i=1:1:agecnt q:err'=0  d
		.s age=$p(agestr,",",i)
		.q:age=""
		.s ageexist=..FindDrgDiseaseAge(drginstdr,age)
		.q:ageexist=1
		.k PLIST
		.s PLIST(2)=age
		.s PLIST(3)=drginstdr
		.&sql(INSERT INTO DHC_PHDiseaseAge VALUES :PLIST())
		.i SQLCODE'=0 s err=-3
		.q:SQLCODE'=0 
		
		i err'=0 tro
		i err'=0 q err
		
		//病症
		s drugdiscnt=$l(drugdisstr,",")
		f i=1:1:drugdiscnt q:err'=0  d
		.s disease=$p(drugdisstr,",",i)
		.q:disease=""
		.s drgdis=..FindDrgDiseaseRowId(drginstdr,disease)
		.q:drgdis'="" //已存在
		.k PLIST
		.s PLIST(2)=drugid
		.s PLIST(3)=disease
		.s PLIST(4)=mode
		.s PLIST(5)=drginstdr
		.&sql(INSERT INTO DHC_PHDrugDisease VALUES :PLIST())
		.i SQLCODE'=0 s err=-4
	
		i err'=0 tro
		i err'=0 q err
		
		
		//用法
		i $d(^DHCPHDISUSE(0,"INST",drginstdr)) d
		.&sql(delete from DHC_PHDiseaseUse where PDI_Inst_Dr=:drginstdr)
		.i SQLCODE'=0 s err=-5
		i err'=0 tro
		i err'=0 q err
		
		s usageidstr=$g(usageidstr)
		s usageidcnt=$l(usageidstr,",")
		f i=1:1:usageidcnt q:err'=0  d
		.s useid=$p(usageidstr,",",i)
		.q:useid="" 
		.k PLIST
		.s PLIST(2)=useid
		.s PLIST(3)=drginstdr
		.&sql(INSERT INTO DHC_PHDiseaseUse VALUES :PLIST())
		.i SQLCODE'=0 s err=-6
		
		
		i err'=0 tro
		i err'=0 q err
		
		tcommit
	    q drginstdr
	    */
}

/// 查某一条说明书记录对应的某个病症表RowID
ClassMethod FindDrgDiseaseRowId(drginstdr, disease) As %String
{
	    s ret=""
	    s phdisdr=""
		f  s phdisdr=$o(^DHCPHDDIS(0,"INST",drginstdr,phdisdr)) q:(phdisdr="")||(ret'="")  d
		.s disdr=$p(^DHCPHDDIS(phdisdr),"^",2)
		.q:disdr=""
		.i disease=disdr d
		..s ret=phdisdr
		q ret
}

/// 查某药品病症年龄是否存在
ClassMethod FindDrgDiseaseAge(drginstdr, agedr) As %String
{
	s chkexist=0
    s pdar=""
	f  s pdar=$o(^DHCPHDAGE(0,"INST",drginstdr,pdar)) q:(pdar="")||(chkexist=1)  d
	.s ageid=$p(^DHCPHDAGE(pdar),"^",1)
	.i ageid=agedr d
	..s chkexist=1
	
	q chkexist
}

//清数据 w ##class(web.DHCSTPHCMADDINST).KillData()

ClassMethod KillData() As %String
{
	//600633
	//&sql(delete from DHC_PHInstructions)
	//&sql(delete from DHC_PHDrugDisease)
	//&sql(delete from DHC_PHDiseaseList)
	//&sql(delete from DHC_PHDiseaseFreq)
	//&sql(delete from DHC_PHDiseaseUse)
	//&sql(delete from DHC_PHDiseaseAge)
	//&sql(delete from DHC_PHPatAgeList)
	//&sql(delete from DHC_PHDiseaseInteract)
	k ^DHCPHINSTRUC
	k ^DHCPHDDIS
	//k ^DHCPHDISL
	k ^DHCPHDISFR
	k ^DHCPHDISUSE
	k ^DHCPHDAGE
	k ^DHCPHDINTER

	q ""
}

/// 获取药品的用法字典
ClassMethod QueryDrgUsageCombo(drugid) As %String
{
	s page=1
	s rows=100

	s pid=##class(web.DHCSTPHCMADDINST).GetPID()
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
    s type="usage"
	s typedr=$o(^DHCPHPINL(0,"Code",type,""))
	s drgdise=..FindGlobalDrgDiseRowId(drugid,typedr)
	q:drgdise="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s drginstdr=$p(^DHCPHDDIS(drgdise),"^",4)
    
	s h=0
	s phcindr=0
	f  s phcindr=$o(^DHCPHDISUSE(0,"INST",drginstdr,phcindr)) q:(phcindr="")||(phcindr=0)  d
	.s desc=$p(^PHCIN(phcindr),"^",2)
	.s rowid=phcindr //$o(^DHCPHDISUSE(0,"INST",drginstdr,phcindr,""))
	.s h=h+1
	.s index=desc_"^"_h
	.s data=desc_"^"_rowid
	.s ^TMP("DHCST","DHCSTPHCMADDINST","QueryDrgUsageCombo",pid,index)=data
	
	q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPHCMADDINST","QueryDrgUsageCombo",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPHCMADDINST","QueryDrgUsageCombo",pid,h)
    .s desc=$p(data,"^",1)
    .s rowid=$p(data,"^",2)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
	.s desc=##class(web.DHCSTJQUERYCOMMON).JsonCell("desc",desc)
	.s rowid=##class(web.DHCSTJQUERYCOMMON).JsonCell("rowid",rowid)
	.s tmpstr=desc_","_rowid
	.
    .i count=stpage w "[{"_tmpstr
    .i (count'=stpage)&(count<endpage) w "},{"_tmpstr
    .i (count=endpage) d
    ..i (count>1) d
    ...w "},{"_tmpstr_"}]"
	..e  d
	...w "}]"
	
	k ^TMP("DHCST","DHCSTPHCMADDINST","QueryDrgUsageCombo",pid)
	    
    q ""
}

/// 获取药品集合
ClassMethod QueryDrugItmDS(rows, page, input) As %String
{
	s pid=##class(web.DHCSTPHCMADDINST).GetPID()
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
    b
	s h=0
	&sql(DECLARE curtt CURSOR FOR
	        select distinct inca_inci_dr from inc_alias 
	         where %ALPHAUP(inca_text) %STARTSWITH %ALPHAUP(:input))  
	&sql(OPEN curtt)
	f  &sql(fetch curtt into :inci )  q:SQLCODE  d
	.q:##class(web.DHCSTITMDESC).CatType(inci)'="G"
	.s h=h+1
	.s code=$p(^INCI(inci,1),"^",1)
	.s arci=$p(^INCI(inci,1),"^",3)
	.s phcr=$p(^ARCIM(+arci,$p(arci,"||",2),1),"^",12)
	.s desc=$p(^PHCD(+phcr,1),"^",2)
	.s spec=##class(web.DHCSTCOMMONSRV).getBarcode(inci)
	.s manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci)
	.i $f(manf,"-") s manf=$p(manf,"-",2)
	.s puomdr=""
	.s puomdr=$P(^INCI(inci,3),"^",6)                                  //入库单位ID
    .s:puomdr'="" puomdesc=$P(^CT("UOM",puomdr),"^",2)
	.s prp=##Class(web.DHCSTPRICE).GetCurItmBRp(code,puomdr,"")            //入库单位进价
	.s buomdr=$P(^INCI(inci,1),"^",10)
	.s:buomdr'="" buomdesc=$P(^CT("UOM",buomdr),"^",2) 
    .
	.s index=code_","_h
	.s data=code_"^"_desc_"^"_phcr_"^"_spec_"^"_manf_"^"_puomdesc_"^"_prp_"^"_buomdesc
	.s ^TMP("DHCST","DHCSTPHCMADDINST","QueryDrugItmDS",pid,h)=data
	
	q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPHCMADDINST","QueryDrugItmDS",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPHCMADDINST","QueryDrugItmDS",pid,h)
    .s code=$p(data,"^",1)
    .s desc=$p(data,"^",2)
    .s rowid=$p(data,"^",3)
    .s spec=$p(data,"^",4)
    .s manf=$p(data,"^",5)
    .s puomdesc=$p(data,"^",6)
    .s prp=$p(data,"^",7)
    .s buomdesc=$p(data,"^",8)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s code=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("code",code)
	.s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("rowid",rowid)
	.s spec=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("spec",spec)
	.s manf=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("manf",manf)
	.s puomdesc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("puomdesc",puomdesc)
	.s prp=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("prp",prp)
	.s buomdesc=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("buomdesc",buomdesc)
	.
	.s tmpstr=code_desc_rowid_spec_manf_puomdesc_prp_buomdesc
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	
	k ^TMP("DHCST","DHCSTPHCMADDINST","QueryDrugItmDS",pid)
	    
    q ""
}

/// 获取药品相互作用集合
ClassMethod QueryDrugInteractDS(rows, page, drugid) As %String
{
	s pid=##class(web.DHCSTPHCMADDINST).GetPID()
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	s type="Interact"
	s typedr=$o(^DHCPHPINL(0,"Code",type,""))
	s drginstdr=""
	s drgdise=..FindGlobalDrgDiseRowId(drugid,typedr)
	i drgdise'="" d
	.s drginstdr=$p(^DHCPHDDIS(drgdise),"^",4)
    q:drginstdr="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
    
	s h=0
    s phcr=""
	f  s phcr=$o(^DHCPHDINTER(0,"INST",drginstdr,phcr)) q:phcr=""  d
	.s interdr=""
	.f  s interdr=$o(^DHCPHDINTER(0,"INST",drginstdr,phcr,interdr)) q:interdr=""  d
	..s h=h+1
	..s desc=$p(^PHCD(+phcr,1),"^",2)
	..s mode=$p(^DHCPHDINTER(interdr),"^",3)
	..i mode="C" s mode="管控"
	..i mode="W" s mode="警示"
	..i mode="S" s mode="统计"
	..s rowid=interdr
	..s data=desc_"^"_mode_"^"_interdr
	..s ^TMP("DHCST","DHCSTPHCMADDINST","QueryDrugInteractDS",pid,h)=data
	
	q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPHCMADDINST","QueryDrugInteractDS",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPHCMADDINST","QueryDrugInteractDS",pid,h)
    .s desc=$p(data,"^",1)
    .s mode=$p(data,"^",2)
    .s rowid=$p(data,"^",3)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	.s mode=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("mode",mode)
	.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=desc_mode_rowid
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	
	k ^TMP("DHCST","DHCSTPHCMADDINST","QueryDrugInteractDS",pid)
	    
    q ""
}

/// 删除药品相互作用集合
ClassMethod DelDrugInteract(rowid) As %String
{
   /*
	&sql(delete from DHC_PHDiseaseInteract where PDINT_RowID=:rowid)
	i SQLCODE'=0 q SQLCODE
	q 0
	*/
}

ClassMethod Query(drugid) As %String
{
		
		s pid=##class(web.DHCSTPHCMADDINST).GetPID()
		s h=0

        s drginststr=""
        s freqglbid=..FindGlobalDrgInstRowId(drugid,"freq")
        s usageglbid=..FindGlobalDrgInstRowId(drugid,"usage")
        s interactglbid=..FindGlobalDrgInstRowId(drugid,"Interact")
	
		s glbid=freqglbid_"^"_usageglbid_"^"_interactglbid
		
		
	    //按病症查询
		s disallid=..FindDrgDisInstRowId(drugid)
		
	    s drginststr=glbid_"^"_disallid
	    
		
		q:drginststr="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
        s strcnt=$l(drginststr,"^")
		f x=1:1:strcnt d
		.s drginstdr=$p(drginststr,"^",x)
		.q:drginstdr=""
		.s diseasestr=..GetDrgOneDisInstStr(drginstdr)
		.i diseasestr'="" s itmdesc=$p(diseasestr,"^",1)
		.
		.s Data=..GetDrugInstData(drginstdr)
		.s typedr=$p(Data,"^",1)
		.s secnum=10000+$p(Data,"^",2)
		.
		.s labelcode=$p(^DHCPHPINL(typedr),"^",1)
		.s labeldesc=$p(^DHCPHPINL(typedr),"^",2)
		.s labelorder=$p(^DHCPHPINL(typedr),"^",3)
		.i ..ChkGolbalLabel(labelcode)=0 s h=h+1  //如果非全局,每条说明书ID记录数+1
		.
		.//频次
		.s fristnum=labelorder
		.s itmcode=typedr_","_labelcode_","_labeldesc
		.s num=fristnum_","_secnum
        .s freqstr=..GetDrugInstFreqData(drginstdr)
		.i freqstr'="" d
		..i labelcode="freq" d
		...s h=h+1
		...s index=num_"^"_h
		...s data=itmcode_"^"_freqstr_"^"_drginstdr
	    ...s ^TMP("DHCST","DHCSTPHCMADDINST","Query",pid,index)=data
	    ..e  d
	    ...s itmdesc=itmdesc_", "_freqstr
		.//用法
		.s fristnum=labelorder
		.s itmcode=typedr_","_labelcode_","_labeldesc
		.s num=fristnum_","_secnum
        .s usestr=..GetDrugInstUseData(drginstdr)
        .s usestr=$p(usestr,"^",1)
        .i usestr'="" d
		..i labelcode="usage" d
		...s h=h+1
		...s index=num_"^"_h
		...s data=itmcode_"^"_usestr_"^"_drginstdr
	    ...s ^TMP("DHCST","DHCSTPHCMADDINST","Query",pid,index)=data
	    ..e  d
	    ...s itmdesc=itmdesc_", "_usestr
	    .
	    .//特殊人群
	    .s PlanPregnancy=$p(Data,"^",29)
	    .i PlanPregnancy="Y" s itmdesc=itmdesc_", "_"计划妊娠"
        .s Climacteric=$p(Data,"^",30)
        .i Climacteric="Y" s itmdesc=itmdesc_", "_"更年期妇女"
        .s Menstrual=$p(Data,"^",31)
        .i Menstrual="Y" s itmdesc=itmdesc_", "_"经期"
        .s Lactation=$p(Data,"^",32)
        .i Lactation="Y" s itmdesc=itmdesc_", "_"哺乳期"
        .s Pregnant=$p(Data,"^",33)
        .i Pregnant="Y" s itmdesc=itmdesc_", "_"孕妇"
        .s RenalFunction=$p(Data,"^",34)
        .i RenalFunction="Y" s itmdesc=itmdesc_", "_"肝肾功能不全"
	    .//性别
	    .s sex=$p(Data,"^",3)
	    .i sex="A" s sex="全部"
	    .i sex="F" s sex="女"
	    .i sex="M" s sex="男"
	    .i sex'="" s sex="性别:"_sex
	    .i sex'="" s itmdesc=itmdesc_", "_sex
	    .s WeightMin=$p(Data,"^",25)
	    .s WeightMax=$p(Data,"^",26)
	    .s Weight="体重:"_WeightMin_"－"_WeightMax_"kg"
	    .i (WeightMin'="")||(WeightMax'="") s itmdesc=itmdesc_", "_Weight
	    .//年龄
	    .s age=..GetDrugInstAgeDesc(drginstdr)
	    .s agestr="年龄:"_age
	    .i age'="" s itmdesc=itmdesc_", "_agestr
	    .//
	    .//体表面积
	    .s BodyAreaMin=$p(Data,"^",27)
        .s BodyAreaMax=$p(Data,"^",28)
        .s BodyArea="体表面积:"_BodyAreaMin_"－"_BodyAreaMax_""
	    .i (BodyAreaMin'="")||(BodyAreaMax'="") s itmdesc=itmdesc_", "_BodyArea
        .
	    .s OneDayTimeMin=$p(Data,"^",4)
	    .s OneDayTimeMax=$p(Data,"^",5)
	    .s OneDayTime="每日服药次数:"_OneDayTimeMin_"次"_"－"_OneDayTimeMax_"次"
	    .i (OneDayTimeMin'="")||(OneDayTimeMax'="") s itmdesc=itmdesc_", "_OneDayTime
	    .s OnceQtyMin=$p(Data,"^",6)
	    .s OnceQtyMax=$p(Data,"^",7)
	    .s OnceQtyUomDr=$p(Data,"^",8)
	    .s OnceQtyUom=""
	    .i OnceQtyUomDr'="" s OnceQtyUom=$p(^CT("UOM",OnceQtyUomDr),"^",1)
	    .s OnceQty="单次服药量:"_OnceQtyMin_OnceQtyUom_"－"_OnceQtyMax_OnceQtyUom
	    .i (OnceQtyMin'="")||(OnceQtyMax'="") s itmdesc=itmdesc_", "_OnceQty
 		.s OneDayQtyMin=$p(Data,"^",9)
	    .s OneDayQtyMax=$p(Data,"^",10)
	    .s OneDayQtyUomDr=$p(Data,"^",11) 
	    .s OneDayQtyUom=""
	    .i OneDayQtyUomDr'="" s OneDayQtyUom=$p(^CT("UOM",OneDayQtyUomDr),"^",1)
	    .s OneDayQty="每日服药总量:"_OneDayQtyMin_OneDayQtyUom_"－"_OneDayQtyMax_OneDayQtyUom
	    .i (OneDayQtyMin'="")||(OneDayQtyMax'="") s itmdesc=itmdesc_", "_OneDayQty 		
	    .s OnceMaxQty=$p(Data,"^",12)
	    .s OnceMaxQtyUomDr=$p(Data,"^",13)
	    .s OnceMaxQtyUom=""
	    .i OnceMaxQtyUomDr'="" s OnceMaxQtyUom=$p(^CT("UOM",OnceMaxQtyUomDr),"^",1)
	    .s OnceMaxQty="每次最大量:"_OnceMaxQty_OnceMaxQtyUom
	    .i $p(Data,"^",12)'="" s itmdesc=itmdesc_", "_OnceMaxQty
	    .s OneDayMaxQty=$p(Data,"^",14)
	    .s OneDayMaxQtyUomDr=$p(Data,"^",15)
	    .s OneDayMaxQtyUom=""
	    .i OneDayMaxQtyUomDr'="" s OneDayMaxQtyUom=$p(^CT("UOM",OneDayMaxQtyUomDr),"^",1)
	    .s OneDayMaxQty="每日最大量:"_OneDayMaxQty_OneDayMaxQtyUom
	    .i $p(Data,"^",14)'="" s itmdesc=itmdesc_", "_OneDayMaxQty
	    .s FristTimeQtyMin=$p(Data,"^",16)
	    .s FristTimeQtyMax=$p(Data,"^",17)
	    .s FristTimeQtyUomDr=$p(Data,"^",18)
	    .s FristTimeQtyUom=""
	    .i FristTimeQtyUomDr'="" s FristTimeQtyUom=$p(^CT("UOM",FristTimeQtyUomDr),"^",1)
	    .s FristTimeQty="首次服药量:"_FristTimeQtyMin_FristTimeQtyUom_"－"_FristTimeQtyMax_FristTimeQtyUom
	    .i (FristTimeQtyMin'="")||(FristTimeQtyMax'="") s itmdesc=itmdesc_", "_FristTimeQty
	    .s DurationQtyMin=$p(Data,"^",19)
	    .s DurationQtyMax=$p(Data,"^",20)
	    .s DurationQtyUomDr=+$p(Data,"^",21)
	    .s DurationQtyUom=""
	    .i DurationQtyUomDr'="" s DurationQtyUom=$p(^CT("UOM",DurationQtyUomDr),"^",1)
        .s DurationQty="连用:"_DurationQtyMin_DurationQtyUom_"－"_DurationQtyMax_DurationQtyUom
	    .i (DurationQtyMin'="")||(DurationQtyMax'="") s itmdesc=itmdesc_", "_DurationQty
	    .s SpaceQtyMin=$p(Data,"^",22)
	    .s SpaceQtyMax=$p(Data,"^",23)
	    .s SpaceQtyUomDr=$p(Data,"^",24)
	    .s SpaceQtyUom=""
	    .i SpaceQtyUomDr'="" s SpaceQtyUom=$p(^CT("UOM",SpaceQtyUomDr),"^",1)
        .s SpaceQty="服药间隔:"_SpaceQtyMin_SpaceQtyUom_"－"_SpaceQtyMax_SpaceQtyUom
	    .i (SpaceQtyMin'="")||(SpaceQtyMax'="") s itmdesc=itmdesc_", "_SpaceQty
	    .
	    .//相互作用
		.s fristnum=labelorder
		.s itmcode=typedr_","_labelcode_","_labeldesc
		.s num=fristnum_","_secnum
        .s interstr=..FindDrgInteractStr(drginstdr)
        .i interstr'="" d
		..i ..ChkGolbalLabel(labelcode)=1 d
		...s h=h+1
		...s index=num_"^"_h
		...s data=itmcode_"^"_interstr_"^"_drginstdr
	    ...s ^TMP("DHCST","DHCSTPHCMADDINST","Query",pid,index)=data
	    ..e  d
	    ...i itmdesc'="" d
	    ....s itmdesc=itmdesc_", "_interstr
	    ...e  d
	    ....//全局的且病症为空
	    ....s itmdesc=interstr
	    .
	    .i ..ChkGolbalLabel(labelcode)=0 d
	    ..s index=num_"^"_h
	    ..s data=itmcode_"^"_itmdesc_"^"_drginstdr
	    ..s ^TMP("DHCST","DHCSTPHCMADDINST","Query",pid,index)=data
		
		 
		q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	    s maxrow=h
        
	    s count=0
	    s h=""
	    f  s h=$o(^TMP("DHCST","DHCSTPHCMADDINST","Query",pid,h)) q:h=""  d
	    .s data=^TMP("DHCST","DHCSTPHCMADDINST","Query",pid,h)
	    .s tmpstr=$p(data,"^",1)
	    .s itmcode=$p(tmpstr,",",3)
	    .s itmcodeval=$p(tmpstr,",",2)
	    .s itmdesc=$p(data,"^",2)
	    .s itmrowid=$p(data,"^",3)
	    .
	    .s itmcode=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("itmcode",itmcode)
	    .s itmcodeval=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("itmcodeval",itmcodeval)
	    .s itmdesc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("itmdesc",itmdesc)
		.s itmrowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("itmrowid",itmrowid)
		.
		.s tmpstr=itmcode_itmcodeval_itmdesc_itmrowid
	    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
		.s count=count+1
		.i count=1 w startString
	    .i count<maxrow w firstrow
	    .i count=maxrow w lastrow
	    
	    q ""
		
		
		f i=1:1:11 d
		.i i=1 d
		..s itmcode="用药时间限制"
		..s itmdesc="1.每日两次 2.每日三次"
		.i i=2 d
		..s itmcode="治疗方法限制"
		..s itmdesc="1.口服"
		.i i=3 d
		..s itmcode="服用量限制"
		..s itmdesc="1.每日服药3次,单次10mg"
		.i i=4 d
		..s itmcode="提示标签"
		..s itmdesc="1.遮光、密闭,在25度下保存，测试数据，测试数据，测试数据，测试数据，测试数据，测试数据，测试数据，测试数据，测试数据，测试数据，测试数据折行"
		.i i=5 d
		..s itmcode="适应症"
		..s itmdesc="1.配合饮食控制,用于2型糖尿病"
		.i i=6 d 
		..s itmcode="适应症"
		..s itmdesc="2.配合饮食控制,降低糖耐量"
		.i i=7 d
		..s itmcode="用法用量"
		..s itmdesc="1.餐前1g"
		.i i=8 d
		..s itmcode="禁忌症"
		..s itmdesc="1.对阿卡波糖和非活性成分过敏者禁用"
		.i i=9 d
		..s itmcode="老人用药"
		..s itmdesc="1.老年人无须改变用法用量"
		.i i=10 d
		..s itmcode="老人用药"
		..s itmdesc="1.老年人无须改变用法用量"
		.i i=11 d
		..s itmcode="儿童用药"
		..s itmdesc="1.儿童服药"
		.s h=h+1
	    .s data=itmcode_"^"_itmdesc
	    .s ^TMP("DHCST","DHCSTPHCMADDINST","Query",pid,h)=data
	    q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	    s maxrow=h
    
	    s count=0
	    s h=""
	    f  s h=$o(^TMP("DHCST","DHCSTPHCMADDINST","Query",pid,h)) q:h=""  d
	    .s data=^TMP("DHCST","DHCSTPHCMADDINST","Query",pid,h)
	    .s itmcode=$p(data,"^",1)
	    .s itmdesc=$p(data,"^",2)
	    .
	    .s itmcode=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("itmcode",itmcode)
		.s itmdesc=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("itmdesc",itmdesc)
		.
		.s tmpstr=itmcode_itmdesc
	    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
		.s count=count+1
		.i count=1 w startString
	    .i count<maxrow w firstrow
	    .i count=maxrow w lastrow
		.
		k ^TMP("DHCST","DHCSTPHCMADDINST","Query",pid)
		
	
		//w "[{"_"""itmcode"""_":"_"""标签"""_"}]"
		q ""
}

/// 获取诊断字典
ClassMethod QueryICD(rows, page, input = "") As %String
{
	s pid=##class(web.DHCSTPHCMADDINST).GetPID()
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	
	s h=0
	s mrc=""
	f  s mrc=$o(^MRC("ID",mrc)) q:mrc=""  d
	.s code=$p(^MRC("ID",mrc),"^",1)
	.s desc=$p(^MRC("ID",mrc),"^",2)
	.s desc=##Class(web.DHCSTJQUERYCOMMON).GetValue(desc)
	.q:(desc'[input)&(input'="")
	.s h=h+1
	.s index=desc_"^"_h
	.s data=code_"^"_desc_"^"_mrc
	.s ^TMP("DHCST","DHCSTPHCMADDINST","QueryICD",pid,index)=data
	 q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPHCMADDINST","QueryICD",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPHCMADDINST","QueryICD",pid,h)
    .s code=$p(data,"^",1)
    .s desc=$p(data,"^",2)
    .s rowid=$p(data,"^",3)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s code=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("code",code)
	.s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=code_desc_rowid
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	
	k ^TMP("DHCST","DHCSTPHCMADDINST","QueryICD",pid)
	    
    q ""
}

/// 获取已对照诊断字典
ClassMethod QueryContrastICD(rows, page) As %String
{
	s pid=##class(web.DHCSTPHCMADDINST).GetPID()
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	s h=0
	s disldr=0
	f  s disldr=$o(^DHCPHDISL(disldr)) q:(disldr="")||(disldr=0)  d
	.s code=$p(^DHCPHDISL(disldr),"^",2)
	.s desc=$p(^DHCPHDISL(disldr),"^",2)
	.s h=h+1
	.s index=code_"^"_h
	.s data=code_"^"_desc_"^"_disldr
	.s ^TMP("DHCST","DHCSTPHCMADDINST","QueryContrastICD",pid,index)=data
	 q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPHCMADDINST","QueryContrastICD",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPHCMADDINST","QueryContrastICD",pid,h)
    .s code=$p(data,"^",1)
    .s desc=$p(data,"^",2)
    .s rowid=$p(data,"^",3)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s code=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("code",code)
	.s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=code_desc_rowid
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	
	k ^TMP("DHCST","DHCSTPHCMADDINST","QueryContrastICD",pid)
	    
    q ""
}

/// 获取频率字典
ClassMethod QueryFreqDS(rows, page) As %String
{
	s pid=##class(web.DHCSTPHCMADDINST).GetPID()
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	
	s h=0
	s phcr=""
	f  s phcr=$o(^PHCFR(phcr)) q:phcr=""  d
	.s code=$p(^PHCFR(phcr),"^",1)
	.s desc=$p(^PHCFR(phcr),"^",4)
	.s rowid=phcr
	.s h=h+1
	.s index=code_"^"_h
	.s data=code_"^"_desc_"^"_rowid
	.s ^TMP("DHCST","DHCSTPHCMADDINST","QueryFreqDS",pid,index)=data
	 q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPHCMADDINST","QueryFreqDS",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPHCMADDINST","QueryFreqDS",pid,h)
    .s code=$p(data,"^",1)
    .s desc=$p(data,"^",2)
    .s rowid=$p(data,"^",3)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s code=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("code",code)
	.s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=code_desc_rowid
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	
	k ^TMP("DHCST","DHCSTPHCMADDINST","QueryFreqDS",pid)
	    
    q ""
}

/// 获取用法字典
ClassMethod QueryInstrucDS(rows, page) As %String
{
	s pid=##class(web.DHCSTPHCMADDINST).GetPID()
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	
	s h=0
	s phcinr=""
	f  s phcinr=$o(^PHCIN(phcinr) ) q:phcinr=""  d
	.s code=$p(^PHCIN(phcinr),"^",1)
	.s desc=$p(^PHCIN(phcinr),"^",2)
	.s rowid=phcinr
	.s h=h+1
	.s index=code_"^"_h
	.s data=code_"^"_desc_"^"_rowid
	.s ^TMP("DHCST","DHCSTPHCMADDINST","QueryInstrucDS",pid,index)=data
	 q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPHCMADDINST","QueryInstrucDS",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPHCMADDINST","QueryInstrucDS",pid,h)
    .s code=$p(data,"^",1)
    .s desc=$p(data,"^",2)
    .s rowid=$p(data,"^",3)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s code=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("code",code)
	.s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=code_desc_rowid
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	
	k ^TMP("DHCST","DHCSTPHCMADDINST","QueryInstrucDS",pid)
	    
    q ""
}

/// 获取一条说明书对应的年龄集合
ClassMethod QueryAgeDs(rows, page, drginstdr) As %String
{
	s pid=##class(web.DHCSTPHCMADDINST).GetPID()
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行

	s h=0
	s pdar=0
    f  s pdar=$o(^DHCPHDAGE(0,"INST",drginstdr,pdar)) q:(pdar="")||(pdar=0)  d
    .s ageid=$p(^DHCPHDAGE(pdar),"^",1)
    .s age=$p(^DHCPHPAGEL(ageid),"^",1)
	.s h=h+1
	.s data=age_"^"_ageid
	.s ^TMP("DHCST","DHCSTPHCMADDINST","QueryAgeDs",pid,h)=data
	 q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPHCMADDINST","QueryAgeDs",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPHCMADDINST","QueryAgeDs",pid,h)
    .s desc=$p(data,"^",1)
    .s rowid=$p(data,"^",2)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=desc_rowid
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	
	k ^TMP("DHCST","DHCSTPHCMADDINST","QueryAgeDs",pid)
	    
    q ""
}

/// 获取DHC_PHInstructions表所有字段值
ClassMethod GetDrugInstData(drginstdr) As %String
{
        q:drginstdr="" ""
	    s TypeDr=$p(^DHCPHINSTRUC(drginstdr),"^",1)
        s OrderNum=$p(^DHCPHINSTRUC(drginstdr),"^",2)
        s SexDr=$p(^DHCPHINSTRUC(drginstdr),"^",3)
		s OneDayTimeMin=$p(^DHCPHINSTRUC(drginstdr),"^",4)
	    s OneDayTimeMax=$p(^DHCPHINSTRUC(drginstdr),"^",5)
	    s OnceQtyMin=$p(^DHCPHINSTRUC(drginstdr),"^",6)
	    s OnceQtyMax=$p(^DHCPHINSTRUC(drginstdr),"^",7)
	    s OnceQtyUomDr=$p(^DHCPHINSTRUC(drginstdr),"^",8)
 		s OneDayQtyMin=$p(^DHCPHINSTRUC(drginstdr),"^",9)
	    s OneDayQtyMax=$p(^DHCPHINSTRUC(drginstdr),"^",10)
	    s OneDayQtyUomDr=$p(^DHCPHINSTRUC(drginstdr),"^",11)		
	    s OnceMaxQty=$p(^DHCPHINSTRUC(drginstdr),"^",12)
	    s OnceMaxQtyUomDr=$p(^DHCPHINSTRUC(drginstdr),"^",13) 
	    s OneDayMaxQty=$p(^DHCPHINSTRUC(drginstdr),"^",14)
	    s OneDayMaxQtyUomDr=$p(^DHCPHINSTRUC(drginstdr),"^",15)
	    s FristTimeQtyMin=$p(^DHCPHINSTRUC(drginstdr),"^",16)
	    s FristTimeQtyMax=$p(^DHCPHINSTRUC(drginstdr),"^",17)
	    s FristTimeQtyUomDr=$p(^DHCPHINSTRUC(drginstdr),"^",18)
	    s DurationQtyMin=$p(^DHCPHINSTRUC(drginstdr),"^",19)
	    s DurationQtyMax=$p(^DHCPHINSTRUC(drginstdr),"^",20)
	    s DurationQtyUomDr=$p(^DHCPHINSTRUC(drginstdr),"^",21)
	    s SpaceQtyMin=$p(^DHCPHINSTRUC(drginstdr),"^",22)
	    s SpaceQtyMax=$p(^DHCPHINSTRUC(drginstdr),"^",23)
	    s SpaceQtyUomDr=$p(^DHCPHINSTRUC(drginstdr),"^",24)
	    s WeightMin=$p(^DHCPHINSTRUC(drginstdr),"^",25)
        s WeightMax=$p(^DHCPHINSTRUC(drginstdr),"^",26)
        s BodyAreaMin=$p(^DHCPHINSTRUC(drginstdr),"^",27)
        s BodyAreaMax=$p(^DHCPHINSTRUC(drginstdr),"^",28)
        s PlanPregnancy=$p(^DHCPHINSTRUC(drginstdr),"^",29)
        s Climacteric=$p(^DHCPHINSTRUC(drginstdr),"^",30)
        s Menstrual=$p(^DHCPHINSTRUC(drginstdr),"^",31)
        s Lactation=$p(^DHCPHINSTRUC(drginstdr),"^",32)
        s Pregnant=$p(^DHCPHINSTRUC(drginstdr),"^",33)
        s RenalFunction=$p(^DHCPHINSTRUC(drginstdr),"^",34)
        s NurseUseTips=$p(^DHCPHINSTRUC(drginstdr),"^",35)
        s DocUseTips=$p(^DHCPHINSTRUC(drginstdr),"^",36)
        s Note=$p(^DHCPHINSTRUC(drginstdr),"^",37)
        s CheckLevel=$p(^DHCPHINSTRUC(drginstdr),"^",38)
        s DrugDr=$p(^DHCPHINSTRUC(drginstdr),"^",39)
        s Mode=$p(^DHCPHINSTRUC(drginstdr),"^",40)
        s Data=TypeDr_"^"_OrderNum_"^"_SexDr_"^"_OneDayTimeMin_"^"_OneDayTimeMax
        s Data=Data_"^"_OnceQtyMin_"^"_OnceQtyMax_"^"_OnceQtyUomDr_"^"_OneDayQtyMin_"^"_OneDayQtyMax
        s Data=Data_"^"_OneDayQtyUomDr_"^"_OnceMaxQty_"^"_OnceMaxQtyUomDr_"^"_OneDayMaxQty_"^"_OneDayMaxQtyUomDr
        s Data=Data_"^"_FristTimeQtyMin_"^"_FristTimeQtyMax_"^"_FristTimeQtyUomDr_"^"_DurationQtyMin_"^"_DurationQtyMax
        s Data=Data_"^"_DurationQtyUomDr_"^"_SpaceQtyMin_"^"_SpaceQtyMax_"^"_SpaceQtyUomDr_"^"_WeightMin
        s Data=Data_"^"_WeightMax_"^"_BodyAreaMin_"^"_BodyAreaMax_"^"_PlanPregnancy_"^"_Climacteric
        s Data=Data_"^"_Menstrual_"^"_Lactation_"^"_Pregnant_"^"_RenalFunction_"^"_NurseUseTips
        s Data=Data_"^"_DocUseTips_"^"_Note_"^"_CheckLevel_"^"_DrugDr_"^"_Mode
        
        q Data
}

/// 获取DHC_PHInstructions表频率所有
ClassMethod GetDrugInstFreqData(drginstdr) As %String
{
	    q:drginstdr="" ""
		s freqstr=""
		s freqdr=""
		f  s freqdr=$o(^DHCPHDISFR(0,"INST",drginstdr,freqdr)) q:freqdr=""  d
		.s freq=$p(^PHCFR(freqdr),"^",4)
		.i freqstr="" d
		..s freqstr=freq
		.e  d
		..s freqstr=freqstr_","_freq
		q freqstr
}

/// 获取DHC_PHInstructions表用法所有
ClassMethod GetDrugInstUseData(drginstdr) As %String
{
	    q:drginstdr="" ""
	    s useidstr=""
		s usestr=""
		s phcindr=""
		f  s phcindr=$o(^DHCPHDISUSE(0,"INST",drginstdr,phcindr)) q:phcindr=""  d
		.s usedesc=$p(^PHCIN(phcindr),"^",2)
		.i usestr="" d
		..s usestr=usedesc
		.e  d
		..s usestr=usestr_","_usedesc
		.i useidstr="" d
		..s useidstr=phcindr
		.e  d
		..s useidstr=useidstr_","_phcindr
		
		q usestr_"^"_useidstr
}

/// 获取DHC_PHInstructions表年龄所有ID
ClassMethod GetDrugInstAgeData(drginstdr) As %String
{
		s agestr=""
		s pdar=0
	    f  s pdar=$o(^DHCPHDAGE(0,"INST",drginstdr,pdar)) q:(pdar="")||(pdar=0)  d
	    .s ageid=$p(^DHCPHDAGE(pdar),"^",1)
	    .s age=$p(^DHCPHPAGEL(ageid),"^",1)
	    .i agestr="" d
	    ..s agestr=ageid
	    .e  d
	    ..s agestr=agestr_","_ageid
	    
	    q agestr
}

/// 获取DHC_PHInstructions表年龄所有描述
ClassMethod GetDrugInstAgeDesc(drginstdr) As %String
{
	    q:drginstdr="" ""
		s agestr=""
		s pdar=0
	    f  s pdar=$o(^DHCPHDAGE(0,"INST",drginstdr,pdar)) q:(pdar="")||(pdar=0)  d
	    .s ageid=$p(^DHCPHDAGE(pdar),"^",1)
	    .s age=$p(^DHCPHPAGEL(ageid),"^",1)
	    .i agestr="" d
	    ..s agestr=age
	    .e  d
	    ..s agestr=agestr_","_age
	    
	    q agestr
}

//获取药品全局说明书ID

ClassMethod FindGlobalDrgInstRowId(drugid, type) As %String
{
	    s typedr=$o(^DHCPHPINL(0,"Code",type,""))
	    s drginstdr=""
		s drgdise=##class(web.DHCSTPHCMADDINST).FindGlobalDrgDiseRowId(drugid,typedr)
	    i drgdise'="" s drginstdr=$p(^DHCPHDDIS(drgdise),"^",4)
	    q drginstdr
}

//获取药品所有病症说明书ID

ClassMethod FindDrgDisInstRowId(drugid) As %String
{
     
        s pid=##class(web.DHCSTPHCMADDINST).GetPID()
        s ret=""
	    s disease=""
		f  s disease=$o(^DHCPHDDIS(0,"DrugDis",drugid,disease)) q:disease=""  d
		.q:disease="A"
		.s drgdise=""
		.f  s drgdise=$o(^DHCPHDDIS(0,"DrugDis",drugid,disease,drgdise)) q:drgdise=""  d
		..s drginstdr=$p(^DHCPHDDIS(drgdise),"^",4)
		..s ^TMP("DHCST","DHCSTPHCMADDINST","FindDrgDisInstRowId",pid,drginstdr)=""
		//
		s dr=""
		f  s dr=$o(^TMP("DHCST","DHCSTPHCMADDINST","FindDrgDisInstRowId",pid,dr)) q:dr=""  d
		.i ret="" d
		..s ret=dr
		.e  d
		..s ret=ret_"^"_dr
		k ^TMP("DHCST","DHCSTPHCMADDINST","FindDrgDisInstRowId",pid)
		
	    q ret
}

//查找药品某一条病症说明书

ClassMethod GetDrgOneDisInstStr(drginstdr) As %String
{
        q:drginstdr="" ""
        s ret=""
        s retid=""
	    s phdisdr=""
		f  s phdisdr=$o(^DHCPHDDIS(0,"INST",drginstdr,phdisdr)) q:phdisdr=""  d
		.s disdr=$p(^DHCPHDDIS(phdisdr),"^",2)
		.q:disdr=""
		.s desc=$p($g(^DHCPHDISL(disdr)),"^",2)
		.i ret="" d
		..s ret=desc
		.e  d
		..s ret=ret_","_desc
		.i retid="" d
		..s retid=disdr
		.e  d
		..s retid=retid_","_disdr
		
		q ret_"^"_retid
}

//查找药品某一条病症说明书

ClassMethod JsQueryDrgDisICD(rows, page, drginstdr) As %String
{

		s pid=##class(web.DHCSTPHCMADDINST).GetPID()
	
		s endpage=page*rows  //结束行
		s stpage=((page-1)*rows)+1 //开始行

		s h=0
		s phdisdr=""
		f  s phdisdr=$o(^DHCPHDDIS(0,"INST",drginstdr,phdisdr)) q:phdisdr=""  d
		.s disdr=$p(^DHCPHDDIS(phdisdr),"^",2)  //对照表id
		.q:disdr=""
		.s desc=$p(^DHCPHDISL(disdr),"^",2)
		.s h=h+1
		.s data=desc_"^"_disdr
		.s ^TMP("DHCST","DHCSTPHCMADDINST","JsQueryDrgDisICD",pid,h)=data
		 q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
		s maxrow=h
		i endpage>maxrow s endpage=maxrow
		s count=0
	    s h=""
	    f  s h=$o(^TMP("DHCST","DHCSTPHCMADDINST","JsQueryDrgDisICD",pid,h)) q:h=""  d
	    .s data=^TMP("DHCST","DHCSTPHCMADDINST","JsQueryDrgDisICD",pid,h)
	    .s desc=$p(data,"^",1)
	    .s rowid=$p(data,"^",2)
	    .
	    .s count=count+1
	    .q:count<stpage
	    .q:count>endpage
	    .
	    .s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
		.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
		.
		.s tmpstr=desc_rowid
	    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
		.
	    .i count=stpage w startString
	    .i count<endpage w firstrow
	    .i count=endpage w lastrow
		.
	
		k ^TMP("DHCST","DHCSTPHCMADDINST","JsQueryDrgDisICD",pid)
	    
	    q ""
}

//查找某一个药品相互作用

ClassMethod FindDrgInteractStr(drginstdr) As %String
{
	q:drginstdr="" ""
	s ret=""
	s itmid=""
	f  s itmid=$o(^DHCPHDINTER(0,"INST",drginstdr,itmid)) q:itmid=""  d
	.s desc=$p(^PHCD(+itmid,1),"^",2)
	.i ret="" d
	..s ret=desc
    .e  d
    ..s ret=ret_","_desc
    q ret
}

/// 删除已对照的频次数据
ClassMethod DelFreqData(rowid) As %String
{
	/*
	&sql(delete from DHC_PHDiseaseFreq where PDF_RowID=:rowid)
	q:SQLCODE'=0 -1
	q 0
	*/
}

/// 删除已对照的用法数据
ClassMethod DelUsageData(rowid) As %String
{
	/*
	&sql(delete from DHC_PHDiseaseUse where PDI_RowID=:rowid)
	q:SQLCODE'=0 -1
	q 0
	*/
}

/// 删除某一条病症的年龄记录
ClassMethod DelAgeData(drginstdr, rowid) As %String
{
	/*
	q:drginstdr="" 0
	s pdar=0
    f  s pdar=$o(^DHCPHDAGE(0,"INST",drginstdr,pdar)) q:(pdar="")||(pdar=0)  d
    .s ageid=$p(^DHCPHDAGE(pdar),"^",1)
    .i rowid=ageid d
    ..&sql(delete from DHC_PHDiseaseAge where PDA_RowID=:pdar)

	q 0
	*/
}

/// 一键对照
ClassMethod ContrastAllICD() As %String
{
	/*
	s mrc=""
	f  s mrc=$o(^MRC("ID",mrc)) q:mrc=""  d 
	.s desc=$p(^MRC("ID",mrc),"^",2)
	.q:desc=""
	.s desc=##Class(web.DHCSTJQUERYCOMMON).GetValue(desc)
	.s chkicdflag=0
	.s phdl=""
	.f  s phdl=$o(^DHCPHDISL(0,"Dis",mrc,phdl)) q:phdl=""  d
	..s icdflag=$p(^DHCPHDISL(phdl),"^",3)
	..i icdflag="Y" d
	...s chkicdflag=1
	...s $p(^DHCPHDISL(phdl),"^",2)=desc  //更新描述 
	.q:chkicdflag=1
	.k PLIST
	.s PLIST(2)="N"
	.s PLIST(3)=desc
	.s PLIST(4)="Y"
	.s PLIST(5)="Y"
	.&sql(INSERT INTO DHC_PHDiseaseList VALUES :PLIST())
	.q:SQLCODE'=0 
	.s main=$p(%ROWID,$c(1))
	.s sub=$o(^DHCPHDISL(main,"Itm",""),-1)+1
    .k PLIST
    .s PLIST(0)=main
    .s PLIST(2)=sub
    .s PLIST(3)=mrc
    .&sql(insert into DHC_PHDiseaseItmList values PLIST())
    .q:SQLCODE'=0 
	.
	q 0
	*/
}

/// 增加对照描述
ClassMethod AddContrastDesc(input) As %String
{
	/*
	s desc=$p(input,"^",1)
	s keyflag=$p(input,"^",2)

	q:$d(^DHCPHDISL(0,"Desc",desc)) -99
	k PLIST
	s PLIST(2)=keyflag
	s PLIST(3)=desc
	s PLIST(4)="N"
	s PLIST(5)="Y"
	&sql(INSERT INTO DHC_PHDiseaseList VALUES :PLIST())
    q:SQLCODE'=0 SQLCODE
    q 0
    */
}

/// 查询已对照病症关联的诊断集合列表
ClassMethod QueryContrastItmDs(page, rows, main) As %String
{
	    s main=+main
		s pid=##class(web.DHCSTPHCMADDINST).GetPID()
	
		s endpage=page*rows  //结束行
		s stpage=((page-1)*rows)+1 //开始行

		s h=0
		s sub=""
		f  s sub=$o(^DHCPHDISL(main,"Itm",sub)) q:sub=""  d
		.s mrc=$p(^DHCPHDISL(main,"Itm",sub),"^",1)  //诊断表id
	
		.q:mrc=""
		.s desc=$p(^MRC("ID",mrc),"^",2)
		.s h=h+1
		.s rowid=main_"||"_sub
		.s data=desc_"^"_rowid
		.s ^TMP("DHCST","DHCSTPHCMADDINST","QueryContrastItmDs",pid,h)=data
		 q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
		
		s maxrow=h
		i endpage>maxrow s endpage=maxrow
		s count=0
	    s h=""
	    f  s h=$o(^TMP("DHCST","DHCSTPHCMADDINST","QueryContrastItmDs",pid,h)) q:h=""  d
	    .s data=^TMP("DHCST","DHCSTPHCMADDINST","QueryContrastItmDs",pid,h)
	    .s desc=$p(data,"^",1)
	    .s rowid=$p(data,"^",2)
	    .b
	    .s count=count+1
	    .q:count<stpage
	    .q:count>endpage
	    .
	    .s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
		.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
		.
		.s tmpstr=desc_rowid
	    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
		.
	    .i count=stpage w startString
	    .i count<endpage w firstrow
	    .i count=endpage w lastrow
		.
	 
		k ^TMP("DHCST","DHCSTPHCMADDINST","QueryContrastItmDs",pid)
	    
	    q ""
}

/// 撤消病症与该诊断的关联
ClassMethod DelContrastItm(rowid) As %String
{
	/*
	s main=+rowid
	s icdflag=$p(^DHCPHDISL(main),"^",3)
	s h=0
	s sub=""
	f  s sub=$o(^DHCPHDISL(main,"Itm",sub)) q:sub=""  d
	.s h=h+1
	q:(icdflag="Y")&(h=1) -99
	&sql(delete from DHC_PHDiseaseItmList where PHDISIL_RowID=:rowid)
	q:SQLCODE'=0 SQLCODE
	q 0
	*/
}

/// 删除某一条说明书记录下关联的病症
ClassMethod DelDrgDis(drginstdr, rowid) As %String
{
	/*
	q:drginstdr="" 0
	s phddr=..FindDrgDiseaseRowId(drginstdr, rowid)
	q:phddr="" 0
	&sql(delete from DHC_PHDrugDisease where PHDD_RowID=:phddr)
	q:SQLCODE'=0 SQLCODE
	q 0
	*/
}

/// 查询药品列表
ClassMethod QueryDrugList(rows, page, tmprowid) As %String
{
       
		s pid=##class(web.DHCSTPHCMADDINST).GetPID()
	
		s endpage=page*rows  //结束行
		s stpage=((page-1)*rows)+1 //开始行

		s h=0
		s tmpphcdr=$p(tmprowid,"||",1)
		s phcdr=0
		i tmprowid'="" s phcdr=$o(^PHCD(tmpphcdr),-1)
		
		f  s phcdr=$o(^PHCD(phcdr)) q:(phcdr="")||(phcdr=0)  d
		.q:+phcdr=0
		.q:(h>1)&(tmprowid'="")
		.q:'$d(^PHCD(+phcdr,1))
		.s code=$p(^PHCD(+phcdr,1),"^",1)
		.s desc=$p(^PHCD(+phcdr,1),"^",2)
		.s dosage=""
		.s sub=0
		.f  s sub=$o(^PHCD(phcdr,"DF",sub)) q:(sub="")||(sub=0)  d 
		..s phcfrdr=$p(^PHCD(phcdr,"DF",sub,1),"^",1)
	    ..i phcfrdr'="" s dosage=$p($g(^PHCF(phcfrdr)),"^",2)
	    ..s rowid=phcdr_"||"_sub
	    .s inci=$o(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(code)_"Z",""))
	    .q:inci=""
	    .q:##class(web.DHCSTITMDESC).CatType(inci)'="G"
	    .s spec=""
	    .i inci'="" d
	    ..s addinfo=$o(^DHCITMINFO(0,"INCI",inci,""))
	    ..i addinfo'="" d
	    ...s spec=$p(^DHCITMINFO(addinfo),"^",27)
	    .s manf=""
	    .s manfdr=$p(^PHCD(phcdr,2),"^",4)
	    .i manfdr'="" d
	    ..s manf=$p(^PHMNF(manfdr),"^",2)
	    ..i $f(manf,"-") s manf=$p(manf,"-",2)
	    .
	    .s data=code_"^"_desc_"^"_spec_"^"_dosage_"^"_manf_"^"_rowid
	    .
		.s h=h+1
		.s index=code_"^"_h
		.s ^TMP("DHCST","DHCSTPHCMADDINST","QueryDrugList",pid,index)=data
		 q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
		
		s maxrow=h
		i endpage>maxrow s endpage=maxrow
		s count=0
	    s h=""
	    f  s h=$o(^TMP("DHCST","DHCSTPHCMADDINST","QueryDrugList",pid,h)) q:h=""  d
	    .s data=^TMP("DHCST","DHCSTPHCMADDINST","QueryDrugList",pid,h)
	    .s code=$p(data,"^",1)
	    .s desc=$p(data,"^",2)
	    .s spec=$p(data,"^",3)
	    .s dosage=$p(data,"^",4)
	    .s manf=$p(data,"^",5)
	    .s rowid=$p(data,"^",6)
	
	    .s count=count+1
	    .q:count<stpage
	    .q:count>endpage
	    .
	    .s code=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("code",code)
	    .s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	    .s spec=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("spec",spec)
	    .s dosage=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("dosage",dosage)
	    .s manf=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("manf",manf)
		.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
		.
		.s tmpstr=code_desc_spec_dosage_manf_rowid
	    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
		.
	    .i count=stpage w startString
	    .i count<endpage w firstrow
	    .i count=endpage w lastrow
		.
	 
		k ^TMP("DHCST","DHCSTPHCMADDINST","QueryDrugList",pid)
	    
	    q ""
}

/// 
/// 删除某一条说明书记录
ClassMethod DelInst(rowid) As %String
{
	/*
    tstart
	&sql(delete from DHC_PHInstructions	 where PHINST_RowID=:rowid)
	i SQLCODE'=0 tro
	q:SQLCODE'=0 SQLCODE
	
	s err=0
	i $d(^DHCPHDDIS(0,"INST",rowid)) d
	.&sql(delete from DHC_PHDrugDisease	 where PHDD_Inst_Dr=:rowid)
	.i SQLCODE'=0 s err=SQLCODE
	i err'=0 tro
	q:err'=0 err
	
	i $d(^DHCPHDISFR(0,"INST",rowid)) d
	.&sql(delete from DHC_PHDiseaseFreq where PDF_Inst_Dr=:rowid)
	.i SQLCODE'=0 s err=SQLCODE
	i err'=0 tro
	q:err'=0 err
	
	i $d(^DHCPHDISUSE(0,"INST",rowid)) d
	.&sql(delete from DHC_PHDiseaseUse where PDI_Inst_Dr=:rowid)
	.i SQLCODE'=0 s err=SQLCODE
	i err'=0 tro
	q:err'=0 err
	
	i $d(^DHCPHDAGE(0,"INST",rowid)) d
	.&sql(delete from DHC_PHDiseaseAge where PDA_Inst_Dr=:rowid)
	.i SQLCODE'=0 s err=SQLCODE
	i err'=0 tro
	q:err'=0 err
	
	tcommit
	
	
	q 0
	
	*/
}

/// 获取某一药的类型记录的控制级别
ClassMethod GetDrugInstMode(drugid, type) As %String
{
	s typedr=$o(^DHCPHPINL(0,"Code",type,""))
	s instmode=""
	s drgdise=..FindGlobalDrgDiseRowId(drugid,typedr)
	q:drgdise="" ""
	i drgdise'="" d
	.s drginstdr=$p(^DHCPHDDIS(drgdise),"^",4)
	.s instmode=$p(^DHCPHINSTRUC(drginstdr),"^",40)
	q instmode
}

/// 根据页签类型判断是否在说明书表属于全局
ClassMethod ChkGolbalLabel(optype) As %String
{
	i optype="freq" q 1
	i optype="usage" q 1
	
	q 0
}

/// 更新管控级别
ClassMethod UpdateGolbalDrgData(drugid, type, input) As %String
{
   
	    s mode=$p(input,"^",1)
	    s drginstdr=""
	    s typedr=$o(^DHCPHPINL(0,"Code",type,""))
		s drgdise=..FindGlobalDrgDiseRowId(drugid,typedr)
		i drgdise'="" d
		.s drginstdr=$p(^DHCPHDDIS(drgdise),"^",4)
		q:drginstdr="" 0
		s $p(^DHCPHINSTRUC(drginstdr),"^",40)=mode
		q 0
}

/// 检查
/// w ##Class(web.DHCSTPHCMADDINST).PassOrdItmByPha("")
ClassMethod PassOrdItmByPha(input) As %String
{
	    
  
		/*
		病人性别
		病人年龄
		病人体重
		特列人群，是否计划妊娠
		特列人群，是否更年期妇女
		特列人群，是否经期
		特列人群，是否哺乳期
		特列人群，是否孕妇
		特列人群，是否肝肾功能不全
		诊断
		医嘱项
		用法
		频次
		剂量
		剂量单位
		医嘱数量
		数量单位
		疗程
		用药体表面积
		首次用药数量
		首次用药数量单位
		关联组号
		*/ 

      
        s questionflag=""  //空-没问题, 0-一般问题, 1-管制问题
        s indflag=0  //适应症标志
        
        s input="2^26^^N^N^N^N^N^N^1||1"_$c(2)_"1||2^9339||1!204!17!1!198!6!63!!1!!"
		s node="DHCST,DHCSTPHCMADDINST,PassOrdItmByPha"
		s pid=##class(web.DHCSTPHCMADDINST).GetPID()
	    s ^CLILOG(+$H,pid)=input
	      /*
	    q ""
      
		s patsex=$p(input,"^",1)
		s patage=$p(input,"^",2)
		s patweight=$p(input,"^",3)
		s patplan=$p(input,"^",4)
		s patclimac=$p(input,"^",5)
		s patlac=$p(input,"^",6)
		s patmens=$p(input,"^",7)
		s patpre=$p(input,"^",8)
		s patren=$p(input,"^",9)
		s paticdstr=$p(input,"^",10) //诊断
		
		
        s itminfo=$p(input,"^",11)
		s arrcnt=$l(itminfo,$c(2))
		f i=1:1:arrcnt d
		.s itmstr=$p(itminfo,$c(2),i)
		.s arci=$p(itmstr,"!",1)
		.s drugid=$p(^ARCIM(+arci,$p(arci,"||",2),1),"^",12)
		.s instid=$p(itmstr,"!",2)
		.s freqid=$p(itmstr,"!",3)
		.s freqfac=$p(^PHCFR(freqid),"^",2)
		.s dosqty=$p(itmstr,"!",4) //剂量
		.s dosuomid=$p(itmstr,"!",5)
		.s ordqty=$p(itmstr,"!",6)
		.s orduomid=$p(itmstr,"!",7)
		.s index=i_"^"_drugid
		.s alldesc="全部"
		.s phdisl=$o(^DHCPHDISL(0,"Desc",alldesc,""))
		.s ^TMP(node,pid,"ICD",phdisl)=""
		.s paticdcnt=$l(paticdstr,$c(2))
		.f x=1:1:paticdcnt d
		..s paticd=$p(paticdstr,$c(2),x)
		..s phdisl=""
		..f  s phdisl=$o(^DHCPHDISL(0,"Dis",paticd,phdisl)) q:phdisl=""  d
		...s ^TMP(node,pid,"ICD",phdisl)=""
		.. 
		.s phdis=""
		.f  s phdis=$o(^TMP(node,pid,"ICD",phdis)) q:phdis=""  d
		..s drgdise=""
		..f  s drgdise=$o(^DHCPHDDIS(0,"DrugDis",drugid,phdis,drgdise)) q:drgdise=""  d
		...q:disease="A" //全局的不考虑
		...s drginstdr=$p(^DHCPHDDIS(drgdise),"^",4)
		...s ^TMP(node,pid,"PhInst",drginstdr)=""
		.
		.s drginstdr=""
		.f  s drginstdr=$o(^TMP(node,pid,"PhInst",drginstdr)) q:drginstdr=""  d
		..s data=##class(web.DHCSTPHCMADDINST).GetDrugInstData(drginstdr)
		..//用药次数
		..s onedaytimeflag=0
		..s OneDayTimeMin=$p(Data,"^",4)
	    ..s OneDayTimeMax=$p(Data,"^",5)
	    ..i ((freqfac'>OneDayTimeMax)&(OneDayTimeMax'=""))&((freqfac'<OneDayTimeMin)&(OneDayTimeMin'="")) s onedaytimeflag=1
	    ..i (OneDayTimeMin="")&(OneDayTimeMax'="") s onedaytimeflag=1
	    ..//单次服药量
	    ..s onceqtyflag=0
	    ..s OnceQtyMin=$p(Data,"^",6)
	    ..s OnceQtyMax=$p(Data,"^",7)
	    ..s OnceQtyUomDr=$p(Data,"^",8)
	    ..s OnceQtyUom=$p(^CT("UOM",OnceQtyUomDr),"^",1)
	    ..s fac=##class(web.DHCSTCOMMONSRV).UOMFac(dosuomid,OnceQtyUomDr)
	    ..s dosqty=dosqty*fac
    	..i ((dosqty'>OnceQtyMax)&(OnceQtyMax'=""))&((dosqty'<OnceQtyMin)&(OnceQtyMin'="")) s onceqtyflag=1
	    ..i (OnceQtyMin="")&(OnceQtyMax'="") s onceqtyflag=1
	    ..//每日用药量
	    ..s onedayqtyflag=0
 		..s OneDayQtyMin=$p(Data,"^",9)
	    ..s OneDayQtyMax=$p(Data,"^",10)
	    ..s OneDayQtyUomDr=$p(Data,"^",11) 
	    ..s OneDayQtyUom=$p(^CT("UOM",OneDayQtyUomDr),"^",1)
	    ..s fac=##class(web.DHCSTCOMMONSRV).UOMFac(dosuomid,OnceQtyUomDr)
	    ..s onedayqty=dosqty*fac*freqfac
    	..i ((onedayqty'>OneDayQtyMax)&(OneDayQtyMax'=""))&((onedayqty'<OneDayQtyMin)&(OneDayQtyMin'="")) s onedayqtyflag=1
	    ..i (OnceQtyMin="")&(OnceQtyMax'="") s onedayqtyflag=1
	    ..//每次最大量	
	    ..s oncemaxflag=0	
	    ..s OnceMaxQty=$p(Data,"^",12)
	    ..s OnceMaxQtyUomDr=$p(Data,"^",13)
	    ..s OnceMaxQtyUom=$p(^CT("UOM",OnceMaxQtyUomDr),"^",1)
    	..i (dosqty'>OnceMaxQty)&(OnceMaxQty'="") s oncemaxflag=1
	    ..i (OnceMaxQty="") s oncemaxflag=1
	    ..//每日最大量
        ..s ondaymaxflag=0
	    ..s OneDayMaxQty=$p(Data,"^",14)
	    ..s OneDayMaxQtyUomDr=$p(Data,"^",15)
	    ..s OneDayMaxQtyUom=$p(^CT("UOM",OneDayMaxQtyUomDr),"^",1)
	    ..i (onedayqty'>OneDayMaxQty)&(OneDayMaxQty'="") s ondaymaxflag=1
	    ..i (OneDayMaxQty="") s ondaymaxflag=1
	    ..//首次量
	    ..s fristtimeflag=0
	    ..s FristTimeQtyMin=$p(Data,"^",16)
	    ..s FristTimeQtyMax=$p(Data,"^",17)
	    ..s FristTimeQtyUomDr=$p(Data,"^",18)
    	..i (fristtimeqty'="")&((fristtimeqty'>FristTimeQtyMax)&(FristTimeQtyMax'=""))&((fristtimeqty'<FristTimeQtyMin)&(FristTimeQtyMin'="")) s fristtimeflag=1
	    ..i (FristTimeQtyMin="")&(FristTimeQtyMax'="") s fristtimeflag=1
	    ..//连用
	    ..s DurationQtyMin=$p(Data,"^",19)
	    ..s DurationQtyMax=$p(Data,"^",20)
	    ..s DurationQtyUomDr=+$p(Data,"^",21)
	    ..//服药间隔
	    ..s SpaceQtyMin=$p(Data,"^",22)
	    ..s SpaceQtyMax=$p(Data,"^",23)
	    ..s SpaceQtyUomDr=$p(Data,"^",24)
		..
		..//特殊人群
	    ..s PlanPregnancy=$p(Data,"^",29)
	    ..q:planflag'=PlanPregnancy 
	    ..
        ..s Climacteric=$p(Data,"^",30)
        ..q:patclimac'=Climacteric  //"更年期妇女"
        ..
        ..s Menstrual=$p(Data,"^",31)
        ..q:patmens'=Menstrual  //"经期"
        ..
        ..s Lactation=$p(Data,"^",32)
        ..q:patlac'=Lactation //"哺乳期"
        ..
        ..s Pregnant=$p(Data,"^",33)
        ..q:patpre'=Pregnant //"孕妇"
        ..
        ..s RenalFunction=$p(Data,"^",34)
        ..q:patren'=RenalFunction  //肝肾功能不全"
        ..
	    ..//性别
	    ..s sex=$p(Data,"^",3)
        ..q:(patsex'=sex)&(patsex'="")&(sex'="A") //性别满足(全部)
        ..//体重
	    ..s WeightMin=$p(Data,"^",25)
	    ..s WeightMax=$p(Data,"^",26)
	    ..q:(patweight<WeightMin)&(WeightMin'="")&(patweight'="")&(patweight>WeightMax)&(WeightMax'="")&(patweight'="") 
	    ..//年龄
	    ..s ageflag=0
	    ..i patage="" s ageflag=1
	    ..s agestr=..GetDrugInstAgeDesc(drginstdr)
	    ..i agestr="" s ageflag=1
	    ..s agecnt=$l(agestr,",")
	    ..f x=1:1:agecnt d
	    ...s tmpage=$p(agestr,",",x)
	    ...q:tmpage=""
	    ...i tmpage=patage d
	    ....s ageflag=1  //年龄满足
	    ..q:ageflag=0
	    ..//---------------------以上是全部项目检查-----------------------
	    ..s instmode=$p(Data,"^",40)
		..s typedr=$p(Data,"^",1)
		..s labelcode=$p(^DHCPHPINL(typedr),"^",1)
		..s labeldesc=$p(^DHCPHPINL(typedr),"^",2)
		..
		..i labelcode="Indication" d
		...s indflag=1  //适应症通过
		..
		..i labelcode="Contraindication" d
		...i questionflag="" s questionflag=0
		...i instmode=1 s questionflag=1
		...s num=+$o(^TMP(node,pid,"DrugItm",index,"Con",""))+1
		...s icddesc=..GetDrgOneDisInstStr(drginstdr)
	    ...s ^TMP(node,pid,"DrugItm",index,"Con",num)="禁忌症^"_icddesc_"^"_instmode
		..i labelcode="Disease" d
		...i questionflag="" s questionflag=0
		...i instmode=1 s questionflag=1
		...i onedaytimeflag=0 d
		....s num=+$o(^TMP(node,pid,"DrugItm",index,"Dis",""))+1
	    ....s ^TMP(node,pid,"DrugItm",index,"Dis",num)="用法用量^"_"用药次数:"_OneDayTimeMin_"-"_OneDayTimeMax_"^"_instmode
	    ...i onceqtyflag=0 d
	    ....s num=+$o(^TMP(node,pid,"DrugItm",index,"Dis",""))+1
	    ....s ^TMP(node,pid,"DrugItm",index,"Dis",num)="用法用量^"_"单次用药量:"_OnceQtyMin_"-"_OnceQtyMax_OnceQtyUom_"^"_instmode
		...i onedayqtyflag=0 d
		....s num=+$o(^TMP(node,pid,"DrugItm",index,"Dis",""))+1
	    ....s ^TMP(node,pid,"DrugItm",index,"Dis",num)="用法用量^"_"每日服药总量:"_OneDayQtyMin_"-"_OneDayQtyMax_OneDayQtyUom_"^"_instmode
	    ...i oncemaxflag=0 d
	    ....s num=+$o(^TMP(node,pid,"DrugItm",index,"Dis",""))+1
	    ....s ^TMP(node,pid,"DrugItm",index,"Dis",num)="用法用量^"_"每次最大量:"_OnceMaxQty_OnceMaxQtyUom_"^"_instmode
        ...i ondaymaxflag=0 d
        ....s num=+$o(^TMP(node,pid,"DrugItm",index,"Dis",""))+1
	    ....s ^TMP(node,pid,"DrugItm",index,"Dis",num)="用法用量^"_"每日最大量:"_OneDayMaxQty_OneDayMaxQtyUom_"^"_instmode
        ...
        //相互作用
		s drginstdr=..FindGlobalDrgInstRowId(drugid,"Interact")
		i drginstdr'="" d
		.s inter=""
		.f  s inter=$o(^DHCPHDINTER(0,"Inst",drginstdr,drugid,inter)) q:inter=""  d
		..s phcd=$p(^DHCPHDINTER(inter),"^",1)
		..s desc=$p(^PHCD(+phcd,1),"^",2)
		..s instmode=$p(^DHCPHDINTER(inter),"^",3)
		..i instmode="C" s instmode=1
		..s num=+$o(^TMP(node,pid,"DrugItm",index,"Inter",""))+1
	    ..s ^TMP(node,pid,"DrugItm",index,"Inter",num)="相互作用^"_desc_"^"_instmode
	    ..i questionflag="" s questionflag=0
		..i instmode=1 s questionflag=1
	    //
	    i indflag=0 d
	    .s labeldr=$o(^DHCPHPINL(0,"Code","Indication",""))
	    .s ordnum=$o(^DHCPHINSTRUC(0,"OrderNum",drugid,labeldr,""))
	    .q:ordnum=""
	    .s drginstdr=$o(^DHCPHINSTRUC(0,"OrderNum",drugid,labeldr,ordnum,""))  
	    .s instmode=$p(^DHCPHINSTRUC(drginstdr),"^",40)
	    .s num=+$o(^TMP(node,pid,"DrugItm",index,"Ind",""))+1
	    .s ^TMP(node,pid,"DrugItm",index,"Ind",num)="适应症^"_"超出适应症范围^"_instmode
	    .i questionflag="" s questionflag=0
		.i instmode=1 s questionflag=1
		
		s h=0
		s index=""
		f  s index=$o(^TMP(node,pid,"DrugItm",index)) q:index=""  d
		.s drugid=$p(index,"^",2)
		.s itemid=""
		.s item=$p(^PHCD(+drugid,1),"^",2)
		.s desc=""
		.s flag=""
		.s h=h+1
		.s data=h_"^"_item_"^"_desc_"^"_flag
		.s ^TMP(node,pid,"Itm",h)=data
		.//适应症
		.s num=""
		.f  s num=$o(^TMP(node,pid,"DrugItm",index,"Ind",num))  q:num=""  d
		..s itemid=""
		..s data=^TMP(node,pid,"DrugItm",index,"Ind",num)
		..s itemid=""
		..s desc=$p(data,"^",2)
		..s flag =$p(data,"^",3)
		..s h=h+1
		..s data=h_"^"_"适应症"_"^"_desc_"^"_flag
		..s ^TMP(node,pid,"Itm",h)=data
		.//禁忌症
		.s constr="" 
		.s num=""
		.f  s num=$o(^TMP(node,pid,"DrugItm",index,"Con",num))  q:num=""  d
		..s itemid=""
		..s data=^TMP(node,pid,"DrugItm",index,"Con",num)
		..s desc=$p(data,"^",2)
		..s flag=$p(data,"^",3)
		..i constr="" d
		...s constr=desc
		..e  d
		...s constr=constr_","_desc
		.i constr'="" d
		..s h=h+1
		..s data=h_"^"_"禁忌症"_"^"_constr_"^"_flag
		..s ^TMP(node,pid,"Itm",h)=data
		.//用法用量
		.s disstr=""
		.s num=""
		.f  s num=$o(^TMP(node,pid,"DrugItm",drugid,"Dis",num)) q:num=""  d
		..s itemid=""
		..s data=^TMP(node,pid,"DrugItm",index,"Dis",num)
		..s desc=$p(data,"^",2)
		..s flag=$p(data,"^",3)
		..i disstr="" d
		...s disstr=desc
		..e  d
		...s disstr=disstr_","_desc
		.i disstr'="" d
		..s h=h+1
		..s data=h_"^"_"用法用量"_"^"_disstr_"^"_flag
		..s ^TMP(node,pid,"Itm",h)=data
		.//相互作用
		.s num=""
		.f  s num=$o(^TMP(node,pid,"DrugItm",drugid,"Inter",num)) q:num=""  d
		..s itemid=""
        ..s data=^TMP(node,pid,"DrugItm",index,"Inter",num)
		..s desc=$p(data,"^",2)
		..s flag=$p(data,"^",3)
        ..s h=h+1
		..s data=h_"^"_"相互作用"_"^"_desc_"^"_flag
		..s ^TMP(node,pid,"Itm",h)=data
		.
	    k ^TMP(node,pid,"DrugItm")
	    
	    
	    q questionflag_"^"_h_"^"_pid
	     */

	    s drugid=""
		s h=0
	    s questionflag=0
	    
		f i=1:1:6 d
		.s desc=""
		.s parentId=""
		.s iconcls=""
		.s flag=""
		.i i=1 d
		..s itemid="1"
		..s item="阿莫西林西林西林[0.3/ml]"
		..
		.i i=2 d
		..s itemid=11
		..s item="适应症"
		..s desc="超出适应症范围"
		..s iconcls="icon-ok"
		..s parentId="1"
		.i i=3 d
		..s itemid=12
		..s item="禁忌症"
		..s desc="与诊断有禁忌症忌症忌症忌症忌症忌症忌症忌症忌症忌症忌症忌症"
		..s iconcls="icon-ok"
		..s parentId="1"
		..s flag=1
		.i i=4 d
		..s itemid=2
		..s item="氯化钠4"
		.i i=5 d
		..s itemid=3
		..s item="氯化钠5"
		.i i=6 d
		..s itemid=4
		..s item="氯化钠6"
		.;i i=7 d
		.;.s itemid=5
		.;.s item="氯化钠"
		.s h=h+1
		.s data=itemid_"^"_item_"^"_desc_"^"_flag_"^"_"858||1"
		.s ^TMP(node,pid,"Itm",h)=data
		 q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()

	     q 0_"^"_h_"^"_pid
}

ClassMethod GetPassOrdItmResult(input) As %String
{
	    
        s node="DHCST,DHCSTPHCMADDINST,PassOrdItmByPha"
        s pid=$p(input,"^",3)
        s maxrow=$p(input,"^",2)
		s count=0
	    s h=""
	    f  s h=$o(^TMP(node,pid,"Itm",h)) q:h=""  d
	    .s data=^TMP(node,pid,"Itm",h)
	    .s itemid=$p(data,"^",1)
	    .s item=$p(data,"^",2)
	    .s desc=$p(data,"^",3)
	    .s flag=$p(data,"^",4)
	    .s drugid=$p(data,"^",5)
	    .s count=count+1
	    .
	    .s itemid=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("itemid",itemid)
		.s item=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("item",item)
		.s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
		.s flag=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("flag",flag)
		.s drugid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("drugid",drugid)
		.s tmpstr=itemid_item_desc_flag_drugid
		.
	    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
		.
	    .i count=1 w startString
	    .i count<maxrow w firstrow
	    .i count=maxrow w lastrow

		
	 
		//k ^TMP(node,pid,"Itm")
		
		q ""
}

}
