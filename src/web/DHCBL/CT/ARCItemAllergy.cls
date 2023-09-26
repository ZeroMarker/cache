/// Function:过敏原维护
Class web.DHCBL.CT.ARCItemAllergy Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function: 查询医嘱项关联过敏原  
/// Creator: sunfengchao
/// CreateDate: 2014-10-18
/// Table: ARC_ItemAllergy 
/// Input: ParRef 
/// Output: ALG_ParRef ALG_RowId ALG_Childsub ALG_DrugMast_DR ALG_Generic_DR ALG_Allergy_DR
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCItemAllergy","GetList","")
Query GetList(ParRef As %String) As %Query(ROWSPEC = "ALGRowId:%String,AllergyDesc:%String,MRCATTag:%String,ShowRowId:%String,Table:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, ParRef As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1

 s parref=$p(ParRef,"||",1)
 s version=$p(ParRef,"||",2)
 s rowid=0  ; childsub 孩子数
 f  s rowid=$o(^ARCIM(parref,version,"ALG",rowid)) q:rowid=""  d
 .s ALGRowId=parref_"||"_version_"||"_rowid
 .s ALGDrugMastDR=$p($g(^ARCIM(parref,version,"ALG",rowid)),"^",1)
 .s ALGGenericDR =$p($g(^ARCIM(parref,version,"ALG",rowid)),"^",2)
 .s ALGAllergyDR=$p($g(^ARCIM(parref,version,"ALG",rowid)),"^",3)
 .s Table=""
 .s:ALGDrugMastDR'="" ShowRowId=ALGDrugMastDR,Table="PHCDrgMast"
 .s:ALGGenericDR'="" ShowRowId=ALGGenericDR,Table="PHCGeneric"
 .s:ALGAllergyDR'="" ShowRowId=ALGAllergyDR,Table="PACAllergy"
 
 .s:ALGDrugMastDR'="" AllergyDesc=$p($g(^PHCD(ALGDrugMastDR,1)),"^",2) ,MRCATTag="P"
 .s:ALGGenericDR'="" AllergyDesc=$p($g(^PHCGE("GE",ALGGenericDR)),"^",2) ,MRCATTag="G"
 .s:ALGAllergyDR'="" AllergyDesc=$p($g(^PAC("ALG",ALGAllergyDR)),"^",2) ,MRCATTag="I" 
 .d OutputRow
 
 
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(ALGRowId,AllergyDesc,MRCATTag,ShowRowId,Table)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Function:根据 tag 去查询不同的程序，实现级联功能
/// Creator:sunfengchao
/// CreateDate: 2014-10-18
/// Desc: 分为 tag 存在和 tag 不存在的情况，根据情况的不同，查询出不同的数据结构
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCItemAllergy","GetComboList","2","")
/// Others:  Tag 是为了在修改时重新加载combox的store才使用的入参，这个参数是从前台传过来
Query GetComboList(MRCATRowId, desc, Tag As %String, rowid As %String) As %Query(ROWSPEC = "RowId:%String,AllergyDesc:%String")
{
}

ClassMethod GetComboListExecute(ByRef qHandle As %Binary, MRCATRowId, desc, Tag As %String, rowid As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1
   
   
   
   //1
   ///*
   if (MRCATRowId="")
   {    
     if (Tag="")
     {
        ; 查询出所有的过敏原
        if (rowid'="")
	     {
		     s RowId=rowid
		     s AllergyDesc=$p($g(^PAC("ALG",rowid)),"^",2)
		      d OutputRowCombo
	     }
	     else
	     {
		     s RowId=0
       		 for
       		 { 
            	s RowId=$o(^PAC("ALG",RowId)) q:RowId=""   
            	s AllergyDesc=$p($g(^PAC("ALG",RowId)),"^",2)
            	if (AllergyDesc[desc)
            	{
              	d OutputRowCombo
           	 }
        	}
	     }
     }
     elseif (Tag="P")
     {
	     
	     if (rowid'="")
	     { 
	     	s RowId=rowid
		     s AllergyDesc=$p($g(^PHCD(rowid,1)),"^",2)
		      d OutputRowCombo
	     }
	     else
	     {
		     
            s RowId=0
            for
            { 
              s RowId=$o(^PHCD(RowId)) q:RowId=""   
              s AllergyDesc=$p($g(^PHCD(RowId,1)),"^",2)
              if (AllergyDesc[desc)
              {
                d OutputRowCombo
              }
            }
	     }
     }
     elseif(Tag="G")
     {  /// 显示药品通用名 Generic
     	 if (rowid'="")
	     {
		      s RowId=rowid
		     s AllergyDesc=$p($g(^PHCGE("GE",rowid)),"^",2)
		      d OutputRowCombo
	     }
	     else
	     {
            s RowId=0
            for
            {
              s RowId=$o(^PHCGE("GE",RowId)) q:RowId=""
              s AllergyDesc=$p($g(^PHCGE("GE",RowId)),"^",2)
              if (AllergyDesc[desc)
              {
                d OutputRowCombo
              }
            }
	     }
     }
     elseif(Tag="I")
     { 
              //// 显示所有过敏原
          if (rowid'="")
	     {
		     s RowId=rowid
		      s AllergyDesc=$p($g(^PAC("ALG",rowid)),"^",2)
		       d OutputRowCombo
	     }
	     else
	     {
              s RowId=0
              for
              { 
                s RowId=$o(^PAC("ALG",RowId)) q:RowId=""   
                s AllergyDesc=$p($g(^PAC("ALG",RowId)),"^",2)
                if (AllergyDesc[desc)
                {
                 d OutputRowCombo
                }
              } 
	     }
     }
   }
     else   //MRCATRowId'=""   
     {
         ; 取过敏原分类的标签项
          s tag=$p($g(^MRC("AT",MRCATRowId)),"^",6)
          if (tag="P")
          {
	         if (rowid'="")
	    	 {
		      	  s RowId=rowid
		     		s AllergyDesc=$p($g(^PHCD(rowid,1)),"^",2)
		      	  d OutputRowCombo
	     	}
	     	else
	     	{
               s RowId=0
               for
               { 
                 s RowId=$o(^PHCD(RowId)) q:RowId=""   
                 s AllergyDesc=$p($g(^PHCD(RowId,1)),"^",2)
                 if (AllergyDesc[desc)
                 {
                    d OutputRowCombo
                 }
               }
	    	 }
          }
          elseif(tag="G")
          {
	         if (rowid'="")
	    	 {
		      	  s RowId=rowid
		     		s AllergyDesc=$p($g(^PHCGE("GE",rowid)),"^",2)
		      	  d OutputRowCombo
	     	}
	     	else
	     	{
               s RowId=0
               for
               {
                 s RowId=$o(^PHCGE("GE",RowId)) q:RowId=""
                 s AllergyDesc=$p($g(^PHCGE("GE",RowId)),"^",2)
                 if (AllergyDesc[desc)
                 {
                   d OutputRowCombo
                 }
               }
	     	}
          }
          elseif(tag="I")
          {
	          if (rowid'="")
	    	 {
		      	 s RowId=rowid
		     		s AllergyDesc=$p($g(^PAC("ALG",rowid)),"^",2)
		      	 d OutputRowCombo
	     	}
	     	else
	     	{
              s RowId=0
              for
              { 
                 s RowId=$o(^PAC("ALG",RowId)) q:RowId=""   
                 s AllergyDesc=$p($g(^PAC("ALG",RowId)),"^",2)
                 s ALGTypeDR=$p($g(^PAC("ALG",RowId)),"^",3)
                 ; 取出 过敏原 引用的过敏原分类id  
                 if ((ALGTypeDR'="")&(ALGTypeDR=MRCATRowId)&(ALGTypeDR[desc))
                 {
                   d OutputRowCombo
                 }
               } 
	     	}
          }
          else
          {
	          if (rowid'="")
	    	 {
		      	 s RowId=rowid
		     	s AllergyDesc=$p($g(^PAC("ALG",rowid)),"^",2)
		      	 d OutputRowCombo
	     	}
	     	else
	     	{
              s RowId=0
              for
              { 
                 s RowId=$o(^PAC("ALG",RowId)) q:RowId=""   
                 s AllergyDesc=$p($g(^PAC("ALG",RowId)),"^",2)
                 s ALGTypeDR=$p($g(^PAC("ALG",RowId)),"^",3)
                 ; 取出 过敏原 引用的过敏原分类id  
                 if ((ALGTypeDR'="")&(ALGTypeDR=MRCATRowId)&(ALGTypeDR[desc))
                 {
                   d OutputRowCombo
                 } 
              }
	     	}
          }    
     } 
   //*/
   //2
   /*
    if (rowid'="")
	{
	 s RowId=rowid
	 s AllergyDesc=$p($g(^PAC("ALG",rowid)),"^",2)
	 d OutputRowCombo
	}
	else
	{
	   if (MRCATRowId="")
	   {     
	        ; 查询出所有的过敏原
	        s RowId=0
	        for
	        { 
	            s RowId=$o(^PAC("ALG",RowId)) q:RowId=""   
	            s AllergyDesc=$p($g(^PAC("ALG",RowId)),"^",2)
	            if (AllergyDesc[desc)
	            {
	              d OutputRowCombo
	            }
	       }
	   }
	   else
	   {
	           s RowId=0
	           for
	           { 
	             s RowId=$o(^PAC("ALG",RowId)) q:RowId=""   
	             s AllergyDesc=$p($g(^PAC("ALG",RowId)),"^",2)
	             s ALGTypeDR=$p($g(^PAC("ALG",RowId)),"^",3)
	             ; 取出 过敏原 引用的过敏原分类id  
	             if ((ALGTypeDR'="")&(ALGTypeDR=MRCATRowId)&(AllergyDesc[desc))
	             {
	               d OutputRowCombo
	             } 
	           }
	   }
   
	 }
   */
   Set qHandle=$lb(0,repid,0)
  Quit $$$OK
OutputRowCombo
    set Data=$lb(RowId,AllergyDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetComboListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetComboListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetComboListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetComboListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// / Function: 宝安医院需求：新的医嘱项关联过敏原时combox取过敏原数据
///  CreateDate: 2015-7-10
///  Creator:  sunfengchao
Query GetComboListForBA(MRCATRowId As %String = "", desc As %String = "", rowid) As %Query(ROWSPEC = "RowId:%String,AllergyDesc:%String")
{
}

ClassMethod GetComboListForBAExecute(ByRef qHandle As %Binary, MRCATRowId As %String = "", desc As %String = "", rowid) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1
    
     if (rowid'="")
	{
	 s RowId=rowid
	 s AllergyDesc=$p($g(^PAC("ALG",rowid)),"^",2)
	 d OutputRowBA
	}
	else
	{
   if (MRCATRowId="")
   {     
        ; 查询出所有的过敏原
        s RowId=0
        for
        { 
            s RowId=$o(^PAC("ALG",RowId)) q:RowId=""   
            s AllergyDesc=$p($g(^PAC("ALG",RowId)),"^",2)
            if (AllergyDesc[desc)
            {
              d OutputRowBA
            }
       }
   }
   else
   {
           s RowId=0
           for
           { 
             s RowId=$o(^PAC("ALG",RowId)) q:RowId=""   
             s AllergyDesc=$p($g(^PAC("ALG",RowId)),"^",2)
             s ALGTypeDR=$p($g(^PAC("ALG",RowId)),"^",3)
             ; 取出 过敏原 引用的过敏原分类id  
             if ((ALGTypeDR'="")&(ALGTypeDR=MRCATRowId)&(AllergyDesc[desc))
             {
               d OutputRowBA
             } 
           }
   }
	}
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
OutputRowBA
    set Data=$lb(RowId,AllergyDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetComboListForBAClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetComboListForBAExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetComboListForBAFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetComboListForBAExecute ]
{
  Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Function: 删除医嘱项对应的过敏原子表数据
/// CreateDate:2014-10-17
/// Creator: sunfengchao
/// Table:  ARC_ItemAllergy
/// Debug:  d ##class(web.DHCBL.CT.ARCItemAllergy).DeleteData("")
ClassMethod DeleteData(rowid As %String) As %String
{
	n (rowid,%session)
	Quit:rowid="" "{success:'false',info:'未选择医嘱项过敏原,不能删除!'}"

	//用于保存日志
	s obj = ##class(User.ARCItemAllergy).%OpenId(rowid)
	s eobj = ##class(web.Entity.CT.ARCItemAllergy).%New()
	s eobj.ALGRowId=rowid
	s eobj.ALGParRef=$p(rowid,"||",1)_"||"_$p(rowid,"||",2)
	s:obj.ALGAllergyDR'="" eobj.Allergy=obj.ALGAllergyDR.%Id()  /// 过敏原
	s:obj.ALGDrugMastDR'="" eobj.Allergy=obj.ALGDrugMastDR.%Id() /// 药物
	s:obj.ALGGenericDR'="" eobj.Allergy=obj.ALGGenericDR.%Id()  /// 自定义

	Tstart
	s sc=##class(User.ARCItemAllergy).%DeleteId(rowid)
	If (sc=0)
	{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱项过敏原关联","web.DHCBL.CT.ARCItemAllergy","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
		Quit "{success:'false',info:'医嘱项过敏原删除失败, 请重新操作!'}"
	}
	Tc
	//删除时，日志   
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItemAllergy","User.ARCItemAllergy","医嘱项过敏原关联",rowid,eobj.Allergy,"D",eobj)
	d eobj.%Close()
	Quit "{success:'true',info:'医嘱项过敏原,删除成功!'}"
}

/// Creator:sunfengchao
/// CreatDate: 2015-4-16
/// Description：数据重复校验
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
/// Dubug: w ##class(web.DHCBL.CT.ARCItemAllergy).FormValidate("4||1||2","4||4","G","10")
ClassMethod FormValidate(id As %String, ALGParRef As %String, Tag As %String, Allergy As %String) As %String
{
	n (id,ALGParRef,Allergy,Tag)
 s flag=0,rowid=""

 if (id="") //如果为空，添加时的重复判断
 {
   s parref=$p(ALGParRef,"||",1)
   s version=$p(ALGParRef,"||",2)
   s rowid=0  ; childsub 孩子数
   for
   {
     s rowid=$o(^ARCIM(parref,version,"ALG",rowid))
     q:rowid="" 
     s ALGDrugMastDR=$p($g(^ARCIM(parref,version,"ALG",rowid)),"^",1) ;P
     s ALGGenericDR =$p($g(^ARCIM(parref,version,"ALG",rowid)),"^",2) ;G
     s ALGAllergyDR=$p($g(^ARCIM(parref,version,"ALG",rowid)),"^",3)  ;I
     if (Tag="P")
     {
       if (ALGDrugMastDR=Allergy)
       {
         s flag=1  //返回重复标志
         q
       }
       else
       {
         s flag=0 //返回不重复标志v
       } 
    }
    elseif(Tag="G")
    {
      if (ALGGenericDR=Allergy)
       {
         s flag=1  //返回重复标志
         q
       }
       else
       {
         s flag=0 //返回不重复标志v
       } 
    }
    elseif(Tag="I")
    {
     if (ALGAllergyDR=Allergy)
       {
         s flag=1  //返回重复标志
         q
       }
       else
       {
         s flag=0 //返回不重复标志v
       } 
     }   
  }
 }
 else //如果不为空，修改时的重复判断
 {
   s parref=$p(ALGParRef,"||",1)
   s version=$p(ALGParRef,"||",2)
   s rowid=0   
   for
   {
      s rowid=$o(^ARCIM(parref,version,"ALG",rowid))
      q:rowid="" 
      s ALGRowId=parref_"||"_version_"||"_rowid
      s ALGDrugMastDR=$p($g(^ARCIM(parref,version,"ALG",rowid)),"^",1)
      s ALGGenericDR =$p($g(^ARCIM(parref,version,"ALG",rowid)),"^",2)
      s ALGAllergyDR=$p($g(^ARCIM(parref,version,"ALG",rowid)),"^",3)
      
      if (Tag="P")
      {
       if ((ALGDrugMastDR=Allergy)&(ALGRowId'=id))
       {
         s flag=1  //返回重复标志
         q
       }
       else
       {
         s flag=0 //返回不重复标志 
       } 
      }
      elseif(Tag="G")
      {
	      if ((ALGGenericDR=Allergy)&(ALGRowId'=id))
       {
         s flag=1  //返回重复标志
         
         q
        
       }
       else
       {
         s flag=0 //返回不重复标志 
        
       } 
      }
      elseif(Tag="I")
      {
      ; w ALGAllergyDR_"K"_Allergy_"K"_ALGRowId_"K"_id
      
        if ((ALGAllergyDR=Allergy)&(ALGRowId'=id))
        {
         s flag=1  //返回重复标志
         q
        }
        else
        {
         s flag=0 //返回不重复标志 
        } 
      }
   }   
 }
 q flag
}

/// Function:  新增医嘱项关联过敏原
/// CreateDate: 2014-10-17
/// Creator:   sunfengchao
/// Debug:     w ##class(web.DHCBL.CT.ARCItemAllergy).AddOrderAllergy("13468||1||8^7^^")
ClassMethod AddOrderAllergy(SaveDataStr As %String) As %String
{
	n (SaveDataStr,%session)
	Set flag=0
	Set ALGParRef=$p(SaveDataStr,"^",1)  
	Set AllergenType=$p(SaveDataStr,"^",2) ; 过敏原类型标签项
	Set Allergy=$p(SaveDataStr,"^",3)
	if (AllergenType'="")
	{
		Set Tag=..FindTagById(AllergenType)
	}
	else
	{
		Set Tag="I" 
	}
	s flag=..FormValidate("",ALGParRef,Tag,Allergy)   
	if (flag=1)
	{
		s result = "{success:'false',info:'过敏原数据重复！'}"
	}
	else
	{ 
		s eobj = ##class(web.Entity.CT.ARCItemAllergy).%New()
		s eobj.ALGParRef=ALGParRef
		s eobj.ALGRowId= ""
		s eobj.Allergy= Allergy

		Tstart
		s obj=##class(User.ARCItemAllergy).%New(ALGParRef)
		d obj.ALGParRefSetObjectId(ALGParRef)

		if (Tag="P")
		{
			d:Allergy'="" obj.ALGDrugMastDRSetObjectId(Allergy) 
			s eobj.ALGDrugMastDR= Allergy
		}
		elseif(Tag="G")
		{
			d:Allergy'="" obj.ALGGenericDRSetObjectId(Allergy)
			s eobj.ALGGenericDR= Allergy
		}
		elseif(Tag="I")
		{
			d:Allergy'="" obj.ALGAllergyDRSetObjectId(Allergy)
			s eobj.ALGAllergyDR= Allergy
		} 

		s sc=obj.%Save()
		If (sc=0)
		{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱项过敏原关联","web.DHCBL.CT.ARCItemAllergy","AddOrderAllergy",eobj)
			s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',info:'保存失败, 请重新操作!'}"
		}
		Tc
		s id=obj.%Id()
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItemAllergy","User.ARCItemAllergy","医嘱项过敏原关联",id,eobj.Allergy,"A",eobj)
		d eobj.%Close()
		s result = "{success:'true',info:'保存成功!'}"
	}

	q result
}

/// Function:  修改医嘱项过敏原
/// CreateDate: 2014-10-17
/// Creator:   sunfengchao
/// Debug:     w ##class(web.DHCBL.CT.ARCItemAllergy).UpdateOrderAllergy("1||1||1^^28^I")
ClassMethod UpdateOrderAllergy(UpdateOrderAllergyStr As %String) As %String
{

	n (%session,UpdateOrderAllergyStr)
	s ALGRowId=$p(UpdateOrderAllergyStr,"^",1)
	s AllergenType=$p(UpdateOrderAllergyStr,"^",2)
	s Allergy=$p(UpdateOrderAllergyStr,"^",3)
	s MTag=$p(UpdateOrderAllergyStr,"^",4)
	
   s Tag="",flag=0
   ; 根据 AllergenType id号来取得 传过来的tag
   if (AllergenType'="")
   {
     s Tag=..FindTagById(AllergenType)
   }
   if (Tag="") s Tag=MTag
   s parref=$p(ALGRowId,"||",1)
   s version=$p(ALGRowId,"||",2)
   s child=$p(ALGRowId,"||",3)
   s ALGParRef=parref_"||"_ version
   s flag=..FormValidate(ALGRowId,ALGParRef,Tag,Allergy)
   if (flag=1)
   {
     s result = "{success:'false',info:'过敏原数据重复！'}"
   }
   else
   { 
    s ALGDrugMastDR= $p($g(^ARCIM(parref,version,"ALG",child)),"^",1)
    s ALGGenericDR=$p($g(^ARCIM(parref,version,"ALG",child)),"^",2)
    s ALGAllergyDR=$p($g(^ARCIM(parref,version,"ALG",child)),"^",3)
    s obj=##class(User.ARCItemAllergy).%OpenId(ALGRowId) 
    ; 取出了原始数据的字段，还要根据这3个指向是否为空，进行判断进行置空，然后进行修改
    s bobj = ##class(web.Entity.CT.ARCItemAllergy).%New()
    s bobj.ALGRowId=ALGRowId
    s:ALGDrugMastDR'="" bobj.ALGDrugMastDR=ALGDrugMastDR
    s:ALGGenericDR'="" bobj.ALGGenericDR = ALGGenericDR 
    s:ALGAllergyDR'="" bobj.ALGAllergyDR= ALGAllergyDR   
   
    s eobj = ##class(web.Entity.CT.ARCItemAllergy).%New()
    s eobj.ALGRowId= ALGRowId  
    s eobj.Allergy=Allergy

    Tstart
    if (Tag="")
    {
      S:bobj.ALGDrugMastDR'="" Tag="P"
      S:bobj.ALGGenericDR'="" Tag="G"
      S:bobj.ALGAllergyDR'="" Tag="I"
    }
    d:bobj.ALGDrugMastDR'="" obj.ALGDrugMastDRSetObjectId("")
    d:bobj.ALGGenericDR'="" obj.ALGGenericDRSetObjectId("")
    d:bobj.ALGAllergyDR'="" obj.ALGAllergyDRSetObjectId("")
 
   ; 需要根据上一级 过敏原分类的tag标签项是 P I G 来进行不同的保存处理 ,存储到不同的字段中去,同时需要将原来的字段清空
    if (Tag="P")
    {
      d:Allergy'="" obj.ALGDrugMastDRSetObjectId(Allergy) 
      s eobj.ALGDrugMastDR=Allergy
    }
    elseif(Tag="G")
    {
      d:Allergy'="" obj.ALGGenericDRSetObjectId(Allergy)
      s eobj.ALGGenericDR=Allergy
     
    }
    elseif(Tag="I")
    {
     d:Allergy'="" obj.ALGAllergyDRSetObjectId(Allergy)
      s eobj.ALGAllergyDR=Allergy
    } 
    s sc=obj.%Save()
    If (sc=0)
    {
      Trollback
       s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱项过敏原关联","web.DHCBL.CT.ARCItemAllergy","UpdateOrderAllergy",eobj)
	   s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
       s result =  "{success:'false',info:'保存失败, 请重新操作!'}"
    }
    Tc
   
    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItemAllergy","User.ARCItemAllergy","医嘱项过敏原关联",ALGRowId,Allergy,"U",eobj,bobj)
    d eobj.%Close()
    s result =  "{success:'true',info:'保存成功!'}"
  }
  
  Quit result
}

/// Function: 根据过敏原分类的rowid 获取tag,用于添加/修改方法时调用
/// Creator:  sunfengchao
/// CreateDate: 2014-10-22
/// Debug:  w ##class(web.DHCBL.CT.ARCItemAllergy).FindTagById("7")
ClassMethod FindTagById(rowid As %String) As %String
{
	n (rowid)
	if rowid'=""
	{
		s tag=""
		if ($d(^MRC("AT",rowid))>0)
		{
			s tag=$p($g(^MRC("AT",rowid)),"^",6) 
			if (tag="") s tag="I"
		}
	}
	else
	{
		s tag="I"
	}
	q tag
}

/// Creator: sunfengchao
/// CreatDate: 2014-10-22
/// Function: 根据 rowid 取值去找 dr ，根据dr 去找过敏原类型的 id
/// Debug: w ##class(web.DHCBL.CT.ARCItemAllergy).FindDR("13397||1||23 ")
ClassMethod FindDR(rowid As %String) As %String
{
	n (rowid)
	s MRowId=""
	s pobj = ##class(User.ARCItemAllergy).%OpenId(rowid)
	s ALGAllergyDR=pobj.ALGAllergyDR
	s ALGDrugMastDR = pobj.ALGDrugMastDR 
	s ALGGenericDR  = pobj.ALGGenericDR 

	if (ALGAllergyDR'="")
	{
		s MRowId=ALGAllergyDR.%Id()
	}
	if (ALGDrugMastDR'="")
	{
		s MRowId=ALGDrugMastDR.%Id()
	}
	if (ALGGenericDR'="")
	{
		s MRowId=ALGGenericDR.%Id()
	}
	s result="{MRowId:"""_MRowId_"""}"
	q result
}

/// Function:批量添加医嘱项过敏原关联数据
/// Creator: 基础数据平台组 sunfengchao
/// CreateDate:2014-12-25
/// Debug: W ##class(web.DHCBL.CT.ARCItemAllergy).MultiAddAllergy("13915||1","8^2*^4*^2")
ClassMethod MultiAddAllergy(rowid As %String, AddAllergyStr As %String) As %String
{
	n (AddAllergyStr,rowid,%session)
    s result=""
    q:AddAllergyStr="" "{success:'true'}"
    s flag=""
    s Allergylength=$length(AddAllergyStr,"*")
    
    for i=1:1:Allergylength 
    {
       s AllergyStr=$P(AddAllergyStr,"*",i)
       s AllergenType=$p(AllergyStr,"^",1)                 
       s Allergy=$p(AllergyStr,"^",2)   
                
       //1
       if (AllergenType'="")
       {
         Set Tag=..FindTagById(AllergenType)
       }
       else
       {
         Set Tag="I" 
       }
       //2
       //Set Tag="I" 
     
       if (Allergy="")
       {
          s result= "{success:'false',info:'过敏原为空,请重新选择过敏原!'}"
       }
       else
       {
         s eobj = ##class(web.Entity.CT.ARCItemAllergy).%New()
    	 s eobj.ALGRowId=""
    	 s eobj.ALGParRef=rowid
   		 s eobj.Allergy=Allergy

         s obj=##class(User.ARCItemAllergy).%New(rowid)
         d obj.ALGParRefSetObjectId(rowid)
  
         if (Tag="P")
         {
           d:Allergy'="" obj.ALGDrugMastDRSetObjectId(Allergy) 
           S eobj.ALGDrugMastDR=Allergy
         }
         elseif(Tag="G")
         {
           d:Allergy'="" obj.ALGGenericDRSetObjectId(Allergy)
           S eobj.ALGGenericDR=Allergy
         }
         elseif(Tag="I")
         {
           d:Allergy'="" obj.ALGAllergyDRSetObjectId(Allergy)
           S eobj.ALGAllergyDR=Allergy
         } 
         s sc=obj.%Save()
         
         If (sc=0)
         {
	        
	        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱项过敏原关联","web.DHCBL.CT.ARCItemAllergy","MultiAddAllergy",eobj)
	   		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
            s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"!'}"
         }
         else
         {
          s result= "{success:'true',info:'添加成功!'}"
         }  
          if result["false" s flag=1
            
      }
   }
   if flag=1 s result= "{success:'false',info:'<医嘱项过敏原>添加失败, 请重新操作!'}"
   else  s result= "{success:'true'}"
   Quit result
}

}
