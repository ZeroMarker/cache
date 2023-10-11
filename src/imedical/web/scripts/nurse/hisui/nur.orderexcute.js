/**
 * @author SongChao
 * @version 20181017
 * @description ҽ��ִ��(ִ��ҽ��)
 * @name nur.orderexcute.js
 */
var GV = {
    _CALSSNAME: "Nur.HISUI.OrderExcute",
    episodeID: "",
    executeOrdIds:""
};
var frm=dhcsys_getmenuform();

var init = function () {
    initPageDom();
    initBindEvent();
}
$(init)
function initPageDom() {	  
    initCondition();
    initPatComBoBox();
    initPatTypeBox();
    initsearchExecedStatus();
    initsearchBillStatus();
    initsearchUserLoc();
    initsearchArcim();
    initsearchDoctor();
    initsearchPatAdmLoc();
    initsearchOrdType();
	initOrdGrid();
}
function initBindEvent() {
    $('#regNoInput').bind('keydown', function (e) {
        var regNO = $('#regNoInput').val();
        if (e.keyCode == 13 && regNO != "") {
            var regNoComplete = completeRegNo(regNO);
            $('#regNoInput').val(regNoComplete);
            ordGridReload();
        }
    });
    $('#medNoInput').bind('keydown', function (e) {
        var medNo = $('#medNoInput').val();
        if (e.keyCode == 13 && medNo != "") {            
            ordGridReload();
        }
    });
    $('#cardNoInput').bind('keydown', function (e) {
        var cardNo = $('#cardNoInput').val();
        if (e.keyCode == 13 && cardNo != "") {            
            //ordGridReload();
            checkCardNo();
        }
    });
    $('#queryOrderBtn').bind('click', ordGridReload);
    $('#execOrdsBtn').bind('click', execOrdsBtnClick);
    $('#cancelOrdsBtn').bind('click', cancelOrdsBtnClick);
    $('#readCardBtn').bind('click', readCardBtnClick); 
    $('#clearBtn').click(clearBtnClick);
    $('#orderPrintBtn').click(function(){
	    ExportPrintCommon("Print");
	});
    $('#exportBtn').click(function(){
	    ExportPrintCommon("Export");
	});
    /*$('#ifExced').checkbox({
	    onCheckChange:function(event,value){
		    	if(value){
			    	$('#execOrdsBtn').linkbutton('disable');
			    	$('#cancelOrdsBtn').linkbutton('enable');
			    	ordGridReload();
			    }
			    else{
				    $('#execOrdsBtn').linkbutton('enable');
				    $('#cancelOrdsBtn').linkbutton('disable');
				    ordGridReload();
				}
		    }
	    }); */  
}
function clearBtnClick(){
	//ordGridReload();	
	$('#regNoInput,#medNoInput,#cardNoInput,#applyNoInput,#diagnosisInput').val('');
	$('#patTypeBox').combobox('setValue','');
	$('#searchBillStatus,#searchPatAdmLoc,#searchArcim,#patComBoBox,#searchDoctor').combobox('setValue','').combobox('setText','');
	$('#searchUserLoc').combobox("setValues","");
	$("#searchExecedStatus").combobox("setValues",['false']);
	$('#otherLoginLocs').combobox('setValues',[session['LOGON.CTLOCID']]);
	$('#startDate').datebox('setValue', formatDate(new Date()));
    $('#endDate').datebox('setValue', formatDate(new Date()));
    var orderByOrdDate=$("#orderByOrdDate").checkbox("getValue")?"Y":"N";
    if (orderByOrdDate=="Y"){
    	$("#orderByOrdDate").checkbox("setValue",false);
    }else{
	    ordGridReload();
	}
}

/*----------------------------------------------------------------------------------*/
/**
 * @description ��ʼ��ҽ���б�
 */
function initOrdGrid() {
    var regNo = $('#regNoInput').val();
    var medNo = $('#medNoInput').val();
    var cardNo = $('#cardNoInput').val();
	var applyNo = $('#applyNoInput').val();
	var diagnosis=$('#diagnosisInput').val();
    var admType = $('#patTypeBox').combobox('getValue');
    var otherLoginLocs = $('#otherLoginLocs').combobox('getValues').join("^") || (LoginPageDefaultQuery=="Y"?session['LOGON.CTLOCID']:"");
    var startDate = $('#startDate').datebox('getValue');
    var endDate = $('#endDate').datebox('getValue');
    //var ifExced = $('#ifExced').checkbox('getValue');
    var searchExecedStatus=$("#searchExecedStatus").combobox("getValues").join("^");
    var searchBillStatus=$("#searchBillStatus").combobox("getText");
    if (searchBillStatus =="ȫ��") searchBillStatus="";
    var searchUserLoc=$("#searchUserLoc").combobox("getValues").join("^");
    var searchPatAdmLoc=$("#searchPatAdmLoc").combobox("getValue");
    var searchArcim=$("#searchArcim").combobox("getValue");
    var searchDoctor=$("#searchDoctor").combobox("getValue");
    var orderByOrdDate=$("#orderByOrdDate").checkbox("getValue")?"Y":"N";
    var searchOrdType=$("#searchOrdType").combobox("getValues").join("^");
    $('#ordGrid').datagrid({
        url: $URL,
        queryParams: {
            ClassName: GV._CALSSNAME,
            QueryName: "QueryOrder",
            ResultSetType: 'array',
            RegNo: regNo,
            MedNo: medNo,
            CardNo: cardNo,
			ApplyNo:applyNo,
			Diagnosis:diagnosis,
            CTLoc: otherLoginLocs,
            StartDate: startDate,
            EndDate: endDate,
            IfExced: searchExecedStatus,
            AdmType: admType,
            searchBillStatus:searchBillStatus,
            searchUserLoc:searchUserLoc,
            searchPatAdmLoc:searchPatAdmLoc,
            searchArcim:searchArcim,
            orderByOrdDate:orderByOrdDate,
            searchDoctor:searchDoctor,
            searchOrdType:searchOrdType,
        },
        columns: [[
            { field: 'OrdStatDesc', title: 'ҽ��״̬', width: 80 },
			{ field: 'ExecStatus', title: 'ִ��״̬', width: 80 },
            { field: 'BillState', title: '�˵�״̬', width: 80,styler: billStateCellStyler },
            { field: 'ordPrice', title: '����(Ԫ)', width: 80,align:"right"},
            { field: 'ordQty', title: '����', width: 80},
            { field: 'ordTotalAmount', title: '�ܼ�(Ԫ)', width: 80,align:"right"},
            { field: 'CreateDoctor', title: 'ҽ��', width: 100 },
            { field: 'CreateDateTime', title: '��ҽ��ʱ��', width: 150 },
            { field: 'SttDateTime', title: 'Ҫ��ִ��ʱ��', width: 150 },
            { field: 'OrcatDesc', title: 'ҽ������', width: 80 },
            { field: 'AdmLoc', title: '�������', width: 150 },
            { field: 'OrdNotes', title: '��ע', width: 130 },               
            { field: 'ExecCtcpDesc', title: 'ִ����', width: 100 },         
            { field: 'ExecDateTime', title: 'ִ��ʱ��', width: 150 },
            { field: 'RecLoc', title: '���տ���', width: 150 },
            { field: 'ordDep', title: '��������', width: 150 },
            { field: 'OeoriId', title: 'ҽ��ID', width: 10 }, // 
        ]],
        frozenColumns: [[
            { field: 'EpisodeID', title: '�����', width: 30,hidden:true}, 
            { field: 'PatName', title: '����', width: 120 },
            { field: 'RegNo', title: '�ǼǺ�', width: 110 },
            { field: 'patMedicareNo', title: '������', width: 80 },
            { field: 'PatSex', title: '�Ա�', width: 50 },
            { field: 'PatAge', title: '����', width: 50 },
            { field: 'AdmTypeDesc', title: '��������', width: 80,
            	formatter: function(value,row,index){
	            	return $g(value);
            	}
            },            
            { field: 'checkCol', title: 'ѡ��', checkbox: true, width: 30 },
            { field: 'ApplyNo', title: '���뵥��', width: 160},
			{ field: 'DiagnosisDesc', title: '���', width: 100},
            { field: 'ArcimDesc', title: 'ҽ������', width: 200, styler:orderNameCellStyler,
            	formatter:function(value,row,index){
	            	if (row.UrgentFlag=="Y") {
		            	value="<font color=red>("+$g("�Ӽ�")+")</font>"+row.ArcimDesc.replace("(�Ӽ�)","");
		            }
	            	value = '<span id=' + row["OeoriId"] + ' onmouseover="ShowOrderDescDetail(this)">'+value+'</span>';
					return value;	
	            }
            },
            { field: 'Operate', title: '����', width: 50, formatter: operCellStyler }]],
        idField: 'OeoriId',
        onLoadSuccess: function(data){
	        initPatComBoBox(data);// mergeCells,
	        initSearchUserLocByGridData(data);
	    },
        onClickCell:mergeCellSelectAll,
        selectOnCheck:false, 
		//checkOnSelect:false,
		//singleSelect:true, 
		onBeforeLoad:function(param){
			$('#ordGrid').datagrid("clearSelections");
	        $('#ordGrid').datagrid("clearChecked");
		},
		onDblClickHeader:function(){
			//ʹ�����´��붨�嵼�����ӡ����
			// CONTEXT=K����:Query��&PAGENAME=�������&PREFID=0
			window.open("websys.query.customisecolumn.csp?CONTEXT=K"+GV._CALSSNAME+":QueryOrder&PAGENAME=DHCNurseOrderExecute&PREFID=0");
		}
    });
}
/**
*@description �ϲ���Ԫ���ѡ�д���
*/
function mergeCellSelectAll(rowIndex, field, value){
	setTimeout(function () {
         $('#ordGrid').datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
    }, 0);
	var arr = ["EpisodeID","PatName", "RegNo","PatSex","PatAge", "AdmTypeDesc"];
	if(arr.indexOf(field)>-1){
		var array=$('#ordGrid').datagrid("getData");
		var rec=array.rows[rowIndex];
		if (SwitchSysPat !="N"){
			frm.EpisodeID.value=rec.EpisodeID;
		}
		$('#ordGrid').datagrid("clearSelections")
		$('#ordGrid').datagrid("clearChecked") 
		var selRecs=array.rows.filter(function(row){
    		var samePat=row.EpisodeID==rec.EpisodeID
			if(samePat){
				var index=$('#ordGrid').datagrid("getRowIndex",row);
				$('#ordGrid').datagrid("checkRow",index);
			}
    		return samePat
    	});	
    	
    	selRecs.forEach(function(selRec){
        	$('#ordGrid').datagrid("selectRecord",selRec);
        });   
	}
	window.event.cancelBubble = true;
}

function orderNameCellStyler(value, row, index) {
    /*if (row.UrgentFlag == 'Y') {
        return 'background-color:#FFE3E2;';
    }*/
    if (row.backgroundColor) {
		return 'background-color:'+row.backgroundColor+";";
	}
}
function billStateCellStyler(value, row, index){
	if (value == $g('δ�Ʒ�')) {
        return 'color:red;';
    }
}
function operCellStyler(value, row, index) {
	if (row.IfOrdCanExec == "0"){
        return "";
	}
	if ((row.OrdStatDesc == $g("ִ��"))||((row.OrdStatDesc == $g("��ʵ"))&&(row.ExecStatus==$g("��ִ��")))) {
        return '<a href="javascript:void(0)" class="hisui-linkbutton" onclick="cancelOrdBtnClick(\'' + String(row.OeoriId) + '\')" data-options="iconCls:"icon-accept",plain:true">'+$g('����')+'</a>';
    }
    if (row.OrdStatDesc == $g("��ʵ")) {
        return '<a id="" href="javascript:void(0)" class="hisui-linkbutton" onclick="execOrdBtnClick(\'' + String(row.OeoriId) + '\')" data-options="iconCls:"icon-accept",plain:true">'+$g('ִ��')+'</a>';
    }
	
	
}
/**
* @description datagrid�������ϲ�ָ����Ԫ��
*/
function mergeCells(data) {
    var arr = [{ mergeFiled: "EpisodeID", premiseFiled: "EpisodeID" },	//�ϲ��е�field���鼰��Ӧǰ������filed��Ϊ����ֱ�����ݺϲ���
    { mergeFiled: "PatName", premiseFiled: "EpisodeID" },
    { mergeFiled: "RegNo", premiseFiled: "EpisodeID" },
    { mergeFiled: "PatSex", premiseFiled: "EpisodeID" },
    { mergeFiled: "PatAge", premiseFiled: "EpisodeID" },    
    { mergeFiled: "AdmTypeDesc", premiseFiled: "EpisodeID" }
    ];
    var dg = $("#ordGrid");	//Ҫ�ϲ���datagrid�еı��id
    var rowCount = dg.datagrid("getRows").length;
    var cellName;
    var span;
    var perValue = "";
    var curValue = "";
    var perCondition = "";
    var curCondition = "";
    var flag = true;
    var condiName = "";
    var length = arr.length - 1;
    for (i = length; i >= 0; i--) {
        cellName = arr[i].mergeFiled;
        condiName = arr[i].premiseFiled;
        if (condiName) {
            flag = false;
        }
        perValue = "";
        perCondition = "";
        span = 1;
        for (row = 0; row <= rowCount; row++) {
            if (row == rowCount) {
                curValue = "";
                curCondition = "";
            } else {
                curValue = dg.datagrid("getRows")[row][cellName];
				/* if(cellName=="ORGSTARTTIME"){//���⴦�����ʱ���ֶ�
					curValue =formatDate(dg.datagrid("getRows")[row][cellName],"");
				} */
                if (!flag) {
                    curCondition = dg.datagrid("getRows")[row][condiName];
                }
            }
            if (perValue == curValue && (flag || perCondition == curCondition)) {
                span += 1;
            } else {
                var index = row - span;
                dg.datagrid('mergeCells', {
                    index: index,
                    field: cellName,
                    rowspan: span,
                    colspan: null
                });
                span = 1;
                perValue = curValue;
                if (!flag) {
                    perCondition = curCondition;
                }
            }
        }
    }
    initPatComBoBox(data);
}
function initSearchUserLocByGridData(data){
	var oldVal=$("#searchUserLoc").combobox("getValues").join("^");
	var regNo = $('#regNoInput').val();
    var medNo = $('#medNoInput').val();
    var cardNo = $('#cardNoInput').val();
	if ((regNo!="")||(medNo!="")||(cardNo!="")) { //((data && data.rows.length)&&
		var arr = data.rows;
        var result = [], hash = {};
        for (var i = 0, elem; (elem = arr[i]) != null; i++) {
            if ((!hash[elem.ordDep])&&(elem.ordDep)) {
	            var selected=false;
	            if (("^"+elem.ordDepId+"^").indexOf("^"+oldVal+"^")>=0) selected=true;
                result.push({id:elem.ordDepId,text:elem.ordDep,"selected":selected});
                hash[elem.ordDep] = true;
            }
        }
        if (result.length){
	        $("#searchUserLoc").combobox("loadData",result);
	    }
	}else{
		initsearchUserLoc();
		setTimeout(function(){
			$("#searchUserLoc").combobox("setValues",oldVal==""?"":oldVal.split("^"));
		},500)
	}
}
/**
 *@description ��ʼ������������
 */
function initPatComBoBox(data) {
    if (data && data.rows) {
	    var TotalAmount=0;
        var arr = data.rows;
        var result = [], hash = {};
        for (var i = 0, elem; (elem = arr[i]) != null; i++) {
            if (!hash[elem.EpisodeID]) {
                result.push(elem);
                hash[elem.EpisodeID] = true;
            }
            TotalAmount += parseFloat(elem.ordTotalAmount);
        }
        $('#patComBoBox').combobox({
            data: result,
            valueField: 'EpisodeID',
            textField: 'PatName',
            defaultFilter: 4,
            onSelect: function(rec){  
           		//$('#regNoInput').val(rec.RegNo);
        		//ordGridReload();
        		var array=$('#ordGrid').datagrid("getData");
        		$('#ordGrid').datagrid("clearSelections")
	        	$('#ordGrid').datagrid("clearChecked") 
        		var selRecs=array.rows.filter(function(row){
	        		var samePat=row.EpisodeID==rec.EpisodeID
					if(samePat){
						var index=$('#ordGrid').datagrid("getRowIndex",row);
						$('#ordGrid').datagrid("checkRow",index);
					}
    				return samePat;
	        	});	
	        	
	        	selRecs.forEach(function(selRec){
		        	$('#ordGrid').datagrid("selectRecord",selRec)
		        });        		
        	}
        });
        $('#summeryInfo').html($g("����ѯ������")+":<span style='color: red;font-size:18px;margin:0 10px;vertical-align:bottom;'>" + result.length + $g("��")+"</span>,"+$g("ҽ��")+":<span style='color: red;font-size:18px;margin:0 10px;vertical-align:bottom;'>" + data.rows.length + $g("��")+"</span>,"+$g("�ܼ�")+":<span style='color: red;font-size:18px;margin:0 10px;vertical-align:bottom;'>"+TotalAmount.toFixed(2)+$g("Ԫ")+"</span>");
    }
}
/**
 * @description ��ʼ�����������б�
 */
function initPatTypeBox() {
    var arr = [{
        "id": 'O',
        "text": $g("����")
    }, {
        "id": 'I',
        "text": $g("סԺ")
    }, {
        "id": 'E',
        "text": $g("����"),
    }, {
        "id": 'H',
        "text": $g("���")
    }];
    $('#patTypeBox').combobox({
        data: arr,
        valueField: 'id',
        textField: 'text',
        defaultFilter: 4
    });
}
function initsearchExecedStatus(){
	$('#searchExecedStatus').combobox({
        data: [{
	        "id": 'false',
	        "text": $g("δִ��"),"selected":true
	    }, {
	        "id": 'true',
	        "text": $g("��ִ��")
	    }],
        valueField: 'id',
        textField: 'text',
        multiple:true,
        rowStyle:"checkbox"
    });
}
function initsearchBillStatus(){
	$HUI.combobox('#searchBillStatus', {
		panelHeight: 'auto',
		editable: false,
		valueField: 'value',
		textField: 'text',
		data: [{value: '', text: $g('ȫ��'),"selected":true},
		       {value: 'TB', text: $g('δ�Ʒ�')},
		       {value: 'TBO', text: $g('δ�շ�')},
		       {value: 'B', text: $g('�ѼƷ�')},
		       {value: 'P', text: $g('���շ�')},
		       {value: 'I', text: $g('���˷�')}//,
		       //{value: 'R', text: '���˷�'}
		]
	});
}
function initsearchUserLoc(){
	$.cm({
		ClassName:"web.DHCBillOtherLB",
		QueryName:"QryDept",
	   	desc:"",hospId:session['LOGON.HOSPID'],
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#searchUserLoc", {
				multiple:true,
				rowStyle:"checkbox",
				valueField: 'id',
				textField: 'text',
				data: GridData["rows"],
				filter: function(q, row){
					var pyjp = getPinyin(row["text"]).toLowerCase();
					return (row["text"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(pyjp.toUpperCase().indexOf(q.toUpperCase()) >= 0);
				}
		 });
	});
	/*$HUI.combobox('#searchUserLoc', {
		multiple:true,
		rowStyle:"checkbox",
		url: $URL + '?ClassName=web.DHCIPBillPatOrdFee&QueryName=FindDept&ResultSetType=array',
		mode: 'remote',
		valueField: 'id',
		textField: 'dept',
		onBeforeLoad: function (param) {
			param.desc = param.q;
			param.hospId = session['LOGON.HOSPID'];
		}
	});*/
}


function initsearchOrdType(){
	$.cm({
		ClassName:"Nur.HISUI.OrderExcute",
		QueryName:"FindOrdType",
	},function(Data){
		var cbox = $HUI.combobox("#searchOrdType", {
				multiple:true,
				rowStyle:"checkbox",
				valueField: 'id',
				textField: 'text',
				data: Data['rows'],
				filter: function(q, row){
					var pyjp = getPinyin(row["text"]).toLowerCase();
					return (row["text"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(pyjp.toUpperCase().indexOf(q.toUpperCase()) >= 0);
				}
		 });
	});
}


function initsearchArcim(){
	$HUI.combobox('#searchArcim', {
		panelHeight: 350,
		mode: 'remote',
		method: 'GET',
		delay: 300,
		valueField: 'ArcimRowID',
		textField: 'ArcimDesc',
		onBeforeLoad: function (param) {
			if ($.trim(param.q).length > 1) {
				$.extend($(this).combobox("options"), {url: $URL})
				param.ClassName = "BILL.COM.ItemMast";
				param.QueryName = "FindARCItmMast";
				param.ResultSetType = "array";
				var sessionStr = session['LOGON.USERID'] + "^" + "" + "^" + session['LOGON.CTLOCID'] + "^" + session['LOGON.HOSPID'];
				param.alias = param.q;
				param.sessionStr = sessionStr;
			}
		}
	});
}

function initsearchDoctor(){
	$HUI.combobox('#searchDoctor', {
		panelHeight: 350,
		mode: 'remote',
		method: 'GET',
		delay: 300,
		valueField: 'DocRowID',
		textField: 'DocDesc',
		onBeforeLoad: function (param) {
			if ($.trim(param.q).length > 1) {
				$.extend($(this).combobox("options"), {url: $URL})
				param.ClassName = "Nur.HISUI.OrderExcute";
				param.QueryName = "FindDoctor";
				param.ResultSetType = "array";
				param.Hospital = session['LOGON.HOSPID'];
				param.DocName = param.q;
			}
		}
	});
}

function initsearchPatAdmLoc(){
	$.cm({
		ClassName:"web.DHCExamPatList",
		QueryName:"ctloclookup",
	   	desc:"",hospid:session['LOGON.HOSPID'],
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#searchPatAdmLoc", {
				valueField: 'ctlocid',
				textField: 'ctloc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["ctloc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				}
		 });
	});
}
/**
 * @description ��ʼ����ѯ������
 */
function initCondition() {
    //console.log(new Date().Format("yyyy-MM-dd"))
    $('#startDate').datebox('setValue', formatDate(new Date()));
    $('#endDate').datebox('setValue', formatDate(new Date()));
    var userID = session['LOGON.USERID'];
    var hospID = session['LOGON.HOSPID'];
    //$('#cancelOrdsBtn').linkbutton('disable');
    $('#otherLoginLocs').combobox({
        url: $URL + '?1=1&ClassName=' + GV._CALSSNAME + '&QueryName=FindOtherLoginLocs&UserID=' + userID + '&HospID=' + hospID + '&ResultSetType=array',
        valueField: 'locID',
        textField: 'locDesc',
        multiple:true,
		rowStyle:"checkbox",
        defaultFilter:4,
        onLoadSuccess: function () { $('#otherLoginLocs').combobox('setValues', [session['LOGON.CTLOCID']]); }
    })
}
/**
 * @description ҽ���б�ˢ��
 */
function ordGridReload() {
    var regNo = $('#regNoInput').val();
    var medNo = $('#medNoInput').val();
    var cardNo = $('#cardNoInput').val();
    var applyNo = $('#applyNoInput').val();
	var diagnosis=$('#diagnosisInput').val();
    var admType = $('#patTypeBox').combobox('getValue');
     var otherLoginLocs = $('#otherLoginLocs').combobox('getValues').join("^");
    var startDate = $('#startDate').datebox('getValue');
    var endDate = $('#endDate').datebox('getValue');
    //var ifExced = $('#ifExced').checkbox('getValue');
    var searchExecedStatus=$("#searchExecedStatus").combobox("getValues").join("^");
    var searchBillStatus=$("#searchBillStatus").combobox("getText");
    if (searchBillStatus =="ȫ��") searchBillStatus="";
    var searchUserLoc=$("#searchUserLoc").combobox("getValues").join("^");
    var searchPatAdmLoc=$("#searchPatAdmLoc").combobox("getValue");
    var searchArcim=$("#searchArcim").combobox("getValue");
    var orderByOrdDate=$("#orderByOrdDate").checkbox("getValue")?"Y":"N";
    var searchDoctor=$("#searchDoctor").combobox("getValue");
    var searchOrdType=$("#searchOrdType").combobox("getValues").join("^");
    $('#ordGrid').datagrid('reload',
        {
            ClassName: GV._CALSSNAME,
            QueryName: "QueryOrder",
            ResultSetType: 'array',
            RegNo: regNo,
            MedNo: medNo,
            CardNo: cardNo,
			ApplyNo: applyNo,
			Diagnosis:diagnosis,
            CTLoc: otherLoginLocs,
            StartDate: startDate,
            EndDate: endDate,
            IfExced: searchExecedStatus,
            AdmType: admType,
            searchExecedStatus:searchExecedStatus,
            searchUserLoc:searchUserLoc,
            searchPatAdmLoc:searchPatAdmLoc,
            searchArcim:searchArcim,
            searchBillStatus:searchBillStatus,
            orderByOrdDate:orderByOrdDate,
            searchDoctor:searchDoctor,
            searchOrdType:searchOrdType,
        });
}
/**
 * @description ִ�а�ť����
 */
function cancelOrdsBtnClick() {
	var findNotCancelExecOrd=0;
    var selectArray = $('#ordGrid').datagrid('getChecked');
    var ordIdArray = selectArray.map(function (row) {
	    if ((row.OrdStatDesc == $g("ִ��"))||((row.OrdStatDesc == $g("��ʵ"))&&(row.ExecStatus==$g("��ִ��")))) {
        	return row.OeoriId;
        }else{
	        findNotCancelExecOrd=1;
	    }
    })
    if (findNotCancelExecOrd ==1){
	    $.messager.popover({ msg: "ҽ��δִ�л�ִ�м�¼δִ�в��ܳ���ִ�У�", type: 'alert', timeout: 2000 });
	    return false;
	}
    if(ordIdArray.length>0){
    	var ordIds = ordIdArray.join('^');
    	updateOrd(ordIds, "C");
    }else{
	    $.messager.popover({ msg: '��ѡ��ҽ��!', type: 'alert', timeout: 2000 });
	}
}
/**
 * @description ִ�а�ť����
 */
function execOrdsBtnClick() {
	var findNotExecOrd=0,findNotPayExecOrd=0;
    var selectArray = $('#ordGrid').datagrid('getChecked');
    var ordIdArray = selectArray.map(function (row) {
	    /*if (row.OrdStatDesc == $g("��ʵ")) {
       		return row.OeoriId;
        }else if((row.AdmType!="I")&&(row.BillState!=$g("���շ�"))&&(row.BillState!=$g("���"))&&(row.isPayAfterTreat!="Y")){
	        findNotPayExecOrd=1;
	    }else{
	        findNotExecOrd=1;
	    }*/
	    if((row.AdmType!="I")&&(row.BillState!=$g("���շ�"))&&(row.BillState!=$g("���"))&&(row.isPayAfterTreat!="Y")){
	        findNotPayExecOrd=1;
	    }
	    if (row.OrdStatDesc != $g("��ʵ")) {
		    findNotExecOrd=1;
		}
		return row.OeoriId;
    })
    if (findNotPayExecOrd ==1){
		$.messager.popover({ msg: "��סԺ�������Ƚ��Ѻ���ִ�У�", type: 'alert', timeout: 2000 });
		return false;
	}
    if (findNotExecOrd ==1){
	    $.messager.popover({ msg: "ҽ��״̬��'��ʵ'����ִ�У�", type: 'alert', timeout: 2000 });
	    return false;
	}
    if(ordIdArray.length>0){	    
    	var ordIds = ordIdArray.join('^');
    	GV.executeOrdIds=ordIds;
    	updateOrd(ordIds, "E");
    	//V8.5.2Ҫ����ִ��ʱ����ʱ��ѡ��ҳ��,��ҳ��ѡ���ʱ���Ӱ��Ʒ��˵�ʱ��,�������θù���
    	//showExecuteDialog();
    }else{
	    $.messager.popover({ msg: '��ѡ��ҽ��!', type: 'alert', timeout: 2000 });
	}
}
function GetCurTime(){
   function p(s) {
	   return s < 10 ? '0' + s: s;
   }
   var myDate = new Date();
   var h=myDate.getHours();       //��ȡ��ǰСʱ��(0-23)
   var m=myDate.getMinutes();     //��ȡ��ǰ������(0-59)
   var s=myDate.getSeconds();  
   var nowTime=p(h)+':'+p(m);
   return nowTime;
}
/**
 * @description ���ú�ִ̨�з���
 * @param {*} orderStatus 
 */
function updateOrd(ordIds, orderStatus, executeDate, executeTime) {
    var userID = session['LOGON.USERID'];
    var userDeptId= $('#otherLoginLocs').combobox('getValue') || session['LOGON.CTLOCID'];
    $cm({
        ClassName: GV._CALSSNAME,
        MethodName: "UpdateOrd",
        OrdIds: ordIds,
        UserId: userID,
        OrderStatus: orderStatus,
        UserDeptId:userDeptId,
        executeDate:executeDate,
        executeTime:executeTime
    }, function (jsonData) {
        if (jsonData.success == '0') {
	        $('#ordGrid').datagrid("clearSelections")
	        $('#ordGrid').datagrid("clearChecked") 
	        ordGridReload();       		
            if (orderStatus == 'E') { $.messager.popover({ msg: 'ִ�гɹ�!', type: 'success', timeout: 2000 }); }
            if (orderStatus == 'C') { $.messager.popover({ msg: '�����ɹ�!', type: 'success', timeout: 2000 }); }
            GV.executeOrdIds="";$HUI.dialog('#executeDialog').close();
        }
        else {
	        var errMsg="ִ��ʧ��:<br/>"
	        jsonData.errList.forEach(function(errOrd){
		        if(errOrd.ifCanUpdate!=""){
		        	errMsg+=errOrd.ArcimDesc+":"+errOrd.ifCanUpdate+"<br/>";
		        }
		        else{
			        errMsg+=errOrd.ArcimDesc+"����ʧ��!<br/>"
			    }
		    });
            $.messager.popover({ msg: errMsg, type: 'alert', timeout: 2000 });
            ordGridReload();            
    		$('#ordGrid').datagrid('clearSelections').datagrid("clearChecked");
        }
    })
}

/**
 * @description ����ִ�а�ť����
 */
function cancelOrdBtnClick(ordID) {
    updateOrd(ordID, "C","","");
}
/**
 * @description ִ��ִ�а�ť����
 */
function execOrdBtnClick(ordID) {
    //updateOrd(ordID, "E");
    GV.executeOrdIds=ordID;
    var rows=$('#ordGrid').datagrid("getRows");
    var index=$('#ordGrid').datagrid("getRowIndex",ordID);
    if((rows[index].AdmType!="I")&&(rows[index].BillState!="���շ�")&&(rows[index].BillState!="���")&&(rows[index].isPayAfterTreat!="Y")){
        $.messager.popover({ msg: "��סԺ�������Ƚ��Ѻ���ִ�У�", type: 'alert', timeout: 2000 });
		return false;
    }
    //V8.5.2Ҫ����ִ��ʱ����ʱ��ѡ��ҳ��,��ҳ��ѡ���ʱ���Ӱ��Ʒ��˵�ʱ��,�������θù���
	//showExecuteDialog();
	updateOrd(GV.executeOrdIds, "E", "", "");
}
/**
 * @description ������ť����
 */
function readCardBtnClick() {
    function setCardNo(myrtn) {
	    var myary=myrtn.split("^");
		var rtn=myary[0];
		switch (rtn){
			case "0": 
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1];
	    		$("#cardNoInput").val(CardNo);
	    		ordGridReload();
				break;
			case "-200": 
				$.messager.alert("��ʾ","����Ч!","info",function(){
					$("#CardTypeNew,#PatNo").val("");
					$("#CardNo").focus();
				});
				break;
			case "-201": 
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1];
	    		$("#cardNoInput").val(CardNo);
	    		ordGridReload();
				break;
			default:
				break;
		}
    }
    DHCACC_GetAccInfo7(setCardNo);
}

function checkCardNo(){
    var cardNo=$("#cardNoInput").val();
    if (cardNo=="") return false;
    var myrtn=DHCACC_GetAccInfo("",cardNo,"","",cardNoKeyDownCallBack);
}

function cardNoKeyDownCallBack(myrtn,errMsg){
   	if (typeof errMsg == "undefined") errMsg="����Ч";
	$(".newclsInvalid").removeClass('newclsInvalid');
	var myary=myrtn.split("^");
    var rtn=myary[0];
	switch (rtn){
		case "0": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#cardNoInput").focus().val(CardNo);
			ordGridReload();	
			break;
		case "-200": //����Ч
			$.messager.popover({ msg: errMsg, type: 'alert', timeout: 2000 });
			return false;
			break;
		case "-201": //����Ч���ʻ�
			$.messager.popover({ msg: errMsg, type: 'alert', timeout: 2000 });
			break;
		default:
	}
}
function IsValidTime(time){
   if (time.split(":").length==3){
	   var TIME_FORMAT=/^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/;
   }else if(time.split(":").length==2){
	   var TIME_FORMAT=/^(0\d{1}|1\d{1}|2[0-3]):([0-5]\d{1})$/;  
   }else{
	   return false;
   }
   if(!TIME_FORMAT.test(time)) return false;
   return true;
}
function showExecuteDialog(){
	$('#executeDialog').dialog({ 
    	iconCls:'icon-w-edit',   
	    cache: false,    
	    modal: true,
	    buttons:[{
			text:'ִ��',
			handler:function(){
				var executeDate=$('#executeDate').datebox('getValue');
			   if (executeDate==""){
				   $.messager.alert("��ʾ","���ڲ���Ϊ��!","info",function(){
					   $('#executeDate').next('span').find('input').focus();
				   });
				   return false;
			   }
			   if(!DATE_FORMAT.test(executeDate)){
				   $.messager.alert("��ʾ","���ڸ�ʽ����ȷ!");
				   return false;
			   }
			   var executeTime=$('#executeTime').timespinner('getValue');//$('#SeeOrdTime').combobox('getText');
			   if (executeTime==""){
				   $.messager.alert("��ʾ","ʱ�䲻��Ϊ��!");
				   $('#SeeOrdTime').next('span').find('input').focus();
				   return false;
			   }
			   if (!IsValidTime(executeTime)){
				   $.messager.alert("��ʾ","ʱ���ʽ����ȷ! ʱ:��:��,��11:05");
				   return false;
			   }
			   updateOrd(GV.executeOrdIds, "E", executeDate, executeTime);
			}
		},{
			text:'�ر�',
			handler:function(){GV.executeOrdIds="";$HUI.dialog('#executeDialog').close();}
		}]
	}).dialog('open'); 
	if (execSetting.execDefaultDT === 1){
		var oeoreID=GV.executeOrdIds.split("^")[0];
		if (oeoreID.split("||").length==2) oeoreID=oeoreID+"||1";
		if (GV.executeOrdIds.split("^").length>1){
			$("#executeDate").datebox('disable');
			$("#executeTime").timespinner('disable');
		}else{
			var ordCreateDataTime = $m({ClassName: "Nur.NIS.Service.OrderExcute.OrderInfo",MethodName: "GetCreateDateTime",oeoriId:oeoreID},false);
			var opt = $("#executeDate").datebox('options');
			opt.minDate = ordCreateDataTime.split(" ")[0];
		}
		var data = $m({ClassName: "Nur.NIS.Service.OrderExcute.OrderInfo",MethodName: "GetSttDateTime",oeoreId:oeoreID},false);
		var handleDate = data.split(" ")[0];
		var handleTime = data.split(" ")[1];
	}else{
		var data = $cm({ClassName: "Nur.NIS.Common.SystemConfig",MethodName: "GetCurrentDateTime",timeFormat: "1"},false)
		var handleDate = data.date;
		var handleTime = data.time;
	}
	$('#executeDate').datebox('setValue', handleDate); 
	$("#executeTime").timespinner('setValue',handleTime);
	if (execSetting.editeDefaultDT === "N"){
		$("#handleDate").datebox('disable');
		$("#handleTime").timespinner('disable');
	}
	$("#executeUser").val(session['LOGON.USERNAME']);
}
if (dtseparator=="/"){
	//DD/MM/YYYY
    var DATE_FORMAT= new RegExp("(((0[1-9]|[12][0-9]|3[01])/((0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)/(0[469]|11))|(0[1-9]|[1][0-9]|2[0-8])/(02))/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(29/02/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))");
}else if(dtseparator=="-"){
	//YYYY-MM-DD
	var DATE_FORMAT= new RegExp("(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)");
}
function ExportPrintCommon(ResultSetTypeDo){
	var regNo = $('#regNoInput').val();
    var medNo = $('#medNoInput').val();
    var cardNo = $('#cardNoInput').val();
    var admType = $('#patTypeBox').combobox('getValue');
    var otherLoginLocs = $('#otherLoginLocs').combobox('getValue');
    var startDate = $('#startDate').datebox('getValue');
    var endDate = $('#endDate').datebox('getValue');
    //var ifExced = $('#ifExced').checkbox('getValue');
    var searchExecedStatus=$("#searchExecedStatus").combobox("getValues").join("^");
    var searchBillStatus=$("#searchBillStatus").combobox("getText");
    if (searchBillStatus =="ȫ��") searchBillStatus="";
    var searchUserLoc=$("#searchUserLoc").combobox("getValues").join("^");
    var searchPatAdmLoc=$("#searchPatAdmLoc").combobox("getValue");
    var searchArcim=$("#searchArcim").combobox("getValue");
    var orderByOrdDate=$("#orderByOrdDate").checkbox("getValue")?"Y":"N";
    var searchDoctor=$("#searchDoctor").combobox("getValue");
	var searchOrdType=$("#searchOrdType").combobox("getValues").join("^");
     $.cm({
		 localDir:ResultSetTypeDo=="Export"?"Self":"",
		 ResultSetTypeDo:ResultSetTypeDo,
	     ExcelName:startDate+"��"+endDate+$('#otherLoginLocs').combobox('getText')+"ҽ��ִ�е�",
	     //localDir:"",
	     PageName:"DHCNurseOrderExecute",
	     ResultSetType:"ExcelPlugin",
		 //ResultSetTypeDo:"Print",
	     ClassName : GV._CALSSNAME,
	     QueryName : "QueryOrder",
	     RegNo: regNo,
         MedNo: medNo,
         CardNo: cardNo,
         CTLoc: otherLoginLocs,
         StartDate: startDate,
         EndDate: endDate,
         IfExced: searchExecedStatus,
         AdmType: admType,
         searchExecedStatus:searchExecedStatus,
         searchUserLoc:searchUserLoc,
         searchPatAdmLoc:searchPatAdmLoc,
         searchArcim:searchArcim,
         searchBillStatus:searchBillStatus,
         orderByOrdDate:orderByOrdDate,
         searchDoctor:searchDoctor,
         searchOrdType:searchOrdType,
	     rows:9999999
	 },false);
}
/**
 * @description �շ�������lxf
 */
function ShowOrderDescDetail(that){
	var index=$("#ordGrid").datagrid('getRowIndex',that.id);
	if(isNaN(index)) return;
	var row=$("#ordGrid").datagrid("getRows")[index];
	var tabId="ordTarGrid_"+index;
	var tarList=getTarList(row);
	var MaxHeight=tarList.total*34+35+10,placement="auto";
	if (MaxHeight>360) MaxHeight=360;
	$(that).webuiPopover({
		title:'�շ���',
		content:'<table id='+tabId+'></table>', //content,
		trigger:'hover',
		placement:placement,
		//style:'table',
		height:MaxHeight,
		width:608,
		cache:false,
		onShow:function(){
			loadOrdTarList(tarList,index);
		}
	});
	$(that).webuiPopover('show');
}
function getTarList(row){
	var tarList = $cm({
		ClassName: "Nur.HISUI.OrderExcute",
		QueryName: "FindTarList",
		arcimrowid: row["arcimID"],
		oeori:row["OeoriId"],
		hospid:session['LOGON.HOSPID']
	},false)
	return tarList;
}
function loadOrdTarList(tarList,index){
	//var row=$("#ordGrid").datagrid("getRows")[index];
	var Columns=[[
		{field:'tarDesc',title:'����',width:250,
			styler: function(value,row,index){
				if (row.tarQty=="" && row.tarSum==""){
					return 'font-weight:bold;';
				}else if(row.tarQty=="" && row.tarSum!=""){
					return 'font-weight:bold;color:red;';
				}
			}
		},  
		{field:'tarPrice',title:'����',width:80,align:'right'}, 
		{field:'tarQty',title:'����',width:80}, 
		{field:'tarSum',title:'�ܼ�(Ԫ)',width:80,align:'right',
			styler: function(value,row,index){
				if(row.tarQty=="" && row.tarSum!=""){
					return 'font-weight:bold;color:red;';
				}
			}
		},
		{field:'tarDiscSum',title:'�ۺ��(Ԫ)',width:80,align:'right',
			styler: function(value,row,index){
				if(row.tarQty=="" && row.tarSum!=""){
					return 'font-weight:bold;color:red;';
				}
			}
		}
	]]
	 
	$HUI.datagrid('#ordTarGrid_'+index,{
	    data:tarList,
	    headerCls:'panel-header-gray',
	    idField:'Index',
	    fit : true,
	    width:600,
	    height:380,
	    border: false,
	    columns:Columns
	});
}
