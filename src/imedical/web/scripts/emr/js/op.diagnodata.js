$(function() {
    setDataGrid();
    queryData();
});

function refreshData(){
    queryData();
}

//设置数据
function setDataGrid() {
    $('#diagnoData').datagrid({
        pageSize: 10,
        pageList: [10, 20, 30],
        loadMsg: '数据装载中......',
        autoRowHeight: true,
        url: '../EMRservice.Ajax.opHISInterface.cls?action=getDiagnos',
        rownumbers: true,
        pagination: false,
        singleSelect: false,
        fitColumns: true,
        fit: true,
        columns: [
            [{
                field: 'ck',
                checkbox: true
            }, {
                field: 'ARowID',
                title: '诊断ID',
                width: 0,
                hidden: true
            }, {
                field: 'ADiagnosName',
                title: '诊断名称',
                width: 400
            }, {
                field: 'ADiagnosType',
                title: '诊断类型',
                width: 0,
                hidden: true
            }, {
                field: 'AEvaluationDesc',
                title: '状态名称',
                width: 0,
                hidden: true
            }, {
                field: 'AICDCode',
                title: '诊断代码',
                width: 0,
                hidden: true
            }, {
                field: 'AEffectsDesc',
                title: '转归名称',
                width: 0,
                hidden: true
            }, {
                field: 'AUserName',
                title: '医生',
                width: 0,
                hidden: true
            }, {
                field: 'ADateTime',
                title: '时间',
                width: 400
            }, {
                field: 'ADemo',
                title: '备注',
                width: 0,
                hidden: true
            }, {
                field: 'ALevel',
                title: '级别',
                width: 0,
                hidden: true
            }]
        ],
        onCheck: function(rowIndex, rowData) {

        },
        onUncheck: function(rowIndex, rowData) {

        },
        onCheckAll: function(rows) {

        },
        onUncheckAll: function(rows) {

        }
    });

}

// 查询
function queryData() {
    $('#diagnoData').datagrid('reload', {
        EpisodeID: episodeID
    });
}

//引用数据
function getData()
{
    var result = "";
    separate = "\n";
    var checkedItems = $('#diagnoData').datagrid('getChecked');
    $.each(checkedItems, function(index, item) {
        var value = (index + 1) + '.' + item.ADiagnosName.replace(/&nbsp;/g,"");
        result = result + value + separate;
    });
 
    var param = {
        "action": "insertText",
        "text": result
    };
    parent.eventDispatch(param);
    UnCheckAll();         
}

//去掉选择
function UnCheckAll() {
    $("#diagnoData").datagrid("uncheckAll");
}
////////////////////
/*
$(function(){
    strXml = convertToXml(scheme);
    init();

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
});

//初始化
function init()
{
    $("#currentEpisode").attr("checked",true);
    $("#layer").attr("checked",true);
    $("#comboxEpisode").hide();
    initEpisodeList("#EpisodeList");
    setDataGrid();
    queryData();    
}

//设置数据
function setDataGrid()
{
    $('#diagnos').datagrid({ 
        width:'100%',
        height:'100%', 
        pageSize:10,
        pageList:[10,20,30], 
        loadMsg:'数据装载中......',
        autoRowHeight: true,
        fitColumns: true,
        url:'../EMRservice.Ajax.diagnos.cls', 
        singleSelect:true,
        rownumbers:true,
        pagination:true,
        singleSelect:false,
        idField:'ARowID',
        fit:true,
        columns:getColumnScheme("scheme>show>item"),
        onLoadSuccess:function(data){               
            var rowData = data.rows;
            $.each(rowData,function(idx,val){
                var space = "";
                for (var i=1;i<val.ALevel;i++)
                {
                    space = space + '&nbsp;&nbsp;';
                }
                $('#diagnos').datagrid('updateRow',{
                    index: idx,
                    row: {ADiagnosName: space+ val.ADiagnosName}
                });
           });              
        }
  });
}
// 查询
function queryData()
{
    var epsodeIds = episodeID;
    if ($('#allEpisode')[0].checked)
    {
        epsodeIds = "";
        var values = $('#EpisodeList').combogrid('getValues');
        for (var i=0;i< values.length;i++)
        {
            epsodeIds = (i==0)?"":",";
            epsodeIds = epsodeIds + values[i];
        }
    }
    $('#diagnos').datagrid('load',{
        EpisodeIDs: epsodeIds
    });    
}
//引用数据
function getData()
{
    var refScheme = getRefScheme("scheme>reference>items>item")
    var checkedItems = $('#diagnos').datagrid('getChecked');
    var separate = $(strXml).find("scheme>reference>separate").text();
    separate = separate=="enter"?"\n":separate;    
    var result = "";
    for (i=0;i<refScheme.length;i++ ){
        result = result + refScheme[i].desc;    
    }    
    result = result + separate
    if ($('#row')[0].checked)
    {
        $.each(checkedItems, function(index, item){
            for (i=0;i<refScheme.length;i++ ){ 
                var value = item[refScheme[i].code];
                if (refScheme[i].code == "ADiagnosName")
                {
                    value = value.replace(/&nbsp;/g,"");
                }
                result = result + value + refScheme[i].separate;
            }
            result = result + "\n";
        });     
    }
    else
    {
        $.each(checkedItems, function(index, item){
            for (i=0;i<refScheme.length;i++ ){ 
                var value = item[refScheme[i].code];
                if (refScheme[i].code == "ADiagnosName")
                {
                    value = value.replace(/&nbsp;/g," ");
                }
                result = result + value + refScheme[i].separate;
            }
            result = result + "\n";
        });     
    }
    var param = {"action":"insertText","text":result}
    parent.eventDispatch(param);            
}
*/