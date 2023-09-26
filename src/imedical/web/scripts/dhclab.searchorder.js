
var Usercode=session['LOGON.USERCODE']; 
var HospID=session['LOGON.HOSPID']; 
var UserId = session['LOGON.USERID'];

//ҳ�����
var me = {
	VisitNumberReportDR:"",
	ConnectString:""
}

$(function() {
    pageInit();
});

function pageInit() {
	ShowOrdItmListsGrid();
	//����
	$('#cmb_Location').combogrid({    
	    panelWidth:200,    
	    idField:'RowID',    
	    textField:'CName',    
	    url:'jquery.easyui.dhclabclassjson.csp',    
	    queryParams: {
			ClassName:"DHCLIS.DHCBTQuery",
			QueryName:"QueryLocation",
			FunModul:"JSON",
			P0:session['LOGON.HOSPID'],
			rows:10000
		},
	    columns:[[    
	        {field:'CName',title:'��������',width:190}  
	    ]],
	    onSelect:function(index,row) {
		    $('#cmb_Ward').combobox("setValue","");
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
	var thisDate = GetCurentDate();
	$('#dt_FindSttDate').datebox('setValue',thisDate);
	$('#dt_FindEndDate').datebox('setValue',thisDate);
	
	$('#text_RegNo').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findOrdItmList();
        }
    });
    
    ///��ȡ�����ӡ���ݿ�����
	var ID="1";
	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCOrderList",MethodName:"GetConnectString",ID:ID},
	function(rtn){
		if (rtn != "") {
			me.ConnectString=rtn;
		}
	});	
}   ///pageInit


var findOrdItmList = function (){
	var AuthFlag = 1;
	var ReadFlag = 0;
	if (document.getElementById("selectReadedCb").checked) {
		ReadFlag = 1;
	} 
	var PrintFlag = "Y";
	if (document.getElementById("selectPrintReport").checked) {
		PrintFlag = "N";
	}
	var SttDate = $('#dt_FindSttDate').datebox('getValue');
    var EndDate = $('#dt_FindEndDate').datebox('getValue');
    var LocationDR = $("#cmb_Location").combogrid('getValue');
    var WardDR = $("#cmb_Ward").combobox('getValue');
    var RegNo = $("#text_RegNo").val();
	//if (document.getElementById("selectAuthedReport").checked) {
	//	AuthFlag = 1;
	//}
	//!document.getElementById("selectIsNeedDate").checked && 
	if (RegNo.length) {
		SttDate="";
		EndDate="";
	}
    if (RegNo.length>0 && RegNo.length < 10) {
	     var i=0;
		 i=10-RegNo.length;
		 var pre=""
		 for (var j=0;j<i;j++) {
			 pre=pre+"0";
		 }
		 RegNo=pre+RegNo;
		 $("#text_RegNo").val(RegNo);
    }
	$('#dgOrdItmList').datagrid("load",{ 
		ClassName:"DHCLIS.DHCOrderListSearch",
		QueryName:"QueryOrderListByRegNo",
		FunModul:"JSON",
		P0:RegNo, 
		P1:LocationDR, 
		P2:WardDR,
		P3:SttDate,   
		P4:EndDate,  
		P5:session['LOGON.HOSPID'],  //AuthFlag:"", 
		P6:AuthFlag,  //AllTS:"", 
		P7:ReadFlag,  //AdmDateFlag:"",
		P8:"",  //AdmDateFlag:""
		P9:session['LOGON.USERCODE'],
		P10:UserId,
		P11:PrintFlag
	});
}

//�򿪱����ó��Ѷ�
var SetReadedFlag = function(){
	var selectedRow = $("#dgOrdItmList").datagrid("getSelected")
	if (selectedRow.length==0) return;
	var OrderID = selectedRow["OEOrdItemID"]
	var VisitNumberReportDR = selectedRow["VisitNumberReportDR"]
	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCReportControl",MethodName:"AddViewLog",UserId:UserId,VisitNumberReportDR:VisitNumberReportDR,HospID:HospID,OrderID:OrderID},
	   function(rtn){
		   if (rtn == "1") {
			   $.messager.show({
					title:'��ʾ��Ϣ',
					msg:'�Ķ��ɹ�!',
					timeout:5000,
					showType:'slide'
				});
				$('#dgOrdItmList').datagrid("reload");
		   }
		}
	);
	//AddViewLog(USERID,EpisodeID,PatientID,OrderID)
}

//ҽ����ϸ�б�
function ShowOrdItmListsGrid(EpisodeID,PatientID,Search) {
    $('#dgOrdItmList').datagrid({
		url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCOrderListSearch",
			QueryName:"QueryOrderList",
			FunModul:"JSON",
			P0:EpisodeID, 
			P1:PatientID, 
			P2:"", 
			P3:"",  //ToDate:"", 
			P4:"",  //LocCode:"", 
			P5:"",  //AuthFlag:"", 
			P6:"",  //AllTS:"", 
			P7:"",  //AdmDateFlag:""
			P8:session['LOGON.USERCODE'],
			P9:""   //ReadFlag
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
          { field: 'chkReportList', checkbox: true },
          { field: 'LabEpisode', title: '�����', width: 120, sortable: false, align: 'center' },
          { field: 'BedNo', title: '����', width: 80, sortable: false, align: 'left' },
          { field: 'SurName', title: '����', width: 100, sortable: false, align: 'left' },
          { field: 'Species', title: '�Ա�', width: 50, sortable: false, align: 'center' },
          { field: 'Age', title: '����', width: 50, sortable: false, align: 'center' },
          { field: 'OrdItemName', title: 'ҽ������', width: 200, sortable: false, align: 'left' },
          //{ field: 'OrdSpecimen', title: '�걾����', width: 100, sortable: false, align: 'left' },
          { field: 'ResultStatus', title: '���״̬', width:100, sortable: false, align: 'center', formatter: ResultIconPrompt 
         
          },
		  { field: 'PrintFlag', title: '��ӡ', width: 30, sortable: false, align: 'left',
          	formatter: function (value, rowData, rowIndex) {
                          if(value=="Y")
                          {
	                          return '<span class="icon-ok" title="�Ѵ�ӡ">&nbsp&nbsp&nbsp&nbsp&nbsp</span>';
                          }
                          else if(value=="N")
                          {
	                          return '';
                          }
                      }
          },
          //{ field: 'TSResultAnomaly', title: '�쳣���', width: 60, sortable: false, align: 'center'
           //, styler: function (value, rowData, rowIndex) {
			//	if (rowData.TSResultAnomaly == "1") { return 'color:red;'; }
			//}
		  //},
          { field: 'ReadFlag', title: '�Ķ�', width: 30, sortable: false, align: 'center',
          	formatter: function(value, rowData, rowIndex){
	          	if (rowData.ResultStatus != "3")
	          		return "";
	        	if (value == "1") {
		        	return "<span class='icon-book_open' color='red' title='���Ķ�')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>";
	        	}
	        	else {
		        	return "<span class='icon-book_go' color='red' title='δ�Ķ�')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>";
	        	}  	
	        } 
          },
          { field: 'TransComm', title: 'Σ����ʾ', width: 150, sortable: false, align: 'left' },
          { field: 'ReceiveNotes', title: '�걾��ע', width: 150, sortable: false, align: 'left' },
          { field: 'MajorConclusion', title: '��������', width: 150, sortable: false, align: 'left' },
////          { field: 'ViewResultChart', title: '��ʷ', width: 60, sortable: false, align: 'center' },
//          { field: 'PreReport', title: 'Ԥ����', width: 60, sortable: false, align: 'center' },
          { field: 'ReqDateTime', title: '��������', width: 150, sortable: false, align: 'center' },
          { field: 'SpecDateTime', title: '�ɼ�����', width: 150, sortable: false, align: 'center' },
          { field: 'ReceiveDateTime', title: '��������', width: 150, sortable: false, align: 'center' },
          { field: 'AuthDateTime', title: '��������', width: 150, sortable: false, align: 'center' },
          { field: 'VisitNumberReportDR', title: 'VisitNumberReportDR', width: 60, sortable: false, align: 'center' },
        ]],
        onLoadSuccess: function (data) {
            ShowReportResult("");
        },
         rowStyler: function (index, rowData) {
            ///������
//            if (rowData.ReportAbFlag == "1" && rowData.ReportStatus == "3") {
//                console.info(rowData.TestSetStatus);
//                return "color:red;";
//            }
        },
        onSelect:function(rowIndex, rowData) {
	        me.VisitNumberReportDR = rowData["VisitNumberReportDR"];
	         if ((rowData["ResultStatus"] == 3) && (rowData["ReadFlag"] != 1)) {
		        $("#div_ReportResultEast").panel("setTitle","������&nbsp&nbsp<a href='#' class='' id='btn_confirmReaded' onclick='SetReadedFlag()'>�Ķ�ȷ��</a>");
		        $("#btn_confirmReaded").linkbutton({})
	        }
	        else {
		        $("#div_ReportResultEast").panel("setTitle","������");
	        }
	        if (rowData["ResultStatus"].length > 0 && rowData["VisitNumberReportDR"].length > 0 && rowData["ResultStatus"] == 3) {
		        ShowReportResult(rowData["VisitNumberReportDR"]);
	        }
	        else {
		        $('#dg_ReportResult').datagrid("loadData",[]);
	        }
        }
    });
}; //ShowOrdItmListsGrid

//��ʾ�����б�
function ShowAdmList(PatientID) {
	$('#cb_admList').combobox({
		valueField:'id',    
    	textField:'name',
    	multiple:false,
    	separator:"/",    
        columns:[[    
        {field:'id',title:'id',width:60,hidden:true},
//        { field: 'ck', checkbox: true },    
        {field:'name',title:'Name',width:185}
    	]]  ,
        onLoadSuccess: function (data) {
          $('#cb_admList').combobox("setValue",EpisodeID);
        },
         rowStyler: function (index, rowData) {
            ///������
//            if (rowData.ReportAbFlag == "1" && rowData.ReportStatus == "3") {
//                console.info(rowData.TestSetStatus);
//                return "color:red;";
//            }
        }
    });
	 $.ajax({
		url:'jquery.easyui.dhclabclassjson.csp',
		data:{
			ClassName:"DHCLIS.DHCOrderList",
			QueryName:"getAdmList",
			FunModul:"MTHD",
			P0:PatientID
		},
		type:"get",
		success:function(data) {
			var admArray = data.split("^");
			var cbArray= [{"id":"","name":"ȫ������"}];
			for (var i in admArray) {
				if (admArray[i].length > 10) {
					var id = admArray[i].split(",")[0];
					var name = admArray[i].replace(id+",","");
					cbArray.push({"id":id,"name":name});
				}
			}
			$('#cb_admList').combobox("loadData",cbArray)
		} 
	 })
	 
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
	var UserParam=UserId + "^" + HospID;
	
	var printFlag = "0";
    var rowids = reportDRs;
    var userCode = UserParam;
    var paramList = param;
    var connectString = me.ConnectString;
    var printType = "PrintOut";
    var clsName = "HIS.DHCReportPrint";
    var funName = "QueryPrintData";
	var Param = printFlag + "@" + connectString + "@" + reportDRs + "@" + UserParam + "@" + printType + "@" + paramList;
	PrintCommon(Param);
	
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
	
	return;
	
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
	
}
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
	return;

}

//�������鿴
function ShowReportResult(VisitNumberReportDR) {
	 if (VisitNumberReportDR == "") {
		 $("#div_ReportResultEast").panel("setTitle","������");
	 }
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
              { field: 'Synonym', title: '��д', width: 50, sortable: false, align: 'center' },
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
              { field: 'AbFlag', title: '�쳣��ʾ', width: 60, sortable: false, align: 'center',
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
              { field: 'ResNoes', title: '���˵��', width: 90, sortable: false, align: 'left' },
              { field: 'Units', title: '��λ', width: 90, sortable: false, align: 'left' },
              { field: 'RefRanges', title: '�ο���Χ', width: 100, sortable: false, align: 'center' },
              { field: 'PreResult', title: 'ǰ�ν��', width: 100, sortable: false, align: 'center',formatter:HistoryIconPrompt,
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
              { field: 'PreAbFlag', title: 'ǰ���쳣��ʾ', width: 90, sortable: false,hidden: true, align: 'center'},
              { field: 'ResClass', title: 'Σ����ʾ', width: 90, hidden:true,sortable: false, align: 'center',
                styler: function (value, rowData, rowIndex) {

                }
              },
              { field: 'ClinicalSignifyS', title: '�ٴ�����', width: 150, sortable: false, align: 'center'}
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


//�µĴ�ӡ��ʽ
function PrintCommon(Param) {
	
	//var Param = printFlag + "@" + connectString + "@" + reportDRs + "@" + UserParam + "@" + printType + "@" + paramList;
	var printUrl="http://"+ webIP +"/imedicallis/lisprint/print2HIS/ResultPrintForHis.application?Param="+Param;
	document.location.href=printUrl;
	
}