var OutPatientDataGrid;
var patientMap={
	"call":{},
	"recall":{},
	"skip":{}	
}; 
var dianosingWinMap={};
var dianosingMap={};
var refreshTimeout=120000;
var toolsConfigInfo=null;
var clickEnable=true;
var dw=$(window).width()-166,dh=$(window).height()-80;
$(function(){
	Init();
});
function Init(){
	InitOutPatientDataGrid();
	LoadOutPatientDataGrid();
	//非接诊界面打开的患者列表不显示按钮行
	//if (ServerObj.openWinName!="recAdm"){
		LoadToolbarConfigAndRend();
	//}
	InitCombobox();
	InitEvent();
    setInterval(function(){
	    LoadOutPatientDataGrid();
	},refreshTimeout);
}
window.onload = function () {
	if (ServerObj.OPDefDisplayMoreContions==1) {
		$("#BMore").click();
	}
}
function InitEvent(){
	$("#PatName").keydown(function(e){
		PatNameKeydownHandler(e);
	});
    $HUI.datebox("#DateFrom,#DateTo",{
	   onSelect:function(date){
		   LoadOutPatientDataGrid();
		   return true;
   	   }
   });
   $("#diagnosingPanel").click(function(e){
	   var t=$(e.target);
	   var id=t.parent().attr("id");
	   if(dianosingMap[id]) {
			if(t.hasClass("panel-tool-close")){
				dianosingWinMap[id].window('destroy');
				removeDianose(id);
			}else{
				dianosingWinMap[id].window('open');
			}
		}
   });
   $("#CloseAllCurTreatAdm").click(function(e){
	   for(var pat in dianosingMap){
			removeDianose(pat);
			$("#win_"+pat).window('destroy');
		}
   });
   $("#ReadCard").click(ReadCardClickHandler);
   $("#BFind").click(LoadOutPatientDataGrid);
   $("#RegQue").click(function(){
	   LeftBtnClick("RegQue");
   });
   $("#ArrivedQue").click(function(){
	   LeftBtnClick("ArrivedQue");
   });
   $("#Report").click(function(){
	   LeftBtnClick("Report");
   });
   //$("#BMore").click(BMoreClickHandle);
   $(document.body).bind("keydown",BodykeydownHandler);
   
}
function ResizePatListWindow(){
	var width=$(window).width();
	var height=$(window).height();
	$('#MainWin,#Search-div').attr("style","width:"+width+"px;height:"+height+"px;");
	$('#MainWin,#Search-div').layout("resize",{
		width:width+"px",
		height:height+"px"
	});
	$('#OutPatientTable').datagrid('resize',{
       width:width+"px",
       heigth:(height-180)+"px"
   })
}
function BodykeydownHandler(e){
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
		if ((SrcObj.tagName=="A")||(SrcObj.tagName=="INPUT")) {
			if (SrcObj.id=="CardNo"){
				CardNoKeydownHandler(e);
				return false;
			}else if(SrcObj.id=="RegNo"){
				RegNoKeydownHandler(e);
				return false;
			}
			return true;
		}
	}
}
function InitCombobox(){
	//初始化号别下拉框
	$.m({
	    ClassName:"DHCDoc.OPDoc.PatientList",
	    MethodName:"DocRegList",
	    userId:session['LOGON.USERID'],
	    locId:session['LOGON.CTLOCID']
	},function(val){
		var cbox = $HUI.combobox("#MarkDocList", {
			valueField: 'id',
			textField: 'des', 
			data: eval("("+val+")"),
			onSelect: function (rec) {
				LoadOutPatientDataGrid();
			},
			onChange:function(newValue,oldValue){
				if (newValue==""){
					LoadOutPatientDataGrid();
				}
			}
	   });
	});
}
function LeftBtnClick(id,CheckName){
	$(".a-oplist-selected").removeClass("a-oplist-selected");
	$("#"+id).addClass("a-oplist-selected");
	LoadOutPatientDataGrid();
}
function InitOutPatientDataGrid(){
	var Columns=[[
		{field:'PatientID',title:'',hidden:true},
		{field:'mradm',title:'',hidden:true},
		/*{field:'LocSeqNo',title:'序号',align:'center',width:50},
		{field:'PAPMINO',title:'登记号',align:'center',width:120},
		{field:'PAPMIName',title:'姓名',align:'center',width:70,
			formatter: function(value,row,index){
				var btn = '<a class="editcls" onclick="ShowPatInfo(\'' + row.EpisodeID + '\')">'+value+'</a>';
				return btn;
			}
		},*/
		{field:'PAPMISex',title:'性别',width:50},
		{field:'PAPMIDOB',title:'出生日期',width:100},
		{field:'Age',title:'年龄',width:40},
		{field:'WalkStatus',title:'状态',width:70,
			styler: function(value,row,index){
				var WalkStatus=row['StatusCode'];
				if (WalkStatus=='03'){
					return 'background-color: #ff7373  !important;color:#fff !important;';
				}
			}
		},
		{field:'Diagnosis',title:'诊断',width:200},
		{field:'RegDoctor',title:'号别',width:150},
		{field:'PAAdmDocCodeDR',title:'医生',width:100},
		{field:'PAAdmDepCodeDR',title:'科室',width:100},
		{field:'PAAdmReason',title:'费别',width:70},
		{field:'PAAdmDate',title:'就诊日期',width:90},
		{field:'PAAdmTime',title:'就诊时间',width:90},
		{field:'ArrivedDate',title:'到达日期',width:90},
		{field:'ArrivedTime',title:'到达时间',width:90},
		{field:'Called',title:'呼叫状态',align:'center',width:50,hidden:true},
		{field:'DrugsStatus',title:'药品',align:'center',width:70,
			formatter: function(value,row,index){
				return renderWorkStatusCols(value,row,"Drug");
			}
		},
		{field:'InspectStatus',title:'检查',align:'center',width:70,
			formatter: function(value,row,index){
				return renderWorkStatusCols(value,row,"Exam");
			}
		},
		{field:'LaboratoryStatus',title:'化验',align:'center',width:70,
			formatter: function(value,row,index){
				return renderWorkStatusCols(value,row,"Lab");
			}
		},
		{field:'TreatmentStatus',title:'治疗',align:'center',width:70,
			formatter: function(value,row,index){
				return renderWorkStatusCols(value,row,"Treat");
			}
		},
		/*{field:'EpisodeID',title:'转诊',align:'center',width:70,
			formatter: function(value,row,index){
				return '<a><img style="cursor:pointer" src="../images/websys/update.gif" border="0" onclick="PatTransfer('+value+')"></a>';
			}
		},
		{field:'CancleEpisodeID',title:'取消接诊',align:'center',width:70,
			formatter: function(value,row,index){
				return '<a><img style="cursor:pointer" src="../images/websys/delete.gif" border="0" onclick="CancelAdmiss('+row.EpisodeID+')"></a>';
			}
		},*/
		{field:'PAAdmPriority',title:'优先级',width:90},
		{field:'ConsultRoom',title:'诊室',width:90},
		{field:'ConsultArea',title:'诊区',width:90},
		{field:'TSecretLevel',title:'密级',width:90},
		{field:'TPoliticalLevel',title:'级别',width:90},
		{field:'RegRangeTime',title:'时段',width:90},
		{field:'RegAdmSource',title:'来源',width:90}
		
   ]]
	OutPatientDataGrid=$("#OutPatientTable").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		autoSizeColumn : false,
		rownumbers:false,
		pagination : false,  //
		rownumbers : false,  //
		frozenColumns:[[
			{field:'LocSeqNo',title:'序号',align:'center',width:50},
			{field:'PAPMINO',title:'登记号',align:'center',width:120,
				formatter: function(value,row,index){
					var btn = '<a class="editcls" onclick="ShowPatInfo(\'' + row.EpisodeID + '\')">'+value+'</a>';
					return btn;
				}
			},
			{field:'PAPMIName',title:'姓名',align:'center',width:70,
				formatter: function(value,row,index){
					 var admDate=row.PAAdmDate;
					 if ((!CheckAdmDate(admDate))||($(".a-oplist-selected")[0].id!="RegQue")) {
						return value;
					 }else{
						 var btn = '<a class="editcls" onclick="callOnePatient(\'' + row.EpisodeID + '\')">'+value+'</a>';
						return btn;
					 }
				}
			}
		]],
		idField:'EpisodeID',
		columns :Columns,
		rowStyler: function(index,row){
			var Called=row['Called']; 
			if (Called=="1"){
				 return 'background-color: #21ba45 !important;color:#fff !important;'; //#00DC00
			}
			if (Called=="2"){
				return 'background-color: #d2eafe  !important;color:#000 !important;';
			}
		},
		onDblClickRow:function(rowIndex, rowData){
			doSwitch(rowData.PatientID,rowData.EpisodeID,rowData.mradm,rowData.WalkStatus,true); 
		},
		onLoadSuccess:function(data){
			UpdateOutPatListCatCount();
		},onCheck:function(index, row){
			recordeSelectForTools(toolsConfigInfo,row,true);
		},onUncheck:function(index, row){
			recordeSelectForTools(toolsConfigInfo,row,false)
		}
	})
}
function doSwitch(PatientID,EpisodeID,mradm,WalkStatus,autoClose) {
	//tanjishan 2020.05.20为防止上一位患者的电子病历尚未加载完毕，在切换之前，判断下上一位患者是否在电子病历组件中处理完毕
	///  切换病人前，判断是不是正在切换中
	var frm = dhcsys_getmenuform();
	if (frm){
	    if (frm.DoingSth.value!="") {
	        $.messager.alert("提示",frm.DoingSth.value+"请稍后再试");
	        return false; //不能切换病人
	    }
	}


	if(top.frames[0] && top.frames[0].switchPatient){
		top.frames[0].switchPatient(PatientID,EpisodeID,mradm,WalkStatus);
		if (autoClose){
			top.frames[0].hidePatListWin();
		}
	}else{
		parent.switchPatient(PatientID,EpisodeID,mradm,WalkStatus);
		if (autoClose){
			parent.hidePatListWin();
		}
	}
	return ;
}
function LoadOutPatientDataGrid(){
	$.m({
	    ClassName : "DHCDoc.OPDoc.PatientList",
	    MethodName : "OutPatientList",
	    LocID: session['LOGON.CTLOCID'],
	    UserID: session['LOGON.USERID'],
	    IPAddress: "",
	    AllPatient: "",
	    PatientNo: $("#RegNo").val(),
	    SurName: $("#PatName").val(),
	    StartDate: $("#DateFrom").datebox('getValue'),
	    EndDate: $("#DateTo").datebox('getValue'),
	    ArrivedQue: "",
	    RegQue: "",
	    Consultation:"",
	    MarkID:$("#MarkDocList").combobox('getValue'),
	    CheckName:$(".a-oplist-selected")[0].id,
	    page:1,
	    rows:99999
	},function(GridData){
		GridData=eval("("+GridData+")");
		OutPatientDataGrid.datagrid("unselectAll").datagrid('loadData',GridData);
	});
}
function UpdateOutPatListCatCount(){
	$.m({
	    ClassName : "DHCDoc.OPDoc.PatientList",
	    MethodName : "OutPatientListCatCount",
	    LocID: session['LOGON.CTLOCID'],
	    UserID: session['LOGON.USERID'],
	    IPAddress: "",
	    AllPatient: "",
	    PatientNo: $("#RegNo").val(),
	    SurName: $("#PatName").val(),
	    StartDate: $("#DateFrom").datebox('getValue'),
	    EndDate: $("#DateTo").datebox('getValue'),
	    ArrivedQue: "",
	    RegQue: "",
	    Consultation:"",
	    MarkID:$("#MarkDocList").combobox('getValue'),
	    CheckName:$(".a-oplist-selected")[0].id
	},function(data){
		var data=eval("("+data+")");  //"{"RegQue":4,"Complete":0,"Report":0}"
		for(var pro in data){
			$("#"+pro+"Num").text(data[pro]);
		}
		parent.$("#WaitPatNum").html("待就诊患者："+data['RegQue']+"人");
	}); 
}
function ShowPatInfo(EpisodeID){
	$.ajax("opdoc.patientbasicinfo.csp", {
		"type" : "GET",
		"dataType" : "html",
		"success" : function(data, textStatus) {
			var $code = $(data);
			createModalDialog("PatInfoDiag","患者基本信息", 600, 207,"icon-w-card","",$code,"");
			PatientInfo(EpisodeID);
		},

		"error" : function(XMLHttpRequest, textStatus, errorThrown) {
			console.log(textStatus);
		}
	});
}
function PatientInfo(EpisodeID){
	$.m({
	    ClassName:"DHCDoc.OPDoc.AjaxPatientAgentInfor",
	    MethodName:"NurPatInfo",
	    EpisodeID:EpisodeID
	},function(val){
		var PatInfoArr = val.split("^");
		$("#patno").val(PatInfoArr[4]);
		$("#patname").val(PatInfoArr[0]);
		$("#Age").val(PatInfoArr[2]);
		$("#Sex").val(PatInfoArr[1]);
		$("#National").val(PatInfoArr[16]);
		$("#Address").val(PatInfoArr[13]);
		$("#lxman").val(PatInfoArr[17]);
		$("#homtel").val(PatInfoArr[14]);
		//加入图片base64应用
		var PhotoInfo=PatInfoArr[20];
		if (PhotoInfo!=""){
			var src="data:image/png;base64,"+PhotoInfo;
		}else{
			var src="../images/uiimages/patdefault.png";
		}
		ShowPicBySrcNew(src,"imgPic");
	})
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if ((_width == null)||(_width<0))
        _width = 800;
    if ((_height == null)||(_height<0))
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
function CloseDialog(id){
   $('#'+id).dialog('close');
}
function destroyDialog(id){
   $("body").remove("#"+id); //移除存在的Dialog
   $("#"+id).dialog('destroy');
}
function CardNoKeydownHandler(e){
   var key=websys_getKey(e);
   var CardNo=$("#CardNo").val();
   var RegNo=$("#RegNo").val();
   if (key==13) {
		if (CardNo!="") {
			var myrtn=DHCACC_GetAccInfo("",CardNo,"","PatInfo",CardTypeCallBack);
		}else if (RegNo!=""){
			$("#RegNo").val("");
			LoadOutPatientDataGrid();
		}
		return false;
   }
}
function CardTypeCallBack(myrtn){
   var myary=myrtn.split("^");
   var rtn=myary[0];
	switch (rtn){
		case "0": //卡有效有帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").focus().val(CardNo);
			$("#RegNo").val(PatientNo);
			LoadOutPatientDataGrid();
			event.keyCode=13;			
			break;
		case "-200": //卡无效
			$.messager.alert("提示","卡无效!","info",function(){$("#CardNo").focus();});
			break;
		case "-201": //卡有效无帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").focus().val(CardNo);
			$("#RegNo").val(PatientNo);
			LoadOutPatientDataGrid();
			event.keyCode=13;
			break;
		default:
	}
}
function RegNoKeydownHandler(e){
   var key=websys_getKey(e);
   var RegNo=$("#RegNo").val();
   if (key==13) {
	   if (RegNo!=""){
		   var T_IDLength=10;
		   if ((RegNo.length<T_IDLength)&&(T_IDLength!=0)) {
				for (var i=(T_IDLength-RegNo.length-1); i>=0; i--) {
					RegNo="0"+RegNo;
				}
		   }
	   }
	   $("#RegNo").val(RegNo);
	   LoadOutPatientDataGrid();
	   return false;
   }
}
function PatNameKeydownHandler(e){
   var key=websys_getKey(e);
   var PatName=$("#PatName").val();
   if (key==13) {
	   LoadOutPatientDataGrid();
	   return false;
   }
}
function renderWorkStatusCols(value,row,renderType){
   if(!row["EpisodeID"]) return "";
   var ic=getWorkStatusIcon(value);
   if(ic==null) return "";
   return '<span id="'+row["EpisodeID"]+'-'+renderType+'-TTP">'+ic+'</span>'; //class="hisui-tooltip" data-options="position:'+"left"+'"
}
function getWorkStatusIcon(statusCode,otherClass,style){
    var ic=null;
	if(statusCode=="S3"){
		ic="icon-ok status-finish"; //完成（做了并出结果）  icon-ok
	}else if(statusCode=="S2"){
		ic="icon-funnel-half status-s2"; //部分完成（病人做了没有出结果） icon-funnel-half
	}else if(statusCode=="S1"){
		ic="icon-funnel-empty hisui-linkbutton"; //未完成（医生开了但病人没有做） icon-funnel-empty
	}else if(statusCode=="S0"){
		return null;
	}else if(statusCode.length>2){
		if(statusCode.indexOf("S3")>0 || statusCode.indexOf("S2")>0 || statusCode.indexOf("S1")>0){
			ic="icon-funnel-half status-s1"; //fa fa-hourglass-o
		}
	}
	if(ic==null) return ic;
	if(otherClass!=undefined){
		ic+=" "+otherClass;
	}
	return '<a onmouseover="ShowTipMessage(this)" href="#" class="'+ic+'" data-options="plain:true">&nbsp;&nbsp;&nbsp;&nbsp;</a>';
}
function ShowTipMessage(that){
   var id=$($(that).parent())[0].id;
   if (id=="") return false;
   var epid=id.split("-")[0]; //"285-Drug-TTP"
   var targetType=id.split("-")[1];
   $.m({
		ClassName:"DHCDoc.OPDoc.PatientList",
		MethodName:"GetOPHandleStatusData",
		EpisodeID:epid,
		format:"JSON",
		list:""
	},function(jsonData){
		var json=$.parseJSON(jsonData);
		var html=[];
			html.push('<div class="panel panel-default" style="border:none;">');
			html.push('<div class="panel-body" style="border:none;background-color:#4C4C4C;">');
		if (targetType=="Drug"){var title=$g("药品");}
		if (targetType=="Exam"){var title=$g("检查");}
		if (targetType=="Lab"){var title=$g("化验");}
		if (targetType=="Treat"){var title=$g("治疗");}
		$(that).webuiPopover({
			width:400,
			content:function(){
				html.push('<div class="panel panel-default" style="border:none;">')
				html.push('</div><div class="panel-body" style="padding:0px;background-color:#4C4C4C;border:none;max-height:260px;">');
				for(var i in json){
					var des=json[i]["des"];
					if ((des.indexOf($g("药品"))>=0)&&(targetType!="Drug")) continue;
					if ((des.indexOf($g("检查"))>=0)&&(targetType!="Exam")) continue;
					if ((des.indexOf($g("化验"))>=0)&&(targetType!="Lab")) continue;
					if ((des.indexOf($g("治疗"))>=0)&&(targetType!="Treat")) continue;
					var st=json[i]["status"];
					html.push('<span style="color:white;line-height:25px;">'+json[i]["des"]+'</span></br>');
					for(var li in json[i]["list"]){
						html.push('<span style="color:white;line-height:25px;">'); //white-space:nowrap;
						if (targetType=="Lab"){
							html.push(json[i]["list"][li]); //(+li+1)+". "+
						}else{
							html.push((+li+1)+". "+json[i]["list"][li]);
						}
						html.push('</br>');
						html.push('</span>');
					}
					
				}
				html.push('</div></div>');
				html.push('</div></div>');
				var htmlCode= html.join('');
				delete html;
				return htmlCode;
			},
			trigger:'hover', 
			placement:'auto'
		});
		$(that).webuiPopover('show');
	});
}
function LoadToolbarConfigAndRend(){
   $.q({
		ClassName:"DHCDoc.OPDoc.TreatStatusConfigQuery",
		QueryName:"TreatStatusConfig",
		CSPMain:"opdoc.outpatientlist.csp",
		ActiveOrNo:"1",
		page:1,  
		rows:200
   },function(jsonData){
		toolbarConfigRender(jsonData.rows);
   });
}
function toolbarConfigRender(configs){
   toolsConfigInfo=configs;
   var templ=$("#toolbarTemplate");
   var panel=$("#toolbarPanel");
   for(var i=0,len=configs.length;i<len;++i){
	   (function(i){
		   var config=configs[i];
		   var tool=templ.clone();
		   tool.removeAttr("style");
		   tool.removeAttr("id");
		   var a=$("a",tool).attr("id",config["toolId"]);
		   if(config["iconStyle"]){
			   $("a",tool).find("span").eq(2).addClass(config["iconStyle"]);
		   }else{
			   $("a",tool).find("span").eq(2).addClass('icon-big-save');
			   
		   }
		   $("a",tool).find("span").eq(1).text($g(config["name"]))
		   if(config["verSplitLine"]=="true") {
				tool.addClass("global-opdoc-verline");
		   }
		   panel.append(tool);
		   if(config["clickHandler"]){
			   var fun=config["clickHandler"]
			   if($.type(fun) === "string"){
				    //a.click(eval(fun));
				    a.click((function(){
					    return function(){
						    eval("("+fun+")")(config)
						};
					})(fun,config));
			   }else{
				    a.click(fun(config));
			   }
		   }
		})(i)
   }
   var frm=top.document.forms['fEPRMENU'];
   var frmEpisodeID=frm.EpisodeID.value;
   if (frmEpisodeID!=""){
	   recordeSelectForTools(configs,null,true);
   }else{
	   recordeSelectForTools(configs,null,false);
   }
}
//check the action for a patient shuold be called
function checkForCall(toolId,rowData,selected){
	if(selected &&(toolId=="skipCallPatient" || toolId=="TransferPat" || toolId=="CancelAdmiss" || toolId=="ReceiveTreatment") || toolId=="CompleteAdm"){
		return true;
	}else if((toolId=="callPatient" || toolId=="reCallPatient" || toolId=="Registration" || toolId=="Refund")){
		return true;
	}else if ((toolId=="PatArrive")&&(($(".a-oplist-selected")[0].id=="Report")||((rowData)&&(rowData['StatusCode']='03')))){
		return true;
	}
	return false;
}
//listener the select action for change the toolbar status
function recordeSelectForTools(toolsConfigInfo,rowData,selected){
	for(var i=0,len=toolsConfigInfo.length;i<len;++i){
		var config=toolsConfigInfo[i];
		var toolId=config["toolId"];
		var targ=$("#"+toolId);
		if(checkForCall(toolId,rowData,selected)){
		    targ.removeAttr("disabled").removeClass("disabled");
		    clickEnable=true;
		    if(config["activeStatus"]){
				var fun=config["activeStatus"];
				fun=fun+"({data:config})";
				eval(fun);
		    }
	    }else{
		    targ.attr("disabled","disabled").addClass("disabled");
		    clickEnable=false;
		    if(config["disableStatus"]){
				var fun=config["disableStatus"];
				fun=fun+"({data:config})";
				eval(fun);
		    }
	    }
	}
	/*var frm=top.document.forms['fEPRMENU'];
	var frmEpisodeID=frm.EpisodeID;
	var frmPatientID=frm.PatientID;
	var frmmradm=frm.mradm;
	if (selected){
		if ((rowData)&&(rowData["EpisodeID"])){
			if (frmEpisodeID.value!=rowData["EpisodeID"]){
				doSwitch(rowData.PatientID,rowData.EpisodeID,rowData.mradm,rowData.WalkStatus,false); 
			}
			frmPatientID.value=rowData["PatientID"];
			frmEpisodeID.value=rowData["EpisodeID"];
			frmmradm.value=rowData["mradm"];
		}
	}else{
		frmPatientID.value="";
		frmEpisodeID.value="";
		frmmradm.value="";
	}*/
	
}
function fontawesomeActiveStatus(e){
	if(clickEnable)return true;
	var config=e.data;
	var $a=$("#"+config["toolId"]);
	$a.addClass("tool-opdoc-active");
}
function fontawesomeDisableStatus(e){
	if(clickEnable)return true;
	var config=e.data;
	var $a=$("#"+config["toolId"]);
	$a.removeClass("tool-opdoc-active");
}
function passNoActiveStatus(e){
	if(clickEnable)return true;
	var config=e.data;
	var $a=$("#"+config["toolId"]);
}
function passNoDisableStatus(e){
	if(clickEnable)return true;
	var config=e.data;
	var $a=$("#"+config["toolId"]);
	$("img",$a).attr("src",config["iconRoute"]);
}
function callPatientHandler(event){
   var IPAddress = GetComputerIp();
   if (IPAddress) {
		var row=OutPatientDataGrid.datagrid('getRows');
		if ((row || row.length>0)&&(row[0].EpisodeID)){
			$("#datagrid-row-r1-2-0").removeClass("row-oplist-recalled row-oplist-skip").addClass("row-oplist-called");
			patientMap["call"][row[0].EpisodeID]="row-oplist-called";
		}
	}else{
		IPAddress="";
	}
	var MarkID=$("#MarkDocList").combobox('getValue');
	if (!MarkID) MarkID="";
	if((IPAddress!="Exception")&&(IPAddress!="")){
		var ret=tkMakeServerCall("web.DHCVISQueueManage","RunNextButton","","",IPAddress,MarkID);
	}else{
	    var ret=tkMakeServerCall("web.DHCVISQueueManage","RunNextButton","","","",MarkID);
	}
	CalledAfter(ret);
}
function reCallPatientHandler(event){
   var IPAddress = GetComputerIp();
   var alertCode=null;
	if (IPAddress) {
		var row=OutPatientDataGrid.datagrid('getRows');
		if ((row || row.length>0)&&(row[0].EpisodeID)){
			$("#datagrid-row-r1-2-0").removeClass("row-oplist-called row-oplist-skip").addClass("row-oplist-recalled");
			patientMap["recall"][row[0].EpisodeID]="row-oplist-recalled";
		}
	} else {
		IPAddress="";
	}
	var MarkID=$("#MarkDocList").combobox('getValue');
	if (!MarkID) MarkID="";
	if((IPAddress!="Exception")&&(IPAddress!="")){
		var ret=tkMakeServerCall("web.DHCVISQueueManage","RecallButton","","",IPAddress,MarkID);
	}else{
	    var ret=tkMakeServerCall("web.DHCVISQueueManage","RecallButton");
	}
	CalledAfter(ret);
	return false;
}
function findPatientTree(){
   LoadOutPatientDataGrid();
}
function skipCallPatientHandler(event){
	if ($("#skipCallPatient").hasClass('disabled')){
		return false;
	}
	var row=OutPatientDataGrid.datagrid('getSelected');
	if (!row || row.length<=0) {
		 $.messager.alert("提示",t['SelectOnePatient']);
		 return false;
	}
	 if(!row.EpisodeID)return false;
	 if (row.Called==""){
		 $.messager.alert("提示","没有呼叫的患者不能过号!");
		return false;
	 }
	 var selIndex=OutPatientDataGrid.datagrid('getRowIndex',row);
	 $("#datagrid-row-r1-2-0").removeClass("row-oplist-called row-oplist-recalled").addClass("row-oplist-skip");
	 var admDate=row.PAAdmDate;
	 if (!CheckAdmDate(admDate)) {
		$.messager.$.messager.alert("提示",t['AdmDateOver']);
		return false;
	 }
	 if (row.PAAdmPriority=="优先"){
		 $.messager.alert("提示","优先的患者不能过号!");
		return false;
	 }
	 $.messager.confirm('确认对话框', t['SkipNumberMsg'], function(r){
		if (r){
		    patientMap["recall"][row.EpisodeID]="row-oplist-recalled";
		    $.cm({ 
				ClassName:"web.DHCDocOutPatientList",
				MethodName:"SetSkipStatus", 
				Adm:row.EpisodeID,
				DocDr:ServerObj.DocDr
			},function(stat){
				if (stat!='1'){
					$.messager.alert("提示",t['StatusFailure']);
					return false;
				}else{
					LoadOutPatientDataGrid();
				}
			});
		}
	});		 
}
function admissionsHandler(){
   var row=OutPatientDataGrid.datagrid('getSelected');
   if (!row || row.length<=0) {
	   	 var frm=top.document.forms['fEPRMENU'];
		 var frmEpisodeID=frm.EpisodeID.value;
		 var frmPatientID=frm.PatientID.value;
		 if (frmEpisodeID==""){
			 $.messager.alert("提示",t['SelectOnePatient']);
			 return false;
		 }else{
			 var data=new Object();
			 data["EpisodeID"]=frmEpisodeID;
			 $.cm({
				ClassName:"DHCDoc.OPDoc.PatientList",
				MethodName:"GetPatNameByAdm",
				dataType:"text",
				EpisodeID:frmEpisodeID
			},function(PatName){
				data["PAPMIName"]=PatName;
				loadOutpatrecadmWin(data);
			});
		 }
   }else{
	   loadOutpatrecadmWin(row);
   }
}
function registrationHandler(config){
   var src=replaceLinkParams(config["URLconfig"]);
   if (src.indexOf("?")>=0){
	   src=src+"&winfrom=outpatlist"
   }else{
	   src=src+"?winfrom=outpatlist"
   }
   websys_showModal({
		url:src,
		title:config["name"],
		LoadOutPatientDataGrid:LoadOutPatientDataGrid,
		CloseDialog:CloseDialog,
		width:600,height:327
   });
}
function refundHandler(config){
   var maxH=$("#Search-div").height();
   var maxW=$("#Search-div").width();
   var src=replaceLinkParams(config["URLconfig"]);
    websys_showModal({
		url:src,
		title:config["name"],
		width:'97%',height:'95%'
   });
}
function replaceLinkParams(lnk){
    var frm=top.document.forms['fEPRMENU'];
	var frmEpisodeID=frm.EpisodeID.value;
	var frmPatientID=frm.PatientID.value;
	var frmmradm=frm.mradm.value;
	var ret = lnk.replace('@patientID', frmPatientID);
	    ret = ret.replace('@episodeID', frmEpisodeID);
	    ret = ret.replace('@mradm', frmmradm);
	    return ret;
}
function GetComputerIp() {
	return ClientIPAddress;
	/*var ipAddr="";
	var locator = new ActiveXObject ("WbemScripting.SWbemLocator");
	//连接本机服务器
	var service = locator.ConnectServer(".");
	//查询使用SQL标准 
	var properties = service.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration");
	var e = new Enumerator (properties);
	var p = e.item ();
	for (;!e.atEnd();e.moveNext ())  {
		var p = e.item ();
		//IP地址为数组类型,子网俺码及默认网关亦同
		//document.write("IP:" + p.IPAddress(0) + " ");
		ipAddr=p.IPAddress(0);
		if(ipAddr) break;
	}
	return ipAddr;*/
}
function CheckAdmDate(AdmDate)	{
	var ToDay= new Date();
	var Year=ToDay.getFullYear();
	var Month=ToDay.getMonth();
	Month=Month+1;
	if (Month<10) {Month='0'+Month;}
	var Day=ToDay.getDate();
	if (Day<10) Day='0'+Day;
	if (ServerObj.sysDateFormat=="4"){
		var StrDate=Day+'/'+Month+'/'+Year
	}else{
		var StrDate=Year+'-'+Month+'-'+Day
	}
	if (StrDate==AdmDate) {return true}
	else  {return false;}	
}
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
function ReadCardClickHandler(){
	var myrtn=DHCACC_GetAccInfo7(CardTypeCallBack);
}
function toggleExecInfo(ele){
	if ($(ele).hasClass('expanded')){  //已经展开 隐藏
		$(ele).removeClass('expanded');
		$("#BMore")[0].innerText=$g("更多");
    	$("#more,#dashline").hide();
    	setHeight("-43");
	}else{
		$(ele).addClass('expanded');
		$("#BMore")[0].innerText=$g("隐藏");
		$("#more,#dashline").show();
    	setHeight('43');
	}
	function setHeight(num){
        var c=$("#Search-div");
        var p=c.layout('panel', 'north');
        var Height=parseInt(p.outerHeight())+parseInt(num);
        p.panel('resize',{height:Height}); 
        
		var p = c.layout('panel','center');	// get the center panel
		var Height = parseInt(p.outerHeight())-parseInt(num);
		p.panel('resize', {height:Height})
		if (+num>0) p.panel('resize',{top:86});
		else p.panel('resize',{top:40});
    }
}
function CompleteAdmHandle(){
	var row=OutPatientDataGrid.datagrid('getSelected');
   	if (!row || row.length<=0) {
	   	 var frm=top.document.forms['fEPRMENU'];
		 var frmEpisodeID=frm.EpisodeID.value;
		 var frmPatientID=frm.PatientID.value;
		 if (frmEpisodeID==""){
			 $.messager.alert("提示",t['SelectOnePatient']);
			 return false;
		 }else{
			 CompleteAdm(frmEpisodeID);
		 }
   	}else{
	   	if (!row["EpisodeID"]) return false;
	    CompleteAdm(row["EpisodeID"]);
   	}
function CompleteAdm(Adm){
	   	$.m({
			ClassName:"web.DHCDocOutPatientList",
			MethodName:"SetComplate",
			Adm:Adm,
			LocId:session['LOGON.CTLOCID'],
			UserId:session['LOGON.USERID']
		},function(rtn){
			if (rtn!="0"){
				$.messager.alert("提示",rtn.split("^")[1]);
				return false;
			}else{
				LoadOutPatientDataGrid();
			}
		});
	}
}
//转诊
function PatTransfer(){
	var row=OutPatientDataGrid.datagrid('getSelected');
	if (!row || row.length<=0) {
		 $.messager.alert("提示",t['SelectOnePatient']);
		 return false;
	}
	var EpisodeID=row.EpisodeID;
	if(!EpisodeID)return false;
	var Status=$.cm({ 
			ClassName:"web.DHCDocTransfer",
			MethodName:"GetQueStatusByAdm", 
			Adm:EpisodeID,
			dataType:"text"
		},false);	
	if(Status=="到达"){
		$.messager.alert("提示","已就诊患者不能转诊!");
		return false;
	}else if(Status=="报到"){
		$.messager.alert("提示","未报到患者不能转诊!");
		return false;
	}
    websys_showModal({
		url:"opdoc.transfer.hui.csp?EpisodeID=" + EpisodeID,
		title:$g('转诊'),
		width:530,height:270,
		LoadOutPatientDataGrid:LoadOutPatientDataGrid
    });
}
//取消接诊
function CancelAdmiss(){
	var row=OutPatientDataGrid.datagrid('getSelected');
	if (!row || row.length<=0) {
		 $.messager.alert("提示",t['SelectOnePatient']);
		 return false;
	}
	var EpisodeID=row.EpisodeID;
	if(!EpisodeID)return false;
	$.cm({ 
		ClassName:"web.DHCDocOutPatientList",
		MethodName:"CancelAdmiss", 
		Adm:EpisodeID,
		DocDr:ServerObj.DocDr,
		dataType:"text"
	},function(stat){
		if (stat!='0'){
			var message=""
			if (stat=="NoToday"){message="只能取消当日就诊的接诊!"}
			else if (stat=="AddMark"){message="加号患者不能取消接诊!"}
			else if (stat=="diagnos"){message="患者已经录入诊断或者存在有效的医嘱不可取消接诊!"}
			else if (stat=="NoAdmiss"){message="未接诊的就诊不能取消!"}
			else if (stat=="NoSelf"){message="只能取消本人接诊的就诊记录!"}
			else if (stat=="InsertFail"){message="队列表记录更新失败."}
			else if (stat=="UpdateAdmDocFail"){message="更新就诊科室与医生失败!"}
			else if (stat=="NoInitData"){message="未得到接诊状态改变记录!"}
			else {message="取消接诊失败,"+stat}
			$.messager.alert("提示",message);
			return false;
		}else{
			$.messager.popover({msg: '取消接诊成功!',type:'success',timeout: 1000});
			LoadOutPatientDataGrid();
		}
	});
}
function callOnePatient(EpisodeID){
	var IPAddress = GetComputerIp();
   if (IPAddress) {
		$("#datagrid-row-r1-2-0").removeClass("row-oplist-recalled row-oplist-skip").addClass("row-oplist-called");
		patientMap["call"][EpisodeID]="row-oplist-called";
	}else{
		IPAddress="";
	}
	var MarkID=$("#MarkDocList").combobox('getValue');
	if (!MarkID) MarkID="";
	var ret=tkMakeServerCall("web.DHCVISQueueManage","FrontQueueInsert",EpisodeID,session['LOGON.CTLOCID'],session['LOGON.USERID'],IPAddress,MarkID);
	CalledAfter(ret);
}
function Find_click(){
   findPatientTree();
}
function CalledAfter(ret){
	if (ret!=""){
		var alertCode=ret.split("^")[0];
		var alertMsg=ret.split("^")[1];
		if (alertCode==0){
			$.messager.popover({msg: alertMsg,type:'success',timeout: 3000});
			findPatientTree();
			return true;
		}else{
			$.messager.alert("提示", alertMsg);
			$("#datagrid-row-r1-2-0").removeClass("row-oplist-called row-oplist-skip");
		}
	}
}
function PatArrive(){
	if ($("#PatArrive").hasClass('disabled')){
		return false;
	}
	var row=OutPatientDataGrid.datagrid('getSelected');
	if (!row || row.length<=0) {
		 $.messager.alert("提示",t['SelectOnePatient']);
		 return false;
	}
	var QueRowId=row.QueRowId;
	$.cm({
		ClassName:"web.DHCAlloc", 
		MethodName:"PatArrive",
		dataType:"text",
		itmjs:"PatArriveToHUI", itmjsex:"", QueID:QueRowId,UserID:session['LOGON.USERID']
	},function(rtn){
		if (rtn!=0){
			$.messager.alert("提示","报到失败!"+rtn);
			return false;
		}
		LoadOutPatientDataGrid("");
	})
}
