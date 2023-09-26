Class web.DHCNurInterface Extends %RegisteredObject
{

ClassMethod SaveBurnDate(adm, date, time, weight, totalArea, areaOne, areaTwo, areaThree)
{
	i (date="")!(time="") q "烧伤日期时间不能为空"
	i adm="" q "就诊号为空"
	s date=##class(websys.Conversions).DateHtmlToLogical(date)
	s time=$zth(time)
	s ^DHCNurTMPData("BurnSheet",adm)=date_"^"_time_"^"_weight_"^"_totalArea_"^"_areaOne_"^"_areaTwo_"^"_areaThree
	q "保存成功"
}

ClassMethod GetOneWeekData(Adm, index) As %String
{
	s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_Adm,""))
    i par=""  q ""
    s obj="" 
    s tmpObj=""
    s burnStr=$g(^DHCNurTMPData("BurnSheet",Adm))
    i burnStr'="" d
    .s burnDate=$p(burnStr,"^",1)
    .s burnTime=$p(burnStr,"^",2)
    s arr=##class(Nur.DHCNursePrintRec).getstdatetim("DHCNURBURN",Adm)
    i arr=""
    i ($g(burnDate)="")&($g(burnTime)="")
    {
	    s ret=##class(web.DHCMGNurComm).PatInfo(Adm)
		s admDate=$p($p(ret,"^",15),"@",2)
		s admTime=$p($p(ret,"^",16),"@",2)
		s startDate=admDate
		s startTime=admTime
    }
    else
    {

		//s startDate=$P(arr,"^",3)
		//s startTime=$P(arr,"^",4)
		s startDate=$zd(burnDate,3)
 		s startTime=$zt(burnTime,1)
 		
    }
    s startDate=$ZDH(startDate,3)
	//s startTime=$ZTH(startTime,3)
    i ($g(burnDate)'="")&($g(burnTime)'="")
    {
	    s burnTime=$zt(burnTime,1)
	    i (((startDate-burnDate)=1)&((+startTime)<(+burnTime)))!((startDate=burnDate)&((+startTime)>=(+burnTime))) d
	    .s startDate=burnDate
	    .s startTime=burnTime
    }
    s compareDate=startDate+index-1
	f date=(compareDate):1:(compareDate+1)
	{
        s time="" f  s time=$O(^Nur.DHCNurseRecSubI("TypDatTim"," DHCNURBURN",date,time)) q:time=""  d
        .s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypDatTim"," DHCNURBURN",date,time,par,rw)) q:rw=""  d
        ..s tmpTime=time
        ..s tmpTime=$zt(tmpTime,1)
        ..s tmpTime=+tmpTime
        ..q:(date=compareDate)&&(tmpTime<+startTime)
        ..q:(date>compareDate)&&(tmpTime>=+startTime)
        ..s tmp=""
        ..s ret=##class(Nur.DHCNurseRecSub).getVal(par_"||"_rw,.tmp)
        ..q:$g(tmp("RecCancelUser"))'=""
		..s ret=..getRet(date,time,.tmp,.obj,.tmpObj)
	 }
	 s ret=""
	 s code=""
	 f  s code=$o(obj(code)) q:code=""  d
	 .q:code'["Item"
	 .s date=""
	 .f  s date=$o(obj(code,date)) q:date=""  d
	 ..s time=""
	 ..f  s time=$o(obj(code,date,time)) q:time=""  d
	 ...i compareDate=date s pos=+$p($zt(time),":")-(+startTime)
	 ...i compareDate<date s pos=24-((+startTime)-(+$p($zt(time),":"))) 
	 ...q:$g(obj(code,date,time))=""
	 ...i code="Item3" d
	 ....i $g(obj("Item48",date,time))  d
	 .....i +obj("Item48",date,time)'=0 s pos=pos_"^"_obj("Item48",date,time)
	 ...i $g(obj(code))="" s obj(code)=code_"$"_obj(code,date,time)_"^"_pos
	 ...e  s obj(code)=obj(code)_"#"_obj(code,date,time)_"^"_pos
	 .q:$g(obj(code))=""
	 .i ret="" s ret=obj(code)
	 .e  s ret=ret_"!"_$g(obj(code))
	 s drugStr=""
	 s date=""
	 s posX=""
	 s posY=""
	 f  s date=$o(tmpObj(date)) q:date=""  d
	 .s time="" 
	 .f  s time=$o(tmpObj(date,time)) q:time=""  d
	 ..i ($d(tmpObj(date,time,"Item36")))&(($d(tmpObj(date,time,"Item37")))) d
	 ...i compareDate=date s posX=+$p($zt(time),":")-(+startTime)
	 ...i compareDate<date s posX=24-(+startTime)+(+$p($zt(time),":"))
	 ...s posY=0
	 ...i drugStr="" s drugStr="Item36$"_tmpObj(date,time,"Item36")_"^"_tmpObj(date,time,"Item37")_"^"_posX_"^"_posY
	 ...e  s drugStr=drugStr_"#"_tmpObj(date,time,"Item36")_"^"_tmpObj(date,time,"Item37")_"^"_posX_"^"_posY
	 ..i ($d(tmpObj(date,time,"Item38")))&($d(tmpObj(date,time,"Item39"))) d
	 ...i compareDate=date s posX=+$p($zt(time),":")-(+startTime)
	 ...i compareDate<date s posX=24-(+startTime)+(+$p($zt(time),":"))
	 ...s posY=1
	 ...i drugStr="" s drugStr="Item36$"_tmpObj(date,time,"Item38")_"^"_tmpObj(date,time,"Item39")_"^"_posX_"^"_posY
	 ...e  s drugStr=drugStr_"#"_tmpObj(date,time,"Item38")_"^"_tmpObj(date,time,"Item39")_"^"_posX_"^"_posY
	 i (drugStr'="")&(ret'="") s ret=ret_"!"_drugStr
	 i (ret="")&(drugStr'="") s ret=drugStr
	 
	 
	 q ret
}

ClassMethod GetPatInfo(adm, index As %String = 1) As %String
{
	s startDate=""
	s startTime=""
    s burnDate=""
	s burnTime=""
	s ret=##class(web.DHCMGNurComm).PatInfo(adm)
	s patName=$p($p(ret,"^",5),"@",2)
	s sex=$p($p(ret,"^",4),"@",2)
	s age=$p($p(ret,"^",7),"@",2)
	s bedCode=$p($p(ret,"^",6),"@",2)
	s wardDesc=$p($p(ret,"^",8),"@",2)
	s medNo=$p($p(ret,"^",10),"@",2)
	s admDate=$p($p(ret,"^",15),"@",2)
	s admTime=$p($p(ret,"^",16),"@",2)
    s burnStr=$g(^DHCNurTMPData("BurnSheet",adm))
    i burnStr'="" d
    .s burnDate=$p(burnStr,"^",1)
    .s burnTime=$p(burnStr,"^",2)
    .s weight=$p(burnStr,"^",3)
    .s totalArea=$p(burnStr,"^",4)
    .s areaOne=$p(burnStr,"^",5)
    .s areaTwo=$p(burnStr,"^",6)
    .s areaThree=$p(burnStr,"^",7)
	s arr=##class(Nur.DHCNursePrintRec).getstdatetim("DHCNURBURN",adm)
	i arr=""
	 i ($g(burnDate)="")&($g(burnTime)="")
	{
		s startDate=admDate
		s startTime=admTime
	}
	else
	{
 		s startDate=$P(arr,"^",3)
 		s startTime=$P(arr,"^",4)
 		i burnDate'=""  d
 		.s startDate=$zd(burnDate,3)
 		.s startTime=$zt(burnTime,1)

	}
	
	i startDate'=""	 s startDate=$ZDH(startDate,3)
	//s startTime=$ZTH(startTime,3)
    i ($g(burnDate)'="")&($g(burnTime)'="")
    {
	    s burnTime=$zt(burnTime,1)
	    i (((startDate-burnDate)=1)&((+startTime)<(+burnTime)))!((startDate=burnDate)&((+startTime)>=(+burnTime))) d
	    .s startDate=burnDate
	    .s startTime=burnTime
	    .i index=1 s burnMessage="烧伤时间"
    }
	//s startTime=$ZT(startTime)
	s pageDate=startDate+index-1
	s pageDate=$zd(pageDate,3)
	s startTime=+startTime
	i startTime=0 s startTime=24
	s inDays=startDate+index-$zdh(admDate,3)
	i $g(burnDate)'="" s burnDays=startDate-burnDate+index
	s startDate=$ZD(startDate,3)
    i ($g(burnDate)'="")&($g(burnTime)'="")
    {
	    s burnDate=$zd(burnDate,3)
	    s burnTime=$zth(burnTime,1)
	    s burnTime=$zt(burnTime,2)
    }
    s curTime=+($zt($p($h,",",2)))
    i curTime=0 s curTime=24
    i curTime>=startTime d 
    .s startDateExt=$zd(+$h,3)
    .s endDate=$zd(+$h+1,3)

    e  d 
    .s startDateExt=$zd(+$h-1,3)
	.s endDate=$zd(+$h,3)
	s ret="姓名:"_patName_
	"^性别:"_sex_
	"^年龄:"_age_
	"^床号:"_bedCode_
	"^住院号:"_medNo_
	"^病区:"_wardDesc_
	"^日期:"_pageDate_
	"@"_startTime_
	"@"_startDate_
	"@"_
	"烧伤日数:"_$g(burnDays)_
	"^住院日数:"_inDays_
	"^体重:"_$g(weight)_"公斤"_
	"^总面积:"_$g(totalArea)_"%"_
	"^一度:"_$g(areaOne)_"%"_
	"^二度:"_$g(areaTwo)_"%"_
	"^三度:"_$g(areaThree)_"%"_
	"@"_$g(burnMessage)_
	"@"_$g(burnDate)_
	"@"_$g(burnTime)_
	"@"_startDateExt_
	"@"_endDate_
	"@"_$g(weight)_
	"@"_$g(totalArea)_
	"@"_$g(areaOne)_
	"@"_$g(areaTwo)_
	"@"_$g(areaThree)
	q ret
}

ClassMethod getRet(date, time, tmp, obj, tmpObj) As %String
{
	s code=""
	f  s code=$o(tmp(code)) q:code=""  d
	.q:code'["Item"
	.q:tmp(code)=""
	.i (code="Item36")!(code="Item37")!(code="Item38")!(code="Item39") s tmpObj(date,time,code)=tmp(code)
	.e  s obj(code,date,time)=tmp(code)
	q 0
}

ClassMethod GetPatHospitalDesc(admId As %String) As %String
{
	q:admId="" ""
	s ctlocId=$p(^PAADM(admId),"^",4)
    s hospital=""
    i ctlocId'=""  d
    .s hospital=##class(web.DHCMGNurComm).gethospital(ctlocId)
	q hospital
}

/// Creator:      songchao
/// CreateDate:   2018.3.14
/// Description:  获取第一次的生命体征值
/// Input:       episodeID:就诊号, itemCode:生命体征代码
/// Return:       
/// Other:        ##Class(Nur.CommonInterface.Temperature).getFirstItemValue("17","weight")
ClassMethod getFirstItemValue(episodeID, itemCode)
{
	s mrAdmID=$P(^PAADM(episodeID),"^",61)
	s itemID=$o(^MRC("OBITM",0,"Code",$$ALPHAUP^SSUTIL4(itemCode),""))
	s date="" f  s date=$o(^MR(mrAdmID,"OBS",0,"Item",itemID,date)) q:(date="")!($g(findFlag)=1)  d
	.s time="" f  s time=$o(^MR(mrAdmID,"OBS",0,"Item",itemID,date,time)) q:(time="")!($g(findFlag)=1)  d
	..s obsID=$o(^MR(mrAdmID,"OBS",0,"Item",itemID,date,time,""))
	..q:obsID=""
	..s value=$P(^MR(mrAdmID,"OBS",obsID),"^",2)
	..s findFlag=1
	q $g(value)
}

}
