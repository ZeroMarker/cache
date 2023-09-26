Class web.DHCAPPArcLinkOpt Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      zhouxin
/// CreatDate：    2016-04-12
/// Description:： 分页显示该医嘱关联的其他项目
/// Table：        DHC_AppArcLinkOpt,
/// Input：	      page：当前页数
///               rows：每页条数
///               itmmastid：医嘱id
/// Return：       
/// d ##class(web.DHCAPPArcLinkOpt).list()
ClassMethod list(page = 1, rows = 10, itmmastid = "", HospID = "")
{
	
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0

 
	    w "{""rows"":["
		s arc=""
		f  s arc=$o(^DHCAPARCO(0,"ARC",arc)) q:arc=""  d
		.q:(itmmastid'="")&(itmmastid'=arc)
		.s otheropt=""
		.f  s otheropt=$o(^DHCAPARCO(0,"ARC",arc,otheropt)) q:otheropt=""  d
		..s ID=$o(^DHCAPARCO(0,"ARC",arc,otheropt,""),-1)
		..Q:$p(^DHCAPOTHO(otheropt),"^",5)'=HospID    /// 增加医院判断 bianshuai 2017-01-21
		..s AOMoChoiceDr=$P(^DHCAPARCO(ID),"^",3)
		..s Type=$p(^DHCAPOTHO(otheropt),"^",3)
		..s AOMoChoice=""
		..if AOMoChoiceDr'="" d
		...if Type="Check" d
		....s AOMoChoice=$s(AOMoChoiceDr="Y":"是",AOMoChoiceDr="N":"否",1:"")
		...if Type="Combox" d
		....s AOMoChoice=$P(^DHCAPOTHO(otheropt,"I",AOMoChoiceDr),"^",2)
		...if Type="Order" d
		....s ArcimDr=$P(^DHCAPOTHO(otheropt,"I",AOMoChoiceDr),"^",3)
		....s AOMoChoice=$P(^ARCIM(+ArcimDr,$P(ArcimDr,"||",2),1),"^",2)
		..s AORequired=$p(^DHCAPOTHO(otheropt),"^",4)
		..s AORequired=$s(AORequired="Y":"是",AORequired="N":"否",1:"")
		..s count=count+1
		..q:count<start
		..q:count>end
	    ..w $case(count,start:"",:",")
	    ..s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    ..s jsonObj.ContainNullValue=1
		..d jsonObj.Put("ID",ID)
		..d jsonObj.Put("AODesc",$p(^DHCAPOTHO(otheropt),"^",2))
		..d jsonObj.Put("AOCode",$p(^DHCAPOTHO(otheropt),"^",1))
		..d jsonObj.Put("AOType",$p(^DHCAPOTHO(otheropt),"^",3))
		..d jsonObj.Put("AORequired",AORequired)
		..d jsonObj.Put("AORowId",otheropt)
		..d jsonObj.Put("AOMoChoice",AOMoChoice)
		..d jsonObj.Put("AOMoChoiceDr",AOMoChoiceDr)
		..w jsonObj.Json()
		w "],""total"":"_count_"}"
		q ""
}

ClassMethod saveList(dataList)
{

	s Len=$L(dataList,"$$")
	s Err=0
	f i=1:1:Len q:Err'=0  d
	.s str=$p(dataList,"$$",i)
	.s Err=..Save($p(str,"^",2),$p(str,"^",3),$p(str,"^",1))
	q Err
}

/// Creator：      zhouxin
/// CreatDate：    2016-04-12
/// Description:： 保存或者新增医嘱和其他项目关联
/// Table：        DHC_AppArcLinkOpt
/// Input：	      ALOArcDr：医嘱id
///               ALOOptDr：其他项目id
///               ID：rowid
/// Return：       保存成功 0，其他 失败
ClassMethod Save(ALOArcDr, ALOOptDr, ID, MoChoice)
{
  
  		 ;q:$d(^DHCAPARCO(0,"ARC",ALOArcDr,ALOOptDr)) -10 //增加重复性判断
  		 s sameflag=0
  		 s subid=""
  		 for {
	  		 s subid=$O(^DHCAPARCO(0,"ARC",ALOArcDr,ALOOptDr,subid))
	  		 q:subid=""
	  		 s SameMoChoice=$P(^DHCAPARCO(subid),"^",3)
	  		 if (SameMoChoice=MoChoice) s sameflag=1
	  		 }
	  	 q:sameflag=1 -10
		 i +ID=0 d
		 .s obj=##class(User.DHCAppArcLinkOpt).%New()
		 e  d
		 .s obj=##class(User.DHCAppArcLinkOpt).%OpenId(ID)
		 .d obj.%Reload()
		 s obj.ALOArcDr=##class(User.ARCItmMast).%OpenId(ALOArcDr)
		 s obj.ALOOptDr=##class(User.DHCAppOtherOpt).%OpenId(ALOOptDr)
		 s obj.ALOMoChoice=MoChoice
		 s sc=obj.%Save()
		 i $$$ISERR(sc) q -2
		 q 0
}

/// Creator：      zhouxin
/// CreatDate：    2016-04-12
/// Description:： 删除关联
/// Table：        DHC_AppArcLinkOpt
/// Input：	      Id：rowid
/// /Return：      操作成功 0，其他 失败
ClassMethod remove(Id)
{
  
  q:+Id=0 -1
   
  s obj=##class(User.DHCAppArcLinkOpt).%DeleteId(Id)
  q 0
}

/// w ##class(web.DHCAPPArcLinkOpt).jsonAppOtherOpt(6)
ClassMethod jsonAppOtherOpt(ALOOptDr)
{
	s ^tempqujian("jsonAppOtherOpt")=ALOOptDr
	q:ALOOptDr="" "[]"
	s OptType=$P(^DHCAPOTHO(ALOOptDr),"^",3)
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s count = 0
	if (OptType="Check"){
		s tmp="Y^是"
		d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
		d Stream.Write(",")
		s tmp="N^否"
		d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
	}elseif(OptType="Combox"){
		s subrowid=""
		for {
			s subrowid=$O(^DHCAPOTHO(ALOOptDr,"I",subrowid))
			q:subrowid=""
			s Desc=$P(^DHCAPOTHO(ALOOptDr,"I",subrowid),"^",2)
			s tmp=subrowid_"^"_Desc
			s count = count+1
			if (count=1){d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
			}else{
				d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
				}
			}
		
	}elseif(OptType="Order"){
		s subrowid=""
		for {
			s subrowid=$O(^DHCAPOTHO(ALOOptDr,"I",subrowid))
			q:subrowid=""
			s ArcimDr=$P(^DHCAPOTHO(ALOOptDr,"I",subrowid),"^",3)
			continue:ArcimDr=""
			s Desc=$P(^ARCIM(+ArcimDr,$P(ArcimDr,"||",2),1),"^",2)
			s tmp=subrowid_"^"_Desc
			s count = count+1
			if (count=1){d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
			}else{
				d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
				}
		}
	}
	d Stream.Write("]")
	q Stream.Read()
}

}
