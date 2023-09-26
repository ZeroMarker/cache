///qqa
///2017-11-28
///HISUI����鿴

$(function (){

	initParam();
	
	initPatInfo();
	
	initMethod();
	
	initDateBox();
	
	initDatagrid();
	
	initCombobox();
	
})

function initCombobox(){
	
	$HUI.combobox("#ordTypeCombo",{
		url:LINK_CSP+"?ClassName=web.DHCEMSeePatLis&MethodName=JsonListArciCat",
		//panelHeight:"auto",
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       
	    }	
	})	
	
	if($("#admType").length==1){
		$HUI.combobox("#admType",{
			data:[
				{"value":"O","text":"����"},
				{"value":"E","text":"����"},
				{"value":"I","text":"סԺ"}
			],
		
			valueField:'value',
			textField:'text',
			onSelect:function(option){
		       searchLisOrd();
		    }	
		})
	}
	
	$HUI.combobox("#ordTypeCombo",{
		url:LINK_CSP+"?ClassName=web.DHCEMSeePatLis&MethodName=JsonListArciCat",
		//panelHeight:"auto",
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       
	    }	
	})
	
	$HUI.combobox("#admLocCombo",{
		url:LINK_CSP+"?ClassName=web.DHCEMSeePatLis&MethodName=GetPositonLocList",
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       
	    }	
	})
}

function initParam(){
	DateFormat="";
	showType=0;
	lisOrdRowData="";
	curCheckIndex="";
	ConnectString="";   ///�����ӡ���ݿ����� 
	webIP="";
	DateOrder="N";
	
	runClassMethod("web.DHCEMSeePatLis","GetParams",{Params:""},
		function (rtn){
			rtnArr = rtn.split("^");
			ConnectString=rtnArr[0];
			webIP=rtnArr[1];
			regNolenght=rtnArr[2];
			DateFormat = rtnArr[3];
		},"text",false
	)

}


function initMethod(){
	$('#search').on('click',searchLisOrd);
	$('#prtViewBtn').on('click',printViewClick);
	$('#prtBtn').on('click',printOutClick);
	$('#affirmReadBtn').on('click',affirmReadBtnClick);
	$('#seeReadDetail').on('click',seeReadDetail);
	$('#seePrtDetail').on('click',seePrtDetail);
	$('#seeOpHist').on('click',seeOpHist);

	///�ǼǺ�
	if($('#patRegNo').length==1){
		$('#patRegNo').on('keypress', regNoKeyPress); 	
	}
}

function regNoKeyPress(){
	if (event.keyCode!=13) return;
	var regNo = $('#patRegNo').val();

	if(regNo==""){
		$.messager.alert("��ʾ","�ǼǺ�Ϊ��");
		return;
	}

	///�ǼǺŲ�0
	for (i=regNo.length;i<regNolenght;i++){
		regNo = "0"+regNo;
	}
	
	//runClassMethod("web.DHCEMInComUseMethod","GetPatIDByRegNo",
	//	{RegNo:regNo},
	//	function(ret){
	//		PatientID=ret;
	//	},"text",false
	//) 
	$('#patRegNo').val(regNo);
	searchLisOrd();	
}



function initDateBox(){
		$HUI.datebox("#sel-stDate",{
			//formatter :myFormatDate
		});

		$HUI.datebox("#sel-edDate",{
			//formatter : myFormatDate
		});
			
		//$HUI.datebox("#sel-stDate").setValue(formatDate(0));
		//$HUI.datebox("#sel-edDate").setValue(formatDate(0));
}

function myFormatDate(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	return y+'-'+m+'-'+d;
}

//��ʼ��datagrid
function initDatagrid(){
	var Params=""
	var stDate = $HUI.datebox("#sel-stDate").getValue();
	var edDate = $HUI.datebox("#sel-edDate").getValue();
	var RegNo = $("#patRegNo").val();
	Params= ""+"^"+RegNo+"^"+stDate+"^"+edDate+"^^0^^^"+UserId+"^0^^^^Y";  //##
	//var columns=[[
	//	{field:'PatLabel',title:'',width:230,formatter:setCellLabel}
	//]];
	
	var columns=[[
          { field: 'chkReportList', checkbox: true },
          { field: 'LabEpisode', title: '�����', width: 95, sortable: false, align: 'center' },
          { field: 'AuthDateTime', title: '��������', width: 150, sortable: false, align: 'center' },
          { field: 'PatNo', title: '�ǼǺ�', width: 100, sortable: false, align: 'center' },
          //{ field: 'BedNo', title: '����', width: 80, sortable: false, align: 'left' },
          { field: 'PatName', title: '����', width: 80, sortable: false, align: 'center' },
          //{ field: 'PatSex', title: '�Ա�', width: 50, sortable: false, align: 'center' },
          //{ field: 'PatAge', title: '����', width: 50, sortable: false, align: 'center' },
          { field: 'OrdItemName', title: 'ҽ������', width: 200, sortable: false, align: 'left' },
          { field: 'ResultStatus', title: '���״̬', width:100, sortable: false, align: 'center', formatter: ResultIconPrompt },
		  { field: 'PrintFlag', title: '��ӡ', width: 40, sortable: false, align: 'left',
          	formatter: function (value, rowData, rowIndex) {
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
          { field: 'WarnComm', title: 'Σ����ʾ', width: 150, sortable: false, align: 'left' },
          { field: 'ReceiveNotes', title: '�걾��ע', width: 150, sortable: false, align: 'left' },
          { field: 'MajorConclusion', title: '��������', width: 150, sortable: false, align: 'left' },
          { field: 'ReqDateTime', title: '��������', width: 150, sortable: false, align: 'center' },
          { field: 'SpecDateTime', title: '�ɼ�����', width: 150, sortable: false, align: 'center' },
          { field: 'RecDateTime', title: '��������', width: 150, sortable: false, align: 'center' },
          { field: 'VisitNumberReportDR', title: 'VisitNumberReportDR', width: 60, sortable: false, align: 'center' },
        ]]

	$HUI.datagrid('#lisOrdTable',{
		url:LINK_CSP+"?ClassName=web.DHCEMSeePatLis&MethodName=JsonQryOrdListOnly&Params="+Params,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:60,  
		pageList:[60], 
		loadMsg: '���ڼ�����Ϣ...',
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		onSelect:function (rowIndex, rowData){
			lisOrdRowData=rowData;
		
			if(rowData.ResultStatus!="3"){
				reloadOrdDetailTable("");
				return;
			}
			
			$("#radio5").radio("setValue",true);  //Ĭ�ϲ�ѯ����
			
			reloadOrdDetailTable(rowData.VisitNumberReportDR);	   //ˢ����ϸ
			reloadLisLab(rowIndex, rowData);
			hideOrShowReadBtn(rowData);
		},
		onLoadSuccess:function(data){
				
		}
	});
		
	var columns=[[
    	{ field: 'Synonym',align: 'center', title: '��д',width:45},
        { field: 'TestCodeName',align: 'center', title: '��Ŀ����',width:60},
        { field: 'Result',align: 'center', title: '���',styler:stylerResult,formatter:formatterResult,width:45},
		{ field: 'ExtraRes',align: 'center', title: '�����ʾ'},
		{ field: 'AbFlag',align: 'center', title: '�쳣��ʾ',width:45,styler: stylerAbFlag},
		{ field: 'Units',align: 'center', title: '��λ'},
		{ field: 'RefRanges',align: 'center', title: '�ο���Χ',width:49},
		{ field: 'PreResult',align: 'center', title: '����',width:35,formatter:HistoryIconPrompt,styler: stylerPreRs}, 
		{ field: 'PreAbFlag', align: 'center',title: 'ǰ���쳣��ʾ',hidden: true}
 	]]; 
 	
 	$HUI.datagrid('#lisOrdDetailTable',{
		url:LINK_CSP+"?ClassName=web.DHCEMSeePatLis&MethodName=JsonQryTSInfo",
		queryParams:{
			ReportDR:"",
			showType:showType 
		},
		fit:true,
		rownumbers:false,
		columns:columns,
		fitColumns:true,
		nowrap:false,
		pageSize:10,  
		pageList:[10,15,20], 
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:false,
		onLoadSuccess: function (data) {
	        var data=data["rows"];
	        var TSNames={};
	        //�������
	        var ClonyNum={};
	        //������̬
	        var ClonyForms={};
	        //��ע
	        var ResNoes={};
	        //��ҩ���Բ鿴�쳣
   			$("#radio6").radio("enable");
            for(var i=0;i<data.length;i++) {
	            if(data[i]["ResultFormat"] == "M" && data[i]["Result"].length > 0) {
		            $("#radio6").radio("disable");
		            TSNames[data[i]["ReportResultDR"]] = data[i]["Result"];
		            ClonyForms[data[i]["ReportResultDR"]]=data[i]["ClonyForm"];
		            ClonyNum[data[i]["ReportResultDR"]]=data[i]["ClonyNum"];
		            ResNoes[data[i]["ReportResultDR"]]=data[i]["ResNoes"];
					
		            //��ѯҩ�����
		            $.ajax({
			             url:'jquery.easyui.dhclabclassjson.csp',
			             async: false,
						 data: { 
							 ClassName:"LIS.WS.BLL.DHCRPMicNumberReport",
							 QueryName:"QryReportResultSen",
							 FunModul:"JSON",
							 P0:data[i]["ReportResultDR"]
						 },
				         success: function (retData) {
					         var htmlStr="";
					         retData = jQuery.parseJSON(retData)
					         if(retData["rows"] != undefined && retData["rows"].length >0){
						        htmlStr+="<table style='font-size:12px;padding-top:10;width:430'>";
						        htmlStr+="<tr><td colspan='5'><span style='color:red;font-weight:bold'>"+TSNames[retData["rows"][0]["VisitNumberReportResultDR"]]
						        if(ClonyNum[retData["rows"][0]["VisitNumberReportResultDR"]] != undefined && ClonyNum[retData["rows"][0]["VisitNumberReportResultDR"]].length > 0)
						        	htmlStr+="</span>----<span style='font-weight:bold'>���������</span>"+ClonyNum[retData["rows"][0]["VisitNumberReportResultDR"]];
						        	if(ClonyForms[retData["rows"][0]["VisitNumberReportResultDR"]] != undefined && ClonyForms[retData["rows"][0]["VisitNumberReportResultDR"]].length > 0)
						        htmlStr+="</span>----<span style='font-weight:bold'>������̬��</span>"+ClonyForms[retData["rows"][0]["VisitNumberReportResultDR"]];
						        htmlStr+="</td></tr>";
						        if(ResNoes[retData["rows"][0]["VisitNumberReportResultDR"]] != undefined && ResNoes[retData["rows"][0]["VisitNumberReportResultDR"]].length > 0)
						        	htmlStr+="<tr><td colspan='5'><span style='font-weight:bold'>��ע��</span>"+ResNoes[retData["rows"][0]["VisitNumberReportResultDR"]]+"</td></tr>";
								htmlStr+="<tr style='font-weight:bold'>";
								htmlStr+="<td>����������</td>";
								htmlStr+="<td>��д</td>";
								htmlStr+="<td>KB(mm)</td>";
								htmlStr+="<td>MIC(ug/ml)</td>";
								htmlStr+="<td>���</td>";
								htmlStr+="</tr>";
								var kb=""
								var mic=""
								for(var index=0;index<retData["rows"].length;index++) {
									  htmlStr+="<tr>";
									  htmlStr+="<td>"+retData["rows"][index]["AntibioticsName"]+"</td>";
										htmlStr+="<td>"+retData["rows"][index]["SName"]+"</td>";
		
										if (retData["rows"][index]["SenMethod"] == "1") {
											kb=retData["rows"][index]["SenValue"];
											mic="&nbsp"
										} else {
											mic=retData["rows"][index]["SenValue"];
											kb="&nbsp";
										}
										htmlStr+="<td>"+kb+"</td>";
										htmlStr+="<td>"+mic+"</td>";
										htmlStr+="<td>"+retData["rows"][index]["SensitivityName"]+"</td>";
										htmlStr+="</tr>";
								 }
								 htmlStr+="</table>";
						         $('#lisOrdDetailTable').prev().children(".datagrid-body").append(htmlStr);
						         
					         }
				         }
		            })
		            //��ѯ��ҩ���ƽ��
		            $.ajax({
			             url:'jquery.easyui.dhclabclassjson.csp',
			             async: false,
						 data: { 
							 ClassName:"LIS.WS.BLL.DHCRPMicNumberReport",
							 QueryName:"QryReportResultRst",
							 FunModul:"JSON",
							 P0:data[i]["ReportResultDR"]
						 },
				         success: function (retData) {
					         var htmlStr="";
					         retData = jQuery.parseJSON(retData)
					         if(retData["rows"] != undefined && retData["rows"].length >0){
						        htmlStr+="<table style='font-size:12px;padding-top:10;width:430'>";
						        htmlStr+="<tr><td><b>��ҩ����</b></td></tr>";
								for(var index=0;index<retData["rows"].length;index++) {
									  htmlStr+="<tr>";
									  	htmlStr+="<td>"+retData["rows"][index]["ResistanceItemName"]+"</td>";
										var resItem=jQuery.parseJSON(retData["rows"][index]["ResItem"]);
										var result=retData["rows"][index]["Result"];
										if(resItem.length>0)
										{
											for(var i=0;i<resItem.length;i++)
											{
												if(resItem[i].id==result)
												{
													result=resItem[i].text;
													break;
												}
											}
										}
										htmlStr+="<td>"+result+"</td>";
									  htmlStr+="</tr>";
								 }
								 htmlStr+="</table>";
						         $('#lisOrdDetailTable').prev().children(".datagrid-body").append(htmlStr);
					         }
				         }
		            })
	            }  
            }
            var selectedRow=$('#lisOrdTable').datagrid('getSelected');
            if (selectedRow==null) return;
            if(selectedRow.MajorConclusion != undefined &&selectedRow.MajorConclusion.length>0){
	           var TSMemostring ='<table style="width:100%"><tr><td style="width:75px"><b>�������ۣ�</b></td> <td> <div style="border:1px solid #000">'+selectedRow.MajorConclusion+'</div> </td></tr></table>';
	            $('#lisOrdDetailTable').prev().children(".datagrid-body").append(TSMemostring); 
	        }
        }
	});	
	
	
	var pager = $HUI.datagrid('#lisOrdTable').getPager();
	
	$(pager).pagination({
		showRefresh:false
	});
	
	
}

function reloadLisLab(rowIndex, rowData){
	var retStr = "<a href='#' title='' onclick='showHistory(\""+rowData.OEOrdItemID+"\")'>��������</span></a>"
	$("#lisLab").html(rowData.LabEpisode);				   //ˢ��Lab
	$("#lisStatus").html(rowData.StatusDesc);
	var lisRsHtml = ResultIconPrompt(rowIndex, rowData);
	$("#lisResult").html(lisRsHtml);
	var htmlStr="";
	htmlStr = "����ʱ��:"+rowData.ReqDateTime
	htmlStr =  htmlStr + "&nbsp;&nbsp;����ʱ��:"+rowData.AuthDateTime
	//$("#lisOrdInfo").html(htmlStr);  //qqa����ʾ����ʱ��ͽ���ʱ��
	$("#detailOrdName").html(rowData.OrdItemName.substring(0,30)+"("+retStr+")");
}

function showHistory(OEOrdItemID){
	window.open ('dhcem.seepatlishist.csp?OEORIID='+OEOrdItemID, "newwindow", "height=450, width=650, toolbar =no,top=100,left=300,, menubar=no, scrollbars=no, resizable=yes, location=no, status=no") ;
	return false;

}

//
function hideOrShowReadBtn(rowData){
	if((rowData.ResultStatus==3)&&(rowData.ReadFlag!=1)){
		$("#affirmReadBtn").show();	
	}else{
		$("#affirmReadBtn").hide();	
	}
}

///��ʼ��������Ϣ
function initPatInfo(){
	
	runClassMethod("web.DHCEMSeePatLis","GetAdmInfoByAdm",{EpisodeID:1370},
	   function(data){
		  $("#patName").html(data.PatName);
		  $("#patSex").html(data.PatSex);
		  $("#patAge").html(data.PatAge);
		  $("#regNo").html(data.PatNo);
		  $("#cardNo").html(data.PatCardNo);
		  $("#MRDiagnos").html(data.MRDiagnos);
		  $("#patLoc").html(data.QueDepDesc);
		  $("#patDoc").html(data.QueDocDesc);
		  $("#patWard").html(data.WardDesc);
		  DateFormat = data.DateSetting;
		  //$("#lisLab").html(data.PatSex);   //������ڵ������б�ʱ����
	   },"json",false
	);
}

function reloadOrdDetailTable(portId){
	
	$HUI.datagrid('#lisOrdDetailTable').load({
		ReportDR:portId,
		showType:showType
	})
}

///���˼���ҽ������
function setCellLabel(value, rowData, rowIndex){
	var reportRsStatus="",lisOrdStatus="";
    var value= rowData.ResultStatus;
    var imgHtm="",imgUrl="";

	if (value == "3") {
		var paramList=rowData.VisitNumberReportDR;
		if (rowData.TSResultAnomaly == "3") {
			reportRsStatus = "../scripts/dhcnewpro/images/absurd.png"; //��
		}
		if (rowData.TSResultAnomaly == "2") {
			reportRsStatus = "../scripts/dhcnewpro/images/crisis.png"; //Σ
		}
		if (rowData.TSResultAnomaly == "1") {
			reportRsStatus = "../scripts/dhcnewpro/images/abnormal.png"; //��
		}
		if (rowData.TSResultAnomaly == "0") {
			reportRsStatus = ""; //����
		}
		
		imgUrl = "../scripts/dhcnewpro/images/yetgo.png";

		if (rowData.ReadFlag == "1") {
    		imgUrl = "../scripts/dhcnewpro/images/yetread.png";
		}  
		
		lisOrdStatus = "background-image: url("+imgUrl+");";  //�����ʾ�Ѿ�������
		

		lisOrdStatus =lisOrdStatus +" background-position-x: 135px;";
		lisOrdStatus =lisOrdStatus +" background-position-y: 7px;";
		lisOrdStatus =lisOrdStatus +" background-repeat-y: no-repeat;";
		lisOrdStatus =lisOrdStatus +" background-repeat-x: no-repeat;";
		lisOrdStatus =lisOrdStatus +" background-repeat: no-repeat;";
	}   
	
	if(reportRsStatus!=""){
		imgHtm='<IMG align="top" style="width:24px;float:right;margin-top:-5px" SRC=\"'+reportRsStatus+'\" title="" border=0/>';
	}else{
		imgHtm="";
	}
	var retHtml=""
	retHtml = 		  '<div style="'+lisOrdStatus+'" title="'+rowData.OrdItemName+'" class="hisui-tooltip" style="width:230px">'
	retHtml= retHtml+ 	'<h1 style="font-weight: normal;line-height:12px">'+rowData.OrdItemName.substring(0,17)+'</h1>'
	retHtml= retHtml+ 	'<h1 style="font-weight: normal;line-height:12px">'+"�걾��:"+rowData.LabEpisode+'</h1>'
	retHtml= retHtml+ 	'<h1 style="font-weight: normal;line-height:12px">'+rowData.ReqDateTime+imgHtm+'</h1>'
	retHtml= retHtml+'</div>'
	return retHtml;
}


///��ʷ���ͼ��
function HistoryIconPrompt(value, rowData, rowIndex) {

   var retHtml = "";
   var iconHtml ="",inconUrl="../scripts/dhcnewpro/images/curve-chart1.png";
   iconHtml = '<IMG align="top" style="width:16px;float:right;" SRC=\"'+inconUrl+'\" title="" border=0/>';
   if (value != "" && rowData.TestCodeName != "��ע") {
	    if (rowData.ResultFormat == "N"){
       		retHtml ="<a style='text-decoration:none;' href=\"javascript:void(ShowHistoryResult("+lisOrdRowData.VisitNumberReportDR+","+rowData.TestCodeDR+"));\">"+value+iconHtml+"</a>";
	    }else{ 
       		retHtml=value
	    }
	   
    }
    return retHtml;
}

/////�������ͼ
function ShowHistoryResult(VisitNumberReportDR,TestCodeDR) {
	window.open ('dhcem.rscurve.csp?VisitNumberReportDR='+VisitNumberReportDR+'&TestCodeDR='+TestCodeDR, "newwindow", "height=450, width=650, toolbar =no,top=100,left=300,, menubar=no, scrollbars=no, resizable=no, location=no, status=no") ;
	return false;
}

function stylerResult(value, row, index){
	var colStyle="color:black";
    if(value!="") {
        if (!isNaN(value)) {   ///��������
            if (row.AbFlag == "L") { colStyle = "color:blue"};
            if (row.AbFlag == "H") { colStyle = "color:red"};
            if (row.AbFlag == "PL") { colStyle = "background-color:red;color:blue"};
            if (row.AbFlag == "PH") { colStyle = "background-color:red;color:#ffee00"};
            if (row.AbFlag == "UL") { colStyle = "background-color:red;color:blue"};
            if (row.AbFlag == "UH") { colStyle = "background-color:red;color:#ffee00" };
        }
    } 
    return colStyle;	
}

function formatterResult(value, row, index){
	if(row.ResultFormat=="M"){
	  	//return '<a href="#" onClick="ShowMicReport(\''+row.TestCodeDR+'\');">'+value+'</a>';
	  	return value;
	}else{
	  	return value;
	}
}


function stylerAbFlag(value, row, index) {
	 var colStyle="color:black";
	 if (value) {  
	    if (value.trim() == "L") { colStyle = "color:blue"};
	    if (value.trim() == "H") { colStyle = "color:red"};
	    if (value.trim() == "A") { colStyle = "color:red"};
	    if (value.trim() == "PL") { colStyle = "background-color:red;color:blue"};
	    if (value.trim() == "PH") { colStyle = "background-color:red;color:#ffee00"};
	    if (value.trim() == "UL") { colStyle = "background-color:red;color:blue"};
	    if (value.trim() == "UH") { colStyle = "background-color:red;color:#ffee00"};
	 }
	return colStyle;
}


function stylerPreRs(value, row, index) {
    var colStyle="color:black";
    if (value != "") {
        if (!isNaN(value)) {   ///��������
            if (row.PreAbFlag == "L") { colStyle = "color:blue"};
    		if (row.PreAbFlag == "H") { colStyle = "color:red"};
   			if (row.PreAbFlag == "PL") { colStyle = "background-color:red;color:blue" };
    		if (row.PreAbFlag == "PH") { colStyle = "background-color:red;color:#ffee00" };
    		if (row.PreAbFlag == "UL") { colStyle = "background-color:red;color:blue"};
   			if (row.PreAbFlag == "UH") { colStyle = "background-color:red;color:#ffee00"};                 
        }
    
    }
    return colStyle;
}

//���ͼ����ʾ
function ResultIconPrompt(value, rowData, rowIndex) {
	///(1�Ǽǣ�2����3��ˣ�4���飬5ȡ����ˣ�6���ϣ�O����)
    if (value == "3") {
	    var paramList=rowData.VisitNumberReportDR;
	    if (rowData.TSResultAnomaly == "3") {
        	return "<a style='text-decoration:none;color:#FF83FA;' href='javascript:void(ReportView(" + paramList + "))';><span class='icon-absurb' color='red' title='�ĵ����')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>������</a>";
	    }
	    if (rowData.TSResultAnomaly == "2") {
        	return "<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(" + paramList + "))';><span class='icon-panic' color='red' title='Σ��ֵ���')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>������</a>";
	    }
	    if (rowData.TSResultAnomaly == "1") {
        	return "<a style='text-decoration:none;color:#FF7F00;' href='javascript:void(ReportView(" + paramList + "))';><span class='icon-abnormal' color='red' title='�쳣���')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>������</a>";
	    }
	    if (rowData.TSResultAnomaly == "0") {
        	return "<a style='text-decoration:none;color:blue' href='javascript:void(ReportView(" + paramList + "))';><span class='icon-normal' color='red' title='������')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>������</a>";
		}
    }
}

function ResultIconPrompt1(rowIndex, rowData) {
	///(1�Ǽǣ�2����3��ˣ�4���飬5ȡ����ˣ�6���ϣ�O����)
	var value= rowData.ResultStatus
	if (value == "3") {
		var paramList=rowData.VisitNumberReportDR;
		if (rowData.TSResultAnomaly == "3") {
			return "<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(" + paramList + "))';><img class='flo-left' style='width:24px' src='../scripts/dhcnewpro/images/absurd.png'/></span><span class='flo-left'>����</span></a>";
		}
		if (rowData.TSResultAnomaly == "2") {
			return "<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(" + paramList + "))';><img class='flo-left' style='width:24px' src='../scripts/dhcnewpro/images/crisis.png'/></span><span class='flo-left'>����</span></a>";
		}
		if (rowData.TSResultAnomaly == "1") {
			return "<a style='text-decoration:none;color:orange;' href='javascript:void(ReportView(" + paramList + "))';><img class='flo-left' style='width:24px' src='../scripts/dhcnewpro/images/abnormal.png'/></span><span class='flo-left'>����</span></a>";
		}
		if (rowData.TSResultAnomaly == "0") {
			return "<a style='text-decoration:none;' href='javascript:void(ReportView(" + paramList + "))';><span class='' color='red' title='������')></span>������</a>";
		}
	}   
}

function upLisDate(event,value){	
	if(value){
		switch ($(event.target).attr("id")){
			case "radio1":
				$HUI.datebox("#sel-stDate").setValue(formatDate(0));
				$HUI.datebox("#sel-edDate").setValue(formatDate(0));
				break;
			case "radio2":
				$HUI.datebox("#sel-stDate").setValue(formatDate(-30));
				$HUI.datebox("#sel-edDate").setValue(formatDate(0));
				break;
			case "radio3":
				$HUI.datebox("#sel-stDate").setValue(formatDate(-180));
				$HUI.datebox("#sel-edDate").setValue(formatDate(0));
				break;
			case "radio4":
				$HUI.datebox("#sel-stDate").setValue("");
				$HUI.datebox("#sel-edDate").setValue("");
				break;
		}
	}
}

function ReportView(VisitNumberReportDR) {
	window.open ('jquery.easyui.dhclabreport.csp?VisitNumberReportDR='+VisitNumberReportDR, "newwindow", "height=500, width=900, toolbar =no,top=100,left=200,, menubar=no, scrollbars=no, resizable=no, location=no, status=no") ;
	return false;
}

function searchLisOrd(){
	var Params=""
	var stDate = $HUI.datebox("#sel-stDate").getValue();
	var edDate = $HUI.datebox("#sel-edDate").getValue();
	var regNo = $('#patRegNo').val();
	var ARCICatDr = $HUI.combobox("#ordTypeCombo").getValue();
	var admTypeDesc = $HUI.combobox("#admType").getValue();
	var admLocID = $HUI.combobox("#admLocCombo").getValue();

	ARCICatDr=ARCICatDr==undefined?"":ARCICatDr;
	admTypeDesc=admTypeDesc==undefined?"":admTypeDesc;
	admLocID=admLocID==undefined?"":admLocID;
	dataOrderVal = DateOrder=="Y"?1:-1;

	$("#detailOrdName").html("��������");
	$("#lisOrdInfo").html("");

	Params= ""+"^"+regNo+"^"+stDate+"^"+edDate+"^^0^^^"+UserId+"^0^^^^Y"+"^"+ARCICatDr+"^"+admTypeDesc+"^"+dataOrderVal+"^"+admLocID;  //##

	$HUI.datagrid('#lisOrdDetailTable').load({
		ReportDR:"",
		showType:showType
	})
	
	$HUI.datagrid('#lisOrdTable').load({
		Params:Params
	})
}

function upShowType(event,value){
	var rowData = $HUI.datagrid("#lisOrdTable").getSelections();
	if(rowData.length===0) return;
	if(value){
		switch($(event.target).attr("id")){
			case "radio5" :   //ȫ��
				showType=0;
				break;
			case "radio6" :   //�쳣
				showType=1;
				break;
		}
		reloadOrdDetailTable(rowData[0].VisitNumberReportDR);
	}
}

//�����ӡ���
function printViewClick() {
	var checkedRows = $HUI.datagrid("#lisOrdTable").getSelections();
	if(checkedRows.length===0){
		$.messager.alert("��ʾ","û��ѡ�����ݣ�");
		return ;
	}
	var reportDRs = "";
	for (var i in checkedRows) {
		if (checkedRows[i].ResultStatus!= "3") {
			$.messager.alert("��ʾ",'����'+checkedRows[i].OrdItemName+"δ�����棬���ܽ��д�ӡԤ����");
			return ;
		}
		if (reportDRs.length > 0)
			reportDRs = reportDRs+"~"+checkedRows[i].VisitNumberReportDR;
		else 
			reportDRs = checkedRows[i].VisitNumberReportDR
	}
	param="DOCTOR"
	connectString=ConnectString
	var UserParam=UserId + "^" + HospID;
	
	var printFlag = "0";
    var rowids = reportDRs;
    var userCode = UserParam;
    var paramList = param;
    var connectString = ConnectString;
    var printType = "PrintPreview";
    var clsName = "HIS.DHCReportPrint";
    var funName = "QueryPrintData";
	var Param = printFlag + "@" + connectString + "@" + reportDRs + "@" + UserParam + "@" + printType + "@" + paramList;
	PrintCommon(Param);
}

//�����ӡ
function printOutClick() {
	var checkedRows=$HUI.datagrid("#lisOrdTable").getSelections();
	if(checkedRows.length===0){
		$.messager.alert("��ʾ","û��ѡ�����ݣ�");
		return ;
	}
	var reportDRs = "";
	for (var i in checkedRows) {
		if (checkedRows[i].ResultStatus != "3") {
			$.messager.alert("��ʾ",'����'+checkedRows[i].OrdItemName+"δ�����棬���ܴ�ӡ��");
			return ;
		}
		if (reportDRs.length > 0) {
			reportDRs = reportDRs+"~"+checkedRows[i].VisitNumberReportDR;
		}
		else 
			reportDRs = checkedRows[i].VisitNumberReportDR;
	}

	param="DOCTOR"
	connectString=ConnectString;
	var UserParam=UserId + "^" + HospID;
	var printFlag = "0";
    var rowids = reportDRs;
    var userCode = UserParam;
    var paramList = param;
    var paramList = "DOCTOR";
    var connectString = ConnectString;
    var printType = "PrintOut";
    var clsName = "HIS.DHCReportPrint";
    var funName = "QueryPrintData";
	var Param = printFlag + "@" + connectString + "@" + reportDRs + "@" + UserParam + "@" + printType + "@" + paramList;
	PrintCommon(Param);
   
}

function affirmReadBtnClick(){
	$.messager.confirm("ȷ��","�Ƿ��Ķ�?",function (ret){
		if(ret){
			readPort();
		}	
	})
	
	
}


function readPort(){

	var selectedRow=$("#lisOrdTable").datagrid("getSelections");
	if (selectedRow.length==0) return;
	var OrderID = selectedRow[0].OEOrdItemID
	var VisitNumberReportDR = selectedRow[0].VisitNumberReportDR;
	runClassMethod("DHCLIS.DHCReportControl","AddViewLog",
		{'UserId':UserId,'VisitNumberReportDRs':VisitNumberReportDR,'HospID':HospID,'OrderIDs':OrderID},
	   function(rtn){
		   if (rtn == "1") {
			  $.messager.alert("��ʾ","�Ķ��ɹ���");
			  $("#affirmReadBtn").hide();
			  searchLisOrd();
		   }
		},"text",false
	);	
}

///�鿴�Ķ���ϸ
function seeReadDetail(){
	var rowData = $HUI.datagrid("#lisOrdTable").getSelections();

	if(rowData.length===0){
		$.messager.alert("��ʾ","δѡ�����ݣ�");
		return;
	}
	
	var reportDR = rowData[0].VisitNumberReportDR;
	
	if(reportDR==""){
		$.messager.alert("��ʾ","δ�����棡");
		return;
	}
	
	var columns=[[
		{field:'ReadDoctorName',title:'�Ķ���',width:110},
		{field:'ReadDate',title:'�Ķ�����',width:110},
		{field:'ReadTime',title:'�Ķ�ʱ��',width:110}
	]];

	$HUI.datagrid('#readDetailTable',{
		url:LINK_CSP+"?ClassName=web.DHCEMSeePatLis&MethodName=JsonGetReadRecord&ReportDR="+reportDR,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:6,  
		pageList:[6], 
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		showHeader:true,
		pagination:true
	});

	$HUI.window("#readDetailWin").open();
}

///�鿴��ӡ��ϸ
function seePrtDetail(){
	var rowData = $HUI.datagrid("#lisOrdTable").getSelections();

	if(rowData.length===0){
		$.messager.alert("��ʾ","δѡ�����ݣ�");
		return;
	}
	
	var reportDR = rowData[0].VisitNumberReportDR;
	
	if(reportDR==""){
		$.messager.alert("��ʾ","δ�����棡");
		return;
	}

	var columns=[[
		{field:'PrtDoctorName',title:'��ӡ��',width:110},
		{field:'PrtDate',title:'��ӡ����',width:110},
		{field:'PrtTime',title:'��ӡʱ��',width:110}
	]];

	$HUI.datagrid('#prtDetailTable',{
		url:LINK_CSP+"?ClassName=web.DHCEMSeePatLis&MethodName=JsonGetPrtRecord&ReportDR="+reportDR,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:6,  
		pageList:[6], 
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		showHeader:true,
		pagination:true
	});

	$HUI.window("#prtDetailWin").open();
}


function seeOpHist(){
	var rowData = $HUI.datagrid("#lisOrdTable").getChecked();
	if(!rowData.length){
		$.messager.alert("��ʾ","δѡ�����ݣ�");
		return;	
	}
	showTraceDetail(rowData[0].LabEpisode);
}

function PrintCommon(Param) {
	var printUrl="http://"+ webIP +"/imedicallis/lisprint/print2HIS/ResultPrintForHis.application?Param="+Param;
	document.location.href=printUrl;
}

function showTraceDetail(LabNo){
	var url = 'jquery.easyui.dhclabreporttrace.csp?LabNo='+LabNo;
	var openCss = 'width='+(window.screen.availWidth-100)+',height='+(window.screen.availHeight-550)+ ', top=250, left=50, location=no,toolbar=no, menubar=no, scrollbars=no, resizable=no,status=no'
	window.open(url,'newwindow',openCss) 	
}

///��ʾ��ӡ��¼
function ShowPrintHistory(ReportDR) {
	if(ReportDR=="") return;
	if(ReportDR.split(",").length > 1) ReportDR = ReportDR.split(",")[0];
	 $HUI.window("#printHistory").open();
    $HUI.datagrid('#printHistoryTable',{
        url: "jquery.easyui.dhclabclassjson.csp",
        queryParams: { 
			ClassName:"LIS.WS.BLL.DHCRPVisitNumberReportPrint",
			QueryName:"QryReportPintHistoryList",
			FunModul:"JSON",
			P0:ReportDR
		},
        fit: true,
        rownumbers: true,
        columns: [[
	        {
	            field: 'PrintDT', title: '��ӡʱ��', width: 150, align: 'left',
	            formatter: function (value, row, index) {
	                return row["PrintDate"] + "&nbsp;&nbsp;" + row["PrintTime"];
	            }
	        },
	        { field: 'PrintedUserName', title: '��ӡ��', width: 100, align: 'center' },
	        {
	            field: 'ModuleID', title: '��ӡ����', width: 100, align: 'center',
	            formatter: function (value, row, index) {
	                if (value == "LIS") {
	                    return "����ƴ�ӡ";
	                }
	                if (value == "DOCTOR") {
	                    return "ҽ����ӡ";
	                }
	            }
	        }
        ]]
    });
}