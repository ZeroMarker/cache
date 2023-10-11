var auditID = getParam("auditID");
var patientID = getParam("patientID");
var admID = getParam("admID");
var mradm = getParam("mradm");
var imgurl = "../scripts/dhcnewpro/dhcpresc/images/"; //ͼ��·��
var color = ["#2AB66A","#FFB519","#FF5219","#000000"];	//��ɫ����ʾ�����ѡ���ʾ����ֹ

function InitPageDefault(){
	
	initButton();
	InitAuditInfo();
	LoadPrescNo();
	initLisDatagrid();
	initInsDatagrid();
	InitHistory();
	LoadPrescPro(auditID)
			
}

//���ز�����Ϣ
function InitAuditInfo(){
	
	runClassMethod("web.DHCPRESCList","GetInfo",{"auditID":auditID},	
		function(jsonString){	
			var jsonObject = jsonString;
			InitPatientInfo(jsonObject);
			
		},'json')
}

//չ�ֲ�����Ϣ
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

/*��ѯ����*/
function initDateBox(){
	$HUI.datebox("#sel-stDate",{});
	$HUI.datebox("#sel-edDate",{});	
	$HUI.datebox("#sel-stDate").setValue(formatDate(0));
	$HUI.datebox("#sel-edDate").setValue(formatDate(0));
}

///���ش�����Ϣ
function LoadPrescNo()
{
	
	runClassMethod("web.DHCPRESCAudit","GetPrescNo",{"auditId":auditID},
		function(jsonString){
			var json= eval('(' + jsonString + ')');
			AppendPrescHtml(json);
	},'text');
}

///��������html
function AppendPrescHtml(json)
{
	var $prescInfo = $("#prescInfo");
	$prescInfo.empty();
	
	var length = json.length;
	var prescNo = json[0].prescNo;
	
	$row = $("<div class='presc-pre'></div>");
	$row.append("<span class='icon-paper-pen-blue' >&nbsp;&nbsp;&nbsp;&nbsp;</span>");
	$row.append("<span class='presc-col' >����</span>");
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
		$usecols.append("<span class='presc-use'>���μ�����</span>");
		$usecols.append("<span>"+ onceDose +"</span>");
		$usecols.append("<span class='presc-use'>��ҩ;����</span>");
		$usecols.append("<span>"+ preMet +"</span>");
		$usecols.append("<span class='presc-use'>Ƶ�Σ�</span>");
		$usecols.append("<span>"+ freq +"</span>");
		$usecols.append("<span class='presc-use'>�Ƴ̣�</span>");
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

/*���鱨��*/
function initLisDatagrid()
{
	///  ����columns
	var columns=[[
          { field: 'chkReportList', checkbox: true },
          { field: 'LabEpisode', title: '�����', width: 105, sortable: false, align: 'left' },
          { field: 'OrdItemName', title: 'ҽ������', width: 200, sortable: false, align: 'left' },
          { field: 'AuthDateTime', title: '��������', width: 150, sortable: false, align: 'left' },
          { field: 'PatName', title: '����', width: 80, sortable: false, align: 'left' },
          { field: 'Order', title: 'Ԥ����', width: 55, sortable: true, align: 'left'},
          { field: 'ResultStatus', title: '���״̬', width:100, sortable: false, hidden:true,align: 'left'},
		  { field: 'PrintFlag', title: '��ӡ', width: 40, sortable: false, hidden:true,align: 'left',
          	formatter: function (value, rowData, rowIndex) {
				if (rowData.ResultStatus != "3") return "";
				if(value=="Y"){
					return '<a href="#" title="��ӡ��¼"  onclick="ShowPrintHistory(\''+rowData.VisitNumberReportDR+'\')"><span class="icon-ok" title="�Ѵ�ӡ">&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>';
				}else if(value=="N"){
					return '<a href="#" title="��ӡ��¼"  onclick="ShowPrintHistory(\''+rowData.VisitNumberReportDR+'\')"><span class="icon-undo" title="����δ��ӡ">&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>';
				}
             }
          },
          { field: 'ReadFlag', title: '�Ķ�', width: 40, sortable: false, align: 'center',
          	formatter: function(value, rowData, rowIndex){
	          	if (rowData.ResultStatus != "3") return "";
	        	if (value == "1") {
		        	return "<span class='icon-book_open' color='red' title='���Ķ�')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>";
	        	}else {
		        	return "<span class='icon-book_go' color='red' title='δ�Ķ�')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>";
	        	}  	
	        } 
          },
          { field: 'WarnComm', title: 'Σ����ʾ', width: 150, sortable: false, align: 'left'},
          { field: 'ReceiveNotes', title: '�걾��ע', width: 150, sortable: false, align: 'left' },
          { field: 'MajorConclusion', title: '��������', width: 150, sortable: false, align: 'left' },
          { field: 'ReqDateTime', title: '��������', width: 150, sortable: false, align: 'left' },
          { field: 'SpecDateTime', title: '�ɼ�����', width: 150, sortable: false, align: 'left' },
          { field: 'RecDateTime', title: '��������', width: 150, sortable: false, align: 'left' },
          { field: 'VisitNumberReportDR', title: '����ID', width: 100, sortable: false, align: 'left' },
        ]]
	
	///  ����datagrid
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
    	{ field: 'Synonym',align: 'left', title: '��д',width:100},
        { field: 'TestCodeName',align: 'left', title: '��Ŀ����',width:120},
        { field: 'Result',align: 'left', title: '���',width:120},
		{ field: 'ExtraRes',align: 'left', title: '�����ʾ',width:100},
		{ field: 'AbFlag',align: 'left', title: '�쳣��ʾ',width:80},
		{ field: 'HelpDisInfo',align: 'left', title: '�������',width:80},
		{ field: 'Units',align: 'left', title: '��λ',width:80},
		{ field: 'RefRanges',align: 'left', title: '�ο���Χ',width:120},
		{ field: 'PreResult',align: 'left', title: '����',width:120}, 
		{ field: 'PreAbFlag', align: 'left',title: 'ǰ���쳣��ʾ',hidden: true}
 	]];
 	
 	///  ����datagrid
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

///��ʼ������б�
function initInsDatagrid()
{
	var Params=""
	var stDate = "";
	var edDate = "";
	Params= admID +"^"+ patientID +"^"+ stDate +"^"+ edDate +"^"+ LgUserID+"^"+""+"^"+""+"^"+""+"^"+"";  //##
	ReqNo = "",OEORIID="";
	var columns=[[
		{ field: 'lx',align: 'center', title: '����',formatter:formatterlx},
    	{ field: 'AdmLoc',align: 'center', title: '�������'},
    	{ field: 'ReqNo',align: 'center', title: '���뵥��'},
    	{ field: 'StudyNo',align: 'center', title: '����'},
    	{ field: 'strOrderName',align: 'center', title: '�������'},
    	{ field: 'strOrderDate',align: 'center', title: '��������'},
    	{ field: 'ItemStatus',align: 'center', title: '���״̬'},
    	{ field: 'recLocName',align: 'center', title: '������'},
    	{ field: 'IsCVR',align: 'center', title: 'Σ��ֵ����'},
    	{ field: 'IsIll',align: 'center', title: '�Ƿ�����',
    		formatter:function(value,row,index){ //hxy 2018-10-30
				if (value=='Y'){return '��';} 
				else {return '��';}
			}}, 
    	{ field: 'IshasImg',align: 'center', title: '�Ƿ���ͼ��',
    		formatter:function(value,row,index){ //hxy 2018-10-30
				if (value=='Y'){return '��';} 
				else {return '��';}
    		}
    	},
    	{ field: 'Grade',align: 'center', title: '����',hidden:true},
    	{ field: 'OEORIId',align: 'center', title: 'ҽ��ID'},
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
		loadMsg: '���ڼ�����Ϣ...',
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

///���ؼ����б�
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
		return "���";
	}
	
	if(rowData.BLOrJC==1){
		return "����";
	}
}

//��ȡ�����ʷ��¼
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
					htmlStr += "<div>����ҽ��:"+array[i].createrUser+"</div>"
					htmlStr += "<div>��������:"+array[i].createrDate+"</div>"
					htmlStr += "<div>����ʱ��:"+array[i].createrTime+"</div>"
					htmlStr += "<div>ҽ������:"+array[i].audNote+"</div>"
					htmlStr += "<div>ҽ����ע:"+docnote+"</div>"
					htmlStr += "</div>"
					
					
				}
				if(i==1){
					var htmlStr = "";
					htmlStr += "<div class=\"history-item\">"
					htmlStr += "<div>���ҩʦ:"+array[i].pharDesc+"</div>"
					htmlStr += "<div>�������:"+array[i].auditDate+"</div>"
					htmlStr += "<div>���ʱ��:"+array[i].auditTime+"</div>"
					htmlStr += "<div>��˽��:"+array[i].status+"</div>"
					htmlStr += "<div>ҩʦ��ע:"+array[i].remark+"</div>"
					htmlStr += "</div>"
				}
				if(i==2){
					var htmlStr = "";
					var htmlStr = "<div class=\"history-item\">"
					htmlStr += "<div>����ҽ��:"+array[i].pharDesc+"</div>"
					htmlStr += "<div>��������:"+array[i].auditDate+"</div>"
					htmlStr += "<div>����ʱ��:"+array[i].auditTime+"</div>"
					htmlStr += "<div>ҽ������:"+array[i].remark+"</div>"
					htmlStr += "</div>"
				}
				
				$("#info-items").append(htmlStr);
			}
		},
		
	'json')	
}

///�����������
function LoadPrescPro(auditID){
	
	runClassMethod("web.DHCPRESCAudit","GetAuditInfo",{"auditId":auditID},
		function(jsonString){
			var json= eval('(' + jsonString + ')');
			AppendProbHtml(json);
	},'text');
}

///��������html
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
	//��ȡjson���ݣ���ȡһ�����
	for (var i = 0; i < itemsArr.length; i++){
		var warnsArr = itemsArr[i].warns;
		for (var j = 0; j < warnsArr.length; j++){
			var msgItmsArr = warnsArr[j].itms;
			for (var k = 0; k < msgItmsArr.length; k++){
				var valItemArr = msgItmsArr[k].itms;
				for (var x = 0; x < valItemArr.length; x++){
					var obj = {};
					/*if (warnsArr[j].manLev == "����" || warnsArr[j].manLev == "��ʾ"){
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
	
	//������ʾ�ȼ���������࣬ȥ��
	for (var n = 0; n < arr.length; n++){
		keyArr.push(arr[n].keyname);
		keyArr = unique(keyArr);
	}
	for (var m = 0; m < keyArr.length; m++){
		//������Ƭ
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
			/* if (manLevArr[o] == "����"||manLevArr[o] == "��ʾ"){
				continue;	
			} 
			if(manLevArr[o] == "��ֹ") {
				manLevArr[o] = "��ʾ"
			}*/
			//��Ŀ���������ͼ��ͱ߿���ɫ
			var manLevIcon = (manLevArr[o] == "��ʾ") ? "tips.png" : (manLevArr[o] == "����" ? "remind.png" :(manLevArr[o] == "��ʾ" ? "warn.png" : (manLevArr[o] == "��ֹ" ? "forbid.png" : "")))
			var manLevcolor = (manLevArr[o] == "��ʾ") ? color[0] : (manLevArr[o] == "����" ? color[1] :(manLevArr[o] == "��ʾ" ? color[2] : (manLevArr[o] == "��ֹ" ? color[3] : "")))
			var $manLev = $("<div><img style=\"height:30px;position:absolute;left:-5px;top:-15px\" src = \""+ imgurl +""+manLevIcon+"\"/></div>");
			var $infoCard = $("<div style=\"margin-top:-20px;padding:5px;width:70%;\"></div>");
			$keyCard.append($manLev);
			$keyCard.append("<div style=\"width:25%;text-align:right;float:right;margin-top:15px;margin-right:30px;color:"+ manLevcolor +"\"><b>"+keyArr[m]+"</b></div>");
			$keyCard.append("<div style='clear:both;width:0px'></div>");	//�հ������ſ�����
			for (var r = 0; r < arr.length; r++){
				
					$infoCard.append("<span class='icon-drug'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>")
					$infoCard.append(arr[r].item+"<br/>");
					$infoCard.append("<div style=\"color:#676360;font-size:12px;margin-left:25px;\">"+arr[r].val+"<br/></div>");	
			}
			$keyCard.append($infoCard);
		}
	}
}

/// ����ȥ�ط���
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

///����˵����
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
	$("#patNo").bind('click',panoview);			//��תȫ����ͼ
	
	$("#presc-keywords").tabs({
		onSelect:function(title){
		   if (title == "������Ϣ"){
				initLisDatagrid();
		   }else if(title == "�����Ϣ"){
			   initInsDatagrid();
		   }
		}
	});
}

///��ת��ȫ����ͼ
function panoview()
{
	
	if($('#winlode').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="winlode"></div>');
	$('#winlode').window({
		title:'��������б�',
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
	/// ����뿪
	$('#diagnosis').on({
		'mouseleave':function(){
			$("#tip").css({display : 'none'});
		}
	})
	/// ����ƶ�
	$('#diagnosis').on({
		'mousemove':function(){
			var tleft=(event.clientX + 20);
			/// tip ��ʾ��λ�ú������趨
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

