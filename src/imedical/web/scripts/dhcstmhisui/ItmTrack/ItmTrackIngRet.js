var init = function() {
	
	/*--按钮事件--*/
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#MainConditions')
			if(isEmpty(ParamsObj.StartDate)){
				$UI.msg("alert","开始日期不能为空!");
				return;
			}
			if(isEmpty(ParamsObj.EndDate)){
				$UI.msg("alert","截止日期不能为空!");
				return;
			}
			if(isEmpty(ParamsObj.PhaLoc)){
				$UI.msg("alert","库房不能为空!");
				return;
			}
		
			ParamsObj.Status="Enable"
			var Params=JSON.stringify(addSessionParams(ParamsObj));
			$UI.clear(InitDetailGrid);
			$UI.clear(RetDetailGrid);
			TrackGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCItmTrack',
				QueryName: 'QueryTrack',
				Params:Params
			});
		}
	});
	
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Default();
		}
	});
	
	$UI.linkbutton('#SaveBT',{
		onClick:function(){
			Save();
		}
	});
	function Save(){
		var MainObj=$UI.loopBlock('#MainConditions')
		var Main=JSON.stringify(MainObj)
		var DetailObj = TrackGrid.getSelectedData();
		if(DetailObj===false){
				$UI.msg("alert","数据检查未通过!");
				return;
			}
			else if(DetailObj.length==0){
				$UI.msg('alert','没有需要保存的明细!')
				return;
			}			//验证未通过 不能保存
		var Detail=JSON.stringify(DetailObj)
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCItmTrackIngret',
			MethodName: 'CreatIngRet',
			Main: Main,
			Detail: Detail
			},function(jsonData){
				hideMask();
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					var arr=jsonData.rowid.split(",")
					var Init=arr[0]
					var RetId=arr[1]
					ReturnInfo(Init,RetId);
				}
				else{
					$UI.msg('error',jsonData.msg);
				}
			});
	}
	function ReturnInfo(Init,RetId){
		$UI.clear(InitDetailGrid);
		$UI.clear(RetDetailGrid);
		$UI.clearBlock('#InitInfo');
		$UI.clearBlock('#RetInfo');
		//本次退库
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCItmTrackIngret',
			MethodName: 'QueryInit',
			Init: Init
		},
		function(jsonData){
			$UI.fillBlock('#InitInfo',jsonData)
		});
		InitDetailGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCItmTrackIngret',
			QueryName: 'QueryIniti',
			Init:Init
		});
		//本次退货
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCItmTrackIngret',
			MethodName: 'QueryIngt',
			RetId: RetId
		},
		function(jsonData){
			$UI.fillBlock('#RetInfo',jsonData)
		});
		RetDetailGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCItmTrackIngret',
			QueryName: 'QueryIngti',
			RetId:RetId
		});
	}
	/*--Grid--*/
	var DetailCm = [[
		{
			title:"RowId",
			field:'RowId',
			hidden:true
		}, {
			title:"物资RowId",
			field:'InciId',
			hidden:true
		}, {
			title:"代码",
			field:'InciCode',
			width:100
		}, {
			title:"描述",
			field:'InciDesc',
			width:100
		}, {
			title:"高值条码",
			field:'HVBarCode',
			width:100
		}, {
			title:"规格",
			field:'Spec',
			width:100
		},{
			title:"批号",
			field:'BatNo',
			width:100
		}, {
			title:"效期",
			field:'ExpDate',
			width:100,
			align:'right'
		}, {
			title:"厂商",
			field:'ManfDesc',
			width:80
		}, {
			title:"数量",
			field:'Qty',
			width:80,
			align:'right'
		}, {
			title:"单位",
			field:'UomDesc',
			width:100
		}, {
			title:"进价",
			field:'Rp',
			width:100,
			align:'right'
		}, {
			title:"进价金额",
			field:'RpAmt',
			width:80,
			align:'right'
		}, {
			title:"售价",
			field:'Sp',
			width:80,
			align:'right'
		}, {
			title:"售价金额",
			field:'SpAmt',
			width:80,
			align:'right'
		}
	]];
	
	var RetDetailGrid = $UI.datagrid('#RetDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrackIngret',
			QueryName: 'QueryIngti'
		},
		columns: DetailCm
	})
	
	var InitDetailGrid = $UI.datagrid('#InitDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrackIngret',
			QueryName: 'QueryIniti'
		},
		columns: DetailCm
	})
	
	/*--Grid--*/
	var TrackCm = [[
		{field: 'ck',
			checkbox: true
		},{
			title:"RowId",
			field:'RowId',
			hidden:true
		}, {
			title: "操作",
			field: 'Icon',
			width: 50,
			align: 'center',
			formatter: function (value, row, index) {
				var str = "<a href='#' onclick='TrackInfo(" + row.RowId + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper_info.png' title='跟踪信息' border='0'></a>";
				return str;
			}
		}, {
			title:"物资RowId",
			field:'InciId',
			hidden:true
		}, {
			title:"代码",
			field:'InciCode',
			width:100
		}, {
			title:"描述",
			field:'InciDesc',
			width:100
		}, {
			title:"高值条码",
			field:'Label',
			width:100
		}, {
			title:"自带条码",
			field:'OriginalCode',
			width:100
		}, {
			title:"状态",
			field:'Status',
			formatter: StatusFormatter,
			width:100
		}, {
			title:"批次",
			field:'Incib',
			width:100,
			hidden:true
		}, {
			title:"批号",
			field:'BatNo',
			width:100,
			hidd:true
		}, {
			title:"效期",
			field:'ExpDate',
			width:100,
			hidd:true
		}, {
			title:"规格",
			field:'Spec',
			width:100
		}, {
			title:"具体规格",
			field:'SpecDesc',
			width:100
		}, {
			title:"单位",
			field:'UomDesc',
			width:80
		}, {
			title:"供应商",
			field:'VendorDesc',
			width:100
		}, {
			title:"厂商",
			field:'ManfDesc',
			width:100
		},{
			title:"当前位置",
			field:'CurrentLoc',
			width:80
		}, {
			title:"日期",
			field:'DhcitDate',
			width:100
		}, {
			title:"时间",
			field:'DhcitTime',
			width:100
		}, {
			title:"操作人",
			field:'DhcitUser',
			width:80
		}
	]];
	
	var TrackGrid = $UI.datagrid('#TrackGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'QueryTrack'
		},
		columns: TrackCm,
		singleSelect:false
	})
	
	var HandlerParams=function(){
		var PhaLoc=$("#PhaLoc").combo('getValue');
		var StkScg=$("#StkScg").combo('getValue');
		var Obj={StkGrpRowId:StkScg,StkGrpType:"M",Locdr:PhaLoc};
		return Obj
	}
	$("#InciDesc").lookup(InciLookUpOp(HandlerParams,'#InciDesc','#Inci'));
	
	var VendorParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	var VendorBox = $HUI.combobox('#Vendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	
	var CurrLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var CurrLocBox = $HUI.combobox('#CurrLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+CurrLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var PhaLocBox = $HUI.combobox('#PhaLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+JSON.stringify(addSessionParams({Type:'Login'})),
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#PhaLoc').combobox('setValue', session['LOGON.CTLOCID']);
	
	var VirtualFlag = $HUI.checkbox('#VirtualFlag',{
		onCheckChange: function(e, value){
			if(value){
				var FrLoc = $('#PhaLoc').combobox('getValue');
				var Info = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon','GetMainLoc',FrLoc);
				var InfoArr = Info.split('^');
				var VituralLoc = InfoArr[0], VituralLocDesc = InfoArr[1];
				AddComboData($('#PhaLoc'), VituralLoc, VituralLocDesc);
				$('#PhaLoc').combobox('setValue', VituralLoc);
			}else{
				$('#PhaLoc').combobox('setValue', gLocId);
			}
		}
	});
	
	/*--设置初始值--*/
	var Default=function(){
		$UI.clearBlock('#MainConditions');
		$UI.clearBlock('#InitInfo');
		$UI.clearBlock('#RetInfo');
		$UI.clear(TrackGrid);
		$UI.clear(InitDetailGrid);
		$UI.clear(RetDetailGrid);
		///设置初始值 考虑使用配置
		var DefaultValue={
			StartDate:TrackDefaultStDate(),
			EndDate:TrackDefaultEdDate(),
			PhaLoc:gLocObj,
			
			AuditFlag:'N'
		}
		$('#VirtualFlag').checkbox('setValue','false');
		$UI.fillBlock('#MainConditions',DefaultValue)
	}
	Default()
}
$(init);


//跟踪信息窗口
function TrackInfo(RowId) {
		$HUI.dialog('#FindWin').open()

		/*--Grid--*/
		var TrackDetailCm = [[
			{
				title:"RowId",
				field:'RowId',
				hidden:true
			}, {
				title:"类型",
				field:'Type',
				width:100,
				formatter:function(value){
					var TypeDesc="";
					if(value=="G"){
						TypeDesc="入库";
					}else if(value=="R"){
						TypeDesc="退货";
					}else if(value=="T"){
						TypeDesc="转移出库";
					}else if(value=="K"){
						TypeDesc="转移接收";
					}else if(value=="P"){
						TypeDesc="住院医嘱";
					}else if(value=="Y"){
						TypeDesc="住院医嘱取消";
					}else if(value=="A"){
						TypeDesc="库存调整";
					}else if(value=="D"){
						TypeDesc="库存报损";
					}else if(value=="F"){
						TypeDesc="门诊医嘱";
					}else if(value=="H"){
						TypeDesc="门诊医嘱取消";
					}else if(value=="RD"){
						TypeDesc="请求";
					}else if(value=="PD"){
						TypeDesc="采购";
					}else if(value=="POD"){
						TypeDesc="订单";
					}else if(value=='SG'){
						TypeDesc="补录入库";
					}else if(value=='ST'){
						TypeDesc="补录出库";
					}else if(value=='SK'){
						TypeDesc="补录出库-接收";
					}else if(value=='SR'){
						TypeDesc="补录入库-退货";
					}else if(value=='SP'){
						TypeDesc="补录医嘱消减";
					}
					return TypeDesc;
				}
			}, {
				title:"Pointer",
				field:'Pointer',
				width:100,
				hidden:true
			}, {
				title:"处理号",
				field:'OperNo',
				width:150
			}, {
				title:"日期",
				field:'Date',
				width:100
			}, {
				title:"时间",
				field:'Time',
				width:100
			}, {
				title:"操作人",
				field:'UserDesc',
				width:100
			}, {
				title:"位置信息",
				field:'OperOrg',
				width:150
			}
		]];
	
		var TrackDetailGrid = $UI.datagrid('#TrackDetailGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCItmTrack',
				QueryName: 'QueryTrackItm',
				Parref:RowId
			},
			onClickCell: function(index, filed ,value){
				TrackDetailGrid.commonClickCell(index,filed,value)
			},
			columns: TrackDetailCm,
			lazy:false
		})
	}