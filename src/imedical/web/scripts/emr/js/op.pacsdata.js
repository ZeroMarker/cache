var pacsSubItems= "";
$(function(){
    strXml = convertToXml(scheme);
    $('#currentEpisode').attr("checked",true);
    $("#comboxEpisode").hide();
    initEpisodeList("#EpisodeList");
    $('#seekform').find(':radio').change(function () {
        if (this.id == "allEpisode")
        {
            $("#comboxEpisode").show();
        }
        else
        {
            $("#comboxEpisode").hide();
            queryData();
        }
    });
    setDataGrid();
    queryData();
});

function getCheckedIds() {
    var ordItemId = '';
    var ids = $('#pacsData').datagrid('getSelections');
    for(var i=0;i<ids.length;i++) {
        quoteData[ids[i].OEOrdItemDR] = {}
        if (''==ordItemId) { ordItemId = ids[i].OEOrdItemDR; }
        else { ordItemId = ordItemId + '^' + ids[i].OEOrdItemDR; }
    }    
    return ordItemId;
}

//设置数据
function setDataGrid()
{
    $('#pacsData').datagrid({
        pageSize:10,
        pageList:[10,20,30], 
        loadMsg:'数据装载中......',
        autoRowHeight: true,
        url:'../EMRservice.Ajax.pacsData.cls?Action=GetPacsData', 
        rownumbers:true,
        pagination:true,
        singleSelect: 'Y'==singleSelect,
        idField:'OEOrdItemDR',
        fit:true,
        columns:getColumnScheme("show>parent>item"),
        onSelect:function(rowIndex,rowData){
            var ordItemId = rowData.OEOrdItemDR;
            quoteData[ordItemId]={};
            getPacsSubData(ordItemId);
        },
        onUnselect:function(rowIndex,rowData){
            $("#pacsSubData  tr:not(:first)").empty();
            //delete quoteData[rowData.OEOrdItemDR];
            quoteData = {};
            var ordItemId = getCheckedIds();
            getPacsSubData(ordItemId);
        },
        onCheckAll:function(rows)
        {
            quoteData = {};
            /*var length = rows.length; 
            for(i = 0; i < length; i ++){ 
                quoteData[rows[i].OEOrdItemDR] = {};    
                getPacsSubData(rows[i].OEOrdItemDR);            
            }*/
            var ordItemId = getCheckedIds();
            getPacsSubData(ordItemId);            
        },
        onUncheckAll:function(rows)
        {
            $("#pacsSubData  tr:not(:first)").empty();
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
        var    td = "";
        if (pacsSubItems[0][i].hidden)
        { 
            td= "<th id='" +pacsSubItems[0][i].field+ "' style='display:none;' ><input type='checkbox' name='SubPacs'/>" + pacsSubItems[0][i].title + "</th>"    
        }
        else
        {
            td= "<th id='" +pacsSubItems[0][i].field+ "' style='border-bottom:#999 1px dotted;border-right:#999 1px dotted;background-color:#F5F5F5;width:" +pacsSubItems[0][i].width+ ";'><input type='checkbox' name='SubPacs' onclick='checkOnClick(this)' />" + pacsSubItems[0][i].title + "</th>"             
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
function getPacsSubData(ID)
{
    jQuery.ajax({
        type: "GET",
        dataType: "text",
        url: "../EMRservice.Ajax.pacsData.cls",
        async: true,
        data: {"Action":"GetMultiSubPacs","ID":ID},
        success: function(d){setPacsSubData(eval("("+d+")"));},
        error: function(d){alert("error");}
    });
}

//检查子项赋值
function setPacsSubData(data)
{
    $("#pacsSubData  tr:not(:first)").empty();
    var tr = $("<tr></tr>");
    for (var i=0;i<data.rows.length;i++)
    {
        $(tr).attr("id",data.rows[i].OEItemRowID);
        var td = ""; 
        for (var j=1;j<pacsSubItems[0].length;j++)
        {
            if (pacsSubItems[0][j].hidden)
            {
                td = "<td style='border:#999 1px dotted;display:none;'>" + data.rows[i][pacsSubItems[0][j].field] +"</td>";    
            }
            else
            {
                td = "<td style='border-bottom:#999 1px dotted;border-right:#999 1px dotted;white-space:normal;'>" + data.rows[i][pacsSubItems[0][j].field] +"</td>";    
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
    quoteData = {};
    var stDateTime = "",endDateTime = "";
    var epsodeIds = episodeID;
    if ($('#allEpisode')[0].checked)
    {
        epsodeIds = "";
        var values = $('#EpisodeList').combogrid('getValues');
        for (var i=0;i< values.length;i++)
        {
            epsodeIds = (i==0)?"":epsodeIds + ",";
            epsodeIds = epsodeIds + values[i];
        }    
    }
    $('#pacsData').datagrid('load',{
        ID: epsodeIds,
        StartDateTime: stDateTime,
        EndDateTime: endDateTime
    });    
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
            for (j=0;j<childList.length;j++)
            {
                if (quoteData[item.OEOrdItemDR][childList[j].code])
                {
                    result = result + childList[j].desc + quoteData[item.OEOrdItemDR][childList[j].code]+ childList[j].separate;
                }
            }
            result = result + separate;
        }    
    });     
    var param = {"action":"insertText","text":result}
    invoker.eventDispatch(param);            
    
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