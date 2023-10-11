var assessScaleSubItems= "";
$(function(){
    strXml = convertToXml(scheme);
    var interface = $(strXml).find("interface").text();
    initEpisodeList("#EpisodeList");
    setDataGrid(interface);
    $HUI.radio("[name='episode']",{
        onChecked:function(e,value){
            queryData();
            $('#EpisodeList').combogrid('setValue','');
        }
    });
    
    $HUI.radio("#currentEpisode").setValue(true);

    $('#assessScaleDataPnl').panel('resize', {
        height: $('#dataPnl').height() * 0.60
    });
 
    $('body').layout('resize');
});

//设置数据
function setDataGrid(interface)
{
    var param = getParam();
    $('#assessScaleDataByEpisodeID').datagrid({
        pageSize:10,
        pageList:[10,20,30], 
        loadMsg:'数据装载中......',
        autoRowHeight: true,
        url:'../EMRservice.Ajax.assessScale.cls?Action=GetAssessScaleDataByEpisodeID&InterFace='+encodeURI(encodeURI(interface)),
        rownumbers:true,
        pagination:true,
        singleSelect:false,
        queryParams:param,
        idField:'ScaleID',
        fit:true,
        columns:getColumnScheme("show>parent>item"),
        onSelect:function(rowIndex,rowData){
            quoteData[rowData.RatingScaleDictDR]={};
            getAssessScaleData(interface,rowData.ScaleID);
        },
        onUnselect:function(rowIndex,rowData){
            $("#assessScaleDataByScaleID  tr:not(:first)").detach();
            delete quoteData[rowData.RatingScaleDictDR];
        },
        onCheckAll:function(rows)
        {
            quoteData = {};
            var length = rows.length; 
            for(i = 0; i < length; i ++){ 
                quoteData[rows[i].RatingScaleDictDR] = {};
                getAssessScaleData(interface,rows[i].ScaleID);
            }
        },
        onUncheckAll:function(rows)
        {
            $("#assessScaleDataByScaleID tr:not(:first)").detach();
            quoteData = {};
        }
    });
    initAssessScaleDataTable();
}
//初始化评估量表
function initAssessScaleDataTable()
{
    var tr = $("<tr></tr>");
    assessScaleSubItems = getColumnScheme("show>child>item");
    for (var i=1;i<assessScaleSubItems[0].length;i++)
    {
        var td = "";
        if (assessScaleSubItems[0][i].hidden)
        { 
            td= "<th id='" +assessScaleSubItems[0][i].field+ "' style='display:none;' ><input class='hisui-checkbox' type='checkbox' name='SubAssessScale' label='" + assessScaleSubItems[0][i].title + "'/></th>"    
        }
        else
        {
            td= "<th id='" +assessScaleSubItems[0][i].field+ "' style='width:" +assessScaleSubItems[0][i].width+ ";'><input class='hisui-checkbox' type='checkbox' name='SubAssessScale' data-options='onCheckChange:function(event,value){checkOnClick(this)}' label='" + assessScaleSubItems[0][i].title + "'/></th>" 
        }
        $(tr).append(td);
    }
    $("#assessScaleDataByScaleID").append(tr);
    $.parser.parse('#assessScaleDataByScaleID');
    for (var i=1;i<assessScaleSubItems[0].length; i++)
    {
        if (assessScaleSubItems[0][i].check)
        { 
            var code = assessScaleSubItems[0][i].field;
            $HUI.checkbox('#'+ code+ " input").setValue(true);
        }
    }
    
}
// 取评估量表结果
function getAssessScaleData(Interface,scaleID)
{
    jQuery.ajax({
        type: "GET",
        dataType: "text",
        url: "../EMRservice.Ajax.assessScale.cls?InterFace="+encodeURI(encodeURI(Interface)),
        async: true,
        data: {
            "Action":"GetAssessScaleDataByScaleID",
            "ScaleID":scaleID
        },
        success: function(d){
            setAssessScaleData(eval("("+d+")"));
        },
        error: function(d){
            alert("GetAssessScaleDataByScaleID error");
        }
    });
}

//评估量表子项赋值
function setAssessScaleData(data)
{
    $("#assessScaleDataByScaleID tr:not(:first)").detach();
    for (var i=0;i<data.rows.length;i++)
    {
        var tr = $("<tr></tr>");
        $(tr).attr("id",data.rows[i].RatingScaleDictDR);
        var td = ""; 
        for (var j=1;j<assessScaleSubItems[0].length;j++)
        {
            if (assessScaleSubItems[0][j].hidden)
            {
                td = "<td style='display:none;'>" + data.rows[i][assessScaleSubItems[0][j].field] +"</td>";
            }
            else
            {
                td = "<td>" + data.rows[i][assessScaleSubItems[0][j].field] +"</td>";
            }
            $(tr).append(td);
        }
        $("#assessScaleDataByScaleID").append(tr);
        quoteData[data.rows[i].RatingScaleDictDR][i] = {};
        quoteData[data.rows[i].RatingScaleDictDR].length = i+1;
        $("#assessScaleDataByScaleID tr th").each(function(){
            if ($(this).find("input")[0].checked)
            {
                var field = $(this).attr("id");
                quoteData[data.rows[i].RatingScaleDictDR][i][field] = data.rows[i][field];
            }
        });
    }
}

// 查询
function queryData()
{
    var param = getParam();
    $('#assessScaleDataByEpisodeID').datagrid('load',param);
}

//获取查询参数
function getParam()
{
    quoteData = {};
    var epsodeIds = "";
    if ($('#currentEpisode')[0].checked) {
        epsodeIds = episodeID;
    }else {
        var values = $('#EpisodeList').combogrid('getValues');
        for (var i=0;i< values.length;i++)
        {
            epsodeIds = (i==0)?"":epsodeIds + "^";
            epsodeIds = epsodeIds + values[i];
        }
    }
    var param = {
        EpisodeIDs: epsodeIds
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
    separate = (separate=="enter")?"\n":separate;
    var checkedItems = $('#assessScaleDataByEpisodeID').datagrid('getChecked');
    $.each(checkedItems, function(index, item){
        if (quoteData[item.RatingScaleDictDR])
        {
            //收集父内容
            for (var i=0;i<parentList.length;i++)
            {
                result = result + parentList[i].desc + item[parentList[i].code] + parentList[i].separate;
            }
            //收集子表内容
            for (i=0;i<quoteData[item.RatingScaleDictDR].length;i++)
            {
                for (var j=0;j<childList.length;j++)
                {
                    if (quoteData[item.RatingScaleDictDR][i][childList[j].code])
                    {
                        result = result + childList[j].desc + quoteData[item.RatingScaleDictDR][i][childList[j].code].replace(/\n/g,"") + childList[j].separate;
                    }
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

//选择列的子项目，改变缓存内容
function checkOnClick(obj)
{
    try
    {
        if (!$("#assessScaleDataByScaleID tr td")) return;
        var columnItemId = $("#assessScaleDataByScaleID tr:eq(1)").attr("id");
        if (!columnItemId) return;
        var field = $(obj).parent().parent().attr("id");
        var tdNum = $(obj).parent().parent()[0].cellIndex; 
        var context = {};
        var number = 0;
        $("#assessScaleDataByScaleID tr td").each(function() {
            if ($(this)[0].cellIndex == tdNum)
            {
                context[number] = $(this).text();
                number = number + 1;
            }
        });
        if (obj.checked)
        {
            var rownumber = 0 ;
            if (quoteData[columnItemId].length > 1)
            {
                $("#assessScaleDataByScaleID tr").find("td:eq(0)").each(function(){
                   quoteData[columnItemId][rownumber][field] = context[rownumber];
                    rownumber = rownumber + 1;
                });
            }
            else
            {
                quoteData[columnItemId][0][field] = context[0];
            }
        }
        else
        {
            for (i=0;i<quoteData[columnItemId].length;i++)
            {
                if (quoteData[columnItemId][i][field])
                {
                    delete quoteData[columnItemId][i][field];
                }
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
    $("#assessScaleDataByEpisodeID").datagrid("uncheckAll");
}
function onHidePanel()
{
    var values = $('#EpisodeList').combogrid('getValues');
    if (values.length > 0) {
        if ($('#currentEpisode')[0].checked) {
            $HUI.radio("#currentEpisode").setValue(false);
        }
    }
    queryData();
}

function BrowserReport(URL)
{
	window.open(URL,"");
}