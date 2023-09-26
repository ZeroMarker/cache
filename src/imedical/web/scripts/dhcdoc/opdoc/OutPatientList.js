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
	//�ǽ������򿪵Ļ����б���ʾ��ť��
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
	//��ʼ���ű�������
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
		/*{field:'LocSeqNo',title:'���',align:'center',width:50},
		{field:'PAPMINO',title:'�ǼǺ�',align:'center',width:120},
		{field:'PAPMIName',title:'����',align:'center',width:70,
			formatter: function(value,row,index){
				var btn = '<a class="editcls" onclick="ShowPatInfo(\'' + row.EpisodeID + '\')">'+value+'</a>';
				return btn;
			}
		},*/
		{field:'PAPMISex',title:'�Ա�',width:50},
		{field:'PAPMIDOB',title:'��������',width:100},
		{field:'Age',title:'����',width:40},
		{field:'WalkStatus',title:'״̬',width:70,
			styler: function(value,row,index){
				var WalkStatus=row['StatusCode'];
				if (WalkStatus=='03'){
					return 'background-color: #ff7373  !important;color:#fff !important;';
				}
			}
		},
		{field:'Diagnosis',title:'���',width:200},
		{field:'RegDoctor',title:'�ű�',width:150},
		{field:'PAAdmDocCodeDR',title:'ҽ��',width:100},
		{field:'PAAdmDepCodeDR',title:'����',width:100},
		{field:'PAAdmReason',title:'�ѱ�',width:70},
		{field:'PAAdmDate',title:'��������',width:90},
		{field:'PAAdmTime',title:'����ʱ��',width:90},
		{field:'ArrivedDate',title:'��������',width:90},
		{field:'ArrivedTime',title:'����ʱ��',width:90},
		{field:'Called',title:'����״̬',align:'center',width:50,hidden:true},
		{field:'DrugsStatus',title:'ҩƷ',align:'center',width:70,
			formatter: function(value,row,index){
				return renderWorkStatusCols(value,row,"Drug");
			}
		},
		{field:'InspectStatus',title:'���',align:'center',width:70,
			formatter: function(value,row,index){
				return renderWorkStatusCols(value,row,"Exam");
			}
		},
		{field:'LaboratoryStatus',title:'����',align:'center',width:70,
			formatter: function(value,row,index){
				return renderWorkStatusCols(value,row,"Lab");
			}
		},
		{field:'TreatmentStatus',title:'����',align:'center',width:70,
			formatter: function(value,row,index){
				return renderWorkStatusCols(value,row,"Treat");
			}
		},
		/*{field:'EpisodeID',title:'ת��',align:'center',width:70,
			formatter: function(value,row,index){
				return '<a><img style="cursor:pointer" src="../images/websys/update.gif" border="0" onclick="PatTransfer('+value+')"></a>';
			}
		},
		{field:'CancleEpisodeID',title:'ȡ������',align:'center',width:70,
			formatter: function(value,row,index){
				return '<a><img style="cursor:pointer" src="../images/websys/delete.gif" border="0" onclick="CancelAdmiss('+row.EpisodeID+')"></a>';
			}
		},*/
		{field:'PAAdmPriority',title:'���ȼ�',width:90},
		{field:'ConsultRoom',title:'����',width:90},
		{field:'ConsultArea',title:'����',width:90},
		{field:'TSecretLevel',title:'�ܼ�',width:90},
		{field:'TPoliticalLevel',title:'����',width:90},
		{field:'RegRangeTime',title:'ʱ��',width:90},
		{field:'RegAdmSource',title:'��Դ',width:90}
		
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
			{field:'LocSeqNo',title:'���',align:'center',width:50},
			{field:'PAPMINO',title:'�ǼǺ�',align:'center',width:120,
				formatter: function(value,row,index){
					var btn = '<a class="editcls" onclick="ShowPatInfo(\'' + row.EpisodeID + '\')">'+value+'</a>';
					return btn;
				}
			},
			{field:'PAPMIName',title:'����',align:'center',width:70,
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
	//tanjishan 2020.05.20Ϊ��ֹ��һλ���ߵĵ��Ӳ�����δ������ϣ����л�֮ǰ���ж�����һλ�����Ƿ��ڵ��Ӳ�������д������
	///  �л�����ǰ���ж��ǲ��������л���
	var frm = dhcsys_getmenuform();
	if (frm){
	    if (frm.DoingSth.value!="") {
	        $.messager.alert("��ʾ",frm.DoingSth.value+"���Ժ�����");
	        return false; //�����л�����
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
		parent.$("#WaitPatNum").html("�����ﻼ�ߣ�"+data['RegQue']+"��");
	}); 
}
function ShowPatInfo(EpisodeID){
	$.ajax("opdoc.patientbasicinfo.csp", {
		"type" : "GET",
		"dataType" : "html",
		"success" : function(data, textStatus) {
			var $code = $(data);
			createModalDialog("PatInfoDiag","���߻�����Ϣ", 600, 207,"icon-w-card","",$code,"");
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
		//����ͼƬbase64Ӧ��
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
   $("body").remove("#"+id); //�Ƴ����ڵ�Dialog
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
		case "0": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").focus().val(CardNo);
			$("#RegNo").val(PatientNo);
			LoadOutPatientDataGrid();
			event.keyCode=13;			
			break;
		case "-200": //����Ч
			$.messager.alert("��ʾ","����Ч!","info",function(){$("#CardNo").focus();});
			break;
		case "-201": //����Ч���ʻ�
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
		ic="icon-ok status-finish"; //��ɣ����˲��������  icon-ok
	}else if(statusCode=="S2"){
		ic="icon-funnel-half status-s2"; //������ɣ���������û�г������ icon-funnel-half
	}else if(statusCode=="S1"){
		ic="icon-funnel-empty hisui-linkbutton"; //δ��ɣ�ҽ�����˵�����û������ icon-funnel-empty
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
		if (targetType=="Drug"){var title=$g("ҩƷ");}
		if (targetType=="Exam"){var title=$g("���");}
		if (targetType=="Lab"){var title=$g("����");}
		if (targetType=="Treat"){var title=$g("����");}
		$(that).webuiPopover({
			width:400,
			content:function(){
				html.push('<div class="panel panel-default" style="border:none;">')
				html.push('</div><div class="panel-body" style="padding:0px;background-color:#4C4C4C;border:none;max-height:260px;">');
				for(var i in json){
					var des=json[i]["des"];
					if ((des.indexOf($g("ҩƷ"))>=0)&&(targetType!="Drug")) continue;
					if ((des.indexOf($g("���"))>=0)&&(targetType!="Exam")) continue;
					if ((des.indexOf($g("����"))>=0)&&(targetType!="Lab")) continue;
					if ((des.indexOf($g("����"))>=0)&&(targetType!="Treat")) continue;
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
		 $.messager.alert("��ʾ",t['SelectOnePatient']);
		 return false;
	}
	 if(!row.EpisodeID)return false;
	 if (row.Called==""){
		 $.messager.alert("��ʾ","û�к��еĻ��߲��ܹ���!");
		return false;
	 }
	 var selIndex=OutPatientDataGrid.datagrid('getRowIndex',row);
	 $("#datagrid-row-r1-2-0").removeClass("row-oplist-called row-oplist-recalled").addClass("row-oplist-skip");
	 var admDate=row.PAAdmDate;
	 if (!CheckAdmDate(admDate)) {
		$.messager.$.messager.alert("��ʾ",t['AdmDateOver']);
		return false;
	 }
	 if (row.PAAdmPriority=="����"){
		 $.messager.alert("��ʾ","���ȵĻ��߲��ܹ���!");
		return false;
	 }
	 $.messager.confirm('ȷ�϶Ի���', t['SkipNumberMsg'], function(r){
		if (r){
		    patientMap["recall"][row.EpisodeID]="row-oplist-recalled";
		    $.cm({ 
				ClassName:"web.DHCDocOutPatientList",
				MethodName:"SetSkipStatus", 
				Adm:row.EpisodeID,
				DocDr:ServerObj.DocDr
			},function(stat){
				if (stat!='1'){
					$.messager.alert("��ʾ",t['StatusFailure']);
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
			 $.messager.alert("��ʾ",t['SelectOnePatient']);
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
	//���ӱ���������
	var service = locator.ConnectServer(".");
	//��ѯʹ��SQL��׼ 
	var properties = service.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration");
	var e = new Enumerator (properties);
	var p = e.item ();
	for (;!e.atEnd();e.moveNext ())  {
		var p = e.item ();
		//IP��ַΪ��������,�������뼰Ĭ��������ͬ
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
	if ($(ele).hasClass('expanded')){  //�Ѿ�չ�� ����
		$(ele).removeClass('expanded');
		$("#BMore")[0].innerText=$g("����");
    	$("#more,#dashline").hide();
    	setHeight("-43");
	}else{
		$(ele).addClass('expanded');
		$("#BMore")[0].innerText=$g("����");
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
			 $.messager.alert("��ʾ",t['SelectOnePatient']);
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
				$.messager.alert("��ʾ",rtn.split("^")[1]);
				return false;
			}else{
				LoadOutPatientDataGrid();
			}
		});
	}
}
//ת��
function PatTransfer(){
	var row=OutPatientDataGrid.datagrid('getSelected');
	if (!row || row.length<=0) {
		 $.messager.alert("��ʾ",t['SelectOnePatient']);
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
	if(Status=="����"){
		$.messager.alert("��ʾ","�Ѿ��ﻼ�߲���ת��!");
		return false;
	}else if(Status=="����"){
		$.messager.alert("��ʾ","δ�������߲���ת��!");
		return false;
	}
    websys_showModal({
		url:"opdoc.transfer.hui.csp?EpisodeID=" + EpisodeID,
		title:$g('ת��'),
		width:530,height:270,
		LoadOutPatientDataGrid:LoadOutPatientDataGrid
    });
}
//ȡ������
function CancelAdmiss(){
	var row=OutPatientDataGrid.datagrid('getSelected');
	if (!row || row.length<=0) {
		 $.messager.alert("��ʾ",t['SelectOnePatient']);
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
			if (stat=="NoToday"){message="ֻ��ȡ�����վ���Ľ���!"}
			else if (stat=="AddMark"){message="�ӺŻ��߲���ȡ������!"}
			else if (stat=="diagnos"){message="�����Ѿ�¼����ϻ��ߴ�����Ч��ҽ������ȡ������!"}
			else if (stat=="NoAdmiss"){message="δ����ľ��ﲻ��ȡ��!"}
			else if (stat=="NoSelf"){message="ֻ��ȡ�����˽���ľ����¼!"}
			else if (stat=="InsertFail"){message="���б��¼����ʧ��."}
			else if (stat=="UpdateAdmDocFail"){message="���¾��������ҽ��ʧ��!"}
			else if (stat=="NoInitData"){message="δ�õ�����״̬�ı��¼!"}
			else {message="ȡ������ʧ��,"+stat}
			$.messager.alert("��ʾ",message);
			return false;
		}else{
			$.messager.popover({msg: 'ȡ������ɹ�!',type:'success',timeout: 1000});
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
			$.messager.alert("��ʾ", alertMsg);
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
		 $.messager.alert("��ʾ",t['SelectOnePatient']);
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
			$.messager.alert("��ʾ","����ʧ��!"+rtn);
			return false;
		}
		LoadOutPatientDataGrid("");
	})
}
