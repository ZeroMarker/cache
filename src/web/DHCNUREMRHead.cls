Class web.DHCNUREMRHead Extends %Persistent
{

//  w ##class(web.DHCNUREMRHead).getheadchangeflag("DHCNURXH1")

// 判断模板是否是表头变更模板

ClassMethod getheadchangeflag(code) As %String
{
	s ret="",last=""
	s code=$zcvt(code,"U")
	s p="" f  s p=$O(^Nur.DHCNurChangeLableRecI("Lable",p)) q:p=""  d
	.s rw=""  f  s rw=$o(^Nur.DHCNurChangeLableRecI("Lable",p,rw)) q:rw=""  d
	..q:(last'="")&&(last=p)
	..s last=p
	..s nowp=$tr(p," ","")
	..s nowp=$zcvt(nowp,"U")
	..i nowp=code s ret=1
	q ret
}

//  w ##class(web.DHCNUREMRHead).getflag("DHCNURZSK_Sub")

ClassMethod getflag(code) As %String
{
	s ret="",last=""
	s code=$zcvt(code,"U")
	b
	s p="" f  s p=$O(^Nur.DHCNurZSKDataI("emrcode",p)) q:(p="")!(ret=1)  d
	.s rw=""  f  s rw=$o(^Nur.DHCNurZSKDataI("emrcode",p,rw)) q:(rw="")!(ret=1)  d
	..s nowp=$tr(rw," ","")
	..s nowp=$zcvt(nowp,"U")
	..b ;
	..i nowp=code s ret=1
	i code="DHCNURZSK_SUB" Q 1
	q ret
}

// 刷新时自动生成js

// w ##class(web.DHCNUREMRHead).getcomflag("DHCNURXH_LYZGHLJHD","","98","")

ClassMethod getcomflag(code, EpisodeID, loc, headcode) As %String
{
	
  s flag=..getheadchangeflag(code) //只有在科室空白栏中维护了的表才自动生成js
  q:(flag'=1)&&(code'="DHCNURHEADCHANGE") ""
  i $D(%session) s loc=$G(%session.Data("LOGON.CTLOCID"))
  e  s loc="" 
  i $D(%session) s user=$G(%session.Data("LOGON.USERID"))
  e  s user="" 
  s getcurhead=##class(Nur.DHCNurRecHeadChangeRec).getcurrrow(EpisodeID,user,code)
  d ##class(NurEmr.webheadchange).headfromord(loc,EpisodeID,getcurhead) //根据医嘱取表头列
  s id=##class(NurEmr.NurEmrSub).GetKCode(code)
  s flag=$listget(^NurEmr.NurEmrSubD(id),8)
  if flag'="Y"  //模板左下角的组件没勾上
  {
	 s ^TMP("c",code,flag)=id
	 k ^NurEmr.NurEmrTemp(code)
	 s a=##class(Nur.DHCMGNurseSet).getSet()
	 s generpath=$P(a,"^",3)
	 if ($E(generpath,$L(generpath))="\") s generpath=generpath_"\"
     if generpath="" s generpath="\\127.0.0.1\dhcmg\"
  	 if '##class(%Library.File).DirectoryExists(generpath)
	 {
		 s Result = ##class(%Library.File).CreateDirectoryChain(generpath) 
	 }
     Set file = ##class(%Library.File).%New(generpath_code_".js") 
     s a=##class(web.DHCNUREMRHead).getPagData("",code,EpisodeID,loc,"true",headcode)
     d file.Open("WNSK\UTF8\")
     d file.WriteLine("var sm = new Ext.grid.CheckboxSelectionModel();")
     d file.WriteLine("var sm1 = new Ext.grid.CheckboxSelectionModel();")
     d file.WriteLine("var sm2 = new Ext.grid.CheckboxSelectionModel();")
     d file.WriteLine("var sm3 = new Ext.grid.CheckboxSelectionModel();")
     s name=""  f  s name=$O(^NurEmr.NurEmrSubK("tablestore",code,name)) q:name=""  d
     .d file.WriteLine("var "_code_name_"="_^NurEmr.NurEmrSubK("tablestore",code,name)_";")
     d file.WriteLine("var a=tkMakeServerCall(""web.DHCNUREMRHead"",""getPagData"","""",EmrCode,EpisodeID,session['LOGON.CTLOCID'],false,headcode);") 
     d file.WriteLine("var arr=eval(a);")
     d ..writecomm(file)
     d file.Close()
     q file.SizeGet()
  }else
  {  
     q ""
  }
}

// js取模板信息

ClassMethod getjsjson(EmrCode As %String, i) As %String
{
 //##class(web.DHCNUREMR).getjsjson
   q ^NurEmr.NurEmrTemp($g(EmrCode),i)
}

ClassMethod getcurrrow(adm, user, rectyp) As %String
{
	s par=##class(Nur.DHCNurseRecParent).getparentid(adm,user)
	s chl=""
	//b //
	s rw=""  f  s rw=$O(^Nur.DHCNurRecHeadChangeRecI("TypDatTim"," DHCNURHEADCHANGE"," "_rectyp,par,rw)) q:rw=""  d
	.s a=##class(Nur.DHCNurRecHeadChangeRec).%OpenId(par_"||"_rw)
	.s flag=a.Item50
	.if flag="Y"  s chl=rw
	.//b
   q:chl="" ""
   q par_"||"_chl
}

ClassMethod getdepHead(LocId) As %String
{
	s ret=""
	i LocId'="" d
	.s rw="" f  s rw=$O(^Nur.DHCNurHeadKnowledgeI("Loc"," "_LocId,rw)) q:rw=""  d
	..s obj=##class(Nur.DHCNurHeadKnowledge).%OpenId(rw)
	..s ret=ret_rw_"-"_obj.Head_"|"_obj.Head_"!"
    q ret
}

ClassMethod getVal(id, tmp, labletmp) As %String
{
	if id'=""
	{
	s a=##class(Nur.DHCNurRecHeadChangeRec).%OpenId(id)
	s tmp=""
	if '$D(^tdata("Nur.DHCNurRecHeadChangeRec")) d a.ListProperties()
	s p="" f  s p=$O(^tdata("Nur.DHCNurRecHeadChangeRec",p)) q:p=""  d
	.i $d(labletmp(p)) s tmp(p)=$ZOBJPROPERTY(a,p)
	}
	q 0
}

ClassMethod gethead(adm, user, rectyp, headtmp, loc, code, headselected) As %String
{
  //获取当前标题
   //##class(Nur.DHCNurRecHeadChangeRec).gethead(adm,user,rectyp,tmp)
    s rowid=..getcurrrow(adm,user,rectyp)
    k tmpLableRec
    d ..GetLableRec(code_"^"_loc,.tmpLableRec)
    b ;002
    s a=..getVal(rowid,.headtmp,.tmpLableRec)
    b ;003
    i $g(loc)'="" s ret=..getdepHead(loc)
    //获取当前科室维护信息
    i $g(code)'="" s head=##class(Nur.DHCNurHeadKnowledge).getloccodeHead(code,loc,.headselected)
    q 0
}

ClassMethod getPagData(itmdata, code, EpisodeId, Loc, ReturnStream = "false", headcode) As %GlobalCharacterStream
{
 // s a=##class(web.DHCNUREMR).getPagData("","DHCCONSULTPAT","4054905","")
 // w ##class(web.DHCNUREMRHead).getPagData("","DHCNURXH_WKHLJL","10424222","99","false","")
    k headtmp
    ///取表格标题
    s flag=..getheadchangeflag(code) //只有在科室空白栏中维护了的表才自动生成js$g(%session.Data("LOGON.USERID"))
    b ;222
    k headSelections
    i flag'="" s a=..gethead(EpisodeId,"3880",code,.headtmp,Loc,code,.headSelections)
     //i flag'="" s a=##class(Nur.DHCNurRecHeadChangeRec).gethead(EpisodeId,"3880",code,.headtmp,Loc,code,.headSelections)
    b ;
    //i $D(%session) s a=##class(Nur.DHCNurRecHeadChangeRec).gethead(EpisodeId,$g(%session.Data("LOGON.USERID")),code,.headtmp)
  // s ^TMP("head11")=$LB(EpisodeId,%session.Data("LOGON.USERID"),code)
  // m ^TMP("head1")=headtmp
    s ITM=""    
	S Data=""
	s rowid=""
	s AnaesID=""
	if $D(%request)
	{
		 s AnaesID=$G(%request.Data("AnaesID",1))
	}
	if EpisodeId'=""
    {
	     s parentid=##class(NurEmr.DHCMgEmrData).getEpisodeId(EpisodeId) 
    }
    if rowid="" 
    {
        s rowid=##class(NurEmr.DHCMgEmrData).getEpisodeIdRowId(EpisodeId,code) //getEpisodeIdRowId
    }
    if AnaesID'=""
    { ///2010-04-05 qse add
	  s rowid=##class(Nur.DHCNurAnaesRec).getNurAnaesId(code,AnaesID)
	}
    s Data=""
   if rowid'=""
    {
	   s ITM=##class(NurEmr.DHCMgEmrDataChild).%OpenId(rowid)
	   s itcode=ITM.EmrCode
	   q:code'=itcode ""
	   s Data=ITM.EmrData
	}else{
        s str=##class(NurEmr.NurEmrSub).GetKCode(code)
        if str="" s str=##class(NurEmr.NurEmrSub).getData(code)
       if str'=""   
	   {
		S ITM=##CLASS(NurEmr.NurEmrSub).%OpenId(str)
		s Data=ITM.EmrSubData
		s title=ITM.EmrSubDesc
	   }else
	   {
	    q ""
	   }
	}
	d Data.Rewind()
  // Set sc = ##class(%XML.TextReader).ParseStream(Data,.Reader)
    s Reader=..GetReader(code,Data)
	//Set datastream=##class(%GlobalCharacterStream).%New()
   // d datastream.Write(xml)
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
	           if p="Adm" s p=p_":"_EpisodeId
	           if p="AnaesID" s p=p_":"_AnaesID
	           s pdata=""
	           if EpisodeId'=""
	           {
	            d ..getpdata(cls,mth,p,.pdata,arr)
	           }
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
		      if Reader.MoveToAttributeName("CheckSel") s itmCheckSel(code,xname)=Reader.Value
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
		          //显示顺序按表头分组
		          d ..getTtitle(xname,code)
		          s title="",itmifor=""
			      while Reader.Read()
			      {
         		     if (Reader.Name=xname)&(Reader.NodeType="endelement")  q
		             s colname=Reader.Name
		             s itmtable(code,colname)=""
                     if ($E(Reader.Name,0,1)="M")!($E(Reader.Name,0,1)="O")!($E(Reader.Name,0,1)="I")!($E(Reader.Name,0,1)="R")
				     {	
				         if Reader.NodeType="endelement" continue
				     	 if (Reader.MoveToAttributeName("Title")) s head=Reader.Value
	            	     if Reader.MoveToAttributeName("Link") s itmLinkName(code,colname)=Reader.Value

		                 if Reader.MoveToAttributeName("RelName") s Relname=Reader.Value
		                 if Reader.MoveToAttributeName("Pos") s Pos=Reader.Value
		                 s title=title_$G(head)_"!"_$G(Relname)_"!"_colname_"!"_$G(Pos)_"^"
		                 s itmifor(colname)=$G(head)_"!"_$G(Relname)_"!"_colname_"!"_$G(Pos)_"^"
			             if Reader.NodeType'="endelement" s itm=..getitm(.Reader,colname,.itmdata,code)
					 }
					 else
					 {
						 if Reader.NodeType="endelement" continue
				     	 if (Reader.MoveToAttributeName("Title")) s head=Reader.Value
		                 if Reader.MoveToAttributeName("RelName") s Relname=Reader.Value
		                 if Reader.MoveToAttributeName("Pos") s Pos=Reader.Value
		                 s itmifor(colname)=$G(head)_"!"_$G(Relname)_"!"_colname_"!"_$G(Pos)_"^"
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
				  s str=""
				  s i="" f  s i=$o(^DHCNurEmrGen2(i)) q:i=""  d
				  .s itm=""  f  s itm=$o(^DHCNurEmrGen2(i,itm)) q:itm=""  d
				  ..s val=$g(itmifor(itm))
				  ..q:val=""
				  ..i str="" d
				  ...s str=val
				  ..e  d
				  ...s str=str_val
			      s itmdata(code,xname)=str  
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
			      if lb="O"
			      {
				     // b //ooooo(注:总分<=17分,可上报不可避免压疮)
				    if (Reader.MoveToAttributeName("selecttext"))
				    {
					 // if itmdataVal(code,itmname)'="" s itmdataVal(code,itmname)=itmdataVal(code,itmname)_"@"_Reader.Value
					 s itmdataVal(code,itmname)=Reader.Value
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
                  if (lb="M")!(lb="R")
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
					 }else{
						// s itmdata(code,itmname)=$ZD(+$H,3)
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
		                     if lb="R"
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
 s ff=##class(%GlobalCharacterStream).%New()
 d ff.Write("[")
 s i=0
 s cc=""  f  s cc=$O(pdata(cc)) q:cc=""  d
 .s itmdataVal(code,cc)=pdata(cc)
 s name=""  f  s name=$O(itmdata(code,name)) q:name=""  d
 .q:$D(itmtable(code,name))
 .s hflag=$G(itmHidd(code,name))
 .if hflag="Y" s ^NurEmr.NurEmrSubK("Kcode",code,name)=itmLinkName(code,name)_":"_itmRelName(code,name)
 .q:hflag="Y"
 .s a1=$P(itmdata(code,name),"@")
 .s a2=$P(itmdata(code,name),"@",2)
 .s link=$G(itmLinkName(code,name))
 .s aa=""
 .s RelName=$G(itmRelName(code,name))
 .if RelName="" s cnname=name
 .e  s cnname=RelName
 .//if $E(name,0,1)="T" q
 .if $F(itmdata(code,name),"@")=0 s aa=itmdata(code,name)
 .e  s aa=a2
 .s typ=$P(aa,"^",1)
 .if (typ="DesignForm.QHLine")!(typ="DesignForm.QVline")!(typ="DesignForm.QVline") q
 .s x=$P(aa,"^",2)
 .s y=$P(aa,"^",3)
 .s h=$P(aa,"^",4)
 .s w=$P(aa,"^",5)
 .s text=$P(aa,"^",6)
 .s tab=$P(aa,"^",7)
 .s title=$G(itmTitle(code,name))
 .s i=i+1
 .//if i>42 q
 .//b ;999999
 .s flag="0"
 . // s b=b_"{tabIndex:'"_1_"',name:'grr',xtype:'panel',x:"_0_",y:"_200_",height:"_200_",width:"_400_",border:false,items:[{xtype:'grid',stripeRows: true,name:'hhh',title:'dddf',height:200,width:400,store:"_..getstore()_",columns:"_..getcols()_"}]}," 
 .if $E(name,0,1)="T" d
 ..s xtype="grid"
 ..s flag=1
 ..s grphead=..GetGrpHead(name,code)
 ..s check="N" ,sm="" //复选 grid
 ..s RowSel=",sm: new Ext.grid.RowSelectionModel({ singleSelect:false})"
 ..if $G(itmCheckSel(code,name))="Y" d
 ...s grphead="",check="Y",sm=",sm:sm",RowSel=""
 ...if cnname="mygrid1" s sm=",sm:sm1"
 ...if cnname="mygrid2" s sm=",sm:sm2"
 ...if cnname="mygrid3" s sm=",sm:sm3"
 ..s vastr=itmtableData(code,name)
 ..s widstr=$P(vastr,"$",2)
 ..s griddata=""
 ..if link'="" d
 ...s cls=$P(link,":",1),mth=$P(link,":",2),parrm=$P(link,":",3),dl=$P(link,":",4),vl=$P(link,":",5)
 ...s stdata=..GenerateMetaData(a1,cls,mth)
 ...s ^NurEmr.NurEmrSubK("tablestore",code,name)=stdata
 ...s griddata=code_name
 ..e  d
 ...s stdata=..getstore1(a1,vastr)
 ...s ^NurEmr.NurEmrSubK("tablestore",code,name)=stdata
 ...s griddata=code_name
 ..s editflag=$G(itmEdit(code,name))
 ..//b //grid
 ..if editflag="Y" d
 ...if grphead="" d ff.Write("{id:'"_cnname_"pl',name:'"_cnname_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",xtype:'panel',layout:'fit',border:false,items:[new Ext.grid.EditorGridPanel({id:'"_cnname_"'"_sm_",name:'"_cnname_"',loadMask:true,clicksToEdit: 1, stripeRows: true,title:'"_title_"',height:"_h_",width:"_w_",tbar:[{id:'"_cnname_"but1',icon:'../Image/icons/add.png',text:'新建'},{id:'"_cnname_"but2',icon:'../Image/icons/disk.png',text:'修改'}],store:"_griddata_",colModel: new Ext.grid.ColumnModel({columns:"_..getcols1(a1,.itmdata,code,widstr,.itmRelName,.itmLinkName,.headtmp,check,headcode,.headSelections)_",defaultSortable:false,enableColumnMove: false,viewConfig:{forceFit: false}})"_RowSel_",bbar: new Ext.PagingToolbar({store:"_griddata_",displayInfo:true,pageSize:10})})]},")
 ...e  d ff.Write("{id:'"_cnname_"pl',name:'"_cnname_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",xtype:'panel',layout:'fit',border:false,items:[new Ext.grid.EditorGridPanel({id:'"_cnname_"',name:'"_cnname_"',title:'"_title_"',loadMask:true,clicksToEdit: 1, stripeRows: true,height:"_h_",width:"_w_",tbar:[{id:'"_cnname_"but1',icon:'../Image/icons/add.png',text:'新建'},{id:'"_cnname_"but2',icon:'../Image/icons/disk.png',text:'修改'}],store:"_griddata_",colModel: new Ext.grid.ColumnModel({columns:"_..getcols1(a1,.itmdata,code,widstr,.itmRelName,.itmLinkName,.headtmp,"N",headcode,.headSelections)_",rows:"_grphead_",defaultSortable:false}),enableColumnMove: false,viewConfig:{forceFit: false},plugins:[new Ext.ux.plugins.GroupHeaderGrid()],sm: new Ext.grid.RowSelectionModel({ singleSelect: false}),bbar: new Ext.PagingToolbar({store:"_griddata_",displayInfo:true,pageSize:10})})]},")
 ..e  d
 ...if grphead="" d ff.Write("{id:'"_cnname_"pl',name:'"_cnname_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",xtype:'panel',layout:'fit',border:false,items:[new Ext.grid.GridPanel({id:'"_cnname_"'"_sm_",name:'"_cnname_"',loadMask:true,clicksToEdit: 1, stripeRows: true,title:'"_title_"',height:"_h_",width:"_w_",tbar:[{id:'"_cnname_"but1',icon:'../Image/icons/add.png',text:'新建'},{id:'"_cnname_"but2',icon:'../Image/icons/disk.png',text:'修改'}],store:"_griddata_",colModel: new Ext.grid.ColumnModel({columns:"_..getcols1(a1,.itmdata,code,widstr,.itmRelName,.itmLinkName,.headtmp,check,headcode,.headSelections)_",defaultSortable:false,enableColumnMove: false,viewConfig:{forceFit: false}})"_RowSel_",bbar: new Ext.PagingToolbar({store:"_griddata_",displayInfo:true,pageSize:10})})]},")
 ...e  d ff.Write("{id:'"_cnname_"pl',name:'"_cnname_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",xtype:'panel',layout:'fit',border:false,items:[new Ext.grid.GridPanel({id:'"_cnname_"',name:'"_cnname_"',title:'"_title_"',loadMask:true,clicksToEdit: 1, stripeRows: true,height:"_h_",width:"_w_",tbar:[{id:'"_cnname_"but1',icon:'../Image/icons/add.png',text:'新建'},{id:'"_cnname_"but2',icon:'../Image/icons/disk.png',text:'修改'}],store:"_griddata_",colModel: new Ext.grid.ColumnModel({columns:"_..getcols1(a1,.itmdata,code,widstr,.itmRelName,.itmLinkName,.headtmp,"N",headcode,.headSelections)_",rows:"_grphead_",defaultSortable:false}),enableColumnMove: false,viewConfig:{forceFit:false},plugins:[new Ext.ux.plugins.GroupHeaderGrid()],sm: new Ext.grid.RowSelectionModel({ singleSelect: false}),bbar: new Ext.PagingToolbar({store:"_griddata_",displayInfo:true,pageSize:10})})]},") 
 .if $E(name,0,1)="R" d   //单选
 ..s xtype="radio"
 ..if link'="" s a1=..GetLinkData(link)
 ..s radioGrp=..GetRadioGrp(a1,cnname,$G(itmdataVal(code,name)))
 ..s flag=1
 ..d ff.Write("{name:'"_cnname_"',id:'"_cnname_"',frame:true,isFormField:true, labelAlign:'left',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_(h+5)_",width:"_w_",xtype:'panel',layout:'column',items:"_radioGrp_"},") 
 .if $E(name,0,1)="M" d
 ..s xtype="checkbox"
 ..if link'="" s a1=..GetLinkData(link)
 ..s checkGrp=..GetCheckGrp(a1,cnname,$G(itmdataVal(code,name)))
 ..s flag=1
 ..//i $G(itmdataVal(code,name))'="" d
 ..d ff.Write("{name:'"_cnname_"',id:'"_cnname_"',frame:true,isFormField:true, labelAlign:'left',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",xtype:'panel',background: '#FFFF00',layout:'column',items:"_checkGrp_"},") 
 .if $E(name,0,1)="O" d
 ..s xtype="combo"
 ..s flag=1
 ..s datastore=..GetStore(a1)  //b //combo
 ..s pl=..getvalFlag(a1)
 ..//i $g(itmdataVal(code,name))'="" d
 ..d ff.Write("{name:'"_cnname_"',id:'"_cnname_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",xtype:'"_xtype_"',store:"_datastore_", displayField:'desc', valueField:'id',allowBlank: true,mode:'local',value:'"_$P(itmdataVal(code,name),"|",pl)_"'},") 
 .if $E(name,0,1)="I" d
 ..s xtype="combo"
 ..s cls="",mth="",dl="Desc",vl="id",parrm=""
 ..if link'="" d
 ...s cls=$P(link,":",1),mth=$P(link,":",2),parrm=$P(link,":",3),dl=$P(link,":",4),vl=$P(link,":",5)
 ...if parrm=""  s a1=..GetLinkData(link)
 ..s flag=1
 ..if link="" d
 ...s datastore=..GetLinkData1($G(itmdataVal(code,name)))  //b //combo
 ...if datastore'="" d ff.Write("{name:'"_cnname_"',id:'"_cnname_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",xtype:'"_xtype_"',store:"_datastore_", displayField:'desc', valueField:'id',allowBlank: true,mode:'local',value:'"_$P($G(itmdataVal(code,name)),"|")_"'},") 
 ...e  d ff.Write("{name:'"_cnname_"',id:'"_cnname_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",xtype:'"_xtype_"', displayField:'desc', valueField:'id',allowBlank: true,mode:'local'},") 
 ..e  d
 ...if $G(a1)="" d ff.Write("{name:'"_cnname_"',id:'"_cnname_"',store:"_..GenerateComBoxMeta(dl_"^"_vl,cls,mth)_",tabIndex:'"_tab_"',x:"_x_",listWidth:'400',y:"_y_",height:"_h_",width:"_w_",xtype:'"_xtype_"', displayField:'"_dl_"', valueField:'"_vl_"',hideTrigger:false,queryParam:'"_parrm_"',forceSelection:true,triggerAction:'all',minChars:1,pageSize:10,typeAhead:true,typeAheadDelay:1000,loadingText:'Searching...'},") 
 ...e  d
 ....s datastore=..GetStore(a1)
 ....d ff.Write("{name:'"_cnname_"',id:'"_cnname_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",xtype:'"_xtype_"',store:"_datastore_", displayField:'desc', valueField:'id',allowBlank: true,mode:'local',value:''},") 
 .if $F(name,"Button")'=0 d
 ..s xtype="button"
 ..s flag=1
 ..d ff.Write("{tabIndex:'"_tab_"',name:'"_cnname_"',xtype:'panel',layout:'column',x:"_x_",y:"_y_",height:"_h_",width:"_w_",border:false,buttons:[{plain:true,frame:true,xtype:'button',id:'"_cnname_"',text:'"_text_"'}]},") 
 .if $E(name,0,1)="D" d
 ..s flag=1
 ..s df=$P(a1,"^")
 ..s df2=$P(a1,"^",2)
 ..if df2="D" s xtype="datefield",format="Y-m-d"
 ..if df2="T" s xtype="timefield"
 .. //bDateTime
 ..if xtype="timefield" d
 ...if $g(itmdataVal(code,name))'="" d
 ....s itmdataVal(code,name)=$ZT($ZTH(itmdataVal(code,name)),4)
 ..if df2="D" d
 ...//i $g(itmdataVal(code,name))'="" d
 ...//d ff.Write("{name:'"_cnname_"',id:'"_cnname_"',format:'"_format_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",xtype:'"_xtype_"',value:'"_itmdataVal(code,name)_"'},") 
 ...d ff.Write("{name:'"_cnname_"',id:'"_cnname_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",xtype:'"_xtype_"',value:'"_itmdataVal(code,name)_"'},") 

 ..if df2="T" d
 ...//i $g(itmdataVal(code,name))'="" d
 ...d ff.Write("{name:'"_cnname_"',id:'"_cnname_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",format: 'H:i',xtype:'"_xtype_"',value:'"_itmdataVal(code,name)_"'},") 
 .if $E(name,0,1)="G" d
 ..s xtype="textarea"
 ..s flag=1
 ..d ff.Write("{name:'"_cnname_"',id:'"_cnname_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",xtype:'"_xtype_"',value:'"_$G(itmdataVal(code,name))_"'},")
 ..//b //GGG
 .if typ="System.Windows.Forms.Label" s xtype="label" 
 .else  s xtype=""
 .if typ="System.Windows.Forms.Button" s xtype="button"
 .q:flag=1 
 .if $G(xtype)'="" d ff.Write("{name:'"_cnname_"',id:'"_cnname_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",xtype:'"_xtype_"',text:'"_text_"'},")
 .e  d ff.Write("{tabIndex:'"_tab_"' ,xtype:'textfield',x:"_x_",y:"_y_",height:"_h_",width:"_w_",name:'"_cnname_"',id:'"_cnname_"',value:'"_$G(itmdataVal(code,name))_"'},")
 ;s ff=$e(ff,0,$l(ff)-1)
 s tmpff=##class(%GlobalCharacterStream).%New()
 while ('(ff.AtEnd))
 {
	 set len=1024
	 set str=ff.Read(len)
	 if $l(str)'=1024 d 
	 .s str=$e(str,0,$l(str)-1)
	 d tmpff.Write(str)
 }
 s ff=tmpff
 d ff.Write("]")   //",{x:100,y:200,xtype:'timefield',anchor:'10%'}]"  
 s ^TM("aa")=ff
 i ReturnStream="true" q ff
 else  q ff.Read()
}

ClassMethod writecomm(file) As %String
{
	
	d file.WriteLine("var pg=0;")
	d file.WriteLine("Ext.onReady(function() {")
	d file.WriteLine("if (pg>0) return ;")
    d file.WriteLine(" new Ext.form.FormPanel({")
	d file.WriteLine("height:600,")
	d file.WriteLine("width: 800,")
	d file.WriteLine("id:'gform',")
	d file.WriteLine("autoScroll:true,")
	d file.WriteLine("layout: 'absolute',")
	d file.WriteLine("items:arr,")
	d file.WriteLine("renderTo: Ext.getBody()")
    d file.WriteLine("});")
	d file.WriteLine("pg++;")
	d file.WriteLine("var fheight=document.body.offsetHeight;")
	d file.WriteLine("var fwidth=document.body.offsetWidth;")
	d file.WriteLine("var fm=Ext.getCmp('gform');")
	d file.WriteLine("fm.setHeight(fheight);")
	d file.WriteLine("fm.setWidth(fwidth);")

    d file.WriteLine("BodyLoadHandler();")
    d file.WriteLine("});")
    q 0
}

// 显示顺序按表头分组

ClassMethod readxml2(xRead, code, nod, typ, prev, num)
{
    if (nod=code)&(typ="endelement") 
    {
	    s ^flag2="1"
    }
	while xRead.Read()
	{  
	    s prevnod=nod
	    s curr=nod
		s nod=xRead.Name
	    if ^flag2="1"  q
		s path=xRead.Path
		s l=$l(path,"/")
		s id=$p(path,"/",l)
	    if xRead.MoveToAttributeName("Title")	
        {
	        if id[code continue
	        s ^DHCNurEmrGen2(num,id)=xRead.Value
	    }
		s num=num+1			    
        d ..readxml2(xRead,code,nod,xRead.NodeType,prevnod,.num)
	    if ^flag2="1"  q
	}
}

// 显示顺序按表头分组

ClassMethod getTtitle(Code, EmrCode) As %String
{
       k ^t2,^DHCNurEmrGen2
       s str=##class(NurEmr.NurEmrSub).GetKCode(EmrCode)
       if str="" s str=##class(NurEmr.NurEmrSub).getData(EmrCode)
       if str'=""   
	   {
		S ITM=##CLASS(NurEmr.NurEmrSub).%OpenId(str)
		s Data=ITM.EmrSubData
		s title=ITM.EmrSubDesc
	   }else
	   {
	    q ""
	   }
	   d Data.Rewind()
       s Reader=..GetReader(str,Data)
       s ^flag2="0"
       s num=0
       while Reader.Read()
       {
	     if Reader.Name=Code
	     {   
	       d ..readxml2(Reader,Code,Code,Reader.NodeType,"",.num) 
	       if ^flag2="1" q
		 }
       }
       k ^t2
}

ClassMethod GetReader20170908(id As %String, DissolveStream As %Stream) As %XML.TextReader
{
	s AFileName=..GetFileName(id) 
	S stream=##class(%FileCharacterStream).%New()
	S stream.Filename=AFileName
	d stream.TranslateTableSet("UTF8")
	d stream.WriteLine("<?xml version=""1.0"" encoding=""UTF-8""?>")
	//b ///sdfsdf
	while (DissolveStream.AtEnd = 0)
	{ 
		s readstring=DissolveStream.Read(1024)
		
	 	d stream.Write(readstring)
	}

	d stream.SaveStream()
	D stream.%Close()
	S sc = ##class(%XML.TextReader).ParseFile(AFileName,.reader)
	//b ;sc
	q reader
}

ClassMethod GetReader(id As %String, DissolveStream As %Stream) As %XML.TextReader
{
	s reader=""
	// 备份
	s AFileName=..GetFileName(id) 
	S stream=##class(%FileCharacterStream).%New()
	S stream.Filename=AFileName
	d stream.TranslateTableSet("UTF8")
	d stream.WriteLine("<?xml version=""1.0"" encoding=""UTF-8""?>")
	//b ///sdfsdf
	while (DissolveStream.AtEnd = 0)
	{ 
		s readstring=DissolveStream.Read(1024)
	 	d stream.Write(readstring)
	}
	d stream.SaveStream()
	D stream.%Close()
	i (DissolveStream'="") {
		d DissolveStream.Rewind()
		s sc=##class(%XML.TextReader).ParseStream(DissolveStream,.reader)
		i ($$$ISERR(sc)) s reader=""
	}
	q reader
}

/// Creator: 未知
/// Modified by: 徐保良 徐鹏
/// ModifyDate: 2017-08-01
/// Description: (1)修改了文件冗余的Bug;(2)更换了文件路径,改用公司标准文件路径;
/// Input: aID:护理病历模板ID
/// Return: 备份文件路径及ID
/// Others: w ##class(web.DHCNUREMRHead).GetFileName("NurTemplate001")
ClassMethod GetFileName(aID As %String) As %String
{
	s AOSString = ##class(%SYSTEM.Version).GetOS()
 	s WindowsFlag =$Find(AOSString,"Windows") 
 	// 根据操作系统是否Windows,确定文件目录
	if WindowsFlag>0{
		s FilePath="C:\backup\dhccbak\nurmodel"
	}else{
		s FilePath="/backup/dhccbak/nurmodel"
	}
	// 目录不存在,则创建目录
	if '##Class(%Library.File).DirectoryExists(FilePath){
		s Result = ##Class(%Library.File).CreateDirectoryChain(FilePath) 
	}
	// 目录+模板ID作为文件名字
	if (WindowsFlag>0){
		s FileNameStr = FilePath_"\"_$TR(aID,"||","")_".xml"	   	 
    }else{
		s FileNameStr = FilePath_"/"_$TR(aID,"||","")_".xml"  		 
	}
	
	Quit FileNameStr
}

ClassMethod GetFileName20170908(aID As %String) As %String
{
 s AOSString = ##class(%SYSTEM.Version).GetOS()
 s WindowsFlag =$Find(AOSString,"Windows") 
 S UNIXFlag =$Find(AOSString,"UNIX") 
     
	 set FilePath=""  //$ZUTIL(12,"")_"TempMG"
	 if WindowsFlag>0
	 {
	      s FilePath="c:\tmp"
	
	 }
	 if (UNIXFlag>0) 
	 {	
	     s FilePath="/tmp/TempMG"

	 }
 
	
	 if '##Class(%Library.File).DirectoryExists(FilePath)
	 {
		 s Result = ##Class(%Library.File).CreateDirectoryChain(FilePath) 
	 }
	 
	 if (WindowsFlag>0) 
	 {
	   s FileNameStr = FilePath_"\"_$J_"_"_$TR(aID,"||","")_".xml"
	   Quit FileNameStr	 
		 
     }
	 if (UNIXFlag>0) 
	 {
	   s FileNameStr = FilePath_"/"_$J_".xml"
	   Quit FileNameStr	 
	 }
}

ClassMethod readxml(xRead, code, nod, typ, prev)
{
    //if ($F(nod,0,3)=$F(prev,0,3))&( typ="endelement" )  s ^json=^json_","
    if (nod=code)&(typ="endelement") 
    {
	    s ^flag="1"
    }
	while xRead.Read()
	{  
	    s prevnod=nod
	    s curr=nod
		s nod=xRead.Name
	    if ^flag="1"  q
		s path=xRead.Path
		s l=$l(path,"/")
		//if path'="" s ^DHCNurEmrGen(path)=""
	    if xRead.MoveToAttributeName("Title")	
        {
	        s ^DHCNurEmrGen(path)=xRead.Value
	    }
        d ..readxml(xRead,code,nod,xRead.NodeType,prevnod)
	    if ^flag="1"  q
	}
}

ClassMethod getfree(Reader, itmname) As %String
{
   
    s itm=""
    //b ///ddf
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

ClassMethod GetStoreByItem(a) As %String
{
   s l=$L(a,"^")
   s dd=""
   for i=1:1:l
   {
     if $P(a,"^",i)="" continue
     s itm=$p(a,"^",i)
     s text=$p(itm,"|")
     s val=$p(itm,"|",2)
     if dd="" s dd="{desc:'"_text_"',id:'"_val_"'}"
     e  s dd=dd_","_"{desc:'"_text_"',id:'"_val_"'}"
   }
   s dd="["_dd_"]"
   s a="new Ext.data.JsonStore({data : "_dd_",fields: ['desc', 'id']})"
   q a
}

/// 护理记录单打印接口
/// 根据模版与科室取自定义列名
ClassMethod GetLableRec(parr As %String, tmpLab) As %String
{
	//s a=##class(Nur.DHCNurChangeLableRec).GetLableRec("DHCNUR6^211")
	s EmrCode=$P(parr,"^",1)
	s EmrCode=$zcvt(EmrCode,"U")
	s LableLocDr=$P(parr,"^",2)
	q:(EmrCode="")!(LableLocDr="") ""
	s ret=""
	s rw="" f  s rw=$O(^Nur.DHCNurChangeLableRecI("LableLoc"," "_EmrCode," "_LableLocDr,rw)) q:rw=""  d
	.s arr=^Nur.DHCNurChangeLableRecD(rw)
	.s LableId=$List(arr,4)
	.s LableDesc=$List(arr,3)
	.s ret=ret_LableId_"|"_LableDesc_"&"
	.i '$d(tmpLab(LableId)) d
	..s tmpLab(LableId)=LableDesc
    i ret="" 
    {
	    s locid="" f  s locid=$O(^Nur.DHCNurChangeLableRecI("LableLoc"," "_EmrCode,locid)) q:locid=""  d
	    .s rw="" f  s rw=$O(^Nur.DHCNurChangeLableRecI("LableLoc"," "_EmrCode,locid,rw)) q:rw=""  d
	    ..s arr=^Nur.DHCNurChangeLableRecD(rw)
	    ..s LableId=$List(arr,4)
	    ..s LableDesc=$List(arr,3)
	    ..i '$d(tmpLab(LableId)) d
	    ...s tmpLab(LableId)=LableDesc
	}
    q ""
}

ClassMethod getcols1(str, itmdata, code, widthstr, itmrel, itmlink, headtmp, check = "N", headcode, headselected) As %String
{
 // s a="[{header:'项目名称',dataIndex:'name'},{header:'开发团队',dataIndex:'organization'},{header:'网址',dataIndex:'homepage'}]"
  // s a=##class(web.DHCNUREMR).getcols1()
   //s str="日期!a1!D21!1^日期!a1!D21!1^时间!a2!"
  // s str=str_"D22!2^时间!a2!D22!2^有无发生!a3!O103!3^有无发生!a3!O103!3^发生(面积 部位 程度)!a4!S104!4^发生(面积 部位 程度)!a4!S104!4^再评分!a5!S106!5^再评分!a5!S106!5^签名!a6!I111!6^签名!a6!I111!6^"
   i $D(%session) s Loc=$G(%session.Data("LOGON.CTLOCID"))
   e  s Loc="" 
   //k tmpLableRec
   //d ..GetLableRec(code_"^"_Loc,.tmpLableRec)
   //s h=""  f  s h=$O(tmpLableRec(h)) q:h=""  d
   //.if $G(headtmp(h))'=""  s tmpLableRec(h)=headtmp(h) 
   s l=$L(str,"^")
   s checkcodestr="^"_$G(^DHCMgNurCheckSum(code))  //质控汇总
   for i=1:1:l
   {
      s itmstr=$P(str,"^",i)
      s width=$P(widthstr,"^",i)
      if itmstr="" continue
      s head=$P(itmstr,"!",1)
      s dataindex=$P(itmstr,"!",2)
      s itmcode="^"_dataindex_"^"
      if checkcodestr'=""
      {
         if checkcodestr[itmcode continue
      }
      s col=$P(itmstr,"!",3)
      s setstr=""
      s stordata=""
      if $D(itmdata(code,col)) s setstr=itmdata(code,col)
      //if $E(col,0,1)="D" s setstr="D^Y"
      if (($E(col,0,1)="D" )&(setstr'=""))
      { 
        s flag=$P(setstr,"^",1)
        
        s typ=$P(setstr,"^",2)
        if typ="D" s xtype="datefield"
        if typ="T" s xtype="timefield"
      }
      if $E(col,0,1)="S" s xtype="textfield"
      if $E(col,0,1)="E" s xtype="textarea"
      if $E(col,0,1)="G" s xtype="textarea"
      if $E(col,0,1)="O" s xtype="combo"
      if $E(col,0,1)="I" s xtype="combo"
      if $E(col,0,1)="M" d
      .s name=$P(itmstr,"!")
      .s xtype="lvcombo"
      .s stordata=..GetStore($G(itmdata(code,col)))
      s readonly="false"
      //if dataindex="CaseMeasure" s readonly="true"
      //if $E(col,0,1)="M" s readonly="true"
      s pos=$P(itmstr,"!",4)
      if pos="" s pos=i
      i dataindex="Item31"  d
      .b ;item31
      //if $G(dataindex)'="",$D(tmpLableRec(dataindex)) s head=tmpLableRec(dataindex)
      if $G(dataindex)'="",$D(headtmp(dataindex)) s head=headtmp(dataindex)
      b ;990
      s titlH="{header:'"_head_"',dataIndex:'"_dataindex_"',width:"_width_","
      i xtype="datefield" s titlH=titlH_"renderer:function(value){if(value instanceof Date){ return new Date(value).format(websys_DateFormat);}else{ return value}},"
      //i xtype="datefield" s titlH=titlH_"renderer:function(value){if(value instanceof Date){ return new Date(value).format(""Y-m-d"");}else{ return value}},"
      s cls="",mth="",dl="Desc",vl="id",parrm=""
      s link=$G(itmlink(code,col))
      if $G(itmlink(code,col))'="" d
      .s cls=$P(link,":",1),mth=$P(link,":",2),parrm=$P(link,":",3),dl=$P(link,":",4),vl=$P(link,":",5)

      if (xtype="combo" )
      {
	     s stordata=..GetStore($G(itmdata(code,col)))
	     //b ;888
		 if (code="DHCNURHEADCHANGE") //表头变更维护界面
		 {
			 s retdata=##class(Nur.DHCNurHeadKnowledge).getdepHead(headcode,Loc)
			 //s ^objjj888=retdata
			 i retdata'="" s stordata=..GetStoreByStr(retdata)
	     }
	     else
	     {
		    if (head'="")
		    {
		       if ($d(headselected(head)))
	           {
		         s l=$L(headselected(head),",")
		         i (l=1)&&(headselected(head)="") d  //如果没有维护下拉项
		         .s xtype="textfield"  
		         e  d
		         .s stordata=..GetStoreByStr(headselected(head))
		       }
		    }
		     
		 }
		// s parr=Loc_"^"_code_"^"_dataindex  //2014-06-28
		//s strlist=##class(Nur.DHCNurZSKData).getitemlist(parr) //2014-06-28
		// i strlist'="" d
		// .s stordata=..GetStoreByItem(strlist) //2014-06-28
	     //s ^obj178(code,col,dataindex)=strlist
	    
	     if ($G(itmlink(code,col))'="")&(Loc'="")
	     {
		     //s ^TMP("ll")=itmlink(code,col)_"^"_Loc
		  // s stordata=..GetStore(##class(web.DHCMGPrintComm).GetData(itmlink(code,col),"Loc:"_Loc))
		 }
	    // b  ///ds
	     
	  }
      if xtype="lvcombo" s con="editor:new Ext.grid.GridEditor(new Ext.ux.form.LovCombo({hideOnSelect:false,displayField:'id', valueField:'desc',store:"_$G(stordata)_",mode:'local'}))}"
      if link="" 
      {
	   
	    if (xtype="combo") s con="editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({displayField:'id',triggerAction : 'all', valueField:'desc',store:"_$G(stordata)_",mode:'local'}))}"
      }else{
       	
        if (xtype="combo")  d
        .//s con="renderer:function(object,a,b,c,d,e){ if(object==undefined){ return """" }else{ alert(d+""@""+e);return (Ext.getCmp(""mygrid"").getColumnModel().getCellEditor(d,e).mons[0].item.lastSelectionText);}},"
        .//..GenerateComBoxMeta(dl_"^"_vl,cls,mth)
        .//.s con="editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({store:CreateStore('"_cls_"','"_mth_"'),listWidth:400,displayField:'"_dl_"', valueField:'"_dl_"',hideTrigger:true,queryParam:'"_parrm_"',forceSelection:true,triggerAction:'all',minChars:1,pageSize:10,typeAhead:true,typeAheadDelay:1000,loadingText:'Searching...'}))}"
        .s con="editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({store:"_..GenerateComBoxMeta(dl_"^"_vl,cls,mth)_",listWidth:400,displayField:'"_dl_"', valueField:'"_dl_"',hideTrigger:false,queryParam:'"_parrm_"',forceSelection:true,triggerAction:'all',minChars:1,pageSize:10,typeAhead:true,typeAheadDelay:1000,loadingText:'Searching...'}))}"
      }
      if xtype="textarea" s con= "editor: new Ext.grid.GridEditor(new Ext.form.TextArea({readOnly:"_readonly_",grow:true}))}"
      if xtype="textfield" s con= "editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:"_readonly_"}))}"
      //if xtype="datefield" s con=" renderer:Ext.util.Format.dateRenderer('Y-m-d'),editor: new Ext.grid.GridEditor(new Ext.form.DateField({id:'"_col_"',format: 'Y-m-d'}))}"
      //if xtype="datefield" s con=" renderer:Ext.util.Format.dateRenderer('Y-m-d'),editor: new Ext.grid.GridEditor(new Ext.form.DateField({id:'"_col_"',format: 'Y-m-d'}))}"
      if xtype="datefield" s con=" editor:new Ext.form.DateField({id:'"_col_"'})}"
      
      //if xtype="datefield" s con=" editor: new Ext.grid.GridEditor(new Ext.form.DateField({id:'"_col_"',format: 'Y-m-d'}))}"
      if xtype="timefield" s con="editor: new Ext.grid.GridEditor(new Ext.form.TimeField({format: 'H:i'}))}"
      s titlH=titlH_con
      s tt(i)=titlH

   }
   s a="["
   if check="Y"  s a="[new Ext.grid.RowNumberer(),sm,"
   s p=""  f  s p=$O(tt(p)) q:p=""  d
   .s a=a_tt(p)_","
   s a=$e(a,0,$l(a)-1)
   s a=a_"]"
  q a
}

ClassMethod GenerateComBoxMeta(str As %String, cls, Rmth) As %String
{
 //w ##class(web.DHCNUREMR).GenerateComBoxMeta
 s ^TMP("str")=$LB(str, cls, Rmth)
   s ret="{root:'rows',totalProperty:'results',fields:["
   s l=$L(str,"^")
   s mth=$P(Rmth,".")
   s QueryTyp="Query"
   if $P(Rmth,".",2)'="" s QueryTyp=$P(Rmth,".",2)
   b
   for i=1:1:l
   {
      s itm=$P(str,"^",i)
      if itm="" continue
      s head=itm
      s dataindex=itm
      s h(i)=dataindex
      s ret=ret_"{'name':'"_dataindex_"','mapping':'"_dataindex_"'}"
      b
      i i'=(l) s ret=ret_","
   }
   //s ret=$e(ret,0,$l(ret)-1)
   s ret=ret_"]}"  
   s ret1="new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:""../csp/dhc.nurse.ext.common.getdata.csp""}),reader:new Ext.data.JsonReader("_ret_"),"
   s ret2="baseParams:{className:'"_cls_"',methodName:'"_mth_"',type:'"_QueryTyp_"'}"
   s ret=ret1_ret2_"})"
  q ret
}

/// add by Linyuxu 2014-05-05
ClassMethod GetStoreByStr(a) As %String
{
   s l=$L(a,",")
   s dd=""
   for i=1:1:l
   {
     if $P(a,",",i)="" continue
     s text=$p(a,",",i)
     s val=text
     if dd="" s dd="{desc:'"_text_"',id:'"_val_"'}"
     e  s dd=dd_","_"{desc:'"_text_"',id:'"_val_"'}"
   }
   s dd="["_dd_"]"
   s a="new Ext.data.JsonStore({data : "_dd_",fields: ['desc', 'id']})"
   q a
}

ClassMethod getitmstore(a)
{
   s text=$P(a,"|")
   s val=$P(a,"|",2)
   if val="" s val=text
  //s str="['"_text_"','"_val_"']"
   s str="{desc:'"_text_"',id:'"_val_"'}"
   q str
}

ClassMethod GetStore(a) As %String
{
   s l=$L(a,"!")
   s dd=""
   for i=1:1:l
   {
     if $P(a,"!",i)="" continue
     if dd="" s dd=..getitmstore($P(a,"!",i))
     e  s dd=dd_","_..getitmstore($P(a,"!",i))
   }
 s dd="["_dd_"]"
 s a="new Ext.data.JsonStore({data : "_dd_",fields: ['desc', 'id']})"
  q a
}

ClassMethod GetLinkData(a) As %String
{
  
 // s a="new Ext.data.JsonStore({data : [],fields: ['desc', 'id']})"
 // q a

  //q "" ;
  if a="" q ""
  s cls=$P(a,"^",1)
  s mth=$P(a,"^",2)
  s dt="##class("_cls_")."_mth_"()"
 // b  ///333
  q @dt
}

ClassMethod GetRadioGrp(a, cnname, selitm) As %String
{

   s l=$L(a,"!")
   s dd=""
   for i=1:1:l
   {
     if $P(a,"!",i)="" continue
     s itm=$P(a,"!",i)
     s id=$p(itm,"|",2)
     s txt=$p(itm,"|")
     s cl=$L(selitm,"^")
     s flag="false"
     for j=1:1:cl
     {
	    s sel=$P(selitm,"^",j)
	    if txt=$TR(sel," ","") s flag="true"
	 }
	// b //checSel
     if id="" s id=i
     if dd="" s dd="{name:'"_cnname_"',id:'"_cnname_"_"_id_"',xtype:'radio',checked:"_flag_", boxLabel:'"_txt_"'}"
     e  s dd=dd_",{name:'"_cnname_"',id:'"_cnname_"_"_id_"',xtype:'radio',checked:"_flag_", boxLabel:'"_txt_"'}"
   }
   q "["_dd_"]"
}

ClassMethod GetCheckGrp(a, cnname, selitm) As %String
{

   s l=$L(a,"!")
   s dd=""
   for i=1:1:l
   {
     if $P(a,"!",i)="" continue
     s itm=$P(a,"!",i)
     s id=$p(itm,"|",2)
     s txt=$p(itm,"|")
     s cl=$L(selitm,"^")
     s flag="false"
     for j=1:1:cl
     {
	    s sel=$P(selitm,"^",j)
	    if txt=$TR(sel," ","") s flag="true"
	 }
	// b //checSel
     if id="" s id=i
     if dd="" s dd="{name:'"_cnname_id_"',id:'"_cnname_"_"_id_"',xtype:'checkbox',checked:"_flag_", boxLabel:'"_txt_"'}"
     e  s dd=dd_",{name:'"_cnname_i_"',id:'"_cnname_"_"_id_"',xtype:'checkbox',checked:"_flag_", boxLabel:'"_txt_"'}"
   }
   q "["_dd_"]"
}

ClassMethod getvalFlag(a) As %String
{
   s flag=1
   s l=$L(a,"!")
   s dd=""
   s itm=$P(a,"!",1)
   if itm="" q flag
   s text=$P(itm,"|")
   s val=$P(itm,"|",2)
   if val="" s flag=2
 q flag
}

ClassMethod GetComboData(a) As %String
{
   s l=$L(a,"!")
   s dd=""
   for i=1:1:l
   {
     if $P(a,"!",i)="" continue
     if dd="" s dd=..getitmstore($P(a,"!",i))
     e  s dd=dd_","_..getitmstore($P(a,"!",i))
   }
 s dd="["_dd_"]"
 // s a="new Ext.data.SimpleStore({data : "_dd_",fields: ['desc', 'id']})"
  q dd
}

ClassMethod getstore1(str, data) As %String
{
 s b="[ [1, 'EasyJWeb', 'EasyJF','www.easyjf.com'],[2, 'jfox', 'huihoo','www.huihoo.org']," 

 s b=b_"[3, 'jdon', 'jdon','www.jdon.com'],"

 s b= b_"[4, 'springside', 'springside','www.springside.org.cn'] ]"
  s l=$L(str,"^")
  s ret="["
   for i=1:1:l
   {
      s itmstr=$P(str,"^",i)
      if itmstr="" continue
      s head=$P(itmstr,"!",1)
      s dataindex=$P(itmstr,"!",2)
      s h(i)=dataindex
      s ret=ret_"'"_dataindex_"',"
   }
    s ret=$e(ret,0,$l(ret)-1)
    s ret=ret_"]"   //",{x:100,y:200,xtype:'timefield',anchor:'10%'}]"  
   s tdata=$P(data,"$",3)
   s rws=$L(tdata,"^")
   s tt="["
   for i=1:1:rws
   {
	   s cldata=$P(tdata,"^",i)
	   s cols=$L(cldata,"!")
	   s cret="{"
	   if cldata="" continue
	   for c=1:1:cols
	   {
	     if '$D(h(c)) continue
	     s cd=$P(cldata,"!",c)
	     if cd="" s cd=""
	     if h(c)="CareDate" 
	     {
		     s cd="Date()"
		     s cret=cret_h(c)_":"_cd_","
	     }
	     else{
	     s cret=cret_h(c)_":'"_cd_"',"
	     }
	   } 
	   s cret=$e(cret,0,$l(cret)-1)
	   s tt=tt_cret_"},"
   }
   s tt=$e(tt,0,$l(tt)-1)
   s tt=tt_"]"
   //s a="new Ext.data.JsonStore({data:"_tt_",fields:"_ret_"})"
   s a="new Ext.data.JsonStore({data:[],fields:"_ret_"})"
 // b //7777000000
 q a
}

ClassMethod GetLinkData1(a) As %String
{
  if a'="" s id=$P(a,"|",1),des=$P(a,"|",2)
  if a="" s b="new Ext.data.JsonStore({data : [],fields: ['desc', 'id']})"
  if a'="" s b="new Ext.data.JsonStore({data : [{desc:'"_des_"',id:'"_id_"'}],fields: ['desc', 'id']})"
  q b

  q "" ;
  if a="" q ""
  s cls=$P(a,"^",1)
  s mth=$P(a,"^",2)
  s dt="##class("_cls_")."_mth_"()"
  q @dt
}

ClassMethod GenerateMetaData(str As %String, cls, Rmth) As %String
{
   s ret="{root:'rows',totalProperty:'results',fields:["
   s l=$L(str,"^")
   s mth=$P(Rmth,".")
   s QueryTyp="Query"
  if $P(Rmth,".",2)'="" s QueryTyp=$P(Rmth,".",2)
   for i=1:1:l
   {
      s itmstr=$P(str,"^",i)
      if itmstr="" continue
      s head=$P(itmstr,"!",1)
      s dataindex=$P(itmstr,"!",2)
      s h(i)=dataindex
      s ret=ret_"{'name':'"_dataindex_"','mapping':'"_dataindex_"'}"
      i i'=l s ret=ret_","
   }
   s ret=$e(ret,0,$l(ret)-1)
   s ret=ret_"]}"  
   s ret1="new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:""../csp/dhc.nurse.ext.common.getdata.csp""}),reader:new Ext.data.JsonReader("_ret_"),"
   s ret2="baseParams:{className:'"_cls_"',methodName:'"_mth_"',type:'"_QueryTyp_"'}"
   s ret=ret1_ret2_"})"
  q ret
}

ClassMethod GetGrpHead(Code As %String, EmrCode) As %String
{
	//s a=##class(web.DHCNUREMR).GetGrpHead("T152","DHCNURWKHLJL")
	   k ^t,^DHCNurEmrGen
	  // s Code="T101",EmrCode="DHCNURPRN2"
        s str=##class(NurEmr.NurEmrSub).GetKCode(EmrCode)
        if str="" s str=##class(NurEmr.NurEmrSub).getData(EmrCode)
       // b /////d
        //s ^pjf(132)=EmrCode_"@"_Code
       if str'=""   
	   {
		S ITM=##CLASS(NurEmr.NurEmrSub).%OpenId(str)
		s Data=ITM.EmrSubData
		s title=ITM.EmrSubDesc
		//b ///33
	   }else
	   {
	    q ""
	   }
	
	d Data.Rewind()
   // Set sc = ##class(%XML.TextReader).ParseStream(a.EmrData,.Reader)
  
    s Reader=..GetReader(str,Data)
    
     s ^flag="0"
     s num=0
     //b ////11111111111111
     while Reader.Read()
     {
	    if Reader.Name=Code
	    {   
	       d ..readxml1(Reader,Code,Code,Reader.NodeType,"",.num) 
	       if ^flag="1" q
		}
    }
    //b ;001
    k ^t
    s rows=0
    s maxrow=0
    s r=""  f  s r=$O(^DHCNurEmrGen(r)) q:r=""  d
    .s itm="" f  s itm=$O(^DHCNurEmrGen(r,itm)) q:itm=""  d
    ..s l=$L(itm,"/")
    ..s rows=0
    ..s tt=$P(itm,"/",l)
    ..if $F(tt,Code)'=0  s head(l-2,r,tt)=^DHCNurEmrGen(r,itm)
    ..e  d
    ...s a1=$P(itm,"/",3)
    ...s a2=$P(itm,"/",4)
    ...s a3=$P(itm,"/",5)
    ...s a4=$P(itm,"/",6)
    ...if l=6 s thead(r,a1,a2,a3,a4)=^DHCNurEmrGen(r,itm)
    ...if l=5 s thead(r,a1,a2,a3)=^DHCNurEmrGen(r,itm)
    ...if l=4 s thead(r,a1,a2)=^DHCNurEmrGen(r,itm)
    ..f i=1:1:l  d
    ...s tm=$P(itm,"/",i)
    ...s fl=$F(tm,Code)
    ...if fl'=0 s rows=rows+1
    ...if rows>maxrow s maxrow=rows
    //b ;002
    s rw=2
    s JRows=""
    s ret=""
    f rw=2:1:maxrow
    {
	   d ..getcolspan(.head,rw,Code)
	   s r="" f  s r=$O(^DHCNurEmrGen(r)) q:r=""  d
	   .s it="" f  s it=$O(^DHCNurEmrGen(r,it)) q:it=""  d
	   ..s l=$L(it,"/")
	   ..q:l>(rw+2)
	   ..s itm=$P(it,"/",l)
	   ..s fl=$F(itm,Code)
	   ..if fl=0  d
	   ...s JRows(rw)=$G(JRows(rw))_"{},"
	   ..else  d
	   ...if $D(head(rw,r,itm)) d
	   ....s titl=$P(head(rw,r,itm),"^")
	   ....s colsspan=$P(head(rw,r,itm),"^",2)
	   ....s JRows(rw)=$G(JRows(rw))_"{header:'"_titl_"',colspan:"_colsspan_",align:'center'},"
	    s JRows(rw)="["_$e(JRows(rw),0,$l(JRows(rw))-1)_"]"
        s ret=ret_JRows(rw)_","
	}
	s ret="["_$e(ret,0,$l(ret)-1)_"]"
	q ret
}

/// w##class(web.DHCNUREMRHead).Replace("abcdefghijklmn&KeyEnter;opqrstuvwxyz","&KeyEnter;","\n")
ClassMethod Replace(Strings, Str, Rep) As %String
{
 Q ..ReplaceCommon(Strings,Str,Rep)
}

/// 要求被替换的内容不能=""
ClassMethod ReplaceCommon(instr As %String, substr As %String, replacement As %String) As %String
{
	;
	q:(substr="") instr
	;q:(replacement="") instr
	q:'($l(instr,substr)>1) instr
	
	s mylen=$l(instr,substr)
	for myIdx=1:1:mylen {
		s myary(myIdx)=$p(instr,substr, myIdx)
	}
	
	s mystr=""
	s myIdx=""
	s myIdx=$o(myary(myIdx))
	while (myIdx'=""){
		s myrepstr=""
		i ($o(myary(myIdx))=""){
			s myrepstr=myary(myIdx)
		}else{
			s myrepstr=myary(myIdx)_replacement
		}
		
		i (mystr=""){
			s mystr=myrepstr
		}else{
			s mystr=mystr_myrepstr
		}
		
		s myIdx=$o(myary(myIdx))
		q:(myIdx="")
	}
	
	q mystr
}

ClassMethod getpdata(cls, mth, p, pdata, arr)
{
	           s data=##class(web.DHCMGPrintComm).GetData(cls_":"_mth,p)
	           b ;234
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
				   s pdata(dm)=$zcvt($G(bb(dv)),"o","JS")
				 }
		       }
}

ClassMethod getcolspan(head, rw, Code)
{
   s cols=0
   s r=""  f  s r=$O(head(rw,r)) q:r=""  d
   .s h=""  f  s h=$O(head(rw,r,h)) q:h=""  d
   ..s head(rw,r,h)=head(rw,r,h)_"^"_..getcls(h,Code)
}

ClassMethod getcls(h, Code) As %String
{
    s cols=0
	s gg="" f  s gg=$O(^DHCNurEmrGen(gg)) q:gg=""  d
    .s aa="" f  s aa=$O(^DHCNurEmrGen(gg,aa)) q:aa=""  d
    ..s a=$P(aa,h,2)
    ..s l=$L(aa,"/")
    ..s b=$P(aa,"/",l)
    ..s fl=$F(b,Code)
    ..//if (a'="")&(fl=0)  s cols=cols+1
    ..if ($p(a,"/")="")&(a'="")&(fl=0)  s cols=cols+1
   q cols
}

ClassMethod readxml1(xRead, code, nod, typ, prev, num)
{
    //if ($F(nod,0,3)=$F(prev,0,3))&( typ="endelement" )  s ^json=^json_","
    if (nod=code)&(typ="endelement") 
    {
	    s ^flag="1"
    }
	while xRead.Read()
	{  
	    s prevnod=nod
	    s curr=nod
		s nod=xRead.Name
	    if ^flag="1"  q
		s path=xRead.Path
		s l=$l(path,"/")
		//if path'="" s ^DHCNurEmrGen(num,path)=""
	    if xRead.MoveToAttributeName("Title")	
        {
	        s ^DHCNurEmrGen(num,path)=xRead.Value
	    }
		s num=num+1			    
        d ..readxml1(xRead,code,nod,xRead.NodeType,prevnod,.num)
	    if ^flag="1"  q
	}
}

Storage Default
{
<Data name="DHCNUREMRHeadDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCNUREMRHeadD</DataLocation>
<DefaultData>DHCNUREMRHeadDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCNUREMRHeadD</IdLocation>
<IndexLocation>^web.DHCNUREMRHeadI</IndexLocation>
<StreamLocation>^web.DHCNUREMRHeadS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
