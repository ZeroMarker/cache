/// 描述: 工厂注册
/// 编写者：基础数据平台组-石萧伟
/// 编写日期: 2019-07-18
Class web.DHCBL.MKB.MKBStructuredBase Extends %RegisteredObject
{

/// Creator：石萧伟
/// CreatDate: 2019-07-18
/// Description：获取界面数据
/// Input:desc查询条件
/// return:
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBStructuredBase","GetList","","")
Query GetList(rowid As %String, desc As %String) As %Query(ROWSPEC = "Rowid,MKBSTBDesc,MKBSTBICDDr,MKBSTBStrDr,MKBSTBStr,MKBSTBICD,MKBSTBSource,MKBSTBLocDr,MKBSTBLoc,MKBSTBODFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
    s Rowid=rowid
    s MKBSTBDesc=$LISTGET($G(^User.MKBStructuredBaseD(Rowid)),2)
    s MKBSTBICDDr=$LISTGET($G(^User.MKBStructuredBaseD(Rowid)),3)
    s MKBSTBStrDr=$LISTGET($G(^User.MKBStructuredBaseD(Rowid)),4)
    //s MKBSTBFlag=$LISTGET($G(^User.MKBStructuredBaseD(Rowid)),5)
    s MKBSTBSource = $LISTGET($G(^User.MKBStructuredBaseD(Rowid)),6)
    //s MKBSTBNonstandardFlag = $LISTGET($G(^User.MKBStructuredBaseD(Rowid)),7)
    s MKBSTBLocDr=$LISTGET($G(^User.MKBStructuredBaseD(Rowid)),8)
    s MKBSTBODFlag=$LISTGET($G(^User.MKBStructuredBaseD(Rowid)),9)
    if (MKBSTBODFlag = "Diagnosis")
    {
		s MKBSTBODFlag = "诊断"  
    }
    if (MKBSTBODFlag = "Operation")
    {
		s MKBSTBODFlag = "手术"  
    }
    s MKBSTBStr=""
    s MKBSTBICD=""
    s MKBSTBLoc=""
    s:MKBSTBStrDr'="" MKBSTBStr=$LISTGET($G(^User.MKBTermBaseD(MKBSTBStrDr)),3)
    s:MKBSTBICDDr'="" MKBSTBICD=$LISTGET($G(^User.MKBTermBaseD(MKBSTBICDDr)),3)
    s:MKBSTBLocDr'="" MKBSTBLoc=$LISTGET($G(^User.MKBTermBaseD(MKBSTBLocDr)),3)
    d OutputRow
 }
 else
 {
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写

    s Rowid=0
    for{  
      s Rowid=$o(^User.MKBStructuredBaseD(Rowid)) q:Rowid=""   
	  s MKBSTBDesc=$LISTGET($G(^User.MKBStructuredBaseD(Rowid)),2)
	  s MKBSTBICDDr=$LISTGET($G(^User.MKBStructuredBaseD(Rowid)),3)
	  s MKBSTBStrDr=$LISTGET($G(^User.MKBStructuredBaseD(Rowid)),4)
	  //s MKBSTBFlag=$LISTGET($G(^User.MKBStructuredBaseD(Rowid)),5)
	  s MKBSTBSource = $LISTGET($G(^User.MKBStructuredBaseD(Rowid)),6)
	  //s MKBSTBNonstandardFlag = $LISTGET($G(^User.MKBStructuredBaseD(Rowid)),7)
	  s MKBSTBLocDr=$LISTGET($G(^User.MKBStructuredBaseD(Rowid)),8)
	  s MKBSTBODFlag=$LISTGET($G(^User.MKBStructuredBaseD(Rowid)),9)
	  if (MKBSTBODFlag = "Diagnosis")
	  {
		  s MKBSTBODFlag = "诊断"  
	  }
	  if (MKBSTBODFlag = "Operation")
	  {
		  s MKBSTBODFlag = "手术"  
	  }
      s MKBSTBStr=""
      s MKBSTBICD=""
      s MKBSTBLoc=""
      s:MKBSTBStrDr'="" MKBSTBStr=$LISTGET($G(^User.MKBTermBaseD(MKBSTBStrDr)),3)
      s:MKBSTBICDDr'="" MKBSTBICD=$LISTGET($G(^User.MKBTermBaseD(MKBSTBICDDr)),3)
      s:MKBSTBLocDr'="" MKBSTBLoc=$LISTGET($G(^User.MKBTermBaseD(MKBSTBLocDr)),3)

	  
      s PINYIN=""
      s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBSTBDesc)  
      if (($ZCONVERT(MKBSTBDesc,"U")[desc)||(PINYIN[desc)) {
        d OutputRow
      }
    }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(Rowid,MKBSTBDesc,MKBSTBICDDr,MKBSTBStrDr,MKBSTBStr,MKBSTBICD,MKBSTBSource,MKBSTBLocDr,MKBSTBLoc,MKBSTBODFlag)
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

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 石萧伟
/// CreateDate:2019-07-18    
/// w ##class(web.DHCBL.MKB.MKBStructuredBase).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, desc As %String) As %String
{
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc=""
    s:desc'="" flagc=$d(^User.MKBStructuredBaseI("DescIndex"," "_desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if (flagc>0) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc=""
        s:desc'="" idc=$o(^User.MKBStructuredBaseI("DescIndex"," "_desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator：石萧伟
/// CreatDate: 2018-03-29
/// Input:
/// Description：保存修改内容
/// return:成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.MKB.MKBStructuredBase) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        s flag=..FormValidate(eobj.Rowid,eobj.MKBSTBDesc)   
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'已存在相同名称的数据！'}"
        }
        else
        {   
            if (eobj.Rowid="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.MKBStructuredBase).%New()
            }
            else  //如果RowId已赋值则修改
            {
                s obj=##class(User.MKBStructuredBase).%OpenId(eobj.Rowid)
                
                s bobj = ##class(web.Entity.MKB.MKBStructuredBase).%New()
                s bobj.Rowid = eobj.Rowid
                //s bobj.MKBSTBICDDr = obj.MKBSTBICDDr
                s bobj.MKBSTBStrDr = obj.MKBSTBStrDr
                s bobj.MKBSTBDesc = obj.MKBSTBDesc
                //s bobj.MKBSTBFlag = obj.MKBSTBFlag
                //s bobj.MKBSTBNonstandardFlag = obj.MKBSTBNonstandardFlag
                s bobj.MKBSTBSource = obj.MKBSTBSource
                //s bobj.MKBSTBLocDr = obj.MKBSTBLocDr
                s bobj.MKBSTBODFlag = obj.MKBSTBODFlag

            }
            
            s obj.MKBSTBDesc = eobj.MKBSTBDesc
            d:eobj.MKBSTBICDDr'="" obj.MKBSTBICDDrSetObjectId(eobj.MKBSTBICDDr)
            d obj.MKBSTBStrDrSetObjectId(eobj.MKBSTBStrDr)
            d:eobj.MKBSTBLocDr'="" obj.MKBSTBLocDrSetObjectId(eobj.MKBSTBLocDr)
            //s obj.MKBSTBFlag = eobj.MKBSTBFlag
            s obj.MKBSTBSource = eobj.MKBSTBSource
            //s obj.MKBSTBNonstandardFlag = eobj.MKBSTBNonstandardFlag
            s obj.MKBSTBODFlag = eobj.MKBSTBODFlag

            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc){
                Tc
                s id = obj.%Id()
                
                if (eobj.Rowid=""){					 
				 	//新增一厂菜单
			   		s menuobj=##class(web.Entity.BDP.BDPMenu).%New()
			   		s menuobj.Code = "dhc.bdp.mkb.stb."_id           
		   			s menuobj.Caption = eobj.MKBSTBDesc   
		   			s menuobj.LinkFuntionDR=""   
				   	s menuobj.LinkUrl = "dhc.bdp.mkb.mkbstructuredata.csp?STBBase="_id_"&base="_eobj.MKBSTBStrDr_"&icdtermbase="_eobj.MKBSTBICDDr     
		   			s ParentMenuDr=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.STB",0))
		   			s menuobj.ParentMenuDr=ParentMenuDr
		   			s menuobj.Sequence = id //##class(web.DHCBL.BDP.BDPMenuDefine).GetSequence(ParentMenuDr)
		   			s menuobj.ValueExpression="&STBBase="_id_"&base="_eobj.MKBSTBStrDr_"&icdtermbase="_eobj.MKBSTBICDDr
		   			s menuobj.actMenuBDP="1"
		   			s menuobj.actMenuAutItem="1"
		   			s menuobj.actMenuAutData="1"
		   			s menuobj.IsMKBMenu="Y"
		   			s resultMenu=##class(web.DHCBL.BDP.BDPMenu).SaveEntity(menuobj,"")
		   			if (resultMenu'["true"){
			   			s result = "{success:'false',errorinfo:'菜单维护数据插入失败！'}"
			   		}
			   		//新增二厂菜单
			   		s smenuobj=##class(web.Entity.BDP.BDPMenu).%New()
			   		s smenuobj.Code = "dhc.bdp.mkb.stb2."_id 
			   		if (eobj.MKBSTBDesc["工厂"){
				   		s smenuobj.Caption = $replace(eobj.MKBSTBDesc,"工厂","二厂")
				   	}else{
						s smenuobj.Caption = eobj.MKBSTBDesc_"二厂"  
					}         
		   			 
		   			s smenuobj.LinkFuntionDR=""   
				   	s smenuobj.LinkUrl = "dhc.bdp.mkb.mkbstructuredseconddata.csp?STBBase="_id_"&base="_eobj.MKBSTBStrDr_"&icdtermbase="_eobj.MKBSTBICDDr      
		   			s ParentMenuDr=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.STB2",0))
		   			s smenuobj.ParentMenuDr=ParentMenuDr
		   			s smenuobj.Sequence = id //##class(web.DHCBL.BDP.BDPMenuDefine).GetSequence(ParentMenuDr)
		   			s smenuobj.ValueExpression="&STBBase="_id_"&base="_eobj.MKBSTBStrDr_"&icdtermbase="_eobj.MKBSTBICDDr
		   			s smenuobj.actMenuBDP="1"
		   			s smenuobj.actMenuAutItem="1"
		   			s smenuobj.actMenuAutData="1"
		   			s smenuobj.IsMKBMenu="Y"
		   			s resultMenus=##class(web.DHCBL.BDP.BDPMenu).SaveEntity(smenuobj,"")
		   			if (resultMenus'["true"){
			   			s result = "{success:'false',errorinfo:'菜单维护数据插入失败！'}"
			   		}
			   		
			   		
				 }else{
					 //修改一厂菜单
			   		s menuobj=##class(web.Entity.BDP.BDPMenu).%New()
			   		s menuobj.ID=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.STB."_$ZCONVERT(id,"U"),0))
			   		s menuobj.Code = "dhc.bdp.mkb.stb."_id           
		   			s menuobj.Caption = eobj.MKBSTBDesc   
				   	s menuobj.LinkUrl = "dhc.bdp.mkb.mkbstructuredata.csp?STBBase="_id_"&base="_eobj.MKBSTBStrDr_"&icdtermbase="_eobj.MKBSTBICDDr        
		   			s ParentMenuDr=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.STB",0))
		   			s menuobj.ParentMenuDr=ParentMenuDr
		   			s menuobj.Sequence = id //##class(web.DHCBL.BDP.BDPMenuDefine).GetSequence(ParentMenuDr)-1
		   			s menuobj.ValueExpression="&STBBase="_id_"&base="_eobj.MKBSTBStrDr_"&icdtermbase="_eobj.MKBSTBICDDr
		   			s menuobj.actMenuBDP="1"
		   			s menuobj.actMenuAutItem="1"
		   			s menuobj.actMenuAutData="1"   
		   			s menuobj.IsMKBMenu="Y"     
		   			s resultMenu=##class(web.DHCBL.BDP.BDPMenu).SaveEntity(menuobj,"")
		   	
		   			if (resultMenu'["true"){
			   			s result = "{success:'false',errorinfo:'菜单维护数据修改失败！'}"
			   		}
			   		
			   		
			   		//修改二厂菜单
			   		s smenuobj=##class(web.Entity.BDP.BDPMenu).%New()
			   		s smenuobj.ID=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.STB2."_$ZCONVERT(id,"U"),0))
			   		s smenuobj.Code = "dhc.bdp.mkb.stb2."_id           
			   		if (eobj.MKBSTBDesc["工厂"){
				   		s smenuobj.Caption = $replace(eobj.MKBSTBDesc,"工厂","二厂")
				   	}else{
						s smenuobj.Caption = eobj.MKBSTBDesc_"二厂"  
					}  
				   	s smenuobj.LinkUrl = "dhc.bdp.mkb.mkbstructuredseconddata.csp?STBBase="_id_"&base="_eobj.MKBSTBStrDr_"&icdtermbase="_eobj.MKBSTBICDDr        
		   			s ParentMenuDr=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.STB2",0))
		   			s smenuobj.ParentMenuDr=ParentMenuDr
		   			s smenuobj.Sequence = id //##class(web.DHCBL.BDP.BDPMenuDefine).GetSequence(ParentMenuDr)-1
		   			s smenuobj.ValueExpression="&STBBase="_id_"&base="_eobj.MKBSTBStrDr_"&icdtermbase="_eobj.MKBSTBICDDr
		   			s smenuobj.actMenuBDP="1"
		   			s smenuobj.actMenuAutItem="1"
		   			s smenuobj.actMenuAutData="1"   
		   			s smenuobj.IsMKBMenu="Y"     
		   			s resultMenus=##class(web.DHCBL.BDP.BDPMenu).SaveEntity(smenuobj,"")
		   	
		   			if (resultMenus'["true"){
			   			s result = "{success:'false',errorinfo:'菜单维护数据修改失败！'}"
			   		}

				 }
                
                s result = "{success:'true',id:'"_id_"'}" //返回RowId
                d:eobj.Rowid="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_StructuredBase","User.MKBStructuredBase","工厂注册",id,eobj.MKBSTBDesc,"A",eobj)
                d:eobj.Rowid'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_StructuredBase","User.MKBStructuredBase","工厂注册",eobj.Rowid,eobj.MKBSTBDesc,"U",eobj,bobj)
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
                //s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("术语文献管理","web.DHCBL.MKB.MKBDocManage","SaveData",eobj)
                //s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
            }
        }   
    }   
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在'}"
    }
    
    q result
}

/// Creator：石萧伟
/// CreatDate: 2019-07-18
/// Input:对象id
/// Description：修改时打开的对象数据
/// return:对象json串
/// w ##class(web.DHCBL.MKB.MKBStructuredBase).OpenData(1881)
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.MKB.MKBStructuredBase).%New()
    s eobj.Rowid = id
    s eobj.MKBSTBDesc = $lg($g(^User.MKBStructuredBaseD(id)),2)  
    //s eobj.MKBSTBICDDr = $lg($g(^User.MKBStructuredBaseD(id)),3)
    s eobj.MKBSTBStrDr = $lg($g(^User.MKBStructuredBaseD(id)),4)
    //s eobj.MKBSTBFlag = $lg($g(^User.MKBStructuredBaseD(id)),5)
    s eobj.MKBSTBSource = $lg($g(^User.MKBStructuredBaseD(id)),6)
    //s eobj.MKBSTBNonstandardFlag = $lg($g(^User.MKBStructuredBaseD(id)),7)
    //s eobj.MKBSTBLocDr = $lg($g(^User.MKBStructuredBaseD(id)),8)
    s eobj.MKBSTBODFlag = $lg($g(^User.MKBStructuredBaseD(id)),9)
    s str = eobj.JsonS()    
    q str
}

/// Creator：石萧伟
/// CreatDate: 2018-03-29
/// Input:对象id
/// Description：删除对象
/// Return：成功返回true，失败返回false和失败原因
/// w ##class(web.DHCBL.MKB.MKBStructuredBase).DeleteData(13)
ClassMethod DeleteData(id) As %String
{
  s result=""
  //s errorinfo = ##class(web.DHCBL.MKB.MKBReference).DeleteData("DOC",id)
  //if (errorinfo'="")
  //{
	// s result = "{success:'false',info:'"_errorinfo_"'}"
	 //q result 	 
  //}	 
  s eobj=##class(web.Entity.MKB.MKBStructuredBase).%New()
  s eobj.Rowid=id
  s eobj.MKBSTBDesc=$LISTGET($G(^User.MKBStructuredBaseD(id)),2)
  s eobj.MKBSTBICDDr=$LISTGET($G(^User.MKBStructuredBaseD(id)),3)
  s eobj.MKBSTBStrDr=$LISTGET($G(^User.MKBStructuredBaseD(id)),4)
  //s eobj.MKBSTBFlag=$LISTGET($G(^User.MKBStructuredBaseD(id)),5)
  s eobj.MKBSTBSource=$LISTGET($G(^User.MKBStructuredBaseD(id)),6)
  //s eobj.MKBSTBNonstandardFlag=$LISTGET($G(^User.MKBStructuredBaseD(id)),7)
  s eobj.MKBSTBLocDr=$LISTGET($G(^User.MKBStructuredBaseD(id)),3)
  s eobj.MKBSTBODFlag = $LISTGET($G(^User.MKBStructuredBaseD(id)),9)
  Tstart
  s sc=##class(User.MKBStructuredBase).%DeleteId(id)
  IF $$$ISOK(sc) {
   Tc
   s result="{success:'true',info:'删除成功'}"
   //保存日志
   	s flagMenu=..GetMenuExist(eobj.Rowid)
	if (flagMenu=1){
		//菜单中删除dhc.bdp.mkb.stb
		s menuID=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.STB."_$ZCONVERT(eobj.Rowid,"U"),0))
		s resultMenu = ##class(web.DHCBL.BDP.BDPMenu).DeleteData(menuID)
		s menuID2=$o(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.STB2."_$ZCONVERT(eobj.Rowid,"U"),0))
		s resultMenu2 = ##class(web.DHCBL.BDP.BDPMenu).DeleteData(menuID2)

		if ((resultMenu'["true") || (resultMenu2'["true")){
			s result = "{success:'false',info:'菜单维护数据删除失败！'}"
		}
	}	
   d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_StructuredBase","User.MKBStructuredBase","工厂注册",id,eobj.MKBSTBDesc,"D",eobj)
   d eobj.%Close()
   //d ##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("DOC",id)
  }
  else 
  {
     Trollback
     //s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
     s result = "{success:'false',errorinfo:'"_$SYSTEM.Status.GetErrorText(sc)_"'}"
     //s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("术语文献管理","web.DHCBL.MKB.MKBDocManage","DeleteData",eobj)
     //s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)   
  }
 q result
}

/// Creator：石萧伟
/// CreatDate: 2018-03-27
/// Description:知识库删除时，判断知识库生成的菜单是否存在
/// Table：User.MKBTermBase
/// Input：code
/// Other: w ##class(web.DHCBL.MKB.MKBTermBase).GetMenuExist("Test")
ClassMethod GetMenuExist(code As %String) As %String
{
	s flagc="",flag=""
	s:code'="" code=$ZCONVERT(code,"U")
	s:code'="" flagc=$d(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.STB."_code))
	if (flagc>0){
		s flag=1	
	}
	q flag
}

/// Creator：石萧伟
/// CreatDate: 2019-07-18
/// Description：判断是否有数据设置成了当前医院
/// return:对象json串
/// w ##class(web.DHCBL.MKB.MKBStructuredBase).JusthaveY()
ClassMethod JusthaveY() As %String
{
	s Rowid=0
	s MKBSTBDesc=""
	s id = ""
	for
	{
		s Rowid=$o(^User.MKBStructuredBaseI("FlagIndex"," Y",Rowid))
		q:Rowid=""
  		s MKBSTBDesc=$LISTGET($G(^User.MKBStructuredBaseD(Rowid)),2)
  		s id = Rowid		
	}
	q MKBSTBDesc_"*"_id
}

/// Creator：石萧伟
/// CreatDate: 2019-07-29
/// Description：查询知识库表内容 含有诊断模板属性的
/// Table：User.MKBTermBase
/// Input：rowid, desc, type
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBStructuredBase","GetList","","","")
Query GetTermBaseList(desc As %String) As %Query(ROWSPEC = "MKBTBRowId,MKBTBCode,MKBTBDesc")
{
}

ClassMethod GetTermBaseListExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 

	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:desc'="" desc=$tr(desc," ","") //过滤空格

	s MKBTBRowId=""
	for{  
	  s MKBTBRowId=$o(^User.MKBTermBaseD(MKBTBRowId),-1) 
	  q:MKBTBRowId=""
	  
	  continue:$D(^User.MKBTermBasePropertyI("FlagIndex",MKBTBRowId," DT"))=0
	    
	  //continue:MKBTBRowId=5
	  s MKBTBCode=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),2)
	  s MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),3)
	  s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTBDesc)  
	  if (($ZCONVERT(MKBTBDesc,"U")[desc)||(PINYIN[desc)||(MKBTBPYCode[desc)) {
	  	d OutputRow
	  }
	}


 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(MKBTBRowId,MKBTBCode,MKBTBDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetTermBaseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTermBaseListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetTermBaseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTermBaseListExecute ]
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

/// Creator：石萧伟
/// CreatDate: 2019-07-29
/// Description：查询知识库表内容 ICD
/// Table：User.MKBTermBase
/// Input：rowid, desc, type
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBStructuredBase","GetICDBaseList","")
Query GetICDBaseList(desc As %String, cat As %String) As %Query(ROWSPEC = "MKBTBRowId,MKBTBCode,MKBTBDesc,catdesc")
{
}

ClassMethod GetICDBaseListExecute(ByRef qHandle As %Binary, desc As %String, cat As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 

	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:desc'="" desc=$tr(desc," ","") //过滤空格
	s:cat=1 cat="ICD"
	s:cat=2 cat="科室"
	s MKBTBRowId=""
	for{  
	  s MKBTBRowId=$o(^User.MKBTermBaseD(MKBTBRowId),-1) 
	  q:MKBTBRowId=""
	  
	  //continue:$D(^User.MKBTermBasePropertyI("FlagIndex",MKBTBRowId," DT"))=0
	  s catdr = $LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),9)
      s:catdr="" catdesc=""
      s:catdr'="" catdesc=..GetCatText(catdr)
	  continue:catdesc'=cat
	  
	  s MKBTBCode=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),2)
	  s MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(MKBTBRowId)),3)
	  s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTBDesc)  
	  if (($ZCONVERT(MKBTBDesc,"U")[desc)||(PINYIN[desc)||(MKBTBPYCode[desc)) {
	  	d OutputRow
	  }
	}


 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(MKBTBRowId,MKBTBCode,MKBTBDesc,catdesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetICDBaseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetICDBaseListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetICDBaseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetICDBaseListExecute ]
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

/// Creator：高姗姗(从termbase拷贝)
/// CreatDate: 2018-03-27
/// Description:根据分类的id串获取相应的描述信息
/// Table：User.MKBTermBase
/// Input：CatDr
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredBase).GetCatText("10,12")
ClassMethod GetCatText(CatDr As %String) As %String
{
    s CatText=""
    if (CatDr'=""){
		s len=$Length(CatDr,"&%")
		for i=1:1:len{
			s catid=$p(CatDr,"&%",i)
			s cat=$listGet($g(^User.MKBTermD(catid)),3)
			if (CatText=""){
				s CatText=cat
			}else{
				s CatText=CatText_","_cat	
			}
		} 
	}
	q CatText
}

/// Creator：获取实际科室
/// CreatDate: 2019-10-16
/// Description:根据base找termdr
/// Table：User.MKBTermBase
/// Input：stbbase
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBStructuredBase","GetLocList","9")	
Query GetLocList(stbbase As %String) As %Query(ROWSPEC = "MKBTRowId,MKBTDesc")
{
}

ClassMethod GetLocListExecute(ByRef qHandle As %Binary, stbbase As %String) As %Status
{
	s repid=$I(^CacheTemp)
 	s ind=1
 
 	s base=$LISTGET($G(^User.MKBStructuredBaseD(stbbase)),8) //实际科室指向
 	b ;
	if (base'="")  //存在实际科室指向 2020-4-20张云越增加
	{
		b ;$d(^User.MKBTermI("BaseIndex",base))
		
		if ($d(^User.MKBTermI("BaseIndex",base)))	//该术语库下有数据,
		{
			s MKBTRowId=""
			for  
			{	
				s MKBTRowId=$o(^User.MKBTermI("BaseIndex",base,MKBTRowId),-1) q:MKBTRowId="" 
				s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
				s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)		
				d OutputRow111			
			}
		}
		else		//没有的话取ctloc表的数据
		{
			s MKBTRowId=0
	        for  
	        {
	            s MKBTRowId=$o(^CTLOC(MKBTRowId)) q:MKBTRowId=""
                s MKBTDesc=$p($g(^CTLOC(MKBTRowId)),"^",2)     
                s CTLOCDateActiveTo=$p($g(^CTLOC(MKBTRowId)),"^",25)    //截止日期
                continue:(CTLOCDateActiveTo'="")&&(CTLOCDateActiveTo<+$h)
                d OutputRow111	
	        }
	        	
		}
	}
	else		//没有的话取ctloc表的数据
	{
		s MKBTRowId=0
        for  
        {
            s MKBTRowId=$o(^CTLOC(MKBTRowId)) q:MKBTRowId=""
            s MKBTDesc=$p($g(^CTLOC(MKBTRowId)),"^",2)     
            s CTLOCDateActiveTo=$p($g(^CTLOC(MKBTRowId)),"^",25)    //截止日期
            continue:(CTLOCDateActiveTo'="")&&(CTLOCDateActiveTo<+$h)
            d OutputRow111	
        }
	}

 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow111
    set Data=$lb(MKBTRowId,MKBTDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocListExecute ]
{
 	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocListExecute ]
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

}
