//页面加载  
$(function() {
    var _regNo = "";
    var _name = "";
    var _cardNo = "";
    patInfo.IPAddress = getIpAddress();
    /*$('#patLst').panel('resize', {
        width: (screen.availWidth) * 0.382
    });
    $('body').layout('resize');*/
    //设置时间
    $('#startDate').datebox('setValue',myformatter(setDate(6)));
    $('#endDate').datebox('setValue',myformatter(setDate(0)));
    $('#startDate').datebox({  
        formatter: function(date){
            var y = date.getFullYear();
            var m = date.getMonth()+1;
            var d = date.getDate();
            return y + '-' + (m < 10 ? ('0' + m) : m) + '-'
            + (d < 10 ? ('0' + d) : d);
        }  
    });
    $('#endDate').datebox({
        formatter: function(date){
            var y = date.getFullYear();
            var m = date.getMonth()+1;
            var d = date.getDate();
            return y + '-' + (m < 10 ? ('0' + m) : m) + '-'
            + (d < 10 ? ('0' + d) : d);
        }
    });
    
    $('.easyui-searchbox').searchbox({
        searcher: function (value, name) {            
            var regNo = $("#regNoSearch").searchbox('getValue');
            var name = $("#nameSearch").searchbox('getValue');
            var cardNo = $("#cardNoSearch").searchbox('getValue');
            setQuery(regNo, name, cardNo);
        },
        prompt: '请输入...'
    });
    
    //读卡按钮 ReadCardClickHandler
    $('#readCard').live('click', function () {
        DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
    });
    
    //查询按钮
    $('#doquery').live('click', function () {
	    var regNo = $("#regNoSearch").searchbox('getValue');
        var name = $("#nameSearch").searchbox('getValue');
        var cardNo = $("#cardNoSearch").searchbox('getValue');
        setQuery(regNo, name, cardNo);
    });
    
    //多选打印按钮
    $('#printSelect').live('click', function () {
        var ckItems = $('#patientPrintListData').datagrid('getChecked');
        var result = "";
        var PageNum = 0;
        var myArray=new Array();
        var countNum = 0;
        var printflag = true;
        $.each(ckItems, function(index, item) {
            if (item.IsAllowCheckPrint == "0") {
                 alert("【"+item.Text+"】不允许勾选打印，请重新勾选！");
                 
                 var Rowindex=$('#patientPrintListData').datagrid('getRowIndex',item);
                 $('#patientPrintListData').datagrid('unselectRow', Rowindex);

                 printflag = false;
                 return true;    
             }
            debugger;
            myArray[countNum] = item.EcID+'||'+item.InsID;
            PageNum = Number(PageNum) + Number(item.PageNum) ; 
            countNum = countNum + 1;
        });
        envVar.PrintPageCount = PageNum ;
        envVar.InsIDCount = myArray ;
        if (printflag == false)
        {
            return ;
        }
        var length = envVar.InsIDCount.length;
        PrintALL(length);
    });
    
    initPatTable();

    //todo
    data = ajaxDATA('String', 'EMRservice.BL.opPrintSearch', 'GetOPPatAllPrintList', '', '', '', '', '', '');
    ajaxGET(data, function (ret) {
        if ('' != ret) {
            var patData = $.parseJSON(ret);
            $('#patientPrintListData').datagrid('loadData', patData);
        }
    
    }, function (err) {
        alert('GetOPPatAllPrintList error:' + err);
    });
    //审核日志
    if (!hisLog) {
        hisLog = new HisLogEx(sysOption.IsSetToLog, patInfo);
    }
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
			setSearchOptions("", "", CardNo); 
			break;
		case "-200": //卡无效
			alert("读卡失败，卡无效！");
			return false;
			break;
		case "-201": //卡有效无帐户
			alert("读卡失败，无账户信息！")
			break;
		default:
	}
}

function initPatTable() {
    $('#patientPrintListData').datagrid({
        width: '100%',
        height: '100%',
        striped: true,
        loadMsg: '数据装载中......',
        //autoSizeColumn: true,
        //checkOnSelect: false,
        autoRowHeight: true,
        singleSelect: false,
        //idField: 'EpisodeID',
        rownumbers: true,
        fit: true,
        remoteSort: false,
        columns: [[{
                    field: 'ck',
                    checkbox:true
                }, {
                    field: 'PatientID',
                    title: 'PatientID',
                    width: 80,
                    hidden: true
                }, {
                    field: 'EpisodeID',
                    title: 'EpisodeID',
                    width: 80,
                    hidden: true
                }, {
                    field: 'mradm',
                    title: 'mradm',
                    width: 80,
                    hidden: true
                }, {
                    field: 'PAPMIName',
                    title: '姓名',
                    width: 60,
                    sortable: true
                }, {
                    field: 'PAPMISex',
                    title: '性别',
                    width: 40,
                    sortable: true
                }, {
                    field: 'PAPMIAge',
                    title: '年龄',
                    width: 40,
                    sortable: true
                }, {
                    field: 'PAAdmDate',
                    title: '就诊日期',
                    width: 80,
                    sortable: true
                }, {
                    field: 'PAAdmTime',
                    title: '就诊时间',
                    width: 80,
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
                    width: 200,
                    sortable: true
                }, {
                    field: 'Text',
                    title: '病历名称',
                    width: 100,
                    sortable: true
                }, {
                    field: 'CreateUserName',
                    title: '创建医师',
                    width: 80,
                    sortable: true
                }, {
                    field: 'EcID',
                    title: 'EcID',
                    width: 50,
                    hidden: true
                }, {
                    field: 'InsID',
                    title: 'InsID',
                    width: 50,
                    hidden: true
                }, {
                    field: 'PageNum',
                    title: 'PageNum',
                    width: 20,
                    hidden: true
                }, {
                    field: 'IsAllowCheckPrint',
                    title: 'IsAllowCheckPrint',
                    width: 20,
                    hidden: true
                }, {
                    field: 'PrintInfo',
                    title: '打印情况',
                    width: 400,
                    sortable: true,
                    formatter: function(value) {
                        
                        if (value== "未打印"){
                             var str = "未打印";
                           }else{
                             var str = '<font style="color:red">'+value+'</font>';
                           }
                           return str;
                    }     
                }, {
                    field: 'browse',
                    title: '浏览病历',
                    align: 'center',
                    width: 80,
                    formatter: function(value,row,index) {
                        var str = '<a href="#" name="browse" class="easyui-linkbutton" onclick="browse('+row.EcID+','+row.InsID+')"></a>';
                        return str;
                    }
                }, {
                    field: 'print',
                    title: '打印病历',
                    align: 'center',
                    width: 80,
                    formatter: function(value,row,index) {
                        var str = '<a href="#" name="print" class="easyui-linkbutton" onclick="print('+row.EcID+','+row.InsID+','+row.PageNum+')"></a>';
                        return str;
                    }
                   } 
        ]],
        onLoadSuccess: function(data){
            $("a[name='browse']").linkbutton({text:'浏览',plain:true,iconCls:'icon-add'});
            $("a[name='print']").linkbutton({text:'打印',plain:true,iconCls:'icon-print'}); 
            $('#patientPrintListData').datagrid('unselectAll');
            $('#patientPrintListData').datagrid('clearSelections');               
        }
    });
}

//浏览所选病历
function browse(EcID,InsID) {
	var data = ajaxDATA('String', 'EMRservice.BL.opInterface','GetBrowseUrl', EcID, InsID);
        ajaxGET(data, function(ret) {
            if (judgeIsIE()){
                window.showModalDialog(ret, window, 'dialogHeight:630px;dialogWidth:1000px;resizable:no;status:no');
            }else {
                var dialogId = "browseDialog";
                var iframeId = "opBrowse";
                var iframeCotent = "<iframe id='"+iframeId+"' width='100%' height='100%' scrolling='auto' frameborder='0' src='"+ret+"'></iframe>";
                createEasyUIModalDialog(dialogId,"浏览病历", 1000, 550,iframeId,iframeCotent,"","");
            }
        }, function(ret) {
            alert('发生错误', '获取浏览相关Url失败' + ret);
        });
}

//打印所选病历
function print(EcID,InsID,PageNum) {
    if (sysOption.isShowCloseBtn && judgeIsIE()){
        window.showModalDialog("emr.op.print.csp?IsWithTemplate=N&AutoPrint=Y&InstanceId="+EcID+'||'+InsID, window, 'dialogHeight:10px;dialogWidth:10px;resizable:no;status:no');
        //alert("打印完成，此次共打印"+PageNum+"页！")
        setQuery(_regNo, _name, _cardNo);
    }else {
        var dialogId = "printDialog";
        var iframeId = "opPrint";
        var src = "emr.op.print.csp?IsWithTemplate=N&AutoPrint=Y&AutoClose=Y&InstanceId="+EcID+'||'+InsID;
        var iframeCotent = "<iframe id='"+iframeId+"' width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>";
        createEasyUIModalDialog(dialogId,"打印病历", 80, 20,iframeId,iframeCotent,doAfterPrint,"");
    }
}

//默认获取当前日期范围（七天）
function setDate(n){
    var now = new Date;
    now.setDate(now.getDate() - n);
    return now;
}

function myformatter(date) {
    var y = date.getFullYear();
    var m = date.getMonth() + 1;
    var d = date.getDate();

    return y + '-' + (m < 10 ? ('0' + m) : m) + '-'
            + (d < 10 ? ('0' + d) : d);
}

//Desc:设置登记号长度
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

//查询条件
function setSearchOptions(regNo, name, cardNo){
    $("#regNoSearch").searchbox('setValue', regNo);
    $("#nameSearch").searchbox('setValue', name);
    $("#cardNoSearch").searchbox('setValue', cardNo);
    //读卡后进行查询
    setQuery(regNo, name, cardNo);
}

//查询操作调用
function setQuery(regNo, name, cardNo){
    _regNo = regNo;
    _name = name;
    _cardNo = cardNo;
    var idCard = "";
    if (document.getElementById("idCardSearch") != null ) {
        idCard = $("#idCardSearch").searchbox('getValue');
    }
    if (sysOption.PatientNoLength != "N") {
 	   regNo = setregNoLength(regNo,sysOption.PatientNoLength);	    
    }
    var startDate = $('#startDate').datebox('getText');
    var endDate = $('#endDate').datebox('getText');
    
    var data = ajaxDATA('String', 'EMRservice.BL.opPrintSearch', 'GetOPPatAllPrintList', regNo, name, cardNo, startDate, endDate, idCard);
    ajaxGET(data, function (ret) {
        if ('' != ret) {
            var patData = $.parseJSON(ret);
            $('#patientPrintListData').datagrid('loadData', patData);
        }else {
            $('#patientPrintListData').datagrid('loadData', {total:0,rows:[]});
        }
    }, function (err) {
        alert('GetOPPatAllPrintList error:' + err);
    });
}

//查询打印调用
function PrintALL(length){
    if (sysOption.isShowCloseBtn && judgeIsIE()){
        for (var i=0;i<length;i++)
        {
            if (envVar.InsIDCount[i] !="")
            {
                window.showModalDialog("emr.op.print.csp?IsWithTemplate=N&AutoPrint=Y&InstanceId="+ envVar.InsIDCount[i], window, 'dialogHeight:10px;dialogWidth:10px;resizable:no;status:no');
                envVar.InsIDCount[i] = "";
            }
        }
        //alert("打印完成，此次共打印"+envVar.PrintPageCount+"页！")
        setQuery(_regNo, _name, _cardNo); 
    }else {
        if (length == 0) return doAfterPrint();
        var num = envVar.InsIDCount.length - length;
        var dialogId = "printDialog";
        var iframeId = "opPrint";
        var src = "emr.op.print.csp?IsWithTemplate=N&AutoPrint=Y&AutoClose=Y&InstanceId="+envVar.InsIDCount[num];
        var iframeCotent = "<iframe id='"+iframeId+"' width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>";
        length = length - 1;
        createEasyUIModalDialog(dialogId,"打印病历", 80, 20,iframeId,iframeCotent,PrintALL,length);
        envVar.InsIDCount[num] = "";
    }
      
}

//存储打印操作
function insertSelfPrintLog(InstanceID) {
   var data = ajaxDATA('String', 'EMRservice.HISInterface.BOExternal', 'AddCustomSelfPrintLog', InstanceID, patInfo.IPAddress, patInfo.UserID);
   ajaxGETSync(data, function(d) {
          if (d != "0") {
                // 同步待议
          }else {
             alert("补打日志保存失败！");
          }
    }, function(err) {
          alert('InsertCustomSelfPrintLog error:' + ret);
    });    
}  

function doAfterPrint(){
    setQuery(_regNo, _name, _cardNo);
}                