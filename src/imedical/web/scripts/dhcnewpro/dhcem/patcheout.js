$(function(){
	
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
		url:'jquery.easyui.dhclabclassjson.csp',
		data:{
			ClassName:"DHCLIS.DHCOrderList",
			QueryName:"getAdmList",
			FunModul:"MTHD",
			P0:1
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
				
		} 
	 })
}



//�������鿴
function ShowReportResult(VisitNumberReportDR) {
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
    alert("11");
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
		//P1:PatientID, 
		P1:12,
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
            { field: 'LabEpisode', title: '�����',width: 90, sortable: true, align: 'center'},
            { field: 'OrdItemName', title: 'ҽ������',width: 90, sortable: true, align: 'center'},
            { field: 'ResultStatus', title: '���״̬',width: 90, sortable: true, align: 'center'},
            { field: 'PrintFlag', title: '��ӡ',width: 90, sortable: true, align: 'center',
        	formatter: function (value, rowData, rowIndex) {
                          if(value=="Y")
                          {
	                          return '<i class="fa fa-camera-retro fa-2x"></i>';
                          }
                          else if(value=="N")
                          {
	                          return '111';
                          }
                      }
          	},
            { field: 'ReadFlag', title: '�Ķ�',width: 90, sortable: true, align: 'center',
            formatter: function(value, rowData, rowIndex){
	          	if (rowData.ResultStatus != "3")
	          		return "";
	        	if (value == "1") {
		        	return "<span>���Ķ�</span>";
	        	}
	        	else {
		        	return "<span>δ�Ķ�</span>";
	        	}  	
	        } 
	        },
            { field: 'AuthDateTime', title: '��������',width: 90, sortable: true, align: 'center'},
            { field: 'RecDateTime', title: '��������',width: 90, sortable: true, align: 'center'},
            { field: 'SpecDateTime', title: '�ɼ�����',width: 90, sortable: true, align: 'center'},
            { field: 'ReqDateTime', title: '��������',width: 90, sortable: true, align: 'center'},
            { field: 'WarnComm', title: 'Σ����ʾ',width: 90, sortable: true, align: 'center'},
            { field: 'TSMemo', title: '�걾��ʾ',width: 90, sortable: true, align: 'center'},
            { field: 'ViewResultChart', title: '��ʷ',width: 90, sortable: true, align: 'center'},
            { field: 'PreReport', title: 'Ԥ����',width: 90, sortable: true, align: 'center'},
            { field: 'VisitNumberReportDR', title: 'VisitNumberReportDR',width: 90, sortable: true, align: 'center'},
            { field: 'OEOrdItemID', title: 'OEOrdItemID',width: 90, sortable: true, align: 'center'}
            ];

	//�걾�б�
	$('#sampleArr').dhccTable({
	    //height:$(window).height()-300,
	    //sidePagination:'side',
	    height:460,
	    pageSize:15,
	    pageList:[50,100],
        url:"jquery.easyui.dhclabclassjson.csp",
        columns:columns,
        singleSelect:true,
        queryParams: { 
			ClassName:"DHCLIS.DHCOrderList",
			QueryName:"QueryOrderList",
			FunModul:"JSON",
			//P0:EpisodeID, 
			//P1:PatientID, 
			P0:-1, 
			P1:12, 
			P2:"", 
			P3:"",  //ToDate:"", 
			P4:"",  //LocCode:"", 
			P5:"",  //AuthFlag:"", 
			P6:"",  //AllTS:"", 
			P7:"",  //AdmDateFlag:""
			P8:UserId,
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
              { field: 'TestCodeDR', title: '��Ŀid',sortable: true, align: 'center' },
              { field: 'Synonym', title: '��д',sortable: true, align: 'center'},
              { field: 'TestCodeName', title: '��Ŀ����'},
              { field: 'Result', title: '���',sortable: true, align: 'center',
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
 	          { field: 'ExtraRes', title: '�����ʾ',sortable: true, align: 'center'},
              { field: 'AbFlag', title: '�쳣��ʾ',sortable: true, align: 'center',
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
              { field: 'Units', title: '��λ',sortable: true, align: 'center'},
              { field: 'RefRanges', title: '�ο���Χ',sortable: true, align: 'center'},
              { field: 'PreResult', title: 'ǰ�ν��',sortable: true, align: 'center',      //formatter:HistoryIconPrompt,
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
              { field: 'PreAbFlag', title: 'ǰ���쳣��ʾ',sortable: true, align: 'center',hidden: true},
              { field: 'ResClass', title: 'Σ����ʾ',hidden:true,sortable: true, align: 'center'},
              { field: 'ClinicalSignifyS', title: '�ٴ�����',sortable: true, align: 'center'}
            ]];
	
	
	
	//������
	$('#ResultArr').dhccTable({
        url:'jquery.easyui.dhclabclassjson.csp',
        height:460,
		queryParams: { 
			ClassName:"LIS.WS.BLL.DHCRPVisitNumberReportResult",
			QueryName:"QryTSInfo",
			FunModul:"JSON",
			//P0:VisitNumberReportDR
			P0:""
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
		  alert(row.VisitNumberReportDR);	
	      ShowReportResult(row.VisitNumberReportDR);
	      $('#ResultArr').dhccTable('reload');
	});
	
	//���Ұ�ť�İ��¼�
	$('#selBtn').on('click',findOrdItmList)	 //sss
	
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