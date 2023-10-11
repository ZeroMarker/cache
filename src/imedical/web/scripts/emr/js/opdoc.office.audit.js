$(function () {
    var dataTemp = [];
    initPatTable(dataTemp);
    $('#patientListData').datagrid('loadData', {total:0,rows:[]});
    $('.hisui-searchbox').searchbox({
        searcher: function (value, name) {
            setQuery();
        },
        prompt: emrTrans('请输入')
    });
    $('#recordDocIDType').combobox({
        valueField:"DocID",
        textField:"Desc",
        panelHeight:"auto"
    });
    initPnlButton();
    //处理编辑器
    $('#editorFrame').attr('src', 'emr.opdoc.editor.csp?MWToken='+getMWToken());
    
    //禁止后退键
    document.onkeypress = forbidBackSpace;
    document.onkeydown = forbidBackSpace;

    //审核日志
    if (!hisLog) {
        hisLog = new HisLogEx(sysOption.IsSetToLog, patInfo);
    }
    //如果未配置诊断证明模板 增加系统提示
    if(sysOption.DiagnoseProofDocID==""){
	    alert("未找到配置模板，请到维护程序中确认！");
    }else{
        initDocIDType();
	}
    //设置默认光标在regNoSearch输入框里
    $('input',$('#regNoSearch').next('span')).focus();
});

//读卡回调函数，固定入参
function CardNoKeyDownCallBack(myrtn, errMsg){
	var myary=myrtn.split("^");
    var rtn=myary[0];
	switch (rtn){
		case "0": //卡有效有帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			setSearchOptions(PatientNo, "", ""); 
            $("#regNoSearch").searchbox('setValue',myary[5]);
            setQuery();
			break;
		case "-200": //卡无效
            $.messager.alert("提示","读卡失败，卡无效！","info",function(){
				$("#regNoSearch").focus();
			});
			break;
		case "-201": //卡有效无帐户
            $.messager.alert("提示","读卡失败，无账户信息！","info",function(){
				$("#regNoSearch").focus();
			});
			break;
		default:
            $.messager.alert("提示","读卡失败！错误码："+rtn,"info",function(){
				$("#regNoSearch").focus();
			});
	}
}

function readCardEvent(){
	DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
}

function scanEvent(){
		var StaticQrcodeText=""
		var emsg=tkMakeServerCall("DHCDoc.Interface.Outside.ElecCard.Public","GetScanMsg","1")
		//var StaticQrcodeText=prompt(emsg,"");
		var url="../csp/dhc.ReadScan.csp?";
    	var StaticQrcodeText = window.showModalDialog(url, window, "dialogWidth:800px;dialogHeight:200px;center:yes;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;");
		if (StaticQrcodeText==null){return;}
		var myrtn=DHCACC_GetAccInfo("",StaticQrcodeText,"");
		var mystr=myrtn.split("^");
		if(mystr[0]=='0'){
			setSearchOptions('','',mystr[1]);
			$("#cardNoSearch").searchbox('setValue',myary[1]);
            setQuery();
		}
		else {
			alert(mystr[1]+",请重新扫码!\n或去自助机及人工窗口补发就诊卡就医(原信息同样保留)");
		}
}

//  emr.opdoc.editor.csp invoke
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
        bodyCls:'panel-body-gray',
        headerCls:'panel-header-gray',
        iconCls:'icon-paper',
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
        border:false,
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
                }, {field:'Log',title:'日志',formatter: function (value,row,index) {
						var html = '<div>';
						var title = "日志";
						var style="display:block;width:100%;";
						var str = row.InstanceID + '&' + row.EpisodeID + '&' + row.DocId
						if (row["ID"]!="")
						{
							style += "background:url(../scripts/emr/image/icon/log.png) center center no-repeat;"
							html = html + '<span title="'+title+'" style="'+style+'" onclick = viewLog("'+str+'");>&nbsp;&nbsp;</span>';
						}
						html = html + '</div>';
						return html;
	            	}
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
            switchEMRContent(rowData);
            $('#btnBrowse').linkbutton('enable');
			$('#btnViewRevision').linkbutton('enable');
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
    //锁定按钮
    $('#btnOpOfficeAudit').linkbutton('disable');
    $('#btnAuditAndPrint').linkbutton('disable');
    $('#btnPrint').linkbutton('disable');
    $('#btnRefuse').linkbutton('disable');
    /* $('#btnOpOfficePDFPrev').linkbutton('disable');
    $('#btnOpOfficePDFPrint').linkbutton('disable'); */
    if ((rowData.InstanceID == "")||(rowData.Status == "未保存")) return top.$.messager.alert('提示','本次就诊无电子病历记录！');

    
    common.GetRecodeParamByInsIDSync(rowData.InstanceID, function (tempParam) {
        envVar.savedRecords = tempParam;
        if ("" == envVar.savedRecords) {
            top.$.messager.alert('提示','本次就诊无电子病历记录！');
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
            if (rowData.Status == "已签名") {
                //刷新病历后解锁按钮
                $('#btnOpOfficeAudit').linkbutton('enable');
                $('#btnAuditAndPrint').linkbutton('enable');
            	//$('#btnOpOfficePDFPrev').linkbutton('enable');
            	if (rowData.AuditStatus == "已审核")
            	$('#btnPrint').linkbutton('enable');
            	if (rowData.AuditStatus == "未审核")
            	$('#btnRefuse').linkbutton('enable');
            }
        }
    });
}
//查询条件
function setSearchOptions(regNo, name, cardNo){

    var patStatus = "";
	if ((regNo == "")&&(name == "")&&(cardNo =="")) return patStatus;
    var data = ajaxDATA('String', 'EMRservice.BL.opPrintSearch', 'GetOPPatInfo', regNo, "", name, "", cardNo);
    ajaxPOSTSync(data, function (ret) {
        if ('[]' != ret) {
            var patInfoData = $.parseJSON(ret);
            $("#regNoSearch").searchbox('setValue', patInfoData[0].RegNo);
            $("#nameSearch").searchbox('setValue', patInfoData[0].PatName);
            $("#cardNoSearch").searchbox('setValue', patInfoData[0].CardNo);
        }else {
            patStatus = "未找到指定患者,请重新输入查询条件!";
            //if ("" === regNo) $("#regNoSearch").searchbox('setValue', '');
            //if ("" === name) $("#nameSearch").searchbox('setValue', '');
            //if ("" === cardNo) $("#cardNoSearch").searchbox('setValue', '');
            $("#regNoSearch").searchbox('setValue', regNo);
            $("#nameSearch").searchbox('setValue', name);
            $("#cardNoSearch").searchbox('setValue', cardNo);
        }
    }, function (err) {
        alert('GetOPPatInfo error:' + err);
    });
    return patStatus;
}

//补0方法 默认不满10位的补0
function setArgsLength(arg,PatientNoLength){
    if (arg != '') 
    {
        if (arg.length < Number(PatientNoLength)) 
        {
            for (var i=(Number(PatientNoLength)-arg.length-1); i>=0; i--)
            {
                arg ="0"+ arg;
            }
        }
    }
    return arg;
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

//查询操作调用
function setQuery() {
	var regNo = $("#regNoSearch").searchbox('getValue');
    var name = $("#nameSearch").searchbox('getValue');
    var cardNo = $("#cardNoSearch").searchbox('getValue');
    var startDate = $("#startDate").datebox('getValue');
    var endDate = $("#endDate").datebox('getValue');
    var auditStatus = $("#auditStatus").combobox('getValue');
    var docIDType = $('#recordDocIDType').combobox('getValue') || "ALL";
    if (sysOption.PatientNoLength != "N") {
       //登记号
       regNo = setArgsLength(regNo,sysOption.PatientNoLength);
       //就诊卡号
       cardNo = setArgsLength(cardNo,sysOption.PatientNoLength);    
    }
    var patStatus = setSearchOptions(regNo, name, cardNo);

     if (patStatus != "") {
        return showEditorMsg(patStatus, 'alert');
    }

    tregNo = $("#regNoSearch").searchbox('getValue');
    tname = $("#nameSearch").searchbox('getValue');
    tcardNo = $("#cardNoSearch").searchbox('getValue');

    var startDate1 = startDate.replace(new RegExp(/-/g), "/");
    var endDate1 = endDate.replace(new RegExp(/-/g), "/");
    var date1 = new Date(startDate1);
    var date2 = new Date(endDate1);
    var date3 = date2.getTime()-date1.getTime();
    var days = Math.floor(date3/(24*3600*1000));
    if (days >= 7)
    {
		top.$.messager.alert('提示','查询时间范围要在7天之内');
		return;
    }
	$.messager.progress({
		title: '提示',
		msg: '数据查询中，请稍候……',
		text: ''
   	});
    var data = ajaxDATA('Stream', 'EMRservice.BL.opInterface', 'GetOPPatList', tregNo, tname, tcardNo, "", startDate, endDate, auditStatus, docIDType);
    ajaxGET(data, function (ret) {
        if ('' != ret) {
            var patData = $.parseJSON(ret);
            //每条数据只显示第一条诊断数据
            for(var i = 0;i<patData.rows.length;i++){
	            var diagnose = patData.rows[i].Diagnosis
	            if (diagnose.indexOf(",")!=-1){
		        	patData.rows[i].Diagnosis = diagnose.substring(0,diagnose.indexOf(","))	
		        }	 
	        }
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

//因为调用iEMRplagin.js，在门诊打开病历调用该方法设置系统参数环境，在这里不需要设置，所以同名函数直接return；
function setRunEMRParams()
{
	return;
}

//初始化类型下拉框
function initDocIDType(){
    var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'GetDocIDTypeData');
    ajaxGET(data, function (ret) {
        if (ret != "") {
            var data = $.parseJSON(ret);
            $('#recordDocIDType').combobox({data:data});
        }
    });
}

//查看日志
function viewLog(str)
{
	var instanceId = str.split("&")[0];
	var episodeId = str.split("&")[1];
	var docId = str.split("&")[2];
	jQuery.ajax({
        type : "GET", 
        dataType : "text",
        url : "../EMRservice.Ajax.common.cls",
        async : true,
        data : {
                "OutputType":"String",
                "Class":"EMRservice.BL.opInterfaceBase",
                "Method":"GetAuditAndPrintLog",
                "p1":episodeId,
                "p2":docId,
                "p3":instanceId
            },
        success : function(d) {
	    	$('#dialogLog').dialog({closed: false});
	    	var data = eval("("+d+")");
	        initLogDatagrid(data);
        },
        error : function(d) { alert("viewLog error!");}
    });
}

function initLogDatagrid(data)
{
	$("#officeLog").datagrid({
		loadMsg:'数据装载中......',
	    autoSizeColumn:false,
	    fit:true,
		fitColumns:true,
		pagination:false,
		columns:[[
			{field:'OrderID',title:'顺序号',width:60,sortable:true,type:'int'},
			{field:'LoginUserName',title:'登录医师',width:80,sortable:true},
			{field:'OperUserName',title:'操作医师',width:80,sortable:true},
			{field:'OperDate',title:'操作日期',width:100,sortable:true},
			{field:'OperTime',title:'操作时间',width:90,sortable:true},
			//{field:'MachineIP',title:'IP地址',width:100,sortable:true},
			{field:'Action',title:'操作名称',width:90,sortable:true},
			{field:'ProductSource',title:'产品模块',width:110,sortable:true}
		]],
		data:data
	});
}
