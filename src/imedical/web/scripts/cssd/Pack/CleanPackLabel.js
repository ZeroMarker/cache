function getcleandtail(Id) {
	FindDetail(Id);
}
var init = function() {
	var ParamObj=GetAppPropValue('CSSDPACK');
	var PrintDetailNum = PrintLine();
	$("#cleandate").dateboxq("setValue", DateFormatter(new Date()));
	$("#Iscmt").val('1');
	var Params = JSON.stringify($UI.loopBlock('cleantable'));
	var GridListIndex = 0;
	//清洗架
	$("#cleanCode").keydown(function(e) {
		var curKey = e.which;
		if(curKey == 13) {
			if($("#cleanCode").val() != "") {
				$.m({
					ClassName: "web.CSSDHUI.Clean.CleanInfo",
					MethodName: "GetCleanCode",
					cleanCode: $("#cleanCode").val()
				}, function(txtData) {
					if(txtData != null && !isEmpty(txtData)) {
						arr = txtData.split('^');
						$("#cleanCodev").val(arr[0]);
						$("#cleanCode").val(arr[1]);
					} else {
						$UI.msg('alert', '错误的清洗架号!');
						$("#cleanCode").val("");
						$('#cleanCode').focus();
						return;
					}
				})
			}
		}
	});
	//审核人回车
	$("#txtChker").keydown(function(e) {
		var curKey = e.which;
		if(curKey == 13) {
			if($("#txtChker").val() != "") {
				$.m({
					ClassName: "web.CSSDHUI.Clean.CleanInfo",
					MethodName: "GetCleanUser",
					cleanCode: $("#txtChker").val()
				}, function(txtData) {
					if(txtData != null && !isEmpty(txtData)) {
						arr = txtData.split('^');
						$("#txtChkerv").val(arr[0]);
						$("#txtChker").val(arr[1]);
						$('#txtActor').focus();
					} else {
						$UI.msg('alert', '错误的审核人!');
						$("#txtChker").val("");
						$('#txtChker').focus();
						return;
					}
				})
			}
		}
	});
	//包装人回车
	$("#txtActor").keydown(function(e) {
		var curKey = e.which;
		if(curKey == 13) {
			if($("#txtActor").val() != "") {
				$.m({
					ClassName: "web.CSSDHUI.Clean.CleanInfo",
					MethodName: "GetCleanUser",
					cleanCode: $("#txtActor").val()
				}, function(txtData) {
					if(txtData != null && !isEmpty(txtData)) {
						arr = txtData.split('^');
						$("#txtActorv").val(arr[0]);
						$("#txtActor").val(arr[1]);
						$('#num').focus();
					} else {
						$UI.msg('alert', '错误的审核人!');
						$("#txtActor").val("");
						$('#txtActor').focus();
						return;
					}
				})
			}
		}
	});
	
	var ToLocBox = $HUI.combobox('#ToLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=',
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   
		}
	});
	
	//灭菌方式下拉框
	var SterTypeBox = $HUI.combobox('#SterType', {	
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterType&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   
		}
	});
	
	//锅号
	$("#PotNo").keypress(function(event) {
		if ( event.which == 13 ) {
			var v=$("#PotNo").val();
			var Ret = tkMakeServerCall('web.CSSDHUI.Common.Dicts', 'GetMachineNo',"sterilizer",v);
			if(Ret.split('^')[3]=="N"){
				$UI.msg('alert',Ret.split('^')[2]+'灭菌锅未启用!');
				$("#PotNo").val("");
				$("#PotNo").focus();
				return;
			}
			if(Ret.split('^')[0]=="Y"){
				$("#PotNoValue").val(Ret.split('^')[1]);
				$("#PotNo").val(Ret.split('^')[2]);
				$("#PotNoSterType").val(Ret.split('^')[4]);
				$("#HeatNo").focus();
				//$("#SterPro").focus();
			}else{
				$UI.msg('alert','未找到相关信息!');
				$("#PotNo").val("");
				$("#PotNo").focus();
			}
		}
	});
	
	//查询
	$UI.linkbutton('#query', {
		onClick: function() {
			if(isEmpty($UI.loopBlock('cleantable').cleanCode)){
				$("#cleanCodev").val("")
			}
			var Params = JSON.stringify($UI.loopBlock('cleantable'));
			GridListIndex = 0;
			MainDataIndex = 0;
			$UI.clear(OprListGrid);
			$UI.clear(OrdListGrid);
			map = {}
			OrdMap = {}
			GridList.load({
				ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
				QueryName: 'SelectAllCheck',
				Params: Params
			});
			
		}
	});
	//手术包标签生成
	$UI.linkbutton('#oprGen', {
		onClick: function() {
			var PackAndCheck=ParamObj.PackAndCheck;
			if(PackAndCheck=="Y"){
				if (!$("#txtChker").val()) {
					$UI.msg('alert', '请输入审核人！');
					$("#txtChker").focus();
					return;
				}
			}else {
				if (!$("#txtChker").val()) {
					$UI.msg('alert', '请输入审核人！');
					$("#txtChker").focus();
					return;
				}
				if (!$("#txtActor").val()) {
					$UI.msg('alert', '请输入包装人！');
					$("#txtActor").focus();
					return;
				}
				
			}
			
			var Main = JSON.stringify(addSessionParams($UI.loopBlock('Usertb')));
			var Rows = OprListGrid.getSelections();
			if(isEmpty(Rows)){
				$UI.msg('alert', '请选择需要生成的消毒包！');
			}
			var OprFlag = false;
			$.each(Rows,function(index,item){
				if(item.ChkerName==$("#txtChker").val()&&item.ActorName==$("#txtActor").val()){
					OprFlag = true;
					return ;
				}
			});
			if(OprFlag){
				$UI.msg('alert', '请勿重复生成条码！');
				return ;
			}
			var Obj = $UI.loopBlock('#Usertb');
			var ToLoc = Obj.ToLoc;
			var DetailParams = JSON.stringify(Rows);
			$.cm({
				ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
				MethodName: 'GenOprLabel',
				Main: Main,
				Detail: DetailParams,
				ToLoc:ToLoc
			}, function(jsonData) {
				if(jsonData.success == 0) {
					GridList.commonReload();
					OprListGrid.commonReload();
					$UI.msg('success',"标签生成成功！");
				}else{
					$UI.msg('error',jsonData.msg)
				}
			});
		}
	});
	//普通包标签生成
	$UI.linkbutton('#ordGen', {
		onClick: function() {
			if (!$("#txtChker").val()) {
				$UI.msg('alert', '请输入审核人！');
				$("#txtChker").focus();
				return;
			}
			if (!$("#txtActor").val()) {
				$UI.msg('alert', '请输入包装人！');
				$("#txtActor").focus();
				return;
			}
			if($("#num").val()<=0&&!isEmpty($("#num").val())){
				$UI.msg('alert', '请输入正确的个数！');
				$("#num").numberbox("setValue","");
				$("#num").focus();
				return ;
			}
			
			var Main = JSON.stringify(addSessionParams($UI.loopBlock('Usertb')));
			var Rows = OrdListGrid.getSelections();
			if(isEmpty(Rows)){
				$UI.msg('alert', '请选择需要生成的消毒包！');
				return ;
			}
			var DetailParams = JSON.stringify(Rows);
			var num = $("#num").val();
			if((num > 0) && (Rows.length != 1)) {
				$UI.msg('alert', '部分生成条码只能选择某一个消毒包!');
				return
			}
			var OrdFlag = false;
			$.each(Rows,function(index,item){
				if(item.unCreatedQty<=0){
					OrdFlag = true;
				}
			});
			if(OrdFlag){
				$UI.msg('alert', '无法重复生成标签!');
				return ;
			}
			if(parseInt(Rows[0].unCreatedQty)<parseInt(num)){
				$UI.msg('alert', '生成数量不能多于未生成数量！');
				$("#num").focus();
				return;	
			}
			$.cm({
				ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
				MethodName: 'GenOrdLabel',
				Main: Main,
				Detail: DetailParams,
				num: num
			}, function(jsonData) {
				if(jsonData.success == 0) {
					GridList.commonReload();
					OrdListGrid.commonReload();
				} else {
					$UI.msg('alert', jsonData.msg);
				}
			});
			$("#num").numberbox("setValue","");

		}
	});
	//普通包标签打印
	$UI.linkbutton('#ordPrint', {
		onClick: function () {
			var Rows = OrdListGrid.getSelections();
			if(isEmpty(Rows)){
					$UI.msg('alert', '请选择需要打印的消毒包！');
			}
			var DetailIds="";
			for(var i= 0, Len= Rows.length;i < Len;i++){
				var detailid = Rows[i]['detailID'];
				if(DetailIds == ""){
					DetailIds = detailid;
				}
				 else{
					DetailIds = DetailIds + ',' + detailid;
				}
			}
			$.cm({
				ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
				MethodName: 'GetPackageLabels',
				details: DetailIds
			}, function(jsonData) {
				if(!isEmpty(jsonData)){
					var Obj = $UI.loopBlock('#Usertb');
					var ToLoc = Obj.ToLoc;
					var PotNoValue = Obj.PotNoValue;
					var HeatNo = Obj.HeatNo;
					var PotNoSterType = Obj.PotNoSterType;
					var packNum = $("#packNum").val();	//每包打的个数
				$.each(jsonData, function(index, item){
					printout(item.label,ToLoc,PotNoValue,HeatNo,PotNoSterType,packNum,PrintDetailNum);
				}); 
				}
				OrdListGrid.commonReload();
				GridList.commonReload();
			});
			
		}
	});
	//普通包标签打印(不打明细)
	$UI.linkbutton('#ordPrintNot', {
	onClick: function () {
		var Rows = OrdListGrid.getSelections();
		if(isEmpty(Rows)){
				$UI.msg('alert', '请选择需要打印的消毒包');
		}
		var DetailIds="";
		for(var i= 0, Len= Rows.length;i < Len;i++){
			var detailid = Rows[i]['detailID'];
			if(DetailIds == ""){
				DetailIds = detailid;
			}
			 else{
				DetailIds = DetailIds + ',' + detailid;
			}
		}
		$.cm({
			ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
			MethodName: 'GetPackageLabels',
			details: DetailIds
		}, function(jsonData) {
			if(!isEmpty(jsonData)){
				var Obj = $UI.loopBlock('#Usertb');
				var ToLoc = Obj.ToLoc;
				var PotNoValue = Obj.PotNoValue;
				var HeatNo = Obj.HeatNo;
				var PotNoSterType = Obj.PotNoSterType;
				var packNum=""
			$.each(jsonData, function(index, item){
				printoutnotitm(item.label,ToLoc,PotNoValue,HeatNo,PotNoSterType,packNum);
			});
			OrdListGrid.commonReload();
			GridList.commonReload();
			}
		});
	}
	});
	//手术包标签打印
	$UI.linkbutton('#oprPrint', {
		onClick: function () {
			var Detail = OprListGrid.getSelections();
			var DetailParams = JSON.stringify(Detail);
			if(isEmpty(Detail)){
				$UI.msg('alert', '请选择需要打印的消毒包!');
				return;
			}
			if(!isEmpty(Detail)){
				var Obj = $UI.loopBlock('#Usertb');
				var ToLoc = Obj.ToLoc;
				var PotNoValue = Obj.PotNoValue;
				var HeatNo = Obj.HeatNo;
				var PotNoSterType = Obj.PotNoSterType;
				var packNum=""
				$.each(Detail, function(index, item){
					if(!isEmpty(item.Label)){
						if(item.IsFItem=="Y"){
							$UI.msg('alert', item.PackageName+'是外来器械包,不能进行手术器械包打印！');
						}else{
							if(item.IsLowerSter=="Y"){	//低温灭菌打印
								printlower(item.Label,ToLoc,PotNoValue,HeatNo,PotNoSterType,packNum,PrintDetailNum);
							}else{	//高温灭菌打印
								printout(item.Label,ToLoc,PotNoValue,HeatNo,PotNoSterType,packNum,PrintDetailNum);
							}
						}
					}else{
						$UI.msg('alert', item.PackageName+'未生成标签无法打印!');
					}
				});  
				OprListGrid.commonReload();
				GridList.commonReload();
			}
	}
	});	
	//外来器械打印
	$UI.linkbutton('#extPrint', {
	onClick: function () {
		var Detail = OprListGrid.getSelections();
		var DetailParams = JSON.stringify(Detail);
		if(isEmpty(Detail)){
			$UI.msg('alert', '请选择需要打印的消毒包!');
			return;
		}
		if(!isEmpty(Detail)){
			var Obj = $UI.loopBlock('#Usertb');
			var ToLoc = Obj.ToLoc;
			var PotNoValue = Obj.PotNoValue;
			var HeatNo = Obj.HeatNo;
			var PotNoSterType = Obj.PotNoSterType;
			$.each(Detail, function(index, item){
				if(!isEmpty(item.Label)){
					if(item.IsFItem=="N"){
						$UI.msg('alert', item.PackageName+'不是外来器械包,不能进行外来器械打印！');
					}else{
						printExt(item.Label,ToLoc,PotNoValue,HeatNo,PotNoSterType);
					}
				}else{
					$UI.msg('alert', '未生成标签无法打印!');
				}
			});  
		}
	}
	});	
	//手术包标签打印(无明细)
	$UI.linkbutton('#oprPrintNot', {
	onClick: function () {
		var Detail = OprListGrid.getSelections();
		var DetailParams = JSON.stringify(Detail);
		var PackAndCheck=ParamObj.PackAndCheck;
		var AckUser=$("#txtActorv").val();
		if(PackAndCheck=="Y"&&isEmpty(AckUser)){
			$UI.msg('alert', '请输入包装人!');
			return;
		}
		if(isEmpty(Detail)){
			$UI.msg('alert', '请选择需要打印的消毒包');
		}
		if(!isEmpty(Detail)){
			var Obj = $UI.loopBlock('#Usertb');
			var ToLoc = Obj.ToLoc;
			var PotNoValue = Obj.PotNoValue;
			var HeatNo = Obj.HeatNo;
			var PotNoSterType = Obj.PotNoSterType;
			var packNum=""
			$.each(Detail, function(index, item){
				if(!isEmpty(item.Label)){
					printoutnotitm(item.Label,ToLoc,PotNoValue,HeatNo,PotNoSterType,packNum,PackAndCheck,AckUser);
				}else{
					$UI.msg('alert', '未生成标签无法打印!');
				}
			}); 
			OprListGrid.commonReload();
			GridList.commonReload();
		}
	}
	});	
	//固定标签查询
	$UI.linkbutton('#fixLabelquery', {
		onClick: function () {
			var v=$("#FixLabel").val();
			var Ret=""
			var Ret = tkMakeServerCall('web.CSSDHUI.Pack.CleanPackLabel', 'GetFixLabel',v);
			if(isEmpty(Ret.split('^')[1])){
				$UI.msg('alert','未找到相关信息!');
				$("#FixLabel").val("");
				$("#FixLabel").focus();
				return ;
			}
			if(!isEmpty(Ret)){
				var rows = $("#tabDrugList").datagrid("getRows");
				$.each(rows,function(index,item){
					if(item.ID==Ret.split('^')[0]){
						$("#tabDrugList").datagrid("selectRow",index);
						if(MainDataIndex!=index){
							map = {};
							OrdMap={};
						}
						MainDataIndex = index;
						FindOpryF(Ret.split('^')[0]);
						FindOrdyF(Ret.split('^')[0]);
					}
				})
			}else{
				$UI.msg('alert','未找到相关信息!');
				$("#FixLabel").val("");
				$("#FixLabel").focus();
			}
		}
	});
  //固定标签回车查询
	$("#FixLabel").keydown(function(e) {
		var curKey = e.which;
		if(curKey == 13) {
			if($("#FixLabel").val() != "") {
				var v=$("#FixLabel").val();
				var Ret=""
				var Ret = tkMakeServerCall('web.CSSDHUI.Pack.CleanPackLabel', 'GetFixLabel',v);
				if(isEmpty(Ret.split('^')[1])){
					$UI.msg('alert','未找到相关信息!');
					$("#FixLabel").val("");
					$("#FixLabel").focus();
					return ;
			}
			if(!isEmpty(Ret)){
				var rows = $("#tabDrugList").datagrid("getRows");
				$.each(rows,function(index,item){
					if(item.ID==Ret.split('^')[0]){
						GridListIndex=index;
						$("#tabDrugList").datagrid("selectRow",index);
						if(MainDataIndex!=index){
							map = {};
							OrdMap={};
						}
						MainDataIndex = index;
						FindOpryF(Ret.split('^')[0]);
						FindOrdyF(Ret.split('^')[0]);
					}
				})
			}else{
				$UI.msg('alert','未找到相关信息!');
				$("#FixLabel").val("");
				$("#FixLabel").focus();
			}
			}
		}
	});	
	var Cm = [[
		{
			title: 'ID',
			field: 'ID',
			hidden: true
		},{
			title: '标签生成',
			field: 'IsFinished',
			width: 80,
			styler: flagColor,
			formatter: function(value) {
				var status = "";
				if(value == "1") {
					status = "已完成";
				} else {
					status = "未完成";
				}
				return status;
			}
		},{
			title: '标签打印',
			field: 'IsPrint',
			width: 80,
			styler: flagColor,
			hidden: true,
			formatter: function(value) {
				var status = "";
				if(value == "1") {
					status = "已完成";
				} else {
					status = "未完成";
				}
				return status;
			}
		},{
			title: '机器号',
			field: 'MachineNo',
			align: 'right',
			width: 60
		}, {
			title: '日期',
			field: 'CleanDate',
			width: 100
		}, {
			title: '时间',
			field: 'CleanTime',
			width: 100
		},
		{
			title: '清洗批号',
			field: 'CleanNo1',
			width: 150

		}, {
			title: '清洗人',
			field: 'CleanerName',
			width: 100

		}, {
			title: '验收人',
			field: 'ChkerName',
			width: 100

		}
	]];
	function flagColor(val, row, index) {
		if(val == '1') {
			return 'background:#15b398;color:white';
		}else{
			return 'background:#ff584c;color:white';
		}
	}
	
	function flagColorOpr(val, row, index) {
		if(val == 'Y') {
			return 'background:#15b398;color:white';
		}else{
			return 'background:#ff584c;color:white';
		}
	}
	
	var GridList = $UI.datagrid('#tabDrugList', {
		url: $URL,
		queryParams: {
			ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
			QueryName: 'SelectAllCheck',
			Params: Params
		},
		columns: Cm,
		toolbar: "#UomTB",
		remoteSort: false,
		lazy: false,
		onLoadSuccess: function(data) {
			$(".icon_Modify").linkbutton({
				text: '',
				plain: true,
				iconCls: 'icon-cancel'
			});
			if(data.rows.length > 0) {
				//$('#tabDrugList').datagrid("selectRow", 0);
				$('#tabDrugList').datagrid("selectRow",GridListIndex);
			}

		},
		onClickCell: function(index, filed, value) {
			GridListIndex = index;
			MainDataIndex = index;
			var Row = GridList.getRows()[index]
			var Id = Row.ID;
			if(!isEmpty(Id)) {
				FindOpryF(Id);
				FindOrdyF(Id);
				var value=$("#FixLabel").val();
				if(isEmpty(value)){
					map = {};
				}
				OrdMap={};
			}
		},
		onSelect: function(index, row){
			var Id = row['ID'];
			if(!isEmpty(Id)) {
				FindOpryF(Id);
				FindOrdyF(Id);
			}
			
		}
	})
	//双击左边显示右边手术器械包
	function FindOpryF(Id) {
		$UI.clear(OprListGrid);
		var SterType=$("#SterType").combobox("getValue");
		OprListGrid.load({
			ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
			QueryName: 'QueryOprPkgs',
			CleanID: Id,
			rows:999,
			SterTypeQuery:SterType
		});
		
		
	}
	//双击左边显示右边专科器械包和普通包
	function FindOrdyF(Id) {
		var SterType=$("#SterType").combobox("getValue");
		$UI.clear(OrdListGrid);
		OrdListGrid.load({
			ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
			QueryName: 'SelectOrdPkg',
			CleanID: Id,
			rows:999,
			SterTypeQuery:SterType
		});
		
	}

	//手术器械grid
	var OprCm = [[
		{
			title: '',
			field: 'ck',
			checkbox: true,
			width: 50
		}, {
			title: 'ID',
			field: 'DetailID',
			saveCol: true,
			width: 100,
			hidden: true
		}, {
			title: '是否打印',
			field: 'IsPrint',
			width: 80,
			styler: flagColorOpr,
			formatter: function(value) {
				var status = "";
				if(value == "Y") {
					status = "已打印";
				} else {
					status = "未打印";
				}
				return status;
			}
		},{
			title: '包标牌编码',
			field: 'FixedLabel',
			width: 100
		}, {
			title: '消毒包标牌名称',
			field: 'PackageName',
			width: 150
		}, {
			title: '标签',
			field: 'Label',
			width: 150
		},
		{
			title: '包Dr',
			field: 'PackageDr',
			width: 100,
			hidden: true
		},
		{
			title: '审核人',
			field: 'ChkerName',
			width: 100
		},{
			title: '包装人',
			field: 'ActorName',
			width: 100
		},
		{
			title: '灭菌方式Dr',
			field: 'SterType',
			width: 100,
			hidden: true
		},
		{
			title: '灭菌方式',
			field: 'SterTypeName',
			width: 100
		},
		{
			title: '是否为外来器械',
			field: 'IsFItem',
			width: 100,
			hidden:true
		},
		{
			title: '是否为低温灭菌方式',
			field: 'IsLowerSter',
			width: 100,
			hidden:true
		}
	]];
	//用来实现勾选后的数据在标签生成后仍处于勾选状态,方便打印
	var map = {};
	var MainDataIndex = "";  //用于记录当前手术器械包查询到的数据为主菜单数据第几列，当查询消毒包时跨不同主菜单,则重置map
	//右边手术器械包明细
	var OprListGrid = $UI.datagrid('#OprList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
			MethodName: 'QueryOprPkgs'
		},
		columns: OprCm,
		pagination: false,
		singleSelect: false,
		toolbar: "#UocTB",
		idField:'DetailID',
		onLoadSuccess: function(data) {
			var v=$("#FixLabel").val();
			//用来区分为正常加载还是查询后的加载
			var flag = false;   
			if(!isEmpty(v)){
				var rows = $("#OprList").datagrid("getRows");
				$.each(rows,function(index,item){
					if(item.FixedLabel==v){
						$("#OprList").datagrid("checkRow",index);
						flag = true;
						return false;
					}	
				})
			}
			if(flag){
				$("#FixLabel").val("");
			}
			for(var i=0;i<data.rows.length;i++){
				if(map[i]){
					$("#OprList").datagrid("checkRow",i);
					//map[i]=false;
				}
			}	
		},
		onCheck:function(rowIndex, rowData){
			map[rowIndex] = true;
		},
		onUncheck:function(rowIndex, rowData){
			map[rowIndex] = false;
		},
		onCheckAll:function(rows){
			for(var i in rows){
				map[i] = true;
			}
		}
	});
	var OrdCm = [[
		{
			title: '',
			field: 'ck',
			checkbox: true,
			width: 50
		}, {
			title: 'ID',
			field: 'detailID',
			saveCol: true,
			width: 100,
			hidden: true
		}, {
			title: '是否打印',
			field: 'IsPrint',
			width: 80,
			styler: flagColorOpr,
			formatter: function(value) {
				var status = "";
				if(value == "Y") {
					status = "已打印";
				} else {
					status = "未打印";
				}
				return status;
			}
		},{
			title: '科室',
			field: 'LocName',
			width: 100
		}, {
			title: '消毒包',
			field: 'pkgdr',
			width: 150,
			hidden: true
		}, {
			title: '消毒包名称',
			field: 'packagedesc',
			width: 150
		},
		{
			title: '清洗数量',
			field: 'Qty',
			width: 100,
			align:'right',
			hidden: false
		},
		{
			title: '生成数量',
			field: 'createdQty',
			align:'right',
			width: 100
		},
		{
			title: '未生成数量',
			field: 'unCreatedQty',
			align:'right',
			width: 100
		},
		{
			field: 'operate',
			title: '操作',
			align: 'center',
			width: 50,
			formatter: function(value, row, index) {
				var str = '<a href="#" name="opera" class="easyui-linkbutton"  onclick="getcleandtail(' + row.detailID + ')"></a>';
				return str;
			}
		}
	]];
	//右边普通包明细
	var OrdMap = {}; // 用于选中普通包生成标签后使对应的包仍然处于被勾选状态方便打印
	var OrdListGrid = $UI.datagrid('#OrdList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
			MethodName: 'SelectOrdPkg'
		},
		columns: OrdCm,
		pagination: false,
		toolbar: "#UoTb",
		singleSelect: false,
		onLoadSuccess: function(data) {
			$("a[name='opera']").linkbutton({
				plain: true,
				iconCls: 'icon-paper'
			});
			var rows = $("#OrdList").datagrid("getRows");
			for(var i=0;i<data.rows.length;i++){
				if(OrdMap[i]){
					$("#OrdList").datagrid("checkRow",i);
				}
			}		
		},
		onCheck:function(rowIndex, rowData){
			OrdMap[rowIndex] = true;
		},
		onUncheck:function(rowIndex, rowData){
			OrdMap[rowIndex] = false;
		},
		onCheckAll:function(rows){
			for(var i in rows){
				OrdMap[i] = true;
			}
		}

	});
	var Default = function() {
		///设置初始值 考虑使用配置
		$("#cleandate").datebox("setValue", DateFormatter(new Date()));

	}
}

$(init);