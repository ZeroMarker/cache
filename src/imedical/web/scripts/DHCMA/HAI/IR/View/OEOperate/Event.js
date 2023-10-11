//页面Event
function InitOEANTListWinEvent(obj){
    obj.LoadEvent = function(args){
		//初始查询结果
		obj.refreshOprQry(); 
	}
     //检索框
     $('#searchbox').searchbox({
        searcher: function (value, name) {
            if(value=="") {
                obj.refreshOprQry();
            } else {
                searchText($("#gridOEItemList"), value,1);
            }           
        }
    });
     //刷新列表
     obj.refreshOprQry = function () {
       // $("#gridOEItemList").datagrid("loading");
        var Ret = $cm({
            ClassName: "DHCHAI.IRS.INFOPSSrv",
		    QueryName: "QryOperAnaesByAdm",
		    aEpisodeDr:PaadmID,
            page: 1,
            rows: 99999
       }, function (rs) {
           $('#gridOEItemList').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
       });
     }
}

