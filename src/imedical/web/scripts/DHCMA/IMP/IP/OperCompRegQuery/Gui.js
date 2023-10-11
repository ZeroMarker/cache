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
    var cboComplType = $HUI.combobox("#cboComplType",{
		url:$URL+'?ClassName=DHCMA.IMP.BTS.OperCompDicSrv&QueryName=QryOperCompDic&aIsActive=1&ResultSetType=Array',
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
					var CategoryDR = row["CategoryDR"];
					var IMPOrdNo = row["IMPOrdNo"];
					var btn = '<a href="#" class="icon-paper-info" onclick="OpenReport(\'' + EpisodeID+'\',\''+CategoryDR+'\',\''+IMPOrdNo+ '\')">&nbsp;&nbsp;&nbsp;&nbsp;</a>';
					return btn;
				}
			}, 
			{field:'MrNo',title:'病案号',width:'80'},
			{field:'PatientName',title:'患者姓名',width:'80'},
			{field:'LocDesc',title:'科室',width:'80'}, 
			{field:'Ward',title:'病房',width:'120'},
			{field:'Sex',title:'性别',width:'50'},
			{field:'Age',title:'年龄',width:'50'},
			{field:'Status',title:'填报状态',width:'80'},
			{field:'OperDesc',title:'手术名称',width:'150'},
			{field:'OperType',title:'手术类型',width:'80'},
			{field:'OperLocDesc',title:'手术科室',width:'100'},
			{field:'StartTime',title:'手术开始时间',width:'150'},
			{field:'EndTime',title:'手术结束时间',width:'150'},
			{field:'OpertorName',title:'手术医师',width:'100'},
			{field:'AnesMethod',title:'麻醉方式',width:'100'},
			{field:'Incision',title:'切口类型',width:'100'},
			{field:'ASAScorer',title:'ASA评分',width:'100'},
			{field:'ComplTypeDesc',title:'并发症类型',width:'150'},
			{field:'ComplDate',title:'发生日期',width:'100'},
			{field:'ComplLvlDesc',title:'并发症分级',width:'150'}
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
	
	OpenReport = function(aEpisodeID,CategoryDR,IMPOrdNo) {
		var strUrl= "./dhcma.imp.ip.opercompreg.csp?1=1&EpisodeID=" + aEpisodeID +"&CategoryDR="+CategoryDR+"&IMPOrdNo="+IMPOrdNo;
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
	}
	
	InitCheckQueryWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


