Class web.DHCNuremrqc Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

// w ##class(web.DHCNurSyComm).getloc1("DOCTOR","addloc")

ClassMethod getlocward(funname As %String) As %String
{
 s rw="" f  s rw=$O(^CTLOC(rw)) q:rw=""  d
 .s a=$P(^CTLOC(rw),"^")
 .s c=$P(^CTLOC(rw),"^",2)
 .q:c=""
 .s ctlocType=$p(^CTLOC(rw),"^",13)
 .;q:ctlocType'="E"
 .;s c=$P(c,"-",2)
 .q:(c'["病区")&(c'["产房")&(c'["单元")&(c'["病房")
 .q:c["停用"
 .s rtnval=funname_"('"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(c),"O","JS")_"');"
 .&javascript<#(rtnval)#>
 .//w !,b
 q 0
}

// w ##class(web.DHCNuremrqc).gethszbyloc("266")

// 根据科室查看护士长

ClassMethod gethszbyloc(loc As %String) As %String
{
 s ret=""
 //i loc="1338" s loc="254"
 q:loc="1338" "刘翠*652" //心血管内科病区护士长
 q:loc="254" "赵倩123*505" //心血管内科二病区护士长
 q:loc="266" "褚秀美*2307" //胸外科B单元护士长
 q:loc="166" "贾秀玲*2340" //急诊内科病区护士长
 q:loc="289" "张业玲*2576" //肿瘤科二病区护士长
 q:loc="237" "魏华*2235" //特需保健科三病区护士长
 s rw="" f  s rw=$O(^SSU("SSUSR",0,"Group",45,rw)) q:rw=""  d
 .s defaultdep=$P(^SSU("SSUSR",rw),"^",4) //默认登录科室
 .q:defaultdep'=loc
 
 .s name=$P(^SSU("SSUSR",rw),"^",2)
 .q:name["护士"
 .s ret=name_"*"_rw
  .b ;
 b 
 q ret
}

ClassMethod getloc1(typ As %String, funname As %String) As %String
{
 s ^kii=typ
 s rw="" f  s rw=$O(^CTLOC(rw)) q:rw=""  d
 .s a=$P(^CTLOC(rw),"^")
 .s c=$P(^CTLOC(rw),"^",2)
 .s locTyp=$P(^CTLOC(rw),"^",13)
 .s IsAllowCon=$P(^CTLOC(rw),"^",62)
 .q:c["停用"
 .q:c=""
 .q:(typ="DOCTOR")&(locTyp="W")
 .//q:(typ="NURSE")&(locTyp'="W")
 .q:(typ="NURSE")&(locTyp'="W")&(IsAllowCon'="Y")
 .s ADMLOCI=$O(^PAC("ADMLOC",0,"AdmType","I",rw,""))
 .s ADMLOCH=$O(^PAC("ADMLOC",0,"AdmType","H",rw,""))
 .q:((ADMLOCI="")&&(ADMLOCH=""))&&(typ'="NURSE")
 .s ContactName=$P(^CTLOC(rw),"^",43)
 .q:ContactName=""
 .s tmp(ContactName,rw)=c
 
 s curConName=""
 f  s curConName=$O(tmp(curConName)) q:curConName=""  d
 .s row=""
 .f  s row=$O(tmp(curConName,row)) q:row=""  d
 ..s c=$G(tmp(curConName,row))
 ..s rtnval=funname_"('"_$ZCVT($g(row),"O","JS")_"','"_$ZCVT($g(c),"O","JS")_"');"
 ..&javascript<#(rtnval)#>
 
 q 0
}

ClassMethod GetInCode(RecTyp) As %String
{
   s ret="" 
   s RecTyp=$zconvert(RecTyp,"U")
   //s id="" f  s id=$O(^User.DHCNURListLinkI("CodeIndex"," "_RecTyp,id)) q:id=""  d
 	//.s a=##class(User.DHCNURListLink).%OpenId(id)
 	//.s ret=a.InCode
  I RecTyp["TABLE" S ret=$p(RecTyp,"TABLE",1)
  q ret
}

/// 护理记录单配置
/// 2010-09-28
ClassMethod GetDepModelSet(LocId As %String, funname As %String) As %String
{
	//w ##class(web.DHCNuremrqc).GetDepModelSet("246","AddRec")
	//s ^DHCNurDepModelSet("Generic")="DHCNURRecordbradenscaleTable|卧床病人压疮发生危险因素量化评估—Braden Scale评分简表|81"
	s ^DHCNurDepModelSet("Generic")=""
	i LocId'="" d
	.s DepModelStr=$G(^DHCNurDepModelSet(LocId))
	.s DepModelStr=DepModelStr_"^"_^DHCNurDepModelSet("Generic")
	.f ii=1:1:$L(DepModelStr) d
	..s DepModel=$P(DepModelStr,"^",ii)
	..q:DepModel=""
	..s ModelKey=$P(DepModel,"|",1)
	..s inflag=..GetInCode(ModelKey)
	..i inflag'="" s ModelKey=inflag
	..s ModelName=$P(DepModel,"|",2)_"("_ModelKey_")"
	..s ModelSort=$P(DepModel,"|",3)
	..s DepModel(ModelKey)=ModelName_"^"_ModelKey
	s LocId="9000"
	i LocId'="" d
	.s DepModelStr=$G(^DHCNurDepModelSet(LocId))
	.s DepModelStr=DepModelStr_"^"_^DHCNurDepModelSet("Generic")
	.f ii=1:1:$L(DepModelStr) d
	..s DepModel=$P(DepModelStr,"^",ii)
	..q:DepModel=""
	..s ModelKey=$P(DepModel,"|",1)
	..s inflag=..GetInCode(ModelKey)
	..i inflag'="" s ModelKey=inflag
	..s ModelName=$P(DepModel,"|",2)_"("_ModelKey_")"
	..s ModelSort=$P(DepModel,"|",3)
	..i '$d(DepModel(ModelKey)) s DepModel(ModelKey)=ModelName_"^"_ModelKey
 	b
	s sort="" f  s sort=$O(DepModel(sort)) q:sort=""  d
	.s ret=DepModel(sort)
	.s ModelName=$P(ret,"^",1)
	.s ModelKey=$P(ret,"^",2)
    .s rtnval=funname_"('"_$ZCVT($g(ModelKey),"O","JS")_"','"_$ZCVT($g(ModelName),"O","JS")_"');"
 	.&javascript<#(rtnval)#>
    q 0
    i $D(DepModel(RecTyp)) d
	.s ModelName=$P(DepModel(RecTyp),"^",1)
	.s ModelSort=$P(DepModel(RecTyp),"^",2)
	.s IfShow=1
	s SubKCode="" f  s SubKCode=$O(^NurEmr.NurEmrSubI("KCode",SubKCode)) q:SubKCode=""  d
	.s ItmId=$O(^NurEmr.NurEmrSubI("KCode",SubKCode,""))
	.q:ItmId=""
	.s RecName=$List(^NurEmr.NurEmrSubD(ItmId),4)
	.s RecTyp=$TR(SubKCode," ","")
    .q:($E(RecTyp,1,6)'=$ZCONVERT("DHCNUR","U"))
    .//q:($E(RecTyp,1,11)'=$ZCONVERT("DHCNURQY_BZ","U"))&($E(RecTyp,1,13)'=$ZCVT("DHCNURQY_HLJL","U"))&($E(RecTyp,1,20)'="DHCNURRECORDHLAQGZS1")&($E(RecTyp,1,21)'=$ZCVT("DHCNURRECORDHZZKHLJJD","U"))&($E(RecTyp,1,19)'=$ZCVT("DHCNURRECORDWXYSPGB","U"))&($E(RecTyp,1,24)'="DHCNURRECORDZYWCBRRCFSYS")&($E(RecTyp,1,12)'=$ZCVT("DHCNURRecord","U"))
	.//q:(($L(RecTyp)>15)&(RecTyp'="DHCNURCHANGELABLERECLOC")&(RecTyp'="DHCNURCOPYDIAGNOS"))
	.s ModelName="",ModelSort="",IfShow=0
	.i $D(DepModel(RecTyp)) d
	..s ModelName=$P(DepModel(RecTyp),"^",1)
	..s ModelSort=$P(DepModel(RecTyp),"^",2)
	..s IfShow=1
	.//q:RecName'["消化内科"
    .s rtnval=funname_"('"_$ZCVT($g(RecTyp),"O","JS")_"','"_$ZCVT($g(RecName),"O","JS")_"');"
 	.//s rtnval=funname_"('"_$ZCVT($g(RecTyp),"O","JS")_"','"_$ZCVT($g(RecName),"O","JS")_"','"_$ZCVT($g(IfShow),"O","JS")_"','"_$ZCVT($g(ModelSort),"O","JS")_"','"_$ZCVT($g(ModelName),"O","JS")_"');"
 	.&javascript<#(rtnval)#>
 	q 0
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
    b ///ddf
	while Reader.Read()
	{
	  if (Reader.Name=itmname)&(Reader.NodeType="endelement") q  
      if ((Reader.Name="")&(Reader.NodeType="chars")) s itm=itm_Reader.Value
    //  w !, Reader.NodeType
    //  w !,Reader.Name," //--",Reader.Value,"-NodeType-",Reader.NodeType
	}
   //	b  ///9999
   //	
    q itm
}

// w ##class(web.DHCNuremrqc).GetCodeList("193","","DHCNURRECORDBRADENSCALE","AddRec")

ClassMethod GetCodeList(loc As %String, id As %String, code As %String, funname As %String) As %String
{
	   s str=##class(NurEmr.NurEmrSub).GetKCode(code)
       if str="" s str=##class(NurEmr.NurEmrSub).getData(code)
       b ;1
       s Data=""
       if str'=""   
	   {
		S ITM=##CLASS(NurEmr.NurEmrSub).%OpenId(str)
		s Data=ITM.EmrSubData
		s title=ITM.EmrSubDesc
	   }
	   q:Data="" ""
	   d Data.Rewind()
	   s itmRelName=""
	   s Reader=##class(web.DHCNUREMR).GetReader(code,Data)
	   q:Reader="" ""
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
 		    // w !,Reader.Name," //00",Reader.Path
		    // if Reader.Name="T11" b
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
				       /// b hide
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
				  
			      s itmdata(code,xname)=title  
		     }
		     // w !,xname
		      
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
			 // b
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
                   // b ///M
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
		                   //b  //888888888888888888
		                    if (Reader.Name=itmname)&(Reader.NodeType="endelement")  q
		                     s lb=$E(Reader.Name,0,1)
		                   //	w !,Reader.Name
                             if lb="F"
		                     {
			                   s str=str_..getfree(Reader,Reader.Name)
			                  // b
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
 
 b
 s exitm="",itmxy=""
 i (loc'="")&(code'="")&(id="") d
 .s exitm=..existzkitem(loc, code)
 s ^oieis=loc_"^"_exitm
 s x1="" f  s x1=$o(itmxy(x1)) q:x1=""  d
 .s y1="" f  s y1=$o(itmxy(x1,y1)) q:y1=""  d
 ..s itmval=itmxy(x1,y1)
 ..q:'$d(itmRelName(code,itmval))
 ..s itmcode=itmRelName(code,itmval)
 ..s flag=0
 ..i exitm'="" s flag=..ifhave(exitm,itmcode)
 ..//w !,flag_"  "_itmcode
 ..//q:flag=1
 ..q:itmcode'["Item"
 ..s itmdesc=itmTitle(code,itmval)_" ("_itmcode_")"
 ..s rtnval=funname_"('"_$ZCVT($g(itmcode),"O","JS")_"','"_$ZCVT($g(itmdesc),"O","JS")_"');"
 ..&javascript<#(rtnval)#>
 
 q 0
 s itmcodedesc=""
 s i="" f  s i=$o(itmRelName(code,i)) q:i=""  d
 .s itmcode=itmRelName(code,i)
 .s itmdesc=itmTitle(code,i)
 .q:$d(itmLinkName(code,i))&(itmLinkName(code,i)'="")
 .i itmcode'="" s itmcodedesc(itmcode)=itmdesc
 s i="" f  s i=$o(itmcodedesc(i)) q:i=""  d
 .s itmcode=i
 .s itmdesc=itmcodedesc(i)_" ("_i_")"
 .s rtnval=funname_"('"_$ZCVT($g(i),"O","JS")_"','"_$ZCVT($g(itmdesc),"O","JS")_"');"
 .&javascript<#(rtnval)#>

	b ;
}

// w ##class(web.DHCNuremrqc).existzkitem("246","DHCNURRecordxhn1")

ClassMethod existzkitem(loc, EmrCode)
{
	s ^oei(loc)=EmrCode
	s EmrCode=$zconvert(EmrCode,"U")
	s ret=""
	s rw="" f  s rw=$o(^Nur.DHCNUREMRQCI("LocEmrCodeIndex"," "_loc," "_EmrCode,rw)) q:rw=""  d
	.s a=##class(Nur.DHCNUREMRQC).%OpenId(rw)
	.s type=a.Type
	.q:type'="User"
	.s Zkitem=a.Zkitem //质控项
    .i ret="" s ret=Zkitem
    .e  s ret=ret_","_Zkitem
    q ret
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

}
