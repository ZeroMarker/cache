Import SQLUser

Class web.INSUTarContrastCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 137;

/// **********************************************
/// 按照HIS项目查询对照情况
/// 入参说明
/// /// 关键字：sKeyWord
/// /// 关键字类型：Class （拼音码、代码、名称） 
/// /// 目录类型：Type （韶关医保、广铁医保） 
/// /// 查询类型：ConType （已对照-Y、未对照-N、所有-A）
/// /// 帐单大类：TarCate  add by wuqk 2005-07-27
/// Write by wuqk 2005-05-10
/// ************************************************
ClassMethod QueryAll(sKeyWord As %String, Class As %String, Type As %String, ConType As %String, TarCate As %String)
{
	;k ^CACHETEMP("TAR",$j)
	;s ^CACHETEMP("TAR",$j)=0
	k ^CacheTemp("TAR",$j)
	s ^CacheTemp("TAR",$j)=0
	s HisCount=""
	;&js<alert(sKeyWord+"  "+Class)>
	s HisCount=..QueryHisTar(sKeyWord,Class,TarCate)
	s flag=..CheckOption(Type,ConType)
	;f i=0:1:HisCount d
	;.s flag=..CheckInsu(i,Type,ConType)
	s HisCount=$g(^CacheTemp("TAR",$j))
	q $j
}

/// 查询HIS收费项目
ClassMethod QueryHisTar(sKeyWord As %String, Class As %String, TarCate As %String)
{
	n (sKeyWord,Class,TarCate)
	i sKeyWord="" d
	.s TCount=..QueryEvery(TarCate)
	e  i Class="1" d
	.s TCount=..QueryAlias(sKeyWord,TarCate)
	e  i Class="2" d
	.s TCount=..QueryCode(sKeyWord,TarCate)
	e  i Class="3" d
	.s TCount=..QueryDesc(sKeyWord,TarCate)
    e  d
    .s TCount=-1
    q TCount
}

/// 查询所有
ClassMethod QueryEvery(TarCate As %String)
{
	s Tarid=0
	f  s Tarid=$o(^DHCTARI(Tarid)) q:Tarid=""  d
	.s s=$g(^DHCTARI(+Tarid))
	.s xCode=$p(s,"^",1)
	.s tSubcate=$p(s,"^",4)
	.quit:(tSubcate="")
	.s tCate=$p($g(^DHCTarC("SC",tSubcate)),"^",3)
	.q:(TarCate'="")&(TarCate'=tCate)
	.i $d(^CacheTemp("TAR",$j,xCode))=0 d
	..s ^CacheTemp("TAR",$j,xCode)=Tarid
	..s ^CacheTemp("TAR",$j)=$g(^CacheTemp("TAR",$j))+1
	q 0
}

/// 按照别名查询HIS收费项目
ClassMethod QueryAlias(sKeyWord As %String, TarCate As %String)
{
	n (sKeyWord,TarCate)
	s sKeyWord=$ZCVT(sKeyWord,"U")
	s err=..SelectAlias(sKeyWord,TarCate)
	s Desc=sKeyWord
	f  s Desc=$o(^DHCTARAL("A",0,"Desc",Desc)) q:(Desc="")!(Desc'[sKeyWord)  d
	.s err=..SelectAlias(Desc,TarCate)
	q 0
}

/// 按别名查询
ClassMethod SelectAlias(Desc As %String, TarCate As %String)
{
	n (Desc,TarCate)
	s Tarid="0"
	f  s Tarid=$o(^DHCTARAL("A",0,"Desc",Desc,Tarid)) q:Tarid=""  d
	.s s=$g(^DHCTARI(+Tarid))
	.;w !,Tarid_"   "_s
	.s xCode=$p(s,"^",1)
	.s tSubcate=$p(s,"^",4)
	.quit:(tSubcate="")
	.s tCate=$p($g(^DHCTarC("SC",tSubcate)),"^",3)
	.q:(TarCate'="")&(TarCate'=tCate)
	.i $d(^CacheTemp("TAR",$j,xCode))=0 d
	..s ^CacheTemp("TAR",$j,xCode)=Tarid
	..s ^CacheTemp("TAR",$j)=$g(^CacheTemp("TAR",$j))+1
	q 0
}

/// 按照代码查询HIS收费项目
ClassMethod QueryCode(sKeyWord As %String, TarCate As %String)
{
	;^DHCTARI(0,"Code",{TARI_Code},{TARI_RowId})
	n (sKeyWord,TarCate)
	;s sKeyWord=$ZCVT(sKeyWord,"U")
	;s Tarid=""
	;w !,sKeyWord
	;&sql(DECLARE scode CURSOR FOR 
	;     select INTIM_Rowid into :Tarid 
	;     from insu_taritems where intim_xmbm like :sKeyWord)
	;&SQL(OPEN scode)	
	;For  &SQL(FETCH scode) Quit:SQLCODE  Do
	;.s s=$g(^DHCTARI(+Tarid))
	;.w !,Tarid
	;.s xCode=$p(s,"^",1)
	;.s tSubcate=$p(s,"^",4)
	;.quit:(tSubcate="")
	;.s tCate=$p($g(^DHCTarC("SC",tSubcate)),"^",3)
	;.q:(TarCate'="")&(TarCate'=tCate)
	;.i $d(^CACHETEMP("TAR",$j,xCode))=0 d
	;..s ^CACHETEMP("TAR",$j,xCode)=Tarid
	;..s ^CACHETEMP("TAR",$j)=$g(^CACHETEMP("TAR",$j))+1	
	;&SQL(CLOSE scode)
	
	s Tarid="0"
	f  s Tarid=$o(^DHCTARI(0,"Code",sKeyWord,Tarid)) q:Tarid=""  d
	.s s=$g(^DHCTARI(+Tarid))
	.s xCode=$p(s,"^",1)
	.s tSubcate=$p(s,"^",4)
	.quit:(tSubcate="")
	.s tCate=$p($g(^DHCTarC("SC",tSubcate)),"^",3)
	.q:(TarCate'="")&(TarCate'=tCate)
	.i $d(^CacheTemp("TAR",$j,xCode))=0 d
	..s ^CacheTemp("TAR",$j,xCode)=Tarid
	..s ^CacheTemp("TAR",$j)=$g(^CacheTemp("TAR",$j))+1
	q 0
}

/// 按照名称查询HIS收费项目
ClassMethod QueryDesc(sKeyWord As %String, TarCate As %String)
{
	
	n (sKeyWord,TarCate)
	;^DHCTARI(0,"Desc",{TARI_Desc},{TARI_RowId})	
	s err=..SelectDesc(sKeyWord,TarCate)
	s Desc=sKeyWord
	f  s Desc=$o(^DHCTARI(0,"Desc",Desc)) q:(Desc="")!(Desc'[sKeyWord)  d
	.s err=..SelectDesc(Desc,TarCate)
	q 0
}

/// 按照名称查询
ClassMethod SelectDesc(Desc As %String, TarCate As %String)
{
	n (Desc,TarCate)
	s Tarid="0"
	f  s Tarid=$o(^DHCTARI(0,"Desc",Desc,Tarid)) q:Tarid=""  d
	.s s=$g(^DHCTARI(+Tarid))
	.s xCode=$p(s,"^",1)
	.s tSubcate=$p(s,"^",4)
	.quit:(tSubcate="")
	.s tCate=$p($g(^DHCTarC("SC",tSubcate)),"^",3)
	.q:(TarCate'="")&(TarCate'=tCate)
	.i $d(^CacheTemp("TAR",$j,xCode))=0 d
	..s ^CacheTemp("TAR",$j,xCode)=Tarid
	..s ^CacheTemp("TAR",$j)=$g(^CacheTemp("TAR",$j))+1
	q 0
}

/// 检查是否满足查询条件
ClassMethod CheckOption(Type As %String, ConType As %String)
{
	n (Type,ConType)
	s xCode=""
	f  s xCode=$o(^CacheTemp("TAR",$j,xCode)) q:xCode=""  d
	.s Tarid=$g(^CacheTemp("TAR",$j,xCode))
	.;
	.;删除无对照关系的记录 
	.i ($d(^DHCINTCT("0","DHCTID",Tarid))=0)&(ConType="Y") d
	..k ^CacheTemp("TAR",$j,xCode)
	.q:($d(^DHCINTCT("0","DHCTID",Tarid))=0)&(ConType="Y")
	.;
	.;删除有对照关系的记录
	.i ($d(^DHCINTCT("0","DHCTID",Tarid))'=0)&(ConType="N") d
	..k ^CacheTemp("TAR",$j,xCode)
	.q:($d(^DHCINTCT("0","DHCTID",Tarid))'=0)&(ConType="N")
	.s ConFlag=""
	.i ($d(^DHCINTCT("0","DHCTID",Tarid))'=0) d
	..s ConFlag=..CheckCon(Tarid,Type)
	.;
	.;删除无本类对照关系的记录
	.i (ConFlag="")&(ConType="Y") d
	..k ^CacheTemp("TAR",$j,xCode)
	.q:(ConFlag="")&(ConType="Y")
	.
	.s sTar=$g(^DHCTARI(+Tarid))
	.s TarCode=$p(sTar,"^",1)
	.s TarDesc=$p(sTar,"^",2)
	.;k ^CACHETEMP("TAR",$j,xCode)
	.s ^CacheTemp("TAR",$j,xCode)=Tarid_"^"_TarCode_"^"_TarDesc_"^"_ConFlag
	q 0
}

/// 检查是否存在对照关系
ClassMethod CheckCon(DHCTarid As %String, Type As %String)
{
	n (DHCTarid,Type)
	s TarConid="0",ConStr=""
	f  s TarConid=$o(^DHCINTCT("0","DHCTID",DHCTarid,TarConid)) q:TarConid=""  d
	.s sCon=$g(^DHCINTCT(TarConid))
	.q:Type'=$p(sCon,"^",12)              ;非本目录类别
	.s ConStr=ConStr_"!"_TarConid
	q ConStr
}

/// 取查询出的收费项目
ClassMethod GetTar(xCode As %String, JString As %Integer)
{
	;n (xCode)
	;s outString=""
	;s xCode=$o(^CACHETEMP("TAR",$j,xCode))
	;s:xCode'="" outString=$g(^CACHETEMP("TAR",$j,xCode))
	;q outString_"!"_$j
	;
	;
	n (xCode,JString)
	s outString=""
	s xCode=$o(^CacheTemp("TAR",JString,xCode))
	s:xCode'="" outString=$g(^CacheTemp("TAR",JString,xCode))
	q outString
}

/// 取收费项目明细
ClassMethod GetTarDetail(TarId As %String)
{
     n (TarId)
     s tUomDesc="",tCate="",tCateDesc="",tSubcateDesc=""
     s s=$g(^DHCTARI(+TarId))
     s tCode=$p(s,"^",1)
     s tDesc=$p(s,"^",2)
	 s tUom=$p(s,"^",3)
	 s tSubcate=$p(s,"^",4)
	 s:tUom'="" tUomDesc=$p($g(^CT("UOM",tUom)),"^",2)
	 s:tSubcate'="" tSubcateDesc=$p($g(^DHCTarC("SC",tSubcate)),"^",2)
	 s:tSubcate'="" tCate=$p($g(^DHCTarC("SC",tSubcate)),"^",3)
	 s:tCate'="" tCateDesc=$p($g(^DHCTarC("CC",tCate)),"^",2)
	 ;s sPrive=$$GetItmPrice^DHCPRICE(Tarid,$h,"","","")
	 s tPrice=""
	 s OutStr=TarId_"^"_tCode_"^"_tDesc_"^"_tUomDesc_"^"_tCateDesc_"^"_tSubcateDesc_"^"_tPrice
	 q OutStr
}

/// 取对照明细
ClassMethod GetContDetail(ContId As %String)
{
	n (ContId)
	s obj=##class(User.INSUTarContrast).%OpenId(ContId)
    s HisDr=obj.INTCTHisDr     
    ;s HisCode=obj.INTCTHisCode   
    ;s HisDesc=obj.INTCTHisDesc   
    s InsuDr=obj.INTCTInsuDr    
    ;s InsuCode=obj.INTCTInsuCode  
    ;s InsuDesc=obj.INTCTInsuDesc  
    s Class=obj.INTCTClass     
    s Level=obj.INTCTLevel     
    s PatTypeDr=obj.INTCTPatTypeDr 
    s Amount=obj.INTCTAmount    
    s DrAddFlag=obj.INTCTDrAddFlag 
    s DicType=obj.INTCTDicType   
    d obj.%Close()
    ;s insuOBJ=##class(User.INSUTarItems).%OpenId(InsuDr)
    
    s OutStr=HisDr_"^"_InsuDr_"^"_Class_"^"_Level_"^"_PatTypeDr_"^"_Amount_"^"_DrAddFlag_"^"_DicType
    q OutStr
}

/// 保存对照关系
ClassMethod SaveCont(ContId As %String, HisId As %String, InsuId As %String, Qty As %String, Type As %String, ElsString As %String)
{
	;n (ContId, HisId, InsuId, Qty, Type,ElsString)
	s:ElsString="" ElsString="^^^^^^^^^^^^^^^^^^^^^"
    i ContId="" d
    .s TarConid="0",Flag=""
    .f  s TarConid=$o(^DHCINTCT("0","DHCTID",HisId,TarConid)) q:(TarConid="")!(Flag="1")  d
	..s sCon=$g(^DHCINTCT(TarConid))
	..q:Type'=$p(sCon,"^",12)              ;非本目录类别
    ..;q:InsuId'=$p(sCon,"^",4)
    ..s Flag="1"
    ..s obj=##class(User.INSUTarContrast).%OpenId(TarConid)
    .s:Flag="" obj=##class(User.INSUTarContrast).%New()
    e  d
    .s obj=##class(User.INSUTarContrast).%OpenId(ContId)
    .i obj.INTCTHisDr'=HisId d
    ..d obj.%Close()
    ..s obj=##class(User.INSUTarContrast).%New()
    s obj.INTCTHisDr=HisId
    s obj.INTCTHisCode=$p(ElsString,"^",1)
    s obj.INTCTHisDesc=$p(ElsString,"^",2)
    s obj.INTCTInsuDr=InsuId
    s obj.INTCTInsuCode=$p(ElsString,"^",3)
    s obj.INTCTInsuDesc=$p(ElsString,"^",4)
    s obj.INTCTClass=$p(ElsString,"^",5)
    s obj.INTCTLevel=$p(ElsString,"^",6)
    s obj.INTCTPatTypeDr=$p(ElsString,"^",7)
    s obj.INTCTAmount=+Qty
    s obj.INTCTDrAddFlag=$p(ElsString,"^",8)
    s obj.INTCTDicType=Type
    d obj.%Save()
    d obj.%Close()
    q 0
}

/// 删除对照关系
ClassMethod DeleteCont(ContId As %String)
{
	    q:$zd(^DHCINTCT(ContId))=0 100
	    s ContId=+ContId
	    &sql(Delete from INSU_TarContrast where INTCT_Rowid=:ContId)
	    q SQLCODE
}

ClassMethod Query(sKeyWord As %String, Class As %String, Type As %String, ConType As %String)
{
	k ^CacheTemp("TAR")
	s ^CacheTemp("TAR",$j)=0
	s HisCount=""	
	s HisCount=..QueryHisTar(sKeyWord,Class,"")		
	s flag=..TartoDir(Type)	
	s HisCount=$g(^CacheTemp("TAR",$j))
	s s=..CheckFilter(ConType)
	q $j
}

/// 项目与有对照关系的医保项目链接CZQ
ClassMethod TartoDir(Type As %String)
{
	s xCode=""
	s INsu=""
	f  s xCode=$o(^CacheTemp("TAR",$j,xCode)) q:xCode=""  d
	  .s Tarid=$g(^CacheTemp("TAR",$j,xCode))	  
	  .s sTar=$g(^DHCTARI(+Tarid))
	  .s TarCode=$p(sTar,"^",1)
	  .s TarDesc=$p(sTar,"^",2)
	  .s ^CacheTemp("TAR",$j,xCode)=Tarid_"^"_TarCode_"^"_TarDesc	  
	  .s INsu=..Check(Tarid,Type)	 
	  .s ^CacheTemp("TAR",$j,xCode)=^CacheTemp("TAR",$j,xCode)_"^"_INsu	   	  	  
	q 0
}

/// 根据类型连接或处理CACHETEMP的数据CZQ
ClassMethod Check(DHCTarid As %String, Type As %String)
{
	;n (DHCTarid,Type)	
	s TarConid="0",ConStr="",Insustring="",Taritid=""
	s return=""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""		
	f  s TarConid=$o(^DHCINTCT("0","DHCTID",DHCTarid,TarConid)) q:TarConid=""  d
	  .s Tarconstring=$g(^DHCINTCT(TarConid))	
	  .q:Type'=$p(Tarconstring,"^",12)	
	  .s Taritid=$p(Tarconstring,"^",4)
	  .s Insustring=$g(^DHCINTIM(Taritid))
	  .s Insubm=$p(Insustring,"^",3)	
	  .s Insumc=$p(Insustring,"^",4)
	  .s Insujx=$p(Insustring,"^",8)
	  .s Insugg=$p(Insustring,"^",9)
	  .s Insudw=$p(Insustring,"^",10)	
	  .s return=Insubm_"^"_Insumc_"^"_Insujx_"^"_Insugg_"^"_Insudw_"^"_TarConid	
	  .;s return=Insubm_"^"_Insumc_"^"_Insujx_"^"_Insugg_"^"_Insudw_"^"_Taritid	
	q return
}

/// 检查是否满足查询条件CZQ
ClassMethod CheckFilter(ConType As %String)
{
	n (ConType)
	s xCode=""
	f  s xCode=$o(^CacheTemp("TAR",$j,xCode)) q:xCode=""  d
	  .s TempString=$g(^CacheTemp("TAR",$j,xCode))
	  .s Tarid=$piece(TempString,"^",9)	
	  .;删除已对照关系的记录	
	  .i (ConType="N")&(Tarid'="") d
	  ..k ^CacheTemp("TAR",$j,xCode)
	  .;删除未对照关系的记录
	  .i (ConType="Y")&(Tarid="")  d
	  ..k ^CacheTemp("TAR",$j,xCode)	
    q 0
}

///  得到his名称
ClassMethod GetHisdec(Hiscode As %String)
{
   	s HisDesc=""
   	&js<alert("#(Hiscode)#")>
   ;	write Hiscode,!
	&sql(Select TARI_Desc into :HisDesc from DHC_TarItem where TARI_Code=:Hiscode)	
		&js<alert("#(HisDesc)#")>
	q HisDesc
}

ClassMethod CheckInCont(Instring As %String) As %String
{
	q:Instring="" 1
	s hiscode=$p(Instring,"^",2)
	s insucode=$p(Instring,"^",4)
	s type="NBB"
	q:hiscode="" 101
	q:insucode="" 102
	q:$d(^DHCTARI(0,"Code",hiscode))=0 -101
	;s Insuid=""
	;s Tarid=hiscode
	;q:$O(^DHCINTIM("0","CODE",insucode))=0 -102
	s Tarid=""
	s Tarid=$o(^DHCTARI(0,"Code",hiscode,Tarid))
	s Insuid=""
	;s Insuid=$O(^DHCINTIM("0","CODE",insucode,Insuid))
	;&sql(select intim_rowid into :Insuid from insu_taritems where intim_xmbm=:insucode)
	s Insuid=..Test(insucode)
	w Insuid,!
	;q:SQLCODE -103
	q:Insuid="" -103
	s flag=..SaveCont("",Tarid,Insuid,"1",type,"")
	q flag
	
	;q:Instring="" -1
	;s hiscode=$p(Instring,"^",1)
	;s insucode=$p(Instring,"^",2)
	;s type="DT"
	;q:hiscode="" -101
	;q:insucode="" -102
	;q:$d(^DHCTARI(0,"Code",hiscode))=0 101
	;q:$O(^DHCINTIM("0","CODE",insucode))=0 102
	;s Tarid=""
	;s Tarid=$o(^DHCTARI(0,"Code",hiscode,Tarid))
	;s Insuid=""
	;s Insuid=$O(^DHCINTIM("0","CODE",insucode,Insuid))
	;s flag=..SaveCont("",Tarid,Insuid,"1",type,"")
	;q flag
}

ClassMethod CheckOutUnCont(Jid, Pid)
{
	s Pid=$o(^CacheTemp(Jid,Pid))
	s s=$g(^CacheTemp(Jid,Pid))
	s iCount=$l(s,",")
	s TmpStr=Pid
	f i=1:1:12 d
	.s TmpStr=TmpStr_"!"_$List(s,i)
	q TmpStr
}

/// /d ##class(web.INSUTarContrastCtl).DownLoad("HF","A","")
ClassMethod DownLoad(Type, ConType, file)
{
	
	s sKeyWord="",Class="1",TarCate=""
	s file="e:\tools\tmp\insutar.txt"
	w "Begin Query......."
	s flag=##class(web.INSUTarContrastCtl).QueryAll(sKeyWord,Class,Type,ConType,TarCate)
	w !,"Writing......."
	o file:("NRW"):5
	;o file:"RS"
	u file
	s xcode=""
	f  s xcode=$o(^CacheTemp("TAR",flag,xcode)) q:xcode=""  d
	.s s=$g(^CacheTemp("TAR",flag,xcode))
	.s TarId=$p(s,"^",1)
	.s HisCode=$p(s,"^",2)
	.s HisDesc=$p(s,"^",3)
	.s ConIdString=$p(s,"^",4) 
	.s TarString=##class(web.INSUTarContrastCtl).GetTarDetail(TarId)
	.s DW=$p(TarString,"^",4), Cate=$p(TarString,"^",5) , SubCate=$p(TarString,"^",6) , Price=$p(TarString,"^",7)
	.s ConCount=$l(ConIdString,"!")
	.s ConId="", InsuId="", InsuCode="", InsuDesc="", ConQty="", InsuGG="", InsuDW="", InsuSeltPer="", InsuCate="", InsuClass=""
	.i ConCount<=1  d
	..;s ConId="", InsuId="", InsuCode="", InsuDesc="", ConQty="", InsuGG="", InsuDW="", InsuSeltPer="", InsuCate="", InsuClass=""
	..d Build
	.e  d
	..f ConIndex=2:1:ConCount d
	...s ConId=$p(ConIdString,"!",ConIndex)
	...;s ^AAA(HisCode)=ConIndex_"------"_ConIdString_"------"_ConId
	...s ConString=##class(web.INSUTarContrastCtl).GetContDetail(ConId)
	...s InsuId=$p(ConString,"^",2)
	...s ConQty=$p(ConString,"^",6)
	...i InsuId'="" d
	....s InsuString=##class(web.INSUTarItemsCtl).GetInsuDetail(InsuId)
	....s InsuCode=$p(InsuString,"^",3)
	....s InsuDesc=$p(InsuString,"^",4)
	....s InsuGG=$p(InsuString,"^",9)
	....s InsuDW=$p(InsuString,"^",10)
	....s InsuSeltPer=$p(InsuString,"^",18)
	....s InsuCate=$p(InsuString,"^",1)
	....s InsuCate=##class(web.INSUFPCtl).QueryByCode(InsuCate)
	....s InsuClass=$p(InsuString,"^",23)
	...d Build
	;Set qHandle=$lb(0,repid,0)
	k ^CacheTemp("TAR",flag)
	c file
	w !,"Over!"
	Quit ;$$$OK
Build  
    s str=HisCode_"^"_HisDesc_"^"_DW_"^"_SubCate_"^"_InsuCode_"^"_InsuDesc
	w str,!
	;set Data=$lb(TarId,HisCode,HisDesc,DW,Cate,SubCate,Price,ConId,InsuId,InsuCode,InsuDesc,ConQty,InsuGG,InsuDW,InsuSeltPer,InsuCate,InsuClass)
 	;Set ^CacheTemp(repid,ind)=Data
 	;Set ind=ind+1
}

ClassMethod Test(insucode As %String) As %String
{
	&sql(select intim_rowid into :Insuid from insu_taritems where intim_xmbm=:insucode)
    s Test=Insuid
    q Test
}

}
