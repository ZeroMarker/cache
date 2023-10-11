function InitLocVirusSpecWinEvent(obj){
   	//初始化
    obj.LoadEvent=function(){
		//加载表格
		obj.refreshVirusQry();
	}
	
   	//查询
    $('#btnQuery').click(function (e) {
        obj.refreshVirusQry();
    });
    //导出事件
    $('#btnExport').on('click', function () {
		var rows = $('#gridLocVirusSpec').datagrid('getRows');//返回当前页的所有行
        if(rows.length==0){
	        $.messager.alert("错误","无记录数据,不允许导出!", 'info');
			return;
	    }
        $('#gridLocVirusSpec').datagrid('toExcel', '特殊病原体列表.xls');   //导出
    });
    //检索框
    $('#searchbox').searchbox({
        searcher: function (value, name) {
	        if(value=="") {
		       $('#btnQuery').click();
		    } else {
			    searchText($("#gridINFOPSQry"), value);
			}           
        }
    });
    	//获取弹窗方式 0为窗口 1为csp
	obj.flg = $m({
		ClassName:"DHCHAI.BT.Config",
		MethodName:"GetValByCode",
		aCode:"IsShowModal"
		},false);
	//获取当前页面的缩放值
	function detectZoom() {
		var ratio = 1;
		if(BrowserVer=="isChrome") {   //医为浏览器为 Chrome 49
			var userAgent = navigator.userAgent;
            var ChromePos = userAgent.indexOf("Chrome");  //Chrome定位
            var ChromeStr = userAgent.substr(ChromePos);  //Chrome串
            var ChromeArr = ChromeStr.split(" ");
            var ChromeVer = parseInt(ChromeArr[0].split("/")[1]);      //Chrome版本
			if (ChromeVer<=58) {    
				ratio = window.devicePixelRatio;
			}
		}
		return ratio;
	}
   	//摘要
	obj.btnAbstractMsg_Click = function(EpisodeID)
	{	
		var ratio =detectZoom();
		var PageWidth=Math.round(1320*ratio);
		 var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&PageType=WinOpen';
		 //var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&1=1';
		 if(obj.flg=="1"){
			 websys_showModal({
				 url:url,
				 title:'医院感染集成视图',
				 iconCls:'icon-w-epr',
				 closable:true,
				 width:PageWidth,
				 height:'95%'
			 });
		 }
		 else{
			 websys_createWindow(url,"","width="+PageWidth+",height=95%");
		 }	
	 };
	//打开疑似筛查
	obj.OpenCCSingle = function(EpisodeID) {
		var strUrl = "./dhcma.hai.ir.patscreening.csp?1=1&EpisodeDr=" + EpisodeID;
		websys_showModal({
			url:strUrl,
			title:'疑似病例筛查',
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:true,
			width:'95%',
			height:'95%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){} 
		});
	}
    //刷新表
    obj.refreshVirusQry = function () {
        var aHospID 	= $('#cboHospital').combobox('getValue');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aDateType 	= $('#cboDateType').combobox('getValue');
		var aStatUnit   = Common_CheckboxValue('chkStatunit');
		var aVirusTest  = $('#cboVirusTest').combobox('getValues').join(',');
		var aAbFlag     = $("#chkaAbFlag").checkbox('getValue')? '1':'0';
		var aWarnHours  = $("#WarnHours").val();
		if (aStatUnit=="W"){
			aStatUnit=1;
		}else{
			aStatUnit=2;
		}
		if (aDateType == "") {
            $.messager.alert("提示", "日期类型不能为空!", 'info');
            return;
        }
		if (aDateFrom == "") {
            $.messager.alert("提示", "开始日期不能为空!", 'info');
            return;
        }
        if (aDateTo == "") {
            $.messager.alert("提示", "结束日期不能为空!", 'info');
            return;
        }
        if (Common_CompareDate(aDateFrom, Common_GetDate(new Date())) == 1) {
            $.messager.alert("提示", "开始日期不能大于当前日期!", 'info');
            return;
        }
		if (Common_CompareDate(aDateFrom, aDateTo) == 1) {
            $.messager.alert("提示", "开始日期不能大于结束日期!", 'info');
            return;
        }
        $("#gridLocVirusSpec").datagrid("loading");
        var Ret = $cm({
			ClassName:"DHCHAI.IRS.LocVirusSpecSrv",
			QueryName:"QryLocVirusSpecDtl",
			aHospIDs: aHospID,
			aDateType:aDateType,
			aDateFrom: aDateFrom,
            aDateTo: aDateTo,
            aSpecID:obj.SpecDr,
            aStatUnit:aStatUnit,
            aLocID: "",
            aSpecDesc:obj.SpecDesc,
            aVirusTest:aVirusTest,
            aAbFlag:aAbFlag,
            aWarnHours:aWarnHours,
            page: 1,
            rows: 99999
        }, function (rs) {
            $('#gridLocVirusSpec').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
		});
    }
}