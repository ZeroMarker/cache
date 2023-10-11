 //页面Event
function InitPARegWinEvent(obj) {
	obj.LoadEvent=function(){    
		$('#gridPAReg').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		obj.gridPARegLoad();	
	}
	//刷新表格
	obj.gridPARegLoad = function(){
		$cm ({
		   	ClassName: "DHCHAI.IRS.PDCARegSrv",
		    QueryName: "QryPARepList",
		    aLocID:obj.aLocID,
		    aUserID:obj.aUserID,
	    	page:1,
			rows:9999
		},function(rs){
			$('#gridPAReg').datagrid({loadFilter:pagerFilter}).datagrid('loadData',rs);					
		});
    }
    //点击'新增'PDCA报告
    $('#custtb > a').click(function (e) {
        var ModTypeID = $(this).attr('text');
       	if (ModTypeID=="") {
            $.messager.alert("提示", "PDCA项目为空!", 'info');
        }
        else if (ModTypeID == "btnExport") { //导出
        	var rows 			= obj.gridPAReg.getRows();  //返回当前页的所有行
        	if(rows.length==0){
	        	$.messager.alert("错误","当前界面没有数据，无法导出!", 'info');
				return;
	        }
        	
            $('#gridPAReg').datagrid('toExcel', 'PDCA项目登记.xls');   //导出
        }
        else{
	    	 obj.OpenPDCARep(ModTypeID,"","",obj.AdminPower);   //打开PDCA报告
	    }
    });
    //打开PDCA报告
    obj.OpenPDCARep = function (aModTypeID, aReportID,aSubID,aAdminPower) {
        var url = '../csp/dhcma.hai.ir.pdca.report.csp?&RegTypeID=' + aModTypeID + '&ReportID=' + aReportID+ '&SubID=' + aSubID + "&AdminPower=" + obj.AdminPower;
        websys_showModal({
            url: url,
            title: $g('PDCA项目登记表'),
            iconCls: 'icon-w-paper',
            width: '1320',
            height: '95%',
            onBeforeClose: function () {
                obj.gridPARegLoad();
            }
        });
    }
    //搜索
	$('#searchbox').searchbox({ 
		searcher:function(value,name){
			searchText($("#gridPAReg"),value);
		}	
	});
}