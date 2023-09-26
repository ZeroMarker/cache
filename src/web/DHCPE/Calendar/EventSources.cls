/// Descript: 日历 日程对象源
/// Creator:wangguoying
Class web.DHCPE.Calendar.EventSources Extends %RegisteredObject
{

/// Description:获取号源池Event数组
/// Input:
///                         BeginDate：开始日期
///                         EndDate：结束日期
/// 							PreClass：号源类型 I：内部号源  O：外部号源
///                         PreIADM：DHC_PE_PreIADM
/// 							ExtStr：拓展串  性别ID^VIPID^PGADM
/// Return:       
/// Creator:    wangguoying
/// CreateDate: 2023-02-02
/// Debug: w ##class(web.DHCPE.Calendar.EventSources).GetDataSourceEventArr(66060,66060,"1434",11849)
ClassMethod GetDataSourceEventArr(BeginDate, EndDate, PreClass, PreIADM = "", ExtStr = "", LocID = "") As %DynamicArray
{
    s arr = []
    s sexId = "",levelId="",pgid=""
    i PreIADM'=""
    {
    	s LocID = $P($g(^DHCPEPreIADM(PreIADM)),"^",26)
    	s pibi = $P($g(^DHCPEPreIADM(PreIADM)),"^",1)
        s sexId = $P($g(^DHCPEPreIBI(pibi)),"^",3) 
        s levelId = $P($g(^DHCPEPreIADM(PreIADM)),"^",18)
        s pgid = $P($g(^DHCPEPreIADM(PreIADM)),"^",2)
    }else{
    	s sexId = $P(ExtStr,"^",1)
        s levelId = $P(ExtStr,"^",2)
        s pgid = $P(ExtStr,"^",3)
    }
    s pmType = $CASE(pgid="",1:"I",:"G")
    f date = BeginDate:1:EndDate
    {
        continue:date<+$H
        s dateStr = ##class(websys.Conversions).DateLogicalToHtml(date)
        s mId = $O(^User.DHCPESourceManagerI("IndOfLocClassDate",LocID,PreClass,date,""))
        continue:mId=""
        continue:$LG(^User.DHCPESourceManagerD(mId),8)="Y"  //停诊
        Set startTime = 0
	    For {
		    Set startTime = $ORDER(^User.DHCPESourceTimeManagerI("IndOfSTime",mId,startTime))  
		    Quit:startTime=""  
	    	Set sub = ""
	    	For  {
		    	Set sub = $ORDER(^User.DHCPESourceTimeManagerI("IndOfSTime",mId,startTime,sub))  
	    		Quit:sub=""  
	    		Set endTime = $LISTGET(^User.DHCPESourceManagerD(mId,"SMTime",sub),9)
	    		Set availNum = ##class(web.DHCPE.SourceManager).GetAvailNum(mId_"||"_sub,sexId,pmType,levelId)
	    		s:availNum=99999 ^tmpwgy(99999) = $lb(mId_"||"_sub,sexId,pmType,levelId)
        		s obj = {}
        		s color = "#fff6f6",selectable=0
        		i availNum>0
        		{
            		s obj = {}
            		
            		s remainderEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.predate.select.csp","余:")
 					s obj.title = $ZT(startTime)_"-"_$ZT(endTime)_" <label class='numTag'>"_remainderEng_availNum_"</label>"
 					
            		//s obj.title = $ZT(startTime)_"-"_$ZT(endTime)_" <label class='numTag'>余:"_availNum_"</label>"
            		s obj.selectable = 1
            		s obj.type = "SELECT"
            		s obj.detailId = mId_"||"_sub
            		//s obj.color = "green"
            		//s obj.classNames = "black-txt"
            		s obj.display = "block"
            		s obj.start = $ZD(date,3)_"T"_ $ZT(startTime)  //'2020-09-06T10:00:00',
            		s obj.end = $ZD(date,3)_"T"_ $ZT(endTime)  //'2020-09-06T10:00:00',
            		d arr.%Push(obj)
        		}    
	    	}
	    }   
    }
    q arr
}

}
