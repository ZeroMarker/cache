var objOrder = new Object();	
function ShowMakeOrderDialog(){
	$.parser.parse(); // 解析整个页面
	objOrder.replaceIndex=-1;	//替换序号
	objOrder.IsHaveDown=[];
	objOrder.IsChecking=false;	//防止死循环
	objOrder.IsUnChecking=false;
	objOrder.OrdContent=[];
	objOrder.SelectedOrds={rows:[],total:999}
	objOrder.tempCplFormID=""
	objOrder.tempFormEpID="";
	objOrder.tempFormEpItemID="";
	objOrder.OrdGroupID="";
	objOrder.curTabTitle=$g("主路径");
	objOrder.ARCOSCheckFlg=false;
	objOrder.JsonARCOSDetail = {};
	objOrder.StatusCurrDesc = "";
	
	InitOCPWInfo();
	$('#OStepMore').on('click', function(){
		var Emvalue = $('#OStepMore').attr("value");
		ShowOSetpMore(Emvalue);
	});
	$('#Addorder').on('click', function(){
		AddOrderToEntry();
	});
	$('#GetHelp').on('click', function(){
		$HUI.dialog('#HelpCPWDialog').open();
	});
	$('#OrdDesc').searchbox({ 
		prompt:$g('请输入关键字'),
		searcher:function(value){
			if (objOrder.curTabTitle==$g("主路径")){ 
				$cm ({
					ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
					QueryName:"QryPathFormEpItemOrdAll",
					ResultSetType:"array",
					aPathFormEpDr:objOrder.tempFormEpID,
					aPathFormEpItemDr:objOrder.tempFormEpItemID,
					aOrdDesc:value,
					aOrdGroupID:objOrder.OrdGroupID,
					aUserType:UserType,
					aEpisodeID:EpisodeID,
					aLgnLocID:session['DHCMA.CTLOCID'],
					page:1,
					rows:99999
				},function(rs){
					$('#CPWItemOrder').datagrid({groupField:'ItemDesc',loadFilter:pagerFilter}).datagrid('loadData', rs);				
				});
			}else{
				$cm ({
					ClassName:"DHCMA.CPW.CPS.PathwayComplSrv",
					QueryName:"QryComplFormOrdAll",
					ResultSetType:"array",
					aFormID:objOrder.tempCplFormID,
					aFormEpID:objOrder.tempFormEpID,
					aFormItemID:objOrder.tempFormEpItemID,
					aOrdDesc:value,
					aOrdGroupID:objOrder.OrdGroupID,
					aUserType:UserType,
					aEpisodeID:EpisodeID,
					aLgnLocID:session['DHCMA.CTLOCID'],
					page:1,
					rows:99999
				},function(rs){
					$('#CPWItemOrder').datagrid({groupField:'OrdBuzTypeDesc',loadFilter:pagerFilter}).datagrid('loadData', rs);				
				});	
			}
		}
	}); 
	
	$('#GeneReplace').on('click', function(){
		var selData = $('#gridGeneOrder').datagrid('getSelected')
		$('#CPWItemOrder').datagrid('updateRow',{
			index: objOrder.replaceIndex,
			row: {
				OrdMastIDDesc: selData['ArcimDesc'],
				OrdDoseQty: selData['DoseQty'],
				OrdUOMIDDesc: selData['DoseUomDesc'],
				OrdFreqIDDesc: selData['FreqDesc'],
				OrdInstrucIDDesc: selData['InstrucDesc'],
				OrdDuratIDDesc: selData['DuratDesc'],
				OrdMastID:selData['ArcimID'],
				OrdUOMID:selData['DoseUomDR'],
				OrdFreqID:selData['FreqDR'],
				OrdDuratID:selData['DuratDR'],
				OrdInstrucID:selData['InstrucDR']
			}
		});
		$HUI.dialog('#GeneCPWDialog').close();
	})
	
	//医嘱分组下拉框定义
	objOrder.cboOrdGroup = $HUI.combogrid('#cboOrdGroup', {
		url:$URL+"?ClassName=DHCMA.CPW.BTS.PathOrdGroupSrv&QueryName=QryPathOrdGroup&ResultSetType=array&aFormEpID="+objOrder.tempFormEpID,
		panelWidth:310,
		editable: false,
		placeholder:$g('全部医嘱'),
		idField: 'ID',
		textField: 'OrdGroupDesc',
		columns:[[
			{field:'OrdGroupDesc',title:'名称',width:100,sortable:true},    
        	{field:'OrdGroupNote',title:'备注',width:200,sortable:true} 
		]],
		onShowPanel: function () {
		   	$(this).combogrid('grid').datagrid("load",{
			   	ClassName:"DHCMA.CPW.BTS.PathOrdGroupSrv",
			   	QueryName:"QryPathOrdGroup",
			   	aFormEpID:objOrder.tempFormEpID
			});
		},
		onSelect:function(index,row){
			objOrder.OrdGroupID=row.ID;
			if (objOrder.curTabTitle==$g("主路径")){ 
				$cm ({
					ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
					QueryName:"QryPathFormEpItemOrdAll",
					ResultSetType:"array",
					aPathFormEpDr:objOrder.tempFormEpID,
					aPathFormEpItemDr:objOrder.tempFormEpItemID,
					aHospID:HospID,
					aOrdDesc:$('#OrdDesc').searchbox('getValue'),
					aOrdGroupID:objOrder.OrdGroupID,
					aUserType:UserType,
					aEpisodeID:EpisodeID,
					aLgnLocID:session['DHCMA.CTLOCID'],
					page:1,
					rows:99999
				},function(rs){
					$('#CPWItemOrder').datagrid({groupField:'ItemDesc',loadFilter:pagerFilter}).datagrid('loadData', rs);				
				});
			}else{
				$cm ({
					ClassName:"DHCMA.CPW.CPS.PathwayComplSrv",
					QueryName:"QryComplFormOrdAll",
					ResultSetType:"array",
					aFormID:objOrder.tempCplFormID,
					aFormEpID:objOrder.tempFormEpID,
					aFormItemID:objOrder.tempFormEpItemID,
					aHospID:HospID,
					aOrdDesc:$('#OrdDesc').searchbox('getValue'),
					aOrdGroupID:objOrder.OrdGroupID,
					aUserType:UserType,
					aEpisodeID:EpisodeID,
					aLgnLocID:session['DHCMA.CTLOCID'],
					page:1,
					rows:99999
				},function(rs){
					$('#CPWItemOrder').datagrid({groupField:'OrdBuzTypeDesc',loadFilter:pagerFilter}).datagrid('loadData', rs);				
				});	
			}
		}
	});
	
	//关联医嘱列表
	objOrder.CPWItemOrder = $HUI.datagrid("#CPWItemOrder",{
		fit: true,
		showGroup: true,
		checkOnSelect:false,
		view: groupview,
		groupFormatter:function(value, rows){
			if(value==undefined) return;
			return value + $g(' , 共( ') + rows.length + $g(' )项');
			},
		scrollbarSize: 0,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:$g('数据加载中...'),
		pageSize: 50,
		pageList : [50,100,200],
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
						return "<span id='"+id+"'>"+value+chkPosDesc+"</span><label id= 'pop"+FJid+"' style='color:red;' onmouseover=ShowFJDetail("+FJid+") onmouseout=DestoryFJDetail("+FJid+")>["+$g("详细")+"]</label>"
					}else if(row['OrdMastID'].indexOf("||")==-1){
						var ARCOSRowid=row['OrdMastID'];
						var ARCOSDesc=row['OrdMastIDDesc'];
						var id=FormOrdID.split("||").join("-");
						var chkPosDesc=row['OrdChkPosID'].split("||")[0];
						return "<span id='"+id+"'>"+value+chkPosDesc+"</span><label style='color:red;cursor:pointer' onclick=ShowARCOSDetail("+ARCOSRowid+",'"+ARCOSDesc+"',"+index+")>["+$g("明细")+"]</label>"
					}else{
						var id=FormOrdID.split("||").join("-");
						var chkPosDesc=row['OrdChkPosID'].split("||")[0];
						return "<span id='"+id+"'>"+value+" "+chkPosDesc+"</span>"
					}
					/*
					var id=row['xID'].split("||").join("-")
					var chkPosDesc=row['OrdChkPosID'].split("||")[0]
					return "<span id='"+id+"'>"+value+chkPosDesc+"</span>"
					*/
				}
			},
			{field:'OrdLnkOrdDr',title:'关联号',width:'50'},
			{field:'OrdDoseQty',title:'单次剂量',width:'70'},
			{field:'OrdUOMIDDesc',title:'单位',width:'70'},
			{field:'OrdFreqIDDesc',title:'频次',width:'70'},
			{field:'OrdInstrucIDDesc',title:'用法',width:'70'},
			{field:'OrdDuratIDDesc',title:'疗程',width:'70'},
			{field:'OrdQty',title:'数量',width:'60'},
			{field:'OrdQtyUomDesc',title:'数量单位',width:'70'},
			{field:'OrdIncilQty',title:'库存',width:'100'},
			{field:'OrdIsDefault',title:'首选医嘱',width:'70',formatter:function(v,r,i){
				if (v == "1") return $g('是');
				else return $g('否');
			}},
			{field:'OrdIsFluInfu',title:'主医嘱',width:'70',formatter:function(v,r,i){
				if (v == "1") return $g('是');
				else return $g('否');
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
					data.rows[i].tabType=objOrder.curTabTitle;					//为所选行对象添加tab类型区分，方便后续处理
					if(data.rows[i].OrdCatCode != OrderType){
						// 类型不一致设为不可用
						$("input[type='checkbox']")[i+1].disabled = true;
						
						//直接过滤该行数据不显示
						//$("#CPWItemOrder").datagrid("deleteRow", i);
						//i=i-1;
					} else {
						if (data.rows[i].OrdIsDefault=="1") {	//首选医嘱
							if(objOrder.IsHaveDown[data.rows[i].xID]==5){	//未执行
								$("#CPWItemOrder").datagrid("selectRow", i);
								$("#CPWItemOrder").datagrid("checkRow", i);
							}
						}
					}
					if (objOrder.SelectedOrds.rows.length>0){
						//检查医嘱是否存在已被勾选列表，存在勾选选择框 add by yankai20201208
						$.each(objOrder.SelectedOrds.rows, function(index, item){
   							if (data.rows[i].xID==item.xID){
								$("#CPWItemOrder").datagrid("checkRow", i);	
	   						}
						});
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
				aArcimID:ArcimID,
				aHospID:session['DHCMA.HOSPID']
			},function(rs){
				$('#gridGeneOrder').datagrid({'title':$g('当前医嘱：')+OrdMastIDDesc});
				$('#gridGeneOrder').datagrid('loadData',rs);
				$HUI.dialog('#GeneCPWDialog').open();	
			})
			/*
			$('#gridGeneOrder').datagrid({'title':'当前医嘱：'+OrdMastIDDesc});	
			objOrder.gridGeneOrder.load({
				ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
				QueryName:"QryOrderListByGene",
				aEpisodeID:EpisodeID.split("!!")[0],
				aArcimID:ArcimID
			});
			//$HUI.dialog('#GeneCPWDialog').open();
			*/
		},
		onClickCell: function(index,field,value){
			if(field=="OrdMastIDDesc"){
				var selData = $('#CPWItemOrder').datagrid('getRows')[index];
				var FormOrdID=selData['xID'];
				if (FormOrdID.indexOf("FJ")>-1) FormOrdID=FormOrdID.split(':')[2]+"||"+FormOrdID.split(':')[1];
				var id=FormOrdID.split("||").join("-");
				if(objOrder.OrdContent[id]==undefined) return;
				$('#'+id).parent().popover({
					content:objOrder.OrdContent[id]
				});
				
				$("#"+id).parent().popover('show');
				$("#"+id).parent().mouseout(function(){
					$("#"+id).parent().popover('hide');
				 })
			}else{
				var selData = $('#CPWItemOrder').datagrid('getRows')[index];
				var FormOrdID=selData['xID']
				var id=FormOrdID.split("||").join("-")
				//$("#"+id).popover('hide');
			}
		},
		onCheckAll: function(rows){
			//全选前先清除已选医嘱列表中当前选项下的医嘱
			for (var i = 0; i < objOrder.SelectedOrds.rows.length; i++) {			
   				if(objOrder.SelectedOrds.rows[i].tabType==objOrder.curTabTitle){
	   				objOrder.SelectedOrds.rows.splice(i,1);
	   				i=i-1;
	   			}	
			}
			
			//面板是否展开处理
			var e_width=$("#cc").layout("panel", "east")[0].clientWidth;
			if (e_width==0) $('#cc').layout('expand','east');
			
			for (var i=0;i<rows.length;i++){
				//中西医类型不匹配的取消勾选
				if(rows[i].OrdCatCode != OrderType){
					$("#CPWItemOrder").datagrid("uncheckRow", i);
				}
				
				if (objOrder.SelectedOrds.rows.length>0){
					//已选医嘱列表下已存在的医嘱取消勾选
					$.each(objOrder.SelectedOrds.rows, function(j, jtem){ 
   						if(jtem.OrdMastID==rows[i].OrdMastID) {
	   						$("#CPWItemOrder").datagrid("uncheckRow", i);
	   					}
					});	
				}		
			}
			
			var checkboxHeader = $('div.datagrid-header-check input[type=checkbox]');//取到全选全不选这个元素
			checkboxHeader.prop("checked","checked");//将其设置为checked即可
			
			//可选医嘱加入已选医嘱对象中
			var index=objOrder.SelectedOrds.rows.length;
			$.each(rows,function(i,item){
				if(item.OrdCatCode == OrderType){
					var chkExist=0;
					$.each(objOrder.SelectedOrds.rows, function(j, jtem){
						if(item.OrdMastID==jtem.OrdMastID) {chkExist=1;}
					})
					if (!chkExist) {
						objOrder.SelectedOrds.rows[index]=item;
						index++;
					}
						
				}
			})
						
			objOrder.gridSelectedOrds.loadData(objOrder.SelectedOrds);
		},
		onUncheckAll:function(rows){
			//清除已选医嘱列表中当前选项下的医嘱
			for (var i = 0; i < objOrder.SelectedOrds.rows.length; i++) {			
   				if(objOrder.SelectedOrds.rows[i].tabType==objOrder.curTabTitle){
	   				objOrder.SelectedOrds.rows.splice(i,1);
	   				i=i-1;
	   			}	
			}
			
			//清空所选医嘱列表
			objOrder.gridSelectedOrds.loadData(objOrder.SelectedOrds);
		},
		onCheck: function(index, row){
			
			if (row.tabType==undefined) row.tabType=objOrder.curTabTitle;
			
			/*	//勾选重复检查因医生站存在该检查，故暂时注释掉
			var isExist=-1;	
			$.each(objOrder.SelectedOrds.rows, function(i, item){       				
   				if(item.OrdMastID==row['OrdMastID']){
	   				if (item.xID!=row.xID) isExist=1; 		//判断是否存在该值
	   				else isExist=0;
	   			}
			});
			if (isExist==-1){
				objOrder.SelectedOrds.rows[rowsLen]=row;
				var e_width=$("#cc").layout("panel", "east")[0].clientWidth;
				if (e_width==0) $('#cc').layout('expand','east');
				objOrder.gridSelectedOrds.loadData(objOrder.SelectedOrds);
			}else if(isExist==1){
				$.messager.confirm("提示", "已选列表已存在该医嘱，是否仍然勾选？", function (r) {
					if (r){
						objOrder.SelectedOrds.rows[rowsLen]=row;
						var e_width=$("#cc").layout("panel", "east")[0].clientWidth;
						if (e_width==0) $('#cc').layout('expand','east');
						objOrder.gridSelectedOrds.loadData(objOrder.SelectedOrds);
					}else{
						$("#CPWItemOrder").datagrid("uncheckRow", index);
						return;	
					}
				})			
			}else{
				//无需处理		
			}
			*/
			
			
			var isExist=-1;	
			$.each(objOrder.SelectedOrds.rows, function(i, item){       				
   				if(item.OrdMastID==row['OrdMastID']){
	   				if (item.xID!=row.xID) isExist=0; 		//判断是否存在该值
	   				else isExist=1;
	   			}
			});
			if (isExist<1){
				//勾选医嘱添加到已选医嘱列表
				var rowsLen=objOrder.SelectedOrds.rows.length;
				objOrder.SelectedOrds.rows[rowsLen]=row;
				var e_width=$("#cc").layout("panel", "east")[0].clientWidth;
				if (e_width==0) $('#cc').layout('expand','east');
				objOrder.gridSelectedOrds.loadData(objOrder.SelectedOrds);	
			}

			//处理关联医嘱同时勾选			
			if(objOrder.IsChecking) return;			
			var ordLinkNum=row['OrdLnkOrdDr'];
			var ItemDesc = row['ItemDesc'];
			if(ordLinkNum == "") return;
			objOrder.IsChecking=true;
			var Rows=$('#CPWItemOrder').datagrid('getRows');
			for (var ind=0;ind<Rows.length;ind++){
				if(index == ind) continue;
				var selData=Rows[ind];
				
				if((Math.floor(selData['OrdLnkOrdDr']) == Math.floor(ordLinkNum))&&(selData['ItemDesc']==ItemDesc)){	//整数位相同视为关联医嘱，操作同时进行
					$("#CPWItemOrder").datagrid("selectRow", ind);
					$("#CPWItemOrder").datagrid("checkRow", ind);
				}
			}
			objOrder.IsChecking=false;
		},
		onUncheck: function(index, row){
			//将取消勾选医嘱从已选医嘱列表移除								
			$.each(objOrder.SelectedOrds.rows, function(idx, item){
   				if (item.xID==row['xID']){
	   				objOrder.SelectedOrds.rows.splice(idx,1);
	   				return false;
	   			}
			});
			objOrder.gridSelectedOrds.loadData(objOrder.SelectedOrds);
			
			//处理关联医嘱同时取消勾选
			if(objOrder.IsUnChecking) return;			
			var ordLinkNum=row['OrdLnkOrdDr'];
			var ItemDesc = row['ItemDesc'];
			if(ordLinkNum == "") return;
			objOrder.IsUnChecking=true;
			var Rows=$('#CPWItemOrder').datagrid('getRows');
			for (var ind=0;ind<Rows.length;ind++){
				if(index == ind) continue;
				var selData=Rows[ind];
				if((Math.floor(selData['OrdLnkOrdDr']) == Math.floor(ordLinkNum))&&(selData['ItemDesc']==ItemDesc)){	//整数位相同视为关联医嘱，操作同时进行
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
				
			var FormOrdID=row['xID']
			var ret=$m({ClassName:"DHCMA.CPW.CPS.InterfaceSrv",
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
	
	// 已选医嘱列表
	objOrder.gridSelectedOrds = $HUI.datagrid("#gridSelectedOrds",{
		fit: true,
		iconCls:"icon-paper",
		//title:$g('已选医嘱')+"<span title=\'折叠\' style=\'float:right;cursor:pointer\' onclick=\"$('#cc').layout('collapse','east');\" class=\'icon-triangle-green-right\'>&nbsp;</span>",
		headerCls:'panel-header-gray',
		//pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:$g('数据加载中...'),
		//pageSize: 10,
		//pageList : [10,20,50,100,200],
	    //url:$URL,
	    queryParams:{
		    //ClassName:"DHCMA.CPW.BTS.PathTCMSrv",
			//QueryName:"QryPathTCM"
	    },
		columns:[[
			{field:'OrdMastIDDesc',title:'名称',width:'200'},
			{field:'tabType',title:'来源',width:'60'}
		]],
		data:objOrder.SelectedOrds,
		onDblClickRow: function(index, row){
			var ordLinkNum=row['OrdLnkOrdDr'];						//获取关联号
			var ordsRows=$('#CPWItemOrder').datagrid('getRows');
			
			if (ordLinkNum!=""){
				// 删除当前已选医嘱列表
				$.each(objOrder.SelectedOrds.rows, function(idx, item){
					if (idx==objOrder.SelectedOrds.rows.length) return false;
	   				if (item.OrdLnkOrdDr==ordLinkNum){
		   				objOrder.SelectedOrds.rows.splice(idx,1);
		   			}
				});
				objOrder.gridSelectedOrds.loadData(objOrder.SelectedOrds);		//重新加载
				
				// 删除阶段医嘱列表
				$.each(ordsRows, function(index, item){ 
   					if (item.OrdLnkOrdDr==ordLinkNum){
						$("#CPWItemOrder").datagrid("uncheckRow", index);	
	   				}
				});					
			}else{
				$(this).datagrid("deleteRow",index);
				// 删除阶段医嘱列表
				$.each(ordsRows, function(index, item){ 
   					if (ordsRows[index].xID==row.xID){
						$("#CPWItemOrder").datagrid("uncheckRow", index);	
	   				}
				});				
			}
			
				
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
	//医嘱套医嘱列表
  	objOrder.gridARCOSOrder = $HUI.datagrid("#gridARCOSOrder",{
		fit: true,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		selectOnCheck:false,
		singleSelect: false,
		remoteSort:false,
		sortName:"SeqNo",
		sortOrder:"asc",
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:$g('数据加载中...'),   
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',width:'',auto:false},
			{field:'ARCIMDesc',title:'医嘱名称',width:'300'},
			{field:'DoseQty',title:'单次剂量',width:'80'},
			{field:'DoseUOMDesc',title:'剂量单位',width:'80'},
			{field:'FreqDesc',title:'频次',width:'80'},
			{field:'InstrDesc',title:'用法',width:'80'},
			{field:'DurDesc',title:'疗程',width:'80'},
			{field:'SeqNo',title:'序号',width:'80'}			
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
		onCheck: function(index, row){
			if(objOrder.ARCOSCheckFlg) return;
			
			if(row['SeqNo']=="") return;
			var MastSeqNo=Math.floor(row['SeqNo']);
			var rowsArr=$(this).datagrid('getData').rows;		//所有行数据
			objOrder.ARCOSCheckFlg=true;
			for (var ind=0;ind<rowsArr.length;ind++){
				if(ind == index) continue;
				if(rowsArr[ind].SeqNo=="") continue;
				var curRowSeqNo=rowsArr[ind].SeqNo;
				if(MastSeqNo==Math.floor(curRowSeqNo)){			//关联序号整数位相同同时操作
					//$(this).datagrid("selectRow", ind);
					$(this).datagrid("checkRow", ind);
					
				}
			}
			objOrder.ARCOSCheckFlg=false;
		},
		onUncheck: function(index, row){
			if(objOrder.ARCOSCheckFlg) return;
			
			if(row['SeqNo']=="") return;
			var MastSeqNo=Math.floor(row['SeqNo']);
			var rowsArr=$(this).datagrid('getData').rows;		//所有行数据
			objOrder.ARCOSCheckFlg=true;
			for (var ind=0;ind<rowsArr.length;ind++){
				if(ind == index) continue;
				if(rowsArr[ind].SeqNo=="") continue;
				var curRowSeqNo=rowsArr[ind].SeqNo;
				if(MastSeqNo==Math.floor(curRowSeqNo)){			//关联序号整数位相同同时操作
					$(this).datagrid("uncheckRow", ind);
				}
			}
			objOrder.ARCOSCheckFlg=false;		
		},
		rowStyler: function(index,row){
			var SeqNo=row.SeqNo;
			if (SeqNo=="") return;
			if (SeqNo.indexOf(".")>-1) return 'background-color:#cdf1cd;';
			else return 'background-color:#94e494;';						
		}
	});
	
	//套内医嘱选择确定事件
	$('#CheckOrder').on('click', function(){
		var ARCOSID = $("#ARCOSCPWDialog").dialog('options').inParam;	//当前医嘱套ID
		
		var rows = $('#gridARCOSOrder').datagrid('getChecked');
		var ARCIMIDArr=[];
		for (var i=0,len=rows.length;i<len;i++){
			var ARCIMRowid=rows[i]['ARCIMRowid'];
			var SeqNo=rows[i]['SeqNo'];
			var RowIndex = $("#gridARCOSOrder").datagrid('getRowIndex',rows[i]);
			ARCIMIDArr.push(ARCIMRowid+"*"+SeqNo+"*"+RowIndex);
		}
		objOrder.JsonARCOSDetail[ARCOSID] = ARCIMIDArr			// 明细数据存放页面对象中
		
		ARCIMIDStr=ARCIMIDArr.join("^");
		var ret=$m({
			ClassName:"DHCMA.CPW.CPS.InterfaceSrv",
			MethodName:"SaveARCOSItems",
			aEpisodeID:EpisodeID.split("!!")[0],
			aARCIMRowids:ARCIMIDStr,
			aARCOSID:ARCOSID
		},false);
		$HUI.dialog('#ARCOSCPWDialog').close();
	})
	
	//医嘱分组后重置按钮事件
	$("#reSetGroup").on('click', function(){
		objOrder.cboOrdGroup.clear();
		objOrder.OrdGroupID="";
		if (objOrder.curTabTitle==$g("主路径")){ 
			$cm ({
				ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
				QueryName:"QryPathFormEpItemOrdAll",
				ResultSetType:"array",
				aPathFormEpDr:objOrder.tempFormEpID,
				aPathFormEpItemDr:objOrder.tempFormEpItemID,
				aHospID:HospID,
				aOrdDesc:$('#OrdDesc').searchbox('getValue'),
				aOrdGroupID:objOrder.OrdGroupID,
				aUserType:UserType,
				aEpisodeID:EpisodeID,
				aLgnLocID:session['DHCMA.CTLOCID'],
				page:1,
				rows:99999
			},function(rs){
				$('#CPWItemOrder').datagrid({groupField:'ItemDesc',loadFilter:pagerFilter}).datagrid('loadData', rs);			
			});	
		}else{
			$cm ({
				ClassName:"DHCMA.CPW.CPS.PathwayComplSrv",
				QueryName:"QryComplFormOrdAll",
				ResultSetType:"array",
				aFormID:objOrder.tempCplFormID,
				aFormEpID:objOrder.tempFormEpID,
				aFormItemID:objOrder.tempFormEpItemID,
				aHospID:HospID,
				aOrdDesc:$('#OrdDesc').searchbox('getValue'),
				aOrdGroupID:objOrder.OrdGroupID,
				aUserType:UserType,
				aEpisodeID:EpisodeID,
				aLgnLocID:session['DHCMA.CTLOCID'],
				page:1,
				rows:99999
			},function(rs){
				$('#CPWItemOrder').datagrid({groupField:'OrdBuzTypeDesc',loadFilter:pagerFilter}).datagrid('loadData', rs);			
			});		
		}
		
	})
	
	// 主路径/合并症页签切换
	objOrder.tabItemTree =$HUI.tabs("#tabItemTree",{
		onSelect:function(title){
			objOrder.curTabTitle=title;
			switch (title) {
				case $g("主路径"):					
					objOrder.cboOrdGroup.clear();
					objOrder.OrdGroupID="";
					//objOrder.tempCplFormID="";
					objOrder.tempFormEpID="";
					objOrder.tempFormEpItemID="";
					$("#OrdDesc").searchbox("clear");
					$("#panelOrdDtl").panel("setTitle",$g("主路径医嘱"));
					ShowStepDetail("OStep-"+objOrder.StepSelecedID);
					break;
				case $g("合并症"):
					objOrder.cboOrdGroup.clear();
					objOrder.OrdGroupID="";
					//objOrder.tempCplFormID="";
					objOrder.tempFormEpID="";
					objOrder.tempFormEpItemID="";
					$("#OrdDesc").searchbox("clear");
					$("#panelOrdDtl").panel("setTitle",$g("合并症医嘱"));
					$('#CPWItemOrder').datagrid({loadFilter:pagerFilter}).datagrid('loadData',{total:0,rows:[]});
					SeletctComplTab();
					break;
			}					
		}
	});
}

AddOrderToEntry = function(){
	var rows = $('#gridSelectedOrds').datagrid("getRows");
	if(rows.length==0) {
		$.messager.popover({msg: $g('未勾选任何医嘱！'),type:'alert'});	 
		return;
	}
	// 获取选择的医嘱项和医嘱数量
	var cntAcrItm = 0, cntArcCos = 0;
	rows.forEach(function (row) {
		if (row.OrdMastID.indexOf('||') == -1) {
			cntArcCos ++;
		} else {
			cntAcrItm ++;
		}
	})
	$.messager.confirm($g("添加"), $g("共")+cntAcrItm+$g("条医嘱项，")+cntArcCos+$g("个医嘱套<br>确定要添加吗？"), function (r) {
		if (r) {
			var groups = [];
			var group =""
			rows.forEach(function (row) {
				if(row['OrdLnkOrdDr']!=""){
					//增加按项目区分关联号，否则不同项目维护相同的关联号会全部关联到一组
					var ItemID=row['ItemID']
					var ItemChild=ItemID.split('||')[2]
					var LnkNum=row['OrdLnkOrdDr']
					var LnkGroup=ItemChild+LnkNum
					group = JSON.stringify(parseInt(LnkGroup))+1
					groups[group] = groups[group] || []
					groups[group].push(row)
				}else{
					group=0
					groups[group] = groups[group] || []
					groups[group].push(row)
				}
			})
			
			var strOrderList = '';
			for (var ind=0,len=groups.length ;ind<len ;ind++){
				if(groups[ind]){
					var strOrder=""
					for(var i=0,l=groups[ind].length ;i<l ;i++){
						if (groups[ind][i].OrdMastID.indexOf('||') == -1) {
							// 当前为医嘱套，只需要传OrdMastID即可
							strOrder  = "^ordid^^^^^^^^".replace("ordid", groups[ind][i].OrdMastID);
							strOrder += '^' + "."+i + '^^';
						}
						else {
							// 当前为医嘱项，直接拼接
							strOrder  = groups[ind][i].OrdGeneID;				//通用名ID
							strOrder += '^' + groups[ind][i].OrdMastID;
							strOrder += '^' + groups[ind][i].OrdPriorityID;
							strOrder += '^' + groups[ind][i].OrdQty;
							strOrder += '^' + groups[ind][i].OrdDoseQty;
							strOrder += '^' + groups[ind][i].OrdUOMID;
							strOrder += '^' + groups[ind][i].OrdFreqID;
							strOrder += '^' + groups[ind][i].OrdDuratID;
							strOrder += '^' + groups[ind][i].OrdInstrucID;
							strOrder += '^' + groups[ind][i].OrdNote;
							strOrder += '^' + ind+"."+i;
							var posStr=groups[ind][i].OrdChkPosID
							if(posStr!=""){
								strOrder += '^' + posStr.split("||")[1];			// 检查部位
							}else{ strOrder += '^'}
							strOrder += '^' + groups[ind][i].IsDefSensitive; 		// 默认加急
						}
						strOrderList +=  CHR_1 + strOrder;
					}
				}
			}

			if(strOrderList!=""){
				//将医嘱添加到列表
				websys_showModal('options').addOEORIByCPW(strOrderList)
				websys_showModal('close');
			}
		} else {
			return;
		}
	});
}

//路径信息
InitOCPWInfo = function(){
	$m({
		ClassName:"DHCMA.CPW.CPS.ImplementSrv",
		MethodName:"GetCPWInfo",
		aEpisodeID:EpisodeID
	},function(JsonStr){
		var JsonObj=$.parseJSON( JsonStr ); 
		
		objOrder.CPWCurrDesc=JsonObj.CPWDesc;		//当前步骤名称
		objOrder.StatusCurrDesc=JsonObj.CPWStatus;	//当前路径状态
		objOrder.PathFormID=JsonObj.PathFormID		//当前路径的表单ID
		objOrder.PathwayID=JsonObj.PathwayID			//出入径记录ID
		
		$('#OCPWDesc').text(JsonObj.CPWDesc)
		$('#OCPWStatus').text(JsonObj.CPWStatus)
		$('#OCPWUser').text(JsonObj.CPWUser)
		$('#OCPWTime').text(JsonObj.CPWTime)
		//$('#CPWIcon').text(JsonObj.CPWIcon)
		var htmlIcon=""
		htmlIcon=htmlIcon+'<span class="OIcon OIcon-D">'+$g('单')+'</span>'
		htmlIcon=htmlIcon+'<span class="OIcon OIcon-B">'+$g('变')+'</span>'
		htmlIcon=htmlIcon+'<span class="OIcon OIcon-T">T</span>'
		htmlIcon=htmlIcon+'<span class="OIcon OIcon-Y">￥</span>'
		$('#OCPWIcon').html(htmlIcon)
		$(".OIcon-D").popover({
			content: $g('单病种信息：') + JsonObj.SDDesc
		});
		$(".OIcon-B").popover({
			content: JsonObj.VarDesc
		});
		$(".OIcon-T").popover({
			content: $g('入径天数：') + JsonObj.CPWDays + $g('天<br />计划天数：') + JsonObj.FormDays + $g('天')
		});
		$(".OIcon-Y").popover({
			content: $g('住院总费用：') + JsonObj.PatCost + $g('<br />计划费用：') + JsonObj.FormCost + $g('元')
		});
		
		InitOCPWSteps();
	});
}

//路径步骤
InitOCPWSteps = function(){
	$m({
		ClassName:"DHCMA.CPW.CPS.ImplementSrv",
		MethodName:"GetCPWSteps",
		aPathwayID:objOrder.PathwayID
	},function(StepsStr){
		var StepsArr=StepsStr.split("#");
		var StepCurr=StepsArr[0];
		if (StepCurr=="") return;
		
		objOrder.StepCurrID=StepCurr.split(":")[0];			//已经执行到当前步骤的ID
		objOrder.StepList=StepsArr[1].split("^");			//该路径所有步骤数组
		objOrder.TimeList=StepsArr[2].split("^");			//该路径所有步骤起止时间数组，EpDays*SttDateTime*EndDateTime
		objOrder.ConfList=StepsArr[3].split("^");			//该路径所有步骤是否确定数组，1、0
		objOrder.SignList=StepsArr[4].split("^");			//该路径所有步骤签名信息数组，SignDoc:SignNur:SignDocDate:SignNurDate
		objOrder.StepSelecedID=objOrder.StepCurrID;				//点击选中的步骤ID
		objOrder.CurrIndex=objOrder.StepList.indexOf(StepCurr);	//已经执行到当前步骤的下标
		
		//展现步骤
		ShowCPWSteps(objOrder.CurrIndex);
		//展现步骤内容
		SelectStep("OStep-"+objOrder.StepCurrID);
	});	
	
}

//展现步骤
ShowCPWSteps = function(selectIndex){
	var StepSelect=objOrder.TimeList[selectIndex].split("*");
	$('#OStepTime').text(StepSelect[0]);
	$('#ODateFrom').datetimebox('setValue',StepSelect[1]);
	$('#ODateTo').datetimebox('setValue',StepSelect[2]);
	
	var StepShow=new Array();	//显示出来的步骤
	var StepMore=new Array();	//更多的步骤
	
	for(var ind = 0,len=objOrder.StepList.length;ind < len; ind++){
		if(selectIndex<3){
			if(ind<5){
				StepShow.push(objOrder.StepList[ind]);
			}else{
				StepMore.push(objOrder.StepList[ind]);
			}
		}else if(selectIndex>(len-3)){
			if(ind>len-6){
				StepShow.push(objOrder.StepList[ind]);
			}else{
				StepMore.push(objOrder.StepList[ind]);
			}
		} else {
			if((ind<(selectIndex-2)) || (ind>(selectIndex+2))) {
				StepMore.push(objOrder.StepList[ind]);
			} else {
				StepShow.push(objOrder.StepList[ind]);
			}
		}
	}
	
	var StepClass="";
	var StepShowHtml="";
	for(var ind = 0,len = StepShow.length; ind < len; ind++){
		var StepIndex=objOrder.StepList.indexOf(StepShow[ind]);
		if(StepIndex<objOrder.CurrIndex){
			StepClass="Ostep Osteppre";	//已执行
		}else if(StepIndex>objOrder.CurrIndex){
			StepClass="Ostep Ostepaft";	//未执行
		}else{
			StepClass="Ostep Ostepcurr";	//当前步骤
		}
		var tmpStep=StepShow[ind].split(":");
		if(GetLength(tmpStep[1])<=13) StepClass=StepClass+" Ostepshort";
		StepShowHtml=StepShowHtml+"<div id='OStep-"+tmpStep[0]+"' class='"+StepClass+"'>"+tmpStep[1]+"</div>"
		if(ind != len-1) {
			StepShowHtml=StepShowHtml+"<div class='Ostepline'></div>"
		}
	}
	$('#OStepShow').html(StepShowHtml);
	
	var StepClass="";
	var StepMoreHtml="";
	for(var ind = 0,len =StepMore.length; ind < len; ind++){
		var StepIndex=objOrder.StepList.indexOf(StepMore[ind]);
		if(StepIndex<objOrder.CurrIndex){
			StepClass="Osteppre";	//已执行
		}else if(StepIndex>objOrder.CurrIndex){
			StepClass="Ostepaft";	//未执行
		}else{
			StepClass="Ostepcurr";	//当前步骤
		}
		var tmpStep=StepMore[ind].split(":");
		StepMoreHtml=StepMoreHtml+"<div id='OStep-"+tmpStep[0]+"' class='OselectStepMore "+StepClass+"'>"+tmpStep[1]+"</div>"
	}
	$('#OStepMoreList').html(StepMoreHtml);
}

SelectStep = function(IDStr){
	var SelectedStepID=IDStr.split("-")[1];
	var SelectedStepText=$("#"+IDStr).text();
	var SelectedStep=SelectedStepID+":"+SelectedStepText;
	var SelectedIndex=objOrder.StepList.indexOf(SelectedStep);
	objOrder.StepSelecedID=SelectedStepID;
	
	if (objOrder.StatusCurrDesc == "入径"){
		if(objOrder.StepSelecedID != objOrder.StepCurrID) {	//非当前步骤不允许添加医嘱
			$("#Addorder").linkbutton("disable");
		}else{
			$("#Addorder").linkbutton("enable");
		}	
	}else{ $("#Addorder").linkbutton("disable"); }
	
	//调整并展现步骤
	ShowCPWSteps(SelectedIndex);
	//展现步骤内容
	if (objOrder.curTabTitle==$g("主路径")) ShowStepDetail(IDStr);
	else {
		$("#OStepShow .Ostep").removeClass('selected');
		$("#"+IDStr).addClass('selected');	
	}
	//绑定点击事件
	$('#OStepMoreList .OselectStepMore').on('click', function(){
		SelectStep(this.id);
	});
	$('#OStepShow .Ostep').on('click', function(){
		var SelectedStepID=this.id.split("-")[1];
		objOrder.StepSelecedID=SelectedStepID;
		SelectStep(this.id);
		//ShowStepDetail(this.id);
	});
	ShowOSetpMore(0);	//关闭更多步骤
	objOrder.SelectedOrds={rows:[],total:999};
	objOrder.gridSelectedOrds.loadData(objOrder.SelectedOrds);
}

ShowStepDetail = function(IDStr){
	$("#OStepShow .Ostep").removeClass('selected');
	$("#"+IDStr).addClass('selected');
	$m({
		ClassName:"DHCMA.CPW.CPS.ImplementSrv",
		MethodName:"GetOrdItmTree",
		aPathwayID: objOrder.PathwayID, 
		aEpisID: objOrder.PathwayID+"||"+objOrder.StepSelecedID,
		aUserType: UserType
	},function(treeJson){
		var dataArr=$.parseJSON(treeJson)
		$('#OItemTree').tree({
			data: dataArr,
			formatter:function(node){
				var Displaytxt="";
				if (node.children){
					Displaytxt = node.text;
				}else{
					len=node.text.length;
					if (len<15) {
						Displaytxt = node.text;
					}else{
						Displaytxt = node.text.substring(0,15)+"<br />"+node.text.substring(15)
					}
				}
				//已经执行				
				if((!node.children)&&(node.attributes.IsImp)){
					Displaytxt = "<span style='color:#509DE1;'>"+Displaytxt+"</span>";
				}
				if((!node.children)&&(node.attributes.IsRequired)){
					Displaytxt = "<span style='color:red;'>*</span>"+Displaytxt;
				}
				return Displaytxt
			},
			onClick: function(node){
				var PathFormEpID="";
				var PathFormEpItemID="";
				if(node.id.split("-")[0]=="OrdTree"){
					PathFormEpID=node.id.split("-")[2];
					PathFormEpItemID="";
				}else{
					var root=$('#OItemTree').tree('getParent', node.target);
					PathFormEpID=root.id.split("-")[2];
					PathFormEpItemID=node.id.split("-")[1];
				}
				objOrder.tempFormEpID=PathFormEpID;
				objOrder.tempFormEpItemID=PathFormEpItemID;
				
				$cm ({
					ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
					QueryName:"QryPathFormEpItemOrdAll",
					ResultSetType:"array",
					aPathFormEpDr:PathFormEpID,
					aPathFormEpItemDr:PathFormEpItemID,
					aHospID:HospID,
					aOrdDesc:$('#OrdDesc').searchbox('getValue'),
					aOrdGroupID:objOrder.OrdGroupID,
					aUserType:UserType,
					aEpisodeID:EpisodeID,
					aLgnLocID:session['DHCMA.CTLOCID'],
					page:1,
					rows:99999
				},function(rs){
					$('#CPWItemOrder').datagrid({groupField:'ItemDesc',loadFilter:pagerFilter}).datagrid('loadData', rs);				
				});
			},
			onLoadSuccess: function(node, data){
				if(data.length>0){
					var rootID=data[0].id;
					var node = $('#OItemTree').tree('find', rootID);
					$('#OItemTree').tree('select', node.target);
					$('#OItemTree').tree('check', node.target);
					PathFormEpID=rootID.split("-")[2];
					objOrder.tempFormEpID=PathFormEpID;
					objOrder.tempFormEpItemID="";
					
					$cm ({
						ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
						QueryName:"QryPathFormEpItemOrdAll",
						ResultSetType:"array",
						aPathFormEpDr:PathFormEpID,
						aPathFormEpItemDr:"",
						aHospID:HospID,
						aOrdDesc:$('#OrdDesc').searchbox('getValue'),
						aOrdGroupID:"",
						aUserType:UserType,
						aEpisodeID:EpisodeID,
						aLgnLocID:session['DHCMA.CTLOCID'],
						page:1,
						rows:99999
					},function(rs){
						$('#CPWItemOrder').datagrid({groupField:'ItemDesc',loadFilter:pagerFilter}).datagrid('loadData', rs);				
					});
					
				}
			},
			lines:true,autoNodeHeight:true
		})
	});	
}

ShowOSetpMore = function(Emvalue){
	if(Emvalue==1){
		$('#OStepMoreList').css('display','block');
		$('#OStepMore').attr("value",0);
		$('#OStepMore').text($g("收起▲"));
	}else{
		$('#OStepMore').text($g("更多▼"));
		$('#OStepMore').attr("value",1);
		$('#OStepMoreList').css('display','none');
	}
}

GetLength = function(str) {
	///获得字符串实际长度，中文2，英文1，符号1
	var realLength = 0, len = str.length, charCode = -1;
	for (var i = 0; i < len; i++) {
		charCode = str.charCodeAt(i);
		if (charCode >= 0 && charCode <= 128)
			realLength += 1;
		else
			realLength += 2;
	}
	return realLength;
}

//显示方剂信息明细
ShowFJDetail = function(FJid){
	$cm({
		ClassName:"DHCMA.CPW.BTS.PathTCMExtSrv",
		QueryName:"QryPathTCMExt",
		aParRef:FJid,
		ResultSetType:"array"
	},function(rs){
		var PopHtml=""
		if (rs.length>0){
			for(var i=0;i<rs.length;i++){
				PopHtml=PopHtml+rs[i].BTTypeDesc+"&nbsp&nbsp&nbsp"+rs[i].BTOrdMastID+"&nbsp&nbsp&nbsp"+rs[i].ArcResumeDesc+"<br/>"
			}
		}
		$HUI.popover('#pop'+FJid,{content:PopHtml,trigger:'hover'});
		$('#pop'+FJid).popover('show');
	});
}

//销毁模态窗
DestoryFJDetail = function(FJid){
	$('#pop'+FJid).popover('destroy');
}

//展示医嘱套明细
ShowARCOSDetail = function(ARCOSID,ARCOSDesc,OutIndex){
	$('#gridARCOSOrder').datagrid('loadData',{rows:[],total:0});
	$cm({
		ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
		QueryName:"QryOrderByARCOS",
		ARCOSRowid:ARCOSID,
		aHospID:session['DHCMA.HOSPID'],
		page:1,
		rows:99999
	},function(rs){
		$('#gridARCOSOrder').datagrid({'title':$g('当前医嘱套')+'：'+ARCOSDesc,'onLoadSuccess': function(data){
			if (objOrder.JsonARCOSDetail[ARCOSID]!="" && objOrder.JsonARCOSDetail[ARCOSID]!=undefined){
				var chkARCIMRowArr = objOrder.JsonARCOSDetail[ARCOSID]
				for (var i=0;i<chkARCIMRowArr.length;i++){
					var chkRowIndex = chkARCIMRowArr[i].split("*")[2]
					$(this).datagrid('checkRow', chkRowIndex)	
				}
			}	
		}});
		$('#gridARCOSOrder').datagrid('loadData',rs);
		$HUI.dialog('#ARCOSCPWDialog',{
			inParam:ARCOSID,
			OutIndex:OutIndex,
			onClose:function(){
				if (objOrder.JsonARCOSDetail[ARCOSID]!=undefined && objOrder.JsonARCOSDetail[ARCOSID].length!=0){
					$("#CPWItemOrder").datagrid('checkRow',OutIndex)	
				}else{
					$("#CPWItemOrder").datagrid('uncheckRow',OutIndex)	
				}	
			}
		}).open();
	})	
}

//合并症信息展示函数
SeletctComplTab = function(){
	$m({
		ClassName:"DHCMA.CPW.CPS.PathwayComplSrv",
		MethodName:"GetComplItemTree",
		aPathwayID: objOrder.PathwayID, 
		aEpisID: objOrder.PathwayID+"||"+objOrder.StepSelecedID,
		aUserType: UserType
	},function(treeJson){
		var dataArr=JSON.parse(treeJson);
		if(dataArr.length==0){
			$("#tabItemTree").tabs('getSelected').context.innerHTML="<span style='color:#1474AF;margin-left:10px;'>"+$g("提示：无关联合并症！")+"</span>";
			return;
		} 
		$('#ComplTree').tree({
			data: dataArr,
			lines:true,
			autoNodeHeight:true,
			formatter:function(node){
				var Displaytxt=node.text;
				if((!node.children)&&(node.attributes.IsImp)){
					Displaytxt = "<span style='color:#509DE1;'>"+node.text+"</span>";
				}
				if((!node.children)&&(node.attributes.IsRequired)){
					Displaytxt = "<span style='color:red;'>*</span>"+Displaytxt;
				}
				return Displaytxt;
			},
			onClick: function(node){
				var CFormID="";
				var CFormEpID="";
				var CFormItemID="";
				if(node.id.split("-")[0]=="ComplForm"){
					CFormID=node.id.split("-")[2];
					CFormEpID=""
					CFormItemID="";
				}else if(node.id.split("-")[0]=="ComplEp"){
					CFormID=node.id.split("-")[1].split("||")[0];
					CFormEpID=node.id.split("-")[1];
					CFormItemID="";
				}else{
					CFormID=node.id.split("-")[1].split("||")[0];
					CFormEpID=CFormID + "||" + node.id.split("-")[1].split("||")[1];
					CFormItemID=node.id.split("-")[1];
				}
				objOrder.tempCplFormID=CFormID;
				objOrder.tempFormEpID=CFormEpID;
				objOrder.tempFormEpItemID=CFormItemID;
				
				objOrder.cboOrdGroup.clear();
				objOrder.OrdGroupID="";
				if(node.id.split("-")[0]=="ComplForm"){
					$("#OrdDesc").searchbox("clear");	
				}
				
				$cm ({
					ClassName:"DHCMA.CPW.CPS.PathwayComplSrv",
					QueryName:"QryComplFormOrdAll",
					ResultSetType:"array",
					aFormID:CFormID,
					aFormEpID:CFormEpID,
					aFormItemID:CFormItemID,
					aHospID:HospID,
					aOrdDesc:$('#OrdDesc').searchbox('getValue'),
					aOrdGroupID:objOrder.OrdGroupID,
					aUserType:UserType,
					aEpisodeID:EpisodeID,
					aLgnLocID:session['DHCMA.CTLOCID'],
					page:1,
					rows:99999
				},function(rs){
					$('#CPWItemOrder').datagrid({groupField:'OrdBuzTypeDesc',loadFilter:pagerFilter}).datagrid('loadData', rs);
				});
			},
			onLoadSuccess: function(node, data){
				if(data.length>0){
					var firstCFormID=data[0].id;
					var node = $('#ComplTree').tree('find', firstCFormID);
					$('#ComplTree').tree('select', node.target);
					
					CFormID=node.id.split("-")[2];
					objOrder.tempCplFormID=CFormID;
					objOrder.tempFormEpID="";
					objOrder.tempFormEpItemID="";
					
					$cm ({
						ClassName:"DHCMA.CPW.CPS.PathwayComplSrv",
						QueryName:"QryComplFormOrdAll",
						ResultSetType:"array",
						aFormID:CFormID,
						aFormEpID:"",
						aFormItemID:"",
						aHospID:HospID,
						aOrdDesc:$('#OrdDesc').searchbox('getValue'),
						aOrdGroupID:"",
						aUserType:UserType,
						aEpisodeID:EpisodeID,
						aLgnLocID:session['DHCMA.CTLOCID'],
						page:1,
						rows:99999
					},function(rs){
						$('#CPWItemOrder').datagrid({groupField:'OrdBuzTypeDesc',loadFilter:pagerFilter}).datagrid('loadData', rs);			
					});
					
				}
			}
		})
	});		
}
