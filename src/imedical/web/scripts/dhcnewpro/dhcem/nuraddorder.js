/// Creator: huaxiaoying
/// CreateDate: 2016-10-11
/// Descript: 护士补录医嘱
var EpisodeID=""; /// 全局变量 迁移页面传参数
var VersionNo=""; /// 页面版本号
var TabType="";   /// 护士执行页签类型
var NurMoeori=""; /// 护士选择主医嘱ID

/// 初始化界面样式设置
function initPageStyle(){
    var myHeight=$(window).height()-389;
    $("#myHeight").css("height",myHeight);
    
    if(getParam("DISPLAY")=="NONE"){ //hxy 2017-03-30 护士执行界面右侧推出该界面
		$("#nuraddorder-title").css("display","none");
		//$("#info").css("display","none");
		$("#left").css("display","none");
		$("#right").css("width","100%");
		$("#myHeight").css("height",$(window).height()-353);
	}
    
    $("#showalert").css("width",$(window).width()+17) //alert宽
    $("#showalert").css("height",$(window).height()) //alert高
    $("#showalertcontent").css("left",($(window).width()-600)/2) //alert left
    $("#showalertcontent").css("top",($(window).height()-260)/2) //alert top
    
    /// 提示框的确认
	$("#yes").click(function(){
		$("#showalert").hide();
		$("#showalertcontent").hide();
	 });
	
	/// 提示框
	$("#alertclose").click(function(){
		$("#showalert").hide();
		$("#showalertcontent").hide();
	 });
	
	/// 隐藏栏
	$("#leftshow").hide();  /// 初始化隐藏this
	changeRightTable();     /// 修改右侧表格全局
	
	$(".template").click(function(){
		Id=$(this).attr("id")
		this.style.color ="#42A5F5";
		this.style.fontWeight='bold';
		$(".template").each(function(){
			if($(this).attr("id")!=Id){
				this.style.color = "#100806";
				this.style.fontWeight='normal';
			}
		})
	});
}

///修改右侧表格全局
function changeRightTable(){
	$(".panel").css("width","100%")
	$(".panel-body-noheader").css("width","100%")
	$(".datagrid-body").css("width","100%")
	$(".datagrid-header").css("width","100%")
	$(".datagrid-view").css("width","100%")
	$(".datagrid-view2").css("width","100%")
	//$.parser.parse($('#dgOrdList').parent());
}

///显示左侧
function leftshow(){
	$("#leftshow").hide();
	$("#left").show();
	$("#right").css("width","60%");
	$.parser.parse($('#dgOrdList'));
    search(); //2017-03-16 初始化左侧超高
}

///隐藏左侧
function lefthide(){
	leftshowHeight=$(window).height()-35
	$("#left").hide();
    $("#leftshow").show();
    $("#leftshow").css("height",leftshowHeight);
    $("#leftshow").css("display","inline");
    $("#right").css("width","98%");
    changeRightTable();
}

///查找按钮
function search(){ 
    var StDate="",EndDate=""
    //按日期查询
    var SelDate =0;
    $("input[type=checkbox][name=SelDate]").each(function(){
		if($(this).is(':checked')){
			SelDate =this.value;	
		}
	})
	if (SelDate==1){
    	StDate=$('#StartDate').getDate(); //开始日期
    	EndDate=$('#EndDate').getDate();  //结束日期

		if ((StDate=="")||(EndDate=="")){
			
			$("#showalert").show();
		    $("#showalertcontent").show();
		    $("#mymessage").html("请选择开始日期与结束日期");
			return;  
		}
	}
	/// 查询病人列表
  	$('#nuraddorderTb').dhccNurQuery({
		query:{
			EpisodeID:EpisodeID, //$('#admId').val(),
			StartDate:$('#StartDate input').val(),
			EndDate:$('#EndDate input').val(),
			LgLocID:LgCtLocID,
			SelDate:SelDate,
			PriorCode:'',
    		TabType:'',
    		Moeori:'',
    		NurOrd:''

			}
	}) 
}

//双击模板增加
function addRowByTemp(arcitemId, tempitmCov){
	
	if (GetDocPermission(arcitemId) == 1){
		$.messager.alert("提示:","您没有权限录入该医嘱！");
		return;
	}
	
	runClassMethod("web.DHCEMNurAddOrder","GetArcItemInfoByArcID",{'EpisodeID':EpisodeID, 'arcitemId':arcitemId},function(jsonString){		   		 
   		
   		if(jsonString != null){
	   		var rowData = jsonString;
	   		insertRowData(rowData, tempitmCov); /// 插入数据  bianshuai 2017-03-24
	   	}
	},"json",false)
}

/// 页面初始化函数
function LoadPageDefault(){
	
    var iframe='<iframe scrolling="yes" width=101% height=305px frameborder="0" src="dhcem.nuraddordertemp.csp?EpisodeID='+EpisodeID+'"></iframe>';
    $("#Cont").html(iframe);
}

///  =================================以下分开各个模块调用==================================
///  bianshuai 2017-01-04
var editRow = "";    /// 当前编辑行号
var ArcColumns = "";
var ComColumns = ""; /// 用法、频次、疗程
var priorCode = "";
var TakOrdMsg = "";  /// 提示消息
var PatType = "";    /// 病人类型
var tempindex = "";
var AvaQtyFlag = 0;  /// 库存标志

/// 页面初始化函数
function initPageDefault(){

	initPageStyle(); 	  /// 初始化界面样式设置
		
	InitPatEpisodeID();   /// 初始化加载病人就诊ID
	GetPatBaseInfo();     /// 加载病人信息
	
	initVersion(); 	      /// 初始化界面版本显示

	initPageDatePicker(); /// 初始化页面日期控件
	initPatOrderList();   /// 初始化病人医嘱列表
	initPageTemp();       /// 初始化页面模板引用
	runClassMethod("web.DHCEMCommonUtil","DateFormat",{},  //hxy 2017-03-07 日期格式走配置
	function(data){
			initItemList(data); 	  /// 页面DataGrid
	});
	//initItemList(); 	  /// 页面DataGrid
	initColumns();        /// 初始化datagrid列
	
	initPatNotTakOrdMsg(); /// 验证病人是否允许开医嘱

	validateIsLock();
	
}
//界面关闭取消锁
window.onbeforeunload = function(){
  	runClassMethod("web.DHCBillLockAdm","UnLockOPAdm",{"admStr":EpisodeID,"lockType":""},  //hxy 2017-03-07 日期格式走配置
	function(retStr){},"text",false);
}

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
	VersionNo = getParam("VersionNo");
	TabType = getParam("TabType");	/// 护士执行页签类型
	NurMoeori = getParam("Moeori"); /// 护士选择主医嘱ID
}

/// 初始化界面版本显示
function initVersion(){
	
	if (VersionNo == 1){
		lefthide();
	}
	priorCode = "NORM";
}

/// 初始化datagrid列
function initColumns(){
	
	ArcColumns = [[
		{field:'arcitemId',hidden:true},
		{field:'arcitmdesc',title:'医嘱名称',width:220},
		{field:'arcitmcode',title:'医嘱代码',width:100},
		{field:'arcitmprice',title:'医嘱价格',width:100},
		{field:'recLocID',title:'科室id',hidden:true},
		{field:'recLocDesc',title:'接收科室',width:120},
	]];
	
	ComColumns = [[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'Desc',title:'描述',width:200},
		{field:'Code',title:'代码',width:100}
	]];
}


///  加载病人信息
function GetPatBaseInfo(){
	
	runClassMethod("web.DHCEMNurAddOrder","GetPatEssInfo",{'EpisodeID':EpisodeID},function(data){

		if (data != null){
	   		var htmlstr = "";
	   		htmlstr = htmlstr + '<span id="PatientID" style="display:none;">' + data.PatientID + '</span>';
	   		htmlstr = htmlstr + '<span id="mradm" style="display:none;">' + data.mradm + '</span>';
	   		htmlstr = htmlstr + '<span id="PatType" style="display:none;">' + data.PatType + '</span>';
			htmlstr = htmlstr + "　登记号:" + data.PatNo + '<span class="patother">|</span>';
			htmlstr = htmlstr + "床号:" + data.PatBed + '<span class="patother">|</span>';
			htmlstr = htmlstr + "姓名:" + data.PatName + '<span class="patother">|</span>';
			htmlstr = htmlstr + "性别:" + data.PatSex + '<span class="patother">|</span>';
			htmlstr = htmlstr + "出生日期：" + data.PatBDay + '<span class="patother">|</span>';
			htmlstr = htmlstr + "年龄:" + data.PatAge + '<span class="patother">|</span>';
			htmlstr = htmlstr + "病案号:" + data.PatMedNo + '<span class="patother">|</span>';
		    htmlstr = htmlstr + "　" + "<b style='color:red;font-size:15px;padding-right:20px;'>" + data.BillType + "</b>";
			$("#info span").html(htmlstr);
			PatType = data.PatType;  /// 病人类型
		}
		
	},"json",false)
}

/// 初始化页面日期控件
function initPageDatePicker(){
	
	/// 结束日期
	$("#EndDate").dhccDate();
	//$("#EndDate").setDate(new Date().Format("yyyy-MM-dd"))	
	/// 开始日期
	$("#StartDate").dhccDate();
	runClassMethod("web.DHCEMCommonUtil","DateFormat",{},  //hxy 2017-03-07 日期格式走配置
				function(data){
					//data=3
					if(data==3){
						$("#EndDate").setDate(new Date().Format("yyyy-MM-dd"))
						$("#StartDate").setDate(new Date().Format("yyyy-MM-dd"))   
				    }else if(data==4){
					    $("#StartDate").setDate(new Date().Format("dd/MM/yyyy"));
					    $("#EndDate").setDate(new Date().Format("dd/MM/yyyy"));	
					}else{
						return;
					}
				});
	//$("#StartDate").setDate(new Date().Format("yyyy-MM-dd"))
}

/// 初始化页面模板引用
function initPageTemp(){
	
	LoadPageDefault(); //初始化,初始加载个人模版
}

/// 初始化病人医嘱列表
function initPatOrderList(){

	var columns = [
		{title:'选择',checkbox:true},
		{field:'arcitmdesc',title:'医嘱名称'},
		{field:'SeqNo',title:'序号',align:'center'},
		{field:'OrderDate',title:'医嘱日期',align:'center'},
		{field:'OrderTime',title:'医嘱时间',align:'center'},
		{field:'OrderDocDesc',title:'下医嘱医生',align:'center'},
		{field:'OrderStartDate',title:'开始日期',align:'center'},
		{field:'OrderStartTime',title:'开始时间',align:'left'},
		{field:'ordPrior',title:'医嘱类型',align:'center'},
		{field:'OrderFreq',title:'频次',align:'center'},
		{field:'OrderInstr',title:'用法',align:'center'},
		{field:'OrderDurt',title:'疗程',align:'center'},
		{field:'OrderDoseQty',title:'剂量',align:'center'},
		{field:'OrderDepProcNote',title:'备注',align:'center'},
		{field:'recLoc',title:'接收科室',align:'center'},
		{field:'arcimid',title:'医嘱项ID'},
		{field:'moeori',title:'moeori'},
		{field:'oeori',title:'oeori'}
		];
		
    $('#nuraddorderTb').dhccTable({
	    formatShowingRows:function(pageFrom, pageTo, totalRows){
		    return "第 "+pageFrom+" 到第 "+pageTo+" 条记录，共 "+totalRows+" 条记录"
		},
	    formatRecordsPerPage:function(pageNumber){return ''},
	    height:$(window).height()-121, //202, //-122,2017-03-16
	    singleSelect: false,
	    clickToSelect:false,
	    //pageSize:11,
	    //pageList:[50,100],
        url: 'dhcapp.broker.csp?ClassName=web.DHCEMNurAddOrder&MethodName=QueryPatOrderItems',
        columns: columns,
        queryParam:{
			EpisodeID:EpisodeID,
    		StartDate:'',
    		EndDate:'',
    		PriorCode:'',
    		TabType:TabType,
    		Moeori:NurMoeori,
    		NurOrd:'',
    		LgLocID:LgCtLocID,
    		SelDate:0
		},
		onCheck:function(row, $element){
			var curIndex=$element.attr("data-index");
			if (tempindex != ""){
				return;
			}else{
				tempindex = curIndex;
			}
			CheckLinkOrd(curIndex, row,0);
		},
		onUncheck:function(row, $element){
			/// 当前行索引
			var curIndex=$element.attr("data-index");
			if (tempindex != ""){
				return;
			}else{
				tempindex = curIndex;
			}
			CheckLinkOrd(curIndex, row,1);
		},
		onClickRow:function(row, $element){
			/// 当前行索引
			var curIndex=$element.attr("data-index");
			var flag = 0;
			/// 点击行是选中/取消
			if ($element.hasClass("selected")){
				flag = 1;
				$('#nuraddorderTb').dhccTableM('uncheck',curIndex);
			}else{
				$('#nuraddorderTb').dhccTableM('check',curIndex);
			}
			tempindex = curIndex;
			CheckLinkOrd(curIndex, row, flag);
		}
    })
}

/// 单击选中关联
function CheckLinkOrd(rowIndex, rowData,check){
	
	var rowsData = $("#nuraddorderTb").dhccTableM('getData');
	for(var m=0;m<rowsData.length;m++){

		if(m==rowIndex){
			continue;
		}
		if (rowData.moeori == rowsData[m].moeori){
			var selects= $("#nuraddorderTb").dhccTableM('getSelections');
			var selectFlag=0;
			for(j=0;j<selects.length;j++){
				if(selects[j].oeori==rowsData[m].oeori){selectFlag=1}
			}
			if(check==1){
				if (selectFlag == 1){
					$('#nuraddorderTb').dhccTableM('uncheck',m);
				}
			}else{
				if (selectFlag == 0){
					$('#nuraddorderTb').dhccTableM('check',m);
					moeori = rowsData[m].moeori;
				}
			}
		}else{
			if(check==0){
				$('#nuraddorderTb').dhccTableM('uncheck',m);
			}
		}
	}
	//if (check == 0){
		tempindex = "";
	//}
}

/// 给项目datagrid绑定点击事件
function dataGridBindEnterEvent(index){

	var editors = $('#dgOrdList').datagrid('getEditors', index);
	for(var i=0; i< editors.length; i++){
		var workRateEditor = editors[i];
		if (!workRateEditor.target.next('span').has('input').length){
			workRateEditor.target.bind('click', function(e){
				$('#dgOrdList').datagrid('selectRow',index);
			});
		}else{
			workRateEditor.target.next('span').find('input').bind('click', function(e){
				$('#dgOrdList').datagrid('selectRow',index);
			});
		}
	}

	var editors = $('#dgOrdList').datagrid('getEditors', index);
	/// 检查项目名称
	var workRateEditor = editors[2];
	workRateEditor.target.focus();  ///设置焦点
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var tr = $(this).closest("tr.datagrid-row");
			editRow = tr.attr("datagrid-row-index");
			var ed=$("#dgOrdList").datagrid('getEditor',{index:editRow, field:'ItmDesc'});		
			var EntryAlias = $(ed.target).val();
			if (EntryAlias == ""){return;}
			var unitUrl = 'dhcapp.broker.csp?ClassName=web.DHCEMNurAddOrder&MethodName=JsonQryArcNurAddOrder&EpisodeID='+EpisodeID+'&LgGroupID='+LgGroupID+'&LgUserID='+LgUserID+'&LgLocID='+LgCtLocID+'&EntryAlias='+EntryAlias;
			/// 调用医嘱项列表窗口
			new ListComponentWin($(ed.target), EntryAlias, "600px", "" , unitUrl, ArcColumns, setCurrArcEditRowCellVal).init();
		}
	});
	
	/// 数量
	var workRateEditor = editors[3];
	workRateEditor.target.bind('keyup', function(e){  /// keydown - > keyup
		
		//if (e.keyCode == 13) {
			
			/// 取录入内容	
			var ed=$("#dgOrdList").datagrid('getEditor',{index:index, field:'PackQty'}); 	
			var pQty = $(ed.target).val();
			
			/// 获取所有行内容
			var rowsData = $('#dgOrdList').datagrid('getRows');
			var rowData = rowsData[index];
			
			/// 医嘱项ID
			var ed=$("#dgOrdList").datagrid('getEditor',{index:index, field:'ItmID'}); 	
			var ItmID = $(ed.target).val();
			
			/// 接收科室
			var ed=$("#dgOrdList").datagrid('getEditor',{index:index, field:'recLocID'}); 	
			var recLocID = $(ed.target).val();
			
			/// 单位ID
			var ed=$("#dgOrdList").datagrid('getEditor',{index:index, field:'PUomID'}); 	
			var PUomID = $(ed.target).val();
			
			/// 检查库存
			if (GetAvailQtyByArc(ItmID, recLocID, pQty, PUomID) == 0){
				alertMsg("此项目库存不足,请核对库存后重试！");
				return;
			}
			
			/// 价格
			var ed=$("#dgOrdList").datagrid('getEditor',{index:index, field:'Sprice'}); 	
			var Sprice = $(ed.target).val();
			
			/// 给rowsData赋值用于计算合计金额
			rowsData[index].PackQty=pQty;
			rowsData[index].Sprice=Sprice;
			
			/// 更新合计金额
			var ed=$("#dgOrdList").datagrid('getEditor',{index:index, field:'ItmTotal'}); 	
			$(ed.target).val(Number(Sprice).mul(pQty));
			
			/// 重新计算金额
			CalCurPagePatPayed();
		//}
	});
	
	/// 价格
	var workRateEditor = editors[6];
	workRateEditor.target.bind('keyup', function(e){  /// keydown - > keyup
			
			/// 数量	
			var ed=$("#dgOrdList").datagrid('getEditor',{index:index, field:'PackQty'}); 	
			var pQty = $(ed.target).val();
			
			/// 价格
			var ed=$("#dgOrdList").datagrid('getEditor',{index:index, field:'Sprice'}); 	
			var Sprice = $(ed.target).val();
			
			/// 获取所有行内容
			var rowsData = $('#dgOrdList').datagrid('getRows');
			var rowData = rowsData[index];
			
			/// 给rowsData赋值用于计算合计金额
			rowsData[index].PackQty=pQty;
			rowsData[index].Sprice=Sprice;
			
			/// 更新合计金额
			var ed=$("#dgOrdList").datagrid('getEditor',{index:index, field:'ItmTotal'}); 	
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
		var editors = $('#dgOrdList').datagrid('getEditors', editRow);
		///医嘱项目
		var workRateEditor = editors[6];
		return;
	}
	
	/// 是否存在相同项目
	if (isExistSameItem(rowData.arcitemId)){
		$.messager.confirm('提示','存在相同项目，是否继续添加?', function(b){
			if (!b){
				var editors = $('#dgOrdList').datagrid('getEditors', editRow);
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
					var editors = $('#dgOrdList').datagrid('getEditors', editRow);
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
	
	var rowsData = $("#dgOrdList").datagrid('getRows');
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
	var ItmID=$("#dgOrdList").datagrid('getEditor',{index:editRow,field:'ItmID'});
	$(ItmID.target).val(rowData.arcitemId);
	
	/// 医嘱名称
	var ItmDesc=$("#dgOrdList").datagrid('getEditor',{index:editRow,field:'ItmDesc'});
	$(ItmDesc.target).val(rowData.arcitmdesc);
	    
    /// 接收科室ID
    var recLocID=$("#dgOrdList").datagrid('getEditor',{index:editRow,field:'recLocID'});
	$(recLocID.target).val(rowData.recLocID);
	
	/// 接收科室
    var ed=$("#dgOrdList").datagrid('getEditor',{index:editRow,field:'recLoc'});
	$(ed.target).combobox('setValue', rowData.recLocDesc);
	
	/// 整包装单位id
	var billuomID=$("#dgOrdList").datagrid('getEditor',{index:editRow, field:'PUomID'});
	$(billuomID.target).val(rowData.billuomID);
	
	/// 整包装单位 
	var ed = $('#dgOrdList').datagrid('getEditor',{index:editRow, field:'PUomDesc' });
    $(ed.target).combobox('setValue', rowData.billuomDesc);
    
    /// 数量
	var OrderPackQty=$("#dgOrdList").datagrid('getEditor',{index:editRow, field:'PackQty'});
	$(OrderPackQty.target).val(rowData.pQty);
	
	/// 费别
	var BillTypeRowid=$("#dgOrdList").datagrid('getEditor',{index:editRow, field:'BillTypeID'});
	$(BillTypeRowid.target).val(rowData.BillTypeRowid);
	
	/// 费别
	var BillTypeRowid=$("#dgOrdList").datagrid('getEditor',{index:editRow, field:'BillType'});
	$(BillTypeRowid.target).combobox('setValue', rowData.BillType);
	
	/// 价格
	var Price=$("#dgOrdList").datagrid('getEditor',{index:editRow, field:'Sprice'});
	$(Price.target).val(rowData.arcitmprice);
	if (rowData.OrderType != "P"){
		$(Price.target).attr("disabled", true);
	}
	
	/// 金额
	var Total=$("#dgOrdList").datagrid('getEditor',{index:editRow, field:'ItmTotal'});
	$(Total.target).val(Number(rowData.arcitmprice).mul(rowData.pQty));
	if (rowData.OrderType != "P"){
		$(Total.target).attr("disabled", true);
	}
	
	/// 医嘱优先级ID
	var ed=$("#dgOrdList").datagrid('getEditor',{index:editRow, field:'ItmPriorID'});
	$(ed.target).val(rowData.ItmPriorID);

	/// 医嘱类型
	var Price=$("#dgOrdList").datagrid('getEditor',{index:editRow, field:'OrderType'});
	$(Price.target).val(rowData.OrderType);
	
	/// 获取所有行内容
	var rowsData = $('#dgOrdList').datagrid('getRows');
	/// 给rowsData赋值用于计算合计金额
	rowsData[editRow].PackQty = rowData.pQty;
	rowsData[editRow].Sprice = rowData.arcitmprice;
			
	/// 重新计算金额
	CalCurPagePatPayed();
}

/// 页面DataGrid
function initItemList(recdata){

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
				var ed=$("#dgOrdList").datagrid('getEditor',{index:modRowIndex,field:'PUomID'});
				$(ed.target).val(option.value);
				var ed=$("#dgOrdList").datagrid('getEditor',{index:modRowIndex,field:'PUomDesc'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed = $("#dgOrdList").datagrid('getEditor', { index: modRowIndex, field: 'ItmID'});
				var arcitemId = $(ed.target).val();
				if(arcitemId != ""){
					var ed = $("#dgOrdList").datagrid('getEditor', { index: modRowIndex, field: 'PUomDesc'});
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
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				///设置类型值
				var ed=$("#dgOrdList").datagrid('getEditor',{index:modRowIndex,field:'recLocID'});
				$(ed.target).val(option.value);
				var ed=$("#dgOrdList").datagrid('getEditor',{index:modRowIndex,field:'recLoc'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed = $("#dgOrdList").datagrid('getEditor', { index: modRowIndex, field: 'ItmID'});
				var arcitemId = $(ed.target).val();
				if(arcitemId != ""){
					var ed = $("#dgOrdList").datagrid('getEditor', { index: modRowIndex, field: 'recLoc'});
					$(ed.target).combobox('reload','dhcapp.broker.csp?ClassName=web.DHCEMNurAddOrder&MethodName=jsonExaCatRecLocNew&EpisodeID='+EpisodeID+'&ItmmastID='+arcitemId);
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
				var ed=$("#dgOrdList").datagrid('getEditor',{index:modRowIndex,field:'BillTypeID'});
				$(ed.target).val(option.value);
				var ed=$("#dgOrdList").datagrid('getEditor',{index:modRowIndex,field:'BillType'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed = $("#dgOrdList").datagrid('getEditor', { index: modRowIndex, field: 'BillType'});
				$(ed.target).combobox('reload','dhcapp.broker.csp?ClassName=web.DHCEMNurAddOrder&MethodName=jsonGetPatBillType&PatType=E&EpisodeID='+EpisodeID);
			}
		}
	}
						
	///  定义columns
	var columns=[[
		{field:'Select',title:'选择',width:40,align:'center',formatter:SetCellCheckBox},
		//{field:'ItmXuNo',title:'序号',width:35,align:'center'},
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
		title : '医嘱列表' + '<span id="allPay" style="float:right">合计金额：0.00</span>',
		border : false,
		rownumbers : true,
		singleSelect : true,
		pagination: false,
		checkOnSelect:true,
		selectOnCheck:true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    	/*
	    	/// 已经审核的医嘱不允许再次编辑
	    	if (rowData.ItmOeori != "") return;
	    	
            if (editRow != ""||editRow == 0) { 
                $("#dgOrdList").datagrid('endEdit', editRow); 
            }
            $("#dgOrdList").datagrid('beginEdit', rowIndex); 
                
            editRow = rowIndex;
            */
        },
		onLoadSuccess:function(data){
			CalCurPagePatPayed(); /// 计算总费用
		}
	};

	var params = "rows=50&page=1&EpisodeID="+EpisodeID+"&StartDate=&EndDate=&LgLocID="+LgCtLocID;
	var uniturl = "dhcapp.broker.csp?ClassName=web.DHCEMNurAddOrder&MethodName=QueryPatOrderItmsByLoc&"+params;
	new ListComponent('dgOrdList', columns, uniturl, option).Init();
}

/// 复选框
function SetCellCheckBox(value, rowData, rowIndex){

	var html = '<input name="ItmCheckBox" type="checkbox" value='+rowIndex+'></input>';
    return html;
}

// 插入新行
function insertRow(){

	/// 当前最后一行是否已有数据
	var rowsData = $("#dgOrdList").datagrid('getRows');
	var LastEditRow = rowsData.length - 1;
	if(LastEditRow >= 0){
		var ed=$("#dgOrdList").datagrid('getEditor',{index:LastEditRow,field:'ItmDesc'});
		if (ed != null){
			if ($(ed.target).val() == "") return;
		}
	}

	var ItmXuNo = 1;  /// 序号
	var rowsData = $("#dgOrdList").datagrid('getRows');
	if (rowsData != null){
		ItmXuNo = rowsData.length + 1;
	}
	
	/// 获取关联医嘱信息
	var ItmSeqNo = ""; var moeori = "";
	var selects= $("#nuraddorderTb").dhccTableM('getSelections');
	if (selects.length > 0){
		ItmSeqNo = selects[0].SeqNo;
		moeori = selects[0].moeori;
	}

	$("#dgOrdList").datagrid('appendRow',{ //在指定行添加数据，appendRow是在最后一行添加数据
		ItmXuNo:ItmXuNo, ItmSeqNo:'', ItmPriorID:'', OrderType:'', ItmID:'',
		ItmDesc:'', Sprice:'', PackQty:'', PUomID:'', moeori:'',  ///moeori, 注释 取消关联 bianshuai 2018-03-19
		PUomDesc:'', recLocID:'', recLoc:'', BillTypeID:'', BillType:'', ItmOeori:'', ItmTotal:''}
	);

	var rowsData = $("#dgOrdList").datagrid('getRows');
	if (rowsData != null){
		$("#dgOrdList").datagrid('beginEdit', rowsData.length - 1);//开启编辑并传入要编辑的行
		editRow = rowsData.length - 1;

		//$('#dgOrdList').datagrid('selectRow',editRow);
	
		/// 编辑行绑定事件
		dataGridBindEnterEvent(editRow);
	}
}

// 删除选中行
function deleteRow(){
	
	var rowsData = $("#dgOrdList").datagrid('getRows');
	for (var index=rowsData.length-1; index >= 0; index--){
		//if ($("[name='ItmCheckBox'][value='"+ index+"']").is(':checked')){
		if ($("tr[datagrid-row-index='"+index+"'] input[name='ItmCheckBox']").is(':checked')){
			if (rowsData[index].ItmOeori == ""){
				/// 删除行
				$("#dgOrdList").datagrid('deleteRow',index);
			}else{
				InvStopOrder(rowsData[index].ItmOeori); /// 调用停医嘱接口
			}
		}
	}
	/*
	/// 刷新列表数据
	var selItems=$("#dgOrdList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		$('#dgOrdList').datagrid('refreshRow', index);
		/// 开启编辑并传入要编辑的行
		//$("#dgOrdList").datagrid('beginEdit', index);
		/// 编辑行绑定事件
		//dataGridBindEnterEvent(index);
	})
	*/
	/// 计算合计金额
	CalCurPagePatPayed();
}

/// 停医嘱调用
function InvStopOrder(Oeori){

	runClassMethod("web.DHCEMNurAddOrder","InvStopOrder",{"Oeori":Oeori, "LgUserID":LgUserID},function(jsonString){
		if(jsonString == 0){
			$('#dgOrdList').datagrid('reload'); //重新加载
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
	var rowsData = $("#dgOrdList").datagrid('getRows');
	for(var m=0;m<rowsData.length;m++){
		$("#dgOrdList").datagrid('endEdit', m);
	}
	
	var rowsData = $("#dgOrdList").datagrid('getChanges');
	if(rowsData.length<=0){
		$("#showalert").show();
		$("#showalertcontent").show();
		$("#mymessage").html("没有待保存数据!");
		return;
	}

	var dataList = [];

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
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("&&");

	if(mListData == ""){
		$("#showalert").show();
		$("#showalertcontent").show();
		$("#mymessage").html("没有待保存数据!");
		return;
	}
	
	/// 住院急诊留观押金控制
	var PatArrManMsg = GetPatArrManage();
	if (PatArrManMsg != ""){
		$("#showalert").show();
		$("#showalertcontent").show();
		$("#mymessage").html(PatArrManMsg);
		return;	
	}
	
	//保存数据
	runClassMethod("web.DHCEMNurAddOrder","SaveOrderItems",{"EpisodeID":EpisodeID, "UserID":LgUserID, "LocID":LgCtLocID, "mListData":mListData},function(jsonString){
		if(jsonString==0){
			$.messager.alert("提示","保存成功!"); 
			$('#dgOrdList').datagrid('reload'); //重新加载
		}else{
			$.messager.alert("提示","保存失败!"); 
		}
	});
}

/// 总费用
function CalCurPagePatPayed(){
	
	var total = 0;
	var rowsData = $("#dgOrdList").datagrid('getRows');
	if (rowsData != null){
		for(var i=0;i<rowsData.length;i++){
			var spamt = Number(rowsData[i].Sprice).mul(rowsData[i].PackQty);
		    total = Number(total).add(spamt);
		}
	    var htmlStr = "合计金额："+"<span id='mypatpay'>"+total+"</span>"
		$("#allPay").html(htmlStr);
	}
}

/// 复制医嘱
function copyRow(){

	/// 选中医嘱
	var rowsData = $('#nuraddorderTb').bootstrapTable('getSelections');
	for (var m=0; m < rowsData.length; m++ ){
		if (rowsData[m].arcimid != ""){
			if (GetDocPermission(rowsData[m].arcimid) == 1){
				$.messager.alert("提示:","您没有权限录入该医嘱！");
				continue;
			}
	 		insertCopyRow(rowsData[m].oeori);
		}
	}
}

/// 获取医生录医嘱权限
function GetDocPermission(arcitemId){

	var DocPerFlag = 0;
	/// 调用医生录医嘱权限
	runClassMethod("web.DHCAPPExaReport","GetDocPermission",{"LgGroupID":LgGroupID,"LgUserID":LgUserID,"LgLocID":LgCtLocID,"EpisodeID":EpisodeID,"arcitemId":arcitemId},function(jsonString){

		if (jsonString == 1){
			DocPerFlag = jsonString;
		}
	},'',false)

	return DocPerFlag;
}

/// 插入复制行
function insertCopyRow(oeori){

	runClassMethod("web.DHCEMNurAddOrder","GetPatOeoriInfo",{'EpisodeID':EpisodeID, 'oeori':oeori},function(jsonString){		   		 
   		
   		if(jsonString != null){
	   		var rowData = jsonString;
	   		insertRow();					   /// 增加空行 bianshuai 2017-01-06
	   		setCurrArcEditRowCellVal(rowData); /// 调用统一填充数据函数 bianshuai 2017-01-06
	   	}
	},"json")
}

/// 关联医嘱
function linkRow(){
	
	var rowsData = $('#nuraddorderTb').bootstrapTable('getSelections');
	if (rowsData == null){
		$.messager.alert("提示","请先选择关联医嘱!"); 
		return;
	}

	var moeori = rowsData[0].moeori;
	var rowsData = $("#dgOrdList").datagrid('getRows');
	for (var index=0; index < rowsData.length; index++){
		if ($("[name='ItmCheckBox'][value='"+ index+"']").is(':checked')){
			if (rowsData[index].ItmOeori == ""){
				/// 删除行
				rowsData[index].moeori = moeori;
			}
		}
	}
	$.messager.alert("提示","关联成功!"); 
	return;
}

/// 获取病人的诊断记录数
function GetMRDiagnoseCount(){

	var Count = 0;
	/// 调用医生站的判断
	runClassMethod("web.DHCAPPExaReport","GetMRDCount",{"EpisodeID":EpisodeID},function(jsonString){
		
		if (jsonString != ""){
			Count = jsonString;
		}
	},'',false)

	return Count;
}

/// 弹出诊断窗口
function DiagPopWin(){
	
	var PatientID = $("#PatientID").text();  /// 病人ID
	var mradm = $("#mradm").text();			 /// 就诊诊断ID

	var lnk = "diagnosentry.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm;
	//window.open(lnk,"_blank","top=100,left=100,width=700,height=350,menubar=yes,scrollbars=no,toolbar=no,status=no");
	window.showModalDialog(lnk, "_blank", "dialogHeight: " + (top.screen.height - 100) + "px; dialogWidth: " + (top.screen.width - 100) + "px");
}

/// 验证病人是否允许开医嘱
function initPatNotTakOrdMsg(){
	
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
	runClassMethod("web.DHCAPPExaReport","GetPatNotTakOrdMsg",{"LgGroupID":LgGroupID,"LgUserID":LgUserID,"LgLocID":LgCtLocID,"EpisodeID":EpisodeID},function(jsonString){

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
	runClassMethod("web.DHCAPPExaReport","GetArrearsManage",{"EpisodeID":EpisodeID,"LgGroupID":LgGroupID,"LgLocID":LgCtLocID,"amount":amount},function(jsonString){

		if (jsonString != ""){
			PatArrManMsg = jsonString;
		}
	},'',false)

	return PatArrManMsg;
}

/// 重新计算数量
function CalPackQty(index){
	
	var editors = $('#dgOrdList').datagrid('getEditors', index);
	if (editors != null){
		var dosQty = 0;    /// 剂量
		var uomID = $(editors[8].target).val();     /// 单位
		var freqID = $(editors[10].target).val();   /// 频次
		var DurID = $(editors[14].target).val();    /// 疗程
		var PUomID = $(editors[18].target).val();   /// 整包装单位
		var ListData = dosQty +"^"+ uomID +"^"+ freqID +"^"+ DurID +"^"+ PUomID;
		runClassMethod("web.DHCEMNurAddOrder","GetPackQty",{"ListData":ListData},function(resValue){
			if (resValue != ""){
				$(editors[17].target).val(resValue);
			}
		},'',false)
	}
}

/// 取His日期维护显示格式 bianshuai 2017-03-10
function GetSysDateToHtml(HtDate){

	runClassMethod("web.DHCAPPExaRepCom","GetSysDateToHtml",{"HtDate":HtDate},function(jsonString){
		HtDate = jsonString;
	},'',false)
	return HtDate;
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
	/*
	/// 金额
	var ItmTotal = (Number(rowData.pQty)*Number(rowData.arcitmprice)).toFixed(2); 
	
	$("#dgOrdList").datagrid('appendRow',{ //在指定行添加数据，appendRow是在最后一行添加数据
		ItmXuNo:ItmXuNo, ItmSeqNo:ItmSeqNo, ItmPriorID:rowData.ItmPriorID, OrderType:rowData.OrderType, ItmID:rowData.arcitemId,
		ItmDesc:rowData.arcitmdesc, Sprice:rowData.arcitmprice, PackQty:rowData.pQty, PUomID:rowData.billuomID, moeori:moeori,
		PUomDesc:rowData.billuomDesc, recLocID:rowData.recLocID, recLoc:rowData.recLocDesc, BillTypeID:rowData.BillTypeID, BillType:rowData.BillType, ItmOeori:'', ItmTotal:ItmTotal}
	);
	
	var rowsData = $("#dgOrdList").datagrid('getRows');
	if (rowsData != null){
		$("#dgOrdList").datagrid('beginEdit', rowsData.length - 1);//开启编辑并传入要编辑的行
		editRow = rowsData.length - 1;
	
		/// 编辑行绑定事件
		dataGridBindEnterEvent(editRow);
	}
	
	/// 计算合计金额
	CalCurPagePatPayed(); 
	*/
}

/// 插入行
function insertRowCon(rowData){

	var ItmXuNo = 1;  /// 序号
	var rowsData = $("#dgOrdList").datagrid('getRows');
	if (rowsData != null){
		ItmXuNo = rowsData.length + 1;
	}

	/// 获取关联医嘱信息
	var ItmSeqNo = ""; var moeori = "";
	var selects= $("#nuraddorderTb").dhccTableM('getSelections');
	if (selects.length > 0){
		ItmSeqNo = selects[0].SeqNo;
		moeori = selects[0].moeori;
	}
	
	/// 金额
	var ItmTotal = (Number(rowData.pQty)*Number(rowData.arcitmprice)).toFixed(2); 
	
	$("#dgOrdList").datagrid('appendRow',{ //在指定行添加数据，appendRow是在最后一行添加数据
		ItmXuNo:ItmXuNo, ItmSeqNo:'', ItmPriorID:rowData.ItmPriorID, OrderType:rowData.OrderType, ItmID:rowData.arcitemId,
		ItmDesc:rowData.arcitmdesc, Sprice:rowData.arcitmprice, PackQty:rowData.pQty, PUomID:rowData.billuomID, moeori:'', /// moeori, 注释 取消关联 bianshuai 2018-03-19
		PUomDesc:rowData.billuomDesc, recLocID:rowData.recLocID, recLoc:rowData.recLocDesc, BillTypeID:rowData.BillTypeID, BillType:rowData.BillType, ItmOeori:'', ItmTotal:ItmTotal}
	);
	
	var rowsData = $("#dgOrdList").datagrid('getRows');
	if (rowsData != null){
		$("#dgOrdList").datagrid('beginEdit', rowsData.length - 1);//开启编辑并传入要编辑的行
		editRow = rowsData.length - 1;
		
		if (rowData.OrderType != "P"){
			/// 单价设置非编辑状态
			var Ed=$("#dgOrdList").datagrid('getEditor',{index:editRow, field:'Sprice'});
		    $(Ed.target).attr("disabled", true);
		    /// 总金额设置非编辑状态
		    var Ed=$("#dgOrdList").datagrid('getEditor',{index:editRow, field:'ItmTotal'});
		    $(Ed.target).attr("disabled", true);
		}
	
		/// 编辑行绑定事件
		dataGridBindEnterEvent(editRow);
	}
	
	/// 计算合计金额
	CalCurPagePatPayed(); 
}

/// 动态删除选择项目
function delRowByTemp(arcitmid){
	
	var rowsData = $("#dgOrdList").datagrid('getRows');
	for (var index=rowsData.length-1; index >= 0; index--){
		if ((rowsData[index].ItmID == arcitmid)&(rowsData[index].ItmOeori == "")){
			/// 删除行
			$("#dgOrdList").datagrid('deleteRow',index);
		}
	}
	/// 计算合计金额
	CalCurPagePatPayed(); 
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

/// 检查项目是否允许保存
function beforeSaveCheck(){
	
	var resFlag = true;
	var rowsData = $("#dgOrdList").datagrid('getRows');
	for(var m=0;m<rowsData.length;m++){
		if (rowsData[m].ItmOeori != "") continue;
		
		/// 取录入内容	
		var ed=$("#dgOrdList").datagrid('getEditor',{index:m, field:'PackQty'}); 	
		var pQty = $(ed.target).val();
		
		/// 医嘱项ID
		var ed=$("#dgOrdList").datagrid('getEditor',{index:m, field:'ItmID'}); 	
		var ItmID = $(ed.target).val();
		
		/// 医嘱项
		var ed=$("#dgOrdList").datagrid('getEditor',{index:m, field:'ItmDesc'}); 	
		var ItmDesc = $(ed.target).val();
		
		/// 接收科室
		var ed=$("#dgOrdList").datagrid('getEditor',{index:m, field:'recLoc'}); 
		var recLoc = $(ed.target).combobox('getValue');
		var ed=$("#dgOrdList").datagrid('getEditor',{index:m, field:'recLocID'}); 	
		var recLocID = $(ed.target).val();
		if (recLocID == ""){
			alertMsg("医嘱："+ ItmDesc + "接收科室为空,请填写接收科室后重试！");
			resFlag = false;
			break;	
		}
		
		/// 单位ID
		var ed=$("#dgOrdList").datagrid('getEditor',{index:m, field:'PUomID'}); 	
		var PUomID = $(ed.target).val();

		/// 库存锁定检查
		if (GetStkLockFlag(ItmID, recLocID) == "Y"){
			alertMsg("医嘱："+ ItmDesc + " 已经被"+ recLoc +"锁定，如需要请联系药房工作人员！");
			resFlag = false;
			break;	
		}
		
		/// 检查库存
		if (GetAvailQtyByArc(ItmID, recLocID, pQty, PUomID) == 0){
			alertMsg("医嘱："+ ItmDesc + " 库存不足,请核对库存后重试！");
			resFlag = false;
			break;	
		}
		
		/// 主医嘱是否已经停止
		if (isMoeoriStop(rowsData[m].moeori) != 0){
			alertMsg("医嘱："+ ItmDesc + " 关联主医嘱已经停止,请核实后重试！");
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

//判断是否已审核医嘱 (存在OrderItemRowid)
function CheckIsItem(rowid){
	var id=parseInt(rowid);
	if($.isNumeric(id)==true){
		var OrderItemRowid=id.ItmOeori
		if(OrderItemRowid != ""){
			return true;
		}else{
			return false;
		}
	}else{
		return false;
	}
}
/// 页面alert样式，不引用公共alert,有子界面调用
function alertMsg(msg){
	$("#showalert").show();
	$("#showalertcontent").show();
	$("#mymessage").html(msg);
}

$.fn.dhccNurQuery=function(_options){
	$(this).bootstrapTable('refresh',_options);
	$(this).bootstrapTable('getOptions').queryParams=function(params){
		   	tmp={
				limit: params.limit,   //页面大小  
  				offset: params.offset,  //
  				page:params.pageNumber
		   	}
		   	
		   	if(_options){
			   	try{
				   	if(_options.hasOwnProperty('query')){
					   	tmp=$.extend(tmp,_options.query)
					}
			   	}catch(e){}
		   	}
		   	return tmp;  
	}
	try{
		$(this).bootstrapTable('refreshOptions',{pageNumber:1,pageSize:15});
	}catch(e){}
}
	
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
