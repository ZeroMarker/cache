//页面Gui
function InitCheckQueryWin(){
	var obj = new Object();		
    
    $.parser.parse(); // 解析整个页面  
    
    //初始查询条件
    //obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp",SSHospCode,"CPW");
    var aHospID = session['LOGON.HOSPID']+"!!1";
    obj.cboSSHosp = Common_ComboToSSHosp2("cboSSHosp",aHospID,"");
	 //医院科室联动
	$HUI.combobox('#cboSSHosp',{
	    onSelect:function(rows){
		    var HospID=rows["OID"].split("!!")[0];
		    obj.cboLoc = Common_ComboToLoc("cboLoc","E","","O",HospID);
	    }
    });
	obj.DateFrom = Common_SetValue('DateFrom',Common_GetDate(new Date())); // 日期初始赋值
	obj.DateTo = Common_SetValue('DateTo',Common_GetDate(new Date()));
	
   obj.GridNotInPathQuery = $HUI.datagrid("#GridNotInPathQuery",{
		fit: true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		nowrap:false,
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.OPCPS.ApplySrv",
			QueryName:"QryNotInPathInfo",	
			aDateFrom: Common_GetValue('DateFrom'), 
			aDateTo:Common_GetValue('DateTo'),
			aHospID:Common_GetValue('cboSSHosp'), 
			aLocID:Common_GetValue('cboLoc')			
	    },
		columns:[[
//xVisitID,ApplyID,EpisodeID,PatientID,PaadmID,PapmiNo,PatName,PatSex,PatAge,CPWDesc,LocID,LocDesc,Reason,ApplyTxt,AppUserDesc,ApplyDate,MobilePhone,UserCode
			{field:'PapmiNo',title:'登记号',width:'100'},
			{field:'PatName',title:'患者姓名',width:'100'},
			{field:'PatSex',title:'性别',width:'50'},
			{field:'PatAge',title:'年龄',width:'50'},
			{field:'LocDesc',title:'申请科室',width:'100'},
			{field:'AppUserDesc',title:'申请医生',width:'80'},	
			//{field:'MobilePhone',title:'医生电话',width:'100'},	
			{field:'CPWDesc',title:'路径名称',width:'160'}, 
			{field:'Reason',title:'原因类型',width:'220'},
			{field:'ApplyTxt',title:'具体原因',width:'280'},
			{field:'ApplyDate',title:'申请日期',width:'100'}	
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
	
	InitNotInPathQueryWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


