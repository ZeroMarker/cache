/// web.DHCNURPDAQUEXCUTE
Class web.DHCDocPDAJYRESULT Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 200;

ClassMethod GetLabNoExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
 	if Adm="" Quit $$$OK

    s Oew=0 f  s Oew=$o(^OEORD(0,"Adm",Adm,Oew)) q:Oew=""  d
	.s OrdSub=""  f  s OrdSub=$O(^OEORD(Oew,"I",OrdSub),-1)  q:(OrdSub="")||(OrdSub=0)  d
	..s OrdDate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",7)  ;取得医嘱表医嘱日期?
	..s OrdTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",17)
	..s StDate=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9)  ;要求执行日期?
	..s StTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10)
	..s StDateTime=$E($ZD(StDate,3),6,10)_" "_$ZT(StTime,2)
	..s OrdStatusDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)
	..s dispstat=""
	..s OrdStat=$P(^OEC("OSTAT",OrdStatusDR),"^",2)
	..q:OrdStat="停止"
	..s LabEpisodeNo=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",20)
	..q:LabEpisodeNo=""
	..s ArcimDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
    ..s testcode=..GetExCode(ArcimDR)
    ..q:testcode=""
    ..//w !,testcode,"-",LabEpisodeNo
	..s labstat=..IflabnoVer(LabEpisodeNo,testcode)
	..//s labstat="df^d^d"
	..s LabCpt=$P(labstat,"^",1)
	..s LabDate=$E($P(labstat,"^",2),6,10)
	..s LabTime=$P(labstat,"^",3)
    ..s ARCIMRowid=$P(ArcimDR,"||",1)
	..s ARCIMSub=$P(ArcimDR,"||",2)  
	..s ARCIMDes=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)  ;ord name
	..s RowId=Oew_"||"_OrdSub
	..i $G(LabNo(ARCIMDes,testcode))="" s LabNo(ARCIMDes,testcode)=LabEpisodeNo
	..e  s LabNo(ARCIMDes,testcode)=LabNo(ARCIMDes,testcode)_"||"_LabEpisodeNo
	..s TEM(ARCIMDes,testcode)=$lb(ARCIMDes,LabNo(ARCIMDes,testcode),StDateTime,RowId,testcode,LabCpt,LabDate,LabTime)
	..//s TEM(testcode,OrdSub)=$lb(ARCIMDes,LabEpisodeNo,StDateTime,RowId,testcode,LabCpt,LabDate,LabTime)
	..
	//s code=""  f  s code=$O(TEM(code)) q:code=""  d
	//.s sub=""  f  s sub=$O(TEM(code,sub)) q:sub=""  d
	//..s a=TEM(code,sub)
	//..d OutPut
	s arcimDesc=""  f  s arcimDesc=$O(TEM(arcimDesc)) q:arcimDesc=""  d
	.s testCode="" f  s testCode=$O(TEM(arcimDesc,testCode)) q:testCode=""  d
	..s a=TEM(arcimDesc,testCode)
	..d OutPut
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPut
	set Data=a //$lb(ARCIMDes,LabEpisodeNo,StDateTime,RowId,testcode,LabCpt,LabDate,LabTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetLabNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLabNoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetLabNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLabNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetLabNo(Adm As %String) As %Query(ROWSPEC = "ARCIMDes,LabEpisodeNo,StDateTime,RowId,testcode,LabCpt,LabDate,LabTime")
{
}

ClassMethod IflabnoVer(labno As %String = "", testc As %String = "") As %String
{
 ///检查是否核实
   n (labno,testc)
   q:testc="" ""
     s status=$P($g(^["LABDATA"]TEPI(labno,1,testc,1)),"\",31)
     if status'="A"  q ""
     s ^TMP(labno,testc)=""
     s author=$p(^["LABDATA"]TEPI(labno,1,testc,1),"\",3)
     i (author'="") {
	     if ($D(^["LABDATA"]SSU("SSUSR",1,author))){
	     s author=$p(^["LABDATA"]SSU("SSUSR",1,author),"^",2) 
	     }
	     else{
		       s author=""
	     }
     }
     else 
     { 
     s author=""
     }
     s Adate=$zd($p($G(^["LABDATA"]TEPI(labno,1,testc,1)),"\",1),3)
     s Atime=$zt($p($G(^["LABDATA"]TEPI(labno,1,testc,1)),"\",2)*60)
     s ret=author_"^"_Adate_"^"_Atime
     i $P(ret,"^",2)="" s ret=""
     q ret
}

ClassMethod GetTestSetDataExecute(ByRef qHandle As %Binary, labInfo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
 	if labInfo="" Quit $$$OK
 	s labnum=$P(labInfo,"^",1)
 	s testc=$P(labInfo,"^",2)
	    // s rw="",des="序号"
	     s ^TMP(labnum)=""
         s sex=$P($g(^["LABDATA"]TEPI(labnum)),"\",3)
         s age=$P($g(^["LABDATA"]TEPI(labnum)),"\",25)
         s i=0 
         s count="" f  s count=$O(^["LABDATA"]TEPI(labnum,1,testc,count)) q:count=""  d
         .//s author=$p(^["LABDATA"]TEPI(labnum,1,testc,count),"\",3)
         .//i author'="" s author=$p(^["LABDATA"]SSU("SSUSR",1,author),"^",2) 
         .//e  s author=""
         .//s Adate=$zd($p(^["LABDATA"]TEPI(labnum,1,testc,1),"\",1),3)
         .//s Atime=$zt($p(^["LABDATA"]TEPI(labnum,1,testc,1),"\",2)*60)
         .s code="" f  s code=$O(^["LABDATA"]TEPI(labnum,1,testc,count,"DATA",code)) q:code=""  d
         ..s intyp=$P(^["LABDATA"]TTAB("TC",code),"\",3)
         ..s itemname=$P(^["LABDATA"]TTAB("TC",code),"\",1)
         ..//i (code="A0111")!(code="A0112") s itemname=itemname_"."  ;镜检 尿红细胞，尿白细胞
         ..i intyp="S" d  ;standard comment------------------------------------------
         ...s data=$P(^["LABDATA"]TEPI(labnum,1,testc,count,"DATA",code),"\",1)
         ...s standcom=""
         ...f b1=1:1:$g(^["LABDATA"]TTAB("TC",code,2,data,0))  d
         ....s standcom=standcom_$g(^["LABDATA"]TTAB("TC",code,2,data,b1))
         ...s data=standcom
         ..i intyp="X" d  ;free text--------------------------------------------------
         ...//s cmm=""
         ...//f b1=1:1:$g(^["LABDATA"]TEPI(labnum,1,testc,count,"DATA",code,"REM",0)) d
         ...//.s cmm=cmm_$g(^["LABDATA"]TEPI(labnum,1,testc,count,"DATA",code,"REM",b1))
         ...//s data=cmm
         ...s data=$P(^["LABDATA"]TEPI(labnum,1,testc,count,"DATA",code),"\",1)
         ..i intyp["N" d  ;numeric---------------------------------------------------
         ...s data=$P(^["LABDATA"]TEPI(labnum,1,testc,count,"DATA",code),"\",1)
         ...s unit=$P(^["LABDATA"]TTAB("TC",code),"\",2)
         ...i unit["~" s unit="*"_unit
         ...s value=..standdata(code,sex,age)
         ...//w !,value
         ...//s data=data_"@"_unit_"@"_value
         ..i intyp="V" d  ;micro Pathogen ct_bugs ^TTAB("BUG",{CTBUG_Code})-----------
         ...s data=$P(^["LABDATA"]TEPI(labnum,1,testc,count,"DATA",code),"\",1)
         ...s ttres=$P($g(^["LABDATA"]TTAB("BUG",data)),"\",1)
         ...s ant=..gettestdata(labnum,testc,code,i)
         ...s ansum=$P(ant,"^")
         ...s antidesc=$P(ant,"^",2)
         ...i $G(ansum)'=0 s data=ttres_" "_antidesc
         ...e  s data=ttres
         ..i intyp="B2" d
         ...s data=$P(^["LABDATA"]TEPI(labnum,1,testc,count,"DATA",code),"\",1)
         ...i data'="" s data=$P(^["LABDATA"]TTAB("BB-BG",data),"\",1)
         ...s unit=$P(^["LABDATA"]TTAB("TC",code),"\",2)
         ...i unit["~" s unit="*"_unit
         ..s labstat=..IflabnoVer(labnum,testc)
         ..s LabDate=$E($P(labstat,"^",2),6,10)
         ..d OutPutData
         //..i '$D(result)  s result=itemname_"##"_data
         //..e  s result=result_"!!"_itemname_"##"_data
         //.s i=i+1
         //.s PLIST(i)=author_"**"_Adate_"**"_Atime_"**"_result

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutData
	set Data=$lb(itemname,data,$G(unit),$G(value),$G(LabDate))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetTestSetDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTestSetDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetTestSetDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTestSetDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetTestSetData(LabNum, TestC) As %Query(ROWSPEC = "itemname,data,unit,value,LabDate")
{
}

ClassMethod GetExCode(ArcimRowid As %String) As %String
{
	n (ArcimRowid)
	s arcsub=$p(ArcimRowid,"||",2)
	q:arcsub="" ""
	s ExCode=""
	s chl="" f  s chl=$o(^ARCIM(+ArcimRowid,arcsub,"EXT",chl)) q:chl=""  d
	.s tod=$p(^ARCIM(+ArcimRowid,arcsub,"EXT",chl),"^",2)
	.s fromd=$p(^ARCIM(+ArcimRowid,arcsub,"EXT",chl),"^",1)
	.q:(fromd'="")&(fromd>+$h)
	.q:(tod'="")&(tod<+$h)
	.s ExCode=$p(^ARCIM(+ArcimRowid,arcsub,"EXT",chl),"^",4)
	q ExCode
}

ClassMethod gettestdata(labno, testcode, itemcode, i)
{
	n (labno, testcode, itemcode, i)
	;EP_VisitTestSetDataAntibiotics ^TEPI({EP_VisitNumber.EPVIS_VisitNumber},1,{EP_VisitTestSet.VISTS_TestSet_DR},{EP_VisitTestSet.VISTS_TestSetCounter},"DATA",{EP_VisitTestSetData.VISTD_TestCode_DR},"ANT",{VISTA_Antibiotic_DR})
	s antidesc="",des="",sensi="" ; f  q:('$d(^["LABDATA"]TTAB("TS",testcode,0,zzz))) 
	s ans="",r=""  
	s ansum=0
	f  s des=$O(^["LABDATA"]TEPI(labno,1,testcode,i,"DATA",itemcode,"ANT",des))  q:des=""  d
	.s ansum=ansum+1 
	.s sensi=$P(^["LABDATA"]TEPI(labno,1,testcode,i,"DATA",itemcode,"ANT",des),"\",1)
	.s ans=$P(^["LABDATA"]TTAB("ANT",des),"\",1)
	.s r=$P(^["LABDATA"]TTAB("SENS",sensi),"\",1)
	.s antidesc=antidesc_" "_ans_"["_r_"]"
	q ansum_"^"_antidesc
}

ClassMethod standdata(itmcode, sex, age)
{
  ;求正常值 
  n (itmcode,sex,age)
  i sex="" s sex="M"
  s itmcode=$g(itmcode) 
  s value=""
  s tvalue=..ranges(itmcode,age,sex,"",0,"","")
  s lowvalue=$p(tvalue,$c(1),1)
  s hvalue=$p(tvalue,$c(1),2)
  i $tr(tvalue,$c(1))'="" d
  .s value="{"_lowvalue_"-"_hvalue_"}"
  .s value=$tr(value,$c(1))
  q value
}

ClassMethod ranges(tc, age, spec, pregn, ptype, date, cond)
{
 n (tc,age,spec,pregn,ptype,date,cond)
 n j,x,xf,age0,type,PLIST,exist,result
  s tc=$g(tc),age=$g(age),spec=$g(spec),pregn=$g(pregn),ptype=$g(ptype),date=$g(date),cond=$g(cond),result=""
  i '$l(date) s date=+$h
  i '$d(^["LABDATA"]TTAB("TC",tc,4,date)) s date=$o(^["LABDATA"]TTAB("TC",tc,4,date),-1)
  ;i '$l(age)  s age=0
  i $l(date) d
  .f type=ptype,$e(ptype) i $d(^["LABDATA"]TTAB("TC",tc,4,date,type)) d  q
  ..i $l(age) d
  ...k xf s x="" f  s x=$o(^["LABDATA"]TTAB("TC",tc,4,date,type,x)) q:x=""  d  q:$l(result)
  ....i $l($p(^(x),"\",23)),age<$p($p(^(x),"\",23),"-",1) q
  ....i $l($p(^(x),"\",23)),age>$p($p(^(x),"\",23),"-",2) q
  ....i $l($p(^(x),"\",22)),$p(^(x),"\",22)'=spec q
  ....i $l($p(^(x),"\",21)),$p(^(x),"\",21)'=cond q
  ....s xf=(''$l($p(^(x),"\",21)))+(''$l($p(^(x),"\",22)))+(''$l($p(^(x),"\",23))),xf(xf,x)=^(x)
  ..e  d
  ...s age=0
  ...k xf s x="" f  s x=$o(^["LABDATA"]TTAB("TC",tc,4,date,type,x)) q:x=""  d  q:$l(result)
  ....i $l($p(^(x),"\",22)),$l($p(^(x),"\",23)),$p(^(x),"\",22)=spec,$p($p(^(x),"\",23),"-",2)=age d
  .....s xf=(''$l($p(^(x),"\",21)))+(''$l($p(^(x),"\",22)))+(''$l($p(^(x),"\",23))),xf(xf,x)=^(x)
  ..s xf=$o(xf(""),-1) i $l(xf) s x=$o(xf(xf,"")) i $l(x) d
  ...s xx=$p(xf(xf,x),"\",1,8)_"\"_$p(xf(xf,x),"\",17,18)
  ...i pregn["Y" s xx=$p(xf(xf,x),"\",9,16)_"\"_$p(xf(xf,x),"\",19,20) d
  ....s exist="" f j=1:1:10 i $l($p(xx,"\",j)) s exist=1 q
  ....i 'exist s xx=$p(xf(xf,x),"\",1,8)_"\"_$p(xf(xf,x),"\",17,18)
  ...s result=$p(xx,"\",1)_$c(1)_$p(xx,"\",2)_$c(1)_$p(xx,"\",5)_$c(1)_$p(xx,"\",6)_$c(1)_$p(xx,"\",7)_$c(1)_$p(xx,"\",8)_$c(1)_$p(xx,"\",3)_$c(1)_$p(xx,"\",4)_$c(1)_$p(xx,"\",9)_$c(1)_$p(xx,"\",10)
  f j=1:1:$l(result,$c(1)) s x=$p(result,$c(1),j) i $e(x)="." s $p(result,$c(1),j)=0_x
  q result
}

//w ##Class(web.DHCDocPDAJYRESULT).GetLabItemdata("113734||118376||123985","F009")

ClassMethod GetLabItemdata(Labno As %String, testc As %String) As %String
{
	s QueryName="web.DHCDocPDAJYRESULT:GetTestSetData"
	Set rset = ##class(%ResultSet).%New(QueryName)
	Set columns = rset.GetColumnCount()
	k tem,colData
	s ret=""
	s QueryName=$TR(QueryName,":","&")
	//s ret=$P(QueryName,"&",2)_"&"
	s rows=0
	s len=$L(Labno,"||")
	f h=1:1:len
	{
		s no=$P(Labno,"||",h)
		q:no=""
		s sc = rset.Execute(no,testc)
		s i=1
		While (rset.Next()) {
			i (i=1){
				i (ret=""){
					f col = 1:1:columns {
            			s ret=ret_rset.GetColumnName(col)_"&"
					}
				}
			}
			s itemName=rset.GetData(1)
			s colData(itemName)=""
			For col = 1:1:columns {
				if col=2 
		        {
					s tem(itemName,col)=$G(tem(itemName,col))_rset.GetData(5)_"/"_rset.GetData(col)_$C(1)
					s colData(itemName)=$G(colData(itemName))_tem(itemName,col)_"^"  //rset.GetData(col)
			    }else
			    {
	            	s colData(itemName)=$G(colData(itemName))_rset.GetData(col)_"^"
				}
        	}
			s i=i+1
			if i>300  q  
		}
		Do rset.Close()
		
	}
	
	s itemName1=$O(colData(""))
	s itemName=""
	f  s itemName=$O(colData(itemName)) q:itemName=""  d
	.i $G(colData(itemName))'="" d
	..i itemName=itemName1 s ret=ret_"$"_$G(colData(itemName))_"&"
	..e  s ret=ret_$G(colData(itemName))_"&"

	i ret="" s ret="-1"
	e  s ret=$P(QueryName,"&",2)_"&"_ret
	q ret
}

Storage Default
{
<Data name="DHCDocPDAJYRESULTDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCDocPDAJYRESULTD</DataLocation>
<DefaultData>DHCDocPDAJYRESULTDefaultData</DefaultData>
<IdLocation>^web.DHCDocPDAJYRESULTD</IdLocation>
<IndexLocation>^web.DHCDocPDAJYRESULTI</IndexLocation>
<StreamLocation>^web.DHCDocPDAJYRESULTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
