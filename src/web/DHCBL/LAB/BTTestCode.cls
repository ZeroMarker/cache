/// 名称:标准版检验-检验项目
/// 描述：检验项目 增删改查 方法
/// 编写者:基础数据平台组 - 杨帆
/// 编写日期: 2020-03-10
Class web.DHCBL.LAB.BTTestCode Extends %RegisteredObject
{

/// Creator：杨帆
/// CreatDate: 2020-03-10
/// Description：查询检验项目表的内容
/// Table：dbo.BT_TestCode
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTTestCode","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, hospitaldr As %String, scodedr As %String) As %Query(ROWSPEC = "RowID:%String,Code:%String,CName:%String,HospitalDR:%String,SCode,Sequence,Active")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospitaldr As %String, scodedr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowID = rowid
		s Code= $lg($g(^dbo.BTTestCodeD(RowID)),2)		//代码
		s CName= $lg($g(^dbo.BTTestCodeD(RowID)),3)		//描述
		s HospitalDR = $lg($g(^dbo.BTTestCodeD(RowID)),4)  //医院DR
		s:HospitalDR'="" HospitalDR=$lg($g(^dbo.BTHospitalD(HospitalDR)),3)	//医院描述
		s SCode = $lg($g(^dbo.BTTestCodeD(RowID)),14)		//标准码
		//s:SCode'="" SCode=$lg($g(^dbo.BTTestCodeSCodeD(SCode)),3)	//标准码描述
		s Sequence = $lg($g(^dbo.BTTestCodeD(RowID)),24)   //序号
		s Active = $lg($g(^dbo.BTTestCodeD(RowID)),25)   //激活
		s Active=$CASE(Active,"1":"Y",:"N")
		
		d OutputRow
	}
	else
	{
		k ^tempsequencesort("dbo.BTTestCode")
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	    s RowID=0
	 	for
	 	{
		 	s RowID=$o(^dbo.BTTestCodeD(RowID))
		 	q:RowID=""
		 	s Code = $lg($g(^dbo.BTTestCodeD(RowID)),2)		//代码
			s CName = $lg($g(^dbo.BTTestCodeD(RowID)),3)		//描述
			s HospitalDR = $lg($g(^dbo.BTTestCodeD(RowID)),4)  //医院DR
			s SCode = $lg($g(^dbo.BTTestCodeD(RowID)),14)		//标准码
			s Sequence = $lg($g(^dbo.BTTestCodeD(RowID)),24)    //序号
		 	s PINYIN=""
		 	s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CName)
		 	if ($ZCONVERT(Code,"U")[code)&&(($ZCONVERT(CName,"U")[desc)||(PINYIN[desc)) &&((HospitalDR=hospitaldr)||(hospitaldr=""))&&((SCode=scodedr)||(scodedr=""))
		 	{
			 	s:Sequence="" Sequence=" "
			 	s ^tempsequencesort("dbo.BTTestCode",Sequence,RowID)=""
			}
		}
		s Sort=""
		for
		{
			s Sort=$o(^tempsequencesort("dbo.BTTestCode",Sort)) q:Sort=""
			s RowID=0
			for 
			{
				s RowID=$o(^tempsequencesort("dbo.BTTestCode",Sort,RowID))  q:RowID=""
				s Code= $lg($g(^dbo.BTTestCodeD(RowID)),2)		//代码
				s CName= $lg($g(^dbo.BTTestCodeD(RowID)),3)		//描述
				s HospitalDR = $lg($g(^dbo.BTTestCodeD(RowID)),4)  //医院DR
				s:HospitalDR'="" HospitalDR=$lg($g(^dbo.BTHospitalD(HospitalDR)),3)	//医院描述
				s SCode = $lg($g(^dbo.BTTestCodeD(RowID)),14)		//标准码
				//s:SCode'="" SCode=$lg($g(^dbo.BTTestCodeSCodeD(SCode)),3)	//标准码描述
				s Sequence = $lg($g(^dbo.BTTestCodeD(RowID)),24)   //序号
				s Active = $lg($g(^dbo.BTTestCodeD(RowID)),25)   //激活
				s Active=$CASE(Active,"1":"Y",:"N")
				
				d OutputRow
			}
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowID,Code,CName,HospitalDR,SCode,Sequence,Active)
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

/// Creator:杨帆 
/// CreatDate:2020-03-10
/// Description:数据重复验证方法,js调用
/// Table:dbo.BT_TestCode
/// Input:id, code, Hospital
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.LAB.BTTestCode).FormValidate("1","L0026","1")
ClassMethod FormValidate(id As %String, code As %String, Hospital As %String) As %String
{
	s flag=0
	if ((code'="")&&(Hospital'=""))
	{
		s RowID=$o(^dbo.BTTestCodeI("IndexCode",Hospital,##Class(web.DHCBL.BDP.FunLib).IndexData(code),0))
		if (RowID'="")&&(id'=RowID) s flag=1
	}
	
	q flag
}

/// Creator:杨帆 
/// CreatDate: 2020-03-10
/// Description：保存 检验项目
/// Input: eobj As web.Entity.LAB.BTTestCode
/// Table：dbo.BT_TestCode
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.LAB.BTTestCode).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.LAB.BTTestCode) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.Active="" eobj.Active="0"
		s flag=..FormValidate(eobj.RowID,eobj.Code,eobj.HospitalDR)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.RowID="")
		{
			s obj=##class(dbo.BTTestCode).%New()
		}
		else
		{
			s obj=##class(dbo.BTTestCode).%OpenId(eobj.RowID)
			s bobj=##class(web.Entity.LAB.BTTestCode).%New()
			s bobj.RowID = eobj.RowID		  //RowID
			s bobj.Code = obj.Code		      //代码
			s bobj.CName = obj.CName		  //描述
			s bobj.HospitalDR=obj.HospitalDR  //医院DR
			s bobj.SCode = obj.SCode		      //标准码
			s bobj.Sequence = obj.Sequence    //序号
			s bobj.Active=obj.Active          //激活
		}
		s obj.Code = eobj.Code		      //代码
		s obj.CName = eobj.CName		  //描述
		S obj.HospitalDR=eobj.HospitalDR  //医院DR
		s obj.SCode = eobj.SCode		      //标准码
		s obj.Sequence = eobj.Sequence    //序号
		s obj.Active=eobj.Active          //激活

		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.RowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_TestCode","dbo.BTTestCode","检验项目",eobj.RowID,eobj.CName,"U",eobj,bobj)
			d:eobj.RowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_TestCode","dbo.BTTestCode","检验项目",id,eobj.CName,"A",eobj)
		}
		else
		{
			TROLLBACK
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
		
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator：杨帆 
/// CreatDate: 2020-03-10
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：dbo.BT_TestCode
/// Input：RowId
/// Other: w ##class(web.DHCBL.LAB.BTTestCode).OpenData(1)
ClassMethod OpenData(id As %String) As %String
{
    s str = ""
	s pobj = ##class(dbo.BTTestCode).%OpenId(id) 
	s eobj = ##class(web.Entity.LAB.BTTestCode).%New() 
	s eobj.RowID = id
	s eobj.Code = pobj.Code      //代码
	s eobj.CName = pobj.CName      //描述
	s eobj.HospitalDR=pobj.HospitalDR      //医院
	s eobj.SCode = pobj.SCode      //标准码
	s eobj.Sequence = pobj.Sequence      //排序
	s eobj.Active=pobj.Active      //激活

	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator:杨帆
/// CreatDate:2020-03-10
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: w ##class(web.DHCBL.LAB.BTTestCode).GetRefFlag(1)
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	//dbo.BTTestCodeComments
	s TestCodeCommentsRowID=0
	for 
	{
		s TestCodeCommentsRowID=$o(^dbo.BTTestCodeCommentsD(TestCodeCommentsRowID))
		q:TestCodeCommentsRowID=""
		s TestCodeDR= $lg($g(^dbo.BTTestCodeCommentsD(TestCodeCommentsRowID)),1)
		if (TestCodeDR=id)
		{
			s myInfo=myInfo_"<检验项目标准备注>"
			q
		}
	}
	//dbo.BTTestCodeRanges
	s TestCodeRangesRowID=0
	for 
	{
		s TestCodeRangesRowID=$o(^dbo.BTTestCodeRangesD(TestCodeRangesRowID))
		q:TestCodeRangesRowID=""
		s TestCodeDR=$lg($g(^dbo.BTTestCodeRangesD(TestCodeRangesRowID)),1)
		if (TestCodeDR=id)
		{
			s myInfo=myInfo_"<检验项目参考范围>"
			q
		}
	}
	//dbo.BTTestSetLayout
	s TestSetLayoutRowID=0
	for 
	{
		s TestSetLayoutRowID=$o(^dbo.BTTestSetLayoutD(TestSetLayoutRowID))
		q:TestSetLayoutRowID=""
		s TestCodeDR=$lg($g(^dbo.BTTestSetLayoutD(TestSetLayoutRowID)),3)
		if (TestCodeDR=id)
		{
			s myInfo=myInfo_"<项目组合套布局>"
			q
		}
	}
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator：杨帆
/// CreatDate: 2020-03-10
/// Description：根据id删除 性别
/// Table：dbo.BT_TestCode
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.LAB.BTTestCode).DeleteData()
ClassMethod DeleteData(id) As %String
{
	s result=""
	s re=##class(web.DHCBL.LAB.BTTestCode).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		s pobj = ##class(dbo.BTTestCode).%OpenId(id)
		s eobj = ##class(web.Entity.LAB.BTTestCode).%New()
		s eobj.Code = pobj.Code		  //代码
		s eobj.CName = pobj.CName		  //描述
		s eobj.HospitalDR=pobj.HospitalDR		  //关联医院
		s eobj.SCode = pobj.SCode		  //标准码
		s eobj.Sequence = pobj.Sequence		  //序号
		s eobj.Active=pobj.Active		  //激活
		
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(dbo.BTTestCode).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_TestCode","dbo.BTTestCode","描述",id,eobj.CName,"D",eobj)
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("描述","web.DHCBL.LAB.BTTestCode","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"	
	}
	
	
	q result
}

/// Creator:杨帆
/// CreatDate:2020-03-15
/// Description:通过检验项目代码获取检验项目rowid
/// w ##class(web.DHCBL.LAB.BTTestCode).GetRowIdByCode("")
ClassMethod GetRowIdByCode(code As %String) As %String
{
	S RowID=""
	s code=$ZCONVERT(code,"U")
	if code'=""
	{
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTTestCodeD(RowID))
			q:RowID=""
			s Code= $lg($g(^dbo.BTTestCodeD(RowID)),2)		//代码
			q:code=$ZCONVERT(Code,"U")
		}
	}
	q RowID
}

/// Creator:杨帆 
/// CreatDate: 2020-03-19
/// Description：通过检验项目代码获取标准码
/// Input: code,hospital
/// Other:w ##class(web.DHCBL.LAB.BTTestCode).GetSCode("00010","1")
ClassMethod GetSCode(code As %String, Hospital As %String) As %String
{
	s SCode=""
	s RowID=""
	if ((code'="")&&(Hospital'=""))
	{
		s RowID=$o(^dbo.BTTestCodeI("IndexCode",Hospital,##Class(web.DHCBL.BDP.FunLib).IndexData(code),0))
	}
	if (RowID'="")
	{
		s SCode = $lg($g(^dbo.BTTestCodeD(RowID)),14)
	}
	q "标准码："_SCode
}

/// Creator:杨帆 
/// CreatDate: 2020-03-26
/// Description：根据标准码取检验小项信息接口
/// Input: scode
/// Output:Code,CName,HospitalID
/// Other:w ##class(web.DHCBL.LAB.BTTestCode).GetTestCode("3")
ClassMethod GetTestCode(scode As %String) As %String
{
	s Code=""
	s CName=""
	s HospitalID=""
	s RowID=""
	s HospitalCode=""
	if (scode'="")
	{
		s RowID=$o(^dbo.BTTestCodeI("IndexSCode",##Class(web.DHCBL.BDP.FunLib).IndexData(scode),0))
	}
	if (RowID'="")
	{
		s Code= $lg($g(^dbo.BTTestCodeD(RowID)),2)		//代码
		s CName= $lg($g(^dbo.BTTestCodeD(RowID)),3)		//描述
		s HospitalID = $lg($g(^dbo.BTTestCodeD(RowID)),4)  //院区ID
		s HospitalCode= $lg($g(^dbo.BTHospitalD(HospitalID)),2)		//代码
	}
	q "检验项目代码:"_Code_","_"检验项目描述:"_CName_","_"医院ID:"_HospitalID_","_"医院代码:"_HospitalCode
}

}
