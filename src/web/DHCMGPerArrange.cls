Class web.DHCMGPerArrange Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator:
/// CreatDate: 	2010-05-17
/// Description:取可用岗位代码
/// Table：		DHCMG_Post
/// Input：		parr:(科室ID)
/// Return：	rw_"|"_Desc_"^"
/// 			代码1ID|代码1描述^代码2ID|代码2描述^
ClassMethod GetDepPost(parr) As %String
{
	//w ##class(web.DHCMGPerArrange).GetDepPost(1)
	s ret=""
	s loc=$P(parr,"^",1)
    k sortno,sortempty
    if loc'=""{
	    s i=0
	    s rw="" f  s rw=$O(^User.DHCMGPostI("Loc"," "_loc,rw)) q:rw=""  d
	    .s a=^User.DHCMGPostD(rw)
	    .s curflag=$ListGet(a,12)
	    .q:curflag="Y"
    	.s Desc=$List(a,3)
    	.s Times=$List(a,5)
   		.s nums=$List(a,6)
    	.s sort=$ListGet(a,13)
    	.i sort'="" s sortno(sort,rw)=rw_"|"_Desc_" "_Times_" "_nums
    	.e  s sortempty(rw)=rw_"|"_Desc_" "_Times_" "_nums
    }
    //先取有顺序号的
    b //00
    s cursort="" f  s cursort=$O(sortno(cursort)) q:cursort=""  d
    .s currw="" f  s currw=$O(sortno(cursort,currw)) q:currw=""  d
    ..s ret=ret_sortno(cursort,currw)_"^" 
    //再取无顺序号的
    b //02
    s rw="" f  s rw=$O(sortempty(rw)) q:rw=""  d
    .s ret=ret_sortempty(rw)_"^"
    q ret
}

ClassMethod arrmzprefession(dep, stdate, edate, user) As %String
{
 //门诊专家号排班\
     //s dep="1082",stdate="2009-05-1",edate="2009-05-20",user="543"
     s rw=""  f  s rw=$O(^User.DHCMGPostPerWeekFixI("Dep"," "_dep,rw)) q:rw=""  d
    .s a=^User.DHCMGPostPerWeekFixD(rw)
    .s dep=$List(a,2)
    .s per=$List(a,3)
    .s pst=$List(a,4)
    .s week=$List(a,5)
    .d ..arrmz(stdate,edate,week,pst,per,dep,user)
    q 0
}

ClassMethod arrmz(stdate, enddate, weekper, pst, per, Dep, user) As %String
{
 //
 	f date=stdate:1:enddate 
    { //日期
     s week=$ZD(date,10)
     if week'=weekper continue
     s parr=pst_"^"_per_"^"_$zd(date,3)_"^"_Dep_"^"_user_"^"
     s ret=##class(User.DHCMGPersonArrange).manulArrange(parr)
    }
    q 0
}

ClassMethod GetPost(parr As %String) As %String
{
  //获取科室岗位
   s ret=""
   s loc=$P(parr,"^")
   b
   s rw="" f  s rw=$O(^User.DHCMGPostI("Loc"," "_loc,rw)) q:rw=""  d
   .s a=^User.DHCMGPostD(rw)
   .s Desc=$List(a,3)
   .s Times=$List(a,5)
   .s nums=$List(a,6)
   .s ret=ret_rw_"|"_Desc_"^"
   q ret
}

ClassMethod GetDepArrPost(parr As %String) As %String
{
  //获取科室岗位
   s ret=""
   s loc=$P(parr,"^")
   b
   s rw="" f  s rw=$O(^User.DHCMGPostI("Loc"," "_loc,rw)) q:rw=""  d
   .s a=^User.DHCMGPostD(rw)
   .s Desc=$List(a,3)
   .s Times=$List(a,5)
   .s nums=$List(a,6)
   .s ret=ret_rw_"|"_Desc_"^"
   q ret
}

ClassMethod GetSetPost(parr As %String) As %String
{
   //按类型获取设置岗位,人员
	  s typ=$P(parr,"^")
	  s dep=$P(parr,"^",2)
	  s ret=""
	  s (pers,pst)=""
	  s id="" s id=$O(^User.DHCMGArrangeSetI("DepTyp"," "_dep," "_typ,id))
      if id="" q ""
      
      
      s setDepTyp=##class(User.DHCMGArrangeSet).%OpenId(id)
      s stdate=setDepTyp.SetFromDate  //开始日期
      s enddate=setDepTyp.SetEndDate  //结束日期
      s stdate=$ZD(stdate,3)
      s enddate=$ZD(enddate,3)

	  s rw="" f  s rw=$O(^User.DHCMGArrangePostPersonI("SetArr",id,rw)) q:rw=""  d
      .s a=^User.DHCMGArrangePostPersonD(rw)
	  .s post=$List(a,2)
	  .s pr=$List(a,3)
	  .if post'="" s pst=pst_post_"|"
	  .if pr'="" s pers=pers_pr_"|"
	  s ret=pers_"^"_pst_"^"_stdate_"^"_enddate
	 q ret
}

ClassMethod getsetpostpers(parr As %String) As %String
{
  //获取岗位对应的人
	 s dep=$P(parr,"^",1)
	 s post=$P(parr,"^",2)
	 s ret=""
     s rw="" f  s rw=$O(^User.DHCMGArrSetPtPersI("DepPost"," "_dep," "_post,rw)) q:rw=""  d
     .s a=^User.DHCMGArrSetPtPersD(rw)
     .s per=$List(a,3)
     .s ret=ret_per_"|"
     q ret
}

ClassMethod GetDepPerson(parr As %String) As %String
{
 //s a=##class(web.DHCMGPerArrange).GetDepPerson()
	  s ret=""
	  s pdep=$P(parr,"^")
	  s stdate=$P(parr,"^",2)
	  s edate=$P(parr,"^",3)
	  if stdate="" s stdate=+$H
	  if edate=""  s edate=+$H
	  s tmp=""
	  s rw="" f  s rw=$O(^User.DHCMGArrangPerSortI("DepPer"," "_pdep,rw)) q:rw=""  d
	  .s tmp($TR(rw," ",""))=""
	  .d itm
	  s rw="" f  s rw=$O(^User.DHCMGPersonsI("Dep"," "_pdep,rw)) q:rw=""  d
	  .s dateend=$listGet(^User.DHCMGPersonsD(rw), 8)
	  .q:dateend'=""     //20121101
	  .s tempdr=##class(User.DHCMGPersons).getTempDep(rw)
	  .;q:tempdr'=""  //有临时科室就暂时不显示
	  .i $D(tmp(rw)) q
	  .s tmp(rw)=""
	  .d itm 
	  ;s rw="" f  s rw=$O(^User.DHCMGPersonsI("TempDep"," "_pdep,rw)) q:rw=""  d
      ;.i $D(tmp(rw)) q
      ;.s tmp(rw)=""
      ;.d itm 
      ;s pl=""  f  s pl=$O(^User.DHCMGPerCyclePlanI("dep"," "_pdep,pl)) q:pl=""  d
      ;.s da=^User.DHCMGPerCyclePlanD(pl)
      ;.s per=$List(da,3)
      ;.s pstd=$List(da,4)
      ;.s ped=$List(da,5)
      ;;.if pstd>edate q
      ;.if ped<stdate q
      ;.s rw=per
      ;.q:$D(tmp(rw))
      .d itm
	  s no=""  f  s no=$O(MPer(no)) q:no=""  d
	  .s ret=ret_MPer(no)_"^"
	   //}
	   q ret

itm     s persondr=$TR(rw," ","")
		q:$d(^User.DHCMGPersonsD(persondr))=0
		;i persondr="6331" b //4
	    s parr=^User.DHCMGPersonsD(persondr)
	    s dateend=$list(parr, 8)
	    s currday=$P($H,",")
        if dateend'="" 
        {
	     q:dateend<currday
	    }
        s name=$list(parr,21)
        s ssid=$list(parr,32)
	    s professpost=$list(parr,29)
	    s TeachPost=$list(parr,35)
	    s Mentor=$list(parr,20)
	    s WorkDateTime=$list(parr,40)
	    s TelHome=$list(parr,38)
	    s TelHand=$list(parr,37)
	    s Address=$list(parr,2)
	    s NativePl=$list(parr,22)
	    s sortno=..GetPerSortNo(persondr,pdep)
	    s flag=$list(parr,17)
	    s (prpostdes,TeachDes,MentorDes)=""
	    if professpost'="" s prpostdes=$list(^User.DHCMGCPostCodeD(professpost),3)
	    if TeachPost'="" s TeachDes=$list(^User.DHCMGCPostCodeD(TeachPost),3)
	    if Mentor'="" s MentorDes=$list(^User.DHCMGCPostCodeD(Mentor),3)
	    if sortno="" s ret=ret_persondr_"|"_name_" "_$G(prpostdes)_" "_$G(TeachDes)_" "_$G(MentorDes)_"^"
	    e  s MPer(sortno)=persondr_"|"_name_" "_$G(prpostdes)_" "_$G(TeachDes)_" "_$G(MentorDes) 
	  q
}

ClassMethod GetPerSortNo(per As %String, dep As %String = "") As %String
{
	q:dep=""
	s rw="" s rw=$O(^User.DHCMGArrangPerSortI("DepPer"," "_dep," "_per,rw))
	if rw="" q ""
	s persort=##class(User.DHCMGArrangPerSort).%OpenId(rw)
	s ret=persort.SetPersonSort
	q ret
}

ClassMethod arrangepost(Dep, User) As %String
{
   s a=..FtypNurAutoArrange(Dep,User)
   s a=..DtypNurAutoArrange(Dep,User)
   s a=..LtypNurAutoArrange(Dep,User)
   q 0
}

ClassMethod FtypNurAutoArrange(Dep, User) As %String
{
 //排班//固定班
	  s typ="F"
	  s ret=""
	  s id="" s id=$O(^User.DHCMGArrangeSetI("DepTyp"," "_Dep," "_typ,id))
      if id="" q ""
      s setDepTyp=##class(User.DHCMGArrangeSet).%OpenId(id)
      s stdate=setDepTyp.SetFromDate  //开始日期
      s enddate=setDepTyp.SetEndDate  //结束日期
      //门诊专家排班dep, stdate, edate, user
      s a=##class(web.DHCMGPerArrange).arrmzprefession(Dep,stdate,enddate,User)
      s setstr=##class(web.DHCMGPerArrange).GetSetPost(typ_"^"_Dep)
      s pers=$P(setstr,"^")
      s posts=$P(setstr,"^",2)
      //人员岗位，日期
      //固定班每个岗位有固定人
      //第一层循环 岗位 
      //第二层 每个岗位对应的人
      //第三层 起始日期 周一至周五
      s n=$L(posts,"|")
      f i=1:1:n
      { 
	     s pt=$P(posts,"|",i)
	     q:pt="" //岗位
	     s nurs=..getsetpostpers(Dep_"^"_pt)
	     q:nurs=""
	     s ln=$L(nurs,"|")
	     f j=1:1:ln
	     { //人员
		   s nurse=$P(nurs,"|",j)
		   f date=stdate:1:enddate 
           { //日期
	         s week=$ZD(date,10)
	         if (week<1)!(week>5) continue
	         s flag=..schpersonholdiday(nurse,date)
	         if flag="Y" continue
	         s parr=pt_"^"_nurse_"^"_$zd(date,3)_"^"_Dep_"^"_User_"^"
             s ret=##class(User.DHCMGPersonArrange).manulArrange(parr)
             s ret=..GetRelPer(nurse,date,pt,Dep,User)
	       }
		 }
	  }
}

ClassMethod DtypNurAutoArrange(Dep, User) As %String
{
 //排班 值班 //s a=##class(web.DHCMGPerArrange).DtypNurAutoArrange(1082,543)
 //1.确定起始日期
 //2.确定人员
 //3.确定岗位
	  s typ="D"
	  s ret=""
	  s id="" s id=$O(^User.DHCMGArrangeSetI("DepTyp"," "_Dep," "_typ,id))
      if id="" q ""
      s setDepTyp=##class(User.DHCMGArrangeSet).%OpenId(id)
      s stdate=setDepTyp.SetFromDate  //开始日期
      s enddate=setDepTyp.SetEndDate  //结束日期
      s setstr=##class(web.DHCMGPerArrange).GetSetPost(typ_"^"_Dep)
      s pers=$P(setstr,"^")
      s posts=$P(setstr,"^",2)
      //人员岗位，日期
      s n=$L(posts,"|")
      //1层 --按岗位作循环
      //2 起始日期，在一组人内循环
      //3 每个岗位起始日期 +1(第一个不加)
      f i=1:1:n
      { 
	     s pt=$P(posts,"|",i)
	     q:pt="" //岗位
	     q:pers=""
	     s ln=$L(pers,"|")
	     s j=1
	     s tdate=stdate+(i-1)
	     b //
	     f date=tdate:1:enddate
	     {
		    s nurse=$P(pers,"|",j)
		    if nurse="" s date=date-1
		    if j=ln s j=0
            s j=j+1
		    if nurse="" continue
		    s flag=..schpersonholdiday(nurse,date)
	        if flag="Y" continue
		   // w !,j,"-",date,"-",pt,"-",nurse
		    s parr=pt_"^"_nurse_"^"_$ZD(date,3)_"^"_Dep_"^"_User_"^"
            s ret=##class(User.DHCMGPersonArrange).manulArrange(parr)
            s ret=..GetRelPer(nurse,date,pt,Dep,User)
		 }
	  }
}

ClassMethod getGtyppst(Dep, typ)
{
	    s rw="" f  s rw=$O(^User.DHCMGArrSetI("DepTyp"," "_Dep," "_typ,rw)) q:rw=""  d
        .s a=^User.DHCMGArrSetD(rw)
        .s no=$List(a,3)
        .s num=$List(a,4)
        .s PostDr=$List(a,5)
        .if $G(p(no))="" s p(no)=PostDr
        .e  s p(no)=p(no)_"^"_PostDr
        s ret=""
        s n="" f  s n=$O(p(n)) q:n=""  d
        .s ret=ret_p(n)_"|"
       q ret
}

ClassMethod GtypNurAutoArrange(Dep, User) As %String
{
 //按组排班 值班s a=##class(web.DHCMGPerArrange).GtypNurAutoArrange
	  s typ="G"
	  s ret=""
	  s id="" s id=$O(^User.DHCMGArrangeSetI("DepTyp"," "_Dep," "_typ,id))
      if id="" q ""
      s setDepTyp=##class(User.DHCMGArrangeSet).%OpenId(id)
      s stdate=setDepTyp.SetFromDate  //开始日期
      s enddate=setDepTyp.SetEndDate  //结束日期
      s setstr=##class(web.DHCMGPerArrange).GetSetPost(typ_"^"_Dep)
      s pers=$P(setstr,"^")
      s posts=..getGtyppst(Dep,typ)
      //人员岗位，日期
      s n=$L(posts,"|")
      f i=1:1:n
      { 
	     s pt=$P(posts,"|",i)
	     q:pt="" //岗位
	     s l=$L(pt,"^")
	     if (l=1)
	     { //如果是一个岗位 ，这组人都是这个岗位
		      s ptstr=""}
	     else{
		     s str=..getpst(pt)
		     s pt=$P(str,"^")
		     s ptstr=$P(str,"^",2)
		     }
	     //s a=##class(User.DHCMGPost).%OpenId(pt)
         //s flag=a.PostFlag
         //if flag="N" continue
	     q:pers=""
	     s ln=$L(pers,"|")
	     s j=1
	     if $G(^DHCMGArrTmpSet(i))'="" 
	     {
		     if ^DHCMGArrTmpSet(i)=ln s j=1
		     e  d
		     .s j=$P(^DHCMGArrTmpSet(i),"^",1)
		     .s ptstr=$P(^DHCMGArrTmpSet(i),"^",2)
		     
		 }
	     if j=1 s stdate=stdate+(i-1)
	     f date=stdate:1:enddate
	     {
            s grp=$P(pers,"|",j)
		    if grp="" s date=date-1
		    if j=ln s j=0
		    if j=1 s pregrp=grp
		   	s j=j+1
		   	//b //---
            if grp="" continue
		    //w !,j,"-",date,"-",pt,"-",nurse
		    //s parr=pt_"^"_nurse_"^"_date_"^"_Dep_"^"_User_"^"
            //s ret=##class(User.DHCMGPersonArrange).arrange(parr)
            if (grp=$G(pregrp))&(j=2)&(date'=stdate)&(ptstr'="")
            {
	         s ptstr=..sortpost(ptstr)
             // b //
            }
            //b ///000
            s ret=..GrpPersonArrange(grp,date,Dep,User,pt,ptstr)
            //s prevgrp=grp,predate=date,prej=j,prei=i
            s ^DHCMGArrTmpSet(i)=j_"^"_ptstr
		 }
	  }
	  //s ^DHCMGArrTmpSet=prevgrp_"^"_date_"^"_prej_"^"_prei
}

ClassMethod getpst(pstr) As %String
{
    s l=$L(pstr,"^")
    s ret=""
    f i=1:1:l
    {
	  s p=$P(pstr,"^",i)
	  if p="" continue
	  s a=##class(User.DHCMGPost).%OpenId(p)
      s flag=a.PostFlag
      if flag="Y" 
      {
	  s nigpt=p 
      continue
      }
      if ret="" s ret=p
      e  s ret=ret_"|"_p
	}
	q nigpt_"^"_ret
}

ClassMethod GrpPersonArrange(grp As %String, date As %String, Dep As %String, User As %String, post As %String, ptstr As %String)
{
		s i=1
		s rw=""  f  s rw=$O(^User.DHCMGGroupPersonsI("Grp",grp,rw)) q:rw=""  d
        . s a=^User.DHCMGGroupPersonsD(rw)
        . s personDr=$List(a,3)
        . s parr=post_"^"_personDr_"^"_date_"^"_Dep_"^"_User_"^"
        . s ret=##class(User.DHCMGPersonArrange).ptarrange(parr)
        . if ptstr="" q
        . s pt=$P(ptstr,"|",i)
        . s i=i+1
        . s parr=pt_"^"_personDr_"^"_date_"^"_Dep_"^"_User_"^"
        . s ret=##class(User.DHCMGPersonArrange).ptarrange(parr)
        . s parr=pt_"^"_personDr_"^"_date_"^"_Dep_"^"_User_"^"
        . s ret=..GetRelPer(personDr,date,post,Dep,User)
      q 0
}

ClassMethod SearchPerson(pers, nums, schno, date)
{
           //s pers="3|5|7|9|8|72|"
           //s nums=2
          // s schno=4
           //s date=61413
            s ln=$l(pers,"|")
            s no=""
           // b //sch
            q:schno'<ln ""
            s m=0
            s nurse=""
            s flag=""
            
            for i=schno:1:ln
            {
	          if m=nums
	          { 
	           s flag=i
	           q 
	          }
	          q:$P(pers,"|",i)=""
	          s nurdr=$P(pers,"|",i)
	          s fg=..schDatePost(nurdr,(date-1),"Y") 
  		      if fg="Y"  continue
  		      s fg=..schDatePost(nurdr,(date-2),"Y") 
  		      if fg="Y"  continue
  		      s hl=..schpersonholdiday(nurdr,date)
  		      if hl="Y" continue
  		      s rw=""  s rw=$O(^User.DHCMGPersonArrangeI("PersonDate"," "_nurdr,date,rw))
  		      //if rw'="" continue
	          s ng=..schDatePost(nurdr,date,"N") 
	         // b //ng
	          //w !,ng
  		      if (rw'="")&(ng="N")  continue  //如果当天有夜班可继续排白班
  		      s m=m+1
	          s nurse=nurse_nurdr_"^"
	        }
	       // b //endsch
	    q flag_$C(1)_nurse 
	    //011 123
	    //442 442
}

ClassMethod LtypNurAutoArrange(Dep, User) As %String
{
 //排班 值班 //轮转
	  s typ="L"
	  s ret=""
	  s id="" s id=$O(^User.DHCMGArrangeSetI("DepTyp"," "_Dep," "_typ,id))
      if id="" q ""
      s setDepTyp=##class(User.DHCMGArrangeSet).%OpenId(id)
      s stdate=setDepTyp.SetFromDate  //开始日期
      s enddate=setDepTyp.SetEndDate  //结束日期
      s setstr=##class(web.DHCMGPerArrange).GetSetPost(typ_"^"_Dep)
      s pers=$P(setstr,"^")
      s posts=$P(setstr,"^",2)
      //人员岗位，日期
      s n=$L(posts,"|")
      
      f date=stdate:1:enddate
      {  
	     q:pers=""
	     s week=$ZD(date,10)
	     s i=1
	     //-----
	     f j=1:1:n
	     { //人员 检查某人某日是否已有岗位//岗位人数还没考虑 //考虑关联人
		 //  b 999
		   //2
		   s pt=$P(posts,"|",j)
	       q:pt="" //岗位
		   s p=^User.DHCMGPostD(pt)
		   // 获取岗位使用范围，人数
		   s rang=$List(p,9)
		   s wkst=$P(rang,"-",1),wked=$P(rang,"-",2)
		   s wpers=$List(p,10)
           s nums=$List(p,6) //取岗位需要人数
           
	       if (week<wkst)!(week>wked) continue
           if ((week=0)!(week=6))&(wpers'="") s nums=wpers 
           
           s n1=..schpostdate(pt,date)
          // w !,n1,"--",pt,"yy",$ZD(date,3)
           s nums=nums-n1
            //b //g
           s perstr=..SearchPerson(pers,nums,i,date)
           s nurstr=$P(perstr,$C(1),2)
           s posnum=$P(perstr,$C(1),1)
           s i=posnum
	       w !,perstr
	       //b //e
           f k=1:1:nums 
           {
  		    s nurse=$P(nurstr,"^",k)
  		    s parr=pt_"^"_nurse_"^"_date_"^"_Dep_"^"_User_"^"
  		    //b //--
            s ret=##class(User.DHCMGPersonArrange).ptarrange(parr)
            s ret=..GetRelPer(nurse,date,pt,Dep,User)
            ///b  //55
	       }
		 }
		s posts=..sortpost(posts)

	  }
	  q 0
}

ClassMethod schDatePost(per As %String, date As %String, lb As %String) As %String
{
   //Index PersonDate On (ARRPerDR, ARRDate);
   //检查 某人前一天的岗位是否夜班
  s flag="N"
  s rw=""  f  s rw=$O(^User.DHCMGPersonArrangeI("PersonDate"," "_per,date,rw)) q:(rw="")!(flag=lb)  d
  .s p=^User.DHCMGPersonArrangeD(rw)
  .s pst=$List(p,6)
  .s a=##class(User.DHCMGPost).%OpenId(pst)
  .s flag=a.PostFlag
  q flag
}

ClassMethod schpostdate(post, date)
{
 //查找某天的岗位是否存在
   s n=0
   s rw=""  f  s rw=$O(^User.DHCMGPersonArrangeI("DatePost",date," "_post,rw)) q:rw=""  d
   .s n=n+1
   q n
}

ClassMethod sortpost(post) As %String
{
 //反排序
   s ln=$l(post,"|")
   f i=1:1:ln
   {
     q:$P(post,"|",i)=""
     s p(i)=$P(post,"|",i)
   }
   s a=""
   s r="" s r=$O(p(r),-1)
   s last=p(r)
   s i=1
   s r="" f  s r=$O(p(r)) q:r=""  d
   .q:p(r)=last
   .s $P(a,"|",i)=p(r)
   .s i=i+1
   s a=last_"|"_a
   q a
}

ClassMethod GetRelPer(per As %String, date As %String, pst As %String, dep As %String, User As %String) As %String
{
   //取关联人员
   s ret=""
   s rw="" f  s rw=$O(^User.DHCMGPersonRelationI("Rel"," "_dep," "_per,rw)) q:rw=""  d
   .s rel=##class(User.DHCMGPersonRelation).%OpenId(rw)
   .s nursub=rel.RelPersonSubDR
   .s fdate=rel.RelFromDate
   .s edate=rel.RelEndDate
   .if (date<fdate)!(date>edate) q
   .s parr=pst_"^"_nursub_"^"_date_"^"_dep_"^"_User_"^"
   .s ret=##class(User.DHCMGPersonArrange).arrange(parr)
   q ret
}

ClassMethod GetSubPerson(per As %String, date As %String, Dep As %String) As %String
{
   //取关联人员
   s ret=""
   s rw="" f  s rw=$O(^User.DHCMGPersonRelationI("Rel"," "_Dep," "_per,rw)) q:rw=""  d
   .s rel=##class(User.DHCMGPersonRelation).%OpenId(rw)
   .s nursub=rel.RelPersonSubDR
   .s fdate=rel.RelFromDate
   .s edate=rel.RelEndDate
   .if (date<fdate)!(date>edate) q
   .s ret=nursub
   q ret
}

ClassMethod GetNurRelPersonExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s loc=$P(parr,"^",1)
    s parnur=$P(parr,"^",2)
    if loc'=""{
	    s par="" f  s par=$O(^User.DHCMGPersonRelationI("Rel"," "_loc,par)) q:par=""  d
	    .q:(par'=" "_parnur)&(parnur'="")
	    .s rw="" f  s rw=$O(^User.DHCMGPersonRelationI("Rel"," "_loc,par,rw)) q:rw=""  d
	    ..d out
    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (DepDes,OldNur,Nurse,fdate,edate)=""
    s a=^User.DHCMGPersonRelationD(rw)
    s Dep=$List(a,6)
    if Dep'="" s DepDes=$P(^CTLOC(Dep),"^",2)
    s edate=$List(a,2)
    s fdate=$List(a,3)
    s oldNurDr=$List(a,4)
    s subNurDr=$List(a,5)
    b
    s parr=^User.DHCMGPersonsD(oldNurDr)
    s OldNur=$list(parr,21)
    s parr=^User.DHCMGPersonsD(subNurDr)
    s Nurse=$list(parr,21)
    s edate=$ZD(edate,3)
    s fdate=$ZD(fdate,3)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(DepDes,OldNur,Nurse,fdate,edate,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetNurRelPersonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNurRelPersonExecute ]
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

ClassMethod GetNurRelPersonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNurRelPersonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetNurRelPerson(parr As %String) As %Query(ROWSPEC = "DepDes,OldNur,Nurse,fdate,edate,rw")
{
}

ClassMethod GetArrange(parr As %String) As %String
{
 //   // s parr="945^2010-2-13^2010-02-18"

  //取排班列表
 // s parr="945^2010-2-13^2010-02-18"
 // w ##class(web.DHCMGPerArrange).GetArrange("76^2012-10-29^2012-11-04")
 //  w ##class(web.DHCMGPerArrange).GetArrange("72^2012-10-22^2012-10-28")
    s loc=$P(parr,"^",1)
    s stdate=$P(parr,"^",2)
    s edate=$P(parr,"^",3)
    s stdate=$ZDH(stdate,3)
    s edate=$ZDH(edate,3)
    
    s ret=..GetDepPerson(loc_"^"_stdate_"^"_edate)
    s ln=$L(ret,"^")
    s endI=0
    for i=1:1:ln
    {
	  s str=$P(ret,"^",i)
	  s per=$P(str,"|",1)
	  if per="" continue
	  s MNur(i)=per
	  ;i i=29 b //56
	  ;i MNur(i)=6331 b //7
	  s MNurSort(per)=i
	  s endI=i
	}
    f date=stdate:1:edate
    {
	    s par="" f  s par=$O(^User.DHCMGPersonArrangeI("DepDate"," "_loc,date,par)) q:par=""  d
	    .s arr=^User.DHCMGPersonArrangeD(par)
	    .s Nur=$List(arr,5)
	  	.if '$D(MNurSort(Nur)) d
	    ..//显示历史存在数据
	    ..s endI=endI+1
	    ..s MNurSort(Nur)=endI
	    ..s MNur(endI)=Nur
        .s PostDr=$List(arr,6)
	    .s flag=$List(arr,4)
	    .;i PostDr="" continue
	    .q:PostDr=""
	    .s Post=$List(^User.DHCMGPostD(PostDr),3)
	    .s pflag=$List(^User.DHCMGPostD(PostDr),7)
	    .s hours=$List(^User.DHCMGPostD(PostDr),10)
	    .s NightHour=$ListGet(^User.DHCMGPostD(PostDr),14)
	    .if $G(MNurPost(Nur,date))="" d
	    ..;i flag="P" s MNurPost(Nur,date)=PostDr_"|"_"PM"
	    ..s MNurPost(Nur,date)=PostDr_"|"_flag
	    .e  s MNurPost(Nur,date)=MNurPost(Nur,date) _"+"_PostDr_"|"_flag
	    .if pflag="Y" d
	    ..;s fullnightdnum=$fn((hours/8),"",2)
	    ..s fullnightdnum=$fn((hours),"",2)
	    ..if (flag="A")!(flag="P") 
	    ...s nightdnum(Nur)=$G(nightdnum(Nur))+$fn((fullnightdnum/2),"",2)
	    ..e  d
	    ...s nightdnum(Nur)=$G(nightdnum(Nur))+$fn((fullnightdnum),"",2)
	    .e  d
	    ..i +NightHour>0 d
	    ...;s fullnightdnum=$fn((NightHour/8),"",2)
	    ...s fullnightdnum=$fn((NightHour),"",2)
	    ...if (flag="A")!(flag="P") d
	    ....s nightdnum(Nur)=$G(nightdnum(Nur))+$fn((fullnightdnum/2),"",2)
	    ...e  d
	    ....s nightdnum(Nur)=$G(nightdnum(Nur))+$fn((fullnightdnum),"",2)
	    .;s fullmnurdnum=$fn((hours/8),"",2)
	    .s fullmnurdnum=$fn((hours),"",2)
	    .if (flag="A")!(flag="P") d
	    ..s mnurdnum(Nur)=$G(mnurdnum(Nur))+$fn((fullmnurdnum/2),"",2)
	    .e  d
	    ..s mnurdnum(Nur)=$G(mnurdnum(Nur))+$fn((fullmnurdnum),"",2)
	    .//w !,$G(nightdnum(Nur)),"Nur",Nur
	    //	   . s sortno=..GetPerSortNo(rw)


    }
   f date=stdate:1:edate
    {
	   s r="" f  s r=$O(MNur(r)) q:r=""  d
	   .if '$D(MNurPost(MNur(r),date))  s MNurPost(MNur(r),date)=""
    }

    s nur="" f  s nur=$O(MNurPost(nur)) q:nur=""  d
    .s ret=""
    .s date="" f  s date=$O(MNurPost(nur,date)) q:date=""  d
    ..s ret=ret_..getstr(MNurPost(nur,date))_"^"
    .s no=$G(MNurSort(nur))
    .q:no=""
    .s MNurArr(no,nur)=ret
    s ret=""
    s no="" f  s no=$O(MNurArr(no)) q:no=""  d
    .s nur=""  f  s nur=$O(MNurArr(no,nur)) q:nur=""  d
    ..s parr=^User.DHCMGPersonsD(nur)
    ..s nurse=$list(parr,21)
    ..s PersonBatteryDr=$listGet(parr,62)
    ..i PersonBatteryDr'="" s PersonBattery=$list(^User.DHCMGCCodeD(PersonBatteryDr),3)
    ..e  s PersonBattery=""
    ..s nurse=nurse_PersonBattery         //20121101
    ..s PerGrpDr=$O(^User.DHCMGGroupPersonsI("Person"," "_nur,"")) 
    ..i PerGrpDr'="" d
    ...s Grp=$g(^User.DHCMGGroupPersonsD(PerGrpDr))
    ...s GrpDr=$list(Grp,2)
    ...i GrpDr'="" d
    ....s GrpDesc=$list($g(^User.DHCMGCGroupD(GrpDr)),3)
	....s nurse=nurse_"("_GrpDesc_")"		//20100422护士分组显示在姓名后面
    ..s catid=$listGet(parr,45)				//可能是负值?
    ..i catid>0 s color=##class(User.DHCMGCCode).GetPertypColor(catid)
    ..e  s color=""
    ..s memstr=##class(User.DHCMGPersonArrange).getarrmem(nur,edate)
    ..s m1=$P(memstr,"^"),m2=$P(memstr,"^",2)
    ..//s subnur=..GetSubPerson(nur,stdate,loc)
    ..//s subnurse=""
    ..//if subnur'="" s subnurse=$list(^User.DHCMGPersonsD(subnur),21)
    ..i $G(mnurdnum(nur))'="" s mnurdnum(nur)=$fn($G(mnurdnum(nur)),"",2)
    ..i $G(nightdnum(nur))'="" s nightdnum(nur)=$fn(nightdnum(nur),"",2)
    ..s ret=ret_nur_$C(3)_color_"^"_nurse_$C(3)_$G(nur)_"^"_MNurArr(no,nur)_m1_"^"_m2_"^"_$G(mnurdnum(nur))_"^"_$G(nightdnum(nur))_$C(1)
 q ret
}

ClassMethod getPerOvRec(Dep, stdate, edate) As %String
{
 //加班记录
 // s Dep=1082,stdate="2009-04-01",edate="2009-4-23"
 s stdate=$ZDH(stdate,3),edate=$ZDH(edate,3)
 f date=stdate:1:edate
 {
    s rw="" f  s rw=$O(^User.DHCMGPersonOverRestI("DepDate"," "_Dep,date,rw)) q:rw=""  d
    .s ov=^User.DHCMGPersonOverRestD(rw)
    .s per=$list(ov,4)
    .s times=$FN($list(ov,11),"",1)
    .s MOV(per)=$G(MOV(per))_$ZD(date,3)_"^"_times_$C(1)
    
 }
    s ret=""
    s per="" f  s per=$O(MOV(per)) q:per=""  d
    .s ret=ret_per_$C(1)_MOV(per)_$C(3)
    q ret
}

ClassMethod getperhol(Dep, stdate, edate) As %String
{
   //s Dep="211",stdate="2010-08-01",edate="2010-08-29"
  // s a=##class(web.DHCMGPerArrange).getperhol()
   s stdate=$ZDH(stdate,3),edate=$ZDH(edate,3)
   s d=""  f  s d=$O(^User.DHCMGPersonHolidayI("DepDate"," "_Dep,d)) q:d=""  d
    .s rw=""  f  s rw=$O(^User.DHCMGPersonHolidayI("DepDate"," "_Dep,d,rw)) q:rw=""  d
    ..s perhol=^User.DHCMGPersonHolidayD(rw)
    ..s per=$List(perhol,6)
    ..s hl=$List(perhol,4)
    ..s sttime=$Listget(perhol,15)
    ..s ettime=$Listget(perhol,14)
    ..s resthours=""
    ..if ((sttime'="")&(ettime'="")) d
    ...s resthours=ettime-sttime
    ...s resthours=$FN(resthours/3600,"",1)
    ..s mem=$Listget(perhol,5)
    ..if (mem="A")!(mem="P") s resthours=mem
    ..q:'$D(^User.DHCMGCHolidayD(hl))
    ..q:hl=""
    ..s a=^User.DHCMGCHolidayD(hl)
    ..s Code=$List(a,2)
    ..s Desc=$List(a,4)
    ..s hlstdate=$List(perhol,3),hledate=$List(perhol,2)
    ..if hlstdate'<stdate s sd=hlstdate
    ..if stdate'<hlstdate s sd=stdate
    ..if edate'>hledate s ed=edate
    ..if hledate'>edate s ed=hledate
    ..//w !,$zd(hlstdate,3),",",$ZD(hledate,3),",",$ZD(stdate,3),",",$ZD(edate,3)
    ..//b 
    ..if hlstdate>edate q
    ..if hledate<stdate q
    ..s flag=..getlastposttime(per,sd)
    ..s hol(per)=$G(hol(per))_Desc_resthours_"|"_flag_"^"_$ZD(sd,3)_"^"_$ZD(ed,3)_"^"_flag_$C(1)
    ..
    s ret=""
    s per="" f  s per=$O(hol(per)) q:per=""  d
    .s ret=ret_per_$C(1)_hol(per)_$C(3)
    q ret
}

ClassMethod getlastposttime(person, date) As %String
{
 //判断休息在上午还是下午
       s flag=""
	   s rw=""  s rw=$O(^User.DHCMGPersonHolidayI("PersonDate"," "_person,date,rw))
       if rw'="" d
       .s arr=^User.DHCMGPersonHolidayD(rw)
       .s flag=$list(arr,5)
 	   q flag
}

ClassMethod getstrOLDbak(pstr) As %String
{
 
    s ln=$L(pstr,"+")
    s nigpt=""
    s ret=""
    for i=1:1:ln
    {
 	   s pst=$P(pstr,"+",i)
 	   s pt=$P(pst,"|")
 	   s flag=$P(pst,"|",2)
 	   q:pt=""
 	   s p=##class(User.DHCMGPost).%OpenId(pt)
 	   i p.PostFlag="Y"
 	   {
	 	   if flag'=""
	 	   {
	 	    s nigpt=p.PostDesc_"|"_flag
	 	   }else{
	 	    s nigpt=p.PostDesc
		 	   }
 	   }
 	   else{ 
 	    if flag'=""
 	    { 
	 	    if ret="" s ret=p.PostDesc_"|"_flag
	 	    e  s ret=ret_"/"_p.PostDesc_"|"_flag
 	    }else{
	 	    
	 	   	if ret="" s ret=p.PostDesc
	 	    e  s ret=ret_"/"_p.PostDesc
	 	    
	 	    }
	   }
 	}
 	if (nigpt'="")&(ret'="") s ret=ret_"/"_nigpt
 	if (nigpt'="")&(ret="") s ret=""_nigpt
   q ret
}

ClassMethod getstr(pstr) As %String
{
 
    s ln=$L(pstr,"+")
    s nigpt=""
    s ret=""
    for i=1:1:ln
    {
 	   s pst=$P(pstr,"+",i)
 	   s pt=$P(pst,"|")
 	   s flag=$P(pst,"|",2)
 	   q:pt=""
 	   s p=##class(User.DHCMGPost).%OpenId(pt)
 	   i p.PostFlag="Y"
 	   {
	 	   if flag'=""
	 	   {
	 	    //s nigpt=p.PostDesc_"|"_flag
	 	    if nigpt="" s nigpt=p.PostDesc_"|"_flag
	 	    e  s nigpt=nigpt_"/"_p.PostDesc_"|"_flag
	 	    
	 	   }else{
	 	    //s nigpt=p.PostDesc
	 	    if nigpt="" s nigpt=p.PostDesc
	 	    e  s nigpt=nigpt_"/"_p.PostDesc
	 	    
		 	   }
 	   }
 	   else{ 
 	    if flag'=""
 	    { 
	 	    if ret="" s ret=p.PostDesc_"|"_flag
	 	    e  s ret=ret_"/"_p.PostDesc_"|"_flag
 	    }else{
	 	    
	 	   	if ret="" s ret=p.PostDesc
	 	    e  s ret=ret_"/"_p.PostDesc
	 	    
	 	    }
	   }
 	}
 	if (nigpt'="")&(ret'="") s ret=ret_"/"_nigpt
 	if (nigpt'="")&(ret="") s ret=""_nigpt
   q ret
}

ClassMethod GetPerHolidayExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s dep=$P(parr,"^",1)
    s pers=$P(parr,"^",2)
    if pers=""
    {
    s date="" f  s date=$O(^User.DHCMGPersonHolidayI("DepDate"," "_dep,date)) q:date=""  d
    .s rw=""  f  s rw=$O(^User.DHCMGPersonHolidayI("DepDate"," "_dep,date,rw)) q:rw=""  d
    ..//s a=##class(User.DHCMGPersonHoliday).%OpenId(rw)
    ..//s a.HOLStTime=$P($H,",",2)
    ..//s a.HOLETime=$P($H,",",2)
    ..//d a.%Save()
    ..d out
    }else{
	    
	 s date="" f  s date=$O(^User.DHCMGPersonHolidayI("PersonDate"," "_pers,date)) q:date=""  d
     .s rw=""  f  s rw=$O(^User.DHCMGPersonHolidayI("PersonDate"," "_pers,date,rw)) q:rw=""  d
     ..//s a=##class(User.DHCMGPersonHoliday).%OpenId(rw)
     ..//s a.HOLStTime=""
     ..//s a.HOLETime=""
     ..d out
    
	    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (DepDes,Nurse,Hol,fdate,edate,mem,sttime,etime)=""
    s a=^User.DHCMGPersonHolidayD(rw)
    s edate=$List(a,2)
    s fdate=$List(a,3)
    s sttime=$List(a,15)
    s etime=$List(a,14)
    if sttime'="" s sttime=$ZT(sttime,1)
    if etime'="" s etime=$ZT(etime,1)
    
    s holdr=$List(a,4)
    q:'$D(^User.DHCMGCHolidayD(holdr))
    s Hol=$List(^User.DHCMGCHolidayD(holdr),4)
    s mem=$List(a,5)
    s person=$List(a,6)
    if (person'=pers)&(pers'="") q
    s Dep=$List(a,10)
    if Dep'="" s DepDes=$P(^CTLOC(Dep),"^",2)
    s parr=^User.DHCMGPersonsD(person)
    s Nurse=$list(parr,21)
    s edate=$ZD(edate,3),fdate=$ZD(fdate,3)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(DepDes,Nurse,Hol,fdate,edate,mem,sttime,etime,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPerHolidayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPerHolidayExecute ]
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

ClassMethod GetPerHolidayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPerHolidayExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPerHoliday(parr As %String) As %Query(ROWSPEC = "DepDes,Nurse,Hol,fdate,edate,mem,sttime,etime,rw")
{
}

ClassMethod GetPerOVRestExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//s parr="1079^"
    s dep=$P(parr,"^",1)
    s pers=$P(parr,"^",2)
    s date="" f  s date=$O(^User.DHCMGPersonOverRestI("DepDate"," "_dep,date)) q:date=""  d
    .s rw=""  f  s rw=$O(^User.DHCMGPersonOverRestI("DepDate"," "_dep,date,rw)) q:rw=""  d
    ..d out
 
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (DepDes,Nurse,datest,times,typ,mem,ovsum)=""
    s a=^User.DHCMGPersonOverRestD(rw)
    s datest=$List(a,2)
    s Dep=$List(a,3)
    s person=$List(a,4)
    s mem=$List(a,5)
    s times=$List(a,11)
    s ovsum=$List(a,12)
    s RecDate=$List(a,6)
    s RecDate=$ZD(RecDate,3)
    s typ=$List(a,10)
    if (person'=pers)&(pers'="") q
    if Dep'="" s DepDes=$P(^CTLOC(Dep),"^",2)
    s parr=^User.DHCMGPersonsD(person)
    s Nurse=$list(parr,21)
    s datest=$ZD(datest,3)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(DepDes,Nurse,datest,times,typ,mem,ovsum,RecDate,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPerOVRestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPerOVRestExecute ]
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

ClassMethod GetPerOVRestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPerOVRestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPerOVRest(parr As %String) As %Query(ROWSPEC = "DepDes,Nurse,datest,times,typ,mem,ovsum,RecDate,rw")
{
}

ClassMethod GetHoliday() As %String
{

   s ret=""
   s rw=""  f  s rw=$O(^User.DHCMGCHolidayD(rw)) q:rw=""  d
   . s a=^User.DHCMGCHolidayD(rw)
   . s Code=$List(a,2)
   . s Desc=$List(a,4)
   . s flag=$List(a,3)
   . q:flag="Y"
   . s ret=ret_rw_"|"_Desc_"^"
   q ret
}

ClassMethod SaveHolAdj(parr As %String) As %String
{
 //s a=##class(web.DHCMGPerArrange).SaveArrAdj
   //s parr="2009-03-30"_$C(2)_"2009-04-30"_$C(2)_"1079"_$C(2)_"543"_$C(2)_"186^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"266^4/7/^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"367^4/7/^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"416^^4^4^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"680^^4^4^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"814^4/7/^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"815^4/7/^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"816^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"817^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"818^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"819^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"820^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"821^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"69^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"822^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"823^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"824^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"825^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"1038^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"1144^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)
   // "^"+NurDr + "^" + holdr + "^" + holstdate + "^" + holedate + "^" + Comm.MgPersonId + "^" + Comm.logonLoc+"^";
  // s ^T=parr
  // q 0
   //s ^tmpe3512(1)=parr
   //s parr=^tmpe3512(1)
   //b //1
   s stdate=$P(parr,$C(2))
   //b //3
   s edate=$P(parr,$C(2),2)
   s loc=$P(parr,$c(2),3)
   s User=$P(parr,$c(2),4)
   s arrang=$P(parr,$c(2),5)
   s ln=$L(arrang,$C(1))
   s stdate=$ZDH(stdate,3)
   s edate=$ZDH(edate,3)
   b
   for i=1:1:ln
   {
      s itm=$P(arrang,$C(1),i)
      s j=2
      s Nurse=$P(itm,"^",1)
      for date=stdate:1:edate
      {
	    s hol=$P(itm,"^",j)
	    //b //6
	    s holdr=$P(hol,"|")
	    s flag=$P(hol,"|",2)
	    s j=j+1
	    if holdr="" continue
	    ;b //9
	    s parr= "^"_Nurse _ "^" _ holdr _ "^" _ $ZD(date,3)_ "^"_ $ZD(date,3)_ "^"_ User_ "^" _ loc_"^"_flag
	    s ret=##class(User.DHCMGPersonHoliday).SavePerHol(parr)
	           
	  }
   }
   q 0
}

ClassMethod SaveArrAdj(parr As %String) As %String
{
 //s a=##class(web.DHCMGPerArrange).SaveArrAdj
   //s parr="2009-03-30"_$C(2)_"2009-04-30"_$C(2)_"1079"_$C(2)_"543"_$C(2)_"186^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"266^4/7/^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"367^4/7/^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"416^^4^4^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"680^^4^4^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"814^4/7/^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"815^4/7/^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"816^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"817^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"818^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"819^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"820^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"821^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"69^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"822^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"823^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"824^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"825^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"1038^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)_"1144^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_$C(1)
  // s parr=^T(1)
   s stdate=$P(parr,$C(2))
   s edate=$P(parr,$C(2),2)
   s loc=$P(parr,$c(2),3)
   s User=$P(parr,$c(2),4)
   s arrang=$P(parr,$c(2),5)
   s ln=$L(arrang,$C(1))
   s stdate=$ZDH(stdate,3)
   s edate=$ZDH(edate,3)
   b
   for i=1:1:ln
   {
      s itm=$P(arrang,$C(1),i)
      s j=2
      s str=$P(itm,"^",1)
      s Nurse=$P(str,$C(3))
      s mem1=$P(str,$C(3),2)
      s mem2=$P(str,$C(3),3)
      for date=stdate:1:edate
      {
	    s post=$P(itm,"^",j)
	    s fg=$F(post,"/")
	    s j=j+1
	   // w !,post
	   // b //date
	    if (date=edate)&((mem1_"^"_mem2)'="^")
        { //插入备注
	               s smem=##class(User.DHCMGPersonArrange).getarrmem(Nurse,date)
	               if smem'=(mem1_"^"_mem2)
	               {
		               //s ^T(smem)=mem1_"^"_mem2
  		                   s a=##class(User.DHCMGPersonArrMem).%New()
                           s a.ARRPerDR=Nurse
                           s a.ARRDate=date
			               s a.ARRMem1=mem1_"^"_mem2
			              d a.%Save()
		           }
	    }else
	    {
		
			//  d ##class(User.DHCMGPersonArrMem).del(Nurse)
			i (date=edate)&(Nurse="7347") s ^tmoert523(1)=date_"^"_mem1_"^"_mem2
		 	if (date=edate)&((mem1="")!(mem2=""))
			{
				 s smem22=##class(User.DHCMGPersonArrange).getarrmem(Nurse,date)
				 i smem22'="" s aaabb=##class(User.DHCMGPersonArrMem).deldate(Nurse,date)
			}
		}
	    if fg'=0
	    {
		   //b //fg
		   s t=..savearrange(post,Nurse,date,loc,User)
		   
		   continue
		}
	    if post="" continue
	    s pp=$P(post,"|")
	    s mm=$P(post,"|",2)
        s parr=pp_"^"_Nurse_"^"_$ZD(date,3)_"^"_loc_"^"_User_"^"_mm
        s ret=##class(User.DHCMGPersonArrange).manulArrange1(parr)
       
	  }
   }
   q 0
}

ClassMethod savearrange(psts, Nurse, date, loc, User) As %String
{
		  s ll=$L(psts,"/")
		  s a=##class(User.DHCMGPersonArrange).ifexist(Nurse,$ZD(date,3))
          if a="1" q ""
		  for m=1:1:ll
		  {
		    s pt=$P(psts,"/",m)
		    //if pt="" continue
		    s pp=$P(pt,"|")
	        s mm=$P(pt,"|",2)
	        s parr=pp_"^"_Nurse_"^"_date_"^"_loc_"^"_User_"^"_mm
	        s ret=##class(User.DHCMGPersonArrange).ptarrange(parr)
		  }
  q 0
}

ClassMethod schpersonholdiday(person As %String, date As %String) As %String
{
 //查找某人某天是否有休假
     s flag="N"
     s tim=""  f  s tim=$O(^User.DHCMGPersonHolidayI("PersonDate"," "_person,tim)) q:tim=""!(flag="Y")  d
     .s rw="" f  s rw=$O(^User.DHCMGPersonHolidayI("PersonDate"," "_person,tim,rw)) q:rw=""!(flag="Y")  d
     ..s edt=$list(^User.DHCMGPersonHolidayD(rw),2)
     ..s fdt=$list(^User.DHCMGPersonHolidayD(rw),3)
     ..if (date'<fdt)&(date'>edt) s flag="Y"
     ..
     q flag
}

ClassMethod getdepholRec(parr As %String) As %String
{
  //按人汇总干过的岗位，各岗位的次数 ##class(web.DHCMGPerArrange).getdeparrange()
   // s parr="1082^2009-4-7^2009-4-23"
    s loc=$P(parr,"^",1)
    s stdate=$P(parr,"^",2)
    s edate=$P(parr,"^",3)
    s stdate=$ZDH(stdate,3)
    s edate=$ZDH(edate,3)
    if loc="" q ""
    s ret=..GetDepPerson(loc_"^"_stdate_"^"_edate)
    s ln=$L(ret,"^")
    for i=1:1:ln
    {
	  s str=$P(ret,"^",i)
	  s per=$P(str,"|",1)
	  if per="" continue
	  s MNur(i)=per
	  s MNurSort(per)=i
	   s hl="" f  s hl=$O(^User.DHCMGPersonHolidayI("PerHl"," "_per,hl)) q:hl=""  d
	    .s rw="" f  s rw=$O(^User.DHCMGPersonHolidayI("PerHl"," "_per,hl,rw)) q:rw=""  d
	    ..s arr=^User.DHCMGPersonHolidayD(rw)
	    ..s st=$List(arr,3)
	    ..s ed=$List(arr,2)
	    ..s hldr=$List(arr,4)
	    ..s hlmem=$List(arr,5)
	    ..s dnum=""
	    ..q:(ed<stdate)!(st>edate)
	    ..if (stdate'>st)&(edate'<ed) s dnum=(ed-st+1)
	    ..if (stdate>st)&(edate'<ed) s dnum=(ed-stdate+1)
	    ..if (stdate'>st)&(edate<ed)  s dnum=(edate-st+1)
	    ..if (stdate>st)&(edate<ed) s dnum=(edate-stdate)
	    ..if ((hlmem="A")!(hlmem="P")) s dnum=0.5
	    ..s perhol(per,hldr)=$G(perhol(per,hldr))+dnum
	    ..w !,per,"--",hldr,"--",dnum
	}
	//get科室所有岗位
    s holstr=..GetHoliday()
    s data=""
    s st=""  f  s st=$O(MNur(st)) q:st=""  d
    .s nur=MNur(st)
    .s parr=^User.DHCMGPersonsD(nur)
    .s name=$list(parr,21)
    .s ln=$L(holstr,"^")
    .s rwpst=""
    .f i=1:1:ln d
    ..s itm=$P(holstr,"^",i)
    ..q:itm=""
    ..s hldr=$P(itm,"|",1)
    ..s rwpst=rwpst_$G(perhol(nur,hldr))_"^"
    .s data=data_nur_"^"_name_"^"_rwpst_$C(2)
    s ^tmw23we4(1)=data
    
    q data
}

ClassMethod GetDutyDayRecord(parr) As %String
{
  //结假日补贴
   
   //s parr="1082^2009-3-15^2009-3-30"
    s loc=$P(parr,"^",1)
    s stdate=$P(parr,"^",2)
    s edate=$P(parr,"^",3)
    s stdate=$ZDH(stdate,3)
    s edate=$ZDH(edate,3)
    
    s ret=..GetDepPerson(loc_"^"_stdate_"^"_edate)
    
    s ln=$L(ret,"^")
    for i=1:1:ln
    {
	  s str=$P(ret,"^",i)
	  s per=$P(str,"|",1)
	  if per="" continue
	  s MNur(i)=per
	  s MNurSort(per)=i
    }
    f date=stdate:1:edate
    {
	    s par="" f  s par=$O(^User.DHCMGPersonArrangeI("DepDate"," "_loc,date,par)) q:par=""  d
	    .s arr=^User.DHCMGPersonArrangeD(par)
	    .s postdr=$List(arr,6)
	    .s hours=$list(^User.DHCMGPostD(postdr),5)
	    .if hours="" s hours=8
	    .s Nur=$List(arr,5)
	    .if $G(MNurPost(Nur))="" d
	    ..s MNurPost(Nur)=1
	    ..s MNurHours(Nur)=hours
	    .e  d
	    ..s MNurPost(Nur)=MNurPost(Nur) +1
	    ..s MNurHours(Nur)=MNurHours(Nur)+hours
    }
    s data=""
    s st=""  f  s st=$O(MNur(st)) q:st=""  d
    .s nur=MNur(st)
    .s parr=^User.DHCMGPersonsD(nur)
    .s name=$list(parr,21)
    .q:'$D(MNurPost(nur))
    .s data=data_name_"^"_nur_"^"_MNurPost(nur)_"^"_ MNurHours(nur)_"^^"_$C(2)
    q data
}

ClassMethod GetHistoryPerson(stdate, edate, PerArr)
{
}

ClassMethod getdeparrange(parr As %String) As %String
{
  //按人汇总干过的岗位，各岗位的次数 s a=##class(web.DHCMGPerArrange).getdeparrange()
   // s parr="945^2010-2-13^2010-02-18"
    s loc=$P(parr,"^",1)
    s stdate=$P(parr,"^",2)
    s edate=$P(parr,"^",3)
    s stdate=$ZDH(stdate,3)
    s edate=$ZDH(edate,3)
	if loc="" q ""
    
    s ret=..GetDepPerson(loc_"^"_stdate_"^"_edate)
    s ln=$L(ret,"^")
    s endI=0
    for i=1:1:ln
    {
	  s str=$P(ret,"^",i)
	  s per=$P(str,"|",1)
	  if per="" continue
	  s MNur(i)=per
	  s MNurSort(per)=i
	  s endI=i
	}
	//get科室所有岗位
	s poststr=##class(web.DHCMGPerArrange).GetPost(loc)
    f date=stdate:1:edate
    {
	    s par="" f  s par=$O(^User.DHCMGPersonArrangeI("DepDate"," "_loc,date,par)) q:par=""  d
	    .s arr=^User.DHCMGPersonArrangeD(par)
	    .s Nur=$List(arr,5)
	    .if '$D(MNurSort(Nur)) d
	    ..//显示历史存在数据
	    ..s endI=endI+1
	    ..s MNurSort(Nur)=endI
	    ..s MNur(endI)=Nur
	    ..b //lll
	    ..q:PostDr=""
	    .s PostDr=$List(arr,6)
	    .s flag=$List(arr,4)
	    .s num=1
	    .if ((flag="A")!(flag="P")) s num=0.5
	    .q:PostDr=""
	    .s Post=$List(^User.DHCMGPostD(PostDr),3)
	    .s pflag=$List(^User.DHCMGPostD(PostDr),7)
	    .s hours=$List(^User.DHCMGPostD(PostDr),10)
	    .if hours<6,hours'=0 s num=0.5 //20100419带教见习按次数统计
	    .if $G(MNurPost(Nur,PostDr))="" d
	    ..s MNurPost(Nur,PostDr)=num
	    .e  s MNurPost(Nur,PostDr)=MNurPost(Nur,PostDr) +num
	    .
	    .//s mnurdnum(Nur,)=$G(mnurdnum(Nur))+1
	    .//if pflag="Y" s nightdnum(Nur)=$G(nightdnum(Nur))+1
	    //	   . s sortno=..GetPerSortNo(rw)
    }
    b ///
    s data=""
    s st=""  f  s st=$O(MNur(st)) q:st=""  d
    .s nur=MNur(st)
    .s parr=^User.DHCMGPersonsD(nur)
    .s name=$list(parr,21)
    .s ln=$L(poststr,"^")
    .s rwpst=""
    .f i=1:1:ln d
    ..s itm=$P(poststr,"^",i)
    ..q:itm=""
    ..s pstdr=$P(itm,"|",1)
    ..s rwpst=rwpst_$G(MNurPost(nur,pstdr))_"^"
    .s data=data_nur_"^"_name_"^"_rwpst_$C(2)
    q data
}

ClassMethod getDepDateArr(parr As %String) As %String
{
  //查询每个科室 门诊,急诊   医生，护士，技师 人数
   //并可查询具体是谁.
   //按，科室 日期 科领导 值班人员
   s stdate=$P(parr,"^",1)
   s edate=$P(parr,"^",2)
    s stdate=$ZDH(stdate,3),edate=$ZDH(edate,3)
   
     f date=stdate:1:edate
    {
	    s loc="" f  s loc=$O(^User.DHCMGPersonArrangeI("DepDate",loc)) q:loc=""  d
	    .s par="" f  s par=$O(^User.DHCMGPersonArrangeI("DepDate",loc,date,par)) q:par=""  d
	    ..s arr=^User.DHCMGPersonArrangeD(par)
	    ..s per=$List(arr,5)
	    ..s Dep=$List(arr,3)
	    ..s post=$List(arr,6)
	    ..s parr=^User.DHCMGPersonsD(per)
        ..s name=$list(parr,21)
        ..s head=$list(parr,41)
        ..//s head=""
	    ..//s typ=$list(^User.DHCMGPostD(post),11)
	    ..//s pertyp=$P(^DHCMGPERSON("person",per),"^",19)
	    ..
	    ..if head="" s Marr(Dep,date)=$G(Marr(Dep,date))_name_","
	    ..if head'="" s Mast(Dep,date)=$G(Mast(Dep,date))_name_","
    }
    s ret=##class(web.DHCMGPERSON).GetSortDep("DOC")
    s ln=$L(ret,"^")
    s datatb=""
    for i=1:1:ln
    {
	   s itm=$P(ret,"^",i)

	   if itm="" continue
	   s dep=$P(itm,"|",1),depdes=$P(itm,"|",2)
	   f date=stdate:1:edate
       {
	       if '$D(Marr(dep,date)) s Marr(dep,date)=""
	   }
       
       s d=""  f  s d=$O(Marr(dep,d)) q:d=""  d
       .if Marr(dep,d)="" s Marr(dep)=$G(Marr(dep))_"^^"
       .e  s Marr(dep)=$G(Marr(dep))_$G(Mast(dep,d))_"^"_Marr(dep,d)_"^"
	   s datatb=datatb_dep_"^"_depdes_"^"_$G(Marr(dep))_$C(2)
	}
  q datatb
}

ClassMethod getdatearrange(parr As %String) As %String
{
  //查询每个科室 门诊,急诊   医生，护士，技师 人数
   //并可查询具体是谁.
   s stdate=$P(parr,"^",1)
   s edate=$P(parr,"^",2)
   s deptyp=$P(parr,"^",3)
   s flag=$P(parr,"^",4)
   s stdate=$ZDH(stdate,3),edate=$ZDH(edate,3)
    f date=stdate:1:edate
    {
	    s loc="" f  s loc=$O(^User.DHCMGPersonArrangeI("DepDate",loc)) q:loc=""  d
	    .s par="" f  s par=$O(^User.DHCMGPersonArrangeI("DepDate",loc,date,par)) q:par=""  d
	    ..s arr=^User.DHCMGPersonArrangeD(par)
	    ..s per=$List(arr,5)
	    ..s Dep=$List(arr,3)
	    ..q:$O(^User.DHCMGArrangPerSortI("TypDep"," "_deptyp," "_Dep,""))=""
	    ..s post=$List(arr,6)
	    ..s typ=$list(^User.DHCMGPostD(post),11)
	    ..s pertyp=$list(^User.DHCMGPersonsD(per),23)
	    ..s qualdate=$P(^User.DHCMGPersonsD(per),24) //取得职业资格时间
	    ..if (qualdate="")&(flag="N") q //职业资格
	    ..q:pertyp=""
	    ..s Marr(Dep,typ,pertyp)=$G(Marr(Dep,typ,pertyp))+1
	    ..s Marr(Dep,typ,pertyp,date,per)=""
	    ..s MarrTyp(typ,pertyp)=$G(MarrTyp(typ,pertyp))+1
	    ..s MarrDep(Dep)=$G(MarrDep(Dep))+1
	    ..s MarrSum=$G(MarrSum)+1
    }
    
    s ret=##class(web.DHCMGPERSON).GetSortDep(deptyp)
    s ln=$L(ret,"^")
    s cat=..gettypDr("岗位分类")
    s datatb=""
    for i=1:1:ln
    {
	   s itm=$P(ret,"^",i)
	   if itm="" continue
	   s rowdata=""
	   s dep=$P(itm,"|",1),depdes=$P(itm,"|",2)
	   s typ="" f  s typ=$O(^User.DHCMGCCodeI("Typ",cat,typ)) q:typ=""  d
	   .s pertyp="D"  s dataArr1=$G(Marr(dep,typ,pertyp))_"|"_$$getper(dep,typ,pertyp,.Marr)
	   .s pertyp="N" s dataArr2=$G(Marr(dep,typ,pertyp))_"|"_$$getper(dep,typ,pertyp,.Marr)
	   .s pertyp="T" s dataArr3=$G(Marr(dep,typ,pertyp))_"|"_$$getper(dep,typ,pertyp,.Marr)
	   .s rowdata=rowdata_dataArr1_"^"_dataArr2_"^"_dataArr3_"^"
	   s datatb=datatb_dep_"^"_depdes_"^"_rowdata_$G(MarrDep(dep))_$C(2)
	}
	  s rowdata=""
	  s typ="" f  s typ=$O(^User.DHCMGCCodeI("Typ",cat,typ)) q:typ=""  d
	   .s pertyp="D"  s dataArr1=$G(MarrTyp(typ,pertyp))_"|"_""
	   .s pertyp="N" s dataArr2=$G(MarrTyp(typ,pertyp))_"|"_""
	   .s pertyp="T" s dataArr3=$G(MarrTyp(typ,pertyp))_"|"_""
	   .s rowdata=rowdata_dataArr1_"^"_dataArr2_"^"_dataArr3_"^"
      b
       s datatb=datatb_""_"^"_"汇总"_"^"_rowdata_$G(MarrSum)_$C(2)
	 q datatb

getper(Dep,typ,pertyp,Marr)
  s rt=""
  s d="" f  s d=$O(Marr(Dep,typ,pertyp,d)) q:d=""  d
  . s p=""  f  s p=$O(Marr(Dep,typ,pertyp,d,p)) q:p=""  d
  ..s parr=^User.DHCMGPersonsD(p)
  ..s name=$list(parr,21)
  . .s rt=rt_name_" "
  q rt
}

ClassMethod ChekExam(parr As %String) As %String
{
 //检查是否够40小时
   s edate=$P(parr,"^",1)
   s loc=$P(parr,"^",2)
   s edate=$ZDH(edate,3)
   s stdate=edate-6
    f date=stdate:1:edate
    {
	    s par="" f  s par=$O(^User.DHCMGPersonArrangeI("DepDate"," "_loc,date,par)) q:par=""  d
	    .s arr=^User.DHCMGPersonArrangeD(par)
	    .s per=$List(arr,5)
	    .s post=$List(arr,6)
	    .s hour=$list(^User.DHCMGPostD(post),5)
	    .s mperworklen(per)=$G(mperworklen(per))+8
    }
    s ret=""
    s rw=""  f  s rw=$O(mperworklen(rw)) q:rw=""  d
    .i $G(mperworklen(rw))<40 d
	..s parr=^User.DHCMGPersonsD(rw)
    ..s name=$list(parr,21)
    ..s ret=ret_name_"^"
    q ret
}

ClassMethod getposttyp() As %String
{
   s cat=..gettypDr("岗位分类")
   s ret=""
   s typ="" f  s typ=$O(^User.DHCMGCCodeI("Typ",cat,typ)) q:typ=""  d
   .s typdes=$List(^User.DHCMGCCodeD(typ),3)
   .s ret=ret_typdes_"^"
   q ret
}

ClassMethod gettypDr(typ) As %String
{
	    s ret=""
	    s codetyp=""
	    s rw=""  f  s rw=$O(^User.DHCMGCodeTypD(rw)) q:(rw="")!(codetyp=typ)  d
	    .//s a=##class(User.DHCMGPost).%OpenId(rw)
	    .s codetyp=$List(^User.DHCMGCodeTypD(rw),3)
	    .if typ=codetyp s ret=rw
	    q ret
}

ClassMethod GetAuditDate(dep) As %String
{
 //获取审核的开始日期
    s id=""
    s date=""  f  s date=$O(^User.DHCMGAuditArrangeI("DepDate",dep,date),-1) q:(date="")!(id'="")  d
    .s rw=""  f  s rw=$O(^User.DHCMGAuditArrangeI("DepDate",dep,date,rw)) q:rw=""  d
    ..s id=rw
    s stdate=+$H
    if id'="" 
    {
	  s a=##class(User.DHCMGAuditArrange).%OpenId(id)
	  s stdate=a.AuditEdDate
	  s stdate=stdate+1 
	  b
	}else
	{
	   s date="" s date=$O(^User.DHCMGPersonArrangeI("DepDate"," "_dep,date))
       if date'="" s stdate=date
	}
	   s edate=""
	   s date="" s date=$O(^User.DHCMGPersonArrangeI("DepDate"," "_dep,date),-1)
       if date'="" s edate=date
	   if edate'="" s edate=$ZD(edate,3)
	   e  s edate=$ZD(+$H,3)
   q $ZD(stdate,3)_"^"_edate
}

ClassMethod getdepperpost(parr As %String) As %String
{
  //查看某天某岗位具体是谁
   //按人汇总干过的岗位，各岗位的次数 ##class(web.DHCMGPerArrange).getdepperpost()
   // s parr="1082^2009-3-15^2009-3-30"
    s loc=$P(parr,"^",1)
    s stdate=$P(parr,"^",2)
    s edate=$P(parr,"^",3)
    s stdate=$ZDH(stdate,3)
    s edate=$ZDH(edate,3)
	if loc="" q ""
    
    s ret=..GetDepPerson(loc_"^"_stdate_"^"_edate)
    s ln=$L(ret,"^")
    for i=1:1:ln
    {
	  s str=$P(ret,"^",i)
	  s per=$P(str,"|",1)
	  if per="" continue
	  s MNur(i)=per
	  s MNurSort(per)=i
	}
	//get科室所有岗位
   f date=stdate:1:edate
      {   
        s rw="" f  s rw=$O(^User.DHCMGPostI("Loc"," "_loc,rw)) q:rw=""  d
       .s a=^User.DHCMGPostD(rw)
       .s typ=$list(^User.DHCMGPostD(rw),11)
       .s MNurPost(typ,rw,date)=""
      }

    f date=stdate:1:edate
    {   
	    s par="" f  s par=$O(^User.DHCMGPersonArrangeI("DepDate"," "_loc,date,par)) q:par=""  d
	    .s arr=^User.DHCMGPersonArrangeD(par)
	    .s Nur=$List(arr,5)
	    .s PostDr=$List(arr,6)
	    .s parr=^User.DHCMGPersonsD(Nur)
        .s name=$list(parr,21)
        .q:PostDr=""
	    .s Post=$List(^User.DHCMGPostD(PostDr),3)
	    .s typ=$list(^User.DHCMGPostD(PostDr),11)
        .s pflag=$List(^User.DHCMGPostD(PostDr),7)
	    .if $G(MNurPost(typ,PostDr,date))="" d
	    ..s MNurPost(typ,PostDr,date)=name
	    .e  s MNurPost(typ,PostDr,date)=MNurPost(typ,PostDr,date)_"|"_name
	    .//s mnurdnum(Nur,)=$G(mnurdnum(Nur))+1
	    .//if pflag="Y" s nightdnum(Nur)=$G(nightdnum(Nur))+1
	    //	   . s sortno=..GetPerSortNo(rw)
    }
	    s data=""
	    s typ="" f  s typ=$O(MNurPost(typ)) q:typ=""  d
	    .s pst=""  f  s pst=$O(MNurPost(typ,pst)) q:pst=""  d
	    ..s post=$List(^User.DHCMGPostD(pst),3)
	    ..s ret=""
	    ..s date=""  f  s date=$O(MNurPost(typ,pst,date)) q:date=""  d
	    ...s ret=ret_$G(MNurPost(typ,pst,date))_$C(1)
	    ..s data=data_post_$C(1)_ret_$C(2)
	    
    q data
}

ClassMethod GetDepPerPlan(cols, planid) As %String
{
     //s a=##class(web.DHCMGPerArrange).GetDepPerPlan()
     s head="depid|科室|perid|姓名|曾轮转科室"
     s colwid="0|100|0|60|200"
     s ret=""
     if planid'=""
     {
	     s rw=""  f  s rw=$O(^User.DHCMGPerCyclePlanI("Plan",planid,rw)) q:rw=""  d
	    .s dep=$Listget(^User.DHCMGPerCyclePlanD(rw),2)
	    .s DepDes=$P(^CTLOC(dep),"^",2)
	    .s per=$Listget(^User.DHCMGPerCyclePlanD(rw),3)
		.s parr=^User.DHCMGPersonsD(per)
	    .s name=$list(parr,21)
	    .s olddep=..GetPerOldDep(per)
	    .s pos=$Listget(^User.DHCMGPerCyclePlanD(rw),10)
	    .s row=$P(pos,"|"),cl=$P(pos,"|",2)
	    .s TMP(row,cl)=dep_"^"_$P(DepDes,"-",2)_"^"_per_"^"_name_"^"_olddep
	    .s TmpDep(dep)="",TmpPerson(per)=""
     }
   s count=1
   s data=""
   s headtitl=""
   s colsize=""
   for j=0:1:(cols-1)
   { 
     s colsize=colsize_colwid_"|"
     s headtitl=headtitl_head_"|"
    for i=1:1:50 
    { 
       if '$D(TMP(i,j))
       {
        s rowdat="^^^^"
       }else
       {
	    s rowdat=TMP(i,j)
	   }
	   s data(i,j)=rowdat
	   s count=count+1
	}
   }
   s locdr=""
   s loc="" f  s loc=$O(TmpDep(loc)) q:loc=""  d
   .s locdr=locdr_loc_"^"
   s perdr=""
   s per=""  f  s per=$O(TmpPerson(per)) q:per=""  d
   .s perdr=perdr_per_"^"
   s tabdata=""
   s rw="" f  s rw=$O(data(rw)) q:rw=""  d
   .s tt=""
   .s cl="" f  s cl=$O(data(rw,cl)) q:cl=""  d
   ..s tt=tt_data(rw,cl)_"^"
   .s tabdata=tabdata_tt_$C(1)
   .w !,tt
   q locdr_$C(2)_perdr_$C(3)_headtitl_$C(2)_colsize_$C(2)_tabdata
}

ClassMethod GetPerOldDep(person)
{
    s ret=""
    s rw=""  f  s rw=$O(^User.DHCMGPerCyclePlanI("person",person,rw)) q:rw=""  d
    .s dep=$Listget(^User.DHCMGPerCyclePlanD(rw))
    .q:dep=""
    .s DepDes=$P(^CTLOC(dep),"^",2)
    .s ret=ret_DepDes_"|"
    q ret
}

/// Creator: 	wxl
/// CreatDate: 	2010-05-11
/// Description:节假日加班费申报
/// Table：		DHCMG_Persons,DHCMGC_PostCode,DHCMG_FeastDate,DHCMG_PersonOverRest
/// Input：		parr:(科室ID!开始日期!结束日期)
/// Return：	perwageno,pername,perpostcode,date,overtime,datenum,sign
/// 			工资号,姓名,职称,日期,加班时间,天数,签名
ClassMethod GetHolOvTimeExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//d ##class(%ResultSet).RunQuery("web.DHCMGPerArrange","GetHolOvTime","1^2010-05-11^2010-05-11")
 	s loc=$P(parr,"!",1)
    s stdate=$P(parr,"!",2)
    s edate=$P(parr,"!",3)
    s year=+stdate
    s yeardr=##class(User.DHCMGCCode).getcodedr(year,"年度")
    s stdate=$ZDH(stdate,3)
    s edate=$ZDH(edate,3)
    if loc="" q ""
    s i=0
    for curdate=stdate:1:edate
    {
		s feastflag=##class(User.DHCMGFeastDate).getfeastflag(curdate,yeardr)
	  	if feastflag'="Y" continue
	  	s rw=""  
		f  s rw=$O(^User.DHCMGPersonOverRestI("DepDate"," "_loc,curdate,rw)) q:rw=""  d
	  	.s a=^User.DHCMGPersonOverRestD(rw)
		.s per=$List(a,4)
	  	.q:per=""
	  	.s i=i+1
	  	.s MNurSort(per,rw)=i
	}
	s curper="" f  s curper=$O(MNurSort(curper)) q:curper=""  d
	.s currw="" f  s currw=$O(MNurSort(curper,currw)) q:currw=""  d
	..s parr=^User.DHCMGPersonsD(curper)
	..s perwageno=$listGet(parr,48)
	..s pername=$list(parr,21)
	..s perpostdr=$list(parr, 29)
	..i perpostdr'="" s perpostcode=$list(^User.DHCMGCPostCodeD(perpostdr), 3)
	..e  s perpostcode=""
	..s a=^User.DHCMGPersonOverRestD(currw)
	..s date=$List(a,2)
	..i date'="" s date=$zd(date,3)
	..e  s date=""
	..s overtime=$List(a,11)
	..s datenum=""
	..s sign=""
	..d OutRowtyp
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(perwageno,pername,perpostcode,date,overtime,datenum,sign)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetHolOvTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHolOvTimeExecute ]
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

ClassMethod GetHolOvTimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHolOvTimeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetHolOvTime(parr As %String) As %Query(ROWSPEC = "perwageno,pername,perpostcode,date,overtime,datenum,sign")
{
}

/// Creator: 	wxl
/// CreatDate: 	2010-05-11
/// Description:夜餐误餐补助申报
/// Table：		DHCMG_Persons,DHCMGC_PostCode
/// Input：		parr:(科室ID!开始日期!结束日期)
/// Return：	pername,nightnum,nightallowance,nightallowanceall,mealnum,mealallowance,mealallowanceall,allowanceall
/// 			姓名,夜餐补助次数,夜餐补助标准,夜餐补助小计,误餐补助次数,误餐补助标准,误餐补助小计,总计
ClassMethod GetAllowanceExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//d ##class(%ResultSet).RunQuery("web.DHCMGPerArrange","GetAllowance","1!2010-05-11!2010-05-11")
 	s loc=$P(parr,"!",1)
    s stdate=$P(parr,"!",2)
    s edate=$P(parr,"!",3)
    s stdate=$ZDH(stdate,3)
    s edate=$ZDH(edate,3)
    if loc="" q ""
    s i=0
    k MNurSort,nightdnum,mealdnum
    for curdate=stdate:1:edate
    {
	  	s rw=""  
		f  s rw=$O(^User.DHCMGPersonArrangeI("DepDate"," "_loc,curdate,rw)) q:rw=""  d
	  	.s arr=^User.DHCMGPersonArrangeD(rw)
		.s Nur=$List(arr,5)
		.q:Nur=""
		.s flag=$List(arr,4)
	    .s PostDr=$List(arr,6)
	    .s Post=$List(^User.DHCMGPostD(PostDr),3)
	    .s typ=$list(^User.DHCMGPostD(PostDr),11)
        .s pflag=$List(^User.DHCMGPostD(PostDr),7)
        .s hours=$List(^User.DHCMGPostD(PostDr),10)
		.q:pflag'="Y"
	    .i (flag="A")!(flag="P") s nightdnum(Nur)=$G(nightdnum(Nur))+0.5
	    .e  d
	    .if hours'="" d
	    ..if (hours>6) s nightdnum(Nur)=$G(nightdnum(Nur))+1
		..e  d
		...i hours'=0 s nightdnum(Nur)=$G(nightdnum(Nur))+0.5
		.i Post["小夜" d
		..i (flag="A")!(flag="P") s mealdnum(Nur)=$G(mealdnum(Nur))+0.5
	    ..e  d
	    ...if hours'="" d
	    ....if (hours>6) s mealdnum(Nur)=$G(mealdnum(Nur))+1
		....e  d
		.....i hours'=0 s mealdnum(Nur)=$G(mealdnum(Nur))+0.5
		.s MNurSort(Nur)=$g(nightdnum(Nur))_"^"_$g(mealdnum(Nur))
	}
	s curper="" f  s curper=$O(MNurSort(curper)) q:curper=""  d
	.s parr=^User.DHCMGPersonsD(curper)
	.s pername=$list(parr,21)
	.s nightnum=$p(MNurSort(curper),"^",1)
	.s nightallowance=""
	.s nightallowanceall=""
	.s mealnum=$p(MNurSort(curper),"^",2)
	.s mealallowance=""
	.s mealallowanceall=""
	.s allowanceall=nightallowanceall+mealallowanceall
	.d OutRowtyp
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(pername,nightnum,nightallowance,nightallowanceall,mealnum,mealallowance,mealallowanceall,allowanceall)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAllowanceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllowanceExecute ]
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

ClassMethod GetAllowanceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllowanceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetAllowance(parr As %String) As %Query(ROWSPEC = "pername,nightnum,nightallowance,nightallowanceall,mealnum,mealallowance,mealallowanceall,allowanceall")
{
}

/// Creator: 	wxl
/// CreatDate: 	2010-05-11
/// Description:打印休假统计
/// Table：		DHCMG_Persons,DHCMGC_PostCode
/// Input：		parr:(科室ID!开始日期!结束日期)
/// Return：	姓名|50|Name|^(假期代码维护)休|30|Itm1|^补休|30|Itm2|^
ClassMethod LookupDepHolRecExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//d ##class(%ResultSet).RunQuery("web.DHCMGPerArrange","LookupDepHolRec","1!2010-05-10!2010-05-16")
	s parr=$Tr(parr,"!","^")
	s loc=$P(parr,"^",1)
    s stdate=$P(parr,"^",2)
    s edate=$P(parr,"^",3)
    s stdate=$ZDH(stdate,3)
    s edate=$ZDH(edate,3)
    if loc="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s ret=..GetDepPerson(loc_"^"_stdate_"^"_edate)
    s ln=$L(ret,"^")
    for i=1:1:ln
    {
	  s str=$P(ret,"^",i)
	  s per=$P(str,"|",1)
	  if per="" continue
	  s MNur(i)=per
	  s MNurSort(per)=i
	   s hl="" f  s hl=$O(^User.DHCMGPersonHolidayI("PerHl"," "_per,hl)) q:hl=""  d
	    .s rw="" f  s rw=$O(^User.DHCMGPersonHolidayI("PerHl"," "_per,hl,rw)) q:rw=""  d
	    ..s arr=^User.DHCMGPersonHolidayD(rw)
	    ..s st=$List(arr,3)
	    ..s ed=$List(arr,2)
	    ..s hldr=$List(arr,4)
	    ..s dnum=""
	    ..q:(ed<stdate)!(st>edate)
	    ..if (stdate'>st)&(edate'<ed) s dnum=(ed-st+1)
	    ..if (stdate>st)&(edate'<ed) s dnum=(ed-stdate+1)
	    ..if (stdate'>st)&(edate<ed)  s dnum=(edate-st+1)
	    ..if (stdate>st)&(edate<ed) s dnum=(edate-stdate)
	    ..s perhol(per,hldr)=$G(perhol(per,hldr))+dnum
	}
	//get科室所有岗位
    s holstr=..GetHoliday()
    s headln=$L(holstr,"^")
   	s tablehead=""
	s rethead="姓名|60|Name|^"
 	for i=1:1:headln
 	{
	   s a=$P(holstr,"^",i)
	   if a="" continue
       s itmname=$p(a,"|",2)
       s WorkItm(a)=itmname
       s rethead=rethead_itmname_"|40|itm"_i_"|^"
       s $p(tablehead,"^",i)=""
	}
	s workstr=rethead
	d out3
    s st=""  f  s st=$O(MNur(st)) q:st=""  d
    .s nur=MNur(st)
    .s parr=^User.DHCMGPersonsD(nur)
    .s name=$list(parr,21)
    .s ln=$L(holstr,"^")
    .s rwpst=""
    .f i=1:1:ln d
    ..s itm=$P(holstr,"^",i)
    ..q:itm=""
    ..s hldr=$P(itm,"|",1)
    ..s rwpst=rwpst_$G(perhol(nur,hldr))_"^"
    .s workstr=name_"^"_rwpst
	.d out3	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
out3
	set Data=$lb(workstr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookupDepHolRecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookupDepHolRecExecute ]
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

ClassMethod LookupDepHolRecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookupDepHolRecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query LookupDepHolRec(parr As %String) As %Query(ROWSPEC = "itm")
{
}

ClassMethod GetArrangeHolYY(parr As %String) As %String
{
 //   // s parr="945^2010-2-13^2010-02-18"

  //取排班列表
 // s parr="945^2010-2-13^2010-02-18"
    s loc=$P(parr,"^",1)
    s stdate=$P(parr,"^",2)
    s edate=$P(parr,"^",3)
    s stdate=$ZDH(stdate,3)
    s edate=$ZDH(edate,3)
     s sttime=$P(parr,"^",4)
    s sttime=$ZtH(sttime,3)
    s endtime=$P(parr,"^",5)
    s endtime=$ZtH(endtime,3)
    s time1=""
    i sttime>endtime d
    .s time1=$zth("23:59:59",3) 
    s nurtyp=$P(parr,"^",6)
    
    
    
    s ret=..GetDepPerson(loc_"^"_stdate_"^"_edate)
    s ln=$L(ret,"^")
    s endI=0
    for i=1:1:ln
    {
	  s str=$P(ret,"^",i)
	  s per=$P(str,"|",1)
	  if per="" continue
	  s dnurtyp=$list(^User.DHCMGPersonsD(per), 23)
	  if (dnurtyp'=nurtyp)&(nurtyp'="" ) continue
	  s MNur(i)=per
	  s MNurSort(per)=i
	  s endI=i
	}
    f date=stdate:1:edate
    {
	    s par="" f  s par=$O(^User.DHCMGPersonArrangeI("DepDate"," "_loc,date,par)) q:par=""  d
	    .s arr=^User.DHCMGPersonArrangeD(par)
	    .s Nur=$List(arr,5)
	    .s dnurtyp=$list(^User.DHCMGPersonsD(Nur), 23)
     .q:(dnurtyp'=nurtyp)&(nurtyp'="" )
     .s arrdate=$List(arr,2)
	  	.if '$D(MNurSort(Nur)) d
	    ..//显示历史存在数据
	    ..s endI=endI+1
	    ..s MNurSort(Nur)=endI
	    ..s MNur(endI)=Nur
        .s PostDr=$List(arr,6)
	    .s flag=$List(arr,4)
	    .;i PostDr="" continue
	    .q:PostDr=""
	    .s Post=$List(^User.DHCMGPostD(PostDr),3)
	    .s pflag=$List(^User.DHCMGPostD(PostDr),7)
	    .s hours=$List(^User.DHCMGPostD(PostDr),10)
	    .s NightHour=$ListGet(^User.DHCMGPostD(PostDr),14)
	    .s cursttime=$ListGet(^User.DHCMGPostD(PostDr),15)
	    .s curendtime=$ListGet(^User.DHCMGPostD(PostDr),16)
	    .if $G(MNurPost(Nur,date))="" d
	    ..s MNurPost(Nur,date)=PostDr_"|"_flag
	    .e  s MNurPost(Nur,date)=MNurPost(Nur,date) _"+"_PostDr_"|"_flag
	    .s fullmnurdnum=$fn((hours/8),"",2)
	    .if (flag="A")!(flag="P") d
	    ..s mnurdnum(Nur)=$G(mnurdnum(Nur))+$fn((fullmnurdnum/2),"",2)
	    .e  d
	    ..s mnurdnum(Nur)=$G(mnurdnum(Nur))+$fn((fullmnurdnum),"",2)
	    .//
	    .i $D(Addnum(Nur))=0 s Addnum(Nur)=0
	    .i (arrdate=stdate)! (arrdate=edate) d
	    ..i curendtime>cursttime d
	    ...i curendtime> sttime d
	    ....i cursttime'>sttime d
	    .....s Addnum(Nur)=$fn(Addnum(Nur),"",1)+$fn(((curendtime-sttime)/3600),"",1)
	    ....i cursttime'<sttime d
	    .....s Addnum(Nur)=$fn(Addnum(Nur),"",1)+$fn(((curendtime-cursttime)/3600),"",1)
	    ..i curendtime<cursttime d
	    ...s temptime1=0,curendtime2=0
	    ...i cursttime<sttime d
	    ....s temptime1=$zth("23:59:59",3)-sttime
	    ....i curendtime'<endtime d
	    .....s temptime2=endtime
	    ....e  d
	    .....s temptime2=curendtime
	    ....s temptime=temptime1+temptime2 
	    ....s Addnum(Nur)=$fn(Addnum(Nur),"",1)+$fn((temptime/3600),"",1)
	    ...i cursttime'<sttime d
	    ....s temptime1=0,curendtime2=0
	    ....s temptime1=$zth("23:59:59",3)-cursttime
	    ....i curendtime'<endtime d
	    .....s temptime2=endtime
	    ....e  d
	    .....s temptime2=curendtime
	    ....s temptime=temptime1+temptime2 
	    ....s Addnum(Nur)=$fn(Addnum(Nur),"",1)+$fn((temptime/3600),"",1)
	    .i (arrdate>stdate)&(arrdate<edate) d
     ..s Addnum(Nur)= Addnum(Nur)+($G(mnurdnum(Nur))*8)
     ..s Addnum(Nur)=$fn(Addnum(Nur),"",1) 
	    .//w !,$G(nightdnum(Nur)),"Nur",Nur
	    //	   . s sortno=..GetPerSortNo(rw)


    }
   f date=stdate:1:edate
    {
	   s r="" f  s r=$O(MNur(r)) q:r=""  d
	   .if '$D(MNurPost(MNur(r),date))  s MNurPost(MNur(r),date)=""
    }

    s nur="" f  s nur=$O(MNurPost(nur)) q:nur=""  d
    .s ret=""
    .s date="" f  s date=$O(MNurPost(nur,date)) q:date=""  d
    ..
    ..s ret=ret_..getstr(MNurPost(nur,date))_"^"
    .s no=$G(MNurSort(nur))
    .q:no=""
    .s MNurArr(no,nur)=ret
    s ret=""
    s no="" f  s no=$O(MNurArr(no)) q:no=""  d
    .s nur=""  f  s nur=$O(MNurArr(no,nur)) q:nur=""  d
    ..s parr=^User.DHCMGPersonsD(nur)
    ..s nurse=$list(parr,21)
    ..s PerGrpDr=$O(^User.DHCMGGroupPersonsI("Person"," "_nur,"")) 
    ..i PerGrpDr'="" d
    ...s Grp=$g(^User.DHCMGGroupPersonsD(PerGrpDr))
    ...s GrpDr=$list(Grp,2)
    ...i GrpDr'="" d
    ....s GrpDesc=$list($g(^User.DHCMGCGroupD(GrpDr)),3)
	....s nurse=nurse_"("_GrpDesc_")"		//20100422护士分组显示在姓名后面
    ..s catid=$listGet(parr,45)				//可能是负值?
    ..i catid>0 s color=##class(User.DHCMGCCode).GetPertypColor(catid)
    ..e  s color=""
    ..s memstr=##class(User.DHCMGPersonArrange).getarrmem(nur,edate)
    ..s m1=$P(memstr,"^"),m2=$P(memstr,"^",2)
    ..//s subnur=..GetSubPerson(nur,stdate,loc)
    ..//s subnurse=""
    ..//if subnur'="" s subnurse=$list(^User.DHCMGPersonsD(subnur),21)
    ..i $G(mnurdnum(nur))'="" s mnurdnum(nur)=$fn($G(mnurdnum(nur)),"",2)
    ..;s ret=ret_nur_$C(3)_color_"^"_nurse_$C(3)_$G(nur)_"^"_MNurArr(no,nur)_m1_"^"_m2_"^"_$G(mnurdnum(nur))_"^"_$G(nightdnum(nur))_$C(1)
    ..s ret=ret_nur_$C(3)_color_"^"_nurse_$C(3)_$G(nur)_"^"_MNurArr(no,nur)_$G(mnurdnum(nur))_"^"_$G(Addnum(nur))_$C(1)
 q ret
}

/// 取夜班护士
/// d ##class(web.DHCMGPerArrange).GetArrangeYNurse("1018^2013-06-27")
/// 
ClassMethod GetArrangeYNurse(parr As %String) As %String
{
  // s parr="868^2010-05-17^2010-05-23"
  //取排班列表
 // s parr="945^2010-2-13^2010-02-18"
    //s ^okkktmp=parr
    //s parr="1105^2013-07-08"
    s loc=$P(parr,"^",1)
    s stdate=$P(parr,"^",2)
    s edate=$P(parr,"^",2)
    s stdate=$ZDH(stdate,3)
    s edate=$ZDH(edate,3)
    s ret=..GetDepPerson(loc_"^"_stdate_"^"_edate)
    s ln=$L(ret,"^")
    s endI=0
    for i=1:1:ln
    {
	  s str=$P(ret,"^",i)
	  s per=$P(str,"|",1)
	  if per="" continue
	  s MNur(i)=per
	  s MNurSort(per)=i
	  s endI=i
	}
    f date=stdate:1:edate
    {
	    s par="" f  s par=$O(^User.DHCMGPersonArrangeI("DepDate"," "_loc,date,par)) q:par=""  d
	    .s arr=^User.DHCMGPersonArrangeD(par)
	    .s Nur=$List(arr,5)
	    .;if Nur=4871 w !,arr
	  	.if '$D(MNurSort(Nur)) d
	    ..//显示历史存在数据
	    ..s endI=endI+1
	    ..s MNurSort(Nur)=endI
	    ..s MNur(endI)=Nur
        .s PostDr=$List(arr,6)
	    .s flag=$List(arr,4)
	    .//if Nur=4871 w !,PosDr
	    .q:'$D(^User.DHCMGPostD(PostDr))
	    .s Post=$List(^User.DHCMGPostD(PostDr),3)
	    .s pflag=$List(^User.DHCMGPostD(PostDr),7)
	    .s hours=$List(^User.DHCMGPostD(PostDr),10)
	    .
	    .if $G(MNurPost(Nur,date))="" d
	    ..s MNurPost(Nur,date)=PostDr_"|"_flag
	    .e  s MNurPost(Nur,date)=MNurPost(Nur,date) _"+"_PostDr_"|"_flag
	    .if (flag="A")!(flag="P") d
	    ..s mnurdnum(Nur)=$G(mnurdnum(Nur))+0.5
	    .e  d
	    ..if (hours>6) d
	    ...s mnurdnum(Nur)=$G(mnurdnum(Nur))+1
	    ..e  d
        ...if hours'="",hours'=0 s mnurdnum(Nur)=$G(mnurdnum(Nur))+0.5
	    .if pflag="Y" d
	    ..if (flag="A")!(flag="P") s nightdnum(Nur)=$G(nightdnum(Nur))+0.5
	    ..e  d
	    ..if hours'="" d
	    ...if (hours>6) s nightdnum(Nur)=$G(nightdnum(Nur))+1
		...e  d
		....i hours'=0 s nightdnum(Nur)=$G(nightdnum(Nur))+0.5
	    .//w !,$G(nightdnum(Nur)),"Nur",Nur
	    //	   . s sortno=..GetPerSortNo(rw)
    }
   // b ;01
   f date=stdate:1:edate
    {
	   s r="" f  s r=$O(MNur(r)) q:r=""  d
	   .if '$D(MNurPost(MNur(r),date))  s MNurPost(MNur(r),date)=""
    }

    s nur="" f  s nur=$O(MNurPost(nur)) q:nur=""  d
    .s ret=""
    .s date="" f  s date=$O(MNurPost(nur,date)) q:date=""  d
    ..
    ..s ret=ret_..getstr(MNurPost(nur,date))_"^"_..ifhaveyb(MNurPost(nur,date))
    .s no=$G(MNurSort(nur))
    .q:no=""
    .;b ;01
    .i $d(PostDr)'=0  s pflag=$List($g(^User.DHCMGPostD(PostDr)),7)
    .;s pflag=$List($g(^User.DHCMGPostD(PostDr)),7)   //2013-7-5
    .s MNurArr(no,nur)=ret
    s ret=""
    //b ;33
    s no="" f  s no=$O(MNurArr(no)) q:no=""  d
    .s nur=""  f  s nur=$O(MNurArr(no,nur)) q:nur=""  d
    ..s parr=^User.DHCMGPersonsD(nur)
    ..s nurse=$list(parr,21)
    ..s catid=$listGet(parr,45)
    ..s flagyb=$p(MNurArr(no,nur),"^",2)
    ..q:flagyb'=1
    ..//2013-07-05区分大小夜班
    ..s hour=$p($h,",",2)  //取当前 时
    ..;s hour=79800
    ..;b ;12
    ..s NurTyp1=$tr($p(MNurArr(no,nur),"^",1),"——","-")
    ..i (hour<79200)&&(hour>54000) q:NurTyp1'["3-10"   //小夜
    ..i (hour>79200)||(hour<28800) q:NurTyp1'["10-8"   //大夜
    ..s color=##class(User.DHCMGCCode).GetPertypColor(catid)
    ..s memstr=##class(User.DHCMGPersonArrange).getarrmem(nur,edate)
    ..s m1=$P(memstr,"^"),m2=$P(memstr,"^",2)
    ..s subnur=..GetSubPerson(nur,stdate,loc)
    ..s subnurse=""
    ..if subnur'="" s subnurse=$list(^User.DHCMGPersonsD(subnur),21)
    ..i ret="" s ret=nurse //_"&"_$G(subnurse)
    ..e  s ret=ret_"^"_nurse  //_"&"_$G(subnurse)
    ..//s ret=ret_nur_$C(3)_color_"^"_nurse_$C(3)_$G(subnurse)_"^"_MNurArr(no,nur)_m1_"^"_m2_"^"_$G(mnurdnum(nur))_"^"_$G(nightdnum(nur))_$C(1)
 	//b ;03
 s ret=$tr(ret,"^",";")
 ;s ret="aaa;ddd"
 q ret
}

ClassMethod ifhaveyb(pstr) As %String
{
    s ln=$L(pstr,"+")
    s nigpt=""
    s ret=""
    for i=1:1:ln
    {
 	   s pst=$P(pstr,"+",i)
 	   s pt=$P(pst,"|")
 	   s flag=$P(pst,"|",2)
 	   q:pt=""
 	   s p=##class(User.DHCMGPost).%OpenId(pt)
 	   i p.PostFlag="Y" s ret=1
 	   q:ret=1
    }
   q ret
}

}
