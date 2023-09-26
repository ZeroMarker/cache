Class web.DHCBL.CT.CTCareProvMedUnit Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2016-8-30
/// Description：医护人员所属医疗单元
/// Table：User.DHCCTLocMedUnitCareProv
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCCTLocMedUnitCareProv","GetList","","838")
Query GetList(rowid As %String, DoctorDR As %String, ParRef As %String) As %Query(ROWSPEC = "CTMUDesc,MUCPParRef,MUCPChildsub,MUCPRowId,MUCPLeaderFlag,MUCPOPFlag,MUCPIPFlag,MUCPDateFrom,MUCPDateTo")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, DoctorDR As %String, ParRef As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
        s MUCPRowId=rowid
        s CTMUCTLOCParRef=$p(MUCPRowId,"||",1)
  		s CTMUChildsub=$p(MUCPRowId,"||",2)
  		s MUCPChildsub=$p(MUCPRowId,"||",3)
        s MUCPParRef=CTMUCTLOCParRef_"||"_CTMUChildsub

        s CTMUDesc=$p($g(^CTLOC(CTMUCTLOCParRef,"MU",CTMUChildsub)),"^",2)      
        s TMUCPLeader=$p($g(^CTLOC(CTMUCTLOCParRef,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",2)
        s:TMUCPLeader="Y" MUCPLeaderFlag="是"
        s:TMUCPLeader="N" MUCPLeaderFlag="否"  
        s TMUCPOP=$p($g(^CTLOC(CTMUCTLOCParRef,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",3)
        s:TMUCPOP="Y" MUCPOPFlag="出诊"
        s:TMUCPOP="N" MUCPOPFlag="不出诊"
        s TMUCPIP=$p($g(^CTLOC(CTMUCTLOCParRef,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",4)
        s:TMUCPIP="N" MUCPIPFlag="不出诊"
        s:TMUCPIP="Y" MUCPIPFlag="出诊"
        s MUCPDateFrom=$p($g(^CTLOC(CTMUCTLOCParRef,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",5)
        s MUCPDateTo=$p($g(^CTLOC(CTMUCTLOCParRef,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",6)
        s:MUCPDateFrom'="" MUCPDateFrom=$zd(MUCPDateFrom,1) 
        s:MUCPDateTo'="" MUCPDateTo=$zd(MUCPDateTo,1)
		
		d OutputRowUnit
	}
	else
	{
     	s CTMUCTLOCParRef=0
     	for{
	     	s CTMUCTLOCParRef=$o(^CTLOC(CTMUCTLOCParRef))  q:(CTMUCTLOCParRef="")
	     	s CTMUChildsub=0
	     	for{
		     	 s CTMUChildsub=$o(^CTLOC(CTMUCTLOCParRef,"MU", CTMUChildsub)) q:(CTMUChildsub="")
		     	 s MUCPChildsub=0
		     	 for{
			     	 s MUCPChildsub=$o(^CTLOC(CTMUCTLOCParRef,"MU", CTMUChildsub,"CP", MUCPChildsub)) q:(MUCPChildsub="")
			     	 s MUCPDoctorDR=$p($g(^CTLOC(CTMUCTLOCParRef,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",1)
			     	 if (MUCPDoctorDR=DoctorDR){
    					 
    					s MUCPParRef=CTMUCTLOCParRef_"||"_CTMUChildsub
        				s MUCPRowId=CTMUCTLOCParRef_"||"_CTMUChildsub_"||"_MUCPChildsub
      
        				s CTMUDesc=$p($g(^CTLOC(CTMUCTLOCParRef,"MU",CTMUChildsub)),"^",2) 
        				s AliasRowId=0,ALIASText1=""
        				for
        				{
         					s AliasRowId=$o(^User.BDPAliasI("DataRef","DHC_CTLoc_MedUnitCareProv",MUCPRowId,AliasRowId))
         					q:AliasRowId=""
         					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
         					; 查询出对应rowid下的所有别名，用"^"进行连接
         					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
        				} 
        				s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTMUDesc)      
        				s TMUCPLeader=$p($g(^CTLOC(CTMUCTLOCParRef,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",2)
        				s:TMUCPLeader="Y" MUCPLeaderFlag="是"
        				s:TMUCPLeader="N" MUCPLeaderFlag="否"  
        				s TMUCPOP=$p($g(^CTLOC(CTMUCTLOCParRef,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",3)
        				s:TMUCPOP="Y" MUCPOPFlag="出诊"
        				s:TMUCPOP="N" MUCPOPFlag="不出诊"
        				s TMUCPIP=$p($g(^CTLOC(CTMUCTLOCParRef,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",4)
        				s:TMUCPIP="N" MUCPIPFlag="不出诊"
        				s:TMUCPIP="Y" MUCPIPFlag="出诊"
        				s MUCPDateFrom=$p($g(^CTLOC(CTMUCTLOCParRef,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",5)
        				s MUCPDateTo=$p($g(^CTLOC(CTMUCTLOCParRef,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",6)
        				s:MUCPDateFrom'="" MUCPDateFrom=$zd(MUCPDateFrom,1) 
        				s:MUCPDateTo'="" MUCPDateTo=$zd(MUCPDateTo,1)
    					 
    					if ((MUCPParRef=ParRef)||(ParRef="")){
	    					d OutputRowUnit
	 	    			}
    				}
			     }
		     }
	     }
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowUnit
    set Data=$lb(CTMUDesc,MUCPParRef,MUCPChildsub,MUCPRowId,MUCPLeaderFlag,MUCPOPFlag,MUCPIPFlag,MUCPDateFrom,MUCPDateTo)
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

/// Creator: 基础数据平台 gss
/// CreatDate: 2016-8-30
/// Description:增加/修改内容
/// Return:成功返回success:'true'和新增或修改的数据的CTCOURowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCCTLocMedUnitCareProv) As %String
{
    s result=""
    s:eobj.MUCPIPFlag="" eobj.MUCPIPFlag="N" 
    s:eobj.MUCPIPFlag="3" eobj.MUCPIPFlag="Y"
    s:eobj.MUCPLeaderFlag="1" eobj.MUCPLeaderFlag="Y" 
    s:eobj.MUCPLeaderFlag="" eobj.MUCPLeaderFlag="N"
    s:eobj.MUCPOPFlag="2" eobj.MUCPOPFlag="Y"
    s:eobj.MUCPOPFlag="" eobj.MUCPOPFlag="N"
    ;s:eobj.MUCPDateFrom'="" eobj.MUCPDateFrom = $zdh(eobj.MUCPDateFrom,15)
    ;s:eobj.MUCPDateTo'="" eobj.MUCPDateTo = $zdh(eobj.MUCPDateTo,15)
    s:eobj.MUCPDateFrom'="" eobj.MUCPDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.MUCPDateFrom)
    s:eobj.MUCPDateTo'="" eobj.MUCPDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.MUCPDateTo)
    s:eobj.MUCPDateFrom="" eobj.MUCPDateFrom=+$h
    if (eobj.MUCPRowId="")       
    {
      s obj=##class(User.DHCCTLocMedUnitCareProv).%New(eobj.MUCPParRef)
    } 
    else{
	  s obj=##class(User.DHCCTLocMedUnitCareProv).%OpenId(eobj.MUCPRowId)
      s bobj = ##class(web.Entity.CT.DHCCTLocMedUnitCareProv).%New()
      s bobj.MUCPRowId = eobj.MUCPRowId
      s bobj.MUCPDateFrom = obj.MUCPDateFrom
      s bobj.MUCPDateTo = obj.MUCPDateTo
      s bobj.MUCPIPFlag = obj.MUCPIPFlag
      s bobj.MUCPOPFlag = obj.MUCPOPFlag
      s bobj.MUCPLeaderFlag = obj.MUCPLeaderFlag
      s:obj.MUCPParRef'="" bobj.MUCPParRef = obj.MUCPParRef.%Id() 
      s:obj.MUCPDoctorDR'="" bobj.MUCPDoctorDR = obj.MUCPDoctorDR.%Id()
      s bobj.CTPCPCode=$p($g(^CTPCP(bobj.MUCPDoctorDR,1)),"^",1)
      s bobj.CTPCPDesc=$p($g(^CTPCP(bobj.MUCPDoctorDR,1)),"^",2) 
	}
      d obj.MUCPParRefSetObjectId(eobj.MUCPParRef)
      s obj.MUCPDateFrom = eobj.MUCPDateFrom
      s obj.MUCPDateTo = eobj.MUCPDateTo
      s obj.MUCPIPFlag = eobj.MUCPIPFlag
      s obj.MUCPLeaderFlag = eobj.MUCPLeaderFlag
      s obj.MUCPOPFlag = eobj.MUCPOPFlag
      d obj.MUCPDoctorDRSetObjectId(eobj.MUCPDoctorDR)
      s CTPCPDesc=$p($g(^CTPCP(eobj.MUCPDoctorDR,1)),"^",2)
      s CTMUDesc=$p($g(^CTLOC($p(eobj.MUCPParRef,"||",1),"MU",$p(eobj.MUCPParRef,"||",2))),"^",2)  
      TS
      s sc=obj.%Save()
      d obj.%Close()
      if $$$ISOK(sc)
      {
        Tcommit
        s id=obj.%Id()
        s result = "{success:'true',id:'"_id_"'}"         
        d:eobj.MUCPRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_CTLoc_MedUnitCareProv","User.DHCCTLocMedUnitCareProv","医护人员所属医疗单元",id,CTPCPDesc_"->"_CTMUDesc,"A",eobj)
      	d:eobj.MUCPRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_CTLoc_MedUnitCareProv","User.DHCCTLocMedUnitCareProv","医护人员所属医疗单元",eobj.MUCPRowId,CTPCPDesc_"->"_CTMUDesc,"U",eobj,bobj)
      }
      else
      {
        Trollback
        s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    
      }
  q result
}

/// Function:显示打开窗口
/// CreateDate:2016-8-30
/// Creator:基础数据平台公共产品组 gss
/// Others: w ##class(web.DHCBL.CT.CTCareProvMedUnit).OpenData("1||1||5")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.DHCCTLocMedUnitCareProv).%OpenId(id)
 s eobj = ##class(web.Entity.CT.DHCCTLocMedUnitCareProv).%New()
 s eobj.MUCPRowId=id
 s CTMUCTLOCParRef=$p(id,"||",1)
 s CTMUChildsub=$P(id,"||",2)

 s eobj.MUCPParRef=CTMUCTLOCParRef_"||"_CTMUChildsub
 s:pobj.MUCPDoctorDR'="" eobj.MUCPDoctorDR = pobj.MUCPDoctorDR.%Id()
 s:pobj.MUCPDoctorDR="" eobj.MUCPDoctorDR=""
 s:eobj.MUCPDoctorDR'="" eobj.CTPCPCode=$p($g(^CTPCP(eobj.MUCPDoctorDR,1)),"^",1)
 s:eobj.MUCPDoctorDR'="" eobj.CTPCPDesc=$p($g(^CTPCP(eobj.MUCPDoctorDR,1)),"^",2)  
 s eobj.MUCPIPFlag = pobj.MUCPIPFlag
 s eobj.MUCPOPFlag = pobj.MUCPOPFlag
 s eobj.MUCPLeaderFlag = pobj.MUCPLeaderFlag
 s:eobj.MUCPIPFlag="Y" eobj.MUCPIPFlag="true"
 s:(eobj.MUCPIPFlag="N"||eobj.MUCPIPFlag="") eobj.MUCPIPFlag="false"
 s:eobj.MUCPOPFlag="Y" eobj.MUCPOPFlag="true"
 s:(eobj.MUCPOPFlag="N"||eobj.MUCPOPFlag="") eobj.MUCPOPFlag="false"
 s:eobj.MUCPLeaderFlag="Y" eobj.MUCPLeaderFlag="true"
 s:(eobj.MUCPLeaderFlag="N"||eobj.MUCPLeaderFlag="") eobj.MUCPLeaderFlag="false"
 s eobj.MUCPDateFrom=pobj.MUCPDateFrom
 s eobj.MUCPDateTo=pobj.MUCPDateTo 
 ;s:eobj.MUCPDateFrom'="" eobj.MUCPDateFrom=$zd(eobj.MUCPDateFrom,1)
 ;s:eobj.MUCPDateTo'="" eobj.MUCPDateTo=$zd(eobj.MUCPDateTo,1)
 s:eobj.MUCPDateFrom'="" eobj.MUCPDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.MUCPDateFrom)
 s:eobj.MUCPDateTo'="" eobj.MUCPDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.MUCPDateTo)
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function：删除数据
/// Creator： sunfengchao
/// CreateDate:2015-12-30
/// w ##class(web.DHCBL.CT.CTCareProvMedUnit).DeleteData("63||1||1")
ClassMethod DeleteData(id) As %String
{
  s CTLocDr=$p(id,"||",1)
  s MUCTChildSub=$p(id,"||",2)
  s MUCTPCPChildSub=$p(id,"||",3)
  s DateFrom=$p($g(^CTLOC(CTLocDr,"MU",MUCTChildSub,"CP",MUCTPCPChildSub)),"^",5)
  s result=""
  s Now=$p($h,",",1)
  s obj=##class(User.DHCCTLocMedUnitCareProv).%OpenId(id)
  s eobj=##class(web.Entity.CT.DHCCTLocMedUnitCareProv).%New()
  s eobj.MUCPDateFrom=obj.MUCPDateFrom
  s eobj.MUCPDateTo=obj.MUCPDateTo
  s eobj.MUCPIPFlag=obj.MUCPIPFlag
  s eobj.MUCPOPFlag=obj.MUCPOPFlag
  s eobj.MUCPLeaderFlag=obj.MUCPLeaderFlag  
  if (obj.MUCPParRef'="")
  { 
   s eobj.MUCPParRef=obj.MUCPParRef.%Id()
  }
  else 
  {    
    s eobj.MUCPParRef=""
  }
  if (obj.MUCPDoctorDR'="")
  { 
   s eobj.MUCPDoctorDR=obj.MUCPDoctorDR.%Id()
  }
  else 
  {    
    s eobj.MUCPDoctorDR=""
  }
  ; 如果开始日期小于当前日期：结束日期置为当前日期
  
  if (Now>DateFrom) 
  {
    TS
    s obj.MUCPDateTo=Now
    s result=obj.%Save()
    if (result=1)
    {
      TC
      s result="{success:'false',info:'开始日期小于当前日期,数据不能删除,结束日期设置为当前日期！'}"
    }
    else
    {
      Trollback
      s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
    }
  }
  else
  {  
  ; 开始日期大于当前日期，将数据删除
    TS
    s flag=obj.%DeleteId(id)
    IF $$$ISOK(flag)
    {
      Tc
      s result="{success:'true',info:'删除成功！'}"
      d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_CTLoc_MedUnitCareProv","User.DHCCTLocMedUnitCareProv","医护人员所属医疗单元",id,eobj.MUCPParRef,"D",eobj)
      d eobj.%Close()
    }
    else
    {
     Trollback
     s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
    }
  
  }
   q result
}

}
