
$(function () {
    $('#patLst').panel('resize', {
        width: (screen.availWidth) * 0.382
    });
    $('body').layout('resize');
	
	var dataTemp = [];
    initPatTable(dataTemp);
    $('#patientListData').datagrid('loadData', {total:0,rows:[]});

    $('.easyui-searchbox').searchbox({
        searcher: function (value, name) {
	        /*var CardTypeValue = $(this).combobox('getValue');
	        if (CardTypeValue != "") {	//扫电子健康码（动态码）
				var CardTypeArr = CardTypeValue.split("^");
				var CardTypeRowId = CardTypeArr[0];
				if (CardTypeRowId == "20")
				{
					var CardNo = $("#cardNoSearch").searchbox('getValue');	//动态码值
					var Rtn=DHCACC_DisabledCardType("CardType",CardNo);
					if (Rtn == "")
					{
						alert("卡无效!");
						return;
					}
					var myrtn=DHCACC_GetAccInfo(CardTypeRowId,CardNo,"","PatInfo");
					var myary=myrtn.split("^");
			        var rtn=myary[0];
			        switch (rtn){
			            case "0": //卡有效有帐户
			                var CardNo=myary[1];
			                $("#cardNoSearch").searchbox('setValue', CardNo);	//通过动态码值取到静态值设置到就诊卡号里
			                break;
			            case "-200": //卡无效
			                alert("卡无效-200");
			                return;
			            case "-201": //卡有效无帐户
			                //alert(t['21']);
			               	alert("无账户-201");
			                return;
			                default:
			        }
					
				}
			}*/
            setQuery();
        },
        prompt: '请输入',
        width: 140
    });
    initCTLoc();
    initPnlButton();
    //处理编辑器
    $('#editorFrame').attr('src', 'emr.op.editor.csp');

    //禁止后退键
    document.onkeypress = forbidBackSpace;
    document.onkeydown = forbidBackSpace;
	
	//初始化卡类型
	//initCardType();
	
    //审核日志
    if (!hisLog) {
        hisLog = new HisLogEx(sysOption.IsSetToLog, patInfo);
    }
});

//  emr.op.editor.csp invoke
function initEditor() {
    var sthmsg = '病历正在初始化...';
    setSysMenuDoingSth(sthmsg);    
    try {
        emrEditor.newEmrPlugin();
        emrEditor.initDocument(true);
        if (sthmsg == getSysMenuDoingSth()) {
            setSysMenuDoingSth();
        }            
    } catch (err) {
        setSysMenuDoingSth();
        alert(err.message || err);
    }
}

function initPatTable(data) {
    $('#patientListData').datagrid({
        
        pageSize:10,
        pageList:[10,20,30,40,50],
        //fitColumns: true,
        striped: true,
        pagination:true,
        data:data.slice(0,10),
        loadMsg: '数据装载中......',
        //autoSizeColumn: true,
        autoRowHeight: true,
        singleSelect: true,
        idField: 'EpisodeID',
        rownumbers: true,
        fit: true,
        remoteSort: false,
        columns: [[{
                    field: 'PatientID',
                    title: 'PatientID',
                    hidden: true
                }, {
                    field: 'EpisodeID',
                    title: 'EpisodeID',
                    hidden: true
                }, {
                    field: 'mradm',
                    title: 'mradm',
                    hidden: true
                }, {
                    field: 'InstanceID',
                    title: '病历ID',
                    hidden: true
                }, {
                    field: 'Status',
                    title: '病历状态',
                    width: 70,
                    sortable: true
                }, {
                    field: 'AuditStatus',
                    title: '审核状态',
                    width: 70,
                    sortable: true
                }, {
                    field: 'Title',
                    title: '病历名称',
                    width: 90,
                    sortable: true
                }, {
                    field: 'PAPMIName',	
                    title: '姓名',
                    width: 60,
                    sortable: true
                }, {
                    field: 'PAPMIRegno',
                    title: '登记号',
                    width: 80,
                    sortable: true
                }, {
                    field: 'PAPMIIDCard',
                    title: '身份证号',
                    width: 80,
                    sortable: true
                }, {
                    field: 'PAAdmDate',
                    title: '就诊日期',
                    width: 90,
                    sortable: true
                }, {
                    field: 'PAAdmTime',
                    title: '就诊时间',
                    width: 70,
                    sortable: true
                }, {
                    field: 'PAAdmLoc',
                    title: '就诊科室',
                    width: 120,
                    sortable: true
                }, {
                    field: 'PAAdmDoc',
                    title: '就诊医师',
                    width: 80,
                    sortable: true
                }, {
                    field: 'Diagnosis',
                    title: '门诊诊断',
                    width: 500,
                    sortable: true
                }
            ]],
        rowStyler: function (index, row) {
            if (row.Status == "已删除") {
                return "color:red";
            }else {}
        },
        onDblClickRow: function (rowIndex, rowData) {
            //alert('onDblClickRow');
            switchEMRContent(rowData);
            $('#btnBrowse').linkbutton('enable');
            $('#btnBrowse').removeAttr("disabled");
        }
    });
}

// 初始化科室
function initCTLoc()
{
    $('#cbxLoc').combobox({  
        url:'../EMRservice.Ajax.hisData.cls?Action=GetCTLocList',  
        valueField:'Id',  
        textField:'Text',
        onChange: function (n,o) {
            $('#cbxLoc').combobox('setValue',n);
            var newText = $('#cbxLoc').combobox('getText');
            $('#cbxLoc').combobox('reload','../EMRservice.Ajax.hisData.cls?Action=GetCTLocList&LocContain='+encodeURI(newText.toUpperCase()));
        },
        onShowPanel: function(){
            var newText = $('#cbxLoc').combobox('getText');
            if (newText == "" || newText == "undefinded")
            {
                $('#cbxLoc').combobox('setValue',"");
            }
            $('#cbxLoc').combobox('reload','../EMRservice.Ajax.hisData.cls?Action=GetCTLocList&LocContain='+encodeURI(newText.toUpperCase()));
        },
        onLoadSuccess:function(d){},
        onLoadError:function(){
            alert('GetCTLocList error:');
        }
    });
}
// 更新病历页面内容
function switchEMRContent(rowData) {
    //if (envVar.instanceId == rowData.InstanceID) return;
    //全局参数替换
    patInfo.PatientID = rowData.PatientID;
    patInfo.EpisodeID = rowData.EpisodeID;
    patInfo.MRadm = rowData.mradm;
    emrEditor.cleanDoc();
    $('#btnOpOfficeAudit').linkbutton('disable');
    $('#btnAuditAndPrint').linkbutton('disable');
    $('#btnPrint').linkbutton('disable');
    $('#btnRefuse').linkbutton('disable');
    $('#btnOpOfficeAudit').attr({"disabled":"disabled"});
    $('#btnAuditAndPrint').attr({"disabled":"disabled"});
    $('#btnPrint').attr({"disabled":"disabled"});
    $('#btnRefuse').attr({"disabled":"disabled"});
    if ((rowData.InstanceID == "")||(rowData.Status == "未保存")) return alert("本次就诊无电子病历记录！");

    common.GetRecodeParamByInsIDSync(rowData.InstanceID, function (tempParam) {
        envVar.savedRecords = tempParam;
        if ("" == envVar.savedRecords) {
            alert("本次就诊无电子病历记录！");
            //showEditorMsg("本次就诊无电子病历记录！", 'warning');
        } else {
            //emrEditor.initDocument(false);
            var sthmsg = '病历正在初始化...';
            setSysMenuDoingSth(sthmsg);    
            try {
                //刷新编辑器
                emrEditor.initDocument(false);
                if (sthmsg == getSysMenuDoingSth()) {
                    setSysMenuDoingSth();
                }            
            } catch (err) {
                setSysMenuDoingSth();
                alert(err.message || err);
            }
            if (rowData.Status == "已签名") 
            {
	            //刷新病历后解锁按钮
                $('#btnOpOfficeAudit').linkbutton('enable');
                $('#btnAuditAndPrint').linkbutton('enable');
                $('#btnOpOfficeAudit').removeAttr("disabled");
                $('#btnAuditAndPrint').removeAttr("disabled");
            	//$('#btnOpOfficePDFPrev').linkbutton('enable');
            	if (rowData.AuditStatus == "已审核")
            	$('#btnPrint').linkbutton('enable');
            	$('#btnPrint').removeAttr("disabled");
            	if (rowData.AuditStatus == "未审核")
            	$('#btnRefuse').linkbutton('enable');
            	$('#btnRefuse').removeAttr("disabled");
            }
        }
    });
}
//查询条件
function setSearchOptions(regNo, name, cardNo){
    var patStatus = "";
    var data = ajaxDATA('String', 'EMRservice.BL.opPrintSearch', 'GetOPPatInfo', regNo, "", name, "", cardNo);
    ajaxPOSTSync(data, function (ret) {
        if ('' != ret) {
            var patInfoData = $.parseJSON(ret);
            $("#regNoSearch").searchbox('setValue', patInfoData.RegNo);
            $("#nameSearch").searchbox('setValue', patInfoData.PatName);
            $("#cardNoSearch").searchbox('setValue', patInfoData.CardNo);
        }else {
            patStatus = "未找到指定患者,请重新输入查询条件!";
            if ("" === regNo) $("#regNoSearch").searchbox('setValue', '');
            if ("" === name) $("#nameSearch").searchbox('setValue', '');
            if ("" === cardNo) $("#cardNoSearch").searchbox('setValue', '');
        }
    }, function (err) {
        alert('GetOPPatInfo error:' + err);
    });
    return patStatus;
}

//设置登记号长度
function setregNoLength(regNo,PatientNoLength){
    if (regNo != '') 
    {
        if (regNo.length < Number(PatientNoLength)) 
        {
            for (var i=(Number(PatientNoLength)-regNo.length-1); i>=0; i--)
            {
                regNo ="0"+ regNo;
            }
        }
    }
    $("#regNoSearch").searchbox('setValue', regNo);
    return regNo;
}

//查询操作调用
function setQuery() {
    var tregNo = $("#regNoSearch").searchbox('getValue');
    var tname = $("#nameSearch").searchbox('getValue');
    var tcardNo = $("#cardNoSearch").searchbox('getValue');
    if (('' != tregNo)||('' != tname)||('' != tcardNo)) {
        if (sysOption.PatientNoLength != "N") {
            tregNo = setregNoLength(tregNo,sysOption.PatientNoLength);
        }
        /* var patStatus = setSearchOptions(tregNo, tname, tcardNo);
        if (patStatus != "") {
            return alert(patStatus);
        }else {
            tregNo = $("#regNoSearch").searchbox('getValue');
            tname = $("#nameSearch").searchbox('getValue');
            tcardNo = $("#cardNoSearch").searchbox('getValue');
        } */
    }
	tregNo = $("#regNoSearch").searchbox('getValue');
    tname = $("#nameSearch").searchbox('getValue');
    tcardNo = $("#cardNoSearch").searchbox('getValue');
	
    var expectedLocId = $('#cbxLoc').combobox('getValue');
    var startDate = $('#startDate').datebox('getText');
    var endDate = $('#endDate').datebox('getText');
    var auditStatus = $("#auditStatus").combobox('getValue');
    var startDate1 = startDate.replace(new RegExp(/-/g), "/");
    var endDate1 = endDate.replace(new RegExp(/-/g), "/");
    var date1 = new Date(startDate1);
    var date2 = new Date(endDate1);
    var date3 = date2.getTime()-date1.getTime();
    var days = Math.floor(date3/(24*3600*1000));
    if (days >= 7)
    {
		alert('查询时间范围要在7天之内');
		return;
	}
    //IE11中，利用下拉框中的“叉号”去掉下拉框内容时，实际上下拉框的值没有去掉，所以查询时需要手动根据下拉框的文本内容判断一下下拉框的值是否应该为空；
    var expectedLocText = $('#cbxLoc').combobox('getText');
    if (expectedLocText == "" || expectedLocText == "undefinded") {
        expectedLocId = "";
    }
	$.messager.progress({
       title: '提示',
       msg: '数据查询中，请稍候……',
       text: ''
   });
    var data = ajaxDATA('Stream', 'EMRservice.BL.opInterface', 'GetOPPatList', tregNo, tname, tcardNo, expectedLocId, startDate, endDate, auditStatus);
    ajaxGET(data, function (ret) {
        if ('' != ret) {
            var patData = $.parseJSON(ret);
            initPatTable(patData.rows);
            var pager = $("#patientListData").datagrid("getPager");
            pager.pagination('refresh', {  
                total:patData.total,  
                pageNumber:1  
            }); 
			pager.pagination({ 
			    total:patData.total, 
			    onSelectPage:function (pageNo, pageSize) { 
					var start = (pageNo - 1) * pageSize; 
					var end = start + pageSize; 
					$("#patientListData").datagrid("loadData", patData.rows.slice(start, end)); 
					pager.pagination('refresh', { 
						total:patData.total, 
						pageNumber:pageNo 
					}); 
			    }
			}); 
            
            //$("#patientListData").datagrid("loadData", patData.rows.slice(0, 10));
            $.messager.progress('close');
        }else {
            $('#patientListData').datagrid('loadData', {total:0,rows:[]});
            $.messager.progress('close');
        }
    }, function (err) {
        alert('GetOPPatList error:' + err);
    });
}


function setSysMenuDoingSth(sthmsg) {
    if ('undefined' != typeof dhcsys_getmenuform) {
        if ('undefined' != typeof dhcsys_getmenuform()) {
            var DoingSth = dhcsys_getmenuform().DoingSth || '';
            if ('' != DoingSth)
                DoingSth.value = sthmsg || '';
        }
    }
}

function getSysMenuDoingSth() {
    if ('undefined' != typeof dhcsys_getmenuform) {
        if ('undefined' != typeof dhcsys_getmenuform()) {
            var DoingSth = dhcsys_getmenuform().DoingSth || '';
            if ('' != DoingSth)
                return DoingSth.value || '';
        }
    }
    return '';
}

var intervalidHideMsg;
function showEditorMsg(msg, msgType) {
    if (isExistVar(msg)) {
        clearInterval(intervalidHideMsg);
        var millisec = 3000;
        if (isExistVar(msgType)) {
            millisec = sysOption.messageScheme[msgType];
        }

        $('#msgtd').html('');
        if (msgType === 'alert') {
            $('#msgtd').css('background-color', '#E7F0FF');
        } else if (msgType === 'warning') {
            $('#msgtd').css('background-color', '##008B8B');
        } else if (msgType === 'forbid') {
            $('#msgtd').css('background-color', 'red');
        } else {
            $('#msgtd').css('background-color', '#E7F0FF');
        }
        $('#msgtd').append(msg);
        $('#msgTable').show();
        intervalidHideMsg = setInterval("$('#msgTable').hide();", millisec);
    }
}

function Dateformatter(date)
{
    var y = date.getFullYear();
    var m = date.getMonth()+1;
    var d = date.getDate();
    return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function Dateparser(s)
{
    if (!s) return new Date();
    var ss = s.split('-');
    var y = parseInt(ss[0],10);
    var m = parseInt(ss[1],10);
    var d = parseInt(ss[2],10);
    if (!isNaN(y) && !isNaN(m) && !isNaN(d))
    {
        return new Date(y,m-1,d);
    } else {
        return new Date();
    }
}

/*
function initCardType()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"web.DHCEMPatCheckLevCom",
			"Method":"CardTypeDefineListBroker"
		},
		success: function(d) {
			if (d == "") return;
			var data = eval("("+d+")");
			$('#cardType').combobox({
				panelHeight: 'auto',
				editable: false,
				valueField: 'value',
				textField: 'text',
				data:data,
				onLoadSuccess: function () {
					$("#cardType").combobox("setValue",data[1].value);
				},
				onSelect: function (record) {
					var cardType = record.value;
				}
			})
		},
		error : function(d) { 
			alert("initDoctorInfo error");
		}
	});	
}

//读卡
function readCardEvent()
{
	/// 卡类型ID
	var CardTypeRowId = "";
	var CardTypeValue = $("#cardType").combobox("getValue");
	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardTypeRowId = CardTypeArr[0];
	}
	
	var myrtn = DHCACC_GetAccInfo(CardTypeRowId, CardTypeValue);
	if (myrtn==-200){ //卡无效
		$.messager.alert("提示","卡无效-1!");
		return;
	}
	
	var myary = myrtn.split("^");
	var rtn = myary[0];
	
	switch (rtn) {
		case "0":
	        //setSearchOptions('','',myary[1]);
	        $("#cardNoSearch").searchbox('setValue',myary[1]);
            setQuery('','',myary[1]);
			break;
		case "-200":
			alert("卡无效");
			break;
		default:
			alert("读卡失败");
	}
}

//读医保卡
function readHealthCardEvent()
{
	var ret = "";
	ret = InsuReadCard("",patInfo.UserID,"","NBA");
	if ((ret == "-1") || (ret == "")) {
		alert("卡无效！");
		return;
	}
	var InsuCardNo=ret.split("^")[1];
	var DQNoStr=ret.split("^")[19];
	var DQNo=DQNoStr.split("|")[0];
	var CardNo=DQNo+InsuCardNo;	//就诊卡号
	$("#cardNoSearch").searchbox('setValue',CardNo);
	setQuery('','',CardNo);
}*/