//DHCRisExamSchedule.js


function BodyLoadHandler(){
	
	var myDate=new Date();
	var dy=myDate.getDate();
	var mo=myDate.getMonth();
	var yr=myDate.getYear();
	if (mo==12){var curyr=parseInt(yr)+1;var curmo=1}else{var curyr=yr;var curmo=parseInt(mo)+1}
	var curdy=dy;
	var InitDate=curyr+"-"+curmo+"-01";
	//alert(InitDate);
	scheduler.config.xml_date="%Y-%m-%d %H:%i";
	
	scheduler.init('scheduler_here',new Date(yr,mo,1),"month");
	
	//var locId='#(LocID)#';
    //var ='#(ResRowId)#';
	//var myURL="dhcris.scheduledetail.csp?action=GetDataJSON"+ 
	//"&locId="+locId+"&resRowid="+resRowid +"&startDate="+InitDate;
	
	//alert(myURL);
	//scheduler.load(myURL,"json");
	

}

function FormatNum(Source,Length)
{ 
	var strTemp=""; 
	for(i=1;i<=Length-Source.length;i++)
	{ 
		strTemp+="0"; 
	} 
	return strTemp+Source; 
}

scheduler.attachEvent("onClick", function (event_id, native_event_object){
	//alert("event_id:"+event_id+",native_event_object="+native_event_object)
	//alert("1");
	var EventObj=scheduler.getEvent(event_id);
	/*
	for (i in EventObj) {
		alert(i+":"+EventObj[i])
	}
	*/
	var StartDay="";
	var EndDay="";
	var EventText="";
	if (EventObj){
		//StartDay=(EventObj.start_date.getFullYear()+"").substring(0,4)+"-"+(EventObj.start_date.getMonth()+1)+"-"+EventObj.start_date.getDate();
		//EndDay=(EventObj.end_date.getFullYear()+"").substring(0,4)+"-"+(EventObj.end_date.getMonth()+1)+"-"+EventObj.end_date.getDate();
		//StartDay=EventObj.start_date.getDate()+"/"+(EventObj.start_date.getMonth()+1)+"/"+(EventObj.start_date.getFullYear()+"").substring(0,4)
		//EndDay=EventObj.end_date.getDate()+"/"+(EventObj.end_date.getMonth()+1)+"/"+(EventObj.end_date.getFullYear()+"").substring(0,4)
		StartDay=(EventObj.start_date.getFullYear()+"").substring(0,4)+FormatNum((EventObj.start_date.getMonth()+1)+"",2)+FormatNum(EventObj.start_date.getDate()+"",2);
		EndDay=(EventObj.end_date.getFullYear()+"").substring(0,4)+FormatNum((EventObj.end_date.getMonth()+1)+"",2)+FormatNum(EventObj.end_date.getDate()+"",2);
	}
	//alert(StartDay);
	//alert(EndDay);
	

	//alert(PatientID+","+StartDay+","+EndDay)
	//websys.default.csp?WEBSYS.TCOMPONENT=DHCRisScheduleDetail&LocID=&ResRowId=&Stdate=&EndDate=&PatType=
	var BookDetailUrl="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisScheduleDetail&LocID="+locId+"&ResRowId="
	    +resRowid+"&Stdate="+StartDay+"&EndDate="+EndDay+"&PatType=";
	//alert(BookDetailUrl);
	window.parent.frames["BookDetail"].location.href=BookDetailUrl;
});

scheduler.showCoverNew=function(event_id){
		//alert("start");
		//return;
		var NewSchText="新建日程";
		var EventObj=scheduler.getEvent(event_id);
		
		if (EventObj.text==NewSchText) this.deleteEvent(event_id);
	
		var StartDay="";
		var EndDay="";
		var EventText="";
		if (EventObj){
			StartDay=(EventObj.start_date.getFullYear()+"").substring(0,4)+FormatNum((EventObj.start_date.getMonth()+1)+"",2)+FormatNum(EventObj.start_date.getDate()+"",2);
		EndDay=(EventObj.end_date.getFullYear()+"").substring(0,4)+FormatNum((EventObj.end_date.getMonth()+1)+"",2)+FormatNum(EventObj.end_date.getDate()+"",2);
		}
		
		
	
		//alert(PatientID+","+StartDay+","+EndDay)
		//websys.default.csp?WEBSYS.TCOMPONENT=DHCRisScheduleDetail&LocID=&ResRowId=&Stdate=&EndDate=&PatType=
		var BookDetailUrl="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisScheduleDetail&LocID="+locId+"&ResRowId="
		    +resRowid+"&Stdate="+StartDay+"&EndDate="+EndDay+"&PatType=";
		window.parent.frames["BookDetail"].location.href=BookDetailUrl;
		
		
}

function toCommonCase(Utc){
    var xYear=Utc.getYear();
    xYear=xYear;
    var xMonth=Utc.getMonth()+1;
    if(xMonth<10){xMonth="0"+xMonth;}
    var xDay=Utc.getDate();
    if(xDay<10){xDay="0"+xDay;}
    var xHours=Utc.getHours();
    if(xHours<10){xHours="0"+xHours;}
    var xMinutes=Utc.getMinutes();
    if(xMinutes<10){xMinutes="0"+xMinutes;}
    var xSeconds=Utc.getSeconds();
    if(xSeconds<10){xSeconds="0"+xSeconds;}
    return xYear+"-"+xMonth+"-"+xDay+" "+xHours+":"+xMinutes+":"+xSeconds;
}


scheduler.attachEvent("onViewChange", function (old_mode, old_date, mode , date){
       //any custom logic here
       //alert("2");
       //alert(old_mode);
       scheduler.clearAll();

       var StartDay=(old_date.getFullYear()+"").substring(0,4)+"-"+FormatNum((old_date.getMonth()+1)+"",2)+"-01";//FormatNum(old_date.getDate()+"",2);
       //alert(StartDay);
       var myURL="dhcris.scheduledetail.csp?action=GetDataJSON"+ 
	    "&locId="+locId+"&resRowid="+resRowid +"&startDate="+StartDay;
	
		//alert(myURL);
		scheduler.load(myURL,"json");
  });
  
  
  scheduler.attachEvent("onExternalDragIn", function (id, source){
         //scheduler.getEvent(id).text = source.innerHTML;
         //alert("1");
         return true;
  });
  
  scheduler.attachEvent("onBeforeDrag", function (event_id, mode, native_event_object){
       //any custom logic here
       //alert("2");
       return false;
  });