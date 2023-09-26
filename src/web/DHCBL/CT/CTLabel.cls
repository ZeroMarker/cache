/// 名称:通用标签 
/// 编写者:sunfengchao 
/// 编写日期:2021-05-10
Class web.DHCBL.CT.CTLabel Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function:数据检索
/// CreateDate:2021-05-10
/// Creator: sunfengchao   
/// Tables:  CT_Label  
/// Others:  d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTLabel", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, table As %String) As %Query(ROWSPEC = "ID,LabelCode,LabelName,LabelActiveFlag,LabelRemark,LabelTableName,LabelCategory")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, table As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1

 if (rowid'="")  
 {
  s ID=rowid
  s LabelCode=$listget($g(^User.CTLabelD(ID)),2)
  s LabelName=$listget($g(^User.CTLabelD(ID)),3) 
  d OutputRow
 }
 else
 {
   if (table'="")
   {
      s ID=0
      for
      {
          s ID=$O(^User.CTLabelI("TableIdx"," "_$zcvt(table,"U"),ID))
          q:ID=""
          s LabelCode=$listget($g(^User.CTLabelD(ID)),2)  
          s LabelName=$listget($g(^User.CTLabelD(ID)),3) 
          d OutputRow 
      }
   }
   else
   {
       s:code'="" code=$zcvt(code,"U") 
       s:desc'="" desc=$zcvt(desc,"U")
       s ID=0
       for
       {
            s ID=$o(^User.CTLabelD(ID)) 
            q:ID=""
            s LabelCode=$listget($g(^User.CTLabelD(ID)),2)  
            s LabelName=$listget($g(^User.CTLabelD(ID)),3) 
            if (desc'="") ;需要对描述或者别名进行检索  
            { 
                s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Label",ID,LabelName,desc)
            }
            else
            {
                s AliasFlag=1   
            } 
            if ($ZCVT(LabelCode,"U")[code)&(AliasFlag=1) 
            {
                d OutputRow
            }
         }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow  
    s LabelActiveFlag=$listget($g(^User.CTLabelD(ID)),4)
    s LabelRemark=$listget($g(^User.CTLabelD(ID)),5)
    s LabelTableName=$listget($g(^User.CTLabelD(ID)),6)
    s LabelCategory=$listget($g(^User.CTLabelD(ID)),7)
    set Data=$lb(ID,LabelCode,LabelName,LabelActiveFlag,LabelRemark,LabelTableName,LabelCategory)
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

/// Function:  下拉框数据检索 
/// CreateDate:2021-05-10
/// Creator:   sunfengchao
/// Tables:    CT_Label  
/// Others:    d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTLabel", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, table As %String) As %Query(ROWSPEC = "ID,LabelCode,LabelName")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, table As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=1
 s:code'="" code=$ZCVT(code,"U")  
 s:desc'="" desc=$ZCVT(desc,"U")
 
 if (rowid'="")  
 {
    s ID=rowid
    s LabelCode=$listget($g(^User.CTLabelD(ID)),2)
    s LabelName=$listget($g(^User.CTLabelD(ID)),3)
    d OutputRowCmb
 }
 else
 {
   s ID=0
   for
   {
        s ID=$O(^User.CTLabelI("TableIdx"," "_$zcvt(table,"U"),ID))
        q:ID="" 
        s LabelActiveFlag=$listget($g(^User.CTLabelD(ID)),4)
        continue:LabelActiveFlag="N"
        s LabelCode=$listget($g(^User.CTLabelD(ID)),2)
        s LabelName=$listget($g(^User.CTLabelD(ID)),3) 
        if (desc'="") ;需要对描述或者别名进行检索  
        { 
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Label",ID,LabelName,desc)
        }
        else
        {
            s AliasFlag=1   
        } 
        if ($ZCVT(LabelCode,"U")[code)&(AliasFlag=1) 
        {
            d OutputRowCmb
        } 
    }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ID,LabelCode,LabelName)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
 Set repid=$LIST(qHandle,2)
  Kill ^CacheTemp(repid)  
  Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
 
  Set AtEnd=$LIST(qHandle,1)
  Set repid=$LIST(qHandle,2)
  Set ind=$LIST(qHandle,3)
  
  Set ind=$o(^CacheTemp(repid,ind))
  If ind="" {    // if there are no more rows, finish fetching
   Set AtEnd=1
   Set Row=""
  }
  Else      {    // fetch row
   Set Row=^CacheTemp(repid,ind)
  }
  s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Function：标签所属表名的查询 
/// CreatDate:2020-03-30
/// Creator： sunfengchao
/// Table：   User.CTLabel   
/// Other:    d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTLabel","GetTypeList")
Query GetTypeList() As %Query(ROWSPEC = "TableName:%String")
{
}

ClassMethod GetTypeListExecute(ByRef qHandle As %Binary) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    s TableName=0
    for  
    {   
        s TableName=$o(^User.CTLabelI("TableLabelCodeIdx",TableName)) 
        q:TableName="" 
        s TableNameA=$replace(TableName," ","")
        d OutputTypeRow
    }
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputTypeRow
    set Data=$lb(TableNameA)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTypeListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTypeListExecute ]
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

/// Function: 用于数据删除或修改时的逻辑判断
/// Creator: sunfengchao
/// CreateDate:2021-05-10
/// Input:   id  
/// Output:  返回一个标志位，0为未被引用，表示可以被删除，1表示已经被引用了，不能被删除
ClassMethod GetRefFlag(id As %String) As %String
{
  s return="",myInfo=""
  
  if ($d(^User.CTLabelLinkARCIMI("LabelDRIndex",+id))) s myInfo=myInfo_"<医嘱关联标签>"
  
	//医护人员关联标签
	s CareProvDR=0
	for
	{
		s CareProvDR=$o(^CTPCP(CareProvDR)) q:CareProvDR=""
		if $d(^CTPCP(CareProvDR,"LinkLabel",0,"Label",id))
		{
			s myInfo=myInfo_"<医护人员关联标签>"
			q
		}
	}
  
  if (myInfo="")
  {
    s return="0^未被引用可删除！"
  }
  else 
  {
    s return="1^在"_myInfo_"表里被引用,不能删除!"
  }
 q return
}

/// Function:删除操作
/// Creator: sunfengchao
/// CreateDate:2021-05-10
/// Output: success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables: CT_Label 
/// Others: d ##class(web.DHCBL.CT.CTLabel).DeleteData("")
ClassMethod DeleteData(id As %String) As %String
{
  s result="",flag="" 
  s re=##class(web.DHCBL.CT.CTLabel).GetRefFlag(id)
  s RefFlag=$p(re,"^",1)
  if (RefFlag=1)
  {
   s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
  }
  else
  {
    s pobj = ##class(User.CTLabel).%OpenId(id)
    s eobj = ##class(web.Entity.CT.CTLabel).%New()
    s eobj.ID = id
    S eobj.LabelCode=pobj.LabelCode
    s eobj.LabelName= pobj.LabelName
    s eobj.LabelActiveFlag=pobj.LabelActiveFlag
    s eobj.LabelRemark=pobj.LabelRemark
    s eobj.LabelTableName=pobj.LabelTableName
    s eobj.LabelCategory=pobj.LabelCategory
    Tstart
    s sc=##class(User.CTLabel).%DeleteId(id)
    if $$$ISOK(sc)
    {
     Tcommit
     s result="{success:'true',info:'删除成功！'}"
     d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Label","User.CTLabel","通用标签",id,eobj.LabelName,"D",eobj)
     d eobj.%Close()
    }
    else
    {
      Trollback
      s result= "{success:'false',info:'删除失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
      s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用标签","web.DHCBL.CT.CTLabel","DeleteData",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    }
   }
   q result
}

/// Function:用于双击修改时数据加载 
/// Creator: sunfengchao
/// CreateDate:2021-05-10
/// Input: id
/// Tables:CT_Label 
/// Others:w ##class(web.DHCBL.CT.CTLabel).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.CTLabel).%OpenId(id)
 s eobj = ##class(web.Entity.CT.CTLabel).%New()
 s eobj.ID = id
 S eobj.LabelCode=pobj.LabelCode
 s eobj.LabelName= pobj.LabelName
 s eobj.LabelActiveFlag=pobj.LabelActiveFlag
 s eobj.LabelRemark=pobj.LabelRemark
 s eobj.LabelTableName=pobj.LabelTableName
 s eobj.LabelCategory=pobj.LabelCategory
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:进行数据重复校验功能 
/// Creator: sunfengchao
/// CreateDate:2021-05-10
/// Table:CT_Label 
ClassMethod FormValidate(id As %String, code As %String, desc As %String, table As %String) As %String
{
 
 s flag="",flagc="", flagd=""
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) 
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc)   
 s:code'="" flagc=$d(^User.CTLabelI("TableLabelCodeIdx"," "_$zcvt(table,"U")," "_code))
 s:desc'="" flagd=$d(^User.CTLabelI("TableLabelNameIdx"," "_$zcvt(table,"U")," "_desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0))
  {
   s flag=1  //返回重复标志
  }
  else
  {
   s flag=0 //返回不重复标志
  }
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^User.CTLabelI("TableLabelCodeIdx"," "_$zcvt(table,"U")," "_code,0)) 
  s:desc'="" idd=$o(^User.CTLabelI("TableLabelNameIdx"," "_$zcvt(table,"U")," "_desc,0))
  if (desc="")
  {
   if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
   else  s flag=0 //返回不重复标志
  }
  else
  {
   if (code="")
   {
    if (idd'=id)&(flagd>0) s flag=1  //返回重复标志
    else  s flag=0 //返回不重复标志
   }
   else
   {
    if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
    else  s flag=0 //返回不重复标志
   }
  }
 }
 q flag
}

/// Function:实现修改增加操作
/// Creator: sunfengchao
/// CreateDate:2021-05-10 
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: CT_Label   
ClassMethod SaveEntity(eobj As web.Entity.CT.CTLabel) As %String
{
  //s $zt="ERROR"
  s result="" 
  s flag= ..FormValidate(eobj.ID,eobj.LabelCode,eobj.LabelName,eobj.LabelTableName)  //调用重复验证
  if (flag=1)
  {
     s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
    if (eobj.ID="")       
    {
       s obj=##class(User.CTLabel).%New()
    } 
    else 
    {  
       s obj=##class(User.CTLabel).%OpenId(eobj.ID)
       s bobj=##class(web.Entity.CT.CTLabel).%New() 
       s bobj.ID=eobj.ID
       s bobj.LabelCode = obj.LabelCode
       s bobj.LabelName = obj.LabelName
       s bobj.LabelActiveFlag = obj.LabelActiveFlag
       s bobj.LabelRemark=obj.LabelRemark
       s bobj.LabelTableName= obj.LabelTableName
       s bobj.LabelCategory= obj.LabelCategory
    }
  s obj.LabelCode = eobj.LabelCode
  s obj.LabelName = eobj.LabelName
  if eobj.LabelActiveFlag=""  s eobj.LabelActiveFlag="N"
  s obj.LabelActiveFlag = eobj.LabelActiveFlag
  s obj.LabelRemark=eobj.LabelRemark
  s obj.LabelTableName=eobj.LabelTableName
  s obj.LabelCategory=eobj.LabelCategory
  Tstart
  s sc=obj.%Save()
  if $$$ISOK(sc)
  {
   Tcommit
   s id = obj.%Id()
   s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
   d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Label","User.CTLabel","通用标签",eobj.ID,eobj.LabelName,"U",eobj,bobj)
   d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Label","User.CTLabel","通用标签",id,eobj.LabelName,"A",eobj)
  }
  else
  {
    Trollback
    s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用标签","web.DHCBL.CT.CTLabel","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
 }  
 q result
}

}
