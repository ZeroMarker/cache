Include webimport

IncludeGenerator webimport

/// 常用公共函数
Class web.DHCLabUtlCore Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 获取Meddata命名空间
/// Table：        无
/// Input：        无
/// Output：       无
/// Return：       命名空间
/// Others：       无
ClassMethod GetDataNS() As %String
{
	S Config=##Class(websys.Configuration).%OpenId(1)
 	S DataNS=Config.DataNamespace
	S:'$l(DataNS) DataNS="dhc-data"
 	Q DataNS
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 获取Labdata命名空间
/// Table：        无
/// Input：        无
/// Output：       无
/// Return：       命名空间
/// Others：       无
ClassMethod GetLabDataNS() As %String
{
	S Config=##Class(websys.Configuration).%OpenId(1)
	S LABDATA=Config.LabDataNamespace
	S:'$l(LABDATA) LABDATA="labdata"
 	Q LABDATA
}

/// Creator：      wwh
/// CreatDate：    2011-5-24
/// Description:： 获取字典分组的所有子节点
/// Table：        DHC_LabDictionaryGroup
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetDictGroupChilds(groupCode As %String) As %String
{
	N (groupCode)
	S groupCode=$g(groupCode)
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret="",PLIST=""
	Q:'$L(groupCode) ret
	zn dhcdata
	S retVal=$$GetAllChilds^DHCLabUtlDictionary(groupCode)
	I retVal>0 {
		S index=""
		F{
			S index=$O(PLIST(index))
			Q:index=""
			S ret=ret_$g(PLIST(index))_$C(3)
		}	
	}
	zn curNS
    Q ret
}

/// Creator：      wwh
/// CreatDate：    2011-5-24
/// Description:： 获取布局信息
/// Table：        DHC_LabItemLayout
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetLayout(rowID As %String) As %String
{
 
	N (rowID)
	S rowID=$g(rowID)
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret="",PLIST=""
	Q:'$L(rowID) ret
	zn dhcdata
	S ret=$$GetLayout^DHCLabUtlDictionary(rowID)
	zn curNS
    Q ret
}

/// Creator：      wwh
/// CreatDate：    2011-5-24
/// Description:： 获取布局信息
/// Table：        DHC_LabItemLayout
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod BuildRequestData(ByRef request As %CSP.Request, gCode As %String, flag As %String = "") As %String
{
	N (request,gCode,flag)
	S request=$g(request),gCode=$g(gCode),flag=$g(flag)
	S ret=""
	Q:request=$$$NULLOREF ret
	Q:'$l(gCode) ret
	
	S reDeli=$C(3),deli=$C(2),ret=""
    S dictData=..GetDictGroupChilds(gCode)
   	F i=1:1:$l(dictData,reDeli) {
	  	S data=$P(dictData,reDeli,i)
	  	S iCode=$P(data,deli,1)
	  	Continue:'$l(iCode)
	  	S val=$g(request.Data(iCode,1))
	  	I $ZCVT(val,"U")="FALSE" {	//false 
			S val="N"	
		}
		I $ZCVT(val,"U")="TRUE" {	//true
			S val="Y"	
		}
		
		I $ZCVT(val,"U")="ON" {	//true
			S val="Y"	
		}

		I flag=1,'$l(val),..CheckLayoutItem(gCode,iCode,"checkbox") {
			S iCode=""
		}
	  	S:$l(iCode) ret=ret_iCode_"^"_val_deli
	}
	Q ret
}

/// ------------------------------------------------------------------------------------
/// Creator：		wwh
/// CreateDate：		2010-06-01
/// Description：	转换为系统日期
/// Table：			无
/// Input：			date
/// Output：			无
/// Return：			ret:系统日期
/// Others：			无
ClassMethod CvnToSysDate(date)
{
    N (date)
    S date=$g(date)
    S ret=""
    Q:'$l(date) ret
    
    S date=$TR(date,"年月日","--")
    I date?4N1"-"1.2N1"-"1.2N D
    .S ret=$ZDH(date,3)
    Q:$l(ret) ret
    Q ret
}

/// ------------------------------------------------------------------------------------
/// Creator：		wwh
/// CreateDate：		2010-06-01
/// Description：	转换为系统时间
/// Table：			无
/// Input：			time
/// Output：			无
/// Return：			ret:系统时间
/// Others：			无
ClassMethod CvnToSysTime(time)
{
    N (time)
    S time=$g(time)
    S ret=""
    Q:'$l(time) ret
    S time=$TR(time," ")
    
    I time?1.2N1":"1.2N0.1(1":"1.2N) D
    .S ret=$ZTH(time,2)
    
    I time?1.2N1":"1.2N0." "1(1"A",1"P")1"M" D
    .S ret=$ZTH(time,4)
    
    Q:$l(ret) ret
    Q ret
}

/// Creator：      wwh
/// CreatDate：    2012-2-6
/// Description:： 判断元素的布局类型
/// Table：        无
/// Input：        无
/// Output：       无
/// Return：       0-不同,1-相同
/// Others：       其它说明
ClassMethod CheckLayoutItem(gpCode As %String, iCode As %String, itmLayout As %String) As %String
{
   N (gpCode,iCode,itmLayout)
   S gpCode=$g(gpCode),iCode=$g(iCode),itmLayout=$g(itmLayout)
   S ret=0
   Q:('$l(gpCode))||('$l(iCode))||('$l(itmLayout)) ret
   S layoutRowID=$P($G(^DHCLABDICTIONAY("GROUP",gpCode,iCode)),"\",2)
   Q:'$l(layoutRowID) ret
   S itmLayout=$ZCVT(itmLayout,"L")
   S layoutType=$P($g(^DHCLABITEMLAYOUT(layoutRowID)),"\",3)
   
   S:(itmLayout=layoutType) ret=1 
   Q ret
}

/// ------------------------------------------------------------------------------------
/// Creator：		wwh
/// CreateDate：		2012-02-1
/// Description：	根据就诊号获取病人登记号
/// Table：			无
/// Input：			admID:就诊号
/// Output：			无
/// Return：			ret:登记号
/// Others：			无
ClassMethod GetDebtorNoByAdm(admID As %String)
{
    N (admID)
    S admID=$g(admID) 
    S ret=""
    Q:'$l(admID) ret
    S dFlag=$D(^PAADM(admID))
    Q:dFlag=0 ret
    S tData=$g(^PAADM(admID))
    Q:'$L(tData) ret
    S papmiDr=$P(tData,"^",1)
    S patType=$P(tData,"^",2)
    Q:'$l(papmiDr) ret
    Q:$D(^PAPER(papmiDr))=0 ret
    S ret=$P($g(^PAPER(papmiDr,"PAT",1)),"^",1) 
    Q ret
}

}
