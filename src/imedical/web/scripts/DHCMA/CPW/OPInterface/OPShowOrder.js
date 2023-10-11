var objOrder = new Object();	
function ShowMakeOrderDialog(){
	var DivWidth=$("#CPW-main").width();
	//$.parser.parse(); // 解析整个页面
	objOrder.replaceIndex=-1;	//替换序号
	objOrder.IsHaveDown=[];
	objOrder.IsChecking=false;	//防止死循环
	objOrder.IsUnChecking=false;
	objOrder.OrdContent=[];
	objOrder.PathwayID=""
	//是否自动阶段确认配置检查
	objOrder.IsAutoCfmStep = $cm({
		ClassName:"DHCMA.Util.BT.Config",
		MethodName:"GetValueByCode",
		aCode:"CPWOPEvrInNewEp",
		dataType:"text"
	},false);
		
	//主要诊疗工作
	objOrder.gridTreatment = $HUI.datagrid("#tb-Treatment",{
		fit: true,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:$g('数据加载中...'),
		//pageSize: 20,
		//pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.OPCPS.ImplementSrv",
			QueryName:"QryCPWStepInfo",		
			aPathwayID: '', 
			aEpisID: '',
			aType:"T" 
	    },
		columns:[[
			{field:'Operation',title:'<img class="Operimg img-TOper" id="img-Execute" onclick=objOrder.ExecuteAllItem() title="全部执行" style="cursor:pointer;margin:0;border-radius:50%" src="../scripts/DHCMA/img/add.png"></img><img class="Operimg img-TOper" id="img-Cancle" onclick=objOrder.CancelAllItem() title="全部撤销" style="cursor:pointer;margin:0 10px;border-radius:50%" src="../scripts/DHCMA/img/no.png"></img>',align:'center',width:DivWidth*0.05,
				formatter: function(value,row,index){
					var retStr = "";
					var RowID=row["ID"];
					if (value.split("^")[0]==1) {
						retStr = retStr + '<img class="Operimg img-TOper" onclick="objOrder.ExecuteItem('+RowID+')" title="执行" style="cursor:pointer;margin:0 10px;border-radius:50%" src="../scripts/DHCMA/img/add.png"></img>';
					}
					if (value.split("^")[1]==1) {
						retStr = retStr + '<img class="Operimg img-TOper" onclick="objOrder.CancelItem('+RowID+')" title="撤销" style="cursor:pointer;margin:0 10px;border-radius:50%" src="../scripts/DHCMA/img/no.png"></img>';
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
			objOrder.OperationControl();
		},
		rowStyler: function(index,row){
			if (parseInt(row["IsImp"])>0){
				return 'color:#509DE1;'; 
			}else{
				return 'color:#000000;'; 
			}
		}
	});
	//关联医嘱列表
	objOrder.CPWItemOrder = $HUI.datagrid("#CPWItemOrder",{
		fit: true,
		showGroup: true,
		groupField:'ItemDesc',
		checkOnSelect:false,
		view: groupview,
		groupFormatter:function(value, rows){
			if(value==undefined) return;
			return value + $g(' , 共( ') + rows.length + $g(' )项');
		},
		scrollbarSize: 0,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:$g('数据加载中...'),
		//pageSize: 20,
		//pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			QueryName:"QryPathFormEpItemOrdAll",
			aPathFormEpDr:"",
			aPathFormEpItemDr:""
	    },
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',width:'',auto:false},
			//{field:'OrdGeneIDDesc',title:'通用名',width:'150'},
			{field:'OrdMastIDDesc',title:'医嘱名',width:'300',
				formatter: function(value,row,index){
					var FormOrdID=row['xID']
					if (FormOrdID.indexOf("FJ")>-1) {
						var FJid=FormOrdID.split(':')[1];
						FormOrdID=FormOrdID.split(':')[2]+"||"+FormOrdID.split(':')[1];
						var id=FormOrdID.split("||").join("-");
						var chkPosDesc=row['OrdChkPosID'].split("||")[0];
						return "<span id='"+id+"' onclick=objOrder.ClickOrdDesc("+index+");>"+value+chkPosDesc+"</span><label id= 'pop"+FJid+"' style='color:red;' onmouseover=objOrder.ShowFJDetail("+FJid+") onmouseout=objOrder.DestoryFJDetail("+FJid+")>["+$g("详细")+"]</label>"
					}else{
						var id=FormOrdID.split("||").join("-");
						var chkPosDesc=row['OrdChkPosID'].split("||")[0];
						return "<span id='"+id+"' onclick=objOrder.ClickOrdDesc("+index+");>"+value+" "+chkPosDesc+"</span>"
					}
				}
			},
			{field:'OrdLnkOrdDr',title:'关联号',width:'50'},
			{field:'OrdDoseQty',title:'单次剂量',width:'70'},
			{field:'OrdUOMIDDesc',title:'单位',width:'70'},
			{field:'OrdFreqIDDesc',title:'频次',width:'70'},
			{field:'OrdInstrucIDDesc',title:'用法',width:'70'},
			{field:'OrdDuratIDDesc',title:'疗程',width:'70'},
			{field:'OrdQty',title:'数量',width:'60'},
			{field:'OrdIsDefault',title:'首选医嘱',width:'70',formatter:function(v,r,i){
				if (v == 1) return $g('是')
				else return $g('否')	
			}},
			{field:'OrdIsFluInfu',title:'主医嘱',width:'70',formatter:function(v,r,i){
				if (v == 1) return $g('是')
				else return $g('否')	
			}},
			{field:'OrdTypeDrDesc',title:'分类标记',width:'70'},
			{field:'OrdPriorityIDDesc',title:'医嘱类型',width:'70'},
			{field:'OrdNote',title:'备注',width:'70'}
		]],
		onBeforeLoad: function (param) {
			objOrder.IsHaveDown=[];
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
			
            return true;
		},
		onLoadSuccess: function (data) {
			if (data.rows.length > 0) {
				for (var i = 0; i < data.rows.length; i++) {
					if(data.rows[i].OrdCatCode != OrderType){	//中西药区分
						//设为不可用
						$("input[type='checkbox']")[i+1].disabled = true;
						
						//直接过滤该行数据不显示
						//$("#CPWItemOrder").datagrid("deleteRow", i);
						//i=i-1;
					} else {
						if (data.rows[i].OrdIsDefault==$g("是")) {	//首选医嘱
							if(objOrder.IsHaveDown[data.rows[i].xID]==5){	//未执行
								$("#CPWItemOrder").datagrid("selectRow", i);
								$("#CPWItemOrder").datagrid("checkRow", i);
							}
						}
					}
				}
			}
        },
		onDblClickRow: function(index, row){
			if(row.OrdCatCode != OrderType){
				$.messager.popover({msg: $g('当前界面禁止操作该医嘱！'),type:'alert'});	
				return false;
			}
			if(row['xID'].indexOf("FJ")>-1){
				$.messager.popover({msg: $g('自定义方剂不支持此操作！'),type:'alert'});	
				return false;	
			}
			objOrder.replaceIndex=index;
			var selData = $('#CPWItemOrder').datagrid('getRows')[index];
			var ArcimID=selData['OrdMastID']
			var OrdMastIDDesc=selData['OrdMastIDDesc']
			$('#gridGeneOrder').datagrid('loadData',{rows:[],total:0});
			$cm({
				ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
				QueryName:"QryOrderListByGene",
				aEpisodeID:EpisodeID.split("!!")[0],
				aArcimID:ArcimID
			},function(rs){
				$('#gridGeneOrder').datagrid({'title':$g('当前医嘱：')+OrdMastIDDesc});
				$('#gridGeneOrder').datagrid('loadData',rs);
				$HUI.dialog('#GeneCPWDialog').open();	
			})
		},
		onClickCell: function(index,field,value){
			var selData = $('#CPWItemOrder').datagrid('getRows')[index];
			var FormOrdID=selData['xID']
			var id=FormOrdID.split("||").join("-")
		},
		onUnselect: function(index, row){
			var selData = $('#CPWItemOrder').datagrid('getRows')[index];
			var FormOrdID=selData['xID']
			var id=FormOrdID.split("||").join("-")
		},
		onCheckAll: function(rows){
			for (var i=0;i<rows.length;i++){
				if(rows[i].OrdCatCode != OrderType){
					$("#CPWItemOrder").datagrid("uncheckRow", i);
				}
			}
			var checkboxHeader = $('div.datagrid-header-check input[type=checkbox]');//取到全选全不选这个元素
			checkboxHeader.prop("checked","checked");//将其设置为checked即可
		},
		onCheck: function(index, row){
			if(objOrder.IsChecking) return;			
			var ordLinkNum=row['OrdLnkOrdDr'];
			if(ordLinkNum == "") return;
			objOrder.IsChecking=true;
			var Rows=$('#CPWItemOrder').datagrid('getRows');
			for (var ind=0;ind<Rows.length;ind++){
				if(index == ind) continue;
				var selData=Rows[ind];
				if(selData['OrdLnkOrdDr'] == ordLinkNum){	//相同关联号的医嘱同时操作
					$("#CPWItemOrder").datagrid("selectRow", ind);
					$("#CPWItemOrder").datagrid("checkRow", ind);
				}
			}
			objOrder.IsChecking=false;
		},
		onUncheck: function(index, row){
			if(objOrder.IsUnChecking) return;			
			var ordLinkNum=row['OrdLnkOrdDr'];
			if(ordLinkNum == "") return;
			objOrder.IsUnChecking=true;
			var Rows=$('#CPWItemOrder').datagrid('getRows');
			for (var ind=0;ind<Rows.length;ind++){
				if(index == ind) continue;
				var selData=Rows[ind];
				if(selData['OrdLnkOrdDr'] == ordLinkNum){	//相同关联号的医嘱同时操作
					$("#CPWItemOrder").datagrid("unselectRow", ind);
					$("#CPWItemOrder").datagrid("uncheckRow", ind);
				}
			}
			objOrder.IsUnChecking=false;
		},
		rowStyler: function(index,row){
			//未知原因，自动运行两次
			//用此方法控制只运行一次
			if(objOrder.IsHaveDown[row['xID']]>1) return
			objOrder.IsHaveDown[row['xID']]=2;
			var FormOrdID=row['xID'];
			var ret=$m({
				ClassName:"DHCMA.CPW.OPCPS.ImplementSrv",
				MethodName:"GetImpOrdInfo",
				aCPWID:objOrder.PathwayID,
				aEpisID:objOrder.StepSelecedID,
				aFormOrdID:FormOrdID
			},false);
			if(ret!=""){
				if (FormOrdID.indexOf("FJ")>-1) FormOrdID=FormOrdID.split(':')[2]+"||"+FormOrdID.split(':')[1]
				var id=FormOrdID.split("||").join("-")
				var content=ret.split("^")[1]
				objOrder.OrdContent[id]=content;
				if (ret.split("^")[0]==1){
					objOrder.IsHaveDown[row['xID']]=3;
					return 'color:#509DE1;'; 	//原医嘱
				}else{
					objOrder.IsHaveDown[row['xID']]=4;
					return 'color:#FD994A;'; 	//替换医嘱
				}
			}else{
				objOrder.IsHaveDown[row['xID']]=5;
				return 'color:#000000;'; 		//未执行
			}
		}
	});
	//路径外医嘱变异
	objOrder.gridVarOrder = $HUI.datagrid("#tb-Variation-Order",{
		fit: true,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:$g('数据加载中...'),
		//pageSize: 20,
		//pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.OPCPS.PathwayVarSrv",
			QueryName:"QryCPWVarOrder",		
			aPathwayID:"", 
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
			if (rindex>-1 && ServerObj.IsAutoCfmStep!='Y') {
				$('#tb-Variation-Order').datagrid("beginEdit", rindex);
				var ed = $(this).datagrid('getEditor', {index:rindex,field:'VariatTxt'});
				$(ed.target).focus();
			}
		},
		onClickRow: function(rowIndex,rowData){
			if (ServerObj.IsAutoCfmStep!='Y'){
				$('#tb-Variation-Order').datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);	
				var ed = $(this).datagrid('getEditor', {index:rowIndex,field:'VariatTxt'});
				$(ed.target).focus();	
			}	
			
		}
	});
	
	//未执行项目变异
	objOrder.gridVarItem = $HUI.datagrid("#tb-Variation-Item",{
		fit: true,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:$g('数据加载中...'),
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.OPCPS.PathwayVarSrv",
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
			if (rindex>-1 && ServerObj.IsAutoCfmStep!='Y') {
				$('#tb-Variation-Item').datagrid("beginEdit", rindex);
				var ed = $(this).datagrid('getEditor', {index:rindex,field:'VariatTxt'});
				$(ed.target).focus();
			}
			
		},
		onClickRow: function(rowIndex,rowData){
			if(ServerObj.IsAutoCfmStep!='Y')	{
				$('#tb-Variation-Item').datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);	
				var ed = $(this).datagrid('getEditor', {index:rowIndex,field:'VariatTxt'});
				$(ed.target).focus();
			}		
		}
	})
	
	//中药方剂变异列表变异
	objOrder.gridVarTCM = $HUI.datagrid("#tb-Variation-TCMVar",{
		fit: true,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:$g('数据加载中...'),
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.OPCPS.PathwayVarSrv",
			QueryName:"QryCPWTCMVar",		
			aPathwayID:"", 
			aEpisID:"" 
	    },
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',width:30,auto:false},
			{field:'ind',title:'序号',align:'center',width:''},
			{field:'ARCIMDesc',title:'医嘱描述',width:'200'},
			{field:'ImplDesc',title:'关联项目',width:'300'},
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
			if (rindex>-1 && ServerObj.IsAutoCfmStep!='Y') {
				$('#tb-Variation-TCMVar').datagrid("beginEdit", rindex);
				var ed = $(this).datagrid('getEditor', {index:rindex,field:'VariatTxt'});
				$(ed.target).focus();
			}
		},
		onClickRow: function(rowIndex,rowData){
			if (ServerObj.IsAutoCfmStep!='Y'){
				$('#tb-Variation-TCMVar').datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);	
				var ed = $(this).datagrid('getEditor', {index:rowIndex,field:'VariatTxt'});
				$(ed.target).focus();
			}	
		}
		,onLoadSuccess:function(data){

		}
	})
	
	//同通用名医嘱列表
  	objOrder.gridGeneOrder = $HUI.datagrid("#gridGeneOrder",{
		fit: true,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:$g('数据加载中...'),
		/*
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			QueryName:"QryOrderListByGene",
			aEpisodeID:"",
			aArcimID:""
	    },
	    */    
		columns:[[
			{field:'ArcimDesc',title:'医嘱名称',width:'300'},
			{field:'DoseQty',title:'单次剂量',width:'80'},
			{field:'FreqDesc',title:'频次',width:'80'},
			{field:'DuratDesc',title:'疗程',width:'80'},
			{field:'InstrucDesc',title:'用法',width:'80'},
			{field:'DoseUomDesc',title:'单位',width:'80'}
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
	var OutReason= $HUI.combobox('#OutReason', {
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
			param.aAdmType = 'O';
			param.ResultSetType = 'array';
		}
	});
	InitOPOrderWinEvent(objOrder);
	objOrder.LoadEvent(arguments);	

	return objOrder;
	
}
