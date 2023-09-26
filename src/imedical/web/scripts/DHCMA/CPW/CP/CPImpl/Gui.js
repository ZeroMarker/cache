var obj = new Object();	
function InitCPImplWin(){
    $.parser.parse(); // 解析整个页面  
    var DivWidth=$("#CPW-main").width();
	obj.PathwayID="";
	obj.MrListID="";
	obj.StepSelecedID="";
	
	//主要诊疗工作
	obj.gridTreatment = $HUI.datagrid("#tb-Treatment",{
		fit: true,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		//pageSize: 20,
		//pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.CPS.ImplementSrv",
			QueryName:"QryCPWStepInfo",		
			aPathwayID: obj.PathwayID, 
			aEpisID: obj.PathwayID+"||"+obj.StepSelecedID,
			aType:"T" 
	    },
		columns:[[
			{field:'Operation',title:'操作',align:'center',width:DivWidth*0.05,
				formatter: function(value,row,index){
					var retStr = "";
					var RowID=row["ID"];
					if (value.split("^")[0]==1) {
						retStr = retStr + '<img class="Operimg img-TOper" onclick="obj.ExecuteItem('+RowID+')" title="执行" style="cursor:pointer;margin:0 10px;border-radius:50%" src="../scripts/DHCMA/img/add.png"></img>';
					}
					if (value.split("^")[1]==1) {
						retStr = retStr + '<img class="Operimg img-TOper" onclick="obj.CancelItem('+RowID+')" title="撤销" style="cursor:pointer;margin:0 10px;border-radius:50%" src="../scripts/DHCMA/img/no.png"></img>';
					}
					return retStr;
				}
			},
			{field:'IndexNo',title:'序号',align:'center',width:DivWidth*0.05},
			{field:'ItemInfo',title:'项目内容',width:DivWidth*0.5},
			{field:'IsRequired',title:'是否必选',align:'center',width:DivWidth*0.06,
				formatter: function(value,row,index){
					var retStr = "";
					if (value==1) {
						retStr = retStr + '<img title="必须执行" style="margin:0 25px;border-radius:50%" src="../scripts/DHCMA/img/ok.png"></img>';
					}
					return retStr;
				}
			}, 
			{field:'OperInfo',title:'执行信息',width:DivWidth*0.3}	
		]],
		onBeforeLoad: function (param) {
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
			
            return true;
		},
		onLoadSuccess: function(data) {
			obj.OperationControl();
		},
		rowStyler: function(index,row){
			if (parseInt(row["IsImp"])>0){
				return 'color:#509DE1;'; 
			}else{
				return 'color:#000000;'; 
			}
		}
	});
	//主要护理工作
	obj.gridNursing = $HUI.datagrid("#tb-Nursing",{
		fit: true,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		//pageSize: 20,
		//pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.CPS.ImplementSrv",
			QueryName:"QryCPWStepInfo",		
			aPathwayID: "", 	
			aEpisID: "", 
			aType:"N" 
	    },
		columns:[[
			{field:'Operation',title:'操作',align:'center',width:DivWidth*0.05,
				formatter: function(value,row,index){
					var retStr = "";
					var RowID=row["ID"];
					if (value.split("^")[0]==1) {
						retStr = retStr + '<img class="Operimg img-NOper" onclick="obj.ExecuteItem('+RowID+')" title="执行" style="cursor:pointer;margin:0 10px;border-radius:50%" src="../scripts/DHCMA/img/add.png"></img>';
					}
					if (value.split("^")[1]==1) {
						retStr = retStr + '<img class="Operimg img-NOper" onclick="obj.CancelItem('+RowID+')" title="撤销" style="cursor:pointer;margin:0 10px;border-radius:50%" src="../scripts/DHCMA/img/no.png"></img>';
					}
					return retStr;
				}
			},
			{field:'IndexNo',title:'序号',align:'center',width:DivWidth*0.05},
			{field:'ItemInfo',title:'项目内容',width:DivWidth*0.5},
			{field:'IsRequired',title:'是否必选',align:'center',width:DivWidth*0.06,
				formatter: function(value,row,index){
					var retStr = "";
					if (value==1) {
						retStr = retStr + '<img title="必须执行" style="margin:0 25px;border-radius:50%" src="../scripts/DHCMA/img/ok.png"></img>';
					}
					return retStr;
				}
			}, 
			{field:'OperInfo',title:'执行信息',width:DivWidth*0.3}	
		]],
		onBeforeLoad: function (param) {
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
            return true;
		},
		onLoadSuccess: function(data) {
			obj.OperationControl();
		},
		rowStyler: function(index,row){
			if (parseInt(row["IsImp"])>0){
				return 'color:#509DE1;'; 
			}else{
				return 'color:#000000;'; 
			}
		}
	});
	
	//重点医嘱
	obj.gridOrder = $HUI.datagrid("#tb-Order",{
		fit: true,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		//pageSize: 20,
		//pageList : [20,50,100,200],
		sortName:"IndexNo",
		sortOrder:"asc",
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.CPS.ImplementSrv",
			QueryName:"QryCPWStepInfo",		
			aPathwayID: "", 	
			aEpisID: "", 
			aType:"O" 
	    },
		columns:[[
			/* {field:'Operation',title:'操作',align:'center',width:DivWidth*0.05,
				formatter: function(value,row,index){
					var retStr = "";
					var RowID=row["ID"];
					if (value.split("^")[0]==1) {
						retStr = retStr + '<img onclick="obj.ExecuteOrder('+RowID+')" title="执行" style="cursor:pointer;margin:0 10px;border-radius:50%" src="../scripts/DHCMA/img/add.png"></img>';
					}
					if (value.split("^")[1]==1) {
						retStr = retStr + '<img onclick="obj.CancelOrder('+RowID+')" title="撤销" style="cursor:pointer;margin:0 10px;border-radius:50%" src="../scripts/DHCMA/img/no.png"></img>';
					}
					return retStr;
				}
			}, */
			{field:'IndexNo',title:'序号',align:'center',width:DivWidth*0.05},
			{field:'ItemInfo',title:'项目内容',width:DivWidth*0.5},
			{field:'IsRequired',title:'是否必选',align:'center',width:DivWidth*0.06,
				formatter: function(value,row,index){
					var retStr = "";
					if (value==1) {
						retStr = retStr + '<img title="必须执行" style="margin:0 25px;border-radius:50%" src="../scripts/DHCMA/img/ok.png"></img>';
					}
					return retStr;
				}
			}, 
			{field:'OperInfo',title:'执行信息',width:DivWidth*0.3}	
		]],
		onBeforeLoad: function (param) {
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
            return true;
		},
		rowStyler: function(index,row){
			if (parseInt(row["IsImp"])>0){
				return 'color:#509DE1;'; 
			}else{
				return 'color:#000000;'; 
			}
		}
	});
	//路径外医嘱
	obj.gridVarOrder = $HUI.datagrid("#tb-Variation-Order",{
		fit: true,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		//pageSize: 20,
		//pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.CPS.ImplementSrv",
			QueryName:"QryCPWVarOrder",		
			aPathwayID: "", 
			aEpisID:"" 
	    },
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',width:30,auto:false},
			{field:'ind',title:'序号',align:'center',width:''},
			{field:'ARCIMDesc',title:'医嘱描述',width:'300'},
			{field:'VariatCat',title:'变异原因',width:'200'},
			{field:'VariatTxt',title:'具体原因',width:'200',editor:'text'}
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
		,onCheck:function(rindex,rowData){			
			if (rindex>-1) {
				$('#tb-Variation-Order').datagrid("beginEdit", rindex);
				var ed = $(this).datagrid('getEditor', {index:rindex,field:'VariatTxt'});
				$(ed.target).focus();
			}
			
		},
		onClickRow: function(rowIndex,rowData){			
			$('#tb-Variation-Order').datagrid('selectRow', rowIndex)
				.datagrid('beginEdit', rowIndex);	
			var ed = $(this).datagrid('getEditor', {index:rowIndex,field:'VariatTxt'});
			$(ed.target).focus();
		}
	});
	
	//未执行项目
	obj.gridVarItem = $HUI.datagrid("#tb-Variation-Item",{
		fit: true,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		//pageSize: 20,
		//pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.CPS.ImplementSrv",
			QueryName:"QryCPWVarItem",		
			aPathwayID: "", 	
			aEpisID: ""
	    },
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',width:30,auto:false},
			{field:'ind',title:'序号',align:'center',width:''},
			{field:'TypeDesc',title:'分类',width:''},
			{field:'ItemDesc',title:'内容',width:'400'},
			{field:'VariatCat',title:'变异原因',width:'200'},
			{field:'VariatTxt',title:'具体原因',width:'200',editor:'text'}
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
		,onCheck:function(rindex,rowData){			
			if (rindex>-1) {
				$('#tb-Variation-Item').datagrid("beginEdit", rindex);
				var ed = $(this).datagrid('getEditor', {index:rindex,field:'VariatTxt'});
				$(ed.target).focus();
			}
			
		},
		onClickRow: function(rowIndex,rowData){			
			$('#tb-Variation-Item').datagrid('selectRow', rowIndex)
				.datagrid('beginEdit', rowIndex);	
			var ed = $(this).datagrid('getEditor', {index:rowIndex,field:'VariatTxt'});
			$(ed.target).focus();
		}
	});
	
	obj.OutReason = $HUI.combobox('#OutReason', {
		url: $URL,
		editable: false,
		placeholder:'请选择',
		valueField: 'VarID',
		textField: 'Desc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathVariatSrv';
			param.QueryName = 'QryVerByTypeCat';
			param.aTypeCode = '02';
			param.aCatCode = '';
			param.ResultSetType = 'array';
		},
	});
	$("#CPWPatList").lookup({
		url:$URL+"?ClassName=DHCMA.CPW.CPS.InterfaceSrv&QueryName=QryCPWVPatByWard&ResultSetType=array",
		mode:'remote',
		idField:'EpisodeID',
		textField:'PatName',
		columns:[[
			{field:'BedNo',title:'床号',width:50},  
			{field:'PapmiNo',title:'登记号',width:100},
			{field:'PatName',title:'姓名',width:100},
			{field:'PatSex',title:'性别',width:50},
			{field:'Status',title:'状态',width:50}
		]],
		pagination:false,
		onSelect:function(index,rowData){
			EpisodeID=rowData['EpisodeID'];
			obj.InitCPWInfo();
		},
		panelWidth:380,
		editable:false,
		minQueryLen:3
	});
	
	obj.serchType="myloc";
	obj.searchValue=""
	$("#CPWLocType").keywords({
	    singleSelect:true,
	    labelCls:'blue',
	    items:[
	        {text:'关联路径',id:'myloc',selected:true},
	        {text:'所有路径',id:'othloc'}
	    ],
	    onClick:function(v){
		    obj.serchType=v.id;
			obj.SearchCPW();
		}
	});
	$('#CPWSearch').searchbox({ 
		searcher:function(value){
			obj.searchValue=value;
			obj.SearchCPW();
		}
	}); 

	InitCPImplWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


