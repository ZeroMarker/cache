Class web.DHCNurAssComm Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

// 根据维护项每日评估表中插入数据

// w ##class(web.DHCNurAssComm).InsertData("DHCNURXHNEWRYPG","50","PGD")

// w ##class(web.DHCNurAssComm).InsertData("DHCNURXH_WKHLJL","774","BG")

ClassMethod InsertData(EmrCode, Adm, type) As %String
{
	 s ^nurasscomm(EmrCode, Adm, type)=""
	 s EmrCode=$zcvt(EmrCode,"U")
	 s DatePGB="DHCNURPL_PG"
	 k arrcode
	 s linkflag=""
	 s itm="" f  s itm=$O(^Nur.DHCNurLinkAssI("Code"," "_EmrCode,itm)) q:itm=""  d
	 .s id="" f  s id=$O(^Nur.DHCNurLinkAssI("Code"," "_EmrCode,itm,id)) q:id=""  d
	 ..s a=##class(Nur.DHCNurLinkAss).%OpenId(id)
	 ..s assid=a.AssId
	 ..s obj=##class(Nur.DHCNurAssess).%OpenId(assid)
	 ..s code=a.ItemCode
	 ..s linkflag=1
	 ..i '$d(arrcode(code)) s arrcode(code)=assid
	 
	 q:linkflag="" ""
	 k arrpgcode  //取每日评估表戈登对应项目
	 s itm="" f  s itm=$O(^Nur.DHCNurLinkAssI("Code"," "_DatePGB,itm)) q:itm=""  d
	 .s id="" f  s id=$O(^Nur.DHCNurLinkAssI("Code"," "_DatePGB,itm,id)) q:id=""  d
	 ..s a=##class(Nur.DHCNurLinkAss).%OpenId(id)
	 ..s code=a.Cate
	 ..q:code=""
	 ..i '$d(arrpgcode(code)) s arrpgcode(code)=a.ItemCode
	 b ;333
	 i type="PGD" //评估单取数据插入
	 {
	   k pgdarr
	   s rw=$O(^Nur.DHCMoudDataI("EmrCode"," "_EmrCode," "_Adm,""))
	   q:rw=""
	   s pobj=##class(Nur.DHCMoudData).%OpenId(rw)
	   q:pobj="" 0
	   s k=""  f  s k=$o(arrcode(k)) q:k=""  d
	   .s gditmid=arrcode(k) //标准元素表id
	   .s val=$ZOBJPROPERTY(pobj,k)
	   .s flag=..ifinsert(gditmid,val)
	   .i flag=1  d
	   ..s obj=##class(Nur.DHCNurAssess).%OpenId(gditmid)
	   ..s bzcate=obj.AssCat
	   ..s name=..getitmname(EmrCode,k)
	   ..//b ;22
	   ..i '$d(pgdarr(bzcate)) s pgdarr(bzcate)=name_":"_val
	   ..e  s pgdarr(bzcate)=pgdarr(bzcate)_", "_name_":"_val
	   b ;inser
       d ..savepgdata(Adm,.pgdarr,.arrpgcode,type)
	 }
	 if (type="BG") //表格类记录单
	 {
		s date=+$h
		k bgarr
		s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_Adm,""))
        if par="" q ""
		s tim="" f  s tim=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_EmrCode,date,tim),-1) q:tim=""  d
        .s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_EmrCode,date,tim,par,rw),-1) q:rw=""  d
        ..s ids=par_"||"_rw
        ..s b=##class(Nur.DHCNurseRecSub).%OpenId(ids)
        ..s headdr=b.HeadDR  //表头
        
        ..//B ;001
        ..s k=""  f  s k=$o(arrcode(k)) q:k=""  d
        ...s val=$ZOBJPROPERTY(b,k)
        ...i headdr=""  d //不是表头变更记录列
	    ....s gditmid=arrcode(k) //标准元素表id
	    ....s flag=..ifinsert(gditmid,val)
	    ....i flag=1  d
	    .....s obj=##class(Nur.DHCNurAssess).%OpenId(gditmid)
	    ....s bzcate=obj.AssCat
	    ....s name=..getitmname(EmrCode,k)
	    ....i '$d(bgarr(bzcate)) s bgarr(bzcate)=name_":"_val
	    ....e  s bgarr(bzcate)=bgarr(bzcate)_", "_name_":"_val
	    
	    ...i headdr'=""  d //是表头变更记录
	    ....s hid=$p(headdr,"_")_"||"_$p(headdr,"_",2)
	    ....s obj=##class(Nur.DHCNurRecHeadChangeRec).%OpenId(hid)
	    ....s name=$ZOBJPROPERTY(obj,k)
	    ....//b ;002
	    ....i name'=""  d  //取表头记录里的表头名称
	    .....s hrw=$O(^Nur.DHCNurHeadKnowledgeI("Head"," "_name,"")) //表头维护表
	    .....i hrw'=""   d
	    ......s objK=##class(Nur.DHCNurHeadKnowledge).%OpenId(hrw)
	    ......s assid=objK.LinkAss
	    ......i assid'=""  D
	    .......//b ;0002
	    .......s flag=..ifinsert(assid,val)
	    .......//b ;003
	    .......I flag=1  d  //阳性
	    ........s objC=##class(Nur.DHCNurAssess).%OpenId(objK.LinkAss)
	    ........s bzcate=objC.AssCat
	    ........i '$d(bgarr(bzcate)) s bgarr(bzcate)=name_":"_val
	    ........e  s bgarr(bzcate)=bgarr(bzcate)_", "_name_":"_val
	    ....i name=""  d //取非表头变换列数据
	    .....s gditmid=arrcode(k) //标准元素表id
	    .....s flag=..ifinsert(gditmid,val)
	    .....i flag=1  d
	    ......s obj=##class(Nur.DHCNurAssess).%OpenId(gditmid)
	    ......s bzcate=obj.AssCat
	    ......s name=..getitmname(EmrCode,k)
	    ......b ;002
	    ......i '$d(bgarr(bzcate)) s bgarr(bzcate)=name_":"_val
	    ......e  s bgarr(bzcate)=bgarr(bzcate)_", "_name_":"_val
	    b ;
	    d ..savepgdata(Adm,.bgarr,.arrpgcode,type)
	 }
	 q 0
}

// 往每日评估表存数据

ClassMethod savepgdata(Adm, data, arrpgcode, type) As %String
{
       s AdmDate=$ZD($p($g(^PAADM(Adm)),"^",6),3) //入院日期
       i type="BG" s AdmDate=$zd(+$h,3)
       s papmiId=+^PAADM(Adm)
	   s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	   s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	   s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
       s age=..CalAge(birth,+$h)
       s age=$p(age,"Y",1)
       s ctlocId=$p(^PAADM(Adm),"^",4)
	   s ctlocDesc=$p(^CTLOC(+ctlocId),"^",2)	
	   i ctlocDesc["-"  s ctlocDesc=$P(ctlocDesc,"-",2)
       s rowidflag=""
       b ;00
       s p="" f  s p=$O(^Nur.DHCMoudDataI("EmrCode"," "_DatePGB," "_Adm,p)) q:p=""  d
	   .s a=##class(Nur.DHCMoudData).%OpenId(p)
	   .q:a=""
	   .s date=a.Item100 //评估日期
	   .i (date=AdmDate)  d 
	   ..s rw=""  f  s rw=$o(arrpgcode(rw)) q:rw=""  d
	   ...i $d(data(rw))  d
	   ....s itm=arrpgcode(rw)
	   ....q:itm=""
	   ....s $ZOBJPROPERTY(a,itm)=data(rw)
	   ...e  d
	   ....s itm=arrpgcode(rw)
	   ....q:itm=""
	   ....s $ZOBJPROPERTY(a,itm)=""
	   ..s rowidflag=1
	   ..s a.Status=""
	   .i a.Item1="" s a.Item1=patName
	   .i a.Item2="" s a.Item2=sex
	   .i a.Item3="" s a.Item3=age
	   .i a.Item4="" s a.Item4=ctlocDesc
	   .d a.%Save()
	   b ;66
	   i rowidflag=""  d
	   .s a=##class(Nur.DHCMoudData).%New()
	   .s a.EmrCode=DatePGB
	   .s a.EpisodeId=Adm
	   .s rw=""  f  s rw=$o(arrpgcode(rw)) q:rw=""  d
	   ..i $d(data(rw))  d
	   ...s itm=arrpgcode(rw)
	   ...q:itm=""
	   ...s $ZOBJPROPERTY(a,itm)=data(rw)
	   ...s rowidflag=1
	   ...s a.Item100=AdmDate
	   ...//b ;002
	   ..e  d //取消阳性体征的删除记录
	   ...s itm=arrpgcode(rw)
	   ...q:itm=""
	   ...s $ZOBJPROPERTY(a,itm)=""
	   ...s rowidflag=1
	   .s a.Item1=patName
	   .s a.Item2=sex
	   .s a.Item3=age
	   .s a.Item4=ctlocDesc
	   .i rowidflag'="" d a.%Save()
}

/// 根据出生日计算年龄
ClassMethod CalAge(IBirth As %String, IToday As %String)
{
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$g(IBirth) ""
    s XBirth=$zd(IBirth)
    s XToday=$zd(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $p(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
}

// w ##class(web.DHCNurAssComm).ifinsert("17","堵塞")

ClassMethod ifinsert(itmid, val) As %String
{
	  s ret=""
	  s obj=##class(Nur.DHCNurAssess).%OpenId(itmid)
	  s asstype=obj.AssType //数据类型
	  i asstype="数字" d
	  .s AssRange=obj.AssPositiveRange //阳性范围
	  .i AssRange[">"  d
	  ..s rval=$p(AssRange,">",2)
	  ..i val>rval  s ret=1
	  .i AssRange["<"  d
	  ..s rval=$p(AssRange,"<",2)
	  ..i val<rval  s ret=1
	  .i AssRange["-"  d
	  ..s rval=$p(AssRange,"-",1)
	  ..s rval2=$p(AssRange,"-",2)
	  ..i (val>rval)&(val<rval2)  s ret=1
	  i asstype="文本" d
	  .s chl=""  f  s chl=$O(^Nur.DHCNurAssessD(itmid,"ChildRec",chl)) q:(chl="")!(ret=1)  d
 	  ..s a=##class(Nur.DHCNurAssessItem).%OpenId(itmid_"||"_chl)
 	  ..s ItmCode=a.ItmCode
 	  ..s ItmFlag=a.ItmFlag 
 	  ..//b ;44
 	  ..i (ItmFlag="Y")&&(val[ItmCode) s ret=1
 	  q ret
}

// 模板某列的名称

// w ##Class(web.DHCNurAssComm).getitmname("DHCNURXH_WKHLJL","Item6")

ClassMethod getitmname(code, initm) As %String
{
	   n (code,initm)
	   s name=""
	   s Tstr=""
	   /*
	   i headdr'=""  d
	   .s headid=$p(headdr,"_")_"||"_$p(headdr,"_",2)
	   .s objhead=##CLASS(Nur.DHCNurRecHeadChangeRec).%OpenId(headid)
	   .q:objhead=""
	   .s name=$ZOBJPROPERTY(objhead,initm)
	   q:name'="" name
	   */
	   s str=##class(NurEmr.NurEmrSub).GetKCode(code)
       if str="" s str=##class(NurEmr.NurEmrSub).getData(code)
       s Data=""
       if str'=""   
	   {
		S ITM=##CLASS(NurEmr.NurEmrSub).%OpenId(str)
		s Data=ITM.EmrSubData
		s title=ITM.EmrSubDesc
	   }
	   d Data.Rewind()
	   s itmRelName=""
	   s Reader=##class(web.DHCNUREMR).GetReader(code,Data)
	 	while Reader.Read()
	{
		if Reader.Name="MetaData"
	    {
		   s aa=""
		   if Reader.MoveToAttributeName("Link") s aa=Reader.Value
           if aa'=""
           {
	           s cls=$P(aa,"^"),mth=$P(aa,"^",2)
	           s p=$P(aa,"^",3)
	           s arr=$P(aa,"^",4)
	           //if p="Adm" s p=p_":"_EpisodeId
	           if p="AnaesID" s p=p_":"_AnaesID
	           s pdata=""
	          // if EpisodeId'=""
	          // {
	          //  d ..getpdata(cls,mth,p,.pdata,arr)
	          // }
           }
		   while Reader.Read()
           {
	      	  if (Reader.Name="MetaData")&(Reader.NodeType="endelement")  q
              s itmname=Reader.Name
	   	      if ($E(Reader.Name,0,1)="M")!($E(Reader.Name,0,1)="O")
	   	       {
	          	 if Reader.MoveToAttributeName("RelName") s itmRelName(code,itmname)=Reader.Value
 		         if Reader.MoveToAttributeName("Link") s itmLinkName(code,itmname)=Reader.Value
                 if Reader.MoveToAttributeName("Title") s itmTitle(code,itmname)=Reader.Value
                s itm=..getitm(.Reader,itmname,.itmdata,code)
	   	       }
              s xname=Reader.Name
	          if Reader.MoveToAttributeName("RelName") s itmRelName(code,xname)=Reader.Value
		      if Reader.MoveToAttributeName("Link") s itmLinkName(code,xname)=Reader.Value
		      if Reader.MoveToAttributeName("Title") s itmTitle(code,xname)=Reader.Value
		      if Reader.MoveToAttributeName("Edit") s itmEdit(code,xname)=Reader.Value
		      if Reader.MoveToAttributeName("hidden") 
		      {
			      s itmHidd(code,xname)=Reader.Value
			      if ((Reader.Value="Y")&($E(xname,0,1)="S"))
			      {
				       s itmdata(code,xname)=""
			      }
		      }
              if ($E(xname,0,1)="T")
	          {
		          s title=""
			      while Reader.Read()
			      {
         		     if (Reader.Name=xname)&(Reader.NodeType="endelement")  q
		             s colname=Reader.Name
		             s itmtable(code,colname)=""

                   if ($E(Reader.Name,0,1)="M")!($E(Reader.Name,0,1)="O")
				     {	
				         if Reader.NodeType="endelement" continue
				     	 if (Reader.MoveToAttributeName("Title")) s head=Reader.Value
	            	     if Reader.MoveToAttributeName("Link") s itmLinkName(code,colname)=Reader.Value

		                 if Reader.MoveToAttributeName("RelName") s Relname=Reader.Value
		                 if Reader.MoveToAttributeName("Pos") s Pos=Reader.Value
		                 s title=title_$G(head)_"!"_$G(Relname)_"!"_colname_"!"_$G(Pos)_"^"
			             if Reader.NodeType'="endelement" s itm=..getitm(.Reader,colname,.itmdata,code)
					 }else{
						 if Reader.NodeType="endelement" continue
				     	 if (Reader.MoveToAttributeName("Title")) s head=Reader.Value
		                 if Reader.MoveToAttributeName("RelName") s Relname=Reader.Value
		                 if Reader.MoveToAttributeName("Pos") s Pos=Reader.Value
		                 s title=title_$G(head)_"!"_$G(Relname)_"!"_colname_"!"_$G(Pos)_"^"
					 }
				         if (Reader.MoveToAttributeName("DateFlag"))
				        {
					       if Reader.Value="Y" s itmdata(code,colname)=Reader.Value_"^D"
					    }
					    if (Reader.MoveToAttributeName("TimeFlag"))
				        {
					       if Reader.Value="Y" s itmdata(code,colname)=Reader.Value_"^T"
					   
					    }

				  }
				  i Tstr=""  s Tstr=title
				  e  s Tstr=Tstr_"^"_title
			      s itmdata(code,xname)=title  
		     }
              if ($E(xname,0,1)="D")
	          {
		        if (Reader.MoveToAttributeName("DateFlag"))
		        {
			       if Reader.Value="Y" s itmdata(code,xname)=Reader.Value_"^D"
			   
			    }
			    if (Reader.MoveToAttributeName("TimeFlag"))
		        {
			       if Reader.Value="Y" s itmdata(code,xname)=Reader.Value_"^T"
			    }
		      }
	       }

		}
		if Reader.Name="InstanceData"
		{
		   while Reader.Read()
		   {
		      s itmname=Reader.Name
		      if itmname="" continue
		
			      s lb=$E(itmname,0,1)
			      if Reader.MoveToAttributeName("left") s x1= Reader.Value
				  if Reader.MoveToAttributeName("top") s y1= Reader.Value
				  if (itmname'["Label") d
                  .s itmxy(x1,y1)=itmname
			      if lb="O"
			      {
				     // b //ooooo(注:总分<=17分,可上报不可避免压疮)
				    if (Reader.MoveToAttributeName("selecttext"))
				    {
					 // if itmdataVal(code,itmname)'="" s itmdataVal(code,itmname)=itmdataVal(code,itmname)_"@"_Reader.Value
					 s itmdataVal(code,itmname)=Reader.Value
					 // b ///----0
					}else{
						s itmdataVal(code,itmname)=$G(itmdataVal(code,itmname))
						}
				  }
                  if lb="I"
			      {
				     if (Reader.MoveToAttributeName("SelectItm"))
				     {
					  s itmdataVal(code,itmname)=Reader.Value
					 }
				  }
                  if lb="M"
			      {
				     if (Reader.MoveToAttributeName("selectItm"))
				     {
					  if $G(itmdataVal(code,itmname))'="" s itmdataVal(code,itmname)=Reader.Value
					  e  s itmdataVal(code,itmname)=Reader.Value
					 }else{
						 s itmdataVal(code,itmname)=$G(itmdataVal(code,itmname))
						 }
                   // b ///Mb不可避免压疮上报表
				  }
                  if lb="D"
			      {
				     if (Reader.MoveToAttributeName("DateTimeVal"))
				     {
					     
				      s aa=Reader.Value
				      s aa=$TR(aa,"^"," ")
					  s itmdataVal(code,itmname)=aa
					 // b  //???
					 }else{
						// s itmdata(code,itmname)=$ZD(+$H,3)
						// b ////////////ds
						 }
                    
				  }
                  if lb="S"
			      {
				     
				     if (Reader.MoveToAttributeName("text"))
				     {
					  s itmdataVal(code,itmname)=Reader.Value
					 }
				  }

			      if lb="G"
			      {
				         s str=""
						 if Reader.MoveToAttributeName("type") s typ= Reader.Value
					     if Reader.MoveToAttributeName("tabindex") s tab= Reader.Value
					     if Reader.MoveToAttributeName("left") s x= Reader.Value
					     if Reader.MoveToAttributeName("top") s y= Reader.Value
					     if Reader.MoveToAttributeName("width") s w= Reader.Value
					     if Reader.MoveToAttributeName("height") s h= Reader.Value
						 if Reader.MoveToAttributeName("text") s text= Reader.Value
						 if $G(itmdata(code,itmname))'="" s itmdata(code,itmname)=itmdata(code,itmname)_"@"_typ_"^"_x_"^"_y_"^"_h_"^"_w_"^"_text_"^"_tab
						 e  s itmdata(code,itmname)=typ_"^"_x_"^"_y_"^"_h_"^"_w_"^"_text_"^"_tab
				    	   while Reader.Read()
		                   { 
		                    if (Reader.Name=itmname)&(Reader.NodeType="endelement")  q
		                     s lb=$E(Reader.Name,0,1)
		                   //	w !,Reader.Name
                             if lb="F"
		                     {
			                   s str=str_..getfree(Reader,Reader.Name)
			                 
			                 }
			                if lb="S"
			                 {
				                   if (Reader.MoveToAttributeName("Value"))
				                    {
					                    s str=str_Reader.Value
					                }else{
						            }
				             }
		                     if lb="O"
			                 {
				                   if (Reader.MoveToAttributeName("Value"))
				                    {
					                    s str=str_Reader.Value
					                }else{
						            }
				             }
		                     if lb="M"
			                 {
				                   if (Reader.MoveToAttributeName("Value"))
				                    {
					                    s str=str_Reader.Value
					                }else{
						            }
				             }
		                   if lb="N"
			                 {
				                   if (Reader.MoveToAttributeName("Value"))
				                    {
					                    s str=str_Reader.Value
					                }else{
						            }
				             }

			                 s itmdataVal(code,itmname)=str
		                   }
		                   
			      }
		      
              if ($E(itmname,0,1)="T") 
              {
                 // s typ=Reader.Value
			     if Reader.MoveToAttributeName("type") s typ= Reader.Value
			     if Reader.MoveToAttributeName("tabindex") s tab= Reader.Value
			     if Reader.MoveToAttributeName("left") s x= Reader.Value
			     if Reader.MoveToAttributeName("top") s y= Reader.Value
			     if Reader.MoveToAttributeName("width") s w= Reader.Value
			     if Reader.MoveToAttributeName("height") s h= Reader.Value
				 if Reader.MoveToAttributeName("text") s text= Reader.Value
				 //b  //table
				 if $G(itmdata(code,itmname))'="" s itmdata(code,itmname)=itmdata(code,itmname)_"@"_typ_"^"_x_"^"_y_"^"_h_"^"_w_"^"_text_"^"_tab
				 e  s itmdata(code,itmname)=typ_"^"_x_"^"_y_"^"_h_"^"_w_"^"_text_"^"_tab
	          	 s itmtableData(code,itmname)=..getfree(Reader,itmname)
	          }
		      if Reader.MoveToAttributeName("type")
		      { ///left="537" top="537" ofx="0" ofy="0" width="53" height="21"
			     s typ=Reader.Value
			     if Reader.MoveToAttributeName("tabindex") s tab= Reader.Value
			     if Reader.MoveToAttributeName("left") s x= Reader.Value
			     if Reader.MoveToAttributeName("top") s y= Reader.Value
			     if Reader.MoveToAttributeName("width") s w= Reader.Value
			     if Reader.MoveToAttributeName("height") s h= Reader.Value
				 if Reader.MoveToAttributeName("text") s text= Reader.Value
				 if $G(itmHidd(code,itmname))="Y" q
				 if $G(itmdata(code,itmname))'="" s itmdata(code,itmname)=itmdata(code,itmname)_"@"_typ_"^"_x_"^"_y_"^"_h_"^"_w_"^"_$G(text)_"^"_tab
				 e  s itmdata(code,itmname)="@"_typ_"^"_x_"^"_y_"^"_h_"^"_w_"^"_$G(text)_"^"_tab
				 
			  }
	         
             if (Reader.Name="InstanceData")&(Reader.NodeType="endelement")  q

		   }
		}
}
 s exitm="",itmxy=""
 s x1="" f  s x1=$o(itmxy(x1)) q:x1=""  d
 .s y1="" f  s y1=$o(itmxy(x1,y1)) q:y1=""  d
 ..s itmval=itmxy(x1,y1)
 ..q:'$d(itmRelName(code,itmval))
 ..s itmcode=itmRelName(code,itmval)
 ..s itmdesc=itmTitle(code,itmval)
 ..i itmcode=initm s name=itmdesc
 //b ;33
 if Tstr'=""  
 {
	 f jk=1:1:$l(Tstr,"^")
	 {
		 s itm=$p(Tstr,"^",jk)
		 i itm=""  continue
		 s subitem=$p(itm,"!",2)
		 i subitem=initm d
		 .s name=$p(itm,"!",1)
		 q:name'=""
	 }
 }
 q name
}

ClassMethod ifhave(DepModelStr, code)
{
	s l=$l(DepModelStr,",")
	s ^oiii(code)=DepModelStr
	s ret=0
	f i=0:1:l
	{
	 s itm=$P(DepModelStr,",",i)
     i itm=code s ret=1
     //q:ret=1
	}
	q ret
}

ClassMethod getpdata(cls, mth, p, pdata, arr)
{
	           s data=##class(web.DHCMGPrintComm).GetData(cls_":"_mth,p)
	           if data'=""
	           {
		         s l=$L(data,"^")  //    s retStr="REGNO@"_regNo_"^LOC@"_ctlocDesc_"^ROOM@"_$g(room)_"^SEX@"_$g(sex)_"^PATNAME@"_$g(patName)_"^BEDCODE@"_$g(bedCode)_"^AGE@"_$g(age)_"岁^WARD@"_$g(wardDesc)_"^DIAG@"_diag
		         f i=1:1:l
		         {
			       s a1=$P(data,"^",i)
			       if a1="" continue
			       s nm=$P(a1,"@",1)
			       s nv=$P(a1,"@",2)
			       s bb(nm)=nv
			     }
			     s l=$l(arr,"@")
			     f i=1:1:l
			     {
				   s dd=$P(arr,"@",i)
				   if dd="" continue
				   s dm=$P(dd,"|",1)
				   s dv=$P(dd,"|",2)
				   s pdata(dm)=$G(bb(dv))
				 }
		       }
}

ClassMethod getitm(Reader, itmname, itmdata, code) As %String
{
   
    s itm=""
	while Reader.Read()
	{
	 // q
      if (Reader.Name=itmname)&(Reader.NodeType="endelement")  q
      if ((Reader.Name="")&(Reader.NodeType="chars"))
      {
	       s itm=itm_Reader.Value_"!"

      }
    //  w !,Reader.Name," //--",Reader.Value,"-NodeType-",Reader.NodeType
	}
    s itmdata(code,itmname)=itm
    q itm
}

ClassMethod getitmstore(a)
{
   s text=$P(a,"|")
   s val=$P(a,"|",2)
   if val="" s val=text
   s str="['"_text_"','"_val_"']"
   q str
}

ClassMethod getfree(Reader, itmname) As %String
{
   
    s itm=""
	while Reader.Read()
	{
	  if (Reader.Name=itmname)&(Reader.NodeType="endelement") q  
      if ((Reader.Name="")&(Reader.NodeType="chars")) s itm=itm_Reader.Value
	}
    q itm
}

Storage Default
{
<Data name="DHCNurAssCommDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCNurAssCommD</DataLocation>
<DefaultData>DHCNurAssCommDefaultData</DefaultData>
<IdLocation>^web.DHCNurAssCommD</IdLocation>
<IndexLocation>^web.DHCNurAssCommI</IndexLocation>
<StreamLocation>^web.DHCNurAssCommS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
