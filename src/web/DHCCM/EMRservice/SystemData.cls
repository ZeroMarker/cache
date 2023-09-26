/// 名称:web.DHCCM.EMRservice.SystemData
/// 描述:个性化类,取HIS以及EMR相关数据
/// 编写者：QuNianpeng
/// 编写日期: 2018-03-09
Class web.DHCCM.EMRservice.SystemData Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCCM.EMRservice.SystemData","GetPatRecordInfo","70")
Query GetPatRecordInfo(EpisodeID As %String = "") As %Query(ROWSPEC = "ChiefCom,CurrentMed,PastHistory,Personal,MarryHistory,Family,Menstruation,Examination,Assist,Consultations,Specialist,Allergy,patPMDrgHisDesc")
{
}

ClassMethod GetPatRecordInfoExecute(ByRef qHandle As %Binary, EpisodeID As %String = "") As %Status
{
 
    Set repid=$I(^CacheTemp)
    s ind=1
    Set qHandle=$lb(0,repid,0)
    Quit:($d(^PAADM(EpisodeID))=0)||(EpisodeID="") $$$OK
	//Set obj=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(EpisodeID,"HDSD00.13.01")
	set obj=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(EpisodeID,"HDSD00.13.01")
	s ChiefCom = obj.GetAt("HDSD00.13.114")   		///主诉
	s CurrentMed = obj.GetAt("HDSD00.13.095")		///现病史
	//s PastHistory = obj.GetAt("HDSD00.13.300")	///既往史 (无)
	s PastHistory = obj.GetAt("HDSD00.13.042")		///既往史 (疾病史)
	s Personal = obj.GetAt("HDSD00.13.036")   		///个人史
	s MarryHistory = obj.GetAt("HDSD00.13.041")  	///婚育史
	s Menstruation = obj.GetAt("HDSD00.13.106")   	///月经史
	s Family = obj.GetAt("HDSD00.13.043")  			///家族史	
	s Examination = obj.GetAt("HDSD00.13.301")		///obj.GetAt("HDSD00.13.088")   ///体格检查
	s Assist = obj.GetAt("HDSD00.13.035")   		///辅助检查
	s Consultations = obj.GetAt("HDSD00.13.112")    ///四诊概要
	s Specialist = obj.GetAt("HDSD00.13.118")  		///专科检查
	s Allergy = obj.GetAt("HDSD00.13.037")   		///过敏史
	s patPMDrgHisDesc = obj.GetAt("HDSD00.13.065")_obj.GetAt("HDSD00.13.066")  ///既往用药史->手术史 输血史 
	
	/*s ChiefCom  =$TR($TR($TR(ChiefCom,$C(34),"'"),"”","'"),"“","'")
	s CurrentMed =$TR($TR($TR(CurrentMed,$C(34),"'"),"”","'"),"“","'")
	s PastHistory =$TR($TR($TR(PastHistory,$C(34),"'"),"”","'"),"“","'")
	s Personal =$TR($TR($TR(Personal,$C(34),"'"),"”","'"),"“","'")
	s MarryHistory =$TR($TR($TR(MarryHistory,$C(34),"'"),"”","'"),"“","'")
	s Menstruation =$TR($TR($TR(Menstruation,$C(34),"'"),"”","'"),"“","'")
	s Family =$TR($TR($TR(Family,$C(34),"'"),"”","'"),"“","'")
	s Examination=$TR($TR($TR(Examination,$C(34),"'"),"”","'"),"“","'")
	s Assist=$TR($TR($TR(Assist,$C(34),"'"),"”","'"),"“","'")
	s Consultations=$TR($TR($TR(Consultations,$C(34),"'"),"”","'"),"“","'")
	s Specialist=$TR($TR($TR(Specialist,$C(34),"'"),"”","'"),"“","'")
	s Allergy =$TR($TR($TR(Allergy,$C(34),"'"),"”","'"),"“","'")*/
	/*
	s ChiefCom = $ZSTRIP(ChiefCom,"*C")
	s CurrentMed = $ZSTRIP(CurrentMed,"*C")
	s PastHistory = $ZSTRIP(PastHistory,"*C")
	s Personal = $ZSTRIP(Personal,"*C")
	s MarryHistory = $ZSTRIP(MarryHistory,"*C")
	s Menstruation = $ZSTRIP(Menstruation,"*C")
	s Family = $ZSTRIP(Family,"*C")
	s Examination = $ZSTRIP(Examination,"*C")
	s Assist = $ZSTRIP(Assist,"*C")
	s Consultations = $ZSTRIP(Consultations,"*C")
	s Specialist = $ZSTRIP(Specialist,"*C")
	s Allergy = $ZSTRIP(Allergy,"*C")
    s MarryHistory = MarryHistory_""_Menstruation
	*/
	set ^CacheTemp(repid, ind) = $LB(ChiefCom,CurrentMed,PastHistory,Personal,MarryHistory,Family,Menstruation,Examination,Assist,Consultations,Specialist,Allergy,patPMDrgHisDesc)
    set ind = ind + 1
    
    Quit $$$OK
}

ClassMethod GetPatRecordInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatRecordInfoExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
    }
    Else {          
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetPatRecordInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatRecordInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
