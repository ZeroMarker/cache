/// CT_HospitalLogo
/// 医院logo维护
/// 基础数据平台-李可凡
/// 2022-07-07
Class web.DHCBL.CT.CTHospitalLogo Extends %RegisteredObject
{

/// Creator：李可凡
/// CreatDate: 2022-07-07
/// Description：获取医院logo列表
/// Table：User.CTHospitalLogo
/// Input：parref(LOGOParRef),rowid
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTHospitalLogo","GetList","2","")
Query GetList(parref As %String, rowid As %String) As %Query(ROWSPEC = "LOGORowId,LOGOParRef,LOGOChildsub,LOGOCode,LOGOUrl,LOGORemarks,LOGOImg")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, parref As %String, rowid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="")
	{
		s LOGORowId=rowid
		s LOGOParRef=$p(LOGORowId,"||",1)
		s LOGOChildsub=$p(LOGORowId,"||",2)
		s LOGOCode=$p($g(^CT("HOSP",LOGOParRef,"LOGO",LOGOChildsub)),"^",1)	//业务代码
		s LOGOUrl=$p($g(^CT("HOSP",LOGOParRef,"LOGO",LOGOChildsub)),"^",2)	//logo Url地址
		s LOGORemarks=$p($g(^CT("HOSP",LOGOParRef,"LOGO",LOGOChildsub)),"^",3)	//备注
		s LOGOImg=$g(^CT("HOSP",LOGOParRef,"LOGO",LOGOChildsub,"IMG"))		//logo base64编码
		if (LOGOUrl'="")
		{
			s FileFlag=..FileExist(LOGOUrl)
			s:FileFlag=1 LOGOImg=LOGOUrl
		}
		
		
		d OutputRow
	}
	else
	{
		s LOGOParRef=parref,LOGOChildsub=0
		for
		{
			s LOGOChildsub=$o(^CT("HOSP",LOGOParRef,"LOGO",LOGOChildsub)) q:LOGOChildsub=""
			s LOGORowId=LOGOParRef_"||"_LOGOChildsub
			s LOGOCode=$p($g(^CT("HOSP",LOGOParRef,"LOGO",LOGOChildsub)),"^",1)	//业务代码
			s LOGOUrl=$p($g(^CT("HOSP",LOGOParRef,"LOGO",LOGOChildsub)),"^",2)	//logo Url地址
			s LOGORemarks=$p($g(^CT("HOSP",LOGOParRef,"LOGO",LOGOChildsub)),"^",3)	//备注
			s LOGOImg=$g(^CT("HOSP",LOGOParRef,"LOGO",LOGOChildsub,"IMG"))		//logo base64编码
			if (LOGOUrl'="")
			{
				s FileFlag=..FileExist(LOGOUrl)
				s:FileFlag=1 LOGOImg=LOGOUrl
			}
			d OutputRow
		}
	}
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(LOGORowId,LOGOParRef,LOGOChildsub,LOGOCode,LOGOUrl,LOGORemarks,LOGOImg)
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
/// Creator:基础数据平台-李可凡
/// CreateDate:2022-07-07    
/// w ##class(web.DHCBL.CT.CTHospitalLogo).FormValidate("1||1","2","aaa")
ClassMethod FormValidate(rowid As %String, parref As %String, code As %String) As %String
{
	q:parref="" ""
	s flag=0
	s ChildSub=0
	for
	{
		s ChildSub=$o(^CT("HOSP",parref,"LOGO",ChildSub)) q:ChildSub=""
		s LOGOCode=$p($g(^CT("HOSP",parref,"LOGO",ChildSub)),"^",1)
		s LOGORowId=parref_"||"_ChildSub
		if (code=LOGOCode)&&(LOGORowId'=rowid)
		{
			s flag=1
			q
		}
	}
	q flag
}

/// Creator：李可凡
/// CreatDate: 2022-07-07
/// function：测试对象数据存储
/// debug：d ##class(web.DHCBL.CT.CTHospitalLogo).Test()
ClassMethod Test()
{
	s eobj=##class(web.Entity.CT.CTHospitalLogo).%New()
	s eobj.LOGOParRef="2"
	s eobj.LOGORowId=""
	s eobj.LOGOCode="picture"
	s eobj.LOGOUrl="../scripts/bdp/App/Locations/HospitalLogo/picture.jpg"
	s eobj.LOGORemarks="测试"
	s eobj.LOGOImg=""
	w ..SaveEntity(eobj)
}

/// Creator：李可凡
/// CreatDate: 2022-07-07
/// Description：保存医院logo
/// Table：User.CTHospitalLogo
/// Input:web.Entity.CT.CTHospitalLogo
/// Return:成功返回true和id,失败返回false和errorinfo
ClassMethod SaveEntity(eobj As web.Entity.CT.CTHospitalLogo) As %String
{
	s result=""
	s flag=..FormValidate(eobj.LOGORowId,eobj.LOGOParRef,eobj.LOGOCode)  //调用重复验证
	if (flag=1)
	{
		s result = "{success:'false',errorinfo:'业务代码已存在！'}"
	}
	else
	{
		if (eobj.LOGORowId="")&&($g(^TempHospLogo("LOGOImg"))="")
		{
			s result = "{success:'false',errorinfo:'请先上传图片！'}"
		}
		else
		{
			if (eobj.LOGORowId="")	//如果RowId未赋值则增加
			{
				s obj=##class(User.CTHospitalLogo).%New(eobj.LOGOParRef)
				d obj.LOGOParRefSetObjectId(eobj.LOGOParRef)
				s eobj.LOGOUrl=$g(^TempHospLogo("LOGOUrl"))
				s eobj.LOGOImg=$g(^TempHospLogo("LOGOImg"))
			}
			else	//如果RowId已赋值则修改
			{
				s obj=##class(User.CTHospitalLogo).%OpenId(eobj.LOGORowId)
				s bobj=##class(web.Entity.CT.CTHospitalLogo).%New(eobj.LOGOParRef)
				s bobj.LOGORowId=eobj.LOGORowId
				s bobj.LOGOParRef=eobj.LOGOParRef
				
				s bobj.LOGOCode=obj.LOGOCode
				s bobj.LOGOUrl=obj.LOGOUrl
				s bobj.LOGORemarks=obj.LOGORemarks
				
				if ($g(^TempHospLogo("LOGOImg"))'="")
				{
					s eobj.LOGOUrl=$g(^TempHospLogo("LOGOUrl"))
					s eobj.LOGOImg=$g(^TempHospLogo("LOGOImg"))
				}
			}
			s obj.LOGOCode=eobj.LOGOCode
			s obj.LOGOUrl=eobj.LOGOUrl
			s obj.LOGORemarks=eobj.LOGORemarks
			s:eobj.LOGOImg'="" obj.LOGOImg=eobj.LOGOImg
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result= "{success:'true',id:'"_id_"'}"         //返回RowId
				
				if (eobj.LOGORowId'="")&&(eobj.LOGOUrl'=bobj.LOGOUrl)
				{
					d ..DeleteFile(bobj.LOGOUrl)	//删除原图片
				}
				
				s HospDesc=$p($g(^CT("HOSP",eobj.LOGOParRef)),"^",2)
				d:eobj.LOGORowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HospitalLogo","User.CTHospitalLogo","医院logo",id,HospDesc_"->"_eobj.LOGOCode,"U",eobj,bobj)
				d:eobj.LOGORowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HospitalLogo","User.CTHospitalLogo","医院logo",id,HospDesc_"->"_eobj.LOGOCode,"A",eobj)
			}
			else
			{
				Trollback
				s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医院logo","web.DHCBL.CT.CTHospitalLogo","SaveEntity",eobj)
				s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  
			}
		}
	}
	k ^TempHospLogo("LOGOUrl")
	k ^TempHospLogo("LOGOImg")
	q result
}

/// Creator：李可凡
/// CreatDate: 2022-07-07
/// Description：删除医院logo
/// Table：User.CTHospitalLogo
/// Input：id
/// Return:成功返回true和id,失败返回false和errorinfo
/// Other: w ##class(web.DHCBL.CT.CTHospitalLogo).DeleteData("3||1")
ClassMethod DeleteData(id) As %String
{
	s result=""
	
	s eobj = ##class(web.Entity.CT.CTHospitalLogo).%New()
	s pobj = ##class(User.CTHospitalLogo).%OpenId(id)
	s ParRef=$p($g(id),"||",1)  
	s ChildSub=$p($g(id),"||",2)
	S eobj.LOGORowId = id
	s eobj.LOGOParRef = ParRef
	s eobj.LOGOChildsub = ChildSub
	s eobj.LOGOCode=pobj.LOGOCode
	s eobj.LOGOUrl=pobj.LOGOUrl
	s eobj.LOGORemarks=pobj.LOGORemarks

	TSTART
	s sc = ##class(User.CTHospitalLogo).%DeleteId(id)
	if $$$ISOK(sc)
	{
		TCOMMIT
		s result = "{success:'true',info:'删除成功！'}"	
		s HospDesc=$p($g(^CT("HOSP",eobj.LOGOParRef)),"^",2)
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HospitalLogo","User.CTHospitalLogo","医院logo",id,HospDesc_"->"_eobj.LOGOCode,"D",eobj)
	}
	else 
	{
		TROLLBACK
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医院logo","web.DHCBL.CT.CTHospitalLogo","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator:李可凡
/// CreatDate:2022-07-07
/// description：双击修改获取数据
/// Table：User.CTHospitalLogo
/// Input：id
/// Return:rowid，科室id，医院logoid
/// Other:w ##class(web.DHCBL.CT.CTHospitalLogo).OpenData("1||1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.CTHospitalLogo).%OpenId(id)
	s eobj = ##class(web.Entity.CT.CTHospitalLogo).%New()
	s eobj.LOGORowId = id
	s eobj.LOGOParRef =$p(id,"||",1)
	s eobj.LOGOChildsub =$p(id,"||",2)
	s eobj.LOGOCode=pobj.LOGOCode
	s eobj.LOGOUrl=pobj.LOGOUrl
	s eobj.LOGORemarks=pobj.LOGORemarks
	s eobj.LOGOImg=pobj.LOGOImg
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// 设置临时global保存医院id
/// ^TempHospLogo("HOSPID")		医院rowid
/// ^TempHospLogo("LOGOImg")	图片base64
/// ^TempHospLogo("LOGOUrl")	图片url
/// w ##class(web.DHCBL.CT.CTHospitalLogo).SaveTempHospLogo("","")
ClassMethod SaveTempHospLogo(node As %String, data As %String) As %String
{
	s:node="" node="default"
	s ^TempHospLogo(node)=data
	q node_"^"_data
}

/// 获取临时global
/// ^TempHospLogo("HOSPID")		医院rowid
/// ^TempHospLogo("LOGOImg")	图片base64
/// ^TempHospLogo("LOGOUrl")	图片url
/// w ##class(web.DHCBL.CT.CTHospitalLogo).GetTempHospLogo("LOGOUrl")
ClassMethod GetTempHospLogo(node As %String) As %String
{
	q:node="" ""
	s data=$g(^TempHospLogo(node))
	q data
}

/// 删除图片文件
/// input:图片logoUrl
/// w ##class(web.DHCBL.CT.CTHospitalLogo).DeleteFile("..\scripts\bdp\App\Locations\HospitalLogo\picture.jpg")
ClassMethod DeleteFile(logourl As %String) As %String
{
	q:logourl="" "-1^null input"
	s result=""
	s:(logourl["..") logourl=$p(logourl,"..",2)
	s:(logourl["/") logourl=$replace(logourl,"/","\")
	
	s picturename=$p(logourl,"HospitalLogo\",2)
	q:picturename="" "-1^null name"
	//s path="D:\DTHealth\app\dthis\web\scripts\bdp\App\Locations\HospitalLogo\"
	s path=$p(logourl,picturename,1)	//相对路径
	s path=##class(web.DHCBL.BDP.BDPUploadFile).GetPhysicalPath("",path)	//取物理路径
	s path=path_picturename
	//w path,!
	
	if (##class(%File).Exists(path)=1)
	{
	  s result=##class(%File).Delete(path)
	}
	else
	{
		s result="-1^file not exist"
	}
	q result
}

/// 上传图片后点关闭，删除已上传的图片文件
/// w ##class(web.DHCBL.CT.CTHospitalLogo).DeleteFile()
ClassMethod CloseDeleteFile() As %String
{
	if $d(^TempHospLogo("LOGOUrl"))&&(^TempHospLogo("LOGOUrl")'="")
	{
		d ..DeleteFile(^TempHospLogo("LOGOUrl"))
	}
	q ""
}

/// 判断图片是否存在
/// input:图片logoUrl
/// w ##class(web.DHCBL.CT.CTHospitalLogo).FileExist("..\scripts\bdp\App\Locations\HospitalLogo\picture.jpg")
ClassMethod FileExist(logourl As %String) As %String
{
	q:logourl="" "-1^null input"
	s result=""
	s:(logourl["..") logourl=$p(logourl,"..",2)
	s:(logourl["/") logourl=$replace(logourl,"/","\")
	
	s picturename=$p(logourl,"HospitalLogo\",2)
	q:picturename="" "-1^null name"
	//s path="D:\DTHealth\app\dthis\web\scripts\bdp\App\Locations\HospitalLogo\"
	s path=$p(logourl,picturename,1)	//相对路径
	s path=##class(web.DHCBL.BDP.BDPUploadFile).GetPhysicalPath("",path)	//取物理路径
	s path=path_picturename
	//w path,!
	
	if (##class(%File).Exists(path)=1)
	{
	  s result=1
	}
	else
	{
		s result=0
	}
	q result
}

/// 图片文件转Base64编码
/// 原方法：##class(web.DHCBL.BDP.FunLib).GetBase64(dirname_FileName).Read()
/// 原方法返回的Base64编码有长度限制32768
/// 2022-08-03	likefan
/// input: url ( 绝对路径，如 D:\DtHealth\app\dthis\web\scripts\bdp\App\Locations\HospitalLogo\picture.jpg )
/// output: Base64编码字符串
/// 前台读取需拼上前缀，如: "data:image/jpeg;base64,"
/// w ##class(web.DHCBL.CT.CTHospitalLogo).GetBase64Code(^templkf("url"))
ClassMethod GetBase64Code(path) As %Stream.GlobalCharacter
{
    s path = ##Class(%File).NormalizeFilename(path)
    q:'##class(%File).Exists(path) "NotExistsFile"
    
    s fileobj = ##class(%FileBinaryStream).%New()  
    s fileobj.Filename = $g(path)   
    s byteList = fileobj.Read(12288)      ;要为3的倍数,这样补0才不会出问题. 12288 = 3*4*1024，12k  
    //s count=1
    s result=""
    while(byteList'=""){ 
    	s baseStr = ##class(%SYSTEM.Encryption).Base64Encode(byteList)
    	s baseStr=$tr(baseStr,$c(10),"")
    	s baseStr=$tr(baseStr,$c(13),"")
    	s result=result_baseStr
    	//s ^templkf(count)=baseStr
        //s count=count+1
        s byteList = ""         
        s byteList = fileobj.Read(12288)
    }     
    d fileobj.%Close()  
    s fileobj=""  
    q result
}

/***********************接口************************/
/// 根据医院id和业务代码，返回医院logo的Url
/// 基础数据平台-likefan	2022-07-29
/// input: 医院id，业务代码
/// output: Url
/// w ##class(web.DHCBL.CT.CTHospitalLogo).GetLogoUrl("2","aaa")
ClassMethod GetLogoUrl(hospid As %String, code As %String) As %String
{
	q:hospid="" ""
	q:code="" ""
	s ChildSub=$o(^CT("HOSP",hospid,"LOGO",0,"Code",code,0))
	q:ChildSub="" ""
	s LOGOUrl=$p($g(^CT("HOSP",hospid,"LOGO",ChildSub)),"^",2)	//logo Url地址
	q LOGOUrl
}

/// 根据医院id和业务代码，返回医院logo的Base64编码
/// 基础数据平台-likefan	2022-07-29
/// input: 医院id，业务代码
/// output: Base64编码
/// w ##class(web.DHCBL.CT.CTHospitalLogo).GetLogoBase64("2","aaa")
ClassMethod GetLogoBase64(hospid As %String, code As %String) As %String
{
	q:hospid="" ""
	q:code="" ""
	s ChildSub=$o(^CT("HOSP",hospid,"LOGO",0,"Code",code,0))
	q:ChildSub="" ""
	s LOGOImg=$g(^CT("HOSP",hospid,"LOGO",ChildSub,"IMG"))		//logo base64编码
	q LOGOImg
}

}
