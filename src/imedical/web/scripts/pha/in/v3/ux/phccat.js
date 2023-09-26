var PHA_IN_V1_UX_PHCCAT_RET={};	// 返回值
$(function () {
    InitTreeGridPhcCat();
    ReLoadUXPhcCat();
    $("#conAlias").searchbox({
        width: $("body").width()-45,
		placeholder:"请输入别名回车查询...",
        searcher: function(text) {
            $("#treegridPhcCat").treegrid("options").queryParams.InputStr = text;
            $("#treegridPhcCat").treegrid("reload");
            $("#conAlias").searchbox("clear");
            $("#conAlias")
                .next()
                .children()
                .focus();
        }
    });

});

function ReLoadUXPhcCat(){
	PHA_IN_V1_UX_PHCCAT_RET="";
	$("#treegridPhcCat").treegrid("options").queryParams.InputStr=""
	$("#treegridPhcCat").treegrid('reload');
}
function InitTreeGridPhcCat() {
    var _treeColumns = [
        [
            {
                field: "phcCatDesc",
                title: "药学分类",
                width: 300
            },
            {
                field: "phcCatDescAll",
                title: "药学分类全称",
                width: 300,
                hidden: true
            },
            {
                field: "phcCatId",
                title: "phcCatId",
                hidden: true
            },
            {
                field: "_parentId",
                title: "parentId",
                hidden: true
            }
        ]
    ];
    $("#treegridPhcCat").treegrid({
        animate: true,
        border: false,
        fit: true,
        nowrap: true,
        fitColumns: true,
        singleSelect: true,
        idField: "phcCatId",
        treeField: "phcCatDesc",
        rownumbers: false, //行号
        columns: _treeColumns,
        showHeader: false,
        url: $URL,
        queryParams: {
            ClassName: "PHA.STORE.Drug",
            QueryName: "DHCPHCCat",
            page: 1,
            rows: 9999
        },
        toolbar: "#treegridPhcCatBar",
        onDblClickRow: function(rowIndex, rowData) {
			PHA_IN_V1_UX_PHCCAT_RET={
				id:rowData.phcCatId,
				text:rowData.phcCatDescAll
			}
			
			top.$("#PHA_IN_V3_UX_PHCCAT").window("close"); 
        }
    });
}

