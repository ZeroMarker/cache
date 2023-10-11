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
		    obj.cboLoc = Common_ComboToLoc("cboLoc","E","","I",HospID);
	    }
    });
	obj.DateFrom = Common_SetValue('DateFrom',Common_GetDate(new Date())); // 日期初始赋值
	obj.DateTo = Common_SetValue('DateTo',Common_GetDate(new Date()));
	
	obj.cboApplyType = $HUI.combobox('#cboApplyType', {
		url: $URL,
		editable: true,
		mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.Util.BTS.DictionarySrv';
			param.QueryName = 'QryDictByType';
			param.aTypeCode = 'CPWAppType';
			param.aIsActive = '1';
			param.ResultSetType = 'array';
		},
	});
	
   //状态
   obj.chkStatus = $HUI.combobox('#chkStatus', {
		url: $URL,
		editable: true,
		mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.Util.BTS.DictionarySrv';
			param.QueryName = 'QryDictByType';
			param.aTypeCode = 'CPWAppStatus';
			param.ResultSetType = 'array';
		},
	});
	
   obj.GridCheckQuery = $HUI.datagrid("#GridCheckQuery",{
		fit: true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		nowrap:false,
		/*
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.CPS.ApplySrv",
			QueryName:"QryApplyInfo",	
			aTypeID: Common_GetValue('cboApplyType'),
			aDateFrom: Common_GetValue('DateFrom'), 
			aDateTo:Common_GetValue('DateTo'), 
			aStatus: Common_GetValue('chkStatus'),
			aLocID:Common_GetValue('cboLoc'),
			aHospID:Common_GetValue('cboSSHosp'),
			aNotIn:$("#NotInPath").checkbox('getValue')? '1':''
	    },*/
		columns:[[
			{field:'PapmiNo',title:'登记号',width:'100'},
			{field:'MrNo',title:'病案号',width:'80'},
			{field:'PatName',title:'患者姓名',width:'100'},
			{field:'PatSex',title:'性别',width:'50'},
			{field:'PatAge',title:'年龄',width:'50'},
			{field:'LocDesc',title:'提交科室',width:'100'},
			{field:'TypeDesc',title:'类型',width:'90'}, 
			{field:'AppUserDesc',title:'提交医生',width:'80'},	
			{field:'MobilePhone',title:'医生电话',width:'100'},	
			/* {field:'StatusDesc',title:'状态',width:'50',
				 styler: function(value,row,index){
					var retStr = "", tmpStatusCode = row["StatusCode"];
					if (tmpStatusCode==1) {
						retStr =  'color:red;';
					} else if (tmpStatusCode==2) {
						retStr = 'color:green;';
					}else if (tmpStatusCode==3) {
						retStr = 'color:blue;';
					} else if (tmpStatusCode==0) {
						retStr = 'color:black;';
					} 
					return retStr;
				}
			},  */
			{field:'PathStatus',title:'路径状态',width:'100'},
			{field:'CPWDesc',title:'路径名称',width:'160'}, 
			{field:'Reason',title:'原因类型',width:'220'},
			{field:'ApplyTxt',title:'具体原因',width:'280'},
			{field:'ApplyDate',title:'提交日期',width:'100'},
			{field:'ShowEMR',title:'住院病历',width:'150',align:'center',sortable:true,
				formatter: function(value,row,index){
						return '<a href="#" onclick=DisplayEPRView('+row['PaadmID']+","+row['PatientID']+')>病历浏览</a>';
				}
			}
			/* {field:'VerNote',title:'拒绝原因',width:'200'} */
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
	
	// 查看病历浏览
	DisplayEPRView = function(EpisodeID,PatientID){
		var strUrl = cspUrl+"&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&2=2";
		websys_showModal({
			url:strUrl,
			title:'浏览病历',
			iconCls:'icon-w-edit',  
			//onBeforeClose:function(){alert('close')},
			//dataRow:{ParamRow:obj.ItemRowData},   //？
			originWindow:window,
			width:1300,
			height:600
		});
	};
	
	InitCheckQueryWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


