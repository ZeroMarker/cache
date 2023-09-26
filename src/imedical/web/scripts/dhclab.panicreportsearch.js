//ҳ�����
var me = {
	VisitNumberReportDR:""
}

$(function() {
    pageInit();
});

function pageInit() {
	//����
	$('#cmb_Location').combogrid({    
	    panelWidth:210,    
	    idField:'RowID',    
	    textField:'CName',    
	    url:'jquery.easyui.dhclabclassjson.csp',    
	    queryParams: {
			ClassName:"DHCLIS.DHCBTQuery",
			QueryName:"QueryLocation",
			FunModul:"JSON",
			rows:150,
			P0:session['LOGON.HOSPID']
		},
	    columns:[[    
	        {field:'CName',title:'��������',width:190}  
	    ]],
	    onSelect:function(index,row) {
		    $.ajax({
			    url:'jquery.easyui.dhclabclassjson.csp',
				data:{
					ClassName:"DHCLIS.DHCBTQuery",
					QueryName:"QueryWard",
					FunModul:"JSON",
					P0:row.RowID
				},
				type:"get",
				dataType:"json",
				success:function(data) {
					$('#cmb_Ward').combobox("loadData",data["rows"]);
				}
		    })
		}    
	});
	//����
	$('#cmb_Ward').combobox({    
	    panelWidth:150,    
	    valueField:'RowID',    
	    textField:'CName'
	});
	//ҽ������
	$('#cmb_Doctor').combogrid({    
	    panelWidth:210,    
	    idField:'RowID',    
	    textField:'CName',
	    url:'jquery.easyui.dhclabclassjson.csp',
		queryParams:{
			ClassName:"DHCLIS.DHCBTQuery",
			QueryName:"QueryDoctor",
			FunModul:"JSON"
		},
		type:"get", 
	    columns:[[    
	        {field:'CName',title:'ҽ��',width:190}  
	    ]]  
	});
	var thisDate = GetCurentDate();
	$('#dt_FindSttDate').datebox('setValue',thisDate);
	$('#dt_FindEndDate').datebox('setValue',thisDate);
	
	$('#text_RegNo').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findOrdItmList();
        }
    });
    
    ShowPanicReportList();
    findOrdItmList();
}   ///pageInit


var findOrdItmList = function (){
	var AuthFlag = 0;
	var SttDate = $('#dt_FindSttDate').datebox('getValue');
    var EndDate = $('#dt_FindEndDate').datebox('getValue');
    var LocationDR = $("#cmb_Location").combogrid('getValue');
    var WardDR = $("#cmb_Ward").combobox('getValue');
//    var RegNo = $("#text_RegNo").val();
//	if (document.getElementById("selectAuthedReport").checked) {
//		AuthFlag = 1;
//	}
//	if (!document.getElementById("selectIsNeedDate").checked && RegNo.length) {
//		SttDate="";
//		EndDate="";
//	}
	var DoctorDR = $("#cmb_Doctor").combogrid('getValue');
//    if (RegNo.length>0 && RegNo.length < 10) {
//	     var i=0;
//		 i=10-RegNo.length;
//		 var pre=""
//		 for (var j=0;j<i;j++) {
//			 pre=pre+"0";
//		 }
//		 RegNo=pre+RegNo;
//		 $("#text_RegNo").val(RegNo);
//    }
	$('#dgPanicReportList').datagrid("load",{ 
		ClassName:"DHCLIS.DHCLISPanicReport",
		QueryName:"QueryPanicReport",
		FunModul:"JSON",
		P0:LocationDR, 
		P1:WardDR, 
		P2:SttDate,
		P3:EndDate,   
		P4:session['LOGON.HOSPID'],  
		P5:DoctorDR, 
		P6:"",  
		P7:"", 
		P8:""
	});
}

//�򿪱����ó��Ѷ�
var SetReadedFlag = function(){
	var UserId = session['LOGON.USERID'];
	var selectedRow = $("#dgPanicReportList").datagrid("getSelected")
	if (selectedRow.length==0) return;
	var OrderID = selectedRow["OEOrdItemID"]
	var EpisodeID = selectedRow["LabEpisode"]
	$.ajaxRunServerMethod({ClassName:"web.DHCLabReportControl",MethodName:"AddViewLog",UserId:UserId,EpisodeID:EpisodeID,PatientID:PatientID,OrderID:OrderID},
	   function(rtn){
		   if (rtn == "1") {
			   $.messager.show({
					title:'��ʾ��Ϣ',
					msg:'�Ķ��ɹ�!',
					timeout:2000,
					showType:'slide'
				});
				$('#dgPanicReportList').datagrid("reload");
		   }
		}
	);
	//AddViewLog(USERID,EpisodeID,PatientID,OrderID)
}

//��ʾΣ������
function ShowPanicReportList() {
    $('#dgPanicReportList').datagrid({	
    	url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCLISPanicReport",
			QueryName:"QueryPanicReport",
			FunModul:"JSON",
			P0:"", 
			P1:"", 
			P2:"",
			P3:"",   
			P4:"",  
			P5:"", 
			P6:"",  
			P7:"", 
			P8:""
		},		
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		pageList: [20, 50, 100, 200],
		striped:true,
		nowrap: false, 
		border: true,
		collapsible: true,
		singleSelect:true,
		selectOnCheck: false,
        checkOnSelect: false,
		fit:true, 
        columns: [[
          { field: 'TestSetName', title: 'ҽ������', width: 180, sortable: true, align: 'left' },
          { field: 'SurName', title: '��������', width: 60, sortable: true, align: 'center' },
          { field: 'SpecimenName', title: '�걾', width: 80, sortable: true, align: 'left' },
          { field: 'AuthDateTime', title: '����ʱ��', width: 120, sortable: true, align: 'center' },
          { field: 'MajorConclusion', title: 'Σ����ʾ', width: 150, sortable: true, align: 'left' },
          { field: 'DoctorName', title: '����ҽ��', width: 60, sortable: true, align: 'center' },
          { field: 'LocationName', title: '�������', width: 100, sortable: true, align: 'left' },
          { field: 'VisitNumberReportDR', title: '����', width:90, sortable: true, align: 'center', formatter: ResultIconPrompt 
         
          },
          { field: 'RegNo', title: '�ǼǺ�', width: 100, sortable: true, align: 'center'}
 
        ]]
    });
}; //ShowOrdItmListsGrid

//���ͼ����ʾ
function ResultIconPrompt(value, rowData, rowIndex) {
	if (rowData.VisitNumberReportDR.length)
       	return "<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(" + rowData.VisitNumberReportDR + "))';><span class='icon-urgent' color='red' title='Σ��ֵ���')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>������</a>";
}

//�������
function ReportView(VisitNumberReportDR) {
    //showwin("#win_ReportResultView", "���鱨��", "http://172.21.21.92/iMedicalLIS/sample/form/frmRequest.aspx?OEOrdItemID=" + OEOrdItemID, 900, 570, true);
	//return false;
	
	var width = document.body.clientWidth - 200;
	var height = document.body.clientHeight - 50;
	$("#win_ReportResultView").window({
		modal:true,
		title:'���鱨��',
		//closable:false,
		collapsible:false,
		iconCls:'icon-message',
		width:width,
		height:height,
		content:'<iframe src="jquery.easyui.dhclabreport.csp?VisitNumberReportDR='+VisitNumberReportDR+'" scrolling="no" frameborder="0" style="width:100%;height:100%;"></iframe>'
		//top: xy.top+20,
		//left: xy.left-width+100
	});
	return false;
	
}

//����id �����⣬����ҳ�棬�� ����
function showwin(winid, title, url, mywidth, myheight, draggable) {//�޸ĺ���ӵĵ�����
	alert(url);
    var _content = '<iframe id="FRMdetail"  frameborder="0"  src=' + url + ' style="width:100%;height:100%;" ></iframe>';
    $(winid).dialog({
        width: mywidth,
        height: myheight,
        modal: true,
        content: _content,
        title: title,
        draggable: draggable,
        resizable: true,
        shadow: true,
        minimizable: false
        //onClose: function () { winClose(winid); }  ///liuzf ���ڻص������庯��������
    });
}

//�����ӡ
function printOutClick() {
	var checkedRows =  $('#dgOrdItmList').datagrid("getChecked");
	var reportDRs = "";
	for (var i in checkedRows) {
		if (checkedRows[i]["ResultStatus"] != "3") {
			$.messager.alert('������ʾ','����'+checkedRows[i]["OrdItemName"]+"δ�����棬���ܴ�ӡ��");
			return;
		}
		if (reportDRs.length > 0)
			reportDRs = reportDRs+","+checkedRows[i]["VisitNumberReportDR"];
		else 
			reportDRs = checkedRows[i]["VisitNumberReportDR"]
	}
	reportDRs=2
	var a = $("<a href='/imedicallis/facade/ui/frmRepostPrint.aspx?reportDRs="+reportDRs +"'target='_blank'></a>").get(0);  
              
            var e = document.createEvent('MouseEvents');  
  
            e.initEvent('click', true, true);  
            a.dispatchEvent(e);  
	
}


//�������鿴
function ShowReportResult(VisitNumberReportDR) {
	$('#dg_ReportResult').datagrid({
        url:'jquery.easyui.dhclabclassjson.csp',
		queryParams: { 
			ClassName:"LIS.WS.BLL.DHCRPVisitNumberReportResult",
			QueryName:"QryTSInfo",
			FunModul:"JSON",
			P0:VisitNumberReportDR
		},
        method: 'get',
        fitColumns: false,  //������Ϊtrue,�ж���Ϊfalse
        fit:true,
        collapsible: true,
        rownumbers: true,
        pagination: false,
        pagePosition: 'bottom',
        pageSize: 10,
        pageList: [10, 20, 50, 100, 200],
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: false,
        nowwarp: false,  //����
        border: true,
        remoteSort: false,
        columns: [[
              { field: 'TestCodeDR', title: '��Ŀid', width: 150,  hidden:true, align: 'left' },
              { field: 'Synonym', title: '��д', width: 50, sortable: true, align: 'center' },
              { field: 'TestCodeName', title: '��Ŀ����', width: 150,  align: 'left' },
              { field: 'Result', title: '���', width: 90, align: 'center'
              ,styler: function (value, rowData, rowIndex) {
                        var colStyle = "color:#000000";
                        if (value != "") {
                            if (!isNaN(value)) {   ///��������
                                if (rowData.AbFlag == "L") { colStyle = 'color:blue;' };
                                if (rowData.AbFlag == "H") { colStyle = 'color:red;' };
                                if (rowData.AbFlag == "PL") { colStyle = 'background-color:red;color:blue;' };
                                if (rowData.AbFlag == "PH") { colStyle = 'background-color:red;color:#ffee00;' };
                                if (rowData.AbFlag == "UL") { colStyle = 'background-color:red;color:blue;' };
                                if (rowData.AbFlag == "UH") { colStyle = 'background-color:red;color:#ffee00;' };
                            }
                        return colStyle;
                        }
                    }
               },
              { field: 'AbFlag', title: '�쳣��ʾ', width: 60, sortable: true, align: 'center',
                  styler: function(value, rowData, rowIndex) {
                        var colStyle = "color:#000000";
                        if (value != "") {
                            ///��������
                            if (value == "L") { colStyle = 'color:blue;' };
                            if (value == "H") { colStyle = 'color:red;' };
                            if (value == "PL") { colStyle = 'background-color:red;color:blue;' };
                            if (value == "PH") { colStyle = 'background-color:red;color:#ffee00;' };
                            if (value == "UL") { colStyle = 'background-color:red;color:blue;' };
                            if (value == "UH") { colStyle = 'background-color:red;color:#ffee00;' };
                            return colStyle;
                            }
                    }
              },
              { field: 'Units', title: '��λ', width: 90, sortable: true, align: 'left' },
              { field: 'RefRanges', title: '�ο���Χ', width: 100, sortable: true, align: 'center' },
              { field: 'PreResult', title: 'ǰ�ν��', width: 100, sortable: true, align: 'center',formatter:HistoryIconPrompt,
                styler: function (value, rowData, rowIndex) {
                        var colStyle = "color:#000000";
                        if (value != "") {
                            if (!isNaN(value)) {   ///��������
                                if (rowData.PreAbFlag == "L") { colStyle = 'color:blue;' };
                                if (rowData.PreAbFlag == "H") { colStyle = 'color:red;' };
                                if (rowData.PreAbFlag == "PL") { colStyle = 'background-color:red;color:blue;' };
                                if (rowData.PreAbFlag == "PH") { colStyle = 'background-color:red;color:#ffee00;' };
                                if (rowData.PreAbFlag == "UL") { colStyle = 'background-color:red;color:blue;' };
                                if (rowData.PreAbFlag == "UH") { colStyle = 'background-color:red;color:#ffee00;' };
                            }
                        return colStyle;
                        }
                    }
              },
              { field: 'PreAbFlag', title: 'ǰ���쳣��ʾ', width: 90, sortable: true,hidden: true, align: 'center'},
              { field: 'ResClass', title: 'Σ����ʾ', width: 90, hidden:true,sortable: true, align: 'center',
                styler: function (value, rowData, rowIndex) {

                }
              },
              { field: 'ClinicalSignifyS', title: '�ٴ�����', width: 150, sortable: true, align: 'center'}
            ]],
//        onLoadSuccess: function (data) {
//            $('#ReportContent').datagrid('clearSelections');
//        },
        onDblClickRow: function (rowIndex, rowData) {
            CheckAdmData();
        }
    });
};

///��ʷ���ͼ��
function HistoryIconPrompt(value, rowData, rowIndex) {
    var a = [];
    if (value != "" && rowData.TestCodeName != "��ע") {
       a.push(value + "&nbsp;<a style='text-decoration:none;' href=\"javascript:void(ShowHistoryResult('",  me.VisitNumberReportDR,"','",rowData.TestCodeDR, "'));\"><span class='icon-chart_curve' title='�������ͼ'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;");
    }
    return a.join("");
}

/////�������ͼ
function ShowHistoryResult(VisitNumberReportDR,TestCodeDR) {
    $('#win_ResultCharts').window('open');
    $('#h_ResultCharts').text("�������ͼ");
    var t = $(this);

    $.ajax({
        url:'jquery.easyui.dhclabclassjson.csp',
		data: { 
			ClassName:"LIS.WS.BLL.DHCRPVisitNumberReportResult",
			QueryName:"GetHistoryResultMTHD",
			FunModul:"MTHD",
			P0:VisitNumberReportDR,
			P1:TestCodeDR
		},
        success: function (data) {
             data = jQuery.parseJSON(data)
            if (typeof (data) != "undefined") {
                var rowData = data.rows[0];
                var row = data.dataHead[0];
                var xAxisArr = new Array();
                $.each(row, function (i, v) {
                    if (i.indexOf("Col") >= 0)
                        xAxisArr.push(v.split(' ')[0]); //ͼ����ʾ��x��
                });
                var lineData = new Array();
                var max = '';
                var min = '';
                $.each(rowData, function (i, v) {
                    if (i.indexOf("Col") >= 0) {
                        lineData.push(parseFloat(v));
                    }
                    if (i == 'RefRanges1') {
                        max = parseFloat(v.split('-')[1]);
                        min = parseFloat(v.split('-')[0]);
                    }
                });
                var unit = rowData.Units;
                var legenData = [rowData.TestCodeName];
                lineCharts('div_ResultCharts', rowData.TestCodeName, unit, xAxisArr, lineData, legenData, max, min)
            }
        }
    });
}

//��ȡ��ǰʱ��
function GetCurentDate() {
    var now = new Date();

    var year = now.getFullYear();       //��
    var month = now.getMonth() + 1;     //��
    var day = now.getDate();            //��

    var hh = now.getHours();            //ʱ
    var mm = now.getMinutes();          //��

    var clock = year + "-";

    if (month < 10)
        clock += "0";

    clock += month + "-";

    if (day < 10)
        clock += "0";

    clock += day;

    return (clock);
}