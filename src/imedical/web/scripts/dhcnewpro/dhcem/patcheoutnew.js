var PatientID="",showRstTable=""

//ҳ�����
var me = {
	VisitNumberReportDR:"",
	ConnectString:""	
}
$(function(){
	//ȡ�����˵�IDֵ
	GetPatId();
	//��ʼ������
	initTable();
	//������󶨷���
	bindMethod();
	//��ʼ��combobox
	ShowAdmList();
	
	
})


//��ʾ�����б�,��ʼ��������,ͨ�������б�
function ShowAdmList() { //ssss
    //���������������ʼ��combobox��
	 $.ajax({
		url:'dhcapp.broker.csp',
		data:{
			"ClassName":"web.DHCEMPatCheOutNew",
	        "MethodName":"getAdmList",
			//P0:PatientID    ��ȷ
			"PatientID":PatientID
		},
		type:"get",
		success:function(data) {
			//alert(data);
			var admArray = data.split("^");
			var cbArray= [{"id":"-1","text":"ȫ������"}];
			for (var i in admArray) {
				if (admArray[i].length > 10) {
					var id = admArray[i].split(",")[0];
					var name = admArray[i].replace(id+",","");
					cbArray.push({"id":id,"text":name});
				}
			}
			$("#diagnose_combobox").dhccSelect({
   				data:cbArray 
			});
			$('#diagnose_combobox').val(EpisodeID);
			$('#diagnose_combobox').trigger('change');
		} 
	 })
}



//�������鿴
function ShowReportResult() {
	 
	 $('#ResultArr').dhccQuery(
	 {
		query:{
			ClassName:"web.DHCEMPatCheOutNew",
	   	 	MethodName:"QryTSInfo",
			ReportDR:me.VisitNumberReportDR
		}
	 })
	
};

//�����ӡ���
function printViewClick() {
	//var checkedRows =  $('#dgOrdItmList').datagrid("getChecked");
	var checkedRows = $('#sampleArr').dhccTableM('getSelections');
	var reportDRs = "";
	for (var i in checkedRows) {
		if (checkedRows[i].ResultStatus!= "3") {
			$.messager.alert('������ʾ','����'+checkedRows[i].OrdItemName+"δ�����棬���ܴ�ӡ��");
			return;
		}
		if (reportDRs.length > 0)
			reportDRs = reportDRs+"^"+checkedRows[i].VisitNumberReportDR;
		else 
			reportDRs = checkedRows[i].VisitNumberReportDR
	}
	
	param="DOCTOR"
	connectString=me.ConnectString
	var UserParam=UserId + "^" + HospID
    if (reportDRs) objPrintPreview.PrintPreview(reportDRs, UserParam, param, connectString);  
}

//�����ѯ��ť
var findOrdItmList = function (){
	var AuthFlag = 0;
	if (document.getElementById("selectAuthedReport").checked) {
		AuthFlag = 1;
	}
	//alert(AuthFlag);
	var PrintFlag = "Y";
	if (document.getElementById("selectPrintReport").checked) {
		PrintFlag = "N";
	}
	//alert(PrintFlag);
	var ReadFlag = 0;
	if (document.getElementById("selectReadedCb").checked) {
		ReadFlag = 1;
	} 
	//alert(ReadFlag);
	var SttDate = $('#startDateText').val();
    var EndDate = $('#endDateText').val();   
    var admNo = $("#diagnose_combobox").val();
    if (admNo!="") {
	    EpisodeID = admNo;
    }
    
    
    //alert(EpisodeID+"^"+PatientID+"^"+EndDate+"^"+AuthFlag+"^"+UserId+"^"+ReadFlag+"^"+PrintFlag);
     $('#sampleArr').dhccQuery(
	 {
		query:{
			"ClassName":"web.DHCEMPatCheOutNew",
	        "MethodName":"OrderList",
			"EpisodeID":EpisodeID,
			"PatientID":PatientID,
			"FromDate":SttDate,
			"ToDate":EndDate,  //ToDate:"",
			"LocCode":"",  //LocCode:"",
			"AuthFlag":AuthFlag,  //AuthFlag:"",
			"AllTS":"",  //AllTS:"",
			"AdmDateFlag":"",  //AdmDateFlag:""
			"UserId":UserId, //��¼�û�ID
			"fReadFlag":ReadFlag,   //ReadFlag
			"fRegNo":"",	 //RegNo
			"fLocationDR":"",  //LocationDR
			"fWardDR":"",  //WardDR
			"fPrintFlag":PrintFlag  //PrintFlag
		}
	 })

}

//��ʼ��Table
function initTable(){
	//ʱ��������
	$('#startDate').dhccDate();
	$('#endDate').dhccDate();
	$('#endDate').setDate(new Date().Format("yyyy-MM-dd"));
	//�걾�б�,���Table
	var columns=[ 
        	{ field: 'chkReportList', checkbox: true },
        	//{ field: 'ID', title: 'ID'},
            { field: 'LabEpisode', title: '�����',align:'center'},
            { field: 'OrdItemName', title: 'ҽ������',align:'center',width:300},
            { field: 'ResultStatus', title: '���״̬',formatter: ResultIconPrompt},
            { field: 'PrintFlag', title: '��ӡ',
        	formatter: function (value, rowData, rowIndex) {
                          if(value=="Y")
                          {
	                          return '<span class="" title="�Ѵ�ӡ">&nbsp&nbsp&nbsp&nbsp&nbsp</span>';
                          }
                          else if(value=="N")
                          {
	                          return '';
                          }
                      }
          	},
            { field: 'ReadFlag', title: '�Ķ�',
            formatter: function(value, rowData, rowIndex){
	          	if (rowData.ResultStatus != "3")
	          		return "";
	        	if (value == "1") {
		        	return "<span class='' color='red' title='���Ķ�')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp���Ķ�</span>";
	        	}
	        	else {
		        	return "<span class='' color='red' title='δ�Ķ�')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbspδ�Ķ�</span>";
	        	}   	
	        } 
	        },
            { field: 'AuthDateTime', title: '��������'},
            { field: 'RecDateTime', title: '��������'},
            { field: 'SpecDateTime', title: '�ɼ�����'},
            { field: 'ReqDateTime', title: '��������'},
            { field: 'WarnComm', title: 'Σ����ʾ'},
            { field: 'TSMemo', title: '�걾��ʾ'},
            { field: 'ViewResultChart', title: '��ʷ'},
            { field: 'PreReport', title: 'Ԥ����'}
            //{ field: 'VisitNumberReportDR', title: 'VisitNumberReportDR'},
            //{ field: 'OEOrdItemID', title: 'OEOrdItemID'}
            ];
	//alert(EpisodeID);
	//�걾�б�
	//alert(EpisodeID+":"+PatientID);

	$('#sampleArr').dhccTable({
	    height:435,
	    pageSize:10,
	    pageList:[10,15,20],
        url:"dhcapp.broker.csp",
        columns:columns,
        singleSelect:true,
        queryParam: {
	        ClassName:"web.DHCEMPatCheOutNew",
	        MethodName:"OrderList", 
			EpisodeID:EpisodeID,
			PatientID:PatientID,
			FromDate:"", 
			ToDate:"",  //ToDate:"", 
			LocCode:"",  //LocCode:"", 
			AuthFlag:"",  //AuthFlag:"", 
			AllTS:"",  //AllTS:"", 
			AdmDateFlag:"",  //AdmDateFlag:""
			UserId:UserId, //��¼�û�ID
			fReadFlag:"",   //ReadFlag
			fRegNo:"",	 //RegNo
			fLocationDR:"",  //LocationDR
			fWardDR:"",  //WardDR
			fPrintFlag:""  //PrintFlag
		},
		
        onLoadSuccess:function(data){
	       $('#ResultArr').dhccTableM("removeAll");  //����������
	    }
		
	})
	
	
	//���������ұ�Table
	var  colums = [[
              { field: 'TestCodeDR', title: '��Ŀid'},
              { field: 'Synonym', title: '��д'},
              { field: 'TestCodeName', title: '��Ŀ����'},
              { field: 'Result', title: '���',
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
 	          { field: 'ExtraRes', title: '�����ʾ'},
              { field: 'AbFlag', title: '�쳣��ʾ',
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
              { field: 'Units', title: '��λ'},
              { field: 'RefRanges', title: '�ο���Χ'},
              { field: 'PreResult', title: 'ǰ�ν��',formatter:HistoryIconPrompt,
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
              { field: 'PreAbFlag', title: 'ǰ���쳣��ʾ',hidden: true},
              //{ field: 'ResClass', title: 'Σ����ʾ',hidden:true},
              { field: 'ClinicalSignifyS', title: '�ٴ�����'}
            ]];
	
	
	//������
	$('#ResultArr').dhccTable({
        height:433,
        url:'dhcapp.broker.csp',
        columns: colums,
        singleSelect: true,
		queryParam: { 
			ClassName:"web.DHCEMPatCheOutNew",
	        MethodName:"QryTSInfo",
			ReportDR:me.VisitNumberReportDR 			
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
	// ѡ��һ�д����ķ���
	$('#sampleArr').on('click-row.bs.table', function (e, row, $element) {
		me.VisitNumberReportDR = row.VisitNumberReportDR;
		ShowReportResult();     //�Ҳ������
	});
	
	//���Ұ�ť�İ��¼�
	$('#selBtn').on('click',findOrdItmList);	 //sss
	$('#priRepBtn').on('click',printOutClick);
	$('#priViewBtn').on('click',printViewClick)

	$('#diagnose_combobox').on('select2:select', function (evt) {
		findOrdItmList();	
	}); 
	//�����Ͳ�ѯ
	$("#selectAuthedReport").change(function () {
         findOrdItmList();
    });
    //�����Ͳ�ѯ
    $("#selectPrintReport").change(function () {
         findOrdItmList();
    });
    //�����Ͳ�ѯ
    $("#selectReadedCb").change(function () {
         findOrdItmList();
    });	
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
        if (rowData.ResultFormat == "N")
       		a.push(value + "&nbsp;<a style='text-decoration:none;' href=\"javascript:void(ShowHistoryResult('",  me.VisitNumberReportDR,"','",rowData.TestCodeDR, "'));\"><span class='icon-chart_curve' title='�������ͼ'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;");
       	else 
       		a.push(value);
    }else{
       		a.push(value + "&nbsp;<a style='text-decoration:none;' href=\"javascript:void(ShowHistoryResult('",  me.VisitNumberReportDR,"','",rowData.TestCodeDR, "'));\"><span class='' title='�������ͼ'>&nbsp;&nbsp;&nbsp;&nbsp;���ν��</span></a>&nbsp;");
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
        	return "<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(" + paramList + "))';><span class='' color='red' title='�ĵ����')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>������</a>";
	    }
	    if (rowData.TSResultAnomaly == "2") {
        	return "<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(" + paramList + "))';><span class='' color='red' title='Σ��ֵ���')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>������</a>";
	    }
	    if (rowData.TSResultAnomaly == "1") {
        	return "<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(" + paramList + "))';><span class='' color='red' title='�쳣���')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>������</a>";
	    }
	    if (rowData.TSResultAnomaly == "0") {
        	return "<a style='text-decoration:none;' href='javascript:void(ReportView(" + paramList + "))';><span class='' color='red' title='������')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>������</a>";
		}
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
  		content: 'jquery.easyui.dhclabreport.csp?VisitNumberReportDR='+VisitNumberReportDR
	}
	window.parent.layer.open(option);
	return false;
}


//�����ӡ
function printOutClick() {
	alert("�����ӡ");
	var checkedRows = $('#sampleArr').dhccTableM('getSelections');
	var reportDRs = "";
	var rowIndexArray = [];
	for (var i in checkedRows) {
		alert(i+":"+checkedRows[i].ResultStatus);
		if (checkedRows[i].ResultStatus != "3") {
			alert(checkedRows[i].OrdItemName);
			$.messager.alert('������ʾ','����'+checkedRows[i].OrdItemName+"δ�����棬���ܴ�ӡ��");
			return;
		}
		alert("aaaa");
		if (reportDRs.length > 0) {
			reportDRs = reportDRs+"^"+checkedRows[i].VisitNumberReportDR;
		}
		else 
			reportDRs = checkedRows[i].VisitNumberReportDR;
		var rowIndex =  checkedRows[i].ID;
		rowIndexArray.push(rowIndex);
	}
	param="DOCTOR"
	connectString=me.ConnectString
	var UserParam=UserId + "^" + HospID
    if (reportDRs) objPrintPreview.PrintOut(reportDRs, UserParam, param, connectString);   //�����ӡ��dll
    //���´�ӡ��ʶ
    for (var i = 0; i < rowIndexArray.length; i++) {
		
		$('#sampleArr').dhccTableM('updateRow', {  
			    index: rowIndexArray[i],  
			    row: {  
			            PrintFlag:'Y'
			    }  
		    });  
		
		//$('#dgOrdItmList').datagrid('uncheckRow', rowIndexArray[i]);
    }
}

//�����ӡ
function printOutClick() {
	var checkedRows =  $('#dgOrdItmList').datagrid("getChecked");
	var reportDRs = "";
	var rowIndexArray = [];
	for (var i in checkedRows) {
		if (checkedRows[i]["ResultStatus"] != "3") {
			$.messager.alert('������ʾ','����'+checkedRows[i]["OrdItemName"]+"δ�����棬���ܴ�ӡ��");
			return;
		}
		if (reportDRs.length > 0) {
			reportDRs = reportDRs+"^"+checkedRows[i]["VisitNumberReportDR"];
		}
		else 
			reportDRs = checkedRows[i]["VisitNumberReportDR"];
		var rowIndex  = $('#dgOrdItmList').datagrid("getRowIndex", checkedRows[i]);
		rowIndexArray.push(rowIndex);
	}
	
	param="DOCTOR"
	connectString=me.ConnectString
	var UserParam=UserId + "^" + HospID
    if (reportDRs) objPrintPreview.PrintOut(reportDRs, UserParam, param, connectString);  
    //���´�ӡ��ʶ
    for (var i = 0; i < rowIndexArray.length; i++) {
    	$('#dgOrdItmList').datagrid('updateRow',{
			index: rowIndexArray[i],
			row: {
				PrintFlag:'Y'
			}
		});
		$('#dgOrdItmList').datagrid('uncheckRow', rowIndexArray[i]);
    }
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
  		area: ['950px','500px'],
  		content: 'dhcem.cheouthistoryresult.csp?VisitNumberReportDR='+VisitNumberReportDR+'&TestCodeDR='+TestCodeDR
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
function hideTable(){

	$('#sampleArrDiv').animate({
		width:"67%"
		},200);
	$('#ResultArrDivOne,#ResultArrDivTwo').animate({
		width:"3%"
	},200,function(){
		$('#ResultArrDiv').find(".bootstrap-table").hide();
	});
	showRstTable=1;
}

function showTable(){
	$('#sampleArrDiv,#ResultArrDivOne').animate({
		width:"49%"
		},200);
	$('#ResultArrDivTwo').animate({
		width:"100%"
	},200);
	$('#ResultArrDiv').find(".bootstrap-table").show();
	showRstTable="";
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

function develop (){
	alert("������");
	}