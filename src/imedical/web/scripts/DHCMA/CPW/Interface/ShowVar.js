//window.onbeforeunload = BeforeClose;
function BeforeClose(e){
	e = e || window.event;

	if($('#CPWVarOrder').datagrid("getRows").length != 0){
		//删除已经添加的变异原因
		var ret=$m({ClassName:"DHCMA.CPW.CPS.InterfaceSrv",MethodName:"DeleteTmpVarOrd",aFlg:"Y"},false)
		if (websys_showModal("options").CallBackFunc) {
			websys_showModal("options").CallBackFunc(false);
		}else{
			window.returnValue = false;	//返回给医生站
		}
	}else{
		//清除临时数据
		var ret=$m({ClassName:"DHCMA.CPW.CPS.InterfaceSrv",MethodName:"DeleteTmpVarOrd",aFlg:"N"},false)
		if (websys_showModal("options").CallBackFunc) {
			websys_showModal("options").CallBackFunc(true);
		}else{
			window.returnValue = true;	//返回给医生站
		}
	}
}

var objVar = new Object();	
function ShowMakeOrderDialog(){
	$.parser.parse(); // 解析整个页面 
	InitVCPWInfo();
	
	$m({
		ClassName:"DHCMA.CPW.CPS.ImplementSrv",
		MethodName:"GetVariatTree",
		aTypeCode: "01", 
		aCatCode: ""
	},function(treeJson){
		var dataArr=$.parseJSON(treeJson)
		$('#VarTree').tree({
			data: dataArr,
			formatter:function(node){
				//formatter  此时isLeaf方法还无法判断是不是叶子节点 可通过children
				if (node.children){
					return node.text;
				}else{
					len=node.text.length;
					if (len<15) {
						return node.text;
					}else{
						return node.text.substring(0,15)+"<br />"+node.text.substring(15)
					}
					/* return "<div >"
						+"<span data-id='"+node.id+"' class='icon-write-order' style='display:block;width:16px;height:16px;position:absolute;right:5px;top:5px;'></span>"
						+"<div style='height:20px;line-height:20px;color:gray'>"+(new Date()).toLocaleString()+"</div>"
						+"<div style='height:20px;line-height:20px;'>"+node.text+"</div>"
						+"</div>";
					//同时给此树下的tree-node 加上position: relative;   以实现小图标靠右 */
				}
				
			},
			onClick: function(node){
				//alert(node.text);  // alert node text property when clicked
			},
			lines:true,autoNodeHeight:true
		})
	});	
	
	//关联医嘱
	objVar.CPWVarOrder = $HUI.datagrid("#CPWVarOrder",{
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
		    ClassName:"DHCMA.CPW.CPS.InterfaceSrv",
			QueryName:"QryCPWVarOrder",		
			aEpisodeID:EpisodeID, 
			aOEItmMastList:OEItmMastList,
			alocID:session['LOGON.CTLOCID'],
			aWardID:session['LOGON.WARDID']
	    },
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',width:30,auto:false},
			{field:'ind',title:'序号',align:'center',width:''},
			{field:'ARCIMDesc',title:'医嘱描述',width:'300'},
			//{field:'VariatCat',title:'变异分类',width:'200'},
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
				$('#CPWVarOrder').datagrid("beginEdit", rindex);
				var ed = $(this).datagrid('getEditor', {index:rindex,field:'VariatTxt'});
				$(ed.target).focus();
			}
			
		},
		onClickRow: function(rowIndex,rowData){			
			$('#CPWVarOrder').datagrid('selectRow', rowIndex)
				.datagrid('beginEdit', rowIndex);	
			var ed = $(this).datagrid('getEditor', {index:rowIndex,field:'VariatTxt'});
			$(ed.target).focus();
		}
	});
	
	//路径外医嘱保存变异信息
	$('#Var-Order-Save').on('click', function(){
		SaveOrderVar();
	})
	//路径外医嘱撤销变异信息
	$('#Var-Order-Cancel').on('click', function(){
		CancelOrderVar();
	})
		
}
//路径信息
InitVCPWInfo = function(){
	$m({
		ClassName:"DHCMA.CPW.CPS.ImplementSrv",
		MethodName:"GetCPWInfo",
		aEpisodeID:EpisodeID
	},function(JsonStr){
		var JsonObj=$.parseJSON( JsonStr ); 
		$('#VCPWDesc').text(JsonObj.CPWDesc)
		$('#VCPWEpisDesc').text(JsonObj.CPWEpisDesc)
		objVar.PathwayID=JsonObj.PathwayID;
		objVar.EpisID=JsonObj.CPWEpisID;
		
		objVar.CPWVarOrder.load({
			ClassName:"DHCMA.CPW.CPS.InterfaceSrv",
			QueryName:"QryCPWVarOrder",		
			aEpisodeID:EpisodeID, 
			aOEItmMastList:OEItmMastList,
			alocID:session['LOGON.CTLOCID'],
			aWardID:session['LOGON.WARDID']
		});	
	});
}
SaveOrderVar = function(){
	var Node=$('#VarTree').tree('getSelected');
	if(Node){
		var IsLeaf=$('#VarTree').tree('isLeaf',Node.target)
		if(IsLeaf){
			var rows = $('#CPWVarOrder').datagrid("getSelections");
			for (var ind=0,len=rows.length;ind<len;ind++){
				var RowIndex=$('#CPWVarOrder').datagrid("getRowIndex",rows[ind]);
				var ed = $('#CPWVarOrder').datagrid('getEditor', { index: RowIndex, field: 'VariatTxt' });
				var VariatTxt = ""
				if (ed) VariatTxt = $(ed.target).val();
				var rowData = rows[ind]
				var Node=$('#VarTree').tree('getSelected');
				var EpisID=objVar.PathwayID+"||"+objVar.EpisID;
				var ImplID="";	//路径外医嘱没有关联项目
				var OrdDID=rowData['ARCIMID'];
				var VarID=""
				
				var InputStr=objVar.PathwayID+"^"+VarID+"^"+Node.id.split("-")[1]+"^"+VariatTxt+"^"+EpisID+"^"+ImplID+"^"+OrdDID+"^"+session['DHCMA.USERID'];
				var ret=$m({
					ClassName:"DHCMA.CPW.CP.PathwayVar",
					MethodName:"Update",
					aInputStr:InputStr,
					aSeparete:"^"
				},false)
				if (parseInt(ret) > 0) {
					$('#CPWVarOrder').datagrid("deleteRow", RowIndex);
				}
			}
			$('#VarTree').find('.tree-node-selected').removeClass('tree-node-selected');
		}else{
			$.messager.popover({
					msg: '不能选择原因分类',
					type:'error',
					style:{
						top:150,
						left:450
					}
				});
			return;
		}
	}else{
		$.messager.popover({
			msg: '请选择变异原因',
			type:'error',
			style:{
				top:150,
				left:450
			}
		});
		return;
	}
	var OrdItemList = $('#CPWVarOrder').datagrid("getRows").length;
	websys_showModal("options").onBeforeClose(OrdItemList);
}
CancelOrderVar = function(){
	var rows = $('#CPWVarOrder').datagrid("getSelections");
	for (var ind=0,len=rows.length;ind<len;ind++){
		var VarID=rows[ind]['VarID'];
		if(VarID=="") continue;
		$m({
			ClassName:"DHCMA.CPW.CP.PathwayVar",
			MethodName:"Invalid",
			aID:objVar.PathwayID+"||"+VarID,
			aUserID:session['DHCMA.USERID']
		},function(ret){
			if(parseInt(ret)>0){
			}
		})
	}
	$('#CPWVarOrder').datagrid('reload');
}