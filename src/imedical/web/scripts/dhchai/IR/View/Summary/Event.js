//页面Event
function InitSummaryWinEvent(obj){
	// 首次加载明细内容（视图时间内所有明细）
	obj.DateFrom = obj.Viewtitle[0].DateIndex;
    obj.DateTo   = obj.Viewtitle[obj.Viewtitle.length-1].DateIndex;
	refreshgridViewDetail();
	// 重新加载明细列表
	function refreshgridViewDetail(){
		if(obj.gridViewDetail==null)
		{
			var scrollY = $("body").height()-$("#ItemViewDiv").height()-parseInt($("#ItemViewDiv").css("margin-top"))-parseInt($("#ItemViewDiv").css("margin-bottom"))-$("table.dataTable thead th").height()+'px';
			obj.gridViewDetail = $("#gridViewDetail").DataTable({
				dom: 'rt'
				,ordering:false
				,autoWidth: false 
				,paging: false
				,keys: true
				,scrollY: scrollY
		    	,order: [[ 0, "desc" ]]
				,ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.CCInfViewSrv";
						d.QueryName = "QryInfViewDetail";
						d.Arg1=PaadmID;
						d.Arg2=obj.DateFrom;
						d.Arg3=obj.DateTo;
						d.ArgCnt = 3;
					}
				}
				,columns: [
					{"data": "ActDate"},
					{"data": "DiagStr"},
					{"data": "TreatStr"}
				]
				,drawCallback: function (settings) {
					$("#gridViewDetail").css("width","100%");
				}
			});
		}else{
			obj.gridViewDetail.ajax.reload();
		}
		$("#gridViewDetail_wrapper .dataTables_scrollBody").mCustomScrollbar({
			// scrollButtons: { enable: true },
			theme: "dark-thick",
			axis: "y"
		});
	}

    // 视图图标点击事件
    obj.gridItemView.on('click', 'td', function(){
    	var colInd = obj.gridItemView.cell(this).index().column;
        var rowInd = obj.gridItemView.cell(this).index().row;
        if (($("#td_view_"+rowInd+"_"+colInd +":has(img)").length==0)&&(!$("#td_view_"+rowInd+"_"+colInd).attr("title"))) return;   //td是否有img元素或title提示
        var DateIndex = obj.Viewtitle[0].DateIndex;
        var ViewDate = parseInt(DateIndex)+parseInt(colInd)-1;
        //加载明细列表 
        obj.DateFrom = ViewDate-7;
        obj.DateTo   = ViewDate+7;
	    refreshgridViewDetail();
    });

    // 视图表头提示
	for (var i=0;i<obj.Viewtitle.length;i++)
	{
		if (obj.Viewtitle[i].TransLoc=="") continue;
		var innerHtml = $("#gridItemView_wrapper th")[i+1].innerHTML;
		$("#gridItemView_wrapper th")[i+1].innerHTML='';
		var html = '<span id="tip" title="'+obj.Viewtitle[i].TransLoc + '">' + innerHtml + '</span>';
		$($("#gridItemView_wrapper th")[i+1]).append(html);
	}
}