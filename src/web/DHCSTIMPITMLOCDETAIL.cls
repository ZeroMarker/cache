Import sqluser

Class web.DHCSTIMPITMLOCDETAIL Extends %RegisteredObject [ Not ProcedureBlock ]
{

//科室库存辅助数据初始化程序,数量都是大包装数量

//数据列(科室代码、科室描述、药品代码、药品描述、包装单位、药品货位(多货位用","分割)、上限、下限、标准库存、补货标准、加锁标志、配液打包标记、管理药标记)

//确保科室有该药品，而且货位字典已导入，导入的科室货位正确在字典里

//1 准备数据表文件(*.txt,12列,tab字符分隔)

//2 读取数据到临时global

//3 更新INC_ItmLoc、DHC_IncItmLocBin、dhc_incitmloc数据

//add by wyx 2015-01-15

//w ##class(web.DHCSTIMPITMLOCDETAIL).importdata("D:/123.txt")

ClassMethod importdata(fname)
{
 ;fname : the filename including data(必须是全路径)
 ;
 s pid=..NewPid()
 q:fname="" -1
 w "正在读取数据...",!
 s file=fname
 k ^TMP("web","DHCSTIMPITMLOCDETAIL",pid)
 s ret=..RR(file)
 w "正在生成导入数据...",!
 s ret=..SaveDataToGlobal(pid)
 q:ret=0 -2
 s locdr=""
 f   s locdr=$o(^TMP("web","DHCSTIMPITMLOCDETAIL",pid,"LocStr",locdr)) q:locdr=""  d
 .d ..SaveLocItmData(locdr,pid)
 w "处理完毕。",!
 k ^TMP("web","DHCSTIMPITMLOCDETAIL",pid)
 q 0
}

ClassMethod RR(file)
{
 s del="^"
 s file=file
 s $zt="close^"_$zn
 o file:"RS"
 u file
 s i=0
 f   d   
  . r srec
  . s i=i+1
  . s ^TMP("web","DHCSTIMPITMLOCDETAIL",pid,"DataList",i)=srec
  . s ^TMP("web","DHCSTIMPITMLOCDETAIL",pid,"DataList",i)=$tr(^TMP("web","DHCSTIMPITMLOCDETAIL",pid,"DataList",i),$c(9),del)
  . 
close c file
 q pid
}

ClassMethod SaveDataToGlobal(pid)
{
 n (pid)
 s num=0
 s cnt=0
 f  s cnt=$o(^TMP("web","DHCSTIMPITMLOCDETAIL",pid,"DataList",cnt)) q:cnt=""  d
 .s data=^TMP("web","DHCSTIMPITMLOCDETAIL",pid,"DataList",cnt)
 .s loccode=$p(^TMP("web","DHCSTIMPITMLOCDETAIL",pid,"DataList",cnt),"^",1)
 .s locDr=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(loccode),""))
 .i '$d(^TMP("web","DHCSTIMPITMLOCDETAIL",pid,"LocStr",locDr)) s ^TMP("web","DHCSTIMPITMLOCDETAIL",pid,"LocStr",locDr)=""
 .
 . s code=$p(data,"^",3)
 . i code'="" &sql(select INCI_RowId into :inci from INC_Itm where INCI_Code = :code)
 . i code="" s inci="" d ..rej("Code is NULL: "_"") q   //代码为空
 . i inci="" d ..rej("Stock Item RowId is NULL:"_""_","_code) q
 .
 .s incilch=$o(^INCI("IL_LOC",locDr,inci,""))
 .i incilch=""  d ..rej("incil is NULL:"_""_","_incilch) q
 .s incil=inci_"||"_incilch
 .s locsbstr=$p(data,"^",6) //科室货位
 .s maxQty=$p(data,"^",7) //库存上限   
 .s minQty=$p(data,"^",8)  //库存下限
 .s repQty=$p(data,"^",9)   //标准库存
 .s repLevel=$p(data,"^",10)  //补货标准
 .s lockFlag=$p(data,"^",11)   //锁定标志
 .s pivaPack=$p(data,"^",12)     //配液打包标记
 .s manFlag=$p(data,"^",13)     //管理药标志
 . 
 .s num=num+1
 .s ^TMP("web","DHCSTIMPITMLOCDETAIL",pid,"LocDetData",locDr,num)=incil_"^"_locsbstr_"^"_maxQty_"^"_minQty_"^"_repQty_"^"_repLevel_"^"_lockFlag_"^"_pivaPack_"^"_manFlag
 q num
}

ClassMethod SaveLocItmData(locdr, pid)
{
  n (locdr,pid)
  s num=0
  f  s num=$o(^TMP("web","DHCSTIMPITMLOCDETAIL",pid,"LocDetData",locdr,num)) q:num=""  d
  .s data=^TMP("web","DHCSTIMPITMLOCDETAIL",pid,"LocDetData",locdr,num)
  .s incil=$p(data,"^",1) 
  .s locsbstr=$p(data,"^",2)  //科室货位
  .s cnt=$l(locsbstr,",")
  .f count=1:1:cnt d
  ..s stkbinDesc=$p(locsbstr,",",count)
  ..s savestr1=incil_"^"_stkbinDesc_"^"_locdr
  ..d ..SaveLocItmBin(savestr1)
  ..
  .
  .s maxQty=$p(data,"^",3) //库存上限   
  .s minQty=$p(data,"^",4)   //库存下限
  .s repQty=$p(data,"^",5)    //标准库存
  .s repLevel=$p(data,"^",6)   //补货标准
  .s savestr2=incil_"^"_maxQty_"^"_minQty_"^"_repQty_"^"_repLevel
  .d ..SaveLocItmInfo1(savestr2)
  .s lockFlag=$p(data,"^",7)    //锁定标志
  .s pivaPack=$p(data,"^",8)      //配液打包标记
  .s manFlag=$p(data,"^",9)      //管理药标志
  .if lockFlag="是" s lockFlag="Y"
  .e  s lockFlag="N"
  .
  .if pivaPack="是" s pivaPack="Y"
  .e  s pivaPack="N"
  .
  .if manFlag="是" s manFlag="1"
  .e  s manFlag="0"
  .s savestr3=incil_"^"_lockFlag_"^"_pivaPack_"^"_manFlag
  .d ..SaveLocItmInfo2(savestr3)
  q
}

/// 批量保存货位码记录
/// Author:zhangdongmei
/// Date:2012-08-20
/// Argu:科室库存id^货位id  
ClassMethod SaveLocItmBin(savestr)
{
    n (savestr)
    s incil=$p(savestr,"^",1)
    s stkbinDesc=$p(savestr,"^",2)
    s locDr=$p(savestr,"^",3)
    s stkbindr=$o(^INC("SB",0,"Desc",$$ALPHAUP^SSUTIL4(stkbinDesc),""))
    i stkbindr="" d ..rej("stkbindr is NULL:"_stkbindr_","_incil) q
    s stkbinCodeStr=$p(^INC("SB",stkbindr),"^",1)
    s stkbinCode=""
    s:stkbinCodeStr["P" stkbinCode=$p(stkbinCodeStr,"P",1)
    q:(stkbinCode'=locDr)&(stkbinCode'="")
    s exist=0
    s incilb=""
    f  s incilb=$o(^DHCINCILB(0,"Loc",incil,incilb)) q:incilb=""  d
    .s stkbin=$p(^DHCINCILB(incilb),"^",2)
    .i stkbin=stkbindr d
    ..s exist=1
    i exist=1 d ..rej("stkbindr is Repeat:"_stkbindr_","_incil) q
  
    &sql(Insert into DHC_IncItmLocBin(INCILB_ItmLoc_Dr,INCILB_StkBin_Dr)
    values(:incil,:stkbindr))
    i SQLCODE'=0  d ..rej("stkbindr is Failed to insert:"_stkbindr_","_incil) q
  
    q
}

/// 更新科室库存项目信息
/// Author:wyx
/// Date:2015-01-15
/// Argu:科室库存id^库存上限^库存下限^标准库存^补货标准  
ClassMethod SaveLocItmInfo1(savestr)
{
  n (savestr)
   s incil=$p(savestr,"^",1) //科室库存项rowid
   s maxQty=$p(savestr,"^",2) //库存上限   
   s minQty=$p(savestr,"^",3)   //库存下限
   s repQty=$p(savestr,"^",4)    //标准库存
   s repLevel=$p(savestr,"^",5)   //补货标准
   
   s uomid=$p(^INCI(+incil,1),"^",10)
   s puruomid=$p(^INCI(+incil,3),"^",6)
   s fac=##Class(web.DHCST.Common.UtilCommon).UOMFac(puruomid,uomid)
   s maxQty=maxQty*fac     //转换成基本单位对应的数量
   s minQty=minQty*fac
   s repQty=repQty*fac
   s repLevel=repLevel*fac
   &sql(Update INC_ItmLoc set INCIL_MaxQty=:maxQty,INCIL_MinQty=:minQty,INCIL_RepQty=:repQty,INCIL_RepLev=:repLevel)
   i SQLCODE'=0  d ..rej("INC_ItmLoc is Failed to Update:"_savestr_","_incil) q
  q
}

/// 更新科室库存项目信息2
/// Author:wyx
/// Date:2015-01-15
/// Argu:科室库存id^锁定标志^配液打包标记^管理药标志
ClassMethod SaveLocItmInfo2(savestr)
{
  n (savestr)
   s incil=$p(savestr,"^",1) //科室库存项rowid
   s lockFlag=$p(savestr,"^",2)    //锁定标志
   s pivaPack=$p(savestr,"^",3)      //配液打包标记
   s manFlag=$p(savestr,"^",4)      //管理药标志
   s dINCIL=""
   &sql(select %ID into :dINCIL from dhc_incitmloc where incil_incil_dr=:incil)
   i $G(dINCIL)="" d
   .&sql(insert into dhc_incitmloc(INCIL_INCIL_DR,INCIL_LockFlag,INCIL_PIVAPack,INCIL_USEFLAG) 
         values(:incil,:lockFlag,:pivaPack,:manFlag))
   .i SQLCODE'=0  d ..rej("dhc_incitmloc is Failed to Insert"_savestr_","_incil) q
   else  d
   .&sql(Update dhc_incitmloc set INCIL_LockFlag=:lockFlag,INCIL_PIVAPack=:pivaPack,INCIL_USEFLAG=:manFlag
     where INCIL_RowId=:dINCIL )
   .i SQLCODE'=0  d ..rej("dhc_incitmloc is Failed to Update:"_savestr_","_incil) q
  q
}

ClassMethod rej(param)
{
 n (param)
  ;f j=1:1 q:$t(reject+j)'[";"  s reject(j)=$p($t(reject+j),";",2)
  ;s str=$g(reject(num))
  ;s count=$o(^REJECT($ZN,""),-1)+1,^REJECT($ZN,count)=str_" : "_param
  s count=$o(^REJECT($ZN,""),-1)+1,^REJECT($ZN,count)=param
  q
}

ClassMethod errlog()
{
 s ind="" f  s ind=$o(^REJECT($zn,ind)) q:ind=""  w ^(ind),!
 q
}

ClassMethod NewPid() As %String
{
  q $I(^DHCSTPID("web.DHCSTIMPITMLOCDETAIL"))
}

//Create by wyx 2015-04-16

//Desc:从以前的药学三级分类(大类，子类，小类)导入至新的多级药学分类的字典里

//w ##class(web.DHCSTIMPITMLOCDETAIL).ImpDHCPhcCatDataFromPhcCat()

ClassMethod ImpDHCPhcCatDataFromPhcCat()
{
	//k ^DHCPHCC
	s PhcCatId=0
    s phcnum1=0,phcnum2=0,phcnum3=0
    f  s PhcCatId=$o(^PHCC(PhcCatId)) q:PhcCatId=""  d
	.q:$g(^PHCC(catid))=""
	.s CatCode=$p($g(^PHCC(PhcCatId)),"^",1)
	.s CatDesc=$p($g(^PHCC(PhcCatId)),"^",2)
	.q:(CatCode="")||(CatDesc="")
	.s ret=..SaveCat(0,CatCode,CatDesc)
	.q:ret'>0
	.s ParCat=ret
	.s phcnum1=phcnum1+1
	.s Sub=0
    .f  s Sub=$o(^PHCC(PhcCatId,"SC",Sub)) q:Sub=""  d
    ..s CatCode2=$p($g(^PHCC(PhcCatId,"SC",Sub)),"^",1)
	..s CatDesc2=$p($g(^PHCC(PhcCatId,"SC",Sub)),"^",2)
	..s ret=..SaveCat(ParCat,CatCode2,CatDesc2)
	..q:ret'>0
	..s ParCat2=ret
	..s phcnum2=phcnum2+1
	..s Chl=0
    ...f  s Chl=$o(^PHCC(PhcCatId,"SC",Sub,"MIN",Chl)) q:Chl=""  d
    ...s CatCode3=$p($g(^PHCC(PhcCatId,Sub,"MIN",Chl)),"^",1)
	...s CatDesc3=$p($g(^PHCC(PhcCatId,Sub,"MIN",Chl)),"^",2)
	...s ret=..SaveCat(ParCat2,CatCode3,CatDesc3)
	...s phcnum3=phcnum3+1
    ...

	q "药学大类:"_phcnum1_"个;"_"药学子类:"_phcnum2_"个;"_"药学小类:"_phcnum3_"个"
}

ClassMethod SaveCat(ParCat, CatCode, CatDesc) As %String
{
	q:ParCat="" -1
	q:CatCode="" -1
	q:CatDesc="" -1
	//s locid=$G(%session.Data("LOGON.CTLOCID"))
	s hospid=""
	i ParCat'=0 d
	.s parlevel=$p(^DHCPHCC(ParCat),"^",4)
	.s level=parlevel+1
	e  d
	.s level=1
	&sql(insert into dhc_phccat(PHCC_Code,PHCC_Desc,PHCC_ParCat_Dr,PHCC_Level,PHCC_Hosp_Dr) values(:CatCode,:CatDesc,:ParCat,:level,:hospid))
	s rowid=$p(%ROWID,$c(1))
	s ruleid=$o(^DHCSSPCS(0,"LEVEL",+hospid,level,""))
	i ruleid'="" d
	.&sql(update DHC_StkSysPHCCodeSet set PCS_CurNo=:CatCode where PCS_RowId=:ruleid)
	q rowid
}

//w ##class(web.DHCSTIMPITMLOCDETAIL).ImportInciPhcdToPhcdAll()

//将药品维护了三级药学分类的数据导入到多级药学分类中

ClassMethod ImportInciPhcdToPhcdAll()
{
	
	s Code=""
	s cnt=0
	f  s Code=$o(^INCI(0,"Code1",Code)) q:Code=""  d
	.s InciId=""
	.f  s InciId=$o(^INCI(0,"Code1",Code,InciId)) q:InciId=""  d
	..s InciDesc=$p(^INCI(InciId,1),"^",2)
	..s PhcCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetPhcCat(InciId)
	..s PhcCatDesc=$p(PhcCatInfo,"^",1)
	..s PhcCatId=$p(PhcCatInfo,"^",2)
	..s PhcCatCode=""
	..i PhcCatId'="" s PhcCatCode=$p(^PHCC(PhcCatId),"^",1)
	..s PhcSubCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetPhcSubCat(InciId)
	..s PhcSubCatDesc=$p(PhcSubCatInfo,"^",1)
	..s PhcSubCatDr=$p(PhcSubCatInfo,"^",2)
	..s PhcSubCatCode=""
	..i PhcSubCatDr'="" s PhcSubCatCode=$p($g(^PHCC(+PhcSubCatDr,"SC",$p(PhcSubCatDr,"||",2))),"^",1)
	..s PhcMinCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetPhcMinCat(InciId)
	..s PhcMinCatDesc=$p(PhcMinCatInfo,"^",1)
	..s PhcMinCatDr=$p(PhcMinCatInfo,"^",2)
	..s Hos=$o(^DHCPHCC(0,"CODE",""),-1)
	..s PhcMinCatCode=""
	..i PhcMinCatDr'="" s PhcMinCatCode=$p($g(^PHCC(+PhcMinCatDr,"SC",$p(PhcMinCatDr,"||",2),"MIN",$p(PhcMinCatDr,"||",3))),"^",1)
	..s DhcPhcDr=""
	..i PhcMinCatCode'="" d
	...s DhcPhcDr=$o(^DHCPHCC(0,"CODE",Hos,PhcMinCatCode,""))
	..e  i PhcSubCatCode'="" d
	...s DhcPhcDr=$o(^DHCPHCC(0,"CODE",Hos,PhcSubCatCode,""))
	..e  i PhcCatCode'=""  d
	...s DhcPhcDr=$o(^DHCPHCC(0,"CODE",Hos,PhcCatCode,""))
	..i DhcPhcDr'="" d
	...s:InciId'="" ArcRowid=$p(^INCI(InciId,1),"^",3)
	...s Sub=+ArcRowid
	...s Ver=$p(ArcRowid,"||",2)	
	...s:(Sub'="")&(Ver'="") PhcdfRowid=$p(^ARCIM(Sub,Ver,1),"^",12)
    ...i PhcdfRowid'=""  d
 	....s PhcdRowid=+PhcdfRowid
 	....&sql(Update  PHC_DrgFormExt set PHCDF_PHCC_Dr=:DhcPhcDr where PHCDF_PHCD_ParRef=:PhcdRowid)
 	....s cnt=cnt+1
 	....
 	
	q cnt
}

//w ##class(web.DHCSTIMPITMLOCDETAIL).killPhdInsucat()

//清空药品的医保类别 s OfficeCode=$p($g(^PHCD(Phcd,4)),"^",2)		;医保类别

ClassMethod killPhdInsucat()
{
	
	s Code=""
	s cnt=0
	f  s Code=$o(^INCI(0,"Code1",Code)) q:Code=""  d
	.s InciId=""
	.f  s InciId=$o(^INCI(0,"Code1",Code,InciId)) q:InciId=""  d
	..s InciDesc=$p(^INCI(InciId,1),"^",2)
	..s PhcCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetPhcCat(InciId)
	..s PhcCatDesc=$p(PhcCatInfo,"^",1)
	..s PhcCatId=$p(PhcCatInfo,"^",2)
	..s PhcCatCode=""
	..i PhcCatId'="" d
	...s $p(^PHCD(PhcCatId,4),"^",2)=""
	...s cnt=cnt+1
	q cnt
}

}
