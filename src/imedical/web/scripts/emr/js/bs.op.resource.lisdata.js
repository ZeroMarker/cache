var lisSubColumn = {
    "ItemDesc":{"check":true},
    "Synonym":{"check":true},
    "ItemResult":{"check":true},
    "ItemUnit":{"check":true},
    "AbnorFlag":{"check":true},
    "ItemRanges":{"check":true}
};
$(function(){
    strXml = convertToXml(scheme);
    interface = $(strXml).find("interface").text();
    checkstyle = $(strXml).find("checkstyle").text();
    pageConfig = $(strXml).find("pageConfig").text();
    if (pageConfig == "Y") {
        //获取其它资源区的查询按钮配置项数据
        var resourceConfig = getResourceConfig("lisRadio");
        if (resourceConfig)
        {
            $HUI.radio("#"+resourceConfig).setValue(true);
        }else{
            $HUI.radio("#oneMonth").setValue(true);
        }
    }else{
        $HUI.radio("#oneMonth").setValue(true);
    }
    setDataGrid();

    initlisSubTable();
    $('#lisDataPnl').panel('resize', {
        height: $('#dataPnl').height() * 0.50
    });
 
    $('body').layout('resize');
});

//设置数据
function setDataGrid()
{
    var param = getParam();
    $('#lisData').datagrid({
        pageSize:10,
        pageList:[10,20,30], 
        loadMsg:'数据装载中......',
        autoRowHeight: true,
        url:'../EMR.DOC.SRV.RequestCommon.cls?PAGING=Y&MWToken='+getMWToken(),
        rownumbers:true,
        pagination:true,
        singleSelect:false,
        queryParams:param,
        idField:'OEordItemRowID',
        fit:true,
        columns:getColumnScheme("show>parent>item"),
        sortName:'AuthorisationDate',
        sortOrder:'desc',
        remoteSort:false,
        onCheck:function(rowIndex,rowData){
            var ordItemId = rowData.OEordItemRowID;
            quoteData[ordItemId]={};
            if (checkstyle == "Multiple")
            {
                loadMultiSubData();
            }
            else
            {
                loadSubData(rowData.EpisodeID,ordItemId,rowData.LabEpisodeNo);
            }
        },
        onUncheck:function(rowIndex,rowData){
            if (checkstyle == "Multiple")
            {
                quoteData = {};
                loadMultiSubData();
            }
            else
            {
                $('#lisSubData').datagrid('uncheckAll');
                delete quoteData[rowData.OEordItemRowID];
                $('#lisSubData').datagrid('loadData',{total:0,rows:[]});
            }
        },
        onCheckAll:function(rows)
        {
            quoteData = {};
            var length = rows.length; 
            if (length == 0) return;
            if (checkstyle == "Multiple")
            {
                loadMultiSubData();
            }
            else
            {
                quoteData = {};
                $('#lisSubData').datagrid('loadData',{total:0,rows:[]});
                for(i = 0; i < length; i ++){ 
                    quoteData[rows[i].OEordItemRowID] = {}; 
                    loadSubData(rows[i].EpisodeID,rows[i].OEordItemRowID,rows[i].LabEpisodeNo);
                }
            }
        },
        onUncheckAll:function(rows)
        {
            quoteData = {};
            $('#lisSubData').datagrid('loadData',{total:0,rows:[]});
        }
    });
    lisSubItems = getColumnScheme("show>child>item");
    var wid = 0;
    for (var i=0;i<lisSubItems[0].length;i++)
    {
        wid = wid + lisSubItems[0][i].colwidth;
    }    
    $('#lisSubData').datagrid({ 
        //loadMsg:'数据装载中......',
        autoRowHeight: true,
        url:'../EMR.DOC.SRV.RequestCommon.cls?PAGING=N&MWToken='+getMWToken(),
        singleSelect:true,
        rownumbers:true,
        singleSelect:false,
        fit:true,
        width:wid,
        columns:getColumnScheme("show>child>item"),
        onCheck:function(rowIndex,rowData){
            quoteData[rowData.OeordID]["child" + rowIndex] = { "ItemDesc": rowData.ItemDesc, "Synonym": rowData.Synonym, "ItemResult": rowData.ItemResult, "ItemUnit": rowData.ItemUnit, "AbnorFlag": rowData.AbnorFlag, "ItemRanges": rowData.ItemRanges, "DetailData": rowData.DetailData, "ReportDR": rowData.ReportDR };
            if ((rowData.DetailData.length > 0)&&(rowData.ReportDR != ""))
            {
                qryAnt[rowData.ReportDR] = {};
                $('#Sub-'+rowIndex).datagrid('checkAll');
            }
        },
        onUncheck:function(rowIndex,rowData){
            delete quoteData[rowData.OeordID]["child"+rowIndex];
            if ((rowData.DetailData.length > 0)&&(rowData.ReportDR != "")) 
            {
                delete qryAnt[rowData.ReportDR];
                $('#Sub-'+rowIndex).datagrid('uncheckAll');
            }
        },
        onCheckAll:function(rows){
            var length = rows.length;
            if (length <= 0) return; 
            if (checkstyle == "Multiple")
            {
                var ids = $('#lisData').datagrid('getChecked');
                for(var i=0;i<ids.length;i++) {
                    quoteData[ids[i].OEordItemRowID] = {};
                }
            }
            else
            {
                delete quoteData[rows[0].OeordID]
                quoteData[rows[0].OeordID] = {};
            }
            for(i = 0; i < length; i ++){ 
                quoteData[rows[i].OeordID]["child" + i] = { "ItemDesc": rows[i].ItemDesc, "Synonym": rows[i].Synonym, "ItemResult": rows[i].ItemResult, "ItemUnit": rows[i].ItemUnit, "AbnorFlag": rows[i].AbnorFlag, "ItemRanges": rows[i].ItemRanges, "DetailData": rows[i].DetailData, "ReportDR": rows[i].ReportDR  };
                if ((rows[i].DetailData.length > 0)&&(rows[i].ReportDR != "")) 
                {
                    qryAnt[rows[i].ReportDR] = {};
                    $('#Sub-'+i).datagrid('checkAll');
                }
            }
        },
        onUncheckAll:function(rows){
            var length = rows.length;
            if (length <= 0) return; 
            if (checkstyle == "Multiple")
            {
                var ids = $('#lisData').datagrid('getChecked');
                for(var i=0;i<ids.length;i++) {
                    quoteData[ids[i].OEordItemRowID] = {};
                }
            }
            else
            {
                quoteData[rows[0].OeordID]={};
                for (i = 0; i < length; i++) {
                    if ((rows[0].DetailData.length > 0)&&(rows[0].ReportDR != "")) 
                    {
                        delete qryAnt[rows[0].ReportDR];
                        $('#Sub-'+i).datagrid('uncheckAll');
                    }
                }
            }
        },
        rowStyler: function(index,row){
            /*if ((row.AbnorFlag != "")&&(row.AbnorFlag != "正常")){
                return 'color:#FF0000;';
            }*/
            if ((row.AbnorFlag == "H")||(row.AbnorFlag == "PH")){
                return 'color:#FF0000;';
            }
            else if(row.AbnorFlag == "L")
            {
                return 'color:#0000FF;';
            }
        },
        view: detailview,
        detailFormatter: function(rowIndex, rowData){
            if (rowData.DetailData.length > 0){
                return '<div style="padding:2px"><table id="Sub-' + rowIndex + '"></table></div>';
            }
        },
        onExpandRow: function(index,row){
            if (row.DetailData.length > 0)
            {
                var expanderdata = row.DetailData;
                qryAnt[row.ReportDR] = {};
                $('#Sub-'+index).datagrid({
                    headerCls:'panel-header-gray',
                    loadMsg:'数据装载中......',
                    autoRowHeight:true,
                    data:expanderdata,
                    rownumbers:true,
                    singleSelect:false,
                    idField:'ReportDR',
                    columns:[[  
                        {field:'ck',checkbox:true},
                        {field:'ReportDR',title:'ReportDR',width:80,hidden:true},
                        {field:'AntCode',title:'抗生素代码',width:80},
                        {field:'AntName',title:'抗生素名称',width:80},
                        {field:'LowRange',title:'最低抑菌浓度',width:80},
                        {field:'SenCode',title:'药敏结果代码',width:80},
                        {field:'SenName',title:'药敏结果描述',width:80,sortable:true},
                        {field:'Suggest',title:'建议',width:80},
                        {field:'SenMethod',title:'药敏方法',width:80,sortable:true}
                    ]],
                    sortOrder:'SenName',
                    onResize:function(){
                        $('#lisSubData').datagrid('fixDetailRowHeight',index);
                    },
                    onCheck: function(rowIndex, rowData) {
                        qryAnt[rowData.ReportDR]["child" + rowIndex] = { "ReportDR": rowData.ReportDR, "AntCode": rowData.AntCode, "AntName": rowData.AntName, "SenCode": rowData.SenCode, "SenName": rowData.SenName, "SenMethod": rowData.SenMethod, "LowRange": rowData.LowRange, "Suggest": rowData.Suggest };
                    },
                    onUncheck: function(rowIndex, rowData) {
                        delete qryAnt[rowData.ReportDR]["child" + rowIndex];
                    },
                    onCheckAll: function(rows) {
                        var length = rows.length;
                        if (length <= 0) return;
                        for (i = 0; i < length; i++) {
                            qryAnt[rows[i].ReportDR]["child" + i] = { "ReportDR": rows[i].ReportDR, "AntCode": rows[i].AntCode, "AntName": rows[i].AntName, "SenCode": rows[i].SenCode, "SenName": rows[i].SenName, "SenMethod": rows[i].SenMethod, "LowRange": rows[i].LowRange, "Suggest": rows[i].Suggest };
                        }
                    },
                    onUncheckAll: function(rows) {
                        var length = rows.length;
                        if (length <= 0) return;
                        for (i = 0; i < length; i++) {
                            qryAnt[rows[i].ReportDR] = {};
                        }
                    },
                    onLoadSuccess:function(data){
                        setTimeout(function(){
                            $('#lisSubData').datagrid('fixDetailRowHeight',index);
                        },0);
                    }
                });
                $('#lisSubData').datagrid('fixDetailRowHeight',index);
            }else{
                $('#lisSubData').datagrid('collapseRow',index);
                
            }
        },
        onLoadSuccess:function(data){//当表格成功加载时执行
            var rowData = data.rows;
            $.each(rowData,function(idx,val){//遍历JSON
                if (rowData[idx].DetailData.length > 0){
                    $('#lisSubData').datagrid('expandRow',idx);
                }
                // 异常值勾选
                if (AbnorFlagCheck == "Y" && val.AbnorFlag != "" && val.AbnorFlag != "正常"){
                    $("#lisSubData").datagrid("selectRow", idx); //选中行
                }
           });
        }
    }); 
}

///加载子项
function loadSubData(episodeId,oeordId,labEpisodeNo)
{
    $('#lisSubData').datagrid('load',{
        paramdata: JSON.stringify({
            action: "GET_SUBLISDATA",
            params: {
                langID: langID,
                interface: interface,
                episodeIDs: episodeId,
                oeitemRowID: oeordId,
                labEpisodeNo: labEpisodeNo
            },
            product: product
        })
    });
}

///加载全选的多个子项
function loadMultiSubData() {
    var ordItemId = "";
    var episodeId = "";
    var labEpisodeNo = ""
    var ids = $('#lisData').datagrid('getChecked');
    for(var i=0;i<ids.length;i++) {
        quoteData[ids[i].OEordItemRowID] = {};
        if (ordItemId == "") 
        { 
            ordItemId = ids[i].OEordItemRowID; 
        }
        else 
        { 
            ordItemId = ordItemId + "^" + ids[i].OEordItemRowID; 
        }
        if (episodeId == "") 
        { 
            episodeId = ids[i].EpisodeID; 
        }
        else 
        { 
            episodeId = episodeId + "^" + ids[i].EpisodeID; 
        }
        if (labEpisodeNo == "") 
        { 
            labEpisodeNo = ids[i].LabEpisodeNo; 
        }
        else 
        { 
            labEpisodeNo = labEpisodeNo + "^" + ids[i].LabEpisodeNo; 
        }
    }
    $('#lisSubData').datagrid('load',{
        paramdata: JSON.stringify({
            action: "GET_MULSUBLISDATA",
            params: {
                langID: langID,
                interface: interface,
                episodeIDs: episodeId,
                oeitemRowID: ordItemId,
                labEpisodeNo: labEpisodeNo
            },
            product: product
        })
    });
}

// 查询
function queryData()
{
    var param = getParam();
    if (param){
        $('#lisData').datagrid('load',param);
        $('#lisSubData').datagrid('loadData',{total:0,rows:[]});
    }
}

//获取查询参数
function getParam()
{
    var param = "";
    var epsodeIds = episodeID;
    var authStDate = $("#stDate").datebox("getValue");
    var authEndDate = $("#endDate").datebox("getValue");
    if (!$("#currentEpisode")[0].checked)
    {
        epsodeIds = getAllEpisodeIdByPatientId();
    }
    if ("" != authStDate){
        authStDate = getHISDateTimeFormate("Date",authStDate);
    }
    if ("" != authEndDate){
        authEndDate = getHISDateTimeFormate("Date",authEndDate);
    }
    if (("" != authStDate)&&("" != authEndDate)){
        if (!compareDateTime(authStDate+" 00:00:00",authEndDate+" 00:00:00"))
        {
            $.messager.alert("提示信息", "审核开始日期大于审核结束日期,请重新选择起始日期!");
            return param;
        }
    }
    quoteData = {};
    param = {
        paramdata: JSON.stringify({
            action: "GET_LISDATA",
            params: {
                langID: langID,
                interface: interface,
                episodeIDs: epsodeIds,
                startDateTime: "",
                endDateTime: "",
                authStartDateTime: authStDate,
                authEndDateTime: authEndDate
            },
            product: product
        })
    };
    return param;
}
//引用数据
function getData()
{
    var params = new Array();
    var resultItems = new Array();
    var result = "";
    var parentList = getRefScheme("reference>parent>item");
    var childList = getRefScheme("reference>child>item");
    var separate = $(strXml).find("reference>separate").text();
    separate = (separate=="enter")?"\n":separate
    var checkedItems = $('#lisData').datagrid('getChecked');
    $.each(checkedItems, function(index, item)
    {
        if (quoteData[item.OEordItemRowID])
        {
            //收集父内容
            for (var i=0;i<parentList.length;i++)
            {
                result = result + parentList[i].desc + item[parentList[i].code];
                if (parentList[i].separate == "\n"){
                    params.push([{"text": result}]);
                    result = "";
                }else{
                    result = result + parentList[i].separate;
                }
            }
            //收集子表内容
            $.each(quoteData[item.OEordItemRowID], function(index, item)
            {
                for (j=0;j<childList.length;j++)
                {
                    if(lisSubColumn[childList[j].code].check==true)
                    {
                        if (childList[j].code == "ItemUnit") 
                        {
                            var obj = getFormatString(item[childList[j].code]);
                            if (obj != "") 
                            {
                                var idx1 = item[childList[j].code].indexOf(obj.subChar1);
                                var idx2 = item[childList[j].code].indexOf(obj.subChar2);
                                if ((item[childList[j].code].charAt(0) != "*")&&(item[childList[j].code].charAt(0) != "×")) 
                                {
                                    result = result + "*";
                                }
                                result = result + item[childList[j].code].substring(0, idx1);
                                resultItems.push({"text": result});
                                var text = {"text": item[childList[j].code].substring(idx1 + 1, idx2)};
                                text[obj.style] = "true";
                                resultItems.push(text);
                                result = item[childList[j].code].substring(idx2);
                            } 
                            else 
                            {
                                result = result + item[childList[j].code];
                            }
                        } 
                        else 
                        {
                            result = result + item[childList[j].code];
                        }
                        if (childList[j].separate == "\n"){
                            resultItems.push({"text": result});
                            params.push(resultItems);
                            resultItems = [];
                            result = "";
                        }else{
                            result = result + childList[j].separate;
                        }
                    }
                }
                if (item["DetailData"]!=null){
                    if ((item["DetailData"].length > 0)&&(item["ReportDR"] != ""))
                    {
                        resultItems.push({"text": result});
                        params.push(resultItems);
                        resultItems = [];
                        result = "";
                        $.each(qryAnt[item["ReportDR"]], function(row, rowData) {
                            result = result + rowData.AntName + "：" + rowData.SenName + "：" + rowData.Suggest + "；";
                        });
                        resultItems.push({"text": result});
                    }
                }
            });
            if (checkedItems.length-1 > index)
            {
                if (separate == "\n"){
                    resultItems.push({"text": result});
                    params.push(resultItems);
                    resultItems = [];
                    result = "";
                }else{
                    result = result + separate;
                }
            }
        }
    });
    resultItems.push({"text": result});
    params.push(resultItems);
    var commandJson = parent.EmrEditor.syncExecute({
        action:"COMMAND",
        params:{
            text:params
        },
        product: product
    });
    if ("fail" != commandJson.result) {
        parent.eventSave("insertText","",false);
    }
    UnCheckAll();
}

//判断字符处理
function getFormatString(text)
{
    var obj = "";
    $.each(formatStrings, function(index, item){
        if (text.indexOf(item.string)>-1)
        {
            obj = item;
            return true;
        }
    });
    return obj;
}

//去掉选择
function UnCheckAll()
{
    $("#lisData").datagrid("uncheckAll");
}

//设置报告日期
function upPacsDate(e,sel,val){
    if(!sel) return;
    if(val==1){
        $HUI.datebox("#stDate").setValue(formatDate(-30));
        $HUI.datebox("#endDate").setValue(formatDate(0));
    }
    
    if(val==2){
        $HUI.datebox("#stDate").setValue(formatDate(-90));
        $HUI.datebox("#endDate").setValue(formatDate(0));
    }
    
    if(val==3){
        $HUI.datebox("#stDate").setValue(formatDate(-180));
        $HUI.datebox("#endDate").setValue(formatDate(0));
    }
    
    if(val==4){
        $HUI.datebox("#stDate").setValue("");
        $HUI.datebox("#endDate").setValue("");
    }
    if (initFlag){
        queryData();
    }else{
        initFlag = true;
    }
    if (pageConfig == "Y") {
        saveResourceConfig("lisRadio",e.target.id);
    }
    
    return;
}

/// 格式化日期
function formatDate(t){
    var curr_Date = new Date();  
    curr_Date.setDate(curr_Date.getDate() + parseInt(t)); 
    var Year = curr_Date.getFullYear();
    var Month = curr_Date.getMonth()+1;
    var Day = curr_Date.getDate();
    
    if(typeof(DateFormat)=="undefined"){
        return Year+"-"+Month+"-"+Day;
    }else{
        if(DateFormat=="4"){
            //日期格式 4:"DMY" DD/MM/YYYY
            return Day+"/"+Month+"/"+Year;
        }else if(DateFormat=="3"){
            //日期格式 3:"YMD" YYYY-MM-DD
            return Year+"-"+Month+"-"+Day;
        }else if(DateFormat=="1"){
            //日期格式 1:"MDY" MM/DD/YYYY
            return Month+"/"+Day+"/"+Year;
        }else{
            return Year+"-"+Month+"-"+Day;
        }
    }
}

function initlisSubTable()
{
    var tr = $('<tr class="datagrid-header-row lisSubData-header-row0"></tr>');
    lisSubItems = getColumnScheme("show>child>item");
    var lisSubRefScheme = getRefScheme("reference>child>item");
    tda = "<td class='datagrid-header-rownumber'></td><td style='width:22px;'></td><td class='.datagrid-header-row, .datagrid-row' id='' style='width:15px;'><input class='hisui-checkbox' type='checkbox' name='SubPacs' data-options='onCheckChange:function(event,value){checkAllData(this)}'/></td>";
    $(tr).append(tda);
    for (var i=1;i<lisSubItems[0].length;i++)
    {
        var td = "";
        if (lisSubItems[0][i].hidden)
        { 
            td = "<td class='' id='" +lisSubItems[0][i].field+ "' style='display:none;'><input class='hisui-checkbox' type='checkbox' name='SubPacs' label='" + lisSubItems[0][i].title + "'/></td>";
        }
        else
        {
            var isCheckField = true;
            $.each(lisSubRefScheme, function(index, item){
                if (item.code == lisSubItems[0][i].field)
                {
                    isCheckField = true
                    return false;
                }
                else
                {
                    isCheckField = false
                    return;
                }
                
            })
            
            if (isCheckField == true)
            {
                td= "<td class='' id='" +lisSubItems[0][i].field+ "' style='width:" +(lisSubItems[0][i].width-2)+ ";' align='center'><input class='hisui-checkbox' type='checkbox' name='" +lisSubItems[0][i].field+ "' data-options='onCheckChange:function(event,value){checkOnClick(this)}' label='" + lisSubItems[0][i].title + "'/></td>";
            }
            else
            {
                td= "<td class='' id='" +lisSubItems[0][i].field+ "' style='width:" +lisSubItems[0][i].width+ ";' align='center'>"+lisSubItems[0][i].title+"</td>";

            }
        }
        
        $(tr).append(td);
    }
    $("#lisSubColumn").append(tr);
    $.parser.parse('#lisSubColumn');
    if(selectConfig=="Y"&&clickFlag==false)return
    for (var i=0;i<lisSubRefScheme.length; i++)
    {
        if (lisSubRefScheme[i].check)
        { 
            var code = lisSubRefScheme[i].code;
            $HUI.checkbox('#'+ code+ " input").setValue(true);
        }
    }
}

function checkAllData(obj)
{
    if(obj.checked)
    {
        $('#lisSubData').datagrid('checkAll');
    }
    else
    {
        $('#lisSubData').datagrid('uncheckAll');
    }
    
}

//选择子项目
function checkOnClick(obj)
{
    try
    {
        if (!$("#lisSubColumn tr td")) return;
        var field = obj.name;
        var lisSubItems = getColumnScheme("show>child>item");
        //lisSubColumn = lisSubItems[0];
        if(obj.checked)
        {
            for(var i=0;i<lisSubItems[0].length;i++)
            {
                if((lisSubItems[0][i])&&(lisSubItems[0][i].field))
                {
                    if (lisSubItems[0][i].field == field)
                    {
                        lisSubColumn[field].check = true;
                    }
                }
            }
        }
        else
        {
            for(var i=0;i<lisSubItems[0].length;i++)
            {
                if((lisSubItems[0][i])&&(lisSubItems[0][i].field))
                {
                    if (lisSubItems[0][i].field == field)
                    {
                        lisSubColumn[field].check = false;
                    }
                }
            }
        }
    }
    catch(err)
    {
    }

}
