Class DHCWL.DM.R.ComputedThemeDims Extends %RegisteredObject
{

Property Code As %String [ Required ];

Property DataType As DHCWL.DM.T.DataType;

/// Attached="TD"
/// DimType="RD"时ProExpression保存维度路径;DimType="ED"时ProExpression保存维度的计算表达式;DimType="LD"时ProExpression为空
Property DimType As DHCWL.DM.T.TypeConfig [ Required ];

Property ProExpression As %String(MAXLEN = 256);

Property SerialNumber As %Integer;

Property DimStructList As %List;

Property IsThemeDims As %Boolean;

Method %OnNew(dimName, dimStructList As %List, sn As %Integer, dimIndex As %Integer) As %Status [ Private, ServerOnly = 1 ]
{
	s ..Code=dimName
	s ..DimType=##class(DHCWL.DM.T.TypeConfig).GetByPath("TD:LD")
	s ..DataType=##class(DHCWL.DM.T.DataType).GetByJDBCTypeCode(+$list(dimStructList,4))
	s:..DataType="" ..DataType=##class(DHCWL.DM.T.DataType).GetByPath("VARCHAR")
	s dimBaseId=$lg(dimStructList,dimIndex)
	s ..IsThemeDims=0
	if $g(dimBaseId,"")'="" {
	  if ((dimIndex=1)){
	    s ..IsThemeDims=1
	    s pro=##class(DHCWL.DM.T.DimProperty).%OpenId($lg(dimStructList,2))
	    if pro'=""{
		  s ..ProExpression=pro.LinkedPath
		  if pro.LinkedPath'=""{
			s dimBaseObj=##class(DHCWL.DM.T.DimBase).GetByPath(pro.LinkedPath)
			s:dimBaseObj'="" $list(dimStructList,3)=dimBaseObj.%Id()
			s ..DimType=##class(DHCWL.DM.T.TypeConfig).GetByPath("TD:RD")
		  }
	    }
	  }elseif ((dimIndex=2)){
		s dimBaseObj=##class(DHCWL.DM.T.DimBase).%OpenId(dimBaseId)
	    if (dimBaseObj'=""){
		  s ..DimType=##class(DHCWL.DM.T.TypeConfig).GetByPath("TD:RD")
		  s ..ProExpression=dimBaseObj.GetPath()
	    }
	    s $list(dimStructList,3)=dimBaseId
	  }elseif dimIndex=3{
		s dimId=$lg(dimStructList,3)
		s $list(dimStructList,2)=dimId
	    s themeDim=##class(DHCWL.DM.T.ThemeDims).%OpenId(dimBaseId)
		if themeDim'=""{
		  s ..ProExpression=themeDim.ProExpression
		  s dimBaseObj=##class(DHCWL.DM.T.DimBase).GetByPath(themeDim.ProExpression)
		  if dimBaseObj'=""{
		    s ..DimType=##class(DHCWL.DM.T.TypeConfig).GetByPath("TD:RD")
		    s $list(dimStructList,3)=dimBaseObj.%Id()
		  }
		}
		;s $list(dimStructList,1)=dimBaseId
	  }
	  s dimBaseObj=""
	  
	  /*if ( (dimIndex=2) ){
		s dimPath=##class(DHCWL.DM.T.DimBase).%OpenId(dimBaseId)
	    if (dimPath'=""){
		  s ..DimType=##class(DHCWL.DM.T.TypeConfig).GetByPath("TD:RD")
		  s ..ProExpression=dimPath.GetPath()
	    }
	  }elseif ( (dimIndex=1) ){
		s ..IsThemeDims=1
		s themeDim=##class(DHCWL.DM.T.ThemeDims).%OpenId(dimBaseId)
		if themeDim'=""{
		  s ..DimType=##class(DHCWL.DM.T.TypeConfig).GetByPath("TD:RD")
		  s ..ProExpression=themeDim.ProExpression
		}
	  }*/
	  
	}
	s $list(dimStructList,1)=dimName
	s $list(dimStructList,2)=sn
	s $list(dimStructList,4)=..DataType.JDBCTypeCodeNum
	s ..DimStructList=dimStructList
	s ..SerialNumber=sn
	q $$$OK
}

Method GetLinkDim() As DHCWL.DM.T.DimBase
{
	if (..DimType.GetPath()="TD:RD") && (..ProExpression'="") {
	  q ##class(DHCWL.DM.T.DimBase).GetByPath(..ProExpression)	
	}
	q ""
}

Method Mask() As %String
{
  q ..SerialNumber
}

Method GetJDBCTypeCodeNum() As %Integer [ CodeMode = expression ]
{
..DataType.JDBCTypeCodeNum
}

}
