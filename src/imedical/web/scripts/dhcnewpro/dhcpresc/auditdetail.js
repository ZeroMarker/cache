var auditID = getParam("auditID");
var patientID = getParam("patientID");
var admID = getParam("admID");
var mradm = getParam("mradm");
var imgurl = "../scripts/dhcnewpro/dhcpresc/images/"; //图标路径
var color = ["#2AB66A","#FFB519","#FF5219","#000000"];	//颜色，提示、提醒、警示、禁止

function InitPageDefault(){
	
	initButton();
	InitAuditInfo();
	LoadPrescNo();
	initLisDatagrid();
	initInsDatagrid();
	InitHistory();
	LoadPrescPro(auditID)
			
}

//加载病人信息
function InitAuditInfo(){
	
	runClassMethod("web.DHCPRESCList","GetInfo",{"auditID":auditID},	
		function(jsonString){	
			var jsonObject = jsonString;
			InitPatientInfo(jsonObject);
			
		},'json')
}

//展现病人信息
function InitPatientInfo(jsonObject){
	
	$("#name")[0].innerHTML = jsonObject.patName;
	$("#sex")[0].innerHTML = jsonObject.patSex;
	$("#age")[0].innerHTML = jsonObject.patAge;
	var weight = jsonObject.weight;
	if(weight!=""){
		weight = weight+"kg";
	}
	$("#weight")[0].innerHTML = weight;
	$("#patNo")[0].innerHTML = jsonObject.patNo;
	$("#admNo")[0].innerHTML = jsonObject.admNo;
	$("#locDesc")[0].innerHTML = jsonObject.locDesc;
	$("#docDesc")[0].innerHTML = jsonObject.docDesc;
	$("#allergy")[0].innerHTML = jsonObject.allergy;
	$("#diagnosis")[0].innerHTML = jsonObject.diagnos;
	$("#admId")[0].innerHTML = jsonObject.admID;
	$("#patientId")[0].innerHTML = jsonObject.patientID;
	
	BindTips(jsonObject.diag)
}

/*查询日期*/
function initDateBox(){
	$HUI.datebox("#sel-stDate",{});
	$HUI.datebox("#sel-edDate",{});	
	$HUI.datebox("#sel-stDate").setValue(formatDate(0));
	$HUI.datebox("#sel-edDate").setValue(formatDate(0));
}

///加载处方信息
function LoadPrescNo()
{
	
	runClassMethod("web.DHCPRESCAudit","GetPrescNo",{"auditId":auditID},
		function(jsonString){
			var json= eval('(' + jsonString + ')');
			AppendPrescHtml(json);
	},'text');
}

///处理处方的html
function AppendPrescHtml(json)
{
	var $prescInfo = $("#prescInfo");
	$prescInfo.empty();
	
	var length = json.length;
	var prescNo = json[0].prescNo;
	
	$row = $("<div class='presc-pre'></div>");
	$row.append("<span class='icon-paper-pen-blue' >&nbsp;&nbsp;&nbsp;&nbsp;</span>");
	$row.append("<span class='presc-col' >处方</span>");
	$row.append("<span class='presc-no'>"+prescNo+"</span>");
	$prescInfo.append($row);
	
	for(var i=0;i<length;i++){
		var drugDesc = json[i].drugDesc;
		var drugCode = json[i].drugCode;
		var onceDose = json[i].onceDose;
		var preMet = json[i].preMet;
		var freq = json[i].freq;
		var treatment = json[i].treatment;
		var $cols = $("<div class='presc-drug'></div>");
		$prescInfo.append($cols);
		$cols.append("<span>"+(i+1)+"</span>");
		var spanHtml = "<span class='icon-drug'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span class='presc-text'>"+drugDesc+"</span><a  href='javascript:litratrue("+'"'+drugCode+'"'+',"'+drugDesc+'"'+")'  style='float:right;padding-right:20px;' value='"+drugDesc+"'";
		spanHtml = spanHtml + "data-code='"+drugCode+"' data-libId= '"+json[i].libDrugId+ "' data-libCode='"+json[i].libDrugCode+"' data-libDesc='"+json[i].libDrugDesc+ "'><img src='../scripts/dhcnewpro/dhcpresc/images/lit.png' style='height:18px'/></a><br>";
		
		$cols.append(spanHtml);
	
		
		var $usecols = $("<div class='presc-pre'></div>");
		$prescInfo.append($usecols);
		$usecols.append("<span class='presc-use'>单次剂量：</span>");
		$usecols.append("<span>"+ onceDose +"</span>");
		$usecols.append("<span class='presc-use'>给药途径：</span>");
		$usecols.append("<span>"+ preMet +"</span>");
		$usecols.append("<span class='presc-use'>频次：</span>");
		$usecols.append("<span>"+ freq +"</span>");
		$usecols.append("<span class='presc-use'>疗程：</span>");
		$usecols.append("<span>"+ treatment +"</span>");
		
		var $entrust = $("<div class='entrust'></div>");
		$prescInfo.append($entrust);
		var $contmore = $("<div class='contmore'></div>");
		$entrust.append($contmore);
		if(i<1){
			$contmore.append("<span></span>")

		}
		var $dashline = $('<div  id="dasline"></div>');
		if(i<length-1){
			$prescInfo.append($dashline);
		}
	}
}

/*检验报告*/
function initLisDatagrid()
{
	///  定义columns
	var columns=[[
          { field: 'chkReportList', checkbox: true },
          { field: 'LabEpisode', title: '检验号', width: 105, sortable: false, align: 'left' },
          { field: 'OrdItemName', title: '医嘱名称', width: 200, sortable: false, align: 'left' },
          { field: 'AuthDateTime', title: '报告日期', width: 150, sortable: false, align: 'left' },
          { field: 'PatName', title: '姓名', width: 80, sortable: false, align: 'left' },
          { field: 'Order', title: '预报告', width: 55, sortable: true, align: 'left'},
          { field: 'ResultStatus', title: '结果状态', width:100, sortable: false, hidden:true,align: 'left'},
		  { field: 'PrintFlag', title: '打印', width: 40, sortable: false, hidden:true,align: 'left',
          	formatter: function (value, rowData, rowIndex) {
				if (rowData.ResultStatus != "3") return "";
				if(value=="Y"){
					return '<a href="#" title="打印记录"  onclick="ShowPrintHistory(\''+rowData.VisitNumberReportDR+'\')"><span class="icon-ok" title="已打印">&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>';
				}else if(value=="N"){
					return '<a href="#" title="打印记录"  onclick="ShowPrintHistory(\''+rowData.VisitNumberReportDR+'\')"><span class="icon-undo" title="本人未打印">&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>';
				}
             }
          },
          { field: 'ReadFlag', title: '阅读', width: 40, sortable: false, align: 'center',
          	formatter: function(value, rowData, rowIndex){
	          	if (rowData.ResultStatus != "3") return "";
	        	if (value == "1") {
		        	return "<span class='icon-book_open' color='red' title='已阅读')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>";
	        	}else {
		        	return "<span class='icon-book_go' color='red' title='未阅读')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>";
	        	}  	
	        } 
          },
          { field: 'WarnComm', title: '危急提示', width: 150, sortable: false, align: 'left'},
          { field: 'ReceiveNotes', title: '标本备注', width: 150, sortable: false, align: 'left' },
          { field: 'MajorConclusion', title: '报告评价', width: 150, sortable: false, align: 'left' },
          { field: 'ReqDateTime', title: '申请日期', width: 150, sortable: false, align: 'left' },
          { field: 'SpecDateTime', title: '采集日期', width: 150, sortable: false, align: 'left' },
          { field: 'RecDateTime', title: '接收日期', width: 150, sortable: false, align: 'left' },
          { field: 'VisitNumberReportDR', title: '报告ID', width: 100, sortable: false, align: 'left' },
        ]]
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		rownumbers : false,
		singleSelect : true,
        onClickRow:function(rowIndex, rowData){
	        
			reloadOrdDetailTable(rowData.VisitNumberReportDR);
	    },
		onLoadSuccess:function(data){
			
		}
	};
	
	var params = admID +"^"+ patientID +"^"+ "" +"^"+ "" + "^^0^^^"+""+"^0^^^^Y"+"^"+""+"^"+""+"^"+""+"^"+"";
	var uniturl = $URL +"?ClassName=web.DHCPRESCQuery&MethodName=GetLisHisList&params="+params;
	
	new ListComponent('lisOrdTable', columns, uniturl, option).Init();
	
	var columns=[[
    	{ field: 'Synonym',align: 'left', title: '缩写',width:100},
        { field: 'TestCodeName',align: 'left', title: '项目名称',width:120},
        { field: 'Result',align: 'left', title: '结果',width:120},
		{ field: 'ExtraRes',align: 'left', title: '结果提示',width:100},
		{ field: 'AbFlag',align: 'left', title: '异常提示',width:80},
		{ field: 'HelpDisInfo',align: 'left', title: '辅助诊断',width:80},
		{ field: 'Units',align: 'left', title: '单位',width:80},
		{ field: 'RefRanges',align: 'left', title: '参考范围',width:120},
		{ field: 'PreResult',align: 'left', title: '历次',width:120}, 
		{ field: 'PreAbFlag', align: 'left',title: '前次异常提示',hidden: true}
 	]];
 	
 	///  定义datagrid
	var option = {
		//showHeader:false,
		rownumbers : false,
		singleSelect : true,
        onClickRow:function(rowIndex, rowData){
	    },
		onLoadSuccess:function(data){
			
		}
	};
	
	var uniturl = $URL +"?ClassName=web.DHCPRESCQuery&MethodName=GetLisDetList&reportId=";
	new ListComponent('lisOrdDetailTable', columns, uniturl, option).Init();
}

///初始化检查列表
function initInsDatagrid()
{
	var Params=""
	var stDate = "";
	var edDate = "";
	Params= admID +"^"+ patientID +"^"+ stDate +"^"+ edDate +"^"+ LgUserID+"^"+""+"^"+""+"^"+""+"^"+"";  //##
	ReqNo = "",OEORIID="";
	var columns=[[
		{ field: 'lx',align: 'center', title: '类型',formatter:formatterlx},
    	{ field: 'AdmLoc',align: 'center', title: '就诊科室'},
    	{ field: 'ReqNo',align: 'center', title: '申请单号'},
    	{ field: 'StudyNo',align: 'center', title: '检查号'},
    	{ field: 'strOrderName',align: 'center', title: '检查名称'},
    	{ field: 'strOrderDate',align: 'center', title: '申请日期'},
    	{ field: 'ItemStatus',align: 'center', title: '检查状态'},
    	{ field: 'recLocName',align: 'center', title: '检查科室'},
    	{ field: 'IsCVR',align: 'center', title: '危急值报告'},
    	{ field: 'IsIll',align: 'center', title: '是否阳性',
    		formatter:function(value,row,index){ //hxy 2018-10-30
				if (value=='Y'){return '是';} 
				else {return '否';}
			}}, 
    	{ field: 'IshasImg',align: 'center', title: '是否有图像',
    		formatter:function(value,row,index){ //hxy 2018-10-30
				if (value=='Y'){return '是';} 
				else {return '否';}
    		}
    	},
    	{ field: 'Grade',align: 'center', title: '评级',hidden:true},
    	{ field: 'OEORIId',align: 'center', title: '医嘱ID'},
    	{ field: 'PortUrl',align: 'center', title: 'PortUrl',hidden:'true'}
 
 	]]; 

 	$HUI.datagrid('#inspectDetail',{
		url:$URL+"?ClassName=web.DHCPRESCQuery&MethodName=GetInspectOrd&Params="+Params,
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:false,
		pageSize:10,  
		pageList:[10,15,20], 
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
		border:false,//hxy 2018-10-22
		rowStyler: function(index,row){
			
		},
		onLoadSuccess:function(data){
			if((data.rows.length=="1")&&(ReqNo!="")){
				
			}
		}
	});	
	
}

///加载检验列表
function reaLoadLis()
{
	var params = EpisodeID +"^"+ PatientID+"^"+ "" +"^"+ "";
	params = params + "^^0^^^"+""+"^0^^^^Y"+"^"+""+"^"+""+"^"+""+"^"+"";  //##
	$HUI.datagrid('#lisOrdTable').load({
		params:params
	})

}

function formatterlx(value,rowData){
	if(rowData.BLOrJC==0){
		return "检查";
	}
	
	if(rowData.BLOrJC==1){
		return "病理";
	}
}

//获取审核历史记录
function InitHistory(){

	runClassMethod("web.DHCPRESCList","GetHistory",{"auditID":auditID},
		function(jsonString){
				
			var array = jsonString;
			
			for (var i = 0; i < array.length; i++){
				if(i==0){
					var reasonDoc = array[i].reasonDoc;
					var resCom = array[i].resCom;
					var docnote = reasonDoc;
					if(resCom != ""){
						docnote = docnote +","+resCom;
					}
					var htmlStr = "";
					var htmlStr = "<div class=\"history-item\">"
					htmlStr += "<div>开方医生:"+array[i].createrUser+"</div>"
					htmlStr += "<div>开方日期:"+array[i].createrDate+"</div>"
					htmlStr += "<div>开方时间:"+array[i].createrTime+"</div>"
					htmlStr += "<div>医生建议:"+array[i].audNote+"</div>"
					htmlStr += "<div>医生备注:"+docnote+"</div>"
					htmlStr += "</div>"
					
					
				}
				if(i==1){
					var htmlStr = "";
					htmlStr += "<div class=\"history-item\">"
					htmlStr += "<div>审核药师:"+array[i].pharDesc+"</div>"
					htmlStr += "<div>审核日期:"+array[i].auditDate+"</div>"
					htmlStr += "<div>审核时间:"+array[i].auditTime+"</div>"
					htmlStr += "<div>审核结果:"+array[i].status+"</div>"
					htmlStr += "<div>药师备注:"+array[i].remark+"</div>"
					htmlStr += "</div>"
				}
				if(i==2){
					var htmlStr = "";
					var htmlStr = "<div class=\"history-item\">"
					htmlStr += "<div>开方医生:"+array[i].pharDesc+"</div>"
					htmlStr += "<div>申诉日期:"+array[i].auditDate+"</div>"
					htmlStr += "<div>申诉时间:"+array[i].auditTime+"</div>"
					htmlStr += "<div>医生申诉:"+array[i].remark+"</div>"
					htmlStr += "</div>"
				}
				
				$("#info-items").append(htmlStr);
			}
		},
		
	'json')	
}

///加载审查问题
function LoadPrescPro(auditID){
	
	runClassMethod("web.DHCPRESCAudit","GetAuditInfo",{"auditId":auditID},
		function(jsonString){
			var json= eval('(' + jsonString + ')');
			AppendProbHtml(json);
	},'text');
}

///处理问题html
function AppendProbHtml(retJson)
{
	var $probInfo = $("#proInfo");
	$probInfo.empty();
	if ($.isEmptyObject(retJson)){
		return;	
	}
	var itemsArr = retJson.items;
	var arr = [];
	var keyArr = [];
	var manLevArr = [];
	//抽取json内容，获取一组对象
	for (var i = 0; i < itemsArr.length; i++){
		var warnsArr = itemsArr[i].warns;
		for (var j = 0; j < warnsArr.length; j++){
			var msgItmsArr = warnsArr[j].itms;
			for (var k = 0; k < msgItmsArr.length; k++){
				var valItemArr = msgItmsArr[k].itms;
				for (var x = 0; x < valItemArr.length; x++){
					var obj = {};
					/*if (warnsArr[j].manLev == "提醒" || warnsArr[j].manLev == "提示"){
						continue;	
					}else{*/
						obj.item = itemsArr[i].item;
						obj.manLev = warnsArr[j].manLev;
						obj.keyname = warnsArr[j].keyname;
						obj.val = valItemArr[x].val;
						arr.push(obj);
				/* 	} */
				}
			}
		}		
	}
	
	//按照提示等级和种类分类，去重
	for (var n = 0; n < arr.length; n++){
		keyArr.push(arr[n].keyname);
		keyArr = unique(keyArr);
	}
	for (var m = 0; m < keyArr.length; m++){
		//创建卡片
		var $keyCard = $("<div style=\"background-color:#FFFCF7;margin:20px 10px 10px 10px;height:auto;border:1px dashed #ccc;padding:10px;position:relative\"></div>");
		$probInfo.append($keyCard);	
		var manLevArr = [];
		for (var p = 0; p < arr.length; p++){
			if (arr[p].keyname == keyArr[m]){
				manLevArr.push(arr[p].manLev);	
			}	
		}
		manLevArr = unique(manLevArr);
		for (var o = 0; o < manLevArr.length; o++){
			/* if (manLevArr[o] == "提醒"||manLevArr[o] == "提示"){
				continue;	
			} 
			if(manLevArr[o] == "禁止") {
				manLevArr[o] = "警示"
			}*/
			//三目运算符处理图标和边框颜色
			var manLevIcon = (manLevArr[o] == "提示") ? "tips.png" : (manLevArr[o] == "提醒" ? "remind.png" :(manLevArr[o] == "警示" ? "warn.png" : (manLevArr[o] == "禁止" ? "forbid.png" : "")))
			var manLevcolor = (manLevArr[o] == "提示") ? color[0] : (manLevArr[o] == "提醒" ? color[1] :(manLevArr[o] == "警示" ? color[2] : (manLevArr[o] == "禁止" ? color[3] : "")))
			var $manLev = $("<div><img style=\"height:30px;position:absolute;left:-5px;top:-15px\" src = \""+ imgurl +""+manLevIcon+"\"/></div>");
			var $infoCard = $("<div style=\"margin-top:-20px;padding:5px;width:70%;\"></div>");
			$keyCard.append($manLev);
			$keyCard.append("<div style=\"width:25%;text-align:right;float:right;margin-top:15px;margin-right:30px;color:"+ manLevcolor +"\"><b>"+keyArr[m]+"</b></div>");
			$keyCard.append("<div style='clear:both;width:0px'></div>");	//空白容器撑开盒子
			for (var r = 0; r < arr.length; r++){
				
					$infoCard.append("<span class='icon-drug'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>")
					$infoCard.append(arr[r].item+"<br/>");
					$infoCard.append("<div style=\"color:#676360;font-size:12px;margin-left:25px;\">"+arr[r].val+"<br/></div>");	
			}
			$keyCard.append($infoCard);
		}
	}
}

/// 数组去重方法
function unique(arr) {
    if (!Array.isArray(arr)) {
        console.log('type error!')
        return
    }
    var array = [];
    for (var i = 0; i < arr.length; i++) {
        if (array .indexOf(arr[i]) === -1) {
            array .push(arr[i])
        }
    }
    return array;
}

///调用说明书
function litratrue(drugCode,drugDesc)
{
	
	var link = "dhcckb.pdss.instruction.csp?IncId=&IncCode="+drugCode+"&IncDesc="+drugDesc  //encodeURI
	if ('undefined'!==typeof websys_getMWToken){
		link += "&MWToken="+websys_getMWToken();
	}
	window.open(link, "", "status=1,scrollbars=1,top=50,left=100,width=1350,height=720");
	
}

function initButton()
{
	$("#patNo").bind('click',panoview);			//跳转全景视图
	
	$("#presc-keywords").tabs({
		onSelect:function(title){
		   if (title == "检验信息"){
				initLisDatagrid();
		   }else if(title == "检查信息"){
			   initInsDatagrid();
		   }
		}
	});
}

///跳转到全景视图
function panoview()
{
	
	if($('#winlode').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="winlode"></div>');
	$('#winlode').window({
		title:'病历浏览列表',
		collapsible:true,
		border:false,
		closed:"true",
		width:document.body.offsetWidth-100,
		height:document.body.offsetHeight-100
	});
	
	
	if ('undefined'!==typeof websys_getMWToken){
		var link="websys.chartbook.hisui.csp?";
		link += "MWToken="+websys_getMWToken();
		link += "&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=&SwitchSysPat=N&ChartBookID=70&PatientID="+ patientID +"&EpisodeID="+ admID +"&mradm="+ mradm +"&WardID=";

	}else{
		var link="websys.chartbook.hisui.csp?";
		link += "PatientListPanel=emr.browse.episodelist.csp&PatientListPage=&SwitchSysPat=N&ChartBookID=70&PatientID="+ patientID +"&EpisodeID="+ admID +"&mradm="+ mradm +"&WardID=";

	}
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+link+'"></iframe>';
	$('#winlode').html(iframe);
	$('#winlode').window('open'); 
}

function BindTips(diag)
{
	var html='<div id="tip" style="border-radius:3px;display:none;border:1px solid #000;padding:10px;position:absolute;background-color:#000;color:#fff;"></div>'
	$('body').append(html);
	/// 鼠标离开
	$('#diagnosis').on({
		'mouseleave':function(){
			$("#tip").css({display : 'none'});
		}
	})
	/// 鼠标移动
	$('#diagnosis').on({
		'mousemove':function(){
			var tleft=(event.clientX + 20);
			/// tip 提示框位置和内容设定
			$("#tip").css({
				display : 'block',
				top : (event.clientY + 10) + 'px',   
				left : tleft + 'px',
				'z-index' : 9999,
				opacity: 0.6
			}).text(diag);    // .text()
		}
	})
}

function reloadOrdDetailTable(portId){
	
	$HUI.datagrid('#lisOrdDetailTable').load({
		reportId:portId
	})
}
$(function(){ InitPageDefault(); });

