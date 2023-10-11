///qqa
///2017-11-28
///HISUI检查查看
var PageLogicObj={
	MainSreenFlag:websys_getAppScreenIndex()				//双屏标识
}
$(function (){

	initParam();
		
	initMethod();
	
	initCombobox();
	
	initDateBox();
	
	//initDatagrid();
	
	initDatagridNew();
	
	initShowThisAdmCheck(); 

    if ((PageLogicObj.MainSreenFlag==0)&&(EpisodeID!="")){
		websys_emit("onSelectIPPatient",{PatientID:PatientID,EpisodeID:EpisodeID,mradm:""});
	}
})

function initCombobox(){
	$HUI.combobox("#admType",{
		data:[
			{"value":"O","text":"门诊"},
			{"value":"E","text":"急诊"},
			{"value":"I","text":"住院"}
		],
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       searchLisOrdNew();
	    }	
	})
	
	var Params = HospID;
	
	$HUI.combobox("#ordType",{
		url:LINK_CSP+"?ClassName=web.DHCAPPSeePatPacs&MethodName=GetOrdType&Params="+Params,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    	searchLisOrdNew();
	    }	
	})

	$HUI.combobox("#admLoc",{
		url:LINK_CSP+"?ClassName=web.DHCAPPSeePatPacs&MethodName=GetAdmLoc&PatientID="+PatientID,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    	//searchLisOrdNew();
	    }	
	})		
}

function initParam(){
	PatientID = PatientID==undefined?"":PatientID;  //为undefined设置为空
	showType=0;
	pacsOrdRowData="";
	thisAdm="Y";        ///默认查询当前就诊
	if (PAAdmType!="I"){
		thisAdm="N";
		$('#thisAdm').checkbox('setValue',false);
		}
	var params =  LgCtLocID+"^"+PatientID+"^"+OEORIID
	runClassMethod("web.DHCAPPSeePatPacs","GetParam",{"Params":params},function (data){
		var dataArray =data.split("#");
		DateFormat = dataArray[0];
		if((PatientID!="")&&(RegNo=="")){
			RegNo = dataArray[1];
		}
		regNolenght = dataArray[2];
		ordStDate = dataArray[3];
	},'text',false)
}

function initMethod(){
	$('#search').on('click',searchLisOrdNew);
	
	$('#patRegNo').on('keypress', regNoKeyPress); 
	
	$("#openPort").on('click',openLittleThree);
	
	$(window).resize(resizeLayout); 
}

function regNoKeyPress(){
	if (event.keyCode!=13) return;
	var regNo = $('#patRegNo').val();

	if(regNo==""){
		$.messager.alert("提示","登记号为空");
		return;
	}

	///登记号补0
	for (i=regNo.length;i<regNolenght;i++){
		regNo = "0"+regNo;
	}
	
	runClassMethod("web.DHCEMInComUseMethod","GetPatIDByRegNo",
		{RegNo:regNo},
		function(ret){
			PatientID=ret;
		},"text",false
	) 
	
	RegNo = regNo;
	$('#patRegNo').val(regNo);
	searchLisOrdNew();	
}

function searchLisOrdNew(){
	var stDate = $HUI.datebox("#sel-stDate").getValue();
	var edDate = $HUI.datebox("#sel-edDate").getValue();
	var admTypeDesc=($HUI.combobox("#admType").getValue()==undefined?"":$HUI.combobox("#admType").getValue());
	var arccaID=($HUI.combobox("#ordType").getValue()==undefined?"":$HUI.combobox("#ordType").getValue());
	//var EpisodeID=($HUI.combobox("#admLoc").getValue()==undefined?"":$HUI.combobox("#admLoc").getValue());
	Params=(thisAdm==="Y"?EpisodeID:"")+"^"+PatientID+"^"+stDate+"^"+edDate+"^"+LgUserID+"^"+admTypeDesc+"^"+arccaID+"^"+ReqNo+"^"+OEORIID;  //##
	$HUI.datagrid('#inspectDetail').load({
		Params:Params
	})
}

function initDateBox(){
		$HUI.datebox("#sel-stDate",{});
		$HUI.datebox("#sel-edDate",{});
		$HUI.datebox("#sel-stDate").setValue((ordStDate==""?formatDate(-180):ordStDate));
		$HUI.datebox("#sel-edDate").setValue(formatDate(0));
}

function initDatagridNew(){
	var Params=""
	var stDate = $HUI.datebox("#sel-stDate").getValue();
	var edDate = $HUI.datebox("#sel-edDate").getValue();
	Params= (thisAdm==="Y"?EpisodeID:"")+"^"+PatientID+"^"+stDate+"^"+edDate+"^"+LgUserID+"^"+""+"^"+""+"^"+ReqNo+"^"+OEORIID;  //##
	ReqNo = "",OEORIID="";
	var columns=[[
		{ field: 'lx',align: '', title: '类型',formatter:formatterlx},
    	{ field: 'AdmLoc',align: '', title: '就诊科室'},
    	{ field: 'ReqNo',align: '', title: '申请单号'},
    	{ field: 'StudyNo',align: '', title: '检查号'},
    	{ field: 'strOrderName',align: '', title: '检查名称',formatter:orderviewArci},
    	{ field: 'strOrderDate',align: '', title: '申请日期',sortable:true,sorter:mySort},
    	{ field: 'ItemStatus',align: '', title: '检查状态'},
    	{ field: 'recLocName',align: '', title: '检查科室'},
    	{ field: 'IsCVR',align: '', title: '危急值报告'},
    	{ field: 'IsIll',align: '', title: '是否阳性',
    		formatter:function(value,row,index){ //hxy 2018-10-30
				if (value=='Y'){return $g('是');} 
				else {return $g('否');}
			}}, 
    	{ field: 'IshasImg',align: '', title: '是否有图像',
    		formatter:function(value,row,index){ //hxy 2018-10-30
				if (value=='Y'){return $g('是');} 
				else {return $g('否');}
    		}},
    	{ field: 'Bookingtime',align: '', title: '预约时间'},
    	{ field: 'Image',align: '', title: '图像',formatter:formatterImg},
    	{ field: 'Report',align: '', title: '报告',formatter:formatterPort},
    	{ field: 'BlMorePort',align: '', title: '病理多份报告',formatter:formatterBlMorePort,hidden:'true'},
    	{ field: 'Grade',align: '', title: '评级',hidden:true},
    	{ field: 'IsReaded',align: '', title: '阅读',formatter:formatterIsReaded},
    	{ field: 'AffirmReaded',align: '', title: '确认阅读',formatter:formatterAffirmReaded},
    	//旧版知识库的链接，标版停用,等待新版接口{ field: 'InsureList',align: '', title: '说明书',formatter:formatterInsureList},
    	{ field: 'OEORIId',align: '', title: '医嘱ID'},
    	{ field: 'ARCIMId',align: '', title: 'ARCIMId',hidden:'true'},
    	{ field: 'PartID',align: '', title: 'PartID',hidden:'true'},
    	{ field: 'PortUrl',align: '', title: 'PortUrl',hidden:'true'}
 
 	]]; 

 	$HUI.datagrid('#inspectDetail',{
		url:LINK_CSP+"?ClassName=web.DHCAPPSeePatPacs&MethodName=GetLisInspectOrdNew&Params="+Params,
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:false,
		pageSize:10,  
		pageList:[10,15,20], 
	    singleSelect:true,
	    remoteSort: false,
		loadMsg: '正在加载信息...',
		pagination:true,
		border:true,//hxy 2018-10-22
		rowStyler: function(index,row){
			
		},
		onLoadSuccess:function(data){
			if((data.rows.length=="1")&&(ReqNo!="")){
				isShowPort(data.rows[0]);	
			}
		},
		onSelect:function(rowIndex, rowData){
			var PortUrl=rowData.PortUrl||"";
			var Report=rowData.Report||"";
			if (PageLogicObj.MainSreenFlag==0){
				if ((PortUrl=="")||(Report=="")){
					websys_emit("onSelectIPPatient",{PatientID:rowData.PatientID,EpisodeID:rowData.EpisodeID,mradm:""});
					return false;
				}
				//因为不能传递url参数以及对象Json链接参数
				//websys_emit("onOpenDHCDoc",{title:"检查报告",frameurl:PortUrl,MWToken:websys_getMWToken()});
				var frameurl=PortUrl.replace(/&/g,"!@")
				//websys_emit("onOpenSpectReport",{title:"检查报告",patid:"0000000022",AccNum:"CJCH725"})
				websys_emit("onOpenDHCDoc",{title:"检查报告",frameurl:frameurl})
			}
		}
	});	
}

function formatterlx(value,rowData){
	if(rowData.BLOrJC==0){
		return $g("检查");
	}
	
	if(rowData.BLOrJC==1){
		return $g("病理");
	}
}

function formatterImg(value,rowData){	
	retStr = "<a href='#' title='' onclick='showImg(\""+rowData.ImgUrl+"\");return false;'>"+value+"</span></a>"
	return retStr;	
}

function formatterPort(value,rowData){
	var url="",params="";
	if(rowData.BLOrJC==0){}
	if(rowData.BLOrJC==1){}
	url=rowData.PortUrl
	if(rowData.PortUrl===""){
		url="";
	}
	retStr = "<a href='#' title='' onclick='showReport(\""+url+"\");return false;'>"+$g(value)+"</span></a>"
	return retStr;	
}

function isShowPort(rowData){
	if(rowData.Report=="") return;
	var url="",params="";
	if(rowData.BLOrJC==0){
		url = rowData.PortUrl+(rowData.PortUrl.indexOf("?")==-1?"?":"&")+"LID="+rowData.recLocDr+"&SID="+rowData.StudyNo+"&OID="+rowData.OEORIId+"&USERID="+LgUserID;
	}
	if(rowData.BLOrJC==1){
		url=rowData.PortUrl+(rowData.PortUrl.indexOf("?")==-1?"?":"&")+"dept="+rowData.recLocDr+"&patID="+(rowData.RegNo+"")+"&OrderID="+rowData.OEORIId+"&Rpt=1";
	}
	if(rowData.PortUrl===""){
		url="";
	}
	params = rowData.recLocDr+"^"+LgCtLocID+"^"+rowData.RegNo+"^"+rowData.StudyNo+"^"+LgUserID+"^"+rowData.OEORIId+"^"+rowData.PartID
	showReport(url,params,rowData.Num);
	return;
}

function formatterBlMorePort(value,rowData){
	var url = rowData.PortUrl;
	url = url.replace("Rpt=1","Rpt=");  //病理查看多份报告
	params = rowData.recLocDr+"^"+LgCtLocID+"^"+rowData.RegNo+"^"+rowData.StudyNo+"^"+LgUserID+"^"+rowData.OEORIId+"^"+rowData.PartID
	retStr = "<a href='#' title='' onclick='showReport(\""+url+"\",\""+params+"\",\""+rowData.Num+"\");return false;'>"+$g(value)+"</span></a>"
	return retStr;	
}

///查看阅读明细
function formatterIsReaded(value,rowData){
	var params = rowData.OEORIId+"^"+rowData.StudyNo;
	retStr = "<a href='#' title='' onclick='showReadDetail(\""+params+"\");return false;'>"+$g(value)+"</span></a>"
	return retStr;	
}

///确认阅读
function formatterAffirmReaded(value,rowData){
	var retStr="";
	params = rowData.recLocDr+"^"+LgCtLocID+"^"+rowData.RegNo+"^"+rowData.StudyNo+"^"+LgUserID+"^"+rowData.OEORIId+"^"+rowData.PartID
	if((rowData.Report!="")){
		retStr = "<a href='#' title='' onclick='affirmReaded(\""+params+"\",\""+rowData.Num+"\");return false;'>"+$g("确认阅读")+"</span></a>"	
	}
	return retStr;
}

//检查阅读报告
function affirmReaded(params,rowIndex){
	setReadFlag("R",params);   //设置阅读标记

	$HUI.datagrid('#inspectDetail').updateRow({
        index: rowIndex,
        row: {
            IsReaded: $g("已阅读")
        },
    });	
}

///阅读图像
function showImg(url){
	if(url===""){
		$.messager.alert("提示","RIS报告平台没有配置图像阅读路径");	
		return false;
	}
	if(typeof websys_writeMWToken=='function') url=websys_writeMWToken(url);
	window.open (url, "newwindow", "height=550, width=950, toolbar =no,top=100,left=300,menubar=no, scrollbars=no, resizable=yes, location=no,status=no");
	return false;	
}

///阅读报告
function showReport(url,params,rowIndex){
	if(url===""){
		$.messager.alert("提示","RIS报告平台没有配置图像阅读路径");	
		return false;
	}
	if(typeof websys_writeMWToken=='function') url=websys_writeMWToken(url);
	//打开报告
	window.open (url, "newwindow", "height=550, width=950, toolbar =no,top=100,left=300,menubar=no, scrollbars=yes, resizable=yes, location=no,status=no");
		
	runClassMethod("web.DHCAPPSeePatPacs","ClinicRecordSet",
		{
			Model:"R",
		 	Params:params
		},function(ret){
		},"text"
	)	

	$HUI.datagrid('#inspectDetail').updateRow({
        index: rowIndex,
        row: {
            IsReaded: $g("已阅读")
        },
    });	
	return false;
}

///查看阅读明细
function showReadDetail(params){
	

	if(params===""){
		$.messager.alert("提示","参数为空！");
		return;
	}
	
	var columns=[[
		{field:'ReadDoctorName',title:'阅读人',width:110},
		{field:'ReadDate',title:'阅读日期',width:122},
		{field:'ReadTime',title:'阅读时间',width:122}
	]];

	$HUI.datagrid('#readDetailTable',{
		url:LINK_CSP+"?ClassName=web.DHCAPPSeePatPacs&MethodName=ReadDetailByParams&Params="+params,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:6,  
		pageList:[6], 
	    singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		showHeader:true,
		pagination:true
	});

	$HUI.window("#readDetailWin").open();
}

///设置阅读标记
function setReadFlag(model,params){	
	runClassMethod("web.DHCAPPSeePatPacs","ClinicRecordSet",
		{
			Model:model,
		 	Params:params
		},function(ret){
			if(ret!=0){
				$.messager.alert("提示","保存阅读记录异常！");
			}else{
				$.messager.popover({msg:"阅读成功！",type:'success'});
				searchLisOrdNew();
			}	
		},"text"
	)	
}

function reloadOrdDetailTable(rowData){
	$HUI.datagrid('#inspectDetail').load({
		OEORIId:rowData.OEORIId,
		StudyNoLab:rowData.StudyNo 
	})
}

function reloadPacsLab(rowIndex,rowData){
	$("#pacsOrdInfo").html($g("申请时间:")+rowData.OrdDateTime);
	$("#detailOrdName").html(rowData.ArcimName.substring(0,20));
}

///病人检查医嘱加载
function setCellLabel(value, rowData, rowIndex){
	var lisOrdStatus="";
	if(rowData.PortStatusCode==="CM"){
		var imgUrl ="../scripts/dhcnewpro/images/yetgo.png";
		if (rowData.IsReaded=="Y") imgUrl ="../scripts/dhcnewpro/images/yetread.png";
		lisOrdStatus = "background-image: url("+imgUrl+");";
		lisOrdStatus =lisOrdStatus +" background-position-y: 7px;";
		lisOrdStatus =lisOrdStatus +" background-position-x: 135px;";
		lisOrdStatus =lisOrdStatus +" background-repeat-y: no-repeat;";
		lisOrdStatus =lisOrdStatus +" background-repeat-x: no-repeat;";
		lisOrdStatus =lisOrdStatus +" background-repeat: no-repeat;";

	}
	
	var retHtml=""
	retHtml = 		  '<div style="'+lisOrdStatus+'" title="'+rowData.ArcimName+'" class="hisui-tooltip" style="width:210px">'
	retHtml= retHtml+ 	'<h1 style="font-weight: normal;line-height:24px">'+rowData.ArcimName.substring(0,17)+'</h1>'
	retHtml= retHtml+ 	'<h1 style="font-weight: normal;line-height:24px">'+rowData.OrdDateTime+'</h1>'
	retHtml= retHtml+'</div>'
	return retHtml;
}

function upPacsDate(select,value){
	if(!select) return;
	if(value==1){
		$HUI.datebox("#sel-stDate").setValue(formatDate(0));
		$HUI.datebox("#sel-edDate").setValue(formatDate(0));
	}
	
	if(value==2){
		$HUI.datebox("#sel-stDate").setValue(formatDate(-30));
		$HUI.datebox("#sel-edDate").setValue(formatDate(0));
	}
	
	if(value==3){
		$HUI.datebox("#sel-stDate").setValue(formatDate(-180));
		$HUI.datebox("#sel-edDate").setValue(formatDate(0));
	}
	
	if(value==4){
		$HUI.datebox("#sel-stDate").setValue("");
		$HUI.datebox("#sel-edDate").setValue("");
	}
	return;
}

function openLittleThree(){
	var url="";
	url = "http://192.168.100.17/query?login_name=doctor&password=111111&role_name=clinicViewer&patient_id=HIS:";
	url = url+RegNo;
	showImg(url)	
}


function initShowThisAdmCheck(){
	if(EpisodeID===""){
		$("#thisAdm").hide();
	}	
}

function resizeLayout(){
	$HUI.layout("#center-layout").resize();	
}

function orderviewArci(value, rowData, rowIndex){
	return "<a style='text-decoration:none;color:#017bce;' href='javascript:void(showOrderview(\"" + rowData.OEORIId + "\"))';>"+value+"</a>";;
}
function formatterInsureList(value, rowData, rowIndex){
	return "<a style='text-decoration:none;color:#017bce;' href='javascript:void(showInsureListview(\"" + rowData.ARCIMId + "\",\""+ rowData.PartID +"\"))';>"+$g("说明书")+"</a>";;
}
function showOrderview(ord){
	var obj={
		winHeight:300
	}
	$.orderview.show(ord,obj);
	return;
}

/// Modify  20230322
/// 旧版知识库的链接，标版停用。药品说明书使用新产品组合理用药，检查检验等将使用基础数据平台
function showInsureListview(ARCIMId,PartID){
	var itemHtml = "";
	if(Common_ControlObj.LibPhaFunc.ZSKOpenFlag=="Y"){
		itemHtml = GetItemInstr(ARCIMId, PartID);
	}
	if (itemHtml == "") {
		$.messager.alert("提示","未启用或未维护相应说明书!","warning");
		return;
	}
	$("#itro_content").html(itemHtml); 
	$HUI.window("#readInter").open();
}
/// 提取检查项目说明书
/// 此方法需与医嘱录入统一。待新版检查检验知识库说明书
function GetItemInstr(itmmastid, itemPartID){
	var html = '';
	// 获取显示数据
	runClassMethod("web.DHCAPPExaReportQuery","GetItemInstr",{"itmmastid":itmmastid, "itemPartID":itemPartID},function(jsonString){

		if (jsonString != ""){
			var jsonObject = jsonString;
			html = initMedIntrTip(jsonObject);
		}else{
			html = "";
		}
	},'json',false)
	return html;
}
/// 初始化知识库信息描述
function initMedIntrTip(itmArr){
	
	var htmlstr = '';
	for(var i=0; i<itmArr.length; i++){
		
		htmlstr = htmlstr + "<table  cellpadding='0' cellspacing='0' class='itro_content'>" //<tr><td style='background-color:#F6F6F6;width:120px' >〖检查项目〗</td><td colspan='2'  style='border-right:solid #E3E3E3 1px'>"+itmArr[i].geneDesc+"["+itmArr[i].pointer+"]</td></tr>";
		htmlstr = htmlstr + "<tr><td style='background-color:#F6F6F6;font-weight:bold; font-size:14px;'>"+itmArr[i].itemTile+"</td></tr>";
		htmlstr = htmlstr + "<tr><td style='border-right:solid #E3E3E3 1px; font-size:14px; padding-left: 10px;'>"+itmArr[i].itemContent+"</td></tr>";
		htmlstr = htmlstr + "</table>";
	}

   return htmlstr;
}
//tanjishan
//2020-09-22
//考虑到目前该界面的应用场景，只做了界面数据刷新，并未实现切换患者的功能
function xhrRefresh(refreshArgs){
	$("#search").click()
    if ((PageLogicObj.MainSreenFlag==0)&&(EpisodeID!="")){
		websys_emit("onSelectIPPatient",{PatientID:PatientID,EpisodeID:EpisodeID,mradm:""});
	}
}

function mySort(a,b) {
	if ((a.indexOf("/")>=0)||(a.indexOf("/")>=0)){
	a = a.split('/');
	b = b.split('/');
	if (a[2] == b[2]){
		if (a[0] == b[0]){
			a[1] = parseFloat(a[1]);
			b[1] = parseFloat(b[1]);
			return (a[1]>b[1]?1:-1);
		} else {
			a[0] = parseFloat(a[0]);
			b[0] = parseFloat(b[0]);
			return (a[0]>b[0]?1:-1);
		}
	} else {
		a[2] = parseFloat(a[2]);
		b[2] = parseFloat(b[2]);
		return (a[2]>b[2]?1:-1);
	}
	}else{
	a = a.split('-');
	b = b.split('-');
	if (a[0] == b[0]){
		if (a[1] == b[1]){
			a[2] = parseFloat(a[2]);
			b[2] = parseFloat(b[2]);
			return (a[2]>b[2]?1:-1);
		} else {
			a[1] = parseFloat(a[1]);
			b[1] = parseFloat(b[1]);
			return (a[1]>b[1]?1:-1);
		}
	} else {
		a[0] = parseFloat(a[0]);
		b[0] = parseFloat(b[0]);
		return (a[0]>b[0]?1:-1);
	}
	
	}
}
