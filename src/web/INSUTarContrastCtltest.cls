Import SQLUser

/// 医保目录对照操作
Class web.INSUTarContrastCtltest Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 168;

/// ************************************************************
/// 导入对照关系
/// ************************************************************
ClassMethod UpLoadCon(FileName As %String, Type As %String)
{
	
	;s $zt="close^"_$zn
	k ^CACHETEMP1($zn)	
	s ^CACHETEMP1($zn,$j)=0
	s ustr=""
	w "File Upload Starting...",!
	w !,"$zn="_$zn
	o FileName:"RS":1
	u FileName
	f  d     ;q:$ZEOF=-1
	. r sRec
	. s sRec=$tr(sRec,$c(9),"^")
	. s ustr=ustr_$c(13)_$c(10)_sRec
	. s cont=..BuildCont(sRec,Type)
	. i cont'=0 d
	. .s index=$g(^CACHETEMP1($zn,$j))
	. .s ^CACHETEMP1($zn,$j,index)=sRec_"---"_cont
	. .s ^CACHETEMP1($zn,$j)=index+1
	. ;s ustr=ustr_$c(13)_$c(10)_sRec_"^"_$ZEOF  
    c FileName
    w !,ustr,!!
	w "File Upload Finished!",!!
	q
}

ClassMethod test()
{
	
    c FileName
    w !,ustr,!!
	w "File Upload Finished!",!!
	q
}

ClassMethod BuildCont(InString As %String, Type As %String)
{
	n (InString,Type)
	s ArcimCode=$p(InString,"^",1)
	s InsuCode=$p(InString,"^",2)
	s TarId=..GetTarId(ArcimCode)
	q:TarId=100 -100
	s InsuDr=..GetInsu(InsuCode,Type)
	q:InsuDr="" -101
	s flag=##class(web.INSUTarContrastCtl).SaveCont("",TarId,InsuDr,"1",Type,"")
	q flag
}

/// ;按照代码查询
ClassMethod GetInsu(sKeyWord As %String, Type As %String)
{
	n (sKeyWord,Type)
	s InsuDr=""
    ;&js<alert("222")>
	s sKeyWord=$ZCVT(sKeyWord,"U")
	s id=""
	f  s id=$O(^DHCINTIM("0","CODE",sKeyWord,id))  q:id=""  d
	.s s=$g(^DHCINTIM(id))
	.q:Type'=$p(s,"^",2)
    .s InsuDr=id
    q InsuDr
}

ClassMethod GetArcim(ArcimCode As %String)
{
	n (ArcimCode)
	s ArcimCode=$ZCVT(ArcimCode,"U")
	q:$d(^ARCIM(0,"Code",ArcimCode))=0 100
	s Subscript=""
	s Subscript=$O(^ARCIM(0,"Code",ArcimCode,Subscript))
	s arcim=Subscript_"||1"
	;^ARCIM(0,"Code",$$ALPHAUP({ARCIM_Code}),{ARCIM_Subscript},{ARCIM_Version})
	q arcim
}

ClassMethod GetTarId(ArcimCode As %String)
{
	n (ArcimCode)
	s tarid=100
	s arcim=..GetArcim(ArcimCode)
	q:$d(^DHCOLT(0,"ARCIM",arcim))=0 100
	s sub1=""
	f  s sub1=$o(^DHCOLT(0,"ARCIM",arcim,sub1)) q:sub1=""  d
	.s sub2=""
	.f  s sub2=$o(^DHCOLT(0,"ARCIM",arcim,sub1,sub2),-1) q:sub2=""  d
	..q:sub2>+$h
	..s OLTRowId=""
	..f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcim,sub1,sub2,OLTRowId)) q:OLTRowId=""  d
	...s s=$g(^DHCOLT(OLTRowId))
	...s tarid=$p(s,"^",2)
	;^DHCOLT(0,"ARCIM",{OLT_ARCIM_DR},{OLT_Inst_DR}_"Z",{OLT_StartDate},{OLT_RowId})
	q tarid
}

}
