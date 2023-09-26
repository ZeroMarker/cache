Class web.DHCBldCommonUse Extends %Persistent
{

//获取病区描述

ClassMethod GetWardDesc(wardDr As %String) As %String
{
    S wardDr=$g(wardDr)
    S ret=""
    Q:'$l(wardDr) ret
    S ret=$P($g(^PAWARD(wardDr)),"^",2)
    S:ret["-" ret=$P(ret,"-",2)
    Q ret
}

ClassMethod GetLastOperatorByType(appFormID As %String, opType As %String) As %String
{
	S appFormID=$g(appFormID),opType=..CheckOpType($g(opType))
    S ret=""
    Q:('$l(appFormID))||('$l(opType)) ret
    
    S dFlag=$D(^DHCBLDAPPFORM(appFormID,"OPERATION"))
    Q:dFlag=0 ret
    
    K PLIST
    S subScript="",tDeli=$C(2),isFind=0
    F  S subScript=$O(^DHCBLDAPPFORM(appFormID,"OPERATION",subScript),-1) Q:(subScript="")!(isFind=1)  D
    .//S opType=""
    .I $D(^DHCBLDAPPFORM(appFormID,"OPERATION",subScript,opType))'=0 D
    ..
    ..S operator=$O(^DHCBLDAPPFORM(appFormID,"OPERATION",subScript,opType,""),-1)
    ..Q:operator=""
    ..S tData=$g(^DHCBLDAPPFORM(appFormID,"OPERATION",subScript,opType,operator))
    ..Q:'$l(tData)
    ..S opDate=$P(tData,"\",4)
    ..S:$l(opDate) opDate=$ZD(opDate,3)
    ..S opTime=$P(tData,"\",5)
    ..S:$l(opTime) opTime=$ZT(opTime,2)
    ..S details=$P(tData,"\",6)
    ..S remark=$P(tData,"\",7)
    ..S operatorDesc=..GetDoctorNameByID(operator)
    ..S ret=operator_tDeli_operatorDesc_tDeli_opDate_tDeli_opTime_tDeli_details_tDeli
    ..S isFind=1
 
    
    Q ret
}

ClassMethod CheckOpType(opType As %String) As %String
{
    S opType=$g(opType)
    S ret=opType
    I (opType'="SA")&&(opType'="AP")&&(opType'="CA")&&(opType'="CH"){
		I (opType'="CC")&&(opType'="PA")&&(opType'="PC"){    
			S ret=""
		}
	}
    
    Q ret
}

ClassMethod GetDoctorNameByID(userID As %String) As %String
{
    S userID=$g(userID)
    s userID=$TR(userID,"-","")
    S ret=""
    Q:'$l(userID) ret
    S userID=$ZCVT(userID,"U")
    Q:'$D(^SSU("SSUSR",0,"SSUSR_Initials",userID)) ret
    S userRowID=$O(^SSU("SSUSR",0,"SSUSR_Initials",userID,""))
    S ret=..GetDoctorNameByRowID(userRowID)
    Q ret
}

ClassMethod GetDoctorNameByRowID(userRowID As %String) As %String
{

    S userRowID=$g(userRowID)
    S ret=""
    Q:'$l(userRowID) ret
    Q:'$D(^SSU("SSUSR",userRowID)) ret
    S ret=$P($g(^SSU("SSUSR",userRowID)),"^",2)
    Q ret
}

/// Creator：      MCR
/// CreatDate：    20141201
/// Description:： 获取手术类型信息
/// Table：        无
/// Input：        EpisodeID：就诊号
/// Output：       无
/// Return：       JSon Store数据
/// Others：       无
///  W ##Class(web.DHCBldCommonUse).GetOperationType("829572")
ClassMethod GetOperationType(EpisodeID As %String) As %String
{
	S EpisodeID=$G(EpisodeID)
	S Info="",OpInfo="",ret=""
	S OpaId="" F  S OpaId=$O(^DHCANOPArrange(0,"Adm",EpisodeID,OpaId)) Q:OpaId=""  D
	.S OpDesc=""
	.S chl=$p($p(^DHCANOPArrange(OpaId),"^",2),"||",2)
	.S subchl=0 F  S subchl=$O(^OR(EpisodeID,"ANA",chl,"OP",subchl)) Q:(subchl="")  D 
	..S Oplevel=$P(^OR(EpisodeID,"ANA",chl,"OP",subchl,"DHC"),"^",1)
	..S Opdr=$P(^OR(EpisodeID,"ANA",chl,"OP",subchl),"^",6)       		    
	..I $L(Opdr)  D   
	...I $P($G(^ORC("OPER",+Opdr)),"^",2)'="" D    
	....I $L(OpDesc) S OpDesc=OpDesc_";"     
	....S OpDesc=OpDesc_$P($G(^ORC("OPER",+Opdr)),"^",2)       //手术名称
	..E  D
	...I $G(^OR(EpisodeID,"ANA",chl,"OP",subchl,"REM",2))'="" D
	....I $L(OpDesc) S Opdes=Opdes_";"
	....S OpDesc=OpDesc_$G(^OR(EpisodeID,"ANA",chl,"OP",subchl,"REM",2))
	.S Info=OpaId_"||"_OpDesc_"||"_Oplevel
	.S:$L(Info) OpInfo=OpInfo_Info_"^"
	S:$L(OpInfo) OpInfo=$E(OpInfo,1,$L(OpInfo)-1),ret=OpInfo
	Q ret
}

Storage Default
{
<Data name="DHCBldCommonUseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBldCommonUseD</DataLocation>
<DefaultData>DHCBldCommonUseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCBldCommonUseD</IdLocation>
<IndexLocation>^web.DHCBldCommonUseI</IndexLocation>
<StreamLocation>^web.DHCBldCommonUseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
