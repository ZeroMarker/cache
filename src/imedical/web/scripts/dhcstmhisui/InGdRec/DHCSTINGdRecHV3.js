/*
入库单制单(高值供应商科室拆分)
*/
var InGdRecGrid, InGdRecMainGrid, InGdRecMainCm, InGdRecCm;
var init = function() {
	if (!UseItmTrack){
		$UI.msg('alert','未启用高值跟踪,此菜单不使用!');		
	}
	var UomCombox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required:true,
			mode:'remote',
			onBeforeLoad:function(param){
				var rows =InGdRecGrid.getRows();  
				var row = rows[InGdRecGrid.editIndex];
				if(!isEmpty(row)){
					param.Inci =row.IncId;
				}
			},
			onSelect:function(record){
				var rows =InGdRecGrid.getRows();  
				var row = rows[InGdRecGrid.editIndex];
				row.IngrUom=record.Description;
				var NewUomid=record.RowId;
				var OldUomid=row.IngrUomId;
				if(isEmpty(NewUomid)||(NewUomid==OldUomid)){return false;}
				var BUomId=row.BUomId;
				var rp=row.Rp;
				var sp=row.Sp;
				var newsp=row.NewSp;
				var confac=row.ConFacPur;
				if (NewUomid==BUomId){ //入库单位转换为基本单位
					var rp=row.Rp;
					var sp=row.Sp;
					var newsp=row.NewSp;
					row.Rp=Number(rp).div(confac);
					row.Sp=Number(sp).div(confac);
					row.NewSp=Number(newsp).div(confac);
				}else{ //基本单位转换为入库单位
					var rp=row.Rp;
					var sp=row.Sp;
					var newsp=row.NewSp;
					row.Rp=Number(rp).mul(confac);
					row.Sp=Number(sp).mul(confac);
					row.NewSp=Number(newsp).mul(confac);
				}
				if (isEmpty(row.RecQty)){
					var RpAmt = 0;
					var SpAmt = 0;
					var NewSpAmt=0;
				}else{
				var RpAmt=Number(row.Rp).mul(row.RecQty);
				var SpAmt=Number(row.Sp).mul(row.RecQty);
				var NewSpAmt=Number(row.NewSp).mul(row.RecQty);
				}
				row.RpAmt=RpAmt;
				row.InvMoney=RpAmt;
				row.SpAmt=SpAmt;
				row.NewSpAmt=NewSpAmt;
				row.IngrUomId=NewUomid;
				$('#InGdRecGrid').datagrid('refreshRow', InGdRecGrid.editIndex);
			},
			onShowPanel:function(){
				$(this).combobox('reload');
			}
		}
	};
	var reqLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var reqLocCombox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+reqLocParams,
			valueField: 'RowId',
			textField: 'Description',
			onSelect:function(record){
				var rows =InGdRecGrid.getRows();
				var row = rows[InGdRecGrid.editIndex];
				row.reqLocDesc=record.Description;
			},
			onShowPanel:function(){
				$(this).combobox('reload')
			}
		}
	};
	var PhManufacturerParams=JSON.stringify(addSessionParams({StkType:"M"}));
	var PhManufacturerBox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params='+PhManufacturerParams,
			valueField: 'RowId',
			textField: 'Description',
			onSelect:function(record){
				var rows =InGdRecGrid.getRows();
				var row = rows[InGdRecGrid.editIndex];
				row.Manf=record.Description
			},
			onShowPanel:function(){
				$(this).combobox('reload')
			}
		}
	};
	var SpecDescParams=JSON.stringify(sessionObj)
	var SpecDescbox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSpecDesc&ResultSetType=array&Params='+SpecDescParams,
			valueField: 'Description',
			textField: 'Description',
			mode:'remote',
			onBeforeLoad:function(param){
				var Select=InGdRecGrid.getSelected();
				if(!isEmpty(Select)){
					param.Inci =Select.IncId;
				}
			}
		}
	};
	var RecLocParams=JSON.stringify(addSessionParams({Type:"Login"}));
	var RecLocBox = $HUI.combobox('#RecLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+RecLocParams,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record){
				var LocId = record['RowId'];
				GetPurchaseUser(LocId);
			}
	});
	var IngrTypeIdParams=JSON.stringify(addSessionParams({Type:"IM"}));
	var IngrTypeIdBox = $HUI.combobox('#IngrTypeId', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOperateType&ResultSetType=array&Params='+IngrTypeIdParams,
			valueField: 'RowId',
			textField: 'Description',
			onLoadSuccess:function(){
				var IngrTypeId=GetIngrtypeDefa();
				$('#IngrTypeId').combobox('select',IngrTypeId);
		}
	});
	var PurchaseUserParams=JSON.stringify(addSessionParams({LocDr:"",UseAllUserAsPur:IngrParamObj.UseAllUserAsPur}));  //
	var PurchaseUserBox = $HUI.combobox('#PurchaseUser', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocPPLUser&ResultSetType=array&Params='+PurchaseUserParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	function GetPurchaseUser(RecLocid) {
			$('#PurchaseUser').combobox('clear');  
			$('#PurchaseUser').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocPPLUser&ResultSetType=Array&Params='
				+ JSON.stringify(addSessionParams({LocDr:RecLocid,UseAllUserAsPur:IngrParamObj.UseAllUserAsPur}))
			);
	}
	var AcceptUserIdParams=JSON.stringify(addSessionParams({LocDr:""}));
	var AcceptUserIdBox = $HUI.combobox('#AcceptUserId', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=array&Params='+AcceptUserIdParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var SourceOfFundParams=JSON.stringify(addSessionParams());
	var SourceOfFundBox = $HUI.combobox('#SourceOfFund', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSourceOfFund&ResultSetType=array&Params='+SourceOfFundParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var VirtualFlag = $HUI.checkbox('#VirtualFlag',{
		onCheckChange: function(e, value){
			if(value){
				var RecLoc = $('#RecLoc').combobox('getValue');
				var Info = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon','GetMainLoc',RecLoc);
				var InfoArr = Info.split("^");
				var VituralLoc = InfoArr[0], VituralLocDesc = InfoArr[1];
				AddComboData($('#RecLoc'), VituralLoc, VituralLocDesc);
				$('#RecLoc').combobox('setValue', VituralLoc);
			}else{
				$('#RecLoc').combobox('setValue', gLocId);
			}
		}
	});
	
	var IngrClear=function(){
		$UI.clearBlock('#MainConditions');
		$UI.clear(InGdRecMainGrid);
		$UI.clear(InGdRecGrid);
		///设置初始值 考虑使用配置
		var Dafult={
			RecLoc:gLocObj,
			IngrId:"",
			CreateDate:DateFormatter(new Date())
		}
		$UI.fillBlock('#MainConditions',Dafult);
		var IngrTypeId=GetIngrtypeDefa();
		$('#IngrTypeId').combobox('select',IngrTypeId);
	}
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			var Rows=InGdRecMainGrid.getRows();
			for(var i = 0; i < Rows.length; i++){
				var Complete = Rows[i].Complete;
				var InGrNo = Rows[i].InGrNo;
				if(Complete=='N'){
					$UI.msg('alert', '入库单'+InGrNo+'尚未完成,不能清屏！');
					return;
				}
			}
			var DetailObj=InGdRecGrid.getChangesData();
			if (DetailObj.length>0){
				$UI.confirm('数据已做修改,确定要清屏吗?','','', IngrClear);
			}else{
				IngrClear();
			}
		}
	});
	$UI.linkbutton('#ComBT',{
		onClick:function(){
			var DetailObj=InGdRecGrid.getChangesData();
			if (DetailObj.length>0){
				$UI.confirm('数据已做修改,确定要继续吗?','','', MakeComplete);
			}else{
				var RecDesc=$HUI.combobox("#RecLoc").getText();
				$UI.confirm('当前入库科室是 '+RecDesc+' 确定是否继续?','','', MakeComplete);
			}
		}
	});
	function MakeComplete(){
		var Row=InGdRecMainGrid.getSelected();
		if(isEmpty(Row)){
			$UI.msg('alert','请选择入库单!');
			return false;
		}
		var index = InGdRecMainGrid.getRowIndex(Row);
		var Rowid=Row.IngrId;
		if(isEmpty(Rowid)){
			$UI.msg('alert','入库单不存在!');
			return false;
		}
		if($HUI.checkbox("#Complete").getValue()){
			$UI.msg('alert','入库单已完成!');
			return false;
		}
		var RowData=InGdRecGrid.getRowsData();
		if(isEmpty(RowData) || RowData.length==0){
			$UI.msg('alert','入库单无明细!');
			return false;
		}
		var Params=JSON.stringify(addSessionParams());
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'jsMakeComplete',
			IngrId: Rowid,
			Params:Params
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				InGdRecMainGrid.deleteRow(index);
				if((IngrParamObj.AutoAuditAfterComp=='Y') && (IngrParamObj.AutoPrintAfterAudit=='Y')){
					PrintRecHVCol(gIngrRowid, 'Y');
				}
				$UI.clear(InGdRecGrid);
			}else{
				$UI.msg('error',jsonData.msg);		
			}
		});
		}
	$UI.linkbutton('#PrintBT',{
		onClick:function(){
			var Row=InGdRecMainGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert','请选择入库单!');
				return false;
			}
			if(isEmpty(Row)){
				$UI.msg('alert','请选择需要打印的入库单!');
				return false;
			}
			if (($HUI.checkbox("#Complete").getValue()==false)&&(IngrParamObj.PrintNoComplete=="N")){
				$UI.msg('alert','不允许打印未完成的入库单!');
				return false;
			}
			var Rowid=Row.IngrId;
			PrintRec(Rowid);
		}
	});
	
	$UI.linkbutton('#PrintHVColBT',{
		onClick:function(){
			var Row=InGdRecMainGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert','请选择入库单!');
				return false;
			}
			if(isEmpty(Row)){
				$UI.msg('alert','请选择需要打印的入库单!');
				return false;
			}
			if (($HUI.checkbox("#Complete").getValue()==false)&&(IngrParamObj.PrintNoComplete=="N")){
				$UI.msg('alert','不允许打印未完成的入库单!');
				return false;
			}
			var Rowid=Row.IngrId;
			PrintRecHVCol(Rowid);
		}
	});

	InGdRecMainCm = [[{
			title : "RowId",
			field : 'IngrId',
			width : 100,
			hidden : true
		}, {
			title : "入库单号",
			field : 'InGrNo',
			width : 120
		}, {
			title : "ApcvmDr",
			field : 'ApcvmDr',
			width : 30,
			hidden : true
		}, {
			title : "供应商",
			field : 'VendorDesc',
			width : 200
		}, {
			title : "ReqLocId",
			field : 'ReqLocId',
			width : 30,
			hidden : true
		}, {
			title : "请求科室",
			field : 'ReqLocDesc',
			width : 200
		}, {
			title : "完成标志",
			field : 'Complete',
			width : 70
		}	
	]];
	InGdRecMainGrid = $UI.datagrid('#InGdRecMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'Query',
			rows:99999
		},
		columns: InGdRecMainCm,
		pagination: false,
		onSelect:function(index, row){
			$UI.setUrl(InGdRecGrid)
			InGdRecGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
				QueryName: 'QueryDetail',
				Parref: row.IngrId,
				rows: 99999
			});
		}
	});
		var addOneRow={
			text: '新增',
			iconCls: 'icon-add',
			handler: function () {
				var AllRows=InGdRecGrid.getRows();
				var LastRowIndex=InGdRecGrid.editIndex;
				var Row=AllRows[LastRowIndex];
				var DefaData={};
				if ((!isEmpty(AllRows))&&(!isEmpty(Row))){
					if (IngrParamObj.CompareNamePrice=='Y'){  //同上次入库判断是否改价;改名称;
						var Inci=Row.IncId;
						var Rp=Row.Rp;
						var Incidesc=Row.IncDesc;
						var CompareNamePrice=tkMakeServerCall("web.DHCSTMHUI.DHCINGdRec","CheckNamePrice",Inci,Rp);
						if (CompareNamePrice == -1){
							$UI.msg('alert',Incidesc+'的名称已修改!')
							}
						if (CompareNamePrice == -2){
							$UI.msg('alert',Incidesc+'的进价已调整!')
							}
					}
						var tmpInvNo=Row.InvNo;
						var tmpInvDate=Row.InvDate;
						if (IngrParamObj.DefaInvNo=="Y"){
							var DefaData={InvNo:tmpInvNo,InvDate:tmpInvDate};
						}
				}
				InGdRecGrid.commonAddRow(DefaData);
			}
	};
	InGdRecCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width:100
		}, {
			title: '物资RowId',
			field: 'IncId',
			hidden: true,
			width:100			
		}, {
			title: '物资代码',
			field: 'IncCode',
			width:100
		}, {
			title: '物资名称',
			field: 'IncDesc',
			width: 230
		}, {
	        	title: "规格",
	       		field:'Spec',
	        	width: 100
	    	}, {
	        	title: "高值条码",
	       		field:'HVBarCode',
			width: 150,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}
			}
	    	}, {
			title: "确认",
			field:'Confirmed',
			width: 50,
			align: 'center',
			formatter: function (value, row, index) {
				var str = "<a href='#' onclick='Confirm(" + index + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png' title='确认' border='0'></a>";
				return str;
			}
		}, {
			title : "高值标志",
			field : 'HVFlag',
			width : 80,
			hidden : true
		}, {
		        title:"厂商",
		        field:'ManfId',
			width:150,
			formatter: CommonFormatter(PhManufacturerBox,'ManfId','Manf'),
			editor:PhManufacturerBox
	   	 }, {
			title : "批号",
			field : 'BatchNo',
			width : 90,
			editor:{
				type:'text',
				options:{
					}
				}
		}, {
			title : "有效期",
			field : 'ExpDate',
			width : 150,
			editor:{
				type:'datebox',
				options:{
					}
				}
		}, {
			title : "单位",
			field : 'IngrUomId',
			width : 80,
			formatter: CommonFormatter(UomCombox,'IngrUomId','IngrUom'),
			editor:UomCombox
		}, {
			title : "数量",
			field : 'RecQty',
			width : 80,
	        	align : 'right',
			editor:{
				type:'numberbox',
				options:{
					required:true
					}
				}
		}, {
			title : "进价",
			field : 'Rp',
			width : 60,
	        	align : 'right',
			editor:{
				type:'numberbox',
				options:{
					required:true
					}
				}
		}, {
			title : "售价",
			field : 'Sp',
			width : 60,
	        	align : 'right'
		}, {
			title : "当前加成",
			field : 'Marginnow',
			width : 60
		}, {
			title : "入库售价",
			field : 'NewSp',
			width : 60,
	        	align : 'right',
			editor:{
				type:'numberbox',
				options:{
					required:true
					}
				}
		}, {
			title : "发票号",
			field : 'InvNo',
			width : 80,
			editor:{
				type:'numberbox',
				options:{
					}
				}
		}, {
			title :"发票金额",
			field :'InvMoney',
			width :80,
	        	align : 'right'
		}, {
			title : "发票日期",
			field : 'InvDate',
			width : 100,
			editor:{
				type:'datebox',
				options:{
					}
				}
		},{
			title : "质检单号",
			field : 'QualityNo',
			width : 90,
			editor:{
				type:'text',
				options:{
					}
				}
		},{
			title : "随行单号",
			field : 'SxNo',
			width : 90,
			editor:{
				type:'text',
				options:{
					}
				}
		}, {
			title : "进货金额",
			field : 'RpAmt',
			width : 100,
	        	align : 'right'
		}, {
			title : "入库售价金额",
			field : 'NewSpAmt',
			width : 100,
	        	align : 'right'
		},{
			title : "定价类型",
			field : 'MtDesc',
			width : 180
		},{
			title : "招标轮次",
			field : 'PubDesc',
			width : 180
		},{
			title : "摘要",
			field : 'Remark',
			width : 90,
			editor:{
				type:'text',
				options:{
					}
				}
		},{
			title : "备注",
			field : 'Remarks',
			width : 90,
			editor:{
				type:'text',
				options:{
					}
				}
		},{
			title : "BUomId",
			field : 'BUomId',
			width : 10,
			hidden : true
		},{
			title : "ConFacPur",
			field : 'ConFacPur',
			width : 10,
			hidden : true
		},{
			title : "MtDr",
			field : 'MtDr',
			width : 10,
			hidden : true
		},{
			title : "MtDr2",
			field : 'MtDr2',
			width : 10,
			hidden : true
		},{
			title : "灭菌批号",
			field : 'SterilizedNo',
			width : 90,
			editor:{
				type:'text',
				options:{
					}
				}
		}, {
			title : '订购数量',
			field : 'InPoQty',
			width : 20,
	        	align : 'right',
			hidden:true,
		},{
			title : "批号要求",
			field : 'BatchReq',
			width : 10,
			hidden : true
		},{
			title : "有效期要求",
			field : 'ExpReq',
			width : 10,
			hidden : true
		}, {
			title : "条码",
			field : 'BarCode',
			width : 180
		}, {
			title : "注册证号",
			field : 'AdmNo',
			width : 90,
			editor:{
				type:'text',
				options:{
					}
				}
		}, {
			title : "注册证有效期",
			field : 'AdmExpdate',
			width : 100,
			editor:{
				type:'datebox',
				options:{
					}
				}
		},{
			title:"具体规格",
			field:'SpecDesc',
			width:100,
			formatter: CommonFormatter(SpecDescbox,'SpecDesc','SpecDesc'),
			editor:SpecDescbox
		},{
			title : "请求部门",
			field : 'reqLocId',
			width : 80,
			formatter: CommonFormatter(reqLocCombox,'reqLocId','reqLocDesc'),
			editor:reqLocCombox
		}, {
			title : "单品税额",
			field : 'Tax',
			width : 100,
	        	align : 'right',
			editor:{
				type:'numberbox',
				options:{
					}
				}
		}, {
			title : "单品总税额",
			field : 'TaxAmt',
			width : 100,
	        	align : 'right'
		}, {
			title : '自带条码',
			field : 'OrigiBarCode',
			width : 80
		}, {
			title : 'vendor',
			field : 'vendor',
			width : 80,
			hidden : true
		}, {
			title : '供应商',
			field : 'VendorDesc',
			width : 100
		},{
			title : "reqLocId",
			field : 'reqLocId',
			width : 80,
			hidden : true
		},{
			title : "请求科室",
			field : 'reqLocDesc',
			width : 100
		}		
	]];
	function ReturnInfoFunc(RowData, row){
		//RowData.SterilizedDate = row.SterilizedDate;
		//RowData.ProduceDate = row.ProduceDate;
		var RecLocId = $('#RecLoc').combobox('getValue');
		var ParamsObj = addSessionParams({RecLocId: RecLocId});
		var Params = JSON.stringify(ParamsObj);
		var ItmData = $.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'GetItmInfo',
			IncId: row.Inci,
			Params: Params
		},false);
		var tmpManfId="";tmpManf="";tmpBatchNo="";tmpExpDate="";tmpAdmNo="";tmpAdmExpdate="";Margin=0;
		if (!isEmpty(row.ManfId)){
			tmpManfId = row.ManfId;
			tmpManf = row.ManfDesc;
		}else{
			tmpManfId = ItmData.ManfId;
			tmpManf = ItmData.ManfDesc;
		}
		if (!isEmpty(row.BatNo)){
			tmpBatchNo = row.BatNo;
		}else{
			tmpBatchNo = ItmData.BatNo;
		}
		if (!isEmpty(row.ExpDate)){
			tmpExpDate = row.ExpDate;
		}else{
			tmpExpDate = ItmData.ExpDate;
		}
		if (!isEmpty(row.CertNo)){
			tmpAdmNo = row.CertNo;
		}else{
			tmpAdmNo = ItmData.CertNo;
		}
		if (!isEmpty(row.CertExpDate)){
			tmpAdmExpdate = row.CertExpDate;
		}else{
			tmpAdmExpdate = ItmData.CertExpDate;
		}
		//加成率
		var Sp=ItmData.BSp;
		var Rp=row.BRp;
		if (Sp!=0){
			Margin = accSub(accDiv(Sp,Rp),1);
		}
		var MaxSp=ItmData.MaxSp;
		if ((IngrParamObj.ValidateMaxSp=="Y")&&(!isEmpty(MaxSp))){
			if (Number(ItmData.BSp)>Number(MaxSp)){
				$UI.msg('alert','当前售价高于最高售价!');
				//return false;
			}
		}
		InGdRecGrid.updateRow({
			index:InGdRecGrid.editIndex,
			row: {
				Inci:row.InciDr,
				IncId : row.Inci,
				IncCode : row.Code,
				IncDesc : row.Description,
				Inpoi : row.Poi,
				RecQty : 1,
				Rp : row.BRp,
				RpAmt : row.BRp,
				SpecDesc : row.SpecDesc,
				reqLocId : row.ReqLoc,
				reqLocDesc : row.ReqLocDesc,
				SxNo : row.SxNo,
				SterilizedNo : row.SterilizedNo,
				OrigiBarCode : row.OrigiBarCode,
				ManfId : tmpManfId,
				Manf : tmpManf,
				BatchNo : tmpBatchNo,
				ExpDate : tmpExpDate,
				AdmNo : tmpAdmNo,
				AdmExpdate : tmpAdmExpdate,
				Sp : ItmData.BSp,
				SpAmt : ItmData.BSp,
				NewSp : ItmData.BSp, 
				NewSpAmt : ItmData.BSp,
				InvMoney : row.BRp,
				Spec : ItmData.Spec,
				HVFlag : ItmData.HVFlag,
				BUomId : ItmData.BUomId,
				IngrUomId : ItmData.BUomId,
				IngrUom : ItmData.BUomDesc,
				MtDr : ItmData.MtDr,
				MtDesc : ItmData.MtDesc,
				PubDesc : ItmData.PbDesc,
				ConFacPur : ItmData.ConFac,
				BatchReq : ItmData.BatchReq,
				ExpReq : ItmData.ExpReq,
				Marginnow :Margin,
				vendor : ItmData.vendor,
				VendorDesc : ItmData.vendordesc,
				reqLocId : row.ReqLoc,
				reqLocDesc : row.ReqLocDesc
			}
		});
		var RowIndex = $('#InGdRecGrid').datagrid('getRowIndex', RowData);
		$('#InGdRecGrid').datagrid('refreshRow', RowIndex);
	}
	InGdRecGrid = $UI.datagrid('#InGdRecGrid', {
		url:'',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			QueryName: 'QueryDetail',
			rows:99999
		},
		columns: InGdRecCm,
		showBar:true,
		pagination: false,
		toolbar:[addOneRow], 
		onClickCell: function(index, field ,value){	
			if($HUI.checkbox("#Complete").getValue()){
				$UI.msg('alert','入库单已完成!');
				return false;
			}
			var Row = InGdRecGrid.getRows()[index];
			if ((!isEmpty(Row.IncId)&&((field == 'HVBarCode')||(field == 'IngrUomId')||(field == 'RecQty')))) {
				return false;
			}
			if ((field == 'ExpDate')&&(Row.ExpReq=="N")) {
				return false;
			}
			if ((field == 'BatchNo')&&(Row.BatchReq=="N")) {
				return false;
			}
			InGdRecGrid.commonClickCell(index,field,value);
		},
		onBeforeEdit:function(index,row){
			if($HUI.checkbox("#Complete").getValue()){
				$UI.msg('alert','入库单已完成!');
				return false;
			}
		},
		onBeginEdit: function(index, row){
			var ed = $('#InGdRecGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++){
				var Editor = ed[i];
				if(Editor.field == 'HVBarCode'){
					$(Editor.target).bind('keydown', function(event){
						if(event.keyCode == 13){
							var BarCode = $(this).val();
							if(isEmpty(BarCode)){
								return false;
							}
							var FindIndex = InGdRecGrid.find('HVBarCode', BarCode);
							if(FindIndex >= 0 && FindIndex != index){
								$UI.msg('alert','条码不可重复录入!');
								$(this).val('');
								$(this).focus();
								return false;
							}
							var BarCodeData = $.cm({
								ClassName: 'web.DHCSTMHUI.DHCItmTrack',
								MethodName: 'GetItmByBarcode',
								BarCode: BarCode
							},false);
							if(!isEmpty(BarCodeData.success) && BarCodeData.success != 0){
								$UI.msg('alert',BarCodeData.msg)
								$(this).val('');
								$(this).focus();
								return false;
							}
							var NowDate = DateFormatter(new Date());
							var ScgStk = BarCodeData['ScgStk'];
							var ScgStkDesc = BarCodeData['ScgStkDesc'];
							var dhcitLocId = BarCodeData['dhcitLocId'];
							var IsAudit = BarCodeData['IsAudit'];
							var OperNo = BarCodeData['OperNo'];
							var Type = BarCodeData['Type'];
							var Status = BarCodeData['Status'];
							var RecallFlag = BarCodeData['RecallFlag'];
							var Inci = BarCodeData['Inci'];
							var Code = BarCodeData['Code'];
							var Description = BarCodeData['Description'];
							var dhcit = BarCodeData['dhcit'];
							var ManfId = BarCodeData['ManfId'],ManfDesc = BarCodeData['ManfDesc'];
							var Poi = BarCodeData['Poi'],BatNo = BarCodeData['BatNo'],ExpDate = BarCodeData['ExpDate'];
							var CertNo = BarCodeData['CertNo'],CertExpDate = BarCodeData['CertExpDate'],BRp = BarCodeData['BRp'];
							if((Type!="Reg" && Type!="G")||(Type=="G" && IsAudit=="Y")){
								$UI.msg('alert','该条码已办理入库!');
								$(this).val('');
								$(this).focus();
								return false;
							}else if(Type=="G" && IsAudit!="Y"){
								$UI.msg('alert','该条码有未审核的'+OperNo+',请核实!');
								$(this).val('');
								$(this).focus();
								return false;
							}else if(!isEmpty(dhcitLocId)&&(gLocId!=dhcitLocId)){
								$UI.msg('alert','此条码非本科室注册条码!');
								$(this).val('');
								$(this).focus();
								return false;
							}else if((!isEmpty(ExpDate))&&(FormatDate(NowDate)>=FormatDate(ExpDate))){
								$UI.msg('alert','此条码注册时候维护的效期已过期!');
							}
							row['HVBarCode'] = BarCode;
							row['dhcit'] = dhcit;
							ReturnInfoFunc(row, BarCodeData);
						}
					});
				}
			}
		},
		beforeAddFn:function(){
			var ParamsObj=GetParamsObj();
			if($HUI.checkbox("#Complete").getValue()){
				$UI.msg('alert','入库单已完成!');
				return false;
			}
			if(isEmpty(ParamsObj.RecLoc)){
				$UI.msg('alert','入库科室不能为空!');
				return false;
			}
			if((IngrParamObj.ImpTypeNotNull=="Y")&&(isEmpty(ParamsObj.IngrTypeId))){
				$UI.msg('alert','入库类型不能为空!!');
				return false;
			}
			if(IngrParamObj.MakeByPoOnly=="Y"){
				$UI.msg('alert','必须依据订单入库,不能增加!');
				return false;
			}
			if((IngrParamObj.RequiredSourceOfFund=="Y")&&(isEmpty(ParamsObj.SourceOfFund))){
				$UI.msg('alert','资金来源不能为空!');
				return false;
			}
		},
		onEndEdit:function(index, row, changes){
			var Editors = $(this).datagrid('getEditors', index);
		    for(var i=0;i<Editors.length;i++){
				var Editor = Editors[i];
				if(Editor.field=='ExpDate'){
					var ExpReq=row.ExpReq;
					var ExpDate=row.ExpDate;
					var IncId=row.IncId;
					var NowDate = DateFormatter(new Date());
					if ((isEmpty(ExpDate))&&(ExpReq=="R")){
						$UI.msg('alert',"有效期不可为空!");
						InGdRecGrid.checked=false;
						return false;
					}
					if ((!isEmpty(ExpDate))&&(FormatDate(NowDate)>=FormatDate(ExpDate))){
						$UI.msg('alert',"有效期不能小于或等于当前日期!");
						InGdRecGrid.checked=false;
						return false;
					}
					if ((!isEmpty(ExpDate)) && (ExpReq == "R")){
						var ExpDateMsg = ExpDateValidator(ExpDate, IncId);
						if(!isEmpty(ExpDateMsg)){
							$UI.msg('alert', '第' + row + '行' + ExpDateMsg );
							InGdRecGrid.checked=false;
							return false;
						}
					}
					if ((!isEmpty(ExpDate)) && (ExpReq == "N")) {
						$UI.msg('alert', "有效期不允许填写!");
						InGdRecGrid.checked = false;
						return false;
					}
				}else if(Editor.field=='BatchNo'){
					var BatchReq=row.BatchReq;
					var BatchNo=row.BatchNo;
					var IncId=row.IncId;
					if ((isEmpty(BatchNo))&&(BatchReq=="R")){
						$UI.msg('alert',"批号不可为空!");
						InGdRecGrid.checked=false;
						return false;
					}
					if ((!isEmpty(BatchNo)) && (BatchReq == "N")) {
						$UI.msg('alert', "批号不允许填写!");
						InGdRecGrid.checked=false;
						return false;
					}
				}else if(Editor.field=='Rp'){
					var rp = row.Rp;
					if (isEmpty(rp)) {
						$UI.msg('alert',"进价不能为空!");
						InGdRecGrid.checked=false;
						return false;
					}else if (rp < 0) {
						//2016-09-26进价可为0
						$UI.msg('alert',"进价不能小于0!");
						InGdRecGrid.checked=false;
						return false;
					}
					var IncId=row.IncId;
					var UomId=row.IngrUomId;
					var sp = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'GetSpForRec', IncId, UomId, rp, SessionParams);
					row.Sp=sp;
					//验证加成率
					var ChargeFlag = tkMakeServerCall('web.DHCSTMHUI.Common.DrugInfoCommon','GetChargeFlag',IncId);
					var margin = 0;
					if((rp!=0) && (ChargeFlag=='Y')){
						margin = accSub(accDiv(sp, rp), 1);
						if((IngrParamObj.MarginWarning!=0) &&((margin>IngrParamObj.MarginWarning) || (margin<0))){
							$UI.msg('alert',"加成率超出限定范围!");
							InGdRecGrid.checked=false;
							return false;
						}
					}
					// 计算指定行的进货金额
					var RealTotal = accMul(row.RecQty, rp);
					row.NewSp=sp;
					row.NewSpAmt=sp;
					row.RpAmt=RealTotal;
					row.InvMoney=RealTotal;
					row.Marginnow=margin.toFixed(3);
					/// 是否调价
					var PriorPriceInfo=tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'GetPrice', IncId, UomId,SessionParams);
					var PriorPriceArr=PriorPriceInfo.split("^");
					var PriorRp=PriorPriceArr[0];
					var PriorSp=PriorPriceArr[1];
					var ResultRp=row.Rp;
					var ResultSp=row.Sp;
					var AllowAspWhileReceive=IngrParamObj.AllowAspWhileReceive;
					var IfExitPriceAdj=tkMakeServerCall('web.DHCSTMHUI.INAdjSalePrice', 'CheckItmAdjSp', IncId,"");
					if ((AllowAspWhileReceive=="Y")&&(Number(PriorSp)!=Number(ResultSp))&&(IfExitPriceAdj!=1))
					{
						var Scg="";
						var LocDr=$("#RecLoc").combo('getValue');
						var Obj={Incid:row.IncId,Incicode:row.IncCode,Incidesc:row.IncDesc,PriorRp:PriorRp,PriorSp:PriorSp,
										ResultRp:ResultRp,ResultSp:ResultSp,AdjSpUomId:row.IngrUomId,StkGrpType:Scg,LocDr:LocDr};
						var adjPriceObj=addSessionParams(Obj);
						$UI.confirm('价格发生变化，是否生成调价单?','','',SetAdjPrice,"","","","",adjPriceObj);
					}
				}else if(Editor.field=='RecQty'){
					var Tax=row.Tax;
					var RecQty=row.RecQty;
					var Rp=row.Rp;
					if ((isEmpty(RecQty))||(RecQty<=0)){
						$UI.msg('alert',"入库数量不能小于或等于0!");
						InGdRecGrid.checked=false;
						return false;
					}
					var InPoQty=row.InPoQty;
					if ((IngrParamObj.RecQtyExceedOrderAllowed != "Y") && (InPoQty!="") && (Number(RecQty) > Number(InPoQty))){
						$UI.msg('alert',"入库数量不能大于订购数量!");
						InGdRecGrid.checked=false;
						return false;
					}
					var RealTotal = accMul(Rp,RecQty);
					if(!isEmpty(Tax)){
						var TaxAmt = accMul(Tax,RecQty);
						row.TaxAmt=TaxAmt;
					}
					row.RpAmt=RealTotal;
					row.InvMoney=RealTotal;
				}else if(Editor.field=='Tax'){
					var Tax=row.Tax;
					var RecQty=row.RecQty;
					var TaxAmt = accMul(Tax,RecQty);
					row.TaxAmt=TaxAmt;
				}else if(Editor.field=='InvNo'){
					var Ingritmid=row.RowId;
					if (isEmpty(Ingritmid)) {return true;}
					var IngrId=Ingritmid.spilt("||")[0];
					var flag=InvNoValidator(row.InvNo,IngrId);
					if(flag==false){
						$UI.msg('alert',"发票号" + row.InvNo + "已存在于别的入库单!");
					}
					if ((isEmpty(row.InvNo))&&(IngrParamObj.InvNoNotNull=="Y")){
						$UI.msg('alert',"发票号不可为空!");
						InGdRecGrid.checked=false;
						return false;
					}
				}else if(Editor.field=='NewSp'){
					var NewSp=row.NewSp;
					if ((isEmpty(NewSp))||(NewSp<=0)){
						$UI.msg('alert',"入库售价不能小于或等于0!");
						InGdRecGrid.checked=false;
						return false;
					}
				}else if(Editor.field=='ManfId'){
					var ManfId=row.ManfId;
					if ((IngrParamObj.ManfNotNull!="Y")&&(isEmpty(ManfId))){
						$UI.msg('alert',"入库厂商不能为空!");
						InGdRecGrid.checked=false;
						return false;
					}
				}
		    }
		},
		rowStyler: function (index, row) {
			if(row.Sp==0){
				$UI.msg('alert',"售价不能小于等于零!");
				return 'background-color:yellow;color:black;font-weight:bold;';
			}
		}
	})
	IngrClear();

}
$(init);
//获取入库主表信息
function GetParamsObj(){
	var ParamsObj=$UI.loopBlock('#MainConditions');
	return ParamsObj;
}
function Confirm(index){
	showMask();
	if (CheckDataBeforeSave(index)){
		SaveIngrInfo(index);
	}else{
		hideMask();
	}
}
function CheckDataBeforeSave(index) {
	var ParamsObj=GetParamsObj();
	var NowDate = DateFormatter(new Date());
	// 判断入库部门和供货商是否为空
	var phaLoc = ParamsObj.RecLoc;
	if (isEmpty(phaLoc)) {
		$UI.msg('alert','请选择入库科室!');
		$('#RecLoc').focus();
		return false;
	}
	var PurUserId = ParamsObj.PurchaseUser;
	if((isEmpty(PurUserId))&(IngrParamObj.PurchaserNotNull=='Y')){
		$UI.msg('alert','采购员不能为空!');
		$('#PurchaseUser').focus();
		return false;
	}
	var IngrTypeId = ParamsObj.IngrTypeId;
	IngrParamObj.ImpTypeNotNull="Y"
	if((isEmpty(IngrTypeId))&(IngrParamObj.ImpTypeNotNull=='Y')){
		$UI.msg('alert','入库类型不能为空!');
		$('#IngrTypeId')[0].focus();
		return false;
	}
	
	// 1.判断入库物资是否为空
	var RowsData=InGdRecGrid.getRows();
	var item = RowsData[index].IncId;
	if (isEmpty(item)) {
		$UI.msg('alert','请输入入库明细!');
		return false;
	}
	var sp=RowsData[index].Sp;
	var row=index+1;
		if (sp<=0){
			$UI.msg('alert','第'+row+'行'+Incidesc+'售价为零或者小于零!');
			return false;
		}
	var ExpDate=RowsData[index].ExpDate;
	if ((!isEmpty(ExpDate))&&(FormatDate(NowDate)>=FormatDate(ExpDate))){
		$UI.msg('alert','有效期不能小于当天!');
		return false;
	}
	var HVBarCode = RowsData[index].HVBarCode;
	var GetInrInfoByBarcode=tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'GetInrInfoByBarcode',HVBarCode);
	var InrInfoArr=GetInrInfoByBarcode.split("^");
	var CompleteFlag=InrInfoArr[1];
	if (CompleteFlag=="Y"){
		$UI.msg('alert','此条码对应入库单已完成不允许修改!');
		return false;
	}
	return true;
}
function SaveIngrInfo(index){
	var MainObj=GetParamsObj();
	var RowsDatas=InGdRecGrid.getRows();
	var RowsData=RowsDatas[index];
	var VendId=RowsData.vendor;
	var reqLocId=RowsData.reqLocId;
	var Ingrid="";MainData="";
	if (isEmpty(VendId)){
		$UI.msg('alert','没有维护供应商!');
		hideMask();
		return false;
	}
	var LocId=MainObj.RecLoc;
	var FindIndex = InGdRecMainGrid.find('ApcvmDr', VendId);
	var LocFindIndex =InGdRecMainGrid.find('ReqLocId', reqLocId);
	if ((FindIndex==LocFindIndex)&&(FindIndex>=0)){
		var MainRowsDatas=InGdRecMainGrid.getRows();
		var MainRowsData=MainRowsDatas[FindIndex];
		Ingrid=MainRowsData.IngrId;
		var AdjCheque = MainObj.AdjCheque;
		var GiftFlag = MainObj.GiftFlag;
		var IngrTypeId = MainObj.IngrTypeId;
		var PurchaseUser = MainObj.PurchaseUser;
		var SourceOfFund = MainObj.SourceOfFund;
		var InGrRemarks = MainObj.InGrRemarks;
		var MainData=JSON.stringify(addSessionParams({IngrId:Ingrid,RecLoc:LocId,ApcvmDr:VendId,GiftFlag:GiftFlag,AdjCheque:AdjCheque,IngrTypeId:IngrTypeId,PurchaseUser:PurchaseUser,SourceOfFund:SourceOfFund,InGrRemarks:InGrRemarks}));
		var SaveData = $.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'MainUpdateForJs',
			MainInfo: MainData
		},false);
	}else{
		var AdjCheque = MainObj.AdjCheque;
		var GiftFlag = MainObj.GiftFlag;
		var IngrTypeId = MainObj.IngrTypeId;
		var PurchaseUser = MainObj.PurchaseUser;
		var SourceOfFund = MainObj.SourceOfFund;
		var InGrRemarks = MainObj.InGrRemarks;
		var HVBarCode = RowsData.HVBarCode;
		var GetInrInfoByBarcode=tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'GetInrInfoByBarcode',HVBarCode);
		var InrInfoArr=GetInrInfoByBarcode.split("^");
		var tmpIngrid=InrInfoArr[0];
		if (tmpIngrid!=""){
			Ingrid=tmpIngrid;
		}else{
		var MainData=JSON.stringify(addSessionParams({RecLoc:LocId,ApcvmDr:VendId,GiftFlag:GiftFlag,AdjCheque:AdjCheque,IngrTypeId:IngrTypeId,PurchaseUser:PurchaseUser,SourceOfFund:SourceOfFund,InGrRemarks:InGrRemarks,ReqLocId:reqLocId}));
		var SaveData = $.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'MainInsertForJs',
			MainInfo: MainData
		},false);
		Ingrid=SaveData.rowid;
		}
		var SelectData = $.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'Select',
			Ingr: Ingrid
		},false);
		$('#InGdRecMainGrid').datagrid('appendRow',SelectData); 
	}
	var DetailArr=[];
	DetailArr.push(RowsData);
	var Detail=JSON.stringify(DetailArr);
	$.cm({
		ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
		MethodName: 'DetailSaveForJs',
		IngrId :Ingrid,
		MainInfo: MainData,
		ListData: Detail
	},function(jsonData){
		hideMask();
		if(jsonData.success==0){
			$UI.msg('success',jsonData.msg);
		}else{
			$UI.msg('error',jsonData.msg);		
		}
	});
}