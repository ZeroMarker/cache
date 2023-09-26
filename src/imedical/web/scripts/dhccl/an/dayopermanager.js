$(document).ready(function() {

	InitForm();
	var type=""
});
function InitForm() {
	//中间科室医护人员列表
var ctlocCtcpData=$HUI.datagrid("#ctlocCtcpData",{
        fit:true,
        //singleSelect: true,
        selectOnCheck:true,
        rownumbers: true,
        headerCls:'panel-header-gray',
        url:$URL,
        queryParams:{
            ClassName:"web.DHCOPDocLocAuthorize",
            QueryName:"FindCtcp"
        },
        onBeforeLoad:function(param)
        {
            param.OpDeptId=$('#ctloc').combobox('getValue');
            param.name=$('#name').val();
            param.WorkNo=$('#workno').val();
            param.OperId="";
        },	
	onClickRow: function(rowIndex, rowData) {
			selectctcpid = rowData["ctcpId"];
			$('#ctlocCtcpData').datagrid('clearSelections');
			$('#ctlocCtcpData').datagrid('selectRow',rowIndex);
			
		},
		onCheck: function(rowIndex, rowData) {
			selectctcpid = rowData["ctcpId"]
			var ctcpdata = $('#ctlocCtcpData').datagrid('getSelections');
			var ctcpdatalen = ctcpdata.length;
			if(ctcpdatalen>1) {
					$('#operAuthData').datagrid({
					queryParams: {
						ClassName: "web.DHCOPDocLocAuthorize",
						QueryName: "FindOrcDocOper",
					},
					onBeforeLoad:function(param)
        			{
            			param.OpDocId="";
        			}
				}) 
				return;
			}
			else
			{
  				$('#operAuthData').datagrid({
					queryParams: {
						ClassName: "web.DHCOPDocLocAuthorize",
						QueryName: "FindOrcDocOper",
					},
					onBeforeLoad:function(param)
        			{
            			param.OpDocId=selectctcpid;
        			}
				})
			}
		}
	    ,toolbar:[{     
	                iconCls: 'icon-addauth',
	                text:'添加授权', 
	                width: 120,        
	                handler: function(){
	                     AddCtcpOperData();
	                	}
	    			}
	    			,{     
	                iconCls: 'icon-delauth',
	                text:'取消授权',          
	                handler: function(){
	                     DeleteCtcpOperData();
	                	}
	    			}
	    			,{     
	                iconCls: 'icon-adddayauth',
	                text:'日间授权',          
	                handler: function(){
	                     AddDaySurgeryAuth();
	                	}
	    			},{     
	                iconCls: 'icon-deldayauth',
	                text:'取消日间授权',          
	                handler: function(){
	                     DeleteDaySurgeryAuth();
	                	}
	    			}
	    			],
		columns: [
			[
			{ field: "check",checkbox:true },
			{field: 'ctcpDesc',title: '医生',width: 80}, 
			{field: 'ctcpId',title: '医护人员Id',width: 90}, 
			{field: 'ctcpWorkNo',title: '工号',width: 70},
			{field: 'dayAuth',title: '日间',width: 70}]
		],
		pagination: true,
		pageSize: 50,
		pageNumber: 1,
		pageList: [10, 20, 30, 40,50]
	});
	
	//查找科室医护人员
	$('#btnfindctcp').bind('click', function() {
		 $HUI.datagrid("#ctlocCtcpData").load();
	});

	//----左侧手术列表
	 var operList=$HUI.datagrid("#operData",{
		 url:$URL,
		 height:460,
		 headerCls:'panel-header-gray',
		 displayMsg:'',
		queryParams: {
			ClassName: "web.DHCOPDocLocAuthorize",
			QueryName: "FindOperation"
		},
		onBeforeLoad:function(param)
        {
            param.operDescAlias=$('#opdesc').val();
            param.operCat=$('#oplevel').combobox('getValue');
            param.isDayOper=$("#IsDayOper").checkbox('getValue')?"Y":"N";
        },
		onClickRow: function(rowIndex, rowData) {
			//这块准备加选择手术筛选相关医护人员
			/*
			operId = rowData["rowid"]
			var operdata = $('#operData').datagrid('getSelections');
			var ctcpdatalen = operdata.length;
			if(ctcpdatalen>1) {
					var queryParams = $("#operAuthData").datagrid('options').queryParams;
	  				queryParams.ClassName="web.DHCOPDocLocAuthorize";
					queryParams.QueryName="FindOperCtcp";
        			queryParams.Arg1 = '';
  					$('#ctlocCtcpData').datagrid('reload',queryParams); 
				return;
			}
				$('#ctlocCtcpData').datagrid({
					queryParams: {
						ClassName: "web.DHCOPDocLocAuthorize",
						QueryName: "FindOperCtcp",
						Arg1: operId,
						ArgCnt: 1
					}
				})
				*/
		},
		columns: [
			[
			{ field: "check",checkbox:true },
			{
				field: 'OPTypeDes',
				title: '手术名称',
				width: 200
			}, {
				field: 'rowid',
				title: '手术ID'
			}
				]
		]		
		,pagination: true,
		pageSize: 50,
		pageNumber: 1,
		pageList: [10, 20, 30, 40,50]

	});
	//-----查找手术
	$('#btnfindoper').bind('click', function() {
		FindOperData();
	});

	function FindOperData() {
		$HUI.datagrid("#operData").load(	);
	}
	//日间手术授权
	function AddDaySurgeryAuth()
	{
		//
		var ctcpdata = $('#ctlocCtcpData').datagrid('getSelections');
		var ctcpdatalen = ctcpdata.length;
		var ctcpdatastr = "";
		if(ctcpdatalen > 0) {
			for(var i = 0; i < ctcpdatalen; i++) {
				var ctcpid = ctcpdata[i].ctcpId;
				if(ctcpdatastr == "") {
					ctcpdatastr = ctcpid;
				} else {
					ctcpdatastr = ctcpdatastr + "^" + ctcpid;
				}
			}
		}
		if(ctcpdatastr=="")
		{
			$.messager.alert("提示", "请选择医护人员", 'warning');
			return;
		}
		var data=$.m({
        ClassName:"web.DHCOPDocLocAuthorize",
        MethodName:"AddDayOperAuth",
        ctcpIdStr:ctcpdatastr 
    		},false);
		if(data==0)
		{
			$.messager.alert("提示", "授权成功", 'info');
			$('#ctlocCtcpData').datagrid('clearSelections');
			HUI.datagrid("#ctlocCtcpData").reload();
		}

	}
		//日间手术授权
	function DeleteDaySurgeryAuth()
	{
				//
		var ctcpdata = $('#ctlocCtcpData').datagrid('getSelections');
		var ctcpdatalen = ctcpdata.length;
		var ctcpdatastr = "";
		if(ctcpdatalen > 0) {
			for(var i = 0; i < ctcpdatalen; i++) {
				var ctcpid = ctcpdata[i].ctcpId;
				if(ctcpdatastr == "") {
					ctcpdatastr = ctcpid;
				} else {
					ctcpdatastr = ctcpdatastr + "^" + ctcpid;
				}
			}
		}
		if(ctcpdatastr=="")
		{
			$.messager.alert("提示", "请选择医护人员", 'warning');
			return;
		}
		var data=$.m({
        ClassName:"web.DHCOPDocLocAuthorize",
        MethodName:"DeleteDayOperAuth",
        ctcpIdStr:ctcpdatastr 
    		},false);
		if(data==0)
		{
			$.messager.alert("提示", "撤销授权成功", 'info');
		}
	}
////已授权手术
 var operAuList=$HUI.datagrid("#operAuthData",{
		 url:$URL,
        headerCls:'panel-header-gray',
        displayMsg:'',
		queryParams: {
			ClassName: "web.DHCOPDocLocAuthorize",
			QueryName: "FindOrcDocOper"
		},
		onBeforeLoad:function(param)
        {
            param.OpDocId="";
        },
		columns: [
			[
			{ field: "check",checkbox:true },
			{
				field: 'tOperDesc',
				title: '手术名称',
				width: 120,
				sortable: true
				
			}, {
				field: 'tOperId',
				title: '手术ID'
				,width: 1
				, hidden: true
			}
			,{
				field: 'tOperLevel',
				title: '级别'
				,width: 60
				}
			,{
				field: 'tDayOper',
				title: '日间'
				,width: 60
				}
			,
			{
				field: 'tRowId',
				title: 'tRowId'
				,width: 1
				, hidden: true
				}
			]]
		,toolbar:[
				{
		    		iconCls: 'icon-delauth',
	                text:'取消授权',          
	                handler: function(){
	                     deleteAuthOperData();
	                	}
	    			}
		]
		,pagination: true,
		pageSize: 50,
		pageNumber: 1,
		pageList: [10, 20, 30, 40,50]
	});


//---------------删除多个医护人员对应手术
function deleteAuthOperData()
{
	var operIdStr=""
		var rows = $('#operAuthData').datagrid('getSelections');
		var len = rows.length;
		if(len > 0) 
		{
			for(var i = 0; i < len; i++) {
				var operId = rows[i].tRowId;
				if(operIdStr!="")
				{
					operIdStr=operIdStr+"^"+operId
				}
				else
				{
					operIdStr=operId
				}
			}
		}
		if(operIdStr=="")
		{
			$.messager.alert("提示", "请选择一条记录", 'warning');
			return;
		}
			var data=$.m({
        ClassName:"web.DHCOPDocLocAuthorize",
        MethodName:"DeleteAuthOper",
        rowIdStr:operIdStr 
    		},false);
		if(data==0)
		{
			$.messager.alert("提示", "删除成功", 'info');
			$('#operAuthData').datagrid({
					queryParams: {
						ClassName: "web.DHCOPDocLocAuthorize",
						QueryName: "FindOrcDocOper",
					},
					onBeforeLoad:function(param)
        			{
            			param.OpDocId=selectctcpid;
        			}
				})
		}
			

		
}
	//---------------------添加医护人员相关手术
	function AddCtcpOperData() {
		var userId=session['LOGON.USERID'];
		//手术
		var operdatas = $('#operData').datagrid('getSelections');
		var operdataslen = operdatas.length;
		var operdatastr = "";
		if(operdataslen > 0) {
			for(var i = 0; i < operdataslen; i++) {
				var operid = operdatas[i].rowid;
				if(operdatastr == "") {
					operdatastr = operid;
				} else {
					operdatastr = operdatastr + "^" + operid;
				}
			}
		}
		if(operdatastr=="")
		{
			$.messager.alert("提示", "请选择手术", 'warning');
			return;
		}
		//
		var ctcpdata = $('#ctlocCtcpData').datagrid('getSelections');
		var ctcpdatalen = ctcpdata.length;
		var ctcpdatastr = "";
		if(ctcpdatalen > 0) {
			for(var i = 0; i < ctcpdatalen; i++) {
				var ctcpid = ctcpdata[i].ctcpId;
				if(ctcpdatastr == "") {
					ctcpdatastr = ctcpid;
				} else {
					ctcpdatastr = ctcpdatastr + "^" + ctcpid;
				}
			}
		}
		if(ctcpdatastr=="")
		{
			$.messager.alert("提示", "请选择医护人员", 'warning');
			return;
		}
		
		var data=$.m({
        ClassName:"web.DHCOPDocLocAuthorize",
        MethodName:"AddAuthOperSingle",
        ctcpIdStr:ctcpdatastr, 
        operIdStr:operdatastr,
         UserId:userId
    		},false);
		if(data==0)
		{
			$.messager.alert("提示", "保存成功", 'info');
			$('#ctlocCtcpData').datagrid('clearSelections');
			$('#operData').datagrid('clearSelections');
		}
	
	}
//收回手术授权
function DeleteCtcpOperData()
{
	var ctcpIdStr=""
	var rows = $('#ctlocCtcpData').datagrid('getSelections');
	var len = rows.length;
	if(len > 0) 
	{
		for(var i = 0; i < len; i++) {
			var opctcpId = rows[i].ctcpId;
			if(ctcpIdStr!="")
			{
				ctcpIdStr=ctcpIdStr+"^"+opctcpId
			}
			else
			{
				ctcpIdStr=opctcpId
			}
		}
	}
	if(ctcpIdStr=="")
		{
			$.messager.alert("提示", "请选择医护人员", 'warning');
			return;
		}
		
		var data=$.m({
        ClassName:"web.DHCOPDocLocAuthorize",
        MethodName:"DeleteDocOper",
        ctcpIdStr:ctcpIdStr
    		},false);
		if(data==0)
		{
			$.messager.alert("提示", "删除成功", 'info');
			$('#operAuthData').datagrid({
					queryParams: {
						ClassName: "web.DHCOPDocLocAuthorize",
						QueryName: "FindOrcDocOper",
					},
					onBeforeLoad:function(param)
        			{
            			param.OpDocId=selectctcpid;
        			}
				})
			
		}
		
}

//====================
	////////////////////////////////////////////////////////////////////////////////////
	
		var objCtloc=$HUI.combobox("#ctloc",{
		url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array",
		valueField:'ctlocId',
		textField:'ctlocDesc',
		multiple:false,
		onBeforeLoad:function(param){
			param.desc=param.q;
			param.locListCodeStr="INOPDEPT^OUTOPDEPT^EMOPDEPT";
			param.EpisodeID="";
		},
		onLoadSuccess:function(data) {
			    }
		,mode: "remote"	
		,columns: [
				[{
					field: 'ctlocId',
					title: '科室ID',
					hidden: true
				}, {
					field: 'ctlocDesc',
					title: '科室名称'
				}, {
					field: 'ctlocCode',
					title: '科室代码',
					hidden: true
				}]
			]
		});
		//
		var objoplev=$HUI.combobox("#oplevel",{
		url:$URL+"?ClassName=web.DHCANCOrc&QueryName=FindORCOperationCategory&ResultSetType=array",
		valueField:'operCategId',
		textField:'operCategLDesc',
		multiple:false,
		panelHeight:'auto',
		onBeforeLoad:function(param){
	
		},
		onLoadSuccess:function(data) {
			    }
		,mode: "remote"	
		,columns: [
				[{
					field: 'operCategLDesc',
					title: '分类',
					width: 100
				}, {
					field: 'operCategId',
					title: '分类ID'
				}]
			]
		});
	}

