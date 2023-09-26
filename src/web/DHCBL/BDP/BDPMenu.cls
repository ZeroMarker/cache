/// 名称: 菜单定义
/// 描述: 菜单配置
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2018-03-22
Class web.DHCBL.BDP.BDPMenu Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：陈莹
/// CreatDate: 2018-03-22
/// Description：修改时打开的数据
/// Table：User.BDPMenu
/// Input：id
/// w ##class(web.DHCBL.BDP.BDPMenu).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str="" 
	s eobj = ##class(web.Entity.BDP.BDPMenu).%New()
	s eobj.ID = id
	s eobj.Code=$LISTGET($G(^User.BDPMenuD(id)),2)
	s eobj.Caption=$LISTGET($G(^User.BDPMenuD(id)),3)
	s eobj.LinkFuntionDR=$LISTGET($G(^User.BDPMenuD(id)),4)
	s eobj.LinkUrl=$LISTGET($G(^User.BDPMenuD(id)),5)
	s eobj.Image=$LISTGET($G(^User.BDPMenuD(id)),6)
	s eobj.Method=$LISTGET($G(^User.BDPMenuD(id)),7)
	s eobj.Sequence=$LISTGET($G(^User.BDPMenuD(id)),8)
	s eobj.ShortcutKey=$LISTGET($G(^User.BDPMenuD(id)),9)
	s eobj.ShowInNewWindow=$LISTGET($G(^User.BDPMenuD(id)),10)
	s eobj.ParentMenuDr=$LISTGET($G(^User.BDPMenuD(id)),11)
	s eobj.ValueExpression=$LISTGET($G(^User.BDPMenuD(id)),15)
	s ActiveFlag=$LISTGET($G(^User.BDPMenuD(id)),16)
	if (ActiveFlag'="") {
		s eobj.actMenuBDP=$select($p(ActiveFlag,"^",1)="1":"1", 1:"0")
		s eobj.actMenuAutItem=$select($p(ActiveFlag,"^",2)="1":"1", 1:"0")
		s eobj.actMenuAutData=$select($p(ActiveFlag,"^",3)="1":"1", 1:"0")
	}else {
		s eobj.actMenuBDP="1"
		s eobj.actMenuAutItem="1"
		s eobj.actMenuAutData="1"
	}
	s eobj.CompName=$LISTGET($G(^User.BDPMenuD(id)),17)
	s eobj.ProductLineDr=$LISTGET($G(^User.BDPMenuD(id)),18)
	s eobj.IsMKBMenu=$LISTGET($G(^User.BDPMenuD(id)),21)
	
	//s str = eobj.JsonS() 
	s str="{Caption:'"_eobj.Caption_"',Code:'"_eobj.Code_"',CompName:'"_eobj.CompName_"',ID:'"_eobj.ID_"',Image:'"_eobj.Image_"',LinkFuntionDR:'"_eobj.LinkFuntionDR_"',LinkUrl:'"_eobj.LinkUrl_"',Method:'"_eobj.Method_"',ParentMenuDr:'"_eobj.ParentMenuDr_"',ProductLineDr:'"_eobj.ProductLineDr_"',Sequence:'"_eobj.Sequence_"',ShortcutKey:'"_eobj.ShortcutKey_"',ShowInNewWindow:'"_eobj.ShowInNewWindow_"',ValueExpression:'"_eobj.ValueExpression_"',actMenuAutData:'"_eobj.actMenuAutData_"',actMenuAutItem:'"_eobj.actMenuAutItem_"',actMenuBDP:'"_eobj.actMenuBDP_"',IsMKBMenu:'"_eobj.IsMKBMenu_"'}"
	d eobj.%Close()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：陈莹
/// CreatDate:2018-03-22
/// Description：数据重复验证方法，由js调用
/// Table：User.BDPMenu
/// Input：id, code
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String) As %String
{
	s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s flag="",flagc=""
	s:code'="" flagc=$d(^User.BDPMenuI("UniqueCodeIndex",code))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s:code'="" idc=$o(^User.BDPMenuI("UniqueCodeIndex",code,0))
		if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator：陈莹
/// CreatDate: 2018-03-22
/// Description：保存修改
/// Table：User.BDPMenu
/// Input：web.Entity.BDP.BDPMenu 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.BDP.BDPMenu).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.BDP.BDPMenu, tempImage As %String = "") As %String
{
	s result="",flag=""
	if $IsObject(eobj)
	{
		s:eobj.IsMKBMenu="" eobj.IsMKBMenu="N"   //是否属于医学知识库 add@20180402
		if (eobj.Caption'="")
		{
			s eobj.FirstPYCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCONVERT(eobj.Caption,"U")) //首拼
			s eobj.WholePYCODE=##class(web.DHCBL.BDP.FunLib).GetCNCODE($ZCONVERT(eobj.Caption,"U"),3,"")  //全拼
		}
		s eobj.ValueExpression=$tr(eobj.ValueExpression,"”","""")  ///值表达里有双引号 ，为影响JSONS方法，OpenDataJSON先换成中文的引号，所以此处需要转换回来。
		s flag=..FormValidate(eobj.ID,eobj.Code)  //调用重复验证
		
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			s:eobj.Sequence'="" eobj.Sequence=$ZCONVERT(eobj.Sequence,"U")
			if (eobj.Image="")
			{ 
				s eobj.Image=tempImage 
				if (eobj.Image["../scripts/bdp/Framework/BdpIconsLib/")
				{
					s eobj.Image=$p(eobj.Image,"../scripts/bdp/Framework/BdpIconsLib/",2)
				}
			}
			else
			{ 
				s tempImage=""
			}

			if (eobj.ID="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.BDPMenu).%New()
			}
			else                     //如果RowId已赋值则修改
			{
				s obj=##class(User.BDPMenu).%OpenId(eobj.ID)
				s bobj=##class(web.Entity.BDP.BDPMenu).%New()
				s bobj.ID=eobj.ID
				s bobj.Code = obj.Code           
				s bobj.Caption = obj.Caption          
				s:obj.LinkFuntionDR'="" bobj.LinkFuntionDR=obj.LinkFuntionDR.%Id()
				s bobj.LinkUrl =  obj.LinkUrl
				s bobj.Image = obj.Image
				s bobj.Method = obj.Method
				s bobj.Sequence = obj.Sequence
				s bobj.ShortcutKey = obj.ShortcutKey
				s bobj.ShowInNewWindow = obj.ShowInNewWindow
				s:obj.ParentMenuDr'="" bobj.ParentMenuDr=obj.ParentMenuDr.%Id()
				s:obj.ProductLineDr'="" bobj.ProductLineDr=obj.ProductLineDr.%Id()
				s bobj.ValueExpression = obj.ValueExpression
				s bobj.CompName=obj.CompName
				s bobj.IsMKBMenu=obj.IsMKBMenu
				s bobj.FirstPYCODE=obj.FirstPYCODE
				s bobj.WholePYCODE=obj.WholePYCODE
				
				if (obj.ActiveFlag)
				{
					s bobj.actMenuBDP = $p(obj.ActiveFlag,"^",1)
					if (bobj.actMenuBDP="") s bobj.actMenuBDP ="0"
					if (bobj.actMenuBDP="Y") s bobj.actMenuBDP ="1"
					s bobj.actMenuAutItem=$p(obj.ActiveFlag,"^",2)
					if (bobj.actMenuAutItem="") s bobj.actMenuAutItem="0"
					if (bobj.actMenuAutItem="Y") s bobj.actMenuAutItem ="1"
					s bobj.actMenuAutData=$p(obj.ActiveFlag,"^",3)
					if (bobj.actMenuAutData="") s bobj.actMenuAutData="0"
					if (bobj.actMenuAutData="Y") s bobj.actMenuAutData ="1"
				}
				if (obj.Code'=eobj.Code)
				{
					s myobj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCBL.MKB.MKBTermBase||IsMKBBaseCreate")
					if $IsObject(myobj)
					{
						s flag=##class(web.DHCBL.MKB.MKBTermBase).IsMKBBaseCreate(eobj.ID)
						if flag=1
						{
							q "{success:'false',errorinfo:'该菜单是自动生成的，不允许修改代码！'}"
						}
					}
				}
			}  
			Ts
			s obj.Code = eobj.Code          //修改代码
			s obj.Caption = eobj.Caption          //修改描述
			d obj.LinkFuntionDRSetObjectId(eobj.LinkFuntionDR)
			s obj.LinkUrl = eobj.LinkUrl

			s obj.Image =eobj.Image
			s obj.Method = eobj.Method
			s obj.Sequence = eobj.Sequence
			s obj.ShortcutKey = eobj.ShortcutKey
			s obj.ShowInNewWindow = eobj.ShowInNewWindow
			d obj.ParentMenuDrSetObjectId(eobj.ParentMenuDr)
			d obj.ProductLineDrSetObjectId(eobj.ProductLineDr)
			s obj.UpdateDate = +$p($h,",",1)
			s obj.UpdateTime = +$p($h,",",2)
			d obj.UpdateUserSetObjectId($Get(%session.Data("LOGON.USERID")))
			s obj.ValueExpression = eobj.ValueExpression
			s obj.CompName=eobj.CompName
			s obj.IsMKBMenu=eobj.IsMKBMenu
			s obj.FirstPYCODE=eobj.FirstPYCODE
			s obj.WholePYCODE=eobj.WholePYCODE
				
			s:eobj.actMenuBDP="" eobj.actMenuBDP="0"
			s:eobj.actMenuAutItem="" eobj.actMenuAutItem="0"
			s:eobj.actMenuAutData="" eobj.actMenuAutData="0"
			s:eobj.actMenuBDP="Y" eobj.actMenuBDP="1"
			s:eobj.actMenuAutItem="Y" eobj.actMenuAutItem="1"
			s:eobj.actMenuAutData="Y" eobj.actMenuAutData="1"
			s obj.ActiveFlag = eobj.actMenuBDP_"^"_eobj.actMenuAutItem_"^"_eobj.actMenuAutData
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"  //返回RowId
				d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_Menu","User.BDPMenu","菜单定义",id,eobj.Caption,"A",eobj)
				d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_Menu","User.BDPMenu","菜单定义",eobj.ID,eobj.Caption,"U",eobj,bobj)
				
				if eobj.ID'=""
				{
					s myobj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCBL.MKB.MKBTermBase||SyncMKBBase")
					if $IsObject(myobj)
					{
						d ##class(web.DHCBL.MKB.MKBTermBase).SyncMKBBase(eobj.Code,eobj.Caption,eobj.Sequence)
					}
				}
			}
			else
			{
				Trollback
				s result ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorText(sc)_"'}"
			}
		}    
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator：陈莹
/// CreatDate: 2018-03-22
/// Description：菜单定义
/// Table：User.BDPMenu
/// d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPMenu","GetList","","","","")
Query GetList(rowid As %String, myCode As %String, myCaption As %String, myParMenu As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Caption:%String,LinkFuntionDR:%String,LinkUrl:%String,Image:%String,Method:%String,Sequence:%String,ShortcutKey:%String,ShowInNewWindow:%String,ParentMenuDr:%String,UpdateDate:%String,UpdateTime:%String,UpdateUser:%String,ValueExpression:%String,CompName:%String,IsMKBMenu:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, myCode As %String, myCaption As %String, myParMenu As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
 
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		s Code=$LISTGET($G(^User.BDPMenuD(ID)),2)
		s Caption=$LISTGET($G(^User.BDPMenuD(ID)),3)
		s LinkFuntionDR=$LISTGET($G(^User.BDPMenuD(ID)),4)
		s:LinkFuntionDR'="" LinkFuntionDR=$LISTGET($G(^User.BDPExecutablesD(LinkFuntionDR)),3) //获取功能名称
		s LinkUrl=$LISTGET($G(^User.BDPMenuD(ID)),5)
		s Image=$LISTGET($G(^User.BDPMenuD(ID)),6)
		s Method=$LISTGET($G(^User.BDPMenuD(ID)),7)
		s Sequence=$LISTGET($G(^User.BDPMenuD(ID)),8)
		s ShortcutKey=$LISTGET($G(^User.BDPMenuD(ID)),9)
		s ShowInNewWindow=$LISTGET($G(^User.BDPMenuD(ID)),10)
		s ParentMenuDr=$LISTGET($G(^User.BDPMenuD(ID)),11)
		s:ParentMenuDr'="" ParentMenuDr=$LISTGET($G(^User.BDPMenuD(ParentMenuDr)),3) //获取菜单描述
		s UpdateDate=$LISTGET($G(^User.BDPMenuD(ID)),12)
		s UpdateTime=$LISTGET($G(^User.BDPMenuD(ID)),13)
		s UpdateUser=$LISTGET($G(^User.BDPMenuD(ID)),14)
		s:UpdateUser'="" UpdateUser=$p($g(^SSU("SSUSR",UpdateUser)),"^",1) //获取用户名
		s ValueExpression=$LISTGET($G(^User.BDPMenuD(ID)),15) 
		s CompName=$LISTGET($G(^User.BDPMenuD(ID)),17)
		s IsMKBMenu=$LISTGET($G(^User.BDPMenuD(ID)),21)
		s:UpdateDate'="" UpdateDate=$zd(UpdateDate,1) //转换日期格式
		s:UpdateTime'="" UpdateTime=$zt(UpdateTime,1) //转换时间格式
		d OutputRow
	}
	else
	{
		s:myCode'="" myCode=$$ALPHAUP^SSUTIL4(myCode) //转换成大写
		s:myCaption'="" myCaption=$$ALPHAUP^SSUTIL4(myCaption) //转换成大写
		s:myParMenu'="" myParMenu=$$ALPHAUP^SSUTIL4(myParMenu) //转换成大写
		s ID=0
		for
		{
			s ID=$o(^User.BDPMenuD(ID)) q:ID=""
			s Code=$LISTGET($G(^User.BDPMenuD(ID)),2)
			s Caption=$LISTGET($G(^User.BDPMenuD(ID)),3)
			s LinkFuntionDR=$LISTGET($G(^User.BDPMenuD(ID)),4)
			s:LinkFuntionDR'="" LinkFuntionDR=$LISTGET($G(^User.BDPExecutablesD(LinkFuntionDR)),3) //获取功能名称
			s LinkUrl=$LISTGET($G(^User.BDPMenuD(ID)),5)
			s Image=$LISTGET($G(^User.BDPMenuD(ID)),6)
			s Method=$LISTGET($G(^User.BDPMenuD(ID)),7)
			s Sequence=$LISTGET($G(^User.BDPMenuD(ID)),8)
			s ShortcutKey=$LISTGET($G(^User.BDPMenuD(ID)),9)
			s ShowInNewWindow=$LISTGET($G(^User.BDPMenuD(ID)),10)
			s ParentMenuDr=$LISTGET($G(^User.BDPMenuD(ID)),11)
			s:ParentMenuDr'="" ParentMenuDr=$LISTGET($G(^User.BDPMenuD(ParentMenuDr)),3) //获取菜单描述
			s UpdateDate=$LISTGET($G(^User.BDPMenuD(ID)),12)
			s UpdateTime=$LISTGET($G(^User.BDPMenuD(ID)),13)
			s UpdateUser=$LISTGET($G(^User.BDPMenuD(ID)),14)
			s:UpdateUser'="" UpdateUser=$p($g(^SSU("SSUSR",UpdateUser)),"^",1) //获取用户名
			s ValueExpression=$LISTGET($G(^User.BDPMenuD(ID)),15)
			s CompName=$LISTGET($G(^User.BDPMenuD(ID)),17) 
			s IsMKBMenu=$LISTGET($G(^User.BDPMenuD(ID)),21)
			s:UpdateDate'="" UpdateDate=$zd(UpdateDate,1) //转换日期格式
			s:UpdateTime'="" UpdateTime=$zt(UpdateTime,1) //转换时间格式
			i ($$ALPHAUP^SSUTIL4(Code)[myCode)&($$ALPHAUP^SSUTIL4(Caption)[myCaption)&($$ALPHAUP^SSUTIL4(ParentMenuDr)[myParMenu)
			{
				d OutputRow
			}
		}
	}
  
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,Code,Caption,LinkFuntionDR,LinkUrl,Image,Method,Sequence,ShortcutKey,ShowInNewWindow,ParentMenuDr,UpdateDate,UpdateTime,UpdateUser,ValueExpression,CompName,IsMKBMenu)
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

/// Creator：陈莹
/// CreatDate:2018-03-22
/// Description：根据ID删除
/// Table：User.BDPMenu
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result = "",flag=""
	s flag=$d(^User.BDPMenuI("ParMenuIdx",id)) //判断该菜单是否被引用
	if (flag>0)
	{
		s result = "{success:'false',info:'该数据下已有子节点,禁止删除！'}"   
	}
	else
	{
		s eobj = ##class(web.Entity.BDP.BDPMenu).%New()
		s eobj.ID = id
		s eobj.Code=$LISTGET($G(^User.BDPMenuD(id)),2)
		s eobj.Caption=$LISTGET($G(^User.BDPMenuD(id)),3)
		s eobj.LinkFuntionDR=$LISTGET($G(^User.BDPMenuD(id)),4)
		s eobj.LinkUrl=$LISTGET($G(^User.BDPMenuD(id)),5)
		s eobj.Image=$LISTGET($G(^User.BDPMenuD(id)),6)
		s eobj.Method=$LISTGET($G(^User.BDPMenuD(id)),7)
		s eobj.Sequence=$LISTGET($G(^User.BDPMenuD(id)),8)
		s eobj.ShortcutKey=$LISTGET($G(^User.BDPMenuD(id)),9)
		s eobj.ShowInNewWindow=$LISTGET($G(^User.BDPMenuD(id)),10)
		s eobj.ParentMenuDr=$LISTGET($G(^User.BDPMenuD(id)),11)
		s eobj.ValueExpression=$LISTGET($G(^User.BDPMenuD(id)),15)
		s eobj.CompName=$LISTGET($G(^User.BDPMenuD(id)),17)
		s eobj.ProductLineDr=$LISTGET($G(^User.BDPMenuD(id)),18)
		s eobj.IsMKBMenu=$LISTGET($G(^User.BDPMenuD(id)),21)

		s sc=##class(User.BDPMenu).%DeleteId(id)
		if $$$ISOK(sc)
		{
			s result = "{success:'true',info:'删除成功！'}" 
			//保存日志
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_Menu","User.BDPMenu","菜单定义",id,eobj.Caption,"D",eobj)
			d eobj.%Close()
		}
		else 
		{
			s result ="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorText(sc)_"'}"
		}
	}
	q result
}

/// 添加时获取显示顺序
/// 入参：父菜单id
/// w ##class(web.DHCBL.BDP.BDPMenu).GetSequence("1")
ClassMethod GetSequence(id As %String) As %String
{
	if (id="TreeRoot") s id=-100000000000000
	if (id="") s id=-100000000000000
	s mySMRowID=0
	s mySMSeq=0
	k a

	//生成菜单索引数组
	s mySMSeq=0
	s n=0
	for {
		s mySMSeq=$o(^User.BDPMenuI("ParSeqIdx",id,mySMSeq))
		q:(mySMSeq="")
		s n=n+1
		s a(n)= $p(mySMSeq," ",2)
	}
	set left=1,right=n
	d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序
	s mySMRowID=0
	s n=0
	s mySMSeq=0
	for {
		s n=$o(a(n))
		q:(n="")
		s mySMSeq=$g(a(n))
	}
	q mySMSeq+1
}

/// Description：保存拖拽的内容 2016/9/21     ---HISUI
/// Table：User.DHCSymptomLev
/// Input：id, parentid,orderstr
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.KB.DHCSymptomCon).SaveData()
ClassMethod DragNode(id, parentid, orderstr) As %String
{
	s result=""
	q:(id="") "{success:'false',errorinfo:'没有拖拽的节点'}"
	s:parentid="TreeRoot" parentid=""

	s obj=##class(User.BDPMenu).%OpenId(id) 
	d:parentid="" obj.ParentMenuDrSetObjectId("")
	d:parentid'="" obj.ParentMenuDrSetObjectId(parentid)

	Ts  
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId

		s orderLen=$Length(orderstr,"^")
		for i=1:1:orderLen   
		{      
			s rowid=$p(orderstr,"^",i)
			s obj=##class(User.BDPMenu).%OpenId(rowid)
			s obj.Sequence =i
			s sc=obj.%Save()
			d obj.%Close()           
		}
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
	}

	q result
}

/// Creator：陈莹   ---HISUI
/// CreatDate: 2018-03-22
/// Description：修改时打开的数据
/// Table：User.BDPMenu
/// Input：id
/// w ##class(web.DHCBL.BDP.BDPMenu).OpenDataJSON("1")
ClassMethod OpenDataJSON(id As %String) As %String
{
	s str="" 
	s eobj = ##class(web.Entity.BDP.BDPMenu).%New()
	s eobj.ID = id
	s eobj.Code=$LISTGET($G(^User.BDPMenuD(id)),2)
	s eobj.Caption=$LISTGET($G(^User.BDPMenuD(id)),3)
	s eobj.LinkFuntionDR=$LISTGET($G(^User.BDPMenuD(id)),4)
	s eobj.LinkUrl=$LISTGET($G(^User.BDPMenuD(id)),5)
	s eobj.Image=$LISTGET($G(^User.BDPMenuD(id)),6)
	s eobj.Method=$LISTGET($G(^User.BDPMenuD(id)),7)
	s eobj.Sequence=$LISTGET($G(^User.BDPMenuD(id)),8)
	s eobj.ShortcutKey=$LISTGET($G(^User.BDPMenuD(id)),9)
	s eobj.ShowInNewWindow=$LISTGET($G(^User.BDPMenuD(id)),10)
	s eobj.ParentMenuDr=$LISTGET($G(^User.BDPMenuD(id)),11)
	s eobj.ValueExpression=$LISTGET($G(^User.BDPMenuD(id)),15)
	s eobj.ValueExpression=$tr(eobj.ValueExpression,"""","”")  ///值表达里有双引号 ，为影响JSONS方法，先换成中文的引号
	
	s ActiveFlag=$LISTGET($G(^User.BDPMenuD(id)),16)
	if (ActiveFlag'="") {
		s eobj.actMenuBDP=$p(ActiveFlag,"^",1)
		s eobj.actMenuAutItem=$p(ActiveFlag,"^",2)
		s eobj.actMenuAutData=$p(ActiveFlag,"^",3)

		s:eobj.actMenuBDP="1" eobj.actMenuBDP="Y"
		s:eobj.actMenuAutItem="1" eobj.actMenuAutItem="Y"
		s:eobj.actMenuAutData="1" eobj.actMenuAutData="Y"
		s:eobj.actMenuBDP="0" eobj.actMenuBDP="N"    //激活基础数据维护菜单
		s:eobj.actMenuAutItem="0" eobj.actMenuAutItem="N"    //激活功能元素授权菜单
		s:eobj.actMenuAutData="0" eobj.actMenuAutData="N"     //激活基础数据授权菜单
	}else {
		s eobj.actMenuBDP="Y"
		s eobj.actMenuAutItem="Y"
		s eobj.actMenuAutData="Y"
	}
	s eobj.CompName=$LISTGET($G(^User.BDPMenuD(id)),17)
	s eobj.ProductLineDr=$LISTGET($G(^User.BDPMenuD(id)),18)
	s eobj.IsMKBMenu=$LISTGET($G(^User.BDPMenuD(id)),21)
	s:eobj.IsMKBMenu="" eobj.IsMKBMenu="N"
	
	s str = eobj.JsonS() 
	d eobj.%Close()
	q str
}

/// Creator：陈莹   ---HISUI
/// CreatDate: 2018-03-13
/// Description：获取某个父节点下的所有子节点 用^连接，并按照顺序排列  
/// Table：User.BDPMenu
/// Input：父节点
/// Return：所有子节点 用^连接
/// w ##class(web.DHCBL.BDP.BDPMenu).GetChildOrderedIDStr("")
ClassMethod GetChildOrderedIDStr(LastLevel As %String) As %String
{
	n (LastLevel)
	s IDStr=""
	if (LastLevel="") s LastLevel=-100000000000000
	
	s myJsonStr=""
	s myRowID=0
	
	s mySeq=0
	k myArray
	k a
	//生成菜单索引数组
	s mySeq=0
	s n=0
	for {
		s mySeq=$o(^User.BDPMenuI("ParSeqIdx",LastLevel,mySeq)) q:(mySeq="")
		s n=n+1
		s a(n)= $p(mySeq," ",2)
	}
	set left=1,right=n
	d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序

	s n=0
	s mySeq=0
	s myCount=0
	for {
		s n=$o(a(n)) q:(n="")
		s mySeq=$g(a(n))
		s myRowID=0
		for {
			s myRowID=$o(^User.BDPMenuI("ParSeqIdx",LastLevel," "_mySeq,myRowID)) q:(myRowID="")
			s myCount=myCount+1
			s myArray(myCount)=myRowID
		}
	}
	//输出菜单JSON串
	s myRowID=0
	s mySeq=0
	s childStr=""
	for {
		s mySeq=$o(myArray(mySeq)) q:(mySeq="")
		s myRowID=$g(myArray(mySeq))
		
		s childStr=..GetChildOrderedIDStr(myRowID)
		if childStr'="" s childStr=myRowID_"^"_childStr
		if childStr="" s childStr=myRowID
		
		if IDStr="" s IDStr=childStr
		else  s IDStr=IDStr_"^"_childStr
	}
	q IDStr
}

/// Creator：陈莹   ---HISUI
/// CreatDate: 2018-03-13
/// Description：查询页面数据  
/// Table：User.BDPMenu
/// Input：id(父节点 )
/// Return：treegrid格式数据串
/// w ##class(web.DHCBL.BDP.BDPMenu).GetJsonList("",1)
ClassMethod GetJsonList(id As %String, MKBFlag As %String) As %String
{
	n (id,MKBFlag)
	s parentcatdr=id
	s IDStr=""
	if (parentcatdr="") s parentcatdr=-100000000000000
	
	s myJsonStr=""
	s myRowID=0
	
	s mySeq=0
	k myArray
	k a
	//生成索引数组
	s mySeq=0
	s n=0
	for {
		s mySeq=$o(^User.BDPMenuI("ParSeqIdx",parentcatdr,mySeq)) q:(mySeq="")
		s n=n+1
		s a(n)= $p(mySeq," ",2)
	}
	set left=1,right=n
	d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序

	s n=0
	s mySeq=0
	s myCount=0
	for {
		s n=$o(a(n)) q:(n="")
		s mySeq=$g(a(n))
		s myRowID=0
		for {
			s myRowID=$o(^User.BDPMenuI("ParSeqIdx",parentcatdr," "_mySeq,myRowID)) q:(myRowID="")
			s myCount=myCount+1
			s myArray(myCount)=myRowID
		}
	}
	//输出菜单JSON串
	s myRowID=0
	s mySeq=0
	s childStr=""
	w "["
	s count=0
	for 
	{
		s mySeq=$o(myArray(mySeq)) q:(mySeq="")
		s myRowID=$g(myArray(mySeq))
		s IsMKBMenu=$LISTGET($G(^User.BDPMenuD(myRowID)),21)
		s:IsMKBMenu="" IsMKBMenu="N"
		if MKBFlag=1
		{
			continue:IsMKBMenu="N"
		}
		
		s count=count+1
		if count>1 w ","
		s Code=$LISTGET($G(^User.BDPMenuD(myRowID)),2)   //代码
		s Caption=$LISTGET($G(^User.BDPMenuD(myRowID)),3)   //描述
		s LinkUrl=$LISTGET($G(^User.BDPMenuD(myRowID)),5)   //url解析地址
		s LinkFuntionDR=$LISTGET($G(^User.BDPMenuD(myRowID)),4)   //功能
		if LinkFuntionDR'="" s LinkFuntionDR=$LISTGET($G(^User.BDPExecutablesD(LinkFuntionDR)),3)   //功能描述
		
		s CompName=$LISTGET($G(^User.BDPMenuD(myRowID)),17)   //组件名称
		
		s ParentMenuDr=$LISTGET($G(^User.BDPMenuD(myRowID)),11)    //父菜单
		if ParentMenuDr'="" s ParentMenuDr=$LISTGET($G(^User.BDPMenuD(ParentMenuDr)),3)   //父菜单描述
		s Sequence=$LISTGET($G(^User.BDPMenuD(myRowID)),8)  //显示顺序
		
		s Image=$LISTGET($G(^User.BDPMenuD(myRowID)),6)   //图标
		s ProductLineDr=$LISTGET($G(^User.BDPMenuD(myRowID)),18)   //关联产品线
		if ProductLineDr'="" s ProductLineDr=$LISTGET($G(^User.DHCProductLineD(ProductLineDr)),3)   //关联产品线描述	
		s Method=$LISTGET($G(^User.BDPMenuD(myRowID)),7)   //服务器端类方法
		s ShortcutKey=$LISTGET($G(^User.BDPMenuD(myRowID)),9)   //快捷键
		s ShowInNewWindow=$LISTGET($G(^User.BDPMenuD(myRowID)),10)  //弹出窗口或增加tab的方式
		
		s ValueExpression=$LISTGET($G(^User.BDPMenuD(myRowID)),15)   //值表达式
		s ValueExpression=$tr(ValueExpression,"""","”")  ///值表达里有双引号 ，为影响JSONS方法，先换成中文的引号
		s ActiveFlag=$LISTGET($G(^User.BDPMenuD(myRowID)),16)
		
		if (ActiveFlag'="") {
			s actMenuBDP=$p(ActiveFlag,"^",1)
			s actMenuAutItem=$p(ActiveFlag,"^",2)
			s actMenuAutData=$p(ActiveFlag,"^",3)
			s:actMenuBDP="1" actMenuBDP="Y"    //激活基础数据维护菜单
			s:actMenuAutItem="1" actMenuAutItem="Y"    //激活功能元素授权菜单
			s:actMenuAutData="1" actMenuAutData="Y"     //激活基础数据授权菜单
			s:actMenuBDP="0" actMenuBDP="N"    //激活基础数据维护菜单
			s:actMenuAutItem="0" actMenuAutItem="N"    //激活功能元素授权菜单
			s:actMenuAutData="0" actMenuAutData="N"     //激活基础数据授权菜单
		}else {
			s actMenuBDP="Y"
			s actMenuAutItem="Y"
			s actMenuAutData="Y"
		}
		
		w "{""id"":"""_myRowID_""""
		w ",""ID"":"""_myRowID_""",""Code"":"""_Code_""",""Caption"":"""_Caption_""",""LinkUrl"":"""_LinkUrl_""",""LinkFuntionDR"":"""_LinkFuntionDR_""",""CompName"":"""_CompName_""""
		w ",""ParentMenuDr"":"""_ParentMenuDr_""",""Sequence"":"""_Sequence_""",""Image"":"""_Image_""",""ProductLineDr"":"""_ProductLineDr_""",""Method"":"""_Method_""",""ShortcutKey"":"""_ShortcutKey_""""
		w ",""ShowInNewWindow"":"""_ShowInNewWindow_""",""ValueExpression"":"""_ValueExpression_""",""ActiveFlag"":"""_ActiveFlag_""",""actMenuBDP"":"""_actMenuBDP_""",""actMenuAutItem"":"""_actMenuAutItem_""",""actMenuAutData"":"""_actMenuAutData_""",""IsMKBMenu"":"""_IsMKBMenu
		w """"
		if Image'="" w ",""icon"":"""_"../scripts/bdp/Framework/BdpIconsLib/"_Image_""""
		
		
		s childStr=..GetChildOrderedIDStr(myRowID)
		if childStr'=""
		{
			w ",""state"":""open"""   //closed节点不展开,open节点展开
			w ",""children"":"
			w ..GetJsonList(myRowID,MKBFlag)
		}
		else
		{
			w ",""state"":""open"""
		}
		w "}"
		
	}
	w "]"
	q ""
}

/// Creator：陈莹   ---HISUI
/// CreatDate: 2018-03-13
/// Description：查询菜单数据   下拉框
/// Table：User.BDPMenu
/// Input：父节点 
/// Return：treegrid格式数据串
/// w ##class(web.DHCBL.BDP.BDPMenu).GetJsonDataForCmb("")
ClassMethod GetJsonDataForCmb(parentcatdr As %String, MKBFlag As %String) As %String
{
	
	n (parentcatdr,MKBFlag)
	s IDStr=""
	if (parentcatdr="") s parentcatdr=-100000000000000
	
	s myJsonStr=""
	s myRowID=0
	
	s mySeq=0
	k myArray
	k a
	//生成索引数组
	s mySeq=0
	s n=0
	for {
		s mySeq=$o(^User.BDPMenuI("ParSeqIdx",parentcatdr,mySeq)) q:(mySeq="")
		s n=n+1
		s a(n)= $p(mySeq," ",2)
	}
	set left=1,right=n
	d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序

	s n=0
	s mySeq=0
	s myCount=0
	for {
		s n=$o(a(n)) q:(n="")
		s mySeq=$g(a(n))
		s myRowID=0
		for {
			s myRowID=$o(^User.BDPMenuI("ParSeqIdx",parentcatdr," "_mySeq,myRowID)) q:(myRowID="")
			s myCount=myCount+1
			s myArray(myCount)=myRowID
		}
	}
	//输出菜单JSON串
	s myRowID=0
	s mySeq=0
	s childStr=""
	w "["
	s count=0
	for {
		s mySeq=$o(myArray(mySeq)) q:(mySeq="")
		s myRowID=$g(myArray(mySeq))
		
		s IsMKBMenu=$LISTGET($G(^User.BDPMenuD(myRowID)),21)
		s:IsMKBMenu="" IsMKBMenu="N"
		if MKBFlag=1
		{
			continue:IsMKBMenu="N"
		}
		s count=count+1
		if count>1 w ","
		s Code=$LISTGET($G(^User.BDPMenuD(myRowID)),2)   //代码
		s Caption=$LISTGET($G(^User.BDPMenuD(myRowID)),3)   //描述
		
		w "{""id"":"""_myRowID_""",""text"":"""_Caption_""""
		//s Image=$LISTGET($G(^User.BDPMenuD(myRowID)),6)   //图标
		//if Image'="" w ",""iconCls"":"""_"../scripts/bdp/Framework/BdpIconsLib/"_Image_""""
		w ",""attributes"":{""SPCode"":"""_##class(web.DHCBL.BDP.FunLib).GetPYCODE(Caption)_"""}"
		s ActiveFlag=$LISTGET($G(^User.BDPMenuD(myRowID)),16)
		s actMenuBDP=""
		if (ActiveFlag'="") {
			s actMenuBDP=$p(ActiveFlag,"^",1)
			s:actMenuBDP="1" actMenuBDP="Y"    //激活基础数据维护菜单
		}else {
			s actMenuBDP="Y"	
		}
		if (actMenuBDP="Y")
		{
			w ",""checked"":true"
		}
		else
		{
			
			w ",""checked"":false"
		}	
		
		s childStr=..GetChildOrderedIDStr(myRowID)
		if childStr'=""
		{
			w ",""state"":""open"""
			w ",""children"":"
			w ..GetJsonDataForCmb(myRowID,MKBFlag)	
		}
		else
		{
			w ",""state"":""open"""
		}
		w "}"
		
	}
	w "]"
	q ""
}

/// Creator：陈莹   ---HISUI
/// CreatDate: 2018-03-28
/// Description：保存菜单批量激活隐藏状态，每点击一次
/// Table：User.BDPMenu
/// Input：父节点 
/// Return：treegrid格式数据串
/// w ##class(web.DHCBL.BDP.BDPMenu).SaveActiveTree("")
ClassMethod SaveActiveTree(id As %String, checked) As %String
{
	n (id,checked,%session)
	q:id="" "{success:'false',info:'保存失败'}"
	s result=""	
	s obj=##class(User.BDPMenu).%OpenId(id)
	
	s bobj=##class(web.Entity.BDP.BDPMenu).%New()
	s bobj.ID=id
	s bobj.Code = obj.Code           
	s bobj.Caption = obj.Caption          
	s:obj.LinkFuntionDR'="" bobj.LinkFuntionDR=obj.LinkFuntionDR.%Id()
	s bobj.LinkUrl =  obj.LinkUrl
	s bobj.Image = obj.Image
	s bobj.Method = obj.Method
	s bobj.Sequence = obj.Sequence
	s bobj.ShortcutKey = obj.ShortcutKey
	s bobj.ShowInNewWindow = obj.ShowInNewWindow
	s:obj.ParentMenuDr'="" bobj.ParentMenuDr=obj.ParentMenuDr.%Id()
	s:obj.ProductLineDr'="" bobj.ProductLineDr=obj.ProductLineDr.%Id()
	s bobj.ValueExpression = obj.ValueExpression
	s bobj.CompName=obj.CompName
	if (obj.ActiveFlag'="")
	{
		s bobj.ActiveFlag=obj.ActiveFlag
		s bobj.actMenuBDP = $p(obj.ActiveFlag,"^",1)
		s bobj.actMenuAutItem=$p(obj.ActiveFlag,"^",2)
		s bobj.actMenuAutData=$p(obj.ActiveFlag,"^",3)
	}
	
	s eobj=##class(web.Entity.BDP.BDPMenu).%New()
	s eobj.ID=id
	s eobj.Code = obj.Code           
	s eobj.Caption = obj.Caption          
	s:obj.LinkFuntionDR'="" eobj.LinkFuntionDR=obj.LinkFuntionDR.%Id()
	s eobj.LinkUrl =  obj.LinkUrl
	s eobj.Image = obj.Image
	s eobj.Method = obj.Method
	s eobj.Sequence = obj.Sequence
	s eobj.ShortcutKey = obj.ShortcutKey
	s eobj.ShowInNewWindow = obj.ShowInNewWindow
	s:obj.ParentMenuDr'="" eobj.ParentMenuDr=obj.ParentMenuDr.%Id()
	s:obj.ProductLineDr'="" eobj.ProductLineDr=obj.ProductLineDr.%Id()
	s eobj.ValueExpression = obj.ValueExpression
	s eobj.CompName=obj.CompName
	
	
	s ActiveFlag=obj.ActiveFlag
	if (checked="true") s $p(ActiveFlag,"^",1)="1"
	if (checked="false") s $p(ActiveFlag,"^",1)="0"
	if (checked="1") s $p(ActiveFlag,"^",1)="1"
	if (checked="0") s $p(ActiveFlag,"^",1)="0"
	
	s eobj.actMenuBDP = $p(ActiveFlag,"^",1)
	s eobj.actMenuAutItem=$p(ActiveFlag,"^",2)
	s eobj.actMenuAutData=$p(ActiveFlag,"^",3)
	s eobj.ActiveFlag =ActiveFlag
	s obj.ActiveFlag =ActiveFlag		
	TS      
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){
		Tc
		s result = "{""success"":""true""}"  //返回RowId
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_Menu","User.BDPMenu","菜单定义",eobj.ID,eobj.Caption,"U",eobj,bobj)
	} else {
		Trollback
		s result = "{""success"":""false"",""errorinfo"":"""_$zconvert(sc,"O","JS")_"""}"  //返回错误信息
	}
	q result
}

/// d ##class(web.DHCBL.BDP.BDPMenu).batchUpdate()
ClassMethod batchUpdate() As %String
{
	s ID=0
	for
	{
		s ID=$o(^User.BDPMenuD(ID)) q:ID=""
		s obj=##class(User.BDPMenu).%OpenId(ID) 
		s obj.FirstPYCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCONVERT(obj.Caption,"U")) //首拼
	    s obj.WholePYCODE=##class(web.DHCBL.BDP.FunLib).GetCNCODE($ZCONVERT(obj.Caption,"U"),3,"")  //全拼
	
		s IsMKBMenu=$LISTGET($G(^User.BDPMenuD(ID)),19)
		if IsMKBMenu="Y" 
		{
			s obj.IsMKBMenu=IsMKBMenu
		}	
		else
		{
			s obj.IsMKBMenu="N"
		}	
		s sc=obj.%Save()
		d obj.%Close()
	}
	q "over"
}

/// Creator:2015-12-25 by gss
/// Function: 根据code返回id
/// Debugs: w ##class(web.DHCBL.BDP.BDPMenu).GetID("dhc.bdp.cdssV2.mkb.mtm")
ClassMethod GetID(code As %String) As %String
{
    s ID=""
    if (code'="") {
        s code=" "_$ZCONVERT(code,"U") //转换成大写
        s ID=$o(^User.BDPMenuI("UniqueCodeIndex",code,0))
    }
    q ID
}

}
