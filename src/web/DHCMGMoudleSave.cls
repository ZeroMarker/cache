Class web.DHCMGMoudleSave Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod test()
{
    while Reader.Read()
	{            //w !,Reader.Name
	             s ItmName=Reader.Name
	             s RelName=""
	             if (Reader.NodeType="endelement")
	             {
		          if Reader.Name'=""  s xml=xml_"</"_Reader.Name_">"
		         }else
		         {
	               if Reader.Name'="" s xml=xml_"<"_Reader.Name
		         }
	             if ((Reader.Name="")&(Reader.NodeType="chars")) 
	             {
		             s xml=xml_Reader.Value
	             }

                 if Reader.MoveToAttributeName("RelName") 
                 {
	                s xml=xml_" RelName='"_Reader.Value_"'"
	                s RelName=Reader.Value
	             }
 		         if Reader.MoveToAttributeName("Link")  
 		         {
	                s xml=xml_" Link='"_Reader.Value_"'"
	             }

                 if Reader.MoveToAttributeName("Title")
                 {
	                s xml=xml_" Title='"_Reader.Value_"'"
	             }

			    if Reader.MoveToAttributeName("Pos") 
			    {
	                s xml=xml_" Pos='"_Reader.Value_"'"
	             }

			    if Reader.MoveToAttributeName("Query")
			    {
	                s xml=xml_" Query='"_Reader.Value_"'"
	             }

			    if Reader.MoveToAttributeName("MIndex")
			    {
	                s xml=xml_" MIndex='"_Reader.Value_"'"
	             }

			    if Reader.MoveToAttributeName("IDNO")
			    {
	                s xml=xml_" IDNO='"_Reader.Value_"'"
	             }

			    if Reader.MoveToAttributeName("Width")
			    {
	                s xml=xml_" Width='"_Reader.Value_"'"
	             }

			    if Reader.MoveToAttributeName("Height")
			    {
	                s xml=xml_" Height='"_Reader.Value_"'"
	             }

			    if Reader.MoveToAttributeName("Continue")
			    {
	                s xml=xml_" Continue='"_Reader.Value_"'"
	             }

			    if Reader.MoveToAttributeName("type")
			    {
	                s xml=xml_" type='"_Reader.Value_"'"
	             }

			    if Reader.MoveToAttributeName("text")
			    {
	              if ($E(ItmName,0,1)="S")!($E(ItmName,0,1)="D")
	              {
		             if $D(tmval(RelName)) s xml=xml_" text='"_tmval(RelName)_"'"
		             e  s xml=xml_" text=''"
		          } 
	              
	             }

			    if Reader.MoveToAttributeName("top")
			    {
	                s xml=xml_" top='"_Reader.Value_"'"
	            }
			    if Reader.MoveToAttributeName("hidden")
			    {
	                s xml=xml_" hidden='"_Reader.Value_"'"
	            }

			    if Reader.MoveToAttributeName("ofx")
			     {
	                s xml=xml_" ofx='"_Reader.Value_"'"
	             }

			    if Reader.MoveToAttributeName("ofy")
			    {
	                s xml=xml_" ofy='"_Reader.Value_"'"
	            }

			    if Reader.MoveToAttributeName("width")
			    {
	                s xml=xml_" width='"_Reader.Value_"'"
	            }

			    if Reader.MoveToAttributeName("height")
			    {
	                s xml=xml_" height='"_Reader.Value_"'"
	             }

			    if Reader.MoveToAttributeName("tabindex")
			    {
	                s xml=xml_" tabindex='"_Reader.Value_"'"
	            }

			    if Reader.MoveToAttributeName("bgcolor")
			    {
	                s xml=xml_" bgcolor='"_Reader.Value_"'"
	            }

			    if Reader.MoveToAttributeName("fontcolor")
			    {
	                s xml=xml_" fontcolor='"_Reader.Value_"'"
	            }

				if Reader.MoveToAttributeName("fontname")
				{
	                s xml=xml_" fontname='"_Reader.Value_"'"
	            }

				if Reader.MoveToAttributeName("fontsize")
				{
	                s xml=xml_" fontsize='"_Reader.Value_"'"
	            }

				if Reader.MoveToAttributeName("b")
				{
	                s xml=xml_" b='"_Reader.Value_"'"
	             }

				if Reader.MoveToAttributeName("i")
				{
	                s xml=xml_" i='"_Reader.Value_"'"
	            }

				if Reader.MoveToAttributeName("u")
				{
	                s xml=xml_" u='"_Reader.Value_"'"
	            }

				if Reader.MoveToAttributeName("fontunit") 
				 {
	                s xml=xml_" fontunit='"_Reader.Value_"'"
	             }

				if Reader.MoveToAttributeName("selecttext")
				 {
	               // if s xml=xml_" selecttext='"_Reader.Value_"'"
	                if $E(ItmName,0,1)="O"
	                {
		             if $D(tmval(RelName)) s xml=xml_" selecttext='"_tmval(RelName)_"'"
		             e  s xml=xml_" selecttext=''"
		            } 
	             }
				if Reader.MoveToAttributeName("selectItm")
				{
	                //s xml=xml_" selectItm='"_Reader.Value_"'"
	                if $E(ItmName,0,1)="M"
	                {
		             if $D(tmval(RelName)) s xml=xml_" selectItm='"_tmval(RelName)_"'"
		             e  s xml=xml_" selectItm=''"
		            } 
                   if $E(ItmName,0,1)="I"
	                {
		             if $D(tmval(RelName)) s xml=xml_" selectItm='"_tmval(RelName)_"'"
		             e  s xml=xml_" selectItm=''"
		            } 

	             }

				if Reader.MoveToAttributeName("DateFlag")
				 {
	                s xml=xml_" DateFlag='"_Reader.Value_"'"
	             }

				if Reader.MoveToAttributeName("TimeFlag")
				{
	                s xml=xml_" TimeFlag='"_Reader.Value_"'"
	            }
              if (Reader.NodeType'="chars")&(Reader.NodeType'="endelement") s xml=xml_">"
	}
}

ClassMethod SaveMoudle(rowid As %String, code As %String, parr As %String, EpisodeId As %String, person As %String = "", loc As %String = "", mulflag = "N") As %String
{
	//G ,G--<free></free>
	// s xml="" //S--text,D--text,O--,M,G--<free></free>
	      //selecttext,selectItm
	      //w ##class(web.DHCMGMoudleSave).SaveMoudle()
	// s ^TT=$lb(rowid, code, parr , EpisodeId, person, loc )
	//s parr=$list(^TT,3)
	//s EpisodeId=338155 //$list(^TT,4)
   // s code=$list(^TT,2)
	//s ^TT=parr  D--DateTimeValue,I--selectitm
	// s rowid=""
	 s parentid=""
    if EpisodeId'=""
    {
	     s parentid=##class(NurEmr.DHCMgEmrData).getEpisodeId(EpisodeId) 
    }
    if rowid="" 
    {
      if mulflag="N"  s rowid=##class(NurEmr.DHCMgEmrData).getEpisodeIdRowId(EpisodeId,code) //getEpisodeIdRowId
    }
    ///////////////////////解析数据///////////////////////////////////////
    ///b  //////////////////////sd
    s par1=$P(parr,"&")
    s chepar=$P(parr,"&",2)
	s l=$L(chepar,"^")
	s comboret=$P(parr,"&",3)
	f i=1:1:l
	{
	  s itm=$P(chepar,"^",i)
	  if itm="" continue
	  s arr=$P(itm,"|")
	  s name=$P(arr,"_")
	  s selcode=$P(arr,"_",2)
	  s val=$P(itm,"|",2)
      //if '$D(tmval(name)) s tmval(name)=selcode_"|"_val
	  //e  s tmval(name)=tmval(name)_selcode_"|"_val_"^"
	  if '$D(tmval(name)) s tmval(name)=val
	  e  s tmval(name)=tmval(name)_"^"_val
	}
	s l=$L(par1,"^")
	for i=1:1:l
	{
	  s itm=$P(par1,"^",i)
	  if itm="" continue
	  s name=$P(itm,"|")
	  s val=$P(itm,"|",2)
	  s tmval(name)=val
	}
	s l=$L(comboret,"^")
	for i=1:1:l
	{
	  s itm=$P(comboret,"^",i)
	  if itm="" continue
	  s name=$P(itm,"|")
	  s arr=$P(itm,"|",2)
	  s val=$P(arr,"!",1)
	  s des=$P(arr,"!",2)
	  s tmval(name)=val_"|"_des
	}
	//////////////////////////解析//////////////////////////////////////
	/////////取数据////////////////
    Set datastream=##class(%GlobalCharacterStream).%New()
   s title=""
  if rowid'=""
    {
	   // b  ///9999
	   s ITM=##class(NurEmr.DHCMgEmrDataChild).%OpenId(rowid)
	   s itcode=ITM.EmrCode
	   q:code'=itcode ""
	   s Data=ITM.EmrData
	//  if id="54"  b  ///
	}else{
    s str=##class(NurEmr.NurEmrSub).GetKCode(code)
    if str="" s str=##class(NurEmr.NurEmrSub).getData(code)
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
	}
	d Data.Rewind()
	//b ///////t
   // Set sc = ##class(%XML.TextReader).ParseStream(Data,.Reader)
    if rowid'="" s Reader=##class(web.DHCNUREMR).GetReader(rowid,Data)
    e  s Reader=##class(web.DHCNUREMR).GetReader(code,Data)
      
   while Reader.Read()
	{            //w !,Reader.Name
	             s ItmName=Reader.Name
	             s RelName=""
	             if (Reader.NodeType="endelement")
	             {
		          if Reader.Name'=""  d datastream.Write("</"_Reader.Name_">")
		         }else
		         {
	               if Reader.Name'="" d datastream.Write("<"_Reader.Name)
		         }
	             if ((Reader.Name="")&(Reader.NodeType="chars")) 
	             {
		             d datastream.Write(Reader.Value)
	             }

                 if Reader.MoveToAttributeName("RelName") 
                 {
	                d datastream.Write(" RelName='"_Reader.Value_"'")
	                s RelName=Reader.Value
	               // w !,ItmName,"--",RelName
	                if RelName="" s RelName=ItmName
	                s ItmRelName(ItmName)=RelName
	             }
 		         if Reader.MoveToAttributeName("Edit")  
 		         {
	                d datastream.Write(" Edit='"_Reader.Value_"'")
	             }
                 if Reader.MoveToAttributeName("Link")  
 		         {
	                d datastream.Write(" Link='"_Reader.Value_"'")
	             }

                 if Reader.MoveToAttributeName("Title")
                 {
	                d datastream.Write(" Title='"_Reader.Value_"'")
	             }

			    if Reader.MoveToAttributeName("Pos") 
			    {
	                d datastream.Write(" Pos='"_Reader.Value_"'")
	             }

			    if Reader.MoveToAttributeName("Query")
			    {
	                d datastream.Write(" Query='"_Reader.Value_"'")
	             }

			    if Reader.MoveToAttributeName("MIndex")
			    {
	                d datastream.Write(" MIndex='"_Reader.Value_"'")
	             }

			    if Reader.MoveToAttributeName("IDNO")
			    {
	                d datastream.Write(" IDNO='"_Reader.Value_"'")
	             }

			    if Reader.MoveToAttributeName("Width")
			    {
	                d datastream.Write(" Width='"_Reader.Value_"'")
	             }

			    if Reader.MoveToAttributeName("Height")
			    {
	                d datastream.Write(" Height='"_Reader.Value_"'")
	             }

			    if Reader.MoveToAttributeName("Continue")
			    {
	                d datastream.Write(" Continue='"_Reader.Value_"'")
	             }

			    if Reader.MoveToAttributeName("type")
			    {
	                d datastream.Write(" type='"_Reader.Value_"'")
	             }

			    if Reader.MoveToAttributeName("text")
			    {
	              s txt=Reader.Value
	              if ($E(ItmName,0,1)="S")
	              {
			         if $D(tmval(ItmRelName(ItmName))) s txt=tmval(ItmRelName(ItmName))
		             
	                b  //ooo
		          } 
		          d datastream.Write(" text='"_txt_"'")
	             }
	             if Reader.MoveToAttributeName("DateTimeVal")
	             {
		             //if ($E(ItmName,0,1)="D")
                     if $D(tmval(ItmRelName(ItmName))) d datastream.Write(" DateTimeVal='"_$P(tmval(ItmRelName(ItmName)),"|",1)_"'")
		             e  d datastream.Write(" DateTimeVal=''")
				 }
			    if Reader.MoveToAttributeName("left")
			    {
	                d datastream.Write(" left='"_Reader.Value_"'")
	            }
			    if Reader.MoveToAttributeName("top")
			    {
	                d datastream.Write(" top='"_Reader.Value_"'")
	            }
			    if Reader.MoveToAttributeName("hidden")
			    {
	                d datastream.Write(" hidden='"_Reader.Value_"'")
	            }

			    if Reader.MoveToAttributeName("ofx")
			     {
	                d datastream.Write(" ofx='"_Reader.Value_"'")
	             }

			    if Reader.MoveToAttributeName("ofy")
			    {
	                d datastream.Write(" ofy='"_Reader.Value_"'")
	            }

			    if Reader.MoveToAttributeName("width")
			    {
	                d datastream.Write(" width='"_Reader.Value_"'")
	            }

			    if Reader.MoveToAttributeName("height")
			    {
	                d datastream.Write(" height='"_Reader.Value_"'")
	             }

			    if Reader.MoveToAttributeName("tabindex")
			    {
	                d datastream.Write(" tabindex='"_Reader.Value_"'")
	            }

			    if Reader.MoveToAttributeName("bgcolor")
			    {
	                d datastream.Write(" bgcolor='"_Reader.Value_"'")
	            }

			    if Reader.MoveToAttributeName("fontcolor")
			    {
	                d datastream.Write(" fontcolor='"_Reader.Value_"'")
	            }

				if Reader.MoveToAttributeName("fontname")
				{
	                d datastream.Write(" fontname='"_Reader.Value_"'")
	            }

				if Reader.MoveToAttributeName("fontsize")
				{
	                d datastream.Write(" fontsize='"_Reader.Value_"'")
	            }

				if Reader.MoveToAttributeName("b")
				{
	                d datastream.Write(" b='"_Reader.Value_"'")
	             }

				if Reader.MoveToAttributeName("i")
				{
	                d datastream.Write(" i='"_Reader.Value_"'")
	            }

				if Reader.MoveToAttributeName("u")
				{
	                d datastream.Write(" u='"_Reader.Value_"'")
	            }

				if Reader.MoveToAttributeName("fontunit") 
				 {
	                d datastream.Write(" fontunit='"_Reader.Value_"'")
	             }

				if Reader.MoveToAttributeName("selecttext")
				 {
	               // if d datastream.Write(" selecttext='"_Reader.Value_"'")
	                if $E(ItmName,0,1)="O"
	                {
		             if $D(tmval(ItmRelName(ItmName))) d datastream.Write(" selecttext='"_tmval(ItmRelName(ItmName))_"'")
		             e  d datastream.Write(" selecttext=''")
		             b ///ee
		            } 
	             }
				if Reader.MoveToAttributeName("selectItm")
				{
	                //d datastream.Write(" selectItm='"_Reader.Value_"'")
	                if $E(ItmName,0,1)="M"
	                {
		             if $D(tmval(ItmRelName(ItmName))) d datastream.Write(" selectItm='"_tmval(ItmRelName(ItmName))_"'")
		             e  d datastream.Write(" selectItm=''")
		             b  //888
		            } 

	             }
				if Reader.MoveToAttributeName("SelectItm")
				{
	                //d datastream.Write(" selectItm='"_Reader.Value_"'")
	                //s ^TM("dddd")=""

	                if $E(ItmName,0,1)="I"
	                {
		              //  s ^TM(ItmName)=tmval(ItmRelName(ItmName))
		             if $D(tmval(ItmRelName(ItmName))) d datastream.Write(" SelectItm='"_tmval(ItmRelName(ItmName))_"'")
		             e  d datastream.Write(" SelectItm=''")
		             b  //888
		            } 

	             }

				if Reader.MoveToAttributeName("DateFlag")
				 {
	                d datastream.Write(" DateFlag='"_Reader.Value_"'")
	             }

				if Reader.MoveToAttributeName("TimeFlag")
				{
	                d datastream.Write(" TimeFlag='"_Reader.Value_"'")
	            }
              if (Reader.NodeType'="chars")&(Reader.NodeType'="endelement")
              {
	               d datastream.Write(">")
	               if ($E(ItmName,0,1)="G")&($D(ItmRelName(ItmName)))
	               {
		              if $D(tmval(ItmRelName(ItmName))) d datastream.Write("<FreeText>"_tmval(ItmRelName(ItmName))_"</FreeText>")
		           }

              }
	}
	//	d datastream.Write(xml) //parent,code,rowid,title,DissolveStream
    s a=##class(NurEmr.DHCMgEmrDataChild).save(parentid,code,rowid,title,datastream)
    s ParentId=##Class(NurEmr.NurEmrDataSch).GetParentId(code,a)
    d ##Class(NurEmr.NurEmrDataSchItm).SaveSch(ParentId,parr)

    q a
	//S stream=##class(%FileCharacterStream).%New()
	//S stream.Filename=AFileName
	//d stream.TranslateTableSet("UTF8")
	//d stream.WriteLine("<?xml version=""1.0"" encoding=""UTF-8""?>")
	//d stream.Write(xml)
	//d stream.SaveStream()
	//D stream.%Close()
	//S sc = ##class(%XML.TextReader).ParseFile(AFileName,.Reader)
}

}
