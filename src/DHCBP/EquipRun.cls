Import SQLUser

/// 曲线数据处理
Class DHCBP.EquipRun Extends web.DHCClinicCom
{

// w ##class(DHCBP.EquipRun).ToJson(Array)

// d ##class(DHCBP.EquipRun).Get(89)

ClassMethod Get(arrangeId)
{
	s id=""
	For{
		s id=$O(^DHCBPC("EquipRunParaCat",id))
		q:id=""
		s obj=##class(User.DHCBPCEquipRunParaCat).%OpenId(id)
		s Array(id,"Code")=obj.BPCERPCCode
		s Array(id,"Desc")=obj.BPCERPCDesc
		d ..InitEquipRunPara(.Array,id,arrangeId)
	}
	
   s res=..ToJson(.Array)
   w res.Read()
   q res.Read()
}

// w ##class(DHCBP.EquipRun).InitArrangeEquipRunPara(89,13,2)

ClassMethod InitArrangeEquipRunPara(arrangeId, catId, BPCERPId)
{
	s id=0
	s data=""
	For{
		s id=$O(^DHCBPArrange(arrangeId,"ERP",id))
		q:id=""
		s obj=##class(User.DHCBPArrangeEquipRunPara).%OpenId(arrangeId_"||"_id)
		if (obj.BPAERPBPCERPDr'="")
		{
			if ((obj.BPAERPIfAbandon'="Y")&&(obj.BPAERPBPCERPDr.%Id()=BPCERPId))
			{
				if (obj.BPAERPBPCERPDr.BPCERPBPCERPCDr.%Id()=catId)
				{
					s data=obj
					q 
				}
			}
		
		}
		
	}
	q data
}

ClassMethod InitSchemeEquipRunPara(arrangeId, catId, BPCERPId)
{
	s arrange=##class(User.DHCBPArrange).%OpenId(arrangeId)
	s schemeId=arrange.BPABPSchemeDr.%Id()
	q:schemeId="" ""  // 数据异常
	s id=0
	s data=""
	For{
	   s id=$O(^DHCBPScheme(schemeId,"ERP",id))
	   q:id=""
	   s obj=##class(User.DHCBPSchemeEquipRunPara).%OpenId(schemeId_"||"_id)
	   
	   if (obj.BPSERPBPCERPDr'="")
		{
			if ((obj.BPSERPIfAbandon'="Y")&&(obj.BPSERPBPCERPDr.%Id()=BPCERPId))
			{
				if (obj.BPSERPBPCERPDr.BPCERPBPCERPCDr.%Id()=catId)
				{
					s data=obj
					q 
				}
			}
		
		}
	}
	q data
}

ClassMethod InitEquipRunPara(Array, catId, arrangeId)
{
	s id=0
	For{
      s id=$O(^DHCBPC("EquipRunPara",id))
      q:id=""
      s obj=##class(User.DHCBPCEquipRunPara).%OpenId(id)
      if (obj.BPCERPBPCERPCDr.%Id()=catId){
	      s Array(catId,"Option",id,"Id")=id
      	  s Array(catId,"Option",id,"CatId")=obj.BPCERPBPCERPCDr.%Id()
          s Array(catId,"Option",id,"Code")=obj.BPCERPCode
          s Array(catId,"Option",id,"Desc")=obj.BPCERPDesc 
          s Array(catId,"Option",id,"Max")=obj.BPCERPMax
          s Array(catId,"Option",id,"Min")=obj.BPCERPMin
          s Array(catId,"Option",id,"Image")=obj.BPCERPImage
          s Array(catId,"Option",id,"Value")=obj.BPCERPValue
          s Array(catId,"Option",id,"Increment")=obj.BPCERPIncrement
          s Array(catId,"Option",id,"ShowRange")=obj.BPCERPShowRange
          s Array(catId,"Option",id,"ShowValue")=obj.BPCERPShowValue
          s Array(catId,"Option",id,"ShowImage")=obj.BPCERPShowImage
          d obj.%Close()
          // 本次透析有数据，则从本次透析取，否则从方案中获取
          if $g(^DHCBPArrange(arrangeId,"ERP"))>0 {
	         s data=..InitArrangeEquipRunPara(arrangeId,catId,id)
	         
	         if (data){
		          s Array(catId,"Option",id,"Max")=data.BPAERPMaxValue
		          s Array(catId,"Option",id,"Min")=data.BPAERPMinValue
		          s Array(catId,"Option",id,"Value")=data.BPAERPValue
		          s Array(catId,"Option",id,"Select")=data.BPAERPBPCERPDr.%Id()
		          
		          //s Array(catId,"Option",id,"Value")=data.BPAERPValue
	          }
          }
          else {
	          s data=..InitSchemeEquipRunPara(arrangeId,catId,id)
	          if (data){
		          s Array(catId,"Option",id,"Max")=data.BPSERPMaxValue
		          s Array(catId,"Option",id,"Min")=data.BPSERPMinValue
		          s Array(catId,"Option",id,"Value")=data.BPSERPValue
		          s Array(catId,"Option",id,"Select")=data.BPSERPBPCERPDr.%Id()
	          }
          }
      }
   }
}

// 保存曲线相关信息

// w ##class(DHCBP.EquipRun).Save("{""arrangeId"":""89"",""equipRunPara"":[{""Parref"":""89"",""Note"":""2"",""BPCERPDr"":""10""},{""Parref"":""89"",""Note"":""3"",""BPCERPDr"":""9""}]}")

// w ##class(DHCBP.EquipRun).Save("{""arrangeId"":5,""equipRunPara"":[{""Parref"":5,""Note"":""1"",""BPCERPDr"":""1""},{""Parref"":5,""Note"":"""",""BPCERPDr"":""""},{""Parref"":5,""Note"":""3"",""BPCERPDr"":""""},{""Parref"":5,""Note"":"""",""BPCERPDr"":""""}]}")

ClassMethod Save(param)
{
	
	//s array={}.%FromJSON(param) //cache2016的解析
	s array=##class(Nur.JSON).Decode(param) //cache2010的解析
	q:array.GetAt("arrangeId")="" "ArrangeId is null"
	q:array.GetAt("equipRunPara").Size=0 1
	d ..DeleteOldData(array.GetAt("arrangeId"))
	
	s equipRunParas=array.GetAt("equipRunPara")
	s count=equipRunParas.Count()
	For i=1:1:count  {
		s equipRunPara=equipRunParas.GetAt(i)
		s rowId=..AddDynamicData("User.DHCBPArrangeEquipRunPara",##class(Nur.JSON).Encode(equipRunPara),"BPAERP")
	}
	
	/*cache2016
	set iter = array.equipRunPara.%GetIterator()
	   while iter.%GetNext(.key , .value ) {
	      s rowId=..AddDynamicData("User.DHCBPArrangeEquipRunPara",value.%ToJSON(),"BPAERP")
	}*/
	
	//q rowId
	q 1
}

ClassMethod UpdateDynamicData(className, paramStr, prefix)
{
	//s d={}.%FromJSON(paramStr)
	s d=##class(Nur.JSON).Decode(paramStr)
	set iter = d.%GetIterator()
	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(className)
	Set count = cdef.Properties.Count()
	Set rowId=d.%Get("rowId")
    q:rowId="" "rowId is Null"
	s excuteStr="arrange=##class("_className_").%OpenId("""_rowId_""")"
	XECUTE (excuteStr,.arrange)
	while iter.%GetNext(.key,.value) {
		  s name=prefix_key
		  For i = 1:1:count {
		     Set propertyName=cdef.Properties.GetAt(i).Name
		     if (propertyName=name){
			     Set $PROPERTY(arrange,propertyName)=value
			 }
		  }
	}
    d arrange.%Save()
}

ClassMethod AddDynamicData(className, paramStr, prefix)
{
	s d={}.%FromJSON(paramStr)
	//s d=##class(Nur.JSON).Decode(paramStr)
	set iter = d.%GetIterator()
	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(className)
	
	Set count = cdef.Properties.Count()
	
	s excuteStr="(obj)s obj=##class("_className_").%New()"
	XECUTE (excuteStr,.obj)
	//b ;1
	while iter.%GetNext(.key,.value) {
		  s name=prefix_key
		  For i = 1:1:count {
		     Set propertyName=cdef.Properties.GetAt(i).Name
		     if (propertyName=name){
			     Set type=cdef.Properties.GetAt(i).Type
			     if (type["User."){
				     s excuteStr="(objValue)s objValue=##class("_type_").%OpenId("""_value_""")"
		             XECUTE (excuteStr,.objValue)
				     s value=objValue
			     }
			     
			     Set $PROPERTY(obj,propertyName)=value
			 }
		  }
	}
	s res=obj.%Save()
	s rowId=obj.%Id()
	d obj.%Close()
	if (res'=1){
	   w $SYSTEM.Status.DisplayError(res)
	}
	//b //
    q rowId
}

ClassMethod DeleteOldData(arrangeId)
{
    &sql(update  DHC_BP_ArrangeEquipRunPara set BPAERP_IfAbandon='Y'
    where BPAERP_Parref->BPA_RowId=:arrangeId)
    q 0
}

}
