Class dhc.ca.cache.udata.uGenLevelTmp Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

///  Creator：wang ying
///  CreatDate：2009-12-29
///  Description: 根据job,deptpar,count,lev生成排好序的带有层次关系的临时global
///  Table：
///  Input：job-任意值,deptPar-上级科室分层套id,count-记录数,lev-层次数
///  Output：
///  Return：
///  Others：w ##class(dhc.ca.cache.udata.uGenLevelTmp).GenTmp(0,3356,"",0)
ClassMethod GenTmp(deptPar, job, count, lev) As uDeptIncomeList
{
    i count ="" d
    .S count = ##class(dhc.ca.cache.udata.uCount).%New()
    .s count.num=0
    s lev=lev+1
    s count=$G(count)
    s tmpDept=""
    s deptDr=""
    s dept=""
    f  s dept=$o(^tmpDeptItem(0,"dhc","ca","deptIncom",deptPar,dept))  q:dept=""  d
    .s sum=""
    .f  s sum=$o(^tmpDeptItem(0,"dhc","ca","deptIncom",deptPar,dept,job,sum)) q:sum=""  d
    ..s item=$p(^tmpDeptItem(0,"dhc","ca","deptIncom",deptPar,dept,job,sum),"^",2)
    ..s fdept=$p(^tmpDeptItem(0,"dhc","ca","deptIncom",deptPar,dept,job,sum),"^",1)
    ..if deptPar=0 d
    ...s tmpDept=dept
    ...s deptIncom=^tmpDeptItem(0,"dhc","ca","deptIncom",deptPar,dept,job,sum)
    ...s tmp=count.num 
    ...s ^TMP("0","dhc","ca",job,tmp)=deptIncom_"^"_lev
    ...s count.num=count.num+1
    ...d ..GenTmp(dept,job,count,lev)
    ..else  if (item="合计")&&(dept'=0) d
    ...s deptIncom=^tmpDeptItem(0,"dhc","ca","deptIncom",deptPar,dept,job,sum)
    ...s tmp=count.num
    ...s ^TMP("0","dhc","ca",job,tmp)=deptIncom_"^"_lev
    ...s count.num=count.num+1
    ...d ..GenTmp(dept,job,count,lev)
    ..else  if (item="合计")&&(dept=0) d 
    ...s tmpdept=""
    ...f  s tmpdept=$o(^tmpDeptItem(0,"dhc","ca","deptIncom",deptPar,tmpdept)) q:tmpdept=""  d
    ....s num=""
    ....f  s num=$o(^tmpDeptItem(0,"dhc","ca","deptIncom",deptPar,tmpdept,job,num))  q:num=""  d
    .....s tmpfdept=$p(^tmpDeptItem(0,"dhc","ca","deptIncom",deptPar,tmpdept,job,num),"^",1) 
    .....s itemtmp=$p(^tmpDeptItem(0,"dhc","ca","deptIncom",deptPar,tmpdept,job,num),"^",2)
    .....if fdept=tmpfdept d
    ......if (itemtmp'="合计") d
    .......s t1=lev+1
    .......s deptIncome=^tmpDeptItem(0,"dhc","ca","deptIncom",deptPar,tmpdept,job,num)
    .......s tmp=count.num
    .......s ^TMP("0","dhc","ca",job,tmp)=deptIncome_"^"_t1
    .......s count.num=count.num+1
    ......else  d
    .......s deptIncome=^tmpDeptItem(0,"dhc","ca","deptIncom",deptPar,tmpdept,job,num)
    .......s tmp=count.num
    .......s ^TMP("0","dhc","ca",job,tmp)=deptIncome_"^"_lev
    .......s count.num=count.num+1
}

///  Creator：wang ying
///  CreatDate：2009-12-30
///  Description: 根据层次生成有层次结构的临时global
///  Table：
///  Input：job-任意值
///  Output：
///  Return：
///  Others：w ##class(dhc.ca.cache.udata.uGenLevelTmp).GenSpace(3356)
ClassMethod GenSpace(job)
{
  s count=""
  f  s count=$o(^TMP("0","dhc","ca",job,count)) q:count=""  d
  .s lev=$p(^TMP("0","dhc","ca",job,count),"^",5)
  .For i=1:1:lev d
  ..s space=" "
  ..s ^TMP("0","dhc","ca",job,count)=space_^TMP("0","dhc","ca",job,count)
  ..s space=space_" "
}

///  Creator：wang ying
///  CreatDate：2009-12-30
///  Description: 根据层次生成有层次结构的临时global
///  Table：
///  Input：id-任意值
///  Output：
///  Return：reportData对象
///  Others：w ##class(dhc.ca.cache.udata.uGenLevelTmp).GenLevelTmp(3356)
ClassMethod GenLevelTmp(job)
{
   d ..GenTmp(0,job,"",0)
   d ..GenSpace(job)
}

}
