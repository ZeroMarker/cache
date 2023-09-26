
var HospID=session['LOGON.HOSPID']; 
var UserId = session['LOGON.USERID'];

//ҳ�����
var me = {
	VisitNumberReportDR:"",
	ConnectString:""
}
var aIcon0Str=getIconHtmlI("��","white","blue");
var aIcon1Str=getIconHtmlI("Ԥ","white","blue");
$(function() {
    pageInit();
    
});

function pageInit() {
	ShowOrdItmListsGrid(EpisodeID,PatientID,Search);
	
//	var curDate = GetCurentDate();
//	$('#dt_FindSttDate').datebox('setValue', curDate);
//    $('#dt_FindEndDate').datebox('setValue', curDate);
	ShowAdmList(PatientID);


	//�����Ͳ�ѯ
	$('#dt_FindSttDate').datebox({
		onSelect:function(date){
			findOrdItmList();
		}
	});
	//�����Ͳ�ѯ
	$('#dt_FindEndDate').datebox({
		onSelect:function(date){
			findOrdItmList();
		}
	});
	//�����Ͳ�ѯ
	$('#cb_admList').combobox({
		onSelect:function(date){
			findOrdItmList();
		}
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

	
	//��ȡ�����ӡ���ݿ�����
	var ID="1";
	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCOrderList",MethodName:"GetConnectString",ID:ID},
	function(rtn){
		if (rtn != "") {
			me.ConnectString=rtn;
		}
	});	
}   ///pageInit


var findOrdItmList = function (){
	var AuthFlag = 0;
	if (document.getElementById("selectAuthedReport").checked) {
		AuthFlag = 1;
	}
	var PrintFlag = "Y";
	if (document.getElementById("selectPrintReport").checked) {
		PrintFlag = "N";
	}
	var ReadFlag = 0;
	if (document.getElementById("selectReadedCb").checked) {
		ReadFlag = 1;
	} 
	var SttDate = $('#dt_FindSttDate').datebox('getValue');
    var EndDate = $('#dt_FindEndDate').datebox('getValue');
    var admNo = $('#cb_admList').combobox("getValue");
    if (admNo.length > 0) {
	    EpisodeID = admNo;
    }
	$('#dgOrdItmList').datagrid("load",{ 
		ClassName:"DHCLIS.DHCOrderList",
		QueryName:"QueryOrderList",
		FunModul:"JSON",
		P0:EpisodeID, 
		P1:PatientID, 
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
	});
}

//�򿪱����ó��Ѷ�
var SetReadedFlag = function(){
	var selectedRow = $("#dgOrdItmList").datagrid("getSelected")
	if (selectedRow.length==0) return;
	var OrderID = selectedRow["OEOrdItemID"]
	var VisitNumberReportDR = selectedRow["VisitNumberReportDR"]
	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCReportControl",MethodName:"AddViewLog",UserId:UserId,VisitNumberReportDRs:VisitNumberReportDR,HospID:HospID,OrderIDs:OrderID},
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
			ClassName:"DHCLIS.DHCOrderList",
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
			P8:UserId,
			P9:"",   //ReadFlag
			P10:"",	 //RegNo
			P11:"",  //LocationDR
			P12:"",  //WardDR
			P13:""  //PrintFlag
		},		
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		pageList: [20, 50, 100, 200],
		striped:true,
		nowrap: true, 
		border: false,
		sortName: 'AuthDateTime',
		sortOrder: 'dasc',
		collapsible: true,
		singleSelect:true,
		selectOnCheck: false,
        checkOnSelect: false,
		fit:true, 
        columns: [[
          { field: 'chkReportList', checkbox: true },
          { field: 'LabEpisode', title: '�����', width: 90, sortable: false, align: 'center' },
          { field: 'OrdItemName', title: 'ҽ������', width: 260, sortable: false, align: 'left' },
		  { field: 'Order', title: '', width: 25, sortable: true, align: 'center',formatter:MCIconPrompt},
          //{ field: 'OrdSpecimen', title: '�걾����', width: 100, sortable: false, align: 'left' },
          { field: 'ResultStatus', title: '���״̬', width:90, sortable: false, align: 'center', formatter: ResultIconPrompt },
          { field: 'Trance', title: '׷��', width:30, sortable: false, align: 'center', formatter: function (value, rowData, rowIndex) {
                  retStr = "<a href='#' title='�걾׷��'  onclick='ShowReportTrace(\""+rowData.LabEpisode+"\",\""+rowData.VisitNumberReportDR+"\")'><span class='icon-track' title='�걾׷��')>&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>"
				  return retStr;
              }
          },
          { field: 'PrintFlag', title: '��ӡ', width: 30, sortable: false, align: 'left',
          	formatter: function (value, rowData, rowIndex) {
                  if(value=="Y")
                  {
                      return '<a href="#" title="��ӡ��¼"  onclick="ShowPrintHistory(\''+rowData.VisitNumberReportDR+'\')"><span class="icon-ok" title="�Ѵ�ӡ">&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>';
                  }
                  else if(value=="N")
                  {
                      return '<a href="#" title="��ӡ��¼"  onclick="ShowPrintHistory(\''+rowData.VisitNumberReportDR+'\')"><span class="icon-undo" title="����δ��ӡ">&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>';
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
		        	return '<a href="#" title="�Ķ���¼"  onclick="ShowReadLog(\''+rowData.VisitNumberReportDR+"\')\"><span class='icon-book_open' color='red' title='���Ķ�')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>";
	        	}
	        	else {
		        	return '<a href="#" title="�Ķ���¼"  onclick="ShowReadLog(\''+rowData.VisitNumberReportDR+"\')\"><span class='icon-book_go' color='red' title='δ�Ķ�')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>";
	        	}  	
	        } 
          },
		  { field: 'StatusDesc', title: '״̬', width: 60, sortable: false, align: 'center',
			  styler: function(value,row,index){
					if (value == "�Ǽ�" || value == "����" || value == "���"){
						return 'color:#0000ff;';
					}
					if (value == "��ʵ") {
						return 'color:#7400ff;';
					}
					if (value == "ȡ��" || value == "����"){
						return 'color:#ff0000;';
					}
					if (value == "����") {
						return 'color:#fb00ff;';
					}
					return 'color:#000000;';
				}
		   },
          { field: 'AuthDateTime', title: '��������', width: 130, sortable: false, align: 'center' },
          { field: 'RecDateTime', title: '��������', width: 130, sortable: true, align: 'center' },
          { field: 'SpecDateTime', title: '�ɼ�����', width: 130, sortable: false, align: 'center' },
          { field: 'ReqDateTime', title: '��������', width: 130, sortable: false, align: 'center' },
          { field: 'WarnComm', title: 'Σ����ʾ', width: 150, sortable: false, align: 'left' },
          { field: 'TSMemo', title: '�걾��ʾ', width: 150, sortable: false, align: 'left' },
           { field: 'ReceiveNotes', title: '�걾��ע', width: 150, sortable: false, align: 'left' },
          { field: 'MajorConclusion', title: '��������', width: 150, sortable: false, align: 'left' },
          { field: 'ViewResultChart', title: '��ʷ', width: 60, sortable: false, align: 'center' },
         // { field: 'PreReport', title: 'Ԥ����', width: 60, sortable: false, align: 'center' },
          { field: 'VisitNumberReportDR', title: 'VisitNumberReportDR', width: 60, sortable: false, align: 'center' },
          { field: 'OEOrdItemID', title: 'OEOrdItemID', width: 60, sortable: false, align: 'center' }
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
	         if ((rowData["ResultStatus"] == 3) && (rowData["ReadFlag"] != 1) && (NoReaded!=1)) {
		        $("#div_ReportResultEast").panel("setTitle","������&nbsp&nbsp<a href='#' class='' id='btn_confirmReaded' onclick='SetReadedFlag()'>�Ķ�ȷ��</a>");
		        $("#btn_confirmReaded").linkbutton({});
		        $("#btn_reportTrace").linkbutton({
			    	iconCls: 'icon-track',
        			plain: true
			    });
	        }
	        else {
		        $("#div_ReportResultEast").panel("setTitle","������");
		        $("#btn_reportTrace").linkbutton({
			    	iconCls: 'icon-track',
        			plain: true
			     });
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
			var cbArray= [{"id":"-1","name":"ȫ������"}];
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
	var retStr="";
    if (value == "3") {
	    var paramList=rowData.VisitNumberReportDR;
	    if (rowData.TSResultAnomaly == "3") {
        	retStr = "<a style='text-decoration:none;color:#FF83FA;' href='javascript:void(ReportView(\"" + paramList + "\"))';><span class='icon-absurb' color='red' title='�ĵ����')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>������</a>";
	    }
	    if (rowData.TSResultAnomaly == "2") {
        	retStr = "<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(\"" + paramList + "\"))';><span class='icon-panic' color='red' title='Σ��ֵ���')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>������</a>";
	    }
	    if (rowData.TSResultAnomaly == "1") {
        	retStr = "<a style='text-decoration:none;color:#FF7F00;' href='javascript:void(ReportView(\"" + paramList + "\"))';><span class='icon-abnormal' color='red' title='�쳣���')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>������</a>";
	    }
	    if (rowData.TSResultAnomaly == "0") {
        	retStr = "<a style='text-decoration:none;color:blue' href='javascript:void(ReportView(\"" + paramList + "\"))';><span class='icon-normal' color='red' title='������')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>������</a>";
		}
		
    }
    //retStr += "<a href='#' title='�걾׷��'  onclick='ShowReportTrace(\""+rowData.LabEpisode+"\")'><span class='icon-track' title='�걾׷��')>&nbsp&nbsp&nbsp</span></a>"
	if(rowData.HasBic=="1")
	{
		retStr="<span style='color:red;'>��</span>"+retStr;
	}
	return retStr;
}

//��������ͼ����ʾ
function MCIconPrompt(value, rowData, rowIndex) {
	var mcStr="";
	if(rowData.HasMC=="1"&&rowData.VisitNumberReportDR!="")
	{
	    mcStr+="<a style='text-decoration:none;color:red;' href='javascript:void(ReportMCView(" + rowData.VisitNumberReportDR + "))';>"+aIcon0Str+"</a>";
	}
	if(rowData.HasMid=="1"&&rowData.VisitNumberReportDR!="")
	{
	    mcStr+="<a style='text-decoration:none;color:red;' href='javascript:void(ReportMIDView(" + rowData.VisitNumberReportDR + "))';>"+aIcon1Str+"</a>";
	}
    return mcStr;
}

function ShowReportTrace(LabEpisode,ReportDR) {
	
	var width = document.body.clientWidth - 200;
	var height = 350;
	if (LabEpisode== undefined || LabEpisode == "") {
		var selectedRow = $("#dgOrdItmList").datagrid("getSelected")
		if (selectedRow.length==0) return;
		 LabEpisode = selectedRow["LabEpisode"];
	}
	$("#win_ReportTrace").window({
		modal:true,
		title:'�걾׷��',
		//closable:false,
		collapsible:false,
		iconCls:'icon-message',
		width:width,
		height:height,
		content:'<iframe src="jquery.easyui.dhclabreporttrace.csp?LabNo='+LabEpisode+'&ReportDR='+ReportDR+'" scrolling="no" frameborder="0" style="width:100%;height:100%;"></iframe>'
		//top: xy.top+20,
		//left: xy.left-width+100
	});
	return false;
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

//��������������
function ReportMCView(VisitNumberReportDR) {
	var width = document.body.clientWidth - 200;
	var height = document.body.clientHeight - 50;
	$("#win_ReportMCView").window({
		modal:true,
		title:'�������̲鿴',
		//closable:false,
		collapsible:false,
		iconCls:'icon-message',
		width:width,
		height:height,
		content:'<iframe src="jquery.easyui.dhcMCProcess.csp?VisitNumberReportDR='+VisitNumberReportDR+'" scrolling="no" frameborder="0" style="width:100%;height:100%;"></iframe>'
	});
	return false;
	
}

//�����м䱨�����
function ReportMIDView(VisitNumberReportDR) {
	var width = document.body.clientWidth - 200;
	var height = document.body.clientHeight - 50;
	$("#win_ReportMCView").window({
		modal:true,
		title:'Ԥ����鿴',
		//closable:false,
		collapsible:false,
		iconCls:'icon-message',
		width:width,
		height:height,
		content:'<iframe src="jquery.easyui.dhclabmidreport.csp?VisitNumberReportDR='+VisitNumberReportDR+'" scrolling="no" frameborder="0" style="width:100%;height:100%;"></iframe>'
	});
	return false;
	
}

//����id �����⣬����ҳ�棬�� ����
function showwin(winid, title, url, mywidth, myheight, draggable) {//�޸ĺ���ӵĵ�����
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
		if (checkedRows[i]["ResultStatus"] != "3"&&checkedRows[i]["HasMid"] != "1") {
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
	if (rowIndexArray.length == 0) {
		$.messager.alert('������ʾ','�빴ѡҪ��ӡ�ı��棡');
		return;
	}
	
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
    var printType = "PrintOut";
    var clsName = "HIS.DHCReportPrint";
    var funName = "QueryPrintData";
	var Param = printFlag + "@" + "" + "@" + reportDRs + "@" + UserParam + "@" + printType + "@" + paramList;
	HISBasePrint(Param);
	
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
	
	//�ɵĴ�ӡ��ʽ
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
	try
	{
    	if (reportDRs) objPrintPreview.PrintOut(reportDRs, UserParam, param, connectString);  
	}
	catch(e)
	{
		var printFlag = "0";       ///0:��ӡ���б��� 1:ѭ����ӡÿһ�ݱ���
        var printType = "PrintPreview";    ///PrintOut:��ӡ  PrintPreview��ӡԤ��
        var paramList = "LIS";               ///1:���洦���ӡ 2:������ӡ 3:ҽ����ӡ
		var Param = printFlag + "@" + connectString + "@" + reportDRs + "@" + UserParam + "@" + printType + "@" + paramList
		HISBasePrint(Param);
	}
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
	if (checkedRows.length == 0) {
		$.messager.alert('������ʾ','�빴ѡҪ��ӡ�ı��棡');
		return;
	}
	for (var i in checkedRows) {
		if (checkedRows[i]["ResultStatus"] != "3"&&checkedRows[i]["HasMid"] != "1") {
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
	var Param = printFlag + "@" + "" + "@" + reportDRs + "@" + UserParam + "@" + printType + "@" + paramList;
	HISBasePrint(Param);
	return;
	
	//����Ϊ�ɵĴ�ӡ��ʽ
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
	try
	{
    	if (reportDRs) objPrintPreview.PrintPreview(reportDRs, UserParam, param, connectString);
	} 
	catch(e)
	{
		var printFlag = "0";       ///0:��ӡ���б��� 1:ѭ����ӡÿһ�ݱ���
        var printType = "PrintPreview";    ///PrintOut:��ӡ  PrintPreview��ӡԤ��
        var paramList = "LIS";               ///1:���洦���ӡ 2:������ӡ 3:ҽ����ӡ
		var Param = printFlag + "@" + connectString + "@" + reportDRs + "@" + UserParam + "@" + printType + "@" + paramList
		LISBasePrint(Param);
	}

}

//���д�ӡ
function printCentralClick() {
	var admNo = $('#cb_admList').combobox("getValue");
	param="DOCTOR"
	connectString=me.ConnectString
	var UserParam=UserId + "^" + HospID
	var printFlag = "0";       ///0:��ӡ���б��� 1:ѭ����ӡÿһ�ݱ���
    var printType = "PrintPreviewOld";    ///PrintOut:��ӡ  PrintPreview��ӡԤ��
    var paramList = "LIS";               ///1:���洦���ӡ 2:������ӡ 3:ҽ����ӡ
    var clsName = "HIS.DHCCentralPrint";
    var funName = "QueryPrintData";
	var Param = printFlag + "@" + connectString + "@" + admNo + "@" + UserParam + "@" + printType + "@" + paramList +"@"+clsName+"@"+funName;
		
	PrintCommon(Param);
	return;
	
	//����Ϊ�ɵĴ�ӡ��ʽ	
	try
	{
    	if (admNo) objPrintPreview.PrintOut(admNo, UserParam, param, connectString,"HIS.DHCCentralPrint","QueryPrintData");  
	}	
	catch(e)
	{
		var printFlag = "0";       ///0:��ӡ���б��� 1:ѭ����ӡÿһ�ݱ���
        var printType = "PrintPreview";    ///PrintOut:��ӡ  PrintPreview��ӡԤ��
        var paramList = "LIS";               ///1:���洦���ӡ 2:������ӡ 3:ҽ����ӡ
		var Param = printFlag + "@" + connectString + "@" + admNo + "@" + UserParam + "@" + printType + "@" + paramList
		HISBasePrint(Param);
	}
}

//���ȫ��
function ViewAllReportClick()
{
	var reportDRs = "";
	param="DOCTOR"
	connectString=me.ConnectString
	var UserParam=UserId + "^" + HospID
	try
	{
    	objPrintPreview.ViewAll(reportDRs, UserCode, param, connectString); 
	}
	catch(e)
	{
		//0:��ӡ���б��� 1:ѭ����ӡÿһ�ݱ���
    	var printFlag = "0";       
    	var rowids = "" ;
    	//��ӡ�û� 
		var userCode = UserID;
    	//1:���洦���ӡ 2:������ӡ 3:ҽ����ӡ
    	var paramList = "OTH";              
    	//PrintOut:��ӡ  PrintPreview��ӡԤ��,ReportView�������
    	var printType = "ReportView";
    	var Param = printFlag +"@" + WebServicAddress +"@" + rowids +"@" + userCode +"@" + printType +"@" + paramList
		LISBasePrint(Param);
	}
}


//�������鿴
function ShowReportResult(VisitNumberReportDR) {
	 if (VisitNumberReportDR == "") {
		 $("#div_ReportResultEast").panel("setTitle","������");
	 }
	$('#dg_ReportResult').datagrid({
        url:'jquery.easyui.dhclabclassjson.csp',
		queryParams: { 
		    //����������������������"LIS.WS.BLL.DHCQryTestItemsForViewRep"
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
        selectOnCheck: false,
        checkOnSelect: false,
        nowwarp: false,  //����
        border: false,
        remoteSort: false,
        columns: [[
              { field: 'TestCodeDR', title: '��Ŀid', width: 150,  hidden:true, align: 'left' },
              { field: 'Synonym', title: '��д', width: 50, sortable: false, align: 'center' },
              { field: 'TestCodeName', title: '��Ŀ����', width: 140,  align: 'left' },
              { field: 'Result', title: '���', width: 130, align: 'center'
              ,styler: function (value, rowData, rowIndex) {
                        var colStyle = "color:#000000";
                        if (value != "") {
                            //if (!isNaN(value)) {   ///��������
                                if (rowData.AbFlag == "L") { colStyle = 'color:blue;' };
                                if (rowData.AbFlag == "H") { colStyle = 'color:red;' };
                                 if (rowData.AbFlag == "A") { colStyle = 'color:red;' };
                                if (rowData.AbFlag == "PL") { colStyle = 'background-color:red;color:blue;' };
                                if (rowData.AbFlag == "PH") { colStyle = 'background-color:red;color:#ffee00;' };
                                if (rowData.AbFlag == "UL") { colStyle = 'background-color:red;color:blue;' };
                                if (rowData.AbFlag == "UH") { colStyle = 'background-color:red;color:#ffee00;' };
                           // }
                        return colStyle;
                        }
                    }
               },
 	           { field: 'ExtraRes', title: '�����ʾ', width: 60, align:'left' },
              { field: 'AbFlag', title: '�쳣��ʾ', width: 50, sortable: false, align: 'center',
                  styler: function(value, rowData, rowIndex) {
                        var colStyle = "color:#000000";
                        if (value != "") {
                            ///��������
                            if (value == "L") { colStyle = 'color:blue;' };
                            if (value == "H") { colStyle = 'color:red;' };
                            if (value == "A") { colStyle = 'color:red;' };
                            if (value == "PL") { colStyle = 'background-color:red;color:blue;' };
                            if (value == "PH") { colStyle = 'background-color:red;color:#ffee00;' };
                            if (value == "UL") { colStyle = 'background-color:red;color:blue;' };
                            if (value == "UH") { colStyle = 'background-color:red;color:#ffee00;' };
                            return colStyle;
                            }
                    },
                    formatter: function(value, rowData, rowIndex){
	          			if (rowData.MultipleResistant=="1")
	          			{
	          				return '<span style="font-weight:bold;color:red;font-size:14px;">�����͡�</span>';
	        			}  	
	        			return value;
	       			 } 
              },
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
             { field: 'MachineParameterDesc', title: '��������', width: 90, align: 'center' },
             { field: 'TestMethodName', title: '��ⷽ��', width: 80, align: 'center' },
              { field: 'ClinicalSignifyS', title: '�ٴ�����', width: 150, sortable: false, align: 'center'}
            ]],
        onLoadSuccess: function (data) {
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
						         $('#dg_ReportResult').prev().children(".datagrid-body").append(htmlStr);
						         
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
						         $('#dg_ReportResult').prev().children(".datagrid-body").append(htmlStr);
					         }
				         }
		            })
	            }  
	            if(data[i]["ExpertRule"] != undefined &&data[i]["ExpertRule"]!=""){
	           		var ExpertRulestring ='<table style="width:100%"><tr><td style="width:75px"><b>ר�ҹ���</b></td> <td> <div style="border:1px solid #000">'+data[i]["ExpertRule"]+'</div> </td></tr></table>';
	            	$('#dg_ReportResult').prev().children(".datagrid-body").append(ExpertRulestring); 
	        	}
            }
            var selectedRow=$('#dgOrdItmList').datagrid('getSelected');
            if (selectedRow==null) return;
            if(selectedRow.MajorConclusion != undefined &&selectedRow.MajorConclusion.length>0){
	           var TSMemostring ='<table style="width:100%"><tr><td style="width:75px"><b>�������ۣ�</b></td> <td> <div style="border:1px solid #000">'+selectedRow.MajorConclusion+'</div> </td></tr></table>';
	            $('#dg_ReportResult').prev().children(".datagrid-body").append(TSMemostring); 
	        }
        },
        onDblClickRow: function (rowIndex, rowData) {
            CheckAdmData();
        }
    });
};
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
	    if (rowData["ResultFormat"] == "N")
       		a.push(value + "&nbsp;<a style='text-decoration:none;' href=\"javascript:void(ShowHistoryResult('"+rowData.ReportDR +"','"+rowData.TestCodeDR+ "'));\"><span class='icon-chart_curve' title='�������ͼ'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;");
       	else 
       		a.push(value);
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
                        var GridDate = new Array();
                        var GridResult = new Array();
                        $.each(row, function (i, v) {
                            if (i.indexOf("Col") >= 0) {
                                //�������ֵ���͵�
                                if (rowData["ResultFormat"] != "N") {
                                    //���datagrid����
                                    GridDate.push(v);
                                } else {
                                    xAxisArr.push(v.split(' ')[0]); //ͼ����ʾ��x��
                                }
                            }
                        });
                        var lineData = new Array();
                        var max = '';
                        var min = '';
                        $.each(rowData, function (i, v) {
                            if (i.indexOf("Col") >= 0) {
                                //�ж��Ƿ�Ϊ��ֵ�͵�(N)
                                if (rowData["ResultFormat"] != "N") {
                                    //������ֵ���͵ı����ʾ
                                    GridResult.push(v);
                                } else {
                                    lineData.push(parseFloat(v));
                                }
                            }
                            if (i == 'RefRanges1') {
                                max = parseFloat(v.split('-')[1]);
                                min = parseFloat(v.split('-')[0]);
                            }
                        });
                        //����������
                        if (rowData["ResultFormat"] != "N") {
                            var DatagridData = new Array();
                            for (var i = 0; i < GridDate.length; i++) {
                                var row = {};
                                row["Date"] = GridDate[i];
                                row["Result"] = GridResult[i];
                                DatagridData.push(row);
                            }
                            $("#div_ResultCharts").html("<table id='dg_historyResultList'></table>");
                            $("#dg_historyResultList").datagrid({
                                fit: true,
                                fitColumns: true,
                                columns: [[
                                { field: 'Date', title: 'ʱ��', width: 100, align: "center" },
                                { field: 'Result', title: '���', width: 300, align: "center" },
                            ]]
                            });
                            $("#dg_historyResultList").datagrid("loadData", DatagridData)
                            return;
                        }
                        if ($("#dg_historyResultList").length > 0) {
                            $("#dg_historyResultList").remove();
                        }
                        var unit = rowData.Units;
                        var legenData = [rowData.TestCodeName];
                        if (lineData.length == 0) return;
                        lineCharts('div_ResultCharts', rowData.TestCodeName, unit, xAxisArr, lineData, legenData, max, min, 3, rowData["ResultFormat"]);
            }
        }
    });
}

///��ʾ��ӡ��¼
function ShowPrintHistory(ReportDR) {
	if(ReportDR=="") return;
	if(ReportDR.split(",").length > 1) ReportDR = ReportDR.split(",")[0];
	 $("#win_PrintHistory").window('open');
     $("#dg_PrintHistory").datagrid({
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

///��ʾ�Ķ���¼
function ShowReadLog(ReportDR) {
	if(ReportDR=="") return;
	if(ReportDR.split(",").length > 1) ReportDR = ReportDR.split(",")[0];
	$("#win_ReadLog").window('open');
     $("#dg_ReadLog").datagrid({
        url: "jquery.easyui.dhclabclassjson.csp",
        queryParams: { 
			ClassName:"LIS.WS.BLL.RPVisitNumberReportReadQuery",
			QueryName:"QryReadRecord",
			FunModul:"JSON",
			P0:ReportDR
		},
        fit: true,
        rownumbers: true,
        columns: [[
	        {
	            field: 'PrintDT', title: '�Ķ�ʱ��', width: 150, align: 'left',
	            formatter: function (value, row, index) {
	                return row["ReadDate"] + "&nbsp;&nbsp;" + row["ReadTime"];
	            }
	        },
	        { field: 'ReadDoctorName', title: '�Ķ���', width: 100, align: 'center' },
        ]]
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
var zPrintIframeIndex=0;
//���������ӡ,�������ͳһ���
function LISBasePrint(para) {
   if (localStorage["iMedicalLISPrintExtendFlag"] == "3") {
      var iframeName = "zPrintIframe" + zPrintIframeIndex;
      zPrintIframeIndex++;
      //���һ���������е�div����Ϊ������Ϣ��
      $(document.body).append('<iframe id="' + iframeName + '" src="' + "iMedicalLIS://" + para + '" style="display:none;"><iframe>');
      setTimeout(function () {
        $("#" + iframeName).remove();
      }, 2500);
   }
   else {
      var win = window.open("iMedicalLIS://" + para, "��ӡ�ȴ�", "height=750,width=650,top=10,left=10,titlebar =no,toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no, status=no,alwaysLowered=no");
      if(localStorage["iMedicalLISPrintExtendFlag"]==""||isNaN(localStorage["iMedicalLISPrintExtendFlag"]))
      {
      	//���ñ�ʶ
      	localStorage["iMedicalLISPrintExtendFlag"] = "1";
      }
      else
      {
	    //���ñ�ʶ
      	localStorage["iMedicalLISPrintExtendFlag"] = parseInt(localStorage["iMedicalLISPrintExtendFlag"])+1;
      }
   }
}

//�µĴ�ӡ��ʽ
function PrintCommon(Param) {
	
	//var Param = printFlag + "@" + connectString + "@" + reportDRs + "@" + UserParam + "@" + printType + "@" + paramList;
	var printUrl="http://"+ webIP +"/imedicallis/lisprint/print2HIS/ResultPrintForHis.application?Param="+Param;
	document.location.href=printUrl;
	
}


//Descͼ������
function getIconHtmlI(Desc, Color, BackGroundColor) {
    if (Color == undefined || Color.length == 0 || Color == null) Color = '#FFF';
    if (BackGroundColor == undefined || BackGroundColor.length == 0 || BackGroundColor == null) BackGroundColor = '#fd5454';
    var retHtml = '<div style=" background-color:' + BackGroundColor + ';display:inline-block;border-radius:4px;width:16px;height:16px;text-align:center" ';
    retHtml += '><span style="color:' + Color + ';font-size:10px;text-align:center">' + Desc + '</span></div>';
    return retHtml;
}