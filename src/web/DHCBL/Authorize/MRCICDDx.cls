/// ICD诊断代码数据授权
/// 2013-10-11 by lisen
Class web.DHCBL.Authorize.MRCICDDx Extends web.BDP.sys.ExtPreferences
{

/// w ##class(web.DHCBL.Authorize.MRCICDDx).SaveAuthorizeData("G","1","")
/// w ##class(web.DHCBL.Authorize.MRCICDDx).GetTreeJson("menuTreeRoot","G","1")
Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "MRC_ICDDx";

Parameter EntityClassName = "web.Entity.CT.MRCICDDx";

Parameter DataSplitString = "BITMAP";

/// 保存授权的Data
/// 数据格式：bitmap，1：有权  0：无权
/// 保存的数据格式："limited 1 or 0" # "bitmap"
ClassMethod SaveAutData(ObjectType As %String, ObjectReference As %String, Data As %String) As %String
{
	s type=$p(Data,":",1)
	if (type="limited") {
		s limited=$p(Data,":",2)
		s bitStr=""
		s bitStr=##class(web.DHCBL.Authorize.MRCICDDx).DHCGetDataByReference(ObjectType,ObjectReference)
		if ($l(bitStr,"#")=1) {
			s bitStr=limited_"#"_bitStr
		}
		elseif ($l(bitStr,"#")=2) {
			s $p(bitStr,"#",1)=limited
		}
	}
	elseif (type="IDS") {
		s IDS=$p(Data,":",2)
		s bitStr=""
		s bitStr=##class(web.DHCBL.Authorize.MRCICDDx).DHCGetDataByReference(ObjectType,ObjectReference)
		if (bitStr'="") {
			if ($l(bitStr,"#")=1) {
				s len=$l(IDS,"^")
				for i=1:1:len {
					s node = $p(IDS,"^",i)
					s id = $p(node,"!",1)
					s flag = $p(node,"!",2)
					s $bit(bitStr,id) = flag
				}
				s bitStr=1_"#"_bitStr
			}
			elseif ($l(bitStr,"#")=2) {
				s bitStr=$p(bitStr,"#",2)
				s len=$l(IDS,"^")
				for i=1:1:len {
					s node = $p(IDS,"^",i)
					s id = $p(node,"!",1)
					s flag = $p(node,"!",2)
					s $bit(bitStr,id) = flag
				}
				s bitStr=1_"#"_bitStr
			}
		}
	}
	
	s rtn=##class(web.DHCBL.Authorize.MRCICDDx).SaveAuthorizeData(ObjectType,ObjectReference,bitStr)
	q rtn
}

/// 获取授权数据的limited
/// limited:  1：受限  0：不受限  空：不受限
ClassMethod GetLimited(ObjectType As %String, ObjectReference As %String)
{
	s bitStr="",limited=""
	s bitStr=##class(web.DHCBL.Authorize.MRCICDDx).DHCGetDataByReference(ObjectType,ObjectReference)
	if (bitStr'="") {
		if ($l(bitStr,"#")=1) {
			s limited=0
		}
		elseif ($l(bitStr,"#")=2) {
			s limited=$p(bitStr,"#",1)
		}
	}
	
	q limited
}

/// 一级授权中获取Tree类型的json串
/// ParentID： 父ID
/// ObjectType: 需要显示的优先级类别
/// ObjectReference： 在界面上 选择的 Group或者User或者CTLoc(登录科室)
ClassMethod GetTreeJson(ParentID As %String, ObjectType As %String, ObjectReference As %String, start, limit, query, FilterCK) As %String
{
	if (ParentID="menuTreeRoot") s ParentID=-100000000000000
	
	s myJsonStr=""
	s myImage=""
	
	//获取授权bit
	s AuStr=##class(web.DHCBL.Authorize.MRCICDDx).DHCGetDataByReference(ObjectType,ObjectReference)				
	if ($l(AuStr,"#")=1) {
	}
	elseif ($l(AuStr,"#")=2) {
		s AuStr=$p(AuStr,"#",2)
	}
	s hospid=$p(query,"^",2)
	s query=$p(query,"^",1)
	s rowid=0
	s count=0
	s end=start+limit
	
	for {
		s rowid=$o(^MRC("ID",rowid)) q:rowid=""
		continue:$p($g(^MRC("ID",rowid)),"^",27)="N"
		s MRCIDDateActiveTo=$p($g(^MRC("ID",rowid)),"^",7)
		continue:(MRCIDDateActiveTo'="")&&(MRCIDDateActiveTo<+$h)
		if hospid'=""
		{
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("MRC_ICDDx",rowid,hospid)
			continue:showflag="N"
		}
		s code=$p($g(^MRC("ID",rowid)),"^",1)
		s desc=$p($g(^MRC("ID",rowid)),"^",2)
		s desc=##class(web.BDP.util.String).Replace(desc,$c(34),"")
		continue:(desc="-")
		s MRCIDICD9CMCode=$p($g(^MRC("ID",rowid)),"^",4) 
		//过滤已选、未选
		if (FilterCK="checked") {
			if ($bit(AuStr,rowid)=1) 
			else  continue
		}
		elseif (FilterCK="unchecked") {
			if ($bit(AuStr,rowid)=1) continue
			else  
		}
		
		if ($ZCONVERT(desc,"U")[$ZCONVERT(query,"U")) {
			s count=count+1
			if ((count>start) & (count<=end)) || (end=0) {
				
				if ($bit(AuStr,rowid)=1) s myEnable=1
				else  s myEnable=0
				
				s:(myJsonStr'="") myJsonStr=myJsonStr_","
				s myJsonStr=myJsonStr_"{"
				s myJsonStr=myJsonStr_"""id"":"""_""_rowid_""",""text"":"""_code_"  "_desc_"  "_MRCIDICD9CMCode_""","
				
				if (+myEnable) {
					s myJsonStr=myJsonStr_"""checked"":true,"
				}else {
					s myJsonStr=myJsonStr_"""checked"":false,"
				}
				s myJsonStr=myJsonStr_"""leaf"":true"
				s myJsonStr=myJsonStr_"}"
			}
		}
	}
	s myJsonStr="{data:["_myJsonStr_"],totalCount:"_count_"}"
	
	q myJsonStr
}

}
