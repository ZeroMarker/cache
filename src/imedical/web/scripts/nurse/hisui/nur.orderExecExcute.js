/**
 * @author SongChao
 * @version 20181017
 * @description ҽ��ִ��(ִ��ҽ��)
 * @name nur.orderexcute.js
 */
var ordExecFlag=1; //ҽ��ִ�б�ʶ
var exeBtnInfo; //��ť��Ϣ
var ordExecExecuteFlag="Y" //ִ�м�¼ִ��ҳ��ִ�б�־
var GV = {
    _CALSSNAME: "Nur.HISUI.OrderExecExcute",
    episodeID: "",
    executeOrdIds:""
};
var frm=dhcsys_getmenuform();

var init = function () {
    initPageDom();
    initBindEvent();
    // ��ʼ��HISUI����
    initEditWindow();
    setFixEpisodeIDDefault();    
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
    $('#orderPrintBtn').click(orderPrintClick);
	$("#switchBtn").click(function () {
        $(".current").removeClass("current");
        $(".current_lite").removeClass("current_lite");
        if ($(".ant-switch-checked").length) {
	        $('#otherLoginLocs').combobox('setValues',"");
	        if (fixedRecLocId) $('#otherLoginLocs').combobox('setValues',[fixedRecLocId]);
	        $('#searchUserLoc').combobox('setValues',session['LOGON.CTLOCID']);
            $("#switchBtn").removeClass("ant-switch-checked");
            $($(".switch label")[0]).addClass(HISUIStyleCode=="blue"?"current":"current_lite");
        } else {
	        $('#searchUserLoc').combobox('setValues',"");
	        if ($('#otherLoginLocs').combobox('getValues').length==0){
		        $('#otherLoginLocs').combobox('setValues', [session['LOGON.CTLOCID']]);
		    }
            $("#switchBtn").addClass("ant-switch-checked");
            $($(".switch label")[1]).addClass(HISUIStyleCode=="blue"?"current":"current_lite");
        }
        initsearchUserLoc();
        ordGridReload();
    });
}
function clearBtnClick(){
	//ordGridReload();	
	$('#regNoInput,#medNoInput,#cardNoInput').val('');
	$('#patTypeBox').combobox('setValue','');
	$('#searchBillStatus,#searchPatAdmLoc,#searchArcim,#patComBoBox,#searchDoctor').combobox('setValue','').combobox('setText','');
	$('#searchBillStatus').combobox('setText',$g('ȫ��'));
	
	$("#searchExecedStatus").combobox("setValues",['false']);
	
	$('#startDate').datebox('setValue', formatDate(new Date()));
    $('#endDate').datebox('setValue', formatDate(new Date()));
    var orderByOrdDate=$("#orderByOrdDate").checkbox("getValue")?"Y":"N";
    if ($(".ant-switch-checked").length){
	    $('#otherLoginLocs').combobox('setValues',[session['LOGON.CTLOCID']]);
	    $('#searchUserLoc').combobox("setValues","");
	}else{
		$('#searchUserLoc').combobox("setValues",[session['LOGON.CTLOCID']]);
		$('#otherLoginLocs').combobox('setValues',"");
	}
    if (orderByOrdDate=="Y"){
    	$("#orderByOrdDate").checkbox("setValue",false);
    }else{
	    ordGridReload();
	}
	setFixEpisodeIDDefault();
}

/*----------------------------------------------------------------------------------*/
/**
 * @description ��ʼ��ҽ���б�
 */
function initOrdGrid() {
    var regNo = $('#regNoInput').val();
    var medNo = $('#medNoInput').val();
    var cardNo = $('#cardNoInput').val();
    var admType = $('#patTypeBox').combobox('getValue');
    var otherLoginLocs = $('#otherLoginLocs').combobox('getValues').join("^");
    var startDate = $('#startDate').datebox('getValue');
    var endDate = $('#endDate').datebox('getValue');
    //var ifExced = $('#ifExced').checkbox('getValue');
    var searchExecedStatus=$("#searchExecedStatus").combobox("getValues").join("^");
    var searchBillStatus=$("#searchBillStatus").combobox("getText");
    if (searchBillStatus ==$g("ȫ��")) searchBillStatus="";
    var searchUserLoc=$("#searchUserLoc").combobox("getValues").join("^");
    var searchPatAdmLoc=$("#searchPatAdmLoc").combobox("getValue");
    var searchArcim=$("#searchArcim").combobox("getValue");
    var searchDoctor=$("#searchDoctor").combobox("getValue");
    var orderByOrdDate=$("#orderByOrdDate").checkbox("getValue")?"Y":"N";
    if ($(".ant-switch-checked").length){
	    if (!otherLoginLocs) otherLoginLocs=session['LOGON.CTLOCID'];
	}else{
		if (!searchUserLoc) searchUserLoc=session['LOGON.CTLOCID'];
	}
	if (fixedRecLocId) otherLoginLocs=fixedRecLocId;
	if (fixedDocId) searchDoctor=fixedDocId;
	if (fixedEpisodeID) admType=fixAdmType;
    $('#ordGrid').datagrid({
        url: $URL,
        queryParams: {
            ClassName: GV._CALSSNAME,
            QueryName: "QueryOrder",
            ResultSetType: 'array',
            RegNo: regNo,
            MedNo: medNo,
            CardNo: cardNo,
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
            searchType:$(".ant-switch-checked").length?"RecLoc":"OrdDept",
            fixedEpisodeID:fixedEpisodeID
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
            { field: 'oeoreId', title: 'ִ�м�¼ID', width: 10 }, // 
        ]],
        frozenColumns: [[
            { field: 'EpisodeID', title: '�����', width: 30, hidden: true }, //
            { field: 'PatName', title: '����', width: 150 },
            { field: 'RegNo', title: '�ǼǺ�', width: 110 },
            { field: 'PatSex', title: '�Ա�', width: 50 },
            { field: 'PatAge', title: '����', width: 50 },
            { field: 'AdmTypeDesc', title: '��������', width: 80,
            	formatter: function(value,row,index){
	            	return $g(value);
            	}
            },            
            { field: 'checkCol', title: 'ѡ��', checkbox: true, width: 30 },
            { field: 'ArcimDesc', title: 'ҽ������', width: 200, styler:orderNameCellStyler,
            	formatter:function(value,row,index){
	            	if (row.UrgentFlag=="Y") {
		            	value="<font color=red>("+$g("�Ӽ�")+")</font>"+row.ArcimDesc.replace("(�Ӽ�)","");
		            }
	            	//value = '<span id=' + row["OeoriId"] + ' onmouseover="ShowOrderDescDetail(this)">'+value+'</span>';
					return value;	
	            }
            },
            { field: 'Operate', title: '����', width: 50, formatter: operCellStyler },]],
        idField: 'oeoreId',
        onLoadSuccess: function(data){
	        initPatComBoBox(data);
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
	if (row.IfCanExec==0){
		return "";
	}
	if (row.ExecStatus==$g("��ִ��")) {
        return '<a href="javascript:void(0)" class="hisui-linkbutton" onclick="cancelOrdBtnClick(\'' + String(row.oeoreId) + '\')" data-options="iconCls:"icon-accept",plain:true">'+$g("����")+'</a>';
    }else{
	    return '<a id="" href="javascript:void(0)" class="hisui-linkbutton" onclick="execOrdBtnClick(\'' + String(row.oeoreId) + '\')" data-options="iconCls:"icon-accept",plain:true">'+$g("ִ��")+'</a>';
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
	if ($(".ant-switch-checked").length){
		//�����տ��Ҳ�ѯ
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
					},
					onLoadSuccess: function () {
						$('#searchUserLoc').combobox('setValues', "");
						
					}
			 });
		});
    }else{
	    //���������Ҳ�ѯ
	    $.cm({
			ClassName:"Nur.HISUI.OrderExcute",
			QueryName:"FindOtherLoginLocs",
			UserID:session['LOGON.USERID'],
		   	HospID:session['LOGON.HOSPID'],
			rows:99999
		},function(GridData){
			$HUI.combobox("#searchUserLoc", {
					multiple:true,
					rowStyle:"checkbox",
					valueField: 'id',
					textField: 'text',
					data: JSON.parse(JSON.stringify(GridData["rows"]).replace(/locID/g, 'id').replace(/locDesc/g, 'text')),
					onLoadSuccess: function () {
				        $('#searchUserLoc').combobox('setValues', [session['LOGON.CTLOCID']]);
				    }
			 });
		})
	}
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
		disabled:fixedDocId?true:false,
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
	if (fixedDocId){
		$("#searchDoctor").combobox("loadData",[{"DocRowID":fixedDocId,"DocDesc":fixedDocName}]);
		$("#searchDoctor").combobox("setValue",fixedDocId);
	}
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
	$($(".switch label")[0]).addClass(HISUIStyleCode=="blue"?"current":"current_lite");
    //console.log(new Date().Format("yyyy-MM-dd"))
    $('#startDate').datebox('setValue', formatDate(new Date()));
    $('#endDate').datebox('setValue', formatDate(new Date()));
    var userID = session['LOGON.USERID'];
    var hospID = session['LOGON.HOSPID'];
    //$('#cancelOrdsBtn').linkbutton('disable');
    $('#otherLoginLocs').combobox({
	    multiple:true,
		rowStyle:"checkbox",
        url: $URL + '?1=1&ClassName=Nur.HISUI.OrderExcute&QueryName=FindOtherLoginLocs&UserID=' + userID + '&HospID=' + hospID + '&ResultSetType=array',
        valueField: 'locID',
        textField: 'locDesc',
		disabled:fixedRecLocId?true:false,
        defaultFilter:4,
        onLoadSuccess: function () { 
        	if ($(".ant-switch-checked").length){
				//�����տ��Ҳ�ѯ
				$('#otherLoginLocs').combobox('setValues', [session['LOGON.CTLOCID']]);
			}
			if (fixedRecLocId){
				$('#otherLoginLocs').combobox('setValues', [fixedRecLocId]);
			}
        }
    })
}
/**
 * @description ҽ���б�ˢ��
 */
function ordGridReload() {
    var regNo = $('#regNoInput').val();
    var medNo = $('#medNoInput').val();
    var cardNo = $('#cardNoInput').val();
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
    if ($(".ant-switch-checked").length){
	    //�����տ��Ҳ�ѯ
	    if (!otherLoginLocs) {
		    $.messager.popover({ msg: "�����տ��Ҳ�ѯʱ���տ��Ҳ���Ϊ��!", type: 'alert', timeout: 2000 });
	    	return false;
		}
	}else{
		//���������Ҳ�ѯ
		if (!searchUserLoc) {
			$.messager.popover({ msg: "���������Ҳ�ѯʱ�������Ҳ���Ϊ��!", type: 'alert', timeout: 2000 });
	    	return false;
		}
	}
	if (fixedRecLocId) otherLoginLocs=fixedRecLocId;
	if (fixedDocId) searchDoctor=fixedDocId;
	if (fixedEpisodeID) admType=fixAdmType;
    $('#ordGrid').datagrid('reload',
        {
            ClassName: GV._CALSSNAME,
            QueryName: "QueryOrder",
            ResultSetType: 'array',
            RegNo: regNo,
            MedNo: medNo,
            CardNo: cardNo,
            CTLoc: otherLoginLocs,
            StartDate: startDate,
            EndDate: endDate,
            IfExced: searchExecedStatus,
            AdmType: admType,
            //searchExecedStatus:searchExecedStatus,
            searchUserLoc:searchUserLoc,
            searchPatAdmLoc:searchPatAdmLoc,
            searchArcim:searchArcim,
            searchBillStatus:searchBillStatus,
            orderByOrdDate:orderByOrdDate,
            searchDoctor:searchDoctor,
            searchType:$(".ant-switch-checked").length?"RecLoc":"OrdDept",
            fixedEpisodeID:fixedEpisodeID
        });
}
/**
 * @description ȫ�ֳ���ִ�а�ť����
 */
function cancelOrdsBtnClick() {
	var findNotCancelExecOrd=0;
    var selectArray = $('#ordGrid').datagrid('getChecked');
    var oeoreIdAry = selectArray.map(function (row) {
	    if (row.ExecStatus==$g("��ִ��")) {
        	return row.oeoreId;
        }else{
	        findNotCancelExecOrd=1;
	    }
    })
    if (findNotCancelExecOrd ==1){
	    $.messager.popover({ msg: "ִ�м�¼δִ�в��ܳ���ִ�У�", type: 'alert', timeout: 2000 });
	    return false;
	}
    if(oeoreIdAry.length>0){
    	var oeoreIds = oeoreIdAry.join('^');
    	updateOeoriStatus(oeoreIds, "C");
    }else{
	    $.messager.popover({ msg: '��ѡ��ִ�м�¼!', type: 'alert', timeout: 2000 });
	}
}
/**
 * @description ȫ��ִ�а�ť����
 */
function execOrdsBtnClick() {
	var findNotExecOrd=0,findNotPayExecOrd=0;
    var selectArray = $('#ordGrid').datagrid('getChecked');
    var oeoreIdAry = selectArray.map(function (row) {
	    if ((row.IfCanExec==1)&&((row.ExecStatus=="")||(row.ExecStatus == $g("δִ��"))||(row.ExecStatus == $g("����ִ��")))) {
       		return row.oeoreId;
        }else if((row.AdmType!="I")&&(row.BillState!=$g("���շ�"))&&(row.BillState!=$g("���"))&&(row.isPayAfterTreat!="Y")){
	        findNotPayExecOrd=1;
	    }else{
	        findNotExecOrd=1;
	    }
    })
    if (findNotPayExecOrd ==1){
		$.messager.popover({ msg: "��סԺ�������Ƚ��Ѻ���ִ�У�", type: 'alert', timeout: 2000 });
		return false;
	}
    if (findNotExecOrd ==1){
	    $.messager.popover({ msg: "��ִ�е�ִ�м�¼�����ٴ�ִ�У�", type: 'alert', timeout: 2000 });
	    return false;
	}
    if(oeoreIdAry.length>0){	    
    	var oeoreIds = oeoreIdAry.join('^');
    	GV.executeOrdIds=oeoreIds;
    	updateOeoriStatus(oeoreIds, "E");
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
function caSignVerify(functionName,oeoreIds) {
    var desc, windowModel, orderIDObj, queryOrder;
    // ��ȡbutton��ť��Ϣ��ҽ��������Ϣ
    if (!exeBtnInfo) {
        var btnData=$cm({
          ClassName: 'Nur.NIS.Service.OrderExcute.SheetConfig',
          QueryName: 'GetAllExecuteButton',
          rows: 999999999999999,
          hospId: session["LOGON.HOSPID"]
        }, false);
        exeBtnInfo={};
        btnData.rows.map(function(e) {
            exeBtnInfo[e.Func]=e;
        })
    }
    if (exeBtnInfo[functionName]) {
        var e=exeBtnInfo[functionName];
        desc=e.Name;
        if ("Y"==e.ShowWin) {
            windowModel="W";
            if ("Y"==e.Sign) {
                windowModel="S";
            }
        } else {
            windowModel="N";
        }
    }
    if (windowModel=="S") {
	    for (var i=0;i<oeoreIds.split("^").length;i++){
	    	// �ж�ҽ���Ƿ���Ҫ˫ǩ
            var dbSignFlag=$cm({
              ClassName: 'Nur.NIS.Service.OrderExcute.QueryOrder',
              MethodName: 'IsDoubleSignOrderGroup',
              dataType: "text",
              oeordID: oeoreIds.split("^")[i].split("||")[0],
              oeoriSub: oeoreIds.split("^")[i].split("||")[1],
              hospID: session["LOGON.HOSPID"]
            }, false);
            if ("Y"==dbSignFlag) windowModel="D";break;
		}
	}
    var orderIDObj={};
    if ('excuteOrder'==functionName) {
        orderIDObj['execOrderList']=oeoreIds.split("^");
        orderIDObj['execDisOrderList']=[];
    } else if ('cancelOrder'==functionName) {
        orderIDObj['cancelExecOrderList']=oeoreIds.split("^");
    }
    handleOrderCom(functionName, desc, windowModel, "false",orderIDObj, UpdateOrdGroupChunks, "NUR");
}
function UpdateOrdGroupChunks(){
	$('#ordGrid').datagrid("clearSelections");
    $('#ordGrid').datagrid("clearChecked") ;
    ordGridReload(); 
}
/**
 * @description ���ú�ִ̨�з���
 * @param {*} orderStatus 
 */
function updateOeoriStatus(oeoreIds, orderStatus, executeDate, executeTime) {
	if (orderStatus=="E"){
		caSignVerify("excuteOrder",oeoreIds);
	}else{
		caSignVerify("cancelOrder",oeoreIds);
	}
	/*
    var userID = session['LOGON.USERID'];
    var userDeptId= $('#otherLoginLocs').combobox('getValue') || session['LOGON.CTLOCID'];
    $cm({
        ClassName: GV._CALSSNAME,
        MethodName: "handleOrderChunks",
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
    })*/
}
/**
 * @description ��ִ�а�ť����
 */
function cancelOrdBtnClick(oeoreId) {
    updateOeoriStatus(oeoreId, "C","","");
}
/**
 * @description ������ִ�а�ť����
 */
function execOrdBtnClick(oeoreId) {
    GV.executeOrdIds=oeoreId;
    var rows=$('#ordGrid').datagrid("getRows");
    var index=$('#ordGrid').datagrid("getRowIndex",oeoreId);
    if((rows[index].AdmType!="I")&&(rows[index].BillState!=$g("���շ�"))&&(rows[index].BillState!=$g("���"))&&(rows[index].isPayAfterTreat!="Y")){
        $.messager.popover({ msg: "��סԺ�������Ƚ��Ѻ���ִ�У�", type: 'alert', timeout: 2000 });
		return false;
    }
	updateOeoriStatus(GV.executeOrdIds, "E", "", "");
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
function orderPrintClick(){
	var regNo = $('#regNoInput').val();
    var medNo = $('#medNoInput').val();
    var cardNo = $('#cardNoInput').val();
    var admType = $('#patTypeBox').combobox('getValue');
    var otherLoginLocs = $('#otherLoginLocs').combobox('getValues').join("^");
    var startDate = $('#startDate').datebox('getValue');
    var endDate = $('#endDate').datebox('getValue');
    //var ifExced = $('#ifExced').checkbox('getValue');
    var searchExecedStatus=$("#searchExecedStatus").combobox("getValues").join("^");
    var searchBillStatus=$("#searchBillStatus").combobox("getText");
    if (searchBillStatus ==$g("ȫ��")) searchBillStatus="";
    var searchUserLoc=$("#searchUserLoc").combobox("getValues").join("^");
    var searchPatAdmLoc=$("#searchPatAdmLoc").combobox("getValue");
    var searchArcim=$("#searchArcim").combobox("getValue");
    var orderByOrdDate=$("#orderByOrdDate").checkbox("getValue")?"Y":"N";
    var searchDoctor=$("#searchDoctor").combobox("getValue");
	if (fixedRecLocId) otherLoginLocs=fixedRecLocId;
	if (fixedDocId) searchDoctor=fixedDocId;
	if (fixedEpisodeID) admType=fixAdmType;
	 $.cm({
	     ExcelName:startDate+"��"+endDate+$('#otherLoginLocs').combobox('getText')+"ҽ��ִ�е�",
	     localDir:"",
	     PageName:"DHCNurseOrderExecute",
	     ResultSetType:"ExcelPlugin",
		 ResultSetTypeDo:"Print",
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
         //searchExecedStatus:searchExecedStatus,
         searchUserLoc:searchUserLoc,
         searchPatAdmLoc:searchPatAdmLoc,
         searchArcim:searchArcim,
         searchBillStatus:searchBillStatus,
         orderByOrdDate:orderByOrdDate,
         searchDoctor:searchDoctor,
         searchType:$(".ant-switch-checked").length?"RecLoc":"OrdDept",
         fixedEpisodeID:fixedEpisodeID,
	     rows:9999999
	 },false);
}
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
function setFixEpisodeIDDefault(){
    if (fixedEpisodeID){
	    $("#readCardBtn").linkbutton("disable");
	    $("#regNoInput").val(fixedRegNo);
	    $("#medNoInput").val(fixMedNo);
	    $("#regNoInput,#medNoInput,#cardNoInput").prop("disabled",true);
	    $("#patTypeBox").combobox("setValue",fixAdmType).combobox("disable");
	}
	if (fixedDocId){
		$("#searchDoctor").combobox("loadData",[{"DocRowID":fixedDocId,"DocDesc":fixedDocName}]);
		$("#searchDoctor").combobox("setValue",fixedDocId);
	}
	if (fixedRecLocId){
		$('#otherLoginLocs').combobox('setValues', [fixedRecLocId]);
	}
}