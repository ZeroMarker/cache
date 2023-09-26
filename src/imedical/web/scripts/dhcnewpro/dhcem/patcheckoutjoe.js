var PatientID=""

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
		url:'DHCJOEQueryToJsqon.csp',
		data:{
			ClassName:"web.patcheckout",
			QueryName:"getAdmList",
			FunModul:"MTHD",
			//P0:PatientID    ��ȷ
			P0:PatientID
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
			//$("#diagnose_combobox").val("-1");	
		} 
	 })
}



//�������鿴
function ShowReportResult(VisitNumberReportDR) {
	 //alert(VisitNumberReportDR);   OK
	 if (VisitNumberReportDR == "") {
		 //ΪNULL ��ʱ����ؿ�����
		 ShowReportResult("0");
	 }
	 $('#ResultArr').dhccQuery(
	 {query:{
		ClassName:"LIS.WS.BLL.DHCRPVisitNumberReportResult",
		QueryName:"QryTSInfo",
		FunModul:"JSON",
		P0:VisitNumberReportDR}
	 })

};

//�����ӡ���
function printViewClick() {
	var checkedRows =  $('#dgOrdItmList').datagrid("getChecked");
	var reportDRs = "";
	for (var i in checkedRows) {
		if (checkedRows[i]["ResultStatus"] != "3") {
			$.messager.alert('������ʾ','����'+checkedRows[i]["OrdItemName"]+"δ�����棬���ܴ�ӡ��");
			return;
		}
		if (reportDRs.length > 0)
			reportDRs = reportDRs+"^"+checkedRows[i]["VisitNumberReportDR"];
		else 
			reportDRs = checkedRows[i]["VisitNumberReportDR"]
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
    //alert(EpisodeID);
    //alert(admNo);
    //alert(admNo);
    if (admNo.length > 0) {
	    EpisodeID = admNo;
    }
    
     $('#sampleArr').dhccQuery(
	 {query:{
		ClassName:"DHCLIS.DHCOrderList",
		QueryName:"QueryOrderList",
		FunModul:"JSON",
		P0:EpisodeID, 
		P1:PatientID,   
		//P1:12,     ��ȷ
		P2:SttDate,
		P3:EndDate,  //ToDate:"", 
		P4:"",  //LocCode:"", 
		P5:AuthFlag,  //AuthFlag:"", 
		P6:"",  //AllTS:"", 
		P7:"",  //AdmDateFlag:""
		P8:UserId,
		P9:	ReadFlag,
		P10:"",	 //RegNo
		P11:"",  //LocationDR
		P12:"",  //WardDR
		P13:PrintFlag
		}
	 })
}

//��ʼ��Table
function initTable(){
	//ʱ��������
	$('#startDate').dhccDate();
	$('#endDate').dhccDate();
	
	var columns=[ 
        	{ field: 'chkReportList', checkbox: true },
            { field: 'LabEpisode', title: '�����',width: 90},
            { field: 'OrdItemName', title: 'ҽ������',width: 90},
            { field: 'ResultStatus', title: '���״̬',width: 90,formatter: ResultIconPrompt},
            { field: 'PrintFlag', title: '��ӡ',width: 90,
        	formatter: function (value, rowData, rowIndex) {
                          if(value=="Y")
                          {
	                          return '�Ѵ�ӡ';
                          }
                          else if(value=="N")
                          {
	                          return 'δ��ӡ';
                          }
                      }
          	},
            { field: 'ReadFlag', title: '�Ķ�',width: 90,
            formatter: function(value, rowData, rowIndex){
	          	if (rowData.ResultStatus != "3") //���״̬
	          		return "";
	        	if (value == "1") {
		        	return "<span>���Ķ�</span>";
	        	}
	        	else {
		        	return "<span>δ�Ķ�</span>";
	        	}  	
	        } 
	        },
            { field: 'AuthDateTime', title: '��������',width: 90},
            { field: 'RecDateTime', title: '��������',width: 90},
            { field: 'SpecDateTime', title: '�ɼ�����',width: 90},
            { field: 'ReqDateTime', title: '��������',width: 90},
            { field: 'WarnComm', title: 'Σ����ʾ',width: 90},
            { field: 'TSMemo', title: '�걾��ʾ',width: 90},
            { field: 'ViewResultChart', title: '��ʷ',width: 90},
            { field: 'PreReport', title: 'Ԥ����',width: 90},
            { field: 'VisitNumberReportDR', title: 'VisitNumberReportDR',width: 90},
            { field: 'OEOrdItemID', title: 'OEOrdItemID',width: 90}
            ];
	//�걾�б�
	//alert(EpisodeID+":"+PatientID);
	$('#sampleArr').dhccTable({
	    //height:$(window).height()-300,
	    //sidePagination:'side',
	    height:460,
	    pageSize:15,
	    pageList:[50,100],
        url:"DHCJOEQueryToJsqon.csp",  
        //url:"DHCJOEQueryToJsqon.csp",  
        pagination:false,
        columns:columns,
        //singleSelect:true,
        queryParams: { 
			ClassName:"web.patcheckout",
			QueryName:"QueryOrderList",
			FunModul:"JSON",
			P0:"-1",
			P1:PatientID, 
			P2:"", 
			P3:"",  //ToDate:"", 
			P4:"",  //LocCode:"", 
			P5:"",  //AuthFlag:"", 
			P6:"",  //AllTS:"", 
			P7:"",  //AdmDateFlag:""
			P8:UserId,  //��¼�û�ID
			P8:"",
			P9:"",   //ReadFlag
			P10:"",	 //RegNo
			P11:"",  //LocationDR
			P12:"",  //WardDR
			P13:""  //PrintFlag
		},
		
        onLoadSuccess:function(data){
	       ShowReportResult("0"); 
	    }
		
	})
	
	
	var  colums = [[
              //{ field: 'TestCodeDR', title: '��Ŀid'},
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
	                          return '<a href="#" onClick="ShowMicReport(\''+VisitNumberReportDR+'\',\''+rowData.TestCodeDR+'\');">'+value+'</a>';
                          }
                          else
                          {
	                          return value;
                          }
                      }
	              
               },
 	          { field: 'ExtraRes', title: '�����ʾ'},
              { field: 'AbFlag', title: '�쳣��ʾ',
	              cellStyle: function (value, row, index, field) {
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
              { field: 'PreResult', title: 'ǰ�ν��',      //formatter:HistoryIconPrompt,
                cellStyle: function (value, row, index, field) {
                        var colStyle = "";
                        if (value != "") {
                            if (!isNaN(value)) {   ///��������
                                if (row.PreAbFlag == "L") { colStyle = {"color":"blue"}};
	                    		if (row.PreAbFlag == "H") { colStyle = {"color":"red"}};
	                   			if (row.PreAbFlag == "PL") { colStyle = {"background-color":"red","color":"blue"} };
	                    		if (row.PreAbFlag == "PH") { colStyle = {"background-color":"red","color":"#ffee00"} };
	                    		if (row.PreAbFlag == "UL") { colStyle = {"background-color":"red","color":"blue"}};
	                   			if (row.PreAbFlag == "UH") { colStyle = {"background-color":"red","color":"#ffee00"} };                 
                            }
                        return {
				   			css: colStyle
				 		};
                        }
                    }
              },
              { field: 'PreAbFlag', title: 'ǰ���쳣��ʾ',hidden: true},
              //{ field: 'ResClass', title: 'Σ����ʾ',hidden:true},
              { field: 'ClinicalSignifyS', title: '�ٴ�����'}
            ]];
	
	
	//������
	$('#ResultArr').dhccTable({
        url:'jquery.easyui.dhclabclassjson.csp',
        height:460,
        pagination:false,
		queryParams: { 
			ClassName:"LIS.WS.BLL.DHCRPVisitNumberReportResult",
			QueryName:"QryTSInfo",
			FunModul:"JSON",
			//P0:VisitNumberReportDR
			P0:""  //��ʼ��ֵ����
		},
        method: 'get',
        pagination:true,
        singleSelect: true,
        columns: colums
    });
}



function bindMethod(){
	// ѡ��һ�д����ķ���
	$('#sampleArr').on('click-row.bs.table', function (e, row, $element) {
	      ShowReportResult(row.VisitNumberReportDR);
	      $('#ResultArr').dhccTable('reload');
	});
	
	//���Ұ�ť�İ��¼�
	$('#selBtn').on('click',findOrdItmList);	 //sss
	$('#priRepBtn').on('click',printOutClick);
	$('#priViewBtn').on('click',develop)
	
	
	/*$('#UserTradeSeatBt').on('select2:select', function (evt) {
		var SeatNumberObj =  document.getElementsByName("SeatNumber")[0];
		SeatNumberObj.value = this.value ;
	}); */
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
function ShowMicReport(VisitNumberReportDR,TestCodeDR) {
	var width = document.body.clientWidth - 130;
	var height = document.body.clientHeight - 10;
	$("#win_ReportResultView").window({
		modal:true,
		title:'΢���ﱨ��',
		//closable:false,
		collapsible:false,
		iconCls:'icon-message',
		width:width,
		height:height,
		content:'<iframe src="http://172.21.21.78/iMedicalLIS/facade/ui/frmMicReporstPrint.aspx?reportDRs='+VisitNumberReportDR+'&TestCodeDR='+TestCodeDR+'" scrolling="yes" frameborder="0" style="width:100%;height:100%;"></iframe>'
		//top: xy.top+20,
		//left: xy.left-width+100
	});
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
    }
    return a.join("");
}


//���ͼ����ʾ
function ResultIconPrompt(value, rowData, rowIndex) {
	///(1�Ǽǣ�2����3��ˣ�4���飬5ȡ����ˣ�6���ϣ�O����)
    if (value == "3") {
	    var paramList=rowData.VisitNumberReportDR;
	    //alert(paramList);
	    if (rowData.TSResultAnomaly == "3") {
        	return "<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(" + paramList + "))';>������</a>";
	    }
	    if (rowData.TSResultAnomaly == "2") {
        	return "<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(" + paramList + "))';>������</a>";
	    }
	    if (rowData.TSResultAnomaly == "1") {
        	return "<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(" + paramList + "))';>������</a>";
	    }
	    if (rowData.TSResultAnomaly == "0") {
        	return "<a style='text-decoration:none;' href='javascript:void(ReportView(" + paramList + "))';>������</a>";
		}
    }
}


//�������
function ReportView(VisitNumberReportDR) {
	//alert(VisitNumberReportDR);
	option={
		title:'�Ķ�ȷ��',
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
	//alert($('#sampleArr').dhccTable(''));
	/*
	alert();
	*/
	/*var checkedRows =  $('#dgOrdItmList').datagrid("getChecked");
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
    //var str="/imedicallis/facade/ui/frmRepostPrint.aspx?reportDRs="+reportDRs;
    //window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=700,left=0,top=0')
           
	//var a = $("<a href='/imedicallis/facade/ui/frmRepostPrint.aspx?reportDRs="+reportDRs +"'target='_blank'></a>").get(0);  
    // var e = document.createEvent('MouseEvents');  
    // e.initEvent('click', true, true);  
    // a.dispatchEvent(e);  
	*/
}



//ͬ���ǼǺŻ�ȡ���˵�ID
function  GetPatId(){
	if(RegNo==""){
		PatientID="";	
	}else if(RegNo.length<10){
		for(i=RegNo.length;i<10;i++){
			RegNo="0"+RegNo
		}	
	}
	//alert(RegNo);
	PatientID=MyRunClassMethod("web.patcheckout","GetPatIdByNo",{"RegNo":RegNo})
	//alert(PatientID);
}//GetPatId end
	


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