var GV = {
    editIndex: undefined,
    currentHOSPID: session['LOGON.HOSPID'],
    tableName: "Nur_IP_Quality.WorkFlowConfig"
}
var currentCTLOCID = session['LOGON.CTLOCID']
var currentUSERID = session['LOGON.USERID']
var currentUSERNAME = session['LOGON.USERNAME']
var currentGROUPID = session['LOGON.GROUPID']
var currentWARDID = (session['LOGON.WARDID']==undefined)? "" : session['LOGON.WARDID']
$(function() {
    initUI()
})

function initUI(){
    initSearchForm();
    initProblemSummaryTabs();
    initShowInputEmrNote();
}
function initSearchForm(){

    var hiddenAppraise = $cm({
        ClassName:"Nur.Quality.Service.WorkflowConfig",
        MethodName:"getSingleConfig",
        code: "appraise",
        HospId: GV.currentHOSPID
    },false);

    if (hiddenAppraise == "1")
    {
        $('#problemSummaryTabs').tabs("close",3)
        //$('#problemSummaryTabs').tabs("close",1)
        //$('#problemSummaryTabs').tabs("close",0)
    }
    
    var hiddenNote = $cm({
        ClassName:"Nur.Quality.Service.WorkflowConfig",
        MethodName:"getSingleConfig",
        code: "note",
        HospId: GV.currentHOSPID
    },false);

    if (hiddenNote == "1")
    {
        $('#problemSummaryTabs').tabs("close",2)
    }

    function filter(q, row) {
        var opts = $(this).combobox('options');
        var text = row[opts.textField];
        var pyjp = getPinyin(text).toLowerCase();
        if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
            return true;
        }
        return false;
    }
    
    /**科室 */
    $('#inputWardID').combobox({
        disabled: (currentWARDID != "" ? true : false ),
        valueField: 'ID',
        textField: 'desc',
        url: LINK_CSP + '?className=Nur.Quality.Service.Comm&methodName=getLocs&parameter1=W&parameter2=' + GV.currentHOSPID + "&parameter3=" + GV.tableName,
        filter: filter,
        onLoadSuccess: function (params) {
	        if (currentWARDID != "")
            {
                $(this).combobox('setValue', session['LOGON.CTLOCID'])
            }
        }
    })

    /**病历 */
    $('#inputEmrCode').combobox({
        valueField: 'ID',
        textField: 'desc',
        url: LINK_CSP + '?className=Nur.Quality.Service.Comm&methodName=getEmrCodeList&parameter1=' + GV.currentHOSPID,
        filter: filter
    })

    /**开关 */
    $HUI.switchbox('#patSwitch', {
        onText:$g("在院病历"),
        offText:$g("转科/出院病历"),
        checked: false,
        size:'small',
        animated:true,
        onClass:'primary',
        offClass:'gray',
        // style:{ height: '30px'},
        onSwitchChange:function(event,obj){
	         if (obj.value)
	        {
		        $("#dateInput").css("display","none")
		    }else{
			    $("#dateInput").css("display","")
			}
            searchBtn()
        },
    })
    
    /*选中全部患者*/
    $HUI.radio("#allPat").setValue(true);
    
    /**出院时间 */
    $('#inputOutHopStartDate').datebox('setValue', (new Date()).Format("yyyy-MM-dd"))
    $('#inputOutHopEndDate').datebox('setValue', (new Date()).Format("yyyy-MM-dd"))

    /**关键字 */
    $('#inputMainSelect').combobox({
        valueField: 'value',
        textField: 'label',
        data: [{
            label: $g("床号"),
            value: 'bedCode'
        },{
            label: $g("患者姓名"),
            value: 'patName'
        }]
    })

    $('#inputMainInput').bind('keypress', function(event) {
        if (event.keyCode == "13") {
            searchBtn();
        }
    });

    /**查询 */
    $('#searchBtn').on('click',function(){
        searchBtn()
    })
    
    /**导出 */
    $('#exportBtn').on('click',function(){
	    var problemSummaryTabs = $('#problemSummaryTabs').tabs('getSelected');
    	var title = $(problemSummaryTabs).panel("options").title
    	
    	switch (title) {
        case $g("备注问题"):
        	exportBtn("notesProblemTable","note")
            break;
        case $g("评价问题"):
        	exportBtn("appraiseProblemTable","appraise")
            break;
        case $g("护理评估未评"):
        	exportBtn("limitationOfTimeTable","limitationOfTime")
            break;
         case $g("体温单未测"):
         	exportBtn("temperatureCompleteTable","temperatureComplete")	
            break;
    	}
    })

    $HUI.checkbox("#all",{
        onCheckChange: function(e, value){
            allCheckBoxClick(value)
        }
    })

    /**设置切换tab后的查询方法 */
    $('#problemSummaryTabs').tabs({
        onSelect: function(title,index){
            changeTabEvent(title)
        }
    })
}
function initProblemSummaryTabs(){
	
	/*获取配置的列*/
	var configColumns = $cm({
		ClassName:"Nur.Quality.Service.ProblemSummary",
		MethodName:"getEmrConfigInterface",
        HospId: GV.currentHOSPID
	},false);
	
	var limitColumns=[{ field: 'bedCode', title: $g("床号"), width: 80, align:'left' },
            		  { field: 'patName', title: $g("姓名"), width: 100, align:'left' }]
    
    limitColumns = limitColumns.concat(configColumns)
	
    // 护理评估未评
    $('#limitationOfTimeTable').datagrid({
	    url: LINK_CSP + '?className=Nur.Quality.Service.ProblemSummary&methodName=getNotesProblemList',
        method: 'post',
        loadMsg: $g("数据装载中......"),
        nowrap: false,
        striped: false,
        //fitColumns: true,
        autoRowHeight: false,
        singleSelect: false,
        showHeader: true,
        columns: [limitColumns],
        pagination: true,
        pageSize: 20,
        pageList: [10, 20, 50],
        pagePosition: 'bottom',
        onBeforeLoad: function(param) {
            param.parameter1 = ($('#inputWardID').combobox('getValue')=="" ? currentCTLOCID : $('#inputWardID').combobox('getValue'));
            param.parameter2 =  $HUI.switchbox('#patSwitch').getValue() ? "I" : "D";
            param.parameter3 = $('#inputMainSelect').combobox('getValue');
            param.parameter4 = $('#inputMainInput').val();
            param.parameter5 = $('#inputOutHopStartDate').datebox('getValue');
            param.parameter6 = $('#inputOutHopEndDate').datebox('getValue');
            param.parameter7 = param.page;
            param.parameter8 = param.rows;
            param.parameter9 = "limitationOfTime";
            param.parameter10 = $('#inputEmrCode').combobox('getValue');
            param.parameter11 = $HUI.radio("#selfPat").getValue();
            param.parameter12 = currentUSERID;
            param.parameter13 = currentGROUPID;
        }
    })

    // 体温单完整性
    $('#temperatureCompleteTable').datagrid({
	    url: LINK_CSP + '?className=Nur.Quality.Service.ProblemSummary&methodName=getNotesProblemList',
        method: 'post',
        loadMsg: $g("数据装载中......"),
        nowrap: false,
        striped: false,
        //fitColumns: true,
        autoRowHeight: true,
        singleSelect: false,
        showHeader: true,
        columns: [[
            { field: 'bedCode', title: $g("床号"), width: 80, align:'left' },
            { field: 'patName', title: $g("姓名"), width: 100, align:'left' },
            { field: 'problemDetails', title: $g("缺陷描述"), width: 480, align:'left',
              formatter:function(value){
	            var newValue=value.replace(/未测/g,"<font style='color:red'>"+$g("未测")+"</font>")
             	return newValue
              }
            },
        ]],
        pagination: true,
        pageSize: 20,
        pageList: [10, 20, 50],
        pagePosition: 'bottom',
        onBeforeLoad: function(param) {
            param.parameter1 = $('#inputWardID').combobox('getValue');
            param.parameter2 =  $HUI.switchbox('#patSwitch').getValue() ? "I" : "D";
            param.parameter3 = $('#inputMainSelect').combobox('getValue');
            param.parameter4 = $('#inputMainInput').val();
            param.parameter5 = $('#inputOutHopStartDate').datebox('getValue');
            param.parameter6 = $('#inputOutHopEndDate').datebox('getValue');
            param.parameter7 = param.page;
            param.parameter8 = param.rows;
            param.parameter9 = "temperatureComplete";
            param.parameter10 = $('#inputEmrCode').combobox('getValue');
            param.parameter11 = $HUI.radio("#selfPat").getValue();
            param.parameter12 = currentUSERID;
            param.parameter13 = currentGROUPID;
        }
    })

    // 备注问题
    $('#notesProblemTable').datagrid({
        url: LINK_CSP + '?className=Nur.Quality.Service.ProblemSummary&methodName=getNotesProblemList',
        method: 'post',
        loadMsg: $g("数据装载中......"),
        nowrap: false,
        striped: false,
        fitColumns: true,
        autoRowHeight: true,
        singleSelect: true,
        showHeader: true,
        columns: [[
            { field: 'bedCode', title: $g("床号"), width: 80, align:'left' },
            { field: 'patName', title: $g("姓名"), width: 100, align:'left' },
            { field: 'emrDesc', title: $g("病历名称"), width: 200, align:'left',
              formatter:function(value){
             	return "<font color='blue'>"+value+"</font>"
              }
            },
            { field: 'noteDetails', title: $g("备注"), width: 380, align:'left' },
            { field: 'noteUser', title: $g("备注人"), width: 120, align:'left' },
            { field: 'noteDateTime', title: $g("备注日期"), width: 180, align:'left' },
            { field: 'responsible', title: $g("责任人"), width: 120, align:'left' },
            { field: 'noteIfAdjust', title: $g("是否调整"), width: 80, align:'left' },
            { field: 'noteAdjustUser', title: $g("调整人"), width: 120, align:'left' },
            { field: 'noteID', title: 'id', width: 80, align:'left', hidden:true},
        ]],
        pagination: true,
        pageSize: 20,
        pageList: [10, 20, 50],
        pagePosition: 'bottom',
        onBeforeLoad: function(param) {
            param.parameter1 = $('#inputWardID').combobox('getValue');
            param.parameter2 =  $HUI.switchbox('#patSwitch').getValue() ? "I" : "D";
            param.parameter3 = $('#inputMainSelect').combobox('getValue');
            param.parameter4 = $('#inputMainInput').val();
            param.parameter5 = $('#inputOutHopStartDate').datebox('getValue');
            param.parameter6 = $('#inputOutHopEndDate').datebox('getValue');
            param.parameter7 = param.page;
            param.parameter8 = param.rows;
            param.parameter9 = "note";
            param.parameter10 = $('#inputEmrCode').combobox('getValue');
            param.parameter11 = $HUI.radio("#selfPat").getValue();
            param.parameter12 = currentUSERID;
            param.parameter13 = currentGROUPID;
        },
        onLoadSuccess:function(data){
            var notegrid =  $('#notesProblemTable')
            var bedCodeMerge = data.bedCodeMerge
            for (var bedIndex in bedCodeMerge)
            {
                notegrid.datagrid('mergeCells',{
                    index: bedCodeMerge[bedIndex].index,
                    field:'bedCode',
                    rowspan: bedCodeMerge[bedIndex].rowspan
                });
                notegrid.datagrid('mergeCells',{
                    index: bedCodeMerge[bedIndex].index,
                    field:'patName',
                    rowspan: bedCodeMerge[bedIndex].rowspan
                });
            }
            var emrDescMerge = data.emrDescMerge
            for (var emrIndex in emrDescMerge)
            {
                notegrid.datagrid('mergeCells',{
                    index: emrDescMerge[emrIndex].index,
                    field:'emrDesc',
                    rowspan: emrDescMerge[emrIndex].rowspan
                });
            }
        },
        onClickCell: function(rowIndex, field, value){
            if (field == "emrDesc"){
                var rows = $('#notesProblemTable').datagrid("getRows")
                var noteID = rows[rowIndex].noteID
                $("#auditMainID").val(noteID.split("||")[0])
                clickBtnEvent()
                $('#showInputEmrNote').window("open")
            }
        }
    })

     // 评价问题
     $('#appraiseProblemTable').datagrid({
        url: LINK_CSP + '?className=Nur.Quality.Service.ProblemSummary&methodName=getNotesProblemList',
        method: 'post',
        loadMsg: $g("数据装载中......"),
        nowrap: false,
        striped: false,
        fitColumns: true,
        autoRowHeight: true,
        singleSelect: true,
        showHeader: true,
        columns: [[
            { field: 'bedCode', title: $g("床号"), width: 80, align:'left' },
            { field: 'patName', title: $g("姓名"), width: 100, align:'left' },
            { field: 'emrDesc', title: $g("质控项目"), width: 200, align:'left' },
            { field: 'appraiseItem', title: $g("问题描述"), width: 380, align:'left' },
            { field: 'appraiseRemark', title: $g("备注"), width: 120, align:'left' },
            { field: 'appraiseScore', title: $g("评价结果"), width: 180, align:'left' },
            { field: 'appraiseDateTime', title: $g("评价日期"), width: 180, align:'left' },
            { field: 'appraiseUser', title: $g("评价人"), width: 120, align:'left' },
        ]],
        pagination: true,
        pageSize: 20,
        pageList: [10, 20, 50],
        pagePosition: 'bottom',
        onBeforeLoad: function(param) {
            param.parameter1 = $('#inputWardID').combobox('getValue');
            param.parameter2 = $HUI.switchbox('#patSwitch').getValue() ? "I" : "D";
            param.parameter3 = $('#inputMainSelect').combobox('getValue');
            param.parameter4 = $('#inputMainInput').val();
            param.parameter5 = $('#inputOutHopStartDate').datebox('getValue');
            param.parameter6 = $('#inputOutHopEndDate').datebox('getValue');
            param.parameter7 = param.page;
            param.parameter8 = param.rows;
            param.parameter9 = "appraise";
            param.parameter10 = "";
            param.parameter11 = $HUI.radio("#selfPat").getValue();
            param.parameter12 = currentUSERID;
            param.parameter13 = currentGROUPID;
        },
        onLoadSuccess:function(data){
            var appraisegrid =  $('#appraiseProblemTable')
            var bedCodeMerge = data.bedCodeMerge
            for (var bedIndex in bedCodeMerge)
            {
                appraisegrid.datagrid('mergeCells',{
                    index: bedCodeMerge[bedIndex].index,
                    field:'bedCode',
                    rowspan: bedCodeMerge[bedIndex].rowspan
                });
                appraisegrid.datagrid('mergeCells',{
                    index: bedCodeMerge[bedIndex].index,
                    field:'patName',
                    rowspan: bedCodeMerge[bedIndex].rowspan
                });
            }
            var emrDescMerge = data.emrDescMerge
            for (var emrIndex in emrDescMerge)
            {
                appraisegrid.datagrid('mergeCells',{
                    index: emrDescMerge[emrIndex].index,
                    field:'emrDesc',
                    rowspan: emrDescMerge[emrIndex].rowspan
                });
                appraisegrid.datagrid('mergeCells',{
                    index: emrDescMerge[emrIndex].index,
                    field:'appraiseScore',
                    rowspan: emrDescMerge[emrIndex].rowspan
                });
                appraisegrid.datagrid('mergeCells',{
                    index: emrDescMerge[emrIndex].index,
                    field:'appraiseDateTime',
                    rowspan: emrDescMerge[emrIndex].rowspan
                });
                appraisegrid.datagrid('mergeCells',{
                    index: emrDescMerge[emrIndex].index,
                    field:'appraiseUser',
                    rowspan: emrDescMerge[emrIndex].rowspan
                });
            }
        }
    })
}

/**主界面查询按钮 */
function searchBtn(){
    var problemSummaryTabs = $('#problemSummaryTabs').tabs('getSelected');
    var title = $(problemSummaryTabs).panel("options").title
    //var index = $('#problemSummaryTabs').tabs('getTab',problemSummaryTabs);
    changeTabEvent(title)
}


/**图标展示 */
function showImg (value, row, index){
    return  "<a onclick='showEmrAuditDetails("+row['auditMainID']+","+ row['episodeID'] +")'  class='icon icon-paper' href='javascript:;'></a>"
}
/**文书名称展示 */
function showRecDesc(data){
    var data = $.parseJSON(data)
    var html='<div class="showEmrList"><ul>'
    for (var index in data)
    {
        html += '<li  style="cursor:pointer;" onclick="clickRecDesc(' + data[index].episodeID  + ',' + data[index].auditMainID + ')" value="' + data[index].auditMainID  + '">' + data[index].recDesc  + '</li>'
    }
    html += '</ul></div>'
    return html
}
/**评价结果展示 */
function showEvalution(data){
    var data = $.parseJSON(data)
    var html='<div class="showEmrList"><ul>'
    for (var index in data)
    {
        html += '<li style="height:'+ (data[index].colSpan) * 34   +'px" >' + data[index].score + '</li>'
    }
    html += '</ul></div>'
    return html
}
/**状态点击全部 */
function allCheckBoxClick(flag){
    for (var item in statusList)
    {
        if (item != "all")
        {
            $HUI.checkbox('#' + item).setValue(flag)
        }
    }
}
function getAllChecked()
{
    var checkedList = [] 
    for (var item in statusList)
    {
        if (item != "all")
        {
            if ($HUI.checkbox('#' + item).getValue())
            {
                checkedList.push(item)
            }
        }
    }
    return checkedList.join(",")
}

/**
 * 切换页签的事件
 * @param {*} title 
 */
function changeTabEvent(title){
    switch (title) {
        case $g("备注问题"):
            $('#notesProblemTable').datagrid('load');
            break;
        case $g("评价问题"):
            $('#appraiseProblemTable').datagrid('load');
            break;
        case $g("护理评估未评"):
            $('#limitationOfTimeTable').datagrid('load');
            break;
         case $g("体温单未测"):
            $('#temperatureCompleteTable').datagrid('load');
            break;
    }
}
/**
* @description: 初始化备注模块
*/
function initShowInputEmrNote(){
    $('#showInputEmrNote').window({
        width: 800,
        height: 400,
        modal: true,
        closed: true,
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closable: true,
        title: $g('备注'),
        iconCls: 'icon-w-edit'
    })
    $('#searchNoteBtn').on('click',function(){
        clickBtnEvent()
    })
    $('#inputEmrNoteTable').datagrid({
        url: $URL,
        queryParams:{
            ClassName: 'Nur.Quality.Service.Audit',
            QueryName: 'getAuditNoteRec',
            AuditMainID: "",
            StartDate: "",
            EndData: ""
        },
        method: 'post',
        loadMsg: $g('数据装载中......'),
        striped: false,
        fitColumns: false,
        autoRowHeight: true,
        singleSelect: true,
        rownumbers: true,
        showHeader: true,
        nowrap: false,
        columns: [[
            { field: 'content', title: $g('备注内容'), width: 280},
            { field: 'addUser', title: $g('备注人'), width: 70, align:'left'},
            { field: 'addDateTime', title: $g('备注日期'), width: 160, align:'left' },
            { field: 'ifAdajust', title: $g('是否调整'), width: 80, align:'left',editor: 'text',
            formatter:function(value){
               if (value == 0)
               {
                   return $g("否")
               }else{
                   return $g("是")
               }
            },
                editor:{
                    type:'checkbox',
                    options:{  
                        on: "1",  
                        off: "0",
                    }            
                }
            },
            { field: 'adajustUser', title: $g('调整人'), width: 70, align:'left' },
            { field: 'adajustDateTime', title: $g('调整日期'), width: 160, align:'left' },
            { field: 'auditMainNoteSubID', title: 'ID', width: 70, align:'left' }
        ]],
        pagination: true,
        pageSize: 20,
        pageList: [10, 20, 50],
        pagePosition: 'bottom',
        toolbar: [
            {
                iconCls: 'icon-save',
                text: $g('保存'),
                handler: function() {
                    emrNoteHandler('save')
                }
            }
        ],
        onDblClickRow:function(rowIndex, rowData){
            $('#inputEmrNoteTable').datagrid("rejectChanges");
            $('#inputEmrNoteTable').datagrid("unselectAll");
            $('#inputEmrNoteTable').datagrid("selectRow",rowIndex)
            $('#inputEmrNoteTable').datagrid("beginEdit", rowIndex);
            GV.editIndex = rowIndex
            // if (endEdit())
            // {
            //     GV.editIndex=rowIndex
            //     $('#inputEmrNoteTable').datagrid("beginEdit", rowIndex);
            // }
        }
    })
}

/**
 * 备注表格的操作按钮
 * @param {*} action  delete save
 */
function emrNoteHandler(action){
    var auditMainNoteID="",auditMainID="",content="",ifAdajust=""
    var auditMainNoteSelected = $('#inputEmrNoteTable').datagrid('getSelected')
    if (auditMainNoteSelected == null){
        $.messager.popover({msg: $g('请选择一条记录'),type:'error',timeout: 1000});
        return
    }
    if ( action != "delete")
    {
	    var ed = $('#inputEmrNoteTable').datagrid('getEditor',{index:GV.editIndex,field:'ifAdajust'})
        if (ed == null)
        {
	        $.messager.popover({msg: $g('没有需要保存的数据'),type:'error',timeout: 1000});
        	return
	    }
        var auditMainNoteID = auditMainNoteSelected.auditMainNoteSubID
        var content = auditMainNoteSelected.content;
        var edAdajust = $('#inputEmrNoteTable').datagrid('getEditor',{index:GV.editIndex,field:'ifAdajust'})
        var ifAdajust = ($(edAdajust.target).prop("checked") ? 1 : 0)
    }
    runClassMethod("Nur.Quality.Service.Audit","auditMainNoteSubHandler",
    {
        parameter1: auditMainID,
        parameter2: auditMainNoteID,
        parameter3: content,
        parameter4: ifAdajust,
        parameter5: currentUSERID,
        parameter6: action
    },
    function(data){
        if (data =="0")
        {
            $.messager.popover({msg: $g('操作成功'),type:'success',timeout: 1000});
            $('#inputEmrNoteTable').datagrid('reload');
        }else{
            $.messager.popover({msg: $g('操作失败'),type:'error',timeout: 1000});
        }
    })
}


function clickBtnEvent(){
    var auditMainID = $("#auditMainID").val()
    if (auditMainID == ""){
        $.messager.popover({msg: $g('请选择一条记录'),type:'error',timeout: 1000});
        return
    }
    var queryParams = $('#inputEmrNoteTable').datagrid('options').queryParams;
    queryParams.AuditMainID = auditMainID,
    queryParams.StartDate = $('#inputEmtNoteStartDate').datebox('getValue'),
    queryParams.EndDate = $('#inputEmtNoteEndDate').datebox('getValue'),
    $('#inputEmrNoteTable').datagrid('options').queryParams = queryParams;
    $('#inputEmrNoteTable').datagrid('load');
}

function exportBtn(gridId, type){
	
	
	$('#' + gridId).datagrid('toExcel',
		{name:$g('导出的数据.xls'),
		 parseDataFun: function(data){
			 var data=$cm({
        		 ClassName: 'Nur.Quality.Service.ProblemSummary',
        		 MethodName: 'getNotesProblemList',
        		 dataType: "json",
       			 WardID: $('#inputWardID').combobox('getValue'),
        		Type : $HUI.switchbox('#patSwitch').getValue() ? "I" : "D",
        		MainSelect : $('#inputMainSelect').combobox('getValue'),
        		MainInput : $('#inputMainInput').val(),
        		StartDate : $('#inputOutHopStartDate').datebox('getValue'),
        		EndDate :$('#inputOutHopEndDate').datebox('getValue'),
       			page : "1",
       			rows: "1000",
       			 ContentType : type,
        		EmrCode : $('#inputEmrCode').combobox('getValue'),
        		PatType : $HUI.radio("#selfPat").getValue(),
        		UserId : currentUSERID,
                GroupID: currentGROUPID 
    		},false)
    		return data.rows
		 }
		})
	/*
	 $cm({
        ClassName: 'Nur.Quality.Service.ProblemSummary',
        MethodName: 'getNotesProblemList',
        dataType: "json",
       	WardID: $('#inputWardID').combobox('getValue'),
        Type : $HUI.switchbox('#patSwitch').getValue() ? "I" : "D",
        MainSelect : $('#inputMainSelect').combobox('getValue'),
        MainInput : $('#inputMainInput').val(),
        StartDate : $('#inputOutHopStartDate').datebox('getValue'),
        EndDate :$('#inputOutHopEndDate').datebox('getValue'),
       	page : "1",
       	rows: "1000",
        ContentType : type,
        EmrCode : $('#inputEmrCode').combobox('getValue'),
        PatType : $HUI.radio("#selfPat").getValue(),
        UserId : currentUSERID        
    },function(jsonData){
	 	debugger;
		var jsonData=jsonData.rows
        var xls = new ActiveXObject ("Excel.Application");
        var xlBook = xls.Workbooks.Add;
        var xlSheet = xlBook.Worksheets(1);
    
        var cols = $('#' + gridId ).datagrid('options').columns[0];
        var colCount = cols.length;
    	if ((type!="appraise")&&(type!="note"))
    	{
	    	colCount=colCount+1
	    }
    
        for(i=0;i <colCount-1;i++){ 
            xlSheet.Cells(1,i+1).value =cols[i].title.trim();
            xlSheet.Cells(1,i+1).Font.Bold = true;
            xlSheet.Cells(1,i+1).Font.Size = 12;
            xlSheet.Columns(i+1).ColumnWidth = 10; 
            xlSheet.Cells(1,i+1).Borders.Weight = 2; 
        }
        

        var row =  2;
        for (var i=0;i<jsonData.length;i++) {
            var column = 1;
            
            for(j=0;j <colCount-1;j++){
	            var value = jsonData[i][cols[j].field]
	            if (value!=undefined)
	            {
		            value = String(value)
	            	if (value.indexOf("<br>")>-1)
	            	{
		            	var value=value.replace(/<br>/g,"\n")
		       		}
	             	xlSheet.Cells(row,column).value = value;
	            }
                 xlSheet.Cells(row,column).Borders.Weight = 2; 
             
                 xls.Selection.MergeCells = true;
                 xls.Selection.Borders.Weight = 2;
                 column++;
            }
            row ++;
        }
        var fname = xls.Application.GetSaveAsFilename("导出的xlsx", "Excel Spreadsheets (*.xlsx), *.xlsx"); 
        xlBook.SaveAs(fname); 
        xlBook.Close(); 
        xls.Quit();     
        xls=null;
        xlBook=null; 
        xlSheet=null;
    });
    */
}