var init = function() {
	//申请科室
	var SupLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var SupLocBox = $HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	///return:起始日期
	function DefaultStDate(){
		var Today = new Date();
		return DateFormatter(Today);	
		
	}
	var Dafult={
		FStartDate:DefaultStDate()
		//ExtStartDate:DefaultStDate()
	}
	var DafultExt={
		RecDateValue:DefaultStDate()
	}
	$UI.fillBlock('#MainCondition',Dafult)
	$UI.fillBlock('#DetailCondition',DafultExt)
	//查询
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			query();
			//Clear();
		}
	});
	function query(){ 
		var Params = JSON.stringify($UI.loopBlock('#CondTB'));
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.PackageCallBack.ForeignPkgBindInfo',
			QueryName: 'GetOpPlan',
			Params: Params
		});
	}
	//明细查询
	$UI.linkbutton('#QueryBTExt',{ 
		onClick:function(){
			queryext();
		}
	});
	function queryext(){ 
		var Params = JSON.stringify($UI.loopBlock('#IpuntTB'));
		DetailListGrid.load({
			ClassName: 'web.CSSDHUI.PackageCallBack.ForeignDeviceRegister',
			QueryName: 'GetDeviceRegister',
			Params: Params
		});
	}
	//导入手术排班数据
	$UI.linkbutton('#ImportOP',{ 
		onClick:function(){
			Import();
		}
	});
	function Import(){ 
		var Params = $UI.loopBlock('#CondTB');
		$.cm({
			ClassName:'web.CSSDHUI.PackageCallBack.ForeignPkgBindInfo',
			MethodName:'Import',
			stdate:Params.FStartDate
		},function(jsonData){
			if(jsonData.success==0){
				 query();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		}); 
	}
	//扫码动作自动提交
	$("#BarCode").keypress(function(event) {
		if ( event.which == 13 ) {
			var v=$("#BarCode").val();
			var row = $('#MainList').datagrid('getSelected');
			if(isEmpty(row)){
				$UI.msg('alert','请选择需要绑定的数据!');
				return;
			}
			if(isEmpty(row.RowId)){
				$UI.msg('alert','参数错误!');
				return;
			}
			if(isEmpty(v)){
				$UI.msg('alert','条码录入为空!');
				return;
			}
			$.cm({
				ClassName:'web.CSSDHUI.PackageCallBack.ForeignPkgBindInfo',
				MethodName:'jsSaveDetail',
				mainId:row.RowId,
				barCode:v,
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					MainListGrid.reload();
					DetailListGrid.reload();
				}else{
					$UI.msg('error',jsonData.msg);
					$("#BarCode").val("").focus();
				}
				$("#BarCode").val("").focus();
			});
		}
	});
	function flagColor(val, row, index) {
		if(val == '1') {
			return 'background:#15b398;color:white';
		}else{
			return 'background:#ff584c;color:white';
		}
	}
	//上面输入框的回车事件处理 end
	var MainCm = [[{
					title : '',
					field : 'ck',
					checkbox : true,
					width : 50
				},{
					title: '是否绑定',
					align:'left',
					field: 'isbind',
					width:100,
					fitColumns:true,
					styler: flagColor,
					formatter: function(value) {
					var status = "";
					if(value == "1") {
						status = "已绑定";
					} else {
						status = "未绑定";
					}
					return status;
					}
				},
				{
					title: 'RowId',
					field: 'RowId',
					width:50,
					hidden: true
				},{
					title: '手术日期',
					field: 'RecDate',
					width:150
				},{
					title: '手术室',
					align:'left',
					field: 'OPLocName',
					width:150,
					fitColumns:true
				}, {
					title: '手术名称',
					align:'left',
					field: 'OPERDesc',
					width:150,
					fitColumns:true
				},{
					title:'病人登记号',
					align:'left',
					field:'RegNo',
					width:150,
					fitColumns:true
				},
				{
					title:'病人姓名',
					align:'left',
					field:'PatientName',
					width:150,
					fitColumns:true
				},{
					title:'病人科室',
					align:'left',
					field:'PatientLocDesc',
					width:150,
					fitColumns:true
				},
				
			]];

	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageCallBack.ForeignPkgBindInfo',
			QueryName: 'GetOpPlan',
			Params:JSON.stringify($UI.loopBlock('#CondTB'))
		},
		columns: MainCm,
		toolbar: '#CondTB',
		lazy:false,
		selectOnCheck: false,
		//singleSelect: false,
		onLoadSuccess:function(data){  
			if(data.rows.length>0){
				$('#MainList').datagrid("selectRow", 0)
				var Row=MainListGrid.getRows()[0]
				var Id = Row.RowId;
				$("#MainDr").val(Id);
				BindAllPackage();
		 	}
		},
		onClickCell: function(index, filed ,value){
			var Row=MainListGrid.getRows()[index]
			var Id = Row.RowId;
			$("#MainDr").val(Id);
			if(!isEmpty(Id)){
				BindAllPackage();
			}
			$("#BarCode").val("").focus();
		}
	})
	///右边登记外来器械表
	var DetailCm = [[{
						title: 'RowId',
						field: 'RowId',
						width:50,
						hidden: true
					},{
						title: '消毒包名称',
						field: 'InstruName',
						width:150
					},{
						title: '包标牌编码',
						field: 'InstruCode',
						align: 'left',
						width:100,
					}, {
						title:'病人姓名',
						align:'left',
						field:'SickerName',
						width:150,
						fitColumns:true
					},{
						title:'病人科室',
						align:'left',
						field:'ExtLocDesc',
						width:150,
						fitColumns:true
					},
					{
						title: '手术医生',
						field: 'UseDoctor',
						align: 'left',
						width:100,
						sortable: true,
					}
				]];

	var DetailListGrid = $UI.datagrid('#ItemList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageCallBack.ForeignDeviceRegister',
			QueryName: 'GetDeviceRegister',
			Params:JSON.stringify($UI.loopBlock('#IpuntTB'))
		},
		columns: DetailCm,
		toolbar: '#IpuntTB',
		//lazy:false,
		pagination:false
	})
	
	function BindAllPackage() {
		DetailListGrid.load({
			ClassName: 'web.CSSDHUI.PackageCallBack.ForeignDeviceRegister',
			QueryName: 'GetDeviceRegister',
			Params:JSON.stringify($UI.loopBlock('#IpuntTB')),
			rows:999
		});
	}
}
$(init);