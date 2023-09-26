/// Function: 医嘱项 年龄/性别限制
/// CreateDate: 2014/11/4
/// Creator:  sunfengchao　　　
Class web.DHCBL.CT.ARCItemAgeSexRestriction Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function:   查询医嘱项年龄/性别限制
/// Table:      ARC_ItemAgeSexRestriction
/// CreateDate: 2014/11/4
/// Input:      ParRef
/// Output:     AGEParRef AGERowId AGEChildsub AGESexDR AGEAgeFrom AGEAgeTo　
/// Others:     d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCItemAgeSexRestriction","GetList","")
Query GetList(ParRef As %String) As %Query(ROWSPEC = "AGERowId:%String,AGEParRef:%String,AGESexDR:%String,AGEAgeFrom:%String,AGEAgeTo:%String,AGESexDR2:%String,AGEAgeFromType,AGEAgeToType")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, ParRef As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 s parref=$p(ParRef,"||",1)
 s version=$p(ParRef,"||",2)
 s rowid=0
 f  s rowid=$o(^ARCIM(parref,version,"AGE",rowid)) q:rowid=""  d
 .s AGERowId=parref_"||"_version_"||"_rowid
 .s AGEParRef=ParRef
 .s AGESexDR=$p($g(^ARCIM(parref,version,"AGE",rowid)),"^",1)
 .s AGESexDR2=AGESexDR
 .S:AGESexDR'="" AGESexDR=$p($g(^CT("SEX",AGESexDR)),"^",2)
 .s AGEAgeFrom=$p($g(^ARCIM(parref,version,"AGE",rowid)),"^",2)
 .s AGEAgeTo=$p($g(^ARCIM(parref,version,"AGE",rowid)),"^",3)
 
 .s AGEAgeFromType=$p($g(^ARCIM(parref,version,"AGE",rowid)),"^",4)
 .s AGEAgeFromType=$case(AGEAgeFromType,"Y":"岁","M":"月","D":"日",:"")
 .s:((AGEAgeFrom'="")&&(AGEAgeFromType="")) AGEAgeFromType="岁"
 .s AGEAgeToType=$p($g(^ARCIM(parref,version,"AGE",rowid)),"^",5)
 .s AGEAgeToType=$case(AGEAgeToType,"Y":"岁","M":"月","D":"日",:"")
 .s:((AGEAgeTo'="")&&(AGEAgeToType="")) AGEAgeToType="岁"
 .d OutputRow
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(AGERowId,AGEParRef,AGESexDR,AGEAgeFrom,AGEAgeTo,AGESexDR2,AGEAgeFromType,AGEAgeToType)
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

/// Function:   删除医嘱项年龄/性别限制 的数据
/// CreateDate: 2014-11-4
/// Creator:    sunfengchao
/// Table:      ARC_ItemAgeSexRestriction
/// Debug:      w ##class(web.DHCBL.CT.ARCItemAgeSexRestriction).DeleteData("")
ClassMethod DeleteData(rowid As %String) As %String
{
    n (rowid,%session)
    Quit:rowid="" "{success:'false',info:'未选择<医嘱项年龄/性别限制>数据,不能删除!'}"

    //用于保存日志
    s obj = ##class(User.ARCItemAgeSexRestriction).%OpenId(rowid)
    s eobj = ##class(web.Entity.CT.ARCItemAgeSexRestriction).%New()
    s eobj.AGERowId=rowid
    s eobj.AGEAgeFrom=obj.AGEAgeFrom
    s eobj.AGEAgeTo=obj.AGEAgeTo
    s:obj.AGESexDR eobj.AGESexDR=obj.AGESexDR.%Id()
	s eobj.AGEAgeFromType=obj.AGEAgeFromType 	//从年龄类型 （岁/月/日）
	s eobj.AGEAgeToType=obj.AGEAgeToType 	//到年龄类型 （岁/月/日）
    d obj.%Close()
    Tstart
    s sc= ##class(User.ARCItemAgeSexRestriction).%DeleteId(rowid) 
    If (sc=0)
    {
        Trollback
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱项年龄/性别限制","web.DHCBL.CT.ARCItemAgeSexRestriction","DeleteData",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        Quit "{success:'false',info:'删除失败, 请重新操作!'}"
    }
    Tc
    //删除时，日志
    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItemAgeSexRestriction","User.ARCItemAgeSexRestriction","医嘱项年龄/性别限制",rowid,eobj.AGESexDR,"D",eobj)

    d eobj.%Close()
    Quit "{success:'true',info:'删除成功!'}"
}

/// Creator:sunfengchao
/// CreatDate: 2015-4-15
/// Description：数据重复校验
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
/// Dubug: w ##class(web.DHCBL.CT.ARCItemAgeSexRestriction).FormValidate("","","","","")
ClassMethod FormValidate(ParRef As %String, id As %String, sexdr As %String, agefrom As %String, ageto As %String, agefromtype As %String, agetotype As %String) As %String
{
	n (agefrom,ageto,id,ParRef,sexdr,agefromtype,agetotype)
 s flag="",flagc="",flagd="",rowid=""
 if (id="") //如果为空，添加时的重复判断
 {
  /// 开始年龄，截止年龄 性别三者的数据与agefrom ,ageto,sexdr完全相同时才算是数据重复
   s parref=$p(ParRef,"||",1)
   s version=$p(ParRef,"||",2)
   s rowid=0
   for
   {
     s rowid=$o(^ARCIM(parref,version,"AGE",rowid)) 
     q:rowid=""  
     s AGESexDR=$p($g(^ARCIM(parref,version,"AGE",rowid)),"^",1)
     s AGEAgeFrom=$p($g(^ARCIM(parref,version,"AGE",rowid)),"^",2)
     s AGEAgeTo=$p($g(^ARCIM(parref,version,"AGE",rowid)),"^",3)
     s AGEAgeFromType=$p($g(^ARCIM(parref,version,"AGE",rowid)),"^",4)
 	 s AGEAgeToType=$p($g(^ARCIM(parref,version,"AGE",rowid)),"^",5)
     if (((AGESexDR=sexdr)&(AGEAgeFrom=agefrom)&(AGEAgeTo=ageto)&(AGEAgeFromType=agefromtype)&(AGEAgeToType=agetotype))||((AGESexDR=sexdr)&(AGEAgeFrom=agefrom)&(AGEAgeFromType=agefromtype)&(ageto="")&(AGEAgeTo'="")))||((AGESexDR=sexdr)&(AGEAgeTo=ageto)&(AGEAgeToType=agetotype)&(agefrom=""))||((AGEAgeFrom=agefrom)&(AGEAgeFromType=agefromtype)&(AGEAgeTo=ageto)&(AGEAgeToType=agetotype)&(sexdr=""))
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
 else //如果不为空，修改时的重复判断
 {
   s Mrowid="", flag=0
   s parref=$p(ParRef,"||",1)
   s version=$p(ParRef,"||",2)
   s rowid=0
   for
   {
     s rowid=$o(^ARCIM(parref,version,"AGE",rowid)) 
     q:rowid=""  
     s AGESexDR=$p($g(^ARCIM(parref,version,"AGE",rowid)),"^",1)
     s AGEAgeFrom=$p($g(^ARCIM(parref,version,"AGE",rowid)),"^",2)
     s AGEAgeTo=$p($g(^ARCIM(parref,version,"AGE",rowid)),"^",3)
     s AGEAgeFromType=$p($g(^ARCIM(parref,version,"AGE",rowid)),"^",4)
 	 s AGEAgeToType=$p($g(^ARCIM(parref,version,"AGE",rowid)),"^",5)
     s Mrowid=ParRef_"||"_rowid
     
     if (((AGESexDR=sexdr)&(AGEAgeFrom=agefrom)&(AGEAgeTo=ageto)&(AGEAgeFromType=agefromtype)&(AGEAgeToType=agetotype))||((AGESexDR=sexdr)&(AGEAgeFrom=agefrom)&(AGEAgeFromType=agefromtype)&(ageto="")))||((AGESexDR=sexdr)&(AGEAgeTo=ageto)&(AGEAgeToType=agetotype)&(agefrom=""))||((AGEAgeFrom=agefrom)&(AGEAgeTo=ageto)&(AGEAgeFromType=agefromtype)&(AGEAgeToType=agetotype)&(sexdr=""))
     {
      if (Mrowid'=id)
      {
       s flag=1  //返回重复标志
       q
      }
      else
      {
       s flag=0  //返回不重复标志
      }
     }
     else{
      continue 
     }
   }
 }
 q flag
}

/// Function:  修改<医嘱项年龄/性别限制>的数据
/// CreateDate: 2014-10-20
/// Creator:   sunfengchao
/// Table:     ARC_ItemAgeSexRestriction
/// Debug:     w ##class(web.DHCBL.CT.ARCItemAgeSexRestriction).UpdateData("3||1||1^1^34^660")
ClassMethod UpdateData(UpdateOrderAgeSexStr As %String) As %String
{
    n (UpdateOrderAgeSexStr,%session)
    s result=""
    s eobj = ##class(web.Entity.CT.ARCItemAgeSexRestriction).%New()
    s AGERowId=$p(UpdateOrderAgeSexStr,"^",1)
    s eobj.AGERowId=$p(UpdateOrderAgeSexStr,"^",1)
    s eobj.AGEParRef=$p(AGERowId,"||",1)_"||"_$p(AGERowId,"||",2)
    s eobj.AGESexDR= $p(UpdateOrderAgeSexStr,"^",2)
    s eobj.AGEAgeFrom= $p(UpdateOrderAgeSexStr,"^",3)
    s eobj.AGEAgeTo= $p(UpdateOrderAgeSexStr,"^",4)
	s eobj.AGEAgeFromType=$p(UpdateOrderAgeSexStr,"^",5) 	//从年龄类型 （岁/月/日）
	s eobj.AGEAgeToType=$p(UpdateOrderAgeSexStr,"^",6) 	//到年龄类型 （岁/月/日）
    s Result= ##class(web.DHCBL.CT.ARCItemAgeSexRestriction).SaveEntity(eobj)
    if Result["success:'true'" s Ret= "{success:'true',info:'保存成功!'}"
    else  s Ret="{success:'false',info:"_$p(Result,"errorinfo:",2)
    q Ret
}

/// Function:  新增<医嘱项年龄/性别限制>
/// CreateDate: 2014-11-4
/// Creator:   sunfengchao
/// Table:     ARC_ItemAgeSexRestriction
/// Debug:     w ##class(web.DHCBL.CT.ARCItemAgeSexRestriction).AddData("9||1^2^3^53")
ClassMethod AddData(AddOrderAgeSexStr As %String) As %String
{
    n (AddOrderAgeSexStr,%session)
    s result=""
    s eobj = ##class(web.Entity.CT.ARCItemAgeSexRestriction).%New()
    s eobj.AGERowId=""
    s eobj.AGEParRef=$p(AddOrderAgeSexStr,"^",1)
    s eobj.AGESexDR=$p(AddOrderAgeSexStr,"^",2)
    s eobj.AGEAgeFrom= $p(AddOrderAgeSexStr,"^",3)
    s eobj.AGEAgeTo=$p(AddOrderAgeSexStr,"^",4)
	s eobj.AGEAgeFromType=$p(AddOrderAgeSexStr,"^",5) 	//从年龄类型 （岁/月/日）
	s eobj.AGEAgeToType=$p(AddOrderAgeSexStr,"^",6) 	//到年龄类型 （岁/月/日）
    s Result= ##class(web.DHCBL.CT.ARCItemAgeSexRestriction).SaveEntity(eobj)
    if Result["success:'true'" s Ret= "{success:'true',info:'保存成功!'}"
    else  s Ret="{success:'false',info:"_$p(Result,"errorinfo:",2)
    q Ret
}

/// Function:  保存<医嘱项年龄/性别限制>
/// CreateDate: 2017-3-2
/// Creator:   陈莹
/// Table:     ARC_ItemAgeSexRestriction
/// Debug:    d ##class(web.DHCBL.CT.ARCItemAgeSexRestriction).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.ARCItemAgeSexRestriction) As %String
{
    n (eobj,%session)
    if ((eobj.AGEAgeFrom="")&(eobj.AGEAgeTo="")&(eobj.AGESexDR=""))
    {
        q "{success:'false',errorinfo:'数据不能全为空,请重新操作!'}"
    }
    s result="",flag=""
	s flag=..FormValidate(eobj.AGEParRef,eobj.AGERowId,eobj.AGESexDR,eobj.AGEAgeFrom,eobj.AGEAgeTo,eobj.AGEAgeFromType,eobj.AGEAgeToType)   
    if (flag=1)
    {
        s result= "{success:'false',errorinfo:'该数据已存在！'}"
    }
    else
    { 
    	s:((eobj.AGEAgeFromType="")&&(eobj.AGEAgeFrom'="")) eobj.AGEAgeFromType="Y"
    	s:((eobj.AGEAgeToType="")&&(eobj.AGEAgeTo'="")) eobj.AGEAgeToType="Y"		//为空时，默认为岁
    	if (eobj.AGEAgeFromType'="Y")&&(eobj.AGEAgeFromType'="M")&&(eobj.AGEAgeFromType'="D")
		{
			s eobj.AGEAgeFromType=$case(eobj.AGEAgeFromType,"岁":"Y","月":"M","日":"D",:"")
		}
		if (eobj.AGEAgeToType'="Y")&&(eobj.AGEAgeToType'="M")&&(eobj.AGEAgeToType'="D")
		{
			s eobj.AGEAgeToType=$case(eobj.AGEAgeToType,"岁":"Y","月":"M","日":"D",:"")
		}
        if (eobj.AGERowId="")
        {
            s obj = ##class(User.ARCItemAgeSexRestriction).%New(eobj.AGEParRef) 
        }
        else
        {
            s obj=##class(User.ARCItemAgeSexRestriction).%OpenId(eobj.AGERowId)
            s bobj = ##class(web.Entity.CT.ARCItemAgeSexRestriction).%New()
            s bobj.AGERowId= eobj.AGERowId
            s bobj.AGEParRef=$p(eobj.AGERowId,"||",1)
            s bobj.AGEAgeFrom= obj.AGEAgeFrom
            s bobj.AGEAgeTo=obj.AGEAgeTo
            if $IsObject(obj.AGESexDR)
            {
                s bobj.AGESexDR = obj.AGESexDR.%Id() 
            }
			s bobj.AGEAgeFromType=obj.AGEAgeFromType 	//从年龄类型 （岁/月/日）
			s bobj.AGEAgeToType=obj.AGEAgeToType 	//到年龄类型 （岁/月/日）
        }
        Tstart
        d obj.AGEParRefSetObjectId(eobj.AGEParRef)
        s obj.AGEAgeFrom=eobj.AGEAgeFrom
        s obj.AGEAgeTo=eobj.AGEAgeTo
        d:eobj.AGESexDR'="" obj.AGESexDRSetObjectId(eobj.AGESexDR)
        d:eobj.AGESexDR="" obj.AGESexDRSetObjectId("") 
		s obj.AGEAgeFromType=eobj.AGEAgeFromType 	//从年龄类型 （岁/月/日）
		s obj.AGEAgeToType=eobj.AGEAgeToType 	//到年龄类型 （岁/月/日）
        s sc=obj.%Save()
        if $$$ISOK(sc)
        {
            Tc
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"
            d:eobj.AGERowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItemAgeSexRestriction","User.ARCItemAgeSexRestriction","医嘱项年龄/性别限制",id,eobj.AGESexDR,"A",eobj)
            d:eobj.AGERowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItemAgeSexRestriction","User.ARCItemAgeSexRestriction","医嘱项年龄/性别限制",id,eobj.AGESexDR,"U",eobj,bobj)
            d eobj.%Close() 
        }
        else
        {
            Trollback
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱项年龄/性别限制","web.DHCBL.CT.ARCItemAgeSexRestriction","SaveEntity",eobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
            s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"!'}"
        }
    }

    q result
}

/// Function:添加医嘱项年龄性别限制 
/// Creator: 基础数据平台组 sunfengchao
/// CreateDate:2014-12-25
/// Debug: W ##class(web.DHCBL.CT.ARCItemAgeSexRestriction).MultiAddAgeSex("13902||1","1^1^1")
ClassMethod MultiAddAgeSex(rowid As %String, AddAgeSexStr As %String) As %String
{
    n (AddAgeSexStr,rowid,%session)
    s result=""
    q:AddAgeSexStr="" "{success:'true'}"
    s flag=0
    s Agesexlength=$length(AddAgeSexStr,"*")
    for i=1:1:Agesexlength 
    {
        Set AgeSexStr=$P(AddAgeSexStr,"*",i)  
        s eobj = ##class(web.Entity.CT.ARCItemAgeSexRestriction).%New()
        s eobj.AGERowId= ""
        s eobj.AGEParRef=rowid
        s eobj.AGESexDR=$p(AgeSexStr,"^",1)
        s eobj.AGEAgeFrom=$p(AgeSexStr,"^",2) 
        s eobj.AGEAgeTo=$p(AgeSexStr,"^",3)   
		 s eobj.AGEAgeFromType=$p(AgeSexStr,"^",4) 
		 s eobj.AGEAgeToType=$p(AgeSexStr,"^",5)  
        s Result= ##class(web.DHCBL.CT.ARCItemAgeSexRestriction).SaveEntity(eobj)
        if Result["success:'false'" s flag=1
    }

    if flag=1 q "{success:'false',info:'<医嘱项年龄/性别限制>添加失败, 请重新操作!'}"
    else  q "{success:'true'}"
}

/// Function:提供根据性别、年龄判断医嘱是否可用的接口
/// CreateDate:2022-11-25
/// Creator:sunfengchao
/// Table:  ARC_ItemAgeSexRestriction
/// Input:  ARCIMRowId:医嘱id , Sex:性别 , Age:年龄
/// Output: Y/N
/// Others: w ##class(web.DHCBL.CT.ARCItemAgeSexRestriction).GetAllowUseFlag("2||1","男",20)
ClassMethod GetAllowUseFlag(ARCIMRowId As %String, Sex As %String, Age As %String) As %String
{
    s result=""
    q:ARCIMRowId="" result 
    s ARCIMSubscript=$p(ARCIMRowId,"||",1)
    s ARCIMVersion=$p(ARCIMRowId,"||",2)
    q:(ARCIMSubscript="")||(ARCIMVersion="") ""
    if ((Sex="")&(Age=""))  // 年龄性别为空则返回医嘱对应的所有年龄性别限制数据
    {  
        s ChildSub=0
        for
        {  
            s ChildSub=$o(^ARCIM(ARCIMSubscript,ARCIMVersion,"AGE",ChildSub)) q:ChildSub=""  
            s AGERowId=ARCIMRowId_"||"_ChildSub  
            s AGESexDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"AGE",ChildSub)),"^",1)
            s:AGESexDR'="" AGESexDR=$p($g(^CT("SEX",AGESexDR)),"^",2)
            s AGEAgeFrom=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"AGE",ChildSub)),"^",2)
            s AGEAgeTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"AGE",ChildSub)),"^",3)
            if (result="") s result=AGESexDR_"^"_AGEAgeFrom_"^"_AGEAgeTo 
            else  s result=result_"#"_AGESexDR_"^"_AGEAgeFrom_"^"_AGEAgeTo  b ;1
        }
    }
    else
    { 
        s ChildSub=0
        for
        {  
            s ChildSub=$o(^ARCIM(ARCIMSubscript,ARCIMVersion,"AGE",ChildSub)) q:ChildSub=""  
            s AGERowId=ARCIMRowId_"||"_ChildSub 
            s AGESexDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"AGE",ChildSub)),"^",1)
            s:AGESexDR'="" AGESexDR=$p($g(^CT("SEX",AGESexDR)),"^",2)
            s AGEAgeFrom=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"AGE",ChildSub)),"^",2)
            s AGEAgeTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"AGE",ChildSub)),"^",3)
            if (AGEAgeTo="") s AGEAgeTo =200 //默认一个最大值
            if (+Age>=+AGEAgeFrom)&(+Age<=AGEAgeTo)&(AGESexDR=Sex)
            {
                s result="Y"
                q
            }
            else
            {
                s result="N"
                continue
            }
        }
    }
    q result
}

}
