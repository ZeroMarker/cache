Class web.UDHCANVitalSign Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetByOpaAndDateTime(opaID As %String, startUDate As %String, startUTime As %String, endUDate As %String, endUTime As %String)
{
 new query,strsql
 k %msql
 k ^tmpAnOp("VitalSign",$j)
 k ^tmpAnOp("VitalSignRet",$j)
 //
 
 /*m ^tmpAnOp("VitalSignRet",$j)=^tmpAnOp("VitalSignRet",3476)
 f i=1:1:4 d
     .s $p(^tmpAnOp("VitalSignRet",$j,i),"^",2)=startUDate
     .s $p(^tmpAnOp("VitalSignRet",$j,i),"^",3)=startUTime
 q 4*/
 
 
 s i=0 
 s startUDate=$zdh(startUDate,3)
 s endUDate=$zdh(endUDate,3)
 
 s startUTime=$zth(startUTime,3)
 s endUTime=$zth(endUTime,3)
 Set query = ##class(%ResultSet).%New("%DynamicQuery:SQL")
 set strsql="SELECT ANVS_RowId,ANVS_ANVS_DR,ANVS_Date,ANVS_EditFlag,ANVS_MDataItem_Dr,ANVS_Reason,ANVS_Source,ANVS_Flag,ANVS_Time,ANVS_UOM_Dr,ANVS_UpdateDate,ANVS_UpdateTime,ANVS_User_Dr,ANVS_Val,ANVS_ViewCat_Dr FROM SQLUser.DHC_AN_VitalSign WHERE (ANVS_OPA_Dr= :opaID)"
 Do query.Prepare(strsql)
 Do query.Execute()
 WHILE (query.Next()=1)
 {
	 //w "."
 s dept="",pri="",usr="",date="",deptID="",priID=""
 s ANVSUDate=query.GetDataByName("ANVS_UpdateDate")
 s ANVSUTime=query.GetDataByName("ANVS_UpdateTime")
 s ANVSDate=query.GetDataByName("ANVS_Date")
 s ANVSTime=query.GetDataByName("ANVS_Time")
 //判断记录修改时间是否在给定的时间段内,是则加到^tmpAnOp("VitalSign")中
 s quitFlag=0
 i (ANVSUDate<startUDate)!(ANVSUDate>endUDate) s quitFlag=1
 i (ANVSUDate=startUDate)&(ANVSUTime'>startUTime) s quitFlag=1
 i (ANVSUDate=endUDate)&(ANVSUTime>endUTime) s quitFlag=1
 i quitFlag=0 d
     .q:query.GetDataByName("ANVS_EditFlag")="D"
     .s monId=+query.GetDataByName("ANVS_MDataItem_Dr")
     .s tmpStr=$p($g(^DHCANC("MDataItem",monId)),"^",2)_"^"_$ZD(query.GetDataByName("ANVS_Date"),3)_"^"
     .s tmpStr=tmpStr_$ZT(query.GetDataByName("ANVS_Time"))_"^"
     .s tmpStr=tmpStr_query.GetDataByName("ANVS_Val")_"^"
     .s tmpStr=tmpStr_$p($g(^CT("UOM",+query.GetDataByName("ANVS_UOM_Dr"))),"^",2)_"^"
     .s tmpStr=tmpStr_query.GetDataByName("ANVS_Source")_"^"
     .s tmpStr=tmpStr_query.GetDataByName("ANVS_Flag")_"^"
     .s tmpStr=tmpStr_query.GetDataByName("ANVS_User_Dr")_"^"
     .s tmpStr=tmpStr_$ZD(query.GetDataByName("ANVS_UpdateDate"),3)_"^"
     .s tmpStr=tmpStr_$ZT(query.GetDataByName("ANVS_UpdateTime"))_"^"
     .s tmpStr=tmpStr_query.GetDataByName("ANVS_EditFlag")_"^"
     .s tmpStr=tmpStr_query.GetDataByName("ANVS_Reason")_"^"
     .s tmpStr=tmpStr_query.GetDataByName("ANVS_ANVS_DR")_"^"
     .s ancvcId=query.GetDataByName("ANVS_ViewCat_Dr")
     .s ancvcDesc=""
     .i ancvcId="" s ancvcId=$p(^DHCANC("MDataItem",monId),"^",5)
     .i ancvcId'="" s ancvcDesc=$p($g(^DHCANC("ViewCat",ancvcId)),"^",2)
     .s tmpStr=tmpStr_ancvcId_"^" //tmpStr_ancvcDesc_"^"
     .s anvsId=query.GetDataByName("ANVS_RowId")
     .s ^tmpAnOp("VitalSign",$j,monId,ANVSUDate,ANVSUTime,anvsId)=tmpStr_query.GetDataByName("ANVS_RowId")
 }
 //将^tmpAnOp("VitalSign")转成^tmpAnOp("VitalSignRet",$j,i),方便客户端程序取值
 s monId="" f  s monId=$o(^tmpAnOp("VitalSign",$j,monId)) q:monId=""  d
 .s dat="" f  s dat=$o(^tmpAnOp("VitalSign",$j,monId,dat))  q:dat=""  d
 ..s tim="" f  s tim=$o(^tmpAnOp("VitalSign",$j,monId,dat,tim))  q:tim=""  d
 ...s anvsId="" f  s anvsId=$o(^tmpAnOp("VitalSign",$j,monId,dat,tim,anvsId))  q:anvsId=""  d
 ....s i=i+1
 ....s ^tmpAnOp("VitalSignRet",$j,i)=^tmpAnOp("VitalSign",$j,monId,dat,tim,anvsId)
 ....w ^tmpAnOp("VitalSignRet",$j,i),!
 Quit i
}

ClassMethod getItems(i As %Library.String, j As %Library.String) As %Library.List
{
 //i为本次取值的开始Number,j为要取的行数	
 s k=0,returnList=""
 f k=i:1:(i+j) d
 .i $d(^tmpAnOp("VitalSignRet",$j,k))=1 d
 ..s returnList=returnList_$LB($LB(^tmpAnOp("VitalSignRet",$j,k)))
 ..k ^tmpAnOp("VitalSignRet",$j,k)
 q returnList
}

Query SelectAll() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,ANVS_ANVS_DR,ANVS_Date,ANVS_EditFlag,ANVS_MDataItem_Dr,"ANVS_OPA_Dr->ID","ANVS_OPA_Dr->OPA_Adm_dr",ANVS_Reason,ANVS_Source,ANVS_Time,ANVS_UOM_Dr,ANVS_UpdateDate,ANVS_UpdateTime,ANVS_User_Dr,ANVS_Val FROM SQLUser.DHC_AN_VitalSign
}

Storage Default
{
<Data name="UDHCANVitalSignDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.UDHCANVitalSignD</DataLocation>
<DefaultData>UDHCANVitalSignDefaultData</DefaultData>
<IdLocation>^web.UDHCANVitalSignD</IdLocation>
<IndexLocation>^web.UDHCANVitalSignI</IndexLocation>
<StreamLocation>^web.UDHCANVitalSignS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
