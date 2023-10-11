var PageLogicObj = {
	OldID:"", //上一个选中单元
	OldColor:"", //上一个选中单元颜色
	nowmoth:"", //日历当前显示的月份
	rbasdr:"", //双击选中资源信息
	tabApponitmentList:"",
	tabtimer:"",
	SelectAppMeth:"", //选中的预约方式
	LockPatientID:""
}

$(function(){

	//页面元素初始化
	PageHandle();
	
	//事件初始化
	InitEvent();
});
function BodyLoadHandler(){

	//界面加载完毕后初始化日历模版
	IntCalender()

	//时间默认	
	$('#StartDay').datebox('setValue',ServerObj.NowDateHtml)

	$('#EdDate').datebox('setValue',ServerObj.NowDateHtml)

	//初始化和查询放在一起
	//setTimeout(function(){$('#FindLoc').combobox('setValue',session['LOGON.CTLOCID']);},100)
	setTimeout(function(){IntFindLoc()},100)
	//科室
	$("#OCTloc").keyup(function (e){
			if ($("#OCTloc").val()==""){
				$('#OCTLocRowid').val('');
				/*$('#OMark').combobox('setValue','');
				$('#OMark').combobox('setText','');
				$('#OMark').combobox('clear');
				$('#OMark').combobox('loadData',{});*/
				$('#OMark').val('');
				$('#OMarkRowid').val('');
				//IntOMark()
				
			}
		}
	)
	document.onkeydown = DocumentOnKeyDown;
	try{
		var frmobj=dhcsys_getmenuform();
		if (frmobj){patdr=frmobj.PatientID.value}
	}catch(e){}
	setTimeout(function(){frames[0].LoadPage("",patdr,"",ServerObj.CanNoCardApp)},300)
}
function InitEvent(){
	//预约
	$('#BtnAppointment').bind('click',function(){BtnAppointment()})

   	//清除日历选择信息
   	$('#Clear').bind('click',function(){Clear()})
	//查询
	$('#Find').bind('click',function(){LoadtabAppList()})
	//打印预约条
	//$('#PrintAppInfo').click(PrintAppInfo)
	//取消预约
	//$('#CancelApp').bind('click',function(){CancelApp()})
	//清除
	$('#ClearFindMesage').bind('click',function(){ClearFindMesage()})
    //其他科室
	var Obj=document.getElementById("OCTloc")
  	if (Obj){
	  	Obj.onkeyup=OCTlocChangeHandler;
  	}
  	//回车事件
	$("#PatNo").keydown(function (e){
			var keycode = e.which;
			if(keycode==13){		
				PatNoSearch()
			}
		}
	)

	//回车事件
	$("#Name").keydown(function (e){
		var keycode = e.which;
		if(keycode==13){	
			LoadtabAppList()
		}
	  }
	)
	//登记号查询患者
	$("#PatNo").keyup(function (e){
			if ($('#PatNo').val()==""){
				$('#PatNo,#Name,#PatientID,#CardNo,#CardTypeNew').val('')
				$('#RBAS').combobox('setValue','');
				$('#RBAS').combobox('setText','');
				IntFindLoc()
			}
		}
	)
  	//回车事件
	$("#CardNo").keydown(function (e){
			var keycode = e.which;
			if(keycode==13){		
				CardNoKeyDownHandler()
			}
		}
	)

	//读卡
	$("#BReadCard").click(ReadCardClickHandler);

}

///打开预约界面
function BtnAppointment(){

	if (PageLogicObj.OldID==""){
		$.messager.alert("提示","请先选择日历信息")
		return 
	}
	calendersearceAppoint(PageLogicObj.OldID)
}


function ClearFindMesage(){

	$('#PatNo').val('')
	$('#Name').val('')
	$('#PatientID').val('')
	$('#CardNo').val('')
	$('#CardTypeNew').val('')
	$('#RBAS').combobox('setValue','');
	$('#RBAS').combobox('setText','');
	$('#StartDay,#EdDate').datebox('setValue',ServerObj.NowDateHtml)
	IntFindLoc()


}
//登记号回车
function PatNoSearch(){

	var patno=$("#PatNo").val()
	if ((patno.length<ServerObj.PatNumLength)&&(ServerObj.PatNumLength!=0)) {
		for (var i=(ServerObj.PatNumLength-patno.length-1); i>=0; i--) {
			patno="0"+patno;
		}


	}
	//先清除患者信息
	ClearPatInfo()
	
	$("#PatNo").val(patno)
	var rtn=$cm({
		ClassName:"web.DHCDocAppointmentHui",
		MethodName:"getPatMesageByPatNo",
		dataType:"text",
		PatNo:patno,
		PatDr:"",
	},false);
	window.setTimeout("SetPatInfo('"+rtn+"')");
	
}

function ClearPatInfo(){

	$("#Name").val("")
	$("#PatientID").val("")
}

//设置患者信息
function SetPatInfo(rtn) {
	if (rtn==""){
		$.messager.alert("提示","患者信息无效！")
		return 
	}
	var rtnarry=rtn.split("^")
	$("#Name").val(rtnarry[2])
	$("#PatientID").val(rtnarry[0])
}

//卡号回车
function CardNoKeyDownHandler(){

	var CardNo=$("#CardNo").val();
	if (CardNo=="") return;
	var myrtn=DHCACC_GetAccInfo("",CardNo,"","PatInfo",CardTypeCallBack);
	return false;
}

//调用新读卡函数
function ReadCardClickHandler(){

	//新版
	DHCACC_GetAccInfo7(CardTypeCallBack);
}

//读卡返回
function CardTypeCallBack(myrtn){


    var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0": //卡有效有帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").val(CardNo);
			$("#PatNo").val(PatientNo);
			PatNoSearch()		
			break;
		case "-200": //卡无效
			$.messager.alert("提示","卡无效!","info",function(){
				$("#CardNo").focus();
			});
			break;
		case "-201": //卡有效无帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").val(CardNo);
			$("#PatNo").val(PatientNo);
			PatNoSearch()
			break;
		default:
	}
}


function PageHandle(){

	PageLogicObj.tabApponitmentList=IntApponitmentList()
	/*
	var tool=[
		{  
			text:'清除',  
	    	iconCls:'icon-clear-screen',   
	    	handler:function(){Clear()}    
	  	}  
	]    
	var westpanel=$('#mainlayout').layout('panel','west'); 
	if (westpanel){
		westpanel.panel({ 
			tools:tool
		})
	}
	*/

	//初始化号别
   $.cm({
		ClassName:"web.DHCDocAppointmentHui",
		QueryName:"FindDocMarkStr",
		userid:session['LOGON.USERID'],
		locid:session['LOGON.CTLOCID'],
		rows:99999
   },function(jsonData){
		var cbox = $HUI.combobox("#MarkDoc", {
			valueField: 'resrowid',
			textField: 'markdesc', 
			data: jsonData.rows,
			filter: function(q, row){
				q=q.toUpperCase();
				return (row["markdesc"].toUpperCase().indexOf(q) >= 0);
			},
			onSelect: function (rec) {
				PageLogicObj.rbasdr=rec.resrowid;
				$("#OCTloc").val('')
				$("#OCTLocRowid").val('')
				$('#OMark').val('');
				$('#OMarkRowid').val('');
				IntCalender()
				SetFindLocRBAS(session['LOGON.CTLOCID'],rec.resrowid)
				
			},
			onChange:function(newValue,oldValue){


			},
			onLoadSuccess:function(){
				if (jsonData.rows.length==1){
					var Selectvalue=jsonData.rows[0].resrowid
					$HUI.combobox("#MarkDoc").select(Selectvalue)
				}else if (jsonData.rows.length>1){
					for (var j=0;j<jsonData.rows.length;j++){
						if(jsonData.rows[j].MarkShowDesc==session['LOGON.USERNAME']){
							var Selectvalue=jsonData.rows[j].resrowid
							$HUI.combobox("#MarkDoc").select(Selectvalue)
							}
						}
					}
			}
	   });
    });	


  //初始化科室
  $("#OCTloc").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'CTRowId',
        textField:'CTDesc',
        columns:[[  
            {field:'CTRowId',title:'',hidden:true},
			{field:'CTDesc',title:'科室名称',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        isCombo:true,
        delay:'500',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.DHCBL.Doctor.AppointOral',QueryName: 'GetOtherLocList'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{UserID:session['LOGON.USERID'], CTLOC:session['LOGON.CTLOCID'], desc:desc});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
				if (rec!=undefined){
					OCTlocLookupSelect(rec["CTDesc"]+"^"+rec["CTRowId"])	
				}else{
					
				}
			});
		}
    });
    IntOMark()
    
    //查询科室用放大镜代替
     $("#FindLoc").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'CTRowId',
        textField:'CTDesc',
        columns:[[  
            {field:'CTRowId',title:'',hidden:true},
			{field:'CTDesc',title:'科室名称',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        isCombo:true,
        delay:'500',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.DHCDocAppointmentHui',QueryName: 'CanFindLoc'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{LogOnUser:session['LOGON.USERID'], LogOnLoc:session['LOGON.CTLOCID'], desc:desc});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
				if (rec!=undefined){
					$("#FindLocRowid").val(rec["CTRowId"])
					IntFindRBAS(rec["CTRowId"])	
				}else{
				}
			});
		}
    });
    
   
   
   
   //初始化预约方式
   $.cm({
		ClassName:"web.DHCDocAppointmentHui",
		QueryName:"GetMethTypeDesc",
		userid:session['LOGON.USERID'],
		locid:session['LOGON.CTLOCID'],
		MethCodeStr:ServerObj.AppMethCodeStr,
		rows:99999
   },function(jsonData){
		var cbox = $HUI.combobox("#MeathCodeList", {
			valueField: 'MethodCode',
			textField: 'MethodDesc', 
			data: jsonData.rows,
			filter: function(q, row){
		
			},
			onSelect: function (rec) {
				
			},
			onChange:function(newValue,oldValue){
				if ((newValue==undefined)||(typeof newValue==undefined)){newValue=""}
				PageLogicObj.SelectAppMeth=newValue
				IntCalender()
				
			},
			onLoadSuccess:function(){
					if (jsonData.rows.length==1){
						$('#MeathCodeList').combobox('setValue',jsonData.rows[0].MethodCode);
					}
					
					
			}
	   });
    });	
   
   


}

function SetFindLocRBAS(loc,rbas){
	$("#FindLocRowid").val(loc)
	var ctlocdesc = $cm({
		ClassName:"web.DHCDocAppointmentHui",
		MethodName:"GetCtLocDescByID",
		dataType:"text",
		ctlocdr:loc
	},false);
	$('#FindLoc').val(ctlocdesc)
	IntFindRBAS(loc)
	setTimeout(function(){
	 	$('#RBAS').combobox('setValue',rbas);
	},1000)	
}

function IntFindRBAS(FindLoc){

  ///初始化预约查询的科室
  $.cm({
		ClassName:"web.DHCDocAppointmentHui",
		QueryName:"CanFindRBAS",
		locdr:FindLoc,
		logonuser:session['LOGON.USERID'],
		logonloc:session['LOGON.CTLOCID'],
		rows:99999
   },function(jsonData){
		var cbox = $HUI.combobox("#RBAS", {
			valueField: 'rowid',
			textField: 'desc', 
			data: jsonData.rows,
			filter: function(q, row){
				q=q.toUpperCase();
				return (row["desc"].toUpperCase().indexOf(q) >= 0);
			},
			onSelect: function (rec) {
			
			},
			onChange:function(newValue,oldValue){
				
			},
			onLoadSuccess:function(){
			}
	   });
   });	

}

//其他科室清空
function OCTlocChangeHandler(){
    var Obj=document.getElementById("OCTloc")
    if ((Obj)&&(Obj.value=="")){
	    var OCTLocRowidObj=document.getElementById("OCTLocRowid");


    	if (OCTLocRowidObj){
	    		OCTLocRowidObj.value="";
	    		/*$('#OMark').combobox('clear');
	    		$('#OMark').combobox('setValue','');
	    		$('#OMark').combobox('setText','');
	    		$('#OMark').combobox('loadData',{});*/
	    		$('#OMark').val('');
				$('#OMarkRowid').val('');
	    		PageLogicObj.rbasdr=""
	    		IntCalender();
	    }

	}
}

//选择其他科室
function OCTlocLookupSelect(value){
    var OCTLocRowidObj=document.getElementById("OCTLocRowid");


    if (OCTLocRowidObj){
	    OCTLocRowidObj.value=value.split("^")[1];
	    /*$('#OMark').combobox('clear');
	    $('#OMark').combobox('setValue','');
	    $('#OMark').combobox('setText','');
	    $('#OMark').combobox('loadData',{});*/
	    $('#OMark').val('');
		$('#OMarkRowid').val('');
	    $('#MarkDoc').combobox('setValue','');
	    $('#MarkDoc').combobox('setText','');
	    window.setTimeout('IntOMark()',1)


	}
}

///加载其他号别
function IntOMark(){

   //var OCtlocDr=$("#OCTLocRowid").val()
   $("#OMark").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'resrowid',
        textField:'markdesc',
        columns:[[  
            {field:'resrowid',title:'',hidden:true},
			{field:'markdesc',title:'名称',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        isCombo:true,
        //minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCDocAppointmentHui',QueryName: 'FindDocMarkStrOther'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{UserID:session['LOGON.USERID'], LocID:$("#OCTLocRowid").val(), LogOnLoc:session['LOGON.CTLOCID'], MarkCodeName:desc});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
				if (rec!=undefined){
					PageLogicObj.rbasdr=rec['resrowid'];
					IntCalender();
					SetFindLocRBAS(OCtlocDr,rec['resrowid'])
					$('#OMarkRowid').val(rec['resrowid']);
				}
			});
		}
    });
   /*$.cm({
		ClassName:"web.DHCDocAppointmentHui",
		QueryName:"FindDocMarkStrOther",
		UserID:session['LOGON.USERID'],
		LocID:OCtlocDr,
		LogOnLoc:session['LOGON.CTLOCID'],
		rows:99999
   },function(jsonData){
		var cbox = $HUI.combobox("#OMark", {
			valueField: 'resrowid',
			textField: 'markdesc', 
			data: jsonData.rows,
			filter: function(q, row){
		
			},
			onSelect: function (rec) {
				PageLogicObj.rbasdr=rec.resrowid;
				IntCalender();
				SetFindLocRBAS(OCtlocDr,rec.resrowid)
			},
			onChange:function(newValue,oldValue){
				
			},
			onLoadSuccess:function(){
				
			}
	   });
    });*/
    //加载清空资源
    PageLogicObj.rbasdr=""
    IntCalender();
	$('#OMark').focus()
}

///清除左侧日历信息
function Clear(){

	$('#OMark').val('');
	$('#OMarkRowid').val('');
	$("#OCTloc").val('')
	$("#OCTLocRowid").val('')
	$('#MarkDoc').combobox('setValue','');
	$('#MarkDoc').combobox('setText','');
	PageLogicObj.rbasdr=""
	IntCalender();
}

//查询预约信息
function LoadtabAppList(){


	if (PageLogicObj.tabApponitmentList==""){
		$.messager.alert("提示","未找到初始化表格信息.请联系系统管理员!")
		return
	}

	//是否查询其他医生预约资源
	var OterdocAppoint="N"
	var OterdocAppoint=$("#OterdocAppoint").checkbox('getValue')
	if (OterdocAppoint){
		OterdocAppoint="Y"
	}


	var rbasdr=$('#RBAS').combobox('getValue');
	if ($("#FindLoc").lookup('getText')==""){
		$("#FindLocRowid").val('');
	}
	//var Locdr=$('#FindLoc').combobox('getValue');
	var Locdr=$("#FindLocRowid").val()
	if (Locdr==undefined) Locdr="";
	if (Locdr==""){
		$.messager.alert("提示","请选择科室!");
		return false;
	}
	//查询之前清空所有选中
	$('#tabApponitmentList').datagrid("unselectAll")
	$.cm({
	    ClassName :"web.DHCDocAppointmentHui",
	    QueryName :"GetApptList",
	    StartDay:$("#StartDay").datebox('getValue'),
	    EndDay:$("#EdDate").datebox('getValue'),
	    LogonLocId:session['LOGON.CTLOCID'],
	    LogOnUser:session['LOGON.USERID'],
	    MethCodeStr:ServerObj.AppMethCodeStr,
	    CanAddApponit:ServerObj.CanAddApponit,
	    PatientID:$("#PatientID").val(),
	    Locdr:Locdr,
	    RBResID:rbasdr,
	    PatName:$("#Name").val(),
	    OterdocAppoint:OterdocAppoint,
	    Pagerows:PageLogicObj.tabApponitmentList.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.tabApponitmentList.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);

	});

}

///初始化查询Table	
function IntApponitmentList(){

	var tabdatagrid=$('#tabApponitmentList').datagrid({  
	fit : true,
	border : false,
	striped : true,
	singleSelect : false,
	fitColumns : false,
	autoRowHeight : true,
	rownumbers:true,
	pagination : true,  
	rownumbers : true,
	toolbar: [{
		iconCls: 'icon-cancel',
		text:"取消预约",
		handler: function(){CancelApp();}
	},{
		iconCls: 'icon-print',
		text:"打印预约条",
		handler: function(){PrintAppInfo();}
	}],

	nowrap: false, //不换行
	pageSize: 20,
	pageList : [20,100,200],
	idField:"RowId",
	columns :[[ 
			{field:'RowCheck',checkbox:true},
			{field:'PatientNo',title:"登记号",width:150,align:'left'},
			{field:'PatientName',title:"姓名",width:150,align:'left'},
			{field:'AppPatientSex',title:"性别",width:80,align:'left'},
			{field:'AppPatientAge',title:"年龄",width:100,align:'left'}, 
			{field:'TPhone',title:"联系电话",width:150,align:'left'},
			{field:'AppDate',title:"预约日期",width:150,align:'left'},
			{field:'DepDesc',title:"预约科室",width:150,align:'left'},
			{field:'DocDesc',title:"预约医生",width:150,align:'left'},
			{field:'MethodDesc',title:"预约方式",width:120,align:'left'},
			{field:'QueueNo',title:"诊号",width:60,align:'left'},
			{field:'StatusDesc',title:"预约状态",width:100,align:'left'},
			{field:'TransDate',title:"预约办理日期",width:120,align:'left'},
			{field:'TransTime',title:"预约办理时间",width:120,align:'left'},
			{field:'TransUserName',title:"预约办理人",width:100,align:'left'},
			{field:'Sum',title:"金额",width:60,align:'left'},
			{field:'TTimeRange',title:"建议就诊时段",width:150,align:'left'},
			{field:'Remark',title:"预约备注",width:150,align:'left'},
			


			{field:'TPoliticalLevel',title:"病人级别",width:100,align:'left',hidden:true},
			{field:'TSecretLevel',title:"病人密级",width:100,align:'left',hidden:true},
			{field:'AppTime',title:"预约时间",width:35,align:'left',hidden:true},
			{field:'PatientID',title:"PatientID",width:35,align:'left',hidden:true},
			{field:'StatusCode',title:"StatusCode",width:35,align:'left',hidden:true},
			{field:'RBASStatusDesc',title:"排班状态",width:35,align:'left',hidden:true},
			{field:'RBASStatusCode',title:"排班状态Code",width:35,align:'left',hidden:true},
			{field:'RBASStatusReason',title:"排班变更原因",width:35,align:'left',hidden:true},
			{field:'TRDoc',title:"替诊医生",width:35,align:'left',hidden:true},
			{field:'StatusChangeDate',title:"预约状态变更日期",width:35,align:'left',hidden:true},
			{field:'StatusChangeTime',title:"预约状态变更时间",width:35,align:'left',hidden:true},
			{field:'StatusChangeUserName',title:"预约状态人",width:35,align:'left',hidden:true},
			{field:'SystemSession',title:"外部系统码",width:35,align:'left',hidden:true},
			{field:'AppIntervalTime',title:"取号时长(分钟)",width:35,align:'left',hidden:true},
			{field:'LineNum',title:"行序号",width:35,align:'left',hidden:true},
			{field:'TPoliticalLevel',title:"病人级别",width:35,align:'left',hidden:true},
			{field:'TSecretLevel',title:"病人密级",width:35,align:'left',hidden:true},
			{field:'RowId',title:"预约ID",width:150,align:'left'},

				
			 ]] ,
		 onSelect:function (rowIndex, rowData){



		},
		onLoadSuccess:function(rowData){
			
		}




	
});
return tabdatagrid
}

//界面日历代码 ------------begin----

//初始化日历
function IntCalender(){
	//清除
	var rbasdr=PageLogicObj.rbasdr;
	var AppMethCodeStr=ServerObj.AppMethCodeStr
	var CanAddApponit=ServerObj.CanAddApponit
	if (PageLogicObj.SelectAppMeth!=""){
		AppMethCodeStr=PageLogicObj.SelectAppMeth
	}
	
	$('#Cancel').bind('click',function(){Cancel()})
	var datastr = $cm({
		ClassName:"web.DHCDocAppointmentHui",
		MethodName:"getcalenderHtml",
		dataType:"text",
		menthdate:PageLogicObj.nowmoth,
		rbasdr:rbasdr,
		CanAddApponit:CanAddApponit,
		AppMethCode:AppMethCodeStr,
		USERID:session['LOGON.USERID'],	
	},false);
	if (datastr!=""){
		var datahtml=datastr.split("^")[0]
		PageLogicObj.nowmoth=datastr.split("^")[1]
	}else{
		var datahtml=""
		PageLogicObj.nowmoth=""
	}
	//
	$('#calender').html(datahtml)
	//月份向上
	$('#upmoth').bind('click',function(){ChangeCalenderDate('up')})
	//月份向下
	$('#downmoth').bind('click',function(){ChangeCalenderDate('down')})
	//当前月份
	$('#nowmoth').bind('click',function(){ChangeCalenderDate('now')})	
	
	var PorpStr={trigger:'hover',placement:'top-left',title:'',content:'假日颜色'}
	$("#holidaycolor").popover(PorpStr)
	var PorpStr={trigger:'hover',placement:'top-left',title:'',content:'非本月颜色'}
	$("#outmethcolor").popover(PorpStr)
	var PorpStr={trigger:'hover',placement:'top-left',title:'',content:'本月颜色'}
	$("#nowmothcolor").popover(PorpStr)
	var PorpStr={trigger:'hover',placement:'top-left',title:'',content:'当日颜色'}
	$("#nowdatecolor").popover(PorpStr)
	var PorpStr={trigger:'hover',placement:'top-left',title:'',content:'小于当日的无效日期'}
	$("#yesdatecolor").popover(PorpStr)
	PageLogicObj.OldID=""
	
	PageLogicObj.OldColor=""
}
function AddClass(value){
	
	$('#'+value).addClass("selectCls"); //css("background", ServerObj.selectcolor); 
	$('#T'+value).addClass("selectColor"); 
	$('#D'+value).addClass("selectColor"); 
}
//日历点击背景色处理

function calendersearce(value){
	//if (PageLogicObj.OldID!=""){$('#'+PageLogicObj.OldID).css("background",PageLogicObj.OldColor);}
	//PageLogicObj.OldID=value;PageLogicObj.OldColor=$('#'+value).css('background-color');
	//$('#'+value).css("background", ServerObj.selectcolor); \
	
	$(".selectCls").removeClass("selectCls");
	$(".selectColor").removeClass("selectColor");
	//点击查询
	var htmldate=$cm({
		ClassName:"web.DHCDocAppointmentHui",
		MethodName:"DateToHtml",
		dataType:"text",
		date:value
	},false);
	AddClass(value);
	//日历选择的时候自动发起查询
	$('#StartDay').datebox('setValue',htmldate)
	$('#EdDate').datebox('setValue',htmldate)
	LoadtabAppList();
	clearTimeout(PageLogicObj.tabtimer);
	//但是会慢影响交互
	PageLogicObj.tabtimer=window.setTimeout('IntTabload("'+value+'")',1000)
	calendersearceAppoint(value)

}

//同步查询日期同步查询--
function IntTabload(value)
{
	LoadtabAppList()
}


//日历选择预约份 上一月、下一月、本月
function ChangeCalenderDate(type){	
	if (PageLogicObj.nowmoth==""){
		$.messager.alert("提示","日历当前显示日期不存在,数据异常!")
		return
	}
	//---日期时间
	var nowmothArry=PageLogicObj.nowmoth.split("-")
	var year=nowmothArry[0]
	var motn=nowmothArry[1]
	var date=nowmothArry[2]
	if (type=='up') motn=parseInt(motn)-1
	if (type=='down') motn=(parseInt(motn)+1)
	if (motn>12){year=(parseInt(year)+1);motn="01"}
	if (motn<1){year=(parseInt(year)-1);motn="12"}
	if (type=='now'){nowmoth=ServerObj.nowDate;;var nowmothArry=nowmoth.split("-");var year=nowmothArry[0];var motn=nowmothArry[1];var date="01"}
	var nowmoth=year+"-"+motn+"-"+date
	PageLogicObj.nowmoth=nowmoth
	IntCalender()
	return
}

//日历双击打开预约窗口
function calendersearceAppoint(date)
{
	//双击得时候不触发查询
	clearTimeout(PageLogicObj.tabtimer);
	
	var rbasaobj=$("[id='T"+date+"']")
	var rbasdrstr=""
	for (var i=0;i<rbasaobj.length;i++){
		var onerbas=$(rbasaobj[i]).attr('rbasdr')
		var canApp=$(rbasaobj[i]).attr('canApp')
		if (canApp!="Y"){continue} //是否可以预约标志
		if ((onerbas=="")||(typeof onerbas =="undefined")){continue}
		if (rbasdrstr==""){rbasdrstr=onerbas}
		else{rbasdrstr=rbasdrstr+"^"+onerbas}
	}
	if (rbasdrstr==""){
		//$.messager.alert("提示","请先选择有效的记录进行预约!")
		$.messager.popover({msg: '请先选择有效的记录进行预约!',type:'alert'});
		AppointMentOpen("")
		return
	}
	var IsHoliday = $cm({
		ClassName:"web.DHCDocAppointmentHui",
		MethodName:"IsHolidayDate",
		dataType:"text",
		CurrDate:date,
		},false);
	if (IsHoliday=="1"){
		$.messager.confirm('确认对话框', '该天为节假日，是否预约?', function(r){
			if (r){
			    AppointMentOpen(rbasdrstr)
			}
		});
	}else{AppointMentOpen(rbasdrstr);}
	
}
//界面日历代码 end----

//日期处理函数
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (ServerObj.sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}

function myparser(s){
    if (!s) return new Date();
    if(ServerObj.sysDateFormat=="4"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}

//打开预约窗口
function AppointMentOpen(rbasdrstr)
{
	var patdr=""
	try{
		var frmobj=dhcsys_getmenuform();
		if (frmobj){patdr=frmobj.PatientID.value}
	}catch(e){}
	//lxz 预约先选择预约方式
	var AppMethCodeStr=ServerObj.AppMethCodeStr
	if (PageLogicObj.SelectAppMeth!=""){
		AppMethCodeStr=PageLogicObj.SelectAppMeth
	}else{
		$.messager.alert("提示","请先选择预约方式!")
		return
	}	
	var awidth=screen.availWidth/6*5; 
	var aheight=screen.availHeight/5*4; 
	console.log(AppMethCodeStr,ServerObj.CanNoCardApp)
	frames[0].LoadPage(rbasdrstr,"",AppMethCodeStr,ServerObj.CanNoCardApp)
	//var src="dhcdoc.appointment.app.hui.csp?RBASRowID="+rbasdrstr+"&AppMethCodeStr="+AppMethCodeStr+"&PatientID="+patdr+"&CanNoCardApp="+ServerObj.CanNoCardApp;
	/*var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Appoint","预约", awidth, aheight,"icon-w-edit","",$code,"");	*/
}

//窗口打开函数
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}

function destroyDialog(id){
   //移除存在的Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}

function PrintAppInfo()
{
	
	var selectobj=$('#tabApponitmentList').datagrid("getSelections")
	if (selectobj.length<=0){
		$.messager.alert("提示","请选择需要打印的预约记录!")
		return
	}
	for (var i=0;i<selectobj.length;i++){
		var oneobj=selectobj[i]
		var AppRowID=oneobj.RowId
		if (AppRowID==""){
			$.messager.alert("提示",oneobj.PatientName+$g("患者不存在预约记录ID"))
			continue
		}
		var statucode = $cm({
			ClassName:"web.DHCDocAppointmentHui",
			MethodName:"GetAppStatuCode",
			dataType:"text",
			appid:AppRowID
		},false);

		if (statucode!="I"){
			$.messager.alert("提示",oneobj.PatientName+$g(",预约记录状态是非【预约】状态不能打印预约条！"))
			continue
		}
		PrintAPPMesag(AppRowID)
	}
}

//预约打印新加入方法 和日历预约的查询保持一致
function PrintAPPMesag(AppID)
{
	DHCP_GetXMLConfig("XMLObject","DHCOPAppointPrint");
	var Rtn = $cm({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"GetAppPrintData",
		dataType:"text",
		AppARowid:AppID,
		AppMedthod:ServerObj.AppMethCodeStr,
	},false);
	var RtnArry=Rtn.split("^")
	var PDlime=String.fromCharCode(2);
	var MyPara="CardNo"+PDlime+RtnArry[0]+"^"+"PatNo"+PDlime+RtnArry[13]+"^"+"PatName"+PDlime+RtnArry[2]+"^"+"RegDep"+PDlime+RtnArry[6]
	var MyPara=MyPara+"^"+"SessionType"+PDlime+RtnArry[18]+"^"+"MarkDesc"+PDlime+RtnArry[7]+"^"+"Total"+PDlime+RtnArry[17];
	var MyPara=MyPara+"^"+"AdmDate"+PDlime+RtnArry[10]+"^"+"APPDate"+PDlime+RtnArry[8]+" "+RtnArry[9]+"^"+"SeqNo"+PDlime+RtnArry[4]
	var MyPara=MyPara+"^"+"UserCode"+PDlime+RtnArry[15];
	var MyPara=MyPara+"^"+"MethType"+PDlime+"["+RtnArry[16]+"]"
	var MyPara=MyPara+"^"+"AdmTimeRange"+PDlime+RtnArry[14] //建议就诊时间
	var myobj=document.getElementById("ClsBillPrint");
	//DHCP_PrintFun(myobj,MyPara,"")
	DHC_PrintByLodop(getLodop(),MyPara,"","","");
}

//取消预约
function CancelApp()
{
	var selectobj=$('#tabApponitmentList').datagrid("getSelections")
	if (selectobj.length<=0){
		$.messager.alert("提示","请选择需要取消的预约记录!")
		return
	}
	//检测是否可以撤销执行记录
	var AppRowIDCheckFlag=0
	for (var i=0;i<selectobj.length;i++){
		var oneobj=selectobj[i]
		var AppRowID=oneobj.RowId
		var Rtn = $cm({
		ClassName:"web.DHCDocAppointmentHui",
		MethodName:"CheckBeforeCancel",
		dataType:"text",
		AppID:AppRowID,
		LogonUser:session['LOGON.USERID'],
		},false);
		if (Rtn!=""){
			$.messager.alert("提示",$g("患者,")+oneobj.PatientName+$g(Rtn))
			AppRowIDCheckFlag=1
		}
	}
	if (AppRowIDCheckFlag==1){
		return;
		}
	$.messager.confirm('确认对话框', '是否确认取消预约?', function(r){
		if (r) {
			for (var i=0;i<selectobj.length;i++){
				var oneobj=selectobj[i]
				var AppRowID=oneobj.RowId
				//取消预约
				var Rtn = $cm({
					ClassName:"web.DHCRBAppointment",
					MethodName:"CancelAppointment",
					dataType:"text",
					APPTRowId:AppRowID,
					UserRowId:session['LOGON.USERID'],
				},false);
					if (Rtn!=0){
						$.messager.alert("提示","取消预约失败!")
						LoadtabAppList();
						return
				}
			}
			$.messager.popover({msg: '取消预约成功！',type:'success',timeout: 1000});
			LoadtabAppList();
		}
	})
}

function DocumentOnKeyDown(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	if (keyCode==13) {
		/*
		if(SrcObj && SrcObj.id.indexOf("CardNo")>=0){
			CardNoKeydownHandler(e);
			return false;
		}else if(SrcObj && SrcObj.id.indexOf("PatNo")>=0){
			PatNoKeydownHandler(e);
			return false;
		}
		*/
		return false;
	}
	return true;
}

///初始化查询科室和列表
function IntFindLoc()
{
	
	$('#FindLoc').val(ServerObj.logonlocdesc)
	$("#FindLocRowid").val(session['LOGON.CTLOCID'])
	IntFindRBAS(session['LOGON.CTLOCID'])
	setTimeout(function(){LoadtabAppList()},100)
}

function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content
    });
}
function SetChildPatNo(patno) {
	$("#FindPatInfo").dialog("close");
	frames[0].ClearPatInfo();
	$("#TabMain").contents().find("#PatNo").val(patno);
	frames[0].PatNoSearch();
	//frames[0].LoadPage("",PatientId,"",ServerObj.CanNoCardApp)
}
