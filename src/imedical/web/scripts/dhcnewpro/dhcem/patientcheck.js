var PatientID="",showRstTable=""

//ҳ�����
var me = {
	VisitNumberReportDR:"",
	ConnectString:""	
}

//qqa ���ü���ӿڻ�ȡ����·��
var webIP= serverCall("DHCLIS.DHCOrderList","getDllWebIP");

$(function(){
	
	
	//ȡ�����˵�IDֵ
	GetPatId(); 
	
	//��ʼ��Time�ؼ�
	initTmeControl();
	
	//��ʼ������
	initTable();
	
	//������󶨷���
	bindMethod();
	
	//��ʼ��combobox
	initCombobox();
	
	resTable();
	
})



function initCombobox(){
	//�����������ʼ��
	ShowAdmList();
	
	//showCheckName
	ShowCheckName();
	
	//ҽ������������
	ShowItemName();
	}




function initTmeControl(){
	//ʱ��������
	$('#StartDate').dhccDate();
	$('#EndDate').dhccDate();
	//$('#EndDate').setDate(new Date().Format("yyyy-MM-dd"));
}



//�����б�
function ShowAdmList() { 
	
	 $("#diagAdm").dhccSelect({
		url:LINK_CSP+"?ClassName=web.DHCEMPatCheOutNew&MethodName=getAdmList&PatientID="+PatientID+"&StartDate="+$('#StartDate input').val()+"&EndDate="+$('#EndDate input').val()
		 })
}


function ShowCheckName(){
	$('#CheckName').dhccSelect({
		url:LINK_CSP+"?ClassName=web.DHCEMPatCheOutNew&MethodName=getCheckName" 
		})
	}


function ShowItemName(){
	$('#ItemName').dhccSelect({
		url:LINK_CSP+"?ClassName=web.DHCEMPatCheOutNew&MethodName=getItemName" 
		})
	}



//�������鿴
function ShowReportResult() { 
	 $('#cspCheckRarr').dhccQuery(
	 {
		query:{
			offset : 0,
	        limit : "1000",
			ReportDR:me.VisitNumberReportDR
		}
	 })

};


//�����ӡ���
function printViewClick() {
	var checkedRows = $('#cspCheckSamArr').dhccTableM('getSelections');
	if(checkedRows==""){
		dhccBox.alert("û��ѡ�����ݣ�","NoData");
		return ;
		}
	var reportDRs = "";
	for (var i in checkedRows) {
		if (checkedRows[i].ResultStatus!= "3") {
			dhccBox.alert('����'+checkedRows[i].OrdItemName+"δ�����棬���ܽ��д�ӡԤ����");
			return;
		}
		if (reportDRs.length > 0)
			reportDRs = reportDRs+"^"+checkedRows[i].VisitNumberReportDR;
		else 
			reportDRs = checkedRows[i].VisitNumberReportDR
	}
	param="DOCTOR"
	connectString=me.ConnectString
	var UserParam=UserId + "^" + HospID;
	
	var printFlag = "0";
    var rowids = reportDRs;
    var userCode = UserParam;
    var paramList = param;
    var connectString = me.ConnectString;
    var printType = "PrintPreview";
    var clsName = "HIS.DHCReportPrint";
    var funName = "QueryPrintData";
	var Param = printFlag + "@" + connectString + "@" + reportDRs + "@" + UserParam + "@" + printType + "@" + paramList;
	PrintCommon(Param);
}

//�����ѯ��ť
var findOrdItmList = function (){
	
	var AuthFlag = "0";
	if ($("#printRadio:checked").val()=="on") {
		AuthFlag = 1;
	}
	//alert(AuthFlag);
	var PrintFlag = "Y";
	if ($("#issueRadio:checked").val()=="on") {
		PrintFlag = "N";
	}

	var ReadFlag = "0";
	if ($("#readRadio:checked").val()=="on") {
		ReadFlag = 1;
	} 

	var SttDate = $('#StartDate input').val();
    var EndDate = $('#EndDate input').val(); 
    var admNo = $("#diagAdm").val();
    if ((admNo!="")&(admNo!=null)) {
	    EpisodeID = admNo;  //���վ���ID ����
    }else{
	    EpisodeID="-1"		//��ѯ����
    }
    ShowAdmList();     //QQA 2016-11-10 ���¼��ؾ������select2
    
    var Param=""
    Param = EpisodeID+"^"+PatientID+"^"+SttDate+"^"+EndDate+"^"+""+"^"+AuthFlag
    Param=Param+"^"+""+"^"+""+"^"+UserId+"^"+ReadFlag+"^"+""+"^"+""+"^"+""
    Param=Param+"^"+PrintFlag
	$('#cspCheckRarr').dhccTableM("removeAll");  //����������	
    $('#SelDrugRs').remove();                    //���table
     $('#cspCheckSamArr').dhccQuery(
	 {
		query:{
			offset : 0,
	        limit : "1000",
			Params:Param
		}
	 })
	
}

//��ʼ��Table
function initTable(){
	//�걾�б�,���Table
	var columns=[ 
        	{ title:'ѡ��', checkbox: true },
            { field: 'LabEpisode', title: '�����',align:'center'},
            { field: 'OrdItemName', title: 'ҽ������',align:'center',width:300},
            { field: 'ResultStatus', title: '���״̬',align: 'center',formatter: ResultIconPrompt},
            { field: 'PrintFlag', title: '��ӡ',align: 'center',formatter: printFormatter},
            { field: 'ReadFlag', title: '�Ķ�',align: 'center',formatter:readFormatter},
            { field: 'Trance', title: '׷��', width:30, sortable: false, align: 'center', formatter: function (value, rowData, rowIndex) {
                  retStr = "<a href='#' title='�걾׷��'  onclick='ShowReportTrace(\""+rowData.LabEpisode+"\")'><img style='width:25px' src='../scripts/dhcnewpro/images/track.png'/></span></a>"
				  	return retStr;
              	  }
          	},
          	{ field: 'StatusDesc', title: '״̬',align: 'center',
			  cellStyle: function(value,row,index){
					if (value == "�Ǽ�" || value == "����" || value == "���"){
						return {css: {"background-color":"color:#0000ff;"}}
					}
					if (value == "��ʵ") {
						return {css: {"background-color":"color:#7400ff;"}}
					}
					if (value == "ȡ��" || value == "����"){
						return {css: {"background-color":"color:#ff0000;"}}
					}
					if (value == "����") {
						return {css: {"background-color":"color:#fb00ff;"}}
					}
					return {css: {"background-color":"color:#000000;"}}
				}
		   },
            { field: 'AuthDateTime',align: 'center', title: '��������'},
            { field: 'RecDateTime',align: 'center', title: '��������'},
            { field: 'SpecDateTime',align: 'center', title: '�ɼ�����'},
            { field: 'ReqDateTime',align: 'center', title: '��������'},
            { field: 'WarnComm', align: 'center',title: 'Σ����ʾ'},
            { field: 'MajorConclusion', align: 'center',title: '��������'},
            { field: 'TSMemo', align: 'center',title: '�걾��ʾ'},
            { field: 'ViewResultChart', align: 'center',title: '��ʷ'},
            { field: 'PreReport', align: 'center',title: 'Ԥ����'}
     		]; 
	//�걾�б�
	$('#cspCheckSamArr').dhccTable({
	    height:$(window).height()-125,
	    pagination:false,
        url:"dhcapp.broker.csp?ClassName=web.DHCEMPatCheck&MethodName=JsonQryOrdList",
        columns:columns,
        singleSelect:true,
        queryParam: {
	        offset : 0,
	        limit : "1000",
			Params:"-1^"+PatientID+"^^^^^^^"+UserId+"^^^^^"
		},
      onClickRow:function (row, $element) {
		me.VisitNumberReportDR = row.VisitNumberReportDR;
		if ((row.ResultStatus == 3) && (row.ReadFlag != 1) ) {
	        $("#readBookBtn").show();
        }else {
	        $("#readBookBtn").hide();
        }
        
        if (row.ResultStatus.length > 0 && row.VisitNumberReportDR.length > 0 && row.ResultStatus == 3) {
	        $("#cspCheckSamArr").dhccTableM("uncheckAll");
	        //$("#cspCheckSamArr").dhccTableM('check',$element.attr("data-index"));   //Ӱ�������ѡ��  qqa 2017-09-28
	        ShowReportResult();     //�Ҳ������
        }else{
	        $('#cspCheckRarr').dhccTableM("removeAll");  //����������
			$('#SelDrugRs').remove();
	    }
	}
      
	})

	//���������ұ�Table
	var  columns = [
          //{field :"TestCodeDR",align:'center',title:'��ĿID'},
          { field: 'Synonym',align: 'center', title: '��д'},
          { field: 'TestCodeName',align: 'center', title: '��Ŀ����'},
          { field: 'Result',align: 'center', title: '���',
              cellStyle: function (value, row, index, field) {
	            var colStyle={"color":"black"};
	            if(value!="") {
	             if (!isNaN(value)) {   ///��������
                    if (row.AbFlag == "L") { colStyle = {"color":"blue"}};
                    if (row.AbFlag == "H") { colStyle = {"color":"red"}};
                    if (row.AbFlag == "PL") { colStyle = {"background-color":"red","color":"blue"} };
                    if (row.AbFlag == "PH") { colStyle = {"background-color":"red","color":"#ffee00"} };
                    if (row.AbFlag == "UL") { colStyle = {"background-color":"red","color":"blue"}};
                    if (row.AbFlag == "UH") { colStyle = {"background-color":"red","color":"#ffee00"} };
	             }
	            } 
                return {
			   		css: colStyle
			 	};
            },formatter: function (value, rowData, rowIndex) {
                      if(rowData.ResultFormat=="M")
                      {
                          return '<a href="#" onClick="ShowMicReport(\''+rowData.TestCodeDR+'\');">'+value+'</a>';
                      }
                      else
                      {
                          return value;
                      }
                  }
           },
          { field: 'ExtraRes',align: 'center', title: '�����ʾ'},
          { field: 'AbFlag',align: 'center', title: '�쳣��ʾ',
              cellStyle: function (value, row, index) {
	             var colStyle={"color":"black"};
	             if (value) {  
                    if (value.trim() == "L") { colStyle = {"color":"blue"}};
                    if (value.trim() == "H") { colStyle = {"color":"red"}};
                    if (value.trim() == "PL") { colStyle = {"background-color":"red","color":"blue"} };
                    if (value.trim() == "PH") { colStyle = {"background-color":"red","color":"#ffee00"} };
                    if (value.trim() == "UL") { colStyle = {"background-color":"red","color":"blue"}};
                    if (value.trim() == "UH") { colStyle = {"background-color":"red","color":"#ffee00"} };
	             }
                return {
			   		css: colStyle
			 	};
              }
            },
          { field: 'Units',align: 'center', title: '��λ'},
          { field: 'RefRanges',align: 'center', title: '�ο���Χ'},
          { field: 'PreResult',align: 'center', title: 'ǰ�ν��',formatter:HistoryIconPrompt,
           	    cellStyle: function (value, row, index) {
                   var colStyle={"color":"black"};
                    if (value != "") {
                        if (!isNaN(value)) {   ///��������
                            if (row.PreAbFlag == "L") { colStyle = {"color":"blue"}};
                    		if (row.PreAbFlag == "H") { colStyle = {"color":"red"}};
                   			if (row.PreAbFlag == "PL") { colStyle = {"background-color":"red","color":"blue"} };
                    		if (row.PreAbFlag == "PH") { colStyle = {"background-color":"red","color":"#ffee00"} };
                    		if (row.PreAbFlag == "UL") { colStyle = {"background-color":"red","color":"blue"}};
                   			if (row.PreAbFlag == "UH") { colStyle = {"background-color":"red","color":"#ffee00"} };                 
                        }
                    
                    }
                    return {
			   			css: colStyle
			 		};
                }
          }, 
          { field: 'PreAbFlag', align: 'center',title: 'ǰ���쳣��ʾ',hidden: true}
          //{ field: 'ResClass', title: 'Σ����ʾ',hidden:true},
          //{ field: 'ClinicalSignifyS',align: 'center', title: '�ٴ�����'}
        ];

	//������
	$('#cspCheckRarr').dhccTable({
        height:$(window).height()-125,
        url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheck&MethodName=JsonQryTSInfo',
        columns: columns,
        pagination:false,
        singleSelect: true,
		queryParam: { 
			offset : 0,
	        limit : "1000",
			ReportDR:"" 			
		},
		onLoadSuccess:function (data){
			if(data.rows.length>0){
				if(!$('#SelDrugRs').html()){    //����Ҫ�ظ����
					SelDrugRs(data);	
				}
			}
		}
    });
    
    
    ///��ȡ�����ӡ���ݿ�����
	var ID="1";
	runClassMethod("DHCLIS.DHCOrderList","GetConnectString",{"ID":ID},
		function (rtn){
			if (rtn != "") {
				me.ConnectString=rtn;
			}
		},"text"
	)
}

function bindMethod(){
	
	
	//���Ұ�ť�İ��¼�
	$('#selBtn').on('click',findOrdItmList);	 //sss
	$('#prnBtn').on('click',printOutClick);
	$('#exeBtn').on('click',printViewClick)
	$('#readBookBtn').on('click',SetReadedFlag);
	$('#diagAdm').on('select2:select', function (evt) {
		findOrdItmList();	
	}); 
	
	//�����Ͳ�ѯ
	//$("#selectAuthedReport").change(function () {
    //     findOrdItmList();
    //});
    //�����Ͳ�ѯ
    //$("#selectPrintReport").change(function () {
    //    findOrdItmList();
    //});
    //�����Ͳ�ѯ
    //$("#selectReadedCb").change(function () {
	  
    //     findOrdItmList();
    //});	
}
		
//΢���ﱨ�����
function ShowMicReport(TestCodeDR) {
	option={
		title:'΢���ﱨ��',
		type: 2,
		shadeClose: true,
		shade: 0.8,
		area: ['950px','500px'],
		content: "http://172.21.21.78/iMedicalLIS/facade/ui/frmMicReporstPrint.aspx?reportDRs="+me.VisitNumberReportDR+"&TestCodeDR="+TestCodeDR
	}
	window.parent.layer.open(option);
	return false;
}
	
///��ʷ���ͼ��
function HistoryIconPrompt(value, rowData, rowIndex) {
    var a = [];
    if (value != "" && rowData.TestCodeName != "��ע") {
	    if (rowData["ResultFormat"] == "N")
       		a.push(value + "&nbsp;<a style='text-decoration:none;' href=\"javascript:void(ShowHistoryResult('",  me.VisitNumberReportDR,"','",rowData.TestCodeDR, "'));\"><span class='icon-chart_curve' title='�������ͼ'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;");
       	else 
       		a.push(value);
    }
    return a.join("");
}


//���ͼ����ʾ
function ResultIconPrompt(value, rowData, rowIndex) {
	///(1�Ǽǣ�2����3��ˣ�4���飬5ȡ����ˣ�6���ϣ�O����)
	  event.stopPropagation();
      if (value == "3") {
	    var paramList=rowData.VisitNumberReportDR;
	    if (rowData.TSResultAnomaly == "3") {
        	return "<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(" + paramList + "))';><img style='width:25px' src='../scripts/dhcnewpro/images/absurd.png'/></span>������</a>";
	    }
	    if (rowData.TSResultAnomaly == "2") {
        	return "<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(" + paramList + "))';><img style='width:25px' src='../scripts/dhcnewpro/images/crisis.png'/></span>������</a>";
	    }
	    if (rowData.TSResultAnomaly == "1") {
        	return "<a style='text-decoration:none;color:orange;' href='javascript:void(ReportView(" + paramList + "))';><img style='width:25px' src='../scripts/dhcnewpro/images/abnormal.png'/></span>������</a>";
	    }
	    if (rowData.TSResultAnomaly == "0") {
        	return "<a style='text-decoration:none;' href='javascript:void(ReportView(" + paramList + "))';><span class='' color='red' title='������')></span>������</a>";
		}
    }   
}

function printFormatter(value, rowData, rowIndex){
	  if(value=="Y")
	  {
	      return '<span class="" title="�Ѵ�ӡ">�Ѵ�ӡ</span>';
	  }
	  else if(value=="N")
	  {
	      return '';
	  }
}

function readFormatter(value, rowData, rowIndex){
	if (rowData.ResultStatus != "3") return "";
	if (value == "1") {
    	return "<span class='' color='red' title='���Ķ�')>���Ķ�</span>";
	}
	else {
    	return "<span class='' color='red' title='δ�Ķ�')>δ�Ķ�</span>";
	}  
}

//�������
function ReportView(VisitNumberReportDR) {
	//alert(VisitNumberReportDR);
	option={
		title:'������',
  		type: 2,
  		shadeClose: true,
  		shade: 0.8,
  		area: ['950px','500px'],
  		content: 'jquery.easyui.dhclabreport.csp?VisitNumberReportDR='+VisitNumberReportDR,
  		end:function(){
	  		findOrdItmList();
	  	}
	}
	window.parent.layer.open(option);
	return false;
}


//�򿪱����ó��Ѷ�,���ȷ���Ķ�
var SetReadedFlag = function(){
	var selectedRow=$("#cspCheckSamArr").dhccTableM("getSelections");
	if (selectedRow.length==0) return;
	var OrderID = selectedRow[0].OEOrdItemID
	var VisitNumberReportDR = selectedRow[0].VisitNumberReportDR;
	runClassMethod("DHCLIS.DHCReportControl","AddViewLog",
		{'UserId':UserId,'VisitNumberReportDRs':VisitNumberReportDR,'HospID':HospID,'OrderIDs':OrderID},
	   function(rtn){
		   if (rtn == "1") {
			  dhccBox.alert("�Ķ��ɹ���","patientcheck1");
		   }
		   findOrdItmList();
		   $("#readBookBtn").hide();
		},"text",false
	);
}


//�����ӡ
function printOutClick() {
	var checkedRows=$("#cspCheckSamArr").dhccTableM("getSelections");
	if(checkedRows==""){
		dhccBox.alert("û��ѡ�����ݣ�","NoData");
		return ;
		}
	var reportDRs = "";
	for (var i in checkedRows) {
		if (checkedRows[i].ResultStatus != "3") {
			dhccBox.alert('����'+checkedRows[i].OrdItemName+"δ�����棬���ܴ�ӡ��","wcbg");
			return ;
		}
		if (reportDRs.length > 0) {
			reportDRs = reportDRs+"^"+checkedRows[i].VisitNumberReportDR;
		}
		else 
			reportDRs = checkedRows[i].VisitNumberReportDR;
	}

	param="DOCTOR"
	connectString=me.ConnectString
	var UserParam=UserId + "^" + HospID;
	
	var printFlag = "0";
    var rowids = reportDRs;
    var userCode = UserParam;
    var paramList = param;
    var paramList = "DOCTOR";
    var connectString = me.ConnectString;
    var printType = "PrintOut";
    var clsName = "HIS.DHCReportPrint";
    var funName = "QueryPrintData";
	var Param = printFlag + "@" + connectString + "@" + reportDRs + "@" + UserParam + "@" + printType + "@" + paramList;
	PrintCommon(Param);

    //���´�ӡ��ʶ
	findOrdItmList();    
}

//ͬͨ������ID��ȡ���˵�ID
function  GetPatId(){
	PatientID=MyRunClassMethod("web.DHCEMPatCheOutNew","GetPatIdByEpisodeID",{"EpisodeID":EpisodeID})
}//GetPatId end


/////�������ͼ
function ShowHistoryResult(VisitNumberReportDR,TestCodeDR) {


	
	option={
		title:'�������ͼ',
  		type: 2,
  		shadeClose: true,
  		shade: 0.8,
  		area: ['600px','500px'],
  		content: 'dhcem.rscurve.csp?VisitNumberReportDR='+VisitNumberReportDR+'&TestCodeDR='+TestCodeDR
	}
	window.parent.layer.open(option);
	return false;
}


function hsrTable(){

	if(!showRstTable){
		hideTable();
		return;
	}
	if(showRstTable){
		showTable();
		return;
		}
		
}
function resTable(){
	var rtime = new Date();
    var timeout = false;
    var delta = 200;
    $(window).resize(function() {
        rtime = new Date();
        if (timeout === false) {
            timeout = true;
            setTimeout(resizeend, delta);
        }
    });


    function resizeend() {
        if (new Date() - rtime < delta) {
            setTimeout(resizeend, delta);
        } else {
            timeout = false;
            $('#cspCheckRarr').dhccTableM("resetWidth");
        }
    }
	
}

function ShowReportTrace(LabEpisode) {
	
	if (LabEpisode== undefined || LabEpisode == "") return false;
	option={
		title:'�걾׷��',
  		type: 2,
  		shadeClose: true,
  		shade: 0.8,
  		area: ['800px','500px'],
  		content: 'jquery.easyui.dhclabreporttrace.csp?LabNo='+LabEpisode
	}
	window.parent.layer.open(option);
	return false;
}

//���ú�̨����
//      
function MyRunClassMethod(ClassName,MethodName,Datas){
   Datas=Datas||{};
   var RtnStr = "";
   runClassMethod(ClassName,MethodName,
   Datas,
   function (data){
	  	RtnStr=data;
	  },
	"text",false
	);
	return RtnStr;
}

function SelDrugRs(data){
	var data=data["rows"];
	var TSNames={};
	//�������
	var ClonyNum={};
	//������̬
	var ClonyForms={};
	//��ע
	var ResNoes={};
	for(var i=0;i<data.length;i++) {
    if(data[i]["ResultFormat"] == "M" && data[i]["Result"].length > 0) {
        TSNames[data[i]["ReportResultDR"]] = data[i]["Result"];
        ClonyForms[data[i]["ReportResultDR"]]=data[i]["ClonyForm"];
        ClonyNum[data[i]["ReportResultDR"]]=data[i]["ClonyNum"];
        ResNoes[data[i]["ReportResultDR"]]=data[i]["ResNoes"];

        //��ѯҩ�����
        $.ajax({
             url:'jquery.easyui.dhclabclassjson.csp',
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
			        htmlStr+="<table id='SelDrugRs' style='font-size:12px;padding-top:10;width:430'>";
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
								kc="&nbsp";
							}
							htmlStr+="<td>"+kb+"</td>";
							htmlStr+="<td>"+mic+"</td>";
							htmlStr+="<td>"+retData["rows"][index]["SensitivityName"]+"</td>";
							htmlStr+="</tr>";
					 }
					 htmlStr+="</table>";
			        $('#cspCheckRarr').parents('.fixed-table-body').append(htmlStr);
		         }
	         }
		  })
    	}
	}
	
}



function PrintCommon(Param) {
	var printUrl="http://"+ webIP +"/imedicallis/lisprint/print2HIS/ResultPrintForHis.application?Param="+Param;
	document.location.href=printUrl;
}