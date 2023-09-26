/*入库单审核*/
var init = function () {
	var Clear=function(){
		$UI.clearBlock('#FindConditions');
		$UI.clear(IOeoriMainGrid);
		$UI.clear(IOeoriDetailGrid);
		///设置初始值 考虑使用配置
		var Dafult = {
			StartDate: new Date(),
			EndDate: new Date()
		};
		$UI.fillBlock('#FindConditions',Dafult)
	}
	var FRecLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var FRecLocBox = $HUI.combobox('#LocId', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+FRecLocParams,
			valueField: 'RowId',
			textField: 'Description'
	});	
	
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			Query();
		}
	});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear();
		}
	});
	$UI.linkbutton('#SaveBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#FindConditions')
			var Params=JSON.stringify(ParamsObj);
			var mainData=IOeoriMainGrid.getSelectedData();
			var Detail=IOeoriDetailGrid.getChangesData('Inci');
			if (Detail === false){	//未完成编辑或明细为空
				return;
			}
			if (isEmpty(Detail)){	//明细不变
				$UI.msg("alert", "没有需要保存的明细!");
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.OeoriBindInci',
				MethodName: 'Save',
				Params:Params,
				MainInfo: mainData,
				ListDetail: JSON.stringify(Detail)
			},function(jsonData){
				if(jsonData.success === 0){
					$UI.msg('success', jsonData.msg);
					Query();
				}else{
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	$UI.linkbutton('#DelBT',{
		onClick:function(){
			var Row=IOeoriDetailGrid.getSelected();
			var IngrId=Row.IngrId;
			
		}
	});

	$('#BarCode').bind('keypress',function(event){
		if(event.keyCode == "13"){
			var barcode=document.getElementById("BarCode").value;
			if(barcode==""){
				$UI.msg('alert', '请输入条码!');
			}
			
			var info=tkMakeServerCall("web.DHCSTMHUI.DHCItmTrack","GetItmByBarcode",barcode);
			//var arrinfo=mianinfo.split("^")
			var info=$.parseJSON(info);
			if(info.Inclb==""){
				$UI.msg('alert', "没有相应库存记录,不能制单!");
				$("#BarCode").val("");
				return;
			}else if(info.IsAudit!="Y"){
				$UI.msg('alert', " 高值材料有未审核的"+lastDetailOperNo+",请核实!");
				return;
			}else if(info.Type=="T"){
				$UI.msg('alert', " 高值材料已经出库,不可制单!");
				return;
			}else if(info.Status!="Enable"){
				$UI.msg('alert', " 高值条码处于不可用状态,不可制单!");
				return;
			}
			
			var jsonData=tkMakeServerCall("web.DHCSTMHUI.DHCItmTrack","Select",barcode);
			var jsonData=$.parseJSON(jsonData);
			var record={
				Dhcit:jsonData.itmtrackid,
				InciCode:jsonData.incicode,
				InciDesc :jsonData.incidesc,
				BarCode:barcode,
				Manf:jsonData.manfdesc,
				Inclb:jsonData.inclb,
				BatExp:jsonData.expdate+"~"+jsonData.batno,
				Rp:jsonData.rp
			};
			OeoriDetailGrid.appendRow(record)
			$("#BarCode").val("");
		}
	});
	$('#wardno').bind('keypress', function (event) {
		if (event.keyCode == "13") {
			var wardno = $(this).val();
			if (wardno == "") {
				$UI.msg('alert', '请输入登记号!');
				return;
			}
			var patinfostr=tkMakeServerCall("web.DHCSTMHUI.HVMatOrdItm", "Pa",wardno);
			var patinfoarr=patinfostr.split("^");
			var newPaAdmNo=patinfoarr[0];
			var patinfo=patinfoarr[1]+","+patinfoarr[2];
			$("#wardno").val(newPaAdmNo);
		}
	});
	var OeoriMainCm = [[{
			title : "Oeori",
			field : 'Oeori',
			width : 100,
			hidden : true
		}, {
			title : "医嘱项代码",
			field : 'ArcimCode',
			width : 120
		}, {
			title : '医嘱项名称',
			field : 'ArcimDesc',
			width : 150
		}, {
			title : '患者登记号',
			field : 'PaAdmNo',
			width : 150
		}, {
			title : "患者姓名",
			field : 'PaAdmName',
			width : 200
		}, {
			title : "接收科室id",
			field : 'RecLoc',
			width : 200,
			hidden : true
		}, {
			title : '接收科室',
			field : 'RecLocDesc',
			width : 70
		}, {
			title : '医嘱日期',
			field : 'OeoriDate',
			width : 90,
			hidden: true
		}, {
			title : '医嘱录入人',
			field : 'UserAddName',
			width : 70
		}, {
			title : 'Inci',
			field : 'Inci',
			width : 70,
			hidden:'true'
		}
	]];
	var IOeoriMainGrid = $UI.datagrid('#IOeoriMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.OeoriBindInci',
			QueryName: 'QueryOeori'
		},
		columns: OeoriMainCm,
		showBar:false,
		onSelect:function(index, row){
			IOeoriDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.OeoriBindInci',
				QueryName: 'QueryDetail',
				Parref: row.rowid
			});
			InciMainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
				QueryName: 'GetDetail',
				Pack: row.Inci
			});
		}
	})
	var InciMainCm = [[{
			title : "PCL",
			field : 'PCL',
			width : 100,
			hidden : true
		}, {
			title : "Inci",
			field : 'Inci',
			width : 120,
			hidden : true
		}, {
			title : '物资代码',
			field : 'InciCode',
			width : 150
		}, {
			title : '物资名称',
			field : 'InciDesc',
			width : 150
		}, {
			title : "规格",
			field : 'Spec',
			width : 200
		}, {
			title : "进价",
			field : 'PbRp',
			width : 200
		}
	]];
	var InciMainGrid = $UI.datagrid('#InciMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
			QueryName: 'GetDetail'
		},
		columns: InciMainCm,
		showBar:false,
		onDblClickRow:function(index, row){
			var inci=row.Inci;
			var incicode=row.InciCode;
			var incidesc=row.InciDesc;
			var qty=1;
			var record={
				inci:inci,
				desc:incidesc,
				qty:1,
				code:incicode
				
			}
			IOeoriDetailGrid.appendRow(record);
		}
	})
	var OeoriDetailCm = [[{
			title : "orirowid",
			field : 'orirowid',
			width : 100,
			hidden : true
		}, {
			title : 'oeori',
			field : 'oeori',
			width : 80,
			hidden : true
		}, {
			title : 'inci',
			field : 'inci',
			width : 80,
			hidden : true
		}, {
			title : '物资代码',
			field : 'code',
			width : 80
		}, {
			title : '物资名称',
			field : 'desc',
			width : 80
		}, {
			title : '数量',
			field : 'qty',
			width : 80
		}, {
			title : '单位',
			field : 'uomdesc',
			width : 80
		}, {
			title: '批号',
			field: 'batno',
			width:200,
			editor:{
				type:'text',
				options:{
					}
				}
		}, {
			title: '效期',
			field: 'expdate',
			width:100,
			editor:{
				type:'datebox',
				options:{
					}
				}
		}, {
			title: '自带码',
			field: 'originalcode',
			width:200,
			editor:{
				type:'text',
				options:{
					}
				}
		}, {
			title : '规格',
			field : 'specdesc',
			width : 80
		}, {
			title : 'dhcit',
			field : 'dhcit',
			width : 80,
			hidden:'true'
		}, {
			title : '高值条码',
			field : 'barcode',
			width : 80
		}, {
			title : '补录标记',
			field : 'IngrFlag',
			width : 80
		}, {
			title : '进价',
			field : 'rp',
			width : 80
		}, {
			title : '售价',
			field : 'sp',
			width : 80
		}, {
			title : '发票金额',
			field : 'invamt',
			width : 80
		}, {
			title : '发票号',
			field : 'invno',
			width : 80
		}, {
			title : '发票日期',
			field : 'invdate',
			width : 80
		}, {
			title : '费用状态',
			field : 'feestatus',
			width : 80
		}, {
			title : '费用总额',
			field : 'feeamt',
			width : 80
		}, {
			title : '生成日期',
			field : 'dateofmanu',
			width : 80
		}, {
			title : '供应商',
			field : 'vendor',
			width : 80
		}, {
			title : '厂商',
			field : 'manf',
			width : 80
		}
		
	]];
	
	var IOeoriDetailGrid = $UI.datagrid('#IOeoriDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.OeoriBindInci',
			QueryName: 'QueryDetail'
		},
		columns: OeoriDetailCm,
		showBar:false
	})
	function Query(){
		var ParamsObj=$UI.loopBlock('#FindConditions')
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert', '开始日期不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.EndDate)){
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		var Params=JSON.stringify(ParamsObj);
		$UI.clear(IOeoriDetailGrid);
		$UI.clear(InciMainGrid);
		IOeoriMainGrid.load({
			ClassName: 'web.DHCSTMHUI.OeoriBindInci',
			QueryName: 'QueryItem',
			Params:Params
		});
	}
	
	Clear();

}
$(init);