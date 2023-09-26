var init = function() {
	
	/*--按钮事件--*/
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#Conditions')
			if(isEmpty(ParamsObj.FStartDate)){
				$UI.msg("alert","开始日期不能为空!");
				return;
			}
			if(isEmpty(ParamsObj.FEndDate)){
				$UI.msg("alert","截止日期不能为空!");
				return;
			}
			if(isEmpty(ParamsObj.FLocId)){
				$UI.msg("alert","科室不能为空!");
				return;
			}
			ParamsObj.FInstComp='Y';	//账盘完成标志
			ParamsObj.FStkTkComp='Y';	//实盘完成标志
			ParamsObj.FAdjComp='Y';		//调整完成标志
			var Params=JSON.stringify(ParamsObj);
			MainGrid.load({
				ClassName: 'web.DHCSTMHUI.INStkTk',
				QueryName: 'jsDHCSTINStkTk',
				Params:Params
			});
		}
	});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Default();
		}
	});
	
	$HUI.radio("[name='LossFlag']",{
		onChecked:function(e,value){
			loadIFrame()
		}
	});
	
	$HUI.tabs("#DetailTabs",{
		onSelect:function(title,index){
			loadIFrame();
		}
	});
	
	function loadIFrame(){
		var DTTabed = $('#DetailTabs').tabs('getSelected');
		var DTTabed=$('#DetailTabs').tabs('getTabIndex',DTTabed);
		var Row=MainGrid.getSelected()
		if(isEmpty(Row)){
			$UI.msg("alert","请选择盘点单!");
			return;
		}
		var inst=Row.inst
		var LossFlagRadioObj = $("input[name='LossFlag']:checked");
		var LossFlag=LossFlagRadioObj.val();
		var Params=JSON.stringify(addSessionParams({StatFlag:LossFlag,Inst:inst}));
		Params=encodeUrlStr(Params)
		if(DTTabed=="0"){
			var p_URL=PmRunQianUrl+"?reportName=DHCSTM_HUI_instktkstat-detail.raq"+"&Params="+Params;
			$("#DetailIFrame").attr("src", p_URL);
		}
		else if(DTTabed=="1"){
			var p_URL=PmRunQianUrl+"?reportName=DHCSTM_HUI_instktkstat-inc.raq"+"&Params="+Params;
			$("#IncIFrame").attr("src", p_URL);
		}
		else if(DTTabed=="2"){
			var p_URL=PmRunQianUrl+"?reportName=DHCSTM_HUI_instktkstat_barcode.raq"+"&Params="+Params;
			$("#IncWithBarcodeIFrame").attr("src", p_URL);
		}
	}
	
	var MainGridCm = [[ {
			title: 'inst',
			field: 'inst',
			hidden: true
		}, {
			title: '盘点单号',
			field: 'instNo',
			width:100
		}, {
			title:"盘点日期",
			field:'date',
			width:80,
			align:'right'
		}, {
			title:"盘点时间",
			field:'time',
			width:80,
			align:'right'
		}, {
			title:"盘点人",
			field:'userName',
			width:80,
			align:'right'
		}, {
			title:"盘点完成",
			field:'comp',
			width:80,
			align:'right',
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
			width:80,
			align:'right',
			formatter: function(value,row,index){
				if (row.stktkComp=="Y"){
					return "已完成";
				} else {
					return "未完成";
				}
			}
		}, {
			title:"调整完成",
			field:'adjComp',
			width:80,
			align:'right',
			formatter: function(value,row,index){
				if (row.adjComp=="Y"){
					return "已完成";
				} else {
					return "未完成";
				}
			}
		}, {
			title:"重点关注标志",
			field:'manFlag',
			width:80,
			align:'right',
			hidden:true
		}, {
			title:"类组",
			field:'scgDesc',
			width:100,
			align:'right'
		}, {
			title:"库存分类",
			field:'scDesc',
			width:100,
			align:'right'
		}, {
			title:"开始货位码",
			field:'frSb',
			width:80,
			align:'right'
		}, {
			title:"结束货位码",
			field:'toSb',
			width:80,
			align:'right'
		}, {
			title:"输入类型",
			field:'InputType',
			width:80,
			align:'right',
			hidden:true
		}
	]];
	var MainGrid = $UI.datagrid('#MainGrid',{
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk'
		},
		columns: MainGridCm,
		onSelect:function(index, row){
			loadIFrame();
		},
		pagination:false
	})
	
	/*--绑定控件--*/
	var LocParams=JSON.stringify(addSessionParams({Type:"LinkLoc"}));
	var LocBox = $HUI.combobox('#FLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	/*--设置初始值--*/
	///return:起始日期
	function DefaultStDate(){
		var Today = new Date();
		var StDate = DateAdd(Today, 'd', parseInt(-7));
		return DateFormatter(StDate);
	}
	var Default=function(){
		$UI.clearBlock('#Conditions');
		$UI.clearBlock('#ReportConditions');
		$UI.clear(MainGrid);
		///设置初始值 考虑使用配置
		var DefaultValue={
			FStartDate:DefaultStDate(),
			FEndDate:new Date(),
			FLocId:gLocObj
		}
		$UI.fillBlock('#Conditions',DefaultValue);
		$("#DetailIFrame").attr("src", "");
		$("#IncIFrame").attr("src", "");
		$("#IncWithBarcodeIFrame").attr("src", "");
	}
	Default()
}
$(init);
