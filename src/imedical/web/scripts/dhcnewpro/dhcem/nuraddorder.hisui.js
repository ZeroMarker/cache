//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2018-06-28
// 描述:	   新版护士补录医嘱
//===========================================================================================

var EpisodeID = "";      /// 病人就诊ID
var TabType="";          /// 护士执行页签类型
var NurMoeori = "";      /// 护士选择主医嘱ID
var TakOrdMsg = "";      /// 提示消息
var LgLocID = session['LOGON.CTLOCID'];
var LgGroupID = session['LOGON.GROUPID'];
var LgUserID = session['LOGON.USERID'];
var LgHospID = session['LOGON.HOSPID'];
var LgCtLocID = session['LOGON.CTLOCID'];
var LgLocDesc = session['LOGON.CTLOCDESC'];
var ArcColumns = "";    /// 医嘱窗口grid
var PageFlag = 0;

/// 页面初始化函数
function initPageDefault(){
		
	InitPatEpisodeID();   ///  初始化加载病人就诊ID
	validateIsLock();     ///判断加锁
	GetPatBaseInfo();     ///  加载病人信息
	InitPatOrdList();     ///  初始化医嘱列表
	InitWirOrdList();     ///  初始化医嘱录入列表
	InitColumns();        ///  初始化datagrid列
	InitPatNotTakOrdMsg();  /// 验证病人是否允许开医嘱
	
	InitBlButton();       /// 页面 Button 绑定事件
	InitCombobox();       /// 页面Combobox初始定义
}

///加锁
function validateIsLock(){
	runClassMethod("web.DHCBillLockAdm","LockOPAdm",{"admStr":EpisodeID,"lockType":""},  //hxy 2017-03-07 日期格式走配置
	function(retStr){
		if(retStr=="") return;
		$.messager.alert("提示",retStr,"info",function(){
			window.close();
			return;	
		});
		return;
	},"text");
}


/// 初始化加载病人就诊ID
function InitPatEpisodeID(){

	EpisodeID = getParam("EpisodeID");
	if (PatPanelFlag == 0){
		$('#MainPanel').layout('hidden','west');  /// 本次就诊医嘱列表
	}
}

/// 页面 Button 绑定事件
function InitBlButton(){
	
	/// 点击复选框事件
	$("#itemList").on("click",".checkbox",selectExaItem);
}

/// 页面Combobox初始定义
function InitCombobox(){

	/// 检查分类
	var option = {
        onSelect:function(option){
			
			$HUI.checkbox("#TempCovCK").setValue(false);
			LoadTempItemCovDet(option.value);  /// 加载医嘱套内容
	    }
	};
	var url = $URL+"?ClassName=web.DHCEMNurAddOrder&MethodName=JsonQryOrderTempCov&LgUserID="+LgUserID+"&LgLocID="+LgLocID+"&LgHospID="+LgHospID;
	new ListCombobox("TempCov",url,'',option).init();
	
	/// 加载默认的医嘱套对象
	var initCovObj = LoadTempCovInitObj();
	///  医嘱套名称查询
	if (typeof initCovObj != "undefined"){
		$HUI.combobox("#TempCov").setValue(initCovObj.value);
		$HUI.combobox("#TempCov").setText(initCovObj.text);
		LoadTempItemCovDet(initCovObj.value);  /// 加载医嘱套内容
	}
}

/// 病人就诊信息
function GetPatBaseInfo(){
	
	runClassMethod("web.DHCAPPExaReportQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID, "PPFlag":""},function(jsonString){
		var jsonObject = jsonString;
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
			if (jsonObject.PatSex == "男"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/boy.png");
			}else{
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/girl.png");
			}
			if (jsonObject.PatBed == ""){
				$("#PatBed").parent().parent().next().hide();
			}
		})
	},'json',false)
}

/// 初始化datagrid列
function InitColumns(){
	
	ArcColumns = [[
		{field:'arcitemId',hidden:true},
		{field:'arcitmdesc',title:'医嘱名称',width:320},
		{field:'arcitmcode',title:'医嘱代码',width:100},
		{field:'arcitmprice',title:'医嘱价格',width:100},
		{field:'recLocID',title:'科室id',hidden:true},
		{field:'recLocDesc',title:'接收科室',width:160},
	]];
}

/// 初始化医嘱列表
function InitPatOrdList(){
	
	///  定义columns
	var columns=[[
		{field:'arcitmdesc',title:'医嘱名称',width:240},
		{field:'SeqNo',title:'序号',width:40,align:'center'},
		{field:'OrderDate',title:'医嘱日期',width:100,align:'center'},
		{field:'OrderTime',title:'医嘱时间',width:100,align:'center'},
		{field:'OrderDocDesc',title:'医生',width:100,align:'center'},
		{field:'OrderStartDate',title:'开始日期',width:100,align:'center'},
		{field:'OrderStartTime',title:'开始时间',width:100,align:'center'},
		{field:'ordPrior',title:'医嘱类型',width:80,align:'center'},
		{field:'OrderFreq',title:'频次',width:60,align:'center'},
		{field:'OrderInstr',title:'用法',width:100,align:'center'},
		{field:'OrderDurt',title:'疗程',width:60,align:'center'},
		{field:'OrderDoseQty',title:'剂量',width:80,align:'center'},
		{field:'OrderDepProcNote',title:'备注',width:100},
		{field:'recLoc',title:'接收科室',width:120},
		{field:'oeori',title:'oeori',width:100,align:'center'},
		{field:'moeori',title:'moeori',width:100,align:'center'}
	]];
	
	///  定义datagrid
	var option = {
		singleSelect : true,
		queryParams: {
			EpisodeID:EpisodeID,
    		StartDate:'',
    		EndDate:'',
    		PriorCode:'',
    		TabType:TabType,
    		Moeori:NurMoeori,
    		NurOrd:'',
    		LgLocID:LgLocID,
    		SelDate:0
		},
		onClickRow:function(rowIndex, rowData){

	    }
	};

	var uniturl = $URL +"?ClassName=web.DHCEMNurAddOrder&MethodName=QueryPatOrderItems";
	new ListComponent('dgPatOrdList', columns, uniturl, option).Init(); 
}

/// 验证病人是否允许开医嘱
function InitPatNotTakOrdMsg(){
	
	TakOrdMsg = GetPatNotTakOrdMsg();
	if (TakOrdMsg != ""){
		$.messager.alert("提示:",TakOrdMsg);
		return;	
	}
}

/// 验证病人是否允许开医嘱
function GetPatNotTakOrdMsg(){

	var NotTakOrdMsg = "";
	/// 验证病人是否允许开医嘱
	runClassMethod("web.DHCAPPExaReport","GetPatNotTakOrdMsg",{"LgGroupID":LgGroupID,"LgUserID":LgUserID,"LgLocID":LgLocID,"EpisodeID":EpisodeID},function(jsonString){

		if (jsonString != ""){
			NotTakOrdMsg = jsonString;
		}
	},'',false)

	return NotTakOrdMsg;
}

/// 验证病人是否允许开医嘱 住院急诊留观押金控制
function GetPatArrManage(){

	var PatArrManMsg = "";
	var amount = $("#mypatpay").text(); /// 金额
	/// 验证病人是否允许开医嘱
	runClassMethod("web.DHCAPPExaReport","GetArrearsManage",{"EpisodeID":EpisodeID,"LgGroupID":LgGroupID,"LgLocID":LgLocID,"amount":amount},function(jsonString){

		if (jsonString != ""){
			PatArrManMsg = jsonString;
		}
	},'',false)

	return PatArrManMsg;
}

/// 页面DataGrid
function InitWirOrdList(){

	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}

	/// 包装单位
	var PUomEditor = {
		type:'combobox',
		options:{
			panelHeight:'auto',
			valueField:'value',
			textField:'text',
			editable:false,
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				///设置类型值
				var ed=$("#dgWriOrdList").datagrid('getEditor',{index:modRowIndex,field:'PUomID'});
				$(ed.target).val(option.value);
				var ed=$("#dgWriOrdList").datagrid('getEditor',{index:modRowIndex,field:'PUomDesc'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed = $("#dgWriOrdList").datagrid('getEditor', { index: modRowIndex, field: 'ItmID'});
				var arcitemId = $(ed.target).val();
				if(arcitemId != ""){
					var ed = $("#dgWriOrdList").datagrid('getEditor', { index: modRowIndex, field: 'PUomDesc'});
					$(ed.target).combobox('reload','dhcapp.broker.csp?ClassName=web.DHCEMNurAddOrder&MethodName=GetBillUOMList&ArcimRowid='+arcitemId)
				}
			}
		}
	}
	
	/// 接收科室
	var LocEditor = {
		type:'combobox',
		options:{
			panelHeight:'auto',
			valueField:'value',
			textField:'text',
			editable:false,
			enterNullValueClear:false,
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				///设置类型值
				var ed=$("#dgWriOrdList").datagrid('getEditor',{index:modRowIndex,field:'recLocID'});
				$(ed.target).val(option.value);
				var ed=$("#dgWriOrdList").datagrid('getEditor',{index:modRowIndex,field:'recLoc'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed = $("#dgWriOrdList").datagrid('getEditor', { index: modRowIndex, field: 'ItmID'});
				var arcitemId = $(ed.target).val();
				if(arcitemId != ""){
					var ed = $("#dgWriOrdList").datagrid('getEditor', { index: modRowIndex, field: 'recLoc'});
					$(ed.target).combobox('reload','dhcapp.broker.csp?ClassName=web.DHCEMNurAddOrder&MethodName=jsonExaCatRecLocNew&EpisodeID='+EpisodeID+'&ItmmastID='+arcitemId);
				}
			},
			onLoadSuccess:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed = $("#dgWriOrdList").datagrid('getEditor', { index: modRowIndex, field: 'recLoc'});
				var recLodId=$(ed.target).combobox('getValue');
				var LogonDepStr = GetLogonLocByFlag();
			    if((LogonDepStr.split("!")[0]!="")&(LogonDepStr.split("!")[1]!="")){
				    if(recLodId!=LogonDepStr.split("!")[0]) return;
				    $(ed.target).combobox('setValue',LogonDepStr.split("!")[0]); 
				    $(ed.target).combobox('setText',LogonDepStr.split("!")[1]); 
				}	
			}
		}
	}
	
	/// 费别
	var AdmReaEditor = {
		type:'combobox',
		options:{
			valueField:'value',
			textField:'text',
			editable:false,
			panelHeight:'auto',
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				///设置类型值
				var ed=$("#dgWriOrdList").datagrid('getEditor',{index:modRowIndex,field:'BillTypeID'});
				$(ed.target).val(option.value);
				var ed=$("#dgWriOrdList").datagrid('getEditor',{index:modRowIndex,field:'BillType'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed = $("#dgWriOrdList").datagrid('getEditor', { index: modRowIndex, field: 'BillType'});
				$(ed.target).combobox('reload','dhcapp.broker.csp?ClassName=web.DHCEMNurAddOrder&MethodName=jsonGetPatBillType&PatType=E&EpisodeID='+EpisodeID);
			}
		}
	}
						
	///  定义columns
	var columns=[[
		{field:'Select',title:'选择',width:40,align:'center',formatter:SetCellCheckBox},
		{field:'ItmSeqNo',title:'关联',width:35,align:'center',hidden:true},
	    {field:'ItmPriorID',title:'优先级ID',width:80,editor:textEditor,hidden:true},
		{field:'ItmOeori',title:'医嘱ID',width:80,hidden:true},
		{field:'ItmID',title:'医嘱项ID',width:80,editor:textEditor,hidden:true},
		{field:'ItmDesc',title:'医嘱名称',width:320,editor:textEditor,styler: function (value, rowData, index) {
			var ClassName = "";
			if (rowData.ItmOeori != ""){
               ClassName = 'background-color:#FFC0CB;';
			}
			return ClassName;
         }},
		{field:'PackQty',title:'数量',width:60,editor:textEditor},
		{field:'PUomID',title:'单位ID',width:80,editor:textEditor,hidden:true},
		{field:'PUomDesc',title:'单位',width:80,editor:PUomEditor},
		{field:'Sprice',title:'单价',width:80,editor:textEditor},
		{field:'recLocID',title:'接收科室id',width:80,editor:textEditor,hidden:true},
		{field:'recLoc',title:'接收科室',width:160,editor:LocEditor},
		{field:'BillTypeID',title:'费别ID',width:80,editor:textEditor,hidden:true},
		{field:'BillType',title:'费别',width:100,editor:AdmReaEditor},
		{field:'ItmTotal',title:'金额',width:100,editor:textEditor},
		{field:'OrderType',title:'医嘱类型',width:40,editor:textEditor,hidden:true},
		{field:'moeori',title:'moeori',width:80,hidden:true}
	]];
	
	///  定义datagrid
	var option = {
		//title : '医嘱列表' + '<span id="allPay" style="float:right">合计金额：0.00</span>',
		//
		title : '医嘱列表' +'<input type="checkbox" id="FindByLogDep" style="position: relative;top: 3px;margin-top:-4px;margin-left:50px;">按登录取接收科室</input>'+'<span id="allPay" style="float:right">合计金额：0.00</span>',
		border : false,
		rownumbers : true,
		singleSelect : true,
		pagination: false,
		headerCls:'panel-header-gray',
		checkOnSelect:true,
		selectOnCheck:true,
		onLoadSuccess:function(data){
			CalCurPagePatPayed(); /// 计算总费用
		}
	};

	var params = "rows=50&page=1&EpisodeID="+EpisodeID+"&StartDate=&EndDate=&LgLocID="+session['LOGON.CTLOCID'];
	var uniturl = $URL + "?ClassName=web.DHCEMNurAddOrder&MethodName=QueryPatOrderItmsByLoc&"+params;
	new ListComponent('dgWriOrdList', columns, uniturl, option).Init();

	/// 登陆科室取接收科室配置 18-6-13 lp
	if (RecLocByLogonLocFlag=="1"){
	    $("#FindByLogDep").prop("checked",true);
	}
}

/// 复选框
function SetCellCheckBox(value, rowData, rowIndex){

	var html = '<input name="ItmCheckBox" type="checkbox" value='+rowIndex+'></input>';
    return html;
}

/// 检查可用库存是否足够
function GetAvailQtyByArc(arcitmid,recLoc,Qty,uomID){
	
	var retflag = 0;
	runClassMethod("web.DHCEMNurAddOrder","GetAvaQtyByArc",{"arcitmid":arcitmid, "recLoc":recLoc, "bQty":Qty, "uomID":uomID},function(jsonString){
		if(jsonString != ""){
			retflag = jsonString;
		}
	},'',false);
	return retflag;
}

/// 库存锁定检查
function GetStkLockFlag(arcitmid,recLocID){

	var retflag = "N";
	runClassMethod("web.DHCEMNurAddOrder","GetStkLockFlag",{"arcitmid":arcitmid, "recLoc":recLocID},function(jsonString){
		if(jsonString != ""){
			retflag = jsonString;
		}
	},'',false);
	return retflag;
}

// 插入新行
function insertRow(){

	if (TakOrdMsg != ""){
		$.messager.alert("提示:",TakOrdMsg);
		return;	
	}
	
	/// 当前最后一行是否已有数据
	var rowsData = $("#dgWriOrdList").datagrid('getRows');
	var LastEditRow = rowsData.length - 1;
	if(LastEditRow >= 0){
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:LastEditRow,field:'ItmDesc'});
		if (ed != null){
			if ($(ed.target).val() == "") return;
		}
	}

	var ItmXuNo = 1;  /// 序号
	var rowsData = $("#dgWriOrdList").datagrid('getRows');
	if (rowsData != null){
		ItmXuNo = rowsData.length + 1;
	}
	
	/// 获取关联医嘱信息
	var ItmSeqNo = ""; var moeori = "";
	var rowsData = $("#dgPatOrdList").datagrid('getSelected');
	if (rowsData != null){
		ItmSeqNo = rowsData.SeqNo;
		moeori = rowsData.moeori;
	}

	$("#dgWriOrdList").datagrid('appendRow',{ //在指定行添加数据，appendRow是在最后一行添加数据
		ItmXuNo:ItmXuNo, ItmSeqNo:'', ItmPriorID:'', OrderType:'', ItmID:'',
		ItmDesc:'', Sprice:'', PackQty:'', PUomID:'', moeori:'',  ///moeori, 注释 取消关联 bianshuai 2018-03-19
		PUomDesc:'', recLocID:'', recLoc:'', BillTypeID:'', BillType:'', ItmOeori:'', ItmTotal:''}
	);

	var rowsData = $("#dgWriOrdList").datagrid('getRows');
	if (rowsData != null){
		$("#dgWriOrdList").datagrid('beginEdit', rowsData.length - 1);//开启编辑并传入要编辑的行
		editRow = rowsData.length - 1;
	
		/// 编辑行绑定事件
		dataGridBindEnterEvent(editRow);
	}
}

/// 给项目datagrid绑定点击事件
function dataGridBindEnterEvent(index){

	var editors = $('#dgWriOrdList').datagrid('getEditors', index);
	for(var i=0; i< editors.length; i++){
		var workRateEditor = editors[i];
		if (!workRateEditor.target.next('span').has('input').length){
			workRateEditor.target.bind('click', function(e){
				$('#dgWriOrdList').datagrid('selectRow',index);
			});
		}else{
			workRateEditor.target.next('span').find('input').bind('click', function(e){
				$('#dgWriOrdList').datagrid('selectRow',index);
			});
		}
	}

	var editors = $('#dgWriOrdList').datagrid('getEditors', index);
	/// 检查项目名称
	var workRateEditor = editors[2];
	workRateEditor.target.focus();  ///设置焦点
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var tr = $(this).closest("tr.datagrid-row");
			editRow = tr.attr("datagrid-row-index");
			var ed=$("#dgWriOrdList").datagrid('getEditor',{index:editRow, field:'ItmDesc'});		
			var EntryAlias = $(ed.target).val();
			if (EntryAlias == ""){return;}
			var unitUrl = $URL + '?ClassName=web.DHCEMNurAddOrder&MethodName=JsonQryArcNurAddOrder&EpisodeID='+EpisodeID+'&LgGroupID='+LgGroupID+'&LgUserID='+LgUserID+'&LgLocID='+LgLocID+'&EntryAlias='+EntryAlias;
			/// 调用医嘱项列表窗口
			new ListComponentWin($(ed.target), EntryAlias, "800px", "" , unitUrl, ArcColumns, setCurrArcEditRowCellVal).init();
		}
	});
	
	/// 数量
	var workRateEditor = editors[3];
	workRateEditor.target.bind('keyup', function(e){  /// keydown - > keyup
		
		var index = $(this).parents('.datagrid-row').attr('datagrid-row-index');

		/// 取录入内容	
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:index, field:'PackQty'}); 	
		var pQty = $(ed.target).val();
		
		/// 获取所有行内容
		var rowsData = $('#dgWriOrdList').datagrid('getRows');
		var rowData = rowsData[index];
		
		/// 医嘱项ID
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:index, field:'ItmID'}); 	
		var ItmID = $(ed.target).val();
		
		/// 接收科室
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:index, field:'recLocID'}); 	
		var recLocID = $(ed.target).val();
		
		/// 单位ID
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:index, field:'PUomID'}); 	
		var PUomID = $(ed.target).val();
		
		/// 检查库存
		if (GetAvailQtyByArc(ItmID, recLocID, pQty, PUomID) == 0){
			alertMsg("此项目库存不足,请核对库存后重试！");
			return;
		}
		
		/// 价格
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:index, field:'Sprice'}); 	
		var Sprice = $(ed.target).val();
		
		/// 给rowsData赋值用于计算合计金额
		rowsData[index].PackQty=pQty;
		rowsData[index].Sprice=Sprice;
		
		/// 更新合计金额
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:index, field:'ItmTotal'}); 	
		$(ed.target).val(Number(Sprice).mul(pQty));
		
		/// 重新计算金额
		CalCurPagePatPayed();
		//}
	});
	
	/// 价格
	var workRateEditor = editors[6];
	workRateEditor.target.bind('keyup', function(e){  /// keydown - > keyup
			
			/// 数量	
			var ed=$("#dgWriOrdList").datagrid('getEditor',{index:index, field:'PackQty'}); 	
			var pQty = $(ed.target).val();
			
			/// 价格
			var ed=$("#dgWriOrdList").datagrid('getEditor',{index:index, field:'Sprice'}); 	
			var Sprice = $(ed.target).val();
			
			/// 获取所有行内容
			var rowsData = $('#dgWriOrdList').datagrid('getRows');
			var rowData = rowsData[index];
			
			/// 给rowsData赋值用于计算合计金额
			rowsData[index].PackQty=pQty;
			rowsData[index].Sprice=Sprice;
			
			/// 更新合计金额
			var ed=$("#dgWriOrdList").datagrid('getEditor',{index:index, field:'ItmTotal'}); 	
			$(ed.target).val(Number(Sprice).mul(pQty));
			
			/// 重新计算金额
			CalCurPagePatPayed();
	})
}

/// 给当前编辑列赋值
function setCurrArcEditRowCellVal(rowData){
	
	/*
	/// 诊断判断
	if (GetMRDiagnoseCount() == 0){
		$.messager.alert("提示:","病人没有诊断,请先录入！","");
		return;	
	}
	*/
	
	if (rowData == null){
		var editors = $('#dgWriOrdList').datagrid('getEditors', editRow);
		///医嘱项目
		var workRateEditor = editors[6];
		return;
	}
	
	/// 是否存在相同项目
	if (isExistSameItem(rowData.arcitemId)){
		$.messager.confirm('提示','存在相同项目，是否继续添加?', function(b){
			if (!b){
				var editors = $('#dgWriOrdList').datagrid('getEditors', editRow);
				///医嘱项目
				var workRateEditor = editors[6];
				return;	
			}else{
				checkItemSprice(rowData); /// 检查项目价格，是否继续添加
			}
		})
	}else{
		checkItemSprice(rowData);  /// 检查项目价格，是否继续添加
	}
}

/// 检查项目价格，是否继续添加
function checkItemSprice(rowData){
	if (Number(rowData.arcitmprice) == 0){
		/// 处理监听的回车keydown事件，不会同时被confirm默认回车监听到，添加延时，改变执行队列顺序。 lvpeng add 18-2-6
		setTimeout(function(){
			$.messager.confirm('提示','医嘱项目单价为0，是否继续添加?', function(b){
				if (!b){
					var editors = $('#dgWriOrdList').datagrid('getEditors', editRow);
					///医嘱项目
					var workRateEditor = editors[6];
					workRateEditor.target.focus().select();  ///设置焦点 并选中内容
					return;
				}else{
					setCurrEditRowCellVal(rowData);
				}
			});	
		},0)	
	}else{
		setCurrEditRowCellVal(rowData);
	}
}

/// 是否存在相同项目
function isExistSameItem(arcitemId){
	
	var rowsData = $("#dgWriOrdList").datagrid('getRows');
	for (var n=0; n<rowsData.length; n++){
		if (arcitemId == rowsData[n].ItmID){
			return true;
		}
	}
	return false;
}

/// 添加项目列表
function setCurrEditRowCellVal(rowData){
	
	/// 医嘱项ID
	var ItmID=$("#dgWriOrdList").datagrid('getEditor',{index:editRow,field:'ItmID'});
	$(ItmID.target).val(rowData.arcitemId);
	
	/// 医嘱名称
	var ItmDesc=$("#dgWriOrdList").datagrid('getEditor',{index:editRow,field:'ItmDesc'});
	$(ItmDesc.target).val(rowData.arcitmdesc);
  
    /// 接收科室ID
    var LogonDepStr = GetLogonLocByFlag();
    var recLocID=$("#dgWriOrdList").datagrid('getEditor',{index:editRow,field:'recLocID'});
    if((LogonDepStr.split("!")[0]!="")&(LogonDepStr.split("!")[1]!="")){
	   $(recLocID.target).val(LogonDepStr.split("!")[0]);
	}else{
		$(recLocID.target).val(rowData.recLocID);
	}
	
	/// 接收科室
    var ed=$("#dgWriOrdList").datagrid('getEditor',{index:editRow,field:'recLoc'});
    if((LogonDepStr.split("!")[0]!="")&(LogonDepStr.split("!")[1]!="")){
	    $(ed.target).combobox('setValue',LogonDepStr.split("!")[0]); 
	    $(ed.target).combobox('setText',LogonDepStr.split("!")[1]); 
	}else{
		$(ed.target).combobox('setValue', rowData.recLocDesc);
	}
	/// 整包装单位id
	var billuomID=$("#dgWriOrdList").datagrid('getEditor',{index:editRow, field:'PUomID'});
	$(billuomID.target).val(rowData.billuomID);
	
	/// 整包装单位 
	var ed = $('#dgWriOrdList').datagrid('getEditor',{index:editRow, field:'PUomDesc' });
    $(ed.target).combobox('setValue', rowData.billuomDesc);
    
    /// 数量
	var OrderPackQty=$("#dgWriOrdList").datagrid('getEditor',{index:editRow, field:'PackQty'});
	$(OrderPackQty.target).val(rowData.pQty);
	
	/// 费别
	var BillTypeRowid=$("#dgWriOrdList").datagrid('getEditor',{index:editRow, field:'BillTypeID'});
	$(BillTypeRowid.target).val(rowData.BillTypeRowid);
	
	/// 费别
	var BillTypeRowid=$("#dgWriOrdList").datagrid('getEditor',{index:editRow, field:'BillType'});
	$(BillTypeRowid.target).combobox('setValue', rowData.BillType);
	
	/// 价格
	var Price=$("#dgWriOrdList").datagrid('getEditor',{index:editRow, field:'Sprice'});
	$(Price.target).val(rowData.arcitmprice);
	if (rowData.OrderType != "P"){
		$(Price.target).attr("disabled", true);
	}
	
	/// 金额
	var Total=$("#dgWriOrdList").datagrid('getEditor',{index:editRow, field:'ItmTotal'});
	$(Total.target).val(Number(rowData.arcitmprice).mul(rowData.pQty));
	if (rowData.OrderType != "P"){
		$(Total.target).attr("disabled", true);
	}
	
	/// 医嘱优先级ID
	var ed=$("#dgWriOrdList").datagrid('getEditor',{index:editRow, field:'ItmPriorID'});
	$(ed.target).val(rowData.ItmPriorID);

	/// 医嘱类型
	var Price=$("#dgWriOrdList").datagrid('getEditor',{index:editRow, field:'OrderType'});
	$(Price.target).val(rowData.OrderType);
	
	/// 获取所有行内容
	var rowsData = $('#dgWriOrdList').datagrid('getRows');
	/// 给rowsData赋值用于计算合计金额
	rowsData[editRow].PackQty = rowData.pQty;
	rowsData[editRow].Sprice = rowData.arcitmprice;
			
	/// 重新计算金额
	CalCurPagePatPayed();
}

/// 总费用
function CalCurPagePatPayed(){
	
	var total = 0;
	var rowsData = $("#dgWriOrdList").datagrid('getRows');
	if (rowsData != null){
		for(var i=0;i<rowsData.length;i++){
			var spamt = Number(rowsData[i].Sprice).mul(rowsData[i].PackQty);
		    total = Number(total).add(spamt);
		}
	    var htmlStr = "合计金额："+"<span id='mypatpay'>"+total+"</span>"
		$("#allPay").html(htmlStr);
	}
}

// 删除选中行
function deleteRow(){
	
	var rowsData = $("#dgWriOrdList").datagrid('getRows');
	for (var index=rowsData.length-1; index >= 0; index--){

		if ($("tr[datagrid-row-index='"+index+"'] input[name='ItmCheckBox']").is(':checked')){
			if (rowsData[index].ItmOeori == ""){
				/// 删除行
				$("#dgWriOrdList").datagrid('deleteRow',index);
			}else{
				InvStopOrder(rowsData[index].ItmOeori); /// 调用停医嘱接口
			}
		}
	}
	$('#dgPatOrdList').datagrid('reload'); //重新加载

	/// 计算合计金额
	CalCurPagePatPayed();
}

/// 停医嘱调用
function InvStopOrder(Oeori){

	runClassMethod("web.DHCEMNurAddOrder","InvStopOrder",{"Oeori":Oeori, "LgUserID":LgUserID},function(jsonString){
		if(jsonString == 0){
			$('#dgWriOrdList').datagrid('reload'); //重新加载
		}else{
			$.messager.alert("提示","删除失败!"); 
		}
	},'',false);
}


/// 保存行
function saveRow(){
	
	/// 保存前检查
	if (!beforeSaveCheck()) return;

	/// 结束编辑
	var rowsData = $("#dgWriOrdList").datagrid('getRows');

	for(var m=0;m<rowsData.length;m++){
		$("#dgWriOrdList").datagrid('endEdit', m);
	}
	
	var rowsData = $("#dgWriOrdList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	
	var dataList = [],validateData=true;
	for(var i=0;i<rowsData.length;i++){
		
		/// 自定义价格
		var Sprice = "";
		if (rowsData[i].OrderType == "P"){
			Sprice = rowsData[i].Sprice;
		}
		var tmp = rowsData[i].ItmID +"^"+ rowsData[i].OrderType +"^"+ rowsData[i].ItmPriorID +"^^";
			tmp = tmp +"^"+ rowsData[i].PackQty +"^"+ Sprice +"^"+ rowsData[i].recLocID +"^"+ rowsData[i].BillTypeID +"^";
			tmp = tmp +"^^^^^^";
			tmp = tmp +"^^"+ "" +"^^"+ (i+1) +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "";
			tmp = tmp +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ rowsData[i].moeori;
		
		if(rowsData[i].PackQty==0){
			$.messager.alert("提示","第"+(i+1)+"行数量不能为0!");
			validateData=false;
			return false;
		}
		
		dataList.push(tmp);
	}
	
	if(!validateData) return false;
	
	
	
	var mListData=dataList.join("&&");

	if(mListData == ""){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	
	/// 住院急诊留观押金控制
	var PatArrManMsg = GetPatArrManage();
	if (PatArrManMsg != ""){
		$.messager.alert("提示",PatArrManMsg); 
		return;	
	}
	
	//保存数据
	runClassMethod("web.DHCEMNurAddOrder","SaveOrderItems",{"EpisodeID":EpisodeID, "UserID":LgUserID, "LocID":LgLocID, "mListData":mListData},function(jsonString){
		if(jsonString==0){
			$.messager.alert("提示","保存成功!"); 
			$('#dgWriOrdList').datagrid('reload'); //重新加载
			$('#dgPatOrdList').datagrid('reload'); //重新加载
		}else{
			$.messager.alert("提示","保存失败!"); 
		}
	},'',false);
}


/// 检查项目是否允许保存
function beforeSaveCheck(){

	var resFlag = true;
	var rowsData = $("#dgWriOrdList").datagrid('getRows');
	
	/// 最后一个空白行去除
	var ed=$("#dgWriOrdList").datagrid('getEditor',{index:rowsData.length-1, field:'ItmID'}); 	
	var ItmID = $(ed.target).val();
	if(ItmID==""){
		/// 删除行
		$("#dgWriOrdList").datagrid('deleteRow',rowsData.length-1);
	}
	
	
	var rowsData = $("#dgWriOrdList").datagrid('getRows');
	for(var m=0;m<rowsData.length;m++){
		

		if (rowsData[m].ItmOeori != "") continue;
	
		/// 取录入内容	
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:m, field:'PackQty'});
		if (ed == null) continue;	
		var pQty = $(ed.target).val();
		
		/// 医嘱项ID
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:m, field:'ItmID'}); 	
		var ItmID = $(ed.target).val();
		
		/// 医嘱项
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:m, field:'ItmDesc'}); 	
		var ItmDesc = $(ed.target).val();
		
		/// 接收科室
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:m, field:'recLoc'}); 
		var recLoc = $(ed.target).combobox('getValue');
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:m, field:'recLocID'}); 	
		var recLocID = $(ed.target).val();
		if (recLocID == ""){
			$.messager.alert("提示:","医嘱："+ ItmDesc + "接收科室为空,请填写接收科室后重试！");
			resFlag = false;
			break;	
		}
		
		/// 单位ID
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:m, field:'PUomID'}); 	
		var PUomID = $(ed.target).val();

		/// 库存锁定检查
		if (GetStkLockFlag(ItmID, recLocID) == "Y"){
			$.messager.alert("提示:","医嘱："+ ItmDesc + " 已经被"+ recLoc +"锁定，如需要请联系药房工作人员！");
			resFlag = false;
			break;	
		}
		
		/// 检查库存
		if (GetAvailQtyByArc(ItmID, recLocID, pQty, PUomID) == 0){
			$.messager.alert("提示:","医嘱："+ ItmDesc + " 库存不足,请核对库存后重试！");
			resFlag = false;
			break;	
		}
		
		/// 主医嘱是否已经停止
		if (isMoeoriStop(rowsData[m].moeori) != 0){
			$.messager.alert("提示:","医嘱："+ ItmDesc + " 关联主医嘱已经停止,请核实后重试！");
			resFlag = false;
			break;	
		}
	}
	
	return resFlag;
}

/// 主医嘱是否已经停止
function isMoeoriStop(moeori){
	
	var retflag = 0;
	runClassMethod("web.DHCEMNurAddOrder","GetOeoriStat",{"oeori":moeori},function(jsonString){
		if(jsonString != ""){
			if ((jsonString == "D")||(jsonString == "C")){
				retflag = 1;
			}
		}
	},'',false);
	return retflag;
}

///查找按钮
function QryPatOrdList(){ 

    var StartDate="",EndDate="";
    //按日期查询
    var SelDate = $HUI.checkbox("#ByDate").getValue()?"1":"0";     /// 加急
	if (SelDate == 1){
    	StartDate = $HUI.datebox("#StartDate").getValue(); /// 开始日期
    	EndDate =$HUI.datebox("#EndDate").getValue();;     /// 结束日期

		if ((StartDate=="")||(EndDate=="")){
		    $.messager.alert("提示:","请选择开始日期与结束日期");
			return;  
		}
	}
	
	/// 查询病人列表
	$("#dgPatOrdList").datagrid("load",{"EpisodeID":EpisodeID, "StartDate":StartDate,"EndDate":EndDate, "LgLocID":LgLocID, 
		"SelDate":SelDate, "PriorCode":'', "TabType":'', "Moeori":'', "NurOrd":''});
}

/// ========================================= 医嘱模板 ===========================================
/// 加载模板
function LoadTempItem(ObjectType){
	
	/// 加载模板
	$("#itemList tbody").html('');
	var QueryParam = {"LgUserID":LgUserID, "LgGroupID":LgGroupID, "LgLocID":LgLocID, "ObjectType":ObjectType, "HospID":LgHospID, "EpisodeID":EpisodeID};
	runClassMethod("web.DHCEMNurAddOrder","JsonQryOrderTemp",QueryParam,function(jsonString){
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InitCheckItemRegion(jsonObjArr);
		}
	},'json',false)
}

/// 检查方法列表
function InitCheckItemRegion(itemArr){	
	/// 标题行
	var htmlstr = '';

	/// 项目
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		var itmmaststr = itemArr[j-1].eleid;
		if (itmmaststr.indexOf("ARCIM") != "-1"){
			var itmmastArr = itmmaststr.split("^");
			itmmaststr = itmmastArr[2];
		}
		itemhtmlArr.push('<td style="width:33px"  align="center"><input id="'+ itemArr[j-1].id +'" name="ExaItem" type="checkbox" class="checkbox" value="'+ itmmaststr +'"></input></td><td>'+ itemArr[j-1].name +'</td>');
		if (j % 2 == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}

	if ((j-1) % 2 != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:33px"></td><td></td></tr>';
		itemhtmlArr = [];
	}

	$("#itemList tbody").append(htmlstr+itemhtmlstr)
}

/// 加载模板
function LoadTempItemCovDet(ID){
	
	/// 加载模板
	$("#itemList tbody").html('');
	var QueryParam = {"ID":ID, "LgHospID":LgHospID, "EpisodeID":EpisodeID};
	runClassMethod("web.DHCEMNurAddOrder","JsonQryOrderTempCovDet",QueryParam,function(jsonString){
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InitCheckItemRegionCov(jsonObjArr);
		}
	},'json',false)
}

/// 检查方法列表
function InitCheckItemRegionCov(itemArr){	
	/// 标题行
	var htmlstr = '';
		//htmlstr = '<tr style="height:30px"><td colspan="4" class=" tb_td_required" style="border:1px solid #ccc;"></td></tr>';

	/// 项目
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		var itemValue = itemArr[j-1].ItemRowid +"^"+ itemArr[j-1].ItemQty +"^"+ itemArr[j-1].ItemBillUomID +"^"+ itemArr[j-1].ItemBillUOM;
		itemhtmlArr.push('<td style="width:33px"  align="center"><input id="'+ itemArr[j-1].ItemRowid +'" name="ExaItemCov" type="checkbox" class="checkbox" value="'+ itemValue +'"></input></td><td>'+ itemArr[j-1].Item +'</td><td align="center">'+ itemArr[j-1].ItemQty +'</td><td>'+ itemArr[j-1].ItemBillUOM +'</td>');
		if (j % 2 == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}

	if ((j-1) % 2 != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:33px"></td><td></td><td></td><td></td></tr>';
		itemhtmlArr = [];
	}

	$("#itemList tbody").append(htmlstr+itemhtmlstr)
}

/// 加载默认的医嘱套
function LoadTempCovInitObj(){
	
	var initCovObj = {};
	/// 医嘱套名称查询
	var QueryParam = {"LgUserID":LgUserID, "LgLocID":LgLocID, "LgHospID":LgHospID};
	runClassMethod("web.DHCEMNurAddOrder","JsonQryOrderTempCov",QueryParam,function(jsonString){

		if (jsonString != null){
			var jsonObjArr = jsonString;
			initCovObj = jsonObjArr[0];
		}
	},'json',false)
	return initCovObj;
}

/// 加载个人模板
function LoadUserTemp(){
	
	$(".con_div").hide();
	$(".item_div").addClass("item_top");
	$("#itemList th:contains('数量')").hide();
	$("#itemList th:contains('单位')").hide();
	LoadTempItem("User.SSUser"); /// 加载模板
}

/// 加载科室模板
function LoadLocTemp(){
	
	$(".con_div").hide();
	$(".item_div").addClass("item_top");
	$("#itemList th:contains('数量')").hide();
	$("#itemList th:contains('单位')").hide();
	LoadTempItem("User.CTLoc"); /// 加载模板
}

/// 加载医嘱套模板
function LoadTempCov(){
	
	$(".con_div").show();
	$(".item_div").removeClass("item_top");
	$("#itemList th:contains('数量')").show();
	$("#itemList th:contains('单位')").show();
	$("#itemList tbody").html('');
	
	/// 项目包含选择内容时,重新查询
	if (PageFlag == 1){
		var TempCov = $HUI.combobox("#TempCov").getValue();
		if (TempCov != ""){
			LoadTempItemCovDet(TempCov);
		}
	}
}

/// 选中事件
function selectExaItem(){
	
	/// 检查方法【医嘱项ID、医嘱项名称】
	var arcitmid = ""; var tempitmCov = "";
	var itmmaststr = this.value;    /// 项目数据串
	if (itmmaststr == "") return;
	var arcitmdesc = "";
		
	if ($(this).is(':checked')){
		/// 选中调用
		if (this.name == "ExaItemCov"){
			var itmmastArr = itmmaststr.split("^");
			arcitmid = itmmastArr[0];
			tempitmCov = itmmaststr;
		}else{
			if (itmmaststr.indexOf("ARCOS") != "-1"){
				var itmmastArr = itmmaststr.split("^");
				GetOrderTempCov(itmmastArr[2],1);  /// 取医嘱套明细项目
				return;
			}else{
				arcitmid = itmmaststr;
			}
		}
		$(this).attr('checked',false); /// 获取项目后,复选框取消选中状态
		arcitmdesc = $(this).parent().next().text(); /// 检查方法
		InsOrderByTemp(arcitmid, tempitmCov, arcitmdesc);
	}
}

/// 取医嘱套明细项目
function GetOrderTempCov(arccosid, flag){
	
	/// 加载模板
	var QueryParam = {"ID":arccosid, "LgHospID":LgHospID};
	runClassMethod("web.DHCEMNurAddOrder","JsonQryOrderTempCovDet",QueryParam,function(jsonString){
		if ((jsonString != null)&(jsonString !="")){
			var jsonObjArr = jsonString;
			InsItemCovDet(jsonObjArr, flag);
		}else{
			$.messager.alert("提示","医嘱套对应医嘱明细为空,请核实后再试！");
		}
	},'json',false)
}

/// 插入医嘱套明细内容
function InsItemCovDet(itemArr, flag){
	
	/// 项目
	for (var j=1; j<=itemArr.length; j++){
		if (flag == 1){
			var tempitmCov = itemArr[j-1].ItemRowid +"^"+ itemArr[j-1].ItemQty +"^"+ itemArr[j-1].ItemBillUomID +"^"+ itemArr[j-1].ItemBillUOM;
			InsOrderByTemp(itemArr[j-1].ItemRowid, tempitmCov, "");
		}else{
			DelRowByTemp(itemArr[j-1].ItemRowid);
		}
	}
}

/// 全选/全销
function TempCovCKItem(value){
	
	var TempCovCKFlag = false;
	if (value){
		TempCovCKFlag = true;
	}
	//$(this).attr('checked',false);
	
	/// 选中或取消医嘱套对应明细项目
	$("input[name='ExaItemCov']").each(function(){
		$(this).attr('checked',TempCovCKFlag);
		
		/// 检查方法【医嘱项ID、医嘱项名称】
		var arcitmid = ""; var tempitmCov = ""; var arcitmdesc = "";
		var itmmaststr = this.value;    /// 项目数据串
		if (itmmaststr == "") return;
		var itmmastArr = itmmaststr.split("^");
		arcitmid = itmmastArr[0];
		tempitmCov = itmmaststr;
		arcitmdesc = $(this).parent().next().text(); /// 检查方法
		if (TempCovCKFlag == true){
			InsOrderByTemp(arcitmid, tempitmCov, arcitmdesc);
		}else{
			//DelRowByTemp(arcitmid);
		}
		$(this).attr('checked',false);
	})
}

/// tab标签点击事件
function TabsOnSelect(title){
	
	if (title == "个人模板"){
		LoadUserTemp();
	}else if (title == "科室模板"){
		LoadLocTemp();
	}else if (title == "医嘱套"){
		LoadTempCov();
	}
}

/// 点击模板增加
function InsOrderByTemp(arcitemId, tempitmCov, arcitmdesc){
	
	if (TakOrdMsg != ""){
		$.messager.alert("提示:",TakOrdMsg);
		return;	
	}
	
	if (GetDocPermission(arcitemId) == 1){
		$.messager.alert("提示:","您没有权限录入医嘱:"+arcitmdesc);
		return;
	}
	
	runClassMethod("web.DHCEMNurAddOrder","GetArcItemInfoByArcID",{'EpisodeID':EpisodeID, 'arcitemId':arcitemId},function(jsonString){		   		 
   		
   		if(jsonString != null){
	   		var rowData = jsonString;
	   		insertRowData(rowData, tempitmCov); /// 插入数据  bianshuai 2017-03-24
	   	}
	},"json",false)
}

/// 动态删除选择项目
function DelRowByTemp(arcitmid){
	
	var rowsData = $("#dgOrdList").datagrid('getRows');
	for (var index=rowsData.length-1; index >= 0; index--){
		if ((rowsData[index].ItmID == arcitmid)&(rowsData[index].ItmOeori == "")){
			/// 删除行
			$("#dgWriOrdList").datagrid('deleteRow',index);
		}
	}
	/// 计算合计金额
	CalCurPagePatPayed(); 
}

// 插入新行
function insertRowData(rowData, tempitmCov){

	/// 取医嘱套明细内容赋值给添加行
	if (tempitmCov != ""){
		var tempitmCovArr = tempitmCov.split("^");
		rowData.pQty = tempitmCovArr[1];
		rowData.billuomID = tempitmCovArr[2];
		rowData.billuomDesc = tempitmCovArr[3];
	}

	/// 检查库存
	if (GetAvailQtyByArc(rowData.arcitemId, rowData.recLocID, rowData.pQty, rowData.billuomID) == 0){
		$.messager.confirm('提示:','此项目默认接收科室库存不足,是否继续添加?', function(r){
			if (r){
				insertRowCon(rowData);
			}
		})
	}else{
		insertRowCon(rowData);
	}
}

/// 插入行
function insertRowCon(rowData){

	var ItmXuNo = 1;  /// 序号
	var rowsData = $("#dgWriOrdList").datagrid('getRows');
	if (rowsData != null){
		ItmXuNo = rowsData.length + 1;
	}

	/// 获取关联医嘱信息
	var ItmSeqNo = ""; var moeori = "";
	var rowsData = $("#dgPatOrdList").datagrid('getSelected');
	if (rowsData != null){
		ItmSeqNo = rowsData.SeqNo;
		moeori = rowsData.moeori;
	}
	
	/// 金额
	var ItmTotal = (Number(rowData.pQty)*Number(rowData.arcitmprice)).toFixed(2); 
	
	/// 18-6-13 update lp 接收科室走配置取登陆科室 start
	var LogonDepStr = GetLogonLocByFlag();
	var ByTempLocID="",ByTempLocDesc="";
	    
    /// 接收科室ID
    if((LogonDepStr.split("!")[0]!="")&(LogonDepStr.split("!")[1]!="")){
	  	ByTempLocID = LogonDepStr.split("!")[0]; 
	}else{
		ByTempLocID = rowData.recLocID;
	}
	
	/// 接收科室
    if((LogonDepStr.split("!")[0]!="")&(LogonDepStr.split("!")[1]!="")){
	    ByTempLocDesc = LogonDepStr.split("!")[1];
	}else{
		ByTempLocDesc = rowData.recLocDesc;
	}
	
	/// 当前最后一行是否已有数据
	var rowsData = $("#dgWriOrdList").datagrid('getRows');
	var LastEditRow = rowsData.length - 1;
	if(LastEditRow >= 0){
		var ed=$("#dgWriOrdList").datagrid('getEditor',{index:LastEditRow,field:'ItmDesc'});
		if (ed != null){
			if ($(ed.target).val() == "") $("#dgWriOrdList").datagrid('deleteRow', LastEditRow);
		}
	}
	
	$("#dgWriOrdList").datagrid('appendRow',{ //在指定行添加数据，appendRow是在最后一行添加数据
		ItmXuNo:ItmXuNo, ItmSeqNo:'', ItmPriorID:rowData.ItmPriorID, OrderType:rowData.OrderType, ItmID:rowData.arcitemId,
		ItmDesc:rowData.arcitmdesc, Sprice:rowData.arcitmprice, PackQty:rowData.pQty, PUomID:rowData.billuomID, moeori:'', /// moeori, 注释 取消关联 bianshuai 2018-03-19
		PUomDesc:rowData.billuomDesc, recLocID:ByTempLocID, recLoc:ByTempLocDesc, BillTypeID:rowData.BillTypeID, BillType:rowData.BillType, ItmOeori:'', ItmTotal:ItmTotal}
	);
	
	var rowsData = $("#dgWriOrdList").datagrid('getRows');
	if (rowsData != null){
		$("#dgWriOrdList").datagrid('beginEdit', rowsData.length - 1);//开启编辑并传入要编辑的行
		editRow = rowsData.length - 1;
		
		if (rowData.OrderType != "P"){
			/// 单价设置非编辑状态
			var Ed=$("#dgWriOrdList").datagrid('getEditor',{index:editRow, field:'Sprice'});
		    $(Ed.target).attr("disabled", true);
		    /// 总金额设置非编辑状态
		    var Ed=$("#dgWriOrdList").datagrid('getEditor',{index:editRow, field:'ItmTotal'});
		    $(Ed.target).attr("disabled", true);
		}
	
		/// 编辑行绑定事件
		dataGridBindEnterEvent(editRow);
	}
	
	/// 计算合计金额
	CalCurPagePatPayed(); 
}

/// 获取医生录医嘱权限
function GetDocPermission(arcitemId){

	var DocPerFlag = 0;
	/// 调用医生录医嘱权限
	runClassMethod("web.DHCAPPExaReport","GetDocPermission",{"LgGroupID":LgGroupID,"LgUserID":LgUserID,"LgLocID":LgLocID,"EpisodeID":EpisodeID,"arcitemId":arcitemId},function(jsonString){

		if (jsonString == 1){
			DocPerFlag = jsonString;
		}
	},'',false)

	return DocPerFlag;
}

/// 加载默认的医嘱套
function LoadTempCovInitObj(){
	
	var initCovObj = {};
	/// 医嘱套名称查询
	var QueryParam = {"LgUserID":LgUserID, "LgLocID":LgLocID, "LgHospID":LgHospID};
	runClassMethod("web.DHCEMNurAddOrder","JsonQryOrderTempCov",QueryParam,function(jsonString){

		if (jsonString != null){
			var jsonObjArr = jsonString;
			initCovObj = jsonObjArr[0];
		}
	},'json',false)
	return initCovObj;
}


//界面关闭取消锁
window.onbeforeunload = function(){
  	runClassMethod("web.DHCBillLockAdm","UnLockOPAdm",{"admStr":EpisodeID,"lockType":""},  //hxy 2017-03-07 日期格式走配置
	function(retStr){},"text",false);
}

function GetLogonLocByFlag() {
	
    var FindRecLocByLogonLoc;
    //如果按登录科室取接收科室?就把登录科室传进去
    var obj = document.getElementById("FindByLogDep");
    if (obj) {
        if (obj.checked) { FindRecLocByLogonLoc = 1 } else { FindRecLocByLogonLoc = 0 }
    }
    var LogonDep = "",LogonDepDesc="";
    if (FindRecLocByLogonLoc == "1") { 
    	LogonDep = LgCtLocID;
    	LogonDepDesc = LgLocDesc;
     }
    return LogonDep+"!"+LogonDepDesc;
}


/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {
	PageFlag = 1;
}

window.onload = onload_handler;

/// ========================================= 医嘱模板 ===========================================

/// JQuery 初始化页面
$(function(){ initPageDefault(); })