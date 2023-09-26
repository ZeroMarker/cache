var init = function() {
	//=======================条件初始化start==================
	//科室
	var LocParams=JSON.stringify(addSessionParams({Type:"LinkLoc"}));
	var LocBox = $HUI.combobox('#FLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	//===========================条件初始end===========================
	// ======================tbar操作事件start=========================
	//清屏
	$UI.linkbutton('#ClearBT',{ 
		onClick:function(){
			Clear();
		}
	});
	var Clear=function(){
		$UI.clearBlock('#Conditions');
		$UI.clear(MasterGrid);
		var Dafult={
			FLocId:gLocObj,
			FStartDate:DateFormatter(new Date()),
			FEndDate:DateFormatter(new Date()),
			FInstComp:"Y",
			FStkTkComp:"N",
			FAdjComp:"N"
			}
		$UI.fillBlock('#Conditions',Dafult)
	}
	//查询
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			Query();
		}
	});
	function Query(){ 
		var ParamsObj=$UI.loopBlock('Conditions');
		if(isEmpty(ParamsObj.FLocId)){
				$UI.msg('alert','科室不能为空!');
				return;
			}
		if(isEmpty(ParamsObj.FStartDate)){
				$UI.msg('alert','开始日期不能为空!');
				return;
			}
		if(isEmpty(ParamsObj.FEndDate)){
				$UI.msg('alert','截止日期不能为空!');
				return;
			}
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(MasterGrid);
		$UI.setUrl(MasterGrid);
		MasterGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk',
			Params: Params,
			sort:'',
			order:''
		});
	}
	//选取
	$UI.linkbutton('#CompleteBT',{ 
		onClick:function(){
			SelectHandler();
		}
	});
	function SelectHandler(){
		var row = $('#MasterGrid').datagrid('getSelected');
		if(isEmpty(row)){
			$UI.msg('alert','请选择数据!');
			return;
		}
		if(isEmpty(row.inst)){
			$UI.msg('alert','参数错误!');
			return;
		}
		SelectModel(row,Select)
		
	}
	
	function Select(selectModel,instwWin) {
		var row = $('#MasterGrid').datagrid('getSelected');
		var InstId=row.inst;
		var PhaLoc=$('#FLocId').combobox('getValue');
		if(isEmpty(PhaLoc)){
			$UI.msg('alert','请选择科室!');
			return;
		}
		// 跳转到相应的录入界面
		if(selectModel==1){
			window.location.href='dhcstmhui.instktkitmwd.csp?Rowid='+InstId+'&LocId='+PhaLoc+'&InstwWin='+instwWin;
		}else if(selectModel==2){
			window.location.href='dhcstmhui.instktkitmwd2.csp?Rowid='+InstId+'&LocId='+PhaLoc+'&InstwWin='+instwWin;
		}else if(selectModel==3){
			window.location.href='dhcstmhui.instktkinput.csp?Rowid='+InstId+'&LocId='+PhaLoc+'&InstwWin='+instwWin;
		}else if(selectModel==4){
			window.location.href='dhcstmhui.instktkitmtrack.csp?Rowid='+InstId+'&LocId='+PhaLoc+'&InstwWin='+instwWin;
		}
	}
	
	//======================tbar操作事件end============================
	
	var MasterGridCm = [[ {
			title: 'inst',
			field: 'inst',
			hidden: true
		},{
			title: '盘点单号',
			field: 'instNo',
			width:150
		}, {
			title:"日期",
			field:'date',
			width:100
		}, {
			title:"时间",
			field:'time',
			width:100
		}, {
			title:"科室",
			field:'loc',
			hidden:true
		}, {
			title:"科室",
			field:'locDesc',
			width:120
		}, {
			title:"盘点完成",
			field:'comp',
			width:100,
			formatter: function(value,row,index){
				if (row.comp=="Y"){
					return "已完成";
				} else {
					return "未完成";
				}
			}
		}, {
			title:"实盘录入完成",
			field:'stktkComp',
			width:100,
			hidden: true
		}, {
			title:"调整完成",
			field:'adjComp',
			width:70,
			hidden: true
		}, {
			title:"标志",
			field:'manFlag',
			width:70,
			hidden: true
		}, {
			title:"账盘单位",
			field:'freezeUom',
			width:70,
			formatter: function(value,row,index){
				if (row.freezeUom==1){
					return "入库单位";
				} else {
					return "基本单位";
				}
			}
		}, {
			title:"包括不可用",
			field:'includeNotUse',
			width:100
		}, {
			title:"仅不可用",
			field:'onlyNotUse',
			width:70
		}, {
			title:"类组",
			field:'scgDesc',
			width:100
		}, {
			title:"库存分类",
			field:'scDesc',
			width:100
		}, {
			title:"开始货位码",
			field:'frSb',
			width:100
		}, {
			title:"结束货位码",
			field:'toSb',
			width:100
		}, {
			title:"录入类型",
			field:'InputType',
			width:100,
			formatter: function(value,row,index){
				if (row.InputType==1){
					return "分批次";
				} else if(row.InputType==2){
					return "按品种";
				}else if(row.InputType==3){
					return "按高值条码"
				}else {
					return ""
				}
			}
		}, {
			title:"打印标志",
			field:'printflag',
			width:70,
			hidden: true
		}, {
			title:"最低进价",
			field:'MinRp',
			width:70,
			align:'right'
		}, {
			title:"最高进价",
			field:'MaxRp',
			width:70,
			align:'right'
		}, {
			title:"随机数",
			field:'RandomNum',
			width:70,
			align:'right'
		}, {
			title:"高值标志",
			field:'HighValueFlag',
			width:70
		}
	]];
	var MasterGrid = $UI.datagrid('#MasterGrid',{
		url : $URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk'
		},
		columns: MasterGridCm
	})
	Clear();
}
$(init);
