//页面Gui
function InitCheckQueryWin(){
	var obj = new Object();		
    obj.Status="";
    $.parser.parse(); // 解析整个页面  
    
    //初始查询条件
    obj.cboSSHosp=Common_ComboToSSHosp("cboSSHosp",SSHospCode,"IMP");
	//医院科室联动
	$HUI.combobox('#cboSSHosp',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    Common_ComboToLoc("cboLoc","E","","I",HospID);
		   
	    }
    });
	
	/*obj.IsAdmin = 0;
	if (tDHCMedMenuOper) {
		if (tDHCMedMenuOper['admin'] == '1') {
			obj.IsAdmin=1;
		}
	}*/
    
	obj.DateTo = $('#DateTo').datebox('setValue', Common_GetDate(new Date()));// 日期初始赋值
    obj.DateFrom = $('#DateFrom').datebox('setValue', Common_GetDate(new Date()));
    var cboReportType = $HUI.combobox("#cboReportType",{
		url:$URL+'?ClassName=DHCMA.IMP.IPS.IMPRegisterSrv&QueryName=QryReportTypeList&&aIsActive=1&aIsOper=1&ResultSetType=Array',
		valueField:'BTID',
		textField:'BTDesc'
	});
	var cboSubStatus  = $HUI.combobox("#SubStatus",{
		url:$URL+'?ClassName=DHCMA.IMP.IPS.IMPRegisterSrv&QueryName=QryReportSubType&aTypeCode=IMPRegStatus&ResultSetType=Array',
		valueField:'BTID',
		textField:'BTDesc'
	});
	
   obj.GridCheckQuery = $HUI.datagrid("#GridCheckQuery",{
		fit: true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: true, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{title:'操作',width:45,field:'EpisodeID',align:'center',
				formatter: function(value,row,index){
					if (value=="") return "";
					var EpisodeID = row["EpisodeID"];
					var CategoryDR = row["IMPCateDr"];
					var IMPOrdNo = row["IMPOrdNo"];
					var CateDesc = row["IMPCateDesc"];
					var btn = '<a href="#" class="icon-paper-info" onclick="OpenReport(\'' + EpisodeID+'\',\''+CategoryDR+'\',\''+IMPOrdNo+'\',\''+CateDesc+ '\')">&nbsp;&nbsp;&nbsp;&nbsp;</a>';
					return btn;
				}
			}, 
			{field:'MrNo',title:'病案号',width:'80'},
			{field:'PatientName',title:'患者姓名',width:'80'},
			{field:'LocDesc',title:'科室',width:'80'}, 
			{field:'Ward',title:'病房',width:'120'},
			{field:'Sex',title:'性别',width:'50'},
			{field:'Age',title:'年龄',width:'50'},
			{field:'IMPCateDesc',title:'报告类型',width:'150'},
			{field:'StatusDesc',title:'填报状态',width:'80'},
			{field:'RegDate',title:'登记日期',width:'150'},
			{field:'RegUserDesc',title:'登记人',width:'80'},
			{field:'CheckDate',title:'审核日期',width:'100'},
			{field:'CheckUserDesc',title:'审核人',width:'150'}
		]],
		onBeforeLoad: function (param) {
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
            return true;
		}
	});
	
	OpenReport = function(EpisodeID,CategoryDR,IMPOrdNo,IMPCateDesc) {
		if (IMPCateDesc=="手术并发症"){
			var strUrl= "./dhcma.imp.ip.opercompreg.csp?1=1&EpisodeID=" + EpisodeID +"&CategoryDR="+CategoryDR+"&IMPOrdNo="+IMPOrdNo;
		    websys_showModal({
				url:strUrl,
				title:'手术并发症登记',
				iconCls:'icon-w-epr',  
				originWindow:window,
		        closable:false,
				width:1150,
				height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,  
				onBeforeClose:function(){
					obj.CheckQueryLoad(); //刷新
				} 
			});
    		//var oWin = window.open(strUrl,'',"height=" + (window.screen.availHeight - 50) + ",width=1150,top=0,left=100,resizable=no");
		}else if(IMPCateDesc=="非计划重返手术"){
			var strUrl= "./dhcma.imp.ip.urtoperreg.csp?1=1&EpisodeID=" + EpisodeID +"&CategoryDR="+CategoryDR+"&IMPOrdNo="+IMPOrdNo ;
	    	websys_showModal({
				url:strUrl,
				title:'非计划重返手术登记',
				iconCls:'icon-w-epr',  
				originWindow:window,
	        	closable:false,
				width:1150,
				height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,  
				onBeforeClose:function(){
					obj.CheckQueryLoad();//刷新
				} 
			});
		}else if(IMPCateDesc=="危重病例"){
			var strUrl= "./dhcma.imp.ip.criticalillreg.csp?1=1&EpisodeID=" + EpisodeID +"&CategoryDR="+CategoryDR+"&IMPOrdNo="+IMPOrdNo ;
	    	websys_showModal({
				url:strUrl,
				title:'危重病例报告',
				iconCls:'icon-w-epr',  
				originWindow:window,
	        	closable:false,
				width:1150,
				height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,  
				onBeforeClose:function(){
					obj.CheckQueryLoad(); //刷新
				} 
			});
		}else if (IMPCateDesc=="非计划重返住院"){
			var strUrl= "./dhcma.imp.ip.urthospreg.csp?1=1&EpisodeID=" + EpisodeID +"&CategoryDR="+CategoryDR+"&IMPOrdNo="+IMPOrdNo ;
	    	websys_showModal({
				url:strUrl,
				title:'非计划重返住院登记',
				iconCls:'icon-w-epr',  
				originWindow:window,
	        	closable:false,
				width:1150,
				height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,  
				onBeforeClose:function(){
					obj.CheckQueryLoad(); //刷新
				} 
			});
		}else if(IMPCateDesc=="长期住院"){
			var strUrl= "./dhcma.imp.ip.langhospreg.csp?1=1&EpisodeID=" + EpisodeID +"&CategoryDR="+CategoryDR+"&IMPOrdNo="+IMPOrdNo ;
	    	websys_showModal({
				url:strUrl,
				title:'长期住院报告',
				iconCls:'icon-w-epr',  
				originWindow:window,
	        	closable:false,
				width:1150,
				height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,  
				onBeforeClose:function(){
					obj.CheckQueryLoad(); //刷新
				} 
			});
		}else{
			$.messager.alert("提示", "该分类还没有登记表,不允许操作!",'info');
			return;
		}
		
	}
	
	InitCheckQueryWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


