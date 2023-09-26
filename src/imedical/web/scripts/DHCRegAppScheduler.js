
var DateList=null;
function BodyLoadHandler(){
	//scheduler.init('scheduler_here',null,"month");
	//scheduler.setLoadMode("month");
	//scheduler.config.show_loading=true;
	//scheduler._render_wait=true;
	//隐藏日,周的tab
	scheduler.templates.month_date_class=function(date,today){
		var date=toCommonCase(date).split(' ')[0];
		if (DateList == null){
			var StartDate=toCommonCase(scheduler.getState().min_date).split(' ')[0];
			//var EndDate=toCommonCase(scheduler.getState().max_date).split(' ')[0];
			//alert(StartDate+","+LogonLocId+","+DocId+","+MarkDocID)
			DateList=tkMakeServerCall("web.DHCBL.Doctor.AppointOral","GetDateList",StartDate,LogonLocId,DocId,MarkDocID,MarkOther);
		}
		if (DateList.indexOf(date)>=0){
			return "haveSche";	
		}
		return "";
	}
	scheduler.attachEvent("onViewChange", function(event_id, event_object){  
	    DateList=null;
	});
	
	
	var bodyItemsObj=document.body.getElementsByTagName("div");
	for (var i=0;i<bodyItemsObj.length;i++) {
		var ItemObj=bodyItemsObj[i];
		var ItemObjName="";
		if (ItemObj) ItemObjName=ItemObj.getAttribute("name");
		if ((ItemObjName=="day_tab")||(ItemObjName=="week_tab")) {
			ItemObj.style.display='none';
		}
	}
	
	///lxz 清除
	var Obj=document.getElementById("Clear");
	if (Obj){
		Obj.onclick=Clear;
	}
	
	//lxz 封装加载
	ReloadScheduler()
	/*
	var myDate=new Date();
	var dy=myDate.getDate();
	var mo=myDate.getMonth();
	var yr=myDate.getFullYear();
	if (mo==12){var curyr=parseInt(yr)+1;var curmo=1}else{var curyr=yr;var curmo=parseInt(mo)+1}
	var curdy=dy;
	var InitDate=curyr+"-"+curmo+"-01"
	
	scheduler.config.xml_date="%Y-%m-%d %H:%i";
	scheduler.init('scheduler_here',new Date(yr,mo,1),"month");
	var myURL="dhc.reg.appschedulerdata.csp?action=GetDataJSON&InitDate="+InitDate;
	myURL +="&PatientID="+PatientID;
	myURL +="&LogonLocId="+LogonLocId;
	myURL +="&DocId="+DocId;
	scheduler.load(myURL,"json");
	*/

}


//lxz ---清除
function Clear()
{
	document.getElementById("OCTloc").value="";
	document.getElementById("OCTLocRowid").value="";
	combo_OtherMark.setComboText(''); 
	combo_OtherMark.setComboValue('');
	//combo_OtherLoc.setComboText(''); 
	//combo_OtherLoc.setComboValue('');
	combo_MarkDoc.setComboText(''); 
	combo_MarkDoc.setComboValue('');
	scheduler.clearAll()
	
	var Obj=window.frames["AppDetail"].document.getElementById("PatientID")
	if (Obj){Obj.value=""}
	var Obj=window.frames["AppDetail"].document.getElementById("Papmino")
	if (Obj){Obj.value=""}
	var Obj=window.frames["AppDetail"].document.getElementById("Name")
	if (Obj){Obj.value=""}
	var Obj=window.frames["AppDetail"].document.getElementById("MarkDocID")
	if (Obj){Obj.value=""}
	var Obj=window.frames["AppDetail"].document.getElementById("RBResID")
	if (Obj){Obj.value=""}
	
	MarkOther=""
	MarkDocID=""
	
	
}
//加载日历

function ReloadScheduler(){
	var myDate=new Date();
	var dy=myDate.getDate();
	var mo=myDate.getMonth();
	var yr=myDate.getFullYear();
	if (mo==12){var curyr=parseInt(yr)+1;var curmo=1}else{var curyr=yr;var curmo=parseInt(mo)+1}
	var curdy=dy;
	var InitDate=curyr+"-"+curmo+"-01"
	scheduler.config.xml_date="%Y-%m-%d %H:%i";
	scheduler.init('scheduler_here',new Date(yr,mo,1),"month");
	var myURL="dhc.reg.appschedulerdata.CSP?action=GetDataJSON&InitDate="+InitDate;
	myURL +="&PatientID="+PatientID;
	myURL +="&LogonLocId="+LogonLocId;
	myURL +="&DocId="+BackDocId;
	myURL +="&MarkDocID="+MarkDocID;
	myURL +="&MarkOtherID="+MarkOther;
	myURL +="&USERID="+session['LOGON.USERID'];
	scheduler.clearAll()
	//window.setTimeout("scheduler.load('"+myURL+"','"+"json"+"');",200);
	scheduler.load(myURL,"json");
}
scheduler.attachEvent("onBeforeDrag", function (event_id, native_event_object){
	return false;
})

scheduler.attachEvent("onClick", function (event_id, native_event_object){
	//alert("event_id:"+event_id+",native_event_object="+native_event_object)
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
		var StYear=(EventObj.start_date.getFullYear()+"").substring(0,4);
		var StMonth=EventObj.start_date.getMonth()+1;
		if (+StMonth<=9){
			StMonth="0"+StMonth;
		}
		var StDay=EventObj.start_date.getDate();
		if (+StDay<=9){
			StDay="0"+StDay;
		}
		var EndYear=(EventObj.end_date.getFullYear()+"").substring(0,4);
		var EndMonth=EventObj.end_date.getMonth()+1;
		if (+EndMonth<=9){
			EndMonth="0"+EndMonth;
		}
		var EndDay=EventObj.end_date.getDate();
		if (+EndDay<=9){
			EndDay="0"+EndDay;
		}
		
		if (DateFormat=="4"){
			StartDay=StDay+"/"+StMonth+"/"+StYear;
			EndDay=EndDay+"/"+EndMonth+"/"+EndYear;
		}else if (DateFormat=="3"){
			StartDay=StYear+"-"+StMonth+"-"+StDay;
			EndDay=EndYear+"-"+EndMonth+"-"+EndDay;
		}else if (DateFormat=="1"){
			StartDay=StMonth+"/"+StDay+"/"+StYear;
			EndDay=EndMonth+"/"+EndDay+"/"+EndYear;;
		}
		
	}
	
	//lxz 如果提前读取患者信息需要带入
	var PatientID=""
	var Obj=window.frames["AppDetail"].document.getElementById("PatientID")
	if (Obj){PatientID=Obj.value}
	var Papmino=""
	var Obj=window.frames["AppDetail"].document.getElementById("Papmino")
	if (Obj){Papmino=Obj.value}
	var Name=""
	var Obj=window.frames["AppDetail"].document.getElementById("Name")
	if (Obj){Name=Obj.value}
	
	var AppDetailUrl="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPDoc.CalendarAppoint&PatientID="+PatientID+"&StartDay="+StartDay+"&EndDay="+EndDay+"&LogonLocId="+LogonLocId+"&DocId="+BackDocId+"&Papmino="+Papmino+"&Name="+Name+"&MarkDocID="+MarkDocID+"&RBResID="+MarkOther;
	window.frames["AppDetail"].location.href=AppDetailUrl;
});
scheduler.showCoverNew=function(event_id){
		var NewSchText="新建日程";
		var EventObj=scheduler.getEvent(event_id);
		var InputPatientID="";
		if (window.frames["AppDetail"]) {
			var ObjAppDetailPatID=window.frames["AppDetail"].document.getElementById("PatientID")
			if (ObjAppDetailPatID) InputPatientID=ObjAppDetailPatID.value;
			
		}
		if (InputPatientID!="") PatientID=InputPatientID;
		if(PatientID==""){
		  //alert("请选择一个病人");
		  //this.deleteEvent(event_id);
		  //return;
		}
		
		var StartDate=this.getEventStartDate(event_id);
		var EndDate=this.getEventEndDate(event_id);
		StartDate=toCommonCase(StartDate).split(' ')[0];
		EndDate=toCommonCase(EndDate).split(' ')[0];
		//alert(StartDate+","+(EndDate))
		
		var LogonLocId=session['LOGON.CTLOCID'];
		var LogonUserId=session['LOGON.USERID'];
		//判断是否有出诊记录——lxz 有号别用号别判断没有号别按照所有判断
		
		//lxz 必须选择号别
		if ((MarkDocID=="")&&(MarkOther=="")){
			alert("请选择号别!")
			if (EventObj.text==NewSchText) this.deleteEvent(event_id);
			return
		} 
		var ASRowId=""
		if (MarkOther!=""){
			var ASRowId=cspRunServerMethod(GetAvailRA,MarkOther,StartDate,"","","N");
		}else if (MarkDocID!=""){
			var ASRowId=cspRunServerMethod(GetTodayASRowIdByResMethod,LogonLocId,MarkDocID,"",StartDate);
		}else{
			var ASRowId=cspRunServerMethod(GetTodayAllASRowIdByResMethod,LogonLocId,DocId,"",StartDate);
		}
		
		if (ASRowId=="") {
			//既然选择了日期就没有必要去只找最后一个排班记录
			//如果没有当前星期的排班记录,则不允许产生
			/*
			var IsScheduleFlag=cspRunServerMethod(GetIsScheduleFlagMethod,LogonLocId,DocId,StartDate);
			if (IsScheduleFlag=="0") {
				alert("您在"+StartDate+"对应的星期没有排班.");
				if (EventObj.text==NewSchText) this.deleteEvent(event_id);
				return;
			}else if (IsScheduleFlag=="-1") {
				alert("您在"+StartDate+"对应的排班已经停诊.");
				if (EventObj.text==NewSchText) this.deleteEvent(event_id);
				return;
			}
			*/
			//lxz 不去在判断GetIsScheduleFlagMethod知道没有排班记录即可
			var tmpStartDate=StartDate;
			if (websys_DateFormat=="j/n/Y"){
				var tmpStartDate=StartDate.split("-")[2]+"/"+StartDate.split("-")[1]+"/"+StartDate.split("-")[0];
			}
			alert("您在"+tmpStartDate+"缺少对应的出诊记录.");
			if (EventObj.text==NewSchText) this.deleteEvent(event_id);
			return;
			
			/*
			var ScheduleTRangeStr=cspRunServerMethod(GetScheduleTRangeStrMethod,LogonLocId,DocId,StartDate);
			if (ScheduleTRangeStr!="") {
				if (IsScheduleFlag=="2") {
					var conflag=true;
				}else{
					var conflag=confirm("您在"+StartDate+"没有出诊记录,是否按排班模板产生该天的出诊记录?");
				}
				if (conflag) {
					var ScheduleTRangeAry=ScheduleTRangeStr.split("^");
					for (var i=0;i<ScheduleTRangeAry.length;i++) {
						var TimeRangeItem=ScheduleTRangeAry[i];
						var TimeRangeId=TimeRangeItem.split(String.fromCharCode(2))[0];
						var TimeRangeDesc=TimeRangeItem.split(String.fromCharCode(2))[1];
						var ASRowId=cspRunServerMethod(GetRapidASRowIdMethod,LogonLocId,LogonUserId,"",StartDate,TimeRangeId);
						if (ASRowId==""){
							alert("产生出诊记录失败,请确认是否曾经有过排班?");
							if (EventObj.text==NewSchText) this.deleteEvent(event_id);
							return;
						}
					}
				}else{
					if (EventObj.text==NewSchText) this.deleteEvent(event_id);
					return;
				}
			}else{
				alert("排班模板未维护时段,请联系排班护士维护.");
				if (EventObj.text==NewSchText) this.deleteEvent(event_id);
				return;
			}
			*/
			/*
			var Rtn=window.showModalDialog("websys.default.csp?WEBSYS.TCOMPONENT=DHCOPDoc.RBASTimeRangeSel&AsDate="+StartDate,"","dialogwidth:30;dialogheight:30;status:no;center:1;resizable:yes");
			if ((Rtn!=null)&&(Rtn!="")) {
				//没有出诊记录则插入不规则记录
				var TimeRangeId=Rtn;
				var ASRowId=cspRunServerMethod(GetRapidASRowIdMethod,LogonLocId,LogonUserId,"",StartDate,TimeRangeId);
				if (ASRowId==""){
					alert("产生出诊记录失败,请确认是否曾经有过排班?");
					if (EventObj.text==NewSchText) this.deleteEvent(event_id);
					return;
				}
			}else{
				if (EventObj.text==NewSchText) this.deleteEvent(event_id);
				return;
			}
			*/
		}else{
			/*
			//add by guorongyong 2012.10.09 处理有出诊记录,但没有按模板产生完全,在此产生完全
			var ScheduleTRangeStr=cspRunServerMethod(GetScheduleTRangeStrMethod,LogonLocId,DocId,StartDate);
			if (ScheduleTRangeStr!="") {
				var ScheduleTRangeAry=ScheduleTRangeStr.split("^");
				for (var i=0;i<ScheduleTRangeAry.length;i++) {
					var TimeRangeItem=ScheduleTRangeAry[i];
					var TimeRangeId=TimeRangeItem.split(String.fromCharCode(2))[0];
					var TimeRangeDesc=TimeRangeItem.split(String.fromCharCode(2))[1];
					var ASRowId=cspRunServerMethod(GetTodayASRowIdByResMethod,LogonLocId,DocId,"",StartDate,TimeRangeId);
					if (ASRowId=="") {
						//如果没有当前星期的排班记录,则不允许产生
						var IsScheduleFlag=cspRunServerMethod(GetIsScheduleFlagMethod,LogonLocId,DocId,StartDate,TimeRangeId);
						if (IsScheduleFlag=="0") {
							alert("您在"+StartDate+"对应的星期没有排班,不能提前生成出诊记录.");
							if (EventObj.text==NewSchText) this.deleteEvent(event_id);
							continue;
						}else if (IsScheduleFlag=="-1") {
							alert("您在"+StartDate+TimeRangeDesc+"对应的排班已经停诊.");
							if (EventObj.text==NewSchText) this.deleteEvent(event_id);
							continue;
						}
						var ASRowId=cspRunServerMethod(GetRapidASRowIdMethod,LogonLocId,LogonUserId,"",StartDate,TimeRangeId);
						if (ASRowId==""){
							alert("产生出诊记录失败,请确认是否曾经有过排班?");
							if (EventObj.text==NewSchText) this.deleteEvent(event_id);
							continue;
						}
					}
				}
			}
			*/
		}
		
		//自动将选中的患者带过去
		var frm=dhcsys_getmenuform();
		if ((frm.PatientID)&&(PatientID=="")){
			PatientID=frm.PatientID.value
		}
		
		
		var DocAppUrl="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPDoc.Appoint&PatientID="+PatientID+"&StartDate="+StartDate+"&EndDate="+EndDate+"&DocMarkDr="+MarkDocID+"&RBResRowid="+MarkOther;
		var AppSearchUrl="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPAdm.Appointment&PatientID="+PatientID+"&StartDay="+StartDate+"&EndDay="+EndDate;
		if (EventObj.text==NewSchText) this.deleteEvent(event_id);

		var tablepanel = new Ext.TabPanel({
			//renderTo:'showCoverNew',	
			//srcElementId:'showCoverNew',
			id: 'mainTab',					
			width: 900,
			height: 500,
		    frame: true,
			autoScroll:true,
			x: 100,
			y: 100,
			activeTab:0,
			items:
			[
				{
					  title: '预约',
					  id:"DocApp",
					  //autoLoad: 
					  html:'<iframe name="DocApp" src="'+DocAppUrl+'" width="98%" height="85%"></iframe>'
				},
				{
					  title: '取消预约',
					  id:"AppSearch",
					  //autoLoad:"websys.default.csp?WEBSYS.TCOMPONENT=DHCLONGTIMEORDDOC&Adm="+#(%request.Get("EpisodeID"))#+"&IsOn=1"
					  html:'<iframe name="AppSearch" src="'+AppSearchUrl+'" width="98%" height="85%"></iframe>'
				}
			]
		});
		
		var _window=new Ext.Window({   
        title:"预约管理",   
        width:900,   
        height:500,  
        plain:true,   
        items:[   
            tablepanel   
        ],   
		maximizable:true,
		listeners:{
			maximize:function(a,b,c){
		     var width=this.getWidth();
			 var height=this.getHeight();
			 Ext.getCmp("mainTab").setWidth(width-10);
			 Ext.getCmp("mainTab").setHeight(height-10);
			},
			restore:function(a,b,c){		   
				Ext.getCmp("mainTab").setWidth(900);
				Ext.getCmp("mainTab").setHeight(500);
			}
		},
        buttons:[   
            {
            	text:"确定",
            	iconCls: "page_save",
            	handler:function(){
            		_window.close();
            	}
            },   
            {
            	text:"取消",
            	iconCls: "page_close",
            	handler:function(){
            		_window.close();
            	}
            }   
        ]   
    });   
    _window.show();
}

function toCommonCase(Utc){
    var xYear=Utc.getFullYear();
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

