$(function(){
	
	
	InitForm()
	$('#btnfindloc').bind('click', function() {
		FindLocData();
	});
		//-----查找手术
	$('#btnfindoper').bind('click', function() {
		FindOperData();
	});

});
	
	function FindOperData() {
		$HUI.datagrid("#operData").load(	);
	}

	function FindLocData() {
		$HUI.datagrid("#ctlocData",{
			queryParams: {
				ClassName: "web.DHCClinicCom",
				QueryName: "FindLocList",
				desc: $("#ctloc").combobox("getText"),
				locListCodeStr: "INOPDEPT^OUTOPDEPT^EMOPDEPT",
				EpisodeID: ""
			}});
	}
	//-------------------------
	function InitForm() {
	
		var objctloc=$HUI.combobox("#ctloc",{
		url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array",
		valueField:'ctlocId',
		textField:'ctlocDesc',
		onBeforeLoad:function(param){
			param.desc=param.q;
			param.locListCodeStr ='INOPDEPT^OUTOPDEPT^EMOPDEPT';
			param.EpisodeID = "";
		},
		onLoadSuccess:function(data) {
			    }	
	});
	var ctlocDataObj=$HUI.datagrid("#ctlocData",{
			url: $URL,
			pagination: true,
		pageSize: 50,
		pageNumber: 1,
		pageList: [10, 20, 30, 40,50],
			queryParams: {
				ClassName: "web.DHCClinicCom",
				QueryName: "FindLocList",
				desc: $("#ctloc").combobox("getText"),
				locListCodeStr: "INOPDEPT^OUTOPDEPT^EMOPDEPT",
				EpisodeID: ""
			},
			columns: [
				[
				{ field: "check",checkbox:true },
				{
					field: 'ctlocDesc',
					title: '科室名称',
					width:180
				}
				,{
					field: 'ctlocId',
					title: '科室ID',
					width:60
				}
				, {
					field: 'ctlocCode',
					title: '科室代码',
					hidden: true
				}]
			],
			onClickRow: function(rowIndex, rowData) {
			selectid = rowData["ctlocId"];
			$('#ctlocData').datagrid('clearSelections');
			$('#ctlocData').datagrid('selectRow',rowIndex);
			
		},
		onCheck: function(rowIndex, rowData) {
			selectid = rowData["ctlocId"]
			var ctlocdata = $('#ctlocData').datagrid('getSelections');
			var ctlocdatalen = ctlocdata.length;
			if(ctlocdatalen>1) {
					$('#operAuthData').datagrid({
					queryParams: {
						ClassName: "web.DHCOPDocLocAuthorize",
						QueryName: "FindLocOperation"
					},
					onBeforeLoad:function(param)
        			{
            			param.ctlocdr="";
        			}
				}) 
				return;
			}
			else
			{
  				$('#operAuthData').datagrid({
					queryParams: {
						ClassName: "web.DHCOPDocLocAuthorize",
						QueryName: "FindLocOperation"
					},
					onBeforeLoad:function(param)
        			{
            			param.ctlocdr=selectid;
        			}
				})
			}
		}

		});		
		
		 var operList=$HUI.datagrid("#operData",{
		 url:$URL,
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
			var objoplev=$HUI.combobox("#oplevel",{
		url:$URL+"?ClassName=web.DHCANCOrc&QueryName=FindORCOperationCategory&ResultSetType=array",
		valueField:'operCategId',
		textField:'operCategLDesc',
		multiple:false,
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
	////已授权手术
 var operAuList=$HUI.datagrid("#operAuthData",{
	  title:'已授权手术列表',
        headerCls:'panel-header-gray',
		 url:$URL,
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
				width: 120
			}, {
				field: 'tOperId',
				title: '手术ID'
			}
			,{
				field: 'tANCLocDr',
				title: 'tANCLocDr',
				hidden:true
				}
			,{
				field: 'tANCLoc',
				title: 'tANCLoc',
				hidden:true
				}
			,
			{
				field: 'tRowId',
				title: 'tRowId'
				}
			]]
		,toolbar:[
				{
		    		iconCls: 'icon-add',
	                text:'添加授权',          
	                handler: function(){
	                     AddLocOperAuthData();
	                	}
	    			},
	    			{
		    		iconCls: 'icon-remove',
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
	
	}
//--------------------
//添加授权
	function AddLocOperAuthData() {
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
			alert("请选择手术")
			return;
		}
		//
		var ctlocdata = $('#ctlocData').datagrid('getSelections');
		var ctlocdatalen = ctlocdata.length;
		var ctlocdatastr = "";
		if(ctlocdatalen > 0) {
			for(var i = 0; i < ctlocdatalen; i++) {
				var ctlocid = ctlocdata[i].ctlocId;
				if(ctlocdatastr == "") {
					ctlocdatastr = ctlocid;
				} else {
					ctlocdatastr = ctlocdatastr + "^" + ctlocid;
				}
			}
		}
		if(ctlocdatastr=="")
		{
			alert("请选择科室")
			return;
		}
		
		var data=$.m({
        ClassName:"web.DHCOPDocLocAuthorize",
        MethodName:"AddLocOperAuth",
        ctlocIdStr:ctlocdatastr, 
        operIdStr:operdatastr
    		},false);
		if(data==0)
		{
			alert("保存成功");
			$('#ctlocData').datagrid('clearSelections');
			$('#operData').datagrid('clearSelections');
		}
	
	}

//删除授权
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
		
			var data=$.m({
        ClassName:"web.DHCOPDocLocAuthorize",
        MethodName:"DeleteLocAuthOper",
        rowIdStr:operIdStr 
    		},false);
		if(data==0)
		{
			alert("删除成功")
			$('#operAuthData').datagrid({
					queryParams: {
						ClassName: "web.DHCOPDocLocAuthorize",
						QueryName: "FindLocOperation"
					},
					onBeforeLoad:function(param)
        			{
            			param.ctlocdr=selectid;
        			}
				})
		}
}
		
		