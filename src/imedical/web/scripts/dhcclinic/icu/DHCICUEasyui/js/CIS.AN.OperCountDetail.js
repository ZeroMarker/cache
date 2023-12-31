function initPage(){
    initInstrumentsBox();
    initDressingsBox();
}

function initInstrumentsBox(){
    var columns=[[
        {field:"SurgicalMaterial",title:"手术物品ID",hidden:true},
        {field:"MaterialNote",title:"手术物品",width:100},
        {field:"PreopCount",title:"术前清点",width:76,editor:{type:"numberbox"}},
        {field:"OperAddCount",title:"术中加数(数值)",hidden:true},
        {field:"AddCountDesc",title:"术中加数",width:120},
        {field:"PreCloseCount",title:"关前清点",width:76},
        {field:"PostCloseCount",title:"关后清点",width:76},
        {field:"PostSewCount",title:"缝皮后清点",width:80}
    ]];

    $("#instrumentsBox").datagrid({
        fit: true,
        title:"手术器械清点记录",
        headerCls:"panel-header-gray",
        checkOnSelect:false,
        selectOnCheck:false,
        singleSelect: false,
        pagination: false,
        iconCls:"icon-paper",
        url: ANCSP.DataQuery,
        columns: columns,
        queryParams: {
            ClassName: ANCLS.BLL.DataQueries,
            QueryName: "FindSurInventory",
            Arg1: session.RecordSheetID,
            ArgCnt: 1
        }
    });
}

function initDressingsBox(){
    var columns=[[
        {field:"SurgicalMaterial",title:"手术物品ID",hidden:true},
        {field:"MaterialNote",title:"手术物品",width:100},
        {field:"PreopCount",title:"术前清点",width:76},
        {field:"OperAddCount",title:"术中加数(数值)",hidden:true},
        {field:"AddCountDesc",title:"术中加数",width:120},
        {field:"PreCloseCount",title:"关前清点",width:76},
        {field:"PostCloseCount",title:"关后清点",width:76},
        {field:"PostSewCount",title:"缝皮后清点",width:80}
    ]];

    $("#dressingsBox").datagrid({
        fit: true,
        title:"手术敷料清点记录",
        headerCls:"panel-header-gray",
        checkOnSelect:false,
        selectOnCheck:false,
        singleSelect: false,
        pagination: false,
        iconCls:"icon-paper",
        url: ANCSP.DataQuery,
        columns: columns,
        queryParams: {
            ClassName: ANCLS.BLL.DataQueries,
            QueryName: "FindDressingInventory",
            Arg1: session.RecordSheetID,
            ArgCnt: 1
        }
    });

}

$(document).ready(initPage);

