var pacsSubItems= "";
$(function(){
    strXml = convertToXml(scheme);
    var interface = $(strXml).find("interface").text();
    pageConfig = $(strXml).find("pageConfig").text();
    $("#resourceConfig").hide();
    $HUI.radio("[name='episode']",{
        onChecked:function(e,value){
            //alert("选中事件");
            queryData();
            $('#EpisodeList').combogrid('setValue','');
            if (pageConfig == "Y") {
                resourceConfig.Pacs = this.id;
            }
        }
    });
    
    if (pageConfig == "Y") {
        $("#resourceConfig").show();
        //获取其它资源区的查询按钮配置项数据
        resourceConfig = getResourceConfig();
        var configItem = resourceConfig.Pacs;
        if ((configItem != "")&&(configItem != undefined))
        {
            $HUI.radio("#"+configItem).setValue(true);
        }else{
            $HUI.radio("#currentEpisode").setValue(true);
        }
    }else{
        $HUI.radio("#currentEpisode").setValue(true);
    }
    initEpisodeList("#EpisodeList");
    setDataGrid(interface);

    $('#pacsDataPnl').panel('resize', {
        height: $('#dataPnl').height() * 0.60
    });
 
    $('body').layout('resize');
});

//设置数据
function setDataGrid(interface)
{
    //$HUI.radio("#allEpisode").setValue(true);
    /*
    if ($('#allEpisode')[0].checked)
    {
            var param = {
            EpisodeIDS: getAllEpisodeIdByPatientId(),
            StartDateTime: "",
            EndDateTime: "",
            RrtStartDateTime: "",
            RrtEndDateTime: "",
            RrtedFlag: ""
        };
    }else{
        var param = getParam();
    }
    */
    var param = getParam();
    
    
    $('#pacsData').datagrid({
        pageSize:10,
        pageList:[10,20,30], 
        loadMsg:'数据装载中......',
        autoRowHeight: true,
        url:'../EMRservice.Ajax.pacsData.cls?Action=GetPacsData&InterFace='+encodeURI(encodeURI(interface)),
        rownumbers:true,
        pagination:true,
        singleSelect:false,
        queryParams:param,
        idField:'OEOrdItemDR',
        fit:true,
        columns:getColumnScheme("show>parent>item"),
        onSelect:function(rowIndex,rowData){
            var ordItemId = rowData.OEOrdItemDR;
            quoteData[ordItemId]={};
            getPacsSubData(interface,rowData.EpisodeID,ordItemId);
        },
        onUnselect:function(rowIndex,rowData){
            $("#pacsSubData  tr:not(:first)").empty();
            delete quoteData[rowData.OEOrdItemDR];
        },
        onCheckAll:function(rows)
        {
            quoteData = {};
            var length = rows.length; 
            for(i = 0; i < length; i ++){ 
                quoteData[rows[i].OEOrdItemDR] = {};
                getPacsSubData(interface,rows[i].EpisodeID,rows[i].OEOrdItemDR);
            }
        },
        onUncheckAll:function(rows)
        {
            $("#pacsSubData tr:not(:first)").empty();
            quoteData = {};
        }
    });
    initPacsSubTable();
}
//初始化检查子项
function initPacsSubTable()
{
    var tr = $("<tr></tr>");
    pacsSubItems = getColumnScheme("show>child>item")
    var pacsSubRefScheme = getRefScheme("reference>child>item");
    for (var i=1;i<pacsSubItems[0].length;i++)
    {
        var	td = "";
        if (pacsSubItems[0][i].hidden)
        { 
            td= "<th id='" +pacsSubItems[0][i].field+ "' style='display:none;font-size:16px;' ><input type='checkbox' name='SubPacs'/>" + emrTrans(pacsSubItems[0][i].title) + "</th>"    
        }
        else
        {
            td= "<th id='" +pacsSubItems[0][i].field+ "' style='border-bottom:#999 1px dotted;font-size:16px;border-right:#999 1px dotted;background-color:#F5F5F5;width:" +pacsSubItems[0][i].width+ ";'><input type='checkbox' name='SubPacs' onclick='checkOnClick(this)' />" + emrTrans(pacsSubItems[0][i].title) + "</th>"
        }
        $(tr).append(td);
    }
    $("#pacsSubData").append(tr);
    
    for (var i=0;i<pacsSubRefScheme.length; i++)
    {
        if (pacsSubRefScheme[i].check)
        { 
            var code = pacsSubRefScheme[i].code;
            $('#'+ code+ " input").attr("checked",true);
        }
    }
    
}
// 取检验结果
function getPacsSubData(Interface,EpisodeID,ID)
{
    jQuery.ajax({
        type: "GET",
        dataType: "text",
        url: "../EMRservice.Ajax.pacsData.cls?InterFace="+encodeURI(encodeURI(Interface)),
        async: true,
        data: {
            "Action":"GetSubPacs",
            "EpisodeIDS":EpisodeID,
            "ID":ID
        },
        success: function(d){setPacsSubData(eval("("+d+")"));},
        error: function(d){alert("error");}
    });
}

//检查子项赋值
function setPacsSubData(data)
{
    $("#pacsSubData  tr:not(:first)").remove();
    var tr = $("<tr></tr>");
    for (var i=0;i<data.rows.length;i++)
    {
        $(tr).attr("id",data.rows[i].OEItemRowID);
        var td = ""; 
        for (var j=1;j<pacsSubItems[0].length;j++)
        {
            if (pacsSubItems[0][j].hidden)
            {
                td = "<td style='border:#999 1px dotted;display:none;font-size:16px;'>" + data.rows[i][pacsSubItems[0][j].field] +"</td>";
            }
            else
            {
                td = "<td valign='top' style='border-bottom:#999 1px dotted;border-right:#999 1px dotted;font-size:16px;white-space:normal;word-break:break-all;'>" + data.rows[i][pacsSubItems[0][j].field] +"</td>";
            }
            $(tr).append(td);
        }
        
        $("#pacsSubData tr th").each(function(){
            if ($(this).find("input")[0].checked)
            {
                var field = $(this).attr("id");
                quoteData[data.rows[i].OEItemRowID][field]= data.rows[i][field];	
            }
        });
        $("#pacsSubData").append(tr);
    }
}

// 查询
function queryData()
{
    var param = getParam();
    $('#pacsData').datagrid('load',param);
}
//获取查询参数
function getParam()
{
    quoteData = {};
    var stDateTime = "",endDateTime = "";
    //rrtStDateTime、rrtEndDateTime是按报告日期查询的始末条件
    var rrtStDateTime = "",rrtEndDateTime = "";
    //报告标识rrtedFlag
    var rrtedFlag = "";
    //三个月时间标识
    var dateGap = "";
    var epsodeIds = episodeID;
    if ($('#currentEpisode')[0].checked) {
        //本次就诊
        //rrtedFlag = 1;
    }else if ($('#recentTwice')[0].checked) {
        rrtedFlag = 2;
    }
	
	/*else if ($('#threeMonths')[0].checked) {
        dateGap = $('#threeMonths').attr('value');
    }*/
	else {
        epsodeIds = "";
        var values = $('#EpisodeList').combogrid('getValues');
        for (var i=0;i< values.length;i++)
        {
            epsodeIds = (i==0)?"":epsodeIds + ",";
            epsodeIds = epsodeIds + values[i];
        }
    }
    var param = {
        EpisodeIDS: epsodeIds,
        StartDateTime: stDateTime,
        EndDateTime: endDateTime,
        RrtStartDateTime: rrtStDateTime,
        RrtEndDateTime: rrtEndDateTime,
        RrtedFlag: rrtedFlag,
        PatientID: patientID,
        DateGap: dateGap
    };
    return param;
}
//引用数据
function getData()
{
    var result = "";
    var parentList = getRefScheme("reference>parent>item");
    var childList = getRefScheme("reference>child>item");
    var separate = $(strXml).find("reference>separate").text();
    separate = (separate=="enter")?"\n":separate	
    var checkedItems = $('#pacsData').datagrid('getChecked');
    $.each(checkedItems, function(index, item){
        if (quoteData[item.OEOrdItemDR])
        {
            //收集父内容
            for (var i=0;i<parentList.length;i++)
            {
                result = result + parentList[i].desc + item[parentList[i].code] + parentList[i].separate;
            }
            //收集子表内容
            for (var j=0;j<childList.length;j++)
            {
                if (quoteData[item.OEOrdItemDR][childList[j].code] != undefined)
                {
                    result = result + childList[j].desc + quoteData[item.OEOrdItemDR][childList[j].code].replace(/\n/g,"") + childList[j].separate;
                }
            }
            if (checkedItems.length-1 > index)
            {
                result = result + separate;
            }
        }
    });
    var param = {"action":"insertText","text":result}
    parent.eventDispatch(param);
    
    //去掉选择
    UnCheckAll();
}

//选择子项目，改变缓存内容
function checkOnClick(obj)
{
    try
    {
        if (!$("#pacsSubData tr td")) return;
        var ordItemId = $("#pacsSubData tr:eq(1)").attr("id");
        if (!ordItemId) return;
        var field = $(obj).parent().attr("id");
        var tdNum = $(obj).parent()[0].cellIndex; 
        var context = "";
        $("#pacsSubData tr td").each(function() {
            if ($(this)[0].cellIndex == tdNum)
            {
                context = $(this).text();
            }
        });
        if (obj.checked)
        {
            quoteData[ordItemId][field] = context;
        }
        else
        {
            if (quoteData[ordItemId][field])
            {
                delete quoteData[ordItemId][field];
            }
        }
    }
    catch(err)
    {
    }
}

//去掉选择
function UnCheckAll()
{
    $("#pacsData").datagrid("uncheckAll");
}
function onHidePanel()
{
    if ($('#currentEpisode')[0].checked) {
        $HUI.radio("#currentEpisode").setValue(false);
    }else if ($('#recentTwice')[0].checked) {
        $HUI.radio("#recentTwice").setValue(false);
    }
	
	/*else if ($('#threeMonths')[0].checked) {
        $HUI.radio("#threeMonths").setValue(false);
    }*/
    queryData();
}

function BrowserReport(URL)
{
	window.open(URL,"");
}