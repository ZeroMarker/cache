var objOrder = new Object();	
function ShowMakeOrderDialog(){
	$.parser.parse(); // 解析整个页面
	objOrder.replaceIndex=-1;	//替换序号
	objOrder.IsHaveDown=[];
	objOrder.IsChecking=false;	//防止死循环
	objOrder.IsUnChecking=false;
	objOrder.OrdContent=[];
	InitOCPWInfo();
	$('#OStepMore').on('click', function(){
		var Emvalue = $('#OStepMore').attr("value");
		ShowOSetpMore(Emvalue);
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
			return value + ' , 共( ' + rows.length + ' )项';
			},
		scrollbarSize: 0,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
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
						return "<span id='"+id+"'>"+value+chkPosDesc+"</span><label id= 'pop"+FJid+"' style='color:red;' onmouseover=ShowFJDetail("+FJid+") onmouseout=DestoryFJDetail("+FJid+")>[详细]</label>"
					}else{
						var id=FormOrdID.split("||").join("-");
						var chkPosDesc=row['OrdChkPosID'].split("||")[0];
						return "<span id='"+id+"'>"+value+chkPosDesc+"</span>"
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
			{field:'OrdIsDefault',title:'首选医嘱',width:'70'},
			{field:'OrdIsFluInfu',title:'主医嘱',width:'70'},
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
					if(data.rows[i].OrdCatCode != OrderType){
						// 类型不一致设为不可用
						$("input[type='checkbox']")[i+1].disabled = true;
						
						//直接过滤该行数据不显示
						//$("#CPWItemOrder").datagrid("deleteRow", i);
						//i=i-1;
					} else {
						if (data.rows[i].OrdIsDefault=="是") {	//首选医嘱
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
				$.messager.popover({msg: '当前界面禁止操作该医嘱！',type:'alert'});	
				return false;
			}
			if(row['xID'].indexOf("FJ")>-1){
				$.messager.popover({msg: '自定义方剂不支持此操作！',type:'alert'});	
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
				$('#gridGeneOrder').datagrid({'title':'当前医嘱：'+OrdMastIDDesc});
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
			if(field=="OrdGeneIDDesc"){
				/* objOrder.replaceIndex=index;
				var selData = $('#CPWItemOrder').datagrid('getRows')[index];
				var ArcimID=selData['OrdMastID']
				var OrdMastIDDesc=selData['OrdMastIDDesc']
				$('#gridGeneOrder').datagrid({'title':'当前医嘱：'+OrdMastIDDesc});
				objOrder.gridGeneOrder.load({
					ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
					QueryName:"QryOrderListByGene",
					aEpisodeID:EpisodeID.split("!!")[0],
					aArcimID:ArcimID
				});
				$HUI.dialog('#GeneCPWDialog').open(); */
			}else if(field=="OrdMastIDDesc"){
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
		onUnselect: function(index, row){
			var selData = $('#CPWItemOrder').datagrid('getRows')[index];
			var FormOrdID=selData['xID']
			var id=FormOrdID.split("||").join("-")
			//$("#"+id).popover('hide');
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
			var ItemDesc = row['ItemDesc'];
			if(ordLinkNum == "") return;
			objOrder.IsChecking=true;
			var Rows=$('#CPWItemOrder').datagrid('getRows');
			for (var ind=0;ind<Rows.length;ind++){
				if(index == ind) continue;
				var selData=Rows[ind];
				if((selData['OrdLnkOrdDr'] == ordLinkNum)&&(selData['ItemDesc']==ItemDesc)){	//相同关联号的医嘱同时操作
					$("#CPWItemOrder").datagrid("selectRow", ind);
					$("#CPWItemOrder").datagrid("checkRow", ind);
				}
			}
			objOrder.IsChecking=false;
		},
		onUncheck: function(index, row){
			if(objOrder.IsUnChecking) return;			
			var ordLinkNum=row['OrdLnkOrdDr'];
			var ItemDesc = row['ItemDesc'];
			if(ordLinkNum == "") return;
			objOrder.IsUnChecking=true;
			var Rows=$('#CPWItemOrder').datagrid('getRows');
			for (var ind=0;ind<Rows.length;ind++){
				if(index == ind) continue;
				var selData=Rows[ind];
				if((selData['OrdLnkOrdDr'] == ordLinkNum)&&(selData['ItemDesc']==ItemDesc)){	//相同关联号的医嘱同时操作
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
	$('#Addorder').on('click', function(){
		AddOrderToEntry();
	})
	$('#GetHelp').on('click', function(){
		$HUI.dialog('#HelpCPWDialog').open();
	})
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
	//同通用名医嘱列表
  	objOrder.gridGeneOrder = $HUI.datagrid("#gridGeneOrder",{
		fit: true,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
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

}

AddOrderToEntry = function(){
	var rows = $('#CPWItemOrder').datagrid("getChecked");
	if(rows.length==0) {
		$.messager.popover({msg: '未勾选任何医嘱!！',type:'alert'});	 
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

	$.messager.confirm("添加", "共【n】条医嘱项，【m】个医嘱套<br>确定要添加吗？".replace("n",cntAcrItm).replace("m",cntArcCos), function (r) {
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
							strOrder += '^' + "."+i;
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
						}
						var posStr=groups[ind][i].OrdChkPosID
						if(posStr!=""){
							strOrder += '^' + posStr.split("||")[1];
						}
						strOrderList +=  CHR_1 + strOrder;
					}
				}
			}

			if(strOrderList!=""){
				console.log(strOrderList)
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
		htmlIcon=htmlIcon+'<span class="OIcon OIcon-D">单</span>'
		htmlIcon=htmlIcon+'<span class="OIcon OIcon-B">变</span>'
		htmlIcon=htmlIcon+'<span class="OIcon OIcon-T">T</span>'
		htmlIcon=htmlIcon+'<span class="OIcon OIcon-Y">￥</span>'
		$('#OCPWIcon').html(htmlIcon)
		$(".OIcon-D").popover({
			content: '单病种信息：' + JsonObj.SDDesc
		});
		$(".OIcon-B").popover({
			content: JsonObj.VarDesc
		});
		$(".OIcon-T").popover({
			content: '入径天数：' + JsonObj.CPWDays + '天<br />计划天数：' + JsonObj.FormDays + '天'
		});
		$(".OIcon-Y").popover({
			content: '住院总费用：' + JsonObj.PatCost + '<br />计划费用：' + JsonObj.FormCost + '元'
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
		objOrder.TimeList=StepsArr[2].split("^");			//该路径所有步骤起止时间数组，EpDays:SttDate:EndDate
		objOrder.ConfList=StepsArr[3].split("^");			//该路径所有步骤是否确定数组，1、0
		objOrder.SignList=StepsArr[4].split("^");			//该路径所有步骤签名信息数组，SignDoc:SignNur:SignDocDate:SignNurDate
		objOrder.StepSelecedID=objOrder.StepCurrID;				//点击选中的步骤ID
		objOrder.CurrIndex=objOrder.StepList.indexOf(StepCurr);	//已经执行到当前步骤的下标
		
		//展现步骤
		ShowCPWSteps(objOrder.CurrIndex);
		//绑定点击事件
		$('#OStepMoreList .OselectStepMore').on('click', function(){
			SelectStep(this.id);
		});
		$('#OStepShow .Ostep').on('click', function(){
			var SelectedStepID=this.id.split("-")[1];
			objOrder.StepSelecedID=SelectedStepID;
			SelectStep(this.id);
			ShowStepDetail(this.id);
		});
		//展现步骤内容
		SelectStep("OStep-"+objOrder.StepCurrID);
	});	
	
}

//展现步骤
ShowCPWSteps = function(selectIndex){
	var StepSelect=objOrder.TimeList[selectIndex].split(":");
	$('#OStepTime').text(StepSelect[0]);
	$('#ODateFrom').datebox('setValue',StepSelect[1]);
	$('#ODateTo').datebox('setValue',StepSelect[2]);
	
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
	if(objOrder.StepSelecedID != objOrder.StepCurrID) {	//非当前步骤不允许添加医嘱
		$("#Addorder").linkbutton("disable");
	}else{
		$("#Addorder").linkbutton("enable");
	}
	//调整并展现步骤
	ShowCPWSteps(SelectedIndex);
	//展现步骤内容
	ShowStepDetail(IDStr);
	//绑定点击事件
	$('#OStepMoreList .OselectStepMore').on('click', function(){
		SelectStep(this.id);
	});
	$('#OStepShow .Ostep').on('click', function(){
		var SelectedStepID=this.id.split("-")[1];
		objOrder.StepSelecedID=SelectedStepID;
		SelectStep(this.id);
		ShowStepDetail(this.id);
	});
	ShowOSetpMore(0)	//关闭更多步骤
}

ShowStepDetail = function(IDStr){
	$("#OStepShow .Ostep").removeClass('selected');
	$("#"+IDStr).addClass('selected');
	$m({
		ClassName:"DHCMA.CPW.CPS.ImplementSrv",
		MethodName:"GetOrdItmTree",
		aPathwayID: objOrder.PathwayID, 
		aEpisID: objOrder.PathwayID+"||"+objOrder.StepSelecedID
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
				
				$cm ({
					ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
					QueryName:"QryPathFormEpItemOrdAll",
					ResultSetType:"array",
					aPathFormEpDr:PathFormEpID,
					aPathFormEpItemDr:PathFormEpItemID,
					page:1,
					rows:999
				},function(rs){
					$('#CPWItemOrder').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
				});
			},
			onLoadSuccess: function(node, data){
				if(data.length>0){
					var rootID=data[0].id;
					var node = $('#OItemTree').tree('find', rootID);
					$('#OItemTree').tree('select', node.target);
					$('#OItemTree').tree('check', node.target);
					PathFormEpID=rootID.split("-")[2];
					
					$cm ({
						ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
						QueryName:"QryPathFormEpItemOrdAll",
						ResultSetType:"array",
						aPathFormEpDr:PathFormEpID,
						aPathFormEpItemDr:"",
						page:1,
						rows:999
					},function(rs){
						$('#CPWItemOrder').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
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
		$('#OStepMore').text("收起▲");
	}else{
		$('#OStepMore').text("更多▼");
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
DestoryFJDetail = function(FJid){
	$('#pop'+FJid).popover('destroy');
}
